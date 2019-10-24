Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1DFCA9EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 15:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4588E2166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 15:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503187AbfJXP0i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:26:38 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:39430 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503092AbfJXP0i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 11:26:38 -0400
Received: from ramsan ([84.195.182.253])
        by michel.telenet-ops.be with bizsmtp
        id HTSa2100D5USYZQ06TSaTu; Thu, 24 Oct 2019 17:26:35 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNf0U-00077A-IL; Thu, 24 Oct 2019 17:26:34 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNf0U-0007vR-Fq; Thu, 24 Oct 2019 17:26:34 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Russell King <linux@armlinux.org.uk>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        Jiri Kosina <trivial@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] scsi: Fix various misspellings of "connect"
Date:   Thu, 24 Oct 2019 17:26:33 +0200
Message-Id: <20191024152633.30404-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix misspellings of "disonnect", "reconnect", "connection", "connected",
and "disconnection".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/scsi/arm/acornscsi.c          | 4 ++--
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h | 2 +-
 drivers/scsi/isci/remote_device.c     | 2 +-
 drivers/scsi/ncr53c8xx.c              | 2 +-
 drivers/scsi/nsp32.c                  | 2 +-
 drivers/scsi/qedf/qedf_dbg.h          | 2 +-
 drivers/scsi/qedi/qedi_dbg.h          | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index d12dd89538df2990..ddb52e7ba6226b51 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -1067,7 +1067,7 @@ void acornscsi_dma_setup(AS_Host *host, dmadir_t direction)
  * Purpose : ensure that all DMA transfers are up-to-date & host->scsi.SCp is correct
  * Params  : host - host to finish
  * Notes   : This is called when a command is:
- *		terminating, RESTORE_POINTERS, SAVE_POINTERS, DISCONECT
+ *		terminating, RESTORE_POINTERS, SAVE_POINTERS, DISCONNECT
  *	   : This must not return until all transfers are completed.
  */
 static
@@ -1816,7 +1816,7 @@ int acornscsi_reconnect(AS_Host *host)
 }
 
 /*
- * Function: int acornscsi_reconect_finish(AS_Host *host)
+ * Function: int acornscsi_reconnect_finish(AS_Host *host)
  * Purpose : finish reconnecting a command
  * Params  : host - host to complete
  * Returns : 0 if failed
diff --git a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
index e4469df9c4695ab9..698f5ebaa0c29f98 100644
--- a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
+++ b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
@@ -813,7 +813,7 @@ struct fcoe_confqe {
 
 
 /*
- * FCoE conection data base
+ * FCoE connection data base
  */
 struct fcoe_conn_db {
 #if defined(__BIG_ENDIAN)
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 49aa4e657c44fc65..cd1e4b4d95bbbba0 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1504,7 +1504,7 @@ static enum sci_status isci_remote_device_construct(struct isci_port *iport,
  * This function builds the isci_remote_device when a libsas dev_found message
  *    is received.
  * @isci_host: This parameter specifies the isci host object.
- * @port: This parameter specifies the isci_port conected to this device.
+ * @port: This parameter specifies the isci_port connected to this device.
  *
  * pointer to new isci_remote_device.
  */
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index e0b427fdf81800c3..11a2cb844ecb3782 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -1722,7 +1722,7 @@ struct ncb {
 	**	Miscellaneous configuration and status parameters.
 	**----------------------------------------------------------------
 	*/
-	u_char		disc;		/* Diconnection allowed		*/
+	u_char		disc;		/* Disconnection allowed	*/
 	u_char		scsi_mode;	/* Current SCSI BUS mode	*/
 	u_char		order;		/* Tag order to use		*/
 	u_char		verbose;	/* Verbosity for this controller*/
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 70db79254155677d..b6e04d14292d2f90 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1542,7 +1542,7 @@ static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
  * with ACK reply when below condition is matched:
  *	MsgIn 00: Command Complete.
  *	MsgIn 02: Save Data Pointer.
- *	MsgIn 04: Diconnect.
+ *	MsgIn 04: Disconnect.
  * In other case, unexpected BUSFREE is detected.
  */
 static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
diff --git a/drivers/scsi/qedf/qedf_dbg.h b/drivers/scsi/qedf/qedf_dbg.h
index d979f095aeda06a8..2386bfb73c4616aa 100644
--- a/drivers/scsi/qedf/qedf_dbg.h
+++ b/drivers/scsi/qedf/qedf_dbg.h
@@ -42,7 +42,7 @@ extern uint qedf_debug;
 #define QEDF_LOG_LPORT		0x4000		/* lport logs */
 #define QEDF_LOG_ELS		0x8000		/* ELS logs */
 #define QEDF_LOG_NPIV		0x10000		/* NPIV logs */
-#define QEDF_LOG_SESS		0x20000		/* Conection setup, cleanup */
+#define QEDF_LOG_SESS		0x20000		/* Connection setup, cleanup */
 #define QEDF_LOG_TID		0x80000         /*
 						 * FW TID context acquire
 						 * free
diff --git a/drivers/scsi/qedi/qedi_dbg.h b/drivers/scsi/qedi/qedi_dbg.h
index 243acc8b520a44a5..37d084086fd43410 100644
--- a/drivers/scsi/qedi/qedi_dbg.h
+++ b/drivers/scsi/qedi/qedi_dbg.h
@@ -44,7 +44,7 @@ extern uint qedi_dbg_log;
 #define QEDI_LOG_LPORT		0x4000		/* lport logs */
 #define QEDI_LOG_ELS		0x8000		/* ELS logs */
 #define QEDI_LOG_NPIV		0x10000		/* NPIV logs */
-#define QEDI_LOG_SESS		0x20000		/* Conection setup, cleanup */
+#define QEDI_LOG_SESS		0x20000		/* Connection setup, cleanup */
 #define QEDI_LOG_UIO		0x40000		/* iSCSI UIO logs */
 #define QEDI_LOG_TID		0x80000         /* FW TID context acquire,
 						 * free
-- 
2.17.1

