Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97B74A843C;
	Thu, 17 Sep 2026 09:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636571; cv=fail; b=rA5HbhyWoepZM7My/1GM0r0+QwqOYxMa4bLz3B2Nrvvvhy/mbU/+vyZ3/9bm16fMku0r+eHVY4GD82PD0o77h1XQyAu+58GvOBYiK0gkGUZloVTV/opI86c+3CV6U299zuvvtaYowQ5nJQsGV/yDIY9B8Qz51KB9jLc8VqRhPdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636571; c=relaxed/simple;
	bh=b8yFhbe5RmU8hRdUh1VkilrIemV5CvKP0zNsavASvBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iyrpksY9JMDJK6zYco++wD4bM5bJIP8E1GydClQQaIBH5CJmuYV3Qd1NSrfvQID3K+ZpQtAjMhVNUuu2GjAHfPCHqFrC3ZFk+ndc/xX/pe5N4pncdys9kY3+X12OtOzmQwepRJUmcPyMogRR+ah1LseuRkU5tx4D6LCrCXYtugI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=aqGsrwd0; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="aqGsrwd0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ilHWezlGNQN2fWzhK8C/xBHeV7ol7s9QgJqBZ+xekN/4Bdu89KWw1LHohZRXufCQ2EC0ZVF6dbgSswlHRoPIWy/8FavJDfWiSYHmVXwParyCBrg5y3Qf9IJnLenM2r3cxc84eLpkxjhD3pSfuxxbvnekTDOIekUKxW6w9exQ7/2VMR6XzGs49W/eoRgDclisgCLbrwt1Rg1GWPxxwvcH70m0uODfjSG4yAa+KDGs+rCdI70hFLkmoLVrK1ZL6Qv2F8WhE/iELdTzNMhKZo542nCyjRXKonHKE6/bdJRwm4pSU6V60VsIr61E2tKClACrmB5F2TK+B6GUAnZ5251slw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=d+x13OH70FoLGua0hwzzr1CD0KN7yoIZflO72pNTgL0SsnPTl151H/i42hS/XuXIzFrLs9B4Yj5OcSG6xFmseoOg23C5yLNWMm0rz1jC0ybY0AvTTGT5/E8ZAFfzQknefaNRMUh9qXXx1wgnyuYdqatyb0oR4f1cYDDHoQaiXNx5QsVPTlj2/fqZLGumA9NG7ybscPqfuqQ8FDRH3gjr87cbuEkkmTGq1YSnt1vkyIpNIButbU1dOWPNRwNsNuhEE8VAAzAI67gpCjra1LQZYpnOipjLZDMDaOQXk+X3ksCh2XseMVi0HPj4Swc8xET+N8hXrhsQYNnitwgwLtn/uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=aqGsrwd0h1/zESYmqX/MKp8bTrHeNUvJFvCwN8W2cWVakkaO5YQNhTAiV9G9TWLTfKhu2GIv4qJsMg8if5xnBkR5873E6d0Heoz71MDHh3DipCaIqlGYjSR/6wT6fu7o4WSfLNBh+Cs7JCFPd5G6HOOMXZ3dYmbjsJbaAy2jf1hzKqUsIrHNH1hcjqzdmoEUyFsIH6C+tHnHOPtded+gX9ZUtMhMJ1HlUyfNxKofxMLuEmMMXRVxoULPFJ+DECxT1a50yJgL7sg7wd4wd+CYrGeejxErM9oW/YuD4J8qir+47gXBQHbFe6Y2TMSWB8yRVZb41vO686s1fCJkffsYWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:16:02 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:02 +0000
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
	Pedro Sousa <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v4 02/11] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Thu, 17 Sep 2026 11:15:46 +0200
