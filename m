Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D74C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C08C260ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbhJLXj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:28 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:53149 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbhJLXjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:23 -0400
Received: by mail-pj1-f53.google.com with SMTP id oa4so814508pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zV95fuzcw/1F5E6I+0GGTqawzS1QjJLjxm6SJSTdxs=;
        b=IPjI1ZLzbiVcZ2VKtmKd0aV8+d/yznGQb0IXvxSbM6Ny6qvsrv8G3jO5YxJVqHrzET
         PiDGJ/mzJyBrBcJKIPxOgraaUCjQuvJKsdedMw/pIDD1voBG06He1sHbWfr53YvqcQlC
         KnWUUYdIun9wWWJCL1OsSHOxFiwj9Vo7TJfOnk37Urp2nxRuSvTj/mSUk0UQ22pnzVyb
         RASInZqnnS/Xylt8C3LWB5UitPBXKzk01jgbD0+k8LV5z2EJ0Numuy4tDC8Ynju2Evfw
         uRqIF7Q9LsR5SoRKyBXQazg2+IOIOum58oe6oM3BbpVadML5USBR0QOXI6WnkL1GIIcn
         G2cA==
X-Gm-Message-State: AOAM5327cA0syBeyQViTD2H5BkiLQjgK5butjAK7OmvJASsoxMwklePU
        lcMNLMN34uAV9SXQXaAA6Qc=
X-Google-Smtp-Source: ABdhPJyJ8BapE44ZgkdKuDYOV0vs4gLIbvun8+EW6TgTA4L8JZO9EbmUogGTavBx2/jKQmnacnNvLQ==
X-Received: by 2002:a17:90a:290b:: with SMTP id g11mr9255723pjd.35.1634081840759;
        Tue, 12 Oct 2021 16:37:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 39/46] scsi: qla2xxx: Remove a declaration
Date:   Tue, 12 Oct 2021 16:35:51 -0700
Message-Id: <20211012233558.4066756-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since there is no definition for the qla2x00_host_attrs_dm array, remove
its declaration.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 8aadcdeca6cb..5ff974e98783 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -743,7 +743,6 @@ uint qla25xx_fdmi_port_speed_currently(struct qla_hw_data *);
  */
 struct device_attribute;
 extern struct device_attribute *qla2x00_host_attrs[];
-extern struct device_attribute *qla2x00_host_attrs_dm[];
 struct fc_function_template;
 extern struct fc_function_template qla2xxx_transport_functions;
 extern struct fc_function_template qla2xxx_transport_vport_functions;
