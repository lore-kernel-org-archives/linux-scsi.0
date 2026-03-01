Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09B72EE262;
	Sun,  1 Mar 2026 02:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330817; cv=fail; b=MbRiwc+QmjuIgvafhLzgZfP1WO9v1aBom73//b2TM+BsxsRruIMWNHOUVl3CAl5Pch27ryqi9THfC3yz1EJwTy6WZeZ8o0I3cd94xZsD92UJzaXeXFpp6iil3U8sm3xudMGBzbskWfDgmOMGNVrWz4FyAJWfuRJRKGAU7MoIrUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330817; c=relaxed/simple;
	bh=G34AYpcKR19HMvdxDex7V0FM2jpr/tZBS8lZHU7dLTA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HTnQImi0/DbttjZAtmAwu0vldOBwJ2bM/gcfs97EimFTYcO3q8Uc6xXMpOADZBab4gRkY/OHacfrjhMR+h1YnofRrbg+j1WQu3hHTsmcLRGRM2eSShdk4X/YddKMlIJAbwHRlO9kFCxhqryncWZtky8p7V/2Jz60K51PdyFKSWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aM5SFJIF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DPQ/c6Vp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aM5SFJIF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DPQ/c6Vp"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62123tvH2792950;
	Sun, 1 Mar 2026 02:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lMmWtvrdjIvyl54lpz
	E6JftXV2ThT6tmy2H04Rlpk2k=; b=aM5SFJIF4uxkac4n0FfMebK0suI3QiYaQy
	Ymr39F7AlsMp6kWMkx9cLcJ1kLlweUpZ0ZtFzHBnI+0wOTxeECtvXFfmkE6qXDJ+
	GmmfbS2hHXzaRlQ50RDjtWyFpkOh1Xuja68+pnZBgXPTinBX7vfG31mRzm0n9UR9
	yov6RoJW8AvP4tIgx36MGlpS5X7hgmLrc5LhZ84C8gjY6g9xb6Ii89I3ocVRCLv6
	vZqxIhM4OG/IrGHMJI/83HZrszOmUzsQMdAna7IwCS19piQ+wh+Wj3a0RuFbvBHI
	7vihunbnyvUeFXhXcBZxr1KKTyhYCbUzP2C8btQU9xG+MMRleWNA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ckshn0nxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:06:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SNPLB5034715;
	Sun, 1 Mar 2026 02:06:53 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbpkru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:06:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nJ1m5rvoUeBiVeR9RgGZUuKCLANqD1izM6aAWDtG8GAFImWl7CB8kLjTm4Lfl79kUi+cvKRWa5t+m1fY2hcjss9kHDkDaL/zcaoGvfiKx284X8jc84rMVN6zklpwZkVebPC0XOLzt0a8ZyCn9WSergkCRciN4LyO0rIA+/hyWreeQxa82Q4Gr29B51uAj+2kKfhaMWv/wHFD3K7lcEIShoPAOWo/1geA3TwXeMsbSpq5wrT2zXJmOmGsclruHVDQseN/sCGG/voYRMZhBss5DGDyj3VLgeWMkLc0dyqgoeH0L/06a5Pv2I4a+Z5wffHnHRXYeNbFWM4zvodda01KnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMmWtvrdjIvyl54lpzE6JftXV2ThT6tmy2H04Rlpk2k=;
 b=dozljzqT/o8ERuy+e4JIrXsSHqfJgw27r0VS9qhqp/bup8B2V29u+koyrxax1GY/oY6kRUaSXVQDLChMTZZ3BAaz28T9qTexhvZ2xLD+sxOSM3OFXx39FxzpYm29eV0R6QPpmenawhoRenQWGFr+bcAsRoEse4EygUfOMrEhLlQvp6YbqxATKspMPnUoz7zL+1fFhHvKqe6YP/FIRsSP4y922hmLUvwjrLfz6+3uN6T4HV84p13qtEU002/H7VqUt79guaStFCL4PZXsWo93JB4HSan8jqv3oNgDdvnv+oxc9zXB0niinpP2OLaZrOoSdg6Pa8BH/wKuZf1zNvl/fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMmWtvrdjIvyl54lpzE6JftXV2ThT6tmy2H04Rlpk2k=;
 b=DPQ/c6VpwdhOyP6ifUiBcC7V8I6IsWIbLgtratw0i/RhI2s87zJzeZr2SuzYouNImCOJU319QI61BfBmNwHMC5H+lwKUpH5ZHcppZ3O93bBQIJqan+r0ne4OvhO2FdoSmklfSpjg7brgRYWjuwWI4qIKRdI5nopGvXkQTqAeUWs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB7064.namprd10.prod.outlook.com (2603:10b6:510:280::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sun, 1 Mar
 2026 02:06:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sun, 1 Mar 2026
 02:06:49 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: target: direct completion support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260222232946.7637-1-michael.christie@oracle.com> (Mike
	Christie's message of "Sun, 22 Feb 2026 17:27:00 -0600")
Organization: Oracle Corporation
Message-ID: <yq1cy1o1exm.fsf@ca-mkp.ca.oracle.com>
References: <20260222232946.7637-1-michael.christie@oracle.com>
Date: Sat, 28 Feb 2026 21:06:47 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0024.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB7064:EE_
X-MS-Office365-Filtering-Correlation-Id: 64246ccc-cd05-4812-7eab-08de77373291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	8lS13oTdt/16IHXS/p54y+u9t4z1UtgpgQptbNnWYCYW4iqJwTPsLMDBS18FXTOVyukH8f0G7EGhdQGCYBJFzvUVsm8Rzs7s+BzMLQuHZiEGLm4ugZPLTem3Kefj0QIt0teTD0RP6AE+THteaTcUSk1uRFKQvMyjnmZuFPG+B2gk8ur81qmvz94EfvbM4gWczoFnsvIiSZQYsOIgIpdoVu9Z88U6pg0KL22HaRFZrv0h/dnIR3QU6ZjABSeXCMC/UjSj8VKA/N1Tl9ofiEP5j5gJzmhvVARVyZOJj3Yfb9YGQ8PdufZGCaWM6E8j0DSvu0/y1o9Nd3rOTjJ+NsqXwKyxMZh+exNfVppOluBy0S3s0xhZdDHkaTKc6FATCEtjw6WX+Llw1LLHlsFcPbY+Mq/38/XdhpOJTnwVOXNoQdiuBXXFSl3qjRCNC+E0e4qKlrQ0SMMxZ1e8c0oqXLXMpwcBslRVd4Owwf380Un6YYaSs3FeX+U+6bsYQhGBpE7EKzsIN3IXIYyohCe9cN+S/PMlau1DGDGNrjpZe71myldGVne6W8DkBg3ZLo48DRA06kgwW1/jiRVVNYLRwu3I0ExJN/3moXKHcS3gOmNOggcYTZudwGXdxRTEEr3RIvkn8wRfCWuiCKne+Q/PsH7S6/RkQobqIsWv5sfmWeAaaIUmftFoxxe0ku7m5pJVbt3MZsLeRzEUigk59G+MocV41kQPj4zLlb8vlh/frCiljrY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wn/hATxiuEEQreG9+vpLuE/IaHdHZogQi7xZHQNLcEEtOTTHmoUBZ6IE831q?=
 =?us-ascii?Q?Upp7Zl6CJEJ5MsDa6S+2YRRpsMktTDUG3GMl6tekXG9lj4Id9Dz4lLEqsLQK?=
 =?us-ascii?Q?9cvZlcj/fZh30ZZYmCAYjx7MPJeP7X9e2nnX5ORxJKklLKFwAvmDDgT8JuD+?=
 =?us-ascii?Q?akyYKsTL2FVPCODUBuXG1kK3xYkEWuTurl1TIj7+sL6/Y0Kqsnnuk1v0Ge76?=
 =?us-ascii?Q?sZ0Uvoh+A0aJXWi9/MHY01Rrb20k+FtxdWWtWYVkP6uwQz3O+6sVUzHHFtUt?=
 =?us-ascii?Q?g7RtRQE5Eb2T1koJti8jQ6JZDtGs8CYvpr8VZJDDaFe4xxNitLJvljZiQncC?=
 =?us-ascii?Q?qdoCdNITRgPIjEEOBjCD6zo3YbYrVmM4XcdMbKOj3jxwqdvxf7QoCGCu7a9C?=
 =?us-ascii?Q?F5+1UGc8eoDADf3SFLRl0OJHxEPA/lFv+6nZv7M/VOAwPnubp0MQVTEIwcyb?=
 =?us-ascii?Q?iLSXeI5jG8wQsbW000/6/3diLUfUMt2T7KeFILuBFL6jCzZSCFXObHQXkYk1?=
 =?us-ascii?Q?nMCyvbYuk6Xs0TKf+pYJWKyzckW1XB+FchfDeOQ4PxTlPh26gXASXrqdrGwv?=
 =?us-ascii?Q?ZG1bK7kIYxa2OyQglP6DwOA2pDx/fjZ6MhyKbjiR1vNzhmNvQva4p5PqnaEO?=
 =?us-ascii?Q?rK6dRT5d+aRKMsy4mp2gD+3E1Yon8/cErnRq8L9NDJUVRsBOmm+dLmF2vjYH?=
 =?us-ascii?Q?AuKjaKaZyuw3S9Sq8XsYIr4bOZjAYUiUoJ8dIzCkkp6NQd2YydJFuP/0wImf?=
 =?us-ascii?Q?MWGD92/a9wUZP+LIZFeg9zYFn1Q1q9EM0IsK/3wAlU6tbPXQFLTZqqhTsF0N?=
 =?us-ascii?Q?GH03xFPE/hZJJ59No4zSTz9nrzj5XN4xBQlIa+LjQ7FjylNyC5g/ITQNH5w3?=
 =?us-ascii?Q?5VvFY9usxWPKLjYMah1JoHIL1K9+1lyeHwBP238toID8YLOiH5Uqth4L88i5?=
 =?us-ascii?Q?znwFdAhLae+jkzRJ5fkKaYvS10mms5pNC/n6VqJb4Le1kg4yVXNfqwjwAoRZ?=
 =?us-ascii?Q?e/ls04tsWrikVUSvJlvVt/EnFPCS0GrI6DBsR9o97q0CUIYnvs/flNLDD5ok?=
 =?us-ascii?Q?E49LX3ECOY+pM/Q5GWakzJf0pXu5MMVUWyapqD79ia8mvU6F8f1o81QQkgRv?=
 =?us-ascii?Q?UWxE5lrP7+ADz474yBJwLNEojyBaxWWd47jaNdwxb4G4/nfqTHKBxsVLqr20?=
 =?us-ascii?Q?WPh7oaROJ+xMSQNKiyrrFHtGz2xdmxJLSrC4vjLGKjRSMHo/YBVhqKeTEpzq?=
 =?us-ascii?Q?OT0451tHYRNdZ2JQ/6CSE8AQzTQCN+QlK56Lb0iANekfU/0jSYPVEpGYUWsJ?=
 =?us-ascii?Q?WnO2TWgk6vj9hNQvhIOLLfj+PQrIBA+CuYbUCEv5jzit0E614l7PebNhEuKF?=
 =?us-ascii?Q?NGVv3iP4EztRLIyvGyrBXt+qC1Ly4sZtw20i6d6kBPJ4Ee1gtZx8QZmV1ImO?=
 =?us-ascii?Q?D9D2pmZdVJ38qLZ1P40Sc+5XRBh2zIb/UJ4FXe4yWgd07Qisgt+31adfK1m3?=
 =?us-ascii?Q?v+tIS6cfWuWHbIGI1Q7/mrqlMopR5ZZmVxZWXZ5QajwF2nmTms9XNZgogzVC?=
 =?us-ascii?Q?KPPNfFg22CYLv8f0Ymxw/SBItZQRWDwPiSm37Q4tHFHrqI0O7PjQ4irfgbpx?=
 =?us-ascii?Q?fiicUjhF34AOHKMc4Oo9tL89wDk1npPWdZa8d1+tURc7JWpZz4jYKpbE5c+/?=
 =?us-ascii?Q?lKH6Uhf5GVksW+Y0P1sBwurMy5oXMqq64mN7gpBh6QmyaORhFX4rPe5ygjim?=
 =?us-ascii?Q?rD+FNQMOkBSAxsZ2/9BOySTGPPtqtZc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GohX5/ZMR2O/lByS2CpbcYj4XB7wbDnAeZh6p90kplbo6M1Lduox28y8ygDUuJz5IuaZbFlKLIhymwAdmN86LXH02IHkrgnVZ7pL40B9ah8sWXr4tCYLv+noFpaZhOBlc9VWL9t8OHqEygVxThDvZ0xmLIPhkltIH0ptBfUWXPku+u6HKqRtuQm0doDCd9l8k0VMyeC3p+Ut084bBKL40VEIX57Ic1fm3rZkQFKh/MqTo5O6FOSP5pBQgS/Jkunx25KkDa2B2aHzsDKcJPmyhTLZYXxAOZkECIw7zf+zj1HR0OnGLfh86imVVacq2vPLiMPOkB5pfvR9DkvPXTgWWr02T+x0oZ8Eir4TN5agDcACkJQ3XT6pPirW1SSr9yjE0QW0o3ZFhtidG0B/cX3yDD1srl/g51GZOZPQR+yoM9V9meWtGeB2LC5rcOYpr32tVn8sfLyEFgnF0BRsMiSjC7aHFW2Z6PAk5nsKF/S6VrIclC7FJxc8gb5hoPphhoFllJAr9hlSmSjqFm6wIWuFizsawttFm7RRyC+nVD7AzBLXZBKZ59drVkNMhvwWJ2i3VKK7GpIsSghKJlAPzhbPIhm55w++KbYFMBNofLVEkDE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64246ccc-cd05-4812-7eab-08de77373291
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 02:06:48.9732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: znOJIYtoQAMdvYGy2nBzBjoVREVTawR1GO5VZe+IAB05y6HTpyYB0oRWpsjwQFjnJVIs7dpRTOnXj9qnG0J6NqKYeh33OrtmhkTgNAWxbcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7064
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603010016
X-Authority-Analysis: v=2.4 cv=RsPI7SmK c=1 sm=1 tr=0 ts=69a39f3e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=K2odG-xEv7i8lmV70gEA:9 cc=ntf awl=host:12261
X-Proofpoint-GUID: em0o7UNsv7EgoXZ1YuybYuYQOOgUdsEU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxNyBTYWx0ZWRfX7U8Ts3enNK6O
 denYS4kYBoTgaTO5VxriTBkA28Ajz2anfxTAKqCtJ4I8dzop1YXaMOxcdzhc//yY2DIDo83ra45
 lyzvzpWibzzOKmYIdIiQQ0uxs79GlOIAZoRGItClzYDNzy54sloPG+4DC9ONQflOhip27ZV9Ji5
 wnpW4sSLiO7+qYAbypsu0/ATGBdcC/IJHwAIREi1ZfDUvDwytsAiEjaSZa2QLvGakvtVpYujm5Z
 r01NbHhw45dOz6iSR43/j8MKlh6a6y6WSPcIevWjTTHpe9kBFECQTSf+8/0VNCfIDPpi9lN0ocs
 2OqL351+P5EoXIK5Oq1SpxZRcazfXpvoraWU5XHOWtWwB+CHbMCbPi+i2vgH13vxtkF1TuQVMN7
 kKgLu3yjtoNGUPCYzMa/ecnETfeBtOkR+23CO4VbEszM0EWLkKiM3pl+XhqX/IBM6sxBsdSJry/
 ArQ92jo2ijwBWZ83Hx/WCNXLryncbvCmW0FZ6dkQ=
X-Proofpoint-ORIG-GUID: em0o7UNsv7EgoXZ1YuybYuYQOOgUdsEU


Mike,

> The following patches made over Linus's current tree allow users to
> tell the target layer to perform direct completions instead of always
> deferring to LIO's completion workqueue. When the frontend driver
> already has multiple worker threads (or you are doing a LUN per target
> with a single thread per target) then bypassing the LIO workqueue can
> increase performance 20-30%.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
