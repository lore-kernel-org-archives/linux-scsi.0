From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/5] qla2xxx: Updates for scsi-misc-2.6.
Date: Fri, 19 Mar 2010 17:03:57 -0700
Message-ID: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36570 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752209Ab0CTAED (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 20:04:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply these patches. The patch number 0005 fixes patch errors
and warnings present in pathces 0001 to 0004. One of the error present
is more of style convenetion. I have not corrected to be in sync 
with similar code allready present.

Andrew Vasquez (1):
  qla2xxx: General checkpatch corrections.

Giridhar Malavali (1):
  qla2xxx: Re-organized BSG interface specific code.

Harish Zunjarrao (1):
  qla2xxx: Free DMA memory only if it is allocated in vendor specific
    BSG command

Sarang Radke (2):
  qla2xxx: Add APEX support.
  qla2xxx: Fix to make conditional decision based on port number.

 drivers/scsi/qla2xxx/Makefile   |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c |  707 +-----------------------
 drivers/scsi/qla2xxx/qla_bsg.c  | 1207 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h  |  135 +++++
 drivers/scsi/qla2xxx/qla_def.h  |  132 +----
 drivers/scsi/qla2xxx/qla_fw.h   |   59 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |   17 +-
 drivers/scsi/qla2xxx/qla_init.c |  170 ++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |   98 +++-
 drivers/scsi/qla2xxx/qla_os.c   |   22 +-
 drivers/scsi/qla2xxx/qla_sup.c  |   69 +++-
 11 files changed, 1771 insertions(+), 847 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_bsg.c
 create mode 100644 drivers/scsi/qla2xxx/qla_bsg.h

