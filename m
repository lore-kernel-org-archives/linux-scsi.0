Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA26E46D54A;
	Mon,  7 Sep 2026 10:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778348; cv=fail; b=mAN2+4Am/nzxMg9FqkmYq0nsJvID8zWkilzOzYMfg9FhrNnowWoWCuPCcFIqQTzxGGZyBei7GJQgbHtiYmSKWoaZRm4BGzZQFB8H33YkOwBp1xV0o5Jtxk6ETGQfnG3+fVHtzzXUeqjWQX/VLLeEp3vSFjqXVRFFPQeYyP11gHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778348; c=relaxed/simple;
	bh=Vnz2OUaPNniK6HtPHygHLBw4ZmmuknUJ4SGgpXz/Dl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YFcob4wvlMjbizmq/pAA/AwOgYdhh0n6ltmFi0MSGf3ZgGZG4aqxtkx9hqCNX1u6mQYloMcerTETJWl1poUP6YrPnbn5hBl4BRjEpnMZGDEVlUSzW4/K6xLOP3fUDQAT1SrSCWKmphQtCwIL2dyIXWmeoDjh8G4hRs0UxYWLydU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aGKvcoR4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y+NwbJBP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aGKvcoR4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y+NwbJBP"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686NwXa4204422;
	Mon, 7 Sep 2026 10:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=reDciKOIhgVtvaKtpnUTCmO8AyBTyM3r8+5i0QoLiJE=; b=
	aGKvcoR45vLAmHgdUypfQ7cYqoLAvP3ZHpaIM3njuaiwcsy6bhqbPtsmsdzpSdYR
	0jBvlBpT0nujRotnrP68bIeJ2m34KpPjKjVGAREoPXHqFt6v7pRJ3BQjea5l9OJc
	7i4HPDrOBtCQBW2RtT3kAccSVy87FBL410iT2+Z4yhDf2sLpzBCM+8DqcCP7LY5W
	kT/21JkGZliVV/+FW+9QgmPFlmQnCZwhMFX7Q+NMdLkvXbseTJqbEtq4isRfF0td
	LAmFOz9FP9RzQfM8Zr4NypaYRQjhZMoBm6iEzsB90o2H/w9xPHQtnZCMeyAlQgUL
	DsSmb62Id+l9Mpd8whOrLQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbhuht1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687ApfQd029304;
	Mon, 7 Sep 2026 10:51:57 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh7aw8bdt-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhj2+lBLyB7PblYZJN/L09w1Qo+wB3fxvb6ZBIuPImSzP/8Zx34u8eBbWE9kXfVHJM5JK3YyHnzcdzlMmcNjG/KqbgdBboObWUVBGf/TwlLd+YFK27A+pzWeIfjvL+LHtW+FPu7gNLAD/D5u1cFhRKHz1baBz+dArhy6ekCb0zd/LNaIh3h7VZI+UgTuUsJ4KfdcyRx3AfwF55o4XpXZBoejGkToLsrYxRsF5ZdBs6N7p5Ktbw/v+kRqscS3ywqgnT7kFB/ivIgV9RuxBTef3i3tbv1Y+eEqmbYoFhWK9e9l3Vw/M8yq6m+iM6QTn2j1uN8EbwcaNaxedNBMUS2Vmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=reDciKOIhgVtvaKtpnUTCmO8AyBTyM3r8+5i0QoLiJE=;
 b=GNSfXBxpoHw7LkRLIKA3tLKmuL+/hrMULgiSQzi5/4PQqO08CIhXCSxQv5CeaJVbE+KkFGqaXC8qYhRDk/KklEOEwBR5DSfVAa0QkU1R4Z6b2OdyS8lAx1SMxHde8UIydHQPoA15nJFj0BpjVwgtIUp9SBgb3WjaSlnAzUwKe/buHGY3W2pAPiMQzeFRwURabYkYhdStGE9CiCL11xiZlJYq29a0J1SEcOD7yUWCffPXlKb/xTR2K0niUjhGfhXlYli5ls9YQSDd+AU4eKGg0ZPRQehCfePUWTNa8Th47OKD4bScRvx3u7fY791B3xp8hexd85XDne8S9YPIMr7stQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=reDciKOIhgVtvaKtpnUTCmO8AyBTyM3r8+5i0QoLiJE=;
 b=Y+NwbJBPwH8bCIvsRrwpYbVHjrwwsbLRwoz+JmKelACRHlLlVdrgFQizH4bVkI4gOzaoADusE/v4GoOZ/qMmsiIfprjIbqDFYZYkfyt/MipVGl1ZfVt4kXqeI0AxoNXdU0+ZAqlUdrFgGw9vhaqhQpqelADF5lwGroIdLA9xqNw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6276.namprd10.prod.outlook.com (2603:10b6:510:210::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:24 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 24/27] scsi: sd: support multipath disk
