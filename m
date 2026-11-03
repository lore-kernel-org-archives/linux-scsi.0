Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793711423;
	b=qrg3MEfmOLrL3AjdJOuiYTqcLqntvwUqiO4UZRqOCY+tnr+tJ9sK6wFbPA3v8/TLqNS0
	 SqDzN8hjBimEZV7i5cVN9gPwV41GdpHgyjDldjumV2qAKoowT+gNMlsPhHd9L6AwRReQC
	 uZQj05B0imwNX3RDsTurlq4L1sFCOfsIcSV1HtyRt6tY2ZC0n3qHKxzTiGwfgd6nPleSc
	 PrB6GweHsrhgA8U5zAsxwU8f5Dolk2+B7m1lHgZieDZkWXKsnBwT96uZwYYIfhIK3UkIm
	 7mWG0Kc+jJtbT0aSwuaE9vuVnXRTprNGDTwmn6AQpUgTU04et3enyySjxt+xQRCOBcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711423;
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
	bh=veXguC1CfKrLaZLXQgQAbq0NSZuoxitHZi/raJLFeN8=;
	b=zPRVGpWVEQlnifB5XcY5V3SSOtoWI4+iO2Hk5txaMGAbjtNn9nLunonMthRhWrtlgZWc
	 NZEF/60anKUZjWfAj8T58QaCNa8McBIkvPEcfp3AycSNkxR9Po9InvM53c43x+arRYsyv
	 A4m6qdWKDhPqSnhFsRjNEqUiUB5qfNt4HEI3C6IuLUvPt2214VKWftqB/GzkufrWwQFkx
	 AxUmld4N052acQO7LYce8ZkzMt6PIdiO1Er/t2gEw6u8rTxdkcKjxsVO88LtuRV/cDRhR
	 GIui1aLSzD1B0ZAWN/Lx8wVDMCVTZV3XWGb5x/Rc1Rm6JFqaSTZT5OWXMJ+Kgu8Jraw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=R629nqe9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.71
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013071.outbound.protection.outlook.com [40.107.162.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2B36082BE7;
	Tue,  3 Nov 2026 13:10:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E2B36082BE7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=R629nqe9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lKxQkjSSU343bpjdLduwyWOH1/OKKYzOiW+vZHnlDliX+Igw7BfKELWDCwJ8yGSCzQtHVjBbicK09tXePtDCLgn1qLfhKJQ5nO80VSzrpyUP7vwDnMx+fAHsE3MPPwrMPz7mDiAv6tCm9T1EuUs//PaDjBskWY1dLjwR0IDLnX+psXB5g+IyDKxY+GGevKNy9sfo0UirhENDYmOuvPNTCHqVnoEpFLLPFw85uZyr12nWQ50V1id9cLm5WRB/8vndW71bC9bXWeJ/ZAaSu2luux0+rbSEiAIY0dOXr5msaBtYnRQYdh4a1vCCZJTgvECGzh3GVO7LlZNA7y6VrkrPZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veXguC1CfKrLaZLXQgQAbq0NSZuoxitHZi/raJLFeN8=;
 b=D5HwSzfo5NzIy37FAG3nNw83lLI0nvTzvXTRdRxQWs9i4TsB5EQFfIX4xXJ8Ig+4k/pg7CgYrAB+C3HxtCj9F3Dqg4AuFMosmaptWZ4Yq2BhoJn1S3W6ji24Jwe9/vXaGzfnfJ5BFmQ0HMyjjeTm2X80Z1KAGnMcntIVQNo0VjZK0koj5uQ7ZBgHte3Z3RUXqNxsVwa6a1MS8iQxJ6zP9H8otcTQB+L4JMzcITQxjyKA5JP4CA2pTEtecCO8XHRR+qdCB8FpgzYG94Ng9QTnmPT24pMJxMnSxzpVC1FQyLaEGSYK7tP9ZOPgXWEvPKgz3FEVOXvv/DG/FrLYJ6R68A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veXguC1CfKrLaZLXQgQAbq0NSZuoxitHZi/raJLFeN8=;
 b=R629nqe9VeS3u5PM9FbSsqedfPNUlNu5Vj2BzJSm0w56naAnrFBDRNPymAKWiVFT70JMxkcXlNP6/41Gfz5UMUe+2m/0s4IX+T2kc5wEx/i0dGxlsMazvtrt/omqgS/8Ww74EthjyrhIBm7SKn5OmmE24HdqiqRyB40ZMBoezun8LNzZ/Ki+NFaydq03bh8jzBboVORcYSklKCuqdXesI5dRkbQkaAlfTl0ohU4qIBBfse/G2GzlAGrmepUMI1sVUl5gyAuJ8yw59Svp4VPr+UkVIb1vqyoWS0kSrdo3vp8wM7JHWCJKaSTxoBMaiPHRYW1On2tZ9v1vrYCXaRXvtA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU0PR04MB9561.eurprd04.prod.outlook.com
 (2603:10a6:10:312::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:10:16 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:10:16 +0000
Message-ID: <275e4894-a7d9-44f2-a7bb-c73f80d05f6b@oss.nxp.com>
Date: Tue, 3 Nov 2026 15:10:11 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] Add S32N79RDB UFS support
To: Bart Van Assche <bvanassche@acm.org>, NXP S32 Linux Team <s32@nxp.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto
 <Joao.Pinto@synopsys.com>, Hannes Reinicke <hare@suse.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com,
 eballetb@redhat.com, echanude@redhat.com
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
 <991fd1f4-b054-42ba-a157-cc9d89dc594b@acm.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <991fd1f4-b054-42ba-a157-cc9d89dc594b@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR10CA0028.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::13) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DU0PR04MB9561:EE_
