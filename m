From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 1/2] scsi: aacraid: reading out of bounds
Date: Thu, 27 Jul 2017 16:12:36 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5307D0A4@avsrvexchmbx2.microsemi.net>
References: <20170725194955.dd4g6msevoesty4t@mwanda>
 <yq11sp2y6ip.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <yq11sp2y6ip.fsf@oracle.com>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>=20
> Dan,
>=20
> > "qd.id" comes directly from the copy_from_user() on the line before so
> > we should verify that it's within bounds.
>=20
> Applied to 4.13/scsi-fixes. Thanks!
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering

Acked-by: Dave Carroll <david.carroll@microsemi.com>
