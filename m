From: domen@coderock.org
Subject: [patch 1/2] FlashPoint: comments cleanup
Date: Sat, 14 May 2005 00:23:57 +0200
Message-ID: <20050513222357.028490000@nd47.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:57493 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262595AbVEMWZm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 18:25:42 -0400
Content-Disposition: inline; filename=comments-drivers_scsi_FlashPoint
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@mail.ru>, domen@coderock.org

From: Alexey Dobriyan <adobriyan@mail.ru>


[apply defines-drivers_scsi_FlashPoint.patch before this one]

* Remove duplicate copyright notices.
* Remove duplicate license notices.
* Remove SCM expansion strings from 1997. Hope nobody will miss them.
* Remove commented out (to allow compilation) #include's.

  The driver was merged as a single huge file cat'ted together from many small
  ones. These #include's should have been deleted long ago.

* Remove "#ifndef #define #endif" from cat'ted together headers.
* Remove commented out #include's of non-existent files.

Signed-off-by: Alexey Dobriyan <adobriyan@mail.ru>
Signed-off-by: Domen Puncer <domen@coderock.org>
---
 FlashPoint.c |  496 ++---------------------------------------------------------
 1 files changed, 22 insertions(+), 474 deletions(-)

Index: quilt/drivers/scsi/FlashPoint.c
===================================================================
--- quilt.orig/drivers/scsi/FlashPoint.c
+++ quilt/drivers/scsi/FlashPoint.c
@@ -149,32 +149,11 @@
 #define utilEEWriteOnOff		FPT_utilEEWriteOnOff
 #define utilUpdateResidual		FPT_utilUpdateResidual
 
-
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   globals.h  $
- *
- *   Description:  Common shared global defines.
- *
- *   $Date: 1996/09/04 01:26:13 $
- *
- *   $Revision: 1.11 $
- *
- *----------------------------------------------------------------------*/
-#ifndef __GLOBALS_H__
-#define __GLOBALS_H__
+/* Common shared global defines. */
 
 #define _UCB_MGR_  1
 #define _SCCB_MGR_ 2
 
-/*#include <osflags.h>*/
-
 #define MAX_CDBLEN  12
 
 #define SCAM_LEV_2	1
@@ -262,35 +241,7 @@ typedef u32bits 	* pu32bits;
 	#define OS_UnLock(x)
 #endif /* !defined(OS_InPortByte) */
 
-
-
-
-#endif  /* __GLOBALS_H__ */
-
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   sccbmgr.h  $
- *
- *   Description:  Common shared SCCB Interface defines and SCCB 
- *						 Manager specifics defines.
- *
- *   $Date: 1996/10/24 23:09:33 $
- *
- *   $Revision: 1.14 $
- *
- *----------------------------------------------------------------------*/
-
-#ifndef __SCCB_H__
-#define __SCCB_H__
-
-/*#include <osflags.h>*/
-/*#include <globals.h>*/
+/* Common shared SCCB Interface defines and SCCB Manager specifics defines. */
 
 #if defined(BUGBUG)
 #define debug_size 32
