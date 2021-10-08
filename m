Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338B7C43219
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201186112D
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbhJHU1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:19 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:45958 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbhJHU1N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:13 -0400
Received: by mail-pg1-f179.google.com with SMTP id q12so3446075pgq.12
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zV95fuzcw/1F5E6I+0GGTqawzS1QjJLjxm6SJSTdxs=;
        b=bw30OelT86roJxCjTbySa+uQw5oFMDhqw1NJmVF0ujVzGouGeofcm6hQFM7c4zjlCq
         Ci+Y/c0FVMBTELJa98zc6S4vky3DKKvSbcXX4R1DvYbjQlJ33c55iFwAuuuWTFLERHSJ
         4DbmUxXRQGQy2O8uzYfbNsPaygFcSHUyckoaHKf0ClakZVtknygRbbxsILMda3bEAU/6
         jBAs7AeuF5IN+lhfIDISkYBUTrZcU1EmGhPCML38DPF1hzla+mDM7OZzTcecyZZOq8pX
         wGeM2iIZOFGeRUrwasRfIoklo8/n5k0Q4WvyAHxEduIukm+D8YNazsis5BASzT+gg9ra
         m0iw==
X-Gm-Message-State: AOAM532vwz6BVnsgtMJumOuDIAmtZRpCPpNp29VoA8S0TKkkfw7oIOap
        sfdW4u4XrCm9a2K+RWVBGMw=
X-Google-Smtp-Source: ABdhPJyTHGpxQlDEs8oOyBGGRD/05+IOd0AJC7wR3lQZCER0oV7mDqXAd6EK1y13PVzTwaNqmCgP6A==
X-Received: by 2002:a63:4f25:: with SMTP id d37mr6479530pgb.61.1633724717543;
        Fri, 08 Oct 2021 13:25:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 39/46] scsi: qla2xxx: Remove a declaration
Date:   Fri,  8 Oct 2021 13:23:46 -0700
Message-Id: <20211008202353.1448570-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
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
