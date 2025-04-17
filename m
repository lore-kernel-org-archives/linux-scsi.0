Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012047.outbound.protection.outlook.com [40.107.75.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7876428E37;
	Thu, 17 Apr 2025 12:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744894233; cv=fail; b=kBquAPfY26tlfCOTW5BvMdGRFzmlp35n21fIt9Z/YEv6eBfQvQddJRhvbpqwWmJxkGkP+f5cpBo5FV3AjqsIMsBEgYlN4XsUtqQdQ+PerwkKJENf0pt4xfPSL/T1XAjvlFUFTXf+Gg0CGxwDYJMnGmRPfstOS6wCU6tcTTsf7tE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744894233; c=relaxed/simple;
	bh=YUCuQNzRuYh5ilfARH655Ho1mjFDEeLAMcytv/L4DQo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=JEwAABknKUPG+DjXRlNtLGdmSyK5VD5Hh7zgfogzr8UI4wn6aX+GfiBS3go5V7bQfsrR1VN9jzQHOzmQOHNKNhYmi0Wp9Fe2qqM4lTxl241Muxel4WxP4Rr6CuE7N5QQ7x/dEu5RqTMPzFPNuXuqWpKThEumxeBa7lIvbQ2zqDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=phyxnSZN; arc=fail smtp.client-ip=40.107.75.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="phyxnSZN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qn6bcA1aeXmoZaN95neP3EU7gncBHgWJYcgfnialRMJfLZ6aAySYiJDs44S7GNG4yoMga3kGvuzDZk2qCF0cNhPHfrNrSSCXs1C0moUZQ4ilPwm5LN6IWRBUM6wKU83H6v0AmHBQaT5Ui7XaZNf0s2zOdkvvT19FWIz49trt2oGjhe5CSKznWELYTaWvKUsuj46p2WXB2bFHreaF8ephrsJwWlKbiA3JXFqlSUNXeoMfNivnznYgxCJGdfw5c8eB80zQbdtsNrycAJJZ61r4QZXm89MjnHWQ9k4BNHQqhbP+ObKa52NYE6/O91AKB6hMNQuy/m8zcKqEGNcFCh/srQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9W1n30iwTgeLJkzFV/EyZRjK6CFa4C58N0fYHMVb3s=;
 b=RMWomSqx6wJlK6SzKXESQ6JjGdDeee/CxSo0xo9thL3jeS1hlj4sAzQ5M0qhluOaROelIaYGlMcYcMC87M0llTinzD2W5LQDxPj3RNFtMiJ+ogq5hd1XjflhN2zlW5OUKXkpAeufpa+3FwH71pi9gHw5ZrJPaQR5AeujA5OuyqN1Ln3MBy4L8DSltY9n580/mjswWQij+LZNNXavfjzZyVeYVTdBgWqhMKq6ozTnY+ihLTKRm8ceApzDxNu/hYo4zSTyIQMD9GkqHU2XZ+WAwc7SxXqRee52QsMi8pJ8CE0OyMf7qZu2P5H3OqKIk+rYahiyLlOjAvgVTahQ6m8YyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9W1n30iwTgeLJkzFV/EyZRjK6CFa4C58N0fYHMVb3s=;
 b=phyxnSZNuwnzCbysbnkz7aImb2VV2vf/Cv2GI54cSxBoQfD/YVIgOGI65SlKhfzCxE4faWKl6ELRCJwFUlVQ/Klpe03018ZLySyZitX/oLef1u4Qe3TC667OrHQaxP3uI8UA4u8EQ4X5PabScoRt+7XjMaQVtC9RDMbN765H7/d5F00opQ+ms2OGmVKtQcSeS6y5H2d0F7u9Fy6ItapaFrGSyAJgABxko5kTAvjuX0GHLsMDqlhB2ID4KDWCZp002rsr7xqc8TjEWY8vsiPg+YYYUkT8oW8eq/wtQAvzab/Jw1LhAY125q+e6jMH3AXQ+ABBGpLoVra3qZ4aXCc50g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by JH0PR06MB6679.apcprd06.prod.outlook.com (2603:1096:990:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.24; Thu, 17 Apr
 2025 12:50:23 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Thu, 17 Apr 2025
 12:50:22 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	beanhuo@micron.com,
	keosung.park@samsung.com,
	quic_ziqichen@quicinc.com,
	viro@zeniv.linux.org.uk,
	gwendal@chromium.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	tanghuan@vivo.com,
	luhongfei@vivo.com,
	Wenxing Cheng <wenxing.cheng@vivo.com>
Subject: [PATCH] ufs: core: Add HID support
Date: Thu, 17 Apr 2025 20:50:08 +0800
Message-Id: <20250417125008.123-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|JH0PR06MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: 79645112-ef2d-48c6-b466-08dd7dae6a68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|7416014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?03QzVUeP3xujTc/yCla+30U4sNrnAhH4ljk8ZQJvQ9xQmBAsKSGqpQQ4G0k4?=
 =?us-ascii?Q?WFQN2xGqDXw1aeIyKB317no4HSP0GD6q+TShsh7yDDC2naGf5zZx8scaarfa?=
 =?us-ascii?Q?h5DIS/jm0fB2f9SToT5ZHZcC9OG3vtU51c995pJq/8Fr/Sb9ZanmnsUW+5dz?=
 =?us-ascii?Q?UBq1eXqmI408LatiIC5HQNecoOC1U31yADpEk1KIlEIRKvDzo9iOJX04pO9R?=
 =?us-ascii?Q?jbW+FHu/SaXHeAbRlWIT1XSXvIRLnmPYSCmRZMzyyTEmS68zTHul6zj5CMT2?=
 =?us-ascii?Q?d1pRni9RxfeL2x2j2njqVnY682pFI1EK48KaNgFagCB+CEd5eHnNx4/i5K7p?=
 =?us-ascii?Q?6wNMZ3sP/X3hZAmWUYjWP6S3urBsUUK0oYyOhegT8Q8jia7WVeFPUqimMcZq?=
 =?us-ascii?Q?K6IJExaay5onYMHeLAcysJPXo9Q6wLSAlv2Tc7cH220Wf17wAoXSeMiCzopQ?=
 =?us-ascii?Q?QeGzWRo6t544hiZ4qp4IlSrTTJOWe18jMdMEDzgxfVCjRbWFoG7kZ4LfcIU7?=
 =?us-ascii?Q?xJD/0JMEFh+zdDJbyEGUdf8ccjlKY/SfMOUwhkfDwRu8WPuZwR1w1sT6X8de?=
 =?us-ascii?Q?B4IbhMwALXh8RBORBe9sOXt0v+ydtasXErLoJGQUsxxbC3Qc6pFKnf/q5KD6?=
 =?us-ascii?Q?LXLD/Sxaw3CkWiaYNDY/e6Hq8naMqXGCQtIwJ2JGqshPqJPks1MJwEeDpkpn?=
 =?us-ascii?Q?bIZFP2xI5B4lpJr9KKgsQXdu8vTX8onENEyN7vp0OWiOSt/qzrwKL204Dsi9?=
 =?us-ascii?Q?gQqB5WcmU/ryhOQ3iVd0DLIJpzPhtjSAQcTLRxgvfTlObUs8nfkcR5kOs1gY?=
 =?us-ascii?Q?suZ2hcro59vVcDqZvDpPv3Q7tmTY3iW+cO5NuFcNdY2q5I3eIRAydKQRpped?=
 =?us-ascii?Q?uTIdH0u4niRbzZXf60KyxxMd5JcwvfWtTLO/6VK5jO8UlGF2Kcnytz0OHcAy?=
 =?us-ascii?Q?yPh6h5HRIVHqz0T1h7PaozmR+ysyGgmgeTi0wvFDqyLIL58FFYjgvz0JYiJ3?=
 =?us-ascii?Q?lA+Xbdc9aOViVGtFDJD0aEHsAwFILfTW7SZoiw7WBDsIAxtw6vJEumvakb9k?=
 =?us-ascii?Q?lQ+GCRSVfOmL3/xekyKZ5D8cOVdvXn2sNXHxaRvT5vwTphSuvMRR6rCVg9MM?=
 =?us-ascii?Q?7BFk/fCewe6dNbs7QLKAtFPWkYP9VFb6wflRasdmYtPiPv6EmLZASCu5UdQe?=
 =?us-ascii?Q?dTiIwV2MCyQHAhAO2DC2dtq7WGHa+pZm/1bLVCNU5ITPNQdDRZnu1yuEBDIu?=
 =?us-ascii?Q?kRtxMnc0ts9vEQoL2tJ5k9OvUyW8UUE1m0O3K334W1vMLFgRAtUwwqxSE7Y7?=
 =?us-ascii?Q?TmzDF5bEEfOhd6VE4AowxL6aeU57O899fBz79M6elqAWQ3/dFSWMyhv80huo?=
 =?us-ascii?Q?WO/uwrp1MwJNTQg+zme69wWw2UX1+9Lw/Kib3MXKorPB69GZhgApi4r2ZN50?=
 =?us-ascii?Q?ZD8I2mVoaZgR0Y9WQ3dSyGhUimgKg8b/hSDyloVfVTlQUBIhjYNRYD0Gy+21?=
 =?us-ascii?Q?NvWiSvrfC7aWGKQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(7416014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kZvj7i2yWatMWgKok21qxuO25/ZN+6BjjuokE/EM7iEoAwYqWwYf9ueFoGr9?=
 =?us-ascii?Q?m5Z0a1Qdg5dMGC5dFqhmu9TxwXGwCgjv0unrtzMpitKx6MA4IXiBKcpvw639?=
 =?us-ascii?Q?rODFfE//D2cRm7aOg4aiI+7jn7JTsSEzE+J3qqRRnp3Mg7TdkF1yg18RafFf?=
 =?us-ascii?Q?CNgPC8PjAZU+qBCLVstL9SknNuzCAuK54BksftepEOs+/fuS0nvITUREMQzp?=
 =?us-ascii?Q?BBhGDrOaz2QFgH0z6XiMg0U/ir2KrovAKkpBXxE9oRjvnOtUSVOQZoYp6Vuz?=
 =?us-ascii?Q?mlnFNFYiDwM9wvzGqT9rdzBrTmq8LRuJHBcMBWwKYWxi4rDOBFU5dAhrL4Sl?=
 =?us-ascii?Q?cGDpzq5gwJUMe8XhghyY7pqURFqTRKEclkR/MDKV9qjdhmgdMdZjmsfimQIa?=
 =?us-ascii?Q?6ZpCHhNxGhn9QqJlNZH+JH/JGpzXHkBpJYf/4BGjIvgpqWY43QojLR0r8e+A?=
 =?us-ascii?Q?+vTMbPC0LmLJaVGALYXCJyns3+ctUjy0A5RuSu+LQsGEktCsB2CNRwT3q0Vf?=
 =?us-ascii?Q?jPSvsEyQvHmdqzAbUWf2KL9JChHxhf+wbrPZDUyr4eRABZ8d5/hNv+dZUX7t?=
 =?us-ascii?Q?psw+PM+hLIJiiJGc3WKd0LlVGKaVI2yKGr/nPhTJdLV3FDq5kShbwEBqk/DX?=
 =?us-ascii?Q?9r2EvgVuZ+OM01OtOddFBkEQWEuAjiet9zCSHedEl97ghvdUoFYv9PRYeHFZ?=
 =?us-ascii?Q?qMa8xG2JjnpqlpHgHupZiDUuyofgm4lickCaQm0AyvbItgT9X4Hi3C4sKbGS?=
 =?us-ascii?Q?Kft4NP3RKFrRjNxign2EBAgiZC17e0c2FZDJ64nZp7rQ03dUJQzRSv7A9zgm?=
 =?us-ascii?Q?wfUOaNqdU6QDfMQlCer5Kn+l9r+l+7Fxkb2W1I/p1D0QggohNFS3FUT6o14t?=
 =?us-ascii?Q?NfNhM+Orz36H2n/S4WPYFYkufeKF7pb+94fB8DZssSkGD4NR2yYvw34Aq0Hq?=
 =?us-ascii?Q?h2+r9Z9tpwInFtVlf7aq/LBvLrtKIrgEqjh2a265YgRG8k1H5Vrie0ITK1kR?=
 =?us-ascii?Q?hCO8w3xHcXYMqBAemne9P7Qg9xYA6P9WKMB0OshzSgdL+esd1AQrV3RevpnU?=
 =?us-ascii?Q?9NhGcrNvVMmv9esjPopwx3Ro+Hu3UcuezHSMs0OQ9F+4UeNC/yuy7SQLU0XE?=
 =?us-ascii?Q?xMfo0cvYA05RZ/TQ1jqZ4YE5tsdBzJs+YiJimayJrjYGz2lA0i+9d5uWeYja?=
 =?us-ascii?Q?kYfOR/jAPFMB2VkgcFCegcyUHuyMH24tPIicc3As9ZLctA/mwKxLn4Ahdmjc?=
 =?us-ascii?Q?RDCi7i6QATEVYIskLj/evyMT4TOXDnEEgUcNu7bMekj75Gs16B/TGzSFi1J/?=
 =?us-ascii?Q?7w6y/h60BLg+Ml+w9xppP1xTrgoLunSOQNWxj/dEp+H2VXWpvo7W5zlyBhZi?=
 =?us-ascii?Q?Cbr8UWRgrtXhjb6OVoNcZR7X8lJLH1fXJFwi44nBhi42HWbTH5zqaNBlAdvw?=
 =?us-ascii?Q?uDHjhcxp+fMdMLQxACVsmm4p8UAvBJsl13y/PgHJvJlPKc/2tqT8DvVmy3mG?=
 =?us-ascii?Q?Wau1+pbt0O8+bammPq/tRyCPmtlbSiDQ1LpPu/nnR7UcztqjM0UPKRJxQj9C?=
 =?us-ascii?Q?+jCHXQskf4DGAZmwSOj7/3qxcn3UHUuy03wY3VLM?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79645112-ef2d-48c6-b466-08dd7dae6a68
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 12:50:22.5462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8Fq33PyVwQgTKX/spb+jY75lwg5keVDIWynkK9EktA2/m40yy8uu2fDyO3VpBg9HHxbgCGTzTBPK4lmBph5xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6679

Follow JESD220G, support HID(Host Initiated Defragmentation)
through sysfs, the host can perform HID related operations
through these nodes:1.It can use hid_trigger to enable kworkers
to automatically perform complete HID operations;2.manual HID
operation can also be achieved through other nodes.
The relevant sysfs nodes are as follows:
	1.hid_trigger
	2.defrag_operation
	3.hid_available_size
	4.hid_size
	5.hid_progress_ratio
	6.hid_state
The detailed definition of the six nodes can be	found in the sysfs
documentation.

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Wenxing Cheng <wenxing.cheng@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  82 ++++++++++++
 drivers/ufs/core/Kconfig                   |   9 ++
 drivers/ufs/core/Makefile                  |   1 +
 drivers/ufs/core/ufs-hid.c                 | 130 ++++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 149 ++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h             |   8 ++
 drivers/ufs/core/ufshcd.c                  |   7 +
 include/ufs/ufs.h                          |  28 +++-
 include/ufs/ufshcd.h                       |   2 +
 9 files changed, 414 insertions(+), 2 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-hid.c

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index ae0191295d29..80350d1f8662 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,85 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid_trigger
+What:		/sys/bus/platform/devices/*.ufs/hid_trigger
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable or disable complete HID.
+
+		========  ============
+		enable    Let kworker(ufs_hid_enable_work) execute the complete HID
+		disable   Cancel kworker(ufs_hid_enable_work) and disable HID
+		========  ============
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/defrag_operation
+What:		/sys/bus/platform/devices/*.ufs/attributes/defrag_operation
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable or disable HID analysis and HID defrag operations.
+
+		===============  ==================================================
+		all_disable      HID analysis and HID defrag operation are disabled
+		analysis_enable  HID analysis is enabled
+		all_enable       HID analysis and HID defrag operation are enabled
+		===============  ==================================================
+
+		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/hid_available_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/hid_available_size
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The total fragmented size in the device is reported through this
+		attribute.
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/hid_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/hid_size
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host sets the size to be defragmented by an HID defrag operation.
+
+		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/hid_progress_ratio
+What:		/sys/bus/platform/devices/*.ufs/attributes/hid_progress_ratio
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		Defrag progress is reported by this attribute,indicates the ratio of
+		the completed defrag size over the requested defrag size.
+
+		====  ======================================
+		01h   1%
+		...
+		64h   100%
+		====  ======================================
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/hid_state
+What:		/sys/bus/platform/devices/*.ufs/attributes/hid_state
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The HID state is reported by this attribute.
+
+		====   ======================================
+		00h    Idle(analysis required)
+		01h    Analysis in progress
+		02h    Defrag required
+		03h    Defrag in progress
+		04h    Defrag completed
+		05h    Defrag is not required
+		====  ======================================
+
+		The attribute is read only.
\ No newline at end of file
diff --git a/drivers/ufs/core/Kconfig b/drivers/ufs/core/Kconfig
index 817208ee64ec..9ac04ba18061 100644
--- a/drivers/ufs/core/Kconfig
+++ b/drivers/ufs/core/Kconfig
@@ -50,3 +50,12 @@ config SCSI_UFS_HWMON
 	  a hardware monitoring device will be created for the UFS device.
 
 	  If unsure, say N.
+
+config SCSI_UFS_HID
+	bool "Support UFS Host Initiated Defrag"
+	help
+	  The UFS HID feature allows the host to check the status of whether
+	  defragmentation is needed or not and enable the device's internal
+	  defrag operation explicitly.
+
+	  If unsure, say N.
diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
index cf820fa09a04..2e11f4bdb80d 100644
--- a/drivers/ufs/core/Makefile
+++ b/drivers/ufs/core/Makefile
@@ -7,3 +7,4 @@ ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
 ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
 ufshcd-core-$(CONFIG_SCSI_UFS_HWMON)	+= ufs-hwmon.o
+ufshcd-core-$(CONFIG_SCSI_UFS_HID)	+= ufs-hid.o
diff --git a/drivers/ufs/core/ufs-hid.c b/drivers/ufs/core/ufs-hid.c
new file mode 100644
index 000000000000..98c117d21622
--- /dev/null
+++ b/drivers/ufs/core/ufs-hid.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+ /*
+  * Universal Flash Storage Host Initiated Defragmentation
+  * Authors:
+  *	Huan Tang <tanghuan@vivo.com>
+  *	Wenxing Cheng <wenxing.cheng@vivo.com>
+  */
+
+#include <linux/unaligned.h>
+#include <linux/device.h>
+#include <linux/stddef.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <linux/container_of.h>
+#include "ufshcd-priv.h"
+
+#define HID_SCHED_COUNT_LIMIT	300
+static int hid_sched_cnt;
+static void ufs_hid_enable_work_fn(struct work_struct *work)
+{
+	struct ufs_hba *hba;
+	int ret = 0;
+	enum ufs_hid_defrag_operation defrag_op;
+	u32 hid_ahit = 0;
+	bool hid_flag = false;
+
+	hba = container_of(work, struct ufs_hba, ufs_hid_enable_work.work);
+
+	if (!hba->dev_info.hid_sup)
+		return;
+
+	down(&hba->host_sem);
+
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	hid_ahit = hba->ahit;
+	ufshcd_auto_hibern8_update(hba, 0);
+
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_STATE, 0, 0, &hba->dev_info.hid_state);
+	if (ret)
+		hba->dev_info.hid_state = HID_IDLE;
+
+	switch (hba->dev_info.hid_state) {
+	case HID_IDLE:
+		defrag_op = HID_ANALYSIS_ENABLE;
+		hid_flag = true;
+		break;
+	case DEFRAG_REQUIRED:
+		defrag_op = HID_ANALYSIS_AND_DEFRAG_ENABLE;
+		hid_flag = true;
+		break;
+	case DEFRAG_COMPLETED:
+	case DEFRAG_IS_NOT_REQUIRED:
+		defrag_op = HID_ANALYSIS_AND_DEFRAG_DISABLE;
+		hid_flag = true;
+		break;
+	case ANALYSIS_IN_PROGRESS:
+	case DEFRAG_IN_PROGRESS:
+	default:
+		break;
+	}
+
+	if (hid_flag) {
+		ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, 0, 0, &defrag_op);
+		hid_flag = false;
+	}
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_HID_STATE, 0, 0, &hba->dev_info.hid_state);
+	if (ret)
+		hba->dev_info.hid_state = HID_IDLE;
+
+	ufshcd_auto_hibern8_update(hba, hid_ahit);
+	ufshcd_rpm_put_sync(hba);
+	up(&hba->host_sem);
+
+	if (hba->dev_info.hid_state != HID_IDLE &&
+			hid_sched_cnt++ < HID_SCHED_COUNT_LIMIT)
+		schedule_delayed_work(&hba->ufs_hid_enable_work,
+					msecs_to_jiffies(1000));
+	else
+		hid_sched_cnt = 0;
+}
+
+int ufs_hid_disable(struct ufs_hba *hba)
+{
+	enum ufs_hid_defrag_operation defrag_op = HID_ANALYSIS_AND_DEFRAG_DISABLE;
+	u32 hid_ahit;
+	int ret;
+
+	down(&hba->host_sem);
+
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	hid_ahit = hba->ahit;
+	ufshcd_auto_hibern8_update(hba, 0);
+
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, 0, 0, &defrag_op);
+
+	ufshcd_auto_hibern8_update(hba, hid_ahit);
+	ufshcd_rpm_put_sync(hba);
+	up(&hba->host_sem);
+
+	return ret;
+}
+
+void ufs_hid_init(struct ufs_hba *hba, const u8 *desc_buf)
+{
+	u32 ext_ufs_feature;
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+
+	ext_ufs_feature = get_unaligned_be32(desc_buf +
+				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+
+	if (ext_ufs_feature & UFS_DEV_HID_SUPPORT) {
+		dev_info->hid_sup = true;
+		INIT_DELAYED_WORK(&hba->ufs_hid_enable_work,
+				ufs_hid_enable_work_fn);
+	}
+}
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab60f5ae..0a56751ab7dc 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -81,6 +81,21 @@ static const char *ufshcd_ufs_dev_pwr_mode_to_string(
 	}
 }
 
