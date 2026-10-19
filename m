Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792432160;
	b=Uhj8Z48imxRhY1Pswn6yC72+3mqSc0RPLpLOL9x9kit78ecf3olpACPU+7g6LkDKYnsU
	 8ykCqbtDhjcVUjDXhMnt6KIZmTYrhxQ5h9Q4KZr21E0KI2IYYrJBRYKL64gWRQ21WZHbD
	 tQ5HB2K7Chekcq0r2mGS0eObB+AmkQ1e7G+sWuQPUlHhYrpPBzVzNGpnwxpg+dPfH+2+4
	 sLDqPDpBuZ/FqV3ZgqBKfin6M5CRJSfjvC3HYcczUj9+eJCYyPgiTsmI6apV7lo5zEnNQ
	 9bo9JPcB0TTWkVMBty3Zkl86d1UtXFKzx7LcNjQgZlI2LKXTB+qWMetYzA7k46C20yg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792432160;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc;
	bh=aD+qOB7qauFmu6+pnCarJkIWJ2LPesDT6pfAmq4K/FE=;
	b=R7eXxR7w/UZfg/Et1y/NF8VaPrkb5YRpKegoc/IMNDt+qKCDWFgugFHTvGv1qQ3j6Rh1
	 +2mMmAlUNWgs4Gd4NuM9bHM8Q+PYfmNcoJ/boLZrAmjjGuGTQuiq0jeFwuaIaEbL0PCVR
	 fqesIqI9wj1mCVaq2RLCviY6DqTBi4YoIxKSWHNyH0Y+CGH/QfjppGp37QdVDeNzmVoF4
	 fb3D2SSE0QGUvjY3xdJlyXck2pTwwN5qDQ7W+K0geNtyhMW0YoRlpsctu4VJIs1pFPfBJ
	 4BBdt6I3GjC90/dMjD3k1vAsEyRIL9AgC/z3WAR/BFiDs7rsoUxdHkJwiM17yCH2ZrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=H2K9G6dr;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=hz4DnfFY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818EB606A31C
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 17:49:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 818EB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=H2K9G6dr;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=hz4DnfFY
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69JEY86R2610687;
	Mon, 19 Oct 2026 17:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aD+qOB7qauFmu6+pnCarJkIWJ2LPesDT6pfAmq4K/FE=; b=
	H2K9G6drYihduvIcLwg2JAq+0tVUEaeBGmr2GVarAhryXkIbPju+zzJQeh1rMxcJ
	xWHMAx+LJMwGfsowrt9YDxs+ZaihdCGt/wWp886NnZzJ1w0AQFIhqugjFGQ2RnIh
	BTSjJzGrkJDjE8k1vBuvko/9h4WJ4v28A/vv8dZ8fcvxoOrr34nWiDjQ3lnIjtTF
	fwntjYVy/rQWCyCOP3tZZAQKD3DTGuPQ9QELX8G/DT/MyKGTtwxEbfnJGeKF2XpN
	rksQo+T5n0mxmDFm/EgFflgl07/+wkmxlpDU5IUvRnuCm3wcLsb+j0FVeTxg7Ecx
	2sfWtWIIhtP3aEzA8KF+sQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hc0w72bev-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Mon, 19 Oct 2026 17:49:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 69JHf1x81035530;
	Mon, 19 Oct 2026 17:49:16 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4hdqtprbcf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 17:49:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JFSvnszjEOhGjI1ZJ5XiRTbj4Olri4L+dVkFJQloiMzX5Qn1hzBqaPRD4kBg4i96grJORQ5HQtf2KjvyIjUJnbm8I40rjqFyX3tX01bbMzKY8qkuLTAcNSoz4sp1RFtAGab3DwttEOIj8VnQYQP7S0ZX4A/+KChkDUFGIKHwZ8yOF62JqGwYULY5L0fYruNKNkDZU/Im2evKpq9kAPwt2Hdal+xfZcFY8mLRNNs6B0kbjdWCZ+tK9v1/nEaxExi2tD1KMwpmWzfLbGDjeJZpCVBNwDr3OLsoIo9FPf/guQRlVpvHEVvQvoilsWGduiPwJe8K/CB4g3c/YSKLPunjSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aD+qOB7qauFmu6+pnCarJkIWJ2LPesDT6pfAmq4K/FE=;
 b=h4pjk45FElimExXZFBVftvRbKhcPvSZJPfYkzC4W79gHofWazNX0zy0EQJQqbexqq1N6QS1HJDlqlPXIyldmv8zVs60OWJIAFE0WjxHeBqMoxjbHrlpvsQFTTZvU/0cjFEZhc7v+aveeKwzsqHmjfcCp0qsveNEFsB6g8tOXwrWhy/WxRh+N/g2H/llSdmovXqVRW7SQFfZQkXE3TmxVe320j7D/e9LMXWtMKMk7o+WygHh5UawGZ7zBRvU22NnfB3O7kvqrb2txWtvAP0f2Xf3+xPrdDYQ5GvUcKhN+vZ0Nv14hBhw1MkT7qQdLLsTFdWiIo8X43vFZsSilTybFBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aD+qOB7qauFmu6+pnCarJkIWJ2LPesDT6pfAmq4K/FE=;
 b=hz4DnfFYVaUHKCE2ZggtmC6xQ0W1NB5mJ8oMQxUzdSQC3x0L0JxR7DrYPVgwuiRHcj5NiVZgzueUofcPuW+lG+UgxO/48APpjJNXtpCq5fm2bQjXAB5RAPGH4WVoQxZMMlNPbzfqxFxdX09SxZRuWRBz5tvcb2WThadSW9TFy6s=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from MW6PR10MB7639.namprd10.prod.outlook.com (2603:10b6:303:244::14)
 by SN7PR10MB6364.namprd10.prod.outlook.com (2603:10b6:806:26c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Mon, 19 Oct
 2026 17:49:13 +0000
Received: from MW6PR10MB7639.namprd10.prod.outlook.com
 ([fe80::8386:1d11:46b2:b163]) by MW6PR10MB7639.namprd10.prod.outlook.com
 ([fe80::8386:1d11:46b2:b163%5]) with mapi id 15.21.0546.012; Mon, 19 Oct 2026
 17:49:13 +0000
Message-ID: <424c51a4-1db6-4d12-8a01-525e6319b536@oracle.com>
Date: Mon, 19 Oct 2026 10:49:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: lpfc: fix node use-after-free in rport
 callbacks
To: justin.tee@broadcom.com, paul.ely@broadcom.com
Cc: linux-scsi@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>
References: <20261003204122.1393233-1-dai.ngo@oracle.com>
Content-Language: en-US
From: Dai Ngo <dai.ngo@oracle.com>
In-Reply-To: <20261003204122.1393233-1-dai.ngo@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0PR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:510:e::33) To MW6PR10MB7639.namprd10.prod.outlook.com
 (2603:10b6:303:244::14)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7639:EE_|SN7PR10MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: 4316d8b8-b73e-4cb3-d19c-08df2e094939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|56012099006|5023799004|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	M3b3iLRYCYLPYKqKNyA9jpvd6og5CVhT4SCe0kFYY8C0TeR1/CuRV/Cz2w9EJ1zJAq0SuhPc631S1/GxcXepjKdNxmEBq+f3WtHQLKWk/FXvY9IyrCD0SkJVkWQa64ZGqubtzi/1h5EGpyXz/qF6NaBfVIoA50KqIOalC4aeIubcddsjm50TzmCVhFbMlpOlgmQv+A6YAzV3V56YPavKGaz4MnQsB6K4d5DK9HaIcPB6fHc57IOwWdGCRP1jpfgFWMX5+CvN/yQn2nQNYmIfMD0RMAeg5oG+G+S/UboO1gJlvZ1H4t5smmsnWSCSe4BC6y/GFysv1wArjSVNUmSXvv1M6cD5OZst8l8ZXG+qVq5RJcukFImd+yjwxOOFNLHNbgC03FDQX8pqfdwUBNd7wiJ6HcUMgkI0bWlMHrGEpmqAPddF1iidv3++KYnkO4O4jtw2dKcgjeSohkHmf0736umhyQtAeAcieEufCebgL6oHv/snd4NoGN1gDde1PiB2ivDtJUAwrHsa/M5BHpoLRBiniFLW1foLur0i4sKsTg3PzrQqHr50MYupmnVJr+diayQP2CwNRVq+CnNlbfw68XV6WriChsZGYm+ubXbgtGN6pl52kfBryoRDHXo73C0NxBhgarLse//YU+TCpdKL8q1SjtCovjyxHRkuah4eESs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7639.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(56012099006)(5023799004)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eE0xR3RlN2R0OVM1TVhKN1hVZFdWR21tV1FpWCtZUVlMdTBCU3QxVkorakRN?=
 =?utf-8?B?YXhMZXN1Qk4yelE0K0Q5OG1MNDdubmw2VFpkL1N0bWF3ZmNOUEtqb2wvYnRZ?=
 =?utf-8?B?WUJVR1NuZUFNU1FqL012a3hzYlBOQ3RpUkF0dGRoeEk1L0g5bEo0L3V2T0Vx?=
 =?utf-8?B?Z1AybCswemY5Y0ROcXFxU0g1enpMb1Ryak95OWZXSHZvRlNNL3dLRWt4dTg3?=
 =?utf-8?B?c0RncEJZNERZVVppQjE3djhCZ21qQ0s5L0VWYzg5RDh1eWptNS9OQmk2MGxL?=
 =?utf-8?B?dXdVL3J4dWNVWnV0UmduaWVlYWNiS05Ea1JLODYwdG1hU2MxZ291SzR1TTRs?=
 =?utf-8?B?NWFUSjVCZDBudmp0SnlLTml5SUtDYTB0cHhKZ1NwK3IyMWRDOUFFWVdCa1py?=
 =?utf-8?B?cXNPaWdyU2xBZWxMT0hBWHVCS3JkK25ZNGZ3YkEvbDhJMmQrNlJlUWNIYWk1?=
 =?utf-8?B?YWlFSkJRc05YM1Y0Sk1XK1FCbWhSd0ZXY3FwV0J3Zkt4M1E1ejJJT2QrMEFa?=
 =?utf-8?B?eFlXUHExbk1MVFROOUpBOHNiZ0FjSUJHN2lmWTlmdUlCSkZGczJSNWZKTERm?=
 =?utf-8?B?dEExZ0JxZk5tOGpVSkdaVU1rMW4zc04ycCtyQ040ZStkTWJqUVN3amI2ZUFI?=
 =?utf-8?B?ZGE5azh2WVhUNXNWNWRlSEgwdi9IS0F1eGlsOHNIdWlXT2R1WFUwYzEzVEtw?=
 =?utf-8?B?RTk1RU5mKzRxQ3Vmc01kMFZnVXRIKy9ZQ1hvWE1XdXZCQU9lRTRTc0RxOWZl?=
 =?utf-8?B?VEN6dUk2OFAzaVEzOGV0ZEdNQitIWjV6eExSRFdNTnh0bWlINUdhVkZKb3B1?=
 =?utf-8?B?dnZReTh4K3ZreU9JNTFTRzJxRmZ4VEdKOVJoM2d0am1xemtzYnFseGhhKzQ0?=
 =?utf-8?B?M2xpU3JjWWpCck9pUXRqVjVSTGlETURBRjdGcGtlUmUvU2NwNzNWUmIvbHUx?=
 =?utf-8?B?SVUyNWtZbkhEaTdaTVpnejloZWt2U2o1b1pheUxBbjE4RS9pUWdzYkdET0lD?=
 =?utf-8?B?ZEY1VCtCSHlsc0M5M1Z0eEJZNHB0R2ZDaWJMOWptcU8rbytiNUJZcE1kTzhZ?=
 =?utf-8?B?RzNNZDI2MnBVV0VHSXJKMVBXV1FwenQ1VTFvUFNKYkJaOWVER3hOY1ROeEhw?=
 =?utf-8?B?eEgwRktmS1FJMElEQ2o0M0MyVCtwdDE2bXdDZVUrcUpXMXFNeXBZelBnc2xj?=
 =?utf-8?B?K2l6NWVFeW9rMjYrSUtNdGg3SEtiRWxnaEN4elo0ZkxlTnB1dmd5dnMwdUhp?=
 =?utf-8?B?eVdMaEg3T3JlbERMTjc0YkJ3VkVydEgzbkNtR3AvV2VMSkdwUklzVHlmOHdm?=
 =?utf-8?B?UXpCbUd6dnRPUmFCS2FMbjBNekJRRXR3M3cxMDgzdTI3WWpSd1diemNsYkxr?=
 =?utf-8?B?MVJPa052VThpS3ZEUXduSjc0N25rQ0VXb05SaWJYOU1BTkdLeGxkSDRMMU5Q?=
 =?utf-8?B?UkNUWElyTzhoc1ZOOUo4TjQ4WmVEenpEK3c5T0grMEJFYkkrVUFib3FPTFgz?=
 =?utf-8?B?RHlWMzlzcXBUbjg2SUU1UXgxdDBWUUxXVElsbVlPQnk1dkk5cmlwN0lBVHEr?=
 =?utf-8?B?Uzg2Q0YzVCthV3RuWnRwZi9pQjBuRzNqL2IvODJRTnV2QUhlU2hNcEk0Y0FI?=
 =?utf-8?B?SFRna0dDWXRtYnU3cXBtV3NudDc3UFgvU00yU21jZHZoLy8wODJpdjhZMFIy?=
 =?utf-8?B?VnluMU5MMU10UVBsbW1QOE9STnFwd2F3N1FoZnB2N0drL2RsR2xkb011eVpJ?=
 =?utf-8?B?VkdjR2o4bitBcWRzYUUxcUV1bkRSQzdwbGx1YVVWWklOKys4OSt5UzRISk12?=
 =?utf-8?B?cnBOa3NTZmdUcTIvaC9aWHoxZkdtMVMzdWNnUVg4Z0ZRMndRR1hGeVBYNmNi?=
 =?utf-8?B?NzgyS2dHd1JMQ2RWcjFwcFo5L1VtNEp5aVJBZnExYlBtTmtKdHdTTTFWZ1lV?=
 =?utf-8?B?SG56TUlGa21YNWhkMDkySXhKVUYyZCszL01zRFVPSU1JcTdhM3dzTkMvdHZi?=
 =?utf-8?B?RVcyUkJpVFlIQjBwUGs1LzlYQjdaVHpUaFBTYXRYeDZTeG52ZkpqYldxNDVh?=
 =?utf-8?B?ZEFwb1BYOVkxeUltOFM5bTk2NDFqYU1uazJ0R1NpMHc5ajV4RStTU2tZQXBi?=
 =?utf-8?B?SlhUeUJJUkY3NWEyVnJQcG1mOGMySmM0U1RueS85eENFT2JSdTBtZzl5NXZj?=
 =?utf-8?B?UzNKQlpxKzE1YmNSM1U1cFZVL2lVMmlOckg0MTlIUERramtWcGg4b285UEpN?=
 =?utf-8?B?WmgzL3c4dmxmWEcxeVRaYnliSGlGVkx5bWhVcG9UL1hxeXFoMGpxN0JNRHlB?=
 =?utf-8?B?K3hHaFk4VGUzYm5LWTgwbGV2VUFETDQ5VmNlaW5XV09GWWh4amVFUT09?=
