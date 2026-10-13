Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013004.outbound.protection.outlook.com [40.107.162.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9095351A140;
	Tue, 13 Oct 2026 14:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901615; cv=fail; b=XIlhyh2Hqw5cC2Wzxr3/uiaW8JJqMgxEPDaC5PHn5fZjCzuwkYN7uBe73oy4OzbowT1fTA4d4xgZB68vRbNQP8f1NeID2p7XDdH0SjCq0WuVod9WJfqW/iUD1h7dL7aSiK2Co19SIlheHb75eQ4IQvEqJoSmoyKIskcOjiYPQzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901615; c=relaxed/simple;
	bh=XyqzKNRyKc7Pog3etKQhDA3OABeK4UYU3pmFBVwDV1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o6lOhCOP6Y+5BI8J6Me5Tay2c2SQPg/sjZgATSrvugLBIZl3oninNG5FXbIc3qf6zvn2WfxiuBddYoEyr39z7w9rXsvaGA27qKSoD512Xs4q7ADv/LA0eJ1Zi+V78AvL2lhoMhnI3F0s6iaQuCypn+lDkl1QyJWaP5WxfG7iIjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=BihwXb4B; arc=fail smtp.client-ip=40.107.162.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="BihwXb4B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kyk88aQceW9ba+Xx4WNMJGKif5CB3uuN4Fa3TDDMUzNAg36AB4/N9/7FXLvfDhGVG0UNxSHpUmFNJP544L9Q4PUGJnnv5XhVNFAyaEh/5FnmF9QE4uW2S3JzT0Nf9jHCJJD7VdXJiCbUh8yLBRwUxF1k66qahNI6VAxKQakUHzn88l7U0Arg6wKxjQKRw82GyYCRRbX+rmVm2IhiyomTZlVC1SwgudmH8THubzfg1hoj4ZMrbL+hTVvvNyIJvR1ZUVG02IITA5VpbVkL/D/dN5EYuMN+WOM9vXYK1NYoWnE6q4K6xj2UgmScOou91PFgFI0nueT7hqQpZo90Wfjn+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwYrqLWnFJcJohC+cPbikw1CYQn+xvuGaM21oYGMmIM=;
 b=TucJD6cHVX06oFbaqO1Eh4KXsExDiDh+oYeV0AgfiSRqxQFnvX83Tzf7eloSmC3fPAACIVd7Qyr+cScIxwzqP9CO0IriHHJzrxPCVvqOMLWAJo1nX/MWuLNbFwajVhqmxum9EVipiKK3+E1NVaiG08RU6ESI/7BXYw/9P2Ljni3nKtNz00HKTJjNAkAN6IP5sIl4HVfFQ58HXvqDi6kp80MrbiYpdAZcnk9lBjA3lvP4bw9pRpjSJCXdknwrhKcd+GjI9nVvd1Y09+3uHQZo6k36q9ekGjIhMKyy3dp6vCuosECMTCnLKnA3Jjlchh4cRMbBijZ4ZdbHfuR9IzlCEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwYrqLWnFJcJohC+cPbikw1CYQn+xvuGaM21oYGMmIM=;
 b=BihwXb4BMqHwnPSGs/y4ku9ioPKhZ0Uf9cquisFbWcMukvOaC2yqxef4nqZ1ELwOifmkeavQPRLEMk2V3bdgWAFR75rTQARLQGWbXBdfMUXWCupw4tpp1hJmkr/dTZ4L+P3+WornNid1ht4ec1pE/U4Ryj14w+CrEGGpMoVowaSpdkt5InAYK9udpJQv7/WO9nRmfYCoK/UoMYVt8YJKq+xrGd7V1J01M2cavdfyhjDedfkPnD1j50RWDKUZNIRPvcdEoUwTgom0cB2nsGUwd0UiInMrp7/7yHf73oKqmKmO+9m7eVYsCkH9a4RFyAhWn5siBsMS6Xt9XNNSM4ey1Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AS5PR04MB9755.eurprd04.prod.outlook.com (2603:10a6:20b:650::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.19; Tue, 13 Oct
 2026 14:26:49 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 14:26:48 +0000
Date: Tue, 13 Oct 2026 09:26:29 -0500
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
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, clizzi@redhat.com,
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com
Subject: Re: [PATCH v8 07/12] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
Message-ID: <as4_lVm9tvTeOkBp@SMW015318>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
 <20261013103003.373156-8-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013103003.373156-8-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: PH7P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::21) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AS5PR04MB9755:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eaf8992-9a49-4d63-e380-08df293603bb
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|23010399003|376014|7416014|261009223027099003|18002099003|22082099003|3023799007|10067099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 C8Q5vDLdmUxbTL7SxM0uPL3a55qzr2dolTHMo2mh3IxHdU3n4X6KhqzGCvzAehs198UCduyg3CoEA6v2qArQx21QsH5F4iG+Xx75VLQ2d4HSnS843jH3sUSKdhlraUll7BK5vni6JnqIbdk5ABEurrtkK1ktPyT1fUus2789T2F0beEhjfwRWP9YOPC4oksdxXMuIgwaGHheZeQOP/4yFnuW98yEEkYRiiwndqpHT7FwudtC03ejMjXBdCjTvz/P2MbW6orM+pourfZ8bc0iEZKNSH5Lx61+bSnP+yWPuu2UuwY5ZKCHURkhmlSWxEfQwGWSpoigdyrYmI08JsRyS9fZC4XPbHcudlXMoKO0p4MNVKET9vTZIZvZmriJf8oFJLY1Rvu/2jNrMacc3Kb7mjkumu0+aQM0ifY+05Fir5oJkKg58RkqtSwg6sjGEm8UKVAzYnLqt5jCv1cOMoBWvzi+VcKWZVjg3zgICiaAbtyznSjaoXgR+Yi7+lg5vwYA5Huuiw6oGv82TDHhASm+NKGU4UH3VbvlYZjAAAvdvw4WspdR1zm8x5B7i3Afpq734AQIXyyELVFlLj6aMeaKTzqjsSyzsF7kyUhf5mqnH/UofFcBe9fCyXmX8+ySwp3u
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(23010399003)(376014)(7416014)(261009223027099003)(18002099003)(22082099003)(3023799007)(10067099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?rtRRsIbl7zuF/MRarOau1xrCCTVK/a3eK8SZnMxA8W1E3btgWr2zdS3mOhjG?=
 =?us-ascii?Q?mooDUTgvgobDngT8oUGWlqt7SIi3VoYHAPzzworOHRHzhP9N+VgcAj/YnDjQ?=
 =?us-ascii?Q?gkxa+4xXJDaPJsSOHMFcdCGUQkE3k2tkfLr7I6+LkHtAKIL9Y98TUXfBTC+X?=
 =?us-ascii?Q?OtjYnnFtJY4GCKiCTfMr/zuK3brWhlCFjtKFF4CSKjnwihpjEx+XYkpb1X8T?=
 =?us-ascii?Q?9zFShl6DR8EGDUDMAOq4TsLGc3AolhijV5ND/q2RACmTC3aiYKWU64XBb2Fn?=
 =?us-ascii?Q?dVUIzLuaLL0xT2i1/ueQRSw/ftKdSBFpprrV01djmdaAgGIz6H2tVxx8hGxj?=
 =?us-ascii?Q?WY0516nM16LHHiU1JrmTAX8gBI5+8G1vi9dTH/x0RgxUSac6KKBKQunWEI8W?=
 =?us-ascii?Q?CO80GxMcyTt5VYNNMllkEYvMQ/MoL3jNBvVVqxtUXuztNyMR1KOJxdn4Z3ES?=
 =?us-ascii?Q?YK7TIsL8unk6czs8ny92KMv+RRSd0muYNpHN+r+3w70KJiyJh2kseGBfe0MF?=
 =?us-ascii?Q?fDCrQI89S4g7NNco43F699e2aP7Wg+K+SO8I7vjDEtgF6skZgMletJub6Neu?=
 =?us-ascii?Q?UXoORgFDr2v1o0bf2irxKMIgHXHUzKAHps4CfK9E285ytcxFTG+oglRaCPNU?=
 =?us-ascii?Q?SFX13zHUtWgiXJaysmPOD+iKuNQmM5aRHIZB3IHmu0XoBx2BfTzpjpjQ1tBh?=
 =?us-ascii?Q?HFF4+6WYruKUfnWZpdAGZrwyz095rN5sGtqgkDT3uLTJwTLrhyXHJs5plhAw?=
 =?us-ascii?Q?Y8MknMjRb7eGC/AbhKemQrJPG1wp+ljgtlaonsdTzVQNrVyjox8HtgX9imqI?=
 =?us-ascii?Q?X6ucd2Et9OjFMSv4eC2cerneEV7FQtnJMpLFCOoOLVD05znn7xrAVkEYNapt?=
 =?us-ascii?Q?EILFMF72ttQJeJTDswSuuIPdC7yMT4n5JmoGEzLe3+oBp0sdW0S43xc5psKt?=
 =?us-ascii?Q?O2aQ9JRxoE6Ib8reLfO5B8X/CLR4OiFUlk5uGOL779AAIcwXb+YlQ2VIqc4K?=
 =?us-ascii?Q?07jr85A4U1dn2xz5YL7s5f+SkP4qdpfoKcRtP3zcIDH6sI+Qr/QcrS9CfONj?=
 =?us-ascii?Q?ONnBJyWLv5Af0Nwrw8wQEfspSGC0qVk6eHWGKVed3G2oSCG8nIMxJsAMk7vw?=
 =?us-ascii?Q?UZ9+9xu8M7l4f6BCWNGjrftZwLrO55mPua7ppcEI/RBIU4ZLLi32cU0PeX6C?=
 =?us-ascii?Q?3MJj0oMURuof2KOpXRr+EKlfeRoixWskzoU+o8R4z9EPgwInTkvwRo1it4q0?=
 =?us-ascii?Q?eHvXxQehi24kfau309ARbswibd3Ldmsl0vt8DVelS6Fl9sPe8TBC6q+MJWIA?=
 =?us-ascii?Q?K4uNbQVL2yYM5NceTr7lq3Z3SBYCy2STje7IMtqbKJf2vtK4Lh26pokgzqhj?=
 =?us-ascii?Q?QgxjBXabfNGsuuVt4d2YPAnzNBIrq6/dNhlyfHIYm8+Iib7PQlwiqB+vtVqF?=
 =?us-ascii?Q?1VkH14QcWQ6dl3qdi3ffUmLV/p+PUAgFYaDUxhDXrc9VgXkuq8ljreC4Zofg?=
 =?us-ascii?Q?Sw9nmLQ0vDcLvmmR1MTr+wNHnW8gMmVYuoli4Nm1X8jJPpCZhDfQa2fsXkcz?=
 =?us-ascii?Q?/5CYwcZ16sFbWEsKtW0xZYQGJvsZWV+/BHtRKjFaS5fdiMuMKHyNEnl3UMP9?=
 =?us-ascii?Q?g/1roPTzQL8i0yECY/JHPOkElyyIxnq/OWo994c0KQeWdO3nzQOk4hBAe2+h?=
 =?us-ascii?Q?x/XyiIuPifqwCqbA6N10LOHECRv0uoA42nu4ylLST70j1B3vfLy2TmQIayw7?=
 =?us-ascii?Q?MVppbt3CjQ9xc/Q8LpaVnpqFsxMKrMAr+Us3/kbAT78uQDPCQkud?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eaf8992-9a49-4d63-e380-08df293603bb
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 14:26:48.3960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eq2VxUbZvFsZ12JZUpaG6mb1CHXO/gNkcOllKhvdHczLizOKFWmuFbr2DIgpjaA6WvNiq3pkUPFnxVDtWBlEf4hEJfl079mAG5rzabVNV7nsNX2fqo/emmay64+VlqkB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9755

On Tue, Oct 13, 2026 at 12:29:58PM +0200, Larisa Grigore wrote:
> Document the UFS host controller on the NXP S32N79 SoC.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 65 +++++++++++++++++++
>  1 file changed, 65 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
>
> diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
> new file mode 100644
> index 000000000000..14291c5506f1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
> @@ -0,0 +1,65 @@
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
> +properties:
> +  compatible:
> +    const: nxp,s32n79-ufshc
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
> +
> +  clock-names:
> +    items:
> +      - const: core
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - clocks
> +  - clock-names
> +  - operating-points-v2
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ufshc@4ac80000 {
> +        compatible = "nxp,s32n79-ufshc";
> +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
> +        reg-names = "ufshc", "scm";
> +        interrupt-parent = <&irqsteer_coss>;
> +        interrupts = <211>;
> +        clocks = <&clks 0x92>;
> +        clock-names = "core";
> +        operating-points-v2 = <&ufs_opp_table>;
> +
> +        ufs_opp_table: opp-table {
> +            compatible = "operating-points-v2";
> +
> +            opp-0 {
> +                opp-hz = /bits/ 64 <0>;
> +            };
> +        };
> +    };
> --
> 2.43.0
>
>
