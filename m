From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 00/42] qla2xxx: Patches for scsi "misc" branch.
Date: Wed, 22 Aug 2012 14:20:54 -0400
Message-ID: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:38943 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964808Ab2HVSiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience.

Thanks,
Chad

Andrew Vasquez (2):
  qla2xxx: Ensure PLOGI is sent to Fabric Management-Server upon
    request.
  qla2xxx: Fail initialization if unable to load RISC code.

Arun Easi (5):
  qla2xxx: Fix for continuous rescan attempts in arbitrated loop
    topology.
  qla2xxx: Use #defines instead of hardcoded values for intr status.
  qla2xxx: T10 DIF - ISP83xx changes.
  qla2xxx: Fix incorrect status reporting on DIF errors.
  qla2xxx: Use the right field for container_of.

Atul Deshmukh (1):
  qla2xxx: Wrong PCIe(2.5Gb/s x8) speed in the kerenel message for
    ISP82xx.

Chad Dupuis (12):
  qla2xxx: Bind to ISP8031 devices.
  qla2xxx: Add check in qla82xx_watchdog for failed hardware state.
  qla2xxx: Use bitmap to store loop_id's for fcports.
  qla2xxx: Changes for ISP83xx loopback support.
  qla2xxx: Update the driver license.
  qla2xxx: Only enable link up on the correct interrupt event.
  qla2xxx: Implement beacon support for ISP83xx.
  qla2xxx: Remove setting Scsi_host->this_id during adapter probe.
  qla2xxx: Fix description of qla2xmaxqdepth parameter.
  qla2xxx: Fix for handling some error conditions in loopback.
  qla2xxx: Set Maximum Read Request Size to 4K.
  qla2xxx: Update version number to 8.04.00.07-k.

Giridhar Malavali (4):
  qla2xxx: Don't register to legacy interrupt for ISP82xx.
  qla2xxx: Fix for legacy interrupts for ISP83xx.
  qla2xxx: Don't toggle RISC interrupt bits after IRQ lines are
    attached.
  qla2xxx: Allow MSI interrupt registration for ISP82xx.

Harish Zunjarrao (1):
  qla2xxx: Add FW DUMP SIZE sysfs attribute.

Joe Carnuccio (3):
  qla2xxx: Add I2C BSG interface.
  qla2xxx: Add bit to identify adapters for thermal temp.
  qla2xxx: Do PCI fundamental reset for ISP83xx

Masanari Iida (1):
  qla2xxx: Fix typo in qla2xxx files

Santosh Vernekar (2):
  qla2xxx: IDC implementation for ISP83xx.
  qla2xxx: Perform ROM mbx cmd access only after ISP soft-reset during
    f/w recovery.

Saurav Kashyap (11):
  qla2xxx: Display mailbox failure by default.
  qla2xxx: Implementation of bidirectional.
  qla2xxx: Implemetation of mctp.
  qla2xxx: Fix rval may be used uninitialized in this function warning.
  qla2xxx: Dont call nic restart firmware if it is already active and
    running.
  qla2xxx: Do not restrict the number of NPIV ports for ISP83xx.
  qla2xxx: set idc version if function is first one to come.
  qla2xxx: Enclose adapter related calls in adapter check in failed
    state handler.
  qla2xxx: Get fcal position map should not be called for p2p topology.
  qla2xxx: Enable fw attributes for ISP24xx and above.
  qla2xxx: Restrict nic core reset to one function for mctp.

 Documentation/scsi/LICENSE.qla2xxx  |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c     |  145 ++++++-
 drivers/scsi/qla2xxx/qla_bsg.c      |  376 +++++++++++++++--
 drivers/scsi/qla2xxx/qla_bsg.h      |   30 ++-
 drivers/scsi/qla2xxx/qla_dbg.c      |   29 +-
 drivers/scsi/qla2xxx/qla_dbg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_def.h      |  166 +++++++-
 drivers/scsi/qla2xxx/qla_dfs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h       |   49 ++-
 drivers/scsi/qla2xxx/qla_gbl.h      |   39 ++-
 drivers/scsi/qla2xxx/qla_gs.c       |    4 +-
 drivers/scsi/qla2xxx/qla_init.c     |  562 ++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_inline.h   |   28 ++-
 drivers/scsi/qla2xxx/qla_iocb.c     |  261 ++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c      |  437 ++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_mbx.c      |  224 +++++++++-
 drivers/scsi/qla2xxx/qla_mid.c      |    5 +-
 drivers/scsi/qla2xxx/qla_nx.c       |  153 ++++----
 drivers/scsi/qla2xxx/qla_nx.h       |   17 +-
 drivers/scsi/qla2xxx/qla_os.c       |  767 +++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_settings.h |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c      |   67 +++-
 drivers/scsi/qla2xxx/qla_version.h  |    6 +-
 23 files changed, 2957 insertions(+), 416 deletions(-)

-- 
1.7.7

