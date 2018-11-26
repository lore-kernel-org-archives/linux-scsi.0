From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH] scsi: ufs: add fall through annotation
Date: Mon, 26 Nov 2018 15:56:16 +0000
Message-ID: <DM6PR04MB4923C5B8A2F8190EFE4A3EEDFCD70@DM6PR04MB4923.namprd04.prod.outlook.com>
References: <20181126081034.30185-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126081034.30185-1-tomas.winkler@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Tomas Winkler <tomas.winkler@intel.com>
> Sent: Monday, November 26, 2018 10:11 AM
> To: James E . J . Bottomley <jejb@linux.vnet.ibm.com>; Martin K . Peterse=
n
> <martin.petersen@oracle.com>; Vinayak Holikatti
> <vinholikatti@gmail.com>; Avri Altman <Avri.Altman@wdc.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Tomas Winkl=
er
> <tomas.winkler@intel.com>
> Subject: [PATCH] scsi: ufs: add fall through annotation
>=20
> Add /* fallthrough */ annotation, to eliminate compilation warning:
> warning: this statement may fall through [-Wimplicit-fallthrough=3D]
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
