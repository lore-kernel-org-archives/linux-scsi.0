Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020139.outbound.protection.outlook.com [52.101.196.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5623C9435;
	Wed,  1 Apr 2026 22:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082330; cv=fail; b=jksExyGcGkVwstKY2TnQKawqyXPB1dvKbwykVhgrMh1NqozyHrnM/JMPmuKvZNCrZRtak4kmOz06j1Mvthy4OFG8SnRXVVG8CgpS2FzZkfWkFMMnXLWGtzPqGPeoA8Yf6YfTmS+PIJJIl8XaURLRQBoE4UZ1K49Va9CZ0WoHQqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082330; c=relaxed/simple;
	bh=wDtDRyjeNaHXbGCX92ZWQJ+Rb/gd257YCL1q4GtUeV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mdBkpsVK2drjCoJI9jugz/dZwGsMA0N+g4C+qNjbOw0y7svflQwyuBIhtWsz19f/D7L+G4s0zEQCFbSEfJwHackLWxdMcBB3PzfTigGFKzjBuX0ZT0P561XRv9aiwAbDJwGBk1/ZlevjdW+rfPQhvAoiiiMpP4VjcarLIPe1TFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nbf1mEZZuwLFMk+lRg5RUe+E6jVKTw2PtD4YK2H9zyedeOtZrr4k8vj+QxT9LsrcDNkTovu7CisLMtJBRHCAKUo0AHiRxA0QmW8+dHp8ge1aMb3Mll1IuePCeel8XkgtFXBLpv2EUkto+wUZAL1D6aICun/B5oZeUVYXpZLuJj5RjKFV4EoF7pAowmgzv0An1D2Q+w8CyT10yenyjCqI8O5xoHGwhzsmbaoYXG7ZIVbnybB0mMSUdjQguz4lDsDhfaefk5+VOSrSH1tGIo+9fUKNZSqASBWC5XUPcy98cd1n1UWxn71rSVeJogmbDRHFN6XOFbL7Qaewf/4JIjIEzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aEwx902v5JeurIZlSuzQ/7lqtqFXTr2EuUQS2/yQnU4=;
 b=zM2jXHY8hmdE/8K1trROoVms3S9AGM5XV2fxMiedWlwGk75o2MfWUZryEccNHvsQ3pdTuvZ7Gt6LYSz5NkIaq8JQPyTiNuGLkdLJ9nfSFkxjBtiF9OEyODj9xBAii0PkqUSWdHY7jsSJtsDt5Bf4kK8YnK5oz6EvUCoNFQ79QNL2TtUjr/1ivFZoho5XG4VNaZLOJVgQkcDw1/mggnzuFr0On7dCXg1+azamUJ3G+/geqtGM8RbgG5vlcQmYUpWgED/X2H3OaWkSn05y3L72W2ChQc2pu6Tz4cIArqi6hylLnTcJkpceIwQb4YUn5qI8UxOymWI+qIIMCfMZ/vqCwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB2964.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.24; Wed, 1 Apr
 2026 22:24:02 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:24:02 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	mst@redhat.com
Cc: atomlin@atomlin.com,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	liyihang9@h-partners.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	jinpu.wang@cloud.ionos.com,
	tglx@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	maz@kernel.org,
	ruanjinjie@huawei.com,
	bigeasy@linutronix.de,
	yphbchou0911@gmail.com,
	wagi@kernel.org,
	frederic@kernel.org,
	longman@redhat.com,
	chenridong@huawei.com,
	hare@suse.de,
	kch@nvidia.com,
	ming.lei@redhat.com,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Date: Wed,  1 Apr 2026 18:23:12 -0400
Message-ID: <20260401222312.772334-14-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:408:e2::7) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB2964:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd0a896-4240-4e0b-6ded-08de903d6062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TfFTwgjKmCqtUEBrJ/UKDlracZLu7lxFeUZpfK2wV3TcVsUHUHtwejxjZyzptPlWLOm6SZkYbnNpkXGEj1E74btyMetYhN+A2Z1wPj/S+YtSGiD6/N/VvjuxWK/1RbUAuI2jKofxuiudf/32Hw0EZCMhBQQw77U8oEd9EZyg65Z4G3pq4SBCroWlzptzm45VC5YHObbh0qOqoPweUZBBYSmLmM/1ybpSjoiqhrspgM70zUpLMvNkWLQI//hCqhLwtKKKA7SUgN6hrckUq0Yd6GwwRgcFXiNjR5G9S6OidMsgkD2gVegp6BgmY7kWc/SYYB3xjV/qivXSqY4Zkiqt1E0P0mdXxsB80kVjWwDBzex/UgCXwzp4dERKMDNQWgCN9uDdQQYaHNVXD4g9Oz70nLEjt4sNzbiez/ERcrF47IZ+1/6BBX1ISDxmxK2vkmT3ZQ2oEgtC5Oe3czHqn8+7lFhGYm8WAvgE0uKI6eSyOQz3DWDh/2s1dMoH1D+QZnFnau6WTiz5+tYl4Iy5IaZZE3+HK5AOv+6lO2pVG0qAXS+pcbI27MV9RvAWJ+5AvMlCMRQsIqJ/a9j/m6veNmpyjlKAh/APmGgAMO+s6Ys6L/cOZDSDcs5Ba9ZElhzE2NFaAWIsykTRZWqKkvEuEcCtp3ES3DzQotCzRW7/EHSv2AKAmhWOfnzCgorSStVaGvWJa/e1rt8rBZQNRa7hU6Jbb/iEM3z5RkkGq0tn19/2+H4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/Hf87wYpJweo1GJzR4sinXCvBSXyatpjMvkdLcbecsGC5+eC+FyvTTDAAdkv?=
 =?us-ascii?Q?PO8c9y2A29nT0o2pCqI2+NeEgOE2pdtaL4xX7cW5mydmDRjbGEiQYKMqjjuy?=
 =?us-ascii?Q?wnD2WYejM+C/8aqFQdmPJpT8pWeGkzMnr+2STshLAgYGF3ieoxInUVU4J1/A?=
 =?us-ascii?Q?Wii7fu1JcFBGufqyCAET5JMR2W0xTQWBG+XtAa0ksYHfH0BjvEdL/XSbYKzE?=
 =?us-ascii?Q?4ucTzcOOO4D4ZzzjX1hVBMRR4aRmKIWvbE03CM55vYrFE9ekgcGtK/rFVxbF?=
 =?us-ascii?Q?6WtoVhQFn95UCbtEpYaxEtwVLH6H4OMUTHgD8MrsUR6hdD2lYJ/NpmKv3XAS?=
 =?us-ascii?Q?WyhAKyUdrz3POfL4UYBYrURhll/ywBqTk08lyf2dbxV+UT+A+QZWMiQgq16N?=
 =?us-ascii?Q?igUEeYoXrZllcH3nmfEGFd4hIpCIn6oVCC3E9u0Pb36mErJpFadAtLx/naIf?=
 =?us-ascii?Q?56d0HgPpTvntqbK/fNIOj4BLlTdhFPqjCXwrJJ1EH4dTNg20pZYTcOPg5T5T?=
 =?us-ascii?Q?r+z0NF7KVc08BFxV+GsM3JlLY2i57RCTq+Xhs4tb2aK3q5qrgV+8VQFh0VTp?=
 =?us-ascii?Q?JAlzj7Rgydq09boJYDxgB9Q4UWmODGkrK6AKNey1GDR/acgfRF3Z3bbjMTy4?=
 =?us-ascii?Q?jp0dHxbyuGMCJYi4IB+LHY43tfgyUWL2nkEvOcF/cgIW10AwFpZtcZCxk1Nu?=
 =?us-ascii?Q?OG+Zy0I0oCnuHzqW4vh6ZOyVc9urPfpsk949L7TGtCEX2dKQvxJPBKDCvYZ2?=
 =?us-ascii?Q?+DhpyUg6AhFMxgNegdR2igMeUTkzFoEVhwhPOtjveUxDg8wIo9OAokAvBtZF?=
 =?us-ascii?Q?etq6YaqN8JGJsiGoI/NBatqFdnOTDSA2CLyc7WWepUzmwRXXAf3Dvcp0q35a?=
 =?us-ascii?Q?p8Nyxsgn4whBlKVdChS6ctK1aw/w8kYCwC78kCuIdDiq6jekSxiN9L/A3Olb?=
 =?us-ascii?Q?7bvL0eLVfFip0XCu/gDu8JK25XDdXdsSjoJ2ZrtHoXWNAYLTtxLVxzstC2zj?=
 =?us-ascii?Q?dIvYPCaAtR41cw7DNNPufv/FzpD23HbfMFtJhRv/ump2jwirvFMUcQEd9ORd?=
 =?us-ascii?Q?hGnF6sFyzjqz8kywczSk39H/lrmgRRZQx64R7uE7D2Ox0k2y7mPumU/0k+LI?=
 =?us-ascii?Q?bp+OXaUeSfcsbR3sjhWtfeY3hM2zqgs0umIqNCkEsKTTHNZWkRHHtePJ8BsG?=
 =?us-ascii?Q?YOQEN0DWk3yl5PUHA1gtI8pjQKSfhF1kehUAXsD1Xb3hcUH5AtL3fVpwrT3d?=
 =?us-ascii?Q?4Von8w4JNxuJ3BvKly0TAEowaxoDu0lkIKaRPfibJsAWWXDmsZtx39GSqPCR?=
 =?us-ascii?Q?MgnBY2QMMQybsNIXwl21KBVAmzxsqff4u8bH2FRaFto3bphQy/GvRgsr2+vK?=
 =?us-ascii?Q?WHYxze6AvUAOLar+0A5bYWqOIbJ0tlUFrNZzx0lM8L9R/PTsi6gF5tyThigW?=
 =?us-ascii?Q?jJUeh4U/FazCZIx0xTRFKTv7jmCbstCLPCnsR30/+5ahuTzkfzMFvhURGOEF?=
 =?us-ascii?Q?E+NvYrDtHMNaxJlkJcvZl2Z+MCnTq/7BHhOQP6y9SQwifyFOAB74hNmKNyXc?=
 =?us-ascii?Q?ZK7+dayoQbXxS4vw09toYM2p78mUai7y4C5dkLaaK1oP2m7kKInNu8KTNEnl?=
 =?us-ascii?Q?Nv8qN/FcBIeA168RPi9dFKU1nOBhjXjYhz5LlAzoEc+U6RuajBnRhgs0Jsn5?=
 =?us-ascii?Q?1uNRjAWvx5ijzSp7HZzrWKsz1fyTSkt89wp0Gz9ilv72LH4lLZr0fiafPZAA?=
 =?us-ascii?Q?1VRuYjpZ/w=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd0a896-4240-4e0b-6ded-08de903d6062
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:24:01.9191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /AtW9gdRs80E/WQ6Nzt3ZR8mbbC0g3pC4vGKJI2T4RBmi4x0Qi30zg3UrNb4+7vcmzzs4SfLqec8k2T+Vh36+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB2964

