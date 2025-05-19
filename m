Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011059.outbound.protection.outlook.com [52.101.129.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B6F84D08;
	Mon, 19 May 2025 02:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747621769; cv=fail; b=KL4fHYiHoerjH48FhYn33AyBL6MgyY8x2l7DDtz1xHqQ31xI6j+g8z0rHKq0ZJbLTj6C0fG/D8x4dYnkh89amcsS/jUB1If/0Ev+XFXRE+JJn9Ta57sFK2KErXSWm6RYXYUemqLesrh53brPtIIj4vgTkKtwcBFcJsgw4kwlLKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747621769; c=relaxed/simple;
	bh=b9vwM9LiKz3sPlhM8aOH2twhnWvuzbtWsyLBab3Jr08=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=JFfbtrkVSj2ywuWBVU8lStvHyqnWILJusTuD3oLE4rhCY+bqKGx1nR59WZpcP/Z9UfNIrEHZDoHO1nTIAPfrVnoPQkE0DEudVzOFrUtMew7dqNjxcnRS2/ljlgW58XSpTmZxZ/8RNiZMYiRqrlnvVOjo61yofL2FmPAWi+skXWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=oMkEq0Xl; arc=fail smtp.client-ip=52.101.129.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="oMkEq0Xl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CyUrQhFuUwmAj7eyamsMn+9feIsTyMRKiubw7OsUi+kbW0UHOmK1sL+cRD5mWXHs5PhoTKNcRMQamzTUQcE1rdgShE4s9jkimsvWfGmhtqFxQJ+qxN7SxFXM8u0gGPqSLODhrC182J8mhzu6nQBGuEVGUkHq50295SwVprCz/WN/PqXlePTKYbBZ605DMjwntZJZ9xqky3cW6RkEtDDAgp+oNWHK96VX6TK9axwxWjJvTsu9Oyb3bF5sQDdfZBrtxPH3JF4A5MIwgz+/7VoJLnsl8ybAOWOGtQzG6H4AGPAZbkv+0XGx6CupvwWMvKwUXEhhkQQbo8v2ICbV+IQ0qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zYBXyyVjJ/XBFt/uXvmI3J+3GEM/ZMobp0uzIr1cqw=;
 b=vmKlNWiV9XtXZ4vczky3c6I9+W4mFyTQRv8WbLtiqQHcpIO9dY8ZJxsp21IJ0CjCB3v9ftJNCTaQal82Lkyvt32NdsQRxrXLPYlqETF3Hyk8O+VCBmLNbYr/I0nMw4aeDBEmAJL5Op96QZVrkcmZyDPDOfhherG5HkicW0gnphDtLu0D8eQycNd3FTCu5whLO0l6YJiO7KGxkl5poYXvIqCbZc7JLmWBg/nVmCWzsoRsdYTgDVO3x68g+eS3A3tjiwio5j/V8otJGCwXs+akx2n+hyqm/BbDH+sfvpxQ4lT7x5DdM1EAPYGTyBwV4uME99+ZkjBlnjg6QUny5ifikw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zYBXyyVjJ/XBFt/uXvmI3J+3GEM/ZMobp0uzIr1cqw=;
 b=oMkEq0XlGa7n7CLKiBEah+5zLznkQ0yPaiOs/ytWY4N5R63Selk9oRnDoD3qSn0NYc/gsa1Ex3yC+tbEiFt9MFOeTodCQdFw5/TMq4x8t6inFGY0rkQvJyv30VJqZlch+N6qq5UvKdvjJHkovaRWecscx66ZSPP2qFWrW1Keudzqyp2v9QlDpC4wn8u9G2RZ1qPwjMcMchueXxfB4hPqhVkSbHHOoRuQNdM0E1wP/3nkhS1O/6td6K/gnkfu0hUhoacqJ3B/VjrMN4+jANxiWWsP+3Y5d6cktlrUmLleYkGbVcnwqLNgrGc29wkgHe9tF6IFFGgPndy5SGCpXArYAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by JH0PR06MB6966.apcprd06.prod.outlook.com (2603:1096:990:68::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 02:29:22 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 02:29:22 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	quic_nguyenb@quicinc.com,
	luhongfei@vivo.com,
	tanghuan@vivo.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com,
	Wenxing Cheng <wenxing.cheng@vivo.com>
Subject: [PATCH v3] ufs: core: Add HID support
Date: Mon, 19 May 2025 10:29:12 +0800
Message-Id: <20250519022912.292-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|JH0PR06MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: d6a8c0f6-592d-4d96-2752-08dd967cf6e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|52116014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fNHcsNtMb0mPytAoOqvjkxmjONBs1P6HzwvXdz2szDhmBsgh8vadHbog3oaM?=
 =?us-ascii?Q?xz/Cw7wVTzWKe/Um+Xdpii0wMZiyH6gCD6jwZpmeP/h+0aLc+bMaYKBly0zY?=
 =?us-ascii?Q?yghUeE0b9GZ5jvni5uKCgqY367TurlNxk+Gs78Nf7VQiQ926wdN04FPPMkeN?=
 =?us-ascii?Q?ryIO4QlasCTpSS/KSjmUyAKCLrjIDJv/xt4F54W/sbOQVFWeB55oWY3DRSLA?=
 =?us-ascii?Q?cV8Y8iHdgOxkmyBpmfSyQHN7MKYPVPfk2UfzyKfvWL4kAeNPFeojLxqyYhTu?=
 =?us-ascii?Q?g4BroKuvHIzSOAfVgWZMuOWkf4KQqIec0vPdAWOPVEIO0oFnLRMvd9c2w4dL?=
 =?us-ascii?Q?P6qaLpIT/YI07JxWi3Y7dPiLTcEag9a8vIs03NYbU/94an4WCIjKnN6opyFI?=
 =?us-ascii?Q?N4eWsrlpqBtU5rZ2ysFj/Q0kr/olmbpHGV9K+KfSNEWNH4lxnj1IqWpPC30n?=
 =?us-ascii?Q?gcGDfvUXSHdxWi/jJchExAhbs4q0zQH85ft7W1lMlA78A8ePo6CAVsSbMIjb?=
 =?us-ascii?Q?dOH0VxvRSwTu/hZ65wMywQoIGpj8a3vSwec4U7zgeZITxQHpULLJDCMNL3JK?=
 =?us-ascii?Q?CfWD3vFwPlPyR18ZGW5ArVsR6bLemilLzujWRX7646BxQwoJgWGXl90LzbKB?=
 =?us-ascii?Q?nP0O7XLRy2FsigRyuuDfLb7rPNFm6PJRb/fPEK57EsDxDiRK+W0080n6Z+0k?=
 =?us-ascii?Q?dPOU0gGHFgpRkLWTbQ6El74KvZOLOzJ4iibUylmUqidUSc3L7iuT6twqdo1W?=
 =?us-ascii?Q?bEdsw7FQhTUaMfe1kxoWbdwfMG4ncSSoUzDrefut1MqINk+HDfCKX7LKEqLK?=
 =?us-ascii?Q?BZTVqcsCqtuoMC2y0uVB4W7pDura3oRSu96E341sk7ehUVpHdr4hSbNAZYud?=
 =?us-ascii?Q?T0d9qTriuD5W7chUBSHXLAcdqMCtH/Cnkd9z/fQlCtLbVFgxFs4tSC6X0Sn0?=
 =?us-ascii?Q?DXS01XYTvC6oGsd71I34UBlBCOhh4VhmovKynKt9tfr3Abm0xe93naQ3FLlh?=
 =?us-ascii?Q?Dmm0VQXe17gqPvL9YBhR/5xxG2MmjvWoeAFV/lTCclqgcMWmSSC8/iI+WviB?=
 =?us-ascii?Q?QLdfi20LfM5H0VBDJrFTHFga3+gRchXT1+5XLo/34x3gvx2dbg66t8Fj6Kxm?=
 =?us-ascii?Q?6TtORl5eFX1Qo2WcQp7QR+NfYeHta/LKAPk1L9Ycd40fPpGoY0tNuRSfKHp3?=
 =?us-ascii?Q?/6A8SRK5+G42XodmO63D4Urn6YDG2NUgtmIU/dGnlL8lWxM7whYAII8lmOqC?=
 =?us-ascii?Q?H/EYC/WXbGRgwPIcuy5zSf3ALSx7U+UJsm3O470uvg7MmvS35G5Cvc614mWp?=
 =?us-ascii?Q?cGjbnc/PDFKF5qhnEhI8LVFUqU/fBz6uXQ/h8yxLnjHPqbVdjBj65N5nNE2P?=
 =?us-ascii?Q?MEK1eUI4MFNLb1SdJ+Bik+IVu2RUx4eMhei5tO5TOyS2lZ1EJLasVY/Vwe7s?=
 =?us-ascii?Q?hK9WUgM8qJqfgYDHG7pFnNqzIGM+q32CggB68BPTNjOckz9MGdoJb3vhtPNO?=
 =?us-ascii?Q?vkCumZHGo0LXzP0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(52116014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+ejcZMB4pqpwLn6K7q36/axviLTDzJwNRbF1PuSoMrT5QTjOSE3PC3/A2ixn?=
 =?us-ascii?Q?XcuMdd2uHVqtFFFRvUkv/rLNnpMZMHr/Zt6VujrLRqH24WDvtMR488V/LDUF?=
 =?us-ascii?Q?9I6ubiDRxQVYSK4SKfOyW89aQNZSnmLaHXk+D175iq36+HmH9wdc1+nszp75?=
 =?us-ascii?Q?jYAZucKLUt8FzqHgyHsLFba4Um4LBDh4fejWtwwNA9mBc+DAxymf3ZcolR/H?=
 =?us-ascii?Q?ckLGjaFOj5g+yeVW330mbPpKpAjPG76LYzQjgRNmpO7KL6Qe7SH5l1g3g5Ib?=
 =?us-ascii?Q?HMkZSg8Usg9ipMwGgPaCNzpyIknN+2XI9qepPTIRU9kHFQmeCo+PG/jHjwvH?=
 =?us-ascii?Q?2+zd8ecFbVWsB9/N+wsvANCF/9LWP3R11S3At65+jR4+kxTdno9bbO1B3T6r?=
 =?us-ascii?Q?sJjvX355h9zi0+YB090IOpDyJjlrEQRKONzIvV8JFd5eqLlXwWt3ZiMUs1qd?=
 =?us-ascii?Q?DfTzjFkmhIwqhk29/iOLFMeqXY1SWpLLRTHaqh6tRRviFl7UV15EGZCMw8Qu?=
 =?us-ascii?Q?ZcB++Vwn1kE1yLeEm5znz1t3o+t6M9+X+XHa2TgZIaTyChB9P4JD5wUPjr+V?=
 =?us-ascii?Q?9sxqGzwdFRYcaeaBLGpmSpUB29m07ONXVp6ew2U+NzM0rVPvPJQKI3DNQT+w?=
 =?us-ascii?Q?+O4kYRRMZLKrVBKNhLOIp4Irb5hJ0j02FtnrB3Eq4tWd1i+gnFT0u3tzMLBt?=
 =?us-ascii?Q?CCEJJmaFGUkVIki27BaR1nVD5TfN3U3ipWMqf/G+w7ZplR5xqfNfpv6qkh4Q?=
 =?us-ascii?Q?NnAU6YV+mUiLkPKnCe7JOw7ii2t3bs/F0b2R36TVUv61P3xUisslx9tQCeOe?=
 =?us-ascii?Q?tToCBmbxJiHICnyi1KNpQlyHxpmM8gjDfOMt2Ys1wmmNutLa1l1M4Q8n+V9h?=
 =?us-ascii?Q?+dff+T9b25thkXTuLBA7OLppTtukF/iXLDnLtGudT5HRiTXU7Wq8ZJWSuT1m?=
 =?us-ascii?Q?mb+nINU+0hvE2nSFgiQWVR9ezQ+7+CPQuhGVKv7HUdomaBB0mBAlWYjdpDaE?=
 =?us-ascii?Q?3YWVfld6gxEqfiMAtWNiMrhIMOpHY+ZRHpgzsy0MaxqGzHWgcLPyjFgegL9D?=
 =?us-ascii?Q?w2bDeRv/uVA8R/uIrwfC1Pf90NYAQQNO/lLnMoMqXnM2jkiuvtgMiOD643b3?=
 =?us-ascii?Q?Fw1B2rL7K1t09eVtM+d8l9ejv61B8/70gpzY8/6vM2+AR2DCuFH9XftiF/ZG?=
 =?us-ascii?Q?jMYPA8812ByJB2aMR0NYgnxmbXpfA3o8xL1ebPE5TMlYQw38w3/8b+JjTqYL?=
 =?us-ascii?Q?QGAhTAVcIb2V46EHnRDmrMDU8qXzTtW9lEtojQD+cFEOe6Z96xDJ8BLgSN9S?=
 =?us-ascii?Q?uVwgF7k4XlPVyrAQx6ak4ER1jZKz6tBqhjkm+w1sCIJNRDXGaDjiD/AlCrZc?=
 =?us-ascii?Q?+OHJB21FQ3nMumLTojEYICRpE3gviNjRZuQnTCY7jEmlxy6CWiQ8rpe4/+vd?=
 =?us-ascii?Q?tk0dSuIp53Zao4aix9MHdU75IucpK0bjEOTActzAC5EEjWEkvYtaBli8W5zv?=
 =?us-ascii?Q?rTPeMUgsAkHVX9q++sl+/BuqssfnQZ9OPBg8hbdcmKhwlBvberubUtrleFav?=
 =?us-ascii?Q?Z8AwS4mBxvdZsXPzc7NHBP7GSSweH/s4VLN88/hP?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a8c0f6-592d-4d96-2752-08dd967cf6e2
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 02:29:22.0868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybuxESG2+t2SKC04uwjUR8arM/dmPlKPwWoRNbXCRro+NXBK1ILdcK4dpYPNixSzxS0OIO0rsRYD/jpleo6oTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6966

Follow JESD220G, support HID(Host Initiated Defragmentation)
through sysfs, the relevant sysfs nodes are as follows:
	1.analysis_trigger
	2.defrag_trigger
	3.fragmented_size
	4.defrag_size
	5.progress_ratio
	6.state
The detailed definition	of the six nodes can be	found in the sysfs
documentation.

HID's execution policy is given to user-space.

Changelog
===
v2 - > v3:
	1.Remove the "ufs_" prefix from directory name
	2.Remove the "hid_" prefix from node names
	3.Make "ufs" appear only once in the HID group name
	4.Add "is_visible" callback for "ufs_sysfs_hid_group"
v1 - > v2:
	1.Refactor the HID code according to Bart and Peter and
	Arvi's suggestions

v2
	https://lore.kernel.org/all/20250512131519.138-1-tanghuan@vivo.com/
v1
	https://lore.kernel.org/all/20250417125008.123-1-tanghuan@vivo.com/

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Wenxing Cheng <wenxing.cheng@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  83 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 192 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |   4 +
 include/ufs/ufs.h                          |  25 +++
 4 files changed, 304 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d4140dc6c5ba..24485df80ccb 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1685,3 +1685,86 @@ Description:
 		================  ========================================
 
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/analysis_trigger
+What:		/sys/bus/platform/devices/*.ufs/hid/analysis_trigger
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable or disable HID analysis operation.
+
+		=======  =========================================
+		disable   disable HID analysis operation
+		enable    enable HID analysis operation
+		=======  =========================================
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/defrag_trigger
+What:		/sys/bus/platform/devices/*.ufs/hid/defrag_trigger
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable or disable HID defragmentation operation.
+
+		=======  =========================================
+		disable   disable HID defragmentation operation
+		enable    enable HID defragmentation operation
+		=======  =========================================
+
+		The attribute is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/fragmented_size
+What:		/sys/bus/platform/devices/*.ufs/hid/fragmented_size
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The total fragmented size in the device is reported through
+		this attribute.
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/defrag_size
+What:		/sys/bus/platform/devices/*.ufs/hid/defrag_size
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host sets the size to be defragmented by an HID
+		defragmentation operation.
+
+		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/progress_ratio
+What:		/sys/bus/platform/devices/*.ufs/hid/progress_ratio
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		Defragmentation progress is reported by this attribute,
+		indicateds the ratio of the completed defragmentation size
+		over the requested defragmentation size.
+
+		====  ============================================
+		1     1%
+		...
+		100   100%
+		====  ============================================
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/state
+What:		/sys/bus/platform/devices/*.ufs/hid/state
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The HID state is reported by this attribute.
+
+		====================   ===========================
+		idle			Idle(analysis required)
+		analysis_in_progress    Analysis in progress
+		defrag_required      	Defrag required
+		defrag_in_progress      Defrag in progress
+		defrag_completed      	Defrag completed
+		defrag_not_required     Defrag is not required
+		====================   ===========================
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index de8b6acd4058..ba6371740b30 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -87,6 +87,26 @@ static const char *ufs_wb_resize_status_to_string(enum wb_resize_status status)
 	}
 }
 
+static const char *ufs_hid_state_to_string(enum ufs_hid_state state)
+{
+	switch (state) {
+	case HID_IDLE:
+		return "idle";
+	case ANALYSIS_IN_PROGRESS:
+		return "analysis_in_progress";
+	case DEFRAG_REQUIRED:
+		return "defrag_required";
+	case DEFRAG_IN_PROGRESS:
+		return "defrag_in_progress";
+	case DEFRAG_COMPLETED:
+		return "defrag_completed";
+	case DEFRAG_IS_NOT_REQUIRED:
+		return "defrag_not_required";
+	default:
+		return "unknown";
+	}
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -1763,6 +1783,177 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
 	.attrs = ufs_sysfs_attributes,
 };
 
+static int hid_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+			enum attr_idn idn, u32 *attr_val)
+{
+	int ret;
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
+static const char * const hid_trigger_mode[] = {"disable", "enable"};
+
+static ssize_t analysis_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	int ret;
+
+	mode = sysfs_match_string(hid_trigger_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_WO(analysis_trigger);
+
+static ssize_t defrag_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	int ret;
+
+	mode = sysfs_match_string(hid_trigger_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	if (mode)
+		mode = HID_ANALYSIS_AND_DEFRAG_ENABLE;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_WO(defrag_trigger);
+
+static ssize_t fragmented_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_AVAILABLE_SIZE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static DEVICE_ATTR_RO(fragmented_size);
+
+static ssize_t defrag_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_SIZE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static ssize_t defrag_size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	if (kstrtou32(buf, 0, &value))
+		return -EINVAL;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_SIZE, &value);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_RW(defrag_size);
+
+static ssize_t progress_ratio_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_PROGRESS_RATIO, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static DEVICE_ATTR_RO(progress_ratio);
+
+static ssize_t state_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_STATE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%s\n", ufs_hid_state_to_string(value));
+}
+
+static DEVICE_ATTR_RO(state);
+
+static struct attribute *ufs_sysfs_hid[] = {
+	&dev_attr_analysis_trigger.attr,
+	&dev_attr_defrag_trigger.attr,
+	&dev_attr_fragmented_size.attr,
+	&dev_attr_defrag_size.attr,
+	&dev_attr_progress_ratio.attr,
+	&dev_attr_state.attr,
+	NULL,
+};
+
+static umode_t  ufs_sysfs_hid_is_visible(struct kobject *kobj,
+		struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return	hba->dev_info.hid_sup ? attr->mode : 0;
+}
+
+static const struct attribute_group ufs_sysfs_hid_group = {
+	.name = "hid",
+	.attrs = ufs_sysfs_hid,
+	.is_visible = ufs_sysfs_hid_is_visible,
+};
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
 	&ufs_sysfs_capabilities_group,
@@ -1777,6 +1968,7 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_string_descriptors_group,
 	&ufs_sysfs_flags_group,
 	&ufs_sysfs_attributes_group,
+	&ufs_sysfs_hid_group,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3e2097e65964..8ccd923a5761 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8390,6 +8390,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	dev_info->rtt_cap = desc_buf[DEVICE_DESC_PARAM_RTT_CAP];
 
+	dev_info->hid_sup = get_unaligned_be32(desc_buf +
+				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
+				UFS_DEV_HID_SUPPORT;
+
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
 	err = ufshcd_read_string_desc(hba, model_index,
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index c0c59a8f7256..e61caa40f7cd 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -182,6 +182,11 @@ enum attr_idn {
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
 	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
 	QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID     = 0x34,
+	QUERY_ATTR_IDN_HID_DEFRAG_OPERATION	= 0x35,
+	QUERY_ATTR_IDN_HID_AVAILABLE_SIZE	= 0x36,
+	QUERY_ATTR_IDN_HID_SIZE			= 0x37,
+	QUERY_ATTR_IDN_HID_PROGRESS_RATIO	= 0x38,
+	QUERY_ATTR_IDN_HID_STATE		= 0x39,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
@@ -401,6 +406,7 @@ enum {
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 	UFS_DEV_LVL_EXCEPTION_SUP       = BIT(12),
+	UFS_DEV_HID_SUPPORT		= BIT(13),
 };
 #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
 
@@ -466,6 +472,23 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
+/* bDefragOperation attribute values */
+enum ufs_hid_defrag_operation {
+	HID_ANALYSIS_AND_DEFRAG_DISABLE	= 0,
+	HID_ANALYSIS_ENABLE		= 1,
+	HID_ANALYSIS_AND_DEFRAG_ENABLE	= 2,
+};
+
+/* bHIDState attribute values */
+enum ufs_hid_state {
+	HID_IDLE		= 0,
+	ANALYSIS_IN_PROGRESS	= 1,
+	DEFRAG_REQUIRED		= 2,
+	DEFRAG_IN_PROGRESS	= 3,
+	DEFRAG_COMPLETED	= 4,
+	DEFRAG_IS_NOT_REQUIRED	= 5,
+};
+
 /* bWriteBoosterBufferResizeEn attribute */
 enum wb_resize_en {
 	WB_RESIZE_EN_IDLE	= 0,
@@ -625,6 +648,8 @@ struct ufs_dev_info {
 	u32 rtc_update_period;
 
 	u8 rtt_cap; /* bDeviceRTTCap */
+
+	bool hid_sup;
 };
 
 /*
-- 
2.48.1

