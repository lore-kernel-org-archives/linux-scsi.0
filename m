Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013030.outbound.protection.outlook.com [40.107.44.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF2D313524;
	Tue,  2 Sep 2025 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819493; cv=fail; b=M7iFcGRvGFsuna7NV1Y5hoiWmlf41rAmEh/5C6N9Esd8guKtXF1s92cxjC5p8kQ2811/ibSupObQfBkJOqRg7e6xDXxDFRYUF8FMAZmZSqITOdZFvjADEQrE2zWdQNfw9+vUiKiiDhbxEGNsf2HOv5fpH53u4a9+FqwAlQUa/oY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819493; c=relaxed/simple;
	bh=jFxLa5QtuTei9SskOyGLK/LzaL5fDG1+3kTgMR8AZA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SriZjXW0/v4OqmQDJs8CxXa7bQ5T52IxF6JjumuERcuWkY1xnfXLOthnYv5+ehoiRWZZ+PX8Vv2/Ga+o8mYXkyh1yV9mF59cespJynaW8ussNcFaJZdDQVu4D1iBEf1fmr0yr9NFYXW3sYSSg+pIx1k/7dN6/TfuGATwiBqrgA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=RwAOL2ML; arc=fail smtp.client-ip=40.107.44.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="RwAOL2ML"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdzljPQsTF30rOWsE1YXsYb+jNqFBzRFqouod7lyNeqbOGyzmuIyhuK+IehLd4ou5ozvaPKppdwVm9o7L+LyDaLd6a/Ruu/PCXYVG8kv98u51MgPv5lSahFYFQ3a/OEZ9PzOF7mQ/gxfwVmqDj5wt3HkEIk/DnOxI1+B7nxZNEsSvJ6TPxlr3Xj/JCX2uJTU++LanSUxqlAtyTCblDAcTkYcd4GZ8jk5dkPkbuy/sFuCCSuUNWYqgQ+EbNWaejGFY4XRSFMy69iwu0uTotEc9JMdoFUn/F/HbMtB16G49kZ0WhIqCZPpt3HY/GFzUOyUmhMBh1qqlOgHitqiN/BiNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwrcWTFjoyqA8wW0vtzR0njyab8MVeq+yDuIg6lg9YU=;
 b=t6SHBYAFAN91+9wIJwnyjJZ3GuPYCXy9iGawlY0czVj3yKfYRrw/PLfBrs4N5whZq/vAUqH/CQW9BBNvUXiwNm3xo47bw2fZZbhnQA+xT0LjhtRDDiC5kM+QXlZ8iQuL7vCavfdqea+0mPYUoZdOms3Nd7QtIZ6vQy41f6vGqAl5/KuUcqw8WisXxzPIpvzEsKLhL5lNKst7QGZENDDrHXjHSJQujoHrlLzZ4ddIfvqi9X2rNFWsnkH9MAycKJ3kCccU7uEpgRQzXXLfo9ivEtpL6UK5lmzbFXrJ9A1o0bHxW8WUlwjMCgTodwE5LTBRHEeTK1SJYdY9eGtsyw9Sgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwrcWTFjoyqA8wW0vtzR0njyab8MVeq+yDuIg6lg9YU=;
 b=RwAOL2MLAj3yhQyeRZujN5eB/acXaQ3bhLflJxmbpC+dn20AAd6P0/7+ZRDp3aB2W3WLcEz/tE5Ug0G6hDGzaR6thybFMznWxeUeZJ4lXSPEDFFwPXGqcRCyojBIFx1EjuUkGOYLFmu4S9v2wnfgIGYEnfASCXhSxa+7YQRYOK8FYpl9X7O0UEgKXG3ztn5BR8uMi6NjWP/wNm1B2XERfB4V9wGpxHEqPoLCWbjgU5oZmJhoHIkc/ZfbnJla8PWI13nYlOQ0J/vRVUbAoDRvsZEo2pxIaGSfCyEo4SFZIveEn4/BKV3GL4QyXEP2EK8SEYq7zEWYtVd55k8gl/IU+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY0PR06MB5078.apcprd06.prod.outlook.com (2603:1096:400:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 13:24:48 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 13:24:47 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com (open list:MEGARAID SCSI/SAS DRIVERS),
	linux-scsi@vger.kernel.org (open list:MEGARAID SCSI/SAS DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 4/6] scsi: megaraid_sas: Remove redundant ternary operators
Date: Tue,  2 Sep 2025 21:23:44 +0800
Message-Id: <20250902132359.83059-5-liaoyuanhong@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: b4e86ad1-e283-4722-f64c-08ddea2416b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hi6s5x+SQ0GIm594d6Thf7v+SzLMLgpYWC0qpjuHWQRgm30uOrkNrneD5HQQ?=
 =?us-ascii?Q?cYUirEYPnXBhQj1Q6G/QfB7F1PTgFAM1q5TSpx0nyZnyzslMzGttd/zHup55?=
 =?us-ascii?Q?XkcHGJPDIfUJ0dbZijR1JFmgdQAxXCpfbLtDep41+MHy1gd1lGR52JscpPMH?=
 =?us-ascii?Q?4JSTvt5mzXiZrY8rw/wKF2+tYk6tyIqDNMAutitsH7LSHbICYMLBrubeXFfu?=
 =?us-ascii?Q?vwJkh9hF+wwgIFQdlDJJRKEfk1IMPjTEUc0a/NljLc8BS0XCOv25oJlzsEe7?=
 =?us-ascii?Q?R0cBTypX7O67i+ICioDJKzUYvmvUAMXDfZONrYchRMuvJH5LF3JDsCwtyyv8?=
 =?us-ascii?Q?6+T4H9Vn4Ps0sPg6aRV4OqfcCzHF0F39JjXUC72kZCOqCjuowExgUECKNcap?=
 =?us-ascii?Q?yIGhPjeHYSXu1rt5TD2AL1/RjendGIG/+HGtGL448HXsxaOwmjbl1xE6UQsW?=
 =?us-ascii?Q?qCFmD04HMiSKRMa4HTNA434o8Ry0Q4bdTEpH3OuRlkfLa76fGMjh4F2ORmUz?=
 =?us-ascii?Q?cJzz/vL5C0vJ1DOZi3UFBAn1V/hsSqL7kDMj89glFMclTMOGfAlPoTKMlj/G?=
 =?us-ascii?Q?ZOckeRDQW6TnOvwjlWXAjCwVZdQd6yElI68XbDGfOfUDwSPjHPOgqLkir2ke?=
 =?us-ascii?Q?zRFdiEMaKXMoZeLfekwxH9dMVvrG3jzHbuAMBAO0dE4lG00nXkrcqgcMHjkE?=
 =?us-ascii?Q?pCw1+O36fYe+aO1The7CO3ceCVsUFOHGwAziYh6h2FjSz0hvviMKvffNE/Uh?=
 =?us-ascii?Q?QEqw9/LBQaMLBpJLrcJKhZawCepHvYJXibtBiq+QgJnBmyzM6WpmQ/jfN5HV?=
 =?us-ascii?Q?CYNWzRA0dyBNTNDkD4S1DMMu79gpTjwiwHTZSR5l/cxHAyfWO08idSnaCQvH?=
 =?us-ascii?Q?jJJZXGq2/s2SA7SExymOm6GNHvTZ28mtsMXuF1fa23YpnJitozYIyTYgGzxH?=
 =?us-ascii?Q?25ezDx7uZBuiJmLFVUhSbqgHaDQLqwoKUjnD1jaZ3Szv7yu1p2v7THp7oXDC?=
 =?us-ascii?Q?/Opym39dqQr11fQO+to0ip7mIujMIxJBd75NMMFbV+80BEcVUZVJ+ukoDSWV?=
 =?us-ascii?Q?8hSd1CdzA6cNyKRIZsa4jX8yK/l9hBi7f3GdmaaMIgIM0vGVqgsumyp4rrtd?=
 =?us-ascii?Q?j645KrIozTh7qm8BKiJ4i+k+DAwO2fBC3bhPTUbf+TAFW5KNmRvHsgsC+jDL?=
 =?us-ascii?Q?W6flhiaKFXznDuOqIwhD8EU0m0Jwrfr4QdkGssZtpVFmGbEKz5ehT8QiNwvo?=
 =?us-ascii?Q?gFSRvKbmrv8sC49uDI9QJzNfZGg6jc6GdQvbiRpxGw6ZQ/tOfag/d1pZn16Y?=
 =?us-ascii?Q?4lbq6pFxqrpTIfvjZzcq668rAuIB0UV8uq7dMDvTl5zWG4Gp96PHiSGITdYR?=
 =?us-ascii?Q?kKIfYJ5/O2D4QPARKcNmEy6USuVyTWdsXA9HUt9AfGATK//oaoDYcZeVXwvp?=
 =?us-ascii?Q?Z7z7PZx2rKd3GJ0K30dQYwOMi+Q5RgC6NMMhWXBxj9mwh1GjOjlCqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6X1EY14QVXMTGnqPJiYBOzH430q58ODPQ+Ra34OlnazjrCQ3uPTkiIXN0QDr?=
 =?us-ascii?Q?xb3b4N1GrRK2P2zS86ez2XM41XhGFI3HO7ktAEEt5xRIe2VbwWD2hXIkf/Qy?=
 =?us-ascii?Q?yrYvlofg5pLxFRh0f79lRhupRVjz6Q+m6aLjncE3tqf2gzwuXOrqtPfcIw6f?=
 =?us-ascii?Q?dxXsQGc5z+9SiIOI4HtsxCkF87tK1V0Kp1+XNUR8b5oluv4N8IEY9Ey+zdey?=
 =?us-ascii?Q?Vum/39cnRlHbCoWfZ7NkGWtogwKqwOkCClpfgCSi4hyZsQeQewXpU3dgw8G0?=
 =?us-ascii?Q?8+zYjmTtkkOTvewQrB4++38uxPdQSoV8e96ApXG+jUdyiIGRqXHTKpUfCdll?=
 =?us-ascii?Q?nJYvn9rVUkQUPkQ1rso1bZLqxUxDiTrj5clkuG35HH/pMKDc7hs4Pkmt7mFY?=
 =?us-ascii?Q?4+095x614aQJT/i8TJUFgAHEVIrvDBh+9sIHHU/7aMc+p6cUJmPkOyQ7XiIO?=
 =?us-ascii?Q?TsEqdwf8WPK1CrRc3Rq0OY09/kjjo9M5Wnbo+a9Wekqin/g5SANBloI65JAe?=
 =?us-ascii?Q?MIipybVJ+S4CxSJgGpSiejEzpwhRDukqdlHg5IJxPp94dnuHi70gaTLMWM4/?=
 =?us-ascii?Q?+G9XzRbylPm8YMrObkz/psQMbqf3DTYH2UeFxPMOZKnB3aLobLV9pTpfwCKO?=
 =?us-ascii?Q?xCp7ciJ/bUUo+sr+vQU0/L+uSWo6z5Udb8MFgBSbJ6vNfDm8K9ZywDbiM+aA?=
 =?us-ascii?Q?DdoFhSg51o+9fIBcdGocUqugCKgmOKm9U3izv6fyGi2PKjAUHdj7/p1m7PJm?=
 =?us-ascii?Q?IaVy61Iku2t4Bv4A7ov2zFZL3X5jKO6Ra52IuGE/T03i2Y7dLuxMyl1tkDR+?=
 =?us-ascii?Q?n9b6iNMoE8IMS2VPxZ/0EfNzmerh9E8rZ/uQ+N2FUgSSZ2OWsmOo7m/Gzq6m?=
 =?us-ascii?Q?W7oQWSkNy63Whuyj0mt/6FdkU69icZln/DwHGuF5WrCmWW72+e5as1MrJpwd?=
 =?us-ascii?Q?pbz/nV5Q2xMkSldehyx7FDGNGl5tOeO+/M8YLRn7nkKoD8ny3vwhnvrbcjUt?=
 =?us-ascii?Q?I/S2imVW3K7FGKDoJY+ulSBtfB8U9tb9UBb3tzA2sZKRwkf+e3EmguInF7hx?=
 =?us-ascii?Q?Kngs/4hjMt+JYCyH8IiVu/om8SQGwYukCL7V/40eYt1w5/4MbHPlQJcPPykf?=
 =?us-ascii?Q?FOLN+/71yzzYRkANBwD6mlQ2G6N/YqxHSDQ6vFBTeAfp8KytKlJJmLwHXQh6?=
 =?us-ascii?Q?rboI1k5u/Q+5EwonNCsv29UFZ1Cmyq3nIHtz/863P2qdd0Em0MiJ7K5Dt2TV?=
 =?us-ascii?Q?PFZOuUPePiVLduxPltEJes+uJKUAjbgaCmD8LSdNfa0vWe4S8/vQMEZn3oHR?=
 =?us-ascii?Q?NVNNsLTYPVHVhohUYvj59rDJ2DqrQP/rFqp/pWHBwyOVAcp8d4fdIILwYWXK?=
 =?us-ascii?Q?7c62Q6LY2vmCp42nk+bKXo7PqJALspBEWYU3UxkziO0McDiTccoE4BIcFcNp?=
 =?us-ascii?Q?7mv+MSzHhYWsLuB/8UIJWMoMx7dPS5L3meIzrbOxi52mksfFHRq+OlC99dQL?=
 =?us-ascii?Q?IVpflZ6i6ZJZb/PLV9O1GpBF7wAQCDpwNtiiPcp8mF8iOR3xftYnrl6bAdcN?=
 =?us-ascii?Q?Kvj+ylBY4zAkhCOwiD68NedP4Ya+olnB7wdTqkTn?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e86ad1-e283-4722-f64c-08ddea2416b0
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 13:24:47.8703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L83R86hC8tYoKkd+RpeJ9UG55/qyRY7OA+i3SuWmRFaCffCQZElAdkBF5jcPk2B5bmEWD/vkMkRxxoab9fASxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5078

Remove redundant ternary operators to clean up the code.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 615e06fd4ee8..25589ade8409 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2097,7 +2097,7 @@ static int megasas_sdev_configure(struct scsi_device *sdev,
 	if ((instance->tgt_prop) && (instance->nvme_page_size))
 		ret_target_prop = megasas_get_target_prop(instance, sdev);
 
-	is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
+	is_target_prop = ret_target_prop == DCMD_SUCCESS;
 	megasas_set_static_target_properties(sdev, lim, is_target_prop);
 
 	/* This sdev property may change post OCR */
@@ -3448,7 +3448,7 @@ enable_sdev_max_qd_store(struct device *cdev,
 
 	shost_for_each_device(sdev, shost) {
 		ret_target_prop = megasas_get_target_prop(instance, sdev);
-		is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
+		is_target_prop = ret_target_prop == DCMD_SUCCESS;
 		megasas_set_fw_assisted_qd(sdev, is_target_prop);
 	}
 	mutex_unlock(&instance->reset_mutex);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a6794f49e9fa..cd9fea07e563 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2835,7 +2835,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	} else {
 		if (MR_BuildRaidContext(instance, &io_info, rctx,
 					local_map_ptr, &raidLUN))
-			fp_possible = (io_info.fpOkForIo > 0) ? true : false;
+			fp_possible = io_info.fpOkForIo > 0;
 	}
 
 	megasas_get_msix_index(instance, scp, cmd, io_info.data_arms);
@@ -5121,7 +5121,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				    (instance->nvme_page_size))
 					ret_target_prop = megasas_get_target_prop(instance, sdev);
 
-				is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
+				is_target_prop = ret_target_prop == DCMD_SUCCESS;
 				megasas_set_dynamic_target_properties(sdev, NULL,
 						is_target_prop);
 			}
-- 
2.34.1

