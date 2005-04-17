From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Sun, 17 Apr 2005 10:18:21 -0500
Message-ID: <1113751101.5011.5.camel@mulgrave>
References: <20050413191824.GK9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62680 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261324AbVDQPSf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Apr 2005 11:18:35 -0400
In-Reply-To: <20050413191824.GK9703@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-04-13 at 12:18 -0700, Andrew Vasquez wrote:
>  drivers/scsi/qla2xxx/qla_attr.c |  323 ++++++++++++++++++++++++++++++++++++++++

This file uses vmalloc but doesn't appear to include linux/vmalloc.h
causing a compiler warning in my build env.  It also includes
linux/version.h, which it doesn't appear to need.

I'll stick this patch in to correct the problem.

James

===== drivers/scsi/qla2xxx/qla_attr.c 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/qla_attr.c	2005-04-13 10:45:53 -05:00
+++ edited/drivers/scsi/qla2xxx/qla_attr.c	2005-04-17 09:41:13 -05:00
@@ -18,7 +18,7 @@
  */
 #include "qla_def.h"
 
-#include <linux/version.h>
+#include <linux/vmalloc.h>
 #include <scsi/scsi_transport_fc.h>
 
 /* SYSFS attributes --------------------------------------------------------- */


