Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31A018D658;
	Tue,  9 Dec 2025 03:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765249812; cv=fail; b=jRD5Hpe86CxFk6SlFGNoi1zJaVt4pqc81w1ENkcMLg24aySYS3gyo5fRQpRC/stA1UJGr/nmO7KUX7eC4dk43WMM94WqqAFRTuZWiZtEW2E3USGT5bmlXnfO5euL6qGfaEYD9BQ/XBblaOCu91TcRmQpIt8sXfBRRwbZ05Rp8Ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765249812; c=relaxed/simple;
	bh=K9r/MsBgCuu93al7YGYWaORjhJR3C1BcgyL2bzQyitg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=L7/cOdaE2Mt/NE6OVsKQEjMxhcDeZcO/kMfsmiH68yRcu51UTaDAOl8r59qZGA4RFqfKc+BS87c0XTKhOPAP4LQxX6AFFXIU0plfgghJX4VyYVfBTQTjG6gcjWXjhzCDNIVTiniMQ00fUahoPs5BO8SuMQjNK0PO6kofBP66334=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IW+WXpbv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tfyTRKbQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IW+WXpbv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tfyTRKbQ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B92Pirq3796281;
	Tue, 9 Dec 2025 03:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Qg2qlgT/2VyYAZHouJ
	ZoBR5Z0JVNlzOgLW4dngXrD0k=; b=IW+WXpbvN8TIMqkrRov3papkj6zRBByk9f
	ruVSQAtfSnsFjd36IXG7vCqhDKLUBvQ4Yd0Ab7NNXOjqqPiVY/lOAgDo9Slh5ga3
	3vPiV9srI5OFPb5Q8vGnbqwKdK25+CHk5j14Dch52RX57VMO57cEq583EgLPXAnF
	u6zRPcy0mXMo3sWuZ66PgLd2Z/hAaFV+Dn9MIUWk5PztlwxQkraP1ennmH0g2Oiw
	BQJZ8bd7Yykxsyb3AlgGz29rFwaQ4CJZrsYgYZ93maapFlrmVNz0edNAuI0PhHTV
	shJf3F0ApNC7I2HnL2RrR9lWIBG8XfnjxQ3fQKR2oe+BWaxZRk0Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axaws8152-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:09:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B937jSE040690;
	Tue, 9 Dec 2025 03:09:58 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010055.outbound.protection.outlook.com [52.101.56.55])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxcadgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:09:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oD+QtukK3eAbew+B6JhwzebaGQ3eAMBI7RRtm8Kh/6oh6IWQ+hrw+RbEu+lCwDBn5o8ST/CB+WlzV6B+h4CKSLfDdwg6f/0UepaozXyWI7i8U7lDqrXJCu98NIVKJYxJcLCE+nyiXUFsacl5b10LRUm7aFHjDanSGT78uYW7tOSemwYVkd4a/xki3JBJqC1HJEv9JWHeUUvb8cNNgeX7qvr0QhR0thEnNsZkIikDv0Eo/nOo1WTWJeX12yKweyqVBtEJCJFxtzibJos7q1irWt/Sw71EylgZkxfBqJo/h1HvseFEUGlzMjLFP0KpDf27cI48xHac/T69KkrohzmxUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qg2qlgT/2VyYAZHouJZoBR5Z0JVNlzOgLW4dngXrD0k=;
 b=ZTZDogyWZcv+UsQNZe033CHu6hCmLj6V5U2oYI4vrUUjbjo1cZKUgg188PYH6OrlL0SBwqiUvP9HHkHRkT1u1Q0Bqofoa6CK0X9nxXfpqVJRZf5eYxcX0ZPk20Nq68cFOapiW2GIZB2um84edjvTYnO5lQPYay4RtV/6H2ifNGklgBwq9DHJKs1jsWrOjt+McyJnHQwc5S51P30hWVC4sTxxbVj4wzNemJcf6WRBmZ4HgEf9a0S/8SnU6f0aaIhj1tN6qy7aYwpOOf8iSVzKHbI+qIp7yUqDOgEK0ZokDy1bGqxe/cnpwWuKjMrnr4V7U98nrlrOJRTiVYxrgv3ZHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qg2qlgT/2VyYAZHouJZoBR5Z0JVNlzOgLW4dngXrD0k=;
 b=tfyTRKbQFSHZ7GcSM3FLuPMXwBH2qwSsbVdNiE6nuVouOozIKYlmHoOUWy6jVmtOs7nRHk7nei3SBYYzlocxDRqHlX5TiK8UPSkKshc8lz2UUI++zCh3FB5cQ8RfJRvfNB1KbOJibMrp4kUfrV2VNbOK2J/1taxLGEP2SlTWYQE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA4PR10MB8610.namprd10.prod.outlook.com (2603:10b6:208:55f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 03:09:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 03:09:56 +0000
To: wdhh6 <wdhh6@aliyun.com>
Cc: john.g.garry@oracle.com, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        dlemoal@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libsas: Add rollback handling in the
 sas_register_phys() and sas_register_ha() when an error occurs.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251206060616.69216-1-wdhh6@aliyun.com> (wdhh6@aliyun.com's
	message of "Sat, 6 Dec 2025 14:06:16 +0800")
Organization: Oracle Corporation
Message-ID: <yq11pl4pd0g.fsf@ca-mkp.ca.oracle.com>
References: <20251206060616.69216-1-wdhh6@aliyun.com>
Date: Mon, 08 Dec 2025 22:09:54 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0028.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::41) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA4PR10MB8610:EE_
X-MS-Office365-Filtering-Correlation-Id: 004a7cfd-b8d4-4378-3ec4-08de36d06df3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1I7tMSTwIJJ5TRBtQguDb3GuU3xubiGmt50clh9s9tdkHrZNjTR8zN+oPS6m?=
 =?us-ascii?Q?ayqMxO1+j71GdRvcYcgGDCDu66e3dl5ZLSgMhSxGImq+1hAhALCog3nfmSZ7?=
 =?us-ascii?Q?3vD08Zv0PHBq8uTxT0DQ1cFZGk1fSYRUXD3sY8VmfT02Pm6aGfLRqURCOHln?=
 =?us-ascii?Q?5/RU3kGXylYU0pxNH2Glc1N+3ZSXXKSV6NwRF8kyhVKHTqG8ncX0UhAoOM+/?=
 =?us-ascii?Q?mSSXBOanhqX+XU8mB/5bPaRAONfIlJKVhqM1eMTEVvUrwFykfEwUqYMlLr+o?=
 =?us-ascii?Q?RdVCfj9EE8qp0vZKwqvXQ9pqsKx+xjq0vMEx2jArzj1+ZpaPbgfG5sVz3D1O?=
 =?us-ascii?Q?0GA5VHPPHkGiKzxte4QkLm4+12M3ExKRJtOY9HfMn/P7Cy3cdGWnWHJs3pxO?=
 =?us-ascii?Q?vYwfsnggW/Cbtp+/+uBS9NeS6M47j71AOaSJbRZ7EKBcqHY6bmSi7ourRwQO?=
 =?us-ascii?Q?4TVlbkkSswXgLLQSpQV9g1VBHs6+DGS38yAChZ7TOgJF65dyi4KB1hO/T/Ik?=
 =?us-ascii?Q?eZ+pHnWLdrQjw6mdhzbt+trUgZy+WC28epICQ+pFW0+qUN635zLZLpKz1GNA?=
 =?us-ascii?Q?TiHm9aos5IJBH1Ee072CXwbow/GifrMleBKWu6aMfxuPpjKQDCAnw/gJX/eX?=
 =?us-ascii?Q?oD1y3uNDGqMFZm1fNaaWlTmZcZRVvKyLux3DcahlHiAW1SN2+NSD/HBxyZUR?=
 =?us-ascii?Q?lyPYMb4tHvbMnqy9f5pBRTXt33hOKkwyWEVHNqV7BDdSkQYSac1TQwZR2SE2?=
 =?us-ascii?Q?imSB93FMTD9rWS3jSp6lBnUerruWUxhifXBXIBM6E6qju1kxJwRh68OVzz4X?=
 =?us-ascii?Q?SNKeC0KkqMZRGzgMxtnPlMauvMRt24hYKh6lz2Y5UN8EUbmHB6JvMoaAfgDp?=
 =?us-ascii?Q?qQKUsK6x2VA02TJZL+7gWKmmDqlfkRbcAHmvnOf7xcljHp0wzu97oj8iCAU/?=
 =?us-ascii?Q?HuwNGZ/HfumqeBsQUzwDamLY3jf2/0gT2LGjSFbDUTzaUBuWLJLVMSTOuQg/?=
 =?us-ascii?Q?mD5bF4dy6TCG0DI7Ms2+GqNjBtoyYZYi0krmAK4x6nVvD8CNNSoeeSuD4qjO?=
 =?us-ascii?Q?J+u13X/NSqv264W/kJiksMPsXZ+9tqL2jTgecyQQNH2PynzRplcNwd8VeNKZ?=
 =?us-ascii?Q?gusqY1OsaQ7UFonP4dydFn8GeF47MVlfNYK7M+rfInQQt29HTbs+tJDJgvKr?=
 =?us-ascii?Q?TYdrdh+mq0w0zj89HaaZycCAfZyUcjjgHE1gMd/1IXn2oI/L7/qM+LZHxtlH?=
 =?us-ascii?Q?mct8jGXSVoIO++LBv4XADCxFn60YWXgBqoztlHXqU8z2RUmxteKGChI/rbZ5?=
 =?us-ascii?Q?oiwIHS1e/PCVQdF606H7kemzlnG3wQfk9YkHCvxIgL7h+RnsIgjP07igAEsn?=
 =?us-ascii?Q?RDj2eiGpBSUY9Q6OXrRNhsnuNGPxtB6SppA0gmc31rVG5+O3ujHwIDv+Oz2m?=
 =?us-ascii?Q?z0eyd6enJ4e+dpnL6Fk8/TScqcqK3BH9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vcMQtfBDtrJTqoTkm74sB3OcpCuVyskh+7O0zMPLsZQNqbYksyPcbgPkzt0x?=
 =?us-ascii?Q?V30mFQ7R5Dky+F+pcrSzkx6YS3LfSCJrCTcPLQkATcRdmXCksCKbSnjUtlOB?=
 =?us-ascii?Q?5p1j813SannFWUU5yCaRcCGBzYv6jpqTQCk5Ae1IMpBTm5n6fXp8kYJSr2vB?=
 =?us-ascii?Q?owoDoYp3SDhIzt/coLPkxAEvv0CnHa73dEqMflBuPTO2wONTwdiNgcjrrZiS?=
 =?us-ascii?Q?+TjaigXpzXPV1O5+YGSMI2pfjxpfMUQ/Ea0SxwNWJGROZMYALmD6gUddjg1k?=
 =?us-ascii?Q?CLCF2TNJfT5urNlnmayKcNYPpBrW+aWXRSCqXglgcPRYkwOWajqpkckyyymh?=
 =?us-ascii?Q?WQfJ9rMeRt1qaiUq7TB4OD9xycdbn50M13DAnJ2rUts9lzIw6cRjPI+tcY9u?=
 =?us-ascii?Q?HW1q0wasL1mnXlJWBcaN7F4D6qohoYHLDJEASj6uydWEtlW6kRa2Z4vj/lmV?=
 =?us-ascii?Q?5RyVRdh0c0uTCO033TGskPD3HUK5KQXu4xjfh7AzHNQ+JXuZfp0Cd3YpTeAi?=
 =?us-ascii?Q?wfVXWXd+LB5Ep5uU5dxNm//tBrH64kPvDk3Lk2A0GvwEesy972cX7QgwjzFG?=
 =?us-ascii?Q?v04iSjufF01ZZA3UFcMM/juY0z3lL8oXLUW4GaF/QmxutFJvYDHn0RDXBCMc?=
 =?us-ascii?Q?ZN8XWDP2CDY692VLeEaz+dYdEW0CFKMc9q7eUkHVr+ZHwxStkKuaUDtbCGyd?=
 =?us-ascii?Q?A1wz+dusaphSjFEyet7Ai7eeqzv+R0evh0iTEUdUB14C0U5razxEQMXmywI3?=
 =?us-ascii?Q?er/G3VIxrt2kSkH59nkriY7DDZHM91yZ18IiKZ1aVvGwg63HE+M2FPaBtRcM?=
 =?us-ascii?Q?c/Ky9biJRGavdbA2b/+km/sWc/ZJpM30Ty5oTUuFadV/NkJEi5/yMywh9qnn?=
 =?us-ascii?Q?EKtmIawfQGdKMiQAN8hzNl7ktU8UuOVGfDwfKJxcB5mOvapYCW06ftPDQoQJ?=
 =?us-ascii?Q?2Gc81fPFNv2iDExBJdkZmbpdCOvCsA+Z5WGKfD96B349vmsR2Itl3QSrjcxE?=
 =?us-ascii?Q?AdpxtMyyFnySC/RPBZi1qH6mgpkferHcMfeFxj2zS4ksWGGGzPm9wGu72V+f?=
 =?us-ascii?Q?+ZggYb91GjpRh254fE3Z+6HesvyIO+40NgkldpDZ6uvmVPU5LBgt1BqBH1Sw?=
 =?us-ascii?Q?p34xWJQXdDoTZxu7AvBjgeVWYkLtJ3V1qXA89NYsCBKZzPwZJJLT2CJiGgBd?=
 =?us-ascii?Q?S9MNZ5TN4dgLLSqEJHK00rWgEN3DhOpYSwVgz4OrtWszFfalazK9DosFBgMR?=
 =?us-ascii?Q?4JIX/78OtWiraFwaodQJjo/BnzRwiL5lVGbUpUH2rWRqu09JuBGTVQqGJ6Kj?=
 =?us-ascii?Q?7DPCXzRYG4/lT8j/2nvt1gLJ6abLiBdkcmVOhokEnxzZsK1nwBVqtcAzi9q7?=
 =?us-ascii?Q?/hvgMiYjfmDzmn6dL3nbGHdvpAKMhTdoEXqgZMJiSiffVk0d67zKSmXLBy9P?=
 =?us-ascii?Q?0gLuNw7RqB7VBKuKKWpwVgqiyWin9SWOijiY2cx8D67Hx1hjxK8JDFu3laYi?=
 =?us-ascii?Q?kyuXgdP+2CvQeW5xX7yYEQsibUmtkenKJDkwFLhO3H5m1stmGFoMguOVy5rM?=
 =?us-ascii?Q?nXeTWCZYJEzWFlszSoCeVbC1m2kmJP8yLgSaTyQg5iipYJs95akUt/DYX001?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wK3UID0C6dXI1n/fFfzjamwJnzCwbWSSitJfIEnzfGCF4nvOejkEr4NplB5xju762jLrjtjXBsGyvo7u2J+lgz6MrywliVbf1sY53opDP4v3WVpfJ/diiCUb3DDlylqLGvmOd79dnKvhd2NbvlE1CpzUiFVAJQJcPhIHBplLLPcDtttpNepNUcHJpsb6ktEmemhItcNolxz4sRxWnt12HOlHnwmBAkP7WGJfV9lID5bybZbVoKaJTnYJbrdwC4jkTy66z0JMtE6qBbyl+spgNsGf8gT+5zo0RgLTLJXDaacl78PPTyFJAwd8jY36E8By7DUEaO+KDMFbSMQ5UWycPCzacJC2JMqW7WN7F5TEuVQzqxqjKAyEu9VxaOTXX7ChzkEL734+RdvnigA2Ig5s5lZDAtNBlCkdAjvfNYJHi6AEEjutwx1lCmzVj+zl9xH5nh0xwSAB6n1PAtdHBm+DLLEMHJ8XxBuDrO7AhR22fTAqd0IjVdLh9D8ec5BCA93dgGFd399LrChxqwqcLHAQdL+mk7cQMsh+dePzGXNt2pIIWpp0ek8gWNToKSLi7nloQ4buLOFrPOxz0edoPosMlZVGOJWxyWjhZAPV9KYXBBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004a7cfd-b8d4-4378-3ec4-08de36d06df3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 03:09:55.9997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LjpcKYj53ziDdKMicvYf/usA6u5aWw4g1Mdvu51LXIfoiOSaLQ11K+Rqq9NJTpyZp95TbFzwk44j0Vrd7FXlDpJ0zpXCywUbq1TsO0h7ZjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8610
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512090022
X-Proofpoint-GUID: dSH-L2DnA5iCGeP8wsdHr3mDBAtLsyOI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMiBTYWx0ZWRfX1AkpijfBNXRT
 s5QhfVJvfET/yZ6B6/SIQmTjfDyuzepoh9d5D+vC6kc9cypsrA/H4ZqfIwMkzWl0azocb2APQZp
 Qwgsw67vgjKEYgfbEfRhMC3NvYdqcnKoc0kqeujgFSx53CviDXwbajek+Ql+NCWzPYuKgaPqe+U
 S30rky0MBV0cdwaYGRxd7APklWxw1SWiuxzkAhCkKwU9XSEhZpitCOwIheE3nvIGJVeP/9/Repq
 ZHb2WLIGPFDLDvLiaZ6LjcnvYDW0xWHGPrXkA6UN8Ekx/mvkjV0LPZh3l5rbzh0Tv+7jjeolSHm
 xw0MOafJQ1zA+2tyf+aNlPIjDywFnrpP+Frkbd+hO9TWpaoTf3tIfCHGXo+pmL3MeEOvUZaWDkL
 mecgpyXOV9auhGglObeizPKDStE7fkUx840FDkenty8s6ZIEZ0c=
X-Proofpoint-ORIG-GUID: dSH-L2DnA5iCGeP8wsdHr3mDBAtLsyOI
X-Authority-Analysis: v=2.4 cv=c4umgB9l c=1 sm=1 tr=0 ts=69379307 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
 a=ZXulRonScM0A:10 cc=ntf awl=host:12098


> In sas_register_phys(), if an error is triggered in the loop process,
> we need to rollback the resources that have already been requested.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
