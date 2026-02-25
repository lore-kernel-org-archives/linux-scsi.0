Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329FD3EFD20;
	Wed, 25 Feb 2026 15:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034093; cv=fail; b=B5YOhJTKtOTX2pGW1bUdK2t8eZLFZEBrO6Ba0sQ+XV6m9pn2zpBl2+dc73VSymiBJcZE04nHAwYDnxp7Xsw6O+1KoZce1h3CvoSKpHERQtRQAnpYatF1sNl+siSnlnBBdGa+BxCijXWJ67Nl04XiE4xnmCpqb18D3yWyPwGzeY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034093; c=relaxed/simple;
	bh=HC3D/f0UoT6eSpm94EmK/tTh0vQLT+Uq/I4ZG1pFYtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pLjywpHsUlzZFpFJhEs0979ioPsKxgxk45nS3RTyiwejeA9UV2M68dCj6BbdVDm3V1mV4TVCPb39zIPmUym6AkKsEZ1fD0mXKUVimid8qwy1gOEY9dDtpSuM44e7j/0ZsdXENyJsJZgjYVE3h8KP5zaalqQ82+x3xF0BLj0Fe7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZQH2Rjes; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LyIX4aXd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZQH2Rjes";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LyIX4aXd"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PA7oPC553150;
	Wed, 25 Feb 2026 15:41:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vSDhqDcSXZuFj9C7JKYiAPMtBaETJYAU3gwFkDdXyjc=; b=
	ZQH2RjesGBK06GiRAFjUYuSCiMevtNe7nXrojZF4XnnU/FP+8fIUIfG3dt1K+duS
	4CBgmQ63m/Pg+x2npc47U8IDtWVSexS+TYmF9z+YD3rpGc94hJ7I0MKnpucoKRWZ
	1ZJRIeWWVR7EmSzp57VPkyZtDK+YozCxAa0FgEvwHI2wBxESgleFocb+/lCrF/d/
	DjYasRcOvdNBpBqtfg6R4HuTtxBL6ru3b9J8Blyk3iPyaO+71pkCnDotgCFCNW4Z
	uc67nGsw7y4AlI7BZHF/ZXiNkyKU9uhn94oeDnSNlx+LbzFbcs6ditB0iIHflYf7
	eOih+xNs0gatSu1dEy0ZFA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3pgh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:41:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEE0do006327;
	Wed, 25 Feb 2026 15:41:07 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011013.outbound.protection.outlook.com [52.101.62.13])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bgejk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:41:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rdtuiB+DCHRzUVo6xo3VyqfiYIJDK3BW4rZg0MMtc5BlPhFhzXKcXTByyv/Qp//m0dFrvBMPDkOuTnHU08cmC4zR1rTOazQdumCPCpmmt7rTf+voTVpZrLloiPDNKukv+zAx3IIkPCJqUqDGJJq6ZxUs5fT9F2lwOStJlroChfvaRHDsg6grOMcdNk4yHY3Q4zMzgh+Kt3RY1+VVDx+brlBD533ncdf2tOeCbGev66westW7AwYVNlEhgTrzq5H2pk/a7fKT79HzrGDzALhat4IylD96yWp02zXWjCABq5+t6mCDMazfLk002l7uLhG+CbjQ+0BB+byuou1yod+06Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSDhqDcSXZuFj9C7JKYiAPMtBaETJYAU3gwFkDdXyjc=;
 b=Kv1xtynefORUqmkLqLvgUMlO0T8w90S9wF/ZvIqOE/oG3Gi2LpQv3rgfe8FC5MIL297MpLnTCR+9VDubVGCIli4u2e4JU34CW/Z3uF3XzW0XwyLJfgGQ/O1Aote5bgP8XWuHbtan3Oz2kt2I4GCvRvaFgoNCVKU2q+mp8WfCRG0xswJkPXQIY88fforvDU1F2vyVJnXx120+Wog7GtNGxge5aHvaADaXBnYPUZ4PM5/t8YJRP5X5iQR5beG6bAeCj7MPklibb6xHpc6Nuc4fELHilHf8idKSWXXVNFlnBNSRn25mmGab8O3qeJbetaCzIfxHn0j6H88pslCD0L2tKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSDhqDcSXZuFj9C7JKYiAPMtBaETJYAU3gwFkDdXyjc=;
 b=LyIX4aXd9O4oS4B7Pu2ja/3eezobSbxJ83FThwlfxreb7eeyVIrPXmS3ncPBomMiDLJrPs0a6tDyAasBEPGvOMHQOcudIoRx947/bSl8511u7ljPZ2aK5hvtOV9eBTxETOMVDQ1aHQgbnUPbczrWjFFfTL4awGYURly1XuPq88Y=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB8149.namprd10.prod.outlook.com
 (2603:10b6:8:1ff::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:40:57 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 19/19] nvme-multipath: switch to use libmultipath
