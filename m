Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0060A7489;
	Fri, 13 Sep 2024 00:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726188151; cv=fail; b=KNQCmVKxga9Jebpu5Wk9Jlhgg2RNe6UdXz8rI/dlrNXB4CdD9xRAjFExZjg40Rt5xT1EuMQQfHH34OXYyfg5RqcgsX+NA1VDpi8EvhtToisrXuT/bo+MA59zkjtWlihZfaBgvfkI7B1ziYxlsnZVKZQ4xl01smHj3h6oUJL60+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726188151; c=relaxed/simple;
	bh=l1ucEda0e5T2XvljOB9F10rCrT63rahHl+44Zrl2WVM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GtQSRJFtceF++FOSe201aASNLtTzzcL4Jsu7D4Ianm4fHeolFAaLMwySlY01Bbx3ELHFY/hH1FjbVDDJQsckL/vn71c01NgzzvQVYZrKWjnc0pt1Osl5nlpRDLzom+znOfiBhsz1HEqkS0Rp8mDA12Tibez+MUomSqsUN4Gv50E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rw0IFLKj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B5EXzWj4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rw0IFLKj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B5EXzWj4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMC7Hp010387;
	Fri, 13 Sep 2024 00:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=koOEQ8LFRkVvBx
	LPD5e1J7MWqkT2ZQU93/Ja3OboNBE=; b=Rw0IFLKjCSJSRqPiADfBitDDG1xRyg
	qNksfckmBbfkAURS1fHK3ph9Dig0h4gXoqQbkDb92VhnlFKJb2XuETO1+qa88kwI
	XdyUReFPNL9A3Ej2VpsmNtMEzB8ObmWOj+Vq5q/EAtUFCPDzaZSIBQG/J/RurXGx
	ewuHp0C/eB5VwMZxTch4kXLKaVyEp9nfl2QbCxGXo4j+mfGZI4ltahVCTbo2B6TT
	5M1mLyVAnfJYYkvBRv3vbkBzIW67tDLv1yVLieupUks1OPrsq1TR8QObZi3qJeZw
	sSzDs/ludLo44T4FFciclV4OYu7cxfhkneHrNQHhMiafkw+7Q7IIXZ0Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdrbc8px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:42:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CN0h8b004154;
	Fri, 13 Sep 2024 00:42:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c1qg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:42:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XChJ7EMtFdsLKqj2WHTotC8J/5/Bf7tUlqrzetsgPibWHyl619fynx5JCEFh66qsNG/hMlUeobwd98gtfnpS0nK8+iRXWM6Hw4XZvu0m+lWHLbVMvBVJ2fgPIIMgG7Qxko53GCFjBKhNyMPnQNLw+GFpdXHC+bjwXdSj+Srsmd80ptDLzFGpQFyEVfqdcpfMcOT6wXWipCVZo1+RWMh43nQnqEG1gYjRsyZrlIWcfr1HEsrfqYhcp8PvkcnakBhTBKI1bwpRHZbnAYSnJRusR1fZ/LMhhQdrYC7gTGEagj1woL7vknq+In3ea9XjhBZvinmaALpbdZ355Nccdyo3DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koOEQ8LFRkVvBxLPD5e1J7MWqkT2ZQU93/Ja3OboNBE=;
 b=CYNxanNANHRf2R6xGc9vR8J7OUeEI5g+3LUmJR5QfwRrV507cSMIYIB7ZxgJyqAheKXx09p6Yi4UMRyIfxhW367cxoaK5V9eagFNSjgG/JrujG9HBx4NcxA7RQ+0GFvgQBxONDKPuL4TnrDu4cNXb2ePACmCkloIadUMmhmwZ1RVX90dJpJRshhGa3XPCEjVwlN7zspLpM2dojNbGePBKqDR4i6nyG38OF5GaZydxngq6lz1bPwJkt2UICOso0w8NwBSfrCo7+eJ3jQK5EyErcMe6arK96+WBVb5gSSYNKvXbK37uvVUbbzA7uXTRJtV/Tf46Ea/vR0E6ITEOQvQJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koOEQ8LFRkVvBxLPD5e1J7MWqkT2ZQU93/Ja3OboNBE=;
 b=B5EXzWj4gHrQ7J6AFgC2Q2OlWu/2cPlu1iruCTYyB4xROTau0ucjKQlvKv/qEEWTPmoOGgv0c8ZTrILaV1EyhXy44LnL/54z+nmXKVQusaMxh9faoKrGOK94chPZmuHbuTh+VFf0DV0ecFgKEUZEKFzmK5zsEsIkPEZgIwpQPB0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.8; Fri, 13 Sep
 2024 00:42:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:42:21 +0000
