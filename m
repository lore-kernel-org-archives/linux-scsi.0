Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69A2C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 953C86140D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhDURtW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:49:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:52312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245066AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CA67FB2D8;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/42] qlogicfas408: whitespace cleanup
Date:   Wed, 21 Apr 2021 19:47:28 +0200
Message-Id: <20210421174749.11221-22-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/qlogicfas408.c | 61 +++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index a1eabdc7db09..86de400ca81a 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -4,9 +4,9 @@
    Use at your own risk.  Support Tort Reform so you won't have to read all
    these silly disclaimers.
 
-   Copyright 1994, Tom Zerucha.   
+   Copyright 1994, Tom Zerucha.
    tz@execpc.com
-   
+
    Additional Code, and much appreciated help by
    Michael A. Griffith
    grif@cs.ucr.edu
@@ -22,12 +22,12 @@
 
    Functions as standalone, loadable, and PCMCIA driver, the latter from
    Dave Hinds' PCMCIA package.
-   
+
    Cleaned up 26/10/2002 by Alan Cox <alan@lxorguk.ukuu.org.uk> as part of the 2.5
    SCSI driver cleanup and audit. This driver still needs work on the
    following
-   	-	Non terminating hardware waits
-   	-	Some layering violations with its pcmcia stub
+	-	Non terminating hardware waits
+	-	Some layering violations with its pcmcia stub
 
    Redistributable under terms of the GNU General Public License
 
@@ -92,8 +92,9 @@ static void ql_zap(struct qlogicfas408_priv *priv)
 /*
  *	Do a pseudo-dma tranfer
  */
- 
-static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request, int reqlen)
+
+static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request,
+		   int reqlen)
 {
 	int j;
 	int qbase = priv->qbase;
@@ -108,7 +109,7 @@ static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request, int
 			request += 128;
 		}
 		while (reqlen >= 84 && !(j & 0xc0))	/* 2/3 */
