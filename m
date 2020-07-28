Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85879C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 14:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69CB2206D8
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 14:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbgG1O4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 10:56:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:18905 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730455AbgG1O4P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jul 2020 10:56:15 -0400
IronPort-SDR: NLcY2Oov2g4FFaw0qvLoUUk5YdZGHGG9C0rorwz+kd/ebbN4j+/d6LMyQB0//OvhekpkQklx4R
 PLfNPZoDSsiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="139255000"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="139255000"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 07:56:14 -0700
IronPort-SDR: QWzjGFxHsChmxq6d5+7xY871R3N+oDMypTQlz4lkTJXlqGG1bUn8aGqjUpD/WCXjkOEVbXgd6t
 WqD41I6QZOog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="312648921"
Received: from silpixa00399752.ir.intel.com (HELO silpixa00399752.ger.corp.intel.com) ([10.237.222.180])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jul 2020 07:56:12 -0700
From:   Ferruh Yigit <ferruh.yigit@intel.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, Ferruh Yigit <ferruh.yigit@intel.com>
Subject: [PATCH] scsi: lpfc: Fix typo in comment for ULP
Date:   Tue, 28 Jul 2020 15:56:06 +0100
Message-Id: <20200728145606.1601726-1-ferruh.yigit@intel.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UPL -> ULP for "Upper Layer Protocol"

Signed-off-by: Ferruh Yigit <ferruh.yigit@intel.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 25653baba367..a4d07b7a4dd4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17820,7 +17820,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
  * receive sequence is only partially assembed by the driver, it shall abort
  * the partially assembled frames for the sequence. Otherwise, if the
  * unsolicited receive sequence has been completely assembled and passed to
- * the Upper Layer Protocol (UPL), it then mark the per oxid status for the
+ * the Upper Layer Protocol (ULP), it then mark the per oxid status for the
  * unsolicited sequence has been aborted. After that, it will issue a basic
  * accept to accept the abort.
  **/
-- 
2.25.4

