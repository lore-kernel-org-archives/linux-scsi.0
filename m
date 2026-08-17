Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AC83B4E88;
	Mon, 17 Aug 2026 07:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786953270; cv=fail; b=KKVClDzI+hgebExmrLd0hFmKFkv/cm2fSu7ZHl6sVjBS3WxmcgFtPywUKUkhd/68r8tWuZ0fFS7Z0yuAXlwXFTAHXcB4KR9ac2EC4u0lFbyHe52q+tAuoEa2YDUiyRBgGrnYGF7SkYc771la8HgBmk2sNTHS2FLW+dT7nhuWt3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786953270; c=relaxed/simple;
	bh=KC5cw/S3BLie+3z+vruiMj1vjOmN8DiFIMNEkLTeuIU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oYujvUWfiiV5kF3Dd1MnUdZxpx0ZPlglbPOfPEzbvOe4P3SpIzb0u+025AVua4ok60rZxpbtsNQZHxVoUncFc9QD1ooaeHs2PVMqUazFZcMkYHZiEcYcKlVFsZm6YKemcrVIPApBZqz2zYNVbx3UnONnnwcc9S76rrVAzo0k5yA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dqDm7zwG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FRaq1Eq9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dqDm7zwG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FRaq1Eq9"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67H0Cg6H452514;
	Mon, 17 Aug 2026 07:53:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=s//Xr5bTy0Utn02N
	7v9WKOhUK5uc5H+KsaHYDx0DexY=; b=dqDm7zwGo54vHsBU4R5vGZrzWRGv8zaa
	mPeXj+GVc3QgDBIINmbB0BmUA592DweAn36jslbKnIXkqcCcmVedi6GrhLpTn1ou
	ZTgNr8JD/sy7I9APxgfl3MCpzpdKqJkjU400kmAmp8bxfCPC+1/wOBz1bwJqzcXz
	4OKbR+/V0UUNjDtqySvLXB+qoCzSWtOkqluAlBcFy1WxIpJWwXziaKo9fPwf4EMu
	zYcOSr156tWj3nKFQC57v2bYNV0hzJWK79iq/FthnZpTA6x3E35YiOBYiAaz6G9t
	qLWKmQBeliJPKyIIDxhJuQUtqXGLweSxE6TO+1Lq1WsGdjxkqUhMaQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2g5c9vfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 07:53:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67H7jB5u011684;
	Mon, 17 Aug 2026 07:53:40 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010035.outbound.protection.outlook.com [52.101.201.35])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejaxcmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 07:53:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GM8N7QlbH2fC4jz5ltPqTyDKJt6w00Y/sXv3ohwxQcIwETgr85+PZy3WLDSHkMmRK8dF5qkqSIv/ceEfB2hoVR8MwxIAWGRUxuGcJrjXZxcU8wvT6DkZEOO4D8v/N7KHy+Z3XzJa1+tfyYgHtGMBOuJ3C0EkKjzXjydh/W4L+xiAEPetJvTPzkqCCUobvagm+IxpWAcmy1TPsoxOBbGVRDXa2Gyu+PR8IRNMr/Fd5B8D4eH3Dh6seHDM4wwmXF6QsfS0xQNTTv/lcfn53gQ2MJDCI2ieJpXFghpKQoghx/D8HAPXb58mWdYKzxbg5V9ryvX/fNa7gcqyMyxsfyxjDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s//Xr5bTy0Utn02N7v9WKOhUK5uc5H+KsaHYDx0DexY=;
 b=buoDTFQpsV9SUdtDGfJ5+PkPxoygReETkrvo12jgV61JdhKqybkvvRb1zUzGfrfnQzw7DsNuM91ObIWcuLfTPgh+y+C5MCG44S97uSzCUjcBqjGQDVHCwEK6ZlMXs2KIGiFVbkxEtyAqgMjv++CzhZ57er+eMZABcuBSlK2psTT7/vCALGb5XqsXHU0pPjXCXQG/A0CfDF2mvRubUAxwtv9DrVlaj/lmNf9mFqfb4GpBoLSm21f0LCIl2/e87uxfjAYtCZttuxQed9FR43DXaLuouWaNhem7nFneDqY7NOJDT98V0+B0nFfwt511ISmbrY7g9LihCEIUMZLiLamp1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s//Xr5bTy0Utn02N7v9WKOhUK5uc5H+KsaHYDx0DexY=;
 b=FRaq1Eq9MVwz26UAQlh3S7Gr3z9d1dXONdl3oP7w/vN5ce6Fv7SZQ7HvirabCaLa0LM6RXsL/9GpXjmFJn7xFFCdS2FIPmqYdznwTHJwF6HU3plT6JHjHCRNI28D/L9lEPg9i0kDjdWRD29Iy4fUJ0q523pdCdzMTfOV8BvVcLA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4454.namprd10.prod.outlook.com (2603:10b6:510:3a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.17; Mon, 17 Aug 2026 07:53:35 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 07:53:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, linux-s390@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
        John Garry <john.garry@linux.dev>,
        John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v4] scsi: core: Drop Scsi_Host.default_lock
Date: Mon, 17 Aug 2026 07:53:24 +0000
Message-ID: <20260817075324.2737619-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0158.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::34) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ba6fa4a-5aee-444d-bb53-08defc34a384
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|6133799003|10067099003|5023799004|56012099006|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	zUZVKijLCRRgfrAPS5bQue19OrZYEXDFoGMNK9ilsQAjpowqKfywToLI2qqQRbQMAJNvLNASa8Z0YE1YVwixSQ1M/LzuE7jfe0la83FQ3jWQQLpJJYU6cv/DSZ3SKd2yJdZHDS1MIe9GXY+GOuGq5SN52haFPkw3fvDM386aUViWNej7KBldw5xmzD7J4KwmRTBl7MXODpQpI5Yp65GiCEUTh0WJ0upPA7HbHP0RpjKlYZNi+ay4xsODG6qQna1o9ptCSkK9tQ0xk58fYKzCJpdldtHeCsuKEUFz/HnDgWtDJGYDdo0OfBNJ67muYZ7iEeb6Pgr4PJdZwBcq2zuXYEdS+AaeOEZr8Flgyt4w1CE0dRuWhwlZI8sk9LORSRC4QGNsaSRILDrmBnXyCA4qDboMrTvTnAXM9p/U4kvjxxyA4sckiGrNqHGKGlk7aZ9jZNzWkigmP+jHDWmtNscNE259JxH/Jm3eIHk/BHBVq9l25CDsu0+HLBKmHH0uCh7vwQ4ttxD8UV8DHKsMfDzD7jodPzJifxT6hqBPGt15J3dRnFKio/7nGUNiQiQQxonzLwRpsa26a7N9Bc/MnMODhb/pq+JmnoMZcANomYCskofycmCtKlkJU6mncyChlCKJ332qixfGpZtZn/8K0v+aHNQTFcnnx9uYtPJOvQdw7Cw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(6133799003)(10067099003)(5023799004)(56012099006)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ga30ct+OwGYB5PfLXXyV/yqzKDdzlLPs1fNJ0zmOyz7mr/dgAKbEw+etox6E?=
 =?us-ascii?Q?JL39YJxyqQlKTjsIRHuQqlI5EHhMBiPZQ/SlJ2cnzyytcY+dk0rBHU5hy1XO?=
 =?us-ascii?Q?bZ5AE1Tg+pYpnTa8+2usGGSlx3hCE4Z3YF8IriKzGy8ZIcNAvE06nvD+9idQ?=
 =?us-ascii?Q?DoiaHlTA3MeSmwhFfXBnbj24ZxUF0EACws0XFGxSFdlzgBYIHn3y+vxfOpEu?=
 =?us-ascii?Q?R5g7BWYPG87vNAbvrRZCHuDhcmvqL+yFb4HY7/7hjlDY9OyOp/dmWEqF+fSY?=
 =?us-ascii?Q?kDShPfGn3dvZFzPTk3khnc9QB+WpnRW1muzFcZpM/0sHV2SNbhUM1Yfs4rCD?=
 =?us-ascii?Q?w2C3HuTocVjSeOYpdYYw6TYfEzUbPOQ8ak3WxJWwLzZwGrXZMMDW7TLTFNXr?=
 =?us-ascii?Q?QKrLdjxyKqo/IT2LnN7srBQ2Lr3H9yiKwuhzY49NNIR6paV7F4zvBoIo1YmR?=
 =?us-ascii?Q?vaOFfa45r+IvAvAb0TND6s4CJuIHZfDw2WXJ1z56VbvCv3zLD0aBKpG9xEoT?=
 =?us-ascii?Q?HYycGt5rcRyvzmCkv0v3lBvvyi1PNUQdGVEym1PzWhFJeqD2bMDbg10fjhtF?=
 =?us-ascii?Q?nw0zOhEzbDZeBIfhScA398OyXUQsFudkPrAznYQBZMqOvYa3Pl70VP35W+wj?=
 =?us-ascii?Q?KdUeIY17TIp69H9MA7/PKKmguKQvJHGJwDliW/dh8sEMDSsHjEyyKEGpi828?=
 =?us-ascii?Q?NBYTNLxRbSCkUsf7jSsWMDJNdcpNpLLHsIUQkYgA31FLizkNjBnXI7dWiS3w?=
 =?us-ascii?Q?ckKm3gr4sZLD8Cqj68HyOEiVO17GCbXdgsiNsKtyCNArx1sQXRT+wbKoUwW4?=
 =?us-ascii?Q?/bh5zFuVtg08NeNcAu0wagBuiqxtr6SERVBBYGS3pJuSEKNjI65YZqy9DT+c?=
 =?us-ascii?Q?D3VsN/y3okx7MGPeMn50XyG27k3P4W3oJZPR9+Pi5u3Fi7j1U98k1iHUN8K1?=
 =?us-ascii?Q?s+4722VzUBOgMED2PV3pFKTZ6QTPjPIQ8gIBA0ifPj4KJxQjSNBjSMOz1xmQ?=
 =?us-ascii?Q?U1sCP3HTF/SlnwHo4UhabcklltyxcN/14KREsaIAfD0Zi+atuv238wsHDMnZ?=
 =?us-ascii?Q?5bi7pxBWNdCXjz0tDPNSaHTkhpE2gppJVMPy4oUzxkJOE8+B4T69hGeNOPkA?=
 =?us-ascii?Q?GextxhDLcddChQmG8lVszDH7LQHkN7ntio41850xd3wxKHIgv6LRtPT4O9Yr?=
 =?us-ascii?Q?8GOoY4kHDH/9ngd1f8r1jq+AWVyLIkIhvBJRQJ4BsRR2X/FqRxg+sQTL95Zs?=
 =?us-ascii?Q?cbjYRGDhQ7Hetq3Sp+lsnvTV+s4sewz+TygvAXdQgK3YcYWBMWvnZnsqDMSY?=
 =?us-ascii?Q?ohOB3VVYEW0p4qGsPsifZZQMZUXrE0M/5ZCYMZfok5HU/R6iroaBqN7TLb15?=
 =?us-ascii?Q?xClcL9wHkXZrbG7dXL8iW+kXXVcRtS8isRDlkFExxVzym0ShF4NbUVEPVmUR?=
 =?us-ascii?Q?6wBGmPECrj6Ol/tDlsQ+d3OcWuUtBTbsBs+/WZdQoVeRC007aZr83gjqDTwi?=
 =?us-ascii?Q?DwStCX6goxOhhIWqTX7MFnAd+uFneP+hJLaOR3PDYi4D5LxMk7tJPLalgIGT?=
 =?us-ascii?Q?uy289v3aw99hMa76ceNn04pvZ8TRZ2v9klmy6bxI9NWxqyFDaTNfQK/5n0Pp?=
 =?us-ascii?Q?R8aM4+DrKf6BXoliKH9jiuImZoY+5iqFNjy5UJ6h9LfJTpXJmIdoUFF7EPmk?=
 =?us-ascii?Q?pNNBvOJ+0eDdApVc4/PGNtGQnJx6pcWYJQy9/owzHl4yU/dHj7XxutwSCmZb?=
 =?us-ascii?Q?sKSmnjN1sw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	jUo39d9aDen8PvRMO8qDmooslcdj6wBtr2G8kaMr5hdgvr3E3bj50Wdvfjx3H8DlqI2tqPBJ5U8qvtsZU7N7CoLGe8QGfl8IraxA2cbGmTAvbBqkk9x5w5ezRHviRjNr+Swi1Qit6DII8fAmGICtjCkYcY//+eIfVe3NSxQatex9fN3aM4mpxTiqabbUdi/mjf7zXkJsJNmFWr3wZXef4+vk63QwVwx83mSk156GAMllXA/pcnvizXePOadCraMBQkdoB0ewwWRWzubfHVdcitcACSBaeRAUD2WijYmF43230PEWGnaPuM1G3FXTBj/NCHDZZczhKR1mVr0GP4oZnw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o+JAV+mbY0x41LtfU5PSDwrNN0TFG5dLWFMTJqG+5iFHCQTog1Qpo68b1cn8WTz29yr4U59khlL332M/6KzACR54bCNmJVtUXEOr64sqZ8x41QVJ7gZ1Hfmp0nP7uMxQKGn2+Tph5V9tLP4Kqn7qV/kUJstLtphX+7Y4mPfquOZv7VeYZHpeXLjUSVaxG0kl/zKblUU8FNq/tFZFIRTDsXwdZmEq2ie5IQUuCZSJnlmJfKfNzPSnMfM9ToePi9/kwrHn4fKWNU7hECGLm7cazXYy6x0Pan9uIdUyGRuRFyh3tsUny7qZMqeSQtGEo5TXFT8llgyCwrN/ez7h9mTC9jl/0wqTLPB+YwAqiHX2b2/kyV4MPOsK2mbrDjMTvguONsY4TpP/Eh0WkyifAW/kH6kaKkBaJcz5AMCITg2MQRL9IzdTqgGOqdTqj7XD0LW+URe0m095oXZUV1XaPwng6W1CEI6KUvQjQ8v8wv7Pc2CrXkOrB2+fcmlKzhevEEKmXYl6Jzj/MiJeVlFM6+PL6Kwke6YgwUryef4jQEZB5INnv8KucXFdHFxGePwXgUbUfBaIJZdc4mcTOPqftrAyHia0G7n015VDTo5UPuEL1Aw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba6fa4a-5aee-444d-bb53-08defc34a384
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 07:53:35.0882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzUIQTQSFjtaVnDIgOjoWF/nu1PIdoYDUP2+sKJ3jYku92SUdN43ko1g0fvDH3ZXa4g0OLDpJMnCVkS1khwbaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608170057
X-Authority-Analysis: v=2.4 cv=INoyzAvG c=1 sm=1 tr=0 ts=6a82be06 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8
 a=m-3anQSa4fv6gn4ZkywA:9 a=O8hF6Hzn-FEA:10
X-Proofpoint-GUID: vWeXS3mV0CtOJ62svppfNSboMQ3YJe6U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA1OCBTYWx0ZWRfX6aECOZc5C5AM
 rj494R0ovzDpc3brb5GiemVjuJ1OFos7m+kmp17F3ujghePd2OrL7P4qqzkL1rd/3WmuE09zYT3
 uiVfPd/3ddXUgMAEAc3/PJWx+WXQH8q7w3WpAJbSdJ9eDU0f5n/XVGsba/ATWpG0dO6Y6MbY4XV
 6nFCX3gYrEpR4PzCuG9oXDI4ZmgMP3WFHG01Sdrr1aSb5X6xXlfEOyVjm9vjTP8/QI/gmnUPWIW
 EVlNtLpqB4XqRM0g20q5Wu0prq5bWJ3XUCvj7IE/HgLoe+02GOfWJcGmDrctKQtC6Vzu1q4aN4/
 k/Jh3mACgWgPn/kCkSdQaz+fiJgC6INeiAESQbdFtbIvqOjaBJQ4xVkBcrbUgOQLNzPNaGGf/zb
 jhY2DTpUNxyciW1eSexib6CVI8sKi6He5+b81bgWSF99jRhLMzR3knbISOE/nLflxdQsyAIFg4C
 p/9797di7jHUVf9/vRQ==
X-Proofpoint-ORIG-GUID: vWeXS3mV0CtOJ62svppfNSboMQ3YJe6U
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA1OCBTYWx0ZWRfX9xu0K8U6qTgp
 9LOOpACbFJObUl/TSkKJefjIJrIf3bbmZX2bCIyQnvX+QpNviye5KUfJyLE+3U+7OanIVxw51f3
 FlduleN+KeguwTh1+y2BfLRqXpRD8RPqoWW/PKf/hZ22U66jkhLw

From: John Garry <john.garry@linux.dev>

Back in the 2.6.xx days, it was possible to for low-level drivers to set
the shost lock pointer. That is why there is a default lock and a pointer
to the shost lock.

However, support for this has long been removed, so drop
Scsi_Host.default_lock and make Scsi_Host.host_lock as the actual lock.

Getting the address of embedded host_lock structure just requires adding
a fixed offset value to the shost pointer. However, getting the value of
the host_lock pointer requires loading from a fixed offset to the shost
pointer. The latter should be very slightly slower, which is relevant as
this lock is used a lot throughout the core code and drivers.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Acked-by: Damien Le Moal <dlemoal@kernel.org> # ata parts
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
Difference to v3:
- Rebase and update some annotations

Differences to v2:
- Add tags from Bart and Damien (Thanks!)
- Update Documentation reference to default_lock (Bart)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 7f59dff43eb54..5489e9d07ab7e 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -1148,12 +1148,8 @@ The scsi_cmnd structure is defined in include/scsi/scsi_cmnd.h
 Locks
 =====
 Each struct Scsi_Host instance has a spin_lock called struct
-Scsi_Host::default_lock which is initialized in scsi_host_alloc() [found in
-hosts.c]. Within the same function the struct Scsi_Host::host_lock pointer
-is initialized to point at default_lock.  Thereafter lock and unlock
-operations performed by the mid level use the struct Scsi_Host::host_lock
-pointer.  Previously drivers could override the host_lock pointer but
-this is not allowed anymore.
+Scsi_Host::host_lock which is initialized in scsi_host_alloc() [found in
+hosts.c].
 
 
 Autosense
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 05df7ea6954a9..e5c2e90f3531b 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -565,9 +565,9 @@ void ata_scsi_error(struct Scsi_Host *host)
 	int nr_timedout;
 	LIST_HEAD(eh_work_q);
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	list_splice_init(&host->eh_cmd_q, &eh_work_q);
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 
 	/*
 	 * First check what errors we got with ata_scsi_cmd_error_handler().
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index b55deb988ad92..bca05099718a0 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -196,20 +196,20 @@ mptfc_block_error_handler(struct fc_rport *rport)
 
 	hd = shost_priv(shost);
 	ioc = hd->ioc;
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	while ((ready = fc_remote_port_chkready(rport) >> 16) == DID_IMM_RETRY
 	 || (loops > 0 && ioc->active == 0)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
 			"mptfc_block_error_handler.%d: %s, port status is "
 			"%x, active flag %d, deferring recovery.\n",
 			ioc->name, ioc->sh->host_no,
 			dev_name(&rport->dev), ready, ioc->active));
 		msleep(1000);
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		loops --;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (ready == DID_NO_CONNECT || ioc->active == 0) {
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index ec6c0e1021199..adfe15f5cb429 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -95,11 +95,11 @@ static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
 		zfcp_erp_action_dismiss(&port->erp_action);
 	else {
-		spin_lock(port->adapter->scsi_host->host_lock);
+		spin_lock(&port->adapter->scsi_host->host_lock);
 		__shost_for_each_device(sdev, port->adapter->scsi_host)
 			if (sdev_to_zfcp(sdev)->port == port)
 				zfcp_erp_action_dismiss_lun(sdev);
-		spin_unlock(port->adapter->scsi_host->host_lock);
+		spin_unlock(&port->adapter->scsi_host->host_lock);
 	}
 }
 
@@ -670,11 +670,11 @@ static void _zfcp_erp_lun_reopen_all(struct zfcp_port *port, int clear,
 {
 	struct scsi_device *sdev;
 
-	spin_lock(port->adapter->scsi_host->host_lock);
+	spin_lock(&port->adapter->scsi_host->host_lock);
 	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			_zfcp_erp_lun_reopen(sdev, clear, dbftag, 0);
-	spin_unlock(port->adapter->scsi_host->host_lock);
+	spin_unlock(&port->adapter->scsi_host->host_lock);
 }
 
 static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
@@ -1429,7 +1429,7 @@ static void zfcp_erp_try_rport_unblock(struct zfcp_port *port)
 		write_unlock_irqrestore(&adapter->erp_lock, flags);
 		return;
 	}
-	spin_lock(shost->host_lock);
+	spin_lock(&shost->host_lock);
 	__shost_for_each_device(sdev, shost) {
 		struct zfcp_scsi_dev *zsdev = sdev_to_zfcp(sdev);
 		int lun_status;
@@ -1451,7 +1451,7 @@ static void zfcp_erp_try_rport_unblock(struct zfcp_port *port)
 			 * or meanwhile blocked [new LUN recovery triggered]
 			 */
 			zfcp_dbf_rec_run_lvl(4, "ertru_l", &zsdev->erp_action);
-			spin_unlock(shost->host_lock);
+			spin_unlock(&shost->host_lock);
 			write_unlock_irqrestore(&adapter->erp_lock, flags);
 			return;
 		}
@@ -1460,7 +1460,7 @@ static void zfcp_erp_try_rport_unblock(struct zfcp_port *port)
 	 * and no ERP of severity >= port was meanwhile triggered elsewhere
 	 */
 	zfcp_scsi_schedule_rport_register(port);
-	spin_unlock(shost->host_lock);
+	spin_unlock(&shost->host_lock);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
@@ -1713,10 +1713,10 @@ void zfcp_erp_set_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 	if (adapter->scsi_host == NULL)
 		return;
 
-	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, adapter->scsi_host)
 		atomic_or(common_mask, &sdev_to_zfcp(sdev)->status);
-	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1757,13 +1757,13 @@ void zfcp_erp_clear_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 	if (adapter->scsi_host == NULL)
 		return;
 
-	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, adapter->scsi_host) {
 		atomic_andnot(common_mask, &sdev_to_zfcp(sdev)->status);
 		if (clear_counter)
 			atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 	}
-	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1784,12 +1784,12 @@ void zfcp_erp_set_port_status(struct zfcp_port *port, u32 mask)
 	if (!common_mask)
 		return;
 
-	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&port->adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			atomic_or(common_mask,
 					&sdev_to_zfcp(sdev)->status);
-	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&port->adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1814,7 +1814,7 @@ void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 	if (clear_counter)
 		atomic_set(&port->erp_counter, 0);
 
-	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&port->adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port) {
 			atomic_andnot(common_mask,
@@ -1822,7 +1822,7 @@ void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 			if (clear_counter)
 				atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 		}
-	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&port->adapter->scsi_host->host_lock, flags);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 4f23d585d0620..b1ed0cb30a724 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -270,7 +270,7 @@ static bool zfcp_sysfs_port_in_use(struct zfcp_port *const port)
 	if (atomic_read(&port->units) > 0)
 		goto unlock_port_units_mutex; /* zfcp_unit(s) under port */
 
-	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, adapter->scsi_host) {
 		const struct zfcp_scsi_dev *zsdev = sdev_to_zfcp(sdev);
 
@@ -288,7 +288,7 @@ static bool zfcp_sysfs_port_in_use(struct zfcp_port *const port)
 	in_use = false;
 
 unlock_host_lock:
-	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&adapter->scsi_host->host_lock, flags);
 unlock_port_units_mutex:
 	mutex_unlock(&zfcp_sysfs_port_units_mutex);
 	return in_use;
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 9b93a2440af8f..e6694f242ebed 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -160,7 +160,7 @@ static ssize_t twa_show_stats(struct device *dev,
 	unsigned long flags = 0;
 	ssize_t len;
 
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 	len = sysfs_emit(buf, "3w-9xxx Driver version: %s\n"
 			 "Current commands posted:   %4d\n"
 			 "Max commands posted:       %4d\n"
@@ -183,7 +183,7 @@ static ssize_t twa_show_stats(struct device *dev,
 			 tw_dev->max_sector_count,
 			 tw_dev->num_resets,
 			 tw_dev->aen_count);
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 	return len;
 } /* End twa_show_stats() */
 
@@ -694,7 +694,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	/* See which ioctl we are doing */
 	switch (cmd) {
 	case TW_IOCTL_FIRMWARE_PASS_THROUGH:
-		spin_lock_irqsave(tw_dev->host->host_lock, flags);
+		spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 		twa_get_request_id(tw_dev, &request_id);
 
 		/* Flag internal command */
@@ -712,7 +712,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 
 		/* Now post the command packet to the controller */
 		twa_post_command_packet(tw_dev, request_id, 1);
-		spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+		spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 
 		timeout = TW_IOCTL_CHRDEV_TIMEOUT*HZ;
 
@@ -734,11 +734,11 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 		memcpy(&(tw_ioctl->firmware_command), tw_dev->command_packet_virt[request_id], sizeof(TW_Command_Full));
 
 		/* Now complete the io */
-		spin_lock_irqsave(tw_dev->host->host_lock, flags);
+		spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 		tw_dev->posted_request_count--;
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twa_free_request_id(tw_dev, request_id);
-		spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+		spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 		break;
 	case TW_IOCTL_GET_COMPATIBILITY_INFO:
 		tw_ioctl->driver_command.status = 0;
@@ -1223,7 +1223,7 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 	int handled = 0;
 
 	/* Get the per adapter lock */
-	spin_lock(tw_dev->host->host_lock);
+	spin_lock(&tw_dev->host->host_lock);
 
 	/* Read the registers */
 	status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
@@ -1372,7 +1372,7 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 	}
 
 twa_interrupt_bail:
-	spin_unlock(tw_dev->host->host_lock);
+	spin_unlock(&tw_dev->host->host_lock);
 	return IRQ_RETVAL(handled);
 } /* End twa_interrupt() */
 
@@ -1585,7 +1585,7 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 	set_bit(TW_IN_RESET, &tw_dev->flags);
 	TW_DISABLE_INTERRUPTS(tw_dev);
 	TW_MASK_COMMAND_INTERRUPT(tw_dev);
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 
 	/* Abort all requests that are in progress */
 	for (i = 0; i < TW_Q_LENGTH; i++) {
@@ -1616,7 +1616,7 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 	tw_dev->pending_tail = TW_Q_START;
 	tw_dev->reset_print = 0;
 
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 
 	if (twa_reset_sequence(tw_dev, 1))
 		goto out;
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 52dc1aa639f7e..060f97805319f 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -108,9 +108,9 @@ static ssize_t twl_sysfs_aen_read(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 	ret = memory_read_from_buffer(outbuf, count, &offset, tw_dev->event_queue[0], sizeof(TW_Event) * TW_Q_LENGTH);
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 
 	return ret;
 } /* End twl_sysfs_aen_read() */
@@ -139,9 +139,9 @@ static ssize_t twl_sysfs_compat_info(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 	ret = memory_read_from_buffer(outbuf, count, &offset, &tw_dev->tw_compat_info, sizeof(TW_Compatibility_Info));
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 
 	return ret;
 } /* End twl_sysfs_compat_info() */
@@ -165,7 +165,7 @@ static ssize_t twl_show_stats(struct device *dev,
 	unsigned long flags = 0;
 	ssize_t len;
 
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 	len = sysfs_emit(buf, "3w-sas Driver version: %s\n"
 			 "Current commands posted:   %4d\n"
 			 "Max commands posted:       %4d\n"
@@ -184,7 +184,7 @@ static ssize_t twl_show_stats(struct device *dev,
 			 tw_dev->max_sector_count,
 			 tw_dev->num_resets,
 			 tw_dev->aen_count);
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 	return len;
 } /* End twl_show_stats() */
 
@@ -763,7 +763,7 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	/* See which ioctl we are doing */
 	switch (cmd) {
 	case TW_IOCTL_FIRMWARE_PASS_THROUGH:
-		spin_lock_irqsave(tw_dev->host->host_lock, flags);
+		spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 		twl_get_request_id(tw_dev, &request_id);
 
 		/* Flag internal command */
@@ -781,7 +781,7 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 
 		/* Now post the command packet to the controller */
 		twl_post_command_packet(tw_dev, request_id);
-		spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+		spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 
 		timeout = TW_IOCTL_CHRDEV_TIMEOUT*HZ;
 
@@ -803,11 +803,11 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 		memcpy(&(tw_ioctl->firmware_command), tw_dev->command_packet_virt[request_id], sizeof(TW_Command_Full));
 
 		/* Now complete the io */
-		spin_lock_irqsave(tw_dev->host->host_lock, flags);
+		spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 		tw_dev->posted_request_count--;
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twl_free_request_id(tw_dev, request_id);
-		spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+		spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 		break;
 	default:
 		retval = -ENOTTY;
@@ -1125,7 +1125,7 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 	struct scsi_cmnd *cmd;
 	TW_Command_Full *full_command_packet;
 
-	spin_lock(tw_dev->host->host_lock);
+	spin_lock(&tw_dev->host->host_lock);
 
 	/* Read host interrupt status */
 	reg = readl(TWL_HISTAT_REG_ADDR(tw_dev));
@@ -1229,7 +1229,7 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 	}
 
 twl_interrupt_bail:
-	spin_unlock(tw_dev->host->host_lock);
+	spin_unlock(&tw_dev->host->host_lock);
 	return IRQ_RETVAL(handled);
 } /* End twl_interrupt() */
 
@@ -1360,7 +1360,7 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 	TWL_MASK_INTERRUPTS(tw_dev);
 	TWL_CLEAR_DB_INTERRUPT(tw_dev);
 
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 
 	/* Abort all requests that are in progress */
 	for (i = 0; i < TW_Q_LENGTH; i++) {
@@ -1386,7 +1386,7 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 	tw_dev->free_tail = TW_Q_START;
 	tw_dev->posted_request_count = 0;
 
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 
 	if (twl_reset_sequence(tw_dev, 1))
 		goto out;
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c68678fa72c1e..7f7bf5b5640de 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -495,7 +495,7 @@ static ssize_t tw_show_stats(struct device *dev, struct device_attribute *attr,
 	unsigned long flags = 0;
 	ssize_t len;
 
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 	len = sysfs_emit(buf, "3w-xxxx Driver version: %s\n"
 			 "Current commands posted:   %4d\n"
 			 "Max commands posted:       %4d\n"
@@ -518,7 +518,7 @@ static ssize_t tw_show_stats(struct device *dev, struct device_attribute *attr,
 			 tw_dev->max_sector_count,
 			 tw_dev->num_resets,
 			 tw_dev->aen_count);
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 	return len;
 } /* End tw_show_stats() */
 
@@ -935,7 +935,7 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 			dprintk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): caught TW_AEN_LISTEN.\n");
 			memset(tw_ioctl->data_buffer, 0, data_buffer_length);
 
-			spin_lock_irqsave(tw_dev->host->host_lock, flags);
+			spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 			if (tw_dev->aen_head == tw_dev->aen_tail) {
 				tw_aen_code = TW_AEN_QUEUE_EMPTY;
 			} else {
@@ -946,12 +946,12 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 					tw_dev->aen_head = tw_dev->aen_head + 1;
 				}
 			}
-			spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+			spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 			memcpy(tw_ioctl->data_buffer, &tw_aen_code, sizeof(tw_aen_code));
 			break;
 		case TW_CMD_PACKET_WITH_DATA:
 			dprintk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): caught TW_CMD_PACKET_WITH_DATA.\n");
-			spin_lock_irqsave(tw_dev->host->host_lock, flags);
+			spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 
 			tw_state_request_start(tw_dev, &request_id);
 
