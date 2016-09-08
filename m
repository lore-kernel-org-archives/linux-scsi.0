From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Thu, 8 Sep 2016 18:15:01 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D191639AE64@avsrvexchmbx1.microsemi.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
        <146706367078.29152.14405582249219794335.stgit@brunhilda>
 <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
 <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0086.outbound.protection.outlook.com ([104.47.40.86]:6560
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758107AbcIHSPU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Sep 2016 14:15:20 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Don Brace
> Sent: Wednesday, September 07, 2016 4:05 PM
> To: Martin K. Petersen
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benes=
h;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: RE: [PATCH V4 2/2] aacraid: remove wildcard for series 9 control=
lers
>=20
> EXTERNAL EMAIL
>=20
>=20
> > -----Original Message-----
> > From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> > Sent: Friday, August 12, 2016 3:09 PM
> > To: Don Brace
> > Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> > hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Ben=
esh;
> > elliott@hpe.com; linux-scsi@vger.kernel.org
> > Subject: Re: [PATCH V4 2/2] aacraid: remove wildcard for series 9
> controllers
> >
> > EXTERNAL EMAIL
> >
> >
> > >>>>> "Don" =3D=3D Don Brace <don.brace@microsemi.com> writes:
> >
> > Don,
> >
> > Don> Depends on smartpqi driver adoption
> >
> > -    { 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /* Adaptec P=
MC
> > Series 9 */
> >
> > How are people that load aacraid in their initrd going to boot after
> > this?
> >
> > --
> > Martin K. Petersen      Oracle Linux Engineering
>=20
> I updated smartpqi/Kconfig and added Documentation/scsi/smartpqi.txt to
> inform users of the
> need to configure the smartpqi driver moving forward for aacraid Series 9
> controllers.
>=20
> Hope this helps.
>=20
> Thanks,
> Don Brace
> ESC - Smart Storage
> Microsemi Corporation
>=20
>=20

One more note:
A little extra clarification. Removing these IDs from the aacraid driver ha=
s no impact on the driver
loading for currently available controllers.

These IDs are only used on new controllers and we want the new smartpqi dri=
ver
to only be used with these new controllers. Now that the smartpqi
driver is in for-next we need to get rid of this overlap.

>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
