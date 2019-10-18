Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA55CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 22:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46E520679
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 22:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571437029;
	bh=3csVmTOHNGTB+c9xUv/fHEeweHnvr5OV6v+ydEEUMDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ty7JKFwOoayPBNLdno324Y78YjtUsj+RWJ+UQs+zXalbMTYsAbSKF47WWu42MsmW/
	 gX7QeuGJA46L3qVZrhMqKn0VrFbxvYrJhnRPERWX0P61n1AS2JkQzm15PJ6E+9CiyJ
	 yOhl5gEnBbF00RzKjZTV09k9JDvE7e2PSFd8frp4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393234AbfJRWRB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387430AbfJRWH4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84612222D1;
        Fri, 18 Oct 2019 22:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436476;
        bh=3csVmTOHNGTB+c9xUv/fHEeweHnvr5OV6v+ydEEUMDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UtpwT+NJQ000CGAj3zB4FB8nZvH5H6I4HYqA1AtwkooSYKHpy4ipWs+TCObEgWlyr
         3im/NQlgWJNygbqYLc9z4taAA0LjIXdbw66wcerGbekhVds4IwIBzQXbtnSGsTt7up
         W3KbEiV/6VfxJm5K47LHSrWV52Z3FHKKin55aoFo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/56] scsi: lpfc: Fix a duplicate 0711 log message number.
Date:   Fri, 18 Oct 2019 18:06:59 -0400
Message-Id: <20191018220753.10002-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2c4c91415a05677acc5c8131a5eb472d4aa96ae1 ]

Renumber one of the 0711 log messages so there isn't a duplication.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4ade13d72deb3..07cb671bb8550 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4152,7 +4152,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	/* If pCmd was set to NULL from abort path, do not call scsi_done */
 	if (xchg(&lpfc_cmd->pCmd, NULL) == NULL) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "0711 FCP cmd already NULL, sid: 0x%06x, "
+				 "5688 FCP cmd already NULL, sid: 0x%06x, "
 				 "did: 0x%06x, oxid: 0x%04x\n",
 				 vport->fc_myDID,
 				 (pnode) ? pnode->nlp_DID : 0,
-- 
2.20.1

