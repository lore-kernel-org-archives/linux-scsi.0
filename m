Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013057.outbound.protection.outlook.com [52.101.72.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA54246EC9E;
	Wed, 16 Sep 2026 08:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548275; cv=fail; b=DOd1qb+epCHBjDjiCRdoFT/YAOd8YtYocQA8O9/H9eEVDd1wea3EFEF/aH3QXr7oQFojfrc7LxW1pqNwCVgm3/tqQ5VIIsAwAtONEVtulM/Y7v0kOTpl34OjGtlF25TnSMjX/Y3N2jt7JaIL9EdRr2LBKRpiRQkGcdsNF0jf5S0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548275; c=relaxed/simple;
	bh=97icSjO12lOkdoavdD/UM60WoWo3z5SelKg7Df5h+A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dp/2GpWg2HA4C/eEbu5pXWVWJJB/kAER1gWMI8ahZUvA1OjL2Us8ER0dPnudjzHWVm1ypEUwPlQsAkgnRKWP51Vj9hesu+//jw9jeve6XuYr0iEeTWSXyw1ozbbOB+IN3OJ6aUlbymaecpP5VMIy2TTjjegePfs6lT6vdcmPLNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=EnuMdhzm; arc=fail smtp.client-ip=52.101.72.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="EnuMdhzm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9hHRijJH1IeLgjow846z3FqQyXX3S6WMoVSzpT/+kEGVVRQeBDF9DtjftKsn/2Qu5t29oGo0eMRIR4Go9wGvGKN04W3QXnLJuUlznqjgPr292UCqnBO2fB6jRFXWbIbDysUzPcYxiBqJuQGuzjDDDLRYVjD8XyIA2egJe8VY35XUpZGXTiQfBzdxMrbuePWg0eY75F6uXWXAVJMY3mvF6QsOqinlaZ2/PL6EFUBxkXXJd7JGiou1iz4jH3TRLB5hmv+INn7a8S9lMMKZ5Zr0VNY5LrQ9ZLC85zVXveO2P3DSAxAL5GLGTEDyKZ+6KcQoXGRVknlA6WyyhqlxYDypQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbLo/7oNyhXU3wlLm7ARzgq0CzyvIbJqz6X9OT18oWc=;
 b=YQi93cPxyR6lwSPOrgt177WpSOpbpfjzc2vQP1JAK6HJ2SRXU6SigqYJZsfpzhKQ6+1f7rTa8/1nOdDUBrihKUM7iDJ9BZFNBuiGiZZNsDdk89UIaLHp6SygTaTyTAyyoQaMln/NuUBjdJZkREPRzgjUlB4A9EOSa6Cj3/+2tip8XKiyEvOYjCti6DJmVBcx3CY+TJT7wzO+b0fIpoot2I48mRtwRHY3uNflCI2IIHoHA0kJNmsG6hcPnhWoxCpaUH5TZHWCRfT7zQg9UXdMBiDGDcl1oOcK5XCGIgGAgoVqht8NeFmrArbmLD1l0cg/vND5+4qb54Pv8AdkPGEIpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbLo/7oNyhXU3wlLm7ARzgq0CzyvIbJqz6X9OT18oWc=;
 b=EnuMdhzm2zC55n9munKD6awf5L+847P+XIJ4FS/PvZZtLpThZ+kgbxTdnvKcxNVPXNcYdyZF+7TmOULBPI2OrZHuumVNjAGmh0B0fMYUn+ZktAdMFMqkabfbvw8XsCrQB005jOZyyAq4rN8Gl/0HsedKV7XuxGoVO9bI2rRLfYj6tC9G1/SdVF8nLzidQ0cOKReymkUCL9SY56zQv82sp8uBD6/26uDQDLttgPUwG/AJkniHwIcW9jMHjDhqq72FcEB5tfP+w30pNdgRM7c575Qib5fCpazA47KfEiZeUHnvnyyyvATSEs0A2zwAtxD1WXGxNeCUsz2oqcvcmU0rfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:19 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:19 +0000
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
	=?UTF-8?q?Pedro=20Sousa=20=C2=A0?= <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v3 01/10] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Wed, 16 Sep 2026 10:44:02 +0200
