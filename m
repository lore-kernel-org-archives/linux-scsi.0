From: Pavel Machek <pavel@suse.cz>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Tue, 30 Mar 2004 13:39:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040330113915.GB3084@openzaurus.ucw.cz>
References: <20040325225423.GT9248@cheney.cx> <MDEHLPKNGKAHNMBLJOLKCEEOLEAA.davids@webmaster.com> <20040326131629.GB26910@zombie.inka.de> <40643BFA.1000302@stesmi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:19392 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S263660AbUC3N7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 08:59:38 -0500
Content-Disposition: inline
In-Reply-To: <40643BFA.1000302@stesmi.com>
List-Id: linux-scsi@vger.kernel.org
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: Eduard Bloch <edi@gmx.de>, David Schwartz <davids@webmaster.com>, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi!

> >#include <hallo.h>
> >* David Schwartz [Thu, Mar 25 2004, 04:41:23PM]:
> >
> >
> >>>IMHO code that can be compiled would probably be the preferred form
> >>>of the work.
> >>
> >>	You are seriously arguing that the obfuscated binary of the 
> >>	firmware is the
> >>preferred form of the firmware for the purpose of making 
> >>modifications to
> >>it?!
> >
> >
> >Yes, the driver authors PREFERS to make the changes on the C source
> >code, he never has to modify the firmware. Exactly what the GPL
> >requests, where is your problem?
> 
> But the firmware didn't appear out of thin air - someone wrote it
> somehow. If that's using a hex editor or inside the C code doesn't
> matter, but most likely they used some other language like either
> C or assembly (no, not all firmware is written using assembly), and
> there are cases where some are in fact written using a hex editor but
> I can't remember any that has been for the last 30 or so years but
> I'm sure there has been cases where there hasn't been a working
> assembler.

If my code contains picture of human, do I have to provide his DNA, too?
				Pavel

(runs away)
-- 
64 bytes from 195.113.31.123: icmp_seq=28 ttl=51 time=448769.1 ms         

