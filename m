Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106F7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE22660EDF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbhJGUs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:57 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:45767 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbhJGUs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:57 -0400
Received: by mail-pj1-f48.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so6120579pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rj38THqlipbf957/eLANcbrd/cuWQkbuwlC720xOows=;
        b=7IrJUZ8e7ZlMnKeBTu9soXY/7nah6Ma0XipXzVai4Iy+QrB1GPUlQcafyopB3xeMTH
         CFWsomzJ52Li4vbCgeKfyH+g6On1aVhMoykEEeP+Rj5QYeiLy9gkaZDCaTZbYDXTLroJ
         EX8bxQbMrZ8MGJglmWbI9s++R1OWDBMqB/1vbp3YOMCmjpU/9Zy2ssjCquWnhmG9nhsT
         mKPeZPJiYFWz9Bub4FgJ/xtVgFQZFgVJbCO7BFWixBHffGCEt/63tnfsV++yNOlOYL0f
         8q/EW5YVHkKO439Vyb6qASEQ/nPzy0sb79/6uKcD+0gilQZm3CeW+zkEePXjh3bXt9Yd
         vEnw==
X-Gm-Message-State: AOAM533OWoJwMQRlRKrUWbV8DWZb/qYUuAi03El17hOBZh1vil6um6AC
        njivsyyGniWas5wkOZFNvkU=
X-Google-Smtp-Source: ABdhPJymGKq3k3s3w0AR2FPssuzVSfEYXwyem3xIuB+XWK6LI38ASGVpod5RxXv8TjFw0nXeemEHkg==
X-Received: by 2002:a17:902:bf43:b0:13e:28f8:9e84 with SMTP id u3-20020a170902bf4300b0013e28f89e84mr6038391pls.58.1633639623102;
        Thu, 07 Oct 2021 13:47:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:47:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 86/88] isci: Remove a declaration
Date:   Thu,  7 Oct 2021 13:46:12 -0700
Message-Id: <20211007204618.2196847-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no function with the name isci_queuecommand(). Hence remove the
declaration for isci_queuecommand().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/isci/task.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index 8f4531f22ac2..cae168b8916f 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -182,8 +182,4 @@ void *isci_task_ssp_request_get_response_data_address(
 u32 isci_task_ssp_request_get_response_data_length(
 	struct isci_request *request);
 
-int isci_queuecommand(
-	struct scsi_cmnd *scsi_cmd,
-	void (*donefunc)(struct scsi_cmnd *));
-
 #endif /* !defined(_SCI_TASK_H_) */
