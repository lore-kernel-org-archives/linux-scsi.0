Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2053.outbound.protection.outlook.com [40.107.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF1C38DD8;
	Mon, 28 Oct 2024 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730123542; cv=fail; b=Eo+rchmqZxRDOpskn3QiV1VWmCxUxMO42HURoBf274q/CIe1SOQwit87CDyPZjRdyhhgsGdBIouDxg+bhCFLa+VDNnAHTh+SkuG92wM7pUhn6xtEV2Gxm6n2Z3LEDAaLOo8zZyNomGM2d+NUSdEp9QbOTwwha1RaR3J/sT6X154=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730123542; c=relaxed/simple;
	bh=zeeiyb3+OqVaNLf4DteKsQ63BKY+WzZoyEu/ROZDGhY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=HAloVE5Oi8TafKIhxufTQ26f3mSMA1nZgvc0alTfFRqpYfTImmn6Ns4nl/EGyTwdryAfH1UUJVegxb6Iwc3vA++3L6UwzFHVX3iNEDDkEQWX6/oX5mBhZ5ET8gjUl6XjyIM/IzJPmeFQK3wgpS4N9kZwt8+sYDF/1dzZ/ubDk7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=quRT3sOT; arc=fail smtp.client-ip=40.107.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="quRT3sOT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mm+9fFUE2kL5RoIIh/kE2Br1YQRZGmiXgqcmOiCM/4tNy25QRvhkZoUqDFiJrYyp+Wmpji6DZN02pVW/u1UDcEG0o1knH+5hgf6l6OcwZRA8OgwCMNZGLs3eCoklUwMrygrXoNO+0Cn8Y21vn+VVcz1vxhiFbCYYpcK79zW+PWYbLu9J4LPuBWMh829GvISGkrgBFgKCK0ymBc4Qtu5Xua72/0zhQ7/kPANhQB0dtLAMrxp/vO5oySnd3kZ/29T4BBthefnp/OvAH1agxB4oPZ1RRyEhwBurG8i8sBm/7kO9o2gErlLBr7wOz7auHc/BlmBT3piMJAGBsa+S6ToAZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHscrNJqjf6vThKDYb9zr5CfTW0YsvCjZLVFM6Tf0E0=;
 b=Fjsry1Si8BhzPDDL3xuisyKR5jk3vGWEUJOrGOzTT3FXS6GyW7H5PHCMonMw2HhUkJHnVKpcE4desLfnNoFc348uH7VT8K4FzMgoJH78szWvh79svK4XZeMXpxkap/Eac/NIKsfBVLKXpjuk8V71JJJVxxsRUCwRCyGjIHM91OpayqYMpAmreJ57vXqYGpQqR9+VFd7lykCfIIcVRk/EyI6mzIVflKei34fl+JDkwXNK0k4ZTWwpISCRzCECyBsk539Kjhhj7jUbP4413TGVAc/EQkdHJHTLYk3vvuElSnq4f9d66xtdmo5P1/sy4ngiRMYIjxu3d9LEqIH9B7XjlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHscrNJqjf6vThKDYb9zr5CfTW0YsvCjZLVFM6Tf0E0=;
 b=quRT3sOTQ/yFu/1KNUtQTknMbk7iwD3fF6kqC0UDm0L0/c7wIT1fke5ositk5o4984O9OO4dNldjYKiiB9EpplQieXQnE4eRiPYvoh9eZ+B65v50cPoSSoitYp0HjjmUL3Ci13lIuYGmeTpfyYKdxT0jS+wCDgULjsASS+mtqYsS3lYVTL8/LKrhEY7Ak/fECAXxvxXzIqyUvOCnqmn072D3HZuve27aAInnSn70Vor36zuEKcjr44ZMn9CIiIX8bF2tPFtKgVOmieQLNQr4lHeXwl/w1SjP7ztwgnWUBd7FIlZuA5aDQwIpJ81HhfexW5dE8WuvH8up7Oafc/0MiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by JH0PR06MB7199.apcprd06.prod.outlook.com (2603:1096:990:99::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.11; Mon, 28 Oct
 2024 13:52:16 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8114.011; Mon, 28 Oct 2024
 13:52:15 +0000
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
	ahalaney@redhat.com,
	quic_nguyenb@quicinc.com,
	linux@weissschuh.net,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: [PATCH v3] ufs: core: Add WB buffer resize support
Date: Mon, 28 Oct 2024 21:52:05 +0800
Message-Id: <20241028135205.188-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0016.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::20) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|JH0PR06MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: e88f06ab-20b6-4f16-616e-08dcf757bb15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|52116014|376014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SomPdioOCtVVJqAbZDZrke9gmYI8hyiObV1RLkfU8NhAP7AXb1zZcNhA0/Jm?=
 =?us-ascii?Q?Vh+hgZQbUISIJ278t6JCXvVL7igMCLACTacTkTLjafFkar5WEF6VC7+0+mnV?=
 =?us-ascii?Q?zGMIm2VeGqpJGQb/tIEw1Q3IbxXR7wUjz5FUzFoewQd+mhRAmO9PkMBL2rxt?=
 =?us-ascii?Q?hZfL0ACsYetaO//25SQNbZHZVNb4yDbrhCW6es3tCMRMkXzih7mgKm020UfN?=
 =?us-ascii?Q?O+o1iB+Ko5UCGD+J6g7UksXAf3hT0duZLY038xSmHGNtyggS+DZit/PISZnz?=
 =?us-ascii?Q?Fbt3DI44YJopQDY3x1o1ZGOhFBI0a4jKqEmTgiQBWORs67pjje6dAmsMxZkX?=
 =?us-ascii?Q?T3QihQOT7NuETtCttFu5qqMhj9f4hlvP4hx4nKedM9jXFx7SRyS4DIA9T4Gx?=
 =?us-ascii?Q?hjT9WHM/o1GxmB2RASQ7Rk6YeRiAEIiFyrHsU65gpU0ViIWdLh3n+GSRwOX/?=
 =?us-ascii?Q?341kPgo/XjWgj19sbWiydwlgxZd8tO99rt0iae9KPWzna9Z7xqNC2e9DCFSw?=
 =?us-ascii?Q?VoUf/7KoK6GOSOa2GFK6vAaOq1Zq5zZ0EM8JQmpWbBKzw111mgnqVCs+DgqG?=
 =?us-ascii?Q?ATXNXYM2RAgmGUmmviwFWVkQ1DPxx8G10GnOc4kPvyUdTw8uoXhqZrbpoqIj?=
 =?us-ascii?Q?BIR8h+y5T5HE/2YMM4aiBuzkcBm8vpunWiPOm2bTFCXQwPxKPTLMEGyRNJuX?=
 =?us-ascii?Q?L0WlQ9+IdpkYQ3kb4uqFn6Dt/8P4l7ZMd5oKjLCFtb8i/iD0gE1MA9xLy0nU?=
 =?us-ascii?Q?/8MooU472PUqQlNb/HcBoRW3mOolVMi0OVAwOZPAmRbsowsxLyMKk1PyzSMq?=
 =?us-ascii?Q?aW8XFLMa4Ddm17cbXS8KwMPbDiucDyzyvtsD7VTbGHEO36tFteadwN1gnJSz?=
 =?us-ascii?Q?wrkkfqrb3UJhp+Dt6IeF4eJp9u1pfshzdHhUn/F99jeVkg6Fzq+VVuknxOx1?=
 =?us-ascii?Q?E6QVmCYVK8je21BbqlVzuyeRy/1EHbB1A7dMN90i9OdPUAu8GcQVDXgGl7ym?=
 =?us-ascii?Q?YZZIMeqv5kXkiqqhMisK93upDyvQtUBfFKY1q+Cpu0GjfgKFZRNl3Qg59F23?=
 =?us-ascii?Q?tChj6tCS4MsTNUQoaHm+ze21xTisDuUbxMS98j3/WH9psPFvGAwxLkQHDrb6?=
 =?us-ascii?Q?jWzpP7hFWO9M3/MAbWC2vL4H0C/R6WoM6bPB5QLdAB81WWoDNYqClY7uE2Ds?=
 =?us-ascii?Q?TjuSlWhnQmplSHc/XqJEWP6WB9+iGatyGgrv5OdkEzOGyNVH2Y65Ctmabp01?=
 =?us-ascii?Q?tVPabIDgAQsZpiqjc47XPmYXtWuBLmCGe516hECc/tiG6SIWfRr7gpCQ70Cx?=
 =?us-ascii?Q?SexpEjWlY4vUw2vXju/mOuueGhW6HaFVjYY5mQCd9wr35YqhqLpUqU1HJIye?=
 =?us-ascii?Q?Nm9xvKVe0vmarLaeQcIznx+gihWB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(52116014)(376014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o5cm9VcjPWcYg40NPvKvqEyat4d+BZasJMLHWVX/uQPwhjYu5+T9rrXGk22k?=
 =?us-ascii?Q?eu3w9wfbsQXK108oaELFv1ATKXVn6r+1/QZmB9cMfLOaYoNAeu4LUE5Q0UQJ?=
 =?us-ascii?Q?j0Ug0OmWh6pn8hPXKoK2OQzhsuW7hGzdsBk/6GTFd8QYa4/QduVOzWx+qLgd?=
 =?us-ascii?Q?WY3Jrv77LhkwDT6zwqjnMBykWV3zav6y5cjR23o2N731CYH3dxM2loLd0gwS?=
 =?us-ascii?Q?A7P+OLws6emGTsYVaLyEcYA/cj3nU7KQyzosug0XanKRqe+DT0c058C0gY8w?=
 =?us-ascii?Q?wuTz2+BUY6kLeqqLxJm4gAXxui4dL+0QVZvex8fV5URl/UqyAX5SG+sdmI2l?=
 =?us-ascii?Q?z7fSiHzndHzDEjojTtwiwOujw8ccHPTqFwGDD+WqhfaVA3f1hecVORr8Jn1S?=
 =?us-ascii?Q?3qcqYzi7/8w8sXCpPMnz5/C5MHidV78TYwPe7YBj05aJPYCez70yw0OBYvEd?=
 =?us-ascii?Q?9PW88sVoXGOCUNCR/NOwJBqmC6sFyOS0nV9chVGqD5I0OLzlF9aP45gEwy+Q?=
 =?us-ascii?Q?mJ4aBk8LiPL8441kdx3lMBhive0jfimECc98mS0D3vSQKPD0bPfK1GnzP8QK?=
 =?us-ascii?Q?ZUGrpi+AtV5DTBuIegaC/gKHvHTPjHjMGLBEadZ7rb2LwcauuhtjfN2oyl/D?=
 =?us-ascii?Q?R4tEr8GY69aHecyafuochAC+qEhi9MeAU/Iqwxy/mPpeQT++nWXfbLlLAXxL?=
 =?us-ascii?Q?LUmBAavEnybm0F+D2ZcfARZnrw/GPVvsE9buOI4Ifx6SzlC/Un4qnpIiUH6G?=
 =?us-ascii?Q?YtFCeZ5e+n867PnEOf85IkNBzPQBU5aq4sxKcBeYFHpsbiD9edxkjpVubBcl?=
 =?us-ascii?Q?MXkWIs55m2NN5035t+dmAEzGiffRPD1BTHW1uY/j2qgjbGv+9NLuhJo8+mDz?=
 =?us-ascii?Q?fYAww3zLWUDPNPRVoqcnGayfYqtZYQKEphQglawLuj4XTi7HKduyHeWU0fKs?=
 =?us-ascii?Q?0QLtCcAxXE5Q3r/lD9GCSz0SE/HmsdWbR36ezpI5s2Ri1twh/IT+WfUwClcG?=
 =?us-ascii?Q?sZS719R5tYiCakrnWgVCspPSeLqKnVuq7AJ61xx2slHwAWvDducL24vf/8QH?=
 =?us-ascii?Q?cMrOg0/4ihiEsx5Hhmol21UZX5jxMlQYo0cyLYnYrSKmn+En2E9+Lx+A35Oo?=
 =?us-ascii?Q?PGxPGcbVLMPWXTthcSCEqTARRQRdf1Ici6v4v1sx2mDVO+W8GjawUhIsj72L?=
 =?us-ascii?Q?fg1vyhumTyD+g0I9btTSzZjAW+Q+/cEdZtI6XMoSRE9SSmdZBXo6crrfBuDz?=
 =?us-ascii?Q?mJ/CT6KP++IrfZtcV7ycN+bsUCCaPcDDTe0eqADEkE6caiNEtgD6n8U1WaE+?=
 =?us-ascii?Q?Otd9kik/eA0KzNwXJP5v2SIyrhuOVeOg21oyAlYE0QHH/tpWH/KaGGDgE8z5?=
 =?us-ascii?Q?N1yYo3eK9LWfMPA+mPaL9sXm+/QBqLZVYMsphZv5xIeuzpGDWszJRViGq5UZ?=
 =?us-ascii?Q?FrilXQp66IRQ5mWPxiqPNPNmVsNpNLamw4mQUNly6eyJyHGkVvnBBpLrApwN?=
 =?us-ascii?Q?BDAgxDjRbmehw6QR+0rQ85iCyvva0YbM0PB0CDitaR8zFH2Zqttj3X20Ze2g?=
 =?us-ascii?Q?COM1CKS5NKBu9VSeP9NnY+bHM8E6FZZrZCfl2Di6?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e88f06ab-20b6-4f16-616e-08dcf757bb15
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 13:52:15.4187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sOLoWqatC0BpLay+S2bFfYnSCpZFOjtvu8NhS8txMosE90cBE8c/1fFXhiPlxMO3EuUf7IZjndSWQuIYCWi2/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB7199

Support WB buffer resize function through sysfs, the host can obtain
resize hint and resize status and enable the resize operation. To
achieve this goals, three sysfs nodes have been added:
	1. wb_toggle_buf_resize
	2. wb_buf_resize_hint
	3. wb_buf_resize_status

The detailed definition of the three nodes can be found in the sysfs
documentation.

Changelog
===
v2 - > v3:
	remove needless code:
	drivers/ufs/core/ufs-sysfs.c:441:2:
	index = ufshcd_wb_get_query_index(hba)

v1 - > v2:
	remove unused variable "u8 index",
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'
	set but not used.

v1
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/
v2
	https://lore.kernel.org/all/20241026004423.135-1-tanghuan@vivo.com/

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 52 ++++++++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 42 +++++++++++++++++
 drivers/ufs/core/ufshcd.c                  | 15 +++++++
 include/ufs/ufs.h                          |  5 ++-
 include/ufs/ufshcd.h                       |  1 +
 5 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5fa6655aee84..dbaa84277801 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1559,3 +1559,55 @@ Description:
 		Symbol - HCMID. This file shows the UFSHCD manufacturer id.
 		The Manufacturer ID is defined by JEDEC in JEDEC-JEP106.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_toggle_buf_resize
+What:		/sys/bus/platform/devices/*.ufs/wb_toggle_buf_resize
+Date:		Qct 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can decrease or increase the WriteBooster Buffer size by setting
+		this file.
+
+		======  ======================================
+		00h  Idle (There is no resize operation)
+		01h  Decrease WriteBooster Buffer Size
+		02h  Increase WriteBooster Buffer Size
+		Others  Reserved
+		======  ======================================
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_buf_resize_hint
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_buf_resize_hint
+Date:		Qct 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		wb_buf_resize_hint indicates hint information about which type of resize for
+		WriteBooster Buffer is recommended by the device.
+
+		======  ======================================
+		00h  Recommend keep the buffer size
+		01h  Recommend to decrease the buffer size
+		02h  Recommend to increase the buffer size
+		Others: Reserved
+		======  ======================================
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_buf_resize_status
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_buf_resize_status
+Date:		Qct 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can check the Resize operation status of the WriteBooster Buffer
+		by reading this file.
+
+		======  ========================================
+		00h  Idle (resize operation is not issued)
+		01h  Resize operation in progress
+		02h  Resize operation completed successfully
+		03h  Resize operation general failure
+		Others  Reserved
+		======  ========================================
+
+		The file is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 265f21133b63..683f916e558b 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -411,6 +411,42 @@ static ssize_t wb_flush_threshold_store(struct device *dev,
 	return count;
 }
 
+static ssize_t wb_toggle_buf_resize_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int wb_buf_resize_op;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en) {
+		dev_err(dev, "The WB buf resize is not allowed!\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (kstrtouint(buf, 0, &wb_buf_resize_op))
+		return -EINVAL;
+
+	if (wb_buf_resize_op != 0x01 && wb_buf_resize_op != 0x02) {
+		dev_err(dev, "The operation %u is invalid!\n", wb_buf_resize_op);
+		return -EINVAL;
+	}
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_wb_toggle_buf_resize(hba, wb_buf_resize_op);
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
@@ -468,6 +504,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_toggle_buf_resize);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 
@@ -482,6 +519,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_toggle_buf_resize.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	NULL
@@ -1526,6 +1564,8 @@ UFS_ATTRIBUTE(wb_flush_status, _WB_FLUSH_STATUS);
 UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
 UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
 UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
+UFS_ATTRIBUTE(wb_buf_resize_hint, _WB_BUF_RESIZE_HINT);
+UFS_ATTRIBUTE(wb_buf_resize_status, _WB_BUF_RESIZE_STATUS);
 
 
 static struct attribute *ufs_sysfs_attributes[] = {
@@ -1549,6 +1589,8 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_buf_resize_hint.attr,
+	&dev_attr_wb_buf_resize_status.attr,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 630409187c10..c28915debab6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6167,6 +6167,21 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
 }
 
+int ufshcd_wb_toggle_buf_resize(struct ufs_hba *hba, u32 op)
+{
+	int ret;
+	u8 index;
+
+	index = ufshcd_wb_get_query_index(hba);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				   QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &op);
+	if (ret)
+		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
 static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(to_delayed_work(work),
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index e594abe5d05f..f737d98044ac 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -181,7 +181,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
 	QUERY_ATTR_IDN_EXT_IID_EN		= 0x2A,
-	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
 };
 
 /* Descriptor idn for Query requests */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..cbe208ce9293 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1454,6 +1454,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_toggle_buf_resize(struct ufs_hba *hba, u32 op);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
-- 
2.39.0

