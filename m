Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95DE1DE4CD;
	Tue, 11 Mar 2025 01:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655554; cv=fail; b=K37JXDuZ97JPSDIQBm+t75H6LS5k94/QXOVHK5KFF2fXs3ud4oxJxnlBuZwfbpwkAwITW5glH7NJ3UAVuXfmcNseKqcmsgKxjnOGBxbgNoZRl2iXGJmBsgK8a1Qla5zp+3mQcZ5HUudMWRarRT3YgZ3ySSDGS4D23h+mAe7Xvio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655554; c=relaxed/simple;
	bh=nk7rU0n1wxl8XqmL48iH/uHdR+MSWC/OMdlkv2SdUK8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OaYjnlYx9jDgYwhXGnKF6//qUjpb7L800CuXdJuMKnof/sdpVj4dmsRYhzhABeLu4C69gtG2FWPZad7ele6Ud2Ykw0D2Z1VlCjT/PzQ7UuV4sLH5jNWlrGIIYXqGAgTgGLiFwZC4Yxw+lt27veHY6cBRWyXzeiQKHdVNZoqHkvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UQwqS3wM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wLGKVn1E; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UQwqS3wM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wLGKVn1E"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALfpNj019866;
	Tue, 11 Mar 2025 01:12:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=I7Znet9UC/CvizO2Tv
	STj6KZr+kOf/7wTu/2vNJ/FSg=; b=UQwqS3wMB/XqCFrY8efzBGwHQXh/7qA4uf
	wXzxccirjf8O/PdhthJTtib7dSa82fJ2EnTKDPnJTcR1IZ3X3z5B8OYyjU7PwL89
	VQisumPQmJfvWEEV2p3Wyft3EiZjjEvlCE/M7RTsooMUR7K6AvhyskQBGbXPbdiF
	Ig0hTPukqwKTHfK5IJ5w8uU+qOISOJVn2xzVUj3BvXgolfhgqI5tf43gsvTxe39z
	C7NQgINQsZjqyHfmcDfFoYQ8VzdRxEYk2A+Hf+3tWnItjRIIlQsL6XK0OnOnn1BM
	n/17iprFLvUga/2jI1CgkdLlLUF5kj8e30VR+BAVCModj/jHqjfQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458eeu3ur9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:12:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B10Vg3026237;
	Tue, 11 Mar 2025 01:12:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458cb8c61y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:12:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmB1QDp3xPdJB+1yWMWwaplYpW6RPulmE49cV1/G8c5aMi7HvHuduhKif48KPG2rSFNDOFhNJV/chFkDpK6lyXH/CIPs6VC1Q0x28CZdlqrg27Dba/ChJxDLnIXeXNMxuULAE+r1CXM396YZyfWLLLtY7JhdztRC1n2dUiIXwiS0EHRj4xjh3O/ZTgHtrr/PP8Xs5q0RDqvPXg1o/+UOKcYGvjfRbOgD07Rom2O+ZOOc5P0rWYs0WbVZmo280QK7B3V3EFJ/gQwn8YBZTvrhUdfiCvZo14TyBJJGJ24/jwvpTNjPVTNmYTnUPR9eR6zzVGWV2Amhv2YNIs+ZsU3hRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7Znet9UC/CvizO2TvSTj6KZr+kOf/7wTu/2vNJ/FSg=;
 b=LylTqWgT1GDCeCvrBlMweP+10asLVShgZteAf/cqOLwA4kOlO30pVROoEw3uxk7S224u82Ok/h22g7ROolr12pujSF3M7WQC57518BVUqLBZP5vGZogeHMGWmjW/lsRIl8Sdfol7223r4qV2D8xRcGSkHyIuwDL0MU5ZfokK+lRSINvZDMU2oIczx5Aj+0R4q+Nj5aISpokneauY1dIuca9UacdW5PtDj5MR/jmYWPknRCUfSLDoH7M0C5/aF2XgUdCDK9Yuti3eazYakk/oiaRkOO+q1+qVs6rarjtRlptmLA8GTSQq97BDJciXzC/z6jAAmNPJGTXsMssgF6uaxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7Znet9UC/CvizO2TvSTj6KZr+kOf/7wTu/2vNJ/FSg=;
 b=wLGKVn1EYhqFUrqLXPkcSC63x4oIEeX811syXRDuFtWGpL2iApozMKM5wBRrFs/ZgXP8rQzZ/NueDtRLb7TvTtLosZoHGC5sRc5QOcDAm64qW9vdocIHVJhF9okXEuVofTeDcn5xH9/zGf3xIOQLXstLRk1Di61Ao12M0efaftw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4892.namprd10.prod.outlook.com (2603:10b6:610:dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 01:12:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 01:12:24 +0000
To: linux@treblig.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: static most module parameters
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250309143348.32896-1-linux@treblig.org> (linux@treblig.org's
	message of "Sun, 9 Mar 2025 14:33:48 +0000")
Organization: Oracle Corporation
Message-ID: <yq1ecz4jrqc.fsf@ca-mkp.ca.oracle.com>
References: <20250309143348.32896-1-linux@treblig.org>
Date: Mon, 10 Mar 2025 21:12:23 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:208:239::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4892:EE_
X-MS-Office365-Filtering-Correlation-Id: 40cecb48-1a1d-43db-d737-08dd6039c844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u/+eQ8wMyDdlPg67FyhXpQQT9ZyFAZMlKmIvK4t16QFRFPlNmnkzTcjrYJc9?=
 =?us-ascii?Q?8YnhnPFW0zsOrPzZF0amrDQgvgZBsLykL9UwuWPMtWVYNFlNujZgR4wz0daU?=
 =?us-ascii?Q?6XrcHXHW6xbPSPqbi7CNFZ8qB1bg9a5q3U8XbbQ5k/TN+cjhMEwChNTNa1pp?=
 =?us-ascii?Q?+H4FbfwohKdoxPdl+01EdOQjIR4UwqLNwfMqVZVAVy9AcyHFumyUvoDjaWvi?=
 =?us-ascii?Q?jdveZsUN3usFUuK8d0g+ZkoAsYUrFhmdK2d/gCZUB5Q27yttcqXKhW8FMHrh?=
 =?us-ascii?Q?7mSEasasO7pZ5si7W1zoVc7wJ4+qRTfTwloFrgtEYds/LCdktWNroPT0V1/H?=
 =?us-ascii?Q?uLluP2q79euDncjiGhQz4M+8cokZ3/rPA7vUnslVyy/lRnEVR5+bd1WMbjxx?=
 =?us-ascii?Q?CeYqstnsriWwuJp/t2x8uKYHKNnNiq5DQ40ozBxt7RWIaLv1UDVlwwwFEz7d?=
 =?us-ascii?Q?sp42oY5BzxSWYVyfSpDK7B3N1fQiNhokBzAsToZ3vL9zid4WlfS4EkBMjayI?=
 =?us-ascii?Q?MRb7EVNZcrHuX+xpswT6pG9MI4+y4YDX+MElnXJpf40z7Uvvlq6WnOQATBpy?=
 =?us-ascii?Q?Z4VMkQQRq88f8rSLiwiLkwfaKKW/HE2CuIpvEhn/xVreIoJrTbalZrY29ZpF?=
 =?us-ascii?Q?97sWMbIcHVFZNP1+20Isjg4peL4tH5mE6hJ4LD6d07SZd0OybN5frQukoW2K?=
 =?us-ascii?Q?AeOxwxNA7NYja3LIjHTkk33LoiLV/wv41j57agF0fAZNEhKGmOljuPe6sJtn?=
 =?us-ascii?Q?T+fHSqly0MXHCKeqN7Ic5Gn9pJ5GtmofZPF11jKqqAhvVcMP1syAhGm+MtJh?=
 =?us-ascii?Q?EvwGns+YiAohWED6p9WGQa52mYMzLkwOOpL1Oy0DUptwnWK1HfqPt+BZMfS3?=
 =?us-ascii?Q?TRY/JZsXycM7dzabja/PAsboxY58fiklTLuB2FWJa6TZxHtSsrMj6SOUezfS?=
 =?us-ascii?Q?5aiNeV6bPjYKAo+Vgc+8BydfCdZKJeQ7QrkXcT3ZkOO5XnBUd/aIl/QwpaNK?=
 =?us-ascii?Q?t3cJ+jsnppVbq1D1LuCO9A4R5Xt4vqTgabPhOET12YMJ0A8Ysm14wob3zBDg?=
 =?us-ascii?Q?4DppnrF84hZOyAfPtlXPgkOOr5JT7PAlJukN1A2lig0pxfUV1zAiEcIit6s/?=
 =?us-ascii?Q?9qTCtDSV+2zOigWsRRLyK/J3fan27Md8QmqtmM1YV1tXqN/xSi/9WefBogVN?=
 =?us-ascii?Q?bvHcwbFug6tvMEXV4chtutHG82sa/pk11uTJJdPY3C9g6BcdEEOuKgYgXKRv?=
 =?us-ascii?Q?9+xBnxukUkuYU0EbDXvHrMSEAD6LPy5o7XhLT/E3TIBVqHHDNcKoZK6PwrG7?=
 =?us-ascii?Q?Uvspt4cw2WstMQeZX7orEwvRRrA81CGiZRR04cqdmQwVppBB+1UtQPvHUMHR?=
 =?us-ascii?Q?FXOc6b3/R/kSQQ39o+ZLVstQeOnX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?laDKP9QaouiMxGSK3H7LUcCzTBmrncns61rbaAJjMpZu9UCm4N1Yz7NvDHFe?=
 =?us-ascii?Q?g97Ortk6nC7GoIGSQfK6A/js62PkS1pgMb96gxurJHBGe5g5K6ZmfzTxBYVJ?=
 =?us-ascii?Q?WO3SlQN4P9a3W0IgxzE0BGFlNNUCVK35uNv+we9r+TjD5lKluVtTnl+wKAq/?=
 =?us-ascii?Q?O5ZmpQEhoWhgYXFKOdzwzM2H4FxO1YtioFPJqCcpnMMa4KexPEbDdNc/D4hp?=
 =?us-ascii?Q?olj0T921/uuenqFRt4Cu85AohyxsBsv+fdmibjnGYxK/9ccq9bYDAb2Gomcc?=
 =?us-ascii?Q?W/jwe1gqcF5wci3QcVULYOt1mTBlQyNKQeQHrKF7GFBVIuuQu2F8qf07kgP/?=
 =?us-ascii?Q?jbdfaiMBa6I41FAhZjgkJ5R1Ml5sN+OHQMocxTTVQpUUQuzz2A4ApJcDHL+o?=
 =?us-ascii?Q?VxZ08ASXUgt9MGkZ0ohPsrygzMC82wqX+hwH7YxQ+CobFllyaQSrkaHW87I+?=
 =?us-ascii?Q?ys1I1qv6pJjCdEzRi1p9P9FGmMsbXUBWUqFNT+521obi5r3PguKPvupdMGMT?=
 =?us-ascii?Q?+k2CwT6KYjkIcLFehod1W+9Tw2jVZe8f8sE8v3tkhwiUZ2RZbkmJWmcEeckS?=
 =?us-ascii?Q?Vvu4ve+1qTierC+K6K0FTXZmQOlagRY0oIj25wJU2pbcuPwlAGDkT9kXKh+H?=
 =?us-ascii?Q?DnvdFia7kW6T3k0+lVzhmDkAEumFYZEjD2KZj3VU1RtM6LxNsGKv8CCT4Fo6?=
 =?us-ascii?Q?bJ61n2eG24Xt21TixZKU8hAlmVTWy1RCta8uVo0hkW2lIDX9o3yiAGIx9UIY?=
 =?us-ascii?Q?5Zqm22caBVx9s5Ey7O0gaHraE+NX2Gx1ztthNy2AxlIbpqKCgSe5BZPUG5Cu?=
 =?us-ascii?Q?xnwFBFUnRHXPWRhEO0o3FLdz5Mk4EMUAFlNkOVdAhoyl1doGBQczmdEfXJcx?=
 =?us-ascii?Q?csLNMvnLr2FXGUZgI1TXHdgnzcES29VQ0OK2fzFxP+uPfEP6arJdhXRUY45n?=
 =?us-ascii?Q?afeFL+aSyKziwb/GsB0qb7PIVi6/xifBDdz5gfxy1+QOfw6TMblokrdy4hXH?=
 =?us-ascii?Q?dRwT6EL4fk2aYCtooC56zcK+e2SYz3peZgeXEkDLwmjHd7FNYjLm6Yqq8J6m?=
 =?us-ascii?Q?xJKBd594lJHcHNrYnWzr4g+Lr8HdEiCqw2xrb3fLNw/VzZV+0i8IRaQtttT6?=
 =?us-ascii?Q?6bH4agik7glfMrmkq/8yTenDemYjLh9CFZhVm6PVYVdftjeH0YMi1+NXy6n+?=
 =?us-ascii?Q?mST7xbl14IEiBJspIAODC2aFTW6AeNvywSbxk/i6pK84ZPcazhcxWUoXOFNz?=
 =?us-ascii?Q?NMCZaOEV0xE7wn7rrd+e4zYAiHSEnNjvsg5BaGBv09KMZcZtaMbxAqhTOoKC?=
 =?us-ascii?Q?jWj9ciAy+cijyJ3urqETga4haoj66bmiu/WD0hwYWYE/8dBsgkh/TG2YrJNl?=
 =?us-ascii?Q?BAwkU7dbgIeB0AytD+YWAtV2ou+bAVDRwgPQfoHIVVI3IkiYj48J3CxbzY2J?=
 =?us-ascii?Q?JYkLLMCoM57ijbgojkylKwt0vCJuN9iwj84IHRSWeBOdsi+eLsS5nePlFXLI?=
 =?us-ascii?Q?lhAItjjZEQOvQT2eaF7+0JA/egz8olqJu03nj5aXCrD1JONck/hFEwUVrFAY?=
 =?us-ascii?Q?MK8k6kraF4TcYJLy5frvV/FVBS8dTuszsOeh5gSQD5EeOHTgJ3tdljsp2ATS?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uRsSdL0StxrCB8ixXUY/14jlzaFNdtD+dNZOltzeHFYSj29+L33dr30dvXxnDHqseV3o2D/Rf/S4Gv7RxtKKJKS5HoM7D0IZRLiq8ZgZWVhxGe64sXeONpiQrTrbF6vcO6TGJUJe5VUOELdy5Kcz/dkvJYz5JgFNWSU/n3GukvTjLM6o7c0O9Dtj1JLUB4mY0v78FTD2LtWXLouLYfXNNTIVM+5/YiKTzz1MfheRNYTP9Eg2g/b5zjhqLt5+Rgsx+iz10WIFo+0ymaVUtOB3NhAg9Ao6wURccOnCcR80R77fAVyd6nhfmbnL1FLKeCgpdJ7HXE0dIa+/kJUVEqJZhfT/aVDPaQqSKFgpSt+9zCVLuKdOLxGSyFaHl8YhZnBhJoPziFQ4WoAdBQVXFgllJqyGcTdu5PXsscgwl48/uvUHnn8xwF8phH16Dll18SOeWuI0rSHViL5ZEPR7GI8wgf8NOmgdbP5AiOGJN6NvHIhQ6+5Z/kaMqyf9DyIHgaQG9j5/5KS5mj4JGD+E3iFgRluLH2GLEKa8+AgppY1MiRuJ9swH5ttqAX9qaVUqV/AGew15qTDUM5w2mbKSig5CDICzYXPtVaUzn/P0A8FrWr0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40cecb48-1a1d-43db-d737-08dd6039c844
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 01:12:24.7208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2Z1Cq/otWWkVrxqWeaUESnrKkKzM3yVlLvZMs0cWFgfJdQfE/Q92O4hQJRl2goTycYe+nhTyBbkuY+Rf4uetZxMSKdh+5kOEaI7CYuSdPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=820 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110006
X-Proofpoint-ORIG-GUID: m0oBfxHSmOYKRs5wPu7HHpJ-efoja9hK
X-Proofpoint-GUID: m0oBfxHSmOYKRs5wPu7HHpJ-efoja9hK


> Most of the module parameters are only used locally in the same C
> file; so static them.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
