Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392C4249E6
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 19:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705520814; cv=fail; b=f2r3HeOXo1JUgm3XoDtUKOs+OaKMcDzU8mLzlLOeaoYjFKzVeuoNA+Dg2/sDIWI8v6usjxkliOi9J0VBRa38okVJXx8zkS8VU0Pbqg7sQndFdz6MK3rePGn4HRNtZ10sBWu6DIalseYSpEzuWeLy+d199KpPjv6hzk7i2J6XhO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705520814; c=relaxed/simple;
	bh=ua+ivaSpZqY0hUHAKyEV1pqJAJYIOZGL2OsdoVcnidY=;
	h=Received:DKIM-Signature:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:DKIM-Signature:
	 Received:Received:To:Cc:Subject:From:Organization:Message-ID:
	 References:Date:In-Reply-To:Content-Type:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID; b=T3YIN8QLv/Ap3ES06tJChe4r4iUI0lSDm9emiDJlA6oCDLG4eVmkncR8iompwSVzUF2+GBnr7IZrhJCjwsjQbIt9uWM4R1vFvN4oJZlneYx5CzMemwYvkiSHS8GdGG3l/Jf2ggJD47E54oXiDEYzjtBVb0ZFUnCl3xvll+lSURc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m0t2Npz9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jwnWvaJe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m0t2Npz9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jwnWvaJe"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40HJcsNF023615;
	Wed, 17 Jan 2024 19:46:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=Ub9QUYFA6xB9pMO/Z27eINsKDM0FOl9IxvtqTTTzUPc=;
 b=m0t2Npz9ieAd7t2zUIh+Ri2ymZXcUKUG4O6RpPEQAtFNf4fKgGvAIgCFLNqejIzgLFp6
 LdGiNL9TCwEYHuyhF1Gvw9S4a/ogS+D3YPa7F0sNJz68yaPFHpatynnR/lMTmrblnbxf
 3w0x+tenP4bw9k0r1b9kK1ubMKTCuR4WGcCXgqR0iS+kAGb3aJgQNSLwLHrqyLPXXGMQ
 OuVKhSqrwYea/DvgKImxHEnEtewKtJbLsBScEcihyJFoU808+IQwWAKdu6uu5Mc1RBiT
 8XL+Yy5PIi8sGnFV/KtmMiYFRhQ0t0x6a7APuPbjF9BLLeiRXzyRcr7hzncm4aQTDyQd kA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vkqce0emx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jan 2024 19:46:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40HILrCG004524;
	Wed, 17 Jan 2024 19:46:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vkgyh0x2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jan 2024 19:46:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLDVnSTvN1h/FaMzQstipSarEVSiTJGZpPsJVLSkcp1X0aJdjD2S5/HTBZcLtlEZDpIyizJXDP/PktMCPGWgUpJJkJEk09i1EGLNGL5y895IqtX3avUYnnh5WC4vNoC6S0dg3lbq8aS2wF1v8d14vL+DbJDeocHiXCaAYSuquBijBTy9AZSK96UNAYv4/IZL5KQH3NF71XAs6XKb3XLP+PEArjGMmDfBpsqXq3UQQX5GzMiqEzwuVC2Y3BWFFOw3hbz5aSt4KF39dQGfzKWdqeUsG964tsgB9KDJyWdJshlqzdz2YfXiYa00+zG9EchMtTehe6SRubz+UhFu/FP/Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ub9QUYFA6xB9pMO/Z27eINsKDM0FOl9IxvtqTTTzUPc=;
 b=lw/oBqpfpDXexAzROIdSpuiWbwut7+a+v6JUfElF1Z4RPFfo7GEdzQx5qGwfgEJaAiy7K77pNv3Y/rHLpRPDNFGJLThbiAHdwLBB+4edUN9+6h93M7DaxD+UhDaMo1oCKAe/dxRD8m9yRmo8Cv68G2VXN2W6xfsJpzih897XVkN4lcW+fUVxkl54YXEJcqPWygHLEjg/4YgZcloAidhWn78MXHHDOfDl1GjRW4TuMC83GCAmLTixPjb0pIP6ejII3laz56CtZqAdk0iCyF6X4jqGI+u9btz5VpLZOVkQr4v57+AdTL9OAVvahnrIxyIaBHUq/ejdWi2gXBmgz08qhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ub9QUYFA6xB9pMO/Z27eINsKDM0FOl9IxvtqTTTzUPc=;
 b=jwnWvaJeiBZLIb07vjtX6wUcfqelLKJLEFH7Mi4dLfPGJIocc2ZkQOqvTwTdqVk0EgB3Fh7w7KtvjpcMcK/UiFF9HmwfUBaKcmXcBuVcn+zhHcjDEVF/Fs9uIxX3A6dA9jxrUhIiirK8i6AuKKYxbe+sNGSOkXiFp4bK6q9yo9c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7432.namprd10.prod.outlook.com (2603:10b6:8:155::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Wed, 17 Jan
 2024 19:46:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7202.020; Wed, 17 Jan 2024
 19:46:40 +0000
To: Li RongQing <lirongqing@baidu.com>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        virtualization@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] virtio_scsi: remove duplicate check if queue is broken
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17ck73fqj.fsf@ca-mkp.ca.oracle.com>
References: <20240116045836.12475-1-lirongqing@baidu.com>
Date: Wed, 17 Jan 2024 14:46:37 -0500
In-Reply-To: <20240116045836.12475-1-lirongqing@baidu.com> (Li RongQing's
	message of "Tue, 16 Jan 2024 12:58:36 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0359.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7432:EE_
X-MS-Office365-Filtering-Correlation-Id: b247309f-ed5d-4c23-9a5a-08dc179505ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	u0SzdfDzIJ7EN1omQr09CIMSma5Uod1uKjj5EfQO/X88/LsRwnVVv+JuxJOgbkdjzeiH1IE4wSN3DF/HSirugCWps4Jl1ABQbyzTbdVGniIaQPmzAfTouW5ErFN7ZPojE13YKu9b5SIZ/+v4RLud2BEpwBUXWj1l00oy10tOLOO9mbg4aYeXFt2dF3JOBvdt5w8QQQhNZfZ4IE0+FVWlNb4qtmHZdAahuP6RnLLncjhR+q/XPc0XfOK17gEWn5QYI3mT7ZoFECOwBTfpVLZP04Xb1/Qu8BbmgsWvXnkx3czOaJEskZGKAsuuUa1I27lOVg7aJYZ2zxejYXBuKwT9vN0Po2EygDsdRoWFky5YhZ+sC0uHdU8Zuq6QWpe2TE+jGr3OVYhnfkD8RRkiveb+0wILZaAJbAIZ7llc375sR7aaIKlVFf+sm7mM9XE5upr+eG/8O6yprCERUnwIhRM0brhL4gkTp1T/HuBLlmobEKPWLFD4V8IXiMklclEy3qbjyr/8Cs6glVZiU1XWGRR3XKU8mkTockboz9k8JYPuq4YWto9OKslUGiLwfO+4x1mw
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(26005)(6666004)(36916002)(86362001)(558084003)(6506007)(5660300002)(4326008)(8676002)(6512007)(38100700002)(6916009)(66556008)(66946007)(316002)(66476007)(8936002)(41300700001)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?dzmbdjxmhGBOAoeOrFNd3X4P+WGNK7tZS/tPtYnB0bYmj8hR9Cc1tcpYf7n7?=
 =?us-ascii?Q?nXeIIEbFHHrn/8eIAtVI8qznV0Rvq9k+t/Pyc8eIylIJldKRrq4iIaZxsToi?=
 =?us-ascii?Q?fMJn54Q0o/bOCPuuAovLPGLzOQIi6rLWeUswbaNxwVqwnVR5p3D5+Jy42e45?=
 =?us-ascii?Q?f1ycQ7j9JaLzmJpBOWFYE3wcZm+dLJu+yNjnXyVN2WfgCDeaMHv1l9m36NAX?=
 =?us-ascii?Q?yWob/bth4mQvQ99LbMA0bnITlyDKFXHgam+73MYXXvztVOnqgO/Yh4oo2CZS?=
 =?us-ascii?Q?0wcGnyB5BQ4fjf3VEZCfeJFAIT0nX0GiDBvcsnyT/PEr3Ou9SzWUHl3XmlyQ?=
 =?us-ascii?Q?K8d1R4l9v8d2erPbNlZS/Tg+HM4N4zsuxHXLoK63Oz3VK1QyZLmvAOUBNWy1?=
 =?us-ascii?Q?h5R+Fl7jSDl1ZNmNh6z3LiZ5K56jVHDjBkVhuJ2EKMefF3Jf6tvTwEBtpPcH?=
 =?us-ascii?Q?JgynzHMjC0a/HFJb9t/X6jjCO3FiqyRFcQFDY98chggHzximcQpRwX9HDYux?=
 =?us-ascii?Q?UwMbIRFxUnjfuQAgVtJCw1HKYaCOIqtbylAwygr97ypsG5+7b6RsRcna0G8t?=
 =?us-ascii?Q?9yQ7DwplugvAioAg8SDo+XYpudjUA099Og4t+VOgP7wuXzpddgvjamfdDT/N?=
 =?us-ascii?Q?BjQpW09OL1ZqMkpWEHV9ssZ0j3DqqBTJLPRfk3CiBrU3V4b2pShRPM0HL+/m?=
 =?us-ascii?Q?wRgAdJJG0bHwbqmzo0Ku9hc8kCxDbVSDiMhqdOHjlowSbJLrbbFbbVAdkZkQ?=
 =?us-ascii?Q?cnTv5UkEjanE4tUwVqekJb8cARgG30Lmv8IEAXA8yiCzEHggSi7E+BE1/yJS?=
 =?us-ascii?Q?5nL4xxqPknwEveFGmtxXlArrR6x28I2jpP96HfJa2q0tb/YLgGSQzIZ+bL39?=
 =?us-ascii?Q?JMVpxOLYlXpYxXn0WiqDL7Fc23CGiy1AtZGmAZCUgD9eMGh2dfbOoMr7Us5k?=
 =?us-ascii?Q?t8OnH6ik2Z/Tbi/0g/RyJClkeYB/U57F1akapFSnAquW7AOHEbL/0lNb5KRe?=
 =?us-ascii?Q?Jlw2u0TVYqvAMaT750KqjuBEHYFauJSqxV0gU6NeT29szysASXdEqrdRFjVq?=
 =?us-ascii?Q?7ih/WBjNuWs13eg9di2QhLzF2mD22RKw8qOFjBbHJ779Ka5zDStAq3AzDbHm?=
 =?us-ascii?Q?OSm5iDNpBIWM6HIECFqHUj8UqEAzbVo0xJXHMyaQHcCYZaYuzUSR6RHdIvpd?=
 =?us-ascii?Q?sLxzzb+BY/74ksGSR+UtHn5SSkqufyC/xng3Y+GHkjK2fEuATZS2W/yNYXXb?=
 =?us-ascii?Q?wP/6c09CsGG3gPHu8qCZocFibpmCThKv3cYvQtu5fMrLUGnuM3Iqnm2STACL?=
 =?us-ascii?Q?QQkq7DW2KqpLSlYPpKBSDmUk81n7N7F5JhkDqxdLdY19Nm6rv9wjVHqHahAr?=
 =?us-ascii?Q?R/8aLJwPOlUxSjB8oMlht0kcZM5jNksncXijHQ6n3mrv12e01KiWXR8m85Uv?=
 =?us-ascii?Q?RR2aFPpcIsHATQ4JZqAIVZUQ4PjpA/dbLm0igNFxAFhNMnWVKNxH2J7X7rQz?=
 =?us-ascii?Q?47cqO8eJl4qHwAbIC8SFsW5orHCgAhiAWSkcSDCKdt2Sl/8BjrFklAzW991o?=
 =?us-ascii?Q?Uu3r/M8ZqXpBNo16d5TrRrxk9W5+qwfNlfpMxFkBx3mHvOyBItVfYG4TSjSL?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	EYwtoCgemyWtTvCuug223weUl3ukSzmeQrhNfXoe3LPbAUj/q5AlSEW9mT2mPDBQlNwzFj+IZCGDfQXfozgcV3lPaJOgz088o6QTL3V9ZjQf92U7iODXI3fzAmxIDJvLUHPXKbD4DOAKHzvH/lHB9EeYm/QPzMXwGSu1eM1Uu9Lt7NpsHXwOkUCbMCAlH1mDXGvRX+IOu31yx/ypkBk56F9Ccx0lAaYe8VcUG5H4BgOd7p9+QXXnb9/6UtmPCroim3BQpKlPQ2jKx/UDVCO6BLGw2M0TJR0IVqdiNJrdwMMJgvHCbx/dKw3CvHn+JrVLJPTQTYFgqOp2Z/dnhtfHUJ4NQ8rzCrd0iWyGCcFRGX5YZGyB3ZCAL9y/AEhcXsLe1h/r9Y5w0ItVx5a7DhcNQ6OEDM9lWZ1J/ImnJrctNpzat6EWSn8a+/64muFaorlTapFkTlCX1Oy0P2/KBFpbWzkQD3NfQ7e+7ctLh0hCTQ6NftWGmwYFCbPbPcaT/Ca9bF5MHdkT2cL9MQuBoy8gWA02WezZ7Kf/EITNYcq0CnFAuabHRnrvnm8NnDIuJByVBp5vKoYe/08APn6J9KtVaK/FGEJdd8AJYCgJIXAYmSQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b247309f-ed5d-4c23-9a5a-08dc179505ff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 19:46:39.9548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkRLok7He2LuaXphM070WV2VQ3E1BAJURVYKxn8aj5qGnbV4raWkJ1/++MskEDKbPbE0/M73ln3a5kRYRp98IIcq1x0/ImTqioHyGIPQYQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7432
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-17_12,2024-01-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=877 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401170143
X-Proofpoint-GUID: cgJnqNxGgrWUi7rotcaFOTLBWISj5eUy
X-Proofpoint-ORIG-GUID: cgJnqNxGgrWUi7rotcaFOTLBWISj5eUy


> virtqueue_enable_cb() will call virtqueue_poll() which will check if
> queue is broken at beginning, so remove the virtqueue_is_broken() call

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
