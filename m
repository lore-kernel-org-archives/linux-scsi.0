From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [3/3] add MODULE_VERSION to drivers/scsi
Date: Wed, 21 Jul 2004 17:02:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040721220258.GD16608@lists.us.dell.com>
References: <20040721220111.GA16608@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:50265 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S266743AbUGUWEP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2004 18:04:15 -0400
Content-Disposition: inline
In-Reply-To: <20040721220111.GA16608@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jgarzik@pobox.com

You can import this changeset into BK by piping this whole message to
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.1842.1.3, 2004-07-19 18:06:39-04:00, Matt_Domsch@dell.com
  Set MODULE_VERSION
  
  Move SYM_VERSION and SYM_DRIVER_NAME to new sym_version.h file


 sym_glue.c    |    2 ++
 sym_hipd.c    |    5 +----
 sym_version.h |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions, 4 deletions


diff -Nru a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-07-21 16:57:58 -05:00
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-07-21 16:57:58 -05:00
@@ -64,6 +64,7 @@
 
 #include "sym_glue.h"
 #include "sym_nvram.h"
+#include "sym_version.h"
 
 #define NAME53C		"sym53c"
 #define NAME53C8XX	"sym53c8xx"
@@ -2283,6 +2284,7 @@
 }
 
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(SYM_VERSION);
 
 /*
  * Driver host template.
diff -Nru a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-07-21 16:57:58 -05:00
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-07-21 16:57:58 -05:00
@@ -49,12 +49,9 @@
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE.
  */
-
-#define SYM_VERSION "2.1.18j"
-#define SYM_DRIVER_NAME	"sym-" SYM_VERSION
-
 #include "sym_glue.h"
 #include "sym_nvram.h"
+#include "sym_version.h"
 
 #if 0
 #define SYM_DEBUG_GENERIC_SUPPORT
diff -Nru a/drivers/scsi/sym53c8xx_2/sym_version.h b/drivers/scsi/sym53c8xx_2/sym_version.h
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/sym53c8xx_2/sym_version.h	2004-07-21 16:57:58 -05:00
@@ -0,0 +1,53 @@
+/*
+ * Device driver for the SYMBIOS/LSILOGIC 53C8XX and 53C1010 family 
+ * of PCI-SCSI IO processors.
+ *
+ * Copyright (C) 1999-2001  Gerard Roudier <groudier@free.fr>
+ *
+ * This driver is derived from the Linux sym53c8xx driver.
+ * Copyright (C) 1998-2000  Gerard Roudier
+ *
+ * The sym53c8xx driver is derived from the ncr53c8xx driver that had been 
+ * a port of the FreeBSD ncr driver to Linux-1.2.13.
+ *
+ * The original ncr driver has been written for 386bsd and FreeBSD by
+ *         Wolfgang Stanglmeier        <wolf@cologne.de>
+ *         Stefan Esser                <se@mi.Uni-Koeln.de>
+ * Copyright (C) 1994  Wolfgang Stanglmeier
+ *
+ * Other major contributions:
+ *
+ * NVRAM detection and reading.
+ * Copyright (C) 1997 Richard Waltham <dormouse@farsrobt.demon.co.uk>
+ *
+ *-----------------------------------------------------------------------------
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * Where this Software is combined with software released under the terms of 
+ * the GNU Public License ("GPL") and the terms of the GPL would require the 
+ * combined work to also be released under the terms of the GPL, the terms
+ * and conditions of this License will apply in addition to those of the
+ * GPL with the exception of any terms or conditions of this License that
+ * conflict with, or are expressly prohibited by, the GPL.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
+ * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+#define SYM_VERSION "2.1.18j"
+#define SYM_DRIVER_NAME	"sym-" SYM_VERSION

===================================================================


This BitKeeper patch contains the following changesets:
1.1842.1.3
## Wrapped with gzip_uu ##


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
D#1E4P6HTGRNQ[15Q,&/!EWPY/U0T29NTFI+P?UKA.D:L%@  
 
