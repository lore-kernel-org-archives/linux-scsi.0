From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 23:57:41 -0600
Message-ID: <20060730055741.GA4442@parisc-linux.org>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de> <1154180419.9447.61.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <44CBAB4B.7050308@torque.net> <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org> <44CBC115.2080401@torque.net> <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org> <Pine.LNX.4.64.0607291338530.4168@g5.osdl.org> <1154211186.2903.66.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:12742 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751140AbWG3F5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 01:57:43 -0400
Content-Disposition: inline
In-Reply-To: <1154211186.2903.66.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org, Dave Jones <davej@redhat.com>, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Douglas Gilbert <dougg@torque.net>

On Sun, Jul 30, 2006 at 12:13:06AM +0200, Arjan van de Ven wrote:
> 
> > (As a historical oddity - there _was_ this bug in some drive that would 
> > corrupt the firmware by mistake, though - I think we _did_ actually fry 
> > some drives by sending it a "cache flush" command that it wasn't 
> > expecting, and that it turned into firmware reload thing or something. I 
> > think Alan Cox knows all the gruesome details, but that we could 
> > definitely blame on bad hardware..
> 
> since you asked for it...
> 
> a certain distribution shipped a preproduction version of a packet
> writing patch or it was some barrier thing, I forgot, which would end up
> sending an *ATA* "cache flush" command to ATAPI drives that didn't claim
> to understand that command range. A certain model of cdrom drive (LG?)
> actually had that same command byte code as "flash firmware". 
> 
> Arguably it's a very stupid value to pick, but it's also not technically
> a drive bug; the drive explicitly claimed to not understand the command
> set in question, and that distro kernel sent it anyway. 

Actually, the standard does prohibit these command values from being
reused for different purposes.  http://lwn.net/Articles/55815/
