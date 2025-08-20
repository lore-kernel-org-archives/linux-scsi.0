Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012005.outbound.protection.outlook.com [52.101.126.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813BF3093BF;
	Wed, 20 Aug 2025 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755694217; cv=fail; b=JzVHoU2Jgsyh4YVPAwvFFPAWfFhU5Do5jLsYBrBgBpWcicyKvkwhhG65ljNCERw7OUKWSVj/b8GL17GO6Hba1sUNCBqmOPfnDyMglqh0bPfkZXcB+Y6vnpAfmCQ7CQ7qumyezZoBRw3XPz/0JJKv8GKBhby4sEjcVayVbRX5KOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755694217; c=relaxed/simple;
	bh=3hsIpryIWNHO8ChN1U8feRdMGoYgyODFkvYESmkJENk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yf7Z69N1S3jOwDl+pcs1x1zltM+O8WSOHkUArL5On7qA+SFUlGFXcpSufkaa3GYSktlZKcmzvayZ3kNTIEB361S6+O0jH5UsxfITxymobJeNL9SWSoIiDH/fhSSOs01D08xObAc/YFQEf2yeCqm53cr4hp2bM9oUSgCwMnoBeXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=V1Bippws; arc=fail smtp.client-ip=52.101.126.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="V1Bippws"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XqQWuI9gzXzMmGzz+dencbJ1qN9o3IC5VvHH5wBtZKax3L+YQIfO129N2u5inbe/cR/4WjrcqLcEFFSacQubB8jVkXEr9rLi6MafGzO2JdgG7RWRVuduZxtE8HJrgE9ApqNtsHyUhGQgHCVz5LuBC93GR2T66CxJwByrBlMPztubpgZjmE5TUEXeK7CQcvsS8xIaUJumGAJUlA+SAWLVATi/JdugcbDyP+IN/4pJAiNZu72gAkyDHqLb+NuxtGMLk2DiRTGe+FjtGlm5HrE90Xl9nnFWkNXy5GFUtyDPXAE8kd2whkiichf8LJfbnoSRgN8LsrquL2H8j+e6cPODpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+q/1ao2tJsrQWBb3hkEYAeoQ+vUJQBfXz6Taw0nffc=;
 b=cSUR9ojhiIRRk6CQL2okqDABKTKKzCyy4ZFZ58yosaDt73QmWnLEz9GZSZgeMgk0ixq1ekaRJHh/EwW8N/Q3VR+3jFK2KEb/0+i4OEIyQmT23yTfwC2BdrOhH5iPCyWoDfkxL70bLaX9g7XwpcLbTXWkXwGpLy24IF5nF3cJLrUj7JWpczjVsI9YmTDgONCqYJ3D/CHPldGXq9ka3jyW5rYHTwjUXqdXWYS3OIqftDbsp1OkBOuuKtj0oXykqlOnST6Au08kERb7vyZr3hXR9MqTuvXPlRRMj5vWgO3C0T2X+RSJZ7W4pgHzwXZGHd5nOy2gO+UTee7gDG0vZ7TYhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+q/1ao2tJsrQWBb3hkEYAeoQ+vUJQBfXz6Taw0nffc=;
 b=V1BippwsOAlzF1iPQl9XmAhd6kAXj5A4TRVKck3MFE7ug0qDCioKyt6tqd9HnkgVwZNv9PM8A4CO23D98svIRrseLMfaC0UC+pBq+4QLP8PINrN4IRSHwVFeTG3+NrWRzrDosBSwIw3eJpzZRIwpXkJUxD68X+doGLjxEoLvAx+GhSjhXAysZfB0c2VYWSA535rDBjw5OZwTTJ47eYTUvSK3MxXCO8sI/UqJ0Vdg0Ar4njLrFxPVdg1gAL7LbBz/49FZC89ZiJg8ppQoBFyTSoQ3TAnrtiEPP9U1Li4kRbdiKsiS2vuvZZkNSYN9XKz7bRdFyYqLGc5ThcXy5Gr2xA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TY2PPF5221563AF.apcprd06.prod.outlook.com (2603:1096:408::78e) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.15; Wed, 20 Aug 2025 12:50:11 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 12:50:11 +0000
Message-ID: <deee5abe-1992-426d-a62d-51249014bdc9@vivo.com>
Date: Wed, 20 Aug 2025 20:50:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] scsi: hpsa: use min()/min_t() to improve code
Content-Language: en-US
To: David Laight <david.laight.linux@gmail.com>
Cc: Don Brace <don.brace@microchip.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)"
 <storagedev@microchip.com>,
 "open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
 <20250815121609.384914-3-rongqianfeng@vivo.com>
 <20250820130237.111cc3a7@pumpkin>
