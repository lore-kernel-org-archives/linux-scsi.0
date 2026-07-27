Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8C638F934;
	Mon, 27 Jul 2026 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165970; cv=fail; b=YW8W26JdZWzAHySm8SMyga3uTz05x1ipadSHZcXcCdPyJ8UfMl/D+u1XqaxDfFJre9j2x09QorPKG0C5DBx7iwbBId9jwdDuZAFEn8IjTPe3f4+I3W+tK9veT0MvPo3eZQKhSMsPPAfIwTt7PT4c/LayRhxkHpQW6EAxyukWSf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165970; c=relaxed/simple;
	bh=8ZhdvDveQLVtwQQAjJo2KWufVdmUZre+t70cv0FPvFA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UxxxXxTXqVKC0hYHYSh3zx38avrop1x4t1rvosRgRQy2LaI3tWS9iE2F93LijekuFz0iHzl/eGadvc+7yPGWTnVlJeXB9NbOY3Tt3nza5bm81ZcMrr4Q0juFm1XB3lQnlljO2g+nFEHSKMJpOs0xPwez44MkA3N7eXD7cqSuDv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fC2KF9XG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vmLB8pa+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fC2KF9XG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vmLB8pa+"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66REtZbA2614212;
	Mon, 27 Jul 2026 15:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pjeRx0ncVGSJ2pwlOQLIy4ccKs/te2zvgMnKKaCLupI=; b=
	fC2KF9XGfBpXyPN88le02AOyA9nG8jtSuo+cDiBRjrOnxas8MBw0XwgOWwnyg1b2
	QkCgkJh2siH8cpwQ1bY2QmJIWNUkMqGmhPXhZMU75Cv+wfkm9ZKPKHeI+p+9uU7Y
	/A/EXbl1xcRZZW5kYbwSbQTXMwTrPb0PBniOudDgvBncMgqOpsq2Ch9OIpn3jheb
	GtRsVi+bNY5bR3choCY1wUv81e3+kRHwOxQnar4tBWC3glWEzruDqBFrrRxMAP7C
	HMrgz5WDUuMpDUVmofsp0Gr0riJAbeq8i+6JgPHJnZ7Z1ohSv/+Ldid7/ZTdkPF9
	d47rklqmr35oDDONWLo5GA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr012285-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:26:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFPUZP006986;
	Mon, 27 Jul 2026 15:26:06 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010062.outbound.protection.outlook.com [52.101.61.62])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6njpcd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:26:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BTROKaoI58jUvgoMhMd5k2oc4DCCNZ1vX5JAU/j2cZLRS21jlvyHouHHpWf9k4n8P4epXYzb1E6xRyU0OKbh4RhGBopPXnek5E+d9NCN6ValmpEqZd4gBTlXa9GTh0ym+GxDkF8k1HsKae/lh1vA2AoG5dZAJlp2+MxXHPwhYJXy2sa3tvciiD7vQDrHwTNjAgThDHT6g8Opkc0ufLl1Vjk1fnE+M1pwpvOD0IrmZMYu447H40eK2rwtShsP8tFK7WjCzOARxA9+Q65yukApKQIQhHP/Maw3siVNFbVOXexBmQ4y2aGaKbpK7hAm73cXa3wlTZoW7hYmDXly/duHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjeRx0ncVGSJ2pwlOQLIy4ccKs/te2zvgMnKKaCLupI=;
 b=eIgwNcxfr2OaMiDWH/tRty5fippVIMnEver38P/OxQJVeWo2LX5SL4erE0zH2XWS4eNKo1oHWh2TK8i6DOlrnWqnmtigQvY+e7Z7wtGLPnMX0XxTgvn0utWZTLPhm21ezV8I6YuIW0K0NiLqpEws68V4/hB2wfLb+cmjNF8+72qagsY/RSvxjzdvscvAWr+Ik8o+p7XB2+6Isuvr+6FjHIO0bQIgseRWpKyuiCJvI8pduzMO8ELtc3Za4Ikoik7D1u9MjEK5UGyZb/2IKRgcv1yaW2k3gDA10a9NmYiYDva6ZS+oGvWBM9pcfNeMMabZgftZ/mGulEtN8Gba5GGVHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjeRx0ncVGSJ2pwlOQLIy4ccKs/te2zvgMnKKaCLupI=;
 b=vmLB8pa+WxU6c687mq663B4sMvlQK0uwuxv/RTR/cWbJ9wNRDwY9XnIc4zOB8GBkbzaDgtVIB7fIqiDaSta2DTT7wIahmNThJpd0JiI4DMwotYdqgzw8+XTAtSLKOm//1QA9HWDf3WtS1/EllsVng8i2N+wA7n8V9T3qoEopJoE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BN0PR10MB4887.namprd10.prod.outlook.com (2603:10b6:408:124::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Mon, 27 Jul
 2026 15:25:29 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:25:29 +0000
