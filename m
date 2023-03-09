Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8823CC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCIT2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCIT2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:24 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137DB5FEBF
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:23 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id s18so1728590pgq.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9EbEznef8iJjMvb3ab9roSVdm2qWqXIE3r6q0CuMcY=;
        b=QRhEuoGObSmxtNjC4LhZKOVntENh0FevJmsS0cBVFdrJaHf0R/Z323ZXMfrM524WMN
         ZTZScwYAvjsK38DglIQXy3DpPXbZnKbcJZoCu66osQZfCllC9kcRRlRTUENqDZjVcaTJ
         1zXRhxxdeyGnu5Q5iATCYH6om+Jdoqzb6JRi1Q+EKvzbYoJqHuTOHQO+OCvKk6v2eLJI
         whgzpw5zlLYH2rbWbhlxXf/m2PGMVujxJRwI6WfBDvPlNUbC6nRfLO0fzimwqPveW+n/
         hIf8nc5OPEiTZrlObpG7Kd0y5ffFsLIALpSnlJtgwwOOkEv3BN+AJWkOUxHa++KWKTb/
         BHhg==
X-Gm-Message-State: AO0yUKWoISahCxgQjL60xdY59npTO8b1sXWwfyuXKDlg5UiKVWErVVna
        Rd6sEj9T+uvL0rro0g0S3s8=
X-Google-Smtp-Source: AK7set8YdvgKLMFZV4hw9lO5ghcIDmlFQ3pSUgOyxZPoRAr1uNaxSmiUTkW1We+dm/J4RH07tDk4WA==
X-Received: by 2002:aa7:9504:0:b0:5db:ba06:1825 with SMTP id b4-20020aa79504000000b005dbba061825mr20058558pfp.3.1678390102514;
        Thu, 09 Mar 2023 11:28:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 32/82] scsi: elx: efct: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:24 -0800
Message-Id: <20230309192614.2240602-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/elx/efct/efct_xport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 9495cedcc0b9..cf4dced20b8b 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -10,7 +10,7 @@
 static struct dentry *efct_debugfs_root;
 static atomic_t efct_debugfs_count;
 
-static struct scsi_host_template efct_template = {
+static const struct scsi_host_template efct_template = {
 	.module			= THIS_MODULE,
 	.name			= EFCT_DRIVER_NAME,
 	.supported_mode		= MODE_TARGET,
