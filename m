Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B0DC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E5F26120F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhFIJOC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:14:02 -0400
Received: from m12-13.163.com ([220.181.12.13]:47940 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232580AbhFIJOB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 05:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=QYJvq
        PoxNFu7owdPdoBlI490iQR4KoKc0CPfEqZejlw=; b=NeehZR5uNT+hf7R9JyQPZ
        wKxVac2X+xeLrnUgTdjYdfdGlm8BhkeBwI2NGgyXufkb4Fn2La2ptczKLOzianRU
        WxQQ1D88PTF5VMRpCB+Uj5/czYyDNT9khDB5+y2lOwXRlfKUzVrcQBoEBa43nzA+
        sRjVw2K8GxE1BSODLZyWG0=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowAC3uravhcBgzsueFQ--.6593S2;
        Wed, 09 Jun 2021 17:11:12 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_debugfs: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 17:10:11 +0800
Message-Id: <20210609091011.535407-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAC3uravhcBgzsueFQ--.6593S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFWxGrWxGF4fGF18Aw13Jwb_yoWftrcEkw
        s7Zr4fJwsrAry2vFyxGw17Aayq9a13XFn29FsYqryfCwsxWryUAw40grs0qrWrZr4DXF1D
        G3Zagr92yr15CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnE387UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiShCsUFPAOocCTwAAsF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index c67e8a0e0b32..a353f6ed9b2f 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1845,7 +1845,6 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif = jiffies;
 #endif
-	return;
 }
 
 /**
@@ -1883,7 +1882,6 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif = jiffies;
 #endif
-	return;
 }
 
 /**
@@ -6444,7 +6442,6 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		}
 	}
 #endif
-	return;
 }
 
 /*
-- 
2.25.1


