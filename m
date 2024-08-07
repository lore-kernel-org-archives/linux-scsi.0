Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565D215D5AB;
	Wed,  7 Aug 2024 03:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002068; cv=none; b=Db+iRJI/+fFFjVMriIEnS2VCiUDkE1aBJOMSgZA3ZHyjfCjsJp71c7RpCZ41PtAzvYFYsbQkrk0UbThAgIuqHJfTkb/V/ReJx8lPO2O99kv4HTos0J/TnjQMZ1WMfSBpOVcZsHsyfZeMYub2ecXyle88MDrRT5GxJH8SOow0hHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002068; c=relaxed/simple;
	bh=O67O2fVlIYaZyQAS2g6kWfXMRlGRXuuwcBgR0IHz0ps=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=F6bPc+A6z9hIZ42UV+sDonyi1stKtLugtrtw6amv+jNkAy6GY2X/CaIY7YGd8HqtLhTX97DJtn1yrGppmbHF2wPnYAXo19mDNmTZwrbmzBqdY5j0iyiegKST7JdPDNJJTZko3/pbY30UO5lmL3UGvTT/NrJeMjabuLEsTYeDZFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Y7IXKmyZ; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Y7IXKmyZ"
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfout.nyi.internal (Postfix) with ESMTP id 78B1E138FD09;
	Tue,  6 Aug 2024 23:41:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 06 Aug 2024 23:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002066; x=
	1723088466; bh=2c2ciecJJb1jJm1kaXBOvMCtmXLBFReu/hf4ZrVnh44=; b=Y
	7IXKmyZ/xmOIMC4oQo6QCge7RTMuUM5enwANtToTiY98wbAw4gZIG7xifC1ouCRY
	gYJprbtA9Nx2Wyio4IB/gUr57Jw9K9NsuQ+hjsbPhr7cD22USV0S/epPIHJzalX9
	CNC9rA+8kiDMemM9YDG5Z6OwodjHlmX4qPWkdJMNgzWCSq95XkXu+sAwckYgOmX3
	4f8OymWQB90aJnw9JEXQfA5/VaNn0g91QgDjrB3xY4xKG78z5rCqmrMqNdyG/i7i
	yTs8Ga2M1fG7CpJlPm2F9rR1EQnyI/THefPXWoHhpB2IQzrfw2xQjiFVtDuY8Oon
	oQ9D1SQAMNOb+7lvF8u8A==
X-ME-Sender: <xms:0uyyZn_gRJiUgPNstBcUyWsadYW_xF03iM6aAAD_9snkZ9Rr4dXtJg>
    <xme:0uyyZjvMDxaTvCROY89IsnOIRt6QbJIhJjmZb2oLUmq7siMUorwT2a7606Y0GblAt
    U2DbTsHrN6r9IKGUsw>
X-ME-Received: <xmr:0uyyZlBP-_0RDXeWCofLXszzV4tj7D_cdmQLK4cBLD4SSsLrT1QqoHKy_vgFsWfF-L_aVMFhLf-N9q9K_ODOVN7iv0zZPgu7KW4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:0uyyZjcR5q86edyMxx1b-ahwn3Cvs2ZDceVlbXooPp4mcIvjhyg5jw>
    <xmx:0uyyZsOCZGXAC_e9ji8wAuLMM9C862kVIevHtWMPIAbTyWxOphzGRA>
    <xmx:0uyyZll78Z901bVbSQnYO9hwzftrPXTlsI_McblZ4O2PJClW1SPWrQ>
    <xmx:0uyyZmsMTWW3je7AorvTNStUy6heHh6VNOYIREDC-M2yXjaL9TznUw>
    <xmx:0uyyZjfbwFbX0a6b8uJgU7tO5DkbBToaHve0QI9ETgIsXN17fSqwao-a>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:41:04 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <c54aff198b5a60be8ecfd50df0a9a77850730501.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 10/11] scsi: NCR5380: Remove obsolete comment
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

This comment should have been removed in commit e7734ef14ead ("scsi:
NCR5380: Remove context check") when the irqs_disabled() conditional
was removed.

Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/NCR5380.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 931b2581a33d..94501773506b 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -198,7 +198,6 @@ static inline void set_resid_from_SCp(struct scsi_cmnd *cmd)
  * Polls the chip in a reasonably efficient manner waiting for an
  * event to occur. After a short quick poll we begin to yield the CPU
  * (if possible). In irq contexts the time-out is arbitrarily limited.
- * Callers may hold locks as long as they are held in irq mode.
  *
  * Returns 0 if either or both event(s) occurred otherwise -ETIMEDOUT.
  */
-- 
2.39.5

