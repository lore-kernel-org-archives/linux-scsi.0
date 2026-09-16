Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011063.outbound.protection.outlook.com [40.107.130.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A2F3AA4EB;
	Wed, 16 Sep 2026 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576496; cv=fail; b=k9odkTz57BA5fqlTFyP3d7vmiZIP9Rf79txjI9l9mNxIhUeVOsn47081Yv+Ug+3T9hzpRMNMbNiKr13wmFjxnKQ53PX31uk40dsOJplfWi1mKT1R+lN3Jf4ftfBDSKW4Z7LSnX0Sfu7uK33WD7f4X2+waJRFYVPYB7fjtHokT3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576496; c=relaxed/simple;
	bh=KyGkYwf9z67xloXodaYmnHEIGFl9OZUkopmxgjAXbmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WMsriMWB6nTnYjW/lHZygbXQlV6zJ08SgcDMaLNXG4S2VIVLv2tE7FDpav/OVk6A/3VokxFyVD+l+0vsopR00A5KuUWDZZ922suXbMBHtE6R0640p8tZ3JpVZvQn951RcBqkZLOQRbR7xpPlF/hv//FxfzuYWroH8LGcKkpT+08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=aOHqwQ1N; arc=fail smtp.client-ip=40.107.130.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="aOHqwQ1N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfPR330gft/kPYgQAt+qWFDG/ZkEsFaeWYXW+qeFPFZV6odFmvFPtU92qcp+U9XcTVcw29KB8zscOP5+UD3GOk2S5y81SIK8a2iocWgje2b1hdsU5RVbZcO2ik9iY1161uQiNmi8yoVpzTqtv5YhO8CgN2+YOZm5M+hrfanPLpv3daNVvw7He0P36Fb7ERzi4bgd5hIfmsO9k0hybqesIwZ3Ox74+IxzGGUThDhqA1uJVHCDlux2j7qebYG5BDBGOlmhDwSwGiIFMH77pXsyrmyR9zTXybfkyunfYTDaEoBQtfCtbg0dCXlfHrvGdYZnCkKvFVw2DzMsSoK9XEY1hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nKOoaZ7t5T3ebmbmfmEUPXanm7w3XGHxIVUUzK4z2w=;
 b=kXWRO/0AiAzKhCxCZ71kP3QlHMLUkJvZys3GGtkfumiQMOyQjRsHBGgFEfyZq1R7f4BBO0rZ+zk6EdNeO1Q9HZAgQl7ylNW1VD1B7oJWce9eV9QmRrU8CNDBQMacncx/oUgY+UHAiFUf3i0RWkAlKuqpMU0HiI0lw6dkGU7JZUr2gJcCBSyJeKKBTOcZ6dwrnoAGmlTpG6NgnNSUSpf20Gp8DOWlka9tGbJnJev4CSiyusPP9XoodaOdX6eOhfO0xdaIqOMmlkOgOgmDfaO5T371aw3D2dWX2HdwaUWaf8gDD6GckLiNEI67TIuWJKr1qB6Pejm7pt+tenl8f1BJpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nKOoaZ7t5T3ebmbmfmEUPXanm7w3XGHxIVUUzK4z2w=;
 b=aOHqwQ1NI9Sez94Il4Ynvxgg4DqDuW2Nfe/0Xk05IPHqkQYi8H7n3F70gvbwPUh5zJJEfo7I9W2fMbYnG5QzMISIPtir7oL6Gqv+c8Y3RYiA5s5ZI0atev8UHB7XUDaXMYesCjBt/0GA+0aSyAqjLJ09rRPVyEdHZqtsrUVcrq/d3dFXkuhmdJem6zz6lnsU/R0nObD8Ljg4/RkjXZJ0YdYyGcQValuWDCVqVLr0U088/7LEBFu5RBiN8ACzdOXOBrbP9rXWS0zhaGfQb5isLnLZd7MBTKihYiaheSpXGHj2ru2Asboomrg03gRA4Hc8NMHd0FndJP3rzPKtqQJvng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DUZPR04MB10063.eurprd04.prod.outlook.com (2603:10a6:10:4af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 16:34:49 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.012; Wed, 16 Sep 2026
 16:34:49 +0000
Date: Wed, 16 Sep 2026 11:34:36 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa =?iso-8859-1?Q?=A0?= <pedrom.sousa@synopsys.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com, aruizrui@redhat.com, eballetb@redhat.com,
	echanude@redhat.com
Subject: Re: [PATCH v3 06/10] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
Message-ID: <aqrFHDFd6G5wPVFl@SMW015318>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-7-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916084411.941297-7-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: CYZPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:930:a3::26) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DUZPR04MB10063:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e4aee57-6c1d-49cb-6411-08df14106ce8
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|19092799006|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 bhtoGiyneFDtbcJhWSppxGUZ0LZMVaPLL7lfXa0AkomZvGWGwtCJpCN5TW+BX13J+c+2SIuw6azxhNvviXS1JblFHpkikTs+Dca0Key+eAyzOw1K/AVh02/0Oqjv5N2UJAw8zi6TglwLN/V23BGgYtCb9saFw4dciAk4R3nwT4Gnq3LJ+dl/hhpecp4Z47LQi5UHRBjA7mr6p7fS/mmnIz84dR8FpKxkSL3HnSFyl/imSdbIeI/jZhkD74se6pbsFEgEUtJ7RzN7dJOThaIFQh7VX6PXKNMrnr3m6mlB5O4Fp9QJufxJi5hWhm3igpv/ALGi96r1u2UPZRgNbL6LiLOOkAPMyV5ZLvfn104VWqj7Pol1qEhSpCaT1B/FEBlJhZir1nisBYsctxfgvSuaP5ABjbKcqiMpCVoQeZnwrIdYG51dZWTZJWc9fg+jlkdOsVCDFdvqGq9nVFyemTYYt8zNxAKTt2ft631+oUTAXKXdAbb//EgcxH6wYZmZqkhKaHolLznvm6Zf4ZvFaiXfSWdFt6av4FYr6gFN34PE1TMZi6EwmMoiesF+RLWovLV2Vau95gxbr1S2rt3y5JU+lA3EC2pxfnO9+p5ajHs/sv1amHcxhB81jrJb/ELGER1N
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(19092799006)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?mnap/f2gmZMa839Gyh9b6PFXrkUDDT6t1O+aSTQq9aVKd/IDRvMTM7O2muLH?=
 =?us-ascii?Q?6OIwbLuEoQSIzAeXCOhzRZQ9nq5daRItNQj2iaAjsGWypQpyR1YBIOXgF1yC?=
 =?us-ascii?Q?CYSkOcf03QGdNJ2nNRFG+3YREpbUwuusuMmFyvX0+F3r2aQSVvO54zdtIEVF?=
 =?us-ascii?Q?2ciJmNksAoss4bH6LNw5WfkVpHrFtSsgSF9Nn0+zBdF3hbk0wLkARsGEzkJR?=
 =?us-ascii?Q?Ft+idk0zrcL/p7q7mc4FN1fyoQ7hTdCVXSZFnFm/s1f2kp3pwiqdyDgueUHS?=
 =?us-ascii?Q?3a3NbFEG+JrA+5CtxkHFmoo1QgoyPPc0iOEChlPsI8pQ8t5o4gSI5jfgExTZ?=
 =?us-ascii?Q?h3dubKqDjuVZgsyCEwTRcP8Z6CtiHEDCg5anmQAL2IAqVv20upbyV/uC0REG?=
 =?us-ascii?Q?8yC0VMOg0duT+cJ+IlIZ2620deW0JdgsD+wXJWGN7YEFujmWwYi09iJFtdbR?=
 =?us-ascii?Q?zDIoDp9x+X0kfMsMV6JR1w08HamCF10dsTUiqu2zNF5uzHaAjw3zC8HI/vOu?=
 =?us-ascii?Q?p7XRQdde1sBw15BWKsDxet/75YjJIhLyyNQqNjJYGXHakbKUdtuFf+KtupkB?=
 =?us-ascii?Q?IWo7Vb4L68YyDG9XGOZa9Bh+cHq6x7Drv8MMOl27olicKOk8vjjV1ojWA4D7?=
 =?us-ascii?Q?KlOXYU+BYckY+jyujfZI4DDZwWQW2XiZd711LB5e4r8YcWSrlZ6JM8AfS+xA?=
 =?us-ascii?Q?khUKm++p4We02d1gyeojdhSdSf7drrl87gSPmUg0KQ31NW9Fm5MmddO4bEZ9?=
 =?us-ascii?Q?oNRaf/P/MYwDA7DEwb6vr18qW6W6NMVGAUH1AOl77Urx0y0fZcFFZtwh6Tp8?=
 =?us-ascii?Q?Ns+R+ErVkQY55SWggU+XiqlgeUf3wBe3tPOWML65Jrd25MT9GqA6fNreX6wu?=
 =?us-ascii?Q?7i5c/V9ygL5zCvJeMofYkAJ7Th8sPjNhBTTJDPey//Z1a3vHX0HKGW0P+dLx?=
 =?us-ascii?Q?sIrHv5LDXkr4wAQ6CqrBCR6jSd/gCdwC8JqzWIbz+l1v/6rrkqhbv40nYQrR?=
 =?us-ascii?Q?PTqagcD5RfHBF0Cj5x1qf5HoMZPYcMgZlIK6X8Hgq3wMgIhD5TjcgNum5XiG?=
 =?us-ascii?Q?sc4l2bxIc8JMD8QkKzyd7qy5tj+NAGP07dDIJTlzQbE+TTiT1QyiVj8uQJvJ?=
 =?us-ascii?Q?UrbH2AN2ITuu2wek3PzQnoBF89zGVND9D4J8TwQ0YMNp2or0g0wE3mV5NXxr?=
 =?us-ascii?Q?QaOSusR/ZjZGH+i0Djpn/kSzeMe2Lq0qNcr/+QPR/PLUq0D2S8b3ryjyxbFb?=
 =?us-ascii?Q?81sUcD71SmiEtFmwcw6wLGEexrk1gloPv4RWflAK8U0N9QU+EjDGBdduvuSh?=
 =?us-ascii?Q?+ySGI+v/X6vZrJl9qG1LFi3ztiJsxltujiqJTtFqEWPpDAbYz/m7d8Zrd0ia?=
 =?us-ascii?Q?bIvzBOcKrK+7lcHjKYBaLWHoqpKLVjJMgOoxLOihXLB3bjq5Z0PAPaGRp1Nz?=
 =?us-ascii?Q?R478WlGvz8QG7avL49LlQecRF+eMxTGChXA3psWMsn05JOlmKhdfpRIq1LtL?=
 =?us-ascii?Q?n+Vk6TmBmxCQWo2DlURXqV+4v4IEAH5iORHKll/7JdvDht6vybQ2yQDr+3EC?=
 =?us-ascii?Q?QFInf4nmQadPcBIAPQSfuSzApj11Z4ke/LXjs94f8XW9XPA1qyGR2Cv3yeq8?=
 =?us-ascii?Q?Gb89OnnF76i2qCNFGr0MVQlqSkjrMxNGRSSOirl8zR3QsMOmOrPUkVEXCnX/?=
 =?us-ascii?Q?YNIEUubVnsZUnPERsokQc9qM2CSujpJPRvSslvSY1/0UqfO5pJD1XQhcDJlC?=
 =?us-ascii?Q?cNDfXx/H4U16TlhfED3Atg+yFp+hqozKB8HnIfHg4S8ZqiWVVYte?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4aee57-6c1d-49cb-6411-08df14106ce8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 16:34:49.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pl7eFiN/Nc5ILLnhhc+akDL9pHL3+upwcg+/pIDfMW++BgY++s+EAjOMLtJKMpo/kHBbEaoGMdyvBIkXzDF6BEjcrsVjIVy3gsui7qpo6Tov6NqEo+eq56ImE741kUjL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB10063

On Wed, Sep 16, 2026 at 10:44:07AM +0200, Larisa Grigore wrote:
> Document the UFS host controller on the NXP S32N79 SoC.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
>
> diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
> new file mode 100644
> index 000000000000..2bede50a9b6f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/nxp,s32n79-ufshc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP S32N79 Universal Flash Storage (UFS) Controller
> +
> +maintainers:
> +  - Larisa Grigore <larisa.grigore@oss.nxp.com>
> +
> +# Select only our matches, not all jedec,ufs
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        const: nxp,s32n79-ufshc
> +  required:
> +    - compatible
> +
> +properties:
> +  compatible:
> +    items:
> +      - const: nxp,s32n79-ufshc
> +      - const: jedec,ufs-2.0

I have not seen driver parse it even though other vendor use it at dts
and yaml.

leave dt team to comment it.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
> +
> +  reg:
> +    items:
> +      - description: UFS Host Controller registers
> +      - description: System Control Module registers
> +
> +  reg-names:
> +    items:
> +      - const: ufshc
> +      - const: scm
> +
> +  clocks:
> +    maxItems: 1
> +    description: UFS core clock
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - clocks
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ufshc@4ac80000 {
> +        compatible = "nxp,s32n79-ufshc", "jedec,ufs-2.0";
> +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
> +        reg-names = "ufshc", "scm";
> +        interrupt-parent = <&irqsteer_coss>;
> +        interrupts = <211>;
> +        clocks = <&clks 0x92>;
> +    };
> --
> 2.43.0\
>
>
