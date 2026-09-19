Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011001.outbound.protection.outlook.com [52.101.70.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037D2400961;
	Sat, 19 Sep 2026 13:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789823488; cv=fail; b=U0yi10Ktkg317eXW9Y6qMy8RrSWJrSdox7z5pKEpT15aJIuESYDbyJB3BiW9+5xMjxccYyDM8juWcJbx2xCUR2eDtEERDqRUU3KsuLc2b2XmD88GWJpo20N94y9itajEsyTkB9uZ2cWWWevhzNiEm7sbAY1CpXFjUHg8JLknlmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789823488; c=relaxed/simple;
	bh=3jqskKuJC2QggQCS9dktCl8hnLjAj4JoHqv3rR0e224=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uibTzNb3ZZwQx7JqtAb9YJwsvULQBBXm/fqY+q3WgQgaRYn/Hby4Wn8Yb5RjGf/XvZtovga3TfNZev336jj2KxYzbtCZ+HQUBNwUt+Ipf91BFwoQA4xa8xqirDQGjZNJTU0tqPlwXxgrAHzl+y67e6HR7CsrGgNdgzHscxojmMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=xBI+B7BO; arc=fail smtp.client-ip=52.101.70.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="xBI+B7BO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMfpDQ1rngauZltnyVv7lf/1bdGZoTe0IOhepiT7kRrfWRHRZr4cMu9l430wbPNq/MHafB8klVYLSudFxfUjpuvTgOh+vWrsfJjMLIp5G4cnEx6NK3j+Sb6RCw3LDMiHhSVW4GEaDxXybOjhf0rqGhTuuGyKmIoFFO/8cmFlEf4MRojn0tTOv+emOtPtAP1Naf7MIOmigQcPDFV8mgiTq8CwADdMWpWQ4is9qn880EoJ6RJ5cca+8DAFYbzUblwwvAce47R1n6gTi6mUni07ZIqVj5WlC337z2rNQ/4K911WYkwKohJe5klOW8113qRgyVlngrAwi24sgodn/t3OIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MKtbgpeTqLPTDVonH2oY6rNe56knMhZrLmxhqhDVoc=;
 b=oXLbPi8EVarKaMhNLX1SR1l7RtEQGbgrNUseWwOmwpBugmL5r0x2YQ4JXafWj+ABIFptUBqL41j1m/Z3zyG3sU2sFKn0x1gzBOALpv40e49kFCqKs4GsiAAugkF3eBLh3hT8K//nEbxYnTbxnUScjdA+rwirgSoufxvIcpAwTnvNd3urD26unmk7rC+vmQ2Lje/ey1hLF/dVq4Mq1NhK58oosukX7bx5aktnw+v803qnJFlwtXXEDRZDEsgkRD1FnbVHeD2o6Auk4hBbORh8ZQiXwGbu5S23zQ+DLShS/TiyJ2cEAFGHBbR9drQGjVLL/h5f408P1mR489p7gRratg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MKtbgpeTqLPTDVonH2oY6rNe56knMhZrLmxhqhDVoc=;
 b=xBI+B7BO8XvMFJZAxmkGGbvL/sGIySz4n2Fx8stt75dB9PXYJ+xJtF3Mn5Mqn53AanhhmV4+OOLyBGtI7d0/wQKuQnvvi0xaMQK8BYB9tPSTM/Vq9nayGSYGrwTa/0BmNIFDh0DeHYb2c4KifEYaacLtjjsw+18ELnLkSSMPOTsXZfMlEq8i+WV+xlapUJ0+nSDD/l3QoFpJfPA72zmQ4i8Cg8IFqQv5ccHvAX8vgB0tYQaIPLXzumn8XcIIgUc/ArJoF6/d8i+IY5QyramlBTdJf8hJqqmCRG3aeI2nh4ZcvZEHxuIvEvjVqvUzrzCbpNOHZ7FQpKtYTziXyxPcHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS4PR04MB9507.eurprd04.prod.outlook.com (2603:10a6:20b:4ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.14; Sat, 19 Sep
 2026 13:11:23 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.014; Sat, 19 Sep 2026
 13:11:23 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] target: use assign_bit() where applicable
Date: Sat, 19 Sep 2026 21:08:52 +0800
Message-ID: <20260919130853.3041614-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA5PR01CA0169.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1cf::14) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS4PR04MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: 75fff85f-01e2-4b71-4b6a-08df164f80d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|19092799006|1800799024|23010399003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	RU6iK5okjuUg7cxdV07NmNYlHYdrJTy1fAgnjOtXApJuKPHUzOvbto88L85pfOWuwRjzYr7cXcHbzANvezLzIUYs85aBpIX7AIeReOCZOEHVh4a+1PPKLj1QnwKRImV8Funl5HLZ7NtS7knfipixcAVjX9W+LOI6Vdm6SyFI0PUkOAzriLkF8kbO3K88fat0hhJHK7XOsxtAAAD/eaiWy8+ja0MYPsnpvSrGIrXUFO5iHZK2LIIuDrLFsP2L6DT1NY/hwWJ0Zu7OJAOxg757RXFCzucA2+ElYsZ5VP/Dp9R0lafyxUN05xxr6qd891VIo1mzfJimV8eq+7QFRDRAASfVit4KETYxoxZZe64jCme6IlOx0haHMsPJLywCsdsqWjWZQSBKrQpdwzCg29RDAHjvdwI5o2IqbaCwVgrE4FWb1IoDek0iX4hkD5tS1WCMhuxUwpw52uHjSLlEIKkosnQzfHiXFjEFif8kFlSJAmVDB98GWFJOc2VUZDSIn0wSsjKlleqLqzwJGdH4PgnIckrKfgBB8yeHEe6GSV57Llt/19ieFrpa5Np3hc9tOBjoos60Cyzyz1FW4npUughgLhRyMgz2E5bJ0CE6gcWxjZoYljRGgZwBDsLF76KETx/AHx33/EnKz4/WhMJaiaV6AmqfQ051XHDXok8eF3SVW3M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xUhKpj5lzkC1GAlxGM9+p78mIYt+XGo2OiY4eQ5EvKLa3oeEnK25Xw55is9W?=
 =?us-ascii?Q?xIZFwi2u17JZ7McXg81UGmy4k+KKzFERL9SVyD+mWdYELEz0K5plfD54xuI+?=
 =?us-ascii?Q?U3PLcF3vXyMclL0K1vtHeZRFnItg1Trh3x/zOs/tkwjJlR54hTKEZf+w4cm0?=
 =?us-ascii?Q?cIAfPF38s6nR4czniv4x2lzryv4EnhuOMWap3AcUmkjJP3lQhRok6RUM4C0F?=
 =?us-ascii?Q?L6MGhNVigEnCa6I/Nl9dc0n+r+jrQzGNOup9dJThHUvtVA1/p8hCVz72Vfx2?=
 =?us-ascii?Q?AqWbQYU+Q9Ls1Yg0aI0vznPXnMwHN3qun658WVaOODKJ5qYn1FDbeqfdYxp9?=
 =?us-ascii?Q?qAmHEZDHL//SGSpteeiklahrNaycBADcDJxvkt16glzhjcpS7poIUnpMJSdG?=
 =?us-ascii?Q?WxYVAVhM1AArHhFVP+GjMNXTLhA0Cxyy57TeVISjN50VwwwElsyEcHRMMbBn?=
 =?us-ascii?Q?+ABdkD4GqbdE7CH6/ziug/cCjOEs6uTLPbOvgtpKzKZS7tkdTIgpe/cuIPUH?=
 =?us-ascii?Q?Py5ITKuD4V9zv3GVs7E0YvRicMkc+mpafAzak6RdHYSFxMTx9Jz3bu/rUXLr?=
 =?us-ascii?Q?+fmxT6LO+sbjToHnZOCYUJR+ngzErFhGEbYK2rinQkuREFDkTOxIN5M3JOpS?=
 =?us-ascii?Q?+4EsMl2rKGJ0SJH4pXhW8iwi2u43buet0eS6WrXgSGyrlKOzRdbNRBxQ6rCD?=
 =?us-ascii?Q?TwRtRTyKEFKWHPV8ABoYDX2E1EYKmI0IFQd1/vjHyXA/yECvj2vx59aSRJrb?=
 =?us-ascii?Q?oGd0ftEvfEXTLoCSWVf9OLGI3cwm2ULaYY/J6p/pS7f1mlNIbRhkNKnh8wWt?=
 =?us-ascii?Q?VKvYxV1O9eDXCaipbZFuSSV0qVLgKW9swP3+5JYtWyY00K23NAhtwTp4fPnF?=
 =?us-ascii?Q?szvmLOSi7nA/cJjgG5mJMjz1NNgXlHdFIYl4yOqhwcztzlGeGh+AVm59PPAL?=
 =?us-ascii?Q?BN8+0herIqH5mxNsTEXCVLYH0ThBMR502T8BCQP5WR+zjC2zaLwuZYyj4asG?=
 =?us-ascii?Q?GloNbBQbf7vsSp5QNEmXVYWZZDSk0+gL7qXK/3xp436+wPB5eHe0lzUFU+Ld?=
 =?us-ascii?Q?tMqaKpyKgI+HxHJ7H05OYGVhztDrA/RFp89yMLsDZcqnx4aBv8IGwsbKiy69?=
 =?us-ascii?Q?LNyVCD9jEZezRC66e0McUSDdDSkg6MnWfes7Gdqj2+YkIfjFbKOugKFBozrD?=
 =?us-ascii?Q?Vh3XJR8LDD4MSryGmAITZ+0OCDRb8WE1BhVDi6TRMfzIFZ3rOTMtEdvHTKi6?=
 =?us-ascii?Q?7inahmVgnKk3JiMJ0n6M6imJwO8SOJS+24T81VYY7VpQOct1qolbyrG1Cumr?=
 =?us-ascii?Q?frJEReJ8ZRscE7oYQjxwTInfGeda7l6PIwcMtvGMkM5u6/hB7wQ9Ra8XfwXG?=
 =?us-ascii?Q?eyn8mStqrMa3PZEM0WWg0YLSzFiEuXHwOS+a2y4Dq7bNpL8bNDgRfez6iNBX?=
 =?us-ascii?Q?cWeelZQNvwTGw6d7HHacEDPFLiWUk5t8LuHnlmc2eDrnmpOnpYANJ8v7YbvT?=
 =?us-ascii?Q?WtWSKoKla2VLKkW692ANTdfPfFNsWtPaHybZF/hZwKuykOLTnODwbrKLgej4?=
 =?us-ascii?Q?abbO8hGbZ6yqpXp4QYxEEXPoBuO4ayvCFmuhtzBa8bsGUKvwm2XEza1wz3UV?=
 =?us-ascii?Q?MLnlmyx3XAL/CvqDDLHbNx9Uwxt1pwA2HoHPtyAzxHo0lP9QaMp888tqLkyU?=
 =?us-ascii?Q?SBD0h5mmR7lGSBkay/D8jAM2us/AGOKJa0PEuvSphBPJL+QxAAR5IZO4hKyB?=
 =?us-ascii?Q?oxgSPLJHVPi44IVWWGYmf1Suzh+9ava58bHhfFVx55Z9WiPM0p+p?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fff85f-01e2-4b71-4b6a-08df164f80d0
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 13:11:23.0881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GwJk3Fs238+JukvcJI8Lsa9Gk5YXJm0cZSuMiq1KwrcJNCFr75osaq4dLhSE0vbUpTA3tfyEwKE2wwjWivcuEkVqeCkvnyl8BcGa3ciFKFNLHHGYGqtPNwGWGuzZb8kA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9507

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/target/target_core_user.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index edc2afd5f4ee..425ad1246a75 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -3006,10 +3006,7 @@ static ssize_t tcmu_tmr_notification_store(struct config_item *item,
 	if (val > 1)
 		return -EINVAL;
 
-	if (val)
-		set_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags);
-	else
-		clear_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags);
+	assign_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags, val);
 	return count;
 }
 CONFIGFS_ATTR(tcmu_, tmr_notification);
-- 
2.51.0

