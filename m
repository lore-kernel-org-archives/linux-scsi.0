Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03C1C54E8D
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA62A20720
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgEKUJ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:09:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36184 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:09:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id z1so5238722pfn.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HHTgIAS/UZisrDeGTFK4IPVnQikI5kG1hd7y9VNsaCI=;
        b=siTYst4jOObrwYJ8npzDoZw+j2dVEkhZmRLvWR0R0mFgMvh+zz2A2Zy/ndKO1FaM9N
         mfIIfFMx7SJ2Jxyi++fq+K/THxqlhtXLEBiJNLBuR5J/ERE56l8bCXEd9J4v8txjrXJ3
         VIq77EMtBo1qbL7S69/0tMYdPcW2hapD10+KzpQ+lV1iHiNXncmhYqunSGw5JQP7QzIm
         UBBX+Kbm3DSPzkTTo9iYYMZYHEm9YmaO6uRJmXtmSYbI7y3asfmo1u1mKDvTv8YNewWe
         D9vFfIxlfUmgh/OC0xWy0wy0D1j0dqx5Fsn+1RKnXi3XgjhahUURs2rDNSqX5yK6Fwxz
         LnZw==
X-Gm-Message-State: AGi0PuYqyZ/lkT9ZSuOteRPp9d2NbYPJE06vczIGKksCu+oaDSH/MpWV
        w33Z046uWj4Bwu6BZ6zR830LDFRkFm8=
X-Google-Smtp-Source: APiQypIdUM4DkqcfJmdpnxPKHzSDb0eEFcwn42JJQmsh8DFK/Uamie01jBqYskGN2ZhAUqgFFi28Hw==
X-Received: by 2002:a63:b11:: with SMTP id 17mr16225152pgl.3.1589227794168;
        Mon, 11 May 2020 13:09:54 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:09:53 -0700 (PDT)
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
Subject: [PATCH v5 01/15] qla2xxx: Fix spelling of a variable name
Date:   Mon, 11 May 2020 13:09:32 -0700
Message-Id: <20200511200946.7675-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org>
References: <20200511200946.7675-1-bvanassche@acm.org>
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
