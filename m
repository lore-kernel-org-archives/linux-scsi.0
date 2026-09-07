Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B21C479885;
	Mon,  7 Sep 2026 10:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778336; cv=fail; b=FapJ86kJpVpV5pHfDmtbQ/7fQzcEP3ku88UwY213AUjL65iIawaQyzWFlmIhh7kCFQPc9ZeJgA2v0HYRifP9KcfkuGQ+jtcIuo+RJ8H31iRCLIKNNGLVHBz7ZnooQ1UVFWIv5r9elyKqdPitg5rAnQWabkGLrCpTcqZ9spH5eEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778336; c=relaxed/simple;
	bh=wwoKCJ9LRSf89BmrQmhRZbwGbyR6enO6v7oxz2XYei8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PCuEIOFBZ3aoJN8WboGeTBdPCFNotiUJRLmATMe5x+IxzrFUH5TSWDWjnPgHrU+5g2fPh8Hn+l09W2ErHhJfXhHBRrMU+GXl9fWGFedDgznCdWwf4eyjSbHbrpbcFPiLkoWCZFEK0GFJ8cGpp4QJEYF65alX3OPDzMUh9BLT0No=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dVDqmFTa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ezc0OirR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dVDqmFTa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ezc0OirR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686NcBq7770254;
	Mon, 7 Sep 2026 10:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hUI8ygZGsNv/lAmmNKIrI995Hl00iMc6nJcndzX0TRo=; b=
	dVDqmFTa91qTngWeKVniX4uQLpNl0wM/Mggo96Lw1smP5TlDVmXtBTZTSVesSnbL
	O24tGm+hSdq08MbgOQIxF73BSKR8PO7Zqq2tB07FUqAR8v6phGsc+uNODAAzhwd3
	g3bCCT+oGCzK6kHZHgJ95AkCoXGej7npBYjGVm06qvJB4I6ZvbfZEKsDzdlGbwu5
	dA/oAuLJrnM9s23hOSj2ndA22rIuoHS6LrHCsxsa9KWqzbjwkLz6FDJeXIKx9fB0
	K3ctdUJ62ovKnMZczQK1vwHByJKQLqjECd2vJUfA4TaMI1DeiF3Aq+IXSHhZYnAC
	R1zfNmlXT5JnklTzK8EaXw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbh09twx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfF019106;
	Mon, 7 Sep 2026 10:51:18 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xNOlR9Nz5Ygufl7vGXJQcajQFRNZEtZP8AMHNDtoCaV3BtioHTd37B5HKutQi+HoHTOc3Tas4+QZYyQX/oaRqFeRoBWxrkeo8xMpsSbkVX2/3M500moz0wtaXQq9AMyZdaiwtow+PketygsbFzEyyfcPXlN6Q6LPfxRjaCg4l7H4+rYh36LbqwVdGQos4jmN/W0ddC8VVbOaiIyO2WhiCYX4B5nPoNc9WwWBA30br1kDctfujgxYEjL0yZf+Fs63c1gy/st0f3bJQpwn4pe6aNa1m+RhM7qWaTZoWzuz8zOjh6y879uB+uMsQ3j4hWXpxWwcGbRTlSYw/0yYXudVUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUI8ygZGsNv/lAmmNKIrI995Hl00iMc6nJcndzX0TRo=;
 b=TP1kkVhu/Vb70zSgt/MhkvOc8TtzQNFqv9ZX9/LP0e3xSDquO1NrDV+K3u2dCKzT3hfsFfJ1dLCgagvL+82KZCg942DJzSwEzvvm0CUTW3adtFiVQvGmDtzI81o70+NL33/ilGlUjOMdDHa/E6B3clw/2ZnyWg9QwoizyIgxT6O9HTw3C7Nf/1zQqEklzy1e9Qa85QLXOxYFblY61vc8AbC1UYB/0CNDMef5Lg+Uhia0s/If2EK1JCT2uZJKLlT1ugC8CWxGMrkzu6m71wfgoTsS/s4WJoFQYVdYoA6+z5AQCKxH0c8BLhpgjyzkonRvuK1Ekvek9Ac+cPR8lp/bJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUI8ygZGsNv/lAmmNKIrI995Hl00iMc6nJcndzX0TRo=;
 b=ezc0OirRQj6sPG6YASh0pragrne4e55r2lsDNowVf8iWuW1o1r3myZZKbmmzDVG4DFc+uet+3EHWefaqQ/djOm5X+86UgOAU6givt9OFiRpGvjMKaZCR4Sf4m1helqa9GIU4EC2lkLGSmOH76wnoM+yFwkLEsdYPP7YeGKa3BRM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:01 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v8 13/27] scsi-multipath: provide sysfs link from to scsi_device