Message-ID: <20260916084411.941297-2-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0194.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DUZPR04MB9981:EE_
X-MS-Office365-Filtering-Correlation-Id: cf39f537-bf81-4afb-f24f-08df13ceb1ff
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 gb1VbuvP79jSU27KQT//IAs/PhtJv6PKGJx1eRhiKNoquwHaww529jcVb+Z6CcgcrdF4lryvsfelauyxruf1/kJHrzSylad6ctXLxKo2a73XrNCpBFpFdGbJmhdX72l8QE8vWyXXm8Sjwj4Zr1h4y3vJ/y6ThL/kG3FPLvJpajElvEUL9VfzbxPw9ZPStdkK1v/9odXjJWlSGMNKhjMBhnp6FF5QcmK6bGNCDg7/PqSybcB1Fyp/6qlt8W3MlflAStVwGsWs4ksr17GuwnHhmokVUfXpsSa7hM2/Lw+XxCfUYd/BcvLWNOHyr32LclDqS+w5LQ1EvJRxSsu+VTAFXjqnTPUvBXw0elSfTmF0z2RYa6SYRgWs6a4TLsOBkpOz0pPp7vOoJOOcDM61TqbCSgfoxyu3at3vaBZyZn25hqfgPn7qO0oPZeTst4yQ42XVy+fMPHNwIQwqKtU+Kq3KRYkTUS46wQjf24YWDVZ2gH84VYzFMdH/Rmc8poSMAkX+jbMWIAFn/ArNwWXcqTAQgWPf39DtOPuKgP6xYZdUNUuszOxzIrysHqst6vILaNzXAgneEKoX3n67dNWgoxrs9FsQNGm2qAf0E9/k1G74sfZDHUwQb3+23HP8vbe9oBLpbKEmU88I2DHbKRhfrv2GgUnHR3/0T/yn81RSrwBy9LJGR5R+jzY9QanuKKZKIf0IFLTBrsldGcqs31ZisAVQ8g==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dnpGNDJXT0RXUkgxMDQ5SE9WRmp1cXUrQzRwU0NsTGFzY1dqaE9uT0NXRnRn?=
 =?utf-8?B?dURmbkcvbzAra3ltakh2OUNrSFNUUXdZYWNuYm92WTBSbGMwWVM0b3ZJZHJk?=
 =?utf-8?B?d081eVh2cGt3Z3FnUS9GV0FHZlNIdU94K0pLMjJ1aUIzdnpwREhzNFVhZVha?=
 =?utf-8?B?RTNOaWFOVXYxeHhrMFlZS3YwLytoZGdRc3BJckQ2VWJ6RHJyS21JVzAvb1dL?=
 =?utf-8?B?QS9jTmI2Y0szVDQveWVYQzI0aDBkRk5uNEwvR3FEODFKdzVmTnlxLzB6c2Zr?=
 =?utf-8?B?OVRpb2RYTG5SUThTbVFxRUdneURiQTZSMjZHSSs2VDNidVNRT0QyOGU2TEFE?=
 =?utf-8?B?dG1NeXdGOStnVk9uQ1JPQ2Y2ZjZyWlFtSlJBUno4S0NucTg5NHlTTGhrTTNQ?=
 =?utf-8?B?cEc5QXQ0UGE4TEN0dGtyQU9JWGFVc3NYNlV6VG1nRUI0S0JJRFRsdlBrZnFN?=
 =?utf-8?B?cHN5QWRDR1YrNklmOXEzTXFzOFZZZkF1SUxMNU5jSHJBR0JxdnJjbC9tUGdh?=
 =?utf-8?B?anFBQzN1VENWOGQxWFc4Nk5UeFlnSUVyVjJ4TkNQTlM1OUtqY1A1cmI1OUhP?=
 =?utf-8?B?S0hGOUc2R0tLY1VrbjRTWUFtZEJMOStVU01pNEkrYkI2MFcvODdkaGZaL2pp?=
 =?utf-8?B?U3liKzVUbnBBOC9BZStMakIwT3N4clhRaGwwQnV4WHcvMGhDRVpUbWtRN202?=
 =?utf-8?B?azExd0FWUUgyaWpDZmU3LzZNRDY0bVR3SjQ4aFhnT3BDcURFd3RPbGgrUTJI?=
 =?utf-8?B?T0tHZUVjUDZ2UW92UGpyUHVidWtWSkhMNXNWdnVEYk9yNG40TU1JWGN5Tjlh?=
 =?utf-8?B?cnRRSkgzRlExaHkvSjVmQzhnSGhBMUpTbjZaeEd5WkFLNUs2VmJFSFlkNlRj?=
 =?utf-8?B?OTNuaU1Iak1GN2xIajR1RU5ON3N0NStnd0FBbnYrRlNubW1vS0xhODdCaDRH?=
 =?utf-8?B?bG5heVBTTGUxeFRsM0g1WVZBd0JScjNtWnRHb2xkNEhhbDZLN2F2OEFzanEr?=
 =?utf-8?B?ZGt0b2ZpdGVOdEY5MVE0YTFtQUNVd29RbE8wODJYUE9rTGNaUThtS3kyZ2c3?=
 =?utf-8?B?YnptZFRWQkswTDI2MWlNTWdPLzBxbmlZSk5MWHNOWVRtK2taRVM2OXdYZ3NL?=
 =?utf-8?B?cTZjQUd0dEVtRXhZSWo1dUt3Uzc5NWV0c3ovRmcxVGRkWENWRDJDN29rczk1?=
 =?utf-8?B?ZWlvd0tqanRMUkhtY3RFZko3RTZzNyswMVd6ejFSdjY0N2xYczFiSkt4eEFi?=
 =?utf-8?B?dnkwK3J0cXg3cWhRSEFZa2VPVElXaVlsMVpGbnQzajI4UWNMMHUrTjFtUkpR?=
 =?utf-8?B?NWhVZVltdmQ5RjJwK0VKVVNjWUFkREt0RDFyd1I3ZGF3VDF6b1I2TE1Mdnl1?=
 =?utf-8?B?YnpIWTFKWEd5cElCQWF4Sm8waHd5RTkwZlBoMVFOT0JkcGRWWWJhMTgrK2hF?=
 =?utf-8?B?K3JJOFNDOGlVdUJjKzg5a25mYTFid3NOa1Q3c1JKWTZxK0N4L1dBVUNZeC96?=
 =?utf-8?B?QWRjcjhLTE9qN2U5SzZSczB4V0h1TWZOOSttNlY3dDEvakcwZThyZFlZb3pq?=
 =?utf-8?B?bjE3azB0ZDhSK0wxTDdiVkE3L0tzTWJGSnZKZ0ZZeUl2a3BmYXVuMjVuTllK?=
 =?utf-8?B?cFEycjczbkQwWXd5L3IxSWtyUis3TWtERmNCRjFyRFhPM0xhNGpGc0gyc1VQ?=
 =?utf-8?B?TFkwN2RhTU9Md2ZRdzhjangzZmlQQzd6cEdSWWtRcC9YUHVGc1ZPY2F4RDc3?=
 =?utf-8?B?KzNOK0RwRmtrSkV3bS81UEY5S20yNzd2Wmt4MUpSZXVkWG0wSGt0ZVhwVzY2?=
 =?utf-8?B?L29pd0pKZVlLTkhYajRzck9CTmkxVDZvN0lLT24wTHVtQSt0bnZIU210QTFK?=
 =?utf-8?B?VUNjeHQ2NUJGcVdNZ2hUdm1iTlFKN0YvU2dSaDZuamRXbmJVM054MlQzblBZ?=
 =?utf-8?B?dEZjVTZvY3ZOM2k3R2laREdyeU9SdUZ4YWpiT1lEbnhwbVB6NzQvaTBweHUx?=
 =?utf-8?B?MDEyNkF1Nm9NQjJ6dW55R0dPeHAxSkF2bmZPWkJLQk1PK0hBMTN2MnNCOEJs?=
 =?utf-8?B?R09jQjZsTzEvN0ZObGdYaS8vS2psZXhrZVlzN3JaanRJanZCaVk3WkhmaE1B?=
 =?utf-8?B?ckZObE5uaHYwNW96bHM1eDlINWhFNEVkYkFSME5uUFhvQVJMYVYrQ0FrN3VY?=
 =?utf-8?B?dEhiaHNZcEhTc3E5RThtYkZMdzFUeGhJbVpWMVlLM0djYjFWUjRJWit5ZEha?=
 =?utf-8?B?ZFdpQ0owYXpDTUV1Q29YMkFjbnJNL0k0STMxZlUrdk51aUkwVGpmclpIVU5F?=
 =?utf-8?B?V0FXOXoyMFFZOFBLWVh0NTFGVnVqMHp5MkhXYkJDQmRpbnBpeE5lUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf39f537-bf81-4afb-f24f-08df13ceb1ff
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:18.1132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7cLh/icA8mp4nYC0o6Cup38fpPWVyVgMLwuqdQOm7prm3dRHJdgj4eR0+2I9J/9AaP57udoPFHQEW+5+rpPhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

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

