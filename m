Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020120.outbound.protection.outlook.com [52.101.195.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BE3B65C;
	Sun,  1 Jun 2025 01:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748742070; cv=fail; b=HsPKTlECPC8yiam1h2KcKq69Zuhv45ntdGLh0+6sc6CekXu9q/y2A3tak4LKVdCgEENAcxcykySzIfeH+OisGsaZeIEPNeUmjU5sewj/SWXnPvXsNcIzyFxbvUcG0yF69iyN0lAd+lqJ2aQDpxytIZ0P9zGfDR8yNMsOOYNeCkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748742070; c=relaxed/simple;
	bh=B6hn3UBHBlu8qJZMy5OIjmFPSSgcxq7rDFePY15cmXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EJFPACUlVPOXZ3sI6FrHxyK7da1n47AaiX1AlDO5VZpGCzrOAOoWNWCms1XEZTEBxbufnmSGDuhX3xOSN00giZEXuL7RjwWc4IgvvKUWvbXzWiASQGv/R9dfWZZ1EoOaSTCYsm9hJuFKVUl2mWQ5WGEBLW8dnOQonsNZqSlef4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8awuBfwmwMvKRdN2rKKZSIcX5MVwXeYBtHARcyK4g3Kc5gYuqxdMk3o10Pt6A+AK2hfSAF0TeIYVghXphImC11VBZvYPzYhLpJtRPp3MRzsd0MsHSxv4fXLquU8uvPZdouaospZjzEBBp8sfE+lNCaHn/RI/mPyeXGA6dlYBHvtV5NXhbYtFqxTQN+NT/O9A4NBV4jWGRbCM0Qh1Ne6y7T/n5FZgxpzXrbGlpXnxK8jtydanO+2+ke6fUePzPPDgTH7VKan/h3oMkw1UDn5YFOLqKSkcsLgvd0vrimMtViZ4T3dRXCTf0O30FZBrvoueY1ClNt7kRbJxmJD/UpsOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gey7zi8sodF373x8/Eu8hbKh4sP35j76LkbcMPWS0M=;
 b=JmlfdsPcBJxkWLRFsHLFACS6nWh5yAWEuqFkBP7EKqJ0flvUbeb+tMMFEvB5Y0TqAhH592Swha1E19uGwrHIf2SSP8uxbrQyc6Ph7gtdgCnuBoa+d74KBNjJvPjGqx7qbJtcOxpz4Jj1wGIom3ZDIdM7qe0q/T11PTRkjSpKyDy2/bTwODoKpZfTMBgSJQvHWDr5W3S5h4OWqaQx8oGcKLlIhLIbPilRtFZxQqQXCQYt/BOkdDUFkphZcpCsXkiQ3qY1flqod0i8Bg20led/S3LFP0MHQfGQQnIcah0zcNvucT6C1OtF5s8C3LeBgDqnw6rcu4MhF0GhCZ73JFCJmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB5679.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:229::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.16; Sun, 1 Jun
 2025 01:41:07 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%4]) with mapi id 15.20.8813.016; Sun, 1 Jun 2025
 01:41:07 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	atomlin@atomlin.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable module parameter
