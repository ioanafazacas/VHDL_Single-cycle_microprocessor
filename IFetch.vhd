----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2024 04:27:41 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
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
end IFetch;

architecture Behavioral of IFetch is
signal PCsum:std_logic_vector(31 downto 0);
signal branchRez:std_logic_vector(31 downto 0);
--signal branch2Rez:std_logic_vector(31 downto 0);
signal PCin:std_logic_vector(31 downto 0);
signal PCout:std_logic_vector(31 downto 0);
type mem_rom is array(0 to 32)of std_logic_vector(31 downto 0);
signal rom: mem_rom:=(
      0=>B"000000_00000_00000_00001_00000_000001", --add $1,$0,$0 -- hexa:X"00000801" -- in r1 stocam valoarea 0, folosim r1 ca contor pentru bucla (i=0 contorul buclei)
      1=>B"100010_00000_00011_0000000000000100", --lw $3, 4($0) -- hexa:X"88030004" -- in r3 stocam valoare N(care se afla la adresa 4 in memorie) aceasta reprezinta lungimea sirului
      2=>B"000000_00000_00000_00010_00000_000001", --add $2,$0,$0 -- hexa:X"00001001" -- in r2 stocam valoarea 0 
      3=>B"001000_00000_00101_1111111110011101", --addi $5,$0, -999 -- hexa:X"2005FF9D" -- in r5 stocam valoarea -999, r5 va fi folosit pentru stocarea valorii pozitive pare maxime din sir (max=-999)
      4=>B"100010_00000_00100_0000000000000000", --lw $4, 0($0) -- hexa:X"88040000" -- in r4 stocam adresa de inceput a sirului A, r4 va fi folosit pentru a stoca adresa la care se afl? elementele din sir pe parcurs ce
                                                                                    -- parcurgem sirul prin intermediul buclei 
      5=>B"000100_00001_00011_0000000000001101", --beq $1,$3 13 -- hexa:X"1023000D" -- verificam daca am terminat de parcurs intregul sir(i==N) , iar daca este adevarat sarim la finalul programului 
                                                                                    -- la instructiunea de pe pozitia 19 pentru a salva reultatul in memorie
      6=>B"100010_00100_00110_0000000000000000", --lw $6,0($4) -- hexa:X"88860000"  -- in r6 aducem elementul current din sir (r6=A[i])
      7=>B"001000_00000_00111_0000000000000001", --addi $7,$0,1 -- hexa:X"20070001" -- in r7 stocam valoarea 1
      8=>B"000000_00111_00110_01000_00000_100000", --and $8,$7,$6 -- hexa:X"00E64020" -- facem AND pe biti intre elementul curent din sir A[i] si valoarea 1 , r8=0 daca elementul A[i] este par , altfel r8=1 daca A[i] este impar 
      9=>B"001000_00001_01001_0000000000000001", --addi $9,$1,1s -- hexa:X"20290001" -- r9=i+1 in r9 stocam valoarea contorului incrementata cu 1
      10=>B"000000_01001_00000_00001_00000_000001", --add $1,$9,$0 -- hexa:X"01200801" -- r1=r9 actualizam valoare contorului cu valoarea lui incrementata i=i+1
      11=>B"001000_00100_01010_0000000000000001", --addi $10,$4,1 -- hexa:X"208A0001" -- r10=r4+1 in r10 stocam adresa urmatorului element din sir
      12=>B"000000_01010_00000_00100_00000_000001", --add $4,$10,$0 -- hexa:X"01402001" -- r4=r10 actulizam r4 cu noua adresa a elementului curent care va fi folosita in urmatoarea iteratie a sirului
      13=>B"000100_01000_00000_0000000000000001", --beq $8,$0,1 -- hexa:X"11000001" -- daca elementul curent A[i] este impar mergem mai departe la instructiunea de jump care ne trimite la inceputul buclei
                                                                                    -- daca nu sarim peste instructiunea de jump si efectual instructiunea de slt 
      14=>B"000010_00000000000000000000000101", --j 5 -- hexa:X"08000005" -- sarim la inceputul buclei
      15=>B"000000_00101_00110_00111_00000_001010", --slt $7,$5,$6 -- hexa:X"00A6380A" -- r7=1 daca (r5<r6) max<A[i] altfel r7=0
      16=>B"000100_00111_00000_0000000000000001", --beq $7,$0,1 -- hexa:X"10E00001" -- daca max<A[i] mergem la instructiunea urmatoare unde actualizam valoarea maximului max=A[i]
                                                                                    -- altfel facem salt la instructunea de jump care ne trimite la inceputul buclei
      17=>B"000000_00110_00000_00101_00000_000001", --add $5,$6,$0 -- hexa:X"00C02801" -- actualizam valoarea maximului (r5=r6) max=A[i]
      18=>B"000010_00000000000000000000000101", --j 5 -- hexa:X"08000005" -- sarim la inceputul buclei la instructiunea 5
      19=>B"100011_00000_00101_00000_00000001000", --sw $5,8($0) -- hexa:X"8C050008" -- stocam in memorie la adresa 8 valoarea para maxima din sir
      others=>X"00000000"
);

begin

branchRez<=PCsum when PCSrc='0' else BranchAdr;
--branch2Rez<=branchRez when PCSrc2='0' else BranchGTZAdr;
PCin<=branchRez when Jump='0' else JumpAdr;


--bistabil PC
process(clk,rst)
begin
if rst='1' then
   PCout<=(others=>'0');
else
   if clk='1' and clk'event then
      if en='1'then
         PCout<=PCin;
      end if;
   end if;
end if;
end process;

--sumator
PCsum<= PCout+X"00000004";

PC<=PCsum;
--memorie rom
instruction<=rom(conv_integer(PCout(6 downto 2)));


end Behavioral;