X-Exchange-RoutingPolicyChecked:
	SMffubEfAPKzhaUJDWHql1pQOuJe9s/8JJ0ARfVKPkF9oCeOwaW5C7zCb7odMZ2EeTj9ZkUmeRpra9qmxpjUT3qTQwklDok5l9EcBXBtcWtp2p4l8iSEDJ8osrEOR3ZAVuC5IAJLCm3Nsv1GumkfB6Hj2jbBs8YMIWbz3R6loF9edyUzKnqamg6ddq4vMSo6JafK9lv6PLo74VC21d9QxxJVEG94+zEg737GsKAvepgtPAwCkVCqEGgwCMWgRUiEvfRKlc7WZ4yzyVg8bAuycz53fpKhdTu8y6V+YyykCEUfv57ZXT9sGWQx+t/CDd0P0gIra9iJRa+PBw1sZUkGQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	inTv5KFcjT2zq/QIlWLtfJdzkAnCyfHHwyaRUS3FHzS9RVmuyW3kruI3eQS4KBm13VfuJlJfr76nPC++9FEvFBlYtbE/KRFz/7yP2cU7t3AOQPPnfwsdc2iAgm/HtzbjscJeV1cYTGbPPR6rLbAaHk41d/GYUyZYDXCborO4Ttpq74Z87Zm1XN7hkvUrpDP6RMp5DIjvyKTzzfRcAtOgKHD/PBss681ICSARtSnhX3DThUJhTlWESBL+JKqtt3hmn3mAX9Q5/QN6le7i9EHCl3UDsNQbzSjYmrcN7BF9E2IC+68TJz5STtMOyGsBUtEIScg9LXmdjkR4P6HnwbUDLVNN9RdtSoAbd3rw+6Yrn9pftoGJWQaPs3Wth3vp9ge8aA4KLZ4XAFiWnriqBgu4zSHDMBl/6GlIEBPHL5C8v0jGMwTTumjekQSCsg8AqY3H108/aVAy5gosnrSlwAYGxIX7yegSgLfam+K3Bp14oVmq69NbefKRu+b6pCKT805QDxWE0HTWYsAuOYxiS3FO8RQ9JWy1nw+98hMJFl7Y54R0qO4q4tU0KnXkgN20FZcJyb1npjN9x6IhpE/m/GX8OL4lI29i0cbNDfiZMouLWVE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4316d8b8-b73e-4cb3-d19c-08df2e094939
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7639.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 17:49:13.0973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2sEfNV8LPHofUyJ5Z+qDL9cbxdjV9rTI9TQTBwlIFRSH96m1jZ1YA4wa+c3bfTLRlfK8mrdATeko9e/zYVZgOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6364
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_05,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190071
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA3MCBTYWx0ZWRfX9+BiFRQWU7Kw
 Uj7RioVejnqbUI8OgiVeJWY/MPxwL40ZNoRuDYUgzxfv/mO7RdHSE2ayDNvXet9+p6jAw5BGvvc
 Qu2kUCsNCKyV6FyEkB/o4c9iAYoewIGIWeBbdKRMgBBj1fRznihY
