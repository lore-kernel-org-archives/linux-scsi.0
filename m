From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Date: Sun, 04 May 2008 10:25:31 -0500
Message-ID: <1209914732.16283.27.camel@localhost.localdomain>
References: <481D9C69.8080902@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46560 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbYEDPZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 11:25:39 -0400
In-Reply-To: <481D9C69.8080902@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sun, 2008-05-04 at 07:22 -0400, Jeff Garzik wrote:
> See attached files for additional config detail.
> 
> Platform summary:  AMD64 2x2 (== 4 cores), Fedora 8/x86-64
> 
> Driver 'sr' needs updating - please use bus_type methods
> BUG: unable to handle kernel NULL pointer dereference at 00000000000005d8
> IP: [<ffffffff8025e10c>] get_page_from_freelist+0x43/0x573
> PGD 7e90f067 PUD 7edbc067 PMD 0
> Oops: 0000 [1] SMP

Is this with CONFIG_SLAB or CONFIG_SLUB?

I don't see it in my test systems, but they're CONFIG_SLAB

James