Date: Mon,  7 Sep 2026 10:50:18 +0000
Message-ID: <20260907105021.1763236-25-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:610:b2::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: a2f1e7e8-f4dc-4e39-9c8c-08df0ccdf490
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|10063799003|22082099003|20046099003|56012099006|5023799004|18002099003;
X-Microsoft-Antispam-Message-Info:
	KE/depIWKtymp4cXpSO6BevanGbNfZl6LmkOaiBGW/04YBbowRGdAUAO3UUi8AairLs9K6IVPcUe+JfXlTf+EB8/jkjZhKcomyhKfRZmiG1troHYhZf2o9V/Zq4obG8eyOWHmdfbxYOElMNPaw3RXnjY5VryLM3ltFBGWF8ly2w15ARIcVTpex35g7Lx5R+tR+egltP09Ys1640ozSHY1Gvr/gK31bdPqI7rfbc7PImpviLDAttmrxeKlI7dTqeu4CNa8bt39qV6+XG9B06j8o6N3Wsyf1qYrNZgGEWW8ZT2gQqLGqCfYRCbv2OgqyyCpLPoYUv5v4wO+sL+UaQhS2/VBMKoBC61Y4h9pYF+A0UZd3aszX7xq9LGy3tHgjD1/0+07wcy5yNwLPPUkJG8etp16ud+egQx+VqtKSbxx1ur8dwnr5HLXmllTPanq3KsQ7AsoZRGZUOxJMpPoKd2H0NrbNgkM1JB1cFa27Yc8ve738ejXOGH0Rj/kwNF5qDgUGwiYYuQq4/l5bDi0jGC0KO7EtqWh+wAIjRIz0Eg2wNhukyhzRxa4cgRCFnWyWa+xIJzDGP3yPXlvfCF+RTXOKfTMqdb3gLhLLuduXrBaNpdL43YTWN+0iDVN6RKQOh3WFrVAgxuk0um0tczwYA7ClhvfoN+CoRCbL6DIuInPx0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(10063799003)(22082099003)(20046099003)(56012099006)(5023799004)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+BMUu+X51SK+zzvCTM23kcb63II37XeQGl8WtfUFb0eYecv7LIU/Zzf/EC5C?=
 =?us-ascii?Q?LWj7kw/Aw8TlH+jj4rCJGcaMPVqkJ4iSDYiyxV8VP5mdDiCjz7ZvM/9Vxesi?=
 =?us-ascii?Q?xZICxzFoEf0jnjimI+67NNnMLM5719LDq6AbZd9Q3sqx0P2RnFhRmu70kc8y?=
 =?us-ascii?Q?yIYPNcqHpD+gICcQgF+U29msH8aiAopwptjVC2GoAd2Cd35L8RanzIXpCAqs?=
 =?us-ascii?Q?c9j3sM/SxfuDMI0PeucqsCEx+rwYim+B11y8NWoWCghnJTw/sOhmYT5rz/uz?=
 =?us-ascii?Q?g0gbt0awCItS6JgIy+Yclqtxv1s3ibDkVLsnzggE+r9o2i5tEqBZVMG81Pw4?=
 =?us-ascii?Q?7aVVpK1qhK6bek5YzUQLgsCsfN/e98XYmnsZUAKUqNe4IZdwvk5Flc1c/gXb?=
 =?us-ascii?Q?A1ZCe2f6WsaKW4vlSqNeBDhgMEX1ggSc2NIa1s3Itt3OLNE8AGKkQ0u+uNhM?=
 =?us-ascii?Q?nE5hkkJk7EFjtLSbonxXQZa4LDW2fOCRFw9AEaN0jqZiue/WQzY/31dgbfIa?=
 =?us-ascii?Q?ZZ4b97ftHNh6CWQ2W39Coj8DEtJPLzF2MHSYbak19ZF6d0ajFblii5gBpI2x?=
 =?us-ascii?Q?ns9IuZwsv47YfiO3QoirFAbGHg/Ytx3TENihtwY4IDPLrheRwkdOe//fvtrb?=
 =?us-ascii?Q?H86JMcnfbrgk2xPEjrVoJ8GU8sTviumHx0JvN1lA8B1qeetcCKeDiTGXUtqP?=
 =?us-ascii?Q?fUZnh2Ti9ZU9ezByjSQo6Mppkmqv/exRGoougYgcGxtrOI4esDeyI9E2SH3g?=
 =?us-ascii?Q?YUAzNmPy3G2/ayUUD9pYt7opYr4tgdwEDO9XjW9alXuPb6ayPPucdhg1+pu0?=
 =?us-ascii?Q?Vo4zZ2ZaBbUghQcT+UgajkdazYeSXJn6AKDV6A1quMDs8gXCBXqhmyofN69n?=
 =?us-ascii?Q?004j25wPdR0atM+FbcQjRXSvLmVjNqoVLeDR5iiOuEztaZ51/CAZIRjublsM?=
 =?us-ascii?Q?qxQ5mRUdLD6uIPwgyb4KCMsINCdSfj1suAqTgI0RgYuSSt6IB3z+/d5DmxlD?=
 =?us-ascii?Q?w9qgHdEkuEGdKFKwBts1pLd87AYzpDL6PvUMe8pXAU2nMzKSvPYCYcUfprQn?=
 =?us-ascii?Q?4LIhvYo06ojzUl/c0k9JwyoP40gRbaDI2+Br3brUpgBjJPS6rnCLcanraqDf?=
 =?us-ascii?Q?uF7krY3w1K/DwWS7wQHogsMz6cPjR+us6PWWnGRAZ3ZpRS97N67lIruh5re2?=
 =?us-ascii?Q?qeekQ3i9l8T0bGDSaTr8IudsNS5D0zaTpyCVMnRT/6bOyyAX/ImL97r14JH8?=
 =?us-ascii?Q?5QvdnlvX++s2FJCsCJRbo7DjDXnsU10mkXzAVn8ZITvojXF7N2U2dS8MBT93?=
 =?us-ascii?Q?XVVhGlb+WF4hBYmJSetxOYajCNDxt/umgT60QBQJPRSy6VEFLcs5GO0s6j6O?=
 =?us-ascii?Q?zZ56sOjgdd6toffpr/F8vweqlEc9VDXPQXv4uGcxCQPuVJwdENXTBbuMk94H?=
 =?us-ascii?Q?RHeCVwzndT66X8xfa4xNuyyrYjUgLu2IYmB0c+2EdNC88K8aKFKnYsNnGY9q?=
 =?us-ascii?Q?ITQA0u7j4cDgAxCYwf1TqYEfrl9hNpgAyhn1j6sbmBm74Ud8mv/LC5feskRS?=
 =?us-ascii?Q?LtUgY5EFiFttcfws5e6pObUzcinPDCvOUP0qboPA3fsNQbAj6FR14Xh7otF0?=
 =?us-ascii?Q?iDz77qaH4AyEmPJEvQjd6SEdg73awleetMccJhMDVtnZw/MYs35Nce390mVX?=
 =?us-ascii?Q?c/BwOaqqWKxkRaWgreOR6OoBC4nr8i8q8HDNscjRIu7YzAnk4bUvUfX6E0lY?=
 =?us-ascii?Q?UL/qJEywsQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	AUQnz4kQ4v29+jl8MNcYQDZhDKQ4gN74/dc7aATCPkrqcMfkIUlO6/dqz2MtU9sX+4ryXTJbBcsfvnJOx+C1IJFTCNKs0vO9/ZOEoGW9bvrJ6thfTYN6NPH9MLiBE6FKSFNfey3TGNbyjW/Szd6UBBnHj+VbTcPr1EWFLYixIqKaFDKaUWJr6KLYAmYn1uSN8vRdhl4MFP625yOpul2F50YHhQPhjnAegFJz/By7fOA8aIWff6hv5GyRyVBl9krs8TE8eLHfrmFZftfivsr0bD84V0R+BdahbwKLNg59wwZnER0DHoye3XA6rP5VQ8NS0SMsVD415xMXXWZwO1gksQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/wvqLLXoZMQmgbVAD3bYDLKMZDcc2J5DjtRrHOQL+Mjpk1mEr7164zBCJFCuDuZXV34sE6YQ1B1UtUYymfKWaOoTfWz5oM+I77d5GmmupwoT/2mx9Ak0OmBTBLv09YQsjyYs6TktVZNS0ehRvxyS91yYx2BvLCraZtENvbZPoTODrZv2hioe/I+eqUVerwQa1PM/Mmi4q84Q/BoB0e0PymJ97Unf/CkQu+0V9lQ6o2pUQmnRy8OExyv+HehWf2raAsDx6ULTuscmh+POFkxrNoC+yatGD3FUGvoPfGM5d6wPko1IhjahWfqiHK/ylXQa6eX0lrONresHrH3wnCkINdNTSay8bF8oooFcT76S1aWi8YIldMRYZCdG3i0clsC+p8eMMxE1Y/c/JxUtjWqQeGQBP1O7mY+LKjTPsdpaYfQRCJfo8NFTrFsF31vd9o8LjEBnz8Yvc8W9ePilJelYx9fdTC/7iRdPcidqfpACCTNeBVF6qORxWIwMK5xq+Hx/X82PSxf1OWHpjl3fsnTmVAoY2wZhnyKXo+leSGkqoMfr9fdVbTowb6I1XP9sX/vhmH60Hp5hTPjeelTeVk6lICXVSZSG6kK5RorvF/KKa9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f1e7e8-f4dc-4e39-9c8c-08df0ccdf490
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:24.0253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoXMq01rM0eux0u3UrJPgnTbSnmYWYsNNOHDf2HloxzEj3oYuiu6e9Kt/Lzg5yYGh7kz2R0QiSte/0ex19IWOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6276
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: ReN1Bsl9GZwFX2Oa7EHEYebI_zJWr9wk
X-Proofpoint-ORIG-GUID: ReN1Bsl9GZwFX2Oa7EHEYebI_zJWr9wk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX9b6zfSvIYOth
 M26mCWSZrOZ7iTASgIEOYejPl7jXx0HEAci5czhRS/mdBsZ1DJywnkICLABbUe/bgNqdeY8SG6L
 NzEywqS95mPG74DRjapjTZBI98WaxNBsE90XQ68d1RSs0JRwZXGbH5xyoAscHeMLtSzONzsjZy9
 Y39IiHO2dStxgEgEHc/GJFQVgVqVmPIBMVVqhPv/5WMIvbEUI4vMEOg9P9ruDaRBkTQV+xfegfg
 FFKisl+KJQpLdOCaKv/v4eD138f1D1fOZe7XNHi8r18AjMJvWOYXB/IS86jxoBpdsAUgCg4nXyp
 N7ivyo9I1uTNpYxL9vlNM4UZF8ZSCwu0AHInMYlZvv2D0YDuquMPCW2wGwRlsCMtTYClN9ifpb8
 B8fkqJgbwLgbP8/rwbH+f+/tIRzls5njcsO2b9cyOZjKKWpVb6oYuLvQzgFX7puRmTNWZqPpmWK
 AMkYsGf4LjxpWcU9OCeIo1FqwY7sler8LQ5+IYEk=
