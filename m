Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A75C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 103806112D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhJTVm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:42:58 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:45965 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhJTVm6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:42:58 -0400
Received: by mail-pl1-f177.google.com with SMTP id s1so15246950plg.12
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jiGVxvjAGFMB88xRzaf16FoRpAf00m1HjBqnVUQxRco=;
        b=AG0fJPmLWqLX3LXcqN8WC2TbwIkHIzR1nw6/cLe6Mtk+sjaBTOae5UkLaCjg3Li2Wp
         xzcKNLOW1+dMee+f5GxRvU4dz3E9gKXiLAtus1B0TGwhtmA8uOrZAVc7G3ljObDJFLvy
         TFILdAcPk3AEMng8udJGMNzMUb3n48rHbLPPiopra4akUdUvZLkitjNcvWWzECUrG+7o
         pkSj/ZHHimIvMvLumLqrWG5T1qCYfroDDiiyYfL7ZDXeH6/NiY3Q6h4tiM6GQBpFaaj6
         3qWidnzCADLyigXp3Yqnx1D39Lr5JyG0dS3G6q4rLfABFngfbX21CDZG7ytL1DHW7pgv
         UwLQ==
X-Gm-Message-State: AOAM532WVA07lw/ofugFxa0mbUJcOXwGuJ4R/RIfs5iq7TeNS5Vsl1Xi
        8R1F0PTDoCIph3/VVFQCSAw=
X-Google-Smtp-Source: ABdhPJyxqa8TDXx5OQCKs7t8Pe7pQkmEzO1oZiTAXfzz0PfAOAr3055O3D+UxVnA1qk584VQybttow==
X-Received: by 2002:a17:90b:193:: with SMTP id t19mr1738275pjs.95.1634766043100;
        Wed, 20 Oct 2021 14:40:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:40:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH v2 02/10] scsi: ufs: Improve source code comments
Date:   Wed, 20 Oct 2021 14:40:16 -0700
Message-Id: <20211020214024.2007615-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
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
