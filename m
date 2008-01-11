From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] PATCH:
	usb-storage-psc1350-v4.patch (was Linux scsi /
	usb-mass-storage and HP printer cardreader bug + fix)
Date: Fri, 11 Jan 2008 12:34:24 -0800
Message-ID: <20080111203424.GE14375@one-eyed-alien.net>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>
	<4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>
	<4787CE08.5000304@hhs.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1006082646=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4787CE08.5000304@hhs.nl>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, fedora-kernel-list@redhat.com, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org


--===============1006082646==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/2994txjAzEdQwm5"
Content-Disposition: inline


--/2994txjAzEdQwm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 11, 2008 at 09:14:00PM +0100, Hans de Goede wrote:
> Boaz Harrosh wrote:
> >Yes, you're right. in ULDs it is a much proper way to do this.
> >
> >So I guess you'll have to do that special host flag or device
> >flag, and add a check for it in sd.c. You'll see that sd.c is=20
> >already doing bufflen truncation at sd_prep_fn(), just add one
> >more case.
> >
>=20
> Done, thanks for the hint. Patch implementing my fix this way attached,=
=20
> please apply.

Well, I can't say that I'm really a big fan of matching a multi-interface
device based on the interface class code, but I don't see a better solution
that isn't a major coding project.

This approach looks pretty reasonable to me.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

SP: I sell software for Microsoft.  Can you set me free?
DP: Natural Selection says I shouldn't.
					-- MS Salesman and Dust Puppy
User Friendly, 4/2/1998

--/2994txjAzEdQwm5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHh9LQHL9iwnUZqnkRArHpAJ4wzGHh2y7n1yK1B2JunmX5053c+QCgivhT
x4F0uon24345+Mhaa/3ooVc=
=H+Dg
-----END PGP SIGNATURE-----

--/2994txjAzEdQwm5--


--===============1006082646==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
--===============1006082646==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============1006082646==--
