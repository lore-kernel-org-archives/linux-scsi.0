Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82238CCA482
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 14:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358129AbiFVOTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 10:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358455AbiFVOSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 10:18:40 -0400
Received: from smtpbg.qq.com (smtpbg123.qq.com [175.27.65.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B78CF7;
        Wed, 22 Jun 2022 07:18:35 -0700 (PDT)
X-QQ-mid: bizesmtp91t1655907398tszimgfg
Received: from ubuntu.localdomain ( [106.117.78.84])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 22 Jun 2022 22:16:34 +0800 (CST)
X-QQ-SSF: 01000000008000B0B000E00A0000000
X-QQ-FEAT: ZHWZeLXy+8eGIpW5SgqC0vGxiIjhVdPeUkQEKaTB67jOjJuIlIxRSlAdrinK5
        NwUieqAbkmu5XbUfuRVNyX3YhOZN/XXnSzc3wTrQ6M5S6SXN8XlFKO/LdPpTsaVtKI2ZpMv
        n8rRpGpLJiiAjkHjoT3lheNTah2I+O+kDedhpLo8GaqB+BNx3IvidhQlPD3ZHKLgA6WiUwp
        eunjwWknBtlZT16UcPZG1q/bzAIsVOInqJ33JqsCav0Wi20EUYNYFxoepOb8xuh6zdixSOZ
        cW7EUByIYNZN7vH4BOc7gZQxhy2VnFZbwoRUI5yhRqbtg+84qdtAFttzDjqhLekf/xv8t6/
        oZA1Qv1vxCHnlP4BofgR6mlNOkgDAcLxlynypbH
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Jian <jiangjian@cdjrlc.com>
Subject: [PATCH] scsi: megaraid_sas: drop unexpected word 'and' in the comments
Date:   Wed, 22 Jun 2022 22:16:31 +0800
Message-Id: <20220622141631.9249-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

there is an unexpected word 'and' in the comments that need to be dropped

file: drivers/scsi/megaraid/megaraid_sas_fusion.c
line: 2551

* megasas_stream_detect -	stream detection on read and and write IOs

changed to:

* megasas_stream_detect -	stream detection on read and write IOs

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5b5885d9732b..d74a0e0e6d5d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2548,7 +2548,7 @@ megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
 }
 
 /**
- * megasas_stream_detect -	stream detection on read and and write IOs
+ * megasas_stream_detect -	stream detection on read and write IOs
  * @instance:		Adapter soft state
  * @cmd:		    Command to be prepared
  * @io_info:		IO Request info
-- 
2.17.1

