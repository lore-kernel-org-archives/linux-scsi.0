Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012017.outbound.protection.outlook.com [40.107.75.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3B0277C9E;
	Fri, 17 Jul 2026 03:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784260233; cv=fail; b=Fi7I0a2sWI5oEVqAvTaPaF9mM4+GAhJinbPRpbXcXf0aIYOswhJ9QO/MnCkWhE82Uv+Aq9oT7lwpJfDi4nIt9l5EJ/xQfKrHMsVMwfwPH1e50/utn8lIEPsb+TNvTRccTOx/UjPXgKf/WPCNHmzzlimYEXe3IrPkiihWD/yN9CI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784260233; c=relaxed/simple;
	bh=juw0iPpOG1bcgklsKcFmPUnnRaHipCEAe2Tzp/YjID4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=jHMpdE9EwmbcvqHqoBU9UIpB0jZk8P/jojnzJCaBppi63dndhBL7PnvKgYqooq1GC9SiQ8RUMJX4+3s5BLzt1kKz4RfnvookRQ5FiXTJQE110rD1e5Tns1n+4UuzDBobo7+N5e858BGWSc6jIRYTt3ztG9LSt8oq0VtqG8EMvt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=q7u77wCN; arc=fail smtp.client-ip=40.107.75.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="q7u77wCN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQ6Xuo8oW+bJzuUtzST/tc+u5ggs6q0rTpmvRy3dGjXMXIjpVNCrW7830EuY+FfAhgSL/vM+O1m/iOnIDDBny6JlXsW1ckduU4V/LAmlmY2KPl4UO4DcBe+3H94aiZSWTqJBWnB130EHNGLQTkfg5dWVhlnRpd1g7qruHrgQDDYjkyDtOSkYI5bKTX63i4Az7k4OZ0vyfv7ccNqXVyHPWVhhoCCxJXiyWGRpY/RV1knUJfWkJdkYhjezYf9fZZW+3AV6z8NFQe8PGSoi72bcaranTw7LqAksBV9ch4zJlZnYpvuYIBVrluSoibljTqL4GrSIJfq5MhHo3c1cLiTnLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4fXG/ZWn4c/9Vj8x+sBOeF9fZMIW8AvOy1gWND9rlI=;
 b=Spq0BJPBy3a3IRHzGGMOFTBJt66Zna84yQdCCwXwefo7AcXsAQOZH4HdSpqCTIErBdvhEYf4SGJOdQbIuaWVu3Qr7Bk4AxGtqHMFSUyw17MfKRA/wyDsSjqTjs9bQazbgXb92xSXpAfjd+/DQ213Zpn21YlgtX453xZSDcSi7gJ0VYOMTpk07I2iybyg6JOJQPoTtVQIjbIpJaD7lhU5pkKwBMjaYYKlLM2vdQYTkoF5vkyxixlNGXXcycCyPfZxvSRjT8VBxOowxysljrbSdI9DHNOjSUEcwBivsnGl1bYZiiPgdFmYoQvAdMZ6VDSutPzr3ef0fAI+5JlrGIraUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q4fXG/ZWn4c/9Vj8x+sBOeF9fZMIW8AvOy1gWND9rlI=;
 b=q7u77wCNJMPN/Q/zb/FxYfAvN2Eu7FKpJrkXy93HQ0/8j8jQtIkL59ysvJXuQScrV+5OHuWN0Y5vGEMVdKsm/H3x5LOEfR6B1kvxYWv3tmkxbpF1UvfabiNTa3PagnQSK2wKzyMQ9tph+UJs++C3jdSk5sgtOzQDolR/wvC6LwwApp6pe8iQhA2UIFAuhQdHBGP1KtLjHm9qAFmAbbsikV3UozHKUXWlJb5Cc2fDhXXpMAonJ7k7dAfol+YAnQoD8hdKKirpAVo1aE1ceGmF8gCJZZJyVPs10eGAdWmWC414tpfROFJiP8DV32ceTkZsz8GwlIHuPOOyJFDLqOc0uQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by SEYPR06MB5205.apcprd06.prod.outlook.com (2603:1096:101:8b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 03:50:25 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 03:50:25 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Peter Wang <peter.wang@mediatek.com>,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-scsi@vger.kernel.org (open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER...),
	linux-mediatek@lists.infradead.org (moderated list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER...),
	linux-kernel@vger.kernel.org (open list),
	linux-arm-msm@vger.kernel.org (open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER...),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH] ufs: host: Remove redundant dev_err()
Date: Fri, 17 Jul 2026 11:50:13 +0800
Message-Id: <20260717035013.563791-1-panchuang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0054.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::18) To SEZPR06MB5832.apcprd06.prod.outlook.com
 (2603:1096:101:c8::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|SEYPR06MB5205:EE_
X-MS-Office365-Filtering-Correlation-Id: a15a6919-45d1-42ea-0169-08dee3b688bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|52116014|376014|7416014|366016|921020|38350700014|10067099003|6133799003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	fmi1cHonkD2t+K5Sot2SUzvkykNcEY2TJPb52kwPEnSmJ6FSjutOtfSaPDeBQDyh7Tv2W5v4J+kQsloqoLQ68OudQz9v5PV6QuzoaYde7uZ+NsqvGJyJY1ms3ik45G2BkO6e4QtWT705yS6ilTcqrmgX3oFPsXFbr7ZSm5eDzR7Gn086xVU6uiAwxdbERzYhJD2GUEkdzVvO+vvzAV/8XoF0+Q4HBrZe1d8PEwsDTn+vCL1XgtSvWSpz+XQRnj4X4oLe0empxmtz9h3C/A7z9c/Wo/ABXvCC2aguE64TWsgIkxmAiP+aTO/YQfHogtD2Z49JKuq+zKCqyPtkNruS2XdHq67fXhrZFyr+U7ZvyJBsXY7dv+isY+EKlX/n6jTM2e9ZvC4AfmUrvMT8nLCBuoP5K6Q57RieggnFPDo+XvdyGuICNv1vPLjpAn/EtFsVEgaOq7eqI1VnVDQ+BEM89vWQ2WDEsvhvasquu9qlxWydnoJpQfM+SB6uqiwYaJrVHTs1n7AZAQGy9okmsSijOpWEQN7YREAW8c6zl4sHBEY9ARaRdLLqm/yFfEQQ8fcyjRRXp2vxyglouToDgGObSNGqUpbMlG4U0bHE9UB37j8s5jvPfFHuNPleYSe7w72dqw2JA3NyQ9fsW00ondA9XOA87QWTzqOxkT+Z4xaR5Klh48JMw7K13zmrZZOs1M5aB/i225ZWzx3bPQ83Nxy5Jeg6W+qB9V2wpZ7SgCmylHDXP0SxuqDeRtFC5cnr75C8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(52116014)(376014)(7416014)(366016)(921020)(38350700014)(10067099003)(6133799003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bIglRqykE1hSfCFVPZaaFTeJtydAH1X/xxIn2u5N9SP0jjNiKtnstUkpKQGf?=
 =?us-ascii?Q?58GTyBQZ39NRs0cAwCOW3qcggA6M2GgQbUxUQIBbfvYAO2fWUSOa3uw/Fl+/?=
 =?us-ascii?Q?2+UR+/UG1Il/nsaUGNmyFf4nU2W1BrU0IsAnIVUuOyPL/EcJQxmDVlCsY5a1?=
 =?us-ascii?Q?56sDFZLgM6Dcz1MvulttZCWP3H0Cldat2K3hho2OTIrggJm+2jhSVG0ko5ao?=
 =?us-ascii?Q?ervI4ODZhKoQUYOFmNiHIWj5uqLGRpSeEmAU/ctvquggQIHi2BhuIbQ+p2lh?=
 =?us-ascii?Q?Lx0kPnG340SozK0k9yH4P9RJYlsuMRXZUuY23Q2EArQyRFDQi/+9aLMUdHKP?=
 =?us-ascii?Q?lcHGm84OKjytpjPHf+YUlrUre1gVb0SnTCS2N3Ze8bcRpT/1ldfYMZfJi4SL?=
 =?us-ascii?Q?HGMyJ2a4Wd7mjOozlDigYuxx3K5yqg95myYrsAV5nRXWgvYiFD5ZJrjVXubu?=
 =?us-ascii?Q?Mj1riAy0AwP1U/zU59wBN4o7hnFzwW9ZxyX5fnQjKuNURR4V1ZgQrvuyYwcx?=
 =?us-ascii?Q?Pc6QYH+3oIWkQmk6gRWrCS+wdbDm8GJm1BUglcuYdoNNE2zO3LvxInmheifT?=
 =?us-ascii?Q?1zswlOa2/A/Cw19WbdJtStxCMKqfvtl7dFygmwV6Tdj/AF4rpa9a1xA3BHcl?=
 =?us-ascii?Q?PFpVIkja1kk50uDpf+XZbrnj6FLNX/F+qRfyyCI780j3eefuCXDJagcAFpqj?=
 =?us-ascii?Q?G+0VUL81xVk6+meu0hjKKUaiiYwiVFy3pJTdpt+Vid4sN2KF1x/loEd+nLU+?=
 =?us-ascii?Q?FdQAC82Z1w6PSVHPW3psRJQ7xTylMJQqHRkiF4AJStQtwVP43X9lkbNWbDVQ?=
 =?us-ascii?Q?S+iGJJQhRc8f4sl6gGWstTzwPcm0/qpXiRCBTjSr06HvTCW7II+HuIvKZGYB?=
 =?us-ascii?Q?whhSdzUxFfJeFJduFnlYxJ+TNFJlHK4dMWjlcYpTm+IcxMuKPBcCAiIcTVz/?=
 =?us-ascii?Q?uw5wjLh3usBYMzNNqaBCtkBAiLjmo1sqlZzBmsjiaZZQHPz3IKy/Ok7Ic+Wl?=
 =?us-ascii?Q?nmqGqOmMSSFgRCOVdZqL7uF6IvrMZHg3Vauuy5HvSKPsfLprWNxn7emGLjgT?=
 =?us-ascii?Q?rzOHRg/qjOh2auaMdFyLBVA6YNxxvSWYY4NMquk1zyfZG2Hlph9NUXeDyg5Z?=
 =?us-ascii?Q?HFzgYOXOEBaJgSjFMISEjFIwF8LCVnd4XvAsEb8cBzz7ymUg1ayoJhtQTiyy?=
 =?us-ascii?Q?NSJFB45eujGCU50v8EiLLEPkeMc8wySik2bX1dbof4Ze957LQMnmMPOhBvI6?=
 =?us-ascii?Q?XEOExKR7p+t+xvv4NI4fd83lhPCFlI9+Yrr90GNVZL7+tvMaJNM89Nzym0/z?=
 =?us-ascii?Q?khe+sij8MROeSpl699VZkZDr1RJ9PqwrzrOe7XP28LJ1WJ3ogvC3YIZi7NB6?=
 =?us-ascii?Q?VEpU1gkKxT+kFFFxcAooxHjFMdNQfPJk/rGGABSy+fozuyxZ3Aii8EsKSgZB?=
 =?us-ascii?Q?HWYSpyJWuK/Ag3FMSNktJcYCzQDzuowmUtY2NiB9TWs/JVf4hdbGNtETcEa5?=
 =?us-ascii?Q?7HOirapkWLc4gNbNKL+f6BHfrZLSiIq++PI9JAiBHieI61xtt1KTbiEjp0hm?=
 =?us-ascii?Q?hGKv1EczTltl6r12IZLMpXpZRrf1Ol+ZOC4hm8vuZUU/cwKNR6jEjRJhcC8F?=
 =?us-ascii?Q?GM7t7gsNudoDDPYz+EDDyOvyk0eJlfW/VnT0qlLTSdSz9npg5Suk3u5vCQm9?=
 =?us-ascii?Q?IXiEshg8tUvk4aq7jDnvnWFGvEiVv0zMMVUFm6b2aszIjGdJRU3zoehfSVAk?=
 =?us-ascii?Q?1gPaoJd0yw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a15a6919-45d1-42ea-0169-08dee3b688bb
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 03:50:25.3853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49XOTbnn/LLdtUmqxRMUoX0nbEP58323P7XvVVip5ynn6VqMIUpY9xtVuVkxWWjq5GBelNWpa4uAWgbNvgnYSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5205

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/ufs/host/ufs-mediatek.c | 4 +---
 drivers/ufs/host/ufs-qcom.c     | 2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3991a51263a6..98ea9aa2a39c 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2266,10 +2266,8 @@ static int ufs_mtk_config_mcq_irq(struct ufs_hba *hba)
 
 		dev_dbg(hba->dev, "request irq %d intr %s\n", irq, ret ? "failed" : "");
 
-		if (ret) {
-			dev_err(hba->dev, "Cannot request irq %d\n", ret);
+		if (ret)
 			return ret;
-		}
 	}
 	host->is_mcq_intr_enabled = true;
 
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 291c43448764..7d690ea2fa67 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2431,8 +2431,6 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 		ret = devm_request_irq(hba->dev, qi[idx].irq, ufs_qcom_mcq_esi_handler,
 				       IRQF_SHARED, "qcom-mcq-esi", qi + idx);
 		if (ret) {
-			dev_err(hba->dev, "%s: Failed to request IRQ for %d, err = %d\n",
-				__func__, qi[idx].irq, ret);
 			/* Free previously allocated IRQs */
 			for (int j = 0; j < idx; j++)
 				devm_free_irq(hba->dev, qi[j].irq, qi + j);
-- 
2.34.1

