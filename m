From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: NEXX NF-315: unusual_devs.h entry submission
Date: Thu, 8 Nov 2007 09:45:20 -0800
Message-ID: <20071108174520.GB6089@one-eyed-alien.net>
References: <20071106221914.GA10728@breeze.localhost>
	<Pine.LNX.4.44L0.0711071419020.6432-100000@iolanthe.rowland.org>
	<20071107222853.GA10380@breeze.localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1746561085=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20071107222853.GA10380@breeze.localhost>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Linux SCSI list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org


--===============1746561085==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(CC'ing linux-scsi on this)

On Thu, Nov 08, 2007 at 01:28:53AM +0300, Serge (gentoosiast) Koksharov wro=
te:
> On Wed, Nov 07, 2007 at 02:31:45PM -0500, Alan Stern wrote:
> > This suggests that the device needs a longer timeout for the INQUIRY
> > command.  The default timeout is 5 seconds (the driver adds an extra
> > 0.5 seconds for some reason), but it is a module parameter you can
> > adjust.  Try adding
> >=20
> > 	options sd_mod inq_timeout=3D10
> >=20
> > to your /etc/modprobe.conf.  This might fix the problem.
>=20
> Yes! Your suggestion solved my problem, thank you very much.

What we have here is a device which takes a particularly long time to
respond to an INQUIRY command (a little over 6 seconds, I think).

Would there be any objections to permanently modifying sd_mod to change the
default INQUIRY timeout to 10 seconds (currently 5)?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:   Baaap booop BAHHHP.
Mir: 9600 Baud?
Mik: No, no!  9600 goes baap booop, not booop bahhhp!
					-- Greg, Miranda and Mike
User Friendly, 12/31/1998

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHM0swHL9iwnUZqnkRAi9DAKCcy4isntUAtQzFIg7bx56JIDmBZgCeLrfR
YosetcjHQDT13xzxLnt0z1I=
=aFmE
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--


--===============1746561085==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
--===============1746561085==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============1746561085==--
