From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: remove incorrect lockdep assertion
Date: Mon, 18 Apr 2016 09:07:37 +0200
Message-ID: <1543520.n4UZ9fsgDT@c203>
References: <20160417132727.000026f3@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbcDRHHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2016 03:07:39 -0400
In-Reply-To: <20160417132727.000026f3@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Sonntag, 17. April 2016 13:27:27 CEST Sebastian Herbszt wrote:
> Remove incorrect lockdep assertion from lpfc_sli_hbqbuf_find() which =
acquires
> the hbalock itself. Fix the comment which resulted in this mistake.
>=20
> Fixes: 1c2ba475eb0e ("lpfc: Add lockdep assertions")
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
>=20

Good catch,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                                     =
                           Storage
jthumshirn@suse.de                                                     =
        +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
