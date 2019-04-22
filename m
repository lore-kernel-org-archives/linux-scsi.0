From: Pedro Sousa <PedroM.Sousa@synopsys.com>
Subject: RE: [EXT] Re: [PATCH] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE
 define value
Date: Mon, 22 Apr 2019 09:55:32 +0000
Message-ID: <BE9F9E381D69874CB4F222EB627032EB098AFB06@de02wembxa.internal.synopsys.com>
References: <87405e9b14c6eb01b395f01eac4ab085e8020ff7.1555614814.git.sousa@synopsys.com>
 <SN6PR04MB49257C931DF204F593C2CEE9FC260@SN6PR04MB4925.namprd04.prod.outlook.com>
 <BN7PR08MB56846AE96175DB2C8F250C55DB260@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <BN7PR08MB56846AE96175DB2C8F250C55DB260@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, Avri Altman <Avri.Altman@wdc.com>, Pedro Sousa <PedroM.Sousa@synopsys.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bean, Avri,

From: Bean Huo (beanhuo) <beanhuo@micron.com>
Date: Thu, Apr 18, 2019 at 22:51:01

> Hi, Avri
>=20
> >
> >Hi,
> >I tried to look it up in the unipro spec V1.6 (2013) - but it wasn't the=
re.
> >Is this attribute introduced on a later version?
> >Thanks,
> >Avri
>=20
> It is in M-phy spec,=20
> RX_Termination_Force_Enable should be 0xA9, I think, here is typo.
> But currently no driver uses it.
>=20
>=20
> //Bean

That's correct I've looked it up in M-phy spec.
Thank you for checking.

Despite not being in use I am correcting it since I am planning to use it=20
in a future submission.

Thank you,
Pedro
