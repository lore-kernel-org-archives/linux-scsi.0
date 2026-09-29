Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010045.outbound.protection.outlook.com [52.101.69.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E42246F4B8;
	Tue, 29 Sep 2026 10:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676708; cv=fail; b=XUXTyVQt8lJlZshysfsZqgiQY54dolbkR3mdmFsw19RCJaiPLR3G+QqEugh3tmPH8okxC7WOZjco5raNjVXRLa6z7OE6sGB8mL7qJ2rGPyHeFNopBxcZG/IibN/xRnd1W19tKUk60NAjIhIJar8z4VutbKo2eUtVrNO40TS6YwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676708; c=relaxed/simple;
	bh=4xkBl3OG8MRo6BkfecIQ4TfHdFzHjKdQZlBCV4k1foc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fpBkKGAHiNA8XB/gbsJGC3bXqN0aEH88+FICuHVdssuPiJ6b4k/XliAVjXFDEbpLx7LUNoLjdlkIhqfrv2XcBQ3KLLT0Tmg0cmds21VfUCtzMHERyzoOMNUpYHZ19HU/3RBbTLzDcdij0zAlQjdafPXMFXTBQQDrwWYfBoUHPnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=YWndpzm/; arc=fail smtp.client-ip=52.101.69.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="YWndpzm/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZsL4yWg6trvySHWquJ6GpsKbCUdsE79I6GVQ5CM+fMPcMfIeR6CcuK3P7Fb1AYwhHElOdDVVSKxaCruQREiLu4DGqkvsOov4oXtxF94M2Y98Dy5f1j7RfLVNYH6yQdtaVeWrLUhg/XIcMgGHS5gWEtA5Ta/tp1bpFPyXO4S4lANr3+4wDE6bOXfYTraM24PL0Q+DYXyqwTF7IX7GhlA5SeDV9oQ7M6WsNiR0k/jjPzDwG49iVO6W8W75x1En84/tOx1Hk9o02KOf6m3P5ZP/e6rC6GaKlARM1HsgdGptDpV9MGBhqpS20KV5mxR7lt7WxwO9vRBc5QJVsGmuAwHRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqxCE2d5GztTR3HjBlRXysS6u8eaq1wh4DF+uFgkQhQ=;
 b=E4hN3EtpDyHKzG2v/600MsWHGKZWArZKFrK3DVwXwb6snwaAwyf50beAIkKoC5Pgx+xCfLP8b7jUJ+/fUXY/voGlrIUJRDNTiiAq8V4qfYDMxhZioBXeerGTyO5gKNVdlN4gweDbug/XNfKK9X518CGNPpwf6BCgZHE+yhf5j7ix6kaOv9xTQddfTmv8sZHnf6kbrgSks9Gc7d1iMPBOtwL3rtjJ5fsNFap9U8g/DaGViYQYgSjT/UWeBDeEhh+yR+Xt1xTYfLMdvZ1Ukvqb5UvyVwgMz9YMkFmyH0p7yl9833OORKlc98n0Nb9HJuUhEtP8+T5cltL1wyGC4tDuNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqxCE2d5GztTR3HjBlRXysS6u8eaq1wh4DF+uFgkQhQ=;
 b=YWndpzm/RAdxGSal0IAFQD0dXr9IxPyOSOqh/hpvckRoFbkg5xmNSKpR6kxvfA8QxRi7I4iA+vd6GrPaHImmmjeeRNHs2boXKmQiRzHc6Hi/JkzB4xt/QYjWJQ/tiCsGPpbyBdV7EgIZxxC82uj/nn+D5ti0WV8+L6G3cJtnrQOkkvterLLejsMFIfgvYokWrcc/KcTDRddXG5oajkBiDTXXrQVmYTBo5iq89H4HeTJjpiHzyN1M2xaSzq1Tk/EvgGIriMCd0lo7ZhZ3bdXLCEl7CKx+LPxIqru/A63rGEM3Hn8IhProMr5PDSZDPDIX4fNWd85OrBDPP/2hHKjvIQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:19 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:19 +0000
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
Subject: [PATCH v7 10/12] arm64: dts: freescale: s32n79: Add UFS host controller
Date: Tue, 29 Sep 2026 12:09:44 +0200
Message-ID: <20260929100946.693962-11-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P251CA0007.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::11) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 9ad3aeb2-7d43-4be4-6189-08df1e11ddb5
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 AlgPp4nVdw2RzENeJf2HLhujOsM0kD0aMJa4JqHSd0AdCe0/Iak35JAKkrjTphjBztVPIytjJ2gkInJLGtQe56Okn8zlfZ/UxJVLUblEmtjPBUh75+Oj07rk5iyhJTeRyJQ2wQVBrisEEfzh5gu60f99yFktGQRFUk2cbh2JQ8d39D5nuJ3cX49ZgqSmXfDr/DryAjOdezHwkBLP3cGRx3lcDvr6swQW0sllRvQSM2jQWcPBDOynBjGpdXcBRpZBePmtsdEm8bmqvK5+0lfKLHuNRYib25gNsO9QCtevtZxAeqVbAS7GniHMlYtjbiPgXxLIL+8hy7STayBZDPfWHD7yVmHrWJV1Awpru8nd1i0uhmp4oMca6uz4fJrJPhQuMv+V8I53/Vf7f6ZNaPfa9wiDGKJDn8F/gN8p9gxMFtt6g2MGUqJwtHW/fahYRzkYENNNCLXqacDwR6MQx3OEDlL8R3WHgD38zvOiHYtS+V6e1UAtYs9BfKHwdqLexjC3yZPWuGKI+/V4Mm/kXc1/e5Ki4EEj96yi/LO0xG+2gWDoijzhC8duKwUiq0+vkD6/h81dQQeu+FLfApdTxMrC1C/kK5vv1YrvXaK8+Qd0vVgt6c1q+y1vh8erJ4JDQzFrKL2x0mB8SMR11tQg3Oz6nTopkWhHQoh4/6QPp6zz93uhtNkdtC3iBgJTal2Y3IeuEDoZZAv3mONSOYi1DjvFTw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?aC9IbTR5ZVV6S2dwSWlyUzVDVVIvK0Izd2dFQzVreHVvL0tFYXR4UTJ3dTQv?=
 =?utf-8?B?YVdEZEZUblR3dXJiQWhKcnBWM2NVNU14L0R4K0VySGNoS3g2eFBpaTdhc1RU?=
 =?utf-8?B?U1IxSC9ZVlpqUHU2ZkhUaHRyb3VXRzRIdkhSc1hOVVQzY2EvdGl4N3IyWkVt?=
 =?utf-8?B?YjlCMmxZRkdYUmIyQ1pYZnd6S0xXZ3Qvc2NZSTZQZzIzSGtWWk5idGNlKzlX?=
 =?utf-8?B?aUxSV2VXRGpaVGhNYWcvck5QRXRleUJxcG1obXpLTlVXK1pnd2JrbmR3YjBj?=
 =?utf-8?B?bk16elplNWhBbnlleHphS1Y0WSsrNWk1cmxOR0dQenpPVDFGeFVrdDFPRGth?=
 =?utf-8?B?Z3BnRW9uNTBZTnp4RjRJOGpnditsVEFKT004L2lIYkhwVjJPWGd2bi8wTUhJ?=
 =?utf-8?B?QXNlOGNGL1VQUkFzeVFEU29LU1VKWVdvYmNPZFRmNEFhcmFkSTAwYW5SKzNG?=
 =?utf-8?B?ajZoblZpdkt0Ny9kMU9jMGRCT1drb0UvdERIaTlWYUxVOEFpVHBwcTRkSVZl?=
 =?utf-8?B?K010TGErV0Y4MENVc3ZGRTdSTFlvREVxamVIVDVVdjR3VFNhODBsN3RBWUNp?=
 =?utf-8?B?ei8xZlJCY21hdHdxcFdSOGRVRkFxS0tNSGFWWnJ5OHU4SWFsWk5yNExhbTE5?=
 =?utf-8?B?Tit6d2llSUdFM05DQnVQelRmZjVyWUIxWTZQRTVVc3JlU2FQQU1BVW4veG9S?=
 =?utf-8?B?N3d5TWxPb0U1dnBOek5VQzdtZnJub1l6d2gxdWthV015TWR4cGtmeFZGUzd3?=
 =?utf-8?B?ZzlHVVk3Rk51ZXJLQ3NBNkh4WG1Fb29DdzBGV29qOWNyZzF4RU9aR0dqMTh5?=
 =?utf-8?B?K0FoeU53TGtJcnVZZWtPMTg1QXRXa1FxODRtWWdNNld4RXA1MFZNZUl2YWxI?=
 =?utf-8?B?TEY0WEFDSTVxQk1mUTF5Uk4zMXJYbk5LZjR0bDU2Wmc5WHMxR01CZTJMOFd3?=
 =?utf-8?B?aUhheFBweUdsdGpRQllEaVBLak1sUCtjRjFLb0RUL3M2RndvS2laZitKcFBp?=
 =?utf-8?B?QlhSWElQVm9MOHdNTno2QWx5STBNb3VaaE5JenhrUjU5Yk9SRzRRQW5UZUFU?=
 =?utf-8?B?WmZrdDdURk9XRlJvN0daeC9iQTcraHJIb2JIUTZhSFBTRVczNFpTQnNwa1Y0?=
 =?utf-8?B?VTBuTi9oUmVxZGhQbmJtbTF5aThHb2kyb0h3TVZ1Zm5pb3oxeVpLYmdHNnJx?=
 =?utf-8?B?OHVka1h4bFByOXIwSFJEdWdpYW9McTJhN2JSWmQ2bFN1VWlNWUNBWjRTZ0tJ?=
 =?utf-8?B?U3BaaldCa29RaStRN3h5ZkxwZHdETFhjeUF4dGJjZmJ6cFlOWTBLbmhRenJN?=
 =?utf-8?B?WmIwc2F3b3F5UUZ0NDFjNUQ5eHc2Q1NZK0ZIUXV5dytrcE80SGF0clc2bGlB?=
 =?utf-8?B?MDlERkNkUjQ0NGU3MHNpUUloY3NjVSt3MHUxd01xa1gvOHlmVi9JUXdlNjVZ?=
 =?utf-8?B?UVRMOGtTTVZTNlp5cThWa3lJV2JoMVFqMkQ3c2N0bkI0M1BGYzBFU3drNGNj?=
 =?utf-8?B?V2RrdXNoekphcmlmWWFTVXV0NkI3aHhTQy8rRUhYVDVKWlBId1RMNWpQLzBo?=
 =?utf-8?B?amVuTGtOeDhkRU80SmVaVFJMbzVEbTlYRlF5bHBxZHkvM2pEdi9KVlhQVnZi?=
 =?utf-8?B?aCtCMEFJTnF2WlpFdVk5ZDlhYzN0YU5jem5qTHMxY05jbC96SmJtdzIvN2Ir?=
 =?utf-8?B?K25MQjlnU0tINVZjT1RpekJUSjNObThiOCt5czdxMzFOTi9YY2EvVlpJRkZr?=
 =?utf-8?B?azdnQ0lnZDRyZnUxenVSSUs0UHcwMkZOOWRYb2ZKeVBWM2xiTGhpaGNKVnBO?=
 =?utf-8?B?T3R3NXJhUmJTdGtvNkNQNkNiL0VuOXI5bEVvdm1iZTVjZ3E5TTg3YnAyK1hr?=
 =?utf-8?B?RHpuMzhpSVROMHdXYkNielkyd2xsNm0rSjJwUmQzQitxaDNncm9UdS84WUNO?=
 =?utf-8?B?NHl0NFlVVGU2ZzMwMFdpeXMvcEFybnNLUHk5UFZxRTc2RUFoMlpuWHZHZ1c5?=
 =?utf-8?B?SGV4Q2hHOXl6Y0ZVRVB3b3VDM3FzUHg1dndaU1FuZnAzYm15NXRWOWNMS21s?=
 =?utf-8?B?NUx3eFdEYnV1MUZHTkx4QTUzb3B0WXh5aUN1ZzFGSkFlZmJoS3VkWThJbG1B?=
 =?utf-8?B?aEdBV25wK3RFYjZwdHYxTnI0N280YzliblFiVmtJd082bTRrRytmRlFFcE9R?=
 =?utf-8?B?L1puWHVwM0FzWUpJMkk2cS96YUk0Y1lJMG0zT2FmWUNQeXV5cUMrUzlJWnFn?=
 =?utf-8?B?OE90OGt3WDBoaTRIZUpuWmdmTFBhQ3pSSTdVV0JubHU2TEFrdWV5VFJ5TGp4?=
 =?utf-8?B?d3loZUxadDh4Qmx1cmhpUjRHSUcwZm42R3BCeE8vcUFQeXdkOHEydz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad3aeb2-7d43-4be4-6189-08df1e11ddb5
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:19.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jwz2OHq6yTXEB9k+c12LORxWcoG8vCKf5KJZubqPFatEIubUNIHQZSp+loLMtXRUcq3qVa4kn1wMFgL27Nqs9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

Add the S32N79 UFS host controller node to the SoC dtsi.
The controller remains disabled by default and is enabled by board dts
files as needed.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79.dtsi b/arch/arm64/boot/dts/freescale/s32n79.dtsi
index 94ab58783fdc..9f64a7acc3f8 100644
--- a/arch/arm64/boot/dts/freescale/s32n79.dtsi
+++ b/arch/arm64/boot/dts/freescale/s32n79.dtsi
@@ -100,6 +100,16 @@ uart7: serial@4aa40000 {
 			status = "disabled";
 		};
 
+		ufshc: ufs@4ac80000 {
+			compatible = "nxp,s32n79-ufshc";
+			reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+			reg-names = "ufshc", "scm";
+			interrupt-parent = <&irqsteer_coss>;
+			interrupts = <211>;
+			clocks = <&clks 0x92>;
+			status = "disabled";
+		};
+
 		irqsteer_coss: interrupt-controller@4ed00000 {
 			compatible = "nxp,s32n79-irqsteer";
 			reg = <0x4ed00000 0x10000>;
-- 
2.43.0

