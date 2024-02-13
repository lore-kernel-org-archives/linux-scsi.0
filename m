Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D2860DD7;
	Tue, 13 Feb 2024 18:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707850157; cv=fail; b=MKUKE7S//UHUNVS+25OjQx13S50ve6sfYYyJ5rUZdFh91ZgL6xSQu6CTqSCcm3sPeZXKZXr4+4+ZbWeiHVl8aQ2I/UBc/xO6fA4U2N2RTPNe3IxjiTQ/ZgaLIlohfmkV4Ob/jgCiZ0rWiKPZavUu5rXCV0if8Tr389gnsZBey7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707850157; c=relaxed/simple;
	bh=0h7+sGT7voulxyzShs9UHu5fvVoGqgVMmEN/8Bpsxuc=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=EdocxexRCNCbycSuh7NekbevHmjrL9Fe5X89FTjEteJhmyJ1Zj4Zit7obGjzEjx8O8kwao+hn7WyF//7bY7HGrENMvB40lkpDHNyoghUb+QqnuqbPKvQsf6z23T1I+XkH6sDV0RPKlcDaG/LijRCYEiqQr8MDyISjxGbfQR8C6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WByKaSTM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ovqao92r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WByKaSTM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ovqao92r"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41DIj4TC018247;
	Tue, 13 Feb 2024 18:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=vtBHsuxd1JrBRL4MVfYPZVcsICII7idqKE9hs/7u72E=;
 b=WByKaSTMP60zqgT/uwBhyH666j8cuglP0pIteH9g9sVjPHL6LhfZKGSluYIWLY34NSkR
 7oMJWYqCyQKX6lh321HCeUGZSUhwIWvAuXnjfJcPTNbgX4y/Jn6JSZI5XBEE2Zmy7bAJ
 5FSe8jL/GVykQv+peVP3SnGvaO8LjYik0GGtLD7nhGDeNtlETenOTOGZfAwGrG9pLCG5
 EDA7saJhkqoFqk5jQWWTTi5AijsU9Mf6fRDrpbiQUEJDZ+kejdcefbjouNEZL34X68fJ
 bNIkmkPkNX313kmIV/7dQsUoAbJIAWtZpH/KFfB4IqHf5Gpmth6MKcutOi8W9GUxFqMQ eA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w8dyjg0c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 18:49:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41DI7XAn031535;
	Tue, 13 Feb 2024 18:49:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yk7sfun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 18:49:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThDr5RDONdasrisOY3UOU6/EzdGW5YUTyuCGNRvY1F8rshFBbBMGH+lMj0Tky1vmIYHX20vCvNPaBu6ePaozdDcEIr4JYOtCx989iII2i1pIYcKX+6N+XgIlqMaEt/j+nNO+IUMqsHkzyq365VF6UXxtXQeztwPpjtS3kCCOTdt5ImkVr/7ZOROj5W+5G5datRZ2eYkv78rDm4m0708MA7Mno1l9wHx7AezjhoQz5dAeVtFkQh25KCwzQUpZ5TFnn9cWkX4tY64moVVtGOTN2GpFttj5aMGp0WsOzj70cvEYdwVYQ4ZVkEyAr9K8t1l3eHrFrRoOsZ0a+5e9T2cmiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtBHsuxd1JrBRL4MVfYPZVcsICII7idqKE9hs/7u72E=;
 b=mZA09xhdtbUmX9T5lb524r0ymaKocX8bddzx5Bg++qFEYKUxjOQsuIR3usQH+x+V/lBozCmC2V34qF1cR0gW1jo1fSzQ2peQtH0NCTH+Eea4EGZL11RLkRLfKZF8jUIlB0d0731a5PLeXpKrFFApURMxfiCfs8O6y3c8B9LFWKIV4og9k082ehXckobq7s0VV+whjCEE/2DIkTJJ0cTBb3IuhCcDzZeFJFtZKtGcZi63Dh/UifOlStMbP0xKb4bcYWMkJcuS9BCPfZk+kNOLhBxOIwn+Y8f1R4G9C/JR71CxFaJnTNPZaw+zqLIEwPAU8QYFGOczYpkKxXwbKlDnFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtBHsuxd1JrBRL4MVfYPZVcsICII7idqKE9hs/7u72E=;
 b=Ovqao92rEBQ5Nqm1Nv9YpQ/1AqhDSObH4YuyLgQo02JayuX3zzRuqfxA5Lc1btMqB1nhZ+a4520NpQb9I5I7zDnbYMRiAiPZkx/iSgJsNy05bVkOVhbB0picetryghnUNKwTDTurNBFcZbl3I8iSiY+u594px8PlW9CW55+I7Ak=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5053.namprd10.prod.outlook.com (2603:10b6:5:3a4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39; Tue, 13 Feb
 2024 18:49:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79%4]) with mapi id 15.20.7270.036; Tue, 13 Feb 2024
 18:49:10 +0000
