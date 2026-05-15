-- The Potato Processor - A simple processor for FPGAs
-- (c) Kristian Klomsten Skordal 2014 - 2015 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;

use work.pp_constants.all;
use work.pp_csr.all;
use work.pp_types.all;
use work.pp_utilities.all;

--! Detects the case of a CSR instruction
entity pp_detect_csr is
	port(
		opcode  : in std_logic_vector( 4 downto 0); --! Instruction opcode field.
		funct3  : in std_logic_vector( 2 downto 0); --! Instruction funct3 field
		csr_instr : out std_logic --! Detection of CSR instruction
	);
end entity pp_detect_csr;

architecture behaviour of pp_detect_csr is
begin

	detecting_csr: process(opcode, funct3)
	begin
		if opcode = b"11100" then
			case funct3 is
				when b"001" | b"101" => -- csrrw/i
					csr_instr <= '1';
				when b"010" | b"110" => -- csrrs/i
					csr_instr <= '1';
				when b"011" | b"111" => -- csrrc/i
					csr_instr <= '1';
				when others =>
					csr_instr <= '1';
			end case;
		else
			csr_instr <= '0';
		end if;
	end process detecting_csr;

end architecture behaviour;
