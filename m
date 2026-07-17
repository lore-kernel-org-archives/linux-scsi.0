Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012012.outbound.protection.outlook.com [52.101.126.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EE93B3896;
	Fri, 17 Jul 2026 06:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271532; cv=fail; b=MNL+DY2/g/DmChu4NVzirUYFupcQ3ssRCENzNxsKrIz93WAvE/bcz0IfEljX/n8rczR2cfhDkgLnyrAx2hGMEhPgTDXZGcBSBIerRa4jm5SqzkqCiklpO1CMdkUlOMjI0RBByYCRLYAcbXqn7SbHqKmOrPIXzIUikQVYzWcROwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271532; c=relaxed/simple;
	bh=meKssChRMNCmuPRPDZEpPDCe4Lj1uoVoeUEx7a2dzOk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=i3JkpAVoKhYXArOpjTqAzKVBLiqCGYbuaRHw9mBFIcHrqFwW+TiH+/Bsfg/rL2wbonDNW5rr3EtC15AIXo5MpxGyVVtCHsjVPJVbiJ/eNUk5UBTDfRO9GmXSJm9lnSrUDI7nnlR7Dtx13NL449FENbJh5DzouvQcaHwYSH6Dka0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qF+/giUJ; arc=fail smtp.client-ip=52.101.126.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qF+/giUJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pyYZr4Z85/VpeaZ9SZzHnlyTSqDlB5mxQREj+k/Wsv7BxcKoGOhn+2DdC6OeakinUZAVGuxsQwNqXXSeagKxfOIAdo5Y7nbpB/22yE94Y8NgY33wr91ZIHVRizZr5a7FxsigLZNOZK+y5brxC20jvqBkYEXo9avlUTBQ1MlNrZV8nOxcTd5cfYjRHjR0cr42o6Nghxgm0z+uMn6t3ocsNWKGJXZDyDF/2CFF287yAgU1MNG824xF0ZYj3uvWKvnpHW6YUy7rStuvS7Vos+qJZtznAZMQue7kd2+hAuzgRkH/PxzMAUfczooL7nkm0Y6/9FwhK95D7bnat+oXwqLLsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpFDJ8UM3rxzh0eeu8Vrbau/J62H98P5id42U/NktZQ=;
 b=r5IP/MrnVr3EtVQqqX+M8Dc859jiv22Ffn6DZcG0E15JzH8HwvppaB1TZtbU0y63qpw1LX+we+uQU5WHoAIAD61Nxtt9Bgv8BZDD7aZELIsNxS5F1GlpRvg505wDs5gdIeVjMwPqy3u5qANUrGV+0wgRjB/d3S5IhnlTQyyIxHrkR+nA6JyV8jGegaBNiKjK/O4LYx67DeHkeu5rDEFGJkAXvdj6BR2uv0VnokwKmPvaD4zhlOemyNQEgzcrCPHKHCa96kDVEiFk/bYdvNLt2YFhJs6sjnkojAMoGpxSqpiS3zWIoLJTmxKjVE3smXxjM5VmwFCjlZ5jvVVX2S31Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpFDJ8UM3rxzh0eeu8Vrbau/J62H98P5id42U/NktZQ=;
 b=qF+/giUJTZrfXUwW1MOI6zfEm2nER2AirXqrPKmiNzO16NO6ZkqhRz+zNuIgWqtdc0Z7qXDVZVHffv5o7MI3yS2T6TJQzgarF6Xc3UCBanFjciV8X0k7ZspuF01J5NUpPhuw45efGQ2kahpZqBwQ1EVCnVYjn/Gma+1NNIMUsFZ762WVPDwhPC3YwXooct+Sgy16AgQ5F/u0iMNoog02KbJm8+MjZGvoUChDF/W32ZazsdcLSRaKHtib8zGDNmDeEzVEt+j893s8w0tosygjPg0MokVzNnCDEIAPgP5F2KI0DIAGAY9143IQhlkv4iytS2V7Px9ubPQs6Z/hox+k0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by KUXPR06MB8389.apcprd06.prod.outlook.com (2603:1096:d10:82::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Fri, 17 Jul
 2026 06:58:48 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 06:58:48 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Yihang Li <liyihang9@h-partners.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH] scsi: hisi_sas: Remove redundant dev_err()
Date: Fri, 17 Jul 2026 14:58:36 +0800
Message-Id: <20260717065837.616599-1-panchuang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TPYP295CA0005.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::15) To SEZPR06MB5832.apcprd06.prod.outlook.com
 (2603:1096:101:c8::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|KUXPR06MB8389:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bc4ba87-bdb1-404a-c0ab-08dee3d0d9a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|52116014|366016|1800799024|38350700014|6133799003|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	Cyu27FDHn9YPwqO1SSNb7/TD4CtxAX3rmJaOQ3PnYEaJwhM1ku/HGQQ9TPXx0nX7u5cGn3rWPBqF0ofh44elFo/xjwXlgzKgDC5L3OJWTVwJEeO7XEIBEUNjukh6cHCyppJIWgMpY/9bDg6Gb1G08mJ6z0eQ1RLEpqwKXtTRdzObscUFmJmZopsUfJfK9TldAdFVlsOBsW1KeXm0WWXzvkTk70YhSKl7/gTZXDeaoLEbCPN8Nx+IHbO8EgVVp1Mcd6jYJhJqoX5nJpaEKn22PMVpw7Fubzmdzihtcby/AvWkZQpszDZ/3EembgalioKkRW67b8YkSVeLnIQiuoH1IAKzR9dLFkiASGL8s3JvI4JlNx6KA4MMvqD4Wvn3AfNB6voXNN3MAk/FYvrPVM4e1zwy6cELdCNZnJfgeQXJGaIabKGjoD3beGVQYHzFkLYuueHgPQImA7iO4Svx5BU7bSh1cverWBGvkWUrw0ZdnTb/z6hdasCUxR7AW4Nb4UeDgQuhMTVlMbkud+caQCFg6bkiCbl6IaP2dOWl/qD57LhCBFYUpalq2iuHKKHIZehhpbVtVajoxHtszSL6SvkJmnttHzlGJz8hK6btjHQEskNWM+FU0t9vUtDdjJHkHXgJvukEd1Tleg2K8TE0uchfYskP6klc0dunRx8vMQxeh9lLjDfAabVX3RpUFiJ/+psqezDhwmnX/qMAxsf8Ptj5/2K8BNIR4YzcwbF/O2R2t7w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(52116014)(366016)(1800799024)(38350700014)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/+wYg/Y6gga63vWCoyqNDNYougDdWbb9RgRDg61op7uw/cMgZsoJC0+HGeSB?=
 =?us-ascii?Q?t4rZ+tqSkDj0fwJInUPt2y+K1WVK5EjH6iAjkIgU0ZXM0aZojRveKHg6xbyV?=
 =?us-ascii?Q?WW4ezEYsyYtFaV/xmUjxNoqxxQ3rf4qka7J3U1UggsoU7KKjtHhCCU/GxEL2?=
 =?us-ascii?Q?FHhajvgmSmHQnopo1PHawvyxmGCLt5V43h3EbBdmbU1Gc6bD73VKGyq4Oopz?=
 =?us-ascii?Q?LOwauMvK8R9vKxQ0Son3l+tM2u7ZbJtqOia+xKuH0OnBGQXTJ6N3yEQMzojl?=
 =?us-ascii?Q?lPQ2i3lBBH6WHdc1Ytp4d8u7JogGhAOeYRr5hyjV+qfOKCaSiL7dnXtsyuwC?=
 =?us-ascii?Q?JSbgTFsQIXg8t+o6IfyQUdLKlLgYob9og7VzfXGZWzvuVhZJDwzGhbfRZvKl?=
 =?us-ascii?Q?Tuyh1lTY5xa8BqiCq02yofiywu/LtQ3NYp6EuiUV52v1sIrIJlgP+yww8DJc?=
 =?us-ascii?Q?7Q1R15AN+qtYAX/vZ/lUGnYV8CcMymNMh2tGPs58+1xeKCWjkin6whuZ01fb?=
 =?us-ascii?Q?2J+i1DJTMLx9hn4ysbtFLNBQrSXRYqCGlt0QNtcU0vKOSzOyZjwvmNDmwBKC?=
 =?us-ascii?Q?F7/P4jr6VJntTsx9BmFOup5j/BHLZTDHMYLdVVZioynNzn+gpWWGQukPLIHO?=
 =?us-ascii?Q?sM8c/zrdUj/R0gSIcXjExre26Mxf4Z7dQpitRDJna67cywN/hWxNWONfgXTY?=
 =?us-ascii?Q?Y5U+jywO0iYKnr8ze6K9N6g3vOtJivLP8UUiHPVpisSH04YmPd8Bob9IzqZy?=
 =?us-ascii?Q?L97yP7hNda3Mhgs0lOM62efsLKCfQH6JFLd/IvmMkKpdlCD7WSiSQp1plXgU?=
 =?us-ascii?Q?SIUZoikKroYLufwVCqZW5EYZdwOOpT49KtqrTviV82L+2Fo1YH6xRd/gxCj1?=
 =?us-ascii?Q?u1B6u5ZWKDPj0xdwWPz+hGtlX1hddV4vQOc5hyzP/HDD+3r74n7kyZ4rkYS5?=
 =?us-ascii?Q?v+VrXRyowAEsGAA5+6hXP4/bKQ7KJm1/BtS23+8UIs8HVdAZOLZa1rdPOJ2J?=
 =?us-ascii?Q?X9QBLjXPFiiMZt+UfI7BELnelkf13Fco8yXHVQipox3VHRWvHcE84iVBcqOG?=
 =?us-ascii?Q?QIDkS3j3z4pXW0D5cf/7vl8U6U95y6akNpAP2YOZmqidBnbmm5TKIaqOA4ka?=
 =?us-ascii?Q?UqalIsYCsmySaqiqqgB4UOchpBCBVC22RZ5sN2zCGzAOdOuQ/LTAxR3axwtz?=
 =?us-ascii?Q?b+XS7BaSFktvizE5pxrPDKmU1s0fFmdaoS0ThOPk7YvViw+hZ/kOx3aM81zT?=
 =?us-ascii?Q?cpv/PsJIX569BNQrRW/MKNsuJHImxu6RKCmZxsWlmRWVdq3qNobtxSYWtSLJ?=
 =?us-ascii?Q?KOR8B14D5btcKANr83l7tv/JooRccNXCt2YV5/od5+a6w34oxduJRR1CpyjZ?=
 =?us-ascii?Q?NxySGOXKEprZU1hVWw/cCLD3TTya1Eg9GJCGDq7T8qFabmdqu8PkmUVt3tPE?=
 =?us-ascii?Q?0e+ksViOBzkA9kQ+0ASR9vl70sxho7tAgPvXZmjA/vS8b2IYdh1cpXg2PKSu?=
 =?us-ascii?Q?wTiiXKRrtFtth6TIRS0KnNJLBpBX9UAQCaLA3KIuKeLEw1tUUVnmngvUJKCE?=
 =?us-ascii?Q?9RjuvDhimArcLJu3+uE7LeyYuSCMCBoNjd7K0bbv4insDbM3LQ3MOW97YE8g?=
 =?us-ascii?Q?I6XezsvME1DDygGUTSUDTDXpNdiAgx8jlOONWs5fZTxIQWt9wqNcQIJeJHO2?=
 =?us-ascii?Q?CfuGa1RRIOORed24rmFsecWB+4AlEkl8sYADPbf7BS3u5CTYfQqI75vA+hBr?=
 =?us-ascii?Q?7ccti64Viw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc4ba87-bdb1-404a-c0ab-08dee3d0d9a7
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 06:58:47.9449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ohbP5yJSUUBdO99gUIZxBCDPOzQ38HzlIoNMcrDkAhHUtP1rFAjq8ZZQMa7rATFTekiE6eC6vObQBC+TVRJAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUXPR06MB8389

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() and devm_request_threaded_irq()
automatically log detailed error messages on failure. Remove the
now-redundant driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 15 +++------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 --------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 ++++-------------
 3 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fa94d7110714..17974a57014e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1638,11 +1638,8 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 
 			rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
 					      DRV_NAME " phy", phy);
