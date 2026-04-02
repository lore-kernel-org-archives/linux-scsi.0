Received: from iad-out-010.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-010.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.197.254.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E79E3ED101;
	Thu,  2 Apr 2026 13:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.197.254.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138248; cv=none; b=cTzT8eZnj3FwXfFw3U5Dsbqdt+u94n8I6vpDJiritjZqGjtVJBJVq/uxTipHay1F/0SDROMqaXpk22CJhcpHmajxbuc2aPMj7BPVmlCmijQCgN/Quwj1D84GE3F/jTUyHnL2v60IsWaTMdHsfp+yz8tcXga3KUjtWqLZ9pIikYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138248; c=relaxed/simple;
	bh=DwjYrCrYHiZGVHlaDfF21bfSKi2+EKC0p0kSlXD7b74=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ob9nmjvBxkPG+MQByBvB3qwAITHKPkl/r+XVewKUzX7wg2WX/kb5ui93QFv/+umQ5UIVw9oeDF9lHXOtklHm605PFS/8DImvdW+0qBxz/tqLF/ILqXHIZJUZRmfDTV6Maiga+NSFz9Gbl2gkL3bHgnWWtSFubYsIYBRVzwGmybc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=JLvRPH9x; arc=none smtp.client-ip=34.197.254.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="JLvRPH9x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775138246; x=1806674246;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=mvU/lZdi2hYsgWu6W9JVHisJHcxM5S1ZidU29vypwvM=;
  b=JLvRPH9xw7nJLHk2Hiv7M7T0Fqh10BBM0lPcuA2xoTIyQ5M6mGheQTer
   1T5sZj+vtC19NAfUKkTf8NAglDUxDpwwhQcrl1QkUD/g1vMd2HfuYDyvQ
   2hoEk1cg/mXxyZL/MWFMeFS1qF2TG2c0Ltkwgs4Ukt8r8oRVMPuqIcUKn
   XQd/wESdpQBARCptGZvYb1ql2IT5wDeEK7an7AjBsA5eB/JcFIu4VIl7Q
   Sl524cyWbKItkTekkiR54fRgXMemWkO7Chz3G/Za7if1ONjmHivOEx+i8
   Nugv1QDwXVaS7I44sbxxW3T9RpquxTxf2egiMKg0KXky5NpXb6weLqutF
   Q==;
X-CSE-ConnectionGUID: auy+wLkAQYWw59kc47d3Bw==
X-CSE-MsgGUID: Kb+i6j18TzmrWueDucDIBA==
X-IronPort-AV: E=Sophos;i="6.23,155,1770595200"; 
   d="scan'208";a="15101635"
Received: from ip-10-4-22-235.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.22.235])
  by internal-iad-out-010.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 13:57:22 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.142:22247]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.39.103:2525] with esmtp (Farcaster)
 id d07190eb-e20f-4e37-9699-b4099791098d; Thu, 2 Apr 2026 13:57:22 +0000 (UTC)
X-Farcaster-Flow-ID: d07190eb-e20f-4e37-9699-b4099791098d
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:21 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC003.ant.amazon.com (10.252.135.160) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:21 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Thu, 2 Apr 2026 13:57:21 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Heyne, Maximilian" <mheyne@amazon.de>, Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Yi Zhang <yi.zhang@redhat.com>, Jens Axboe
	<axboe@kernel.dk>, Hector Martin <marcan@marcan.st>, Sven Peter
	<sven@svenpeter.dev>, Alyssa Rosenzweig <alyssa@rosenzweig.io>, "Christoph
 Hellwig" <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, "Avri
 Altman" <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "Sasha
 Levin" <sashal@kernel.org>, Peter Wang <peter.wang@mediatek.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Seunghwan Baek
	<sh8267.baek@samsung.com>, Seunghui Lee <sh043.lee@samsung.com>, "Adrian
 Hunter" <adrian.hunter@intel.com>, Brian Kao <powenkao@google.com>, "Sanjeev
 Yadav" <sanjeev.y@mediatek.com>, Wonkon Kim <wkon.kim@samsung.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Hannes Reinecke <hare@suse.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"asahi@lists.linux.dev" <asahi@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y v2 6/6] nvme: fix admin queue leak on controller reset
Thread-Topic: [PATCH 6.1.y v2 6/6] nvme: fix admin queue leak on controller
 reset
Thread-Index: AQHcwqigUhccylBZtkqEyTZV34R51w==
Date: Thu, 2 Apr 2026 13:57:21 +0000
Message-ID: <20260402-fox-attic-82ebf113@mheyne-amazon>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b84bb7bd913d8ca2f976ee6faf4a174f91c02b8d ]

When nvme_alloc_admin_tag_set() is called during a controller reset,
a previous admin queue may still exist. Release it properly before
allocating a new one to avoid orphaning the old queue.

This fixes a regression introduced by commit 03b3bcd319b3 ("nvme: fix
admin request_queue lifetime").

Cc: Keith Busch <kbusch@kernel.org>
Fixes: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime").
Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-block/CAHj4cs9wv3SdPo+N01Fw2SHBYDs9tj=
2M_e1-GdQOkRy=3DDsBB1w@mail.gmail.com/
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ Have to do analogous work in nvme_pci_alloc_admin_tag_set in pci.c due
  to missing upstream commit 0da7feaa5913 ("nvme-pci: use the tagset
  alloc/free helpers") ]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 drivers/nvme/host/core.c | 7 +++++++
 drivers/nvme/host/pci.c  | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f17318f6c82b0..09439fa7d083a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5012,6 +5012,13 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl,=
 struct blk_mq_tag_set *set,
 	if (ret)
 		return ret;
 =

+	/*
+	 * If a previous admin queue exists (e.g., from before a reset),
+	 * put it now before allocating a new one to avoid orphaning it.
+	 */
+	if (ctrl->admin_q)
+		blk_put_queue(ctrl->admin_q);
+
 	ctrl->admin_q =3D blk_mq_init_queue(set);
 	if (IS_ERR(ctrl->admin_q)) {
 		ret =3D PTR_ERR(ctrl->admin_q);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e8b7b0004086c..07ca1e1d920b8 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1804,6 +1804,13 @@ static int nvme_pci_alloc_admin_tag_set(struct nvme_=
dev *dev)
 		return -ENOMEM;
 	dev->ctrl.admin_tagset =3D set;
 =

+	/*
+	 * If a previous admin queue exists (e.g., from before a reset),
+	 * put it now before allocating a new one to avoid orphaning it.
+	 */
+	if (dev->ctrl.admin_q)
+		blk_put_queue(dev->ctrl.admin_q);
+
 	dev->ctrl.admin_q =3D blk_mq_init_queue(set);
 	if (IS_ERR(dev->ctrl.admin_q)) {
 		blk_mq_free_tag_set(set);
-- =

2.50.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

