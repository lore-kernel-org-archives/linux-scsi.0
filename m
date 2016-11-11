From: adam radford <aradford@gmail.com>
Subject: [PATCH] Update 3ware driver email addresses
Date: Thu, 10 Nov 2016 16:23:15 -0800
Message-ID: <CAHtARFH_svO-sP6dpDZADcXrf9Oce1FBR=aFriGWmo3OdkyrcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36403 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964799AbcKKAXS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 19:23:18 -0500
Received: by mail-wm0-f67.google.com with SMTP id m203so4513750wma.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2016 16:23:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This change updates the 3ware drivers (3w-xxxx, 3w-9xxx, 3w-sas) email
addresses from linuxraid@lsi.com to aradford@gmail.com, since the old
email address doesn't exist.

Signed-off-by: Adam Radford <aradford@gmail.com>
---
 MAINTAINERS            | 2 +-
 drivers/scsi/3w-9xxx.c | 6 +++---
 drivers/scsi/3w-9xxx.h | 6 +++---
 drivers/scsi/3w-sas.c  | 4 ++--
 drivers/scsi/3w-sas.h  | 4 ++--
 drivers/scsi/3w-xxxx.c | 4 ++--
 drivers/scsi/3w-xxxx.h | 4 ++--
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3a7774..1b5ddd0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -138,7 +138,7 @@ S:  Maintained
 F:     drivers/net/ethernet/3com/typhoon*

 3WARE SAS/SATA-RAID SCSI DRIVERS (3W-XXXX, 3W-9XXX, 3W-SAS)
-M:     Adam Radford <linuxraid@lsi.com>
+M:     Adam Radford <aradford@gmail.com>
 L:     linux-scsi@vger.kernel.org
 W:     http://www.lsi.com
 S:     Supported
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a56a7b2..6de3cab 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1,8 +1,8 @@
 /*
    3w-9xxx.c -- 3ware 9000 Storage Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@lsi.com>
-   Modifications By: Tom Couch <linuxraid@lsi.com>
+   Written By: Adam Radford <aradford@gmail.com>
+   Modifications By: Tom Couch

    Copyright (C) 2004-2009 Applied Micro Circuits Corporation.
    Copyright (C) 2010 LSI Corporation.
@@ -41,7 +41,7 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@lsi.com
+   aradford@gmail.com

    For more information, goto:
    http://www.lsi.com
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index 0fdc83c..5380ce4 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -1,8 +1,8 @@
 /*
    3w-9xxx.h -- 3ware 9000 Storage Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@lsi.com>
-   Modifications By: Tom Couch <linuxraid@lsi.com>
+   Written By: Adam Radford <aradford@gmail.com>
+   Modifications By: Tom Couch

    Copyright (C) 2004-2009 Applied Micro Circuits Corporation.
    Copyright (C) 2010 LSI Corporation.
@@ -41,7 +41,7 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@lsi.com
+   aradford@gmail.com

    For more information, goto:
    http://www.lsi.com
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index f837485..6840217 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1,7 +1,7 @@
 /*
    3w-sas.c -- LSI 3ware SAS/SATA-RAID Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@lsi.com>
+   Written By: Adam Radford <aradford@gmail.com>

    Copyright (C) 2009 LSI Corporation.

@@ -43,7 +43,7 @@
    LSI 3ware 9750 6Gb/s SAS/SATA-RAID

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@lsi.com
+   aradford@gmail.com

    For more information, goto:
    http://www.lsi.com
diff --git a/drivers/scsi/3w-sas.h b/drivers/scsi/3w-sas.h
index fec6449..e7b7aec 100644
--- a/drivers/scsi/3w-sas.h
+++ b/drivers/scsi/3w-sas.h
@@ -1,7 +1,7 @@
 /*
    3w-sas.h -- LSI 3ware SAS/SATA-RAID Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@lsi.com>
+   Written By: Adam Radford <aradford@gmail.com>

    Copyright (C) 2009 LSI Corporation.

@@ -39,7 +39,7 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@lsi.com
+   aradford@gmail.com

    For more information, goto:
    http://www.lsi.com
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 25aba16..374648d 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1,7 +1,7 @@
 /*
    3w-xxxx.c -- 3ware Storage Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@lsi.com>
+   Written By: Adam Radford <aradford@gmail.com>
    Modifications By: Joel Jacobson <linux@3ware.com>
                     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
@@ -47,7 +47,7 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@lsi.com
+   aradford@gmail.com

    For more information, goto:
    http://www.lsi.com
diff --git a/drivers/scsi/3w-xxxx.h b/drivers/scsi/3w-xxxx.h
index 6f65e66..5a5a5d2 100644
--- a/drivers/scsi/3w-xxxx.h
+++ b/drivers/scsi/3w-xxxx.h
@@ -1,7 +1,7 @@
 /*
    3w-xxxx.h -- 3ware Storage Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@lsi.com>
+   Written By: Adam Radford <aradford@gmail.com>
    Modifications By: Joel Jacobson <linux@3ware.com>
                     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
@@ -45,7 +45,7 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@lsi.com
+   aradford@gmail.com

    For more information, goto:
    http://www.lsi.com
--
1.8.3.1
