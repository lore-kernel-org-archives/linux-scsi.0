Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011062.outbound.protection.outlook.com [40.107.130.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E7633ADB3;
	Thu, 27 Aug 2026 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841990; cv=fail; b=FJT+pNh13jJ9xJhm/yiurB+CEYNE0JLV+RExQPtOx2Ofg68nxr+GuUVE8aDJZuiL23fRs3b7ir4ygeOjm6HNBoOjN1SXWFvNALLzQilXOKNAIq+NCySnTXMd6WETvbx1DCeuiMK3dlx84HmQYtloMzoJql61GerMokvFqgrNoj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841990; c=relaxed/simple;
	bh=sgwLG/D/JoOjlltNKr6VIFQyt3YJY2wY6rdSy7Tn9xY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Aui0lYHNuTw4gOG4EWETNEMkibtPKQyOo7M9ETCX7jucYjFU3T6I94l8JeRTXCvSosfTT+77wxf4LSXIux7CJmwi89sudRCJ9BlCWPoTEG3u3BlXGER5Ug5vEWgxk6UXXjKwKUn7MO0OXMs4CZc8mUjycJxN3QQi9Ovs6tmHMtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=hGZT+Z7t; arc=fail smtp.client-ip=40.107.130.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="hGZT+Z7t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a94ncca1qpXRF2NHR7rLDo3GhYVtoElGAIT7xrbiEQoVCT63W2uiIy8JFYhMA2wsCLEGJQ1+ZiRoqt2Yd2oUxsFvYoiMpJBGQ0VOzmFDxTNtarAuP5SL5hatEDv/y36U0gadlzr8bNbGApLBmIFUjbTITStu2CMwioMUrgaJrbM09gdMQ9ZYV3Vozh3trhoDxZA9SWMDBm8BhwEwE4F4XQ0bkJ1LdPFLmijzAuBJLeeEFiIT7B5ERVKgMPUo941Sc8MhcftYvWMtGEUCbVFSqK4gx0AbuXzV4n1pjsS1V0aMiPdVuHduWYK69rMj+qeaoT4LqxnoxryXBQLtm2esJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqzHX3PjvaKGiG9oZ24IXsSCpIlD3GTPoZV7PmlD7rI=;
 b=GnvGWJWa3wTJURCEfK/S+Id8hnzZW/GOQGhOHYUXpgaixiOtjVZ+sjg1Yx6crilg4N+ZtUVnw2CIUpuGF1hZmPj38Z9VdIVojATDF5R20VimfoOoICb17t9hnPIC4GmyLCwsbh44WPzmIMVGP4umN7tW2VssHjtobZXm/bJWoDcrAeMnrUdBCK4JxyPzmBmYi4ALuNDEGZuS7oK8ggw/CmrhQdpA5uMTJhOioYGkUwsJt+hYqk6CB3pLtKe54v7yYkXlmDM45fg7nTcoRFNG7mLMBL9CB0V/4/PeFpOqK+bRUzJsE8RvjPQfnrrXBRb964iNY3Xs+RPYLTWKFCsUhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqzHX3PjvaKGiG9oZ24IXsSCpIlD3GTPoZV7PmlD7rI=;
 b=hGZT+Z7tpJROWu6/UAUjr1rFMTFVEC+hyDfmKou2qccWlo9UeB1LnR/6l7/4k2laJGKt4+izkWUtrRzSpPctJdNrDx3ivEqP5KRugTgZQSwmFklXZs+dI12Mli4feI8YhQoCGlDcfdg0xn2VvG/5gknV08jtodh+w3TRFvYHDQGA3gE0jL5CwU2YpZLQWvi2oLL/tg1SM74ZHjepf8kJ5SNJlcbewElQILCNRFFZWMHXfEpL5MwQAQ+NtJfsHG4xi5oR9QgY7HkRCAG5pYq3HNjOIIB5h9hvuPOF4pArHzQQ6Z2bZ6n5IZiyrWD6wVDONQLlPfzD33ssNatnQboyMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by PA1PR04MB10817.eurprd04.prod.outlook.com (2603:10a6:102:485::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Thu, 27 Aug
 2026 14:46:11 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 14:46:11 +0000
Date: Thu, 27 Aug 2026 09:45:59 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com,
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 06/10] dt-bindings: ufs: Add compatibles for S32N79 Host
 Controller platform driver
Message-ID: <apBNp1ybnHsNrHSL@SMW015318>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-7-larisa.grigore@oss.nxp.com>
 <ao75lU2zYDeOZi2f@SMW015318>
 <ccacc3bc-7f81-4363-a273-a6076e468618@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccacc3bc-7f81-4363-a273-a6076e468618@oss.nxp.com>
X-ClientProxiedBy: SA9PR13CA0178.namprd13.prod.outlook.com
 (2603:10b6:806:28::33) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|PA1PR04MB10817:EE_
X-MS-Office365-Filtering-Correlation-Id: d475b4d6-55ef-4164-434e-08df0449ef7f
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|376014|7416014|1800799024|366016|10067099003|56012099006|4143699003|6133799003|11063799006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 GEoqqsc7FCzhDFvzXk3gtCthSTgIkn9jrsBYQi7Z5O5Xb/YVs3qbUvp9k60cnDred3jNFCVILV3V4GIVfmF/fFsaC+l1XSxgEhTd57JVyD+nLKbMGOLgE7tMjpiwLw/Zo2X4wXu9hG+HW1mFhmTTlazVTdep10bZ3q3oN4d+ij5b4uRc04O8hSJh51WaGFesLwf3CAyORB55NZ+tCdaq5RWNyRZ8B/cN/wgLscstdKqTEFYnZ6GD+nQljAQNj0tjK1Gg0EyKyLGhFKD6fJMs16fk2hdQrz8MvvcLYqJngC9RSDuGUiR/R0pfHmpWzWXuMXegIfDLgcIOFgN+/XFv9ApRfQazu3OE0TyxAzeBefXubgoeq0DhNGOxRATF7CluylO2lCBsF7/hQbeIpnRzUlBr1exuwfxNAoqFemphUFYZ1e8PhN8AfnjNrxTrRM5SHGkW8CBSt1ULHMnprgFdqnHSCTvjXL9kH9PqLlCK0rvFeImP5xBNa9Nj6RDHPt28L7bBBZnrIDgwDd6IoPRnUM7wWOMq4XF7FOPX7IGHvL1MXH1ZDSwGuZUqw1GRgvxRthLH6C4q0znYEJBupJqoWwbi3whwbUz8Z0ZLMdIDcmtVGoHRFFuTMv1ZTUFa2Pl5
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(7416014)(1800799024)(366016)(10067099003)(56012099006)(4143699003)(6133799003)(11063799006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?kHYV2sMVG9r0PwAKxwg3mYOL1R8HdKtsar4h4Vs11KJoyfQIkA/8CNl176Pp?=
 =?us-ascii?Q?X6sGgYdX3s6Jg/Iil47UPp4xEmP95w6wUnpDFOit2t3Fz5TSpG+nGVfkIu4F?=
 =?us-ascii?Q?JQew7hGslrIw+rFFTYF9CVIOkzUWWMYutQkI2AoblLsXc7aTYeU6XvP4Pzp7?=
 =?us-ascii?Q?1Kn8o4FX7D9/OkxyBi3bZRI7r7i2ci9Llkzr2GI7t0dSus/iGj4xMPY4Q3HZ?=
 =?us-ascii?Q?cIJuw4lPrNGs2UXeSP48snphO/Vl7Mmbj9FQfn1c83p/MziWQnEqN5STqwbr?=
 =?us-ascii?Q?5jd9G24IYbhptvGZjyMBdD+Gw0eY9QPu4dnTdAFS3LczXin0bcFriPrnOzK4?=
 =?us-ascii?Q?hc/OVtVoK2mAPSX2lEA5UgiYekC6CXA1XqbUCZlQA3HVR7rewEM88GehU+hy?=
 =?us-ascii?Q?vYUEII2smM24cMjs1j5Ml7Eas1iEbBrVQBgwK8SJJjIeVAt4Tk2+wayHCC6L?=
 =?us-ascii?Q?rsLcDpYtY0rScf+BnDe8W8ukkCZgk3/vVasntwZxb5mDkB6fWgaXsDPocaGA?=
 =?us-ascii?Q?TKnpUrjelvwIc49GZN3E+5gGxHgLwNQwpmPvSMBwuycJ4BjRZZSiSJF5vC99?=
 =?us-ascii?Q?tY1IVVGr3c/HiI8H/RtimceH3TZEzZxpyaHO1dA3RxP6+72u1Ys8GiVQyHGS?=
 =?us-ascii?Q?75DzR92wzke2Dx70WBwkdowOMCRnq/6SZJOjHukEcW1AqYw1jZyOQepzxSEF?=
 =?us-ascii?Q?EyXAZd7VzgR9khuzK2Zzd+Px9NH7dCTNBTw9GuQJTlpYF0C2Jejuksy5Q57h?=
 =?us-ascii?Q?RXqFgy3fIDGiyT0vHU9aw7WuuI7C3qVMcmiAIDF3/Zw1ykIIF5OAiQlHmlbQ?=
 =?us-ascii?Q?loKOdf2wWzvnbleT6kkS6iyBRWSaXMnpDxC95lfhOtdaBGC/4VE26NcEcfjx?=
 =?us-ascii?Q?4+rK8C01WF7T+kXmjFEErXo2Q3rXRmP/gyWaNund6DsdtJWyxLKAmt9JouIh?=
 =?us-ascii?Q?ADE9LZMyQnZxY30UnS3u8/Yoyv7f+yZN5+mAiwwmmA9iqzyVZyP8mWnIxf4C?=
 =?us-ascii?Q?vX9ynsMIgeUmrb8eGUd3bW3pa6+n1+JSso00RKHePmFllI7Ayc5/+bXDGX4x?=
 =?us-ascii?Q?uqG9Vh7REJl2BHm6+LCVYpsQb/5oX4nWp9wf9d1OEFo0LwX8CpsOnZHp0wbi?=
 =?us-ascii?Q?as65D4n38QxOs6JqBFAGnW4mCSGgiTBCgzorB9rbwTE57cSfyqp9e2tPKVu+?=
 =?us-ascii?Q?p0V9smE+oJA4dunls1MHKSuR52ZXdmKGIHpo9NgyqAhVStyP0HG9E0ieR6TQ?=
 =?us-ascii?Q?UEXgvvAok737ZkOLuBIiyY4fVbTtQmSrV0B7jZuOg19zWjluRGy+yKuLx4Cw?=
 =?us-ascii?Q?gb+PEn3fxq5VikKaOfwfSqn8yg+jhE6F3b6UHZITdlv8jOjzOZDraTFHvot/?=
 =?us-ascii?Q?hzr19PnIyK6Uq0PuwuXeFUkg3/V0bDDJ9Z5Mk8tVA23tHzzZns+ZkZBGT6qJ?=
 =?us-ascii?Q?3KzsFKz6tpdfjnIuomqsjt9FcgBCYLVZ5wBSEIcHEDG33q/kta2bBkPE2iw1?=
 =?us-ascii?Q?tNqqw7NVZIwP+jseKCU64Tj45HyOEdTesy/AjX0Ptr8rXTecfW+RZd77Cgfg?=
 =?us-ascii?Q?MfKEGVPmVz1/f28v07WFHuelX7k/gm5Ta5QJIeUtZKIIXpPEXQaYF4mH1s9X?=
 =?us-ascii?Q?oKI62vVouoCIHQWpu7xfgZ2swaQOsnWNnbRyO9jvTtBDuI8WhDSos9TR4l3o?=
 =?us-ascii?Q?W/tXbPt+qWD0RovMdcuR6+mQxOlCs3IYXA9VY6aq5vkrFwbPkohL42S2YwJu?=
 =?us-ascii?Q?dJVSdnLe9dbcIbBkUXomkklSWS7Jl3Q3auQkT4/MtWzIeJfF2u6M?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d475b4d6-55ef-4164-434e-08df0449ef7f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 14:46:11.4806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJLHFjGCnVcj4wE3PBb7NEYSsi+0Z6vyFuF13ulSuoj6nYc3Sw+s5xc8N6/ztG8N4q1lopInl9s23CUPECt6AyGpKu9Z0w3DrETheQVqM8liNaYD8XZdOua4s9Z+i8Vp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR04MB10817

On Thu, Aug 27, 2026 at 05:36:27PM +0300, Larisa Ileana Grigore wrote:
> On 8/26/2026 5:35 PM, Frank Li wrote:
> > On Wed, Aug 26, 2026 at 03:40:44PM +0200, Larisa Grigore wrote:
> > > [You don't often get email from larisa.grigore@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > >
> > > Document the device tree binding for the NXP S32N79 DWC-based UFS host
> > > controller which is compliant with JESD-223D "Universal Flash Storage Host
> > > Controller Interface" v3.0.
> > >
> > > The controller requires access to the SCM register block and the core
> > > clock rate when M-PHY initialization is performed. Add the optional
> > > nxp,mphy-boot-mode property to select the M-PHY firmware execution
> > > environment.
> > > Currently, the M-PHY firmware can only run from ROM. If the property is
> > > omitted, M-PHY initialization is assumed to be handled externally.
> > >
> > > Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> > > ---
> > >   .../bindings/ufs/nxp,s32n7-ufshc.yaml         | 99 +++++++++++++++++++
> > >   1 file changed, 99 insertions(+)
> > >   create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
> > > new file mode 100644
> > > index 000000000000..d9d5669be313
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
> > > @@ -0,0 +1,99 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/ufs/nxp,s32n7-ufshc.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: NXP S32N79 Universal Flash Storage (UFS) Controller
> > > +
> > > +maintainers:
> > > +  - Larisa Grigore <larisa.grigore@oss.nxp.com>
> > > +
> > > +# Select only our matches, not all jedec,ufs
> > > +select:
> > > +  properties:
> > > +    compatible:
> > > +      contains:
> > > +        const: nxp,s32n79-ufshc
> > > +  required:
> > > +    - compatible
> > > +
> > > +properties:
> > > +  compatible:
> > > +    items:
> > > +      - const: nxp,s32n79-ufshc
> > > +      - const: jedec,ufs-3.0
> >
> > Any place actually use this fallback?
>
> You're right Frank! I will switch to `jedec,ufs-2.0` in v2.
>
> >
> > > +
> > > +  reg:
> > > +    minItems: 1
> > > +    items:
> > > +      - description: UFS Host Controller registers
> > > +      - description: System Control Module registers
> > > +
> > > +  reg-names:
> > > +    description: |
> > > +      Names for the register regions. The first entry must be "ufshc".
> > > +      The second entry "scm" is mandatory only when nxp,mphy-boot-mode
> > > +      property is present.
> >
> > you already us if - else branch to restrict this limition, needn't
> > description here.
>
> Thank you! Will drop reg-names description in v2.
>
> > > +    minItems: 1
> > > +    items:
> > > +      - const: ufshc
> > > +      - const: scm
> > > +
> > > +  clocks:
> > > +    maxItems: 1
> > > +    description: UFS core clock
> > > +
> > > +  clock-names:
> > > +    items:
> > > +      - const: core_clk
> >
> > Needn't suffix _clk, just "core", generally needn't clock-names if only
> > one clocks.
>
> I will rename it to "core" in v2, if that works for you.
>
> > > +
> > > +  nxp,mphy-boot-mode:
> > > +    description: |
> > > +      MPHY initialization mode. Defines how the MPHY firmware should be
> > > +      initialized and executed during UFS controller startup.
> > > +      If this property is not specified, MPHY initialization will be skipped.
> > > +    $ref: /schemas/types.yaml#/definitions/string
> > > +    enum:
> > > +      - rom
> >
> > why not use standard "phy" property, if no "phy" means ROM init it.
>
> First, apologies for not including enough background in the commit message.
>
> On the S32N79, the M-PHY firmware can be brought up in one of three ways,
> selected through the SoC's SCM MPHY_RAM_CONFIG_STATUS register:
>
> 1. running MPHY from internal FW ROM,
> 2. running MPHY from a (modified) FW ROM copy in external SRAM, or
> 3. running MPHY from a FW image in external SRAM.
>
> `nxp,mphy-boot-mode` was introduced to select which of these boot sequences
> the controller driver programs. Today only option 1, "rom", is implemented
> and validated, but the property was meant to leave room for the two
> SRAM-based modes.


You need define all options in binding.  who load FW?

Frank

>
> Given this setup, what would you suggest as the appropriate DT
> representation? I would greatly appreciate any guidance you can provide.
>
> > Frank
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +
> > > +allOf:
> > > +  - $ref: ufs-common.yaml
> > > +  - if:
> > > +      required:
> > > +        - nxp,mphy-boot-mode
> > > +    then:
> > > +      properties:
> > > +        reg:
> > > +          minItems: 2
> > > +        reg-names:
> > > +          minItems: 2
> > > +      required:
> > > +        - reg-names
> > > +        - clocks
> > > +        - clock-names
> > > +    else:
> > > +      properties:
> > > +        reg:
> > > +          maxItems: 1
> > > +        reg-names:
> > > +          maxItems: 1
> > > +
> > > +unevaluatedProperties: false
> > > +
> > > +examples:
> > > +  - |
> > > +    ufshc@4ac80000 {
> > > +        compatible = "nxp,s32n79-ufshc", "jedec,ufs-3.0";
> > > +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
> > > +        reg-names = "ufshc", "scm";
> > > +        interrupt-parent = <&irqsteer_coss>;
> > > +        interrupts = <211>;
> > > +        clocks = <&sys_clk>;
> > > +        clock-names = "core_clk";
> > > +        nxp,mphy-boot-mode = "rom";
> > > +    };
> > > --
> > > 2.43.0
> > >
> > >
>
