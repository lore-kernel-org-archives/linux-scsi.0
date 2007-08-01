From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC][PATCH] Coding style fix drivers/scsi/aha1542.c
Date: Wed, 01 Aug 2007 17:22:31 +0200
Message-ID: <46B0A537.9070907__81.1814600185201$1185981821$gmane$org@googlemail.com>
References: <46B0A30A.8090500@googlemail.com> <20070801151812.GA17601@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:39360 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbXHAPXA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 11:23:00 -0400
Received: by nf-out-0910.google.com with SMTP id g13so63192nfb
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 08:22:59 -0700 (PDT)
In-Reply-To: <20070801151812.GA17601@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@v>

Christoph Hellwig pisze:
> On Wed, Aug 01, 2007 at 05:13:14PM +0200, Michal Piotrowski wrote:
>> Hi,
>>
>> Coding style fix
>>
>> Regards,
>> Michal
>>
> 
> I think that include should just go.  There is no reason at all for
> a scsi driver to include stat.h
> 
> 

As you wish

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/drivers/scsi/aha1542.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/aha1542.c	2007-08-01 17:18:57.000000000 +0200
@@ -77,8 +77,6 @@ static void BAD_SG_DMA(Scsi_Cmnd * SCpnt
 	panic("Buffer at physical address > 16Mb used for aha1542");
 }
 
-#include<linux/stat.h>
-
 #ifdef DEBUG
 #define DEB(x) x
 #else

