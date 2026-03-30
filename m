Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020102.outbound.protection.outlook.com [52.101.196.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB37A3A640F;
	Mon, 30 Mar 2026 22:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908701; cv=fail; b=bbv6aa6aRmTjfppy+MHmdhc9m2+UY3BPREMCNGD9LCDNP6nSKiy0Ud3zKf1vsHRqGYkpn+deCUoFqPR6XxOnBP9tX39PdNr/aVpBu1avvUrjY0CDpXkRTAxnX2kuy71+00xZ2KrPUOZkh2dBcWEuFVPc3t0lM8GeMww2Ov0hO+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908701; c=relaxed/simple;
	bh=ogEeDzV+LVEZHZ1eRbPOXXTGYSqG5oysG7Z3ejObpe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z/8xd3CiiDMQP4gnbhygo2+dzXbqJ1f9NKWa6PlQjZ8jSM5bSn4Ed0MQT9CubsnYahQ1zWmX6A3mHzAx+4mJJAk/u/0cUOvFvKp7Bc+PL9Kvz5l3ZS0y/zOIjhXzaUevsdLqzOWZUHpwbcOmDdfMvrHQ8geW3w8DXSzKMKnGxzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BEopKRXQSLCJwv0eI/tIA0MJyPdofTMO/9Xt2/Ur7D61BD09kquidsiDJ+0kO4urT8BjNoLvIpX/9TTWEox8yjBPwfFQ0xHv29Cb0qB1aiLcYOTNw/r+NcgdxlWsVW+3eDOWpzLpp5owxf7A6hkfbHtrds15UyS3WxR3gt71yxHr2+COk2DD/YPIT7m9s2fXVFvpg/jnXLAHTLXVOk53fWYXeoJIRA/inrCSl7f7so8mRi9IMorU2iWf5LVUAniyjhpAHtxnp+RXToVYNcDbDfwpPL44fRs8S5i9EtXDmVKpmBkYBPzEC1ur9ra8fJ9WmqzzeyQIZoPbcW+sYDGHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmWC6QGOVxeNPUHeGnXrU3BrxZ8azJrRPagwYTbPgrs=;
 b=sYcMIiElMwh5Oa5A0SFEZteKwZ1+7NlRTcMczKGW9m9NryCQjMa8VXToJDZqfYbwKwSxqoG9uDfgouOQrrP65pnF9C/Zf2P7qFvf1qnIk/JVmSknSvGyybmxTByqdyPdkRA7PTDBiw8413mQyrWeZxXNkE8/ll8L7gDd/pOZhhI8Y/GE5aMDhxCZ4gflUSjBVsxJ/KHmaBsifjGIw3w9nXLdYbXVARAgZId+LVykeXeu1sm6Ahms9tMqFylrEogYOYC3uqpH6mfHJ+LYvmis4GN+CDloj8ghpxXPCHtc+k7XmaWoHCf4Fi7PabV+pf4soj4Ici+U4OlAqWSyAdznNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3841.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:37 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:37 +0000
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
Subject: [PATCH v9 13/13] docs: add io_queue flag to isolcpus
Date: Mon, 30 Mar 2026 18:10:47 -0400
Message-ID: <20260330221047.630206-14-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::6) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3841:EE_
X-MS-Office365-Filtering-Correlation-Id: d3c8f54e-d209-4090-b5ee-08de8ea94fe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bwOevYgtoZK271KtY0FnpSfJoISBBhsDcJqda2ivxq1jxoorirNxbxLy1Mt+l13EGlhnVgl9PL2bvmGnz+B3anBTvFi+JkQTKEDibx0MfLw9dASDzCU25l+2UfqRACoqfZYeJZnhSdlJ+JQZ2B0dyRa4bbbuI017Y7GhfeT/879x81RZinIbWnNRfzEnIlSfcov/b/mPUaVi5iQVWoQH2bU7g/lY/pgVVK7Pl6yaAvIBX0UVZ24k8wfMiwdNHjTlFnuUEcpnKCttiAS82Yc35kKvtnMMNyffrilgjT+Qji3nRzJSW30bLmWWpEQGj5y3ZQ3bkWWxZV3a+m6zuAaOwJHde70Zc1Qi5YyHN90iI7q9qI01EzpiduogZKQkUTbfqtYsLyqLGJQJsjmtwujj2a7U3iE+JO+VuTnOUj5zf0pVBAfKUDLpg61RTyDOzLYWseJFwvGIs3FtBOOLqc7WG/hHPDPXgyymHbkFF/w0hbVaCimLsrLtCL0cR0bsRWp1x6QKCosYVD9ih9DP04eMVVaAu+YfySDRcR1zIALW8Z21m/zehdGNYhjVQgN3GS4qKoO9NYE+lHYAVyFylTyl4O/ocejUkkwO5p+6dtJkaqM+K4YrBKEkXX38Ak3Vm2qKWGDvUTGEthui8B/dYyKKD+dr8T4bGTqNEd/UaTjJxlTf+IKM5xb2eO/yWV5bQruThXqhQyHSuDwtz290k+lgFYZTUXifcGv7DiM+unMKJWE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z/G0RWZ7vb/zrDN+23KOagkHa0wApItIz6l9pa5q1OcMnpPDFd6ASLpHsIpY?=
 =?us-ascii?Q?XvIDoAFvAPZDMVXSe5IB/mt4epWiYDSaIH0po7yq4K5eljL+4CFf/9w+GxgM?=
 =?us-ascii?Q?Ek0dWNFPXxffHJSuuQJ4dUKbf0gYhQ0Llys5LciK2fDreKaTaCDKeRuSpNhE?=
 =?us-ascii?Q?0R+OqNkwVmEEx0nc7h45JtUnIinADTRW0zuvcZj6dBXljvNGTb2sltGj13zX?=
 =?us-ascii?Q?p7cWMFgi+M3ndaocB70fy0hDS30tBcCEkBZsuA73d2UP0QpnL8WvHeNQpdbn?=
 =?us-ascii?Q?5uU7NoMQmMy/Gj1u4xZXpC1M25iLobzrcKo17DSuvYrAYqi01ibSai+TXWf0?=
 =?us-ascii?Q?BUiVsi2LDpOFNiWsThuraGu7N4wyWUic/REzwFK+DuHwUf8YZcB2gBPLDhjr?=
 =?us-ascii?Q?Q/jVI9XY+sDnQ1zrZnTV3WVIHwqA0kvsfoPdjlEQL2UAZY/pU4xItt34x6yt?=
 =?us-ascii?Q?aW8LUdJvM/xeHsGKzF0txPUNHRiYbypiyFofeVoRzEHCDpaSwGX7rOT+ISFu?=
 =?us-ascii?Q?JJi+ulETamZqLBgRIgoOD+8G0GEDZLG9LZKN+x+FsJInRLcRaS+Ano7bKoEN?=
 =?us-ascii?Q?yk6PL1U08TlRyBJAXhNVf/7ywrWASIvIanbJqe6ht3u0upFeneBJnc5s6mkX?=
 =?us-ascii?Q?FVwdjhaaht0h8zuDY+/mBy47SkuHgax4TN6l3lSj2D6gvw8A5DDmgntte1vx?=
 =?us-ascii?Q?Sw+r7T2aVgPfJzFaRJ22OzHzFy4t1TDxBVQShmU/XUlvmXAIVXXPObXzzvzG?=
 =?us-ascii?Q?ZWlDkfnpuGNBnwMB60G9AoV0GJj9h3VmmwPcidjFVea0ksq8vJ3fZwkPqnVa?=
 =?us-ascii?Q?D3i2SvF5sOc3Slata68fhgrUAiDT7KZDFkke/O1tHYyfz8d1rJc0OzPd34lS?=
 =?us-ascii?Q?6SeDIPbeEuMWNpXre9zm+vKU3CyrGLY19tlHPilOZ+jIAplQJWmBaIzZm8z8?=
 =?us-ascii?Q?YyTwHiQohx5/DpHV7PqmcXodiOIwo7u5VgtZ4FZm+Oi8RNRa4scTdpZOaIZc?=
 =?us-ascii?Q?1BsC0exVGOmYCJPLdUm1Iwj/y16Js8hVFiKn28zkWk7b4f3QDrF8Ows3SD58?=
 =?us-ascii?Q?SRpuVhUexRKtNW7Y71RPPEUARvTfhgiLWoU/jB9bcMv9v9yICiw82C7I+/ft?=
 =?us-ascii?Q?e18BV7YtOzNqMJr+PDpjCLNi44+tomBAr/+bJO9NTIM6Widep9dcH8qq8bEZ?=
 =?us-ascii?Q?x5sxyctvkvym8FhbraWZLz+rI2hCofSAJr9QsMLi8fN5hwyfr+Xlsda5n05u?=
 =?us-ascii?Q?Vi697AcKFTSTbzW4tSdSZYSRRl6EAnLCxDiYDewYxrNl5+OYbpze+4OhQHuL?=
 =?us-ascii?Q?hxYuZ7ziBaOUUt1eA7MHE0ipSPNk7LxkfyQK5O3UUA5eoXjaxYIJXUHe2+ze?=
 =?us-ascii?Q?Au7pRHEwnXliEJ/LX6GDhMZA8KhqHuPViFRNWOvaQpIyEc/tjO0yqOUNL9ke?=
 =?us-ascii?Q?8EXglu83Sc9nNzHuPp+YYN/OHP7KJsYXlTmj7SGEP9gPb1z5afY2GoHS/jCn?=
 =?us-ascii?Q?NVrAnoyvgIeT6Z5JWM6OVl/uR4mLQyONKX3rmjAus5M+945U9Si+kcmIpnVr?=
 =?us-ascii?Q?lircV6SndZNrIYcvggWOAHRRpRtQP7JXRLyNnkiBTIshYLrPlkHIPSc+kIqG?=
 =?us-ascii?Q?WwqJ+hKZPrWumSAbyV5RW275BuTQO9qgjQI5A09RAXeyQ9dt6C8A/pFUFv6l?=
 =?us-ascii?Q?qX5ILuTY4VgycEmLQswRIW+qiVrumMwDAsuUy/z/uj6QdnjjYtueDiP4QDco?=
 =?us-ascii?Q?pdf7+FmFeg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c8f54e-d209-4090-b5ee-08de8ea94fe5
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:37.5134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlXPCWfJOEsyyRfj5yD41KgKISdUNf7WHxsLudLFXFw9vQ8rc/SZHOUe/N5N9Z9z3ewIllGhH/YHvUw/QiCJwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3841

From: Daniel Wagner <wagi@kernel.org>

The io_queue flag informs multiqueue device drivers where to place
hardware queues. Document this new flag in the isolcpus
command-line argument description.

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
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

