From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: origin tree build warning
Date: Fri, 30 Oct 2009 14:30:03 +1100
Message-ID: <20091030143003.5a961d65.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Oct_2009_14_30_03_+1100_CIj_dIR_M1NtPTx3"
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Fri__30_Oct_2009_14_30_03_+1100_CIj_dIR_M1NtPTx3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

drivers/scsi/ipr.c: In function 'ipr_log_enhanced_dual_ioa_error':
drivers/scsi/ipr.c:1336: warning: ignoring return value of 'strstrip', decl=
ared with attribute warn_unused_result
drivers/scsi/ipr.c: In function 'ipr_log_dual_ioa_error':
drivers/scsi/ipr.c:1362: warning: ignoring return value of 'strstrip', decl=
ared with attribute warn_unused_result

Exposed by commit 0a1b71b4008d332e57b5605a8228ea7aa96687e8 ("strstrip():
mark as as must_check").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Oct_2009_14_30_03_+1100_CIj_dIR_M1NtPTx3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrqXbsACgkQjjKRsyhoI8xwSQCeJMeebKCgtwj0J53e1LIvU7YR
icAAnjqPCs9zZjOiWZvvzx16KFcFykAq
=IZOi
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Oct_2009_14_30_03_+1100_CIj_dIR_M1NtPTx3--