Date: Wed, 25 Feb 2026 15:40:07 +0000
Message-ID: <20260225154007.1033735-20-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0189.namprd13.prod.outlook.com
 (2603:10b6:208:2be::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b6daf5f-e02f-4758-9be9-08de7484447b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	wohfGMRMwAJ8HImYpFFmoMphUqVyz1ZOiedwGHjyi9GkxUubKmExKu2yQq5aRUgxL81SgZdvsrmE5456x/QpC5lS1/2EpF2rAsalCgiQpcLqMhKpZKNwu+SEhk4VdRwQOAZ7oHqrWc32RvjicXOf+BItq2//45OlCMHHDC9hE5Kloobt6Kmb1hwxS63LCrHCI2Nx3+EMoU0FJak1Gy4JFeIsQm/3pgffqYeTxqWogOyuJjGeAYjpfqPyL0B5oWIQ+ywzzAy898H8kuLdn8HpQs8XdDK0NIy/7noSWpQHSXv96JMitaokprnZdyUlCgbyaLdmE5MAnGMLjjHZjUitjWjSCtFq7H4LPoSFkDpPswqlxQCXBdzB7ISheMPSPxRKnpmzsoP/by1UmRB4BHJzNA+pXM44o6cveIJv5K6xZcV/xCqfrZAxaVIQsJFdIgHP98DlHdF+dLOoH43+Bwaa187erHIWKoGHBgjyTDHHWUSJeFozLI11UxDd1Ewtq+w2pFxxfGVMZXEY3bRm2/+oFgLtXZflpl2hCzudYsdjGzXEtyuJZ6Ba2G3laVP0i/IsmR0J5Jpib0ye/nwIo2hsqa9jBNzVwC/JdGgpV5a0+ZQS5SXPPZblPuv77BLtr8WGdVGkDiPirIc29qlwcCRd6WF1DFvSmv/PCsk7Z0fH9h+UosWS6EOd2jOCFIFhRWl+zBXbNo1h1/nlbE/ONZhP96grinNVh5CiPwfoHFjkRag=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?734t0HZLe88pf8P+IvqXVazDOMSC0lqpXFQEAVIyY35f4OGApZuDoaua2vhI?=
 =?us-ascii?Q?k0Zu1eIij1fLQBit5zZc6Itjsiipkk+lFZnVGNlTwrGBKsGLvymqz3Wyoj/Z?=
 =?us-ascii?Q?5t8AtSQSSscGfY7D3rZ3j/BvJPeJn47xK3aDEsLGhVSxFaHD1/B9ej0PuhMx?=
 =?us-ascii?Q?8vZmEQujAG8nWIYU3BLdNb0uXjBmrf4h6eScIMy7j6JWIJfU6LUtEEXZim8p?=
 =?us-ascii?Q?wRHwoJ/ADqvf9/i0JcpDTcZQFbFK1fPnhVfy0LwBLQH/Zq0gIlFw+cIiq+M3?=
 =?us-ascii?Q?slOu6SyVkrHD6qbyLz5HWW7XE/dHrLrk/b7dMTTIDugw6l5wiZeh5ulwxB3k?=
 =?us-ascii?Q?72r6Tqhya4JTyAV1qMYRhwcIwH4+N3lrtBnfZmFtGGS9pKb22EHw/7tjC3ID?=
 =?us-ascii?Q?4U2Yza9XfLR39x/h49V/QYXJdmC9jMzpvORwKD3WeQK0Iw2aSjo6e+j454nn?=
 =?us-ascii?Q?Zdg8MZLwAXapnMQHHnY38sVrX0k+upoP6Gyqf4zsCt6p0i0E6609zDVVq7s4?=
 =?us-ascii?Q?SCWcomTLz5L/JJDFiMgqgRzAX2Tptpf388/pAatwDyweL3DzYCzfKEsPwmUd?=
 =?us-ascii?Q?w4WS9TklaolGhoPa2cEekWA6yJWbzPs5t+US6rSKsZ4U0MrBjdwUXXYqNy5V?=
 =?us-ascii?Q?j/lHWELDDBHePMAZSvk0+ifgTT8XJJ6xrf2PVE2tDjrsl2yHlDuJEV02oybL?=
 =?us-ascii?Q?bJB9/95nLH3KFgiLTXdyBPUUTwBLFjQ8q6YTGfKbWaSLGWOlH9KUoOrvy8TV?=
 =?us-ascii?Q?n+uAXYhlMiZ7uBScTpHtd6rtI5BvQsPglE1FMDAZ3O4oSUJvD6y4KIXxydgp?=
 =?us-ascii?Q?v0lIibwlqP1IfMWdDY76umPEfqEqSQLRG67JOzlMmV0ty8TjIQx/xt8bd69E?=
 =?us-ascii?Q?1+Zq8L1sQSbrb1OrmoobtgWDDM/Tg2jkWDeiO3MXn+eHmODmQgkWZBNI5Jxw?=
 =?us-ascii?Q?IY6hOXDIKTs2tr876GOb0nbU5NWic63GYQ89U7YdVoFew3dHL9Sh6Jubbisl?=
 =?us-ascii?Q?bL+3k9q/qG02f7prMYAH9LFWqRN1FLKoCcBI+cuFbWPTCioAIyhC+uwJJFrG?=
 =?us-ascii?Q?1mEr468iEkO2WqJfNUad/UzFpgtnVDV9T7dDlESzd4oTvAqisNC5RqGf2Fxo?=
 =?us-ascii?Q?Veeq6aIYDmvBmT9VNsPvX4sqpSbQykbe+wM8CNJh07HAclgIa66hDZ24LYPs?=
 =?us-ascii?Q?NrbkI5hD1BbUOjEymwRXuAGWUeSvwG1Mp2B2zD5FH+6xhxH+LvllFqPdQ321?=
 =?us-ascii?Q?vsnJccgNCn3bp+71hB7r1YCf42ul3d1+JKobrrzARthqVcdv6eMNHhIzmMI0?=
 =?us-ascii?Q?KagMy7bDCYvNtbzsba5wnruAjcugTM1B7+tC1Ji4NAnb87QmWtffymwALAg2?=
 =?us-ascii?Q?BcyLmdxE/W4VDJHubzFD7E0uZd6AtF/PE+kM/6x8S9H6KVGACqf/3w/h2mno?=
 =?us-ascii?Q?xXT4hJsk4kMyvFIRT7+1doSkfcKZAWw2mPvdXbFtihXHEdV8BtO3huzdVwau?=
 =?us-ascii?Q?HFERRzcj4WZNfhOs6a/ta0SC6uvc4VUgGYC1eOz9ton35h6X4DszC008MgEz?=
 =?us-ascii?Q?+YLqoWiPn93wk2khlDMIa0ivsi51EkpYaPY3TWZReU5PwmaqfdSKyQomKt07?=
 =?us-ascii?Q?KCUvVxzzZgsWul81NJAfNKq6NTxvw/aRN8ckHbwxjU6X3MNLPHUxjTRMJkCT?=
 =?us-ascii?Q?62GyEm99HrlFTNN2X26DtdqjUXRhK/4FqWZupEyNABEXXt53TiY7XfRvKW6D?=
 =?us-ascii?Q?lyiYR3qW8MKGuA41t7GZxAfPx2lGu/Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QPrjoEWlhALc5PvGh/Lj5HDbSn1ztv6RnhOOx7iWEYh3W9fj2tsCZB+vcK82pmrgkS5ez1i6ck+ElucNgFm/vXDer5/B6u5DLI/F8ky4PSA7kr7toBF8PbBvLnt/WBq3NpUEibRMf0kPE/JANN4CaIAZk+Q50tM3ULHXhygbA5FJE4mJ2fieRhF9M5n0QavHVHPRiItLkQav2KkaN8tIolapuBgrNXaxRgPqmiyAPkMCrwGDp2vq7sLr5SWpfR245lBPIR3dG+fWPRWsYKob2lbfN5R72JKEijmJZDzr/0B8mbu6e+p6mOHLPnyfzK/MQXWaQ09xQIy4M3AFNTLayCVm98hXRp7aDGxOHj//OWT1k9UI39qzVpBEFV9AACTcFFGf/yDR8Ipj6FNdSVtRU+xn910zzK7zy2WGeHrl8onTlfVK70lZXjiI+CBA7txLpeir4Hlo+TTTe+84LHAryKqYOXDu6SxNi8muQZbpnD8jeTG03/4kbsWFWRFEXgB7zcCVPc23++pp5Bl7EpyoTnE5OTy11zdll6N7hTQnwh6LIKIlxKFz2Vz0GOLpJiRwHbDmhX+Kx4/HV6+tajWVWoAq+vI45thKhz52nFL8Swg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6daf5f-e02f-4758-9be9-08de7484447b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:56.9343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RmxQXfOEr7Bt10RySWXy+Qf3YDZxehSsEfj9S5G2MhXHVV/UkpnjgHVXujZfq/5cqN3/6jrDrRff0iij3eopTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699f1814 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=kFJKMHVsF_9EA3gfUxIA:9
 a=q-gNWNAGp3vJJuIC:21
X-Proofpoint-ORIG-GUID: zT0tvcMm7ImaFc1b0YKLOZGdMnGfxLnT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX7g/2yPyt51Ow
 bxIcy9JF0jlHUGiNTaM7+qs6GxXPx/61E20y72U3TSQ4oyTIpFJezVj7oisSN6/7k341qs3gESM
 VUFp/bnH36xtHT9RSct1fOfMgbqjemQEL2HQBsLvZPJujD00aFSbJxx5AOyCIuuZssP+1U64ox9
 7NGvkQRge5zJaeIVN9nvXbLKapeukSplt+MqEFxWXHYCD//EIanRebCVmUy+Bg5wdhqE3KqMchM
 iTfbsppCJxTQ0E3DxAMyUHIn3jDxRm0Piz2ecsdjBnBZxqZuxng/OnOJ1yoXm4xNk9EVkGYE0+t
 q5XGC1mMykbE6DtHPyoOrGdMqW3N3NUwIUidMbtS1XFVmc1QNr5Tq+9EyHoNMRYFdAAI0ImxdDY
 QSSxKw3kCJ+PigoLZcjyWaaAhVb0rQmSIbXganzF9IbDEaRO/c7zhmek4qlirAdx708DQZYjasX
 S7GLWxrDYX2c4x/hLcg==
X-Proofpoint-GUID: zT0tvcMm7ImaFc1b0YKLOZGdMnGfxLnT

Now that as much unused libmulipath-based code has been added, do the
full switch over.

The major change is that the multipath management is moved out of the
nvme_ns_head structure and into mpath_head and mpath_disk structures.

The check for ns->head->disk is now replaced with a ns->mpath_disk check,
it decide whether we are really in multipath mode. Similarly everywhere
we were referencing ns->head->disk, we reference ns->mpath_disk->disk.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c      |  65 ++-
 drivers/nvme/host/ioctl.c     |  89 ----
 drivers/nvme/host/multipath.c | 865 +++++++---------------------------
 drivers/nvme/host/nvme.h      |  72 +--
 drivers/nvme/host/pr.c        | 355 +++-----------
 drivers/nvme/host/sysfs.c     |  84 ++--
 6 files changed, 318 insertions(+), 1212 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2d0faec902eb2..be757879f19b2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -667,9 +667,7 @@ static void nvme_free_ns_head(struct kref *ref)
 	struct nvme_ns_head *head =
 		container_of(ref, struct nvme_ns_head, ref);
 
-	nvme_mpath_put_disk(head);
 	ida_free(&head->subsys->ns_ida, head->instance);
-	cleanup_srcu_struct(&head->srcu);
 	nvme_put_subsystem(head->subsys);
 	kfree(head->plids);
 	kfree(head);
@@ -2488,9 +2486,12 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 		struct queue_limits *ns_lim = &ns->disk->queue->limits;
 		struct queue_limits lim;
 		unsigned int memflags;
+		struct nvme_ns_head *head = ns->head;
+		struct mpath_disk *mpath_disk = head->mpath_disk;
+		struct gendisk *disk = mpath_disk->disk;
 
-		lim = queue_limits_start_update(ns->head->disk->queue);
-		memflags = blk_mq_freeze_queue(ns->head->disk->queue);
+		lim = queue_limits_start_update(disk->queue);
+		memflags = blk_mq_freeze_queue(disk->queue);
 		/*
 		 * queue_limits mixes values that are the hardware limitations
 		 * for bio splitting with what is the device configuration.
@@ -2511,20 +2512,20 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 		lim.io_min = ns_lim->io_min;
 		lim.io_opt = ns_lim->io_opt;
 		queue_limits_stack_bdev(&lim, ns->disk->part0, 0,
-					ns->head->disk->disk_name);
+					disk->disk_name);
 		if (unsupported)
-			ns->head->disk->flags |= GENHD_FL_HIDDEN;
+			disk->flags |= GENHD_FL_HIDDEN;
 		else
 			nvme_init_integrity(ns->head, &lim, info);
 		lim.max_write_streams = ns_lim->max_write_streams;
 		lim.write_stream_granularity = ns_lim->write_stream_granularity;
-		ret = queue_limits_commit_update(ns->head->disk->queue, &lim);
+		ret = queue_limits_commit_update(disk->queue, &lim);
 
-		set_capacity_and_notify(ns->head->disk, get_capacity(ns->disk));
-		set_disk_ro(ns->head->disk, nvme_ns_is_readonly(ns, info));
-		nvme_mpath_revalidate_paths(ns->head);
+		set_capacity_and_notify(disk, get_capacity(ns->disk));
+		set_disk_ro(disk, nvme_ns_is_readonly(ns, info));
+		nvme_mpath_revalidate_paths(head);
 
-		blk_mq_unfreeze_queue(ns->head->disk->queue, memflags);
+		blk_mq_unfreeze_queue(disk->queue, memflags);
 	}
 
 	return ret;
@@ -3884,10 +3885,6 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	size_t size = sizeof(*head);
 	int ret = -ENOMEM;
 
-#ifdef CONFIG_NVME_MULTIPATH
-	size += num_possible_nodes() * sizeof(struct nvme_ns *);
-#endif
-
 	head = kzalloc(size, GFP_KERNEL);
 	if (!head)
 		goto out;
@@ -3895,10 +3892,7 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	if (ret < 0)
 		goto out_free_head;
 	head->instance = ret;
-	INIT_LIST_HEAD(&head->list);
-	ret = init_srcu_struct(&head->srcu);
-	if (ret)
-		goto out_ida_remove;
+
 	head->subsys = ctrl->subsys;
 	head->ns_id = info->nsid;
 	head->ids = info->ids;
@@ -3911,22 +3905,20 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	if (head->ids.csi) {
 		ret = nvme_get_effects_log(ctrl, head->ids.csi, &head->effects);
 		if (ret)
-			goto out_cleanup_srcu;
+			goto out_ida_free;
 	} else
 		head->effects = ctrl->effects;
 
 	ret = nvme_mpath_alloc_disk(ctrl, head);
 	if (ret)
-		goto out_cleanup_srcu;
+		goto out_ida_free;
 
 	list_add_tail(&head->entry, &ctrl->subsys->nsheads);
 
 	kref_get(&ctrl->subsys->ref);
 
 	return head;
-out_cleanup_srcu:
-	cleanup_srcu_struct(&head->srcu);
-out_ida_remove:
+out_ida_free:
 	ida_free(&ctrl->subsys->ns_ida, head->instance);
 out_free_head:
 	kfree(head);
@@ -3965,7 +3957,7 @@ static int nvme_global_check_duplicate_ids(struct nvme_subsystem *this,
 static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 {
 	struct nvme_ctrl *ctrl = ns->ctrl;
-	struct nvme_ns_head *head = NULL;
+	struct nvme_ns_head *head;
 	int ret;
 
 	ret = nvme_global_check_duplicate_ids(ctrl->subsys, &info->ids);
@@ -4046,14 +4038,11 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 		}
 	}
 
-	list_add_tail_rcu(&ns->siblings, &head->list);
 	head->ns_count++;
 	ns->head = head;
+	nvme_mpath_add_ns(ns);
 	mutex_unlock(&ctrl->subsys->lock);
 
-#ifdef CONFIG_NVME_MULTIPATH
-	cancel_delayed_work(&head->remove_work);
-#endif
 	return 0;
 
 out_put_ns_head:
@@ -4192,24 +4181,24 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
 	synchronize_srcu(&ctrl->srcu);
  out_unlink_ns:
 	mutex_lock(&ctrl->subsys->lock);
-	list_del_rcu(&ns->siblings);
+	nvme_mpath_delete_ns(ns);
 	ns->head->ns_count--;
 	if (!ns->head->ns_count) {
 		list_del_init(&ns->head->entry);
 		/*
 		 * If multipath is not configured, we still create a namespace
-		 * head (nshead), but head->disk is not initialized in that
+		 * head (nshead), but mpath_head->disk is not initialized in that
 		 * case.  As a result, only a single reference to nshead is held
 		 * (via kref_init()) when it is created. Therefore, ensure that
 		 * we do not release the reference to nshead twice if head->disk
 		 * is not present.
 		 */
-		if (ns->head->disk)
+		if (nvme_mpath_has_disk(ns->head))
 			last_path = true;
 	}
 	mutex_unlock(&ctrl->subsys->lock);
 	if (last_path)
-		nvme_put_ns_head(ns->head);
+		nvme_mpath_remove_disk(ns->head);
 	nvme_put_ns_head(ns->head);
  out_cleanup_disk:
 	put_disk(disk);
@@ -4233,24 +4222,24 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 	 * Ensure that !NVME_NS_READY is seen by other threads to prevent
 	 * this ns going back into current_path.
 	 */
-	synchronize_srcu(&ns->head->srcu);
+	nvme_mpath_synchronize(head);
 
 	/* wait for concurrent submissions */
 	if (nvme_mpath_clear_current_path(ns))
-		synchronize_srcu(&ns->head->srcu);
+		nvme_mpath_synchronize(head);
 
 	mutex_lock(&ns->ctrl->subsys->lock);
-	list_del_rcu(&ns->siblings);
+	nvme_mpath_delete_ns(ns);
 	head->ns_count--;
 	if (!head->ns_count) {
-		if (!nvme_mpath_queue_if_no_path(ns->head))
+		if (!nvme_mpath_head_queue_if_no_path(head))
 			list_del_init(&ns->head->entry);
 		last_path = true;
 	}
 	mutex_unlock(&ns->ctrl->subsys->lock);
 
 	/* guarantee not available in head->list */
-	synchronize_srcu(&ns->head->srcu);
+	nvme_mpath_synchronize(head);
 
 	if (!nvme_ns_head_multipath(ns->head))
 		nvme_cdev_del(&ns->cdev, &ns->cdev_device);
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 773c819cde52a..a243662b461e9 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -710,22 +710,6 @@ int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
 	return nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
 }
 
-static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
-		void __user *argp, struct nvme_ns_head *head, int srcu_idx,
-		bool open_for_write)
-	__releases(&head->srcu)
-{
-	struct nvme_ctrl *ctrl = ns->ctrl;
-	int ret;
-
-	nvme_get_ctrl(ns->ctrl);
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	ret = nvme_ctrl_ioctl(ns->ctrl, cmd, argp, open_for_write);
-
-	nvme_put_ctrl(ctrl);
-	return ret;
-}
-
 int nvme_mpath_bdev_ioctl(struct block_device *bdev,
 			struct mpath_device *mpath_device, blk_mode_t mode,
 			unsigned int cmd, unsigned long arg, int srcu_idx)
