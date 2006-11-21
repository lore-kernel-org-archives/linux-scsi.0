From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Remove #warning cruft from drivers/scsi/ips.c
Date: Tue, 21 Nov 2006 17:14:10 +1100
Message-ID: <20061121061413.5D10967BF3@ozlabs.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:14002 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S934321AbWKUGOO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 01:14:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, ipslinux@adaptec.com

drivers/scsi/ips.c pollutes my build log telling me that it has only
been tested on x86/ia64/x86_64. It's starting to get annoying.

Replace the #warning with a simple comment.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---

 drivers/scsi/ips.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: msi/drivers/scsi/ips.c
===================================================================
--- msi.orig/drivers/scsi/ips.c
+++ msi/drivers/scsi/ips.c
@@ -8,6 +8,8 @@
 /* Copyright (C) 2000 IBM Corporation                                        */
 /* Copyright (C) 2002,2003 Adaptec, Inc.                                     */
 /*                                                                           */
+/* This driver has only been tested on the x86/ia64/x86_64 platforms.        */
+/*                                                                           */
 /* This program is free software; you can redistribute it and/or modify      */
 /* it under the terms of the GNU General Public License as published by      */
 /* the Free Software Foundation; either version 2 of the License, or         */
@@ -207,10 +209,6 @@ module_param(ips, charp, 0);
 #define IPS_VERSION_HIGH        "7.12"
 #define IPS_VERSION_LOW         ".05 "
 
-#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
-#warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
-#endif
-
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
 #include <linux/blk.h>
 #include "sd.h"
