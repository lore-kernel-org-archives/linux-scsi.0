From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Binary-only firmware covered by the GPL?
Date: 30 Mar 2004 20:11:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <874qs6nr25.fsf@mrvn.homelinux.org>
References: <20040325225423.GT9248@cheney.cx>
	<MDEHLPKNGKAHNMBLJOLKCEEOLEAA.davids@webmaster.com>
	<20040326131629.GB26910@zombie.inka.de> <40643BFA.1000302@stesmi.com>
	<20040330113915.GB3084@openzaurus.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5.Informatik.Uni-Tuebingen.De ([134.2.12.32]:58521 "EHLO
	mx5.informatik.uni-tuebingen.de") by vger.kernel.org with ESMTP
	id S263797AbUC3SLV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 13:11:21 -0500
In-Reply-To: <20040330113915.GB3084@openzaurus.ucw.cz>
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Cc: Stefan Smietanowski <stesmi@stesmi.com>, Eduard Bloch <edi@gmx.de>, David Schwartz <davids@webmaster.com>, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Pavel Machek <pavel@suse.cz> writes:

> Hi!
> 
> If my code contains picture of human, do I have to provide his DNA, too?
> 				Pavel
> 
> (runs away)

If the picture was made with gimp and you keep an xcf of it around for
changing it (because it keeps the layers) but only ship a png (no more
layers) then your violating the GPL.

Prefered form for you would be the xcf file and not the png.

Of cause its hard to show that you do use an xcf as prefered form
without spying at you working on it so you can get away with an png.


With binary firmware is way easier to argue that the prefered form is
some kind of asm, C , forth or whatever source and not the binary.
That someone is prefering a hex editor is very unlikely.

If the driver+firmware is released as GPL (say as binary driver
containing the firmware) then the _firmware_ would be in violation of
the GPL unless source is provided or a note confirming the 3 years on
request thing is there. Either way the source of the firmware has to
be made available.

So please do get firms to release GPLed drivers with firmware included
as GPL bcause then we can sue them for the firmware source. :)

MfG
        Goswin