@@ -783,79 +767,6 @@ int nvme_mpath_cdev_ioctl(struct mpath_head *mpath_head,
 	return ret;
 }
 
-int nvme_ns_head_ioctl(struct block_device *bdev, blk_mode_t mode,
-		unsigned int cmd, unsigned long arg)
-{
-	struct nvme_ns_head *head = bdev->bd_disk->private_data;
-	bool open_for_write = mode & BLK_OPEN_WRITE;
-	void __user *argp = (void __user *)arg;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-	unsigned int flags = 0;
-
-	if (bdev_is_partition(bdev))
-		flags |= NVME_IOCTL_PARTITION;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (!ns)
-		goto out_unlock;
-
-	/*
-	 * Handle ioctls that apply to the controller instead of the namespace
-	 * separately and drop the ns SRCU reference early.  This avoids a
-	 * deadlock when deleting namespaces using the passthrough interface.
-	 */
-	if (is_ctrl_ioctl(cmd))
-		return nvme_ns_head_ctrl_ioctl(ns, cmd, argp, head, srcu_idx,
-					       open_for_write);
-
-	ret = nvme_ns_ioctl(ns, cmd, argp, flags, open_for_write);
-out_unlock:
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
-long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
-		unsigned long arg)
-{
-	bool open_for_write = file->f_mode & FMODE_WRITE;
-	struct cdev *cdev = file_inode(file)->i_cdev;
-	struct nvme_ns_head *head =
-		container_of(cdev, struct nvme_ns_head, cdev);
-	void __user *argp = (void __user *)arg;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (!ns)
-		goto out_unlock;
-
-	if (is_ctrl_ioctl(cmd))
-		return nvme_ns_head_ctrl_ioctl(ns, cmd, argp, head, srcu_idx,
-				open_for_write);
-
-	ret = nvme_ns_ioctl(ns, cmd, argp, 0, open_for_write);
-out_unlock:
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
-int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
-		unsigned int issue_flags)
-{
-	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
-	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
-	int srcu_idx = srcu_read_lock(&head->srcu);
-	struct nvme_ns *ns = nvme_find_path(head);
-	int ret = -EINVAL;
-
-	if (ns)
-		ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 081a8a20a9908..c686cabfd9d16 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -67,33 +67,17 @@ module_param_cb(multipath_always_on, &multipath_always_on_ops,
 MODULE_PARM_DESC(multipath_always_on,
 	"create multipath node always except for private namespace with non-unique nsid; note that this also implicitly enables native multipath support");
 
-static const char *nvme_iopolicy_names[] = {
-	[NVME_IOPOLICY_NUMA]	= "numa",
-	[NVME_IOPOLICY_RR]	= "round-robin",
-	[NVME_IOPOLICY_QD]      = "queue-depth",
-};
 
-static int iopolicy = NVME_IOPOLICY_NUMA;
+static int iopolicy = MPATH_IOPOLICY_NUMA;
 
 static int nvme_set_iopolicy(const char *val, const struct kernel_param *kp)
 {
-	if (!val)
-		return -EINVAL;
-	if (!strncmp(val, "numa", 4))
-		iopolicy = NVME_IOPOLICY_NUMA;
-	else if (!strncmp(val, "round-robin", 11))
-		iopolicy = NVME_IOPOLICY_RR;
-	else if (!strncmp(val, "queue-depth", 11))
-		iopolicy = NVME_IOPOLICY_QD;
-	else
-		return -EINVAL;
-
-	return 0;
+	return mpath_set_iopolicy(val, &iopolicy);
 }
 
 static int nvme_get_iopolicy(char *buf, const struct kernel_param *kp)
 {
-	return sprintf(buf, "%s\n", nvme_iopolicy_names[iopolicy]);
+	return mpath_get_iopolicy(buf, iopolicy);
 }
 
 module_param_call(iopolicy, nvme_set_iopolicy, nvme_get_iopolicy,
@@ -103,7 +87,7 @@ MODULE_PARM_DESC(iopolicy,
 
 void nvme_mpath_default_iopolicy(struct nvme_subsystem *subsys)
 {
-	subsys->iopolicy = iopolicy;
+	subsys->iopolicy.iopolicy = iopolicy;
 }
 
 void nvme_mpath_unfreeze(struct nvme_subsystem *subsys)
@@ -111,9 +95,13 @@ void nvme_mpath_unfreeze(struct nvme_subsystem *subsys)
 	struct nvme_ns_head *h;
 
 	lockdep_assert_held(&subsys->lock);
-	list_for_each_entry(h, &subsys->nsheads, entry)
-		if (h->disk)
-			blk_mq_unfreeze_queue_nomemrestore(h->disk->queue);
+	list_for_each_entry(h, &subsys->nsheads, entry) {
+		struct mpath_disk *mpath_disk = h->mpath_disk;
+
+		if (mpath_disk)
+			blk_mq_unfreeze_queue_nomemrestore(
+				mpath_disk->disk->queue);
+	}
 }
 
 void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
@@ -121,9 +109,12 @@ void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
 	struct nvme_ns_head *h;
 
 	lockdep_assert_held(&subsys->lock);
-	list_for_each_entry(h, &subsys->nsheads, entry)
-		if (h->disk)
-			blk_mq_freeze_queue_wait(h->disk->queue);
+	list_for_each_entry(h, &subsys->nsheads, entry) {
+		struct mpath_disk *mpath_disk = h->mpath_disk;
+
+		if (mpath_disk)
+			blk_mq_freeze_queue_wait(mpath_disk->disk->queue);
+	}
 }
 
 void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
@@ -131,15 +122,22 @@ void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
 	struct nvme_ns_head *h;
 
 	lockdep_assert_held(&subsys->lock);
-	list_for_each_entry(h, &subsys->nsheads, entry)
-		if (h->disk)
-			blk_freeze_queue_start(h->disk->queue);
+	list_for_each_entry(h, &subsys->nsheads, entry) {
+		struct mpath_disk *mpath_disk = h->mpath_disk;
+
+		if (mpath_disk)
+			blk_freeze_queue_start(mpath_disk->disk->queue);
+	}
 }
 
 void nvme_failover_req(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
+	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
 	u16 status = nvme_req(req)->status & NVME_SCT_SC_MASK;
+	struct gendisk *disk = mpath_disk->disk;
 	unsigned long flags;
 	struct bio *bio;
 
@@ -155,9 +153,9 @@ void nvme_failover_req(struct request *req)
 		queue_work(nvme_wq, &ns->ctrl->ana_work);
 	}
 
-	spin_lock_irqsave(&ns->head->requeue_lock, flags);
+	spin_lock_irqsave(&mpath_head->requeue_lock, flags);
 	for (bio = req->bio; bio; bio = bio->bi_next) {
-		bio_set_dev(bio, ns->head->disk->part0);
+		bio_set_dev(bio, disk->part0);
 		if (bio->bi_opf & REQ_POLLED) {
 			bio->bi_opf &= ~REQ_POLLED;
 			bio->bi_cookie = BLK_QC_T_NONE;
@@ -171,20 +169,23 @@ void nvme_failover_req(struct request *req)
 		 */
 		bio->bi_opf &= ~REQ_NOWAIT;
 	}
-	blk_steal_bios(&ns->head->requeue_list, req);
-	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
+	blk_steal_bios(&mpath_head->requeue_list, req);
+	spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
 
 	nvme_req(req)->status = 0;
 	nvme_end_req(req);
-	kblockd_schedule_work(&ns->head->requeue_work);
+	kblockd_schedule_work(&mpath_head->requeue_work);
 }
 
 void nvme_mpath_start_request(struct request *rq)
 {
 	struct nvme_ns *ns = rq->q->queuedata;
-	struct gendisk *disk = ns->head->disk;
+	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+	struct gendisk *disk = mpath_disk->disk;
+	struct nvme_subsystem *subsys = head->subsys;
 
-	if ((READ_ONCE(ns->head->subsys->iopolicy) == NVME_IOPOLICY_QD) &&
+	if (mpath_qd_iopolicy(&subsys->iopolicy) &&
 	    !(nvme_req(rq)->flags & NVME_MPATH_CNT_ACTIVE)) {
 		atomic_inc(&ns->ctrl->nr_active);
 		nvme_req(rq)->flags |= NVME_MPATH_CNT_ACTIVE;
@@ -203,13 +204,15 @@ EXPORT_SYMBOL_GPL(nvme_mpath_start_request);
 void nvme_mpath_end_request(struct request *rq)
 {
 	struct nvme_ns *ns = rq->q->queuedata;
+	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
 
 	if (nvme_req(rq)->flags & NVME_MPATH_CNT_ACTIVE)
 		atomic_dec_if_positive(&ns->ctrl->nr_active);
 
 	if (!(nvme_req(rq)->flags & NVME_MPATH_IO_STATS))
 		return;
-	bdev_end_io_acct(ns->head->disk->part0, req_op(rq),
+	bdev_end_io_acct(mpath_disk->disk->part0, req_op(rq),
 			 blk_rq_bytes(rq) >> SECTOR_SHIFT,
 			 nvme_req(rq)->start_time);
 }
@@ -232,11 +235,17 @@ void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
 	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
 				 srcu_read_lock_held(&ctrl->srcu)) {
-		if (!ns->head->disk)
+		struct mpath_disk *mpath_disk = ns->head->mpath_disk;
+		struct mpath_head *mpath_head;
+		struct gendisk *disk;
+
+		if (!mpath_disk)
 			continue;
-		kblockd_schedule_work(&ns->head->requeue_work);
+		mpath_head = mpath_disk->mpath_head;
+		disk = mpath_disk->disk;
+		kblockd_schedule_work(&mpath_head->requeue_work);
 		if (nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE)
-			disk_uevent(ns->head->disk, KOBJ_CHANGE);
+			disk_uevent(disk, KOBJ_CHANGE);
 	}
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
@@ -253,20 +262,13 @@ static const char *nvme_ana_state_names[] = {
 bool nvme_mpath_clear_current_path(struct nvme_ns *ns)
 {
 	struct nvme_ns_head *head = ns->head;
-	bool changed = false;
-	int node;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
 
-	if (!head)
-		goto out;
+	if (!mpath_disk)
+		return false;
 
-	for_each_node(node) {
-		if (ns == rcu_access_pointer(head->current_path[node])) {
-			rcu_assign_pointer(head->current_path[node], NULL);
-			changed = true;
-		}
-	}
-out:
-	return changed;
+	return mpath_clear_current_path(mpath_disk->mpath_head,
+				&ns->mpath_device);
 }
 
 void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
@@ -277,30 +279,35 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
 	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
 				 srcu_read_lock_held(&ctrl->srcu)) {
+		struct nvme_ns_head *head = ns->head;
+		struct mpath_disk *mpath_disk = head->mpath_disk;
+
+		if (!mpath_disk)
+			continue;
+
 		nvme_mpath_clear_current_path(ns);
-		kblockd_schedule_work(&ns->head->requeue_work);
+		kblockd_schedule_work(&mpath_disk->mpath_head->requeue_work);
 	}
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
 
+static void nvme_mpath_revalidate_paths_cb(struct mpath_device *mpath_device,
+					sector_t capacity)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	if (capacity != get_capacity(ns->disk))
+		clear_bit(NVME_NS_READY, &ns->flags);
+}
+
 void nvme_mpath_revalidate_paths(struct nvme_ns_head *head)
 {
-	sector_t capacity = get_capacity(head->disk);
-	struct nvme_ns *ns;
-	int node;
-	int srcu_idx;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
 
-	srcu_idx = srcu_read_lock(&head->srcu);
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		if (capacity != get_capacity(ns->disk))
-			clear_bit(NVME_NS_READY, &ns->flags);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
+	if (!mpath_disk)
+		return;
 
-	for_each_node(node)
-		rcu_assign_pointer(head->current_path[node], NULL);
-	kblockd_schedule_work(&head->requeue_work);
+	mpath_revalidate_paths(mpath_disk, nvme_mpath_revalidate_paths_cb);
 }
 
 static bool nvme_path_is_disabled(struct nvme_ns *ns)
@@ -327,142 +334,6 @@ static bool nvme_mpath_is_disabled(struct mpath_device *mpath_device)
 	return nvme_path_is_disabled(ns);
 }
 
-static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
-{
-	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
-	struct nvme_ns *found = NULL, *fallback = NULL, *ns;
-
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		if (nvme_path_is_disabled(ns))
-			continue;
-
-		if (ns->ctrl->numa_node != NUMA_NO_NODE &&
-		    READ_ONCE(head->subsys->iopolicy) == NVME_IOPOLICY_NUMA)
-			distance = node_distance(node, ns->ctrl->numa_node);
-		else
-			distance = LOCAL_DISTANCE;
-
-		switch (ns->ana_state) {
-		case NVME_ANA_OPTIMIZED:
-			if (distance < found_distance) {
-				found_distance = distance;
-				found = ns;
-			}
-			break;
-		case NVME_ANA_NONOPTIMIZED:
-			if (distance < fallback_distance) {
-				fallback_distance = distance;
-				fallback = ns;
-			}
-			break;
-		default:
-			break;
-		}
-	}
-
-	if (!found)
-		found = fallback;
-	if (found)
-		rcu_assign_pointer(head->current_path[node], found);
-	return found;
-}
-
-static struct nvme_ns *nvme_next_ns(struct nvme_ns_head *head,
-		struct nvme_ns *ns)
-{
-	ns = list_next_or_null_rcu(&head->list, &ns->siblings, struct nvme_ns,
-			siblings);
-	if (ns)
-		return ns;
-	return list_first_or_null_rcu(&head->list, struct nvme_ns, siblings);
-}
-
-static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
-{
-	struct nvme_ns *ns, *found = NULL;
-	int node = numa_node_id();
-	struct nvme_ns *old = srcu_dereference(head->current_path[node],
-					       &head->srcu);
-
-	if (unlikely(!old))
-		return __nvme_find_path(head, node);
-
-	if (list_is_singular(&head->list)) {
-		if (nvme_path_is_disabled(old))
-			return NULL;
-		return old;
-	}
-
-	for (ns = nvme_next_ns(head, old);
-	     ns && ns != old;
-	     ns = nvme_next_ns(head, ns)) {
-		if (nvme_path_is_disabled(ns))
-			continue;
-
-		if (ns->ana_state == NVME_ANA_OPTIMIZED) {
-			found = ns;
-			goto out;
-		}
-		if (ns->ana_state == NVME_ANA_NONOPTIMIZED)
-			found = ns;
-	}
-
-	/*
-	 * The loop above skips the current path for round-robin semantics.
-	 * Fall back to the current path if either:
-	 *  - no other optimized path found and current is optimized,
-	 *  - no other usable path found and current is usable.
-	 */
-	if (!nvme_path_is_disabled(old) &&
-	    (old->ana_state == NVME_ANA_OPTIMIZED ||
-	     (!found && old->ana_state == NVME_ANA_NONOPTIMIZED)))
-		return old;
-
-	if (!found)
-		return NULL;
-out:
-	rcu_assign_pointer(head->current_path[node], found);
-	return found;
-}
-
-static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
-{
-	struct nvme_ns *best_opt = NULL, *best_nonopt = NULL, *ns;
-	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
-	unsigned int depth;
-
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		if (nvme_path_is_disabled(ns))
-			continue;
-
-		depth = atomic_read(&ns->ctrl->nr_active);
-
-		switch (ns->ana_state) {
-		case NVME_ANA_OPTIMIZED:
-			if (depth < min_depth_opt) {
-				min_depth_opt = depth;
-				best_opt = ns;
-			}
-			break;
-		case NVME_ANA_NONOPTIMIZED:
-			if (depth < min_depth_nonopt) {
-				min_depth_nonopt = depth;
-				best_nonopt = ns;
-			}
-			break;
-		default:
-			break;
-		}
-
-		if (min_depth_opt == 0)
-			return best_opt;
-	}
-
-	return best_opt ? best_opt : best_nonopt;
-}
-
 static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
 {
 	return nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE &&
@@ -476,64 +347,6 @@ static bool nvme_mpath_is_optimized(struct mpath_device *mpath_device)
 	return nvme_path_is_optimized(ns);
 }
 
