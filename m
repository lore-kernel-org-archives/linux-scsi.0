From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patchset 0/24] Lots of the Accessors patches and !use_sg	cleanup
Date: Mon, 17 Sep 2007 17:05:08 -0400
Message-ID: <46EEEC04.1080609@garzik.org>
References: <46E6F92D.2090409@panasas.com>	 <200709171246.15142.bzolnier@gmail.com>	 <1190037090.3386.3.camel@localhost.localdomain>	 <200709172205.36070.bzolnier@gmail.com>  <46EEEA40.40908@garzik.org> <1190062829.3386.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47208 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759969AbXIQVGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 17:06:32 -0400
In-Reply-To: <1190062829.3386.49.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>, osst@riede.org

James Bottomley wrote:
> On Mon, 2007-09-17 at 16:57 -0400, Jeff Garzik wrote:
>> Bartlomiej Zolnierkiewicz wrote:
>>> On Monday 17 September 2007, James Bottomley wrote:
>>>> Realistically (and I hate myself for saying this) libata-pata does
>>>> provide a much better alternative for the ATAPI devices.  Is it just
>>>> time to recognise the inevitable and kill ide-scsi?
>>> Agreed, libata-pata is a much better version of ide-scsi. ;-)
>>>
>>> If there is general consensus about ide-scsi removal I think that we
>>> should start with disabling ide-scsi Kconfig entry in 2.6.24 to later
>>> remove the ide-scsi driver completely in 2.6.25.
>>
>> Perhaps it is strange to hear me say this, but...
>>
>> My experience with the IDE driver in the field is that ide-scsi sees a 
>> fair amount of use, as an intentional replacement for ide-cd and the 
>> other hand-written ide-$class ATAPI drivers.
>>
>> I would prefer that ide-scsi stays around as long as ide stays around.
> 
> Of course ... as long as we get to address you as Mr Maintainer ...

I don't claim maintainer, I only claim there are quite a few _users_.

Which is IMO the far more relevant point.

	Jeff



