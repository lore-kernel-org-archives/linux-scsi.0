Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013068.outbound.protection.outlook.com [52.101.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136EF443C11;
	Mon, 14 Sep 2026 12:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387568; cv=fail; b=mX6Y/owMYm/2DTieVuL0CrzPDhWNdeqix2nXS+aJUrS3imrTwa55RlaWlsSYleMFgS/0YUYcCeRSmVeNJFjZKQD1ni9SR+LEicrgRomMfZofVVIqkUoz41+ki99rjixD3d2btQ3U3Qo7iXtn3P/WTmis2HQOhFih7AkQyCo/Zt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387568; c=relaxed/simple;
	bh=pe3N2A3VXq3L1p2X7lvGlpwFjsokqxEojUR261ydYc0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ugl1ISnMiTg0Dl8JI1n++rFHvgcrW+J0miNql7dL17vRl3xvLCm/XTVaV5TywtpDYpDWJZ9FeJfJo12aZdrszHwT9CB8VuXUGE/YDTJJWt5/3g1kIbwqytYDEEB17CCMMhzvwDqvlYcPoTJT6NOg/qIurCtKG0NCUf5qgcqzwXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=u2cSbUKD; arc=fail smtp.client-ip=52.101.72.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="u2cSbUKD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WEDGgW+5yZff1qSZO10Ll5AuuGVcKNIheokMW+GfKOxdv/GKXz3ePi+r/Q6h7Jz4TgG4hQAetcfkt6zRB6mSDGyLVTXmdUIbIIw9PPPQc5dUlN+SyhBJyHLH157GQjPF5/m1W3o4tYuZU4BbGDYBoQeoXOiufACvW9pZL8Dyu5ZXu0hxf6eOa4qnxYAIn1+vRAWNSq4hLS2eKsE2wHRS7pbbqitKKMw2fH0mf8kSOuPWr6YOgTh9uW8k+vnje9VQapqgc8pR2ctMdujen/gZp+LJXNR0+1WuUXf3xf+mKSmJsxx01mRF+jZmueXgGAZsTo/gFa70TxubG/+pjCNtuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAGS1M3sKaOQQDOoDEM9PdJP2gk5u9BngpddeOjlN5A=;
 b=XziLmG0LU2AwXWFkCiwQce/XbLRh1IoowberMTyS+jrvHMtVbze5IHfaCS/R+ntiFDCe57B2YTMvjT5mEd95S6iCg3oO5x28gmshL66rPB7E5dwJcDkW52PkfClkSr2Xoi4BtGKEfdD6DbeaHVmECtWF3ATBfjOyHrPV41rzUef/TX7/0cGH6+dONBc4zUYDdRVrgjDvaqhUb7d5UeKxeLQ/MNGOhlce625RuwJgEJ+BRsQUbe2FxEtGBpuw2pwafT7rmgoY5/K0p2zeckzhTyny0ULjApvnYBB2scYckBwDqsuANAH6gBR3JF58Ihq6O5eV8qbpK//HeS5Ql4KrTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAGS1M3sKaOQQDOoDEM9PdJP2gk5u9BngpddeOjlN5A=;
 b=u2cSbUKDhdCV17BvkA/Pr7L9Eao5qZ6dS2ERnjsfCERhyXWl8Ob3DUb9Jck606DiAryvYIIH+E1UAMhIPVAEz3BBPuwIr4kU2U7jWwcxJBDXkIzwEpa92Tl84dne+6o4EHewV/5QnSVn5vx9yBlnd/knR0NtxJx9wUfMg+wgOXdDp9sfAWkwkI7FSeLNn7EGkCQu/IE61xdLbQbqHi62SHCBRSce8qUBrQSmEjVo+edB7IrV/xtFsK4XLrvWMMHQL5jm5fkkuRk/BnQ5zfYDO9Z7bNMPrxb0kaRE2eznZPct+d/A2s61aGZ4CFhOvTEApcVgTvmHhXM56jJPy+laPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBBPR04MB8044.eurprd04.prod.outlook.com
 (2603:10a6:10:1e5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:05:58 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:05:58 +0000
Message-ID: <c59a0d69-823c-4c84-8e1b-779e6f75a1f3@oss.nxp.com>
Date: Mon, 14 Sep 2026 15:05:54 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] dt-bindings: ufs: Add compatibles for S32N79 Host
 Controller platform driver
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com,
 aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-7-larisa.grigore@oss.nxp.com>
 <20260828-pretty-impetuous-dove-cfcd0e@quoll>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20260828-pretty-impetuous-dove-cfcd0e@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::11) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DBBPR04MB8044:EE_
