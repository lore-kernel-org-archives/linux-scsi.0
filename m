Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012071.outbound.protection.outlook.com [40.107.75.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698A7308F1D;
	Tue,  2 Sep 2025 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819475; cv=fail; b=eSfAalU4Zyb3tEe9/uAiDerIwvbJNj0qb/zYXXIeBn0VCjJImo5crEJAxKhTMK6Eyqu8k7yK2SN14EsF3Eq6zsQnkIckWqMkj9khGCpYFFq6WOlOFVOtYP4saw7qwMYFwjuKXLULHZiRBrcmGAHGAj2UybkmsYftq0Fd2QReowA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819475; c=relaxed/simple;
	bh=VPLRaE7Hr20qF8OMNlyNqAwI1jWXzxyhvy7oCPTC9uM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pof3DELKVt2EqyqWAHfxJ78TCjrNG4kC1IjHVa+6lRFCGk+N3ctY81+5G9TU5wwzz3gsw9Sw7eMLxOuQAMHOKdqMk7DKbhN074aWsEwoNHykA/D+LDE38I4aHauZORL2Bs5nfWzoPyNoBm8uygBYOa/NdGDmaHvEqJWUn0p8i3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=pp3LR7Uo; arc=fail smtp.client-ip=40.107.75.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="pp3LR7Uo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Im2xRaEvj5XAun1j62iT9yDOMsZFAR5kQ06KO6fICxcd6EFv5hoNrb31Rc97JI80w6baRJ6N+ayVjOgkUSTFjk13SK10qmuwEf13wVWbmWpCdA7T3V6QxArmVAAtTpi/FOxgbltmwarjUlJZL4LEBZgODgKc6+TPdPXCECsAC1gHnvETz8DU3V0uth1f0yik3tkvbHGzi7HdARuv7yYmtbgGecSC9P5jl8TdO/VQiz+t6BmL9j85KGVlOybNVPSPOZFx4EbMQkfoSeXv3q+qvfazC0OEeXxKOBYy6z+XY4gLEh1p3Wxnybe7XJ/Px4fQyuWg4alFHrb538SH7kCrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oB+Z5pzHpQoVY0kEVskgiTy2oSnQs8E9SELsIPLASXs=;
 b=cxj3MGnINNOQqbHv8C+w4OZbs3d5TKPYjZpi7pJ2nxZ99euknKfpT2N5zknuT+1Z/llZPgu6zzR98+CxqLOa8bYXHV3iep4O2tDt03wuh5XkWF/ZpmAZyKo5OHk3wybYTPBf6emIUNwzFoUpqU8ALs9QbJ5TKkW7ITte4dbKWH+DkPHkxti04JcnmKtZjjgyexxAB3/E3RCpc76VS8wl6+u4QmIoXe7cZkZPedPM7IS/yxBPen9P/zbQyonDOochJvTQiEopYB28DvteSJbLlbqBR5NEIOHA/4Eqr4Cw6Spiuf6/ONmh8MBbmkoBmw1xigD4CuUJBuZZ/xguidxwfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oB+Z5pzHpQoVY0kEVskgiTy2oSnQs8E9SELsIPLASXs=;
 b=pp3LR7UoTpu60OQ/5KKTqFtP3sH41+c96fZJo/HH+Phwl6KU0KtUX67tY+zj8MHNXE4BlEaEGeHp14hDVX8fRS9PovP32ebcMolza6ABDWld0PmPwTi8bcvIoBC6hiqVjlBjDYS55/KyhzA/stDoZoB8eXkhsOvsDjG+OD5nzToKo3c38YvRwf1skir5he2iyw6rnodSPWThn6VbaaZCmdMW5gOVXl7s1iBJ/SaxlXPjo4peNFCKDpspTzuCZjBFTfomwYFF1jC5xXZIE6pB/I0YY+YgtC9oNdBjR/i+fpv8Xl/NEdEkw6nXmkROBvO8QF08CaQxr+yLYPFOrAYwNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY0PR06MB5078.apcprd06.prod.outlook.com (2603:1096:400:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 13:24:31 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 13:24:31 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geoff Levand <geoff@infradead.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 1/6] scsi: arcmsr: Remove redundant ternary operators
Date: Tue,  2 Sep 2025 21:23:41 +0800
Message-Id: <20250902132359.83059-2-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250902132359.83059-1-liaoyuanhong@vivo.com>
References: <20250902132359.83059-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0238.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::11) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TY0PR06MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b3e0ff4-9e5c-40e9-8beb-08ddea240cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/+M2NncHu6XzxmDTtFW+oXODrpI3eBCyBQl477aHHDuKz0/ozx4vW3VXZrbk?=
 =?us-ascii?Q?jhQFZ/fofm8eS/XHaNpy1aWsbHxZ6b7ggVgsMDPoQCYDRWKJneE1r5D5aLiM?=
 =?us-ascii?Q?rolr+73bgNt/9uO2bKcm6bfM5Zbu6TPnWyMAhqkyaW8OcATwAqpuac6LA4dK?=
 =?us-ascii?Q?yZaDwWZx9rvMJeOCf9d7Zd6mefQwbRIYMrG2yi8yXl1aPxB5MBInom/1W+Q7?=
 =?us-ascii?Q?k+JMIhBTjx7whyBnggGYo3bWwjYnO8JCTCNI5+M/+Ou3akzXZN7MhaJmofvU?=
 =?us-ascii?Q?GMsZAixL4+N5t5WYZ7NB02WgIbLBMY4ssCfAr35+uApAwmPuxtHaBvKW9ikh?=
 =?us-ascii?Q?uKcDF6DcxFJK4J4Q6pFa4NqJUIDKn9vvs1Qp5/lm6Mf5JIktgU8ncJYwn6Uf?=
 =?us-ascii?Q?ZLHKdJblY6OiGJco6m56Q8ryjGXz1a+mZC2d/x9dOfymtXLbU+j7AuzzjP4w?=
 =?us-ascii?Q?9LJpvnjG344QIpjhpHmqqGKHf/8pps1u0qinNlEYTdqe2wn9C2OaPgjA/w+b?=
 =?us-ascii?Q?IBibjXcKDWpytoeULZezjk144JqedGah/DyDOF+zdt6CGvT2mDGYweHUNWpw?=
 =?us-ascii?Q?avJdd7zVO+GT9lrvLCu7d9YKpwTjeHdUWsYEGypeJJivF4gX5MUfpGFXOOEX?=
 =?us-ascii?Q?3HJJSHEBu2tSkIzyEnYQROo9D/vqcccoYvslxPOZdqD98UKpROzGlwn8Pxp7?=
 =?us-ascii?Q?xTofeaM6empEHYEWxZ5uGSAU+k5jJAAaU1Wj3sJxihdjLKMw/u/nrDi4kjPF?=
 =?us-ascii?Q?+WHb78rVCQXC3mXZUz7HXnzp2qlVhgBL05ZDiuvQkpVZ1ymD44qR+0X5hieF?=
 =?us-ascii?Q?+6fHh8IiIy3R8Mejonv7SA4vpBJ25BrLWtTvmn+S2uRE+4vYQXIXQbdRbDj3?=
 =?us-ascii?Q?aYwfZU3/mLnVsxtH5aEzYcx/+d3tH3EpQeMpBmvGEqQP5DsWtDh5kfadLSiR?=
 =?us-ascii?Q?y02D+aTSC97Tp3CFqxbb9NkHOnpyps8YDv0vHsWaYrjC97jLYxJeehZumZvF?=
 =?us-ascii?Q?LC9IdA7DDnLntbXnD+B/rPD6uaJTfc7Z+qBTYEVbPWN1tWfKWwFyByUEKPnR?=
 =?us-ascii?Q?TI3QVrK1Nntqrm1vTB39JQrt5YeaqGtLn/R3CHXb/cUzbWncbU0QEoiuJD0c?=
 =?us-ascii?Q?xc/6NkMQri025bu6pH83Q1YVCzMN4s+A68BgplHZRnKeTpT0WbWCS7LocQZS?=
 =?us-ascii?Q?m+Yscids4VPFKDZI6pwc4J3MJWXM67aTL0b66PZmZFKJIXiylB46bw9a147C?=
 =?us-ascii?Q?NqyS7YZvZLr9Klo1znyQfRj9U/C9QOdDyk9S5u/6BUqjSC+mg3m+hPh/zTmT?=
 =?us-ascii?Q?ZVy4Sc9dK7SonBa1phHC18MBC8oWiFnTN+cP7JKn2g3NDKkKrU3Mf0sYMoCq?=
 =?us-ascii?Q?OYqpF/41tJDp0cOrZi6+wxDysjJsSR6j6yUOjxHLompGotzuowUpnmy+BXUI?=
 =?us-ascii?Q?W92+nM309ODUaPmNV5/rPSffSwyDFs6mbn4UcGe/kPr+muCZ0Ahewb81oLHw?=
 =?us-ascii?Q?laTZvU9Gok1bhRk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?METGH1OzROJf9PJ+00BkTQxxBfrIrBLJCQ9CpaW+MuQCAE4UmcW+hPwu7RKC?=
 =?us-ascii?Q?NWbtX8+ijzH4DXdKlehf4+2aeKxuPyKq/p9Z/434j0nf1G+b/OcRRw01+1k6?=
 =?us-ascii?Q?wwmvtEKLiUl1LLCuF81MQgO3Pu5zZVsoGbwz5jzDcQQ5fbpcQ5WQo+DgY70u?=
 =?us-ascii?Q?b18WVeqEd/VsanHSdgO/LJ1XKJP4psjOuSe39Dj1v8quuSTdfNVs3z/tgJmO?=
 =?us-ascii?Q?AjzH0TVQ5ZNBzsygzvPJkO0EGanjRHKwKOZPtA4zmRfHZ6qrIAdOcME+URXP?=
 =?us-ascii?Q?SorqCbDbfQWwBEKYwCESqWJtGwcYBpevC/w8FGXgqgH8DIRF8OjRZK2YN8A2?=
 =?us-ascii?Q?uSoaZ2XdeUhVozeXXkb+tUtcFWWUpQGCp/UCgISHlsZ4dre1WFffgpsREjz3?=
 =?us-ascii?Q?ON5YTqodmjrUb0EbMbl8n6RchMP+WzcWhwti6VcSd9KKLefssSXXI3tQ4ZiR?=
 =?us-ascii?Q?LsJO7XWo4U07aMxaNYT5kDJIuKPWmXWYwfOfcmFW9gnuxnGlb3x8E3zTPe39?=
 =?us-ascii?Q?7BLrv8SJDnCZ+lBAdSnlaMUYjzN4zABMGTgWwAR6dEAQ3/LojPtLpBK6kQr6?=
 =?us-ascii?Q?jgKjKBzWQ34f6UVuWFj2zR46v8l71pMHxG3adWRXCLKt1hH57GtrYpUMFVNF?=
 =?us-ascii?Q?8/V80zQxvNw4aFsAcDbiA7vHpLRDJLFnU38GHwne/NqFtByHdTNkuwrSAGQ4?=
 =?us-ascii?Q?zEu+cvlNXH+UMbXkPwI0osHgwd0BDAP62FLcyGWgctWWBLB0NQ0yRdNBtiJ8?=
 =?us-ascii?Q?5KCfda3nMBY1/BHUbzQSpg6R7P/xksJFGeMb7qk6SO4C+Zrkuc6q8nISyNfx?=
 =?us-ascii?Q?TcXi7VdBTXe5umV/Y59Y5PdvrzYt7SSTNrIAZRI+M6F8fX8cPzcQr04Eoi5Y?=
 =?us-ascii?Q?qkPUTfVX2xQpjXh7/1l9G22yRtZSIsA5AsU7bM+Jta5SGAT0nx85TfysvWX0?=
 =?us-ascii?Q?Y5TxF+TQqAISrgOQ1UFSWPgthQImrAPuzY8gmpS3wudqFjYimFioXRvmer61?=
 =?us-ascii?Q?HBWhgJG9hWVLBlHELPRot604OSRPkrYFsa1n4SiZ+41hH2qPCfumqaguWoUn?=
 =?us-ascii?Q?pk5c9GdtKAN7Ch8DzHklEZq28mRKsKmUVQPhY0bTYxYmg1W0Pmr0agiIJf5G?=
 =?us-ascii?Q?XzGEZ04ezv8WHkrY2A6QBbWWFHaXOxkJsKD8SqWSwAFIfwX6QpsQ4ZgVCf3t?=
 =?us-ascii?Q?0dX0AAcKghc27UXfkr+/3Fj53ozTtZeIN9tHIQDW/yADlNFV9qgNnd4XKYOP?=
 =?us-ascii?Q?ly2I6F7XjB7d/W82fOs/qtMFBzyyzqy3wfEuMBImu4dLRQT9xyjm/ss14wwI?=
 =?us-ascii?Q?sr52+ddTj2zNJ9/wWJMXr07UuP4uZaCvdF9CRh1JEPiRcWFjh976m68b2w+t?=
 =?us-ascii?Q?WxUKzlqW+1kPPqhWGSAVtgM+3uAe7Y+yl/sbYZ+Y01i09p42eOgam1PVKt/x?=
 =?us-ascii?Q?DFSISq1icorof4kjA7a/eXxEkXEkUhcRr71aybssKG04j6FoomhRS5yo2fzH?=
 =?us-ascii?Q?x4Yts1849ui++0ekZgLrdwFxGu5bkjmo/+76P3cSHox7YgQQ5xpwsFvr0vUM?=
 =?us-ascii?Q?zd2RSpDGT2HY2fueMkgqRJqTK+nG67WumlMrY0NB?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3e0ff4-9e5c-40e9-8beb-08ddea240cde
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 13:24:31.4612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qU3Ar4ao9w6VD8sH5Nv94acBs6UM1bUxooF970NidzSccOFF4sXXIrKuglElrh02A24raFCh0FFTox+9Kqc1ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5078

