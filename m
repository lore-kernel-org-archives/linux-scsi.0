Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B380C38145
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 06:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiIFGEH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 02:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiIFGEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 02:04:06 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC48A6E2C3;
        Mon,  5 Sep 2022 23:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Qqyu/
        lLVEOfgUBpB9+9CFRj1uBU4T1fbhSIWkzeQAeg=; b=TPJv7187fsTz9LlTu4oB4
        HjbV22w/YQNsb55um8P6Rf3fZ2COwnMubqtF0sbCvNxk4x2skrUCZhnq0jCcfL63
        Z6bKPnq/Iz7UTNMOpQ8vsSUHxwsXHTpyL9FYdDSQBxBnzB7Q8HSOBDLeL968phYm
        eXrdkYtb9RZmM1vlcO8RKg=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp4 (Coremail) with SMTP id HNxpCgCXbtbD4hZj5Dqrag--.37305S2;
        Tue, 06 Sep 2022 14:03:48 +0800 (CST)
From:   Jiangshan Yi <13667453960@163.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiangshan Yi <yijiangshan@kylinos.cn>,
        k2ci <kernel-bot@kylinos.cn>
Subject: [PATCH] scsi: qedf: qedf_hsi: fix spelling typo in comment
Date:   Tue,  6 Sep 2022 14:03:27 +0800
Message-Id: <20220906060327.2304049-1-13667453960@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgCXbtbD4hZj5Dqrag--.37305S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrury7Jr47ZFy5GFy8Jw1xAFb_yoWftrcEgF
        yjqw42gryjvF9avr4Utr43WFy0kF48Cr4xuFsYqw4Fv39Yyw4DJa95XF1jvw4qyrWDX3Z8
        Xw18ZrykGwnrtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1Tmh3UUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: bprtllyxuvjmiwq6il2tof0z/1tbivgV0+1Zcem+zvgAAsm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jiangshan Yi <yijiangshan@kylinos.cn>

Fix spelling typo in comment.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 drivers/scsi/qedf/qedf_hsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_hsi.h b/drivers/scsi/qedf/qedf_hsi.h
index ecd5cb53b750..36a8a53e859d 100644
--- a/drivers/scsi/qedf/qedf_hsi.h
+++ b/drivers/scsi/qedf/qedf_hsi.h
@@ -300,7 +300,7 @@ struct fcoe_respqe {
 /* PARAM that is located in the FCP_RSP FC header */
 #define FCOE_RESPQE_PARAM_MASK            0xFFFFFF
 #define FCOE_RESPQE_PARAM_SHIFT           0
-/* Indication whther its Target-auto-rsp mode or not */
+/* Indication whether its Target-auto-rsp mode or not */
 #define FCOE_RESPQE_TARGET_AUTO_RSP_MASK  0xFF
 #define FCOE_RESPQE_TARGET_AUTO_RSP_SHIFT 24
 };
-- 
2.25.1


No virus found
		Checked by Hillstone Network AntiVirus

