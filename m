Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B78047D459;
	Tue,  1 Sep 2026 10:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259619; cv=fail; b=cA8DUWVDr6mC0L3UepvrmDGdwnm3GB6KM+fMHODg743TutP8vFD38pYjdUlahMtkBXoPisirYxjaD9YiTW1+8Sh0wbZKP1STrcbE8l2uXc3TEO1DYRJP8BWcb7GqMGhsBk6MUNfQUC5zuGc6lHMlHXzoSeXJFBFQqOIauAbBhpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259619; c=relaxed/simple;
	bh=QXxOQ/nO8Ht435FvRN/fOvrut7xEU8WYiIbtLI+vIK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wa725PJ4HsATOpITyM8Dkb5fyxcdwfM07VuNM6vhmsxebOGr9+yyHTGegILZWbzUia1UA5GvcofMKGF0ez1X7hdxILoPezZUuaeC57GPQBqi2o1ueoEyp0/qz+4/xO9GCAFGIKqemrGq678/iVDZcpGkQKsRIgBBeYt4UPrHqUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gDCC37y1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l52SSZOF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gDCC37y1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l52SSZOF"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLCZ262223243;
	Tue, 1 Sep 2026 10:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=X0gBDLSlke0GdEHQTf8F1pYN3sojJJ0mSHaUFYnqqLc=; b=
	gDCC37y1M0x10gRCQ3EXtpnpZnuyu8mum8gtU4Ib7gaK85c8AKHlywT5NGPGbySh
	gSaKE/UrJQUUv7wox2uqIlKrpT2JJ4WdjFvTIlq1v7W7x9zM9/bxQ5XcsPeoHEOS
	TNjsdORiyDw8K3GSZEgf82RY3JVrnBlb2Nud+nx+tTGPD2UqkXHRcRXgib1G9ck4
	sdxsSTC5JZtwnbkl7sGRWr1WdzaSLJGO3TyngdVM0XkF6xtIiuXksDGEuywaEsBq
	p7xAxg8pn8+3aWduI1UcAVhuGcVWoSZ2/Cdsh5tUBur5sTIXEDtm8GNUGQLiNwLy
	tQjdxDR+yyzo9Im/mAxH4w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqyrvbx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AYuBL040245;
	Tue, 1 Sep 2026 10:46:26 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve8n9d-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ebcj82dyO/N0/3vWJZN3E6S21w/MegF3C1FKuiJZiuSm8+cFpCyArsRyAOrxP0RyHE51wTTLNdjHdjd7Ib88GwQYhVYSKaxzbNm1OxLxbDOOAzjw5Eh5Q6v+Sgram1sEvYww7YmqVq3yoNixsMAoJuEksWmLcqy7YcxL0ojgCjWMhB/WzVHIToS403UkLv94tv/1mp1sPPvEHS0rpq81Mu7b2THW4Gr7BXjYlIYSwxdbR09IdiIfPMBIEN1oK1cTLyIUGsglkp2dmPGCWt3yMOVo+71nFCzBf6dmCR5IaqOL2UKzIl7cI0FyU1VRniGkwuu4hK355mQTKEhcauav4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0gBDLSlke0GdEHQTf8F1pYN3sojJJ0mSHaUFYnqqLc=;
 b=lXq9HecdjPeKhgDrfyq6xq2lEIHcLbrLrnnkzEMw2QWoGCpTOILtAEgU07VE4hIV5Ea3Bje5cfUUl5ihq/qdTSjYu16XOnWK6xBGkMHI4/S9zQHO3v5iOQjnLUJwXsqPLflqhOVqK3MGa2SI132wMShbSzhRPXuN1Swo+ar164f6kdNFkUPgZ7Gn4rSGoGji6DiTbxrLx8s2z3YvKWsP6nCGIIft31j9Y6wN+1g7uLP3wc7xyFTdrFSFPUqshC3B0MBFPAD9/8AzfRecgVwayArmxxvM1XUVnazZ5CUaQ8+rKvv6k6fM+3ThJ0A9e4x32p5zgDflRiXssCn/yE+7FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0gBDLSlke0GdEHQTf8F1pYN3sojJJ0mSHaUFYnqqLc=;
 b=l52SSZOFGlG/gPx5Ew/xsMskWTTXeWsGVqxKmIbHBOXvzD+urn6rQg4Dq8NhnTUqfAqIlkmlDDUlI2P+sO7k7fpliY4VkEY0CBk+pEkUn9PNVwZrWXRbhMwqTBXszlhIbWuqoAwtDeJbEqQnK/5awkgNC0k/jW5CzSbe2o+THjA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:20 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:20 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 21/27] scsi-multipath: add delayed disk removal support
