From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH 1/2] virtio-blk: limit number of hw queues by nr_cpu_ids
Date: Wed, 10 Apr 2019 14:12:25 +0100
Message-ID: <20190410131225.GA8210@stefanha-x1.localdomain>
References: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
 <1553682995-5682-2-git-send-email-dongli.zhang@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1553682995-5682-2-git-send-email-dongli.zhang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com, cohuck@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2019 at 06:36:34PM +0800, Dongli Zhang wrote:
> When tag_set->nr_maps is 1, the block layer limits the number of hw queues
> by nr_cpu_ids. No matter how many hw queues are used by virtio-blk, as it
> has (tag_set->nr_maps =3D=3D 1), it can use at most nr_cpu_ids hw queues.
>=20
> In addition, specifically for pci scenario, when the 'num-queues' specifi=
ed
> by qemu is more than maxcpus, virtio-blk would not be able to allocate mo=
re
> than maxcpus vectors in order to have a vector for each queue. As a resul=
t,
> it falls back into MSI-X with one vector for config and one shared for
> queues.
>=20
> Considering above reasons, this patch limits the number of hw queues used
> by virtio-blk by nr_cpu_ids.
>=20
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  drivers/block/virtio_blk.c | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJcreu5AAoJEJykq7OBq3PIv1QH/3Xfhaaouf6EN6cUvjc1C8S5
zptX9W26vBX9yhTbAcJTDQ8ETXOri7HIE0e6fGMPUPc5TQQlShnC74b7d8aUqFS2
lxl08VctShlE+vB3YVP5K6FOZ82sHszI+uZde/rTt+2+wZqcOqNz0rzi5H+GwZRQ
QwC3c/Juo/wdG48aWliZrQDApazeKf/2YY+LBqj43Wk7F+X5X65SEiuQkY2xzp0t
VFLrAGxycRpiL0JBTnXf4VtmP+vox26KmLtccRVZktcgckHuexe05nMGFVhy30aB
PkQCu7gUEV9AC6kNT4fO6GML6EPHNWnrGRg4qbgZ0htLuQpDTUYonrOR3q3cDkc=
=TWiv
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
