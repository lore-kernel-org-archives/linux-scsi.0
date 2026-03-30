Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022078.outbound.protection.outlook.com [52.101.96.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7463AA4FA;
	Mon, 30 Mar 2026 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908673; cv=fail; b=BX8vgLRvncR7AWBzn/bEZMGryhdaz5ZjcH6evyWoyJkTRk4Up30Aw7lh06+dX5W0+8m/iY+2ATOB7Olp7JL3EDTb6FRV2QVHlLBzc64Sf3sHevKFLgg948etcINc0fwKw8Uc+y0hWbmd2IJdDgVJeDDLotqT8UgxT6hWC+FGzrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908673; c=relaxed/simple;
	bh=TfyOcIJyLFNHOJ/MVSOb3tQsDVEQ+ECPRa/mX3K5Ul4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gXqac7UakgEWe+B3NxPFMtZma6JrDN2dnkwX+cs5NovaU7nUoVCOB0EiGtT8JJ85n42VhzmYx1D4FRr30OSIEJWJE9sesV0wh6If7iarDmP621yDgqfFO1P5V/s60pP3yp5gFPS3dVV48ClfVVp2Brp+arWAjFkVSQQlMCz90MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k4F/xYDdgLHmGfFAydZao9cQgd3XX1188+gA/HBjt64vwuXkImGJxA7BDFnqIVgYgCOVBitNxNznHbSqaqEntzF0jMCy8wcwtwMyVZSCnIa/vW8aAzYS3WJo9sl+4yb5o+tbMM615RK+AK9wH+N7HpDSF6ZYOA7CnLa0hL6AfbkMWu4TN2ku4/EqvvHQi11SI0qjbXflOA7ZWiC3ft5aUMzKXurjcMToBttB1fx3rpZn6YAWxs34U1YlhDE3qpL8ONFr4yLGgl6Ln6huTeBHJNbtUdgkx2KoZNXQl2z0UpFNNzK7heoaF7gT5VMPwhX0vRJnFy/Fb6cEvcwjK40hfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kg3yHjLjoMvYW0pRykwx8zyz7xjOhTSffO7qPpl9FdY=;
 b=UNMDz0KLeNi8ocnGiSKXUdEJIRlsj3KMHQQdzuevQGDY6NBTV1DSGfyEmVuBaYUoZT0VlCHISo9FvkkLHr9bWfBqOIR9aoXqr70WMqtrZUxqxgXQ2ZHhsOOQAfmkMw/WVNUzfNvo7t9bQWOxhhlcP1hzswHIb2A6LPuSpcgGgAgHlndiIVgXpA6lBRRsl1Ai3/LGPout6FunOEmMlQac1G7Mt6j6aTUmE6CahE4knfJTRKmVBqrpXvAzAT8LBKARr6NPOXtW9MDTCN1NNncnaXT6uhN7lXnOEhGCOJg+q7E6/h220QoL4YTZl/bdsrFucYhtSATd/d6bzjxncAoAvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6512.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:09 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:09 +0000
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
Subject: [PATCH v9 05/13] blk-mq: add blk_mq_{online|possible}_queue_affinity
Date: Mon, 30 Mar 2026 18:10:39 -0400
Message-ID: <20260330221047.630206-6-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0579.namprd03.prod.outlook.com
 (2603:10b6:408:10d::14) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 069247e8-5803-46c0-73f2-08de8ea93f0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6NmqDQAsRG460nzhKGYfMcXQrJaY3tUoOYxdni+7vzJKnfkBixULOsYicD6Rl8je5X57JrRREyGQIOFpxGzDWQLllNPR89o5MSJuyCbGluo0FoCZZdtGAWVwis0kILGpoifKpuWCC7ZbsGhlKpCJ8/z4GzhxXpBN/2WXNMBXp4RKqoqOVQbtq8IN3oUUak4rN7CHWlsW4y7T4up/cd7BMqaneerq4j/zwwPIgQ012+eADPBInXBecer66+PKMKownsk4WTeolyYuya87RumlL5ddSeNC2QrG2JfIxCfhLuxVM1gyWVkmgHsts6rBFbSn8YBKZnLFhie9QYEddl1PGvQVYsr6LQAXP0fwuSi9rYWLprhdmHMsqDFHXIiuwEo9S+RviLWx361bxUgWTITZ9N5yZU6/3I348Tn0ezJJXfNWteo0xBeUgi6AUALIxYbFkCl09IgNccwOTSqXKyHobDScb+9jH4KZhRjdzWVsHY0zIk59M5ZldWTsUGxPO/NfpNwmhPa4Ro/hGplNQ8+FgVszjaUWYop9fwM98U5qtytpuDJlAgB48K61k0y+82KllKGRC2RKK5kzz6kqRQMOP909nDdgwjQu+MbWpN6i/N1m75gvpsd0BiLZnKwet0bIiMlRYqUuUjJCChTsxLXhiKP01LbHLofE9DsRRIzQApHE8B/Fl/dfxdOQx0k9/p3RjtgM7t/HEBlmRSVV7ICDN0BGV9IW6G+ZltJ96YKiVrQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r6h5vbc1zkYcqrNKn7ANjDOq28jeXT4EG4/OJc93pTg4HxvdysyFa8cDGaKh?=
 =?us-ascii?Q?Cydj0KTkl3mSFANU97Ui3G9eZhRjUr8RGzQJdBfjhYuhSt/6x/jwmoPXC6lz?=
 =?us-ascii?Q?jdFYqJw0SvS90GnsyAXeS2UXkzYs9pYF2XzMMXP5NS9bODmphfUC3ljP5N7t?=
 =?us-ascii?Q?wQcBI5Mx5ATnl+lSVCx4raWgZUkvtL/tIyi9+7FCP1j5ETCKthBKJkyRN7Z4?=
 =?us-ascii?Q?2VZDesrOxfSYrjm54vY7NOftqoAogAfFB8sHKao5xHgSRaJAx8HC9vJZ5pyV?=
 =?us-ascii?Q?G3hU1AKJFqfUpmc3BMT4rf+Bp6MrP0e2TLTrqv5gZFOEu9L2sho4RImEEJM5?=
 =?us-ascii?Q?SleF8ttkjO/x/fvuhQ5c/kUVpZTc58mNkRUD24SnIIBnpy5XBCT0CryxlAPE?=
 =?us-ascii?Q?u5Proh0LClSzh8CrI4M644L9OiTBKBszzj6f9DHrvf+w6A5yVjBcYa8sOAu0?=
 =?us-ascii?Q?5zyjuhx4yhE9bo9DItIb9wfqUF/CnV3nsy/MdZTFRn1ZKN6PNFskpB+9nOxm?=
 =?us-ascii?Q?aCZJTGwJcpGJg6RYn6t14HUYI2vZ7nsEpw+Cki9BPC8CKGLeUQaEkuAKg2U4?=
 =?us-ascii?Q?+oNHfQRWFzCeUSNIbEz+0R5rnBR5pIOnGDiNesi6mffNs/eipk5PEWVsqqBU?=
 =?us-ascii?Q?hzJsYvSMLQ307ko9FK+BGQbLDBtOaYzBiXpCWJ1QNLywVo1lrNMAU4lE/0M6?=
 =?us-ascii?Q?l+ZdZHiuuhOS88oVfYAxJYiT5I1pk/k9zR64B7NOOW0X8f5nvTMoW2/PrbHH?=
 =?us-ascii?Q?+5yqZbQl7V6Rx9OkluBxoc5izydhUEz0EKkbkOHdOlVQng8d34MsBH2hKz5P?=
 =?us-ascii?Q?ZI/zYLWUU7cQzaSPy790fpMDR2yfJeC1OJx9lhe/GPIr54QKYADGo4eETaiR?=
 =?us-ascii?Q?0byWbNZFVofu03S7cAdS/FS/uvDHmOEd7RRwSUTvNR70mbThiInFzJknnwUH?=
 =?us-ascii?Q?xAoz1E5GVwXdyUa0dj8wJubk2hdHVzNXINO3MO9Phla9d4wgkHkDSWDqujRP?=
 =?us-ascii?Q?Uc9AhkewfFKNyd/T/dVrzoEKMH9uu33/AmBrSXsenuGEj+yE2NEuEr5GOQGG?=
 =?us-ascii?Q?Tcp3fykpwXpMMS+StuAvvaahEl1oYRMRB4/CTUgSSH0ZkTFYvnz38xI9qAoF?=
 =?us-ascii?Q?XzFOYwLPSjl4ygsSUCeRue+25fU+BIfHbghWwFyKjv+2vJCKsxDzclJ6lEE3?=
 =?us-ascii?Q?2yo/+W1OUKXNrohsuXnTuJB5wu7QtgTMnv+LK1oDaV1HlfY6A4zsXAoh7C44?=
 =?us-ascii?Q?HLHiX1KBKNH0ReMjsZjT3MlqaXwPtA5oFIGOjFvCh0DMkEU9KZjpFkOAPpaH?=
 =?us-ascii?Q?Yu+2V4VtG0yVfXfv1hEQzsi9rRWyT0J+p2GnF9mVULzwIPH0vIU/muEl2LVT?=
 =?us-ascii?Q?DLfkjJ7mGHVureVOYI4C9/us/V4kab0rSHApHQh0+oq9bxM+9PPM48u3XAaA?=
 =?us-ascii?Q?uzyrMuvuuLXwy+aUmWQuHQ8mbfp+yMPfVVd/23CTBB9Z+EUF6tWV6YCfozF2?=
 =?us-ascii?Q?XbSeZWRH5yFXy4VdThz4Yw1/iTfWe0kUtPXEx1i/EcpD/yfLqW9SJtIP269k?=
 =?us-ascii?Q?6Jigq5y4uO0H9Jw3t8KnPb6Ov6y71y9Kacoloq+VlvCc66tqWEITHelEvhe1?=
 =?us-ascii?Q?TPefhxQoeeUrPBw0wi2uv9vr3w90f7oRYL6vW6xuc1vwUSzPDdB+j21JZOp3?=
 =?us-ascii?Q?yEL3FXC8/ZJahRRHxHGX55K0XnrNsKQMR9cCwTIN0QbVWhpBdZXDjimxolA+?=
 =?us-ascii?Q?FAZAUwCoKA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 069247e8-5803-46c0-73f2-08de8ea93f0c
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:09.3153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bj+mUYGdrlSrBC9iwsRkvuhrLxC2hLPBtIVllN75v1sKvv+I/rsPvROllAGKSOD79J7R8EA6JNaU6RtCYtI0BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6512

From: Daniel Wagner <wagi@kernel.org>

Introduce blk_mq_{online|possible}_queue_affinity, which returns the
queue-to-CPU mapping constraints defined by the block layer. This allows
other subsystems (e.g., IRQ affinity setup) to respect block layer
requirements.

It is necessary to provide versions for both the online and possible CPU
masks because some drivers want to spread their I/O queues only across
online CPUs, while others prefer to use all possible CPUs. And the mask
used needs to match with the number of queues requested
(see blk_num_{online|possible}_queues).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq-cpumap.c  | 24 ++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 705da074ad6c..8244ecf87835 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -26,6 +26,30 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 	return min_not_zero(num, max_queues);
 }
 
+/**
+ * blk_mq_possible_queue_affinity - Return block layer queue affinity
+ *
+ * Returns an affinity mask that represents the queue-to-CPU mapping
+ * requested by the block layer based on possible CPUs.
+ */
+const struct cpumask *blk_mq_possible_queue_affinity(void)
+{
+	return cpu_possible_mask;
+}
+EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
+
+/**
+ * blk_mq_online_queue_affinity - Return block layer queue affinity
+ *
+ * Returns an affinity mask that represents the queue-to-CPU mapping
+ * requested by the block layer based on online CPUs.
+ */
+const struct cpumask *blk_mq_online_queue_affinity(void)
+{
+	return cpu_online_mask;
+}
+EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
+
 /**
  * blk_mq_num_possible_queues - Calc nr of queues for multiqueue devices
  * @max_queues:	The maximum number of queues the hardware/driver
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 18a2388ba581..ebc45557aee8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -969,6 +969,8 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
 void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
+const struct cpumask *blk_mq_possible_queue_affinity(void);
+const struct cpumask *blk_mq_online_queue_affinity(void);
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues);
 unsigned int blk_mq_num_online_queues(unsigned int max_queues);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
-- 
2.51.0

