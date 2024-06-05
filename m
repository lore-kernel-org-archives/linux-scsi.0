Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A49638DD6;
	Wed,  5 Jun 2024 02:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717553854; cv=fail; b=H7OTlzBopW5QSi3I7qTOho7WPBmtr+grSGkYBQWnfuu+mSCSZN4XfgyydamQwjfM32d2+a/C9d1IMTssg/wc9FKP545XQ9yNnJV2OXPgNyCLWzEe/g2TN6vgOdU8p92jg92hNqSnifZSU/NvrQiuf4+6ezt/XWwjCStJf261mHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717553854; c=relaxed/simple;
	bh=gmZngtz+pP+1uwI/GXSDMQingpt9v5ix5x8Jj0E0Gj0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=K9LwkC5VknJKuJDE8D3DPE1Iw/bM9jGtklla0HZhwlzsxSUgEXGH4RNnaMi5UfHnlKtCn4wwkWlJBY3bQa+r8R/PYYMCQvvmi6dZIanaXmkXy3jCYTYksukabzFP2qQH/srJtD7wK+5pBcVXwHJVe4WCNJaRpWt3Vj+/of5kalc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kYfvXA8N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LHksjYqv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kYfvXA8N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LHksjYqv"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551EBCj015595;
	Wed, 5 Jun 2024 02:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : content-type :
 date : from : in-reply-to : message-id : mime-version : references :
 subject : to; s=corp-2023-11-20;
 bh=gmZngtz+pP+1uwI/GXSDMQingpt9v5ix5x8Jj0E0Gj0=;
 b=kYfvXA8NE4CN3HOQw3aX2Y8Y52BAAytK2w5ZdiDMcOdXg1G42Tf+dljQxYhqjT7kk8Tb
 LtlX6mjgbfvzkZi4vBk7lWAHLRwgWC2ceLboVbr5sy98a66tFpuidSk2Ww8ke/Py2dxN
 PkjmPWatuZakQKUFg4tfWHRvPkz5zl7ayJTY2pEKjitJULkt0lwFG2hh6Ghr0j3jjSYt
 uymvKae6d0d5/g7Dt4Isa88A86ANm5HscDYurVzxTcumNey972qnQyFhXZJLpFPABtjk
 Vnu71UeHObfx67wiS+yL5hwd47mYpKA5BHaqx1dOk/6a755R5J6qiIqtwPC3iVrei4OI Yg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbsy85jm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:17:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45520lZA025170;
	Wed, 5 Jun 2024 02:17:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrt9dne6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:17:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aV+HnoHvywE0bKvZBNuy/yJsxmdxBv6JYweTp7pWj4ZG4H4yGcgpDbDUsuSBo/nrYwlguyfbP1H8MieiEX2DEMjoc7xs/1gaXWfFM5nngNlmVoLrWL4Phx912lQRHhonQpXhVXM+jKUIdD3we6nU8KQ3K4ENNkzIldVQqKQR9n0bpg4xS89Z5QdAivCQEqaBHQoodg7roEy2Y7Dkhokz7hMppRqxae0JvqgV3dHxYcn1g1YpoDNtkzPRX0P164Uzi3BmJ93U8qrsRdprRyaT1jCvQJcgInHt0CF4Z5KVcU8f5j7BL3v3Mi7VomrLw6bYvbooCJCUH6O4hOpgQUOCWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmZngtz+pP+1uwI/GXSDMQingpt9v5ix5x8Jj0E0Gj0=;
 b=leYe5+MlCxUMJicnK3Qo5d/GR/U5IsSM2cQDx7fqwfJOwEA1JMygnIGrUo0qjKQjIMq5M/f1lndqgchN3SJQQ95fUaz6dwSrVPkTN7C6F09HHyK+GPlphibWqBPxJJfLP6U1DR7+RF7GU0ejMTv3YsWeF1zjjyvmzFW8LkR6RWvjeG8bE9RxQLN5/pcNXREzezRQxO2N9UBsiaIvoJvCR7aw8rmrvDQbknkRXPcHWJQMdNjPnoMNRmugvpXn+zqGozZa/udFg54PCbxIibHwGWfrJsKSMeVuO91+gRiH0HHoMbi9w47XSoJHdAK1A091BBP0MvMkL7IXBLQ6M8plSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmZngtz+pP+1uwI/GXSDMQingpt9v5ix5x8Jj0E0Gj0=;
 b=LHksjYqvkH8Qj6eXVn8a3MvAW6Qd9eoRQ6bJNFQIiXWHV5QE9l26hnXEbh32mHwX7dkIHk78A5t4lR7vhKQMHE717YNTwvS01C6r+WEE7STriYxfCdwsqcBhlg9lv2g/Ub2LpAtK1+t8V+O0DGXDqiokch3M0WyncoILw4YL+iA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4886.namprd10.prod.outlook.com (2603:10b6:408:114::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Wed, 5 Jun
 2024 02:17:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 02:17:10 +0000
To: Minwoo Im <minwoo.im@samsung.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman
 <avri.altman@wdc.com>, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeuk Kim <jeuk20.kim@samsung.com>
Subject: Re: [PATCH v2 0/2] ufs: pci: Add support UFSHCI 4.0 MCQ
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240531212244.1593535-1-minwoo.im@samsung.com> (Minwoo Im's
	message of "Sat, 1 Jun 2024 06:22:42 +0900")
Organization: Oracle Corporation
Message-ID: <yq1cyow9lrc.fsf@ca-mkp.ca.oracle.com>
References: <CGME20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3@epcas2p1.samsung.com>
	<20240531212244.1593535-1-minwoo.im@samsung.com>
Date: Tue, 04 Jun 2024 22:17:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4886:EE_
X-MS-Office365-Filtering-Correlation-Id: 7517b225-6231-4bae-d43a-08dc85059b3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?L5wiPNbt6mva0TLL9K0ldC21TTQV2jV7Id6A83kSuWezbwa6CIlvxxxhKS5c?=
 =?us-ascii?Q?BPvhRRHe53Xm5IAVW4SemyvoLw6Zi0hVjoWU8adKyQwG482s6C+BvP3+R4+J?=
 =?us-ascii?Q?cA8r1aCr86igHO+fE8VE/s6gUGk/zKxb6n/E6bHNiYJxnN2r5bZGyJwytTay?=
 =?us-ascii?Q?AMfL45jblhIMOYYdk8RM+mDyOnvVdQgcNLCMUN3S79auekG+JIqXlawsf5iY?=
 =?us-ascii?Q?pwhGv/zykUByc1xLe4Pidjzc4IYNcYfSvo4H/BnlsVsWRdKUh8xdxmOhlGkw?=
 =?us-ascii?Q?/OrmAIDcoJy7s5Dwnk1m31pfqk92/KUYzLImad4vl9H5LHk77hZog6JXBlPH?=
 =?us-ascii?Q?OcaStz/BGYHvk3o1XxLwW03cWq7cqPMA3mC7jnOgC0ymXsMHqo2Z/Qji8/HU?=
 =?us-ascii?Q?OLQkDMNZygRZGJEPNW6u5Fbpc9WVRB37XjWs6xX1fa8+6BplQs085ibuc/4T?=
 =?us-ascii?Q?MWcljPrDCIX1eZ28YlUISwna1SRiXW9B3ZrQxY3yWzOIvNMv0VDMMp5URZn5?=
 =?us-ascii?Q?W9sWxv8K2uwneUz7H1f9j/XUcnTA+OZBlzKIu2bh+gmwa9A6jn+6fXbK5pYj?=
 =?us-ascii?Q?6PMuEzQUnlPBnkIsRqkmi3IDPvGU+v0ondzg1KJc7xWqtvKu+6umGDCR8+X9?=
 =?us-ascii?Q?tXdSU14psOOsmusp81FfKtcV7/MGsm98qtqJ+TTnid8ARbH7zOHBb55UgFJV?=
 =?us-ascii?Q?6uIOuXdKpsRzL0IqJVaLbPyvQWh0yEpnUpm1cwkaDpYt11yHLx6ZyT/Fl/kS?=
 =?us-ascii?Q?bsZfXN8Ulz1LqE3UVbQop/wMatTkca3gFPPCTrU+2Anmx6B5oh3InHdhQoxY?=
 =?us-ascii?Q?OylJgrp4/Xuo7o5OPS4dQ6NI43E6sNSscYF/LIA4lomaQ+dAdcZkuWruLYvm?=
 =?us-ascii?Q?E6RSZi41cefO7qlK+A8rlndsDRL8PqyXEYclAaSL2Va1ANqTYEFOu9tidx2r?=
 =?us-ascii?Q?+c1IeZBSKyOJ1aiSPnfDOtuYwT0JXxhXmT0QDjLaErlendqV0dQzCejvXxfZ?=
 =?us-ascii?Q?sB6t29bVuDO8qSkqycp0VOHqqydrZ2fbAC/uYeD1x1qFEwO7AnpNbmrA/d2S?=
 =?us-ascii?Q?zgdf/AovdfpiTIO3h+vQl2/8MusqweSCPZICuv2CfVnE4Bo5HQtMD2y6PIAd?=
 =?us-ascii?Q?OIhDm305c+T3aUrTQbd0JwhGeIhAN5N/yW8K1dqPtKkP5lotTkdDK8QF5n64?=
 =?us-ascii?Q?RD0rU8VgWoiBTSd7i6BWAOiuqfCdwef0uMAh3l6DjOniXaTy+CkDoaTTzJq6?=
 =?us-ascii?Q?Qsdn9OkzVxSPUKBb2K3TvdLL/mKLpMiz9Vwv3avezw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?yifCTrrGTJMW1XZk/RWs3TRsUwZmM1qPPLykY0c7qRZyMQEhvyWFj/8PO61V?=
 =?us-ascii?Q?Jcd2B5F7pTfr3/aVN9WgFH0RhG/1doRL1NnNp/q7RiSv27miUxVeWZC/hRz2?=
 =?us-ascii?Q?VjY/rcLGdwWWs7GiE7EilmZqoDWoFVWmsxybJMFV/8Z4NARjO9sicc5HULN8?=
 =?us-ascii?Q?KnMgDtbvSkql+dka0xx/RAwJkDAUejiLactzpXOknEnHhURlkaCBZmgUkChm?=
 =?us-ascii?Q?IItAxrf/0kqnarRb4txn8OKBx5INgRtpgVONZfPIdkz74zyP4SPIDsY8/Qka?=
 =?us-ascii?Q?xsoSE3vyPylAfeNuVTVhUfNrI2i1HeKKBYnaGXzfitLgENanNe5iUrC++W9O?=
 =?us-ascii?Q?/Frvd617UHB2+r2Adq7b2CAuQ2Tr2SMsqxS7BDpi6HP3A+1xecNE4oxlk/Hb?=
 =?us-ascii?Q?YsQ18+zKxCqvblhfdNK7c6aJaQoj4kzbQMvFfxUzYoYNuX46X8lsxoO/1mKX?=
 =?us-ascii?Q?cZ0TM4VNfWgvBQ064XV5lYJxoiphXUsYqKtTr0+bqwVL93MSL0o2NyqAX6Ec?=
 =?us-ascii?Q?3kAzzK7poWtRESqRJO/YdTH+6/5CLGqP8oXIkFDsmUoXc1mBq5P7OiSD8JSH?=
 =?us-ascii?Q?YRAuTe160txVQ9mkYYrZa/JWDcFEFf0fulv977rbpk2gw8RgAJOCu2r6s6B/?=
 =?us-ascii?Q?rSVCOpl1zxPVhEo08HPapA4P2wuYRsFcam1rUGN9FHhN4DdurnmJtFPdUH38?=
 =?us-ascii?Q?kR/wW8VXEOiQQzKchcylRVv1aYEgQxSvms9/TYUL4Tsur7AX8Vu5gRlrdlwb?=
 =?us-ascii?Q?0RO4v6AFfnsvt9PudoBtT2ZRq9v4vCty+q4JBBBT/8u2WI2uQK331Ez0Ty/3?=
 =?us-ascii?Q?ko7v0fdxPiB7qb0iKH8PUqc0+IJnJiWpG9W85PFOh1lTU761dR0S/3dIVbbk?=
 =?us-ascii?Q?rvZf387lBW4wzWt8nztpqOJKnuqUaOu56d/QqiwFBr6dJytwuqFRRm3Eg45A?=
 =?us-ascii?Q?LQXvsNX+3QrnlmQ5SA4pKgQFSUOYk4CzoxfvGHXjpXzD62wU8+O6D9psM72i?=
 =?us-ascii?Q?IpWoq/vbB6ouWZHU9uleCRq9j/ARCjAKzoiDQrG9lVBEuwC1G3SQYy0oR+iS?=
 =?us-ascii?Q?EbIbzE+BGrD2abnmwf6ODtOLUbj8avMpLJ0mPN+uEBWYtNRp+gfQ3s8ZzUzm?=
 =?us-ascii?Q?mDofBJVXHmet0kLs3xDw7LN7DdckFOWe/8umstSZKhJQIjBFed+2dFrB0623?=
 =?us-ascii?Q?rj85ouM/XLQSFAPyVHlJ2eBLsc5qv4UxlWGynjZX6hEUSR0sQmlliL4fkutK?=
 =?us-ascii?Q?ciR98Slja6S5CCcx9qQtkA2x91FTVl/AeJ5pQUgjIhoRQAakRU0X7v9FRnrN?=
 =?us-ascii?Q?AMbuE62C7ZRLDZQco0dL0QDixxCDyuyZfbh82lOgNf1ZX9U7z0trwhnYL+Zg?=
 =?us-ascii?Q?dTZffXovAMTcefhK3wM/1bgdqOLjbpTsH6Omi6wOmkrPLsbrInN/giV4beDC?=
 =?us-ascii?Q?4SX4v2kSpamXi9yflF4aMSs+8pL05OLMJ8nRMC9dHqUZ2lCRbWOZJmhxl00n?=
 =?us-ascii?Q?pioDZ1f70oZTbv+zAV+uG8kHT/2FeqqVRgxynwcT2hQrWOr8JNpYZ5jZINw8?=
 =?us-ascii?Q?DEkNVdyP1dq1SzueukPu1/NWrrE/41FdmAOI7ChYcnCrzXjYlRsXPb28Ll0P?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mhZnQa41JFIo8m6wCvinjrTxAADAVz3QgJmPGrN3F7ZwCGFgsAW+U3clpWl+aOhYkLyFEqlxypmQg3dZXbL22gHp+J6Y45cNSxte0VjVyV4bugQMUPDCUz4HS6N2W6CO/c02auNu9wssem/1RTE4UgG7N/rzEDNtwNtP1A1gLXLuvBZA/x682vof4FfNZ48wiL8OuTJutSqCsCQzfPSlUhTfJxrGEYNlwuJwcaQYEDRgDNzqszzXmbe8NHbH75DX+2C+aAVApzMXO6tZLHCN1yFdtTWDdP/ebrXwU6mrRFWYtQ/sW9Lhb/RdnMcJTFbpwCCHoXnUr/y3JOHLTmDaJOIylOPWHjl0leOX8HlLUpjLJhftSudOmjh9cVTDfh2EnyMoW3pFW8NQ4eNnqaB4ctzAzVM4if2XEuS7Yurws0A0Iuq2B9eAAw9HT5TmZuA9CW1lyN05tjAHwXyjG4Y+KnDmHNWoADar0NBT4KNy8rQq53+ayyxql0955IjXD6aREdF+lQBbxXHtIshhkJNFZBSQSw3ZoQtW/qJhmkk8nRuoZzlEjjOyCTgPyFdVNiL564yqHmC1WERCW0WGT/uVIx3a/92s+XHr+y+/rmNsoog=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7517b225-6231-4bae-d43a-08dc85059b3a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 02:17:10.6413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M3zp91Ad+RpZLDnHka+PJivJPOH2+fJEeT/b+GDiUo7+EGxIjVckBr0va4tmGALH0GORsimsD0YZ+V1JuSwlGpmqdsqpEDO0ZAPr9FfQzEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4886
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=649 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050016
X-Proofpoint-GUID: v3ijzEOVqwfLaelcF2nuWr7xkLVd_UJU
X-Proofpoint-ORIG-GUID: v3ijzEOVqwfLaelcF2nuWr7xkLVd_UJU


Minwoo,

> This patchset introduces add support for MCQ introduced in UFSHCI 4.0.
> The first patch adds a simple helper to get the address of MCQ queue
> config registers. The second one enables MCQ feature by adding
> mandatory vops callback functions required at MCQ initialization
> phase. The last one is to prevent a case where number of MCQ is given
> 1 since driver allocates poll_queues first rather than I/O queues to
> handle device commands. Instead of causing exception handlers due to
> no I/O queue, failfast during the initialization time.

Applied to 6.11/scsi-staging, thanks!

Martin
