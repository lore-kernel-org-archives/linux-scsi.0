Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011026.outbound.protection.outlook.com [40.107.130.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C343FE35F;
	Tue, 13 Oct 2026 10:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887423; cv=fail; b=eRuo97iyAFpoXbQNZI7E0O3Z2i676GnoqVMAcZdM1SU67rudoOSs5BON4bzXpIXQOoDN43/t/7ri+AqCQRcucOQYLcF0kdMvnj2n3bt2AXHO6ARycAEj+BtKGsq2v77b1OkpW7gizoWDNfIX+8rhFhSMmhvvZGmXE/2quoLVx9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887423; c=relaxed/simple;
	bh=b8yFhbe5RmU8hRdUh1VkilrIemV5CvKP0zNsavASvBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MMzCt4vck+NMSpg4heej/cL+6NNgIMLHtedbwaZXkaIBmjX0jjzaxWsVYIAlmQ+AbokQw7Gg4++OB21pZt3OCnsCBw91Dmds2edaITdWOw/48nE03j39R8jEPNi9t00or1CjqyH31kv3lWHH/gIHNt+Hvma4z3T523iiKv5hMYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=YmwoQtTL; arc=fail smtp.client-ip=40.107.130.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="YmwoQtTL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sMxC+CNHqdMcEy+PzTw5XjdhrHLuqFDj5hQAFmJ5F0shyoUjWrnQAKpOHKSLQggRjZu0qzPMbEbhanaBNyVVPDTbsEZ3XVNAwilkBfbDTXPJ1zDF2EXc7t6UJNWlnhusgWRGXvdfHFtru/4H3Bm0QjYUn3uEfS5eXBz4CN7OrgufD4NvFTpVY+vM5jEnBP9rYRmHBXTwIiTM5YwVRDq29qaZ4O3qNFoL6hDS8koP8eeYTqJfx2MkDE1Gi1L4Dgu91TNKf7bH2UhjbJKebHalVmyGGhAxDVNG6cmZZxuXqLFfgLvU6ZIxyU0P/byVRhNCFGOJJf5MAJ4hyMkBU9TcZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=xgpsVtHSlpR1Eb+VghLP5PL3oRVc4VGqWabDS0Cd1hqFLQ3+2eBDRVnk7++gG6Ultt2NwqPN5uJUqt4YI4aGHsJXACZ02EwW4flo+ihLDr5dPNs/BPVU3nxHrdM6pNgNTELvTW5uMyw0EALvis+R4O4x1n2UQkoRgq8zo+jzOy0jGqe5qRZQjez0a+Gxr35BfBFdHd8TnZn1fMFtxG7bF2sYRFUYCws3wYUSozXmor21wYuC8pg51fECMjNfrZly0lnm2wLkgUsT4qdYmsRF83NpzM4FvpvduSd/9gW63wT7apiCrhnyuNDikTRc2U7cxmnufxSn8UYgF/F5fEh0cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=YmwoQtTLt/IJj9/jHloTG+69APjdRKy2cqbf0MSGYWVOk+mvXSZ9ZTUcYkend9awoeB2j/VkLlcQ+cWyMiKY3iBDcKjEI6suXNwNoNnuLLqriv/w+XWhOBSwVOGZCO4/b5LxvYWGO+EvCm2pREv6Ei275V1lycEJOpGzDMM8sYZuq481qg62gRTA1ds/VvhrBHGVk0GaWlrNr13oq+S3HzyrQ5hZ18UybOp50MO9CO53ekglYhDGbdAhHd+NySsuM1LyiDix+9BN4i26Olf9w98+ovxauLgJPm8VGZ/+b5UawcFGdJ0FjSnRqpMPlpyNeuwRbke0WFAKb/Zi5V9vlg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:15 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:15 +0000
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
Subject: [PATCH v8 02/12] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Tue, 13 Oct 2026 12:29:53 +0200
Message-ID: <20261013103003.373156-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::12) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI1PR04MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 40ad6e79-bc4c-4693-4565-08df2914f822
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|6133799003|22082099003|10067099003|18002099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 EhVWWe/ECDK52ZW+T+7ydoK+lvS3T14pNkVbuL9oEmIuWeuZCM+iXR+n6BKV5R+PQDXpMfXAuADEBlM/qpytfAFPPH10x47ZbtoS1Axllbf/+rVJcMhCh7NbEPiR7i8cZBl1KqXXbNGVnXU4Pd/GbIkTnmGvI2wAkNMqSafXRh/QEUO6GrEqT7vudLULm0Kn+tgWxHJ1U8uwayGCjARrEgVUYaGKy4XGO6BLdT0EjyYoKg4mtjK54Rqc4M3gO4sbSpWwf7qc/7AfmD0NfvA/J0kNWjgeyAZAzls9gK0UWveyh/u81bmtmMOULMxCK0/CzduV74U36JKdtqcRw7VW2QgLHBNxrGZ9tG5b5o0hbTeQuH/Sg3xxflViZedcDKo1oC2MQzCHbgnGUgmTHOsoBqVBcWfrAuzG72hnsjocfI5/grlvtPuLwyAFDcHiUR3Qei72M0x87SVxhSnU4t8TO2F1+euO6iMc843SZYF2PMS0fz7ZBxPaXXDeY6VwPkYra7rF3MvQ+jACCdDbsjEW7GOOkAd5K0m1o/rrdcuQG87pfkKioLujKbe6oV1ZStKs9NNwggetqutKqGC3sd8XQebTJqb3R9lJ7JkS6fkVMtzMT+SOyhEoPuMMJdPzyuSlyvO8cX8OctYWNResx3Zv6dXLWZb+6rWW15hZK6j2HMoXX26wMoJSNeYJKWGRyUC2Hrmqwy25kHKfW8HMO/q5cQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(6133799003)(22082099003)(10067099003)(18002099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NFdqVldPdThvZGY1YU9tYzBIRnNBRlIxd0RxK0taN09ocS9mbC9ISzAvYzlE?=
 =?utf-8?B?dE13cGhUcnhlQ0pDbDVRWExocWE4UHpwdktnNUtoS0w3M0xGVDc1Q0p6MVZM?=
 =?utf-8?B?ZFRvNllHMGVIcGxscWVLRGFKbnFHNkVQU1dkTGRCemVQYkdydm1vUGlGcCt4?=
 =?utf-8?B?RXJKVFh3K1J2YVEvQlhYb1JZZWFvYTgvazFUbVNvR2huZW9sOFhYb1BnZUdn?=
 =?utf-8?B?RklXdTZ5QWRGakdzZlB3cW90dytmNEd3Tmo4c3JnUnhDYW5PVFRoRGVmVGNr?=
 =?utf-8?B?c1QzOStnUUthcGNZY1Y0OWFLTTYrQnlwRm8rZGlLZ3QzZUhlbXhqOG9sYWJG?=
 =?utf-8?B?dFZ6bWRPRzRKMmx6cTdLcnNmRmJkaFlxdDBLYzhDczBidnFSbFgxbFJDdGxU?=
 =?utf-8?B?bkZGOTZKYUlNTjNWdmNoVDNNWXFPcXY4eDIzamJ0NUJta0ZXeHF6bkZOT0I1?=
 =?utf-8?B?bDk1elFBQ2ZXUXJSdktKYWs2cStKT3BTWjkyaFR0Z2lUWnY3MlBWQkJuNllN?=
 =?utf-8?B?cGc4eFpweEVrSlVVYUJuemNZRmhmV1Y4bTFSVGRFNlBacVhsa21mdEZwWVAz?=
 =?utf-8?B?NFJhbGJ2Z2Q3M2c2cHRDcHRlVGtBSHpIYTdaMzlvZ0xNUHpaLzJXUm94Z1B0?=
 =?utf-8?B?KytDR3g0QlVJWlBMRlVYdDRVQW9tSWtOMFB4OGRuTmFVRXM0NUVWOW5xTkhS?=
 =?utf-8?B?MExlMDIxbVNneUx3NjBRUVF2RWU5YlVlbE5xS2VZcTdxdXN2M3R6cks2YzZm?=
 =?utf-8?B?dTIwT1ozT0xCV1E2dFBaNHVySE53bjZheERqSTZ5WFFPQUN1UXNYdGI1T3hL?=
 =?utf-8?B?a092dDY1WHU1OUZCd1hnTjF6azFUS1VOWWFhV2FsMEszUU9naHZlWFV3ZGto?=
 =?utf-8?B?bVFPVUxDdDhXd0c5VFJpeDQwUkFLalhFTkZJblR4Nm9hcDFFYXN5dDhaVU9j?=
 =?utf-8?B?bTZwMzM2TStZSk5SVno1dDJSVmVMbWJOQmc5SWkxYzZuTnR2Y3NFdEpQa080?=
 =?utf-8?B?cUZKN0w1eVF6TXlydyt5R2w4NVlOUW1FVVRPdGFlbW1vejRTNGc3V1Q1SFBJ?=
 =?utf-8?B?WVRoSVZuQjNHUGEyT29qRmUwM1cwQWRQY0RCNm9LZmpVSk13NStiSzNjTU9F?=
 =?utf-8?B?cGpmaTZ4MGNYTGNIV3ZwRnB0MENOT3RQSFkyWUQ4eWhHMVhQYm9FejFxbmw0?=
 =?utf-8?B?MElYL1VOcS96QUN6b2htMHlnMllVd0J4cTQ0TzUxb1lyWkxIcWRHVXA5cEhX?=
 =?utf-8?B?T2srRVROSjRxa2ttdmorenpVVmF2eUpNRW00TDdCcmEwNDNESlpaWElIVDlV?=
 =?utf-8?B?Y2dGcE1mTXdhMUhoTzRPUkphRmp0bkdydDJtaW5WclRRS0pUMlpYRnVtS2hk?=
 =?utf-8?B?SmJtT0M5SXREL21kMk9FWUtrTldiV3N2Q0pjazc1TjR4SHVCOFpUc0doSCtR?=
 =?utf-8?B?Wk5zbE5NdWtNRmxKRjM5T0NtNEtrNVpNSmZ0aTF0eUVxdnZKeHNIaHJhd3FJ?=
 =?utf-8?B?Ri9CZ0dacEhkTUNnWmFxdEN3elBIVDc4L0tmRUwzT21KWlh1cGNHSlRlOHBl?=
 =?utf-8?B?Y1VxditrTlNzQkNIbFZqWVBTWUx4OTg0VG55dlloSkFLZzNEMURrY0NpdUJx?=
 =?utf-8?B?YUFjY1p6czBIRXcvUWFkZHhzb3RCRFhoYzBnS0FtbHJZaUYvcWF0NWk0ZzBM?=
 =?utf-8?B?RUZDOFhHTmJ6RGgxZGhTVU40dkRCWU5Dd3BsSzczTFpOZUd1T3Zic2ROYVZs?=
 =?utf-8?B?S0RqRnJrazRWQWIyZllxTlVGTFkvbkpEKzg0eGVpSmZPNVVzL0hLMmd3aVU5?=
 =?utf-8?B?OXBDOFJjTUloQ0NBVDRmbnBCOWk3R2JFLzVMN1RncUIzcXRQSEQ2alBZL2Q1?=
 =?utf-8?B?Z1ZsbTJHQyt5WU9DNkE1b3pJYW5UOXE0ZnRocjhTWnpWQlBwbUl4MTNodEE1?=
 =?utf-8?B?ZWZDWGhWdVZzVmNpbm11Y3pqM24zdnp0eGdGaTBrU1dCcjFISU5iZ0toSVRr?=
 =?utf-8?B?cmJlaEpaVWJ3Tk1UejRISWNIR2p6TTZRaTFxcndjaEpxbHB6TE53dHdIdWd0?=
 =?utf-8?B?RllDMWlGbnZDWjVWUXFvdVVQY2hNRm9HMzhjMlplUmlmODlMK09tRGxCSE04?=
 =?utf-8?B?dkRKNFJUYXM3OW9lTmo2emxwWG9CenBiVnFyMThyQzJsNFFlUFFROGJzYXFM?=
 =?utf-8?B?SS8zd0Y0TVNnY1pKbFYzUkxLTklwVlJSSG9LSE4zak5YaFQ3Mnk5MG40ZUc2?=
 =?utf-8?B?TnpPeVJRSjd6VGhlc2tMd0ozNWd0Tmx4cXl1RDdUVkFZV3ZDd042c3J3K2Y4?=
 =?utf-8?B?L0VPQzk0V2VvOVpyWGg0czVUOFZ5ckNrcGQ5Q014ejk2ZnhBQStKQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ad6e79-bc4c-4693-4565-08df2914f822
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:14.9975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xr1REHLWkLGCwTkQfAZLXyZdAJ0S+Tc2qjrMMOftUhVijR83zptwcUZSOTbkr/dVbSSe7yXDkt4O8cPWb22qaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

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

