Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F86416864;
	Mon, 27 Jul 2026 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163425; cv=fail; b=ce1LnmfNQD/kNB1xzxJ9bd3XXSZMocDRoJT4bipjjiZDmxpCN3fgM1kTl9bS8c4Gb8FItF88nfHzNYE4Xo8sFpmhPlfPKHT/shWcI1kDj9gVXQKNCH98n2cCC5z9BWU9QLHZHspZsWr/Do/G5JpZH8hEMm/65C1uzbVSrLEoT5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163425; c=relaxed/simple;
	bh=atnpu58xUSNm0FZ1QTrJRjAuYsW8qjY4LThwdaMHxeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NJRSfCB7AsnuQ8SUTSfIXV92czPVDJgADpfalDjGaCnofXPmdNeTW+6a6I7/nhDG34+1hAIQhLUiMEqCDlck4Ja4/FFURMjuD+baP4UuftpX1fIqKkB2Nzv2HzrsEOBy2ClH+uXPsDxVBpm/JqXK8FhuKS47Z5+810+pJG+gLy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DVcveEbI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o67mvli+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DVcveEbI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o67mvli+"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTSln2082575;
	Mon, 27 Jul 2026 14:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RkR38a/MY1GaoRgBpXLc+hBfhMHdSvBGmR9IDJnY40o=; b=
	DVcveEbIba2WigQvBDTFS8vLk472ltBCcEUAE/wQpEbbwq4sM9bRSMg0XjUcOjQq
	mEGMxUv1f0DZJ/HYmMVD+ggLbD7XDST4QMI1gUKsvn8Epz5WgLMan9jC/SDimpyg
	Hb8Bfp5Uq7j9LLPNNMY1J8pNfyyaUgZpy6XqWTOrdJegWFcQz8ZaNY0MFwpQR/P+
	Wvk4np7avWYXSzcOucTlnqrgCue7vRFxN+6CW1ktPISOwidrtncPmY3lsXD+Sb+l
	5ib3D44Vtt+QWZNQrmDhA7ggpZ1CVyDJ7hwtev8kfF1T9EbYTN0n8tEVVMTDOB7r
	n+PdbY2GxsnsAdRRJQhZtA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym1xkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeBOV006867;
	Mon, 27 Jul 2026 14:43:05 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehaw70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D3bzP//WV61PnaILwu7glsOp7Lu/gdtSs33fPkXFGRa3xM0VHj4RTtu32kpilMADa0A+leCqXo78bgAfQ0T8Lb+tLE3BMwkFXx41WuSH54Z35TW4mIhgptVckta8qQRidML6dFqKp6SSTdR/IYAW2BfbWAzvW8kd02ArVNDQiyGbx1a1o1O8q9RroJ8SdIjk9dy3WsKxerE+z6c/RDASxJn8vAce5iqlmiEPb/ZlWb46++QX6Ln8bBaxE1r6vFqT26eQ9mIMCecWQGRT1nCvNZnqgR5ndOM95tQ2VecLS/xi63Q0PoX3GouprfqZrBqBV8jbxQHAYgOnLbcpxrNY1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RkR38a/MY1GaoRgBpXLc+hBfhMHdSvBGmR9IDJnY40o=;
 b=L1gcNqaM5LgtWb+jIB+GKDqPmE4Kuv0sSSM+iEbERDReC7s5UMH/439wRXQe7z5J9kjpLU+HpcZ/9wmw4lCBzi0YT1pnkC9NqmHd2Efo+BwPz0vhEMmR5rEXT35sU9M/h72fZGv+ymgTZTu9i7bgnBaJCXKmSdKb+ST2E/1N5C/UbGFUHG4hfsN6WKZLJ0fk//nJ0N4LdhDRaQzAr9xM1sewS98K7THlrkMAVYs37UAkNsNuIge2KOMhBZi9Cq4YjsIQcBwwVJs1zy5vQr1qdNNP0ZZhlFKFMQZFbXlsKXNMMOOYtlA+BKmQld+DaM0ikTvJNNbFfnMVcxULg5Ns6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkR38a/MY1GaoRgBpXLc+hBfhMHdSvBGmR9IDJnY40o=;
 b=o67mvli+ivLSq08LQHrtIILRhbaFRu4VWBSs0Tg0J1LuTZlx9jBTl6pQV6mcAFYvJmlQoAKgNPjUVsxyJOskp7PjAe2XBiuVrD3kIyb9S9/5jFQkbQkznzwBWAVozgz4hk6DCsHuH2gbleMd/dcKF/HIq4v6lhpMYeZKwr6FM94=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:00 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:42:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 02/27] libmultipath: Add basic gendisk support