+static const char *ufs_hid_defrag_operation_to_string(
+			enum ufs_hid_defrag_operation op)
+{
+	switch (op) {
+	case HID_ANALYSIS_AND_DEFRAG_DISABLE:
+		return "all_disable";
+	case HID_ANALYSIS_ENABLE:
+		return "analysis_enable";
+	case HID_ANALYSIS_AND_DEFRAG_ENABLE:
+		return "all_enable";
+	default:
+		return "unknown";
+	}
+}
+
 static inline ssize_t ufs_sysfs_pm_lvl_store(struct device *dev,
 					     struct device_attribute *attr,
 					     const char *buf, size_t count,
@@ -466,6 +481,34 @@ static ssize_t critical_health_show(struct device *dev,
 	return sysfs_emit(buf, "%d\n", hba->critical_health_count);
 }
 
+static const char * const hid_trigger_mode[] = {
+	"disable", "enable"
+};
+
+static ssize_t hid_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	int ret = 0;
+
+	if (!hba->dev_info.hid_sup)
+		return -EOPNOTSUPP;
+
+	mode = sysfs_match_string(hid_trigger_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	if (mode)
+		schedule_delayed_work(&hba->ufs_hid_enable_work, 0);
+	else {
+		cancel_delayed_work_sync(&hba->ufs_hid_enable_work);
+		ret = ufs_hid_disable(hba);
+	}
+
+	return ret < 0 ? ret : count;
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -479,6 +522,7 @@ static DEVICE_ATTR_RW(wb_flush_threshold);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
+static DEVICE_ATTR_WO(hid_trigger);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -494,6 +538,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
+	&dev_attr_hid_trigger.attr,
 	NULL
 };
 
@@ -1495,6 +1540,101 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
 
+static int hid_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+				enum attr_idn idn, u32 *attr_val)
+{
+	int ret;
+
+	if (!hba->dev_info.hid_sup)
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, opcode, idn, 0, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t defrag_operation_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%s\n", ufs_hid_defrag_operation_to_string(value));
+}
+
+static const char * const hid_defrag_operation[] = {
+	[HID_ANALYSIS_AND_DEFRAG_DISABLE]	= "all_disable",
+	[HID_ANALYSIS_ENABLE]	= "analysis_enable",
+	[HID_ANALYSIS_AND_DEFRAG_ENABLE]	= "all_enable",
+};
+
+static ssize_t defrag_operation_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int defrag_op;
+	int ret;
+
+	defrag_op = sysfs_match_string(hid_defrag_operation, buf);
+	if (defrag_op < 0)
+		return -EINVAL;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &defrag_op);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_RW(defrag_operation);
+
+static ssize_t hid_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_HID_SIZE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "0x%08X\n", value);
+}
+
+static ssize_t hid_size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int value;
+	int ret;
+
+	if (kstrtou32(buf, 0, &value))
+		return -EINVAL;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+					QUERY_ATTR_IDN_HID_SIZE, &value);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_RW(hid_size);
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -1545,7 +1685,9 @@ UFS_ATTRIBUTE(wb_flush_status, _WB_FLUSH_STATUS);
 UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
 UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
 UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