X-MS-Office365-Filtering-Correlation-Id: 4881d7a5-0c33-4006-2d81-08df39abcd96
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|7416014|23010399003|1800799024|376014|6133799003|10067099003|18002099003|22082099003|261102123227099003|3023799007|56012099006|261028144727099003|5023799004|4143699003|11063799006|261026140227099003|921020|261022105027099003|261009223027099003|261022075727099003|261026121527099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 HDjdg1fYKvW5veW2nBBMjAm2DSWLkb70J59u9zaWkw1pc2DgaEOXYijH2LauqAAnMom5BoZSOImQ728KJs9/IWqVmHEcegQ6MgfOZH0MkHDW2sl3NziLuaMGOSSPbiC4zl/VBGXNEAJhfQvv7qA9ULRcK0y/+t0jrDjxmFe++CsYMBZz46/KSdTe3PqFSNqLASz6DMPHZJkfEphKS3odBKlmP1bOXKQEDpouSKuGDjJF6BpO7UmQI54YGNhZGKVNMdwlUHRqu/DF7TuDSaXy/dcrwfEEAaGk2F72p8GXWHyPDSz9epvJNL79ORbeyNnWspi83Sdnvp3IZzPDmTFkVAIigbw8+g7Og/ivHmAih+hztpTlIJaVzu/BbnRzdXFnnmESYXWF6IOjJiZBckrETzqF5Zow1kz4q4uikc94rLb6Psi1veYG/OrLYOP0AuNFyLgt9ZK6I1T0UcJLKvd4gL6Q0KxNym3lb/Nsjopm1J//noaC0ujq9vRiVWI/oFSjf18j1p6wsf8kDQl582rJeaHhA9oRy1osqXd285sWP6AGI6bUDkZlyYR5MHE4sSOuLEm76c57I8EH4P0kPMz26hDqpHIgy5+oZsVE34pz55UhzOvtz6pqFoppWvXiVeUYarXOH/U3LM4QDl6Ls2Qlp4lwkYkIJTPVgywVD2JDk1+ZgPZA8AZbckTA/0aglchlPbzek/KB6jL8Pq2oUcbOGQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(7416014)(23010399003)(1800799024)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(261102123227099003)(3023799007)(56012099006)(261028144727099003)(5023799004)(4143699003)(11063799006)(261026140227099003)(921020)(261022105027099003)(261009223027099003)(261022075727099003)(261026121527099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QldCN0FQZENVRzRYUWx6TVN0UDNSSWZBRHVBZks3bklITWthUlAxNjBJUWlJ?=
 =?utf-8?B?Q0kyakVSK3cwUXpRSzNsdUgyMi8vdHZPUmk4M0dCbmZBbjVwcFNWSm5pdWIz?=
 =?utf-8?B?dk5GT3Zyd1BDRkVnWGhMV2ZWd3FmelBDdGJiWkFCRlNjY3dkdUgzK0xmTVlZ?=
 =?utf-8?B?SzVaSWpILzh0d2FEWXJGYjQ1SkJTd2IwTDdpQjZYU01aZVdKbWk2MVI4Z294?=
 =?utf-8?B?enpNbTBLamloT1lnOTcvNGlxZ0QyWFRuTGw1dzJseEdIYTZuQmdqUEU1bXA4?=
 =?utf-8?B?a1U0OU9PcEczaHI2dUlpaEJ2RkVNS1FLdnZDeExhMHZrOVB0N21YdWMrKzJR?=
 =?utf-8?B?VUhRd0dnanVKN0VQNHovMTJmc3RySVgzdnF5MDhldUNxMEFLU0RvL2FtREht?=
 =?utf-8?B?aDZhSlBBQ0J4a0l0LzBCTXBsZmFpa3VuVGxhUTdSVjFhcFlaL3g5L1NOVy9L?=
 =?utf-8?B?SzNEbEtWTW1kUnU0akdZcVlBRzFsNVNkU21OWEZ6OHpnVGh5RlZ3VUpkY2ps?=
 =?utf-8?B?ckFXemgrUk1wL2FSbWR1c3htSlEvM1p4RDMvNTQrdXlXYUhIOW9WZldHdHhn?=
 =?utf-8?B?OXFUMG9hVWV6Y25FVzVIeWN2V2ZocUJZNVhhR1pTa2lwRDhSWkdUMXJOcTQ5?=
 =?utf-8?B?UU9TbmQ3MlJLRXFLRFYrZWt4UHNZQjlSazhqN1F3MXFFTG1SdzhOTml1RTl4?=
 =?utf-8?B?NTR0NWRuQ2RCdWVSVzlvZTh4RzdwQ1VobHIxS1ZBdE4zbGRiUUlMRUdQVDAw?=
 =?utf-8?B?V1NpdVBVSkN2M1BwdmZ5T1pQa1ptZFNWTkF6amF3U3VKbW5CYVpyd0Q2VG0r?=
 =?utf-8?B?RCt0YWNlcURHQ1BIQXgzM2dva0poS1dNYzE2MWdBb3RQZEpJY21PamJjMnhN?=
 =?utf-8?B?aEFzbVlzYVVVQzJXM0pXb2JTWHJQcys1M2hHWTZReWJOazJQSnJnT0lRdUc4?=
 =?utf-8?B?MmhEOHU5dVhIdkp2SDlNWEJvWGdOeUNaZjJtRTlxL2Eya0M5MW15SUNnNCt3?=
 =?utf-8?B?N3VUM2Qxa3UwdDNOMjQ3V0dFSXdLU3hkd0lUcWVrUkI4SGJseis0QzRkY2JT?=
 =?utf-8?B?WElZYmE2eVlJUUZnUVB4MGdPVGxtaWZqWDNqWWYreVZBajVrc1RtVGxmTTRF?=
 =?utf-8?B?czJUdEtSMW0zNVpXQ1loUzd5aTE0OTNQRmtQNllCeXlJOXNPU1RqRkM4MW41?=
 =?utf-8?B?ZFhXV0daci9vSGtFbzd2TVliTkdXcUdqS2R0clJHYmlQdnZIZGtRK2lMaWRE?=
 =?utf-8?B?dU9FOFhScTVGL1dwaVVCbFI5WEpWM0htdFJXdUF4dkp6T0xWRm45QmxtcCtD?=
 =?utf-8?B?bk11NW9tQVNFMy9xdGVjN0dyd1JLelljelNwUDNvNk55elZWRUdqZmdTY0hp?=
 =?utf-8?B?ejIyUWhNbW5GM2RlQ253OGZVTTJPenlkaDd2QldoNWpjSzJDYWFYRy9TcEFL?=
 =?utf-8?B?dU10Z3UzckduSzBVSVlHS09IZDhRUllnTGFacmpFRkNhcVUyVnRpRkpLY2Iz?=
 =?utf-8?B?R1kzb1QxV3gvaTN5N0VWeUx6RE9sbHBnYmEra1I0elYrUGhtTXpRM1BwNDZx?=
 =?utf-8?B?UUpsRlRFamo4QXhrVDBXeGpjbVdxMWRiOGp1dDBmNWluaFJWYWtZUU5yVDQ4?=
 =?utf-8?B?RFBFcjFuMXJtYWNiYUlyNEZqTkRFVzJRVk51b2J3ODYzdFY2cGVFSVpRbSt0?=
 =?utf-8?B?Lzd5OEt0UlNyNWFCaHBXTlpSNkJ6UjVNdmducUhJSFZLQ0RuVHZ0V25pZjV0?=
 =?utf-8?B?TFVPa2Mzc0xpdHg1VHZVSFpkU2NDYm5BczltVThJV2xwTVVISGxRS0pvaGtU?=
 =?utf-8?B?VWJZTXowNm1MQUtZaWRnKy9NRmhyRVIzMFVXbmEzN2g3dGJ5eUl5dlhNTnVz?=
 =?utf-8?B?anFZYmdVVXkyOFY5NmhzSm1nL0oxQWxrQ2JPNnJZVDY1cFQ5K2lsM0x5a0Zn?=
 =?utf-8?B?Y2RnRU1QUlZhNlRLajUwdXZ6TDk5Nzl4Q0Z5M2QvTVU0TTF4OEM1VWlKUlhi?=
 =?utf-8?B?N1FCQStxYUVmQm4vR3R5S3ZsNG15R0h6eWpTMzZqRWU3ZEljTisxUzNucTF0?=
 =?utf-8?B?TUw4VXFua0x1TE56ZEdIcE1WSGx0cWpkbjZtQ2tZZkU0U3YzeGczRjlHOEsz?=
 =?utf-8?B?YTh3MTFZcWZNeEtiKytxWG1xUnp3bURJdm01MFdrN0hsUE1NV2tPVzZGM25H?=
 =?utf-8?B?TjRyRnFiNk1RNXY2QUVkS2lUVFZoZXgzdHFoQ3c3NjdFZHpnVU1JK29ya3d2?=
 =?utf-8?B?VzNqbzc3R09sUy90dkJGd3o1NW5iWHNtZWY4ZFgrVmNHUmprT3Z4ZkIrYlZt?=
 =?utf-8?B?RVJTVHV2QzFLVVNSYzJrVHBaTDFmYnh0TlJ1L2ZjR2txNWd1akZNclI0YXh3?=
 =?utf-8?Q?M/rD+7xnnL0QlyzI=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4881d7a5-0c33-4006-2d81-08df39abcd96
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:10:16.2451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LH+++WLxkLWQlIJiO7XeuECYUTX6jLvTmRFd3dGoGnGceoToBp0qoI1dgGtUrSzuzQzqve0BqDBv2OdvqxT1NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9561

