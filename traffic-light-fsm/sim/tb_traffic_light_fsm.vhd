library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_traffic_light_fsm is
end entity tb_traffic_light_fsm;

architecture Sim of tb_traffic_light_fsm is
    signal clk         : std_logic := '0';
    signal reset_n     : std_logic := '0';
    signal sensor_ew   : std_logic := '0';
    signal emergency   : std_logic := '0';
    signal lights_ns   : std_logic_vector(2 downto 0);
    signal lights_ew   : std_logic_vector(2 downto 0);

    constant CLK_PERIOD : time := 10 ns;
begin

    -- Instantiate with a small clock frequency ratio so simulation runs quickly
    uut: entity work.traffic_light_fsm
        generic map (
            CLK_FREQ_HZ => 4 -- 4 clock ticks = 1 second of simulation time
        )
        port map (
            clk         => clk,
            reset_n     => reset_n,
            sensor_ew   => sensor_ew,
            emergency   => emergency,
            lights_ns   => lights_ns,
            lights_ew   => lights_ew
        );

    -- 100 MHz clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stim_proc: process
    begin
        -- Assert Reset
        reset_n <= '0';
        wait for 40 ns;
        reset_n <= '1';

        -- Run normal cycle through NS Green -> NS Yellow -> EW Green
        wait for 350 ns;

        -- Test EW priority trigger
        sensor_ew <= '1';
        wait for 100 ns;
        sensor_ew <= '0';

        -- Test Emergency override (all lights red)
        wait for 200 ns;
        emergency <= '1';
        wait for 80 ns;
        emergency <= '0';

        wait;
    end process;
end architecture Sim;