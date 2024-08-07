Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65273190694;
	Wed,  7 Aug 2024 03:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002000; cv=none; b=lrdFbB/be6LyiJ9fdV8Csi3eEM1fJvWEKRX7xCFjwF6AcqaTUbOA+bVKp9b4v413lYgBtd+rdsWFcqxKjpvYZLlIbpB6/ldUT531MZfxTlZjWPy6qUuvpZgcFpJL9IyuZZzfrzbKMDpf52gE18LqQv08GbMCttHRD7JK9QOV7HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002000; c=relaxed/simple;
	bh=zmQ7FLn937aqNLXWbETQcKd+1lShqmdyDK+Kj437yz4=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=EZYp/UNtfoDjwTYJ5pIJ0Cyfn1JL+qkmAriATHMZe0zcmzrCtK3ive3vM39tEeVb9VsFctp3i/9g4MKEXEr9kvBo3JoeT/dGYZam1daX2VJIDICelD0mXFGxnhc9A0w0BJNE+j8YqFn7TCJPSqC/oty9suYcFZl9H/y8zvqjSGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PyHWaTgZ; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PyHWaTgZ"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 60C781151AEF;
	Tue,  6 Aug 2024 23:39:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 06 Aug 2024 23:39:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723001997; x=
	1723088397; bh=HiFYafSvcnXA44ixp6a1R6FngnT8UiO0RXK9ZEi00Nc=; b=P
	yHWaTgZf2mtVP8j2uuH7qIgMNJFOwo21SEo6Q7Qha5+mw7tkfEKQewdK9GFhW8r4
	8GUwhIryMkfmKsJlPOrguDBmDtyGNtE1FW48KQLQtEB5WmHUn3s++HCUsS9EHWWE
	kOZ/AlJpng5NBl7NMS1f4sbn2L4ayr+3irdkHR5Dz6aJRM8wAm4vid3gQGHnKPx/
	msfMF4PCQGhxCaaT3HBgGhSnS6+eECss+ILgubxLLEWSxbbbeoP0/TZFHm5ONSVK
	vCJZ3y63sGfA/lSD/a6v4vHTD/Qt7mxjWYWphDQCVM4zW12TG/eYycjkQsfEtoA3
	V+TI8m9TeTOz9bEny/q4w==
X-ME-Sender: <xms:jeyyZrP2XnKKvqlfCLsXj6YPYZl0wIVWYTHxkvZyrxy10-gh5Cqi4A>
    <xme:jeyyZl_4DfNEG6pJ0yfqfU0JZ1JPn-0V_jYUj33dbbf0YmLcsPb4J90sqyqaQBlRx
    JYbMeumtYTf-gKxcaY>
X-ME-Received: <xmr:jeyyZqRyDFvj8-kUCQTX8GkuSJQ2ztgUIBSOnoWN2DM8Z-TcI6MI1LlWgrp0qVCsk5EoE0sJLJ9tT0YMFgGlf5PEngCJxM810z8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:jeyyZvuTXx-rCeq4kzFR90zoWuqt27LBH45xnR7ioRjZI9RGhQu7dA>
    <xmx:jeyyZjdITYynYnX9IujcF89wyomncuw67u_2IS1DSNfeNTKWOi_V2w>
    <xmx:jeyyZr3FY_HwXNlp3ncmySUy15rZaoZ9IPJOnpW6isQDk0JyBRlcRQ>
    <xmx:jeyyZv-Q_A1OWtz6xTObUrwv3RoFVX3qQDU8bGJaTUYDzNUIx5FBmg>
    <xmx:jeyyZixMDeHq9Z0hCYsgHPL6W68J5m8ph8GGOWzmk0sNgqWSfdToVely>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:39:54 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    stable@vger.kernel.org,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <6a5ffabb4290c0d138c6d285fda8fa3902e926f0.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 02/11] scsi: mac_scsi: Refactor polling loop
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Before the error handling can be revised, some preparation is needed.
Refactor the polling loop with a new function, macscsi_wait_for_drq().
This function will gain more call sites in the next patch.

