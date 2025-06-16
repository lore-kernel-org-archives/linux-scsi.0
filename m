Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05915204098;
	Mon, 16 Jun 2025 20:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750107019; cv=fail; b=qJtqr4DFbrdth1+qS71L+lAwjShnAcE2ZnHoKV/HVhE0uf2/AKxWnBO/zcOirt4B7/oksaJcWmuwoQ2F2KkR5N4bvhi3o3Bb6dCKuD4K8fNgcpnIBUDzmh9YIi1OHIm0oQ1lSMvVtlwlwc8l45VyTRgFDpS5gZrcdBvltvMEpt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750107019; c=relaxed/simple;
	bh=HxoSqfKhjfLxM7rkdRhEznwNgz16hGYXghrs0wuip1M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=X3+NHxHa9z44EAbcxZgJT8E3n4va5f4k07KCuKKduTJMKH8QGSHncywQaJKzJxRbuMM+cx7rJXsyKEZjuHfOj2QN5G7X9XTfXTshRt+RGGi07FtlJ5UkKovXY/a8hHoPC7aWXqLZ5lx80fs0vkbLQaYXHwPd37N3hBeI+y7gW00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=locjFBNP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ie+bX6pP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="locjFBNP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ie+bX6pP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuS58015723;
	Mon, 16 Jun 2025 20:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=R3XWyahjD6iJNo2aQZ
	FuSrLRg1fyXAYnwiqhm+qDlps=; b=locjFBNPuRt4b7lk7SBn1WlUcYzdM6oFPi
	R0u+xHi8aMqFxzWue1n7iPCOYxOajJ/7+CqwcOPSgd+VuJikWrN8GwcbWKPhhFOx
	rRHJ5v0PrKJhv6JYWVyULHYr6eduC0FbBa1EaYC9PTsuaCpC0X+qYADBIigN6A4O
	AsGVo7StvJ2S6r2DdF1Ag2yZrvuTifL7tzoI/FogqfoNuJyj0wG6enpw6+hK73rc
	XOVV2ad8Hv/AvLW4W04q+sw6LgN2pfE9hTwtCVf+rnhkVuFQEbf+BiO6aY5cYSIb
	YtBL50jphxyVCCNInc2slfx7fOZx9Ouv0JMEzvHuQgU9lBk3Y5zQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yv53uqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 20:49:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GJWUer031022;
	Mon, 16 Jun 2025 20:49:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh85x8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 20:49:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTtya7E9WYzdYfI1uDx1H6ZaeQzm18ig0eHc1W9GyYUV6gSmcOVqsmnIGUh+SgqhscbZqgOMC2FrLYNZbYmJxULazXVFUQgxEqF1YBxrp9Vnkdy/oaG7dOHV6V/+drKIKSE+8qlW4V1zmSCisAm8Pf2cRhTNmPj7inw5Y7mPiOCrEmaAZ4L5AUoCytnxMkZtaG9nEhAjnf8VR31QEUHP1nDFfdZLlroiiQ5Hvt+iqEMP6QHL7iZ118rOaZDCHazifbWIaJzhVZ9k2DpBfv+Q923ZMiyFLWoCevWyaDfAVrs1miJNyoAahKUtfMuOnOwDcpaQh3pIix5wHO0syLxXcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3XWyahjD6iJNo2aQZFuSrLRg1fyXAYnwiqhm+qDlps=;
 b=ppnO9GP0/3zTEbT14NuaoK4r/eGpZFLZhT9hseC+32+5fG13I1puCs3uu02pnshdUEZLRbFC/pQdCjavkQKkPzi8B97sVI1fNqkT4nmBNSEmhr2F/6Nyg2YpLvusf9U70UTx8OL5L4/yhnzH1szM/3SROOfnGpBYFJtHNHaj214kIizFby82Dff+kSnRHadc2jc1TyI8SOgr1qTgI3HkQtv/HDx4ldPdhxNRUUlbEDDR3HztLPKxANPZTT3n79ulTixMGuuy2gWoR+FxP5QWpnVDLZmUA00qWr2YWR4V32kvSHnGH1jGnbhggo8UtRIZJ87H74DXgLB8tTxI71HqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3XWyahjD6iJNo2aQZFuSrLRg1fyXAYnwiqhm+qDlps=;
 b=Ie+bX6pPUZUatVNKYPIkg0T6Agcb/sZLiiO6//W67XlVDXQYOswUP8hgd4V94O4kgs0LtD6ZvwxQtDrVSDc9mRqzqBIFfIxn6Ew382J0sEc5qJz79RuQjpOF9r3fbhbFZt+CRm/SjKrpI7Z00f3BgfGpz8sQ2Mxt6+cmOqH9wJc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB6761.namprd10.prod.outlook.com (2603:10b6:610:146::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 20:49:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 20:49:48 +0000
