Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F090FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 20:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242416AbhLBUPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 15:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242903AbhLBUPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 15:15:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149CAC06174A
        for <linux-scsi@vger.kernel.org>; Thu,  2 Dec 2021 12:11:44 -0800 (PST)
Date:   Thu, 2 Dec 2021 21:11:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638475902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=uKEKXvHs/6NxYMJWymT1MfEbyB0ReTK3gJLrVlyxCNw=;
        b=FHC32GA5p/sSpWcqtnrBgU4zUzISM1bFiaTz/PfS1hy9vTywTN3kk33z0lRF6pQL49V+pU
        7TpXeNNplZuVTykzoTdTFbbVaKDVTwYHqhkgnlMdGMFGn/xwJXnZXrjPZbC9F+UsTRslQr
        sIrTbgFeCjY7DTg0yPulbf8UpI3a8tKwfrdWtRFPMS8fy4xiv9z4H2MSIjMxjvUldVrAqr
        iUglLSk1cMFguaXer+4iQ3w/AWz8fbLxeLkSyXUckZXTUwjyeQIoPK03lM+rMXHYNhayRA
        UGWSx9LoWBuYMq7GcsSozryjULMpl+afjPl811b9m5zvnQW8YkV966LD/D/jHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638475902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=uKEKXvHs/6NxYMJWymT1MfEbyB0ReTK3gJLrVlyxCNw=;
        b=EZ9uDiMeM3RPYt0S/xwJMxWHpBHOK5Lh6bs4rGEWw1rCzb6Kr40R/nnLIN9Y0Vqh2gxcp0
        WpfSoCZNvzEe/ACQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-scsi@vger.kernel.org
Cc:     Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] scsi/be2iscsi: Remove non existing maintainer.
Message-ID: <20211202201141.cytqe73ish6oa356@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The email address of
   Subbu Seetharaman <subbu.seetharaman@broadcom.com>
   Jitendra Bhivare <jitendra.bhivare@broadcom.com>

is no longer working.
Remove Subbu and Jitendra as maintainer.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b1e79f8e3d88..f0f84b7eefafc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7049,9 +7049,7 @@ S:	Maintained
 F:	drivers/mmc/host/cqhci*
 
 EMULEX 10Gbps iSCSI - OneConnect DRIVER
-M:	Subbu Seetharaman <subbu.seetharaman@broadcom.com>
 M:	Ketan Mukadam <ketan.mukadam@broadcom.com>
-M:	Jitendra Bhivare <jitendra.bhivare@broadcom.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 W:	http://www.broadcom.com
-- 
2.34.1

