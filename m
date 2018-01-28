From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] scsi: aic7xxx: remove really aiclib.c
Date: Sun, 28 Jan 2018 07:23:54 +0000
Message-ID: <1517124234-23425-1-git-send-email-clabbe@baylibre.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34947 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbeA1H15 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jan 2018 02:27:57 -0500
Received: by mail-wm0-f65.google.com with SMTP id r78so28057191wme.0
        for <linux-scsi@vger.kernel.org>; Sat, 27 Jan 2018 23:27:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>

aiclib.c is unused (and contain no code) since commit 1ff927306e08 ("[SCSI] aic7xxx: remove aiclib.c")
13 years later, finish the cleaning by remove it from tree.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/scsi/aic7xxx/aiclib.c | 34 ----------------------------------
 1 file changed, 34 deletions(-)
 delete mode 100644 drivers/scsi/aic7xxx/aiclib.c

diff --git a/drivers/scsi/aic7xxx/aiclib.c b/drivers/scsi/aic7xxx/aiclib.c
deleted file mode 100644
index 828ae3d9a510..000000000000
--- a/drivers/scsi/aic7xxx/aiclib.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Implementation of Utility functions for all SCSI device types.
- *
- * Copyright (c) 1997, 1998, 1999 Justin T. Gibbs.
- * Copyright (c) 1997, 1998 Kenneth D. Merry.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification, immediately at the beginning of the file.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
- *
- * $FreeBSD: src/sys/cam/scsi/scsi_all.c,v 1.38 2002/09/23 04:56:35 mjacob Exp $
- * $Id$
- */
-
-#include "aiclib.h"
-
-- 
2.13.6
