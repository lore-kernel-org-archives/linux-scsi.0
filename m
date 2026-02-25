Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18B740F8C6;
	Wed, 25 Feb 2026 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034075; cv=fail; b=D2bTtJZ2LEseGuVv+VPteqDeTx1cEiI76UA61YYIOOEh6/OI8uPPuO8PdZTikJHkOik1szV0XR8aYrrMRsrua7y82WG0dcs31EuAPe680SnNlku3j+EkR8m2qik3HZvNxj/ZfLgAJ2UR2wGctdMiRdt+d6QkZQX4GqSG3jvyqk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034075; c=relaxed/simple;
	bh=A0HtuNQ6bwFt/y2PFWgQpxLUkl0ruip0zf1CQstXKKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=imF+nstLSKem/pp2N4blDJqrbL4b5g0UYer0EOhcPSbbY1gBG1zCQ4+oSz2ICwhg0vx98fPbjkPOkRBd3xuIaMfubRGJ8h6ME+b8NNYCPr7dzL3gNeArdpP81o3KkuxD0stCayuxUKCE84MVIdOO4CwPx0ZENLynzGdkfXHMzbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XfSI1zFA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g5sfsCcH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XfSI1zFA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g5sfsCcH"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9mnOC553428;
	Wed, 25 Feb 2026 15:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jyJ9tDNPGJSjU1ot9ENovKaf9Y9VHqLmJmyb6yfs7tM=; b=
	XfSI1zFA7M6Sc8KqOohuoz6Adaa+tHAtrumzkK2OxEk57qhNuXFjH07DsWoA9ETE
	AaqwXcbHcCoyceADt04x/D+yVmQ0MG4gsmHTVb/vCk7PsjbzqdsdT90XDN1LIwF8
	uDzY/mBxpP3Y2sdy2X5Vtz8HfFYPZj1TMKD7PNO9YtD622TVyPK23RNcNJIl7PTD
	V2oF+XukIHREAcQxr2gA0maBMDwm6l3twAbaFZNhKWc112qMXAIvElNiBU07LM3A
	F6FdDw5evcYfe8qi52BmsF7cUdUh1pOqNTVhPipI7DeEXMI5CSoP2GdcgGbEapZl
	JQQ9uANSPHHGPkOLA325wQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3pggp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF5ckj015907;
	Wed, 25 Feb 2026 15:40:57 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012055.outbound.protection.outlook.com [40.107.209.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bfruw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YorvPBGUcB06ItrL/gXozQsQopJ33QzHKAKEd0Dz06/lytPBqBFXnQz6MMyyVZF4c+bPqk4ZmCxRCdc3gWxxPWHDKVMV2REUwDsjTUdAD15AcDdAsFeZVZt0ayecKJYTluO8HVjaN8AYWj2tc6f/rkzqpckAMZWFGnic6UtcdaJZxiNXcuuGcU4Wh+eEdo6vLAnJnkGFE5H877Zg5c9xspiCpV85QDwA8/UjVp6QV7pbPs4a+dpR+XIzHkwEok19y0sFon+GwROTndcc6XQLmqT2Xvw09dXHAMg3GSDoOg0fm4dnaWugqZCsOBhm5QJ3sWtgjCt0tIwJmwPx8+t3Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jyJ9tDNPGJSjU1ot9ENovKaf9Y9VHqLmJmyb6yfs7tM=;
 b=Je0BwnpiPh/tvNrMFY/PJEs+xCyp7agK84KynbV6PA+Vn3Fy3RoX9APx5wmcx6brzWKyDYdETXZo+pzPhFlOcloJujHmCbjKThoxDPR++ncWb40MemRuJJHY52h0F4XozCQlbR3fKZNOzW6HaC7Hctj+Ag7AyfRm8vyIDGRQRjHs9jCoaPkCEU0HHuclmSROUnB5dUaikvjjMjKmv6vDqw7m/vm8kh0ajkOR85dqscaTuy0Mnu/3Ocdq9l4m8hghhiq3CloD0L2LDLMbERbhuPnUKRm6uzNtmfQLtaOAQ0bY8KLeuel/XyMy734DHpPUlEUQATfeCxdljcdyVVkiaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyJ9tDNPGJSjU1ot9ENovKaf9Y9VHqLmJmyb6yfs7tM=;
 b=g5sfsCcHNeiCCoQTOhQaaFDjqm1hvOOyHY1iyCueTqZQVL+zK0ydSMpC7n4IDcl0XEe8Q3qmxT4D45DXKSjKw46A9B8TmCIG324XekpwnrPGgos66uIQBii8Gp/nkNLfLjxx+36cUkygVi3vDtLg8/NRBIW7Ho/wOD1fGpSXMKM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB6319.namprd10.prod.outlook.com
 (2603:10b6:806:252::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:40:55 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 17/19] nvme-multipath: add nvme_mpath_head_queue_if_no_path()
Date: Wed, 25 Feb 2026 15:40:05 +0000
Message-ID: <20260225154007.1033735-18-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0467.namprd03.prod.outlook.com
 (2603:10b6:408:139::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dce4b93-9d47-4c1d-bfdf-08de748442cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	1/3Db6dBFKiyAgHJkHcln688pm5+Eqes3k2X3iRR5W47xfcFgU1HOekMeOGK13P3YBk+/uxF2P3S/zKcJmTeK/BQWAUojayOiKfBWpU5fym37tAIWqwxOLKZIsdAp+vwJbLigX/R0IrwkmMtPk1pSZD21K6LujeBIxD0z+yZexHUhTswoHHDjlwCmOm7Pv2u+7aF8WI0nhHlZcuUF4Ovp9R6Oer8e9py4N4XmxK34lWSbPjx2ifBGbOfsMMnt+QEFL8DVDwsUhtxaghz/1OVrvbpYLhz5tOMrxT0qeRTR/GnsmGkKhMWHqGtWhLLhnZSKhKQpEecRKX939ZYIO83x9H/LoCMW1Bi8BqG5xJ+fN+1IFzgNU+LN6YNAycflizAJmn9SIiVCEA+dB7UKEKsJTv08qIxGEL3HOacmqQ9Cs7zyeoUz89iMR3SHqmTwkk0O3voCjWkaDk/W4aw8DFOErJwUvFLCnKRPiNS0DBm3r50gRSeuiQc6855YoQI6nXD/a8P8nGANLqNzrVG7mutKxDfNsnacwKykY2s81WPGxlBDZczxw86VKnhPLpDC+WdBEodrvwnh9HzWt7zuRmuf/lj6BoF2f3iQdUBauUegEl7fkc6YLrCtvtk2VMAJaId8dvtbgVYi586Xcq0LQP/coCWgM0ghvcCGEe09CvXRRXTLDaYUVzxZ9iADTNO3ih0kgZcJN9NsvdZ1btIgIY/Wie83GMKjKuaKl5aU5h/4cw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?13V5aiiSpIA0sPnQxLWFF+43imPmjEXWqG2QulFXt/jpfm2NdoDqI0aByKou?=
 =?us-ascii?Q?75sc66Z5GcomSYrsXp0hzXugNM/AOBXZDK5yCJmnvN7PGnBzbXZCrgaHd7Ti?=
 =?us-ascii?Q?K+qMoTgtsjcLXkjCusEPZZy/YvKNsyNWAtWw9yP8gHSnMKFn4UqbkHHDW1R8?=
 =?us-ascii?Q?uwl2Dc9STLUWMQQ/YJ4qZnD+adZp1IrokWa8dCSP9tTX02SSY4Nbxm76RVzx?=
 =?us-ascii?Q?PjYLE4clfnyt2eA/HChZ5/5Ubyh/akYbJKaxuCuupSgepAsvfQne/p3HFtHV?=
 =?us-ascii?Q?uqvw3n1Wbqg5WCQZ/P2Hh3tRN6rpLfeUm3VDbNQ4qHmBtqw9ZjxjMxvTLyEA?=
 =?us-ascii?Q?efp/fiTJjA8NII6Mn0w4u87pwzvw3JcPgvrVNZYGwoAv4QHaIbh6b/5VFHB+?=
 =?us-ascii?Q?pD3o3eRaDI/eWhF6PgC5+9zdp5DjmrQCA78OLnpVi0wbSCcAm9qQt/ef5dN0?=
 =?us-ascii?Q?gDyIpRO6yucibrbfjPuBd/qNeHDfOIgVOMWjvqMbcYLTmprTkENOMFksnE4C?=
 =?us-ascii?Q?YCqFyUUSO/yRp+QjHHeNUPUF0poX+lBUcPndyoDzTYxvF8eoFBMS1EdZahZF?=
 =?us-ascii?Q?MedvX+lnVpSKkUIJ2tmd9H36pOhcdwoMTYoc8FUhNBTwjR+bigymplntNjAx?=
 =?us-ascii?Q?8oBrlelhEQLwM1JcSDomhJE+rN0pJKPDcf3RmfemtOIl0PAThlOmUssvNTE0?=
 =?us-ascii?Q?AAwxKykTmyrPKruWKsNVsM5yISTkz4i7z8oZPIXv9NREA7y6fweimqUZSOhr?=
 =?us-ascii?Q?4mMDJ7cJwbD7+9X598LU9lblRF7A1vl0NLi30Q10sE2h8ifuOeFtGFsz53/S?=
 =?us-ascii?Q?5E+gArdO5A+I3m8yutpfrclgYKhkbkQXGiNCKyJPk6Uj2Pwr3qcUlRoRVZC/?=
 =?us-ascii?Q?RMw7nWhIQ4GsMoNQrNgj6XXePHPu1QYXvbvAbkMbOm+xJl3KDAjlu5WEz99h?=
 =?us-ascii?Q?R7oHTgYq61HS+/BEEeS86VBe2i90byiQ/InuCn6oAoB2jaB8X2uASzNdxyCB?=
 =?us-ascii?Q?WMiXXFL2cWg5VgnQlywBvIMai6iePVAaE9IKV6Gj3fVx7zEHhWWl47qHJzNW?=
 =?us-ascii?Q?2RWy4/bjrk35qIfijhzPDhNpsp5ynTsBItrZLAmj72nmOR7EX4jS7eUIRiVg?=
 =?us-ascii?Q?Iuu0aDQWI4egBHrAqPsXAAWGzOcACbYMnYzXdrT9LtMwsy608UVglZ8FX5Rp?=
 =?us-ascii?Q?tb4S3HMDPP5O3nlx/wt6SnrOgHliNbx99UNQk6RnPaF3ykFTR07yT6lOLs0v?=
 =?us-ascii?Q?ghq3p4FvD+/mxY3aISE6yRrmbWfcAVdF25V0iSPfQHV8a47/TtcPYBco6xOf?=
 =?us-ascii?Q?sffPeJ/rYTI+CJMSEft6l6NCM2tubFdqe5oA+YlwXoxvLb/PjtnmI6pbw4mP?=
 =?us-ascii?Q?bvTSeAtc194SfuOx4tQ5XDr2Us0bfjPdB+ROLDn+oBVb70tQJWYCjglWeH/6?=
 =?us-ascii?Q?N+vuZYDlrhPRg0r9bo3TxuW/8vB+kZY7LymHsrGTPSMamYyCdnwUGNEL4yAZ?=
 =?us-ascii?Q?LQcBk3EjzNgB1FbbV05G/Ng+rlaV6y1KzOpceHzC9pJu5j7NOtuwpr5jDBAP?=
 =?us-ascii?Q?O76X2ZKN3czyEyyUaZjNghSMKoKJzyYd2os+tNDMTMQ2zp9FypFbG5cXkwjq?=
 =?us-ascii?Q?/o1t9vUB8cCXWxsvlrRxclIFA9doY8xbbn6t/qrnja8wttyximIp33TMmDVp?=
 =?us-ascii?Q?06KLChD1wKXdnaSN0jedsepotjnlJOb6d4/J1Ht4Nvs4h4o7w4mvYe0S4mEH?=
 =?us-ascii?Q?fCfUwcUtyJTB0aFdP6VadVansuFtORQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p/mVjyFxCCQD7S1Ke4Qu1zSmEASYzaxSMg2cjT7RnEmbk68QsMOI9nq0xujAVD31SvSM2m5E5BdaS1R5R5wAuuEKqdV+BtTBmE71gmIgsEV7Q6h9BgrBPdtHwhtlzIUFar079uv5KfKPr9laaxUh7nUjQszFXYtEzQr4nIy9nYzqaWlUi5fFkIdG0aVmwDVGuQr/B3gzeVpstWoiW5i1sgssR/wJxRPkHsauXhqQKT7Ts6bLDL5ky4qo7UphuC5GR5HF9XENGcS3MXJOeI3ZmmWb8v3dc5OzjOUkMYUWhxJYBTPvnk41+kl4wWuPfj6b5pVV5sNqPA4rkp5PuDtcouSW9xHJyKTEFpWrQJSLw0DpHiKKjk68QzMJ5U8ASsXfhxe17W9DSnwOcP9c6uUgQlHjlNItkkxO1pkCAxaz4k/JqS6byNen8CWzYc74aiYxEL5GPoZYl4C3PUG7NoHXNQvkerfOgk5so+llKHcYhRy0tg54xpFXzg4BiRALjWLz7oMoeE/KwXF4aXjYrUdL6GZxCPf9W0M96b4xH5Uom+UEW8CRDsDzD14l4RJijOIHs/tL7YAJpAUmo7O9M+QwezaPQi666NXiGy1gbSxxFXI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dce4b93-9d47-4c1d-bfdf-08de748442cf
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:54.0117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVC/D30T4dRq7jyH233vCYZVHiOGsx6W1C/KVHl75teRyy32MmX+sxRehosGaGnqICDR6hqRZCOzuF1L/fqrKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699f180b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=Jlb6IQvdQG1jHNWhUt0A:9
X-Proofpoint-ORIG-GUID: a5CeMFIexoHmMc-eEw4017X5lzXaVg5-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX4/QMbDBGmeNa
 GZAiDTmW/OzA+krfethCDdJu4IyqkXq6kfnYX7EHod40xlid0fDPCQyW9PaZUIJqWo+7qTd9LMN
 /V7dRp8GTSPbnHWPkEinwp8E2MH7fX1aCgBRoTTG42uzLUzMnuimtoLrF2vcAtZ8qxqUQhUbh+t
 bZ+p/bUumKdMNL8cVkiqd53IQKf57K4g4Bt56912Q/PEcVE153njXMl3/nyiyNxadQqotdaGAp5
 FgnQxoI1uc8McTNbY8Ev2hOHtLE8gh/+r3E9rq8M519zHPBQ5QNEnk9XoWGLhQSnS+M45pJQTGr
 7Yi6703Vnu++WbvZKPCfiixJbI78Fda4Aqd7lwxB0/1fV6ZjPR9S7nmC8+im6oLDxxE+lvR3HjK
 Rq41FUQpFH9V98i4laHyDBMa0we8AIwjiqniv8DQMSraWckM6qKVcNFUPAuIQqmjWDxG5yGNl62
 ZiyBeSu2VPmgBLxD9EA==
X-Proofpoint-GUID: a5CeMFIexoHmMc-eEw4017X5lzXaVg5-

Add a wrapper to call into mpath_head_queue_if_no_path().

The mpath_disk is added as we can be called from paths when the mpath_head
has not been allocated.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 10 ++++++++++
 drivers/nvme/host/nvme.h      |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index bd96211123fee..fdb7f3b55a197 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -214,6 +214,16 @@ void nvme_mpath_end_request(struct request *rq)
 			 nvme_req(rq)->start_time);
 }
 
+bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head)
+{
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+
+	if (!mpath_disk)
+		return false;
+
+	return mpath_head_queue_if_no_path(mpath_disk->mpath_head);
+}
+
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 3c08212e4a54f..e276a7bcb7aff 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1052,6 +1052,7 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
 void nvme_mpath_end_request(struct request *rq);
+bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head);
 int nvme_mpath_bdev_ioctl(struct block_device *bdev,
 		struct mpath_device *mpath_device, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg, int srcu_idx);
@@ -1196,6 +1197,10 @@ static inline bool nvme_mpath_queue_if_no_path(struct nvme_ns_head *head)
 {
 	return false;
 }
+static inline bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head)
+{
+	return false;
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 int nvme_ns_get_unique_id(struct nvme_ns *ns, u8 id[16],
-- 
2.43.5

