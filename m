Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3DE3815E6;
	Tue, 22 Sep 2026 07:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062406; cv=fail; b=i9pBVI51PEGwJ3hKKxvxbT09VgepfppRkvuO+znYCPXbWTOVhuU4VZ0tECFrVuX53mIbU2Baq3aylWrzcx5ITEYy46oS/kEgXifmVf84UCXI97WzL/mAHOOevfHNRMUjKXeF/KOSKLZH3aCtEKg83QCIaz3dXRg3fYF8B/KBiVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062406; c=relaxed/simple;
	bh=LqZgKGVdikM01Bjk+y+eUcjKg3NgTidWu2CI9CfMQBA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Kpy5TVpnRivPXsughVgaFUa+mgEunXkLJ7AfxGYwpaepuNnscZWmRiCf7zwkVu4m0/R6iEVTo6d5clBgreDm1JZKIe7onODKtoH4oYJVjHeE4LbjpbBOeQdvvW6glbO7BhqgmffRvlOiLLBnJgC5lBfySOvz+VzjTtKBrdC0904=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=uUhp8zWL; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="uUhp8zWL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lwgN8VCvW/svSJl5Qq2hQvRn+ujWZ0Ingj/JwipyM1D0KZCb/szCJrdSyrwA8IUFAK2CEZ+YPd3mP43S8QRHStu3EXy7uLuMnrV9FWgWqDyjj050W/7j5F5rUP3fUUjjxH6dEPx6UPhBUdhedokmwf82skyB2MKSG000jem+aInr6MXri5Q8TX3M8iNilAAUDVo78OZIsEpZIUogtwRHLTfo53V5tLW3xYxLu+IHh6r2rItR6nBEJ5g4PalerZIz5io6NvDgnKssgIkNfRfJzLIJr2TmwJVl89TD740lSYB8C611rZRfDz7AqhPpou2/iTxkOlw1CC4j4Hdu0CYb4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSmiP75jZx2fuT3dPiYa37xcVpilBcTZMFGkszeH+2E=;
 b=oiV4FZlUtGQ75OMdzgnMqfJuwo7lDPw4/YcZNcnUeoLrv/uNVQ/rswWHpVZG50PMYW6qG4JQGI18B49jgL3FblYFkrvaRva2IiYp51Jheya+L2E2WEtktHOXN9k/TAXxiApZzrVUrdII61/WNDpVHwqx8qcfp2R+9JGACImfU8OmD8IDR31guSmCnVQ5+3FiH7w5ZCAaFOcLB+u4Egpxe18ey77CnI/6XVEDCYHW52l2/yngk8qpFV1SxkXN334FBdY5SFgPoaQrbqbQd5OPUBZz7ndPn8WgoPtZc6VHh21YrAg6LPE3B9Xz6fnOyK/lHeQ1zX0SZZoc7Lqxz15xuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSmiP75jZx2fuT3dPiYa37xcVpilBcTZMFGkszeH+2E=;
 b=uUhp8zWL5nihhSX0VxClbPICty1e6yuBRDeLykOvn0qEvZASlZgvTcLIDW3c/Zyb6KLaOca6Fr80uGQ77UJCZAUnP8vavp6hESMhcwle3qBz27uSz+gcMwzdE3h3qnpcfuzL/6YWhNK574Z2vpWiGemeN+Qg3mga+bm3+9B7MCbuENLr0ra6MXh86avzRGnlH0FRD1ufGjqXvAp2c56qnRmqZMDNUj5saYtYfLsg1ZsFg4XnmpYVQ/f21QzGz+zrPpm/mD9fsMiMBBENBPpVIF2Cqif0HFcHxixz2HkyD16S/f3o93QpRpp5kZ8y7ZRICWJfoxrVDZJf9JB+/No9RA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:13 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:12 +0000
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
Subject: [PATCH v5 00/12] Add S32N79RDB UFS support
Date: Tue, 22 Sep 2026 09:29:57 +0200
Message-ID: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0030.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::40) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 503c10f2-da89-4e5a-58d2-08df187bc209
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|3023799007|6133799003|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
 Iv3d1+aenTPenSNd5w0sg4hCAOs/DQdRUZdYvEOWZTUUffn8PtoIjoKhMiFd31Ewj+rpw1Cww6p4l3zDc4RlNh3AT0Gu7G2uf4Z8Gc0S/4DSDG8zUYhdNibO0+UItT19NhQ8w4bfHY41ebvewxCcaLFsLEvFZdJZvh5k+XH88xdo3qtue5lj5beC4lYV0asAWug5ifdQAJx6lcWwOUGq8rgGgS1N8G3yocxWkAhB7b40orIITh9MwWDLJ5WAZCHqtkYfo3Rfl6e+Nhmhpw2huXMpLD9V8C3SUotvtKywtUdARLrhr3mrwiLSt+AbhDQ/QiamLP5Z5YC+/C2wGsOZZBBhW5hg/q7WHEIzEvbG/CCoojqt4lvzl/aRSYwnBJF/MMn60pAV/ArjWxdnB0TCL1oD0V7odH7Ckmq7HvC0OxoFohLVorQD5mp1t0JigdyWz6gDzWTPknluhQ7dsqdtEigHuz9TjTL7n2XQreTBSr969pqQFsnR4niTmwKIkC60Vj1atMmwVnQmXpMrYtgbpxV35sLZMmpndUNWt9JBZ7/gv4+t/YlNopQXca9zJXQIQOfxMuh9HMCt87HBT7f2Ps1Gg/ZjSl9DtMjpngmmHfYBIQN5AhxTXeSn/6OQjWQpkRN6bwZGkx7jfgDXom7mpKvAfyDhzAi5e2gIT8rz3KpkPs7hwS/Om/zGvxRCvB95/d/TSBeyhATGvwelAq+8YA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(3023799007)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bnFPZlRmdEh4dFZWZVJiNW1Wd2JSNUFHb2NXN1A0S3NoU0dLY0VGMnE4S2cz?=
 =?utf-8?B?aUdtaWZzN1Q2bWwremR3YXppZnYzeFlDOE50Y09adGI0aHlPL2xJQ2U4cGlZ?=
 =?utf-8?B?byswOTRWK2JqWXo4Qm9EZUhsNFdCYW1kQU9HMXVzOTVlVC9jTUFxaTljZmM1?=
 =?utf-8?B?ZnZITHVLQlpST0RFNU5QOUxQcVRLeTU2andKR0w0aUFQUWZlYjRQQi9xUVNZ?=
 =?utf-8?B?OEVLcVZoTGoyVjBEVittam9sREQ4UCtrbW53WWhFUTBUVXkrRWczbndtWW9u?=
 =?utf-8?B?UmF4YWNpNW03aWMzdkE3YmNGc0pSQVVkNXAxT2pncDJsNlUwRTA0ZjVNRWpU?=
 =?utf-8?B?RWtoKzNodWRaWmRYd3Z2WEVBQ0g0bWJzYzdCM2hRRkJvQnZOWnNUSFc1Q01W?=
 =?utf-8?B?RExsZEUxN3VCYnh0Mk5Xa1plb1NhdnEwRTVYSDY4aFY3OW0wWGJwT3hxTHRS?=
 =?utf-8?B?QjJ6SHhibDV6dnkwMTNISVFHMUw1dHlwRDZJdXlVMEpETnNpNWVObHUrMDMv?=
 =?utf-8?B?MDYrS1NhOXRTZytwVCtqK1RqNFlzdmNMaHlBYzhGc1crRkkyT3FlWDVkeUkv?=
 =?utf-8?B?WDJXK1N2T0hIQUtyaklvOGhoMzFWc3FPSU84TzNxU2NSYXFHTzV5RGhVckJr?=
 =?utf-8?B?NmtReXRFRnE2SVFNczl5WlllS2hOUUdHS1pCNmZPeEY1YWk5WlV1UDVRL3pO?=
 =?utf-8?B?MHRSYW9wQ1dkeUFrVGNpWWxBZ0FNbXZReUtwcXA3TGh1TjdXQU5WZThRdzhi?=
 =?utf-8?B?QU8vOGtjRmE5UUZTV3hqME81U3V1aitqWHRRM293elBKZmxYNG16SFlXbXB1?=
 =?utf-8?B?NFpDMjBOUFZudE1heUtQSHYxTXN1cWMxeVJjRHNJTHdsOTZVYTF1NzNMRlZV?=
 =?utf-8?B?QjZtcDV4ZzExYnBUQXdjNFgwL1pxUFc1RUZ6UVZXenVCa0dXTERSTTF3ckNk?=
 =?utf-8?B?R29mRVNvcXM3N1ZQbUFkUFBOWHl5b3Fmb2FjVE5EbkZVVkpWTHhjbk5YNUUy?=
 =?utf-8?B?U3YrMjRNVm10TmRhUEIxeEo2ZFFyRUlVZFZtZnRWWW4yVWt3NGpKamdNOCs4?=
 =?utf-8?B?NUE2bTVwZHlXaGZIdTRBUjQwcjFTc1JQWHdJT3B0eGRGM3IvR0lpbDZaZWRK?=
 =?utf-8?B?RE9KSVpBaXY0aGhmbVd2MU1xR2xEeU92YjVVVWVGM3hremtpNG1RZ1ZNeEhZ?=
 =?utf-8?B?OUlQU3RFc1F4M0RnRnhwOWh0dGM3b2JLYXhlYlFsV05SVlVwc2swRVR0Mlpx?=
 =?utf-8?B?K3dZbDlNVXYyU0ltZDY0RGpnS21qMjRiK2pRNHN4N0JHT1ExNCtlWm0zN2tr?=
 =?utf-8?B?YTU4TyttVkhhUHNPd2VzNnV1VmJWMExnRDBuWXJCRHZsbE1iYTR6em1NdXBM?=
 =?utf-8?B?U1FURjFXTm54czN2QVFaOXphNlhYRkVWWmltK28wby8zZTVja2ZVMDJEWUJl?=
 =?utf-8?B?WmxIZER4Rkl5bFFITmNjdm9YSzQxb0hKK2FpNHRlbUNPUlNCQ1FxeG5CTVcv?=
 =?utf-8?B?bmh4WGl6N2FOTFpVZk9qdGt4TVJwYlVFWVQ5bS9oT0czVmtadHZrQTVheGNy?=
 =?utf-8?B?Um03VzEvTUo4eklNcFJHVzN4dGN0amJTSGFIbG9kS0V5RngyWXhPWHNlbXVh?=
 =?utf-8?B?dmVsc3RSSytJeGNvbEhUSFY4eEVuQ2F4Y3lyT1d0bFpwVUoxdENlK0JsNE9j?=
 =?utf-8?B?WjJ1bG04ZFdzS1RTYmUvbC9pdlUwdEwxdFJNd3hMZDZzSnZzcUhZNXgxbklT?=
 =?utf-8?B?ZG5sRm1iK0JZYkpSM0lKR0RQMlNwOWpkQmVjeWZJSGRYZFk1clByR1FTdGYx?=
 =?utf-8?B?S1lBY3NISzZqWmkwYUlLdHdqc3dTYXU5UUc0ZXNHc0M3Q2JXZVFBTnRMUjF1?=
 =?utf-8?B?R3ZlWVNFYStubG9xRVdOZ3pITGkxRHNBSnA3YVRKRXRjczlqMlBBbW9pWkVn?=
 =?utf-8?B?MXMvOWlXWXZySjlHWGcvSFNxOXF2K3BEbEZpWUpPd0kySkpMVzZRSW52bURO?=
 =?utf-8?B?S3JWdGM4M0dpeFlkSUVTa0xqRWQ0c2JpdnlXZ0RPUkhxQllEWmc4anNtRUx1?=
 =?utf-8?B?QitQUkRXTXFEd1ppQUR0T01TV1YvSHJmOWszMUtlNHF1NkZUTEEvaEF0dGUv?=
 =?utf-8?B?SE45K21IeEtZMnlBUzZ1b05mWjgzMy9ZZ3llSlh3U1pReFJET3pENkt1KzJW?=
 =?utf-8?B?Sm9rdlFsaENDbW9IZ3hSZXNNaVRGbmNXUE5ORnI0MTlVZUdpazNRZ0wzeUsv?=
 =?utf-8?B?R3F1RUJWUkIvUlEwMHpqYUlKL0pRT0YvelAyTEdnQTBhVk1jWklCU3NuS1d1?=
 =?utf-8?B?UHN6ekhvVmJBcGlieVNkeW1xZDJ4WjNxSWNsb09LZHAwamtkMCtOUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503c10f2-da89-4e5a-58d2-08df187bc209
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:12.7728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqrA65XrmARIuUcExsuj1HYE7CFE9lh+URzLAGTdPD+sGaURFqtOapLBbEvytUsw2lbLWil8lOQVAaZr7ZYT2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