X-Authority-Analysis: v=2.4 cv=S4HpBosP c=1 sm=1 tr=0 ts=6a9e974f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=UnEsLBAWqG5TZJypXWwA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX9HiOoNgd848k
 TUvetdRvif66LNkb7MwdEJbiTMfxQ+52OHrcz5ZtSZAoFsGiIyQfhsTBjvo8EuGcJQ1octQKeFr
 zfP5gxq/J+l+23MjHxqMUGNkq8S22VOL0gIwtYfyGffTRzjJXUEt

From: John Garry <john.garry@linux.dev>

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

A global list of sd_mpath_disks is kept for matching scsi_device's.

The multipath gendisk has the name and disk->major/minor set to minic a
scsi_disk.

The following is an example of relevant scsi_disk and block sysfs
directories:

$ ls -l /sys/block/ | grep sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc*
brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2

$ lsblk /dev/sdc
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc               8:32   0  600M  0 disk
|-sdc1            8:33   0    9M  0 part
`-sdc2            8:34   0  568M  0 part

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 426 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 406 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 60e071d23ddd0..27230ecc2337e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
 #ifdef CONFIG_SCSI_MULTIPATH
+static LIST_HEAD(sd_mpath_disks_list);
+static DEFINE_MUTEX(sd_mpath_disks_lock);
+
 struct sd_mpath_disk {
+	struct device			dev;
+	int				disk_index;
+	int				disk_count;
+	struct list_head		entry;
 	struct scsi_mpath_head		*scsi_mpath_head;
 };
 
 static void sd_mpath_disk_release(struct device *dev)
 {
+	struct sd_mpath_disk *sd_mpath_disk =
+		container_of(dev, struct sd_mpath_disk, dev);
+	struct scsi_mpath_head *scsi_mpath_head =
+		sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	mpath_put_disk(mpath_head);
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+	scsi_mpath_put_head(scsi_mpath_head);
+
+	kfree(sd_mpath_disk);
 }
 
 static const struct class sd_mpath_disk_class = {
@@ -817,7 +835,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	ida_free(&sd_index_ida, sdkp->index);
+	if (sdkp->index >= 0)
+		ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
@@ -4019,6 +4038,90 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
+	struct queue_limits lim;
+	unsigned int memflags;
+	int ret;
+
+	lim = queue_limits_start_update(disk->queue);
+	memflags = blk_mq_freeze_queue(disk->queue);
+
+	lim.logical_block_size = sdkp_lim->logical_block_size;
+	lim.physical_block_size = sdkp_lim->physical_block_size;
+	lim.io_min = sdkp_lim->io_min;
+	lim.io_opt = sdkp_lim->io_opt;
+
+	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
+					disk->disk_name);
+
+	/* TODO: setup integrity and zoned limits */
+	lim.max_write_streams = sdkp_lim->max_write_streams;
+	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
+	ret = queue_limits_commit_update(disk->queue, &lim);
+
+	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
+
+	mpath_revalidate_paths(mpath_head);
+
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	return ret;
+}
+
+static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	if (!get_device(&sd_mpath_disk->dev))
+		return -ENXIO;
+	return 0;
+}
+
+static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	put_device(&sd_mpath_disk->dev);
+}
+
+static struct sd_mpath_disk *sd_mpath_find_disk(
+			struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct sd_mpath_disk *sd_mpath_disk;
+	int ret;
+
+	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
+		ret = sd_mpath_get_disk(sd_mpath_disk);
+		if (ret)
+			continue;
+
+		if (sd_mpath_disk->scsi_mpath_head == scsi_mpath_head)
+			return sd_mpath_disk;
+
+		sd_mpath_put_disk(sd_mpath_disk);
+	}
+
+	return NULL;
+}
+
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	int ret;
+
+	ret = mpath_add_device(mpath_device, sdkp->disk,
+		dev_to_node(sdp->host->dma_dev), &sdp->host->mpath_nr_active);
+	if (ret)
+		return ret;
+	mpath_device_set_live(mpath_device);
+	return 0;
+}
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4048,13 +4151,260 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
 	.attrs		= sd_mpath_disk_attrs,
 };
 
-__maybe_unused
 static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
 	&sd_mpath_disk_attr_group,
 	&mpath_attr_group,
 	NULL
 };
 
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct device *dma_dev = sdp->host->dma_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	char disk_name[DISK_NAME_LEN - 2];
+	struct queue_limits lim;
+	struct gendisk *disk;
+	int error;
+
+	/*
+	 * sd_mpath_disks_list is kept locked if no disk found.
+	 * Otherwise an extra reference is taken.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (sd_mpath_disk) {
+		error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+		if (error < 0) {
+			/*
+			 * Should not happen as would fail for the same when
+			 * allocating the sd_mpath_disk
+			 */
+			sd_mpath_put_disk(sd_mpath_disk);
+			mutex_unlock(&sd_mpath_disks_lock);
+			return error;
+		}
+		sd_mpath_disk->disk_count++;
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		goto found;
+	}
+
+	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
+	if (!sd_mpath_disk) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+
+	error = mpath_alloc_head_disk(mpath_head, &lim,
+				dev_to_node(dma_dev));
+	if (error)
+		goto out_free_disk;
+	disk = mpath_head->disk;
+
+	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	if (error < 0) {
+		sdev_printk(KERN_WARNING, sdp, "sd_mpath_probe: memory exhausted.\n");
+		goto out_put_disk;
+	}
+	sd_mpath_disk->disk_index = error;
+	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
+				disk->disk_name, DISK_NAME_LEN);
+	if (error)
+		goto out_free_index;
+
+	error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+	if (error < 0)
+		goto out_free_index;
+
+	device_initialize(&sd_mpath_disk->dev);
+	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
+
+	/* undone in sd_mpath_disk_release() */
+	scsi_mpath_get_head(scsi_mpath_head);
+
+	error = dev_set_name(&sd_mpath_disk->dev, "scsi_mpath_disk%d",
+				scsi_mpath_head->index);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	error = device_add(&sd_mpath_disk->dev);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	mpath_head->parent = &sd_mpath_disk->dev;
+	mpath_head->drv_module = THIS_MODULE;
+	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
+
+	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
+	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
+	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
+				(sd_mpath_disk->disk_index & 0xfff00);
+	disk->minors = SD_MINORS;
+
+	sd_mpath_disk->disk_count = 1;
+	mutex_unlock(&sd_mpath_disks_lock);
+found:
+	sdkp->sd_mpath_disk = sd_mpath_disk;
+	sdkp->disk->flags |= GENHD_FL_HIDDEN;
+	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
+		disk_name, scsi_mpath_dev->index);
+
+	sdkp->index = -1;
+	return 0;
+
+out_free_index:
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+out_put_disk:
+	mpath_put_disk(mpath_head);
+out_free_disk:
+	kfree(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return error;
+}
+
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	bool remove = false;
+
+	mpath_synchronize(mpath_head);
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+
+	mpath_delete_device(mpath_device);
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_remove_sysfs_link(mpath_device);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct device *dev = &scsi_mpath_head->dev;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk) {
+		dev_warn(dev, "could not find mpath disk\n");
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	if (sd_mpath_disk->disk_count) {
+		dev_dbg(dev, "non-zero multipath disk count in removal\n");
+		sd_mpath_put_disk(sd_mpath_disk);
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	list_del_init(&sd_mpath_disk->entry);
+	mutex_unlock(&sd_mpath_disks_lock);
+
+	device_del(&sd_mpath_disk->dev);
+	mpath_remove_disk(mpath_head);
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+/*
+ * Always calls for a failed probe, so we need to handle that some structures
+ * have not been setup.
+ */
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_head *scsi_mpath_head;
+	struct mpath_head *mpath_head;
+	bool remove = false;
+
+	if (!sd_mpath_disk)
+		return;
+
+	scsi_mpath_dev = sdp->scsi_mpath_dev;
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	mpath_head = &scsi_mpath_head->mpath_head;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	return;
+}
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+
+}
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+#endif
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -4078,7 +4428,7 @@ static int sd_probe(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	int index;
+	int index = -1;
 	int error;
 
 	scsi_autopm_get_device(sdp);
@@ -4107,22 +4457,33 @@ static int sd_probe(struct scsi_device *sdp)
 					 &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
+	sdkp->disk = gd;
+	sdkp->device = sdp;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
-		goto out_put;
-	}
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_probe(sdkp);
+		if (error)
+			goto out_put;
+	} else {
+		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+		if (index < 0) {
+			sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+			goto out_put;
+		}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
-		goto out_free_index;
+		error = sd_format_disk_name("sd", index, gd->disk_name,
+					DISK_NAME_LEN);
+		if (error) {
+			sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
+			goto out_free_index;
+		}
+		sdkp->index = index;
+
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
 
-	sdkp->device = sdp;
-	sdkp->disk = gd;
-	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
@@ -4142,6 +4503,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		put_device(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
@@ -4149,10 +4511,6 @@ static int sd_probe(struct scsi_device *sdp)
 
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-
 	gd->fops = &sd_fops;
 	gd->private_data = sdkp;
 
@@ -4171,6 +4529,7 @@ static int sd_probe(struct scsi_device *sdp)
 	sd_revalidate_disk(gd);
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
+			sd_mpath_fail_probe(sdkp);
 			error = -ENOMEM;
 			device_unregister(&sdkp->disk_dev);
 			put_disk(gd);
@@ -4178,6 +4537,12 @@ static int sd_probe(struct scsi_device *sdp)
 		}
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_revalidate_head(sdkp);
+		if (error)
+			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
+	}
+
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
@@ -4192,6 +4557,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		if (sdp->sector_size > PAGE_SIZE)
@@ -4199,6 +4565,19 @@ static int sd_probe(struct scsi_device *sdp)
 		goto out;
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_add_disk(sdkp);
+		if (error) {
+			sd_mpath_fail_probe(sdkp);
+			device_del(&sdkp->disk_dev);
+			del_gendisk(sdkp->disk);
+
+			put_disk(sdkp->disk);
+			if (sdp->sector_size > PAGE_SIZE)
+				sd_large_pool_destroy();
+			goto out;
+		}
+	}
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
@@ -4212,7 +4591,8 @@ static int sd_probe(struct scsi_device *sdp)
 	return 0;
 
  out_free_index:
-	ida_free(&sd_index_ida, index);
+	if (index >= 0)
+		ida_free(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -4340,6 +4720,9 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_remove(sdkp);
+
 	scsi_autopm_get_device(sdkp->device);
 
 	device_del(&sdkp->disk_dev);
@@ -4508,6 +4891,9 @@ static struct scsi_driver sd_template = {
 	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
+#ifdef CONFIG_SCSI_MULTIPATH
+	.mpath_remove_head	= sd_mpath_remove_head,
+#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
-- 
2.43.7

