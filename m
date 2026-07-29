Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D74470453;
	Wed, 29 Jul 2026 10:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322351; cv=fail; b=P06GZvIimKIYCdSpj7gPJIOKnMZC5rMZaBkWbE3sSWoi6aXPiFwKsq1VWZHvHJW856hrVvuYJJ7qWkLmu1bFGinZUEq3tTux5Jzd/EqgSL9S4vPeCFYqEyl5Frim0peWL7FdscYA63/DfUNjb2ADUzE4eRzJNaw4Pux6ZOQyg3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322351; c=relaxed/simple;
	bh=aO9kgBy552uvTkQ+RFyqX/AEybKZd+JRJBty8Xz0ezM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gJqqwppZYsKA9yi7tVW4wsGQOWs39rQx+oAu2J/y3L/ZpXzUh2IlAGVtIoKKypuzv1G7smSVqnwt1Ph1WE+3+B8gLCcFb4EuWpgKIsVPzOaQ6BrIVx+qBPeL29r8aXOq/scul+aXd5QdUk8SEPw9OFNHHoqgCzxxkp5LOeyf3Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H+s1sTA5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fIJcQ8AI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H+s1sTA5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fIJcQ8AI"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T2HLJa2045180;
	Wed, 29 Jul 2026 10:51:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6Krj2OwJohLba803uhX5wIIkXynolpVDP/6dU5TdYZo=; b=
	H+s1sTA5msReAKCMNYGzUe967h9MoW2y6qiDpMnoIjgpv19rJCIiQf5shtnwTT8E
	c1EHTdq9GvwX5+UNbIzBryokz1nOvMPG2/q7pwdORMsoheK2rNM7mzgQof7XeFfk
	WVSwQn4aKE12pJEPtwApU/cYRmYBzPN3PQbAA4SQ+E30B5IXeg1PZMDVhjE94+tZ
	y/UwAbEk13dxnPto1yoJcKBGtSDmpyQXbfJZA9j+zmrwaVZy5yiQRVgEPs8/1uuk
	xsZ7DcVfDoTnbLLkYdG+XP5QoUT6W4ItsHGvgPBC2sw39PYFOGq0zSeXPqKrEjO8
	AQKM6LlFzi1eUW4eb93CKw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pnmxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAoX1j004914;
	Wed, 29 Jul 2026 10:51:43 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011005.outbound.protection.outlook.com [52.101.57.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6dt96k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y03TLc+irNY8nJfPrfSlFVePXGRxKXOZJwsvDGiTRQRi07FKYRLGaBtl7ED/GkWLqCz8XzZrRQEgUIYJ9nWZBvo3ySBPFDZebY1aEg4239OAPZxXNV+7DR/h1I1g0tJl3DcUK7NWujaV2st/OC9qD+XDT1QjMl+i9nNfpUXpurzR++qXFopxgPa33ICSh/UVSx4p6nX6sEhZGb6WrOLF32040wCCcOvhpLECJL8bFeqwSJdNDzeSIfFDexut2vxGYKZioyRr9J8opEhWd8fyVOpV8VNFW7apCjWQr0kh2Ol2dyLXzc6veiWUhmUp9gvB0Hp/lGq39hBeQu3Olhhgcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Krj2OwJohLba803uhX5wIIkXynolpVDP/6dU5TdYZo=;
 b=LjnTxrmeN7GVVJdCuQqc26IzjNqXcZVAOnfTmDjbFvNpFScrPkFN49bfGNFkxjZN8RJWPjjWUss6q7TMHlgv1ImHziFRk1IXSl3befqjlKF8VvT9PTiHBZ9Itbx70yMkiAmoHmpi7uq3wDzGAd8IlXDdYMj+I+ZEIre0M1Ywx2kmn3vtk4i2cednvXlKmi3E6TsQVUFfOimCQe+8icl7fcc4UEaUguP6KrokY0fufaVtT9gNpAKXFJo9jlN1dLdU8bq68FECkr3OjATJKzh36SO6J8HoWzt+Vt36HqtNwAEYnmd6FfWKi11/UhC88DPwoB03O5qOkjgIo7xR8vjGbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Krj2OwJohLba803uhX5wIIkXynolpVDP/6dU5TdYZo=;
 b=fIJcQ8AIAMAoBXPQQUC0IMqUEy97q5UxOeeFWLoDOr3/mXPy8NOvbXlN7TFJ24B8KAaKf+pFZhiuzhZFgCKuRsDpkMqKy+l8BwU4QB9ada1DYVGFJK/C2RLB+ovW0/+/hQ8lePwYbanPVvpONEnd6SZ5KLyxJ5ZSkROkjx8hEww=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:40 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 03/27] libmultipath: Add path selection support
