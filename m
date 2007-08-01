From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [RFC][PATCH] Coding style fix drivers/scsi/aha1542.c
Date: Wed, 01 Aug 2007 17:13:14 +0200
Message-ID: <46B0A30A.8090500@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:31184 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbXHAPNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 11:13:42 -0400
Received: by nf-out-0910.google.com with SMTP id g13so62473nfb
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 08:13:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Hi,

Coding style fix

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/drivers/scsi/aha1542.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/aha1542.c	2007-08-01 17:09:40.000000000 +0200
@@ -77,7 +77,7 @@ static void BAD_SG_DMA(Scsi_Cmnd * SCpnt
 	panic("Buffer at physical address > 16Mb used for aha1542");
 }
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
 #ifdef DEBUG
 #define DEB(x) x