This series adds support for the UFS host controller found on the NXP S32N79
platform. The controller is based on the Synopsys DesignWare (DWC) UFS host
architecture and requires S32N79-specific M-PHY initialization/calibration
sequence. It is compliant with JESD-223D "Universal Flash Storage Host
Controller Interface" v3.0, and supports up to HS-Gear 4 speed grade. It is
compatible with UFS 2.1, 3.0 and 3.1 devices. The MIPI UniPro is compliant with
"MIPI Alliance Specification for Unified Protocol", v1.8. The MIPI M-PHY is
compliant to version 4.1.

In order to keep the S32N79 platform driver small and avoid duplicating common
DWC code across platform glue drivers, the series also refactors and exports a
few reusable DWC helpers. In particular, M-PHY CREG (CBCREG*) register access
helpers are moved from the existing AMD Versal2 glue driver into the common
ufshcd-dwc layer, and are then used by the platform drivers. The series also
introduces a generic Hibern8 TX-FSM polling helper so that multiple platforms
can reuse the same pre-link checks.

Device tree binding documentation for the S32N79 UFS controller is included,
along with SoC and board DTS updates to instantiate and enable the controller.

Changes in v5:

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- New patch. Split the macro reorder into its own cleanup.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Return the real poller error on timeout, not a forced -ETIMEDOUT.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.
- Removed the select: block and the clocks description.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Documented the timeout values as driver-defined bounds.
- Wrapped .prepare/.complete in pm_ptr().

