Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012070.outbound.protection.outlook.com [52.101.126.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967B82F60B1;
	Sat, 16 Aug 2025 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755356432; cv=fail; b=Jm74M49wIGO0SkkqGbKG7TTrYJvm1g0QjD0dxfvfCHatgmxklcPt7e8zBZ05ZDnSTYEDXC0/SNgg2j8YwquAZ0PgqK3OXcIKSBONT86bib3pwEq8rnjLbA2gtQarr+c3ZrxwUuQNrAaNJpin6JVBHxZi3DZCpI26ir9Q5MB7nYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755356432; c=relaxed/simple;
	bh=hLZwQFVG4EZO1Bkus+ZbfjyuTccQaFqtP2vnFPVGzZk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=AdspUm5VhAVIJmAaEqKrKVA8dVRPe7U42m/foxzHJBp9hlp/1vCmYFkaA2dwbISFnpJJnsL9qV+2Esbt5UQJCv2G/6Q3M4gHe2/I36IZmi4px1elgD0+1UEtiDPQQTvWzve83vjRcFELs/k88y2rhBKkWNYwzUojpoOMo1gthFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=lli0IxVR; arc=fail smtp.client-ip=52.101.126.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="lli0IxVR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aO9WQPePxAShcZvUQB7FhJIkjwtrGwBDXOIrsPVVLS0k+1/APViYwPc7TEv6zXOOUZR5+akzinL5Uz/h4ToVdf0FdeZkaYMBYMHZ+LkWqh2EEVyMjplbMtaXR99nSAOCMoSYsxfNEQQMgEciGFlUJs5xzklUi09CJMZ1Ejbj8pmussRSQDI0hEdxcQdb4ayHvEmAkViknQW2d50R8kDE4oE80kQFrDx38OEhWtmaQi6wBbVyyrXBzDKrIh8zTgT45x/rcl93Pyt3d98+F9mHrTFmLuqxzWWnA0e0z/0LL2OqjGEwek/OYFaE9V+SFrpTU/jQR8D17iW5CuLDIv3F8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IvdXp+gHnAolwDx8eigBxwDy3jLbXs5tVjK8mzNzjI=;
 b=SemkwhLHB2vSkNhdSG6QRY+NE3p14t2Nc6IYyhTmPI4gAhGH+xsl3Q82iSo/rzE3Ythprl3piOqeXh46KO91O7SGpoCfgNs3EMaghOiE0HWpFAGgdBjxU+FBYatlfAExCQBwjQfz53nZMWrq8llsO84Fpo8AAOMERNIph1agJ12yzXUnFOvhN2IQ51HSSyQ6CjvVEyXHbvGaxgXEFLGq4KOvpUaG23EaJ51pgmRa6r4vXH0Ute41ghrAaHk4FwZOHQxg4QADYwLmkxd6tFejCiogcWEVzi7mtgdrNukWZ8bwv8xNrxP3P3r/o3R2lIGIUwD7ONPMViwoA5/cTOZwAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IvdXp+gHnAolwDx8eigBxwDy3jLbXs5tVjK8mzNzjI=;
 b=lli0IxVRPB7ZJBKCJUh7yCLZ+LVLA4BKUQ2YQwjchybLser968KLPBQFXy/Z6dz9WZIRiyqt+1YupQk5iaViewCDCk76mIQJi5zVQ532iTnfnukp0/C3Zw7Pxo1hz3IXWuASaQ3Ct7BCTnQyvYpomB4BLO1T7Px28RkqaRHgxDhQ5baUSTxhojnOlDWwAc23dQ38SyeQ1gOMcrpTECP4/f9f+HBmtD6l1IQjE2cYoJTGQ2y33Datu+xvmUoFIGxofcKsZQCut/P8VNHu59tL68EWeDOi+rbNnj5WZ9HbmBy2riUkM2K1GS/DVLTFhz9rqU4xYK/pGvmd2ZsWDyhvaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB5145.apcprd06.prod.outlook.com (2603:1096:400:1c3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Sat, 16 Aug 2025 15:00:27 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.018; Sat, 16 Aug 2025
 15:00:27 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] scsi: smartpqi: use kmalloc_array() for array space allocation
Date: Sat, 16 Aug 2025 23:00:16 +0800
Message-Id: <20250816150017.407518-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB5145:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a1a10f7-bcfc-404a-b623-08dddcd5a2cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c4CMlvzCBIHh48trh7/bhRIo+ynK+Xd+VCWtUfwX+i48Lnr9wLETs5bQ0OqZ?=
 =?us-ascii?Q?LwGWRk8DY72/Jl+r7+mBOBF6AQhqS+DrNEHkZLNTqAq2oOux6YciDmUuW0wi?=
 =?us-ascii?Q?1WXJbkhxFkuAdkTgdBx7YmYCVF+J6P7Skh8+LTVPUhRZusHlzV6yNQSchQfz?=
 =?us-ascii?Q?dn/ZXPNjhu/KGT5HgNyOl4oo4ugx5y9Y1ImMt7GA8Rj3nOlooHmK9B+viCaY?=
 =?us-ascii?Q?Ro/U4lcAxxpvW4IDxDS8cWU46tTGvq0eNL7wuWjLVkKiAHQ0eTvNpLamRDf9?=
 =?us-ascii?Q?Us0O6OQKDLic02Y8Od7Ea6E/0WViuPvufXjEsgZt3+3atw5AhVtwc5k0x3A5?=
 =?us-ascii?Q?79vY1hdrD9qKEruu4Ouuf4zj5zVlhUTHDKnjob4Dy3ozSxMuIq210OFCgJ5f?=
 =?us-ascii?Q?sEAvJeTQt/q8/cenReCffeHwBgieYcFTroa5GcPOifR14vApYo3wCkhU+ZYZ?=
 =?us-ascii?Q?BdUWi6cP+XMbrfGjVPvMPvZSd3xPKa6QcsbahYkWrKvT7GF3Yh/37zzmX+LL?=
 =?us-ascii?Q?+H0Og23v3Gc3V9bdzDSiIq86eDmSLDkrUie1nHBb6okFh7Q3uwDGK9K4o2Cs?=
 =?us-ascii?Q?Em960MQXO1bwDVqofl/sbrKclwNhah2WMQlu5dpg7Ya8re6h5yyDzKLqXHgh?=
 =?us-ascii?Q?HOjTpVPPcI85+2KzvPQGUxfNPDn+CfsU5213kgx7KyiWRTwBlFEeqxd6jl+X?=
 =?us-ascii?Q?ODU+6tM8hnNDGu94/EOU7fAwVxHQA5j0eB43MVNMIUVCRg93KhyuoZ1Fjueb?=
 =?us-ascii?Q?j57aVBVmy540wHD8iuMIe8medXG7v5vQNRYSD/P/6bRw0B1S7JzG2+yg6Qvt?=
 =?us-ascii?Q?C1nRyK/DBjw8r8fQPP0AL5AU89fdn/fYquZGMTcWKNZdPQMsvtw1gQSoqAOS?=
 =?us-ascii?Q?fulMmInY7VGlV3n6j/Y9K81tCsNZXQDuBaAGAL0XvbSQVrc8lpmAHcW99URO?=
 =?us-ascii?Q?QJ+iOgRO59Oi3horfeIQE9EK19cmR1wHA0F/S8cxpt8VJXT4Yc30p9MN83mt?=
 =?us-ascii?Q?JicNSSQyvRAkLWrpO++qowwlJ1sId8Xr8xCNloRIC56cwtxm5Ybd90ksIxIo?=
 =?us-ascii?Q?DHOy2XGyEjF9fbdngK/uQWlmrrOAfbf8M8k90IgmFWi+njCMclhsZ19xUfMk?=
 =?us-ascii?Q?gC25xnjQwPbD+7KPLBvNT+4H+idQ91bJywHguT71xMWckQ4jZIQbt73MEgLy?=
 =?us-ascii?Q?WbFGhurkxmv43xDKAK34ajqKl4zf2I9G/cyiliHaoGlRye9tltMCQw8REISx?=
 =?us-ascii?Q?JVXDPy9N9NJOo34YtdT58dd6/PRkpgNlE6kK0ElNSddRCMRu5bfRMBHXfzJG?=
 =?us-ascii?Q?99cnX/YUICUtyqKnZ7xUIEVVbDSvWf6SVRETF0GKOQbluDi8ivbv2VLowbg7?=
 =?us-ascii?Q?Z4g3Y/2o2nV3v+FVIGRDSj3gk7dASOrYm4xzNlTQ9QQuyD9f457os8RnO9BL?=
 =?us-ascii?Q?zXGxnKAEITKeaSg7/pEfrm5bo9ipNVFRr/BuvE6K0coi6ObQcW0Zbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n333h0hkb9HGlXMdUJSjBZPAhigsfoZFeqeTGbLtY9eNmd++RZjbtHni/ll8?=
 =?us-ascii?Q?ZfizqtBPD7EOuArC4MOHqs+aAzDd4Guy8k0eePjk/AxPxbfD85lfTUzTS7Ct?=
 =?us-ascii?Q?cW1QV8IHivQKsPdQESlP6kB7pHcKueBtHj2TIrFdtgWeMmO2Iwhq2dMYXTqj?=
 =?us-ascii?Q?0cjGvv4JkizWDPAX3KaS1UkfPvY5Dgvr+/dzNCzXZtwOSnWPO/JM8Y0fYxkK?=
 =?us-ascii?Q?V4uHWDs6Zrcfk2rgsiuKhRw//fTUewTPw8wmmoK/McSL5AGduOqM/qpB1LyX?=
 =?us-ascii?Q?CZGUgHzO5XJR6i0w6S65IumR3px6bm6ReMzl2I1zR8xOopKNjQx44NCEZSgn?=
 =?us-ascii?Q?rKdPERHpQQcOB8TpFoVfz1CYvxD0iW9MRYovths54YrijHG279nqJ4YqL6Su?=
 =?us-ascii?Q?1Bka6zgCU4KkRj9cc2NsegKQTuMa5x3UgJDqL9mrtcY7Ymfk+vnRBBLUs0SJ?=
 =?us-ascii?Q?QgWEwwEMCzAvU3M4BHdPu1rke3HktyLJ8TsRuNCbIZGWeZO4FJ37Dqw+B249?=
 =?us-ascii?Q?YEOWzBmiQIUzq/06JlrNTM7VzE66FpFZAzZBayl85WNqAVIkGbE7WMQ5DXAZ?=
 =?us-ascii?Q?r9/dTyrMAVv7vAtptlLU3GYL2eDLfTq3a2pdA9Bm5pyAszmOynkUtDzquktD?=
 =?us-ascii?Q?jx4m2n/14E6MNrsMXVTDtE56gwOWAFVW6ySHr/TYEYQ1FNhhHTWJB+sXth/o?=
 =?us-ascii?Q?VSrCA2PQBmNIBrtcPs3PDfbfTeRJoXLuUVKp/vgY2CHM83NxXvkDZzNI8l/S?=
 =?us-ascii?Q?tGWB1x/X10EK1H+YuNam5C+hGuRoYyntYX+7NbVXPaEVIISNhVbroiKoPt7a?=
 =?us-ascii?Q?up/DZ6zZ2xccsS/SMhzt+Aun9RotxdXT7My8jM1dIz6pZT6LMyfkHX+/nRfj?=
 =?us-ascii?Q?fr9yq9ndthGRPuIJHCjyqfKPPCUvzkH/TpN+t1YAjK4u+EDXqXjC3yKsXzQN?=
 =?us-ascii?Q?5kXCjLdsbuQipnLPx1m/Ds3jUT1Le8NOne6PDw4e2/RON0Vbfww9BUg0moh3?=
 =?us-ascii?Q?ZGCxeW7pnNgZcKRS8458dW6+2IXQEJzynMX3wa2pIldW2CZudhRgPb9Zks/D?=
 =?us-ascii?Q?BAIy+n/yVllFO3lGLDV3teXwiv8DEz4QODcprTA1OVBYt0I/323SMsp89Fov?=
 =?us-ascii?Q?brBThuxMIovHZhhBjL3Tuy8tHdvGLCGiIMeJX/gMK0FLOW8G9sWYwR6kw1r3?=
 =?us-ascii?Q?rQPK2Y5/nl+9BHKxtkymWcw8IWpowzu4D6XKP1BD1vjEbscbyWv8anjw98b8?=
 =?us-ascii?Q?mz7eSb1soqI18NtOSIlOaRjAsQISKbzoRbea+eZEboSvz+dHLpAiDga7RlyM?=
 =?us-ascii?Q?snB6QCABZ2EE+u7VCIft5tEP7c6alEk8ToYdRx2zYU600PQv4PPSK6KkmoM2?=
 =?us-ascii?Q?RMfAEE1hQuA1pCOo1sZ0scG6UHMRb8R15EUf3vtGZIkSSngUgM3FnU+XAcOt?=
 =?us-ascii?Q?jBpMhQ8a5ZJM7LUMZbsPsyIQ7sdLYAu6GkAmB9gN09Ffe/Klq/DB1e1wsH4F?=
 =?us-ascii?Q?KNKU2KvT/3CT7lYkL8GMUoc/8tY3NdZeRZS0SuqftYTbYMnTzvBDHXJR6afd?=
 =?us-ascii?Q?IHsx7AMcLzTOMAee10riK4GuI8rNiHsFUUJgHLEr?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1a10f7-bcfc-404a-b623-08dddcd5a2cf
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 15:00:27.6105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ag8CVCqK1NEIGzBEj9e2PnVOcPv1HRGqtK7gGFGpM95eVSZSUjkrtL1SMAEj0cShQsIPJyN1vjq+owYYDOJZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5145

Replace kmalloc(count * sizeof) with kmalloc_array() for safer memory
allocation and overflow prevention.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 125944941601..7ff39f1faf38 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8937,7 +8937,7 @@ static int pqi_host_alloc_mem(struct pqi_ctrl_info *ctrl_info,
 	if (sg_count == 0 || sg_count > PQI_HOST_MAX_SG_DESCRIPTORS)
 		goto out;
 
-	host_memory_descriptor->host_chunk_virt_address = kmalloc(sg_count * sizeof(void *), GFP_KERNEL);
+	host_memory_descriptor->host_chunk_virt_address = kmalloc_array(sg_count, sizeof(void *), GFP_KERNEL);
 	if (!host_memory_descriptor->host_chunk_virt_address)
 		goto out;
 
-- 
2.34.1

