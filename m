From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] /proc/scsi/map
Date: Sat, 22 Jun 2002 20:42:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020622184220.GD105@elf.ucw.cz>
References: <Pine.LNX.4.33.0206201230190.654-100000@geena.pdx.osdl.net> <3D125735.7000805@evision-ventures.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D125735.7000805@evision-ventures.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Dalecki <dalecki@evision-ventures.com>
Cc: Patrick Mochel <mochel@osdl.org>, Linus Torvalds <torvalds@transmeta.com>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

Hi!

> That's called /. BTW. If anything I'm missing there is the
> representation of the very first BUS out there: CPU!!!

And if you have four cpus, two of them having southbridge with PCI?
You might make cpu%d the root....
									Pavel
-- 
(about SSSCA) "I don't say this lightly.  However, I really think that the U.S.
no longer is classifiable as a democracy, but rather as a plutocracy." --hpa
