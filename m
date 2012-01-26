From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] target: handle empty string writes in sysfs
Date: Thu, 26 Jan 2012 15:19:59 +0300
Message-ID: <20120126121959.GS3294@mwanda>
References: <20120124084036.GB29097@elgon.mountain>
 <4F1E8E31.1070507@bfs.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/U0GMd1Pus0mbMSS"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F1E8E31.1070507@bfs.de>
Sender: target-devel-owner@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--/U0GMd1Pus0mbMSS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 24, 2012 at 11:55:45AM +0100, walter harms wrote:
>=20
>=20
> Am 24.01.2012 09:40, schrieb Dan Carpenter:
> > These are root only and we're not likely to hit the problem in practise,
> > but it makes a the static checkers happy.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >=20
> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/tar=
get_core_configfs.c
> > index 0955bb8..9b86330 100644
> > --- a/drivers/target/target_core_configfs.c
> > +++ b/drivers/target/target_core_configfs.c
> > @@ -1707,6 +1707,8 @@ static ssize_t target_core_store_dev_alias(
> >  	se_dev->su_dev_flags |=3D SDF_USING_ALIAS;
> >  	read_bytes =3D snprintf(&se_dev->se_dev_alias[0], SE_DEV_ALIAS_LEN,
> >  			"%s", page);
>=20
> Would it help to check page=3D=3DNULL or *page=3D=3D0 at start ?
> Now you have se_dev->su_dev_flags initialised.

It's a fair point.  Let me redo it.

regards,
dan carpenter


--/U0GMd1Pus0mbMSS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIUTvAAoJEOnZkXI/YHqR8H8P/j72PeivHtXwNuKnp6dFFdBD
daQA7Cvm8ayUAOEQgA639RxuMINA5Ck3zd1zgwZ5OxHGLeBwQF7FndBNcBTKaRWe
cd0qo8uFiW2J7+u/MTybDXa700WgQnIY8D5MKrBtlL921VvUhhSdvf2FzIyf332i
DiV9HDdEVAWpoyIw3Jeo2chyaOd2b3M8as1islTVoip76+IA23ddb2qCt0ypr3M4
D7FsIqvf0YguM67N/db6I2AtbxqaTJXOjJ1Evh9H4dpUNqPzcPueKvQ2iRQux1r0
WnGP+eBTze/MOet5BfbFzr8WVQp4uu0rhAfdpRbHQ7LqztxDXrVIMxLonxcUUXtP
UjYT6hEdKjhjx65kY6YfZeRXbmOzLkIIxe4ovc1tJmYg5pz8pg1Nn0uu91hZQhDp
j/G4DhMO0E/C1m8tE2hLRjVNp5e0UN1qVT34Rvimm/qQby+j9doH64HWKlkjriIk
baI8vJYJ3FEjD7YWnZrt+82e7D/prbUKpt+fuhcUXsqphWo3sm0NBsVbjPBlIYxe
E77izpR5J0NlpBg+afX4l6RCA2ZIb9DxzqO7t8ww5I+RTjEWN7EyfJ25VZPcn5/f
sS6lKsaPIMKaFhDO5HzVrg7Yv9HaLyf5+5jTExLv9xuw5FzYjiC0KQvjgcTHI8Ex
vKka9SjbweNbUvtb27Xh
=U4BQ
-----END PGP SIGNATURE-----

--/U0GMd1Pus0mbMSS--
