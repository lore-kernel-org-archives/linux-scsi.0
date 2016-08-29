From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 15/17] smartpqi: update maintainers
Date: Mon, 29 Aug 2016 20:57:19 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916398C2C@avsrvexchmbx1.microsemi.net>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222993662.31214.1739657681215763725.stgit@brunhilda>
 <20160829094225.xlrpzjto22ushvn7@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0040.outbound.protection.outlook.com ([104.47.33.40]:61034
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755583AbcH2U5X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 16:57:23 -0400
In-Reply-To: <20160829094225.xlrpzjto22ushvn7@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, August 29, 2016 4:42 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benes=
h;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 15/17] smartpqi: update maintainers
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Aug 26, 2016 at 11:45:36AM -0500, Don Brace wrote:
> > From: Kevin Barnett <kevin.barnett@microsemi.com>
> >
> > added Documentation/scsi/smartpqi.txt
> >
> > Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> > Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> > Signed-off-by: Don Brace <don.brace@microsemi.com>
> > ---
> >  MAINTAINERS |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index f50fe50..d980685 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5447,6 +5447,7 @@ F:      drivers/scsi/smartpqi/Kconfig
> >  F:   drivers/scsi/smartpqi/Makefile
> >  F:   include/linux/cciss*.h
> >  F:   include/uapi/linux/cciss*.h
> > +F:   Documentation/scsi/smartpqi.txt
>=20
> This should be foldet into the next patch where you actually add the
> documentation ;-).

I squash smartpqi-add-smartpqi.txt and smartpqi-update-maintainers

Thanks,
Don
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
