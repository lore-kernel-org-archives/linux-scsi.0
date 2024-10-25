Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC3920C324;
	Fri, 25 Oct 2024 19:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729883049; cv=fail; b=EzXNE2qqFp+3KwJaQljN8TQ57S0mAp58kqXRizcY/FRUzUlevmZKHYvD4/d34dfScCeQD03pan1cBFoJnH8OFwdG+y0h733eIKhEbCDDl35jGv5mIi/2UZFAURPLe9Med4K3ASF8LpNkGx+dm0TStSxWxvEON55g3KYHdzn6sy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729883049; c=relaxed/simple;
	bh=HpqruHUTz29bILjEb0N6e0QwZwHxSs8VpxcztVIZTsE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=MPicjxSDnD4u5yOrH2quLUzQKk3tx3jne7wQhIkvfUrj/vdCs6k5pbWlYR6M9dA/+e8Darv4tjO0NVxKQ9pkH5azxwTrCn/xczvekjKcpqEGwO8YFRB60OHVtI5/L73UXSEu5BeJchpDX+vRPxDHQUumVsqln1hSrTxK0CreEfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lEjW+fXt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=beR/G1Wv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lEjW+fXt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="beR/G1Wv"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PG0nC2028210;
	Fri, 25 Oct 2024 19:03:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Li0cbKk5jJ6MBckyRl
	w6JmEZK1MdfEguecK1C5Rg1/I=; b=lEjW+fXtDy2MmCrmp6bIMMrUFX2XRoNsYK
	zmuxLCAeVFCXBR74zBNm2EZXvJ4XoP+OE/B4JO8a+AC17njEMRjtiwWnYyMM82VG
	kvuB9pA3JlMZtOLj5kEXvLVLo3X9VLsgv0Mir6dEvEbP2ZiQP50SM8d5rwibbYhi
	Hv16q3auom1Gle20R7uTctSQ6KR6PVooJT6KNLVteFU6GetWFiohQ+qXCHmc5v6J
	z6rkMOH36Z3mwok9o9/LE54n6DoGny7/ny9i6IzDRqrTU0BQNS0eooK5GWVcvPCC
	qo959quu7+DTmfXD/KTDBYcFPmTpHihFPJjqOufspcI+OpiDZN3Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42ckkr4x9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 19:03:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PHdako036700;
	Fri, 25 Oct 2024 19:03:52 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42emh5pbfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 19:03:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T8MFwcVkZUvIlnTHyUgeK+q1QV4KLsYeEGBFokjdcCkusDxW5nuRbSQ/1BrXf4LkpOJwr1dPJ2VqdC7Y017UZ0nuw5mh96vYVUkpIQRcoUpXoyohGvALWFOGhoOwBjzomgAcdKbc1/9Sp6S3gqrF8r9+G874p8wEqP1EFSiGXI2ZuShmRMjJyJcq30+l2yib6rLUIZ93u+AaWbp4tkzr9q2xTipcgYhbVsaDgRzIX/QsW4AB2mMR8qeM1sL71dLtRJUtkrnnFDMakCpbj+DB3kNCp/wWJ4GozsO+sGeNCZnjXbixs3EQt7mzuwhYMQ+ERZ+c20GlwwwsKXQF7jKr7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Li0cbKk5jJ6MBckyRlw6JmEZK1MdfEguecK1C5Rg1/I=;
 b=cpsKLaARZ0uhu5Fb6x2/YzJAr8cNUvxCjyOelkoqBG58dMk9GgcBcxNPvBIW4S8UIfrYAL6P1od1BNW1Ms+EYVpKb8XBEohZYh0eieSOYbHHBIr2n7z+OqurqsRRH8LcHkNMAN6zEVFYOPHfrtMsGlZreHKvWGtM0SGFcPiPmfeVYOvSajnlPVj+nJzWwPB9nP51sYxrvSa0eUZClj8wqSd1SYDs+twZNBhS/hCN9Pf7ap5FiQwgaLUaqgdAEbhT+Wlh3cADwSNlOzoiFFPjf3gcA+DW9RiCsPffTjbSO8tXEGSYoNuAptJmK5gta3LzXoUQzUXZZQGcGpLYoVrPrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Li0cbKk5jJ6MBckyRlw6JmEZK1MdfEguecK1C5Rg1/I=;
 b=beR/G1Wv5426UnNC4WDPPj0bJCXqgjkod3NMZlC0y+3DcFvL0wuU/WDL3Yqx+NjnMvmx5r/RslJ1MzW/nCq6/Td7BhxNLA/VZ8SyygKQE5QXxcLuet9rlAP/PFAs/XWHgPACNBjVI4OQf6jmGhHkoo5qyraX2rmbOXYtYnGPU/E=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by DM6PR10MB4186.namprd10.prod.outlook.com (2603:10b6:5:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Fri, 25 Oct
 2024 19:03:50 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8069.018; Fri, 25 Oct 2024
 19:03:49 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/3] Untie the host lock entanglement - part 1
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241024075033.562562-1-avri.altman@wdc.com> (Avri Altman's
	message of "Thu, 24 Oct 2024 10:50:30 +0300")
