Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384F6190077;
	Wed,  7 Aug 2024 03:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723001992; cv=none; b=lEZTN2xM7ckHabWX+n/fZYoLfUrBqaJMFxokzCmn6hV9FCxG6n+JnqEL8GyAcpFq9f2VEyOSWvhuSPIvUoZlbuS/CGI6noJ2uFg7yc3Z7De9WsVYk0BWIp5a23ho8Z6Hbl4nMxSsJnlFNPRLTWwHRk9A5bJf32hz0Lj0CCTHpPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723001992; c=relaxed/simple;
	bh=qYQuIcOFTPtzqL1PbxGk9TxMN2OJkD6TyQQSvKpUUU0=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=fFXRme8V4frCIPMRdu9jG8URm2o/go+JBwT41EDODnyHiT5x/RxCZ91VZVgZ8funB26Cq+tzFCz+7DiZ3vkzcd7LCaU96BTqcyd57bc1J3i3R3Oa4eU/MengyAm921GQn03/4or+jhM1tAOlFEsk3YUwu4eD1Po8dzfvfa4ujZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ELIRnuJU; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ELIRnuJU"
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 517821151AE5;
	Tue,  6 Aug 2024 23:39:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 06 Aug 2024 23:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723001988; x=
	1723088388; bh=HGEfU5BmDu4YX25rlEXjLHuCURndhPbFar6LNKiNQgg=; b=E
	LIRnuJURPX/8Eu5xVmXwYLw6ECgdIYpfuQAKB1G8EL/gM43SPA86hNwUku2cJ66g
	rB1sXzVmGJik48dkCJYwCZ/iqd/8QwKYl+6EyZvM0DwvKhaVzg1Q2Kg7ozz9f80M
	7BlsVesxN4QpWyE6F3ZogXCqxw7n4PSYivXkDPPPByW6WFSvZ50bOan3ZcLdyqQz
	XM32yS5cydUyJfk7tC5dzkJMASbVdvGaInW3AGd8HO8mZRYcvqnAmM1SYm3g3i0b
	9JEmN9+9az6IDUWDRoLHQn2xy7r/HWPFktgmR86KUNW/sjtZSdma7rf+sJ5sQ7N+
	d+YCLEz28NQlDQbClnmyA==
X-ME-Sender: <xms:hOyyZqU5YhHEWtbfHnhyzimlVtvLJOp-SwrLPPJ4oznuHRzKJR_nGA>
    <xme:hOyyZmnlrii87QYukvlfQZoFECu0ejFEhyqyDPhrujpOERDdkKiA9YUn9kFSgb2L9
    dncL8aTh5_OT8smalE>
X-ME-Received: <xmr:hOyyZuZbwPYif-4yPumdxIzbtnLChKHgRBzMlr08xJ1CW3gn4LsU-85woAS-bjg-OvsrsMwaaHsKnHolpTwYZoKk2T48drJR-To>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:hOyyZhUxY1MeTLuzi8JNho1X1km88e8lp5sH1cWV_Lr7-gU-m5SuzA>
    <xmx:hOyyZkmI9FBvjsmuzQiT0Ccldn1dOcuYHtu919RRwyg2htmKjhODNw>
    <xmx:hOyyZmc5wpxS6rYkhjLa23ZTxIqw_8d5MnRf3_BqFcyCWmuXxRRnQg>
    <xmx:hOyyZmGM1u25iNzJlgY78wz5sp8U-e9aF58Eexajw9esbtBaDivwhQ>
    <xmx:hOyyZu4JdkOZe4ta2fTzRHfeeThOBmNmDAiE_OXaHjDyyqA051aQk4yN>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:39:45 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    stable@vger.kernel.org,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <7573c79f4e488fc00af2b8a191e257ca945e0409.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 01/11] scsi: mac_scsi: Revise printk(KERN_DEBUG ...) messages
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

After a bus fault, capture and log the chip registers immediately,
if the NDEBUG_PSEUDO_DMA macro is defined. Remove some
printk(KERN_DEBUG ...) messages that aren't needed any more.
Don't skip the debug message when bytes == 0. Show all of the byte
counters in the debug messages.

Cc: stable@vger.kernel.org # 5.15+
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
This is not really a bug fix, but has been sent to @stable because it is a
prerequisite for the bug fixes which follow.
---
 drivers/scsi/mac_scsi.c | 42 +++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index a402c4dc4645..5ae8f4a1e9ca 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -286,13 +286,14 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
 	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
-		int bytes;
+		int bytes, chunk_bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
 			write_ctrl_reg(hostdata, CTRL_HANDSHAKE_MODE |
 			                         CTRL_INTERRUPTS_ENABLE);
 
-		bytes = mac_pdma_recv(s, d, min(hostdata->pdma_residual, 512));
+		chunk_bytes = min(hostdata->pdma_residual, 512);
+		bytes = mac_pdma_recv(s, d, chunk_bytes);
 
 		if (bytes > 0) {
 			d += bytes;
@@ -302,23 +303,23 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 		if (hostdata->pdma_residual == 0)
 			goto out;
 
-		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
-		                           BUS_AND_STATUS_REG, BASR_ACK,
-		                           BASR_ACK, 0) < 0)
-			scmd_printk(KERN_DEBUG, hostdata->connected,
-			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
 			goto out;
 
 		if (bytes == 0)
 			udelay(MAC_PDMA_DELAY);
 
-		if (bytes >= 0)
+		if (bytes > 0)
 			continue;
 
-		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
-		         "%s: bus error (%d/%d)\n", __func__, d - dst, len);
 		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
+		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
+			 "%s: bus error [%d/%d] (%d/%d)\n",
+			 __func__, d - dst, len, bytes, chunk_bytes);
+
+		if (bytes == 0)
+			continue;
+
 		result = -1;
 		goto out;
 	}
@@ -345,13 +346,14 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
 	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
-		int bytes;
+		int bytes, chunk_bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
 			write_ctrl_reg(hostdata, CTRL_HANDSHAKE_MODE |
 			                         CTRL_INTERRUPTS_ENABLE);
 
-		bytes = mac_pdma_send(s, d, min(hostdata->pdma_residual, 512));
+		chunk_bytes = min(hostdata->pdma_residual, 512);
+		bytes = mac_pdma_send(s, d, chunk_bytes);
 
 		if (bytes > 0) {
 			s += bytes;
@@ -370,23 +372,23 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 			goto out;
 		}
 
-		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
-		                           BUS_AND_STATUS_REG, BASR_ACK,
-		                           BASR_ACK, 0) < 0)
-			scmd_printk(KERN_DEBUG, hostdata->connected,
-			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
 			goto out;
 
 		if (bytes == 0)
 			udelay(MAC_PDMA_DELAY);
 
-		if (bytes >= 0)
+		if (bytes > 0)
 			continue;
 
-		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
-		         "%s: bus error (%d/%d)\n", __func__, s - src, len);
 		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
+		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
+			 "%s: bus error [%d/%d] (%d/%d)\n",
+			 __func__, s - src, len, bytes, chunk_bytes);
+
+		if (bytes == 0)
+			continue;
+
 		result = -1;
 		goto out;
 	}
-- 
2.39.5

