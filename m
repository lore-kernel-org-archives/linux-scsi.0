From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 0/3] Three small fixes for libsas
Date: Tue, 2 Jan 2018 20:15:07 +0800
Message-ID: <20180102121510.12570-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:55472 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752129AbeABMIL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jan 2018 07:08:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, hare@suse.com, Jason Yan <yanaijie@huawei.com>

We've found three small bugs. Please consider including them for 4.15.

Jason Yan (2):
  scsi: libsas: fix memory leak in sas_smp_get_phy_events()
  scsi: libsas: fix error when getting phy events

chenxiang (1):
  scsi: libsas: initialize sas_phy status according to response of
    DISCOVER

 drivers/scsi/libsas/sas_expander.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.9.5
