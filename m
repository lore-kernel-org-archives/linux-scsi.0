Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575CF1292EC;
	Fri, 16 Feb 2024 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708096129; cv=fail; b=WglcwooWizeSSOHBAjc69UbOg/vi64r1BWE8ZhavHgyC99ORu1gin3UivozVI+WRs84jz46KWId2aHZU1s01tJIOLeVZhZbOsgCkHuo93O3Ntdlpk+V9aClUYcxMrbSwKlz2niljbz7ZjT0pfuc550Zk9s0VdbXSptr4Vj0ngE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708096129; c=relaxed/simple;
	bh=QGCHkzTAZ6LeL2sOg/nvDCU3uPynIy9npbASf9GuBPY=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=A4oaq71sohOa4d9cp0G1nDIWQZJ77y41VNOMek4a1rBqGhoYLU+7hBpN0zqZP0PFL2R/oj9BesP2lU91YFIynNbjyMzORKyyWnBozUI/a/TFxBSlZl031UVgyK6hmQTmZQLn+zR6DuD06N8+R+Bh8XN/Wl5piKMAYU1yHr+WqSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KoBYQnhe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MamF5Qcp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KoBYQnhe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MamF5Qcp"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41GCidvU020785;
	Fri, 16 Feb 2024 15:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=5gORfLX1clXcEaPuyVnqTw8AszqtOCZMDAs6ep8bmmw=;
 b=KoBYQnheaE2dwLtXMZkqiOuwlJL95VBli+5zT3fE9B+JeVY0rzlORXJJ4vbXjiew6pJs
 O8DQxv82a4dCK+ykwQPt2XAcAZEnIUUQJVwNe2KEyxHmfdfaTPU354xGDMXeqe+gg5n9
 6yp4p+2HDxA5IlGZz2wvt4B3SPzrm5h8XukSGvcYfC9X8woDvKJkMrJRzujfTQ+UPi+B
 pEdVAIC8B6SGEf/LKxt9e5tqO3EKH1XlCvHsg4DbqMIYuWoWKksFdoqCHFLsopjWnfi/
 2olevg/54Ji9lIkddDnUaMN0ZgfKk9pFEXu6Jr9y32EFEKM5r7Ru5qeiEJVsdWVFS9aD IA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92s759ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Feb 2024 15:08:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41GE8dV8031535;
	Fri, 16 Feb 2024 15:08:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykc89kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Feb 2024 15:08:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmUhIr+v9ltPmBMneKMwIBDzhZSp/OETcW6BQEcmutyLT8qMvWysihzQhah46+kWRzj2QbSMWgIsiN8R2/wWcvcqFH6AumsPMqPAirkXUuXqwwKaGnEb35WzRo+gZ7T1+GKH5s0VnQA26/ndy7q5KjOXx0kIpe5ZT8r6AgcWR1AZXnUxUYQAipkZx3J6sFkdC4uqUNtAtje8r7E0po/mra5g7ZKnOlxVGR5v85RiqeKmXeYxLKESVQFhrCHQotWYOJ+wi9+BXgatZKQ4VzJNnVpryJpV8/jFxemQb3Veaofdg3mT3u/hT0OUxgcBkxLE2XPjMlmxy9u/NAaw1Tsh0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gORfLX1clXcEaPuyVnqTw8AszqtOCZMDAs6ep8bmmw=;
 b=DPtoKBrUk9lgSQK7XGlwatQzQzoMZQWZ23didh7I5Uwf2eLNuebXNWW8P/mT4RwiyucpGJboWYMb99JgA4uFG8KNfAN1efurQkILHn8/R75FhhtAtkfUnl2h4YgNgF9FYDYombjn33QRTbBq2WFLQehpHPxZk2dcsYw3rSZ+f1RDBTDQ+6HD4M/b4r4UvbkB2Blex90UpnM/yEK16IJJDFNJPe6wPB2EfSLbs4B7RSOediToqCKBtgALGYaih5szclbA6I2jJjPaNtcQrzPiu5hR3SyzCABibHjEb4psrQQgtKCElZFyBSujLLJQDAEwjbuzfCz7HCednv8Gjmynmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gORfLX1clXcEaPuyVnqTw8AszqtOCZMDAs6ep8bmmw=;
 b=MamF5QcppK0UqDK8LylZSj7m7fCUgxKNAk7MvKfEIVKJOh9NDOgDAU5GtBXcEShcPrefbzAkbZMKRtfbO0AF4UQ1/GgvNCvpB/G/KNETUOuW8XKwonBQlQaq3qEsm4vNW1kmpJGHJtH903xyZfq/2SBcTsWBiBv9S+VCGfWXszw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6196.namprd10.prod.outlook.com (2603:10b6:208:3a4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39; Fri, 16 Feb
 2024 15:08:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79%4]) with mapi id 15.20.7292.027; Fri, 16 Feb 2024
 15:08:32 +0000
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        belegdol@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: Consult supported VPD page list prior to
 fetching page
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cyswcv0f.fsf@ca-mkp.ca.oracle.com>
References: <20240214221411.2888112-1-martin.petersen@oracle.com>
	<883d670c-3ae1-4f44-bcb1-45e1428c9c3b@acm.org>
	<20240216145717.bywcwpx5m7ymyzyp@altlinux.org>