@@ -983,7 +983,7 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 
 			/* Now post the command packet to the controller */
 			tw_post_command_packet(tw_dev, request_id);
-			spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+			spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 
 			timeout = TW_IOCTL_CHRDEV_TIMEOUT*HZ;
 
@@ -1005,11 +1005,11 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 			memcpy(&(tw_ioctl->firmware_command), tw_dev->command_packet_virtual_address[request_id], sizeof(TW_Command));
 
 			/* Now complete the io */
-			spin_lock_irqsave(tw_dev->host->host_lock, flags);
+			spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 			tw_dev->posted_request_count--;
 			tw_dev->state[request_id] = TW_S_COMPLETED;
 			tw_state_request_finish(tw_dev, request_id);
-			spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+			spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 			break;
 		default:
 			retval = -ENOTTY;
@@ -1296,7 +1296,7 @@ static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 	set_bit(TW_IN_RESET, &tw_dev->flags);
 	TW_DISABLE_INTERRUPTS(tw_dev);
 	TW_MASK_COMMAND_INTERRUPT(tw_dev);
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock_irqsave(&tw_dev->host->host_lock, flags);
 
 	/* Abort all requests that are in progress */
 	for (i=0;i<TW_Q_LENGTH;i++) {
@@ -1325,7 +1325,7 @@ static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 	tw_dev->pending_tail = TW_Q_START;
 	tw_dev->reset_print = 0;
 
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	spin_unlock_irqrestore(&tw_dev->host->host_lock, flags);
 
 	if (tw_reset_sequence(tw_dev)) {
 		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset sequence failed.\n", tw_dev->host->host_no);
@@ -2005,7 +2005,7 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
 	int handled = 0;
 
 	/* Get the host lock for io completions */
-	spin_lock(tw_dev->host->host_lock);
+	spin_lock(&tw_dev->host->host_lock);
 
 	/* Read the registers */
 	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
@@ -2185,7 +2185,7 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
 	}
 
 tw_interrupt_bail:
-	spin_unlock(tw_dev->host->host_lock);
+	spin_unlock(&tw_dev->host->host_lock);
 	return IRQ_RETVAL(handled);
 } /* End tw_interrupt() */
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index c78f74b8f45c8..eb3a69dff1e72 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1499,7 +1499,7 @@ NCR_700_intr(int irq, void *dev_id)
 	 * lock to enter the done routines.  When that happens, we
 	 * need to ensure that for this driver, the host lock and the
 	 * queue lock point to the same thing. */
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	if((istat = NCR_700_readb(host, ISTAT_REG))
 	      & (SCSI_INT_PENDING | DMA_INT_PENDING)) {
 		__u32 dsps;
@@ -1747,7 +1747,7 @@ NCR_700_intr(int irq, void *dev_id)
 		}
 	}
  out_unlock:
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 	return IRQ_RETVAL(handled);
 }
 
@@ -1948,27 +1948,27 @@ NCR_700_host_reset(struct scsi_cmnd * SCp)
 	/* In theory, eh_complete should always be null because the
 	 * eh is single threaded, but just in case we're handling a
 	 * reset via sg or something */
-	spin_lock_irq(SCp->device->host->host_lock);
+	spin_lock_irq(&SCp->device->host->host_lock);
 	while (hostdata->eh_complete != NULL) {
-		spin_unlock_irq(SCp->device->host->host_lock);
+		spin_unlock_irq(&SCp->device->host->host_lock);
 		msleep_interruptible(100);
-		spin_lock_irq(SCp->device->host->host_lock);
+		spin_lock_irq(&SCp->device->host->host_lock);
 	}
 
 	hostdata->eh_complete = &complete;
 	NCR_700_internal_bus_reset(SCp->device->host);
 	NCR_700_chip_reset(SCp->device->host);
 
-	spin_unlock_irq(SCp->device->host->host_lock);
+	spin_unlock_irq(&SCp->device->host->host_lock);
 	wait_for_completion(&complete);
-	spin_lock_irq(SCp->device->host->host_lock);
+	spin_lock_irq(&SCp->device->host->host_lock);
 
 	hostdata->eh_complete = NULL;
 	/* Revalidate the transport parameters of the failing device */
 	if(hostdata->fast)
 		spi_schedule_dv_device(SCp->device);
 
-	spin_unlock_irq(SCp->device->host->host_lock);
+	spin_unlock_irq(&SCp->device->host->host_lock);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 5304d2febd63e..27b446c0c5d0f 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2744,7 +2744,7 @@ static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
 	/*
 	   Acquire exclusive access to Host Adapter.
 	 */
-	spin_lock_irqsave(adapter->scsi_host->host_lock, processor_flag);
+	spin_lock_irqsave(&adapter->scsi_host->host_lock, processor_flag);
 	/*
 	   Handle Interrupts appropriately for each Host Adapter type.
 	 */
@@ -2812,7 +2812,7 @@ static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
 	/*
 	   Release exclusive access to Host Adapter.
 	 */
-	spin_unlock_irqrestore(adapter->scsi_host->host_lock, processor_flag);
+	spin_unlock_irqrestore(&adapter->scsi_host->host_lock, processor_flag);
 	return IRQ_HANDLED;
 }
 
@@ -2864,12 +2864,12 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt)
 	struct blogic_tgt_stats *stats = &adapter->tgt_stats[id];
 	int rc;
 
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(&SCpnt->device->host->host_lock);
 
 	blogic_inc_count(&stats->adapter_reset_req);
 
 	rc = blogic_resetadapter(adapter, false);
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(&SCpnt->device->host->host_lock);
 	return rc;
 }
 
@@ -2915,9 +2915,9 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
 	 */
 	ccb = blogic_alloc_ccb(adapter);
 	if (ccb == NULL) {
-		spin_unlock_irq(adapter->scsi_host->host_lock);
+		spin_unlock_irq(&adapter->scsi_host->host_lock);
 		blogic_delay(1);
-		spin_lock_irq(adapter->scsi_host->host_lock);
+		spin_lock_irq(&adapter->scsi_host->host_lock);
 		ccb = blogic_alloc_ccb(adapter);
 		if (ccb == NULL) {
 			command->result = DID_ERROR << 16;
@@ -3062,10 +3062,10 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
 		   be initiated soon.
 		 */
 		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
-			spin_unlock_irq(adapter->scsi_host->host_lock);
+			spin_unlock_irq(&adapter->scsi_host->host_lock);
 			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\n", adapter);
 			blogic_delay(1);
-			spin_lock_irq(adapter->scsi_host->host_lock);
+			spin_lock_irq(&adapter->scsi_host->host_lock);
 			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
 						ccb)) {
 				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
@@ -3212,9 +3212,9 @@ static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
 	 */
 
 	if (hard_reset) {
-		spin_unlock_irq(adapter->scsi_host->host_lock);
+		spin_unlock_irq(&adapter->scsi_host->host_lock);
 		blogic_delay(adapter->bus_settle_time);
-		spin_lock_irq(adapter->scsi_host->host_lock);
+		spin_lock_irq(&adapter->scsi_host->host_lock);
 	}
 
 	for (tgt_id = 0; tgt_id < adapter->maxdev; tgt_id++) {
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 4365b896f5c47..7e6776325d9b8 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1058,9 +1058,9 @@ static irqreturn_t inia100_intr(int irqno, void *devid)
 	unsigned long flags;
 	irqreturn_t res;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	res = orc_interrupt(host);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	return res;
 }
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index f81e53b53e203..223065529654f 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -39,9 +39,9 @@ static irqreturn_t a2091_intr(int irq, void *data)
 	if (!(status & (ISTR_INT_F | ISTR_INT_P)) || !(status & ISTR_INTS))
 		return IRQ_NONE;
 
-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(&instance->host_lock, flags);
 	wd33c93_intr(instance);
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(&instance->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index bf054dd7682bf..dd0924572c0e1 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -41,9 +41,9 @@ static irqreturn_t a3000_intr(int irq, void *data)
 	if (!(status & ISTR_INT_P))
 		return IRQ_NONE;
 	if (status & ISTR_INTS) {
-		spin_lock_irqsave(instance->host_lock, flags);
+		spin_lock_irqsave(&instance->host_lock, flags);
 		wd33c93_intr(instance);
-		spin_unlock_irqrestore(instance->host_lock, flags);
+		spin_unlock_irqrestore(&instance->host_lock, flags);
 		return IRQ_HANDLED;
 	}
 	pr_warn("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index c4485629f7923..347d480a39b08 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1487,7 +1487,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 */
 	aac_adapter_disable_int(aac);
 	if (aac->thread && aac->thread->pid != current->pid) {
-		spin_unlock_irq(host->host_lock);
+		spin_unlock_irq(&host->host_lock);
 		kthread_stop(aac->thread);
 		aac->thread = NULL;
 		jafo = 1;
@@ -1612,7 +1612,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	}
 
 	if (jafo) {
-		spin_lock_irq(host->host_lock);
+		spin_lock_irq(&host->host_lock);
 	}
 	return retval;
 }
@@ -1644,11 +1644,11 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	/* Quiesce build, flush cache, write through mode */
 	if (forced < 2)
 		aac_send_shutdown(aac);
-	spin_lock_irqsave(host->host_lock, flagv);
+	spin_lock_irqsave(&host->host_lock, flagv);
 	bled = forced ? forced :
 			(aac_check_reset != 0 && aac_check_reset != 1);
 	retval = _aac_reset_adapter(aac, bled, reset_type);
-	spin_unlock_irqrestore(host->host_lock, flagv);
+	spin_unlock_irqrestore(&host->host_lock, flagv);
 
 	unblock_retval = scsi_host_unblock(host, SDEV_RUNNING);
 	if (!retval)
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 5cdbf2bdb13df..e6fa05ffc0240 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7072,9 +7072,9 @@ static int advansys_reset(struct scsi_cmnd *scp)
 			ret = FAILED;
 			break;
 		}
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		AdvISR(adv_dvc);
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 	}
 
 	ASC_DBG(1, "ret %d\n", ret);
@@ -7138,7 +7138,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	unsigned long flags;
 
 	ASC_DBG(2, "boardp 0x%p\n", boardp);
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (ASC_NARROW_BOARD(boardp)) {
 		if (AscIsIntPending(shost->io_port)) {
 			result = IRQ_HANDLED;
@@ -7153,7 +7153,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 			ASC_STATS(shost, interrupt);
 		}
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	ASC_DBG(1, "end\n");
 	return result;
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 93dab19c1cb95..7ea38d5090720 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -306,7 +306,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 #endif
 	number_serviced = 0;
 
-	spin_lock_irqsave(sh->host_lock, flags);
+	spin_lock_irqsave(&sh->host_lock, flags);
 	while (1) {
 		flag = inb(INTRFLAGS(sh->io_port));
 
@@ -339,7 +339,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 		} while (mbi != aha1542->aha1542_last_mbi_used);
 
 		if (mb[mbi].status == 0) {
-			spin_unlock_irqrestore(sh->host_lock, flags);
+			spin_unlock_irqrestore(&sh->host_lock, flags);
 			/* Hmm, no mail.  Must have read it the last time around */
 			if (!number_serviced)
 				shost_printk(KERN_WARNING, sh, "interrupt received, but no mail.\n");
@@ -367,7 +367,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 		tmp_cmd = aha1542->int_cmds[mbo];
 
 		if (!tmp_cmd) {
-			spin_unlock_irqrestore(sh->host_lock, flags);
+			spin_unlock_irqrestore(&sh->host_lock, flags);
 			shost_printk(KERN_WARNING, sh, "Unexpected interrupt\n");
 			shost_printk(KERN_WARNING, sh, "tarstat=%x, hastat=%x idlun=%x ccb#=%d\n", ccb[mbo].tarstat,
 			       ccb[mbo].hastat, ccb[mbo].idlun, mbo);
@@ -461,7 +461,7 @@ static enum scsi_qc_status aha1542_queuecommand(struct Scsi_Host *sh,
 	 * is how the host adapter will scan for them
 	 */
 
-	spin_lock_irqsave(sh->host_lock, flags);
+	spin_lock_irqsave(&sh->host_lock, flags);
 	mbo = aha1542->aha1542_last_mbo_used + 1;
 	if (mbo >= AHA1542_MAILBOXES)
 		mbo = 0;
@@ -518,7 +518,7 @@ static enum scsi_qc_status aha1542_queuecommand(struct Scsi_Host *sh,
 #endif
 	mb[mbo].status = 1;
 	aha1542_outb(cmd->device->host->io_port, CMD_START_SCSI);
-	spin_unlock_irqrestore(sh->host_lock, flags);
+	spin_unlock_irqrestore(&sh->host_lock, flags);
 
 	return 0;
 }
@@ -873,7 +873,7 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 	int mbo;
 	struct ccb *ccb = aha1542->ccb;
 
-	spin_lock_irqsave(sh->host_lock, flags);
+	spin_lock_irqsave(&sh->host_lock, flags);
 	mbo = aha1542->aha1542_last_mbo_used + 1;
 	if (mbo >= AHA1542_MAILBOXES)
 		mbo = 0;
@@ -913,7 +913,7 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 	 * target
 	 */
 	aha1542_outb(sh->io_port, CMD_START_SCSI);
-	spin_unlock_irqrestore(sh->host_lock, flags);
+	spin_unlock_irqrestore(&sh->host_lock, flags);
 
 	scmd_printk(KERN_WARNING, cmd,
 		"Trying device reset for target\n");
@@ -928,7 +928,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(sh->host_lock, flags);
+	spin_lock_irqsave(&sh->host_lock, flags);
 	/*
 	 * This does a scsi reset for all devices on the bus.
 	 * In principle, we could also reset the 1542 - should
@@ -939,7 +939,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 
 	if (!wait_mask(STATUS(cmd->device->host->io_port),
 	     STATMASK, IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
-		spin_unlock_irqrestore(sh->host_lock, flags);
+		spin_unlock_irqrestore(&sh->host_lock, flags);
 		return FAILED;
 	}
 
@@ -978,7 +978,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 		}
 	}
 
-	spin_unlock_irqrestore(sh->host_lock, flags);
+	spin_unlock_irqrestore(&sh->host_lock, flags);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index c435769359f22..b01701d139b90 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -225,7 +225,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 	
 	if (!host)
 		panic("aha1740.c: Irq from unknown host!\n");
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	base = host->io_port;
 	number_serviced = 0;
 	edev = HOSTDATA(host)->edev;
@@ -315,7 +315,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 		number_serviced++;
 	}
 
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 	return IRQ_RETVAL(handled);
 }
 
@@ -353,7 +353,7 @@ static enum scsi_qc_status aha1740_queuecommand_lck(struct scsi_cmnd *SCpnt)
 #endif
 
 	/* locate an available ecb */
-	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
+	spin_lock_irqsave(&SCpnt->device->host->host_lock, flags);
 	ecbno = host->last_ecb_used + 1; /* An optimization */
 	if (ecbno >= AHA1740_ECBS)
 		ecbno = 0;
@@ -372,7 +372,7 @@ static enum scsi_qc_status aha1740_queuecommand_lck(struct scsi_cmnd *SCpnt)
 						    doubles as reserved flag */
 
 	host->last_ecb_used = ecbno;    
-	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
+	spin_unlock_irqrestore(&SCpnt->device->host->host_lock, flags);
 
 #ifdef DEBUG
 	printk("Sending command (%d %x)...", ecbno, done);
@@ -465,7 +465,7 @@ static enum scsi_qc_status aha1740_queuecommand_lck(struct scsi_cmnd *SCpnt)
 		unsigned int base = SCpnt->device->host->io_port;
 		DEB(printk("aha1740[%d] critical section\n",ecbno));
 
-		spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
+		spin_lock_irqsave(&SCpnt->device->host->host_lock, flags);
 		for (loopcnt = 0; ; loopcnt++) {
 			if (inb(G2STAT(base)) & G2STAT_MBXOUT) break;
 			if (loopcnt == LOOPCNT_WARN) {
@@ -485,7 +485,7 @@ static enum scsi_qc_status aha1740_queuecommand_lck(struct scsi_cmnd *SCpnt)
 				panic("aha1740.c: attn wait failed!\n");
 		}
 		outb(ATTN_START | (target & 7), ATTN(base)); /* Start it up */
-		spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
+		spin_unlock_irqrestore(&SCpnt->device->host->host_lock, flags);
 		DEB(printk("aha1740[%d] request queued.\n",ecbno));
 	} else
 		printk(KERN_ALERT "aha1740_queuecommand: done can't be NULL\n");
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 99be9da8757f4..0cb1308eda4e6 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -124,14 +124,14 @@ eesoxscsi_terminator_ctl(struct Scsi_Host *host, int on_off)
 	struct eesoxscsi_info *info = (struct eesoxscsi_info *)host->hostdata;
 	unsigned long flags;
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	if (on_off)
 		info->control |= EESOX_TERM_ENABLE;
 	else
 		info->control &= ~EESOX_TERM_ENABLE;
 
 	writeb(info->control, info->ctl_port);
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 }
 
 /* Prototype: void eesoxscsi_intr(irq, *dev_id, *regs)
@@ -457,14 +457,14 @@ static ssize_t eesoxscsi_store_term(struct device *dev, struct device_attribute
 	unsigned long flags;
 
 	if (len > 1) {
-		spin_lock_irqsave(host->host_lock, flags);
+		spin_lock_irqsave(&host->host_lock, flags);
 		if (buf[0] != '0') {
 			info->control |= EESOX_TERM_ENABLE;
 		} else {
 			info->control &= ~EESOX_TERM_ENABLE;
 		}
 		writeb(info->control, info->ctl_port);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 	}
 
 	return len;
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index fccfacaaf1d52..d0752c0bf4254 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2295,7 +2295,7 @@ static enum scsi_qc_status fas216_noqueue_command_lck(struct scsi_cmnd *SCpnt)
 	 * However, we must re-enable interrupts, or else we'll be
 	 * waiting forever.
 	 */
-	spin_unlock_irq(info->host->host_lock);
+	spin_unlock_irq(&info->host->host_lock);
 
 	while (!info->internal_done) {
 		/*
@@ -2307,13 +2307,13 @@ static enum scsi_qc_status fas216_noqueue_command_lck(struct scsi_cmnd *SCpnt)
 		 * to be some time (eg, disconnected).
 		 */
 		if (fas216_readb(info, REG_STAT) & STAT_INT) {
-			spin_lock_irq(info->host->host_lock);
+			spin_lock_irq(&info->host->host_lock);
 			fas216_intr(info);
-			spin_unlock_irq(info->host->host_lock);
+			spin_unlock_irq(&info->host->host_lock);
 		}
 	}
 
-	spin_lock_irq(info->host->host_lock);
+	spin_lock_irq(&info->host->host_lock);
 
 	scsi_done(SCpnt);
 
@@ -2662,7 +2662,7 @@ int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
 {
 	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
 
-	spin_lock_irq(info->host->host_lock);
+	spin_lock_irq(&info->host->host_lock);
 
 	fas216_checkmagic(info);
 
@@ -2679,9 +2679,9 @@ int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
 	 * IRQs if we sleep, but we must relock and disable
 	 * IRQs after the sleep.
 	 */
-	spin_unlock_irq(info->host->host_lock);
+	spin_unlock_irq(&info->host->host_lock);
 	msleep(50 * 1000/100);
-	spin_lock_irq(info->host->host_lock);
+	spin_lock_irq(&info->host->host_lock);
 
 	/*
 	 * Release the SCSI reset.
@@ -2690,7 +2690,7 @@ int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
 
 	fas216_init_chip(info);
 
-	spin_unlock_irq(info->host->host_lock);
+	spin_unlock_irq(&info->host->host_lock);
 	return SUCCESS;
 }
 
@@ -2917,9 +2917,9 @@ int fas216_add(struct Scsi_Host *host, struct device *dev)
 	/*
 	 * scsi standard says wait 250ms
 	 */
-	spin_unlock_irq(info->host->host_lock);
+	spin_unlock_irq(&info->host->host_lock);
 	msleep(100*1000/100);
-	spin_lock_irq(info->host->host_lock);
+	spin_lock_irq(&info->host->host_lock);
 
 	fas216_writeb(info, REG_CNTL1, info->scsi.cfg[0]);
 	fas216_readb(info, REG_INST);
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 67459d81f479e..c608d22ad2c60 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -225,7 +225,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			/*
 			 *	Issue more commands
 			 */
-			spin_lock_irqsave(dev->host->host_lock, flags);
+			spin_lock_irqsave(&dev->host->host_lock, flags);
 			if (((dev->quhd[c] != dev->quend[c]) ||
 			     (dev->last_cmd[c] != 0xff)) &&
 			    (dev->in_snd[c] == 0)) {
@@ -234,7 +234,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 #endif
 				send_s870(dev,c);
 			}
-			spin_unlock_irqrestore(dev->host->host_lock, flags);
+			spin_unlock_irqrestore(&dev->host->host_lock, flags);
 			/*
 			 *	Done
 			 */
@@ -511,7 +511,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			 */
 			scsi_dma_unmap(workreq);
 
-			spin_lock_irqsave(dev->host->host_lock, flags);
+			spin_lock_irqsave(&dev->host->host_lock, flags);
 			scsi_done(workreq);
 #ifdef ED_DBGP
 			   printk("workreq->scsi_done\n");
@@ -521,7 +521,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			 */
 			dev->id[c][target_id].curr_req = NULL;
 			dev->working[c]--;
-			spin_unlock_irqrestore(dev->host->host_lock, flags);
+			spin_unlock_irqrestore(&dev->host->host_lock, flags);
 			/*
 			 *      Take it back wide
 			 */
@@ -533,7 +533,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			/*
 			 *	If there is stuff to send and nothing going then send it
 			 */
-			spin_lock_irqsave(dev->host->host_lock, flags);
+			spin_lock_irqsave(&dev->host->host_lock, flags);
 			if (((dev->last_cmd[c] != 0xff) ||
 			     (dev->quhd[c] != dev->quend[c])) &&
 			    (dev->in_snd[c] == 0)) {
@@ -542,7 +542,7 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 #endif
 			   send_s870(dev,c);
 			}
-			spin_unlock_irqrestore(dev->host->host_lock, flags);
+			spin_unlock_irqrestore(&dev->host->host_lock, flags);
 			dev->in_int[c] = 0;
 			return IRQ_HANDLED;
 		}
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 292bc9aa43f1f..143a3913c6504 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2552,7 +2552,7 @@ static void bfad_reset_sdev_bflags(struct bfad_im_port_s *im_port,
 	struct scsi_device *sdev;
 	unsigned long flags;
 
-	spin_lock_irqsave(im_port->shost->host_lock, flags);
+	spin_lock_irqsave(&im_port->shost->host_lock, flags);
 	list_for_each_entry(itnim, &im_port->itnim_mapped_list, list_entry) {
 		sdev = __scsi_device_lookup(im_port->shost, itnim->channel,
 					    itnim->scsi_tgt_id, 0);
@@ -2563,7 +2563,7 @@ static void bfad_reset_sdev_bflags(struct bfad_im_port_s *im_port,
 				sdev->sdev_bflags &= ~scan_flags;
 		}
 	}
-	spin_unlock_irqrestore(im_port->shost->host_lock, flags);
+	spin_unlock_irqrestore(&im_port->shost->host_lock, flags);
 }
 
 /* Function to reset the LUN SCAN mode */
diff --git a/drivers/scsi/csiostor/csio_attr.c b/drivers/scsi/csiostor/csio_attr.c
index 200e50089711e..9f021a7f78bd2 100644
--- a/drivers/scsi/csiostor/csio_attr.c
+++ b/drivers/scsi/csiostor/csio_attr.c
@@ -84,9 +84,9 @@ csio_reg_rnode(struct csio_rnode *rn)
 
 	ln->num_reg_rnodes++;
 	rport = rn->rport;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	*((struct csio_rnode **)rport->dd_data) = rn;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	sp = &rn->rn_sparm;
 	rport->maxframe_size = ntohs(sp->csp.sp_bb_data);
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index b1de615cf3162..0114e70e98844 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2256,14 +2256,14 @@ csio_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	struct csio_lnode *ln = shost_priv(shost);
 	int rv = 1;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	if (!ln->hwp || csio_list_deleted(&ln->sm.sm_list))
 		goto out;
 
 	rv = csio_scan_done(ln, jiffies, time, csio_max_scan_tmo * HZ,
 			    csio_delta_scan_tmo * HZ);
 out:
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	return rv;
 }
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index ba490174a417d..10e2078f4a0fd 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -91,8 +91,8 @@
 #endif
 
 
-#define DC395x_LOCK_IO(dev,flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
-#define DC395x_UNLOCK_IO(dev,flags)		spin_unlock_irqrestore(((struct Scsi_Host *)dev)->host_lock, flags)
+#define DC395x_LOCK_IO(dev,flags)		spin_lock_irqsave(&((struct Scsi_Host *)dev)->host_lock, flags)
+#define DC395x_UNLOCK_IO(dev,flags)		spin_unlock_irqrestore(&((struct Scsi_Host *)dev)->host_lock, flags)
 
 #define DC395x_read8(acb,address)		(u8)(inb(acb->io_port_base + (address)))
 #define DC395x_read16(acb,address)		(u16)(inw(acb->io_port_base + (address)))
@@ -1016,9 +1016,9 @@ static int dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
 
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(&cmd->device->host->host_lock);
 	rc = __dc395x_eh_bus_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irq(&cmd->device->host->host_lock);
 
 	return rc;
 }
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 897a01d3e3038..9993b0ae9c4f2 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2174,7 +2174,7 @@ irqreturn_t scsi_esp_intr(int irq, void *dev_id)
 	unsigned long flags;
 	irqreturn_t ret;
 
-	spin_lock_irqsave(esp->host->host_lock, flags);
+	spin_lock_irqsave(&esp->host->host_lock, flags);
 	ret = IRQ_NONE;
 	if (esp->ops->irq_pending(esp)) {
 		ret = IRQ_HANDLED;
@@ -2194,7 +2194,7 @@ irqreturn_t scsi_esp_intr(int irq, void *dev_id)
 				break;
 		}
 	}
-	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	spin_unlock_irqrestore(&esp->host->host_lock, flags);
 
 	return ret;
 }
@@ -2497,7 +2497,7 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 	/* XXX This helps a lot with debugging but might be a bit
 	 * XXX much for the final driver.
 	 */
-	spin_lock_irqsave(esp->host->host_lock, flags);
+	spin_lock_irqsave(&esp->host->host_lock, flags);
 	shost_printk(KERN_ERR, esp->host, "Aborting command [%p:%02x]\n",
 		     cmd, cmd->cmnd[0]);
 	ent = esp->active_cmd;
@@ -2514,9 +2514,9 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 			     ent->cmd, ent->cmd->cmnd[0]);
 	}
 	esp_dump_cmd_log(esp);
-	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	spin_unlock_irqrestore(&esp->host->host_lock, flags);
 
-	spin_lock_irqsave(esp->host->host_lock, flags);
+	spin_lock_irqsave(&esp->host->host_lock, flags);
 
 	ent = NULL;
 	list_for_each_entry(tmp, &esp->queued_cmds, list) {
@@ -2579,12 +2579,12 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 		goto out_failure;
 	}
 
-	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	spin_unlock_irqrestore(&esp->host->host_lock, flags);
 
 	if (!wait_for_completion_timeout(&eh_done, 5 * HZ)) {
-		spin_lock_irqsave(esp->host->host_lock, flags);
+		spin_lock_irqsave(&esp->host->host_lock, flags);
 		ent->eh_done = NULL;
-		spin_unlock_irqrestore(esp->host->host_lock, flags);
+		spin_unlock_irqrestore(&esp->host->host_lock, flags);
 
 		return FAILED;
 	}
@@ -2592,7 +2592,7 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 	return SUCCESS;
 
 out_success:
-	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	spin_unlock_irqrestore(&esp->host->host_lock, flags);
 	return SUCCESS;
 
 out_failure:
@@ -2600,7 +2600,7 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 	 * XXX since we know which target/lun in particular is
 	 * XXX causing trouble.
 	 */
-	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	spin_unlock_irqrestore(&esp->host->host_lock, flags);
 	return FAILED;
 }
 
@@ -2612,7 +2612,7 @@ static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 
 	init_completion(&eh_reset);
 
-	spin_lock_irqsave(esp->host->host_lock, flags);
+	spin_lock_irqsave(&esp->host->host_lock, flags);
 
 	esp->eh_reset = &eh_reset;
 
@@ -2624,14 +2624,14 @@ static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 	esp->flags |= ESP_FLAG_RESETTING;
 	scsi_esp_cmd(esp, ESP_CMD_RS);
 
-	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	spin_unlock_irqrestore(&esp->host->host_lock, flags);
 
 	ssleep(esp_bus_reset_settle);
 
 	if (!wait_for_completion_timeout(&eh_reset, 5 * HZ)) {
-		spin_lock_irqsave(esp->host->host_lock, flags);
+		spin_lock_irqsave(&esp->host->host_lock, flags);
 		esp->eh_reset = NULL;
-		spin_unlock_irqrestore(esp->host->host_lock, flags);
+		spin_unlock_irqrestore(&esp->host->host_lock, flags);
 
 		return FAILED;
 	}
@@ -2645,10 +2645,10 @@ static int esp_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	struct esp *esp = shost_priv(cmd->device->host);
 	unsigned long flags;
 
-	spin_lock_irqsave(esp->host->host_lock, flags);
+	spin_lock_irqsave(&esp->host->host_lock, flags);
 	esp_bootup_reset(esp);
 	esp_reset_cleanup(esp);
-	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	spin_unlock_irqrestore(&esp->host->host_lock, flags);
 
 	ssleep(esp_bus_reset_settle);
 
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 438ac7c3a9e3f..a2cf65fac2970 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2705,7 +2705,7 @@ static void fcoe_vport_remove(struct fc_lport *lport)
 	fc_host = shost_to_fc_host(shost);
 
 	/* Loop through all the vports and mark them for deletion */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
 		if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)) {
 			continue;
@@ -2715,7 +2715,7 @@ static void fcoe_vport_remove(struct fc_lport *lport)
 				   &vport->vport_delete_work);
 		}
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	flush_workqueue(fc_host_work_q(shost));
 }
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 22fbb0222f07d..b5766f752cdd8 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -273,7 +273,7 @@ static void fdomain_work(struct work_struct *work)
 	int status;
 	int done = 0;
 
-	spin_lock_irqsave(sh->host_lock, flags);
+	spin_lock_irqsave(&sh->host_lock, flags);
 
 	if (scsi_pointer->phase & in_arbitration) {
 		status = inb(fd->base + REG_ASTAT);
@@ -380,7 +380,7 @@ static void fdomain_work(struct work_struct *work)
 			     fd->base + REG_ICTL);
 	}
 out:
-	spin_unlock_irqrestore(sh->host_lock, flags);
+	spin_unlock_irqrestore(&sh->host_lock, flags);
 }
 
 static irqreturn_t fdomain_irq(int irq, void *dev_id)
