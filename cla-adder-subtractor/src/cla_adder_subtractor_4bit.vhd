library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_adder_subtractor_4bit is
    Port (
        a        : in  std_logic_vector(3 downto 0);
        b        : in  std_logic_vector(3 downto 0);
        sub_mode : in  std_logic;                    -- '0' for Add, '1' for Subtract
        sum      : out std_logic_vector(3 downto 0);
        cout     : out std_logic;
        overflow : out std_logic
    );
end entity cla_adder_subtractor_4bit;

architecture Behavioral of cla_adder_subtractor_4bit is
    signal b_xor : std_logic_vector(3 downto 0);
    signal p     : std_logic_vector(3 downto 0); -- Propagate: P_i = A_i xor B_effective_i
    signal g     : std_logic_vector(3 downto 0); -- Generate:  G_i = A_i and B_effective_i
    signal c     : std_logic_vector(4 downto 0); -- Carry signals: c(0) is Cin
begin

    -- Conditional bitwise inversion of B for 2's complement subtraction
    b_xor(0) <= b(0) xor sub_mode;
    b_xor(1) <= b(1) xor sub_mode;
    b_xor(2) <= b(2) xor sub_mode;
    b_xor(3) <= b(3) xor sub_mode;

    -- Cin is 1 when subtracting (completing 2's complement negation), 0 when adding
    c(0) <= sub_mode;

    -- Generate and Propagate logic
    gen_terms: for i in 0 to 3 generate
        p(i) <= a(i) xor b_xor(i);
        g(i) <= a(i) and b_xor(i);
    end generate;

    -- Lookahead Carry Equations
    c(1) <= g(0) or (p(0) and c(0));
    c(2) <= g(1) or (p(1) and g(0)) or (p(1) and p(0) and c(0));
    c(3) <= g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and c(0));
    c(4) <= g(3) or (p(3) and g(2)) or (p(3) and p(2) and g(1)) or (p(3) and p(2) and p(1) and g(0)) or 
            (p(3) and p(2) and p(1) and p(0) and c(0));

    -- Final Sum calculation: Sum_i = P_i xor C_i
    sum_gen: for i in 0 to 3 generate
        sum(i) <= p(i) xor c(i);
    end generate;

    cout <= c(4);

    -- Signed 2's complement overflow detection: V = C_3 xor C_4
    overflow <= c(3) xor c(4);

end architecture Behavioral;