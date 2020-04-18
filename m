Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525D1C38A2B
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 06:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DE35221EA
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 06:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgDRGjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 02:39:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2405 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbgDRGjk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 02:39:40 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E465CA996F4E359CCD46;
        Sat, 18 Apr 2020 14:39:36 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 14:39:27 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <tglx@linutronix.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: bfa: remove unneeded semicolon in bfa_fcs_lport_ns_sm_online()
Date:   Sat, 18 Apr 2020 15:05:53 +0800
Message-ID: <20200418070553.11262-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

drivers/scsi/bfa/bfa_fcs_lport.c:4361:3-4: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index e09bf0729deb..297a77f5806c 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -4358,7 +4358,7 @@ bfa_fcs_lport_ns_sm_online(struct bfa_fcs_lport_ns_s *ns,
 			bfa_sm_set_state(ns,
 				bfa_fcs_lport_ns_sm_sending_gid_ft);
 			bfa_fcs_lport_ns_send_gid_ft(ns, NULL);
-		};
+		}
 		break;
 
 	default:
-- 
2.21.1

