Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5CCC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53DEA2065F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgENVf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 17:35:27 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33567 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgENVf0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 17:35:26 -0400
Received: by mail-pl1-f195.google.com with SMTP id t7so72366plr.0
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 14:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjeajmh/Ba/F4xWkb5O/2yaJzxC8J1lWjR/QpNGQRGU=;
        b=jYTECE093oke3JH+JoyuPdjAWkMNEPji3aaEaMmYnyfDYViuDOsg76tnjxnXPmE13i
         Yc32+jfUAKVMPNPuyVDT416Rc+FcaerXHre4J4T92omsGxqt4Xi/pngYhN1HezoCkTrf
         K3WVXb+lElTfoyyIcPmNejEeMwWKKZ2XuGmh/kDoeJjrY9dAZbE0PvUvaL+nX9N8jQ0a
         JvKuofihwTqkKzz625A8wjgz7lT97n+tur71zlKcBxxx0QeWUhoth1XC3zSr/7vkpGd5
         P8OsgJct7W3b30YY5We02RMAw5AoYuDlZxlPx5IryqkBgajwg5UeWhn/KlIOY491Ia2y
         BdvA==
X-Gm-Message-State: AOAM531l2i9NrVdziBIowTJm61YviRzHgDl5WWbfYjl8JOn4Sv+Sn//g
        ZWFki/ZYTQ8OnWjiPPghRfM=
X-Google-Smtp-Source: ABdhPJw2uGRbEa8oZGAOGvxCURlA6hRp6t0laxftpjU1G7C+0DCV6Mw9loVTq1tgZWM4K/+0epAu6w==
X-Received: by 2002:a17:902:5597:: with SMTP id g23mr498302pli.337.1589492125520;
        Thu, 14 May 2020 14:35:25 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:6c16:7f27:8c37:e02d])
        by smtp.gmail.com with ESMTPSA id a142sm145754pfa.6.2020.05.14.14.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 14:35:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v6 01/15] qla2xxx: Fix spelling of a variable name
Date:   Thu, 14 May 2020 14:35:02 -0700
Message-Id: <20200514213516.25461-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514213516.25461-1-bvanassche@acm.org>
References: <20200514213516.25461-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Arun Easi <aeasi@marvell.com>
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
