Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012059.outbound.protection.outlook.com [52.101.66.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE48946AA6F;
	Mon, 14 Sep 2026 12:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388429; cv=fail; b=dGKoj4WKHNAQoQz/v9aeWHWb8D0ovpXlSMYR5J3gZWRbnvQODmtZOVlZ8tM6JBHl/hmExNM83GFn54yn3UqS3K5Dw3zIj17zHjQG4kU0KuaIoEK0zovjhXelRuv51alzPxqbDB7VImk6LvfrkChcDESR1SoNZc+iP1yYxxtuU5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388429; c=relaxed/simple;
	bh=862zZb6/dEVR01G/7doW3QxDoQHPsfDKsvj/3D9z8jc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vB72yh6+qV1Dctc5g2KVbGAbmO2OmFRs3iIIe0IKbL7sFFr5a6nMfzYFvlWo1XEZk0jJLk8vuvV4fMOWPzh4VcLbVCAN4ZyTuChURZBcYCH0e863vIIHg967fWsizXQKLE5dhXuitHhLaRtpfTODYAMFC9+vAGHQqa4sAyw/pi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=tccDVhcF; arc=fail smtp.client-ip=52.101.66.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="tccDVhcF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wJ7Jb8WpEZcw+Xi4cry2PGB/zkboJdh0JAJacKFg2BxPzu27QGcqcAEAh7WGo23wfnqQEaDqFfjdhGkgdLQY2kVB6vuK+CtBx/8T569i2f5Cd4sjWOep8Z3wNDFCvHkdIJDXonB0NqSZBDEwgSykOP2iuRpHjF8SBEyVd0knRA5WPr/EvyAfnRqiInjAE8ArHhLfK0RSFylApuzkLCi/MeSeU/z+VgxTqTU3NrMScKHtyEFBkcT6KmX+UsRcQZVtvni947TlySHNvpMTMtPqL8er+N8xOjR3t5qgEa2nPctkUXdQvid7ZUpPK04A/fFB7qCAo28xSbBxTyUJHzY9mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cn4ioOhGUN+RmbVATW+fBvTuy4J96LMiyQpBxzr6G4c=;
 b=VCGclBsxIQt1VKS/Pxa21KI1FpCDDWit3Hhk3/mq1jhGpmwDZoGCRy7s8rmuARt9gPRFxzWP6+KgoSZKuV5bkW+O1R4tf57Fa+PCd6aWwTITrLuhT9QaP8pcAtxG2mw8NmzZUyF/mP/EXmkBGP5Mf831gpme+K6VAGTvEs6HWKggneFZYWTp8HXdjbM9ozkL8+unmU5RT/bv/Fzh4Rikc8g0VpqEyf3+OZ0mWA7DZsX7C7OvPvSFvNI6FqP4rzM72U6YwmmfchjJ4duP3jWAaewqYCKXy8E9HKir1JoWWmmnNpCNEHVOFUWgUy0RX/5UxbF3nbLgkUGr/UmZ+QDqGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cn4ioOhGUN+RmbVATW+fBvTuy4J96LMiyQpBxzr6G4c=;
 b=tccDVhcFcBP49YvmBmUH9jD4wCZyOFCiSxDOG7iNhC8p2ez5XZl8IUIZDxMt0ycAtJKObSbQNvrnLh3mkBtmGTNMKWYKFpod8ZO/kS+n8znKsXW+7NYwDWL04JkWGYbHvvp39sGI60mfEsUzkRqeT7joCUDJsIEsrRunJX6WJEc8wwL2KnQSVQG8CJj1eTZ3Z2na3KEOES+KAK6hW7U7TFFmp++heEGWlhmf7H6T4k0FksJUZhaF3WBYpvnMyZs6wNenSuKtn7rwpFXMZ/bMGX07tEe3QE4KTJei7eRI7xbODR3w9Ck3yozIa0ncr7XDn8MccZOhCaGDie5pWZQYiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MIWPR04MB272002.eurprd04.prod.outlook.com
 (2603:10a6:290:e8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:20:22 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:20:22 +0000
Message-ID: <cb5e8a0e-b371-4a77-b023-689c6818b5ae@oss.nxp.com>
Date: Mon, 14 Sep 2026 15:20:17 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
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
 <20260826134048.854748-8-larisa.grigore@oss.nxp.com>
 <20260828092724.m46ftm7daavufuxy@shlinux89>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20260828092724.m46ftm7daavufuxy@shlinux89>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0024.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::16) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|MIWPR04MB272002:EE_
X-MS-Office365-Filtering-Correlation-Id: 9807fec4-c46f-4b1f-8de6-08df125a8c82
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|19092799006|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 manuJ1tx03DAkNVKcVIcplcsAHFTur8kF2GqwMRxdkviC74rMuli67p1KznksQQ/C5y7Gd6f8Tuv8/om/ZRSV95HxGz2XQaA4M9J6+4+O19aocN1B4HuVQPTser2TXDusiuL66Th1N/NQ4Js4vqPwsiX+vPgoixJJu5GztYJRdxDwSO+BKx9XK7vKBJZMi/EbVMr8KdpzpLTp8AXUVy8xKsR/QU4+49/4ASjIonDd7m7Jw2slHAX2QLMQjG9vwT+ll1CCDhGCXNWPNqIVuDyUIhgPfv4jSU0ryaeMlVgqlEw0jrnITupcxmxGY+La9L5DFA11K1LyP+sXreKroyrg/B2QSmj+/lPi+qzzoQ0uyvOPhWqax6WFaY6LgBJ5YLO4OkUJr2oqLOqSLqMgDxDHLSx5VapI+Z9ZAuj1duIEP1pf5otCwc0M8rLhIyUzD5m/lxo96sRnFGynaLV/gGVWnND7QJ0t2R9AMkvSYU/GQBHNlVh0r2AGnwVo1h074NcuqdWRwhb9kXasJsIucEMrGkzpF9xRqZdjuzinmTif4IHaalyIfnumdTwipAUK5fwodOHIfnIzVNNq1Y9o3vigO1btfF4MulQ2rFcpaoLxMP7+88G0voFKxCJcIZEO4hilHIEEAZnLMD9dqDAH//hrYDZMb6vhtnFdsHD4Lk/4WU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SitIM0dVK2lsRlRJRnVWWFhYQjZKWlhIRHRNcmF2bEJJbXpjWEVWdXY2VDdT?=
 =?utf-8?B?UEc1MDUxRVRMSDJPWGU1TTBVRXFWSnFOUmw2bUFDRjZLN0o1NzRDL25DTTdu?=
 =?utf-8?B?RjU0QjN2UEQwc1FhaUZPY0FBdmYwQ3V5eVFwdlh2NGVrR1dyMGpGZFJ5R05u?=
 =?utf-8?B?eTJoa0ljaGlseklWSlRhay9BYUpkRzRqLytINmYzOFZWN05UUFcrcVg2Skhx?=
 =?utf-8?B?bFJ2N1dBa1g3Ym9xanFHbTFwZUFMSkk0bEVnS3ZGUktYTEoxU215VExjSHZa?=
 =?utf-8?B?U0k0ZEc4Zkh1MDE2VEU1OExyRC9XWWxHK0o5MmxoTlpzR2JyaVZrS0QrNUJU?=
 =?utf-8?B?VEZZN2diTGNHeWRIYk4wRFFqOUVBdVA4aGNYanJWbzBmM3dML3lCTWtQRUN1?=
 =?utf-8?B?M01qVXhzbDg3VS9XK2l0ZmRyWWtXN2VlNlZ3WS91UEFES3lLa0NPdkJxQUtZ?=
 =?utf-8?B?Tmg3YXdkeGI4K2RXcS9wVjd5Ti9KMTl5bXU3Z0hyNmk3dTNoVVhKY1h0Nkow?=
 =?utf-8?B?VzVIQitwWTlFRTZITzFDdEFreks2VzFJM2hnWWdRQU9sdmt5WjRhUUM2d3BE?=
 =?utf-8?B?cWsrWUVGM3FweTVVZnlkTEtZY1BqaVBuSlIra3VMUnV3NU0ydlpndEQ3YUYy?=
 =?utf-8?B?N0RDRmlRV3pFbHRKcWgzL3BiRVRGWVl4OFNCcjZDWUt4YituYTBIbWRYL3lD?=
 =?utf-8?B?SzJ4aWQ5dXBsakNGcjM3OXF5VEJHcG5NZ3dnNW9RVlV2RWtxalJ3eXIycHRy?=
 =?utf-8?B?ZEx3RTRNRURYNVlpVGwza0JpV0FmWVJwRFJ6WGJqTmpZN0toL3VOOGNWK0V0?=
 =?utf-8?B?enJWYU16K1dCVG9kbzd5S3VpSk1QODJFdzl5cHN4WFZNb0FVZkJOZmZoUll2?=
 =?utf-8?B?dDlGcUpwdWFFbmk5SXVwMWV2eFQwRVdiajVBT0hxNzRKbnRyRkh5LytKdWlr?=
 =?utf-8?B?d0J5R2N0bXo4OG5IR25XRjlLcUhaNXdUNnkxQUdCMHlRNHROK0NycTZpWDdN?=
 =?utf-8?B?SWRPNFpQVTdFOGtSdVBDK2xaMStoSlVmL0VvbTFrbDZkMGQ0aEcyT0R1V1ow?=
 =?utf-8?B?M045dVBSeUJLS0J5QTREQ2YvSi9JUitRazFYcmtZTE9oYnduNzVRY3hrWG9J?=
 =?utf-8?B?NVF3Mkh2c0h4cUtaajY1UGs4Y3gzRkl6S0ZSY1hKRGovVFpSY1B6NnFXMGN5?=
 =?utf-8?B?TFZZclNwaS91WlhvaUZpSTVXK3c0M29pQk4rYmR5clc4eG41aDJSeWoyRHFQ?=
 =?utf-8?B?dWZ4dDJjQ3pYVmFVcC94eS9xTUxCd3NyZDcwRXZsMTdkckJkN1F1ZGdRbmx2?=
 =?utf-8?B?K2R1Vm9DYWtWekFBcTVhOHp4U3NWbGtYK3QrTnFUQnluOVh5V3huRnZaRFlB?=
 =?utf-8?B?TlJqbXI3MnFQNC8xdVpGcW0zWHVkQ0VvdmZTSVpQZUVMVFh1YjQxRFZxci9R?=
 =?utf-8?B?QjdmeEtFRmQ2U0N5c3ViN0lyblY4YXNyMUdDQllxalNOU29hSXJLakJNMVVO?=
 =?utf-8?B?UFdlbXk3MEpDNjUzeC8vcGlvU0d1RU5lL2ZBb0tCTE1VbURHdURCNVVEOE5r?=
 =?utf-8?B?eE9WcjQxZm83KzBuNUFibER4azFxclM1REZIUkVYMzI1TUc2dW4xb3dmZWE4?=
 =?utf-8?B?WnBSSXIyYzIzcHkxZjNxUnJUVXl5NDJEclhEdjdoejVDQ3owWlhUVkR6QkI1?=
 =?utf-8?B?MUVSVGcrMU9pLzdJVCsrckl3QWNpOEYzSGxiQWRDejJJUEFjQSszbENYZ1lZ?=
 =?utf-8?B?MjE4Nm1RZVN4YzFDemVJK01tMEErTHZuN1llYUZZWHNuUkJuMU5pdmVhc2li?=
 =?utf-8?B?b0gyWTRQRi9aL3ZFMzlVd0FFV1pKT0tsU3VyNFlTTUsybWtpU04yZlRiMlF4?=
 =?utf-8?B?QnN0SDZMQ0Y2VjlXYmtpYlovbDVqanR1eXA2SEdLclVPZC9VN25vOEFadnJq?=
 =?utf-8?B?T3dxU1A4QkQycE9zV3loRngrcnVxTzJRcUZGVisxWTZtZWIvSm51RVpwdnVS?=
 =?utf-8?B?eXdPcDVPWFE3YW5PbWViT0Qrd0h0dzNZdDdCWDEwTXFocWwrVmJOTG9qQzlJ?=
 =?utf-8?B?eXV4WGdUZ0M4WGt4NWxkZkY3T0JUYlJtSXRKMFZKQlFqclBwY0FBOUthU1Bl?=
 =?utf-8?B?OFBpUmY0b1doSmowcDJEU3hRVDQ1alhDci8vaHFKcmtFS1ZjbXdqeG1iQVFz?=
 =?utf-8?B?UkZ2eVlmUTloTzNrN2N1bnIwNFVMZVhUMzY3REZVU1BnalJ3YmJ6NjhKZzlE?=
 =?utf-8?B?dEZMS28yTFo5L29tbXlWRHg5dVZYMndRRHJRQ2FOYmRqSFZKWlN3cVNVKzEv?=
 =?utf-8?B?c3VNNUpNVUVOWkU1ZlBlN3Rla2pvMEdWWEtLUHBQNHk0bW92bXdKUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9807fec4-c46f-4b1f-8de6-08df125a8c82
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:20:22.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqgJnNUC7awQPmEA7LJN0B/X7KLf3HSxaKJUqYA5HL5euvbw8VXmWvne0dybPSV4s37w8a9yG8E9CRXLdfeAsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR04MB272002

On 8/28/2026 12:27 PM, Bough Chen wrote:
> On Wed, Aug 26, 2026 at 03:40:45PM +0200, Larisa Grigore wrote:
>> Add support for the UFS host controller on the NXP S32N79 SoC, built on
>> the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
>> UFSHCD platform glue.
>>
>> This controller requires S32N79-specific initialization prior to
>> UIC_LINKSTARTUP, including:
>>    - programming SCM.ONE_US_TICK and HC.HCLKDIV based on the core clock,
>>    - applying the vendor-defined M-PHY calibration sequence, and
>>    - performing post-link calibration steps needed for HS operation.
>>
>> The M-PHY boot mode is selected via the 'nxp,mphy-boot-mode' device tree
>> property. If the property is omitted, M-PHY initialization is assumed to
>> be handled by external firmware or by a simulation environment.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
>>   drivers/ufs/host/Kconfig         |  12 +
>>   drivers/ufs/host/Makefile        |   1 +
>>   drivers/ufs/host/ufs-nxp-s32n7.c | 464 +++++++++++++++++++++++++++++++
>>   drivers/ufs/host/ufshcd-dwc.h    |   9 +-
>>   4 files changed, 484 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c
>>
>> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
>> index ff170c0b6da0..e8ee7dd05f1a 100644
>> --- a/drivers/ufs/host/Kconfig
>> +++ b/drivers/ufs/host/Kconfig
>> @@ -168,3 +168,15 @@ config SCSI_UFS_AMD_VERSAL2
>>   
>>   	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
>>   	  If unsure, say N.
>> +
>> +config SCSI_UFS_S32N7
>> +	tristate "NXP S32N7 platform driver"
>> +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_S32 || COMPILE_TEST)
>> +	help
>> +	  This selects the S32N7 specific additions on top of the UFSHCD DWC
>> +	  and UFSHCD platform driver. UFS host on S32N79 needs some vendor
>> +	  specific configurations like PHY and vendor specific register accesses
>> +	  before accessing the hardware.
>> +
>> +	  Select this if you have UFS controller on an S32N7 based board.
>> +	  If unsure, say N.
>> diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
>> index 65d8bb23ab7b..0381750a35d3 100644
>> --- a/drivers/ufs/host/Makefile
>> +++ b/drivers/ufs/host/Makefile
>> @@ -2,6 +2,7 @@
>>   
>>   obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>>   obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
>> +obj-$(CONFIG_SCSI_UFS_S32N7) += ufs-nxp-s32n7.o ufshcd-dwc.o
>>   obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
>>   obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>>   obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
>> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
>> new file mode 100644
>> index 000000000000..8a125105536b
>> --- /dev/null
>> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c
>> @@ -0,0 +1,464 @@
>> +// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-3-Clause)
>> +/*
>> + * Copyright 2026 NXP
>> + *
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/iopoll.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +
>> +#include "ufshcd-pltfrm.h"
>> +#include "ufshcd-dwc.h"
>> +#include "ufshci-dwc.h"
>> +
>> +/* SCM Register Offsets. */
>> +#define SCM_ONE_US_TICK			0x2CU
>> +#define SCM_STATUS			0x30
>> +
>> +/* SCM_ONE_US_TICK Register. */
>> +#define SCM_ONE_US_TICK_MASK		GENMASK(8, 0)
>> +
>> +/* SCM_MPHY_RAM_CONFIG_STATUS Register Fields. */
>> +#define SCM_STATUS_PHY_RESET_MASK		BIT(0)
>> +#define SCM_STATUS_SRAM_BYPASS_MASK		BIT(1)
>> +#define SCM_STATUS_SRAM_INIT_DONE_MASK		BIT(16)
>> +
>> +#define SCM_STATUS_PHY_RESET(val)		\
>> +	FIELD_PREP(SCM_STATUS_PHY_RESET_MASK, val)
>> +
>> +#define SCM_STATUS_SRAM_BYPASS(val)		\
>> +	FIELD_PREP(SCM_STATUS_SRAM_BYPASS_MASK, val)
>> +
>> +/* Timeout values. */
>> +#define CFG_MPHY_INIT_TIMEOUT_VALUE_US	3000000
>> +
>> +/* Clock validation limits. */
>> +#define MAX_VALID_ONE_US_TICK		SCM_ONE_US_TICK_MASK
>> +
>> +/* CPort definitions */
>> +#define CPORT_0				0
>> +
>> +/* Hibern8 state poll timeout. */
>> +#define HBRN8_POLL_TOUT_MS      1000
>> +
>> +/**
>> + * enum mphy_boot_mode - MPHY boot mode options
>> + * @MPHY_BOOT_NONE: Skip MPHY initialization
>> + * @MPHY_BOOT_ROM: Running MPHY from internal FW ROM
>> + */
>> +enum mphy_boot_mode {
>> +	MPHY_BOOT_NONE = 0,
>> +	MPHY_BOOT_ROM = 1,
>> +};
>> +
>> +/**
>> + * struct s32n_ufs - S32N7 UFS host controller data
>> + * @hba: UFS host controller instance
>> + * @reg_scm: SCM register base address
>> + * @core_clk: core reference clock used to derive ONE_US_TICK/HCLKDIV
>> + * @mphy_boot_mode: MPHY boot mode configuration
>> + */
>> +struct s32n_ufs {
>> +	struct ufs_hba *hba;
>> +	void __iomem *reg_scm;
>> +	struct clk *core_clk;
>> +	enum mphy_boot_mode mphy_boot_mode;
>> +};
>> +
>> +/**
>> + * struct phy_reg_cfg - PHY register configuration entry
>> + * @reg: Register offset/address
>> + * @val: Value to write
>> + */
>> +struct phy_reg_cfg {
>> +	u32 reg;
>> +	u32 val;
>> +};
>> +
>> +/**
>> + * ufs_s32n_phy_write_sequence - Write a sequence of PHY registers
>> + * @hba: UFS host controller instance
>> + * @cfg: Array of register configurations
>> + * @count: Number of entries in the array
>> + *
>> + * Return: 0 on success, error code on failure
>> + */
>> +static int ufs_s32n_phy_write_sequence(struct ufs_hba *hba,
>> +				       const struct phy_reg_cfg *cfg,
>> +				       size_t count)
>> +{
>> +	int ret;
>> +	size_t i;
>> +
>> +	for (i = 0; i < count; i++) {
>> +		ret = ufshcd_dwc_phy_reg_write(hba, cfg[i].reg, cfg[i].val);
>> +		if (ret) {
>> +			dev_err(hba->dev,
>> +				"Failed to write PHY reg 0x%x = 0x%x (step %zu)\n",
>> +				cfg[i].reg, cfg[i].val, i);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static unsigned long ufs_s32n_calculate_us_tick(unsigned long clk_rate)
>> +{
>> +	return clk_rate / USEC_PER_SEC;
>> +}
>> +
>> +static int ufs_s32n_configure_clocks(struct ufs_hba *hba)
>> +{
>> +	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
>> +	struct device *dev = hba->dev;
>> +	unsigned long clk_rate = 0;
>> +	unsigned long one_us_tick;
>> +
>> +	if (!ufs->core_clk) {
>> +		dev_err(dev, "Invalid core_clk.\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	clk_rate = clk_get_rate(ufs->core_clk);
>> +	if (!clk_rate) {
>> +		dev_err(dev, "Failed to get valid clock rate.\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	one_us_tick = ufs_s32n_calculate_us_tick(clk_rate);
>> +	if (one_us_tick == 0 || one_us_tick > MAX_VALID_ONE_US_TICK) {
>> +		dev_err(dev, "Invalid one_us_tick value: %lu (clk_rate: %lu Hz).\n",
>> +			one_us_tick, clk_rate);
>> +		return -EINVAL;
>> +	}
>> +
>> +	dev_dbg(dev, "Core clock rate: %lu Hz, one_us_tick = %lu.\n",
>> +		 clk_rate, one_us_tick);
>> +
>> +	/*
>> +	 * Configure the micro-second tick rate generator based on core
>> +	 * clock rate.
>> +	 */
>> +	writel(one_us_tick, ufs->reg_scm + SCM_ONE_US_TICK);
>> +	ufshcd_dwc_program_clk_div(hba, one_us_tick);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ufs_s32n_phy_initial_calib(struct ufs_hba *hba)
>> +{
>> +	static const struct phy_reg_cfg initial_calib[] = {
>> +		{ FAST_FLAGS(0), 0x6 },
>> +		{ FAST_FLAGS(1), 0x6 },
>> +		{ RX_DAC_CTRL_OVRD(0), 0x1 },
>> +		{ RX_DAC_CTRL_OVRD(1), 0x1 },
>> +		{ RX_DAC_CTRL(0), 0x8E },
>> +		{ RX_DAC_CTRL(1), 0x91 },
>> +		{ RX_DAC_CTRL_SEL(0), 0x1 },
>> +		{ RX_DAC_CTRL_SEL(1), 0x1 },
>> +		{ RX_DAC_CTRL_EN(0), 0x1 },
>> +		{ RX_DAC_CTRL_EN(1), 0x1 },
>> +		{ RX_DAC_CTRL_OVRD(0), 0x0 },
>> +		{ RX_DAC_CTRL_OVRD(1), 0x0 },
>> +		{ RX_DAC_CTRL_OVRD(0), 0x1 },
>> +		{ RX_DAC_CTRL_OVRD(1), 0x1 },
>> +		{ RX_DAC_CTRL(0), 0x71 },
>> +		{ RX_DAC_CTRL(1), 0x7F },
>> +		{ RX_DAC_CTRL_SEL(0), 0x2 },
>> +		{ RX_DAC_CTRL_SEL(1), 0x2 },
>> +		{ RX_DAC_CTRL_EN(0), 0x1 },
>> +		{ RX_DAC_CTRL_EN(1), 0x1 },
>> +		{ RX_DAC_CTRL_OVRD(0), 0x0 },
>> +		{ RX_DAC_CTRL_OVRD(1), 0x0 },
>> +		{ FW_CALIB_CCFG(0), 0x100 },
>> +		{ FW_CALIB_CCFG(1), 0x100 },
>> +	};
>> +	int ret;
>> +
>> +	/* Clock Control */
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBREFCLKCTRL2, 0), 0x80);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Initial calibration sequence */
>> +	return ufs_s32n_phy_write_sequence(hba, initial_calib,
>> +					   ARRAY_SIZE(initial_calib));
>> +}
>> +
>> +static int ufs_s32n_link_startup_pre_change(struct ufs_hba *hba)
>> +{
>> +	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
>> +	struct device *dev = hba->dev;
>> +	int ret;
>> +	u32 reg;
>> +
>> +	/*
>> +	 * There are two supported MPHY boot options implemented:
>> +	 * - Running MPHY from internal FW ROM:
>> +	 *  MPHY_RAM_CONFIG_STATUS.SRAM_BYPASS = 1
>> +	 *  MPHY_RAM_CONFIG_STATUS.SRAM_EXT_LD_DONE = 0
>> +	 * - Skip M-PHY initialization when it is handled externally.
>> +	 */
>> +	if (ufs->mphy_boot_mode == MPHY_BOOT_NONE) {
>> +		dev_dbg(dev, "Skipping UFS MPHY init.\n");
>> +		return 0;
>> +	}
>> +
>> +	ret = ufs_s32n_configure_clocks(hba);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Reset SCM.MPHY_RAM_CONFIG_STATUS to default value; keep MPHY in reset. */
>> +	writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
>> +	if (ufs->mphy_boot_mode == MPHY_BOOT_ROM) {
>> +		/* ROM Mode. */
>> +		writel(SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1),
>> +		       ufs->reg_scm + SCM_STATUS);
>> +	}
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBCRCTRL, 0), 0x1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Release PHY_RESET. */
>> +	writel(readl(ufs->reg_scm + SCM_STATUS) & ~SCM_STATUS_PHY_RESET_MASK,
>> +	       ufs->reg_scm + SCM_STATUS);
>> +
>> +	/* Wait until SRAM_INIT_DONE = 1. */
>> +	ret = readl_poll_timeout(ufs->reg_scm + SCM_STATUS, reg,
>> +			reg & SCM_STATUS_SRAM_INIT_DONE_MASK,
>> +			1000, CFG_MPHY_INIT_TIMEOUT_VALUE_US);
>> +	if (ret) {
>> +		dev_err(dev, "UFS MPHY init not done!\n");
>> +		return ret;
>> +	}
>> +
>> +	/* Start of initial calibration */
>> +	ret = ufs_s32n_phy_initial_calib(hba);
>> +	if (ret) {
>> +		dev_err(dev, "UFS MPHY initial calibration failed!\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYDISABLE, 0), 0x0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Set Local DeviceID. */
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
>> +	if (ret)
>> +		return ret;
> 
> N_DEVICEID belong to network layer of Unipro, set DEVICEID in pre_change seems
> too early. link startup still not done, so unipro link still not up.
> I suggest to move this DEVICEID to post_change, and just before CPort, so that
> the whole config sequence is: Mphy -> PA -> DL -> N -> T, from down to high.
>
Correct. Thank you for the review!

>> +
>> +	/* End of Gear1 settings */
>> +
>> +	return ufshcd_check_hibern8(hba, hba->lanes_per_direction,
>> +				    HBRN8_POLL_TOUT_MS);
>> +}
>> +
>> +static int ufs_s32n_link_startup_post_change(struct ufs_hba *hba)
>> +{
>> +	static const struct ufshcd_dme_attr_val cport_setup[] = {
>> +		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
>> +				CPORT_IDLE, DME_LOCAL },
>> +		{ UIC_ARG_MIB_SEL(T_CPORTFLAGS, CPORT_0),
>> +				CPORT_DEF_FLAGS, DME_LOCAL },
>> +		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
>> +				CPORT_CONNECTED, DME_LOCAL },
>> +	};
>> +	static const struct phy_reg_cfg post_calib[] = {
>> +		{ RX_OVRD_IN_1(0), 0xc },
>> +		{ RX_OVRD_IN_1(1), 0xc },
>> +		{ RX_OVRD_IN_1(0), 0x8 },
>> +		{ RX_OVRD_IN_1(1), 0x8 },
>> +		{ RX_OVRD_IN_1(0), 0x0 },
>> +		{ RX_OVRD_IN_1(1), 0x0 },
>> +	};
>> +	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
>> +	unsigned int data = 0;
>> +	int ret;
>> +
>> +	if (ufs->mphy_boot_mode == MPHY_BOOT_NONE)
>> +		return 0;
>> +
>> +	/* Set Connection State to IDLE (it allows CPort Attributes to be set). */
>> +	ret = ufshcd_dwc_dme_set_attrs(hba, cport_setup, ARRAY_SIZE(cport_setup));
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0), &data);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (data != CPORT_CONNECTED)
>> +		return -EIO;
>> +
>> +	/* Post Link Startup Calibration sequence */
>> +	ret = ufs_s32n_phy_write_sequence(hba, post_calib,
>> +					   ARRAY_SIZE(post_calib));
>> +	if (ret)
>> +		return ret;
>> +
>> +	/*
>> +	 * Performing MPHY configuration for rate change:
>> +	 * CB rate selection: 0 - rate A, 1 - rate B;
>> +	 */
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBRATESEL, 0), 0x1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
>> +	if (ret)
>> +		return ret;
> 
> Should the rate change operation be moved before post link startup calibration sequence?
> in post link startup calibration sequence, it reset the RX CDR, but thie CDR reset should be
> based on the target rate B, right? If do the RX CDR reset first, it is based on rate A, then
> when swithc to rate B, seems need this RX CDR reset again.
> 
Indeed you are right. I will move this operation accordingly. Thank you!

> Another question is why need to switch to rate B here in link_startup_post_change?
> after link_startup_post_change, common code will call
> ufshcd_dme_change_power_mode {
> ...
> PA_HSSERIES = PA_HS_MODE_B;
> PA_PWRMode = FAST_MODE << 4 | FAST_MODE;
> ...
> }
> 
> In the standard DesignWare (DW) UFS IP design, when the PA_HSSERIES value in the PA layer
> changes, the M-PHY rate selection register (CBRATESEL) is automatically synchronized by
> hardware. No manual software intervention is required.
> 
> Does this rate B change here really necessary? or there are some hardware limitation on
> S32N79?

I also verified whether the explicit CBRATESEL programming can be 
removed. On S32N79, setting PA_HSSERIES to Rate B and completing the 
power-mode change updates PA_HSSERIES and the TX/RX lane rate attributes 
to Rate B, but CBRATESEL remains at Rate A. The link later becomes 
non-functional.

>> +
>> +	/* End of Gear4 calibration */
>> +	return 0;
>> +}
>> +
>> +static int ufs_s32n_link_startup_notify(struct ufs_hba *hba,
>> +			     enum ufs_notify_change_status status)
>> +{
>> +	int err;
>> +
>> +	if (status == PRE_CHANGE) {
>> +		err = ufs_s32n_link_startup_pre_change(hba);
>> +		if (err) {
>> +			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
>> +			return err;
>> +		}
>> +		return 0;
>> +	}
>> +
>> +	/* POST_CHANGE */
>> +	err = ufshcd_dwc_link_is_up(hba);
>> +	if (err) {
>> +		dev_err(hba->dev, "Link is not up.\n");
>> +		return err;
>> +	}
>> +
>> +	err = ufs_s32n_link_startup_post_change(hba);
>> +	if (err)
>> +		dev_err(hba->dev, "Connection setup failed (%d).\n", err);
>> +
>> +	return err;
>> +}
>> +
>> +static int ufs_s32n_init(struct ufs_hba *hba)
>> +{
>> +	struct device *dev = hba->dev;
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct device_node *np = dev->of_node;
>> +	const char *mphy_boot_mode;
>> +	struct s32n_ufs *ufs;
>> +	int ret;
>> +
>> +	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
>> +	if (!ufs)
>> +		return -ENOMEM;
>> +
>> +	ufs->hba = hba;
>> +	ufs->mphy_boot_mode = MPHY_BOOT_NONE;
>> +
>> +	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
> 
> why broken auto hibernate here? or meet any issue when enable auto hibernate?
> Better to add a comment here.

At the time these patches were created, Auto-Hibern8 was not functional 
on S32N79. We have since resolved the issue and verified that 
Auto-Hibern8 works correctly. Therefore, this quirk will be removed in 
the next revision of the patch series.

>> +	hba->quirks |= UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
>> +	hba->spm_lvl = UFS_PM_LVL_5;
> 
> Any reason why not support LVL_6? Does this chip do not support reset pin?

The controller is completely powered off during system suspend and is 
fully reinitialized during resume. Therefore, we use UFS_PM_LVL_5, which 
is sufficient for this suspend/resume sequence.

> Regards
> Haibo Chen
>> +
>> +	ret = of_property_read_string(np, "nxp,mphy-boot-mode", &mphy_boot_mode);
>> +	if (ret || !mphy_boot_mode) {
>> +		dev_dbg(dev,
>> +			"nxp,mphy-boot-mode property not found. UFS MPHY init will be skipped.\n");
>> +		goto init_out;
>> +	}
>> +
>> +	if (!strcmp(mphy_boot_mode, "rom")) {
>> +		ufs->mphy_boot_mode = MPHY_BOOT_ROM;
>> +	} else {
>> +		return dev_err_probe(dev, -EINVAL,
>> +				     "Unrecognized nxp,mphy-boot-mode property. UFS MPHY init will be skipped.\n");
>> +	}
>> +
>> +	ufs->reg_scm = devm_platform_ioremap_resource_byname(pdev, "scm");
>> +	if (IS_ERR(ufs->reg_scm))
>> +		return dev_err_probe(dev, PTR_ERR(ufs->reg_scm),
>> +				     "ioremap failed for SCM registers.\n");
>> +
>> +	ufs->core_clk = devm_clk_get(dev, "core_clk");
>> +	if (IS_ERR(ufs->core_clk))
>> +		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
>> +				     "Failed to get core clock.\n");
>> +
>> +init_out:
>> +	ufshcd_set_variant(hba, ufs);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct ufs_hba_variant_ops ufs_hba_s32n79_vops = {
>> +	.name = "s32n79",
>> +	.init = ufs_s32n_init,
>> +	.link_startup_notify = ufs_s32n_link_startup_notify,
>> +};
>> +
>> +static const struct of_device_id ufs_s32n7_match[] = {
>> +	{
>> +		.compatible = "nxp,s32n79-ufshc",
>> +		.data = &ufs_hba_s32n79_vops,
>> +	},
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, ufs_s32n7_match);
>> +
>> +static int ufs_s32n7_probe(struct platform_device *pdev)
>> +{
>> +	const struct ufs_hba_variant_ops *vops;
>> +
>> +	vops = device_get_match_data(&pdev->dev);
>> +	if (!vops)
>> +		return -ENODEV;
>> +
>> +	return ufshcd_pltfrm_init(pdev, vops);
>> +}
>> +
>> +static void ufs_s32n7_remove(struct platform_device *pdev)
>> +{
>> +	ufshcd_pltfrm_remove(pdev);
>> +}
>> +
>> +static const struct dev_pm_ops ufs_s32n7_pm_ops = {
>> +	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
>> +	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
>> +	.prepare	= ufshcd_suspend_prepare,
>> +	.complete	= ufshcd_resume_complete,
>> +};
>> +
>> +static struct platform_driver ufs_s32n7_driver = {
>> +	.probe = ufs_s32n7_probe,
>> +	.remove = ufs_s32n7_remove,
>> +	.driver	= {
>> +		.name	= "ufs-s32n7",
>> +		.pm	= &ufs_s32n7_pm_ops,
>> +		.of_match_table	= ufs_s32n7_match,
>> +	},
>> +};
>> +
>> +module_platform_driver(ufs_s32n7_driver);
>> +
>> +MODULE_AUTHOR("Larisa Grigore <larisa.grigore@oss.nxp.com>");
>> +MODULE_DESCRIPTION("NXP S32N7 UFS Host Controller platform driver");
>> +MODULE_LICENSE("Dual BSD/GPL");
>> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
>> index 53b523ef59df..747383cfb839 100644
>> --- a/drivers/ufs/host/ufshcd-dwc.h
>> +++ b/drivers/ufs/host/ufshcd-dwc.h
>> @@ -13,8 +13,7 @@
>>   #include <ufs/ufshcd.h>
>>   
>>   /* RMMI Attributes */
>> -#define CBREFCLKCTRL2		0x8132
>> -#define CBCRCTRL		0x811F
>> +#define RXSQCONTROL		0x8009
>>   #define CBC10DIRECTCONF2	0x810E
>>   #define CBRATESEL		0x8114
>>   #define CBCREGADDRLSB		0x8116
>> @@ -24,10 +23,16 @@
>>   #define CBCREGRDLSB		0x811A
>>   #define CBCREGRDMSB		0x811B
>>   #define CBCREGRDWRSEL		0x811C
>> +#define CBCRCTRL		0x811F
>> +#define CBREFCLKCTRL2		0x8132
>>   
>>   #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
>>   
>>   /* M-PHY registers */
>> +#define RX_DAC_CTRL(n)		(0x10AF + ((n) * 0x100))
>> +#define RX_DAC_CTRL_OVRD(n)	(0x10B0 + ((n) * 0x100))
>> +#define RX_DAC_CTRL_SEL(n)	(0x10B1 + ((n) * 0x100))
>> +#define RX_DAC_CTRL_EN(n)	(0x10B8 + ((n) * 0x100))
>>   #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
>>   #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
>>   #define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
>> -- 
>> 2.43.0
>>

Best regards,
Larisa