Message-ID: <9a2a8d21-8f46-4b64-913e-9145b4d171a3@oracle.com>
Date: Mon, 27 Jul 2026 16:25:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/27] libmultipath: Add delayed removal support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-7-john.g.garry@oracle.com>
 <20260727150045.B19231F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150045.B19231F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0319.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BN0PR10MB4887:EE_
X-MS-Office365-Filtering-Correlation-Id: bff30ef5-1d6e-4756-b394-08deebf34ac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|6133799003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	T2PZDCZLWJqalizJyT3WezPC/iqyqv+9BFtR+BU5osR/thJfAkXlv+egyX0mfk53komuJSkwQy+5IX5Q2QfnNyGiYBPV7diuVJ/Gsu1bjKcMV5FxwFkNYzy/xhMvrpJqD8O4WpKcHbHXEk/C8rpTcBQx3WtuxKOnSZv6tswbvpf5ZEJdVXMVGHCoMFSZds3CLUCJUoWfWk51Ctn9CpKaKAqL9kQ98IbPKhRhhsvoGAdzpbBRBzZk6yGsj9VM1BRhlNqngCHZuzzauprlia9Ov4A4jXAjY/eInzjonPUxWrPogp7isfmde1RdZ2sw6nm9gZQGNLXnnv3f4Vt48djn7gZXdonU4pxLdM6rSA0h0A/4smUnZBp7OAykjyfy1fR8270v2URZlobtdDCGE009iYgmob7i+2R4G2MhbLd2DYaEE32yOgZ3PT9diIDiepytuBi6Px83i0InTg4wBEOAuuxFyjnlx5rU4mlDnfDB+umP531dOEeMM062ETKPvq4hz3rpl3PN1sd39qmA5XdqkJ8DN6Su0Dw9JNM6j39z4NR5Tn7RvnQh8hEA9Qal7VGqMuFZCuS3gS4/p6UkaelNyVK559YJLh5ErRYapdfBnOnfz1uvqoDIMRSaeYvoi4gmAgO6dId2eZgaE+xkYRTJzH9zB2hy3ufiaFc7gdncKNA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(6133799003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q040cHBzM21jMVYxMVlIS2s0elJkK2VLdkRDYzB0VUxsRjhSYVBuQ0k1WDBR?=
 =?utf-8?B?bnAzeDBTUWJUREFER3ZDVVpnckY1WUxGZU9CYXdweGFxZnRSOER5ZlB6ekJh?=
 =?utf-8?B?eWg5bEJqUTc0cHgwT1JsdUtRYXM4QUd6Vit2SmhDS01jRUJHTUttMzJvUlF5?=
 =?utf-8?B?QjF0NXNqUEVNR3RZQUsxYUltRVNjNU1xajdYbnhiUzUzNDFGTzkwNi9XVmda?=
 =?utf-8?B?QjhiVmtjbTMvMDJoa0dLaHVZNzBMY2t4UFRQeHJUK0dHZ1pCcWpObGkwYWtD?=
 =?utf-8?B?Sm5nS1JpZ1dwQ09IN1kyUEFYckZCdnYrTlBRK2U0QUg0UU1OL05VSDRRaUI4?=
 =?utf-8?B?S0h0UFJxWUVRK0htZmlJWUQvTHZrYnEyczk1WnNrR1Y2dktza2ZnWlZvTnov?=
 =?utf-8?B?b2FndWtQa1J0UFJGdGNaZlZPbHJBRDNRN2xOTjFqR014UEFvcHM0Y3k1SVNS?=
 =?utf-8?B?Q2xUUGVUU1p0TjNiWklqRlZQb1pEeTgxdW9VTEl4YWZaTmQxYkRZUitqazlz?=
 =?utf-8?B?N0lvVFU5R3FBTkk2M05jRXJ0RmRxZ3Bxc2Y2QVZpVXkyeVVJQ0kvekkydFFN?=
 =?utf-8?B?dy9tS1NIQWhjc2pWa2FBZ0dMRDBVWGRUY3UzUVJYbSt3eUJDL1p4KzE5M2lw?=
 =?utf-8?B?R2R5Ulc5ekcvOUcyekJNck5BUUVZQXhVbTJVS2doSEVXeUljWVlub1ZaMHVk?=
 =?utf-8?B?UzlXQTJWOG0xa2pSbjdibkt4OU4ycmJCK3lJZmJDWWhJd2VXRllER1JpNWpz?=
 =?utf-8?B?VHhPZG4wUXVaOVZFUEdyTHhhWE9QQVhnRTNlVnNUQkoyUk9YZllGU1BCVk5h?=
 =?utf-8?B?VnZmczVKNTNBbkt3NUsrdG5EVFNvcHB4THdIa2M5TGlBRnRPQVRaRWNkNmF6?=
 =?utf-8?B?Qmtya09NS1dKaERoNGo2MHlGNlZrRWk5OGZDTXgra1F1L08yaG50N29TNzFI?=
 =?utf-8?B?bjFzU3dIRjRQVlNoVlZacXdPSkh4eXM0RndPZVBoSUZnS0dpNk9FUmRLWGQz?=
 =?utf-8?B?cmF1NXZPY2pVc2ljVVRXYzNROFJpREFwdXFVTFBNZmpCSjFlSTIvMklzdTli?=
 =?utf-8?B?Zys4YkpELzlIaGNLbGZLMWllMHc2dWdRd2taUVBFS2ZBSFE2NFE3UERsWHdT?=
 =?utf-8?B?QkNaM1ZwM1E2dGFrVnZuVnVFZjVwNkFhbkZaMEJoUnQ5ZVh5WjZ5S0E2QmJx?=
 =?utf-8?B?cFZTdTR1a21RWE5WeVlDRGFwMGNrNG9VNkt6THB1cDRGWWJmMExVZXNSYm1j?=
 =?utf-8?B?TjdkdDJPWE5CVmkrV2l6dmlYVS9sYnM1clVBSnU1VzIvREJNQmhMTVJ0L0VG?=
 =?utf-8?B?TjRuMzA5MUZ6VVZWWUpTOGR6MWxOSlpBK2tuRDliUzRjYTBETkZoeldKeXha?=
 =?utf-8?B?Y2RaekZLMlRUWXA3bVB4a1ZEV3RNSTBEeXRuZVVqUDZOaDM4QzVXcENpZUt6?=
 =?utf-8?B?dXJFS0JSaDdSVWlFQUdTYVBGYzFDbnRRYVlDUjRxZmIvenMrc1UrbGc2cXg4?=
 =?utf-8?B?UjdmV0FpTDZBZGJac0RZME9xTkFjUWpKdlE3NW4vRUxzajYzcTRLaTJQeVVa?=
 =?utf-8?B?VEh4RjNvbnNaSzNmOFM2cnAwbHFNa01nMFFOYjI0YWlsNDcxd2JyNHlHQm4y?=
 =?utf-8?B?TWhlNE9xTFAzMFkyakVFbHdVT2hpa3d2VkJMWmhxeU8xQTB0YzJDVUhZdkUz?=
 =?utf-8?B?MXZFbWNIVnQ3SjVVb0ZUZm5rSFlvd253Y1I3QUJJK1F3UUU5bEM5bE9DZFJv?=
 =?utf-8?B?dXB3cVRZUHl2aElUVzVGU2ZoY0RBNmlMTW5Rc003VVg0WDJzaklxNFV2OXA1?=
 =?utf-8?B?R3JkbFU2VkxkZFh2cjNNREpnRkg3M2xzM0hDZDJUUmh0ZEVsKzNiNlVNdTRL?=
 =?utf-8?B?ajFtMDN6dFVRK09VakNodndQZEIxNHQyY0p5UWN1dzQxcEJHNjVxVCtUbktu?=
 =?utf-8?B?eWhWaG15QVpmalpGYlZaQlhoSS9vdGZyblovcnM5UkZXR1pMc25wN0wxdC9F?=
 =?utf-8?B?Wms2bnpOTXI4dTNwZE8vbHpUeXU4dVhKb3pKeW9YNW9UNDlSWCtrN3J2ZDVZ?=
 =?utf-8?B?NTVuNVI1d1BzSHM3WUh2V0tIRVZBRGtGMVE4VTB6OExxcmFLdFZPVVhyM2Vj?=
 =?utf-8?B?VW1TTTVWbmtpSWZZTUlSeVU0ejJpUEkrUFFjV0w2cXZlSFU4dk9DeHcvRVRN?=
 =?utf-8?B?NWh2NW1EMlIvdmZBWTNqdURvUnZDbzhMVVpUblVQVFlYMjB2eHRJODJUVXBj?=
 =?utf-8?B?MUYxeWxkcTNycXpua3NSTHZvTXRyQVJiRmp0RWxnc1RnbklVWW5kREdCc1Ir?=
 =?utf-8?B?WjlhYXB5cU5RNy9ONmpzdjh4cVB6Z29VWjAvS09tSUV5SGFNSSs0YmVWYk5u?=
 =?utf-8?Q?fuBdLDJpEhpLJWkg=3D?=
X-Exchange-RoutingPolicyChecked:
	LsMPw2g5pxThle8SGYoUjx3rfPupAWcO+fsVJXhnBm3GszYcmNBSbPEjMA52UOpBLTFGkzPl2ovzV8VszW723wP9iMZUDKZM/qG1iPY+LUSwChQ6jRWv2i2ZmO/2H++s3YkrAsAWA4RG5Keiufbs/5YngicW5s1S1KncxWF5JM9/oG+zmvWjE4tRbjiAJNYF0u2cMrhZ9e3gwBwjbVRANE+fHT2N3abQU3GtOILsnQ2/ptO4Qvbm+HAa/Y+6E8YdfEr3ct/mimmlokjvC41f8c01GTTlwM81BELZ0TMAkRjqs/avTRYMes+knFkdSBiHoOTwqBcWpwN5bLao7fa6Xw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FY84p+vsyf7HVSfFvooT4uTgk5hB//ZdLrhOll6k1FvT9n7n1tlqCnSYtqsnfmyUJwubw4xR6NBnfF7EXGSqAz1gXsZQQ0Q5UNflv7b3ga9J5YjMlmHfCEonbC11BjEsyvymcWGu/mGCgnCTmynCuRLWb8wb3SqUpvylODLJKitiisdbBKzlvQ/lqQneMc/hVJJDtCo/5Cc9U6exQnEsms08ZtXbASPoAeEcwRtpNmT6VIKoSqbGMyIn6xDKxfHehqzsnDtr8fjdhl1CvdJWCgIfhHIq8Pw/qC6kSo8IQQNZ9pXBYuYi3KT7auJoTYITxbzKPC7r/JNS3+3QcqrNYFWQP0mfh3f1H/OXedbHh8rY9CDPqWQDm92ivfecZ1xEKvv2R34yppIwJaKwtlrHjw5cLqw5CBA58ztrVkT+kAribHF6Y5/RewWKp5bbglthAb8YrfXO4IPHiWXGVvLwPs6SRArvGv4pVN7QXGmt/N0pQfBSVnkG85oHegSqZW/EXgUBRS1CzVGe6k8AD0qjscJQs6uVeCcSr3ZhwmolzBHYpMeXvXfG+hwSksx5dhz8gWlFfO74mPt/1wh1ovgTZ8qF32zP5va+Lnfv0lM7DjY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bff30ef5-1d6e-4756-b394-08deebf34ac4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:25:29.8378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9oYAbsQGUkjBq5updD1mhGB7UEEok7kQGv4ugi4xXfGC4s3dyxedqznPxk693s1QmSjnzpjFJKo63kmj0aYv5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270145
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfX0iOtTet/8xy1
 WmHSLZgtPlcpfzrKmHzemL5qo3qN2LY3SHpacOFC2vzatGp8bJffT6cE/RDSR6Pp9bCqBnDcH+w
 NWWrtSDS5sK4/nsZ5OfWhiCjvF713BUjlZLCuzn9dj18HkX4s98T
X-Proofpoint-GUID: z5qkXwyq7_9bGY3S9dH4M541hMsiWIVR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfX0H2flN/d8gnu
 DhjGM4OquXfqFM+15gWVvqZmxFXdftkE8J5Lj3XySgdIernhGeU36/c5kkN0ezvQxrf/QsnVM8p
 GkO68W5afPn7yLsdv5bTn8DvTNFvcCZdpbu9PdPKtikU4QIvYlqIY1w7NLbbFHMnnqkQVT9gMso
 c1SPAQJtDa4opBm8/GZSK70ZCCiHSxNIxWWfDo4hGNGkSg8Xkwku4tHKol3Xs6hkOyopiHSm4R9
 GzdF6LcVhR6AatGKKOAjVxE6jokaUvGWQkDGAxepd4AemZt5wMbSd+QwNEJGZRC2kUq/w+5Dygc
 VqB0lN1TwwUL3KK/RAdpi8qc22O6ia0hq9MjBln+A0K1RZZaSVA7EN4TxFo2+pL8wSiOzm5//7i
 W+zpbkF1pt0qTVirijloL0p5//G7pnqekTqRzgsYngeoLTWwX0U56RfCIAAZZUsCZPo6tk26bk6
 5eGpgyKXYXMAnXVGdfRfcGxPC+sAWY5U6ur0jOkg=
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a67788f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=1ZA0m_Fyh7e3CJhPti4A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: z5qkXwyq7_9bGY3S9dH4M541hMsiWIVR

On 27/07/2026 16:00, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [High] Missing synchronization between path addition and delayed removal causes Use-After-Free.
> - [High] Missing cancellation of `remove_work` during head teardown causes Use-After-Free.
> - [High] Disabling delayed removal via sysfs leaves queued I/Os stuck indefinitely.
> - [Medium] Module reference leak in `mpath_can_remove_head()` when delayed work is already pending.
> - [Medium] 32-bit integer overflow in delayed removal seconds calculation.
> --
> 
> --- Patch [6]: [PATCH v5 06/27] libmultipath: Add delayed removal support ---
> commit c3a14a8d55791e59aaf6def4186888f9333f0985
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add delayed removal support
> 
> This patch adds support for delayed removal of multipath devices, similar to
> NVMe. It introduces a configurable delayed removal window to retain the disk
> and cdev during transient path loss.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index f70049b6cede9..ede06e5e901c8 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -65,6 +65,9 @@ int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
>>   	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>>   	mutex_unlock(&mpath_head->lock);
>>   
>> +	if (cancel_delayed_work(&mpath_head->remove_work))
>> +		module_put(mpath_head->drv_module);
>> +
> 
> [Severity: High]
> If mpath_remove_head_work() is already executing when we call
> cancel_delayed_work(), the cancellation will fail and return false. By
> dropping the lock before this check, is it possible for mpath_remove_head_work()
> to unconditionally tear down the mpath_head without realizing a new path was
> just added?
> 
> This might leave the newly added path with dangling pointers to the freed
> multipath head. Should we hold the lock or verify the execution state of the
> work item?
> 
>>   	return 0;
>>   }
> 
> [ ... ]
> 
>> @@ -480,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *work)
>>   	}
>>   }
>>   
>> +bool mpath_can_remove_head(struct mpath_head *mpath_head)
>> +{
>> +	bool remove = false;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	/*
>> +	 * Ensure that no one could remove this module while the head
>> +	 * remove work is pending.
>> +	 */
>> +	if (mpath_head_queue_if_no_path(mpath_head) &&
>> +		try_module_get(mpath_head->drv_module)) {
> 
> [Severity: Medium]
> If the delayed work is already pending from a previous path failure,
> mod_delayed_work() will update the timer and return true, but it will not
> queue a new execution of the work item.
> 
> Since try_module_get() unconditionally increments the reference count before
> this, will subsequent calls to mpath_can_remove_head() leak module references
> since mpath_remove_head_work() only executes once?
> 
>> +		unsigned long delay = mpath_head->delayed_removal_secs * HZ;
> 
> [Severity: Medium]
> Could this multiplication overflow on 32-bit systems? Both
> mpath_head->delayed_removal_secs (unsigned int) and HZ are 32-bit types, so the
> multiplication is evaluated in 32-bit arithmetic before being promoted to
> unsigned long.
> 
> If a user writes a large value to the sysfs attribute, could this result in an
> unintended short delay or immediate removal?
> 
>> +
>> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);
>> +	} else {
>> +		remove = true;
>> +	}
>> +
>> +	mutex_unlock(&mpath_head->lock);
>> +	return remove;
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_can_remove_head);
> 
> [ ... ]
> 
>> @@ -525,6 +571,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
>>   	mpath_head->disk->private_data = mpath_head;
>>   	mpath_head->disk->fops = &mpath_ops;
>>   
>> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
> 
> [Severity: High]
> Since this work is initialized here, do we need to ensure it is cancelled
> during head teardown?

