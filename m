Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013037.outbound.protection.outlook.com [40.107.159.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAA1379960;
	Thu, 27 Aug 2026 14:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841444; cv=fail; b=pd5zJwdHqHHDaxXFbv9zcYIwiy8bya4OgDY9hsEU/NRZsXLdrvRh93IpKr0HljOW1CZq/VE+tiaO7WBeg2is/p6fUYPeCSeYeWSTEBraW2qu0pKzoQymyOS/GH83YEMdVwLkRGCISMHtMbizpLng0vOVWnHOF1jsPCanqxrnLWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841444; c=relaxed/simple;
	bh=urFwOgdd1VxhBXFA8nF0acycax4Z1TbK5yaxUQFj08w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nKd9xWnHuprtCOfVA9DPun/79DsJVxAsg8q8+wxBH3JNR1QAMryAsmZls658jJQrm4YRj18h2FV6/kX83jAQKwpm3MraqT0SAUg5troItiqy2wdtVCgf+73zdJuFyIi/YeUL4VEU2O9iIdVLdU3henmfESeZDbv5mOuVGv0jUjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=udsDG8to; arc=fail smtp.client-ip=40.107.159.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="udsDG8to"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uz/GlCj6a/Ivq/fMhjNA4W3zCGW5qkZSg/9bMQ0/uKxGyufP3woqn+iffMG8OWcaE01En7I4tMINr2Ni6Q2pH4O9FUP1DnYOrHO7nLPOtF6bER3r4f2Xx5AnLEYWtNlFi8TGNLd0TPvx4obBEJthYtvZrqxc73tgFPxU1rWsZe/mj0U2JKKiYLTHyym7w15Zz2RQyR1azwmwU6TZmcHj8dXj2fYiK+EkfDGVX29ldwHTXPOAaFvf7J0JjqokQ/aUOOR1mv55ywOgepRZlixIAE+M6sR6VRmcv59emxEkGWEDOg4QQVWaHnXjT/6BtCrflBCn1Vr6L4+NOcJYLDcNRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFMdgByWIMAFnZIreIY8pVtiw3Vum/lJr4WpQlXvqXY=;
 b=I6wwR5CmG6vUSaSwGfEocQsRUn2MHM6HfZCEm6hNzUoVNHXPUwjbpRBy/x6HMLtzgZnw+vYlv6CI83tfl1bI6PYgvaQRWG4jYBTn4m91th0YejrYO2wQ3xQaHuvdqDKADw3fvfY42w1ItImJhJliv/v8anJ+SZe28BMFk1cyvVU8hWwTJNqoRjCYpjbB/mgQUwx5fV/ICfnWUjPYY0+0e1MHE/+hb3QOXLk8J3an4livJjV6HiAyHfm8ih828yKihn6uCpI7iY3lF4K8t6m/fLaM6Ta1GDTJv0XBuJlPQFvmjy/uPXJ02fp6HK89Jqb0NkOVuSBz0uZaDK2KuZhdHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFMdgByWIMAFnZIreIY8pVtiw3Vum/lJr4WpQlXvqXY=;
 b=udsDG8towFdPc75EIxH0Xyo8oYU9IH+3ZFHAx+bti145T8ov8i/7v7PUvgicmV/d22GWNgsYcZf3j4ekRcOa3BD3SLB5TBYmwy13u0PdpiCYmFpBJ+Mq/0g1HnSQ04nJMtNFKbso/3Z0s79FsK+EOdfxgHzJtI3ht3aF/Nj+QTmkNWZpNHV9qX33yGSkptdziHMHWU8Cf4PSNXPL/9k7pphiVWRR1IesIyP7bM7vEnbrl2uoe+r5PV4HXX+8g5rmPMG9WbSyxE20PiDukM01ZY9j9ga2QlUFSS2HDKReouN8o+ju/vCIX1J6vjDMaPJ4xDYE9u5nQP9dqOB8j8IFsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PAXPR04MB9021.eurprd04.prod.outlook.com
 (2603:10a6:102:217::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 14:37:18 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 14:37:18 +0000
Message-ID: <f9a9273a-3c00-407f-8c35-c07d367954d0@oss.nxp.com>
Date: Thu, 27 Aug 2026 17:37:14 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] dt-bindings: ufs: Add compatibles for S32N79 Host
 Controller platform driver
To: Conor Dooley <conor@kernel.org>, Frank Li <Frank.li@oss.nxp.com>
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
 <ao75lU2zYDeOZi2f@SMW015318> <20260826-surely-sandal-64ca2d2c4481@spud>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20260826-surely-sandal-64ca2d2c4481@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0025.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::12) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PAXPR04MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: ee176b99-1638-4d20-2017-08df0448b226
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|376014|7416014|366016|1800799024|10067099003|56012099006|11063799006|4143699003|6133799003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 bl05BJf4FOe9woWlN2FLC+eI9E66JLlNDkrPnAPzk0ipjHDzU+Ff5p4qRhkBkTNwWFbmdPtWHKc8ZQGN0ZQUrds5AirNBZXLQqPY5jkmkZXrgcJWS4YfL5aED73YsLf9KJR7QYM1k4XM6NdSFM4dmwEspgva0dPcLv2V/NbdeNZTFDh/j9bAmYXVsRJLfH246k9XIxwcdXXpfU4P0Ewj7caEctRx6xmnup92yDkUvGFxKzfY5jnyvUEb0V15ee+bj4p5CDNnrm2X6z80gugxW44XOrOq8jmi7+pUoP3D4o0DRGSq9pfPJOTdqB663muudYwVKmYzMdrC0bp9naBN7512VupGWdjZrjPGc69JmoCBFFgroPcgcbF5iHM61gC/ZLC0k7jzUvmmaK6rFhCuUVKZ5iP3PAnuocs92Vzj3pUmAwN/mt7phAkVadCaxwcvTUPWAzl0I/bxihlv5TOQxkJiMikvR91AoIIMtGya+g1oPlQjrhcAbIHIevJ8pmB9jup/YEF1paBDsl7SKz15E0OrOg4ev4+63yxuBj9gHiQxb4NOtnG11aYhiI1WK9RDoZ1RQFk9ezS8EiviKOsNRQ+ABrGXRPz0CYSIJunb2/S8kqf7ENVSvUzotJyZSwpE
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(7416014)(366016)(1800799024)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bjVqV1Q5VjJkY2ttRFV6akxTUEx2YkxRaUREN0w4WVQyV3dQOW42UllpNjcx?=
 =?utf-8?B?VFNGLzNnRFU3Slo4QnpxK0lNVTd4WTNsZXpxaUhZTHpNajBjZTR6OFMvQ3Q0?=
 =?utf-8?B?M09VcnlzZlRwTjVwZ2cyQ3dTanlOKzA0Z2dJYVNvdDR1M0lJSnNMWEhLZkxz?=
 =?utf-8?B?YWFKanlQZHpkUysxSG1WRjBnSStBbm9OeGF4WXdJb2VRM2ZHbXhKY05sUnV1?=
 =?utf-8?B?amFLaVAxSDA3K0hHbjhld1dCOVhySEdkTnFHZjkvZzYxQ0krK0U0Ui82dU9J?=
 =?utf-8?B?QXVmK2VDODIvN0Y3TEd2MUVoNXlOL2dNaUg5RU56LzFmVURyb1pURFRpa2hE?=
 =?utf-8?B?RHFZYjNZV2VMblh0Z2gvaUJRZGFxOS9aRGJMUGM5aTVZYk50dTVBZ2c0dDVF?=
 =?utf-8?B?WkdMK0pFM295dDArc05Lak0zT1o4SHQwSDUzUjVCNFR1TWdGaFp5N2QzRU1j?=
 =?utf-8?B?K1JNNitqbUZWRlBSYVJ4U2hrbE1OZVE4bVB6ZkFFcDh0QWIzK21UNHRoVGNq?=
 =?utf-8?B?RmJWNXJQV25zdmdKTmZGREZZVDhqclg1NkR5ZEdnbFgrTjNoK0Y2STZwNWgy?=
 =?utf-8?B?NGhnZ0xWU0FyNXdhMGRVRGRNTXloZ2t4dEtZZW1BVkhLM1pNQzBNbjJCNlh6?=
 =?utf-8?B?U3Z6Y0ROZk00QjdqYUJ0anRURThGMmYwOFo4NXZ3TVV0clhza0p3SnFiUktU?=
 =?utf-8?B?VWNKVEsva3BBRHlYRXBuT0UwaWk3ZXFjbXBkSUZZT2YwTUhWbDF5UFVPYitt?=
 =?utf-8?B?Zkc4VjhheTN6ZDIveXdSUGRGVlNoaG5NaW9wc2MyV0JJRHRRbThLUTBKQmVS?=
 =?utf-8?B?a3plVWNaOUVrNXNSNVRwRHllY25rUGhldS91SUlIc0RqUkF4ZW5uRWttMGkx?=
 =?utf-8?B?aVVMcXBpQUNUa1dLVjZUWTd2MDNkTElZKy9lcFprWmFGMVkxTE9YbHJyOXN0?=
 =?utf-8?B?VG0yVTBzcDhLSVBsUEEyWVFTajNrNEpUdm5GYzhGTnlmUnJsQTJuaFdhbzRt?=
 =?utf-8?B?ODBUSVhQKy9yM243VzdXWUFuNmtBQ2NMZzdYckxMbE0vU0I3YnN5c1VSUWVz?=
 =?utf-8?B?bEhXaFBhR1htdThjWXJpaFdoWmx3TW1XdnBjSnM5ZlU4UFFkU0VOV3Evd0pK?=
 =?utf-8?B?RkJ3T2Q3YkJqSGxqenR3SitLNmJwRXlkMHBMaldURVVJRm5icjQvRUkvNGZo?=
 =?utf-8?B?VERkOUZadEtEYlZtK1lERzEyZDN0aUo1WTQ5YWVuQjBPYkVhSG95SjFoTXBZ?=
 =?utf-8?B?blNnLzEveWJoMzR6NVlQUUY0NE1kUFJaNWVxVC95K0JwNldXRmtzeW1GWSsy?=
 =?utf-8?B?UTNwV3RNQzdCUUE1NFpGamNTTlkwelZYdHdpVU9kS0ZKelF3SkwrOGtLdmgw?=
 =?utf-8?B?ZFJHbGswQzNkY2FZTkJoNDdnamNRNXBqbEdQQUtiMjJIZ1oxK1pyaXgwREZD?=
 =?utf-8?B?UzI1NmlkWXBYUlY3bTMwVXYzVW0vV0VlKzRmT0hjdXdpWWE0SWswY0JyUGZt?=
 =?utf-8?B?anM1ME4vbmlxSUtKcEd6SEdTMmxqOVFZN1BTdWQ2MUdhVlhCbGFLUW91YUlO?=
 =?utf-8?B?L2pRNFVxRklyL0hURXQ1Ui93R3BlVWVtd0gzdVFEQXVreU9zWWdwYnNIN2Jn?=
 =?utf-8?B?VmFVT2NLNFZvMkRqSmIrbDlNT1lhckZ1SWpOTVJVOElwdy9OUndnWHhNdHh2?=
 =?utf-8?B?ZTJqN2Zud1pSbUdHZyt6Z096UmphVS90UW1UUlBOaElqdDhzZG51Q2wzbkNv?=
 =?utf-8?B?S0hlRWRrek56WEdJRkNDSXNSQzBrNEpFaHhLZjF0cTM5QzNUNkl5cmhIdUF0?=
 =?utf-8?B?bUtYd0VKWFZyYmVNcHRTZmNsc1BZYWw0NHZnT29RYld2bWpXaXBuaWoxTDFn?=
 =?utf-8?B?ZDlzVmRSOUtFNWFHY2hNSzIvdmRHODFORCswck1QTS92S0FGeEVsTjVtMDZw?=
 =?utf-8?B?bXhhWWQrMzdUS09wd3dyWHZqamVWdm9KRWdXSG94Q0R0aEZ3MWdNN01mb3Z5?=
 =?utf-8?B?N0ZJRXE1YThnOEs3eXRhZzc1aTZUQk82QkNEMHhFS2tuUEUwdklXVmRBeVdD?=
 =?utf-8?B?SEJ3SkJsbE5uSDdiUkczS0NLaVJNUGxuM3lRTms4UkI5Z3h2WjdLcUNwVXZ0?=
 =?utf-8?B?SEN0ekRzbUEwNkZXMG5UQTkvRDliSEpHdDJRbEtTOHhGczAyUmZkRVJLZXFV?=
 =?utf-8?B?azJObzdSVFVuVzhNS3VXdmFxWlFUVzlyK2dnd1RlSDVhakYzaWhsa0xyUXNy?=
 =?utf-8?B?ZDA3d0NYdUtpRWZaSmlieHN5Q0s1YmNuOXhJNk5qVVJWOXd3aWRlMTNkcG90?=
 =?utf-8?B?bFl2MWRFMW1GU0xYYzFqbDFmUjlkeHpPdm1CeWZkZmNNRFVWRFlhUkZVcmtO?=
 =?utf-8?Q?HJG8VOPyFr49FXQ0=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee176b99-1638-4d20-2017-08df0448b226
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 14:37:18.4003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+e+zM1Ua5l2WwFSGz3zswRH9WP6gzNEclXaT5qjDYt5NXH9lvprgJbapHaJmb7Az0VeM+pNe84g/kAVDdvuFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9021

