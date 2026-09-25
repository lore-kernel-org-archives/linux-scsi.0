Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011033.outbound.protection.outlook.com [52.101.65.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1BB4B1274;
	Fri, 25 Sep 2026 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346969; cv=fail; b=mIiJtItlTIhxgtu1OwH1dqw/YuQV8v80vdiaIvcyLQvXYxF8CrjpBFESl8W3KI7CZV5/tzMCNuvy9vOgso7OwA0zIY9ZLLPiDgbR4cUUAYCDaYkGWL2H5T/WfAwqeVy7LyMylLAaSTk72L6OXD4sk115EcWPCf5P2fcKFftEcA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346969; c=relaxed/simple;
	bh=NhgMjKx3ZG+A+CZ6GKvwxQoZVo+hFIGlJmDYNqraEWo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=c1lHmrrC9fnL5x2jxfUNYalLpHrGnJmaKt7rUA1SKR1sMEdWMtWpz1SJjjNknDk+ZZHC2SmEDO/nyNkC5pPYeoXPu/7VnVlbZCE/0vCWxkUtJgtMwJcWsHc5KhyDJj1fLOF9o7hA0kc9jyIT41lSGSw4iaoRwqDurXURPI9qifo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=SP9P7WKI; arc=fail smtp.client-ip=52.101.65.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="SP9P7WKI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEhdYbrXdQNg5W21sm1HhhV01qICF5dxkoYU1Fz8VeoDD/af+dqrcRU/fgXpCzn2LwhsL3bAf9Si53W74L9iHGim3I+GErSNly+bGwA/ub4ZF4YNyNgxCLjkN3qdh0C6V7YIr9k6Fvgp6YnQAZwi8jc9EHNiIpI9daI0XvQ5YfXUVC339bUF/GfTXHi8khwx5rm0vnkRZL2TZzytppfAvrU5s+T+qlpUZbSjEDcWbPZG1XTC/+8iNyhplBiOhRySyJ3N9WYBlzRF9EIJMsec+RFqJnQ52/jZvbdHJKFs50bi+5BOpcw1IoF8ZxueyT8BT9lZq9Pv7h8AAuNuCul34Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eq5FBgEnXTT8hMk/8GlVX3UAmt6VoObreBVDgh0vJyQ=;
 b=u+ppOPfJoPYuowd7uxGyMKXWhYt/o1m68dufgFJU70jgk7f2N/CYxFRGk5X1yirL6Np5XOtM5r13IP2mVNBufg436mkYdgCdWanfw1cbWJVK42MColOVHjC2hLurJ2wMNXioP1gtSCt2Qmt64WVbja6gR3jB9GTwBgyhaqPs4AH8O4MZaTA13pNPmJf8jIZZwWqlwDh/0uLHzDaj2AMEUHaAeEVuovx6VtYjDapuI04ULYG7temfsS9YRte4D8Ej7m7FxuoBk6/aEVi7fjbDCwD/acZbf8PrUDhCjuPpq1qIVFbpsjBuK/mPpHGUjI44mqfIbRtfOXNjcn6vTMbwMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eq5FBgEnXTT8hMk/8GlVX3UAmt6VoObreBVDgh0vJyQ=;
 b=SP9P7WKI+YqYpSC1N4DfCRBktkD/x99r9KuoS5RVrjd+6HmuFgoj7xWAjOBI5lsMrUg8F8zlLRnVZoy/dHxG1nIXVsyaR9ssK+VVrebGYRn9Jhi4XVnKvR4iwW3YCOIDeA4IzkTE24W7dT0q76IuwC6Rql/VEei/Fie+gqrsyHK4OmfmFibKD4gHsAVY9og/zRw9AhUmYHIE8TROVTtIVl0hwWhO+IYAA38QUv17S6+TlSU/JAu2tPat+ZfJ2rTRuNpaTuCrFAkZJfkrufY/yvkNijRtobIC+NomSULRendWheHl3T0oyfaCPNYSs7Vw9JfqBiBvpZHG55aRY4TlyQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7256.eurprd04.prod.outlook.com
 (2603:10a6:10:1a3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:35:45 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:35:44 +0000
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
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>
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
Subject: [PATCH v6 00/12] Add S32N79RDB UFS support
Date: Fri, 25 Sep 2026 16:35:22 +0200
Message-ID: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DBAPR04MB7256:EE_
X-MS-Office365-Filtering-Correlation-Id: 260c4d20-849c-4fbb-d27a-08df1b12484d
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|23010399003|7416014|376014|10067099003|56012099006|3023799007|6133799003|11063799006|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 Z7wHOOit3PyinnZ/XYKRwNePkUStMFH723Lvc7HF1tiEDXj2AF4WgenGHE/z5myry5Z0KkE3Cj8OW20jLAXHm7gs7DNnHt0QKQbhXJfbBLOkO/xo+BoW9uVMWIdIo4ODzhWcCBgm2Rj5ER3GLJxxN5Yq3h6i7/D56sOgjz0vbJbj10a3EMhV5ZZke8qe/VEvGKtMwTMtCYVBx3Jqug0HFq5T2NRqX4lSJ8ys3nZxCWgGPD7kwogaJ1RKmiInOL3bx29pTd9mY3dyI1dmb+IPfpiM6x0k3hobM2oCbCkKutI0lSv3y8MXdUuRBW4LFQCTv/3RjrGKrxVdNhvdMH1JpSv3eP8+aYz8Bm/OS+2wYj9jDNciIQ9WmN2g/XO/gKyBpQUFahzWgasScRBlCb+mjtHQRinP307ufosCWiXr5hv++PdDWYeELmngSV9+2KjF+fmydkB/dNdHNjaQl7HjpwCMgRU5SfOlmuXqZWN7ii9HoYHnVlAtKisfWXrZ3FebAqPHitMcHVUvRftF8/NlQWqMj0W1eXuzWtR2c92K/vNbTFC9iqgvOCdvykaEkjve6he5b7Ocz2OFl2e+r8dxt6y3qxl1caOPWuD8SyfAmKp3qn/XdVZwK4rWN7yA0lFg1KldDVq+G45Nlkc0TCLR2FBpuWAHJaPOJOZ64J8skexvB09oeqOvWXbak9rtIMRnlv0Rrj6jXCCkQblwDnmKmg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(23010399003)(7416014)(376014)(10067099003)(56012099006)(3023799007)(6133799003)(11063799006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZVZmc1U0TmtUL0tMUTA4ZUp5NjA0K2dUWmFISmdlYmsyRUcwaTNGVnR4QmtC?=
 =?utf-8?B?YXZpRGJCTXlmY1VtWlBNdyt1TFBqT1hlQVMzaXVland2dnl5TTc0L2YwYUpo?=
 =?utf-8?B?UjN2MlJRaFR4SnpLVGpRUXBVczRwMENudjFCa2NzUGlINUFFalhkQ0ludFJK?=
 =?utf-8?B?aXFBOUNhNU8vMmxRVDFpWlV0cWo3SkJQSDMzTXRhWXYzbjF2RGhFWU5tWGh3?=
 =?utf-8?B?cGpvWE5IekxnUXdmbmplUThRVTduSmRxbUlBM01XdVhBNFROcExnMm1XWm9Q?=
 =?utf-8?B?TkQwU0RjQTF5U1YyL0xGc21NVU11aEdxYnhUdGhvWDlXTC9NUTd0VWlxNDd1?=
 =?utf-8?B?Qjl0cVgyYy90dW51Z0FQWVlFZVVJQ2RpaU9NQkQwcGZtdllFTU1SclU0VitF?=
 =?utf-8?B?RmlqRmVUWWN4a2E1T2hVQmVaQnRQMlNCd2tiZTJWZlFhZE9GQVFvSWJtdnBC?=
 =?utf-8?B?TmxRYzRGczBFRVRZN0JhNUw1RmRYcXNUckZabFRKRFBNOFdXVU02VUNHUHp1?=
 =?utf-8?B?WFZLU0NlNDI3NVJRcTVFbFJoT1NuTCtydktlSWRkRnVCSnUwb1dCZmlJYldQ?=
 =?utf-8?B?U3RvNU5waEFBUGhxYzJITFhrVCt6MHF4Z0tZa1dYOHJCQUthdS9COHI0UTBx?=
 =?utf-8?B?bzl6VUpsbU1HMkRUbTk0cTArdFl1TmtzaENMMmRNWkJsQStVU1FnbVJoREVq?=
 =?utf-8?B?NmlBZUVnNEREQU9kYUFJT2RHWGxyUkRIUzVRbDU5SjFvTnRuR1JxQVRlbEZi?=
 =?utf-8?B?am52S2ViZWxtb2xxWVI0WmFHeHhEbCtjUTZtMnE3amN1UlNiV0NrSjI4VHBW?=
 =?utf-8?B?K3JZdy82eXVuZGJzTk00TEVOMGdZM0V3eWRwSjMyUTFHZE5MNXVFR0xkR2Zh?=
 =?utf-8?B?T2FHb2pwcmVLWUVCM3lmSzJJYmppeVFjdmRtNWE0NmtZdjFQbkRSTHRuMndo?=
 =?utf-8?B?OWEyS3poR2pLc0M3d2FGZlFoZGxIV0E3VUQvdGh3RW5GRHRCYlVOYXoyTXhD?=
 =?utf-8?B?Znh5WnBNa0dMNnlYNXh0L1E2Slg2amJaZnlUZVZXTmk5bWlFSUhUWkFYaCtN?=
 =?utf-8?B?Tm0zTm9JNStCaFpSVjIrWGtjR2xPako1N2h1OS84RGN2SWVCZDhLSE5TYklT?=
 =?utf-8?B?S0lpL1hGcFBSZDNveWZjb1ZBM2pUR0FGU1pUY2RXNm04bUo3TzBPOUlDaktX?=
 =?utf-8?B?dWE5RDhWY1RiUE9tNUVRMXdRUmpyL2x0R1hkZlBHa0c4MEI0cURNN2lDM25D?=
 =?utf-8?B?MlZPcVR5bis2TWQwSXZhOVFqN3hUdXFjVFg3UU1pa2ZTeERHbHNnNnJ4N1BI?=
 =?utf-8?B?ZVNzZXVCL043QWVLOVVpVmJEU0xZWFhBc21QL3BoQVorNzdJVkRzbGhJYVFw?=
 =?utf-8?B?L0FoODhPQ2xrYU9UQ2V0NHhrVzMxNWtVc09CTGwranJwN284VWNmVExnQ3FC?=
 =?utf-8?B?RStrZU5BaWpuWHIzU0liZ251MGlQcTVyUHBKOWMxQlROdVdTMHc2K0E0eHlR?=
 =?utf-8?B?d3VDVU5UemMwOGxUTlJvNEt0OGhkWXpsMUdpMWJCUUd5aWZBNS9FNTI4dUla?=
 =?utf-8?B?eXNEMEgxSjQ1cEJtTXdSNzRxNGd3OEZXM1JlS0xFRk9EVlYwWXBWSEJvRndX?=
 =?utf-8?B?azB6UVpzVjZIMkxTMVcrMmZqeGdCZE10NjI5UVNaMWR0MGxyRDJkYVkwVktu?=
 =?utf-8?B?S3lOWnRyRjNkbW0zMS9jMis5RUU2SG1hejh2cnFyTEMwOC9uRlY2akNseld3?=
 =?utf-8?B?dC9vK29ZMERFOEpiVnFkWSt5L0dEQk5IUXlNeXdoSlZ6cExGNTNFRVNjWGpJ?=
 =?utf-8?B?YnoveWkyNHczdEg1cjBjeXo0S1RQWXRpRjlPemRWa0M1Mm5WeVZzS1FmL1Va?=
 =?utf-8?B?T2haZjlNUVBkQWNVVlZzazZrTHpnRWlETmcvSzU0UkEzajhPWFNrUktIckJC?=
 =?utf-8?B?eHpFV3BZMVc4N205bW9ZSGlVMVB4TFFEandNZVNLWDh5cGZKQUlXYVBMNmcr?=
 =?utf-8?B?aG96OGhocHI2VEg1YWJVSkNXV0ZsV25oK0s4MVAyeXZ4bTZMRkJZUnV5NTZO?=
 =?utf-8?B?VzlQK0FrL21hVFNIdnN1VXhQMzc0K3YvVFVFYjZ3VzV6LzRiSWFPUi91dnJG?=
 =?utf-8?B?MWdxckVLWHRlbkUzOVdaREI5ZUxMaWZWN2VMMzM3RFBjUkUvWXR2N3BuYzFU?=
 =?utf-8?B?YkR3VUVPREFQZnU5SFBjVXVCZTdYaHNvdHpjMzJyMU5paVRtMXJmcm1Vc1RY?=
 =?utf-8?B?MVdTcEM2Qi9TckRjQWJzTFpwbWZmTXpPSjZuTFMxRkdSMUhpbVNoa0ZDUEdj?=
 =?utf-8?B?akh5ZUVXbk94Q0tjeGxPdXp5SngrR0t5QU5ZNUhNZEk5c3R5aStPUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 260c4d20-849c-4fbb-d27a-08df1b12484d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:35:44.8121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URY9gZvIIxHwhcAv+KEj7w/yXC5cznPK3M4WdrGayfpDhqOlOPGhq7rFDFqxoWRFyr5mmaH4gVSgAbrOxtH1bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7256

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

Changes in v6:

scsi: ufs: dwc: Return a negative error if the link is down:
- Translate a positive UIC command result from ufshcd_dme_get() into -EIO.
- Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- Added Reviewed-by: Frank Li.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Added Reviewed-by: Frank Li.

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
 drivers/ufs/host/ufshcd-dwc.c                 |  86 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   3 +
 include/ufs/unipro.h                          |  22 +
 18 files changed, 851 insertions(+), 196 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

