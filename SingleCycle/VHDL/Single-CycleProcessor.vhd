library ieee;
use ieee.std_logic_1164.all;

entity riscvsingle is
    port(
        clk       : in  std_logic;
        reset     : in  std_logic;
        PC        : out std_logic_vector(31 downto 0);
        Instr     : in  std_logic_vector(31 downto 0);
        MemWrite  : out std_logic;
        ALUResult : out std_logic_vector(31 downto 0);
        WriteData : out std_logic_vector(31 downto 0);
        ReadData  : in  std_logic_vector(31 downto 0)
    );
end entity riscvsingle;

architecture rtl of riscvsingle is
    signal ResultSrc  : std_logic_vector(1 downto 0);
    signal PCSrc      : std_logic;
    signal ALUSrc     : std_logic;
    signal RegWrite   : std_logic;
    signal Jump       : std_logic;
    signal ImmSrc     : std_logic_vector(1 downto 0);
    signal ALUControl : std_logic_vector(2 downto 0);
    signal Zero       : std_logic;
begin
    c : entity work.controller
        port map(
            op       => Instr(6 downto 0),
            funct3   => Instr(14 downto 12),
            funct7b5 => Instr(30),
            Zero      => Zero,
            ResultSrc => ResultSrc,
            MemWrite  => MemWrite,
            PCSrc     => PCSrc,
            ALUSrc    => ALUSrc,
            RegWrite  => RegWrite,
            Jump      => Jump,
            ImmSrc    => ImmSrc,
            ALUControl => ALUControl
        );

    dp : entity work.datapath
        port map(
            clk        => clk,
            reset      => reset,
            ResultSrc  => ResultSrc,
            PCSrc      => PCSrc,
            ALUSrc     => ALUSrc,
            RegWrite   => RegWrite,
            ImmSrc     => ImmSrc,
            ALUControl => ALUControl,
            Zero       => Zero,
            PC         => PC,
            Instr      => Instr,
            ALUResult  => ALUResult,
            WriteData  => WriteData,
            ReadData   => ReadData
        );
end architecture rtl;
