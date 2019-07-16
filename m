From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v1] scsi: ufs: change msleep to usleep_range
Date: Tue, 16 Jul 2019 06:54:50 +0000
Message-ID: <SN6PR04MB492511AE7841BD4C84205218FCCE0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <BN7PR08MB5684BBB44FD0E43501558A20DBCF0@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BN7PR08MB5684BBB44FD0E43501558A20DBCF0@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, Evan Green <evgreen@chromium.org>, Stanley Chu <stanley.chu@mediatek.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> This patch is to change msleep() to usleep_range() based on
> Documentation/timers/timers-howto.txt. It suggests using
> usleep_range() for small msec(1ms - 20ms) since msleep()
> will often sleep longer than desired value.
>=20
> After changing, booting time will be 5ms-10ms faster than before.
> I tested this change on two different platforms, one has 5ms faster,
> another one is about 10ms. I think this is different on different
> platform.
>=20
> Actually, from UFS host side, 1ms-5ms delay is already sufficient for
> its initialization of the local UIC layer.
>=20
> Fixes: 7a3e97b0dc4b ([SCSI] ufshcd: UFS Host controller driver)
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