Date: Wed, 29 Jul 2026 10:50:43 +0000
Message-ID: <20260729105107.255712-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH3P221CA0010.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1e7::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 02fdbbb2-2890-4128-8520-08deed5f5ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	b2bap6pzS2ov8XtUKFSfHTwPu6olNFATt9UkRtTTlqWMrpaNTLwIQo5bKWYoHvQ9KGobzMTHYeX0sNcpbK5s4NP1s0UmzjKBh2f/aqrWNpjnPIMzX50guYfAY5zsVFqCpkxfl14ouA4zWbVQWXE3D1hFL8y3mu6EGpPIBMqKan8fsxq7x3/5IklCacaitDQP0pbDnEFlmGPByOSg9+CCkt1ZVmFSQA+6fdz6ABwnkx8bR1NAPxMe9zZrDEhYWBflh9YbAAWTq7ZRTEFuqHYUFP2Xa9xoJK7tAzjt9GXBkKJ4dxiI9FaBG4jmfI19DdDDcqg/MpA/rvUvI8qWm8Cnyr8HzEb8dboU1drAthZ6GBf3GtzKAPv0wQMd+J7rGpmO0HcFiyXVUkU2qxlYDNpgjO9BYqQboSynp0HJIm7qq2z3/WBu6nkk7eDhJbo1j40y8F/p1PbJXsInx9mjTBYAbrXQmYLI6YIHmtA5Uyh8ibC8pTe8PTZFhOWRPDCdyumFDof+m6sCVRjQ05DRXIkj9ITsJsqy86Y09JbzKpL42WtmuD/r7kfxSkweUFxP7P3PXdOE4swRGIJHW5N0rWDnlClZ8fLYu1nkanj72VAcwHfgMdA741spykmYYpsTZTiXhjrKjQYuNX8aqjS7LOqqbfYZN+8kDYx/ZliVLd7tvZU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tCOWAJ7thNIqf7fPqEb892CpthVeqst0WIfhu1eP4U9hI0K3vTQaMjzEZ/xw?=
 =?us-ascii?Q?tNjxoYkK2HYqeTfP4EYjuN56LfJgSx/3Zg9AsKF/ZODrNhLLh1fBJZDAx/Wb?=
 =?us-ascii?Q?zs05mDbFIadGan3QYakI8bM2lNnpSPJJE6ip9tnQKXf9UI7fmM7cEqa13WJW?=
 =?us-ascii?Q?g5UzxNBANbwjzL0nUujGflH9EOVtln2CuQApyKJnorzuAHg9BFgOGMgxMsLT?=
 =?us-ascii?Q?xjy7VGwXkha/wj76GxdmmmqyROEpCqzQCYJrYkQcRvhEpSD227y4vFoe+Jxb?=
 =?us-ascii?Q?GqLSiayRq6OobLOIUVCTWQNQri+CVEfQ9jsrywAEdr3kzPt5NznFtV34GklA?=
 =?us-ascii?Q?zCf4bBw1Yj+pAAbnbZ6nxQv4vAz3EgkrBmwWqoKTXK7In7MTsjsXRLIobwZr?=
 =?us-ascii?Q?kQHcvlBozOEnF1LC8t4XlUXjaAN2/nsUTS/YfCYxlTAygNh4lWKoZxDh6Jey?=
 =?us-ascii?Q?ofbiNdOr0icklHuVy5rXbkUegRXV3NVVpmEDaJV5bWiC9A6lxIEWWPi+rJkM?=
 =?us-ascii?Q?ag5GMX4AQjJFsvbKrLfWo1v17PPeJTf3eaMtiKB5CfRfZVzm6DJW2tEQ7e2d?=
 =?us-ascii?Q?w1GXyN8cz/nN5iOUrir4TU/nLuuh7MriT1HtHboBj1VRYakqgNoCe3hG/lIj?=
 =?us-ascii?Q?Lg//3Xzpctqilf0JI8HUuC5Adq2XJ2lcI2t59k9FJWc4SBPyIRbjA3//xd5F?=
 =?us-ascii?Q?crJQ1+TvEXeyEyjY56R5H1SuiVM6wNrWMNaksEA6Mz6VffzB8NZYBx3W04Ph?=
 =?us-ascii?Q?2Jd/XIyUnVr1SrL4gCNHooCHO+jL/EJ0C9FNa74/ortzSzrfSbpbJ/HTFoji?=
 =?us-ascii?Q?aP69fp12/Gc2PjGWGxnvvWAdOLcHt9uHUcJznIb6EUJtvWU5VtQyH3VhGSI6?=
 =?us-ascii?Q?H8FOf7jmKgeV73g4mffJUz2rZcoAS6AmtKPI8F8gCQFTDDm21/gKOZ8l309j?=
 =?us-ascii?Q?hqSWJH9d6pLypiSDlZVUTg1iJP3EqDjfF8InB6l+d6vVRNn4Sm6+hCBTVCk4?=
 =?us-ascii?Q?5TNjlvkFPdyl0y33ox7OnZ3O8sp2ZtOHD+vP58IGf+4MJ2zH0zK/1/Vwz/9t?=
 =?us-ascii?Q?A/rqqvyYjiSYz7jxB3LeG5UM/YN9cakCZ+aZ8CIrsy1DKQJsGEihH9HU1tvy?=
 =?us-ascii?Q?JVMaVD6/Qi9oSgQX27c5Fd2OE4Y24zRQvnMd2rthJFs1l6HGk1vPhvplNOmE?=
 =?us-ascii?Q?wqlMhECAF/Blf17kWXpP0RSWqqMg3P1pGl+o3n+Xfm11PcylMElr5TniPByv?=
 =?us-ascii?Q?eNVPYe+I84tbSBQx1ktcZgiJsd3D5FMLdEKeWflDXwAsYTWEi7+UrWNBWmox?=
 =?us-ascii?Q?myibtPDKz00ot3iJbo+4dhE7nLgCeGyfhE2m/pdiQwSDczytrthWy10w/vmP?=
 =?us-ascii?Q?yOrxYImtpTV3ZqhqKF0c4o0wOfq1jHZndsqxLda5kybwqJYQaV0X5MjrP7iz?=
 =?us-ascii?Q?gqh8BQtS3DEAG2qRWhcOzoG2HKwNsXRYId20NdMh2v0VJe09x/zYNEi+HIIO?=
 =?us-ascii?Q?Pwcf0VKxPvnsAWiK9D8ALIV8rX4lzbM+bC6OvZEFU3wuUn/8KSgUaWF/DtpD?=
 =?us-ascii?Q?HpvQQ9Qi+Aibo2tbQJxokmg6whoJUPFwVLPJ3kQ/t7g56KgVlRjkx5+p/4IQ?=
 =?us-ascii?Q?2MN5EX1VFC0xv3lXMh1McAh41L7yTv6eJPOlF9iHE8IsS9B5RzgT9zb8a1Qe?=
 =?us-ascii?Q?zDA4HQthOZmh6cKEvCxARGOIiEaKvMTJaBOjBMPjPpRWbGtQWp7vBkikEWi5?=
 =?us-ascii?Q?1+LRsjbJgYzLwyTWlOzkYS327xlMDNw=3D?=
