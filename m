From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V2 00/15] smartpqi update
Date: Fri, 2 Sep 2016 14:59:08 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916399E05@avsrvexchmbx1.microsemi.net>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
 <yq1poomtwyr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0040.outbound.protection.outlook.com ([104.47.33.40]:16985
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932111AbcIBO7Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Sep 2016 10:59:24 -0400
In-Reply-To: <yq1poomtwyr.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, John Hall <John.Hall@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Viswas G <viswas.g@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thank you for doing the tweaking.

I notice that the MAINTAINERS file got updated with the Documentation/scsi/=
smartpqi.txt, but smartpqi.txt was not added.

Wondering what I need to do to resolve this.


Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation




> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Friday, September 02, 2016 5:31 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; John Hall; Kevin Barnett; Mahesh
> Rajashekhara; hch@infradead.org; Scott Teel; Viswas G; Justin Lindley; Sc=
ott
> Benesh; elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH V2 00/15] smartpqi update
>=20
> EXTERNAL EMAIL
>=20
>=20
> >>>>> "Don" =3D=3D Don Brace <don.brace@microsemi.com> writes:
>=20
> Don,
>=20
> Don> These changes are based on Linus's tree The changes are:
>=20
> Please make sure you submit patches against my tree. Had to tweak a few
> things by hand.
>=20
> Applied series to 4.9/scsi-queue.
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
