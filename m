Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FA1C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DAAC6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhDTAJd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:33 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33748 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhDTAJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:30 -0400
Received: by mail-pl1-f174.google.com with SMTP id n10so7530548plc.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yMDwXZ84hsapV539Fos3bJY203yOZ61XgSgGRpSxeTw=;
        b=KpaY9UNIYT7/0e+0rkXJr8vVeHQN1tFd3sbJMX5YW4uM/cF6NoJWkNC6ch4gQ7ZVwR
         8USEch9v32IZCb/58vKEw081Q4+ayIz3kARnavPB+Dk45KAT+JcR4sTrPqWRboxPBGp1
         RGRf0xCKGV1pRF7OCBkVsWHBGps5Jglg89APTSlfC2Vb9N9VjL8S5rAWm0nNxU/Cv7pM
         JHhakQStDRusUSt2WBECbT5er2y8ooAjgwdf9ykEp2Prifx9KreRcnW5S7Uuo4wy+BTC
         ZqWR+mSBr/274OS76WGT5WpWe99vuRnxhSqXdgtznFnXQI/1JI6uiUIFyGGL/aG7MUVL
         TdDQ==
X-Gm-Message-State: AOAM530CI4cUEFJZFnhiPYNV5Hm348rBcE7puIvwQN4EvSjd4SZvYU/O
        hOMkJPQStuEiNp48pjFR26M=
X-Google-Smtp-Source: ABdhPJx+ts7gt9WjcEnOR7+BbDOHoM0jNe5GQpnfpaaI0iU4GYmv2ONy/XKDGaIBny2pLA9guUakFQ==
X-Received: by 2002:a17:902:d3ca:b029:eb:4ae2:6d6 with SMTP id w10-20020a170902d3cab02900eb4ae206d6mr26187787plb.69.1618877339854;
        Mon, 19 Apr 2021 17:08:59 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:08:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 007/117] lpfc: Reformat four comparisons
Date:   Mon, 19 Apr 2021 17:06:55 -0700
Message-Id: <20210420000845.25873-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reformat four comparisons because otherwise Coccinelle would make the
formatting of these comparisons look weird.

Cc: James Smart <james.smart@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index eefbb9b22798..81455b53ef3e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4227,11 +4227,9 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		if (lpfc_cmd->result & IOERR_DRVR_MASK)
 			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 		if (lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_ERROR ||
-		    lpfc_cmd->result ==
-		    IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR ||
+		    lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR ||
 		    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_ERROR ||
-		    lpfc_cmd->result ==
-		    IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
+		    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
 			cmd->result = DID_NO_CONNECT << 16;
 			break;
 		}
@@ -4502,11 +4500,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		case IOSTAT_LOCAL_REJECT:
 		case IOSTAT_REMOTE_STOP:
 			if (lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_ERROR ||
-			    lpfc_cmd->result ==
-					IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR ||
+			    lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR ||
 			    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_ERROR ||
-			    lpfc_cmd->result ==
-					IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
+			    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
 				cmd->result = DID_NO_CONNECT << 16;
 				break;
 			}