@@ -545,32 +496,7 @@ typedef struct _SCCB {
 
 #endif  // (FW_TYPE == _SCCB_MGR_)
 
-#endif  /* __SCCB_H__ */
-
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   blx30.h  $
- *
- *   Description: This module contains SCCB/UCB Manager implementation
- *                specific stuff.
- *
- *   $Date: 1996/11/13 18:34:22 $
- *
- *   $Revision: 1.10 $
- *
- *----------------------------------------------------------------------*/
-
-
-#ifndef __blx30_H__
-#define __blx30_H__
-
-/*#include <globals.h>*/
+/* SCCB/UCB Manager implementation specific stuff. */
 
 #define  ORION_FW_REV      3110
 
@@ -624,35 +550,7 @@ typedef struct _SCCB {
 	#define WRW_HARPOON(ioport,val)       OS_OutPortWord((u32bits)ioport,(u16bits)val)
 	#define WR_HARP32(ioport,offset,data)  OS_OutPortLong((u32bits)(ioport + offset), data)
 
-
-
-#endif  /* __BLX30_H__ */
-
-
-/*----------------------------------------------------------------------
- * 
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   target.h  $
- *
- *   Description:  Definitions for Target related structures
- *
- *   $Date: 1996/12/11 22:06:20 $
- *
- *   $Revision: 1.9 $
- *
- *----------------------------------------------------------------------*/
-
-#ifndef __TARGET__
-#define __TARGET__
-
-/*#include <globals.h>*/
-/*#include <blx30.h>*/
-
+/* Definitions for Target related structures */
 
 #define  TAR_SYNC_MASK     (BIT(7)+BIT(6))
 #define  SYNC_UNKNOWN      0x00
@@ -799,29 +697,7 @@ typedef struct SCCBscam_info {
     
 } SCCBSCAM_INFO, *PSCCBSCAM_INFO;
 
-#endif
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   scsi2.h  $
- *
- *   Description:  Register definitions for HARPOON ASIC.
- *
- *   $Date: 1996/11/13 18:32:57 $
- *
- *   $Revision: 1.4 $
- *
- *----------------------------------------------------------------------*/
-
-#ifndef __SCSI_H__
-#define __SCSI_H__
-
-
+/* Register definitions for HARPOON ASIC. */
 
 #define  SCSI_TEST_UNIT_READY    0x00
 #define  SCSI_REZERO_UNIT        0x01
@@ -931,29 +807,7 @@ typedef struct SCCBscam_info {
 #define  SYNC5MBS                0x32
 #define  MAX_OFFSET              0x0F  /* Maxbyteoffset for Sync Xfers */
 
-#endif
-/*----------------------------------------------------------------------
- *  
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   eeprom.h  $
- *
- *   Description:  Definitions for EEPROM related structures
- *
- *   $Date: 1996/11/13 18:28:39 $
- *
- *   $Revision: 1.4 $
- *
- *----------------------------------------------------------------------*/
-
-#ifndef __EEPROM__
-#define __EEPROM__
-
-/*#include <globals.h>*/
+/* Definitions for EEPROM related structures */
 
 #define  EEPROM_WD_CNT     256
 
@@ -1015,32 +869,7 @@ typedef struct SCCBscam_info {
    #define  WIDE_NEGO_BIT     BIT(7)
    #define  DISC_ENABLE_BIT   BIT(6)
 
-
-#endif
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   harpoon.h  $
- *
- *   Description:  Register definitions for HARPOON ASIC.
- *
- *   $Date: 1997/07/09 21:44:36 $
- *
- *   $Revision: 1.9 $
- *
- *----------------------------------------------------------------------*/
-
-
-/*#include <globals.h>*/
-
-#ifndef __HARPOON__
-#define __HARPOON__
-
+/* Register definitions for HARPOON ASIC. */
 
    #define  hp_vendor_id_0       0x00		/* LSB */
       #define  ORION_VEND_0   0x4B
@@ -1744,11 +1573,6 @@ typedef struct SCCBscam_info {
 #define MENABLE_INT(p_port) (WR_HARPOON(p_port+hp_page_ctrl, \
                              (RD_HARPOON(p_port+hp_page_ctrl) & ~G_INT_DISABLE)))
 
-
-
-#endif
-
-
 #if (FW_TYPE==_UCB_MGR_)
 void ReadNVRam(PSCCBcard pCurrCard,PUCB p_ucb);
 void WriteNVRam(PSCCBcard pCurrCard,PUCB p_ucb);
@@ -1914,42 +1738,8 @@ void Debug_Load(UCHAR p_card, UCHAR p_bu
 
 extern unsigned int SccbGlobalFlags;
 
-
-#ident "$Id: sccb.c 1.18 1997/06/10 16:47:04 mohan Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   sccb.c  $
- *
- *   Description:  Functions relating to handling of the SCCB interface
- *                 between the device driver and the HARPOON.
- *
- *   $Date: 1997/06/10 16:47:04 $
- *
- *   $Revision: 1.18 $
- *
- *----------------------------------------------------------------------*/
-
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-	/*#include <budioctl.h>*/
-#endif
-
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <eeprom.h>*/
-/*#include <scsi2.h>*/
-/*#include <harpoon.h>*/
-
-
+/* Functions relating to handling of the SCCB interface between the device
+   driver and the HARPOON. */
 
 #if (FW_TYPE==_SCCB_MGR_)
 #define mOS_Lock(card)    OS_Lock((PSCCBMGR_INFO)(((PSCCBcard)card)->cardInfo))
@@ -4786,36 +4576,9 @@ void Debug_Load(UCHAR p_card, UCHAR p_bu
 }
 
 #endif
-#ident "$Id: sccb_dat.c 1.10 1997/02/22 03:16:02 awin Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   sccb_dat.c  $
- *
- *   Description:  Functions relating to handling of the SCCB interface 
- *                 between the device driver and the HARPOON.
- *
- *   $Date: 1997/02/22 03:16:02 $
- *
- *   $Revision: 1.10 $
- *
- *----------------------------------------------------------------------*/
 
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-#endif
-
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <harpoon.h>*/
+/* Functions relating to handling of the SCCB interface between the device
+   driver and the HARPOON. */
 
 /*
 **  IMPORTANT NOTE!!!
@@ -4852,40 +4615,9 @@ UCHAR    debug_int[MAX_CARDS][debug_size
 UCHAR    debug_index[MAX_CARDS] = { 0 };
 UCHAR    reserved_1[3] = { 0 };
 #endif
-#ident "$Id: scsi.c 1.23 1997/07/09 21:42:54 mohan Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   scsi.c  $
- *
- *   Description:  Functions for handling SCSI bus functions such as
- *                 selection/reselection, sync negotiation, message-in
- *                 decoding.
- *
- *   $Date: 1997/07/09 21:42:54 $
- *
- *   $Revision: 1.23 $
- *
- *----------------------------------------------------------------------*/
-
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-#endif
-
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <scsi2.h>*/
-/*#include <eeprom.h>*/
-/*#include <harpoon.h>*/
 
+/* Functions for handling SCSI bus functions such as selection/reselection,
+   sync negotiation, message-in decoding. */
 
 /*
 extern SCCBCARD BL_Card[MAX_CARDS];
@@ -6844,40 +6576,8 @@ void sinits(PSCCB p_sccb, UCHAR p_card)
 
 }
 
-
-#ident "$Id: phase.c 1.11 1997/01/31 02:08:49 mohan Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   phase.c  $
- *
- *   Description:  Functions to initially handle the SCSI bus phase when
- *                 the target asserts request (and the automation is not
- *                 enabled to handle the situation).
- *
- *   $Date: 1997/01/31 02:08:49 $
- *
- *   $Revision: 1.11 $
- *
- *----------------------------------------------------------------------*/
-
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-#endif
-
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <scsi2.h>*/
-/*#include <harpoon.h>*/
-
+/* Functions to initially handle the SCSI bus phase when the target asserts
+   request (and the automation is not enabled to handle the situation). */
 
 /*
 extern SCCBCARD BL_Card[MAX_CARDS];
@@ -7486,40 +7186,7 @@ void phaseBusFree(ULONG port, UCHAR p_ca
       } /*end if !=null */
 }
 
-
-
-
-#ident "$Id: automate.c 1.14 1997/01/31 02:11:46 mohan Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   automate.c  $
- *
- *   Description:  Functions relating to programming the automation of
- *                 the HARPOON.
- *
- *   $Date: 1997/01/31 02:11:46 $
- *
- *   $Revision: 1.14 $
- *
- *----------------------------------------------------------------------*/
-
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-#endif
-
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <scsi2.h>*/
-/*#include <harpoon.h>*/
+/* Functions relating to programming the automation of the HARPOON. */
 
 /*
 extern SCCBCARD BL_Card[MAX_CARDS];
@@ -7869,37 +7536,8 @@ void autoCmdCmplt(ULONG p_port, UCHAR p_
 
    queueCmdComplete(&BL_Card[p_card], currSCCB, p_card);
 }
-#ident "$Id: busmstr.c 1.8 1997/01/31 02:10:27 mohan Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   busmstr.c  $
- *
- *   Description:  Functions to start, stop, and abort BusMaster operations.
- *
- *   $Date: 1997/01/31 02:10:27 $
- *
- *   $Revision: 1.8 $
- *
- *----------------------------------------------------------------------*/
-
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-#endif
-
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <scsi2.h>*/
-/*#include <harpoon.h>*/
 
+/* Functions to start, stop, and abort BusMaster operations. */
 
 /*
 extern SCCBCARD BL_Card[MAX_CARDS];
@@ -8477,41 +8115,9 @@ void hostDataXferRestart(PSCCB currSCCB)
       currSCCB->Sccb_XferCnt = currSCCB->DataLength - currSCCB->Sccb_ATC;
       }
 }
-#ident "$Id: scam.c 1.17 1997/03/20 23:49:37 mohan Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   scam.c  $
- *
- *   Description:  Functions relating to handling of the SCAM selection
- *                 and the determination of the SCSI IDs to be assigned
- *                 to all perspective SCSI targets.
- *
- *   $Date: 1997/03/20 23:49:37 $
- *
- *   $Revision: 1.17 $
- *
- *----------------------------------------------------------------------*/
-
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-#endif
-
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <scsi2.h>*/
-/*#include <eeprom.h>*/
-/*#include <harpoon.h>*/
-
 
+/* Functions relating to handling of the SCAM selection and the determination
+   of the SCSI IDs to be assigned to all perspective SCSI targets. */
 
 /*
 extern SCCBMGR_TAR_INFO sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR];
@@ -9542,37 +9148,8 @@ void scsavdi(UCHAR p_card, ULONG p_port)
    utilEEWrite(p_port, sum_data, EEPROM_CHECK_SUM/2);
    utilEEWriteOnOff(p_port,0);   /* Turn off write access */
 }
-#ident "$Id: diagnose.c 1.10 1997/06/10 16:51:47 mohan Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   diagnose.c  $
- *
- *   Description:  Diagnostic funtions for testing the integrity of
- *                 the HARPOON.
- *
- *   $Date: 1997/06/10 16:51:47 $
- *
- *   $Revision: 1.10 $
- *
- *----------------------------------------------------------------------*/
-
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-#endif
 
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <eeprom.h>*/
-/*#include <harpoon.h>*/
+/* Diagnostic funtions for testing the integrity of the HARPOON. */
 
 /*---------------------------------------------------------------------
  *
@@ -9961,37 +9538,8 @@ void DiagEEPROM(ULONG p_port)
 
 }
 
-#ident "$Id: utility.c 1.23 1997/06/10 16:55:06 mohan Exp $"
-/*----------------------------------------------------------------------
- *
- *
- *   Copyright 1995-1996 by Mylex Corporation.  All Rights Reserved
- *
- *   This file is available under both the GNU General Public License
- *   and a BSD-style copyright; see LICENSE.FlashPoint for details.
- *
- *   $Workfile:   utility.c  $
- *
- *   Description:  Utility functions relating to queueing and EEPROM
- *                 manipulation and any other garbage functions.
- *
- *   $Date: 1997/06/10 16:55:06 $
- *
- *   $Revision: 1.23 $
- *
- *----------------------------------------------------------------------*/
-/*#include <globals.h>*/
-
-#if (FW_TYPE==_UCB_MGR_)
-	/*#include <budi.h>*/
-#endif
-
-/*#include <sccbmgr.h>*/
-/*#include <blx30.h>*/
-/*#include <target.h>*/
-/*#include <scsi2.h>*/
-/*#include <harpoon.h>*/
-
+/* Utility functions relating to queueing and EEPROM manipulation and any other
+   garbage functions. */
 
 /*
 extern SCCBCARD BL_Card[MAX_CARDS];

--
