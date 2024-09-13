Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F008EBA33;
	Fri, 13 Sep 2024 01:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726192473; cv=fail; b=GjEoO4RtjNVAhVglTGeDyKISB3YWYH4TA5IVuOJx4wrcbcswVvwOxnU+F7gS+jrQ0NZWd6lCYwbVl3L/3TnJKVVS8CRbe0gyN+OGkeHRt8UMYDytdIyegbmZGj4EQDiuyK2ohKzUpZbqwbFuNWU4lWEGHWc2MVjM080NeaqNqxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726192473; c=relaxed/simple;
	bh=DC3RORbgfuC9MNLN1oPUAyj810M0Zt5ctheHlrQaJUo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OUmLOKuj5EYPD7XkRULe0t//b38o0Xflcf97I1Hb0sxwVzOAaO9we56ek0aZsrv5DOlsRSuNxz8DQQPuIPhNjy5GV7o9Pbuev2BY3I0Aug37J0IChH2WHMxALeMPquvZBxjpcnFnzsxP81WHKN2Tj/75Q/HS5UbDVvLSI+6G+go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MnEcL50X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jb3D24Se; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MnEcL50X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jb3D24Se"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBVvQ027771;
	Fri, 13 Sep 2024 01:54:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=R6xhud+fXpmc5b
	pTpu/kxicNUJ/3bCdr1mRogrb1Fms=; b=MnEcL50XlcpeQsBaIiAJ6KKd+t206X
	8QOa69SRZsepydzNnLtSraomIpuzMHxgRvyP84rrkwZWbClURvGrn8Nv/cD8HybW
	hCEznQrasg/tZPfI5odF4WMfp9ctctdxHUgW/85dNPCIhK6Eb7xOWzFF3zHlr9zu
	uL9KLR48BdtZTRCJD5EohSF71NNwlqQk5lgiuP4WAGyxA4xNTpSAStnKhtLHsuA2
	vELAmX1j99sWbjk2rubV5SoQLZ24Lo5W5GGlMkcOkyhfIsAeD+w6HlWwlIRBDo6Z
	mwSw4KW37vv4uMpgP7zUf5JLo+o473GQmkA2CWa3VksHJ9N2gsoClwtw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2vbwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:54:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CNeCi3033574;
	Fri, 13 Sep 2024 01:54:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c26qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A1B4KJ1Z1uWQ357agy3Fg5p4a0SM7jT6iuC5159EHqPrFt2nrIYIVKLfRz+j8X58p6wvxc4q+y6T+hFQBewAGyxojcXcwNI67MMqkNc6aOH6jWLw6YVrQ/54sEWCKfC2GZKvxezHtj/k7K4NQhxUgzzvDukoE+nvzfzmOuV8HO6HVzWFlSxf6Ko8rsJH4UCR/pnPzN1YiPFjxUrnirOIqaI6MKT1qbyveXMb0miLxMZl6OjQE/r/u5gwFd/QdDgXwoEs3/X0R0n0NN/8yVjW5sfCdTnff45ciXG99xJ7KyGPB6+hfAzN9iRrMfXGprsIY/z8eSXjUf/pyGdQl5kJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6xhud+fXpmc5bpTpu/kxicNUJ/3bCdr1mRogrb1Fms=;
 b=pMWfN53lv5i2cr12soUGO4GGJmg+vDpvUJkgc9Q/nAaFYjZPwxerCrl7lxUwmWkrMinlXO4N+IR1Wvve6FW8kkWUHfJSn8XY10RwFfottR1428WdyFbWm7PGhX4rqad1nbnh13Yac6Dr4tYFZPIlXWy/Ag5zLSG+EbgtFEoNm6c4LvKxeFuedBt2TdAK3+rSjX3QNSBeKV+2sXjT0aTUFm392Qjc5gVDJ76ROGZmuLOBXY3X8zsL/aTe2DYFQIz3WCZ5JqoYlfObnRQ+nkqmG6F6BEY/bWnOvj7sP9dF9F2CHdK6i6hw/KHqykctTNqiarDLbmQ5sAOyqP3jBDU60g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6xhud+fXpmc5bpTpu/kxicNUJ/3bCdr1mRogrb1Fms=;
 b=Jb3D24Seh1HrjrDdiJnjFrdJ8BzrKVeSE/EfUU9Jug7yzhYVohV/vP/i9nlLDmdXcYe+oUapaGsqP/ZM29o53ejDO9qF7zr/7VTZDNbAyBN0k9IrIEq6vGO043lu2j28dwRLSWVkfH/Q8nX1bdY8uIwlWAnYdExsHKMvF2myA2Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7361.namprd10.prod.outlook.com (2603:10b6:8:f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.14; Fri, 13 Sep
 2024 01:54:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 01:54:15 +0000
To: Keith Busch <kbusch@meta.com>
Cc: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>,
        Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCHv4 08/10] nvme-rdma: use request helper to get integrity
 segments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240911201240.3982856-9-kbusch@meta.com> (Keith Busch's message
	of "Wed, 11 Sep 2024 13:12:38 -0700")
