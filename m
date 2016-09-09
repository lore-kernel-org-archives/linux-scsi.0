From: David Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Fri, 9 Sep 2016 17:11:58 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A15FACC27@avsrvexchmbx1.microsemi.net>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
        <146706367078.29152.14405582249219794335.stgit@brunhilda>
 <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
 <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0087.outbound.protection.outlook.com ([104.47.37.87]:46336
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750938AbcIIRM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 13:12:26 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>


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
> inform users of the need to configure the smartpqi driver moving forward =
for
> aacraid Series 9 controllers.
>=20
> Hope this helps.
>=20
> Thanks,
> Don Brace
> ESC - Smart Storage
> Microsemi Corporation

Acked-by: Dave Carroll <david.carroll@microsemi.com>
