From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [EXT] Re: [PATCH] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE
 define value
Date: Thu, 18 Apr 2019 21:51:01 +0000
Message-ID: <BN7PR08MB56846AE96175DB2C8F250C55DB260@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <87405e9b14c6eb01b395f01eac4ab085e8020ff7.1555614814.git.sousa@synopsys.com>
 <SN6PR04MB49257C931DF204F593C2CEE9FC260@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <SN6PR04MB49257C931DF204F593C2CEE9FC260@SN6PR04MB4925.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>, Pedro Sousa <PedroM.Sousa@synopsys.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi, Avri

>
>Hi,
>I tried to look it up in the unipro spec V1.6 (2013) - but it wasn't there=
.
>Is this attribute introduced on a later version?
>Thanks,
>Avri

It is in M-phy spec,=20
RX_Termination_Force_Enable should be 0xA9, I think, here is typo.
But currently no driver uses it.


//Bean

>________________________________________
>From: Pedro Sousa <PedroM.Sousa@synopsys.com>
>Sent: Thursday, April 18, 2019 10:13 PM
>To: alim.akhtar@samsung.com; Avri Altman; martin.petersen@oracle.com
>Cc: linux-scsi@vger.kernel.org; stable@vger.kernel.org; Pedro Sousa
>Subject: [PATCH] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value
>
>Fix RX_TERMINATION_FORCE_ENABLE define value from 0x0089 to 0x00A9
>according to MIPI Alliance MPHY specification.
>
>Fixes: e785060ea3a1 ("ufs: definitions for phy interface")
>Cc: stable@vger.kernel.org
>Signed-off-by: Pedro Sousa <sousa@synopsys.com>
>---
> drivers/scsi/ufs/unipro.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h index
>23129d7..c77e365 100644
>--- a/drivers/scsi/ufs/unipro.h
>+++ b/drivers/scsi/ufs/unipro.h
>@@ -52,7 +52,7 @@
> #define RX_HS_UNTERMINATED_ENABLE              0x00A6
> #define RX_ENTER_HIBERN8                       0x00A7
> #define RX_BYPASS_8B10B_ENABLE                 0x00A8
>-#define RX_TERMINATION_FORCE_ENABLE            0x0089
>+#define RX_TERMINATION_FORCE_ENABLE            0x00A9
> #define RX_MIN_ACTIVATETIME_CAPABILITY         0x008F
> #define RX_HIBERN8TIME_CAPABILITY              0x0092
> #define RX_REFCLKFREQ                          0x00EB
>--
>2.7.4
