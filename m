Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F04191F90;
	Wed,  7 Aug 2024 03:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002077; cv=none; b=mk2j8orS/gGRIv9myd0I7fuAGOYYporGQkn4UtEMAaFwnm0NRBfxqZcVFzRVdWRUtm5/84OZxHDRYVIeKrlKkjHGXRcCEbvMS7jjSwyldgg41Rnjw68OQwtSjcN0ZWbMlLK3FDYhHpYxETXw412L2icX/sO2rkAk9lDSACRWDM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002077; c=relaxed/simple;
	bh=yyf1cox5BiOkdER8kNxmiNBigZdyc62wWAdPR40mMNw=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=sDNmR7+gdIS8cJmLyjp//Mp8WcNI7KFGDE4GX33ZnTnC+CeI+N+XumeikAjIGbhjgYFf+DKqybJwqhmjueLGlQnqM1wd4V+Lw/qJS4u+nmVxRlvu3YfUm9ZsoLZsVvGCBR+w2WWa4Ff3Qcdn0SfGUZD85nZgcUhVI3OgJrbrEz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=b7dj+0FY; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="b7dj+0FY"
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id EB4031151AFB;
	Tue,  6 Aug 2024 23:41:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 06 Aug 2024 23:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002074; x=
	1723088474; bh=euujujsMejaizzikdLDY4Z5SumFrPMbcpvsxES5mvjs=; b=b
	7dj+0FY2a5r8rX0dCikP+dtEZH8sN3lMoKf5/1dneYJkHLRg90i4uQBmSP5WU6Q9
	wmth8mJyMQB6AWGskUVuKPRtPJUvNVBGOuPqftNYyAFkuEhTpLJ8QnW2rPHNrJa4
	k1WJyJ88X8ukD6NjoHOVAR5dlOZZxV725LWMoOyuWIbto53yh+46MBLrIM6XebTD
	nfAnrx7myhJ8A2ewVAatyk++YYKlgdBAyCCs8A5Nwl6EwQIbq95s+icoB+B3wAcg
	7qblkb9pxilUz/mAaCYnceIVEeYxgbGOXoW89edzlQD/7SWd2kWzxmzS430wWf9t
	U8McNdyJ3qILahAR5Bkxg==
X-ME-Sender: <xms:2uyyZuG0m0krAkhZOyhbfvgreUoqfAUI0kZwSAXanFknsQEkB6rR9g>
    <xme:2uyyZvVFMGEYJY8l9qbwvR0q7jM9BANzttXzi5DD9-SUAWkhxSwdxKtZCUNU-C9Xk
    jk1xAQZ9gWeyfJr2Ps>
