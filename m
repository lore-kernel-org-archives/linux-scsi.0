From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATAPI via libata promise 20275
Date: Thu, 21 Oct 2004 13:10:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4177ED8F.7060809@pobox.com>
References: <200410211704.i9LH4jMR008268@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42141 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270701AbUJURK5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 13:10:57 -0400
In-Reply-To: <200410211704.i9LH4jMR008268@falcon30.maxeymade.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Albert CC Lee <albertcc@tw.ibm.com>

Doug Maxey wrote:
> Continuing down a somewhat related path,  what is the outlook for PATAPI
> via libata?
> 
> There is a high level of interest to have hotplug controllers for ppc64, and 
> the primary (exclusive at this point) application is to drive PATAPI optical.
> 
> I know you have indicated that you have some WIP to get there.  I would like 
> to offer any help to reach that goal.
> 
> Would you point me to any code available?

You should be following linux-ide, and pay attention to any posting like
http://marc.theaimsgroup.com/?t=109782787200002&r=1&w=2&n=4

The latest ATAPI code is currently in the latest -BK snapshot of 
upstream, but new development occurs in "libata-dev" queue as described 
in the above email link.

	Jeff


