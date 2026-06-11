library ieee;
use ieee.std_logic_1164.all;

entity datapath is
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;
        ResultSrc  : in  std_logic_vector(1 downto 0);
        PCSrc      : in  std_logic;
        ALUSrc     : in  std_logic;
        RegWrite   : in  std_logic;
        ImmSrc     : in  std_logic_vector(1 downto 0);
        ALUControl : in  std_logic_vector(2 downto 0);
        Zero       : out std_logic;
        PC         : out std_logic_vector(31 downto 0);
        Instr      : in  std_logic_vector(31 downto 0);
        ALUResult  : out std_logic_vector(31 downto 0);
        WriteData  : out std_logic_vector(31 downto 0);
        ReadData   : in  std_logic_vector(31 downto 0)
    );
end entity datapath;

architecture rtl of datapath is
    signal PCNext, PCPlus4, PCTarget : std_logic_vector(31 downto 0);
    signal ImmExt                    : std_logic_vector(31 downto 0);
    signal SrcA, SrcB, Result        : std_logic_vector(31 downto 0);
    -- Internal signals cho cac output duoc doc lai ben trong
    signal PC_int         : std_logic_vector(31 downto 0);
    signal ALUResult_int  : std_logic_vector(31 downto 0);
    signal WriteData_int  : std_logic_vector(31 downto 0);
    signal Zero_int       : std_logic;
begin
    PC        <= PC_int;
    ALUResult <= ALUResult_int;
    WriteData <= WriteData_int;
    Zero      <= Zero_int;

    pcreg : entity work.flopr
        generic map(WIDTH => 32)
        port map(clk => clk, reset => reset, d => PCNext, q => PC_int);

    pcadd4 : entity work.adder
        port map(a => PC_int, b => x"00000004", y => PCPlus4);

    pcaddbr : entity work.adder
        port map(a => PC_int, b => ImmExt, y => PCTarget);

    pcmux : entity work.mux2to1
        generic map(WIDTH => 32)
        port map(d0 => PCPlus4, d1 => PCTarget, s => PCSrc, y => PCNext);

    rf : entity work.regfile
        port map(
            clk => clk, we3 => RegWrite,
            a1  => Instr(19 downto 15),
            a2  => Instr(24 downto 20),
            a3  => Instr(11 downto 7),
            wd3 => Result,
            rd1 => SrcA,
            rd2 => WriteData_int
        );

    ext : entity work.extend
        port map(instr => Instr, immsrc => ImmSrc, immext => ImmExt);

    srcbmux : entity work.mux2to1
        generic map(WIDTH => 32)
        port map(d0 => WriteData_int, d1 => ImmExt, s => ALUSrc, y => SrcB);

    alu_inst : entity work.alu
        port map(
            a          => SrcA,
            b          => SrcB,
            alucontrol => ALUControl,
            result     => ALUResult_int,
            zero       => Zero_int
        );

    resultmux : entity work.mux3
        generic map(WIDTH => 32)
        port map(
            d0 => ALUResult_int,
            d1 => ReadData,
            d2 => PCPlus4,
            s  => ResultSrc,
            y  => Result
        );
end architecture rtl;
