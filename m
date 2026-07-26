Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB2A189F43;
	Sun, 26 Jul 2026 19:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093644; cv=fail; b=hAsVvoIVyhKvZfNFdz6jjG7qf2uaNKrBKS4wyIrX2QVV9gFqW+2X2gTBs8ofunhsLIo3nsRlHJFlvVLxt74JVwNZGh0lp2XqnAyVYntjJjj1XZcXIOv3A9c6FIF8K2hsWn44l3z8hg9XWPt4K8LT95uanTs6rqskoJqJZWCPAlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093644; c=relaxed/simple;
	bh=ABxM16l6LEnfPcVch0+kf8kdV05qC8hnlGQlHytto1o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=O9cgIHkEUM98xmTyOSQKuVbkLEfMNyQcT7wXhXvhvcOkktxnSW1sDVr4GFVtOL50YIWhNM+XKFr6nDM23kqiKVGjYpxHjWnrKnUWV4/Iqm1J6/7u5LkFH1Fb5dhroY+dI7DNcn6+Pa0FZKYfrFQbW2qr0Lyt1Kt1N/Nm/u7g/Ak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sB39lOip; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ugigjIeS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sB39lOip";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ugigjIeS"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QIqoLX336639;
	Sun, 26 Jul 2026 19:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BSffsFsXaQ3xjOj0nS
	g+n0Ptw2JLWeP7afNpmMS3TDk=; b=sB39lOipaWp49gjfLgdj7lsrMvgQRtLNlP
	FgSN2unoS7ld6Vh8WLZp1U2AR09G8XQVzeRG5KwsWo64AEFErpW37EAeFmnTupvg
	S1eQbJUWaJ5t/mYbdJMxJhEo+HUezq00jCbrp9XTxdrgN9QZibgM9qtsCk3hVuRX
	gsHgFt51+YZx4b3mfbNqvf0k+HNYcA6baxOBIVd8NB+GSscZoPxTiWIOspYX8gZZ
	HZcqHegMcz9NS7HiHhmYLREhuXOxMZprKyNHXWT8QX0osqCDClv86xklrTcqyffP
	+hp+0COI1YR0jnaslFDsXbIDunUol8LVmRwsyOkw/lgdvfopvyVg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5ngx8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 19:20:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QJKSFP032272;
	Sun, 26 Jul 2026 19:20:30 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011027.outbound.protection.outlook.com [52.101.57.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6mp8up-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 19:20:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HoE2qCPfI6dYgrqYF8Y7+QbzHaAkJQTtAf8Vo7efc938in2GmX4lWI1PinHozhRIYI+UMl8mEolaeN21cXOTlgTDHtVuAEpT4Ixs2jxnA1NW9hN0GTF6MD3TDikxH2LpcfWR6aABkzKAaioKu8UfcCOu81H7Za2hk3OLpL/0+84W+shPvOkHJa6vYk0d4QJYRtlwmDU1RH8BCxDpYtZvmRdZRIqbLt6ykIIwjSXoOsojiaT7C8GYBP6+FzCnL4tuSJENfyp9pZqGKVaU00/8+vfmzHPQV6371waYsY8uTKMwoqAJUxFpmBPMmIDRdWAhrjVAUNfpPcXoEcM48TxFhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSffsFsXaQ3xjOj0nSg+n0Ptw2JLWeP7afNpmMS3TDk=;
 b=EebVLWawwey/1z/EGoKrpdzY6p9bJbE0R7gbjp3ZlFM8aRwEYWNAtSIlCRyy8QEyWOZcqCV5EOjU/qPRp/MnAXwNt7fPfq2iYDSMbb6mz5duZdVSijKP0vHCfWbgc43o6AhJkJdvKfT4e9zp6BWaWkt6BGNVilSJ4lvI8vHACFvfy0qOCCOiRyiqnKL+o0nfw8zCxziDarBW+XlPeL9t3Vl2jb/pYykoRpH1MubEMuaLvUjN5XNJu6MGU3NayfCs9/PhRv8uVrV/52E51b45qFjD/xQfY+L/WigLYBrWg8d3KBFKE6dxc9S3tUCo+RbDM27zz+Bmu3aHuahK2eLobQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSffsFsXaQ3xjOj0nSg+n0Ptw2JLWeP7afNpmMS3TDk=;
 b=ugigjIeSuVbGH6TvXhtiso5EbjHNDyQWAzh11jZJWJYwAJzEBfH+7s5d1/PztIsE+nF0snTXyzl7Rpf0wipXZc5DaSdOLs5d9k0ptdBIXjjuhtdIq1KvAHjusec2j8GLiLIOqPotgPuLAxzQy0YqPr6Op1lZSv6Sa9GyWERQR+g=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7089.namprd10.prod.outlook.com (2603:10b6:8:142::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 19:20:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 19:20:20 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie
 Lenehan <lenehan@twibble.org>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: dc395x: remove unused variable fact
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260714073510.43289-1-colin.i.king@gmail.com> (Colin Ian King's
	message of "Tue, 14 Jul 2026 08:35:10 +0100")
Message-ID: <yq1ldax1rtn.fsf@ca-mkp.ca.oracle.com>
References: <20260714073510.43289-1-colin.i.king@gmail.com>
Date: Sun, 26 Jul 2026 15:20:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0146.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: fe6e3ac4-9267-4d01-1da2-08deeb4aeee8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	A7ijXhIgfekUQF5Jn8trlonObhElZLQ6h/KkGcBpEu9par5ghiFh1oQi/eNZjrRVIX+ZAwXniFbFPvFr6fBoKH4TqSMIcFWoPI7FPWW2EN/AcW2UQGyyVqvVaO+KNWY06/YIks1mUjlSR1dRJ1lzzzL+cXpZ8J+zxkZRILgzqpBU+2I6LlqdGOaer4H0bD5xSXaw7y0bNAH5lrB2Bf3oOtWYi1nbLh/pJcn1cV/rhq3jJDpbAKg6ikm6QS7r4L7uIljNgrbNM3BpT2YeQll2rld5j8tskrwfvMB+WxWGh/9IrdtzeAog5kH41e76ZNEoRnTW0eJNSb7zlqLmO1/D+9r3GnIn6Mq1p8QaBsTxfKhxiYEVw3qJ8yWhuvaeEUfVqctvG/4ZpuDc5/U2YUt8MRVgVirw2HmO2bnfXaL3RCN0mVkUR64rmD83vRzShaInNlapBDf8NH7rBSz6pSkvTeQRhHcJfW20C4XuMeor5EfgZax+T6UO4nxyCDDee5ZzyT4XEN0l+ylsyXBYirghDY1u2JN/DdJdnzQlSSgDm6oQzhUW/9qs0+Xtayyb6kIoiHYrcakcOihZTiZ5R9K5CFa6cEaziDsEZci3Tekr2uhnciW8Sao0NqJgMBKNWkYAAex08okYsNEeWlxLor9Q1wEGMY0Ibs4Pop6gGZqeCLo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FOBQHGNqwZpMSHA2lmPNNTnUZDuqRsVqG8dZENtjwjj1Lms+ZKdcjpBW+Wvv?=
 =?us-ascii?Q?qdIYaQDH4Jwjuf9ttN4K58EZg0R/dkA0Q2u8ut6TqE+vHlfxob+Y9p9DGn2m?=
 =?us-ascii?Q?bGb++fAeNtJY3OeQZageiR/Lk+uQdsGezyT4fqvhFckZX7QFxiisIa2Xjxn7?=
 =?us-ascii?Q?n1KNg+g9fnZdkmyA1s5AMPM1gTb7Ye0eQojOcf5GXi3L9VVOkCCP852Lifpv?=
 =?us-ascii?Q?Nl6SDxX/IEHWQHmBpQMvVUG7xuDGORcoeTRtvNua1Kio01y1BC5Fs81LV7GI?=
 =?us-ascii?Q?dIwu9hiPqC2CxkdeJsmukRfGybKU10R4toYjVX5RH8Dj8qWLj28ZnaMZledJ?=
 =?us-ascii?Q?MdEmTncWcuwAXiG73vnwHqGgKNaSMSPpqmWMXxe6BEl1rlg97r054+bO6qqC?=
 =?us-ascii?Q?8WZpDaAXK1mVHP7VcvjSvRGeERsyQeU5Sl6e0SlzthahYL10BqeNIpCadQSz?=
 =?us-ascii?Q?6eoTckmvzY0LC5Oro7REc78Jf1T1v7/oMFMAV3VYaJrYo+GzdS2asEEiLnYC?=
 =?us-ascii?Q?IVQUdtHDRDhpdHe6dzJ9uh2xmg5hyu9gbyhxsKCqq4kHLsEQ+TX/5Dhi9TWg?=
 =?us-ascii?Q?KKumsi+vBsbqz0SUEP09t/ZrEQDCfrr2GpApqGHF3CMUsS34ZpAsPlEoi2im?=
 =?us-ascii?Q?hkt/JmVJE/22wVDsujQ0LK1YyzazbGvwDP6KfR/CygZ3f/+IjCDtYeA/mJhL?=
 =?us-ascii?Q?OJbHo5lOmxoyKI6KW9oF6kWMYx5Pt+SCAjRy0QHa8CU7VKwnfY239Z0bIpa9?=
 =?us-ascii?Q?oQsKgtFjDhwx/EUWUiay78zx/cftwYPVNHxeMowML9bgUu92/SU9N5ixgkZx?=
 =?us-ascii?Q?x4K4K8Ca6bUxF08hmYPuD7hJpmd3rMC7MwKoTO1wMXjA+tA/pmgehNOS7Q6P?=
 =?us-ascii?Q?kXKudTvNmj9VjS0njYLQepbT7JoV0z96C4PFj1Kx2zxCe8gs2s2V7wuJw7zp?=
 =?us-ascii?Q?esEr6Td7gfIm+ogT/J+M0Y17ffox3bGGkgdsrCgmqTaot4WqMvk4hkLrT3O8?=
 =?us-ascii?Q?ltegUANpGpfwN56eghjyf8cgaJL9xuL8vBZ6+jmAsyIYxyVqNFnUIv5gfOL3?=
 =?us-ascii?Q?yHfOtIc5kbGV+qONgvuNAWVsv/MpOF+5EFv0q5+5R/ip/468buy4iamEDEI1?=
 =?us-ascii?Q?UTCO5xjEplzA5bfubcJ3zDe0IyowyFhsNJlDCfgxJvPo44fStXFLSI4zpTJd?=
 =?us-ascii?Q?soP0Xe9yDW/hugH94OhQYAY86Gd3HNNnD5h+fqY1crxP5EGjL8CpGof1qrmn?=
 =?us-ascii?Q?FVFkeamckguGwHpYukffCLE9cEY9fLFVjP+vVvLpcAZU2vFvcS8fM1DxAvCh?=
 =?us-ascii?Q?R5A43AcKt6nBV7zat8CnK604OGSgnJdx3KBuUGN1qBrv6mBlTzu5SiemI1Mb?=
 =?us-ascii?Q?hsZCBSpNvYbmLs463SauDYUqpxUGQlybdCrDv13Bge4ymPs901jq9tujBuVt?=
 =?us-ascii?Q?oAAaxfBAGCdLX4QdsXmj6f8Lda1AG4qxG9t0WQiHwBVfc7sJ4hjJG3nXiHZX?=
 =?us-ascii?Q?LzAo3Wz2vygwOqdw/5eQm55vRDG8OBG5zR6bhJN2EJjeor25sGIBp00mFVZ1?=
 =?us-ascii?Q?uCSZUKqyXX2dgVKSUGhZ5UroIRB73taUMeyvvRoCS6r5P3M35510XdWW26+e?=
 =?us-ascii?Q?h3H90HmSO4saaaezNLQmlEm5gddX5ke7Iv17Aybab0RKYPgWwycsszTLZ/pZ?=
 =?us-ascii?Q?aJqn361naJ0glYFqY7S27oTo0dYz6NM0+CGjWqb/sG17PaEWsg4IXsPtPycf?=
 =?us-ascii?Q?eyrk4jjSskTYgLjrRTgk3Ox+AH718Uo=3D?=
X-Exchange-RoutingPolicyChecked:
	K6Uu+IEqx6w0PSZ0+WW/DU/2mfFlO0nGQYa/drH5YcYM56slR9X0ps4FjwlSg84QzL5NxF3TA/6kN9UVIwsouy3Sko782yiyhEzIBeoU2/luWFJjgMOLelvVhyFG8WX/eXm6OfJOf/QQ6G3B4VZoDS6eeAc4PZ3JPA+n2NTrN3iKRlidEOrYMuLuLjE8NVi+lSvEJUgJyxF0fZj8Onkk8gdeRh8oM7OV6XGQf9TjzJWeS9aItvQ5f5zJqNnmhk0FIYd1mCRnaR4sgQw9d5pV1uVvcQ5ADJifp1M1QbJEEuFwZo3uHaRXmf1ygS0rpJ8+1dU/0a3+kmSryRriLg5YSg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eH21QjF95jCORLzZdDeNPbRgk06oqM9Cg7YKGeOLedUtoliNRuYLXXnB0XsMAkxMCemqDDNEgQBvoXjPjix+3UyeRRJdbvNRIAqzBIs7KAZ4R88V50myCUzuAnHIIUPV9ybki1FNhn71LSoWxr407QbxT9+HZrTOq4oOX6ceuANIGWnA+FXhxDjasddBwfInEbK9UUZWwlt61AT4wWgX8YG+S8vpoAV6r/lM5tuVs+CQ0wAhW98or8W6FGgmK6qZTGzBWC3G/TwG6PWfNpy/5xbvGKBVoErwuMlJZPVMu7KgF0ZR8gfJdNjNpvdGgas4BfzPDfGxgXntZPd1SnjBMs55uW72XzsbckdF9b3cOiJneM5y6Gh50gY+rydgXz9bcgN/uS4VX9EqDzpyRcCPaZUz6XMQBtOXwO4s2kG8Yy6KkEyFOQebnMw12oT9ii2H2/0RbNnNI18l0aZKrwvu8JVJOGXyCDXIceDNomK+REHdq+Iv74Wj0qorzmuHQgZIgtUfILESblo5XFNHedblnVfrcxGxtAojHY1M1Z8DG4fmDhKmS5QhWmRSdY5auRySwiPuF5+VTitkFS2ZUkLH7+eQoHB+KEP9Q/Qrg7Q17nM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe6e3ac4-9267-4d01-1da2-08deeb4aeee8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 19:20:20.4965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cb3Sa1/p/pKACH5+IEusTI4xw8Nfh6QvQ+LNc0TP6T3AGrCx9NsHl6Q0jnN3biZMa1VNmaJ3sf249l8NDBgG1HIBNgRDb+v6Dac1TnV3b4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=710 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260196
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a665dff b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=12cj7TfuM9MEmnwLILEA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: zcDvCakNajVax_mHaQNMs2Dx251Ax-iK
X-Proofpoint-GUID: zcDvCakNajVax_mHaQNMs2Dx251Ax-iK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE5NiBTYWx0ZWRfX3SVn4YZ/Nnrk
 tsP2bXn/MUFbd57U0BE1h3aNMTS2aLLLWQYKczV4CIoBomYWjYDL/Eip8u6PhUlFweaCnn+6Yzs
 jZUer3qSEOwgrGgjfO9iL/V4ifN+K7FkSW/hSA8SwX/lQ39rHx/E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE5NiBTYWx0ZWRfX+lMsVeABMqTF
 nu8ysOPb0tn7eRWKrH8fYQXUI0B7mMjK9ZwfwgSimJtnQ0ACB5KFBktVuZNFXmW/4W/M0nuCXC9
 pS0oDgKcIj+nuSndOboCiDA2XB7urHpxPYCzmI2clLgW2EySjREExyxrnSL5M2wFFUAO3XfGSXM
 6ABtvIykJfvun8+6w2ZBkjqnIAMrK3y8VeQKiFmwGnl99f63RZEvi1v1pRWAPPIHPtsGgGsx/pw
 cJ+mjoV2s5MTXhRIzDYwHjy6CCaSE3Q0kfpsSjxWY6YDnikDSnNsSGGCC0IPS2zkz/t0LnAoHi0
 X7XFy4osD3gTPdbCck28rVSD0R3/NuYdQt95waLk/EmD4cqFTVOH/AoRzkMH/BBf8RSe59GNUdg
 uvIqieyhlJlozYJW6jLP/3/9XDQ2S38F+xfLw+8xUEc2+3w42kawT8gGbobP6a7EWeTu5NI58CN
 1ynTkxS6AUgUYjBAmMz1C9JUWlpY/4LCekpdOrWY=


Colin,

> The variable fact was used for debug but this was removed in commit
> 62b434b0db2c ("scsi: dc395x: Remove DEBUG conditional compilation").
> The variable is now redundant and can be removed.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
