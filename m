From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid bad queuecommand return
Date: Fri, 19 Nov 2004 07:58:31 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B69480B@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:63617 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261383AbUKSM6e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 07:58:34 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Cool, I'll buy it!!!

-----Original Message-----
From: Jens Axboe [mailto:axboe@suse.de] 
Sent: Friday, November 19, 2004 7:41 AM
To: Salyzyn, Mark
Cc: linux-scsi@vger.kernel.org; James Bottomley
Subject: Re: [PATCH] aacraid bad queuecommand return

On Fri, Nov 19 2004, Salyzyn, Mark wrote:
> In the patch I supplied, I dropped the result setting and aac_io_done
> and let the midlayer retry on the none-zero return.
> 
> Which is more efficient?

It doesn't really matter - this path should basically never be hit
(or you would have seen a report, it would hang the scsi layer), so
efficiency isn't really an issue. So just do whatever you see fit,
either way will work fine. I like the scsi_done approach best, because
it allows you to flag more fine grained errors.

-- 
Jens Axboe

