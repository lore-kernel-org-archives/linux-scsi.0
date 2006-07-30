From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: cd burning with plextor drives.
Date: Sun, 30 Jul 2006 11:38:49 +0200
Message-ID: <20060730093848.GC8910@bitwizard.nl>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de> <1154180419.9447.61.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <44CBAB4B.7050308@torque.net> <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org> <44CBC115.2080401@torque.net> <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:636 "HELO abra2.bitwizard.nl")
	by vger.kernel.org with SMTP id S932096AbWG3Jiu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 05:38:50 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

On Sat, Jul 29, 2006 at 01:33:42PM -0700, Linus Torvalds wrote:
> (Yeah, I realize that it's also possible that the firmware update
> could happen by the drive just reading a disk, since the controller
> will do various things on its own anyway. I don't actually know if
> that is ever the case, or possibly even the _common_ case, but my
> wild guess would be that it's a lot more common to have a firmware
> update SCSI command than to have the drive able to update its own
> firmware).

Just for the record: we've upgraded CD burner firmware, and it works
by running some silly little program on DOS. No media involved.

We've updated/modified harddisk drive firmware. Same procedure: vendor
specific commands, and voila! (We're currently banging the hardware to
do this, possibly we might port to some passtrhough thingy later on)

I have vendor confirmation that turning on some consumer electronics
while holding a specific key combo will make the device boot (some
stage-2 boot) from the inserted CD instead of the firmware inside.
They use this to boot the "diagnostics" CD, but an "update firmware"
CD could obviously be made. 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