To: Julian Sikorski <belegdol@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-storage: Ignore UAS for LaCie Rugged FW USB3
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ttmcjj7t.fsf@ca-mkp.ca.oracle.com>
References: <20240209151121.1004985-1-tasos@tasossah.com>
	<b16e72ad-3f2d-46a8-8361-2641088694df@rowland.harvard.edu>
	<2978efa3-e83f-4ef5-907d-8232e4b692a5@tasossah.com>
	<6d4b1f55-09df-47e9-945d-fa38cd36588c@gmail.com>
	<b6dcf71b-f094-4664-8d43-7d8c0173f51f@gmail.com>
	<c21f9649-30be-462a-b9ec-f7c96ead30cf@gmail.com>
	<0cf5ea13-6472-47e1-a32f-b9f332656c6a@gmail.com>
	<yq1bk8kl9th.fsf@ca-mkp.ca.oracle.com>
	<0a892e80-424f-4047-a885-5efbcc75af53@gmail.com>
Date: Tue, 13 Feb 2024 13:49:08 -0500
In-Reply-To: <0a892e80-424f-4047-a885-5efbcc75af53@gmail.com> (Julian
	Sikorski's message of "Tue, 13 Feb 2024 19:14:39 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5053:EE_
X-MS-Office365-Filtering-Correlation-Id: bc1e9661-e4a4-4c4a-b4ef-08dc2cc4773e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/o/P7/Fp40rjXMxDgVZQldIP/ndevKGQOteKaPQwRb7aXcaJj0qWIjuqUEtIRDdPWzcAS4rpzTuGftzz/c2U6NdtEMtc1QyZFvlfEvgi6ok/gnqRYCa/u3UWMLyYKxY+aUFJSIGlvdvavxRsi3bscW+vnZbjF2ddxpfIZb0FkgIlNA6tnmKxY0NBx2dRZ0x1zUHHu8BGRxWjSm3SYnpntVStfs78k9ppkUvFVFZyZpRBtzlCF4dzQ/XMiFMa832zCYB91URbraNhptzB8cap977h5TbuBEkml2b2V9l11leTEKpmqvJzo1bMfDtamd40wAuXcQxyOHiAFhWXtu/ircnQm2hIFAm7dlIF1OIcuXrI9d84paDakESQbhn5mAMXMXdxcxqdi0VlwxMj06n7K67fjO9Zr1h4V3FS5D9cqDIfom7n6ONzxshiusMmukgCuiEXTU3QjrgZE8540XwBW2nCFfMYouZM+j5Y+Jb8bfX8MSIvzR3mL6J1SttwnawjpJDQavSIWZ6fG6jXGXEYrp6uhHZzC6fbgmxuxx0S0gWLpxUnSc9RP99AT14+EwIX
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(6029001)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(8936002)(8676002)(6512007)(4326008)(26005)(41300700001)(66556008)(66476007)(6506007)(6916009)(6486002)(66946007)(478600001)(36916002)(316002)(38100700002)(86362001)(4744005)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?wN50DIsBh4aaQ5BJtvZFdSfRa1kWqofriwqmLPEkyuaQ6GOTc3oiv/detoLW?=
 =?us-ascii?Q?OmItHcakDIeFjaut0e+dH3qOFIbsLXVHgkh6/1GPheCM3exvbJ4pGZ6NZzfy?=
 =?us-ascii?Q?7vuEZ/2hgpFCcp2/T17hOvwliivtTeEZ8Au6ho2xwTFkKrqBuiNhBSUNFk9b?=
 =?us-ascii?Q?RmZ5Ikwck9TPpuZ+NLwDQXNd/rT6cQtvfDPTVTfVtfP8dWkK4Uja5NBhIIal?=
 =?us-ascii?Q?UMn4F0U+pV8Nc3ap+M0BPkED9OYnK4CeFm6H7skvpLpTEcqFy780B1vJqqTf?=
 =?us-ascii?Q?1Kw+TxyN7oRMo5JXws/jE9pnNmBVzaG1qmYwN65VQRs5uMMKEsRDrcVknnbZ?=
 =?us-ascii?Q?Rs7p39+YCXymOueMy5wWfVY8zHEdjjyvEFz3Acdefw8sCgv1gXLiTfI5/2O/?=
 =?us-ascii?Q?s+6iH4sUckHL2WnOqdt0IvEledwzhMyOO8Ka0VCgdMiztp5yeGTd+96aVsNA?=
 =?us-ascii?Q?CdjzUDmbWuy5+LEvbSkGs9v8dWwb07422JaFe8Joo6BSORNVzSSUcu0uQurd?=
 =?us-ascii?Q?lZfps43+xezNk+/5aQjZAbzCT0R3mDcOlElECwBAOIGJCT3usH1uAhVr5YrY?=
 =?us-ascii?Q?A/Cegf6xZ8R9PHUFCPrIkaqoYc9nAlpzSRlOTeCKHx0znJ1YGAVlDyDPk2OO?=
 =?us-ascii?Q?9/D5TRKA9OoDPu+vzt6BFk4Yl3jgjYZcZeLopoguJc5+bLqKbjGYLnNLGRXh?=
 =?us-ascii?Q?J+K8AFApOFA8LoNfj/MJB06E1RiTLBVBDCjbL8zqvytqwffbAn3u1IbeRcRP?=
 =?us-ascii?Q?OLx8ddnHkzphfYkSc4Xt/NPiuVTlvOHfRc95r4ejCZXAInSr5OmVt3pYObLj?=
 =?us-ascii?Q?6Bxhs/qfBsy1F54u+xiRTyrfXewwIZKP8pWTcmgqotHctXl3c5B5oMGnNKxX?=
 =?us-ascii?Q?NbJ30FfyK83MRHPbclZ6VcEwYy0405R2RIevr4Ml7e/wd9qd7KZn8YgnN1gp?=
 =?us-ascii?Q?N/hOfeUhtM6tRyJx/CJ8sWxF0cINrzX066LcWMkVge0mMLQpYnwbGeG9ZiOj?=
 =?us-ascii?Q?GRT+T50PifI16JaMOPkdA/2nupcfH423JlL4aa7uDTX/fMaOxVga2eBQXdDr?=
 =?us-ascii?Q?ylvTOVpEX0hgrCFGsXtqVfiWpli67lvIsVNFYxlwGVAD7xRubJexexMYJttq?=
 =?us-ascii?Q?pB6QclETHJapEXz71UM0Qo2bEFpP5jayr3Qg8oAJL/813MlO29psKLlQzJmy?=
 =?us-ascii?Q?tXcK98GdQ4enQzupfH4OvBTGEOWAWEJIkxYbMujax0sWXsvmPEl+8l+4iWwg?=
 =?us-ascii?Q?m3QCTm4QIYPSA7men6+QJfbAf/UyTzRUpd5ZMz/mo9mNrsbz4bYRMMtqISvM?=
 =?us-ascii?Q?f1uYsiDVKb165qCrWf9tNtUy+m7k7oAA2LhGkPeMFqWNfz0848hWx7rBOGrQ?=
 =?us-ascii?Q?Mk6Jp3eaCXhbKnfx+8V9LOUFHaYkOVes8fnD+MVTwZO38+PJ3CUwXxaIVwIm?=
 =?us-ascii?Q?pnKNCRUjfnGjWb44nEqIaOKUTza5ZlSMBpsD8noaCpF7ZvkpPcj/acNLSiK2?=
 =?us-ascii?Q?Tle74wQDIPhM5rt5Pt92qD71ijyuDD4zf4sbbP5AUy9S/hRBqBBuoOUuO4BT?=
 =?us-ascii?Q?s3YIn9/EMLGQzAXFu2adCvkgV8/payGHGaPU1QzrD9q44DzUvdjgSNDqNQIS?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	fyw64uATaoj0ST4s1BFeQAIdem0IlI8R+2sdkQn0umD8e3aPE8/AZGIrA6U8vAtpiRDJwrsk6hPVupdOy38GBi45yFX+n0kd8WYSUgQVVnnSWmsDJZEs7U60zVW30OMhDgOeBxbxJERMRiLifaO+50ciR1/GvJZegu00m9eeBY703jShTyScGUNeplXvOIpFsZlJ6zbH9T3JYN6Ip6aISfloMrZOQui4P9p8s5gFXf8alrLrH9Z5IarDsB63RgmyoYwkZEQREB2ZQCI3ignJm9eNxjbC+OGr32WOl63IFy90tLPicHTHS85xzwbDi8BG9LA2Mxl/hiN9Bi8458YSg/9TEQt/byFcl5OffuBZqNOelieFcUBTfIOT3yR0VaTCCZESnCs8kDf5KSh88e7lBoCWL1xAUaDqAJxiPVFT0vUuEmFH6UE3Q0axtXZBPSOoNd7rmjkGGg8oQoMq4t9aXEYh1mf61Xi6PqorkF1cVg1jD6Fn2LF6VgOeN/mz2Ne/VbagbVW+qF68BKJ1Rmvnjzs4a1+KgViZB2xc/ZvHaXWRQhd5YtQ2whLeK2brkr0+bsuAmbS8M0bEZFlx7shoMU9VBrDvuHOqxyw1pQTVhTI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1e9661-e4a4-4c4a-b4ef-08dc2cc4773e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 18:49:10.6473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TZjzpJY5GhM0zxX7QYL77MInBb1o+1GL9ERme+8dks4Jdso98K0Wt6SXzyTr2rzZp8NtkGoRP1nOXaVYBycXLGFS+wfzaDu+7kM86VHyx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5053
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-13_11,2024-02-12_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=422 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402130149
X-Proofpoint-ORIG-GUID: bZaB86rCwrLK5oDmESHoRz-cx9Sd27RD
X-Proofpoint-GUID: bZaB86rCwrLK5oDmESHoRz-cx9Sd27RD


Julian,

> Feb 13 19:01:41 kernel: sd 8:0:0:0: [sdb] tag#13 uas_eh_abort_handler
> 0 uas-tag 1 inflight: IN
> Feb 13 19:01:41 kernel: sd 8:0:0:0: [sdb] tag#13 CDB: Inquiry 12 01 b9
> 00 ff 00

OK, I see. I think I have an idea what's going on. Let me try a couple
of things...

-- 
Martin K. Petersen	Oracle Linux Engineering