Message-ID: <20260917091555.1443076-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0053.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::17) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 13f1ce2d-e391-4e22-2f37-08df149c4b90
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 euZ0tROJcoFOBfDNfqZKVrQYCnaZ5r93JcllGbVlkk3fHyH2Wg/mA4JJ80UcR0Fh32FkvomFoc7XduM2ptz6A3u6xW8XwjSB4qxuPpxQQhIQ6vlzYBMDlh1CaaFsDbQwgPVhDkogIHWkdIbc18LLfwMRb9xHspvmB7LiAZz4Ni93QL/xdnqvqrhXw/i8I0JZAYD++Xi1z6APsUQeYx+QicDotGfcQBDSs/JSx9xGLOED1W0gFfpYP29NoFAxDE9cXRhf0SHXMX2fG04xrofrXHtGHN03Wn1C6BMJ2u2uy2bwqr1dWm1gIZ4CU2i/S4FLogQlvXS8+lubZ9r0eX/8WPerTCKtlppQ1BU/TEIBnOuOm9hCtXDbeODs5GDbR8QjFVmzVgMkBvBVByc/FfUGhDQGzsDs2CIQLppQxAwo30yCfrlKb+roB51wEoAx98/yRyP5O9fhdjdipUpYAzoiTxbAybnfIG+G8102GqJurg24a96IIRPs+95n1nhtuKTZEE+RelKxeHXzEMBFa7PvaErkz9Tbce43FWbNsP/p7De2rGLs/PzC8Aggm4E9MmnFpHHOYn22m9qeVN8jsaQlng6JQtxlEQ0fJdQGghXkJGowPjvpWehSPAqHQJDy++Y5QgHL4hXRtfWRL50ECHfFgr/ALL+qEosMzZiOJsGun/vbzmRfmEC6Xc0DIDbRZdf209drjMZrUjfWkWr+UyARSQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VVNjOE1yMUdiZHNNUm1XZ2ttb3k2UlNtVk9KRTZGU2RzNW9KQlFNbGFWQkhB?=
 =?utf-8?B?QWNEdDFIT1pJdTdtQjJDUllUNXBUMkowWThBSXJKdHJvS0JhTlNWT1VGZXFr?=
 =?utf-8?B?RjhuN0lNMlV2OHA2WElyc0YwRUppNU5RWWo3cEFleFM2ektvWXp2OUs5ejBK?=
 =?utf-8?B?djYxSFZLUWZ0MnlOU0RYS0E2Y05BWGxROXVTRkk1eDR1cWhEaVhLMUtwbmtR?=
 =?utf-8?B?UGdOVU5FMmswQTNiUW9TYXlLdUM0WDZCajFOSDc2Zk5JU1ErSFhJVkZDamNF?=
 =?utf-8?B?ZEkwV2VLUnptREFoUlJBemNUUHNSbXBHUGgzZzRaZUJTalJmdEIwYWoyanZL?=
 =?utf-8?B?YTkrQk95ZDVqWmVPb1ExM0lWWmU1ZDE5VlIxQ3NlNnFWdEtEUWcwR1dqZ1Ja?=
 =?utf-8?B?Rjk3QUsyd3ppb2gyT000OXFrWmgvNlZweVh3ZGZPbWlPUDhnZlM1a2l6RTdW?=
 =?utf-8?B?TG94LzEwSmhQSFpTa1huM1hVS0tjT25kTWdmdjlFTkNYNklKUDNWRWhVSWZN?=
 =?utf-8?B?bncyUjV4VHVDMldIZnpJR21iQ1ZON1Y2NzVVZFBjVnpDakhqdlIvbXh3TnBD?=
 =?utf-8?B?S2dHZVhnelpZalkxY0NpaldjQ3FYRDVkWGxYdDFkUURJcHdndU5Ob3pmL0lH?=
 =?utf-8?B?dkkwOVdMT2kxS1N5VHh1NnppTUxiaTNESU94VzJaZ21iREVmOFBKU3NTVXd1?=
 =?utf-8?B?MEE5dVpmWVd5N0dnZFl0d0VUWGQwZy9zU0tscXoxTGpUQXREa1krUGdiUlF2?=
 =?utf-8?B?OTRhWUp6aUpISGdNVWh5MnpvbTdoVFZIQ3FONWkvQVo2ZmVtUEZockpWOXF1?=
 =?utf-8?B?RXNUMHlvRFFPMzkzWjBOY3JQMHUyZXdZWDhhSnRKajZ5bEdOWnJWN3paQVM4?=
 =?utf-8?B?bnpkM0czNyt2MHJRR0FWU3g3Z3FQeDBSWjcyemt1MG13MEVBK2Z1ZU15M1Vh?=
 =?utf-8?B?bjBWTDB2WGp4QXU5VWEwYzlxYjNDNThXL29hNjIybCthS01tbUMxZGExdVdX?=
 =?utf-8?B?ZW5NbGVrQ0JSTlN1WVdnSnJKWVczUmxKaGdZMFprWG1OeG84R0JEMm1nMGpI?=
 =?utf-8?B?ZC8xcVY2UURhUUhEN1Q1MXNYb0pPdmY2WmQ2ZjM4OW5IbWdWMHlBM3JObitZ?=
 =?utf-8?B?TUJIU05XRGVkMFRRNjZocDdkVVFscVlPUGdvQ0lpNk9ycUVmbmFwa0wwOUl3?=
 =?utf-8?B?TWVJalpZdjVpYTkvaVRoa281dFlRUSttSXVlSXJLc2JJY0EvVVBPbFVrenFL?=
 =?utf-8?B?VXdmekJNamRJR2ZmWFh1c0svaEM5cS9zajNCZklRcXozRmZTQWxNbTYrdVM0?=
 =?utf-8?B?Tm9JNm5zQ3pjMGhBRStBcGtXdmEwMThhVzBJVW5acFVmeHVYUS9iTndNaUxQ?=
 =?utf-8?B?Z3lZa0ZVbnJwalFQRWhJQTdCYUhhY2xiejl4SkhTWDdzU0F3aEFtNlByYXJl?=
 =?utf-8?B?Z2plWXN3Z3hHM3lRQUFOWWppSm5DWEkzVjlaUWpuUXJwTzI0ek1rKzRRTEl1?=
 =?utf-8?B?UnhLZEhaK3RrWVJsN2YrUnA5alRWVitFbm5LSUxlNU5SbEFPak85bmZ6alYz?=
 =?utf-8?B?Tk5laUVQMzNtdlduWUdRUS9acFpJWmViMmJWNGZ4TTlBWFhoYkZ3RTlDRTQy?=
 =?utf-8?B?ZnpHeXpnQitHc3Awc3Viek4xeVlaeTI0cWtCZmZXK2RoTy90YzJYL0R3a3Fx?=
 =?utf-8?B?NWVaQnpyWkx6aGJqQnNFaDRWOHVSV1N4UE9iQXdJR1BxZ3lkZUhDMzRVcmlO?=
 =?utf-8?B?U3dqTWhmbTdkTWlTZmluRVlrdGNaNmtLSWloWGVUalpyZ2IwamZPMmQvd0d6?=
 =?utf-8?B?L29ieERmL1RVYVEwNTc2TmpjUVYvZDR3b1VlMlhVUm04Wng1b0Q2T1JoUGRQ?=
 =?utf-8?B?Wkx5TkR4Wm9pa3R5Zit3VkFSdDRCbWtIUnZmUmRlQlZmcVR0eG4wNmZMNlAz?=
 =?utf-8?B?Zk81NmVwc1oxSE1GTm9ycnZMbStvTUxRTUtibG1ZYkt0WU5oV2dOeDg5Q0tq?=
 =?utf-8?B?dFF6cno0ZC9KemlFRVcwMi9LQjJEZXByZTRrTk1MMVZ5b0tUem82NXMvNm1y?=
 =?utf-8?B?RjZVQVF4YTcyd1JvRjN6ejl4Z21jdDBEOGJWN1Y0NGt4VUJYMnJ3ZEJaMDFT?=
 =?utf-8?B?dTlTRTlURmNTMmFrbnkzQzdhN3doMktzVWxBeWNmUk1WK21Gaks4emNJNVE4?=
 =?utf-8?B?OE1ZNU9BTlRNR3FzZmRhUkR5TWtlVjZSU0hoWkxFc3gzNEhUS3ZpZ1VFSE1G?=
 =?utf-8?B?M0RheVBsREtHYlVDcy80MkZ1UWhCaTZoZVErbTV6MThOVzVTQkgxNkZiakVq?=
 =?utf-8?B?MFpBVlZETDZNa0VnWStJWUlYcVg1TG9DVzYyL1IxUmR0alM2RE1yZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f1ce2d-e391-4e22-2f37-08df149c4b90
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:02.6037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+xkcbi6pN9HfqlSIVVfmSPEBkz7S9diEd7alr5RRAZQzCPPYl8u8EQ+PYMVgz3+B27mX1n5qSUA7sDgjFVXpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
include/ufs/unipro.h.

