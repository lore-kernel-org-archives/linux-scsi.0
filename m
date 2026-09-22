Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010045.outbound.protection.outlook.com [52.101.84.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59965377ED7;
	Tue, 22 Sep 2026 07:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062420; cv=fail; b=caSJ6V8QPkIhExM8Yx9OdAAN49En20QpjbneyRAChOpt8OJtPCkBvOywWv0KveBmRcDd7UB2qoAZA0pJasH2i/5cu5AeLoup7SSmDvqDva5GeliL8zWcArlhTg+jDuAPG5Nb7InV2mZKnjC/XIXc8RycWOHdt3ikXo8Yq/T8pHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062420; c=relaxed/simple;
	bh=b8yFhbe5RmU8hRdUh1VkilrIemV5CvKP0zNsavASvBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UfQBBqo9ge1FJtko/Zqd64E0UH3TGhAoPqOg4lJ8T6Hf79NNn7EwmXDZIPPF/qOJ5cc1KfWvgtZzfYiJO6bFhnKu5mLkRj5BjxjclnwheekA/+iJWN9oKFwCxVzgtMnwfoHWcF6xnaZb9CoRuai55+ZkwUAW+cKYfK+b6LW7N7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=t8l0Bixu; arc=fail smtp.client-ip=52.101.84.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="t8l0Bixu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7/BXSNaqiIddNoCZq67LH5Eivdh3rsnOjYJSNLv5kUUd1XevKpjEe5InjRZLpoiIoaEbA7D3UuoRdIyiRHb698msFdbFs80q198wgMBZSOdd8aHFd7PczX9nbh4RbRgyFbIh+YTSl1FYKdcnnlBl90JG36vJRUfWbG1/QKbRNiZ/N2pQtcVNe3xbkucyJ1R2Pi8RDkqoe0gNbMioBWaqQNmf2tW8+Qlb33YyC40QL/+eYZ8sPCkz1IrIVjKWaxWtfxPv0MyM54GNALTSIiFH7DkHwXKj3/1UPstFszyf/gMuG5zbJ1obkc5j7TSPZ+EEVqWwc2TH8sALMBRnK7nDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=xUVPciFv3JxMD3Z+ddrMx4h6tmxRht+11De1076M5uo792tKKCXxj3w094qglUUvF+LfaeY3cC0DlnDpQi9orwJws8NtiVFKXrXwzgaOsePf+113/5SAlXKKTZWSobpGTN2gs7eux3nEwT+zafMX7KngB1r4girxfy8XRswIS5NduI8wXYflmGhQQ2I4N8ed72FX5NItYg15S4KoKoTtvy8z58Jky5QsrTgLQoCbwSdR86mTIfHGEd4mpiPu5vSjCpGR4vOxL+lArARUBA4b1WWMI2r0txTcY2H2h7tcRRvTXKy66Na83L3NHXRZVjNnY+c4ZDmoZssm8bj7CdHZ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=t8l0BixuFeFrHpbbK46ReokrCNizD3Tnrmi4tHJET0OCC9TsnYHXjs/6UmlkOegQC2c6MOnbSGne6wGPSQrvf9mpbLThNjhKyTMjDJ3VIEVa8BqUhn7EAKar4q7qPALrRpNTHLFJg/X1a8Ptf2Q5NOM7CO0c/Y/IUnInJY+GHflXzzuWYrDWvprUlMgE66xebNE9qC/sliJtnrymCsPHC+jQIBEFrUhvGdNKJRszjN1lgQkv3sjRfmLZhF+8Ty/Y6Z72He3RVWDCOQ3tlhvg5eM7a/7IhFNBpDR5xVSAWFTf05lSGoSbE3n9esZcpkFjgyRMckPjMpmL4e4HziH15g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:17 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:17 +0000
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
Subject: [PATCH v5 02/12] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Tue, 22 Sep 2026 09:29:59 +0200
Message-ID: <20260922073009.1449688-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0009.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::19) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 7edc0ba5-aea5-454d-2787-08df187bc4bc
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 I8I4kWj7ibP8AuYOJwDl1NdBoPeCmTfdepXs1UFOw1fHQMkls7MWH5wkKULSOrRShFd2wLsD9E13YDRxItVbXRcwyscjlnpiLeQtT+2/FBClG8q0PZe11dyEaHz7tVMYHX3vS8wzxE4xfQugZg6bDkmpdM9x1pUb1O8iT9sU/OEtfGfGYi03vOXwL8rQiIfRm7dywKUaLadu4VJ9Zxhj/U5Ox9dTa0inKj9mqHFHLz3QbyT4qUvioTPjS38Of9Z7fdVPTTFMfHTvIE2S7LGel0Q1+O+ZE420IIK/8Bv5DNi3L15tSsgGXV1abBRrT4LiEZTvmtQSnuLoHzeFnjG+nAAL0ciLiwSGf/P13UTBxaQ+h0ET+/TyTnsMSopfPU0YbT7mm9Gw1jVv0xxTEjcn+Zg4gD9Sj6YIZ9Emq6SgvwlqlzP+r26WUL5pj5wlys9PVg7d1z+jNR1Y8NGGNr9ufHs1MxF3CO2nbhXKxh2kPr4MKO7vdgdCydNdmRvfrWHx0wd09Luj3gSRAgwJHUZFDCVKuDaun99gJVk+2npS5R7bwQy6A62NUePLiyo1pQn1HN1KFM/49S3rP4EdUCg+qNTS1BZ9bzCNdByoe/xhxIl8O/U8fbJWNqTnc3TKudLkN4Igg2sO6zjeT4WtIIJcfDJPcLzxs463MZ0pw9V1Cbgxfrds8p6kUTE+xfpkc/4bKcl5LEJh9VQi0jcxs8koYQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NWZ4Mi9jTXpDSG41TWxkQlViYmJ3TU0zUGV0N2tINm1yNWNkSjlPdkxRb2x3?=
 =?utf-8?B?NTUyWWx2MWVIZ3BGQ3ZmcytFaUZxcloxT0k3OXVnaXBDVlBSU2NUUFp0a2lw?=
 =?utf-8?B?YnJHNXJvZVFjZkxOaDYwWm1LMG1ZMXBoVFFKVko4SXlKUUdPcmc1dmtkUk1s?=
 =?utf-8?B?NHl2T3NQVHZJYS90SU0yd2pFcUNwTmFiYld6TEkyeks1Y0RUM3kvV3hjVXR4?=
 =?utf-8?B?RUpXUVVTMFo5SjZxZGFiWVVJSEo4Qkh5WXpjdzc1MXRnY0llREkxcm9VNGxZ?=
 =?utf-8?B?a0hJM3BzNGRNMS9MYmdLVU5weFYzQk1XZWZGdnl6bGhFbVpNeGF5OXlGVWt4?=
 =?utf-8?B?SEFEMjdwbXRHS0VMa09ZdG03cVRuYkhvT1dydVAwZEhwVXhVc0gvQk5aZVdu?=
 =?utf-8?B?UUJvQys5TlFRQ3VTVE5ZaU1kZElHa1Bxdis3MGlmazhwVmhTU3A4YU1GSWY3?=
 =?utf-8?B?ZnA0dXlLSnI1WEZuTmo0cit1UUtDQnRjRWtRa1F6NTduSWRqYlZ4MUtkTW10?=
 =?utf-8?B?M0ZSZ1o2TWNrd28vWUptMjZod2ZLSW5XTGp3MWh0VVlKd3ZQczQ1ZVRhdEpt?=
 =?utf-8?B?c1lwakgvRkd5b21rdEJVUm4rcG1GSlhJdlBwL0x4QVlvcWxsWWtMaXE5cnNw?=
 =?utf-8?B?SnVUcUxwZWI1RElCZ0hUVHJUYWxZMGxrWjcvUFg1TU9CdFhNNXB5NVBBZHdk?=
 =?utf-8?B?dUtHS3c3Ky85MEhlNjZncTgvU01kWEdVVWJEdjJ4TU9mQndFUGt5MTlPZlV3?=
 =?utf-8?B?cHpMN3V3K3VadXFPNkxCLzRxdEN3d3gzN0tDR0xjaEcrOXY3M1IraDA1bVVI?=
 =?utf-8?B?YWk5YjNKRlRVZ21hcCttNTZkUTk1UHJlNmRBVkJxek1Xb0V4QUNGWnNJYTNG?=
 =?utf-8?B?WHJpYnZMeW94UkdhMmJ1UUw4VzNvMXlRQ1B4SVdFMDUydDV3djVldSt1SjBK?=
 =?utf-8?B?RmdUaXRDTTJjUkovZk5oekZoRG9LdGpYeFVJWGtkNzlEejRIRkZCYlI5SU42?=
 =?utf-8?B?N0NVbllxTEZjUEFocWRJV3Z5WmRtVkdSdVdYWHdKeTluUjJLbUNYSzNrTnNy?=
 =?utf-8?B?eXR5ZFlQdEVWQm5qTGRLay9tTjdLYUFrUGtWK1Qxdy9PbE53YjBlWjFiSVFu?=
 =?utf-8?B?TXhBNWJHcUZqQjk3NTFBclhsdGFOMFVoZG9ldFZlOUNOMHcrT2YrVnBpUEQy?=
 =?utf-8?B?TXdKRFBNS0hoVVNyYllJVHgwaEkwNlFTZmJJMWdUeGhJaS9McjRWOXliNXZ6?=
 =?utf-8?B?YU1PdlMveTdRYnlwOFNsbVZ4c1JFVStrWjdXNlZsaHcrWFhwTzkzMmVoaGFD?=
 =?utf-8?B?RmFBclc2Y3ZFKzluTTZSTGFzdU1zY3ora21DR0Y4NEFCV1BLa3ppNzdkSERY?=
 =?utf-8?B?UXJhVGsrQThtRHlaaExYOHlscHBEZzBLMEFvNGxqRmxGejkxamtIZzFOMU1V?=
 =?utf-8?B?UklqclByQllmN01qeXBwZFhUcnVFSFBSZGVRMlNLTFR3ZVdOWXVKQmowUXZL?=
 =?utf-8?B?MzFjZ25GRUhoMUhxNHFiemdDZlFQS0JwZFpFUUx5M1FBbGRBa2dwWmtGWnFT?=
 =?utf-8?B?SkM1Ymx0NGZXZU9lamh5d0gwTEh5YWhSZ0JyTEtaL3l5Si9MYjFoU3MzVUJI?=
 =?utf-8?B?TnZtL1FScHhPN09SNGJZZGl1UmNzZUE5bldEZTd0bnI3TFUrTmpBRkt1djkx?=
 =?utf-8?B?c3VNR2pBcVFOQUV1eUNiRjVDY1NiTzRiQUpuQXc4U29vam1XR21hNmc5VlZS?=
 =?utf-8?B?SU1CdytOU2RDblliVS9GcWJnbjhHUWh0RnQrQXdYSlNCSXdSOW0zZGt5SjZG?=
 =?utf-8?B?eDltQVBCZit5ZXp4WjF6aDcxeVpBcWVoQ3BxcmtlOXV2YmQ3RGpKVXdOc3ox?=
 =?utf-8?B?Si9qY3oxQ2hqU05aZ3lKcS80Sjd2TFRXTmFDaTB2b0RtNTFGNnBEcVBpL05D?=
 =?utf-8?B?RjNhdjJ4R1F3OW1BS3ZCQUtIaVdJb1JjODV6ckRsQ0I5bkExdWtHYjEwYngw?=
 =?utf-8?B?VzBUYzhVNnJvMURFV3hTMmJ2K0FWZThZOXJmYkJaeVZ4eUk4MG9rcEpiWUhJ?=
 =?utf-8?B?SnE0ck1HK2MrblluS3p0aXZHNnYyWklnUFBWMDlDcWxjc3R5dkdFWGMxTjB2?=
 =?utf-8?B?Zk9ISXZST2JONHRQTVp1T3oyRjllc2JLbGhoci9hTlBKZ1NuM0ZvemF2MTJy?=
 =?utf-8?B?ZGZaQmlmem4zQ1VPMDloeFJjbk5pRHB0dWc2cDBtMUsxeUFPWi9TejUvVHVN?=
 =?utf-8?B?akk4S0pjNWFqemg5SXJpa3VuRk5Kd2hORmFnUVZXeEg4ZXNHZmluc21BNkx3?=
 =?utf-8?B?dlN4UkVPTXJPbVhTRDBYNEp3c0c2WU1mQUV4ZFlWSS8zaGd6K2UxUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edc0ba5-aea5-454d-2787-08df187bc4bc
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:17.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzLgWPz8Sne1S6mrXaH6NabBdoOg8DzfTg8kLNP3mRHMUxNDEO6GioPn3tsiFtKqja3V8anZFZDErtbtfqv12A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

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

