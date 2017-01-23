From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/2] qla2xxx: Two bug fixes
Date: Mon, 23 Jan 2017 08:34:44 -0800
Message-ID: <20170123163446.9227-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0049.outbound.protection.outlook.com ([104.47.40.49]:62971
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750705AbdAWQe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 11:34:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>

Hello Martin,

While testing kernel v4.10-rc5 I ran into two bugs in the qla2xxx driver.
The two patches in this series fixes these bugs. Please consider these
patches for inclusion in the upstream kernel.

Bart Van Assche (2):
  qla2xxx: Fix a recently introduced memory leak
  qla2xxx: Avoid that issuing a LIP triggers a kernel crash

 drivers/scsi/qla2xxx/qla_isr.c | 3 ++-
 drivers/scsi/qla2xxx/qla_os.c  | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.11.0

