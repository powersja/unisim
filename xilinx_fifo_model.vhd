library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIFO_ASYNC_8_AE is
    port (
        clk           : in  std_logic;
        rst           : in  std_logic;
        din           : in  std_logic_vector(7 downto 0);
        wr_en         : in  std_logic;
        rd_en         : in  std_logic;
        almost_empty  : out std_logic;
        dout          : out std_logic_vector(7 downto 0);
        empty         : out std_logic;
        full          : out std_logic;
        overflow      : out std_logic;
        underflow     : out std_logic
    );
end entity;

architecture behavioral of FIFO_ASYNC_8_AE is

    constant DEPTH : integer := 8;
    constant ADDR_WIDTH : integer := 3; -- log2(8) = 3

    type mem_type is array (0 to DEPTH-1) of std_logic_vector(7 downto 0);
    signal mem : mem_type := (others => (others => '0'));

    signal wr_ptr : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal rd_ptr : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal count  : unsigned(ADDR_WIDTH downto 0) := (others => '0'); -- Count range: 0 to DEPTH

    signal dout_reg : std_logic_vector(7 downto 0) := (others => '0');

    signal full_flag       : std_logic := '0';
    signal empty_flag      : std_logic := '1';
    signal almost_empty_flag : std_logic := '1';
    signal overflow_flag   : std_logic := '0';
    signal underflow_flag  : std_logic := '0';

begin

    -- Output register
    dout <= dout_reg;
    full <= full_flag;
    empty <= empty_flag;
    almost_empty <= almost_empty_flag;
    overflow <= overflow_flag;
    underflow <= underflow_flag;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                wr_ptr <= (others => '0');
                rd_ptr <= (others => '0');
                count  <= (others => '0');
                dout_reg <= (others => '0');
                full_flag <= '0';
                empty_flag <= '1';
                almost_empty_flag <= '1';
                overflow_flag <= '0';
                underflow_flag <= '0';
            else
                -- Defaults
                overflow_flag <= '0';
                underflow_flag <= '0';

                -- Write operation
                if (wr_en = '1' and full_flag = '0') then
                    mem(to_integer(wr_ptr)) <= din;
                    wr_ptr <= wr_ptr + 1;
                    count <= count + 1;
                elsif (wr_en = '1' and full_flag = '1') then
                    overflow_flag <= '1';
                end if;

                -- Read operation
                if (rd_en = '1' and empty_flag = '0') then
                    dout_reg <= mem(to_integer(rd_ptr));
                    rd_ptr <= rd_ptr + 1;
                    count <= count - 1;
                elsif (rd_en = '1' and empty_flag = '1') then
                    underflow_flag <= '1';
                end if;

                -- Update flags
                if count = 0 then
                    empty_flag <= '1';
                else
                    empty_flag <= '0';
                end if;

                if count = DEPTH then
                    full_flag <= '1';
                else
                    full_flag <= '0';
                end if;

                if count <= 1 then
                    almost_empty_flag <= '1';
                else
                    almost_empty_flag <= '0';
                end if;

            end if;
        end if;
    end process;

end architecture;
