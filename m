From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 00/18] qla2xxx: Patches for scsi-misc.
Date: Fri, 18 Nov 2011 09:03:04 -0800
Message-ID: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:26431
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758070Ab1KRRQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to scsi-misc for inclusion in a future mainline release at the earliest convenient opportunity.

Thanks,
Chad

Andrew Vasquez (3):
  qla2xxx: Only read requested mailbox registers.
  qla2xxx: Limit excessive DPC cycles.
  qla2xxx: Ensure there's enough request-queue space for passthru
    IOCBs.

Chad Dupuis (3):
  qla2xxx: Update to dynamic logging.
  qla2xxx: Move initialization of some variables before iospace_config.
  qla2xxx: Do not check for minidump when device state is
    QLA82XX_DEV_READY.

Giridhar Malavali (8):
  qla2xxx: Proper cleanup of pass through commands when firmware
    returns error.
  qla2xxx: Fix to include FCE data as part of dump.
  qla2xxx: Correct report-id acquisition check
  qla2xxx: Corrected the default setting of the help text of Minidump
    capture mask.
  qla2xxx: Corrected the display of firmware dump availability for
    ISP82xx.
  qla2xxx: Added a new entry to ISP specific function pointers
    structure.
  qla2xxx: Process marker IOCB request on request queue 0.
  qla2xxx: Consolidated IOCB processing routines.

Joe Carnuccio (1):
  qla2xxx: Corrections to returned sysfs error codes.

Joe Perches (2):
  qla2xxx: Use less stack to emit logging messages.
  qla2xxx: Make the logging functions verify their arguments and fixed
    the current broken uses as appropriate.

Saurav Kashyap (1):
  qla2xxx: Implement FCP priority tagging for 82xx adapters.

 drivers/scsi/qla2xxx/qla_attr.c |   10 +-
 drivers/scsi/qla2xxx/qla_bsg.c  |   20 ++-
 drivers/scsi/qla2xxx/qla_dbg.c  |  310 ++++++++++---------
 drivers/scsi/qla2xxx/qla_dbg.h  |   19 +-
 drivers/scsi/qla2xxx/qla_def.h  |    6 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c   |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |   95 ++++---
 drivers/scsi/qla2xxx/qla_iocb.c |  641 ++++++++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c  |  253 +++++++++-------
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c   |  510 +------------------------------
 drivers/scsi/qla2xxx/qla_os.c   |  363 +++++++++++------------
 drivers/scsi/qla2xxx/qla_sup.c  |    5 +-
 14 files changed, 1121 insertions(+), 1117 deletions(-)


