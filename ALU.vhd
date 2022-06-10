
--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0); -- 4 downto 3 for mux, 2 for add/sub, 1 downto 0 for shift
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	signal add_sub_out, shift_out: std_logic_vector(31 downto 0);
begin
	-- Add ALU VHDL implementation here
	add_sub: component adder_subtracter port map
		(DataIn1(31 downto 0),DataIn2(31 downto 0),ALUCtrl(2),add_sub_out(31 downto 0),open);

	shift: component shift_register port map
		(DataIn1(31 downto 0),ALUCtrl(2),ALUCtrl(1 downto 0),shift_out);

	with ALUCtrl(4 downto 3) select
	ALUResult <=	add_sub_out when "00",
			shift_out when "01",
			DataIn1(31 downto 0) and DataIn2(31 downto 0) when "10",
			DataIn1(31 downto 0) or DataIn2(31 downto 0) when "11",

	zero <= '1' when ALUResult = x"0000" else '0';
end architecture ALU_Arch;