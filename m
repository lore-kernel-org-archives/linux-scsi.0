From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: MAINTAINERS: Add myself as the maintainer for BusLogic SCSI driver
Date: Tue, 25 Jun 2013 09:57:27 -0600
Message-ID: <1372175847-11222-1-git-send-email-khalid.aziz@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:45822
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505Ab3FYP5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:57:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, linux-scsi@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>

MAINTAINERS: Add myself as the maintainer for BusLogic SCSI driver

I ported BusLogic driver to 64-bit. There is no current maintainer for
this driver and since I made significant changes to the driver for
64-bit porting work, I will continue to maintain it.

Signed-off-by: Khalid Aziz <khalid@gonehiking.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5be702c..83cd4e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1858,6 +1858,13 @@ S:	Odd fixes
 F:	Documentation/video4linux/bttv/
 F:	drivers/media/pci/bt8xx/bttv*
 
+BUSLOGIC SCSI DRIVER
+M:	Khalid Aziz <khalid@gonehiking.org>
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	drivers/scsi/BusLogic.*
+F:	drivers/scsi/FlashPoint.*
+
 C-MEDIA CMI8788 DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
1.7.10.4

