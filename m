Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022076.outbound.protection.outlook.com [52.101.96.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B18266B40;
	Mon, 28 Apr 2025 09:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833314; cv=fail; b=V6jK+Y4wwji2DcQx03m4S9RIziAw/T+x4snw90NBzcnRTe+y0s3maPM3vR6t8UFUY13hrHW0Bn/kQ94vhMRZigeWD/+0LMZaQvw4bzMXDeUWhDnsJeJC1R+5ka86t6N6L2s47um8xdpRHGECXpohiJBZ+yFclOb4XfVXWmfZVDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833314; c=relaxed/simple;
	bh=fkBC6NEZ1wrpgHsWQrVDPtwSkT+V7N0YCK54+Vdlfnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eXRLQ04yX2YGgLKj/NbotS1psJnt2arrkJX1uK2uiAUH0OVMN1gjP4T0xj5M92QrNgeL7dJLksiqf69H7iKq0LYLmpwQqgisuUpVf2QBFmDuvnJ24tlTrdZNoHArrYtK3f8l+UI6R9y5GYDi4Ft0HNMDDIlre5GXqQftwGkywtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQeQ2EwD5PZqZy9R1QOMPMLBFU1BdO3c4b9rH2Ix356zxrhiAWXwvluy6NcbqIDK+WI2TIfXuKwrskU2+Fd2a5vTI5dkFBEVtGZQYR4f1WjjJAQDws3v6zlLGBz3CXUrgXBtOWDYlhp3h7ndwnAUNmdE6TBmgHuaJ7HLqXwn29d/jvVY3lq+JEtzvXmyJ97kjPC2eMN+hgLJ/Lh/a9QGJKvZ7nFyGx91XyO6zp2stPGxolldT2qIVRl4wajz7lmtQ0ClHuIn1YoUE8qaXwHY6aZhhjJvq7Jvq4O/3LPHw3GN6CwwGqPZ6abR5eY5+7qcTfF9zgxcmOEVebnsVuxH5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKbp8UjxIdBaF6w3swB9ILb/ng664UfSlDx7Eh8GzdI=;
 b=eyHNuFklNHNyDXfvbwrqeRCOi++Zn9KyMMZNyy63FMLOgoEXOowLTkXAC+qgyXBT8pPQtXfNyXslM7nYhblrWyMxyouKZtBIOZnDfPVIYQMnonWeHuD4dfw0SLjzwTNhMp239yor2/C+RLceIfvJDw5sevzootPjT+x4TsYgrb94TChHpYzEhbR/dCtMaahRyGCSCryinvdywSe7UJhoWojUEAFV2TJznMhlvKC2I6TekvpNhR+wP9kyNE4u9l81C4whsX1riePcXDfDfAZkkh/wQYUCIQ7QFFML6ZVH+CfWUmFJXqAlus+GiN1AhyrDMcTRYrPyq/CTY25naiYDww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO4P123MB6498.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:27c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.18; Mon, 28 Apr
 2025 09:41:46 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%6]) with mapi id 15.20.8699.012; Mon, 28 Apr 2025
 09:41:46 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/1] scsi: mpi3mr: Introduce smp_affinity_enable module parameter
