From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] /proc/scsi/map
Date: Sat, 22 Jun 2002 20:27:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020622182712.GC105@elf.ucw.cz>
References: <20020620105233.A5506@eng2.beaverton.ibm.com> <Pine.LNX.4.44.0206201133180.8225-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0206201133180.8225-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andries Brouwer <aebr@win.tue.nl>, Martin Schwenke <martin@meltin.net>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

Hi!

> I personally think that the biggest problem with driverfs is it's lack of
> a 2.4.x counterpart. Although the filesystem itself should be fairly
> easy

Well, the thing just does not exist in 2.4.X. I can't see how this can
be helped. [It would be usefull. This way it is close to impossible to
make S3 work nicely in 2.4.X.]
									Pavel
-- 
(about SSSCA) "I don't say this lightly.  However, I really think that the U.S.
no longer is classifiable as a democracy, but rather as a plutocracy." --hpa
