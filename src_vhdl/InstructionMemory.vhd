library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imem is
    port(
        a  : in  std_logic_vector(31 downto 0);
        rd : out std_logic_vector(31 downto 0)
    );
end entity imem;

architecture rtl of imem is
begin
    -- ROM hardcoded - tranh GoWIN khong load ram_init_file cho async ROM
    process(a)
    begin
        case to_integer(unsigned(a(7 downto 2))) is
            when 0 => rd <= x"00000093"; -- addi x1,x0,0  (PC=0)
            when 1 => rd <= x"00108093"; -- addi x1,x1,1  (PC=4)
            when 2 => rd <= x"00102023"; -- sw x1,0(x0)   (PC=8)
            when 3 => rd <= x"ff9ff06f"; -- jal x0,-8     (PC=12)
            when others => rd <= x"00000013"; -- nop
        end case;
    end process;
end architecture rtl;
