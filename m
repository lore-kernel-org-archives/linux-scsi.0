From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/24] scsi: add SPDX tags to scsi midlayer files missing licensing information
Date: Wed,  1 May 2019 12:13:54 -0400
Message-ID: <20190501161417.32592-2-hch@lst.de>
References: <20190501161417.32592-1-hch@lst.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDUNBGN3R4KRBEEMU7TAKGQECAYGELI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20190501161417.32592-1-hch-jcswGhMUV9g@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: "James E . J . Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Willem Riede <osst-BKTAy3DeTVvYtjvyW6yDsg@public.gmane.org>, Doug Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, osst-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Add the default kernel GPLv2 annotation to SCSI midlayer files missing
any licensing information.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/scsi/hosts.c        | 1 +
 drivers/scsi/scsi.c         | 1 +
 drivers/scsi/scsi_debugfs.h | 1 +
 drivers/scsi/scsi_error.c   | 1 +
 drivers/scsi/scsi_ioctl.c   | 1 +
 drivers/scsi/scsi_lib.c     | 1 +
 drivers/scsi/scsi_pm.c      | 1 +
 drivers/scsi/scsi_sysfs.c   | 1 +
 8 files changed, 8 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index eaf329db3973..96ed24841c33 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  hosts.c Copyright (C) 1992 Drew Eckhardt
  *          Copyright (C) 1993, 1994, 1995 Eric Youngdale
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 99a7b9f520ae..49821f138ae0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  scsi.c Copyright (C) 1992 Drew Eckhardt
  *         Copyright (C) 1993, 1994, 1995, 1999 Eric Youngdale
diff --git a/drivers/scsi/scsi_debugfs.h b/drivers/scsi/scsi_debugfs.h
index 951b043e82d0..d125d1bd4184 100644
--- a/drivers/scsi/scsi_debugfs.h
+++ b/drivers/scsi/scsi_debugfs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 struct request;
 struct seq_file;
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 8e9680572b9f..f490994374f6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *  scsi_error.c Copyright (C) 1997 Eric Youngdale
  *
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 840d96fe81bc..00397205466b 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Changes:
  * Arnaldo Carvalho de Melo <acme-KCZ47A4bww4P48s/oLjRZg@public.gmane.org> 08/23/2000
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b2570a5642d..94de50745616 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 1999 Eric Youngdale
  * Copyright (C) 2014 Christoph Hellwig
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 7639df91b110..3a5dfbb81622 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *	scsi_pm.c	Copyright (C) 2010 Alan Stern
  *
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 3b119ca0cc0c..ff0aea7ac87f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * scsi_sysfs.c
  *
-- 
2.20.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
