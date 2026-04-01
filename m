Received: from iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.198.218.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E53743E485;
	Wed,  1 Apr 2026 13:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.198.218.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050632; cv=none; b=mtjf625H5NOPck6eoFyoOcrCbo+nU8Mw3oriPinp28rp3Gvl8zFq0PlJuIJuTNH0o3y3kV2YrVFeq4EE8sc0MOUoQcTHtgzlLG8ekHzxHfc02JJpBTK5xMTM4IMijGUToy9TZszYkNFfEVFo/n6Ku/kNQYWCL9l9qeC4lErp7jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050632; c=relaxed/simple;
	bh=1+WHPwcQvkrDqjN7jtha7n2OLLRrBtkNbbXM9KBS+Vk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jlsxQkzVQZMVwEky2vrTLODbOWWIEqqIur4ZldrMukXxonRK/KLgt0zzE1pSmg9Bxh+3kFs7w664+JANH19y/dvGNzk0L7n8r7i7vGN/aXn49MPHO+wPiPJOwYJEWCVKOh67zVU+uFDAMe6+vnepHGREgtYNK+g8a0Z0eplzY+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=dBGzWfrw; arc=none smtp.client-ip=34.198.218.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="dBGzWfrw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775050630; x=1806586630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=wuthZuZJNuIVCbef4TvR92fybPm79mBQ8LikDhPWnf0=;
  b=dBGzWfrw75o1NSXK8TCJCzSSMfCvFtcw+hN1Jmh/QV1LLEXTXnobJISo
   vRMlw5dyuDCeDKvDj8C8URCZ4p/QpD8J/MyxyZcqAH4ZkUSCSbLPaEn9G
   NKrsJZQnFXia7lqHBB1zzDtmzvKf/d6M1oIc1bPk3M3Otoj8WylPE0Msu
   zeatqB3l4IcxrksXNbpDZR+WE6nxPAxSygG8zB/ueZLtEfnYxq+TMUKr2
   0k4BipKyTxPMVyUuNrcCy5ORLqD3+6f/PQMF6ejwnrvQywrhXgyYlRyNC
   K3b7+/AI77JtzW1oD3j6EZP6i6VZgdodJciBfDydHh9bNqaBPEqCwpeZj
   g==;
X-CSE-ConnectionGUID: Y52wK3WyQnCQaxue3N9eZw==
X-CSE-MsgGUID: BvBLo81GSHqURNQ2EZY2FQ==
X-IronPort-AV: E=Sophos;i="6.23,153,1770595200"; 
   d="scan'208";a="14740612"
Received: from ip-10-4-7-229.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.7.229])
  by internal-iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 13:37:04 +0000
Received: from EX19MTAUEB002.ant.amazon.com [72.21.198.67:21684]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.8.197:2525] with esmtp (Farcaster)
 id b3ce9a85-508e-4dd2-9849-9f140f408e54; Wed, 1 Apr 2026 13:37:03 +0000 (UTC)
X-Farcaster-Flow-ID: b3ce9a85-508e-4dd2-9849-9f140f408e54
Received: from EX19D012UEC004.ant.amazon.com (10.252.135.219) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:37:02 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC004.ant.amazon.com (10.252.135.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:37:01 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Wed, 1 Apr 2026 13:37:01 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Heyne, Maximilian" <mheyne@amazon.de>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, "Keith
 Busch" <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Hector Martin
	<marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, Alyssa Rosenzweig
	<alyssa@rosenzweig.io>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van Assche
	<bvanassche@acm.org>, Sasha Levin <sashal@kernel.org>, Peter Wang
	<peter.wang@mediatek.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bean Huo <beanhuo@micron.com>, Brian Kao <powenkao@google.com>, Wonkon Kim
	<wkon.kim@samsung.com>, Seunghui Lee <sh043.lee@samsung.com>, Sanjeev Yadav
	<sanjeev.y@mediatek.com>, Hannes Reinecke <hare@suse.de>, Ming Lei
	<ming.lei@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev"
	<asahi@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y 4/8] nvme-pci: remove an extra queue reference
Thread-Topic: [PATCH 6.1.y 4/8] nvme-pci: remove an extra queue reference
Thread-Index: AQHcwdyeS0oU7vvtXEuRvFkEk0UbGA==
Date: Wed, 1 Apr 2026 13:37:01 +0000
Message-ID: <20260401-oat-connect-4976b717@mheyne-amazon>
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

[ Upstream commit 7dcebef90d35de13a326f765dd787538880566f9 ]

Now that blk_mq_destroy_queue does not release the queue reference, there
is no need for a second admin queue reference to be held by the nvme_dev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20221018135720.670094-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 drivers/nvme/host/pci.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 727585f580362..13c0098939ec0 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1782,7 +1782,6 @@ static void nvme_dev_remove_admin(struct nvme_dev *de=
v)
 		 */
 		nvme_start_admin_queue(&dev->ctrl);
 		blk_mq_destroy_queue(dev->ctrl.admin_q);
-		blk_put_queue(dev->ctrl.admin_q);
 		blk_mq_free_tag_set(&dev->admin_tagset);
 	}
 }
@@ -1811,11 +1810,6 @@ static int nvme_pci_alloc_admin_tag_set(struct nvme_=
dev *dev)
 		dev->ctrl.admin_q =3D NULL;
 		return -ENOMEM;
 	}
-	if (!blk_get_queue(dev->ctrl.admin_q)) {
-		nvme_dev_remove_admin(dev);
-		dev->ctrl.admin_q =3D NULL;
-		return -ENODEV;
-	}
 	return 0;
 }
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

