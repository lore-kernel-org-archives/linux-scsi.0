From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [RFC][PATCH] Coding style fix drivers/scsi/mvme147.c
Date: Wed, 01 Aug 2007 17:17:15 +0200
Message-ID: <46B0A3FB.2080701@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:34551 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630AbXHAPRo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 11:17:44 -0400
Received: by nf-out-0910.google.com with SMTP id g13so62809nfb
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 08:17:43 -0700 (PDT)
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

--- linux-mm-clean/drivers/scsi/mvme147.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/mvme147.c	2007-08-01 17:14:39.000000000 +0200
@@ -13,7 +13,7 @@
 #include "wd33c93.h"
 #include "mvme147.h"
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
