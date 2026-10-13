Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011026.outbound.protection.outlook.com [40.107.130.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB974BAA17;
	Tue, 13 Oct 2026 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887430; cv=fail; b=YzLow1fgaIDeOO2Vq4KhI3rBKp4Pq8b19YY0B0vcO2tpNkpq1INafVYo8aZ8VyOt70z1OLy4n7we949wn5HqWdf6naPN78qtapEWadB7QqIt1g1P2nYCcSLMiw47eFKTkrKgOkmHOdRiQZZ6yrXWLXP4WsHHc1zmIBGvCGZ57LU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887430; c=relaxed/simple;
	bh=4NiE8tq9I4+KkmCkCSUHh9s1MZ2/o+fYsMro5apuCVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DQAbd+lNT0MvTDTgomgNBiacfpfSpKdbay8NZnLnRZuQuBeGFSCwZdpC1dqEZtrBwFbTdlYA1qtQOUVJ9OPeOb7i0ufwQxlpO3EEXOkFLL0pS5TMNZPRAdA/NhnJE+wlKfKhIuDt4wmz6yqgFwu8sjn/ylJWKclKEWjbIfdNFKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=frCrnWwg; arc=fail smtp.client-ip=40.107.130.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="frCrnWwg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5qp4zviUCXmYTwZI5JUcOSIwx3a1U5iC1Hj4h29D0X5wUnU6Brj2uDQKE0bL7CZZCokRP8Mz9KYK4a/5pD79cTAwcgDsTmNXZUuPtzeRXEC6jg7oVN88ImO9kVzjNyZftZGZ7PYZFdlxT4/YJKu6VUf1bo/XMkAUBYZPnqW2mXzGwwS9NxFH35IfGUapIbX34G7mTJ/pko2IP7Ai4GyeEyQ8e2Mud9EaQ+13DjEyfmOhP/2VasY0VrvF1xy8nMNf/bw4C4U98QNmUiQAV8vzgpqnG2PLjBC22Dy0U6gPVgtfMZ4O5YwpBl4Md+6FEuE9AtDNegb8VsvZjkLSBqFXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXp3rs+Ub6CV/8Wrfyv80LYYCUzHY0Ly1OqLfOQWSFc=;
 b=Eefh20Nky1aCbhv2BHFrvKvBZXwBT7YeQl3bX8/ZIz5oBnWlGkKkCjyHEtXzm4Q1VCdOMwyVOQ4xipbWzJjcMBg6093lncOhG6ATr5WksJzeVCH87xpNIzWv+61I7bBacsCIeOTeZcJzwatGtG/n0surA0x7jEdEnn/DgXDKq1nY1Wlk8+oIE4Vok20Emh9VP98JeCmt3B+LwnvfooLTftEYKmMKrd1V7HtVmieD4XnM1z1sawExI1E4OBZrCGIWOMWVmhn9j2+mO47pxVgSp3D88NNdpIt30zvJaEKod9Vca8m8CGTVkE6qmtj4LgnLI6NhMvGVIil0ZTbXPN3/CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXp3rs+Ub6CV/8Wrfyv80LYYCUzHY0Ly1OqLfOQWSFc=;
 b=frCrnWwg7ZyG8j8+NpJkzcUXL3Lf4UaTQfPnTpb+0K8uiosPwllLj/FE4YAWtLL5R7Cj5SgsI8kzWXXLyGsIzAxpbpTguYXJcgJ5ml5X2pSq/dWVcY747T3mD56doTf4D6Akyc6HILLMRW2r0nk+d7NiC1HiXvYiMHatyS5Fg90DEYusXtPfLnvegvtqt06ygl9bTHuXH0A7fqiqdlYQIzRYp5XyKiALpsZlnN7U6NP00CLfnkXkB1Wg0h/LlgqDIdoXdxusEJ9i0eR8JN6nBoDjgGuNaBC8nT/g5P/BbenvzYkKXPapGBmBlJBNGCSTJFh19TtLx3TrkcynvI+m4g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:22 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:22 +0000
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
Subject: [PATCH v8 05/12] scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
Date: Tue, 13 Oct 2026 12:29:56 +0200
Message-ID: <20261013103003.373156-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::23) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: f4ef977c-c19e-4b7f-4d2b-08df2914fcc9
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|22082099003|10067099003|18002099003|3023799007|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 ++b1RbXL5g4IUmwPh7EgS40BrSW4wq0NBoo79t+8Ge5J69RI3kGD5oOfJlzTrSAX0FE7zco6wS19SvsPEUIYHR4GcElvs/iQ4H/vVc4P/bwFtxyh/A8ZQ5zEEtw4AmMTq4DJzRX7LqMINudO2YdeyJb4UDSAb8nYh/3n0lMKxPf+c/pCb7TGzZrGN59MbZs0NaBU0XBQG+JPLx/eiU31gzRg2oqmtVTygBRyM6OjJiqjzikwEtp77tynZ7AsXLJ9iWYSaHoooS406SupPceV/XgrY4Ce8iYm70gD/wehimm1Bf1dwhErgyU37aV5ioddnwWJ6Pyi4JxkVQFVHib3857cNT0WRGZxs2EyN4P+Z9upDPBLjdBaIBZKQTGusD8U1qF7T4tQFbFgQM0irvV8OPV2/ewBOZMI4wXhALRI9YbFbr6yN+0F+vPxMnHztgo8fzxeOXUtSfstvxbC3l3EGTos52XrFWAaGXG4VAX/XBA0Lk0zSVslHv2VsUYO1a7I0qvSyMvNYn2P3t6TOil3eiwuJiEwpALLOC+cHqIcahk2oBFtwe7b2/NDtS96q5XjUzPriLYIb2b45I6D5Dy2+WhbR7aNmNUklLjiN03zqPTkSRiAVsfIk0QZAW/XRdvsPLS3Pb6YytAcx1U77lJnn3cAUknoOn7gPcKVi1NgBZAvymiajeUEDYrSWM48zBja+V68VNWEqXwd51+kMf/Tjw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(22082099003)(10067099003)(18002099003)(3023799007)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MkxWOFBnRk1TeW1vRzg1QlRGY0x1UloxdHlMRnNDbWZlTndDYi91ck12eUZl?=
 =?utf-8?B?YnhtWmpnMEZmb1NIZzBjaU9hWUtIeFZyWUc5dUE3THVheWhNdllTY04rVlFV?=
 =?utf-8?B?Yit1RmU0aFhLVTlhUkswZ2I1ay9iWEkyRHcrN1h0V2s1RE92bHFJeXcydVQw?=
 =?utf-8?B?NlRJSHlYKzF3K1hMcU1INkE1TnZ2TUZMN1VjK3pwNDhEUEYwQy96RVpZK3lJ?=
 =?utf-8?B?UXArdnc1NGt1aHUyR1hsNk1zdW5FMWJWZGk1WVJUN2tKTDVCVDBTdWJ5WUxV?=
 =?utf-8?B?RXMrZ3hvRVZCS1Z6NzdXcVp3MGhQUGlGNDd6cjV5QVpZMVc1U1liZUwzS0dR?=
 =?utf-8?B?UE1TRnZCU2srRi9ObVNDaXNhcDZHUG12K1pOMWlxYzJ0SzI2cGdCcE1IL0Rq?=
 =?utf-8?B?T1h5MjBmOFlVQzVaU2I0Yzdac1Z0RkhIaVFycHJnUDMrVTd0M0UyZEhGKzJD?=
 =?utf-8?B?ckVkWlVQRzB4YklFMC9jMWh4UnlMQzdORE5nVWVtYnZMVVJPdkMrcU8yK1JX?=
 =?utf-8?B?VTZ5QlVod3BlUlhZYU9NTjY3MXFaeDhnNXhOOElsNmIzVVJJdmRkNE5DdGVB?=
 =?utf-8?B?TUw4UmJDbHNqUExya29yNW8yZTQzUEhHKzBSU1RTcjZIRnZMYmJQTnI1OUFP?=
 =?utf-8?B?eVlmTEFYWElvMzFFenZ4VXMzTlh3NTJJRlhIZEMycVNTbzBndnp3bFRKWEhV?=
 =?utf-8?B?QnR6M2ZwTk50Q3R4UlpUa2NwNTFSS3JaaDdVZEM5dmtOd0d1ajdxNTlvOC9G?=
 =?utf-8?B?dGJrTERESzY1OE1jRWJXVS90eWo2VFdxT2NJS0Rad2x0cHZIdUdFWllQVHBZ?=
 =?utf-8?B?cjNITVgweTJLczFnRmZTdDBuYlVhNTJNdVhQSkJKNlBCZnVqd3AxR1c1Skt0?=
 =?utf-8?B?MnFZaFIwWnB4ZEFPcURtTm40SENRVUd0QkFCYlVOR0NuUURHbi9Lai9tWTlQ?=
 =?utf-8?B?WkN2cDNaRHQrNXNtTmNma1l2aC9SaTcwNWJLMy9vUis1V0pldzhMVHBYK2Vl?=
 =?utf-8?B?Ullvd09BNWZLa01ROG92OXpGb3ZtUmxTNkZBZFZYNHZSWFl3cXVSR3lXaVV3?=
 =?utf-8?B?TnQ1UlNSQ0NFMm5RT1NFRHhOaUxxUzJ4L2Y5blFKbWRsZjJMeVpsc1pFb3l1?=
 =?utf-8?B?Y3VLTzYyU2NzRjVMeFdTNGhDMHhkcFlhT2lWbjdMeGgvQTh0SUY5T01RZTU5?=
 =?utf-8?B?UUNMWFlNOUorY25GZGQzWklIV3ZXNjZEL2pTRmsyYXJiaDBZeWxOWWJzQjZi?=
 =?utf-8?B?blJBYlhQaUJWZTdLcDVOcGVtdzdQbnQyT0lLa0dxbkhCY3BaSHFydi9ja1RL?=
 =?utf-8?B?K2ZCUFBOdytoS0NpelMrRUNlbUtMZ3doK1FrUGxLRHVYRDZnSzZVVWNDSHZj?=
 =?utf-8?B?d0J3a3dBc2JTTEZFWXlXQVlWb0w1OFIrS1ZYOGdRRUMyUm43ckFacmM3WFZv?=
 =?utf-8?B?cjM2TmpoUmpodTFIMEtGMCtkRkRFOEV2NEQvTXNRRHlRTkZ5S2NlZEtZK1hs?=
 =?utf-8?B?clFVaFk4eXZucTVhWnlPNktCSVE1WTBETlRQNmJYUUpPQ2xVaVJNenhKd0Jw?=
 =?utf-8?B?ODg2b1FrN1dCcWYrM1hsanhPYy84TmxyTjNWRVhweHp3bW1kbEVYWXc5Y090?=
 =?utf-8?B?eFFKMytsWkd3d1ozV21QRkNORDdvOFlGN3V4NHhUV0xVYWxLb2t0VkhMdW8y?=
 =?utf-8?B?Zzh1UGc1VXUvdjgxRElYT3RieUJoNDhxNnZ0OUxtdHhFQzYyd2lHdGtvVXZY?=
 =?utf-8?B?QlVKMllxSTNUZGVMMS9LL21WeUtzTEFWdU9sQ1QzdXIyMUZzbExYZzVoQ01h?=
 =?utf-8?B?aEZsYzR5Z3lGSHhIWUl3VTRDQXdlVEpIMm5jZ2JpNm5hZUVDdVR1REl1azFp?=
 =?utf-8?B?RGtkZm1zUWVBRTZKdDkxQ2ljclVvNG84aVliSTYzQWJjUUJqd25BdzM2Rys2?=
 =?utf-8?B?WkhhU1RBMDNUb0pSc1RKN29Lclc1WVRGUUdONjJxS0ltR1h2Q085WG5FN1Y2?=
 =?utf-8?B?RDljZUxFYVZMT0NGM2RKWGExTmZCNi9qOEQwMEx1VTE0SGUrNGorYnBLVDNk?=
 =?utf-8?B?cFFXclJZNEkwUEduRnhZSkhtVnJqY1AweUF5UnZ6U0k5dkU0cG9lbHhKVGt0?=
 =?utf-8?B?UlZudm95dmRKQlBVL3FoUDdXa0FMMkl2aDQzMnFySXhEeHhURDdHc2FVak0v?=
 =?utf-8?B?T3FuQ0lsRjVZcDBuM3AvYmJhTmdCUzlGakZmVS9ialJ5QmF2KzZvaGlnd1dj?=
 =?utf-8?B?S1djdmhQcVJ5dlA3RFFhRldBUzZnR3ZqNmsvdW9oYVQ2QUphNnJHMlNtVVdv?=
 =?utf-8?B?MHZTSFJZL2VvbGNTaFFnVnJVbFRsUm1RcXhIRFZ3TnBVRWthb2h2Zz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ef977c-c19e-4b7f-4d2b-08df2914fcc9
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:22.8072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yNltZOc0oj0COqwmiaA3/NoFckCLo12p9BO2ziYA8jVad+V/N31SxcVN6J81QRw/yqv9T1mogJsdPccLIkx6GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

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
index 71433b4d04aa..20b7174e9498 100644
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

