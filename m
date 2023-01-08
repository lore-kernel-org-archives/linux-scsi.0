Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617E2C54EBE
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Jan 2023 18:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbjAHSs7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Jan 2023 13:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbjAHSsz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2023 13:48:55 -0500
Received: from msg-2.mailo.com (msg-2.mailo.com [213.182.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEC2FCC2;
        Sun,  8 Jan 2023 10:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1673203720; bh=0Jpqh8Vd9R1/JOeJmSJuYMulmrFLVyAE0tgkEvzZVDk=;
        h=X-EA-Auth:Date:From:To:Subject:Message-ID:MIME-Version:
         Content-Type;
        b=D7z6YqZKy7J5jzAO8Z8J3ibOxjHZul9NjqS+eKpzTCygChHvYaaIcJ5OUIBs6Xw5w
         3FELGrwvCm8DjsE6cpL8hzzl0x+mWLbtv1lTD11vniXnUC5VuQbZFeYsOlw2QfhNiP
         FvLPLre3RPcCFe0K9CpzyBfoSevoseNTWajXDUAw=
Received: by b-5.in.mailobj.net [192.168.90.15] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Sun,  8 Jan 2023 19:48:40 +0100 (CET)
X-EA-Auth: ODOImPIEwNov/E+Swoh66grswSJavxIx1kyDzU9EG3NjkJ706oWC3HdS1KrnUicgkEqFT99kkb+Ap71MBligjSXnz0ARp0/q
Date:   Mon, 9 Jan 2023 00:18:36 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: Remove unnecessary semicolon
Message-ID: <Y7sQBF4Y1l7mYKRz@ubun2204.myguest.virtualbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A semicolon at the end of a switch case block is unnecessary. So remove
it. Issue identified using semicolon.cocci Coccinelle semantic patch.

Signed-off-by: Deepak R Varma <drv@mailo.com>
---
 drivers/scsi/ipr.h       | 2 +-
 drivers/scsi/qlogicpti.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 69444d21fca1..54e47ce18338 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1977,7 +1977,7 @@ static inline int ipr_sdt_is_fmt2(u32 sdt_word)
 	case IPR_SDT_FMT2_BAR5_SEL:
 	case IPR_SDT_FMT2_EXP_ROM_SEL:
 		return 1;
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 8c961ff03fcd..72fc8c98a29d 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1150,7 +1150,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 		case COMMAND_ERROR:
 		case COMMAND_PARAM_ERROR:
 			break;
-		};
+		}
 		sbus_writew(0, qpti->qregs + SBUS_SEMAPHORE);
 	}
 
-- 
2.34.1



