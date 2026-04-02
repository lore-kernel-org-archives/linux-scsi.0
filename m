Received: from iad-out-014.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-014.esa.us-east-1.outbound.mail-perimeter.amazon.com [50.16.246.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE083E3155;
	Thu,  2 Apr 2026 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.16.246.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138240; cv=none; b=r1b3VG5GAcO+f6cPhToRa4t6Shf71cBtKAqzCyXSuAeFFnYEzIps+nhDe7Fl0z69qxyoF0azbwZ8o+RV7Bt2RfANgFB0FFgI1Fc/zFQaV3RermJaOjhwyDYii1IX1k23TkmEB7prtAOfpxq6u6fDOzypstsy7hhDs00UDbLaluY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138240; c=relaxed/simple;
	bh=Xlubo5e63Q1mS8nOqT0PR+T6mFXnE463a3p0CCcM2Wc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OLoLT5WndmKxoOQkfps6/UwP8dTYRYd2d3mPnE8AsV+Gdd4k5Yq6X9xtW8klYVLl3kdlo0ZNj6HxoH5IrDNl3aPq5j7tGgv6wuCFutfIWGY3YvpSzlrG4tt2/V9DjkFchjMAlp/29l0gF/RPsuo0vV2Y9svWQoXPDhg1vZ1sP6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=PU8uB0yN; arc=none smtp.client-ip=50.16.246.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="PU8uB0yN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775138239; x=1806674239;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hMUdY6WjkBIAJVkybt2uz62AC89MtKqIA+KLS7wHlyY=;
  b=PU8uB0yN5aP7gjfKEdvUnO5H5fW+lg4pKXA+TxrmI68xikRZE8VlOARu
   8vxMIIeQ7knVRpjcOJkSBDHManoUwovAbyjq7SDV3qFjwDfONVO1dIuNX
   85JITIAdOlt1QhdQi8Xf+5Xp3kI1sd/2o7/fdcZ9WFL7NMVMsAtucyQNf
   MsbW9gboRtEyzUVI+OoGiRg0iZUUqR+EZ1hmCDax9MMeo1/UfldmqQogZ
   9emX6LmwzKCHbhIcf4++v2UFVf3lGnp9WGeYhc0q3H2bap4CInRDizdgM
   vDUslqtXyxd3/99SliNGEl16HP0EkEwcoLHJXIyEmYjs49wN8l2sT8z+Z
   w==;
X-CSE-ConnectionGUID: gH0AQ+v0Qgie1+XG0e5oqA==
X-CSE-MsgGUID: bqVpYZ3bRAqEa50Nri7RmQ==
X-IronPort-AV: E=Sophos;i="6.23,155,1770595200"; 
   d="scan'208";a="14829483"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-014.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 13:57:13 +0000
Received: from EX19MTAUEA001.ant.amazon.com [72.21.196.67:20344]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.17.255:2525] with esmtp (Farcaster)
 id f908d55e-394b-4888-93e4-d21ff27dfe17; Thu, 2 Apr 2026 13:57:12 +0000 (UTC)
X-Farcaster-Flow-ID: f908d55e-394b-4888-93e4-d21ff27dfe17
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:12 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC003.ant.amazon.com (10.252.135.160) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:12 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Thu, 2 Apr 2026 13:57:12 +0000
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
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Adrian Hunter
	<adrian.hunter@intel.com>, Seunghwan Baek <sh8267.baek@samsung.com>, Seunghui
 Lee <sh043.lee@samsung.com>, Thomas Yen <thomasyen@google.com>, Brian Kao
	<powenkao@google.com>, Sanjeev Yadav <sanjeev.y@mediatek.com>, Wonkon Kim
	<wkon.kim@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>, Hannes Reinecke
	<hare@suse.de>, Ming Lei <ming.lei@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev"
	<asahi@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y v2 0/6] nvme: correctly fix admin request_queue lifetime
Thread-Topic: [PATCH 6.1.y v2 0/6] nvme: correctly fix admin request_queue
 lifetime
Thread-Index: AQHcwqiaxpzJWVl8SE+TNUtR0mcVxw==
Date: Thu, 2 Apr 2026 13:57:12 +0000
Message-ID: <20260402-moral-jockey-f072379b@mheyne-amazon>
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
blk_put_queue to a different location.

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

---
Changes in v2:
    - dropped 2 patches from the series that are unnecessary (scsi and
      apple). The apple-nvme patch was even wrong (Thanks Fedor for
      pointing that out)

Christoph Hellwig (3):
  blk-mq: move the call to blk_put_queue out of blk_mq_destroy_queue
  nvme-pci: remove an extra queue reference
  nvme-pci: put the admin queue in nvme_dev_remove_admin

Keith Busch (1):
  nvme: fix admin request_queue lifetime

Maximilian Heyne (1):
  Revert "nvme: fix admin request_queue lifetime"

Ming Lei (1):
  nvme: fix admin queue leak on controller reset

 block/blk-mq.c            |  4 +---
 block/bsg-lib.c           |  2 ++
 drivers/nvme/host/apple.c |  1 +
 drivers/nvme/host/core.c  | 16 ++++++++++++++--
 drivers/nvme/host/pci.c   | 14 +++++++-------
 drivers/scsi/scsi_sysfs.c |  1 +
 drivers/ufs/core/ufshcd.c |  2 ++
 7 files changed, 28 insertions(+), 12 deletions(-)

-- =

2.50.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

