Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2062.outbound.protection.outlook.com [40.107.117.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53F02E3386;
	Wed,  2 Apr 2025 01:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743558384; cv=fail; b=UthdkA+gyY3UZ76hBc2wwZllPLpTFmn3k0TIRSqJGPFXn4ssplmHP6M/mXBQ0zo1U6gl2VW2LBuQTmkYJC+KE/yddjFfMvFO7ElBb3sYo9s2MfFStsAzptWelo0SL1ZrXvNIDzHJrRHup9lFmDqpRmmK0iZE92E3HkGsk/FyWMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743558384; c=relaxed/simple;
	bh=81+kcSQE/UOVcXuooIvKVb5QqDrATO6ftGnv1CeI9j4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=eW+CXZbPWGVZmHWMjUMxGJjmwEsoI0sZk11ipX8iV0vMHyCF5YLJLy8fUO9kyPY+4QIZPV9jr+IREJn3OWHc4TcQNpgC/1/xzvArwTdfQj6m95st8vHqqB+vQIyBEnG6XcqVxNZnCbcuqic3eYOhiDp7nPZH2aOpE80hxEFlllg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=errWL8+l; arc=fail smtp.client-ip=40.107.117.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="errWL8+l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F2XDqgPj72tHMlHaNlaTTXm45sBcp8gyMAEKCxNccQUqwMBg53jFQt6HJBK11vrh5OhKo9V+czxEF/ZI75hSqLeW2CBdl2nxSEOihVSzFrd7750NtWNFWYQzPCth8qiUHoaN1wepWjiadCuckcPkX17rzz6Soqa4pykKqXBgNHgcszNOoiuJGdO6ZVAIYHiod/8Yw3yUe7LPfDx/3tR8Wq1AExRo5jlglr6RPZNMGP0ux/jwniNar1w2bRLFsq1HmGPN25xDEKHcWzMZXnLOwZdApv/wL+2ZeRV6de4NrtITJ+ZoOXcbdFVufvRypajbP9sLgbpXN0SnML/zS4t44w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Fq5dehRGSWEtncm6/cY4gi1xIxezkEQCt33rCHIUjE=;
 b=v+BSXd68i2cqpeYd67dIdX2+1Qs5a1gqGpBmuhK0vJhQbxPJTP7ZKGpfLjn6ldseSH5mCwlVpt6wgJ4Qlwb8yHenV7BI7s2tLA4h4XScSy/GYL/cpIy80H+Dqqe6fM+F0ciBg99Br0cTs8DRRWOTajoiPtAbyo7WbSHADYsBYLPmFLfXPtEf63/i5WfrmvFMzfZd+7XnS/HXhH71CG+1aGWZ8nw9C8f8Sdyc0XPyY0sheV/Ahv9jAp03OL6QqWrMbUwHJjXwGd0uSE6GnOIUofK+dDmpyLdTtPQiYHy5ibQqCExQcwVzcZtT6929EsNF0WbfhTHQMZeFBtkdRgIu9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Fq5dehRGSWEtncm6/cY4gi1xIxezkEQCt33rCHIUjE=;
 b=errWL8+lhQn2KYd9Diktqn3STVT1eXPorZkAMjWHyW1B/CyoSFDPCUWBFARk1PkEfAZhDz9IPsY3inHQ1hSnNwzKKOB6ZcP+L2El+gFU8SExFAQ5JV4w7b77n/+eIgtAfK8mJPwcVeEbq4RFnLDydHf90cc9rF5m4jhqQqaFR1lK9zWMOJF5dPxIthOWHhMCIBC8pRWfKbd+BHyRWGD3tpCAwxg3WVi6gJrivFToGMFCHKwsQft82R25CWJLm/NSSqkPich7GJrJD/KfxUKPAd3MkEl10XryME+x0Vx6eWEojQXPdc5SS6X/vg1R6C/rDxVL/XhjdbQ7uT6cdkgiSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com (2603:1096:101:139::12)
 by TYZPR06MB6990.apcprd06.prod.outlook.com (2603:1096:405:3b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.54; Wed, 2 Apr
 2025 01:46:18 +0000
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a]) by SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a%6]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 01:46:16 +0000
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
Subject: [PATCH v7] ufs: core: Add WB buffer resize support
Date: Wed,  2 Apr 2025 09:45:36 +0800
Message-Id: <20250402014536.162-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0101.apcprd03.prod.outlook.com
 (2603:1096:4:7c::29) To SEYPR06MB6279.apcprd06.prod.outlook.com
 (2603:1096:101:139::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6279:EE_|TYZPR06MB6990:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f3aa16e-424b-4289-ad2b-08dd718827ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|52116014|7416014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5MXiRgjKbdQ90nKakknRSfasW98q3aFF9671KSiIgRZO/1/Dq/fYKwdSKAh6?=
 =?us-ascii?Q?bXwqh5AocKl+RhROeDXthFkGyQvw8ISF51eHrdORsdYWn81+R4sA1p13oEBn?=
 =?us-ascii?Q?6Fncuhg0chJiL6ILPpwPNyM9awsc/PQY7DIUmHr/jOEKbaFsZGtXjspBZf/y?=
 =?us-ascii?Q?saw7GYdPG0ZOMdbu/JKSUzHNZUtVWUoUjbo6KdpZ2kOYLjsE1sow6dHX7LnJ?=
 =?us-ascii?Q?a5wrK9cjjxvOW5JH2Wg+VW+fld1GHGfXoK8kFIWYyQ+p/0QVViljqb/CUm5u?=
 =?us-ascii?Q?e0Q3sclolrSPKmzSjKM9b1IAOtPbxDzgPAf1QtW2G+zrt1kan6C66IUg0YGf?=
 =?us-ascii?Q?rEOte0C8Hg59dTqJDiYe5jVTEPngUeO2a0PIP4PyyG9IY22041FvZPkkIxUx?=
 =?us-ascii?Q?6RURgdSjPb9cDH+2moqt9hMUPHRrpWblj4xJcuf2sQkUDCvhVhmfzhX8nkAD?=
 =?us-ascii?Q?Vfe5RnnjCEaxy1pH2X9WdkZznQG5GWApn673JnWlYLEB7tVCeu+YwSLU/Kh2?=
 =?us-ascii?Q?mBmcQQjACeodOu56lB2hHTtuF5JscPSwD1UxwskYxkMhIixPBXydcCk0dQLE?=
 =?us-ascii?Q?LLUiqwKiGrPwSq3Jv2jVrwEU+Dtzh+uKhT7Xc2fwDoAY7SDIq5xi9B3TlIUG?=
 =?us-ascii?Q?5+KrkTk6uDSPUOhoTrFLhri7Df3qWo6SL8Kue3d3No3FVhYxCXORI4bf16Ya?=
 =?us-ascii?Q?4CAzPlLgelUj1hXmR9gKV2Gs2/9SHN9sOnvQ1FKAvPTvse4h2Wsrw9TDrg5L?=
 =?us-ascii?Q?0tKDK77LARFQfrJzETJy852HuGq9BptIiLM2vWYaMfXOmHr8rXmcoTTo9rsW?=
 =?us-ascii?Q?PvMj7/ifV8qCKJo63zyswjE1ifm7oa02aPuRNWCy+BsN1APTXXboUXWn5UnT?=
 =?us-ascii?Q?Y74AH49rgJkuBLtcM333iWxQI/jJmLGsNtdwvwCiyA6Zu3jlIt4pEgnSYGZv?=
 =?us-ascii?Q?0gbmBSB2hCNF4DcVHwbZSMWPlyIAKVyrgiQyHyw/Ya2c4UWpPiENdetZpoEn?=
 =?us-ascii?Q?j/gGldcPCSe589fRoOetMsKPZAjnEPxg8NhOQz/ONWusd0McyJCGkW7Hg+A1?=
 =?us-ascii?Q?M+sdnZefgMevcunxx7WwAzQns7OTfrMEfm04zQMTlg6oRcL1cZK3U3BbpRfX?=
 =?us-ascii?Q?J0I1j7ISY4auUhZof2dzKdacS3AZuB8jZeg4n/UKr+XwEM/7PMWQF8zUEmAx?=
 =?us-ascii?Q?n/W3S0VqEToNVHiNn89Q2hcUEtlHupGUgvYzxrDNhf7rVE+snicww6ScAqGP?=
 =?us-ascii?Q?Y8P6d5Efqm6drV7Y/grD/V4t7tDw8+vxHu/dEAzhBzSD8vEUV4YWhfS4lRY1?=
 =?us-ascii?Q?D6ems+8NM9O70Vi6XL47y9U2wwIU3SyA7ndZRf02HGhICWWMPOE66g7Ozdus?=
 =?us-ascii?Q?uDlEMJ86hTrPTgmRUsG/t3u2ed6xGSuZxrMOl1yTSIFwUyfSIyRxoIitXNze?=
 =?us-ascii?Q?GFcd7lDnUIstns399I3vMpt69Vo+3uOJiCHU8s7fzwHRQqsrmXcoeQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6279.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(52116014)(7416014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dhzKUuSUEKtKvXtStfqPTjlFROeK3ONV0Zbw7C301gHm0I+9JqRax4OjWoTg?=
 =?us-ascii?Q?/NnjdnRj9wRFxd9mZKQZ0HYACPywI7Xiwj10B2Yc2PgfQFcL7bRdxqOthmSw?=
 =?us-ascii?Q?9/werSEnbWWyVBy5Sw9UQJ6Pom9HRl2hZOOhPUQl1n0PsuKZT3hoU+TTWXp3?=
 =?us-ascii?Q?gbZ8wj594+l3x30KgNEQh4iTsYYlKQcGU/wUQyuyCP8aO/ydHU+AmJ2Jzoqh?=
 =?us-ascii?Q?ySPTJMZEbigr9pabUrwuocvZfBJcpf2xzTtX55n03Wnt0rqLBsHxDansIUIm?=
 =?us-ascii?Q?tLrt7FUpUzDZINgqoZm2cC+9F3gEumnx2IJvVVU6S25IhTm9+NRspeCq0/+e?=
 =?us-ascii?Q?LArZSFdZ1JzanG7WFVsjyf1b7kHRggwNImx+iu95bLy4KSTeF5bS+3gTHe2N?=
 =?us-ascii?Q?KA47NMvXJGtw6Rkhwc/e/We6CTkXXSbnb59pJ4miid3V94Tv5sYLRqsMfqlj?=
 =?us-ascii?Q?DSV47oq/k2GodNIZhfjDycgEukPX71F2AyQEx6fvtQmHAqoRdY8ztgTJrfMa?=
 =?us-ascii?Q?dGYg8mv2gDK3LCsSTJOUGEFjGg7mcixyCBGYdQ56vLXz+2CWj1axcwuhZOmC?=
 =?us-ascii?Q?1/eZhkmnV2aav1iVIjzP8rfpeSQncNET/LZy8UoN28bref8OxpLbTVZKyoXq?=
 =?us-ascii?Q?I7JrnFxUrMObrVoZZ8fE0Qbz19Er7GnQdr1aNVsFlxnyZOEQeHLc+aWaE4y2?=
 =?us-ascii?Q?DkafYz+slDXqvn0FQRgMAjMoWSND3FMlbL+mXyAp0Y2E6mq3mmc/iFor428g?=
 =?us-ascii?Q?dUWNuKcWmGgAV8likU1ZrGhGTp/kmvGjJrphK9g+sXYCzTJ0Qunimem77f15?=
 =?us-ascii?Q?z9axyqBKJ65f5bXTIOIvGTAJn+HrQligapLgNO1Eq2fp/h2/88NAcjD0HK4R?=
 =?us-ascii?Q?Gt487n15s2c5x5HxpSXG6esXv6zECPy+02Y7Py43XHGCyuBYxZyy2pONh8za?=
 =?us-ascii?Q?UtTYJ0bgOoO/uCvDmmN8o219QjeKUxsoNFuosrRPmnLcYZBW/ppLSL9jOVh2?=
 =?us-ascii?Q?TOR8HyNbNs7020fYqtKvuMqXvtHI9OCiqxwf4u0ofEOQuYA5JdA/70gvftL6?=
 =?us-ascii?Q?I+iY9DQrUojABOWDWRWJSl+bFk7wP5egsgWPlwyA7X6X50C4OntudIcH7rYh?=
 =?us-ascii?Q?5BohjklsgxgJvv3I9+glBIRaEkbZJnacWqVw2ex2IGeeIt37OxKIrOuK+s1B?=
 =?us-ascii?Q?rcWZ2vP5Zpg+8f28p59br3L+gq+ZTzxdV2Qmz968870J6lfTP+dCS7T6RFPg?=
 =?us-ascii?Q?pH6hgkqJEORjGhLbDofAsjYYwmdiNkeEAEpaHxlVH30yrAB1AtRAiWw3R67a?=
 =?us-ascii?Q?uHAQ+p2ByIP5kAZqUWDp54G9al6PbNz/CaF7tuK1SfebiyjEF2xr+sngYrve?=
 =?us-ascii?Q?iV5r5qY2/hYJUAnWEx+410dRlB2Q1vOVRfVT9ACspg4XkDlBfMYktKSv49Dk?=
 =?us-ascii?Q?rOCIADPLUAEkLggEpRUUqPL/yDF3mtnZYaNcXjx5Z2V6kqTR4aaw5p5Qhkj/?=
 =?us-ascii?Q?PvDrJxyVMX5IrHpg8WcWzJ0PC4x3r5mMj76VoEVHGtxQ7Sg4oCQZonNnjtvL?=
 =?us-ascii?Q?URv2FlniZHLFRvIaqx7AlcIZk9crqohSCc8Xt8K7?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3aa16e-424b-4289-ad2b-08dd718827ca
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6279.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 01:46:15.5818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EokdbUqAl2lIilSq8cfWhnfgXpI/oL9Uf2Ztuu63JN+5iuQbPnek466hxSySoRXeDgrbpZb0CEQwcNLWyaI78w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6990

Follow JESD220G, Support WB buffer resize function through sysfs,=0D
the host can obtain resize hint and resize status, and enable the=0D
resize operation. To achieve this goals, three sysfs nodes have=0D
been added:=0D
	1. wb_resize_enable=0D
	2. wb_resize_hint=0D
	3. wb_resize_status=0D
The detailed definition of the three nodes can be found in the sysfs=0D
documentation.=0D
=0D
Changelog=0D
=3D=3D=3D=0D
v6 - > v7:=0D
	1.Use "xxxx_to_string" for string convert=0D
	2.Use uppercase characters, for example: "keep" -> "KEEP"=0D
	3.Resize enable mode support "IDLE"=0D
=0D
v5 - > v6:=0D
	1.Fix mistake: obtain the return value of "sysfs_emit"=0D
=0D
v4 - > v5:=0D
	1.For the three new attributes: use words in sysfs instead of numbers=0D
=0D
v3 - > v4:=0D
	1.modify three attributes name and description in document=0D
	2.add enum wb_resize_en in ufs.h=0D
	3.modify function name and parameters in ufs-sysfs.c, ufshcd.h, ufshcd.c=0D
=0D
v2 - > v3:=0D
	Remove needless code:=0D
	drivers/ufs/core/ufs-sysfs.c:441:2:=0D
	index =3D	ufshcd_wb_get_query_index(hba)=0D
=0D
v1 - > v2:=0D
	Remove unused variable "u8 index",=0D
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'=0D
	set but not used.=0D
=0D
v1=0D
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/=0D
v2=0D
	https://lore.kernel.org/all/20241026004423.135-1-tanghuan@vivo.com/=0D
v3=0D
	https://lore.kernel.org/all/20241028135205.188-1-tanghuan@vivo.com/=0D
v4=0D
	https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/=0D
v5=0D
	https://lore.kernel.org/all/20241104134612.178-1-tanghuan@vivo.com/=0D
v6=0D
	https://lore.kernel.org/all/20241104142437.234-1-tanghuan@vivo.com/=0D
=0D
Signed-off-by: Huan Tang <tanghuan@vivo.com>=0D
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  52 ++++++++
 drivers/ufs/core/ufs-sysfs.c               | 131 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  15 +++
 include/ufs/ufs.h                          |  27 ++++-
 include/ufs/ufshcd.h                       |   1 +
 5 files changed, 225 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI=
/testing/sysfs-driver-ufs
index ae0191295d29..efa1e2df292c 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,55 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
=20
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_resize_enable
+What:		/sys/bus/platform/devices/*.ufs/wb_resize_enable
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can decrease or increase the WriteBooster Buffer size by setting
+		this attribute.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+		IDLE      There is no resize operation
+		DECREASE  Decrease WriteBooster buffer size
+		INCREASE  Increase WriteBooster buffer size
+		Others    Reserved
+		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The attribute is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_hint
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_hint
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		wb_resize_hint indicates hint information about which type of resize for
+		WriteBooster buffer is recommended by the device.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+		KEEP       Recommend keep the buffer size
+		DECREASE   Recommend to decrease the buffer size
+		INCREASE   Recommend to increase the buffer size
+		Others     Reserved
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_status
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_status
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can check the resize operation status of the WriteBooster buffer
+		by reading this attribute.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+		IDLE              Idle (resize operation is not issued)
+		IN_PROGRESS       Resize operation in progress
+		COMPLETE_SUCCESS  Resize operation completed successfully
+		GENERAL_FAIL      Resize operation general failure
+		Others            Reserved
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab60f5ae..639b00ef42d3 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -57,6 +57,27 @@ static const char *ufs_hs_gear_to_string(enum ufs_hs_gea=
r_tag gear)
 	}
 }
=20
+static const char *ufs_wb_resize_hint_to_string(enum wb_resize_hint hint)
+{
+	switch (hint) {
+	case WB_RESIZE_HINT_KEEP:	return "KEEP";
+	case WB_RESIZE_HINT_DECREASE:	return "DECREASE";
+	case WB_RESIZE_HINT_INCREASE:	return "INCREASE";
+	default:	return "UNKNOWN";
+	}
+}
+
+static const char *ufs_wb_resize_status_to_string(enum wb_resize_status st=
atus)
+{
+	switch (status) {
+	case WB_RESIZE_STATUS_IDLE:		return "IDLE";
+	case WB_RESIZE_STATUS_IN_PROGRESS:	return "IN_PROGRESS";
+	case WB_RESIZE_STATUS_COMPLETE_SUCCESS:	return "COMPLETE_SUCCESS";
+	case WB_RESIZE_STATUS_GENERAL_FAIL:	return "GENERAL_FAIL";
+	default:	return "UNKNOWN";
+	}
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -411,6 +432,43 @@ static ssize_t wb_flush_threshold_store(struct device =
*dev,
 	return count;
 }
=20
+static const char * const wb_resize_en_mode[] =3D {
+	[WB_RESIZE_EN_IDLE]		=3D "IDLE",
+	[WB_RESIZE_EN_DECREASE]		=3D "DECREASE",
+	[WB_RESIZE_EN_INCREASE]		=3D "INCREASE",
+};
+
+static ssize_t wb_resize_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int mode;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en)
+		return -EOPNOTSUPP;
+
+	mode =3D sysfs_match_string(wb_resize_en_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res =3D -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res =3D ufshcd_wb_set_resize_en(hba, (u32)mode);
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
@@ -476,6 +534,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_resize_enable);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
@@ -491,6 +550,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_resize_enable.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
@@ -1495,6 +1555,75 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn =
idn)
 		idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
=20
+static int wb_read_resize_attrs(struct ufs_hba *hba,
+			enum attr_idn idn, u32 *attr_val)
+{
+	u8 index =3D 0;
+	int ret;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en)
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	index =3D ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+	if (ret)
+		ret =3D -EINVAL;
+
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t wb_resize_hint_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret =3D wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT, &value);
+	if (ret)
+		goto out;
+
+	ret =3D sysfs_emit(buf, "%s\n", ufs_wb_resize_hint_to_string(value));
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_hint);
+
+static ssize_t wb_resize_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret =3D wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS, &value);
+	if (ret)
+		goto out;
+
+	ret =3D sysfs_emit(buf, "%s\n", ufs_wb_resize_status_to_string(value));
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_status);
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -1568,6 +1697,8 @@ static struct attribute *ufs_sysfs_attributes[] =3D {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_resize_hint.attr,
+	&dev_attr_wb_resize_status.attr,
 	NULL,
 };
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 83b092cbb864..2c52a654a1f7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6068,6 +6068,21 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, =
bool enable)
 	return ret;
 }
=20
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, u32 en_mode)
+{
+	int ret;
+	u8 index;
+
+	index =3D ufshcd_wb_get_query_index(hba);
+	ret =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &en_mode);
+	if (ret)
+		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
 static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
 						u32 avail_buf)
 {
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8a24ed59ec46..ed971480c329 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       =3D 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    =3D 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        =3D 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	=3D 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		=3D 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	=3D 0x3E,
 };
=20
 /* Descriptor idn for Query requests */
@@ -454,6 +457,28 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	=3D -1,
 };
=20
+/* bWriteBoosterBufferResizeEn attribute */
+enum wb_resize_en {
+	WB_RESIZE_EN_IDLE	=3D 0,
+	WB_RESIZE_EN_DECREASE	=3D 1,
+	WB_RESIZE_EN_INCREASE	=3D 2,
+};
+
+/* bWriteBoosterBufferResizeHint attribute */
+enum wb_resize_hint {
+	WB_RESIZE_HINT_KEEP	=3D 0,
+	WB_RESIZE_HINT_DECREASE	=3D 1,
+	WB_RESIZE_HINT_INCREASE	=3D 2,
+};
+
+/* bWriteBoosterBufferResizeStatus attribute */
+enum wb_resize_status {
+	WB_RESIZE_STATUS_IDLE	           =3D 0,
+	WB_RESIZE_STATUS_IN_PROGRESS       =3D 1,
+	WB_RESIZE_STATUS_COMPLETE_SUCCESS  =3D 2,
+	WB_RESIZE_STATUS_GENERAL_FAIL      =3D 3,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    =3D 0x00,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f56050ce9445..74086a6cb53f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1471,6 +1471,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *=
hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, u32 en_mode);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
--=20
2.39.0

