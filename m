Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010045.outbound.protection.outlook.com [52.101.84.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863144CDDCD;
	Tue, 22 Sep 2026 07:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062431; cv=fail; b=uveDtxF2up8IZhbd15VPZbEi+aOwvO+Gqi9D6T66epDuZP9Za25aho0Ajz4wQoZ76BwORZ7bj0tQohbBCfJJ9Ufzc/SCNXhpXoDWsgNqgqW9qqmAWCJT8/Q+Pfv0HpunHRalXMM9rUdACIXg5Rcb9T/tixJw8uXq59ysK5nSkdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062431; c=relaxed/simple;
	bh=ZE0egIIW+z4ZjNTCfSbAu2SZBsTcN9KsSboPzVqe9sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hVLtx5hJqF9nlGN6EyPfFEYSMEqNROZYn2j81w0yk5hxhfP9YPzr6M7BmkkP5ml/BpxsdXsz2OR+A8aMgzNco517NsCnzPkiEPuSxEUkkyh4aDmbkNKTe6iJR3FNJV5kYfjZBWKROUgR5CydYafnkGWzP/eVRwlXcJlGqSGCpuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=C2ZVZBfl; arc=fail smtp.client-ip=52.101.84.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="C2ZVZBfl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AYFUuf8kQFf9z0wVAtK7tsm0FPp8DBu7Xkc9ja7x8qBFpeswdH1gk60i59LHBAEYMtxpCp/sZxeh4s4MecqlJONuxM7v4XEttcx4NizgqsIBJQpqoTc0iWktQGgwio6ueE0M0ICIx6VogK2nN6VyvxTL+SbWuGBBpE3BgMv7WzuOGuQFdSGkvg6OTIW6LWKL72MvwcDo3ON2darBRJAg+F8yQjM/gXPuRrv9Am/dls2fON9YlTIqzYylbAKjuFBH47RkN5scbV5QGMSacpPir2j3Jaq9V+ReaUcoW/wFZL1apqkkfUY560wKvzUNY2IW85rvc69djfpdZ5Tl/BIHbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7uoqsx2zML32xzDcSRhGJ174iSzdn9mEilSglZ3myI=;
 b=lLqrKnJ7tQ7gvefwtc16M+iLG10ZMoO7hOoXOx6jMDH71bLcz02c6jU+RTrmQ/iA+b9C8OIbG3f7+FwoB7RbpSuEWdNonONjX9SxwveX1XClpJVA7hRstxOHe/sjn1b079AgZVNxA7jQRxLQrVVpMK2WLWFdeIXNeHqfpBHPROtI7OQ0IAXJ7i3ZAJxoMETeXbuzjYaYrrR75+kJB7vz3/jLtgyiX/JM3kY5jgYt95Ff1kPqyZXDunLbYUBtAI9OZ/+3JtSC2YwHpatcy9LR/8Mqc8/raTskCUI/iMlnsswcclP6bokxkE1b/RhbfWCIIEMX8jLvIcXv9RY75TJV8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7uoqsx2zML32xzDcSRhGJ174iSzdn9mEilSglZ3myI=;
 b=C2ZVZBflv5Vmv9NoOkDIraYa5pKCq1VS4S101aOf/ZRJkhZSwjctp/VcAwGya0nik5wEhtgWM61UAxeQF5rJMN7uaApv1v1VXgAEJMReISmmpB697ecuGfZP8TEZeJzetKsG+DMNbA3JZqlRQHRfRJvhBf6LVdn5pEpgsCoK8iiQ+msp0T1s0ZcDhzf/AKutf1Xyjsu60euw5oz+o+8BNUu6J5MNCo8jmxBIbAOmNMHXAHS1O8UEecbqq6GuMEDds8f/ejUmRQdwTJRI5jQacEEd+bIuMSQ0X4QzYEtLsQCGxID/qYguiloHbujt187HYoIOJ3s0TgbtJfT2gXQ5ZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:23 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:22 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v5 05/12] scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
