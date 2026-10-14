Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011019.outbound.protection.outlook.com [52.101.70.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A905539784;
	Wed, 14 Oct 2026 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986325; cv=fail; b=Beh2mAE+k3OYR5CzLqvvimV8WDoHMB5tFHsa9wxdHVhLGopQbPeq1qgQYIPLGaCSS5bnYu5HZWQpgJ0uIPmZmYJYaeiwJvkNlAmNG9eUUMIZh0IikQfULCQG4jRJs8tXn6vIuSqd63CfHILNgVZdq82EZ+IUTz7CIDHyGPdBtgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986325; c=relaxed/simple;
	bh=R8k+5wpzQ8qtXbSs8OrrGJ1cxsQsru8afdjshshliz4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ej9Bcq3mmqj2uLRS4mA34XVEhrZSlT7gKY4ioue05Ep9Cyv6A4Oq/6wAa3SvCiJZPE8fA9XObqKsLoYN1wa5KDiOIakD31qhQcQYTTAx8PlGxZ0hi8rCsBJJWjyFVft8KEqs19F4etIwngrujboOYba5Ms7sf5h3YSrMJ4bGAsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=pmE5+0yW; arc=fail smtp.client-ip=52.101.70.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="pmE5+0yW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqLwLiyIZUBPJfZXLRgZH/1Dj3O2AWAj5QUjtoKcaLnQBwa+fVh2CxvT++ZZhUO5fWq5LqGUyx8I8tCQDGGat2XwNX4TxkhgeJj/EX0/8FxwxsTqK9IabIa9Q0fDSp/tyXCe+on7tvkFY+N1qtUlHzDeIs+QRGKOHACIdL0N57m5NMugCyRwhVlZJYyr4P1qoIjBu1oub7hucY+Sqlz14/ODHROa21y1Gn94KU6O9S6AFW+0Dosl+y8vQgmiQbI4E+oI9d1SagHyBQLGDSVmGViFqpTNSO6/RdlRv5RD9yDBodBn+t76G/TWEDkxG4lSuBhkt+3I1/cDN9Ykfmh3NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/k8qz+GNdrrDh3g/6gwpZURo/XFJ37hK0QK0vHZq04=;
 b=Cwhen4XMSwe9pd0djRb/qniOQXmQavUG5jiGq85y+5ZAPewv2mO4nBN7ua6xDiOapFCXQttTGMaxy00EiXqrTseB7sTwKxxxT58FWVFjU02zFC5yBzl+MSOm2lCmszoY2rPqKbeAAYG1XPttR/n86NwDeJk+N4MmhpfoLjotlM+tWrGQ5HCkF32iKjqdEQMFHY30GLI5VGK/b3a9csLF22tZ5aaxfasNataxC6hEfJOb0Chn+itq9ZfAE3QuURT0QHYaU4vaWRUZlWJfAN0CGqrD5LxjULflsqrAattwIsmavW+0uNOgvV+aZ6OqqH8EMqWARtbjW2QPytS+vuwTyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/k8qz+GNdrrDh3g/6gwpZURo/XFJ37hK0QK0vHZq04=;
 b=pmE5+0yWVCvm5zJE8H4XdDeZUwJSyArJ63qPtMtYpXKb34S/Y40Owp1BP6LEFWnEtWp/0o5wr5uN4FOuPXsyyCNq2EmYkDckfwxi6fnEkLx2RjecHTuHKG4UnZZ8d7OT4eCjs2hvWfw+lgt31gYd0YixukUH/12LH7aHHy1c395umiEeTGvvW5lOj53p5hv79YKSIGOUDsIxffRCUkA7r5rrpW70JcUoe+7uu3hOxelN0gG1MXNx523P0wQsqVfdC/3Jhvyg+yFIr+BoyBFRjSYftDNWGovKs56zvM3U5UDa1/GnuqHKFaZp2ZWhpCcj8Fw7k8M3r7fywTwDeu7e/Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MIYPR04MB12551.eurprd04.prod.outlook.com (2603:10a6:290:78::24)
 by ZR6PR04MB642384.eurprd04.prod.outlook.com (2603:10a6:910:e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 13:58:34 +0000
Received: from MIYPR04MB12551.eurprd04.prod.outlook.com
 ([fe80::d6bc:8ad8:510:5fd7]) by MIYPR04MB12551.eurprd04.prod.outlook.com
 ([fe80::d6bc:8ad8:510:5fd7%6]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 13:58:34 +0000
Message-ID: <fa3a025b-0d82-42df-a4cc-e144d6a97b20@oss.nxp.com>
Date: Wed, 14 Oct 2026 16:58:30 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/12] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, Hannes Reinicke <hare@suse.de>,
 Joao Pinto <Joao.Pinto@synopsys.com>, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com,
 eballetb@redhat.com, echanude@redhat.com
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
 <20261013103003.373156-8-larisa.grigore@oss.nxp.com>
 <20261014-valiant-goose-of-revolution-efec17@quoll>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20261014-valiant-goose-of-revolution-efec17@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::7) To MIYPR04MB12551.eurprd04.prod.outlook.com
 (2603:10a6:290:78::24)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MIYPR04MB12551:EE_|ZR6PR04MB642384:EE_
X-MS-Office365-Filtering-Correlation-Id: a9655d5f-caa9-4ae0-d430-08df29fb3cc9
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|1800799024|7416014|376014|366016|18002099003|22082099003|10067099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 Efp6tx20ho4myXD/3SNbjyPTqAZO9n+pztgqmphhwrAYu6qsGnPhfvt0EnSOThrxm510hQKMeWor+tVRdN1JW8TkAyJcFkuq68Thri1/sYtg6PWNTgsunnBAxIG4e6r8FNkyGv7FoX6Mrhw5PGUkUfj8wWdRY+ZOVLglbAxzl+3Y367yQRcYPzAIOOgxxsIexBAn2E3rdmNOxETg6I2ba7OoYqYqJZThtbGPVJKGB5tpYI+kfaL7HSLmRyD1pG9OKUO/7q+usPVGAparaCkRhrMtAxUI4A/HMOl2WhRa6fcNfCXGOHWPyoEiNtjSjSj5ONakCwVVoyodvsTUE64KlQo7ko4rURslHsH7hHWSZAb7RS0hgVyOM0vbkEOPnb9dtyKwtcta09BJfn14pnWZA7bm2pBbRzx6inM3hGR1NCb2iEhisspK9nE7CSatr5PyhuESpgwMvSfldNpLOTW0NPFbb2DYb81h06YLAujRJIe6GAUjAfIkSiZYhAAFoRIjk3KUBxPCBK7xE9XEA3BezhIFoALThayOMwHMGPSrTeacqkUF/AvlNbyZAx9MIuwPt9OGrfbmnBFlZF3m6igED9IdfzibcESdf5/G9PTGFGuJh8nfcq6swqdyt63erLPkKDnpj+7UfHLig9pPaw+rmkDBgKBNwT8pBPpq7X/K4iE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MIYPR04MB12551.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?eFNRdythODA4TzVpNDNOTUdUZzQ4cTJGK2I1dHltaHhjcnFqQWF6OWw5OW5R?=
 =?utf-8?B?TWpINk5VRDQ3RVh1dlFDMlhZeG9VcnNvQ0I0RFFqN0VoWWJaY1VqdFhuRFNE?=
 =?utf-8?B?K3FIL0dLRVBJWUFTdGJrK1ZESVNWT3NoUjBDRkxRbmliZ0pwL3N6a2FXT3pN?=
 =?utf-8?B?R0RrQmtxNG9mMHVIOWxwN0EzUlVpd1p1aUdpZGJHTFRpL2ZSRzVONG9wWHNq?=
 =?utf-8?B?VnpMcVBkR2I5NVJCK0ZOdHQyczJkWDdUbmVCZWo3ZnVxVmxHcDFNMFNTTml5?=
 =?utf-8?B?Z2lxZmpveU15d0RzMWxKT1RDenUwd29Eb3FvcTFuTmNEakJSZlMrYVdWdTV4?=
 =?utf-8?B?UFJWODluNG8rUTIvTGpURHEzcFRIU25ZS0NIeXYrNit2QjhYQVp4eHV4TFZG?=
 =?utf-8?B?WTdyTFFIZklINjVKeUlmM1dCaGtkTUV2T015eXcvcnFPZzRFUDdrVHlDUXow?=
 =?utf-8?B?KzY1YldTNW03Rjl2anAxNXd5dWpqVGJTa2xwT2tGb0I4T2FDZ2ZtNThGT2lS?=
 =?utf-8?B?Nk04VDR5amlVNUpQOXl1aXJXTHIzL0Z3NVg0alhsNFFGVzJxdTJMKytmZTdv?=
 =?utf-8?B?dGYxUEwwQ1UyaW9HaGZVU3p0VzErL2EyR0R6UWR3SS9PWWNoTUo0YzFpVGRR?=
 =?utf-8?B?MUtoeFdhNXhCZ3ZnQlFsQ3dIcXhxbUt2YmliSGNwNUdudnBZTG1YcEU3T2hL?=
 =?utf-8?B?TlRXMUgrcCsyUGFGUjM2NFlzbjMwejV6cVNEb0kxR2NIWEdnZFJoODV5cWR4?=
 =?utf-8?B?cDd6Qk55ZEl4Z1dVQXVsOEJPdnRoNlJyMFlkWGIwVWlrWmsvcVVOTEJQa2d5?=
 =?utf-8?B?Unh0dHZERHhOT2NvV3o3Wk1idnppZGtJM0RsRUlZVFVaZDg3V0lNcmF3ODFO?=
 =?utf-8?B?czdrY2JWWE93YjVxRHBnTzJ3cW5UK3RqVWtNdTFJQ0MrMjN3ajdvK2Q4d09y?=
 =?utf-8?B?Rzg3UzdZN25lRWdkdWo1Yi9hZ2JxNlNYZVZpTy92R0FQLzJyMGYwRm84Ukpt?=
 =?utf-8?B?d21qVzhkRForTUVzM0N4bHNsMDBFVkFoa0dnOTdKWHVDekJqTnN6cjJZdFhM?=
 =?utf-8?B?Z1F0TXJtNVE1MU04S0lYZytOeWRzTFVSOWVCZXoxZ0dEMnQvZzhZSGZpaXZP?=
 =?utf-8?B?ZmxPTFE1bGthVnJ1dHV4UnlhcThPRWhTbWgvTzJkb205bGZJZmRmblFEZTFm?=
 =?utf-8?B?Wk00SFpZeis4eTBkN3QvTzZpaUNiL0VybDFPS1pWMkJ4NFA4TUhRYTZrOVNv?=
 =?utf-8?B?YUM4TzBjamRHaG92Yk5KMzJDRzRXSnd6blVyVExVektKb1RVcklVNnVGaG1y?=
 =?utf-8?B?YitaTUxET2h5YnNJNkp4bWV2aFlNVVhlYkpVOVIxcTg0NTlSWURQT1JaU0U3?=
 =?utf-8?B?cEpSZFFQYVJobEg2ejVrSEJXaStzb251ZjJXTmgwcWg3dUZseWp0Y2gyaFQz?=
 =?utf-8?B?NDdJbTI5RFE0WGswZm1wMTh3Y2NZams3SVFjM09sZ1FEOXNNWmp6TmZHcFdF?=
 =?utf-8?B?T2c4eHBNT3hrdnRoVHpvKzdVYlVXZlRrOTB3WlgvTlRDTHB4VWMyN0diMlB3?=
 =?utf-8?B?MjVSOGVoRlZQZTY2SWtxUm1WT25ZeTJSUXpiN2s1bkZRYndTdi9Od2d3NW12?=
 =?utf-8?B?UXJmSGp6a1lCcDQyMWtic2ZzTjhBM3A3OWlZc25uZnlwRUFEY2RwQUxCVXlr?=
 =?utf-8?B?cERBUktpcUo5Z09zVWFHaUNjaC8vQ0w0dlMrNURGRE1hdzBhY2hkaVp2aHcz?=
 =?utf-8?B?TmRtTk83WjVodS9mck9zQXFubEdOdEdaZjZNeGR6M05PY2w2RVZuQkRBdWpP?=
 =?utf-8?B?NDFoY2RFaFJuZEN0dS8vc0VTZWxFTlovRmJQbzNDejJqeVBsWkFUeUpkWDd6?=
 =?utf-8?B?dFpHelE2dm1qN282NlNzZ1g2bHlxUU9lak5yazk3alE4R3krdklDT0dFVkxK?=
 =?utf-8?B?Vy9Tenl2MXNlekpUalZCVTZlQUVEdXJ6VHFMdEpBdk5IV0hheUZZN0tuRDBs?=
 =?utf-8?B?OVoxKzBzY1Job1ozUjJiUFptVmU1Y2grTWlMdVA3TzEvWVNGNzJ4QmtDUllw?=
 =?utf-8?B?cXVnMTYrQnVCY2NKMGoyWjhhTmxXeHo3UGRsa3VWSktEVCsyOFljbHhlZnhh?=
 =?utf-8?B?UTQzcVArN3JRWFY1K3htWFVaQzlnNGZWNE05bXdNMTJKNy9NSXZoOHo2OHNK?=
 =?utf-8?B?NXVUcG9wWHlITzF0c0xkS05DTVpEYm1xSWVQWGNLVjA1OUZFMEZyRkg4Mldr?=
 =?utf-8?B?Q0ZjTWswY2xwWG1Pc0h3ZkNyTUkwMkUvWWYzUVdXWXRPNlFYa0w3d3pmaUkx?=
 =?utf-8?B?cTl3RjdDNE8vSjdBWHFQU1gwQjAvVUlVc2VPS3JTa1pHMXBEa09XZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9655d5f-caa9-4ae0-d430-08df29fb3cc9
X-MS-Exchange-CrossTenant-AuthSource: MIYPR04MB12551.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:58:34.4344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xnZBQFZwfCQORw8BI7WADji7KLCkO1aOIZqomCyM8zFeiGVxrGHe5q9VcjTrKxovY4ZVkktmBoWRJEHvMO8+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR04MB642384

On 10/14/2026 2:10 PM, Krzysztof Kozlowski wrote:
> On Tue, Oct 13, 2026 at 12:29:58PM +0200, Larisa Grigore wrote:
>> +  clocks:
>> +    maxItems: 1
>> +
>> +  clock-names:
>> +    items:
>> +      - const: core
> 
> I don't get why you added the clock-names.
> 
Hello Krzysztof,

The properties, `clock-names` and `operating-points-v2`, are needed to 
let the generic UFS platform code discover and manage the controller clock.

`ufshcd_parse_operating_points()` uses `clock-names` to create the 
corresponding `struct ufs_clk_info` entry and populate 
`hba->clk_list_head`. The UFS core then uses this list to manage the 
clock, including enabling and disabling it during suspend and resume. 
Without this information, the clock would need to be handled separately 
by the S32N79 variant driver.

The OPP table contains one operating point with `opp-hz = <0>`. This is
intentional and follows the semantics documented in `ufs-common.yaml`:

   If clock frequency in the array is "0" then it is assumed that the
   frequency is set by the parent clock or a fixed rate clock source.

On S32N79, the clock rate is configured by an entity outside Linux. 
Linux does not program or scale this rate.

A similar pattern is used by the `amd,versal2-ufs` binding. It describes 
a single clock named `core` together with `freq-table-hz = <0 0>`.

Best regards,
Larisa

>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - reg-names
>> +  - clocks
>> +  - clock-names
>> +  - operating-points-v2
> 
> Your opp-table is empty, so requiring such property looks like wrongly
> written driver.
> 
>> +
>> +allOf:
>> +  - $ref: ufs-common.yaml
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    ufshc@4ac80000 {
>> +        compatible = "nxp,s32n79-ufshc";
>> +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
>> +        reg-names = "ufshc", "scm";
>> +        interrupt-parent = <&irqsteer_coss>;
>> +        interrupts = <211>;
>> +        clocks = <&clks 0x92>;
>> +        clock-names = "core";
>> +        operating-points-v2 = <&ufs_opp_table>;
>> +
>> +        ufs_opp_table: opp-table {
>> +            compatible = "operating-points-v2";
>> +
>> +            opp-0 {
>> +                opp-hz = /bits/ 64 <0>;
> 
> Best regards,
> Krzysztof
> 