-static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
-{
-	int node = numa_node_id();
-	struct nvme_ns *ns;
-
-	ns = srcu_dereference(head->current_path[node], &head->srcu);
-	if (unlikely(!ns))
-		return __nvme_find_path(head, node);
-	if (unlikely(!nvme_path_is_optimized(ns)))
-		return __nvme_find_path(head, node);
-	return ns;
-}
-
-inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
-{
-	switch (READ_ONCE(head->subsys->iopolicy)) {
-	case NVME_IOPOLICY_QD:
-		return nvme_queue_depth_path(head);
-	case NVME_IOPOLICY_RR:
-		return nvme_round_robin_path(head);
-	default:
-		return nvme_numa_path(head);
-	}
-}
-
-static bool nvme_available_path(struct nvme_ns_head *head)
-{
-	struct nvme_ns *ns;
-
-	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags))
-		return false;
-
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		if (test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ns->ctrl->flags))
-			continue;
-		switch (nvme_ctrl_state(ns->ctrl)) {
-		case NVME_CTRL_LIVE:
-		case NVME_CTRL_RESETTING:
-		case NVME_CTRL_CONNECTING:
-			return true;
-		default:
-			break;
-		}
-	}
-
-	/*
-	 * If "head->delayed_removal_secs" is configured (i.e., non-zero), do
-	 * not immediately fail I/O. Instead, requeue the I/O for the configured
-	 * duration, anticipating that if there's a transient link failure then
-	 * it may recover within this time window. This parameter is exported to
-	 * userspace via sysfs, and its default value is zero. It is internally
-	 * mapped to NVME_NSHEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
-	 * non-zero, this flag is set to true. When zero, the flag is cleared.
-	 */
-	return nvme_mpath_queue_if_no_path(head);
-}
-
 static bool nvme_mpath_available_path(struct mpath_device *mpath_device,
 					bool *available)
 {
@@ -554,94 +367,12 @@ static bool nvme_mpath_available_path(struct mpath_device *mpath_device,
 	return true;
 }
 
-static void nvme_ns_head_submit_bio(struct bio *bio)
-{
-	struct nvme_ns_head *head = bio->bi_bdev->bd_disk->private_data;
-	struct device *dev = disk_to_dev(head->disk);
-	struct nvme_ns *ns;
-	int srcu_idx;
-
-	/*
-	 * The namespace might be going away and the bio might be moved to a
-	 * different queue via blk_steal_bios(), so we need to use the bio_split
-	 * pool from the original queue to allocate the bvecs from.
-	 */
-	bio = bio_split_to_limits(bio);
-	if (!bio)
-		return;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (likely(ns)) {
-		bio_set_dev(bio, ns->disk->part0);
-		bio->bi_opf |= REQ_NVME_MPATH;
-		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
-				      bio->bi_iter.bi_sector);
-		submit_bio_noacct(bio);
-	} else if (nvme_available_path(head)) {
-		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
-
-		spin_lock_irq(&head->requeue_lock);
-		bio_list_add(&head->requeue_list, bio);
-		spin_unlock_irq(&head->requeue_lock);
-	} else {
-		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
-
-		bio_io_error(bio);
-	}
-
-	srcu_read_unlock(&head->srcu, srcu_idx);
-}
-
-static int nvme_ns_head_open(struct gendisk *disk, blk_mode_t mode)
-{
-	if (!nvme_tryget_ns_head(disk->private_data))
-		return -ENXIO;
-	return 0;
-}
-
-static void nvme_ns_head_release(struct gendisk *disk)
-{
-	nvme_put_ns_head(disk->private_data);
-}
-
-static int nvme_ns_head_get_unique_id(struct gendisk *disk, u8 id[16],
-		enum blk_unique_id type)
-{
-	struct nvme_ns_head *head = disk->private_data;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (ns)
-		ret = nvme_ns_get_unique_id(ns, id, type);
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
 static int nvme_mpath_get_unique_id(struct mpath_device *mpath_device,
 		u8 id[16], enum blk_unique_id type)
 {
 	return nvme_ns_get_unique_id(nvme_mpath_to_ns(mpath_device), id, type);
 }
-
 #ifdef CONFIG_BLK_DEV_ZONED
-static int nvme_ns_head_report_zones(struct gendisk *disk, sector_t sector,
-		unsigned int nr_zones, struct blk_report_zones_args *args)
-{
-	struct nvme_ns_head *head = disk->private_data;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (ns)
-		ret = nvme_ns_report_zones(ns, sector, nr_zones, args);
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
 static int nvme_mpath_report_zones(struct mpath_device *mpath_device,
 		sector_t sector, unsigned int nr_zones,
 		struct blk_report_zones_args *args)
@@ -650,51 +381,9 @@ static int nvme_mpath_report_zones(struct mpath_device *mpath_device,
 				nr_zones, args);
 }
 #else
-#define nvme_ns_head_report_zones	NULL
 #define nvme_mpath_report_zones		NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 
-const struct block_device_operations nvme_ns_head_ops = {
-	.owner		= THIS_MODULE,
-	.submit_bio	= nvme_ns_head_submit_bio,
-	.open		= nvme_ns_head_open,
-	.release	= nvme_ns_head_release,
-	.ioctl		= nvme_ns_head_ioctl,
-	.compat_ioctl	= blkdev_compat_ptr_ioctl,
-	.getgeo		= nvme_getgeo,
-	.get_unique_id	= nvme_ns_head_get_unique_id,
-	.report_zones	= nvme_ns_head_report_zones,
-	.pr_ops		= &nvme_pr_ops,
-};
-
-static inline struct nvme_ns_head *cdev_to_ns_head(struct cdev *cdev)
-{
-	return container_of(cdev, struct nvme_ns_head, cdev);
-}
-
-static int nvme_ns_head_chr_open(struct inode *inode, struct file *file)
-{
-	if (!nvme_tryget_ns_head(cdev_to_ns_head(inode->i_cdev)))
-		return -ENXIO;
-	return 0;
-}
-
-static int nvme_ns_head_chr_release(struct inode *inode, struct file *file)
-{
-	nvme_put_ns_head(cdev_to_ns_head(inode->i_cdev));
-	return 0;
-}
-
-static const struct file_operations nvme_ns_head_chr_fops = {
-	.owner		= THIS_MODULE,
-	.open		= nvme_ns_head_chr_open,
-	.release	= nvme_ns_head_chr_release,
-	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
-	.compat_ioctl	= compat_ptr_ioctl,
-	.uring_cmd	= nvme_ns_head_chr_uring_cmd,
-	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
-};
-
 static int nvme_mpath_add_cdev(struct mpath_head *mpath_head)
 {
 	struct nvme_ns_head *head = mpath_head->drvdata;
@@ -715,72 +404,17 @@ static void nvme_mpath_del_cdev(struct mpath_head *mpath_head)
 	nvme_cdev_del(&mpath_head->cdev, &mpath_head->cdev_device);
 }
 
-static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
-{
-	int ret;
-
-	head->cdev_device.parent = &head->subsys->dev;
-	ret = dev_set_name(&head->cdev_device, "ng%dn%d",
-			   head->subsys->instance, head->instance);
-	if (ret)
-		return ret;
-	ret = nvme_cdev_add(&head->cdev, &head->cdev_device,
-			    &nvme_ns_head_chr_fops, THIS_MODULE);
-	return ret;
-}
-
-static void nvme_partition_scan_work(struct work_struct *work)
-{
-	struct nvme_ns_head *head =
-		container_of(work, struct nvme_ns_head, partition_scan_work);
-
-	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
-					     &head->disk->state)))
-		return;
-
-	mutex_lock(&head->disk->open_mutex);
-	bdev_disk_changed(head->disk, false);
-	mutex_unlock(&head->disk->open_mutex);
-}
-
-static void nvme_requeue_work(struct work_struct *work)
+bool nvme_mpath_has_disk(struct nvme_ns_head *head)
 {
-	struct nvme_ns_head *head =
-		container_of(work, struct nvme_ns_head, requeue_work);
-	struct bio *bio, *next;
-
-	spin_lock_irq(&head->requeue_lock);
-	next = bio_list_get(&head->requeue_list);
-	spin_unlock_irq(&head->requeue_lock);
-
-	while ((bio = next) != NULL) {
-		next = bio->bi_next;
-		bio->bi_next = NULL;
-
-		submit_bio_noacct(bio);
-	}
-}
-
-static void nvme_remove_head(struct nvme_ns_head *head)
-{
-	if (test_and_clear_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
-		/*
-		 * requeue I/O after NVME_NSHEAD_DISK_LIVE has been cleared
-		 * to allow multipath to fail all I/O.
-		 */
-		kblockd_schedule_work(&head->requeue_work);
-
-		nvme_cdev_del(&head->cdev, &head->cdev_device);
-		synchronize_srcu(&head->srcu);
-		del_gendisk(head->disk);
-	}
-	nvme_put_ns_head(head);
+	return head->mpath_disk;
 }
 
 static void nvme_remove_head_work(struct work_struct *work)
 {
-	struct nvme_ns_head *head = container_of(to_delayed_work(work),
-			struct nvme_ns_head, remove_work);
+	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
+			struct mpath_head, remove_work);
+	struct nvme_ns_head *head = mpath_head->drvdata;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
 	bool remove = false;
 
 	mutex_lock(&head->subsys->lock);