Date: Tue, 22 Sep 2026 09:30:02 +0200
Message-ID: <20260922073009.1449688-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::12) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|MMZPR04MB213195:EE_
X-MS-Office365-Filtering-Correlation-Id: 24188cd1-9ddc-4810-3a52-08df187bc82b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|3023799007|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 Iu7fd52/8AIvAj0PHmRCYkTdzlY7ulC86tYAIXbF49Bzni+BosuhQWCFUjR0ilCbBJNOGz+E7MVJ4gCaT0znMmjCJd/cRwn4VG7eqL02tyaHog3s26uq1AXgmk8BC5J0fKvRlRCV2XOyxJAYUriJBApmjfkH5JnH4SPhdVxPARm2VhflJlBgk0OwyTrE4EahmvbfosVyAD9zhwtAvwNY99qbNkCigNIfmRKShtU3rZBKUfExSXSnGg+fFy0rvb9vNQld1EWG9fSdbCKza3ZDqYbXO1Vu/WkkNR0dC3JyhEgTinvXYs2GaWs/ITa72xK0kWQnkzwjdHZNodGJn/jACIavvZkEQ88FQxmSgwQpy54RwiOJWM3HwdNbox5riL7oUOtBI5H5ErBXDONMhe2psRV5xv6jQzMYcaLW1ahk6cbrCdKds7Dh+3Q9ypYPIMPv6eYzXE/VISIMNL4fDVQiQanzvKAsvBLavN2WKeCpi5gbPxOFUZameoqkcHdd9Z5ci2MJJh4eOlpzKz3JZBAU4gYxgFJ0e/Qo4qUA8iw5gbC2i7PGE24m4amek0d9swBwsJ2NMY/1K8TLkptNA3i9nCbx0/+gpyOLsnP9CWrBF4Km+02Diz+TLqIGNUdPaGBpNieNEUppLVLDGpDa1SJw6DgjA4MV4oUaB1TKW4vZlCX+veXvgF5AyGtfrqNSJWEr4KVcq2BcvMCKOILgV3buPA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(3023799007)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Wmd2M24reWlmaVVPeGdJWEw5TVlHMXEwbkR2WGpTdFBrK1VnSzV4Q3BadEMx?=
 =?utf-8?B?NjRnUHBTRGxsalk5Yzh5SFp0Nm1WNnVBajlMaXF0cTFqRGZWVFRXR2YxUDFS?=
 =?utf-8?B?MDk1dlhseXQzb3hESUczUCs3cm5Sd2ZGUVdtNWNEU0swbDhyRU9UVy9Cdm5Z?=
 =?utf-8?B?cVpFN2hnWFRQbklZeEwrSmhEc21zb29hbW1EdUpLdUVUNmVIR1J0UGVNVGht?=
 =?utf-8?B?RGRSellOSFlrMldFY1gvWTJPa0xBWkFLYXVuRDBWd0YyVUNYRjVDNUhFQUov?=
 =?utf-8?B?OVd2aDVuQitzRmlkMWQwVHRrYm1sNkZQMEMzWndJUXE1am1qYW9jOVJQZVJ3?=
 =?utf-8?B?d3Jxc3VoeDdiY3hiK21WMUVKblhaSkdwcWxiZTREUmc1emowTEVuMVMwMGpl?=
 =?utf-8?B?K2dkT2lSZmtSbUxYQUhjSXRSczRhMEVueS9EYmdiZzBTUllyMGtxeUhCQitp?=
 =?utf-8?B?bU9JOVdPTG9keEJ4dEJiZk5nTmlwU1BSMzlJRmMwRTllWDMxV1RlZVNSK1h5?=
 =?utf-8?B?VmI2c2wvZk9YRU9hN1hpSXFyQndYN0hCc05ZZG1XNDlmNjIyYktFY2xld1FZ?=
 =?utf-8?B?ZkhLcC8wcU9acTV1eloxNE05Z2E2WUxjSVd4VXc0NnYxcEM5M052aElyYUpQ?=
 =?utf-8?B?OHRoZldaZVBoMVlVNDFUTC9IZG1hcDJLYnRGSDN4UlFiU0U4ZkNqY2VyTUpE?=
 =?utf-8?B?bHUzWFBkblAxT0lGVFhtSWtEaEFqSUtMR1FLKzZRZ0QxUmtLeGRSTVpVb2xZ?=
 =?utf-8?B?TldFbHVrMmFVQTNMUTRPbVN3dkZSaEloOGtPY0VYM1ZkOFA4TTlQdW85TU5D?=
 =?utf-8?B?V2JLaDFHdEd6cUZKaHNPNitWaWF4cmFMaXZiNHN5T2RTS3VSVmNEOFFxc0tJ?=
 =?utf-8?B?WW9LcGw0dERkK1lTd1VNZjhMR2k1eitnbmJZMUtGYUNaTS9BYzVoQmwxWnQy?=
 =?utf-8?B?YzVNRjJFaWV3azdSdHdjKzRGaGZUdnBmdlV6bVFNOE9Hcm1sY09WY3BHN01U?=
 =?utf-8?B?SmlOdzR5d1AxNW1PS3VhWXBXWTdjcWhRcDdGWURKdDZ6VXNVWWVWaFpITlZm?=
 =?utf-8?B?RVQ0RzhqbzdIaDRqa0cxc3BkVmltQ2xuYkdmaXZiV1hhbm9YZnovOTJSRENs?=
 =?utf-8?B?ZC9LOUdjcSt4cXVhTmhka2pQQVJ5QitXdFpYQnMvZ1FsRGhBRWsvTVp4Y2NO?=
 =?utf-8?B?NmFXZE4yWjdXSEtNVC9rSU5SMWZaZktabzVYaERiNnJ4S1p6WmYxNUxrZWRr?=
 =?utf-8?B?bGRjVTdBaGd0OXFrUnNBSHQ5OWVXR3pOL2NRS09nWlJMQlJQSjlMbEdCb2Zl?=
 =?utf-8?B?MktoeUNuQlFxYWdsTHJVUHFEa0NIY0ZtOHBaL3pOVWphci81cXluNTc5b0Jq?=
 =?utf-8?B?VUdwbG9IVkVyRmR0ME9VNVI2bHp0SklKN0pQM0VycVZEdnlHekszd3Z0cUxG?=
 =?utf-8?B?NUlldUFSd3hWS21iWktyM0JQVVczMnFHL09lTkpoMUQybGY4TE9DbkZJcFJP?=
 =?utf-8?B?SGpUSjlCV3prY2lvV0FOUkVsZVhIMUJ2UjQvbEFtcitGNHFyVW1hVGpOTk9y?=
 =?utf-8?B?WU9oYk1oTysxb0psYXhlajdUOXJSS2ljdGY1TmhmaHo3NXUzTTY1NjZ1QTFo?=
 =?utf-8?B?aGRGbGg2NUdHWjdMSjlrcUVHU24rUzZjY1d5WHZ6eE1mTWNFeGo0MzRvRnor?=
 =?utf-8?B?VVJTZlJqaHMzeVFVWjJIei9lazlLTjZPVmxxcFIyMGRsVmpleTBwRVlyWDVw?=
 =?utf-8?B?VUw4eUtpVjNaZ3ZnYmpWUXJtUHo0ZkpkUGo5eERJRlRLVTIzQ2tHN3J6WUFx?=
 =?utf-8?B?RHBSY0FjMVlXMk1tWElxVnZDQ1YvTmVFY3JhZDZUeWoyb0UxQ3YzSFlqeFJp?=
 =?utf-8?B?VHZZNXEydkVjcWRTcTV4T2N1dndjWExUa1oraEpGYzVJVmN6Yy9ralpKdFk0?=
 =?utf-8?B?d29OSkdQRXM2WWxjV2NNNWxqY1RiMVk1ZWszYXRYVnhLRkp2WEFBSFo0QUpl?=
 =?utf-8?B?VS9HZEdaaUFxaXU1c2puUm5PMWZjR0M4N1NYNlFBNHlITkRTdXRybFc4akw4?=
 =?utf-8?B?Tk4yQ2J4VGtYaGRINVI2OS9ESlZFazRVWmw5TmRnWXNxN1p2VVFDc0Nsc2pn?=
 =?utf-8?B?Q3NKQTlnRkdBMGpnREd6ZlFFS09za2MrYVN6b2liUEFkbUJLdkVoZUYvVjB5?=
 =?utf-8?B?S2R6YzFCVmI0MmxoSlVubUVTRCtXRmR6SVVudC9oaHN5WkJOOEFVMnJ0bkw5?=
 =?utf-8?B?N3JLSXVSdDlBejF3YmNWaXA3YjFHb0pWS2RPYzlTbUdiZDZPRHQwT0JEUENq?=
 =?utf-8?B?a01EUkRrbUNva3QxUUg4MXc4ZlNiOHFMTVFBMXJzRVZwMVR1Kyt6QT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24188cd1-9ddc-4810-3a52-08df187bc82b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:22.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4YOVPZ0tUxeOR45ZxEPmYruFI0Z0sLpxiewRiUAjGUM2OCvK2kWNq6fQxarlwmMNSiAw7zk9537ZiANps1yXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

