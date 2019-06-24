From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v2 0/3] scsi: ufs: typo fixes and improvement
Date: Mon, 24 Jun 2019 05:50:54 +0000
Message-ID: <SN6PR04MB4925C03088D2D715A9ADAB84FCE00@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <BN7PR08MB5684A44F56972BCE0972B28EDBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BN7PR08MB5684A44F56972BCE0972B28EDBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, Evan Green <evgreen@chromium.org>, Stanley Chu <stanley.chu@mediatek.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

>=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> This series patch is to fix several typos and fix one issue of twice
> completing ufs-bsg job in case of UPIU/DME command failed.
>=20
> Changed since v1:
>     - split v1 patch
>     - add fixes tag
>     - delete needless blank line
>=20
> Bean Huo (3):
>   scsi: ufs: fix typos in comment of ufshcd_uic_change_pwr_mode
>   scsi: ufs-bsg: fix typo in ufs_bsg_request
>   scsi: ufs-bsg: complete ufs-bsg job only if no error

This series looks good to me.
Thanks,
Avri