Organization: Oracle Corporation
Message-ID: <yq1seskdmyu.fsf@ca-mkp.ca.oracle.com>
References: <20241024075033.562562-1-avri.altman@wdc.com>
Date: Fri, 25 Oct 2024 15:03:47 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0217.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::12) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|DM6PR10MB4186:EE_
X-MS-Office365-Filtering-Correlation-Id: b0b6f0ab-e0f6-4c19-a17d-08dcf527c28c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BdwW+5qdy8xF2apFwAxe5KE6LDFNtk5CjaeCsTDQ80Sf3vM7EEtviXdvRMvA?=
 =?us-ascii?Q?+SaWpkI+VET2FDNkB5fmFtCeHSK2oQmvNFoNFjbCMjoxTHbVoMo5BtgUrwxF?=
 =?us-ascii?Q?Ii4DyI/W4Jp0/b+4D+jOAs+/hIHdMQwyARj3qNkCBcROALtZLffPupDIQHZH?=
 =?us-ascii?Q?1+k24NhPPlsfogyXQuHpZYzFlf2P3CvOnzHC/infTIDjCFbg0T4TweUhjDtb?=
 =?us-ascii?Q?IaKYiydYJ9ETr3/pHMDMNHo4ZD5d9lpUi5vzkTUVSnlMUs3aULwhzPh0TSbS?=
 =?us-ascii?Q?OB1e458gODAJrbRqN6VEvRX/mxleHV+uHcOWj5STaHeUypb7SQ1S4WRHP8P6?=
 =?us-ascii?Q?33D38Lzk8tDCaRInO33Lk/hquhw9cWCr+jUmaKL1VETXrmTyCZ2t7mHOyDvV?=
 =?us-ascii?Q?HiiI+fzPg6GUX+bcKU7krhFVF/HolCufjSZtf7FUDgxfAE9Zq0bcaDaEZbux?=
 =?us-ascii?Q?K59p0Aiw24ldd4n+GQBkI3thu4cQNBVPYliurMcz9qIbqKF4STD9ZhwIQ4IS?=
 =?us-ascii?Q?pAFFVyEBjIlpaQ7rxH4fbgQgjwIsXFPkEKk7aUPaR7LO90z525YafcyeJFxy?=
 =?us-ascii?Q?d41xfA1mLDp2K6a28asqWseaAwSX90SQu5Keq02S/0lnDBZhNWa2ZKDzxcnW?=
 =?us-ascii?Q?hmuXO4sxLvZyY5izuLnUmzFV5NbsVmLphveC2RwbudKVzS67mbV55xCvn6Wp?=
 =?us-ascii?Q?N74CAerCbJ/T3SBjJiQQbepWLYkPZemdJhW/0o3UrULLGykQwVHcHWCA3v2N?=
 =?us-ascii?Q?1tzczA0dky97tBrINqG3yAr2d3LEup2fct7t5uUNKaUPmJcsomkfUO6wOVLY?=
 =?us-ascii?Q?AnDNtlyQo2fJNPbl1dpqCVTGmPnpQpPzoXgqsfHvV5465vxSrSqgYwYcSv/R?=
 =?us-ascii?Q?Pult9CStu88z/2RAXSq6Mt91LMDtnr8M8o16LuvbAw91d5lVQONZWvg2K5SX?=
 =?us-ascii?Q?17ZWmKQqnooXxeJGul/TSiuiTpDUWpql4UGsIarwkCqeEaXKpwbsA/AVd9wB?=
 =?us-ascii?Q?X+ssGsZhIadZbNRGCNZAK9UpYnVkIGEnTGoKAalsowaTTu1idy/08xD8OuMZ?=
 =?us-ascii?Q?pgIa5Qcm+m3VOtYXsJW0Kvk+8obvH3sszePoxWgOsJtqHTOz3PB+LrZPD8PQ?=
 =?us-ascii?Q?HIfZYnJQZuJtHhT8GsXBKM0RN1cBsvVfcypdggsyBnPn5b9tMKUu3lKEP2B8?=
 =?us-ascii?Q?BPGwNqQvBL9KQOZ0R3lPb/09YrIZV8HFj2uGTfB9jj9siNNJSuI3YzxYb/lj?=
 =?us-ascii?Q?rgxv9NePhUbSrIVKQbTebnZwAzWNe/rwQ2st4EW+PAZAvFiE3g6mTicNME7H?=
 =?us-ascii?Q?tEXWG1Ntk21vAItTP3Uh9I/9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZViAQapw1p+cQCOuzgP3cBK57oi/iApxgK63jldvumD1D0vCP0mACyKH4vTd?=
 =?us-ascii?Q?Idg5x6rrbjaDGevf8Mn+dweH3Sb+VkGBg8+VLl6d7DdrlvnVqROCcApZsU/1?=
 =?us-ascii?Q?93uRbSzcuVhIerLl6X4GFgV1m6v7ZMYjBj4gaO3vVHQ/NuH2s5e37qgq+JKi?=
 =?us-ascii?Q?5OAm1YFdIOXmECvpbKzDILOjNjX5U93lN7aNoHTKPuDp6Zt8myF6Gqk/ZRG2?=
 =?us-ascii?Q?iZZCHyIY3UsmkvdJegNsTvSlNWq+cWIP1M+4hK1GSh2qx3EIa8LX04ja0621?=
 =?us-ascii?Q?UFgK/SviZOHWUGb7I8m599Jqx3g+TpgLmAayHY3LYJ6Rr4GSspXRRPUkL8DG?=
 =?us-ascii?Q?m2KjlXcKH3H0yJvu9KZLYNIf/thtIg0CLUDu/CyNLbWU7MYJ+UK6OIkK+JXR?=
 =?us-ascii?Q?DYUioGI1ZJxcVzqCmGhlaX9/O7sopOf3tTPFjSBkfr208Xtch+sgwehxu0LS?=
 =?us-ascii?Q?u1ajFMwJ9TBF7kdJb3QocgsBlXb/IhzGEv6gb7prwdwCBfkFxCIIKl9K2+w6?=
 =?us-ascii?Q?hxd7UnBAYMihtPKXB8rYcxTtEbNzeViUHw+XmZGTVe7FRa87qI3S3q/ApC6r?=
 =?us-ascii?Q?l91Iht65pnZcOqMaMlO1YO1y9jmNmDv3kjEWnFAtvYEHilHjSw9MkTteTyH/?=
 =?us-ascii?Q?lwp9ntaYzjGC0KaWrlPaPd2n01/jZefvoTCdd203LhBzB2Z/bUpGTkwtuezm?=
 =?us-ascii?Q?ZwX9E5usfpSXUzDw8uww1LhLR+wXw9ydRje+ivLpTpRKSDeT7ZeLrN45M8Sb?=
 =?us-ascii?Q?XIhFefi1nXM4FxGxl7bJp3YjW+bWFeybgLhJVUzCt32QOHU5DNkQWim+dd08?=
 =?us-ascii?Q?u4YpgjYmxSxuL4hP58Ct7zoJ+khLaJa4r1xyCZIbP9H6+N7YJhPzflyA+oBM?=
 =?us-ascii?Q?hnh3QF/hk6zNciK+kehqkV7a8j+G2W2kIbo+RPBumtv84p2H6iYcZjPA9HK2?=
 =?us-ascii?Q?A6ev5CQTnHXkRkpLTdUgDJMWnXM6OJuwNqZg3ar1riUXV/Fe60YbWW+9VmL3?=
 =?us-ascii?Q?qtCx6CgXZVybFd8clVUGrD6nhb9RRKgHttDYMtP+BmZwHUoTn75lcCUL6XnO?=
 =?us-ascii?Q?8y3x/MOvya2LjDg58yFiJjQRd/fULK0e0j70195W4KvnfEhBiLOBXpHUk2q/?=
 =?us-ascii?Q?Of8keafI9eBVTBvx+itRk+1KMeYgKYBc70oVlGMeORLydzI44QQ/2qWGrZX7?=
 =?us-ascii?Q?nCGEQVGlourtmtNT7ey9/63S6DJL0Dnaph3ExsK1YMlB824EAdtB7WyXJQ8V?=
 =?us-ascii?Q?QRJUPp2vhS8xoG8quuRqAYgtjD3wysM+lsO8tgcKbZ5CTzN5l4FBEb7RTadt?=
 =?us-ascii?Q?+s/fdOUuk843LgI++D8TqXIxDq9jWOIRyozXkmgZco1xA8pySjIwsqNV0E9U?=
 =?us-ascii?Q?4Uf+zcmkZdY4J/z86wqq1VnHuGXKMwR1S1I+vS34Q/fMSEm1PbMZqLeYWCcx?=
 =?us-ascii?Q?tCLcK2KS7UK2pa61J+0bO4RUmxVGnkGw3jIzIfXbn+uT8E5G6qs3taHeZMX1?=
 =?us-ascii?Q?nnaLSVz0k4gnTHcFTDxB0hSUy9QoJ/2M2N0f2Z9VA8j6zYdPiTy+DNKIIuwQ?=
 =?us-ascii?Q?3hO9ZqEFvnd4cU9R8rQyDNoL9ZVTMb+ieI3Tipvrw/EHPVHuXldUK0SyIy5I?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YkTOx24mQ4mRwojTFer7qxe36qP14yjmBWD0hn2GvfP0tSiIITYEoxpSYOeUge/8alO6cUWo1qnkM13BGErYE2VDvq2UaXOGHGH/lShN7+PlsNUKF/8d1hcSBkHShh+Axdo1POKAdZLDogDpfSwlGk2U3wze8+D7AJop3M3P33+Oe2iKD6Xjdv8KEzYaJbxau+i/9PPMJBM0SJi73x0yYigcIO3IhJMwMBkTj9vhGzUlQdwLRYo3FXNSnBDGilSW9HAB8+lLdugpv/tjwoYHb2Yr+jy68m2E7vJRRSkWVNEZ6kHXYm5dcwFigkPxJekNEqHaJdAo0EQWr57PTPft0m7zgd8VtyNcZ/SE9V4rd10YSh3oklKvVODzbe29EPtG31bX7Bxs06IbUWbBf2ze13nWLq74FTrQPYMx0PQjYzwmLAicQOSsX4663ykQYQdvUvsUpXHJpOlGToD0CaE7ArmtBeVqNVwaGkRH4MbcMI1StZTG6iS+3iLFfubon4WIB6BMMDGJz2bCIJet9K2JYEDfyZWm3PhlmAAmKjCs8A8Ueyvf+IUW9eSi4TW8oCgisGOB8iwIslt4IVO+87hrPBglhJkHcFgzBoVd2lnAdRI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b6f0ab-e0f6-4c19-a17d-08dcf527c28c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 19:03:49.8038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XP+5cf6HLoBQsHjXj91dctnYqqhDh6Uee2352/fOov6w2ngZhmLNor+6dOZljTH3nuajKMx4M9gaLAUJLs1pzSJ6xMn8myOVvGlFssUZsJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=985 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410250146
X-Proofpoint-GUID: T1sGh20yLvAr3L3fejDtJ1Ux9cK9pFoB
X-Proofpoint-ORIG-GUID: T1sGh20yLvAr3L3fejDtJ1Ux9cK9pFoB


Avri,

> While trying to simplify the ufs core driver with the guard() macro
> [1], Bart made note of the abuse of the scsi host lock in the ufs
> driver. Indeed, the host lock is deeply entangled in various flows
> across the driver, as if it was some occasional default
> synchronization mean.
>
> Here is the first part of defusing it, remove some of those calls
> around host registers accesses, which needs no protection.
>
> Doing this in phases seems like a reasonable approach, given the
> myriad use of the host lock.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
