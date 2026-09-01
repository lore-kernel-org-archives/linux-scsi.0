Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7EC47CA8A;
	Tue,  1 Sep 2026 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259649; cv=fail; b=jywlR39NRC6uN+1HsUIeYPjbEAGZBgvWz6yLzOuUEshGRr64DsjtQ6x1rNp1g4WP8Ibp0/Ws2p+bxmIBFRaEkmSS7qQRVWoT7/5zNQAqxV+6VEf7SAihd9TwM2eO7RShzU54X896vLL29kMmdgqNhVT/eEoepnSx9DnRUqeyegs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259649; c=relaxed/simple;
	bh=WU0EdO55SYm/nbtdmFlnUJLaUl0LHFsoVGWObJCl5nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OVBaNv+Dt7XwyxaQxOtRyx3SU53yOt31K/ZkNnl1TsKlBFVeHaIUsC27w1JaMQslrIslRkfcvGAb/HXxX/HFM9QIbisc52o9JDjks2VoISkvC/9MfQUxC+ByOPiNfIskm0ryfjF3vU+aVzOrgQziibNiG5k5y7rR0mY0OZzd4qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eDFBoUQO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zOpekeM5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eDFBoUQO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zOpekeM5"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBqIi2846757;
	Tue, 1 Sep 2026 10:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=azn+b9aBXAX8T49esRi6V/bVlyG/wP5b9312KuBJErQ=; b=
	eDFBoUQOoAqO/D5vUyxQS6ilgnlv2EmTfhLpAGUBJhhTMu3TcPi/D15ezl1arCJZ
	hXFQakt4epRoQBwq/8hpW1Dv7O/vFdQU0ufW7zEJeTMK4kMx7GZ1OBqMUvr5zgaz
	y/l8SXpVcSiqSvLQvdHpWEv/eZ4e4sJlKSU0i76BMJhQOylr3y2hcNQOGcmrWIuN
	8LUVNjpkiySt/K5zfGpv4dXdu52eT6z1LQnZavCZngZsM8ehJ7DhuG7E6wxLQEhA
	wyGMo6APFmlYuvbX/d/R7bdF3h66V4lSIbBtk6RoarWF91kJVEAaPCfSu+ucO49O
	yDhLfVd7v0UEZuN9Fv8mmA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbaveh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjYA6036488;
	Tue, 1 Sep 2026 10:46:00 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqfk4k-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+ypCNAGCLFrjKcUd+frgyTuiSEFRbukhWgmco4IlE3NAmjZKYLoSf/6SAW2Aj6u7fnQGC8hulbS+iusLacdtLya/1AhgffnqPfd8l3huPvFJ36JUnRfyr09AIij3jJbjyX1jdlfVv4YKjnfsdiwbzxaKbNqWm8O40UvexpX/F2u/xh9dOvX/+kMmHevLI35R/ep/RdeCJmUPkFTox45S55zq+oC357r6Jnxxb0CRa1ZXBuIZPAcnnVcG2J4B32J67XYOTkH4dZ3fCDJuGQabB6nlUH2ahKfR6rHa/GVk6L+8nxDxhsC4BWznhyfkTLwZQxdyxIo62ytDieUnSr6tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azn+b9aBXAX8T49esRi6V/bVlyG/wP5b9312KuBJErQ=;
 b=cqqe2ezUgWV9R+KMdnvEeROOfLTOfAgxEesN8oBRrl3t9s8EQG0xIut/sLPQuXfmIQ4e9gQZ+fYWDk9u5EPpepK5JnQLIvTMAVLeqw9J+YK5jgVsJCfRJRMjKrBAV8BjS9IE0DlHZSsvEqsk5tRHv6/72/THglhAv6SnW1g7VKZlwwiGRZQWsBgPlCDfDzrd4LFR0T5jRe8H3p39zZkYUof88V6ZL706PaOQRV/hEzhvv/WkjQgoTDiPbVuJPoluJt9Z8/FesX7jJKcCj+F+oC/eqglXT5Wi2p8JDAaof0VzvvGXMuWVFdQgKgCJNgeV+sawxxGDBWrTLG9C41F/CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azn+b9aBXAX8T49esRi6V/bVlyG/wP5b9312KuBJErQ=;
 b=zOpekeM54W1BUFbmZc7HHo8dbF/y83bWeb74eb4tYJGKeD75isc/89BUPjxCmyNCvbeNIVXA2Somhhy+FIm8ZdW/hSfFGZGHur3HVxaOf45+LpypKqqTf5sL1n9rTg60XdhLeTZZIvbgdgzNuv8frP7ISAHAcZMIUq9xum4kkLY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:55 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 11/27] scsi-multipath: introduce basic SCSI device support
