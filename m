Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24785C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AE62207F9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgERVRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 17:17:21 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42937 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERVRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 17:17:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id k19so4738443pll.9
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2020 14:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v6E7r3HQnFANVdICPIMBt6UBQTbIMqrW26GcfdRgP6Y=;
        b=Y6thDzdM2TrDQqsb6u5imMob4cYaX7KATan5Zg7+P571eb9Wqeb7Bo519AHW5yFoRu
         pofc7TpAdWU2KTEaVMmIYMaPTJLjpPoCoHlYixXT8feaIygGXFYqd50z55NdJ9ScG50J
         cPxieC6rqR0hOllgJWFgmXnbRgAy8FGQc3Kda+yOrbPEjIlimKbAfXPEXYgySHp43ZuD
         AUS4XY+hB46cF9G3P8TaKOw5L6qvNGpNJwvi8P/Eo4mCJ6QxNSQEjT78s1Vidw9YGfhw
         /8B0P2lj4clUR8pGUux90liU8cqLf0OblgKKt4QsoOcOw70ky/2Rs8N638W8mK8y1zvK
         85QQ==
X-Gm-Message-State: AOAM530sjoMw4J4WYiRfiN4I8HUPAALzaQY6s9hOvw7cq9IYfomfawwW
        VB3of+yb3w3TlF5IjVqoykU=
X-Google-Smtp-Source: ABdhPJwfZcySCckB+aCrPPUJtOEx8HYtRkK8vV4yIyu8efhb85AUjq4prOSba1xbffwaBC4HDcyezQ==
X-Received: by 2002:a17:90a:c984:: with SMTP id w4mr1420604pjt.9.1589836640433;
        Mon, 18 May 2020 14:17:20 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id i184sm8813123pgc.36.2020.05.18.14.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:17:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v7 01/15] qla2xxx: Fix spelling of a variable name
Date:   Mon, 18 May 2020 14:16:58 -0700
Message-Id: <20200518211712.11395-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518211712.11395-1-bvanassche@acm.org>
References: <20200518211712.11395-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change "offet" into "offset" in a variable name.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
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
