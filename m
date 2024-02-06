Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C77456B76;
	Tue,  6 Feb 2024 01:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707184560; cv=fail; b=MYeojUgFf0M18bEYZAb6d5D0PZ87vbVJ3LJHtDBEKHCQwBzzgKIdUSzFNiUmspIGSnuOXkc5pHmWbE2E7fBB3dDxlY+zbzyuosvfWX8P6U4FbQv0tq2wcuwaUHROwwil6/OKCJbWDb7a5h7EKCfL0vUTXv1I3nbUF0SiFBY7djk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707184560; c=relaxed/simple;
	bh=BgHCPSzaInh6pRIL9AvOmaa36KjGTdOzwMH7PLZV+JI=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=V5CexKu2zpI49y3qiRg8YggT90i8nIDnLPm0Ipl4/U+wSOOXXB10MHbP/PJDybcpkX/jYfg6dhQuNKc8clyqvkOfnjOPhLuwc/sgrj7cIiaJmCPzw6CCb1zYYLnoHvvpiG1QruFdF0gafsZxT/mSIw+3dYEZ16Au7R6aE/VcLas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I+vtjWpg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rdocjG4F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I+vtjWpg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rdocjG4F"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4161ExBM025516;
	Tue, 6 Feb 2024 01:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=PggX/DKMI1xnIRb3Db3FZUr8L7kJ/kE4xhncgrOqBOc=;
 b=I+vtjWpg/5c7xz0BEzYVoTssdLFX5/0on5TvmWmBuCZ5lkpdQoRw+i6cpVcz5b7rNoUQ
 N6Soecmv/xEQzIlPMaDSvJMvoOy7VETe/5aGmo0hLEK71ehTVeJGNOkxtzjBmRHiKamT
 GSfNxIbW54rROd32tFNTpLMpUuQDit3t15zveWbaxwh0lIPDqshPeiz9+eik2GVkoTcz
 f+auUkfZMUCOuLtM+X8wc9dJ9BWDVS4hScmzne/a77ifogCZlU40FnBj0eWBXu4cZVjR
 vS91+eBMV8eIANe0YBQ22d9wpYrxYOm68V5lPoBgcOfl0nbSLNgNbwq2qRTgg8TCd94N Nw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1e1v5fpt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 01:55:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4161lGdr038420;
	Tue, 6 Feb 2024 01:55:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6m1xc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 01:55:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5opUes0zDTNHcDxCXit3Dqcwg90un71lM236j7jWgysSbjMLamcBwnTDHjU/M/yUuz2sxoyF3TeA+lcyeBisj7pXqyEtbtKnRq2q77kaE+srfGt0PA+8lI2mvtUfXl/sosRny4cuGp2rOzj4XSt1lw7KgHoeYBW2EKWO7Qqhsn8EZ+8BUKsmeDmkvLnKfpdfxWnZCys34sjwXkb0t6qz6bO18ideEW19bemq/bEzDCl+KDEx1mZEVNTdD3RASAMOF+nard6sW3FsRUsNpeV9okqHWaunje+3Xm80Fe0DKV6iULSeV3rjrjTiny2vEiqkZdlMcwIYqWyLLXGb+4GSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PggX/DKMI1xnIRb3Db3FZUr8L7kJ/kE4xhncgrOqBOc=;
 b=m3LEBj+Ae+oEaibaqWiPyij9XSeBBYLqlXQC8DsIbLGbBJ8cBCY+v2bNBFnBPF+5KwyTgTznHmr6TtjtVLRXYxaP6d1DVzw28w8tK/LSPeJQ1YFHRFiXBRmBLTQZHkbySmZ73XeMQuwfEcsELcbQaKsBdCq4sr8iEcmsvW/c1Q4BGuGjbnhx6xEYUUCfjgQ2Djjz7gBAAz9y7u9nKjsz5jTh996k+rsL4+EXAaEWL661XLIziuSPCL5VjxREV1XOSQoDvWUljITGRE/nqyt+Vb2SZ6ZJtmKGcBBD6pbmFSLuxof3+EtUqZLbfri5WDjIthuZfAZb0GidwzlCqSro6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PggX/DKMI1xnIRb3Db3FZUr8L7kJ/kE4xhncgrOqBOc=;
 b=rdocjG4FXHefjGwhnxMzuYzGwH04VIrXOlNkCcQk7Lv34u4jpLMVn32xrvnOxMz1ViYkUy2FYEp09x1eKVe/+LBuJM2UchrT6Xsqzb9dtWUfgGZXhkGf63cQp6s6CEfHwKIqy/h/J9hPS1wKAvICazdQK7vC1Rz4vhHkvhnD/ZQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7406.namprd10.prod.outlook.com (2603:10b6:8:158::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Tue, 6 Feb
 2024 01:55:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 01:55:44 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        dm-devel@lists.linux.dev, Mike Snitzer
 <snitzer@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/26] scsi: sd: Use the block layer zone append emulation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zfwenypi.fsf@ca-mkp.ca.oracle.com>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
	<20240202073104.2418230-12-dlemoal@kernel.org>
