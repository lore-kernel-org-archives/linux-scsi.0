From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] /proc/scsi/map
Date: Wed, 3 Jul 2002 03:01:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020703010102.GB112@elf.ucw.cz>
References: <Pine.LNX.4.44.0206251146440.9420-100000@waste.org> <Pine.LNX.4.33.0206251140060.8496-100000@geena.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206251140060.8496-100000@geena.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mochel <mochel@osdl.org>
Cc: Oliver Xymoron <oxymoron@waste.org>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

Hi!

> [ We could also create a swap interface that we skip over when we notify 
> these interfaces. Then we walk the tree and save state to the swap 
> devices. Then, tell the swap devices to suspend, which can notify the 
> devices to actually go to sleep....maybe..]

No.

swsusp works like this

	stop all devices
	save state
	atomically copy memory into my_big_buffer
	start all devices
	write my_big_buffer into swap
	poweroff

It does not need explicit knowledge of where swap is. And I believe it
is reasonable that way.
									Pavel
-- 
(about SSSCA) "I don't say this lightly.  However, I really think that the U.S.
no longer is classifiable as a democracy, but rather as a plutocracy." --hpa
