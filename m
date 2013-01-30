From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 0/6] qla2xxx: Patches for scsi "misc" branch.
Date: Wed, 30 Jan 2013 03:34:36 -0500
Message-ID: <1359534882-17069-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:37481 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753382Ab3A3Iz1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 03:55:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the next mainline merge window.

Thanks,
~Saurav

Arun Easi (3):
  qla2xxx: Enable target mode support for ISP83xx.
  qla2xxx: Allow ISP81xx to create ATIO queues.
  qla2xxx: Prevent enabling target mode for unsupported HBAs.

Chad Dupuis (2):
  qla2xxx: Determine the number of outstanding commands based on
    available resources.
  qla2xxx: Ramp down queue depth for attached SCSI devices when driver
    resources are low.

Saurav Kashyap (1):
  qla2xxx: Correction to the message ids.

 drivers/scsi/qla2xxx/qla_bsg.c    |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c    |    9 +-
 drivers/scsi/qla2xxx/qla_def.h    |   30 +++++--
 drivers/scsi/qla2xxx/qla_fw.h     |    3 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |    4 +
 drivers/scsi/qla2xxx/qla_init.c   |   60 +++++++++++++-
 drivers/scsi/qla2xxx/qla_inline.h |   19 ++++
 drivers/scsi/qla2xxx/qla_iocb.c   |   37 ++++----
 drivers/scsi/qla2xxx/qla_isr.c    |   30 +++++--
 drivers/scsi/qla2xxx/qla_mbx.c    |    8 +-
 drivers/scsi/qla2xxx/qla_mid.c    |    7 ++-
 drivers/scsi/qla2xxx/qla_nx.c     |    2 +-
 drivers/scsi/qla2xxx/qla_os.c     |  123 +++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  169 +++++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_target.h |   19 +++--
 15 files changed, 442 insertions(+), 80 deletions(-)

-- 
1.7.7

