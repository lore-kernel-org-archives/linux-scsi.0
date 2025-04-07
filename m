Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sg2apc01on2064.outbound.protection.outlook.com [40.107.215.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FF63C0B;
	Mon,  7 Apr 2025 09:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744016978; cv=fail; b=X5hV5aGtrxh7WYuVLWJ9FE+I4rfJUKzwCIHp7EMYshvJoSaUOOgAGBDR1IHeSxitnpPilo0Mda7CJwaI54jbRkYJ3rHFc/Bj6Gtvcjseu8q2AnkOkOkxNodVQ9xfBQ4qSjtA4kGZcP3nZ+JGzKEECJhWnus3j6a0Lot4a55iZjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744016978; c=relaxed/simple;
	bh=OYSKKx2iB8zodye6QWp9MbzPqogcBsJVHKl07+HhGn4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=UMmBPWH/E6wyexAi0kyE6bAIiDgShyLlZcj61YYjT761+MKq1Rt+vqh9VG9GR2b8oGnUDcGbK9iQsl+V+/IYcMEjSG8L4d0FuXQuGCuUFjmocPZZr4ImYHxZID5l4dQSSkyRFvFCtVgVWbSpRKeai4e2FJvFlYB4HvbkumnP7pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=cn1blXIX; arc=fail smtp.client-ip=40.107.215.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="cn1blXIX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PfDBaltGzVhh1m7EhH7LorRh6a0ymIan+VjP0FCeuA0z8qBrVnaWuQoJeqtdN9nqoF0NDZTPz1fhCXAvyjN+ZA8Lc+MlZcBQa7MOfB3dmYPCcFRZqzfWvHoCL8qbW95HTg+aQVUnZkxz5lg41kN0GQBePu8qZaMtGx6oU0bFgvLiimWfjyxj4Sx0JJ1P0Jt606USieA1nu5FWknEL2jsNBgWuDyLax+7K+vNXluLvdKCauuDjjfIgi/ykgb4b4HdHSgAJ6xSvznJxnLuyGKlPBxVXCeVLPPvJDe9k6/rQ+cOhVqchSeQM9qKZJ8jwIk/QClL7qgb7UBxqzj+c8U/5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mh/S+EgnA+io9ZOEem35HLFBJlEAXdrkE5Tcw/X0GhM=;
 b=Qx2l3GIPsu6ZnN17zB8jw+W6CagtZX4R6YKoaBmfbzQH8Ecq+lrnKMAbDX+FmX0qsODlhq6m2wOyKwV1Ze4ldy7fO7WGeOIMlc1TZ+K/PdhW7xnwPc3Nehifj/vkPFZfhja/X+BThXilZRVAwr/Akdx2+r4IFdULbrIx131nYHNBGGc8cZP6gdXk3xaRmCPgIzRPNLdWaOTf/sWSne9zM+CAtQXIvm8NWqF9i31OX6JzNaPKTiGm78GKf5nzD9XQ8zEr1xAgmDcdmNRjScJ4DoNdkU3gY3hNsLq9Ka0I81MqMTEEdIw8JwUVT7zvfnHzbhWI+oIxBy8QJFQTMqHVdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mh/S+EgnA+io9ZOEem35HLFBJlEAXdrkE5Tcw/X0GhM=;
 b=cn1blXIXDgU5tmzNbjhcwuPhlxNQE/W2/5dWzpMJx4f6LJGeAk1fN5zqk8JaiFAc6cr9b3+EvYimW/cgFVvuifkU8NSbNpp98kpIaixjUHeVcFmPcIt20eCMM7LrJtx3W/I4TRH4FdUTRabFECmlW9L5gZpcqQZAP2AUss9jnUOSKW2Jm8NI1+IznDUcxv9x74R1zek8uHu5UKdszjIngSc2jHpmT2+l9gqRBrRA9GeX1b8jbAOfR76ksF8kgKjrjYwESTxXAhBQqRTtWFzVt9XGPJnH64i5sgk9ouyjD6q/6oPJ+VwQV14+03lwyYbUPu8C/W0azUk0O89sftVjGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYZPR06MB6468.apcprd06.prod.outlook.com (2603:1096:400:459::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.45; Mon, 7 Apr
 2025 09:09:30 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8583.047; Mon, 7 Apr 2025
 09:09:30 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	beanhuo@micron.com,
	luhongfei@vivo.com,
	quic_cang@quicinc.com,
	keosung.park@samsung.com,
	viro@zeniv.linux.org.uk,
	quic_mnaresh@quicinc.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	quic_nguyenb@quicinc.com,
	linux@weissschuh.net,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: [PATCH v10] ufs: core: Add WB buffer resize support
Date: Mon,  7 Apr 2025 17:09:20 +0800
Message-Id: <20250407090920.431-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYZPR06MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: 176d6fde-86f2-4fd2-af94-08dd75b3e7b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|7416014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0K8fmT+eiFJIsIuNuuavvYPBYmSahWpxp+aC9RCUEtapZcBv3c8pr8TiGcFD?=
 =?us-ascii?Q?BQfvYRvPnXLiq69JrbyAjRuO2OjYbSzsBo1Xe9G5xm/MohcNYEiKtCLl9F0c?=
 =?us-ascii?Q?qsHdOuWjKl3SFBEHLTAP4yTFf022NpaNpabua70l0OlMgfhesUIzMOI4HTQm?=
 =?us-ascii?Q?lNxRpgQmZhObKZ+lqkrUkVhy2kkD0IY8plcyK4LGJsFd6CkjwyenMEta7JaF?=
 =?us-ascii?Q?FZShkUiebwYdZrR+c+bME9AiqgZjoJnJtqaJip/uCbMhdf5T2HH80+4lVCU+?=
 =?us-ascii?Q?2wusPPAWhAmygk3uWm6v+afDrN3DflLk8n43yUaLn0dQ1uc1qLMzYEz+5BlL?=
 =?us-ascii?Q?+D9J4PTi/wsFt7xJl9KNQcYeLgWHDt5lvqwur/nHj4zkU7KDpTALrjo4wdTY?=
 =?us-ascii?Q?vKcsd4HGIVHdl7tFIpALwCJCOVz17Oblsb7jBjtFlKIzrVJFW41XtPso+A7R?=
 =?us-ascii?Q?dSzgutFrRDxRhinMmAxRHmngd11IWGhIm5x9p3GmxPhzlgQIaC/8YqS5i0LQ?=
 =?us-ascii?Q?2hGjhchorenBhRmWxFP5EhCtsH8/8CNyk14gsn3p1O9Mn2JOZxjccaklgCz0?=
 =?us-ascii?Q?hVWOTti9sPm4TKLEUz/oxIqK8cqvCU1B5+gaRk0JZ1gttC6/M/84WDMo6GhQ?=
 =?us-ascii?Q?PdEPQ95hoJWFmMcbi21VXmejaFop+iR8RE+w7wqfZaKnrVc2sDFfMRd+R/Nl?=
 =?us-ascii?Q?5BmCH0djW7QEgOFTOHkFajEIVQjlPxr7q3CM2T+ufyH+2Vd4PjIq8NjCUZ0w?=
 =?us-ascii?Q?AKQRT7WA6SEBZUESkF7iBBzfQw8nX0CttCyfrmcpT4slR7l0m23GLta2Oxl+?=
 =?us-ascii?Q?WhCVrwcJlE5NdGCIOAQ9h/I0/g7A+ANwd27WIe6g8CGXc5GjWEXxnnllpfjv?=
 =?us-ascii?Q?Wg/tM5L/otopzcWBG9iqQDNwVlqMDX9Fh0cq2oal94WbeaoFUO9nOIgzfjtn?=
 =?us-ascii?Q?w5lcAjshhyDFY/0X0925FSY43+9Jy7DtuNkdkZdPeqafw0Dq65ETTAVmotw5?=
 =?us-ascii?Q?sjB4SMmyyimzt6NrkVsypLIaeIUEnnq2/IpIjsBwbN6DwPsIzge0KAkyPktb?=
 =?us-ascii?Q?y3r6LV+sgPpyuxEBU8y5E9xy9kmFY3YeUGtEHF0gMpN+bNGOkY2tVzX+Fg0l?=
 =?us-ascii?Q?V73W3ZN/Ib0JXE6zKRuxKqLOEttWYCvXQ5IWkxIpZsWVq8uetJ4IiaApA+UW?=
 =?us-ascii?Q?kOeRJQjV1E5VO8TTkKXvr0TBS62S+wAOz+oJORv6stPjr8Ta0puICxG9NqDa?=
 =?us-ascii?Q?yk6bLzNO+r6GKh8+gYU+d9wX/GOHPNCUAAi5pDAUbFZTbCiYhmYQPZ3IC4zn?=
 =?us-ascii?Q?D1BIpZUeAflTz3bQGopOeTmOIMPEplNuXSlaQzYFVnZAzEQG6fxh+85/fYj4?=
 =?us-ascii?Q?YROkBy948Tp4dJbCb3Jl+QgPWT6JJA7Pm3bRmWN79uYjlVp3lbws3EkDUynh?=
 =?us-ascii?Q?sZwaf4rii6sAxkrUIvWhLsmj7wkeO9tmwzSLuzZQluWz2lag29m0jw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(7416014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kzgxuMLTjEcH/6Cfo38x6EF467TgbB3AL2AtKnk6dD9zh+NqQoAmd4+sPg5/?=
 =?us-ascii?Q?podYtxHA8p5bKKphM/NkGjSmJxKG+y416NaojlMx/HKKCP3FHWNbRQrhxTvq?=
 =?us-ascii?Q?agnBkF9mrkf+vBiHtDKVxV6We63NlbpApkyJTXE9UZ8XBGngT6CfWhW8K5Qu?=
 =?us-ascii?Q?j9Ao2gtgM1T1e9S8Jut1ktDMi4IKgFdtFvntEYq7stY5LSh6ad57uBBelikd?=
 =?us-ascii?Q?LQsAtFIrNSZO41d3B0VmJl6A+05MO+zHSN2ZcG4A2j1LwZlprg/54QpYiQmz?=
 =?us-ascii?Q?xX/oY60K3n3cdUwsUBMN/4jSGq1Mer77kCnmrm+ggANz44m/vNkZkCBbp8Ld?=
 =?us-ascii?Q?Ud8Ko9geEEQaSmmAXtgSOCPiZ6wg4a7xEjUBXK4W0k3j+52Jl6ylE3Ju35PE?=
 =?us-ascii?Q?xoDyvXD+v3kmmkPlRqp/gzeG37cbQaQF3Aji040+YN1UIxl7d8NPP50Q8WUe?=
 =?us-ascii?Q?kKBnuolLDduV0oyDn6YIdpBdE484SoG5/xxN0+5TuvhMiey58ofVrJ8wLlVh?=
 =?us-ascii?Q?vJx6mK0MogXSvjuuUezVWN1kULf1QaWEC3mWFTmb6QNTALOjoZexFgcCvrPz?=
 =?us-ascii?Q?smAcmsEHqUbtv3Sxdt6H6lxqk1medQYr6n7YRJsCxUvYObYYoaHm8/3Vr3wz?=
 =?us-ascii?Q?nqFMHcjQWn+z+YpU/Zv9f3UsiLlMkz7vfqb5cSWxlXkI3ku9AGuIDg6FjBAU?=
 =?us-ascii?Q?MXW3aiD6GlnqaV8oxIkGkkKVTmX1b5q70d8SbvVPO+WL02rn7CH1ZBziG4X1?=
 =?us-ascii?Q?UmENgsiSJKr+/nBWJcN9ZXDyujC+1yg6BX/wb2EOP/mnOYNJzqyxF27hC4ux?=
 =?us-ascii?Q?XoeAh8m9MHpM4zS4M5gQoLJP5CVzgs3G4IGJZO0g4+LE2WX4jFdwg58JdoQi?=
 =?us-ascii?Q?VSovcNyFjkTbiLuFDGZ3g7Mqh/slw+U/HRaroidkqH3nH4hfwyCS+65fXwd8?=
 =?us-ascii?Q?8+cRki+uvmvsUGukKly7c6qvbE8AdTw993bh/qitSGuyW+58g/SwrUQP15lZ?=
 =?us-ascii?Q?eyGIStbBr3O84vbCY7apNj5joL0zOh/G9DlbCgIskSqyBqBwd5pMHxhXSf0s?=
 =?us-ascii?Q?3QY+LJPWlunLC7UMETqAXeJLn/R+nwnP1jVj8/xrLiDOxfvW25kiDkeSSL8j?=
 =?us-ascii?Q?H2K4ALeepdGD0dv4KPrXaeBcGDL0ZUw/bKwlBoeFEW3oK+din/DUY2IPWOH8?=
 =?us-ascii?Q?RGYweQRwhdVytuUGSZF67b1crmQcOC0aGt8D9TahiOH9drECk2S0lg+lbRZD?=
 =?us-ascii?Q?Z3DB+GEYbeg1XPVAQZE1RmHLKWGwOc8PvY4cVWr6FsfeTyj170OgYzmXChAx?=
 =?us-ascii?Q?5DIFzQ6xzXWcqrFK7tkvzme+1qyUn/TNo18V1Nd3AyUBmFLWvh7hWg9Jt9O+?=
 =?us-ascii?Q?rV4TdiA1OtU/ImTIFUoWe+Kfx2PTf7kYFQGDHm1qV66uenzqv71TqGPX1NhH?=
 =?us-ascii?Q?Co9l3wJze8hzMJJ/hSCbLKiN1ebj/f8qTeEFXIK8eAznDDKmXOoiOrJL9+H+?=
 =?us-ascii?Q?5WpiMH5x4H3eOpR7XQrjfuvpJRGLfSeu3YZLabub0o1+QSNYRZzyrx38+dwq?=
 =?us-ascii?Q?TgTKFI4oWQA2SH6rRrr+pMIUd61iWSyAUjx1DHI0?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176d6fde-86f2-4fd2-af94-08dd75b3e7b2
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 09:09:30.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgTGELGhaXI4VVIkFJXyRbTgHk+06kbJWm0P++Kapbj1Dm2co9Ox8jlCG2WqzZk/NKMihYOGmHvTXjo5JE8INA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6468

Follow JESD220G, support WB buffer resize feature through sysfs;
Query bit0 of ext_wb_sup to determine whether the device supports
WB resize;Query wb_resize_hint and wb_resize_status to get the
device's resize hint and resize status; Set wb_resize_enable to
enable resize operation. To achieve this goals, four sysfs nodes
have been added:
	1. ext_wb_sup
	2. wb_resize_enable
	3. wb_resize_hint
	4. wb_resize_status
The detailed definition of the four nodes can be found in the sysfs
documentation.

Changelog
===
v9 - > v10:
	fix commit message error:remove "^M"

v8 - > v9:
	1.Add "ext_wb_sup" node
	2.Fix some coding errors,for example: "gerneral" -> "general"
	3.Add a check bit0 of ext_wb_sup
	4.Following Bean's advice: use enum in ufshcd_wb_set_resize_en

v7 - > v8:
	1.Optimized the description in the sysfs-driver-ufs file
	2.Replace uppercase with lowercase, for example: "KEEP" -> "keep"
	3.Fix coding style issues with switch/case statements

v6 - > v7:
	1.Use "xxxx_to_string" for string convert
	2.Use uppercase characters, for example: "keep" -> "KEEP"
	3.Resize enable mode support "IDLE"

v5 - > v6:
	1.Fix mistake: obtain the return value of "sysfs_emit"

v4 - > v5:
	1.For the three new attributes: use words in sysfs instead of numbers

v3 - > v4:
	1.modify three attributes name and description in document
	2.add enum wb_resize_en in ufs.h
	3.modify function name and parameters in ufs-sysfs.c, ufshcd.h, ufshcd.c

v2 - > v3:
	Remove needless code:
	drivers/ufs/core/ufs-sysfs.c:441:2:
	index =	ufshcd_wb_get_query_index(hba)

v1 - > v2:
	Remove unused variable "u8 index",
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'
	set but not used.

v1
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/
v2
	https://lore.kernel.org/all/20241026004423.135-1-tanghuan@vivo.com/
v3
	https://lore.kernel.org/all/20241028135205.188-1-tanghuan@vivo.com/
v4
	https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/
v5
	https://lore.kernel.org/all/20241104134612.178-1-tanghuan@vivo.com/
v6
	https://lore.kernel.org/all/20241104142437.234-1-tanghuan@vivo.com/
v7
	https://lore.kernel.org/all/20250402014536.162-1-tanghuan@vivo.com/
v8
	https://lore.kernel.org/all/20250402075710.224-1-tanghuan@vivo.com/
v9
	https://lore.kernel.org/all/20250407085143.173-1-tanghuan@vivo.com/

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  59 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 144 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  18 +++
 include/ufs/ufs.h                          |  34 ++++-
 include/ufs/ufshcd.h                       |   1 +
 5 files changed, 255 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index ae0191295d29..ea9d6186cefd 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,62 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ext_wb_sup
+What:		/sys/bus/platform/devices/*.ufs/device_descriptor/ext_wb_sup
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		This file shows extended WriteBooster features supported by
+		the device.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_resize_enable
+What:		/sys/bus/platform/devices/*.ufs/wb_resize_enable
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable the WriteBooster buffer resize by setting this
+		attribute.
+
+		========  ======================================
+		idle      There is no resize operation
+		decrease  Decrease WriteBooster buffer size
+		increase  Increase WriteBooster buffer size
+		========  ======================================
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_hint
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_hint
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		wb_resize_hint indicates hint information about which type of resize
+		for WriteBooster buffer is recommended by the device.
+
+		=========  ======================================
+		keep       Recommend keep the buffer size
+		decrease   Recommend to decrease the buffer size
+		increase   Recommend to increase the buffer size
+		=========  ======================================
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_status
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_status
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can check the resize operation status of the WriteBooster
+		buffer by reading this attribute.
+
+		================  ========================================
+		idle              Resize operation is not issued
+		in_progress       Resize operation in progress
+		complete_success  Resize operation completed successfully
+		general_fail      Resize operation general failure
+		================  ========================================
+
+		The file is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab60f5ae..71e8454d07d1 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -57,6 +57,36 @@ static const char *ufs_hs_gear_to_string(enum ufs_hs_gear_tag gear)
 	}
 }
 
+static const char *ufs_wb_resize_hint_to_string(enum wb_resize_hint hint)
+{
+	switch (hint) {
+	case WB_RESIZE_HINT_KEEP:
+		return "keep";
+	case WB_RESIZE_HINT_DECREASE:
+		return "decrease";
+	case WB_RESIZE_HINT_INCREASE:
+		return "increase";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *ufs_wb_resize_status_to_string(enum wb_resize_status status)
+{
+	switch (status) {
+	case WB_RESIZE_STATUS_IDLE:
+		return "idle";
+	case WB_RESIZE_STATUS_IN_PROGRESS:
+		return "in_progress";
+	case WB_RESIZE_STATUS_COMPLETE_SUCCESS:
+		return "complete_success";
+	case WB_RESIZE_STATUS_GENERAL_FAIL:
+		return "general_fail";
+	default:
+		return "unknown";
+	}
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -411,6 +441,44 @@ static ssize_t wb_flush_threshold_store(struct device *dev,
 	return count;
 }
 
+static const char * const wb_resize_en_mode[] = {
+	[WB_RESIZE_EN_IDLE]		= "idle",
+	[WB_RESIZE_EN_DECREASE]		= "decrease",
+	[WB_RESIZE_EN_INCREASE]		= "increase",
+};
+
+static ssize_t wb_resize_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled
+		|| !hba->dev_info.b_presrv_uspc_en
+		|| !(hba->dev_info.ext_wb_sup & UFS_DEV_WB_BUF_RESIZE))
+		return -EOPNOTSUPP;
+
+	mode = sysfs_match_string(wb_resize_en_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_wb_set_resize_en(hba, mode);
+	ufshcd_rpm_put_sync(hba);
+
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 /**
  * pm_qos_enable_show - sysfs handler to show pm qos enable value
  * @dev: device associated with the UFS controller
@@ -476,6 +544,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_resize_enable);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
@@ -491,6 +560,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_resize_enable.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
@@ -991,6 +1061,7 @@ UFS_DEVICE_DESC_PARAM(device_version, _DEV_VER, 2);
 UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, _NUM_SEC_WPA, 1);
 UFS_DEVICE_DESC_PARAM(psa_max_data_size, _PSA_MAX_DATA, 4);
 UFS_DEVICE_DESC_PARAM(psa_state_timeout, _PSA_TMT, 1);
+UFS_DEVICE_DESC_PARAM(ext_wb_sup, _EXT_WB_SUP, 2);
 UFS_DEVICE_DESC_PARAM(ext_feature_sup, _EXT_UFS_FEATURE_SUP, 4);
 UFS_DEVICE_DESC_PARAM(wb_presv_us_en, _WB_PRESRV_USRSPC_EN, 1);
 UFS_DEVICE_DESC_PARAM(wb_type, _WB_TYPE, 1);
@@ -1023,6 +1094,7 @@ static struct attribute *ufs_sysfs_device_descriptor[] = {
 	&dev_attr_number_of_secure_wpa.attr,
 	&dev_attr_psa_max_data_size.attr,
 	&dev_attr_psa_state_timeout.attr,
+	&dev_attr_ext_wb_sup.attr,
 	&dev_attr_ext_feature_sup.attr,
 	&dev_attr_wb_presv_us_en.attr,
 	&dev_attr_wb_type.attr,
@@ -1495,6 +1567,76 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
 
+static int wb_read_resize_attrs(struct ufs_hba *hba,
+			enum attr_idn idn, u32 *attr_val)
+{
+	u8 index = 0;
+	int ret;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled
+		|| !hba->dev_info.b_presrv_uspc_en
+		|| !(hba->dev_info.ext_wb_sup & UFS_DEV_WB_BUF_RESIZE))
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+	if (ret)
+		ret = -EINVAL;
+
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t wb_resize_hint_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret = wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT, &value);
+	if (ret)
+		goto out;
+
+	ret = sysfs_emit(buf, "%s\n", ufs_wb_resize_hint_to_string(value));
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_hint);
+
+static ssize_t wb_resize_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret = wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS, &value);
+	if (ret)
+		goto out;
+
+	ret = sysfs_emit(buf, "%s\n", ufs_wb_resize_status_to_string(value));
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_status);
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -1568,6 +1710,8 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_resize_hint.attr,
+	&dev_attr_wb_resize_status.attr,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 83b092cbb864..a73838062ddf 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6068,6 +6068,21 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable)
 	return ret;
 }
 
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, enum wb_resize_en en_mode)
+{
+	int ret;
+	u8 index;
+
+	index = ufshcd_wb_get_query_index(hba);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &en_mode);
+	if (ret)
+		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
 static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
 						u32 avail_buf)
 {
@@ -8067,6 +8082,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, const u8 *desc_buf)
 	 */
 	dev_info->wb_buffer_type = desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
 
+	dev_info->ext_wb_sup =  get_unaligned_be16(desc_buf +
+						DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+
 	dev_info->b_presrv_uspc_en =
 		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
 
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8a24ed59ec46..9dc8b872b24d 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
 };
 
 /* Descriptor idn for Query requests */
@@ -289,6 +292,7 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
 	DEVICE_DESC_PARAM_HPB_VER		= 0x40,
 	DEVICE_DESC_PARAM_HPB_CONTROL		= 0x42,
+	DEVICE_DESC_PARAM_EXT_WB_SUP		= 0x4D,
 	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	= 0x4F,
 	DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN	= 0x53,
 	DEVICE_DESC_PARAM_WB_TYPE		= 0x54,
@@ -383,6 +387,11 @@ enum {
 	UFSHCD_AMP		= 3,
 };
 
+/*  Possible values for wExtendedWriteBoosterSupport */
+enum {
+	UFS_DEV_WB_BUF_RESIZE	= BIT(0),
+};
+
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
 	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
@@ -454,6 +463,28 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
+/* bWriteBoosterBufferResizeEn attribute */
+enum wb_resize_en {
+	WB_RESIZE_EN_IDLE	= 0,
+	WB_RESIZE_EN_DECREASE	= 1,
+	WB_RESIZE_EN_INCREASE	= 2,
+};
+
+/* bWriteBoosterBufferResizeHint attribute */
+enum wb_resize_hint {
+	WB_RESIZE_HINT_KEEP	= 0,
+	WB_RESIZE_HINT_DECREASE	= 1,
+	WB_RESIZE_HINT_INCREASE	= 2,
+};
+
+/* bWriteBoosterBufferResizeStatus attribute */
+enum wb_resize_status {
+	WB_RESIZE_STATUS_IDLE	           = 0,
+	WB_RESIZE_STATUS_IN_PROGRESS       = 1,
+	WB_RESIZE_STATUS_COMPLETE_SUCCESS  = 2,
+	WB_RESIZE_STATUS_GENERAL_FAIL      = 3,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
@@ -578,6 +609,7 @@ struct ufs_dev_info {
 	bool    wb_buf_flush_enabled;
 	u8	wb_dedicated_lu;
 	u8      wb_buffer_type;
+	u16	ext_wb_sup;
 
 	bool	b_rpm_dev_flush_capable;
 	u8	b_presrv_uspc_en;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f56050ce9445..722307182630 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1471,6 +1471,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, enum wb_resize_en en_mode);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
-- 
2.39.0

