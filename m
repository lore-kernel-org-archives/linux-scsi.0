Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421DD42BE87;
	Thu, 23 Jul 2026 09:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799457; cv=fail; b=WSJ3bFRXL7ie2GkCP1vc8TNSav2sUI4M+aIWpEau2CZvDEFF0PcIZ5F0vTrrCbfKwJs34UMOz4IVhd0pLDWKh0njSWZT+j6S3kTFxxJPAoWHMdbpDelF/dxDdt9IIzuEMnueSNtsEr+hRBOsTBi8JtMdXiTXkF1s1hAqJSpw3wE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799457; c=relaxed/simple;
	bh=2ODpcGpUIdjitLul2c8993G9fVZ55qxZW5ErkKavLfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m0E09vJePzb3Cj4epgGTANQ7EP9sbT4+sz7uXg1HY4ce07Ti08w1Pt83FNBICj75dwRnbtfdBTIP5Kl7HsL6IfeEmkhIO0s5l09vOUFsrxTFTDFgX+ZY7mDQfM35CBiWiIpIVeu7selXIh5/Dkda0Kv15PEFWq6eWIhiQ50QJDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XgD2ukQa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gijLbQAW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XgD2ukQa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gijLbQAW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N3rdkI106353;
	Thu, 23 Jul 2026 09:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Xm8jpgEQDY+ahit0RxV+hSdUY5Nfp44OiHJp7CVCzDk=; b=
	XgD2ukQayuOYhcQPUib4aIGFOVoqSyejIPe/8MWwCqJ/xtr40XZ2BOwDJckfIpF7
	chrffJr3qF+vYONdkosXj0S9eFJFiksc3l+1E9EZf/ZTsNhnZ4m1FAnyFPvpbwRf
	DIKmmueY1GVO/8SKQOSuy20iG7qwVxtSFsge9hsKpQiVmkrapBVSJ6NQMYH77kDF
	w8F6aZNJKoJtK/1A2osSx2tJXTPhdF+DbLGQ/QJy29AxroMe3D89Ad63oh7zFKNF
	fbzLA1dgOsSiGX80Ia9daZt0ntzRay8WZb3C8gL3BBwTZToFJ/pFY3Y+FiUT+zMX
	DIPj2DjjERNpvpNjqjs+lA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kpxn0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XVPS010588;
	Thu, 23 Jul 2026 09:36:59 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011004.outbound.protection.outlook.com [52.101.57.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxsdebf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:36:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lhZL3LYAc8uZW70ZO4XRalHlK4d3+RyjnyZzrHh6Khy8+9668iP/tw/Fr0FSeH1ighsUr7RZuEAABzouscXsGct/ncYa9RtUCqhVFNfyuWqy/TlNnOk6idOc0ray8S5oERlMFMi5YoW9oscPcz20V5K36yOpkNp2uWlXrT+D08k2RSgW7ThZBoBM9QTDKBRkjAYPjCxT+MJlV69tKl8wfsJeFaY//qBEVf4kHea361SETd0d2b8FCCFXXmjFBu+7BABgJUEwOuETNMp4fxm5klybjx5CVJhyQHuilcB1EJPqlJ3HwycU7vovQIIr2Yrwl9cbrR3fpbwztI7AW+5L0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm8jpgEQDY+ahit0RxV+hSdUY5Nfp44OiHJp7CVCzDk=;
 b=D/DwHIVopK29CLmSl6UfUHJKeeifqVkue8gwxVCnlA0noRSEKB+ggPXNlzvJ+eSrXd1qCf2fZKv0WhwEUgfOr97osOyIScOYTodSVBx13FiiQNHojigCpmzmBSOMYFa29wO72bbGZRG8Ui0qQj0yKuCBZ7TjNqe3Tm5E1J/99ydfQA/6gKqkw2Y34jCRnZ5XdCNVGqNo263CpPWfGWL5RBDV03CHmqxjP2ASkYRy7il/dB1SeWFZ47Ds/712F17D/ZxfpPqPs5GajUoExyLvNnIkXsa28c9aR96PSYzGcCqN+mAIVQpKmFrovcMP9cJ+HUYhOoA9qURh3EYMgcRMBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm8jpgEQDY+ahit0RxV+hSdUY5Nfp44OiHJp7CVCzDk=;
 b=gijLbQAWGZkArMx7pNwozAD+RKDc9MQBWi/QxTccBSKcw/a/BrcEq2Z2BmSlwlwsjxRzZnvbQfbvLIhS42brOYQP4cF7ays6ai/qP7pCCWUh52WCelxy3f7VxMnNKnZjt6s8rnXAaVDHYYyfMDfVjNGlAkre1CUHU3e5sC1x9hE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:36:54 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:36:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 04/28] libmultipath: Add bio handling
