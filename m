Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012063.outbound.protection.outlook.com [52.101.126.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB4E273D6C;
	Tue,  5 Aug 2025 12:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754398246; cv=fail; b=f4qwpeT+2h6lTvdHt0VpRZCdVg+Wx8YDV6iuR/CxdBKkJJSlROsuOWB5ENBIfvvCm6m2mrih9HNLwEQu06szHPnvvrTzJqKJGWSfmO+fBLjVHzd0OKA3lTXP7340np9H+ZMv9MI50jNeDbH14KsRE1AvUwkWC9oxEvb61Si9ijw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754398246; c=relaxed/simple;
	bh=j3CqDOymVHTMpr1cdsZSMiXsWCQb8LOmwOxc1yXCUx0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tyMuJ6FdA/t/O+hDe/nq3tlO/NnjlZhiWMGysayXYdaTpaGGIDL5roBfhYle3ZpDJVEBEvCNptwkg/fAppOpWnCxhoDTWKZ9oSCOdgrH6hPLkv4sMZNkStTqfIajF0mt3Ual3qks4wYYnSiVtC6PNinVpWAG09LMqC5VY7MM5jE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=nozKE2fv; arc=fail smtp.client-ip=52.101.126.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="nozKE2fv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTDWlZdmAqx9V8KpaIj+01TtUy27nUmU4t41O1IY9lcXg6ala0qUQInUefaJiqrRKr1njPQJ59UDQgsndRuSpgNRfW2h3a6YvhILcvhRSIo35oOISuG7hSsLv9tWL+DIBV6LEgZWzjLgLFqfnHJi14qxB5B6FHQRN66dqAl0Ghs5Eeie5eWuGsNdT9wQJY5/fGLp6elWB6pjttr7ebuQHhg9g7Rc3DG58lTH72iGMzOENHrN0YQ9x02wNrTaIQQx/Gd4vv7rfwK5duQlOiPD8WDqM6rhnDeQHAhKicZ+guLKemkJqZjWeUbNI2imf4AOPipakJIaD0wcH//6VjOg0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18MH5FFeVnTNeeF3yPxHlNT5zVzJlkgHOJIWJiDe68g=;
 b=gvZQR8vQfZjZkDlDWwsPXofgfA+2J6ToBqta9qEF8EFodpA5TdoDeXfDn6oO2y+8BJLzxdSTLka7yjKV0pjeo4iAbenRCDCsm8A/VCzxk2bXJUnGE+T2uHv9wBZJUpN2d7Yh+wvfAP6XB1AwP6IQ8cY5zDB2UJV3ms69ivJKsidnsDWT0YZIWxorEpvjFlro1W8cdW249BIaLUbEemWSQEhDdGxBfrWxikfvAPRnCGD0TB//0KUFRaITchtmxtxY7ARAaJnHAAtjD4/z2viEIMiDQj0zSqSDM1+K0eFfc3MKN2ZukrEPgOiBcH77jZQaknPruTcHBtj1RSXkAL168A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18MH5FFeVnTNeeF3yPxHlNT5zVzJlkgHOJIWJiDe68g=;
 b=nozKE2fv8kfUOcbhYpOAUy1LjyXYy8TpUMkeV7agOU4WJSNBAesRlWSfQce6NWwedFx1ldMGMJ01kJtC9QwbY5vy9fhDTGTdUUmiyX+MegzVxw+bEwuFVy+1f37vbxcRzUrddMpz5/xCYhmlDvRcx9XuL5RSkItzdu+p3S3tfyw2qjhAoQJYjowSU9Ntwv6cF3bc91vYt8vRq6dVSxpA9P1974qu8bc6ZpDKAMyxBN5lM0DEfdz97KHWR/bGgu8aJVVefhJwOVoJAZTd84Yy3qTk2S+sUAlKKFGagWGBkG+DolZz+d4915cEyDzRhqPpAu4ARmF/NDeTFOWPBbMu4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYSPR06MB7133.apcprd06.prod.outlook.com (2603:1096:405:84::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.20; Tue, 5 Aug 2025 12:50:39 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 12:50:39 +0000
Message-ID: <8ef8e4cc-d24b-4651-b0b5-958d1bef6c7e@vivo.com>
Date: Tue, 5 Aug 2025 20:50:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: scsi_debug: Use vcalloc to simplify code
Content-Language: en-US
To: Markus Elfring <Markus.Elfring@web.de>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Bart Van Assche
 <bvanassche@acm.org>, Brian King <brking@us.ibm.com>,
 "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250805022637.329212-3-rongqianfeng@vivo.com>
 <45f3ff46-fcd1-47dc-aaa8-dab7ddcf37bf@web.de>
From: Qianfeng Rong <rongqianfeng@vivo.com>
In-Reply-To: <45f3ff46-fcd1-47dc-aaa8-dab7ddcf37bf@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::17) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYSPR06MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: da05dbfe-a6ff-44d5-2dee-08ddd41eae53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Um01RXVWSE12UnVQMTBUbE5WdURhWWdCT0VyQjRSOERwUVBxWGlYbTY0Yklr?=
 =?utf-8?B?alM2UG5TQW9tRkV0SWszTzVDY0JyZHFMbWN5bElYcWpIRkNGMlZhZ29XS0F2?=
 =?utf-8?B?ZTRCUC9ObHg0dnZQT0g0VVhrR1QyT3BQTFJMRXlZSzgwSGlBYmhDcis4dHhH?=
 =?utf-8?B?a2RTOCt3ZHZaMWs5b0dBeFZNUEJCOW4vYU85VjBodEh4REdGai96U2lLZHdT?=
 =?utf-8?B?RXhZZ1lsVmtkREh6aDFYdFQ2ajBmTXZXbWgyMm1jMUNNREdQNHNUSmJkT2wz?=
 =?utf-8?B?cHJkU094Rm0vZW5SR0VzUko5TlNBcnFDZU1uQzR0RDVXeEVXanJyajNUNUNQ?=
 =?utf-8?B?K3R5eDNRcjgzK0t1b2VpK3VaZ0Q0aFB5ck5YS3Q1c20rOG1pM3RHeDdkZlpr?=
 =?utf-8?B?ZGRCL3JabmhHZmdxL3JpQWZsSmQyL1VOenBOWUt1VVU0OW5xblYwQ1RrSitk?=
 =?utf-8?B?eEMrVFVpYWoyK0ZQNFpjVW03b09RVHhjaVoyM3JJOW1OS0l4QmFZZXhpVWdq?=
 =?utf-8?B?bGN3ZE5aVGw2eDJydmhTV0hZNXhaeElCL0hFdzJUQndMcWhXcldTLzd6UjNG?=
 =?utf-8?B?R0dSN0tUektJK2RKT2szK3JlTEdaMGNVR3hIZmJYY2E5TVBqajloenJtSERS?=
 =?utf-8?B?V0FSQ1RGQld5RHNmaGFLK0kwaDQyMkh0NVFxT0E5SytSTVBZQlNGcS9UMzBp?=
 =?utf-8?B?dlk4dWNZbmF1WWxha2p4QUlnWEJlMXQ3OXByUWU2SmJwcElTaEtEcHFTMmFY?=
 =?utf-8?B?U1Fuczh3a0RyYVdpK0Q5WG1kc3JBdkFTaEFMdk5VTzhKZHVReGQyUGhiRmhv?=
 =?utf-8?B?OEhpTFVzNVhseFlkN0tsSzdsZjBWTkVzUWt1V3VHMmhvVDlYalo2eFFyelZD?=
 =?utf-8?B?Nk9ZSmJQdGllUmlaOXJOTzFYSFBYSGwyREVmbW5yMFdPd1hzc2NnRlJoVGh4?=
 =?utf-8?B?VzF0WTJXUlhWazFsMUdXZEVpN2FaaW5hZTZUeTZ0cmNTSlk1UlBaN2VQdzVG?=
 =?utf-8?B?RGRRVm9ndmJQZEh3eURIU2ZaU29ldnRMRmxvb2Q0SnN0ZFYvak4ycitjNVJE?=
 =?utf-8?B?b0gvNlo4Qi8wYmkrU2ZYNnRrZTEvVTVLNjVQcWVEWWZqTTl6c3UvaEUvbTgx?=
 =?utf-8?B?b2hxbEZydnBpUHF6bkw2bElkRm5aRFVPN2lqZXFPMEc5bnN3eWs5LzJnZjdo?=
 =?utf-8?B?T1p6aURPTFNvSzZLTlJObnFHckQySDk0R201S21EVTh6SVVUYU02ZXIwV2s2?=
 =?utf-8?B?THJTQUZPeFNLYitlU3FXL3d2bnVTc2ZFUnBNbml0QkZEWUoxQlplTXVBazNj?=
 =?utf-8?B?NTBCM3B4RWRvVG1ZQjVtYmVkTTk3dm9uMkFHOWVqOWJOREFzbGpDVGl5Wnpm?=
 =?utf-8?B?V0RVbDNtSTZPY2twSUM2QzhOUXZ4RWx5VytYd1RRQU5wbzJYeGN2QnNRV2dF?=
 =?utf-8?B?dCtrWGF2Z3pjV1gvYjNFOGk4T3dLd2xIUzBmUTdYd05ZMVhUK3V6OFhNWnRE?=
 =?utf-8?B?NDRUejdId2RkcEhFWFFSaHByWEJZOUticmlabjJaTVR5azVybkp0NjFQbGM3?=
 =?utf-8?B?UkdiT0IxVTAvY0trZHQwMXFYdi9FVE1iNC9JdFZRc1NtNFJQaXVXUXFsenRy?=
 =?utf-8?B?ZkJoRXBXZlgrNjVyM1BPbEdIN1RPSURGTzVIdnlNUmwwTkp6ZzJGd2lsa0Ru?=
 =?utf-8?B?eU55WVFkc0dUTVR4eHNCc01oZCtVWllMak40UjNqZXl0ZytBYUd6T3FONVJ3?=
 =?utf-8?B?L0NHMUhVTWc2bit6NVg1eU4rczhjM1lrY2pNL1dURnk2N3AyQU5HUzFxNDYx?=
 =?utf-8?B?ZnpQNVZJM1NkRVo3ZzlPL2QwejNVc2hrNkd2REZmTzI0YlhROVExYjNOWDVI?=
 =?utf-8?B?NkNJY0JybzdTdk1FUUlEVi9Fa1RYMUp4a3YrLy9PbnJQWHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2dVU01NaTJEMWNjcW9EZCt6eXhQdUsva01lMmtIU2hzUklPdURtK1dObWlH?=
 =?utf-8?B?ZHlwaVZrenhOUkNMaGpRbkMvMkpNMC9ZNVhCWmdFQjFKTm9PYXZzZ2tLUGE4?=
 =?utf-8?B?UkswWlhuSjNjc2s5ZnphOWJOdzZUb0ltNVVTN2FkR3hvR290dlErN3ZKeENV?=
 =?utf-8?B?MWlUcDVvb3dNcStBWFZzZCt6aE13VmkrbjMySGRvbEZYV3pqWk44aU5zYUFQ?=
 =?utf-8?B?QjV6ZlhZck5zZC9iMi93SkdCWFdyN1ZSYUNJMElGWWxDYkFtZUl4RnJzQnJJ?=
 =?utf-8?B?Q0U2dTVGNHhzWmM2Mi9yRkFJRmh3UDJzdTZBaFpVL1FWSVZ0SjlkbkR0aWty?=
 =?utf-8?B?ZGNWa3JEUGR0NStFZURNV0g5cVg0UVFBelNGMGZ4SGNoVVkxb0ZNa2t3ZWY2?=
 =?utf-8?B?N0o5TDBHMXlKRG9DeitmU2tlalkwUW5jd1VMdWdSb0VMSmEzdXlvdWUxbGJI?=
 =?utf-8?B?UTM4a2xuUHk5TGZsY2tzRHN0bjU2NnRQL2hkSERnS0NESERHY21XVmpPb0la?=
 =?utf-8?B?VVIvOFVtYnhJT3hlM2J2Q0dIdTBoNzlMczgzZ2loMHZhUFowSWFDUkExMlBM?=
 =?utf-8?B?OUNCZm1jck1Rdmd6MUZTaXBtMjVlSmNPdHZWeXVvOU1jYkw3NjRpMXdKVlZ6?=
 =?utf-8?B?dWNBR0tCTGRtZmdWK2RkZ0MxdjQyMmpGRDJ3bEMzYjcwRUpNTEtoazZybXBB?=
 =?utf-8?B?cDN2M0RMd2JZQmpJbFlpeUIrVWlVcmdwWmhhaGdrZlhVM1N3eUxPNmVmemxv?=
 =?utf-8?B?YVlodWpMZlZrZ09PRGRzdnFXSkZMd0FWQTAyb3g5QWtuajczb2dpcW1EZElU?=
 =?utf-8?B?bXRGR212NmJZVjVzUHJqWUhTNjh0eVZUWTAyaHVabHJNRUpXZk4zRlJrbGpl?=
 =?utf-8?B?SEpUZ2JiTDQ4ditwWVhraTV3eThncFl4S1BhM2NjczJwMzVHY0JpRUVNUWpV?=
 =?utf-8?B?VmkvaUhjN3lGa2xZdlhMVnBqeXN2bldwVVRTYkU2TURMNXU0cjR5bmUwVjY4?=
 =?utf-8?B?Y1ErT3dzSU9IZHBvNytDV0U1UnVYK2VzUmxxZ3M5OVNaSlFsMXowODFNTWdR?=
 =?utf-8?B?T2lRbnpLZjd1QVB5TXJrVHBCYm5KVTJ2bkxuTWd3YWhOSnlMbDNIekpYUFZT?=
 =?utf-8?B?dzUwUXhwNUhZc2I2WTNnK2s2VFlxTnpxSFVwZXVWamY5Z0lMNUxaU0xlTWdx?=
 =?utf-8?B?NFRGTmpIVkUvM0NqelpWUnI4ZjlVRDc3UUc5bkdhWER1Sm9pYm1GUlNOR2k4?=
 =?utf-8?B?UzcyRUo0TmpDa0pZWUZWUXFvNUdHRnVEazRXNTNnTW1xVU9yclhuMmRoQ1ly?=
 =?utf-8?B?dVVJVXlQQ1cvSUhmYkpFSGtFYjZHTTE2TS9pVkR1bjczL0hzeHVBb3JDOFlw?=
 =?utf-8?B?Vkd5S3hzQ2hMWG5HT2xMWUEvekNFQjZlUFVCSERDOTJtZGk3eW11QzY0TzVp?=
 =?utf-8?B?L1RVRTZZd3A5U2wwS1U3VklKamlSTyt5Z2RmdU9zVS9lU1lHdUdicVV5czM3?=
 =?utf-8?B?MmRseGRFSG50aTJMQmNmSys3S3dJSlo5a0VVT2VjTTl5WXc1ZVErWDdvNWE3?=
 =?utf-8?B?RnVsVlIrRWNPUXR6a2NGblJ6b2w1Q09mRXF3d3NyK3VrU1J6NUZZWC93cWJh?=
 =?utf-8?B?dldtOE5TWElQdjBBU0VSRmpxQ2dXSDdHVC92WlZTdnVvU3RRQlB5cERKQmF3?=
 =?utf-8?B?WGZsNDNiWEVMRnIzdVpSZ0dMK0RsREsvdU42U1cvaTBYVHVIZEE0TUREVHRk?=
 =?utf-8?B?OWxSNFJTZzI5NXhhWU1tbFlIZVFqcDdpSlphTlpuQnBxRW5WU1RPdWtkT3dm?=
 =?utf-8?B?Y0FsUnIyQzJsMUljWWdMNWt5amZWaTNsaDJEVFh3d3lzY2JyYkhyamRjYnVG?=
 =?utf-8?B?elMxY2diWVJiT01CWU5idGp0aTJBR3k3SWpQWTRJejBXTTNNRjliVEx6bVpz?=
 =?utf-8?B?cnM2S1hKN0ZpQlJodk5WQWxvUlNiby9sek9QT2pnOHJxRUYyNGRpU2JQa1R3?=
 =?utf-8?B?cm91ckVjaTFLeE5zUHZIUWhJOHZuenY3UkJwVWJEM29UVkxKWlk2NHZ3MTM4?=
 =?utf-8?B?NmF1ZDdTb3RTK2habTc1Uit4dTZpTHdmcTVjZ1hSV3VIcVpsT2RQLzRSWTNL?=
 =?utf-8?Q?wAJeGtdYvYm6cCO8p+S8Zb0FB?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da05dbfe-a6ff-44d5-2dee-08ddd41eae53
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 12:50:39.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fkGgOkyZm3SlbQJmaqHH/fW+TSnyahm/0OzhrjX8/iiy3hEEyER0g6k1+WPlQ7cuT2SlJkKsPn0QLiZpYkhFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB7133


在 2025/8/5 20:38, Markus Elfring 写道:
> [You don't often get email from markus.elfring@web.de. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> …
>> the functions sdebug_add_store().
>        function?
Thank you for your correction, I will modify it in the next version.
>
> Regards,
> Markus
