From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 0/3] Three small fixes for libsas
Date: Thu, 4 Jan 2018 19:47:38 +0800
Message-ID: <20180104114741.37358-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3683 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752778AbeADLkZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jan 2018 06:40:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, hare@suse.com, Jason Yan <yanaijie@huawei.com>

We've found three small bugs. Please consider including them for 4.15.

V2:
	- Add "Fixes" tag.

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