Date: Mon, 27 Jul 2026 14:42:09 +0000
Message-ID: <20260727144234.3802948-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 550a7659-9fbb-4763-099e-08deebed5a50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iPq0QzO55LTjNeckc9Ny+LJ7WXzIM9DVCLQ19admP5oJWckYW9j7h//lJPlBcgJnwyX2kUncbC/oHZIOgh4+dSNhges7UzAvy93hVscFj/daFgg+vAEzppbP9zCZ0VFB7TfQKs6WbvjbCXWMRlMl/uqcTDcYZxwTWm3sWypsp9enc4KIXkAzaDxe+KW0R5THyqtK3WdNPZOyewa29OSHksTwtJIL2bTKQPXn7e4liSKslaUt3qFpowEYdIMjY1fich1JRQDCf7p5xV5xvkaBZp6MF6dcZJsb4yRbCUIOZNERHxy4Rrsz9BEe0+0X78trH0intXwIUARX+Ln8/bSBFIxgUIRhrzX+78uCoz4CQBcn6PsABRlcEOO0w2K54nsGmpqezUvGthhIeWDXsjDL2m+EyyZX5GxiA0+CjVOAn/f2C/9bGLYtJDXGGKGhh/U7S8rEejVBbLKW/Zzqy/bOiI4j1O+wB5glyp91RtgJqzZVVs9wgXRY/tXqaAjh8cMYClHSx7vd83R4ZNXb8CyxfPlCY0SQiSLiILWV6XlOpsqdDroepUgMmknZVAfnzNpMEipzVnXuQRhIswXVxIJ2r7IZwbDvghPKa6BoSrrLyxkHUxCyVCKwDnyft0C9sm8Pm/MIpvVthgQFs86xnVT2V4Q5Xhk3s2yrvKdqbHg6Bmc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L0Ua0/jHcP1k4eBihAc0hVxpS4jJt18UIOmyLPLa/sIj9IcOhk1BHVSwDgT2?=
 =?us-ascii?Q?0YqDI+e1/NlahHP540kQTHBwC1zBJ0eAuq+FreAB2SzbBzq117HD/jeBjPhO?=
 =?us-ascii?Q?GCatqIQdHsRzHGoTec0YpY7EioHdUh4IzHsi1Kf8kT7vr+s/Efjbcim+Ui1p?=
 =?us-ascii?Q?rNOe88dBhHCHWqqDxCyM7WalblERztW8BwLF/mAY+tLbEr8LJBAS/57Bs+K1?=
 =?us-ascii?Q?E1uYF279gJdLRsoZFwyduUkO69YPx3n//fP9mkLOVp3wDUn0kCmvw1SoyFhw?=
 =?us-ascii?Q?ybdNGCQCF/WW3sUUXKfXaSHtJiAQTfuTobLPAJsYujIZOC7OiqOqNlNNTxjH?=
 =?us-ascii?Q?d3jhW9/dVKFHyDmLDuih8THT522RnY/vUtElVaj8lRJFkh+BOf73pWW+FLyw?=
 =?us-ascii?Q?peC9FM/0txgzLd2b9fMYI8aQyjlRKZNyIr/UPDaNqZ08LvGWNtlQ/XJiMATb?=
 =?us-ascii?Q?0M1OGLelkyidPE63nCpxWM0/OV0mpn1UGYQX+/ECuYyuatRG+ijxUIeuOz0G?=
 =?us-ascii?Q?cFKKaPVHdpmdeo13Xh6E6hoZHw2HVYixlx05e1C77LrKOMDy0huGzb4QgE8/?=
 =?us-ascii?Q?KEDSIk7BpThEV4P7CONX4LaDw2W40M7p5o/1e1KfrRAhIxRjznpIRgSAIXRL?=
 =?us-ascii?Q?Q21A4y1E6BMPc9/Qc5t64rEfOZQlbfZvXgP0i4+2tYuFynuxe4sngfM9Wsmx?=
 =?us-ascii?Q?nGrK67a2w/HwHuCdRxFTxgm4ajMXjmiehd1/qO3Mnn7s0wSWYsXmhmdaDpMT?=
 =?us-ascii?Q?OHbddVxunu8YMcJGyxW8mginsboqEK8tX8HCZPL8Ls/VBPLd3roFfv4NbrUN?=
 =?us-ascii?Q?kh5icPfBgXBL2HvwxagiAc8tLTI9vgQbI8J6fOahvUkGlbKAV1LznOXb2okH?=
 =?us-ascii?Q?YiArz8Tk1VLPVL39xBf3tcVRjqXlvOOck8pwt65P/HQ6/Ns0cGd1WksgUHkU?=
 =?us-ascii?Q?gZKpT9pmQIoKbDRZAK8YrGfyCbr+GZUZ25UyRWU5H2FcXoz8kvKFT51GSWrC?=
 =?us-ascii?Q?dg7kECPp0zIOMUEWNVres+EKAxXKfnfT2G7AL6S5VJGkDYTPMXmDZWq197FF?=
 =?us-ascii?Q?l4DMV5wKp8WbypP6BcU8C0433LtRRrgtJCskUboCr2TaJqBRyueDGiOqoaPK?=
 =?us-ascii?Q?jtDZSiASZ8JVCAV0UL5X5lAEHOKwAIqpVrtAb2JybvtppAy7c93ITL2p8i3O?=
 =?us-ascii?Q?+jipQt6KrEER9w/rQD5NXp1LA12xjDx1nj8hRHMFDl0CFux9J+sBFskp2A2Y?=
 =?us-ascii?Q?3kJPIjA6h95QwG3eSNw3KjkDwzRUsdnwZYAE2TAfBYwCwH/XUdZqMmrwJNLV?=
 =?us-ascii?Q?NaAuk+49s08tFyE0EJMT9c7UBqA+yAjOmMEQScCMKFpVLdMY6oGtfXt5aU05?=
 =?us-ascii?Q?g9kwjOPFOQMWvzpmNL5IToDcjczZK9ggK6zvw6so4n14h30a3s3VhiL1g6hE?=
 =?us-ascii?Q?EM0dLnT0J1yscrfI9H/My3VHN7A98kEQfna3QHKsZ7iqIJu24/5eFvbMddj6?=
 =?us-ascii?Q?qnwhb0stphlZjTVWWeaTDV/x4SIUh9omKkuy5aZQ2p7NxLV5klMJJgvBjYwJ?=
 =?us-ascii?Q?d4fmBvIcA8knChBybesdT+/sJsnGhXaiOv8Et3CjvnP5TrEQKiEWDM4+rpX2?=
 =?us-ascii?Q?DjZr2MGlkT4nFa1cxquIgk/dWW+V4JbxVrFB0eXW7KFlFsv0me00cN3JjXns?=
 =?us-ascii?Q?nYn1I0A1jixyvUpHASELTSWOcJr3IUGqVqPVdouNxb3MjzjwDm4kt/gczm68?=
 =?us-ascii?Q?2obWKKccen33SEIPBEGpiGU5mKhY5jM=3D?=