Date: Tue,  1 Sep 2026 10:45:20 +0000
Message-ID: <20260901104526.3850621-22-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0043.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::28) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 728d1f4a-2928-4daf-8dc3-08df0816423d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	0vwb0+ewCOj7F6cWQCAdgYAAWTGwurtM4YyxhaHDJ6nZIxKzjQA7oXC8HdYspAjoxWBavKMBppZbJN3PyChgvIPtxncw/o/nSVcb68P6xJna4XNFjVn13am7tmPun6djTFkxoH6YFo10vMlUoH2kBUb8RBKaSQRbScIox7NsaEOx/rkHxt2kBE4GtFF0rYrDJQmBism6MiMvIt3GE2m7hUxtPvun+WE9bN0Ke5zD2/S5LriofnQUMH9vZiFUIZBIcOGn4M0jdvdkMF1OVV4PQ8gNAIx0hwqk1unvL6c+RhtoLScbk5ryFQP9iyHS4bx/51BCATrCjokMpnRPm7GjdawRFIlaipBvyh6aO9fUn/tlzRZmHLRE5Tfp5z9WQwB1Ie4EF45jqLGJ2STl6HqONRigNqBzKSPZqoa3SsNcESvQaeBLcEk/F96yhbljXcMAKUZkaQDuXZUQYKxRlc72CIwRiXFPMxWwL+OZSbcCASrkGAuY4UW4IAYe58sza9R2ReZFnWMyq38hIv3qNGjzZK0ayyv8EdS8w68dFznl4AxMOUGD72kmJdCVDV8ro/xbKN+i26XxW2xJdSYHgW5fNYf5N/Zes3LG4Yv1WNhXG58QQPXr9D2Qsv6psWhHOvEG/XhmokFbU4LX6wdRFjgtIapLpzM/RUykIG+2Sz9xOK0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jsXliB6TV5zCCOD3+A7zynvx63IPv1QOGG40kG7dCOrz3q9Pr8jKQ0WQqeEx?=
 =?us-ascii?Q?yCGZoeziDg7w7y+dh8DSHh2VGoPZXpNhlcqi1dvOc3ZlI7GnAnoHj18OTdag?=
 =?us-ascii?Q?NA8KHYHXSnTme3mo1J0k/4RwvvQ63N0ic4yDSoc1bXV4BVybnnJib5ftbWgr?=
 =?us-ascii?Q?e00qspltFwccEDcI2yuwyTkFtrYLWEXasq7JM2HcVBEaI+kuVxy4tdSdEN03?=
 =?us-ascii?Q?ikUpYVKmDZ87lw4Ou00EJaWd1S5IaoqeoKEb6yuJqAU4vgtSZ3hFDSBw1t5s?=
 =?us-ascii?Q?Y9OrdJ2/tsbTIHovNb/wknKYbCbS9+NQo6Cg0nQSmvlPu4zBeuNcljh5l3nX?=
 =?us-ascii?Q?6iWUmJppX3d6VWoDQJ/8SI2gzoQlxkuY/bFNM2zyyHf5JZsqVG3pY4D4iKdr?=
 =?us-ascii?Q?SzRKd0Jo7MTlxhqS8URwxO4VXKwvR41xRwEJKaCRBmjm/ha8M8b4BIPUL/4z?=
 =?us-ascii?Q?unWVddZHGncdzWMRZ07lGVrgppI2+Av91BE1wI+ws9PerdPJAyASGRDua16F?=
 =?us-ascii?Q?EGqO5T8xBSnhqa9DaYtwEQEmO1CHYfdPq8UbR8FUmdYwtnz17gDlClni9VDj?=
 =?us-ascii?Q?bMfUzYnpuJTJQ5GmLNEMP8KoVLAPsO0IYEjEyXmHEgvy25oLH97p/lWyj05b?=
 =?us-ascii?Q?OlUyJkL1NII4pLfupugmfuTzin9cIWkiOLgqtOD5zHDGLie3MOXkpWX66Sfk?=
 =?us-ascii?Q?aKqwsoUZUvvl8/alNl+ErD4fvjq8sFrVf98FaSKQHIvnA3kd8H3d8OtiZcDM?=
 =?us-ascii?Q?JZzNp4IU6zurQlz3Y0XUSLYeqs7BwRfH5A6zckoWAJGntWXXPFO3TrFd/R5+?=
 =?us-ascii?Q?SfpvIGv1MUNIE8YXXuttYOMx0WsjFABZ5TGDN3f2lUUemL3xcILOevFAOv/i?=
 =?us-ascii?Q?wcQZUo2yUyvLyB49ctGKwSmHeqNj+h0KzWWu5J25xykz48wKPJzDMLaoNk6F?=
 =?us-ascii?Q?uS8Z+Bwcp+LM5/YP62KdbCRXg+PJruilxIJ2nz3teIVYmOanHZW6Tg+Qj1ay?=
 =?us-ascii?Q?Zit2Y/CILwpL/C3ie6YvleiDZxk/FMiZ1YP0wmRaNBuPTFaqTXm9RCZA3i0X?=
 =?us-ascii?Q?2UJ376aBdagWSzIQmyVe43xfAS8XbqvzDDNWzbuW2tdCeVZfXgEdsnlwAGcX?=
 =?us-ascii?Q?kjdQtxwqFzaSi/LtIV0o4NDgpzEg59I1PPqzwsAFlCPcCrIbtnBz7McYVJZ5?=
 =?us-ascii?Q?U1urcRPLRPQd/AftKzsKAAyGiHuEQgPFmSt4RX1vL4fh5suuQWa+7kBTEMaH?=
 =?us-ascii?Q?+zU5HFys7fjwrxzqosfSZWh5uw29196X4lqLHzrrxtbGR3wjf7IDQxgHkZMz?=
 =?us-ascii?Q?CZjf/X1qXzPWOQaovDcJ1yGDQF5b7l834Oj3eKGGvjAjs8qgFD4xsVRdBH7J?=
 =?us-ascii?Q?RRS2wL5pexjrw6s64a0knCdMgbnU/x+Kcy68XARzoeWt2LUKpo8ToOoIepYb?=
 =?us-ascii?Q?hbgKHkLfEh6jcuyVJ/ySS28ttfBgEHH5Y5VGdLK1ioxT+7uF/WiAxZeXmdI4?=
 =?us-ascii?Q?gHYRI2mLjqlv9QdEvoGTxqZuiZdmrLrhXSBrM3ANl5x0mdTtjYkFNbTN1D3c?=
 =?us-ascii?Q?1GQKXTjBN+MxkIMkOqvNPwSaXP6IaFmnLi9CpYL9UTCVOYWFVl6hegaZnd+Z?=
 =?us-ascii?Q?282L47S1oO1Zu9LyrSPFvDpbbiDZmY4O2h1w0eSDkDCi2m0Ba6ziYehipP4J?=
 =?us-ascii?Q?GBnJT+rY+8+wMuwnqIItuZDDtuo4WTkMAiYuTgGl+eR+ZnRcsE3SVoJSKMAM?=
 =?us-ascii?Q?MHDyEusC1AMIu7UvvQ566YnGhe4FisU=3D?=