Remove redundant ternary operators to clean up the code.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index fb57343a97bd..fd321af14d0e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -4584,14 +4584,14 @@ static bool arcmsr_reset_in_progress(struct AdapterControlBlock *acb)
 	switch(acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:{
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
-		rtn = ((readl(&reg->outbound_msgaddr1) &
-			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) ? true : false;
+		rtn = (readl(&reg->outbound_msgaddr1) &
+			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0;
 		}
 		break;
 	case ACB_ADAPTER_TYPE_B:{
 		struct MessageUnit_B *reg = acb->pmuB;
-		rtn = ((readl(reg->iop2drv_doorbell) &
-			ARCMSR_MESSAGE_FIRMWARE_OK) == 0) ? true : false;
+		rtn = (readl(reg->iop2drv_doorbell) &
+			ARCMSR_MESSAGE_FIRMWARE_OK) == 0;
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C:{
@@ -4601,8 +4601,7 @@ static bool arcmsr_reset_in_progress(struct AdapterControlBlock *acb)
 		break;
 	case ACB_ADAPTER_TYPE_D:{
 		struct MessageUnit_D *reg = acb->pmuD;
-		rtn = ((readl(reg->sample_at_reset) & 0x80) == 0) ?
-			true : false;
+		rtn = (readl(reg->sample_at_reset) & 0x80) == 0;
 		}
 		break;
 	case ACB_ADAPTER_TYPE_E:
-- 
2.34.1

