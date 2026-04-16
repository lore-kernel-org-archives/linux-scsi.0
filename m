Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020117.outbound.protection.outlook.com [52.101.195.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2AA314A8E;
	Thu, 16 Apr 2026 19:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367844; cv=fail; b=n0gByIKI1dmUSXsQEDlAzTNpVsT3BvXtRpH7gbwMpMcDr5VgOkEvXZ5NuohcfAhYMhX8Vu7dq4sz3cHLjbivZteWeg8kQ88Z9JxrjSbzW0yuQFLc5gRrlQhxamiIEERGAiBFOVflMo3v09RHsEhaiWfJNTo+dWQvOS9kaK4fTLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367844; c=relaxed/simple;
	bh=znT5axORIX+a3dCgnfuvHErFeaUab8g+ZFOsQ7bua9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PmGx/u4632Y/fZgtL9b64YfW+ev3T0C6NWQIEEDO0L28km/owV+inLCJCGZlhURAN+lvpUOeLJqzZ7ryDswOS6WOj8uV7IiDY6J4WD5phnUCAdWz76p/XappwnfK3IHKKpJ/VMXJSIAVAh7oruLzxv1I3R+rXAiv/DNovWL+ZC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ck7iP1XpYLt3a5GH7Oc4Ru5YMe10UlaOciW5SpWKNyTTdacaBMq7/KaAisbdlsnDbxa+NHzVbHHOfpDH7NJUqgxfbXtIX1PegQHrJ3zKDLQY4DTEYHU9R2PtKmWeLNYlD+8X8RjShfIwSw7vbKoPDMr8Z3VLr6+8qyU1g7RE+I4kZSpcEuTRalOvOA1eY5YhcBkodmnjL8CLQAuzCbJPeeGvH4hJOH6SEDnhQxHjG8hDH0yMqVjhWGqSajbu02FE/JpcMPXhKW362Vo509R4F/tn4yIoMff5f94lFtbZrRJktVheohC7flPRXSuh96HxnARvkPTckxvjKpyng3jpyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VvAX3Ic7bg6OMX7nB9btcp7TrNmWcMokA7godWoPqY=;
 b=Laj7hBp0AvP+shGB//vQMke7wqND14kT9oiCufDn8HCShbeQzJvDT2vM0zX5obXBRNaL05YmzAI1n6ZlTYmW9whekDUKraY0mqulexbX7K7to8ZLYc4kLBtHxbDQYaGvpbe4cf0fhL/Axhl8sHw3bkAIIuf2hoV2vHUzugqZCy/xahC/NB0RaHPSMvxcxVVayQ0LSkYDnLohgtUL4dmAKbK8AsHcEAcDx5CPPvCvLMro+Pj5g2rI31t6wDYdFbSJxvRDAYx368HZA1LBLGxJoUEx+LQE7m9S2J63Iv46R1n4Ixw1wsAevC3xQuijb6BMv3OcW4b0803bRm+gMspUOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:39 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:39 +0000
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
	tom.leiming@gmail.com,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v11 13/13] docs: add io_queue flag to isolcpus