arm64: dts: freescale: s32n79: Add UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.

Changes in v4:

scsi: ufs: dwc: Return a negative error if the link is down:
- New patch. ufshcd_dwc_link_is_up() now returns a negative errno on failure
  instead of a positive value.

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Refactored ufshcd_dme_check_tx_hibern8() to use read_poll_timeout().

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added Reviewed-by: Frank Li.

Changes in v3:

ufs: host: Add common Hibern8 TX FSM polling helper:
- Use -EAGAIN while polling and only normalize to -ETIMEDOUT on timeout, so
  real attribute-read errors are returned instead of masked.
- Drop the stray delay.h include in ufshcd-pltfrm.c; the helper lives in
  ufshcd.c.
- Drop the now-redundant dev_err() after the check in the HiSilicon driver.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Use devm_clk_get_enabled() to enable the core reference clock.
- Rename the family-level identifiers from the s32n_ prefix to s32n7_
  (structs and functions), keeping the s32n79_ prefix only for the
  chip-specific data.

Changes in v2:

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h:
- Improved the enum comments. They now cite the MIPI M-PHY v6.0 tables.

ufs: unipro: Add TX/RX FSM state attributes:
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Moved the helper into the UFS core (ufshcd.c).
- Split out an inner per-lane poller, ufshcd_poll_tx_hibern8_lanes().
- Expanded the commit message to document the -ETIMEDOUT normalization done
  when converting the qcom/hisi checks to the helper. No code behaviour change.

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Made the DME attribute arrays const. They are now initialized inline instead
  of by later field assignments.

