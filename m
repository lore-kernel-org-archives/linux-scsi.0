Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB968C47247
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D48642082E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgEGE2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 00:28:46 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45732 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgEGE2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 00:28:46 -0400
Received: by mail-pl1-f195.google.com with SMTP id u22so1541994plq.12
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2020 21:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HHTgIAS/UZisrDeGTFK4IPVnQikI5kG1hd7y9VNsaCI=;
        b=ocVm/vbG5VtIYpW8cCSu8Lk4wMbCakiQnU/e6zUu2N8CXA0Sqvu6Gn6h7OiFNCoyia
         3JNVzOExpWPjDYLIGi6TX6U0YmB7VDPO/u7jh1I7wle0VXmu+/IVhHnAk/dOTt+ue12B
         EkqtA6mMBESZH1Q6VAyEXHbwFbcHsvRRY8szchESk1e19MKdpm88GFEZmCZBrOqnuFsi
         WhCy2BmVYDZeFfFRvaE8Yskwc8dIMV3XXnaLUf9bCNcRKGNtzGdWRr1C4ZtRMskG7qX6
         32W3P1UofUdIbgdL4Ya+178Z6tghiD1EljNd8r8yqQL9bsjgP4DzaR5IGBd7lKcnnueE
         MR9A==
X-Gm-Message-State: AGi0PuafCxemngvSIYZqLNKxD6lBbnHxkbaay3xe2ELk4QvY81o6c8Tn
        ZEJO5E/JR7/AF5xpQDLOojY=
X-Google-Smtp-Source: APiQypJCsB93FbcavjR6L+YCCEr2+rDgqoVYWHCmOpU89ZoAVUrIUXhIfeIWQI6VCSQHqIF/3DGzpw==
X-Received: by 2002:a17:90a:d709:: with SMTP id y9mr13784920pju.50.1588825724216;
        Wed, 06 May 2020 21:28:44 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:246f:3453:e672:e40c])
        by smtp.gmail.com with ESMTPSA id z28sm3471028pfr.3.2020.05.06.21.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 21:28:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 01/11] qla2xxx: Fix spelling of a variable name
Date:   Wed,  6 May 2020 21:28:25 -0700
Message-Id: <20200507042835.9135-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507042835.9135-1-bvanassche@acm.org>
References: <20200507042835.9135-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_fw.h   | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index f9bad5bd7198..b364a497e33d 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1292,7 +1292,7 @@ struct device_reg_24xx {
 };
 /* RISC-RISC semaphore register PCI offet */
 #define RISC_REGISTER_BASE_OFFSET	0x7010
-#define RISC_REGISTER_WINDOW_OFFET	0x6
+#define RISC_REGISTER_WINDOW_OFFSET	0x6
 
 /* RISC-RISC semaphore/flag register (risc address 0x7016) */
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 95b6166ae0cc..f8fe0334571f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2861,7 +2861,7 @@ qla25xx_read_risc_sema_reg(scsi_qla_host_t *vha, uint32_t *data)
 	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
 
 	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
-	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET);
+	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET);
 
 }
 
@@ -2871,7 +2871,7 @@ qla25xx_write_risc_sema_reg(scsi_qla_host_t *vha, uint32_t data)
 	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
 
 	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
-	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET, data);
+	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET, data);
 }
 
 static void