Cc: stable@vger.kernel.org # 5.15+
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
This is not really a bug fix, but has been sent to @stable because it is a
prerequisite for the bug fixes which follow.
---
 drivers/scsi/mac_scsi.c | 80 +++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 5ae8f4a1e9ca..39814c841113 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -208,8 +208,6 @@ __setup("mac5380=", mac_scsi_setup);
 		".previous                     \n" \
 		: "+a" (addr), "+r" (n), "+r" (result) : "a" (io))
 
-#define MAC_PDMA_DELAY		32
-
 static inline int mac_pdma_recv(void __iomem *io, unsigned char *start, int n)
 {
 	unsigned char *addr = start;
@@ -274,6 +272,36 @@ static inline void write_ctrl_reg(struct NCR5380_hostdata *hostdata, u32 value)
 	out_be32(hostdata->io + (CTRL_REG << 4), value);
 }
 
+static inline int macscsi_wait_for_drq(struct NCR5380_hostdata *hostdata)
+{
+	unsigned int n = 1; /* effectively multiplies NCR5380_REG_POLL_TIME */
+	unsigned char basr;
+
+again:
+	basr = NCR5380_read(BUS_AND_STATUS_REG);
+
+	if (!(basr & BASR_PHASE_MATCH))
+		return 1;
+
+	if (basr & BASR_IRQ)
+		return -1;
+
+	if (basr & BASR_DRQ)
+		return 0;
+
+	if (n-- == 0) {
+		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
+		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
+			 "%s: DRQ timeout\n", __func__);
+		return -1;
+	}
+
+	NCR5380_poll_politely2(hostdata,
+			       BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
+			       BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, 0);
+	goto again;
+}
+
 static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
                                 unsigned char *dst, int len)
 {
@@ -283,9 +311,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 
 	hostdata->pdma_residual = len;
 
-	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-	                              BASR_DRQ | BASR_PHASE_MATCH,
-	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
+	while (macscsi_wait_for_drq(hostdata) == 0) {
 		int bytes, chunk_bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
@@ -295,19 +321,16 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 		chunk_bytes = min(hostdata->pdma_residual, 512);
 		bytes = mac_pdma_recv(s, d, chunk_bytes);
 
+		if (macintosh_config->ident == MAC_MODEL_IIFX)
+			write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
+
 		if (bytes > 0) {
 			d += bytes;
 			hostdata->pdma_residual -= bytes;
 		}
 
 		if (hostdata->pdma_residual == 0)
-			goto out;
-
-		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
-			goto out;
-
-		if (bytes == 0)
-			udelay(MAC_PDMA_DELAY);
+			break;
 
 		if (bytes > 0)
 			continue;
@@ -321,16 +344,9 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 			continue;
 
 		result = -1;
-		goto out;
+		break;
 	}
 
-	scmd_printk(KERN_ERR, hostdata->connected,
-	            "%s: phase mismatch or !DRQ\n", __func__);
-	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-	result = -1;
-out:
-	if (macintosh_config->ident == MAC_MODEL_IIFX)
-		write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
 	return result;
 }
 
@@ -343,9 +359,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 
 	hostdata->pdma_residual = len;
 
-	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-	                              BASR_DRQ | BASR_PHASE_MATCH,
-	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
+	while (macscsi_wait_for_drq(hostdata) == 0) {
 		int bytes, chunk_bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
@@ -355,6 +369,9 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 		chunk_bytes = min(hostdata->pdma_residual, 512);
 		bytes = mac_pdma_send(s, d, chunk_bytes);
 
+		if (macintosh_config->ident == MAC_MODEL_IIFX)
+			write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
+
 		if (bytes > 0) {
 			s += bytes;
 			hostdata->pdma_residual -= bytes;
@@ -369,15 +386,9 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 				            "%s: Last Byte Sent timeout\n", __func__);
 				result = -1;
 			}
-			goto out;
+			break;
 		}
 
-		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
-			goto out;
-
-		if (bytes == 0)
-			udelay(MAC_PDMA_DELAY);
-
 		if (bytes > 0)
 			continue;
 
@@ -390,16 +401,9 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 			continue;
 
 		result = -1;
-		goto out;
+		break;
 	}
 
-	scmd_printk(KERN_ERR, hostdata->connected,
-	            "%s: phase mismatch or !DRQ\n", __func__);
-	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-	result = -1;
-out:
-	if (macintosh_config->ident == MAC_MODEL_IIFX)
-		write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
 	return result;
 }
 
-- 
2.39.5