No, check sd_mpath_remove_head() which checks for new paths added

> 
> Looking at mpath_put_disk(), it flushes requeue_work and partition_scan_work
> but does not appear to call cancel_delayed_work_sync() for remove_work. Could
> this leave the delayed work active in the workqueue after mpath_head is freed?
> 
>> +	mpath_head->delayed_removal_secs = 0;
>> +
>>   	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
>>   
>>   	return 0;
> 
> [ ... ]
> 
>> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
>> +			const char *buf, size_t count)
>> +{
>> +	unsigned int sec;
>> +	ssize_t ret;
>> +
>> +	ret = kstrtouint(buf, 0, &sec);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	mpath_head->delayed_removal_secs = sec;
>> +	if (sec)
>> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	else
>> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	mutex_unlock(&mpath_head->lock);
> 
> [Severity: High]
> When delayed removal is disabled by writing 0, the MPATH_HEAD_QUEUE_IF_NO_PATH
> flag is cleared. However, does this leave bios already queued in requeue_list
> stuck indefinitely?

How is this even related or responsible bios already queued in requeue_list?

> 
> Should we call mpath_schedule_requeue_work() here to ensure previously queued
> I/Os are flushed and failed?
> 
>> +
>> +	/*
>> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
>> +	 * by its reader.
>> +	 */
>> +	mpath_synchronize(mpath_head);
>> +
>> +	return count;
>> +}
> 

