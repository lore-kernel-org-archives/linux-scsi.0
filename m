From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 00/14] qla2xxx: Patches for 3.2-rc.
Date: Fri, 18 Nov 2011 09:02:08 -0800
Message-ID: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:44426
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab1KRRP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches for 3.2-rc.

Thanks,
Chad

Andrew Vasquez (1):
  qla2xxx: Return the correct value for a mailbox command if 82xx is in
    reset recovery.

Arun Easi (1):
  qla2xxx: Check for SCSI status on underruns.

Chad Dupuis (3):
  qla2xxx: Display IPE error message for ISP82xx.
  qla2xxx: Encapsulate prematurely completing mailbox commands during
    ISP82xx firmware hang.
  qla2xxx: Update version number to 8.03.07.12-k.

Giridhar Malavali (6):
  qla2xxx: Revert back the request queue mapping to request queue 0.
  qla2xxx: Stop unconditional completion of mailbox commands issued in
    interrupt mode during firmware hang.
  qla2xxx: Enable Minidump by default with default capture mask 0x1f.
  qla2xxx: Clear mailbox busy flag during premature mailbox completion
    for ISP82xx.
  qla2xxx: Disable generating pause frames when firmware hang detected
    for ISP82xx.
  qla2xxx: Submit all chained IOCBs for passthrough commands on request
    queue 0.

Saurav Kashyap (3):
  qla2xxx: Remove qla2x00_wait_for_loop_ready function.
  qla2xxx: Don't call alloc_fw_dump for ISP82XX.
  qla2xxx: Correct fc_host port_state display.

 drivers/scsi/qla2xxx/qla_attr.c    |   27 ++++++++++--
 drivers/scsi/qla2xxx/qla_dbg.c     |    8 ++--
 drivers/scsi/qla2xxx/qla_gbl.h     |    1 +
 drivers/scsi/qla2xxx/qla_init.c    |    3 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   14 +++---
 drivers/scsi/qla2xxx/qla_isr.c     |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |   25 +++++++++--
 drivers/scsi/qla2xxx/qla_nx.c      |   42 +++++++++++------
 drivers/scsi/qla2xxx/qla_nx.h      |    4 ++
 drivers/scsi/qla2xxx/qla_os.c      |   86 ++++-------------------------------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 11 files changed, 102 insertions(+), 112 deletions(-)


