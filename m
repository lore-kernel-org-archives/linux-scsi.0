From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 00/15] qedf: Update driver to version 8.18.22.0.
Date: Tue, 23 May 2017 06:19:16 -0700
Message-ID: <20170523131931.1777-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0068.outbound.protection.outlook.com ([104.47.37.68]:43648
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933347AbdEWNTq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 09:19:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Hi Martin,

Please apply the following patches to the scsi tree at your earliest convenience.

Thanks,
Chad

Dupuis, Chad (15):
  qedf: Enable basic FDMI information.
  qedf: Update copyright to 2017.
  qedf: Honor qed_ops->common->set_fp_int() return code.
  qedf: Look at all descriptors when processing a clear virtual link.
  qedf: Check that fcport is offloaded before dereferencing pointers in
    initiate_abts|cleanup.
  qedf: Add fka_period SCSI host attribute to show fip keep alive
    period.
  qedf: Set qed logging level to QED_LEVEL_NOTICE.
  qedf: Use same logic for SCSI host reset and FC lip_reset.
  qedf: Add bus_reset No-op.
  qedf: Add non-offload receive filters.
  qedf: Fixup unnecessary paratheses around test_bit operations.
  qedf: Move some prints to a debug level so they do not print when no
    debugging is enabled.
  qedf: Change cmd_per_lun in scsi_host_template to 32 to increase
    performance.
  qedf: Add change_queue_depth member to scsi_host_template().
  qedf: Update version number to 8.18.22.0.

 drivers/scsi/qedf/drv_fcoe_fw_funcs.c |   2 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.h |   2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.c |   2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.h |   2 +-
 drivers/scsi/qedf/qedf.h              |   2 +-
 drivers/scsi/qedf/qedf_attr.c         |  62 ++++++++-----
 drivers/scsi/qedf/qedf_dbg.h          |   2 +-
 drivers/scsi/qedf/qedf_debugfs.c      |   2 +-
 drivers/scsi/qedf/qedf_els.c          |   8 +-
 drivers/scsi/qedf/qedf_fip.c          |  22 +++--
 drivers/scsi/qedf/qedf_hsi.h          |   2 +-
 drivers/scsi/qedf/qedf_io.c           |  26 ++++--
 drivers/scsi/qedf/qedf_main.c         | 165 +++++++++++++++++++++++++++++-----
 drivers/scsi/qedf/qedf_version.h      |   8 +-
 14 files changed, 231 insertions(+), 76 deletions(-)

-- 
1.8.5.6
