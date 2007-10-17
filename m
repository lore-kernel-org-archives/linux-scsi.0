From: Valdis.Kletnieks@vt.edu
Subject: Re: What still uses the block layer?
Date: Wed, 17 Oct 2007 01:34:24 -0400
Message-ID: <25897.1192599264@turing-police.cc.vt.edu>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015014503.GF9715@thunk.org>
            <200710150304.00901.rob@landley.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192599264_3070P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35904 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXJQFfm (ORCPT
	<RFC822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 01:35:42 -0400
In-Reply-To: Your message of "Mon, 15 Oct 2007 03:04:00 CDT."
             <200710150304.00901.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

--==_Exmh_1192599264_3070P
Content-Type: text/plain; charset=us-ascii

On Mon, 15 Oct 2007 03:04:00 CDT, Rob Landley said:
> I note that the eth0 and eth1 names are dynamically assigned on a first come
> first serve basis (like scsi).  This never causes me a problem because the
> driver loading order is constant, and once you figure out that eth0 is
> gigabit and eth1 is the 80211g it _stays_ that way across reboots, reliably.
> Yeah, it's a heuristic.  Hands up everybody relying on such a heuristic in
> the real world.

I've gotten burned by that heuristic enough times to not rely on it.  My last
laptop had an ethernet on the motherboard, a *separate* ethernet in the docking
station, an ethernet on a multifunction pcmcia card (I usually just used the
modem side), and a wireless that looked like an ethernet - so it was possible
for a given interface to be eth1 (if no dock and no pcmcia card) or eth3 (if
both were present).  And that's on a laptop from almost 5 years ago.

And then there's the recent Sun and Dell 1U rack-mounts that have 4 ethernets
on the motherboard, and they *never* seem to assign in a 0,1,2,3 order that
matches the 0 1 2 3 printed above the 4 RJ45's ;)

So I have for years been a proponent of 'ethN is nailed by MAC address' :)

--==_Exmh_1192599264_3070P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHFZ7gcC3lWbTT17ARAsZXAJ4xuUB1ebX7Vk0jcCwwfaDOEL+g4gCg7TJf
rz3Is447x34Dx3ZHEU167KY=
=glX8
-----END PGP SIGNATURE-----

--==_Exmh_1192599264_3070P--