To: Chen Ni <nichen@iscas.ac.cn>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pmcraid: Convert comma to semicolon
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240905023521.1642862-1-nichen@iscas.ac.cn> (Chen Ni's message
	of "Thu, 5 Sep 2024 10:35:21 +0800")
Organization: Oracle Corporation
Message-ID: <yq1o74swfiz.fsf@ca-mkp.ca.oracle.com>
References: <20240905023521.1642862-1-nichen@iscas.ac.cn>
Date: Thu, 12 Sep 2024 20:42:19 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0769.namprd03.prod.outlook.com
 (2603:10b6:408:13a::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4821:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a52dafb-e33a-4164-c4f8-08dcd38ced5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H77NAiULx+Vmc91b6DnH3ee4lsatO329+1A4CifH9JifKN9UCPy7jcKgSOFE?=
 =?us-ascii?Q?eV4tV9DLTHRSIHJMFmh1bBIX0F6ogAKTGxHaFSuX4LWkTWowxIjPoL/aUF0N?=
 =?us-ascii?Q?fIkCCBdXwyr9nHPvIWFcy4I4gUJ8C/VRFWhE7liXr0DLjj7CTD5taOYYhZOL?=
 =?us-ascii?Q?csCydK55IzufWyypn3V2rcvhY+gTIH3Uy5sjYcVLO0ysYA8K2zEpFyZsAAFL?=
 =?us-ascii?Q?+h+dJWBPxc/E0r454m5+IdxS1qy5XSXrcuxa1+OVjMkYzQP4+BlnD1V+92Eh?=
 =?us-ascii?Q?14MvC6X0d3gvoSWJ3iEZynWphgVgJhdKoN67piSvMQ3wWcg3IgOOZdSRuNp+?=
 =?us-ascii?Q?XUeJe7XSda6++cxvtbvyGDBxDqZORq8VSn78Ns4Pwb96L7HUdTjTCkx/280T?=
 =?us-ascii?Q?XfSKBjw2v4/VaboTZj9WZPdUu5rtC+ngoL7LquvMjRcpKe2TbwwF0iu1g5av?=
 =?us-ascii?Q?qJBl7N12GxfZJpXGks/Nyb6Lv3AI2k5yXlHZh2xH8ct21BQOGlvXJNIij3ZG?=
 =?us-ascii?Q?xLp4Y0jSruJLsP+7tx05y6KqH7vS6V/OsXyAWeFzFRCAIakrlLk16yX1ENoq?=
 =?us-ascii?Q?rz3aoIM2dnZRh8QipONKKx5sh5KgFZVpbBSqykZ8bkNZiwytWdeL2tQ859H/?=
 =?us-ascii?Q?Mj/HQ/tCe2YADf48O65tQxSgfGqHFIq92+nan8dmZNpXVUo8gpVH6ZjYOhrT?=
 =?us-ascii?Q?CfkkVWxzK6a3/B4HZ0Cx4j4k8jD4IyzYoQWTZkTwE2s0AjLPxYJIot8LmKW4?=
 =?us-ascii?Q?vm46wXAIX2NiNO8Wtfe45TZJUfZFEa+00wr81+2AJU5ClSF87Jo1kBNbtaqZ?=
 =?us-ascii?Q?XvpvDYcqfOq8gVnP88aJcvQXvaZCxKXwugYBvM65dEkxKNcbPLbKbjmFGuRP?=
 =?us-ascii?Q?e3vpXdaoo4gh/wsuqtwPl9V9JZZvg0YX6XPeIV1//hGwGg7jQkUzfyiRcx2W?=
 =?us-ascii?Q?ivK3vXImYwvUefKuCqXlTp5n6Y0KzRsBwaQdvmlwCczhZjQrhsmmJCBDa+Md?=
 =?us-ascii?Q?UA7fAz6fe8JYVxWSdHHEWsZf6P9K2rVmOqkzW8JJhVS7l7LS2agojfjeEq0U?=
 =?us-ascii?Q?m1e1mBOs3mt0Vi3XFUYxlUIJjdcfIVRQseyVK2am3KJciN4SiGxZt5QoBhte?=
 =?us-ascii?Q?O14FTwBR+dK6WJJGxSP3/igcPEm020hBtbc17Xp0MVZ6fw0ecqT18J3aXAwg?=
 =?us-ascii?Q?FaHXLIjL2E6R4Z6nSHaI2YuZvnB4Qmf9hhnZGs5m4Cd6HdQN/4X90/zdo8oU?=
 =?us-ascii?Q?C5C5zDX+AhlvxpxwjpNw1pFVr2LeGCpXv+eiaxU58U0u5+cpbYplEW/1d1Fz?=
 =?us-ascii?Q?GCLaozWHLbIJm+CXzFdaomw5yNKBkKYTWP3Ky/tfDOivBA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dL1Vadq7d9GBqbsQpg+gAdaa8NKH4lThtmbza2X7PmyC3N7SzieD26gCgA45?=
 =?us-ascii?Q?W3ZjfgUAfyToqVi0aMycYinDr6P3CVWOhbXUwgJnQQGXfUzqNkFJqnqflwKX?=
 =?us-ascii?Q?+hhnp1Qr6D5sWxX6uW03fkkCFYSUEldc8MG7YJXOdY51OTUduMxsBvRw8dKF?=
 =?us-ascii?Q?EJU93+otSUVUZ93HJiJnLgM/aklo/DXCYLKR2rrT24XIft3dJkUAOKhkCGXR?=
 =?us-ascii?Q?a4L7b/4qZsU4MU2yMb7QZNlv6gZAG9qfsX4N5lWNhIcPS0LII6i/fVaQwLWO?=
 =?us-ascii?Q?T6E0PtjmrmquGexLwpRuxa30Txnt9oEVRM+indfLENwcMh4DH/dJL558M83h?=
 =?us-ascii?Q?SFkGCxgQCvB+Xp0+JaLLRU/y4LU9asCtVurWFIe1bip553dWNZVH1IUsRk1D?=
 =?us-ascii?Q?2RZb5mpu/wZD+6ttG4qkqyahTmktdE4NV9GAnXtSzcnqTriYb6tsqC7RUO7l?=
 =?us-ascii?Q?nKaJNUDDPP9cx7P3yHMLyEPBhLn/xoxjbnz5te/59JGUn9fKakLfvcCI/JLF?=
 =?us-ascii?Q?b2C8sAxO94brghrSNvq9o6nBAqiM70Jhghs8f+lxqi0rcNRz/YJVs5C7R/SN?=
 =?us-ascii?Q?zaQs9GSDgIXMU2GY2pyFdJUgv55tKAy9qBmg4P66j2OzStKUMO5j1DGc/hwC?=
 =?us-ascii?Q?+xPntuWvJ93VaTviPJnyNAHPfsFDBGnB7eLm76mr9//1pH4erw9NVm4ms7iD?=
 =?us-ascii?Q?/eWiHP0NE2taaIO7EfpGq9CtwDzpzIz8FHdE3WIqMqguI8RbyCARVQrWoZ02?=
 =?us-ascii?Q?0hOMys+AHRqObC9d0mBvppiHTINUm4Ll2OjKSWiuwSKS5ubxmwEJHwLA2Ki7?=
 =?us-ascii?Q?qw0znANAj2OdsF8rdfxD//AyZnVZU1HZb+2LMSDPB/tOVfqDEtaMueHfgRbo?=
 =?us-ascii?Q?YTAf6ahLePko65V/v1x9nhqu4VCv4gIF0zT+9xNALR2pCl3Cv0Zp7dS3gQME?=
 =?us-ascii?Q?LMPgbiXD7Kntnyr7rNhm2U7plguI7QDTeASeK+RDE3VU7WM5Smt9GBfu11HL?=
 =?us-ascii?Q?XbANfkvN1avk+var2jV6gzXBd4/+UqcELqKEcL/yfky0yqh+IxPLUFvc9LfS?=
 =?us-ascii?Q?HciSMMrY/eQ8BF6l9TaMt1K4mwHrnQ45W29WsBVKWTlxXjUdcCLOC3PZCtAz?=
 =?us-ascii?Q?fnOolueYhfkBlkZGmhOjZFoh3FzkwZ1yPu1TRmGrP0F6TZRG5nxFCjOL9ItV?=
 =?us-ascii?Q?Og5UdVGhBBk9YrW0McyWbfsgIKHNc4WSbim2LpQGNnNLWDMbJavFeVen52y+?=
 =?us-ascii?Q?J9F05aIky1OXsqd8m8WEKULIv2GcA7bbk4NzqiLXMjKGky8sl6cKthd6eovG?=
 =?us-ascii?Q?8wK0Xg8dMVIgfJ8+UjipUBzAAkZM8RGeILHyufgOglLDdrIuTvkodjhpDnN3?=
 =?us-ascii?Q?hXay8yoHLwCFkJ4bASMDLW8oiRTtv3FOCnLWBTzZdWdb6eWJzWUfYmC5VMbj?=
 =?us-ascii?Q?LdEwhjBen8vies83u4J23dGtpMGdBksJh94nQjkWhEniUwlk2ln28MtDm8h+?=
 =?us-ascii?Q?q5917Nzh6SoGrdyx58McGqPWMcp5wygVqOlbDiDU6PennCyw0EhlzjeiHWjM?=
 =?us-ascii?Q?8q5Vb5b1VkpW0HUZ2ggCFEkHN7UvM+u8WPkXqa1mxpeks5JqWEooj+rEen1f?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OSvMXKh6RfLou/8xxupmv7AZYIXP7Hi5SM4AOLE2fTxRAV5eWfJxEoeTZQCODLbPnP0QR3Pctyduvaq0BaN3FqLnu2bWoumf0lQMYWn2U02cFm/mj5QJgAwiomvupLqGUJWS7CD2gD6MYJO17RtnXNBklCScD7a9dI2AYanAPej4rxRipjyqz51ixtXFkTjdhrcjQDqVU7wMpM62BzdjuJ3E8J5GNAW0G+5l2q/UVpeTxu0iYKuWnGQzVMEdVtPnVjty2QJiVPwFS53KOIzxF/59wU5kty+nJeWxWOkAmkTHPMpLqE+lPRjyHX1WUjE1f8dl8L6epskbnvsl+caW5v9C8eoqLTkDfCIt2jWtUXFGGw68Q01ZqRnWDX0V1z0Er9yvdB+DqbZ5mobInTXaaK5Y7rE68+4I26nYC+yUl6sIL/smyOvCHFEj9ppFlI8DA97BOS7j9eitfYK7Y+YcFjHXcZYiwjW/dVzreAWUz1UU2Etl7v0w0CK6r+t5lKb4924StP9mrgI7iLbzt6h3My9z/G6ZwwIr7AdnhUtpL5W8Yvqa2JzCdPqPP+/RC43PBUqnxsHyLRQWVkij/A9WTEohdpnd3kqe9fxEcAHj2XQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a52dafb-e33a-4164-c4f8-08dcd38ced5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:42:21.1752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1S/E8Jxuhmn91GUwKpFSfsjcarTJdHIVFKjhscTNPwpGG2uIe3Vah+Ju4lqPBu3IHNHNnYei1Cu1R70jGv/kQCEpA/YuxlPsEESmGR2L2Do=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=706 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130002
X-Proofpoint-ORIG-GUID: i4yr8KhYuUIQKidinb1AUxug2MzxfzZX
X-Proofpoint-GUID: i4yr8KhYuUIQKidinb1AUxug2MzxfzZX


Chen,

> Replace comma between expressions with semicolons.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
