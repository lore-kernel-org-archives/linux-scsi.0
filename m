From: Stephen Kitt <steve@sk2.org>
Subject: Re: [PATCH] aic7xxx/aic79xx: remove VLAs
Date: Thu, 8 Mar 2018 21:50:19 +0100
Message-ID: <20180308215019.399ebdb4@heffalump.sk2.org>
References: <20180308132225.13229-1-steve@sk2.org>
	<CAGXu5jK=JhBFHBGpbWF46DC3-QMruiB0qqz1z+njcK2h7jVU9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/EbA69GcKFcB.rXi1iSj5RD0"; protocol="application/pgp-signature"
Return-path: <kernel-hardening-return-12261-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAGXu5jK=JhBFHBGpbWF46DC3-QMruiB0qqz1z+njcK2h7jVU9w@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: hare <hare@suse.com>, linux-scsi@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Sig_/EbA69GcKFcB.rXi1iSj5RD0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Mar 2018 11:52:25 -0800, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Mar 8, 2018 at 5:22 AM, Stephen Kitt <steve@sk2.org> wrote:
> > -static const int num_critical_sections =3D sizeof(critical_sections)
> > -                                      / sizeof(*critical_sections);
> > +#define NUM_CRITICAL_SECTIONS 14 =20
>=20
> The compiler doesn't treat "const" as a literal, hence the need to
> change this. However, you can still use the sizeof (actually, this is
> exactly ARRAY_SIZE()). Perhaps:
>=20
> #define NUM_CRITICAL_SECTIONS ARRAY_SIZE(critical_sections)
>=20
> ?
>=20
> Otherwise, looks great!

Thanks, v2 incoming...

Regards,

Stephen

--Sig_/EbA69GcKFcB.rXi1iSj5RD0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAlqhogsACgkQgNMC9Yht
g5y+vxAAhYiZaRdCTRVxuCtpCt3PtJk1fq4D+RwtPbQjYdM1ZNm5H7DN1tL7Qac/
vP8pnMh3jjU2s2+3lKth3SsM/3izj4KsHFk2XXZjncSIHZddvOhGOpYzGVSNRs97
CKl1JxeTzt+7IaT8u7bxT8sSoIuhMqpXAT+y0YjlG4ljFWpZ23wZ6AxD2EIhDrLi
wddbrvzGHMohAFYg+m4gM7E6SPx/N4dwFaW3ZD1bALvB284OIa0lkWrPQJLNI0m3
JahA6OgzrQkHm8qqwGQPyKWY1JC0nTm/euF387AnklyE9v7pjB0uRk6Muj7Yle55
yN4bKnXfFbQH1ANmbBMfvkIUTZESXaViPweHr3RbmbnMtEpvVkxt04qAOp7mhvBL
qoICxTDE4C1mTHrehCnCjmA095owv+ZJc7TBZGPyvKlBscQh8KBNiJ/b3mXlrTPV
RlLhOt9+oG/Sug/6J+30gYLV5CRJCAQK0H//zmeCKfKIq5Gtefm2CfX1Z+FiXTzM
nREDdG1Pqg0Q+Flh7Yyz7DRY2MYe91cprj1ZsWbl+jmy89ds1iIXR3Q+s2011N8T
/8QR4vIflUsVgaQoIkKyRqp4bAKxj83oN/vXvAauwTEfNfb0bAoeqAzesfBmc6M9
2xHL145DPD1fth4l4PFNsaYdgeYkw1ZnqAEy1TUTaQSbFKDoB3I=
=xGd9
-----END PGP SIGNATURE-----

--Sig_/EbA69GcKFcB.rXi1iSj5RD0--
