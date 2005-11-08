From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Tue, 08 Nov 2005 09:10:14 -0500
Message-ID: <1131459014.3270.1.camel@mulgrave>
References: <20051108024523.35622.qmail@web88006.mail.re2.yahoo.com>
	 <20051108033118.GL3413@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38031 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964950AbVKHOKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Nov 2005 09:10:22 -0500
In-Reply-To: <20051108033118.GL3413@verge.net.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Horms <horms@debian.org>
Cc: Graham Knap <graham.knap@rogers.com>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

On Tue, 2005-11-08 at 12:31 +0900, Horms wrote:
> On Mon, Nov 07, 2005 at 09:45:23PM -0500, Graham Knap wrote:
> > Package: linux-image-2.6.14-1-686
> > Version: 2.6.14-2
> > 
> > Recent versions of the aic7xxx driver will not boot on my secondary PC.
> > The 2.6.8 kernel shipped with sarge works perfectly, but neither the
> > 2.6.12 kernel in testing nor the 2.6.14 kernel in unstable will boot.
> > 
> > This is an older system: 
> > Asus P2L-B, Celeron 500MHz, 384MB RAM, GeForce2 MX AGP
> > Adaptec 2940UW, IBM DDYS-T09170 (9GB disk)
> > 
> > I can't understand what exactly is failing, but I will attach a boot
> > log. (So null modem cables *are* still useful for something!)
> > 
> > I've tried adding "aic7xxx=dv:{0}" to the boot arguments but that
> > doesn't seem to make a difference. Also, "aic7xxx=verbose" doesn't seem
> > to do anything either.
> > 
> > I don't know if this makes a difference but my 2940UW reports its BIOS
> > revision as "1.34.3" during POST.
> > 
> > Any help would be much appreciated.
> 
> Hi Graham, 
> 
> thanks for your detailed report. This does smell a lot like a driver
> bug, and as such, its proably best passed onto the upstream maintainers.
> As such I've CCed James Bottomley and linux-scsi for comment.
> 
> The other main possiblility, is that perhaps the aic7xxx_old driver would
> work. Or perhaps some other module loading foo, though its seems the
> module is loaded fine, it just doesn't like your card very much.

This is an older drive, so it looks like it passes domain validation
(read only) but then chokes on the next command.  On 2.6.8, what do the
transport settings report? (that's cat /proc/scsi/aic7xxx/0)?

Thanks,

James


