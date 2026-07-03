Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6E93B8BDB;
	Fri,  3 Jul 2026 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075046; cv=fail; b=EzElNfhb0h0rU8Lb62SUSBTijE/w5Un4x7OzR1wzxuSasZ9t05yKPz+tz6Rl026onW7tZPr00zurLad41jFScBKLfgw9XI4+E9UqSiXv8BzjVCUWQpumxGnXWODp/4b89TXG3lG6i90Kva5F7xQhSw6HSGi3YjOS3joMGnqLSAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075046; c=relaxed/simple;
	bh=lNdTN/23x1/l9qvWWuIQbdq2UeHCpS/Qm95hhGbJArY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UQpQB7Vmdlr1tl0ow/4t8oKPa4kDOYhR1lvx+Ew4JlQURiBSyovdQ9sgqgDiSv3T0LuWW0x0EsfV3pyokykQGF5Tfe6EOM9kpc63YqV2vyuIaMwh3gduWRaGOIs+n5SfERGAjV79/6rFDX2hHeFyKmGknt6gNeRSi0igCiz5SfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gkzX7Om1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=frFxCe8J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gkzX7Om1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="frFxCe8J"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfwc3080663;
	Fri, 3 Jul 2026 10:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pXFVOpmhSZKfG1hz3dbZT/xokVM97Y0LZd784cFEuAI=; b=
	gkzX7Om14pPIZcJEJgHCvWDCyKa8fkuvg46CWdoHMs/9Ww9onb08psOys4uvP+d5
	t8m+4CSQqRhymxeIvCAZLScFAGZS6PfwxcH/ZwBR4ZobPGT8m6a4IbByzud+uTDV
	KSBUnKcNgJ0WriOxljaJBAN5rY5ZZob1VwDAa2yP8BTcHs0AKoyiKa+aJh045KxG
	xrYaz4793/RAdi803D4uao6URx5SVt/kwJmucljcndhxDz4/4ww5L+xga2uu/2rb
	mSvK+4WfC2PeVJCEl4wPWV4Pqdm6XggBhFKsNEOnPdLPZp87iLedPJaePKOeDXVF
	2Hzz1MRBWaGxka50Ilwsmw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqaj0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS7JV013101;
	Fri, 3 Jul 2026 10:35:06 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010044.outbound.protection.outlook.com [52.101.56.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvtvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wLZO0BxqDJdXtQgbJUmPJLuRSa+xyzkZLUvPA212q2KU/H2aj/8RFtaAakt6eIlShhdRSNy8dUkVYPD8Fgn3f27h3/x2tHWtneqT8p9r5ve4qmXubsTb7XQ1DxNUvxzNe1R2WXyXSlHcLiNDeNTyRmBcjcSmtSvMDnvAwOpyEhNm7Z3nx5JO6h0s798nOIgQYYDmfMQvp7LK05/TTUGDTj6qrdXLBNh22qqB/+Nr4DuoFLM7Xenm7cIAF2T5DXQBPSOjIgc/3075kzNe1DViCOsvFyruCJc/wOg4ijyMxZApS/EzXcMAbaBKHS32FL87tIZkDVlGWmhqVFZdDgX5sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXFVOpmhSZKfG1hz3dbZT/xokVM97Y0LZd784cFEuAI=;
 b=vGyE6MLFVkLDJX4FidBeNdocualsLurJJ0AE+PVuNvTLW55iSMrhUNcYsIWrUwsoBtZc1ZRo+5OjoIiJZwb7I7HNl+lSNCevHEyLfkrV4wpvZFODXfTfHYSqvYwRbIx/q/sAmx/PiPrqqTajtuTIcU6y4txCY763N5GcgRkSLT6boKki/UXba6J7WXG5ZDkUPFVld3oREZRYiUm/MPlhwVsZ21Kil/N5azHBpHRpNi46Z64mMasyHUH/ucY+A7vtLefDVougBtplS59qHVWP61CwLl74fZkTFhCIH0r+Q570CMNkmrGKhRp18T1sdh4p4rTjPXdY0js7DlGLd9uW2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXFVOpmhSZKfG1hz3dbZT/xokVM97Y0LZd784cFEuAI=;
 b=frFxCe8Jp4ArpsP5FvzzRPucFxhOph6RFeAn9DZpMzXwcfVAy86mobMia4FH+9qfL9vuPBKFVAIjKZ1En5a+fReiMnlk8epJCBA+Sb03qfDw0t4pAhUnEMwi6vQG3ZlkBBPcetg6Ph4H2/0IHdlYv22DObmA5cv1U8z9kjXLWls=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Fri, 3 Jul 2026 10:35:03 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:35:02 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 15/17] scsi: sd: add mpath_dev file