-
+UFS_ATTRIBUTE(hid_available_size, _HID_AVAILABLE_SIZE);
+UFS_ATTRIBUTE(hid_progress_ratio, _HID_PROGRESS_RATIO);
+UFS_ATTRIBUTE(hid_state, _HID_STATE);
 
 static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_boot_lun_enabled.attr,
@@ -1568,6 +1710,11 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_defrag_operation.attr,
+	&dev_attr_hid_available_size.attr,
+	&dev_attr_hid_size.attr,
+	&dev_attr_hid_progress_ratio.attr,
+	&dev_attr_hid_state.attr,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 10b4a19a70f1..cc4c817dad9f 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -42,6 +42,14 @@ static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
 static inline void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {}
 #endif
 
+#ifdef CONFIG_SCSI_UFS_HID
+void ufs_hid_init(struct ufs_hba *hba, const u8 *desc_buf);
+int ufs_hid_disable(struct ufs_hba *hba);
+#else
+static inline void ufs_hid_init(struct ufs_hba *hba, const u8 *desc_buf) {}
+static inline int ufs_hid_disable(struct ufs_hba *hba) {return 0; }
+#endif
+
 int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 				  enum query_opcode opcode,
 				  enum desc_idn idn, u8 index,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 83b092cbb864..93eee2774c1b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6536,6 +6536,9 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
 
