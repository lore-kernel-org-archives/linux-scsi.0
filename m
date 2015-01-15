From: Praveen Madhavan <praveenm@chelsio.com>
Subject: [PATCH 0/2] Remove T4 FCoE support
Date: Thu, 15 Jan 2015 19:15:50 +0530
Message-ID: <cover.1421328605.git.praveenm@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:26737 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753841AbbAONqg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2015 08:46:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: davem@davemloft.net, JBottomley@parallels.com, hch@infradead.org, hariprasad@chelsio.com, praveenm@chelsio.com, varun@chelsio.com

These patches removes FCoE support for chelsio T4 adapter.
Please apply on net-next since depends on previous commits.

Praveen Madhavan (2):
  csiostor:Remove T4 FCoE support.
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

