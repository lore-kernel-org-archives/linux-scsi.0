From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/22] qla2xxx: Patches for 3.13 scsi "misc" branch.
Date: Wed, 30 Oct 2013 03:38:07 -0400
Message-ID: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:21007 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752269Ab3J3IJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:09:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree, misc branch  at your
earliest convenience.

Thanks,
~Saurav

Armen Baloyan (5):
  qla2xxx: Print proper QLAFX00 product name at probe.
  qla2xxx: Fix issue with not displaying node name after system reboot.
  qla2xxx: Add logic to abort BSG commands for ISPFX00.
  qla2xxx: Add changes to obtain ISPFX00 adapters product information
    in accordance with firmware update.
  qla2xxx: Replace a constant with a macro definition for
    host->canqueue assigmnment.

Atul Deshmukh (1):
  qla2xxx: Clear RISC INT reg only for an event and not always while
    polling.

Chad Dupuis (7):
  qla2xxx: Honor execute firmware failures.
  qla2xxx: Add BPM support for ISP25xx.
  Revert "qla2xxx: Ramp down queue depth for attached SCSI devices when
    driver resources are low."
  qla2xxx: Refactor shutdown code so some functionality can be reused.
  qla2xxx: Disable adapter when we encounter a PCI disconnect.
  qla2xxx: Use the correct mailbox registers when acknowledging an IDC
    request on ISP8044.
  qla2xxx: Only complete dcbx_comp and lb_portup_comp for virtual port
    index 0.

Joe Carnuccio (3):
  qla2xxx: Correctly set mailboxes for extended init control block.
  qla2xxx: Add BSG interface for read/write serdes register.
  qla2xxx: Fix undefined behavior in call to snprintf().

Saurav Kashyap (3):
  qla2xxx: Don't consider the drivers knocked out of IDC participation
    for future reset recovery process.
  qla2xxx: Adding MAINTAINERS for qla2xxx FC-SCSI driver
  qla2xxx: Update the driver version to 8.06.00.12-k.

Sawan Chandak (3):
  qla2xxx: Disable INTx interrupt for ISP82XX
  qla2xxx: Use scnprintf() instead of snprintf() in the sysfs handlers.
  qla2xxx: Reset nic_core_reset_owner on moving from COLD to READY for
    ISP8044

 MAINTAINERS                        |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c    |  116 ++++++------
 drivers/scsi/qla2xxx/qla_bsg.c     |   44 +++++
 drivers/scsi/qla2xxx/qla_bsg.h     |   13 ++
 drivers/scsi/qla2xxx/qla_dbg.c     |    7 +-
 drivers/scsi/qla2xxx/qla_def.h     |   22 +--
 drivers/scsi/qla2xxx/qla_gbl.h     |   13 +-
 drivers/scsi/qla2xxx/qla_init.c    |    2 +
 drivers/scsi/qla2xxx/qla_inline.h  |   19 --
 drivers/scsi/qla2xxx/qla_isr.c     |   82 +++++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |   73 +++++++-
 drivers/scsi/qla2xxx/qla_mr.c      |   39 +++-
 drivers/scsi/qla2xxx/qla_mr.h      |   12 +-
 drivers/scsi/qla2xxx/qla_nx.c      |   20 ++-
 drivers/scsi/qla2xxx/qla_nx2.c     |   25 ++--
 drivers/scsi/qla2xxx/qla_os.c      |  366 ++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 17 files changed, 534 insertions(+), 324 deletions(-)

-- 
1.7.7