Date: Tue,  1 Sep 2026 10:45:10 +0000
Message-ID: <20260901104526.3850621-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0023.namprd19.prod.outlook.com
 (2603:10b6:610:4d::33) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fa0bda4-064d-4285-3103-08df081632ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pCpy3oHCicoc8GTX+8woQwlp9aOlKpbi3Hm81AcmAxL9kZTxTZMeyLbOwEwpA1IpgAL8RUq+7A8yRa794sAqZPoUDQeMFOL/dtACiHfjQaJ7kratOctlu03b8BpXtT2UMXMfoRfAV4UzicSWlO6XMMq295brYajunsrW9Iz0cTb7E1wu5wnjTtU+XrE2BpA85wBxFSMh9wSfPNs9NULCUm9SrfnbrM80f4+SktT3C+/EFRtJJBEx9w5viJ5pTmwepf778p5V6CYxK7gZElIfl7h27LJjvukDPbOHzcy0BLRSz+u8iQ/vPrt3TC/D7ZJfQKpmJlSCsK/JEPBRFkVjAKSxofkou05RRG0kikVn5Va1VKNt2Pbk9NVSTBStfhnqCtShPA2V4FymHaPg+oaVgPYOoalESzyPA3h4SkgGQjhOq2sDJQG7hPXh6u7jdBVNJX2kj097LREBj90+NdKCBAACmcg22nrM5K4T7LQTFEdu6h4LAU9Nr759XIc22+z635rRX4yq0jxscl6JlG7on8TdhFbNmuK+UE8C8uFINf8a9AEQ8GE7ccc/3U9DMD6O6SNIivvvYqvR+d8HbKcaqEgDm+INFj5rR6wrv+ygjgVdI2eJX3QyIV4uAcKrVdTmTilbpqcsA0AxsLyenEBKljg7EN+mUrCaRr9QH9rYS+0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dI01mKI0TyMs84bPUg0iPjGdroW5477D99WGe6Te6JGs9+nC4W+p9fed851Q?=
 =?us-ascii?Q?xdFA6flF1I+jw2WUGdj5UD9GY8f+/ksOtwzuMlFqumDVis7yGSxGitNKg5pJ?=
 =?us-ascii?Q?DbKgTfRexWDuywG5E1GxNkhslm4x2PjdZEAE9BzJk5DctsnYeVqgrZJKTMs1?=
 =?us-ascii?Q?rfXIv6nXlpJ4sTaLY27KGMZ303/Xz3B7pfYXv5+MhJc98mo+1Y01uzwjnlN8?=
 =?us-ascii?Q?34iiptd/XVc1RxLFS27SCOcMiQSkedqh3J3/7mG9ZIjvbl6GZ1azC0/lhUFw?=
 =?us-ascii?Q?PuYIvyTmA6Tonu2etvAsbjLskbuM881ZI1OGIkkjQmCHBNdqwOJEgyQdwiiM?=
 =?us-ascii?Q?51ZoQfADh5Im8xAfq7lQQgyw7nzICXhrJcYa2NrZqodwae0Ymw3Tx2rlTu1v?=
 =?us-ascii?Q?vPCGUq77XTK0GfLfVNBVS2VCiT1XgU+BJ0mR17lfMYe6GsnqiiQgegsrlX+e?=
 =?us-ascii?Q?Q1+cOZNbfC/xYzYseOq3lxLdSmr0kVHwMUXLjsqYr+CTpb6oeQ5iztpWxaGZ?=
 =?us-ascii?Q?c8EEQdEZT13KtpbXkJc8JC+Cupj6UoIoaC7KrgBs4MWTEN1UO7LShZa2Ozf8?=
 =?us-ascii?Q?OgdCaABkLacgVmXeM2M1uu1kj+pV8iu/1lQFPtLp8eQNmdnCrX3/YoawVOLf?=
 =?us-ascii?Q?5ba685oh2+uzBAHpoCAuLPbdeiu7tFEc1xYJbI6u46LhcWwVGgBfYMVUyiPP?=
 =?us-ascii?Q?H/ogveKT/TYX55sGPs9Qfjko7d6e+qV49cQL9JIBRgIRedyDs54pfuEziawO?=
 =?us-ascii?Q?ZWEAYVEorXiO83rBBA69Xrmb8JaWxnouaLi2cCO85BST629C7q8DlGeKdOPw?=
 =?us-ascii?Q?c8V2KOxyaGNnfq0CjsVraaWrXcB3SNcVsroNAwYXkxHVnMC+9qNhs4iEbqYu?=
 =?us-ascii?Q?QpJVl9cUxpKYlnkr27tJ+nXp0uZAX2cIckYp96lJdqK49oDAZ9VtoHPa/+AD?=
 =?us-ascii?Q?zQMULy6xIDohJPl7cN60t+Ds+FN3p8cJrOFVPFsmxpIkg0cJYAv6g0LlqvBl?=
 =?us-ascii?Q?PjLDjG6ThvLYPGLc1RvVAUM9poncKPSsWv78Ge6u12UVBfk2bfG7K31pHVcE?=
 =?us-ascii?Q?7wS5116I4Wcmt55iJogue5ppomu0qP1GrE6q9H9JMIDUthWL9Kmx0mxLfRmC?=
 =?us-ascii?Q?hCQc8rqJ83RfnKCWInRcfj1uyJbgKHzM7t/sG3Pb2NDQqXu+tIZAZWFe3YAp?=
 =?us-ascii?Q?VECPZ05VioM/SbhlVo/iP7UQmoE4fI/pSXz/g8ebjMSKUTKdnXza3pyE5rPN?=
 =?us-ascii?Q?mKFVV7Bdx/TSQhwCsDiaLUSExgmLS6vQFfD4h9DFs7qQ9kXyvsmPbvGhQnVS?=
 =?us-ascii?Q?vaZ8HvQipHtOkX2d5UQ8arrzfyM7+RPBhlHGBTcfFDPn/GCiaKzKi3XkKpUW?=
 =?us-ascii?Q?EdGo7oNNvQJG0TLyXVcwAUijYqG7mhQw9pXIIKtCrQbxLJZEXUnmvLercbIm?=
 =?us-ascii?Q?vuDO/FGvlxFkYUQ7S1F/Fsn/i74yIIT3oQGpdJtpXyvFxaMeFZMjdAa/92nU?=
 =?us-ascii?Q?Y8KGkwM/aY+9y6+WWzs2uct2F7hR+MFNbW8bHjB1pvXxAxZJsh1jp8MEAeQd?=
 =?us-ascii?Q?XWAR3jmJSfmt/0TcIIEbiyLqdtt9EB5HKceZDCDRgRfQzx5KqCFhEbtRnJOa?=
 =?us-ascii?Q?C/Ru3R5B3A9RxVwh2OYhug2y3mWZLDNf04teB2PpjZDfzZXcwgfNBNcWYHvV?=
 =?us-ascii?Q?NijxLrcyO8riGwzbUxXldzAbcAlFZTC94MqAzbnkAmF1GqYjlxXNkCQYGuN5?=
 =?us-ascii?Q?gEWl7Skvsg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	tWBxwuPongvsa9TuPwNj/GjyFQpuPWEyHbtKe+Xu4j7pVWAUW7PzCFDjOyHr1IzkP0CqXJB93i9k7aMH3j1X/PPwei4hpOcKqKdL7TkUngi/CmPeNEua/0DCt8eSmlL9wR8zbexICl/zFZAXbP0a8DHEsXeJuUqqPYI2is+SAD4LwqzGwzacLkcRtdVedTY3BgATx1m2kOdh1TaCtlL/sBa02CWrlX90o2wEpSLVUmFPxxqdeKeQwfp9ugdXiW9uDq3DInIRYmh8fE5QNza+i+gfKwbK39nq2Cug1j+U0xNY6FVImXcGhsKfFcouoyneKYWU2ECN381qIXjxD70wDA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lO3SuWl9bPUYXHh7el5pFZ/QcjUgJIpZk07RQZFHOggkjSOsrdDc/49W9u3iq6yYgRx58WPXDY+LAP6z9Pym3e+3MW2gl0Oe7yI9aPBeySR94ML6eXJYijfQJKJGc3Udq53HizTnKWZvojC4pRqutF4UDC+hnaHTNBIrOhZ/xGL4vS70o2uKo+fbrfVLC+uYmD88Fazw9xpqUEzmAb1FPLXSDfj0oFQdIN/eBixBMEcB+QbKB3rTChgGNOQ2xF9pS1EzP5yDl32dBDCU/1E5q28E4Pbay3rYup1iahVl3ASRt94K49yTPiUrhKEePhTKh8+8okvPmU3tes3sTubqauzoI0gKv8PvAQrLzvSomD/F8qT8lqcZYIDeY2VrM4pKeZk7E2w3yYZZI3hqyA1Bvw5Z/wLDMxSE8ocD328VB0PpQYucVQke0+xaoOxQT7stINk3PCGlpM2+4lqLwBs9iHqBhgvUJhvO2PmeIFAgHq+V19BrS+MojlPtuWfuvvAiqAueyERqHr/LAsHZSIhnSdoTi0crvL4r5tgabDckooIb61oAbYo43Zfz3+gAGWnfLl4/vi/aLPZGwbj2jU1rmX6DzSb5brLqGZvl2DhkBVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa0bda4-064d-4285-3103-08df081632ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:54.3884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jVLxShbZADZIANZdynyiVzMr6VULbhvhtsbZTyKmGtk42HKqXzLmLWhcC4jO3GARH6+DmLsQpyFxzGKLux29ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX5j+SSd4Xls/F
 4kY9ldtvWOLHQP9+tAqmDrT7IJb2Kwb8MKWjyA9WhutwVezupnKkvDWhvBw5FIVHTz/of9EBgld
 axTvL3vCc2iWhmGsg/cLeCoLhK6LTpk0xJW94BkoCUiUaUtoQSyg
