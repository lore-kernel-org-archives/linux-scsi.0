From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH] virtio_scsi: always read VPD pages for multiqueue too
Date: Tue, 11 Jul 2017 13:29:02 +0100
Message-ID: <20170711122902.GR17792@stefanha-x1.localdomain>
References: <1499243456-29978-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y2MHPAl/EzyWgzIZ"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499243456-29978-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, famz@redhat.com, stable@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
List-Id: linux-scsi@vger.kernel.org


--y2MHPAl/EzyWgzIZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 05, 2017 at 10:30:56AM +0200, Paolo Bonzini wrote:
> Multi-queue virtio-scsi uses a different scsi_host_template struct.
> Add the .device_alloc field there, too.
>=20
> Fixes: 25d1d50e23275e141e3a3fe06c25a99f4c4bf4e0
> Cc: stable@vger.kernel.org
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--y2MHPAl/EzyWgzIZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJZZMSOAAoJEJykq7OBq3PIsQgH/3/kbFrOEDY/Bj+8h8K8zrp7
AmLPneYV2nJlluk8aePEd6TxYA8yUkliP0HDuCHM67u1YBWwzEIBUPcfb79NdBLI
N4dpcTde1DLMdKs8enqUDcWyNNcquIFn1MqNvemZEFoUuWc1PR6TjVNy3AlPvpvS
dt1fc4UsXIANifa++Slt2C2ApKbGqfdFe8aQYu7o3E9zbRl6rYaCb/v2Bs1+CDRW
gC6jyw+gMgqlSDhWK8ixzGEvw++2e/Rli3SyyOhU8JJv1pGcbYn/bCR82+NxaJNW
z8Kv0vF5U3BbuhDQf5t0734v6WIK6d5N6vhMJkGumebHxefQXaDlHxIHvUUo7UY=
=5XkO
-----END PGP SIGNATURE-----

--y2MHPAl/EzyWgzIZ--
