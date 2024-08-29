Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010050.outbound.protection.outlook.com [52.101.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D26718C021;
	Thu, 29 Aug 2024 09:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724923065; cv=fail; b=OU5PZPupk7rzyzih2b79uJz+H4/NWztf3iDLYQa3gcoXPJSA9FBfgIA5SS4/G8Fv73I4begFumL+LAqA90dhFNBsqsOEcKj6C7zrBVIcSZ+XhCfany9xoVWSAlfBYM+DVT8N4qJieN4qr3mLIZDW2sfqFc5Hb+mAeOjRXQcY54s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724923065; c=relaxed/simple;
	bh=USPwK39mJe1xLu33d7Waz2jX3wxnF0n6pb4e/47QS7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=c8EbP86/hEYDcJC0JYAgwnty7MNdL+BfH8UisimGI1p3UQ8/fyXHvvMkBCNAzGYRIWEcFfIboUvokUjqOS+mAp4BDrudnW3jcifTWhdvfvvLJNzrLd81Cmpy0P9YOfAsbK3OtYzc8dvVI+WaPgQAkNa7I0ApkvWFTHT4jzm1uy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=dwZdRovs; arc=fail smtp.client-ip=52.101.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="dwZdRovs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XiVu2YHyAjLkaa7AKTCsd3kjyjaGkRvwiY+4rG9ICo/79FF5idb1Hq+e+QUmcGvtADXzt2c+3wVbzu9Q4S5C6OK5YV7zkLbg15rd02KQXJSLs9Jxj3C7tk/bidHScOBFUjEx22JgGL59gEe8M5sJoHwyp8xwld/ExTh9GrqsCbQx7VbPNVdoMmkfX58xoYqg6zN8zzLNKqJ6ukw56iOg2S6b9s0/ZOFd1d/S9PRXWdXBoxagJH16q4Ez86rC3ShKF8w1I/VV8THi0isYDNT0/TUljnLp6bdG8DAywioBn/c1P3xyEhAVe/Fy4pmtY39PRAqz8yDOtpnGrkGQdlP2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmmEY07d8lBnZiM3FqtAjTSxVODCzzqIZnxAl1eqmbg=;
 b=UUck7ODlXumXuMKKzw0NqFcMjhrxYMy3sVYIQD6atDpGCCLaCyhJQ4bE95vGGvWSNjSwq4O3z2LFxThGXZrmXJkQit+ApQFWtgW2fAgJ4GeTKuUVCWKl7J35DEZI0A9xYkVzLopRl7E9rnMLY9KZ+fqJxPquVNP+6olnr/uKheekYo8cL8/qCH8L67zN1nivKJjhy3E1l6t4gOyTVWX3rYs558GKfUQ0qBk083qB0sZTs68aBKv/EU5DclQ5hhNlGEBjAl5Caspljm/TMG7/pzdggtWBoNX93uwqkhgvg4mzS9m2oF7Bl9Q2tHCQ+UQzyLAy3Zrytgx0LfLreQhdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmmEY07d8lBnZiM3FqtAjTSxVODCzzqIZnxAl1eqmbg=;
 b=dwZdRovsQTloLaQlV+FBl5cGojQNppM7eYTGVIERYE8nIhpX3SERi2yjjzn++NfkIklQSQ3ZmaA8jVUwZPs+Wi+YPeMh+wsFIzNBenQWCuv123acpgn6zLnh3ormbD+83KgCjZJjJk4NNcEnpXsdhjhgiD2ZifytLW66ljvFB/nG6de2NzJ6pktQU26n8QblDFrJCnBCy29IaFokUTYgHU85gtQSsNkZAM0CY626aV2u1gesJ+xScsEoWjQsrLFMemaHtBl8gK+F4VpLc3l5jfj36qTlZ3PLdDVvF0NfPNfVxPH3Ej8syAcY/DdUMhUDfmh0NufMomSdBXU6dFeJNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by SEZPR06MB5878.apcprd06.prod.outlook.com (2603:1096:101:e0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Thu, 29 Aug
 2024 09:17:40 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 09:17:40 +0000
From: Shen Lichuan <shenlichuan@vivo.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	m.muzzammilashraf@gmail.com,
	opensource.kernel@vivo.com,
	Shen Lichuan <shenlichuan@vivo.com>
Subject: [PATCH v1] scsi: Convert to use ERR_CAST()
Date: Thu, 29 Aug 2024 17:17:26 +0800
Message-Id: <20240829091726.33984-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0039.jpnprd01.prod.outlook.com
 (2603:1096:405:1::27) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|SEZPR06MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: a39b46f6-8ba1-425b-692a-08dcc80b6e82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F+y7cKW4YdhJjr+VvD4SYJN6Bpt/VwLSqT5H1aVvmceWdaXCHML94j2RKkZ4?=
 =?us-ascii?Q?zqqsDgMh9tik+4NEestb7Hjun8u8qrjpPQH8to2/xXDyPKNKg6zSD/mfXwIP?=
 =?us-ascii?Q?EPKPVJ5tYg/fFp0fjFRMvdjg85no01SkhUEBcFUpEWDIfQbychIxjGzkuKHo?=
 =?us-ascii?Q?2Xa4nhCYzjBBHxrUuPhNhjjOGWwJSuAbOUxdQPmVFkJn+D/vXI24i9ZS114U?=
 =?us-ascii?Q?mYiyFeNfw+E5aM0ZsWhv+r8TocoJnQ12JHd3Ey7T5fz+GPvv1jFsZNYTXv6h?=
 =?us-ascii?Q?vHCmV5UhlKDCP8dGXlKH3gFWVp+l+2Ykd/AaFObpJ5vUsDPWKIw4s7d9gSOE?=
 =?us-ascii?Q?VNxAGVuzNjVsBY8h80AahsIziuwNyl9YDF15r/bqYmCVue/uCn5ZV+BdSwoI?=
 =?us-ascii?Q?zjnVBfOSIaODMaEuC6MDpWJJ3YAKcptCL6tld1Rv55h7IeOo5Owl3UrTMquv?=
 =?us-ascii?Q?pncSqaxzKnB0zS7W3XlYGk9+4hYocK+RT9NpGK2N4wuOp69T8HDCmQO/2yN/?=
 =?us-ascii?Q?jTcrm747Xv0/Nw6QxRs62zhx7IzG/0bMH3MHmBcl2JxbQ3Kwa82cy0DiytTe?=
 =?us-ascii?Q?ZdcpgTRHpUtDkKtxcwkwd+pMtDxgIFxdsQpfCb5n1En/jsqsqo9wlZuAnEyn?=
 =?us-ascii?Q?kqL5aYbUNUubL/x23bwnX4om0vzQGOC/QzGskrNiTIQUMVLFOzlVj7Dw9/od?=
 =?us-ascii?Q?DvxSCRLxwcDe2/PrbBu8fma/Bf7FVm8gkIUAMAURWESYo8KJHLfFr3ssFQ5Z?=
 =?us-ascii?Q?mu8u5Vbv3X90KbYryZLv7Zu6gRkmFcYstGO041ufJf6JxwqVE0mvQ1kguCC8?=
 =?us-ascii?Q?KC3xZjN4aweBmaq9WxvpP3hpg+kE1pht/lCY9VsFm0Z+y6KlBbCF19X3HWyR?=
 =?us-ascii?Q?8Fl0TszclteC4uDyLDK/xvQ4AKkGmrkD9lLVts9mndcFyGGaC/Tqu6JUfpd2?=
 =?us-ascii?Q?TX0RP0EKgmOwV6HNn6EuoJfdflHinfXV/b4juAm+cGCXMt675yKuYaVLLLBW?=
 =?us-ascii?Q?6shCp2Gz+P3sokvPKFtvloIjwXUVyAIGDL9jHF7Dwwo+Bdm24pn7pGC/gSk4?=
 =?us-ascii?Q?aBXgbcNB/AT9ZfSIvAELtbIt4pc4Umk5cp1dFBNcRbfIBtewGfShtVgIFioh?=
 =?us-ascii?Q?R1EslXMhWsOHI2osqBOZXshRF9lsfSYG/g49kJQ1ybElRDwxXO0DxHY8eCDE?=
 =?us-ascii?Q?GPhgbZIzpY2yLmZ0r+3HMG887Jz2Lt8q+GLtj6pKc0H+WwwrDXX786li44JY?=
 =?us-ascii?Q?PURZIi0niBZ7k4pAgdLq35nTvZPrjTB3KVgyQuOY3H3xtTSG483mGacw8mtf?=
 =?us-ascii?Q?M0SYALyv4K6LK+p2cxyJ7AcZ3BbhgitET8SeCLifjtUx8qEOkcuNdkoUHhrA?=
 =?us-ascii?Q?k49kF8lgdthvcVEaQqmPmj3CPiNRPjbhIIMjgGIR33P3NUcfDg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j714N8RK1d15lw/TfpaMO6v7NYDbb0MOJbI0vG7ZKHzHtWpxQbpqCZyaFguU?=
 =?us-ascii?Q?edTiDImPwHyOkvVAYsv9dyNjbE8DKXb4RuW5RKCWOJk+tGSHkHrZDWXc7NJK?=
 =?us-ascii?Q?v5x34B2w4fzChfzwm9IuO+G6MXnG/YvNVaYt/0UJIicOj71yKcKwwpe+GVHJ?=
 =?us-ascii?Q?+DIWa7StAkXY+vfEZm76OI+QmeaGUTCm7yoz5lS5+x0FuWjFAGbQbmKk8J4c?=
 =?us-ascii?Q?O0FqxXKi23W3wAxPcPY6i8sutq+Ez2BIFnGWiz4v/ie/y0tRVELjDtHGQsXr?=
 =?us-ascii?Q?xEyUCYWSH3YquJJGhwXoapWKzA8hcfy+c40EZiKWZWuCrYTbdC6wicOo/DTp?=
 =?us-ascii?Q?+0py3ZsexqoX2VIghAX59p53u1cFfBa8WzVvgh/I5CA4p4nJZ8r3hk3I7xtX?=
 =?us-ascii?Q?DkCUYYwyyXoJQVeV3lr1c6Sc8YhnBNeOoeok/WCfRHhftaKk5hSVYywiCJv2?=
 =?us-ascii?Q?Cpfv4CeQhITlM96beMO3JvGnezjWK1xhRqnj6iTX4AbIgHd+nnReR4TF51bg?=
 =?us-ascii?Q?cqRrWEyAABqqm8ZKN2lyPodNLWTeRrieu/nSvJfAZrPJAnUag4/sPnYpFFzr?=
 =?us-ascii?Q?Kx5Y86i2B5eKcoeLiJOZQKVGYdnYrr2+Qk/v7wFJqhP7Oxj6Akv1ImIKT1fm?=
 =?us-ascii?Q?QyiBoJho/lLg/kLffjCBBCgYYKtklGh9EehV5ePFeS8epKh9SZGHqDq1AgiE?=
 =?us-ascii?Q?NQDS6Wvm+juioGtB+2H8nXblmWBz2sgyqhm31uvKzrBcxmAfUq7CuHoDIF2t?=
 =?us-ascii?Q?CvpaH8R7nSyhhMYNJ5F26kYSYfcid9CLd9dDAREJHzmQi1IWtC/PsiA6lFhI?=
 =?us-ascii?Q?lvtvPW9R/wgItb7WNMYRXRdimlAYuGn/vglQDP7d3QsjE5Hx2v3k8ZslpYfW?=
 =?us-ascii?Q?SFiQ0V+giYT/p61KKPQTnVcQgAPqvFv9Xvi7z1MpopVJ2QQsh1sIguRupvAg?=
 =?us-ascii?Q?CDE3d7jXI1RKrAet3b4E4MqmIUQQI7UjoT8dRr+JwadQWdDm/cijddKinzXO?=
 =?us-ascii?Q?o0tT+UscRBq4RlpX752M+gFCx+9vGn9lnvYuO8g9lOAckv1E7fgUpgKrnmeD?=
 =?us-ascii?Q?S+BL7L07QAqlLkPVxy+Q0mVhqINuqYqElG58NlKxoiHEC/PB4k7HPuH2RYM4?=
 =?us-ascii?Q?eEtZlPGjHf9/IZYxX26yri/XjLUE/ukX5Z/GNgJXreFwJGA+7wWPn5bj6EJq?=
 =?us-ascii?Q?yUUuSlDSICrqb1z1hfv4nLrY6wMKL7v3j/VIsY16gaiFWnO4StR5veKPiM7d?=
 =?us-ascii?Q?jEshwOPO+EfdvR+vPisRPyuW85EfrSjLNnZ3YAjvIWz7wDGUHOai0UHIeh9g?=
 =?us-ascii?Q?JfJ397HV9vtvYy7xKTQeCjvQ16Qca97FDrxOX//KDW2Xu2urrrUxayhHh80b?=
 =?us-ascii?Q?6+FT0JnOYBJzoMPAWCIC7oKLSSSD2V8EQDDOeNEnPc3nK+Ol0EifdRL3NSIg?=
 =?us-ascii?Q?ELuBK3Nv6DRTT6sgyTxRHzgJ9zOzsGnkpBj6LGVuQuSgTbIqeBOaEdyG0+Wa?=
 =?us-ascii?Q?SFFMRvrn9E5vpC5VHuLSGsMLgMlVO858Z9YP0FzW/q2Ol8t9yOiEGkpVHKex?=
 =?us-ascii?Q?jeZADhsIWw4IPjIeOZ5MD7loYRQ2MG/xUUWthlTr?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a39b46f6-8ba1-425b-692a-08dcc80b6e82
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 09:17:40.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5OINmdTXNi0zrMxNdoaqSbctCY7O17kIOBvsEXt24UKCNoz7Bj3VJQD+UTniW9+1OPo6JAtLJxeCb7U0S102A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5878

Use ERR_CAST() as it is designed for casting an error pointer to
another type.

This macro utilizes the __force and __must_check modifiers, which instruct
the compiler to verify for errors at the locations where it is employed.

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 2 +-
 drivers/scsi/scsi_devinfo.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bf75940f2be1..b2456989bcba 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2890,7 +2890,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 	}
 
 	if (IS_ERR(csk))
-		return (struct iscsi_endpoint *)csk;
+		return ERR_CAST(csk);
 	cxgbi_sock_get(csk);
 
 	if (!hba)
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 90f1393a23f8..6a04cd1a86d6 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -423,7 +423,7 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 	const char *vskip, *mskip;
 
 	if (IS_ERR(devinfo_table))
-		return (struct scsi_dev_info_list *) devinfo_table;
+		return ERR_CAST(devinfo_table);
 
 	/* Prepare for "compatible" matches */
 
-- 
2.17.1

