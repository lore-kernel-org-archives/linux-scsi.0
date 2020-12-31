Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB947C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Dec 2020 06:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73E4122242
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Dec 2020 06:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgLaGhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Dec 2020 01:37:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9707 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgLaGhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Dec 2020 01:37:31 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D5z1X4q0jzkycD;
        Thu, 31 Dec 2020 14:35:44 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Thu, 31 Dec 2020 14:36:42 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>
CC:     <yangerkun@huawei.com>
Subject: [PATCH] scsi: target: iscsi: remove useless blank line
Date:   Thu, 31 Dec 2020 14:39:21 +0800
Message-ID: <20201231063921.3257378-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove useless blank line exists in iscsit_release_commands_from_conn.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/target/iscsi/iscsi_target.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 518fac4864cf..dfb1e6ea428f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4108,7 +4108,6 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 
 		iscsit_increment_maxcmdsn(cmd, sess);
 		iscsit_free_cmd(cmd, true);
-
 	}
 }
 
-- 
2.25.4

