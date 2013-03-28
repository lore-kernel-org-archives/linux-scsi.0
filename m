From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 0/5] qla2xxx: Patches for scsi "misc" branch.
Date: Thu, 28 Mar 2013 08:21:22 -0400
Message-ID: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:27860 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755079Ab3C1MoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Mar 2013 08:44:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the next mainline merge window.

Thanks,
~Saurav

Giridhar Malavali (1):
  qla2xxx: Enhancements to support ISPFx00.

Joe Carnuccio (2):
  qla2xxx: Add clarifying printk to thermal access fail cases.
  qla2xxx: Obtain loopback iteration count from bsg request.

Saurav Kashyap (1):
  qla2xxx: Update the driver version to 8.05.00.03-k.

Wei Yongjun (1):
  qla2xxx: Remove duplicated include form qla_isr.c

 drivers/scsi/qla2xxx/Makefile      |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |   35 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  154 ++-
 drivers/scsi/qla2xxx/qla_bsg.h     |    1 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   27 +-
 drivers/scsi/qla2xxx/qla_def.h     |  236 +++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   47 +-
 drivers/scsi/qla2xxx/qla_gs.c      |   16 +-
 drivers/scsi/qla2xxx/qla_init.c    |   52 +-
 drivers/scsi/qla2xxx/qla_inline.h  |   41 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   67 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   20 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |   10 +-
 drivers/scsi/qla2xxx/qla_mr.c      | 3476 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mr.h      |  510 ++++++
 drivers/scsi/qla2xxx/qla_os.c      |  212 +++-
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 17 files changed, 4803 insertions(+), 107 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_mr.c
 create mode 100644 drivers/scsi/qla2xxx/qla_mr.h

-- 
1.7.7