+	if (hba->dev_info.hid_sup)
+		cancel_delayed_work_sync(&hba->ufs_hid_enable_work);
+
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
@@ -8317,6 +8320,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufshcd_temp_notif_probe(hba, desc_buf);
 
+	ufs_hid_init(hba, desc_buf);
+
 	if (dev_info->wspecversion >= 0x410) {
 		hba->critical_health_count = 0;
 		ufshcd_enable_ee(hba, MASK_EE_HEALTH_CRITICAL);
@@ -9614,6 +9619,8 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		req_link_state = UIC_LINK_OFF_STATE;
 	}
 
+	if (hba->dev_info.hid_sup)
+		cancel_delayed_work_sync(&hba->ufs_hid_enable_work);
 	/*
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8a24ed59ec46..6e8546024e09 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,12 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
+	QUERY_ATTR_IDN_HID_DEFRAG_OPERATION	= 0x35,
+	QUERY_ATTR_IDN_HID_AVAILABLE_SIZE	= 0x36,
+	QUERY_ATTR_IDN_HID_SIZE			= 0x37,
+	QUERY_ATTR_IDN_HID_PROGRESS_RATIO	= 0x38,
+	QUERY_ATTR_IDN_HID_STATE		= 0x39,
 };
 
 /* Descriptor idn for Query requests */