From: Daniel Wagner <wagi@kernel.org>

The io_queue flag informs multiqueue device drivers where to place
hardware queues. Document this new flag in the isolcpus
command-line argument description.

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 .../admin-guide/kernel-parameters.txt         | 22 ++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 03a550630644..9ed7c3ecd158 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2816,7 +2816,6 @@ Kernel parameters
 			  "number of CPUs in system - 1".
 
 			managed_irq
-
 			  Isolate from being targeted by managed interrupts
 			  which have an interrupt mask containing isolated
 			  CPUs. The affinity of managed interrupts is
@@ -2839,6 +2838,27 @@ Kernel parameters
 			  housekeeping CPUs has no influence on those
 			  queues.
 
+			io_queue
+			  Isolate from I/O queue work caused by multiqueue
+			  device drivers. Restrict the placement of
+			  queues to housekeeping CPUs only, ensuring that
+			  all I/O work is processed by a housekeeping CPU.
+
+			  The io_queue configuration takes precedence
+			  over managed_irq. When io_queue is used,
+			  managed_irq placement constrains have no
+			  effect.
+
+			  Note: Offlining housekeeping CPUS which serve
+			  isolated CPUs will be rejected. Isolated CPUs
+			  need to be offlined before offlining the
+			  housekeeping CPUs.
+
+			  Note: When an isolated CPU issues an I/O request,
+			  it is forwarded to a housekeeping CPU. This will
+			  trigger a software interrupt on the completion
+			  path.
+
 			The format of <cpu-list> is described above.
 
 	iucv=		[HW,NET]
-- 
2.51.0

