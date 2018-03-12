From: Stephen Kitt <steve@sk2.org>
Subject: Re: [PATCH] device_handler: remove VLAs
Date: Mon, 12 Mar 2018 20:26:44 +0100
Message-ID: <20180312202644.5594421e@heffalump.sk2.org>
References: <20180309232933.14e39858@heffalump.sk2.org>
	<20180309223211.20473-1-steve@sk2.org>
	<1520635688.2907.17.camel@wdc.com>
	<20180310141422.3a8c451f@heffalump.sk2.org>
	<1520869285.3469.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/Q4hJWW478X8YOM=u9FIG7am"; protocol="application/pgp-signature"
Return-path: <kernel-hardening-return-12478-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1520869285.3469.13.camel@wdc.com>
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

--Sig_/Q4hJWW478X8YOM=u9FIG7am
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Mar 2018 15:41:26 +0000, Bart Van Assche <Bart.VanAssche@wdc.com>
wrote:
> On Sat, 2018-03-10 at 14:14 +0100, Stephen Kitt wrote:
> > The two patches I sent were supposed to be alternative solutions; see
> > https://marc.info/?l=3Dlinux-scsi&m=3D152063671005295&w=3D2 for the
> > introduction (I seem to have messed up the headers, so the mails didn=
=E2=80=99t
> > end up threaded properly). =20
>=20
> The two patches arrived in my inbox several minutes before the cover
> letter. In the e-mail header of the cover letter I found the following:
>=20
> X-Greylist: delayed 1810 seconds by postgrey-1.27 at vger.kernel.org; Fri,
> 09 Mar 2018 18:05:08 EST
>=20
> Does this mean that the delay happened due to vger server's anti-spam
> algorithm?

That=E2=80=99s right, the greylisting part of its anti-spam measures.

Regards,

Stephen

--Sig_/Q4hJWW478X8YOM=u9FIG7am
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAlqm1HQACgkQgNMC9Yht
g5w4Pg//XsoJ53FkY+BpdO4+B9OJz3sNmy8OJi+HGqMzhLpHeTp/5JKyCQI0J+6M
kHXrYkl76mRyYSnh4Dx/YEaq99igksN9B6mu21Y/y0ZNIveO1ItEnzux3D9K2/K0
M1ErDbD0rbpt14dkhbY4rn7dvmsLY26mmXEqdd9Kc2hiI4BqxTyI1IOYARswrpyk
jYHglsKtBsgUvloVAsLa7DIjuW7Fk/usA7aoZp2xJenKYVEmRbJDDvb3QOjS13eO
SKfWS8a6+viID7GbvADcGEGy0QdWe1I69qSAhkI5zlHZGaPM/dCCJmvJxRZ8JVks
F+Tl2obuWptRJe3muSLNg6y3XkNH18lvPRUC/AHR5wah9ZX3Hlx0gyudcztIw9FF
Ui1BgDmUyZC9hLgoXNKGGve/U3IEXs7wVV/EpxOfqvVnpmi/d566zv8ltRjRRa4F
f0IxclNOBEwlP0H1rEODKopdMSxTRMpvxLHDQr8ejOr6v7OkOW69UK5xIFpX8N7T
59YK14HbjUav7cjB9JnYTcS+4f3/rsubLYKS8y+DELIGskPEGKNkaiXlQINQ/3E8
09VegkFiaiQM1tCOvq3JXSGKnW/kUrGaAMBsAHdHJaZLjGD01i3tymcjf8eHQaTK
cWrpE98iLC1fqoIIY2Z6HnF65PURaUepKhlrQuERwbpSPGYx/C8=
=huhw
-----END PGP SIGNATURE-----

--Sig_/Q4hJWW478X8YOM=u9FIG7am--