Date: Mon, 28 Apr 2025 10:41:41 +0100
Message-ID: <20250428094141.1385188-2-atomlin@atomlin.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250428094141.1385188-1-atomlin@atomlin.com>
References: <20250428094141.1385188-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0605.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::7) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO4P123MB6498:EE_
X-MS-Office365-Filtering-Correlation-Id: 183e5894-2f34-4fe6-7f72-08dd8638e33e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HQ+Gz92GASiVKdpanpN1dx7T7GF0MndEN8SEAqTr2d1448oX7Us3ZDwSSvBY?=
 =?us-ascii?Q?9ma0GVkasRIqSNpDXwKp5johgVMtElrP8AfUMbH9WEFODl44Pu0rpM6/ouNw?=
 =?us-ascii?Q?k3t2Syhb/XD6jIyl4W9Nq+Ta3S8hlhh7y8gMDJlM6Y2sGWwyKUJbnk0giB44?=
 =?us-ascii?Q?zBgqtEfJJzFyS42Azc353tGTExtWZ/tJPamldABhlOTGw6hb6GRW051n31so?=
 =?us-ascii?Q?kCCT6OmTryXoytgNhPb7XlTv3gn2DMsoE96Pce5MuRE7IScJ3OBC7QI0Wxe/?=
 =?us-ascii?Q?jXOIAVppJCDU7zpmhuM90nY6wln/LlR41FrXCU3YmMmjIo9Gy4OE+65I+DH6?=
 =?us-ascii?Q?UrqV17PuW3Zz2yl2ECJWCJka06wO1e5Xi3lHkoRnNtDRIT0j6t3lmNmZFivT?=
 =?us-ascii?Q?yBV022+h7rxXYpN8NEBFeNOayjZ+k+uNEpcZuBHfB08tQ1Xr6GcNV1L5Oz25?=
 =?us-ascii?Q?CELG/Va0nbxhnzaNJUZH6uDtfFYdqny0KuMDmYWgZtClpD9cUsbNNFi63W2u?=
 =?us-ascii?Q?7HcFcXHQPa5v+LCGnNKUsgjTsRmxUsAXqh8Yo4TBVq8tYbMDfd2w2yHH+/AM?=
 =?us-ascii?Q?EGfQTLgpWshj6vjo4LaYb5qONVoMKQ5yOQUh8rf1dNrJLn/aQvnGijtjf1kQ?=
 =?us-ascii?Q?8rgqCzypWSbi7aof+/WBJJnoUVkAdSRVvE6B9A8oQnJtekUSbsD1X3j6hgIU?=
 =?us-ascii?Q?v+zOd+VIh0grLvrhSCe6HnSKueY3lFmXL8k2zUtAP/uHBkBxK5iXKoDRxr8t?=
 =?us-ascii?Q?CL4Wc3g35KkoU01e7CZrtJxQ0kRyqvF/MQgTzFGuAxSb1omcrJWjh4HKMiLM?=
 =?us-ascii?Q?jKEKgj2pR7n8yPEesAdV+KkklvZmpYKPEwZTjlWlTkqYBo4fvw9LMRNjO1ww?=
 =?us-ascii?Q?L8cshXI4m/z0WFcsV8pr5RpqLeWyDeKWtMK7sakWq4z/8pSFk35iimrNt3zw?=
 =?us-ascii?Q?0jqmj5+42x6E41SdT257TQgAbpFrRtegBZdwSKeZOsOiTmaLw9PCYdYG27HE?=
 =?us-ascii?Q?wh9z1vNT6qHvyWVJkX6yzq8JDfo1D+lyrU9Un1xC48QO2qb3lsPPdTCRN+5T?=
 =?us-ascii?Q?yxPY54kiUeULPEbAXibKss5FnVF8BIUQpZ30d6Bb4ZQda+xSmnksOzmC7fcM?=
 =?us-ascii?Q?Kum0GElE5XiQb+EClzDQvAvNmDzTwFKW8lA9BNDfZ9cY5nxT2EY6MM8rb21r?=
 =?us-ascii?Q?Wd/NhFYAyAUuUL3c8eKsXvOjbcso7GolKuMeS06uj3N7TYdGIeIgDf46kyv/?=
 =?us-ascii?Q?gRgwxzUYb6tNjL+8onijMTnixWLvPlSiS2DOqRRG1zw4dXVbtVgOJ4Va16Rd?=
 =?us-ascii?Q?qU5KXaFInLFBJBeczsTWG9QTDDnA3O26LzEeULZWyVQDkvDoWvmYm09iyr9Z?=
 =?us-ascii?Q?DBtTmXv9FPiSGer8Fr63JFf7fgc86zUmVA4fyIS1HZiJCMJTca/CxP2gLRVx?=
 =?us-ascii?Q?LBBtcxZBOxI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?diQd7PEZBMUqkg4jlVL8HzyFNqJAA2WqHv+K0k+iBaqQQco52berLjPYvbmh?=
 =?us-ascii?Q?QQp+S/i1YImkdM8jF5zWURfsa3FkFIqMz0Psh1Qjc1Jh0kBaBHjS7hwA1tXC?=
 =?us-ascii?Q?zxX5hkokOPKZ+GIhru94PZwdJK85WTdwjm9O8xrbNLQPnYO1gxMaEf2DXL9b?=
 =?us-ascii?Q?B4zkkL68OPqy2uYbWycWy4uI1QR4+RjDTcj8MtJKO1regJpJ1Ksl7Rt5LF8N?=
 =?us-ascii?Q?3K4tPHdDi4CqrgCA45yqJxmz1pTGRDIRYanIpn+A5kPhnYSnvvx1azApDhNr?=
 =?us-ascii?Q?HMMaAjGPytbHhgLYYskCpIur8TVNDSrMP+t3PT8LIEGV1VernyN7DIRKdWH0?=
 =?us-ascii?Q?0X8Yw/1bOCX1mXCsZKMHcMGi5M7Me6ckbuGvPNcLswnXYQwuDKfIhLLnLuqH?=
 =?us-ascii?Q?H/Vb8CYUQK86/kl629gf9MvFhdoPmco5kBeZxgC1U8iXlUL08anG8xluXl9Q?=
 =?us-ascii?Q?qrR3mzrzCLYVxE6Xjf4727n/ooBGy262aE/5rY0PFc+/MF46Q1+v7LlPeJW1?=
 =?us-ascii?Q?S88iv7vmIJhaI+kwrG9kzh+sNT2WORyfs/0Eb6RXppVk/ENW1/n5qx1BGSMa?=
 =?us-ascii?Q?IHuwgCc0bRz8oPqJBsYXTgAlb2vwjakZjpeK1TAB73fWNh9kY1vyiZsL9NcS?=
 =?us-ascii?Q?1EUp7DpG6LxuiWZ2+CxNxw54lUWvx2R+WETqrdJXzFaNvkTrYtmVevbewsM8?=
 =?us-ascii?Q?RfBk7vMKV3LbHdoivC08hvYBfSeonqD1mwC3woNn6qov/KQCwDei4JBS+v20?=
 =?us-ascii?Q?WAwV0oKuixljCy1qdvWw2AxsYqCpxxihaIZ37pngbM0FsFHKs7kEs9x3wFo6?=
 =?us-ascii?Q?f3JWbQ/Bl4q4HnM0hVertjR0j3Jf9C5+zFKuETQQJmtPRKpGWONQuZTPlFbv?=
 =?us-ascii?Q?+94shdvmoaQ7zHkGbfcRBXJKUSig3bxhu5yv6mHL1ysM/lTrriXtp5I889WG?=
 =?us-ascii?Q?5ehEcX223km/8faamLKYHpN07YvubKYq3lpO2h/hBzRllheuO+8acJZE7TLg?=
 =?us-ascii?Q?0p6WStS9Yy/tDZS4oISamcjCeXvWSA4PTxqMUu4Lp1F7y6yWXr0U2nnJm5Ae?=
 =?us-ascii?Q?CUrHfyI/L7knycyScqGNAf12ola3N8bieiHeOSs2+4WZXb6+bEoZUJOx5aP6?=
 =?us-ascii?Q?XSUdOuTNuA6MgxYv4T3kRXQCkswEBr50P9L+EMwm0HoOzAifc7Iawgbfvkpf?=
 =?us-ascii?Q?5DEcGTLNC+LaInpoAV7BRLcGKh+FL6oVjqGMp48BVSIGkaO0VuhhFMVizr8U?=
 =?us-ascii?Q?biVnztHV6Veb6W7/k5Wz4O1/jfxiIZAAZX98DzORhiogulDnovr0yTg+k2No?=
 =?us-ascii?Q?+631lrO4Wn1DWoefIK/VehEgVrqp0EUc9PF0sD/jFWTece+9LRA+2LTdBKt5?=
 =?us-ascii?Q?FdZiUDzhntYK0jE4pF6dfvyfcIwWMloYjUyNbkwdWEPXczWLZeBX0khuIZC7?=
 =?us-ascii?Q?pBk73aZSr76w3PPNICV8WLct5EvljTstDJf+MuVQcHYInIejMOOe34Mh3xtY?=
 =?us-ascii?Q?koyPMpZiSO+3pLGuPX3vJ+/uh9SdZjkiOwQ1s0qEuumzJc34PUZpHnI8jQU7?=
 =?us-ascii?Q?2oOHckydrDjyhQvSJSIrPV/aXC9MGmpF4xNbQSeq?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183e5894-2f34-4fe6-7f72-08dd8638e33e
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 09:41:44.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RREL/5G4bEX+wwkW9pPOk0RQupMY+eN3LiBfdMbN4JSWxVkW4FgfsfCo7/VFjPfEVn1gF7XxjqfTWbrZpdJJ0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P123MB6498

This patch introduces a new module parameter namely
"smp_affinity_enable", to govern the application of system-wide IRQ
affinity (with kernel boot-time parameter "irqaffinity") for MSI-X
interrupts. By default, the default IRQ affinity mask will not be
respected. Set smp_affinity_enable to 0 disables this behaviour.
Consequently, preventing the auto-assignment of MSI-X IRQs.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5ed31fe57474..c1d76431230a 100644
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
@@ -846,7 +850,8 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 
 		desc.post_vectors = mrioc->requested_poll_qcount;
 		min_vec = desc.pre_vectors + desc.post_vectors;
-		irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
+		if (smp_affinity_enable)
+			irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
 
 		retval = pci_alloc_irq_vectors_affinity(mrioc->pdev,
 			min_vec, max_vectors, irq_flags, &desc);
-- 
2.47.1