@@ -390,6 +395,7 @@ enum {
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
+	UFS_DEV_HID_SUPPORT	= BIT(13),
 };
 #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
 
@@ -454,6 +460,23 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
+/* bDefragOperation attribute values */
+enum ufs_hid_defrag_operation {
+	HID_ANALYSIS_AND_DEFRAG_DISABLE	= 0,
+	HID_ANALYSIS_ENABLE	= 1,
+	HID_ANALYSIS_AND_DEFRAG_ENABLE	= 2,
+};
+
+/* bHIDState attribute values */
+enum ufs_hid_state {
+	HID_IDLE	= 0,
+	ANALYSIS_IN_PROGRESS	= 1,
+	DEFRAG_REQUIRED	= 2,
+	DEFRAG_IN_PROGRESS	= 3,
+	DEFRAG_COMPLETED	= 4,
+	DEFRAG_IS_NOT_REQUIRED	= 5,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
@@ -590,6 +613,9 @@ struct ufs_dev_info {
 	u32 rtc_update_period;
 
 	u8 rtt_cap; /* bDeviceRTTCap */
+
+	bool hid_sup;
+	enum ufs_hid_state hid_state;
 };
 
 /*
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f56050ce9445..8a8c7268d667 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1138,6 +1138,8 @@ struct ufs_hba {
 	bool pm_qos_enabled;
 
 	int critical_health_count;
+
+	struct delayed_work ufs_hid_enable_work;
 };
 
 /**
-- 
2.39.0

