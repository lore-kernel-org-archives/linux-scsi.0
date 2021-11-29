Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A0BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242534AbhK2Tvh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:37 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:53975 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhK2Ttg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:36 -0500
Received: by mail-pj1-f49.google.com with SMTP id iq11so13515129pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=spXTifj5M9HBJDRM6qGu3Iug+LkX07oPsHn9kJIHw6o=;
        b=zHZLgB8XOHZG5owRNh3wX3pOcqS2h3FLYN0/NSPB/3mNcE7NRd+g+lAhYkeap+4HtB
         Inm4pcbcKI4h9wOu/5g411XIyLcApnsRv57S5n3cBYt3St3F7lMQLEI3llxPS4TSKaHz
         mSpvKIrpFwWQtQYvSFvRFuuoRY/zVaXfBRjdFHqE23eLT6JFnsUAQQtzPA9s1RPyNJM3
         ilfKRDeprn+44twEw2hw0nfLWL3SyY4/5d+YUc29RQQ0m12YWIo4UJH8CRRz91asLR1L
         wnRJoxWWglGqlJJwXeWSqArb2Z4aKHS72Bwki0ZrC5IRFTdhvPK/EQDVbm/MOC/FhQ98
         Mxfw==
X-Gm-Message-State: AOAM530x/Xjot+8yfwDvzN+6j+DGb8c65qPX0Qx9/XVpoHcBZv+Nnibc
        JH+P6AMGMpHOE2tcN6H3Alk=
X-Google-Smtp-Source: ABdhPJwLAny2vwQW4JSN70pGA3qIN6iTHejy9yg3BKJNiTjWV9aerUq9Om8nlsZPgdyKsf0u3qpofA==
X-Received: by 2002:a17:902:f693:b0:142:9ec:c2e1 with SMTP id l19-20020a170902f69300b0014209ecc2e1mr61943569plg.34.1638215177950;
        Mon, 29 Nov 2021 11:46:17 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:17 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 01/12] scsi: core: Suppress a kernel-doc warning
Date:   Mon, 29 Nov 2021 11:45:58 -0800
Message-Id: <20211129194609.3466071-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Suppress the following kernel-doc warning:

drivers/scsi/scsi_scan.c:129: warning: Function parameter or member 'dev' not described in 'scsi_enable_async_suspend'

Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 23e1c0acdeae..2f80509fa036 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -122,7 +122,7 @@ struct async_scan_data {
 	struct completion prev_finished;
 };
 
-/**
+/*
  * scsi_enable_async_suspend - Enable async suspend and resume
  */
 void scsi_enable_async_suspend(struct device *dev)