X-Exchange-RoutingPolicyChecked:
	QIISgIm7dc6VkcXH+wfGNTtDlvNO20TCQL6XQ9H2WuBEAuhYlDxgqQgp+Ciys9vzdL02VlNOjHg68QYOXOV5kO6OPE3VeD7XLTVy2FWJb0btGnr9lhWye+Ua7q2bzHRA45c8U2bzs6/vnpgmWYMZjh5nd34VY9w1KnLFo3+ugOYpJ4IIMjMCpvJ4A+wlWFrlICpOYA3KsbEkkMub96Z1v5nsPi12jIcjnLjXTR6QCR8q75vCmKeg+HtNlqIouhqYAVEbZhNnY++ACFypwbnRKSLACtGPgcXs2uAqltUMBxgp3Q1oaBLBBzpA1b/+ycWj69DOiDCFs/w0tYq2VdlfDA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VDdau1Q+KqXpA0hY9X91+Tss4f/GhrJ7FIf42frcwZhXhJG1ra7dkfKS616ZlXi2TkepZb6p+3C2jagiTcBUrcez54JON+eW+unSdHrPfR/wo/AxEPQXvVzpr7eB/g6QmYC+LcQRmhmSeddfylFhJ9tqGJcJShonMCsyVbzrc0bffT+yHLOZUOvW/1OOQyFCb3JaJm/CSz9jjiwNOW1jzkoidQY598BydQLkx85vJ8YnSAxF8gr+IW6CrMVC87x8Dg/KA5JmpcR0OTvLbJGOpq3NJBgjAO/o4bQQQc/dCx5treJ1MB6yqpbMiUYuMdOETvi9YYQnHNrqExGCjEqEDeC8VtQGC46+JlyvzoTHqa0GjSRIOhEr3SNIczsXyANdxTFU68z+qc9WoqHA48a4xH70dXVF/wO5rIi8GIWKGaQASQ8NwoyYMX2mE3mbrtrKjKM0A9nIueuUj08c5KtRz+U4LXH6KKxYwYoXZ9RWlTDopqQZMK8nh6nhDL0p1dRzWXBlWKTWzhGeMGq/ebZCGELAvxl88EQc1rRmqSr+jAaYZewFGicGoGh1KdBle88r1Y8s4AWHACR/438MNRNCHzrIgDI4YAljS3qdxzFbtE0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550a7659-9fbb-4763-099e-08deebed5a50
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:42:59.0138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QH8c0CcdC8hXa0rZ7AHXhkbll1Uv34naPnaOEiEAVQtRNsqakCfv3sKt+CoJSjbnJ5yjbDUcPJX7v95RzSluwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX+YdfHiSjjmbF
 ZbJYPyxVReXUZj++BP0uFM0GyS6iKCMoFmq+LgLxlmSHGsE75Dxn4enkcZmOQDq9C08rzLJ/+y9
 Yxom4Zf/A0W4fE3nyKS6veFtAhR+TysT+XcYnaiiUsFMx/+Ho0E0
