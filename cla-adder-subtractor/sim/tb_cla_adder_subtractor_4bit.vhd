library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_cla_adder_subtractor_4bit is
end entity tb_cla_adder_subtractor_4bit;

architecture Sim of tb_cla_adder_subtractor_4bit is
    signal a        : std_logic_vector(3 downto 0) := (others => '0');
    signal b        : std_logic_vector(3 downto 0) := (others => '0');
    signal sub_mode : std_logic := '0';
    signal sum      : std_logic_vector(3 downto 0);
    signal cout     : std_logic;
    signal overflow : std_logic;
begin

    uut: entity work.cla_adder_subtractor_4bit
        port map (
            a        => a,
            b        => b,
            sub_mode => sub_mode,
            sum      => sum,
            cout     => cout,
            overflow => overflow
        );

    stim_proc: process
    begin
        -- Test 1: Addition 3 + 2 = 5
        a <= "0011"; b <= "0010"; sub_mode <= '0';
        wait for 20 ns;

        -- Test 2: Subtraction 7 - 3 = 4
        a <= "0111"; b <= "0011"; sub_mode <= '1';
        wait for 20 ns;

        -- Test 3: Subtraction 3 - 5 = -2 (14 in unsigned 4-bit representation "1110")
        a <= "0011"; b <= "0101"; sub_mode <= '1';
        wait for 20 ns;

        -- Test 4: Signed overflow in addition (7 + 2 = 9 -> exceeds signed 4-bit limit of 7)
        a <= "0111"; b <= "0010"; sub_mode <= '0';
        wait for 20 ns;

        -- Test 5: Unsigned carry-out (15 + 1)
        a <= "1111"; b <= "0001"; sub_mode <= '0';
        wait for 20 ns;

        wait;
    end process;
end architecture Sim;