From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Sun, 30 Jul 2006 12:57:34 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607301245500.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de>
 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <1154194239.9447.89.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291045540.4168@g5.osdl.org> <m3y7ubqdwg.fsf@zoo.weinigel.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19602 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932468AbWG3T5t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 15:57:49 -0400
In-Reply-To: <m3y7ubqdwg.fsf@zoo.weinigel.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christer Weinigel <christer@weinigel.se>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org



On Sun, 30 Jul 2006, Christer Weinigel wrote:
> 
> Joerg is correct about this.  I just went through the cdrecord sources
> (from Fedora Core 5 with a DVD patch) and took a quick look at what
> commands and mode pages were used by the different files.  I've
> probably missed a few things, but this ought to give you and idea
> about what is needed to burn a CD:

Umm. I suspect you are either looking at the really old drives (like over 
a decade ago), when there were indeed lots of CD-burners that had very 
specific commands because the standard was new or nonexistent.

Or you're looking at some extended commands that cdrecord _knows_ about 
and can use, but that aren't necessarily standard or supported on all 
CD-ROM drives.

I really _would_ be pretty surprised if you can't do standard CD-ROM (and 
DVD) burning with the standard MMC commands with just about _any_ drive 
that is more recent than ten years old. 

One reason? I don't think Windows supports those out of the box either.

		Linus