-			if ((j = inb(qbase + 8)) & 4) 
+			if ((j = inb(qbase + 8)) & 4)
 			{
 				insl(qbase + 4, request, 21);
 				reqlen -= 84;
@@ -123,11 +124,11 @@ static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request, int
 		/* until both empty and int (or until reclen is 0) */
 		rtrc(7)
 		j = 0;
-		while (reqlen && !((j & 0x10) && (j & 0xc0))) 
+		while (reqlen && !((j & 0x10) && (j & 0xc0)))
 		{
 			/* while bytes to receive and not empty */
 			j &= 0xc0;
-			while (reqlen && !((j = inb(qbase + 8)) & 0x10)) 
+			while (reqlen && !((j = inb(qbase + 8)) & 0x10))
 			{
 				*request++ = inb(qbase + 4);
 				reqlen--;
@@ -161,7 +162,7 @@ static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request, int
 		    j = 0;
 		while (reqlen && !((j & 2) && (j & 0xc0))) {
 			/* while bytes to send and not full */
-			while (reqlen && !((j = inb(qbase + 8)) & 2)) 
+			while (reqlen && !((j = inb(qbase + 8)) & 2))
 			{
 				outb(*request++, qbase + 4);
 				reqlen--;
@@ -175,7 +176,7 @@ static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request, int
 }
 
 /*
- *	Wait for interrupt flag (polled - not real hardware interrupt) 
+ *	Wait for interrupt flag (polled - not real hardware interrupt)
  */
 
 static int ql_wai(struct qlogicfas408_priv *priv)
@@ -205,14 +206,14 @@ static int ql_wai(struct qlogicfas408_priv *priv)
 }
 
 /*
- *	Initiate scsi command - queueing handler 
+ *	Initiate scsi command - queueing handler
  *	caller must hold host lock
  */
 
 static void ql_icmd(struct scsi_cmnd *cmd)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
-	int 	qbase = priv->qbase;
+	int	qbase = priv->qbase;
 	int	int_type = priv->int_type;
 	unsigned int i;
 
@@ -253,7 +254,7 @@ static void ql_icmd(struct scsi_cmnd *cmd)
 }
 
 /*
- *	Process scsi command - usually after interrupt 
+ *	Process scsi command - usually after interrupt
  */
 
 static void ql_pcmd(struct scsi_cmnd *cmd)
@@ -329,7 +330,7 @@ static void ql_pcmd(struct scsi_cmnd *cmd)
 		rtrc(2);
 		/*
 		 *	Wait for irq (split into second state of irq handler
-		 *	if this can take time) 
+		 *	if this can take time)
 		 */
 		if ((k = ql_wai(priv))) {
 			set_host_byte(cmd, k);
@@ -339,9 +340,9 @@ static void ql_pcmd(struct scsi_cmnd *cmd)
 	}
 
 	/*
-	 *	Enter Status (and Message In) Phase 
+	 *	Enter Status (and Message In) Phase
 	 */
-	 
+
 	k = jiffies + WATCHDOG;
 
 	while (time_before(jiffies, k) && !priv->qabort &&
@@ -375,8 +376,8 @@ static void ql_pcmd(struct scsi_cmnd *cmd)
 	message = inb(qbase + 2);
 
 	/*
-	 *	Should get function complete int if Status and message, else 
-	 *	bus serv if only status 
+	 *	Should get function complete int if Status and message, else
+	 *	bus serv if only status
 	 */
 	if (!((i == 8 && j == 2) || (i == 0x10 && j == 1))) {
 		printk(KERN_ERR "Ql:Error during status phase, int=%02X, %d bytes recd\n", i, j);
@@ -390,9 +391,9 @@ static void ql_pcmd(struct scsi_cmnd *cmd)
 	}
 
 	/*
-	 *	Should get bus service interrupt and disconnect interrupt 
+	 *	Should get bus service interrupt and disconnect interrupt
 	 */
-	 
+
 	i = inb(qbase + 5);	/* should be bus service */
 	while (!priv->qabort && ((i & 0x20) != 0x20)) {
 		barrier();
@@ -414,7 +415,7 @@ static void ql_pcmd(struct scsi_cmnd *cmd)
 }
 
 /*
- *	Interrupt handler 
+ *	Interrupt handler
  */
 
 static void ql_ihandl(void *dev_id)
@@ -438,8 +439,8 @@ static void ql_ihandl(void *dev_id)
 	ql_pcmd(icmd);
 	priv->qlcmd = NULL;
 	/*
-	 *	If result is CHECK CONDITION done calls qcommand to request 
-	 *	sense 
+	 *	If result is CHECK CONDITION done calls qcommand to request
+	 *	sense
 	 */
 	(icmd->scsi_done) (icmd);
 }
@@ -484,8 +485,8 @@ static int qlogicfas408_queuecommand_lck(struct scsi_cmnd *cmd,
 
 DEF_SCSI_QCMD(qlogicfas408_queuecommand)
 
-/* 
- *	Return bios parameters 
+/*
+ *	Return bios parameters
  */
 
 int qlogicfas408_biosparam(struct scsi_device *disk, struct block_device *dev,
@@ -510,7 +511,7 @@ int qlogicfas408_biosparam(struct scsi_device *disk, struct block_device *dev,
 /*
  *	Abort a command in progress
  */
- 
+
 int qlogicfas408_abort(struct scsi_cmnd *cmd)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
@@ -589,9 +590,9 @@ void qlogicfas408_setup(int qbase, int id, int int_type)
 
 int qlogicfas408_detect(int qbase, int int_type)
 {
-        REG1;
+	REG1;
 	return (((inb(qbase + 0xe) ^ inb(qbase + 0xe)) == 7) &&
-	       ((inb(qbase + 0xe) ^ inb(qbase + 0xe)) == 7));		
+		((inb(qbase + 0xe) ^ inb(qbase + 0xe)) == 7));
 }
 
 /*
-- 
2.29.2