Date: Thu, 23 Jul 2026 09:36:02 +0000
Message-ID: <20260723093627.2327456-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:8:233::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a41265b-b9d6-4cfb-abe3-08dee89dee69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0L/O6SfPLMA9c502n/9i4kfykToDrVVkHdibZof+nJF1o8H1XIfHgeEM5d6zAGsBX+1hBzo4zjiXzqDRmPVASGMNDgDtkjxjq/sg6Yp5TLtUzyy//qkvbjd1GF5mTuu65UjwVFB6xdGp/+5kzqBaM/wXIpD5PDW82+VHAHpgAsQ/S+vkbvBYw4vDY8txzW4tXsQIxuzkDSik/Kw8c3Eg0cAiKgIoF5t9xsq83a/X9RylhlSHI6rJkwLtS3cFMsCvMYAkVWOLDsLunOJp6rISYRyC3IMdu7HHSKXgqyIrAzCPDiUweGLIPOzD09C/NCM4nzhT5nYbeSLcPF03lcIc8OYBZHxL/ow5gaCe7yRNM54Vh9ROhVbYLnI/5cn4PPnelWbKbdk9WBTBHzfJyYW2MSQVhWYgq4oc5Y68DTe+GT/zYZx3pZ58WplQrr1FKhAo20koqAd+PC7hXeXRmeBEs86GJ56j6qrwa2KvDkonV//N3whWWxmdfXr67FbhJtz7A5CD2aU9KZHmBaUf62YHX+h6Pw0Qp7SDllvATaZjjLizUyNOgqV+mbJid2WFQx2ESkBMmkp4wzdlfo+8e1Wn2uSGmKxvbdmxk79y09fuYdQf1dV1WvAPblnUbXaT1XncLCP50iiYHUk5H4kstTtSUoGsuPxqBNdu5AXF7aoqhbw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fhpzi3Shd6yyEvFPr3Mdaf+Vo8sG6TFdVntQsL/aUtT5OyHOWUZz7hati357?=
 =?us-ascii?Q?a1kU7+kkb/Fkvlmp3HFD+UZkhLVutYOEOZVaH48/77fxMOt3qkDx8hORWehy?=
 =?us-ascii?Q?zQ9tPZIpAJEWLP5sNhDhf58KaeKTaP5k8pvDk+qKwffS3bz4wMLtWou7R5fu?=
 =?us-ascii?Q?4t0H5ABTPzy5FPz/Adk5V9+elXpFF6+kPWUD15jhj68980FFiINalFuhkOkl?=
 =?us-ascii?Q?A61/WQHqC65QwJpDY7o/LZB+FnLN9CKdN6eRbD2yjxhc+WdmmKLaJ7hRLHwe?=
 =?us-ascii?Q?jRZ360kfXDRmY1ojSu2TLdt5ZsooZSJ84y8JKIgtCs9RyJRaTNBYs+5WSFqo?=
 =?us-ascii?Q?LGCZ8HVw1NAFFHoisup058F6T65Moe076chUWdckBwtVsTKlq5NNpUuCvngm?=
 =?us-ascii?Q?/BueGKdEh/VWlmut/xIvKoedt09M3nQBR5qXfDeID4ilheTeG0OhjYU2G/iW?=
 =?us-ascii?Q?Jc2AniYDitlmSdHxzYmfHfg53jtkcSGT/UTvf1xqCkfjIEP3pcFSOiuRF7Wa?=
 =?us-ascii?Q?rPaAPWw2ikYoJsqu6621qNAesce0PcwbWyOSi7yPRQ9d7OqUaQJ8wGH2u/yy?=
 =?us-ascii?Q?Tm81x6KjlQpIBptAmi1fS/gOFIeIuWU6TwnLLSyfK50L9mUoodKXJKt7J0BU?=
 =?us-ascii?Q?JdM6uU4HYqYFoKWR2nuZFHLfVU7glriZwmIA8PaA+bBCYkcuZOc4yTQUm20M?=
 =?us-ascii?Q?maMQb6LFbAEgUSiSd60XnsLGD08AkG2bxsL9WJ6B3eoCC5NcUft4X369cFOo?=
 =?us-ascii?Q?oJ1ZL8lRCEMsiylVprhp6sAvQTFtXjNt44L3WkIn1sS1QHyzKx6na841Ntrm?=
 =?us-ascii?Q?1ZQs0SlE4WlutlXXE3vWs2XyyTr6AnoRCy4liIokzxIRIxg88Oq8mTMwXwLn?=
 =?us-ascii?Q?Ixf/MtEaTqHbL7fW3ZUuEneBebh2Hrm7nG2qAMq2euJkw3tANCkCV/YUuaBE?=
 =?us-ascii?Q?H4401cphnaIs99tp6h2aJ5OnWoGZUmDKMrOtMQFJRADQS6jZrsFoiSS/kLsm?=
 =?us-ascii?Q?WRZvhtaSzDe46qoOaWMrf5MUV1IDAX6Vw/sT7k930uwgOHBNQeFVvXEStvdY?=
 =?us-ascii?Q?9PfDEhdOk2Zmn/TEUO+8w7jp1azYDW5GYcXkwzR2d5bkjPJPdgS2sjucrkBx?=
 =?us-ascii?Q?9TbWP7+Q1CI7Q5NMC24wqo7/E6FDF0QwZRde+fKP/9+FtwhgFijx8pute0L2?=
 =?us-ascii?Q?+mM5cf018QHb9UKcDLLnReJYwhRNXsRR5QxTinxjrpwv5u93AJhmqmg54AAj?=
 =?us-ascii?Q?GsgvZh+Y+tYpFHc+XpgKALHlKRIG10TAogezDXS5uoT8YKLDL+lLubdSF1GQ?=
 =?us-ascii?Q?bKTBPvZvSOuCkr8twRJCNotJCFgqzxQliY4ZUuqsL5veo1cg5WaliombruAg?=
 =?us-ascii?Q?qVTNA1sd4RUSa5F4zc+8617kyCa61gMqGUz7oDOrcxiPqF0Nsc1Lp243GpgB?=
 =?us-ascii?Q?8ecTXNleLOQGVRqMOC+I9R1sczqpoXcdR/BlmWrwgcghGaktH3C0btqrvr/T?=
 =?us-ascii?Q?2L4y1dSgFTqWVPq3q0h1y7yTTJb57sa7w9oEzfX3QoH36ODEo85f3cc7ngJc?=
 =?us-ascii?Q?FwIhweD5ykoRfJh95zunmFVxM5IJSr1GTK6awWQrsQjVr5w6BpsG+G5kJ4AT?=
 =?us-ascii?Q?sdwB4TT1NjlLrgoPmIKjwX8Sk353t+a8RtE8Ghq2tHdxDm3laS6UlinNb8wR?=
 =?us-ascii?Q?Hln6DW7olwzEAH+DDHm1IN7kYn5bNheW88MaeRCLK5+vKhtbsG7qSb3OMj7m?=
 =?us-ascii?Q?QU+5AM97gA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	HTptNX3hfNB9e2FTJLPd6ZEJ7dh7bTS+baTMG52B09c1ehn/n0D3W6HuQh3Ghlb6KW6HJmrxFuYIuQn5WfLGCVY/TZlteYrR6nTfpeW7oy2CHfPWG1ld3c2iCne98zigDwiOJhWdiKd4bYJgFlknsHQtUZ4MPdSJNZw30dqEW7UoOvwEPhFFVdbe3Kjza1i4NwfR32SXewxd3I94dtM1JLd/Mp/nQcXiENYkYGA8ZZzogikcilRbULDtTd7gAD+iZNppf+8EdF7T3SogxEoa8GZn5yZV+rcMg7zAzIUxc8qQPhT6JpEwbhLvOYRtD8F+ffnuUqbKANc2MsqLBn9GiQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U0Oq8zMTK0XjeRU6e6+BOBbi8t9rTK4a4XNQb2g26zgoWatwp6JnrUhjvVLttm74g6rO7FqHnWNaF49yQEvFiKz4Axf8X/AsIaWqB2ocQTPageujn3Dn2bBGAz53LuOU/+Fr8nnwW6EdwIjWJAMBK4lEuLkh7oJeMGnsVIvXO8lOf4bNqECDTcwQud51eRIODZg1w2vmTygqMNhnlicWGfnO+wH6ynmwj4A/LiBtlgHOqYuRTtnBlt0X4P8iIZQEaO5vBMW0t3u7sIOFUo/FKPUNnSQTefFAqGQFNKfdelhhp7ZJeJqJuIrIw4lbR1oLh7LpQ9fkW0F7lM/BrnitqWqBu5o4Xl1yOR8x3odxjL0TMutSJDrRJwhd6XaKgt51jrJ0RcuQCVkJBYrntUe28iaScsalgQFQrKHDXZpCZdUxS68KyhzwgFm8SYJxXr+2IEHKoSohtXPvowCXrSshLziIHXxwkSS1kUiSdRPHGvEw4k9qViQ2HLeK7Z1fWZh17LCs73autrkf0sGObnVOFCd4Ka5xeApZsmh1DFe83ymmdKVnuQeV1V0csMlvQpJtY9P8kCrmqQVIe5HeF/j4W1XHoDfxIoVFjWI9rHOV44U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a41265b-b9d6-4cfb-abe3-08dee89dee69
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:36:54.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Z0MEjhlGyC7RSXi3g9yWqHsKYwWufgPWDrNGeHD2GPX38EN7J1dJCQ01ci8J2yTL2rgSFLQzPlNhWk9ejgX4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX7FM7m2hu6xX8
 I8MhF2VygqblR/dBpB0gw2+npdqGwIhCNNwfvnBI/6sFaAijSGOVcewj7Hg04PzTwiTuufEkJaE
 AvDuoqcH+xd1IK8gkgDR4QOBbviGkuoSvPBP6bUR8T9R7vWdNni7
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a61e0bc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=0Q2gd2vOsnR98QmcnEwA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-ORIG-GUID: 3EjK33eILv9ke1NzH2o6ODuY1JGjfVAD
X-Proofpoint-GUID: 3EjK33eILv9ke1NzH2o6ODuY1JGjfVAD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXw0hdvKIoewGN
 KoOYvdGZyW64Jw+X130esUs8YueWX2Iybr+xrLtxjNzemNJoSegu7EFqAGU4ZgeAWvsCbiG4zT9
 Ej+ef1ifF3kCUr9SIguQtQgAeorfu7brT4YApavxJS4lhaDVL27SU/lv5+WMdJjyPL03CVBWnLU
 cRUO7Fjam3Sl2aCXaPEM511+EDxR2Bm9y6WzxJP9XNHpwSi4eeMT/nMTfZriu1F8j9OW0tbsq/Y
 dCQMkQpH+s63YSd2kWxokrz0WNhxwmCKBlh14BQkgP1sD47Q+5x7cN8r60L84TiHbxd3EWcnOme
 gch5cucLYp6gXl62X+jEGI163S3au2HOg4vpw5R8K+d8V1Sxeesmg+Zg58TgwHZXcaCYUeR+g2M
 raz8Rkyh8Z9kJw0ZZw4CZKlehJrYXCxHyt+Rp+MxvUPU8pRM0J/5VyReYazird4nkuE4qr/Quj0
 olqKyRpIdR/z0el9QGaJQ/BpjYR9FN+wW8DaCbQ8=

