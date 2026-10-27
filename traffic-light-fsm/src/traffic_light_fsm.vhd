library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light_fsm is
    Generic (
        CLK_FREQ_HZ : integer := 100_000_000 -- Default 100 MHz clock for Artix-7 (e.g., Basys 3 / Nexys A7)
    );
    Port (
        clk         : in  std_logic;
        reset_n     : in  std_logic;                    -- Active-low synchronous reset
        sensor_ew   : in  std_logic;                    -- High if vehicle/pedestrian waiting on EW
        emergency   : in  std_logic;                    -- Force all directions Red
        lights_ns   : out std_logic_vector(2 downto 0); -- [Red, Yellow, Green]
        lights_ew   : out std_logic_vector(2 downto 0)  -- [Red, Yellow, Green]
    );
end entity traffic_light_fsm;

architecture Behavioral of traffic_light_fsm is

    type state_type is (S_NS_GREEN, S_NS_YELLOW, S_EW_GREEN, S_EW_YELLOW, S_ALL_RED);
    signal current_state, next_state : state_type;

    -- 1 Hz tick generator signals
    signal clk_div_counter : integer range 0 to CLK_FREQ_HZ - 1 := 0;
    signal tick_1hz        : std_logic := '0';

    -- Second counter for state durations
    signal timer_counter   : integer range 0 to 15 := 0;

    -- Configurable durations in seconds
    constant T_GREEN  : integer := 5;
    constant T_YELLOW : integer := 2;

begin

    -- 1-second pulse generator from system clock
    clk_divider: process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                clk_div_counter <= 0;
                tick_1hz <= '0';
            else
                if clk_div_counter = CLK_FREQ_HZ - 1 then
                    clk_div_counter <= 0;
                    tick_1hz <= '1';
                else
                    clk_div_counter <= clk_div_counter + 1;
                    tick_1hz <= '0';
                end if;
            end if;
        end if;
    end process;

    -- State Transition & Timer Register
    sync_proc: process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                current_state <= S_ALL_RED;
                timer_counter <= 0;
            elsif emergency = '1' then
                current_state <= S_ALL_RED;
                timer_counter <= 0;
            else
                if tick_1hz = '1' then
                    if current_state /= next_state then
                        current_state <= next_state;
                        timer_counter <= 0;
                    else
                        timer_counter <= timer_counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Next State Logic
    comb_next_state: process(current_state, timer_counter, sensor_ew)
    begin
        next_state <= current_state;

        case current_state is
            when S_ALL_RED =>
                if timer_counter >= 1 then
                    next_state <= S_NS_GREEN;
                end if;

            when S_NS_GREEN =>
                -- Switch to yellow if time is up, or extend slightly unless EW sensor triggers
                if timer_counter >= T_GREEN or (timer_counter >= 3 and sensor_ew = '1') then
                    next_state <= S_NS_YELLOW;
                end if;

            when S_NS_YELLOW =>
                if timer_counter >= T_YELLOW then
                    next_state <= S_EW_GREEN;
                end if;

            when S_EW_GREEN =>
                if timer_counter >= T_GREEN then
                    next_state <= S_EW_YELLOW;
                end if;

            when S_EW_YELLOW =>
                if timer_counter >= T_YELLOW then
                    next_state <= S_NS_GREEN;
                end if;

            when others =>
                next_state <= S_ALL_RED;
        end case;
    end process;

    -- Output Logic (Format: [Red, Yellow, Green])
    comb_outputs: process(current_state)
    begin
        case current_state is
            when S_NS_GREEN =>
                lights_ns <= "001"; -- Green
                lights_ew <= "100"; -- Red
            when S_NS_YELLOW =>
                lights_ns <= "010"; -- Yellow
                lights_ew <= "100"; -- Red
            when S_EW_GREEN =>
                lights_ns <= "100"; -- Red
                lights_ew <= "001"; -- Green
            when S_EW_YELLOW =>
                lights_ns <= "100"; -- Red
                lights_ew <= "010"; -- Yellow
            when S_ALL_RED =>
                lights_ns <= "100"; -- Red
                lights_ew <= "100"; -- Red
            when others =>
                lights_ns <= "100";
                lights_ew <= "100";
        end case;
    end process;

end architecture Behavioral;