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
--  /   /                  D Flip-Flop with Synchronous Reset and Set (Discontinue in 13.1)
-- /___/   /\     Filename : FDRS.vhd
-- \   \  /  \    Timestamp : Wed Sep  08 2:21:48 PDT 2010
--  \___\/\___\
--
-- Revision:
--    09/08/10 - Initial version.
--    08/23/13 - PR683925 - add invertible pin support.

----- CELL FDRS-----
library IEEE;
use IEEE.STD_LOGIC_1164.all;


library unisim;
use unisim.VPKG.all;
use unisim.VCOMPONENTS.all;

entity FDRS is
  generic(
      INIT  : bit := '0';
      IS_C_INVERTED : bit := '0';
      IS_D_INVERTED : bit := '0';
      IS_R_INVERTED : bit := '0';
      IS_S_INVERTED : bit := '0'
    );
  port(
    Q : out std_ulogic;
    C : in std_ulogic;
    R : in std_ulogic;
    S : in std_ulogic;
    D : in std_ulogic
    );

end FDRS;

architecture FDRS_V of FDRS is
signal D0 : std_ulogic;
signal D_in : std_ulogic;
signal S_in : std_ulogic;
signal IS_D_INVERTED_BIN : std_ulogic := TO_X01(IS_D_INVERTED);
signal IS_S_INVERTED_BIN : std_ulogic := TO_X01(IS_S_INVERTED);

begin
    D_in <= IS_D_INVERTED_BIN xor D;
    S_in <= IS_S_INVERTED_BIN xor S;

    L2 : LUT2
    generic map (
      INIT => X"E"
    )
    port map (
      O  => D0,
      I0  => D_in,
      I1  => S_in
);
    F3 : FDRE
    generic map (
      INIT => INIT,
      IS_C_INVERTED => IS_C_INVERTED,
      IS_R_INVERTED => IS_R_INVERTED
    )
    port map (
      Q  => Q,
      C  => C,
      CE  => '1',
      D => D0,
      R  => R
);

end FDRS_V;
