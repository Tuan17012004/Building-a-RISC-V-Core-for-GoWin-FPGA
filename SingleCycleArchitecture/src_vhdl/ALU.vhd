library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port(
        a          : in  std_logic_vector(31 downto 0);
        b          : in  std_logic_vector(31 downto 0);
        alucontrol : in  std_logic_vector(2 downto 0);
        result     : out std_logic_vector(31 downto 0);
        zero       : out std_logic
    );
end entity alu;

architecture rtl of alu is
    signal condinvb : std_logic_vector(31 downto 0);
    signal sum      : std_logic_vector(31 downto 0);
    signal res      : std_logic_vector(31 downto 0);
begin
    condinvb <= not b when alucontrol(0) = '1' else b;
    -- sum = a + condinvb + alucontrol[0] (2's complement subtraction khi alucontrol[0]=1)
    sum <= std_logic_vector(unsigned(a) + unsigned(condinvb) +
           resize(unsigned(alucontrol(0 downto 0)), 32));

    process(alucontrol, a, b, sum)
    begin
        case alucontrol is
            when "000"  => res <= sum;           -- add
            when "001"  => res <= sum;           -- sub
            when "010"  => res <= a and b;       -- and
            when "011"  => res <= a or b;        -- or
            when "100"  => res <= a xor b;       -- xor
            when "101"  =>                       -- slt (signed)
                if signed(a) < signed(b) then
                    res <= (0 => '1', others => '0');
                else
                    res <= (others => '0');
                end if;
            when others => res <= (others => '0');
        end case;
    end process;

    result <= res;
    zero   <= '1' when res = x"00000000" else '0';
end architecture rtl;
