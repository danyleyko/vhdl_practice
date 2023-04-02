-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Kirill Danyleyko (xdanyl00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
	port(
		CLK      : in std_logic;
		RST      : in std_logic;
		DIN      : in std_logic;
		DOUT     : out std_logic_vector(7 downto 0);
		DOUT_VLD : out std_logic
	);
end entity;
-----------------------------------------------



-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
	signal rx_ready : std_logic := '0';
	signal rx_data : std_logic_vector(7 downto 0) := (others => '0');
begin

	-- Instance of RX FSM
	fsm: entity work.UART_RX_FSM
	port map (
		CLK => CLK,
		RST => RST,
		RXD => DIN,
		RX_READY => rx_ready,
		RX_DATA => rx_data
	);

	DOUT <= rx_data; --<= (others => '0');
	DOUT_VLD <= rx_ready; --'0';
    
end architecture;
-----------------------------------------------------------------
