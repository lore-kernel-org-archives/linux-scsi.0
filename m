Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4115349AA;
	Wed, 14 Oct 2026 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986364; cv=fail; b=sPMp4cGjx4Z+bUszTyfN+qHVeRtp4EKyPMXEQp4hj+ka0mOkqC4bf5NHpfUSUUGdXoRlQtICfaiA7jRlmjVOPBk0BwycZGeCn6M5fMJvOzfrfcMJ6/JfUjhxIjlOiR2noNq82WIdbpLigEJLCIOdMvTfdRRuUhu4gVggC107VJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986364; c=relaxed/simple;
	bh=L67VF11hzBrNmtMmyu0151BdOlpFc/gFcNs77VLrOP4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uaNp/TEtiAotgxZ9tXAIdaFWPVFPFibPO+CdknotzcCujj2JNqWmBXvBmy7J+SnBE8dAtD2WIOoHl+rqV7oZHpN7sQF8cZWiC7WidOjp6S9fry0wqjh9fUJO7dRhJBxZj01ocQJ5L4zGHEHaAoYpp4mFpHDLGwlXaxTa7imWNLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=nQ28/XsW; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="nQ28/XsW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQhXpW5Qs/uH6Q/aB2h7NWiOoq2XBzqptZoVN3KXRvxM1Zomi3RfYKedt6UMdurc/aAVMBh/9uDko9f9riWafhDYRdvLEN1aj2FcBexA182ixW+0av8d1i5ataTnRYLO8BZybroSlacz4sXJY3aKzIIoSJXXaXKoyASmwWUCI+8eEFHtHqovB/O5ikbaSbx+3qpo+540rodj/Zjs1WLPLJ1AUUY+D4/RuPcHJJXiJ4mpk5t5+mmwqu5xg1gQKEuLd7b0qj7Oq77p9I/tK20wzIsnE69djQp+XA95sdcl7WVEmVgsCQOZzolNDIUHoZAYWZNN9+XxPetua+RGRkz+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgRaIH/YHlTXJxWM7KmpKFIPOwCZrOGciOsziv4pPh0=;
 b=TfkEjwhZQaS1BB0g4h7zll31O6HqZGv0hpQsDKl1wIX79PBChnbWI9LrpQcQfCbtijHB0Upi1mmwSHE1LQtXg6D6GEDQHQIayWDvDZXE4B520knPHAT15nFR7s/nJe6xcY0TfxmLwOWApWYxWYYXfSmmpyMoNepZcJiJpqybeLkD9gUz2Y3jcIya8lG4TOHYxZ1FviqVyesq3lO2nsDt17YqrBOKAOkSYgrIDInKWqGdQ7WXGxddJjaI3Mi5ghVDTXXbdmdLgqJSKyP0SBp1je7hq5ZKND3wpXmQBtagzfmYMbMGLW/odHWK81coApPDUT+WYqMXzBi8EA9DtlcsxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgRaIH/YHlTXJxWM7KmpKFIPOwCZrOGciOsziv4pPh0=;
 b=nQ28/XsWjflPVZI8LNspgJV2vpgBN8y4+8QBH6gcxLAcBp9dP0igZpn0nS5mR5zMWYKIUoKKsWrUNHGHbSZupyBnekzpP+RAjNYfYKn2H3WWkymedLg0f+1wjZFQC/f6l8nvr5NpQIcMRYi+CV3jHlge4DTq83dOlPVDvH+IpGvKgnxKJ5HUwrIghaWM6y7MI6Tp2s+LcVjTwOTEPfY2h5DTOWEprHMcjp+Ppzn4U8Rw4P4wwdYprwZdqdRv5uZaPqd1gZYUqnu3CDUNokoJwgX44KqunjzRy+m/P90Zto7+OCpBs3AXlqWC2qy23szSBj26L3ShhNSpqFXmIkMmGw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MIYPR04MB12551.eurprd04.prod.outlook.com (2603:10a6:290:78::24)
 by ZR6PR04MB642384.eurprd04.prod.outlook.com (2603:10a6:910:e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 13:59:09 +0000
Received: from MIYPR04MB12551.eurprd04.prod.outlook.com
 ([fe80::d6bc:8ad8:510:5fd7]) by MIYPR04MB12551.eurprd04.prod.outlook.com
 ([fe80::d6bc:8ad8:510:5fd7%6]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 13:59:09 +0000
Message-ID: <94283251-e489-453b-9d59-6239ef386647@oss.nxp.com>
Date: Wed, 14 Oct 2026 16:59:05 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/12] arm64: dts: freescale: s32n79: Add UFS host
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
 <20261013103003.373156-11-larisa.grigore@oss.nxp.com>
 <20261014-wonderful-elusive-hornet-c32e5a@quoll>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20261014-wonderful-elusive-hornet-c32e5a@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::9) To MIYPR04MB12551.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 012cb2b0-902a-4143-f2ba-08df29fb51a9
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|1800799024|7416014|376014|366016|18002099003|22082099003|10067099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 uzrpvO9yNFpsUhySbjeHHxlq6dBPxNRjrNIvqJf0xcAyNS7n8K7hagGWc14dA847JQpfLSvQnoJL3GqSh0hEfiD0cXDks87nDugVNYLW8If3/zf8wdkOh8A/6vB9+xFS9OOLQRQokQnRh5lAh6Hdb3kJPuNY3n1zJK141ZHGAtLafe366Jotm1DNYZB3ZRhFFS8MT9zFdWt2J5euqjGuErag+/KDPdFRxCLeNFl8SNUcWIROv2Q5gZ+sGjRSICzEGnPibWvtCfnEsqtxtI6nTPkrQUTMNwC4iSaH8F//wAdyZY4/0bVhLdwRYaTAN74ie+KLfzUdNczuy8C9Y8sWHoDEBfuvpgovTpyjk3sZjEn5dD2joGBARr5Vnii+BGILTQ5An6MyxCAawnHE3dDBibVZ+GXW1ALY9fgP0uZSAO2s0EWbhbh0PV2jy6xYHOjzygd0JeOsdlR48CBt7KLJZ/qPhJy7BaLNUwdxSelr765MJ9xpOxdPN9UH9MHrRORhN/rOLA/QBJU2QDDEaQcEHe4+19m1Mwkf5m0W6o0fiOlgIGdwzR/KsGEup/E7Cno/u6E8BllW6ezPpRGAEfJm6+RrxHdSpHSUB6aDqnnwW23Jr1yUZ6vt3CiNoXaA79zEb+Qis+Jtg85P7z59bmLi1EcrD1zZRBzgUklDpEH+DII=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MIYPR04MB12551.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TDdkVTduODZ5cUFwK0FyMzRNcmN2RHl4dVVXc2p1R3V5T3ZSdUNCN3JUOW5L?=
 =?utf-8?B?aGI1am5kd1RFT25kckdSWG1VVzNmWmlXZ2JqY1FJWElpUC9iY2w1Zlh0anN4?=
 =?utf-8?B?Rk5VS3Q2QTVTeWRhcyttc1Y0RU83b1lVR3BPVytuMmYrdFV4RkR6S1ZCQVZz?=
 =?utf-8?B?c3ZZcFhuVWVhdVZTbVdmQzhoaVR3MzRkcUJjOWhqdmsyTHE4N1cxcml5L1pV?=
 =?utf-8?B?UDNQdXNKd21KdWllTDFlUHEzMWh6RDhzUGcybGdQS2IvMmZubWhneUxiNVk0?=
 =?utf-8?B?eHZSWnk2MFM2aXBLb2s2YkNtSnBTaUN6QlBWUWxjYjRZT1F0S2p6djQ0NWRY?=
 =?utf-8?B?cXQ0ZGdKcVJCL0lmRjFpQUgwNUFqMnM1ZHl5SXNNcXJlTDR1MVVhSk1MT1VZ?=
 =?utf-8?B?N3RndktNbmg1NnF3Y0lUclQrZGRwd3ZxKzU0U1Byb2pmSVpialNpNmFBTEZE?=
 =?utf-8?B?V2xHN0RYa3FIWnRhcVN4SHNyejl6SkpVNnhuZjFnUEdwSlBLaFFsTGxmOVBz?=
 =?utf-8?B?aU5TdU5BZy9YcEFsTEJkOEwzZHVDdlM5eC8zL216V2dxQ0ZiNStaZm1NTVJV?=
 =?utf-8?B?UkdodHg2WHB3NW9tZDJPRmdnZ1cwdDA1UlpvNm5mb1VsYVBmZWd0T21mVXFE?=
 =?utf-8?B?aXQxVU9ZcENHU3JGMnFWSjM3Zmd0UGlSbXp3QkM4dFhjT2N3a25mWGcvZjh2?=
 =?utf-8?B?VWtEMUFiaXo5T2sveGRXSEhFbFk5TTR0SzhaK0tWb2l6TTkrNXpBVnUxQkVh?=
 =?utf-8?B?QkNQWFF3NnhST0lBTnBhaVVMT3RrTzZHY3VYYUo1dGZoRjkvNmsvclVWbW95?=
 =?utf-8?B?WEVUc3V0RlJTMEdOYnpNQ2Vvd2dXN2lGOTVKL0U4T1g4WCtPYWhpQms0VjlS?=
 =?utf-8?B?UjlyYUJiR3NXc0J4QzR0Nkh3OWlsbTZMaDJLcS8zcHEvUzJZMnBkNGVrSDJM?=
 =?utf-8?B?TzJKZXVvQzF4dDdmRWpTbE9mUndYNWdISUtkWkpGa3BPNnhFK3ZqMng2djcy?=
 =?utf-8?B?a1hrK2xQNmFwUEdUQ3pTU3hreUV0YkdDOTVOalNDclRRL21JcGhQNGxMenpB?=
 =?utf-8?B?OVpCd08zZnVYRWRhYWtBMzZtSFlUS0d6eFpOc3VlNnNsVWdiSFBvUG5tSHpN?=
 =?utf-8?B?dzgwR0xVNTZsU1F4RFhnK0VlU3Ftb001QkRoY21DYXE3OG1VZ3l2eWRsc0lu?=
 =?utf-8?B?d28rMjQrVnRMbFhyVVlSbXhlVFFucGNNQWZnbkhsMzR5UG4xS0gzL1M0MktR?=
 =?utf-8?B?SDliYTV3clRNZzNKbkE2L1M4cHdVMGhPbEpkd2pianh3a0tCckJ5VTRLVG1P?=
 =?utf-8?B?cmw5YzBaMDZQb3JkazAxakc1dm9jRmZDK2U4RVRoWis5d1NjMEJpbjJKdDJP?=
 =?utf-8?B?WXVMUnYrdWpMd2l6UnI3dWRXNnFGVFlkb1JERmFHYnZOdnJOZ0NndXBnSE55?=
 =?utf-8?B?VjE3U1NIV0huaVN6R3hoZ3VFR2RvWW9CRzBCUFExL2s1Tk9sMDUxSTY1NVNQ?=
 =?utf-8?B?bXJTYVd6UFdmSW5TaXJDeUFwVjlQcnlwUnJleTVXcUZMcGZWb2NWdmg0RjNu?=
 =?utf-8?B?QkR1NUcyd3Q5b3licVFBeGY4RGtLWmt0SG5YL2J0Uzg0dExtK2lUV3h0Q3dI?=
 =?utf-8?B?VVJrZGVPRjdJSmVwWjRGYnVQM1Y4bEpsOHBISktOU1BvSDNJeDFYTDZ0TEVm?=
 =?utf-8?B?amZxUThHaEpDWDNLWDIvbWJMQjZIOHk3WmcwRXNiTDQzTHZldVVqVDR1ZW5U?=
 =?utf-8?B?TXE1WEtLNXcrdFVwTTVDcmRCeXh0NktDTTFZNUs3eTVsRk56dzk5VEt4VVRu?=
 =?utf-8?B?Q0hLVzZ0YVpsbWcyaXBWOG5uZi9XNjhnSnJtN3JZWi80U3BVbUVKUUpLZWZx?=
 =?utf-8?B?OXJ0Wm9SdmkxV2ZQRXkzeVJ1SW54Rm5oM0t0aUEzcmxWTklFQS9QTTlseDFQ?=
 =?utf-8?B?NEhnanl4ZE1yWE44aU1lZnBGSTBiMXQ2UGVtVWFBdEE5Q004LzU0SkZoQjRU?=
 =?utf-8?B?dHV3SUFZOU5CMWV1ZHFxNWw4U2JXNmlGdnNJRzhtUjZNdnVsT1Rxa3V5MXBj?=
 =?utf-8?B?L0tYUzFidGo2UFlQR3lubzZIYzBXT3gybzJJdmIzUlk4UXlhUjZQSlZ1RGhE?=
 =?utf-8?B?S0hBYkZHcFNqRENkY3NoaGR2SE9XZ0tZUFB1aFdmMm5xR0drQ3RobUFkWEJ4?=
 =?utf-8?B?cTR5eWVzck45S2d2N3B4TUdRWW10WjZ6cm1paEU4Z1BvTE9lK1dyTGd0Q3lD?=
 =?utf-8?B?c2s3Y1cwVmUzbkNmNzc5bDRNUEFIRXA1YnFRUmZTVTRDKy9FREROMS9pbk9j?=
 =?utf-8?B?d0pXaEVCYU1uMmlwQjJmUUhydDU2TnBXSmN0UDBFMU01Yzd6Yk5yZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012cb2b0-902a-4143-f2ba-08df29fb51a9
X-MS-Exchange-CrossTenant-AuthSource: MIYPR04MB12551.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:59:09.4416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9oGXs5SwVrwYbR866IwWfD22bFIKvw8ToD9Dgx6HcNf1fHElQAsvJpCHQZYNR2JPScHfWsr3sbbfWatWova+WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR04MB642384

On 10/14/2026 2:07 PM, Krzysztof Kozlowski wrote:
> On Tue, Oct 13, 2026 at 12:30:01PM +0200, Larisa Grigore wrote:
>> Add the S32N79 UFS host controller node to the SoC dtsi.
>> The controller remains disabled by default and is enabled by board dts
>> files as needed.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
>>   arch/arm64/boot/dts/freescale/s32n79.dtsi | 24 +++++++++++++++++++++++
> 
> DTS shouldn't be in the UFS patchset as they tend to grab everything.
> Please split.
> 
Ok. Thank you!

> Best regards,
> Krzysztof
> 