@@ -789,24 +423,21 @@ static void nvme_remove_head_work(struct work_struct *work)
 		remove = true;
 	}
 	mutex_unlock(&head->subsys->lock);
-	if (remove)
-		nvme_remove_head(head);
 
+	if (remove) {
+		mpath_unregister_disk(mpath_disk);
+		nvme_put_ns_head(head);
+	}
 	module_put(THIS_MODULE);
 }
 
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 {
+	struct mpath_disk *mpath_disk;
+	struct mpath_head *mpath_head;
+	struct nvme_subsystem *subsys = ctrl->subsys;
 	struct queue_limits lim;
 
-	mutex_init(&head->lock);
-	bio_list_init(&head->requeue_list);
-	spin_lock_init(&head->requeue_lock);
-	INIT_WORK(&head->requeue_work, nvme_requeue_work);
-	INIT_WORK(&head->partition_scan_work, nvme_partition_scan_work);
-	INIT_DELAYED_WORK(&head->remove_work, nvme_remove_head_work);
-	head->delayed_removal_secs = 0;
-
 	/*
 	 * If "multipath_always_on" is enabled, a multipath node is added
 	 * regardless of whether the disk is single/multi ported, and whether
@@ -832,66 +463,29 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	if (head->ids.csi == NVME_CSI_ZNS)
 		lim.features |= BLK_FEAT_ZONED;
 
-	head->disk = blk_alloc_disk(&lim, ctrl->numa_node);
-	if (IS_ERR(head->disk))
-		return PTR_ERR(head->disk);
-	head->disk->fops = &nvme_ns_head_ops;
-	head->disk->private_data = head;
-
-	/*
-	 * We need to suppress the partition scan from occuring within the
-	 * controller's scan_work context. If a path error occurs here, the IO
-	 * will wait until a path becomes available or all paths are torn down,
-	 * but that action also occurs within scan_work, so it would deadlock.
-	 * Defer the partition scan to a different context that does not block
-	 * scan_work.
-	 */
-	set_bit(GD_SUPPRESS_PART_SCAN, &head->disk->state);
-	sprintf(head->disk->disk_name, "nvme%dn%d",
-			ctrl->subsys->instance, head->instance);
-	nvme_tryget_ns_head(head);
-	return 0;
-}
-
-static void nvme_mpath_set_live(struct nvme_ns *ns)
-{
-	struct nvme_ns_head *head = ns->head;
-	int rc;
-
-	if (!head->disk)
-		return;
+	mpath_disk = mpath_alloc_head_disk(&lim, ctrl->numa_node);
+	if (!mpath_disk)
+		return -ENOMEM;
 
-	/*
-	 * test_and_set_bit() is used because it is protecting against two nvme
-	 * paths simultaneously calling device_add_disk() on the same namespace
-	 * head.
-	 */
-	if (!test_and_set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
-		rc = device_add_disk(&head->subsys->dev, head->disk,
-				     nvme_ns_attr_groups);
-		if (rc) {
-			clear_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);
-			return;
-		}
-		nvme_add_ns_head_cdev(head);
-		queue_work(nvme_wq, &head->partition_scan_work);
+	mpath_head = mpath_alloc_head();
+	if (IS_ERR(mpath_head)) {
+		mpath_put_disk(mpath_disk);
+		return PTR_ERR(mpath_head);
 	}
 
-	nvme_mpath_add_sysfs_link(ns->head);
+	mpath_head->drvdata = head;
 
-	mutex_lock(&head->lock);
-	if (nvme_path_is_optimized(ns)) {
-		int node, srcu_idx;
+	head->mpath_disk = mpath_disk;
+	mpath_disk->mpath_head = mpath_head;
+	mpath_disk->parent = &subsys->dev;
 
-		srcu_idx = srcu_read_lock(&head->srcu);
-		for_each_online_node(node)
-			__nvme_find_path(head, node);
-		srcu_read_unlock(&head->srcu, srcu_idx);
-	}
-	mutex_unlock(&head->lock);
+	mpath_head->mpdt = &mpdt;
+	INIT_DELAYED_WORK(&mpath_head->remove_work, nvme_remove_head_work);
 
-	synchronize_srcu(&head->srcu);
-	kblockd_schedule_work(&head->requeue_work);
+	sprintf(mpath_disk->disk->disk_name, "nvme%dn%d",
+			ctrl->subsys->instance, head->instance);
+	nvme_tryget_ns_head(head);
+	return 0;
 }
 
 static int nvme_parse_ana_log(struct nvme_ctrl *ctrl, void *data,
@@ -946,9 +540,13 @@ static inline bool nvme_state_is_live(enum nvme_ana_state state)
 static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 		struct nvme_ns *ns)
 {
+	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
 	ns->ana_grpid = le32_to_cpu(desc->grpid);
 	ns->ana_state = desc->state;
 	clear_bit(NVME_NS_ANA_PENDING, &ns->flags);
+
 	/*
 	 * nvme_mpath_set_live() will trigger I/O to the multipath path device
 	 * and in turn to this path device.  However we cannot accept this I/O
@@ -960,7 +558,7 @@ static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 	 */
 	if (nvme_state_is_live(ns->ana_state) &&
 	    nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE)
-		nvme_mpath_set_live(ns);
+		mpath_device_set_live(mpath_disk, &ns->mpath_device);
 	else {
 		/*
 		 * Add sysfs link from multipath head gendisk node to path
@@ -977,8 +575,8 @@ static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 		 * is not live but still create the sysfs link to this path from
 		 * head node if head node of the path has already come alive.
 		 */
-		if (test_bit(NVME_NSHEAD_DISK_LIVE, &ns->head->flags))
-			nvme_mpath_add_sysfs_link(ns->head);
+		if (test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+			mpath_add_sysfs_link(mpath_disk);
 	}
 }
 
@@ -1018,6 +616,17 @@ void nvme_mpath_delete_ns(struct nvme_ns *ns)
 	mpath_delete_device(mpath_disk->mpath_head, &ns->mpath_device);
 }
 