Add support to submit a bio per-path. In addition, for failover, add
support to requeue a failed bio.

NVMe has almost like-for-like equivalents here:
    - nvme_available_path() -> mpath_available_path()
    - nvme_requeue_work() -> mpath_requeue_work()
    - nvme_ns_head_submit_bio() -> mpath_bdev_submit_bio()

For failover, a driver may want to re-submit a bio, so add support to
clone a bio prior to submission.

A bio which is submitted to a per-path device has flag REQ_MPATH set,
same as what is done for NVMe with REQ_NVME_MPATH.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  22 ++++++++
 lib/multipath.c           | 108 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 6c75654c12f8f..57d13eb1450cd 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -3,6 +3,7 @@
 #define _LIBMULTIPATH_H
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
@@ -29,8 +30,10 @@ struct mpath_device {
 };
 
 struct mpath_head_template {
+	bool (*available_path)(struct mpath_device *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
+	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
@@ -44,6 +47,14 @@ struct mpath_head {
 	refcount_t		refcount;
 
 	enum mpath_iopolicy_e	*iopolicy;
+
+	struct bio_list		requeue_list; /* list for requeing bio */
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work; /* work struct for requeue */
+
+	atomic_long_t		requeue_no_usable_path_cnt;
+	atomic_long_t		fail_no_avail_path_cnt;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -53,6 +64,13 @@ struct mpath_head {
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+#define REQ_MPATH		REQ_DRV
+
+static inline bool is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_MPATH;
+}
+
 static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
 {
 	return dev_get_drvdata(dev);
@@ -96,4 +114,8 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
+{
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 20bb8cb0ea956..448d879abb354 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -5,6 +5,7 @@
  */
 #include <linux/module.h>
 #include <linux/multipath.h>
+#include <trace/events/block.h>
 
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
 
@@ -43,7 +44,6 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
-
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -230,7 +230,6 @@ static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
 	return mpath_device;
 }
 
-__maybe_unused
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 {
 	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
@@ -245,6 +244,81 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 	}
 }
 
+static bool mpath_available_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device;
+
+	if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+		return false;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_head->mpdt->available_path(mpath_device))
+			return true;
+	}
+
+	return false;
+}
+
+static void mpath_bdev_submit_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct device *dev = mpath_head->parent;
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	/*
+	 * The mpath_device might be going away and the bio might be moved to a
+	 * different queue in failover, so we need to use the bio_split
+	 * pool from the original queue to allocate the bvecs from.
+	 */
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (likely(mpath_device)) {
+		if (mpath_head->mpdt->clone_bio) {
+			struct bio *orig = bio;
+
+			bio = mpath_head->mpdt->clone_bio(bio);
+			if (!bio) {
+				bio_io_error(orig);
+				goto out;
+			}
+		}
+
+		bio_set_dev(bio, mpath_device->disk->part0);
+		/*
+		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
+		 * enters submit_bio_noacct() for the per-path device. The EOD
+		 * check already passed on the multipath head.
+		 */
+		bio_set_flag(bio, BIO_REMAPPED);
+		bio->bi_opf |= REQ_MPATH;
+		trace_block_bio_remap(bio, disk_devt(mpath_head->disk),
+				      bio->bi_iter.bi_sector);
+		submit_bio_noacct(bio);
+	} else if (mpath_available_path(mpath_head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+
+		spin_lock_irq(&mpath_head->requeue_lock);
+		bio_list_add(&mpath_head->requeue_list, bio);
+		spin_unlock_irq(&mpath_head->requeue_lock);
+		atomic_long_inc(&mpath_head->requeue_no_usable_path_cnt);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+
+		bio_io_error(bio);
+		atomic_long_inc(&mpath_head->fail_no_avail_path_cnt);
+	}
+
+out:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -290,6 +364,7 @@ const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
+	.submit_bio	= mpath_bdev_submit_bio,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
@@ -307,12 +382,35 @@ static void multipath_partition_scan_work(struct work_struct *work)
 	mutex_unlock(&mpath_head->disk->open_mutex);
 }
 