Date: Mon, 05 Feb 2024 20:55:39 -0500
In-Reply-To: <20240202073104.2418230-12-dlemoal@kernel.org> (Damien Le Moal's
	message of "Fri, 2 Feb 2024 16:30:49 +0900")
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0168.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7406:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a261055-9b46-498a-d868-08dc26b6bab0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pa/LZ8G18L1+qmjcLYHdW1g9xNMnCc712peHdC94xb0xtwESnc+dnlkgaXTKEdv/bkh9eeAWR86aEHz+aWVXEgi8LHXW9AF7SnkV6X/Z1wGZuXM3Vjh+Sw9FkhHd3hjGtHEzFaG4BkV+A27auqR/my0Yi8ZLXHI2tygBjt0cC/Gjdlu24+n7yETzerLYrsodApGf73EJBXaXTdH76vUtNZuZWL60YAAfOMP+9qufAt4XMuqrPB8C7z469HBOG+rCefvxnzkZ/WqDFZ7HYGSEJNFAYolQTIMsI96/8pcIBmOzlkEyDtQVfOf38rZULtz+3x3hK16G+33QVOFxEdgzD3Yfh5zLouBcET2SDJCciNN+Bu4ODw8g7QUza7PUSXz7OTuU5qcZXjIDpGTHqfttcM0WKRKkXH7jMa7I+I72GHsCbYioyJypgpYaXdnVF04/N+i6KGlCf9PSc12pePi07+cJLY2BcqkbtjTyS96mjhvdf2jzWoRgcjaGny1J8LJGSzW6WIg4YOzNNWHHYuoRevZk88oAlFxaTjmq8vXCo5EpZZ/uBTi1SDBu6niO2DJS
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(39860400002)(396003)(136003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(4744005)(5660300002)(2906002)(41300700001)(86362001)(26005)(38100700002)(83380400001)(6512007)(36916002)(54906003)(6916009)(6666004)(8676002)(478600001)(66476007)(66946007)(6486002)(316002)(4326008)(6506007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XbSzOVF64HiQ8wzEgGYe6HEB0/nQPwg2VTf35JniVygbNTcycpidwmOC8NYw?=
 =?us-ascii?Q?dtycL62TH75dd20XmA7Jy5au9WdhyEh/6mWVrjFkRXZoFWlWB8RAgKbAWJHy?=
 =?us-ascii?Q?5wRtyYooJKBUbEGori5plY2Vp8I/1/+xCA4BmH4WyGW9LVUu/0PvC++YfXJK?=
 =?us-ascii?Q?/uLl2I0jitTg34aqDp0tpmuGnXIS8HpB9c92vVHUj255KHTTerR+Aunj87Ur?=
 =?us-ascii?Q?m7ZW5R5Syq0bp99xqW4Q/kjN0sRFq1q0ZltLsGuNkN5SiADAjSgQSBchDb98?=
 =?us-ascii?Q?g0bSZ2s6cO+bmch3gbXYSvHmcTqxB/6ycdymFEkB7Apk5KxTBKIcSsnw26wn?=
 =?us-ascii?Q?NIhkzL8U7AhLL78hesI+Gcu38BsmAsSY/B5vmV0zKwReV4OUw9oFVhpWavoi?=
 =?us-ascii?Q?sYNXL2Bxh2Vz1kUXvHxDKdG1+xyLMNx4NfF43j3SWpkniDK0GCsPBhrpajT2?=
 =?us-ascii?Q?qrS6lijCanuOuyedgbQO5KIj6tIDsyhMtOVejD8t1gaqWR/5v6Ete6Wzf53O?=
 =?us-ascii?Q?yevBSmmSIwFpuGZWEhlkfHj2lj2MQ+tFXc6zCwWItQTBolI457QNt3fJasuR?=
 =?us-ascii?Q?d2cmDCYQ0rFQP6qto3sJD9tFE2NO6k6Dm4XY64pqy3jVWL/xVwHa4vxcfNSC?=
 =?us-ascii?Q?Bb9W2Y2NfQduubBP+VHoiE959zypPBiatLkW1R+E9OXfRzKFW4JpBn27LeDt?=
 =?us-ascii?Q?zNuCm9EKkYUSX0P9lfTCADpB5SFFTwsrC5vm81rQOC5z7NaRhtQGUPmb7bkd?=
 =?us-ascii?Q?pbOyymzyTGDe17KfpSD8iztmmAAHopnAgFsk3Q4YLixxy1md+4cxk84273fS?=
 =?us-ascii?Q?5RoeQOpX1EGGdGnCCllBfuEBOKth/3H3MciHEwI8H0vkQ4bqbrr6mGnzYY1R?=
 =?us-ascii?Q?ejhLdAckPCgR9xw54dTv3RPgKh1j01Lznn4JJbvtB+WiDZhr6nML9rDn5GdJ?=
 =?us-ascii?Q?aWsFvJC+bHYxpiGcZNkltOQPqo10pSWCh0JAwwFcpUK14xSfEPoSHdOLBkAZ?=
 =?us-ascii?Q?6Gvo1LPr5Yfo1Krk3fBHsytnxVfbUsw8d0zjpyWLowi/i1WbX3ogYeyt+1Bi?=
 =?us-ascii?Q?1AgpHbkZftwEa4haDWoFjWpvP6WA82p7IAxXKCO/GUimtdiUYMSMzM+yWSbJ?=
 =?us-ascii?Q?50tqihQDXbPxRbgXS/NJH1DAG867XJC51dtOkJcgROask/aqg6392frb1uV8?=
 =?us-ascii?Q?mO+i1fb6i7T2IYRqfKgKa2Zaf5jBpcpipLaMJx30DsH0aozw4q2iQCjGrRkh?=
 =?us-ascii?Q?dbkQkCKoZ369P4rga/DrwX43aKM57b5W44CgwHoU7SgPh4iAXIhUZcIKaVgh?=
 =?us-ascii?Q?kudYwk2ZehlUyav4I1Lf59wColC3Q+iGhSGWmIwbDgC0e/Z8wnS44xVaXJ2z?=
 =?us-ascii?Q?BY7iD5c1FxDSI30NU9LvjBe4N2zYvJEfV+8XcOlulUwwlKYbHuxb0MvRf/we?=
 =?us-ascii?Q?j7+tDr2pmHZUT/jVU6TjKYHECAfykWLYSXHnrkOULzSv2jkDLcgGXHsZcZLc?=
 =?us-ascii?Q?0SGhindkVXu5RONntY+gzxLNgdCTmVnM2/E7Qvns8ezlj2HhH4OtYPbgE55A?=
 =?us-ascii?Q?U1szAdrSmjcSu/MtyA5nuQM9sc02C1oZAb0qut7B9MZi/fbUy4+INGwvQs/Y?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Qt/fZ64c06D9jIhpzS7tdDfaZI/YsZQLVrPh1SxNL15z9p4sJchkR2xmpbv3XPUKc9yDiPvs8rDU38zs3/iVmmjDg1S6RguKOFvvvR1A24+/XTtGYpiwbfst8KOP/AJawRVogDMw1PzGnFqaYsMr4WyoTchcvEtxtGGA1E4bArMIjfjyw8w/8t/9MXQwfzzs87KD9fzkgIiTbhrhAqid7p36U3K34Tdz04rl9siIwyH1T4COr4wU19J4LmkpMIE+gUFAuC8LDUBDge10CGmsJVZFYg70l5CiM0YNBByZO2zR/F/koQ4YATN3IDdZKZCh3BLtmInWxPh6TvcjSAY74RG0zOLCPnOqc9qphAYOBUcKN0kqMI4o2zfJhtS0XE2jThjO3k+aiXCMJTp2+x5ym+u7VBydUS9RdLqRwYp+LokDRfzMxd+ojFf8ih5U2MkKJGSNoGbQNzqozvXuTelQ1kt3kmyXNdfylS9oz6/4Asd7ZY4Q6SYibcU5yMpu3LeZxK2YbZ7EKTIYtJwPFOp24/nZo1saPkUfzkcQKr4oweDGf2coul4CbH2xFiVjTiIIP8gjfdXvqX//j6i35Q/BTsxl2TSs5vOMfigEy0uA3kw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a261055-9b46-498a-d868-08dc26b6bab0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 01:55:43.8953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FaOPH8uuL09jrQAXum3J6P00d1Z66pb+s0S2LU4KeGk7zxGKBK/LOxA3ryeoZgpiZtv09k1SwLxGzQglSjK5gXmZPnsKVhC+QO4U214E5sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7406
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_18,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=903 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402060012
X-Proofpoint-GUID: anuy8o1Hazh80x9HWjiLisYnyCbniMSV
X-Proofpoint-ORIG-GUID: anuy8o1Hazh80x9HWjiLisYnyCbniMSV


Damien,

> Set the request queue of a TYPE_ZBC device as needing zone append
> emulation by setting the device queue max_zone_append_sectors limit to
> 0. This enables the block layer generic implementation provided by zone
> write plugging. With this, the sd driver will never see a
> REQ_OP_ZONE_APPEND request and the zone append emulation code
> implemented in sd_zbc.c can be removed.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
