library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
    port(
        clk : in  std_logic;
        we3 : in  std_logic;
        a1  : in  std_logic_vector(4 downto 0);
        a2  : in  std_logic_vector(4 downto 0);
        a3  : in  std_logic_vector(4 downto 0);
        wd3 : in  std_logic_vector(31 downto 0);
        rd1 : out std_logic_vector(31 downto 0);
        rd2 : out std_logic_vector(31 downto 0)
    );
end entity regfile;

architecture rtl of regfile is
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal rf : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we3 = '1' then
                rf(to_integer(unsigned(a3))) <= wd3;
            end if;
        end if;
    end process;

    -- x0 luon bang 0 (hardwired zero)
    rd1 <= rf(to_integer(unsigned(a1))) when a1 /= "00000" else (others => '0');
    rd2 <= rf(to_integer(unsigned(a2))) when a2 /= "00000" else (others => '0');
end architecture rtl;
