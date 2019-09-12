Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2574AC4CEC7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 17:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02DBD2084F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 17:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfILRrt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 13:47:49 -0400
Received: from gateway22.websitewelcome.com ([192.185.47.168]:26958 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbfILRrt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 13:47:49 -0400
X-Greylist: delayed 1290 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2019 13:47:48 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id F3C5614ABF
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 12:26:17 -0500 (CDT)
Received: from gator3278.hostgator.com ([198.57.247.242])
        by cmsmtp with SMTP
        id 8SrJiOtmE90on8SrJi7vMp; Thu, 12 Sep 2019 12:26:17 -0500
X-Authority-Reason: nr=8
Received: from 89-69-237-178.dynamic.chello.pl ([89.69.237.178]:60840 helo=comp.lan)
        by gator3278.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <arkadiusz@drabczyk.org>)
        id 1i8SrI-002o5v-LP; Thu, 12 Sep 2019 12:26:17 -0500
From:   Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: csiostor: Fix spelling typos
Date:   Thu, 12 Sep 2019 19:25:46 +0200
Message-Id: <20190912172546.16489-1-arkadiusz@drabczyk.org>
X-Mailer: git-send-email 2.9.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator3278.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - drabczyk.org
X-BWhitelist: no
X-Source-IP: 89.69.237.178
X-Source-L: No
X-Exim-ID: 1i8SrI-002o5v-LP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 89-69-237-178.dynamic.chello.pl (comp.lan) [89.69.237.178]:60840
X-Source-Auth: arkadiusz@drabczyk.org
X-Email-Count: 3
X-Source-Cap: cmt1bXZicmg7cmt1bXZicmg7Z2F0b3IzMjc4Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix several spelling typos in comments in csio_hw.c.

Signed-off-by: Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
---
 drivers/scsi/csiostor/csio_hw.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index e519238..950f9cd 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -793,10 +793,10 @@ csio_hw_get_flash_params(struct csio_hw *hw)
 			goto found;
 		}
 
-	/* Decode Flash part size.  The code below looks repetative with
+	/* Decode Flash part size.  The code below looks repetitive with
 	 * common encodings, but that's not guaranteed in the JEDEC
-	 * specification for the Read JADEC ID command.  The only thing that
-	 * we're guaranteed by the JADEC specification is where the
+	 * specification for the Read JEDEC ID command.  The only thing that
+	 * we're guaranteed by the JEDEC specification is where the
 	 * Manufacturer ID is in the returned result.  After that each
 	 * Manufacturer ~could~ encode things completely differently.
 	 * Note, all Flash parts must have 64KB sectors.
@@ -983,8 +983,8 @@ csio_do_hello(struct csio_hw *hw, enum csio_dev_state *state)
 			waiting -= 50;
 
 			/*
-			 * If neither Error nor Initialialized are indicated
-			 * by the firmware keep waiting till we exaust our
+			 * If neither Error nor Initialized are indicated
+			 * by the firmware keep waiting till we exhaust our
 			 * timeout ... and then retry if we haven't exhausted
 			 * our retries ...
 			 */
@@ -1738,7 +1738,7 @@ static void csio_link_l1cfg(struct link_config *lc, uint16_t fw_caps,
 	 * Convert Common Code Forward Error Control settings into the
 	 * Firmware's API.  If the current Requested FEC has "Automatic"
 	 * (IEEE 802.3) specified, then we use whatever the Firmware
-	 * sent us as part of it's IEEE 802.3-based interpratation of
+	 * sent us as part of it's IEEE 802.3-based interpretation of
 	 * the Transceiver Module EPROM FEC parameters.  Otherwise we
 	 * use whatever is in the current Requested FEC settings.
 	 */
@@ -2834,7 +2834,7 @@ csio_hws_configuring(struct csio_hw *hw, enum csio_hw_ev evt)
 }
 
 /*
- * csio_hws_initializing - Initialiazing state
+ * csio_hws_initializing - Initializing state
  * @hw - HW module
  * @evt - Event
  *
@@ -3049,7 +3049,7 @@ csio_hws_removing(struct csio_hw *hw, enum csio_hw_ev evt)
 		if (!csio_is_hw_master(hw))
 			break;
 		/*
-		 * The BYE should have alerady been issued, so we cant
+		 * The BYE should have already been issued, so we can't
 		 * use the mailbox interface. Hence we use the PL_RST
 		 * register directly.
 		 */
@@ -3104,7 +3104,7 @@ csio_hws_pcierr(struct csio_hw *hw, enum csio_hw_ev evt)
  *
  *	A table driven interrupt handler that applies a set of masks to an
  *	interrupt status word and performs the corresponding actions if the
- *	interrupts described by the mask have occured.  The actions include
+ *	interrupts described by the mask have occurred.  The actions include
  *	optionally emitting a warning or alert message. The table is terminated
  *	by an entry specifying mask 0.  Returns the number of fatal interrupt
  *	conditions.
@@ -4219,7 +4219,7 @@ csio_mgmtm_exit(struct csio_mgmtm *mgmtm)
  * @hw:		Pointer to HW module.
  *
  * It is assumed that the initialization is a synchronous operation.
- * So when we return afer posting the event, the HW SM should be in
+ * So when we return after posting the event, the HW SM should be in
  * the ready state, if there were no errors during init.
  */
 int
-- 
2.9.0

