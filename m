Received: from iad-out-005.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-005.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.211.80.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE8443DA23;
	Wed,  1 Apr 2026 13:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.211.80.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050630; cv=none; b=U0sTyK4zWuBKnKpAMdCGXPXCE+T3R9xopQoHwkIl0DVLqDGILYxFG/5q58YIqKK3Gpafz/6AtpOvncM1eDFquXxQRvnWld8ACd93BYJzVoHbTyzKHzHOgemib5efESHlmNAumjDeEwadMXfAKTElVPUJ4UPhnssOc+w0FIDu6hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050630; c=relaxed/simple;
	bh=3xvN3w6SnmA8quBEkyn+GZeH+zMeWFsT8ga3lGlXgPA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eHU8dkx6J73bk9JTmNIjTK5M6xqs9SKqEMZpXrHPwUDOUZgZZtLIjLeb97Ik4cirgMo5sIaOUsHPnZbJQ9lvN0Gpg6Yg8XmPZ0iP9OW6HQI9JKubzxE8U4qS9CAhwRmVx+wNL8tbZSuDRQV6+CTQy3gEISP7fNzToR9Dj2xnxkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=W6/JtSJI; arc=none smtp.client-ip=3.211.80.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="W6/JtSJI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775050628; x=1806586628;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=OF/Wc7TK+OsFr31ZdtePyiprlbzI65l7D2fgL0og7g8=;
  b=W6/JtSJIeILxxa3ITEpRSZKz4+G7G5QYn6Zs3K8srh35b/IqMMUMQLTq
   HweLWtq1iFgE8CotPe1hUR58046dD5EEX7pUJJdlLgYG0CQeCV07Y5kq5
   Ub0Kp1o3eajnO7bFf5sLJ8Qh8Juub9kuUk+b9rt7fJogFlSjaWp3qp0C2
   0gXRtYMgrlNjFeVmg1mfSRIaVR1EuPjrAni5gNg/wLsfcHSuAW2z0xDom
   n7dniiTmxb4QI9iNqTlufGjyRnjSJepvLcZhFewBlVHUFIw9+Rq3fCXl8
   tm3iV2DrW+hTsEt22u7pHlNT0d6NR55hpzFkzunQA1sSM79tprwKwI47s
   g==;
X-CSE-ConnectionGUID: UMssy2gNTFW+S4U/A5mK4A==
X-CSE-MsgGUID: j2rWxdH+QcqQjtHpTDJFrQ==
X-IronPort-AV: E=Sophos;i="6.23,153,1770595200"; 
   d="scan'208";a="15275470"
Received: from ip-10-4-7-229.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.7.229])
  by internal-iad-out-005.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 13:37:04 +0000
Received: from EX19MTAUEC002.ant.amazon.com [72.21.198.66:5147]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.8.197:2525] with esmtp (Farcaster)
 id 5da5a075-cb06-4684-aedc-ecbaf014acc0; Wed, 1 Apr 2026 13:37:04 +0000 (UTC)
X-Farcaster-Flow-ID: 5da5a075-cb06-4684-aedc-ecbaf014acc0
Received: from EX19D012UEC001.ant.amazon.com (10.252.135.206) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:37:03 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC001.ant.amazon.com (10.252.135.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:37:03 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Wed, 1 Apr 2026 13:37:03 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Heyne, Maximilian" <mheyne@amazon.de>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Sven Peter <sven@svenpeter.dev>, "Chaitanya
 Kulkarni" <kch@nvidia.com>, Keith Busch <kbusch@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Hector Martin <marcan@marcan.st>, Alyssa Rosenzweig
	<alyssa@rosenzweig.io>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van Assche
	<bvanassche@acm.org>, Sasha Levin <sashal@kernel.org>, Peter Wang
	<peter.wang@mediatek.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Seunghui Lee <sh043.lee@samsung.com>, Sanjeev Yadav <sanjeev.y@mediatek.com>,
	Wonkon Kim <wkon.kim@samsung.com>, Brian Kao <powenkao@google.com>, "Hannes
 Reinecke" <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"asahi@lists.linux.dev" <asahi@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y 5/8] nvme-apple: remove an extra queue reference
Thread-Topic: [PATCH 6.1.y 5/8] nvme-apple: remove an extra queue reference
Thread-Index: AQHcwdyfxKwQXg5Z9kGUiGR8yB37yw==
Date: Wed, 1 Apr 2026 13:37:03 +0000
Message-ID: <20260401-pliny-ashley-ff03a0b6@mheyne-amazon>
References: <20260401-defer-gleam-5226cb65@mheyne-amazon>
In-Reply-To: <20260401-defer-gleam-5226cb65@mheyne-amazon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 941f7298c70c7668416e7845fa76eb72c07d966b ]

Now that blk_mq_destroy_queue does not release the queue reference, there
is no need for a second admin queue reference to be held by the
apple_nvme structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20221018135720.670094-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 drivers/nvme/host/apple.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index c5fc293c22123..c84ebfcfdeb88 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1507,15 +1507,6 @@ static int apple_nvme_probe(struct platform_device *=
pdev)
 		goto put_dev;
 	}
 =

-	if (!blk_get_queue(anv->ctrl.admin_q)) {
-		nvme_start_admin_queue(&anv->ctrl);
-		blk_mq_destroy_queue(anv->ctrl.admin_q);
-		blk_put_queue(anv->ctrl.admin_q);
-		anv->ctrl.admin_q =3D NULL;
-		ret =3D -ENODEV;
-		goto put_dev;
-	}
-
 	nvme_reset_ctrl(&anv->ctrl);
 	async_schedule(apple_nvme_async_probe, anv);
 =

-- =

2.50.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

