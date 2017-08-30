From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/3] qla2xxx: Fixes for scsi misc
Date: Wed, 30 Aug 2017 10:16:47 -0700
Message-ID: <20170830171650.32341-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0055.outbound.protection.outlook.com ([104.47.32.55]:54543
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750972AbdH3RQ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 13:16:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin, 

These patches are small fixes for the driver. Please apply
to 4.14/scsi-queue at your earliest convenience.

Thanks,
Himanshu

Darren Trap (1):
  qla2xxx: Clear fc4f_nvme flag

Quinn Tran (2):
  qla2xxx: Fix slow mem alloc behind lock
  qla2xxx: Reset the logo flag, after target re-login.

 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_init.c   |  2 ++
 drivers/scsi/qla2xxx/qla_os.c     | 33 ++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c |  4 +++-
 4 files changed, 38 insertions(+), 2 deletions(-)

-- 
2.12.0
