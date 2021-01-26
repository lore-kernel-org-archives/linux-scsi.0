Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDD3C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 10:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA751230FD
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 10:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404264AbhAZKlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 05:41:10 -0500
Received: from mail-m973.mail.163.com ([123.126.97.3]:59830 "EHLO
        mail-m973.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404256AbhAZKk4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 05:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=84Y9h
        S/hcQTEsxI71PSydVVNvKNfRlJa3uPZUddnRwM=; b=XAAKBjyyNTG3QzvWxLa/H
        +y5QB0v9fsw2e9lely1iEVu55+ce1qqKlDpn4iUgvt87HzN4iWCjvCU6NNKaxNAZ
        A+h7ByJXhbZqV8waUCtmninJCyjQneRLQfqUKYBpLtmLJ901+/qsBKt2g9S1W4Yh
        NVuaP4mvMO9dwjsrTsRBLE=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp3 (Coremail) with SMTP id G9xpCgAnPHtWrQ9gGw6oUg--.51898S2;
        Tue, 26 Jan 2021 13:49:14 +0800 (CST)
From:   dingsenjie@163.com
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] scsi/megaraid: fix spelling typo of allocated
Date:   Tue, 26 Jan 2021 13:49:08 +0800
Message-Id: <20210126054908.45468-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgAnPHtWrQ9gGw6oUg--.51898S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw4xWF1xXrWUJw4UJryfCrg_yoWDCrbEgr
        W8trn7tryayrs7C34xJ3yrZrZ7t3yYv3WkJ3Wvqr9xuwnrZrsIyF1j9r13Jay7J3yDCasI
        y345Kr1Ikw1vqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5h18PUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiHhomyFSIsgdKdgAAs-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

allocted -> allocated

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 4a27ac8..d57e938 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1165,7 +1165,7 @@ static DEVICE_ATTR(megaraid_mbox_app_hndl, S_IRUSR, megaraid_sysfs_show_app_hndl
 	 * structure
 	 * Since passthru and extended passthru commands are exclusive, they
 	 * share common memory pool. Passthru structures piggyback on memory
-	 * allocted to extended passthru since passthru is smaller of the two
+	 * allocated to extended passthru since passthru is smaller of the two
 	 */
 	raid_dev->epthru_pool_handle = dma_pool_create("megaraid mbox pthru",
 			&adapter->pdev->dev, sizeof(mraid_epassthru_t), 128, 0);
-- 
1.9.1

