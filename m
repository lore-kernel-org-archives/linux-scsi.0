From: Nilesh Javali <nilesh.javali@cavium.com>
Subject: [PATCH 0/1] qedi: Add iSCSI Boot-from-SAN support
Date: Mon, 19 Jun 2017 06:44:28 -0700
Message-ID: <20170619134429.17657-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0087.outbound.protection.outlook.com ([104.47.34.87]:50016
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750951AbdFSNog (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 09:44:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Martin,

Please consider below patch for next 'scsi-fixes' submission.

Thanks,
Nilesh

Nilesh Javali (1):
  qedi: Add support for offload iSCSI Boot

 drivers/scsi/qedi/qedi.h               |  17 ++
 drivers/scsi/qedi/qedi_main.c          | 419 +++++++++++++++++++++++++++++++++
 drivers/scsi/qedi/qedi_nvm_iscsi_cfg.h | 210 +++++++++++++++++
 3 files changed, 646 insertions(+)
 create mode 100644 drivers/scsi/qedi/qedi_nvm_iscsi_cfg.h

-- 
1.8.3.1
