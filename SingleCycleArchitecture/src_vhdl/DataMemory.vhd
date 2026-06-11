library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmem is
    port(
        clk : in  std_logic;
        we  : in  std_logic;
        a   : in  std_logic_vector(31 downto 0);
        wd  : in  std_logic_vector(31 downto 0);
        rd  : out std_logic_vector(31 downto 0)
    );
end entity dmem;

architecture rtl of dmem is
    type ram_array is array(0 to 63) of std_logic_vector(31 downto 0);
    signal RAM : ram_array := (others => (others => '0'));
begin
    rd <= RAM(to_integer(unsigned(a(31 downto 2))));

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                RAM(to_integer(unsigned(a(31 downto 2)))) <= wd;
            end if;
        end if;
    end process;
end architecture rtl;