@@ -416,7 +416,7 @@ static enum scsi_qc_status fdomain_queue(struct Scsi_Host *sh,
 	scsi_pointer->phase		= in_arbitration;
 	scsi_set_resid(cmd, scsi_bufflen(cmd));
 
-	spin_lock_irqsave(sh->host_lock, flags);
+	spin_lock_irqsave(&sh->host_lock, flags);
 
 	fd->cur_cmd = cmd;
 
@@ -431,7 +431,7 @@ static enum scsi_qc_status fdomain_queue(struct Scsi_Host *sh,
 	/* Start arbitration */
 	outb(ACTL_ARB | ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
 
-	spin_unlock_irqrestore(sh->host_lock, flags);
+	spin_unlock_irqrestore(&sh->host_lock, flags);
 
 	return 0;
 }
@@ -445,7 +445,7 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
 	if (!fd->cur_cmd)
 		return FAILED;
 
-	spin_lock_irqsave(sh->host_lock, flags);
+	spin_lock_irqsave(&sh->host_lock, flags);
 
 	fdomain_make_bus_idle(fd);
 	fdomain_scsi_pointer(fd->cur_cmd)->phase |= aborted;
@@ -453,7 +453,7 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
 	/* Aborts are not done well. . . */
 	set_host_byte(fd->cur_cmd, DID_ABORT);
 	fdomain_finish_cmd(fd);
-	spin_unlock_irqrestore(sh->host_lock, flags);
+	spin_unlock_irqrestore(&sh->host_lock, flags);
 	return SUCCESS;
 }
 
@@ -463,9 +463,9 @@ static int fdomain_host_reset(struct scsi_cmnd *cmd)
 	struct fdomain *fd = shost_priv(sh);
 	unsigned long flags;
 
-	spin_lock_irqsave(sh->host_lock, flags);
+	spin_lock_irqsave(&sh->host_lock, flags);
 	fdomain_reset(fd->base);
-	spin_unlock_irqrestore(sh->host_lock, flags);
+	spin_unlock_irqrestore(&sh->host_lock, flags);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 79bd64e12adc2..a29457f5adfbe 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -42,9 +42,9 @@ static irqreturn_t gvp11_intr(int irq, void *data)
 	if (!(status & GVP11_DMAC_INT_PENDING))
 		return IRQ_NONE;
 
-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(&instance->host_lock, flags);
 	wd33c93_intr(instance);
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(&instance->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 9610dd7aa85fb..e1ba791d0aac6 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -73,7 +73,7 @@ static struct class shost_class = {
  *	transition is illegal.
  **/
 int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
-	__must_hold(shost->host_lock)
+	__must_hold(&shost->host_lock)
 {
 	enum scsi_host_state oldstate = READ_ONCE(shost->shost_state);
 
@@ -168,14 +168,14 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	unsigned long flags;
 
 	mutex_lock(&shost->scan_mutex);
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_CANCEL))
 		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
+			spin_unlock_irqrestore(&shost->host_lock, flags);
 			mutex_unlock(&shost->scan_mutex);
 			return;
 		}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	scsi_autopm_get_host(shost);
 	flush_workqueue(shost->tmf_work_q);
@@ -193,10 +193,10 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
 	wait_for_completion(&shost->tagset_freed);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
@@ -277,7 +277,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto out_disable_runtime_pm;
 
-	scoped_guard(spinlock_irq, shost->host_lock)
+	scoped_guard(spinlock_irq, &shost->host_lock)
 		scsi_host_set_state(shost, SHOST_RUNNING);
 	get_device(shost->shost_gendev.parent);
 
@@ -413,8 +413,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	if (!shost)
 		return NULL;
 
-	shost->host_lock = &shost->default_lock;
-	scoped_guard(spinlock_init, shost->host_lock)
+	scoped_guard(spinlock_init, &shost->host_lock)
 		shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 7083c14c53028..a3afb3446bbba 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -385,9 +385,9 @@ static int iop_send_sync_msg(struct hptiop_hba *hba, u32 msg, u32 millisec)
 	hba->ops->post_msg(hba, msg);
 
 	for (i = 0; i < millisec; i++) {
-		spin_lock_irq(hba->host->host_lock);
+		spin_lock_irq(&hba->host->host_lock);
 		hba->ops->iop_intr(hba);
-		spin_unlock_irq(hba->host->host_lock);
+		spin_unlock_irq(&hba->host->host_lock);
 		if (hba->msg_done)
 			break;
 		msleep(1);
@@ -836,9 +836,9 @@ static irqreturn_t hptiop_intr(int irq, void *dev_id)
 	int  handled;
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	handled = hba->ops->iop_intr(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return handled;
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 93b9f699c2e53..0188fa714bd8f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -974,14 +974,14 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	if (rc)
 		dev_err(vhost->dev, "Error enabling adapter (rc=%d)\n", rc);
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	spin_lock(vhost->crq.q_lock);
 	vhost->do_enquiry = 1;
 	vhost->using_channels = 0;
 	vhost->do_scsi_login = 0;
 	vhost->do_nvme_login = 0;
 	spin_unlock(vhost->crq.q_lock);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
@@ -1013,7 +1013,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	spin_lock(vhost->crq.q_lock);
 	vhost->state = IBMVFC_NO_CRQ;
 	vhost->logged_in = 0;
@@ -1037,7 +1037,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 		dev_warn(vhost->dev, "Couldn't register crq (rc=%d)\n", rc);
 
 	spin_unlock(vhost->crq.q_lock);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
@@ -1250,9 +1250,9 @@ static void ibmvfc_reset_host(struct ibmvfc_host *vhost)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	__ibmvfc_reset_host(vhost);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 }
 
 /**
@@ -1318,9 +1318,9 @@ static struct ibmvfc_target *ibmvfc_get_target(struct scsi_target *starget)
 	struct ibmvfc_target *tgt;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	tgt = __ibmvfc_get_target(starget);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return tgt;
 }
 
@@ -1336,7 +1336,7 @@ static void ibmvfc_get_host_speed(struct Scsi_Host *shost)
 	struct ibmvfc_host *vhost = shost_priv(shost);
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (vhost->state == IBMVFC_ACTIVE) {
 		switch (be64_to_cpu(vhost->login_buf->resp.link_speed) / 100) {
 		case 1:
@@ -1365,7 +1365,7 @@ static void ibmvfc_get_host_speed(struct Scsi_Host *shost)
 		}
 	} else
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 /**
@@ -1380,7 +1380,7 @@ static void ibmvfc_get_host_port_state(struct Scsi_Host *shost)
 	struct ibmvfc_host *vhost = shost_priv(shost);
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	switch (vhost->state) {
 	case IBMVFC_INITIALIZING:
 	case IBMVFC_ACTIVE:
@@ -1404,7 +1404,7 @@ static void ibmvfc_get_host_port_state(struct Scsi_Host *shost)
 		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
 		break;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 /**
@@ -1642,9 +1642,9 @@ static void ibmvfc_locked_done(struct ibmvfc_event *evt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(evt->vhost->host->host_lock, flags);
+	spin_lock_irqsave(&evt->vhost->host->host_lock, flags);
 	evt->_done(evt);
-	spin_unlock_irqrestore(evt->vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&evt->vhost->host->host_lock, flags);
 }
 
 /**
@@ -1905,7 +1905,7 @@ static void ibmvfc_scsi_relogin(struct scsi_device *sdev)
 	struct ibmvfc_target *tgt;
 	unsigned long flags;
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (rport == tgt->rport) {
 			ibmvfc_del_tgt(tgt);
@@ -1914,7 +1914,7 @@ static void ibmvfc_scsi_relogin(struct scsi_device *sdev)
 	}
 
 	ibmvfc_reinit_host(vhost);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 }
 
 /**
@@ -2147,17 +2147,17 @@ static int ibmvfc_bsg_timeout(struct bsg_job *job)
 	int rc;
 
 	ENTER;
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	if (vhost->aborting_passthru || vhost->state != IBMVFC_ACTIVE) {
 		__ibmvfc_reset_host(vhost);
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return 0;
 	}
 
 	vhost->aborting_passthru = 1;
 	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return -ENOMEM;
 	}
 
@@ -2181,7 +2181,7 @@ static int ibmvfc_bsg_timeout(struct bsg_job *job)
 		dev_info(vhost->dev, "Cancelling passthru command to port id 0x%lx\n",
 			 port_id);
 
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	LEAVE;
 	return rc;
@@ -2205,7 +2205,7 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 	int rc = 0, issue_login = 1;
 
 	ENTER;
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->scsi_id == port_id) {
 			issue_login = 0;
@@ -2234,7 +2234,7 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 	init_completion(&evt->comp);
 
 	rc = ibmvfc_send_event(evt, vhost, default_timeout);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	if (rc)
 		return -EIO;
@@ -2244,10 +2244,10 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 	if (rsp_iu.plogi.common.status)
 		rc = -EIO;
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
 unlock_out:
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	LEAVE;
 	return rc;
 }
@@ -2332,17 +2332,17 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	if (issue_login)
 		rc = ibmvfc_bsg_plogi(vhost, port_id);
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 
 	if (unlikely(rc || (rport && (rc = fc_remote_port_chkready(rport)))) ||
 	    unlikely((rc = ibmvfc_host_chkready(vhost)))) {
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		goto out;
 	}
 
 	evt = ibmvfc_get_reserved_event(&vhost->crq);
 	if (!evt) {
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -2374,7 +2374,7 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	evt->sync_iu = &rsp_iu;
 	init_completion(&evt->comp);
 	rc = ibmvfc_send_event(evt, vhost, 0);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	if (rc) {
 		rc = -EIO;
@@ -2388,9 +2388,9 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	else
 		bsg_reply->reply_payload_rcv_len = rsp_len;
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	bsg_reply->result = rc;
 	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
@@ -2427,7 +2427,7 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 	unsigned long flags;
 	int rsp_code = 0;
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	if (vhost->state == IBMVFC_ACTIVE) {
 		if (vhost->using_channels)
 			evt = ibmvfc_get_event(&vhost->scsi_scrqs.scrqs[0]);
@@ -2435,7 +2435,7 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 			evt = ibmvfc_get_event(&vhost->crq);
 
 		if (!evt) {
-			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 			return -ENOMEM;
 		}
 
@@ -2452,7 +2452,7 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 		init_completion(&evt->comp);
 		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
 	}
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, sdev, "Failed to send %s reset event. rc=%d\n",
@@ -2479,9 +2479,9 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 	} else
 		sdev_printk(KERN_INFO, sdev, "%s reset successful\n", desc);
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	return rsp_rc;
 }
 
@@ -2583,7 +2583,7 @@ static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
 
 	do {
 		wait = 0;
-		spin_lock_irqsave(vhost->host->host_lock, flags);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
 		for (q_index = 0; q_index < q_size; q_index++) {
 			spin_lock(&queues[q_index].l_lock);
 			for (i = 0; i < queues[q_index].evt_pool.size; i++) {
@@ -2597,14 +2597,14 @@ static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
 			}
 			spin_unlock(&queues[q_index].l_lock);
 		}
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 		if (wait) {
 			timeout = wait_for_completion_timeout(&comp, timeout);
 
 			if (!timeout) {
 				wait = 0;
-				spin_lock_irqsave(vhost->host->host_lock, flags);
+				spin_lock_irqsave(&vhost->host->host_lock, flags);
 				for (q_index = 0; q_index < q_size; q_index++) {
 					spin_lock(&queues[q_index].l_lock);
 					for (i = 0; i < queues[q_index].evt_pool.size; i++) {
@@ -2618,7 +2618,7 @@ static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
 					}
 					spin_unlock(&queues[q_index].l_lock);
 				}
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				if (wait)
 					dev_err(vhost->dev, "Timed out waiting for aborted commands\n");
 				LEAVE;
@@ -2684,7 +2684,7 @@ static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
 	u16 status;
 
 	ENTER;
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	num_hwq = vhost->scsi_scrqs.active_queues;
 	for (i = 0; i < num_hwq; i++) {
 		spin_lock(queues[i].q_lock);
@@ -2702,7 +2702,7 @@ static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
 			evt = ibmvfc_init_tmf(&queues[i], sdev, type);
 			if (!evt) {
 				spin_unlock(queues[i].q_lock);
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				return -ENOMEM;
 			}
 			evt->sync_iu = &queues[i].cancel_rsp;
@@ -2712,7 +2712,7 @@ static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
 
 		spin_unlock(queues[i].q_lock);
 	}
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	if (list_empty(&cancelq)) {
 		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
@@ -2763,7 +2763,7 @@ static int ibmvfc_cancel_all_sq(struct scsi_device *sdev, int type)
 
 	ENTER;
 	found_evt = NULL;
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	spin_lock(&vhost->crq.l_lock);
 	list_for_each_entry(evt, &vhost->crq.sent, queue_list) {
 		if (evt->cmnd && evt->cmnd->device == sdev) {
@@ -2776,7 +2776,7 @@ static int ibmvfc_cancel_all_sq(struct scsi_device *sdev, int type)
 	if (!found_evt) {
 		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
 			sdev_printk(KERN_INFO, sdev, "No events found to cancel\n");
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return 0;
 	}
 
@@ -2786,7 +2786,7 @@ static int ibmvfc_cancel_all_sq(struct scsi_device *sdev, int type)
 		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
 	}
 
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, sdev, "Failed to send cancel event. rc=%d\n", rsp_rc);
@@ -2800,9 +2800,9 @@ static int ibmvfc_cancel_all_sq(struct scsi_device *sdev, int type)
 
 	wait_for_completion(&evt->comp);
 	status = be16_to_cpu(rsp.mad_common.status);
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	if (status != IBMVFC_MAD_SUCCESS) {
 		sdev_printk(KERN_WARNING, sdev, "Cancel failed with rc=%x\n", status);
@@ -2899,7 +2899,7 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 	int rsp_code = 0;
 
 	found_evt = NULL;
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	spin_lock(&vhost->crq.l_lock);
 	list_for_each_entry(evt, &vhost->crq.sent, queue_list) {
 		if (evt->cmnd && evt->cmnd->device == sdev) {
@@ -2912,14 +2912,14 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 	if (!found_evt) {
 		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
 			sdev_printk(KERN_INFO, sdev, "No events found to abort\n");
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return 0;
 	}
 
 	if (vhost->state == IBMVFC_ACTIVE) {
 		evt = ibmvfc_get_event(&vhost->crq);
 		if (!evt) {
-			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 			return -ENOMEM;
 		}
 		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
@@ -2938,7 +2938,7 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
 	}
 
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, sdev, "Failed to send abort. rc=%d\n", rsp_rc);
@@ -2967,9 +2967,9 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 
 			rc = ibmvfc_wait_for_ops(vhost, evt, ibmvfc_match_evt);
 			if (rc != SUCCESS) {
-				spin_lock_irqsave(vhost->host->host_lock, flags);
+				spin_lock_irqsave(&vhost->host->host_lock, flags);
 				ibmvfc_hard_reset_host(vhost);
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				rsp_rc = 0;
 			}
 
@@ -2994,9 +2994,9 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 		sdev_printk(KERN_INFO, sdev, "Abort successful\n");
 
 out:
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	return rsp_rc;
 }
 
@@ -3176,7 +3176,7 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 	if (rc == FAILED)
 		ibmvfc_issue_fc_host_lip(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	found = 0;
 	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
 		if (tgt->scsi_id == rport->port_id) {
@@ -3195,7 +3195,7 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 		ibmvfc_reinit_host(vhost);
 	}
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	LEAVE;
 }
 
@@ -3468,7 +3468,7 @@ static int ibmvfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	struct ibmvfc_host *vhost = shost_priv(shost);
 	int done = 0;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (!vhost->scan_timeout)
 		done = 1;
 	else if (time >= (vhost->scan_timeout * HZ)) {
@@ -3481,7 +3481,7 @@ static int ibmvfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 		vhost->scan_timeout = init_timeout;
 		done = 1;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return done;
 }
 
@@ -3505,9 +3505,9 @@ static int ibmvfc_sdev_init(struct scsi_device *sdev)
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	sdev->hostdata = (void *)(unsigned long)vhost->task_set++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return 0;
 }
 
@@ -3527,9 +3527,9 @@ static int ibmvfc_target_alloc(struct scsi_target *starget)
 	struct ibmvfc_host *vhost = shost_priv(shost);
 	unsigned long flags = 0;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	starget->hostdata = (void *)(unsigned long)vhost->task_set++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return 0;
 }
 
@@ -3550,12 +3550,12 @@ static int ibmvfc_sdev_configure(struct scsi_device *sdev,
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags = 0;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
 		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return 0;
 }
 
@@ -3646,9 +3646,9 @@ static ssize_t ibmvfc_show_log_level(struct device *dev,
 	unsigned long flags = 0;
 	int len;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	len = sysfs_emit(buf, "%d\n", vhost->log_level);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return len;
 }
 
@@ -3670,9 +3670,9 @@ static ssize_t ibmvfc_store_log_level(struct device *dev,
 	struct ibmvfc_host *vhost = shost_priv(shost);
 	unsigned long flags = 0;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	vhost->log_level = simple_strtoul(buf, NULL, 10);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return strlen(buf);
 }
 
@@ -3685,9 +3685,9 @@ static ssize_t ibmvfc_show_scsi_channels(struct device *dev,
 	unsigned long flags = 0;
 	int len;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	len = sysfs_emit(buf, "%d\n", scsi->desired_queues);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return len;
 }
 
@@ -3701,11 +3701,11 @@ static ssize_t ibmvfc_store_scsi_channels(struct device *dev,
 	unsigned long flags = 0;
 	unsigned int channels;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	channels = simple_strtoul(buf, NULL, 10);
 	scsi->desired_queues = min(channels, shost->nr_hw_queues);
 	ibmvfc_hard_reset_host(vhost);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return strlen(buf);
 }
 
@@ -3751,9 +3751,9 @@ static ssize_t ibmvfc_read_trace(struct file *filp, struct kobject *kobj,
 		count = size;
 	}
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	memcpy(buf, &src[off], count);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return count;
 }
 
@@ -3864,10 +3864,10 @@ static irqreturn_t ibmvfc_interrupt(int irq, void *dev_instance)
 	struct ibmvfc_host *vhost = (struct ibmvfc_host *)dev_instance;
 	unsigned long flags;
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	vio_disable_interrupts(to_vio_dev(vhost->dev));
 	tasklet_schedule(&vhost->tasklet);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -3889,7 +3889,7 @@ static void ibmvfc_tasklet(void *data)
 	int done = 0;
 	LIST_HEAD(evt_doneq);
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	spin_lock(vhost->crq.q_lock);
 	while (!done) {
 		/* Pull all the valid messages off the async CRQ */
@@ -3922,7 +3922,7 @@ static void ibmvfc_tasklet(void *data)
 	}
 
 	spin_unlock(vhost->crq.q_lock);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	list_for_each_entry_safe(evt, temp, &evt_doneq, queue_list) {
 		timer_delete(&evt->timer);
@@ -4776,12 +4776,12 @@ static void ibmvfc_adisc_timeout(struct timer_list *t)
 	int rc;
 
 	tgt_dbg(tgt, "ADISC timeout\n");
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	if (vhost->abort_threads >= disc_threads ||
 	    tgt->action != IBMVFC_TGT_ACTION_INIT_WAIT ||
 	    vhost->state != IBMVFC_INITIALIZING ||
 	    vhost->action != IBMVFC_HOST_ACTION_QUERY_TGTS) {
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return;
 	}
 
@@ -4793,7 +4793,7 @@ static void ibmvfc_adisc_timeout(struct timer_list *t)
 		vhost->abort_threads--;
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 		__ibmvfc_reset_host(vhost);
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return;
 	}
 	ibmvfc_init_event(evt, ibmvfc_tgt_adisc_cancel_done, IBMVFC_MAD_FORMAT);
@@ -4821,7 +4821,7 @@ static void ibmvfc_adisc_timeout(struct timer_list *t)
 		__ibmvfc_reset_host(vhost);
 	} else
 		tgt_dbg(tgt, "Attempting to cancel ADISC\n");
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 }
 
 /**
@@ -5009,7 +5009,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 		channels = &vhost->nvme_scrqs;
 
 	/* Look to see if we already have a target allocated for this SCSI ID or WWPN */
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	list_for_each_entry(tgt, &channels->targets, queue) {
 		if (tgt->wwpn == wwpn) {
 			wtgt = tgt;
@@ -5061,7 +5061,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 			ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
 		goto unlock_out;
 	}
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	tgt = mempool_alloc(vhost->tgt_pool, GFP_NOIO);
 	memset(tgt, 0, sizeof(*tgt));
@@ -5073,12 +5073,12 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 	timer_setup(&tgt->timer, ibmvfc_adisc_timeout, 0);
 	kref_init(&tgt->kref);
 	ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	tgt->cancel_key = vhost->task_set++;
 	list_add_tail(&tgt->queue, &channels->targets);
 
 unlock_out:
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	return 0;
 }
 
@@ -5852,9 +5852,9 @@ static int ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 	unsigned long flags;
 	int rc;
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	rc = __ibmvfc_work_to_do(vhost);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	return rc;
 }
 
@@ -5889,14 +5889,14 @@ static void ibmvfc_tgt_add_nvme_rport(struct ibmvfc_target *tgt)
 
 	tgt_dbg(tgt, "Adding NVMe rport\n");
 	ibmvfc_nvme_register_remoteport(tgt);
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	rport = tgt->nvme_remote_port;
 
 	if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
 		tgt_dbg(tgt, "Deleting NVMe rport\n");
 		list_del(&tgt->queue);
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		ibmvfc_nvme_unregister_remoteport(tgt);
 		timer_delete_sync(&tgt->timer);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
@@ -5905,11 +5905,11 @@ static void ibmvfc_tgt_add_nvme_rport(struct ibmvfc_target *tgt)
 		tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
 		tgt->init_retries = 0;
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		ibmvfc_nvme_unregister_remoteport(tgt);
 		return;
 	} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DELETED_RPORT) {
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return;
 	}
 
@@ -5918,7 +5918,7 @@ static void ibmvfc_tgt_add_nvme_rport(struct ibmvfc_target *tgt)
 		tgt->target_id = tgt->nvme_remote_port->port_id;
 	} else
 		tgt_dbg(tgt, "NVMe rport add failed\n");
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 }
 
 /**
@@ -5934,13 +5934,13 @@ static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
 
 	tgt_dbg(tgt, "Adding rport\n");
 	rport = fc_remote_port_add(vhost->host, 0, &tgt->ids);
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 
 	if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
 		tgt_dbg(tgt, "Deleting rport\n");
 		list_del(&tgt->queue);
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		fc_remote_port_delete(rport);
 		timer_delete_sync(&tgt->timer);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
@@ -5950,11 +5950,11 @@ static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
 		tgt->rport = NULL;
 		tgt->init_retries = 0;
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		fc_remote_port_delete(rport);
 		return;
 	} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DELETED_RPORT) {
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		return;
 	}
 
@@ -5972,7 +5972,7 @@ static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
 			rport->supported_classes |= FC_COS_CLASS3;
 	} else
 		tgt_dbg(tgt, "rport add failed\n");
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 }
 
 /**
@@ -5990,7 +5990,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 	int rc;
 
 	ibmvfc_log_ae(vhost, vhost->events_to_log);
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	vhost->events_to_log = 0;
 	switch (vhost->action) {
 	case IBMVFC_HOST_ACTION_NONE:
@@ -5999,12 +5999,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	case IBMVFC_HOST_ACTION_RESET:
 		list_splice_init(&vhost->purge, &purge);
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		ibmvfc_complete_purge(&purge);
 		ibmvfc_nvme_unregister(vhost);
 		rc = ibmvfc_reset_crq(vhost);
 
-		spin_lock_irqsave(vhost->host->host_lock, flags);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
 		if (!rc || rc == H_CLOSED)
 			vio_enable_interrupts(to_vio_dev(vhost->dev));
 		if (vhost->action == IBMVFC_HOST_ACTION_RESET) {
@@ -6025,11 +6025,11 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	case IBMVFC_HOST_ACTION_REENABLE:
 		list_splice_init(&vhost->purge, &purge);
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		ibmvfc_complete_purge(&purge);
 		rc = ibmvfc_reenable_crq_queue(vhost);
 
-		spin_lock_irqsave(vhost->host->host_lock, flags);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
 		if (vhost->action == IBMVFC_HOST_ACTION_REENABLE) {
 			/*
 			 * The only action we could have changed to would have
@@ -6051,7 +6051,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		BUG_ON(vhost->state != IBMVFC_INITIALIZING);
 		if (vhost->delay_init) {
 			vhost->delay_init = 0;
-			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 			ssleep(15);
 			return;
 		} else
@@ -6097,7 +6097,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		}
 
 		if (ibmvfc_dev_logo_to_do(vhost)) {
-			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 			return;
 		}
 
@@ -6108,7 +6108,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				tgt->rport = NULL;
 				list_del(&tgt->queue);
 				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				if (rport)
 					fc_remote_port_delete(rport);
 				timer_delete_sync(&tgt->timer);
@@ -6132,7 +6132,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				 */
 				if (rport && rport->fast_io_fail_tmo == -1)
 					tgt->move_login = 1;
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				if (rport)
 					fc_remote_port_delete(rport);
 				return;
@@ -6145,7 +6145,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				nvme_rport = tgt->nvme_remote_port;
 				list_del(&tgt->queue);
 				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				if (nvme_rport)
 					ibmvfc_nvme_unregister_remoteport(tgt);
 				timer_delete_sync(&tgt->timer);
@@ -6156,7 +6156,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				nvme_rport = tgt->nvme_remote_port;
 				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
 				tgt->init_retries = 0;
-				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				if (nvme_rport)
 					ibmvfc_nvme_unregister_remoteport(tgt);
 				return;
@@ -6169,14 +6169,14 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 					vhost->reinit = 0;
 					scsi_block_requests(vhost->host);
 					ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
-					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				} else {
 					ibmvfc_set_host_state(vhost, IBMVFC_ACTIVE);
 					ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
 					wake_up(&vhost->init_wait_q);
 					schedule_work(&vhost->rport_add_work_q);
 					vhost->init_retries = 0;
-					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 					scsi_unblock_requests(vhost->host);
 				}
 
@@ -6187,7 +6187,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 			}
 		} else {
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
-			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 			scsi_unblock_requests(vhost->host);
 			wake_up(&vhost->init_wait_q);
 			return;
@@ -6195,9 +6195,9 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	case IBMVFC_HOST_ACTION_ALLOC_TGTS:
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_INIT);
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 		ibmvfc_alloc_targets(vhost);
-		spin_lock_irqsave(vhost->host->host_lock, flags);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
 		break;
 	case IBMVFC_HOST_ACTION_TGT_INIT:
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
@@ -6220,7 +6220,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	}
 
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 }
 
 /**
@@ -6753,7 +6753,7 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 	int did_work;
 
 	ENTER;
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	do {
 		did_work = 0;
 		if (vhost->state != IBMVFC_ACTIVE)
@@ -6766,19 +6766,19 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 				kref_get(&tgt->kref);
 				rport = tgt->rport;
 				if (!rport) {
-					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 					ibmvfc_tgt_add_rport(tgt);
 				} else if (get_device(&rport->dev)) {
-					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 					tgt_dbg(tgt, "Setting rport roles\n");
 					fc_remote_port_rolechg(rport, tgt->ids.roles);
 					put_device(&rport->dev);
 				} else {
-					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 				}
 
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
-				spin_lock_irqsave(vhost->host->host_lock, flags);
+				spin_lock_irqsave(&vhost->host->host_lock, flags);
 				break;
 			}
 		}
@@ -6790,16 +6790,16 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 				kref_get(&tgt->kref);
 				nvme_rport = tgt->nvme_remote_port;
 				if (!nvme_rport) {
-					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 					ibmvfc_tgt_add_nvme_rport(tgt);
 				} else {
-					spin_unlock_irqrestore(vhost->host->host_lock, flags);
+					spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 					if (IS_ENABLED(CONFIG_NVME_FC))
 						nvme_fc_rescan_remoteport(nvme_rport);
 				}
 
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
-				spin_lock_irqsave(vhost->host->host_lock, flags);
+				spin_lock_irqsave(&vhost->host->host_lock, flags);
 				break;
 			}
 		}
@@ -6807,7 +6807,7 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 
 	if (vhost->state == IBMVFC_ACTIVE)
 		vhost->scan_complete = 1;
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	LEAVE;
 }
 
@@ -6945,9 +6945,9 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	ENTER;
 	ibmvfc_remove_trace_file(&vhost->host->shost_dev.kobj, &ibmvfc_trace_attr);
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	ibmvfc_wait_while_resetting(vhost);
 	kthread_stop(vhost->work_thread);
@@ -6955,10 +6955,10 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	fc_remove_host(vhost->host);
 	scsi_remove_host(vhost->host);
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_purge_requests(vhost, DID_ERROR);
 	list_splice_init(&vhost->purge, &purge);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	ibmvfc_complete_purge(&purge);
 	ibmvfc_release_sub_crqs(vhost);
 	ibmvfc_release_crq_queue(vhost);
@@ -6985,10 +6985,10 @@ static int ibmvfc_resume(struct device *dev)
 	struct ibmvfc_host *vhost = dev_get_drvdata(dev);
 	struct vio_dev *vdev = to_vio_dev(dev);
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	vio_disable_interrupts(vdev);
 	tasklet_schedule(&vhost->tasklet);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 54f80b6265d45..9ac2671a3567d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -208,7 +208,7 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	if (!vhost->logged_in || !evt)
 		return;
 
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	kref_get(&tgt->kref);
 	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
 	ibmvfc_init_ls_abort(evt, ls_abort);
@@ -217,14 +217,14 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	if (ibmvfc_send_event(evt, vhost, default_timeout))
 		goto out;
 
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	wait_for_completion(&evt->comp);
 	status = be16_to_cpu(rsp.mad_common.status);
-	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
 out:
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	ibmvfc_dbg(vhost, "ls_abort: cancel failed with rc=%x\n", status);
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 609bda730b3a8..4ecd3db088751 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -785,13 +785,13 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 	struct srp_event_struct *evt;
 	unsigned long flags;
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	while (!list_empty(&hostdata->sent)) {
 		evt = list_first_entry(&hostdata->sent, struct srp_event_struct, list);
 		list_del(&evt->list);
 		timer_delete(&evt->timer);
 
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 		if (evt->cmnd) {
 			evt->cmnd->result = (error_code << 16);
 			unmap_cmd_data(&evt->iu.srp.cmd, evt,
@@ -802,9 +802,9 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
 			evt->done(evt);
 		free_event_struct(&evt->hostdata->pool, evt);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	}
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 }
 
 /**
@@ -818,9 +818,9 @@ static void ibmvscsi_set_request_limit(struct ibmvscsi_host_data *hostdata, int
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	atomic_set(&hostdata->request_limit, limit);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 }
 
 /**
@@ -1221,9 +1221,9 @@ static int send_srp_login(struct ibmvscsi_host_data *hostdata)
 	 */
 	ibmvscsi_set_request_limit(hostdata, 0);
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, login_timeout * 2);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 	dev_info(hostdata->dev, "sent SRP login\n");
 	return rc;
 };
