Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011026.outbound.protection.outlook.com [40.107.130.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3314AE8C3;
	Tue, 13 Oct 2026 10:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887428; cv=fail; b=tLVnKkZ9QpvYKCKXdrtnmtZjOoVKYz8llcow4y9u7b+55VFv+rpqpJzXnw0JqOWthmnhtk2ng5HeiTc4U6VIlCAzMKORjjQu8ZfT5rXRzjVGMp7VFGk5nrd3IU6JNBrkebK1Q9vbbquCJmcLSEAvXEigrd8JUHB0N2pi4r3lV3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887428; c=relaxed/simple;
	bh=Piqo9AW2sCzv7pOOjKFfy3/5GioimBVRss4fH1SZPzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LhMs7LgdwpiQESH8EWypUgwuRuNHy9Cpd/C3S8rPbDgK6pQSfCUcYCD0ZRB+i4rHCaxYn3Gcghx9pn16Prq+InwQqXyTJtE2PwQk+o/eDtgU/mWXZ4lCHDunklJSgr1vvk/CVYW7Cei3rMvRDZMTSEf/hVyFiiED9CEtkpeazRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=T1y//D11; arc=fail smtp.client-ip=40.107.130.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="T1y//D11"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8v+WDQyaXwDcj+C1APK6HkLJ4AGgDpdTS7cp27qk1P3MvAwezNSIVyT2RMIkGNjbADcbvZ3rZ0snV5zJRHzj9nBjU3Oi9GrR3oVN1qkV8ESg3xxCYraCx6VLJX1TXYs1WmrdtjAuOoYKCJ9y+Vfyx9U5lcFjJTw17uuE7A9jNhe6nFINaSgZvz9i5py6p8jTcJpPqwDwFEJNu3Xp2QILsarEepzUzBT8bE/aOqz9K3SM3Eehh18qh8g0S7Be/HvsAK6Y3auHqY95ucdaoWSe9gJ0z+FdmNFEi4TVXelbLw8UCxpkcYfiWfREbWXfPH0bjCu/8/4jyxr6AY0PR2FQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/QaA4vzdZhASucmd2Z3xDC6EBTYt3WgHZHST7xmgIg=;
 b=ePTiCl+I8fZuFt3Xni3IuGeFx7G/z35iGlfOKXMFUB4zPSgORfn0NXSAp6cmJgVxfs5IFEwRxVgG5tNLh0zXubPALF9GzbgMdtTJIruRVv3YCiEMgu8NHl0ap6jTrUAKkojCQCTFYvZXwhhgp2Gx4+jZepl9k8PhD22EqfcxWrO2VsaN8Oq8t8TtSUgHVEjqWlz+mJoYeO14FcGTRsI1jCkoG8GD5BgrRvS4DE3Fk5X1P6w72NlLfIZAmfg1cgvThaVVfQubYU8m+qEpUoU0l7/cjUcpqWCuFVfopOwW5LNrLEStcDFaDDxnMU5sijrMOeuY4jPdtTHlnjpCixQMHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/QaA4vzdZhASucmd2Z3xDC6EBTYt3WgHZHST7xmgIg=;
 b=T1y//D11gLr0TGZna52fbLTVQpEotRTXfEozJTsmb6SsSUBncJ0AwXGRA+JJPaOAd1DM+Z7sL4CLeegwXolvw1rl0uS30OKYiRQ8dNA8O3W/IyF3W8CbHOZHa1hDCfb3q0bNVxHARUL+Dgpff5jLLALEdPR9+MJtVud0N0YihWBUx2pICM7Jym/xmLD4xb9avmPeKrFc13dbQ6HzJP7Ggc4GqbESQMGmC9Z2pz1a//9otFYZW+lnTq3J44ksF2z4Ps8dhLmXD9uRmOvd+5G+rZuu/bw8Nc3i7GIIsxAJoOMrxPRscbdr/5bC+QwZBiXVOiy5C6XfJUsmFVO83WFjPg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:20 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:20 +0000
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
	echanude@redhat.com,
	Stanley Jhu <stanleyjhu@google.com>
Subject: [PATCH v8 04/12] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Tue, 13 Oct 2026 12:29:55 +0200
Message-ID: <20261013103003.373156-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 634245ca-fccb-42ce-5e5a-08df2914fb45
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|22082099003|10067099003|18002099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 nrwMCxx3EBSFNcHBo4m1MBHvENb07GriwLB5EwQZFEO0tjsCuhoGtAaH+PCPjiKp+COlTO9em9A7kNLBR2GTIaTxUz00N+/2zc6FsBNaV0ZQ+LVC5YKsfzJvdSg9io2WH+JTQpaDo8Hnayg+bSWkvOa87ji1uPKf+3uiz5G/ZSknt6K0+uNvER7vNuikSkv9VUL5/+WSXhEPufWpIPG3G4yn2X6Qfd+I13twaOEd9s/Q0vDw57iEg0YJzmjKzdF/pwVjCDSnJvWW+aCGSBa/ocsx1UCu0RJ8/X8Jo5kgHTTQXyj/WsGnEaU6qzpfjVShkbgO0AvURtqLFmARnB2u5DTMYAm7tLgxZtMbvbt7lbDG6LoQ7peOSuYeOCyFQo+9MDfRMElmkODskimdRLY/RyopqVN5PoZKEfLh5HyUoRYe33atV0XwGry94QsreCkB53DdKPSwLR3ZRJF4whWvbOHdoxns/SOWs49gEOAQjyPi7C+rD7doMuDUt3JqQrfuASrilNr6w+2+yUGxNJGnKZQN/dGCrVSScGDO3iB6kPZwMLmTDvCNwK7knImouURCj7kLI5LuSRrRtSdt3gIelLvv9xBCInrTVKA9UIbdWGdcKu7asA5kLBRD/sxDoZn8AuGH24X7rTtHwvFibfg8vR1OF1UHcDVu5vy5ZZlmqUoDxKmOswEzjGx3yZ2meP+EY3tOZ7//IjnnMlO1pDyCow==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(22082099003)(10067099003)(18002099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZnplZ3Y5VHI5dmw2NHZzVnVMeXp4WHBEUng4bFAxSWU4MUVQbFZ1QkViZ29a?=
 =?utf-8?B?S29oUjhyWXVwY3N0YkxFS2d3cWNNTHY5NStVcE1kdU8vbUlqRnFwTmhEMW1i?=
 =?utf-8?B?b0VJWGd0dng0NElBR2ZFOHdxMndJYlJjZnU5bDMzQUdoWGNKMS9PVFlINTdn?=
 =?utf-8?B?ZmVsSTRwYUNWV2RrZzFUS1NKWDRTZ003RDlCcFFXQ3E3Q3o4bnB0ZVNRSTlo?=
 =?utf-8?B?dTRzcnVHSWc0dEt5cUJFL3BBUHJLbE5KSXZ5UnZCZ21HMVcyM0htRld3Y2I5?=
 =?utf-8?B?aHFmTUg1bFdRMjVEQjBnRGxmaXR0VXM5ZitUeWxFei9yT2pMQTFMVnRaS0ZY?=
 =?utf-8?B?UDduU1dwa3RtZ2pkM2FnaFAwZGFzSTFwZHhCSTFtdW5CWlc1OXR3NnpCOGhK?=
 =?utf-8?B?MUhaT0NsQzZyNklJNFFkQUZPTnNoenkxbisxazFVSFQvK05RVTJ5VS93ZmQr?=
 =?utf-8?B?SkRiR2xWMW0ycGUxS0NOTGRaQVYrSUdGdjJJSTdKVTRra3pHdHdQMjhtQVJC?=
 =?utf-8?B?eWFIUHRHaVMvWDBNTEYxdk5VZXZ0d2pFajZpRUtRVzk3V0dMcHUyQzZZRUNZ?=
 =?utf-8?B?bEh4WFE4bHZwQ1YyRkRyY3RiKzV6TTJhMmorcmFVcHQ0NE9YOElSVkIvNWl1?=
 =?utf-8?B?NStBT09RN2owOFMzTVdUaWRLRi82Rm9BcEx5R1cvT1hSMUUweFZ0eEJjUjNY?=
 =?utf-8?B?QlIxTFc4YkFwbHhTdXpDRGwrcjNDN01UZUc0OEthMDUyT0tEYXZIQ2FLVEFk?=
 =?utf-8?B?V0s1ZXJqdDJ1K0dlc3VWUXBRMUphMXJJQ0RDaVNpeU50SlRhYVQxYWZQN0tR?=
 =?utf-8?B?VS9Ebjg3SHFhZHpUTHJMT0JFQXZiSUlpK1B3T2M0RWhzcG5WaDV3S0Eyd2FB?=
 =?utf-8?B?eG9Ud0hQRmpNaWk3UkprWEFWMkhLTmN3d0loOCtObUowOW5KWCtGSWlnM1Jv?=
 =?utf-8?B?azlIM0VqeW9LZ01CZGxONzI4ZlFBZWZzUTl1bHQzTE9WaTE4Z1pXV2VYdVVW?=
 =?utf-8?B?aDE5dDFBOGZON1o0MnRzUlYzaUY2UXNVM0tVTFBRN1lKTHEzQ1VCMzlvUGV0?=
 =?utf-8?B?N2xXdUphUS9maVh4MG4rZDc3ZUp4VUMzcy9qcjZiZU1DWk94eEw2SlhURzVk?=
 =?utf-8?B?Mmwvblhaa1hLVDFxeXEwTHVwWEVBeWVUS1pLMGJHVG91RHVIeHhsRUlkTXF3?=
 =?utf-8?B?Z3BYdUdhTENuVm1iTWp1b0ZYa0ZYOEZKZDkwcVd0TGlHcHJURFp1b3NPYmRl?=
 =?utf-8?B?OHR3aldaRUhxUjNBZGhJNkxvcE5NcXJSZFBxM3lKL1dsYi9sUWoyWVdiSVBz?=
 =?utf-8?B?WFVjWVlKdUxIdDlzckFwYXhaVFBXZkZmbGdleHlNR1lpcllxWElSNGhHcXFP?=
 =?utf-8?B?RDBMeGtiQVhwaFhMbGo0dllaL1RxQkZkbnlabi8vL2JEOGROS2VCclRpNXVq?=
 =?utf-8?B?ZHZxa0E2RDNrM0RoYzV3R3FVWXZidjZING5VekEyaWxEeGVkYU9yanBENmhs?=
 =?utf-8?B?eE9zUGs1OERZb0JVcTduNDhHdTdRZXh1em1yTmk2dkVkWUMzZ1NwOGtuWFph?=
 =?utf-8?B?ZnB6dCthQU14c2JSdnFrdVJwOU5aTk5tL1RQZStrY1hVTi8wYVdnS040STJB?=
 =?utf-8?B?OWtxdFZ3UWhWUEJyL0d3dVl2Y2E0T2FoZVFkVlA5WjhTTkg5L2J2VVFub3h2?=
 =?utf-8?B?NUhUOWlaZFp2eFh4bEVpblpYWGMwU1RtNGQvdnRXVXBGcVh4Um9rR2R0T05K?=
 =?utf-8?B?RytnRVlKZkxXMDQ0QlVmc0ZpVmJHbDljSUVyNFltTDlWOVRWSmRUNXV1MlRu?=
 =?utf-8?B?dm1abUdIUkVUaVNKWmFMU3d6UFJDcUxHeXNvb0psTVNIRTlTa05CY2pFd0VY?=
 =?utf-8?B?SDVCZFNRdFNPbUNZTTRzdW9XVFBqYlhGRnZod2FQVHBsdzB6bm9PZER1Vkkr?=
 =?utf-8?B?UVhwQWJCemk5VGVPSmZxTStMRFF1cTd5Y1Yya05LbkFjME4rc2xWTlNLWm5Y?=
 =?utf-8?B?YzdDN0xVZDNFd3ZOUktjR1I1SXN4Qm5DcitIWXdjY0FiemExUUt6ZWF5UDgw?=
 =?utf-8?B?R2FjbXJNczlHNUpxTmNpdmU1Z2pKTE9oaDdDWVlXdmhLNnB0dHd3UHZCRVI2?=
 =?utf-8?B?clEvczhqYnl6L3RvZW1EcEdFWUo4cUUrUTJwMmcwWUE5VTZJNlh0ZDJVWElH?=
 =?utf-8?B?QzZud0hudXBBNDJ4c1daMEpaVkl4SjFTaFJlWEtMZC9ja25CQUdXQ3pxOUZD?=
 =?utf-8?B?UHVBU2VJSDVCbEhia3FhOWhyL2ZJNHhzVFhrOWtqSFl5SnZWZDFqYVhIUm5s?=
 =?utf-8?B?NFI0ZEVEcFBJWVU3bXFvUnluVEs3YURnQ2F0bXNqeEdLTWxsRElaQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634245ca-fccb-42ce-5e5a-08df2914fb45
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:20.2602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZtZ7I8iRNvnhqnEKK+wTqYu+xG9in84HVEpzmic++9SmKZVyyv6IAaLC/GeLEyDMdEbeXwgD+I58SVaQVTYzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

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
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c   | 73 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c | 48 +-----------------------
 drivers/ufs/host/ufs-qcom.c | 42 +--------------------
 include/ufs/ufshcd.h        |  3 ++
 4 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ca8329052cbc..58f235e45817 100644
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
+		return ret;
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

