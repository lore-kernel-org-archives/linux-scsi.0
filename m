From: Praveen Madhavan <praveenm@chelsio.com>
Subject: [PATCH v2 0/2] csiostor:Remove T4 FCoE support
Date: Fri, 16 Jan 2015 21:30:18 +0530
Message-ID: <cover.1421423434.git.praveenm@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:14268 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753934AbbAPQEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2015 11:04:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: davem@davemloft.net, JBottomley@parallels.com, hch@infradead.org, hariprasad@chelsio.com, praveenm@chelsio.com, varun@chelsio.com

We found a subtle issue with FCoE on T4 very late in the game
and decided not to productize FCoE on T4 and therefore there
are no customers that will be impacted by this change. FCoE is
supported on T5 cards.

Please apply on net-next since depends on previous commits.

Changes in v2:
  - Make the commit message more clearer.

Praveen Madhavan (2):
  csiostor:Remove T4 FCoE Support.
  csiostor:Removed file csio_hw_t4.c

 drivers/scsi/csiostor/Makefile       |   2 +-
 drivers/scsi/csiostor/csio_hw.c      |  61 ++----
 drivers/scsi/csiostor/csio_hw_chip.h |  43 ----
 drivers/scsi/csiostor/csio_hw_t4.c   | 404 -----------------------------------
 drivers/scsi/csiostor/csio_init.c    |   6 +-
 drivers/scsi/csiostor/csio_wr.c      |  15 +-
 6 files changed, 25 insertions(+), 506 deletions(-)
 delete mode 100644 drivers/scsi/csiostor/csio_hw_t4.c

-- 
2.0.2