X-Exchange-RoutingPolicyChecked:
	PQfkJh2IRwm+tSiAdBxz+zUlrwUdMIZEjbt578ADw9G0EoyXfuAllNQGh2eFW5zjOla8sPZJf2i4RapXwEzgWWB/QNRpY1SbHx4GmkZ2O2qFbXZcaI7vEWCEDpY8j3kpNx8a1WavB6uaBS5pKzGIf3a3JAcH8B1VPlDeGMnAzApVq2YGJidj8VS2GR3wo3BfaHqAcoaNHyNsh0j+0dS9keqSv0V7ksOo637uAHfR/8wyK1it0zb12V9Yt3gVpS7pVFRKrnPYhGZvVid7ZbzEL/7hW1F10JbZ53atFuJi/JEks26OP8NcrBC8BoXrUgv0QpQH7Hnpmh5QgCbZ8tmhGw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YDI/BrtoV5VdYRbRaGP7xsZSTVSJoLnbltfsmKj2uUxvIX86QnK3U1NHomhHBaZ55pBh6Vrmrwt3xOeRsH6WBdegWtGXIfZzOuis9+QVeW8Me0gQWbWv9HMEoPy+RnLLMJZfXXz6mzf2BkawbuAMlrIDa5Ehua7kezYO4sq7G1FwkpdzwcaQCfxXHI/6tGnWsijvjiR3C45KmFGp9F04o5FPPdLOXvvtn/QfEyhpWHLJmCz3v4ujRVqRk7zJ+U6UiOvcNNkIW0BdN32nqPw1llDWGGu5stOPXszX3vnDpJIiqUhQeJ4UBZDpNt/nRj3VKNAWGE2yBiHGT8k1XaZmgooInZvfj2+CzrGFv30c0/pxz7FiPj2WGfD5X/OjN5QUo3AqEkBlFDMBnKCGK0WbnlchyiitMhzMJIUixCPLpnK5elNsY9MIzsG2kirLn9tSIvXWXurDgmBGWTIpLsa/O/ogPW5nEQawk7mrnfpqlJ9Gxq8/oicqp1zcEWl3vSeOYf8/nyJp5F88fKymnvSxbToHZfmKyytJiCHR8YFWjILc7/0Y04LV2iyQWH2YmHCMPsp44B8y7OVHHMo8719NhNmD419kJ8zjFA6nF/glUrA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02fdbbb2-2890-4128-8520-08deed5f5ead
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:40.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5vo+yAqYkkoPTPdoEpiWuS5vUrB7g8HUZIyTRMHh4obutaAtzSE+M0YU9RherNwz3Y1/CmzUvwLNXNXn1EMrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-GUID: mjBbexvNbDryytDttu2SL4LFw0H03B3l
X-Proofpoint-ORIG-GUID: mjBbexvNbDryytDttu2SL4LFw0H03B3l
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a69db40 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=Lb5UtHSxAhypNmDEWQsA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX+IlhhhJxnLTu
 suYum8OplddyF+SvUtKNZWZLOY+qFcgiYsjHF+DC0Jbo+6HZoIDqbLjzaCkD/MWPSp9EDcAQycw
 y/uyYo5UZx2nKQ/CVxYmaIR0hbqTlLSUfdOJsprJ5AWl2gKOSZcD0Ov6GlMWPWDZqxbGbWgN1TR
 SuYgWhydkfZqlNSFmnS/+dqTOgDoaIfkqubqSHZ+LrADqgoYrcAK5JogK8LXUyz3JG/Q/nhb4Xh
 TrDsK9PDRZkUVIymF+vaiayT2gIcu+TWqEppd8ewKBgIZ82YG+HtIbrxf8NU19f2VVMPNJNub/x
 lSU+33SFVSw/XEgOWAcorKmDGaL7Lmu3xTg+Gx4PRStTfH2VTVMZ6/KWW8IkjIoLfraCvT+76vm
 27y5rQz6mDfa2SRlvFRY7Ninu5O6hZ/Xqjavy0B9pmwuFPkSZFNo4rIrphwiHwQyqgSvIuXwtdV
 YrZRVei0hpzCjfpmPaKyDoeC1owV7OhJ/OkcCjQE=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX7cG4w0E8K/Rk
 XH8Q+j6vef0UV63I7WmGfymeahJsn39KnogJm0jKHsz55nd1PTi/tp/zgEoJF/z+a976BdEgOPA
 xyUeVZPEbCKQdc0QRxNGlI/KZ+H+lLzxShKof3ozZRc+13flG4U9