@@ -1317,10 +1317,10 @@ static void send_mad_capabilities(struct ibmvscsi_host_data *hostdata)
 		req->common.length = cpu_to_be16(sizeof(hostdata->caps) -
 						sizeof(hostdata->caps.reserve));
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	if (ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2))
 		dev_err(hostdata->dev, "couldn't send CAPABILITIES_REQ!\n");
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 };
 
 /**
@@ -1373,9 +1373,9 @@ static int enable_fast_fail(struct ibmvscsi_host_data *hostdata)
 	fast_fail_mad->common.type = cpu_to_be32(VIOSRP_ENABLE_FAST_FAIL);
 	fast_fail_mad->common.length = cpu_to_be16(sizeof(*fast_fail_mad));
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 	return rc;
 }
 
@@ -1454,10 +1454,10 @@ static void send_mad_adapter_info(struct ibmvscsi_host_data *hostdata)
 	req->common.length = cpu_to_be16(sizeof(hostdata->madapter_info));
 	req->buffer = cpu_to_be64(hostdata->adapter_info_addr);
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	if (ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2))
 		dev_err(hostdata->dev, "couldn't send ADAPTER_INFO_REQ!\n");
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 };
 
 /*
@@ -1502,7 +1502,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 	/* First, find this command in our sent list so we can figure
 	 * out the correct tag
 	 */
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	wait_switch = jiffies + (init_timeout * HZ);
 	do {
 		found_evt = NULL;
@@ -1514,13 +1514,13 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 		}
 
 		if (!found_evt) {
-			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 			return SUCCESS;
 		}
 
 		evt = get_event_struct(&hostdata->pool);
 		if (evt == NULL) {
-			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 			sdev_printk(KERN_ERR, cmd->device,
 				"failed to allocate abort event\n");
 			return FAILED;
@@ -1548,12 +1548,12 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
 			break;
 
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 		msleep(10);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	} while (time_before(jiffies, wait_switch));
 
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, cmd->device,
@@ -1592,7 +1592,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 	 * The event is no longer in our list.  Make sure it didn't
 	 * complete while we were aborting
 	 */
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	found_evt = NULL;
 	list_for_each_entry(tmp_evt, &hostdata->sent, list) {
 		if (tmp_evt->cmnd == cmd) {
@@ -1602,7 +1602,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 	}
 
 	if (found_evt == NULL) {
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 		sdev_printk(KERN_INFO, cmd->device, "aborted task tag 0x%llx completed\n",
 			    tsk_mgmt->task_tag);
 		return SUCCESS;
@@ -1616,7 +1616,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 	unmap_cmd_data(&found_evt->iu.srp.cmd, found_evt,
 		       found_evt->hostdata->dev);
 	free_event_struct(&found_evt->hostdata->pool, found_evt);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 	atomic_inc(&hostdata->request_limit);
 	return SUCCESS;
 }
@@ -1638,12 +1638,12 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	u16 lun = lun_from_dev(cmd->device);
 	unsigned long wait_switch = 0;
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	wait_switch = jiffies + (init_timeout * HZ);
 	do {
 		evt = get_event_struct(&hostdata->pool);
 		if (evt == NULL) {
-			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 			sdev_printk(KERN_ERR, cmd->device,
 				"failed to allocate reset event\n");
 			return FAILED;
@@ -1670,12 +1670,12 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
 			break;
 
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 		msleep(10);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	} while (time_before(jiffies, wait_switch));
 
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, cmd->device,
@@ -1712,7 +1712,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	/* We need to find all commands for this LUN that have not yet been
 	 * responded to, and fail them with DID_RESET
 	 */
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
 		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == cmd->device)) {
 			if (tmp_evt->cmnd)
@@ -1729,7 +1729,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 				tmp_evt->done(tmp_evt);
 		}
 	}
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 	return SUCCESS;
 }
 
@@ -1855,10 +1855,10 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 	 * Lock the host_lock before messing with these structures, since we
 	 * are running in a task context
 	 */
-	spin_lock_irqsave(evt_struct->hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&evt_struct->hostdata->host->host_lock, flags);
 	list_del(&evt_struct->list);
 	free_event_struct(&evt_struct->hostdata->pool, evt_struct);
-	spin_unlock_irqrestore(evt_struct->hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&evt_struct->hostdata->host->host_lock, flags);
 }
 
 /**
@@ -1876,12 +1876,12 @@ static int ibmvscsi_sdev_configure(struct scsi_device *sdev,
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long lock_flags = 0;
 
-	spin_lock_irqsave(shost->host_lock, lock_flags);
+	spin_lock_irqsave(&shost->host_lock, lock_flags);
 	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
 		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
 	}
-	spin_unlock_irqrestore(shost->host_lock, lock_flags);
+	spin_unlock_irqrestore(&shost->host_lock, lock_flags);
 	return 0;
 }
 
@@ -2131,35 +2131,35 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 	int rc;
 	char *action = "reset";
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	switch (hostdata->action) {
 	case IBMVSCSI_HOST_ACTION_UNBLOCK:
 		rc = 0;
 		break;
 	case IBMVSCSI_HOST_ACTION_RESET:
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 		rc = ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
 		if (!rc)
 			rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
 		vio_enable_interrupts(to_vio_dev(hostdata->dev));
 		break;
 	case IBMVSCSI_HOST_ACTION_REENABLE:
 		action = "enable";
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 		rc = ibmvscsi_reenable_crq_queue(&hostdata->queue, hostdata);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
 		if (!rc)
 			rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
 		break;
 	case IBMVSCSI_HOST_ACTION_NONE:
 	default:
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 		return;
 	}
 
 	hostdata->action = IBMVSCSI_HOST_ACTION_NONE;
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 
 	if (rc) {
 		ibmvscsi_set_request_limit(hostdata, -1);
@@ -2191,9 +2191,9 @@ static int ibmvscsi_work_to_do(struct ibmvscsi_host_data *hostdata)
 	unsigned long flags;
 	int rc;
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
 	rc = __ibmvscsi_work_to_do(hostdata);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
 
 	return rc;
 }
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 0535252e77e3b..680399bc866dd 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -781,10 +781,10 @@ static void imm_interrupt(struct work_struct *work)
 
 	imm_pb_dismiss(dev);
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	dev->cur_cmd = NULL;
 	scsi_done(cmd);
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 	return;
 }
 
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 06fbe85dccfa6..da2670cd7edf3 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2507,9 +2507,9 @@ static irqreturn_t i91u_intr(int irqno, void *dev_id)
 	unsigned long flags;
 	int r;
 	
-	spin_lock_irqsave(dev->host_lock, flags);
+	spin_lock_irqsave(&dev->host_lock, flags);
 	r = initio_isr((struct initio_host *)dev->hostdata);
-	spin_unlock_irqrestore(dev->host_lock, flags);
+	spin_unlock_irqrestore(&dev->host_lock, flags);
 	if (r)
 		return IRQ_HANDLED;
 	else
@@ -2635,9 +2635,9 @@ static int i91u_bus_reset(struct scsi_cmnd * cmnd)
 
 	host = (struct initio_host *) cmnd->device->host->hostdata;
 
-	spin_lock_irq(cmnd->device->host->host_lock);
+	spin_lock_irq(&cmnd->device->host->host_lock);
 	initio_reset_scsi(host, 0);
-	spin_unlock_irq(cmnd->device->host->host_lock);
+	spin_unlock_irq(&cmnd->device->host->host_lock);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d207e5e81afe0..1dc492092fe53 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -612,9 +612,9 @@ static void ipr_lock_and_done(struct ipr_cmnd *ipr_cmd)
 	unsigned long lock_flags;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	ipr_cmd->done(ipr_cmd);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 }
 
 /**
@@ -1022,9 +1022,9 @@ static void ipr_send_blocking_cmd(struct ipr_cmnd *ipr_cmd,
 	init_completion(&ipr_cmd->completion);
 	ipr_do_req(ipr_cmd, ipr_internal_cmd_done, timeout_func, timeout);
 
-	spin_unlock_irq(ioa_cfg->host->host_lock);
+	spin_unlock_irq(&ioa_cfg->host->host_lock);
 	wait_for_completion(&ipr_cmd->completion);
-	spin_lock_irq(ioa_cfg->host->host_lock);
+	spin_lock_irq(&ioa_cfg->host->host_lock);
 }
 
 static int ipr_get_hrrq_index(struct ipr_ioa_cfg *ioa_cfg)
@@ -2594,7 +2594,7 @@ static void ipr_timeout(struct timer_list *t)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
 	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	ioa_cfg->errors_logged++;
 	dev_err(&ioa_cfg->pdev->dev,
@@ -2606,7 +2606,7 @@ static void ipr_timeout(struct timer_list *t)
 	if (!ioa_cfg->in_reset_reload || ioa_cfg->reset_cmd == ipr_cmd)
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	LEAVE;
 }
 
@@ -2627,7 +2627,7 @@ static void ipr_oper_timeout(struct timer_list *t)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
 	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	ioa_cfg->errors_logged++;
 	dev_err(&ioa_cfg->pdev->dev,
@@ -2642,7 +2642,7 @@ static void ipr_oper_timeout(struct timer_list *t)
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
 	}
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	LEAVE;
 }
 
@@ -2910,7 +2910,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
 		rem_page_len = PAGE_SIZE - ioa_dump->page_offset;
 		cur_len = min(rem_len, rem_page_len);
 
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 		if (ioa_cfg->sdt_state == ABORT_DUMP) {
 			rc = -EIO;
 		} else {
@@ -2919,7 +2919,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
 							&page[ioa_dump->page_offset / 4],
 							(cur_len / sizeof(u32)));
 		}
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 		if (!rc) {
 			ioa_dump->page_offset += cur_len;
@@ -3060,17 +3060,17 @@ static void ipr_get_ioa_dump(struct ipr_ioa_cfg *ioa_cfg, struct ipr_dump *dump)
 
 	ENTER;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	if (ioa_cfg->sdt_state != READ_DUMP) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return;
 	}
 
 	if (ioa_cfg->sis64) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		ssleep(IPR_DUMP_DELAY_SECONDS);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	}
 
 	start_addr = readl(ioa_cfg->ioa_mailbox);
@@ -3078,7 +3078,7 @@ static void ipr_get_ioa_dump(struct ipr_ioa_cfg *ioa_cfg, struct ipr_dump *dump)
 	if (!ioa_cfg->sis64 && !ipr_sdt_is_fmt2(start_addr)) {
 		dev_err(&ioa_cfg->pdev->dev,
 			"Invalid dump table format: %lx\n", start_addr);
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return;
 	}
 
@@ -3135,7 +3135,7 @@ static void ipr_get_ioa_dump(struct ipr_ioa_cfg *ioa_cfg, struct ipr_dump *dump)
 			rc, be32_to_cpu(sdt->hdr.state));
 		driver_dump->hdr.status = IPR_DUMP_STATUS_FAILED;
 		ioa_cfg->sdt_state = DUMP_OBTAINED;
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return;
 	}
 
@@ -3151,7 +3151,7 @@ static void ipr_get_ioa_dump(struct ipr_ioa_cfg *ioa_cfg, struct ipr_dump *dump)
 	else
 		dump->driver_dump.hdr.len += max_num_entries * sizeof(struct ipr_sdt_entry);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	for (i = 0; i < num_entries; i++) {
 		if (ioa_dump->hdr.len > max_dump_size) {
@@ -3220,10 +3220,10 @@ static void ipr_release_dump(struct kref *kref)
 	int i;
 
 	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	ioa_cfg->dump = NULL;
 	ioa_cfg->sdt_state = INACTIVE;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
 		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
@@ -3244,13 +3244,13 @@ static void ipr_add_remove_thread(struct work_struct *work)
 	int did_work;
 
 	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 restart:
 	do {
 		did_work = 0;
 		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds) {
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+			spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 			return;
 		}
 
@@ -3263,10 +3263,10 @@ static void ipr_add_remove_thread(struct work_struct *work)
 						list_move_tail(&res->queue, &ioa_cfg->free_res_q);
 					else
 						res->del_from_ml = 0;
-					spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+					spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 					scsi_remove_device(sdev);
 					scsi_device_put(sdev);
-					spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+					spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 				}
 				break;
 			}
@@ -3279,15 +3279,15 @@ static void ipr_add_remove_thread(struct work_struct *work)
 			target = res->target;
 			lun = res->lun;
 			res->add_to_ml = 0;
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+			spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 			scsi_add_device(ioa_cfg->host, bus, target, lun);
-			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+			spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 			goto restart;
 		}
 	}
 
 	ioa_cfg->scan_done = 1;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	kobject_uevent(&ioa_cfg->host->shost_dev.kobj, KOBJ_CHANGE);
 	LEAVE;
 }
@@ -3311,44 +3311,44 @@ static void ipr_worker_thread(struct work_struct *work)
 		container_of(work, struct ipr_ioa_cfg, work_q);
 
 	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	if (ioa_cfg->sdt_state == READ_DUMP) {
 		dump = ioa_cfg->dump;
 		if (!dump) {
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+			spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 			return;
 		}
 		kref_get(&dump->kref);
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		ipr_get_ioa_dump(ioa_cfg, dump);
 		kref_put(&dump->kref, ipr_release_dump);
 
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 		if (ioa_cfg->sdt_state == DUMP_OBTAINED && !ioa_cfg->dump_timeout)
 			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return;
 	}
 
 	if (ioa_cfg->scsi_unblock) {
 		ioa_cfg->scsi_unblock = 0;
 		ioa_cfg->scsi_blocked = 0;
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		scsi_unblock_requests(ioa_cfg->host);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 		if (ioa_cfg->scsi_blocked)
 			scsi_block_requests(ioa_cfg->host);
 	}
 
 	if (!ioa_cfg->scan_enabled) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return;
 	}
 
 	schedule_work(&ioa_cfg->scsi_add_work_q);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	LEAVE;
 }
 
@@ -3375,10 +3375,10 @@ static ssize_t ipr_read_trace(struct file *filp, struct kobject *kobj,
 	unsigned long lock_flags = 0;
 	ssize_t ret;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	ret = memory_read_from_buffer(buf, count, &off, ioa_cfg->trace,
 				IPR_TRACE_SIZE);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	return ret;
 }
@@ -3411,12 +3411,12 @@ static ssize_t ipr_show_fw_version(struct device *dev,
 	unsigned long lock_flags = 0;
 	int len;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	len = snprintf(buf, PAGE_SIZE, "%02X%02X%02X%02X\n",
 		       ucode_vpd->major_release, ucode_vpd->card_type,
 		       ucode_vpd->minor_release[0],
 		       ucode_vpd->minor_release[1]);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -3445,9 +3445,9 @@ static ssize_t ipr_show_log_level(struct device *dev,
 	unsigned long lock_flags = 0;
 	int len;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	len = snprintf(buf, PAGE_SIZE, "%d\n", ioa_cfg->log_level);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -3469,9 +3469,9 @@ static ssize_t ipr_store_log_level(struct device *dev,
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 	unsigned long lock_flags = 0;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	ioa_cfg->log_level = simple_strtoul(buf, NULL, 10);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return strlen(buf);
 }
 
@@ -3509,31 +3509,31 @@ static ssize_t ipr_store_diagnostics(struct device *dev,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	while (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	}
 
 	ioa_cfg->errors_logged = 0;
 	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NORMAL);
 
 	if (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 
 		/* Wait for a second for any errors to be logged */
 		msleep(1000);
 	} else {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return -EIO;
 	}
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	if (ioa_cfg->in_reset_reload || ioa_cfg->errors_logged)
 		rc = -EIO;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	return rc;
 }
@@ -3563,12 +3563,12 @@ static ssize_t ipr_show_adapter_state(struct device *dev,
 	unsigned long lock_flags = 0;
 	int len;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead)
 		len = snprintf(buf, PAGE_SIZE, "offline\n");
 	else
 		len = snprintf(buf, PAGE_SIZE, "online\n");
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -3596,7 +3596,7 @@ static ssize_t ipr_store_adapter_state(struct device *dev,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead &&
 	    !strncmp(buf, "online", 6)) {
 		for (i = 0; i < ioa_cfg->hrrq_num; i++) {
@@ -3609,7 +3609,7 @@ static ssize_t ipr_store_adapter_state(struct device *dev,
 		ioa_cfg->in_ioa_bringdown = 0;
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
 	}
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 
 	return result;
@@ -3648,10 +3648,10 @@ static ssize_t ipr_store_reset_adapter(struct device *dev,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	if (!ioa_cfg->in_reset_reload)
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NORMAL);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 
 	return result;
@@ -3683,9 +3683,9 @@ static ssize_t ipr_show_iopoll_weight(struct device *dev,
 	unsigned long lock_flags = 0;
 	int len;
 
-	spin_lock_irqsave(shost->host_lock, lock_flags);
+	spin_lock_irqsave(&shost->host_lock, lock_flags);
 	len = snprintf(buf, PAGE_SIZE, "%d\n", ioa_cfg->iopoll_weight);
-	spin_unlock_irqrestore(shost->host_lock, lock_flags);
+	spin_unlock_irqrestore(&shost->host_lock, lock_flags);
 
 	return len;
 }
@@ -3732,7 +3732,7 @@ static ssize_t ipr_store_iopoll_weight(struct device *dev,
 			irq_poll_disable(&ioa_cfg->hrrq[i].iopoll);
 	}
 
-	spin_lock_irqsave(shost->host_lock, lock_flags);
+	spin_lock_irqsave(&shost->host_lock, lock_flags);
 	ioa_cfg->iopoll_weight = user_iopoll_weight;
 	if (ioa_cfg->iopoll_weight && ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		for (i = 1; i < ioa_cfg->hrrq_num; i++) {
@@ -3740,7 +3740,7 @@ static ssize_t ipr_store_iopoll_weight(struct device *dev,
 					ioa_cfg->iopoll_weight, ipr_iopoll);
 		}
 	}
-	spin_unlock_irqrestore(shost->host_lock, lock_flags);
+	spin_unlock_irqrestore(&shost->host_lock, lock_flags);
 
 	return strlen(buf);
 }
@@ -3939,15 +3939,15 @@ static int ipr_update_ioa_ucode(struct ipr_ioa_cfg *ioa_cfg,
 {
 	unsigned long lock_flags;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	while (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	}
 
 	if (ioa_cfg->ucode_sglist) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		dev_err(&ioa_cfg->pdev->dev,
 			"Microcode download already in progress\n");
 		return -EIO;
@@ -3958,7 +3958,7 @@ static int ipr_update_ioa_ucode(struct ipr_ioa_cfg *ioa_cfg,
 					DMA_TO_DEVICE);
 
 	if (!sglist->num_dma_sg) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		dev_err(&ioa_cfg->pdev->dev,
 			"Failed to map microcode download buffer!\n");
 		return -EIO;
@@ -3966,12 +3966,12 @@ static int ipr_update_ioa_ucode(struct ipr_ioa_cfg *ioa_cfg,
 
 	ioa_cfg->ucode_sglist = sglist;
 	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NORMAL);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	ioa_cfg->ucode_sglist = NULL;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return 0;
 }
 
@@ -4072,9 +4072,9 @@ static ssize_t ipr_show_fw_type(struct device *dev,
 	unsigned long lock_flags = 0;
 	int len;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	len = snprintf(buf, PAGE_SIZE, "%d\n", ioa_cfg->sis64);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -4097,16 +4097,16 @@ static ssize_t ipr_read_async_err_log(struct file *filep, struct kobject *kobj,
 	unsigned long lock_flags = 0;
 	int ret;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	hostrcb = list_first_entry_or_null(&ioa_cfg->hostrcb_report_q,
 					struct ipr_hostrcb, queue);
 	if (!hostrcb) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return 0;
 	}
 	ret = memory_read_from_buffer(buf, count, &off, &hostrcb->hcam,
 				sizeof(hostrcb->hcam));
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return ret;
 }
 
@@ -4120,17 +4120,17 @@ static ssize_t ipr_next_async_err_log(struct file *filep, struct kobject *kobj,
 	struct ipr_hostrcb *hostrcb;
 	unsigned long lock_flags = 0;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	hostrcb = list_first_entry_or_null(&ioa_cfg->hostrcb_report_q,
 					struct ipr_hostrcb, queue);
 	if (!hostrcb) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return count;
 	}
 
 	/* Reclaim hostrcb before exit */
 	list_move_tail(&hostrcb->queue, &ioa_cfg->hostrcb_free_q);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return count;
 }
 
@@ -4187,15 +4187,15 @@ static ssize_t ipr_read_dump(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	dump = ioa_cfg->dump;
 
 	if (ioa_cfg->sdt_state != DUMP_OBTAINED || !dump) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return 0;
 	}
 	kref_get(&dump->kref);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	if (off > dump->driver_dump.hdr.len) {
 		kref_put(&dump->kref, ipr_release_dump);
@@ -4298,10 +4298,10 @@ static int ipr_alloc_dump(struct ipr_ioa_cfg *ioa_cfg)
 	kref_init(&dump->kref);
 	dump->ioa_cfg = ioa_cfg;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	if (INACTIVE != ioa_cfg->sdt_state) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		vfree(dump->ioa_dump.ioa_data);
 		kfree(dump);
 		return 0;
@@ -4313,7 +4313,7 @@ static int ipr_alloc_dump(struct ipr_ioa_cfg *ioa_cfg)
 		ioa_cfg->dump_taken = 1;
 		schedule_work(&ioa_cfg->work_q);
 	}
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	return 0;
 }
@@ -4332,15 +4332,15 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg)
 
 	ENTER;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	dump = ioa_cfg->dump;
 	if (!dump) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return 0;
 	}
 
 	ioa_cfg->dump = NULL;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	kref_put(&dump->kref, ipr_release_dump);
 
@@ -4429,11 +4429,11 @@ static ssize_t ipr_show_adapter_handle(struct device *dev, struct device_attribu
 	unsigned long lock_flags = 0;
 	ssize_t len = -ENXIO;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res)
 		len = snprintf(buf, PAGE_SIZE, "%08X\n", res->res_handle);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -4464,7 +4464,7 @@ static ssize_t ipr_show_resource_path(struct device *dev, struct device_attribut
 	ssize_t len = -ENXIO;
 	char buffer[IPR_MAX_RES_PATH_LENGTH];
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res && ioa_cfg->sis64)
 		len = snprintf(buf, PAGE_SIZE, "%s\n",
@@ -4474,7 +4474,7 @@ static ssize_t ipr_show_resource_path(struct device *dev, struct device_attribut
 		len = snprintf(buf, PAGE_SIZE, "%d:%d:%d:%d\n", ioa_cfg->host->host_no,
 			       res->bus, res->target, res->lun);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -4503,14 +4503,14 @@ static ssize_t ipr_show_device_id(struct device *dev, struct device_attribute *a
 	unsigned long lock_flags = 0;
 	ssize_t len = -ENXIO;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res && ioa_cfg->sis64)
 		len = snprintf(buf, PAGE_SIZE, "0x%llx\n", be64_to_cpu(res->dev_id));
 	else if (res)
 		len = snprintf(buf, PAGE_SIZE, "0x%llx\n", res->lun_wwn);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -4539,13 +4539,13 @@ static ssize_t ipr_show_resource_type(struct device *dev, struct device_attribut
 	unsigned long lock_flags = 0;
 	ssize_t len = -ENXIO;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 
 	if (res)
 		len = snprintf(buf, PAGE_SIZE, "%x\n", res->type);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -4575,13 +4575,13 @@ static ssize_t ipr_show_raw_mode(struct device *dev,
 	unsigned long lock_flags = 0;
 	ssize_t len;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res)
 		len = snprintf(buf, PAGE_SIZE, "%d\n", res->raw_mode);
 	else
 		len = -ENXIO;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -4605,7 +4605,7 @@ static ssize_t ipr_store_raw_mode(struct device *dev,
 	unsigned long lock_flags = 0;
 	ssize_t len;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res) {
 		if (ipr_is_af_dasd_device(res)) {
@@ -4618,7 +4618,7 @@ static ssize_t ipr_store_raw_mode(struct device *dev,
 			len = -EINVAL;
 	} else
 		len = -ENXIO;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
 
@@ -4759,13 +4759,13 @@ static void ipr_sdev_destroy(struct scsi_device *sdev)
 
 	ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *) sdev->hostdata;
 	if (res) {
 		sdev->hostdata = NULL;
 		res->sdev = NULL;
 	}
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 }
 
 /**
@@ -4786,7 +4786,7 @@ static int ipr_sdev_configure(struct scsi_device *sdev,
 	unsigned long lock_flags = 0;
 	char buffer[IPR_MAX_RES_PATH_LENGTH];
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	res = sdev->hostdata;
 	if (res) {
 		if (ipr_is_af_dasd_device(res))
@@ -4802,7 +4802,7 @@ static int ipr_sdev_configure(struct scsi_device *sdev,
 					     IPR_VSET_RW_TIMEOUT);
 			lim->max_hw_sectors = IPR_VSET_MAX_SECTORS;
 		}
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 		if (ioa_cfg->sis64)
 			sdev_printk(KERN_INFO, sdev, "Resource path: %s\n",
@@ -4810,7 +4810,7 @@ static int ipr_sdev_configure(struct scsi_device *sdev,
 				res->res_path, buffer, sizeof(buffer)));
 		return 0;
 	}
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return 0;
 }
 
@@ -4835,7 +4835,7 @@ static int ipr_sdev_init(struct scsi_device *sdev)
 
 	sdev->hostdata = NULL;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	res = ipr_find_sdev(sdev);
 	if (res) {
@@ -4849,12 +4849,12 @@ static int ipr_sdev_init(struct scsi_device *sdev)
 		if (ipr_is_gata(res)) {
 			sdev_printk(KERN_ERR, sdev, "SATA devices are no longer "
 				"supported by this driver. Skipping device.\n");
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+			spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 			return -ENXIO;
 		}
 	}
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	return rc;
 }
@@ -4970,7 +4970,7 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 
 	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	if (!ioa_cfg->in_reset_reload && !ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
@@ -4981,9 +4981,9 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 			ioa_cfg->sdt_state = GET_DUMP;
 	}
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	/* If we got hit with a host reset while we were already resetting
 	 the adapter for some reason, and the reset failed. */
@@ -4992,7 +4992,7 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 		rc = FAILED;
 	}
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	LEAVE;
 	return rc;
 }
@@ -5092,9 +5092,9 @@ static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
 	if (!res)
 		return FAILED;
 
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(&cmd->device->host->host_lock);
 	rc = __ipr_eh_dev_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irq(&cmd->device->host->host_lock);
 
 	if (rc == SUCCESS)
 		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
@@ -5158,9 +5158,9 @@ static void ipr_abort_timeout(struct timer_list *t)
 	unsigned long lock_flags = 0;
 
 	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	if (ipr_cmd->completion.done || ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		return;
 	}
 
@@ -5175,7 +5175,7 @@ static void ipr_abort_timeout(struct timer_list *t)
 	cmd_pkt->cdb[2] = IPR_RESET_TYPE_SELECT | IPR_BUS_RESET;
 
 	ipr_do_req(reset_cmd, ipr_bus_reset_done, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	LEAVE;
 }
 
@@ -5281,12 +5281,12 @@ static int ipr_scan_finished(struct Scsi_Host *shost, unsigned long elapsed_time
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
 	int rc = 0;
 
-	spin_lock_irqsave(shost->host_lock, lock_flags);
+	spin_lock_irqsave(&shost->host_lock, lock_flags);
 	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead || ioa_cfg->scan_done)
 		rc = 1;
 	if ((elapsed_time/HZ) > (ioa_cfg->transop_timeout * 2))
 		rc = 1;
-	spin_unlock_irqrestore(shost->host_lock, lock_flags);
+	spin_unlock_irqrestore(&shost->host_lock, lock_flags);
 	return rc;
 }
 
@@ -5307,9 +5307,9 @@ static int ipr_eh_abort(struct scsi_cmnd *scsi_cmd)
 
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
 
-	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
+	spin_lock_irqsave(&scsi_cmd->device->host->host_lock, flags);
 	rc = ipr_cancel_op(scsi_cmd);
-	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, flags);
+	spin_unlock_irqrestore(&scsi_cmd->device->host->host_lock, flags);
 
 	if (rc == SUCCESS)
 		rc = ipr_wait_for_ops(ioa_cfg, scsi_cmd->device, ipr_match_lun);
@@ -6222,11 +6222,11 @@ static void ipr_scsi_done(struct ipr_cmnd *ipr_cmd)
 		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, lock_flags);
 	} else {
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 		spin_lock(&ipr_cmd->hrrq->_lock);
 		ipr_erp_start(ioa_cfg, ipr_cmd);
 		spin_unlock(&ipr_cmd->hrrq->_lock);
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	}
 }
 
@@ -6383,9 +6383,9 @@ static const char *ipr_ioa_info(struct Scsi_Host *host)
 
 	ioa_cfg = (struct ipr_ioa_cfg *) host->hostdata;
 
-	spin_lock_irqsave(host->host_lock, lock_flags);
+	spin_lock_irqsave(&host->host_lock, lock_flags);
 	sprintf(buffer, "IBM %X Storage Adapter", ioa_cfg->type);
-	spin_unlock_irqrestore(host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&host->host_lock, lock_flags);
 
 	return buffer;
 }
