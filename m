Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5212B3EFD1C;
	Wed, 25 Feb 2026 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033873; cv=fail; b=Vj1OYMMnfjIJDWRPe61uWKmu81K/TGixWiQKRT7xKFJ7gQi/BgSpK7V1AE9SLeLxEDNLSydC6i0iUTgAQApkwXx7xMxXiYkWESJmmwCNmxayRhRvtx7Sl6NcOvl5Q/Sfo1w6s5sfgLrkS4MhzsqaQVKjYLpxj5xIoNsKP4P8QQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033873; c=relaxed/simple;
	bh=lZmv8bgSXDux3qlTXgiqfCuDqY+VQzhTf/M7ARS3/TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A5ifiOG5OmGBWMK7i4Owzb5yaTtHN28mEHY/GoXPIELi7+NYoJmsSYSDckigs3PqM5IRub9J5Q0UBURFj275katR6zSHU6rNGqrUbut09m1I9JmylEAHZqyezx9Qx5Q+sFmxiX0BXEhX14dwgDa6/4mra556GRy3XI6+Fnal4Rk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DaP5neQX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Uon9JxBZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DaP5neQX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Uon9JxBZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAfTNw359637;
	Wed, 25 Feb 2026 15:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=G4Sf6yc5W1T0n/9iZu+8F9oVdelCLpuyvOHSapPJDHI=; b=
	DaP5neQXtQuDbGHtZ4iT4VnKbAQsJN5/nUfXRSrQtqLCegKY6JraUCJm50Iad9RB
	KoAnRfEi5pJ2B5MT9yBCkf4sdcGM8SD5jDDQY862DtcD9UVaxaZdtkas6rU2NrZ4
	VqgEM/UTbJ4f7aa2dYUI84n5yk+I2Eg5DWxq0501l6X7NijCrHKb3Ao2tfCKmi2/
	jLSbVwrNCHMI6IiKUoPeUjAXH3CcHDxHh0/jlkY8N58Y4XXFi9svqHN8D4RqM5qT
	XuDk0sfIClcDXL3CnS+AHrDLjsN0vqeJai8XUUh457ikEa1a9uSKKDsWISl1hZTP
	glhHuT5YXwxuGCPZ6qbwJg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7xfj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PExug1006258;
	Wed, 25 Feb 2026 15:37:33 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010010.outbound.protection.outlook.com [52.101.193.10])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9u1-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vu2K/KGicDy8Aac0XMTo9V9o1rZNSkTVivK9whci1j4fWkaRXR/KCU2HA/Npm6vODmUxUUJIYf7VijAAPab/v76+8tv5w2ITiHAaKN7k3WCitT5raN6SYwxBO2Hxazg2nYglCEbUuwo2iWOg9MFaOOnc8ezd7ch5nLRBhP8K0hjfvshOwN9CO6OhELkqMs/tKmHvsKUCjJQcyCKyVM9WfjtXGZs0D2yrZZ3x8iEC4z9KKdWdISZmFT+jd0KeI79kFK28eSOiwF6epYQlvu4k8lbwzSkA5ibq6JutOH1AGjHqNACWX6osTL49nFPmjuIMgcQIyepUyRNUl42o3xyCjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4Sf6yc5W1T0n/9iZu+8F9oVdelCLpuyvOHSapPJDHI=;
 b=OKhlgBwxTxEFoJzETMe8ai8Smy6kMgvJyj6z/EFafQvHZ3eZoZYUMaWIDFUeLJ0+4n5Rr8kixyioy+sY/G/jLAvJ6uli6JUg8ambbdxf73TY6K6PpBKuFLfIqM3pB0AfrmqewRZjAqzh4ItOxeQH0Ec1E0hNhq9nBUEKOPTSVEaMeSyQTesGdVrkDM0c7myFPKlZoyUNI20pumf4oiOKK7J/lIhbqzqznMIPcSimoWv3NoLgiZF4fEzjavh8vE1dx5IlAKfGOl/R7S67I/7zNVUC6G4/Gp9+8pyVavWLhnNiuXGn/j7KYkZVZPf1Rqe+B63hL4cilDJRbntcVvQEMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4Sf6yc5W1T0n/9iZu+8F9oVdelCLpuyvOHSapPJDHI=;
 b=Uon9JxBZNK16CKzrWbQ1wiKDY2qoQeLq3uCM2O+LYeaUJx5AK95GEoy+ZyOqpfYTyqj4aI6nVbMJ6ClBkZyX/vkv7pXtD8FR93kutESYD7pNY6UEjP7CW3AJE9ymMCvZut4mOEyAHG4WPKz8F4zu3bToTKaysajBZEMKbT5MQeA=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN2PR10MB4285.namprd10.prod.outlook.com
 (2603:10b6:208:198::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:28 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 22/24] scsi: sd: add mpath_dev file