+void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns)
+{
+	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+
+	if (!mpath_disk)
+		return;
+
+	mpath_remove_sysfs_link(mpath_disk, &ns->mpath_device);
+}
+
 static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
 		struct nvme_ana_group_desc *desc, void *data)
 {
@@ -1140,32 +749,23 @@ static ssize_t nvme_subsys_iopolicy_show(struct device *dev,
 {
 	struct nvme_subsystem *subsys =
 		container_of(dev, struct nvme_subsystem, dev);
+	return mpath_iopolicy_show(&subsys->iopolicy, buf);
 
-	return sysfs_emit(buf, "%s\n",
-			  nvme_iopolicy_names[READ_ONCE(subsys->iopolicy)]);
 }
 
-static void nvme_subsys_iopolicy_update(struct nvme_subsystem *subsys,
-		int iopolicy)
+static void nvme_subsys_iopolicy_store_update(void *data)
 {
+	struct nvme_subsystem *subsys = data;
 	struct nvme_ctrl *ctrl;
-	int old_iopolicy = READ_ONCE(subsys->iopolicy);
 
-	if (old_iopolicy == iopolicy)
-		return;
-
-	WRITE_ONCE(subsys->iopolicy, iopolicy);
-
-	/* iopolicy changes clear the mpath by design */
 	mutex_lock(&nvme_subsystems_lock);
-	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
+	pr_err("%s subsys=%pS\n", __func__, subsys);
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry) {
+		pr_err("%s2 subsys=%pS ctrl=%pS calling nvme_mpath_clear_ctrl_paths\n",
+			__func__, subsys, ctrl);
 		nvme_mpath_clear_ctrl_paths(ctrl);
+	}
 	mutex_unlock(&nvme_subsystems_lock);
-
-	pr_notice("subsysnqn %s iopolicy changed from %s to %s\n",
-			subsys->subnqn,
-			nvme_iopolicy_names[old_iopolicy],
-			nvme_iopolicy_names[iopolicy]);
 }
 
 static ssize_t nvme_subsys_iopolicy_store(struct device *dev,
@@ -1173,16 +773,9 @@ static ssize_t nvme_subsys_iopolicy_store(struct device *dev,
 {
 	struct nvme_subsystem *subsys =
 		container_of(dev, struct nvme_subsystem, dev);
-	int i;
 
-	for (i = 0; i < ARRAY_SIZE(nvme_iopolicy_names); i++) {
-		if (sysfs_streq(buf, nvme_iopolicy_names[i])) {
-			nvme_subsys_iopolicy_update(subsys, i);
-			return count;
-		}
-	}
-
-	return -EINVAL;
+	return mpath_iopolicy_store(&subsys->iopolicy, buf, count,
+		nvme_subsys_iopolicy_store_update, subsys);
 }
 SUBSYS_ATTR_RW(iopolicy, S_IRUGO | S_IWUSR,
 		      nvme_subsys_iopolicy_show, nvme_subsys_iopolicy_store);
@@ -1207,8 +800,9 @@ static ssize_t queue_depth_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvme_ns *ns = nvme_get_ns_from_dev(dev);
+	struct nvme_subsystem *subsys = ns->head->subsys;
 
-	if (ns->head->subsys->iopolicy != NVME_IOPOLICY_QD)
+	if (!mpath_qd_iopolicy(&subsys->iopolicy))
 		return 0;
 
 	return sysfs_emit(buf, "%d\n", atomic_read(&ns->ctrl->nr_active));
@@ -1218,69 +812,33 @@ DEVICE_ATTR_RO(queue_depth);
 static ssize_t numa_nodes_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	int node, srcu_idx;
-	nodemask_t numa_nodes;
-	struct nvme_ns *current_ns;
 	struct nvme_ns *ns = nvme_get_ns_from_dev(dev);
 	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct nvme_subsystem *subsys = ns->head->subsys;
+	struct mpath_device *mpath_device = &ns->mpath_device;
 
-	if (head->subsys->iopolicy != NVME_IOPOLICY_NUMA)
-		return 0;
-
-	nodes_clear(numa_nodes);
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	for_each_node(node) {
-		current_ns = srcu_dereference(head->current_path[node],
-				&head->srcu);
-		if (ns == current_ns)
-			node_set(node, numa_nodes);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
-
-	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&numa_nodes));
+	return mpath_numa_nodes_show(mpath_head, mpath_device, &subsys->iopolicy, buf);
 }
 DEVICE_ATTR_RO(numa_nodes);
 
-static ssize_t delayed_removal_secs_show(struct device *dev,
+static ssize_t delayed_removal_secs_show(struct device *bd_device,
 		struct device_attribute *attr, char *buf)
 {
-	struct gendisk *disk = dev_to_disk(dev);
-	struct nvme_ns_head *head = disk->private_data;
-	int ret;
+	struct mpath_disk *mpath_disk = mpath_bd_device_to_disk(bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
 
-	mutex_lock(&head->subsys->lock);
-	ret = sysfs_emit(buf, "%u\n", head->delayed_removal_secs);
-	mutex_unlock(&head->subsys->lock);
-	return ret;
+	return mpath_delayed_removal_secs_show(mpath_head, buf);
 }
 
-static ssize_t delayed_removal_secs_store(struct device *dev,
+static ssize_t delayed_removal_secs_store(struct device *bd_device,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct gendisk *disk = dev_to_disk(dev);
-	struct nvme_ns_head *head = disk->private_data;
-	unsigned int sec;
-	int ret;
-
-	ret = kstrtouint(buf, 0, &sec);
-	if (ret < 0)
-		return ret;
-
-	mutex_lock(&head->subsys->lock);
-	head->delayed_removal_secs = sec;
-	if (sec)
-		set_bit(NVME_NSHEAD_QUEUE_IF_NO_PATH, &head->flags);
-	else
-		clear_bit(NVME_NSHEAD_QUEUE_IF_NO_PATH, &head->flags);
-	mutex_unlock(&head->subsys->lock);
-	/*
-	 * Ensure that update to NVME_NSHEAD_QUEUE_IF_NO_PATH is seen
-	 * by its reader.
-	 */
-	synchronize_srcu(&head->srcu);
+	struct mpath_disk *mpath_disk = mpath_bd_device_to_disk(bd_device);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
 
-	return count;
+	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
 }
 
 DEVICE_ATTR_RW(delayed_removal_secs);
@@ -1297,87 +855,14 @@ static int nvme_lookup_ana_group_desc(struct nvme_ctrl *ctrl,
 	return -ENXIO; /* just break out of the loop */
 }
 
-void nvme_mpath_add_sysfs_link(struct nvme_ns_head *head)
-{
-	struct device *target;
-	int rc, srcu_idx;
-	struct nvme_ns *ns;
-	struct kobject *kobj;
-
-	/*
-	 * Ensure head disk node is already added otherwise we may get invalid
-	 * kobj for head disk node
-	 */
-	if (!test_bit(GD_ADDED, &head->disk->state))
-		return;
-
-	kobj = &disk_to_dev(head->disk)->kobj;
-
-	/*
-	 * loop through each ns chained through the head->list and create the
-	 * sysfs link from head node to the ns path node
-	 */
-	srcu_idx = srcu_read_lock(&head->srcu);
-
-	list_for_each_entry_srcu(ns, &head->list, siblings,
-				 srcu_read_lock_held(&head->srcu)) {
-		/*
-		 * Ensure that ns path disk node is already added otherwise we
-		 * may get invalid kobj name for target
-		 */
-		if (!test_bit(GD_ADDED, &ns->disk->state))
-			continue;
-
-		/*
-		 * Avoid creating link if it already exists for the given path.
-		 * When path ana state transitions from optimized to non-
-		 * optimized or vice-versa, the nvme_mpath_set_live() is
-		 * invoked which in truns call this function. Now if the sysfs
-		 * link already exists for the given path and we attempt to re-
-		 * create the link then sysfs code would warn about it loudly.
-		 * So we evaluate NVME_NS_SYSFS_ATTR_LINK flag here to ensure
-		 * that we're not creating duplicate link.
-		 * The test_and_set_bit() is used because it is protecting
-		 * against multiple nvme paths being simultaneously added.
-		 */
-		if (test_and_set_bit(NVME_NS_SYSFS_ATTR_LINK, &ns->flags))
-			continue;
-
-		target = disk_to_dev(ns->disk);
-		/*
-		 * Create sysfs link from head gendisk kobject @kobj to the
-		 * ns path gendisk kobject @target->kobj.
-		 */
-		rc = sysfs_add_link_to_group(kobj, nvme_ns_mpath_attr_group.name,
-				&target->kobj, dev_name(target));
-		if (unlikely(rc)) {
-			dev_err(disk_to_dev(ns->head->disk),
-					"failed to create link to %s\n",
-					dev_name(target));
-			clear_bit(NVME_NS_SYSFS_ATTR_LINK, &ns->flags);
-		}
-	}
-
-	srcu_read_unlock(&head->srcu, srcu_idx);
-}
-
-void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns)
+void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 {
-	struct device *target;
-	struct kobject *kobj;
+	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
 
-	if (!test_bit(NVME_NS_SYSFS_ATTR_LINK, &ns->flags))
+	if (!mpath_disk)
 		return;
 
-	target = disk_to_dev(ns->disk);
-	kobj = &disk_to_dev(ns->head->disk)->kobj;
-	sysfs_remove_link_from_group(kobj, nvme_ns_mpath_attr_group.name,
-			dev_name(target));
-	clear_bit(NVME_NS_SYSFS_ATTR_LINK, &ns->flags);
-}
-
-void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
-{
 	if (nvme_ctrl_use_ana(ns->ctrl)) {
 		struct nvme_ana_group_desc desc = {
 			.grpid = anagrpid,
@@ -1398,23 +883,28 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 		}
 	} else {
 		ns->ana_state = NVME_ANA_OPTIMIZED;
-		nvme_mpath_set_live(ns);
+		mpath_device_set_live(mpath_disk, &ns->mpath_device);
 	}
 
 #ifdef CONFIG_BLK_DEV_ZONED
-	if (blk_queue_is_zoned(ns->queue) && ns->head->disk)
-		ns->head->disk->nr_zones = ns->disk->nr_zones;
+	if (blk_queue_is_zoned(ns->queue) && mpath_disk->disk)
+		mpath_disk->disk->nr_zones = ns->disk->nr_zones;
 #endif
 }
 
 void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 {
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+	struct mpath_head *mpath_head;
 	bool remove = false;
 
-	if (!head->disk)
+	if (!mpath_disk)
 		return;
 
+	mpath_head = mpath_disk->mpath_head;
+
 	mutex_lock(&head->subsys->lock);
+
 	/*
 	 * We are called when all paths have been removed, and at that point
 	 * head->list is expected to be empty. However, nvme_ns_remove() and
@@ -1424,37 +914,21 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 	 * head->list here. If it is no longer empty then we skip enqueuing the
 	 * delayed head removal work.
 	 */
+
 	if (head->ns_count)
 		goto out;
 
-	if (head->delayed_removal_secs) {
-		/*
-		 * Ensure that no one could remove this module while the head
-		 * remove work is pending.
-		 */
-		if (!try_module_get(THIS_MODULE))
-			goto out;
-		mod_delayed_work(nvme_wq, &head->remove_work,
-				head->delayed_removal_secs * HZ);
-	} else {
+	if (mpath_can_remove_head(mpath_head)) {
 		list_del_init(&head->entry);
 		remove = true;
 	}
 out:
 	mutex_unlock(&head->subsys->lock);
-	if (remove)
-		nvme_remove_head(head);
-}
 
-void nvme_mpath_put_disk(struct nvme_ns_head *head)
-{
-	if (!head->disk)
-		return;
-	/* make sure all pending bios are cleaned up */
-	kblockd_schedule_work(&head->requeue_work);
-	flush_work(&head->requeue_work);
-	flush_work(&head->partition_scan_work);
-	put_disk(head->disk);
+	if (remove) {
+		mpath_unregister_disk(mpath_disk);
+		nvme_put_ns_head(head);
+	}
 }
 
 void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl)
@@ -1525,15 +999,16 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 	ctrl->ana_log_size = 0;
 }
 
-static enum mpath_iopolicy_e nvme_mpath_get_iopolicy(
-				struct mpath_head *mpath_head)
+
+static enum mpath_iopolicy_e nvme_mpath_get_iopolicy(struct mpath_head *mpath_head)
 {
 	struct nvme_ns_head *head = mpath_head->drvdata;
 	struct nvme_subsystem *subsys = head->subsys;
 
-	return mpath_read_iopolicy(&subsys->mpath_iopolicy);
+	return mpath_read_iopolicy(&subsys->iopolicy);
 }
 
+
 static enum mpath_access_state nvme_mpath_get_access_state(
 				struct mpath_device *mpath_device)
 {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index e276a7bcb7aff..d83495dead590 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -253,11 +253,6 @@ struct nvme_request {
 	struct nvme_ctrl	*ctrl;
 };
 
-/*
- * Mark a bio as coming in through the mpath node.
- */
-#define REQ_NVME_MPATH		REQ_DRV
-
 enum {
 	NVME_REQ_CANCELLED		= (1 << 0),
 	NVME_REQ_USERCMD		= (1 << 1),
@@ -475,11 +470,6 @@ static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
 	return READ_ONCE(ctrl->state);
 }
 
-enum nvme_iopolicy {
-	NVME_IOPOLICY_NUMA,
-	NVME_IOPOLICY_RR,
-	NVME_IOPOLICY_QD,
-};
 
 struct nvme_subsystem {
 	int			instance;
@@ -502,8 +492,7 @@ struct nvme_subsystem {
 	u16			vendor_id;
 	struct ida		ns_ida;
 #ifdef CONFIG_NVME_MULTIPATH
-	enum nvme_iopolicy	iopolicy;
-	struct mpath_iopolicy mpath_iopolicy;
+	struct mpath_iopolicy	iopolicy;
 #endif
 };
 
@@ -525,8 +514,6 @@ struct nvme_ns_ids {
  * only ever has a single entry for private namespaces.
  */
 struct nvme_ns_head {
-	struct list_head	list;
-	struct srcu_struct      srcu;
 	struct nvme_subsystem	*subsys;
 	struct nvme_ns_ids	ids;
 	u8			lba_shift;
@@ -551,33 +538,15 @@ struct nvme_ns_head {
 
 	struct ratelimit_state	rs_nuse;
 
-	struct cdev		cdev;
-	struct device		cdev_device;
-
-	struct gendisk		*disk;
-
 	u16			nr_plids;
 	u16			*plids;
 
 	struct mpath_disk	*mpath_disk;
-#ifdef CONFIG_NVME_MULTIPATH
-	struct bio_list		requeue_list;
-	spinlock_t		requeue_lock;
-	struct work_struct	requeue_work;
-	struct work_struct	partition_scan_work;
-	struct mutex		lock;
-	unsigned long		flags;
-	struct delayed_work	remove_work;
-	unsigned int		delayed_removal_secs;
-#define NVME_NSHEAD_DISK_LIVE		0
-#define NVME_NSHEAD_QUEUE_IF_NO_PATH	1
-	struct nvme_ns __rcu	*current_path[];
-#endif
 };
 
 static inline bool nvme_ns_head_multipath(struct nvme_ns_head *head)
 {
-	return IS_ENABLED(CONFIG_NVME_MULTIPATH) && head->disk;
+	return IS_ENABLED(CONFIG_NVME_MULTIPATH) && head->mpath_disk;
 }
 
 enum nvme_ns_features {
@@ -1011,9 +980,7 @@ int nvme_getgeo(struct gendisk *disk, struct hd_geometry *geo);
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 
 extern const struct attribute_group *nvme_ns_attr_groups[];
-extern const struct attribute_group nvme_ns_mpath_attr_group;
 extern const struct pr_ops nvme_pr_ops;
-extern const struct block_device_operations nvme_ns_head_ops;
 extern const struct attribute_group nvme_dev_attrs_group;
 extern const struct attribute_group *nvme_subsys_attrs_groups[];
 extern const struct attribute_group *nvme_dev_attr_groups[];
@@ -1030,6 +997,7 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 void nvme_mpath_synchronize(struct nvme_ns_head *head);
 void nvme_mpath_add_ns(struct nvme_ns *ns);
 void nvme_mpath_delete_ns(struct nvme_ns *ns);
+void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns);
 void nvme_mpath_unfreeze(struct nvme_subsystem *subsys);
 void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
 void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
@@ -1037,8 +1005,7 @@ void nvme_mpath_default_iopolicy(struct nvme_subsystem *subsys);
 void nvme_failover_req(struct request *req);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
-void nvme_mpath_add_sysfs_link(struct nvme_ns_head *ns);
-void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns);
+bool nvme_mpath_has_disk(struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid);
 void nvme_mpath_put_disk(struct nvme_ns_head *head);
 int nvme_mpath_init_identify(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
@@ -1064,15 +1031,19 @@ int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
 
 static inline bool nvme_is_mpath_request(struct request *req)
 {
-	return req->cmd_flags & REQ_NVME_MPATH;
+	return is_mpath_request(req);
 }
 
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
 
-	if (nvme_is_mpath_request(req) && req->bio)
-		trace_block_bio_complete(ns->head->disk->queue, req->bio);
+	if (nvme_is_mpath_request(req) && req->bio) {
+		struct nvme_ns_head *head = ns->head;
+		struct mpath_disk *mpath_disk = head->mpath_disk;
+
+		trace_block_bio_complete(mpath_disk->disk->queue, req->bio);
+	}
 }
 
 extern bool multipath;
@@ -1085,13 +1056,7 @@ extern struct device_attribute subsys_attr_iopolicy;
 
 static inline bool nvme_disk_is_ns_head(struct gendisk *disk)
 {
-	return disk->fops == &nvme_ns_head_ops;
-}
-static inline bool nvme_mpath_queue_if_no_path(struct nvme_ns_head *head)
-{
-	if (test_bit(NVME_NSHEAD_QUEUE_IF_NO_PATH, &head->flags))
-		return true;
-	return false;
+	return is_mpath_head(disk);
 }
 #else
 #define multipath false
@@ -1108,6 +1073,9 @@ static inline void nvme_mpath_add_ns(struct nvme_ns *ns)
 static inline void nvme_mpath_delete_ns(struct nvme_ns *ns)
 {
 }
+static inline void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns)
+{
+}
 static inline void nvme_failover_req(struct request *req)
 {
 }
@@ -1119,16 +1087,14 @@ static inline int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,
 {
 	return 0;
 }
-static inline void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
-{
-}
-static inline void nvme_mpath_put_disk(struct nvme_ns_head *head)
+static inline bool nvme_mpath_has_disk(struct nvme_ns_head *head)
 {
+	return false;
 }
-static inline void nvme_mpath_add_sysfs_link(struct nvme_ns *ns)
+static inline void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 {
 }
-static inline void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns)
+static inline void nvme_mpath_put_disk(struct nvme_ns_head *head)
 {
 }
 static inline bool nvme_mpath_clear_current_path(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index fd5a9f309a56f..b1002c3d43eb3 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -49,24 +49,9 @@ static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
 	return 0;
 }
 
-static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, void *data, unsigned int data_len)
-{
-	struct nvme_ns_head *head = bdev->bd_disk->private_data;
-	int srcu_idx = srcu_read_lock(&head->srcu);
-	struct nvme_ns *ns = nvme_find_path(head);
-	int ret = -EWOULDBLOCK;
-
-	if (ns) {
-		c->common.nsid = cpu_to_le32(ns->head->ns_id);
-		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-
-static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		void *data, unsigned int data_len)
+static int nvme_send_device_pr_command(struct nvme_ns *ns,
+		struct nvme_command *c, void *data,
+		unsigned int data_len)
 {
 	c->common.nsid = cpu_to_le32(ns->head->ns_id);
 	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
@@ -92,31 +77,7 @@ static int nvme_status_to_pr_err(int status)
 	}
 }
 
-static int __nvme_send_pr_command(struct block_device *bdev, u32 cdw10,
-		u32 cdw11, u8 op, void *data, unsigned int data_len)
-{
-	struct nvme_command c = { 0 };
-
-	c.common.opcode = op;
-	c.common.cdw10 = cpu_to_le32(cdw10);
-	c.common.cdw11 = cpu_to_le32(cdw11);
-
-	if (nvme_disk_is_ns_head(bdev->bd_disk))
-		return nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
-				data, data_len);
-}
-
-static int nvme_send_pr_command(struct block_device *bdev, u32 cdw10, u32 cdw11,
-		u8 op, void *data, unsigned int data_len)
-{
-	int ret;
-
-	ret = __nvme_send_pr_command(bdev, cdw10, cdw11, op, data, data_len);
-	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
-}
-
-static int __nvme_send_pr_command_ns(struct nvme_ns *ns, u32 cdw10,
+static int __nvme_send_pr_command(struct nvme_ns *ns, u32 cdw10,
 		u32 cdw11, u8 op, void *data, unsigned int data_len)
 {
 	struct nvme_command c = { 0 };
@@ -125,19 +86,18 @@ static int __nvme_send_pr_command_ns(struct nvme_ns *ns, u32 cdw10,
 	c.common.cdw10 = cpu_to_le32(cdw10);
 	c.common.cdw11 = cpu_to_le32(cdw11);
 
-	return nvme_send_ns_pr_command(ns, &c, data, data_len);
+	return nvme_send_device_pr_command(ns, &c, data, data_len);
 }
 
-static int nvme_send_pr_command_ns(struct nvme_ns *ns, u32 cdw10, u32 cdw11,
+static int nvme_send_pr_command(struct nvme_ns *ns, u32 cdw10, u32 cdw11,
 		u8 op, void *data, unsigned int data_len)
 {
 	int ret;
 
-	ret = __nvme_send_pr_command_ns(ns, cdw10, cdw11, op, data, data_len);
+	ret = __nvme_send_pr_command(ns, cdw10, cdw11, op, data, data_len);
 	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
 }
 
-__maybe_unused
 static int nvme_pr_register_ns(struct nvme_ns *ns, u64 old_key, u64 new_key,
 			u32 flags)
 {
@@ -156,33 +116,11 @@ static int nvme_pr_register_ns(struct nvme_ns *ns, u64 old_key, u64 new_key,
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
 	cdw10 |= NVME_PR_CPTPL_PERSIST;
 
-	ret = nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_register,
+	ret = nvme_send_pr_command(ns, cdw10, 0, nvme_cmd_resv_register,
 			&data, sizeof(data));
 	return ret;
 }
 
-static int nvme_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
-		unsigned int flags)
-{
-	struct nvmet_pr_register_data data = { 0 };
-	u32 cdw10;
-
-	if (flags & ~PR_FL_IGNORE_KEY)
-		return -EOPNOTSUPP;
-
-	data.crkey = cpu_to_le64(old_key);
-	data.nrkey = cpu_to_le64(new_key);
-
-	cdw10 = old_key ? NVME_PR_REGISTER_ACT_REPLACE :
-		NVME_PR_REGISTER_ACT_REG;
-	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
-	cdw10 |= NVME_PR_CPTPL_PERSIST;
-
-	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_register,
-			&data, sizeof(data));
-}
-
-__maybe_unused
 static int nvme_pr_reserve_ns(struct nvme_ns *ns, u64 key, enum pr_type type,
 		u32 flags)
 {
@@ -198,30 +136,10 @@ static int nvme_pr_reserve_ns(struct nvme_ns *ns, u64 key, enum pr_type type,
 	cdw10 |= nvme_pr_type_from_blk(type) << 8;
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
 
-	return nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_acquire,
+	return nvme_send_pr_command(ns, cdw10, 0, nvme_cmd_resv_acquire,
 			&data, sizeof(data));
 }
 
-static int nvme_pr_reserve(struct block_device *bdev, u64 key,
-		enum pr_type type, unsigned flags)
-{
-	struct nvmet_pr_acquire_data data = { 0 };
-	u32 cdw10;
-
-	if (flags & ~PR_FL_IGNORE_KEY)
-		return -EOPNOTSUPP;
-
-	data.crkey = cpu_to_le64(key);
-
-	cdw10 = NVME_PR_ACQUIRE_ACT_ACQUIRE;
-	cdw10 |= nvme_pr_type_from_blk(type) << 8;
-	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
-
-	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_acquire,
-			&data, sizeof(data));
-}
-
-__maybe_unused
 static int nvme_pr_preempt_ns(struct nvme_ns *ns, u64 old, u64 new,
 		enum pr_type type, bool abort)
 {
@@ -235,28 +153,10 @@ static int nvme_pr_preempt_ns(struct nvme_ns *ns, u64 old, u64 new,
 			NVME_PR_ACQUIRE_ACT_PREEMPT;
 	cdw10 |= nvme_pr_type_from_blk(type) << 8;
 
-	return nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_acquire,
-			&data, sizeof(data));
-}
-
-static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
-		enum pr_type type, bool abort)
-{
-	struct nvmet_pr_acquire_data data = { 0 };
-	u32 cdw10;
-
-	data.crkey = cpu_to_le64(old);
-	data.prkey = cpu_to_le64(new);
-
-	cdw10 = abort ? NVME_PR_ACQUIRE_ACT_PREEMPT_AND_ABORT :
-			NVME_PR_ACQUIRE_ACT_PREEMPT;
-	cdw10 |= nvme_pr_type_from_blk(type) << 8;
-
-	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_acquire,
+	return nvme_send_pr_command(ns, cdw10, 0, nvme_cmd_resv_acquire,
 			&data, sizeof(data));
 }
 
-__maybe_unused
 static int nvme_pr_clear_ns(struct nvme_ns *ns, u64 key)
 {
 	struct nvmet_pr_release_data data = { 0 };
@@ -267,40 +167,10 @@ static int nvme_pr_clear_ns(struct nvme_ns *ns, u64 key)
 	cdw10 = NVME_PR_RELEASE_ACT_CLEAR;
 	cdw10 |= key ? 0 : NVME_PR_IGNORE_KEY;
 
-	return nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_release,
-			&data, sizeof(data));
-}
-
-static int nvme_pr_clear(struct block_device *bdev, u64 key)
-{
-	struct nvmet_pr_release_data data = { 0 };
-	u32 cdw10;
-
-	data.crkey = cpu_to_le64(key);
-
-	cdw10 = NVME_PR_RELEASE_ACT_CLEAR;
-	cdw10 |= key ? 0 : NVME_PR_IGNORE_KEY;
-
-	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_release,
+	return nvme_send_pr_command(ns, cdw10, 0, nvme_cmd_resv_release,
 			&data, sizeof(data));
 }
 
-static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
-{
-	struct nvmet_pr_release_data data = { 0 };
-	u32 cdw10;
-
-	data.crkey = cpu_to_le64(key);
-
-	cdw10 = NVME_PR_RELEASE_ACT_RELEASE;
-	cdw10 |= nvme_pr_type_from_blk(type) << 8;
-	cdw10 |= key ? 0 : NVME_PR_IGNORE_KEY;
-
-	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_release,
-			&data, sizeof(data));
-}
-
-__maybe_unused
 static int nvme_pr_release_ns(struct nvme_ns *ns, u64 key, enum pr_type type)
 {
 	struct nvmet_pr_release_data data = { 0 };
@@ -312,11 +182,11 @@ static int nvme_pr_release_ns(struct nvme_ns *ns, u64 key, enum pr_type type)
 	cdw10 |= nvme_pr_type_from_blk(type) << 8;
 	cdw10 |= key ? 0 : NVME_PR_IGNORE_KEY;
 
-	return nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_release,
+	return nvme_send_pr_command(ns, cdw10, 0, nvme_cmd_resv_release,
 			&data, sizeof(data));
 }
 
