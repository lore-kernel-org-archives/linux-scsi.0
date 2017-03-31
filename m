From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/2] qla2xxx: Bug Fixes for qla2xxx driver
Date: Fri, 31 Mar 2017 14:37:02 -0700
Message-ID: <20170331213704.5577-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0084.outbound.protection.outlook.com ([104.47.40.84]:34950
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751477AbdCaVhZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Mar 2017 17:37:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin,

Couple bug fixes for the scsi-fixes branch please apply to 4.11/scsi-fixes. 

Thanks,
Himanshu 

Milan P Gandhi (1):
  qla2xxx: Fix typo in driver

Sawan Chandak (1):
  qla2xxx: Add fix to read correct register value for ISP82xx.

 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_bsg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_gs.c   | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c  | 6 +++---
 drivers/scsi/qla2xxx/qla_os.c   | 7 ++++++-
 6 files changed, 13 insertions(+), 8 deletions(-)

-- 
2.12.0
