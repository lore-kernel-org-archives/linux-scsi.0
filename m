Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEACEB64DA
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 07:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjGTHLx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 03:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjGTHL3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 03:11:29 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A788F358C
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 00:10:24 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R63jn18wZzBRDsS
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 15:10:21 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689837021; x=1692429022; bh=KFPxENNW0VwHdPoTYLfLgku/l1a
        nuBYSc4ixw/H739o=; b=uWZONMKO40xQZxIJVFWzNKk3Hqtj+HHVbUqWrk5xaVM
        pENYv+pIWDKsDOYYN+NqVLaSpLaQ1lCgw9qnm3MgrzNGKGqzW73ok8307QUUSK5V
        t6HfhdGXYKhVLYxvIRNulhEVRTZw/jbdfnUD7uLhhWGAUGWvrUAXaeyPvnF5PKRH
        /Av9BioHEO35E99qjECEy7BW5ZAi+3DlxySD3QqnuvRvPUtLaun/r4Y24Wo8ObHl
        KsVxHNc4FiEhiGIx/i8wsFCZwhVud6aDBJ+FkjaqmRbTC1sxw+lrcTZURBquf+Sr
        aANwTAf4+fE4HWis3teUIFW1N7an2M3tnRYy87jNdYA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id h88Y6Bm_k-55 for <linux-scsi@vger.kernel.org>;
        Thu, 20 Jul 2023 15:10:21 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R63jm5JymzBRDsD;
        Thu, 20 Jul 2023 15:10:20 +0800 (CST)
MIME-Version: 1.0
Date:   Thu, 20 Jul 2023 15:10:20 +0800
From:   sunran001@208suo.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] aic7xxx: Remove unnecessary parentheses in hyperv.h
In-Reply-To: <20230720070717.3013-1-xujianghui@cdjrlc.com>
References: <20230720070717.3013-1-xujianghui@cdjrlc.com>
User-Agent: Roundcube Webmail
Message-ID: <999e85cf01a7117c2c968831ec703730@208suo.com>
X-Sender: sunran001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix "return is not a function, parentheses are not required" checkpatch
error.

Signed-off-by: Ran Sun <sunran001@208suo.com>
---
  drivers/scsi/aic7xxx/aic79xx_inline.h | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_inline.h 
b/drivers/scsi/aic7xxx/aic79xx_inline.h
index 09335a3c8691..7644e3d2ec22 100644
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h
+++ b/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -50,7 +50,7 @@ static inline char *ahd_name(struct ahd_softc *ahd);

  static inline char *ahd_name(struct ahd_softc *ahd)
  {
-	return (ahd->name);
+	return ahd->name;
  }

  /************************ Sequencer Execution Control 
*************************/
@@ -157,13 +157,13 @@ do {								\
  static inline uint8_t *
  ahd_get_sense_buf(struct ahd_softc *ahd, struct scb *scb)
  {
-	return (scb->sense_data);
+	return scb->sense_data;
  }

  static inline uint32_t
  ahd_get_sense_bufaddr(struct ahd_softc *ahd, struct scb *scb)
  {
-	return (scb->sense_busaddr);
+	return scb->sense_busaddr;
  }

  /************************** Interrupt Processing 
******************************/