The AMD Versal Gen 2 UFS platform driver carries local helpers to access
M-PHY control registers through the UniPro CREG interface.

Move these helpers into the common Synopsys DWC layer as
ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
duplication in DWC-based glue drivers and provides a single implementation
for future reuse.

Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
is no benefit in keeping them persistent.

Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
 drivers/ufs/host/ufshcd-dwc.c      | 69 ++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  2 +
 3 files changed, 88 insertions(+), 68 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 0d4d5e98ad65..c7da95999c85 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -43,57 +43,6 @@ struct ufs_versal2_host {
 	u8 ctlecompval1;
 };
 
-static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
-{
-	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_write_attrs[0].mib_val = (u8)addr;
-	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
-	phy_write_attrs[2].mib_val = (u8)val;
-	phy_write_attrs[3].mib_val = (u8)(val >> 8);
-
-	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
-}
-
-static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
-{
-	u32 mib_val;
-	int ret;
-	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_read_attrs[0].mib_val = (u8)addr;
-	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
-
-	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
-	if (ret)
-		return ret;
-
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val = mib_val;
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val |= (mib_val << 8);
-
-	return 0;
-}
-
 static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 {
 	u32 offset, reg;
@@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
 	u32 reg;
 
 	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
 	if (ret)
 		return ret;
 
 	/* Program ATT and CTLE compensation values */
 	if (host->attcompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->attcompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
 		if (ret)
 			return ret;
 	}
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
+	return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
 }
 
 static int ufs_versal2_phy_init(struct ufs_hba *hba)