On 10/24/2026 5:20 PM, Bart Van Assche wrote:
> On 10/24/26 5:25 AM, Larisa Grigore wrote:
>> This series adds support for the UFS host controller found on the NXP 
>> S32N79
>> platform. The controller is based on the Synopsys DesignWare (DWC) UFS 
>> host
>> architecture and requires S32N79-specific M-PHY initialization/ 
>> calibration
>> sequence. It is compliant with JESD-223D "Universal Flash Storage Host
>> Controller Interface" v3.0, and supports up to HS-Gear 4 speed grade. 
>> It is
>> compatible with UFS 2.1, 3.0 and 3.1 devices. The MIPI UniPro is 
>> compliant with
>> "MIPI Alliance Specification for Unified Protocol", v1.8. The MIPI M- 
>> PHY is
>> compliant to version 4.1.
> 
> Please take a look at the report below. It comes from an LLM and hence
> may include errors:
> ----------------------------------------------------------------------
> 
> ## Main finding
> 
> **Patch 9/10: PRE_CHANGE errors are ignored.** In 
> `ufshcd_link_startup()` the core calls the PRE_CHANGE hook without 
> checking what it returns:
> ```c
> do {
>      ufshcd_vops_link_startup_notify(hba, PRE_CHANGE);
>      ret = ufshcd_dme_link_startup(hba);
> ```
> So if `ufs_s32n7_link_startup_pre_change()` fails, DME_LINKSTARTUP is 
> still sent. That covers an invalid `one_us_tick`, an SRAM_INIT_DONE 
> timeout after up to 3 s, a calibration failure, or lanes not reaching 
> Hibern8. The error codes and the `dev_err()` calls in that path have no 
> effect. Either the series checks the PRE_CHANGE return value in the core 
> (with an audit of the existing hooks), or the commit message should say 
> that these failures only get logged.
> 

