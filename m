Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C96BC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 11:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbiEULMF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 May 2022 07:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbiEULMB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2022 07:12:01 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3822AC6C;
        Sat, 21 May 2022 04:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w6FEaixBY/UPa4VrqVSgQE2Iu1UffwUZOqZRzmF5TYY=;
  b=m9JZWQkUhgWrZPNnyHVxkb370164+e/4WNlBb2dJOBYBOMp7nG4kQ0t6
   xybvrxFZW/vW9Rs48aFcJk6Owx+Tkp0ehEK0aLJxCGqnIq8G3M3cfhzaQ
   LNuFhuNhVlIuvP0RoXw9hHvLAOFpTORAx3E6Q4DmvjVjD0euVYpHuw6U3
   g=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727907"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:54 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     "K. Y. Srinivasan" <kys@microsoft.com>
Cc:     kernel-janitors@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: storvsc: fix typo in comment
Date:   Sat, 21 May 2022 13:10:22 +0200
Message-Id: <20220521111145.81697-12-Julia.Lawall@inria.fr>
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
 drivers/scsi/storvsc_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5585e9d30bbf..3a9d7bac26f7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -538,7 +538,7 @@ static void storvsc_host_scan(struct work_struct *work)
 	host = host_device->host;
 	/*
 	 * Before scanning the host, first check to see if any of the
-	 * currrently known devices have been hot removed. We issue a
+	 * currently known devices have been hot removed. We issue a
 	 * "unit ready" command against all currently known devices.
 	 * This I/O will result in an error for devices that have been
 	 * removed. As part of handling the I/O error, we remove the device.

