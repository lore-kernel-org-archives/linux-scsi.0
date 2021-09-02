Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01641C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE58F61057
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347807AbhIBWnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:43:20 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33754
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347699AbhIBWnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 18:43:15 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 3EA8740178;
        Thu,  2 Sep 2021 22:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630622535;
        bh=hzMq+mvgujqtRWYknQ4NY0yiqZ+ExiooC1lQTywchwE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=uxKD3uOgVi+8FJ+7BuL1LJyvOwg4JeNgZkrdPWJWo9kFm6REg6WCpnH/2wbi8HLHl
         qEIrchxaFj5hdvG54iFOWNTrD9mWHJ/j5ikQYMDNvGbTRk61USfNhwIDTXNQeCpdFs
         rB6eX2QVBP2iTurAPZfqm0s9MGvFUkbneAGGQ9GrKkoehg42ev39nKN8eDvLVyTerw
         kzuScPLHVXf4GJ77HMYvyJPn0ymjWNZXDFdanTe5NV0S44y3V/MnPV3SepLOKGYatk
         Cs+HZ83X0cQwmzPZD9hCz5EpqwKTlV+t3ERiUziQpz+3H8Yzs5//lBh5BrnTKWOc+w
         zBftdCfzMvioA==
From:   Colin King <colin.king@canonical.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: clean up some inconsistent indenting
Date:   Thu,  2 Sep 2021 23:42:15 +0100
Message-Id: <20210902224215.57286-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a couple of statements where the indentation is not correct,
clean these up. Remove a redundant break statement.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 770b241d7bb2..1b79f01f03a4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2178,7 +2178,7 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 		mpt3sas_check_cmd_timeout(ioc,
 		    ioc->ctl_cmds.status, mpi_request,
 		    sizeof(Mpi2DiagReleaseRequest_t)/4, reset_needed);
-		 *issue_reset = reset_needed;
+		*issue_reset = reset_needed;
 		rc = -EFAULT;
 		goto out;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2f82b1e629af..d383d4a03436 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10749,8 +10749,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
 		_scsih_pcie_topology_change_event(ioc, fw_event);
 		ioc->current_event = NULL;
-			return;
-	break;
+		return;
 	}
 out:
 	fw_event_work_put(fw_event);
-- 
2.32.0

