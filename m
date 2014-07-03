From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/5] hpsa a few small updates for early July 2014
Date: Thu, 03 Jul 2014 10:17:52 -0500
Message-ID: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:12348 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbaGCPSp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 11:18:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com, hch@lst.de

Nothing very big here, just a few small updates for now.

I still have a giant ball of patches waiting in the wings, but it
is unfortunately not quite ready yet.

---

Robert Elliott (1):
      hpsa: do not unconditionally copy sense data

Stephen M. Cameron (4):
      hpsa: remove online devices from offline device list
      hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl
      hpsa: make hpsa_init_one return -ENOMEM if allocation of h->lockup_detected fails
      hpsa: fix 6-byte READ/WRITE with 0 length data xfer


 drivers/scsi/hpsa.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

-- 
-- steve

