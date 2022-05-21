Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC6EC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 11:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355087AbiEULPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 May 2022 07:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355050AbiEULOI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2022 07:14:08 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C5213327F;
        Sat, 21 May 2022 04:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KIkX41j6V5jfrTv89vOQJuGQ4iVzCVQtr2ohyilPIsw=;
  b=ZVTsdMtRMleeiL6TCAb7qZ1V1DEz3ZRDCPCoTlU2ep0qU259GbG6OmjY
   h06lf1F3tEyaTjq3z5MIPH26RKQDP868WmjyEbABszodOWxVadBoYnN+O
   c81nOXJvXfe2D147Ck9WxyJ9XHpYCQ+iYsC8wnOEFKOYR+HBEHfDOODCu
   w=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727999"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:12:08 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc:     kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: isci: fix typo in comment
Date:   Sat, 21 May 2022 13:11:41 +0200
Message-Id: <20220521111145.81697-91-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/scsi/isci/request.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index ac17e3a35d2c..6370cdbfba08 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2182,7 +2182,7 @@ static enum sci_status atapi_data_tc_completion_handler(struct isci_request *ire
 	case (SCU_TASK_DONE_UNEXP_FIS << SCU_COMPLETION_TL_STATUS_SHIFT): {
 		u16 len = sci_req_tx_bytes(ireq);
 
-		/* likely non-error data underrrun, workaround missing
+		/* likely non-error data underrun, workaround missing
 		 * d2h frame from the controller
 		 */
 		if (d2h->fis_type != FIS_REGD2H) {