-static int nvme_mpath_pr_resv_report_ns(struct nvme_ns *ns, void *data,
+static int nvme_mpath_pr_resv_report(struct nvme_ns *ns, void *data,
 		u32 data_len, bool *eds)
 {
 	u32 cdw10, cdw11;
@@ -327,7 +197,7 @@ static int nvme_mpath_pr_resv_report_ns(struct nvme_ns *ns, void *data,
 	*eds = true;
 
 retry:
-	ret = __nvme_send_pr_command_ns(ns, cdw10, cdw11, nvme_cmd_resv_report,
+	ret = __nvme_send_pr_command(ns, cdw10, cdw11, nvme_cmd_resv_report,
 			data, data_len);
 	if (ret == NVME_SC_HOST_ID_INCONSIST &&
 	    cdw11 == NVME_EXTENDED_DATA_STRUCT) {
@@ -339,30 +209,6 @@ static int nvme_mpath_pr_resv_report_ns(struct nvme_ns *ns, void *data,
 	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
 }
 
-static int nvme_pr_resv_report(struct block_device *bdev, void *data,
-		u32 data_len, bool *eds)
-{
-	u32 cdw10, cdw11;
-	int ret;
-
-	cdw10 = nvme_bytes_to_numd(data_len);
-	cdw11 = NVME_EXTENDED_DATA_STRUCT;
-	*eds = true;
-
-retry:
-	ret = __nvme_send_pr_command(bdev, cdw10, cdw11, nvme_cmd_resv_report,
-			data, data_len);
-	if (ret == NVME_SC_HOST_ID_INCONSIST &&
-	    cdw11 == NVME_EXTENDED_DATA_STRUCT) {
-		cdw11 = 0;
-		*eds = false;
-		goto retry;
-	}
-
-	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
-}
-
-__maybe_unused
 static int nvme_pr_read_keys_ns(struct nvme_ns *ns, struct pr_keys *keys_info)
 {
 	size_t rse_len;
@@ -383,7 +229,7 @@ static int nvme_pr_read_keys_ns(struct nvme_ns *ns, struct pr_keys *keys_info)
 	if (!rse)
 		return -ENOMEM;
 
-	ret = nvme_mpath_pr_resv_report_ns(ns, rse, rse_len, &eds);
+	ret = nvme_mpath_pr_resv_report(ns, rse, rse_len, &eds);
 	if (ret)
 		goto free_rse;
 
@@ -399,53 +245,8 @@ static int nvme_pr_read_keys_ns(struct nvme_ns *ns, struct pr_keys *keys_info)
 			struct nvme_reservation_status *rs;
 
 			rs = (struct nvme_reservation_status *)rse;
-			keys_info->keys[i] = le64_to_cpu(rs->regctl_ds[i].rkey);
-		}
-	}
-
-free_rse:
-	kfree(rse);
-	return ret;
-}
-
-static int nvme_pr_read_keys(struct block_device *bdev,
-		struct pr_keys *keys_info)
-{
-	size_t rse_len;
-	u32 num_keys = keys_info->num_keys;
-	struct nvme_reservation_status_ext *rse;
-	int ret, i;
-	bool eds;
-
-	/*
-	 * Assume we are using 128-bit host IDs and allocate a buffer large
-	 * enough to get enough keys to fill the return keys buffer.
-	 */
-	rse_len = struct_size(rse, regctl_eds, num_keys);
-	if (rse_len > U32_MAX)
-		return -EINVAL;
-
-	rse = kzalloc(rse_len, GFP_KERNEL);
-	if (!rse)
-		return -ENOMEM;
-
-	ret = nvme_pr_resv_report(bdev, rse, rse_len, &eds);
-	if (ret)
-		goto free_rse;
-
-	keys_info->generation = le32_to_cpu(rse->gen);
-	keys_info->num_keys = get_unaligned_le16(&rse->regctl);
-
-	num_keys = min(num_keys, keys_info->num_keys);
-	for (i = 0; i < num_keys; i++) {
-		if (eds) {
 			keys_info->keys[i] =
-					le64_to_cpu(rse->regctl_eds[i].rkey);
-		} else {
-			struct nvme_reservation_status *rs;
-
-			rs = (struct nvme_reservation_status *)rse;
-			keys_info->keys[i] = le64_to_cpu(rs->regctl_ds[i].rkey);
+				le64_to_cpu(rs->regctl_ds[i].rkey);
 		}
 	}
 
@@ -454,7 +255,6 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	return ret;
 }
 
-__maybe_unused
 static int nvme_pr_read_reservation_ns(struct nvme_ns *ns,
 				  struct pr_held_reservation *resv)
 {
@@ -468,7 +268,7 @@ static int nvme_pr_read_reservation_ns(struct nvme_ns *ns,
 	 * Get the number of registrations so we know how big to allocate
 	 * the response buffer.
 	 */
-	ret = nvme_mpath_pr_resv_report_ns(ns, &tmp_rse, sizeof(tmp_rse),
+	ret = nvme_mpath_pr_resv_report(ns, &tmp_rse, sizeof(tmp_rse),
 					&eds);
 	if (ret)
 		return ret;
@@ -484,7 +284,7 @@ static int nvme_pr_read_reservation_ns(struct nvme_ns *ns,
 	if (!rse)
 		return -ENOMEM;
 
-	ret = nvme_mpath_pr_resv_report_ns(ns, rse, rse_len, &eds);
+	ret = nvme_mpath_pr_resv_report(ns, rse, rse_len, &eds);
 	if (ret)
 		goto free_rse;
 
@@ -499,7 +299,8 @@ static int nvme_pr_read_reservation_ns(struct nvme_ns *ns,
 	for (i = 0; i < num_regs; i++) {
 		if (eds) {
 			if (rse->regctl_eds[i].rcsts) {
-				resv->key = le64_to_cpu(rse->regctl_eds[i].rkey);
+				resv->key =
+					le64_to_cpu(rse->regctl_eds[i].rkey);
 				break;
 			}
 		} else {
@@ -518,67 +319,6 @@ static int nvme_pr_read_reservation_ns(struct nvme_ns *ns,
 	return ret;
 }
 
-static int nvme_pr_read_reservation(struct block_device *bdev,
-		struct pr_held_reservation *resv)
-{
-	struct nvme_reservation_status_ext tmp_rse, *rse;
-	int ret, i, num_regs;
-	u32 rse_len;
-	bool eds;
-
-get_num_regs:
-	/*
-	 * Get the number of registrations so we know how big to allocate
-	 * the response buffer.
-	 */
-	ret = nvme_pr_resv_report(bdev, &tmp_rse, sizeof(tmp_rse), &eds);
-	if (ret)
-		return ret;
-
-	num_regs = get_unaligned_le16(&tmp_rse.regctl);
-	if (!num_regs) {
-		resv->generation = le32_to_cpu(tmp_rse.gen);
-		return 0;
-	}
-
-	rse_len = struct_size(rse, regctl_eds, num_regs);
-	rse = kzalloc(rse_len, GFP_KERNEL);
-	if (!rse)
-		return -ENOMEM;
-
-	ret = nvme_pr_resv_report(bdev, rse, rse_len, &eds);
-	if (ret)
-		goto free_rse;
-
-	if (num_regs != get_unaligned_le16(&rse->regctl)) {
-		kfree(rse);
-		goto get_num_regs;
-	}
-
-	resv->generation = le32_to_cpu(rse->gen);
-	resv->type = block_pr_type_from_nvme(rse->rtype);
-
-	for (i = 0; i < num_regs; i++) {
-		if (eds) {
-			if (rse->regctl_eds[i].rcsts) {
-				resv->key = le64_to_cpu(rse->regctl_eds[i].rkey);
-				break;
-			}
-		} else {
-			struct nvme_reservation_status *rs;
-
-			rs = (struct nvme_reservation_status *)rse;
-			if (rs->regctl_ds[i].rcsts) {
-				resv->key = le64_to_cpu(rs->regctl_ds[i].rkey);
-				break;
-			}
-		}
-	}
-
-free_rse:
-	kfree(rse);
-	return ret;
-}
 
 #if defined(CONFIG_NVME_MULTIPATH)
 static int nvme_mpath_pr_register(struct mpath_device *mpath_device,
@@ -647,6 +387,61 @@ const struct mpath_pr_ops nvme_mpath_pr_ops = {
 };
 #endif
 
+static int nvme_pr_register(struct block_device *bdev, u64 old_key,
+		u64 new_key, unsigned int flags)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+
+	return nvme_pr_register_ns(ns, old_key, new_key, flags);
+}
+
+static int nvme_pr_reserve(struct block_device *bdev, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+
+	return nvme_pr_reserve_ns(ns, key, type, flags);
+}
+
+static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+
+	return nvme_pr_preempt_ns(ns, old, new, type, abort);
+}
+
+static int nvme_pr_clear(struct block_device *bdev, u64 key)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+
+	return nvme_pr_clear_ns(ns, key);
+}
+
+static int nvme_pr_release(struct block_device *bdev, u64 key,
+			enum pr_type type)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+
+	return nvme_pr_release_ns(ns, key, type);
+}
+
+static int nvme_pr_read_keys(struct block_device *bdev,
+		struct pr_keys *keys_info)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+
+	return nvme_pr_read_keys_ns(ns, keys_info);
+}
+
+static int nvme_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+
+	return nvme_pr_read_reservation_ns(ns, resv);
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 16c6fea4b2db6..95f621c0a5b05 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -64,8 +64,11 @@ static inline struct nvme_ns_head *dev_to_ns_head(struct device *dev)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	if (nvme_disk_is_ns_head(disk))
-		return disk->private_data;
+	if (nvme_disk_is_ns_head(disk)) {
+		struct mpath_disk *mpath_disk = mpath_gendisk_to_disk(disk);
+
+		return mpath_disk->mpath_head->drvdata;
+	}
 	return nvme_get_ns_from_dev(dev)->head;
 }
 
@@ -183,30 +186,36 @@ static ssize_t metadata_bytes_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(metadata_bytes);
 
-static int ns_head_update_nuse(struct nvme_ns_head *head)
+static int ns_head_update_nuse_cb(struct mpath_device *mpath_device)
 {
+	struct nvme_ns *ns = container_of(mpath_device, struct nvme_ns, mpath_device);
+	struct nvme_ns_head *head = ns->head;
 	struct nvme_id_ns *id;
-	struct nvme_ns *ns;
-	int srcu_idx, ret = -EWOULDBLOCK;
-
-	/* Avoid issuing commands too often by rate limiting the update */
-	if (!__ratelimit(&head->rs_nuse))
-		return 0;
-
-	srcu_idx = srcu_read_lock(&head->srcu);
-	ns = nvme_find_path(head);
-	if (!ns)
-		goto out_unlock;
+	int ret;
 
 	ret = nvme_identify_ns(ns->ctrl, head->ns_id, &id);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	head->nuse = le64_to_cpu(id->nuse);
 	kfree(id);
+	return 0;
+}
+
+static int ns_head_update_nuse(struct nvme_ns_head *head)
+{
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	int ret;
+
+	/* Avoid issuing commands too often by rate limiting the update */
+	if (!__ratelimit(&head->rs_nuse))
+		return 0;
+
+	ret = mpath_call_for_device(mpath_head, ns_head_update_nuse_cb);
+	if (ret == -ENODEV)
+		return -EWOULDBLOCK;
 
-out_unlock:
-	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
 
@@ -312,49 +321,10 @@ static const struct attribute_group nvme_ns_attr_group = {
 	.is_visible	= nvme_ns_attrs_are_visible,
 };
 
-#ifdef CONFIG_NVME_MULTIPATH
-/*
- * NOTE: The dummy attribute does not appear in sysfs. It exists solely to allow
- * control over the visibility of the multipath sysfs node. Without at least one
- * attribute defined in nvme_ns_mpath_attrs[], the sysfs implementation does not
- * invoke the multipath_sysfs_group_visible() method. As a result, we would not
- * be able to control the visibility of the multipath sysfs node.
- */
-static struct attribute dummy_attr = {
-	.name = "dummy",
-};
-
-static struct attribute *nvme_ns_mpath_attrs[] = {
-	&dummy_attr,
-	NULL,
-};
-
-static bool multipath_sysfs_group_visible(struct kobject *kobj)
-{
-	struct device *dev = container_of(kobj, struct device, kobj);
-
-	return nvme_disk_is_ns_head(dev_to_disk(dev));
-}
-
-static bool multipath_sysfs_attr_visible(struct kobject *kobj,
-		struct attribute *attr, int n)
-{
-	return false;
-}
-
-DEFINE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
-
-const struct attribute_group nvme_ns_mpath_attr_group = {
-	.name           = "multipath",
-	.attrs		= nvme_ns_mpath_attrs,
-	.is_visible     = SYSFS_GROUP_VISIBLE(multipath_sysfs),
-};
-#endif
-
 const struct attribute_group *nvme_ns_attr_groups[] = {
 	&nvme_ns_attr_group,
 #ifdef CONFIG_NVME_MULTIPATH
-	&nvme_ns_mpath_attr_group,
+	&mpath_attr_group,
 #endif
 	NULL,
 };
-- 
2.43.5

