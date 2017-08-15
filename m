From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: [PATCH 0/6] Update qedf to version 8.20.5.0.
Date: Tue, 15 Aug 2017 10:08:15 -0700
Message-ID: <20170815170821.20806-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0069.outbound.protection.outlook.com ([104.47.34.69]:65440
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751605AbdHORIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 13:08:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

From: "Chad Dupuis" <chad.dupuis@cavium.com>

Hi Martin,

Please apply the following patches at your earliest convenience.

Thanks,
Chad

Chad Dupuis (6):
  qedf: Set WWNN and WWPN based on values from qed.
  qedf: Use granted MAC from the FCF for the FCoE source address if it
    is available.
  qedf: Corrent VLAN tag insertion in fallback VLAN case.
  qedf: Covert single-threaded workqueues to regular workqueues.
  qedf: Fix up modinfo parameter name for 'debug' in modinfo output.
  qedf: Update driver version to 8.20.5.0.

 drivers/scsi/qedf/qedf.h         |   2 -
 drivers/scsi/qedf/qedf_fip.c     |  35 +++-----------
 drivers/scsi/qedf/qedf_main.c    | 102 +++++++++++++++++++++++++++++++--------
 drivers/scsi/qedf/qedf_version.h |   6 +--
 4 files changed, 92 insertions(+), 53 deletions(-)

-- 
2.12.3