X-Proofpoint-ORIG-GUID: w4AtMmC-gbNQEDg17BajHe5Z9BI2-i0y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXz8iqRlZ2He3u
 1W/Mql43FrwHmEgglrjGPOhBKoznOFpNiEcKUM5YD72JxdTdTbzvCuATIPJ+NBGDnF3vEwKseHP
 AeMG9xVfWWXWoyyVVoFcU33Eza74Ys2lbFXaZ9qz3vNi2kM3Y1Vy5f70WMAPc51PnvhakR6ZBVa
 ijJOOiZlPXHG9vwT8b8y7zpQ2gEYKtcv8tDlbqZoJo2pzxU4NHXbOnvw+OExJ3J2ONlaLJLAyAu
 omhG499NhctdpT1JXlxYbSUI6hPynvvKhg2jVkERBDi+mSmEVIFKIYtR2dLYqHx9xGm9FTTskAs
 t0bEKjqwqFmg0lKdvfoiR9f1NtlAt6RsEatNj1Nd/8nfpcHGewRzS0jtr1tgLGXM7yyBxH4RpzT
 JWywdgJhLZebMEXxSrgNa2MwwhqlZzFjOhpBBvYTDXojjg3asIuyfgzb0Es+2AG90A2uJgsu7UJ
 RKGa0ZDdEXrjDFQflBDIlvBCoBndgs4OiuU+yfh4=
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a96ace9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=pCOl5fTshOrEa-n2-VQA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: w4AtMmC-gbNQEDg17BajHe5Z9BI2-i0y

