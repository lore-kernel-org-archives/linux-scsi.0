From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: [PATCH] gdth driver for 2.4.23-pre4
Date: Thu, 8 Jan 2004 15:39:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A121ABA5B472B74EB59076B8E3C8F0190129F5@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:41418 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S266310AbUAHUkm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 15:40:42 -0500
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'Tosatti' <marcelo.tosatti@cyclades.com>


Not at all true ( or easy ) in the real world.  Driver owners are actually
in the business of selling adapters ( or devices ), not software drivers.

When a new device or adapter is announced, a driver for it must be made
available immediately to the customer ( OEM and/or channel ) or the device
is useless.  There is no luxury of waiting of couple months for a new driver
to be accepted into a kernel, and then later make it's way into a
distribution before you can start selling your product.

You must also understand that new driver code sometimes cannot be
distributed to a mailing list prior to a new product's announcment or else
we would be violating confidential "unannounced product" information of the
company.  It's a viscious cycle, and not an ideal situation, but one we
vendors must live with.

I agree we need to drive everything into the kernel as soon as possible, but
that will never be the only work that must be done by vendors.

 


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Xose Vazquez Perez
Sent: Thursday, January 08, 2004 3:06 PM
To: Salyzyn, Mark
Cc: 'Christoph Hellwig'; 'linux-scsi'; 'Tosatti'
Subject: Re: [PATCH] gdth driver for 2.4.23-pre4

Salyzyn, Mark wrote:

> Time and priority is the enemy ... not the maintainers, gatekeepers, 
> volunteeers or the vendors.

So much to do; so little time

> There are currently three effective code bases a vendor driver 
> maintainer is to submit to Distribution, 2.4.* and 2.6.*. OEMs and 
> Channel, the vendor's customers, only concern themselves about
Distributions.

Forget distributions kernel, OEM, Channels ..... If your drivers are in the
official tree you work is done. Easy.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
