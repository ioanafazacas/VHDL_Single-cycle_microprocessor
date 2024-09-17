----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2024 04:38:53 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
  Port (clk: in std_logic;
        btn: in std_logic_vector(4 downto 0);
        sw: in std_logic_vector(15 downto 0);
        led: out std_logic_vector(15 downto 0);
        an : out std_logic_vector(7 downto 0);
        cat: out std_logic_vector(6 downto 0)
        --outt : out STD_LOGIC_VECTOR (31 downto 0)
        );
end test_env;

architecture Behavioral of test_env is
signal counter: std_logic_vector(1 downto 0):=(others=>'0');
signal digits:std_logic_vector(31 downto 0):=(others=>'0');
signal btn_en: std_logic;
signal rst:std_logic;
signal btn_rom:std_logic;
signal do:std_logic_vector(31 downto 0);

component RF
port
(clk:in std_logic;
ra1:in std_logic_vector(4 downto 0);
ra2:in std_logic_vector(4 downto 0);
wa:in std_logic_vector(4 downto 0);
wd:in std_logic_vector(31 downto 0);
regwr: in std_logic;
rd1:out std_logic_vector(31 downto 0);
rd2:out std_logic_vector(31 downto 0));
end component;


component IFetch
Port (
clk: in std_logic;
en:in std_logic;
rst: in std_logic;
Jump: in std_logic;
PCSrc: in std_logic;
--PCSrc2: in std_logic;
JumpAdr: in std_logic_vector(31 downto 0);
BranchAdr: in std_logic_vector(31 downto 0);
--BranchGTZAdr: in std_logic_vector(31 downto 0);
instruction: out std_logic_vector(31 downto 0);
PC:out std_logic_vector(31 downto 0)
 );
 end component;
 
 signal instruction:std_logic_vector(31 downto 0);
 signal PC:std_logic_vector(31 downto 0);
 signal PCSrc: std_logic;
 signal JumpAdr:std_logic_vector(31 downto 0);
 signal BranchAdr:std_logic_vector(31 downto 0);
 
 component ID
 Port ( 
clk:in std_logic;
RegWrite:in std_logic;
Instr:in std_logic_vector(25 downto 0);
RegDst:in std_logic;
ExtOp:in std_logic;
WD:in std_logic_vector(31 downto 0);
RD1:out std_logic_vector(31 downto 0);
RD2:out std_logic_vector(31 downto 0);
Ext_Imm:out std_logic_vector(31 downto 0);
func:out std_logic_vector(5 downto 0);
sa:out std_logic_vector(4 downto 0)
);
end component;
 
 signal RegWrite:std_logic;
 signal RegDst:std_logic;
 signal ExtOp:std_logic;
 signal func:std_logic_vector(5 downto 0);
 signal sa:std_logic_vector(4 downto 0);
 signal Ext_Imm:std_logic_vector(31 downto 0);
 signal WD:std_logic_vector(31 downto 0);
 signal RD1:std_logic_vector(31 downto 0);
 signal RD2:std_logic_vector(31 downto 0);
 
component UC
Port (
Instr:in std_logic_vector(5 downto 0);
RegDst:out std_logic;
ExtOp:out std_logic;
ALUSrc:out std_logic;
Branch:out std_logic;
BraGTZ:out std_logic;
Jump:out std_logic;
ALUOp:out std_logic_vector(1 downto 0);
MemWrite:out std_logic;
MemtoReg:out std_logic;
RegWrite:out std_logic
 );
 end component;
 
signal ALUSrc:std_logic;
signal Branch:std_logic;
signal BraGTZ: std_logic;
signal Jump:std_logic;
signal ALUOp:std_logic_vector(1 downto 0);
signal MemWrite:std_logic;
signal MemtoReg:std_logic;

component EX
Port (
RD1:in std_logic_vector(31 downto 0);
RD2:in std_logic_vector(31 downto 0);
ALUSrc:in std_logic;
Ext_Imm:in std_logic_vector(31 downto 0);
sa:in std_logic_vector(4 downto 0);
func:in std_logic_vector(5 downto 0);
ALUOp:in std_logic_vector(1 downto 0);
PC:in std_logic_vector(31 downto 0);
BranchAdr: out std_logic_vector(31 downto 0);
ALURez:out std_logic_vector(31 downto 0);
Zero: out std_logic;
Gtz:out std_logic
 );
