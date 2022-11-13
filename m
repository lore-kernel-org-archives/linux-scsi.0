Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC73C43217
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Nov 2022 20:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiKMUeC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Nov 2022 15:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235501AbiKMUeB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Nov 2022 15:34:01 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23728B87D;
        Sun, 13 Nov 2022 12:34:01 -0800 (PST)
Message-ID: <20221113202428.436270297@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668371639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=tmVSBh7LFHbVMNi5aGgkDXujNrRbhBcwZrCnE4E7gNk=;
        b=c7S1P1kQqv0b+trJ4f/slqRvr0A4XjmP94hI86PGo5XgMHCwdQsdeZBEFVHhX8HAr9QFrs
        9efbNs/OYOS8ry2Q4yp1ZNDfXbcIHOK1sOrkzm5gttdK1Vwhj4cwsTV6v1pVc/sk4jjex1
        E4WIU12KtuomTbW+dc4AVI0t2hqAuO6oq4E1jrsTkyb7YPsO5234m/tbE0vLJRHKhX98rO
        TQ6TJ0eaJp/Koi6qKcGD7BSy6G+EwiJOsalTrBboTJ1lVIbXNrspaD19D/01LDY9Ch2vXz
        1HYOSWsra8wZ1EvPEKdJdqw09G5w/qYZSDqAff0EFTWIo++KjZRZ51MmL7fFUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668371639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=tmVSBh7LFHbVMNi5aGgkDXujNrRbhBcwZrCnE4E7gNk=;
        b=9pLaOTPUafFx06YIQ7l3qqbXFCa6DWnI74Jp6GGMZDsl/JWcZ6MtfTg9d/xVZZ2RsWUtcT
        spU/IbG0Hm5tJ5Dg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [patch 03/10] scsi: lpfc: Remove linux/msi.h include
References: <20221113201935.776707081@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 13 Nov 2022 21:33:59 +0100 (CET)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nothing in this file needs anything from linux/msi.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_init.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -36,7 +36,6 @@
 #include <linux/firmware.h>
 #include <linux/miscdevice.h>
 #include <linux/percpu.h>
-#include <linux/msi.h>
 #include <linux/irq.h>
 #include <linux/bitops.h>
 #include <linux/crash_dump.h>

