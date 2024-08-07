Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF42433BB;
	Wed,  7 Aug 2024 03:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002009; cv=none; b=LRL4oBreRL9r9FhuCw/iEQPpLysUm5ue19HEbnnKm9hEBgY5vMpn6fqazqcTq2akCCHzh1eP63pBZd07KzBR08JL31q0WPPzoyfQ9QyS1Mk81RlaPwXhDLQP5P5X1o78oW64CfuMHgbRSt7xnRBgrHr2nHm7MZ9sy3K6SKx2JkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002009; c=relaxed/simple;
	bh=AXUWhKyvnpGSl3g2EVmbeoop8XEjCIpvMlkLO6xEdqY=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=ASCYlQNKBbnGdgKCd9MFSCsfsoicl1RBE0wegO9lLAYWAfS7OF+p5aaUH9Rt79/IKJzmKWjNAXdOXiguxyY0HVN0g/jniipRyJFW8qa/WMy92/lY9SlNDQRxA9+tVBBe/U6gaREZuFdspZxcRznqXwqiFbNeVE3UxrtQGOk41fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lSaRHh7B; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lSaRHh7B"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 259121151AFA;
	Tue,  6 Aug 2024 23:40:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 06 Aug 2024 23:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002006; x=
	1723088406; bh=HQaI5PS6HseqDLWuvlRrlpLlgcbdPON3VBx4p6bEVds=; b=l
	SaRHh7BE+5o/OzMot9MBCtbNXRELunYkXbZuBVTEd56lo4Hqq3qr9v34ECopcyVL
	srDq45stX1nknwr7czQAx1EohTW23vHeFCkfUgsyY/kEhXOOrIltbZz+P7MdZ0TS
	v6HslN1hu0sodhz2dxLe3G6cfCJn9ok5zIWxzCbiOy1FLnyrejnc6Aj5l94pW+NM
	lixo6Zz8fUtAELAR7mhxBPY9MVjea5txjmRi54ip5AqhsbtYHYmcB5McbKEnj/Hj
	s57FEV6W29kGs2HGrv+YqICr6qQTs/hcB3XB3A/x2k9F0Yt1rH2C/AyD1W/lwTzZ
	9gQdTalKjPvnNgmdMNqrQ==
X-ME-Sender: <xms:luyyZoqxb4yU2BgMKPKlaPdAf39OZGIyI6ymM_y6ugQjSIK3K2_OGQ>
    <xme:luyyZuqvPsStPx96D-xMXBTGXcoKXTYCaRmBtUQqMkmQB5mx-752-9r9On0EaFW4Q
    5byNMCqlBDzThkc4Ww>
X-ME-Received: <xmr:luyyZtN61e_8J353a9uycmpwxNVtggaLqwPr_qdo58AvR0cXO4_mOtiqoADEP9YX-TH7Ll10qqCLzcrJTD6To2Nj3m4U7Z__nYU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:luyyZv5JpmPZ2kzHnJl9Nm4fli-NXyYbPQoJ5rU-hRglyBYDGTBLuQ>
    <xmx:luyyZn55s4pS7BAB7KHJgXuepmSuP5-3X_dnRGdD9n_ofKpIYVmUKw>
    <xmx:luyyZviKoBIc9TMl1S0XbPBDeGDOVH_0sMyh9eHTofV349Fx0ADvEA>
    <xmx:luyyZh6Nc8qhVWHr6xdET_DAJ-L25tXOtxnasCHS5z0BFyip4N2C3A>
    <xmx:luyyZhu-dI-_HmEVcsskWiHZta6xRGoJTT8buCnj0KCUR93OdPRGjAJz>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:40:03 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    stable@vger.kernel.org,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <cc38df687ace2c4ffc375a683b2502fc476b600d.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 03/11] scsi: mac_scsi: Disallow bus errors during PDMA send
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

SD cards can produce write latency spikes on the order of a hundred
milliseconds. If the target firmware does not hide that latency during
DATA IN and OUT phases it can cause the PDMA circuitry to raise a
processor bus fault which in turn leads to an unreliable byte count
and a DMA overrun.