To: zhengqixing@huaweicloud.com
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Ranjan Kumar
 <ranjan.kumar@broadcom.com>, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
        yangerkun@huawei.com
Subject: Re: [PATCH v2] scsi: mpt3sas: fix uaf in
 _scsih_fw_event_cleanup_queue() during hard reset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <28dbc2.10c5.197529065a2.Coremail.zhengqixing@huaweicloud.com>
	(zhengqixing@huaweicloud.com's message of "Mon, 9 Jun 2025 10:41:24
	+0800 (GMT+08:00)")
Organization: Oracle Corporation
Message-ID: <yq1h60fza56.fsf@ca-mkp.ca.oracle.com>
References: <20250528004935.2000196-1-zhengqixing@huaweicloud.com>
	<28dbc2.10c5.197529065a2.Coremail.zhengqixing@huaweicloud.com>
Date: Mon, 16 Jun 2025 16:49:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: c7261230-db75-4a69-e58f-08ddad17554c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GyxmGreTEYw0O6aBBqWsVWfNTLdVDSF0rQgKUrudcSbeiGppBNeGCl50bV4p?=
 =?us-ascii?Q?soVTtzFSEz0eASiIH7MHC/TsMu29K09b7c1+uUdXQd7p9Axk2jppyh5lse8+?=
 =?us-ascii?Q?I3oPU5ik8fgNb+VAD5s8LmhSWuiatKc5YrYck9ylJH9H0AxiGkWFxiGaV5Xl?=
 =?us-ascii?Q?W1nVsD84JzlyZlr/WX/zdb7mDCjitR5MyRHaMVCgX6KJy/JspV9KionjI/Ef?=
 =?us-ascii?Q?Jm2LrceNMfUOslOJ15YgXQzLQj21XQdjmBc/wGg8e0oo833I68ebUeW1ERVy?=
 =?us-ascii?Q?SOI966V1VMWYaNIYtUPniR06evJnZipMvK6mpaiQgByR/HbadWK3NXMADNU4?=
 =?us-ascii?Q?z7te/maqQ5e6SiVz2MU1N22WLi6ShMYS4Rc5/n32pV3BtGsq7x6eIP6yQo/4?=
 =?us-ascii?Q?lb38uV4QW5iF4yvZEEW5Aurj4+A3qTLHnpIPGMUkF0wy6Z3QrBpb6RyUzZFL?=
 =?us-ascii?Q?PN3UnYU1DtJIGKE4jgOit2VuWdjmnvcMr/FRinrJZg9DN2SAUOwyXXv26YvC?=
 =?us-ascii?Q?B3XuTj74hJkVQa8FIC2PIhAYmsELUlUvCaGfiXCfFs90sEECtZ6RY09jZ8AY?=
 =?us-ascii?Q?imEVfK/QMTSjMv7uii8mLsan/0llXl6crBLA8jx2JnBLQoyfbjW+55JCYJsH?=
 =?us-ascii?Q?/U3P0UrBvUBdb3KZJ6jOxczWEieAgRWYIc0/p45UItg28QqTttl7fTNB6h2g?=
 =?us-ascii?Q?EMBiUAxtDFL87Zf/7pw++M6CtieRVst8owdIsO1UxZuYuzFH6j68uhaGMN+C?=
 =?us-ascii?Q?JEw6zsQp6YdpuJK7nfAcSeY52z9m4oCKaAUBYCQHE7s36Pg0qwJxDtkfhxl4?=
 =?us-ascii?Q?aDjjJZZCDKC0D8kFUsk9dqx7H2FqnXKVnx4OyuP7uvzgqHAu0wENZ6N98obJ?=
 =?us-ascii?Q?uTuaOT/QqoISh09Raf+9yqWGIfh1Lo5ocLK6dqPzkJoO+Aww8fJj5AWRs3JT?=
 =?us-ascii?Q?C2QD5v/QoIw1I2n01MIADyangKYuVWEysSSSTuxbwjrGv68zEgrwZ9ji8uOD?=
 =?us-ascii?Q?1zLCEx7adR0DIi/SU3iUUqSaQ5yX5dOEeCfmTerpljxKaazt6ZRkw1l8NDms?=
 =?us-ascii?Q?itsgo66ImGV4PpdHd6MB+VbeG99JXH4mW/Gpm8+wJOkugltt5+zPqS3denF0?=
 =?us-ascii?Q?jD4EWoaXubR8a5v02EQTfy1K1WhrEhgAjIrx/sWgA1UHW3comErOKnx4K70U?=
 =?us-ascii?Q?0SPaBGseeBUOJYlJaxIbbzRrZwTF7Mo8VRYCOC6RLt8ZgDT9xvqNEgoAU2hn?=
 =?us-ascii?Q?sSdM6zywCvvFHlTcxb3eOHvXLej1oBPtGqwKLRLYwrT2Uk0PpF3p8RY/Cb1A?=
 =?us-ascii?Q?vyWG4aFxZoqD82sUJimEPXk5bufFpBdouri91Plax0aLpA5S0hzEyMfpLUzf?=
 =?us-ascii?Q?JycknUrgF+FL5R7AFZVRMHXQSQv9LoCOngCmjlnIrgd8lS62T4uu7GCe/IeD?=
 =?us-ascii?Q?CphllLVsDHc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MLC12+i9x7OfI6YuglSd4FaUv3coisVepU+PL1QBq3BmIu2eUXzJHVSdlA1b?=
 =?us-ascii?Q?WArzNnlwAwkvir8LOtRdpvBxRTcYxLmnQ68ez6/zH+6AQpQdZ+2jsJhchzl5?=
 =?us-ascii?Q?lZq00Hjfm6SB14EceyeNoxP6achmbR2DrQtnlSVryFSkLsnKlI19Ek7/IiSs?=
 =?us-ascii?Q?0SSK8giJFDzIGaeJp4WMyJbhiILeTqMXfPwxPf6laGflnsN1DW4s7oWauiUD?=
 =?us-ascii?Q?xtvd3YR47f6YkdnFWmF4aNAh7rEoc/V6yX1fG9bytTbbNPsQtXD55rMImEVk?=
 =?us-ascii?Q?4jj6fnWaxxCRV6OX5xgPknE+E+0n/XbRAOcdTdO9X4UexYZkkvQgxIvxwYzP?=
 =?us-ascii?Q?Ag97jrn3u50q7cRlD5Jz1sIWqyhkOtYBLUBrRs1zr6uSB15lQGlYQEaiWj4l?=
 =?us-ascii?Q?rsdYbu5B2l4TTdPpZRnv062VV7LSVzTR31NW/7PFfHe3R5lnmiG2awsYAs4n?=
 =?us-ascii?Q?EwgK6rUYEEV2xIhs9JEyxnqqln4cDys5KNmCWBs3xVjRTkt6QsBIDYrw1Y7o?=
 =?us-ascii?Q?vbdEIjsQVCttVeM8I+V353A9W4VjEtc72UnNNT+xdw5eXJaZIBJkvQItjOn2?=
 =?us-ascii?Q?g6rRdYd0JT9j89rtTKoTow4XcIPQcbn3bNBJcS+6xgk4jEjJM+XVq8SQzl+F?=
 =?us-ascii?Q?cL1dRwWvBzjtOJUNMYACP6b4O0LdMCcMbAImvmxoqO3/E0/pb/6oeKbKc2Xe?=
 =?us-ascii?Q?1cPKb7BLP73pKf4WgwlnjQSi0K+zzmN+3X4y4Ev4T8qNoqSsNRS8+AIMdL5O?=
 =?us-ascii?Q?X8OVfRz9ZyyBu58G57458P+zy0qS3jvcr0S43RAIlFIDtAnReX960NvP4CWh?=
 =?us-ascii?Q?C/GL1I/ePHToPWQ0Dpppemms8Li15TPFBOD93zTkwxbBA3NWp4tIxq1BFpHb?=
 =?us-ascii?Q?qirR52p50gURGnorZd0uH0QBsx/hqy2EtL5+q1LsXBaecMef18pGcimyGdst?=
 =?us-ascii?Q?mE6aaowjyLWSC43b5WgCU4dpjF+sSXveqGIRWMxklq3A9MRoR6lGtxM+3Lsn?=
 =?us-ascii?Q?qtSK4Ms1PtmyrjZS1Z8QkrRFnFkbi7ynsqzvLxL/RgXyPQI4Aa+p9StgoB2I?=
 =?us-ascii?Q?9bsoeNnOyVBIb8f7jCzF7OXYck9Kg0NxliTmXAHh81PYcmeoNnCCt3KRncrN?=
 =?us-ascii?Q?Dhhilt499lyHLV1rpaFpz+BZNzdnVdA3CPm+ZFYUp8/aD866SkXGlfMqsCrA?=
 =?us-ascii?Q?6yv4Rs3a1VDuE6cCI/AUDTb9+EPH5nnR4yXWu/fBRFJXzLnHNoQB3bnZy3x0?=
 =?us-ascii?Q?FKeWYsXsP4RgAyuqhQcUawCMeZeTnfxvaPhKeRMRXLSUiWv8LfThbkxltDOl?=
 =?us-ascii?Q?WX6LBMVhOOyVsHDVW+CKFdBRXJT4cDjU4NclJxdaW6AN5nPr6//wI5dlPOMM?=
 =?us-ascii?Q?bjcppC4mwSQ/4D4d2Rwu+jlbz3ucW/83ge8ScccAyTJVYLzEHoFA27baHmwe?=
 =?us-ascii?Q?PKsTJlwEQx8u/29+tdJ0K2X8MEa76zpccTpU4W/l4NJCLwnSilUjPU3hGL2t?=
 =?us-ascii?Q?0f6m6cTUdhAUF2TnA6zh8GRMXVSH24yq1Eig0BdTQkVQRLof2XdC7miPd8ag?=
 =?us-ascii?Q?zLTPUytToktf0yFXsTOiQO+9fDqriKsT6NUPfCVdwq5ZehnKwLkJ5UgEgaJd?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6kQxs36AOs6koAzd9ZeZOLBQBM8MfYqFid5TDJaJ1+8zn5CCxWO24DDfgydZqChCIxK5GX8PnfwOHL464xs1Z2GpSl1v25hTZrFpKciC9rHUWS7D9VRhfE5q/5vw/HHbROqlQLbHJNbJ9HkVn3B0qwSGeVnPr2TmzSPcOvokPdWLzU6lKBPpTyZNR3CXu3m0/5+7r3K3RKHA0uNQ31HslTwckG9+lODSROdeNXF2TrgMg03gyncxQOiHYbVJqWKysSAUpLcSwFPeB9x301eSM3qHDF3we1A43QxZrHl0DNbyMfnzZc3KVUVV5DZaQrmp5QiU/4BhUrPX5tSAo6OJyXeAXJsKRf2qLWKI2uqXG2Bg/zAWwuQxQsEX8LoiSthHqaMbwaRP0KUj65vRu6YLCona2zoRkOfsnqaFArnELTdGOgk05psQQAchwzWzua9Z/MN2EY0eWkK5b2w7XfOEwgjHC4POI1qP9D3pZOg3nWHi34IGyCWaid1pA5vtOzVO38OEzSS4N5BeSLoyYSHVDKshLWnlST2R7Pp0F1C0MaEacKrVgHLwXo0LTLArYeWdVzOYmkiXrvVySfOnTn+Ifs9HYNC8ItvqI8csZb0isis=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7261230-db75-4a69-e58f-08ddad17554c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 20:49:48.7523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DT2jvhfeZydfQ3IcPUO4KlknB32Y5KpAbzzykCXYZWdsXN4HKYpFUBywL7jf2Rd+AbpF/maVlNLm7tISZK57jXy+AlUbi3jkd3DCglGmx7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6761
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=997 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506160145
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE0NSBTYWx0ZWRfX9R8z7ZWXDJoN eTLQwsPkv6H3Jrg0OWfb/HFOHrBjGLNiQXp5LlIU4L2nPRdgZEAV18sRMkZezTqbyTB4PaY+qbq wboDyH8lyUNcSaC3GFbtZAx+64BJAsfVXhQYABcdkbHNOxljoRh1nn+pI73PXAw8aoGaE0j2gFr
 DsUVveCnoDLFvU9h2lzxHoD/JSUiES2GVISTmlaSRACmapUaz+7+PUy3J+RBDfWxV6BXOuk7ZGb eDxwUzU9ukYmV04d7vrF5Y/v9dP+dUH7DI1e6A8/AVSCqBWOjlqUGAZD/A7XhELcJQaoE5pInrW VYxT3n/xu/etJiqr6a+Kor9yxN/bgHXQzx7RjxeKOK0VxzRH69SRng03ssIC9nSgP65dIogdf/h
 qPgPFc2YOByPiBVWvvXmLooqxO9G2OriYH5aa5JVU1lPHMEnOHt+Dno/spXlk457gbU0A80V
X-Proofpoint-GUID: M9mvGZsgL1L1IyiAHKgYeTbuYIc67EGE
X-Proofpoint-ORIG-GUID: M9mvGZsgL1L1IyiAHKgYeTbuYIc67EGE
X-Authority-Analysis: v=2.4 cv=W9c4VQWk c=1 sm=1 tr=0 ts=68508370 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=Gk4AjVvYMSocsk8ISDEA:9


> Gentle ping on this patch submitted two weeks ago. Could someone
> please take a look when convenient?

Broadcom: Please review!

-- 
Martin K. Petersen
