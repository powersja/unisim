-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 11.1
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  Static Synchronous RAM 32-Deep by 1-Wide
-- /___/   /\     Filename : RAM32X1S.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:56:48 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    11/28/11 - Change bit attribute to std_logic (CR591750)
--    01/16/12 - 591750, 586884 - revert change severe IP impact.
--    04/18/13 - PR683925 - add invertible pin support.
-- End Revision

----- CELL RAM32X1S -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library UNISIM;
use UNISIM.VPKG.all;

entity RAM32X1S is
  generic (
    INIT : bit_vector(31 downto 0) := X"00000000";
    IS_WCLK_INVERTED : bit := '0'
    );

  port (
    O : out std_ulogic;

    A0   : in std_ulogic;
    A1   : in std_ulogic;
    A2   : in std_ulogic;
    A3   : in std_ulogic;
    A4   : in std_ulogic;
    D    : in std_ulogic;
    WCLK : in std_ulogic;
    WE   : in std_ulogic
    );
end RAM32X1S;

architecture RAM32X1S_V of RAM32X1S is
  signal MEM : std_logic_vector(32 downto 0) := ('X' & To_StdLogicVector(INIT));
  signal WCLK_in : std_ulogic;
  signal A_in    : std_logic_vector(4 downto 0);
  signal D_in    : std_ulogic;
  signal WE_in   : std_ulogic;

  signal IS_WCLK_INVERTED_BIN : std_ulogic;

begin

  WCLK_in <= WCLK xor IS_WCLK_INVERTED_BIN;
  WE_in   <= WE;
  A_in    <= A4 & A3 & A2 & A1 & A0;
  D_in    <= D;

  IS_WCLK_INVERTED_BIN <= TO_X01(IS_WCLK_INVERTED);

  FunctionalReadBehavior  : process(A_in, MEM)
    variable Index   : integer := 32;

  begin
    Index   := SLV_TO_INT(SLV => A_in);
    O <= MEM(Index);      
  end process FunctionalReadBehavior;

  FunctionalWriteBehavior : process(WCLK_in)
    variable Index   : integer := 32;

  begin
    if (rising_edge(WCLK_in)) then
      if (WE_in = '1') then
        Index   := SLV_TO_INT(SLV => A_in);
        MEM(Index) <= D_in after 100 ps;
      end if;
    end if;
  end process FunctionalWriteBehavior;
end RAM32X1S_V;
