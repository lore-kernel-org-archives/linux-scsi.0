From: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] scsi: fix lockdep warning
Date: Wed, 31 Mar 2010 03:55:44 +0200
Message-ID: <20100331015544.GA3520@pengutronix.de>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com> <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com> <m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org> <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org> <4BA47692.7040401@kernel.org> <4bb21338.0d0db80a.1685.ffffb9e1@mx.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4bb21338.0d0db80a.1685.ffffb9e1@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <gregkh@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Moreover, there are still failures in the ACPI thermal driver (at very le=
ast)
> on master (9623e5a23724d09283c238960946ec6f65733afe).

https://patchwork.kernel.org/patch/87436/
(or https://bugzilla.kernel.org/show_bug.cgi?id=3D15548)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuyq6AACgkQD27XaX1/VRtgpACgqDUPeQ/SnYZHmiIgXYaLM69h
5gUAnA2yXfIFLTll9DZqLbLwEXqT4CJF
=jL77
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
