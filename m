From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v3 2/7] libsas: remove unused port_gone_completion
Date: Mon, 10 Jul 2017 15:06:04 +0800
Message-ID: <1499670369-44143-3-git-send-email-wangyijing@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9295 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdGJHCV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2017 03:02:21 -0400
In-Reply-To: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Yijing Wang <wangyijing@huawei.com>

No one uses the port_gone_completion in struct asd_sas_port,
clean it out.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 include/scsi/libsas.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index c41328d..628f48b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -263,8 +263,6 @@ struct sas_discovery {
 /* The port struct is Class:RW, driver:RO */
 struct asd_sas_port {
 /* private: */
-	struct completion port_gone_completion;
-
 	struct sas_discovery disc;
 	struct domain_device *port_dev;
 	spinlock_t dev_list_lock;
-- 
2.5.0
