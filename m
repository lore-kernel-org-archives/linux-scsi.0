Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021137.outbound.protection.outlook.com [52.101.95.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FE0530E1D;
	Thu, 10 Sep 2026 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058602; cv=fail; b=RmToLlpzD4z12TGMJQbPMQTg/aMytZlzGLnqyvVR+0tpCDFOLfJcTgrPFZzm2Mv2tsu3IBhv6wF0dUQw2g4G3F9hiyYNgm/DRC5dW1xQNAvDJ/l9qBl0yn4iPwGE7I50aKdbdnO1r+OkSuwd9nfpEGjNBx9VVgvHoUsY151/aFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058602; c=relaxed/simple;
	bh=Gk++3dQUXdKQUgDUNVAHk/X3pOJjujHKRnnuv5wK8b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JOdh9S/OPPJ2PXeZmhqC5tHJ4sXYC1oHN5UaqKX8C9BqJjxxVcq+DrEKvonoSPFpXwdM6z0CBdxWGGsP1n7l9Q3H8dI5shg8H/pUl/nXfvm8pJhgP6gqePPJYCe87TgMVW1zjhkdpmtkZsVW4Mg7DZyPUMe0CLKjqoebE5TJ3Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lvjXtJ0Zse/+FBPKCraYs5/f529VMcLN04fQ8yk4/QWVwuN6IWFMi3jJNsQmJkd+Jh6MMS96ZodKNfXuFW/lBFas49IglUfyNmIRM6PXCqrOmpCxau8Akz6dUaRgooYim5Kea5K5dmMnj0QMyHIuK1QKsC66VPjD3u1Z7QtsMlTXKentJwIGxOBljVNzdngo12yHVR96zY6wC4qE2ObjHoGQxD/8d491Zj0XtdghcZNqGmwYGGqG0k79sk8VxgElLhsGPOzZp3wx5oGZCEKotwf8XjlRhlCzCcgdQDpD3Ane26wOireTkS2wpt28vEXjJRxPb/gaco9mUEwQhPMSbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=9GjZQH5vT5gHOMuVw9IDOQFTTmUg1dJ++I6PH1v/zQ4=;
 b=fJYFta6JMRPtnbsFWHCJoPjzk2v38ylzVT0Ds/7di28TsOaPy1b9tSQtijOOh19XBi+Wtiusq/SbsiwOjnkz+JKdWqJRFmmNDWZS2bxP1AWfAYkXVO8iEQlZRoD88Ri15uQIgDATnufms14rL0/lWqYln4e0ruUbm0WkRaLTDVXDlzCn12uo0Ev0Bcjr2ndIHw8VFIfYdSZQtL4+cXBlU1apcrbCl5B7h4WEOhRAMcJe5DvZRu5lCD1qi7M6CzbDR5jxrHP3k3IG8Ae1DRhSMuR87I4HB96LeJ58RMP7Gn16D3SLg9VnmWt1UIbugt8+JIu9T9iwdsHimp+DL/bKLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CWLP123MB4179.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:43:16 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:43:16 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	tglx@kernel.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	frederic@kernel.org,
	bigeasy@linutronix.de
Cc: atomlin@atomlin.com,
	ionut.nechita@windriver.com,
	corbet@lwn.net,
	vincent.guittot@linaro.org,
	mingo@redhat.com,
	peterz@infradead.org,
	radu@rendec.net,
	akpm@linux-foundation.org,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	marco.crivellari@suse.com,
	rishil1999@outlook.com,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 7/9] blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