From: John Garry <john.garry@linux.dev>

Add code for path selection.

NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
so that SCSI ALUA can be used. Callbacks .is_disabled and .is_optimized
are added to get the path access state.

Path selection modes round-robin, NUMA, and queue-depth are added, same
as NVMe supports.

NVMe has almost like-for-like equivalents here:
- __mpath_find_path() -> __nvme_find_path()
- mpath_find_path() -> nvme_find_path()

and similar for all introduced callee functions.

Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
setting default iopolicy.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  33 +++++
 lib/multipath.c           | 253 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 285 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index ca6e02505be43..9bbab0aa8961a 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,13 +7,31 @@
 
 extern const struct block_device_operations mpath_ops;
 
+enum mpath_iopolicy_e {
+	MPATH_IOPOLICY_NUMA,
+	MPATH_IOPOLICY_RR,
+	MPATH_IOPOLICY_QD,
+};
+
+enum mpath_access_state {
+	MPATH_STATE_OPTIMIZED,
+	MPATH_STATE_NONOPTIMIZED,
+	MPATH_STATE_OTHER
+};
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	int			numa_node;
+	atomic_t		*nr_active;
+	enum mpath_access_state access_state;
 };
 
 struct mpath_head_template {
+	bool (*is_disabled)(struct mpath_device *);
+	bool (*is_optimized)(struct mpath_device *);
+	const struct attribute_group **device_groups;
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
@@ -25,6 +43,7 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	enum mpath_iopolicy_e	*iopolicy;
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -44,6 +63,14 @@ static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
 	return mpath_bd_device_to_head(disk_to_dev(disk));
 }
 