Date: Mon,  7 Sep 2026 10:50:07 +0000
Message-ID: <20260907105021.1763236-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 648a8909-cf1e-4365-7c7b-08df0ccde826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cbA6TtcosDjTItldWBfTv3aHFLAUAsgQ3WNPr8UYgv4n1T7Ou/S2skCs5OP71X5wiVCuqS3z/5Gndnk7XGX2frjQDY5aVed0li+U5P9eLsToQbTqKwsYl3ttGY5igHad9Dk6ithDsBXrAK7KCIsWfi/0EKWze+sZQTlfZu7RqxkNC60r1zMgUszViQyMMljq+WfKp8A9VXzYgjJB2KylApbFAcRyPsqgMxmUPvsyhQCl5KlixDklYVfDVF0ilykrIqxU4RyY/IU1ux6iJ0Ms5fijgkpX9JGal3hH0fVC3tQ2li4vrb1kRp049A4wHX/q772VVDAw61Fa/oUrM6IVLLck/tCTkdn8aX4pmbIIOlzwbqF76alNxeatXpqIbYkPulu5/wFdPtKAStkSvI8pzkkYLd4dThSu5t27lGK0AN4twDMn1xmBgPBX526KMlOSviATePGiuAV+LUhSSTJ3WPhtM8WNmKLv2LUiSfi1FufAGdUs8CvFmAmu0wGLbBqYTgtyouTBtt5u5cV+I0JbRUB7kOw4ERodleepLVeqAW+4DP5Y9WHBaFvvmfKtGv5eUZExHcJU9ZJVUWQRzyJmR1TL9/lt3lBzGTfL0gcQIV6tGeXTb9yU8w8ha8W7FsaWi5VK7+Qz4WRQyvGTir6dRrnzSpQatLj9XVlcX/Eg924=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hxLuPZY5cA1q/BgBRktvUyun4mZlw7q2uQ0aEwRvx3OZrM/v3AoF13eodwxd?=
 =?us-ascii?Q?FRdT8lEgcgVvAnLCmLhUcq411dVa9IcDkwFk4xpPOQMTw3mTOPQ2RWCn30Ww?=
 =?us-ascii?Q?/z5iF6ZlrsodcTT8KfEGvnXxxSDT8R3/O7uJI2+aj4Wk7xQGr7vmURWayqxP?=
 =?us-ascii?Q?Ig8GMYZ0MfQYSgAfuRoOHXBAXxIcmJ3rlxPI2zlDxJvZ1lqhNJLHhHouvUPF?=
 =?us-ascii?Q?3YVXcgfu1ALCI4uNLdYtxvPhTjj7gz2eOREVZ5snaujP5bCeYxosW3k/HqhF?=
 =?us-ascii?Q?EMfRQae62GPr4VmyZ7XYY2CfqJEqwy4KmNjh/nCgGH5DAP1vQtFlgdRFM5kG?=
 =?us-ascii?Q?2Gch+q701x/Qp0dAJ3QuHzfERpH1mm5kElpVKh3miiroY1jLra7AAPsp7Jep?=
 =?us-ascii?Q?fJqvtfR6CNMBTwlO9lm8efY9Jq1h8V45sA/bRhW8TgCKc4SGoAo8ta9m679t?=
 =?us-ascii?Q?wGZCJFqCGifpU2suvlfFxl5HhF66lEcjrJqrJTDTNJBt0Est9fgWPEt6dx6T?=
 =?us-ascii?Q?jfP+615G1KrNlwnNSvK36l4yKcTxNyZ7cRG1UXEau7euRHzbPYrqXyS0Hb62?=
 =?us-ascii?Q?xImh1uxYcmuhIOax5HAL8XnnV0LOmQzhdqdTSBbRf1uNXb0v5nx+e5nl5XAL?=
 =?us-ascii?Q?unhFxOdMJJOkuoyrm8iiSs4YMI2g9cdE2Uv7JdowgHm6V0RW7TC5tDneLRGA?=
 =?us-ascii?Q?ydxS9NVC29gUklH1rijiqoEFhuClkZVHPTpVmgmmbSXEX1poNzwdplXBpevw?=
 =?us-ascii?Q?ipaKE3DW15UGuBoMbi6zXRsooi6dgwF/Gcj4CJVzNF3acCF2bZqwvSxVfC0t?=
 =?us-ascii?Q?Otg8dXmVIHHMGxQbFcQ899r5GrIMkn3UaZh9Ruly7uR8PltJ0O7brpIlni9C?=
 =?us-ascii?Q?HcRoDpVGy3t7ijyII0vT7pV/VK4m09liPzDPSbuu48iW2Bqx+AeHXffbvCIL?=
 =?us-ascii?Q?dMeJG4WNsmfbzi72wBVA1bfA9ErvshFnMtRYX116YeQsgq1ViurcoDmFbYso?=
 =?us-ascii?Q?qYeOYgmG7psBKvbYTaqxqPKVE+FntFR+j754k85hAwTWNHBTGT74Z7FPNyI2?=
 =?us-ascii?Q?lzPA0xI9pnEQWCTUsCbNKsRuHqbEE/RFYgsTmixV4Ai1EbWkOa6aYaEDxJRX?=
 =?us-ascii?Q?AKAelSyIqA7wL8K09IOespMtBxasy3ix9BeRK3BHQYij6lLCY5sBM6AP5pxi?=
 =?us-ascii?Q?XYrmqdMOgZEbb4BQHmV9HAKGzE163W+Rn45QBUB171lI8s5oxnGJb2E848vI?=
 =?us-ascii?Q?sHsr0MHQPg5ZJYXpliC/EKf5mGUySxPT5dQ3if10bar6Du4bw43Ocmnj32Dc?=
 =?us-ascii?Q?p9chOpz+/LGN91IophCCuE/Vl3oii8dsWoQW87ikGPYqpA61yem4aPHO5jYB?=
 =?us-ascii?Q?glU/kDA8sXWznacGGDvwGiq2L05eQ8LXqdvZoJfEWrnYSNj/q9LOjEHhD3LM?=
 =?us-ascii?Q?WyNqbRvDcFDyneNRZDa+SGvNPgvBIWZhxwHNW0ju0YHtrWU++enxpj28HcCL?=
 =?us-ascii?Q?YO27UVQow5S8sZaIl01iXwVPoi0JSQISOEnlIPCrKMMFzEjJmQN5F5TigjJY?=
 =?us-ascii?Q?tXUQ8z7tnAqBkVi4MKeULkf9Ys9V6I9nybX26TUSJ6H3roa+x7OCmAtby3GM?=
 =?us-ascii?Q?6t5LWpOjUClW5CC0/KuRkWSrcKj68FoPwR0Igeiocx1TCyVa+AxETEtIAvBj?=
 =?us-ascii?Q?oFfDXQpG5Fj9FvePjnXK2CbxVscVioFhyHXeGTQ5YIrp30Mv0+v1QvtFNkOm?=
 =?us-ascii?Q?ZCgo152m/Q=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	qsLFE6Z4UEZIgTNU4/gbhSbiO4MdrFmVqPST0Svmpzt8TlyK5A8/8FJ0/4fvZUZUfe1iNLasnra3yBa8A7cwu+noqoSJ13IEYGRSYsGN+VwphOBnLeMzLiXpvoNqqa1wa4i9iTDKgVF2Va9RsAnVTfW1X9WKIROCSlnRLMHwn2BayLvB7fk0QAJY19nuCb/IdjHMDtTxUEXnZOS7Zbk+B1inA59XzhmxyjI1l4/mD3vPm9oyYYCnZZI+uxLEp3ZG7KxUsxrJjRcCRDsqPy/wH40emwLDrLkMfyDKeisC2tvjAaQxumbXPE+eYJktjzO3h9km6JgOu/+mxMSkxR1zlA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m/ngLBTBn7Pd7tE7rva5sFZC5HSEhVuhY1UcslHU+RR7GpbwZUVtIjp+moTrmq/iHaVbiouFZv8Jg6COi1f2SQmpbXPKadNZmBVb5Z2FHEMYUdOANJOZ5lOo06P/opc1gCPDPKrkg4AZF2qXnIqfFYna8kUePV1jLMC8rBrAKqIdNIMLqcjrfiBBbz1pi1bpb1FNWg+X4AHF9ynxyCxoeOnzyHmcY9kPEuatRKRHdFHsX0oWlEdTCKmJzO4P5fNX63ipgUcQTB1V/FWpgYLOb6VdjBR3ANx4HFlWOClybwePxXdwOK+CFmuwujuEho4ysT+JBPPGs/8yu1GlZ7NLgoBXAXc4hYVq9KxJGH9vESUKoggy2tnEs7O3gaeq/Fr3Ot9eHZXKxmD0KQ+gb/HLYbYs+/77iYyu5iGiDemYbWRshpzx5+P334XDdAe9oWh97HpW0Gg5LTMF3NJo7ZnsQU2ihpiacTmVkfneTUD4v3uw0mvl0rZud8y2a5a3c4sYI0Tsgo0tLkiulh+TMn2TL4bINkkqkrjsNoVADwD3DPOlHEsfi3Uxqol+3hbqo0qUicylaJ7cyT75+bYpcbUb1D8NtqtJVsQ0it0/+d2djPk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 648a8909-cf1e-4365-7c7b-08df0ccde826
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:01.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SC+9DrrB81SP9NpKnDUzI4qtqrg1Zov20qewX2368onv0SREDF6xc1U5v234u18KcC0ZBBrNg+lmWjldDaYng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-ORIG-GUID: nTg-_y_J3kwgosF1DBcZ-br8HIptADpN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfXzjAUpN9zMTJx
 AZufuJA6/06E78Hu+RjPtYENDAcl/ZlwJ+5CYOFzfAonWpUW8vkofDwxQhaIi5/dKGvnlOj+Iv6
 0i32rflIpmIOuU1KRMdItiWCO5SRpZlICL2v+qA00AbXMfMiErJt+CokZAl5V42EQ9SEisBYpJa
 8HmM1GBIogmXyUIBfSnnEToDV5hyB2aHDGuNsSnGGISZxzIqwH845Rgnsp8BN6VTzrDhJP4Vhs+
 5rSdIGTPIajcVqmRQgA9i97n8n7kbRJe3uaXBis9rOmYZ/CDZe+MeBscDZAPPz7LtQ8OHxxps18
 FHA8BUAyCep69k1eVPLgosmEd0iMf6NKZePkwhTTth1sr35R2hibS4fPhRbU/ELlArQYZ/ji2Ob
 v63StPFeHoseOxjzZTfvz5aOoNbSDtfleOpyJdt30gnblqTTSfBZqZIsF3jY6VV0kd9oYB8MBKx
 CCKIG2hnYgrXmtchd0w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX08xK0asaGvae
 UDAS4rIsRv9p1zqdL0ZFLDcPG7S4CfWinIlabtzwfgHpZ/r2eFflW67PmeuUVSBd/m1TKrKWrOo
 Yl9Kwl1z4+26BVSFwVtLT4JJOy8ufGTCrQLuEZYa9xtIAkcRpQJm
