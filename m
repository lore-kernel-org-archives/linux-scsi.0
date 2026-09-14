Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011055.outbound.protection.outlook.com [52.101.65.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B34497B8D;
	Mon, 14 Sep 2026 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390225; cv=fail; b=o/tm4a+WPxbaEysK5ygbWDkftshMPzLOoUU15UAVke5Pi1krLo3RokTvFOXZTL9IArys8iprzP/+N2eh3iq8wk6uzVeKZVprHcBpILFvdl+Y3OO/1GBJif6eOKX8JyQToPFcg1N7m3NsdXiW1BzW2LAJQqTIUfr7FWM25PXVnyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390225; c=relaxed/simple;
	bh=1y3uGgT5XKFvGKhW55ohCKw00xOyxxy1cwKIXDtnI1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Dn3ub6VXRmkYVGDAcWzVW+d1Ia0Do5uEq5KOHW/dtrAspW3Q1zRm3MiMvlru/dI5+khbztZfky5YBvyyfbwR3QybBRXlZsiuJJJeRfxvbMgR+sG9q7Dca9FoXXq1beWNrsRYXXxPhTbhPVSsYP0vLJS0w+SwE5rHhbKIhBLqjWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=wJr5ELcE; arc=fail smtp.client-ip=52.101.65.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="wJr5ELcE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQjnMTydBmLSKMzNpRroQHmMcNYF98RKNA9Y8QCV+cpPpMQqSzxYFr0hMbr8ASDbue/B9F6Bo2uIkLX6HVQngVxihF5qUhpGS3O94GP+EZkJQJKffsYeFRhIim2Xp2O52qfGxDfX65p2X5XunypLoaZ37ve1Ohr+jne4jiYKvk6cHUYPqiRz5eAeJEfpjp7+MivJkOrrcImsImz7WiWOtvcUKF1K+yxaf6c48eI3RicnoeDorXanZVZ8HNCI6G1Jq5ZXgGPAHYivFLUFGmZmhDBAm7MZcj1C0yZHPFhFDpariya3DdQMNnkTVyZVRY2Q8y3WN4pxKj4MEf96nUU6Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xa9OowSVB3NURd9m+pSbqANLjdLQ6Pd8zLqWnZyQUqw=;
 b=kPO39dTxRjD7Zu046JL5thW2/feraf2efXFNoxjoQvcOzmwd+dT4W7IOMg1iYifi0gdwptLG1CgoiUcd5UETHmhkFBiaBJGs3kEhfYmAxgdvdrQEv9LgjGlj2asUhEDceoBuxSv64keGD/YrPNvTlwIgA/TMx3f4ugIcVFIrd7r533Xe87f66V9TE31WPJUi9cdQB3HwJkxI/aVJVdMqDQH7jQUHnVY19d+tiIPNvI9BnS2UrLG87OAjQMWZtzT1ZmBGZPhJoxrmD2Eg1sOX4vY6z9jv34obqA3eQ9Dss9ORC+/TBiV11wzZWG8NP8HTr3O80eIurDbKeAwVQjOXYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xa9OowSVB3NURd9m+pSbqANLjdLQ6Pd8zLqWnZyQUqw=;
 b=wJr5ELcE329JShXYfiZ9enf7NFtFpcftWUUsxXggoTSw2GeUr9zoSBMLANDFrcqt+3LscCIV53nZRxF1Oxv/ucDqupP5LQk1QTZbGPUjo+ydEacKyfdXoPP1RyFDoBULm72KxmwgY9H9ABIiQDBKYHrjGLou0F+9kqeUbKaSNyMBsOYhU5ioVkRBpnruHTozZQMlJCGyi6VLKRngQPkGI1EanatmZcjIcH7bne/fmh2vGQRycOdTwB6RoConmmc994wY0+eTJ4+R4C4INyKW8qxsKGaT0/xCuH+uXtTuChQPDP9kQm/BVL18/9rIp3UUFBEwARMHaNlkI25iCmxrYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB8971.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:10 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:10 +0000
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
Subject: [PATCH v2 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Mon, 14 Sep 2026 14:49:53 +0200
Message-ID: <20260914125000.30812-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::31) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM9PR04MB8971:EE_
X-MS-Office365-Filtering-Correlation-Id: faf8bf00-3c4a-4cad-486b-08df125eb64a
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|19092799006|921020|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 w4EZ7z0vb6v+7yhqm8ZXEZtcvAynPFBH52opGx0vIb/6Us7Q7ocKl1Q/hcypWYXqk43TwqnYjCQ+M/DxSH/iZbROXGliVPgBKLbLxpayxZe8HI0iJ80pWCycp9hInjKJGxF2Xun09euyIQDDAzG63zG2FJuGuRhrIebuYqCXvBPLm76QGtNhDO41CCkl+FY1pgVGrZ5U58dRA3GDuZV+bsB9LApHjtdQn6RQg96N5aLJQukKVO/thgXhSYKKT20ZyIX+ibNLeLOO0CkT95aytvAUEK4xPeWiVc62Pwz01pvDgwSBi9jx7HA6ra/phjlDcRAci/nYqopPdVnx9wzwt7fyMqjEbIzgp5M8HIipiqZ1vZHbzvsmKY+NZAGbGlkkyXC2UeZ+fZktPH0jT7pnjMafjdKagPqL2uOACDkUY7aauvmNWmDDTHYsI6888HH17SOjg5W9H5OPkGrYBMsxaJLXOIhGarjAojsk92mIh8Xd7+aM/GhzIGEQdiPEk1sNBtpMzv++ZSTriukA4H7FVC5GX4tQAZxS84yYZOsnT93db3X5fYxwoRTTImYQcrs73UlPhFKO70FoYnLdIPNoDr/42ZDDkSD/TMV3qLkDvBrqY49sb6q0cd7Pm9ivEsDRyuX4sZIpQDeQBCZPo9qso+ATlF3akAZGnlGDT8mi7ERNZU7j2PedWUQUY0y0vtAuwieB7E8IRH/fWAh9w9qoeg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(19092799006)(921020)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Q1lyamQ0UGs5RlFoaWN4dGc4dVNOeUVxVWpocVBNQzl0ODl1aXhCSnpKdy8x?=
 =?utf-8?B?QXpQcjBjbnd5TGtjUW50cXZLNmhoNUNwK25zUFppRVY3UTRmZ2xOSVFrcUxn?=
 =?utf-8?B?clZmQSsvcVMybkVHamdGaFB0ajcwQlRXTUsyQ2FuaHdFUjQwY2ZkT2NOdTY0?=
 =?utf-8?B?RVdJY0lUT25GaXpmTGRselZwMVJvU0d6MjNvdndocWo3Y2RUUExlZVFWaDJv?=
 =?utf-8?B?Qk03OUF5aVY2NGQ0NDFmcnc4R3hiS0ZEcE81NGVJbUlHbHAySHVTRHhobHFx?=
 =?utf-8?B?cjNnQkp6KzRhT29lbGxJUEQzWlozQzcrdklQYnB3Um1hNWRjdEpIUHg5dkM3?=
 =?utf-8?B?bkVYZzM4VTlBSmxNckdOdmNPaVVRTmp4NWlvNjZBa1ZnS05DV1ZRRVdkOHZS?=
 =?utf-8?B?eDlyV3F2SkU5Ny9RbXUxMStFbVFlVktYL2FWb2JHV0hnQWZqUUsrQUNNVmEr?=
 =?utf-8?B?WnBEUG1vaVpzKy9YcWRsZEdTYmlzNlZwMUtsVXJKTndxdEJFSEZCWDBZdVhS?=
 =?utf-8?B?YmFYWmRhVjMwZTVZcU1RUlRORmFZdEsxcUp3RXRsNmdEZ1E3cjRSYTRDQUxR?=
 =?utf-8?B?d0NYalRycEtGekV4N0ptYVBObHRkNHdHY3V3RUJoRGJUQzJVclVXdlNkejgy?=
 =?utf-8?B?UTBiTkZsWVZ4a1FGUStpY0NuS3hsSGNzWkdtb1Y4VW52WkU0YlFDVEo4ZDFO?=
 =?utf-8?B?K0QyK1dDazlNYURPdXRzZ1NVTWhGaHFCY2FyOHVvR3orYk81SENRcVRmNmw2?=
 =?utf-8?B?RnF1ZUtJS2QvNC82T1NLb1hCOENXTXdGeWthcDVRd0tqZGlXa1gyUWlIUGVC?=
 =?utf-8?B?M2YvbjYyOWVzaElpeWxiNHhWR1poZCtEUW1FNUwrRTg5MWh0LzhGV3FNeFow?=
 =?utf-8?B?Tm15OVhTckdCd1h2bVZ2a24yMmtnRHltMjFKMFNBWXpFYzBvYXlZU0RHNXlQ?=
 =?utf-8?B?eVcyRkMwd2Y3OG0vZGRiV0RJL1hmazlpWFM5VW4xWll5MEI4WGVwQXNtUzR3?=
 =?utf-8?B?Zk9Gc3FaVlBzT240dGdFcGExSE9HSjB1aU5hMS92UkN2ZFBFQ09XOTU4Qy9R?=
 =?utf-8?B?U3RrbVVhYUM1c3JzMzBSTEZieE9aQmpGbXJrTGkwaXVpQURUWGdCczhtSkZL?=
 =?utf-8?B?WTQzRHlMbUNMTGpUakM5U2hUR3NXT1lONjdvSHE3MTdJMkdhMDFhbVowa0tX?=
 =?utf-8?B?bEt0V09JTzRkaTFmODVPWFJWUnlBbFBwb24xeENmOUgyUkZ6eDdPaXBQVy9x?=
 =?utf-8?B?VnVjb2FzamJ6YVdSQk5KNVZrVUZ3TnhtZnFHVzF6Ry9XdWtYU3pvakZnaHZN?=
 =?utf-8?B?Q2dkMFFidzNKbytKQjlCeHR4a05Tbk1BZlIrTEF2UXIwL0VVcS9KWW1QRlJ0?=
 =?utf-8?B?akVmT2c0SzFUYVFVTGwrTGFwM0ZMamxxOW9vQmhTMDFXU3U3TzlOUkxjcmpm?=
 =?utf-8?B?S3VheXNPbk1PbW9HUFdmSC9xNjdiWE4wVGdNV0oyY2J1Nkx6ZUhROVZHdVFB?=
 =?utf-8?B?YlExZzk5RkhnQlpkVkNzVnU3QzlsWFlyRU9pb2F2Zi9HRmdPYjZzV3R1KzU5?=
 =?utf-8?B?dW9xMTRNVnRyZVg3d0VTNm01cTRWWlJwVUJuVFkxT3JPZUY3YzBkbENUZE9Z?=
 =?utf-8?B?MStxT2d1SHk3QUg0QjRHVVMvTU9NVy9vSlBCZlpPQ1UwbGdja0NYclMwR0VU?=
 =?utf-8?B?dTB2blV1eStzY3Y4MEpsMFlkZmJiemxqb3dmeXJ5NzJoOUdyTFgxamszVE5v?=
 =?utf-8?B?Si9XaHkzZHEwSzl4OSt0UUhSdXcvcC9qWkRVOEtPRXphMFFiMXV3RjA4ZTRY?=
 =?utf-8?B?V0d6Mitma3U3dmZCS05aTVhjTXRwNjJiZkNaVzVLak5uNjBkam9DcHg4a1ZO?=
 =?utf-8?B?aTd3TksxM1lUWktWSkhzWW9nYUFJSVpYZ3prcUwvQlljb2h4SHVTZkZoSFky?=
 =?utf-8?B?bmM3UWpReFprRndzSUhoK0sxcVZ4ZkxUZ0xReWRNZkZYQWdSVzdFNU5nbTNw?=
 =?utf-8?B?b0pUR3A0KzJlWFQzeTlnZ1R2TExmRjdnQnBYQlhwcVhSVTRwbHRqTVprM2ZJ?=
 =?utf-8?B?c05mMGdDQ0ltUkxmWTg0Mm9INUloUWsyekJsU0s3Y3hNR05Hbk5TWEtJbUFi?=
 =?utf-8?B?QVFaTk8xeis3NER2enh0Wlp2ZEJ3NzhxZk1LcW0ySHdPdmJRQkUyUG5UR3RX?=
 =?utf-8?B?NWYrZFoyOXNnait4RnZTUENocHNJZS9XNW5UK3ArVHFocHErSWhwWHZYWEsv?=
 =?utf-8?B?NjhWN2ZNcDgySVpWVmwrQlI1RkZVSXhLMGpUOE9IYWxxSjl1eklsak5MMUpj?=
 =?utf-8?B?UlcyUE1tNUNKc2M3YUY5Z1c3NUJqOWtyU0t3bzhMaTl6cUlOUFZWdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf8bf00-3c4a-4cad-486b-08df125eb64a
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:10.5333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqDndtGaeD0gjbNaUxg2BTWpDVct2CcLQDnwACUUXrZadZhsemWYZGw7CBWzlaiVnQgANe9ZMXpwwYWCeT+9Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8971

Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
enter Hibern8 into ufshcd_check_hibern8().

The HiSilicon and Qualcomm drivers currently implement similar checks
using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
this logic to a common helper in ufshcd-pltfrm so it can be shared
across host controller drivers.

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
 drivers/ufs/core/ufshcd.c        | 78 ++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c      | 48 +-------------------
 drivers/ufs/host/ufs-qcom.c      | 42 +----------------
 drivers/ufs/host/ufshcd-pltfrm.c |  1 +
 include/ufs/ufshcd.h             |  3 ++
 5 files changed, 85 insertions(+), 87 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..e5facc0a59a7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4448,6 +4448,84 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+/**
+ * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ *
+ * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
+ *
+ * Return: 0 if all lanes are in Hibern8, -ETIMEDOUT if any lane is not
+ * (yet) in Hibern8, or a negative errno if the attribute read fails.
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
+			return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+/**
+ * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ * @timeout_ms: timeout in milliseconds for all lanes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+				unsigned int timeout_ms)
+{
+	unsigned long timeout;
+	int err;
+
+	if (!num_lanes)
+		return -EINVAL;
+
+	timeout = jiffies + msecs_to_jiffies(timeout_ms);
+
+	do {
+		err = ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
+		if (err != -ETIMEDOUT)
+			return err;
+
+		/* sleep for max. 200us */
+		usleep_range(100, 200);
+	} while (time_before(jiffies, timeout));
+
+	/*
+	 * We might have been scheduled out for long during polling, so do
+	 * one final check before reporting timeout.
+	 */
+	err = ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
+	if (err == -ETIMEDOUT)
+		dev_err(hba->dev,
+			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
+			__func__);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
+
 /**
  * ufshcd_dme_rmw - get modify set a DME attribute
  * @hba: per adapter instance
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index bd223bda1ce2..12edd662288b 100644
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
@@ -224,9 +180,9 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
-	err = ufs_hisi_check_hibern8(hba);
+	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
 	if (err)
-		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
+		dev_err(hba->dev, "hibern8 TX FSM check failed\n");
 
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
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 5ac7afe75934..89a1c8659964 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm_opp.h>
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

