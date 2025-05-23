Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011013.outbound.protection.outlook.com [52.101.129.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637AE1804A;
	Fri, 23 May 2025 06:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747982782; cv=fail; b=umml+1d4yuzTYEGM/8Ry6L4ovWTrbwgGDf27jOw++KQPvze7ovgyOTCd+6eNY/a5p0Oku8c/HK+cL5p9U9DI/r+CozRXplHDwZoyZE9E/HJxLQEBEe+3aSsoFtsVY6MflXJdUFI8WaGrVoOMNzjoTYQGO1+RPeieQquVo2G68FQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747982782; c=relaxed/simple;
	bh=tIJlLuvj+hUOyk2shXaZOONzbhSLH5lvUir7iaIFkIc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=NmSWuFFBPTub4kabaKmenlavoWMzrejhpn2OUpWZ2/ea+P5rgly6FJhhv9n8K7t6pfv1tnbl3ZTmK8R0AnQkSkdbd8bzBnp8V7RigYQaNYEv1UDCN0qX798w9jzqCQEiulwgQXIDVssot/wsSReK16jqpg9MsS2FFulXLXR/Cs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Sq4y0E9J; arc=fail smtp.client-ip=52.101.129.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Sq4y0E9J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h8RQxSgVliZf4u71iEl1Hv3IXv1t2Syrk/4UzS6hM9LXoDKJ/vuLsUi/3fU32tZH3muZH5aHG6x/VYMheF1bYD3dBOUDWaJKn53qPmKsXwwmv/vr23Gj93OR29uGuTMY8Kd4pm7gC6HXtD4u46+1HFtFkQHqgVyYlDd7TA+bCtscQ2p8yvIvvc9nSJP04UGZzY9Lw9k6H4PZyjibFDNwstkKqPWsp/1SpeHtszXA7CLG3q+RGGmmO+exXWVCYRb2+LLHLJMcIdufS2ykA2cdqd1kiKh1Xh8KfR8fi0HhNOMFPRL6vYQFV2RHZy8eiRRCNvD7snqvC2xubUdURO4EmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXUwkDYtpLH3KQv5nc3USqfr9A9vDlEx1GCo87USRU0=;
 b=U1iZvZ6YDbk3gqkDvONpWhTiMD6JG9V7OOyvCYMO+ZLYEXqvPYWlcR9/uxoLseZrJdQAMUAcJpqOv1ACJ+s2bRRQODp9NDpkIA5a16CuFTPIaQ804yQHjSCGFhtk4jeteQzIu4LIonjszwm7ycKZztkcA5DHHuVAfbweM5jSKu98nY0Wa3YXTaxreY7bF4f8iGA6W65JQuhTIQ9n+HRuLqaahmOQ9jET8HzVWz7oNGeJcOO818VyiUTlDGbvu0LFpWw5+KY0JgR3djYtbB7Z28KEmFCfktRZMNPvCFSl8F3+KZgVSrJRhz67CGM2p5wZiMP/fMYpu0SYKiYwimMj4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXUwkDYtpLH3KQv5nc3USqfr9A9vDlEx1GCo87USRU0=;
 b=Sq4y0E9JvAx27kx7SUfXDYVdNv5by/++UwbgO4xPSZWXUiWqTdqmOVcy0kCQqaXjcmoDuYkkjDpZrSmErCa0WsHP59owPsGvDHnBS2bpaBwGnWzHrESJSCOW+3wjXjvYFLV61ovFG3vY6vq4nZyZS21zenM5Kru5ajHznGQAD98wWHA+T3tOmu3SDZH45oprvPQyVnLQN/r2OAvkmmnujwZZOqqcMtvn+PADOjDO6smvgzmJ1BR/jmxNycokxCg7fXvjVMmOP+7ihDqIGiAssaSPegzncVaP6Rgvo2BnYxMKH2y7uktKXrwHNMVDx7oWlSHyBRN1RRR5WauE8pFPfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEZPR06MB6814.apcprd06.prod.outlook.com (2603:1096:101:197::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Fri, 23 May
 2025 06:46:14 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%6]) with mapi id 15.20.8769.021; Fri, 23 May 2025
 06:46:13 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	beanhuo@micron.com,
	peter.wang@mediatek.com,
	quic_nguyenb@quicinc.com,
	quic_ziqichen@quicinc.com,
	tanghuan@vivo.com,
	keosung.park@samsung.com,
	viro@zeniv.linux.org.uk,
	gwendal@chromium.org,
	manivannan.sadhasivam@linaro.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com,
	Wenxing Cheng <wenxing.cheng@vivo.com>,
	Bean Huo <huobean@gmail.com>
