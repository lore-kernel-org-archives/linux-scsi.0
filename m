Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011011.outbound.protection.outlook.com [52.101.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E1B4F4CF8;
	Tue, 29 Sep 2026 10:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676625; cv=fail; b=BPCfmKXPArUF5nUi/p8UY+4ZCBROamW1N5aBiuVrVc8/fIUs3jLUiAy/UzML6NoEK8Ug4QgZ+L5MlSf8DQihMnS1J7CyaKqtz4o7i3h7CD3U4H+6nSn9WnBv9H/84ZcVKkOo5MzBKCj5wQ52Vu2Z83kgmvgUk8crtHCwmPgn9Dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676625; c=relaxed/simple;
	bh=Gc1TxaOrHN222id8IhR5snYb5IiAsyn5XSCkLEPlpak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OuToiQ8IMrbgA8kA1zsNUpmrTeam7qKUBtVTMsWs9k76NfhMVq+zekosGJ/pCyd+hgm7HpQ9EYDhWn7G5+j6i5XjMRZyjrxqe74Nm1wKUfuTGhj+cIPTDDIZ8Y3mNZONiVvRwLuA0huwqXQbhPiQjByy8tBBfy47Q7sNbkjIsqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=XRPhODlG; arc=fail smtp.client-ip=52.101.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="XRPhODlG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ybaz3jZYt+uOdlDY/Rzy/xZjtsKiz2vBasVY3V3ldGREHDBzm20ArdJ+6jpPmpVk4tEeuuIoyUGXxJ7aJrJ6nvzB1IQe9/NPbeNrue6PcL4yCfmPQZX3lE2KyOqinaQiyI5yU1cOFj1YQy/ltiLiJ05Pqm3btAJrOqOkQONG3pgAAuZpVWnqSmUGiirget2oE1Vowk4zq77Xz51WD4DdbiWcZ3vKxw9zcOtlaeTdym/6Pi5FrvyAJTDE6UkCT+3gUupnPXi55xRolap6hI7r1GsuZVQ3TBNFZ2q2GIFwHXTtcTNKviZSHsP+Zh8koZqftrfhOiyt2crydctCTWdsYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=KoGy+9Pocu2vHNKQnV5RgEnf3sbLIrEq91Bpw56Slx3l0GdVoKQmTtl9PHzt3xVE/pApXzeJXGVI4q6FvDgf5eF0QzijhyxKXmTHaVwySw352KVeyXKjJ8ndketDB62E/NAU7MFW5SVHMOQJbcFo/Y1R77VfWTwMO2MP7SHaXFcPi26AcvhWNitt+48bBo4HV7ljgr0SbKp+e1UcL/Ji3pfUy4aDODhJ/VVOZ1O8TT6e+icCz6Y8QWCaGKa+eMYIGbfiqp1491/3e947ZZlI7suLkmDuLrghd5OzQBsxw6URcJM/qGjOVBYkFKb90Vi6R/0GIEA1WdhaMVpSROiIaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=XRPhODlGF61k9rx173PHB0i0je8wvpi5MNHaEzfngpfHm65GaJntHPsObWebZ7WgS8TQnU1dMCcKpkMOtialz4lJW5wiYWrc9w/COD/PPAxDaPfQI3oXEOwrJYu4tARJsS4F82KEkGyfUqidb5OOrV6/BZTidRfhRaNXKy4nAoNxer2s9MHYDsZT4DRqdsQHzYGL5Zhut1CarqV5lv5zMFw5S/eUdHSVXrDdIDouo35rYx1XLOKztUVUW7YO7G74U3/e7JB2Rabb6OGKgS8dgfdF4GdNoh/29243Lvjx0oroVCZadTrp6WTdUIl+76COs2Z2csl/9XVp03QjNiG1fw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:01 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:01 +0000
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
Subject: [PATCH v7 03/12] ufs: unipro: Add TX/RX FSM state attributes
Date: Tue, 29 Sep 2026 12:09:37 +0200
Message-ID: <20260929100946.693962-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::8) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI2PR04MB10595:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b039176-f16f-423a-b5a4-08df1e11d304
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 BQbTCEyu0HeMikLD2+9PVZQEx53wSYfjzPIFwTTEpQMaA0a9rH/BwfICTCcQDx16UEEAY6pRfiDipdStEjdvkKisseRqOsiCOtnLZmd0bbbN/yP/HlHg9HHAyuRk2JSAyXbWJOmRdfabhLy9m58oCU2KqfSjUTvt6DXSglWM+YEdGdWpFVf6g6PDhm/iMtEYadvFlmk/kSRx5hnO2Juu3l+pocSedZiYF9bRJPTwaA4ybU1WO7snUy3LFPGmQlX7C4Xt21j1o3wDheyljKkiCzD7ni/OWTfaQdeFU3xnsil2GevBILvZOWJeCI57qFxnevyaIp5fdWwrmgFGCgjvF4x9yqWL1HAUcIgG8W0je91fiOkqgXk7j7EXBiQD7XqQdTS9WSlK6ejX+J7Qp4iggh0/R5L9GSdo+K1AX3uyx4D9AtorOgHula8GpaNKW6wJJGKKGAZcipDNaEJcOl2cGvt9u2+uPu96DYgqgZ2kY+i0s7gkAmyycckoU4sYtXDqEwD769bY9wF0LZ3mmyZrgG9tph4ITvFuL1z/P6VbpkQRZDsbOa04LGdLU1cYedkhlnFYJhLSiZvqqTknVp2BbbLFRXIcGAWlMmllSW8BwCopA6BPQUMXcFvgbSK3ZUeSkI1j4mo8TuQiKtBRO/oXq31lDVuFBDJqIunK3mV9KC9ZoDNDLDVcAnS1xnbdPBHbjXzZaW4SyTKsJsWiQuKKCA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RUJRdXVXVkpieElPSmRsNkRFTkJKaTZmM1ljTjlueGZSa1d2TXVTSU9Hdkdk?=
 =?utf-8?B?ZnZ0dllsbmtwd1MvNytsSTVxKzNaZVZXdCs1WVNib2lMNVlJRDNhbzBoQStu?=
 =?utf-8?B?M0NoOW9IcksvWE14R25yT21VVE1iajhnSlJ3VncrY0lhNnFrOENiV2dWZE94?=
 =?utf-8?B?Qjc5VkFrQmZYU0hTa0d0ZmdJNndLcm8wcDZYb0d0bWFpV0c3VXJnT2h3NU9K?=
 =?utf-8?B?dk13dTJhcU0rMTl4LzZTazRPTEYxWnphdzdSTWFGbHBRbXQ5cFl0MDRJVm5v?=
 =?utf-8?B?Ky83UkFWMlFUSzU3cWhESHBWTEZvdTkySytpQjN1U21zWEtSM0lKREtyTTE5?=
 =?utf-8?B?eG9hWENaTXg3U0VrQVRqSy9JaUk1NUhUc0JHZGVOZFJNVHpPQjhEUGVqM0NS?=
 =?utf-8?B?Z3laWWN2bWlkYVFSL0xvNnMzWks2YWtJZkFtMDRzTVJianVLOTVwNnVRN0ti?=
 =?utf-8?B?cjQzbW1hTDBXOGhrSHQyTFJtZGJLUjZUM1FpVnVUSE0wRXJIWko3S2tEaFdp?=
 =?utf-8?B?N1R2b2dKNmVhYUVxTGlseHhWWS9ObjU2SWZJbmpDV3RJMndubWozQnh4ejlj?=
 =?utf-8?B?c3U0S2haSXl0cU8yM3BxcXovWGVKVUQ3dWZhNEdtTE1lRXJJa2ZWc2pkOW1w?=
 =?utf-8?B?ZFd1VHpzaWFTMXVZaGxYdXpoc3k5ZUJ3RUJvRnlLWmQwL1ErVXNkVCtkYmEy?=
 =?utf-8?B?ekRFODloaFVyeTdRczBwS0pHTXUycWhtZ25wbFVPYjVwcWdwT3lrY0NLRTZH?=
 =?utf-8?B?K0ZaRGJjdkhHRjc2amlObi9aTFdpajdzbHZON0t4bW40Rktja0QyWFV2S3R3?=
 =?utf-8?B?Y1ZyYzBydVVSZVhabVZBMFI1ZUpxVGFhWVBqLzdMbkdZOHYwak5sbUZXNG1C?=
 =?utf-8?B?SmtjNDlISDh4UzJRREpINWFOL3g4eEEvQ2VlR3Y3Y3lkdm5JdGU3Ulk5d1py?=
 =?utf-8?B?TGxaUzhLOGZVK0VJamY1T1ZjcFowazNkd2pIS29TQ0tLcDlKbFIwRDM5V1g3?=
 =?utf-8?B?V05ubGpKQzRqdGZpaTNaVmc1SDN4bGVBRzIzbTUxeVFRVjQ0aUNiZHRUbTdF?=
 =?utf-8?B?NjJmcXlXN0pmRjBUREtReFFSQXhMU3JINXFSLy92UmtZdmVablp6TGFQWE9p?=
 =?utf-8?B?TWRaVEFFRTUrZVV6K2dISDk0eHZnVGpnbGpTY0xSTWt2Q29aeU9UejUvbEtp?=
 =?utf-8?B?dk8zbjVnTVJScUpMSlBwU2ZGbFZ3QWMvVjFDanhSZ0pmZ1p3N1gySDNXS2dN?=
 =?utf-8?B?SzVsSUM4VVY0LzgwVytpVmFSZ1dsZkxtRXRBVU11Vk5rSWtPL3R5dmRmcVlq?=
 =?utf-8?B?NXJXZjdtTTNaemdqaUNHTitTUS9aQmx4RjBqZFhaOXdvQkRsTTlncVlZUjZP?=
 =?utf-8?B?Y29CS21PbTl1R29QYlIrZXRZZ0REUGdHazlURmQyN28wOVpkKzZvMFpyRmdq?=
 =?utf-8?B?dldYSmRsMlU0RlE5ODFacHN2eWwzbnVlZ1pEaWN1Q2RoUmJqTWVYNFRqYkdJ?=
 =?utf-8?B?UjVhSnYveVZoc2FnRXNheTR1bWlzb0U3MlJwMTNNclcwTldkdUhwK1lQMEJW?=
 =?utf-8?B?dXpaakljcnd5VkQxS1dzaDBqUlpwa0ZjSm51dTJPUHBzZlhkaXJlV2NseFA1?=
 =?utf-8?B?dTE0Y3JhN01uUkw1YXJSQnRoVktRMTJ2OXl5Sk1RTCtkaUdwNGViVWtPTXRW?=
 =?utf-8?B?VHJ0akczMHFJeHNUa1dPNmlpeVcxS2k5UGQ3Z1B1SldNMThiTFhiMFl1WnVp?=
 =?utf-8?B?SEh3TXhVdlEwbHFYZGtmaW8rblo4RnFka2RKdS9yNVlTLzBRd3hPZWJTSlhH?=
 =?utf-8?B?R3I2NG4wdGxCeFJmQ1c5MCtjTlI0OVY2K3J3Q0gwdWlzQUFvTEVNZTJvV09m?=
 =?utf-8?B?M29qTFZtOTZCNllhbzNXcTQydndTck0wQ0lxVWRlK3RNNGtwQkR3NDNJenh3?=
 =?utf-8?B?azJHTEphZ3QwYlRBem14aWtXZFBOOFBmR0h4TEY2b0pBaHJkem5pbzMrWlQ1?=
 =?utf-8?B?VlJvTFZnL21KTVFjNUg2REpkRmR3cEdJY0l5TndqaTUySld1OHc5SFhGbzl2?=
 =?utf-8?B?MWd4ZmxCeEhJYXFnR0t5SFV2TVFTTm8xUmk0cEU5TlpYNlRyZWRwSnliWUN0?=
 =?utf-8?B?V2tDTmVNTlBQZzFrRlRMbjA0b1FHNDBBNUNNTTU0azhqdy9VSGMxaG1WRnUw?=
 =?utf-8?B?ZzZ1TW9KTUhBMWhzL3V2b1ROUFhFM2JvMHE5MTFWNHJQYVpMTTMzTUVQL1A2?=
 =?utf-8?B?cDMxOWZOdk1iYm5wV08vd2dSZFFwV25nZEtzVFNnUTZYNTZza1k4d1QxU0Yw?=
 =?utf-8?B?SHQxMWdZbzVDRFFkeDhldTlYSWltTklLUGh3UEcxWnQ2Sy9oWjgydz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b039176-f16f-423a-b5a4-08df1e11d304
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:01.4515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKoLWRbAwznTQXeR5c1cNYXOwqKyLlhw/36OwemHZVe/c8BCsDNmb1keCeJzV1hlKtxoQgRgwVRTMyYnlrmZGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

Add TX_FSM_STATE and RX_FSM_STATE to include/ufs/unipro.h, as these are
UniPro M-PHY attribute definitions rather than host controller specific
ones.

Remove the duplicated local definitions from the HiSilicon, Qualcomm, AMD
Versal and DesignWare UFS headers.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
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
index 38897d01fde2..1e492dac8d93 100644
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
index 3c6cb2281af0..1ec661277c1d 100644
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
index e0f490e11c7f..6fee545bdee5 100644
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

