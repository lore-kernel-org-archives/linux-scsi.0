From: Justin Cormack <justin@street-vision.com>
Subject: Re: Serial ATA (SATA) for Linux status report
Date: 04 Dec 2003 13:38:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1070545088.11956.43.camel@lotte.street-vision.com>
References: <20031203204445.GA26987@gtf.org>
	<1070494030.15415.111.camel@slurv.pasop.tomt.net>
	<3FCE737C.1080105@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3FCE737C.1080105@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andre Tomt <lkml@tomt.net>, Kernel mailing list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2003-12-03 at 23:36, Jeff Garzik wrote:
> Andre Tomt wrote:
> > On Wed, 2003-12-03 at 21:44, Jeff Garzik wrote:
> > 
> >>Intel ICH5
> >>----------
> >>Summary:  No TCQ.  Looks like a PATA controller, but with a few added,
> >>non-standard SATA port controls.
> 
> > One question - with "including hotplug", does that mean some set hotplug
> > standard? Reason I'm asking is, we have a few servers from SuperMicro,
> > with a ICH5R S-ATA controller that claims it's supporting hotplug, but
> > hotplug is not in your ICH5-summary.
> 
> Alas, there is no hotplug support in the ICH5 or ICH5-R SATA hardware.
> 
> One could argue there is "coldplug" support in that hardware -- disable 
> the entire interface, including any active devices, then re-enable and 
> re-scan -- but it's a bit of a hack.  If there's enough demand, I could 
> write some code for that.  It would involve something like
> 
> 	# /sbin/sata off
> 	{ plug in or remove a device }
> 	# /sbin/sata on
> 
> You really, really, really don't want to actually unplug a SATA drive 
> while it's active, on ICH5 hardware.

How does it work on other hardware?

Justin
