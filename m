Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793711289;
	b=m9LS+o8AlJfgKoyswx5DISaOXnhEqdlVcY64GgqzW6dq6fCHpxfBFf8iXQseuII0SmpJ
	 ELW2g1Poqq7TWGFq7dpz6b+hmpMOb01uYCH5sPoLR4UFs1F3gfs5SU97SRkUFyNuAtxaw
	 KkOgyuiwR7iBCRvoxvdKq70TlkHcLkx/MffGin3YrG0Qi622nf+bYD/Bb2t/0zXDLOo6B
	 amAZZvZSU584ghNH3eBioVZILgrxUbju+BqdwznQO7c9A93IcoDMQB3tOqlvzWO13zyak
	 ldyLr06JPEyrtd00mpuIC8Xldnnn7wrpXx4lgqiOTOk70ePs0sAfl96r7GxuqpDdRGQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711289;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SharedMailbox-RoutingAgent-Processed:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=1fBCpV361Ghq70htxPInxWG74L4nJhRQLrY4+iilsEg=;
	b=yJf/8bhh8kEmXG4HXBPVqADsHTuRGcS90oT3EXfxVvFdsiv0u8CFYaPxQs7yY5nxlW0N
	 FtO9+z42PC+2/VSd9LTUMVjmc/SlRgxuHJMCUMipU6BrLKqCbqWS1JcBMHi9di5FaZgyG
	 HDEvb6Rs9Nkg+7zn4dxlU+YiZFjVzwB9960/jL9o8JPC88qpDj0JzYFx3SwTMlKWyOat1
	 sRLIJ2kPxgF5btLteWY2qYpGMTPDnNfXsXWcLgbPT8ehTWEGPNkZigmMjZkSQYDl2J1Iq
	 lNKaPUepkmgQSYHb50WYjMQgyTo/UGF3aR9yYmn5wwd0Z5lgwC4JZN1BlOHgxpy1tfA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=df5WcpEj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.33
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010033.outbound.protection.outlook.com [52.101.69.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7731D606D82A;
	Tue,  3 Nov 2026 13:08:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7731D606D82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=df5WcpEj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brbPBZiCKj4qmCDOoeG9s8rjjOwmixMC5IepiXavsyWdMe9Z2YCTeqe0gShrTaVKQs0gmccs/D5YGE3XLZFk9a6UQaaeBwTMVj23lHZy6pFuhGlxhmTuEquPTKl1cb7KK7Yp0uQNPLOt2LrgGv1IuTLrOEr/D0bk/yo0bonEn6U2xfNWszHiHc7flqrQ+nt2QTeVrGZzIt6UdCIW1lew4Yo/Q4vFOG1Ic2Qm8U4oqZQnVaEZHiyX4NoVkk4H1Cp6ql2RljqXL9tCBN1AQklceIjqUYagKRKgxBMX8nEbuw2vnBlTyg9FxXEBc7fi/uLLMDckEYVDfSpkmG+pzG0gqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fBCpV361Ghq70htxPInxWG74L4nJhRQLrY4+iilsEg=;
 b=kHqz/Gl1IsNt+9rcA1DXqgRsalDQyJFk4StaT1+WR54z7uOmYsWjDRjJrokNIFScG8LaTha3zh+OBfYkHvI5OGPdTWhoErOiBC7M0EbKulvYawonbTczJzPBiSajgi61SwbDyZVdeUW3GEWCr/MPYQbeICVR3DRopxmP07eNEq1vYzl/uOmMYc6NZ4205+bbbHBVyFKs8LdV2e6o5iGJAJvaEpSWVDnUGR3jPMhADKOQ7nuj+diuzFsGelEUODovo0fc5vW9MBKDlTMZECfQ195DF/edwJLS3agVXhZXmTn/4KQiPTeUKGQ20ZQ8Z+cyOUv41eQPM62gkQ/MY/2EUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fBCpV361Ghq70htxPInxWG74L4nJhRQLrY4+iilsEg=;
 b=df5WcpEjnyBY3J5rXYwFF8h19AlMk6BxkJbMhKVzhg0NyLujwyM803Fjn9Jrccq81D5LWZjN93NFvokzl+30TdkCDaEZCk64IipNoBjs2v5BjvA6n08HFu865blUapVgrOOMLyTOJWnr9SMOmtnx7meXf7lR2jVdYe3d5GAy3dhgHvgYoT0C/jpVWqKC2zh9MaW2lA75DJw1GGTYOnBVP51hyQHg5UBhtit49jrBVvY8nfoBFNRAZs6tRVBgnetrRGGaEm1gTnDYxSjUaBqYTu0YzBBrCKcrLSsFRR3kntvIdiUIS+T6OSFtoSWbwq98SnIjMqTbc2/Yn1FNGeMoJw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AS8PR04MB8007.eurprd04.prod.outlook.com
 (2603:10a6:20b:2aa::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:08:04 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:08:04 +0000
Message-ID: <68497fe2-c347-48c2-8faa-8c07924e8305@oss.nxp.com>
Date: Tue, 3 Nov 2026 15:07:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto
 <Joao.Pinto@synopsys.com>, Hannes Reinicke <hare@suse.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com,
 eballetb@redhat.com, echanude@redhat.com, Frank Li <Frank.Li@nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
 <20261024122533.3609180-8-larisa.grigore@oss.nxp.com>
 <20261026-beneficial-authentic-bonobo-a59b7c@quoll>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20261026-beneficial-authentic-bonobo-a59b7c@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AS8PR04MB8007:EE_
X-MS-Office365-Filtering-Correlation-Id: 3853fa50-786a-4f16-d991-08df39ab7eaa
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|19092799006|376014|366016|1800799024|23010399003|10067099003|22082099003|261102123227099003|18002099003|3023799007|56012099006|4143699003|11063799006|261026140227099003|261026121527099003|261022075727099003|261021121427099003|261022105027099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
 wbyOEhaq4aM6zG/6f/6r04cdIN60dghCNowHtW8NBvmwmhCPs3RekcJtgzJIO7JhkAGZYFqPe20qV4gs1TzrabGmeV5lUaAU2w6fU1T6dQ4+bbQPfSgZ+hiorp06RlRrFxUWZfGl5XIddDBIqJcyvPjSENxw0XY8zoedJkc5ZrgUjQpA9aWNXTfrDc68sRodCU/e0eukCV1I7jTtV0jncrn+FBxvLgllKyisnGIdDI33FCVFJ9tfUNMGKI2TEfJ5cD+x5ZzCZLCoVBdP17pJLs5at5sIZN6lfqtyyieCWioPLqOTFM1haNQzIGO+JW/8JlJ8rk98C65r3uuZsL7z53zrFbBulQtRh8Oh6v2wKlVunVAOIWG31L9zoJDyIfLF1rExm7yuAgU1JA2FEeUeAqsYpIZ4lcDFMA0cqjoefJjwQ4247P6y9Io7tyNjdiCfOG3uN2j8NI/bdekuLPNPoCtaj6B8nS/lM3LeKpiQrt1RP3Gz4z6PmKleiuVv+EaeZIzATUspIZJEsZlRqcIrRI1w5u0ThuUfFd42K03aGRsjv953W/1xG84S4ifHZensa/Jgdzxe+3IVW9VoBFYafis/uVHK+Lo2UIt38k5g9ywfYqL99Y5hiaql5dXcbkAq
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(19092799006)(376014)(366016)(1800799024)(23010399003)(10067099003)(22082099003)(261102123227099003)(18002099003)(3023799007)(56012099006)(4143699003)(11063799006)(261026140227099003)(261026121527099003)(261022075727099003)(261021121427099003)(261022105027099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cWQ5NG1HVnNoZm1WQ1UvQWhiVS81a2MxbitTS3NaNEdOKy9MWGFadVY0UGZG?=
 =?utf-8?B?bDR3aGI4S0RHd0ZZQmYzSWl6WUpUS1A4YlR4KzFaSDlPMWZaUnZLZjM0M3lj?=
 =?utf-8?B?Zis0SFJ0YmhRelgrQ2tYSTdFWTJocm5uYk14NktSZFdiMEhMMWNiTWQ0RW00?=
 =?utf-8?B?SlN2aW1oczVYcDgwbjVTOHN4YUl0V3kyUGdKTVJWdUk2UUk4NEUzVUVCSndn?=
 =?utf-8?B?UThpVDdpTW9XVDlLK2ZvZGNsRzc4UG5LRytNZG43RVBFZnRLMXY5ZVdzY1dW?=
 =?utf-8?B?aFlhQjNWckJ6RWsrYzJHK0E5M2liMGpvc2M0dVJJUHo2NFRWR0lxVkRNU29G?=
 =?utf-8?B?UHF0RDNuc2RVQjd1c0p5VnhmL0pZaC96TVFOODBxZnNNRjdCWlZMemxEWGtC?=
 =?utf-8?B?SjZ3RUpieUZIUk5pMmVDZ2VSSHppL3YrWTBoMGNtci9UZTRkQzRTZlQ3QXl2?=
 =?utf-8?B?T0xMUkw3a0htZDJaSFZSN0loaHlncEhlZ1RHRUpFMjRrZzdmRjRHT1d4c1hP?=
 =?utf-8?B?UGFCNFg5ajhXQjliRDF2YmVxR09NYUpqOUx1WmFoUlhTeXN3bDRac09JcGwz?=
 =?utf-8?B?YmI1b3V6VElVTWwrYTJnN3JTdnZ1dEFuRGVlRWI0UWZRaW00Vzh0RUdhbVlS?=
 =?utf-8?B?ZGc5ZEZUNkZuUXY0UVM0R3kra1ZIYTBMMW1PTisyZzhYM0VOQkFORU1SdFp2?=
 =?utf-8?B?UEx1Z1JkV3E0TUxWZ1l3NDZMR1kzSzlndXBHbitxMjREWFE1emlkdVVJK1Az?=
 =?utf-8?B?SUFLS2M1QUJHMFFwQndjQUh3dmxRYnVKRzZPWWpQeUtETEFYa0twMU45QU1y?=
 =?utf-8?B?ZkxMSmtEMjMxanNWRU1nb2xranIvVHpmcG5VWWRwNEFGWkZWTEJyOWxLNHZX?=
 =?utf-8?B?U0tMMCs0Zk84bnZYM3hBc29uWXczMktMNHZWQmhqK1FwT1lhRS9Od3BBRHUy?=
 =?utf-8?B?WWM4b0RkazlxS0U3UitVblhSaFNObTJUWWtEUkdTcXpPNUppdko2MmJmczJM?=
 =?utf-8?B?blR6L1VjMEQ4NWtJZ0sxTmVVNWFtaVRDcWgwM0RBcHIvMVgzVTIzOTdRdGVU?=
 =?utf-8?B?c0lDR29sOUFsK1ZHU2lqa2Q0ajdiZFZzNXl5c215T0tTcGNPbkhVZ09FOU9t?=
 =?utf-8?B?MXQ5N215bm1reDY1b2cvRVVNTk50OC93K0gvVE9KWWhYUlVmaHYySlJtY0VQ?=
 =?utf-8?B?MUtSSndQazV2aE1CUklXelNyZXVxclh1U3hNOTY2OC9adzIwbjFYQVZqSklp?=
 =?utf-8?B?VlNOUm10RGEwb0pkdGVWbVRSekF4MFVIVU5xeDF5L2thdkdXN05HeVZBNmRZ?=
 =?utf-8?B?ZlZnVFhMczdCRnBpeUVwTmtUTG82WVZnVUJuaGhxU0FlenpMaGtrM2dYeS8x?=
 =?utf-8?B?SVJhcXJLdEhRdTNOYzNsY29XZ0FlaUxwUlVORGNlV0tpeENFVGFNWmEzMzQy?=
 =?utf-8?B?UXZ6QVFmbzdROXlGUGFmRnNJQzB6cDBWL09UUHphMDdYSmxPdXQ1Y0VVSCto?=
 =?utf-8?B?UjZ4ZnFaVTVsNnExYmhuM0ZONGptNlFTd1MwQ3FrZFZPeG9VdWxjQ09jRWZ5?=
 =?utf-8?B?akpPSGh6QWJWMGtxWXcvNWYrdzI2c0g4VmF6UHAwbUVxdG0rV3VBMDZrTXZJ?=
 =?utf-8?B?MVhzOHRnWTI4WTdDcG1FVU1OaU5xZ256L3JrOHpaM2p4Qk03bDEvM2ppZ1RC?=
 =?utf-8?B?ZWNQbG05Y0o2SG1YamJla1dDMVRZZ3Z1MGVqMkFKNEVpSGpPd1BSWGRGQnIy?=
 =?utf-8?B?RjlWOWo3SmFyUGRBdHFDanRUanNFWHphQUxZRExzblBKQjk5NDJVZnp1andZ?=
 =?utf-8?B?dWt6U3JzandvYzRHUWlnNU1MRmhDdWRKblY0OEpoZ0l5VENHTWlnYlpMeDRs?=
 =?utf-8?B?MFQ1SXV6ZmkxRjByT09QRVVqVlJiUkVEbVhicUZRYnRJays0SjN0N3prd3hN?=
 =?utf-8?B?QTBpZXJjdTZlQURwNE1lemkveUtLVFZkekMrOXJxTlg3ZnlIWHJIRVJiODhu?=
 =?utf-8?B?NGUyK0UwNlVVYktkdTN5aWVldHpUK0JwTzl3MGJsMnpxNGY2WTBGdzZIVEQy?=
 =?utf-8?B?MmlPMWNmVGNMQW8yN3ZVTUM1VS9va0UzNjlBU2hvMFJFMzNuRWQ0K29qTW1r?=
 =?utf-8?B?WE9PNkxWTWZHYTJSRERiR2FHNzJZb2VlT2lpY3pSeEVwekcxN3crb0MwME5O?=
 =?utf-8?B?ODBGdXBCbFRTRTdnTVBDZkVjVkNKUmJ4NUNZb2lEQlVMMGlxRzd6OFJYTi9T?=
 =?utf-8?B?Mnk1RFE3VDVtWU1wcTM1ZmJBYXZYQ2hoZWhyYTVUWDlvQ1paUzdNMjlnc0tF?=
 =?utf-8?B?cGxBMU1CWGNzVm1OS2RZUWMzWU9oNEZycXlQYjVzSzQ3c2M2QS9TbGFqVzFT?=
 =?utf-8?Q?27SwzsGphfe3tMdA=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3853fa50-786a-4f16-d991-08df39ab7eaa
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:08:03.9852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AK2a5FUofBKA89s/Ce/Ak4uknvMeIQ+XFjKUmdwezJRS7VJR/zCEHl/hu6K2+OI3IVYSnVJTz37gnGURiK2i+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8007

On 10/26/2026 1:11 PM, Krzysztof Kozlowski wrote:
> On Sat, Oct 24, 2026 at 02:25:30PM +0200, Larisa Grigore wrote:
>> Document the UFS host controller on the NXP S32N79 SoC.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> 
> How this could appear in v1?
> 
> Also, your SoB is the last one.
> 

Apologies for the confusion. This was intended to be v9. I will send v10.

Regards,
Larisa
>> ---
>>   .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 65 +++++++++++++++++++
>>   1 file changed, 65 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
>> new file mode 100644
>> index 000000000000..14291c5506f1
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
>> @@ -0,0 +1,65 @@
>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/ufs/nxp,s32n79-ufshc.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NXP S32N79 Universal Flash Storage (UFS) Controller
>> +
>> +maintainers:
>> +  - Larisa Grigore <larisa.grigore@oss.nxp.com>
>> +
>> +properties:
>> +  compatible:
>> +    const: nxp,s32n79-ufshc
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
>> +
>> +  clock-names:
>> +    items:
>> +      - const: core
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - reg-names
>> +  - clocks
>> +  - clock-names
>> +  - operating-points-v2
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
> Why is this empty?
> 
> 
> Best regards,
> Krzysztof
> 

