From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 4/4] scsi: ufs: hisi: fix ufs_hba_variant_ops passing
Date: Wed, 6 Mar 2019 11:43:24 +0000
Message-ID: <DM6PR04MB49231ACAA50E4D8FF5BCE469FC730@DM6PR04MB4923.namprd04.prod.outlook.com>
References: <20190304193917.702601-1-arnd@arndb.de>
 <20190304193917.702601-4-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304193917.702601-4-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Wei Li <liwei213@huawei.com>, Subhash Jadavani <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>=20
> Without CONFIG_OF, the of_match_node() helper does not evaluate
> its argument, and the compiler warns about the unused variable:
>=20
> drivers/scsi/ufs/ufs-hisi.c: In function 'ufs_hisi_probe':
> drivers/scsi/ufs/ufs-hisi.c:673:17: error: unused variable 'dev' [-
> Werror=3Dunused-variable]
>=20
> Rework this code to pass the data directly, and while we're
> at it, correctly handle the const pointers.
>=20
> Fixes: 653fcb07d95e ("scsi: ufs: Add HI3670 SoC UFS driver support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Arnd, Thank you for your comments.
Regards,
Avri
