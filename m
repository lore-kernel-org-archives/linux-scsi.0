Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18194191F78;
	Wed,  7 Aug 2024 03:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002018; cv=none; b=VYrljX98iaThs2fU/tuxeKKHR1G0vwHQ4D5v3wPQdrTv598AuTJYUIbvhZX0FcoEEOtjLlPDN7uhC+j6vm5xTSbCACbajxOlz8iNHoIbylcTPYE1rz1JQsbLTzki9dNvAhU5X7VzRWEnMFzDPjLQ3ZbIEd9eKKhak4Z1/b81NOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002018; c=relaxed/simple;
	bh=WHQKju5TB0Z+Ao/hCxLffpzCct+Fv2WmGoeZEBqS5OU=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=Lzy3iQ9xNUJUE1Gbwu6mGOPkzOFUi5TG/eTzZ7X95iuDRDzMhH9P++rsPe70NSP5yRwVx59oewNC1iUbLgv6JEX5yPCHctwJW12x1v42tyOfNrKE2ZGiy4eLJtmTVBUKVaTI79kq78qZXw2PcRHlhYrUk0n2XN7OrLpTGeP+xtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jv+ShLZA; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jv+ShLZA"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id 24B33138FD02;
	Tue,  6 Aug 2024 23:40:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 06 Aug 2024 23:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002015; x=
	1723088415; bh=nLSp3vSDZw5Ig7kj8JHbE+ZnAS/f759svuZnaVcejT0=; b=j
	v+ShLZAGmsA6wubSOIcmLJYnNt7yic8/uDrQ6b+DClCHQKPDhuQguJlpi5CirOvk
	32I6rPHkP9Pgwa5Jn0Hlam0/QkdlKn8d4y4R2Gav8LWxdlJ5ZhIF0Z4tI8G0Z0S3
	VTxWl1nKvR1vHvD9TCHgGxhvzSpJ8gJ1PDZdzztn9SSs4pXx9I97rld1xWyCTuze
	WLO74iCrz/+vroJcgE3rD7Hu49lNBLJOvjR84v9/3Rs/qiLvggYbGD9jabdOg+Me
	/xHQKCSVk1ITEV6UqueXdt0vpV8cZhxV1v/pZwZr1b/yF2AQpGHZXnRsENApmtm5
	v28CruvZKEJzEahQFsS4w==
X-ME-Sender: <xms:n-yyZh5VyckGMsMXspRzjROumqFD7G_ZCAcnuz7W4kPXCyC0xvl1tw>
    <xme:n-yyZu5N0JDfWLUOpz388dyxFP704HqSj5eXckWZHWkxnr1GPRb0Ji4S9eMp-3f0L
    QisUYj09FkPhaSDS70>
X-ME-Received: <xmr:n-yyZodafQEvWD-1T-yoinP3z29bveh208Mo9_qk-CzeZ0Sqr-VSaqDFmqJmceUWZgJMvYVk4mLN0LzZp9yZGQs1HTAziU9Bwrs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:n-yyZqJBDA2G4Gk7AV_YjpEpJzy3Eo7TeeG3l-YkF7ecwBYrRUcsVA>
    <xmx:n-yyZlJCy8qgBphTLwzUE46dLOeogH1ZzS1ZMbYwT3PWocDjFAge1w>
    <xmx:n-yyZjyFn7bKxDmnWiW5kU4qQV13zqqqxB0DeItyx3YOGXs4r_Qg0g>
    <xmx:n-yyZhI0jWFcWXCG0874hKsiysq31_ypIjxcqJOdXxH1iaJELbIL9Q>
    <xmx:n-yyZqovwedCNBFVUZwyFVsl6dSl8ZuI_PnRs9jgmUcwrJzPtIc1ZwL3>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:40:12 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <99dc7d1f4c825621b5b120963a69f6cd3e9ca659.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 04/11] scsi: NCR5380: Check for phase match during PDMA fixup
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

It's not an error for a target to change the bus phase during a transfer.
Unfortunately, the FLAG_DMA_FIXUP workaround does not allow for that --
a phase change produces a DRQ timeout error and the device borken flag
will be set.

Check the phase match bit during FLAG_DMA_FIXUP processing. Don't forget
to decrement the command residual. While we are here, change
shost_printk() into scmd_printk() for better consistency with other DMA
error messages.

