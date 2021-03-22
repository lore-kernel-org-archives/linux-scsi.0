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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0851BC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 07:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B320D61970
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 07:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhCVH6T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 03:58:19 -0400
Received: from m12-12.163.com ([220.181.12.12]:40245 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229874AbhCVH5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 03:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=lccNb8YaEAjPPXxCBA
        p/evI28UzSVyDrx8A8IWVBdd0=; b=nxq+M0/UKkX0S3GPuiHOtiO0S9HGw+/glA
        AwzKDD8b6aYMwp3M9rxZc/Hl2q5iZ3EpZMRVb5cNH66MdQ/EMv8sr5lz7FbFsBwb
        g9W9IushwXI4L1P+9MmC3rtsfssMy5Y1iVdUiTWNyplqBihhH1WXfPqjU1xLHdty
        sCda3UC7s=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.55.63])
        by smtp8 (Coremail) with SMTP id DMCowABn1qqyTVhgnzXJVw--.62207S2;
        Mon, 22 Mar 2021 15:56:37 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] scsi: lpfc: Fix some typo error
Date:   Mon, 22 Mar 2021 15:56:45 +0800
Message-Id: <20210322075645.25636-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DMCowABn1qqyTVhgnzXJVw--.62207S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr1UWF47Gr45Jw13XF1rtFb_yoW8WrW7p3
        yak3W8JryDA345Z343Crs8J34fAa1rX34qkF4I934ruF13Zry2grZ5KrWjvry8CFy8Zr1j
        qrsFka48uw18GrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j61vsUUUUU=
X-Originating-IP: [119.137.55.63]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiRRVdsVl91ovlYQAAsB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

change 'lenth' to 'length'.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 8c23806..658a962 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5154,7 +5154,7 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
  * This routine is to get the available extent information.
  *
  * Returns:
- * overall lenth of the data read into the internal buffer.
+ * overall length of the data read into the internal buffer.
  **/
 static int
 lpfc_idiag_extacc_avail_get(struct lpfc_hba *phba, char *pbuffer, int len)
@@ -5205,7 +5205,7 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
  * This routine is to get the allocated extent information.
  *
  * Returns:
- * overall lenth of the data read into the internal buffer.
+ * overall length of the data read into the internal buffer.
  **/
 static int
 lpfc_idiag_extacc_alloc_get(struct lpfc_hba *phba, char *pbuffer, int len)
@@ -5277,7 +5277,7 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
  * This routine is to get the driver extent information.
  *
  * Returns:
- * overall lenth of the data read into the internal buffer.
+ * overall length of the data read into the internal buffer.
  **/
 static int
 lpfc_idiag_extacc_drivr_get(struct lpfc_hba *phba, char *pbuffer, int len)
-- 
1.9.1


