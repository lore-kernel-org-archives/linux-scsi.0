Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2122.outbound.protection.partner.outlook.cn [139.219.17.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7655D3C062A;
	Wed, 22 Apr 2026 11:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776856810; cv=fail; b=LIASo1VJZnsUus/R6sBHD2ySIPYHHgZfXCHeOdIcW7pRBWJKOqfni5sj/6mOV0zu/KagSRtKpYnhMHYT3yGVvgMvBre1Htp9fqz+Hmb3k59evnRgfPm3G2wWPx7z7cNaFW518GwdDk5akCs14IK3mdcb3EzSGQkNW26ujt2C4kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776856810; c=relaxed/simple;
	bh=lznB7FVQgvMeVhTR5kOqa95iCAQowa+Uzwnw++ygBOg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mrmM8lD2TVikowvvSwAKi9fyjzPLgx0Qc0wRLTJ9WMjp4fKYhed/Uvtb+m/ffSgXG5FOZnq6ncnTIohnYmU3UiVuw+PCRxq7f3PQsh3+qJ3zMglfs1K6+tcijl0A9soTFXyQICpRAr/jv8tZdB9d/PZoAjGLbPeHCuQmTmIds+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DT6H5I3sncQccJlbVtDRdM7BBjOQtCJbuEjdRYvmu9u6Q+9fiuYstD9AxQhSSkQ1xuzK2a2B78gEv1VmLQ9ZSk3T3ovx2L+zhxnjZtr+tLY5Tz2McPEB4hZK/Ng5+gU0YsBxyDAiT0fviTAKTItLDcJMu8svpbrcucdp9uNYlkxFOYJisEu0UNKdhNATAO43PIApx3u8T8ZzHu5Y3cTbfeBNEwdNXAIQFW29Zr09LA/ZhIedZ7NUl4ybghjuSDLcw7FVE5SU7YphaVOpSJP2gVZ/KOxZx0RqigIVSsVbgr7m/MG4adi56IXeDEqIbyZNdHyUqwC85afs1FWn78cwoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nL/kyFnXntE3T9j68PpVwkQEr+aAZFmUdtqPFJYsnz4=;
 b=imG5gzYr3Bti09v16sBIWSoroi3ixDPghjRCi1u/A2ZlZExiYh+KNjsYJ2k72juxO0eE7I3tVq2+GDPZbF/qxw2bAvBDdhBUHRJtjpGPO8Xejn+mPc8qTbmn1VyWzgcjzPVIcNGEOUJ2bBvVcvq9hVVHxlaof+WHCCMaNRE/XYRb0FvCmYTZO6C4aVeQXJ/0CNEROfB144mDErNSKIQVySuMgYjg7pmvL+mLn1CoKYiMRVlbnasXGAQdwBI0hmESO8Mg4RINseqvGcVqjbz29qTkUZzL71T2rTqdxh3evn/YZ5YDqwzOB6AMIsvtCsGSemaHzC6j5W7whgIOnWwaJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from SH0PR01MB0858.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:20::18) by SH0PR01MB0601.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:9::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 22 Apr
 2026 11:04:22 +0000
Received: from SH0PR01MB0858.CHNPR01.prod.partner.outlook.cn
 ([fe80::8f25:1579:34a0:8569]) by
 SH0PR01MB0858.CHNPR01.prod.partner.outlook.cn ([fe80::8f25:1579:34a0:8569%5])
 with mapi id 15.20.9769.046; Wed, 22 Apr 2026 11:04:22 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Conor Dooley <conor@kernel.org>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>, "James E . J
 . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Arnd
 Bergmann <arnd@arndb.de>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host
 Controller for JHB100 soc
