Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012061.outbound.protection.outlook.com [52.101.66.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDD33515D0;
	Thu, 27 Aug 2026 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839826; cv=fail; b=LdFwFAXe9Z4souKWKCi/Yg0GOBpRdN85PskB2sBQ7/WNvRambQwOKqnyogk0BsVhJEvPV4JxgGGNTQcW6dUj6Dchmx4fzvNeWRnk0hJdiQBnsnsCYGdEZBkaMHd2RtiS7FDwN7HrvCLunVTwwRu8bT+ole5EqTOmlv97eFvyJqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839826; c=relaxed/simple;
	bh=qeUmFi7JWoZpWfy258za8kSWFFKtAXk3KbiJcqMVqyI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tldyv/R42Ab43rM2j/NA/oQAZKCM5b+BLC6FijxlyuM4vvtxxKUid2FhJXsOQf8mhK5n1EFDbnnpzAs3jOLHUNuyxHtSmozar4RbH4kTGkT0gNd2PA0oQZ7fyjVBZXxkh06HExfeUhwewaKVFu43oy7VMEaW9wEti4BfkvckqKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=MZuFE8h0; arc=fail smtp.client-ip=52.101.66.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="MZuFE8h0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGCKQmKS/1kwaA5TthqiUu9pwnlToc3Iv2YanwGYll7sPlQz2qQzW/HXO2WtmumDjsAa+s0uylfSCtoFRCghyWGqhaBG/2q+wakmnfNMjF3jdsRCj2xhql4O86LtRdu/lOaeIhyNr+LLKdni+nhufbs5yXP3ulASYwhruxRPR0haA0kNih55yClFpUwAbRPWlY8b1au/voTRzWOBV6uubMT7P9f+AaJKUPO5Gje4qQTIPmU7F2zmBbbklIQkQcRCHSk554iLxPi1H7dUWsUodY7JKK60Z3cIA/QkJo3FmYYd82sMXQ2OX1TPbok9xLsmw3QdTsYo9albllKUM3QQPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sChYrqIIYOoi7C4g3Ua19kNgPct5OKFPylLvT9/CFwM=;
 b=aC7LPiSvbyNEtZZ5jofOhVmHrj8JesJcbd1DbL6+aHWCZO2uYr7eHdaFqq7T9RuMqM747mrB5IHBl98jKNzci/vPKoCSVQ0eHFrk/FmjuWD+m9DCI4suTZxtM8eK06JD5BJidUkhGPk9GvBIoNRNm4F+MkKivfV4AQRgrDtmoWUdJIx0gF7jhFU6I6Mwykk41K5ns46O1nu18pK9QSBwKNhvnYbXgJ1RjZBZeuDiu2UqHqbKuf01GGio9ODAvt4zAvTKmjNp3YkD9S5Nt1jSC0m5umSx3HvOlPFfMOb1F23P0MUJ2iZk6fypbqHhhZ9IY4ZINDZEG9NYIq7FlIjcdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sChYrqIIYOoi7C4g3Ua19kNgPct5OKFPylLvT9/CFwM=;
 b=MZuFE8h0QEEZyuK9YGh3KBPJZjsF2Tz7gqdEyE4us09sfwsEzQi8Rp/U8jnKfkX4T4n+5Clob799DLWSWB+QtUNRTLvNQj/IfjpWI0fTV30bYzu+UmISEMbNPL74itTknAvcvwnds18yB9NToDMQXqDf9sqQ/V1shFjUZGMyw7QIPhM89otAPcrUvv+YVo3swSPB0/kwuv9uZBkqyRmY8PRG8mTv85YIYmOuIvwCCQOG1F0P0kmafeDOr8p+nX6C/vPUULx43XLJevn+bQdAFlUvJfVJOCs/pxj18yW1TQSAhVSEcJcLMQbdixTvfhd088jPBuQq2GTDlF1Whd/BHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AS8PR04MB7976.eurprd04.prod.outlook.com
 (2603:10a6:20b:2af::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 14:10:19 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 14:10:19 +0000
Message-ID: <7445c392-0220-48f4-a6a1-ffdd8e21546f@oss.nxp.com>
Date: Thu, 27 Aug 2026 17:10:15 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
To: Bough Chen <haibo.chen@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com,
 aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
 <20260827091440.6iqfhvyihrxqv4bp@shlinux89>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20260827091440.6iqfhvyihrxqv4bp@shlinux89>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0197.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::7) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AS8PR04MB7976:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f5e3997-3c26-40e1-cf64-08df0444ecfc
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|19092799006|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 qMrjYxOM0TXnZwWUpdtkE3mtcFhuSbBMltB0v+K/pAz0Lpo7WPS/ZwoCI9HmUoYRiX6Tfvo+N6u9cWo5MjBit+g5Va+8MMXl4+tETyvok+D76uVTmMbb8//PuO98VmR0po2q5xxeIoj1H6iy8orMscs8OSyhc2wr5CwBZ5N9TRLrsKz1LGo8rcKklP36rrlginy0PlozJtxWyJBev3SKmueNQNhJjCMoEBOjX6doJqUvqOhCoQmbPe/Kt6fp+ntpwdVqzLr53ZU5kl9HdHR8J9uwYZcruDmM8vEmV6B0klvfb9viHJPtGNqZsrXVkLtIEEwuWiTKok1iNAnoU7tb1vhVoJvK0jYw9xNL9FwYypD+TbugiXME1QLbWy7aE63TJDpmo5fMrT11NN2wbH1JU8vug6SLllWZamE/fxLuLikbU0ElvcFxe4oMhVPjRGhrccZMmdw8PiRMnviv9BfKz+Bi51aUSQTNY5I1UC6/rOiGsJaE+vM119HXCBJvapnvLVKIKwf7CamxtQKMxEC4f5VKlahEvkjIy3wtWNqxgLNbuts3ylxFm11XWhLaDNHBmpoJYwd5c5YJgcukQlNr7L4FSk9w6JcfsYwcChp/P2ZtfJ+AlfZBKHWq65Au28rsqXU0SDHYkGK1wUt2O1tQNLsUxma0UAOCY92CH6v2GAQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(19092799006)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ODdvL0pZZW9uTkQwYlhiWDU2cVJ0Ymw5V3pHT1hZUmgveXVLZThNR1dXNU5S?=
 =?utf-8?B?QTMvVnltUU5mcTd6Uk0vcWFsRGk1V1FaN1RaMmhvdU4rclhicGpnZHNPVXUy?=
 =?utf-8?B?ZnpKcG5JT0JpdGdJTEtjdVdwRGFpWllCTTZxZWRGZlRNdVY3cUFneEQwNUFz?=
 =?utf-8?B?eHZzaE5HU241Y2Joc043dmIyOXpEQ0g4VFlwQlE3NjRabHdvb0JoNU5zNTBu?=
 =?utf-8?B?eTVuUU5tMGhNQm5Dc3hFVDczcy9vR3RhK2lKb3VUZTFlR3VVM2RtMldEbGNB?=
 =?utf-8?B?N0p1YWp6YnIrV0t3WGNRSzVPR0JWSWV5UzZCZFJzU0lnNEhMdlY4Y1lQMXdZ?=
 =?utf-8?B?UDNpWVR4TXBTTFpZV0hZTnR2ekpvb0hwbjBhMUVxV3BjWUdUSHB1NTQzQ3Ur?=
 =?utf-8?B?dmZCVml2ZVlRZzdLcERnK0o2V0lEQWJIMXpOZG1nd25MUmRxZjB0RUVhdkpO?=
 =?utf-8?B?V3ZKeGZXeGNwak9WU0tBRDE0dmpIc0JsemFNR3pySGpQbCtJYTlSWHdTeW5s?=
 =?utf-8?B?NmV5YlpQYXBhRFNTeWNyeER6M2xBMXZRcUYrTHVoVGJCRFQ2UFAxYi9QQ2xS?=
 =?utf-8?B?ZHpCWEE3M0V5N3BReTZzNTY3YnllYkhJcFp5Z0prQk5iWU55RDFra0dsdWI0?=
 =?utf-8?B?aWdiYy9XNzhPajE4VHc1MnN0b2NYbU1KNkRvUFZLdzUzREVHc3dTdFVJVUZX?=
 =?utf-8?B?K2cxUnlERzI3Sm5oWHpxVlhMMnVPb0NIZ0I5NmdvZytKOHBRZ2RNbVdNZnpD?=
 =?utf-8?B?ZnAzcjV6ZVFQR1diZU14b3V3NDRqWm5yckJvY2MrTVNIZmlycjhpV3Rwa2I2?=
 =?utf-8?B?UzZ6Mno4NDF2TW9mR2J1eThZTENFVnBIQmVYbGZGQ1FrWUlFOEZPYWZqVlBI?=
 =?utf-8?B?ZVRCMTgvQWJKQ20wRkFab2NXS003T29aYnYxN3pSYmFhS3JsL2lKd0k0S2U1?=
 =?utf-8?B?dUVucXJISXlQVklQakl4S0N6eEpjVWRRdUx5cEdZQTVocjc0Z2ovV1MyVjE4?=
 =?utf-8?B?Nzg1bnRIV3hPMk9xemE4eTJJYnpucVBQcW83MVBOcktIeG1aWUFTMzNhMFFi?=
 =?utf-8?B?OGI1RVIzZzJBc2RWVEovYXVXcFlGSXk3Wk9sZmdHcGYzenAzMWcrUXNWZkFi?=
 =?utf-8?B?VHYzWUZ2MFpHSnZoNW05c1hVQ0dQWWN1QndLRWVldHFzZkJuQjJWLzdseEhB?=
 =?utf-8?B?aVU3TUhFRU4xeHpJVVZzS1g0d2N4K29kdEN6M3k5UE8zczVGM1lSR1pYTzJD?=
 =?utf-8?B?Qi9jeFVlUDRZRzJOak9tK1BTemNCTlhuYWt4aGpYZnZ0Yk1YS1EzTWRQUmph?=
 =?utf-8?B?bUhOWGxQTFMrRldIcTFPYmkwN3FlS2c5TnRhM2hFdFZWQytzVWMzUjlidlNl?=
 =?utf-8?B?WFhQRXhidDJiRGI3QmVyVCtmanNPN090R1VTd04wbFBWc3J3dFN0b1lxNmcz?=
 =?utf-8?B?TGtoazk5Sno1SlNTSEpqSGpnamJJT1VSYmZvRE9tV0lCQUVpSXBXQnBqVGJZ?=
 =?utf-8?B?UzB0dFR5bTdiZVgvUlNnRW44MHk1R2MzOHJ0dmIzSm9JNnBCVEVZWWYvOXlE?=
 =?utf-8?B?NE9wM1NLb2lVTVpzNFdXdjA5dU9EOVFDczQ2aGRRY01YczdNdXM2bURYc0ho?=
 =?utf-8?B?a2c4QXpFNDlwMHhrL2RKVndPckkwUDI5SzNxOU9sajdtVzlMUUZLbGlCS3NJ?=
 =?utf-8?B?WExsRjYzakovS0dxclNyK0lMYmdyWjVrZnk1bjkrTWlwM2RNWW1BQmJ1QTlm?=
 =?utf-8?B?amVGM1YvMjE4UDR4NzYvUldzckJUU1ZrN0cwS2NVQTQ0UVhXb3ozNFpMbEha?=
 =?utf-8?B?VVN0UmY0VmErbDJkeS90NmhDZVpsUFBmczd4VGVnQUNPeGhERzV6cU5NRFJS?=
 =?utf-8?B?UzkrR3FSTVhDbGpLNVh1a3RMSkVsRkxiNWtuWWN6dGhCaGVXWk9zM0pXQmRR?=
 =?utf-8?B?YjN3Q0FTVTBJVmdCTHZXaFJjcjBpRjBWZjB1Tk0wdzVOUjRjYmN5OWgxZkhm?=
 =?utf-8?B?eHdNTk82SzdBc2lmeGNRS2tIWmhPRzgreFVFQ01xbGE2QUlSVU11aW9RQzdj?=
 =?utf-8?B?alErQ3JDOVppS2RWYWVKcDIxdWpmOE1CK3pwRVFMZTIzR0ZVY2RlOWpSVk5G?=
 =?utf-8?B?cXFrLzlIZnYzRlc3TStEeW82VTNoUEQ5R0JWTHFsOTRMVE9zMzZyOXZ1NGN3?=
 =?utf-8?B?aVJRaVR0bjVLLzNFVGxybzVKSHBjLzZSOWl0bWdvTnJqWlB5aTZMRjJEOU1B?=
 =?utf-8?B?NnpvL09lRmwvU214Nzh1YnhpZWMwTFo1RWZvY1U2NWtsNGZVckVzYzEyWFQ4?=
 =?utf-8?B?WWN4UHRZb1BodE9zdGRQa2JuOTVRTVIrWnArY3FpbEx3V25NRkI3clVhc1ZM?=
 =?utf-8?Q?z95H87oZeLEQffUw=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5e3997-3c26-40e1-cf64-08df0444ecfc
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 14:10:19.1326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pr16AgZCx5K+t2GdRVregYupXN4qPH3jV/AM0Kq+TXIa3yOxhJaZclWL9o1G75rEck9frgMnyCgPYUw74j+CZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7976

On 8/27/2026 12:14 PM, Bough Chen wrote:
> On Wed, Aug 26, 2026 at 03:40:41PM +0200, Larisa Grigore wrote:
>> Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
>> enter Hibern8 into ufshcd_check_hibern8().
>>
>> The HiSilicon and Qualcomm drivers currently implement similar checks
>> using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
>> this logic to a common helper in ufshcd-pltfrm so it can be shared
>> across host controller drivers.
>>
>> Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
>> their local implementations.
> 
> The code change the error return value for qcom and hisi, better to point this
> out like the following, so that QCOM/HISI guys may pay attention on it:
> 
> "While at it, normalize the "TX lane failed to reach Hibern8" error path to
> return -ETIMEDOUT instead of the raw TX_FSM_STATE value (qcom) or -1 (hisi),
> so all callers get a proper errno. This is an intentional, harmless change of
> the returned error value; the pass/fail behaviour at the call sites is
> unchanged."
> 
> Regards
> Haibo Chen

Thanks for taking the time to review this patch series! I’ll address it 
in the next revision.

>>
>> This also prepares for reusing the same UniPro-specific Hibern8 check in
>> a subsequent commit.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
>>   drivers/ufs/host/ufs-hisi.c      | 48 +------------------
>>   drivers/ufs/host/ufs-qcom.c      | 42 +----------------
>>   drivers/ufs/host/ufshcd-pltfrm.c | 79 ++++++++++++++++++++++++++++++++
>>   drivers/ufs/host/ufshcd-pltfrm.h |  2 +
>>   4 files changed, 84 insertions(+), 87 deletions(-)
>>
>> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
>> index bd223bda1ce2..76d77bc30322 100644
>> --- a/drivers/ufs/host/ufs-hisi.c
>> +++ b/drivers/ufs/host/ufs-hisi.c
>> @@ -22,50 +22,6 @@
>>   #include <ufs/ufshci.h>
>>   #include <ufs/ufs_quirks.h>
>>   
>> -static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>> -{
>> -	int err = 0;
>> -	u32 tx_fsm_val_0 = 0;
>> -	u32 tx_fsm_val_1 = 0;
>> -	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
>> -
>> -	do {
>> -		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
>> -				      &tx_fsm_val_0);
>> -		err |= ufshcd_dme_get(hba,
>> -		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
>> -		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
>> -			tx_fsm_val_1 == TX_STATE_HIBERN8))
>> -			break;
>> -
>> -		/* sleep for max. 200us */
>> -		usleep_range(100, 200);
>> -	} while (time_before(jiffies, timeout));
>> -
>> -	/*
>> -	 * we might have scheduled out for long during polling so
>> -	 * check the state again.
>> -	 */
>> -	if (time_after(jiffies, timeout)) {
>> -		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
>> -				     &tx_fsm_val_0);
>> -		err |= ufshcd_dme_get(hba,
>> -		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
>> -	}
>> -
>> -	if (err) {
>> -		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>> -			__func__, err);
>> -	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
>> -			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
>> -		err = -1;
>> -		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
>> -			__func__, tx_fsm_val_0, tx_fsm_val_1);
>> -	}
>> -
>> -	return err;
>> -}
>> -
>>   static void ufs_hisi_clk_init(struct ufs_hba *hba)
>>   {
>>   	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
>> @@ -224,9 +180,9 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
>>   
>>   	/* Unipro VS_mphy_disable */
>>   	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
>> -	err = ufs_hisi_check_hibern8(hba);
>> +	err = ufshcd_check_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
>>   	if (err)
>> -		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
>> +		dev_err(hba->dev, "hibern8 TX FSM check failed\n");
>>   
>>   	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
>>   		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index b2081ed6197a..c94488661bcf 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>>   	return 0;
>>   }
>>   
>> -static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>> -{
>> -	int err;
>> -	u32 tx_fsm_val;
>> -	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
>> -
>> -	do {
>> -		err = ufshcd_dme_get(hba,
>> -				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> -					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>> -				&tx_fsm_val);
>> -		if (err || tx_fsm_val == TX_STATE_HIBERN8)
>> -			break;
>> -
>> -		/* sleep for max. 200us */
>> -		usleep_range(100, 200);
>> -	} while (time_before(jiffies, timeout));
>> -
>> -	/*
>> -	 * we might have scheduled out for long during polling so
>> -	 * check the state again.
>> -	 */
>> -	if (time_after(jiffies, timeout))
>> -		err = ufshcd_dme_get(hba,
>> -				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> -					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>> -				&tx_fsm_val);
>> -
>> -	if (err) {
>> -		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>> -				__func__, err);
>> -	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
>> -		err = tx_fsm_val;
>> -		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
>> -				__func__, err);
>> -	}
>> -
>> -	return err;
>> -}
>> -
>>   static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
>>   {
>>   	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
>> @@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>>   		break;
>>   	case POST_CHANGE:
>>   		/* check if UFS PHY moved from DISABLED to HIBERN8 */
>> -		err = ufs_qcom_check_hibern8(hba);
>> +		err = ufshcd_check_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
>>   		ufs_qcom_enable_hw_clk_gating(hba);
>>   		ufs_qcom_ice_enable(host);
>>   		ufs_qcom_config_ice_allocator(host);
>> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
>> index c2dafb583cf5..034ee988924a 100644
>> --- a/drivers/ufs/host/ufshcd-pltfrm.c
>> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
>> @@ -9,6 +9,7 @@
>>    */
>>   
>>   #include <linux/clk.h>
>> +#include <linux/delay.h>
>>   #include <linux/module.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/pm_opp.h>
>> @@ -563,6 +564,84 @@ void ufshcd_pltfrm_remove(struct platform_device *pdev)
>>   }
>>   EXPORT_SYMBOL_GPL(ufshcd_pltfrm_remove);
>>   
>> +/**
>> + * ufshcd_check_hibern8 - Check if all TX lanes entered Hibern8 state
>> + * @hba: host controller instance
>> + * @num_lanes: number of TX lanes to check
>> + * @timeout_ms: timeout in milliseconds for all lanes
>> + *
>> + * Return: 0 on success, negative errno on failure.
>> + */
>> +int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
>> +			 unsigned int timeout_ms)
>> +{
>> +	unsigned long timeout;
>> +	u32 tx_fsm_val = 0;
>> +	unsigned int i;
>> +	bool success;
>> +	int err;
>> +
>> +	if (!num_lanes)
>> +		return -EINVAL;
>> +
>> +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
>> +
>> +	do {
>> +		success = true;
>> +
>> +		for (i = 0; i < num_lanes; i++) {
>> +			err = ufshcd_dme_get(hba,
>> +					UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> +						UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
>> +					&tx_fsm_val);
>> +			if (err) {
>> +				dev_err(hba->dev,
>> +						"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
>> +						__func__, i, err);
>> +				return err;
>> +			}
>> +
>> +			if (tx_fsm_val != TX_STATE_HIBERN8) {
>> +				success = false;
>> +				break;
>> +			}
>> +		}
>> +
>> +		if (success)
>> +			return 0;
>> +
>> +		/* sleep for max. 200us */
>> +		usleep_range(100, 200);
>> +	} while (time_before(jiffies, timeout));
>> +
>> +	/*
>> +	 * We might have been scheduled out for long during polling, so do
>> +	 * one final check before reporting timeout.
>> +	 */
>> +	for (i = 0; i < num_lanes; i++) {
>> +		err = ufshcd_dme_get(hba,
>> +				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
>> +				&tx_fsm_val);
>> +		if (err) {
>> +			dev_err(hba->dev,
>> +					"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
>> +					__func__, i, err);
>> +			return err;
>> +		}
>> +
>> +		if (tx_fsm_val != TX_STATE_HIBERN8) {
>> +			dev_err(hba->dev,
>> +					"%s: timeout waiting for lane %u to enter HIBERN8, TX_FSM_STATE=%u\n",
>> +					__func__, i, tx_fsm_val);
>> +			return -ETIMEDOUT;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(ufshcd_check_hibern8);
>> +
>>   MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
>>   MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
>>   MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
>> diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
>> index 0a18a8aed94d..ec2a8013e975 100644
>> --- a/drivers/ufs/host/ufshcd-pltfrm.h
>> +++ b/drivers/ufs/host/ufshcd-pltfrm.h
>> @@ -35,5 +35,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>>   void ufshcd_pltfrm_remove(struct platform_device *pdev);
>>   int ufshcd_populate_vreg(struct device *dev, const char *name,
>>   			 struct ufs_vreg **out_vreg, bool skip_current);
>> +int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
>> +			 unsigned int timeout_ms);
>>   
>>   #endif /* UFSHCD_PLTFRM_H_ */
>> -- 
>> 2.43.0
>>

