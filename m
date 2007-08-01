From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC][PATCH] Coding style fix drivers/scsi/mvme147.c
Date: Wed, 01 Aug 2007 17:26:09 +0200
Message-ID: <46B0A611.3070009@googlemail.com>
References: <46B0A3FB.2080701@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:42416 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbXHAP0j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 11:26:39 -0400
Received: by nf-out-0910.google.com with SMTP id g13so63472nfb
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 08:26:38 -0700 (PDT)
In-Reply-To: <46B0A3FB.2080701@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Michal Piotrowski pisze:
> Hi,
> 
> Coding style fix
> 

Christoph Hellwig:
"There is no reason at all for a scsi driver to include stat.h"

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/drivers/scsi/mvme147.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/mvme147.c	2007-08-01 17:24:22.000000000 +0200
@@ -13,8 +13,6 @@
 #include "wd33c93.h"
 #include "mvme147.h"
 
-#include<linux/stat.h>
-
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static struct Scsi_Host *mvme147_host = NULL;


