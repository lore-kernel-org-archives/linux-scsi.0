From: Mark Brown <broonie@kernel.org>
Subject: linux-next: manual merge of the scsi tree with the net-next tree
Date: Fri, 25 May 2018 02:38:10 +0100
Message-ID: <20180525013810.GG4828@sirena.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SKW69dzTt3T8RCN0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--SKW69dzTt3T8RCN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the scsi tree got a conflict in:

  drivers/scsi/qedf/qedf.h

between commit:

  8673daf4f55bf3b91 ("qedf: Add get_generic_tlv_data handler.")

=66rom the net-next tree and commit:

  4b9b7fabb39b3e9d7 ("scsi: qedf: Improve firmware debug dump handling")

=66rom the scsi tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/scsi/qedf/qedf.h
index cabb6af60fb8,2372a40326f8..000000000000
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@@ -501,9 -499,8 +504,10 @@@ extern int qedf_post_io_req(struct qedf
  extern void qedf_process_seq_cleanup_compl(struct qedf_ctx *qedf,
  	struct fcoe_cqe *cqe, struct qedf_ioreq *io_req);
  extern int qedf_send_flogi(struct qedf_ctx *qedf);
 +extern void qedf_get_protocol_tlv_data(void *dev, void *data);
  extern void qedf_fp_io_handler(struct work_struct *work);
 +extern void qedf_get_generic_tlv_data(void *dev, struct qed_generic_tlvs =
*data);
+ extern void qedf_wq_grcdump(struct work_struct *work);
 =20
  #define FCOE_WORD_TO_BYTE  4
  #define QEDF_MAX_TASK_NUM	0xFFFF

--SKW69dzTt3T8RCN0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlsHaQEACgkQJNaLcl1U
h9BCBQf9HYovTcLyzEevPpMrSMw/PDiJEa4qIOuKgyLZpYpYp2B0pyj1f0ZdBaQU
92hg5u8EfxBAS61uL0PErXluj/YZZCRqe0Nzej/tE++FnqNI/4PQNLnMFVjXOsll
rR4fmLZ6cxtcwYJPn0pu8Ld4tosMhQnYKyoiS8Atty0G6CIPnPyAwrrzcQEV14gN
jJddhR3bZEwdc8n6U8eCgj35KFHFItxSU1QXW6zhOTJD+tBvoeZjErG+VgB3U2BK
9m1nl4W5iukWOK9GH9D1sLFk994hMRAPTI0KfPdDD817REKAzznVDgokDZvjC9qT
8JPi0x+Q/m0+CdvP66QPIqWgkWptrQ==
=a1U6
-----END PGP SIGNATURE-----

--SKW69dzTt3T8RCN0--
