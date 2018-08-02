From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH 0/2] remove double test condition
Date: Thu, 2 Aug 2018 10:44:59 +0800
Message-ID: <1533177901-19514-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: andy.shevchenko@gmail.com, john.garry@huawei.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


zhong jiang (2):
  scsi:qla1280: remove unnessary same condition check
  scsi:qlogicfas408: remove the same check in qlogicfas408_detect

 drivers/scsi/qla1280.c      | 1 -
 drivers/scsi/qlogicfas408.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

-- 
1.7.12.4