Date: Wed, 25 Feb 2026 15:36:25 +0000
Message-ID: <20260225153627.1032500-23-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:510:33d::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN2PR10MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: ec7c243d-bc33-498f-e46d-08de7483c871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	YQwHLruJS8HJJhWxM0xNK1FwS6EuuXUUeGayzAR623m8BbWBTZQCQkW+6IPIzBKUNhBQUM/pEAa72iUxSEjlQr6y/tvuQMXiDUj17vG6UCnmRzYMA5/X7WCATsg0KKscaCj8iqlK8E2vHihgYA0UdpccEQE5Z3wnPmJCAnYyBT5xIms3FcV+oHDmIX6HX+TZTWWXQRCyv2IZeMrlPtGJfJNIFo2CBsml2P53Amad9mCA9wMR/SimKsbzt9y0x1HxxHeIIiyLMWINUsbdayZ0eJlHTbryox5HK1pI01BMh1w8hjpPPEL/HzDZCI+slL3lE7356aH5gA8jdR0cwPHlWhPLzY+DkD29nU6txN6FjtOJpOVbbksZ+lrAD9VHaqBQQ5L761teBCHo+heDiXvVnC/S3JfxGhcvmVVqdDAz570b/TiwYEQISxUWGgrdWcHqk6j4APEUE+aQaRwVD7iKPQfMBbS4KQWcRvkBOrHkd+EvgMyV31rAhbPNjIyWSMpQkBdC9oB96nWqpTzkFHVrHx+EdcEuyL0cj3P5ZVNASOIZ1p19VblDIJRf1D27SXWdd1dpAPPpMmyo1eeDXgnBFMUB6hyw46Zw6Ooj+9ktVFMtJyL1IUOjgU0JTSQF+sD3tP+0apYbh0lng8C1RHkpRLXVSFUNNnMiJ83KpazK6TmkISYn9skiQbqDjhtvotJhRdq84vmvPLQMavyW/MXFuLFg+a1Ev/Zz6ITz8vdndxA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sqyt/TXF7/qoItnkytjE6TJaTzynSB1igzcWIhHVQkkpGALQNeTxXGxuj07m?=
 =?us-ascii?Q?lCR+RQqeG6wQl2O2GxDOEDDafg9HuX53wy/xAolmS0edZpyjQ9Kq2lLnQRD7?=
 =?us-ascii?Q?7n3/2G+Ji2134ghjLkjPpSdQYw9TERxXJ7zg6HVyAdrbizhDomV5YKMhMBfc?=
 =?us-ascii?Q?qSyVn0bfNdwvGDpkm+ppzcC7CwTMt1dMQzb1GqjSP8WzblEs+N54j0JJiuVR?=
 =?us-ascii?Q?es2KRAiUWzZ9YWUtQnSpIkmwm54RXE/3bvjW8YGXNG0+eXnvcJzZl/SF3y5C?=
 =?us-ascii?Q?GX5FKsMel0lNWEKgD1oiVO4U9PC74d/RiaSAZzRcnQaHvu4LzidoKwxHN3KN?=
 =?us-ascii?Q?eFDmBaA1BRUkaM4DVRGJWgm1gBH51NWb9bnpzhV4gUtW2klZ2ihpzxqFy7Ea?=
 =?us-ascii?Q?XBO1oUuJK0+XuuD3Nxd5ejG7biGUHZ+VXoS9QW7jMxkr3M0E5L6c8gW75B8N?=
 =?us-ascii?Q?59+DsJwVhviYhEC1kvM15sIgDyLcz2HiIqrtAUwzcjAqN7eMvk/AShj1hEzM?=
 =?us-ascii?Q?4eYX+eVoNe9DtrWovcXHWWTTK6E2mubvWdW0/sPg7eoD4qO++9DuEcxqqDBx?=
 =?us-ascii?Q?ChdXp0uSJ5M0e3+o9PkohhFBWLPG7dDjGxF6q4AwdyMQSPUgjEo/o66Fi51R?=
 =?us-ascii?Q?jw64/VCPE5UJGzm6z71D688lFrT+BamcTtUSZqT/VbzMs+7b1FDkiGV366jc?=
 =?us-ascii?Q?oZQaALmdTtqsJEqA/Gwcb5ISIQGPSNKqubP7uvnft5At22MiMC9L1V0m8o8Y?=
 =?us-ascii?Q?YicRrshW+UxtJaYvHMBKi47amT0VegKrfFPj/EBuk2s+pddvRJFLlK4tgEVa?=
 =?us-ascii?Q?+lGJtDwZgF5jTX2LqAim+pAV5asvIaqABhsZQiLgSe2X1/YOSQYzBk/kI6Jl?=
 =?us-ascii?Q?M7BN387H3mWDlBrrelt2bBqUKuoGdC7G6v18mC9ZsbRsydHNvVm5eTZ44uWu?=
 =?us-ascii?Q?42WZNtutKfG5xQ85XAGrA9lzQ9AyrLUGelzqyvIxUkiwP3831zKBkLIO0UMp?=
 =?us-ascii?Q?6EcPZNiq5VHfnafZ/IH303Ehfp+ihIXMqaiwMzyx5xmrY2W9Ou3Icz6Sy0gL?=
 =?us-ascii?Q?EO4VWfQ8OXd4sQhXH485d43On12fpqnOPr4QTFVK2EGTQ61aOctkHyNdB3aU?=
 =?us-ascii?Q?Qv7BbTGercD139A27EXQR62TA69mCs2Oc5eK6jcg3fFoSErcVO7wtyFJ5pMo?=
 =?us-ascii?Q?KWnIuQWOb8iGFllnwGVvxLtAiP+J+ixcESHCagl72vHfCMo66VUFmdLJEJlM?=
 =?us-ascii?Q?pNrjCg9Gmv8q0I6CJYYH673qSqXoz58wMuS86GJXnd+M4EcYkegJMkhv7LFt?=
 =?us-ascii?Q?pRAEYoF5DvIDdEZaqE6NGgpqlyN9Vadv6bdReYDAgFSCGJpHFAdRFEJBlxaY?=
 =?us-ascii?Q?wuHTr/6oUO27C2CLB0hrUsvU1fs3zAsE110Hd7oP/H0HeInsx5LrGRmWtr56?=
 =?us-ascii?Q?5HEJgvkKvlsPrCJwyiBP0rNMpCPU8GbVCc326u5NVhHTvRN4CW8ye24Hkr1k?=
 =?us-ascii?Q?7EBlOiswH4SNMwSyLtWPOe8D3sgc3PjDCBcJo7O2dtz6MMQVFJCkevCtuK6S?=
 =?us-ascii?Q?KYPR8fQbeWjTQhYt7Gpc7AEZcK4NkHV3UsTl5KwpdruR21DleuYlEkXX/mJj?=
 =?us-ascii?Q?IIhjneG9oNxYmTyA/jmdDeurYhKfwgHl3ZCsfNVJk/otoszkgTDnSZx3o53W?=
 =?us-ascii?Q?HOt0B1UL1mB8I702FT1WVz82wgOW92GXQzHMV0APO+KPUmaFYMQI/rkfXdyC?=
 =?us-ascii?Q?FkJMxRzNlyZR3iNRkwPG5zrEsmul6hY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yMTYrxDHo55SmA2X8MX68AI2grU7aaD57r6Nudum7glf6RaQD+xivgQIvb/4UMQ41aynqsu1ZLh4ApWSFJwINZ0V/uKscY2khQ/EhULSkMGsf9GWKwzJ6xdIdJS8wWt+uqv/asEW2lKyQLdTVTsjcqAVoGDS9YzaOJ2Ec6Dxve5JpfYEtpHehh+Wr3/ARSbo1mdKPIDRNH7BmYRlisIDWZIGWE+OY4Xc7fKNFVA0vmN9cvcO7bWb+haatXhAGJZyGkpA8LectTOFCAW/HykgLX5JW+epRD8qTaL/YLZFHu0e6zl+pU5tGWEjj8BPs9TarVPVk+7mwWxSxqsYigr03HPMv3JewqjAkDoqYNTJOM1kYVjOnrXiG1ifaYkNRNJr9+KgCSTimwf3KKgmp0Pc3mRskro76Hprq3ss3NmLS9O6UuR03Bm00Fw782fq4rA/maVuallMESaxManX45gnCxoSEZ0j8uH/xDo5Sk4oDUZ90R4q6dia7iyMeNjjDhweQizSzsUuPIvYWajUmwagK8V1ojJSG4TicluCjmmnDfkpEBySPNHBHMxX138z8yibpwB183871/CCnu9VpZAricNNeGdtO//K10a5ZSSmrMw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec7c243d-bc33-498f-e46d-08de7483c871
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:28.7406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4GOvMl49LVjdU4u4z8wYHYpDkbSklkld+ZkylO0AlB1PbDfRgZycuFulZUHglFA/VcMMY0oGUhKuDZx0eb54A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699f173e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=CHiAKCXa_bqUvZA3_qwA:9
X-Proofpoint-GUID: 1dHNo4Z_7iOOe1y20_OyfyRrg4p90hTD
X-Proofpoint-ORIG-GUID: 1dHNo4Z_7iOOe1y20_OyfyRrg4p90hTD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX8Pngb3Se+3f6
 kmbbLx6q/wk/jeUqj/V2qRaORMXHq7vsaUHnvJt9g/cbtDUUzzmARfPL4DAeqOjc2AYsIsqEg/S
 4y2/13yMZkuMDFevE+IMGIFzlUb6DA1PvGmQfAJvu6+XtoceW4H3nA0t6K3s32srCYapu+rnBc6
 MVuzz++YOzOX2GzSgmwzNvGfsfMd9ZMjbfbuFo1bwkDP+tI5W49Jj0jM0BRtOwH0YsUJQmjP/q0
 VJYO6hnw2Zne4hi2VOw6QH1tjLy5i2kkmOld5Ro4EafDbZFs4qapdQ6/7Zu5fmZoX/m+axOZ8tj
 RXP9WbEpfhy6unjKhsHqh3X4U2nFB/uCAKq+devk7crQqaDPcbgzZNATRSHVt1Db2qB5jf3KY6j
 oM+NCbQLzFr3DCMRScpcr9n1uTY/uUBnQm1ZgoPWt7wB2zeLATb5ZB4VYoFgKkzQAaOM1cRtjpj
 sJqqMQpb9oKPJMpXpig==

Add a mpath_dev file so that the multipath disk can be looked up from
per-path gendisk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_device is missing.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 409c0937764d9..f5922a9fe6c1b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4198,6 +4198,51 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
 
 	return ret;
 }
+
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
+	struct gendisk *disk = mpath_disk->disk;
+	struct device *disk_dev = disk_to_dev(disk);
+
+	return print_dev_t(page, disk_dev->devt);
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
 {
 	if (!get_device(&sd_mpath_disk->dev))
@@ -4461,6 +4506,8 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
 static void sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 /**
  *	sd_probe - called during driver initialization and whenever a
@@ -4602,7 +4649,7 @@ static int sd_probe(struct device *dev)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.5

