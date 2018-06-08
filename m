From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the scsi tree with the net-next
 tree
Date: Fri, 8 Jun 2018 13:11:38 +1000
Message-ID: <20180608131138.50810e67@canb.auug.org.au>
References: <20180525013810.GG4828@sirena.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oFBvz+qP9J72/FvUYHtLEkd"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180525013810.GG4828@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Chad Dupuis <chad.dupuis@cavium.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Sig_/oFBvz+qP9J72/FvUYHtLEkd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 25 May 2018 02:38:10 +0100 Mark Brown <broonie@kernel.org> wrote:
>
> Today's linux-next merge of the scsi tree got a conflict in:
>=20
>   drivers/scsi/qedf/qedf.h
>=20
> between commit:
>=20
>   8673daf4f55bf3b91 ("qedf: Add get_generic_tlv_data handler.")
>=20
> from the net-next tree and commit:
>=20
>   4b9b7fabb39b3e9d7 ("scsi: qedf: Improve firmware debug dump handling")
>=20
> from the scsi tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc drivers/scsi/qedf/qedf.h
> index cabb6af60fb8,2372a40326f8..000000000000
> --- a/drivers/scsi/qedf/qedf.h
> +++ b/drivers/scsi/qedf/qedf.h
> @@@ -501,9 -499,8 +504,10 @@@ extern int qedf_post_io_req(struct qedf
>   extern void qedf_process_seq_cleanup_compl(struct qedf_ctx *qedf,
>   	struct fcoe_cqe *cqe, struct qedf_ioreq *io_req);
>   extern int qedf_send_flogi(struct qedf_ctx *qedf);
>  +extern void qedf_get_protocol_tlv_data(void *dev, void *data);
>   extern void qedf_fp_io_handler(struct work_struct *work);
>  +extern void qedf_get_generic_tlv_data(void *dev, struct qed_generic_tlv=
s *data);
> + extern void qedf_wq_grcdump(struct work_struct *work);
>  =20
>   #define FCOE_WORD_TO_BYTE  4
>   #define QEDF_MAX_TASK_NUM	0xFFFF

This is now a conflict between the scsi tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/oFBvz+qP9J72/FvUYHtLEkd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlsZ8+oACgkQAVBC80lX
0Gw+Awf+MwQdnxX0K13gISjEo5GCZeLHu6iCdP6EWClTY7sfUrnsHpBwiHRC3AIH
pN78mqFO/4HXdYDE1wsHFqx0JIlL3f8R7IJHXX/keqFMUd7er9kA+XgMoMzjNb/c
scs2RzXnpMnr89gJ8TeRetuuMzCbQBI/YC/fA0O5luamxjcE4pb/L7FCgIE8dVfu
HTQ1Ql4EqhHRSgAaEyNDPyPNBTSmnPUN/xwUqSXFF1CwGVcz/AwVumrXxzYlr8QR
YbwCxYdXKeJnTQv+G2lrArVe7fyFnu7KjV4F6stTAqrZ/cKixOAZ5PAft1XnD1YX
fH/ttnWRBbfCa0rg+4Tujj33vVQ7jQ==
=9q2W
-----END PGP SIGNATURE-----

--Sig_/oFBvz+qP9J72/FvUYHtLEkd--
