Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C99264A9D;
	Sat,  7 Mar 2026 16:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772900493; cv=fail; b=NkDcPz743qOlyas4n4jFhW/H/IoI/qtNgOGqMdiM18nWGM4JhihMpgkE6PlKg5DP7/uhaVs1YbdKLSV6aToYe9Ddu7nPIpZ/N+kqZtCySLeWk8rVaLypoVGAvpPey/H2/YGWzSN3OFeJd0m+fuaVgkUw52TEXemspqp7tcAlNCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772900493; c=relaxed/simple;
	bh=k190kcyG3atK2VmZrxPos/e+hSWKIaLG7MOI0EYKwpQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=V79iu4ELytEHeblIssLXAIqiWXROro7//liL7jsLQbMvu7CsNnvxoBsMatJ++CBxr5ySrPTcieR2N4LBMRZR6ioSwWFVW8EqzFr6bl3elsVCPjBMpmeX7JLp2+sKH7Ek9Kfjp1BXKEBPHyxNhd0c1VPR/YqYr7nxYZO+Rj6p6kY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ohWXxY8M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JNZkY0bW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ohWXxY8M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JNZkY0bW"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627GKT7c3647528;
	Sat, 7 Mar 2026 16:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GekdmyMFfhRuvRGFVl
	2qhXVDnjc8aNR7+FKXVeHhjq8=; b=ohWXxY8MGb70iTGDuk1gm3j10JR9NsabTs
	bHaxtDeEtCBn4OlT4KbLI1AbD24AyD9Kyq19e0CA1+/hGVG+JsDdmcFT0VYGFuUu
	hfi5d5zaWDVJqr4+TY4sdoCOcPnQ6uJJAmjzJ8bvX2c1LFDqaS1f8Mv/AmfZoxfJ
	D/e9GsEjU4aXv4vteQy0+95DO8mhi6651vIjzCFhFqV7w7mcoUoq/I21Eb2XcOPT
	6x4Gm/Qcmez11F7z51KO/mpCgXWRG73ASqdkFw0wpDFFKFZwyG/F1TYnD6rxCAiU
	WgYeMYNbXzoAc6KJivwCYr3sPyYp18gHlBwICoF/xOspGUmqsuUA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crqdw000y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:21:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627FoJqs014751;
	Sat, 7 Mar 2026 16:20:59 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012050.outbound.protection.outlook.com [52.101.43.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbebkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:20:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V8eIoPSquQ2V+dgzYuiuF9xgy+shXggwGm/uMj605YGygwpUfG/M+x36NPkwWLH+bAxlCC5K4sFALTyCqqCd7444BV7w8B9q2r2bWANGSU4TVeSv3/ilZWhlooEPSXDQBfolwGYrBGPFvJMsZYtdhMBzDLJiLLZA3NavxrIX3vbo76UgyBfu7lLit9IvKil19krF3tu/WUNmqZa3zi3qtN20BSgVS1rJjKmqDrCQah2rcvQZqyYymQ5epzZ1jDgX7UWDcdop3X+O2uwk0MbNm+5T9oFIx4sCdC1RAgmDeheTSIRnmUTPqUF6DmOBLADgPgY8nwVIT7E8dNyz0EvM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GekdmyMFfhRuvRGFVl2qhXVDnjc8aNR7+FKXVeHhjq8=;
 b=aVdM26IRptOUsYQwpwDWCMwyQ6zz0zmJ+Ivd12kBU0eJAOOaajE6oD99NNIXVa4Is9BghHHzGscJUnnBMRzrPT+lrcYwGscRVIwqdoo/nX+is/g64c2PlwSAb7N/9aQktVciw3yaPN3L6Xa63WXyYO9s6xVERtVecl4KoWeQCqlGLkGElklSJvCzTiNWf4ex4RvgrjlDFE0ty6jOTQR5sdJWLaaeZuRTgEeOa3pFRgQtiYa7vnXQ4FmvSNrP2l6yN9wkXANWKJ65Ffo3iP4DjmvHWfSl76OL8b/iB7qmX3jvrcH2lT98UYy4LsxNfpfumd1CsIPwySz+HNI467v57w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GekdmyMFfhRuvRGFVl2qhXVDnjc8aNR7+FKXVeHhjq8=;
 b=JNZkY0bWziGnq6bkLMrRcVMVu7wCNxuuJUpQFPf+v57HlsIn4CSvmqC8g6j89sNLdlR5ffrN8KJlR24Xr1jB0jkE6WZHItWXsh8AS/anjNtOmSeTtYZ1ji6Pbu7PbDV4YQqwvNzFlDOEc6H9eu06H5DFOtjM/Pa2f4So2DjDgVw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF109C7C399.namprd10.prod.outlook.com (2603:10b6:f:fc00::d0a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Sat, 7 Mar
 2026 16:20:50 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 16:20:49 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yangxingui@h-partners.com>, <linuxarm@huawei.com>,
        <prime.zeng@huawei.com>, <liyihang9@h-partners.com>,
        <liuyonglong@huawei.com>
Subject: Re: [RESEND PATCH 0/2] Clean up the hisi_sas driver source code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260305064700.116033-1-liyihang9@huawei.com> (Yihang Li's
	message of "Thu, 5 Mar 2026 14:46:58 +0800")
Organization: Oracle Corporation
Message-ID: <yq1fr6bwqzv.fsf@ca-mkp.ca.oracle.com>
References: <20260305064700.116033-1-liyihang9@huawei.com>
Date: Sat, 07 Mar 2026 11:20:48 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0422.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF109C7C399:EE_
X-MS-Office365-Filtering-Correlation-Id: ea71798b-e9e5-4048-631d-08de7c657ee7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	8utDw5XJrEyfNNdt7fpxXG8ftDZM2Uzx1U2GT3Stx5u1J7YV9aSX5HJtJje6tsnMsSVYknsfpPuOC+2G57RyljMNxtmgmI28VfUM9nYjWMHC/0RPFKUDq73mYin0iBYPqCV9yj0PVSftqefdcBMBO27WY8cKmwk+LAEzbW7LSO8ZCRygHH/MY4DRerupFXtkv6KB+ny8I5LlqmTQuHuIgGx6ugQb3+r3Dd9chM5/pZL0//l8samh8G4nuR3+kkQW3pd0jeMyfAxGIVzdfmppSOi22L4tlv98CJUwobNc76lYx81chCRYgg/FbQ9K4TxCmygBYp25QEI8Telaz9+FXo/QmtFm6mft9ikSmThzXEx4G3g5ZB1UHxVFIpSp+wTT/0M8+YBYkAWs+pDFU4obqlllCzMPzOpCNmJVi0QNpLzy7mesJcYzyCsM+diI0AACYWGO3gY+vP7C6DV7Qh+wemNP9+apdyg4wBgvFBU3s55VtBLEJczUvWPKNg3sYubLzUSKy1/2/A3qe/9kkXCijgOdYDBBjyBj5dM66FgOgHX5dBAisALvMbgPDPEHs0CcdstPv2yuwoGAyWQQ8dk1NiDXqKANXdqSTv97Z0GhNEKILe8R1F6bgyON7UwaBxIJc5LhExwuCxEKQPdJ+TUH89zrjlb8PV/NRPjOmeXwFi8z6+n6buHsf96vKpDJSjXZurQRJ5nAfAiqfkBtN0JD90ylbdQzRn2ybyp92LpvIIE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7ahSExGpsrwhV4ga1pJ+92cNyK8YzRGPKlWKh1WvwfFV0T9ddfkhnioKQJqA?=
 =?us-ascii?Q?clKrrxwyZQ+M5HpxPsiJfzxReEfzsbxZ29rRnPfsBElrKrnM0Hl/CMJL/APU?=
 =?us-ascii?Q?jpAIAFwUGVlZsoGakOtOZgTpp9g9VKVvoCO9ByOTRNKgBMJddOzWrrFWWAoy?=
 =?us-ascii?Q?OnlixGy+CQWfCUf2CCqj9WC5uJVSDNF2MWDmz4aqUh5+c8OtPEjdMoJGzjLf?=
 =?us-ascii?Q?UV2mKtoX9+ea4gDGtXGjroYDVTRSv9QoxAjH232IjAcvAhQm8NpbvnbX+FKG?=
 =?us-ascii?Q?GPL8q7D+vuq/Pv2cc7rwHkYU1AkXt2pNB4HPYp7f7QYpNoyp8ZouZBN3vnLb?=
 =?us-ascii?Q?Jjc/bgfpwR3gzHuFMzT5DQGFFEE6YGaamcgzN4ONJP1QcWkqu+xblFIb2rEK?=
 =?us-ascii?Q?Lq9Wzr+zx94B1i10Dafo1OlP7ecf+eVrop1xKRtq2xwki5dAOBxz+COBwLmL?=
 =?us-ascii?Q?84Npq6h2phXUut6S1aF+zL/XmTpUODFjp+7010zUouVoWvypSnUB0VUI3yV/?=
 =?us-ascii?Q?jH/fqnGtfnjl7A3zjsksJDANxSFj8cJFQtGWlCTEnpzpgJpWcpnu2vNEFGux?=
 =?us-ascii?Q?XHsXa7OTA9AOU94Zsyb4NZ71jVHow+BaGPSaLPgI1kJiBOk2S54h/i81E4H8?=
 =?us-ascii?Q?9vmQQHz1S4j9wpBhDOBGyR1vYnJsqcQpnIJwiQXDmb7HKxNjuDSjkwQ96z30?=
 =?us-ascii?Q?uT8SvNbTOAyG8lc/1IZHbwl3/JTjB+zliMnrqKgex4NwPSY1nkC6irjJbDzS?=
 =?us-ascii?Q?0YQLMBkjMgB8GQqmHtAYN9LJraKyJxlrbh37HCqF6JHmABHaOqLAoaUODyLk?=
 =?us-ascii?Q?dFumQncH8OAkJLivvPqATC0W2DknOJx3uJHkUjJ/sahVBdMaW+yHyQbv8BGH?=
 =?us-ascii?Q?PZrquPdRuDwVN5mMEAkb2F6oXL5nxKuNgnToPoTgXBCuF/Wy/FIex5AGVMX5?=
 =?us-ascii?Q?CpA+LBrxnPkC5mDViQnW8sUZ2R0JHPrzeCmH52Kzis5hXhBBLsCh9Yi+6Kyi?=
 =?us-ascii?Q?WvA9QTpxaOgRODPbiVUQgISVwWNWWNSGOkO6HBiCD/6/w4WcRdQoXkmaIg+O?=
 =?us-ascii?Q?Xa1TU33nqNJfyDzFT9/rhG4z+UlXDjro/Rr01a6ypiVHT8jHN7ENspgrlfgt?=
 =?us-ascii?Q?hkoegsq0bIadleSWPnbMXysLTUH9ZHLCbCpokm8XL4X1G7LqwuCyJJuXcuds?=
 =?us-ascii?Q?YSHNJtEF6+JBuGOoyE3BIhdjeC2JBIdiNfI59V7zL1VP6B4hEJ3dQ1adbwLo?=
 =?us-ascii?Q?nJRG/3ECePDZw7tCFTbMlyHjL4Cx3bkEznFZLGJ45Zpp4d6EjXCmr2SF3uhT?=
 =?us-ascii?Q?xwp62kZ7GXEn53+LRQNbIbdDGolSAyXRxJwVAkmjIxqu53a07jLpm2tj0hYW?=
 =?us-ascii?Q?tLc8mVYaM3uV7qMmnUbqFhV8ksSdkUztxAqBtMNoe6jjNuBNdSDcCA+C9bRt?=
 =?us-ascii?Q?ha8fXoU2iQKa6CujiLkDZZGdAYCvzv4QqhOEX5x3Wn3aq+78/SuqXT6yOlsA?=
 =?us-ascii?Q?GD1VTLpCn8sGiywXwFrwKPe0Mj60/RCe6IvHjvOfzWpYlurfmL7avDuOTCLe?=
 =?us-ascii?Q?x3CHgvGge3bQzwsNII4BCiG9fLw8zS2P29fgySzeCGoqsXtwf9eHK/NUXvTr?=
 =?us-ascii?Q?dSyl9fdc29FLBCB8M37irwbvzM6+JOquLasDlHOgleLFqFd05O8NCjRJEsjX?=
 =?us-ascii?Q?UwTGfa6RaJprD0i+5+nfBt6QDG8bX+wsoA8AS7ljoTLU/0BBlhz/JQknF6Ll?=
 =?us-ascii?Q?+ms+4Rgre2oMNlch9sGo3hPl8Y48DPA=3D?=
X-Exchange-RoutingPolicyChecked:
	ihV7+lVR09THrnK+N5gbRv/1lDOsFejz6fCQiNh1XPrlIk7OACmvJYAr4/BovxD+JVKvnSYX1NO3ZUQfnjI2EYhVBwS9ktUthX10qi9z2yFSZ8Yd+q6aRWaKWH2aQ0CIUrjmUyIablaX1YH5+3Rk1n69nvXoSDkYwfd2u+xCEJcewPSHtn/EzihWbaKNT0irNBn/ufzRb2X0xqINlPZmyvmNprEhSni3zxMAX5jYZ8MNOQYVeZvI4PiNOsatU+hKcOyNq1jyTH/x59SavwY+Y0vGSB9ShS/D0hIrdDYcjTVgx60hVBpDk6Q/pdGnBYwsWiwBH5QqkMaOmLiIEJsk3w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UMNap7Esu2jmDvtKBbKg5Mu1ABPUxA15oFUhfsWxOmLlGspZksgdA9512rpqA0a60pzKinrUzNP0DTIyI4BCV3VMW16jmPRyb4FbCM69Djq/P/5OJhkZp/jzYNcrm6X5IisPcP3l3EPxzU4GpwL+AsZv3ALC0YRx+P8OQ+ZchZVwtXuVB+YEGOifCah3UH2RHFZPJfosbbta8ehFZguI4zEtyX0gdYPFfvR1sLXykXbCQgUu05ThpHRqWtM04W9lSM6zPFvH6M1M62PQ7cfRazqWZ7dMTVZHazGwwt3dsIFvEe9gm2xPglvUzDE+EUSLVV1MnoGc7BzZ+0YcCw921GhYYz/oCMLyqUZE4TSkGCdURA8EdH41imwe1edjWTSSoCGjaRLC7rFJC2UqLXj6HDh8yUJIqEKxLn0/IICEoFGa89GM5O7f+hQjhFefmWpyQ7t1rZdHh36VwOLkvraOop3Ruao2+cDv0XiZbCf6pZu7hIIu1PfPr7jHKGRC77zTuNS54LRlFp4ZnYkyvVMTWf1v1XIszY18vpihrxQ5ZXCFMIR+uFYTnhjcKO4VUxln7TPrHe4cRh5NOmIj7N6PKfmBbIe2Y0rlUg+g35jC6Rw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea71798b-e9e5-4048-631d-08de7c657ee7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 16:20:49.7183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnDJdRZUwpx5Jc59JfPuduNZc/Ue1w/0xDABWhevtdnGA/JtafMv18R0VEiADte5X4JcX0mH68TvpFQhQfPzGJSjT9dCGU8D5WiRVfxHV7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF109C7C399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=523 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE1NCBTYWx0ZWRfX+N0ceQDv4MYs
 coYb4ygH2lWpUqO7DzRe3YMM7r25p5gVY/uiIEwMqv5D7f+g4MRaGshY1fd30u9NCQsL4dxh751
 HpLhuuluTFN1se35oDlgRXHyOqs4tJaFXR2j3ZGVNN4t3g589d1KjVqd+ypfk7nMA9Kvm43U8L7
 IuXAn4huC/3xvfjej+xVMXHoIZMH3MFXusw4Dn5wsyR/AO8GYPqz24Kginyfp1yw5JmE/J0Bk2g
 IzLAOtVw14N0P9jST2S7h68PgmesCY/9v/bbZ7HmNMwiXdXTxozcc3EkW4+NuNH6BIO+pZ29V7P
 YCQxblfSPTjAgCKuFfFWTXAjJB1Z823t7KAk4yTb23rTl+GTM3pmFdwZ1dp47p8er607dhv+l4n
 XMGCWqUw9kLh3P1A350RigdaUlWD63qMRkHIaf59K3mH0JFCOQdVpNnNdu6qRCjJlBXj+YJpvkb
 Q4Qw8+vR1rsQgxDhv3OO7feY4b4itkxHCugYaaB4=
X-Authority-Analysis: v=2.4 cv=ctqWUl4i c=1 sm=1 tr=0 ts=69ac506c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=nlWIzMlcSzFcEpfx2W0A:9 cc=ntf awl=host:12267
X-Proofpoint-ORIG-GUID: joYDzmSlvgQ6U77_czQj_7OOz7Epln8J
X-Proofpoint-GUID: joYDzmSlvgQ6U77_czQj_7OOz7Epln8J


Yihang,

> This series mainly consists of some minor cleanups, printing format
> issue and risk of overflow in bitwise logical. No functional changes
> overall.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
