Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A2735A3A9;
	Wed, 15 Jul 2026 08:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104286; cv=fail; b=pdB5gy1FnYArUiKw++kxMOwMRz7aByjBwjn2WfTb/rFcqsp1DS7If1GcGWxJOzYZEHWTds+/sarG9/pU8t7dCLI6N7/ucDlSqElMbRZOK4lzpkecDKaLXTP7Oji9mcpIgfaljnyBDHZOCpMrpdtta33H1YV4VlZbxvJXyxCPYtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104286; c=relaxed/simple;
	bh=lZbpw1ul7im/WkkiGDhwRsQpIh+Rk9aT83/YJFsMIUk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J782ekxVsCQF2ItPZaxiH7qbyI83fGzK2nrCtPWlT0ooRBCxP0sIZ0SWV3jyrM5evK+N8zffx2edQXp72UXcMdUxoT/Qx3zLrI9+iSTV7wTxdNodR+GEG7BD/+f6J+gP6bVITyiPPQ1MhLMhc5DVP3JfGtDcru/kOy9QlSbBOVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SKowNLua; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UckM9MKK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SKowNLua";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UckM9MKK"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ENN8qF239049;
	Wed, 15 Jul 2026 08:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bAXQh1iFwERdNvZUzQug7BIc4OezIpkFcqE5qBv3lnc=; b=
	SKowNLuaC00LLqmsErF+NxSGtw5q/6nXHY3CLGiRMynyDGlT3BBeZ86BHuiFsHsu
	xU+1Z70t5NCon7jG3Q2buW4zcQxjgu3KV04O0hV3X/NDes1st/GMM0tIp/qmOJOI
	zQm41H/Ke0nme0MW/TfYIpWqBfXHkNUZhONjZkS4vVpuD25yNC9Iapa/TP5Bhb1I
	ohK1pG3bmAZTiD2bMDKzi4KnxJdHu9lJYYv1S36cqqr6gKwNgQ9lfY4RSB/gBLS4
	dYWUHi8/TU3sE5W97nAUvX1/prvRwcAoXT5IKW45sVTW5hRrGixW9vVwKrn/ORJA
	e1rN623ZUf2NywM74rmoBQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed86d58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 08:26:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66F8Naki031169;
	Wed, 15 Jul 2026 08:26:10 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012059.outbound.protection.outlook.com [52.101.43.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9sd50p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 15 Jul 2026 08:26:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMsuMNM66RU/GEfZcxgIPOgFi0tsDsoomRwzVnpFy5OTZYlP1feTZJQopLXLAMu1naTQDegbm7ACDUi2auLvZvY3sHBCe6FWbUAazFtsxLHFBOb4c9qbpxzeTITTkVvPf5ssK0ij+k/12OuW4HQkZBNxuH81Hs4DxRD6scGzGNz1qqEYTxrFkdIQV43v8MJL5qn/2yJp3L1zFOeos4FEqmp+a/DAETd0DEfBolQEF+627DrG01gEF/+mg/8juhFFTMm7XYNkwqt9+VxSw5r9rxv6SbNBD4SV8kbrxsnbgrkG1HANhnD19yabMszParqINpOo+ALh4mRuMkQwaeyyFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAXQh1iFwERdNvZUzQug7BIc4OezIpkFcqE5qBv3lnc=;
 b=yIbfV0tuTuKphvVax6EDaJovCw6jaQsa39FlPBs1aIEzjEbXB7QkpDGE4ltyGm5sbipdxn0ZT+J4DGm4f6B/BDhhlTM8Gp4RcqeAqFrRWyANJE8OGG8ROQa6Yx5ENzfYxPl1HQUpswbuF/r0R/tLipHTi3acSQaT9HWuSu+orNJ6UB0ys39v6kde2uLoiUx+5U62CSnGXyO/agw1igvphVHNKfYCx7Y6M4B4HjAcuKmCMyRJ/Qo/BIUpKQDKfdk2CtvRELltED8lD319ddv6L6VxLNNdLcIDAqklKEmwnPlCXO65nUlN4BmXJRovYPuxsBz+MkmMO6jJdus+7KqLPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAXQh1iFwERdNvZUzQug7BIc4OezIpkFcqE5qBv3lnc=;
 b=UckM9MKK8blgQTCFwt6kJuUCoBo9Sb5F1PQ05j2epipDZyJX15+n3cHNVYofqBMDjA14t23p8pIGESZJ+J4rI+kJmUo6xsWkX+c7wa5qrMGI1JHWwNJ4Kl95LuSkEBsiKJN9euyZmfE+EhvO+iY2fmwscQ/oLRhRwU4fnRPMRqM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS4PPF7BD9BEA92.namprd10.prod.outlook.com (2603:10b6:f:fc00::d2d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Wed, 15 Jul
 2026 08:26:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Wed, 15 Jul 2026
 08:26:07 +0000
Message-ID: <90dd58a1-598d-403a-a29a-266924d0f577@oracle.com>
Date: Wed, 15 Jul 2026 09:25:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260702033211.1743313-1-yangxingui@huawei.com>
 <379091c9-3cd2-7599-baae-8c7f278e7ec3@huawei.com>
 <56d1c5d9-cb3f-4bef-a099-304ef0c49837@oracle.com>
 <e91cdddb-2323-904f-dc63-3d00597b5c8f@huawei.com>
 <de319ce0-ca42-46cf-87ea-98c93c73bc8e@oracle.com>
 <b1f12c52-ab0a-e146-6559-858eb5e581d6@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b1f12c52-ab0a-e146-6559-858eb5e581d6@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0085.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS4PPF7BD9BEA92:EE_
X-MS-Office365-Filtering-Correlation-Id: 018042b8-dc00-4151-7a98-08dee24ab7ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|4143699003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	7nbTSmlZQzrcjCWl3fj1YOVQN99mzboyoAXIH4/hNZo9nrm199E8knsRHaMn+ykUmH4eTfhAkeywN9cynyYxdA3U/LxsXcaDa6L4uAvlw2qGFvQWm1r3KBiSVb2ZnVbTbPCuR6kDNCeLZ5oxwSG3DPhKE01Z3Ge9R8LH3JaS3JQCokBLGdKGuxGRthkxd+tnxBnZ3GJUX7VZT7JGywxuq4K2ZPn/wfRmiFuxy1jEI4dUws0hneFrvU2ltknj5xfPRCJBKWjQIzRer0QnLiXPsf/ChI30GXq5zpzCCyRcptUgR9t/FOwKbZqZtlQSKtkvd33j5/Pb0SCfT8SZUl/C5XnlF8jI0Kvg3dFUBkTmEFbq4HU9USU/yZaLr34sBLQ3e0nHkYlIWyM6v6dxhAgWxsG5Z/eoDgn77A5rfZbk15i+VidlgP3VjHUw899o2XPiWA+592hr9WWRzAL/XvAj93DBMxI3tb1rHrGT194xrDezTRBU59DoJAk0VqUeBiBQyD0gN4WXlKoGR6kM73G/7CTIGUO0CHUkH9ZPPGR06QkoOul76y62NYOHEa+s6gHriR9r3x7PdplPHMh3BUXosM346HAFah5D+xmyJo/afV6efUrLH5cL5L8862ORXyNYtRpyLAShSzwl2YxRR79PtrCcFCs4IhzPm/2HLjWl7s8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(4143699003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkY1cXJBR3NwY2RhUEZBSk9WRUNTaEpzR1Q0ZU1oNk9VWElpZjZPb2J4SWpZ?=
 =?utf-8?B?OTdCSVEwMkxsMFRKaTFwL0VmVGdCWXJjL01Fc3ZVZVNpZ2J1OFlTbFp6Sy84?=
 =?utf-8?B?RjQrYmJrSE1uclhHZWwxSVFyb1N2Z1RrdGk1ZFNHVm1BZjkzMkFhNkx1eUxp?=
 =?utf-8?B?VTdqQzVHWWE5QVg5Qm5lRmRBbTJDNEhuTExiY0NldzRXNFpQcEhaLzRVejJ0?=
 =?utf-8?B?T0Y2NklaUmVTYWJic3VtaDRvSitFdTY1cEF6OVFVMW0wMlpncWgwYWdycjFN?=
 =?utf-8?B?OVYrY0Vpb2VNRkVXU0JIRkpoUzhGWkJHYS9MQzV0aFJrSk9rSmMrUVYzZVh4?=
 =?utf-8?B?YjJpcit4bllHcmVKOEtXemk5ZmJrOWVEbEhtekVwK3o2MTBLSFNMYXU5akYw?=
 =?utf-8?B?MlQvMllITldWT1lhM2Irc2pubDhEZmNJeUpIWVNSUUdyemFpUWFhSTUwTHZW?=
 =?utf-8?B?WGV5NGp1Rytqa0phWFlKYU01bVVQWFFUemUvQWFqNzA3NHQxSTIrTzM5U25v?=
 =?utf-8?B?bW5vM0NkaWVZa0ZQc25zOEk4bkFiV2k0YnZucU5oRk9rbkZ5NzdGNUlWMUY5?=
 =?utf-8?B?V09zbjhac282c2RkZDZ4UlZzR3JsSVJZSGlJc0VROWNtTnFMUzJYMXFXSXMr?=
 =?utf-8?B?SkJzbTlxTVdnQ0JnenZzbjlzZi9VUURuaVhaM3Bzd0owRzlvalpUOWs5dkds?=
 =?utf-8?B?WVRPYmV2SDViOUVRVldkYlJrQTRrZHZVVU9LazdRMTM4TTRNcFByZy8vZ25Y?=
 =?utf-8?B?WnVNUVVmUzFESU5DLzR6U0lGdjZaMmlObitWTFE5em4rQlBtdHlxLzNHQWF5?=
 =?utf-8?B?MkhKY2tPbm9SRXpnREhQdEtySDBCMUttODFTeUlleFJwemswaVVRTU1SUGgw?=
 =?utf-8?B?cWd2TmVsUm5TS0RnbGgvc1pNOGt2bU8yK2RNWUM5S3U0ak54V3FYYUJxUGox?=
 =?utf-8?B?TUZySWVBSmNzbjBuWng5TTVtQXo3WEkzdzVlTmdxT0pqb2RrSWgxZ3p1bUlp?=
 =?utf-8?B?dU5Hb0dYQnErTXEySlNOaloxK2xMVHM5dWM0bmVkcDJWdjNMcFY5RkdWTHBr?=
 =?utf-8?B?WG4rbE93ekR1di9nUkFxWUVvWjRvM0ZjZTV2eUpBRFJ3TzVEZlRKeGR5dHlW?=
 =?utf-8?B?K0VTempvVDZBOW92L0c4RXBqU0JFSTVxQllGTk9BdzYrY3dRMkkxTUlJRW5Y?=
 =?utf-8?B?VlZRTWMrWGZSdlhHN011dkh2UFlhUm9FSUt3aXVvWWJuaHdSRWgxNjRiRnNM?=
 =?utf-8?B?SmxaczN0UHNRaVlsTnlHcDV1N1JjK3hqVEJuWk9sYWxEMUw4a2pxaWg5NmpN?=
 =?utf-8?B?ZTdnejMyc0ZWdHpNall2TEpYTys1ZWNzSW5XT0ZzVVpVUTcwcW8zTlJMTkVk?=
 =?utf-8?B?VUdqWDJvT0RVa2ltRjVEY1dYMkNBeFo0OGFBTUZYbFJHQjFZOWc5OWZUNkxL?=
 =?utf-8?B?Q2Q1UmcxVUZJUmZLRFQwZ1I2R0FyWnlweEdVc3V2Qk40ZVBnL3EzT1RiN1lC?=
 =?utf-8?B?Y1hRanZEYlhHM2dXSVBCN3grbEZVbkVVaVlLL3RNK29pMWZqSGtLU1dIaGZX?=
 =?utf-8?B?UVNkZWFaaGVXclhIWEw0eno0YlBISnIyc3ptZjVRT3J6UnlPenZvbXZhbWFm?=
 =?utf-8?B?K29kdlhqRERjRFJQM1VYZ1hhdzdFQnoyZ1E0UDk0WkhJMUV6NDZsVTNaN2hY?=
 =?utf-8?B?ZjFJR3NPUVFXTkR5UUFxVTVDUFJZRHhUbHhpclpBZjFTSVFhbnZsWFVhQkM2?=
 =?utf-8?B?QkpXRTVpRU5NU2wxTzZRTG1wak1EQWg0dUwxSmt0KzVydkh4UzJQbWJzV3Fh?=
 =?utf-8?B?VjF5Z2x5QkxDRHlXVGJPV295dURVSGszam5FUElDWlRtR29FaGcybmZXVGx3?=
 =?utf-8?B?QWRUU1hVSzJPdXJVb0xCdGt2dWdzUXZ2bkdKRVlQUEVBVHlMN3Zka3JlNDBm?=
 =?utf-8?B?K3ZkVU9BL1ZWTUswYlpyUVdBSXVnZmtLMzBMdkpHMUowaXFZUjZ6cENxRHU4?=
 =?utf-8?B?M25tK3B6TkFkWXYvMVI4dHkzbllHazVPZ3N0N2M1RFIycGpVcTBCeUJzaHlW?=
 =?utf-8?B?STU2eEFvdElBdmVGL1A3VzhFOUM0NzdVZVlmNVJReGhqcmZzNGEzYy94Vndv?=
 =?utf-8?B?UjlvcHhwMEVhdmNmaElKaS9NYU5PM2JLbldva2p0VmF3OVBYQmdOSEE4NkRr?=
 =?utf-8?B?Vks2UHdXQTF0RGpxSlRaVS82b2pqWUpxTy9FamgxTTM4a2gxY1BXQmxaREMv?=
 =?utf-8?B?aTlNd09tZFlKNWZYckxRSStrUFozajNtVVlFbHhRWXNjZGhnbDVXU2M1NjMr?=
 =?utf-8?B?UFZwZUNrU1ZJRmUxS2pHNWtweXFkeXJOWVlRZ2JRVXhrZTlTWG40a0JURUNz?=
 =?utf-8?Q?zz7LBw8z4WzlMpeo=3D?=
X-Exchange-RoutingPolicyChecked:
	VrToyfSA8+Wbn3VddS8JEB0MLYEaNeiFj/IBpKJwMDqr+MJk1TBm2l7Qt2lnMFbYL8oPESLnXHM2lBOiv4s7VLt3hXaT6dOGhjLSi2rsXBAEBJPrr28mCmuqDqIneB77nmg/YFyDzj7sTvJmlDf24oha3Yi49TWEdZDEmiwWk9KUnP7AHd6Vgx3hwNgjyT6+Be6bmA7h+wJcTumwhG32RYeQ0V9czT5MLRDmGxgocA1x1Pmljy6Z8PB4TeeuHqOc1mULrjJUIh9M/veK+6NTySlvIgz0YnVgvM4376sfjf8KIUyyhuON4B9IIL6Z2y/GJAhpMGLLuZLqhF0Kh9lsBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b/kHXfAQh0KR09a7JxY6VLeV/A9kd+PrPT1Gd8a+tfgzNC0eiv0JMeEmLZSH3VvHWeuHLXSWHF72waSSklkv4EBz7R5apmI5kiWhPS7yhwJPSZ3+kbbbzEDwbD3cgGp+2j04MGAm6TzBy8VqfLYnQ/qWYRc0GUcvxgbiSunHbiCVB03OAapyMIEsqX/dBEK2DJIvpOyVx2Vxt6hedB/oI3g1FtAvbJzrykrsrkhAh6oIb7Y1BgwazTSMtW9MWauCh+wNGme4xNdtw5PCcsjBSiUzNZj1/salRj/2rJDdM690G/Q3Nya2LK7q/MAI3JejSPQNxeUSFNXtZIyxucSZj7wNT6sk7/Y5L8Sxxj2geluE/McUczcrdez62u4bOR4pioTboTrrXhOM9sMSOkaBWSafXMPEvjh3rL+ZrNjealImfoeR1/6VtFfI2ciiOpjjZpIpunKIuFqjYcRzg0y+9VRKYMkdgubES6sGwMc+U3JDngQuzhrgN0Deu8oDbpAatRXBU5e0PXoDiNUCYp1netgx6/iwQU0pIHCTKyc8peSJegx5tttmiRCOOV23tZJxXwWKloI0QCAAaDWrmhnHuz2YbiAFI2Cu5wy6hDXvdOk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 018042b8-dc00-4151-7a98-08dee24ab7ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 08:26:07.1523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yqq2IWKAQgXSe/vJfwdOYbCYL9dXfp+2KQ7SLMIcLgk6+xBYLxRkHgfK1PNML6rPavwekA06x/SbDDAdOIhzVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF7BD9BEA92
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=894
 suspectscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607150080
X-Proofpoint-GUID: DpnM649HBDqswYHNRVOI08jeyKWy_ftL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDA4MCBTYWx0ZWRfX+hGbdfT0km60
 AyAY/sUNCkoISlLA1V7IaTXeijWJmYkD8JOaDQJoej21H8lMKgZl8NZSteftbwnnOT8lN8FUATn
 l4MisoAA/ujKx99ybkzP7JWCiCkn67/hePH5+ye5SXNLv9v3tPdT
X-Authority-Analysis: v=2.4 cv=JKALdcKb c=1 sm=1 tr=0 ts=6a574423 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=eIhJVJLQ8ndnVjNuScMA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12219
X-Proofpoint-ORIG-GUID: DpnM649HBDqswYHNRVOI08jeyKWy_ftL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDA4MCBTYWx0ZWRfX6UPrfq5koqOJ
 C/2mUGS3XMQkWHHb0PFAwxSV3cJyRBF+XbSnFWZioq/bzHzKbbV6tNtIWz6C0xZjH0aIl/lm3Lm
 yOqUtXFXaBCPNVb0RV1ZOkJiFEvUelhfdtVMK+p6+vGSJhC9IVH1bOohoiK4Cl/aEyBO8BHINvQ
 0tdljYCk65yAHpjOAkGm8NF0IrbEF7Dww6dRoVzNrZxF7pZcTx1LZN2WsZHWG5BQB8CvkLwv+BL
 3WKj/Ynx1fxaQALuRGeh6P2/3lMrYzJ6wyE30urtjqyygyF19fncGMRpKZJiYmbNgdFjb5xNfU2
 8EceXuQpe6E3OogOgTAqv6t4CH28vUfOdVui282y1567R6RwSRcDutD5aA6E2r9jSMPY+/YJEjM
 t07G5+0z4kkFLJyTTx89w8v8oh6AzQYymTrKBDMFn2KyohlepFS2PEsohiOYqpefPvPqyfe1mJt
 rcCEsgpGLcj7QY5nN7wyQTEz/zpJCBrVgE/rALfk=

On 14/07/2026 13:06, yangxingui wrote:
> There are five libsas consumers (callers of sas_register_ha): hisi_sas,
> isci, pm8001, aic94xx, and mvsas. Only hisi_sas needs a driver-side
> change, because it is the only driver that satisfies all three
> conditions below simultaneously.

I am saying that other drivers use sas_resume_ha() and you are changing 
the behavior of that function - how can you guarantee that you are not 
causing regression for that those other drivers?


