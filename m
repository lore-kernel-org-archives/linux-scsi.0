From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_aic7xxx_aic7xxx_core.c, typo: the the
Date: Tue, 20 Aug 2002 18:56:54 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020820041035.604ED2C49B@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Justin Gibbs <gibbs@btc.adaptec.com>, linux-scsi@vger.kernel.org

[ Hi Justin: trivial typos.  Please send to Marcelo. ]
From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.4.20-pre4/drivers/scsi/aic7xxx/aic7xxx_core.c.orig	2002-08-20 18:00:45.000000000 +1000
+++ trivial-2.4.20-pre4/drivers/scsi/aic7xxx/aic7xxx_core.c	2002-08-20 18:00:45.000000000 +1000
@@ -4367,7 +4367,7 @@
 	/*
 	 * DMA tag for our command fifos and other data in system memory
 	 * the card's sequencer must be able to access.  For initiator
-	 * roles, we need to allocate space for the the qinfifo and qoutfifo.
+	 * roles, we need to allocate space for the qinfifo and qoutfifo.
 	 * The qinfifo and qoutfifo are composed of 256 1 byte elements. 
 	 * When providing for the target mode role, we must additionally
 	 * provide space for the incoming target command fifo and an extra
@@ -6928,7 +6928,7 @@
 		panic("ahc_update_scsiid called on non-multitid unit\n");
 
 	/*
-	 * Since we will rely on the the TARGID mask
+	 * Since we will rely on the TARGID mask
 	 * for selection enables, ensure that OID
 	 * in SCSIID is not set to some other ID
 	 * that we don't want to allow selections on.
-- 
  Don't blame me: the Monkey is driving
  File: James Mayer <james@cobaltmountain.com>: drivers_scsi_aic7xxx_aic7xxx_core.c, typo: the the