X-Authority-Analysis: v=2.4 cv=GKE41ONK c=1 sm=1 tr=0 ts=6a9e9726 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=ZbQ-JUxe3OK3M8wTWUQA:9
X-Proofpoint-GUID: nTg-_y_J3kwgosF1DBcZ-br8HIptADpN

From: John Garry <john.garry@linux.dev>

Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.

An example is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 43 +++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c     |  5 ++++
 include/scsi/scsi_multipath.h |  8 +++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 0fd4347725134..1c04947d906ea 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -114,11 +114,54 @@ static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
 }
 DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *scsi_mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= scsi_mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs),
+};
+
 static const struct attribute_group *scsi_mpath_device_groups[] = {
 	&scsi_mpath_device_attrs_group,
+	&scsi_mpath_attr_group,
 	NULL
 };
 
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+	int error;
+
+	error = sysfs_add_link_to_group(&source->kobj, "multipath",
+			&target->kobj, dev_name(target));
+	if (error) {
+		sdev_printk(KERN_INFO, sdev, "Failed to create mpath sysfs link, error=%d\n",
+				    error);
+	}
+}
+
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+
+	sysfs_remove_link_from_group(&source->kobj, "multipath",
+		dev_name(target));
+}
+
 static const struct class scsi_mpath_device_class = {
 	.name = "scsi_mpath_device",
 	.dev_groups = scsi_mpath_device_groups,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5b5de58063857..b5d12b6943968 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1444,6 +1444,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_add_sysfs_link(sdev);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
@@ -1496,6 +1499,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_remove_sysfs_link(sdev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 50d422798d835..d224a15ce9c2a 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -49,6 +49,8 @@ void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -87,5 +89,11 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+}
+static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

