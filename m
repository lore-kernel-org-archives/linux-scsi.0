From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 15 Apr 2008 11:16:40 -0700
Message-ID: <4804F108.6020505@zytor.com>
References: <47E875AD.1000901@rtr.ca> <47E88A13.70808@zytor.com>	 <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com>	 <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de>	 <47E99A02.7040903@rtr.ca> <47E99EBE.7010708@gmail.com>	 <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>	 <47EBF7D0.6000901@zytor.com>	 <e9c3a7c20804111625w68b21b24p6fbd85864713d62f@mail.gmail.com>	 <20080415001828.b0c9ed64.akpm@linux-foundation.org> <1208269202.3131.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:50099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYDOSV3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2008 14:21:29 -0400
In-Reply-To: <1208269202.3131.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <htejun@gmail.com>, Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> 
> The expressed preference was simply to expand the ioctl (or add a new
> one that got the required information without having to go through the
> old HDIOGETGEO path to extract the value from a fictitious geometry).
> 
> Greg was a bit sceptical of the value of the above proposal ...
> 

However, you have to admit that kind of defeats the whole point of 
having this information in sysfs.  IMNSHO, even scanning sysfs is better 
than keep adding binary ioctls.

	-hpa

