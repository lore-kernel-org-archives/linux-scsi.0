Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DF54A7CA3;
	Thu, 17 Sep 2026 09:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636569; cv=fail; b=QpBNbyTIhG1JugyG4dqvEeIS/WqcXww4VhAIOVkdOkfHTGQXg085tJ8YdFco8cCzTWApk9zfJjz3T7RktKofYGeSX+azJyS3uvKBg6hN39SeWf0UtxS53fCV6TfDAdLZjACHzEWDTgdIQf+Pzst3qtqCXFGR2m/kEJBwxk97jS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636569; c=relaxed/simple;
	bh=bhprEP6AIz0E4U5Qm1LnIP01hroASBiJGVq0h+D8ZnM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PccR7MxCjKwo7zcuHXMxQrm+GZ8aQ4eqMzBA5BrxQFfC7cYO4XAdhIEuDqdVG/xGaem1IJs6LlHGEvs05O2z3bZn6UJ43aX4YHQB9XmdooUdXQGd+xBKR0F+b9dbM14bcWq+wqPWG71WHxgfZcmxunbeZ/P6uqoXTp4nL7uqbcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=P//DFmVp; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="P//DFmVp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFVrmkeEmYFSuhOmhfWKBRpaWe1Tx7O2MLMomk0HkhXzVTkNoxFH445nBPkKHJotSYwwTd8qqJOmsAu0Z2Ral10XrKKzlELYtCtz7PPCQJ3pj8zCj+vt+iyiPxAGnoe9hy5i0aLGCAfaAoXBVEjkn+2yUjcWL70oGwvJes1vhWm4NRIA1NHZ4rLNNb2L8rCxWigg7rKCgMcCJbIHnaQMBKM2AB4Li3RErDIg8cA9SVl65ApaS5x3aiNj1XKKq6ih1YI6sQuWjj1joRXxNGzi91YWFTk9iyZ4p3ojPRj+lPiGWvGUDsTtJoCFfXg4v8GBXfy70+HeLvLXiat0Tvq2cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAoVE86yLe7GrIjb8gAQ9xEITUy98kC7775/57ieI7I=;
 b=VAfTYnn5/WqGVtqGO0dssIQCN9E61HWuni5EWBzlOe1DAIbpjG/A8VmMEG1YnFPyaSLlxAP7UGz+EibshtHUJTLMmxQkmlauouGFf1ZHtdqUQpHXyhnQAmlmYbp3GfrPwWfwSd3orR265YZ6m2Bj9ZjV/+QwUiA3bWuUDRU5iIV1FSah6yjLUsVIIl6+f6qZnfMrYyZXcIBB9u8maw/9eR/Cd6v9Fmhe5BqGcgnAthli3sp/1EW4fYwOOyJVrw+VZN0qQjC3BUsga2N9UJBvCpPLNt6bLSnt+lTzmrVYE4Lq0WkqAT4u7AR2m/uHgXorMyDQ5X2NKP62bxxcC9tF7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAoVE86yLe7GrIjb8gAQ9xEITUy98kC7775/57ieI7I=;
 b=P//DFmVpP8JhxTV1BatBIVCCM0EPh2SCtEboLhOJ8B4WWD5yXUOkAyb/QEN3ch1Y1iOBpZDhh65Y8ubJepsKBG3X5/xjSrE4MDOee8HWyi0KsLkGfQIpXAjKlT1piOFqeQjWhwXbHPX3bL5W+i8IxWQleQxiD3QOVc34xdlm6UcUX/EdD7upE7s4JftHlxKTHkCHd8LV+y/W0LF3WmxZxLZp565lRs0PoKQxWmtIoYjEDgW3bibqpG5y4LzerlwHlQvccvkCbgplwmJETvB5kg5+B50kpBW09oUiS/JT4RMFpJAj56EW30dIMBY8e03rmEKl4MRQDLqfkVZBh5O4Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:15:58 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:15:58 +0000
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
Subject: [PATCH v4 00/11] Add S32N79RDB UFS support
Date: Thu, 17 Sep 2026 11:15:44 +0200
Message-ID: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-Office365-Filtering-Correlation-Id: 5a71d676-9e69-4fdb-e44d-08df149c4929
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 9LCML4LtwBW85DgfL1osTE1ZtajGlXNozO+GzhBhAqGtcdXSC32LQp4zpFJXR4Trs3LuqJiWCIBaTig68KydrhoA2zeiUZyCkGI2Dln92SJ/uNtZspRczdMu+omvmrS3jWNhhaYgDfVIxjklE+M3xO4Jnqn2ZOzz2wApP18fs0fdkRK+xpuahRtqmpm0hRsTJ8GuOEOWCeSBnUrV3a9fbIqzZhe0AB8eB6JemOcDM/cVjA/pLFCT4uf6U+TC9dm32/apYART2Q976M7lcd9NehnbhKDZ8B/PNDHuenRnhuv8NDY4YTGPA7aNRTRHns0+NX38VBikkHow/NvinQL74IVxEPGfuL9wMCqrbYv1CQXjXqjNI3skKdUXignqy1a9CTYwtsMGgxMxuQPC+nNl7pNyOvCLZCtIfZX4VCzi6q4zsNoPykdndwOJCSUG+IG6Aft7GbWkKO6gQvwKJzGaB6fS9YV54zBQ6041cf8/dSPOWw7Wv1FTgLoCWwJd7AhhirgCEX84GAhEubrDMTVpcRMc5nYu9c7B5GuT6ysfC8WqyFhuX4pMvi863uqXJ61xnIAvbP9hF+txvuTrBECNC8yw6QK2lHljae58LSMrD40nP+OyTrW71EEpTiDK2DtKtNzeYBZk9LczqfVoRzgiAoqmWxghPynAv5di69I5lpAbh22w8eoW/YNq7EYZhrqIrJhmfECn6tygZPE4KXVfpg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Z0VjSnpuWEpZSFdZSGx4cE5jVTlsNkYyQmNVendYWm0wQUdtL0picG96ZFY0?=
 =?utf-8?B?dHcrQkh4dkwrc2hYQ2ZmQXJCNE9LTURNN212MzBDdEJiVUpKZElFRDVjM0lV?=
 =?utf-8?B?T3JBVnp0OHJadmY2QjRpTURlQjA4NmtSc2tTMlpOWEl4eXM1RnJYcmJicDA4?=
 =?utf-8?B?TjJCVWhPSVdjcjQwV3hxMTlFMTU2UUZBNXM3b3RBaXJWWGQwQk5CTVNZdWpP?=
 =?utf-8?B?ck50UUlSWFZDWWluaDRtVkQwZjBUMEUvNXgwV2dFZUFlNnViUlFxcHgzNFFB?=
 =?utf-8?B?ZlRqMVM1MDZkVCtrL0dMSm1WdUNKQXdsd01tYTNLQXFpbzVCY09DYlpBTENu?=
 =?utf-8?B?dWFJc1VrWWFXMlpRcHVhTjRGUWZMZUpwOXlRd216R2ZYM3BKV2JxaGxrejB4?=
 =?utf-8?B?Z3pNTXJ0TUttclp5enNBdm05SUlubDIrZTBabHNUcForSjFUYmExVEkvOEVO?=
 =?utf-8?B?Q2tYbXgwcS9wVGxYcjhRV2NvdGVhK1Z6VVlJL29OR0t0MjJHMlZOSGYyVVhw?=
 =?utf-8?B?c0FGYVJHVmFCOFFhcU11UTFTcjZkbDBsTFhKODNIdjBsajFxR0ZVZS85bm4w?=
 =?utf-8?B?NldWckpETnZKRXAxSVlaZGgyY3p5Mkk2YWlIYjJqbTJwcy90K1FVbmc4ckNx?=
 =?utf-8?B?VElGNHM1eUYyS1dZQTRzeVJ5ZTNvYXNvS0FFOWtsYzdtNkFDZllCQzNVZjNy?=
 =?utf-8?B?UU9zWkFub1daejBSMWFqcDlaTVlJeHBqZzFuTkk0RTZNM2RWVEZGTkVxTVVw?=
 =?utf-8?B?emVzN1FRREc0dGhLd1Fjd0tZUmY1aGZYTUZjM0NkZXpEMjNwaE9aUUxBQUJP?=
 =?utf-8?B?QnA3Q3g2YzVVcTBicGppMU43TWYweFJ5T0xxRHprRjhJdU5vNUdWSXg3UVlO?=
 =?utf-8?B?RjFaSVJiVEtZZG5Ibzl4RmJ6TzNEZ0drMVhEQXVzWEMyclg0dENDdUJ0RW1C?=
 =?utf-8?B?N3p6akt5bjRvU0ljZWRjdzhMUkNhYytOWWpveUZXZnRMTTIwNzYxWmEzZmZn?=
 =?utf-8?B?S2dIWlhYYUVicEZwTnlDQkg2dFVhakduZkRmNG1qNHBjVGpMRkt1RHhrZStC?=
 =?utf-8?B?c3J6dWtlWE9FZHBSNUpDZjkwQURpalBibXp6NFplemFJMGU3V2ZjUFpSUTY2?=
 =?utf-8?B?STMwaFJYTHRva0N1UmxXWjM3eHNRN05La0tlbXVLQVd4d3lWN3lpTnN1VUw3?=
 =?utf-8?B?UFF6ZU96Y3ZLbi9ReE9wYlBZSXJKTytNWTVVWC91Q0pzYTMxT2VWZXlnYTN2?=
 =?utf-8?B?U1JvSXBYcDNuZm5EK2lDSWZkclB5dHhTZG9vdkRRUWhpNlVTdTdyMlB2RFEw?=
 =?utf-8?B?MktoTmlzRlZFRkhMRTNDaGdwcCthZ0pkNk9OaENQS0psVjdOMEJaOXdkTWU5?=
 =?utf-8?B?dm9McTBhTThlamM3TVhqeHBCOE5Md2dDQ3NXQkdicGJIL05Qb2V1ZDU3RTY5?=
 =?utf-8?B?K2VzeWFZdUhFQUtlM3I4N1B5K21CVjVHQmxlT1l3S1NHc2sxT1gwUzlSRmV0?=
 =?utf-8?B?Tkh2V21aRXcyZU5VZVp1UnI5ZXVaRmNDcXkvREYybGE4YVZtdE1WVVRlUW03?=
 =?utf-8?B?TDNHR2xnanAwSEd2cGtNNlprbC9ZVm9XU3A2Y3BSRFFFUWdaMm9aNFJpcGtV?=
 =?utf-8?B?bTFxTVprTHFSK05pL1AzSloxV2dOMDV4QWNRWlpBVmVnY2tYU1NLQ013ejF2?=
 =?utf-8?B?RisxWG9aM3pZT0dEOFVwQXpxbkhvRnhLNnkyTGhyNUI0YXB2NkZqem5uMzNx?=
 =?utf-8?B?akc5eGJXdk9YeVZXN1ZRZjBIakRxMkJDdE5ic1hxdVR5VFhBMGpRMXdNZURz?=
 =?utf-8?B?Z053bHEwcm1ReGNUUnVOeXVzWFdTLzVZRHpidllJVGhOSXBSVk9FUFhaaVZ6?=
 =?utf-8?B?WHdKVEYyaDJ4QjZWYW1JaGNYRm02TjFqdmJ1a1V3Z04ydy91bnpjRXNXRVQz?=
 =?utf-8?B?VFB2V1lhZEJUZnpzT0xuYkpMaE5pT2R5eGNKWkp1RkN5L2NPNndkQi8xS2Nt?=
 =?utf-8?B?Zyt1RmZmTk02VnlNcktzMmtuQ2RWZXcxS3hLSk0zQmxHZklhUG00eENSN1pm?=
 =?utf-8?B?VXVXWkhzcHppRllZazZ3ajNoZjNxVXhoQ0lVcDFPK05RRndRMElHSGFrenFB?=
 =?utf-8?B?bDhmZTlmaWxZM3EzVDdHU1hwYlNRTEdSaGNYZmRWcUFVRDlzN0JTc2FoVEZD?=
 =?utf-8?B?d3g5TDhmdjZmK0xHVjlMRldYSUZBcTMyRDJxYVZBYXR3ZnhiMnhEQm9JaXRU?=
 =?utf-8?B?azBxTFBzNldKRW0rTG9mVWcrT1g5ZjZUdlNJTkJ6VzN6SXFrWlh2RVJzbkgr?=
 =?utf-8?B?aTZFeXZXNmRtVjc5K0djUzJsQ0R1aGZIY2tRejErUEZ6OGkwRDVNQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a71d676-9e69-4fdb-e44d-08df149c4929
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:15:58.6009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcAiY3qJ4ZPsrw6kCsuj4CLjq8G6TDoH+MYprEtXpIyjp1qQciM6uw584YaLQpDvhqStLmgSATz8a8RLhHloQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

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

Larisa Grigore (11):
  scsi: ufs: dwc: Return a negative error if the link is down
  ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
  ufs: unipro: Add TX/RX FSM state attributes
  ufs: host: Add common Hibern8 TX FSM polling helper
  scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
  scsi: ufs: dwc: Export common clock divider and link status helpers
  dt-bindings: ufs: Add NXP S32N79 UFS host controller
  scsi: ufs: Add NXP S32N79 UFS host controller driver
  arm64: dts: freescale: s32n79: Add UFS host controller
  arm64: dts: freescale: s32n79-rdb: Enable UFS
  MAINTAINERS: Add NXP S32N7 UFS host controller entry

 .../bindings/ufs/nxp,s32n79-ufshc.yaml        |  61 ++
 MAINTAINERS                                   |   8 +
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts  |   5 +
 arch/arm64/boot/dts/freescale/s32n79.dtsi     |  10 +
 drivers/ufs/core/ufshcd.c                     |  73 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  89 +--
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 543 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  84 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   3 +
 include/ufs/unipro.h                          |  22 +
 18 files changed, 859 insertions(+), 195 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

