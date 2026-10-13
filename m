Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5B24E01FB;
	Tue, 13 Oct 2026 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887456; cv=fail; b=X+/vQ1BoIi8/EwVBdojc98S4EOlsDRjvoK68JRZMdzMBcXaynfKugOPNktJiFUYAtTX/9MLHA2c9h9s0Oh3+N/KOE53XZ7GfGl4dITuYoqO/xelsW8gj//WsxlWPG3/n/SiBNWScYdLT3KH+CAcFQMLnidKWFxLmYUhNDie4kXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887456; c=relaxed/simple;
	bh=SlPckDvgmCgHI3K96wXmE3PZMKP1GnJCHi/dHGpHhM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NqhRgoJM5CwsaWorLYA8cihbguRA2oCFv9uFjzC+1xoIL/EvBnzo5NGNYOY0Szd3wyGqr2PhyXOfVJnlMSQm5NUorGXUxFqR1XgGFHOn1OylZ5Zr/V85cRp0Vyw0vsGeDpH7cwOjxfUS9abq4kcK11YY4P+UhhBcc3itgY1mtAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=uv4AuIQx; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="uv4AuIQx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g3cihoy32urtMPt/IBs8uL/XcWM/cwK5N45lZJh8q/UHPmiG3MpMjmGKTck+P/k5kFgZymU8yUNrDmChssuHuWguDbXrq7L7rLOH0fViT8w4GX7K74j/uCJ64UD+A3lflK1ZQG84SMCoGK2V6eP5QooQfxsACb+20EgDHChafTRHNfU1jvOshzCHU95kgU1zSjRmYHp2xIYp5WKenLYO3w4MW7jDsBpgsTptsImxv6IimzqJczJpER1FmvgjfJZrVVjQfJpQSeMqJbasR2P96lph2U35mrRF8c7lk3a4BGpPcBe1/zdpytXEDQF5RomyOHPz/9Af37RJEk2SkLlcnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=jP6esPOHLTuRCsuWfZyMIs2qnHfJIQlQEczHtYCMY31OxWS+pPypCdccchSj4kVZ6bS8FHf/DfYFvuVn3OKSFO09Pwbi23hw/SR2O5sOwnIXXRS/f4uV0fva/PooDP4QZTR/gRY5bmHjf2Ul4DSS3Fp3ExhEF9QVHvzxwxFBZ0dFEOHMuoE6Re8BhDwRqKq4gxsm9lnSK3bZ3oxOHz7JEKSXXWvF6M3vLmrhR9gWEqkBRNF91bGfh4BC4gO3CUIEzLC4fzDq5rKK3LVA1bYdgV66/lG7RcGHN4ncahva26PTTe0YuGXUQFNoMvEIHlXgivCWB7IHUXkPI2+HnaiBQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=uv4AuIQxwQkVTaYeNtou8TxOeSTZjCFkXaMfFjzKz9tQnJGYH7zpWxe8Cx0ZmetBbJVus06eoyBEJlk+UvkLU3rzKfl1zwt+4wJtI/nF8qx2w3IG7UicTFx4GpObo1t1GOdRguStdti+jzGqUJ5p3XKI7tWXj29AEd0uEmzwvHqv1b/I40uBY0BZfjuuyyI8KP+HssBhG08NEBNjzZ6qhIQ92gR03pxrgI6TMIE7VAKA/cgY68iaWwLm7fOXpzxsV8vye0GVHwIpnuNSHSRfFd9GXopz1Z5QSpeARHRbf9dv1anxwjURqGXBrCbhoTfVUVD3kpxmxl+sgnr2UDOAhw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:48 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:48 +0000
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
Subject: [PATCH v8 11/12] arm64: dts: freescale: s32n79-rdb: Enable UFS
Date: Tue, 13 Oct 2026 12:30:02 +0200
Message-ID: <20261013103003.373156-12-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P250CA0029.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::34) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 264d5819-43c6-4656-c31b-08df29150be9
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|22082099003|10067099003|18002099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 0AgPuVmRAFeffW2UO/QVqdDK4Q/nPRdY3X0eKlWzj/1ExnlLhaqZ0WJpcCzKCgTQPa3ZZTDnkn+DSvMgmZKYX9IktUrOsmvHRKhKq/2qwRibkt24GBOFcjt1PnY9/gSpxRJ4AJB1d5r0VOnkxbqMnsJA0QF/p4VBtC/zsvPDILnRJVtdpF/HYCcuyC7AP7vHcZ0uZj/AO6mMmoLYRkDwFfRUHn6QBDEgb501zVBCwKIQ+bJ0Mn7DbrAMo0eAep7/L0uRFbM6Zj1HNsX5+PDpU4nIFescuUtMpwtuKiAD0Zv6XlX3LuAh4S0M6/FenW+OZMF42IBr2zPdTBshBz9uEg0JP2ZywuL8nIcU2vmvXPLpJcEn8DEPK0aDCCDrN/B/N6nNVOXCDkkaJCJ+FxMfGc7Akfj/roKdgG7MIV5xFiWqxkSHmBxLk+PlsZDnuiHYyD5Dq1zuK2pnu2thw5V7w5rmJGcVsbl6u0jj60lK453ClyqtH8w8umLrwSmNFSDiZDl/lf+ei3IZfZ2FGGkUJgkQuiYmmmdfrHb4ZcZdFEH+NfX9wykEpFML93QXCgjsqQlqi/lkA59Ua/ZDvwG3941KLi5WzAcirrPhUwApcndDg2jAX5rbGPvR5GfhuAWIw8bca5/aS0hKnZyOI+9ax/bhYKldGEk2Wi1U7Ws8olYlRWrgwTwlyQP9PqnCxqsQOevUsUjoLnZCb02qAQS0Aw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(22082099003)(10067099003)(18002099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QzYvMlMzK3V2RStqZzliT2Y4N202QjVVZ2JJVUI4NmRZSzhTNnNXMmtJSGdq?=
 =?utf-8?B?Skx5TUF2NTNmZ3ltUGFYNmQ2b2VGRVg3N2o2SjBOdC8vY09uWWRhT1BWOW5R?=
 =?utf-8?B?TkNYaGhCUUdnNTNieEpEWVREc0JBbDlLRXVxaTdJRU0wNFI5TnhFdEtreURC?=
 =?utf-8?B?YjJacnVsd3o4dWhNQjg1b0t1Z3RaTzEzY0NWNTgrVldLOFhWQW8yb0JYOHI3?=
 =?utf-8?B?QXNwY1hPb1RBN2h6RFVnQWlZVjRrS2I3aXJ6RldNOTk2QUN2NmhrTmZ2NHoy?=
 =?utf-8?B?VnNrQlpHdVJ6WldYNVhTc2lHdENOVGljeEgyV01PVkhiemdkMG9ET0Iyd0kr?=
 =?utf-8?B?WmxkdThpWnpSZlp4UVFUUUZCTk1zMkpSQ0kycWRvbUUzakM3YkxrbDlvNkJE?=
 =?utf-8?B?SUdaSjhuaDl6T2ZQWjVBNE5nTGZOeng4VTRBUitlMzVOUmJKblp3eTdPaDc4?=
 =?utf-8?B?K0NHMDA4dWliQXRLMHRtVk04dEdXeU1pTFlYY0d1NUZxZGpLK0Fxb1BpV1Uy?=
 =?utf-8?B?MklKMjRVRVl5TGNybEdLTFRFTkxwM2FTbDJBVjZwa0d5MmJzNTlNVk5uM3lH?=
 =?utf-8?B?QlNnSmpCUXRLcVVIcjVRbmkraWJzVVJSN3BZSDluVzh4blZLWTE0akMrcFBi?=
 =?utf-8?B?akJOcTdRZWhWVDh4VDNYZWxFK0lqbzRnVnFCRldmQi81T0s5YjRJVWV2cVpj?=
 =?utf-8?B?WWVEL05McitCRFc3ZmRnUW5yZDhhSHhXcEVzMCtqRXpTZzdkdGc3a21MZDZs?=
 =?utf-8?B?NVFkQnErWGpzN2p4STJwQlJpdWtNcHh2YjgrU01ONWgrVHhBd2pybTF1Snkz?=
 =?utf-8?B?azVrUlVybTB5dFU5dmFYSEkxWW9rU1VZNWdNSHVvRTdHdXAyR0E3Vm1sM1J5?=
 =?utf-8?B?ODBXVk1YZzk0NWVwSjhLUWRMMG5tUEw5RSs3SWJiWVNEYTZiRjRPamFCVk1j?=
 =?utf-8?B?YnRiMzNzcUpOdkJzYko0QXB1TmJTSWpQODRRYlFWY2RJQ010ZFZqdjJ5YkVH?=
 =?utf-8?B?OHJ4bXRTYzVjWkY3R2t1cjhtRTlMdGFzY0hLNDI1b0E2V1FHWmt3V05zVGtN?=
 =?utf-8?B?QVYzNUZsZmwyTkZKSDNjNmJXMS8zM0NWdFRsNlFGVjRXSzJPMzVrdkhEY1lL?=
 =?utf-8?B?bGpHUUFPbEVFR081K08wVW4weXNjNlJZbmc0QVNodnpHQnB6SS8zWmExcWw4?=
 =?utf-8?B?ek9RMWQ5K2hOVjcwV0hMTjVnM3FYZWJxTkQ0SDdrWTBzUTAyaTEydVNVY0lF?=
 =?utf-8?B?U0FpaUZaNHlCUlBqWUt5U0xKTXQrRmlyTURxS3lGSU85REIrQmFFSElPOWtG?=
 =?utf-8?B?dTZjYm1paDJqOCt5YWNCeHo3ZFhLeEk0ZUxPSDhZOTdVaWJSZnFEeTI5eW95?=
 =?utf-8?B?ZHREakN2c1k5aFVmSUhrZDErRE1jU3NLTTVCY2h4WS9PRGl3bnNIeGxWQm9L?=
 =?utf-8?B?VkNJZ1VlaytqVGVLUjJsRVlpOWJRVVhvdndieFM4L2EvcFhiQk1OVGhqSEkv?=
 =?utf-8?B?ZkNqQ01KOWhxSmdmRGxMcDBudS9LU3A0NnNyRUFiYWpwT001UTJNRXhMak1i?=
 =?utf-8?B?VDdkU0NDZk0wL1V0c0tIMTRlMnZJK3dHYVQ0cExaSTBFTGZWeHdoNmlVT3Jy?=
 =?utf-8?B?RjN1d2ZkWHMya21XVnM5RTFNdC84ZStxMmRKZWNQYlFpcUloTXhHa25DUGZn?=
 =?utf-8?B?MmNmT0daeUQrTzBnVmxEL1diMHlKeWFZNFVucnBCNTdodVdNYWI3dWFzUDdO?=
 =?utf-8?B?NmpUNFNYUy9qSEZaUEhPUGNkdzVkM2tJQ25mL0VsOEVXeEZpaEd2V09JbTN2?=
 =?utf-8?B?RjRQUll3L1lNaFpxYmNkS3BBZmpONmh2ZkdFUGhGcWQzSlM3RVlOVHpUNTV3?=
 =?utf-8?B?bGF1WkZxMUdROG9oM3BVQnBjYngvWmtjeGZSQ0ZrYTQ0TlV4UmY1RHJzQnh5?=
 =?utf-8?B?SGhYQ2lSZVhrSEFCVTN1UnpybXB5UFdCK2VGN0dIekNTZE1YVmorUCt0UmRZ?=
 =?utf-8?B?bGQxUElBMmZQb1U0Y1M1NjJwT1BhdTg3c0F2SllibjhaZTUxQW9Ia3Z3WWxR?=
 =?utf-8?B?b0xvWVkyUzFPM0txcTZ5TnFveFVsU2ZYYWNrbkNlNFNiM2dMa010UDV4MlVP?=
 =?utf-8?B?ZFprSWU3eUNFT2E3d1hQQ2tIdUI5TmpaeVo5Nkd3VjY4UDhpVVlxNDlpSVB6?=
 =?utf-8?B?S05raEkyUWFUWFp4c0tMUVZ6d0tPSGkzbE00dEIwaUdTTzUyeW5YbHlKNEJZ?=
 =?utf-8?B?dFZDT0Yrd1RXZkNsMGdFMXpYNHBjVjh2MTNpcUxsaE1EYWdhQ0N2M3NPVkht?=
 =?utf-8?B?d0hUNmJEVUt3aGpxdFU1TGNLK0I0YmFmTXhSb3UxRG5rTWg4NUFKZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 264d5819-43c6-4656-c31b-08df29150be9
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:48.1557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PoC1lxKS3IDkh5kjB+reHTJiPv3ktilhVTOaHuDeldoi5VWbC0UyhIGWPnA4AeUL/sS6+4p5gl653++JKZ8OyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

Enable the UFS host controller on the S32N79 RDB and configure it for
two lanes per direction.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
index 1feccd61258e..38c5699e6d54 100644
--- a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
@@ -63,6 +63,11 @@ &uart7 {
 	status = "okay";
 };
 
+&ufshc {
+	lanes-per-direction = <2>;
+	status = "okay";
+};
+
 &usdhc0 {
 	disable-wp;
 	no-sdio;
-- 
2.43.0

