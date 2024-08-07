Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D08119149B;
	Wed,  7 Aug 2024 03:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002044; cv=none; b=tmc2TPVw8ceSA0g7eDNXEQ7f6bcy+7nceN/f8QHhcEHX4Ue3+FbePbDk1K/7nNt9ctPG5VPBYbjtaWcTjPRQ2nLWpYAwSEWaMtql/ZaDytjRIPNrBAVIKeqpGZRNYxMmBB1hv2855ZrPM9LNn6lbrOrWs32MWNzj1ziwDSY+cOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002044; c=relaxed/simple;
	bh=GNU32m9KdeB5kbgCrfjZ2KBpDLrY/RVEA6Uz9KUVz/c=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=bisyFBzeiqr818SEuvsw7t1/H24uo76zMj4RNIYn+KdpKZadzoFuvlWw2ZHgTUlG78O8kjXe6sHEjSPugPgH45bAOwsKnp07xxlhqCtoG5sUdz+ChR6RTUWPyj8TW/HKt/mTaT39hxtCPVlNWcIqewQ7Gvfrn+yAp3ylMPOBcZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QXmjgVnd; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QXmjgVnd"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfout.nyi.internal (Postfix) with ESMTP id 89F68138FD07;
	Tue,  6 Aug 2024 23:40:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 06 Aug 2024 23:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002041; x=
	1723088441; bh=egUzzAe7vvnFliIK8YUcPQSQAMPTfZC930nIdp1FlpA=; b=Q
	XmjgVndfQFHJMSJQDtoOO1FRmeOJllOdX73/C40F/KVmffoaMzRuLfdYAnuwpuKR
	LdlsUy/LSVJjFDk5JKdwN7pqoWMK6rby+keY4nnqZBZQqMA/ch9Dyy2P6JQI2yPY
	FC7ksnPEGidlxRmZub02fPN9W3R28JYdtKabhjt9OeRfHelC/ZbXwqTMnyKgLFyW
	hX52Pd5R9eG1eW2Ul0pX37vrv1lqlAEuNtv1TOgT1ea9Jf8eMyv8VW5KHnM5eARV
	f8bvoxcnozrjVOIvvYuRsL6rkGk0J++7D/6y3Z3n6ZdTapanyemkmQXVoQVayWF9
	7Nx9UtcrlBKM11zshyjQg==
X-ME-Sender: <xms:ueyyZk4VjSqNrFwxhKsJ1sSjEpv3uIWZizEUX_58tNR52U8g-QRbrQ>
    <xme:ueyyZl5CFG88weRDTUcmYV78kKNXeQzvL_1Si8oL7OdNK2QPOnzagfClxlteXxHcP
    5B7AFIxfBBHANGVPMY>
X-ME-Received: <xmr:ueyyZjcOSSmcAUoagc_4cT_lidu1I2jFvoDOQClNDvzd4yiRGZV655wSIh8XeYctmETRJZhpclpE4Q5JEYOuuJ0BadsPXMlQSBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:ueyyZpLjd0ioplEkC4WGMCC1OIbJmAzlPEysRRsABRxKcq-JofRqcA>
    <xmx:ueyyZoLVXDRxgmxBi664QLgR4lrbBOs3-zEQaQyXL4IyTdZQCdA-tg>
    <xmx:ueyyZqxQGMSgQWj879l7h0iz0NoiLlUUNKEY5W_PR6D3pdhg8E7yFg>
    <xmx:ueyyZsJyAlDF0Rs5Knr4OcVkz29E77dOfASLW1QN2vcxwbR8A9dqqg>
    <xmx:ueyyZhogq6GNQV1G_cj459-e3dfbPlhMJCsT_GmSilI0k8vUAUDY74TO>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:40:39 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <d253dddaf4d9bc17b8ee02ea2b731d92f25b16f1.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 07/11] scsi: NCR5380: Handle BSY signal loss during
 information transfer phases
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Improve robustness by checking for a lost BSY signal during the
information transfer loop. The status register is being polled anyway,
so a BSY check costs nothing. BSY signal loss could be caused by a
target error or a kicked plug etc. A bus reset is another possibility
but that is already handled and hostdata->connected would be NULL.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/NCR5380.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 4fcb73b727aa..8a9df2ab9569 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1244,8 +1244,6 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
  * is in same phase.
  *
  * Also, *phase, *count, *data are modified in place.
- *
- * XXX Note : handling for bus free may be useful.
  */
 
 /*
@@ -1277,8 +1275,8 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 		 * valid
 		 */
 
-		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ,
-					  HZ * can_sleep) < 0)
+		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ | SR_BSY,
+					  SR_REQ | SR_BSY, HZ * can_sleep) < 0)
 			break;
 
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ asserted\n");
@@ -1666,9 +1664,6 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
  * Side effects : SCSI things happen, the disconnected queue will be
  * modified if a command disconnects, *instance->connected will
  * change.
- *
- * XXX Note : we need to watch for bus free or a reset condition here
- * to recover from an unexpected bus free condition.
  */
 
 static void NCR5380_information_transfer(struct Scsi_Host *instance)
@@ -2009,9 +2004,20 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				NCR5380_dprint(NDEBUG_ANY, instance);
 			} /* switch(phase) */
 		} else {
+			int err;
+
 			spin_unlock_irq(&hostdata->lock);
-			NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ);
+			err = NCR5380_poll_politely(hostdata, STATUS_REG,
+						    SR_REQ, SR_REQ, HZ);
 			spin_lock_irq(&hostdata->lock);
+
+			if (err < 0 && hostdata->connected &&
+			    !(NCR5380_read(STATUS_REG) & SR_BSY)) {
+				scmd_printk(KERN_ERR, hostdata->connected,
+					    "BSY signal lost\n");
+				do_reset(instance);
+				bus_reset_cleanup(instance);
+			}
 		}
 	}
 }
-- 
2.39.5