-			if (rc) {
-				dev_err(dev, "irq init: could not request phy interrupt %d, rc=%d\n",
-					irq, rc);
+			if (rc)
 				return rc;
-			}
 		}
 	}
 
@@ -1654,11 +1651,8 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 
 		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
 				      DRV_NAME " cq", &hisi_hba->cq[i]);
-		if (rc) {
-			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
-				irq, rc);
+		if (rc)
 			return rc;
-		}
 	}
 
 	idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_count;
@@ -1669,11 +1663,8 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 
 		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
 				      DRV_NAME " fatal", hisi_hba);
-		if (rc) {
-			dev_err(dev, "irq init: could not request fatal interrupt %d, rc=%d\n",
-				irq, rc);
+		if (rc)
 			return rc;
-		}
 	}
 
 	hisi_hba->cq_nvecs = hisi_hba->queue_count;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f3516a0611dd..a7d7f3091026 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3338,8 +3338,6 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 		rc = devm_request_irq(dev, irq, phy_interrupts[i], 0,
 				      DRV_NAME " phy", hisi_hba);
 		if (rc) {
-			dev_err(dev, "irq init: could not request phy interrupt %d, rc=%d\n",
-				irq, rc);
 			rc = -ENOENT;
 			goto err_out;
 		}
@@ -3352,8 +3350,6 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 		rc = devm_request_irq(dev, irq, sata_int_v2_hw, 0,
 				      DRV_NAME " sata", phy);
 		if (rc) {
-			dev_err(dev, "irq init: could not request sata interrupt %d, rc=%d\n",
-				irq, rc);
 			rc = -ENOENT;
 			goto err_out;
 		}