ufshcd_vops_link_startup_notify(hba, PRE_CHANGE) is not checked in 
ufshcd_link_startup(), and this applies to every host driver, not only 
S32N79. Because this is core behaviour and not specific to this driver, 
I would prefer not to change it in this series. A fix in the core that 
checks the PRE_CHANGE return value can follow as a separate patch, so 
that it gets reviewed on its own and does not hold up this driver.

> ## Per-patch comments
> 
> **Cover letter / all patches**
> - The subject says `[PATCH 00/10]` without `v9`, but the body says 
> "Changes in v9". It should be `[PATCH v9 nn/10]`.
> - Patches 1, 5, 6, 8 and 9 start with `scsi: ufs:`. Drop the `scsi:` so 
> they read, for example, `ufs: dwc: …` and `ufs: s32n7: …`. That matches 
> patches 2 and 3 (`ufs: unipro:`).
> 
> **Patch 4/10 (Hibern8 TX FSM polling helper)**
> - The prefix is `ufs: host:`, but the helper is added to `drivers/ufs/ 
> core/ufshcd.c`. It should be `ufs: core:`.
> - The commit message names `ufshcd_check_hibern8()`, but the function is 
> called `ufshcd_dme_check_tx_hibern8()`.
> - "Unlike the initial implementation, the timeout error is now reported 
> only once…" describes earlier versions. It belongs below the `---` line.
> - Please don't use `extern` in new prototypes in `include/ufs/ufshcd.h`.
> - The HiSilicon and Qualcomm messages used to print the TX_FSM_STATE 
> value(s) when a lane failed to reach Hibern8. The new helper only logs a 
> timeout, so that diagnostic information is lost. Consider logging the 
> lane and its last state.
> 
> **Patch 5/10 (move CREG helpers)**
> - "Dropped `static` from …" is not in the imperative mood.
> - The commit message should say why removing `static` matters. In 
> Versal2, `phy_write_attrs[]`/`phy_read_attrs[]` were static arrays that 
> got modified on every call. Two callers at once, for example two host 
> instances, could corrupt each other's values. The move fixes that race, 
> which is worth stating.
> 
> **Patch 9/10 (S32N79 driver)**
> - **Hard-coded lane count:** `s32n79_reset_config[]`, 
> `pwr_change_phy_regs[]` and the calibration tables only cover lanes 0 
> and 1. But `ufshcd_dme_check_tx_hibern8()` is passed `hba- 
>  >lanes_per_direction`. Use a fixed 2 consistently, or check 
> `lanes_per_direction` in `init`.
> - **Connection setup:** `ufs_s32n7_link_startup_post_change()` repeats a 
> subset of `ufshcd_dwc_connection_setup()`: local attributes only, no 
> peer attributes and no `N_DEVICEID_VALID`. Please explain why the shared 
> DWC helper, or `ufshcd_dwc_link_startup_notify()` with a 
> `phy_initialization` hook, can't be used.
> - **Unexplained settings:** `UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE` and 
> `hba->spm_lvl = UFS_PM_LVL_5` need a reason in the commit message, for 
> example whether power is cut during system suspend.
> - **Includes:** `FIELD_PREP()` and `GENMASK()` are used without `<linux/ 
> bitfield.h>` or `<linux/bits.h>`. It compiles only because `ufshcd.h` 
> happens to pull them in.
> - **Nits:**
>    - Use `u32 data` instead of `unsigned int data` for `ufshcd_dme_get()`.
>    - `SCM_ONE_US_TICK 0x2CU` has a `U` suffix but `SCM_STATUS 0x30` 
> doesn't.
>    - The comment says "SCM_MPHY_RAM_CONFIG_STATUS" but the macro is 
> `SCM_STATUS`.
>    - The `dev_err()` in `ufs_s32n7_link_startup_notify()` repeats 
> messages that the inner functions already print.
>    - `device_get_match_data()` is called in both probe and `init`.
>    - `ufs_s32n7_remove()` is a wrapper that adds nothing.
> 

Will fix in v10.

> **Patch 1/10:** the change is fine. The `Fixes:` tag is debatable: the 
> old positive return of 1 was already treated as a failure by `if (ret)` 
> callers, so this isn't really a bug fix for stable.
> 
> To check these points I read the code in your local tree (`locking` 
> branch). I did not apply or build the series.
Will drop the "Fixes" tag and will add a new commit which resolves the 
actual problem. __ufshcd_wl_resume will no longer return a positive 
value in case of an error.

Best regards,
Larisa
