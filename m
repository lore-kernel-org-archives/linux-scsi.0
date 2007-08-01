From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [RFC][PATCH] Remove stat.h from drivers/scsi/a2091.c
Date: Wed, 01 Aug 2007 17:29:53 +0200
Message-ID: <46B0A6F1.3060308@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:45535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758398AbXHAPaW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 11:30:22 -0400
Received: by nf-out-0910.google.com with SMTP id g13so63701nfb
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 08:30:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Hi,

"There is no reason at all for a scsi driver to include stat.h"
-- Christoph Hellwig

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/drivers/scsi/a2091.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/a2091.c	2007-08-01 17:26:39.000000000 +0200
@@ -18,8 +18,6 @@
 #include "wd33c93.h"
 #include "a2091.h"
 
-#include<linux/stat.h>
-
 #define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