X-Proofpoint-GUID: _NmciX5JQMjOypbAG6EbcbyGFRKlpTXU
X-Proofpoint-ORIG-GUID: _NmciX5JQMjOypbAG6EbcbyGFRKlpTXU
X-Authority-Analysis: v=2.4 cv=JKWuIMKb c=1 sm=1 tr=0 ts=6ad6581d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=vSFIXNbbb8Q8dACEiTMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA3MCBTYWx0ZWRfX8fXG9i7w56XL
 fim/WvfCvwro7HbMcY67Ini0+fSdqB31AJ/2iXAFW0GNv3f2lC7z4fcdhv262ZtPDU4YGahyTW9
 AOeXGqzXuE1bls/SH2tmStnVM9qCSRZ/9Ng7o2TgXtzeX8EFkDu1snm7VewxJYcnzE/Xt++YcXH
 P5VERWjw68XvckYdnOEzr4KyfPZ8iPAbqdsP4U5QhxgDSqi0bgVwpl+EgG6h8ZGtKhvCqS1Mcsr
 omby0v0rkmkWZL2IO/BNP2ssNmGvQ4Q9W10BW0iOwipCK0aCkdjcR6/Pamm0X2YoMZeiVe/PaKq
 YSgcqDfo1GeH2PQiAOOf2bu0A7nvmwC8xQ7fRB+XX9L7xqKmvYT5Cayykpt0tPh7rQMApyquNlM
 SxVj259XPkrESBpCysS2Os1+Q3GzedQ/+obM0UVFsN3KPO8F08Ipepg8HJoSCF+vwKuc6+R1bpq
 zerXh65/eekpVCNG5rQ==

