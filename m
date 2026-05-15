Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7169B3876C6;
	Fri, 15 May 2026 01:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778809382; cv=fail; b=oSr33oGCKSWg7zeYiRla1HW/y5rvZ3LoeU3Jd8ICFRgjiMg2wE+SFrDjoZzKHdVmSnVeD1xw8lXaf9WLPGNvCBjgVkZwPzaq5xbpPRzcdOsvW4Hen3C3oGdci7l5M4VFYeh3wawf70ldKQ4KeMGlo4JD2/UBkEfgcgPjmuv7Kfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778809382; c=relaxed/simple;
	bh=Cf5Pzd5qtYobieUMOhll6onnWrw6LlWVCGyFRs2cNUg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=A0BddvkGsqt7V1ceeRNlSw8x4MZqwqPUldq+lXLmdr0h36BI/4GrxcFTjxqYudM00c0BBYAGchvL/oXbn9vsGvG+uFH03DkV0Aw6iwuUnWU/sf3xxomnCc2pcCl5ahFHudQFGaU/DeKVW5yEJvoUrfSD0jJHsyS//6o8+vlWvuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cHgi2VTw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tVa6EYA+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cHgi2VTw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tVa6EYA+"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0T35V3097009;
	Fri, 15 May 2026 01:42:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1GrgbKG/NtQ53eGFbY
	HykVDl+er5uBgIu9442w+jRL8=; b=cHgi2VTwPT2wSrPC5154Gk2nC+a0DDDeaL
	73TyHDNkO7o8fWAoRLN1XquxUPqk1sAo5ZJJFk6bORy6HdcaTQqeQkqneqLTnHIH
	+3sd1X4npaZC7oGeWPVPpyU/9XgpC5qK3LTfpHphgBjpdznyiorwpYQhCKWMwSFW
	DzcCaV777NFMGKfLSImjp2XWRJ2nhh6ioY3y4ZH8F/usytbruR0sONVZ7MHBZ7rQ
	s7QzzRr1PECPCUTuzV7UVR7G4QrQBBFsQhtonm02Blvuxv5QhQG0iB45mvMIag7a
	NdXl1+ZGFN/avx9oNxCg3U45MU/ob1F20UPmrTAdEzOeRW+lTD9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m20gd6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 01:42:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F1dkk1030538;
	Fri, 15 May 2026 01:42:44 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012040.outbound.protection.outlook.com [40.107.200.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kw04bms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 01:42:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bLZjFW3OpKm5xIzvv2lPo/k8MdZK8CAV4AMoax0Oj8WwVB79CxZTOy1TJK1S5+HMYHW6DEYWhNjMfC0XJk3Eysb7lXWoHJu+bFvrApvSpUvrnPDgt45sc3yJGiOGRhAJUvKvyOqMygXSvI4Y1szEV7vb1S/D2vckSXH8rr9NF/ZcEQ1Fn18/PkXkpYww2LLzOlPE5YixM0IIcOvpHny89+jR/ZS8O9k5Vzc3cSxgRJsMHbmMKGERSAKmie5lwbbLix9EjIpCK8PdWyMTUW/d74jms2birctYPpfNZR4HIcxOUH669ZsZUOEyqYbDUrPkjZ/PpS1izuU812m0NKse5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GrgbKG/NtQ53eGFbYHykVDl+er5uBgIu9442w+jRL8=;
 b=FUiC+Ti6V80XKAFcJRI3u2CrgOu3jPNG4Anr3hdimRgB+kIb+Lsm+dJX4XNW1a2gnz9/Hg8ACupdmJg/zVhgMF2c3UmlP6Lb1WQHqzXtN1dLQUKnkJ5lspWWAjqpUF6F9IM3MgkuIFvWYDmeuUEO6MDakdbTYgP3gjTFMORUterFv7MU6qd8AQgNmnZTcCzrhcZ6+Z6qfV45rvZKOnjXPesqgPgaHidRHQUtfjB7QAV2tw6CiyoQMeig4IZtc/SyCtsYJ0CTrpZacGJbI2J2wQP9QA5WqIXj5rev1IGpzMqNwAQ1wVfPNT3h8kjTzfOc6PyjJSoD1Vtlbq5yyWsuKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GrgbKG/NtQ53eGFbYHykVDl+er5uBgIu9442w+jRL8=;
 b=tVa6EYA+sjfbN/7MODE+sC8tIdWV+bQF9QhV7jJm9pH08+iUEQSZdzEgMZ49ndwLHWDxVCf6BotcohIShssd850vqf4uC5QiFF9Ww3IA5eydDLEXv/ifB1eS/RKbbuKEoZ5VcIQLiQIkp1zcTJvb/BlVvPdnSUJvwyOWVmS8ua8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4924.namprd10.prod.outlook.com (2603:10b6:610:ca::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 01:42:42 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 01:42:42 +0000
To: Md Shofiqul Islam <shofiqtest@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH v2] scsi: scsi_scan: Fix typo in comment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260506094504.2235-1-shofiqtest@gmail.com> (Md Shofiqul Islam's
	message of "Wed, 6 May 2026 12:45:04 +0300")
Organization: Oracle Corporation
Message-ID: <yq133zta1o9.fsf@ca-mkp.ca.oracle.com>
References: <20260506094504.2235-1-shofiqtest@gmail.com>
Date: Thu, 14 May 2026 21:42:40 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0064.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::41) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4924:EE_
X-MS-Office365-Filtering-Correlation-Id: 19fbc993-2285-4fbf-4b8f-08deb2234119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	MO9HH9khCv9jZZBJvnCmM0gFT2QXqbFE+j/T8bwH+AZA658Vnwl6cotoi00mREXFESAGQkRNX6lKHCkAjvzEXyKxp8/G/8CHt5K5Ehb14y0vNPPkq6L4WJZSNzHipyaBAPp8dV6oh/vYqnRtfUwavzVt7IPvwHBi464NAVmjLGjXmje86HmQgQvclAsow3yzSAZuekCZnC8WeE/jPc8pu7eMLvHw5jmu+5zlaM2REIOUlNkKmuz7vbRGSAubzegmj3lJajW5g5Mdjj9Tz/Mg6372VGIWNBhxvf0JNCONIe4W687py3MqfdyaolMaZ0AzDGhphNjJAEIyIlruyWn1R5n7FV9SMxSC2ourVA2hW2GulcdKEdXN8/7XbgjMThufYVMizTwk+MdKB79MY6IjCw1ezdoz+XyL2trh3Oj9DrQyp+Pe2OYgRR08ZorJvET95Pc0XEr11CpgRYIv+rj+p/7QIohVjcKK4wNlMXiTlZ6Z7qd+rtDzFcWMK4l+43Ur9/ytWLRXoRSmXSXkhAjAOQla0EagTibJCvCIdZ73iy9WT1z0rH6StviXMb96n3/hL4V3TSnozhka5UO2NcxIG7Ftyv/B2O3VVbhXaYHJOYgyAEeVFFonsgBCHfvdUyy2XAXZruyQqP+/xcYPClXLo+yeSCB3MzMxSmVC+aNq35LXXXI8DNdmXCp88Ai+5/fv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5g31T6PPA8RLZmITmRp7gUZX6JWqY87DbOw6SdI26VlnqhJtoxxrttrOPPAW?=
 =?us-ascii?Q?chkLMLSHRJwf/z1UhVJ/Hzwo6zh68XJUC8mWtUMsj9GLR7TspkMupXZAFHMg?=
 =?us-ascii?Q?7rK9/zV2OLtbL7ZnH/9JgEJ0ctqt9+ZyAtTG12ccUtknneCN0pIFQZ/UHTgz?=
 =?us-ascii?Q?1K1oBBCtZbABusR6FPXx8nnkczGEBr7GkFyW8tN0qkOgd4XwjCWx+5g6KYWi?=
 =?us-ascii?Q?Q6KdgoYf4NFv8QAQCgo+xxnt7dJ8hjKdVq38VWmYGhlpPVxM5sBZ4d70pIUV?=
 =?us-ascii?Q?x4BgoyKgEailbiQYVMBRsq2ZDPwWKL8E4jY35It+uSOCEPp9J2R4oYus/nnj?=
 =?us-ascii?Q?ZvMCViMkH2Q6yzp/IgHbs3K9U7HHkBrRqQKW/jft8XrLapBQmiV43h9hBJtC?=
 =?us-ascii?Q?RIJDQXecshbk82c4tiM66ibhDR8r4YsjBpDEtHduWPiSOTSlX6VuAhQr5cTS?=
 =?us-ascii?Q?zBRI+SIRLu+fHUHjl8wHdsX4uNm8eDZW8zfYLYdJG5FSsIjmeRcSRSDT+y/C?=
 =?us-ascii?Q?Uv4JbDiX8nAU324OjmQB4hZkODpG7YvLbX+m9UQWCzsbRNGHFr7BK3H0fiQc?=
 =?us-ascii?Q?DrIy3zqzEHA3vqApaqh1i7bTlJJAgbN/jivEcVkgC+APeVXu4+FdtJ6mYEB9?=
 =?us-ascii?Q?rWdWDHcQZCQmsHcKkhgMY3XBX7wBkVnyrW+5SVR6w1UJn0rSrEdoVZopzY09?=
 =?us-ascii?Q?WKTRrox7RkJjRlf21YxbBlASMrXBY7lqpgoiTE2gQmq+tV2V3VQod0QDCF+2?=
 =?us-ascii?Q?7Vg7UjQPLvRnI/c4k1vJg03ngzSic/Ug32eAZEyRVEbgqPf7BekZtg0YftmV?=
 =?us-ascii?Q?9Lq2e9SyPfumb7jsbflS9RaYyKu3vhvofU5NLdQOl69cYuaH6Ok9pxK+n1O1?=
 =?us-ascii?Q?vB+RRm+q0LAg2CkiJENQ7AaHn4XjgxiYkG1YT6TMIEnQgykXTG/V+OmUPUgu?=
 =?us-ascii?Q?I/601ogeWEl0BIEZ/3/E51W/Hg5I8y6oF1+d4mYPEQCW6o6o77HPvpKAKFzV?=
 =?us-ascii?Q?po5q5dxDHIHXvwnBEw8zY8+C+DzjFz66sLnoYF9RqNwX98spT5tEyXJrj4gd?=
 =?us-ascii?Q?oaqsPyT/eas4GHXXbW7Wmfv2lMkORzG2za3nU8A7iVfsofIzfP87mIKS0F0b?=
 =?us-ascii?Q?Il6PK1I/ZBEOwcC6dPADX/Qt76H3JrCfzr/dl8uQBGlM3Kk8MNTk0dGUQHoZ?=
 =?us-ascii?Q?O7OvAhjUl9ShoZKX3lNnv2fZ0QOMFbBGfNl92JDA5Z3NSXxOXfjw6VnZNQ9s?=
 =?us-ascii?Q?IVqUvgR80uMFLO1Rl/KQMbFX9fiRx4NmVcV94BoJNMtNhmyb+v7IDb2Yp2Ew?=
 =?us-ascii?Q?aD+n3t6nL8x7plm6gVj5btLY8miqefIruFkcfgCFh/lRc7AmEBw+dyF23OwA?=
 =?us-ascii?Q?cY9eGE4gm99n+z67DEUxhCZYPCtLP5YoiZd1q2AeFgTpmh1cOc5wUQEvX3d3?=
 =?us-ascii?Q?zCTWS3bScSw5ncyk8W8caSlJFlp5g6+t3MxmDGyGjY411SYG8HMP0Il9s95d?=
 =?us-ascii?Q?KVbCRk+mjXnWQMVYSaMKPROT8N9/hoc9VDjx4MEmWVFGorkZQDvKV4tqB+C6?=
 =?us-ascii?Q?QsDG5d9kEPhsgcxB1dyE5nkFxIdDiWiE8487tRfEPIRtPfhheEs14QE8aIzC?=
 =?us-ascii?Q?+ntNtFxyq9YuU+MBLnRCtd5OA9HvYSswKmhd4bJ21dWPtj/kdq66f3hUqVw8?=
 =?us-ascii?Q?Xkdlw8NeurrqF7kT5mSidpSVcEdGHkzsWp1ywLlB5t3Mz5ietnvd7f+hJwAe?=
 =?us-ascii?Q?z++eVW/bBZppXW8K/kx/gqoUepBRsWE=3D?=
