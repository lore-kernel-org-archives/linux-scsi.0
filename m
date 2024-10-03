Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19993B1A4;
	Thu,  3 Oct 2024 03:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727926334; cv=none; b=tBCAyU7WS9ZUxbOsszOS/Q4wK9TqZ/kqlrHi13k6486Avs5GY85bOikDSQKrbLvSMRvG89b4YHvAokDnUMowwQityVnuSCFLLvzTnhPGQEHrNSzi2Z4/GAS4i1m1lbSrhZw2C7rVU3gp6Oun+uQp5pyXw+o3wkulxygVxWOJHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727926334; c=relaxed/simple;
	bh=O6n4NsHyPQfXtZWMch4uSDm3io15hVHMMOVd1ReBV3k=;
	h=To:Cc:Message-Id:From:Subject:Date; b=LP+QhWHIzPqk6bVX6uigXOBTmWA5GbbKhTHuHiV9mq2IcIFk2p54SbPjViH04GC6idtYb3KNfRTuO4s8IyooGQ1HiVPjTUC/bEYTpfc7rP634bAGVvjArZ3T47EI/EMMrWQT79dom6GyBoXON+SNCNkYUiQRCRWZquWRoR43to0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JcC2gzZk; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JcC2gzZk"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id C5076138045A;
	Wed,  2 Oct 2024 23:32:11 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 02 Oct 2024 23:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:message-id:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1727926331; x=1728012731; bh=OyW+gAZ6TAVsu
	pReIbSn1i1eWUwWnwLcod9OA3LP83M=; b=JcC2gzZkVJt/iq5boJ/WctrbrX/lt
	xAKnpDl42fbFLW4FW3RP7+lER0lEbGnOvF8CL9x70v1LA973B4Cofe2NK+0UYQ6d
	p2img1mrBWW58bnwB4Ozd3fKGe9Wjetqdv99o7rzKWCNsiJn3pMUZH/eXMB8MXuw
	pg0Lne32DbeauoMcNxg+PoGxTs8MQZa3t1pfYskNm65aJ/8LCre7MPbZMQtFCce2
	GCegpi10BoAj2wuyjTLP7KUtqgUB2E/hD7/Lc4iOcosfjquBPpsuSZrTgzYZ2RVz
	zimASGtRJPC8pcmUk2UJPKqKN0lXOhkJPcHkE5BFgIv3BtwZSBbw0ct6g==
X-ME-Sender: <xms:OxD-ZhO9DNaAohNebc8GjD79mNvjJUtWvIqu7GC3clBCZJN1Cmd_Aw>
    <xme:OxD-Zj-vxaS4Ypy7A8s7ygf1jUiYToYRN8--m7kqOI7XuLGF1-1DAIQQT0IJv7O_d
    AFvYVNwppkcN4y9UGM>
X-ME-Received: <xmr:OxD-ZgSQEuunoKgu9XiS6GURJWVK1nnhzRSqLjy9x4ELhDIZ5c_iUFPufKT9p0OsLZ0QAGJTrXFs5EQ3lDLnL8bKVEGbF1sRkuY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvtddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepvfevkffhufffsedttdertddttddtnecuhfhrohhm
    pefhihhnnhcuvfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqe
    enucggtffrrghtthgvrhhnpeehfffggeefveegvedtiefffeevuedtgefhueehieetffej
    fefggeevfeeuvdduleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgpdhnsggprhgtphht
    thhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehjrghmvghsrdgsohhtth
    homhhlvgihsehhrghnshgvnhhprghrthhnvghrshhhihhprdgtohhmpdhrtghpthhtohep
    mhgrrhhtihhnrdhpvghtvghrshgvnhesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepug
    grnhhivghlsedtgidtfhdrtghomhdprhgtphhtthhopehstghhmhhithiimhhitgesghhm
    rghilhdrtghomhdprhgtphhtthhopehsthgrsghlvgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqshgtshhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:OxD-ZttV3kQrOccry644dSLZpnVOJBpbI6cmFUHon1_vCAu_B84W4Q>
    <xmx:OxD-ZpcU9V9SsXA8V8mhL7gnYEdA34_-x71Fe9ea5uBTGSLTF0B-9w>
    <xmx:OxD-Zp0K9HlFrbf2p2BAkG-wLFecM8ch_qvko_mTDBNrCzOPN-ziAA>
    <xmx:OxD-Zl8ky4_R0swFzO36pBns_5Va3clu7H2RCVyhalc-J3spEGP8Fw>
    <xmx:OxD-ZhSNv-q2Y58ENepU3oADfeYFXuGSubcgJjlDBAxysg7mybqdmpNm>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Oct 2024 23:32:09 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Daniel Palmer" <daniel@0x0f.com>,
    "Michael Schmitz" <schmitzmic@gmail.com>,
    stable@kernel.org,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <09e11a0a54e6aa2a88bd214526d305aaf018f523.1727926187.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH] scsi: wd33c93: Don't use stale scsi_pointer value
Date: Thu, 03 Oct 2024 13:29:47 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

From: Daniel Palmer <daniel@0x0f.com>

A regression was introduced with commit dbb2da557a6a ("scsi: wd33c93: Move
the SCSI pointer to private command data") which results in an oops in
wd33c93_intr(). That commit added the scsi_pointer variable and
initialized it from hostdata->connected. However, during selection,
hostdata->connected is not yet valid. Fix this by getting the current
scsi_pointer from hostdata->selecting.

Cc: Daniel Palmer <daniel@0x0f.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@kernel.org
Fixes: dbb2da557a6a ("scsi: wd33c93: Move the SCSI pointer to private command data")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Co-developed-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/wd33c93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index a44b60c9004a..dd1fef9226f2 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -831,7 +831,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		/* construct an IDENTIFY message with correct disconnect bit */
 
 		hostdata->outgoing_msg[0] = IDENTIFY(0, cmd->device->lun);
-		if (scsi_pointer->phase)
+		if (WD33C93_scsi_pointer(cmd)->phase)
 			hostdata->outgoing_msg[0] |= 0x40;
 
 		if (hostdata->sync_stat[cmd->device->id] == SS_FIRST) {
-- 
2.39.5