Hi Paul,

Just a gentle reminder about my patch below. When you have a chance, I’d 
appreciate your review or any feedback.

Thanks,

-Dai


On 10/3/26 1:41 PM, Dai Ngo wrote:
> After a cable pull, unregistration can release the SCSI node reference
> before the FC transport invokes its delayed rport callbacks. If the
> remaining references are also released, rport->dd_data->pnode points
> to freed memory.
>
> Use pnode only as a lookup key in the vport's fc_nodes list. Under
> fc_nodes_list_lock, obtain a nonzero node reference and hold it through
> the callback. Final node release removes the node under the same lock.
> Read pnode once per lookup so concurrent rport reuse cannot change the
> search key during traversal.
>
> Track the SCSI-owned node reference with SCSI_XPT_REF. Registration
> flags and ndlp->rport do not reliably indicate whether that reference
> is still held. Publish the association and reference state together
> under ndlp->lock, and serialize normal devloss detachment with
> registration for the same node. Unregistration and devloss clear
> SCSI_XPT_REF under that lock before releasing the reference outside it.
>
> During unregistration, save and pin the old rport so concurrent
> registration or devloss cannot redirect or suppress its deletion.
> Keep the SCSI node reference through all remaining node accesses,
> including NVMe unregistration, and release the rport device last.
>
> Devloss releases any remaining SCSI reference before losing its
> association with the node. Unload and HBA teardown also handle a
> cleared reverse pointer, while preserving the existing initial-node
> and NVMe reference accounting.
>
> Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
> ---
>   drivers/scsi/lpfc/lpfc_disc.h    |   4 +-
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 200 +++++++++++++++++--------------
>   2 files changed, 115 insertions(+), 89 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
> index a377e97cbe65..4fe900f9dc35 100644
> --- a/drivers/scsi/lpfc/lpfc_disc.h
> +++ b/drivers/scsi/lpfc/lpfc_disc.h
> @@ -87,7 +87,9 @@ enum lpfc_fc4_xpt_flags {
>   	SCSI_XPT_REGD		= 0x2,
>   	NVME_XPT_REGD		= 0x4,
>   	NVME_XPT_UNREG_WAIT	= 0x8,
> -	NLP_XPT_HAS_HH		= 0x10
> +	NLP_XPT_HAS_HH		= 0x10,
> +	/* SCSI node reference, protected by ndlp->lock. */
> +	SCSI_XPT_REF		= 0x20
>   };
>   
>   enum lpfc_nlp_save_flags { /* mask bits */
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index c9b02d2c6305..a80685761a19 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -83,64 +83,61 @@ lpfc_valid_xpt_node(struct lpfc_nodelist *ndlp)
>   		return 1;
>   	return 0;
>   }
> -/* The source of a terminate rport I/O is either a dev_loss_tmo
> - * event or a call to fc_remove_host.  While the rport should be
> - * valid during these downcalls, the transport can call twice
> - * in a single event.  This routine provides somoe protection
> - * as the NDLP isn't really free, just released to the pool.
> +
> +/*
> + * Unregistration can release the node before the transport's delayed
> + * callbacks run.  Treat dd_data->pnode only as a lookup key, not as a
> + * dereferenceable pointer.  Final node release removes the node from
> + * fc_nodes under fc_nodes_list_lock before freeing it.  Holding that lock
> + * lets us safely acquire a reference, unless final release has started.
> + * Association checks belong to the caller: failed registration can clear
> + * ndlp->rport while an old rport still needs devloss cleanup.
>    */
> -static int
> -lpfc_rport_invalid(struct fc_rport *rport)
> +static struct lpfc_nodelist *
> +lpfc_rport_get_node(struct fc_rport *rport)
>   {
> -	struct lpfc_rport_data *rdata;
> -	struct lpfc_nodelist *ndlp;
> -
> -	if (!rport) {
> -		pr_err("**** %s: NULL rport, exit.\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	if (rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) {
> -		pr_info("**** %s: devloss_callbk_done rport x%px SID x%x\n",
> -			__func__, rport, rport->scsi_target_id);
> -		return -EINVAL;
> -	}
> -
> -	rdata = rport->dd_data;
> -	if (!rdata) {
> -		pr_err("**** %s: NULL dd_data on rport x%px SID x%x\n",
> -		       __func__, rport, rport->scsi_target_id);
> -		return -EINVAL;
> -	}
> +	struct Scsi_Host *shost = rport_to_shost(rport);
> +	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
> +	struct lpfc_rport_data *rdata = rport->dd_data;
> +	struct lpfc_nodelist *ndlp, *pnode, *found = NULL;
> +	unsigned long iflags;
>   
> -	ndlp = rdata->pnode;
> -	if (!rdata->pnode) {
> -		pr_info("**** %s: NULL ndlp on rport x%px SID x%x\n",
> -			__func__, rport, rport->scsi_target_id);
> -		return -EINVAL;
> -	}
> +	if (!rdata)
> +		return NULL;
>   
> -	if (!ndlp->vport) {
> -		pr_err("**** %s: Null vport on ndlp x%px, DID x%x rport x%px "
> -		       "SID x%x\n", __func__, ndlp, ndlp->nlp_DID, rport,
> -		       rport->scsi_target_id);
> -		return -EINVAL;
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
> +	/*
> +	 * Registration can reuse this rport for another node without taking
> +	 * the list lock. Keep one lookup key throughout the list traversal.
> +	 */
> +	pnode = READ_ONCE(rdata->pnode);
> +	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
> +		if (ndlp == pnode) {
> +			if (kref_get_unless_zero(&ndlp->kref))
> +				found = ndlp;
> +			break;
> +		}
>   	}
> -	return 0;
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
> +	return found;
>   }
>   
>   void
>   lpfc_terminate_rport_io(struct fc_rport *rport)
>   {
> -	struct lpfc_rport_data *rdata;
>   	struct lpfc_nodelist *ndlp;
>   	struct lpfc_vport *vport;
>   
> -	if (lpfc_rport_invalid(rport))
> +	if (!rport || (READ_ONCE(rport->flags) & FC_RPORT_DEVLOSS_CALLBK_DONE))
>   		return;
>   
> -	rdata = rport->dd_data;
> -	ndlp = rdata->pnode;
> +	ndlp = lpfc_rport_get_node(rport);
> +	if (!ndlp)
> +		return;
> +
> +	if (READ_ONCE(ndlp->rport) != rport)
> +		goto out;
> +
>   	vport = ndlp->vport;
>   	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
>   			      "rport terminate: sid:x%x did:x%x flg:x%lx",
> @@ -148,6 +145,8 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
>   
>   	if (ndlp->nlp_sid != NLP_NO_SID)
>   		lpfc_sli_abort_iocb(vport, ndlp->nlp_sid, 0, LPFC_CTX_TGT);
> +out:
> +	lpfc_nlp_put(ndlp);
>   }
>   
>   /*
> @@ -162,8 +161,9 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   	struct lpfc_work_evt *evtp;
>   	unsigned long iflags;
>   	bool drop_initial_node_ref = false;
> +	bool drop_scsi_node_ref = false;
>   
> -	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
> +	ndlp = lpfc_rport_get_node(rport);
>   	if (!ndlp)
>   		return;
>   
> @@ -186,8 +186,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   	    (phba->sli_rev == LPFC_SLI_REV4 &&
>   	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
>   
> +		/*
> +		 * Teardown cleans up the node, not just this rport association.
> +		 * An old rport may be the last callback that can find the node
> +		 * after rport reuse. Do not require ndlp->rport == rport here.
> +		 */
>   		spin_lock_irqsave(&ndlp->lock, iflags);
> -		ndlp->rport = NULL;
> +		WRITE_ONCE(ndlp->rport, NULL);
>   
>   		/* Only 1 thread can drop the initial node reference.
>   		 * If not registered for NVME and NLP_DROPPED flag is
> @@ -203,43 +208,37 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
>   			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
>   
> -			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
> -			 * unregister calls were made to the scsi and nvme
> -			 * transports and refcnt was already decremented. Clear
> -			 * the NLP_XPT_REGD flag only if the NVME nrport is
> -			 * confirmed unregistered.
> -			 */
> -			if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
> -				if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
> -					ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
> -				spin_unlock_irqrestore(&ndlp->lock, iflags);
> -
> -				/* Release scsi transport reference */
> -				lpfc_nlp_put(ndlp);
> -			} else {
> -				spin_unlock_irqrestore(&ndlp->lock, iflags);
> -			}
> -		} else {
> -			spin_unlock_irqrestore(&ndlp->lock, iflags);
> +			/* Leave backend registration set while NVMe is active. */
> +			if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
> +				ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
> +		}
> +		if (ndlp->fc4_xpt_flags & SCSI_XPT_REF) {
> +			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REF;
> +			drop_scsi_node_ref = true;
>   		}
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
>   
>   		if (drop_initial_node_ref)
>   			lpfc_nlp_put(ndlp);
> -		return;
> +		goto out;
>   	}
>   
> -	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
> -		return;
> +	spin_lock_irqsave(&ndlp->lock, iflags);
> +	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
> +		goto out;
> +	}
>   
> -	/* Ignore callback for a mismatched (stale) rport */
> +	/* Serialize association validation and detachment with registration. */
>   	if (ndlp->rport != rport) {
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
>   		lpfc_vlog_msg(vport, KERN_WARNING, LOG_NODE,
>   			      "6788 fc rport mismatch: d_id x%06x ndlp x%px "
>   			      "fc rport x%px node rport x%px state x%x "
>   			      "refcnt %u\n",
>   			      ndlp->nlp_DID, ndlp, rport, ndlp->rport,
>   			      ndlp->nlp_state, kref_read(&ndlp->kref));
> -		return;
> +		goto out;
>   	}
>   
>   	if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn))
> @@ -251,15 +250,15 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   	evtp = &ndlp->dev_loss_evt;
>   
>   	if (!list_empty(&evtp->evt_listp)) {
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
>   		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
>   				 "6790 rport name %llx dev_loss_evt pending\n",
>   				 rport->port_name);
> -		return;
> +		goto out;
>   	}
>   
>   	set_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag);
>   
> -	spin_lock_irqsave(&ndlp->lock, iflags);
>   	/* If there is a PLOGI in progress, and we are in a
>   	 * NLP_NPR_2B_DISC state, don't turn off the flag.
>   	 */
> @@ -271,8 +270,12 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   	 * rport. Remove the association between rport and ndlp.
>   	 */
>   	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
> -	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
> -	ndlp->rport = NULL;
> +	if (ndlp->fc4_xpt_flags & SCSI_XPT_REF) {
> +		ndlp->fc4_xpt_flags &= ~SCSI_XPT_REF;
> +		drop_scsi_node_ref = true;
> +	}
> +	WRITE_ONCE(((struct lpfc_rport_data *)rport->dd_data)->pnode, NULL);
> +	WRITE_ONCE(ndlp->rport, NULL);
>   	spin_unlock_irqrestore(&ndlp->lock, iflags);
>   
>   	if (phba->worker_thread) {
> @@ -287,7 +290,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   			list_add_tail(&evtp->evt_listp, &phba->work_list);
>   			spin_unlock_irqrestore(&phba->hbalock, iflags);
>   			lpfc_worker_wake_up(phba);
> -			return;
> +			goto out;
>   		}
>   		spin_unlock_irqrestore(&phba->hbalock, iflags);
>   	} else {
> @@ -304,6 +307,10 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   						NLP_EVT_DEVICE_RM);
>   		}
>   	}
> +out:
> +	if (drop_scsi_node_ref)
> +		lpfc_nlp_put(ndlp);
> +	lpfc_nlp_put(ndlp);
>   }
>   
>   /**
> @@ -4506,8 +4513,11 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   	if (test_bit(FC_UNLOADING, &vport->load_flag))
>   		return;
>   
> -	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
> +	rport = fc_remote_port_add(shost, 0, &rport_ids);
>   	if (!rport) {
> +		spin_lock_irqsave(&ndlp->lock, flags);
> +		WRITE_ONCE(ndlp->rport, NULL);
> +		spin_unlock_irqrestore(&ndlp->lock, flags);
>   		dev_printk(KERN_WARNING, &phba->pcidev->dev,
>   			   "Warning: fc_remote_port_add failed\n");
>   		return;
> @@ -4517,17 +4527,20 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   	rport->maxframe_size = ndlp->nlp_maxframe;
>   	rport->supported_classes = ndlp->nlp_class_sup;
>   	rdata = rport->dd_data;
> -	rdata->pnode = lpfc_nlp_get(ndlp);
> -	if (!rdata->pnode) {
> +	spin_lock_irqsave(&ndlp->lock, flags);
> +	if (!kref_get_unless_zero(&ndlp->kref)) {
> +		WRITE_ONCE(ndlp->rport, NULL);
> +		spin_unlock_irqrestore(&ndlp->lock, flags);
>   		dev_warn(&phba->pcidev->dev,
>   			 "Warning - node ref failed. Unreg rport\n");
>   		fc_remote_port_delete(rport);
> -		ndlp->rport = NULL;
>   		return;
>   	}
>   
> -	spin_lock_irqsave(&ndlp->lock, flags);
> -	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD;
> +	/* Record the acquired reference separately from association flags. */
> +	WRITE_ONCE(ndlp->rport, rport);
> +	WRITE_ONCE(rdata->pnode, ndlp);
> +	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD | SCSI_XPT_REF;
>   	spin_unlock_irqrestore(&ndlp->lock, flags);
>   
>   	if (ndlp->nlp_type & NLP_FCP_TARGET)
> @@ -4558,14 +4571,10 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   }
>   
>   static void
> -lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
> +lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp, struct fc_rport *rport)
>   {
> -	struct fc_rport *rport = ndlp->rport;
>   	struct lpfc_vport *vport = ndlp->vport;
>   
> -	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
> -		return;
> -
>   	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
>   		"rport delete:    did:x%x flg:x%lx type x%x",
>   		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
> @@ -4577,7 +4586,6 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
>   			 kref_read(&ndlp->kref));
>   
>   	fc_remote_port_delete(rport);
> -	lpfc_nlp_put(ndlp);
>   }
>   
>   static void
> @@ -4675,7 +4683,9 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   void
>   lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   {
> +	struct fc_rport *rport = NULL;
>   	unsigned long iflags;
> +	bool drop_scsi_node_ref = false;
>   
>   	spin_lock_irqsave(&ndlp->lock, iflags);
>   	if (!(ndlp->fc4_xpt_flags & NLP_XPT_REGD)) {
> @@ -4690,12 +4700,21 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   	}
>   
>   	ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
> +	if (ndlp->rport && (ndlp->fc4_xpt_flags & SCSI_XPT_REF)) {
> +		ndlp->fc4_xpt_flags &= ~SCSI_XPT_REF;
> +		drop_scsi_node_ref = true;
> +		rport = ndlp->rport;
> +		/*
> +		 * Keep the old rport alive if registration replaces ndlp->rport
> +		 * or devloss detaches it before fc_remote_port_delete().
> +		 */
> +		get_device(&rport->dev);
> +	}
>   	spin_unlock_irqrestore(&ndlp->lock, iflags);
>   
> -	if (ndlp->rport &&
> -	    ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
> +	if (drop_scsi_node_ref) {
>   		vport->phba->nport_event_cnt++;
> -		lpfc_unregister_remote_port(ndlp);
> +		lpfc_unregister_remote_port(ndlp, rport);
>   	} else if (!ndlp->rport) {
>   		lpfc_printf_vlog(vport, KERN_INFO,
>   				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
> @@ -4716,6 +4735,11 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   		}
>   	}
>   
> +	/* Keep both references through all node accesses and final release. */
> +	if (drop_scsi_node_ref) {
> +		lpfc_nlp_put(ndlp);
> +		put_device(&rport->dev);
> +	}
>   }
>   
>   /*