From: Qianfeng Rong <rongqianfeng@vivo.com>
In-Reply-To: <20250820130237.111cc3a7@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0179.apcprd04.prod.outlook.com
 (2603:1096:4:14::17) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TY2PPF5221563AF:EE_
X-MS-Office365-Filtering-Correlation-Id: cd89f61e-9d4a-4db8-4f94-08dddfe8195b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFRDMkJkZ2t2djJsN0JOSVNJZ3R1bnkyc3E2UDF5b2Z2S3NuYjc1dkRFL1VT?=
 =?utf-8?B?TWxxakNucCttTnlBWVk0ekphTjFJMFB0Y09GMEZONHdNWm5VSlhoN3lxK3Vs?=
 =?utf-8?B?UFFxeGFMNTg5QnFNU1h3TmpPU2dhV0VqV3Q4enVIRmpybStnNzJ4aFFjZmRm?=
 =?utf-8?B?eDliWjZUYzRRMkZZaldKbGpwUXBKTjhCeWJUaVdZTnkrek94ZTJzZ2xVVGho?=
 =?utf-8?B?WTNnNEZINThtUHNyNU9QRVJtdHFsYm1IVWdsZ1cyYVJsdWcxVHpINXh4YmpT?=
 =?utf-8?B?SlA2RjkzMHRmNHp5T2E2b3NJZytaUVF3UktrSnhaU0pyY3J0cXNJRkJ6SUFO?=
 =?utf-8?B?cTRUOGFUYktwL2pVaHVsTHlRempVd1d5Qml6OGVhOCtwWm1YRFBPWDB2VXo0?=
 =?utf-8?B?UHFqWVd2NENsdXlheGNyeVhhSjU1SVNVOVdCeHNQeis3a2o4bDVjR3FrbG9C?=
 =?utf-8?B?d2dLNi9PcUQycjRTR29BZ1VPQ3JjV3RUaXRwdHJNb1NSd0JEWVo0MXdhVkRo?=
 =?utf-8?B?OSt1OGtTLzJ3c3cwYmU5TFZ6M0lNYVUxTkZwalg2aHM2dEJmMHdtMUlnWFhE?=
 =?utf-8?B?QmpNeDJxQkRsdGthcjg3dzZxQ0xqMTNJeXpTSHB1WktMQXBiUHh5em9QL1dP?=
 =?utf-8?B?eEpycldUSXZmWGc5SGNVQmZqV3J3Z2VZcHRKRnBpdUNEbnVRa2VPKzJqekp1?=
 =?utf-8?B?eTVuMVlNcDNCWjRNQzlvb2lnMFo5Wm53WHAydmwwQXFLSnVzaWFQeUJJV2p0?=
 =?utf-8?B?SG41ZzJBMVNoVWdnTGh6Z21kQ3RGNFhJSjJMQjFyYzY5RTgwRkVGNDJYSTA0?=
 =?utf-8?B?eUpqNStUc3QyNUwvalBBQ0UyVVJzQ3Y0MWlkZmFWMm94ZWV6Qlc3cUFDRSt0?=
 =?utf-8?B?MEllS3dsWHZCakhJMkZCYWNVVnA4OUp6WkE5QytKVXdUNHlFeDdweU8xOWhR?=
 =?utf-8?B?b041OUFJS0ZLcU4xV1hMeVNwZHoyUjNabkJuNDlpRnpBNlo4UEpncmpvK24z?=
 =?utf-8?B?bEQ5a0grRDZuSTd4ZTV5RTVRSnNYeVhmMWJOQU45V0R5SDlmakdSbUNUUjNw?=
 =?utf-8?B?OWliM3AxLzFWKys5ckZ2dGFTanB0cGxUeGJrUzJEKzJBQ2VJZG9UMDZENzlF?=
 =?utf-8?B?eHVFNlc2RE9OcTU1c3VnWkw4d05NTlFtNU1aSCtNaXNtRUVRa0t1YVZCVGg1?=
 =?utf-8?B?TlNBYXNIUXNiakp2QWdvMEIwUzdUMHFqc3lwQWh2WlVTOTdybDE0OHlsZGJQ?=
 =?utf-8?B?NE1nZHFuamY1ampKK2JsMERGUGxkK3lhV0l0UHZYRkJGL0JoUmZHeTVlUG5t?=
 =?utf-8?B?Q3FwNi9YdDF4WnZ0R3pYOTAzaHJ6RnVqV3gzQ0FnSkVIemZXby9mUjhSL21T?=
 =?utf-8?B?VFc5bm5keGdDdlo3MXJSYWpORm1ROTd5M2ZxNmo3THdYRW9Hc2lHc1YxYUk0?=
 =?utf-8?B?T01pQXF2YTh4dDMyeDgzbUdGNXhxMWFFRE1XU1dULzZZQVNGYXY4cnNCZDdT?=
 =?utf-8?B?SHpPejV6aVBxaTVQMDdoaDV2eDZPUC95YzFVVlpmYzBRSllnS2pMVE9tYWE2?=
 =?utf-8?B?NlVXQXhiVUF0WG92Vkh4aHdiV0gwMkFhdjNGcjgzT2QxdkNEWURZTU51emha?=
 =?utf-8?B?ZnRvcXZWeHFLaHhpWUJyVEVmSVczSmVKblJONlIraWRXMTN3amFxeFBRWlht?=
 =?utf-8?B?RHBCTllUVGROYWF5eFZVT0FHZk5ZSmpMbUNMQXJlWDdiOUZBRWpDZDRkV0dL?=
 =?utf-8?B?aFMralNMRG1MYVRZR3RlbFd4aitNL25pdFlNL2FhQnVwNTdPVXViL2piWFla?=
 =?utf-8?B?eFQ2clpKRlg1Q1FBTlYyVUt0RzFaME1aemZQbHlpbzJLQk5oRTE5ellYZGMr?=
 =?utf-8?B?WSt2NjNxemNUb2RGUVJyNU9MbFpsbm9HMWpFa1MrNDNac2pGK2xmZTAwNEFF?=
 =?utf-8?Q?S0B/HK4fjzk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dW9KMVpTRFJ2R2NWRGdYVTVXVUhVbHdPaURRRHh0QWFzL1F3YXk0V2JqRGJy?=
 =?utf-8?B?dTNibmJHWk9XaFphSm5qZFE5Z3lXcTJZOWpnOWRINkEyejZwZ2JxK0J4L0xL?=
 =?utf-8?B?ZUxJd0t6UkNvUnJMdlBhckpTMTFTbVNRUmZkSnVZRFlFZ0ZYVHVsa2F6cjBI?=
 =?utf-8?B?bUhNWERqODAxeVhBS2lwek11UnZDTlEzc3VBUkRZK2t4Mmtjb2dJZksxUWJS?=
 =?utf-8?B?dEdiZVIrZlRJM0hmbXpaOEJxMVJWb2RzbEo3NHU4bjM5NEw4L3RmVExtSVY3?=
 =?utf-8?B?Sk82V2ZMSDhFQ2NnQUJmRjFGMDVjY3o2L1NDbElScHVmVUtLcTBzeTZET3dL?=
 =?utf-8?B?N0U4Slp0Z2FoemNITGpPdlRDZnpTdTFpc1o1aUczSkgxbnlsQ1RCM0hlN3d5?=
 =?utf-8?B?Z0dwQ01tYTRzK3h0UjBZaGxPd0FpaHgvQkRpOHhOOVdnS2g2S0xuK05LVFBy?=
 =?utf-8?B?Sk1UK2J1TVFEdURGS1VMdFdGVVdmMWVHc1FySWIySldMSi85YzVXTDRyUXJ3?=
 =?utf-8?B?ak9VK210MlVhNFFmckFPaEJDL1ExNitZZm53Y0RSZXRkS2hJZ1YwZWVERlBo?=
 =?utf-8?B?MFcwRnM3MHovdVE1eTBaMHd1QXp6ZTQzVmx3Z0FwYVhoWVlvdE0xYmNiYVFX?=
 =?utf-8?B?SXNyVzg4MzRNQjZUKy9HaWtWSGhtcG55Rmh3TE5IbVlGTFdvWklEVDJ6REJm?=
 =?utf-8?B?ZDEzcllwanNLSDF3aSsvMm5OVUlxWWxWSisxaXhQRExzeEZUTGZpeGVkUzZW?=
 =?utf-8?B?cG12a256d0RUN3NKWFhQWFZDZUVncmxaMmVYeVNaUFBRNTJ5bkZCZUh0YjRl?=
 =?utf-8?B?KzM0TE9sVTAyZllMSWhVYzRrUDBkR3FWVHRqUFhQSTA2RlJsMEJaRzRLTkpn?=
 =?utf-8?B?OTNZZWJycHJuYzFlaUhHcTBTSHZYSll1czE0eDNxSUpMRzlyc1NKa2V5MWx4?=
 =?utf-8?B?Nkh3Y0p0OUx4TXdJd1dEaFgwWSthakhHVHZhVkd3NXhoOTNjbEpiUGs5dDlL?=
 =?utf-8?B?ZGkrRGZWVFJXL2dnRWNUT0RXL2RhU1BRK2RUM0hMY3h4QXFQRjdEWkNGUlJC?=
 =?utf-8?B?VlZDVFlwY1ZSb0QyYUYvbUNwRzNrNzVPOG13aUdiWFFidzRSMUZIM1RpTjZN?=
 =?utf-8?B?TmgvYVN4dDNFZkpwMFVYT0sxeHg1ZmZqcnJiSnJpK1ZSQ0FjbnhyTUk4SUhq?=
 =?utf-8?B?VUo4anl3LzNDRi9qdkc5eWZGOFE0cG1pMk5ySytsb2RENk1VMDlmNkVTcWVO?=
 =?utf-8?B?bFJlSmpCb2RhZVRXcm1aUDVyNWpUR0dlT0RHRW56MllxY0xBWG92b2p2TEI3?=
 =?utf-8?B?NnpsanBiY1QzTlpFSHh4dzMrdTRFN00vcnVlM1R3ZDVLRFVWcUpNMm1BWjZt?=
 =?utf-8?B?V3FUV3R2ak9ob0JXRlFrUU1vREJaK2d0QzZKL1Nkb2UyVnc5VUkwN3VsNlRM?=
 =?utf-8?B?VEt0eEo2NjhVRmVQUjdGQ09JZTA4WWQvbzFocWhKUGtBSkJqTzFmWERKMFFY?=
 =?utf-8?B?eDQvbVBJQUF6anF2clRUMW5VTU5aUHRWSjk1TWxPMHAzcEhUNm4va0YyblJC?=
 =?utf-8?B?SnFFeUNSWkc1L3JnYk8rUnVRZ0NGM1dkR1B3MXNKcHdlRHpzcWZOaUN3T0F0?=
 =?utf-8?B?Nk1hNTNRUkc4UmM2MlVFczJBMDV3SDRzUURERitpK0liNTg3NDhodlozYjJJ?=
 =?utf-8?B?ditRZU03bHZ3dHd0dFRFK2U4WVhkWUdzN01PWnd3T1Y2SzN0ZlBKR1dMOXpL?=
 =?utf-8?B?ZVdRMVlRK1Z0UWtNK2RDTUYzZjIxVHAxQ2dBVE9rYVBKKzNzRitDSk1zWGlG?=
 =?utf-8?B?YUdpVHBUTWkwaGFCTjFtMnl2Z2QvM2FJb3hGbTlTaktJbnVBVmFMU0E0bUVF?=
 =?utf-8?B?eFBmYjRTQ0pTeXV3NENSb2o4YXJIZFNLc2VpWS84QUJIOFFoV3NGczVGdlVr?=
 =?utf-8?B?UmZuVTJQWnRqM1k1L2Fjdjh1eU91YSt2SU1nT0U2bXdrSDRyYUNDU0d3MERW?=
 =?utf-8?B?RENnMVlnMkFUa1RVTFF3ZENBZUo1YUF3SGxQZGRxQW8rbk1qOEw1TVArNTZO?=
 =?utf-8?B?emZ5OVllZnM3RWdxaWtNZlFIZHZ1L3FubTR3ZlRQSXZyQWhVNGUzeDluZnZ0?=
 =?utf-8?Q?amwM/55ghqMZnTs0G4qgEAOZ1?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd89f61e-9d4a-4db8-4f94-08dddfe8195b
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 12:50:10.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8N1jR4GizUCj/hTj8WbpGqPtUMsFr/43gOEpZb+T8cVHXNDVbgrFNmxCtc02VVOcA8W+0XVKPKzZAar1vHQlQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPF5221563AF


