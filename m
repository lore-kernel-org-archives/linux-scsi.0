From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 2/2] MAINTAINERS: mark Advansys Orphan
Date: Thu, 20 Feb 2014 10:14:03 +0100
Message-ID: <1392887643.5070.44.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Hans de Goede <hdegoede@redhat.com>, Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox hasn't touched the Advansys driver since v2.6.29. I have
not been able to get Matthew to respond to a trivial patch I'd like to
see go in. Mark this driver Orphan and add this driver to Matthew's
CREDITS entry.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 CREDITS     | 2 +-
 MAINTAINERS | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index e371c55..4adbf38 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3805,7 +3805,7 @@ N: Matthew Wilcox
 E: matthew@wil.cx
 W: ftp://ftp.uk.linux.org/pub/linux/people/willy/
 D: Linux/PARISC hacker.  Filesystem hacker.  Random other hacking.  Custom
-D: PPC port hacking.
+D: PPC port hacking.  Advansys SCSI driver.
 
 N: G\"unter Windau
 E: gunter@mbfys.kun.nl
diff --git a/MAINTAINERS b/MAINTAINERS
index fb08dce..c45d72e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -426,9 +426,8 @@ S:	Supported
 F:	drivers/input/misc/adxl34x.c
 
 ADVANSYS SCSI DRIVER
-M:	Matthew Wilcox <matthew@wil.cx>
 L:	linux-scsi@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	Documentation/scsi/advansys.txt
 F:	drivers/scsi/advansys.c
 
-- 
1.8.5.3
