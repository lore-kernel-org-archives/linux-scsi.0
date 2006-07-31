From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Mon, 31 Jul 2006 13:32:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607311328541.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de>
 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <1154194239.9447.89.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291045540.4168@g5.osdl.org> <m3y7ubqdwg.fsf@zoo.weinigel.se>
 <Pine.LNX.4.64.0607301245500.4168@g5.osdl.org> <m3u04yr5s5.fsf@zoo.weinigel.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:38371 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030206AbWGaUdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 16:33:42 -0400
In-Reply-To: <m3u04yr5s5.fsf@zoo.weinigel.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christer Weinigel <christer@weinigel.se>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org



On Sun, 31 Jul 2006, Christer Weinigel wrote:
> 
> Yes, a lot of those CD burners are ancient.  But I like the fact that
> Linux supports a lot of ancient hardware. :-)

Sure. But I don't think we should necessarily design any new code for it. 
It's not like this has _ever_ worked differently from what it does now, so 
if you have one of the pre-MMC drives, the right answer right now (and 
always has been, I think) is that you need to be root to burn them.

I seriously doubt anybody _really_ cares.

That said, I don't think Peter Jones' patch is wrong.  I don't have any 
strong feelings about it - if people actually want this adn feels it 
improves the situation, why not? Although to actually make _sense_, we'd 
want to have distros that actually want to use the interface to 
auto-populate the command things or something.. In the absense of interest 
from distros, I don't think it is worth it.

		Linus