On 8/26/2026 6:57 PM, Conor Dooley wrote:
> On Wed, Aug 26, 2026 at 09:35:01AM -0500, Frank Li wrote:
>> On Wed, Aug 26, 2026 at 03:40:44PM +0200, Larisa Grigore wrote:
>>> [You don't often get email from larisa.grigore@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>>
>>> Document the device tree binding for the NXP S32N79 DWC-based UFS host
>>> controller which is compliant with JESD-223D "Universal Flash Storage Host
>>> Controller Interface" v3.0.
>>>
>>> The controller requires access to the SCM register block and the core
>>> clock rate when M-PHY initialization is performed. Add the optional
>>> nxp,mphy-boot-mode property to select the M-PHY firmware execution
>>> environment.
>>> Currently, the M-PHY firmware can only run from ROM. If the property is
>>> omitted, M-PHY initialization is assumed to be handled externally.
>>>
>>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>>> ---
>>>   .../bindings/ufs/nxp,s32n7-ufshc.yaml         | 99 +++++++++++++++++++
>>>   1 file changed, 99 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>>> new file mode 100644
>>> index 000000000000..d9d5669be313
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
>>> @@ -0,0 +1,99 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/ufs/nxp,s32n7-ufshc.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: NXP S32N79 Universal Flash Storage (UFS) Controller
>>> +
>>> +maintainers:
>>> +  - Larisa Grigore <larisa.grigore@oss.nxp.com>
>>> +
>>> +# Select only our matches, not all jedec,ufs
>>> +select:
>>> +  properties:
>>> +    compatible:
>>> +      contains:
>>> +        const: nxp,s32n79-ufshc
>>> +  required:
>>> +    - compatible
>>> +
>>> +properties:
>>> +  compatible:
>>> +    items:
>>> +      - const: nxp,s32n79-ufshc
>>> +      - const: jedec,ufs-3.0
>>
>> Any place actually use this fallback?
> 
> I don't think that this exists anywhere already:
> https://lore.kernel.org/all/?q=%22jedec%2Cufs-3.0%22
> $ git checkout korg-next/master
> Previous HEAD position was 2697ef8943c9 Add linux-next specific files for 20260813
> HEAD is now at f82a5da2f049 Add linux-next specific files for 20260826
> $ rg jedec,ufs-3.0
> $
> 
> So not entirely sure what the point of this actually is, if the driver
> doesn't use the fallback.
> 
> pw-bot: changes-requested
>
Thank you! Will address it in v2.

Regard,
Larisa

> Thanks,
> Conor.