Date: Thu, 10 Sep 2026 12:42:35 -0400
Message-ID: <20260910164237.500196-8-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0522.namprd03.prod.outlook.com
 (2603:10b6:408:131::17) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CWLP123MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: 85a665ce-ad7a-462b-b368-08df0f5a9c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5jrxTrN0zPAe/sWQO+Qo0DujsDTu7AktUgPbb83CvyCFcxWqt7BH+MlbL5smlzJD4wrj+DoywSw+Zetu+SyttvyLW3evATxzB+pIQon/XrE70Mu/wUSBbGlu5cS6qplUBBZ+42KwOe69zp+kL8XF62IJN0/HnCLbT3lHKK0unSl2daM3psZ/brXdRsbBLoz9xaWcF4AGMrWObdCb7yOgP0wzrKEmxLq+tYFDTaXwpvroDFW33iC34Tn5JScHVJGBygt/olYQFmmnXJW2QVNpFKZTPlbAi5KCJJoaQYDoGQyE9vm97VdgnA5r2LNLZW2yipJo+2ASmm0ceKHHjwZKNlZXcFU4cqcRig2pvMFDg2o8SaG1oDJ6z4uFRkKzL72dw0D/DSywi3MkTq6D1n1Vpj2lXWplwMmZcTIIgjBmxMxSf1Si8pWVjIXvZkIntEA0W363HShPDdP7HXOQO6+Oyhz78nrw8w8AVc3UbeJXz3mGaLQJ6j19kbc2dxl/70qzmNzKszmTKBTeE+sWBNWDymoUZq9GBU6YvthQ4ATRMP/Ctz45jrFHcmgs56Xc9iO4PozJlVTOMwelkrC5e1bsmq89+zXSi0RF//Gn9M2e60XSvAkWBRwqa84q7nBmwAhAn+EqY68QznWsMrehNrDZPadn2apGN96KN8UYWmY5WAE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r0PB0fMWmU5imxkUEs9laNh07gEHscsKbsbqQICJ8w2Ety7eM+RmMTTnR2GL?=
 =?us-ascii?Q?vWbbs2usOQBve4Gm4A4StOZoOy9PZZqiLxSbhAde8DHjiiS3+SwGaBBg/8Se?=
 =?us-ascii?Q?0jweDAoJrRY4xEkRBh0aIy/DRWAgDKEne3HCZae6pb0jEx9ugL8z/qMuUQHR?=
 =?us-ascii?Q?l5Uf4BPh7w211DSV3Q4nJ20Aj7PQj+tZjgjQSLoDbHNji484DWVoXFDdp/xo?=
 =?us-ascii?Q?o+0g1k7wfGF5r4IDAIxafKJF4haiHHVRjD/IuwZMQUZX6CrEmbG7oqYsh5Rs?=
 =?us-ascii?Q?APnYarJeHw5zM2yzI2V+mWygJdz8lfaMRHdNHU14gYGHQUMhx1b7iievPeoM?=
 =?us-ascii?Q?ewl9otIk79I9/E0diFQFAaxdsbdy8NqTmhIzvU8XUv6GEnFWukCRbb22BPnd?=
 =?us-ascii?Q?xT7ba6j5YZAxKZydq/I44g+ABkxSClrVJCZr6+VBfgYMbqHIGSeAvMl5y1eD?=
 =?us-ascii?Q?kiCWvOu6Y91iXxFyva0mpTmkxGtYRh98nyt3sGvw0gfXS1D9QQE060b2k+Mn?=
 =?us-ascii?Q?PpzGNjnrMHJuHAOR9DeKrywrDkecVxQLz2G9f47zS6NtJkNJ4JcObYOCYLdY?=
 =?us-ascii?Q?/No/WiBLNWT1ksmBDc3PQd4xEjdpySaPu72O/kgKarwCdHR2gsLgFoh/1UGS?=
 =?us-ascii?Q?8YN9XL+7zfGE0wo223V2MpcNa3coxLuyqtKPnhD29FbWLZkDobhWPWGMiy4q?=
 =?us-ascii?Q?eNXv02L35lIfKJlgyjs+wDTB1y5ZZiOYXdjVTSCTDq6YhYqxFIGWC5MMFyzC?=
 =?us-ascii?Q?OZ+sxEPyG3rak+w0OrBdOZxDqYC5lIA9erItPdYfdROL3RveGC+aKQ2Qsy8Z?=
 =?us-ascii?Q?dpg9TBjuTj4k3RCoBNnuHofGjhbN3cOGKeOR0pMb2BsZTnfu8hm4CyUp9wJe?=
 =?us-ascii?Q?jgqDZsNaBuHadvU18TGPCCxUjGIb2zXYcYRzOhk5C79Z+PP29JBh9RTHHKsf?=
 =?us-ascii?Q?b/6E95nKghkQ9S4agFWLAJGBSuKzf9JUt+3mIPsf532yg2/avg1ivI5WY0eq?=
 =?us-ascii?Q?aB3aUc/2EyGJ8iiLDDeMCyz9yNsuHSyCHZ410wxzNdNQhgEtmz9gJj+8W2Av?=
 =?us-ascii?Q?AUJBjLvOGeiVXWvYsZHN7+sCbnQtBUCCXExHyFCug6jV/wAxvlUHa4Thb7jU?=
 =?us-ascii?Q?avODAj3DPHwDzldtUMTMOWascmTOMn12hGQVHkNCiajjs0OcGjoBGtbEXIbB?=
 =?us-ascii?Q?PoQ5mQF+ZFPEYblr+inzgaSUMeqe1HRcaLSD6DORvyh/PomynHeu8gfDOizd?=
 =?us-ascii?Q?lxC6gJo6+5jazpvSeM0pOYttLAmqWnmtCl3qie0DRWDonwm5gKWHKaAJXSkf?=
 =?us-ascii?Q?qGXgtKMiherE4Eg9UTG/u1IoZR3dX4Wu/LYoyqO9u7MpMMH1RBw5W613hg2D?=
 =?us-ascii?Q?oaZkqy6vTDIGipB880bWlQbw1oleTrRv5eu0AymJizYLV0vxajKCJTq2boko?=
 =?us-ascii?Q?Ao57AiuZ2D1XgwYrRJDRWnsJZ8GCVBAz4WEGg9C5GrUZGv3bRog6FCuUZP0a?=
 =?us-ascii?Q?cLdtgvflEZUNDXzFJVHFCg5jTVKhbE33C6nAOclP+30UqYv+UADdxKjUAWJ5?=
 =?us-ascii?Q?I0IFxj28PXmNhPuSt70ehJqnhJGR7iCHZBjy6q0PdqG/j3bMnc60plMN7AbD?=
 =?us-ascii?Q?R0fe9poEHC/7Pt5NvHmh+8qX0aTTa9E5+swcp9vbuHNnOcEx+iTOiUTRZaZ/?=
 =?us-ascii?Q?y98Sl8CvDHKFzzJEUgieziU+UEeisD6WrwYOGaB646ks2FWKq4EjtHBUB03W?=
 =?us-ascii?Q?/acDnY2CuA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a665ce-ad7a-462b-b368-08df0f5a9c92
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:43:15.9897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7pjks0tO8kvCiUvUIV1+4+P/IM4qehYEo1jc0gen9+NEB4GcFR3ZEnYrGxokdI716JRVsifEpiOUM5g+UBCcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB4179

