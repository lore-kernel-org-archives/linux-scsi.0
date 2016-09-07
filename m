From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Wed, 7 Sep 2016 21:04:47 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
        <146706367078.29152.14405582249219794335.stgit@brunhilda>
 <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0083.outbound.protection.outlook.com ([104.47.41.83]:23637
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934002AbcIGViQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Sep 2016 17:38:16 -0400
In-Reply-To: <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Friday, August 12, 2016 3:09 PM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benes=
h;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH V4 2/2] aacraid: remove wildcard for series 9 control=
lers
>=20
> EXTERNAL EMAIL
>=20
>=20
> >>>>> "Don" =3D=3D Don Brace <don.brace@microsemi.com> writes:
>=20
> Don,
>=20
> Don> Depends on smartpqi driver adoption
>=20
> -    { 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /* Adaptec PMC
> Series 9 */
>=20
> How are people that load aacraid in their initrd going to boot after
> this?
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering

I updated smartpqi/Kconfig and added Documentation/scsi/smartpqi.txt to inf=
orm users of the
need to configure the smartpqi driver moving forward for aacraid Series 9 c=
ontrollers.

Hope this helps.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation



