Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7383ECBDD;
	Wed, 25 Feb 2026 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033866; cv=fail; b=W9+opTSQvGC5FtuVwzzMtzubkuBr0p9+NIyXcE9gfsl0VPay8+vCsJN9ejnvFqzOl+0AeXOkbmbhSoXQNzH6sdvBpHvDPMq5O/p9N4EgS/cj0256HYMGjED1j3ob9wbYymZsdem+0LFwYnpepkxbo81VR45Lt8DvE7CIimjoYXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033866; c=relaxed/simple;
	bh=z1NfjG42wf0kEbqhwyYvU/28AkHLKd6cJ7gzaRR6754=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Oni1nB2NNZ498jeUERYyJNPo/mB1Zi1LgdtqKc85tR5R9LoPQ/ODzSSLCC12vbnGv3wrJ6Hq5MGLdNIYuQneRG7nGfYi/mqM0ZkAkUkALRqFw/5DPq9Sjdc6McOmhpzZxzH9/WUq04wOiVOSJzsXjNXuD7hlf8Qph//mTAuh34k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TPTPVQHX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F3R/KhXE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TPTPVQHX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F3R/KhXE"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAjt7K817332;
	Wed, 25 Feb 2026 15:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yb+lTrEeNM0VNLi3d1oyBIg/R3ui+bCuIQvEnaZUTBg=; b=
	TPTPVQHXNjBZ20ra1tw5hw6eE1ZjssVwzQQT9UcUC9UpED7el3Dj0FgRbpJb0MUr
	oc/NjYUuiBr1wfWZPt8wD5kzs794ntHyMp3TmhIAnYZyAnYcDWLjHJzSklHIUGEd
	40aFsDDK3NvCwI2MidWHuAp8QGHb4llJc/UChm/8IMoA8HVI7Bxu1VXMf8ADOl6E
	gQziuZB52gRjLkFBEu6Tc1F9TVkdL+MdR3O51lyPhLRiciCPfON3EdQmKjwFCztI
	kbm4TejEDg071qcWNbfQCNcz2O9Kfj6WaN878r+m8miwYcJYkhuJRj3KkvdGd1Ya
	XYDkezh5cqQ0uyZUEe9QUA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areenc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE0UGe028678;
	Wed, 25 Feb 2026 15:37:25 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7j4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TbcT34tBStjigoVGnfMUiXBqbkE3gmyBzUf/2410keSnLKLfM0rmDkBfgmuXrdEqGYswXi4BmGsqw22Vyj7kZz1ok8bfNwajczya6kmVJlSP1mJum/z8nvTAV2dQ4SfIMvvvCCu+TyYXN3e+g5UlSFngwwFFdYM7jdSmqN4U9t+NrLrUqSKWIqj9naPl0oY87p+tuFQmllydq/De/S0phAO8tW8J82KqtLR7xxpqUQHE7AUMt1+rpVe5yZG8T28PuJw4IUorxypphzdiy37vwzagIj8G1YminjXxmjQeQo9L5U/X+OqcPsraBlwJDlXDszWggEPkaDfN/ZStF2Icxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yb+lTrEeNM0VNLi3d1oyBIg/R3ui+bCuIQvEnaZUTBg=;
 b=WkuS0zF+ylhj+y+1dxWb3AWMP+Am6jpzrK0R7b0z6uENSogqcCDrgLH/BJbA+zcOgmpsDmC7C4CWD5PS5xXtSH0li3w2U+QGADCPl27n8JmovMOhNpo0OMGNnLPshGNJQoAfr9+4HwOKkNYYbHSmAc9TZ4j1ykQSlaTsq14WBZbRsvgc4k5l3a9M7eJ+7DNqaVICC3YygXSwkt6CGl5de7CUsSeOyi4OE7s5pmmM1FAfJnm5fOD3vEr2356DOSJolNYq1FjzOwnhQ/PYtrFn1niGuHqvMiJ+v9T/3aoYsZNn8lsimcdl3FCFw9ui7yktp2vzlVuP+VvGZQM9t5brXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yb+lTrEeNM0VNLi3d1oyBIg/R3ui+bCuIQvEnaZUTBg=;
 b=F3R/KhXEAdW+GXH7oImBQdKeNVxnrFRVLkIOX8OXYqXAc5ouxxvmhDgWg/glUXaQa6WzFx83AKlZJQfVI7fqHO0SE6PLFc7ijMK8kMOjMdLRiGi+u1VzDsHPJ1Exdmx8+Ibit76jiWrEbiHnQFcpcEQJGM8hljhM1LPGgTJyqIc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN2PR10MB4285.namprd10.prod.outlook.com
 (2603:10b6:208:198::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:20 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:20 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 18/24] scsi: sd: add sd_mpath_ioctl()
