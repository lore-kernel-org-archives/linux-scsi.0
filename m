Received: from iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.221.209.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAEB429800;
	Wed,  1 Apr 2026 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.221.209.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050625; cv=none; b=scXdNCvNo5bry0JXB51NzGRMUqNxfD0AlyzjGpaiP9HyDvluE20YdG7TqSn8jupkpsUXNj46cqOqlTAYy5rSy1yu1Yy2lEk2bviQ2kbeaTI+WDWSRsbYpflpucU76autdERALPwCSIAVfMSbQTU6b9vDStnCna0XLRNKolMBDC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050625; c=relaxed/simple;
	bh=UaRyzaZAw8cAufiE/beqodKLHP7EHgerfpo6Kh0DMFE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=c4kZ2vqs/iVXXowXzoAfBxr5kvfdBTm4TSoZgikxNdotbgZH//97QqeJhDi1pcxYTrnnDXcsoRE1AipzfUd1at7OMnmyD8hFahdjlROWZJbmGeA+A4qLwx8+YeelmQpbxojTBoHUGFFk9QLyYoCJCgoJeQWUXm0QaALXmXrYUmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=H1da6gtD; arc=none smtp.client-ip=3.221.209.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="H1da6gtD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775050624; x=1806586624;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eECRtkLdb1g6Rdy8JYnmlSQYVnKt6oeRbBYfuuRf+YQ=;
  b=H1da6gtD0tIFF7SgW0oP+kMi/Wzg+qV4Nh03/DK3pH2iOsjtd7sO43/4
   x4S6uZw7OzWLHO7OfEamRH6f7EQLmn/wGJaWBT02HHkYA69ToSE2+y/AW
   aDweDItQK5qNI0HAy9RN9PrNRhnlbAhukFYG4vWf6qp0uc9zorbfm72Ss
   mD9VaLJk6V7HEybGpH7ap5YNgp9TVPjpq75XLxHwf2womj3WXeZfoS8AP
   i6JIC1MxBiu5u0q5trDxG3uEShQ1J6Nxu3LDGz8oIinA/96SEOFvC2Suo
   LSc5YDPWLfO4kVq3/YFk413NzhtbFYAUcI77tEEYisIe2/TGk0Y/NeRu4
   g==;
X-CSE-ConnectionGUID: 694XnSJxShO0NhfHByps2g==
X-CSE-MsgGUID: ZX07A88/RO6AxJBRbXwRoA==
X-IronPort-AV: E=Sophos;i="6.23,153,1770595200"; 
   d="scan'208";a="15299610"
Received: from ip-10-4-17-41.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.17.41])
  by internal-iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 13:36:57 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.134:25533]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.17.255:2525] with esmtp (Farcaster)
 id f8ee6624-5584-41dc-b791-6710bae090c0; Wed, 1 Apr 2026 13:36:57 +0000 (UTC)
X-Farcaster-Flow-ID: f8ee6624-5584-41dc-b791-6710bae090c0
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:36:55 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC003.ant.amazon.com (10.252.135.160) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 1 Apr 2026 13:36:55 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Wed, 1 Apr 2026 13:36:55 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Heyne, Maximilian" <mheyne@amazon.de>, Jens Axboe <axboe@kernel.dk>,
	Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, "Alyssa
 Rosenzweig" <alyssa@rosenzweig.io>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, "Avri
 Altman" <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "Sasha
 Levin" <sashal@kernel.org>, Peter Wang <peter.wang@mediatek.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Thomas Yen
	<thomasyen@google.com>, Bean Huo <beanhuo@micron.com>, Brian Kao
	<powenkao@google.com>, Seunghui Lee <sh043.lee@samsung.com>, Sanjeev Yadav
	<sanjeev.y@mediatek.com>, Wonkon Kim <wkon.kim@samsung.com>, Ming Lei
	<ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>, Chaitanya Kulkarni
	<kch@nvidia.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev"
	<asahi@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y 0/8] nvme: correctly fix admin request_queue lifetime
Thread-Topic: [PATCH 6.1.y 0/8] nvme: correctly fix admin request_queue
 lifetime
Thread-Index: AQHcwdyaXGNYIO/hmUiMYmXEd9VHmw==
Date: Wed, 1 Apr 2026 13:36:55 +0000
Message-ID: <20260401-defer-gleam-5226cb65@mheyne-amazon>
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

The initial attempt to backport upstream commit 03b3bcd319b3 ("nvme: fix
admin request_queue lifetime") was not correct leading to refcount
underflows and not even fixing the problem.

I've tested the reproduction steps from [1] (adding a delay to
nvme_submit_user_cmd and 'echo 1 | sudo tee
/sys/class/nvme/nvme0/delete_controller') on the nvme-tcp driver which
printed the KASAN UAF blurb.

Fixing the issue in the 6.1 series requires a few dependent patches.
This is mainly the upstream commit 2b3f056f72e5 ("blk-mq: move the call
to blk_put_queue out of blk_mq_destroy_queue") which allows to move the
blk_put_queue to a different location. While at it, I'm backporting the
whole patch series for completeness. However, the scsi and apple patches
are not strictly required and could be dropped from this series.

The backport of commit 03b3bcd319b3 ("nvme: fix admin
request_queue lifetime") needed a tweak to the nvme pci driver.

Furthermore, in this patch series I've also included a follow-up fixup
from upstream commit b84bb7bd913d ("nvme: fix admin queue leak on
controller reset"), again with an adaption to the nvme pci driver. This
issue could easily be reproduced by resetting the controller (no need to
run full blktests):

  echo 1 > /sys/class/nvme/nvme0/reset_controller

[1] https://lore.kernel.org/all/20251029210853.20768-1-cachen@purestorage.c=
om/

Christoph Hellwig (5):
  blk-mq: move the call to blk_put_queue out of blk_mq_destroy_queue
  scsi: remove an extra queue reference
  nvme-pci: remove an extra queue reference
  nvme-apple: remove an extra queue reference
  nvme-pci: put the admin queue in nvme_dev_remove_admin

Keith Busch (1):
  nvme: fix admin request_queue lifetime

Maximilian Heyne (1):
  Revert "nvme: fix admin request_queue lifetime"

Ming Lei (1):
  nvme: fix admin queue leak on controller reset

 block/blk-mq.c            |  4 +---
 block/bsg-lib.c           |  2 ++
 drivers/nvme/host/apple.c |  8 --------
 drivers/nvme/host/core.c  | 16 ++++++++++++++--
 drivers/nvme/host/pci.c   | 14 +++++++-------
 drivers/scsi/scsi_scan.c  |  1 -
 drivers/ufs/core/ufshcd.c |  2 ++
 7 files changed, 26 insertions(+), 21 deletions(-)

-- =

2.50.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

