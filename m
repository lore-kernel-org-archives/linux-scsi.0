From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 8/8] aic94xx: use bitops for testing, setting and clearing bits
Date: Tue, 9 May 2006 23:53:04 +0200
Message-ID: <200605092353.10320@bilbo.math.uni-mannheim.de>
References: <1147209211.11847.33.camel@localhost.localdomain> <1147210963.11847.69.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1379891.gBNIh0JP9O";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:49339 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751181AbWEIVxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2006 17:53:14 -0400
In-Reply-To: <1147210963.11847.69.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--nextPart1379891.gBNIh0JP9O
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 9. Mai 2006 23:42 schrieben Sie:
>Use bitops for testing, setting and clearing bits
>
>Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
>Signed-off-by: Mike Anderson <andmike@us.ibm.com>
>
>---
> drivers/scsi/sas/sas_internal.h |   16 +++++++++-------
> include/scsi/sas/sas_class.h    |    8 ++++----
> 2 files changed, 13 insertions(+), 11 deletions(-)
>
>Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_internal.h
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_internal.h
>+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_internal.h
>@@ -27,6 +27,7 @@
> #define _SAS_INTERNAL_H_
>
> #include <scsi/sas/sas_class.h>
>+#include <linux/bitops.h>
> #include <scsi/scsi_host.h>
>
> #define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ##
> __VA_ARGS__) @@ -70,28 +71,29 @@ void sas_notify_lldd_dev_gone(struct dom
>
> void sas_hae_reset(void *);
>
>-static inline void sas_queue_event(int event, spinlock_t *lock, u32
> *pending,
>-				   struct work_struct *work,=20
>-				   struct Scsi_Host *shost)
>+static inline void sas_queue_event(int event, spinlock_t *lock, unsigned
>+				   long *pending, struct work_struct
>+				   *work, struct Scsi_Host *shost)

Line break in the middle of declarations? I would prefer if you would not d=
o=20
that.

Eike

--nextPart1379891.gBNIh0JP9O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBEYQ9GXKSJPmm5/E4RAg+kAJwN0/H0Wx7cwZyYHV9EvJ+BtTmmbwCgjEIz
tKoQgToTgXPEnKjBgOGqHTk=
=8N+b
-----END PGP SIGNATURE-----

--nextPart1379891.gBNIh0JP9O--