+static void mpath_requeue_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+	    container_of(work, struct mpath_head, requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_head->requeue_lock);
+	next = bio_list_get(&mpath_head->requeue_list);
+	spin_unlock_irq(&mpath_head->requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		/*
+		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
+		 * to allow multipath to fail all I/O.
+		 */
 		mpath_synchronize(mpath_head);
+		mpath_schedule_requeue_work(mpath_head);
+
 		del_gendisk(disk);
 	}
 }
@@ -324,6 +422,8 @@ void mpath_put_disk(struct mpath_head *mpath_head)
 		return;
 
 	/* make sure all pending bios are cleaned up */
+	kblockd_schedule_work(&mpath_head->requeue_work);
+	flush_work(&mpath_head->requeue_work);
 	flush_work(&mpath_head->partition_scan_work);
 	put_disk(mpath_head->disk);
 }
@@ -380,6 +480,7 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 	mutex_unlock(&mpath_head->lock);
 
 	mpath_synchronize(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
@@ -392,6 +493,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 
 	INIT_WORK(&mpath_head->partition_scan_work,
 		multipath_partition_scan_work);
+	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
+	spin_lock_init(&mpath_head->requeue_lock);
+	bio_list_init(&mpath_head->requeue_list);
 
 	return init_srcu_struct(&mpath_head->srcu);
 }
-- 
2.43.7

