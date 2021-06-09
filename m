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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16F8C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C5260FEE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbhFIDwe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:52:34 -0400
Received: from m12-11.163.com ([220.181.12.11]:50425 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236625AbhFIDwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Jun 2021 23:52:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RJ4fd
        jimFMvS3XV/vDOCbbbkesEyGJABjAOIjnI8IZI=; b=TEXyxLyZJ5i+KMxJsOzHc
        n2JSn3L3isxgOc5JbxjZtTLsvKEE5t2U/7xXNE+yOF/M4fVL+admRXvB/9PRh5qk
        TaR0PBX3VAHOpxI4bhSSWj7kdbS15VJMYRyWSndyiKwVGEF1EccdUzvbMtq1cdtW
        kKGhPinRGqlofqpTcfP83I=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowAC3vWVpOsBgeNMZhA--.891S2;
        Wed, 09 Jun 2021 11:50:02 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_debugfs: deleted these repeated words
Date:   Wed,  9 Jun 2021 11:49:00 +0800
Message-Id: <20210609034900.382363-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAC3vWVpOsBgeNMZhA--.891S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1Dtw1xKFy7WF17JFy8AFb_yoW8Ar13pa
        93Ka4rJr1kCF1IyF13Cw4rAF9Yya93XF4UCFWjk34rAF4rGr1ftF95trWFqFWFkF1rZFnF
        yrs09rW5Gr4DurJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bjPEfUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/xtbBEQusUFaEEqWA2wAAsY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted these repeated words 'while' and 'from' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 658a962832b3..c67e8a0e0b32 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -136,7 +136,7 @@ static struct lpfc_idiag idiag;
  * gather from the beginning of the log and process until the current entry.
  *
  * Notes:
- * Discovery logging will be disabled while while this routine dumps the log.
+ * Discovery logging will be disabled while this routine dumps the log.
  *
  * Return Value:
  * This routine returns the amount of bytes that were dumped into @buf and will
@@ -202,7 +202,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_vport *vport, char *buf, int size)
  * gather from the beginning of the log and process until the current entry.
  *
  * Notes:
- * Slow ring logging will be disabled while while this routine dumps the log.
+ * Slow ring logging will be disabled while this routine dumps the log.
  *
  * Return Value:
  * This routine returns the amount of bytes that were dumped into @buf and will
@@ -2541,7 +2541,7 @@ lpfc_debugfs_lseek(struct file *file, loff_t off, int whence)
  * @ppos: The position in the file to start reading from.
  *
  * Description:
- * This routine reads data from from the buffer indicated in the private_data
+ * This routine reads data from the buffer indicated in the private_data
  * field of @file. It will start reading at @ppos and copy up to @nbytes of
  * data to @buf.
  *
-- 
2.25.1

