From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH 2/2] scsi: virtio_scsi: limit number of hw queues by
 nr_cpu_ids
Date: Wed, 10 Apr 2019 14:12:28 +0100
Message-ID: <20190410131228.GB8210@stefanha-x1.localdomain>
References: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
 <1553682995-5682-3-git-send-email-dongli.zhang@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1553682995-5682-3-git-send-email-dongli.zhang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com, cohuck@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2019 at 06:36:35PM +0800, Dongli Zhang wrote:
> When tag_set->nr_maps is 1, the block layer limits the number of hw queues
> by nr_cpu_ids. No matter how many hw queues are used by virtio-scsi, as it
> has (tag_set->nr_maps =3D=3D 1), it can use at most nr_cpu_ids hw queues.
>=20
> In addition, specifically for pci scenario, when the 'num_queues' specifi=
ed
> by qemu is more than maxcpus, virtio-scsi would not be able to allocate
> more than maxcpus vectors in order to have a vector for each queue. As a
> result, it falls back into MSI-X with one vector for config and one shared
> for queues.
>=20
> Considering above reasons, this patch limits the number of hw queues used
> by virtio-scsi by nr_cpu_ids.
>=20
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  drivers/scsi/virtio_scsi.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJcreu8AAoJEJykq7OBq3PIvCcIAJk0lXKMxHlM2G2cGbmwHZh+
Vg/WLG3lMPI+4bn8Ze+aH4LqvwJWaFbd9hjs0hQ4UuDZ2obQi8neJYeUx1ZD0Wii
dOnHvCtFxvhEOKGNv9aW8EUbMrV1Aytji+inw1Cf6xawY5G8qg1LEBKd4a341Zkm
jEMguwG9Rt1fBQbd9jP14Nbj2VyD/qAxDQVC8Cd0DfLEmfjl35HEu+bvHcMnUFw5
h/WsViGOWzKmk/3YVOLzSXrbf8kgdBu30knaYhYWR/OkJkTDqGiy5kf2eqdWSLcD
RWtZxZzpMM0hoh4GwExjnCBhw0G8npzermidU/6a1j9zk74CEUvBGj0H2RfzXEA=
=kK0F
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
