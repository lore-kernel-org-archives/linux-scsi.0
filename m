From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 00/19] qla2xxx: Patches for scsi "misc" branch.
Date: Wed, 6 Jul 2016 11:14:16 -0400
Message-ID: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:2322 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbcGFP7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

Hi James, Martin,

Please apply the following patches to the scsi tree, misc branch at your
earliest convenience.

Thanks,
-Himanshu

Giridhar Malavali (1):
  qla2xxx: Set FLOGI retry in additional firmware options for P2P (N2N)
    mode.

Himanshu Madhani (1):
  qla2xxx: Update driver version to 8.07.00.38-k

Joe Carnuccio (12):
  qla2xxx: Remove sysfs node fw_dump_template.
  qla2xxx: Add ram area DDR for fwdump template entry T262.
  qla2xxx: Shutdown board on thermal shutdown aen.
  qla2xxx: Add module parameter alternate/short names.
  qla2xxx: Make debug buffer log easier to view.
  qla2xxx: Properly initialize IO statistics.
  qla2xxx: Properly reset firmware statistics.
  qla2xxx: Add bsg interface to support D_Port Diagnostics.
  qla2xxx: Let DPORT be enabled purely by nvram.
  qla2xxx: Add support to handle Loop Init error Asynchronus event.
  qla2xxx: Correction to function qla26xx_dport_diagnostics().
  qla2xxx: Separate ISP type bits out from device type.

Sawan Chandak (5):
  qla2xxx: Check for device state before unloading the driver.
  qla2xxx: Add bsg interface to support statistics counter reset.
  qla2xxx: Disable the adapter and skip error recovery in case of
    register disconnect.
  qla2xxx: Fix duplicate message id.
  qla2xxx: Fix BBCR offset

 drivers/scsi/qla2xxx/qla_attr.c    | 170 ++++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_bsg.c     |  92 +++++++++++++++-----
 drivers/scsi/qla2xxx/qla_bsg.h     |  13 +++
 drivers/scsi/qla2xxx/qla_dbg.c     |  50 +++++------
 drivers/scsi/qla2xxx/qla_def.h     |  12 ++-
 drivers/scsi/qla2xxx/qla_fw.h      |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   5 +-
 drivers/scsi/qla2xxx/qla_init.c    |  39 +++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |  23 ++++-
 drivers/scsi/qla2xxx/qla_mbx.c     | 123 ++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_os.c      | 127 ++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_target.c  |  16 ++--
 drivers/scsi/qla2xxx/qla_tmpl.c    |   9 +-
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 14 files changed, 443 insertions(+), 240 deletions(-)

-- 
2.7.2