X-ME-Received: <xmr:2uyyZoI_pKuiVbcrYI9ZA4cf2axJ_rnTwS-dlBD2K3LU1YG7-_Hh1b6i81Vq9j5HfVcwa8T6WzWhN07Wz98HoNgWKvFUXMQd-KE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:2uyyZoFCuTIyP-pnU78bd8TngA09Dlt-ibwxjuv3KmYj2IJhlkuBrw>
    <xmx:2uyyZkX70HMidg-8RHHt2mVdvF1BmFmLHsghPTUvL7rbEANlDpYJMg>
    <xmx:2uyyZrOWPQxF2bvwkHOtVaJjylSDw-S29UQPv00QP5YuQcsI81srTg>
    <xmx:2uyyZr2NPyWuMNaUXeLYASg_czXS-Vf5aqGyhg7RGdV2Tcm1XsAdmg>
    <xmx:2uyyZnE3O5MfDhMmRQ_PcNAJ80gjCsRKyLG5lmh4c6i6Wd_a9_e_iV9d>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:41:12 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <8541ea096fde9f8716b79e4f0707aed916a8c58d.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 11/11] scsi: NCR5380: Clean up indentation
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Tidy up a few indentation annoyances. No functional change.

Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/NCR5380.c   | 92 +++++++++++++++++++++-------------------
 drivers/scsi/NCR5380.h   | 14 +++---
 drivers/scsi/sun3_scsi.c |  2 +-
 3 files changed, 56 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 94501773506b..0e10502660de 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1318,17 +1318,19 @@ static void NCR5380_transfer_pio(struct Scsi_Host *instance,
 
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ negated, handshake complete\n");
 
-/*
- * We have several special cases to consider during REQ/ACK handshaking :
- * 1.  We were in MSGOUT phase, and we are on the last byte of the
- * message.  ATN must be dropped as ACK is dropped.
- *
- * 2.  We are in a MSGIN phase, and we are on the last byte of the
- * message.  We must exit with ACK asserted, so that the calling
- * code may raise ATN before dropping ACK to reject the message.
- *
- * 3.  ACK and ATN are clear and the target may proceed as normal.
- */
+		/*
+		 * We have several special cases to consider during REQ/ACK
+		 * handshaking:
+		 *
+		 * 1.  We were in MSGOUT phase, and we are on the last byte of
+		 * the message. ATN must be dropped as ACK is dropped.
+		 *
+		 * 2.  We are in MSGIN phase, and we are on the last byte of the
+		 * message. We must exit with ACK asserted, so that the calling
+		 * code may raise ATN before dropping ACK to reject the message.
+		 *
+		 * 3.  ACK and ATN are clear & the target may proceed as normal.
+		 */
 		if (!(p == PHASE_MSGIN && c == 1)) {
 			if (p == PHASE_MSGOUT && c > 1)
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -1559,39 +1561,41 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 	/* The result is zero iff pseudo DMA send/receive was completed. */
 	hostdata->dma_len = c;
 
-/*
- * A note regarding the DMA errata workarounds for early NMOS silicon.
- *
- * For DMA sends, we want to wait until the last byte has been
- * transferred out over the bus before we turn off DMA mode.  Alas, there
- * seems to be no terribly good way of doing this on a 5380 under all
- * conditions.  For non-scatter-gather operations, we can wait until REQ
- * and ACK both go false, or until a phase mismatch occurs.  Gather-sends
- * are nastier, since the device will be expecting more data than we
- * are prepared to send it, and REQ will remain asserted.  On a 53C8[01] we
- * could test Last Byte Sent to assure transfer (I imagine this is precisely
- * why this signal was added to the newer chips) but on the older 538[01]
- * this signal does not exist.  The workaround for this lack is a watchdog;
- * we bail out of the wait-loop after a modest amount of wait-time if
- * the usual exit conditions are not met.  Not a terribly clean or
- * correct solution :-%
- *
- * DMA receive is equally tricky due to a nasty characteristic of the NCR5380.
- * If the chip is in DMA receive mode, it will respond to a target's
- * REQ by latching the SCSI data into the INPUT DATA register and asserting
- * ACK, even if it has _already_ been notified by the DMA controller that
- * the current DMA transfer has completed!  If the NCR5380 is then taken
- * out of DMA mode, this already-acknowledged byte is lost. This is
- * not a problem for "one DMA transfer per READ command", because
- * the situation will never arise... either all of the data is DMA'ed
- * properly, or the target switches to MESSAGE IN phase to signal a
- * disconnection (either operation bringing the DMA to a clean halt).
- * However, in order to handle scatter-receive, we must work around the
- * problem.  The chosen fix is to DMA fewer bytes, then check for the
- * condition before taking the NCR5380 out of DMA mode.  One or two extra
- * bytes are transferred via PIO as necessary to fill out the original
- * request.
- */
+	/*
+	 * A note regarding the DMA errata workarounds for early NMOS silicon.
+	 *
+	 * For DMA sends, we want to wait until the last byte has been
+	 * transferred out over the bus before we turn off DMA mode. Alas, there
+	 * seems to be no terribly good way of doing this on a 5380 under all
+	 * conditions. For non-scatter-gather operations, we can wait until REQ
+	 * and ACK both go false, or until a phase mismatch occurs. Gather-sends
+	 * are nastier, since the device will be expecting more data than we
+	 * are prepared to send it, and REQ will remain asserted. On a 53C8[01]
+	 * we could test Last Byte Sent to assure transfer (I imagine this is
+	 * precisely why this signal was added to the newer chips) but on the
+	 * older 538[01] this signal does not exist. The workaround for this
+	 * lack is a watchdog; we bail out of the wait-loop after a modest
+	 * amount of wait-time if the usual exit conditions are not met.
+	 * Not a terribly clean or correct solution :-%
+	 *
+	 * DMA receive is equally tricky due to a nasty characteristic of the
+	 * NCR5380. If the chip is in DMA receive mode, it will respond to a
+	 * target's REQ by latching the SCSI data into the INPUT DATA register
+	 * and asserting ACK, even if it has _already_ been notified by the
+	 * DMA controller that the current DMA transfer has completed! If the
+	 * NCR5380 is then taken out of DMA mode, this already-acknowledged
+	 * byte is lost.
+	 *
+	 * This is not a problem for "one DMA transfer per READ
+	 * command", because the situation will never arise... either all of
+	 * the data is DMA'ed properly, or the target switches to MESSAGE IN
+	 * phase to signal a disconnection (either operation bringing the DMA
+	 * to a clean halt). However, in order to handle scatter-receive, we
+	 * must work around the problem. The chosen fix is to DMA fewer bytes,
+	 * then check for the condition before taking the NCR5380 out of DMA
+	 * mode. One or two extra bytes are transferred via PIO as necessary
+	 * to fill out the original request.
+	 */
 
 	if ((hostdata->flags & FLAG_DMA_FIXUP) &&
 	    (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 64a1c6ce5e1b..d402d4bffcb2 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -3,10 +3,10 @@
  * NCR 5380 defines
  *
  * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix consulting and custom programming)
- * 	drew@colorado.edu
- *      +1 (303) 666-5836
+ * Visionary Computing
+ * (Unix consulting and custom programming)
+ * drew@colorado.edu
+ * +1 (303) 666-5836
  *
  * For more information, please consult 
  *
@@ -78,7 +78,7 @@
 #define ICR_DIFF_ENABLE		0x20	/* wo Set to enable diff. drivers */
 #define ICR_ASSERT_ACK		0x10	/* rw ini Set to assert ACK */
 #define ICR_ASSERT_BSY		0x08	/* rw Set to assert BSY */
-#define ICR_ASSERT_SEL 		0x04	/* rw Set to assert SEL */
+#define ICR_ASSERT_SEL		0x04	/* rw Set to assert SEL */
 #define ICR_ASSERT_ATN		0x02	/* rw Set to assert ATN */
 #define ICR_ASSERT_DATA		0x01	/* rw SCSI_DATA_REG is asserted */
 
@@ -135,7 +135,7 @@
 #define BASR_IRQ		0x10	/* ro mirror of IRQ pin */
 #define BASR_PHASE_MATCH	0x08	/* ro Set when MSG CD IO match TCR */
 #define BASR_BUSY_ERROR		0x04	/* ro Unexpected change to inactive state */
-#define BASR_ATN 		0x02	/* ro BUS status */
+#define BASR_ATN		0x02	/* ro BUS status */
 #define BASR_ACK		0x01	/* ro BUS status */
 
 /* Write any value to this register to start a DMA send */
@@ -170,7 +170,7 @@
 #define CSR_BASE CSR_53C80_INTR
 
 /* Note : PHASE_* macros are based on the values of the STATUS register */
-#define PHASE_MASK 	(SR_MSG | SR_CD | SR_IO)
+#define PHASE_MASK		(SR_MSG | SR_CD | SR_IO)
 
 #define PHASE_DATAOUT		0
 #define PHASE_DATAIN		SR_IO
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 4a8cc2e8238e..3d7075714e34 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -304,7 +304,7 @@ static int sun3scsi_dma_setup(struct NCR5380_hostdata *hostdata,
 	sun3_udc_write(UDC_INT_ENABLE, UDC_CSR);
 #endif
 	
-       	return count;
+	return count;
 
 }
 
-- 
2.39.5