X-Exchange-RoutingPolicyChecked:
	QGb9STMTF4xMa5u6K/Bzk1s/DLsQbYkLUheDdI0qXBABpkSiQvuC6muqmGMw/X7y3ji0A1mSKgUCSbR6qzlLHO+54ykwLsoE+6zjI3kGDxUgI9R501YJBcbfsmukfSZOYI6FYGfrbuiMAXwPOJ1osAgw7Q7ybOde/78ObeCmXBicYCVg3V/3lHkZNSKgw6b/P6eBpLS+w3uG6bjZctx8QlnHpB6ljRcmgJYL+bkwzoKQBVdWPd9VZ2wdTrR9Df65y8MJKOZDdJiuZ43K8XVcYnc/YBkFI/fzJYr4zZqW7w0miqsOFJkFp1Ff2zM5RIHIxtX7af4lDqjggGXYnuZj6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6V6p8tNJJMFTeN5ieCnoLE73q1RZPn6Ow2K5BhQBYHD8Bfan2Xswl2ABsSkdSMhBCL5n1j3Qo08SVtoRFxH0+qgEnSgIJ/9ZzyjW0dT+IeJEUx4+nipNLwEd2AkSMWpm4xsTze9eq/pvUm5hCHEzwgE1wbIKl+ifltv/yIrqDZlFBcegXt00POi4C8ddSwKjKiBDoNhHdea1sJFfeoaRQZoYc8ZT208iq2DHKdKn1vcWXjLVKDzRqyGeiTXBZWo2uFyzCTpMoD90IEtCAJ8j7T/3y/98NHSqV6Ye6Q89pqSd5/cwYQ4ERumcwRbdgSO9j1d/U/gBRWcqqKTDzHNKuzjkK/am5O94n12cn2+WuINh3N+7aU4BQflQT219taHwSKScpVZBWQYZz6TgHzm6ruCMnh9hOmjUq52rkqI3NI4wIQWUBevrvC/5K051G+eXyYv9fonyVA5JiTgWopV6JyaFXARRcYZs8yjjYBVeWG40gMZ/32BduhnKYioblBhR9D0Anq6xLbnbT/jvo4GjIeaeSMZIYdRLWsbfngstx+ordtWz+iLFFptLrToO8D4o4GswKGVU9H4DcNzwb/1qQKWRKezZUObX5O/Syg+nRAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 728d1f4a-2928-4daf-8dc3-08df0816423d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:20.5274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KY5wCLBUJh0LLV7lYENACGfAsLBx6oD7Nv6v4sjfPGznxXo/u8IUVn13KXCfBm8CKxx0sgWFeWJVUjbZO32+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXw5QN+OP/ZZo0
 S1ZCfu86EcW5fBfZnu+eGmvmMbSQ8fL4Ctq+MDDsrj5ke7KVxK3WDjcXrD/QQr3lK0Y56bpHTl3
 d1Z8dPUHST0xtKCR7r07B9Sp0zq8MT0yBeV41xoUFWstP1EJnwj5p6qXYpDn/arJiIKTd/urE94
 YZqzOB1Ze/eleYpBLI9kshrYwvbqKPyr3ihsQ8fJkWZML0pjiwZTcqBwtYIsjAZ8fmtwf8IIvzh
 CLDb6xZmBTaq+z9mpV1gmkwV4DRmHTF2dC3N7f3Vy0c9DbQTrufEhkmfSjZMVb3cf+UvWlTkrco
 YzIVXIyJZjxW9gcngdwQ7T9XZacBWb+whQUOa+caHpQOwRVDljWsQQkaW5ljJJROtpJcnbVQ3WK
 +LaKebiVoYEzEpZXfvyAanWnxs3amdQj6T1VcH+W+MeXEBmbfC/JYZDkI+Gt4msK2OlkhbzCQlH
 wxRCwbgjSKDQQK3Yk8Q==