@@ -7480,14 +7480,14 @@ static void ipr_reset_timer_done(struct timer_list *t)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	unsigned long lock_flags = 0;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	if (ioa_cfg->reset_cmd == ipr_cmd) {
 		list_del(&ipr_cmd->queue);
 		ipr_cmd->done(ipr_cmd);
 	}
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 }
 
 /**
@@ -8023,10 +8023,10 @@ static void ipr_reset_reset_work(struct work_struct *work)
 	msleep(jiffies_to_msecs(IPR_PCI_RESET_TIMEOUT));
 	pci_set_pcie_reset_state(pdev, pcie_deassert_reset);
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	if (ioa_cfg->reset_cmd == ipr_cmd)
 		ipr_reset_ioa_job(ipr_cmd);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	LEAVE;
 }
 
@@ -8588,10 +8588,10 @@ static pci_ers_result_t ipr_pci_mmio_enabled(struct pci_dev *pdev)
 	unsigned long flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, flags);
 	if (!ioa_cfg->probe_done)
 		pci_save_state(pdev);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, flags);
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
@@ -8608,10 +8608,10 @@ static void ipr_pci_frozen(struct pci_dev *pdev)
 	unsigned long flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, flags);
 	if (ioa_cfg->probe_done)
 		_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_freeze, IPR_SHUTDOWN_NONE);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, flags);
 }
 
 /**
@@ -8627,7 +8627,7 @@ static pci_ers_result_t ipr_pci_slot_reset(struct pci_dev *pdev)
 	unsigned long flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, flags);
 	if (ioa_cfg->probe_done) {
 		if (ioa_cfg->needs_warm_reset)
 			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
@@ -8636,7 +8636,7 @@ static pci_ers_result_t ipr_pci_slot_reset(struct pci_dev *pdev)
 						IPR_SHUTDOWN_NONE);
 	} else
 		wake_up_all(&ioa_cfg->eeh_wait_q);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, flags);
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
@@ -8653,7 +8653,7 @@ static void ipr_pci_perm_failure(struct pci_dev *pdev)
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 	int i;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, flags);
 	if (ioa_cfg->probe_done) {
 		if (ioa_cfg->sdt_state == WAIT_FOR_DUMP)
 			ioa_cfg->sdt_state = ABORT_DUMP;
@@ -8668,7 +8668,7 @@ static void ipr_pci_perm_failure(struct pci_dev *pdev)
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
 	} else
 		wake_up_all(&ioa_cfg->eeh_wait_q);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, flags);
 }
 
 /**
@@ -8712,7 +8712,7 @@ static void ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
 	unsigned long host_lock_flags = 0;
 
 	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, host_lock_flags);
 	dev_dbg(&ioa_cfg->pdev->dev, "ioa_cfg adx: 0x%p\n", ioa_cfg);
 	ioa_cfg->probe_done = 1;
 	if (ioa_cfg->needs_hard_reset) {
@@ -8721,7 +8721,7 @@ static void ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
 	} else
 		_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_enable_ioa,
 					IPR_SHUTDOWN_NONE);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, host_lock_flags);
 
 	LEAVE;
 }
@@ -9196,7 +9196,7 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 		INIT_LIST_HEAD(&ioa_cfg->hrrq[i].hrrq_pending_q);
 		spin_lock_init(&ioa_cfg->hrrq[i]._lock);
 		if (i == 0)
-			ioa_cfg->hrrq[i].lock = ioa_cfg->host->host_lock;
+			ioa_cfg->hrrq[i].lock = &ioa_cfg->host->host_lock;
 		else
 			ioa_cfg->hrrq[i].lock = &ioa_cfg->hrrq[i]._lock;
 	}
@@ -9291,12 +9291,12 @@ static irqreturn_t ipr_test_intr(int irq, void *devp)
 	unsigned long lock_flags = 0;
 
 	dev_info(&ioa_cfg->pdev->dev, "Received IRQ : %d\n", irq);
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 
 	ioa_cfg->msi_received = 1;
 	wake_up(&ioa_cfg->msi_wait_q);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	return IRQ_HANDLED;
 }
 
@@ -9320,13 +9320,13 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 
 	ENTER;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	init_waitqueue_head(&ioa_cfg->msi_wait_q);
 	ioa_cfg->msi_received = 0;
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.clr_interrupt_mask_reg32);
 	readl(ioa_cfg->regs.sense_interrupt_mask_reg);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	rc = request_irq(irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
 	if (rc) {
@@ -9338,7 +9338,7 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.sense_interrupt_reg32);
 	readl(ioa_cfg->regs.sense_interrupt_reg);
 	wait_event_timeout(ioa_cfg->msi_wait_q, ioa_cfg->msi_received, HZ);
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 
 	if (!ioa_cfg->msi_received) {
@@ -9348,7 +9348,7 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 	} else if (ipr_debug)
 		dev_info(&pdev->dev, "MSI test succeeded.\n");
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	free_irq(irq, ioa_cfg);
 
@@ -9573,9 +9573,9 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 	if (interrupts & IPR_PCII_IOA_UNIT_CHECKED)
 		ioa_cfg->ioa_unit_checked = 1;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 
 	if (pdev->msi_enabled || pdev->msix_enabled) {
 		name_msi_vectors(ioa_cfg);
@@ -9680,11 +9680,11 @@ static void __ipr_remove(struct pci_dev *pdev)
 	unsigned long driver_lock_flags;
 	ENTER;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, host_lock_flags);
 	while (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, host_lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, host_lock_flags);
 	}
 
 	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
@@ -9695,13 +9695,13 @@ static void __ipr_remove(struct pci_dev *pdev)
 	wmb();
 	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, host_lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 	flush_work(&ioa_cfg->work_q);
 	if (ioa_cfg->reset_work_q)
 		flush_workqueue(ioa_cfg->reset_work_q);
 	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
-	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, host_lock_flags);
 
 	spin_lock_irqsave(&ipr_driver_lock, driver_lock_flags);
 	list_del(&ioa_cfg->queue);
@@ -9709,7 +9709,7 @@ static void __ipr_remove(struct pci_dev *pdev)
 
 	if (ioa_cfg->sdt_state == ABORT_DUMP)
 		ioa_cfg->sdt_state = WAIT_FOR_DUMP;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, host_lock_flags);
 
 	ipr_free_all_resources(ioa_cfg);
 
@@ -9807,10 +9807,10 @@ static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 		__ipr_remove(pdev);
 		return rc;
 	}
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, flags);
 	ioa_cfg->scan_enabled = 1;
 	schedule_work(&ioa_cfg->work_q);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, flags);
 
 	ioa_cfg->iopoll_weight = ioa_cfg->chip_cfg->iopoll_weight;
 
@@ -9843,7 +9843,7 @@ static void ipr_shutdown(struct pci_dev *pdev)
 	enum ipr_shutdown_type shutdown_type = IPR_SHUTDOWN_NORMAL;
 	int i;
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	if (ioa_cfg->iopoll_weight && ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		ioa_cfg->iopoll_weight = 0;
 		for (i = 1; i < ioa_cfg->hrrq_num; i++)
@@ -9851,16 +9851,16 @@ static void ipr_shutdown(struct pci_dev *pdev)
 	}
 
 	while (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, lock_flags);
 	}
 
 	if (ipr_fast_reboot && system_state == SYSTEM_RESTART && ioa_cfg->sis64)
 		shutdown_type = IPR_SHUTDOWN_QUIESCE;
 
 	ipr_initiate_ioa_bringdown(ioa_cfg, shutdown_type);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&ioa_cfg->host->host_lock, lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 	if (ipr_fast_reboot && system_state == SYSTEM_RESTART && ioa_cfg->sis64) {
 		ipr_free_irqs(ioa_cfg);
@@ -10030,10 +10030,10 @@ static int ipr_halt(struct notifier_block *nb, ulong event, void *buf)
 	spin_lock_irqsave(&ipr_driver_lock, driver_lock_flags);
 
 	list_for_each_entry(ioa_cfg, &ipr_ioa_head, queue) {
-		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+		spin_lock_irqsave(&ioa_cfg->host->host_lock, flags);
 		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds ||
 		    (ipr_fast_reboot && event == SYS_RESTART && ioa_cfg->sis64)) {
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+			spin_unlock_irqrestore(&ioa_cfg->host->host_lock, flags);
 			continue;
 		}
 
@@ -10044,7 +10044,7 @@ static int ipr_halt(struct notifier_block *nb, ulong event, void *buf)
 		ipr_cmd->ioarcb.cmd_pkt.cdb[1] = IPR_SHUTDOWN_PREPARE_FOR_NORMAL;
 
 		ipr_do_req(ipr_cmd, ipr_halt_done, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		spin_unlock_irqrestore(&ioa_cfg->host->host_lock, flags);
 	}
 	spin_unlock_irqrestore(&ipr_driver_lock, driver_lock_flags);
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 41ed73966a48c..45c5b9acb664c 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -794,7 +794,7 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 	if (!ha->active)
 		return (FAILED);
 
-	spin_lock(host->host_lock);
+	spin_lock(&host->host_lock);
 
 	/* See if the command is on the copp queue */
 	item = ha->copp_waitlist.head;
@@ -815,7 +815,7 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 		ret = (FAILED);
 	}
 
-	spin_unlock(host->host_lock);
+	spin_unlock(&host->host_lock);
 	return ret;
 }
 
@@ -999,9 +999,9 @@ static int ips_eh_reset(struct scsi_cmnd *SC)
 {
 	int rc;
 
-	spin_lock_irq(SC->device->host->host_lock);
+	spin_lock_irq(&SC->device->host->host_lock);
 	rc = __ips_eh_reset(SC);
-	spin_unlock_irq(SC->device->host->host_lock);
+	spin_unlock_irq(&SC->device->host->host_lock);
 
 	return rc;
 }
@@ -1221,16 +1221,16 @@ do_ipsintr(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	spin_lock(host->host_lock);
+	spin_lock(&host->host_lock);
 
 	if (!ha->active) {
-		spin_unlock(host->host_lock);
+		spin_unlock(&host->host_lock);
 		return IRQ_HANDLED;
 	}
 
 	irqstatus = (*ha->func.intr) (ha);
 
-	spin_unlock(host->host_lock);
+	spin_unlock(&host->host_lock);
 
 	/* start the next command */
 	ips_next(ha, IPS_INTR_ON);
@@ -2524,7 +2524,7 @@ ips_next(ips_ha_t * ha, int intr)
 	 * this command won't time out
 	 */
 	if (intr == IPS_INTR_ON)
-		spin_lock(host->host_lock);
+		spin_lock(&host->host_lock);
 
 	if ((ha->subsys->param[3] & 0x300000)
 	    && (ha->scb_activelist.count == 0)) {
@@ -2548,14 +2548,14 @@ ips_next(ips_ha_t * ha, int intr)
 		item = ips_removeq_copp_head(&ha->copp_waitlist);
 		ha->num_ioctl++;
 		if (intr == IPS_INTR_ON)
-			spin_unlock(host->host_lock);
+			spin_unlock(&host->host_lock);
 		scb->scsi_cmd = item->scsi_cmd;
 		kfree(item);
 
 		ret = ips_make_passthru(ha, scb->scsi_cmd, scb, intr);
 
 		if (intr == IPS_INTR_ON)
-			spin_lock(host->host_lock);
+			spin_lock(&host->host_lock);
 		switch (ret) {
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
@@ -2625,7 +2625,7 @@ ips_next(ips_ha_t * ha, int intr)
 		SC = ips_removeq_wait(&ha->scb_waitlist, q);
 
 		if (intr == IPS_INTR_ON)
-			spin_unlock(host->host_lock);	/* Unlock HA after command is taken off queue */
+			spin_unlock(&host->host_lock);	/* Unlock HA after command is taken off queue */
 
 		SC->result = DID_OK;
 		SC->host_scribble = NULL;
@@ -2682,7 +2682,7 @@ ips_next(ips_ha_t * ha, int intr)
 			scb->dcdb.transfer_length = 0;
 		}
 		if (intr == IPS_INTR_ON)
-			spin_lock(host->host_lock);
+			spin_lock(&host->host_lock);
 
 		ret = ips_send_cmd(ha, scb);
 
@@ -2721,7 +2721,7 @@ ips_next(ips_ha_t * ha, int intr)
 	}			/* end while */
 
 	if (intr == IPS_INTR_ON)
-		spin_unlock(host->host_lock);
+		spin_unlock(&host->host_lock);
 }
 
 /****************************************************************************/
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a5139e43ca4ce..60a675aa5a99c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -358,7 +358,7 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
 	unsigned long flags;
 	int can_queue;
 
-	spin_lock_irqsave(lport->host->host_lock, flags);
+	spin_lock_irqsave(&lport->host->host_lock, flags);
 
 	if (si->last_can_queue_ramp_up_time &&
 	    (time_before(jiffies, si->last_can_queue_ramp_up_time +
@@ -381,7 +381,7 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
 		     "can_queue to %d.\n", can_queue);
 
 unlock:
-	spin_unlock_irqrestore(lport->host->host_lock, flags);
+	spin_unlock_irqrestore(&lport->host->host_lock, flags);
 }
 
 /**
@@ -401,7 +401,7 @@ static bool fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 	int can_queue;
 	bool changed = false;
 
-	spin_lock_irqsave(lport->host->host_lock, flags);
+	spin_lock_irqsave(&lport->host->host_lock, flags);
 
 	if (si->last_can_queue_ramp_down_time &&
 	    (time_before(jiffies, si->last_can_queue_ramp_down_time +
@@ -418,7 +418,7 @@ static bool fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 	changed = true;
 
 unlock:
-	spin_unlock_irqrestore(lport->host->host_lock, flags);
+	spin_unlock_irqrestore(&lport->host->host_lock, flags);
 	return changed;
 }
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index c83282733ec4c..732eff434723f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -436,13 +436,13 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 	if (!i->dft->lldd_abort_task)
 		return FAILED;
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	/* We cannot do async aborts for SATA devices */
 	if (dev_is_sata(dev) && !host->host_eh_scheduled) {
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 		return FAILED;
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 
 	if (task)
 		res = i->dft->lldd_abort_task(task);
@@ -699,9 +699,9 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 retry:
 	tries++;
 	retry = true;
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	pr_notice("Enter %s busy: %d failed: %d\n",
 		  __func__, scsi_host_busy(shost), shost->host_failed);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 52fc5058976d9..6f6394a0047c2 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7917,15 +7917,15 @@ lpfc_els_flush_rscn(struct lpfc_vport *vport)
 	struct lpfc_hba  *phba = vport->phba;
 	int i;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	if (vport->fc_rscn_flush) {
 		/* Another thread is walking fc_rscn_id_list on this vport */
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		return;
 	}
 	/* Indicate we are walking lpfc_els_flush_rscn on this vport */
 	vport->fc_rscn_flush = 1;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	for (i = 0; i < vport->fc_rscn_id_cnt; i++) {
 		lpfc_in_buf_free(phba, vport->fc_rscn_id_list[i]);
@@ -7933,9 +7933,9 @@ lpfc_els_flush_rscn(struct lpfc_vport *vport)
 	}
 	clear_bit(FC_RSCN_MODE, &vport->fc_flag);
 	clear_bit(FC_RSCN_DISCOVERY, &vport->fc_flag);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	vport->fc_rscn_id_cnt = 0;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	lpfc_can_disctmo(vport);
 	/* Indicate we are done walking this fc_rscn_id_list */
 	vport->fc_rscn_flush = 0;
@@ -7972,15 +7972,15 @@ lpfc_rscn_payload_check(struct lpfc_vport *vport, uint32_t did)
 	if (test_bit(FC_RSCN_DISCOVERY, &vport->fc_flag))
 		return did;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	if (vport->fc_rscn_flush) {
 		/* Another thread is walking fc_rscn_id_list on this vport */
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		return 0;
 	}
 	/* Indicate we are walking fc_rscn_id_list on this vport */
 	vport->fc_rscn_flush = 1;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	for (i = 0; i < vport->fc_rscn_id_cnt; i++) {
 		lp = vport->fc_rscn_id_list[i]->virt;
 		payload_len = be32_to_cpu(*lp++ & ~ELS_CMD_MASK);
@@ -8234,10 +8234,10 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		}
 	}
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	if (vport->fc_rscn_flush) {
 		/* Another thread is walking fc_rscn_id_list on this vport */
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		set_bit(FC_RSCN_DISCOVERY, &vport->fc_flag);
 		/* Send back ACC */
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
@@ -8245,7 +8245,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	}
 	/* Indicate we are walking fc_rscn_id_list on this vport */
 	vport->fc_rscn_flush = 1;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	/* Get the array count after successfully have the token */
 	rscn_cnt = vport->fc_rscn_id_cnt;
 	/* If we are already processing an RSCN, save the received
@@ -8538,14 +8538,14 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	 * The vport state should go to LPFC_FLOGI only
 	 * AFTER we issue a FLOGI, not receive one.
 	 */
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	fc_flag = vport->fc_flag;
 	port_state = vport->port_state;
 	/* Acking an unsol FLOGI.  Count 1 for link bounce
 	 * work-around.
 	 */
 	vport->rcv_flogi_cnt++;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	set_bit(FC_PT2PT, &vport->fc_flag);
 	clear_bit(FC_FABRIC, &vport->fc_flag);
 	clear_bit(FC_PUBLIC_LOOP, &vport->fc_flag);
@@ -11190,9 +11190,9 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			break;
 		}
 	} else {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		vport->vpi_state |= LPFC_VPI_REGISTERED;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		if (vport == phba->pport) {
 			if (phba->sli_rev < LPFC_SLI_REV4)
 				lpfc_issue_fabric_reglogin(vport);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c9b02d2c63054..4c673dffa671b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1340,9 +1340,9 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		}
 		clear_bit(FC_PT2PT, &phba->pport->fc_flag);
 		clear_bit(FC_PT2PT_PLOGI, &phba->pport->fc_flag);
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		phba->pport->rcv_flogi_cnt = 0;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 	}
 	return 0;
 }
@@ -1406,9 +1406,9 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 	}
 	set_bit(FC_NDISC_ACTIVE, &vport->fc_flag);
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	vport->fc_ns_retry = 0;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	lpfc_setup_fdmi_mask(vport);
 
 	lpfc_linkup_cleanup_nodes(vport);
@@ -1437,9 +1437,9 @@ lpfc_linkup(struct lpfc_hba *phba)
 	 * absorbed without an ACQE. No lock here - in worker thread
 	 * and discovery is synchronized.
 	 */
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	phba->pport->rcv_flogi_cnt = 0;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	return 0;
 }
@@ -3400,9 +3400,9 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	set_bit(FC_VFI_REGISTERED, &vport->fc_flag);
 	clear_bit(FC_VPORT_NEEDS_REG_VPI, &vport->fc_flag);
 	clear_bit(FC_VPORT_NEEDS_INIT_VPI, &vport->fc_flag);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	vport->vpi_state |= LPFC_VPI_REGISTERED;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	/* In case SLI4 FC loopback test, we are ready */
 	if ((phba->sli_rev == LPFC_SLI_REV4) &&
@@ -3943,9 +3943,9 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	set_bit(FC_VPORT_NEEDS_REG_VPI, &vport->fc_flag);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	vport->vpi_state &= ~LPFC_VPI_REGISTERED;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	mempool_free(pmb, phba->mbox_mem_pool);
 	lpfc_cleanup_vports_rrqs(vport, NULL);
 	/*
@@ -4010,9 +4010,9 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	clear_bit(FC_VPORT_NEEDS_REG_VPI, &vport->fc_flag);
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	vport->vpi_state |= LPFC_VPI_REGISTERED;
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	vport->num_disc_nodes = 0;
 	/* go thru NPR list and issue ELS PLOGIs */
 	if (atomic_read(&vport->fc_npr_cnt))
@@ -5620,9 +5620,9 @@ lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 	struct lpfc_nodelist *ndlp;
 	unsigned long iflags;
 
-	spin_lock_irqsave(shost->host_lock, iflags);
+	spin_lock_irqsave(&shost->host_lock, iflags);
 	ndlp = __lpfc_findnode_did(vport, did);
-	spin_unlock_irqrestore(shost->host_lock, iflags);
+	spin_unlock_irqrestore(&shost->host_lock, iflags);
 	return ndlp;
 }
 
@@ -6426,9 +6426,9 @@ lpfc_findnode_wwpn(struct lpfc_vport *vport, struct lpfc_name *wwpn)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	ndlp = __lpfc_find_node(vport, lpfc_filter_by_wwpn, wwpn);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	return ndlp;
 }
 
@@ -6444,9 +6444,9 @@ lpfc_findnode_rpi(struct lpfc_vport *vport, uint16_t rpi)
 	struct lpfc_nodelist *ndlp;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	ndlp = __lpfc_findnode_rpi(vport, rpi);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return ndlp;
 }
 
@@ -6786,9 +6786,9 @@ lpfc_unregister_fcf_prep(struct lpfc_hba *phba)
 				lpfc_sli4_unreg_all_rpis(vports[i]);
 			lpfc_mbx_unreg_vpi(vports[i]);
 			shost = lpfc_shost_from_vport(vports[i]);
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&shost->host_lock);
 			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&shost->host_lock);
 			set_bit(FC_VPORT_NEEDS_INIT_VPI, &vports[i]->fc_flag);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -6801,9 +6801,9 @@ lpfc_unregister_fcf_prep(struct lpfc_hba *phba)
 			lpfc_sli4_unreg_all_rpis(phba->pport);
 		lpfc_mbx_unreg_vpi(phba->pport);
 		shost = lpfc_shost_from_vport(phba->pport);
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		phba->pport->vpi_state &= ~LPFC_VPI_REGISTERED;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		set_bit(FC_VPORT_NEEDS_INIT_VPI, &phba->pport->fc_flag);
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 82af59c913e93..a16821399caf2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3833,9 +3833,9 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 			if (test_bit(FC_UNLOADING, &vports[i]->load_flag))
 				continue;
 			shost = lpfc_shost_from_vport(vports[i]);
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&shost->host_lock);
 			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&shost->host_lock);
 			set_bit(FC_VPORT_NEEDS_REG_VPI, &vports[i]->fc_flag);
 			clear_bit(FC_VFI_REGISTERED, &vports[i]->fc_flag);
 
@@ -3926,9 +3926,9 @@ lpfc_offline(struct lpfc_hba *phba)
 	if (vports != NULL)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&shost->host_lock);
 			vports[i]->work_port_events = 0;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&shost->host_lock);
 			set_bit(FC_OFFLINE_MODE, &vports[i]->fc_flag);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -4930,7 +4930,7 @@ int lpfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	struct lpfc_hba   *phba = vport->phba;
 	int stat = 0;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 
 	if (test_bit(FC_UNLOADING, &vport->load_flag)) {
 		stat = 1;
@@ -4965,7 +4965,7 @@ int lpfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	stat = 1;
 
 finished:
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 	return stat;
 }
 
@@ -9227,9 +9227,9 @@ lpfc_post_init_setup(struct lpfc_hba *phba)
 	lpfc_host_attrib_init(shost);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		lpfc_poll_start_timer(phba);
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 8a795c65e3c3e..50616b05488a8 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4272,7 +4272,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	if (vport->cfg_max_scsicmpl_time &&
 	    time_after(jiffies, lpfc_cmd->start_time +
 	    msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		if (ndlp) {
 			if (ndlp->cmd_qdepth >
 				atomic_read(&ndlp->cmd_pending) &&
@@ -4285,7 +4285,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 
 			ndlp->last_change_time = jiffies;
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 	}
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 
@@ -4552,7 +4552,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	if (vport->cfg_max_scsicmpl_time &&
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		if (pnode) {
 			if (pnode->cmd_qdepth >
 				atomic_read(&pnode->cmd_pending) &&
@@ -4565,7 +4565,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 			pnode->last_change_time = jiffies;
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 	}
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cfa4371169f13..cd285e87c278c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2886,9 +2886,9 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		!test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
 		!pmb->u.mb.mbxStatus) {
 		shost = lpfc_shost_from_vport(vport);
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		vport->vpi_state |= LPFC_VPI_REGISTERED;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		clear_bit(FC_VPORT_NEEDS_REG_VPI, &vport->fc_flag);
 	}
 
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index de2bd860b9d7c..613bb204b6afa 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -107,7 +107,7 @@ static int mac53c94_host_reset(struct scsi_cmnd *cmd)
 	struct dbdma_regs __iomem *dma = state->dma;
 	unsigned long flags;
 
-	spin_lock_irqsave(cmd->device->host->host_lock, flags);
+	spin_lock_irqsave(&cmd->device->host->host_lock, flags);
 
 	writel((RUN|PAUSE|FLUSH|WAKE) << 16, &dma->control);
 	writeb(CMD_SCSI_RESET, &regs->command);	/* assert RST */
@@ -117,7 +117,7 @@ static int mac53c94_host_reset(struct scsi_cmnd *cmd)
 	mac53c94_init(state);
 	writeb(CMD_NOP, &regs->command);
 
-	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
+	spin_unlock_irqrestore(&cmd->device->host->host_lock, flags);
 	return SUCCESS;
 }
 
@@ -182,9 +182,9 @@ static irqreturn_t do_mac53c94_interrupt(int irq, void *dev_id)
 	unsigned long flags;
 	struct Scsi_Host *dev = ((struct fsc_state *) dev_id)->current_req->device->host;
 	
-	spin_lock_irqsave(dev->host_lock, flags);
+	spin_lock_irqsave(&dev->host_lock, flags);
 	mac53c94_interrupt(irq, dev_id);
-	spin_unlock_irqrestore(dev->host_lock, flags);
+	spin_unlock_irqrestore(&dev->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f0152b043e18c..e693cb9e0dee6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2263,11 +2263,11 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
 	    && atomic_read(&instance->fw_outstanding) <
 	    instance->throttlequeuedepth + 1) {
 
-		spin_lock_irqsave(instance->host->host_lock, flags);
+		spin_lock_irqsave(&instance->host->host_lock, flags);
 		instance->flag &= ~MEGASAS_FW_BUSY;
 
 		instance->host->can_queue = instance->cur_can_queue;
-		spin_unlock_irqrestore(instance->host->host_lock, flags);
+		spin_unlock_irqrestore(&instance->host->host_lock, flags);
 	}
 }
 
@@ -2944,13 +2944,13 @@ static enum scsi_timeout_action megasas_reset_timer(struct scsi_cmnd *scmd)
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 	if (!(instance->flag & MEGASAS_FW_BUSY)) {
 		/* FW is busy, throttle IO */
-		spin_lock_irqsave(instance->host->host_lock, flags);
+		spin_lock_irqsave(&instance->host->host_lock, flags);
 
 		instance->host->can_queue = instance->throttlequeuedepth;
 		instance->last_time = jiffies;
 		instance->flag |= MEGASAS_FW_BUSY;
 
-		spin_unlock_irqrestore(instance->host->host_lock, flags);
+		spin_unlock_irqrestore(&instance->host->host_lock, flags);
 	}
 	return SCSI_EH_RESET_TIMER;
 }
@@ -3716,7 +3716,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		if ((opcode == MR_DCMD_LD_MAP_GET_INFO)
 			&& (cmd->frame->dcmd.mbox.b[1] == 1)) {
 			fusion->fast_path_io = 0;
-			spin_lock_irqsave(instance->host->host_lock, flags);
+			spin_lock_irqsave(&instance->host->host_lock, flags);
 			status = cmd->frame->hdr.cmd_status;
 			instance->map_update_cmd = NULL;
 			if (status != MFI_STAT_OK) {
@@ -3726,7 +3726,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				else {
 					megasas_return_cmd(instance, cmd);
 					spin_unlock_irqrestore(
-						instance->host->host_lock,
+						&instance->host->host_lock,
 						flags);
 					break;
 				}
@@ -3751,7 +3751,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				megasas_set_ld_removed_by_fw(instance);
 
 			megasas_sync_map_info(instance);
-			spin_unlock_irqrestore(instance->host->host_lock,
+			spin_unlock_irqrestore(&instance->host->host_lock,
 					       flags);
 
 			break;
@@ -3767,7 +3767,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		if ((opcode == MR_DCMD_SYSTEM_PD_MAP_GET_INFO) &&
 			(cmd->frame->dcmd.mbox.b[0] == 1)) {
 
-			spin_lock_irqsave(instance->host->host_lock, flags);
+			spin_lock_irqsave(&instance->host->host_lock, flags);
 			status = cmd->frame->hdr.cmd_status;
 			instance->jbod_seq_cmd = NULL;
 			megasas_return_cmd(instance, cmd);
@@ -3780,7 +3780,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			} else
 				instance->use_seqnum_jbod_fp = false;
 
-			spin_unlock_irqrestore(instance->host->host_lock, flags);
+			spin_unlock_irqrestore(&instance->host->host_lock, flags);
 			break;
 		}
 
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index dc1402b321da4..1883ba08af7db 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1016,9 +1016,9 @@ static irqreturn_t do_mesh_interrupt(int irq, void *dev_id)
 	struct mesh_state *ms = dev_id;
 	struct Scsi_Host *dev = ms->host;
 	
-	spin_lock_irqsave(dev->host_lock, flags);
+	spin_lock_irqsave(&dev->host_lock, flags);
 	mesh_interrupt(ms);
-	spin_unlock_irqrestore(dev->host_lock, flags);
+	spin_unlock_irqrestore(&dev->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -1708,7 +1708,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 
 	printk(KERN_DEBUG "mesh_host_reset\n");
 
-	spin_lock_irqsave(ms->host->host_lock, flags);
+	spin_lock_irqsave(&ms->host->host_lock, flags);
 
 	if (ms->dma_started)
 		halt_dma(ms);
@@ -1734,7 +1734,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 	/* Complete pending commands */
 	handle_reset(ms);
 	
-	spin_unlock_irqrestore(ms->host->host_lock, flags);
+	spin_unlock_irqrestore(&ms->host->host_lock, flags);
 	return SUCCESS;
 }
 
@@ -1771,14 +1771,14 @@ static int mesh_suspend(struct macio_dev *mdev, pm_message_t mesg)
 		return 0;
 
 	scsi_block_requests(ms->host);
-	spin_lock_irqsave(ms->host->host_lock, flags);
+	spin_lock_irqsave(&ms->host->host_lock, flags);
 	while(ms->phase != idle) {
-		spin_unlock_irqrestore(ms->host->host_lock, flags);
+		spin_unlock_irqrestore(&ms->host->host_lock, flags);
 		msleep(10);
-		spin_lock_irqsave(ms->host->host_lock, flags);
+		spin_lock_irqsave(&ms->host->host_lock, flags);
 	}
 	ms->phase = sleeping;
-	spin_unlock_irqrestore(ms->host->host_lock, flags);
+	spin_unlock_irqrestore(&ms->host->host_lock, flags);
 	disable_irq(ms->meshintr);
 	set_mesh_power(ms, 0);
 
@@ -1795,9 +1795,9 @@ static int mesh_resume(struct macio_dev *mdev)
 
 	set_mesh_power(ms, 1);
 	mesh_init(ms);
-	spin_lock_irqsave(ms->host->host_lock, flags);
+	spin_lock_irqsave(&ms->host->host_lock, flags);
 	mesh_start(ms);
-	spin_unlock_irqrestore(ms->host->host_lock, flags);
+	spin_unlock_irqrestore(&ms->host->host_lock, flags);
 	enable_irq(ms->meshintr);
 	scsi_unblock_requests(ms->host);
 
@@ -1818,7 +1818,7 @@ static int mesh_shutdown(struct macio_dev *mdev)
 	unsigned long flags;
 
        	printk(KERN_INFO "resetting MESH scsi bus(es)\n");
-	spin_lock_irqsave(ms->host->host_lock, flags);
+	spin_lock_irqsave(&ms->host->host_lock, flags);
        	mr = ms->mesh;
 	out_8(&mr->intr_mask, 0);
 	out_8(&mr->interrupt, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
@@ -1826,7 +1826,7 @@ static int mesh_shutdown(struct macio_dev *mdev)
 	mesh_flush_io(mr);
 	udelay(30);
 	out_8(&mr->bus_status1, 0);
-	spin_unlock_irqrestore(ms->host->host_lock, flags);
+	spin_unlock_irqrestore(&ms->host->host_lock, flags);
 
 	return 0;
 }
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e70d336b4ab39..e9e2c25cde682 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -722,9 +722,9 @@ static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
 		return -1;
 	}
 	atomic_inc(&cmd->sync_cmd);
-	spin_lock_irqsave(mhba->shost->host_lock, flags);
+	spin_lock_irqsave(&mhba->shost->host_lock, flags);
 	mhba->instancet->fire_cmd(mhba, cmd);
-	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+	spin_unlock_irqrestore(&mhba->shost->host_lock, flags);
 
 	wait_event_timeout(mhba->int_cmd_wait_q,
 		(cmd->cmd_status != REQ_STATUS_PENDING),
@@ -732,7 +732,7 @@ static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
 
 	/* command timeout */
 	if (atomic_read(&cmd->sync_cmd)) {
-		spin_lock_irqsave(mhba->shost->host_lock, flags);
+		spin_lock_irqsave(&mhba->shost->host_lock, flags);
 		atomic_dec(&cmd->sync_cmd);
 		if (mhba->tag_cmd[cmd->frame->tag]) {
 			mhba->tag_cmd[cmd->frame->tag] = NULL;
@@ -747,7 +747,7 @@ static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
 		} else
 			atomic_dec(&mhba->fw_outstanding);
 
-		spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+		spin_unlock_irqrestore(&mhba->shost->host_lock, flags);
 	}
 	return 0;
 }
@@ -1791,9 +1791,9 @@ static irqreturn_t mvumi_isr_handler(int irq, void *devp)
 	struct mvumi_hba *mhba = (struct mvumi_hba *) devp;
 	unsigned long flags;
 
-	spin_lock_irqsave(mhba->shost->host_lock, flags);
+	spin_lock_irqsave(&mhba->shost->host_lock, flags);
 	if (unlikely(mhba->instancet->clear_intr(mhba) || !mhba->global_isr)) {
-		spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+		spin_unlock_irqrestore(&mhba->shost->host_lock, flags);
 		return IRQ_NONE;
 	}
 
@@ -1814,7 +1814,7 @@ static irqreturn_t mvumi_isr_handler(int irq, void *devp)
 	mhba->isr_status = 0;
 	if (mhba->fw_state == FW_STATE_STARTED)
 		mvumi_handle_clob(mhba);
-	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+	spin_unlock_irqrestore(&mhba->shost->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -2083,13 +2083,13 @@ static enum scsi_qc_status mvumi_queue_command(struct Scsi_Host *shost,
 	struct mvumi_hba *mhba;
 	unsigned long irq_flags;
 
-	spin_lock_irqsave(shost->host_lock, irq_flags);
+	spin_lock_irqsave(&shost->host_lock, irq_flags);
 
 	mhba = (struct mvumi_hba *) shost->hostdata;
 	scmd->result = 0;
 	cmd = mvumi_get_cmd(mhba);
 	if (unlikely(!cmd)) {
-		spin_unlock_irqrestore(shost->host_lock, irq_flags);
+		spin_unlock_irqrestore(&shost->host_lock, irq_flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -2099,13 +2099,13 @@ static enum scsi_qc_status mvumi_queue_command(struct Scsi_Host *shost,
 	cmd->scmd = scmd;
 	mvumi_priv(scmd)->cmd_priv = cmd;
 	mhba->instancet->fire_cmd(mhba, cmd);
-	spin_unlock_irqrestore(shost->host_lock, irq_flags);
+	spin_unlock_irqrestore(&shost->host_lock, irq_flags);
 	return 0;
 
 out_return_cmd:
 	mvumi_return_cmd(mhba, cmd);
 	scsi_done(scmd);
-	spin_unlock_irqrestore(shost->host_lock, irq_flags);
+	spin_unlock_irqrestore(&shost->host_lock, irq_flags);
 	return 0;
 }
 
@@ -2116,7 +2116,7 @@ static enum scsi_timeout_action mvumi_timed_out(struct scsi_cmnd *scmd)
 	struct mvumi_hba *mhba = shost_priv(host);
 	unsigned long flags;
 
-	spin_lock_irqsave(mhba->shost->host_lock, flags);
+	spin_lock_irqsave(&mhba->shost->host_lock, flags);
 
 	if (mhba->tag_cmd[cmd->frame->tag]) {
 		mhba->tag_cmd[cmd->frame->tag] = NULL;
@@ -2135,7 +2135,7 @@ static enum scsi_timeout_action mvumi_timed_out(struct scsi_cmnd *scmd)
 			     scmd->sc_data_direction);
 	}
 	mvumi_return_cmd(mhba, cmd);
-	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+	spin_unlock_irqrestore(&mhba->shost->host_lock, flags);
 
 	return SCSI_EH_NOT_HANDLED;
 }
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index e893d56772417..83cd7099c7a65 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1166,7 +1166,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 	int handled = 0;
 	struct Scsi_Host *host = data->Host;
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 
 	/*
 	 * IRQ check, then enable IRQ mask
@@ -1433,7 +1433,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
  out2:
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 
 	nsp32_dbg(NSP32_DEBUG_INTR, "exit");
 
@@ -2886,14 +2886,14 @@ static int nsp32_eh_host_reset(struct scsi_cmnd *SCpnt)
 	nsp32_msg(KERN_INFO, "Host Reset");
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
 
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(&SCpnt->device->host->host_lock);
 
 	nsp32hw_init(data);
 	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
 	nsp32_do_bus_reset(data);
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(&SCpnt->device->host->host_lock);
 	return SUCCESS;	/* Host reset is succeeded at any time. */
 }
 
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 1530c1ad5d36a..aeae5c16e406f 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -360,7 +360,7 @@ SYM53C500_intr(int irq, void *dev_id)
 	struct sym53c500_cmd_priv *scp = scsi_cmd_priv(curSC);
 	int fast_pio = data->fast_pio;
 
-	spin_lock_irqsave(dev->host_lock, flags);
+	spin_lock_irqsave(&dev->host_lock, flags);
 
 	VDEB(printk("SYM53C500_intr called\n"));
 
@@ -494,7 +494,7 @@ SYM53C500_intr(int irq, void *dev_id)
 		break;
 	}
 out:
-	spin_unlock_irqrestore(dev->host_lock, flags);
+	spin_unlock_irqrestore(&dev->host_lock, flags);
 	return IRQ_HANDLED;
 
 idle_out:
@@ -588,9 +588,9 @@ SYM53C500_host_reset(struct scsi_cmnd *SCpnt)
 	int port_base = SCpnt->device->host->io_port;
 
 	DEB(printk("SYM53C500_host_reset called\n"));
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(&SCpnt->device->host->host_lock);
 	SYM53C500_int_host_reset(port_base);
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(&SCpnt->device->host->host_lock);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 942a993932049..b68f6460207c7 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -497,10 +497,10 @@ static void pmcraid_clr_trans_op(
 	if (pinstance->reset_cmd != NULL) {
 		timer_delete(&pinstance->reset_cmd->timer);
 		spin_lock_irqsave(
-			pinstance->host->host_lock, lock_flags);
+			&pinstance->host->host_lock, lock_flags);
 		pinstance->reset_cmd->cmd_done(pinstance->reset_cmd);
 		spin_unlock_irqrestore(
-			pinstance->host->host_lock, lock_flags);
+			&pinstance->host->host_lock, lock_flags);
 	}
 }
 