X-MS-Office365-Filtering-Correlation-Id: 970b4c1d-437d-4f7d-bef3-08df1258899f
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|19092799006|7416014|10067099003|4143699003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 ic4s9oS7Hov5YruUtgHkhRuupUC0QQb/x7F6w1DyIlGT4DPVzJod8m9fLZUn9UQa0bLox+G64aQD3icq4i9v/5BAGMygte6dVWbbgfTlwHkIeASW/2Ah9NOvgRTJTrvLQQgttpgUBtgzmXfd6dmpiTRB3a5LuNYk9SUsKsjSg09QZIfvuPz2OhTG6pmzI+uFmwfl2mhwK5+vgvX6Z6/DGl/8PTeWl8+vtxOZ4EPjGd05AKAj8iZDuf0ZIOC1JBURHei4lZ8WtsewcCKf4YbYASe4TVmP08h2vptawfEusDtvPJX10NLsLzzZ0DCbJt4tkUNneLwLy3oBBxsPbpjLVUISxoRMe65S2vNJcbFg7MmqE2gLFFojEouym/sYNzltcpgdWZDlnVlDQhXTCPYAtX6Z4AoQz1uXddk2hysg72ZVqgajRn8CyCiX3/627uAsmPmAgn+aR3fiQc8BQ8kVWMnPLZEZiVQeJanqCAj61IHxw3WGIiZ9ZWDNlNEZtbiqUgI8Zb24t0I192blW33VftwFsgCFuOYV/QTzTmn51Bvcrq5irM4iJ/8r/ow6vmzmr0AhddqcCS4LQFOghLqYi5XVzhVHOZATp+eRA41mCPoeYSyv4gkIKJdH9UTPrmyaT4CC6eF0yZitL+8ChcLZyaEfL4mv7exxr94yE1dX/Rw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(19092799006)(7416014)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ckhKSitXRVJNalJvRms5Z281ZWUzQmVWS0lDd0J5L2VLVGZGNjdWaGFrZVdq?=
 =?utf-8?B?QzdXekFnNzRnTy8xOXd1aUl6QXlKNWh1aE5iWUVaV0Y3eFZUY2tEYUd0VnZi?=
 =?utf-8?B?b3gxMnhHSkFMZ0cyekVmdTJyQmdzazlaMFk5OXg0ZnFtSStyYWdzd3Y1amxa?=
 =?utf-8?B?cW12V2M2bEJSdzVVWG5KeU83WGt4VE41Sk52WE5EeXdkeVJnZmdkOWgxbTd2?=
 =?utf-8?B?N05CMW5keUQxNHVWMjNRY0IzdnZXYjMzUktVblU4OHIrNUZPSHlqT0pRVDFp?=
 =?utf-8?B?VUk3V3BkN3g0K0R4dXZIaDA1aUxmc1ZiaEJHd1R2bEEyL3VPbjNmb3BnSXI4?=
 =?utf-8?B?TVk1VUt3WC8zaXNDU0N0L1Z6cjNaZEFJbDFWY2F3YWlERk1yR1V0djhkSXlU?=
 =?utf-8?B?WDM2dlNMSUZIWVFIcmVvL0s2QTB6YzNnZklxVG5BWjFVeWNiSFd2OVJVcHJv?=
 =?utf-8?B?L3A4Y0lZbTVidU9waERUbWgyaWhxakg3dXBrYXo0OW1EZFQxKzBLcy9ZcjYz?=
 =?utf-8?B?UytnclByYWx2bHVseHl3bit1ZTkvMGdmdXozNEE4MGtLWURMemJTWGhZUVl4?=
 =?utf-8?B?c3F4bGg1RHZNSUYxSmlSenVNWVc4V25tYW04WjhGQmlXTWd5RFZNREgyL3JY?=
 =?utf-8?B?ME9qaW9QMU9teklsQ0RNYkI3NE1mZjdFWjBGU2J1N2RnVU1wV2FyY3Y5bkZo?=
 =?utf-8?B?N0pSWDVEV3A3aktVdHU4YjcrMlp5U2VmRG4zL2t0SXl4cjNWTW5JWTU3dUxv?=
 =?utf-8?B?bWJOelMzQ0NDS3hLdkVuVW5QempYR2MvS2FLSFdRL3A5WGRXaHo3SHpnTnpL?=
 =?utf-8?B?QUorazdlNGd4UHppZEhMdWt0MTZTRzBKUFRoMnpxTTRZcVBsRVlXZzlnTy9T?=
 =?utf-8?B?ek1xUmIrc2x2UXR0and0Qm5udXNTWnVxcHdrcUlvdnVSSDdaWXpwaG5wdFJx?=
 =?utf-8?B?b2d4UEZ0QWQ0TFFUSkZDYkRwUUpyN2ZLZVM0NDlFcEdRbG5VK3BRZWp2d1JO?=
 =?utf-8?B?Q0hJUkpGbWZuVU9LS1ZoU25vb0NlT2lyMEpCSTRoZzBEd2IrWTlNM2VLN0dV?=
 =?utf-8?B?cVlVdlZTT1ZFaHpyTnpSWnVxcm9RSEQ3N0N0ZXNDcml1dHdBM3NKVWlTK09Q?=
 =?utf-8?B?eVVHYjZROGdpS2dtOUFlVE9tckhGcll3Wmlqalg1Zk1iSmY5L0FJNjZ5elZh?=
 =?utf-8?B?SGhKS0tDYjFkVlcycFBvbHVwYm5pb0dtTEhSK0FDeUlIaEFRY2tDcFZlNmRQ?=
 =?utf-8?B?WE9PRHkrcTBGZVNQOVRTZnI3Vkdmb1RuRTBlVDhDa2UzRDAwQWd5cExHZ2gv?=
 =?utf-8?B?OEh3VE0wSC9XZ3ZUVFR6K002RFU2WHhOZm53allkTnNyRldkZkJMVWlOUWdT?=
 =?utf-8?B?L0RhTmlGV0xWOXFOc0xzOFA4blJMa21xNVZNRlZXTmxlR2tJL3FOZUF0ZFBL?=
 =?utf-8?B?SDZFOE1SRWhwMmRxNTlWbG5IZXg5ZUlLQ0JpcHc4QzRETTRxdFFuQWpTeVVw?=
 =?utf-8?B?ZmsvWThvdEx0YmFWQ040T3JNTUF4QmNvNzlZRVlJZlBGVTZ2Q3RUQTB2Z01O?=
 =?utf-8?B?cEVQcTAxWm5oR0RPS3lVc3dIRHYyeGhhTGJ2UlVoRjU5dy9BYzZDam9BeFpL?=
 =?utf-8?B?Q2FLdUphZ3dFQTRPbjZ6eCtRREc0UUhiWldoWFBwbGEzNHJ6Zk15dExqbmxQ?=
 =?utf-8?B?bGJ4cWtnS1NTUktDSlhDV1h3ZkVud1pvQ1BNSThRWVVtYXh3N0hXZENwbXR5?=
 =?utf-8?B?NzFiNndpcFlNZUlQQk1ObzduMDkvQ3JzRmRWV2FzcWZadzI4bUk5NDFYWWNl?=
 =?utf-8?B?cmcwR0hKUndrV0M2aHJMc0N5S2FuTUsxSmwrRXEwWHBEL05pSU1BcmJPRlpo?=
 =?utf-8?B?RDlyNEFxLzgxRVpjQjczK296aHpMMU9wY2dEc2lEOXBYazVmRUJBREdxQkd3?=
 =?utf-8?B?TmpGUUNZbVZ3ZXkyVFArWmtYL3NraVhRYXI2SUFsOXlXV21iamIvRFdqTVFl?=
 =?utf-8?B?ZkhJNGZJelA5RStLYnBIZzZsWXpQYklQZFdjOTBrVTV1Ulowb016bFhsK2JD?=
 =?utf-8?B?anlxN3FtYzVUMWJIdEg0M0syQUR5K2RQR2RwQlh1cDNXcjNXYjBmdWZWVkE1?=
 =?utf-8?B?aUdwNGR2bEMzNGRBUXVhVCtqMzBGbTdrdE9MOTRRc0JyS01iTlhUM2x6bDl5?=
 =?utf-8?B?UEY1eGxrdnVFSkdMUEh3cVNJMEFRTzlySURxNzhuRm1pUStDaXZaVlZWckpV?=
 =?utf-8?B?bTZEZnpvbWpsVG8wTk9menRqa2N4V04zYUxIL3FpUlIwL1k0L3FsK0h1bXRh?=
 =?utf-8?B?dlVITm9lVmxyRkpIbElpVkdoS0Q3M3d4SHBxZ053amNOenZDL1hFL1hZejN5?=
 =?utf-8?Q?oGorQR3/UJqncJbU=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970b4c1d-437d-4f7d-bef3-08df1258899f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:05:58.6344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHTRLAzRKs4ESi6y34bBblNxEuFnaZZsvFWkwILkwjVFkgenGijnx6w3pY+4yxvetgZ+JuxODrHGxWcrGeD17w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8044

On 8/28/2026 1:29 PM, Krzysztof Kozlowski wrote:
> On Wed, Aug 26, 2026 at 03:40:44PM +0200, Larisa Grigore wrote:
>> Document the device tree binding for the NXP S32N79 DWC-based UFS host
>> controller which is compliant with JESD-223D "Universal Flash Storage Host
>> Controller Interface" v3.0.
> 
> Subject - Describe hardware, not platform drivers.

Thank you!

> Best regards,
> Krzysztof
> 