Date: Thu, 16 Apr 2026 15:29:42 -0400
Message-ID: <20260416192942.1243421-14-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0039.namprd15.prod.outlook.com
 (2603:10b6:208:237::8) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 38982782-3011-47ac-5979-08de9beea27e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7PEhCBN5QTHag7ZxzKRBFoqA+OpcJwOd0wnNyZ27dvRMVJJfQuRvQUB4QMypUkCnLcSgRkMaF9JotPxtaYQxgiSShQjPqPE6jXeuoCi6W8Vx3t9fWhUgSTeTzLBQdEoPnNecPjEFGUWLo6Z/RORulNTf4fy7t22DfksF5dJOrQiea5gulEtYTmSGK7ebX6lqrPizpNcs6qo+fl8V9OwWZYXUtefEMscKQ4QGeoUu0EssACYSmGAXGrAdBr7xjM4fDi181ftIQWmd+o+MswHpUBdzuCle+1esipRfm4D5K3gvfMguEdKXVJz5rDnz30IoPqr4bN11qlirRk/hORQXkOOgfk+1cb2e+Y3plKK9ceL1tMlIVIjFVzg8rSdzmJQgfQxHHF+hJVCcHZeIqld8VbRqoOHqCurqc7NCZsK8WCVm4NZyxAX4xH5aZbzaHQvVKY7UQc4BxthK5VFmckdQ9homT/EOu9IaDgIrHdhX5dY5Ob7wX/MBkaRzE11STFZRl1FVoHH/qmnxfsq70L2K1VVOcJAu/WqW7+lMYnjCiunNx3UKFOJ3cHONTd/AWx5I+V7roCUeGcuBWgSRjcz4aCH9ejp1P8hL3aZVRcVQKMuWQDgVEH+wgFL25wMuV5xFfnadD8+fe20jv2n5mTt5hNTfellADI4CuV/Wq7zxUrGMZFw2Qdwm0rueIcrHlnACZBzh6OUOtnolxEs/hKAnrYY6lpXgX9nvUrW69YqISB0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MHbhXxKt9kZC9d5s5/vgtVGcjyF7r+VMZFnCTNBixyAjS4TKsB1qeHng45bf?=
 =?us-ascii?Q?XZStakhphDQLVX5BeYFbzFcj5uct68/EyId97fcKXW7VEaJ6H6ZUXNnK2Kn4?=
 =?us-ascii?Q?nawP/huiR754XNryVXMf97RIzvZPCI/Z5NqQBZqfYp/AYWatLIf1DefpAZq8?=
 =?us-ascii?Q?H5/dvaUzn404AEBHojFZ4U1OY1/pjJSZAxL3SYds5j/pTb64XU85Mlm8Dauy?=
 =?us-ascii?Q?PFkybrpNAepLVb7SPPu05nEQEKj/e1z+4+qWrtpBglORgnqHPkEscxrM26U5?=
 =?us-ascii?Q?fwbLO970PE3H04EJbskIs9/FybtkcQ4Smf+N8mqz5NrefY1sBeTY2X9zSR+D?=
 =?us-ascii?Q?KX3HjwgMBzhrc59DmGmF9nlXxqZfPuQODr03WE+EBUXWdHnEv6c+msQrnaNA?=
 =?us-ascii?Q?PESf8fsnpp6Fr5hB/XntwqYWakW8ufcChqOqegCnQxQt/o35JXDFn2ShlpHl?=
 =?us-ascii?Q?XQlj4qXWhf6fGvZBC5Z9USLpd5bspjuoPW01lIT5vLQxh5sFnYqCjiRK5fb4?=
 =?us-ascii?Q?Q5zbgRcEju9WGvuo+kVjPO6U8Ypm9Cka+ymD41QSEh/WnbQLjr7QEJtaB4so?=
 =?us-ascii?Q?JZrAckbLeWeogRPCSEANHt0JOQYqmmP9ZFN4gwB9LJ8l6Lxqab9gPtX+tPu7?=
 =?us-ascii?Q?9gJ8KKuUaYyzFi2qazfEd87HYaERaW8DNqTnxFMTwUc2ovebTQCY1YolFIt+?=
 =?us-ascii?Q?fHJEVhLSP/EL+5TLxYu/cQ66izFEW4Ry9uVt1fCd4Gh0OT0yMBnHw43CMCtg?=
 =?us-ascii?Q?kqRfLht/tFiCcDYz17FW4Sk1wpSZClkoIVOdrySIWmxSWFLdq7CigPnk3N/o?=
 =?us-ascii?Q?nno89TYMLwjU6iqXFhPKWhMafUPAP+TWyKQTLoZQd3Axp3mmDh3l4gOp7LPU?=
 =?us-ascii?Q?1rZmVDFuOotnegY2YI5k6XzKtXBX/V1WffRu5Qu+9s/gaXdc6N7YIw7fVaBv?=
 =?us-ascii?Q?61dzTh+unOcUhALuccsi56K14cf+TdBSKcGUEzqApWBETLePjcnth+jCg7Sl?=
 =?us-ascii?Q?a/nzMNNf0z47A6DUd+vn0hGtI8s7UzpwZBN5Nat1g5ST7gHyFvgWl//29vQ0?=
 =?us-ascii?Q?QvsnqOxZKzqDpT5CHwWntPMDYy7NXclqY6fWfeRCH3DCQ7MVAFungWsfj8yG?=
 =?us-ascii?Q?bINKHnIfRFT+g72JGQ+HI/PdJ9MfoctUgz9IeF0W6Up/Lto4rEZzUkm9v4v0?=
 =?us-ascii?Q?/iZlIRmJM2+np3rXGdpXVIKMQBy/qwU/+By9VgPf3y7/DOshOhSYtj1PjLyR?=
 =?us-ascii?Q?+A7EPq1TA6aItsyx/Ax+bupeb3fT7gHY85b1gVA3gvbtBqQzQ2VBfgNFoO8y?=
 =?us-ascii?Q?SANg8To0rTeFxFsaNOlvCp6WYrFo3/QLUc8K06zhsyoxO0eiOn3AzOP8U1E7?=
 =?us-ascii?Q?sBa2AadOFLfE7KZTQX8tiBrCk0gSVODb3qnzqhR+9NTeiBSA+xYyeF4L3YAx?=
 =?us-ascii?Q?etK9zgXVhYjqunqOTPh/Mh9lzv41et8cs8jUsEe4sZZSfbcCBLQSayR9UKw2?=
 =?us-ascii?Q?RzbpvZPURq5xLpThn0w96SK9N4wwWIa83fuOF8JS9Fux4SmdI7EZt5XNArbq?=
 =?us-ascii?Q?VpdQHzbm+D/gSmWHhZG5BgQYbUMdAMffuaHDYskd4rtmeSCsTSGV9eQZLkv0?=
 =?us-ascii?Q?Xln13/9z56X7gABfq3UpcbbO2mfdTVHOt5h0HGM3WxDzYr5by2JeqW+fqT31?=
 =?us-ascii?Q?WAlYgbu0QTyCbihmQzBcSLKYQuhymQfgbp++UmAVeWYhbaE4zoEW29S6bnXN?=
 =?us-ascii?Q?t39Ow3xwdA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38982782-3011-47ac-5979-08de9beea27e
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:39.1351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kv0lgFhYMmtgusQSIdG0INAzHG83AIXNEYwyUiktOptLRxZ+vDwZN+5qdc+ZKKlpPPvw7q/PtTpsVF11X/j9Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