X-Exchange-RoutingPolicyChecked:
	TE5WP003KVSyR0GN3AXJ8bIhj1etgR7IIGZTjgFtCcOE8DcTYvN1db6VTj1pZovqHu9kooVKGxbdTq98oFMh7qQO0tNKmNKRfSbEAfHKakiyy8koNxrjrUu0N58fTOB2+31M2vWvJo1LSlAgXC4AN5YkfV16VATQO6LJ5yolqooozbDPMLpHCDSIvOFGXcyJBT6RmyZhMopFOKE0XTX27ABeqw7hJMTT1RP4vzxaty4rStKZQ1Yfq2yHy57lbs+nsk90U1gs16/Fdxlx9O0sAkpfpkR15sSITayBy3LwiRLg1n19ra9va/5PoTkmuJh7dixqHXc6pSpunkd5SyUSag==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rI4SMGMiHMVoN4gdhbxVKW81G793GsZ58L26PbG+WcJF6sr35j9I+Cz7VTSGaG+3J1d0ztnG1AfhYRtazEC+IR/bYtfOAe4Cvts1ISmOD0J8mRkbgH8gUzexwdZxZbjI0xi9kFAgZ27UUUDoJgbK/yASwUh5lFJt6KT0s/bJGkldgZ6DcQMsGftakyQI+DBAEUp5tfcOqIeqHpwX65IWvaBXPqIiazAMXlWyFi9XpvWKVfVzn2BdGfmic1Ez2vT8NXqQ/b7Fqn87qaJ1+qEt6w3c2s0sOIviXrMtsYjIT0bxnM9eVozlB8739Vv+CESLRXiHjZpY/DNMcgVc7Keop1iu4Md20id0HjVIslfzZxvmWqvdaHI5kFPZIRvsYBtVXiigUA/Jurl4RlJaDnLsxb33m+cWrc16K5jSxcbDeZIfixJAvwYX6uc/hMHQ3jHgKZErYPbEoGAAHSeOAqJLSENQ1eYTFbN1l/YUCQa4psz03h7b/qKF/5AZ/LLELwLEOR8g+gbqH3+Fh0dRhFiE7z1d420ZUSaeL2FWZJojBMNPPit2KwfVIUYPvekm1EYHBk6qbLaVTo1B+q4OcQk4MgFalcLHJlSx28Qiq0Wi1Ig=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19fbc993-2285-4fbf-4b8f-08deb2234119
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 01:42:41.9934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMLLSSpdm8RyeP7I7azKlQ6xwNmNCxbL9tOGrS8KAkVzdaf76ml/1ti2beBOkVJg+zZIHDTiXpuJsGDtdNHcdlHXwhfAOiI5sE4sftWoXbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4924
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=905 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605150014
X-Authority-Analysis: v=2.4 cv=DeMnbPtW c=1 sm=1 tr=0 ts=6a067a15 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=rSRwQDIwOhqc54zw1qAA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12299
X-Proofpoint-ORIG-GUID: kiSap47ZZwoENcUEX0kGsZmdvAUOaIV3
X-Proofpoint-GUID: kiSap47ZZwoENcUEX0kGsZmdvAUOaIV3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxNCBTYWx0ZWRfX3S7FNeVU2Txe
 z6vsVixyzpF6NWEm/jsWCgIW3kAOzTbQHSaQBvVDnG+LldZbT1YUV5nuCZZU+5UN3cRZX2CnEJ8
 5b6zOpA/jNmp3PbUs0NEELcZJe68DQ10qLtt19QGy1U/bqHCl6jvCedGCTlV04d8vvnN5nNcll7
 lVAb+hVZpOvGB1FAEIyEG0Hkt+NqPjhVRsNN29HPmm1VYfhcESGhcfOGNoo7MyUvlXtmLdMrfgI
 rs4eGgVeK+WplK/du3649Ad2ijm8YSwTz2P2EdRUqH2tXYi94+dHobm/xdRAh1gfIn8+TVP51wl
 d1pxQZYFslvihaqS5uBL4DRg4Ob4H4AQy3nfoGY5TpANRXvLnbZlArCaSmzPEa15HF9VYEXrprN
 PXx5w0JDPaMXKeLCIp/qbATOmMOW8HPjpyCbKZl1hX6k3ab8IJh7Rs7IopjBqOiAD/Su876mgU7
 zmKGsQCvk6vwbrY92BDx2LhhFNChpUAAc8B6MglM=


> Fix spelling mistake in comment:
>  - initialze -> initialize

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
