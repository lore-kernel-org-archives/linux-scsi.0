From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 0/2] qedi: Remove unwanted warnings.
Date: Thu, 15 Jun 2017 00:10:38 -0700
Message-ID: <20170615071040.18093-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0048.outbound.protection.outlook.com ([104.47.36.48]:2337
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751829AbdFOHKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Jun 2017 03:10:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Martin,

Please consider below patches for next 'scsi-fixes' submission.

Thanks,
Manish

Manish Rangankar (2):
  qedi: Remove WARN_ON for untracked cleanup.
  qedi: Remove WARN_ON from clear task context.

 drivers/scsi/qedi/qedi_fw.c   | 1 -
 drivers/scsi/qedi/qedi_main.c | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

-- 
1.8.3.1