Thread-Topic: [PATCH v1 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host
 Controller for JHB100 soc
Thread-Index: AQHc0W74yy82rVma1k2GvS7u9EjKZrXpvsgAgAEt5eA=
Date: Wed, 22 Apr 2026 11:04:22 +0000
Message-ID:
 <SH0PR01MB08588CCE01874CEC5FBEF0D4E62D2@SH0PR01MB0858.CHNPR01.prod.partner.outlook.cn>
References: <20260421091215.120632-1-minda.chen@starfivetech.com>
 <20260421091215.120632-2-minda.chen@starfivetech.com>
 <20260421-appetite-vowel-ce0837f5625b@spud>
In-Reply-To: <20260421-appetite-vowel-ce0837f5625b@spud>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SH0PR01MB0858:EE_|SH0PR01MB0601:EE_
x-ms-office365-filtering-correlation-id: a82f418c-da52-4381-1c9b-08dea05ee8dc
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 OU0avtj/0ktHwZPjHAAFwnW+f/czziW/iHBuiw1ZC6md0nrc3LqagMTPZnuXRBbu1lnA+pFP2nBb/bWNTv2CZqbEaD6aWaMRKSa3hyuw2plsYFw7I/Tb49OPxKO3o/rxMQQ5RdZjX/KITkjENC/9nA1DejMJtMvPGVgon0UpRnPtBahBl01Zyw2srmgejHjbY6UKp91wzH9xkcsQT9lSFcuOtrXLOblwMGl2d6Jv7t+GVhlYA+CAJgSyF9b8uKrhhk4wKogbOI5EkZiyLLT473kod8jhERtN+Mbe4EiQkAKEvl3rJ8Ep7q/ZEJPOcdL+HCEdvbMi3VCRWNHbrUnGoN+XVk5I4rQRYkJVCx8Up+KAOFHok18g3DeEXbK4JDTaK5sgdnuiVXn5bSAFoyS7ZAS2/dSSOfkYyJF4C18Obyn3r2DSiEnx9oduj3NMQz4qoOS0rO9dtij3wPELukiPQbZfM7vYzMKzyp2R+A8mrukzgCahWhDdjpGzcAJJpjdhDq4mx8UVbCnGSqG25K0T0GX4aJvBb7Tiv/Iq4Gxp1M02Mql5BzVg4opmywZgxHrc4jvFbdlAQS6BHhIYpEw6Qw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SH0PR01MB0858.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?VoKlTkTqFwlQjf2wlM3KvEp4UfkPkzsIjxZ6AI7Z48dg8utIkq361hjBmjVx?=
 =?us-ascii?Q?KI0s+bdNHQhvXqnfCujEQ+C2To6yR6Apqa8Ak9XhILOOAppX3NhQAhbCEWPG?=
 =?us-ascii?Q?ISBu6q0iANPG8S0qlnEMRSIVNE0E4PeGlYk7gRWCbgKFSw2v45f2yE3D0cTf?=
 =?us-ascii?Q?4xY/NYZdhsln+FD3NoJfT44b2ShrMZGb3mM0UmXb2BQm9tPZ/NayXslEgUXx?=
 =?us-ascii?Q?e1VgA9O0Pmnqj5sBqlSFk5kBUObrfIT/GVuEo2zkxco+47neVftXe0oDfeyK?=
 =?us-ascii?Q?AODumxWe1CcInau7zifPU/5y/uDLJv+cNr1FYJQ8wpI3BEQOpeQQOmEOi/RB?=
 =?us-ascii?Q?ntX1cMIkO+2p8Dr8UHa6i3FvwmlrMGgn/mbuo033GGBvd/RSycIkcNNh+Y3x?=
 =?us-ascii?Q?zDiIeLtW3XfXqaPNJDF6VSRN3MpX25xag0BHoxDN4GIAAWHt/BfMTJqmiNaj?=
 =?us-ascii?Q?nCO+faqKa/5pyGNq+fU6K7FP7bZsCjbjfX9ZYw3bnaXu9OWDfMClodyKHGWm?=
 =?us-ascii?Q?RfcAss50w9V52l0B1kGRR6t4M42GTgHliYQ2hI6xVMXXdPyjWRHJYHwwuiWC?=
 =?us-ascii?Q?sHE2mJ4VFxfKNOYL6Lg9/OknghY1BhYjWxngDGiDBwFJnGdEaYhWRxQZNfsv?=
 =?us-ascii?Q?zBpuG6xV2Uvt3KdW1vi8GE1ZDquNs0OUDX/hxx22XlIg6JuoTCfHYp9J/0nR?=
 =?us-ascii?Q?pZCQwGlrxvV/dgZ2SKhORnIC2kX4tFQQmr9ug9Lcx4gkMf5YTm8QuCq8tTwD?=
 =?us-ascii?Q?ftfFDbuBW+crW7slD0UcSP+bg6PQWrLhAB9wMrjBO5Lc6a3/97z9DdtCTTZM?=
 =?us-ascii?Q?3Tci7qV8c5mABF4w8szTGsE6IPOGCW0OoDdSxzp/eLX7FQCUhN5VW4n60Dt3?=
 =?us-ascii?Q?eEVHUDlD/ft9lNA2Ww9DTPUudR0he7VoccDqNhcZ6rAgpIDR1cto6fsShPHd?=
 =?us-ascii?Q?gkNROsjI5uaP/XqsID/QUuptmSZEMarO6zDf0o/8VAOCvisT9kjvnSj1xTNT?=
 =?us-ascii?Q?gTjpDEO4lVHzO5+0N0LOpGt204QJjBHz9IN1TT7RN62sUW5ckWAGaVUhVF/c?=
 =?us-ascii?Q?BQZbBGASs5TCAjii8DYK8DTo1hCsZAJxe/JlBGraj0EhnjiWjXdI69koy+dT?=
 =?us-ascii?Q?wbECGbMqT1gYG0b4DIXoV5iTB2Dq8gwpSrm94MnItrdfAaXOVrphMEjKso4d?=
 =?us-ascii?Q?pCuDg3dlnwIrjtVh1dtNR4+Q+aLFiZWXFOHYJo6g99xqkRnt6M+1VHYINY3o?=
 =?us-ascii?Q?BBSPMBTOQoLPUbfl2QCJGv+kx4Micfruc6tG9DenO+uy5m53wak3MBJIbLJp?=
 =?us-ascii?Q?KUda6kZSZgSe5JjGLClmc9Ncg9XLvny7cHVgwjC00X+sTRPU3CliHAUAC+BQ?=
 =?us-ascii?Q?TAXE4GagbamwOVBk6/8N5zixSvtMRVA75iOWDLFZcdysLk/7/lVoPYrumCdt?=
 =?us-ascii?Q?PNgUhVAO8Rl3hIDJl4sqEz3wlBDbTGi1VVlo6anQaNSDegOWo8mrT4zJ3AvJ?=
 =?us-ascii?Q?UMYXtz7FYFaxVxrO4ek+s3DvbxTjyuHdb7Yh1ymbvJv4O1un/zWAnLsJTDIx?=
 =?us-ascii?Q?mubCGiWgpWN0xmCMNp+JkOfcHkhqyY6xDKMNYXVluDz86sFuF0vA6e3NAIHV?=
 =?us-ascii?Q?mMy2HIafy2AoX0NhfVEKXYSURi64lfUYZm+e/Bz7AFXxt1pD7cJHLpGN/9Et?=
 =?us-ascii?Q?VCvTO679YdD4fs0NjjY/jypZesKgQBNcP7sAj7gGieOtV45Rr9b1bZZj+UF7?=
 =?us-ascii?Q?OaiH0FmytA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SH0PR01MB0858.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: a82f418c-da52-4381-1c9b-08dea05ee8dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2026 11:04:22.6655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R8TNqXYRofxmr/I3xRhN0AqNZAZy+u9s32FzzSHXrvQNB/LBnXfE0uC2tWnl1+5Tc3Er7XhXdc+jZ9+ux9dNUNGnPTa8MCVVapQTN08gmXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0601



>=20
> On Tue, Apr 21, 2026 at 05:12:13PM +0800, Minda Chen wrote:
> > Add devicetree document for UFS Host Controller StarFive JHB100 SoC.
> > The UFS controller is based on the Synopsys DesignWare UFS controller.
> >
> > Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
> > ---
> >  .../devicetree/bindings/ufs/starfive,ufs.yaml | 76 +++++++++++++++++++
> >  MAINTAINERS                                   |  5 ++
> >  2 files changed, 81 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
> > b/Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
> > new file mode 100644
> > index 000000000000..c408973dd0ce
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
>=20
> Filename should be starfive,jhb100-ufs.
>=20
Thanks. Conor. I see some vendors's dt-binding doc without IC name
because ufs host controller registers are standard. So I think if we(StarFi=
ve) change
IP vendor will still using the same driver files and dt doc. =20
If the scsi UFS maintainer no comments to this I will change this.

> > @@ -0,0 +1,76 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause %YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/ufs/starfive,ufs.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Starfive Universal Flash Storage (UFS) Controller
> > +
> > +maintainers:
> > +  - Minda Chen <minda.chen@starfivetech.com>
> > +
> > +allOf:
> > +  - $ref: ufs-common.yaml
> > +
> > +properties:
> > +  compatible:
> > +    const: starfive,jhb100-ufs
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    items:
> > +      - description: UFS reference clock
> > +      - description: UFS main enable clock
> > +
> > +  clock-names:
> > +    items:
> > +      - const: ref_clk
>=20
> Think "ref" suffices here.
>=20
> > +      - const: ufs
> > +
> > +  resets:
> > +    items:
> > +      - description: UFS main reset
> > +      - description: UFS PHY reset
> > +
> > +  reset-names:
> > +    items:
> > +      - const: main
> > +      - const: phy
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  starfive,syscon:
> > +    $ref: /schemas/types.yaml#/definitions/phandle-array
> > +    description:
> > +      The phandle to System Register Controller syscon node.
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - clocks
> > +  - resets
> > +  - reset-names
> > +  - interrupts
> > +  - starfive,syscon
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    ufs@11b10000 {
> > +        compatible =3D "starfive,jhb100-ufs";
> > +        reg =3D <0x11b10000 0x20000>;
> > +        interrupts =3D <105>;
> > +        clocks =3D <&syscrg 4>,
> > +                 <&syscrg 5>;
> > +        clock-names =3D "ref_clk", "ufs";
> > +        freq-table-hz =3D <26000000 26000000>,
> > +                        <100000000 100000000>;
> > +        resets =3D <&syscrg 10>,
> > +                 <&syscrg 7>;
> > +        reset-names =3D "main", "phy";
> > +        starfive,syscon =3D <&syscon>;
> > +    };
> > diff --git a/MAINTAINERS b/MAINTAINERS index
> > 32bd94a0b94c..3792c51da63c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -27190,6 +27190,11 @@ L:	linux-scsi@vger.kernel.org
> >  S:	Maintained
> >  F:	drivers/ufs/host/ufs-renesas.c
> >
> > +UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
> > +M:	Minda Chen <minda.cheb@starfivetech.com>
>=20
> Typo in your email address here.
>=20
> pw-bot: changes-requested
>=20
> Thanks,
> Conor.
>=20
> > +S:	Maintained
> > +F:	Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
> > +
> >  UNIWILL LAPTOP DRIVER
> >  M:	Armin Wolf <W_Armin@gmx.de>
> >  L:	platform-driver-x86@vger.kernel.org
> > --
> > 2.17.1
> >
> >
