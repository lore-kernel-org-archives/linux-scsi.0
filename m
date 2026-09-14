Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012044.outbound.protection.outlook.com [52.101.66.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54907448B96;
	Mon, 14 Sep 2026 12:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387536; cv=fail; b=qwcjVlt80V//ZFAdt11MzTZ1BRLx7vRLU/TrHuB0U54K7zuVUTAghLZq7meR23CvP7u07tas8CgxNKQGQee+rttSr/wmE7+spbFqhOs0IpbSH29WzY+5+3hh8xt+nr1cZ2bChugb/edrtXSStqkyPGenGesjWOo8aEMkcnBxxrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387536; c=relaxed/simple;
	bh=67Pbava63R24bDuW1qraKh0B8ExvNBX3U2h+p/xlCWQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Swi6hyKIhah2HxAHJGUpqbIdxr0wSZLBXJvCJ76Xop9A1jcfzPSbuyEm7Oy9mhpzYuwcOGoY/c3Ywo/tf4gV5k7az6d6XvNx+kT+BxKVMjQvIuVOAPEKlkru9eh1MV1kd/QRKllkpcJDmFGZFSUd3JBQz4NK6URXI5Hjg83QBlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=wdPcLP9w; arc=fail smtp.client-ip=52.101.66.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="wdPcLP9w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f6T0IFs+RmubWbV9I8Se6sIzTXVeNPyqlZxRBffTkjKnopcKqKOdX5EKcMQEJ6FfQWJjQJcCMG5c9z1xkhSA18UelCFRXZw/rFbD8n/xwiYNF8oIT4o/AB5fg19hmpJi0L3z8dmQjxvHvpLpOySzdAWk/NauwduXjsdDAo7n3XMbg5D6RrAIcso59MMZw6R+F+njMEPK7s5T60GnDlif6O66zvbABNar+kaEU+zwk8bfDWM9LTu5PPXz29MXBk+T9FuacjO2Tbz7Gh7CqPggi0aGk+6NRQv+L35ztzQqjvAy8re9PS8+alIprV8dp2vOc3fq1g5PLVZgBB4R82GQsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DBIyEjoXBaobETsgAMeXtIzUVA7oeIsr3UWXgIqqGc=;
 b=hj/35DH9maSynr5DAACOe71oOyhaWwJWkIGYP1upr+dRhyX/YxYHI3yn8vfx9QbfOFJkaynn3cjZkS8FUMxGWP+9yYLlYEFUj1k7Ie1ulwIIxNAmNnsKYDev2Sv3LZBhhNJDnXidS9MMnCf7jS7b/jTF+wwTWHx4lAiYn6vxK2weYIRIjZZFcfh3nz+e+Qjjt0xuqzeVxSS08vTlST+XIYFe79KYo6Wm2Skm93/1gZfaYM/5MXD0a2Ka52SKBCZ2l8q+DLPJLcHJmBytMl3cBqZvwUJu8DEC/jwB+WkAWRv5d7FiJ7NJYruznvT7Vfp7P8QeyHZqHVd2vj8/e9PnpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DBIyEjoXBaobETsgAMeXtIzUVA7oeIsr3UWXgIqqGc=;
 b=wdPcLP9wxmZ9GrFKJ5SjcCHT2HWE63VPh6XAlRjXadw29h02LUCF5lcLQmm8V49pL3AXc+nWn5MfubjnXm4Qgb9/WJ3qUC2xRVQt+ZRFxJBNCNhRewV/aXtM/y4SyAIwmAFHpRSzQJY5N7pljPtbnHpCP/p/rvMus2WqCy/xKea8osUoBu4YYhP6dxFal0/jOjywxX1W5FkyuckODMMuYSdtSEESTKSQQvYcx7Qn8MSepcRPNHdtOGAFhJ8Rna2qNsEAGxjFJPd/b+TrDV4K3kA27RqsBBb/i9rV6PZZXptqxjP+EUYtQhaxWXij3jEe1ktHcowRqxpBEP7xlvwO+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBBPR04MB8044.eurprd04.prod.outlook.com
 (2603:10a6:10:1e5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:05:29 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:05:29 +0000
Message-ID: <cceb8f7e-2ff0-43d2-979c-6ddea98f4bea@oss.nxp.com>
Date: Mon, 14 Sep 2026 15:05:24 +0300
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
 <20260828-dark-foamy-guillemot-0b60be@quoll>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20260828-dark-foamy-guillemot-0b60be@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0058.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::14) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: c8e39ca0-f920-4ba0-449a-08df12587840
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|19092799006|7416014|10067099003|4143699003|6133799003|3023799007|22082099003|18002099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
 3NH2IsWrm/TJdNhbVWLWXqE3BUKidlMcYcDJ077eltYp2BT65k8wuc6xu2sKSLLWq1DKxsgnwdcSjgH//L5q4O5t3dTSi7FusyZq+MFEqGXf1vE6/LD/6IlmNoOs3JhYsSFTTaepVUKVLQaiEHiveDFwe67QYdhy3M9vanRY2jc4S9yw19DgBRw6FY9jJE+wJCc6WJvj9Hwy3qi7gkjXt9THJ+vUc1JfawINZ9n/DAW6gEMoLO+G5ez99rjARPyj7jBBdLWZIe/7XfyDHR5rr4GfmfeUQ62+qDHwtHbffUr4vtnWV9xy/WUTku70RRTATMWm0q7F+vVyASMqHCL99IH7YoqANJqHfay0AC2p6nOVe/+YClRt8nzLNLJHmQqjLBbwNeK+DKVAj7OJO4KfOewrglX+Nd86aaU62i++LyrEjm2CY/QlIzmCYdKq8EDgSOuhuFi+NL/DFp37SLpTMxvt2tWIZ4SiM8creSriZUlDOT3hH661qg4MhEov7QvGtZcsmzs5V5HNTPVZiAT8vQcXVnhqLApHB3IPEcPl1qFYKo3GppSov8poLKm9e+DgZm1K4rJQ3GhlMaGrYxN97216us9IjW2chEGKoO/IbdmVyoOSxCVZqCSS31FW+Hl3mBaoSK/dFrlYRAAaYdUYy2KsPRLaJFC+0nIhDCu0Kys=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(19092799006)(7416014)(10067099003)(4143699003)(6133799003)(3023799007)(22082099003)(18002099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cVZDY082eHo3NnZNMzVWWXdDTmlxMkV6Ymc3ZGNMMXdJclJUSk91UXBxYTlB?=
 =?utf-8?B?V2JiK05aanJQNGFSelNyWDgyZ2d1N0JVVG44bVkzZ1Vqb3FVaEozcUhETTAw?=
 =?utf-8?B?SEQ3dWYxOHNkcFMyN0JOMVVXVmh4Q2hCNjdmWUR3VGkxOW9QWEdWeHVPKy9w?=
 =?utf-8?B?OHlxUXRKNkFvUUpKNmxRR3NLajZueTdpOE1YcXIrK2M1T3NMc0ZPRTQwSVgv?=
 =?utf-8?B?cStNZUwvSGJDd2ZDeGZ3L25nczEzS3paOWwyd0dIM0tzc2s2aWZVeU5uditS?=
 =?utf-8?B?dm1BcWNoRy9QYjlDUDRUUDY2ZlYzU3oxSjN4TzRmUGJXRWM4c0F6WWYxQTls?=
 =?utf-8?B?QzFNTmR5MWZJZG1Wa1NOU3BqRWsxSXdEN3lKZUNoeWtxS3dGaVpxazQwN3BS?=
 =?utf-8?B?bDZsSlhCZHFkWVRJTzZqT0VMSWhGNDVMLzg1cllNcEFTZnJpNmNwczh5SWF0?=
 =?utf-8?B?OVI2NGxZeEtrNW5VQXhIaHNhcWFOajdGMjQ4ak9XM09kQzVRSHAwOFhUM0hp?=
 =?utf-8?B?MzFmLzRLcmxPYUJtNVh3UXBUNXhDN21pVURNNFRyVzJLUmluY3dqYXZ1SjJs?=
 =?utf-8?B?U2xyaWtPTmlicHNyWm1xQ0FJLzRxL1VwWjVTbzYzMldCVmFLdUYzUWFnRDNs?=
 =?utf-8?B?UDlPeXhKUE1ZQ3VTaFNONWFUNldVYXJWdGpSVEpueXNvdHpXSHRwVXpiNjln?=
 =?utf-8?B?cldJYkVnbEFWUDlaV21uaDNqME9ySVZiTWRKSWJXY3NidFpscjVpTm93MmNi?=
 =?utf-8?B?QTIybXN3YjdLeHdkNVBFOVhFKzM0VVdmUDhOWEZBbjN2OW1VSmVYdGRGZFhx?=
 =?utf-8?B?ZXpySDF0OU8yUVFsM0tQU2llZzRQV0tzTWxINzRwZE1JZks2M2Y0Lzkvd3do?=
 =?utf-8?B?Nks3cHJXY3lmNUFjcW0wWEdrZitJQ3l5aEszR2RuNVZiNjlHdnRxS2VLT0Fo?=
 =?utf-8?B?SVQ1aHJlTklZVUJxMWltRUIwN0VaeFlPMDNtVW5yMzE3bTRHNURpMUhvSjNB?=
 =?utf-8?B?bS81L2R5WHdBWERhOCtsNVJKMWl4TVBZOXhIYzVieHFwU2dhclRRUWJYU0dw?=
 =?utf-8?B?bWRYc042MVRISHp2ZDk1S0xuMXRpMWt3MFplOFF6WlluOElJSWU4K0s2QUIr?=
 =?utf-8?B?TWR3TytnV0pWOEYzTmREZ014aDh5UW80ejJSaXJ1dHNsUmNrSDZReTkyZzFZ?=
 =?utf-8?B?OVEvVVVtMnNaZ2FKM0xFbEtzb21zQkRHRUE2a21NemVpVEorblkwQ2U1eDlL?=
 =?utf-8?B?MldlczlMQkZ5aWJ2RjU4OVJyRngyWjNaVXBLZ0d5NUlpN2ZUN1JwTFJtLytV?=
 =?utf-8?B?MlV0YU96S0svYVBXczNLOENsbUNhcm5XV1JCN0YxaVdPdXRrRitSODV3MXJ6?=
 =?utf-8?B?UmUvVnBlNUJwZDhDS01pZ1g2OFk2REFHN25DeDZMZEdsb0tGSWs2MFNZRkxy?=
 =?utf-8?B?OE9BanFnbmFaalk1TkliQnVybUkyTlJKMVRBaXdZdmN5UC9wakIvSThESk5Q?=
 =?utf-8?B?NVo1cE5aTzNxSDBPNnpZRlhqNkJzMFFlUXhkbHh1VkVpaWlGMUNJZzd6QUJn?=
 =?utf-8?B?bm9BeXcvbDYvQ2NPbU9ic08zSVUzb0FyUEV2R29TS1Z3U3p2bG0wZHhkbVpi?=
 =?utf-8?B?WDJGNk8wdUVQdEp1SEtIdFV1ZlM2S1lEcGJPd3d3dEJMaDE4cDlBZm4vVnhY?=
 =?utf-8?B?bnorS1hPVmtCMk5KcEtuVEVHa0xzM3JQVzNLVk50OHl6enBaSHExTGJqMTNh?=
 =?utf-8?B?VjFueUNWUWFLcnF6bzZmUC83OEMvVDlJc2JRTGVwR3FvSlNaRHpjYVZ5ZEFk?=
 =?utf-8?B?cEJqMnpxUkpOdnA1QmpJOVBnRldzeHFySmtpK1J2MGRuQTlOeGlaOWdmS1JC?=
 =?utf-8?B?RnUyYURIVE5BMzdWYWZTeEh5aTZkMWdrTzg5ZE95eTVua1RaS2NKc3lDR094?=
 =?utf-8?B?NjhXVGNCUElCUk5MMU1GVXVOZFJ3cFdodmh2K052OFlkSmFHWjhJbko3Nmlv?=
 =?utf-8?B?UHpobys1eHZQRSsycWczMHlkQTE3WmFPL2hjWmRqMnVmS1ZxOTRaWndXMzZr?=
 =?utf-8?B?RzU3a0NNcXMyTkJEcUNQOEM4M0hZa1lkNm9CRWNZMnUvanFzbEFMQUxHRmhn?=
 =?utf-8?B?T2c2YkQzVmphVHQwOThwaDkzWWZWYkxVNzdwbmRUc1BLNG9lMTNYb3JRWVJz?=
 =?utf-8?B?ak9qazR0eG9ydHVUQTB3L1lyZDZKQkw2U29tbmxXMmp5TFBQeDFCTW55MitC?=
 =?utf-8?B?OUpZZ21FTVEzNmhlSHMyRXhwbFpxNUZGOHZOOUlHUFdDY0h1OEViRzlIaG1o?=
 =?utf-8?B?RndoQ1VDeHNjS0gvT2YzRmpXMy9kV2dWSkxMM1IyeGhpaTZXYW9rMXFBQkE3?=
 =?utf-8?Q?ZgoPAgQ+aKDFAsd8=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e39ca0-f920-4ba0-449a-08df12587840
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:05:29.7025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JX091Z/gelT4IWCTDHC9adUctmbCFoLin/7DOQFU2Dq/HG6bX+wOnwaQGIrTbQBCj0oVV+OwlY8dS7SI2tr8TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8044

On 8/28/2026 1:28 PM, Krzysztof Kozlowski wrote:
> On Wed, Aug 26, 2026 at 03:40:44PM +0200, Larisa Grigore wrote:
>> +  clocks:
>> +    maxItems: 1
>> +    description: UFS core clock
>> +
>> +  clock-names:
>> +    items:
>> +      - const: core_clk
> 
> _clk is redundant, just "core". Or skip names, not really useful in this
> case.
> 
Thank you for the review Krzysztof! I will remove clock-names.
>> +
>> +  nxp,mphy-boot-mode:
>> +    description: |
>> +      MPHY initialization mode. Defines how the MPHY firmware should be
>> +      initialized and executed during UFS controller startup.
>> +      If this property is not specified, MPHY initialization will be skipped.
> 
> Isn't this implied by the compatible?

Thank you! I will drop this property.

>> +    $ref: /schemas/types.yaml#/definitions/string
>> +    enum:
>> +      - rom
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +
>> +allOf:
>> +  - $ref: ufs-common.yaml
>> +  - if:
>> +      required:
>> +        - nxp,mphy-boot-mode
>> +    then:
>> +      properties:
>> +        reg:
>> +          minItems: 2
>> +        reg-names:
>> +          minItems: 2
>> +      required:
>> +        - reg-names
>> +        - clocks
>> +        - clock-names
>> +    else:
>> +      properties:
>> +        reg:
>> +          maxItems: 1
>> +        reg-names:
>> +          maxItems: 1
> 
> I don't get why for the SAME device diffeernt initialization means
> device has different address space or clocks. It's the same device, same
> wiring, same hardware setup.

Thank you, that makes sense.

My initial intention was to distinguish between two ownership models: 
one where Linux performs the complete UFS/MPHY initialization, and 
another where the UFS subsystem has already been initialized by firmware 
and Linux is not expected to configure the clocks or access the SCM 
registers.

Looking at it again, this does not seem to describe a property of the 
hardware itself. In the firmware-managed case, Linux would not be 
expected to touch the SCM area at all, so representing it via a DT 
property is probably not appropriate.

A separate compatible describing the firmware-managed interface may be a 
better fit. What do you think?

Best regards,
Larisa

> Best regards,
> Krzysztof
> 

