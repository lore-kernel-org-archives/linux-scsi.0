Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC151E1DE9;
	Wed, 18 Feb 2026 02:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771382276; cv=fail; b=hK5Dxrywg3J+Ea4HqI6d8nNYuIrF4b+RZKZuzxX2Oq0e2E942QDAxyv/YHpRUKYZeHNwQ4zXBfTcYbpiIu7Pt+zshUsqvKIOJmDa2DPkFQqkOEATE+4ilA2AYj8cmR8yV0DUahAsXyKFuj0lk/BxqX6r23BsrTGyJ5OZmXbGNrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771382276; c=relaxed/simple;
	bh=Y2k9R3nmH0uRkQcPL0Yv8q1s88VNhzs0tZAGuZIqNW8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=npfNvlmo7ScrSL7DkagbOO5QcX64apImIIYOBPfy6KrW+QPgMYbMvxCr1Qhu9anFfmp89smst+K13o1mFfXeSAeZCoCCs+eIql+JFXPZvaZWHhO/S+xOkgVvKAcSyxnESTWfq1YC9vJu8VXKPOMcdJXhIqwosd8OICqkDAsZnkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iaFSuwOk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R7nlmk1n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iaFSuwOk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R7nlmk1n"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNJS3026216;
	Wed, 18 Feb 2026 02:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gEx0/wYT/9Qj9Vem+t
	MDHFSH/KubMevC0542mYII9iY=; b=iaFSuwOkCW6Vu3N/zoZyoDnUoq6RniKSXH
	dmMRsQbEXcLelhQIkf1270wrAAnnK+XrKUaTGSoOpzwfP/CmqziggG1O26pOs6Em
	Jzw/jAaInaLVEceEmq6zZ2o4i6PJ2pXZXuGbEzQe3VfCbq1d58ZovEZgWlFrVnOs
	ZqrJn3Mhe7uSUTXhohSztaxL4JMuW0Q5STjtwJk09vH3D7oLzmZV8r/75ph36NJV
	BrMnTI+RX1hwCA+2ImmgckiF2VhqWSNtcXJ7axHaRh+lkXVwb1uGFPJTQ8LOycQG
	070Af5/nq3Om7ax5vyimS8sgRRjj4PDKNG/W9/efd4CXmOkTOWjQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0rcsym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:37:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I2QbfT015049;
	Wed, 18 Feb 2026 02:37:51 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010016.outbound.protection.outlook.com [40.93.198.16])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb22s85b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:37:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=blomd9bCHzW4XWYNyBbNH2/6nYQy9FWQI4b8tAs1+5tO8lH4emrVEE5fxhZ8eb4f7lB5h6/mBojkTjeB8BzlC4kw2981Gj9NGgylFRl8ABQyy9QwKS162mt25dXEV/yMkXNu/qKOVv8n3KG6JpivsQCDdF8QgB9TIAEIE6rw3ODjdZJeuV8vdtcPSHaVwR3CPuWwwD59xRYXO8uYwQ8GgMM1NAvbz5zj2lZ1z6RzbMeoH/1ZoCa1HVPWsIYfLX0uMuKsXuEWbf1IlQ6NgMz3ENz2ABfSH0Ts5WXkkVivRM/VD8cEIo4VoP4whbz9SDnfuOaKpSyGmeU3LRx6yDTYtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEx0/wYT/9Qj9Vem+tMDHFSH/KubMevC0542mYII9iY=;
 b=Gk+SyzWvZohIf4ZI8saSlEG1mCkOQBjwpKI8nOOZmliJKv8aUTDuq6oXN43iOVRfmW128S5TGqMHT6iI30F2ecwu9RI9VVl89CataJp9gMw17Pw64FChGGwWILtU371+fsduXmF/Q9nLmbVtBpeR9NvfC9JgNIYAeyV0OpLWDCBifLEUeH1mWq+mrjyjJBOMw8E0+K7vQ7Qnw5E/rksLRzk4kId34k1ONedZFoy1+OVh/9RsS5btg0Ky4hK7ztDxqK+/IwJbdQesAnAawbewDXm2r6SPUwmQGEUxkC8NIX7SnrNtplpzzvlP75BpCq5IwEmYa+IoNcm96YxOxlWPqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEx0/wYT/9Qj9Vem+tMDHFSH/KubMevC0542mYII9iY=;
 b=R7nlmk1nkhGef2+HAe0iuKTbz0fdGSBXiq/3Mu91d9DmnE7JGukimDgchFIVK1oS0LO1kc5dt+gp4GEiCNIf0A0kLopyL5Of0VS71pXUPpFVRKy98YBrovQkXWsxyF3pmuiBcg1VlktE0R3qIGVf0GupXJMHPkG7eHUSEHPthM8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN6PR10MB7492.namprd10.prod.outlook.com (2603:10b6:208:471::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 02:37:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:37:49 +0000
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela
 <sebaddel@cisco.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Remove unused linkstatus
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260216141056.59429-2-fourier.thomas@gmail.com> (Thomas
	Fourier's message of "Mon, 16 Feb 2026 15:10:55 +0100")
Organization: Oracle Corporation
Message-ID: <yq1y0kqdbf9.fsf@ca-mkp.ca.oracle.com>
References: <20260216141056.59429-2-fourier.thomas@gmail.com>
Date: Tue, 17 Feb 2026 21:37:46 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0016.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN6PR10MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fc67519-43a9-4042-b7c1-08de6e96b4d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pWBbI/Am5zae7PSRKEw+cBgxJvKq0/mpmUlYD3+cWWfhstWVjxxyq1iCZzDO?=
 =?us-ascii?Q?vwicHgf9+Q4wTuMQKpdOSctILaZxE60L1Kssr3Jdbn+FHkLJ3GJqqLMEe6hC?=
 =?us-ascii?Q?+g+mkIhfjGCw9lj0RKJ3zN/qFGkMl4xZ2c8o99Z/JFIpNyki8YxGDRtsFkXS?=
 =?us-ascii?Q?pJktGNnXfPGInBpy33Tzj5jkQS5a/Es0YIrq2AcjLXk1sIyXT1DSy+osaduW?=
 =?us-ascii?Q?3YhzsazbFwzeESUdecsr3tXgID6mpnvGMyNErdUXLfjbmZC9QXXmv9ITltX2?=
 =?us-ascii?Q?8SNICx9u/h9SbZzvdPbC6H636RIySABEfLAJ2/AKg6D9leSUbjgbyk1bo/J9?=
 =?us-ascii?Q?PfbubKdVIZwD7L8qXOBBWYPhAQ20Zr8rLS4BvXCFCZLeCy7h1Vsq//uzXaI9?=
 =?us-ascii?Q?oIuWCAGTq8QGlsgqc66fekShlpzoP3jg+BhDu1ZaETBVeZD1Ejz3EmSUcmS4?=
 =?us-ascii?Q?YnInDLS3b+QTf01M2IIeTy8fOyVN4+lgolLt672z6xmvlTVXOiJbJaz0i0ar?=
 =?us-ascii?Q?Sy4IOHKlYAj2Yt5HL9JX8z19KFAtdm+reWTgPVXIataEGopbPtXdG0HmRw0B?=
 =?us-ascii?Q?pfmxdSERhw2ZiM1l7X12erzTqclU2L+Rayr42eFXDQP5kqb54PSIO1i/IuRo?=
 =?us-ascii?Q?KhThwMj5x8msZiOMBBRSEiy9Rep9IHKVK/sNiL6isbOdT0eKLkHgt147XTrY?=
 =?us-ascii?Q?SgvFaZinb4Voz3ySdY000BWSWlZy//3u9RSPg/CciOOORjkPZP2GErppXTLa?=
 =?us-ascii?Q?y0SVEm/JC+sE5BQa4SjDzlnobcefIBCA9t7K8m0mAqIPmWY/oylCYGDLbuoM?=
 =?us-ascii?Q?WBHwcht2tUZx52iSBz+kSjkS676oDApQ6IsiQuRqPVojh4QdXtgwYlo3PS6i?=
 =?us-ascii?Q?BBcMYxCD1gIAvA8cWP6IwP/ZXFNXoycJVjOgjwZVgMi2/0WBM3KxJYh7dFF5?=
 =?us-ascii?Q?NLqngu4vCHWPhGsRClpnbPDCnn0n4shm/ElrEAEqVX4DtGlOfpibn0QtMOmV?=
 =?us-ascii?Q?0/iJWQruaFufoyjnYJ9FPXSEKhoVehNKASBEAIM7aIvmVbOSjSwdnJZRojf9?=
 =?us-ascii?Q?B7gjtr7xqRr1cG2iwl7fP/Hp38fuiQgKJNs8LLMbnIv7nPdMwh0Nq5m+x8j7?=
 =?us-ascii?Q?9+9V9X22HM6uPnFfuatJ5HohN885/ZEay0T4dyCtsU7esYVvy0zUri//BAHR?=
 =?us-ascii?Q?E9i//K4sadGx/YoOAOIJCtWDBjulqt1aq+ZnqeNmsO2WTDAHaqkC7RRtNWTH?=
 =?us-ascii?Q?jL37J6matoUCmvicb1Mmvmam6fm94f/S7XlJWzTeEAlBCEfrk0UarY7Ywzb6?=
 =?us-ascii?Q?hKL+bT88fhmPB1jh3F8SmuChKcy3B/RIuv4gK9x8j5lxDOcj7LR/ZAE0QQ6y?=
 =?us-ascii?Q?ZmfMjqxT8vptw3CXK9i/HgyavoEuWbnLNeMSc50rW/1oPCyDJdY+TXIplH8x?=
 =?us-ascii?Q?ByL8dOXrP63Ulz4J7xopoihJz0LNUOvxhL7+SF89g1AMo0w1d8DTeo2UJ5vU?=
 =?us-ascii?Q?4bHtBfjAvg12sc8ilaJ+JwvdIpluxKd49AT3Jh+sTsrTrhhBTZIz7mK5bFsv?=
 =?us-ascii?Q?tTifM/gEzpTSVCnTX/o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fu2HuMmLKotxQW/qsgbOlYxVD3sjMRoSxZI8pEzIAy9kVEIfjDrUrUUrMKDo?=
 =?us-ascii?Q?R8BncIY5wBb3VzLlxmyVJ5ChREKGt5+/wk4GFoSFtN3Kxw443CbfB6qvHcyD?=
 =?us-ascii?Q?F1ajQwMPefkus0mCP2UT2XYlhd4mvyA/fdMqzAAeoqPpzcV+a3J8hm8dAHAV?=
 =?us-ascii?Q?cdE1wG0GNQCS+dCdQmFXNqCbQkKkl+CnE6Wydt61Zs7tSoOM2HdM/Mpzzout?=
 =?us-ascii?Q?5l8aGQTsPn+XMR2M1UZbLpiAFvY141XHnJ5bQTrrleB8W7c+JvAaXp8yVkYO?=
 =?us-ascii?Q?aID9zU007j6ZORG8l3kaCsLV6r9Iu+VO1Iu09zDkQY2mWioQvxu0STRPa4DH?=
 =?us-ascii?Q?TIAsfsNKDVjWJr4XzcVmP5W9ub07KF0Fo2f8SHDv3Ue5aAqj1/irwFrHARHM?=
 =?us-ascii?Q?IoTbqHtUunsJB+lN8QXu8AIqcep1GFYf1hm1vnllwW8r1bsOWysqD3XlsDVw?=
 =?us-ascii?Q?QmlPHl/gst2yBKP2g/2Huk0+o8a0GIthWpavv21dLQqaUN2t8/l/Xs0C0lUb?=
 =?us-ascii?Q?WLGh3X/blW2udsLXSxjRBkeANpKHxRI6u9aZ3ov3nH2PBDz+Zg1jvMppF4dl?=
 =?us-ascii?Q?FLIwQGivgiH8gYWIP6QlcJ7LmQP5JUicY9FNOy7CIHSSWecEjmyKvwkDUG/o?=
 =?us-ascii?Q?ZkOPoT5eixA5c/M0K41BVTJ5UlUaZRx5iWmJXLRHr2Gr5U9kg4/tA4NEscqO?=
 =?us-ascii?Q?uol49EIPoy7th1EQDQdLXMCtBb97cyX2w9ORXiBs2SdQQ7NnvjQbhU7pLsUk?=
 =?us-ascii?Q?vJGUYRc8Wuc6hEeLedhs5aRETBS9DG138ZG8kIDZVqHdpQgz80cn+IozdRtm?=
 =?us-ascii?Q?U06xuhVyTOn7zflToQdXlvcjyI75yRRs1+RqX9YNfMqrgpYde5BeSZl0BRpY?=
 =?us-ascii?Q?QBsheGYI49GDF/sqQRCzRL8Hs35r76ScD/oYBpIW2huWt8V4ANSWg/AItxy9?=
 =?us-ascii?Q?3eLEWgutQ+z1A+B0j51qWLaj3At+b94ZIMv+a7bxbldJd1tM6X3PCbT8H65z?=
 =?us-ascii?Q?dw0jSrkHFxOBR5eOk5TJC5xBp94+lM+QPvi4klFvl9jKRXWi4kOmMXQJOHO1?=
 =?us-ascii?Q?9Lzf36rkTr+zK4+9CmM4JoPG/MsJqVmg0HaY5pD8m1+AY8UA2P6BMUEwBlF/?=
 =?us-ascii?Q?OyErSGZz0s3zI6WmqKhrHlUk0Ofwd0n8WtyO823g893X7RWOaL+CJFWXPzO5?=
 =?us-ascii?Q?ARRXcisFvWu5X//fvH1OCaOjy/mVatK8ZF3gcgHRlFuvyrbLz1wPsEmr8njJ?=
 =?us-ascii?Q?QbpUc6xqUR9Yh37GNIZAgimVTos5wURt9T8UhR8HYW/t4+JjByHt1d++S7Jo?=
 =?us-ascii?Q?WO2D1CnkZigad4SDOmPCJIOfvw5eTK8strCkLqJestrtAsIuY6Cg63NA9hRV?=
 =?us-ascii?Q?C7QTQs1rJii0WkKH6tsAl9mSwkoq99MsQwMtjdqp5kd3Qx/BjVR88VX/3Qvf?=
 =?us-ascii?Q?sc+iOfDTZk0921Y+oQcVdlN8ZWAnI+9SbvmDrJ8DeXJXp0ZbkFXpm+L8ceuH?=
 =?us-ascii?Q?qn0w6VG099WNUOmZvaHpTa6idbqm17VPDMAD8pyxKNQWI3S5W6QP+sQqm4Zn?=
 =?us-ascii?Q?Wbbp6dHmG/E1LGbv4VpaZPkiAjp20gDg+sKFwUjxBliyFAb9ad70uZmMbaMU?=
 =?us-ascii?Q?00twYeyqwoo/BMBvlJ7nJn8y7X4lH+dFtK9nlzmusQkjeZHMEFX9v5JM+kOz?=
 =?us-ascii?Q?sR4mXyjp3G/FEcpoGbNGh+mZt95sQWJEBnBIFHC0ImQxnzRKhXq0YbmSqIRf?=
 =?us-ascii?Q?ffEZlSfh3QrmKBDYyJNHWvhQ8YLjeS8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sAlIDfBMbcRZZHdEaJh5vQAliTOJJs0TP+JW2Dn+cfI2Zpw5R6nPzGAz5zmzAG/dxl49N1P/+LWSPPpcA1ULCmBY27A9J8rF79FJRXcQ72mpARuNz65otNZ0f43Zfr4AIVGSJLJGtRv7IUOB1nGuUHPSDTaTv4bQSKLGQmFvtzyhG8A86xpiGLhq16TLJgMwAcZmdN6c77TnfgDzDpYZVAONJNUtdkRVPmcBCx+ErHTNfadAmVbQcA31+5olRMhAUhGNb/qEubMQx/4Jt85wdb+kphxyygEYratFJxm34Ahnk6Ca4vAUsDfMoCzrCZAyX2Wo0wxDMXfNtpWSTtJxueWiI47HHvq93C4oo/3vQ9vOS2AGnDIyG55/Q42v8bImZ52DT31yhkW3EpsJMuIdpNcgxUlYQHKLjB+ptErRhvPx76hMh6B8fU7V1NkPUz3MATy8R21k6GQhM0uSX8/N0+sVQdfR+ygSHo9kGa9O9OXi590QLjsv6r8863L5cKkLqQXC/crhv0qIy6ibvqmlmZnJ2hPrRjFkXhLb3UTmA6SBWJZI10DBQV/ngoc+7WQOET0mkXKAkmo0wKukVWh48z+e31rseKeySbP+dKrOJWI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc67519-43a9-4042-b7c1-08de6e96b4d0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:37:49.2075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+NAsnsOR+BhGsuWzLjpO6pb2YRZ/NOFCo3ddxaoNOTkniXHM7uja/W0Du9yJhzud0XbGeC+HmPbO6TyUfizuy6DnQuychXQvCqciO3M1gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=874 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602180021
X-Authority-Analysis: v=2.4 cv=V6RwEOni c=1 sm=1 tr=0 ts=69952600 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=FypdnLkI3WuhgSNUjt8A:9
X-Proofpoint-ORIG-GUID: ychBuA_T4jVZjFdWAJPUybQB2IZnfb_q
X-Proofpoint-GUID: ychBuA_T4jVZjFdWAJPUybQB2IZnfb_q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAyMSBTYWx0ZWRfX9SJlsFwf/9/7
 9JukVsGzoEzEDXNafuGk/Yc345fHCNINKgkCImhmgiWLDY6qVO+BKwOVhW+jJ2or7jPWdgDUTy+
 k1cj4Z8/89aOmjNMEmzUU+sAYOjBDGR3XlKJ6jZ203XLd/s1lrEXS35pLjrGHsSeoQL2uK6n8Jk
 P8ARG1n2iXBUkqws07U5eSmoCt09rY7I4bcPeUjKbLqm13WssjhzdVRD3b67AqIIsDwk0V8A845
 P/cvkm3aAwv0eku/MYS4jyEV7eaRiQHaxWVdHH/tciGpqXtEpXYsvQR7L8iYzSNrn33Vh9qIMXg
 WmwOthP+Nx4Mm56aPDKlrzUijvSKhdTkov0dUfsZd8BrtOa+EbFQkfu0NLEJ05UEezlrKwyAt0b
 u41t3ZZ6Mh9fHZe/GiKuoGmgPcFhhFbcdH48wrIPt2jcxDFpAAW4eWNxC4vMB+Grz2tyOWjtKva
 E6LdlAxTs/ltSuT8U+Q==


Thomas,

> The (struct vnic_dev).linkstatus buffer is freed in
> svnic_dev_unregister() and referenced in svnic_dev_link_status() but
> never alloc'd. This means (struct vnic_dev).linkstatus is always null
> and the dealloc the reference in svnic_dev_link_status() is dead code.

Applied to 7.0/scsi-staging, thanks!

-- 
Martin K. Petersen