@@ -562,9 +562,9 @@ static void pmcraid_bist_done(struct timer_list *t)
 	} else {
 		cmd->time_left = 0;
 		pmcraid_info("BIST is complete, proceeding with reset\n");
-		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+		spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 		pmcraid_ioa_reset(cmd);
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 	}
 }
 
@@ -613,9 +613,9 @@ static void pmcraid_reset_alert_done(struct timer_list *t)
 	if (((status & INTRS_CRITICAL_OP_IN_PROGRESS) == 0) ||
 	    cmd->time_left <= 0) {
 		pmcraid_info("critical op is reset proceeding with reset\n");
-		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+		spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 		pmcraid_ioa_reset(cmd);
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 	} else {
 		pmcraid_info("critical op is not yet reset waiting again\n");
 		/* restart timer if some more time is available to wait */
@@ -699,7 +699,7 @@ static void pmcraid_timeout_handler(struct timer_list *t)
 	 * reset is in progress. Otherwise fail this command and get a free
 	 * command block to restart the reset sequence.
 	 */
-	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+	spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 	if (!pinstance->ioa_reset_in_progress) {
 		pinstance->ioa_reset_attempts = 0;
 		cmd = pmcraid_get_free_cmd(pinstance);
@@ -708,7 +708,7 @@ static void pmcraid_timeout_handler(struct timer_list *t)
 		 * Some other command's timeout handler can do the reset job
 		 */
 		if (cmd == NULL) {
-			spin_unlock_irqrestore(pinstance->host->host_lock,
+			spin_unlock_irqrestore(&pinstance->host->host_lock,
 					       lock_flags);
 			pmcraid_err("no free cmnd block for timeout handler\n");
 			return;
@@ -745,7 +745,7 @@ static void pmcraid_timeout_handler(struct timer_list *t)
 	pinstance->ioa_state = IOA_STATE_IN_RESET_ALERT;
 	scsi_block_requests(pinstance->host);
 	pmcraid_reset_alert(cmd);
-	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 }
 
 /**
@@ -921,9 +921,9 @@ static void pmcraid_ioa_shutdown_done(struct pmcraid_cmd *cmd)
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	unsigned long lock_flags;
 
-	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+	spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 	pmcraid_ioa_reset(cmd);
-	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 }
 
 /**
@@ -982,10 +982,10 @@ static void pmcraid_get_fwversion_done(struct pmcraid_cmd *cmd)
 	 */
 	if (ioasc) {
 		pmcraid_err("IOA Inquiry failed with %x\n", ioasc);
-		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+		spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 		pinstance->ioa_state = IOA_STATE_IN_RESET_ALERT;
 		pmcraid_reset_alert(cmd);
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 	} else  {
 		pmcraid_querycfg(cmd);
 	}
@@ -1596,11 +1596,11 @@ static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
 			spin_unlock_irqrestore(&pinstance->resource_lock,
 						lock_flags);
 			pmcraid_err("too many resources attached\n");
-			spin_lock_irqsave(pinstance->host->host_lock,
+			spin_lock_irqsave(&pinstance->host->host_lock,
 					  host_lock_flags);
 			pmcraid_send_hcam(pinstance,
 					  PMCRAID_HCAM_CODE_CONFIG_CHANGE);
-			spin_unlock_irqrestore(pinstance->host->host_lock,
+			spin_unlock_irqrestore(&pinstance->host->host_lock,
 					       host_lock_flags);
 			return;
 		}
@@ -1760,9 +1760,9 @@ static void pmcraid_process_ccn(struct pmcraid_cmd *cmd)
 	} else if (ioasc) {
 		dev_info(&pinstance->pdev->dev,
 			"Host RCB (CCN) failed with IOASC: 0x%08X\n", ioasc);
-		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+		spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 		pmcraid_send_hcam(pinstance, PMCRAID_HCAM_CODE_CONFIG_CHANGE);
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 	} else {
 		pmcraid_handle_config_change(pinstance);
 	}
@@ -1800,10 +1800,10 @@ static void pmcraid_process_ldn(struct pmcraid_cmd *cmd)
 	} else if (!ioasc) {
 		pmcraid_handle_error_log(pinstance);
 		if (fd_ioasc == PMCRAID_IOASC_NR_IOA_RESET_REQUIRED) {
-			spin_lock_irqsave(pinstance->host->host_lock,
+			spin_lock_irqsave(&pinstance->host->host_lock,
 					  lock_flags);
 			pmcraid_initiate_reset(pinstance);
-			spin_unlock_irqrestore(pinstance->host->host_lock,
+			spin_unlock_irqrestore(&pinstance->host->host_lock,
 					       lock_flags);
 			return;
 		}
@@ -2322,17 +2322,17 @@ static int pmcraid_reset_reload(
 	unsigned long lock_flags;
 	int reset = 1;
 
-	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+	spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 
 	if (pinstance->ioa_reset_in_progress) {
 		pmcraid_info("reset_reload: reset is already in progress\n");
 
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 
 		wait_event(pinstance->reset_wait_q,
 			   !pinstance->ioa_reset_in_progress);
 
-		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+		spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 
 		if (pinstance->ioa_state == IOA_STATE_DEAD) {
 			pmcraid_info("reset_reload: IOA is dead\n");
@@ -2361,7 +2361,7 @@ static int pmcraid_reset_reload(
 	pinstance->force_ioa_reset = reset;
 	pmcraid_info("reset_reload: initiating reset\n");
 	pmcraid_ioa_reset(reset_cmd);
-	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 	pmcraid_info("reset_reload: waiting for reset to complete\n");
 	wait_event(pinstance->reset_wait_q,
 		   !pinstance->ioa_reset_in_progress);
@@ -2371,7 +2371,7 @@ static int pmcraid_reset_reload(
 	return pinstance->ioa_state != target_state;
 
 out_unlock:
-	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 	return reset;
 }
 
@@ -2719,10 +2719,10 @@ static int pmcraid_reset_device(
 	 * This will force the mid-layer to call _eh_bus/host reset, which
 	 * will then go to sleep and wait for the reset to complete
 	 */
-	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+	spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 	if (pinstance->ioa_reset_in_progress ||
 	    pinstance->ioa_state == IOA_STATE_DEAD) {
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 		return FAILED;
 	}
 
@@ -2736,7 +2736,7 @@ static int pmcraid_reset_device(
 	cmd = pmcraid_get_free_cmd(pinstance);
 
 	if (cmd == NULL) {
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 		pmcraid_err("%s: no cmd blocks are available\n", __func__);
 		return FAILED;
 	}
@@ -2765,7 +2765,7 @@ static int pmcraid_reset_device(
 			 timeout,
 			 pmcraid_timeout_handler);
 
-	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+	spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 
 	/* RESET_DEVICE command completes after all pending IOARCBs are
 	 * completed. Once this command is completed, pmcraind_internal_done
@@ -2960,11 +2960,11 @@ static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
 	 * pmcraid_eh_host_reset which will then go to sleep and wait for the
 	 * reset to complete
 	 */
-	spin_lock_irqsave(pinstance->host->host_lock, host_lock_flags);
+	spin_lock_irqsave(&pinstance->host->host_lock, host_lock_flags);
 
 	if (pinstance->ioa_reset_in_progress ||
 	    pinstance->ioa_state == IOA_STATE_DEAD) {
-		spin_unlock_irqrestore(pinstance->host->host_lock,
+		spin_unlock_irqrestore(&pinstance->host->host_lock,
 				       host_lock_flags);
 		return rc;
 	}
@@ -2992,7 +2992,7 @@ static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
 	if (cmd_found)
 		cancel_cmd = pmcraid_abort_cmd(cmd);
 
-	spin_unlock_irqrestore(pinstance->host->host_lock,
+	spin_unlock_irqrestore(&pinstance->host->host_lock,
 			       host_lock_flags);
 
 	if (cancel_cmd) {
@@ -3720,11 +3720,11 @@ static irqreturn_t pmcraid_isr_msix(int irq, void *dev_id)
 
 				pmcraid_err("ISR: error interrupts: %x \
 					initiating reset\n", intrs_val);
-				spin_lock_irqsave(pinstance->host->host_lock,
+				spin_lock_irqsave(&pinstance->host->host_lock,
 					lock_flags);
 				pmcraid_initiate_reset(pinstance);
 				spin_unlock_irqrestore(
-					pinstance->host->host_lock,
+					&pinstance->host->host_lock,
 					lock_flags);
 			}
 			/* If interrupt was as part of the ioa initialization,
@@ -3798,9 +3798,9 @@ static irqreturn_t pmcraid_isr(int irq, void *dev_id)
 			    intrs);
 		intrs = ioread32(
 				pinstance->int_regs.ioa_host_interrupt_clr_reg);
-		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+		spin_lock_irqsave(&pinstance->host->host_lock, lock_flags);
 		pmcraid_initiate_reset(pinstance);
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+		spin_unlock_irqrestore(&pinstance->host->host_lock, lock_flags);
 	} else {
 		/* If interrupt was as part of the ioa initialization,
 		 * clear. Delete the timer and wakeup the
@@ -3859,11 +3859,11 @@ static void pmcraid_worker_function(struct work_struct *workp)
 			/* host_lock must be held before calling
 			 * scsi_device_get
 			 */
-			spin_lock_irqsave(pinstance->host->host_lock,
+			spin_lock_irqsave(&pinstance->host->host_lock,
 					  host_lock_flags);
 			if (!scsi_device_get(sdev)) {
 				spin_unlock_irqrestore(
-						pinstance->host->host_lock,
+						&pinstance->host->host_lock,
 						host_lock_flags);
 				pmcraid_info("deleting %x from midlayer\n",
 					     res->cfg_entry.resource_address);
@@ -3879,7 +3879,7 @@ static void pmcraid_worker_function(struct work_struct *workp)
 				res->change_detected = 0;
 			} else {
 				spin_unlock_irqrestore(
-						pinstance->host->host_lock,
+						&pinstance->host->host_lock,
 						host_lock_flags);
 			}
 		}
@@ -3986,10 +3986,10 @@ static void pmcraid_tasklet_function(unsigned long instance)
 		atomic_dec(&pinstance->outstanding_cmds);
 
 		if (cmd->cmd_done == pmcraid_ioa_reset) {
-			spin_lock_irqsave(pinstance->host->host_lock,
+			spin_lock_irqsave(&pinstance->host->host_lock,
 					  host_lock_flags);
 			cmd->cmd_done(cmd);
-			spin_unlock_irqrestore(pinstance->host->host_lock,
+			spin_unlock_irqrestore(&pinstance->host->host_lock,
 					       host_lock_flags);
 		} else if (cmd->cmd_done != NULL) {
 			cmd->cmd_done(cmd);
@@ -4880,9 +4880,9 @@ static void pmcraid_complete_ioa_reset(struct pmcraid_cmd *cmd)
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	unsigned long flags;
 
-	spin_lock_irqsave(pinstance->host->host_lock, flags);
+	spin_lock_irqsave(&pinstance->host->host_lock, flags);
 	pmcraid_ioa_reset(cmd);
-	spin_unlock_irqrestore(pinstance->host->host_lock, flags);
+	spin_unlock_irqrestore(&pinstance->host->host_lock, flags);
 	scsi_unblock_requests(pinstance->host);
 	schedule_work(&pinstance->worker_q);
 }
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index cdd6fe002c324..348c59a99cc56 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -741,9 +741,9 @@ _qla1280_wait_for_single_command(struct scsi_qla_host *ha, struct srb *sp,
 	int	status = FAILED;
 	struct scsi_cmnd *cmd = sp->cmd;
 
-	spin_unlock_irq(ha->host->host_lock);
+	spin_unlock_irq(&ha->host->host_lock);
 	wait_for_completion_timeout(wait, 4*HZ);
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(&ha->host->host_lock);
 	sp->wait = NULL;
 	if(CMD_HANDLE(cmd) == COMPLETED_HANDLE) {
 		status = SUCCESS;
@@ -953,9 +953,9 @@ qla1280_eh_abort(struct scsi_cmnd * cmd)
 {
 	int rc;
 
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(&cmd->device->host->host_lock);
 	rc = qla1280_error_action(cmd, ABORT_COMMAND);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irq(&cmd->device->host->host_lock);
 
 	return rc;
 }
@@ -969,9 +969,9 @@ qla1280_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
 
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(&cmd->device->host->host_lock);
 	rc = qla1280_error_action(cmd, DEVICE_RESET);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irq(&cmd->device->host->host_lock);
 
 	return rc;
 }
@@ -985,9 +985,9 @@ qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
 
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(&cmd->device->host->host_lock);
 	rc = qla1280_error_action(cmd, BUS_RESET);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irq(&cmd->device->host->host_lock);
 
 	return rc;
 }
@@ -1003,7 +1003,7 @@ qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
 	struct Scsi_Host *shost = cmd->device->host;
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	if (qla1280_verbose) {
 		printk(KERN_INFO
 		       "scsi(%ld): Issued ADAPTER RESET\n",
@@ -1019,7 +1019,7 @@ qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
 
 	ha->flags.reset_active = 0;
 
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	return rc;
 }
@@ -1080,7 +1080,7 @@ qla1280_intr_handler(int irq, void *dev_id)
 	ENTER_INTR ("qla1280_intr_handler");
 	ha = (struct scsi_qla_host *)dev_id;
 
-	spin_lock(ha->host->host_lock);
+	spin_lock(&ha->host->host_lock);
 
 	ha->isr_count++;
 	reg = ha->iobase;
@@ -1096,7 +1096,7 @@ qla1280_intr_handler(int irq, void *dev_id)
 	if (!list_empty(&ha->done_q))
 		qla1280_done(ha);
 
-	spin_unlock(ha->host->host_lock);
+	spin_unlock(&ha->host->host_lock);
 
 	qla1280_enable_intrs(ha);
 
@@ -1214,11 +1214,11 @@ qla1280_sdev_configure(struct scsi_device *device, struct queue_limits *lim)
 			nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr = 0;
 	}
 
-	spin_lock_irqsave(ha->host->host_lock, flags);
+	spin_lock_irqsave(&ha->host->host_lock, flags);
 	if (nv->bus[bus].target[target].parameter.enable_sync)
 		status = qla1280_set_target_parameters(ha, bus, target);
 	qla1280_get_target_parameters(ha, device);
-	spin_unlock_irqrestore(ha->host->host_lock, flags);
+	spin_unlock_irqrestore(&ha->host->host_lock, flags);
 	return status;
 }
 
@@ -1435,7 +1435,7 @@ qla1280_initialize_adapter(struct scsi_qla_host *ha)
 	 * needs to be able to drop the lock unconditionally to wait
 	 * for completion.
 	 */
-	spin_lock_irqsave(ha->host->host_lock, flags);
+	spin_lock_irqsave(&ha->host->host_lock, flags);
 
 	status = qla1280_load_firmware(ha);
 	if (status) {
@@ -1467,7 +1467,7 @@ qla1280_initialize_adapter(struct scsi_qla_host *ha)
 
 	ha->flags.online = 1;
  out:
-	spin_unlock_irqrestore(ha->host->host_lock, flags);
+	spin_unlock_irqrestore(&ha->host->host_lock, flags);
 
 	if (status)
 		dprintk(2, "qla1280_initialize_adapter: **** FAILED ****\n");
@@ -1496,7 +1496,7 @@ qla1280_request_firmware(struct scsi_qla_host *ha)
 	int index;
 	char *fwname;
 
-	spin_unlock_irq(ha->host->host_lock);
+	spin_unlock_irq(&ha->host->host_lock);
 	mutex_lock(&qla1280_firmware_mutex);
 
 	index = ql1280_board_tbl[ha->devnum].fw_index;
@@ -1529,7 +1529,7 @@ qla1280_request_firmware(struct scsi_qla_host *ha)
 	ha->fwver3 = fw->data[2];
  unlock:
 	mutex_unlock(&qla1280_firmware_mutex);
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(&ha->host->host_lock);
 	return fw;
 }
 
@@ -2451,14 +2451,14 @@ qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *mb)
 	timer_setup(&ha->mailbox_timer, qla1280_mailbox_timeout, 0);
 	mod_timer(&ha->mailbox_timer, jiffies + 20 * HZ);
 
-	spin_unlock_irq(ha->host->host_lock);
+	spin_unlock_irq(&ha->host->host_lock);
 	WRT_REG_WORD(&reg->host_cmd, HC_SET_HOST_INT);
 	qla1280_debounce_register(&reg->istatus);
 
 	wait_for_completion(&wait);
 	timer_delete_sync(&ha->mailbox_timer);
 
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(&ha->host->host_lock);
 
 	ha->mailbox_wait = NULL;
 
@@ -2560,9 +2560,9 @@ qla1280_bus_reset(struct scsi_qla_host *ha, int bus)
 			ha->bus_settings[bus].scsi_bus_dead = 1;
 		ha->bus_settings[bus].failed_reset_count++;
 	} else {
-		spin_unlock_irq(ha->host->host_lock);
+		spin_unlock_irq(&ha->host->host_lock);
 		ssleep(reset_delay);
-		spin_lock_irq(ha->host->host_lock);
+		spin_lock_irq(&ha->host->host_lock);
 
 		ha->bus_settings[bus].scsi_bus_dead = 0;
 		ha->bus_settings[bus].failed_reset_count = 0;
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a4ca22024edeb..781149497ff80 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2814,13 +2814,13 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	 * Transport has effectively 'deleted' the rport, clear
 	 * all local references.
 	 */
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	/* Confirm port has not reappeared before clearing pointers. */
 	if (rport->port_state != FC_PORTSTATE_ONLINE) {
 		fcport->rport = NULL;
 		*((fc_port_t **)rport->dd_data) = NULL;
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
 		return;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 900cd141928e3..a98d2015b4a1e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6247,9 +6247,9 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 		return;
 	}
 
-	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
+	spin_lock_irqsave(&fcport->vha->host->host_lock, flags);
 	*((fc_port_t **)rport->dd_data) = fcport;
-	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
+	spin_unlock_irqrestore(&fcport->vha->host->host_lock, flags);
 	fcport->dev_loss_tmo = rport->dev_loss_tmo;
 
 	rport->supported_classes = fcport->supported_classes;
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index d36293bc27173..af6f6eb516363 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -454,9 +454,9 @@ irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id)
 	unsigned long flags;
 	struct Scsi_Host *host = dev_id;
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	ql_ihandl(dev_id);
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -536,9 +536,9 @@ int qlogicfas408_host_reset(struct scsi_cmnd *cmd)
 
 	priv->qabort = 2;
 
-	spin_lock_irqsave(cmd->device->host->host_lock, flags);
+	spin_lock_irqsave(&cmd->device->host->host_lock, flags);
 	ql_zap(priv);
-	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
+	spin_unlock_irqrestore(&cmd->device->host->host_lock, flags);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index ea0a2b5a0a420..0989160618356 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -333,7 +333,7 @@ static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 
 	risc_code_addr = 0x1000;	/* all load addresses are at 0x1000 */
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 
 	sbus_writew(HCCTRL_PAUSE, qpti->qregs + HCCTRL);
 
@@ -382,7 +382,7 @@ static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 	if (qlogicpti_mbox_command(qpti, param, 1)) {
 		printk(KERN_EMERG "qlogicpti%d: Cannot execute ISP firmware.\n",
 		       qpti->qpti_id);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 		return 1;
 	}
 
@@ -393,7 +393,7 @@ static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 	   (param[0] != MBOX_COMMAND_COMPLETE)) {
 		printk(KERN_EMERG "qlogicpti%d: Cannot set initiator SCSI ID.\n",
 		       qpti->qpti_id);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 		return 1;
 	}
 
@@ -408,7 +408,7 @@ static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 	if (qlogicpti_mbox_command(qpti, param, 1)) {
 		printk(KERN_EMERG "qlogicpti%d: Cannot init response queue.\n",
 		       qpti->qpti_id);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 		return 1;
 	}
 
@@ -420,7 +420,7 @@ static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 	if (qlogicpti_mbox_command(qpti, param, 1)) {
 		printk(KERN_EMERG "qlogicpti%d: Cannot init request queue.\n",
 		       qpti->qpti_id);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 		return 1;
 	}
 
@@ -466,7 +466,7 @@ static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 	qlogicpti_mbox_command(qpti, param, 0);
 	qpti->send_marker = 1;
 
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 	return 0;
 }
 
@@ -501,7 +501,7 @@ static int qlogicpti_load_firmware(struct qlogicpti *qpti)
 	risc_code_addr = 0x1000;	/* all f/w modules load at 0x1000 */
 	risc_code_length = fw->size / 2;
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 
 	/* Verify the checksum twice, one before loading it, and once
 	 * afterwards via the mailbox commands.
@@ -642,7 +642,7 @@ static int qlogicpti_load_firmware(struct qlogicpti *qpti)
 	}
 
 out:
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 outfirm:
 	release_firmware(fw);
 	return err;
@@ -1207,7 +1207,7 @@ static irqreturn_t qpti_intr(int irq, void *dev_id)
 	unsigned long flags;
 	struct scsi_cmnd *dq;
 
-	spin_lock_irqsave(qpti->qhost->host_lock, flags);
+	spin_lock_irqsave(&qpti->qhost->host_lock, flags);
 	dq = qlogicpti_intr_handler(qpti);
 
 	if (dq != NULL) {
@@ -1219,7 +1219,7 @@ static irqreturn_t qpti_intr(int irq, void *dev_id)
 			dq = next;
 		} while (dq != NULL);
 	}
-	spin_unlock_irqrestore(qpti->qhost->host_lock, flags);
+	spin_unlock_irqrestore(&qpti->qhost->host_lock, flags);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..4e7e7a6b7315b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -828,7 +828,7 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 	struct scsi_device *next = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	while (list->next != &shost->__devices) {
 		next = list_entry(list->next, struct scsi_device, siblings);
 		/*
@@ -840,7 +840,7 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 		next = NULL;
 		list = list->next;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (prev)
 		scsi_device_put(prev);
@@ -947,11 +947,11 @@ struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	sdev = __scsi_device_lookup_by_target(starget, lun);
 	if (sdev && scsi_device_get(sdev))
 		sdev = NULL;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	return sdev;
 }
@@ -1007,11 +1007,11 @@ struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	sdev = __scsi_device_lookup(shost, channel, id, lun);
 	if (sdev && scsi_device_get(sdev))
 		sdev = NULL;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	return sdev;
 }
diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index eb52e39f37c92..54d8824250b1a 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -38,7 +38,7 @@ static const char *scsi_cmd_list_info(struct scsi_cmnd *cmd)
 	struct Scsi_Host *shost = cmd->device->host;
 	struct scsi_cmnd *cmd2;
 
-	guard(spinlock_irq)(shost->host_lock);
+	guard(spinlock_irq)(&shost->host_lock);
 
 	list_for_each_entry(cmd2, &shost->eh_abort_list, eh_entry)
 		if (cmd == cmd2)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9c..d0a68c19d1325 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -63,7 +63,7 @@ static enum scsi_disposition scsi_try_to_abort_cmd(const struct scsi_host_templa
 
 void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy)
 {
-	lockdep_assert_held(shost->host_lock);
+	lockdep_assert_held(&shost->host_lock);
 
 	if (busy == shost->host_failed) {
 		trace_scsi_eh_wakeup(shost);
@@ -83,7 +83,7 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
 	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
@@ -91,7 +91,7 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 		scsi_eh_wakeup(shost, scsi_host_busy(shost));
 	}
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 EXPORT_SYMBOL_GPL(scsi_schedule_eh);
 
@@ -181,7 +181,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 		goto out;
 	}
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_del_init(&scmd->eh_entry);
 
 	/*
@@ -193,7 +193,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 		if (shost->eh_deadline != -1)
 			shost->last_reset = 0;
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (!scsi_noretry_cmd(scmd) &&
 	    scsi_cmd_retry_allowed(scmd) &&
@@ -211,9 +211,9 @@ scmd_eh_abort_handler(struct work_struct *work)
 	return;
 
 out:
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_del_init(&scmd->eh_entry);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	scsi_eh_scmd_add(scmd);
 }
@@ -247,12 +247,12 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		return FAILED;
 	}
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
 	BUG_ON(!list_empty(&scmd->eh_entry));
 	list_add_tail(&scmd->eh_entry, &shost->eh_abort_list);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
 	SCSI_LOG_ERROR_RECOVERY(3,
@@ -285,9 +285,9 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 	unsigned int busy;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	shost->host_failed++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	/*
 	 * The counting of busy requests needs to occur after adding to
 	 * host_failed or after the lock acquire for adding to host_failed
@@ -295,9 +295,9 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 	 */
 	busy = scsi_host_busy(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	scsi_eh_wakeup(shost, busy);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 /**
@@ -313,7 +313,7 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	WARN_ON_ONCE(!shost->ehandler);
 	WARN_ON_ONCE(!test_bit(SCMD_STATE_INFLIGHT, &scmd->state));
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RECOVERY)) {
 		ret = scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);
 		WARN_ON_ONCE(ret);
@@ -323,7 +323,7 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 
 	scsi_eh_reset(scmd);
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	/*
 	 * Ensure that all tasks observe the host state change before the
 	 * host_failed change.
@@ -920,9 +920,9 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
-		spin_lock_irqsave(host->host_lock, flags);
+		spin_lock_irqsave(&host->host_lock, flags);
 		scsi_report_bus_reset(host, scmd_channel(scmd));
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 	}
 
 	return rtn;
@@ -950,9 +950,9 @@ static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(host->host_lock, flags);
+		spin_lock_irqsave(&host->host_lock, flags);
 		scsi_report_bus_reset(host, scmd_channel(scmd));
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 	}
 
 	return rtn;
@@ -986,10 +986,10 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 
 	rtn = hostt->eh_target_reset_handler(scmd);
 	if (rtn == SUCCESS) {
-		spin_lock_irqsave(host->host_lock, flags);
+		spin_lock_irqsave(&host->host_lock, flags);
 		__starget_for_each_device(scsi_target(scmd->device), NULL,
 					  __scsi_report_device_reset);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 	}
 
 	return rtn;
@@ -2195,11 +2195,11 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	SCSI_LOG_ERROR_RECOVERY(3,
 		shost_printk(KERN_INFO, shost, "waking up host to restart\n"));
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RUNNING))
 		if (scsi_host_set_state(shost, SHOST_CANCEL))
 			BUG_ON(scsi_host_set_state(shost, SHOST_DEL));
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	wake_up(&shost->host_wait);
 
@@ -2219,11 +2219,11 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * recovery or scsi_device_unbusy() will wake us again when these
 	 * pending commands complete.
 	 */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (shost->host_eh_scheduled)
 		if (scsi_host_set_state(shost, SHOST_RECOVERY))
 			WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 /**
@@ -2315,19 +2315,19 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 	LIST_HEAD(eh_work_q);
 	LIST_HEAD(eh_done_q);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost, &eh_work_q));
 
 	if (!scsi_eh_get_sense(&eh_work_q, &eh_done_q))
 		scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (shost->eh_deadline != -1)
 		shost->last_reset = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	scsi_eh_flush_done_q(&eh_done_q);
 }
 
@@ -2529,9 +2529,9 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	shost->tmf_in_progress = 1;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	switch (val & ~SG_SCSI_RESET_NO_ESCALATE) {
 	case SG_SCSI_RESET_NOTHING:
@@ -2564,9 +2564,9 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	error = (rtn == SUCCESS) ? 0 : -EIO;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	shost->tmf_in_progress = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	/*
 	 * be sure to wake up anyone who was sleeping or had their queue
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2e07b686090f8..d2695a33bbe52 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -388,10 +388,10 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 
 		unsigned int busy = scsi_host_busy(shost);
 
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		if (shost->host_failed || shost->host_eh_scheduled)
 			scsi_eh_wakeup(shost, busy);
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 	}
 	rcu_read_unlock();
 }
@@ -436,9 +436,9 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	struct scsi_target *starget = scsi_target(current_sdev);
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	starget->starget_sdev_user = NULL;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	/*
 	 * Call blk_run_queue for all LUNs on the target, starting with
@@ -449,11 +449,11 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	blk_mq_run_hw_queues(current_sdev->request_queue,
 			     shost->queuecommand_may_block);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (!starget->starget_sdev_user)
 		__starget_for_each_device(starget, current_sdev,
 					  scsi_kick_sdev_queue);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
@@ -491,7 +491,7 @@ static void scsi_starved_list_run(struct Scsi_Host *shost)
 	struct scsi_device *sdev;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_splice_init(&shost->starved_list, &starved_list);
 
 	while (!list_empty(&starved_list)) {
@@ -532,16 +532,16 @@ static void scsi_starved_list_run(struct Scsi_Host *shost)
 		slq = sdev->request_queue;
 		if (!blk_get_queue(slq))
 			continue;
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 
 		blk_mq_run_hw_queues(slq, false);
 		blk_put_queue(slq);
 
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 	}
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 /**
@@ -578,7 +578,7 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 	struct scsi_device *sdev, *prev = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	__shost_for_each_device(sdev, shost) {
 		/*
 		 * Only skip devices so deep into removal they will never need
@@ -589,7 +589,7 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		if (sdev->sdev_state == SDEV_DEL ||
 		    !get_device(&sdev->sdev_gendev))
 			continue;
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 
 		if (prev)
 			put_device(&prev->sdev_gendev);
@@ -597,9 +597,9 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 
 		prev = sdev;
 
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	if (prev)
 		put_device(&prev->sdev_gendev);
 }
@@ -1433,14 +1433,14 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	unsigned int busy;
 
 	if (starget->single_lun) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		if (starget->starget_sdev_user &&
 		    starget->starget_sdev_user != sdev) {
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&shost->host_lock);
 			return 0;
 		}
 		starget->starget_sdev_user = sdev;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 	}
 
 	if (starget->can_queue <= 0)
@@ -1467,9 +1467,9 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	return 1;
 
 starved:
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	list_move_tail(&sdev->starved_entry, &shost->starved_list);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 out_dec:
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
@@ -1506,10 +1506,10 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 
 	/* We're OK to process the command, so we can't be starved */
 	if (!list_empty(&sdev->starved_entry)) {
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		if (!list_empty(&sdev->starved_entry))
 			list_del_init(&sdev->starved_entry);
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 	}
 
 	__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
@@ -1517,10 +1517,10 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	return 1;
 
 starved:
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	if (list_empty(&sdev->starved_entry))
 		list_add_tail(&sdev->starved_entry, &shost->starved_list);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 out_dec:
 	scsi_dec_host_busy(shost, cmd);
 	return 0;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3b82e80e807a7..96e4065ae8b55 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -397,11 +397,11 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	BUG_ON(starget->state == STARGET_DEL);
 	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
 		shost->hostt->target_destroy(starget);
 	list_del_init(&starget->siblings);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	put_device(dev);
 }
 
@@ -524,14 +524,14 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
  retry:
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	found_target = __scsi_find_target(parent, channel, id);
 	if (found_target)
 		goto found;
 
 	list_add_tail(&starget->siblings, &shost->__targets);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
 	if (shost->hostt->target_alloc) {
@@ -558,7 +558,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	 */
 	ref_got = kref_get_unless_zero(&found_target->reap_ref);
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	if (ref_got) {
 		put_device(dev);
 		return found_target;
@@ -2106,16 +2106,16 @@ void scsi_forget_host(struct Scsi_Host *shost)
 	unsigned long flags;
 
  restart:
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (scsi_device_is_pseudo_dev(sdev) ||
 		    sdev->sdev_state == SDEV_DEL)
 			continue;
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		__scsi_remove_device(sdev);
 		goto restart;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	/*
 	 * Remove the pseudo device last since it may be needed during removal
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9480432f650b7..fe54792ed69e4 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -214,7 +214,7 @@ store_shost_state(struct device *dev, struct device_attribute *attr,
 	if (!state)
 		return -EINVAL;
 
-	scoped_guard(spinlock_irq, shost->host_lock)
+	scoped_guard(spinlock_irq, &shost->host_lock)
 		if (scsi_host_set_state(shost, state))
 			return -EINVAL;
 	return count;
@@ -352,7 +352,7 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 			return -EINVAL;
 	}
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (scsi_host_in_recovery(shost))
 		ret = -EBUSY;
 	else {
@@ -363,7 +363,7 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 
 		ret = count;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	return ret;
 }
@@ -459,11 +459,11 @@ static void scsi_device_dev_release(struct device *dev)
 
 	parent = sdev->sdev_gendev.parent;
 
-	spin_lock_irqsave(sdev->host->host_lock, flags);
+	spin_lock_irqsave(&sdev->host->host_lock, flags);
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	spin_unlock_irqrestore(&sdev->host->host_lock, flags);
 
 	cancel_work_sync(&sdev->event_work);
 
@@ -1547,7 +1547,7 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	unsigned long flags;
 	struct scsi_device *sdev;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		/*
@@ -1563,13 +1563,13 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		    sdev->sdev_state == SDEV_CANCEL ||
 		    !get_device(&sdev->sdev_gendev))
 			continue;
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		scsi_remove_device(sdev);
 		put_device(&sdev->sdev_gendev);
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		goto restart;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 /**
@@ -1587,7 +1587,7 @@ void scsi_remove_target(struct device *dev)
 	unsigned long flags;
 
 restart:
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL ||
 		    starget->state == STARGET_REMOVE ||
@@ -1599,13 +1599,13 @@ void scsi_remove_target(struct device *dev)
 				starget->state = STARGET_CREATED_REMOVE;
 			else
 				starget->state = STARGET_REMOVE;
-			spin_unlock_irqrestore(shost->host_lock, flags);
+			spin_unlock_irqrestore(&shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);
 			goto restart;
 		}
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
@@ -1710,10 +1710,10 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 		sdev->lun_in_cdb = 1;
 
 	transport_setup_device(&sdev->sdev_gendev);
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	/*
 	 * device can now only be removed via __scsi_remove_device() so hold
 	 * the target.  Target will be held in CREATED state until something
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 173ed6373f04b..be0efffab2fcc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -645,19 +645,19 @@ fc_find_rport_by_wwpn(struct Scsi_Host *shost, u64 wwpn)
 	struct fc_rport *rport;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
 		if (rport->port_state != FC_PORTSTATE_ONLINE)
 			continue;
 
 		if (rport->port_name == wwpn) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
+			spin_unlock_irqrestore(&shost->host_lock, flags);
 			return rport;
 		}
 	}
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return NULL;
 }
 EXPORT_SYMBOL(fc_find_rport_by_wwpn);
@@ -1718,13 +1718,13 @@ store_fc_vport_delete(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = vport_to_shost(vport);
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		return -EBUSY;
 	}
 	vport->flags |= FC_VPORT_DELETING;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	fc_queue_work(shost, &vport->vport_delete_work);
 	return count;
@@ -2052,7 +2052,7 @@ store_fc_private_host_tgtid_bind_type(struct device *dev,
 
 	/* if changing bind type, purge all unused consistent bindings */
 	if (val != fc_host_tgtid_bind_type(shost)) {
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		while (!list_empty(&fc_host_rport_bindings(shost))) {
 			get_list_head_entry(rport,
 				&fc_host_rport_bindings(shost), peers);
@@ -2060,7 +2060,7 @@ store_fc_private_host_tgtid_bind_type(struct device *dev,
 			rport->port_state = FC_PORTSTATE_DELETED;
 			fc_queue_work(shost, &rport->rport_delete_work);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 	}
 
 	fc_host_tgtid_bind_type(shost) = val;
@@ -2107,10 +2107,10 @@ store_fc_private_host_dev_loss_tmo(struct device *dev,
 		return rc;
 
 	fc_host_dev_loss_tmo(shost) = val;
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_for_each_entry(rport, &fc_host->rports, peers)
 		fc_rport_set_dev_loss_tmo(rport, val);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	return count;
 }
 
@@ -2417,7 +2417,7 @@ store_fc_host_vport_delete(struct device *dev, struct device_attribute *attr,
 	if (stat)
 		return stat;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	match = 0;
 	/* we only allow support on Channel 0 !!! */
 	list_for_each_entry(vport, &fc_host->vports, peers) {
@@ -2430,7 +2430,7 @@ store_fc_host_vport_delete(struct device *dev, struct device_attribute *attr,
 			break;
 		}
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (!match)
 		return -ENODEV;
@@ -2590,7 +2590,7 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 	struct fc_rport *rport;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
 		if (rport->scsi_target_id == -1)
@@ -2602,14 +2602,14 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 
 		if ((channel == rport->channel) &&
 		    (id == rport->scsi_target_id)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
+			spin_unlock_irqrestore(&shost->host_lock, flags);
 			scsi_scan_target(&rport->dev, channel, id, lun,
 					 SCSI_SCAN_MANUAL);
 			return;
 		}
 	}
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 /*
@@ -2922,7 +2922,7 @@ fc_remove_host(struct Scsi_Host *shost)
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	/* Remove any vports */
 	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
@@ -2945,7 +2945,7 @@ fc_remove_host(struct Scsi_Host *shost)
 		fc_queue_work(shost, &rport->rport_delete_work);
 	}
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	/* flush all scan work items */
 	scsi_flush_work(shost);
@@ -3021,18 +3021,18 @@ fc_rport_final_delete(struct work_struct *work)
 	 * only when rmmod'ing the LLDD and we're asking for
 	 * immediate termination of the rports
 	 */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		if (!cancel_delayed_work(&rport->fail_io_work))
 			fc_flush_devloss(shost, rport);
 		if (!cancel_delayed_work(&rport->dev_loss_work))
 			fc_flush_devloss(shost, rport);
 		cancel_work_sync(&rport->scan_work);
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	/* Delete SCSI target and sdevs */
 	if (rport->scsi_target_id != -1)
@@ -3045,13 +3045,13 @@ fc_rport_final_delete(struct work_struct *work)
 	 * Avoid this call if we already called it when we preserved the
 	 * rport for the binding.
 	 */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (!(rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) &&
 	    (i->f->dev_loss_tmo_callbk)) {
 		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
 		do_callback = 1;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (do_callback)
 		i->f->dev_loss_tmo_callbk(rport);
@@ -3123,7 +3123,7 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 	INIT_WORK(&rport->stgt_delete_work, fc_starget_delete);
 	INIT_WORK(&rport->rport_delete_work, fc_rport_final_delete);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	rport->number = fc_host->next_rport_number++;
 	if ((rport->roles & FC_PORT_ROLE_FCP_TARGET) ||
@@ -3134,7 +3134,7 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 	list_add_tail(&rport->peers, &fc_host->rports);
 	scsi_host_get(shost);			/* for fc_host->rport list */
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	rport->devloss_work_q = alloc_workqueue("fc_dl_%d_%d", WQ_PERCPU, 0,
 						shost->host_no, rport->number);
@@ -3144,10 +3144,10 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
  * Note that we have not yet called device_initialize() / get_device()
  * Cannot reclaim incremented rport->number because we released host_lock
  */
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		list_del(&rport->peers);
 		scsi_host_put(shost);			/* for fc_host->rport list */
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		kfree(rport);
 		return NULL;
 	}
@@ -3181,10 +3181,10 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 
 delete_rport:
 	transport_destroy_device(dev);
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_del(&rport->peers);
 	scsi_host_put(shost);			/* for fc_host->rport list */
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	put_device(dev->parent);
 	kfree(rport);
 	return NULL;
@@ -3246,7 +3246,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 	 * deleted, but we've held off the real delete while the target
 	 * is in a "blocked" state.
 	 */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	list_for_each_entry(rport, &fc_host->rports, peers) {
 
@@ -3281,7 +3281,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 				rport->port_state = FC_PORTSTATE_ONLINE;
 				rport->roles = ids->roles;
 
-				spin_unlock_irqrestore(shost->host_lock, flags);
+				spin_unlock_irqrestore(&shost->host_lock, flags);
 
 				if (fci->f->dd_fcrport_size)
 					memset(rport->dd_data, 0,
@@ -3318,24 +3318,24 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 				if (!cancel_delayed_work(&rport->dev_loss_work))
 					fc_flush_devloss(shost, rport);
 
-				spin_lock_irqsave(shost->host_lock, flags);
+				spin_lock_irqsave(&shost->host_lock, flags);
 
 				rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
 						  FC_RPORT_DEVLOSS_PENDING |
 						  FC_RPORT_DEVLOSS_CALLBK_DONE);
 
-				spin_unlock_irqrestore(shost->host_lock, flags);
+				spin_unlock_irqrestore(&shost->host_lock, flags);
 
 				/* if target, initiate a scan */
 				if (rport->scsi_target_id != -1) {
 					scsi_target_unblock(&rport->dev,
 							    SDEV_RUNNING);
-					spin_lock_irqsave(shost->host_lock,
+					spin_lock_irqsave(&shost->host_lock,
 							  flags);
 					rport->flags |= FC_RPORT_SCAN_PENDING;
 					scsi_queue_work(shost,
 							&rport->scan_work);
-					spin_unlock_irqrestore(shost->host_lock,
+					spin_unlock_irqrestore(&shost->host_lock,
 							flags);
 				}
 
@@ -3394,14 +3394,14 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 			if (fci->f->dd_fcrport_size)
 				memset(rport->dd_data, 0,
 						fci->f->dd_fcrport_size);
-			spin_unlock_irqrestore(shost->host_lock, flags);
+			spin_unlock_irqrestore(&shost->host_lock, flags);
 
 			fc_remote_port_rolechg(rport, ids->roles);
 			return rport;
 		}
 	}
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	/* No consistent binding found - create new remote port entry */
 	rport = fc_remote_port_create(shost, channel, ids);
@@ -3478,11 +3478,11 @@ fc_remote_port_delete(struct fc_rport  *rport)
 	 * there's still a scan pending.
 	 */
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
 		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		return;
 	}
 
@@ -3503,7 +3503,7 @@ fc_remote_port_delete(struct fc_rport  *rport)
 
 	rport->flags |= FC_RPORT_DEVLOSS_PENDING;
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	scsi_block_targets(shost, &rport->dev);
 
@@ -3547,7 +3547,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 	unsigned long flags;
 	int create = 0;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (roles & FC_PORT_ROLE_FCP_TARGET) {
 		if (rport->scsi_target_id == -1) {
 			rport->scsi_target_id = fc_host->next_target_id++;
@@ -3558,7 +3558,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 
 	rport->roles = roles;
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (create) {
 		/*
@@ -3578,21 +3578,21 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 		if (!cancel_delayed_work(&rport->dev_loss_work))
 			fc_flush_devloss(shost, rport);
 
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
 				  FC_RPORT_DEVLOSS_PENDING |
 				  FC_RPORT_DEVLOSS_CALLBK_DONE);
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 
 		/* ensure any stgt delete functions are done */
 		fc_flush_work(shost);
 
 		scsi_target_unblock(&rport->dev, SDEV_RUNNING);
 		/* initiate a scan of the target */
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		rport->flags |= FC_RPORT_SCAN_PENDING;
 		scsi_queue_work(shost, &rport->scan_work);
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 	}
 }
 EXPORT_SYMBOL(fc_remote_port_rolechg);
@@ -3615,7 +3615,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	unsigned long flags;
 	int do_callback = 0;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 
@@ -3631,7 +3631,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 		dev_printk(KERN_ERR, &rport->dev,
 			"blocked FC remote port time out: no longer"
 			" a FCP target, removing starget\n");
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		scsi_target_unblock(&rport->dev, SDEV_TRANSPORT_OFFLINE);
 		fc_queue_work(shost, &rport->stgt_delete_work);
 		return;
@@ -3639,7 +3639,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 
 	/* NOOP state - we're flushing workq's */
 	if (rport->port_state != FC_PORTSTATE_BLOCKED) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		dev_printk(KERN_ERR, &rport->dev,
 			"blocked FC remote port time out: leaving"
 			" rport%s alone\n",
@@ -3656,7 +3656,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 			" rport%s\n",
 			(rport->scsi_target_id != -1) ?  " and starget" : "");
 		fc_queue_work(shost, &rport->rport_delete_work);
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		return;
 	}
 
@@ -3686,10 +3686,10 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	 * item to teardown the starget. (FCOE libFC folks prefer this
 	 * and to have the rport_port_id still set when it's done).
 	 */
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	fc_terminate_rport_io(rport);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	if (rport->port_state == FC_PORTSTATE_NOTPRESENT) {	/* still missing */
 
@@ -3722,7 +3722,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 		do_callback = 1;
 	}
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	/*
 	 * Notify the driver that the rport is now dead. The LLDD will
@@ -3777,9 +3777,9 @@ fc_scsi_scan_rport(struct work_struct *work)
 				 SCSI_SCAN_RESCAN);
 	}
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	rport->flags &= ~FC_RPORT_SCAN_PENDING;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 }
 
 /**
@@ -3801,14 +3801,14 @@ int fc_block_rport(struct fc_rport *rport)
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	while (rport->port_state == FC_PORTSTATE_BLOCKED &&
 	       !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		msleep(1000);
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
 		return FAST_IO_FAIL;
@@ -3916,10 +3916,10 @@ fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 	vport->flags = FC_VPORT_CREATING;
 	INIT_WORK(&vport->vport_delete_work, fc_vport_sched_delete);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 
 	if (fc_host->npiv_vports_inuse >= fc_host->max_npiv_vports) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		kfree(vport);
 		return -ENOSPC;
 	}
@@ -3928,7 +3928,7 @@ fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 	list_add_tail(&vport->peers, &fc_host->vports);
 	scsi_host_get(shost);			/* for fc_host->vport list */
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	dev = &vport->dev;
 	device_initialize(dev);			/* takes self reference */
@@ -3965,9 +3965,9 @@ fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 				"%s, err=%d\n",
 				__func__, dev_name(dev), error);
 	}
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	vport->flags &= ~FC_VPORT_CREATING;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	dev_printk(KERN_NOTICE, pdev,
 			"%s created via shost%d channel %d\n", dev_name(dev),
@@ -3982,11 +3982,11 @@ fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 	device_del(dev);
 delete_vport:
 	transport_destroy_device(dev);
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	list_del(&vport->peers);
 	scsi_host_put(shost);			/* for fc_host->vport list */
 	fc_host->npiv_vports_inuse--;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	put_device(dev->parent);
 	kfree(vport);
 
@@ -4041,7 +4041,7 @@ fc_vport_terminate(struct fc_vport *vport)
 	else
 		stat = -ENOENT;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	vport->flags &= ~FC_VPORT_DELETING;
 	if (!stat) {
 		vport->flags |= FC_VPORT_DELETED;
@@ -4049,7 +4049,7 @@ fc_vport_terminate(struct fc_vport *vport)
 		fc_host->npiv_vports_inuse--;
 		scsi_host_put(shost);		/* for fc_host->vport list */
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (stat)
 		return stat;
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 6594661db5f40..455208776239c 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -59,9 +59,9 @@ static irqreturn_t sgiwd93_intr(int irq, void *dev_id)
 	struct Scsi_Host * host = dev_id;
 	unsigned long flags;
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	wd33c93_intr(host);
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index 71d34a702f2ab..8c262b4bbb831 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -160,9 +160,9 @@ snic_scsi_scan_tgt(struct work_struct *work)
 			 SCAN_WILD_CARD,
 			 SCSI_SCAN_RESCAN);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	tgt->flags &= ~SNIC_TGT_SCAN_PENDING;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 } /* end of snic_scsi_scan_tgt */
 
 /*
@@ -287,11 +287,11 @@ snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
 		break;
 	}
 
-	spin_lock_irqsave(snic->shost->host_lock, flags);
+	spin_lock_irqsave(&snic->shost->host_lock, flags);
 	list_add_tail(&tgt->list, &snic->disc.tgt_list);
 	tgt->scsi_tgt_id = snic->disc.nxt_tgt_id++;
 	tgt->state = SNIC_TGT_STAT_ONLINE;
-	spin_unlock_irqrestore(snic->shost->host_lock, flags);
+	spin_unlock_irqrestore(&snic->shost->host_lock, flags);
 
 	SNIC_HOST_INFO(snic->shost,
 		       "Tgt %d, type = %s detected. Adding..\n",
@@ -304,9 +304,9 @@ snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
 			      ret);
 
 		put_device(&snic->shost->shost_gendev);
-		spin_lock_irqsave(snic->shost->host_lock, flags);
+		spin_lock_irqsave(&snic->shost->host_lock, flags);
 		list_del(&tgt->list);
-		spin_unlock_irqrestore(snic->shost->host_lock, flags);
+		spin_unlock_irqrestore(&snic->shost->host_lock, flags);
 		put_device(&tgt->dev);
 		tgt = NULL;
 
@@ -537,7 +537,7 @@ snic_tgt_del_all(struct snic *snic)
 	scsi_flush_work(snic->shost);
 
 	mutex_lock(&snic->disc.mutex);
-	spin_lock_irqsave(snic->shost->host_lock, flags);
+	spin_lock_irqsave(&snic->shost->host_lock, flags);
 
 	list_for_each_safe(cur, nxt, &snic->disc.tgt_list) {
 		tgt = list_entry(cur, struct snic_tgt, list);
@@ -547,7 +547,7 @@ snic_tgt_del_all(struct snic *snic)
 		queue_work(snic_glob->event_q, &tgt->del_work);
 		tgt = NULL;
 	}
-	spin_unlock_irqrestore(snic->shost->host_lock, flags);
+	spin_unlock_irqrestore(&snic->shost->host_lock, flags);
 	mutex_unlock(&snic->disc.mutex);
 
 	flush_workqueue(snic_glob->event_q);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 6aeeb338633df..e69a3779a32ae 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -568,7 +568,7 @@ static void return_abnormal_state(struct st_hba *hba, int status)
 	unsigned long flags;
 	u16 tag;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	for (tag = 0; tag < hba->host->can_queue; tag++) {
 		ccb = &hba->ccb[tag];
 		if (ccb->req == NULL)
@@ -581,7 +581,7 @@ static void return_abnormal_state(struct st_hba *hba, int status)
 			ccb->cmd = NULL;
 		}
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 }
 static int
 stex_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
@@ -887,7 +887,7 @@ static irqreturn_t stex_intr(int irq, void *__hba)
 	u32 data;
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 
 	data = readl(base + ODBL);
 
@@ -896,14 +896,14 @@ static irqreturn_t stex_intr(int irq, void *__hba)
 		writel(data, base + ODBL);
 		readl(base + ODBL); /* flush */
 		stex_mu_intr(hba, data);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		if (unlikely(data & MU_OUTBOUND_DOORBELL_REQUEST_RESET &&
 			hba->cardtype == st_shasta))
 			queue_work(hba->work_q, &hba->reset_work);
 		return IRQ_HANDLED;
 	}
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return IRQ_NONE;
 }
@@ -988,7 +988,7 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 	u32 data;
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 
 	if (hba->cardtype == st_yel) {
 		data = readl(base + YI2H_INT);
@@ -996,7 +996,7 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 			/* clear the interrupt */
 			writel(data, base + YI2H_INT_C);
 			stex_ss_mu_intr(hba);
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			spin_unlock_irqrestore(&hba->host->host_lock, flags);
 			if (unlikely(data & SS_I2H_REQUEST_RESET))
 				queue_work(hba->work_q, &hba->reset_work);
 			return IRQ_HANDLED;
@@ -1010,14 +1010,14 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 				writel((1 << 22), base + YH2I_INT);
 			}
 			stex_ss_mu_intr(hba);
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			spin_unlock_irqrestore(&hba->host->host_lock, flags);
 			if (unlikely(data & SS_I2H_REQUEST_RESET))
 				queue_work(hba->work_q, &hba->reset_work);
 			return IRQ_HANDLED;
 		}
 	}
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return IRQ_NONE;
 }
@@ -1227,7 +1227,7 @@ static int stex_handshake(struct st_hba *hba)
 		err = stex_ss_handshake(hba);
 	else
 		err = stex_common_handshake(hba);
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	mu_status = hba->mu_status;
 	if (err == 0) {
 		hba->req_head = 0;
@@ -1240,7 +1240,7 @@ static int stex_handshake(struct st_hba *hba)
 		hba->mu_status = MU_STATE_FAILED;
 	if (mu_status == MU_STATE_RESETTING)
 		wake_up_all(&hba->reset_waitq);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	return err;
 }
 
@@ -1257,7 +1257,7 @@ static int stex_abort(struct scsi_cmnd *cmd)
 	scmd_printk(KERN_INFO, cmd, "aborting command\n");
 
 	base = hba->mmio_base;
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	if (tag < host->can_queue &&
 		hba->ccb[tag].req && hba->ccb[tag].cmd == cmd)
 		hba->wait_ccb = &hba->ccb[tag];
@@ -1301,7 +1301,7 @@ static int stex_abort(struct scsi_cmnd *cmd)
 	hba->wait_ccb = NULL;
 	result = FAILED;
 out:
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 	return result;
 }
 
@@ -1364,13 +1364,13 @@ static int stex_yos_reset(struct st_hba *hba)
 		msleep(1);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (ret == -1)
 		hba->mu_status = MU_STATE_FAILED;
 	else
 		hba->mu_status = MU_STATE_STARTED;
 	wake_up_all(&hba->reset_waitq);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return ret;
 }
@@ -1393,29 +1393,29 @@ static int stex_do_reset(struct st_hba *hba)
 	unsigned long flags;
 	unsigned int mu_status = MU_STATE_RESETTING;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (hba->mu_status == MU_STATE_STARTING) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		printk(KERN_INFO DRV_NAME "(%s): request reset during init\n",
 			pci_name(hba->pdev));
 		return 0;
 	}
 	while (hba->mu_status == MU_STATE_RESETTING) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		wait_event_timeout(hba->reset_waitq,
 				   hba->mu_status != MU_STATE_RESETTING,
 				   MU_MAX_DELAY * HZ);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 		mu_status = hba->mu_status;
 	}
 
 	if (mu_status != MU_STATE_RESETTING) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		return (mu_status == MU_STATE_STARTED) ? 0 : -1;
 	}
 
 	hba->mu_status = MU_STATE_RESETTING;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	if (hba->cardtype == st_yosemite)
 		return stex_yos_reset(hba);
@@ -1858,12 +1858,12 @@ static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
 	unsigned long before;
 	u16 tag = 0;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 
 	if ((hba->cardtype == st_yel || hba->cardtype == st_P3) &&
 		hba->supports_pm == 1) {
 		if (st_sleep_mic == ST_NOTHANDLED) {
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			spin_unlock_irqrestore(&hba->host->host_lock, flags);
 			return;
 		}
 	}
@@ -1899,7 +1899,7 @@ static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
 	hba->ccb[tag].sense_buffer = NULL;
 	hba->ccb[tag].req_type = PASSTHRU_REQ_TYPE;
 	hba->send(hba, req, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	before = jiffies;
 	while (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE) {
 		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 27e22acaf1a7e..e3783c015b02d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -531,9 +531,9 @@ static irqreturn_t sym53c8xx_intr(int irq, void *dev_id)
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
-	spin_lock(shost->host_lock);
+	spin_lock(&shost->host_lock);
 	result = sym_interrupt(shost);
-	spin_unlock(shost->host_lock);
+	spin_unlock(&shost->host_lock);
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("]\n");
 
@@ -548,9 +548,9 @@ static void sym53c8xx_timer(struct timer_list *t)
 	struct sym_hcb *np = timer_container_of(np, t, s.timer);
 	unsigned long flags;
 
-	spin_lock_irqsave(np->s.host->host_lock, flags);
+	spin_lock_irqsave(&np->s.host->host_lock, flags);
 	sym_timer(np);
-	spin_unlock_irqrestore(np->s.host->host_lock, flags);
+	spin_unlock_irqrestore(&np->s.host->host_lock, flags);
 }
 
 
@@ -587,7 +587,7 @@ static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 	if (pci_channel_offline(pdev))
 		return SCSI_FAILED;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
 		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
@@ -605,13 +605,13 @@ static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 	if (cmd_queued) {
 		init_completion(&eh_done);
 		ucmd->eh_done = &eh_done;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		if (!wait_for_completion_timeout(&eh_done, 5*HZ)) {
 			ucmd->eh_done = NULL;
 			sts = -2;
 		}
 	} else {
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 	}
 
 	dev_warn(&cmd->device->sdev_gendev, "ABORT operation %s.\n",
@@ -639,7 +639,7 @@ static int sym53c8xx_eh_target_reset_handler(struct scsi_cmnd *cmd)
 	if (pci_channel_offline(pdev))
 		return SCSI_FAILED;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	sts = sym_reset_scsi_target(np, starget->id);
 	if (!sts) {
 		FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
@@ -655,15 +655,15 @@ static int sym53c8xx_eh_target_reset_handler(struct scsi_cmnd *cmd)
 			ucmd = SYM_UCMD_PTR(cmd);
 			init_completion(&eh_done);
 			ucmd->eh_done = &eh_done;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock_irq(&shost->host_lock);
 			if (!wait_for_completion_timeout(&eh_done, 5*HZ)) {
 				ucmd->eh_done = NULL;
 				sts = -2;
 			}
-			spin_lock_irq(shost->host_lock);
+			spin_lock_irq(&shost->host_lock);
 		}
 	}
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	starget_printk(KERN_WARNING, starget, "TARGET RESET operation %s.\n",
 			sts==0 ? "complete" :sts==-2 ? "timed-out" : "failed");
@@ -685,9 +685,9 @@ static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 	if (pci_channel_offline(pdev))
 		return SCSI_FAILED;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	sym_reset_scsi_bus(np, 1);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 
 	dev_warn(&cmd->device->sdev_gendev, "BUS RESET operation complete.\n");
 	return SCSI_SUCCESS;
@@ -713,21 +713,21 @@ static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 #define WAIT_FOR_PCI_RECOVERY	35
 	if (pci_channel_offline(pdev)) {
 		init_completion(&eh_done);
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		/* Make sure we didn't race */
 		if (pci_channel_offline(pdev)) {
 			BUG_ON(sym_data->io_reset);
 			sym_data->io_reset = &eh_done;
 			finished_reset = 0;
 		}
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		if (!finished_reset)
 			finished_reset = wait_for_completion_timeout
 						(sym_data->io_reset,
 						WAIT_FOR_PCI_RECOVERY*HZ);
-		spin_lock_irq(shost->host_lock);
+		spin_lock_irq(&shost->host_lock);
 		sym_data->io_reset = NULL;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 	}
 
 	if (finished_reset) {
@@ -776,7 +776,7 @@ static int sym53c8xx_sdev_init(struct scsi_device *sdev)
 	if (sdev->id >= SYM_CONF_MAX_TARGET || sdev->lun >= SYM_CONF_MAX_LUN)
 		return -ENXIO;
 
-	spin_lock_irqsave(np->s.host->host_lock, flags);
+	spin_lock_irqsave(&np->s.host->host_lock, flags);
 
 	/*
 	 * Fail the device init if the device is flagged NOSCAN at BOOT in
@@ -817,7 +817,7 @@ static int sym53c8xx_sdev_init(struct scsi_device *sdev)
 
 	error = 0;
 out:
-	spin_unlock_irqrestore(np->s.host->host_lock, flags);
+	spin_unlock_irqrestore(&np->s.host->host_lock, flags);
 
 	return error;
 }
@@ -873,7 +873,7 @@ static void sym53c8xx_sdev_destroy(struct scsi_device *sdev)
 	if (!lp)
 		return;
 
-	spin_lock_irqsave(np->s.host->host_lock, flags);
+	spin_lock_irqsave(&np->s.host->host_lock, flags);
 
 	if (lp->busy_itlq || lp->busy_itl) {
 		/*
@@ -896,7 +896,7 @@ static void sym53c8xx_sdev_destroy(struct scsi_device *sdev)
 		tp->starget	     = NULL;
 	}
 
-	spin_unlock_irqrestore(np->s.host->host_lock, flags);
+	spin_unlock_irqrestore(&np->s.host->host_lock, flags);
 }
 
 /*
@@ -1191,9 +1191,9 @@ printk("sym_user_command: data=%ld\n", uc->data);
 	else {
 		unsigned long flags;
 
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock_irqsave(&shost->host_lock, flags);
 		sym_exec_user_command(np, uc);
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 	}
 	return length;
 }
@@ -1371,7 +1371,7 @@ static struct Scsi_Host *sym_attach(const struct scsi_host_template *tpnt, int u
 	 *  After SCSI devices have been opened, we cannot
 	 *  reset the bus safely, so we do it here.
 	 */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (sym_reset_scsi_bus(np, 0))
 		goto reset_failed;
 
@@ -1407,14 +1407,14 @@ static struct Scsi_Host *sym_attach(const struct scsi_host_template *tpnt, int u
 	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && pdev->revision < 2)
 		shost->dma_boundary = 0xFFFFFF;
 
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	return shost;
 
  reset_failed:
 	printf_err("%s: FATAL ERROR: CHECK SCSI BUS - CABLES, "
 		   "TERMINATION, DEVICE POWER etc.!\n", sym_name(np));
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
  attach_failed:
 	printf_info("sym%d: giving up ...\n", unit);
 	if (np)
@@ -1903,10 +1903,10 @@ static void sym2_io_resume(struct pci_dev *pdev)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct sym_data *sym_data = shost_priv(shost);
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irq(&shost->host_lock);
 	if (sym_data->io_reset)
 		complete(sym_data->io_reset);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irq(&shost->host_lock);
 }
 
 static void sym2_get_signalling(struct Scsi_Host *shost)
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 1e49d0402f0b5..2a698b93faf8f 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1515,7 +1515,7 @@ wd33c93_host_reset(struct scsi_cmnd * SCpnt)
 	int i;
 
 	instance = SCpnt->device->host;
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irq(&instance->host_lock);
 	hostdata = (struct WD33C93_hostdata *) instance->hostdata;
 
 	printk("scsi%d: reset. ", instance->host_no);
@@ -1541,7 +1541,7 @@ wd33c93_host_reset(struct scsi_cmnd * SCpnt)
 	reset_wd33c93(instance);
 	SCpnt->result = DID_RESET << 16;
 	enable_irq(instance->irq);
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irq(&instance->host_lock);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 830d40f57f6a4..85cf6c9d2ec90 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -270,11 +270,11 @@ static enum scsi_qc_status wd719x_queuecommand(struct Scsi_Host *sh,
 		scb->data_p = 0;
 	}
 
-	spin_lock_irqsave(wd->sh->host_lock, flags);
+	spin_lock_irqsave(&wd->sh->host_lock, flags);
 
 	/* check if the Command register is free */
 	if (wd719x_readb(wd, WD719X_AMR_COMMAND) != WD719X_CMD_READY) {
-		spin_unlock_irqrestore(wd->sh->host_lock, flags);
+		spin_unlock_irqrestore(&wd->sh->host_lock, flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -285,7 +285,7 @@ static enum scsi_qc_status wd719x_queuecommand(struct Scsi_Host *sh,
 	/* send SCB opcode */
 	wd719x_writeb(wd, WD719X_AMR_COMMAND, WD719X_CMD_PROCESS_SCB);
 
-	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+	spin_unlock_irqrestore(&wd->sh->host_lock, flags);
 	return 0;
 
 out_unmap_sense:
@@ -473,12 +473,12 @@ static int wd719x_abort(struct scsi_cmnd *cmd)
 
 	action = WD719X_CMD_ABORT;
 
-	spin_lock_irqsave(wd->sh->host_lock, flags);
+	spin_lock_irqsave(&wd->sh->host_lock, flags);
 	result = wd719x_direct_cmd(wd, action, cmd->device->id,
 				   cmd->device->lun, scsi_cmd_to_rq(cmd)->tag,
 				   scb->phys, 0);
 	wd719x_finish_cmd(scb, DID_ABORT);
-	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+	spin_unlock_irqrestore(&wd->sh->host_lock, flags);
 	if (result)
 		return FAILED;
 
@@ -495,7 +495,7 @@ static int wd719x_reset(struct scsi_cmnd *cmd, u8 opcode, u8 device)
 	dev_info(&wd->pdev->dev, "%s reset requested\n",
 		 (opcode == WD719X_CMD_BUSRESET) ? "bus" : "device");
 
-	spin_lock_irqsave(wd->sh->host_lock, flags);
+	spin_lock_irqsave(&wd->sh->host_lock, flags);
 	result = wd719x_direct_cmd(wd, opcode, device, 0, 0, 0,
 				   WD719X_WAIT_FOR_SCSI_RESET);
 	/* flush all SCBs (or all for a device if dev_reset) */
@@ -504,7 +504,7 @@ static int wd719x_reset(struct scsi_cmnd *cmd, u8 opcode, u8 device)
 		    scb->cmd->device->id == device)
 			wd719x_finish_cmd(scb, DID_RESET);
 	}
-	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+	spin_unlock_irqrestore(&wd->sh->host_lock, flags);
 	if (result)
 		return FAILED;
 
@@ -528,7 +528,7 @@ static int wd719x_host_reset(struct scsi_cmnd *cmd)
 	unsigned long flags;
 
 	dev_info(&wd->pdev->dev, "host reset requested\n");
-	spin_lock_irqsave(wd->sh->host_lock, flags);
+	spin_lock_irqsave(&wd->sh->host_lock, flags);
 	/* stop the RISC */
 	if (wd719x_direct_cmd(wd, WD719X_CMD_SLEEP, 0, 0, 0, 0,
 			      WD719X_WAIT_FOR_RISC))
@@ -539,7 +539,7 @@ static int wd719x_host_reset(struct scsi_cmnd *cmd)
 	/* flush all SCBs */
 	list_for_each_entry_safe(scb, tmp, &wd->active_scbs, list)
 		wd719x_finish_cmd(scb, DID_RESET);
-	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+	spin_unlock_irqrestore(&wd->sh->host_lock, flags);
 
 	/* Try to reinit the RISC */
 	return wd719x_chip_init(wd) == 0 ? SUCCESS : FAILED;
@@ -663,7 +663,7 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 	unsigned long flags;
 	u32 SCB_out;
 
-	spin_lock_irqsave(wd->sh->host_lock, flags);
+	spin_lock_irqsave(&wd->sh->host_lock, flags);
 	/* read SCB pointer back from card */
 	SCB_out = wd719x_readl(wd, WD719X_AMR_SCB_OUT);
 	/* read all status info at once */
@@ -671,7 +671,7 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 
 	switch (regs.bytes.INT) {
 	case WD719X_INT_NONE:
-		spin_unlock_irqrestore(wd->sh->host_lock, flags);
+		spin_unlock_irqrestore(&wd->sh->host_lock, flags);
 		return IRQ_NONE;
 	case WD719X_INT_LINKNOSTATUS:
 		dev_err(&wd->pdev->dev, "linked command completed with no status\n");
@@ -708,7 +708,7 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 	}
 	/* clear interrupt so another can happen */
 	wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
-	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+	spin_unlock_irqrestore(&wd->sh->host_lock, flags);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 989bcaee42caf..2bff5e35822f1 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -417,13 +417,13 @@ static int scsifront_cmd_done(struct vscsifrnt_info *info,
 	int more_to_do;
 	unsigned long flags;
 
-	spin_lock_irqsave(info->host->host_lock, flags);
+	spin_lock_irqsave(&info->host->host_lock, flags);
 
 	more_to_do = scsifront_ring_drain(info, eoiflag);
 
 	info->wait_ring_available = 0;
 
-	spin_unlock_irqrestore(info->host->host_lock, flags);
+	spin_unlock_irqrestore(&info->host->host_lock, flags);
 
 	wake_up(&info->wq_sync);
 
@@ -619,9 +619,9 @@ static enum scsi_qc_status scsifront_queuecommand(struct Scsi_Host *shost,
 	shadow->sc  = sc;
 	shadow->act = VSCSIIF_ACT_SCSI_CDB;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	if (scsifront_enter(info)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -629,7 +629,7 @@ static enum scsi_qc_status scsifront_queuecommand(struct Scsi_Host *shost,
 	if (err < 0) {
 		pr_debug("%s: err %d\n", __func__, err);
 		scsifront_return(info);
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->host_lock, flags);
 		if (err == -ENOMEM)
 			return SCSI_MLQUEUE_HOST_BUSY;
 		sc->result = DID_ERROR << 16;
@@ -643,13 +643,13 @@ static enum scsi_qc_status scsifront_queuecommand(struct Scsi_Host *shost,
 	}
 
 	scsifront_return(info);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	return 0;
 
 busy:
 	scsifront_return(info);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 	pr_debug("%s: busy\n", __func__);
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
@@ -679,7 +679,7 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 	shadow->ref_rqid = s->rqid;
 	init_waitqueue_head(&shadow->wq_reset);
 
-	spin_lock_irq(host->host_lock);
+	spin_lock_irq(&host->host_lock);
 
 	for (;;) {
 		if (scsifront_enter(info))
@@ -692,15 +692,15 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 		if (err)
 			goto fail;
 		info->wait_ring_available = 1;
-		spin_unlock_irq(host->host_lock);
+		spin_unlock_irq(&host->host_lock);
 		err = wait_event_interruptible(info->wq_sync,
 					       !info->wait_ring_available);
-		spin_lock_irq(host->host_lock);
+		spin_lock_irq(&host->host_lock);
 	}
 
-	spin_unlock_irq(host->host_lock);
+	spin_unlock_irq(&host->host_lock);
 	err = wait_event_interruptible(shadow->wq_reset, shadow->wait_reset);
-	spin_lock_irq(host->host_lock);
+	spin_lock_irq(&host->host_lock);
 
 	if (!err) {
 		err = shadow->rslt_reset;
@@ -714,11 +714,11 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 	}
 
 	scsifront_return(info);
-	spin_unlock_irq(host->host_lock);
+	spin_unlock_irq(&host->host_lock);
 	return err;
 
 fail:
-	spin_unlock_irq(host->host_lock);
+	spin_unlock_irq(&host->host_lock);
 	kfree(shadow);
 	return FAILED;
 }
@@ -953,12 +953,12 @@ static int scsifront_resume(struct xenbus_device *dev)
 	struct Scsi_Host *host = info->host;
 	int err;
 
-	spin_lock_irq(host->host_lock);
+	spin_lock_irq(&host->host_lock);
 
 	/* Finish all still pending commands. */
 	scsifront_finish_all(info);
 
-	spin_unlock_irq(host->host_lock);
+	spin_unlock_irq(&host->host_lock);
 
 	/* Reconnect to dom0. */
 	scsifront_free_ring(info);
@@ -981,18 +981,18 @@ static int scsifront_suspend(struct xenbus_device *dev)
 	int err = 0;
 
 	/* No new commands for the backend. */
-	spin_lock_irq(host->host_lock);
+	spin_lock_irq(&host->host_lock);
 	info->pause = 1;
 	while (info->callers && !err) {
 		info->waiting_pause = 1;
 		info->wait_ring_available = 0;
-		spin_unlock_irq(host->host_lock);
+		spin_unlock_irq(&host->host_lock);
 		wake_up(&info->wq_sync);
 		err = wait_event_interruptible(info->wq_pause,
 					       !info->waiting_pause);
-		spin_lock_irq(host->host_lock);
+		spin_lock_irq(&host->host_lock);
 	}
-	spin_unlock_irq(host->host_lock);
+	spin_unlock_irq(&host->host_lock);
 	return err;
 }
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 9ed2818c3028d..fd1b82fc72902 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -348,7 +348,7 @@ static struct se_device *pscsi_alloc_device(struct se_hba *hba,
  * Called with struct Scsi_Host->host_lock called.
  */
 static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
-	__releases(sh->host_lock)
+	__releases(&sh->host_lock)
 {
 	struct pscsi_hba_virt *phv = dev->se_hba->hba_ptr;
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
@@ -359,10 +359,10 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 	if (scsi_device_get(sd)) {
 		pr_err("scsi_device_get() failed for %d:%d:%d:%llu\n",
 			sh->host_no, sd->channel, sd->id, sd->lun);
-		spin_unlock_irq(sh->host_lock);
+		spin_unlock_irq(&sh->host_lock);
 		return -EIO;
 	}
-	spin_unlock_irq(sh->host_lock);
+	spin_unlock_irq(&sh->host_lock);
 	/*
 	 * Claim exclusive struct block_device access to struct scsi_device
 	 * for TYPE_DISK and TYPE_ZBC using supplied udev_path
@@ -393,7 +393,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
  * Called with struct Scsi_Host->host_lock called.
  */
 static int pscsi_create_type_nondisk(struct se_device *dev, struct scsi_device *sd)
-	__releases(sh->host_lock)
+	__releases(&sh->host_lock)
 {
 	struct pscsi_hba_virt *phv = dev->se_hba->hba_ptr;
 	struct Scsi_Host *sh = sd->host;
@@ -402,10 +402,10 @@ static int pscsi_create_type_nondisk(struct se_device *dev, struct scsi_device *
 	if (scsi_device_get(sd)) {
 		pr_err("scsi_device_get() failed for %d:%d:%d:%llu\n",
 			sh->host_no, sd->channel, sd->id, sd->lun);
-		spin_unlock_irq(sh->host_lock);
+		spin_unlock_irq(&sh->host_lock);
 		return -EIO;
 	}
-	spin_unlock_irq(sh->host_lock);
+	spin_unlock_irq(&sh->host_lock);
 
 	ret = pscsi_add_device_to_list(dev, sd);
 	if (ret) {
@@ -491,7 +491,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		}
 	}
 
-	spin_lock_irq(sh->host_lock);
+	spin_lock_irq(&sh->host_lock);
 	list_for_each_entry(sd, &sh->__devices, siblings) {
 		if ((pdv->pdv_channel_id != sd->channel) ||
 		    (pdv->pdv_target_id != sd->id) ||
@@ -524,7 +524,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		}
 		return 0;
 	}
-	spin_unlock_irq(sh->host_lock);
+	spin_unlock_irq(&sh->host_lock);
 
 	pr_err("pSCSI: Unable to locate %d:%d:%d:%d\n", sh->host_no,
 		pdv->pdv_channel_id,  pdv->pdv_target_id, pdv->pdv_lun_id);
diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index ed1de70e2ec1c..9f83628f3e2cf 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -177,7 +177,7 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
 	if (ret < 0)
 		return ret;
 
-	spin_lock_irq(hba->host->host_lock);
+	spin_lock_irq(&hba->host->host_lock);
 	if (strcmp(attr->name, "saved_err") == 0) {
 		hba->saved_err = val;
 	} else if (strcmp(attr->name, "saved_uic_err") == 0) {
@@ -187,7 +187,7 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
 	}
 	if (ret == 0)
 		ufshcd_schedule_eh_work(hba);
-	spin_unlock_irq(hba->host->host_lock);
+	spin_unlock_irq(&hba->host->host_lock);
 
 	return ret < 0 ? ret : count;
 }
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 63e670d1a9d9e..cf49ad0258e14 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -150,12 +150,12 @@ static inline ssize_t ufs_sysfs_pm_lvl_store(struct device *dev,
 	     !(dev_info->wspecversion >= 0x310)))
 		return -EINVAL;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (rpm)
 		hba->rpm_lvl = value;
 	else
 		hba->spm_lvl = value;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	return count;
 }
 
@@ -787,7 +787,7 @@ static ssize_t monitor_enable_store(struct device *dev,
 		return -EINVAL;
 
 	value = !!value;
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (value == hba->monitor.enabled)
 		goto out_unlock;
 
@@ -799,7 +799,7 @@ static ssize_t monitor_enable_store(struct device *dev,
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	return count;
 }
 
@@ -821,11 +821,11 @@ static ssize_t monitor_chunk_size_store(struct device *dev,
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	/* Only allow chunk size change when monitor is disabled */
 	if (!hba->monitor.enabled)
 		hba->monitor.chunk_size = value;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	return count;
 }
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 67745d2796d0a..05ab857de81c9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1273,10 +1273,10 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 	unsigned long flags;
 	u32 pending = 0;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	__shost_for_each_device(sdev, hba->host)
 		pending += scsi_device_busy(sdev);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return pending;
 }
@@ -2061,7 +2061,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 			return;
 	}
 
-	scoped_guard(spinlock_irqsave, hba->host->host_lock) {
+	scoped_guard(spinlock_irqsave, &hba->host->host_lock) {
 		if (ufshcd_is_ufs_dev_busy(hba) ||
 		    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
 			return;
@@ -2118,7 +2118,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
-	scoped_guard(spinlock_irqsave, hba->host->host_lock) {
+	scoped_guard(spinlock_irqsave, &hba->host->host_lock) {
 		if (ufshcd_has_pending_tasks(hba) ||
 		    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
 			return;
@@ -2343,10 +2343,10 @@ static void ufshcd_start_monitor(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 	int dir = ufshcd_monitor_opcode2dir(cmd->cmnd[0]);
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (dir >= 0 && hba->monitor.nr_queued[dir]++ == 0)
 		hba->monitor.busy_start_ts[dir] = ktime_get();
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 }
 
 static void ufshcd_update_monitor(struct ufs_hba *hba, struct scsi_cmnd *cmd)
@@ -2356,7 +2356,7 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 	int dir = ufshcd_monitor_opcode2dir(cmd->cmnd[0]);
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
 		struct ufs_hba_monitor *m = &hba->monitor;
 		ktime_t now, inc, lat;
@@ -2379,7 +2379,7 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 		/* Push forward the busy start of monitor */
 		m->busy_start_ts[dir] = now;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 }
 
 /* Returns %true for SCSI commands and %false for device management commands. */
@@ -2636,9 +2636,9 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 		}
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return ret;
 }
@@ -2688,9 +2688,9 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
 	if (!ret)
@@ -3162,9 +3162,9 @@ static enum scsi_qc_status ufshcd_queuecommand(struct Scsi_Host *host,
 	if (ufs_trigger_eh(hba)) {
 		unsigned long flags;
 
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 		ufshcd_schedule_eh_work(hba);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	}
 
 	return err;
@@ -4498,14 +4498,14 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (ufshcd_is_link_broken(hba)) {
 		ret = -ENOLINK;
 		goto out_unlock;
 	}
 	hba->uic_async_done = &uic_async_done;
 	ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	ret = __ufshcd_send_uic_cmd(hba, cmd);
 	if (ret) {
 		dev_err(hba->dev,
@@ -4549,7 +4549,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		ufshcd_print_evt_hist(hba);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
 	hba->uic_async_done = NULL;
 	if (ret && !hba->pm_op_in_progress) {
@@ -4557,7 +4557,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		ufshcd_schedule_eh_work(hba);
 	}
 out_unlock:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
 	return ret;
@@ -4652,21 +4652,21 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	int ret;
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
 	ufshcd_set_eh_in_progress(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	/* Reset the attached device */
 	ufshcd_device_reset(hba);
 
 	ret = ufshcd_host_reset_and_restore(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (ret)
 		hba->ufshcd_state = UFSHCD_STATE_ERROR;
 	ufshcd_clear_eh_in_progress(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	if (ret)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
@@ -5667,19 +5667,19 @@ static void ufshcd_sdev_destroy(struct scsi_device *sdev)
 
 	/* Drop the reference as it won't be needed anymore */
 	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN) {
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 		hba->ufs_device_wlun = NULL;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	} else if (hba->ufs_device_wlun) {
 		struct device *supplier = NULL;
 
 		/* Ensure UFS Device WLUN exists and does not disappear */
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 		if (hba->ufs_device_wlun) {
 			supplier = &hba->ufs_device_wlun->sdev_gendev;
 			get_device(supplier);
 		}
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 		if (supplier) {
 			/*
@@ -5872,7 +5872,7 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 	irqreturn_t retval = IRQ_NONE;
 	struct uic_command *cmd;
 
-	guard(spinlock_irqsave)(hba->host->host_lock);
+	guard(spinlock_irqsave)(&hba->host->host_lock);
 	cmd = hba->active_uic_cmd;
 	if (!cmd) {
 		dev_err(hba->dev,
@@ -6669,7 +6669,7 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 	unsigned long flags;
 	bool err_handling = true;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	/*
 	 * UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS only workaround the
 	 * device fatal error and/or DL NAC & REPLAY timeout errors.
@@ -6688,9 +6688,9 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 		/*
 		 * wait for 50ms to see if we can get any other errors or not.
 		 */
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		msleep(50);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 
 		/*
 		 * now check if we have got any other severe errors other than
@@ -6708,9 +6708,9 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 		 *   - If we get response then clear the DL NAC error bit.
 		 */
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		err = ufshcd_verify_dev_init(hba);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 
 		if (err)
 			goto out;
@@ -6724,7 +6724,7 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 			err_handling = false;
 	}
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	return err_handling;
 }
 
@@ -6737,7 +6737,7 @@ static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
 
 void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 {
-	lockdep_assert_held(hba->host->host_lock);
+	lockdep_assert_held(&hba->host->host_lock);
 
 	/* handle fatal errors only when link is not in error state */
 	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
@@ -6752,10 +6752,10 @@ void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 
 void ufshcd_force_error_recovery(struct ufs_hba *hba)
 {
-	spin_lock_irq(hba->host->host_lock);
+	spin_lock_irq(&hba->host->host_lock);
 	hba->force_reset = true;
 	ufshcd_schedule_eh_work(hba);
-	spin_unlock_irq(hba->host->host_lock);
+	spin_unlock_irq(&hba->host->host_lock);
 }
 EXPORT_SYMBOL_GPL(ufshcd_force_error_recovery);
 
@@ -6996,25 +6996,25 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 
 	down(&hba->host_sem);
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		up(&hba->host_sem);
 		return;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	ufshcd_err_handling_prepare(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	ufshcd_set_eh_in_progress(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba, false);
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 again:
 	needs_restore = false;
 	needs_reset = false;
@@ -7032,10 +7032,10 @@ static void ufshcd_err_handler(struct work_struct *work)
 	    !hba->force_reset) {
 		bool ret;
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		/* release the lock as ufshcd_quirk_dl_nac_errors() may sleep */
 		ret = ufshcd_quirk_dl_nac_errors(hba);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 		if (!ret && ufshcd_err_handling_should_stop(hba))
 			goto skip_err_handling;
 	}
@@ -7045,14 +7045,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 	     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
 		bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
 		ufshcd_print_tx_eq_params(hba);
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_tmrs(hba, hba->outstanding_tasks);
 		ufshcd_print_trs_all(hba, pr_prdt);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 	}
 
 	/*
@@ -7077,21 +7077,21 @@ static void ufshcd_err_handler(struct work_struct *work)
 		hba->saved_uic_err &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
 		if (!hba->saved_uic_err)
 			hba->saved_err &= ~UIC_ERROR;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		if (ufshcd_is_pwr_mode_restore_needed(hba))
 			needs_restore = true;
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 		if (!hba->saved_err && !needs_restore)
 			goto skip_err_handling;
 	}
 
 	hba->silence_err_logs = true;
 	/* release lock as clear command might sleep */
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	needs_reset = ufshcd_abort_all(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	hba->silence_err_logs = false;
 	if (needs_reset)
 		goto do_reset;
@@ -7101,7 +7101,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	 * now it is safe to retore power mode.
 	 */
 	if (needs_restore) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		/*
 		 * Hold the scaling lock just in case dev cmds
 		 * are sent via bsg and/or sysfs.
@@ -7116,7 +7116,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 		}
 		ufshcd_print_pwr_info(hba);
 		up_write(&hba->clk_scaling_lock);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 	}
 
 do_reset:
@@ -7125,14 +7125,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		int err;
 
 		hba->force_reset = false;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		err = ufshcd_reset_and_restore(hba);
 		if (err)
 			dev_err(hba->dev, "%s: reset and restore failed with err %d\n",
 					__func__, err);
 		else
 			ufshcd_recover_pm_error(hba);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 	}
 
 skip_err_handling:
@@ -7151,7 +7151,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 		hba->ufshcd_state = UFSHCD_STATE_ERROR;
 	}
 	ufshcd_clear_eh_in_progress(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->host_sem);
 
@@ -7274,7 +7274,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 	bool queue_eh_work = false;
 	irqreturn_t retval = IRQ_NONE;
 
-	guard(spinlock_irqsave)(hba->host->host_lock);
+	guard(spinlock_irqsave)(&hba->host->host_lock);
 	hba->errors |= UFSHCD_ERROR_MASK & intr_status;
 
 	if (hba->errors & INT_FATAL_ERRORS) {
@@ -7352,7 +7352,7 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 	irqreturn_t ret = IRQ_NONE;
 	int tag;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	issued = hba->outstanding_tasks & ~pending;
 	for_each_set_bit(tag, &issued, hba->nutmrs) {
@@ -7362,7 +7362,7 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 		complete(c);
 		ret = IRQ_HANDLED;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return ret;
 }
@@ -7564,7 +7564,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	req->end_io_data = &wait;
 	ufshcd_hold(hba);
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 
 	task_tag = req->tag;
 	hba->tmf_rqs[req->tag] = req;
@@ -7575,7 +7575,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	__set_bit(task_tag, &hba->outstanding_tasks);
 
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
 
 	/* send command to the controller */
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
@@ -7600,10 +7600,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_COMP);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	hba->tmf_rqs[req->tag] = NULL;
 	__clear_bit(task_tag, &hba->outstanding_tasks);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	ufshcd_release(hba);
 	blk_mq_free_request(req);
@@ -8151,10 +8151,10 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
 
-		spin_lock_irqsave(host->host_lock, flags);
+		spin_lock_irqsave(&host->host_lock, flags);
 		hba->force_reset = true;
 		ufshcd_schedule_eh_work(hba);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		spin_unlock_irqrestore(&host->host_lock, flags);
 		goto release;
 	}
 
@@ -8212,12 +8212,12 @@ static void ufshcd_process_probe_result(struct ufs_hba *hba,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (ret)
 		hba->ufshcd_state = UFSHCD_STATE_ERROR;
 	else if (hba->ufshcd_state == UFSHCD_STATE_RESET)
 		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	trace_ufshcd_init(hba, ret,
 			  ktime_to_us(ktime_sub(ktime_get(), probe_start)),
@@ -8286,7 +8286,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	unsigned long flags;
 	int retries = MAX_HOST_RESET_RETRIES;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	do {
 		/*
 		 * This is a fresh start, cache and clear saved error first,
@@ -8298,14 +8298,14 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 		hba->saved_uic_err = 0;
 		hba->force_reset = false;
 		hba->ufshcd_state = UFSHCD_STATE_RESET;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 		/* Reset the attached device */
 		ufshcd_device_reset(hba);
 
 		err = ufshcd_host_reset_and_restore(hba);
 
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 		if (err)
 			continue;
 		/* Do not exit unless operational or dead */
@@ -8325,7 +8325,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 		hba->saved_err |= saved_err;
 		hba->saved_uic_err |= saved_uic_err;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return err;
 }
@@ -8357,18 +8357,18 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 		return err;
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	hba->force_reset = true;
 	ufshcd_schedule_eh_work(hba);
 	dev_err(hba->dev, "%s: reset in progress - 1\n", __func__);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	flush_work(&hba->eh_work);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (hba->ufshcd_state == UFSHCD_STATE_ERROR)
 		err = FAILED;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	return err;
 }
@@ -10113,13 +10113,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
 	if (sdp && scsi_device_online(sdp))
 		ret = scsi_device_get(sdp);
 	else
 		ret = -ENODEV;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
 	if (ret)
 		return ret;
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 814c1b7343b9e..359cdb30e9b65 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1124,9 +1124,9 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 				ah_ms = ah_timer * scale_us[ah_scale] / 1000;
 		}
 
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->host->host_lock, flags);
 		hba->clk_gating.delay_ms = max(ah_ms, 10U);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 	}
 }
 
diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index a5e8c591beadd..6862250c542e0 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -181,9 +181,9 @@ static int ufs_sprd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 	if (status == PRE_CHANGE) {
 		if (ufshcd_is_auto_hibern8_supported(hba)) {
-			spin_lock_irqsave(hba->host->host_lock, flags);
+			spin_lock_irqsave(&hba->host->host_lock, flags);
 			ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		}
 	}
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2651629812694..8655edbd66b16 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1130,9 +1130,9 @@ static int uas_pre_reset(struct usb_interface *intf)
 		return 0;
 
 	/* Block new requests */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	scsi_block_requests(shost);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	if (uas_wait_for_pending_cmnds(devinfo) != 0) {
 		shost_printk(KERN_ERR, shost, "%s: timed out\n", __func__);
@@ -1162,9 +1162,9 @@ static int uas_post_reset(struct usb_interface *intf)
 			     __func__, err);
 
 	/* we must unblock the host in every case lest we deadlock */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	scsi_report_bus_reset(shost, 0);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	scsi_unblock_requests(shost);
 
@@ -1204,9 +1204,9 @@ static int uas_reset_resume(struct usb_interface *intf)
 		return -EIO;
 	}
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->host_lock, flags);
 	scsi_report_bus_reset(shost, 0);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
 
 	return 0;
 }
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 97c6196d639b4..c26d008e5184e 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -166,8 +166,8 @@ extern void fill_inquiry_response(struct us_data *us,
  * The scsi_lock() and scsi_unlock() macros protect the sm_state and the
  * single queue element srb for write access
  */
-#define scsi_unlock(host)	spin_unlock_irq(host->host_lock)
-#define scsi_lock(host)		spin_lock_irq(host->host_lock)
+#define scsi_unlock(host)	spin_unlock_irq(&host->host_lock)
+#define scsi_lock(host)		spin_lock_irq(&host->host_lock)
 
 /* General routines provided by the usb-storage standard core */
 #ifdef CONFIG_PM
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c9754771bf297..23b8119947783 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -534,9 +534,9 @@ struct scsi_host_template {
 		unsigned long irq_flags;				\
 		enum scsi_qc_status rc;					\
 									\
-		spin_lock_irqsave(shost->host_lock, irq_flags);		\
+		spin_lock_irqsave(&shost->host_lock, irq_flags);	\
 		rc = func_name##_lck(cmd);				\
-		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
+		spin_unlock_irqrestore(&shost->host_lock, irq_flags);	\
 		return rc;						\
 	}
 
@@ -570,8 +570,7 @@ struct Scsi_Host {
 	
 	struct list_head	starved_list;
 
-	spinlock_t		default_lock;
-	spinlock_t		*host_lock;
+	spinlock_t		host_lock;
 
 	struct mutex		scan_mutex;/* serialize scanning activity */
 
@@ -950,6 +949,6 @@ static inline unsigned char scsi_host_get_guard(struct Scsi_Host *shost)
 }
 
 int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
-	__must_hold(shost->host_lock);
+	__must_hold(&shost->host_lock);
 
 #endif /* _SCSI_SCSI_HOST_H */
-- 
2.43.7