X-Proofpoint-ORIG-GUID: ectrkso6gYNS9-Tm8t4aD-QWkyassb3d
X-Proofpoint-GUID: ectrkso6gYNS9-Tm8t4aD-QWkyassb3d
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a676e7a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=B52eoxIPv8yZRAGToxQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX5Pu8bq8WMr+i
 5VnGxOE5MT5fj259k+BsS8nYdUmkpTXqTQNH8BNJaYisBYeQzGPTHUbOm1pezD2yJuOA7JJUg2Z
 Z13wK6AFUP3GgO7F/e9K1JfmSbEPox0UkIASedCRdQXlF0IRT0+RGZU/c2038hm27hD+vu67R/g
 Ku7LQfkE4Az9XFf8DwuqAVnDPpFadjvi8UG2xGIXO0WOrLWkb5nb60mcBvii6pu3o0BbSmz0DdB
 jb2iSznCNujE5Z/yl/p+aJDRBCIgGhbPdhXOOI4ib2Uc7AHObjwkv0xzxkgGkfeuux/3wY0SPxW
 UpS3JqTmVoHaQXuK1aQLMJjL1UK53e3+/dtCS1Os6uIzs7i0iRRKjpL/s4H0G/Cq3Ie0JP3Tx0s
 R2ha3CdZCqbePqlNOlQefySrUN4VFz111/53leqRKfueE5wmpdjOIRPFgFC915GWGeDk1I5bXVE
 blBE6uWmqDxz0cTUqAQ==

Add support to allocate and free a multipath gendisk.

NVMe has almost like-for-like equivalents here:
- mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
- multipath_partition_scan_work() -> nvme_partition_scan_work()
- mpath_remove_disk() -> nvme_remove_head()
- mpath_device_set_live() -> nvme_mpath_set_live()

