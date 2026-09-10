Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021137.outbound.protection.outlook.com [52.101.95.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53646526A9E;
	Thu, 10 Sep 2026 16:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058596; cv=fail; b=XZh4t0yznnF3tdenP7uDYu4E7OJOMs7IKS9OsL3e7wpaB1+ziwZp+aDYBIbP7gOV6Wx0UKJAC4Tb4vz2jJA+GXeRRofR1ARR1yL/ZzYk25m7QdS4qOvordakyePUQVOLH6nqD8sE70AYXTfzMsyE8bukWDAd4pxRg9P7tjPFF+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058596; c=relaxed/simple;
	bh=23w1wp/wNvRNRzfN2IzDye4qVfzzcZMF10+X/ott2D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q6kbyq+ZPKYeU+rmyi444mpzQTnDO98yIhdwqLTIPZV4zbV2Vqw+nwGAfE003JlmxktOq92R2x9PJBMlZNlb8VqPTUthRM16dNYfdlSJOeWbWvlHBDfxKmoLlU8D/1HnDOD1tVNJ2Q7G5lVvsZBh39aIy82MQ+FzGYdK0fqY2sE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HimHwL3qPhhshvAPHkwM5ae8lDoTk26fq1EoDS58nSlZIupEYLZ7EwaP81INjKtY+pnDgqUifAp9An/OvTcXc6ILnjpSYc+PBGHX3KzSD857snIbrhhktH8RCekKc/W+l7Fu/laoswmv2lu5dYy2QY49i7cWIv6pnx6JtxpMr72TPwbA53PjUXji8qzSptex/fE+q66Qsq5syw4RSZ4eCFdUytiuaAO9jNPeXlV7pP3ZHVAdSa8pRBjg3Hs4JMxVwokfoToPf+BX9wqlLrf4dGiPwEWPV3L8ZtkbKpHp7rHrhVZunG3UR7+cUr37g0yjMkS//bI5fJ7Ms6uTlZeXQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=RmBNUls/CiACZyooS549az+Rk/13iTC6hCs2eUO3F6g=;
 b=FnozJPjaFbwR7bbAn64iEvnobj3r3XoOHMiHWEc8QAY20YwKwbKYtD2jYRYW629488WAVEibxKEQF2z5QO9CZRbEBpnX3yjTum6E+IZ4sy28sSP3sIj5u11xHotQcqCOlriG713VslHzQ7dNDTP3Da9UUSvO98MzrMovoXuVM517/viGppKavbfEa8DG2B1w4b6SkaXIkiomzgVgyLFc7n3308k6RLScTiiRZLmki8FHx39Q0SfKHS9/XLjdj5RMVvRMfYDuOKVUFev2cbf+VOvj6TXoBkqGCEzwumA2+BIN2/vy6OcIuzhC8bFIM4cqjgQkNYPIbBKaQUa6fYLqkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CWLP123MB4179.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:43:08 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:43:08 +0000
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
Subject: [PATCH v16 5/9] isolation: Introduce managed_irq_strict isolcpus type
Date: Thu, 10 Sep 2026 12:42:33 -0400
Message-ID: <20260910164237.500196-6-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0887.namprd03.prod.outlook.com
 (2603:10b6:408:13c::22) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CWLP123MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: cb32cc82-6055-477a-f199-08df0f5a97b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|10067099003|56012099006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gcn3nHTjtBFqDWX6EXhmexWmurqeY0jizGSEZOiqQiRGFhL6pAwNs2drhCcdOYYSgoQb9sZ+cpAMbSRFdZJT6kBfAYeGe1prPnfS+2IgQWWTscY7qkBCVuyaTyxyI0ibaeQjOTf2ZGnpnipb/wqAXsJkmBuMmj4fpMfOSCOvrAMzFhbXZabRpKFOMybfV2GBrjfborIqd3qnLw1CtKt6oHbKHO2mzFg8dZxZXcYmV4HMc8NC8iUIqwdeVq93qwkP/B3xnPweSM6IrbCuaqxTawpw0sl97EfuwkX30iB2b0i3DqkuYWt1Z1pahr8dRiW8uMayd5Pq3TTTnXU0Yzc8FbVRBNj7qr3Iy3UpLRzt4GfJA3kejwi5D29Zk/zI2F5Qz7AySqV3Ca32TFdbjBadBbLPgkrY1yUdVQnK6fEUn7SaiuMErO2DH3pWEGAC9Un7BuMlVRsBpd27Ug4d51griBHTA/sODlzJaFOa/1fvCle5+1I5ug67h6UrWiCC5EBKFqzMZalP03IKxgVvwQ67/ArIVAIKq5eC1tKphEkPQ6kW677f9hhj+CKsAF8HlJVcSBxxot3qNmN4fpaTvJ/1rmCxbl025l8eI2DTsxgvNHuopGRnuagM93aFIjN5mXifet2H8hFUhwzpR4Jqg+V/Xlxu2dNJlUkfrrWyp9utLbA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(10067099003)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KwqsfRuV8IYtndOtU+YsGjuGgfAVrR77M2shqGxcfXfbxT3JCO4W6wRkFTjx?=
 =?us-ascii?Q?XLCs3EZivKarAAjRYk1DEtAK/445+OetoXgnB0Neo+u0/4lY+GPAObM85uVS?=
 =?us-ascii?Q?YU/wvxSqdMrKTLZI07gt6M82O2OXzLT8SELMDtDRKZI7srErBSnug1NeS1P/?=
 =?us-ascii?Q?cC4y5xCT63bjmWeFTTfXrLv7+kV0/hwUAjg4SsusjS/bWvowRfVgE4QMK5b/?=
 =?us-ascii?Q?vMO+rWwnaL3eM8Giho4ewgVRiQJ4EYFgg759hKmweVs2U4RYdvCNvP3fdGg+?=
 =?us-ascii?Q?qCJENxh3eRa7Lh9aI9kSHhuD79azxitz3h6nHT0H2UWJ84WNJzpWjHbz+2S4?=
 =?us-ascii?Q?MqONX7NlYzpj9BOsCwLS9AqFX+zHpP5yHtaGyGO/Zmg5FLU5rSp1abtofyti?=
 =?us-ascii?Q?xK2DJm9wUsYzynZolUz3IR3U2VkB/QvW99KibjougXxhQp3fNVevjTl7hxw2?=
 =?us-ascii?Q?j72nAazQQ4GMVoXQXYC80iV/YvtFLJiZrIyVX7KY+gWpq6bgZSk2ZV0Sui1r?=
 =?us-ascii?Q?EhJ6rBW+DSMLUZLw8iIMma//ghD6s4Se6L42LQvvOZ6yLZk4iEbe5HZO1SxG?=
 =?us-ascii?Q?zp7+gh8Eqpp4JyneoVWqwcCHZmbB2uxc/ZTmiXxjeEFAfFpXv1j386+tG47J?=
 =?us-ascii?Q?ILtySnZj6bDtQKvN+RytmMztUirwDmRbPcYQ8NIJIAy61NvRsbViB4rCCDgw?=
 =?us-ascii?Q?uB4i8aCYB9VOEaVUWwTpoPhRWN4+ZNT0cRKUHIhT39GGjGdtOIj5l55k1ngJ?=
 =?us-ascii?Q?X3/Glgtch26/gSjUOctTqW3E9SsLRy/HFi8HVpbHV9zom3jjEPxv+rYbpZYQ?=
 =?us-ascii?Q?pQQdNdpzzhuG6+WN+8BARCW9rSYnq4gt2r8r6TX5abvJT5CtOIalsNpPeLOg?=
 =?us-ascii?Q?DaNhhRgf1ZU/LOAWS6bywPROEziq3qAIjZhHJwBgR/5PU61FPC6mZ1KS/eQr?=
 =?us-ascii?Q?GyEnRAb7yJr3jkW2NwU33Y9GAXyZh2Q5huGRS8AwLqggjq5XSGUJA9F05NVC?=
 =?us-ascii?Q?HYSbuHzrfjFPkxo0Pk0TlHw2z8/ao+lZGhDoeHCfOIik41RYeTFFfLdkCYdw?=
 =?us-ascii?Q?PSXZo8r18/OKYhYGtGbAuDAbFRWC+rfD+2Gn+DQL65kJZZp9AHamFa1DXc/T?=
 =?us-ascii?Q?1WL4FCZNt4wfk2SET07L1SrwTVN55az62y0yC70IblKpmcMTluGP1ydzz4qa?=
 =?us-ascii?Q?06jiGWahONtSLTF8AONZTSnxyoswmOjQYkwYWgFw7VnB9a4Qmr261kdJqt+8?=
 =?us-ascii?Q?341hCb8BvnbsclOm5f5f6EMNOdfEj8T6GFJN+HUISyBcZXo7WGKFEWG9rsvO?=
 =?us-ascii?Q?UqhyxJvKaEFTQJQ0vJ3OMFPbwub/G/Y4pOWGKb3VoB6X+qJoamiqj2qG5S1O?=
 =?us-ascii?Q?TwaciMhTkbM8eSoBf58R69xCMXo080PFzfMK8JMnw4xc46TVruBbgNkg4cla?=
 =?us-ascii?Q?evGR9j4QohXDcC4Mi+pwjlcg3YBvAKpiX/ffxv91ZSqHWO3syE2ONRNRK9uO?=
 =?us-ascii?Q?v52t1ItprRXED6wO1IL8fRm9PkES15MDH445cind8zNSfORhJQzD557UUZYq?=
 =?us-ascii?Q?YVjcLFqXSCv1oyL2/FW0h693+PWEEEfWjII/e0DPG/zelutVHFQRH6jlG5nN?=
 =?us-ascii?Q?lzInOAMaYSfEWU0ujnOPsRyvjgrgxDEKWFTSRaLVHYaDNNQynGoxHp1gItzb?=
 =?us-ascii?Q?RBUcqhb2CHG7GA5qIr7uF3bvdX1LuYnvf/8m2qki5ESl8qtNaHUHJ1smQce+?=
 =?us-ascii?Q?uXEIlfogEQ=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb32cc82-6055-477a-f199-08df0f5a97b1
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:43:07.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KBKU4abmUDNxVTs+FiOnIyzXxk9Uxw7moStFwXb93WYeKWzgvpft5X7x1MYGi986XpZP56MhlQ7vRVqQvVyIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB4179

From: Daniel Wagner <wagi@kernel.org>

Multiqueue drivers spread I/O queues and managed interrupts across all
CPUs for optimal performance. However, these drivers are not aware of
CPU isolation requirements and will distribute queues and interrupt
vectors without considering the isolcpus configuration.

The existing isolcpus=managed_irq parameter attempts post-allocation
affinity steering, but this is best-effort and fails on modern multiqueue
storage where the number of queues meets or exceeds the CPU count.

Introduce a new isolcpus flag, "managed_irq_strict", that allows users
to strictly define which CPUs should have multiqueue hardware queues
and managed interrupts assigned. This enforces pre-allocation queue
bounding and mask exclusion, preventing managed hardware interrupts
from ever targeting isolated cores.

Because managed_irq_strict is a strict superset of managed_irq, specifying
managed_irq_strict automatically enables HK_FLAG_MANAGED_IRQ as well. This
ensures subsystems that rely on managed interrupt isolation (e.g. Hyper-V
VMBus channel distribution) continue to function seamlessly.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 include/linux/sched/isolation.h |  1 +
 kernel/sched/isolation.c        | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cf0fd03dd7a2..bda3003ce86f 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -18,6 +18,7 @@ enum hk_type {
 	HK_TYPE_MANAGED_IRQ,
 	/* Inverse of boot-time nohz_full= or isolcpus=nohz arguments */
 	HK_TYPE_KERNEL_NOISE,
+	HK_TYPE_MANAGED_IRQ_STRICT,
 	HK_TYPE_MAX,
 
 	/*
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 9f02e9264a3f..7e9e78a18fb9 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -17,6 +17,7 @@ enum hk_flags {
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
+	HK_FLAG_MANAGED_IRQ_STRICT = BIT(HK_TYPE_MANAGED_IRQ_STRICT),
 };
 
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
@@ -354,6 +355,12 @@ static int __init housekeeping_isolcpus_setup(char *str)
 			continue;
 		}
 
+		if (!strncmp(str, "managed_irq_strict,", 19)) {
+			str += 19;
+			flags |= HK_FLAG_MANAGED_IRQ_STRICT;
+			continue;
+		}
+
 		/*
 		 * Skip unknown sub-parameter and validate that it is not
 		 * containing an invalid character.
@@ -374,6 +381,15 @@ static int __init housekeeping_isolcpus_setup(char *str)
 		str++;
 	}
 
+	/*
+	 * managed_irq_strict is a strict superset of managed_irq.
+	 * Ensure that HK_FLAG_MANAGED_IRQ is also set so that subsystems
+	 * relying on managed interrupt isolation (e.g. Hyper-V VMBus channel
+	 * distribution and CPU hotplug IRQ restoration) continue to function.
+	 */
+	if (flags & HK_FLAG_MANAGED_IRQ_STRICT)
+		flags |= HK_FLAG_MANAGED_IRQ;
+
 	/* Default behaviour for isolcpus without flags */
 	if (!flags)
 		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
-- 
2.55.0

