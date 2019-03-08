From: <Dave.Carroll@microchip.com>
Subject: RE: [PATCH] scsi: aacraid: Fix performance issue(QD) on logical
 drives
Date: Fri, 8 Mar 2019 16:09:25 +0000
Message-ID: <BYAPR11MB34476D49085938F6FB8FE113884D0@BYAPR11MB3447.namprd11.prod.outlook.com>
References: <1552030001-10658-1-git-send-email-sagar.biradar@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1552030001-10658-1-git-send-email-sagar.biradar@microchip.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, aacraid@microsemi.com, Scott.Benesh@microchip.com, stable@vger.kernel.org, Sagar.Biradar@microchip.com
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: sagar.biradar@microchip.com [mailto:sagar.biradar@microchip.com]
> Sent: Friday, March 08, 2019 12:27 AM
> To: martin.petersen@oracle.com; jejb@linux.vnet.ibm.com
> Cc: linux-scsi@vger.kernel.org; aacraid@microsemi.com; Dave Carroll -
> C33631 <Dave.Carroll@microchip.com>; Scott Benesh - C33703
> <Scott.Benesh@microchip.com>; stable@vger.kernel.org; Sagar Biradar -
> C34249 <Sagar.Biradar@microchip.com>
> Subject: [PATCH] scsi: aacraid: Fix performance issue(QD) on logical driv=
es
>=20
> Fix performance issue where the queue depth for SmartIOC logical volumes =
is
> set to 1, and allow the usual logical volume code to be executed
>=20
> Fixes: a052865fe2871a3888 (aacraid: Set correct Queue Depth for HBA1000
> RAW disks)
>=20
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
> ---
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
