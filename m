From: James Smart <james.smart@emulex.com>
Subject: [PATCH] lpfc: Revise maintainers for Avago Technologies ownership
 of Emulex
Date: Fri, 15 May 2015 13:10:58 -0400
Message-ID: <1431709858.27283.1.camel@myfc17>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55650 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932810AbbEORLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 May 2015 13:11:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Revise maintainers for Avago Technologies ownership of Emulex

The old email addresses will go away very soon. Revising with new addresses.

Copyrights will be updated in a later patch.

-- james s


Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>

---
 MAINTAINERS | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cb62576..8428bf4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3771,10 +3771,11 @@ M:	David Woodhouse <dwmw2@infradead.org>
 L:	linux-embedded@vger.kernel.org
 S:	Maintained
 
-EMULEX LPFC FC SCSI DRIVER
-M:	James Smart <james.smart@emulex.com>
+EMULEX/AVAGO LPFC FC/FCOE SCSI DRIVER
+M:	James Smart <james.smart@avagotech.com>
+M:	Dick Kennedy <dick.kennedy@avagotech.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://sourceforge.net/projects/lpfcxxxx
+W:	http://www.avagotech.com
 S:	Supported
 F:	drivers/scsi/lpfc/
 
-- 
1.7.11.7



