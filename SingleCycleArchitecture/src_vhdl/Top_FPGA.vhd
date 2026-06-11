library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_fpga is
    port(
        clk   : in  std_logic;
        rst_n : in  std_logic;
        led   : out std_logic_vector(3 downto 0)
    );
end entity top_fpga;

architecture rtl of top_fpga is
    signal rst_sync   : std_logic_vector(2 downto 0) := (others => '0');
    signal reset      : std_logic;
    signal PC         : std_logic_vector(31 downto 0);
    signal Instr      : std_logic_vector(31 downto 0);
    signal MemWrite   : std_logic;
    signal WriteData  : std_logic_vector(31 downto 0);
    signal ALUResult  : std_logic_vector(31 downto 0);
    signal ReadData   : std_logic_vector(31 downto 0);
    signal div        : unsigned(25 downto 0) := (others => '0');
    signal wr_latch   : std_logic_vector(3 downto 0) := (others => '0');
    signal wr_display : std_logic_vector(3 downto 0) := (others => '0');
begin
    -- 3-FF dong bo hoa reset (chong metastability)
    process(clk)
    begin
        if rising_edge(clk) then
            rst_sync <= rst_sync(1 downto 0) & (not rst_n);
        end if;
    end process;
    reset <= rst_sync(2);

    cpu : entity work.riscvsingle
        port map(
            clk => clk, reset => reset, PC => PC, Instr => Instr,
            MemWrite => MemWrite, ALUResult => ALUResult,
            WriteData => WriteData, ReadData => ReadData
        );

    imem_inst : entity work.imem
        port map(a => PC, rd => Instr);

    dmem_inst : entity work.dmem
        port map(clk => clk, we => MemWrite, a => ALUResult,
                 wd => WriteData, rd => ReadData);

    -- Chu ky = 50_000_019 clock (~1 giay tai 50 MHz).
    -- 50_000_019 / 3 = 16_666_673 vong lap, 16_666_673 mod 16 = 1
    -- => LED tang dung 1 moi giay (0->1->2->...->15->0)
    -- Neu dung 50_000_000: 50_000_000/3=16_666_666, mod 16=10 => LED nhay loai
    process(clk, reset)
    begin
        if reset = '1' then
            div <= (others => '0');
        elsif rising_edge(clk) then
            if div = to_unsigned(50_000_018, 26) then
                div <= (others => '0');
            else
                div <= div + 1;
            end if;
        end if;
    end process;

    -- Chot gia tri LED moi lan co lenh sw (MemWrite)
    process(clk, reset)
    begin
        if reset = '1' then
            wr_latch <= (others => '0');
        elsif rising_edge(clk) then
            if MemWrite = '1' then
                wr_latch <= WriteData(3 downto 0);
            end if;
        end if;
    end process;

    -- Cap nhat LED moi 1 giay
    process(clk, reset)
    begin
        if reset = '1' then
            wr_display <= (others => '0');
        elsif rising_edge(clk) then
            if div = to_unsigned(50_000_018, 26) then
                wr_display <= wr_latch;
            end if;
        end if;
    end process;

    led <= wr_display;
end architecture rtl;
