Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41A9C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 15:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E50206D4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 15:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbgIIP7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:59:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37086 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730702AbgIIP6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Sep 2020 11:58:55 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E63D99C6675E0ABF571C;
        Wed,  9 Sep 2020 21:57:20 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:57:13 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yuehaibing@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] scsi: aic94xx: Remove unused inline function
Date:   Wed, 9 Sep 2020 21:57:11 +0800
Message-ID: <20200909135711.35728-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no caller in tree, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/aic94xx/aic94xx.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index c23bbb609126..98978bc199ff 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -42,14 +42,6 @@
 extern struct kmem_cache *asd_dma_token_cache;
 extern struct kmem_cache *asd_ascb_cache;
 
-static inline void asd_stringify_sas_addr(char *p, const u8 *sas_addr)
-{
-	int i;
-	for (i = 0; i < SAS_ADDR_SIZE; i++, p += 2)
-		snprintf(p, 3, "%02X", sas_addr[i]);
-	*p = '\0';
-}
-
 struct asd_ha_struct;
 struct asd_ascb;
 
-- 
2.17.1


