library ieee;
use ieee.std_logic_1164.all;

entity pc is
    port(
        clk    : in  std_logic;
        reset  : in  std_logic;
        pcnext : in  std_logic_vector(31 downto 0);
        pc_out : out std_logic_vector(31 downto 0)
    );
end entity pc;

architecture rtl of pc is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_out <= (others => '0');
        elsif rising_edge(clk) then
            pc_out <= pcnext;
        end if;
    end process;
end architecture rtl;