From: John Garry <john.garry@linux.dev>

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like NS structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

A module param are introduced to enable multipath - the following modes
are available:
- on
- off
- always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and implicit ALUA supported and unique ID
  available in VPD page 83.
- scsi_multipath always mode and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device; having
this pointer set or unset indicates whether multipath is enabled or
disabled for the scsi_device.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 148 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 +++++++++++++
 8 files changed, 229 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4a2af0f702e1b..ffb7d12664b09 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support (EXPERIMENTAL)"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 533623382eca4..8bf4e548b395e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -192,6 +192,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..70aa1dbeacebf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1042,12 +1043,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1071,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 0000000000000..5559e2e8d64a8
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+#define TPGS_MODE_IMPLICIT		0x1
+
+enum {
+	SCSI_MULTIPATH_OFF,
+	SCSI_MULTIPATH_ON,
+	SCSI_MULTIPATH_ALWAYS,
+};
+
+static const char *scsi_multipath_modes[] = {
+	[SCSI_MULTIPATH_OFF]	= "off",
+	[SCSI_MULTIPATH_ON]	= "on",
+	[SCSI_MULTIPATH_ALWAYS]	= "always",
+};
+
+static int scsi_multipath = SCSI_MULTIPATH_OFF;
+
+static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	int mode;
+
+	if (!val)
+		return -EINVAL;
+	mode = __sysfs_match_string(scsi_multipath_modes,
+		ARRAY_SIZE(scsi_multipath_modes), val);
+
+	if (mode < 0)
+		return mode;
+	scsi_multipath = mode;
+	return 0;
+}
+
+static int scsi_multipath_param_get(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_multipath_modes[scsi_multipath]);
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = scsi_multipath_param_set,
+	.get = scsi_multipath_param_get,
+};
+
+module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+	else if (ret == 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+	mpath_device->access_state = MPATH_STATE_OPTIMIZED;
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (scsi_multipath == SCSI_MULTIPATH_OFF)
+		return 0;
+
+	if (!(scsi_device_tpgs(sdev) & TPGS_MODE_IMPLICIT) &&
+	    (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0)
+		goto out_uninit;
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return 0;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3b82e80e807a7..022932af79c65 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1130,6 +1131,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9480432f650b7..d6a0c43a048a0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -456,6 +457,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8694eeadd753e..1d1356a21c3a5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -280,6 +280,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 0000000000000..d3d410dafd17a
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 256
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