Tested-by: Stan Johnson <userm57@yahoo.com>
Fixes: 55181be8ced1 ("ncr5380: Replace redundant flags with FLAG_NO_DMA_FIXUP")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/NCR5380.c | 78 +++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index cea3a79d538e..00e245173320 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1485,6 +1485,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 				unsigned char **data)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	struct NCR5380_cmd *ncmd = NCR5380_to_ncmd(hostdata->connected);
 	int c = *count;
 	unsigned char p = *phase;
 	unsigned char *d = *data;
@@ -1496,7 +1497,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 		return -1;
 	}
 
-	NCR5380_to_ncmd(hostdata->connected)->phase = p;
+	ncmd->phase = p;
 
 	if (p & SR_IO) {
 		if (hostdata->read_overruns)
@@ -1608,45 +1609,44 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
  * request.
  */
 
-	if (hostdata->flags & FLAG_DMA_FIXUP) {
-		if (p & SR_IO) {
-			/*
-			 * The workaround was to transfer fewer bytes than we
-			 * intended to with the pseudo-DMA read function, wait for
-			 * the chip to latch the last byte, read it, and then disable
-			 * pseudo-DMA mode.
-			 *
-			 * After REQ is asserted, the NCR5380 asserts DRQ and ACK.
-			 * REQ is deasserted when ACK is asserted, and not reasserted
-			 * until ACK goes false.  Since the NCR5380 won't lower ACK
-			 * until DACK is asserted, which won't happen unless we twiddle
-			 * the DMA port or we take the NCR5380 out of DMA mode, we
-			 * can guarantee that we won't handshake another extra
-			 * byte.
-			 */
-
-			if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-			                          BASR_DRQ, BASR_DRQ, 0) < 0) {
-				result = -1;
-				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
-			}
-			if (NCR5380_poll_politely(hostdata, STATUS_REG,
-			                          SR_REQ, 0, 0) < 0) {
-				result = -1;
-				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
-			}
-			d[*count - 1] = NCR5380_read(INPUT_DATA_REG);
-		} else {
-			/*
-			 * Wait for the last byte to be sent.  If REQ is being asserted for
-			 * the byte we're interested, we'll ACK it and it will go false.
-			 */
-			if (NCR5380_poll_politely2(hostdata,
-			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
-			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, 0) < 0) {
-				result = -1;
-				shost_printk(KERN_ERR, instance, "PDMA write: DRQ and phase timeout\n");
+	if ((hostdata->flags & FLAG_DMA_FIXUP) &&
+	    (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
+		/*
+		 * The workaround was to transfer fewer bytes than we
+		 * intended to with the pseudo-DMA receive function, wait for
+		 * the chip to latch the last byte, read it, and then disable
+		 * DMA mode.
+		 *
+		 * After REQ is asserted, the NCR5380 asserts DRQ and ACK.
+		 * REQ is deasserted when ACK is asserted, and not reasserted
+		 * until ACK goes false. Since the NCR5380 won't lower ACK
+		 * until DACK is asserted, which won't happen unless we twiddle
+		 * the DMA port or we take the NCR5380 out of DMA mode, we
+		 * can guarantee that we won't handshake another extra
+		 * byte.
+		 *
+		 * If sending, wait for the last byte to be sent. If REQ is
+		 * being asserted for the byte we're interested, we'll ACK it
+		 * and it will go false.
+		 */
+		if (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
+					   BASR_DRQ, BASR_DRQ, 0)) {
+			if ((p & SR_IO) &&
+			    (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
+				if (!NCR5380_poll_politely(hostdata, STATUS_REG,
+							   SR_REQ, 0, 0)) {
+					d[c] = NCR5380_read(INPUT_DATA_REG);
+					--ncmd->this_residual;
+				} else {
+					result = -1;
+					scmd_printk(KERN_ERR, hostdata->connected,
+						    "PDMA fixup: !REQ timeout\n");
+				}
 			}
+		} else if (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH) {
+			result = -1;
+			scmd_printk(KERN_ERR, hostdata->connected,
+				    "PDMA fixup: DRQ timeout\n");
 		}
 	}
 
-- 
2.39.5