end component;

signal Zero:std_logic;
signal Gtz: std_logic;

signal rez: std_logic_vector(31 downto 0);
component MEM
Port ( 
clk:in std_logic;
MemWrite:in std_logic;
en:in std_logic;
ALUResin:in std_logic_vector(31 downto 0);
RD2:in std_logic_vector(31 downto 0);
ALUResout:out std_logic_vector(31 downto 0);
MemData:out std_logic_vector(31 downto 0);
rez:out std_logic_vector(31 downto 0)
);
end component;

signal MemData:std_logic_vector(31 downto 0);
signal ALUResout:std_logic_vector(31 downto 0);
signal ALUResin:std_logic_vector(31 downto 0);

 
begin

btn_control:entity WORK.mpg port map
(
btn=>btn(0),
clk=>clk,
en=>btn_en
);


SSD:entity WORK.SSD port map
(
clk=>clk,
digit=>digits,
an=>an,
cat=>cat
);

InstructionFetch:IFetch port map
(
clk=>clk,
en=>btn_en,
rst=>btn(1),
Jump=>Jump,  --UC
PCSrc=>PCSrc, --UC
--PCSrc2=>sw(2),
JumpAdr=>JumpAdr, -- din WB
BranchAdr=>BranchAdr, --din EX
--BranchGTZAdr=>X"00000020",
instruction=>instruction,  --IF
PC=>PC --PC+4 sper
);

InstructionDecoder:ID port map
(
clk=>clk,
RegWrite=>RegWrite,  --UC
Instr=>instruction(25 downto 0),  --IF
RegDst=>RegDst,  --UC
ExtOp=>ExtOp,  --UC
WD=>WD, --din mux memtoreg dupa memorie ram -- WB
RD1=>RD1, 
RD2=>RD2, 
Ext_Imm=>Ext_Imm,
func=>func,
sa=>sa
);

UnitateControl: UC port map
(
Instr=>instruction(31 downto 26),
RegDst=>RegDst,
ExtOp=>ExtOp,
ALUSrc=>ALUSrc,
Branch=>Branch,
BraGTZ=>BraGTZ,
Jump=>Jump,
ALUOp=>ALUOp,
MemWrite=>MemWrite,
MemtoReg=>MemtoReg,
RegWrite=>RegWrite
 );
 
UnitateExecutie: EX port map
(
RD1=>RD1,
RD2=>RD2,
ALUSrc=>ALUSrc,
Ext_Imm=>Ext_Imm,
sa=>sa,
func=>func,
ALUOp=>ALUOp,
PC=>PC,
BranchAdr=>BranchAdr,
ALURez=>ALUResin,
Zero=>Zero,
Gtz=>Gtz
 );
 
MemorieRAM: MEM port map
( 
clk=>clk,
MemWrite=>MemWrite, --din UC
en=>btn_en,
ALUResin=>ALUResin,
RD2=>RD2,
ALUResout=>ALUResout,
MemData=>MemData,
rez=>rez
);

-- alte elemente
PCSrc<=(Branch and Zero) or (BraGTZ and Gtz);
JumpAdr<=PC(31 downto 28)&instruction(25 downto 0)&"00";

-- WB
WD<=MemData when memtoReg='1' else ALUResout;

process(sw(9 downto 5))
begin
case sw(8 downto 5) is
when "0000" => digits<=instruction;
when "0001" => digits<=PC;
when "0010" => digits<=RD1;
when "0011" => digits<=RD2;
when "0100" => digits<=Ext_Imm;
when "0101" => digits<=ALUResin;
when "0110" => digits<=MemData;
when "0111" => digits<=ALUResout;
when "1000" => digits<=BranchAdr;
when "1001" => digits<=rez;
when others => digits<=WD;
end case;
end process;



end Behavioral;
