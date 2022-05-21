Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56074C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 11:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353297AbiEULPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 May 2022 07:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355031AbiEULOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2022 07:14:07 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF6634B98;
        Sat, 21 May 2022 04:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=++Uj7IgLMOAZzf7Fb2LwpohYAOxsu5/IYJ4RtAmt9hg=;
  b=IcgfdQuTUFtpS6QBifM8h2td8J6mprw3PPTdm90zW1bKLPsqkTMOAMDO
   xWs+kKV1Fv95nVzMsdlI2KjOyYL7Z16EZ1cBulgvu8+lg6ozKDpLK0ZeW
   2JfHjV8iLevD7s0Op23zZlepXQeAybItoZ/AyjyYCbGeNjR6GqUvX7leV
   w=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727997"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:12:08 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     kernel-janitors@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pmcraid: fix typo in comment
Date:   Sat, 21 May 2022 13:11:39 +0200
Message-Id: <20220521111145.81697-89-Julia.Lawall@inria.fr>
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
 drivers/scsi/pmcraid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 3d5cd337a2a6..bfce60183a6e 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -1434,7 +1434,7 @@ static int pmcraid_notify_aen(
 		return -EINVAL;
 	}
 
-	/* send genetlink multicast message to notify appplications */
+	/* send genetlink multicast message to notify applications */
 	genlmsg_end(skb, msg_header);
 
 	result = genlmsg_multicast(&pmcraid_event_family, skb,

