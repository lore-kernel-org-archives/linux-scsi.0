Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A8E4A8438;
	Thu, 17 Sep 2026 09:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636574; cv=fail; b=P82jFR3g02PSXNQPDqKHIfkk6LNUde03PPEbo9BtXqsZGiN2kqtyOWB0l6ls2egdmBt+cL8l9CsIYayOrFI1IlQkqO6+lLx7EocdYqvDkSrbC2Cc4PZfdsmeXGx8MvRcN6ESxAbudwhH7muZoMI4ypgCMgyVCcQ1eg/WFX9jRWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636574; c=relaxed/simple;
	bh=pO29dwQXUgMLObxbYsrSz4aert4uYMTQzzOxsmRpNz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rh5DsLMTpjkBS77lFQsXwIKm1puT6n0V0Et9JGLzVGgS7BSgaR4tYgv3iIKoEeBNSGziOYKQxtPz58pAZq0AH9GPa4/SQwIIy+Ti1ym3UcYZR0c7XAL0MHHpPIyanDtSoddo5O9WezG1RJqWGhA7kbKWgEb+fzIHP4qjh4I+YO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=WCVqOdVv; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="WCVqOdVv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s4ZtN92fU8BVJ4zTEDb4fagpKVys4Dww9WK43qaVpNlDsgx7NZLRm+v8qLAFVRq0cmVHbujqSUWVDiQfAi5XQFhSZ2ukE7MGbg1WIytdhRFxOq+sfvMyZQtfEqiRO9zIUY6GEh6ROod9mvexnETMbzGUrOsmOZEwmcodCDB9XwxOvdoDJ6Co0G/RBRECDwdsDBhEBD1msHcXL8QsgM73/KR1MM1H0oP/4YBm/yLxU8idM1E8QOn9Paqv4eb6i/lP8sNiNuHX0u446UmGujMHqsf0LfsXj7YRJJjj6gGshhO1F1EBojUgIJFpoUKq6ICDvZij+6Hq5PORIUOzclrong==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MOK4ibuNkdxdm2oqC9DWfgPcKxJZP7VLYcxiTLpjIo=;
 b=yAU+yNa9v+zBkn3pHLetJOfKC6tf6imo0UlEmb/tnr1YbMZHF+exZkh0l3nWj4erdt3q4Yn7kYUFnLtbOwTc/jQVTy3ct9yvGmpUd4J4M7B5g7rWDZk2IRnCtY3ui0j5pJKge6ElkGOQxggYDwofX8HshhzfljZv6P2pzu1OGdUH24BjHXpprFkfZMO9ifmwQCIzVCEpC6E+3CWUwd9Vsj098JW2dSzTobVJQtwir/b8ndJ0WoIUMSfA2Hcuc0Ym1kwok2lvzdT2lF3/6AMDE4KNvIS9xRLBk7nJOranoVw9482TH7TqWi1aoRfwAJT94pxX66nKnsNP4vXl3wg8dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MOK4ibuNkdxdm2oqC9DWfgPcKxJZP7VLYcxiTLpjIo=;
 b=WCVqOdVvqXq98tZGME40wZ8y7nPHZpXxPuDbjpn2git1WaSoVZsSFROeLRzrXardy1P8lVjOb0Jnxug9YgO9z0k2zpj4ogVKo8dfN1VntjB7hQ4T4ItzmzyLdlu8A4IeRNjJjn5oq1X8C6i190YG8uQIPTAn34zneQWJMBCbBJpIqvpXQazoBSXtFisUozTaDSWZJk9EA5S1yLgMPbZWJKhEw5bPcCnGZoMhylKg10Iv9YyXkUg9PBNswCqKmYBxFqkq6XbHCoCSKRDqI8NhkzIwgg0e1N+Bn/cPmxo4iW4AbCkh7opAOqxa/0tZ5h7m/07FAWYPEHdRpj/2EaWPiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:16:06 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:06 +0000
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
Subject: [PATCH v4 04/11] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Thu, 17 Sep 2026 11:15:48 +0200
Message-ID: <20260917091555.1443076-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0066.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::14) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 59e316a6-beb5-4fd0-0d7c-08df149c4dc1
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 6t/DCVO06pP8InYMXF9wcCDszA7s1xRYc7Hr/C0HsJDVPzpfCrj17ATTuFRT9t8oIXbnmcrwkkhJoM5qEYD/A2OvEDjSv3Yqp+wwHcnEV2XaqEseHbCNP5TRP5+n2WgwJahRxFK2Svilmcc185Or4ulhuH0qVEm2XUZ/UsKp1tJHrHG4lhU8oi9cmDpx9oNv+QUtrN3J1WYVHpkSBRXIac93eu4VVvKIJvmVcLhjRWT54rxNtoDgm0gLiSXG9tzcEWewDPSod9KJR2VVQVdBQ3N1eYfRuhYqWph0wa/HGE6JPpSHomJuzdGwLKs3J2mZMDUuoss581LQ74Th1ZolUYXP6MaFzslNPhFtsFY/z2AwTpw2Z5iqGcUeHy+HWpm/uT4dDfxjpxGj2OaRAZxrUOU+9rf7zvDWU4JCO1aukU7ove0IXJdSFAeCXkNFD7ihkdWW4+KjkAvJ6a9wROxzyh6G7XsNG1WSwxIDURpQtD0SqgA/JvCZZNNbY0lAX63yHqL2yvHHsW2C44rLh//zMiTvxcm9v0w7r+kKQuY3gxbymfXQvaaF3R3b1JVhfqcdOZ/RuNKgWDoreq6LgrUrH2ZvfIdzeOCx2zE9bCqB2iY5voPWoduSRQDNARFC3aJHIfIxemLhsNL2XEXMbwffrPj5PolSJsoxYF/IYOuRx8KT3YYuX0bei2Mvb0SxidY/wTBmMyl8Yg3VytVZofNzsw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SnlENGFydnBtZ2NIcFp1dTVtSlhDT0FYRjNrM05mTTNwRVlhSVM1cEtGdTZM?=
 =?utf-8?B?c2tnMnlkcjIreXlaWDdDQXZOc1o5THBQOFBCOTJuWXlLd0xIN3JLTWZQa2Fl?=
 =?utf-8?B?d1ovUGsrVmZPSW5PbmJOUmh0SEUxL3FzR3ZxR1BRS2psd2E5OTNFZ1VrSjhV?=
 =?utf-8?B?eENpemZreDN4UXdBeE55YXY4K0Rvd0VNYXpMS3prTHplRmVzV3NmWFdWK1lD?=
 =?utf-8?B?Z2k3MVIwb3o2Z2VqZk43MUI4WXdxbUhOQjJZTXc2Ti9kYktYVWlRYzR6WWVq?=
 =?utf-8?B?Q1V3d3VyN1hnNXNSRzhJOHhqTHA3cHN3SlZHMlBZUEdCM0JoZ084SDcvYkVF?=
 =?utf-8?B?cmtzbW9mNTBkcGRxbDhKOG5lQ1RmWXNKL1ZiczRQVDJKbWUwOHdybkNzN2FT?=
 =?utf-8?B?Ync5NzhKOUVodjJVbjc1V0tzKzYvZ1Q3YkEyb2lBRHNxaVdaR3ErUHgrVi9J?=
 =?utf-8?B?WTdwU21QMjloUmg4d2NGaDVUVkRkbEJ3OTZBcEVsaXZSMGhEYllrbzlZbURF?=
 =?utf-8?B?UE9Mc2NhUThCZG5mZW91enhoME5MU2dsK2lrK1RUN2hYekErRkovK2VETjNp?=
 =?utf-8?B?WHF2RnFHZ2Zad3F1bFhSbjd0QXlUSFpNSVZKbkhjNmtCdkd2VEYyZ2x6TjQ5?=
 =?utf-8?B?dHBKSTd6QisrNTlleWxHUDhQc1d4M2hCN0JrL1B0K1VHWGV5WVROY0tvVmt1?=
 =?utf-8?B?SmQveWVuTU1QeXZORmxBS294QWxNWU85ZUZnN25PRGlIUUZYNE5wNGxIYk8v?=
 =?utf-8?B?emxCU2s0ZWQxdWpCMXFYTW0yVFFlS1NQYTl0MVFtYi9Bbk5xOGVGQWJWMFZv?=
 =?utf-8?B?U2NCMFE3c2sySjZtOHNGaGVzajB2Mlc1N0RLV0k0VTBDYmVoSFlkbDhlazRU?=
 =?utf-8?B?RU0yM3M1UU52aGlxRmpzOCtBWTVCZGVnMnAxZzJVYlVtNVRpc1hiZi84MmV3?=
 =?utf-8?B?c09abE10UmhJQVI2TEpDcENYRGxDbGlPZHc5V0lLNzZhb2tDdEJOcEFpVWw1?=
 =?utf-8?B?aXpTaU1GRFplNEpmbFB0VFEzYThrZXJXTDJkNGlFMEFPdUdXUFJqaDc4eXNM?=
 =?utf-8?B?ek1DL3ZLeTRwZjNLUmsrTUZoVjRoM1E1WWQ5VnBHMTBoenVqajVmRGtGbUln?=
 =?utf-8?B?bW56MFpXZXBUOFk2QVRKVmNrRVA0YU1SNUg4UlNQVnEwQlI0bzNJSmZOYm1W?=
 =?utf-8?B?Rm03ek55Qzg1YVZrZit1U0ZLcWZyaUNGUFQwZzdUODFJZXdLRnNwT1ZyT2dX?=
 =?utf-8?B?TTVYaEl5d0xScHhBYmhGamkvam03eFVuTHVKL2tHczlIa0dScXpIc250TkNU?=
 =?utf-8?B?bTVMV3k5d0h5MWlvSHRxTnpsc1VaZVd2ZHJ1QTdhRG1DWkVrTlpJcVIzeTNU?=
 =?utf-8?B?UnFZVlA0cjZYamFtQ3F0L3ZkRHRiVDBwaUI5b0M4N1dnSUFEYXV0OERaY0ZL?=
 =?utf-8?B?YUJIdkltWmhEekM4N1hhNFJZWGNacFQwNW55N201c0wyeW5IYXJCSHM3WXZR?=
 =?utf-8?B?SFRKN1hya3Zma01UUTBTU0YrN0hGOHZwK0p0Qi80akhCTklxcy9kenlEYUJ6?=
 =?utf-8?B?TWExdXgwMXFWV2t1bE9nemRvV3ZQUlFzK09YZVFVWUN5a0hZeDRNNDUrMzZm?=
 =?utf-8?B?bXpmQkpsUWxudndqTTkweTFBaFRjdDRpRmo1a2tpNkY3ZDZ2TmV3VC9Qa0pv?=
 =?utf-8?B?a0pNVXQwUmVpRkJHYUxRdFJJdXFuWlZ4Q1BUMWM1QTlLdVpLdGFINmVmUk9i?=
 =?utf-8?B?clp0TjFpbTJ3R042ME1DOTQvM2VlWE1vZmF1M2srRk1ydE12UkdBOFBGcVlX?=
 =?utf-8?B?NGVudUN6Q29mTGM4UGM3Z2g2TDA2a0taaWtOR0VEakVFY3ZUZTNZdFNYMWVE?=
 =?utf-8?B?bm5WRWVocFBYajRmOU9DTWxiL2tCeE5iZitJMVZhSWFuWERzY2VVamtyTzlX?=
 =?utf-8?B?N01GM0djNzgrbyt0RllWTkxJYjRWTUpEWndkd2lmYzlDOStLTVI3L1A2bGUx?=
 =?utf-8?B?eE1CZzREUWkwdnVUbFRhWmRzanp5dVMvc1lrU2hwTHBLVSs1NGF0ZGtIOUJB?=
 =?utf-8?B?dHAyeWhuVndxVlhxWnJhQnp4Q0h4Q3puZ1V2bkI5YXI0b3VZQTh6RDJEZWpI?=
 =?utf-8?B?TWY4NWlmSm1CN3o2TG5HRmxoWnpxMzVSOGNkOWo0ZDFYb0k0ZHdSZE9iczBm?=
 =?utf-8?B?a0lsWjNuNGJoRmdJUjRiU0VyZVRWdXRPdWszY29DanRia2tTamU2VGtvTVpU?=
 =?utf-8?B?c2RoRG1SVm4rcVNEak4rSlhTVDdiTHBaMWl6aHZWWmtGUHU0R0k4SENFZi9H?=
 =?utf-8?B?MGhqN3FPNFAyOVhOS2k1aEtqVThmWENpeTJlNWJuT1p5ZDIyWkc4V0h1YmV0?=
 =?utf-8?Q?SuMsnjYdRdnwm0ho=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e316a6-beb5-4fd0-0d7c-08df149c4dc1
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:06.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ykr435Tibu5H68oUihRvz2BpjpS/TwxPRu02HAx5JrLuvzNQXm5UIGil136PgRfsE1wmVft2i70W8xA02EhCfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
enter Hibern8 into ufshcd_check_hibern8().