X-Proofpoint-ORIG-GUID: eygWd1NeuPxmp7rOL4yHJIWJ3ipsxUfY
X-Authority-Analysis: v=2.4 cv=fbCdDUQF c=1 sm=1 tr=0 ts=6a96ad02 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=S0-NFRiyq58gb8qD-mcA:9
X-Proofpoint-GUID: eygWd1NeuPxmp7rOL4yHJIWJ3ipsxUfY
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX9wazrAkIswso
 2mASylfcTetKPnoQzDuUxs/WzD2whGBSCUs9hXeOQ3AHenN1v0iHRzJOqnqgIaKBtPKg/NeHvk5
 kP0BHj3Gj9evbWUuMuahp1d9mR8l+Tds6kNE2GpQ6KUQzZ5ZynhR

From: John Garry <john.garry@linux.dev>

Add support in core code for delayed disk removal support. In this, the
callback calls into the scsi_driver to do the necessary removal work.

The scsi_disk driver (sd) must ensure that the scsi_mpath_device does not
go away while the delayed removal work is active, i.e. it must keep a
reference.

No reference to the scsi_disk multipath structures are kept outside that
driver, so that driver needs to provide a scsi_driver.mpath_remove_head
callback to do the necessary work.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 27 +++++++++++++++++++++++++++
 include/scsi/scsi_driver.h    |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index a80aa2101ef80..4a9ea277e79aa 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -367,7 +367,34 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
 	return false;
 }
 
+static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
+
+	if (scsi_driver->mpath_remove_head)
+		scsi_driver->mpath_remove_head(scsi_mpath_head);
+
+	return 0;
+}
+
+static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
+{
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+
+	/*
+	 * scsi_mpath_remove_head_drv() could drop the final reference to
+	 * scsi_mpath_head, meaning that we pass a free'd pointer further
+	 * drivers - take a reference so that won't happen.
+	 */
+	scsi_mpath_get_head(scsi_mpath_head);
+	bus_for_each_drv(&scsi_bus_type, NULL, scsi_mpath_head,
+		scsi_mpath_remove_head_drv);
+	scsi_mpath_put_head(scsi_mpath_head);
+}
+
 static struct mpath_head_template smpdt = {
+	.remove_head = scsi_mpath_remove_head_work,
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
 	.available_path = scsi_mpath_available_path,
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 249cea724abd1..d92b63d357f2a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -8,6 +8,7 @@
 
 struct module;
 struct request;
+struct scsi_mpath_head;
 
 struct scsi_driver {
 	struct device_driver	gendrv;
@@ -22,6 +23,9 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	#ifdef CONFIG_SCSI_MULTIPATH
+	void (*mpath_remove_head)(struct scsi_mpath_head *);
+	#endif
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
2.43.7