Date: Fri,  3 Jul 2026 10:34:00 +0000
Message-ID: <20260703103402.3725011-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:8:56::25) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f29d0c2-e861-4180-7809-08ded8eebd00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|5023799004|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	j8B+wbymqK6znOqhazqwCfS1kizmuXsBGonPxzP4w1LCjhq2UceWMZL/hALx7IkyM7FfTozYvLuv5A68AvHsjejODP99EUA/Ap+1Rq39vWoN/65GRqY+NAnDgUZYyAblfD35cwvtPIvZXjIi0X2m1ZBFMhBjUygmxsu0menk4hrRjAcTWw4HdvuAOS6sUu/iEz7iJT1j8+msmmJXJ5Llwxv6mY2uYUipkOHCpn7/qfWAa7siq3/B81AD+kXmreGFpTYriMsYeOyLBBCWdBp+F+JEnqAdtI/Ybv81dEK2bIOBAdzkw+tWoUHa/xyIXL5CAM4aG+96/PJ3kg/01fQECw0W3jjinuI6sohDyXNIy4mznj/oGnH3z4iCs9HtESr2AOq4MDpG+EZgXSllRCwXemhJUeSYAD66gKcPw16jSgeRah0I8ZXHpaNzlxkp5Yp0Ue56OXDwvdg4uZiZ5Y8H1I7ZL2As69U0xTOdjLkhPh5UBp8y1KP+xl/tTvWYCMBlgawdz3ibUSuFaKZnIzxrkIM6pKAkfwyEqcSMNZww7Z8YNUpqtFXwT1ai2Ri5K/ZVbbUGylsIxQBESuDTtZ4IisEgON8xUupk2JUcyK4Qj6MEmCMkhoZkxNPjjc3JucEWRRj4E1+I2abGTNjHWzFBzVdy2X2uftgQSoRRACY5cu4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(5023799004)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pseRdNs4YzWVS56rJdSX+qM2Uc6UT8IX2K2hVKxAXHJe76hKkGEZEjl9S4Wj?=
 =?us-ascii?Q?qXb7aKmP85KQFiftNx6yLNaDyXo5FGEveNFWIYqBvLHFjwG1nVO+nTph+Pk4?=
 =?us-ascii?Q?QkX90RA49XIqxe0V4MmiCqI+RKmodC+aF/cibzPrTvPxBfgdk8ZMUEKYjH7f?=
 =?us-ascii?Q?I5S5CkEC8aTvMexeUipGC3x7NIMOoeNgDoE1KdISSM3QUIRd91w/IZryxg+C?=
 =?us-ascii?Q?oQSHzn5MTFJCHLx0HfXPKWal33POoMrNMsgeW5AD0YGukIetcP9qItNohByb?=
 =?us-ascii?Q?Snq8zD3nQFN/DPP+zSGMHfbZWP/RIkcsEMYwDPfCysMVA7kg5cqWFk4HtxHn?=
 =?us-ascii?Q?uM6bSdVutcWtfAGoln3H29u+el4jTtHGCI9EpnYjBWVED0Wb7J/8rQal+P8u?=
 =?us-ascii?Q?X5d44qbaS23fw9n1SwIBhFYjL9hT1MgURzsJ/rCXvxKSl3M7YwJqSuEmXBDC?=
 =?us-ascii?Q?wTSnyVMmc4V1h3+waeRfhNSflBt9JZC3VOrLMV70ZqZiLWcSgNifyHe7Nxxj?=
 =?us-ascii?Q?RdmDiFBjpxzH1NOaOgF87ILODG8TmAquftgkMha0afK76hvOocLES0Y/QNAK?=
 =?us-ascii?Q?0tlHo7GyjYxrIefyAvAv/FToQqF/TCeQjyjr9mkU6hBU84K0/kIeURu7gFua?=
 =?us-ascii?Q?HF91DudbxnTggcYMXDyXpk8PFF9rpBQhE1YE5/YtuaYpfPU2TOv0Ur9WDyvC?=
 =?us-ascii?Q?gMzx3+O9WKy8GosG1yPFLkut/bVijZRZvrnb4lcn/pP80XdzQoONIE6e5BAq?=
 =?us-ascii?Q?ihdmfdnmtJrjCRzB2ICVjI4pzibIfqDgg/qNHz2FhFWkCHry8T31XVf07r/9?=
 =?us-ascii?Q?4aWN9R6CIpQ/fCar9HOhkielYSK08T5QLhfM/Pk4gIOvEKdE7Zjk1qKAX7I4?=
 =?us-ascii?Q?+YTgIrpn/hdHHaqRM8N2M/wT9vJCY1CLZty9kCRauyytgzy2rxiBbgP54nKC?=
 =?us-ascii?Q?BOOgTDkPWSS/yWWdwNO0fKwKMNwHBKsQo7Q3d7oUkUgJl8A1njTU2M2uElDC?=
 =?us-ascii?Q?4CV4TvjEgNLGBiGXWwh1Uyd0zp3t7eCFeq5IULEaiw1By1qmcEB6lRwaK21Z?=
 =?us-ascii?Q?lKbdYMLvGs+4VGRPq0kHXpYd0zNL0D6y85OBUvRvAFMeptzkCjbcXpAV4s6m?=
 =?us-ascii?Q?SisZb9FzdLhRA5Gnq0LU7JSpgiaBi+9h5toJpDeXbGvOuz7W9ygss6ynIj+h?=
 =?us-ascii?Q?rplY7neNjuRiRJm8x0dxPURn/tr4QzNAbcOLJeluP/82adsC12YUAyDrGyPg?=
 =?us-ascii?Q?GdtT3AF3+Ep+gPVwNgaj/qtcA95zBrs+qnQEK2YlNAIigI/KlfIh3L5Ibtse?=
 =?us-ascii?Q?EHfMHLDsTu7H705uxLoG6zRLeM3in1ZXWTl8J9tUAt01QiWGLD87Ol+VBkg9?=
 =?us-ascii?Q?bcawLK1Ha4cS+eoNbOV++hyuQFidBHisxO/eGIuOaTzmKG4TBT33hFvKAx6P?=
 =?us-ascii?Q?0dwGe1jtLzgQ2A43A5yKUaAKC0dRymTzj3x0JaUeF4uC6zPUKWIu6WAA6Npx?=
 =?us-ascii?Q?hOOZznuYkQeQ4iciPAXSa7uMi87e/flRJdI6IgXfqiWugjYSVH1tmwO7e3Bo?=
 =?us-ascii?Q?BwDIA8l0Y1ms2pvqa52Gy9q5WH+fAKejf206Y96cB+CHEKDWwGoUJQGKW2M9?=
 =?us-ascii?Q?6RlzpAWn9p2W9kho9Kiaqz+lLp3Lj9CXihHqW8dIa36R4KOWkVFEQs3WDMxD?=
 =?us-ascii?Q?2XqQCjUr9tzH65M0tKDi4DPcpzL4KNZYqkAOHbJnQVXzZmVssuQCAfU7xY5l?=
 =?us-ascii?Q?49EKteQ7NehTSg/imiabyM31qMElHU0=3D?=