Organization: Oracle Corporation
Message-ID: <yq1r09otj2q.fsf@ca-mkp.ca.oracle.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
	<20240911201240.3982856-9-kbusch@meta.com>
Date: Thu, 12 Sep 2024 21:54:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH5PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:610:1f0::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b932b6f-ea27-4506-2b7d-08dcd396f8db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qJtDRcFkb2DxTQRGcg4FJWz2y+A8QqPnLZdbKHpIOIuHCWgw7qYwe2Z2Jmho?=
 =?us-ascii?Q?wvvw37jIkv7DUO88NB5cQ0oTtmJLaPZSWYHaCS+P8/GTLP7+mrjDOHAGxSCG?=
 =?us-ascii?Q?rlvm3ep9zxHUpilUR7ZeLZvxp5M6UGsyWFlKvNbQ/0Pk8mTT2yGKDz1kU8Pj?=
 =?us-ascii?Q?Mhe84rtBYfgtZhmxNtBZRhXLgl3z1NligEgpFOfhxm6KN5BegF5lpihv0s9l?=
 =?us-ascii?Q?UtVmqBQRQir6nlSUvBG+yhMlysbxUxMUrAu2+KalfDaOz1YxKAdfISegGmnT?=
 =?us-ascii?Q?qpMpo6Jcxzv8JQ+9Xy74XBmiX3DEuJZMw483IWa3zqzpB44xm1kriUecEU2l?=
 =?us-ascii?Q?e4RPh293+/6T9FqHKvnAoBftqiFshszI5h20wrmu/WJby4xiYJs3NOKYecVm?=
 =?us-ascii?Q?OOaUdYPwHLN/OcX9ZJW8qJntsCr15RappqLP3I/34vRd3bBFXsJ75tSu1wWt?=
 =?us-ascii?Q?3eqZIcT9TPkYvQDh7iMZ9GISCdTkN4l7hnapNI5gClMq1nDVfSog+ZRtSfoU?=
 =?us-ascii?Q?L/HUNGSUt3H+4klg1FTFMLpYS1dizaugMYfa9kKptF8e3omHltipfJcHuDGW?=
 =?us-ascii?Q?k0MayRrbO6R/Opg70f/o5iywL9xtEefkI7XVoRGQ7ZwNFpbAF0BcysQn9tH9?=
 =?us-ascii?Q?iopIZ0qGxwLmq//8HZ11xNZn0wDZUjWcObzU9av+tnNeVGkwY7jeWRbiuVd5?=
 =?us-ascii?Q?1m3YziarErgxzDPF39hW8hkgxpZPSiwop0rywYiw7PlgPXe6qy0jZQONyMQq?=
 =?us-ascii?Q?C8X5G17R6QaZcBQ66VRgvLpIIkPm5E1noYcp5kS8B3OTePZ+08wID1F0Tgdg?=
 =?us-ascii?Q?Yd82U4NhZEOyWgmct1sGXGnwDuqC69PfXLH2qh9KPJx88iqOF4ll4r7OGzui?=
 =?us-ascii?Q?sNTdbdoC79g6jxB13SHZopgBjGV46XDusENYg0sY6ez593T+2P6Jhlw9tFJ/?=
 =?us-ascii?Q?2Kk0JA+t25XRxP6mSnArz/VG23diVS6xMzOt2cyOOAHFPFPkM7hPEh9hhGzo?=
 =?us-ascii?Q?JI4fCVkk1in+gmQs84/6bRlpKbq4hqFu5xnFF71J42xkejNK0oOj2BACW7he?=
 =?us-ascii?Q?F80Vzdlp54J3o154ZIiy0IlnC9RvtgcCflxYz/iSDR0M2DLclktNMOfdAnP5?=
 =?us-ascii?Q?inGSE9TQa1WzEeV/nsDIYnvnc1e4cNhJIeFYxnHvLu89zsDbPBCVwN9ttHW3?=
 =?us-ascii?Q?xhUuleu67HcLdxbAEjaHJsIq/JVbbdHTcjR2w33wRUiPgJoxMYQZPteVvJo/?=
 =?us-ascii?Q?eAiGh4kqcHiM/rhya2w4WSzOaW9MiKbUlYRNxd6eDy4JecyWIWK4eqfCC5j2?=
 =?us-ascii?Q?RdbqTufR02kIZWPpfL7KIIT1LwpEx30uq0LFsQdSv4kodg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EOhMkcLwzTLeC/n3fFefwHds+oLdZZ001JkIjyvjb+01VrMjj/qkSU4YDttj?=
 =?us-ascii?Q?jD+f3laCIND+CyK+w0UBnTx0dTK6ivsXLDjwtnP1u2ugyG/PmG2CW0DUBSdh?=
 =?us-ascii?Q?qsEqBFlffimPQuylPhxHtXSFSdiNJwmSFdowu4Fsd+hQvRmssbfnpIim4Pm0?=
 =?us-ascii?Q?vtf8omJc+7UjfyzODaoIXFL6nBTJ9MrafUO2MYwg2afPGMV6kKbhyKa7d81E?=
 =?us-ascii?Q?f/SL7ehxQchQDKstRbBvbamkdV+T9lprkx4/os7dvrcttn4ycBVYS5vNvV3T?=
 =?us-ascii?Q?HESFZzMdoAHbgaP9ZhU2gybXsw7Lt3m3+aVOyyDu3CwMBfpxQUi8WhnhaqEU?=
 =?us-ascii?Q?FPaRZTLNnzf47SZa1jA2WV+jkDttEVpIYEApljgSNSbMLOKfeM/BA2DsxCrp?=
 =?us-ascii?Q?d1PzsaAqgcbaAa+R9+bp7E1lUNT74ii9udPIcgR31NGr8LIZQ3/5DA7mRXQD?=
 =?us-ascii?Q?l4r7ju5wJ4xCi8OijJJe5cLbRSrIQh7Wb7gOPkDZtPkevVqrs772fbMYRoVp?=
 =?us-ascii?Q?icVp/eymI9RwRdSpwjPWMf0M6PsZjw7ZgTDvABlOY72qinRpAn+uhv89+6Hi?=
 =?us-ascii?Q?ASWYxoess3nayIqsyIPE0gL9IfbgQhVInhDbE3QIsZ1V3soqbQS9U3cTdA5m?=
 =?us-ascii?Q?5sNEPg1H/clFaXaN5Elp35UQ4QMRn0lmM44X671z5BF2+szDxodhiRZUEluA?=
 =?us-ascii?Q?V4Cq2Bv7jzjiKyb2lyAwQsk3LX8gWLP9jV1TlvrS82iPkaNjAhChiefa96/o?=
 =?us-ascii?Q?VKzAu7ytskrfuqAiEsc9aqkuUDTlM0Ut4WW+xnkgI9zcD9+lWqFZccFdVmc/?=
 =?us-ascii?Q?hyIgVIN+3xxJSCleJ5FaaLxNQF4IgVDdrnsRUcIljknzpSZ0BtohFUoJ9g2a?=
 =?us-ascii?Q?t4F9GvubnOimKHrHXg25YP7TZxPHfZzo7VfK4CkPxFUyKthbUtK8ZdHxgETH?=
 =?us-ascii?Q?AI/1qvZUC8J/VQAsvSrdbh675AlpDgdSkMqIS9E8rXoUWAE+g+QujNu0JbIH?=
 =?us-ascii?Q?Ryr8DvdxYd2OLnt54sDQRpuPksI7NkjB51We7fbTIGJLoAieHVD0P8eSuVO8?=
 =?us-ascii?Q?W3GpKB7oJAdaTM3BLI2cCJR1D/KaEVoA29YcYEr44iyBo+Z6aBhCY5M8+pot?=
 =?us-ascii?Q?J4bRUqZ5aF5z4k6V/YJLAYPmYYU0zDvXC/53gYmQLCeJoW9vInRDGfPo6LDZ?=
 =?us-ascii?Q?DNQ2s6D3HYIeY/MFJjftZTDuRmxLWNFAO5ezsYOO2U3Rv74UsIkn7Udyyxyq?=
 =?us-ascii?Q?M56ZUep2QyXadhTyDrxruAaOn3aPdky8RXpvuvh6qqPPTZBj3m8GJm4jrIVh?=
 =?us-ascii?Q?NcW154Th+K3rZIQtzusV0FpbULVXCS/Bp5p9mnJ4+St0rr3boYwYkq33rrWC?=
 =?us-ascii?Q?0cRVegmyMrimHNm+6vLBuHVtyl7FHhB/qVcks8FUi1/igpT/cq3rGPUEwXrv?=
 =?us-ascii?Q?5Ztt7dYZxyZSX5LD0qxyKuZrUQGkIRZB7xjMdGBsMtd711H897dx7+SK/94j?=
 =?us-ascii?Q?io/zmv9GQLJAQW0AF5dhyNRnKPWoRN/cB7nrcUVtfOZ8D/NYefGTBIjg3pXX?=
 =?us-ascii?Q?VX3wps84yrxpqQXcuzOy3RvQn4RnXlsVI0mvwcewhEyPNDuS0VVmpi4MGrLi?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SkKXIliWzaczfAPpVk3+AKl9Rv950JPU+sXGJ3LIE3XevYJrC8xSHSkvsXuUceW3UyRM/7zaPYko5d3EzSVhfk81iHYImlZ06yw5bCobRW1r6cOUcfsMfwHai5krC+sD18MdmFlbGeGkj/nmwBGOJcN5zETgytl/tZs7+u7omt6dv7aC1aHy0uTVcvs3kByG/ZNV/1iWbDMep5EQ8tFOjLGNtRG7udW8lCX8otLPli/SF0a45fPg4Atl/VKHBTFOstrrE4HH0PV1LKdP1GEJ5KxNR6njFtmZW9cFqYHzsqVv4Vcs4YiNCiD7xdLWv87J+Y+Cqw/31nKH7K9XQ55561ir9nKecRbzH4Ce1QB1L3Lp9MCPpCxhW+UIngtpFw2ZeFUVUxs3mN3VIsQkISu+XQlAv7jJMa+pU5Cg7YDf5sxtLLhPMVC7nxvH3v5x7nIZytJpDF6YnO+puayAg5cejll9u/nh4Fyk4PuEj6vVSZ5sCzhl4kHI/KxOg7XbqdOgHSEAr/BTfcUFOuPaRB6HiXvWdweSaBxpIwNSkBHxn88qaYOKTlFMJ6EXha2jK2mf2PBzm/A6TwjWVOA1AeZNXcgqt5t30xPwfrmy7Kfb/7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b932b6f-ea27-4506-2b7d-08dcd396f8db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 01:54:15.4258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObIg56KrPfTUUt3mMSJ8y7tDW39hRPEISs8BQlk2RIY3qQzGMFQXPhMR+jNERcPu11MlJD5dw42zKLPvEDvnUTQDAFnxlvkGDZZk+MxZnAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130013
X-Proofpoint-GUID: k8iiiyo5Mt7gWFBqWarYqtNsjr2onk29
X-Proofpoint-ORIG-GUID: k8iiiyo5Mt7gWFBqWarYqtNsjr2onk29


Keith,

> The request tracks the integrity segments already, so no need to
> recount the segements again.

s/segements/segments/

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
