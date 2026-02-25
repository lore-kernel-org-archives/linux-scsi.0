Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8EC3D6696;
	Wed, 25 Feb 2026 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033607; cv=fail; b=OH199MudPd6esP4gXXP9rmlzhjADCvcbWYL1CCpKJ6flMAARgq0gmT9A17Ujq6lIEc995R2ryUxqjFqmZ4c0QrqzrFOOuiyHuDAUtVXgmxGzEJnHzx2uPlgt7mssX+1JjSGr0OWs3q+Zn1yPreRClYSIlPdfbUtihNXCU0S5hT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033607; c=relaxed/simple;
	bh=NOZykaA09irtra6F2eeva9ZeWS/jMWY4eHPn9l5hwLo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BGXDbyhc7nTkZ13NKe4jy2GzCx+7tZ6GxWgFDFuLsOOeg/o778Xih7mR17Ps1pE7zG50S9RLYAwgjhlJMIVwYS8oXHE87ryH1FdYW6Z0h/tfqSi7/yJkQ/hjVix9/yhlgFSk6emPW3TaY/yXZ4wTp6BgOJP5c23rFzvbY6XEKSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O3lbHs5O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jqDjmH1c; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O3lbHs5O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jqDjmH1c"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PALCqq3928816;
	Wed, 25 Feb 2026 15:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=f4sSk8R9aKkRAj/c
	xRlvzCXZ/TCerpsPf00ZnvvBziQ=; b=O3lbHs5OTSiz5GikiaSHbsGfLfU85/hV
	EiaswLRuc8F8WU8z+w3k/5w48PGHASK01cnY/ZWy6ZG0aTFGpMvMeMPsN3802DFz
	A3ayssErkxMVV90j8lbixiz98BB6CU8j+e1IICdpKS6L8GKA1J6S4LQi8YODqIoq
	bkWvqvyljtCWaq7juLk0iCiyHNEelfZNN7RrsZioXqZqg935n42sE0NNq3SKfvLn
	f04GvA9Dg300tY+1L24V2QRoSqq40iVgLFmo5CQ0nJWBjffhzZSoIIlOm4yPF6Cc
	eXot+Z+Mq1roWMLYHlT5g5BlipqEzowmb1K7APWwlvi77TSqgBABpg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qedkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEXUdj013310;
	Wed, 25 Feb 2026 15:32:59 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ffugs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:32:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f5A59FQmCRG3zCy1FMyTPYFnlADdj/c0VTRLqewLLJaBAmtU3Vn7/yrjgz9nhjPWFWG61dndooNL7MaStwVZWvJ4HxvBrbmZnbc6HJqw3Iq7ElZtjTnSJOLHJAoVXwPAaxq2LIJFJV2YGaRL1Qmm+/LQXhf7bChExX7qvJSOVtIee/RP+zgc/8rytU7XybdQ+6n4d4TxUnpDfs/F5cWlpdHpvPgI0VyToF1cterMEJdsqdD7kkSrwuJ4pblPomBu5SFiJlXYsIzOIJiHZ1dx5zoPGLG8ZTYtqbTnljLzCzlFl5kixfVLhPNKonetT2r3swXo30UQ2naB7bDH9vuvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4sSk8R9aKkRAj/cxRlvzCXZ/TCerpsPf00ZnvvBziQ=;
 b=QKtgawRUkfBI5dqgNrJMZXYVjKv0yG2CejB9yKKr2Klfp7+ayfR73jkLJ2m+7hSQ8In1ynGrYLbrgp7jvtMwEbukdtvTSFGwLOMp5FLSoQ1fY/n1jDp5V3SxbA5uSRW2ctTmtyCFq3D6yykE1o3VBEcoTYmH51SIgO6ygkpwShyJQmzpz4+LrubsfJsDXyPJTL7XKGRpzgy/U6+7chulSQfgeqHZTB1twM+oI4ptEbnJHW8/xJ0itBAicB6CWsqysAWpjQ7xNGvSHXfJgsw2338/DgoIhhdrYsxGoKQmhPOypnmSPzKBiDXLYQBJ3sbYm11jW7mcnV5ti9XYDsp/4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4sSk8R9aKkRAj/cxRlvzCXZ/TCerpsPf00ZnvvBziQ=;
 b=jqDjmH1cLQQpJKy5ue7KBlFPM3pXuZWpCwoikRa0mbdQveb6BSJB8e4chx4u/OBtsF3BdX/pUrrCleEFosqWS7NTmFQQbp+4ZwFPiETknwkdXiPEWTfrFm5XO6YghjEC06hPcq9mISCm9Aq9MjtS+4Js069Rcn7kIYWXlh1x91g=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:32:53 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:32:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 00/13] libmultipath: a generic multipath lib for block drivers
