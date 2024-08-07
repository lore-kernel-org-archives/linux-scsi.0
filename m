Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4721917FB;
	Wed,  7 Aug 2024 03:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002060; cv=none; b=SuGZIgk5UHtyhF3Nt7EJicRDEPn1oFAaScU2lsqaSuoeCg/hRhy1ECG0MOgHuOKCEIZ6H+fVlQS2KSc3FMGvzmUndxblIaFiuwTDEY2/Ij7Alg6BkZntfVQ6iH2xO56qh6tUcYCwyWE4vTmLtb0JQkytRWj7pJlc+FL0LJtweRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002060; c=relaxed/simple;
	bh=8YbE6nPplrm7iAQje3AFjR0Z0EounlM+vOraxHzgHcA=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=FOcXoWUoFPkv6OAjx1+MQnrbJQdSxgDhv2Vx8GE7y8pkAToOAMIzdgBFLQo1OAsZF7LLDNcUxAw3TY4NfzYy8X/VHIUj6TmIvZLwKeYXmDR6yzJnv6g/EwQtT9UqgrH1Qdp5dmspq4RseyuaVi3U0eGraaYB7q06g+QTeDRb8kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=a5UOBiOn; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="a5UOBiOn"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id 2354D138FD0C;
	Tue,  6 Aug 2024 23:40:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 06 Aug 2024 23:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002058; x=
	1723088458; bh=50tsiTsAoFPq4H1EooO1tYntxdLY9J4eOgbEeowimQw=; b=a
	5UOBiOnqPu5ZLJUowBp07ed+2j/Ls283PAWD894Mnyzh+RRDrgmFuZIk3lKz6FGe
	UD5renSl3Gd5SkVOz+vg/SA0B+VTNcTjoZL9yBDOe00ZbMyh83LfmBf1gGtvTtlw
	dha/K4HNZ79Y3jVRcnXCPcVnrulRl5TlkoRruIl6I97COWs05Ov0abErhGQMqaD0
	1aPol25kn+Pz4u9Kq3Hj4108UbUcTxcwi/9TgrE044YLw97gVI4OyApowRIy66ES
	AlAofDuC1vOGZrJupus1ZuG5sbuGh1fgngzEEUMtRW2fgKH9pe47TP0V0Pp8YoGm
	lO0+jIv6H9hhzF6I77U/g==
X-ME-Sender: <xms:yuyyZsMjOaRz0khTHE2XVv6_MFd7BQ0LtQsZUbCdGzwvyroNYqdr5g>
    <xme:yuyyZi-IL5z1xDY94swmvi48QyhiHTZozWgvCUGa-lR7SgLd40ytwGapPt0GbqcyI
    BREgWcOjPRIkB5BTig>
X-ME-Received: <xmr:yuyyZjSOS3lw71hF8MHMaNYoCo-27aJ2I-B-xL40-fu2HStQDHMwDE2nQPt6DCZ9qe6elMsANoEAk2Ml9PD8aIQCsIElkPmPD8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:yuyyZkuwwfuo7nq8XXp-WfU0ct1EIhE5hEyTdU7GFJaQQAY3L2Ll7Q>
    <xmx:yuyyZkc2QwGZWMEBdMwt0in7baYdLvF0ZGuD5_A8IMCpNXtVGvn54A>
    <xmx:yuyyZo2CvAh6iOobhzY9NxxiyrWKzSTvka-kXQ3MX-cmHSNV7d7CXw>
    <xmx:yuyyZo_VJyiy1swIpBSWsIeX1BRFb8LQwfDnM3MN0-XcSs2GOnQyWQ>
    <xmx:yuyyZit8105a1wGtQd4--eEeThB5pIeSAWhbm1tnM7MBkpds7lxYq6lg>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:40:55 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <c07a52d0d7610b4b9969d6dd4fc9a62458fe15de.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 09/11] scsi: NCR5380: Remove redundant result calculation from
 NCR5380_transfer_pio()
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

NCR5380_transfer_pio() returns an ambiguous value which is ignored by
callers. Make it void and remove the redundant calculation. Adopt
kernel-doc format for the updated description.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/NCR5380.c | 34 +++++++++++-----------------------
 drivers/scsi/NCR5380.h |  5 +++--
 2 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index a47a825e7220..931b2581a33d 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1227,22 +1227,15 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	return ret;
 }
 
-/*
- * Function : int NCR5380_transfer_pio (struct Scsi_Host *instance,
- * unsigned char *phase, int *count, unsigned char **data)
- *
- * Purpose : transfers data in given phase using polled I/O
- *
- * Inputs : instance - instance of driver, *phase - pointer to
- * what phase is expected, *count - pointer to number of
- * bytes to transfer, **data - pointer to data pointer,
- * can_sleep - 1 or 0 when sleeping is permitted or not, respectively.
- *
- * Returns : -1 when different phase is entered without transferring
- * maximum number of bytes, 0 if all bytes are transferred or exit
- * is in same phase.
+/**
+ * NCR5380_transfer_pio() - transfers data in given phase using polled I/O
+ * @instance: instance of driver
+ * @phase: pointer to what phase is expected
+ * @count: pointer to number of bytes to transfer
+ * @data: pointer to data pointer
+ * @can_sleep: 1 or 0 when sleeping is permitted or not, respectively
  *
- * Also, *phase, *count, *data are modified in place.
+ * Returns: void. *phase, *count, *data are modified in place.
  */
 
 /*
@@ -1251,9 +1244,9 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
  * counts, we will always do a pseudo DMA or DMA transfer.
  */
 
-static int NCR5380_transfer_pio(struct Scsi_Host *instance,
-				unsigned char *phase, int *count,
-				unsigned char **data, unsigned int can_sleep)
+static void NCR5380_transfer_pio(struct Scsi_Host *instance,
+				 unsigned char *phase, int *count,
+				 unsigned char **data, unsigned int can_sleep)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char p = *phase, tmp;
@@ -1358,11 +1351,6 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 		*phase = tmp & PHASE_MASK;
 	else
 		*phase = PHASE_UNKNOWN;
-
-	if (!c || (*phase == p))
-		return 0;
-	else
-		return -1;
 }
 
 /**
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 84db14b036e4..64a1c6ce5e1b 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -285,8 +285,9 @@ static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static bool NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
-static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data,
-				unsigned int can_sleep);
+static void NCR5380_transfer_pio(struct Scsi_Host *instance,
+				 unsigned char *phase, int *count,
+				 unsigned char **data, unsigned int can_sleep);
 static int NCR5380_poll_politely2(struct NCR5380_hostdata *,
                                   unsigned int, u8, u8,
                                   unsigned int, u8, u8, unsigned long);
-- 
2.39.5