Subject: [PATCH v6] ufs: core: Add HID support
Date: Fri, 23 May 2025 14:46:04 +0800
Message-Id: <20250523064604.800-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:4:188::16) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEZPR06MB6814:EE_
X-MS-Office365-Filtering-Correlation-Id: a7dbefcf-24d9-4d37-d311-08dd99c58267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p615W6VWZCJ2gsG3jqIoqt8LWdOKycIujf2gQ83rDm6KyyzFXCq1cFkXV6Pu?=
 =?us-ascii?Q?oTb79QlDdP6STAMX1VYPV+kU5Ofbwtxm9p47Ka1O2CvfGVwdvSBIIFSIl8IR?=
 =?us-ascii?Q?vQGDd7Jb/nUCqXe7F0FesyDI+tCChfGdncQmHX6SFIRa4s5oqAotWqDUpS+X?=
 =?us-ascii?Q?eN7XK9JqHMcSLZMqeuAWH81rfhtGcLFb9c7OquYhXJfG9IfNGNbfZt4Oc3My?=
 =?us-ascii?Q?iTf8+2y/qtsPfZn2m4de007xRsL/48kfqdDy09/l6o25tbmGnSlgtrnTLG61?=
 =?us-ascii?Q?KKJLel3+cJlRPDtpzBKJ7kikp+9bI26903TThNIjMF5e7PwzN7LGYnKhM4l1?=
 =?us-ascii?Q?JBlZOzkUpA44bXSdMBBjfggIJ6OMxQXx7v8vWKGAXJPDaW9XtuiXNGNL2Dft?=
 =?us-ascii?Q?WAdxufja+xeWyyDzcK4qHeKpRzGdTs0yjdzVUFntOHB5xp+X0hIZT5Kuoy6x?=
 =?us-ascii?Q?+4Zt5VbUNoxLtWN/p3dcLByDS296oeD50XU/G7f0Fm5t5EiayGgx7qPZFdx1?=
 =?us-ascii?Q?+BJIWbHWSixMoieFj2ZARLRDozkHiQQ1lBGokRZ7tUAhGJAd+ZxwWQCl5M8H?=
 =?us-ascii?Q?285J2dKAHqEnhRP4aG9mO3oY58abq+KpHWfEqLM4wtY/yPbTR1Y2ZhlrzR+k?=
 =?us-ascii?Q?aiyjkW+f2u6j3/omm+t7jOEOB5l2VzfIROx5w/X42B4opdwjrVOD7UZdBt12?=
 =?us-ascii?Q?OaR6wmQ870ohSQ06bevFVH+rVdOLNuA93tM13QOC9Q1l55kwp9jxT+mIeSoW?=
 =?us-ascii?Q?ymxUsN0mzn44upvjR9I6Lv3EmGYFbhHud4Thur4J+Np0WDxInPdVEt4WXemC?=
 =?us-ascii?Q?nTNffJTl82jexMRyZ5ISouBrhu/jYqlI4a/f8B71aG7OIome5MnGdBLKJxrd?=
 =?us-ascii?Q?7KiFTXu4Yt4L3zJyhv7Oaerm2ZLeXnwlKVV+SX/VrJE442kmCiiiWB4TfXtO?=
 =?us-ascii?Q?7huUAg5fpHuLh7TvcYYaQydiuHWIf23g91LWlF2YBfVtDpMHdBy90GcqY6b0?=
 =?us-ascii?Q?i/td8ZAdQnHlD5apxV332lIi6ryrl5o/HrwmKGgm+saZeQyE2SK6T+FCxr8u?=
 =?us-ascii?Q?I1/sLK7J5irs5aJpN11vZYboM6FiGCOBYliYTgaXH9eR6/dgB494VW5mHC7A?=
 =?us-ascii?Q?GdZkO4FBRHAyvZ3T8UTlJvHnNqD+4KECHId8oocnt8btxNXjIrf6np1it+Fo?=
 =?us-ascii?Q?UUg76SaltNjTVj4x8q4sCYvR92vwbTNXsAt2pyF6XET8jtEs61r8rw6j0bsv?=
 =?us-ascii?Q?NwTVOGxm1O+kZHQcjxXEGhwgbYCz7g4XsbNCMgrB0f+kdLaVFtSjucdz111b?=
 =?us-ascii?Q?9b4sWsCbq9BhiHFWOI77THJAbMW+OsAfD5mRyPEwBsmq7+yWuXkTgiqm2AvU?=
 =?us-ascii?Q?f/Wc3RZ/x0mOs6ldHOuDiu7mrariuECUbtoKfyq8yPvjbP9ZMMC/oIW7lgl0?=
 =?us-ascii?Q?Vy6+uyMljYcuLueUCXOYNh+UFq9wko5V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NK4xgaqppm6uAF0m80YB9DBX4ltINjcpLZgs5iHUmFs2CFPquYQv8KRO/nMc?=
 =?us-ascii?Q?FxmrunDuYc4UEwBGtS1rc+D+PFIg2lyjnhzTKD8KBZOWqDapcPsNdNLvpYIZ?=
 =?us-ascii?Q?Y9UtR1fE5O8FITArUtCEOMJUyriiiZ44rREhQgsk5ao7A1enIseL/H8KfLqC?=
 =?us-ascii?Q?T3IDPfioIsfftxtzKqheA5vzuARiEVbU1y00cXXRxNhxIXQSiaLbybAoC6WJ?=
 =?us-ascii?Q?5mwlcM7nDgfKk0HV1G86mKep6+7fhWtji2Y2p7o8tVThuitQqC70/Dmt1tCe?=
 =?us-ascii?Q?ZrWTVSIcBK6/zdlP9Iwnln172Nfpv8301/O4LVeL4wCcIFmkGVZsqkoIWkUy?=
 =?us-ascii?Q?DQrhIQTIP8PX3XjeA3yHgE2rl4K+TpPTlb7HdmnBJVtzvQpuQFqEQaczmny8?=
 =?us-ascii?Q?gDVcl0ign2fKg0M0Comt4zPmj34NEwlgW7SPFKUWWlGD14Zf0X5nYEh/YmWK?=
 =?us-ascii?Q?phThrpd4Pyf1or8+eaEADuhmS385fytDlSSEvtKED802BcC79+N/aNdQZZt2?=
 =?us-ascii?Q?lH8OnavGtVhBfs1t4bnLSwZ/7bSQjwZs87QmUtobhEnEh40GeGw8CrWkPrzG?=
 =?us-ascii?Q?whTnWHCUS7RkZKsmDYp3dScNuLHZ6/PbQ7GMPhjW4vVwE9bkfiq1VpgmJ+Pa?=
 =?us-ascii?Q?NX0JRbIf+nfyLLCxZgJclDMhOSWgt90yQa7WPjR7HQDBl9MH/xFv1FkxAYbd?=
 =?us-ascii?Q?FXmR6gcIQUncA0MxBCYt0LmFGbxREp73aTD22oFf/Nbi28v54Gvoh80HQQ3l?=
 =?us-ascii?Q?EqqxlLEULNtmsPwDViNI0n1wgePEFPAumw3/8XaYnnGr86Sl+BQDkhisG03C?=
 =?us-ascii?Q?IbINYOjIJgJlWbSPwlM1e8PBjCvSAMEEvKFq4vF5V24CxVfM2M9HAMsWZLCU?=
 =?us-ascii?Q?p4MfLUoYkInx6fNiJx27bJoNDUpB9apFFyDaM8BXg9m7GLUlbMm4hO4raC3u?=
 =?us-ascii?Q?SvZy/reje1ohekduMbOYny5MPkapzn/pwHcMEgsUah0KUYrQRNX8pkDjuEId?=
 =?us-ascii?Q?8M3GaiCcmOpjY2dJm8qhdB3YAFjlynSaGkhcJhOBZ8XrNJOFMLOKBmSedXTX?=
 =?us-ascii?Q?CePhIVowKx3Buw5iSNLreUC3+p/1o8KWqx1SbM1i7seLpU2J4q+/aUgY9Aet?=
 =?us-ascii?Q?t2EPDYlIpT5IhMu63BuoXH94huwiI7qfgNnuwgtCLbIVzgPQMN9wCnpXg9qe?=
 =?us-ascii?Q?3QNuPkmB8fXiMDVdAV/R7AqeBSpzQwtn4+/4pM+rJ25vyZ7iN4OAV8Y2dBPZ?=
 =?us-ascii?Q?C0trpJAD6ix3IUf69BywxcH58l1imVKZLqE6RcCYckBk//rTwh0WXE7D6ozU?=
 =?us-ascii?Q?4Knj8cmSDzf41nI+7EZuHclMT1LzvrCfn+X33+SzszaKLDxV0zFdj53pTEEt?=
 =?us-ascii?Q?NcbjXcds+nN80Yt0KQkTfowu98RT6aJYSRgqAI2cRahzj6cvajVQgN4mLYhD?=
 =?us-ascii?Q?yi6McQXfyxD3SE3/w9Kg7bXGtF7Mq2HpsFzBUTj9BcW5XI90aVdJt7o2/QWS?=
 =?us-ascii?Q?ua8+wcO48D5koZaaWLqRpGyDdM5kuVUKbV+ZAXOrenN5cfDn2G5nXKcL6+Os?=
 =?us-ascii?Q?5ld8SS+FFdNTuQfhiWu9ElGzIupSQzmtUi3I0yQG?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7dbefcf-24d9-4d37-d311-08dd99c58267
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 06:46:13.5509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3AiXUp7KC4Q50n3HQc1KyQIcOy9cUFHLrEu5uHymY+p43s98RCnsqbUDiSOUmY9iQRUibzP/N1ODjzdlbHYNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6814

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

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Wenxing Cheng <wenxing.cheng@vivo.com>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <huobean@gmail.com>
---
Changelog
===
v5 - > v6:
	1.Adopt Peter's suggestion to improve code readability
	2.Adopt Bean's suggestion to simplify code
