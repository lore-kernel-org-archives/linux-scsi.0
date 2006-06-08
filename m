From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] fix up request buffer reference in various scsi drivers
Date: Thu, 08 Jun 2006 09:26:42 -0400
Message-ID: <44882592.5090701@garzik.org>
References: <20060603112113.GA17018@lst.de>  <44880BEA.90707@garzik.org> <1149771978.3436.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:11715 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751329AbWFHN0p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 09:26:45 -0400
In-Reply-To: <1149771978.3436.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@SteelEye.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2006-06-08 at 07:37 -0400, Jeff Garzik wrote:
>> False statement, for libata.
> 
> Could you amplify this statement, please ... I looked through the head
> of libata-dev and it seems that these are still the only two bufflen
> uses, which still do look obviously wrong ... I don't see where the
> problem in libata with this is?

Christoph's false statement is:  "Using the buffer and bufflen fields 
means they do very broken things in error handling."

libata does not do "very broken things in error handling."


>> Please CC the author (me) or linux-ide, at least, when you touch
>> libata.
> 
> The tradition is that for infrastructure changes like this, particularly
> ones that are trivial, as this appears to be, you simply copy the scsi
> list and don't have to sweep up the individual maintainers of each
> driver.

This is apparently an EH-related patch, and libata uses SCSI EH very 
differently from all other drivers.  In this case, Christoph's "very 
broken" justification is clearly inaccurate, and thus a CC is obviously 
warranted.

Also, I remind people constantly of this, so I'm sure you and Christoph 
have heard the request before.

	Jeff, the one who forwards to linux-scsi when others forget