These state values are UniPro/M-PHY related and are not specific to
the DesignWare UFS host controller implementation, so unipro.h is a
more appropriate location for sharing them.

As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
TX_STATE_HIBERN8 enum constant. This is a no-op change: TX_FSM_HIBERN8
was 0x1 and TX_STATE_HIBERN8 is 1, so the compared values are identical.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-hisi.c   |  8 ++++----
 drivers/ufs/host/ufs-hisi.h   |  1 -
 drivers/ufs/host/ufs-qcom.c   |  4 ++--
 drivers/ufs/host/ufs-qcom.h   |  1 -
 drivers/ufs/host/ufshcd-dwc.h | 19 -------------------
 include/ufs/unipro.h          | 20 ++++++++++++++++++++
 6 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 993e20ac211d..2d214ce9620e 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -34,8 +34,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
 		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
-			tx_fsm_val_1 == TX_FSM_HIBERN8))
+		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
+			tx_fsm_val_1 == TX_STATE_HIBERN8))
 			break;
 
 		/* sleep for max. 200us */
@@ -56,8 +56,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 			__func__, err);
-	} else if (tx_fsm_val_0 != TX_FSM_HIBERN8 ||
-			 tx_fsm_val_1 != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
+			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
 		err = -1;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
 			__func__, tx_fsm_val_0, tx_fsm_val_1);
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 5a90c0f4e90c..6af6a268458d 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -43,7 +43,6 @@
  * M-TX Configuration Attributes for Hixxxx
  */
 #define MPHY_TX_FSM_STATE	0x41
