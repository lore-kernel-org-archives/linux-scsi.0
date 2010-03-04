From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/2] qla2xxx: Updates for scsi-misc-2.6.
Date: Thu,  4 Mar 2010 14:12:55 -0800
Message-ID: <1267740777-3862-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52118 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755975Ab0CDWM6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Mar 2010 17:12:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply following patches.

Giridhar Malavali (2):
  qla2xxx: Add ISP82XX support.
  qla2xxx: Update version number to 8.03.03-k0.

 drivers/scsi/qla2xxx/Makefile      |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |   12 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |    3 +
 drivers/scsi/qla2xxx/qla_def.h     |   51 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   80 +
 drivers/scsi/qla2xxx/qla_gs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_init.c    |  217 ++-
 drivers/scsi/qla2xxx/qla_inline.h  |    5 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   70 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   38 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  136 ++-
 drivers/scsi/qla2xxx/qla_nx.c      | 3496 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx.h      |  807 +++++++++
 drivers/scsi/qla2xxx/qla_os.c      |  254 +++-
 drivers/scsi/qla2xxx/qla_sup.c     |   80 +-
 drivers/scsi/qla2xxx/qla_version.h |    6 +-
 16 files changed, 5137 insertions(+), 122 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_nx.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nx.h

