From: Olivier Galibert <galibert@pobox.com>
Subject: Re: Infinite interrupt loop, INTSTAT = 0
Date: Wed, 28 Sep 2005 19:10:52 +0200
Message-ID: <20050928171052.GA45082@dspnet.fr.eu.org>
References: <20050928134514.GA19734@dspnet.fr.eu.org> <1127919909.4852.7.camel@mulgrave> <20050928160744.GA37975@dspnet.fr.eu.org> <1127924686.4852.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750863AbVI1RLD@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1127924686.4852.11.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Hack inc." <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2005 at 11:24:46AM -0500, James Bottomley wrote:
> On Wed, 2005-09-28 at 18:07 +0200, Olivier Galibert wrote:
> > scsi1:0:0:0: Attempting to abort cmd ffff8101b1cdf880: 0x28 0x0 0x0
> > 0xbc 0x0 0x3f 0x0 0x0 0x8 0x0
> 
> Hmm, that message doesn't appear in the current kernel driver.
> 
> Is this a non-standard kernel or non-standard aic79xx driver?

Just reproduced the exact same message with a vanilla 2.6.13.2.
Checking the just-untarred sources, it _is_ in aix79xx_osm.c, in
ahd_linux_abort.  You must have typoed "Attempting" in your grep :-)

Want be to try to BUG() it or something to get a stack trace?  The
crash happens a handful of seconds after the card dumping, time enough
for a well-placed dmesg in an xterm.

Incidentally, how can one get a backtrace without crashing the kernel
in the operation?

  OG.
