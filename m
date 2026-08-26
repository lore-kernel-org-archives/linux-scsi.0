Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6E242BC39;
	Wed, 26 Aug 2026 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751666; cv=fail; b=rEziZ66nKa6KbdzpkvsrhnrT+Yq/W/lH+S+cUPseAFmhJIZ2x1G9gFEx5GjxtCS75Wu1mVMffSYRAG8Awzi2GJgQschHs3vaV51SiIGcpB+Mw1Che2Q+JY6gHxGo54+1n2sdS8+IXnegfVm/J0dp9V5+Ksp2GQ44KjKEpUQluG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751666; c=relaxed/simple;
	bh=Pvoldui4TqUzxH96n10p4Ht1WV44SHxFe2Pj2ND03Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VvY0sDq4JswNWo2Z65JKR2O3VK8R+EXHi76VSj1+e1YJiX0Jtf1k+JAhvikZ3MO4aeIM8Tx1YTnk+EAkaXATQuusgt2mn85X563UUgbJfJ1/u+LM7r9RpPq98DLzLTdVc5/NTzJkbSjTDdDpQ1FU6oLm0L93VAIOiYRq+GLv2g4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=OYaVrrgE; arc=fail smtp.client-ip=52.101.70.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="OYaVrrgE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pol/CnZDWMU5CUsXmUBDAa2uCrkbg7KWwMJtdPu9L4GQa/kqfZ4daeVRduWOkagDP/RrEUqn/uJFdnhPT8PSUFWqJSdJw4mpBWkU6qOzn95T0Q8HOJlziaJUgqrgbM52VLg8Xtuozn7w85HTFYSaWNL3Z6Tzzah+oPPYrWFDWcvk+so2VGVq74xZm89hL2XUFu2nsIKkNBKSqXp/mQn3R4vy76t/zJGHrU1kirRBx/ej1lASN+DYt1QERMtljRIoD13/SKa6hD8XJofKVS8GQYNfRvlrtKB3VozhIZU11tTO21LwY/TEv2EdmDUSHfuL+pxm9cbc6bQW4gorcVVsnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZgopwHOTMWcL2jVyCnKzavYy90keYDSAxmRhAEAfrM=;
 b=mocqnQL4Tmi5yDnYt6LDTDoUhVIn+ohIz0PZ3Agytw/cy0EdsMNFpaBv9UjczwE2NVttA/X8HQfiGYZ3X3KTsQUZefqPjvGYdjdVkfB1MBmCeZ/Sm4wxxZbBpkEHnvGWP0AXlnQMTHwYt3AJXwEJX6ETiMPvnAzBgcC4Kb9m83RgEvSZWW/j0Q4kROKCJCCyFyHrvcl/tAc++hurQp6vrfKkjoQx/qfEnrO+/RtMJLEJqSUnDixV+O49hCATxboHRusUbJOQpQPhup8+iriz5ffja91xefWTLgjXR4mjG4t8L65ZAGQiR+ihYECQcM+j/u4NI/LzHAPqFc/YsFXdXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZgopwHOTMWcL2jVyCnKzavYy90keYDSAxmRhAEAfrM=;
 b=OYaVrrgEIL8E5UXYzkqo9NO740H84S7mdOPsoo0wA9TbRrzS/Q6WW7JSgjiv7Ug1WOZLzS9rhgzdjaCHzZdg2722k+0rJfr3Wxz2EFJf9kQSVKJ+o+20lmvZC9VI4311ADhCN+9tNegITFJNNbCN+IaVlwZZwdcTx7OX4uGVsJt4/7bTbgZIcrV/7k/QLUNSNMFVtS3l/aC13S/9xUQwjOQAZmFC24CtEpjIBQ1PxZ+ecqiJYV2lGbIVXg+Q4OgvSnYDo3Yx+zrThLT+j9B9ooDrWpshIoDw1sNUCUAtF6liNyYHc4TeQkIi+uZnNFetycs/ZUAC8C5epYFjo2YGig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GV2PR04MB11862.eurprd04.prod.outlook.com
 (2603:10a6:150:2f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Wed, 26 Aug
 2026 13:40:57 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 13:40:57 +0000
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
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org
Subject: [PATCH 02/10] ufs: unipro: Add TX/RX FSM state attributes
Date: Wed, 26 Aug 2026 15:40:40 +0200
Message-ID: <20260826134048.854748-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0381.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::9) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|GV2PR04MB11862:EE_
X-MS-Office365-Filtering-Correlation-Id: d1bbe1e6-844c-4419-987f-08df0377a83b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|19092799006|376014|366016|921020|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 f39oqJVMDEss8RuHTCV5N7fLO0r0GB7w4A+8kUzG9r1zv0eDatkZQopn1UZjhV1sJXSCR3VJy7cWBH0lUJfPutcrzCsOVE9bEYhbJtZdv99DXBQDvl8h2BstKqGGQ0D8vJXrnwlWHNfm7SrbPLx0sTi0HbYYevll2M+d49rfKUBdRJaWlET3gqPGltcNp8ZhlZB44fDac9ZBWH+KUlnp/x7EhqKLo5WLvK8nqz43Xr1hon0qqoDefJlybQkX0XA+sXHY8FaqgU+d8eku41pisiua3NcKzLv3CAe3E3WVG1BQek3BZsmJAjZugDkgMDk+8cwkRJZC3PwiIgLkT56z4vjGS/u8onU6UDCXo8+6O0C8YUOl4H77nKdyZgW87dzuVNNtKgx21AomsmpYlCN1+PptDChpzxf82RT4vbKqdw1ceFcRooezEPMhYFz4xKmaA8v+3LxfJQJBskIkxIaVEC3WDp6haB7ZXCkQ2qE+dW5S4FYnXv9XRsWy7HTHfNTx2Ki/UIOA1wj0xHn1LmW/e+Yp4TqaQD/cRiTv67dfNgY0oNMFhEN8DVcdM4Sk0TuKMgQEJkCqrwhHXsXYxyE/+oI8EixCy9nv2/Ch+LwcNwhz4zwdm8AL7HfzNlfS7IWUztgPxG9cYe3dcBGZSvjfk9hM4/Zyf0Ytmj2JNmniHxWhQZPdq5MMnb7g4Uo8oNncx0H8aOk7DiffcOpssiQU/A==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(19092799006)(376014)(366016)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TWV0UmNnV1ZZWHpCNzM5YTV3RnJqbGtrRjZrcU5ZQS9vL2psd01sT1FqK1N4?=
 =?utf-8?B?THplOGhlUnBDY2NOc1QrRHMxMXdxRTZMejdwMWVzSDZRMjJ6VnJOKytzdGNQ?=
 =?utf-8?B?dlpVdHMwVzZZM1pxcGhyd0tiVThmRWRpb1REMUdWZWJEekJ5SWx5QlNKN1J2?=
 =?utf-8?B?ZEVVZThBVUJxR2NwdkZ0aDl1K3QzZnZhbTcyUkpIR1V6NS94ZGhzZ21jNnM1?=
 =?utf-8?B?WDYrMHFVVXBIMnhhUXFCTnVXZUpJNzVzNHVQOHc0S1NWVnpEZ2oxTHBuSEJQ?=
 =?utf-8?B?MTFPYXdvTTIzZnh1OFBuWUZpOHBQdUZFS2lta3phdFE3SnV2VlMvNzVhL3M4?=
 =?utf-8?B?U0dGblFMNXg4YkRCZzN0UW5oeStEdmtQL3RIVVdDU2VJVjF4MlZQVnNmWHlS?=
 =?utf-8?B?MElKeTB4eVhZZStYUmFQZHM5T0RiMlg0NDd2K3dGbmhMajF3aUt5WGt4WlFM?=
 =?utf-8?B?ZXpYSTJEU0ZmdmJjWFRiWXNrdnJhS2ZWenBTZFh2bVI2Wm1tOUNjYkExUnFO?=
 =?utf-8?B?bzVOZVZsZ3VhZjhlV2U4MXg3bjhpYWNJSUI2TlBpQ242bE9VRGRNcWZaZWJZ?=
 =?utf-8?B?S0YwTU9yamVUTlpQakV5QndOdksySHo2OGlMaEh5WEtoRjBVWmdIaU5XTHhX?=
 =?utf-8?B?VGhQTDFjRWlJZzU5dXFDTFh5QURpZ3hJdzhCU1c1bTdrUXd3blMrQjZrcDFj?=
 =?utf-8?B?blBIYTNGZG1WRHRCR3I2U3VKRkt0UGozMVlhYXhmaTRzenNmSnROYXlBK0lT?=
 =?utf-8?B?Nzd6RUFhMHh1VkVnVWVSVGxERVh1NGU0MHB4dmZza25jUXAvbFRQVlp2U0Y0?=
 =?utf-8?B?SHpHT3VPQi9yd2h5Vy9BM1hic0VqS2c5RkJOK202aWFWcmFlenNEaWo4U204?=
 =?utf-8?B?UmVEWWdCY3d1N0wyVHNuUDV5SXpoZSs5REJiaU5CdERSUjdlbU03ZWtCUEFa?=
 =?utf-8?B?SzN1MUtVbUFrcWdTaTBqNkhWa01TcTZkeUVCMHNBTHlOQ3RnVXBqeU14dkgy?=
 =?utf-8?B?V0lQcFNQUzFCUGY0T0drT2svUUJCZUEwaTJGbDNmSS9ucVBTSVdVVDMxVHhh?=
 =?utf-8?B?RmVSN3paK202RHJ0UURuRWM1RXlRb1hZemttZ1RnT1hKUHRMNFRMS3U5UGVQ?=
 =?utf-8?B?QlZZaTM5enZtTDg1T0N2MTE4RTlwQ01VTHFFWXBMK3VndG9jYjF5QU1nRTFv?=
 =?utf-8?B?U2NCRjFsaXJhMnZyN1kxeG5xbkJGekZQSUo5ME5GOEt0UGE3eFVYRDl2V05U?=
 =?utf-8?B?cW12cnpWRjVLNVduN20yWHNxT3dqQWhUMmc2ZU9mZThNSktpTzdjK0pvOVNa?=
 =?utf-8?B?bExMZ2xNRXJuNFZCZEgzbityM1hlWEhmZFBwRUZjWXNTa2lKckQxb1ppMHgr?=
 =?utf-8?B?eUQzNmdwUTBlV0dJdU9iR0xSWjI1aHpvRGJYRTgvTG5Na01NRlRTNDRUSWhN?=
 =?utf-8?B?cjFFV3hQMGlkZGN0M281dSsrYVo3d3NkcUN3Vmx3cWZWRUw1SmxWNk1tSytF?=
 =?utf-8?B?OXJhNGdxb1RPVktTZEM0aFRpK0QzeGZvdnFzQ3Z2K3dJUUNOWU8rdURUS1VD?=
 =?utf-8?B?TVlZQlUrTi9PMEcyUkQ4b2RLVWhyMnI1VGNDa09uTEhzTVh0Sko4T0xpZFB0?=
 =?utf-8?B?anJYRWNDQmUwQWpYREM4SFlCY0w2WStNUmczSWczVE9NcFM0NUdPUjIxckov?=
 =?utf-8?B?OFBiMkJXZlNGeDdpMUNZLzZ0VDh1eTZ1RUZtQXo1d1BaY09oZUgrM1JoYzB6?=
 =?utf-8?B?YkVrUW9EdTRsT0JvOVgrZ0ZiRzNPN2NNSjRsNkU3TVozQ21jazg0bEo2Qkdu?=
 =?utf-8?B?ZXJ1aEJBQVlVRCtqR044NHA1YnZNNnk5eGF3NGV3bzIvSGNYT0ZlOVZVcUFS?=
 =?utf-8?B?L29TUzRVT2lYTlZnMTA0NUZncHVtQ1VpUlV2cGc2UmdFQmdPcGRlUFZKUVAw?=
 =?utf-8?B?M25tdmZMUVNxU3FSMXdPbnRtOGh4SjJkZmtja1FmTzJrY1Znd1FKd1hSQXRR?=
 =?utf-8?B?RVNGVkNGTGlySEpvU01VQmJiZ0JYdlZPWXdvaGwvc0dRY3VwR2J1bElXY0xK?=
 =?utf-8?B?QlR2TGJXV2tod3NMUFBic1JhWDZKTExJY09nTUJuMHFINGdETlBrbnV4NXBj?=
 =?utf-8?B?WFVveE9Ob1FLVFBka1RvWjVvZGFKQXNId3FXdU9uZmV4b1lxZVloblBkZGFG?=
 =?utf-8?B?bGxoWXc5L3VSQk9RalpnbC9hbTJiTk0rZklQUDllUzk0S0QydzUxMnlDUmtk?=
 =?utf-8?B?b0wvY2dLRlZhR0w1bFJIV3doaW41YitIRklmRzNEVUtGSHIyb05vY3NVK3lj?=
 =?utf-8?B?Wk9lVUdqbURaNGVDWUw1VFZmQ245NzUxcWtPRzJPZWFESnQyVzFWbkw4ODdV?=
 =?utf-8?Q?O9mN4/KEtDyaUgsM=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1bbe1e6-844c-4419-987f-08df0377a83b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 13:40:56.9090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ouw5k9AB4IduB3Xz2JFxuA7ngDoINCj70lPVtAmzcsoVqx8F3dnkn/REw9+VfPeTqdsZqPnsxVbcVaqKgFZDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11862

