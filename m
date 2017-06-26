From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 0/7] bnx2fc: Update driver to version 2.11.8.
Date: Mon, 26 Jun 2017 08:59:31 -0700
Message-ID: <20170626155938.2091-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:11313
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751427AbdFZP7m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 11:59:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Hi Martin,

Please apply the following patches at your earliest convenience.

Thanks,
Chad

Dupuis, Chad (7):
  bnx2fc: Add filters to the non-offload FCoE receive path.
  bnx2fc: Check for connection offload before sending RRQ.
  bnx2fc: Update copyright for 2017.
  bnx2fc: Adjust bnx2fc_npiv_create_vports for WWNNs from NVRAM that are
    zero.
  bnx2fc: If IO is still in cleanup then do not return to SCSI layer.
  bnx2fc: Make rport_terminate_io callback a NOOP.
  bnx2fc: Update version number to 2.11.8.

 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  |  3 +-
 drivers/scsi/bnx2fc/bnx2fc.h           |  5 +--
 drivers/scsi/bnx2fc/bnx2fc_constants.h |  3 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.c     |  3 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.h     |  3 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c       | 16 ++++++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c      | 62 +++++++++++++++++++++++++++++++---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c       |  3 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c        | 14 +++-----
 drivers/scsi/bnx2fc/bnx2fc_tgt.c       |  3 +-
 10 files changed, 90 insertions(+), 25 deletions(-)

-- 
1.8.5.6
