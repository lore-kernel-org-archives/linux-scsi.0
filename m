From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Sun, 30 Jul 2006 13:06:30 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607301300320.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de>
 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <44CBAB4B.7050308@torque.net>
 <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org> <44CBC115.2080401@torque.net>
 <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org> <44CCF446.9000007@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40595 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932460AbWG3UGf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 16:06:35 -0400
In-Reply-To: <44CCF446.9000007@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org



On Sun, 30 Jul 2006, Douglas Gilbert wrote:
> 
> The point I'm trying to make is that opcode based filtering
> may have been sufficient in 1992 (circa SCSI-2) but 14
> years later it most certainly ain't.

Nobody has ever contested that we might not make it smarter.

The point I was makign was that _not_ filtering is insane. The filters 
could possibly be made smarter, but REMOVING THEM IS NOT AN OPTION. It's 
also not an option to make it root-only, because making cdrecord suid root 
simply isn't acceptable as things are now.

And that _is_ what you and Jens were talking about.

And that is also what you claimed that the storage summit decided was the 
sane approach.

So can we _please_ agree that the storage summit was just being stupid and 
incompetent, and hadn't thought it through? That filtering isn't going 
away, but it migt be extended.

Oh, btw, I'm perfectly fine with removing the filtering from "sg.c", and 
making _that_ interface be root-only. Anything that doesn't use the 
block/scsi_ioctl.c version of the interface is not worth supporting any 
more, since it hasn't _ever_ worked reliably with IDE-CD's, and quite 
frankly, IDE-CD's is pretty much 95+% of the market.

		Linus
