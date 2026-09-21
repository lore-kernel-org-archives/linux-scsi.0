Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011038.outbound.protection.outlook.com [40.107.130.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198163B14AC;
	Mon, 21 Sep 2026 08:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978953; cv=fail; b=UnsjUc5G9zxBsCQnC0Mwu0QDgrngIaOKU/XIKa+hTq+gqhC2xb6QDF2KqHj1xQnl9YsgPsKVwRStfRPQawyLATrRneehca9oKWn/Hx882aDMGLaN7QXSCwToN3AQlchE5sWV1KydldMbY9iFqIwTyZSun41i6lKDYwhnzto2qc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978953; c=relaxed/simple;
	bh=jecbb6jYb+74Z8VLi7flMNrUIfL1pbabSB2+pA8zAcE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EkmiQI8cCg88HpBlsWd7ssuqjTAp2m+3wn51iqgmNLXllF+EmkiyHe1zLnnErPeXWF3fsoAYcy341x7k5xy4UWyfISWpp9ba61tIniiAY608BRl6L1uSLPWeSl/AV3zN5NyS0RXbB6mL6X76QRolMBzUvVWcltX9KoVx2+c4rv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=v1nTrfx2; arc=fail smtp.client-ip=40.107.130.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="v1nTrfx2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TRrp8wTmMxi/kka8yVBwg9lw8K4akAc0SJT5Sw37mzNemDL6hjocGlCK/4+wjhSsIrr0W1iYhjdkT16xenKjHgS0v+OAcnhVZ8UrshSzC1RdLihvnZotjpWiTPqmxrUBosUp4JI3dkq6pGqK5FskDp2wmvRJXXThmFujgkan3Ejcvp9lZ5Ca7HH0ICs8+nOwA5Hr21bgsWdPeSVI6ceZoK3BAO9KQyt33oPvusZ8gVWbwfnhtbcqtcf1Hdm8UAXoL5xMbXvQxK8esAfWL1yMfL2DHGnqhJvzgFvkCROqt1NxOBmljJifOAgb8aDfSAQPqbXL6QDY3GxbHwo4Ng/oHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6LKC4iPiHUwaXq6w2wJnvSku1C+05mkhhu4GVPFhvw=;
 b=wDao4NwGsPOCQiAUx9l3yNX0pteuVbxhOo9bYDICgtq7kGWhSiF8M3eZ6iaJcTIGgsxy6owTadd9bObQK+oZZTjTgHnUZtP3XcGOyW9E2/fxKy3h4O0/mBW0/vwZrKJt+sdza9iiBTsh5lKSoCDYd0WnGVt4Li9v6noKBjTtoocfZUqqm9E+Sv1BqnJfVvH8LDLCqLR0vH98A3W7WIYhtF7RQfiNHy+5wYz3DeEah6n6B5eGo/qgNeNsTJMHnlWHjej7QD8cEQGKCbMw2i5v4tOC4fGAf1fEyTgDjbDgaKkJRPOCmIV6/lLpP/m96Asbi2DfAVr92Aan0lSeQ4c7Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6LKC4iPiHUwaXq6w2wJnvSku1C+05mkhhu4GVPFhvw=;
 b=v1nTrfx2eCdkq4dk8oHzkaif5UeJki9RtNdUeqzUDsmfmZQZX6yVYZZtqt0eku9j2fBIhZR/Ej3h8FOUqyGs53QrB6dUvyCmB0MAowFmpnQwoMtaQo0z4jaNc5SIryAACXcd6GPBLejYK5m8vGDuRT+d9W27JvyczzbmyzAVM0MBdvpfJJYq1LGj0upfx9/8Vbl99KYSELWVYXn8xhFWDUiBe8cNV1v6X4O+YT6JRljwaSk6S8Erv8RiXqRVD2yaR0JL2H4LkFSqIMltBi659wgidjdR/BcrsD9aTVFJ/iZ1oj9Ye8nxIGCp2nGD/IkcsFdJyK8dDMCxdNFDae+hpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB9932.eurprd04.prod.outlook.com
 (2603:10a6:800:1d8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 08:22:24 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 08:22:23 +0000
Message-ID: <b8dfcfc2-df7e-4b0a-b3e0-c5c8f58752b1@oss.nxp.com>
Date: Mon, 21 Sep 2026 11:22:19 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/11] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
To: Krzysztof Kozlowski <krzk@kernel.org>, NXP S32 Linux Team <s32@nxp.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 clizzi@redhat.com, aruizrui@redhat.com, eballetb@redhat.com,
 echanude@redhat.com
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
 <20260917091555.1443076-8-larisa.grigore@oss.nxp.com>
 <946fb909-8e21-4775-8328-c46e306f17c4@kernel.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <946fb909-8e21-4775-8328-c46e306f17c4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0018.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI1PR04MB9932:EE_
X-MS-Office365-Filtering-Correlation-Id: 37344482-cfb8-461e-0cdd-08df17b9766b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|7416014|23010399003|11063799006|56012099006|4143699003|10067099003|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 mlpOcUYg7rXhbDXTlLqqpPVY0Px9Ha7NxU/Vb7nWmUoJWI3gsDqlcZB6xXkmoIdc2EfRJDGoyN4pC2BOgt/wxqt+jY/rDUmrjjnkRZJIpouAmzYiUCI8PcVcVRgovdfuM102yWQUAo4YM9KvBMchqs7X8PKOTU0eg7yGDvsqKaw4207jHqmn0498ROlZP9ifLbgAliaGCeEOQHBzp4h+HXBBc6cqhhWFO7nfnuHYtYeW2lnp0ftoJwzcN8CH1DGHCfUaQwpvIwHszPooRvoCqwozFD0gZtCBecMRNUrEeLGkz+Q/0b4ffNr9eZ/XDIlcXZhkbTMv6JLia3Dq/vtJ1PATG81SynJjPVLXsl9Tu+oArb+teTlTn9UCEMCFxbmmRC0/BklALIwvSNyjR63+87QB/Z6OnwY+pZCR1gDbADuDnkdQ/VQaRfwVQskfb8F36u04DLHk2dYVWftBwO42x8MVlZEZ8p00LiOkfHhtc1bk0OFKO/ppGX4OCEdX14/UtNFlYgVAZjPk85GCSpx1yWR0Oc1MFVILE8l6neljkWqe9So5bW4GDcstlr1EEaJ1mLAHMRJKOo0VQL3SEBiX7BqHcYKpysmOXiLMWRmauGrNrPto/fzQSNHAK4+TM42T+MafA2uIHG0m/BgLvVJG1RNqsOoaT1+N7603bEgha3Bg+SKiqleBYJp2flFr+bGpHrG5R9ymkfDgmcy/1Pf6dw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(7416014)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UGFHZTN2dlRqdUFLN0FBRVczemtjR2JzdEdzT3NJbC82ajUzY0VKN0RlLzRk?=
 =?utf-8?B?MFJrWENaREtwRDU2ZXVhL1BRWWVhdllLZVRXcEJaaDEwMW14cU9xUVFpTWRX?=
 =?utf-8?B?elJUcFcyYU5BLzBZeU9HT3hkd0hOUlJiWmN0UElza0Y3N0ZOekpVRFlZT01S?=
 =?utf-8?B?aTdtN3htT0FJU2UwYkkvYkxDb2pQSjA1Mmsxc2J0SmtMOXl6enA4aEJaUHUz?=
 =?utf-8?B?TXBIQmhhb245aWp0S1N6RGNlcU9yZ1hhUlJLZFpIZm1jL0ZudXJIU29UaVRC?=
 =?utf-8?B?c3JQcXlqSjhqSDJrZHpPa3NNTDhocUNQV0k2ajRtTWp0WDJuM3hpY0FMZmxI?=
 =?utf-8?B?ajFKWkdReGNDeXZOVEczd2RQVWhsL3RndGtmSlR5ekgvTi9Ebmk1Wk1UckJx?=
 =?utf-8?B?bk84dGQ1NVpjdmllQTBQNXlPTThHVHJoamZjNjRqMzZ5NEJzVmN2bUxNZWJQ?=
 =?utf-8?B?NUMxdkNPYXAxSXBHZzVUbGQzNTljaVY4WFdzdUdzTmxtclZlZ016RVgyYm93?=
 =?utf-8?B?ZTBteGdSLzluVS9EZllJT0drOXV3Z1NDSzRhSnZTdHZqQzJmTFI5NVhIYm1h?=
 =?utf-8?B?L1VrWUJ2ZHlvbThMVUxUUi8rYko4M2gxTzVQTU8xdmROTlZ1a0dkNEZlb2VG?=
 =?utf-8?B?Y2U2RUltWVIzNW1sUGtaRDNjaXFNZ0ZvTHJkZkVxbFM0MmJLOHZNT1B2enNm?=
 =?utf-8?B?MEFEQkh0NjA0Y0oxNG9hK0J6dk9KbmxndXFMQnp5Z0R3RmRtcW95b3RLR21B?=
 =?utf-8?B?Z3ZnbXRhV0NncHJKdWVkbGk4ODB5SWZVd1VpNnh0Yy9UV2RPMlNUakFib0JF?=
 =?utf-8?B?WmJtKzZkc3dUcUFmcGdYTEpyd1I2d29LdnNac2NqaDhtaXZSTkhPNkhwY1Ft?=
 =?utf-8?B?QkIreTRqTUk5VDVYVEtpV29zL1hwa0tvbC9peXBZRTVEeXFhQkJvcDhZUnRj?=
 =?utf-8?B?ZHZmMHdYbnNYdXNGS3BzZGkwWTJzbStZMTJnRVpvR0Y2VE1ISDY0VVpmRytK?=
 =?utf-8?B?NGY1bjVzc0c2ZStzRytMeC81TzB2OUtvNkZRUGJXOUtkS1kwbWw1R2pMVHd5?=
 =?utf-8?B?d2s3MjNGL2xxVU1FNWIzZ0FTU2E3VGFLSTVzdEMwbXBZKzloRU1mdms5ZHNF?=
 =?utf-8?B?ekNBeVNPYnBuRmlnMTY0QzVIODJwdFZUcG8zV2hNUjhiQTQxNld1SjZKWmha?=
 =?utf-8?B?cmJTcDdLTmJ6SDdKWG5UYjk3R200T2pwWlozeS8wQ20xcWdoZ1NzNE41NHYw?=
 =?utf-8?B?VzNTOGwvZGZaUlJ0TXNCVjhyWEZoYnlZODF6elJCOFBjZ3lHQ0RKYk5VMUVC?=
 =?utf-8?B?OG5nNWZMVTRkSkordWVKMldKcVY2QXNYUkRGQUlGM2s2bzVuaFJkZENTYTkx?=
 =?utf-8?B?cGg2U2RWNFphTkdxeXJNYlVzU0JQZE5kU1FJU20wZCtXRjJkYVpTQ3NwN2lY?=
 =?utf-8?B?UzhOdzN1cjRrMXVwT1VpY3FNV1RhYWZTTENpZFdHU1VpNHM2N2xKaW9PQk9O?=
 =?utf-8?B?b1dQUUMrRWNPWXlJVFJ1SURTbC84WU5ZTkdJTDROMFdBSCtPQUNSSEtFOWFZ?=
 =?utf-8?B?cXF1MkIzVzdBU3pGcjduUjFLZHR5c1NpRHgzMjFuOUVQMmlJVm9nTkxVSkVO?=
 =?utf-8?B?MEhUcHhVdmdDcFd0aE1IMy9XZUVjV2huM3pCSmpBZXFORWpid0V1U1lWNnd0?=
 =?utf-8?B?bVhZYlNVdFU4dGZYLytkd2VXbmM2MHlGWXNsREFDMnNMb29UMTloQitkN3Zh?=
 =?utf-8?B?RmtOZjV6UnhMRnptcURta3BmN1VBaGxQOS9sdzRLQS9scTlTT2VVYUk4eVBx?=
 =?utf-8?B?MTY4cmppd2Vua2NxTUNodGo3SHdiY2hqOUkza0hzOEcvM3VRQWZCK0hoSmtz?=
 =?utf-8?B?OU14eEl1QmNnNWNxWUlSSGZjYXM0c2R6SFpTNXZ1UFFsUnNoQVpEaEFYV2RE?=
 =?utf-8?B?YWs5WkZCMlJEdlJaQ2x4NWN3N01xdWFCWmNia05keWdjMUZBaHdmeTgzay9V?=
 =?utf-8?B?dWV2TUtkT2RwUXFVZG1UWWZZV1BKYWc3T05xdVN6cWNYL2VHQ2w5aGVIOVBq?=
 =?utf-8?B?cUVLaUhpTHFoUGx4V0hmQWhRaGR4MEVZYmdWa2czdzBZc1R6enRXbW1iR2cz?=
 =?utf-8?B?RUg0eXBnQzVBT3ZZZEFTMGdMdVlYYzVIcjFHTTFha0Fhc25GZitSY3ZuZnBj?=
 =?utf-8?B?RTFlNzNqNWN3NjFsSWo0d1dBUERrVkJNeTgyV3hsc0lLM2g0QjEzZWkzQ0ZN?=
 =?utf-8?B?emU2R0ZnWGpXVkoweDQycWlBbzB2L3BnNFZzRlM1elhXc2RkUmR6ckZOekxp?=
 =?utf-8?B?d1BvZ0NsL2MwWjVrbmlqdmdmZWUxbmtlSHZ6Sy8vZldFWVdUMUJwZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37344482-cfb8-461e-0cdd-08df17b9766b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:22:23.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJnFp2L9iV18wHwGMyGxN/mfFeX6pFDIQsZl64JJFY8LL5Cen0HdsM5XO+OfK4lJina6xs2Pxx06UTEpwMsxrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9932

On 9/18/2026 12:49 PM, Krzysztof Kozlowski wrote:
> On 17/09/2026 11:15, Larisa Grigore wrote:
>> +
>> +properties:
>> +  compatible:
>> +    items:
>> +      - const: nxp,s32n79-ufshc
>> +      - const: jedec,ufs-2.0
> 
> Continuing discussion from v1, why replacing one fallback with another?
> So previously it was compatible with 3.0, but now it is not and it
> became compatible with 2.0?
> 
> I cannot find any software user of any of these fallbacks, thus IMO it
> should be dropped, unless UFS folks have some arguments for keeping it?
>
Thank you! I will drop the JEDEC fallback compatible. Looking at the 
existing UFS bindings, not all controllers provide such a fallback (for 
example, Renesas UFS controllers), and I could not identify any software 
user for it either.

>> +
>> +  reg:
>> +    items:
>> +      - description: UFS Host Controller registers
>> +      - description: System Control Module registers
>> +
>> +  reg-names:
>> +    items:
>> +      - const: ufshc
>> +      - const: scm
>> +
>> +  clocks:
>> +    maxItems: 1
>> +    description: UFS core clock
> 
> Drop description, redundant.
> 
I will drop it.
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - reg-names
>> +  - clocks
>> +
> Best regards,
> Krzysztof

Regards,
Larisa
