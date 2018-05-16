From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 4/4] scsi: ufs: make ufshcd_config_pwr_mode of non-static
 func
Date: Wed, 16 May 2018 07:51:04 +0000
Message-ID: <DM5PR04MB1085F180B84B88B4D10FE83EFC920@DM5PR04MB1085.namprd04.prod.outlook.com>
References: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
        <CGME20180506102643epcas2p24ed80d7ede859db73c2595724d9c2414@epcas2p2.samsung.com>
 <1525601658-31989-5-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525601658-31989-5-git-send-email-alim.akhtar@samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "olof@lixom.net" <olof@lixom.net>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> On Behalf Of Alim Akhtar
> Sent: Sunday, May 06, 2018 1:14 PM
> To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com;
> vivek.gautam@codeaurora.org; subhashj@codeaurora.org;
> vinholikatti@gmail.com; olof@lixom.net; alim.akhtar@samsung.com
> Subject: [PATCH 4/4] scsi: ufs: make ufshcd_config_pwr_mode of non-static
> func
>=20
> This makes ufshcd_config_pwr_mode non-static so that other vendors like
> exynos can use the same.
>=20
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Acked-by: Avri Altman <avri.altman@wdc.com>

Might be also useful exporting an API for all uic commands?

Thanks,
Avri=20