From: Daniel Wagner <wagi@kernel.org>

When isolcpus=managed_irq_strict is enabled and the last housekeeping CPU
for a given hctx goes offline, no CPU would be left to handle I/O.
To prevent I/O stalls, disallow offlining housekeeping CPUs that are
still serving isolated CPUs.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Co-developed-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a26a11c73ee3..6e903e1310e9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3690,6 +3690,64 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 	return data.has_rq;
 }
 
+static bool blk_mq_hctx_can_offline_hk_cpu(struct blk_mq_hw_ctx *hctx,
+					   unsigned int this_cpu)
+{
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT);
+	int cpu, fallback_isolated_cpu = -1;
+
+	/*
+	 * During system suspend or hibernation, tasks are frozen and all
+	 * CPUs are being taken offline. Allow offlining to proceed so
+	 * suspend is not aborted.
+	 */
+	if (cpuhp_tasks_frozen)
+		return true;
+
+	/*
+	 * If the CPU being offlined is not a housekeeping CPU,
+	 * offlining it will not strand isolated CPUs. Allow it.
+	 */
+	if (!cpumask_test_cpu(this_cpu, hk_mask))
+		return true;
+	/*
+	 * If this CPU is not mapped to this specific hardware context,
+	 * offlining it will not affect the context's I/O routing. Allow it.
+	 */
+	if (blk_mq_map_queue_type(hctx->queue, hctx->type, this_cpu) != hctx)
+		return true;
+	/*
+	 * Iterate over all online CPUs and manually check their mapping.
+	 * We cannot use hctx->cpumask here because blk_mq_map_swqueue()
+	 * intentionally strips isolated CPUs from it to prevent kworker
+	 * routing.
+	 */
+	for_each_online_cpu(cpu) {
+		struct blk_mq_hw_ctx *h;
+
+		if (cpu == this_cpu)
+			continue;
+
+		h = blk_mq_map_queue_type(hctx->queue, hctx->type, cpu);
+		if (h != hctx)
+			continue;
+
+		if (cpumask_test_cpu(cpu, hk_mask))
+			return true;
+
+		if (fallback_isolated_cpu == -1)
+			fallback_isolated_cpu = cpu;
+	}
+
+	if (fallback_isolated_cpu != -1) {
+		pr_warn("blk-mq: cannot offline CPU %u: online isolated CPU %d is still mapped to hctx%u\n",
+			this_cpu, fallback_isolated_cpu, hctx->queue_num);
+		return false;
+	}
+
+	return true;
+}
+
 static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
 		unsigned int this_cpu)
 {
@@ -3722,6 +3780,11 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 	int ret = 0;
 
+	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ_STRICT)) {
+		if (!blk_mq_hctx_can_offline_hk_cpu(hctx, cpu))
+			return -EINVAL;
+	}
+
 	if (!hctx->nr_ctx || blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 
-- 
2.55.0