Date: Sat, 31 May 2025 21:40:56 -0400
Message-ID: <20250601014056.128716-2-atomlin@atomlin.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250601014056.128716-1-atomlin@atomlin.com>
References: <20250601014056.128716-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::9) To LO3P123MB3531.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:be::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB5679:EE_
X-MS-Office365-Filtering-Correlation-Id: f392be29-5db4-4b2f-d6c3-08dda0ad5fd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bDyp8Dw9ZyYKeRaRxDT0Lq4sQi456hWRbrKOyTOJRv5mdIgfDe5Gr7g4iCo3?=
 =?us-ascii?Q?itH5mBzJ077JCbRn6u8nZSWfKVhwNVBvPeKi0fQy8FEPeEAL9k7sW6/vhMUy?=
 =?us-ascii?Q?wiP44QvbRyyT+u2pXYvIBifBo8nCpiGuY827TQUG4VFbsIuy8WnmVYyEmTkT?=
 =?us-ascii?Q?Qxa9aJ2kqEqs30WaxkUNp7R73Wh9Aa5EXtpzQCq5B270KrkUmLOapciSn2zo?=
 =?us-ascii?Q?Z1+F2aAPNi3OVFq/K1weiLTJ93iXVqSxOPwd63t12ZHENnteZTtUmgOEf2Iy?=
 =?us-ascii?Q?BcHBkO1lAl7vp15VRXZQb7z01IXssk31yQzWMxWwUM+l53D7ohURlZsVK0As?=
 =?us-ascii?Q?VIiQQPERVr3CxdxLAZJjMWf37LaRncldRECarb1bGr505pDIPBdzWgmx+4m5?=
 =?us-ascii?Q?z7QxjV3PX/YpY/qeTNnPH9nzOZEK1vdx1VPHEClBEZ2KuAjM8Adht60ixY/7?=
 =?us-ascii?Q?0QofszZavr9U2vcQfIqK2ZvEUJn/19Ie00/+LOPF9y2BsxgSSM+NMm5L60FM?=
 =?us-ascii?Q?z7KyD9CbHUhos5SQq6eEuHKzdim43G66S2QWbLUrj7N6hU8Ob6OOUjKyobUO?=
 =?us-ascii?Q?UeViCXAb955FVa++PWmcbGh10TOD0PpJnO+pRT1ssyhpWKhuYgHef5SKMpw/?=
 =?us-ascii?Q?Sm7xEBRBxGcVtImq0ffaUCoIUyGQ983eCjb2vp4LcM+1lHPdPIzFNWeGHBKF?=
 =?us-ascii?Q?t8qMFVcbc7vDNlNyUueHgjjbUVDoN3sZv6jfZfrIkGpMWgzEB6nf+mewmEgF?=
 =?us-ascii?Q?cBcFZUjyq7wHTh518ZY519f6SNi0cz7XPLo7FU8UgYyUhRbR/KMl1LHGJS/o?=
 =?us-ascii?Q?7AnDIxYgTaDCCD7uDEldhJDmvEvvsr7MoRaYnvNIjyIPs+J5wXAJqu5B9DRl?=
 =?us-ascii?Q?kALZ+5pvynT+wba3IaP7J4eMQ9po3mo/+F+z6fHp/hU315UD1j+BHVHPNgB0?=
 =?us-ascii?Q?TfPKQq83pvHdp2lmDzVYkhaoKXZXt0j4bgjbAlnCzQb77AW3YDY3T14i4qqS?=
 =?us-ascii?Q?G1fjuDc7OyCaVDV1jPwkYBx7UZyJpk0lkr1ufF/30tJ6uWEoUf2znxKut4r1?=
 =?us-ascii?Q?4jHGC+A6lFiGWo49t/CPgilyhgRFbQ0wTNoGNdj4rogrHBbno5UUZ7Q/MhiD?=
 =?us-ascii?Q?8jx4RG2CVF0+0Fm+QTjnSud6/dn7B324F9bDNauLMnCdm7gAn55wDxS4ENcP?=
 =?us-ascii?Q?PF4O3icGVqNB7BPzSutPvZkHCCw9oh0fxz1xP1iQ0Zh3uYSGTYGRqw8AplWr?=
 =?us-ascii?Q?sBEgMITZhOxpbzsDc+PAr478V649ZQF01MPGTaJiWsQ+Ev5PkMXSjaysQ8aa?=
 =?us-ascii?Q?fOJ8bEvIQsXhfruabqBjnmYhfkdkpFgyG/uPSd0RxqmfLITghliTNJtMSES7?=
 =?us-ascii?Q?yQ/hZ0s2MtT7vXtvGLcpQZVSWtGQPf4r0PY0/tA7w2uALvIX7P/5TiGIvoxE?=
 =?us-ascii?Q?jdocuuPxOro=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r1I4tUCeq24vnhx7d/+t2hcJEu+w6xatD1CHUZKbha67uU0gL6Z2DPqvfPeX?=
 =?us-ascii?Q?Tmb9obRAyJUbzoLz0eSlOQDLGXok8mnAPs5e0x0ocT5P1+MwkMyw/ZUIYfT7?=
 =?us-ascii?Q?rbvqp/n2eo0f/hJrbbdsteWJdMDq2UPdCR2jO9YLUwN+tymIyw3dh/DTQUqk?=
 =?us-ascii?Q?k+mdTzSqiIi7amCGbU5eemlNOmJXSv/Jh780WAu+rVqLR8zbECGLf+bJLupD?=
 =?us-ascii?Q?LlfczjlkoxaIY/sgLXo9NCxTJ4UJAIahI6B8KYZnlj5aBRSZ+XFFoAmENsId?=
 =?us-ascii?Q?yWvtHSkZdBtNfTfLMSX4RbiEwoQoQ6htbPCWHX+bEyE8X5ZrDtO9J0JD2NcC?=
 =?us-ascii?Q?xVMjegXtgVclneA14TKwLMd51qL/g0EzB3fZeil4VoWsARPDB+LBGhsMzNAM?=
 =?us-ascii?Q?vqR1vF9akxOMH/YyUE7oZCEDcZpoEbJ/11KqSVf2WwXqlAFZq64J4z02hU9x?=
 =?us-ascii?Q?ILhkwceq/Tn/2HwF30UyV8bI1IlqN/GGTc0Z5YMq4iLpt79/T0228GLgjuw+?=
 =?us-ascii?Q?A+MoxkWebLzQNIXgh/jhzZKM0shddm/xczfjtcXC2fqcoUH7WMeZQvnnar/4?=
 =?us-ascii?Q?F0TF8JF64+JmUnUmGeFUdzPze9ndOeTzGDht7BFv/ksIHF4hkFRYkVZy6f+e?=
 =?us-ascii?Q?9NBBECHEt34hZq9CThx7kDXlFXml1oUUzUDRxSbnDmAIXDtKdGf+0+N1I34f?=
 =?us-ascii?Q?RNVlCsMOnpqVKNU+oNoW6SDh1/R0sSn92aroMwSIlCV1szeIGGGNo/FeFxaR?=
 =?us-ascii?Q?1ls/kcTEAZK93zyhSTXXZXFc4Qt/3TWutf5LWOVLVvj35j8/W54UgMfj3cKG?=
 =?us-ascii?Q?PkaO6xq7Yb8ZEA5lK5mr0vtDYUqqUFy7cqLwnhE6eYqQt2NBROxWK0ZnKBIh?=
 =?us-ascii?Q?Bi3VIkZHEAL31u8hI44RqeSWl23xCuwP7qIrDHbJbVVh3gYSa4pp7y++ZaZ1?=
 =?us-ascii?Q?BrVukubCbtAcr0T7z487GQClDGUg7THEJsmQ6UxgLEcIN18ENVRAF/IAuajr?=
 =?us-ascii?Q?0gLNeEoJ/jA6IkuUVOTx557DAe728aZz47ZfWJkupG1qWnO/4Xhak/YJI0nu?=
 =?us-ascii?Q?IMecsYHxQkUjU9JghNJdwaKtPEqoBAdnngoZ4MtS4y1qA4Qv6GRE3JmhNZZA?=
 =?us-ascii?Q?ucLU/G/se4Jad9a0kOeD68DERJRplZvzK5ahrNkjJHcpx6GJcVdJxktAugDC?=
 =?us-ascii?Q?y38TQCvV7LrQdgFphMPntuTZwFo6fihxtV4ruN06+W7wYw+rea3ffEFJo3kU?=
 =?us-ascii?Q?qG0KWgtqu+pgwDOzAWKPTjTPdOulOM8CdzpUF3ocxEHEHI/r/rLNbDlJ8/Il?=
 =?us-ascii?Q?jLyYbP1eEqdnIcbtAuCvQUjDaKJjiZRD3P2RWvKeqxpsUdslsf2fBMjmD2JM?=
 =?us-ascii?Q?WHtW3Wd1fzkp2pXMiLAsYZ/dlxu1b1WiiMc36V0Ek76R3JXTZQCOAbbXewoe?=
 =?us-ascii?Q?qx+FXnQJvy8M8iSV2nKFCA7vdWpCzcg9hlFWi65eO+Z5kf+hextFFrNmKWRC?=
 =?us-ascii?Q?QXo70M/m1gVnwBxNv37+/WPhp0XckY8MiybmK3UmM0GARKB9vDU4uDOa1U73?=
 =?us-ascii?Q?HL8bT+YHtrQsXZhlNMRh2gvt1TlmmtA7j01toTWs?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f392be29-5db4-4b2f-d6c3-08dda0ad5fd7