在 2025/8/20 20:02, David Laight 写道:
> [You don't often get email from david.laight.linux@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> On Fri, 15 Aug 2025 20:16:04 +0800
> Qianfeng Rong <rongqianfeng@vivo.com> wrote:
>
>> Use min()/min_t() to reduce the code in complete_scsi_command() and
>> hpsa_vpd_page_supported(), and improve readability.
>>
>> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
>> ---
>>   drivers/scsi/hpsa.c | 11 +++--------
>>   1 file changed, 3 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index c73a71ac3c29..95dfcbac997f 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -2662,10 +2662,8 @@ static void complete_scsi_command(struct CommandList *cp)
>>        case CMD_TARGET_STATUS:
>>                cmd->result |= ei->ScsiStatus;
>>                /* copy the sense data */
>> -             if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
>> -                     sense_data_size = SCSI_SENSE_BUFFERSIZE;
>> -             else
>> -                     sense_data_size = sizeof(ei->SenseInfo);
>> +             sense_data_size = min_t(unsigned long, SCSI_SENSE_BUFFERSIZE,
>> +                                     sizeof(ei->SenseInfo));
> Why min_t() ?
> A plain min() should be fine.
> If it isn't you should really need to justify why the type of one parameter
> can't be changes before using min_t().
SCSI_SENSE_BUFFERSIZE is a macro definition and is generally of type int.
The return type of sizeof(ei->SenseInfo) is size_t, so I used min_t()
here.  However, as you mentioned, min() can also be used.  Do I need to
send v2?

Best regards,
Qianfeng
