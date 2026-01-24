Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011062.outbound.protection.outlook.com [52.103.72.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C571482E8;
	Sat, 24 Jan 2026 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769268381; cv=fail; b=P0fpXfTFDBKIOSmyymYSnhMSkkWgzagNC/ZpUxEWMKb9mT96vjzOyWx1I6PXOEW8zzcmmDy/RR0s0SwKd1nWFDnI5LzYvALW7PICpIz+Fio0jHGQZrDW+brp4010MdUuKFB13IA+bh6h6AswSs68cBXyhDgha/sCQbxBvCpu/GQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769268381; c=relaxed/simple;
	bh=f7g1FhpB+GrwNVbibH3QaBMbgZBW3Evry53mbp9RM7I=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=KuuVkSH0ZrL1hthfkAvH+R9padHmg/4lMjNc1W1XjgdZ0B11o2AxSrmIN05fJghNoaDd35SI/ghBHsntnDayMAfabBKUsGu5FLOYyxz/X2P9wBKH8J18ugAa/Jp9WYu4ynMVpGONjEyHvoeF2oMrTvw8II2E/qiaOA68Y1G+SUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=crbQvI0A; arc=fail smtp.client-ip=52.103.72.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="crbQvI0A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zqxp6UZCuSqt+z73dfpICYn0M2XFSpfY3xVydAeG1RaNWf70passslUJm0mHbd+PaD8AE9DjY94tdV7ilfZX+hAvfUhAwa/7n7kdpcoH6ZB3x5FuH8U3FVmkvIrgYJv9FsDZuP1Oq3HiHoLf/AfFmLts6TZ37d/7Wl9xmL0lS0IQWe5qpRBUL0OmXfpenspHGEixi+Qvi7qWHslS3eeITj2PGoUfKfWm+5bJJuqmQYTHsR2jBTAfExy3DE91/DGPWC47hgA5eu8nUl1B0lbD49FxPLrIHi8h7s7pkF+9QoCw3Ws+xVjJ9hwjmzs9TS4O/fhaqIvLp+WQjo5JnuTRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1TJrska4/qS9msIrOix+a7XFoR7rWAO2K8nJvYxJbJk=;
 b=HsKHYAWVr+9Jx3GS9PiHxiGQO525tnd0voYxpb5XU6Xqq04+qElvTyybSvPG5Y06N/2g79KwhGfvc45x15hPdn4sFaLkP0ZW/TTFGx1h6Za8GI9DnLdkz156Lv3AYr8c+zkQO+D0GuFApCnxSJ2L/NCeVvOwX4D9ryhS3aSUFyYoxL28Rp/oVSlKnP0A5yOSbQEnZHDJBpIAbU6gFfgfQ1m2kMwj5RrXoPKqYqOgqf80bfbpYdnA4Tjx9pP68ZnT3asLlVW+A4YI2MYGsm0RaYBJNq9EKBdsG2pXZlKUI5+1EGO1sJLn87ZL/gESwDkAAv5JMtQfyXuno1iqVlAcaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TJrska4/qS9msIrOix+a7XFoR7rWAO2K8nJvYxJbJk=;
 b=crbQvI0AGq0Pwuj1codbqCmqhXVtO941hRF1d+CzsnKAapxPLBoYkPG8GQXYMzF70rHn/EYXCVL6gDLn8u1+C1wlxZyoi7x0wM+DkrUgLGb+2Op/GZ4QAq+e8in83JY5R9I7KvIhBR36FBxz7MToMWXBnsACC8YgyD3pytlVHsW6EJx+5839xCdWoGOl0/c+0xgBOxUpgCUQ855sFhYCKQPjaP3PbqqLFUDdqmmJsrPQndidpn6yYE8ekk33CnFqoMjuCaQQJiLR+Y+k4b4Lxt18LqiOY0D/uh5jAFEUuKVRbHF0m8W7sAOl0o125uabkBcPWXpndLYUf+SeH7Ebsg==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by MEYPR01MB6661.ausprd01.prod.outlook.com (2603:10c6:220:12c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Sat, 24 Jan
 2026 15:26:14 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 15:26:12 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Sat, 24 Jan 2026 23:23:10 +0800
Subject: [PATCH] scsi: ibmvfc: fix out-of-bounds read in discover_targets
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB7881AC42D03DB777C4784520AF95A@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAN3jdGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQyMT3bTMitRi3WRjw5Rkw1STVJPkJCWg2oKiVLAEUGl0bG0tAIJfPWl
 XAAAA
X-Change-ID: 20260124-fixes-c31dc1e4e4cb
To: Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>, 
 Junrui Luo <moonafterrain@outlook.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1761;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=f7g1FhpB+GrwNVbibH3QaBMbgZBW3Evry53mbp9RM7I=;
 b=owGbwMvMwCVW+MIioLvvgwPjabUkhsySJ51H1iZXzs5yqtApP5yw8XbD2nUKRcG1ufwSC5Y78
 c0LE3jaUcrCIMbFICumyHK84NI3C98tult8tiTDzGFlAhnCwMUpABO54MLwP2tvpVzr/dQnItdC
 zzo6/xDROPR6Q5eey4f3Ry4WTHAtKmFk+Ov8ze76N/b1DmekW9tknN/rMv6rLNrQf3VHl+ykXUd
 F2QE=
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: AM0P309CA0001.EURP309.PROD.OUTLOOK.COM
 (2603:10a6:20b:28f::35) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260124-fixes-v1-1-302a1cc57d1e@outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|MEYPR01MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f32a98d-bc4f-4d0f-7629-08de5b5ce7d6
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|461199028|6090799003|5062599005|5072599009|19110799012|15080799012|23021999003|8060799015|3412199025|440099028|52005399003|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0FmQ0tMc012QnZId05YTnYvU3VreXhxWmpXTGI0VFl4S1JlZVdleFdNa1JC?=
 =?utf-8?B?QjQyb3RkdFdxcHJkR1JqaTZmb1dITkZIRTZYWlRWME42OXV0eGdpQS9MNXFC?=
 =?utf-8?B?bzZUb3U0UGF0SzNnN1ppajByTGlUR1NBZWJMdGc1YThXV1I4SWFTOStBem13?=
 =?utf-8?B?K1QxR1BhUmlNd0V4VmJWNGEvM0IzYzVhL0hJd3hHU3pvNHAzbGJnZTZhaGZk?=
 =?utf-8?B?QktJYlRrdVcxRVYyNzI5bWhDUE51Mmt3aktIc2tqNzc1aUFHWi9nMG9sT2hV?=
 =?utf-8?B?eDhnQ2Z5MXRObytNWXpQVGwxZmxmM2w2dEl3YWNiNmFRTFBzbERqRStIUVVZ?=
 =?utf-8?B?VjFha3dHZE1GMUptOFdhNUdpbGNDZWdYV1oxbXhNUVQxcUphSnJKdEg4eVdI?=
 =?utf-8?B?NXV5Y0FEY216bGFZbkFQRDduTThYZGVFaUp4dFBTNS9wcWFlSFUxdXZJV1NK?=
 =?utf-8?B?eC9aVU1oNzVGZTZjVFduclkxakVuN2h4R09PdlQwNEI4RTdiazh0d2xtcXZr?=
 =?utf-8?B?MnpmRW9mS2x6Z2lVTzVaSXRjN1FBWldLNXVjNVlWUE8yK3YzUjhtbjFnMGhC?=
 =?utf-8?B?SUVnL2lSVk9YS3ZGMlM4REtjRmVadGlPVC9UVDU0SU01SmhZb1piTG5ncytQ?=
 =?utf-8?B?QTRHeFJUUUR2UDNwVmphbklKUVErNU1wMHdLc3FXeGlpRDQ3bWlIdkRIUFg3?=
 =?utf-8?B?cTRVOUZUUUJMNlB6UkxjUFE4aXc4RElXbWFsM1V5cm5DUW10cWs0SHVZR29z?=
 =?utf-8?B?ZmcrN3RrcTlCOC91eXNJN0Zxd2JZVW5PYUpRbEMvamdMNjd4aHpVbTZBUjdu?=
 =?utf-8?B?V2krV2tXT2lyTFFRR21zWmtHZ21NTEk0K29hSmFpY1lJY1NNZC9JYlh0VWh1?=
 =?utf-8?B?dUdPNG1FWnBWOFRTYnFldXJid2Y5NVVxM0ZTYXBuMEFWUFI4aGNPdlJrcndJ?=
 =?utf-8?B?WkNwWElRa00rS21DYUFDS2VpOENodFh1NmpSRGlXT3BZa0tsdDZJZHJoV2xq?=
 =?utf-8?B?OHFEdFZjSHZZZmkwekwxdTVxdm9LNzVuRDNRNkFlQytvVDBFaXhIN1poSk4w?=
 =?utf-8?B?eFkyT2RQWmR0UWo5bFlNcGdjam0zUmFaU3VCL21CalRoMktaeEx1UHZDdTVw?=
 =?utf-8?B?b0tla1VYemFiOUxIMHJlVHdBb09NUk5qaVg2S2p2VWdiYkZKMUNsRk1YRXNC?=
 =?utf-8?B?MTJNK1VRVStMMWFIL28rNGFVcmcyYzdMeFlTeDR2dk85WXM1L2FSdzQraUlX?=
 =?utf-8?B?Q2ovcjhDbzJEc2pYS3lCMzd0d1VCa1pyNncrMklmU1l3K2ZTNmQvZFZBakcr?=
 =?utf-8?B?SEMyZktqQ1lzQTEvRmVVOFRCanlBaTJQeTdlaGJ1Z1B3Wk9jb1hQanhsMndK?=
 =?utf-8?B?RzN1bmhwaUZ4Q1BSMXVFYUpiK0E2YWFJbXdqMmNrVllackFhODFNK25qbENj?=
 =?utf-8?B?ZzJPQ081algrTStGekpYVG1BdE9Zcm1GdDFsRE9tMm1XeUludTB4eGdaMHdm?=
 =?utf-8?B?Z1d3UXc1S0M5bTdYWmkxeUxLR1RscHpSUGJkcmJ3VXpMZE1kT01ndW82OEF3?=
 =?utf-8?B?YWE5RmlLbUlOZTRsUVByRnVnZkI3SVcrT2JOMnRrb2VLdTZXZDA5NWZEODZt?=
 =?utf-8?B?SjBhWjhiaU55RGVVUEFuc3FkWHdveWoxOVhweVBRUHowaUFnbEJNdUNhMTRW?=
 =?utf-8?B?UHFJdWdtc0tGcXJ2dCtUODR3WnNrcjFhdVZlQ2xtVWpXL2dNSHZ6eFRubTBx?=
 =?utf-8?Q?HMwxVPQ0Xa7rhMVVP8=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0lhTTU0eWh3QjU1RVk0a2FGRm5TN0dGNDEreGd0Y0RvNENQYnFGbThuajVQ?=
 =?utf-8?B?UjVLQlF1ZVVsRGRMZzlGdzgwcDI4RDZJUXZrS3RIQWIwc3RkcU5xMS9XYk9H?=
 =?utf-8?B?MjFsU09wd08xZEp1TmkxQzFpdUlvWVY3aG8xWUQ2KzB6QlhQQitOdUhFSzlE?=
 =?utf-8?B?dzA5UDNDRVV2akJPbzRRbTFIMmk0WUx5SGUvUmpuZ2gwRXo5Q1hrM1NiajE5?=
 =?utf-8?B?blpSWVA5czcyalZKaXVwb0lQdzNiWFo1QXY1Q3lxb0p0aG9jaERQQ0k1MzRx?=
 =?utf-8?B?Unp1KzNqRDdkR2RCTjBKcXFxQ0M5SFJTeThQejFkVk1aUGhjeEVjb2VFdmlk?=
 =?utf-8?B?a3doYXFySk11bkUwOXE4MDU3ek1BeTVwNGVRL3V6OGRaTjJrNXVoZW5jMllm?=
 =?utf-8?B?MzBBUVpBSFV4Mkw0M1d6QzJkOVJjNE5NY01MdHRiMmRoQWxUcDdHYk9kK2I0?=
 =?utf-8?B?cmdhVjBlME1zUCtTTGFSUVJvdWpEaFhlQi9lb0dFQzlTa0NBZ0hJWFB1anZG?=
 =?utf-8?B?NE52dzFRbGxleG5TTm9kSFQrdHZua2VUcGEwOXpIZytNQU83d052WEpGN2x1?=
 =?utf-8?B?QzBIVnNzNW9BUXphVHN6VDVLdi9rc2hpc2VoUWFvcmprNG5hMXd2ZFYyNS9K?=
 =?utf-8?B?RVNjWG9pQnI2U2lvdFVhYTFYb0Qvd0dWSWZwUmJvdzZCMUxQNjRHZjVGVEg0?=
 =?utf-8?B?TXVzY2Y3ZFZzWlJLOUI0eDEzQ0F1TG1mekI2aDQwNUhiMWZYM3NZdDdXODVE?=
 =?utf-8?B?dFB1NlNSOCswa0MvcWdDYUJtZnVmL3B4TFUvMmIvOHBPbVZqT2VEUW82MUw2?=
 =?utf-8?B?WnNrcnQ4NlczZEhNeXhkNStSTWYwd25RMHVKNTdvbUU3ajRvUDhUMUZMbkd5?=
 =?utf-8?B?N0ErMFdlUFJqVnA3ODRJYmQra2JQNS8xS2lhQkJRdUNUN1diZ2d6V1oxU0Qr?=
 =?utf-8?B?RStJaDVoTmFlTlRzZVprclJnRnI5QzljQnhrVUFLTEpqSGE5cHBJUkd4UzF3?=
 =?utf-8?B?MEJyZFBSa0djazdkRnc4VTBqMzM1MHFxMHlSNlVrTFhERVhSempIemFPMXJn?=
 =?utf-8?B?TGxZeENlcEVnT3lOZ0tGN1ZFVzRPSEMxWitzVkF2NXV4YlJpY1k4ZjhhQkFr?=
 =?utf-8?B?NzcxWFZlUXBEaG1FYVUxNTl0VmVUVnZpempyaHRHSGJvY1ByZVIvMXpKYmxH?=
 =?utf-8?B?SnpwWW85SmNZejlzVUFVZHdLRm5zWks2NVc3NjhNOGU5U3dpMTAwQTVQNThI?=
 =?utf-8?B?NEhvNWszd0pQQXNDUjhSNjZ1eDN5TDhSbDV4eWRJbVJxZC9ienRlSGsxb2dU?=
 =?utf-8?B?UXVtT3VyNUM0eldFdVBBTDRKb3gvbGs5T2dvZ2gvbkxvYzFoRGV4dHlKMjFX?=
 =?utf-8?B?bDliT29Cd0pqanRnNnU3TTZldWgvU29xZVQxYnRoajBFTGoyTWkvQitaN25r?=
 =?utf-8?B?d1UvSXlORDc3SDZrM09SRC96cVd0TVRmRm9jOHo2cWEyZVhzbElGSERxMThX?=
 =?utf-8?B?SGJoNXlCV1ltZlFPeGVpaEN0V2tud1BpTzJJY0NQa2dTN0RZL0txVmRmODFn?=
 =?utf-8?B?TlJjcW9CcVF6d0VVNGlFMFhwUVQzbWZET2NRdU5JaDM2RVc2Q0VValYrQU9I?=
 =?utf-8?B?ditLaExTbXpKdWtwSmRxYThUckRONTVWdDJsL0UyYzVlc3JBQ3dWUEhkRmlN?=
 =?utf-8?B?VHU1amNsWE1xU1NxZ0Iwcms3TTZuNkdja2hYODlLQm5iS2IxTlVKTlRES2pR?=
 =?utf-8?B?d0VCclBzWFdCT3JvOEFvdEs2S1FiWC81OHVPaHV2WkwzTWd2NXpNRVptZ1U5?=
 =?utf-8?B?bEN0aE5TZHhiUHJ0NXRua0NWWS93bWtuYjBOWTMzcSt4Y3NLQUF6TllHdDB2?=
 =?utf-8?B?b3dvN2Fza2hVelZtZlVXaDJlRGNnUGRydFdkNkg5dVN2T2c9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f32a98d-bc4f-4d0f-7629-08de5b5ce7d6
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 15:26:12.2937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYPR01MB6661

The discover_targets_done() function processes a response from the
virtual FC adapter containing a num_written field that indicates how
many targets were written to the discovery buffer. This value is
assigned to vhost->num_targets without validation.

The discovery buffer is pre-allocated with a fixed size based on
max_targets, but the virtual adapter could return
num_written > max_targets. This causes an out-of-bounds read in
ibmvfc_alloc_targets() which iterates vhost->num_targets times over
the disc_buf array.

Fix by clamping the value to the maximum buffer size.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 072b91f9c651 ("[SCSI] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 228daffb286d..f346dee4a0ac 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4965,7 +4965,7 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
-		vhost->num_targets = be32_to_cpu(rsp->num_written);
+		vhost->num_targets = min_t(u32, be32_to_cpu(rsp->num_written), max_targets);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:

---
base-commit: 62085877ae6592be830c2267e35dc469cb706308
change-id: 20260124-fixes-c31dc1e4e4cb

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

