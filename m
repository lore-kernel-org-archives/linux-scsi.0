Received: from iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.198.218.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD143D51A;
	Wed,  1 Apr 2026 13:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.198.218.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050630; cv=none; b=Ad7Bi8yW/RVrhojbPlm7FpqVXmxZwBwLR5v7FCaNg7hEBx4O7pSqym78Mk66Re+4TpZcxRORNZULlHgNAXJDPE/gjObOsp9Bav3RN91gyO9R43/N7ar2CqFcoGuCe+xHSJuh4sDLedaTkbkF7oy8ZWFmSDSajzj3K1cOeEpzL3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050630; c=relaxed/simple;
	bh=Qrk8GSV96kDDkq1+0VAMC53OBa1WpEWTZeLl1slKnmA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YLTE0vgdMQSaT3vgk3fSx4VMIZtYUrS6S09lvg8odYkwcGBnb+ccHrfLODlpXQipeVkHOfZNFxUP3ETEGXvYHCKWBaejDtppIlOpMEPDloC1xD4u+pFqpb+fC9dxKWUGUz4ZMxS+LRRdV7UsC+JKNYGywnVMMAcy6nrVvnYefaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=fO1SG79x; arc=none smtp.client-ip=34.198.218.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="fO1SG79x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775050628; x=1806586628;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=yyrWPY5Ev1YqXQNI936Pi4tZz7GWIXsbdLr6GEho4RU=;
  b=fO1SG79xsimdv16UVio+/O0bam0BJ2lZ7dgbo2E+0488AXWrJPh5LcA0
   LIyXRRXK/afCjJ4bK4BzD7kcRh53gaRKTWeTDsWGicoXzNm+WVeJCVmlb
   LG2O6uOJGAmFEuS0fa/BKZA1I7gIxfWxycownNFZaoZDIGaX2WydxDb7z
   hmGeDlqQeF8CUIUhM0x9BrgAHUz2rhulmuVnSGRqmuuAe9VgGq4J6d1Cy
   kdReBaWKUyRtBi29bItmCBgCbl/4HVAUYMlZNlYtrPWhNV52LFOoDyDGr
   zuqEkGJByZSS0C5UycsOgjg+qUXYvhZ8b6f0DRYdmfngpHChl/nDC+lsp
   A==;
X-CSE-ConnectionGUID: 3S/LPCjRSD6mXfvS8BfF4Q==
X-CSE-MsgGUID: U7tph4hZTj+7Zz7buNfCIQ==
X-IronPort-AV: E=Sophos;i="6.23,153,1770595200"; 
   d="scan'208";a="14740616"
Received: from ip-10-4-13-79.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.13.79])
  by internal-iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 13:37:06 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.134:17575]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.17.255:2525] with esmtp (Farcaster)
 id d5b417ca-06c6-438e-9b58-67511adcf066; Wed, 1 Apr 2026 13:37:05 +0000 (UTC)
X-Farcaster-Flow-ID: d5b417ca-06c6-438e-9b58-67511adcf066
Received: from EX19D012UEC002.ant.amazon.com (10.252.135.254) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:37:05 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC002.ant.amazon.com (10.252.135.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:37:05 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Wed, 1 Apr 2026 13:37:05 +0000
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
	Seunghui Lee <sh043.lee@samsung.com>, Brian Kao <powenkao@google.com>, Adrian
 Hunter <adrian.hunter@intel.com>, Sanjeev Yadav <sanjeev.y@mediatek.com>,
	Wonkon Kim <wkon.kim@samsung.com>, Hannes Reinecke <hare@suse.de>, Ming Lei
	<ming.lei@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev"
	<asahi@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y 6/8] nvme-pci: put the admin queue in
 nvme_dev_remove_admin
Thread-Topic: [PATCH 6.1.y 6/8] nvme-pci: put the admin queue in
 nvme_dev_remove_admin
Thread-Index: AQHcwdygkRu0MfiJH0aFifOxHgnywA==
Date: Wed, 1 Apr 2026 13:37:05 +0000
Message-ID: <20260401-fugue-granite-a4156254@mheyne-amazon>
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