X-MS-Exchange-CrossTenant-AuthSource: LO3P123MB3531.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2025 01:41:07.8084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGYqn61FYVzZMcVQ2FhNktKIrrCqQ3x8NOx4n2pW/j0mAKNYw6U+VGvjsxjZ3QYgNSCY8mCix2Y3wy/pqNrzvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB5679

This patch introduces a new module parameter namely
"smp_affinity_enable", to govern the application of system-wide IRQ
affinity (with kernel boot-time parameter "irqaffinity") for MSI-X
interrupts. By default, the default IRQ affinity mask will not be
respected. Set smp_affinity_enable to 0 disables this behaviour.
Consequently, preventing the auto-assignment of MSI-X IRQs.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 14 ++++++++++++--
 drivers/scsi/mpi3mr/mpi3mr_os.c | 14 +++++++++++---
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9bbc7cb98ca3..82a0c1dd2f59 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1378,6 +1378,7 @@ struct mpi3mr_ioc {
 	u32 num_tb_segs;
 	struct dma_pool *trace_buf_pool;
 	struct segments *trace_buf;
+	bool smp_affinity_enable;
 
 };
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1d7901a8f0e4..9cbe1744213d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -22,6 +22,10 @@ static int poll_queues;
 module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
 
+static int smp_affinity_enable = 1;
+module_param(smp_affinity_enable, int, 0444);
+MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disable Default: enable(1)");
+
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
 {
@@ -821,6 +825,7 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 	int retval;
 	int i;
 	struct irq_affinity desc = { .pre_vectors =  1, .post_vectors = 1 };
+	struct irq_affinity *descp = &desc;
 
 	if (mrioc->is_intr_info_set)
 		return 0;
@@ -852,10 +857,13 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 
 		desc.post_vectors = mrioc->requested_poll_qcount;
 		min_vec = desc.pre_vectors + desc.post_vectors;
-		irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
+		if (mrioc->smp_affinity_enable)
+			irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
+		else
+			descp = NULL;
 
 		retval = pci_alloc_irq_vectors_affinity(mrioc->pdev,
-			min_vec, max_vectors, irq_flags, &desc);
+			min_vec, max_vectors, irq_flags, descp);
 
 		if (retval < 0) {
 			ioc_err(mrioc, "cannot allocate irq vectors, ret %d\n",
@@ -4233,6 +4241,8 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed_noretry;
 	}
 
+	mrioc->smp_affinity_enable = smp_affinity_enable ? true : false;
+
 	retval = mpi3mr_setup_isr(mrioc, 1);
 	if (retval) {
 		ioc_err(mrioc, "Failed to setup ISR error %d\n",
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ce444efd859e..6ea73cf7579b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4064,6 +4064,9 @@ static void mpi3mr_map_queues(struct Scsi_Host *shost)
 	int i, qoff, offset;
 	struct blk_mq_queue_map *map = NULL;
 
+	if (shost->nr_hw_queues == 1)
+		return;
+
 	offset = mrioc->op_reply_q_offset;
 
 	for (i = 0, qoff = 0; i < HCTX_MAX_TYPES; i++) {
@@ -5422,8 +5425,6 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_channel = 0;
 	shost->max_id = 0xFFFFFFFF;
 
-	shost->host_tagset = 1;
-
 	if (prot_mask >= 0)
 		scsi_host_set_prot(shost, prot_mask);
 	else {
@@ -5471,7 +5472,14 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto init_ioc_failed;
 	}
 
-	shost->nr_hw_queues = mrioc->num_op_reply_q;
+	shost->host_tagset = 0;
+	shost->nr_hw_queues = 1;
+
+	if (mrioc->smp_affinity_enable) {
+		shost->nr_hw_queues = mrioc->num_op_reply_q;
+		shost->host_tagset = 1;
+	}
+
 	if (mrioc->active_poll_qcount)
 		shost->nr_maps = 3;
 
-- 
2.49.0

