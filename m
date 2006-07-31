From: Jens Axboe <axboe@suse.de>
Subject: Re: cd burning with plextor drives.
Date: Mon, 31 Jul 2006 22:41:09 +0200
Message-ID: <20060731204109.GB31908@suse.de>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de> <1154180419.9447.61.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <1154194239.9447.89.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291045540.4168@g5.osdl.org> <m3y7ubqdwg.fsf@zoo.weinigel.se> <Pine.LNX.4.64.0607301245500.4168@g5.osdl.org> <m3u04yr5s5.fsf@zoo.weinigel.se> <Pine.LNX.4.64.0607311328541.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:58439 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1030272AbWGaUky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 16:40:54 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607311328541.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Christer Weinigel <christer@weinigel.se>, James Bottomley <James.Bottomley@SteelEye.com>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

On Mon, Jul 31 2006, Linus Torvalds wrote:
> 
> 
> On Sun, 31 Jul 2006, Christer Weinigel wrote:
> > 
> > Yes, a lot of those CD burners are ancient.  But I like the fact that
> > Linux supports a lot of ancient hardware. :-)
> 
> Sure. But I don't think we should necessarily design any new code for it. 
> It's not like this has _ever_ worked differently from what it does now, so 
> if you have one of the pre-MMC drives, the right answer right now (and 
> always has been, I think) is that you need to be root to burn them.
> 
> I seriously doubt anybody _really_ cares.

Probably not for the ancient ones, except the odd person still using
them :-)

There are, however, new uses of vendor specific commands that you need
access to for fully utilizing your drive. As mentioned, Plextor is one
of these. And they do make current and very good burners, yet we cannot
add their opcodes to the table because they (sanely) used the vendor
specific range for that.

> That said, I don't think Peter Jones' patch is wrong.  I don't have any 
> strong feelings about it - if people actually want this adn feels it 
> improves the situation, why not? Although to actually make _sense_, we'd 
> want to have distros that actually want to use the interface to 
> auto-populate the command things or something.. In the absense of interest 
> from distros, I don't think it is worth it.

The default table will be the same as know, distros can leave it alone
for now. It at least enables the user to add the vendor opcodes if need
be.

I'll test and mangle the patch for 2.6.19.

-- 
Jens Axboe

