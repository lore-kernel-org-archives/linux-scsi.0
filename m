From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/3] qla2xxx: fixes for 2.6.32-rc8
Date: Wed,  2 Dec 2009 10:36:53 -0800
Message-ID: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45738 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754260AbZLBSm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 13:42:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Please apply...

Anirban Chakraborty (1):
  Fix to accommodate a hardware bug in multiqueue mode that does not
    work properly when acknowledgement of MSIX Interrupts is disabled.

Giridhar Malavali (2):
  qla2xxx: Queue depth ramp up/down modification changes.
  qla2xxx: Update version number to 8.03.01-k8.

 drivers/scsi/qla2xxx/qla_def.h     |    5 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    2 -
 drivers/scsi/qla2xxx/qla_init.c    |   12 ++++-
 drivers/scsi/qla2xxx/qla_isr.c     |  103 ++++--------------------------------
 drivers/scsi/qla2xxx/qla_mid.c     |    4 ++
 drivers/scsi/qla2xxx/qla_os.c      |   69 ++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 7 files changed, 79 insertions(+), 118 deletions(-)