X-Exchange-RoutingPolicyChecked:
	IJjWwFWxYEedhI6uGf254zrX4SfvNN5Rg9KR+uAEQifSw4duHbpa8ozmppFuYFaOiUm3rar7RdSDg7EKkqZMxR9sqecUNb3XUI6UOcR2Fg6buOWN1z/iFYQ9oGlM3/GQPxRt5l0yh0L5agPrtBBTPqx8AS8T6rtESiR0Cbr2MJhypfjc8P09XiLB5gATUS3j3EPj4INvRcglNPSNfT+TQ9W+l7dM9DDJT5G1XvEApzfAOvaJM8EtO6kORlof4Vd9GbhNYBnwBlf4XD8zY8fVlPWvt6/LuKzOcz5Z//1smK46YjIasm/7Mf3yllozUB0idRzk4p0LKpU7EcT58E3vYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5wbfLS3FvUVF6Svv5kfG9jW1vdhMTvRCt+8SBzFZxXiuZhqO8arrSzuVKCKb9pQoLqyTnwO04vCr4NCuRnxMBC1D4dsh+2KMUbqILnlKl5EK4RAfFZEM0J+65JO5Of1TOqiJZ4rJxvhDjv4ApekzmRjc73LVRbgwa0mzGQJB/QSXV0Qb5TLx3s6xD4nWigbnq6k1/rFmAaa+FgzQSmvDHw9xO87V98+y5UvUxsb2lG3OWSg17ZKfk2irRpISGh0CzcyxLacPHJAlZ4UuUyQvOmXrGQa3W+Q3uuc2F9i4uIw6YF3cdbDfuVxL+iZrk32VVByowG5/NaWumxjPUh+IxyMgi+8P6eMC3Wym1JkoHbsFrs7PASF7a2W05vRwOXzVXqHRD6lDJ1n6PerAvn6CGjAu6HNECbepeEIlxdodvyIafTJfhMAGarLQbi1wQ5+9g8Ziwxu8qdNi115w/ExtoDKgQmH8bQvpgaVuPOgzo/sIfnsa71+jFN7QaBHGPZ8D19L2IGxm3+ptUsXI9HKACJqwmpISfgKo6UwIMZB+FKAlUg2CnYVPOx5QCQrjA/diqAowoYnjae7znIIbxJPTHfh+BkoH8KL8RxmADRVVOnc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f29d0c2-e861-4180-7809-08ded8eebd00
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:35:02.5358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0318C8BukxMrh+ttWvntP2Jqwj5UQpzSLkv8JdyMLEoTijF5hJT8paFsQ72Ky4S1EBupDt/UWXL4kG+5mLZJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: Jyktr941kUc26QghomdhdApm73BQlTVE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXzFJCp+j9bKab
 Gjh1vNTmLzBWrV1Cgkjw5qxc9lzctArYzEGO1dqq6KRD4OEBHplT0yIq3D+kpSO4/9wGTe2yNTQ
 CXZ8J9/yZOXFPhx3OabwQBvDLv+0BOaMBCtWQA2AModHC2Fuy4GaJsPAuG6hASC+9yN/34NFBwu
 b+3k1KqnuoNEvIOq+sMfAwmvSkOl8F6pHANg0DuNTPghvQ/Ve0wJY8ON0EFpt3YN9Po1hDmND5p
 XA5NqB/1kymtoiln7CmDx2SchD/y0jH+LivAt9ZMalQXias41A/IlqcWQcQwVi7TkcPQlXpFs02
 gzx9wvksEury7/9JCOlz9gP0ZTngxwAdyOPIdTkoUE0ve+p/CUxM3eUD8qX1H1MxuFeAMUGcniW
 GGOUf4sAfbsC+Mzm1l/52+Su/VHCNrYtkJeAK3JxJKRNjhKVqKekeWl3cIo/vZBuMcTreRye21C
 n2XZXtAWIL1hAqVzO6w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX24M5o3tpob9r
 mAUfiZHE1PCPVoRAiidjB7BN29U4NZumc1rHKNIxeq6qGIgH8ymfKztZmWsLwIkFO8WCTXC/sXb
 zb7Ox08i5uW28Xhb/pNT+A0LgBleB9NY50hWBG00JNSxWLLq4mNj
X-Proofpoint-GUID: Jyktr941kUc26QghomdhdApm73BQlTVE
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a47905b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=A6hY3BpGxKl4tX3xGd0A:9
 a=WmVTiCyuxqgg3mnwYu6p:22

Since per-path gendisk is hidden, we have no

Add a mpath_dev file so that the multipath disk can be looked up from
per-path gendisk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_device is missing.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a9a29e50f5eec..0c77466f8291a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4059,6 +4059,52 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
 
 	return ret;
 }
+
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct device *disk_dev = disk_to_dev(disk);
+
+	return print_dev_t(page, disk_dev->devt);
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
 {
 	if (!get_device(&sd_mpath_disk->dev))
@@ -4375,6 +4421,8 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
 static void sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 /**
  *	sd_probe - called during driver initialization and whenever a
@@ -4523,7 +4571,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.7

