Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013034.outbound.protection.outlook.com [52.101.127.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3492FD7CB;
	Thu, 14 Aug 2025 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755177210; cv=fail; b=HL6A2KunG7WAxf9/uieJVAtEgyUGEs40LVxiPy+N4/k2hxxjHXPy73GXi4K1S1dQvlEf8x/IP8IN1TSmvEDvC0hpoeT20J/pnvs1G+A5cXKd6VDX9Ir9QLrlfkuQHezWpAXY3ygbp3ADF5PH5jpbSo19VV9iMK9zCximqzTrSvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755177210; c=relaxed/simple;
	bh=PzhXhJYGoiPq0uD9qnx0PysnUpfyQdyGUr6UYr7YfTo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=QqhLQJq+21Fea0WDhoCLlLiBJJVy3kZHpf2LY8jflZ1uJohZ+Kzhk4tUDiXtEJoOp28kpt98RGhnmgE+/qrxKOwPcXKftbTqu2qMvo+p7SKWsTlVxYawRc1vZBzAzqI+miIslIsri4JmypDJ8zeYAIESThs2JLDjihQWLwmnRtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=j0PdJI2+; arc=fail smtp.client-ip=52.101.127.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="j0PdJI2+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0uWgwh5DuEa3EHjgQNJQtKoSAHXmCfnWs6eInNQ80iNqPw+21GQdwt/s9fzrha46nhU9pvvyr0HhehxITRoxfTkUCXwgw7Isd0tmBIWKfoOOmjSch3O4A2ou2j5aiYsVcDDO2sd6PeiUjHIUP9kCCXSz86LmkC5W0Y8sc8WGHpDKTWHtpJAtKw07Wv+Qj4/ei06USj53zdf3cQd+3RoRl491XF9r3QQsbxFP8/wwYYUrZCCp3BsZY9PcBVKQTepX7OfSlhw5NffRdd3vj9FiCo7qytRH8pxTiA8N4sTwv8io2YwKJCyhgHX9C2gXTfOlqd5NItOqEwGW6rJGnA+9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLct3Q/BfqrbfUAJADptBc2OzOU4g2/WKkDc8GY3waQ=;
 b=JIiZyOio7SfxCmx/ldxPwkx82xwQb8LXqnvLTx3GJ8HTMGEEGDymMJshQP1a4F6bDQNiICFSAsNrKWVSss4pwjjkOqrt21sf7T91nSdi9Zp7JmRJ7goQk4LTr+oegpcvyq7Ebfd0bdo7HLYEufiPKnxzvBM/yf0WOZiG1eOxQDxIRiVeLaWDF2jDPduRrJoSskmQWZA5ZEmus7C4r5T4dXdeqO2hFTb+n8BNb8LDydBfbYcAhwEJaOOZMgIWoL5E/N2hxUbHlAi4PQtllinkd9QvBxzJbPeCAB1PvPHwk0QTtg2hY8Uw+sb9rstm1XWcNlRnXYiyXPvorw4F1QlKFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLct3Q/BfqrbfUAJADptBc2OzOU4g2/WKkDc8GY3waQ=;
 b=j0PdJI2+G0sBi3/q1uu/GZpnyzVN/f/qds83fIs4wjYWrFMTci2lHWt7yDYHhrqt729bO2gSdvaJ5nwIb8c9hMZn/cEV0EVepFUqJOCrsEumDAJW72fx4ezUd7DmdxDTWROSqZhHqiljiWC921tG2dhzjms9UjoYfu5ERBxQcN2PDY0FE1n23XWpYbMzMS0QUHTyUDE+1yRGdkZfhTKRjpykTuRF6ZNOO7G8I0jWXXAuM9kbiMtwnqR+0CP7VhVxCJtVky+u+fnyRUU3g/EKbAaTgOy8jvP8GRSBD2KCqTdHgA4aCVBCX6WYCYnuZ7Zbrz6hWceZ7O54WtUygd2U1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by SE2PPFDCBF4279B.apcprd06.prod.outlook.com (2603:1096:108:1::7f0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 14 Aug
 2025 13:13:23 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 13:13:23 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI TARGET SUBSYSTEM),
	target-devel@vger.kernel.org (open list:SCSI TARGET SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] scsi: target: core: Use IS_ERR_OR_NULL() to simplify code
Date: Thu, 14 Aug 2025 21:13:12 +0800
Message-Id: <20250814131312.231097-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:404:42::16) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|SE2PPFDCBF4279B:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eb58170-542a-4ca4-867d-08dddb3458ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ANcF/ISBRTsvpvtBAV+rqo9XnDjhwrJ7R4975TT1ToJ5t53tJIUzF4q1lsLY?=
 =?us-ascii?Q?wKEJ4RheWZsiGukrdLq8vz/Yhsz8H+eQVILUM3cAg/C74q1vathjYKkNZm4f?=
 =?us-ascii?Q?TiLNE+Lou94+vA1a9iIv57zcayB0hxexQu9MOrf0muwB8PCdeDHGyPHnTRRn?=
 =?us-ascii?Q?JbQXD/DkP9cW/aVkwsZ13w876S48N6hM1d7+R+GW8c5295oFBJDMx7mqO5C3?=
 =?us-ascii?Q?dkAfCn9WUTJOkH8xNZfyDvoNz0QGaUa8S1evhN9TDXzLHaLks51Djfhz3lNP?=
 =?us-ascii?Q?Lbj5BqZWDMWHPDqp3xfultF6SwG70ytUuatdyMPlcuZCLq/XGbZPvB0pyytt?=
 =?us-ascii?Q?eGuALcWbfO+xNFqsV8DBfhMtjvPTR7mSzWhctXqGo4173hYMmu5M9gAm1D1K?=
 =?us-ascii?Q?84AjaHFUXvy94ynG4ca1TdO9WmV0QHRdZ64/vuCwZG3e2m/V+XJmLqtqFtVJ?=
 =?us-ascii?Q?IUPjNAudrYZhCjQ/Ie1rznUxRDpIaJjJDSzg+c/ByWoHIu1M+4kM6D5letnU?=
 =?us-ascii?Q?9DJz+FlXr1d4kZEhUEHPhkd8tBu+O3l6t2il6QqJpNbRAPNPrqcItQ+bScKy?=
 =?us-ascii?Q?uzDNAh1g8AxpKnPJiz5d4gJxY97tGPbqUj+1Sd7O4h1KNGky6KJTCORyJtiT?=
 =?us-ascii?Q?5DJBZS1LcfumW0SNh8Uwi4nzPsqsZrd2dOdqJ9sLyH/uAAuQRLA8UHZzouxb?=
 =?us-ascii?Q?3d6LfXOP/yfmsH75NsAO9GcvV5s0Xhu13apYKllhS0XFUl6oWIZ+cTAzXhHv?=
 =?us-ascii?Q?GShzbVMO1V7e3Cgb0rijDL0N/PIGdI1/j6xihB5PpuM++PBW6IN77oMUCKCU?=
 =?us-ascii?Q?ztcVJfnzDYe/ExSvi33KexSgHIsQiR9z1L5TQ9szYSqWSKxbrjLuETRLLMrq?=
 =?us-ascii?Q?vu72SRmk4hTCgcpviP/qQhydoowZ8R477gtgMxPIw0zYXwZ+WBzKgQCDJCJZ?=
 =?us-ascii?Q?eqav4PewflQHYp1bF3J7oMrpSMC7/KnjHONSCS9L4IRd0skWpAAcRdQqoe0v?=
 =?us-ascii?Q?pDZcQBGdr8Dxo6wetlyQI262eCI0KRDHYUOSy9aZz/D5Lbq/JWWZORJHSzhz?=
 =?us-ascii?Q?TpP1tXBlOUQtv2NEsWwCK02z5OZN5Ld4ZOKhwyME+6ATPYBteCVbyhhpge5H?=
 =?us-ascii?Q?fh1fU8kBOiP5TiFn/1u0kJisW2GxOHfKy09PIbt3kMcoOX/kYupt4k4k0wJH?=
 =?us-ascii?Q?BsLavkz+C5t6tY7SAuitaWMu96gKtSPvIbfRbabg3aERI3XpLQjhyW9NGNKz?=
 =?us-ascii?Q?02vom17uv0+St8LAg+pztaYRRUfblgAe+IJu2dMv/OvKm78EDaetQnwONLnh?=
 =?us-ascii?Q?W8VvDtrgqY3v8k7TLmHTpOG/hq60yRAEPRj743ZNtgHYlEqHtA90zp27NQDt?=
 =?us-ascii?Q?6BPBFETXmzTV/6Xuwez9hM7dg0z6yGTSwCVRkFlXBiPEvHAGGbL7qbOWQUvl?=
 =?us-ascii?Q?ul8CX4G56FQo8hOjfeL1IonCW6sIgCPUJtCzarTUXJ32S8l4vTiXgQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hjHPsuDsdRPmWcI7fV7yeGVs24d1dUHmP26DzQLexmQAZS9Xm7J+iSP/f1LC?=
 =?us-ascii?Q?DIqv8L/hJMOUPzRVUvpUQVS7pTxs6KBHvNPf6VlAzJLZHxfecl0zFji2q6qo?=
 =?us-ascii?Q?y3u3RBoJYvMOIyC6JZ8WVdt/FQ7msYpA1SDIk2cBsSG8dJqCecCvRnU9Q/fs?=
 =?us-ascii?Q?MoiU4jJzw8kvdR0ZDbISPZUJq5iiLa8kN7wKHexopCcPN03QrLguOHIVOsY7?=
 =?us-ascii?Q?u6Dq+L44pxY5K5Xl/kX9NqhZTQ82t2+tnFrpngaxyco9WxRnmkTQb6WEctgF?=
 =?us-ascii?Q?SFd/pMyA/B8CRF4vCHw8cYNUZPRTttRtQKUtF4+mP8wd+uPdcMvnMoKEIdPl?=
 =?us-ascii?Q?qmEanWDO2R2jwBmIllD2lob48NXvjoCEzsRgpTLfeeyrxdml0WhrnGXQ+JPo?=
 =?us-ascii?Q?5RLnCBGSGvj0UnDGyc2IekAYLWPI5lO01nf8dRQkKcBVVhNZnp2+XEAzv6w/?=
 =?us-ascii?Q?y6Jretw+3zTBPwuyPGafdk4Ly5Ef2QYNky0Uq/TDnsQtgaE+ELInSyILqyCd?=
 =?us-ascii?Q?ldJ7aTTyypYxDioLpaKudHoRjfZMUvC6AvBqczOGvAyVOm/SVihbd6V+nP3V?=
 =?us-ascii?Q?TFTUkZDS9CJvN9OGHgd5TFTY01tD9OmG/RsabORsl29DzdDyKJ63nNdMMOtG?=
 =?us-ascii?Q?iqt7BDWz+as8lJfO35sFtmp6kGRMGGGdpIfKD5AZDUfldfMybvKxlCOcncy3?=
 =?us-ascii?Q?ftSd0BdEqdczEonlkTGLgEsVpaLB0X0I4iQeqYKpYSzT8pmCM5v4CDfJteo+?=
 =?us-ascii?Q?Pow8/Gl5Q1KdlSzUxPinv+iNXwMbswVfdCecBbA9Bz34nisHv5+YQgLKmG5E?=
 =?us-ascii?Q?KeiLhS5RAVtGzDBSNBjZ6njJ58s6SNCRrVQ2G+oa0P6aTa7tur7aMhrlU82R?=
 =?us-ascii?Q?KvrVJQcO82BcRmx90zfgEubxCNp/YRndPCJTyX3Cx248fGUAu97UT0e666Xf?=
 =?us-ascii?Q?XqX35VH6gQeysr8DTLYV3U6M6YSMdrbLVkyVsGqmjgwmsbafzSICzWhobqbs?=
 =?us-ascii?Q?f09HPRPAUVzJAFAjz9JpTMD7qNkAGOoaE0ea2CcJ0g4BZXCNVxHrPBqMP+P/?=
 =?us-ascii?Q?kFlAIA7zcYTqr/pAkLMY+lhvUtznBDgXcd+/0Auy+c0FXLedJ0QjGoR38RZL?=
 =?us-ascii?Q?OThfGvuSWiVtNqd40DJj0nac0m37lrwpCsIWvt0fAnT2LJMG3f9BUVYilIQd?=
 =?us-ascii?Q?OYduaJpNdIeuEBbqv70wuhb+Zr8G9xPuEI/fi6OC0Dp2jBeuEwXjNfgr+lwI?=
 =?us-ascii?Q?EzWFnvwuNO92IOWcEaQq22FXRRncd6HHslLgawD1xJaDiQMnTawSknqiY7xi?=
 =?us-ascii?Q?+axRBW+fbcuvKEPJUWY7LUWJOOh3BWRQQSpP+YubJBm9wcT5PU9mbOacKdjs?=
 =?us-ascii?Q?hXYjHpVSOhcFdAtc5i78NEZQQEW2KcwEj8rVrLw9eBqokMJdWFVBGKO9Q0ZF?=
 =?us-ascii?Q?532BIuUUaY23iKQqR8fsEzuZOscR9eQ60oGin6fus2mnJ5Yyhqr4cOCTq8p4?=
 =?us-ascii?Q?KSEzz1SJ1doI1yX6ceCYD8CHtdioMWgeOnXQKjv6fsMLa/32p8IKatjkc5D8?=
 =?us-ascii?Q?9uMY2HnLqS4eE4siJP5ATZKf7hGB48Aayq0l1dEN?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb58170-542a-4ca4-867d-08dddb3458ab
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:13:23.1630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiwDUvCWTCHRTjgIABoJDC/vpd4sk9hGdo8oyPiMiN561zZuCEf9DzXM83IAFfBINPSXaXW4bGlSJbsksULaGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2PPFDCBF4279B

Use IS_ERR_OR_NULL() instead of the original !xxx || IS_ERR(xxx) logic.
This will simplify the code and enhance readability.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/target/target_core_fabric_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7156a4dc1ca7..4b0c71fbe57f 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -479,7 +479,7 @@ static struct config_group *target_fabric_make_np(
 	}
 
 	se_tpg_np = tf->tf_ops->fabric_make_np(se_tpg, group, name);
-	if (!se_tpg_np || IS_ERR(se_tpg_np))
+	if (IS_ERR_OR_NULL(se_tpg_np))
 		return ERR_PTR(-EINVAL);
 
 	se_tpg_np->tpg_np_parent = se_tpg;
-- 
2.34.1

