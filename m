From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH] scsi: ufs: Additional clock initialization in Cadence UFS
Date: Wed, 31 Jul 2019 10:09:54 +0000
Message-ID: <MN2PR04MB699133D84C627AE30C6A50CDFCDF0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20190731083614.25926-1-aniljoy@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190731083614.25926-1-aniljoy@cadence.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Varughese <aniljoy@cadence.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
Cc: "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "rafalc@cadence.com" <rafalc@cadence.com>, "mparab@cadence.com" <mparab@cadence.com>, "jank@cadence.com" <jank@cadence.com>, "vigneshr@ti.com" <vigneshr@ti.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>=20
> Configure CDNS_UFS_REG_HCLKDIV in .hce_enable_notify()
> because if UFSHCD resets the controller ip because of
> phy or device related errors then CDNS_UFS_REG_HCLKDIV
> is reset to default value and .setup_clock() is not
> called later in the sequence whereas hce_enable_notify
> will be called everytime controller is reenabled.
>=20
> Signed-off-by: Anil Varughese <aniljoy@cadence.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
