Received: from iad-out-006.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-006.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.216.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681C13E9595;
	Thu,  2 Apr 2026 13:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138245; cv=none; b=C4nXIQuBZHKLOmmCLL/4ru88A2PgQj/rKppQOmg9gw5A96cHIErHU6m+EwK1ZntYZh1klY6J9yDEzwKZVJzwCvVsQuULScyfiZfBUkZ6tIlZ8mfDipeNxD0n7dhdIUDFoXJRafcr7/GolO9rrIVteg47QwGnuO6Zjamp8hffUV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138245; c=relaxed/simple;
	bh=Qrk8GSV96kDDkq1+0VAMC53OBa1WpEWTZeLl1slKnmA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ud7HhjDgGVpJuFKC1PhYkv0esCkVbqi8EX3yfcw9y5TvQPDu9KC/FfFShJE38+28PIjb4sHySyUOgk0YcNU7XrhmSC7wBBopnctcGh466GG2DxeVjIixeMGft5fhaOqF0faLawp8xxixqJVfapX7JdRboeqOWkEZK5SQqiNFG0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=Eev2BELo; arc=none smtp.client-ip=3.216.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="Eev2BELo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775138243; x=1806674243;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=yyrWPY5Ev1YqXQNI936Pi4tZz7GWIXsbdLr6GEho4RU=;
  b=Eev2BELoZcSDLvIKBqGYG7n5LTYfqeSvYf36uoWCgDn62EBA+V0SeLYz
   WHoIF8GDPBLpwO0AIPSkOqTWac1CvmEeH7npNYrBDEURdh5CB6ITwrD/N
   IjG2E0FntkM645CgLsGwI1vVqW7dgAMrT+NEI5G9lyDcDUCmgkBR+UYVU
   7gJPnKSVo/S1bfXS/yCkUfHIueOtL4YrJyXOv8GYQsivJF9tQkaKakrGI
   fX6nIw1QB1hMZW8SFUVKWD2imbZSspGgY61Ohi190zAqBJY79tDl9qsUZ
   E3ddWYWMAqlSASfaum0xK8cRk6eY9F9ROxY2yKBDHxEfFsZR6iLyDNzRI
   w==;
X-CSE-ConnectionGUID: cCuUAN+OQB2K6u5cvFpdWA==
X-CSE-MsgGUID: CBI+7n0xSMyKsLNmLVjrTA==
X-IronPort-AV: E=Sophos;i="6.23,155,1770595200"; 
   d="scan'208";a="15383184"
Received: from ip-10-4-17-41.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.17.41])
  by internal-iad-out-006.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 13:57:19 +0000
Received: from EX19MTAUEB002.ant.amazon.com [52.94.133.143:5141]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.39.103:2525] with esmtp (Farcaster)
 id 68d3bac5-7a3e-4487-90d4-822c0b579f99; Thu, 2 Apr 2026 13:57:19 +0000 (UTC)
X-Farcaster-Flow-ID: 68d3bac5-7a3e-4487-90d4-822c0b579f99
Received: from EX19D012UEC002.ant.amazon.com (10.252.135.254) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:18 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC002.ant.amazon.com (10.252.135.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:18 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Thu, 2 Apr 2026 13:57:18 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Heyne, Maximilian" <mheyne@amazon.de>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, "Chaitanya
 Kulkarni" <kch@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Hector Martin
	<marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, Alyssa Rosenzweig
	<alyssa@rosenzweig.io>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van Assche
	<bvanassche@acm.org>, Sasha Levin <sashal@kernel.org>, Peter Wang
	<peter.wang@mediatek.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Yen <thomasyen@google.com>, Brian Kao <powenkao@google.com>, "Sanjeev
 Yadav" <sanjeev.y@mediatek.com>, Wonkon Kim <wkon.kim@samsung.com>, "Seunghui
 Lee" <sh043.lee@samsung.com>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke
	<hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"asahi@lists.linux.dev" <asahi@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y v2 4/6] nvme-pci: put the admin queue in
 nvme_dev_remove_admin
Thread-Topic: [PATCH 6.1.y v2 4/6] nvme-pci: put the admin queue in
 nvme_dev_remove_admin
Thread-Index: AQHcwqieIRJTxL3DvEmKk95Z3tjcyQ==
Date: Thu, 2 Apr 2026 13:57:18 +0000
Message-ID: <20260402-kemp-dime-b84f5127@mheyne-amazon>
References: <20260402-moral-jockey-f072379b@mheyne-amazon>
In-Reply-To: <20260402-moral-jockey-f072379b@mheyne-amazon>
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

[ Upstream commit 96ef1be53663a9343dffcf106e2f1b59da4b8799 ]

Once the controller is shutdown no one can access the admin queue.  Tear
it down in nvme_dev_remove_admin, which matches the flow in the other
drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by Gerd Bayer <gbayer@linxu.ibm.com>
Stable-dep-of: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime")
[ Context change due to missing commit 94cc781f69f4 ("nvme: move OPAL
  setup from PCIe to core")]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 drivers/nvme/host/pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 13c0098939ec0..38732c0c28bbb 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1782,6 +1782,7 @@ static void nvme_dev_remove_admin(struct nvme_dev *de=
v)
 		 */
 		nvme_start_admin_queue(&dev->ctrl);
 		blk_mq_destroy_queue(dev->ctrl.admin_q);
+		blk_put_queue(dev->ctrl.admin_q);
 		blk_mq_free_tag_set(&dev->admin_tagset);
 	}
 }
@@ -2831,8 +2832,6 @@ static void nvme_pci_free_ctrl(struct nvme_ctrl *ctrl)
 =

 	nvme_dbbuf_dma_free(dev);
 	nvme_free_tagset(dev);
-	if (dev->ctrl.admin_q)
-		blk_put_queue(dev->ctrl.admin_q);
 	free_opal_dev(dev->ctrl.opal_dev);
 	mempool_destroy(dev->iod_mempool);
 	put_device(dev->dev);
-- =

2.50.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