-#define TX_FSM_HIBERN8	0x1
 
 /*
  * Hixxxx UFS HC specific Registers
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 954be9343f42..38897d01fde2 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -393,7 +393,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_FSM_HIBERN8)
+		if (err || tx_fsm_val == TX_STATE_HIBERN8)
 			break;
 
 		/* sleep for max. 200us */
@@ -413,7 +413,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 				__func__, err);
-	} else if (tx_fsm_val != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
 		err = tx_fsm_val;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
 				__func__, err);
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index a5ad5ce44a19..3c6cb2281af0 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -11,7 +11,6 @@
 #include <ufs/ufshcd.h>
 
 #define MPHY_TX_FSM_STATE       0x41
-#define TX_FSM_HIBERN8          0x1
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index c618bb914904..a5e40e7604a1 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -39,25 +39,6 @@
 #define RX_AFE_CTLE_IDAC(n)	(0x4001 + ((n) * 0x100))
 #define FW_CALIB_CCFG(n)	(0x404D + ((n) * 0x100))
 
-/* Tx/Rx FSM state */
-enum rx_fsm_state {
-	RX_STATE_DISABLED = 0,
-	RX_STATE_HIBERN8 = 1,
-	RX_STATE_SLEEP = 2,
-	RX_STATE_STALL = 3,
-	RX_STATE_LSBURST = 4,
-	RX_STATE_HSBURST = 5,
-};
-
-enum tx_fsm_state {
-	TX_STATE_DISABLED = 0,
-	TX_STATE_HIBERN8 = 1,
-	TX_STATE_SLEEP = 2,
-	TX_STATE_STALL = 3,
-	TX_STATE_LSBURST = 4,
-	TX_STATE_HSBURST = 5,
-};
-
 struct ufshcd_dme_attr_val {
 	u32 attr_sel;
 	u32 mib_val;
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 9c168703b104..e0f490e11c7f 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -466,4 +466,24 @@ enum {
 	CPORT_CONNECTED,
 };
 
+/* RX_FSM_State encoding, MIPI M-PHY v6.0 Table 50 (M-RX Status Attributes) */
+enum ufs_rx_fsm_state {
+	RX_STATE_DISABLED = 0,
+	RX_STATE_HIBERN8 = 1,
+	RX_STATE_SLEEP = 2,
+	RX_STATE_STALL = 3,
+	RX_STATE_LSBURST = 4,
+	RX_STATE_HSBURST = 5,
+};
+
+/* TX_FSM_State encoding, MIPI M-PHY v6.0 Table 47 (M-TX Status Attributes) */
+enum ufs_tx_fsm_state {
+	TX_STATE_DISABLED = 0,
+	TX_STATE_HIBERN8 = 1,
+	TX_STATE_SLEEP = 2,
+	TX_STATE_STALL = 3,
+	TX_STATE_LSBURST = 4,
+	TX_STATE_HSBURST = 5,
+};
+
 #endif /* _UNIPRO_H_ */
-- 
2.43.0

