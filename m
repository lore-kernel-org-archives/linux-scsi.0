Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DE6C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 06:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F13461185
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 06:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhFIGWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 02:22:22 -0400
Received: from m12-14.163.com ([220.181.12.14]:60264 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhFIGWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 02:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=+jncS
        EswVm56ufw3Zo7cE6IDUiNRMHH4pAIPqbMJvUk=; b=PAYalI85+lBqc4NgZ3b6/
        lbF6HFmeuWV/wIY77pL3vyeZm3mvx6NVqD0NjVXq6a4gbBWAcYsSJSZoDhLVEiC+
        EOt3QUdoDaI0UIbDQnqOmnSOGyv1AZS1e2JStLE+1DETMcL363yTIzxMvr23imOj
        j11gUfjASAOStQBqtafvHA=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowAAnb2OIXcBgwh4QNw--.18788S2;
        Wed, 09 Jun 2021 14:19:53 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_nvme: deleted the repeated word
Date:   Wed,  9 Jun 2021 14:18:55 +0800
Message-Id: <20210609061855.413327-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowAAnb2OIXcBgwh4QNw--.18788S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFWDKr45XFyfJw43uw43GFg_yoWfCrgE9a
        ykZF17Xw4vkFZrZFy5Gw4Sv3sFyr45Wr92kFn2qryfu3yDWFW7GrWqq34ruw1UZrn8XF9x
        W3Z5ZrySyr15KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU52dgtUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiLxCsUFUMY34rUwAAs-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted the repeated word 'since' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 41e49f61fac2..78171ef77c7e 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2427,7 +2427,7 @@ lpfc_nvme_rescan_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
  * For now, the driver just unbinds the DID and port_role so that
  * no further IO can be issued.  Changes are planned for later.
  *
- * Notes - the ndlp reference count is not decremented here since
+ * Notes - the ndlp reference count is not decremented here
  * since there is no nvme_transport api for devloss.  Node ref count
  * is only adjusted in driver unload.
  */
-- 
2.25.1

