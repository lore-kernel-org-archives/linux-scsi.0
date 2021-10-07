Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63A1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0B0A610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbhJGVWa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:30 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:54972 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbhJGVW2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:28 -0400
Received: by mail-pj1-f49.google.com with SMTP id np13so5901057pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zV95fuzcw/1F5E6I+0GGTqawzS1QjJLjxm6SJSTdxs=;
        b=A0Wv2G+QHNO5S5eQwfq6qrGZYtFShUjKaUc176vUdJJHzRWqtrMXVsjNNEqLUcv5q4
         6/9nKTNkMuhT9mz7t4pQl+HYdJ/c9KjgUcnJud0d/SfRH/rfnQktwMiyxZzUy2vByyyX
         BFIXio5KV5MZgNjOFDG7GJAUDERQiqr7OoYbb0WHI5gtj9q3mah8JbBj3latPIIKInq6
         y1Q7yvzvHn+vbjgEnJMHWqA1YiMfXTEjB2dji6hlYz188ketFXp/eJHh4wlqUponr4se
         TE4vi36ftMA2NtDFagM8ioy4le74CxlsAq4h6aAFAYJ3H718V+Chpzv1O1lUXU+HaGeH
         6IGw==
X-Gm-Message-State: AOAM532JXdOq7bost4eT76gSLojWWtB384BSuBAUUOBSOEQ+1yLDXbcT
        SiJS5Y+T33ciEzLg4YsDm+A=
X-Google-Smtp-Source: ABdhPJxs2UO7mYW3p92yxIeONM2ATMsQFRHe1zd4VhkdPaTFfARi7/E4LUnwbIZ9G61u5Pnp6Y78wg==
X-Received: by 2002:a17:903:1207:b0:138:e2f9:6c98 with SMTP id l7-20020a170903120700b00138e2f96c98mr6169663plh.11.1633641634285;
        Thu, 07 Oct 2021 14:20:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 39/46] scsi: qla2xxx: Remove a declaration
Date:   Thu,  7 Oct 2021 14:18:45 -0700
Message-Id: <20211007211852.256007-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
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
