----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2024 04:23:25 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
--use IEEE.std_logic_arith.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
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
end EX;

architecture Behavioral of EX is
signal ALUCtrl:std_logic_vector(2 downto 0):=(others=>'0');
signal nr1:std_logic_vector(31 downto 0):=(others=>'0');
signal nr2:std_logic_vector(31 downto 0):=(others=>'0');
signal rezultat:std_logic_vector(31 downto 0):=(others=>'0');

begin

--alu control
process(ALUOp)
begin
case ALUOp is
    when "00"=> ALUCtrl<="000"; --adunare
    when "01"=> ALUCtrl<="001"; --scadere
    when "11"=> ALUCtrl<="111"; -- <   --"=>ALUCtrl<="010"
    --when "101"=>ALUCtrl<="010"; -- &
    when others=> --tip r
           case func is
                when "000001"=>ALUCtrl<="000"; -- +
                when "000010"=>ALUCtrl<="001"; -- -
                when "000100"=>ALUCtrl<="100"; -- <<l
                when "000101"=>ALUCtrl<="101"; -- >>l
                when "100000"=>ALUCtrl<="010"; -- &
                when "100001"=>ALUCtrl<="011"; -- |
                when "000111"=>ALUCtrl<="110"; -- >>a
                when "001010"=>ALUCtrl<="111"; -- <
                when others=> ALUCtrl<="000";
           end case;
                
end case;
end process;

nr1<=RD1;
--mux
nr2<=RD2 when ALUSrc='0' else Ext_Imm;

--alu
process(ALUCtrl)
begin 
case ALUCtrl is
    when "000" => rezultat<=nr1+nr2;
    when "001" => rezultat<=nr1-nr2;
    when "010" => rezultat<=nr1 and nr2;
    when "011" => rezultat<=nr1 or nr2;
    when "100" => rezultat<= to_stdlogicvector(to_bitvector(nr1) sll conv_integer(sa)); 
    when "101" => rezultat<= to_stdlogicvector(to_bitvector(nr1) srl conv_integer(sa));
    when "110" => rezultat<= to_stdlogicvector(to_bitvector(nr1) sra conv_integer(sa));
    when others => if signed(nr1) < signed(nr2) then rezultat<=X"00000001"; 
                    else rezultat<=X"00000000";
                    end if;
end case;
end process;

ALURez<=rezultat;
--zero detector
Zero<='1' when rezultat=0 else '0';


--GTZ detector
--Gtz<='1' when rezultat>0 else '0';
process(rezultat)
begin
if signed(rezultat) > 0 then 
    Gtz<='1' ;
else Gtz<='0' ;
end if;
end process;

BranchAdr<=PC+(Ext_Imm(29 downto 0)&"00");


end Behavioral;