v4 - > v5:
	1.Fixed a typo in "indicates"
	2."DEFRAG_IS_NOT_REQUIRED" -> "DEFRAG_NOT_REQUIRED"
	3.Fix some coding style issues
v3 - > v4:
	1.Move the changelog description under "---"
v2 - > v3:
	1.Remove the "ufs_" prefix from directory name
	2.Remove the "hid_" prefix from node names
	3.Make "ufs" appear only once in the HID group name
	4.Add "is_visible" callback for "ufs_sysfs_hid_group"
v1 - > v2:
	1.Refactor the HID code according to Bart and Peter and
	Arvi's suggestions

v5
	https://lore.kernel.org/all/20250520094054.313-1-tanghuan@vivo.com/
v4
	https://lore.kernel.org/all/20250520063512.213-1-tanghuan@vivo.com/
v3
	https://lore.kernel.org/all/20250519022912.292-1-tanghuan@vivo.com/
v2
	https://lore.kernel.org/all/20250512131519.138-1-tanghuan@vivo.com/
v1
	https://lore.kernel.org/all/20250417125008.123-1-tanghuan@vivo.com/

 Documentation/ABI/testing/sysfs-driver-ufs |  83 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 190 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |   4 +
 include/ufs/ufs.h                          |  26 +++
 4 files changed, 303 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d4140dc6c5ba..f3de8c521bbd 100644
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
+		indicates the ratio of the completed defragmentation size
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
+		idle			Idle (analysis required)
+		analysis_in_progress    Analysis in progress
+		defrag_required      	Defrag required
+		defrag_in_progress      Defrag in progress
+		defrag_completed      	Defrag completed
+		defrag_not_required     Defrag is not required
+		====================   ===========================
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index de8b6acd4058..10006ae5ee35 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -87,6 +87,23 @@ static const char *ufs_wb_resize_status_to_string(enum wb_resize_status status)
 	}
 }
 
