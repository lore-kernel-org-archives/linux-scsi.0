Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C95C76196
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Apr 2023 08:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjDAIQB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Apr 2023 04:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbjDAIQB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Apr 2023 04:16:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4137ED9
        for <linux-scsi@vger.kernel.org>; Sat,  1 Apr 2023 01:15:59 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PpVJN4VqXz17N46;
        Sat,  1 Apr 2023 16:12:36 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Sat, 1 Apr
 2023 16:15:55 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 0/3] scsi: libsas: remove empty branches and code simplification
Date:   Sat, 1 Apr 2023 16:15:23 +0800
Message-ID: <20230401081526.1655279-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three patches to remove two empty branches and a little code
simplification.

Jason Yan (3):
  scsi: libsas: Simplify sas_check_eeds()
  scsi: libsas: Remove an empty branch in sas_check_parent_topology()
  scsi: libsas: Simplify sas_check_parent_topology()

 drivers/scsi/libsas/sas_expander.c | 135 ++++++++++++++++-------------
 1 file changed, 73 insertions(+), 62 deletions(-)

-- 
2.31.1