@@ -3364,8 +3360,6 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 		rc = devm_request_irq(dev, irq, fatal_interrupts[fatal_no], 0,
 				      DRV_NAME " fatal", hisi_hba);
 		if (rc) {
-			dev_err(dev, "irq init: could not request fatal interrupt %d, rc=%d\n",
-				irq, rc);
 			rc = -ENOENT;
 			goto err_out;
 		}
@@ -3380,8 +3374,6 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 					       cq_thread_v2_hw, IRQF_ONESHOT,
 					       DRV_NAME " cq", cq);
 		if (rc) {
-			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
-					cq->irq_no, rc);
 			rc = -ENOENT;
 			goto err_out;
 		}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 213d5b5dea94..b9dc28cbf785 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2631,26 +2631,20 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, IRQ_PHY_UP_DOWN_INDEX),
 			      int_phy_up_down_bcast_v3_hw, 0,
 			      DRV_NAME " phy", hisi_hba);
-	if (rc) {
-		dev_err(dev, "could not request phy interrupt, rc=%d\n", rc);
+	if (rc)
 		return -ENOENT;
-	}
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, IRQ_CHL_INDEX),
 			      int_chnl_int_v3_hw, 0,
 			      DRV_NAME " channel", hisi_hba);
-	if (rc) {
-		dev_err(dev, "could not request chnl interrupt, rc=%d\n", rc);
+	if (rc)
 		return -ENOENT;
-	}
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, IRQ_AXI_INDEX),
 			      fatal_axi_int_v3_hw, 0,
 			      DRV_NAME " fatal", hisi_hba);
-	if (rc) {
-		dev_err(dev, "could not request fatal interrupt, rc=%d\n", rc);
+	if (rc)
 		return -ENOENT;
-	}
 
 	if (hisi_sas_intr_conv)
 		dev_info(dev, "Enable interrupt converge\n");
@@ -2668,11 +2662,8 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 				      cq_thread_v3_hw,
 				      irqflags,
 				      DRV_NAME " cq", cq);
-		if (rc) {
-			dev_err(dev, "could not request cq%d interrupt, rc=%d\n",
-				i, rc);
+		if (rc)
 			return -ENOENT;
-		}
 		cq->irq_mask = pci_irq_get_affinity(pdev, i + BASE_VECTORS_V3_HW);
 		if (!cq->irq_mask) {
 			dev_err(dev, "could not get cq%d irq affinity!\n", i);
-- 
2.34.1