The HiSilicon and Qualcomm drivers currently implement similar checks
using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
this logic to a common helper in ufshcd so it can be shared across host
controller drivers.

Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
their local implementations. While at it, normalize the "TX lane failed to
reach Hibern8" error path to return -ETIMEDOUT instead of the raw
TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
This is an intentional, harmless change of the returned error value; the
pass/fail behaviour at the call sites is unchanged.

Unlike the initial implementation, the timeout error is now reported only
once by ufshcd_dme_check_tx_hibern8() after its final check, instead of
per lane.

This also prepares for reusing the same UniPro-specific Hibern8 check in
a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/core/ufshcd.c   | 73 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c | 48 +-----------------------
 drivers/ufs/host/ufs-qcom.c | 42 +--------------------
 include/ufs/ufshcd.h        |  3 ++
 4 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..c1c61377e28a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4448,6 +4448,79 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+/**
+ * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ *
+ * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
+ *
+ * Return: 0 if all lanes are in Hibern8, -EAGAIN if any lane is not (yet)
+ * in Hibern8, or a negative errno (e.g. -ETIMEDOUT from a hard UIC command
+ * timeout) if the attribute read fails.
+ */
+static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
+					unsigned int num_lanes)
+{
+	u32 tx_fsm_val = 0;
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < num_lanes; i++) {
+		err = ufshcd_dme_get(hba,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+				&tx_fsm_val);
+		if (err) {
+			dev_err(hba->dev,
+				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+				__func__, i, err);
+			return err;
+		}
+
+		if (tx_fsm_val != TX_STATE_HIBERN8)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
+/**
+ * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ * @timeout_ms: overall timeout in milliseconds shared by all lanes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+				unsigned int timeout_ms)
+{
+	int err, ret;
+
+	if (!num_lanes)
+		return -EINVAL;
+
+	/*
+	 * Poll every lane until ufshcd_poll_tx_hibern8_lanes() stops returning
+	 * -EAGAIN, i.e. all lanes reached HIBERN8 (err == 0) or a real error
+	 * was hit.
+	 */
+	ret = read_poll_timeout(ufshcd_poll_tx_hibern8_lanes, err,
+				err != -EAGAIN, 200,
+				(u64)timeout_ms * USEC_PER_MSEC, false,
+				hba, num_lanes);
+	if (ret) {
+		dev_err(hba->dev,
+			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
+			__func__);
+		return -ETIMEDOUT;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
+
 /**
  * ufshcd_dme_rmw - get modify set a DME attribute
  * @hba: per adapter instance
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index bd223bda1ce2..b84075dfe00d 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -22,50 +22,6 @@
 #include <ufs/ufshci.h>
 #include <ufs/ufs_quirks.h>
 
-static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
-{
-	int err = 0;
-	u32 tx_fsm_val_0 = 0;
-	u32 tx_fsm_val_1 = 0;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				      &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
-			tx_fsm_val_1 == TX_STATE_HIBERN8))
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				     &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-	}
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-			__func__, err);
-	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
-			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
-		err = -1;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
-			__func__, tx_fsm_val_0, tx_fsm_val_1);
-	}
-
-	return err;
-}
-
 static void ufs_hisi_clk_init(struct ufs_hba *hba)
 {
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
@@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
-	err = ufs_hisi_check_hibern8(hba);
-	if (err)
-		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
+	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
 
 	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
 		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 1e492dac8d93..815ca82a0878 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	return 0;
 }
 
-static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
-{
-	int err;
-	u32 tx_fsm_val;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_STATE_HIBERN8)
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout))
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-				__func__, err);
-	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
-		err = tx_fsm_val;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
-				__func__, err);
-	}
-
-	return err;
-}
-
 static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 {
 	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
@@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		break;
 	case POST_CHANGE:
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
-		err = ufs_qcom_check_hibern8(hba);
+		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
 		ufs_qcom_enable_hw_clk_gating(hba);
 		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..0d9d0a26eb20 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1556,6 +1556,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba,
+				       unsigned int num_lanes,
+				       unsigned int timeout_ms);
 extern int ufshcd_change_power_mode(struct ufs_hba *hba,
 				    struct ufs_pa_layer_attr *pwr_mode,
 				    enum ufshcd_pmc_policy pmc_policy);
-- 
2.43.0

