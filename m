From: Paul Blazejowski <paulb@blazebox.homeip.net>
Subject: Re: Linux [2.6.0-test3/mm1] aic7xxx problems.
Date: Sun, 24 Aug 2003 20:16:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825001630.GA5132@blazebox.homeip.net>
References: <1060543928.887.19.camel@blaze.homeip.net> <2425882704.1060622541@aslan.btc.adaptec.com> <1060623576.2826.9.camel@blaze.homeip.net> <3F37F1A4.2030404@genebrew.com> <31044.199.181.174.146.1060650619.squirrel@www.blazebox.homeip.net> <3F384819.4070108@genebrew.com> <1060711760.854.6.camel@blaze.homeip.net> <3245752704.1060799900@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pool-141-155-159-60.ny5030.east.verizon.net ([141.155.159.60]:31681
	"EHLO mail.blazebox.homeip.net") by vger.kernel.org with ESMTP
	id S261363AbTHYAP5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Aug 2003 20:15:57 -0400
Content-Disposition: inline
In-Reply-To: <3245752704.1060799900@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2003 at 12:38:20PM -0600, Justin T. Gibbs wrote:
>=20
> It will be a little while before I can get my own distributions up
> and running in the 2.6 stream.  I hope to start looking at this next
> week.
>=20
> --
> Justin
>=20

Hi Justin,

After some more testing i have good news to report.
I am currently running kernel 2.6.0-test4 with aic7xxx driver.

The solution to my earlier problem was in SCSI-Select Utility under
Advanced Settings tab.I have never changed any options under the
AHA-2940U2W bios 2.57.2 but this time i've changed BIOS Support for
Int 13 Extensions from Enabled (default) to Disabled.That made all the
difference when the adapter is probed.

I have a question related to this setting, will this affect anything
when set to Disabled? Perhaps there's something in the driver that
prevents the Int 13 extention from functioning properly?

I can provide .config,dmesg output or verbose messages if needed.

Thank you for helping thus far.

Regards,

Paul


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SVVeIymMQsXoRDARAlYhAJ4nkvXdidlzJNq8DmQZtDH9vdNRXwCfbECY
uiD0IomIvXoTt1ZTQGPI8Hc=
=a/DU
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
