From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: [PATCH] ips driver for 2.4.23-pre4
Date: Thu, 8 Jan 2004 15:18:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A121ABA5B472B74EB59076B8E3C8F0190129F3@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:19385 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S266374AbUAHUTU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 15:19:20 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Xose Vazquez Perez <xose@wanadoo.es>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>


Adaptec ( Jack Hammer and Dave Jeffery ) maintains the ips driver.  We
submitted this driver.  If there are any questions or concerns, please let
us know ASAP.

The 6.11.07 ips driver passed a very strict ( and formal ) 4 month
IBM/Adaptec test cycle that included stress tests on every platform and
adapter that it supports before the patch was released.

The reason this compiler warning exists is that these are the only hardware
platforms that support this adapter.  Use of this adapter is any other box
can cause serious problems and is not supported by anyone.  Removal of this
warning has no effect on the executable code and would not improve the
driver in my opinion.  If I was including a module in my system that is not
going to work, I'd like to know about it.



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Thursday, January 08, 2004 12:16 PM
To: Xose Vazquez Perez
Cc: linux-scsi; Tosatti
Subject: Re: [PATCH] ips driver for 2.4.23-pre4

On Wed, Jan 07, 2004 at 08:17:00PM +0100, Xose Vazquez Perez wrote:
> -#if !defined(__i386__) && !defined(__ia64__) -#error "This driver has 
> only been tested on the x86/ia64 platforms"
> +#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__) 
> +#error "This driver has only been tested on the x86/ia64/x86_64
platforms"
>  #endif

This warning schould be removed completly.  Lots of PCI drivers have been
tested only on a few plattforms.

Else the patch is okay, but where's the maintainer?

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
