Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012021.outbound.protection.outlook.com [52.101.66.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F0E435523;
	Wed, 26 Aug 2026 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787754922; cv=fail; b=hAc/ygWon0gClKfB6at77IzvC02G+98sy3qH3qieRAJQIynue4v5yl0Fa3cUwBCZzA5Z5SxVfIbnKcQoCLHzQDcoMRTkhb8aVYxixBmhZd7ALliC0YifhJcz4enSgM7txEHJ2Ytp7HTNgGaWq19ffujnnz77OLnEhnH8GvRI3Rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787754922; c=relaxed/simple;
	bh=wwtjQ4woDWouqvioENlkL6Bt00qVMK/KCg/7CeKiajM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NrZKi1X3wBw+XHJcgUs0QDR/Dv5b5DF/SXm98IIQrTe6Tjr0UkrcX/4V1F7g3VmyR9v4OMnZX8Ip5MZOwoBZ3S/dfVgFBbz86DQoe6nHfwGdlcHaRMu0IaPeLzpiHYVlr5ts8N96cB2VJioC1HzzgAcwUH2wNu31RI3FNjPHCsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=MDhswKGD; arc=fail smtp.client-ip=52.101.66.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="MDhswKGD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RRXCvyKUMielM4AbG1yGq3uaZbDb7WcixKklN84F7iNRdmBff6UzCV8uaf6IREJ5FrlwiWIHDYg886hkAmHa1r/INCufzCRiAbEvb7PiNDSR4anpAcdkVmOlmwxUi+AcKnDV8rPOcPYKyRPwv3Cxgjrd+wszaH2kIJ+KnK6T8l8mzSkV3EL4T9NHLCIjy7McNHTYassYbfKOM5L5FhHK6KKmGfZwQ8thq9McUYBexUXijIKvShNSpECBWWbr9ptWMSQaE3rNzlezH3W9IqTw8EH/e26BOvaOduBe+55jc1s8E8yB/4QzFwMapsk21PxsnqnSufobKtwIDi/Q4zpJZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JtqDX/iIjI+Yod3O8jj8tCrxWMNRyZgjyNMEDzhwLw=;
 b=G9zqBQd32Mnz3WJ4b7COwwObg/lnuKjvmkEjP5xAQ53/wAUw/idgcsJhzgM78Wkm+cVKUG1hlfI94D4KM329CSeNWJj5cH8nP//k4n647JkN1gXVRf9CX56+Tw6ER4A/fLHSfB3l4Xm8kI+/3+v36N3hZmbv1g6VDqoiE3gNgqDlodxsUhbXkD/u4+tadf2zeR48Tw8KvtCkp1G9EQ761VAjOdpZAc6pCx0gkhMgcEQQcp/WMlOecz6qw0jR+TWBHUm4NwH/yNp8i1WgrIL86WuM2ER+lJ0vz2lOZrEepjArvV+2cdQ1nVXUGUTH0fCdjfMqLFLEa0GrYk5CXhL5VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JtqDX/iIjI+Yod3O8jj8tCrxWMNRyZgjyNMEDzhwLw=;
 b=MDhswKGDExFbwV5lJ9+BwYMwulJNisZlK37AIPBCM96XIjcyBePYMSmAuGUiE5GMEAMKFRAK8tks7Lieb9B1abxMdQ7uPp+tXJq+yjouQn0Roeqq3UJ21r3uioErXtU48tv+lEjYyTsdrp5Vf7e8qTE8Pw+mlcZvJTH/9TUtNpJd3tHawjDmpnLRRSAjjxDfwkpg96ENcWqnu88xADr3J8aSdJVuoJnEyX8L9O497o1ObkPHjhgy5sLwZ1QRMHcVSjL02bP/+vn58s735XTIKMxvQXIiqxpudMpzWmPoyAGQSGMPNUqqFDiKogz+/hOZXY4E3nRblgJdQA6g4ySAHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by GVXPR04MB10406.eurprd04.prod.outlook.com (2603:10a6:150:1e3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.8; Wed, 26 Aug
 2026 14:35:14 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0339.012; Wed, 26 Aug 2026
 14:35:13 +0000
Date: Wed, 26 Aug 2026 09:35:01 -0500
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
Message-ID: <ao75lU2zYDeOZi2f@SMW015318>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-7-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-7-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: SN7PR04CA0080.namprd04.prod.outlook.com
 (2603:10b6:806:121::25) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|GVXPR04MB10406:EE_
X-MS-Office365-Filtering-Correlation-Id: da76c66b-813f-4c01-35db-08df037f3d32
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|19092799006|376014|23010399003|22082099003|18002099003|3023799007|10067099003|11063799006|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
 K4j2R2EkjKVuDzq4iZs0BciSoWQrvjjlJUdBC/fjPYPWCgQMY6M/CuBXAyx3O/3/ODQ/6aCsdM4nvzxLykAYKj6EOzbdaet1ZmcLfid9BdfqlnCPjwkK/ePi8NlWEQn6JPys1wZ+kWJZ254MmEpj3dg+QHFZlbRyhwo5UDO3aKmAaI8IRbkX/dlnAgSmjmR3AFHHIlFoD7G2pBvzcOiyrrYiDrjyH9msePFpiQMNcVSfJWPC1RZwT9p5sib4WjWwob2lFf3wnP63dfoJEU8HeS2TR9veYw24wTAbgN2ADN59C1OVuaGy/3oGGO/nntKL3gXUTqJiamL5+Bxj3kvm7BIihA7aDiWLYSakBTM+EeNdywnkKYakikmOdtLztkUm0lEoCl42Ua+HxBjjDLqssuSEV9FxPugf/MNbfoflWMDUp/29ItWBC2HLbEYkqiFkOc4+HXNtVdqIABKBTo6J2sjR05kpSrfTDSiXT8ivCx4gpBRfNBO/IC1ApAK4s3C+Uh5acStXR7qbyWUUksmQkpcPwJRcTNsR/XbppBMI+lynvscPIMzNuYqYhghGxX9wJK7GGbOFqRYZKlTyTrkSYslCwqW5fj1fD3/T2XhE9p57z1VVAd1rBqkPh62u7FO2
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(19092799006)(376014)(23010399003)(22082099003)(18002099003)(3023799007)(10067099003)(11063799006)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ynp2eP/ukFO6NQaYlcyc23U7Rk/PeN9aoMHbfhfV1yHaTmgG1GsxuJOFENQ3?=
 =?us-ascii?Q?13e3cK+yGSCT3/nP5qkDh5Vba9Qeu4Wtt3eZnbGFed5H58WfV794m5yLz0ts?=
 =?us-ascii?Q?GtlbHn+G1YW5vbufu7FZjKeSfjepX1oUQDEdayV0mR1KJbDTW4iaLBYGFxNy?=
 =?us-ascii?Q?p+EKStFLR1j3tx2z1QWplRBHXHOK6nijIEqk5KoYqCpinuiWkfL/qEh7oSjS?=
 =?us-ascii?Q?cG8pO1ygvvQi7KtGJ0BhPQ9x+DKXwZiL6lb0HSbn/xTnm5dHcTXdZg2ve7qk?=
 =?us-ascii?Q?tqkYKPPgr/RLzZIKvwVa2wZo1d7ehdgh7zwvSi4oKjbzhmzZoPKZ2NmBuUAS?=
 =?us-ascii?Q?HOngDdv7A1KkQhMGXG/DsOfbl8PR8UGxYoO0MGMTmfJ8+MMQYvaHNLaT441y?=
 =?us-ascii?Q?tu3kdV22jFtIPnjWAhOFE3eUiWyxNTbDH+V+/kXBgajdJG8cXv2qXNSKDorw?=
 =?us-ascii?Q?Co1MJOScB3RJ6+7Pg1f3STLv2wA8Q5ZKtt5X7kxFRWaTVViaFnoL0QRaQda2?=
 =?us-ascii?Q?WcoY8lFL8PrD6Dz3PCRD8HF7whCPF9EVnhDbyrFGWwhrGEh6tHzQZscmhJdI?=
 =?us-ascii?Q?YLfRn+Qhw0jdHUna59IwIavZSN424tueAyTj9OjDG8mtDb1XgSHn45iNc0QZ?=
 =?us-ascii?Q?WSx3mxJWTyCNfDGM7ZHA35SfZVqxjkh4lCqeTgDEQTlPCaEY4J/P/W9zBnc6?=
 =?us-ascii?Q?CyZGp8Q2u44DTOsdpSUZKk4gjT3pxaiK3WRMekXFsY5fL64bO3tKjVk8fPJe?=
 =?us-ascii?Q?PMOARntEJxvlmqvjq/MTsHSrD6TkqvzYwlc0ZICjjY24/ScjclLv4v8dIZ1N?=
 =?us-ascii?Q?8YS36ZFOyS/o6lHxIATWAg/URf2QjNqG2xS9gmzU3DRZHMOHKiJfpcW9JqRC?=
 =?us-ascii?Q?Dz84hNJxDGwmjsmtgwGnQkVD61qJ7aohfxwRR1pVRy831aJaA2/z/ZJiOB9j?=
 =?us-ascii?Q?ZIaMyg72Gt5jfIeSzN0tt0pAWtAcnGlMOm6uZZaUlyy8tVJv3CLOtHxUipqm?=
 =?us-ascii?Q?9MXMM77V/TZJLjZ8/j5fBXme/aYlKiSKAS8t3Z9hfECWzZrUdGsVBr1Q1wcs?=
 =?us-ascii?Q?ICWo1+SQI9Rt9+6CVQynOSlA0B5ECR150AJ1Bn+6tddihqPVhkaL+F7O+tUh?=
 =?us-ascii?Q?8XudWx9SLHAKBdOzqDro5Xp+ipVLLn523V3prP/VbOEVcAK6ZMri0sN/i1G3?=
 =?us-ascii?Q?vfnXKz6I+/CRkU5o6VHdHlgnDy/86kMJ8G1Qp9x3MQHPmeNrU6EHN8LFigJH?=
 =?us-ascii?Q?SSpAXpPjd0TZrvTsoj4j9TPxgz8hNZ/CS8xs/We2U+3IJMVCTGrPvXgBARbK?=
 =?us-ascii?Q?la/NhoocuWLetiyJRWZVWQH4BvGvsK9C+IqqqAabP99fATb3xOS7VDZyP/O9?=
 =?us-ascii?Q?KU3lmKkn/QmEn3N2dodhVqQwGC/ZWpOBsepZnkJAfsJMbshaqyluPwrhJJHV?=
 =?us-ascii?Q?G/mfw4H6Bpz4QjpaIo27hnQv2T7sAhamDKL7T8jap2z2gDv6YWK0/8GoYOHD?=
 =?us-ascii?Q?tZbyib8wqq7/mYkcHlsFNGHmuOut/de1NwE/ZBgjXaHGJbKBU9M2qJ3VpXPp?=
 =?us-ascii?Q?+AtCT7PSV6ua3z+MshN/rBiay6XzdoWoRKkbBlPRpXAei+hUnh2AsbN4Ieaw?=
 =?us-ascii?Q?YWmWIP2pHmZ2cKg+GKiHBeJ15IEMLob7VR2l7ytA3Vfxxt9Hj1HNeSIfdsip?=
 =?us-ascii?Q?SKtx5sSphIf/Q5A0BOhezg7q++X3tvrOjx9zdhwqzSSRIhUrRmL4bFC7J6Zo?=
 =?us-ascii?Q?ctYHQ8w52YHVgjpiWLnBt4Z6ARew0EPxtBw8pLIrIkcj83Vfl7km?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da76c66b-813f-4c01-35db-08df037f3d32
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 14:35:13.5048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2TmTykJpMuJDwYrcsEaV+3Yo/c7O/OtluvwwgUavcdAdI33cqeG7DNDV5jCwg+EB2Rc3czu9Yyphtp/7i7aD5dZPI9DXwfZrr4ltQm+FMfd1MwUrTxtqa/kxzfSFAl6o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB10406

On Wed, Aug 26, 2026 at 03:40:44PM +0200, Larisa Grigore wrote:
> [You don't often get email from larisa.grigore@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> Document the device tree binding for the NXP S32N79 DWC-based UFS host
> controller which is compliant with JESD-223D "Universal Flash Storage Host
> Controller Interface" v3.0.
>
> The controller requires access to the SCM register block and the core
> clock rate when M-PHY initialization is performed. Add the optional
> nxp,mphy-boot-mode property to select the M-PHY firmware execution
> environment.
> Currently, the M-PHY firmware can only run from ROM. If the property is
> omitted, M-PHY initialization is assumed to be handled externally.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  .../bindings/ufs/nxp,s32n7-ufshc.yaml         | 99 +++++++++++++++++++
>  1 file changed, 99 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>
> diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
> new file mode 100644
> index 000000000000..d9d5669be313
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
> @@ -0,0 +1,99 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/nxp,s32n7-ufshc.yaml#
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
> +      - const: jedec,ufs-3.0

Any place actually use this fallback?

> +
> +  reg:
> +    minItems: 1
> +    items:
> +      - description: UFS Host Controller registers
> +      - description: System Control Module registers
> +
> +  reg-names:
> +    description: |
> +      Names for the register regions. The first entry must be "ufshc".
> +      The second entry "scm" is mandatory only when nxp,mphy-boot-mode
> +      property is present.

you already us if - else branch to restrict this limition, needn't
description here.

> +    minItems: 1
> +    items:
> +      - const: ufshc
> +      - const: scm
> +
> +  clocks:
> +    maxItems: 1
> +    description: UFS core clock
> +
> +  clock-names:
> +    items:
> +      - const: core_clk

Needn't suffix _clk, just "core", generally needn't clock-names if only
one clocks.

> +
> +  nxp,mphy-boot-mode:
> +    description: |
> +      MPHY initialization mode. Defines how the MPHY firmware should be
> +      initialized and executed during UFS controller startup.
> +      If this property is not specified, MPHY initialization will be skipped.
> +    $ref: /schemas/types.yaml#/definitions/string
> +    enum:
> +      - rom

why not use standard "phy" property, if no "phy" means ROM init it.

Frank
> +
> +required:
> +  - compatible
> +  - reg
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +  - if:
> +      required:
> +        - nxp,mphy-boot-mode
> +    then:
> +      properties:
> +        reg:
> +          minItems: 2
> +        reg-names:
> +          minItems: 2
> +      required:
> +        - reg-names
> +        - clocks
> +        - clock-names
> +    else:
> +      properties:
> +        reg:
> +          maxItems: 1
> +        reg-names:
> +          maxItems: 1
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ufshc@4ac80000 {
> +        compatible = "nxp,s32n79-ufshc", "jedec,ufs-3.0";
> +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
> +        reg-names = "ufshc", "scm";
> +        interrupt-parent = <&irqsteer_coss>;
> +        interrupts = <211>;
> +        clocks = <&sys_clk>;
> +        clock-names = "core_clk";
> +        nxp,mphy-boot-mode = "rom";
> +    };
> --
> 2.43.0
>
>
