Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC3E3EF0D1;
	Wed, 25 Feb 2026 15:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034072; cv=fail; b=YSJfSZPahwAon2B/53aTGP7QM1r43Ye/uyudu5Ck+RJgf98kyxsMLjdI675PSOk4vZgObsUhTA0owTpPkg3xezLrl+ewUHtavoCtX/vZtVIbFcJMhdiZNqO5B65Z5Zb6JbXatgQlg1t+YzjTuEd+bAeyHvIQRr/FaCMqLeBMesM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034072; c=relaxed/simple;
	bh=MGogXN6XXSo2PVEWDKDa/cy81B2LBl0WEWuC3FI6/wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M5lrCdO9RDRA4DB4kT5PJgogaXrqJhrd57hMytMA0TAnOexWsmEZWwwLNNMJ6S2viW7pzDwJnRcaLa87uGIrbu7ikhLJWhQNS1mytReh+w4qXFjyOGxUmfFz1tQU/EDm8jARbKC+0Wg1196Ym4chlU9d90kDyDxPMAWuYCA5SVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Os0yzAEr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L1bsnEnP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Os0yzAEr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L1bsnEnP"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PACiJn719593;
	Wed, 25 Feb 2026 15:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Hi+9+hxZhVFUwGEfZ+0XjtmVPsuoH7lzw7DEo1wV5lA=; b=
	Os0yzAEraKN8cWhQrnY7tzomtKh9jNKI3tvP5FCFk6F81A+rNOjP+jEQdtbR6Ja6
	7yCkZEmxnR3zyIIP6DaJluYc4onkez181qq7IaI9KR5ECj1tqfwKr2PYZwewDNk8
	l+O8VSZp2NvV9sKpla2JpVq/2U9Xs8lfRK4pTl2Djb+HKPqbIRFAskTZWvZxnVAI
	CfS9+ht4Qg3Q+PM824fhg03wj6xEt+PwuHDV2tEe3UQcdVdIChy7mNoXxuq4UyRS
	Sv8d+nVtJp5Bdn9t+iMciuGvurJDeIp+8eXVBwt4ukwlq3cumdP33Adk7YFIx0Gw
	LzV6JW/eux7VkQg6jyPq+g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b6eqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFTrjF012679;
	Wed, 25 Feb 2026 15:40:55 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012067.outbound.protection.outlook.com [52.101.43.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg569-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DkhQNj2P3Z60IRhI6f3LuNNzjWnxtAVzg3167E4VI6rsx6XcerVswc+WsON46ClMvgA3+bhaYGCFvdSWPoJXaGw1t3Vr7Lbbhh3xH0WXVmg7CDc2D9plozXlR5yoOKv1AKCTyOVr7L4i8DuxNSxHAEqLdEUxD8N9SsmztEKU4nOvV+TS/b3rcxVvKdHBz3gEV2OLqHiR0dx9eirocTGEWF0YJoR8JwjKpuEKRUq1AmoXwzkzonfbZnpIM/HoWjI0ELAlU+9pyM4se7K0n7/xsoZNevp+YUw0rvN+pXgWxNzWqXpPyFV2TZWsXChriteatOByyKafqlLsCEtV0hh4Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hi+9+hxZhVFUwGEfZ+0XjtmVPsuoH7lzw7DEo1wV5lA=;
 b=WfouysdvfoaU73mZRl2hpmWmhy0ksNdR/2ynWdAWbTQXdbQygvKjKMJhp6IVOj/FtNkrtB8siohoeOR7egHjz70rNK1CgYUWRC6kgiKxr6WqFV9K5AJr2A9o+uRXT+dyK4NXNcWG3IYeMRsyC6f91vgOZO6CDuSjmoq6SOUGMO7Ul8mKUI6Y4nrJm4GtFS13k5RY9xa6dC5u8O/p9gWNfUaBRUKvdULUfypeEHfXEel/eTOb2lLmOYps1ZTTRtTaTPwEM9KtXsxcj119Wgc2/LeUOs92R0WbxpZdJd1GxnyNkt6d1iRjtzPImu0cDC7cG/f64hJgsq8p+gdznFgp4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hi+9+hxZhVFUwGEfZ+0XjtmVPsuoH7lzw7DEo1wV5lA=;
 b=L1bsnEnPmbNHkIwdDUEU+V2SrLnueHkK1Pu3gc1gWMwZ0ugPsKxdgB6XEjyaugmRd5Q+sE4w0HOfBa+ruGeXh9cLKhp6Dx72yaxS1eoyPFhTN+8yAL3xn+UpO8HgyLA/4COOjIXZHVbgrXL+SncW5Fgr5FZh/bae/zVhly33d38=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:49 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:49 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 14/19] nvme-multipath: add nvme_mpath_get_unique_id()
