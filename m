From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH RESEND 0/6] qla2xxx device removal fixups
Date: Tue, 26 Aug 2014 17:08:23 -0400
Message-ID: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:57406 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaHZVJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 17:09:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

Resending patchset against scsi-queue/drivers-for-3.18 with Acked-by and
Cc stable annotations.

Joe Lawrence (6):
  qla2xxx: Fix shost use-after-free on device removal
  qla2xxx: Use qla2x00_clear_drv_active on probe failure
  qla2xxx: Collect PCI register checks and board_disable scheduling
  qla2xxx: Schedule board_disable only once
  qla2xxx: Prevent removal and board_disable race
  qla2xxx: Prevent probe and board_disable race

 drivers/scsi/qla2xxx/qla_def.h |    5 ++++
 drivers/scsi/qla2xxx/qla_gbl.h |    3 +-
 drivers/scsi/qla2xxx/qla_isr.c |   44 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_mr.c  |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c  |    6 ++--
 drivers/scsi/qla2xxx/qla_os.c  |   60 ++++++++++++++++++----------------------
 6 files changed, 61 insertions(+), 59 deletions(-)

-- 
1.7.10.4