Date: Wed, 25 Feb 2026 15:32:12 +0000
Message-ID: <20260225153225.1031169-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:610:60::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 16f12772-ab02-4a14-4d1b-08de74832409
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	bfGDv/Wcbep63oyNuwiNNd7Ev3o10ujETvM64uPqai3P+UXWkpbv5auWpB/9xb7k65noMFL9zo4qq4FL0eWIv16jOTvQZvTGW4nENtjffVUA3ns8c8JUcwZOmeOjmT6DZMynT8JEdh0uyBVVUNKvHWduDaWuhJf/n34+vUnbN4f8MVvO3ttF5JG7kAiM543V9GfCRcQVAHyhdd6lrfIqxzR7kmePlmoiLuWI0XeGWe+35qy4psCSMmsqn4sfEwqyJpCt08TiWKjU52JQGD/hOxlCY0ka1ZGTAExzB0XyoSyatKoAiFZq1mz2lN3YSc0wHMo+RBgnPMhLS6hwH4oymlnx3vslQ6/PzYoyFpDJoU4veLFpb8MXLbvMQhbvXsf7USdnVYYSYSBhH5P2UVCZ5c8hRJKveDid8zUTFRBsIdWlWTtg/WT+eP3mzZZ1YeMuGlKNcyRnhwGMlKRHFrEcodZECHE2m3rifBG7IgY/yGiwga9V2sMnsiL3R4+oyjlr8+NF0LuMwO6nUqe9OSo/SasXEGanc6cTqkwpnYIZ0zOGsW3RUhhuV1SzCLubHQnJBIbjGP8pp7T76KOEjVab6x4WXjTDUXllmQ93EOezrulEgXKjlPNv7E0IXPq7UbC/LVY0UGpqte1zk187VPCPQNrLixADt+21TjsdrrFxQ5PaszswhPeuHUCD5aUE5wcHcsBD7bva9NeXfahuaEMOD7uheduPuQ/jm77Ktg1Hl5E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BXnaQR3ve+0rWbYd7AeQo+1Oc07/H9zk3Dvv6oPeSHBozrA0aCa0Oo9shn4K?=
 =?us-ascii?Q?s12/4gGOweWIDdflLZzKRoafOj8Zl1GZF3gbbRfsp+2LDr6TDdxAsCpCcXiE?=
 =?us-ascii?Q?ZdEijDUrjEGkXjSOBcXUGf2ZyNaFOgzJSZs1tXDBQ+CATo9yGPOENd+YQJdb?=
 =?us-ascii?Q?ZGHL/1yhkbjTQZfDYF1g9DU5rOS1bUz04oS0KA8XidAdAoWSX5PTODEzsRzC?=
 =?us-ascii?Q?5efjKjbwztl72Z3KKCEU0U/c8jPNq6AiyA0itFSja1LDM8ri2Jfk62KqFPmm?=
 =?us-ascii?Q?jBRrCEiZOF5z58iI/JLWLhgjccXGFDsebRuDaW/cIylWWU86z8K1FCjyudoC?=
 =?us-ascii?Q?Gcp0z2aAJVxLZ3fiw1CO+Wl0fLTFl65PlXNzpadnwI25/VhOL1iC7u8fWrmm?=
 =?us-ascii?Q?wlZEeI/XTy5e5TpQNha/ap6uBUe1TIUcl4zwCgiYAEpQ1mYJIxgpHD4oqFHT?=
 =?us-ascii?Q?5U6vekMK6XbvZW0kDWLCmb6VP5iR/qKh7QNa/OqlJbOUDTcomFaXD8Pey9kC?=
 =?us-ascii?Q?ijLhd8UBUCTFhcxLBioYRCJk7b2f7P9p9HThBlsGE5i01mBWlul0/Lo0vPZh?=
 =?us-ascii?Q?6y2Qnd7K4dxQUomP6dM7iImcTF4jBlp2Xt2cNsBSDLhTQ2GM6tOcYZHMowPA?=
 =?us-ascii?Q?W6MuAXvQzQBrTjKiciU0xA5EYg23XzRL7OzVC/LjA74XXiewhnhcKDlPRe5/?=
 =?us-ascii?Q?9TXMO7A8e8gb+1y83depD3M2kesxBdQKKSlRLDk5vkyyOJSMgd3BMrXIg+Cg?=
 =?us-ascii?Q?bTUAlouY5Vw8odAuv3jGK3Ti78HQkEK+Z0d4ycGAU7ggE+TvpJYQEnvAHwSd?=
 =?us-ascii?Q?G8vnE47vWwIESXihnGv2M44c3NX6fJmJiqDyxd/spZnjvBVG4cyU+mVEZT/r?=
 =?us-ascii?Q?ihR4t5XbYlHySulWwMTi0bKeS1EZrTCoQE2cg5uxgFKKNx3CpqXETh4Hu/fk?=
 =?us-ascii?Q?swU0v+ofnFt3zi2Oq4IddYNuIkbPu5tWy57FVyItDtauOUp+/Z+TqqdpjWP9?=
 =?us-ascii?Q?hR2QjYViZpZ6ChGCd20rU0hwVyrYOdZoVf+hYsRncC4ja3qsE5KDKWxE3aS8?=
 =?us-ascii?Q?hlhh2dTZ7P66TQxTbIdBhZaoflEbk2FuYpjLcpGxXEOda0IKKMpVWPgbsFdI?=
 =?us-ascii?Q?ejASURySA/zu/8HSk7dV6uSr96r+7GXjWhXDzb4QQuhCwNlOZ7Z2TVfZcXo0?=
 =?us-ascii?Q?Po+QmIan8aOvCTHBuuh9WmjrqjoIf7CLXZKMtmgv5muG6MqqkieFQgazHPkn?=
 =?us-ascii?Q?PXBvJMwl/9Sa++x8hnRKxs6/P9dAUi2FgPd2GuKddOoj/E6moGvYWHEDtqi4?=
 =?us-ascii?Q?kBTMYTzpAwfoHPHKjDE/mtZWyTfv6rU2KT/581/z0LeprOtbnAnhGDF3Ottx?=
 =?us-ascii?Q?pca47sHbnjEuP8ewhTjzUbgqb5B0v7qEvSoGpTc/oX6bv2jmfm8S7l4jlLlt?=
 =?us-ascii?Q?65u047fo7c34s9Tks3m2kCftu87NK4WhWmQshzNAuE9jDw14uTNoaLfk8MV4?=
 =?us-ascii?Q?kcwdWST4EvhWvzPF/9KdIsQyG3yt0MMDPvwKiLl+IGIJ30W6aOQM1bLBJ54D?=
 =?us-ascii?Q?Hz7E3k3GwccvPprVNnbYT1QLmwPgxnUtDpccBR1IiHUPYGnpTy7BMN1jHkGV?=
 =?us-ascii?Q?i91/WanFVftJOPqglbeNxweyvZbWi6/kjZJA6eTg5eExayq1VC+ktzidzyVz?=
 =?us-ascii?Q?KnBdiSsInLkocxz/R4Ijph5ZeoGLM+knpAQQ/IpV+qngbigKIoThjhvxBQ9L?=
 =?us-ascii?Q?BDYzaXiYtktijmWf2Nn1GH8pCVO1Vww=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TeMei/E/1gbUv1/EcDPUcKpshqHmKLUvIKDoPmE6SAQ0DIsSkR+llJ1mN6UIl1DLsq+5g+eqvW0cP0oJBjtsHY5UMS+gERsA1tKjtrgVyPxzD/sYpD9EwbbqOOSnkew2gIwADQReKUuKqXacDDY1ISNf0PysfKa99+/V680MDxgSrIJuj1fP0M65fQoXuS/kwpUgcs1szdbON/xAQmGvPS41EAcWXrqPkxhW84ODc7xPuEoaYdzViK/2tlOTCj00WGfD8UJBgsjOcIvE9Cl6xpOiNTCVckvK2sXuPWOt4srRqCyo7JyE01BTxz2GegUQVa8PvziEsgpScp1jtmcrNT3YU4HSEd1Hx5kaif0NWsPLmqPO4f4n7GeIZg0ZKogVanCiDf4M7/8Owd8Wo2dA2rGEbpT8Ccir6jsRKm2D8cj9Q95Rx+kFuZqXHksAsA10y/3CYkfYjUQwRVT22P5Ua2aiTSORl5GQMwgGq6QxkX21Qm8RGXBAg5L03HxZ+OO2e0T2mNeVgPGHt3hy8gwuz1MtzaH7OofRk08E7rqofaEdPD7WF1YAvIwTQcgJDs4FTnuSlqb2fl+j07fBWF25wngC9Qmek2PyTUvllFaNHTE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f12772-ab02-4a14-4d1b-08de74832409
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:32:52.8875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwN/NoHziW6OZqYNxxVS7aRCmyBKWwqNuhRO+lGdvqiQvSkrhyQ7NQVImXp8Pe/EiJa42S2r5qmH38GbDoJGBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=764 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX06Jbzb8O0+aO
 iXPlgFPJqOcRfK1c1XBMkE2EtWer9mqyEuxi2X3k1s9ZpUGoUx0KCR9fcKcReCN/ufnCXieFTkK
 aRJ5dtVA+y84jesYXf1v3ldzi2ZU1YypO0Kl7l2MJjkMpUwdF2NOHGEIwBAxFUe9or32J+K7Le+
 L0hJuCp66ymRT2pX/A2DwkdcIXojil36S3foVEyASZuXe2FpGnnWHQiUErt8HlUlbItT+cj5GfW
 9OXBWKxQSu+b3Mqj3Ibdp509My/9GCL8DFXGcfruLRCxJv2sYYVlr6wft12DmEqrrqollmcKhUP
 DtqIqGL5OHlIh83XW3s5/Ha8Ziix+JMlTv+atLRR69smMPqkcTMPPkPXM5SIvtLU2VWvcrre9F0
 fVbT25VApz7RWntuxYWXRtRbvu6ZzB5/UW+mB5tmq6mZZhW5yQEMtbOhdwhoiy/LN7vz3v8xZcm
 B51mgIxFa6OG4RqptV66xYPN5gjFhfp/xN3AB7FI=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699f162d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=Wpk8RT9CqSaPrzIbi_sA:9 cc=ntf awl=host:13810
