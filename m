From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH 0/2] scsi: add support for request batching
Date: Mon, 10 Jun 2019 13:36:17 +0100
Message-ID: <20190610123617.GK14257@stefanha-x1.localdomain>
References: <20190530112811.3066-1-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvuyDaC2GNSBQusT"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190530112811.3066-1-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org


--GvuyDaC2GNSBQusT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2019 at 01:28:09PM +0200, Paolo Bonzini wrote:
> This allows a list of requests to be issued, with the LLD only writing
> the hardware doorbell when necessary, after the last request was prepared.
> This is more efficient if we have lists of requests to issue, particularly
> on virtualized hardware, where writing the doorbell is more expensive than
> on real hardware.
>=20
> This applies to any HBA, either singlequeue or multiqueue; the second
> patch implements it for virtio-scsi.
>=20
> Paolo
>=20
> Paolo Bonzini (2):
>   scsi_host: add support for request batching
>   virtio_scsi: implement request batching
>=20
>  drivers/scsi/scsi_lib.c    | 37 ++++++++++++++++++++++---
>  drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
>  include/scsi/scsi_cmnd.h   |  1 +
>  include/scsi/scsi_host.h   | 16 +++++++++--
>  4 files changed, 89 insertions(+), 20 deletions(-)
>=20
> --=20
> 2.21.0
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--GvuyDaC2GNSBQusT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlz+TsEACgkQnKSrs4Gr
c8gE+QgAwWdqWzwfL6+Ow3hy/qynLLmeQ94GdokspoNxkJ+GvFFTuq51OaFQyMeH
dE+3n2QBm0p57kO1c6doG6CWuOGeMN9pd5PGgLyl+QOaSc1u2LO/kWUJ8Re3Ggyz
QICTZseq3Z4NVerKLZY5Mx53YZfRMbePKVSrfWUR4okHtwSojMIh6bDaIf1HvHU/
vcsEDFOUEle1nu2ypocOoVP6E15tYRlIlYlvnhoeM2Dv1A9+VazFnOkavn2wnEi9
H0ELaaWbRibQFXfIuWf7s8VyLufh1EoGtVAUF4Dza3y/tRg5rVbTEgO3/1S+m1PV
qqPghgKwdjpLkaF2vXeKWBoC2SqiKw==
=IMS9
-----END PGP SIGNATURE-----

--GvuyDaC2GNSBQusT--
