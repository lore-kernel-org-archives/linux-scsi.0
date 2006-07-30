From: Christian Iversen <chrivers@iversen-net.dk>
Subject: Re: cd burning with plextor drives.
Date: Sun, 30 Jul 2006 22:18:32 +0200
Message-ID: <200607302218.33230.chrivers@iversen-net.dk>
References: <20060729045249.GA23398@redhat.com> <m3y7ubqdwg.fsf@zoo.weinigel.se> <Pine.LNX.4.64.0607301245500.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.sikkerhed.org ([83.221.155.180]:19353 "EHLO
	zeus.sikkerhed.org") by vger.kernel.org with ESMTP id S1750832AbWG3URu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 16:17:50 -0400
In-Reply-To: <Pine.LNX.4.64.0607301245500.4168@g5.osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Christer Weinigel <christer@weinigel.se>, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

On Sunday 30 July 2006 21:57, Linus Torvalds wrote:
> On Sun, 30 Jul 2006, Christer Weinigel wrote:
> > Joerg is correct about this.  I just went through the cdrecord sources
> > (from Fedora Core 5 with a DVD patch) and took a quick look at what
> > commands and mode pages were used by the different files.  I've
> > probably missed a few things, but this ought to give you and idea
> > about what is needed to burn a CD:
>
> Umm. I suspect you are either looking at the really old drives (like over
> a decade ago), when there were indeed lots of CD-burners that had very
> specific commands because the standard was new or nonexistent.
>
> Or you're looking at some extended commands that cdrecord _knows_ about
> and can use, but that aren't necessarily standard or supported on all
> CD-ROM drives.
>
> I really _would_ be pretty surprised if you can't do standard CD-ROM (and
> DVD) burning with the standard MMC commands with just about _any_ drive
> that is more recent than ten years old.

That was my impression as well - perhaps this could be solved by making the 
MMC-commands valid for any CD-writer device, and making LightScribe, 
BurnProff, etc available only to root? or, by a special vendor->permission 
table like suggested previously? That would change the bug reports to 
simply "my drive can't do BurnProof unless I'm root", instead of "my drive 
can't burn unless I'm root". That's clearly more manageable, right?

-- 
Regards,
Christian Iversen
