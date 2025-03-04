Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FE313792B;
	Tue,  4 Mar 2025 03:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057543; cv=fail; b=OQToSdW5NtKe9D7ymtw12uy9SHR5NZ9DI3uSR9dRKUn4ag03j5QUxpD75USqR2mlXezdT3VsyG2YWsOn7UTtRPE176CDAWJXe5hkxMj60oBH3KDLZcCp1lpE3gy7w2oVSLcHeJDnyNeWX578fZbMX1kyZXuosmekWYbFYy44ED0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057543; c=relaxed/simple;
	bh=Hn8GCJw/rEYYFM0dT7+sOzIKY8I1n6g95gKC6odgzFU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tn0CjQnjVL/x/EUGiPsfb2MtCk+hlUTUPvWyA7rABsaJ60asBtZYmvPQ4wzQGwjRa8cRPdtG7ONYMhDYJjeo3xgGmz6ne5brAi+NT+QcbN9BaXoRsAHUKHVGuYCFUOiZcDlhEwZP6EnIseLdCSyIt0B5McAwma7X7f2wmsw91GY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RuQO9ZCw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oGtTR3Xe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RuQO9ZCw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oGtTR3Xe"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241Mggb015720;
	Tue, 4 Mar 2025 03:05:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=sFRxEebjcMY4mDozci
	6xyydEifYo5+7Rm7UJFf0PBgs=; b=RuQO9ZCwEuz1339eDz5j8Z/Q1cdeid/mqb
	0XiGm2ObNzQsueye4fLqMwSl2EwN/iB/LOuYiU2FmkVycpJocMuFJ2N8unuDNOD9
	P/fiTXYo9mUiYEtx7krvVsjBP1RaQ4iJ+yXEDQYoR4DpXjY5ukMGNRkTi+YcyQTp
	0nhVqqEw9az9iwbVqlE0dzzSWpJBZByayeQ7m5PafCJzYw141SLhcMBPHLYT9sYZ
	v8ojeeWQq56gmQi9xFEN1vMo+L1dDCOMUpKZ7dCCASEGL8doXknPDOwlT2bs5j1L
	kCjZYVMSf8JIHjj6PMP6ab4wHQWWY4kgQYDaLsk+dkuaZkF1IAjQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u9qc4j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:05:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5241ppsn022760;
	Tue, 4 Mar 2025 03:05:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rwuafdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:05:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rj/uhITXlkML7HueexiFwbO6YnxBHPp4BbHFewKZBuYy/XMnL4Xh4aM0dJT8FuKZVW4Aq2lHy5QnJf1HhbfoeH1eQgxmtffajPOFGxjF0BrO9x/UxxV8LNdhzFseExPaBfEVwvPKKR77Rt9bCFNpftXUrzRHJPTGZL0K6neFF214Sflb3P0h9JWBC6OiYdKLAfYMaafJ1xRBYL4WVSEKw4QBCGC4LBWMwWD9RR2nw/dQlF9rWEUrTuv/z6lSOmJUQjficC2n0s/30+yGWWXllF/7LTAy8BWmr6O6lu40jNNUZsh6dOX5I3IHu599PHwl4paUTciXVP+MrxxgJUFulw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFRxEebjcMY4mDozci6xyydEifYo5+7Rm7UJFf0PBgs=;
 b=Q6ELnqKevrv2RGQI5WTBJ5HHudEBXuu9jvFi5ASX0fZ2C+p1F1k2gooB/5Sjt/KVSLNusBxmky/Jj/hnCdb+aLC5k9Y/oHcDaVrhLDo44mn6D7BiQFegXiLnOjcNVWKxRx3tCuUcCmUQ45zGiIuLqs8AjJON7HvSUoy9T9cusmeCYHZHkStHSR1cF1XE1+8IF2fIBMncloNE4N38g/lptjZo5buVwKa4o7w64st+YpwqEYtvhK0NEN9eLNLXbSa9QIIviSqP9ZeMWlg8udxzuRTUNplfuKIjyFcpZGr/pNrj9Ocyu/+7OQNuxba6eHi11j305LOakD/weDluXwRuNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFRxEebjcMY4mDozci6xyydEifYo5+7Rm7UJFf0PBgs=;
 b=oGtTR3XemeEGPYlsj01cSRRWdhl1AH+VtZYixmm72CiPca30N2dQZwWKVL+A1FjjydIBWZHe+fmhKz8koi9X551ms/Zwlb2h1cGaz5BcagXzv3ppPD3HSE+yEP2HrrjAdqVpWpeZK0Gnji669nUlnjCM2WzVys74olzG1PjlryE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5634.namprd10.prod.outlook.com (2603:10b6:303:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 4 Mar
 2025 03:05:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 03:05:32 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
        gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
        aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter
 <dan.carpenter@linaro.org>
Subject: Re: [PATCH] scsi: fnic: Remove unnecessary debug print
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250225214909.4853-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Tue, 25 Feb 2025 13:49:09 -0800")
Organization: Oracle Corporation
Message-ID: <yq1a5a1ts0t.fsf@ca-mkp.ca.oracle.com>
References: <20250225214909.4853-1-kartilak@cisco.com>
Date: Mon, 03 Mar 2025 22:05:30 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: d579c312-5950-451a-63e7-08dd5ac96d4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?alBqFpf1YfX5upKFYXa0uG7P6IsugSCE1mPlAx/0THE/X0JZ9l+DzqNKKEB7?=
 =?us-ascii?Q?r8HIGTtJGnlQ5jRNiJcr/SwGsLAMd4cCD8/vGwWUeugIRzYDxOlgBW7e+5S4?=
 =?us-ascii?Q?R4WW+fneb/asesr9lfsp+2BumBvtS2PyaxrtZYAu2kgo5iXbef9e73EqUOGA?=
 =?us-ascii?Q?7yDZcaOnJYfVHmod/M+11z90x58m/TELWObILjU7SHfwPRI7mEpfZPPXQLh7?=
 =?us-ascii?Q?hZ2YQTnOkYF0I5TFKHFy6tMb8UTsowjaFnhXg3NMHozq+hXF/jl4mMOgerYn?=
 =?us-ascii?Q?SvvUPDKbjLMyVQUmGj95AtgBru6x3oIt1DzRGC0bbrB4UZJWrAoGyVZ2ZDeD?=
 =?us-ascii?Q?/zcb5zTpt5W7KRNTtIBCcA63xvdhawzWmltVM0zLhY5RBYMEp9CqupdWwdaD?=
 =?us-ascii?Q?IVkrEdp7+35CAS6RyUCVy7h3UYNt166Tc4HiFFOXVXIAeW9VLLMS3f4K4ats?=
 =?us-ascii?Q?BYBaA29G7eyfBNBVPr5wl3mcj7q7osqnNpW4sckvu1XGl4G2w9MEYiMgTJwE?=
 =?us-ascii?Q?CO87YBa3jq0G9p76EoEk64fowP5xSJVzrKECOWhPJbUjMVLyfIJia4KFA/zp?=
 =?us-ascii?Q?6CIHyH0+bTxTAFy41BYQcfTyNkiQ3NbdLs9MsEuRftjc8mFiy7nKsJmy8JCz?=
 =?us-ascii?Q?HtE84faWFED0Uqm4xZ4BV4jnJYm3ZGvaSNlqhve7yfT8Hu9RkhH3FqJ4cAQx?=
 =?us-ascii?Q?QG14736FUd7uPCfS0fT4fhJibm6EmVUq9/IJvjNR68DW/mxRJ2H3ChYrn5Jb?=
 =?us-ascii?Q?W7q0QKDR9swVIZEFjBbIzrFS1nLdCyNe5chHZoGxDkU+/JKf4JxCXBf+QTOW?=
 =?us-ascii?Q?3X8z5xzjjd/nym/CQa8MVWGB416udi0KIuu4hzReRqyExHZ4xstjSek4rxz0?=
 =?us-ascii?Q?1hP9nKxL13hdfU1NQGEq6EIoDg42YjOKqP2Kxw+dssewp5XtNJjn30m8NFbe?=
 =?us-ascii?Q?Op2ouNad+rMu3iV9vhUDH1tygGdq4Shi6alJIfhDGFxA8jurjT5ePP/nvwGg?=
 =?us-ascii?Q?dddHsuXN3ORf5lynCQYnUkDi824N39j2IHJtlhPPNFcYV1mU7AcrhbbMfLLW?=
 =?us-ascii?Q?QOJCyuhcMXCH+s/GSLlYfeI7HtTQySS2AZ8MsxfmovfycQ/zhCCAOTQdmQzw?=
 =?us-ascii?Q?4E5wnApbDD/TV1AIvXoZC+liQUz0MthEaECvOQXc2BQ327QSf4YGtUltvUMs?=
 =?us-ascii?Q?pVV+SYunr1Cn9omGdTGnH6ZnGHf2I2B2/rhiv5qehaFtW6VHQFw4mE0uT8E3?=
 =?us-ascii?Q?8uzAQVXNJkF0rkfM6v4thO/0t9ls3FwlmkGN12h/b/jTBD9KWTCZipmiK/63?=
 =?us-ascii?Q?SCRGXzs/sb7h1cIPCfGyW7RBYbkZUAKJdak6/gfIIGdrg/5wRUNE2B3Nd9FG?=
 =?us-ascii?Q?QuEi/JRch/WV7Ntd8suHHuz4puHs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?64V5pQJxpsUgzyFAAOy9bVbq+w06pJZQ6wK1N79IF2X7xKU4XxDExc/sDUT2?=
 =?us-ascii?Q?1qvhopUsZvMcEdqyB0+3fZZxZIPTjMIg5akkFvHZK/b2xGuayJjup1M7YnR4?=
 =?us-ascii?Q?cTjKQzO5ig7IK9NSdCVJ0acGPLKEHjvuPFFbOprOpJf5AGdzuZBwKcRJLZ4s?=
 =?us-ascii?Q?sAPmDkVE66zWN17TByCoVem3MWpors8nK2NHvX900week5sYAtdEosFCgZjg?=
 =?us-ascii?Q?p+OLElP2YNLYpmrYkp5wXTXQYWCKutGPqfbkXIXM/qAuA6kOoKyU+T3sLDJd?=
 =?us-ascii?Q?YlqYDuehYbaeOwI03OLzM7G3KBK4cNMgZVRwVdu+/VBQJbjCKooDA0Z3AZ/A?=
 =?us-ascii?Q?7fbAGiGWmSmHd05DCr80mPfe1LAAAQ3aVAnjd/rgXhenCslQYQ9aYf5uX9ZX?=
 =?us-ascii?Q?5Fur68xVqYyxtKQlJIlgoT/4RFgb25vB+64ZDBRnCRs8Iu/4vsGBWXdSW7od?=
 =?us-ascii?Q?tO1f9miv2FU/wrth6htuqlyedZ0xaNsnLeMafTuMZcxVRPmz+Bv6MwFG/vSZ?=
 =?us-ascii?Q?ndiGhSkgBG1WDv5uFKYHoWhJrlsodfiUU2L09DiHpl5gUWp0UhCkfpPKup7g?=
 =?us-ascii?Q?GkYHfM7JY4jnwcFYcLoNjQdqYU5PBmRvV8EsbCHfShfrwNE+B6tlOQ/X3OVt?=
 =?us-ascii?Q?TIgxmN0U1Jl93WX3/2aWS5Z6/DKvtBI9wBmsuWPKlaxk63DxHm/AEm3L38bF?=
 =?us-ascii?Q?D2ch5tjUKo2B3o9M7/aSaKOR6HS6WrYXvql8kewm41ztnwgLVNh4cMb2sMpo?=
 =?us-ascii?Q?ZFn9FGcW5cJqPvTZouho+ouV2kHbglswJ0nk0hjs1XHsbvq9C1Rfhnr4+ihg?=
 =?us-ascii?Q?l3IbF0Ut6bZZuM/tlf5YnTC/ZZVYhN9FoRB+1/xksXyMP6ACvO5dvK7xakJh?=
 =?us-ascii?Q?WemIHmfi/6IWuPYnJ76NZbUxQ8eHIw+34lye438SfJpz3pFQC2Igg1Y2MmD+?=
 =?us-ascii?Q?hfMPqsjHoQ+f52BQd52anTcNIKSV+ByyfDwZm0nI+BGfbonMCj4FZXbCLL07?=
 =?us-ascii?Q?HO7P5obMZvKifsCQVZ85wLyZ79mrWAHzPIPvOFzzDMskNPX1Ydom9OD1cSuf?=
 =?us-ascii?Q?Ff4JIONlBREi89+U/565nwOyHUPdUsOAUceJTVRB3OyGkB95xrsXez6CUjdA?=
 =?us-ascii?Q?Wc/Ifo29ttcDVVk45grP5jfLcW8wdE9xrXUfGEkNjqQvaDh6MKZ+NxeeccF/?=
 =?us-ascii?Q?gpp0Z5OcI3hz5T6qQ5empjLKxpTUBi9VXww4ank9T5oGYCqK9s79+G/lg4JU?=
 =?us-ascii?Q?I+vV0ciYRImRMLU/SIvnOD8A0hGQnDYZpcRsGS2CpveFnKkW/LPDleoQYA88?=
 =?us-ascii?Q?ZYiuZOxUt8KwGMZne9yhCbbt7q/YQnD93b7CT5OHC55mRmPJlEl8H/35G/Wd?=
 =?us-ascii?Q?CijwfzlRfMuxiWD2w9Jxl0bqybN/eZK9zynHr8C3R4uGTSLsx6dGb5N690tu?=
 =?us-ascii?Q?66wkdn6cVhvKpeXEqHoBV4XS3uok6KOpezksfJtl9vYyPGDRErzeHV8OuFOt?=
 =?us-ascii?Q?KKjjLcThC0dhKtiyo+xByOnvYbY8FaAJZYABnRWDnWP6Lby4z+XUpPFZWLu9?=
 =?us-ascii?Q?fp5Y15OYDoi0prFtDU8A215BeCksLbMcVZmbkiY2UYYqYXrqUxE+eJVkUTBB?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YtNxDKDSK15vsjXdjYSumex0TXb9GXvmK+iiXqYgCCJ4gpAVZ9w7EYQ7SM2eimGm6OAzdeJwTDF+81ZcEL8Mce+qGC1YoQ1vIaHjL4ZGMNcn1EEQheWACRlk8r/OJtQDFz2ZJ7ed978h1FL/1ItN3B8g8K8qAMU3jWxztr7oIHo2cF73myEpAxWgTPyXktEwypSDEsuYCOtGC7kayC3QPRIRjNJyiPTXA7FCeQYUCLx+hbLfYpUvO+lX2NELz67WEcUHZN8oX+d+NsHW1dL5tkVFXJzPhywPhUj6Av+2vsdx/5ZUxIWOawBDzpx09cVlTAfCIiIEQLxrgbnj2VCgiD5ZG8H3UNsRyv/Wd7YwBZB2b4WALur+thE/1XdeENNUY6QyDIdsNGITPqFtJr1Uxr7Ul3SGE25kIA7cKzTtevNQRUXyqOO0TP+i08YTII4DCOginkU0B0L7ltD5qfSCYdcsr934GMlBq+torxviSWxRmWcA4bLUVazPhWG6T0K7VvU5ss2YM/r4QJ5nLTHDmBtsWPgbb/PCdjaudP1PgTnsllAnPi4ufPklZtRj1Fg3UFzppQ/uAbHRS+4JvDvN+dKcWUwqYI5Ayr6sIDg3d9M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d579c312-5950-451a-63e7-08dd5ac96d4f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 03:05:32.7331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKGMRUiofI8EYOV2DPflTp1YJ6+CZz/yks1VovuU0KG4JBOPe/YXbwaSE7OPIwNlr873Nkti8ZFwnZKxn1Ye7JLnGuj5FJLpPWy7LYywUo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2503040023
X-Proofpoint-ORIG-GUID: rtbEOb5xi5cKPUyJtR4a5sMnkIq5-KoX
X-Proofpoint-GUID: rtbEOb5xi5cKPUyJtR4a5sMnkIq5-KoX


Karan,

> Remove unnecessary debug print from fdls_schedule_oxid_free_retry_work.
> As suggested by Dan, this information is already present in
> stack traces, and the kernel is not expected to fail small allocations.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
