From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: [PATCH] gdth driver for 2.4.23-pre4
Date: Thu, 08 Jan 2004 19:25:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFDA08B.6030901@wanadoo.es>
References: <3FFC5644.9060200@wanadoo.es> <20040108171314.A12595@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp12.eresmas.com ([62.81.235.112]:4491 "EHLO
	smtp12.eresmas.com") by vger.kernel.org with ESMTP id S265784AbUAHS0Z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 13:26:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

Christoph Hellwig wrote:

> On Wed, Jan 07, 2004 at 07:56:04PM +0100, Xose Vazquez Perez wrote:
> 
>>hi,
>>
>>latest driver update for 2.4 kernel:
>>
>>- Disabled scan for EISA controllers
>>- Using CACHE_READ_OEM_STRING_RECORD_IOCTL to set vendor
>>  for SCSI inquiry.
>>- Added support for XSCALE based RAID controllers
>>- Reformated some code chunks
> 
> 
> Patch looks ok, but I'd prefer a submission by the maintainer.

*me too*

But if the maintainer only hangs the patch in the vendor web
and _nobody_ take care for it. what can we do?

againg, ask to them:
Achim Leubner <Achim_Leubner@adaptec.com> or Johannes Dinner <Johannes_Dinner@adaptec.com>