Date: Wed, 25 Feb 2026 15:40:02 +0000
Message-ID: <20260225154007.1033735-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0005.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 0525fad9-1f53-4fd1-3e8d-08de74844019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	Xq7JYDtJbgz5OR9E448w2/0DrsNs91BzBW1kDdTn6zscnGkwEqL1tHG9xDusBCan8Z1P6AYxLqfyHdJNoKkZM21+ygb3CPsuKhr0uKeSkceQSvrWZIG+UjzBsJ+2daKStSnBFnfEGvsml8rdscfX727aycpJ9sLwxEcW8PtlpAqtjQeZqjuvYkOd338+rBmeDEC2Xc5K2mTOFODzulZqImzVoDJEZ5NeQOROMWq1k87uw8q0loWJooDN6AgOMM9wCE8EkTiez/34LsK7p3jSkoyvF8QnRm5L5PEK4Cq1d4wImQWv1/a7q5Io4216piFBKrn1IC/OSRwGwvttzSHvgWPkIT2wC0wVV2FUr8GowfDY7U3/ZllLmMruNNOpEQJH7I1cRSbTCjLalHyxpZrU7/qfEeNDGSivPuEOglc2oVSLhZIrBcdVyhXrQy7GtsxdgYdyfl+Y/lsStr/aGZlWolWmcSvfAg+hAtkittwvT9X1W2fXRgZOo1Zhn13Oq3YlqZqSBC8Rn9ovfF8KCapqBHjHXq1ofZCHlcLoR04YNnKYsiU2rGxuUKyQqSDoNYKV41jVbwsh+RhuUX4B6InYL68iMHpXMeKEdBnhX16ckg2vMKA5H3TgIzUONCld+80uXBbUgZR0/4RxAkabdJfPjNi2h24lYsWjh0IDU1n6LaElpwMme+0A7R+vFQ5ymlsD3LZNYXhPoI0ggzVXKk6MRRi4vQmAvVwgwePOWO/k+u0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jNublDi1rgzWc0KdTJAJ6mfzNKriUfOHparjEeXAElbg4lxAShvcpzAA5TZm?=
 =?us-ascii?Q?kTL+yJvhM3kKE3WYiqHK3XDRPlqMUJmHXnydbm3tnoWTmNRhH39AV9a5vLhH?=
 =?us-ascii?Q?J0k9SqUwH0OUH1jlvP+rwnI+z9pBc/VxqK4ERx6y9dYxCa6Rkbdwxc3vypxw?=
 =?us-ascii?Q?eGU8Sk/3E9XAtI+P6eq2DqDTFwEYfP28wbyCQt29eCnXsPnZDQADiWgPHzpW?=
 =?us-ascii?Q?pCFdHhlzAq2Y7GA5+f+AIWAF0ZbWj2SnFNofI5Uo4DKIWHk0KyJ2vQuLdIMv?=
 =?us-ascii?Q?h+L2xBRL0oiXYuN/HOUbNZmfThUHKHg7Mq73CwrTzU0rGxOhtxeDqF4kqBHq?=
 =?us-ascii?Q?yRCClcbu9QNo5QzlQhtWJDniBshor+D0/0UO17lZ7Gr3zBuyD4myi/Zu2P8t?=
 =?us-ascii?Q?zjQ22IfTw7r4izSsyshDkuIAfVU0kWx/vPCeubz4rFcbQMitixgMhG9OQQbs?=
 =?us-ascii?Q?Vi3wPmoQgQJ63/25NPEEDDycG6OlqMHPeuUNwgg3OYA2pmUnKK2QiMvc0gir?=
 =?us-ascii?Q?zPPz/XvGLvssi8Nsin5c5ZJjcDkJC0VaE/7saDsKXiZL/c1PcsUJ6ZRhs5zP?=
 =?us-ascii?Q?PMrtVwOWtAly+xOfKN+ex0WQToXa2IslZbw2sCyiKLGgAPDAAk7R0h9F7hy4?=
 =?us-ascii?Q?++f09ZirNmpXpeXA8eJervOthjRH8q1Az+si4QcPb9UqZNjdWovoFz/GZxFT?=
 =?us-ascii?Q?wa0JHoQi0dzhOas5enI1C1BYk4BnPtbZgXyyZw1m9OEO+5tYjAMng8U1wYh3?=
 =?us-ascii?Q?O6V8R5cSDQUzVJKl2ds2h6xizXaaUZQEZ/BDtt3HQUPvw4unQZRkp1lIvr+A?=
 =?us-ascii?Q?yy/fo9Us0yRyim4UPQaAyz/6W1s7HE+TwFR7YuoJb8v0maB002a4MmjLryGU?=
 =?us-ascii?Q?F15eVgjGfIFRNywzggy8my8UqMi5WXDqxg+KZD4J0gVyUvM/c4FCNDRf29/Z?=
 =?us-ascii?Q?HkhbNjv3LYKN5tpC6PeSXCFa5nhP8Mh0+Sekts6/aQYCewhdH8aMHcog61w7?=
 =?us-ascii?Q?VfkSkaVHBSk0GiPR8Q1rcJZqGz/apq68vep+GliDYApRbEh7F0AcGxZy8oFx?=
 =?us-ascii?Q?arZj58QjB2sR3j6PmxL6C7DuXNg0/NfrNxH94V7qmn9zRh8p+1BRTrbIOM70?=
 =?us-ascii?Q?OtlU43lwdS9Ff1+/VB2ufK7l18jHL2pF+tmPdHTXu9Q3XBtFVmqCH9UPqq2t?=
 =?us-ascii?Q?npSmaXUTv/CnAjgkqac9REHcBtOrj6djYHliyKhaYNkRDa5/bmDRXI9fibyp?=
 =?us-ascii?Q?igKfXL5LcVeBFvIM5/TRzpeupnDh1XS1JblXru6YS8AIgxvR0+nDfRafXxkn?=
 =?us-ascii?Q?eO19j3iBBHbqAfes7lJ5+O94K3QgINS1GKLpsTXHMO81gUofaN1yKryoOsaR?=
 =?us-ascii?Q?R4G1mfjcIl4gnvE7DdvG9mMMzyXfc+Qk/s/EMifFpH754g2wbDMWS1b27DT2?=
 =?us-ascii?Q?DncE0msLkeQCon+SUHWZSBtU9pXdKdG8gfSR7PTPN5cJxDv5SwADAFx3mD+8?=
 =?us-ascii?Q?hz23p6HLLdglS31BlO8khPGad1iF/azOHpRY61+o/KsANJDiRcyzFlwwYILP?=
 =?us-ascii?Q?TnoYUz1uUByafUIVZ/jEIZeaQITyWRnHYTvXud/JgSSPmIHL3HI/Y6gVs6d2?=
 =?us-ascii?Q?yqvVptUIzc5k18MSzQ9hWbjkHfLHI+EBy4ioOj01bvbi/vaDqpEvFFNTsrRB?=
 =?us-ascii?Q?wCqOsQPA7XPm/F/CGs8/Lldk7YWtCDKqQIVNgtIyexxfP0aR3DM6hg+8wCy3?=
 =?us-ascii?Q?nrIUuLyEMKOxLNv80Nyiw3Nzruzl5m8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JCiDnaoOAFNIaWwFw9O3ZT8Drn6qyZm0FZFKiCBI4x6XE6HNJbmLjRkX/LNw5U+uuavT8OB3VamYacNww326puFPBuPjzZZCpGNf8jfBMUicBVZIJLlDYQDre3xTghrbuy191DoKKzX22dXmU4oHyuPjLM+qgwiaDlNGP4d1gCSyVZpgrDcGQHCEIUD3L/hKHue5MZJYDgEmY+zG/rWwD4+SdCLDC08906RrEh8c2Kti5aAvMuSDZZsz499+AGXMlf8zfLHzeftWQRQ1ajs3TEgCTa8gMrnLAJom1pXsKc0ULE3MNvbnh/Mla3RhToJIpsbtV0Dh2dX8ocpKujoUItyvYyLGFV/Bx1EMWLyCSQBGVzDE/kA1hVROKrVdYWHI2ZqN4wbQIOS3Mu7W3CRnkOM9cGfatEhcLZq7xvcaPJzFhwwG9Ub41Vbfsb2V73Nx5hAPZDJSOS72W0O5KZWvn2njSM2qHNxfGnTpcNO5H3ry7mSPl4r5BIKssWErJ0L/g1Z+GLIzvVNvuq0xDrb/aGIOF1lQdeLz5mf4B5p5dnpM71mQ00YrmO5iVs/hObqpqar4MHhVIbwENasr8NObnzZEKteom3gBY1O4VXDN2Qw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0525fad9-1f53-4fd1-3e8d-08de74844019
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:49.4822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WAfvhSZVmpjX98JZPeiQ3uJuRMbNYPv/BHTVI0MSK7BOuSBuoOLEpFMcU7H3aZJ3ORpedEnsZWWDrhbDriA8cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699f1808 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=-Lr9UA9ZU9FfJu8vAKUA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: HG95rMxTiN3aOuAFB7SKnnRnoytKNi7U
X-Proofpoint-GUID: HG95rMxTiN3aOuAFB7SKnnRnoytKNi7U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX5VlVI5KSJy4S
 JBjtVlB7WCW7fKcwpNKPPGZwWKLYudllxlvWMhebxulmIcnchDkLc0YAKlA6lH+REHCmRUttdIl
 GJWqidHZKpNyxLYWo5l87NFvoW1Yu5E94b6h1XFIgjIrjVOt9Vtz3HvZ+cSZEU6sAT4udnvXJ/Q
 d062N784SFGD2uWx02oFQnNUtj6yBFYPRYKCuL4CffYiB2Avg5tZYbLolTR+lOmNMyeIbH6ABW5
 9POCsBkHl3SMUVvtbyD3HCxnDRkuM048CUBKpCbTytAGHgvAYjCn+yC1bQy+AHOF6iGvKrzYbZ7
 JTSFDS9ubkT91vJmD/JWQNtka+U6MVjMILWU/wI8LRizb25Q41X1SH/Uqc0wsEg/pk5piOUkDX+
 0102WS2z5eI7mzeeHqVxoqTkbr2Rl3O/6NBOXTXSnJu60Owd44g5mJyCnze8vm1P+KecLjxNPxu
 HMeF7OCNO1iOebzn2ROKvkFuyHUY2dOwCvFjXfbs=

Add a callback for handling .get_unique_id, which calls into
nvme_ns_get_unique_id().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index ee7228fced375..15fba20cded67 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -610,6 +610,12 @@ static int nvme_ns_head_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
+static int nvme_mpath_get_unique_id(struct mpath_device *mpath_device,
+		u8 id[16], enum blk_unique_id type)
+{
+	return nvme_ns_get_unique_id(nvme_mpath_to_ns(mpath_device), id, type);
+}
+
 #ifdef CONFIG_BLK_DEV_ZONED
 static int nvme_ns_head_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int nr_zones, struct blk_report_zones_args *args)
@@ -1517,4 +1523,5 @@ static const struct mpath_head_template mpdt = {
 	.chr_uring_cmd = nvme_mpath_chr_uring_cmd,
 	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 	.get_iopolicy = nvme_mpath_get_iopolicy,
+	.get_unique_id = nvme_mpath_get_unique_id,
 };
-- 
2.43.5