scsi: ufs: dwc: Export common clock divider and link status helpers:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Renamed the patch subject and simplified the commit message.
- Renamed the binding file to nxp,s32n79-ufshc.yaml so it matches the
  nxp,s32n79-ufshc compatible string.
- Removed the nxp,mphy-boot-mode property.
- Made reg-names and clocks required.
- Removed the conditional if/then/else schema.
- Removed clock-names.
- Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
- Updated the example clocks to <&clks 0x92>.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Removed the nxp,mphy-boot-mode handling and the mphy_boot_mode enum. The
  M-PHY firmware always runs from ROM now.
- Added a struct s32n_soc_data for SoC match data.
- Moved the calibration writes out to static const tables.
- Renamed struct phy_reg_cfg to s32n_phy_reg.
- Moved the rate-select sequence out of link_startup_post_change() into a new
  pwr_change_notify() pre-change path.
- Used devm_clk_get(dev, NULL) and dropped the redundant core_clk NULL check.
- Switched to *_PM_OPS() macros and pm_ptr() for the PM ops.
- Clarified the Hibern8 poll timeout comment.
- Enabled Auto-Hibern8 instead of setting UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8.
- Reworked and improved the M-PHY initialization sequence.

arm64: dts: freescale: s32n79: Add UFS host controller:
- Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
- Removed clock-names.

arm64: dts: freescale: s32n79-rdb: Enable UFS:
- Removed the nxp,mphy-boot-mode property.

Larisa Grigore (12):
  scsi: ufs: dwc: Return a negative error if the link is down
  ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
  ufs: unipro: Add TX/RX FSM state attributes
  ufs: host: Add common Hibern8 TX FSM polling helper
  scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
  scsi: ufs: dwc: Export common clock divider and link status helpers
  dt-bindings: ufs: Add NXP S32N79 UFS host controller
  scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
  scsi: ufs: Add NXP S32N79 UFS host controller driver
  arm64: dts: freescale: s32n79: Add UFS host controller
  arm64: dts: freescale: s32n79-rdb: Enable UFS
  MAINTAINERS: Add NXP S32N7 UFS host controller entry

 .../bindings/ufs/nxp,s32n79-ufshc.yaml        |  49 ++
 MAINTAINERS                                   |   8 +
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts  |   5 +
 arch/arm64/boot/dts/freescale/s32n79.dtsi     |  10 +
 drivers/ufs/core/ufshcd.c                     |  73 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  89 +--
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 546 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  84 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   3 +
 include/ufs/unipro.h                          |  22 +
 18 files changed, 850 insertions(+), 195 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

