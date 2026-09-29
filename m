Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011011.outbound.protection.outlook.com [52.101.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90FD4FD7A2;
	Tue, 29 Sep 2026 10:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676619; cv=fail; b=CaUzJ/f+Vqrd4jhF+gndrnzaxKQIPpuq00XTbr5UBWcr7dhbDdR81mWzIJBUe/Lz3qWVFrui9iEMrjZ8mobzREqQSK/GV/lvCQvz39fgMfGi1fP8gBgMfvia39c7/s5PLavJ5SBUdw8VY4lE6LDB89JNo1/RsHMX3TNs8ASAeZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676619; c=relaxed/simple;
	bh=b8yFhbe5RmU8hRdUh1VkilrIemV5CvKP0zNsavASvBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uUhhgkS68xnPrh8eOsaqZco0nmQ8mseQPysx1fAW/A9/xWZ2UWKGRujT8vSSeXydT8O8dSY/0t6nFT/iZebwjPj+e3cNSoato2vIIJT9znVLH4gMh4KgtZTfH2Rp/GgD8Lus1HfudI6LF77RsH/uP8PI6rYeTIujVCV8vZK4TUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=gunjheMu; arc=fail smtp.client-ip=52.101.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="gunjheMu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=abOPUwGF33/qZHqM++nMM9OAsYUomG9m2TJ9afWlAefXrCQdjw2R2Xaoaw02CX42kGl7XkAz0DhL/auBW9l4ObqRywubuN/gF2RWQ69+dchLoAyresitwILGk8iWqsqIWTI65e53TgeiduLeb3heUJgxEuHtYyJsGxwvArT0pcK+NJaYBUpFbrqE3XF6944GVzleyEc5dJYayucwR5ctyMIjPmT+9dX/jXycrnIfWzsq71cpFpkZwfIHViJC2UELXuHf5UX7G+HcBDx04X1BgKHyjIK79fyY7/ogStg2uSUyMlLIrV/RLa6X7LQEzrVB5W32HMRCHDnTNz2Wsqh2SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=sGfUpz3isL1UWwZyRcpq4ruu9FOBl6QqjraEw94Cm449rDE4kFsJMnBlcaS+QxAUpEPvX+IxuNacsHUcqw4nc+Hd8FTV23+2I/dP80yqk/Ixa2OmqfTfDReUwExRmqjdFLSLyCNeiADl5Jrj6x3HD0/MxdGeof94swnNHajBp0ApiCHKDsaj7lfH/6s/JG8hbu2H1LnqohZSSY8snd+RFTwyXrPXmU9X2Q0aJZ371BTsIrcUo7cNxzBt9oW195MspE+qyndnwKwEzJxa231QMk8p0Xy4HxkgsXnA7sLcdKMoRQVPyGbU98sRAgEPnJr0eLlqJO6/1biRZDmd6hZWZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2W7h+GjXafG0ENMAMi9o0mKcMCg1+66X3WswR1szRQ=;
 b=gunjheMuDL3bVUJ43znsYfB+NN03YclqByIGEqygY1yc83+PbdGivH2ieCyWzYqDtUKhynFvdUY5+tjhr9FQUqoTJSbr76rik6EiHf45jpYo03VRI8Qjep+udeBEMKaSXVSrimuGL4Qv7q96WmL4IJWVfMOt+NvLCNKSIKG7q+kYd6DGR4yG/Z+FhGg0cxFPPHB33r9X1OehOu3ZoGMWPnY4zuavm2Ugti0u7nxgtQknp/ql/1dENf6hF9sIAVrbyFxJPNJLWcAcZt0iq09CBS5Rbrvyx+2g8Khror59RHiEcCRU/VOVclen3cLXtZu3fSxCuLa290uoJfgrIiww1A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:09:59 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:09:59 +0000
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
Subject: [PATCH v7 02/12] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Tue, 29 Sep 2026 12:09:36 +0200
Message-ID: <20260929100946.693962-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0021.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::12) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 5f4c063b-69f7-49a6-79e5-08df1e11d1f8
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 531YxKZlRsCNUzGDHZUxaQ3YBNHryLFNcy8ieCmxjGfNhgNsSP1++tmMLqgCkAjdQ4YL0Uk9bNa6zn6v9Dyl1gtiX/JBaEom8EMFR8TL6g6Tvy3Gm1ZaiX7rv53EIFoO7CtirrwmBN+hkvXdlbQND7j3CS2AoimUebQuKphOk3Y0UauLEjg2f6dswC8+/OVOTP/biseO/+FGlWQZALMmfsP7K7oSe5aCXyUUS1w1qbK43rHUH6dUXmgUILaqFOcdYT0pPFBsAvxjZdRdi1Y28gFl2fuX34FmP06WxvYEqmj8CKPlj9+Njmf3fwu6fbQ1OBmIcTf99uOAAxgSe3c5MuCg/x6DxLL/breDbL+VGo1035jds6aHEKfS3iMOGfpoENGTb7JzsqQsEyGiBVVryK/BaOtm6qln6/BZ1Ho2QtXxV7nVQYxBsPr8o3Y3XsVpPKQXSLQrJRr1lSZSPsMA0bGkKv11X69/BLjvnCGkxUk4xWiwN+IYw5pbpjcqkiGFXJmi8zpoZK2wIzni3KYAmUj8vnicMU5TAfxSlMF5s+V/a2f5uJSCMPuDFOmO0NR0hdy7q/d/pOoVmhAgqBBmdO1MgtSvdynUhlnXKLb8QHHfl3yG9ijYSB0+m7kaihgXaeQhDIKH6cd20C8IeiJJnTKZmoO9Uu4rlpkseQxGIlEyat+/zjYZa5l1G+0NlOfMzwOkkFG2SJhR4pZmu5VQ2Q==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RmFneDREK25BOUNkbjFNbzV6ejRoSmNNaW1nQjk4RW1RS0NYeE9OK0NiR01B?=
 =?utf-8?B?d25GdXRYZ0w1Y0s1Y3ZpRTk0UE5hT0lZMnNXTG55OXNCRmtUR3R3QkVyQXB4?=
 =?utf-8?B?dm9qcWVaZUU0NWxtNHU3emlaTnFlaXhPVzNpNi93YStiT2daSVZUaHZZYlRv?=
 =?utf-8?B?bStxMTN2WHRGVGxJM3ZDbzFWVkZDVGRRWlFnbFdiWE1xMngwQk1MRERRYy9V?=
 =?utf-8?B?TGhrNVBIaTc1Ry9oVm9xYXVjbmhrWFZBTmFiQ0ZGclF0SXJKWGkwL0poQjVE?=
 =?utf-8?B?TVk5NkxRRFVWWWRsWjRjZ1VVUDBkbGxDbzE1WmY1NHgwSEk2ZzFrTUNLYURr?=
 =?utf-8?B?UjUxN01Mc0t4WXBDWEN5SzltMjgrckJSOUNLYzJQVFNnMTJiUGQvWmNHWm9V?=
 =?utf-8?B?Y3RkMFJNUXRMZWhnY3BiNGJzSzU4TnFYZXNKS1YxRlJwZEpRRmpCQzQ1YmZy?=
 =?utf-8?B?b2JVdDN2dldXQU5wOGVlVFlXclNJczAxYmJneFZEd0VvRzAvcG9HUkltOElh?=
 =?utf-8?B?NGpOdjJoZGpEWXFxanNsbW9hRDR6Yy9nV1JrTldTZTRhblVqRzZjU1o0bW9h?=
 =?utf-8?B?M0x1Q2YwUDZGQkVhR01nNGNFMHk0eDJmOTJ2R1l2L005cEdsbkZKRDh1dThH?=
 =?utf-8?B?dTVrcVlacUUvcWVPNWdsbk1PdXdoZ0oyTjVnQ0Z3OGp5ZXdhdlJXR0RPeFJP?=
 =?utf-8?B?bm5uVEhCcDlsTzFWajhwQ3h4Y0pNQjMwMGozVW1iV3loWnFMdFh4czVIQ1Vm?=
 =?utf-8?B?U2xlM0pRekJIKzFFZXhWb2VnTUE4bHpXN241ZWFwYStTeFRRSEkxNE9lZkRq?=
 =?utf-8?B?ZTM0Um40YjNGUGxFNHJveGZVUmZQOVFJSy9CRUpLOVl0RE1RZjFxSDZkRi9D?=
 =?utf-8?B?OFVPSzJVaW9uSExkbWthbnE0bGl4Ri9BM2ljOFM4aWY0dlVPdmhqWDZvUmVu?=
 =?utf-8?B?a3JZNlFTL3IreFBtRnRNWE1Gck80NGhITXl3Wkt3WWdhVUdkNEZIMXVkMGo2?=
 =?utf-8?B?QWM1SlRYaEhoWXNaMVdSU0hPM3l1ZURjWS9neHNrbGl1c29LL1lhaEdYWHpP?=
 =?utf-8?B?alk0TVNobkRTd25QUUhnZ3dFOWNYV1R5TUhBczJ4OERvWkpmRnF4b0J4SGlV?=
 =?utf-8?B?bWFkQ3dMRURYUEEzZklQdmJiRmd6SXFzY1B1LzY0Rmt3KzhKekd6cndpeDc4?=
 =?utf-8?B?UjhjQUtRSHBYK3JwckwvbDFSQUV0VUtwVzMrcVlva0RzTGhoVWxkZ1lCbDF5?=
 =?utf-8?B?SnVFREJKeUpKdDRMVnJkQ0E2R2dkbm5Tc1laZFdrMW1WOENqU1NrYzYrM0s0?=
 =?utf-8?B?NVR2MlZ0bEM5VEdyMVZjS1ZQOU5VNWt1NWpXYjdCaU9YRVNZaFpQaFhiSmdJ?=
 =?utf-8?B?Y21yNVZKMGxZQWs5cjlHeDIvVENjaFlVbmdZS2MvYXR2eERzcUo0ZlBCQzUz?=
 =?utf-8?B?c1RpY3lIZTlwYkdEb2dLMWExZjVCNWg2TWZvbVlmRmZZUytPWDFDdXFlc0Yv?=
 =?utf-8?B?aDc2cXZMaEI2SndmY2w4eTFiVUxhU09BNnFIZTE0eklZYWwxK2JWUm5XNXQz?=
 =?utf-8?B?NTlHeWc0ay9OK3ZsYUZZd2tyeWRoS2Zsdnc0MUJBa0s4WWkxM1p2K0pzeU9V?=
 =?utf-8?B?YkRSUHM1VTdhMTRNT2h2cnJmVHJrMXNWZUJPeTBNVTkyOFpXcjM4NUlETE5T?=
 =?utf-8?B?WUVOZ1Fidld3QndBZ1lWTDVtRHZZbzM1aXMwYlU5SUNMWFQ4akhFb3ViQmdQ?=
 =?utf-8?B?ai9xMTN6c2tGTWxZUm41UDRJOTlPcXgxU1lvaWtSaEdPTzg5NVdveXl3Zk9U?=
 =?utf-8?B?bzViNmprSW02NkZXeGlia05JNmxhTnBMU2dnendtb1hFVVptbGVBZk12Vm9N?=
 =?utf-8?B?WjJ0Z0o2aWhsSnhUbDF5dTBUWWRjWjB3d1UvVzhkU1ArMGtrVDlRMmUzQjF0?=
 =?utf-8?B?TWc1aHdOWnd6NWZGbWs5akoyOW9Mb0tPZW93dTBtamtuR3E1NmIycExxa1Ez?=
 =?utf-8?B?Z1V2NjVaODV6Z1FOMERtNkxyS3kwRk5KN0Q5bitYUmtPVTJaU0dGRmZyWUpk?=
 =?utf-8?B?ZjNjRGJQTkRZL2wyZEdZaDMrRmxwNWFjaWUyVllXd0ZWMkRSYko2R1lSaGNO?=
 =?utf-8?B?Y1lwdU95SDNXY0p0MW9zNHd6eC9lbTllT04xU2RRSFRzUzg0eVVmekFyUkpu?=
 =?utf-8?B?N2ViUDdHOVdmdHlNazAxdjdLaHJ1WkYxdEErVnRteUNKTUF0U0RPVjVHeFBY?=
 =?utf-8?B?OW9RUTFSbGdoVlFkc1dXSHNPN1ZkVUZoRTlkdUMwR0xsVHo0enVndi9vYmZW?=
 =?utf-8?B?dFZlKzMwYndRMzJzK1pLRk5QNy9oQkV5ZzZ1NmZDcjI3TXV5SXdPQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f4c063b-69f7-49a6-79e5-08df1e11d1f8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:09:59.6722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mevx+UJhourmYNab36GIYwG7m8GsCyn/hYAIFLBUq0I53RxmAXgWIskp2//syfqWek/yxh1/e8kx7FM9YKZL8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

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

