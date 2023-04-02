-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Kirill Danyleyko (xdanyl00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UART_RX_FSM is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        RXD : in std_logic;
        RX_READY : out std_logic;
        RX_DATA : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behavioral of UART_RX_FSM is
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;
    signal bit_counter : integer range 0 to 8 := 0;
    signal data_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if RST = '1' then
            state <= IDLE;
            bit_counter <= 0;
            data_reg <= (others => '0');
            RX_READY <= '0';
            RX_DATA <= (others => '0');
        elsif rising_edge(CLK) then
            case state is
                when IDLE =>
                    if RXD = '0' then
                        state <= START_BIT;
                        bit_counter <= 0;
                        data_reg <= (others => '0');
                    end if;
                when START_BIT =>
                    if RXD = '0' then
                        if bit_counter < 8 then
                            bit_counter <= bit_counter + 1;
                            data_reg(bit_counter) <= RXD;
                        else
                            state <= STOP_BIT;
                            bit_counter <= 0;
                        end if;
                    else
                        state <= IDLE;
                        bit_counter <= 0;
                        data_reg <= (others => '0');
                    end if;
                when DATA_BITS =>
                    if RXD = '0' then
                        if bit_counter < 8 then
                            bit_counter <= bit_counter + 1;
                            data_reg(bit_counter) <= RXD;
                        else
                            state <= STOP_BIT;
                            bit_counter <= 0;
                        end if;
                    else
                        state <= IDLE;
                        bit_counter <= 0;
                        data_reg <= (others => '0');
                    end if;
                when STOP_BIT =>
                    if RXD = '1' then
                        state <= IDLE;
                        RX_READY <= '1';
                        RX_DATA <= data_reg;
                    else
                        state <= IDLE;
                        bit_counter <= 0;
                        data_reg <= (others => '0');
                    end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;
end architecture;