The Last Byte Sent flag is used to detect the overrun but this mechanism
is unreliable on some systems. Instead, set a DID_ERROR result whenever
there is a bus fault during a PDMA send, unless the cause was a phase
mismatch.

Cc: stable@vger.kernel.org # 5.15+
Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Fixes: 7c1f3e3447a1 ("scsi: mac_scsi: Treat Last Byte Sent time-out as failure")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/mac_scsi.c | 44 ++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 39814c841113..2e9fad1e3069 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -102,11 +102,15 @@ __setup("mac5380=", mac_scsi_setup);
  * Linux SCSI drivers lack knowledge of the timing behaviour of SCSI targets
  * so bus errors are unavoidable.
  *
- * If a MOVE.B instruction faults, we assume that zero bytes were transferred
- * and simply retry. That assumption probably depends on target behaviour but
- * seems to hold up okay. The NOP provides synchronization: without it the
- * fault can sometimes occur after the program counter has moved past the
- * offending instruction. Post-increment addressing can't be used.
+ * If a MOVE.B instruction faults during a receive operation, we assume the
+ * target sent nothing and try again. That assumption probably depends on
+ * target firmware but it seems to hold up okay. If a fault happens during a
+ * send operation, the target may or may not have seen /ACK and got the byte.
+ * It's uncertain so the whole SCSI command gets retried.
+ *
+ * The NOP is needed for synchronization because the fault address in the
+ * exception stack frame may or may not be the instruction that actually
+ * caused the bus error. Post-increment addressing can't be used.
  */
 
 #define MOVE_BYTE(operands) \
@@ -243,22 +247,21 @@ static inline int mac_pdma_send(unsigned char *start, void __iomem *io, int n)
 	if (n >= 1) {
 		MOVE_BYTE("%0@,%3@");
 		if (result)
-			goto out;
+			return -1;
 	}
 	if (n >= 1 && ((unsigned long)addr & 1)) {
 		MOVE_BYTE("%0@,%3@");
 		if (result)
-			goto out;
+			return -2;
 	}
 	while (n >= 32)
 		MOVE_16_WORDS("%0@+,%3@");
 	while (n >= 2)
 		MOVE_WORD("%0@+,%3@");
 	if (result)
-		return start - addr; /* Negated to indicate uncertain length */
+		return start - addr - 1; /* Negated to indicate uncertain length */
 	if (n == 1)
 		MOVE_BYTE("%0@,%3@");
-out:
 	return addr - start;
 }
 
@@ -307,7 +310,6 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 {
 	u8 __iomem *s = hostdata->pdma_io + (INPUT_DATA_REG << 4);
 	unsigned char *d = dst;
-	int result = 0;
 
 	hostdata->pdma_residual = len;
 
@@ -343,11 +345,12 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 		if (bytes == 0)
 			continue;
 
-		result = -1;
+		if (macscsi_wait_for_drq(hostdata) <= 0)
+			set_host_byte(hostdata->connected, DID_ERROR);
 		break;
 	}
 
-	return result;
+	return 0;
 }
 
 static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
@@ -355,7 +358,6 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 {
 	unsigned char *s = src;
 	u8 __iomem *d = hostdata->pdma_io + (OUTPUT_DATA_REG << 4);
-	int result = 0;
 
 	hostdata->pdma_residual = len;
 
@@ -377,17 +379,8 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 			hostdata->pdma_residual -= bytes;
 		}
 
-		if (hostdata->pdma_residual == 0) {
-			if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
-			                          TCR_LAST_BYTE_SENT,
-			                          TCR_LAST_BYTE_SENT,
-			                          0) < 0) {
-				scmd_printk(KERN_ERR, hostdata->connected,
-				            "%s: Last Byte Sent timeout\n", __func__);
-				result = -1;
-			}
+		if (hostdata->pdma_residual == 0)
 			break;
-		}
 
 		if (bytes > 0)
 			continue;
@@ -400,11 +393,12 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 		if (bytes == 0)
 			continue;
 
-		result = -1;
+		if (macscsi_wait_for_drq(hostdata) <= 0)
+			set_host_byte(hostdata->connected, DID_ERROR);
 		break;
 	}
 
-	return result;
+	return 0;
 }
 
 static int macscsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
-- 
2.39.5