+static inline enum mpath_iopolicy_e mpath_read_iopolicy(
+			struct mpath_head *mpath_head)
+{
+	return READ_ONCE(*mpath_head->iopolicy);
+}
+void mpath_synchronize(struct mpath_head *mpath_head);
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
+int mpath_get_iopolicy(char *buf, int iopolicy);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
@@ -63,4 +90,10 @@ static inline bool is_mpath_disk(struct gendisk *disk)
 	return false;
 	#endif
 }
+
+static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
+{
+	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
+}
+
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 1cf20b0f62d07..26714116023a3 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -7,8 +7,245 @@
 #include <linux/multipath.h>
 #include <linux/wait_bit.h>
 
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
+
 static struct workqueue_struct *mpath_wq;
 
+static const char * const mpath_iopolicy_names[] = {
+	[MPATH_IOPOLICY_NUMA]	= "numa",
+	[MPATH_IOPOLICY_RR]	= "round-robin",
+	[MPATH_IOPOLICY_QD]	= "queue-depth",
+};
+
+static int mpath_iopolicy_parse(const char *str)
+{
+	return __sysfs_match_string(mpath_iopolicy_names,
+		ARRAY_SIZE(mpath_iopolicy_names), str);
+}
+
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy)
+{
+	int policy;
+
+	if (!str)
+		return -EINVAL;
+	policy = mpath_iopolicy_parse(str);
+	if (policy < 0)
+		return policy;
+	WRITE_ONCE(*iopolicy, policy);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_set_iopolicy);
+
+int mpath_get_iopolicy(char *buf, int iopolicy)
+{
+	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
+}
+EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
+
+
+void mpath_synchronize(struct mpath_head *mpath_head)
+{
+	synchronize_srcu(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_synchronize);
+
+static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_disabled(mpath_device);
+}
+
+static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
+					int node)
+{
+	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
+	struct mpath_device *found = NULL, *fallback = NULL, *mpath_device;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+		srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		if (mpath_device->numa_node != NUMA_NO_NODE &&
+		    (mpath_read_iopolicy(mpath_head) ==
+			MPATH_IOPOLICY_NUMA))
+			distance = node_distance(node,
+					mpath_device->numa_node);
+		else
+			distance = LOCAL_DISTANCE;
+
+		switch(mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+		    if (distance < found_distance) {
+			    found_distance = distance;
+			    found = mpath_device;
+		    }
+		    break;
+		case MPATH_STATE_NONOPTIMIZED:
+		    if (distance < fallback_distance) {
+			    fallback_distance = distance;
+			    fallback = mpath_device;
+		    }
+		    break;
+		default:
+		    break;
+		}
+	}
+
+	if (!found)
+		found = fallback;
+
+	if (found)
+		rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_next_dev(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_dev)
+{
+	mpath_dev = list_next_or_null_rcu(&mpath_head->dev_list,
+			&mpath_dev->siblings, struct mpath_device,
+			siblings);
+
+	if (mpath_dev)
+		return mpath_dev;
+	return list_first_or_null_rcu(&mpath_head->dev_list,
+				struct mpath_device, siblings);
+}
+
+static struct mpath_device *mpath_round_robin_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device, *found = NULL;
+	int node = numa_node_id();
+	enum mpath_access_state access_state_old;
+	struct mpath_device *old =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+
+	if (unlikely(!old))
+		return __mpath_find_path(mpath_head, node);
+
+	if (list_is_singular(&mpath_head->dev_list)) {
+		if (mpath_path_is_disabled(mpath_head, old))
+			return NULL;
+		return old;
+	}
+
+	for (mpath_device = mpath_next_dev(mpath_head, old);
+	    mpath_device && mpath_device != old;
+	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
+			found = mpath_device;
+			goto out;
+		}
+		if (mpath_device->access_state == MPATH_STATE_NONOPTIMIZED)
+			found = mpath_device;
+	}
+
+	/*
+	 * The loop above skips the current path for round-robin semantics.
+	 * Fall back to the current path if either:
+	 *  - no other optimized path found and current is optimized,
+	 *  - no other usable path found and current is usable.
+	 */
+	access_state_old = old->access_state;
+	if (!mpath_path_is_disabled(mpath_head, old) &&
+	    (access_state_old == MPATH_STATE_OPTIMIZED ||
+	    (!found && access_state_old == MPATH_STATE_NONOPTIMIZED)))
+		return old;
+
+	if (!found)
+		return NULL;
+out:
+	rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_queue_depth_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *best_opt = NULL, *mpath_device;
+	struct mpath_device *best_nonopt = NULL;
+	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
+	unsigned int depth;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		depth = atomic_read(mpath_device->nr_active);
+
+		switch (mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+			if (depth < min_depth_opt) {
+				min_depth_opt = depth;
+				best_opt = mpath_device;
+			}
+			break;
+		case MPATH_STATE_NONOPTIMIZED:
+			if (depth < min_depth_nonopt) {
+				min_depth_nonopt = depth;
+				best_nonopt = mpath_device;
+			}
+			break;
+		default:
+			break;
+		}
+
+		if (min_depth_opt == 0)
+			return best_opt;
+	}
+
+	return best_opt ? best_opt : best_nonopt;
+}
+
+static inline bool mpath_path_is_optimized(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_optimized(mpath_device);
+}
+
+static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
+{
+	int node = numa_node_id();
+	struct mpath_device *mpath_device;
+
+	mpath_device = srcu_dereference(mpath_head->current_path[node],
+					&mpath_head->srcu);
+	if (unlikely(!mpath_device))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(mpath_path_is_disabled(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	return mpath_device;
+}
+
+__maybe_unused
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
+{
+	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
+
+	switch (iopolicy) {
+	case MPATH_IOPOLICY_QD:
+		return mpath_queue_depth_path(mpath_head);
+	case MPATH_IOPOLICY_RR:
+		return mpath_round_robin_path(mpath_head);
+	default:
+		return mpath_numa_path(mpath_head);
+	}
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -76,6 +313,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
 }
@@ -99,7 +337,7 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	struct gendisk *disk;
 
 	if (!mpath_head->disk_groups || !mpath_head->parent ||
-	    mpath_head->disk)
+	     !mpath_head->iopolicy || mpath_head->disk)
 		return -EINVAL;
 
 	disk = blk_alloc_disk(lim, numa_node);
@@ -134,6 +372,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		}
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
+
+	mutex_lock(&mpath_head->lock);
+	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
+		int node, srcu_idx;
+
+		srcu_idx = srcu_read_lock(&mpath_head->srcu);
+		for_each_online_node(node)
+			__mpath_find_path(mpath_head, node);
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	}
+	mutex_unlock(&mpath_head->lock);
+
+	mpath_synchronize(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
-- 
2.43.7