Date: Fri, 16 Feb 2024 10:08:28 -0500
In-Reply-To: <20240216145717.bywcwpx5m7ymyzyp@altlinux.org> (Vitaly Chikunov's
	message of "Fri, 16 Feb 2024 17:57:17 +0300")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0622.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: f4bc7572-1a08-4807-73ec-08dc2f0123cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ixY/UPuQZuhH1xvRec938KWaC/TQmZNdKS/GWt9TCdftwNJxYX70BC3i6DLYhMEdUKnCm7PrsJhq7t5FueVQ78zYK0bq3ewEqn6gBLZpGgNeq1NZHU94ab4zBvfCMxj6jQV8axjlHLglB2fd1bniZcnZOS/1j6GnH8ny2eItvv9W2JjPGrfJj+/7XijdWOiDGQEsBLJHImoXMNUKTK5LsDpD4tnoaYu4+hXcPBQibaHLeqMFEobvRAFdavNC6V6ScrYsdEFO/IDAP4HCbR5kZgO/ppAk5Yvg0fDVB+wEIS3b4haz39spu8tUXsokHT9QXvbcKstVrJuBoyPdjGBy7Hy6XXBopYnUyo1+/HX9fPqRfExeCyDMOWI8rHsBLHz8xvyB6jskSbZ7l9cxZeqK0fqmHjIj/8b45a/9WOMN48PJGgtWqbUiS12wvXT2PK0bGVnrA5D+0w1YG5Hmi7BL/f+kRhT9ctEQV7LrA39s7lLQgLWYIgkGYnWN4GJgjDNM/fLvixdfdpavYHDU0bux+yW0F6Hreo0SBnWERA5hfpn/Qo7rxTWAAS55abYva9Lk
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2906002)(5660300002)(41300700001)(4744005)(8676002)(6916009)(6506007)(26005)(66556008)(36916002)(8936002)(66476007)(54906003)(6512007)(316002)(83380400001)(4326008)(66946007)(86362001)(6486002)(478600001)(6666004)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tkxlSambhn3UcH7zxgFSBaBppN5GUYNFXrHNRbn+ah0+X40mJu3dglp3FqDN?=
 =?us-ascii?Q?tKC2E5s/9btbdSkjwJumZtJpLF484KA+GDZzHWoHSeAeh7YTwhEan03no5eB?=
 =?us-ascii?Q?Cjl/QvBbYr4twzIu2rh8AzxuQ/KpAhOEmMiPCLprmZDyw5LvgLa8jCZir/Hc?=
 =?us-ascii?Q?t9hjaAAGu1wMN/gZRDrtdFqedU/A5OcVMQ6cZ/Xf5cJfXKxSMQXDu/GUrr2q?=
 =?us-ascii?Q?BVsfCheveTXzMZhR6cRpoblF5NKXzNc5/rJJ0Z0mlaMQabjbHuE4wzD9F4A7?=
 =?us-ascii?Q?jbqTSwaTlgHx46l7mHLLg8GC+HWeQWV1yZUV9RJlYLlD/n/ckbdRZkUYmBlp?=
 =?us-ascii?Q?hwhN+03PjHurR8vTEYI4RH7TWDObYD18mH7gigcGPGCRUG6TMJmURWH5wtpg?=
 =?us-ascii?Q?Xo8MHIVPoMYSd3WVQV8F5tyekokk/PyFN3kPwtoseqbrv04C85sxXbi6SmZ2?=
 =?us-ascii?Q?JoH8wNoKdGsw3oyiD4vaBv/W1DiLJB1JUWKEIKaAMFeZ2cKqDOL6ClVXqdsO?=
 =?us-ascii?Q?hrwoT+81S4Rfo57VGIn4jR77SeKrWERsR2d0pagi2NdPOnJBOg8jsDWF5T02?=
 =?us-ascii?Q?ihbP/GpL4ekCRD0Lqx1At4CGfHit0f12NJNA34QRziRddaLS7stbOQdd5L7p?=
 =?us-ascii?Q?lrzxI/a3ToNbysproaX6CQ0nqUdYooCOuZ2S3R12+jvEE7haBPk4e/5Vj2De?=
 =?us-ascii?Q?cUFRJwh3pc4MDWKeiEHQUGnG3WiyZju66w9WUI++MU4on/fuUqWITVn1fyB0?=
 =?us-ascii?Q?iSjcldWlh51qawi5PFFCx7GQxqp8CHCDRzWs4efyL0uWYXfklZI03T4Ml6PE?=
 =?us-ascii?Q?DmRfW7ZyHoDWE9BBv1PATnMabI5n/OYO4DpAfMqDdvsjQfpxFiTwzW8r0tFE?=
 =?us-ascii?Q?4R2KL7N1FEt3U7KHzou52VqgAoS7i9iZwM4sG5zzPerVeHRX9/vxwxNZilRz?=
 =?us-ascii?Q?btY1LB8wXr7AncF5EGfdy8PpTVUWMv8v6CXLJ2dHdAlZ/Z/Z6mQE4e/Yd1Tr?=
 =?us-ascii?Q?nKlHmAWVvHrE/wGRShAaAoWeyKbYx/ZFHpIsQK0VMX2YLrG7GxJD972nMwko?=
 =?us-ascii?Q?4iMJ58UNbS6SZOAb2BOAFBxmq+8g2vCVKkeq3MOUgIJKMfsFiROVPO6gbo5H?=
 =?us-ascii?Q?JD0c/QieBV1S9fYlxn9/+vlyy/ElDWsACINdJrKLBa78wgMeLNZx4xL1xm3q?=
 =?us-ascii?Q?yji+9ihOy5dKkfPh2PHcCUM3OZ2F17U0w/L8tiJe6RhMda5d9kByDz5uN3tw?=
 =?us-ascii?Q?VaI0bJUOobzlQlPKj8GG5soQhdCnxd6LtiE5drIAQFMk1bM8rJuQkh2mHHsj?=
 =?us-ascii?Q?saSww6zH+Xtl3u+krZLO54lhrkd9rpqxkp/CYSc7mJ32BWh+Ck6gK9T7XkR/?=
 =?us-ascii?Q?oXPeNbx+2dvCVB9Vj1i7cBy66Cr08BMPoum54fCd7DMP2g42knOUD7DDx6nn?=
 =?us-ascii?Q?zsFkIcQqKbueJftJuHutS+OySBv0KMyx2k4S89H2n+h/E/ZrgbjzrTxrxZJL?=
 =?us-ascii?Q?qNgRT1eoI4L3y/LHget/1NzLxisDSe9toOQedZMaoJNatECMM3xQ4jd5NWSe?=
 =?us-ascii?Q?4wM3cATTzZbtlYXaB/JApS4TlH7xknC3LybIHTWJ0lCYghOo/JSjqZDNfyfc?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mbgHHSlWrD6f9pITRvFTubRlZwmuwFT+UyZVwbtTJdjWnoBYJblvtIBuIzQ2M7eZH/P3s0jbFSZe+x1XUnKlFK2W+tOVWMWa8CvqpvdWVmf3ZQkmb7mJ/asPZ8TOqoXD+kE2S0RNWL3VcjjpUxzSfl1OZJgf1nbY+gvYclcigknxUsrbR1dvx/w44t3TA7AcgZUaTJuMyV3M7REQto6vh+l5u+FY5cbwE9VyWHL/xLFaiqqFhMa/xdIUZMVASvyVJsGOiUS4/ct20fdnGUovjUNNvvRpEfr4HnIb57SPE2aO9PC+CuaU3s74yHw+dxYpmUjH+aauKi5RtWimnxJVP80TyuBRb0lxzwasPHmwxsbcbzBFPmnOyfezXaPor3CEJwmbbvhiK2djDst3fp6l91gCXCf9JJ84kXI2jm1Zz+N3NssoljR65gidRzR4RDDfSC0I3OEQmwerfhFW/jCbDw4MPRwGQ4AFlvmV8EM14dGH5neZrTh93LxwbZeSbkb3iTh5U65KR8hbAPexGbCykJXMY7GsbPnVQ55JmfFlSbQcuYn4HlQ9PrmRW8/gCkKCTa5mwm0ZzjrasDUT4ZIU2tFL4pimRg3Sx7v8qhEeJuE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4bc7572-1a08-4807-73ec-08dc2f0123cd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2024 15:08:32.3006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34kGN26sawRdfHdkZYoI8R74wluUtIKNVjxcHdSCvijwrZ4DDsUVCVFnVRE99QMtSncKPPzqcSmFdeuv/m/U6z6vuW+RLhSCIo6YojvGpUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6196
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_13,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402160121
X-Proofpoint-GUID: 5I2TQu6O3tbJUpXp3iwdFoBX3XGbYVfS
X-Proofpoint-ORIG-GUID: 5I2TQu6O3tbJUpXp3iwdFoBX3XGbYVfS


Vitaly,

> With this patch applied over 6.6.16 problem still persists.

I figured. Couldn't understand why any of these changes would lead to
the symptoms you are experiencing.

I think my original patch just exposed a timing issue. Since your device
has a SATL, we should never be sending a WRITE SAME command in the first
place.

I have another patch in the pipeline which, in combination with
Christoph's atomic queue limit update series, should close this gap.

I'll reach out when it's ready for testing.

Thanks for your help!

-- 
Martin K. Petersen	Oracle Linux Engineering
