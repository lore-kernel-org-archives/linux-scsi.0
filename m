From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] SCSI:  Standardize include of linux header file to use
 "<>".
Date: Wed, 28 Nov 2007 05:12:04 -0500 (EST)
Message-ID: <alpine.LFD.0.9999.0711280510250.4464@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (root@vger.kernel.org) by vger.kernel.org id S1751531AbXK1Mgs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Nov 2007 07:36:48 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:42661 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbXK1KOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2007 05:14:03 -0500
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1IxJve-0004B1-9i
	for linux-scsi@vger.kernel.org; Wed, 28 Nov 2007 05:14:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  outside of UML code, there are few instances throughout the tree
that don't use the recommended format of "<>" for linux header files.

diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 6bd8e30..ddf5f10 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -29,7 +29,7 @@
  *
  */

-#include "linux/pci.h"
+#include <linux/pci.h>
 #include "aic94xx.h"
 #include "aic94xx_reg.h"
 #include "aic94xx_reg_def.h"

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
