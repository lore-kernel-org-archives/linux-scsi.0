From: Christer Weinigel <christer@weinigel.se>
Subject: Re: cd burning with plextor drives.
Date: 29 Jul 2006 23:40:41 +0200
Message-ID: <m3wt9w3x9i.fsf@zoo.weinigel.se>
References: <20060729045249.GA23398@redhat.com>
	<20060729111240.GG13095@suse.de>
	<1154180419.9447.61.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
	<44CBAB4B.7050308@torque.net>
	<Pine.LNX.4.64.0607291145250.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:45517 "EHLO
	zoo.weinigel.se") by vger.kernel.org with ESMTP id S932229AbWG2Vkn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 17:40:43 -0400
In-Reply-To: <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

Linus Torvalds <torvalds@osdl.org> writes:

> But you can try to _improve_ the filtering. We've certainly done that=
=20
> before. Quite frankly, I don't think there's a lot there that can be=20
> improved upon any more, but it's certainly an option that we could ch=
ange=20
> that filtering to be (a) per-device and (b) allow root to explicitly=20
> change it on a per-machine and per-device setting, with the current=20
> filtering rules being just the "default rules".

The filtering can definitely be improved.  Today sg_io filters on SCSI
commands only, but it really ought to have a filter for mode pages[1]
too.  The burn proof setting for a drive could be in a vendor specific
mode page and cdrecord should be able to write to it.  Another page
controls the SCSI bus timings and shold definitely not be writable by
cdrecord.

Or we could just do as J=F6rg Schilling says: trust him and just make
cdrecord suid root.

  /Christer

[1] http://en.wikipedia.org/wiki/SCSI_mode_pages

--=20
"Just how much can I get away with and still go to heaven?"

=46reelance consultant specializing in device driver programming for Li=
nux=20
Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