X-Proofpoint-ORIG-GUID: hmsDKE_EnjDhmh7WyAy924oSDlxFRlTI
X-Proofpoint-GUID: hmsDKE_EnjDhmh7WyAy924oSDlxFRlTI

This series introduces libmultipath. It is essentially a refactoring of
NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
may provide callbacks for driver specifics, like ANA support for NVMe.

Important new structures introduced include:

- mpath_head and mpath_disk
These contain much of the multipath-specific functionality from
nvme_ns_head. Seperate structures are needed to suit SCSI - that is
because SCSI has concept of a scsi_driver, like scsi_disk. For SCSI,
the mpath_head would be associated with the scsi_device, while
mpath_disk would be associated with scsi_disk.

- mpath_device
This is the per-path structure, and contains the multipath-specific
functionality in nvme_ns

libmultipath provides functionality for path management, path selection,
data path, and failover handling.

Since the NVMe driver has some code in the sysfs and ioctl handling
which iterate all multipath NSes, functions like mpath_call_for_device()
are added to do the same per-path iteration.

John Garry (13):
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add cdev support
  libmultipath: Add delayed removal support
  libmultipath: Add sysfs helpers
  libmultipath: Add PR support
  libmultipath: Add mpath_bdev_report_zones()
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()

 include/linux/multipath.h |  205 ++++++
 lib/Kconfig               |    6 +
 lib/Makefile              |    2 +
 lib/multipath.c           | 1261 +++++++++++++++++++++++++++++++++++++
 4 files changed, 1474 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.5