+static const char * const ufs_hid_states[] = {
+	[HID_IDLE]		= "idle",
+	[ANALYSIS_IN_PROGRESS]	= "analysis_in_progress",
+	[DEFRAG_REQUIRED]	= "defrag_required",
+	[DEFRAG_IN_PROGRESS]	= "defrag_in_progress",
+	[DEFRAG_COMPLETED]	= "defrag_completed",
+	[DEFRAG_NOT_REQUIRED]	= "defrag_not_required",
+};
+
+static const char *ufs_hid_state_to_string(enum ufs_hid_state state)
+{
+	if (state < NUM_UFS_HID_STATES)
+		return ufs_hid_states[state];
+
+	return "unknown";
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -1763,6 +1780,178 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
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
+static ssize_t analysis_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	int ret;
+
+	if (sysfs_streq(buf, "enable"))
+		mode = HID_ANALYSIS_ENABLE;
+	else if (sysfs_streq(buf, "disable"))
+		mode = HID_ANALYSIS_AND_DEFRAG_DISABLE;
+	else
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
+	if (sysfs_streq(buf, "enable"))
+		mode = HID_ANALYSIS_AND_DEFRAG_ENABLE;
+	else if (sysfs_streq(buf, "disable"))
+		mode = HID_ANALYSIS_AND_DEFRAG_DISABLE;
+	else
+		return -EINVAL;
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
+static umode_t ufs_sysfs_hid_is_visible(struct kobject *kobj,
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
@@ -1777,6 +1966,7 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
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
index c0c59a8f7256..72fd385037a6 100644
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
 
@@ -466,6 +472,24 @@ enum ufs_ref_clk_freq {
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
+	DEFRAG_NOT_REQUIRED	= 5,
+	NUM_UFS_HID_STATES	= 6,
+};
+
 /* bWriteBoosterBufferResizeEn attribute */
 enum wb_resize_en {
 	WB_RESIZE_EN_IDLE	= 0,
@@ -625,6 +649,8 @@ struct ufs_dev_info {
 	u32 rtc_update_period;
 
 	u8 rtt_cap; /* bDeviceRTTCap */
+
+	bool hid_sup;
 };
 
 /*
-- 
2.48.1

