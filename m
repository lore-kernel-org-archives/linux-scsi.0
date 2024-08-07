Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF5E16D33A;
	Wed,  7 Aug 2024 03:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002034; cv=none; b=P4/paYlGcsoutt5vWztpQ7wlIlkmpVIxNfJgKFlS98wOgRDYZVY6JSeBIQMsFQiLMv1UMRgrZsvxPMH07t8n+CNcCuHFYaIo/7GlcbV96soyo50T1ain7SnIfwzCLqs719t14c7Y9bIdKR2Z50B5/u+HM36LHySVsaZlqI8vp4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002034; c=relaxed/simple;
	bh=kMhox047Tp/K8qC0/o44RL4wbc/V4x4pI9dtcTHlDuA=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=Vn0bwMopS8W3gnD+WDRZuHYW6Pptby5rXkNeItjDbvNqKCBT1cjqYSD+EsIV+E0NvwwxEUZZk5QkiV4gZ8IJr3iiA/NgDJ7wVyc5fslV1EzNBiRzUjalb/Hq/nslTBv+cinr2ORhKmBBv6SqcWWrxiOomScMDadKsrELkJK9naY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JNx7JjrX; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JNx7JjrX"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfout.nyi.internal (Postfix) with ESMTP id 8A1CD138FD05;
	Tue,  6 Aug 2024 23:40:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 06 Aug 2024 23:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002032; x=
	1723088432; bh=jmQ2zlmZiZC69dubowebACwe5xiaU3F+36b99mtz3HU=; b=J
	Nx7JjrXtf9dDfe9M+cFd+pa76/ZXT9SreW8c+9gILC6mFwc5Np3oWd7XDC747jc8
	bftwUGJaJBZsLHiBg9XUcvwXj/DgeDkolB93Y+2Oi5vyNFT61954x3lnmAK34PRa
	WmLQYMaHg0B0oZgIJcgNfYvkLAhPsN+/Eo6yZg4K+DJt+xB2sFZpWLH7FPrxok6O
	gjxuDzduFgRDRpL1RrbF4olQgF/xRuLzmlDKUdMK+nBU508PbcQ0ZFEHqq5aTlNd
	WuX2CV9/atxSdNnMVY1oS5212uJjPauyX0V4a6NBC8Isp14ROfGEtDPh5I0MRlea
	szwuzyCPI+JwnXNNGUzHQ==
X-ME-Sender: <xms:sOyyZhq_qU5r4Bxbqovz3lkvEXyG4uNI9JyCl7lZH7YM5tD9oHlNSg>
    <xme:sOyyZjrW5f_FEYUOyjnzoGES8e-rEQE9sC0bmRQg8IYw5yf--I9GB25pxCJA_gJ3Y
    hn274Ww9gSG28qXTzc>
X-ME-Received: <xmr:sOyyZuOqLDS69zq0kYRHmXP8OyGHiD7T17RN2g-F4hk4Y0ExGIrineJbEkRU4Yji91G6gZ2ZsscNH0dZfB0cEIrAmjFqubM44JM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:sOyyZs4gtABfdhxXegOhvRxSkFS_boJPBCV5jdB7nBE7JRIePUW1_Q>
    <xmx:sOyyZg7QVkARMXgZgWKhUDn7cjYazIWPmalZo6lUGlX9z5aJ5ukWTA>
    <xmx:sOyyZkjGsdX_6nb0rds-37b1EUUDRbdkOn96-8IafmxtLP8pKb6LJQ>
    <xmx:sOyyZi6u02EkQuPhLLGmpaEyhMy-r8wG6lKVLrMSsFuz-xe-DSJZ0Q>
    <xmx:sOyyZvZiuYnNIsHI25wN18bbnPScPntP8B2BH0pGinLiULCrnd8YOt5X>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:40:30 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <52e02a8812ae1a2d810d7f9f7fd800c3ccc320c4.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 06/11] scsi: NCR5380: Initialize buffer for MSG IN and STATUS
 transfers
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Following an incomplete transfer in MSG IN phase, the driver would not
notice the problem and would make use of invalid data. Initialize 'tmp'
appropriately and bail out if no message was received. For STATUS phase,
preserve the existing status code unless a new value was transferred.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/NCR5380.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 00e245173320..4fcb73b727aa 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1807,8 +1807,11 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				return;
 			case PHASE_MSGIN:
 				len = 1;
+				tmp = 0xff;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
+				if (tmp == 0xff)
+					break;
 				ncmd->message = tmp;
 
 				switch (tmp) {
@@ -1996,6 +1999,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				break;
 			case PHASE_STATIN:
 				len = 1;
+				tmp = ncmd->status;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				ncmd->status = tmp;
-- 
2.39.5