The io_queue flag informs multiqueue device drivers where to place
hardware queues. Document this new flag in the isolcpus
command-line argument description.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
[atomlin: Refined io_queue kernel parameter documentation]
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 .../admin-guide/kernel-parameters.txt         | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4510b4b3c416..52ede95db56f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2827,7 +2827,6 @@ Kernel parameters
 			  "number of CPUs in system - 1".
 
 			managed_irq
-
 			  Isolate from being targeted by managed interrupts
 			  which have an interrupt mask containing isolated
 			  CPUs. The affinity of managed interrupts is
@@ -2850,6 +2849,35 @@ Kernel parameters
 			  housekeeping CPUs has no influence on those
 			  queues.
 
+			io_queue
+			  Applicable to managed IRQs only. Restrict
+			  multiqueue hardware queue allocation to online
+			  housekeeping CPUs. This guarantees that all
+			  managed hardware completion interrupts are routed
+			  exclusively to housekeeping cores, shielding
+			  isolated CPUs from I/O interruptions even if they
+			  initiated the request.
+
+			  The io_queue configuration takes precedence over
+			  managed_irq. When io_queue is used, managed_irq
+			  placement constraints have no effect.
+
+			  Note: Using io_queue restricts the number of
+			  allocated hardware queues to match the number of
+			  housekeeping CPUs. This prevents MSI-X vector
+			  exhaustion and forces isolated CPUs to share
+			  submission queues.
+
+			  Note: Offlining housekeeping CPUs which serve
+			  isolated CPUs will fail. The isolated CPUs must
+			  be offlined before offlining the housekeeping
+			  CPUs.
+
+			  Note: When I/O is submitted by an application on
+			  an isolated CPU, the hardware completion
+			  interrupt is handled entirely by a housekeeping
+			  CPU.
+
 			The format of <cpu-list> is described above.
 
 	iucv=		[HW,NET]
-- 
2.51.0