struct mpath_head_template is introduced as a method for drivers to
provide custom multipath functionality.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  38 ++++++++++++++
 lib/multipath.c           | 101 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 139 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 407d985cd31f5..ca6e02505be43 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,11 +5,19 @@
 #include <linux/blkdev.h>
 #include <linux/srcu.h>
 
+extern const struct block_device_operations mpath_ops;
+
 struct mpath_device {
+	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
 };
 
+struct mpath_head_template {
+};
+
+#define MPATH_HEAD_DISK_LIVE 			0
+
 struct mpath_head {
 	struct srcu_struct	srcu;
 	struct list_head	dev_list;	/* list of all mpath_devs */
@@ -17,12 +25,42 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	unsigned long		flags;
+	struct gendisk		*disk;
+	struct work_struct	partition_scan_work;
+	struct device		*parent;
+	const struct attribute_group 		**disk_groups;
+	const struct mpath_head_template	*mpdt;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
+{
+	return mpath_bd_device_to_head(disk_to_dev(disk));
+}
+
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
 void mpath_head_uninit(struct mpath_head *mpath_head);
 
+void mpath_put_disk(struct mpath_head *mpath_head);
+void mpath_remove_disk(struct mpath_head *mpath_head);
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node);
+void mpath_device_set_live(struct mpath_device *mpath_device);
+
+static inline bool is_mpath_disk(struct gendisk *disk)
+{
+	#if IS_ENABLED(CONFIG_LIBMULTIPATH)
+	return disk->fops == &mpath_ops;
+	#else
+	return false;
+	#endif
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 9cc398d266adf..d2e334259f3c1 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -35,6 +35,104 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_head_uninit);
 
+static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	return mpath_get_head(mpath_head);
+}
+
+static void mpath_bdev_release(struct gendisk *disk)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	mpath_put_head(mpath_head);
+}
+
+const struct block_device_operations mpath_ops = {
+	.owner          = THIS_MODULE,
+	.open		= mpath_bdev_open,
+	.release	= mpath_bdev_release,
+};
+EXPORT_SYMBOL_GPL(mpath_ops);
+
+static void multipath_partition_scan_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+		container_of(work, struct mpath_head, partition_scan_work);
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &mpath_head->disk->state)))
+		return;
+
+	mutex_lock(&mpath_head->disk->open_mutex);
+	bdev_disk_changed(mpath_head->disk, false);
+	mutex_unlock(&mpath_head->disk->open_mutex);
+}
+
+void mpath_remove_disk(struct mpath_head *mpath_head)
+{
+	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		struct gendisk *disk = mpath_head->disk;
+
+		del_gendisk(disk);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_remove_disk);
+
+void mpath_put_disk(struct mpath_head *mpath_head)
+{
+	if (!mpath_head->disk)
+		return;
+
+	/* make sure all pending bios are cleaned up */
+	flush_work(&mpath_head->partition_scan_work);
+	put_disk(mpath_head->disk);
+	mpath_head->disk = NULL;
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node)
+{
+	if (!mpath_head->disk_groups || !mpath_head->parent ||
+	    mpath_head->disk)
+		return -EINVAL;
+
+	mpath_head->disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(mpath_head->disk))
+		return PTR_ERR(mpath_head->disk);
+
+	mpath_head->disk->private_data = mpath_head;
+	mpath_head->disk->fops = &mpath_ops;
+
+	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head_disk);
+
+void mpath_device_set_live(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int ret;
+
+	if (!mpath_head->disk)
+		return;
+
+	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		dev_set_drvdata(disk_to_dev(mpath_head->disk), mpath_head);
+		ret = device_add_disk(mpath_head->parent, mpath_head->disk,
+				mpath_head->disk_groups);
+		if (ret) {
+			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
+			return;
+		}
+		queue_work(mpath_wq, &mpath_head->partition_scan_work);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_device_set_live);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
@@ -42,6 +140,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 	mutex_init(&mpath_head->lock);
 	refcount_set(&mpath_head->refcount, 1);
 
+	INIT_WORK(&mpath_head->partition_scan_work,
+		multipath_partition_scan_work);
+
 	return init_srcu_struct(&mpath_head->srcu);
 }
 EXPORT_SYMBOL_GPL(mpath_head_init);
-- 
2.43.7

