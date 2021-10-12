Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F57C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 803D96109E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhJLV44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:56:56 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:35636 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbhJLV44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 17:56:56 -0400
Received: by mail-pl1-f173.google.com with SMTP id w14so451667pll.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 14:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jiGVxvjAGFMB88xRzaf16FoRpAf00m1HjBqnVUQxRco=;
        b=4Pzi3fmw0gFAr0PKguiOJoN6zXs0iUCn1G/qg/ejdgxuNJVsMlO5aJwHF5rxNlpO+1
         L+69UT4Pn9/zNRKNva5pyYS2aR9I0nnyAytJV6Rqc5Ecd8AvumucHwL+16K6QjxHBb+3
         dqLcjeDg4o/fKCA9/9MCi2uHuEHZrcnF158RFLEgR8m+2ZQSUJS3EtoEb6cGLJkfasQx
         lHPcvToE1PQEntSnwDZwntA49o3R1Tt4+ANgRF1E7IkNkZ4l4PSLOH72XDDoGm2yBx1I
         lVJth2xj0z6ZFSBO8wRTxZ5694zzlHbeoQ7nFgvwai/7Qw7hc1I2vyycJ/kROGCs66Yt
         2JXA==
X-Gm-Message-State: AOAM531JJXw2wfFcMHNhqTJ80XUR7JXDFw8PhUTToEhPdGd2Ynn7uDx4
        dwV4SOG9GBKid9eeetljwYc=
X-Google-Smtp-Source: ABdhPJyVxd72m3HeYLYSEAfgc6LYKBmg5nlQkt7RFmVf1fRFg/RHUf9SFsYw3fBIrWFpTidxMt4rmg==
X-Received: by 2002:a17:90b:1101:: with SMTP id gi1mr8841900pjb.11.1634075693901;
        Tue, 12 Oct 2021 14:54:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id m73sm12038730pfd.152.2021.10.12.14.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:54:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH 2/5] scsi: ufs: Improve source code comments
Date:   Tue, 12 Oct 2021 14:54:30 -0700
Message-Id: <20211012215433.3725777-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012215433.3725777-1-bvanassche@acm.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the descriptions above data structures that come from the UFS
specification match the terminology from that specification. This makes
it easier to find these data structures while reading the UFS
specification.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index de95be5d11d4..9a754fab8908 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -425,7 +425,7 @@ struct ufshcd_sg_entry {
 };
 
 /**
- * struct utp_transfer_cmd_desc - UFS Command Descriptor structure
+ * struct utp_transfer_cmd_desc - UTP Command Descriptor (UCD)
  * @command_upiu: Command UPIU Frame address
  * @response_upiu: Response UPIU Frame address
  * @prd_table: Physical Region Descriptor
@@ -451,7 +451,7 @@ struct request_desc_header {
 };
 
 /**
- * struct utp_transfer_req_desc - UTRD structure
+ * struct utp_transfer_req_desc - UTP Transfer Request Descriptor (UTRD)
  * @header: UTRD header DW-0 to DW-3
  * @command_desc_base_addr_lo: UCD base address low DW-4
  * @command_desc_base_addr_hi: UCD base address high DW-5
