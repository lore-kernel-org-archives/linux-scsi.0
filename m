From: Luciano Rocha <luciano@eurotux.com>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Sun, 26 Oct 2008 14:05:29 +0000
Message-ID: <20081026140529.GA4614@bit.office.eurotux.com>
References: <Pine.LNX.4.44L0.0810251548300.7245-100000@netrider.rowland.org> <1224965493.3449.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755246AbYJZOFs@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1224965493.3449.7.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 25, 2008 at 03:11:33PM -0500, James Bottomley wrote:
> On Sat, 2008-10-25 at 15:50 -0400, Alan Stern wrote:
> > On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
> >=20
> > > [Adding CCs]
> > >=20
> > > On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> > > >=20
> > > > Hello,
> > > >=20
> > > > An external HDD, usb-encased, works fine under 2.6.26.5, but under
> > > > 2.6.27.2 I get hundreds of errors per second, of 'No Sense [current=
]'.
> >=20
> > You can use usbmon to capture the details of what happens when you plug
> > in the drive.  Instructions are in the kernel source file
> > Documentation/usb/usbmon.txt.
>=20
> Try reversing this patch (apply with patch -p1 -R)

I'll try it tomorrow.

Thanks,
Luciano Rocha

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkEeSkACgkQinSul6a7oB9UGwCdEZtTS3op9DBnac+k7giz1OI5
nb0AoJ0bC8NiqOBqzzQbSi8i/eSggUwu
=bL7H
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
