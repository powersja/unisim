-- $Header:  $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 12.1
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                 Boundary Scan Logic Control Circuit for SPARTAN6 (Discontinue in 13.1)
-- /___/   /\     Filename : BSCAN_SPARTAN6.vhd
-- \   \  /  \    Timestamp : Wed Oct 13 02:38:56 PDT 2010

--  \___\/\___\
--
-- Revision:
--    10/13/10 - Initial version.

----- CELL BSCAN_SPARTAN6 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library unisim;
use unisim.VPKG.all;
use unisim.VCOMPONENTS.all;

entity BSCAN_SPARTAN6 is
  generic(
        JTAG_CHAIN : integer := 1
        );

  port(
    CAPTURE : out std_ulogic := 'H';
    DRCK    : out std_ulogic := 'H';
    RESET   : out std_ulogic := 'H';
    RUNTEST : out std_ulogic := 'L';
    SEL     : out std_ulogic := 'L';
    SHIFT   : out std_ulogic := 'L';
    TCK     : out std_ulogic := 'L';
    TDI     : out std_ulogic := 'L';
    TMS     : out std_ulogic := 'L';
    UPDATE  : out std_ulogic := 'L';

    TDO     : in std_ulogic := 'X'
    );
end BSCAN_SPARTAN6;

architecture BSCAN_SPARTAN6_V of BSCAN_SPARTAN6 is
begin
    B4 : BSCANE2
     generic map(
      JTAG_CHAIN => JTAG_CHAIN
    )
     port map (
      CAPTURE  => CAPTURE,
      DRCK => DRCK,
      RESET => RESET,
      RUNTEST => RUNTEST,
      SEL => SEL,
      SHIFT => SHIFT,
      TCK => TCK,
      TDI => TDI,
      TMS => TMS,
      UPDATE => UPDATE,
      TDO => TDO
);
end BSCAN_SPARTAN6_V;