Date: Wed, 25 Feb 2026 15:36:21 +0000
Message-ID: <20260225153627.1032500-19-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0006.namprd20.prod.outlook.com
 (2603:10b6:510:23c::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN2PR10MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 916dfc99-af3b-4d60-1f5b-08de7483c389
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	T4j89n+z5R/y/veIbCXJW0x9G6DEwMt1Z6U8fY2Delb5o1TfTtD0eMZfqjrdzyIzC8w7+gTQ7ey1Qp8Rc+0TYtjU7A1bwugTsWUIfNPzRD1sFmB6vpHrr/B375Po+9+4Yt6e4UJUlZb+cppmkMuuyC/Zlv6iwBlBnRvSIgoUkVU3p/sq4nnBu9QVAdEAzWlzu34IBOk5IPftRwC2d1aRhe3HGj0QcUcPElL3rHDzkLvIxmiUAuC9NI/UGzE9vsN+7MJNnx9ztVIOSfM/xwXQS7O/ndyqKFUphTeB3QJ8Bt2CDuOah/ExKMJPgIU9jxrx7wEY5bBVgcR48KllGOhR5uhn+JoJl1zvYX6HOM4bUlUycLKcZLYOoAQlYfITBLZ37S++1e7/NyEQT2s9lY27yzBRrD4avZ6sHPAm+0N8CeoV+YgcMVKX6jXlw8dGm6aqeVo4teloGWddCFhpNOk65+0RuXfSHjFlqcTaspz9Y6fTD83DYuTku5J6IqoKC9AQO1LcICE9zA3LTStZfDHt1u9m1kVC337zIiWvqAZS/fcMHPELp+oQHKIIVoEyxn1npqaMRNFFcgt8Dr32gNl1XtYOWGcdeX3lUUP65I8hC/iPJu6k1GSQWdtBCVOHYMResSHEzuIx7Crvs2MW1Y4L2fOftI/kJoolC/F/DUy1mL99y1r1gMtMltCHO0aubPF8nt7zzmWbRRy2nKp/uNQDpINsrRAAMUhtCnKV+h8AM50=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WvWJ2a0QhhjaouR8cgSp7TowUFkCgHCoYTccwd4CNUGznSaHRJAwJfp2ko0Q?=
 =?us-ascii?Q?cmVE46zWx8I2jQXX3aUziVvG/reQmJ6RCTK3YBS38ycJV/9sGy+x+sjN9+uP?=
 =?us-ascii?Q?J+N6jx/YWP33mlV7qTuv5vV5dOUwllzwRtXhWofBOAdNmjaZDbNrdSWRM6EE?=
 =?us-ascii?Q?w31yn9zpPiAUAF3KgM63gwXJCAjUDY3eBlQkzazotydZ79Kv4RzAbxsjfB55?=
 =?us-ascii?Q?842QdC8VOyVYydj/FgycKXp6sFAwXq4TAVT+GX28Xdm1MvxV3OHcI2kvpc8X?=
 =?us-ascii?Q?7uDinZ7F0VQKBt/r1+jFAwG+iCalHQFEI5MUDoDN/egV/59aQh28FXqaYaiQ?=
 =?us-ascii?Q?KQ0sgHPTtDtH43nvbnh2BI3WaC+pRXHKQkSXmTCCqWZAswsM2assV1iFwfx6?=
 =?us-ascii?Q?TzHjytkrLa8EpgcKhRCD+APjDAy8NchsWUoT8DmB1JwRwJl5oG+UO1vOK5zI?=
 =?us-ascii?Q?MPFGoavifNBowf9jU7/Uv2NsmamhBZp4v4Bu+ecO1NDaeXBWeTmw4Sy+W9mU?=
 =?us-ascii?Q?UozdDGDez+aonj5MN0yi6j/HqxeKZn6zR00R3WggXHs+w+T/IVoYXgaVLRwY?=
 =?us-ascii?Q?r9IEDasBxcppjyWp+tSz9u4PuqRcbtuVt+0W2+x27ZVOeSmFVqYjdBr5+3rt?=
 =?us-ascii?Q?3gMyx7KON4rqWs6+J29qG1nBaPOnUiJrK82lsRp0oW7LPwvFKb814BwOdYOl?=
 =?us-ascii?Q?7mSV+QmfVEIFybPev0rppR/dlSLiXiRMcNUzRNZLV5WXIYpsITlmhV6/E+zk?=
 =?us-ascii?Q?racHLhjT79JPLv6XWU6VjPuyfbQDu9VBZlI5WZF2bqzUpU4I6EcVJARBD6r2?=
 =?us-ascii?Q?UDXD7dy+fhlvB8QnU2pD/ihNkh0p/VNhqGuk8/pYxif/1zHHnMeX2n4OkRM8?=
 =?us-ascii?Q?7RSNMo38wHDf3pjRvdP9msL+gyCAUI09jC5LEmviKvp3dlxJvw3n/z3mBN7Q?=
 =?us-ascii?Q?9S6yPLc8GWoK+61PWhWfof9QRIDH18q/dUH6Voxse6fR4tEiHDazKSfyQoo3?=
 =?us-ascii?Q?HnYyb79E8+6unHqltk8wtz8/Agj0BkkA6Ym4QuPIGedwMX3w+HHPLtQpLn1e?=
 =?us-ascii?Q?zq3aOwRfOIsjojC4nQwMFUGOcfk4f7gI2UrcJluMD39Q+xJ0BEeBzFVa3nqy?=
 =?us-ascii?Q?HBqXTf7ljvABibdlqc17xExBzUmj1qBnJAHwIDUe88zNPeLi0MjrmJfFzzpU?=
 =?us-ascii?Q?EO1PZKXZhO+UuHuthyx+zymUyEjeztrWTSBlINgMdqd4ROkZDqDgjXyxAf/d?=
 =?us-ascii?Q?qcI1nVbaoP+HBZ+GuquL+4D85kvKIncqZ1uw/vIoZ4r0YDQPz6FpNJKQc2nj?=
 =?us-ascii?Q?PIoGoUlSMhBkmodD39cYr091/jxCfvhZyovjBFxCuoQYmXc7vp/piHIrYof/?=
 =?us-ascii?Q?tE6EmT7u+X3hmwr9yUv6NNoplhGr7k94zVfT6WTlvy1K8AAuSN1wa8oKBM7z?=
 =?us-ascii?Q?XWHU+5cKR445+30IH78gEncswmfRO3woEnpGotC/OvnpHk1/e2Bvpr+hcaKJ?=
 =?us-ascii?Q?RlWC/5wbyXDFZ2oWWVVwJV3gmOciw8tdWjRw3aAXlI97aRCpm7qJFBnO5pWa?=
 =?us-ascii?Q?bxw20r107yFNMmVN8ppHiBXo2jIqDbJpq7Hn51hJJw8eLZI9w+kqR6iSdX9f?=
 =?us-ascii?Q?VZJ1B8B50aHXULD20YCa9ti2n9wcGPdxkvKBu4m30Rct7HODesH8jeY98cNQ?=
 =?us-ascii?Q?r0UgEE2q/BQHhH4RWO7Ir6EdutqFjEdDcpaE2cUNaIkdjTKNS5QdkKdcJ9bA?=
 =?us-ascii?Q?04EFSOVhrbJznY1V6xU3hLpOTwfvxvM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SZjxuAQ6OJIaq/iM8sW3iVckU1xr5O8e94HOpj5iP4nKpB0zNe7ST3xu5JYUMJP6dQoPTZZX1kIsFZYah4FQdzF1+LWxISBSCJeXhQgk05npgjDsiqBVNVKY9PSZn5Z4Gl40PW1Hc1FyIqJqxKEpCvNsgrZvlPVFcQr1pGJ/X4jv1WSwxNgSKcRD0EGd1ZqzBfEl5zJ/EnWdJZJ7X18SGTOCLzgrw8+fjR2DlqjFLraZ0Tnea4RiZNLtvkIfvy1L5L/ziha5lSj1JbK8EsQytDqfD4PhOLScHdEy45SD3oQRbxYApBN0HQpVpFlLEV7nvhLVIm876J2Op/dNRdWZerBc6zeJEShGVBuMbKAT6PrFfT0v5PET8PkckDHK9HiGbYoArelMJyJRAj4g6PLLrFSd5P2jVOm631fK3nEpRL9Lu+1a36yozTxcCgAVFVbNBEJ9oaDQoRuaYEtlevNCjLT9E+w+110mgKogE/apjMWk1xtpAOZmtU41GG3C3PEPIuGZxCsVhlm4yHr5wbMjDvyGFWXRjmL57yKKr8lZerN93WXxwuGpLlOSSUCC1401ZKV758XMN1MKLFJu5lYp3ahlu4+Ag7QaYK6prft6Yf0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 916dfc99-af3b-4d60-1f5b-08de7483c389
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:20.4606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w58XuXcVbIEsH9sR23OVVkX7xbxQdRTb+FBCJx+2rHvXxNGXA5xqNIvQkh53vUqArqnHAnzhlF6VGjYxNZPgvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f1735 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=v5Mwit03CL4gI8pcBxgA:9
X-Proofpoint-ORIG-GUID: Alee6iG7ccQARgR_paWFYMLNYkV1swns
X-Proofpoint-GUID: Alee6iG7ccQARgR_paWFYMLNYkV1swns
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX5Z9KskwaJ82R
 X6HRd6JxjWcUbr2EnlWueOHTBHqIOycrzwI9q7KrvX8KMjET/LtFMw008sYzncRXVSBBK1ugxzP
 DkjAvw6rFrw/Fc9tac46eXWCSVPp4jTvPnP/pWnDFmjn3jOyPEpeIns11g5pVfPcZW/29ZckWBz
 KTbuIzFt7dQg7PKMwST3H3CFqMTS3ZWwSfxu8+kosYX81Br0bpDkh1rNLANG/GCl9Wcfh39nplU
 Q2/q9kvtBi9IV+D0+RLuXS7Geqxp/k5oXCfy2KHqERSjjSqTxIDTkRUFOL4yPPBok06Vcbw4Ter
 i+x1ULlHDA7WqtpRc93AudZ5dASG3qNhPUHm79BERxdMApBLZULFyJQ+2pIssmTesqvv1ra7kur
 kfpJUBGCiIFbUGFEgEzpk3RyxpgKSONYEy8FAfVxOIAi1FlG6DCZp3HQiT/0q9AFvft03n4IXY9
 mEZ7xDdePYDCSaA1WbQ==

Add scsi_driver.mpath_ioctl callback.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 845d392456549..b807452a4bdc3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4070,6 +4070,19 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static int sd_mpath_ioctl(struct scsi_device *sdp, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(&sdp->sdev_gendev);
+	struct gendisk *disk = sdkp->disk;
+	struct block_device *bdev = disk->part0;
+
+	return sd_ioctl(bdev, mode, cmd, arg);
+}
+
+#else /* CONFIG_SCSI_MULTIPATH */
+#endif
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -4522,6 +4535,7 @@ static struct scsi_driver sd_template = {
 	#ifdef CONFIG_SCSI_MULTIPATH
 	.mpath_start_cmd	= sd_mpath_start_command,
 	.mpath_end_cmd		= sd_mpath_end_command,
+	.mpath_ioctl		= sd_mpath_ioctl,
 	#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
-- 
2.43.5

