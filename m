Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A90CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 09:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbiGVJqf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 05:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbiGVJqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 05:46:07 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD73C1FCCD;
        Fri, 22 Jul 2022 02:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=EpMX8
        /85w5IOZQMQqccD2jp1bdPhwiHl8+z2tnsG7GQ=; b=GSlKV9TTSDaIwHf8qjG1H
        N7E9Ass9uDkQ9jDzQPWoYtETovvQwthDCF29TWx7ufYNvMU0rF8K/+JoB+WDqcWJ
        bC3fi6i1bDNmKan0XkOlGiNBAWho7p80M87xxS0WOFGtnTgzeOFugUoOwAR5JvNZ
        1AZFoB2SSVWh+FSWKGeZsA=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp1 (Coremail) with SMTP id GdxpCgDn79fkcNpiH5UqPw--.3252S2;
        Fri, 22 Jul 2022 17:41:58 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] scsi: bfa: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 17:41:54 +0800
Message-Id: <20220722094154.78107-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgDn79fkcNpiH5UqPw--.3252S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr4UKF43KrW8Xw17Awb_yoW3trbEva
        nFq3yIgw15CFZ7twnxAr1Fvry5Zw42vryrur1SvF13uayFvFWDXFyvvw1fZ348GFnrur9F
        q3yqqw1akw4UWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRXa9IDUUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbivx5GZFWB0jzPCgABs9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/scsi/bfa/bfa_fcs_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index c21aa37b8adb..dd78bea3e111 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1971,7 +1971,7 @@ bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			/*
 			 * Device's PID has changed. We need to cleanup
 			 * and re-login. If there is another device with
-			 * the the newly discovered pid, send an scn notice
+			 * the newly discovered pid, send an scn notice
 			 * so that its new pid can be discovered.
 			 */
 			list_for_each(qe, &rport->port->rport_q) {
-- 
2.25.1

