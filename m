From: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
Date: Thu, 31 Jan 2008 12:07:36 +0100
Message-ID: <47A1ABF8.4050408@upb.de>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF2114B8E2DB1F8A50F942FFC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:5946 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762468AbYAaL4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 06:56:49 -0500
In-Reply-To: <47A19E26.30107@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF2114B8E2DB1F8A50F942FFC
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

> Yes the gdth driver passed an open hart surgery in kernel 2.6.24. The b=
ad thing
> about it is that all three of the Coders that did that did not have any=
 HW to work
> on. One of them is me. We did cry for tester for a long time but no one=
 came forward.

All i'd like to ask is WHY!?
WHY such a big open heart surgery?
OK, you have your reasons.

> Could you test patches for us? first thing would be to enable debug out=
put patch below.

The machine is still production. It will be replaced by a 64bit system=20
with an AACRAID card some time in the future. Then, i could maybe test=20
patches on the old machine. But unfortunatly, it's not my machine. It's=20
just administrated by me. And i don't know, what's exactly is the future =

of it.

> If you absolutely need a 2.6.24 kernel, + gdth in a production system y=
ou could
> checkout the 2.6.23 driver and compile. The old driver will work the sa=
me in 2.6.24.
> It will not however even compile in 2.6.25-rcx.

I see. Thanks for the hint. Would be an alternative. Actually, i don't=20
need 2.6.24 - but if something security related is fixed, then i'm not=20
able to move on to 2.6.24. And i'm using Gentoo. There's not really a=20
kernel maintained by the distribution.

> If any one wants to send me a card that uses the gdth driver, I will be=
 very happy
> to debug this card, and return it once I'm done.

I don't think, it's a seperate card, that i could send you. It's some=20
19" rack server with such a card on-board, i think.


So it don't see much opportunity for me to test patched and stuff :-(


--------------enigF2114B8E2DB1F8A50F942FFC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHoav47Ww7FjRBE4ARAo4bAJ9m9mKR+Yko3we+KHQdSFWUXAZkbQCfSDpx
+qtpoe7cL2dE+rbbV9akdbI=
=EkF4
-----END PGP SIGNATURE-----

--------------enigF2114B8E2DB1F8A50F942FFC--
