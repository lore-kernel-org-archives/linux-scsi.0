From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/1] qla2xxx: Updates for scsi-misc-2.6.
Date: Mon, 12 Apr 2010 17:59:54 -0700
Message-ID: <1271120395-4510-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39235 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754441Ab0DMBAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2010 21:00:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

I am resubmitting following patch since previous one fails
to apply cleanly. Please apply this patch.

-- Giri

Giridhar Malavali (1):
  qla2xxx: Add ISP82XX support.

 drivers/scsi/qla2xxx/Makefile     |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c   |   35 +-
 drivers/scsi/qla2xxx/qla_dbg.c    |    3 +
 drivers/scsi/qla2xxx/qla_def.h    |   54 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |   85 +
 drivers/scsi/qla2xxx/qla_gs.c     |    2 +-
 drivers/scsi/qla2xxx/qla_init.c   |  233 +++-
 drivers/scsi/qla2xxx/qla_inline.h |    5 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |   74 +-
 drivers/scsi/qla2xxx/qla_isr.c    |   42 +-
 drivers/scsi/qla2xxx/qla_mbx.c    |  158 ++-
 drivers/scsi/qla2xxx/qla_nx.c     | 3635 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx.h     |  888 +++++++++
 drivers/scsi/qla2xxx/qla_os.c     |  346 ++++-
 drivers/scsi/qla2xxx/qla_sup.c    |   80 +-
 15 files changed, 5518 insertions(+), 125 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_nx.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nx.h

