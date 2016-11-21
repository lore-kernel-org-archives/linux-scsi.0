From: "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>
Subject: RE: [PATCH] bfa: turn bfa_mem_{kva,dma}_setup into inline functions
Date: Mon, 21 Nov 2016 04:41:37 +0000
Message-ID: <BY1PR0701MB16448F82D6CB999E9D7E5C698EB50@BY1PR0701MB1644.namprd07.prod.outlook.com>
References: <20161116151445.3208739-1-arnd@arndb.de>
 <20161118132203.3og7fayqxk3xd5r2@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0050.outbound.protection.outlook.com ([104.47.36.50]:49310
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751258AbcKUElp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 20 Nov 2016 23:41:45 -0500
In-Reply-To: <20161118132203.3og7fayqxk3xd5r2@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Patch looks good.
Acked by: Anil Gurumurthy <anil.gurumurthy@cavium.com>


-----Original Message-----
From: Johannes Thumshirn [mailto:jthumshirn@suse.de]=20
Sent: 18 November 2016 18:52
To: Arnd Bergmann <arnd@arndb.de>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen <mar=
tin.petersen@oracle.com>; Anil Gurumurthy <anil.gurumurthy@qlogic.com>; Sud=
arsana Kalluru <sudarsana.kalluru@qlogic.com>; linux-scsi@vger.kernel.org; =
linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bfa: turn bfa_mem_{kva,dma}_setup into inline function=
s

On Wed, Nov 16, 2016 at 04:14:27PM +0100, Arnd Bergmann wrote:
> These two macros cause lots of warnings with gcc-7:
>=20
> drivers/scsi/bfa/bfa_svc.c: In function 'bfa_fcxp_meminfo':
> drivers/scsi/bfa/bfa_svc.c:521:103: error: '*' in boolean context,=20
> suggest '&&' instead [-Werror=3Dint-in-bool-context]
>=20
> Using inline functions makes them much more readable and avoids the=20
> warnings.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton HRB 21284 (AG N=FCrnb=
erg) Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
