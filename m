From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/3] qla2xxx: fixes for 2.6.31-rc3 [8.03.01-k6]
Date: Thu, 23 Jul 2009 16:26:29 -0700
Message-ID: <1248391592-1520-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42858 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754008AbZGWX0c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2009 19:26:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Please apply...

Anirban Chakraborty (2):
  qla2xxx: Fix to ensure driver works in sinlge queue mode if
    multiqueue fails.
  qla2xxx: Fix a bug that clears the interrupt status register for the
    base queue

Giridhar Malavali (1):
  qla2xxx: Update version number to 8.03.01-k6

 drivers/scsi/qla2xxx/qla_attr.c    |    4 ++--
 drivers/scsi/qla2xxx/qla_def.h     |    1 +
 drivers/scsi/qla2xxx/qla_init.c    |    5 ++---
 drivers/scsi/qla2xxx/qla_iocb.c    |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |    3 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c      |   21 +++++++++++++++++----
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 8 files changed, 28 insertions(+), 14 deletions(-)