Add TX_FSM_STATE and RX_FSM_STATE to include/ufs/unipro.h, as these are
UniPro M-PHY attribute definitions rather than host controller specific
ones.

Remove the duplicated local definitions from the HiSilicon, Qualcomm, AMD
Versal and DesignWare UFS headers.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 4 ++--
 drivers/ufs/host/ufs-hisi.c        | 8 ++++----
 drivers/ufs/host/ufs-hisi.h        | 5 -----
 drivers/ufs/host/ufs-qcom.c        | 4 ++--
 drivers/ufs/host/ufs-qcom.h        | 1 -
 drivers/ufs/host/ufshcd-dwc.h      | 4 ----
 include/ufs/unipro.h               | 2 ++
 7 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 2154d6286817..0d4d5e98ad65 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -112,7 +112,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		u32 time_left, mibsel;
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MTX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(TX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
@@ -132,7 +132,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		}
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MRX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(RX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 2d214ce9620e..bd223bda1ce2 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -30,10 +30,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
 
 	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
 			tx_fsm_val_1 == TX_STATE_HIBERN8))
 			break;
@@ -47,10 +47,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	 * check the state again.
 	 */
 	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				     &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 	}
 
 	if (err) {
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 6af6a268458d..08dccfbec404 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -39,11 +39,6 @@
 #define MASK_UFS_DEVICE_RESET		(0x1 << 16)
 #define BIT_UFS_DEVICE_RESET		(0x1)
 
-/*
- * M-TX Configuration Attributes for Hixxxx
- */
-#define MPHY_TX_FSM_STATE	0x41
-
 /*
  * Hixxxx UFS HC specific Registers
  */
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 75f569dd5cfe..b2081ed6197a 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -390,7 +390,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 
 	do {
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 		if (err || tx_fsm_val == TX_STATE_HIBERN8)
@@ -406,7 +406,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	 */
 	if (time_after(jiffies, timeout))
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index b7b68333fc32..fc24ed995ff3 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -10,7 +10,6 @@
 #include <soc/qcom/ice.h>
 #include <ufs/ufshcd.h>
 
-#define MPHY_TX_FSM_STATE       0x41
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index a5e40e7604a1..0406f2bb576b 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -27,10 +27,6 @@
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-/* M-PHY Attributes */
-#define MTX_FSM_STATE		0x41
-#define MRX_FSM_STATE		0xC1
-
 /* M-PHY registers */
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index bf063edc284d..d9fcdf922482 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -34,6 +34,7 @@
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
 #define TX_HS_DEEMPHASIS_SETTING		0x0037
 #define TX_HS_PRESHOOT_SETTING			0x003B
+#define TX_FSM_STATE				0x0041
 #define TX_REFCLKFREQ				0x00EB
 #define TX_CFGCLKFREQVAL			0x00EC
 #define	CFGEXTRATTR				0x00F0
@@ -72,6 +73,7 @@
 #define CFGRXCDR8				0x00BA
 #define CFGRXOVR8				0x00BD
 #define CFGRXOVR6				0x00BF
+#define RX_FSM_STATE				0x00C1
 #define RX_FOM					0x00C2
 #define RXDIRECTCTRL2				0x00C7
 #define CFGRXOVR4				0x00E9
-- 
2.43.0

