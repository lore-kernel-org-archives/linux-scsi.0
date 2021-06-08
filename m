Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9F6C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 06:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 359A46124C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 06:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhFHG71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 02:59:27 -0400
Received: from m12-13.163.com ([220.181.12.13]:57030 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhFHG70 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Jun 2021 02:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=TFx90
        O0hY6oZsjCcebxoSDvhXd3dlATMfUhGTOGRpvI=; b=KpQqcEgi4P6+j7ahbNb3B
        blXHvSh9YIsNUH7erDIpQr34ibIh5us6shyGqIHIf1VFEN40FxeeIm6gMZ7t4RqD
        VjPrJEgMycYwSq42uabJcjR91Gk9a40fgUjjTov65adVemcQ023Y8e1G4PefSQlZ
        LumJ26lpoQ+YawyRYyfflQ=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowAB3enog0b5gj_6UFA--.55197S2;
        Tue, 08 Jun 2021 10:08:33 +0800 (CST)
From:   lijian_8010a29@163.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        ching2048@areca.com.tw, lee.jones@linaro.org,
        vaibhavgupta40@gmail.com, gustavoars@kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: arcmsr: arcmsr_hba: Removed unnecessary 'return'
Date:   Tue,  8 Jun 2021 10:07:35 +0800
Message-Id: <20210608020735.225108-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAB3enog0b5gj_6UFA--.55197S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF4kJw1rZrWkuw1DKryxAFb_yoW8AFWDpa
        1UX347Ka1qyaykta1UZrs7ZF1ay3WxKFy2va47t34kCF15WrWkJrW5Kwn2qF1rG3yrWw17
        ZrWDJr4UG3W7twUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jGv38UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbi3wGrUGB0Gd0DUwAAsl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 930972cda38c..8e2c5758944e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -532,7 +532,6 @@ static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 			timeout,retry count down = %d \n", pACB->host->host_no, retry_count);
 		}
 	} while (retry_count != 0);
-	return;
 }
 
 static void arcmsr_hbaD_flush_cache(struct AdapterControlBlock *pACB)
@@ -1973,7 +1972,6 @@ static void arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 			"arcmsr%d: wait 'stop adapter background rebuild' timeout\n"
 			, pACB->host->host_no);
 	}
-	return;
 }
 
 static void arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)
@@ -4251,7 +4249,6 @@ static void arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
 				rebuild' timeout \n", pACB->host->host_no);
 	}
-	return;
 }
 
 static void arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)
@@ -4419,7 +4416,6 @@ static void arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_C:
 		return;
 	}
-	return;
 }
 
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
@@ -4473,7 +4469,6 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 		pci_write_config_byte(acb->pdev, i, value[i]);
 	}
 	msleep(1000);
-	return;
 }
 
 static bool arcmsr_reset_in_progress(struct AdapterControlBlock *acb)
-- 
2.25.1