@@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 
 	for (lane = 0; lane < activelanes; lane++) {
 		time_left = TIMEOUT_MICROSEC;
-		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 		if (ret)
 			return ret;
 
@@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 		else
 			reg &= ~MPHY_RX_OVRD_VAL;
 
-		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 		if (ret)
 			return ret;
 
 		do {
-			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
 			if (ret)
 				return ret;
 
@@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
 		/* Remove rx_req override */
 		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
-			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 			if (ret)
 				return ret;
 
 			reg &= ~MPHY_RX_OVRD_EN;
-			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+			ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index ccf785fce6cc..82b03b926e77 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -144,6 +144,75 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 }
 EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
 
+/**
+ * ufshcd_dwc_phy_reg_write - Write a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: value to write
+ *
+ * Write a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB),   (u8)val,         DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB),   (u8)(val >> 8),  DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
+					ARRAY_SIZE(phy_write_attrs));
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
+
+/**
+ * ufshcd_dwc_phy_reg_read - Read a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: pointer where the read value is stored
+ *
+ * Read a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+	u32 mib_val;
+	int ret;
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
+				       ARRAY_SIZE(phy_read_attrs));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val = mib_val;
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val |= (mib_val << 8);
+
+	return 0;
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_read);
+
 MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
 MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 0406f2bb576b..d8673cd54d4c 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -45,4 +45,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
 #endif /* End of Header */
-- 
2.43.0

