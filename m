Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DC7386439;
	Wed, 13 May 2026 02:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638579; cv=fail; b=ErN1BXjHtZqQcKHYhIB+euCb+4T7oY3BDhTFwAsmu8nLuLPPort5RQW8KazsjrYDqJxGZQ3DWz/WCk1AE19WPJhu6V0Ev4rM3DH6NCDxZoJlA9Mgc50jBXLO0Tt/EQCUHa+fQ4HJ300g0WnznCCO93bgel/78OoD2OTxIDV8lm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638579; c=relaxed/simple;
	bh=w5bAoQVPd8ZsoQAGJDI/rnxnoOqi30mVEKVNUFAVH/Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LGz7fU5gokhBUkowVcoVNGd6E4EbuvsCHBddjpiM0Lj/rxHoq1f0ofy39uourmHsLPoCH+KtESF2di9R24G/uE56KevcEOqxipqPqrrkJw3dUe7xYLzQPBVp8Bn5zLSmHALF9WBloiN1fhseLIr8/5BfNQGZWyW1DJR7FNVR9vs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OOO1SkFX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HfZ4/tI4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OOO1SkFX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HfZ4/tI4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64CMv0N81848833;
	Wed, 13 May 2026 02:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+/hCMQhAb0fG/d1us8
	hHIHvy5Htm2VsTFjMNz8C8Of4=; b=OOO1SkFX+H3thO++ogZ0D2Iq2hnLalG5/d
	PkBDwr1J1ckH1lAcD2ugscJaXQityIhq9BSPPiAJBvJtAbhI3x/aQYA/v5GX5u9o
	mN01NDoX2i75WV3UUNJm54Bh7AQJ9x89qWz21LmswnjN0RklOspeZKBYqgCCo82o
	F0zkPLavImtOiVlJBde9E7/YeOER5MZ5A5/Q8I3+FkBYHc4KsDrtwE8EVKJQEyIf
	BkCzON8xl+ZWeQhBg+TbizLVxRBypw7q6UBpJV06b3h7ERtYMQR5AYgmxUDLYWjM
	JYQBMEU+vFak9COAasBN2dDdmLcRk5cvbukLceQESln4742RGYcw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c978bp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 02:15:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64D24pkX010998;
	Wed, 13 May 2026 02:15:47 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e46rsubu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 02:15:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DhW4BfsPuBqtq9/3GNdAbeOWyGBIovRXpJzqxVblmcSS+Qzmq2YUnBz9XaCCpbtPSdu7mYYQK8kYmuvMzdNaMQE1E1N76SZ4Jmk3dE8+zhLzQoAJmkbT8cPB5I/b0Io6VXnThZyQy6T7OZk8AyWzHVu9dpmnnjKGoLKUyYjhr7ryJ27YGiEoVdJO/XKs3Q0N8nyGdD0m/m/ShvIKqjSJIBV90+WWqsrC2rm0qS6lDfK9CT6C9q6VsZCrwYsVUX5dlrsJSrdfMOg9F0htjdGfEE1SCrXkkE7bdENRxepVROt+efS1eoIZw+qF9nDljDzbSdMXV1bZRUiWrFxfOM8dBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/hCMQhAb0fG/d1us8hHIHvy5Htm2VsTFjMNz8C8Of4=;
 b=StWmdt5sOzsMT7r464vKJqK4oNpdSh78taZHSY3FHi6WKoCNSbLIYddkOAt3jZmb3/BKLRhozRHZSGbZNwBRBhuEHlWCdyKswxrYPC1otYcv5v7pTgr7IuEP1ns21Ov8UVsgBactMFO295NT53dequ6eEfi1Bpasl0jnePuBM+AGOZXJ0V3UlChYX+LEL/Wi0okbaHmjsy53cJqB8y+aylAWA1jn078TLHlKYb6bYPAMNlKH+0oVrzZzthNNuKUr35d2IVxFy0BtIKsmeS1aDAcHCP3XUd1fahYMCsYoY2S+MG7PHmLAJTf8gyMpEp5eGh8p0iKzgk9UYoWoLbMbSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/hCMQhAb0fG/d1us8hHIHvy5Htm2VsTFjMNz8C8Of4=;
 b=HfZ4/tI4Bk7np7D7o7/vQ2xKYZvQbV1Bvn+2OJIraE9ICi0hTMZrwLuWdlMdaG6eXWKzzaCwM0NMNaQGGlRTGIAHwHctva5SaI81lj6Ij3LfpPQ5CVyRLZhjTrUEPG2PiB6SFsqjkXFfGAWdjUzE+e5LgBFIklPun/bye9DFEvo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB5703.namprd10.prod.outlook.com (2603:10b6:303:18d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 02:15:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 02:15:41 +0000
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe
 <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg
 <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
        Anuj Gupta
 <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CADUfDZq+BZ4Xn19TXH53NndDwDwMKm3xS8wSMnMtRsF7dWSyGg@mail.gmail.com>
	(Caleb Sander Mateos's message of "Mon, 4 May 2026 10:55:44 -0700")
Organization: Oracle Corporation
Message-ID: <yq11pfgxf9s.fsf@ca-mkp.ca.oracle.com>
References: <20260417015732.2692434-1-csander@purestorage.com>
	<yq18qams3re.fsf@ca-mkp.ca.oracle.com>
	<CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
	<yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com>
	<CADUfDZqkT4g3T6uE=hxt9J6JDMXbJt49rM7_Vgs3EBPdFeuuLw@mail.gmail.com>
	<CADUfDZq+BZ4Xn19TXH53NndDwDwMKm3xS8wSMnMtRsF7dWSyGg@mail.gmail.com>
Date: Tue, 12 May 2026 22:15:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:610:b3::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB5703:EE_
X-MS-Office365-Filtering-Correlation-Id: f384917c-8894-4ed2-1205-08deb09587cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|3023799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	j2896KyPZfaZfsD2TxQCEpy04+t1zCWel85BSah5f5wmqtFRI/ZO6mgM9cxClzC3rfA+2hfLGDGmvV4i20+QPvCSNPx2LvB+dB82QbZYYVggYUC+J4Zwjl+SfWrsNliULuwS/ppLPV9fbrYbVVq8YNFBwkeQGCkSxm/kOftZjjBtaztvdUetmzcnZfDy7JCfLqqUk+RWGd+5kavdFLxbDOxJpRndhBdoaaR0+E9UdD/XUSW8TXT6Ipczoqo0edDLmoq3nDDlgGnhVjAKq39n5DdbUVPWfu6DwwyiUr4Qs/vENrkyVntx8oakT2MVSbJf4TUEc5ZnAgHm7q9XmiIM7Zp2qTaucXDPeSAgbwiaZSII6sccc4giz0ZPX9txu8f2GFIwPE/L/gCDXEOtvEe650ow35YabAK5zFu+PWRPFzMOo+9AxNZoz9jOYunxFgqYvdPw576a2hxPV1WSVMTtKP6kiit3Ejl5OfoNseR0gAwf6bPUyRZGjptG++bkmznr1gn3G98Z7ayLLP0fw53NO/UUYvxDuPacsRgtlACnv6py+1BJKrsJGUCOgtYVOD58bd3gOU7ZjzLSpEBsG/4A6hy5ZRvImMvCOMiPBwpsH240/UCiPtnqpYaZqjsl1/JtMucNO77icU6zeI57JzAn/BqMMySbeALl8zC43EtuSsaZ+P8vnKaxpMO6xyY+ZtUm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(3023799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VFasDht7SBxYsuk3rdfZ6YYFAsBxol06EPwfGpPODvCpCGnAkFH4CoFOeqtw?=
 =?us-ascii?Q?zS9pMQ699Fjt+9M7J278C1qFUuzjCjegHrUXfXAL8399cN9+SjEUXt+l8ZAK?=
 =?us-ascii?Q?ckfczcT9x9SJWSllTwxc7W7ojCsUHIKc8rOkOitaxd6hw0WRJBIDefS9fqD+?=
 =?us-ascii?Q?wJ/RKOBOhJCSmU6oVJh/TRh2NccqpKgxzY5+vP5YeNtLQdi3rN0Uf8+rfM77?=
 =?us-ascii?Q?YSEn06KVXFGdkNf9bwowkVjKQzexaH3KQ1ecX7SrCD6Jb/tMrQyLgzKC0I48?=
 =?us-ascii?Q?jyyct5GW1w9Q+MDWXBSo799wyunLu6av/AFtdWjxA2SK0Pu4wxUMMbanSGIV?=
 =?us-ascii?Q?B+8YT37tC2bojUyXVQ2goJ/hBcB3c4K2HkGBLT45gId0abR4Rpm9X7cOIk4e?=
 =?us-ascii?Q?hrFM0VYd6r1o/ZX5qfQM5kjZX5Zi3fxn4MD6S9A3Hodu60PmKBdi832+iv1V?=
 =?us-ascii?Q?+KKzTFtSkR7K1zjXpNFnXLIltVqFUcJxetqtP/qFWQUh4Tkc8dWjTIzbvXn7?=
 =?us-ascii?Q?p1/Jda5brurZ6HnlyWV7I76XO0gPmFcHEC/k0sigEVVngq4TqW0iAzrkaDki?=
 =?us-ascii?Q?9qtNvCzY33xB1k8A/S0JrEAYCzZUuO7ZHvnPCbo2C2bc/bCL5xwAZGCpFEPH?=
 =?us-ascii?Q?rVJjAeY2H13nvUy1G2uJbcJLG848pMr3gCCwNcgZz38yBEAaa8Sv/+O3XOJj?=
 =?us-ascii?Q?aOZLzmSUr5TzUB/MeLyN79rJ4KhLNh4/gwqReJEGMTrigHYQI8mRO5swmSLC?=
 =?us-ascii?Q?ztPx/PQX4EdBxxLZxA+e2caBq/GBPeLd8luDFcnZcuGxJ24G6fognNfjNf17?=
 =?us-ascii?Q?UxtzyNhw78G84gthyqAvoRI+QUfMBnP0Zeg45pLjK4Xgnzhji8+tmzgK091N?=
 =?us-ascii?Q?qjOGCDL7UhuJVcYlWY/mb6CDKJPP1sOtbbPk3yG1ppw09CyszkQ0KF1iSY4Z?=
 =?us-ascii?Q?MNb+qO9BJ66p7ywBCbn6a/Zukc6KpA/X1DACPGwopEGnArBvHJGBTOY7YY0s?=
 =?us-ascii?Q?T6ftYfnSBj1Ll+3t78yKnOdDTfbZYaA/vklFBx6IaLpMiyhJs3nb1rnaiHuT?=
 =?us-ascii?Q?cVv5c90HO+oQrPSCzYn/5zq287Nttfdv54yWz+EpIjoEgSShBfYOjbI6o9LV?=
 =?us-ascii?Q?DhpKQhXCrTFW+1xHXyZaL/H+LPlXeGJJMdDQyMEBguIsIYUeNdR5yVs+IQ6e?=
 =?us-ascii?Q?nemTNeK8wc6wTp23uW8WPnUA7kwkwB/YaMzx+ZkZj7rmh9owsdTBgG8esvDk?=
 =?us-ascii?Q?xQ4kVptSXP7m1YSspSdszCFK9+A8a52LvbFiPSEX2uWvoBWqfvf7kAMg9IJe?=
 =?us-ascii?Q?RnwGMK3JZtYKbtO5aoCduX3VDiCYJiJ74voqUfsl5k9Icfj2OXjAKD7HW83Z?=
 =?us-ascii?Q?I1t4ocvUL0fr6Yj6RAyVEHNY6iNigHm4Rw9odzufdLjzfdQFMpRt+fn/Y/ET?=
 =?us-ascii?Q?ISkLQhr1EgP4WLVrGaMqKNgdHsKVturArCwJvSrzJ75DSF55C/ZB7ZO6DWUE?=
 =?us-ascii?Q?eFHPWqL6/zyfznRSiB5fMEqse72nMITGjWsL7eI7gaLIxnBY4KAyv0RRm9ZD?=
 =?us-ascii?Q?hFuW3I88pyBkOrUZ4tWre2OP8L+bAynmt5qOtOxEuv8/U8kLR7rjyWesrPeT?=
 =?us-ascii?Q?lz7ck2BKAJofA2hvYAqPu5RMlKitbiPy2OhRRhDK11/JT2YlKoxyeSkJocFz?=
 =?us-ascii?Q?Zur9RwW6NPPzbN/g+9plvhIBKzF1fDH2NnROEVK6JtLpjOdIOn1TNGy8E53F?=
 =?us-ascii?Q?fZ8/fia/VgMXS1e/s7rugNm2YYuhJuE=3D?=
X-Exchange-RoutingPolicyChecked:
	en6XTjwg6PKzFKQT3t+skfTG4R1WU9/Uo6AfzPtxBoU6CEWp1+g81dJRlETaqtNLwpaxH68BC0eIfrQtgcqxpDfsjk2GJHMnQBMLTBloxz23YI16gOMMPsKEQRXjKktzp0KAmI2nqeH3+0BGHkMusoMTxSB1JIjzWnOxZ++2uh8tv5gRjo7bYfyRPtl+QJ17eOgysMP8IzluJQc0VmaOVGI0YY/HNC899nO5a4y9D4t/1YGlR0xk9Zetk20YstZgRi8GM8cm83QGXSd2IDg0fD7PhD85C0hwlYKg7z8rRChD29rfeYqXsffPWD0Lt4xpM+PjoqUsr1l919GbW8yqNQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ojHhFPebcRZyNuTtAAkf+iAMPm8Oz00L2KNwP8sEJRvqdwPK13G7xir05jILBYNiEbrYBiMkubdhovrYQK4V2lhfvn1dfKpi4yzyBOO6xHt/l0yI05/yCqayuGSZpSUR9ExyBLP4lgVybZLMLdxmiGKiFdM8OGqKLgA3txmfz00m/YAlggw66Reeb1GHyca4qVGS8W9Xdn3MFQjQKsNOZnaf4Vgnq8HPvn4TZ9tK5OBqBnPmL2pJw8dPRsIwXXp38sXXMjOQ+7R38+wtp3vy4pZR8/ur55tmoa9IbjQi4hNL29ybxIx0AXKeWGYQWJ8rEHck7iZXQMzC3v8n9tzx2qKySTcChuYZHBdKNFlbxmITNcsTNf2lSDLUVwXudvJYYUq4EVl2QvqhukG96W/4qHwVtjc5OEJrBKQczlD1SrHQd5W9yo1jZ1ee3oE+EKnbbCxObWd0zcgrsOKU66ltHDBypxuUTWp+DqFbfjMpb9Bz/Ix9e28UCT+LgnE3ftjYJ7qAVK4Fz9tctuXQbVruF0ixV8Jn7Tjt3pcKqgFszUMczs1AxVscYAIVhfJM/KT49coKFW5poLAljGjO+A/Kb7AMlnZp3HgIgcrjDZA2Wrw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f384917c-8894-4ed2-1205-08deb09587cf
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 02:15:41.1789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLEwOwL7FP29uoIr627a65L5CFchbk9YzuJAGRErf8V5KrHtI/DPLNbbMy4La8PEG4WJJcOOZUvZ22Y9B4H/x/B2I8b/T7ft4aKPdK6Vt08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=879
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605050000 definitions=main-2605130018
X-Proofpoint-GUID: NvTd-mpc9fCW8nOdhdYXlVj17JNd7_9a
X-Proofpoint-ORIG-GUID: NvTd-mpc9fCW8nOdhdYXlVj17JNd7_9a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDAxOSBTYWx0ZWRfX075J6j/yZv5m
 D0wvbhVDf/gmaG2ifkMxsGJIbq952QL0Iu92Q+FNjPGYFvRvOrr67dKFbpJNvE5QoG210GUczGN
 plPIK9PTKkr2hwKNDSgBTUW4g+wnDF9UA+KZoBNEv2Ep+A/u2hTwPzsfgFYTz0JUERvbDkCyDoA
 ehbNdAMh59SAS5SplPOWpc7Xm/WGGJgjfXAhAMJ+sog5k50CiwxXVxMUnS7bN5ONy8DP2DqDLum
 rRUcHMFzknJymvgMzVuDhFtW2KYjl2EcuKcPFM8s4WWA+0nlJgtioIJZUWcqT2DscLWIlbZXKWU
 Pt9g3OLjB796XHxiprvrQvO6/BX8nUKQVkFj0ZwGPRIdlaLr17/aljg6zLgXr7b71on/vz2yjTY
 gXN39s0EwTNx/Ytn1kc0aH/hg/NFu7QM5IYZhln8I9LrxFDBbTxi48imGWszc0IUEhkA8egd/z8
 fYx0gS8T/G0S8t8i5kw==
X-Authority-Analysis: v=2.4 cv=Cq2PtH4D c=1 sm=1 tr=0 ts=6a03ded3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=8WQBuD5X8XmColxuBEwA:9


Hi Caleb!

Sorry about the delay. Been away for a few weeks...

>> So seems like patch 1 ("block: use integrity interval instead of
>> sector as seed") doesn't need a Fixes tag. Still, I'm confused why
>> the auto-integrity code bothers setting the seed to the sector number
>> in the first place if it's going to be remapped later. Why not just
>> leave the seed zeroed?

It adds a bit of extra protection in the sense that it there is one more
parameter that can be validated. The premise of the integrity
infrastructure is that things in the two supplied buffers (data + PI) as
well as the control path (bip in the block layer case plus the SCSI or
NVMe command fields) all need to agree for the I/O to go through.

It is valid to generate the PI starting with 0. But that is
indistinguishable from "the seed value was not initialized".

> I would appreciate a response here. Would you be okay with patch 1 if
> the Fixes tags were dropped?

I am afraid I still don't completely understand why things are broken.

For writes, the meaning of the bip seed is: "This is the value you
should expect in the ref tag for the first integrity interval in the PI
buffer I prepared". With block layer autoprotect, the seed is set before
generating the PI and thus implicitly affects the generation.

When the write operation subsequently reaches the bottom of the stack,
we will check that the first ref tag in the PI buffer matches the
supplied seed value. And then proceed to remap the ref tags for each
protection interval to the target LBA + n since that is what the storage
requires (ignoring the odd Type 2 interval mismatch for now).

For reads, the meaning of the bip seed is: "This is what I expect to
receive in the ref tag for the first integrity interval in the PI
buffer". At the bottom of the stack we will receive PI from the storage
and that will contain ref tags matching the lower 32 bits of the LBA
since that is what the hardware returns. And we will then remap all
those ref tags starting with whichever bip seed value was requested by
the caller. It doesn't matter whether the requested seed value was 0,
10, or 42. The ref tags are remapped to whatever the caller wants them
to be.

I tend to think of the seed as a register you program with the value you
want. And then hardware or software remaps between what the storage
device's protection envelope requires and what the application (or in
this case the block layer) requested. With SCSI + DIX 1.1, the seed
literally controls a remapping register in the HBA ASIC. In NVMe we have
ILBRT/EILBRT.

-- 
Martin K. Petersen
