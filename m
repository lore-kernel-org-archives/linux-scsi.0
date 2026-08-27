Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013060.outbound.protection.outlook.com [52.101.83.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926F54746CF;
	Thu, 27 Aug 2026 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840050; cv=fail; b=icW2DAdR51GeShdKVfM5srpXiBZ06S/bejahHqAixmoPd+4gd0knYH/QjW0ocmMmA6Hlflx5f5MWYbWSQdoYSIWyoavopgUWjBPsH6h2AmoJ464AAsB59pmH8oJPvtOlLO5A3okWN1SR7PxFSAtgGzt8amntBl95NcNeVPjpw1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840050; c=relaxed/simple;
	bh=91QPo66vts7Pqqr8czloNeVpkOVFQzr5aE6RHJtuLPc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mM0P/Pi6ixhlgYCVPM3LTYN6gzIJ44AlM9kWuVc3RCjD5+xVn/CFLdJtLuQNyCricJFO2xz6bz1aJeX0ToYMeXRxt4N0hy8cG27CTqR7eZ1bx+fwwcShX587shZpXaf12720y/VkxR5n38GeljBp210ErPixmw2P5r88tZpDQIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ZbCdWDSy; arc=fail smtp.client-ip=52.101.83.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ZbCdWDSy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iB+te9wuL1iXNL9XQrUCJObJuW/2idZD1qMXtSo3cbnNHR+/VZ8ftNNyMlSGE+T2D/iYnJSqR7xePnPUu9AnHkTXmWV1LXDN60sF7wHJ6vBVmjkV4V18qrE13BBf4vJDIiXk/yIgNlP0pAlmmJUSas1vxpYPGwq2aua04NXOzvAOjI7tvG8Cn0HwSaUAUx8WVdr/2xU7+yiyDJrSvJboETHIFZ+HM7vt/1nx5ix/ludbnzJ0k4gRhE4zzL57zjkjlbE1PwviNAkmka3WNTM+0g0sKL0wlZzYBP4dJbmXTjtEMSp/QupwB5OWfHRb/VxhaFy5eiVit2loBpofMG9peg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ksGma107BoK+l4lGFy0ud6UjduEEno9VMQuCY4JCkWA=;
 b=qQavjr1XNpKD5LhpYZYR0euedwmslUMPWALI6D+zspBIquJf7N7XhTWPO7rMU9PibpVVvZynUKSCxTBdngchlfEeG/jZfvoj1Uv3KP1MK6puo122IRbVkIHNxqxwSLdqnXrpE7NtBLaSMuVXa6V9a0/FK5rP6FOBO0uY9bSmQI9j9GT0cpGK/pXLtnCUba5EK8a7cB02Hbhuw56ejW5uWxPM5kPsszL1kJUKrHzH83lvEAljg+yn00zh0cuK2HF9v9/78adyyt6xHX4r94J28DVGVz9bom6LompD834EzwGYm1cptTMCRhXYenkUBtvCZtgRW6JLBx00npOX/r9nOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksGma107BoK+l4lGFy0ud6UjduEEno9VMQuCY4JCkWA=;
 b=ZbCdWDSycvYtumXi/UYkyc7WHarXYUwZN0+guF4NHqKxZGwW8Ht45/BC4U0Kjg89+ELThEpd/GUZsMU8whS3EFgEmBjFpGs+cCTYHbdjiTPCy/Au+atS5PkymakSff2d0SGi08Vf4y1AXWNCH30FpG8VCQbLm0qHHFZkbpJicKucvyz1/r3pJjU2VC+89jiqzTjEW5AGk7YU/e4O1uM2r+/rw4YUk42kU7Mm4f44aE0MEQn1whSd7g9TG2Y5ktZzPmhur3jRsXPe5LovzY0nNdbp+4LSl8vkaBt0ZvEGTbNY9lElHTrt3s4rDJOLm75hhOFTbWMoldk3S3VkSZ/lhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AS8PR04MB7976.eurprd04.prod.outlook.com
 (2603:10a6:20b:2af::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 14:14:01 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 14:14:01 +0000
Message-ID: <08e24bd7-582c-4141-bc90-4bb19924744f@oss.nxp.com>
Date: Thu, 27 Aug 2026 17:13:59 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] scsi: ufs: Move Versal2 M-PHY CREG access helpers
 into ufshcd-dwc
To: Bart Van Assche <bvanassche@acm.org>, NXP S32 Linux Team <s32@nxp.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
 <378e02d3-bc7f-4c2b-9e48-cb0610e9f421@acm.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <378e02d3-bc7f-4c2b-9e48-cb0610e9f421@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR10CA0007.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::9) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: f52005ca-c915-4dee-570a-08df04457194
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|19092799006|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oVCd3tCuTzG3cAamQ3jON6PNpy+ds+CMDUynupm6LahKZV1TimH9dSYBFG+raLCznHHjclcoKMAdqa4UZNgIGapwArWEYiyU0NBMsuN+FQqXxOHuNM2pED2lbp/M4bzT1ReX5V+PiWeajVzb2kDdlWCDtgbEBUXVmeUDowYpedUmS3Gw8I3m6iGt+pBSy5Ou3w/wo1+zSR2r7aYHBpevL4A1PyjV5bMWAjplt+BzxaoUHk9vsaT0CL3M4JGQPByqEHYTUgeyA5FiWUEc+AtttsY+dDUwdJhe1Css7JGb5O61bJZJwO+ovVbpwRk5+1a8WiLXP6RlzwLRzFSK+UVRRlTrMygyTRqgayyiXfnuKBPULUc8AtGHCeObcS2WDi0+azWOzyMH3DDTPkit3LuuijCn/O9obsMBoVJ7EAbQjOKpZJetzY+tzSAC/O4MkzIOX5xzLTwEkR43w9oQfe9dRZ5LFDaNgO2hZOP4PlgjWGLxLq86a6w+6gON1YveVH99z6997PBqIABOqFIEdMYjCaeacF5hk0hKmz2SXdxQgvegEzYzFI8RNLuCN53L8ydN/L670f9xxcy1oRRYKO9YP0tb6EXeDBeNS5/dyYWuF7XtI3o1Ym8I/ZD21DT/I/QYwxXtkKOA2dakcndGe3xxsvLXQDvv3ls5hj9FnQbKKbg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(19092799006)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGtEeXh1dHlyakx0NzlzQWpvSmt4VmlhdHlRMzJKY241WUdrU3NpTmIwVTdB?=
 =?utf-8?B?R0wwcnNYT3E3QWNMcHgrRjlFUTdzUDJndkxtK2p1Q09mVlBMLzNzV0FBNW83?=
 =?utf-8?B?c21kcEJXbFpQQnovRlE0YW14aS8xRFExbFUwZjZPQVN5WkRldzNxWkgvaCtQ?=
 =?utf-8?B?RTF0ZXFiUTNZa3M0dVFhS0htRGtHMElHWXdxMlFhc3VrcnVXSnozMjN6RmRu?=
 =?utf-8?B?MFVqTzdVNlh0bkZDK01la1p3cDZmRGk2WUFCSkxjNDFSdHNuQ092dHYybmFW?=
 =?utf-8?B?T1pXWXg1dEY3M3VXWUozUG56c2d2RU1GanNrQnprbUpqeGc4UDVPZ3BFM1NR?=
 =?utf-8?B?ZVZ2UkdoOWhQRlVqMThGZFZ4Z00xdUZiNVZzTFpjQjF0S1ljQzFpdFN3Qzg2?=
 =?utf-8?B?OVdVMXNQUnJGbkFPeStXQVlzdzF4aDIzV1d3QjYrNXZQK01XSVJoQnJEYmpB?=
 =?utf-8?B?WERHR1lzZjdoUjZGeXliVzA3eCtxajcrSm9vMVB6Q1JsMHFZSHplUDVXMFEx?=
 =?utf-8?B?OCtra2RaM3R4TjAzK1QxUkhLM3JKbFQ0dGVldWVPQ0Z5SisyY0MvMW5HaEI5?=
 =?utf-8?B?SWdHQng5Y1phUXlkSGdpR3dLb0M1d215OWt3R2JZRjBPOENlelY2Vjk4akMz?=
 =?utf-8?B?THYyOHpIMElyeU8xVkREbTl5bTB3MjFzNzM5dHB0YXk1ZEFrdEx5ZThNK09q?=
 =?utf-8?B?L2hxYVF6QXBpMDg0cTc5MTA1QmFiNnl6NG9YRE9NVzhzMG1qVFNZNEcrSXk1?=
 =?utf-8?B?K0ZHRXpnemQ2K043cDl6OFNsNUVsdXBaUGtuYUFndi91VEdSRVorejJ4L3JY?=
 =?utf-8?B?YU1UTUVBRmNRMEVsZkhwdzlGdGQ3dlArZTU1QmZOU0hzdUJGVmhmWnpsTXBU?=
 =?utf-8?B?RDkweUQrMUFZRlc0djJnT0E4MHdxSVk1bFU4THNyTlB2Ky9YQXpUeWIzVm5K?=
 =?utf-8?B?RW1nL2dsekRhUm1DeG9JdjhoVnNHUHVsV2RPejBWZjB4QXFqSENpM0VYeHRi?=
 =?utf-8?B?KzFlSnk4N2QzTW1TU25NbzBMZTVwWThmaG9WcUVqZnpGY09idlF6UXc5ZnVx?=
 =?utf-8?B?TWlpdWRxUUs2dnFjYnF3em80RThaU1pzZUptNjh5bCthc2gvRG9mY3NBZkJV?=
 =?utf-8?B?QnV6OEpMK3NlUVM3eG92N1QyaElLeldPbkJvb3pzWXpFQlpJbUZDSzJqRk9y?=
 =?utf-8?B?azFkWkU4VFU5S2VsWWQ0VjZmVEhjSUdrTC9KWkV6U2hFVDJ1WnJxTHpqQ1Vu?=
 =?utf-8?B?bjgrbXNOZ1Q2V2g5RVhnZVIzM0o4RWpqSS95ODRxaTEydWhvUHdGUE1haXJB?=
 =?utf-8?B?QUZPSDFIanFuUERxeVA5OTNGTXdwaVEwM2Z6WGIvOURLT1MrbEo5c2thQ2dZ?=
 =?utf-8?B?bTZYSWp0bVRIQThLd3d1QnBuaWxuajMvbUVPNlRBejhnSEZVRDJEOTNhdUQ1?=
 =?utf-8?B?RGNCOWw5WC8zczVRTmRFem10SUhwTkx3cTYzRUtxUC9xVk81TXRzNFRmalRE?=
 =?utf-8?B?ZzRqU25ZSVRYcDlvRW9VMWZxMFhkKzdBREE2MTNLa0dSR1diYmp2OE5zMzJS?=
 =?utf-8?B?bE5oMGJVcjRnL1djNHZoT2RwbjkvV01WdzNnUW5mamgzR3FOY3prb2VrTHB1?=
 =?utf-8?B?RndHcUJxYTFTYUVEaXdKR3Z6bmVITmF0dXlDQWtYOEQ1SGxGVDlTRGZVbHRN?=
 =?utf-8?B?WmE2aUQ3aXhKcUhLaHlxZDBKaGQrVHo2eG1QMEFIejQrRklDUG5CUU1hK3hZ?=
 =?utf-8?B?U2MrQ0ZhNWRrV1k1bG5oOXpIbjU4aVRDUDZ2dGZXV014bXB5SVBja2hiUWNn?=
 =?utf-8?B?bENyRk1MOHpaeG9HUzNWQWZOVDZYbFdMcTcvRVdETTB6Ym5xU1V5eGZuZ25W?=
 =?utf-8?B?c2p1dUtackgzZWc4RnhvQmhqbnBPMzBNQ1ErMlJDaDBDR21VcElKTUZUVW50?=
 =?utf-8?B?OFhXK0RLRmNMcytrRTRVN25ROG9JaUxaTTFmSDFKVk9EbnBoekZVRkI3VlZk?=
 =?utf-8?B?UU1Sb1VEZ2JRODdFTDRXMDhLWFBJUEhTVXkyT0x5Wk4zOEp2VkFsczhnVUVp?=
 =?utf-8?B?OEc0WkEyenhZVlF3REVWYzJHSGpUWGMrUEV5Y2F4cXhESTVZQzc1U1QweFBi?=
 =?utf-8?B?SnVYNWJqdS9QZnhuTDVOcW1mUnBieklCb3ZxRzVnbm5QTjVKME9nZThSV0hR?=
 =?utf-8?B?ZUJlTi9XM1NnSThkcXBpQ0JaVlYwZm9mamFLMTE5RCtlcEpRdng1bVpqdk9C?=
 =?utf-8?B?aU1TNm1QbFpPbnFWajc0QkMvdmEzcUlQdGdMYmFhM2hYOEJzZWI2N3RicnF2?=
 =?utf-8?B?MFo1cXN2U1JYSWJFSnNCYTk4czZwcHAvcmhSY1dqc0t3SXIxRzNsOVc3c244?=
 =?utf-8?Q?p7B9ZZFUbpYUTA78=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52005ca-c915-4dee-570a-08df04457194
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 14:14:01.5593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UpawaYoMq29z89dquQlrT4oSEnYJCn9uJtJQRXGvDrPs80sUt8HaBDWxY0hWQd7MvDu6ZppVG2Jez705U8FQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7976

On 8/26/2026 6:36 PM, Bart Van Assche wrote:
> On 8/26/26 6:40 AM, Larisa Grigore wrote:
>> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
>> +{
>> +    struct ufshcd_dme_attr_val phy_write_attrs[] = {
>> +        { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> +        { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> +        { UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
>> +        { UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
>> +        { UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
>> +        { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> +    };
> 
> This array and similar arrays should be declared 'static const'.
> 
> Thanks,
> 
> Bart.

Thanks for the review Bart! I did not make the arrays static because 
their entries depend on the runtime addr and val arguments. A shared 
static buffer would be racy if two callers ran concurrently. However, I 
can make the arrays const in v2 by moving the addr/val-derived bytes 
directly into the initializer.

Regards,
Larisa
