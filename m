From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/2] qla2xxx: Updates for scsi-misc-2.6.
Date: Tue,  9 Mar 2010 21:44:45 -0800
Message-ID: <1268199888-4405-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52547 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753247Ab0CJFos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2010 00:44:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

I have cleaned up all errors and warnings found in my last submission. 
Please apply these patches.

Giridhar Malavali (2):
  qla2xxx: Add ISP82XX support.
  qla2xxx: Update version number to 8.03.03-k0.

 drivers/scsi/qla2xxx/Makefile      |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |   16 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |    3 +
 drivers/scsi/qla2xxx/qla_def.h     |   53 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   82 +
 drivers/scsi/qla2xxx/qla_gs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_init.c    |  225 ++-
 drivers/scsi/qla2xxx/qla_inline.h  |    5 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   74 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   42 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  150 ++-
 drivers/scsi/qla2xxx/qla_nx.c      | 3538 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx.h      |  888 +++++++++
 drivers/scsi/qla2xxx/qla_os.c      |  315 +++-
 drivers/scsi/qla2xxx/qla_sup.c     |   80 +-
 drivers/scsi/qla2xxx/qla_version.h |    6 +-
 16 files changed, 5346 insertions(+), 135 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_nx.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nx.h

