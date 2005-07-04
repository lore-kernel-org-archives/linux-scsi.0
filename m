From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/9] qla1280: use SAM_ constants
Date: Mon, 4 Jul 2005 17:48:36 +0200
Message-ID: <20050704154836.GE30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:51404 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261311AbVGDPsl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:48:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thiemo Seufer <ths@linux-mips.org>

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-06-19 21:12:55.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.c	2005-06-19 21:14:45.000000000 +0200
@@ -4049,7 +4049,7 @@
 		/* Save ISP completion status */
 		CMD_RESULT(cmd) = qla1280_return_status(pkt, cmd);
 
-		if (scsi_status & SS_CHECK_CONDITION) {
+		if (scsi_status & SAM_STAT_CHECK_CONDITION) {
 			if (comp_status != CS_ARS_FAILED) {
 				uint16_t req_sense_length =
 					le16_to_cpu(pkt->req_sense_length);
Index: linux-2.6/drivers/scsi/qla1280.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.h	2005-06-19 20:48:36.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.h	2005-06-19 21:14:52.000000000 +0200
@@ -979,14 +979,6 @@
 #define CS_RETRY            0x82	/* Driver defined */
 
 /*
- * ISP status entry - SCSI status byte bit definitions.
- */
-#define SS_CHECK_CONDITION  BIT_1
-#define SS_CONDITION_MET    BIT_2
-#define SS_BUSY_CONDITION   BIT_3
-#define SS_RESERVE_CONFLICT (BIT_4 | BIT_3)
-
-/*
  * ISP target entries - Option flags bit definitions.
  */
 #define OF_ENABLE_TAG       BIT_1	/* Tagged queue action enable */
