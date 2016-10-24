From: james.smart@broadcom.com (James Smart)
Subject: [PATCH] lpfc: Revise MAINTAINERS to reflect Broadcom
Date: Mon, 24 Oct 2016 09:05:06 -0700
Message-ID: <580e3132.F/Of3Vs1k6lgixPf%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([202.86.248.61]:38625 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933767AbcJXQFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 12:05:13 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 06B6F10016C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 09:05:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Avago is now known as Broadcom.
Revise the emails and website for lpfc accordingly

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 MAINTAINERS | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 072fe36..96e0ec6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4681,11 +4681,11 @@ M:	David Woodhouse <dwmw2@infradead.org>
 L:	linux-embedded@vger.kernel.org
 S:	Maintained
 
-EMULEX/AVAGO LPFC FC/FCOE SCSI DRIVER
-M:	James Smart <james.smart@avagotech.com>
-M:	Dick Kennedy <dick.kennedy@avagotech.com>
+EMULEX/BROADCOM LPFC FC/FCOE SCSI DRIVER
+M:	James Smart <james.smart@broadcom.com>
+M:	Dick Kennedy <dick.kennedy@broadcom.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://www.avagotech.com
+W:	http://www.broadcom.com
 S:	Supported
 F:	drivers/scsi/lpfc/
 
-- 
2.5.0


