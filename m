Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8474749CA;
	Mon, 14 Sep 2026 12:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390232; cv=fail; b=PvhGGvwoMpBqRQt8NdSWRDvvuV69XoS6OxWCAPI+ReePtvv1SyigXusmnKcubQs6x2PnolvrmwKH5dXSBW1xieQB2HVStNMF4rXgSmRYf/tcoXsGHW3t6B1oABJm8RKoG/9lKfl7Qx3Pr+uv2x66+vwQ2rCiZoWqhKfvWlS+sV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390232; c=relaxed/simple;
	bh=Zt8KsJqmLveMQh85NDfMwSdrFauT5AB1RUcrZVXZBJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gq/I/CPaIeD3sXJN71xItvMm5OXOYVmvbG277qlwsIBB0lYGlilD7WeYbeqQ9ESdNB1MUVgA8WklK2BES8lFjrSkpTk53rSuujlAKSsRaqLVzcDiTVNbfion1VqEzEv0H2HSicJjXqfGUJJMM8sYUSS1r34IW+enWnKeTdQsaC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=IGPY/tKb; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="IGPY/tKb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vYbIG/ptEuFItMdXbFl9wRIGVacG7VB5K0Uxj/q23dzvkpN19LODMbww22cIX9J8Ia9cXmvRnvZdnD6ZJ+hqzxKmrGNqsT9MopSOaKsPeGj4vDri9okz31ErO3hbjDQfqJA8QjvpY9gz9Rrghrhs28ZmFjwAdUEw8L/nI6UaxpO8Ro4qUJSMW7BBqLGHGI6QeVu1RJz3n0NJ01xQsrj1G6B9EQ32sK6yVUTBWyu5UP5y+HFSATe020bvO4ZN7P0dNY10I3yVfzVzKI0XuwVxJAfXy8Zq2Nsz7C2ly2wmXjhVFF9Yg2hMjW3XxA3YGUnEbepy1mzmtVT8A5GiYdhyWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nECHGnHVyp8jrZHqnuR5Us98vfblLnLoekmfqS9samw=;
 b=l4BJCWbl6YlHkhyLbpGDvipM0RCqahTRyjkwHm9qayAFLtgawjITxvNpCEC3NlH46A+bbgapN9X3gVj6V8Yjs8XpIPxg3+1nXiQx89m+hoWEb2T/yUTHT5sxREN15BWjW4KIIG1atq/y/a9vH/4P6UI6OcXzoh8E8610RgiFZi4Y4bCv0RK7ApPSc/YM/jW0Sax2UFimO/VGIG9xQ2dPVE9+zBUuTG0B82GzxKQpSeL8TQXbpvbNzPtQYqZzP7K+IgOQlOQtGgS+jw+2WCacHHjpyBEgpdf6pdSC/AbqZ0Y/LnUWS4jtotIbcDiqb5gycUGJTl3gzN6fi2/G5o1WoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nECHGnHVyp8jrZHqnuR5Us98vfblLnLoekmfqS9samw=;
 b=IGPY/tKbPhUbQbxwz5RK1FBisXeWmOo3kRhoaiocKp3jB8ZHBuc5XvgpGahNHiBPSjKWi/iKrSzxKoZ/shCaCTQZUvvVwxTz+Aj5LcOJr8Zj3JLg1Ua1Et9zZByDhTa1ZzHdQZkNzUhmUVQuddG3LVPQTCSMqnx31BqvRijqPwkf2ZXm7K39kEGmaaxUbTVuIFhm79igV8aWamT+wrprwZg2AwPtDi1fuGxfv8Xp15q9PPSHfHcQEbxkSdvdBTXs+WEv39jd09xQvsvTHY1TrSzDnLMBlZVFQgVCAp367aovf9/oFGTQ6aX0kOHnsCcUlgzMFLO0GKjsi7v9MUPKYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7272.eurprd04.prod.outlook.com
 (2603:10a6:10:1ad::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:18 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:18 +0000
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
Subject: [PATCH v2 07/10] scsi: ufs: Add NXP S32N79 UFS host controller driver
Date: Mon, 14 Sep 2026 14:49:57 +0200
Message-ID: <20260914125000.30812-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::24) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DBAPR04MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 52d53a70-303d-4dba-5979-08df125ebabe
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|6133799003|3023799007|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 aPifEd2hUhksz8XnBykaDYO13MIcnWcU3M4ONg1YvUzinYfRq7UAeCp1FI2fOv51+2mbUFsxkwRUATioQ1VUnFWDuEotToO0uJEzn3I1KnY5mNSOIjU4PfaDdQ1XIc9Qv8nypJWeEKIjaCT1HxsJg3Y3f/EeblKcu9sG2os/BAim9xqTh7VULU7X/pc704bhD8zuo0/hKCAfCR2C7LeZVLLl4ZDBir4fa/Q7/XqRPuVb+rqmEdlPN786I5ncwIlCFotyAT0HXPL/gx6Lo36oC3s8uTR0QuLgKd35jSpB3uHmaiFxPzKEgUVAH9OkjEt+7Dr1JXc/0Kazf5UDHHPoNSwDeLnw7lKthEOSEA1/duk+56fhJ1XQIFezkQC2zdCtU2/kvMoZ49u3KEyyF+psmxeMkbigOFN8+wBMjzti7DuW1sry3HpsCnGaOHsdgSUhjb3BiBk+yi8uFh5kHMQc9Wmva2HviJxy77i8T4tsi+OJKxmEZa0i8rpRzysD+e8O/cZluW6+xpOrdpZwVEBt/6oJb54vbPlCX7KopTMH3qRyW1F1dNwSwsjQY+Pc0NkOFjwoXIgvEA66KXEhSiGTxycp0C9zJ3wVjtFnpDut6SlXdLDesdxGcBF7MnutMreM/b6FA7JddPlI9s7tpBYHhlmKOLKuhCPoVp0HdAtvKEkxdmlgAR6g7h28Ec01rqKkYdY74eRxDEnVATpTZPz8Fg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?M09VMlpHSEg4eW96bitkWFpqWSt1UGFzRDFtU2h2Z0xpMXIxbHRveW5lS3dq?=
 =?utf-8?B?RVRwbnRHR014d0ZEajNEamxmNHE0OHJuUlJnV1BFejJWeFMyMDVDeDVSRjlm?=
 =?utf-8?B?K0Zmc2J5YUpBNVFZcGZEZHpnMTl5cEg1ZnBEZU1qaDhEbmN4ZlYvdjRJOVNH?=
 =?utf-8?B?UjlraTVhcUZ5LzBBR2ZPQzVla1dIZmQra2R1RDlDYytrZEZTY29FS21JSCs5?=
 =?utf-8?B?aFdMbDJnQzhGb2huMEJaYk9iTWlBVTFQcGYyWGE5TCtDMTFYZW5GaW80c1VB?=
 =?utf-8?B?dGZuUFZwWWFObDVqNUEyMk9xMlNNZm9PZStDY2FFMFZmamV3MXJQYVpQZFMw?=
 =?utf-8?B?NkU5RDdVT25jWVRvaHFGOXhFQS9nckx0b2RSOEpZMXhBNFlJZGJ4VmROMTA0?=
 =?utf-8?B?akdUcFRaRTA1N25QWmQyamp3WHdxemhwNWk5eWZ3K0J3KzhjazJCZWxFN3E0?=
 =?utf-8?B?UWczUlg5S1hJUC93VHZvRzlCSmd0b2cyV2FUNm9YMnVjSlFnMVlnNzc2dXYy?=
 =?utf-8?B?dVBzdkhqbnF6aW9MaHA4U2ZrL0hPaS9vMk81Tnp6Z0U1UmJyZnBscGlmb3BV?=
 =?utf-8?B?aUIwLzJsQnZULzNoMUdNS2Zqanl3bGdybTBraUZ5ckVuclRuY2l0Y2xiNVpX?=
 =?utf-8?B?clJGQlhEcHpXVlRFQktCOFArYmxOWGg1WlptcUtPbHhNQnVIR3Uxb1V0WlJv?=
 =?utf-8?B?a002YzZ5RERTT2Y3ME82cWs0TC9NSHQvaDdLay9SMCtodjJsampLRUdkVFJo?=
 =?utf-8?B?Zzl6U1YvRXhOb0Z4SVF0RlBNVWRoNzl3QXhQY0djeWthdUJMZ0ZnWEd4VDZV?=
 =?utf-8?B?ZnZwUVVLUGYwNzIwUjVxYnJhbkdaMEt0b1RlSlBaMGd0VHZkVWp1eGpML1hI?=
 =?utf-8?B?WWw0QnJDendnZjR6TEF5MkFkRVYvZmdqZ0Q5UGg4WTJwa3ZtWVlTSXFocTVn?=
 =?utf-8?B?TDlUT0pBc28rS0xXNnZ4eFdLc3JjT1Q0MnoyNkh3bVoyc252U1dadGxuV0xD?=
 =?utf-8?B?S21FY213S2pYVkRUSG45OEd1Uy85WkNxUXF0WUtJd05Gejk3VWxnVTVHeWRi?=
 =?utf-8?B?c3FXUU1zMTlIZXZEU2JBeUlncG5Eb1NLWVhpWEhYc0NpTVhoK3BaZE9Hazhh?=
 =?utf-8?B?NnNTdFBRQks2UU5na1NEbUU0dGphK2pHbDBPZ1lTWTBPdHRqd1ZDNWVjWm5T?=
 =?utf-8?B?WlVxY2JDY09kdXMydi8zY01kc01COUE1aVdlbzlXQ0lFMVN3K1p3RW9HNHhT?=
 =?utf-8?B?d09tNWxYYU1RTHQ2TkRsVURLM3JCRlRuMDJOdVJ2SkVWTEFLZDZXZ1Y5aFRx?=
 =?utf-8?B?Rmx1aUY2QUhhaXl0c3JEVElpdDV6QnV0MG5sMHdlTS9yNy9KTHBtRWRZMmJk?=
 =?utf-8?B?SUNXU0cxNnplNktSNW9DQTlsN2ljOVRMbCt3V1dnRkFRSEpuUkdKRzFaT2dp?=
 =?utf-8?B?dldWTzlVeGwwS2h3dWtUdDd4UXhZc2Iya05iY2lVZGdSVEFFZDV6R29nQUNy?=
 =?utf-8?B?UVBzT1gxNlRFdzZ6RC8zQWNVcHh4VXNWWFhmMW9FRlJZK2xhVmFQRkEzaCtv?=
 =?utf-8?B?YUxsNnR1N2d3ZEVDdzR2S3NmK28wMENWM29vVjR5K2dobjg3dDBjWTlZWkhS?=
 =?utf-8?B?bEoxV0dGeUlDRzlsMnhpSU5FRnZ3NWRvOHpkQUhiMG82czZmQ20zcFZxWXht?=
 =?utf-8?B?d1Izenc1b0pZWS9YcnFUTm5SeUVNS1pGUnRIUkNIV1JCYXBkRmtoNDV2b21x?=
 =?utf-8?B?aDVRTUNzbVRFSEp0bzlCUlZIV1hDSW9zVGh1bnNmem5xTGdSV0srTzBrRm5W?=
 =?utf-8?B?QVNEb0tJdnU3di9vZDBSdUxEYlJGRDZlSFpuaGNWZGtDNGNxWjhvUGp1Kzlp?=
 =?utf-8?B?WDd6ZGNFNTk3YkV5WkNaZ0dONEVQRFAvN21EN29rUkJwT0xpSGkrdEZjN3ZO?=
 =?utf-8?B?K3FxVGpncjVQRXJaWVVhMU5XakMwcTJqellYN2dwMjJuV2NEeEZzN3BBbDA4?=
 =?utf-8?B?dHdXLzAzVDVjYXRoRW9FVXc3VVhkYWxwZ3cyaTZNaHRyUTZQM3JvYmlEWGF5?=
 =?utf-8?B?QVp2RGlweHRlRUZISElBRkpsM0laYWdPWHdadDFzOUpEN3VNMFd1SmJIMkkz?=
 =?utf-8?B?YzliUG5RT2wvRVNxSFlVQW9JRkp4eTBEeGFya25ITEFENW8zdDM1UXdEY1BO?=
 =?utf-8?B?cHQwU0I0U0REa3BHb1E5UTQ1VW1PVW1ObDRjaS92QlcyMVFoSkk2S0kzMFV6?=
 =?utf-8?B?SnNnZ2xTYVpPZnEzbGgwdDNpdDVaZXQ0LzdyTi91ZzNFU3JOaWxwSXVQK1dV?=
 =?utf-8?B?UWgyeERKaDQ4Ym8zSE9DWDMxNU9wR1I0aVBhS1FiNDlwcHY3UytGdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d53a70-303d-4dba-5979-08df125ebabe
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:18.0171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4KER+j/mKO1HGodhI42Pz4v0WBfQvQIrIYBwytKn8E3gCk7EfthKyFIeT/Tw36MMPdKYvUkIhJJSAtAEz6Q1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7272

Add support for the UFS host controller on the NXP S32N79 SoC, built on
the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
UFSHCD platform glue.

This controller requires S32N79-specific initialization prior to
UIC_LINKSTARTUP, including:
  - programming SCM.ONE_US_TICK and HC.HCLKDIV based on the core clock,
  - applying the vendor-defined M-PHY calibration sequence, and
  - performing post-link calibration steps needed for HS operation.

The M-PHY supports several boot modes for loading its firmware. Only the
mode where the firmware runs from the internal ROM is supported for now.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/Kconfig         |  12 +
 drivers/ufs/host/Makefile        |   1 +
 drivers/ufs/host/ufs-nxp-s32n7.c | 538 +++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h    |  14 +-
 drivers/ufs/host/ufshci-dwc.h    |   6 +
 5 files changed, 569 insertions(+), 2 deletions(-)
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index ff170c0b6da0..e8ee7dd05f1a 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -168,3 +168,15 @@ config SCSI_UFS_AMD_VERSAL2
 
 	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
 	  If unsure, say N.
+
+config SCSI_UFS_S32N7
+	tristate "NXP S32N7 platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && (ARCH_S32 || COMPILE_TEST)
+	help
+	  This selects the S32N7 specific additions on top of the UFSHCD DWC
+	  and UFSHCD platform driver. UFS host on S32N79 needs some vendor
+	  specific configurations like PHY and vendor specific register accesses
+	  before accessing the hardware.
+
+	  Select this if you have UFS controller on an S32N7 based board.
+	  If unsure, say N.
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 7d8db67eb23c..a2f4a1d0b3ae 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -4,6 +4,7 @@ CONTEXT_ANALYSIS := y
 
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
+obj-$(CONFIG_SCSI_UFS_S32N7) += ufs-nxp-s32n7.o ufshcd-dwc.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
new file mode 100644
index 000000000000..7f8cc1673862
--- /dev/null
+++ b/drivers/ufs/host/ufs-nxp-s32n7.c
@@ -0,0 +1,538 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-3-Clause)
+/*
+ * Copyright 2026 NXP
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+
+#include "ufshcd-pltfrm.h"
+#include "ufshcd-dwc.h"
+#include "ufshci-dwc.h"
+
+/* SCM Register Offsets. */
+#define SCM_ONE_US_TICK			0x2CU
+#define SCM_STATUS			0x30
+
+/* SCM_ONE_US_TICK Register. */
+#define SCM_ONE_US_TICK_MASK		GENMASK(8, 0)
+
+/* SCM_MPHY_RAM_CONFIG_STATUS Register Fields. */
+#define SCM_STATUS_PHY_RESET_MASK		BIT(0)
+#define SCM_STATUS_SRAM_BYPASS_MASK		BIT(1)
+#define SCM_STATUS_SRAM_INIT_DONE_MASK		BIT(16)
+
+#define SCM_STATUS_PHY_RESET(val)		\
+	FIELD_PREP(SCM_STATUS_PHY_RESET_MASK, val)
+
+#define SCM_STATUS_SRAM_BYPASS(val)		\
+	FIELD_PREP(SCM_STATUS_SRAM_BYPASS_MASK, val)
+
+/* Timeout values. */
+#define CFG_MPHY_INIT_TIMEOUT_VALUE_US	3000000
+
+/* Clock validation limits. */
+#define MAX_VALID_ONE_US_TICK		SCM_ONE_US_TICK_MASK
+
+/* CPort definitions */
+#define CPORT_0				0
+
+/* Driver-defined timeout for completing a Hibern8 transition. */
+#define HBRN8_POLL_TOUT_MS      1000
+
+/**
+ * struct s32n_phy_reg - PHY CR (config-register) write entry
+ * @reg: Register offset/address
+ * @val: Value to write
+ */
+struct s32n_phy_reg {
+	u32 reg;
+	u32 val;
+};
+
+/**
+ * struct s32n_soc_data - SoC-specific configuration data
+ * @vops: UFS host controller variant operations
+ * @reset_config: MPHY reset DME attributes (programmed while PHY held in reset)
+ * @reset_config_count: number of entries in @reset_config
+ * @calib_mphy_disabled: CR calibration writes performed while the MPHY is disabled
+ * @calib_mphy_disabled_count: number of entries in @calib_mphy_disabled
+ * @calib_mphy_enabled: CR calibration writes performed while the MPHY is enabled
+ * @calib_mphy_enabled_count: number of entries in @calib_mphy_enabled
+ */
+struct s32n_soc_data {
+	const struct ufs_hba_variant_ops *vops;
+	const struct ufshcd_dme_attr_val *reset_config;
+	size_t reset_config_count;
+	const struct s32n_phy_reg *calib_mphy_disabled;
+	size_t calib_mphy_disabled_count;
+	const struct s32n_phy_reg *calib_mphy_enabled;
+	size_t calib_mphy_enabled_count;
+};
+
+/**
+ * struct s32n_ufs - S32N7 UFS host controller data
+ * @hba: UFS host controller instance
+ * @reg_scm: SCM register base address
+ * @core_clk: core reference clock used to derive ONE_US_TICK/HCLKDIV
+ * @soc_data: SoC-specific configuration data
+ */
+struct s32n_ufs {
+	struct ufs_hba *hba;
+	void __iomem *reg_scm;
+	struct clk *core_clk;
+	const struct s32n_soc_data *soc_data;
+};
+
+/**
+ * ufs_s32n_phy_write_sequence - Write a sequence of PHY registers
+ * @hba: UFS host controller instance
+ * @cfg: Array of register configurations
+ * @count: Number of entries in the array
+ *
+ * Return: 0 on success, error code on failure
+ */
+static int ufs_s32n_phy_write_sequence(struct ufs_hba *hba,
+				       const struct s32n_phy_reg *cfg,
+				       size_t count)
+{
+	int ret;
+	size_t i;
+
+	for (i = 0; i < count; i++) {
+		ret = ufshcd_dwc_phy_reg_write(hba, cfg[i].reg, cfg[i].val);
+		if (ret) {
+			dev_err(hba->dev,
+				"Failed to write PHY reg 0x%x = 0x%x (step %zu)\n",
+				cfg[i].reg, cfg[i].val, i);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static unsigned long ufs_s32n_calculate_us_tick(unsigned long clk_rate)
+{
+	return clk_rate / USEC_PER_SEC;
+}
+
+static int ufs_s32n_configure_clocks(struct ufs_hba *hba)
+{
+	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	unsigned long clk_rate = 0;
+	unsigned long one_us_tick;
+
+	clk_rate = clk_get_rate(ufs->core_clk);
+	if (!clk_rate) {
+		dev_err(dev, "Failed to get valid clock rate.\n");
+		return -EINVAL;
+	}
+
+	one_us_tick = ufs_s32n_calculate_us_tick(clk_rate);
+	if (one_us_tick == 0 || one_us_tick > MAX_VALID_ONE_US_TICK) {
+		dev_err(dev, "Invalid one_us_tick value: %lu (clk_rate: %lu Hz).\n",
+			one_us_tick, clk_rate);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "Core clock rate: %lu Hz, one_us_tick = %lu.\n",
+		 clk_rate, one_us_tick);
+
+	/*
+	 * Configure the micro-second tick rate generator based on core
+	 * clock rate.
+	 */
+	writel(one_us_tick, ufs->reg_scm + SCM_ONE_US_TICK);
+	ufshcd_dwc_program_clk_div(hba, one_us_tick);
+
+	return 0;
+}
+
+static int ufs_s32n_hce_enable_notify(struct ufs_hba *hba,
+				      enum ufs_notify_change_status status)
+{
+	u32 reg;
+
+	if (status != POST_CHANGE)
+		return 0;
+
+	/*
+	 * Clear the DWC low-power gating (BUSTHRTL) so a doorbell write can
+	 * wake the link out of hibernate. LP_PGE (generic low-power) and
+	 * LP_AH8_PGE (Auto-Hibern8) both reset to 1.
+	 */
+	reg = ufshcd_readl(hba, DWC_UFS_REG_BUSTHRTL);
+	reg &= ~(DWC_UFS_BUSTHRTL_LP_PGE | DWC_UFS_BUSTHRTL_LP_AH8_PGE);
+	ufshcd_writel(hba, reg, DWC_UFS_REG_BUSTHRTL);
+
+	return 0;
+}
+
+static int ufs_s32n_phy_initial_calib(struct ufs_hba *hba)
+{
+	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
+	int ret;
+
+	/* Calibrations that must run while the MPHY is disabled. */
+	ret = ufs_s32n_phy_write_sequence(hba, ufs->soc_data->calib_mphy_disabled,
+					  ufs->soc_data->calib_mphy_disabled_count);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYDISABLE, 0), 0x0);
+	if (ret)
+		return ret;
+
+	/* Calibrations that must run while the MPHY is enabled. */
+	ret = ufs_s32n_phy_write_sequence(hba, ufs->soc_data->calib_mphy_enabled,
+					  ufs->soc_data->calib_mphy_enabled_count);
+	if (ret)
+		return ret;
+
+	return ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+}
+
+static int ufs_s32n_link_startup_pre_change(struct ufs_hba *hba)
+{
+	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	int ret;
+	u32 reg;
+
+	ret = ufs_s32n_configure_clocks(hba);
+	if (ret)
+		return ret;
+
+	/* Reset SCM.MPHY_RAM_CONFIG_STATUS to default value; keep MPHY in reset. */
+	writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
+
+	/*
+	 * The M-PHY firmware runs from the internal ROM:
+	 *  MPHY_RAM_CONFIG_STATUS.SRAM_BYPASS = 1
+	 *  MPHY_RAM_CONFIG_STATUS.SRAM_EXT_LD_DONE = 0
+	 */
+	writel(SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1),
+	       ufs->reg_scm + SCM_STATUS);
+
+	/* MPHY reset configuration: vendor attributes set while PHY in reset. */
+	ret = ufshcd_dwc_dme_set_attrs(hba, ufs->soc_data->reset_config,
+				       ufs->soc_data->reset_config_count);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* Release PHY_RESET. */
+	writel(readl(ufs->reg_scm + SCM_STATUS) & ~SCM_STATUS_PHY_RESET_MASK,
+	       ufs->reg_scm + SCM_STATUS);
+
+	/* Wait until SRAM_INIT_DONE = 1. */
+	ret = readl_poll_timeout(ufs->reg_scm + SCM_STATUS, reg,
+			reg & SCM_STATUS_SRAM_INIT_DONE_MASK,
+			1000, CFG_MPHY_INIT_TIMEOUT_VALUE_US);
+	if (ret) {
+		dev_err(dev, "UFS MPHY init not done!\n");
+		return ret;
+	}
+
+	/* Start of initial calibration */
+	ret = ufs_s32n_phy_initial_calib(hba);
+	if (ret) {
+		dev_err(dev, "UFS MPHY initial calibration failed!\n");
+		return ret;
+	}
+
+	/* End of Gear1 settings */
+
+	return ufshcd_dme_check_tx_hibern8(hba, hba->lanes_per_direction,
+					   HBRN8_POLL_TOUT_MS);
+}
+
+static int ufs_s32n_link_startup_post_change(struct ufs_hba *hba)
+{
+	static const struct ufshcd_dme_attr_val cport_setup[] = {
+		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
+				CPORT_IDLE, DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(T_CPORTFLAGS, CPORT_0),
+				CPORT_DEF_FLAGS, DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
+				CPORT_CONNECTED, DME_LOCAL },
+	};
+	unsigned int data = 0;
+	int ret;
+
+	/* Network layer: set Local DeviceID. */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
+	if (ret)
+		return ret;
+
+	/* Set Connection State to IDLE (it allows CPort Attributes to be set). */
+	ret = ufshcd_dwc_dme_set_attrs(hba, cport_setup, ARRAY_SIZE(cport_setup));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0), &data);
+	if (ret)
+		return ret;
+
+	if (data != CPORT_CONNECTED)
+		return -EIO;
+
+	return 0;
+}
+
+static int ufs_s32n_link_startup_notify(struct ufs_hba *hba,
+			     enum ufs_notify_change_status status)
+{
+	int err;
+
+	if (status == PRE_CHANGE) {
+		err = ufs_s32n_link_startup_pre_change(hba);
+		if (err) {
+			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
+			return err;
+		}
+		return 0;
+	}
+
+	/* POST_CHANGE */
+	err = ufshcd_dwc_link_is_up(hba);
+	if (err) {
+		dev_err(hba->dev, "Link is not up.\n");
+		return err;
+	}
+
+	err = ufs_s32n_link_startup_post_change(hba);
+	if (err)
+		dev_err(hba->dev, "Connection setup failed (%d).\n", err);
+
+	return err;
+}
+
+static int ufs_s32n_pwr_change_pre_change(struct ufs_hba *hba,
+					  const struct ufs_pa_layer_attr *pwr)
+{
+	/*
+	 * RX rate-select override sequence: assert the override, then deassert
+	 * the value, then drop the override enable so normal operation resumes.
+	 */
+	static const struct s32n_phy_reg pwr_change_phy_regs[] = {
+		{ RX_OVRD_IN_1(0), 0xc },
+		{ RX_OVRD_IN_1(1), 0xc },
+		{ RX_OVRD_IN_1(0), 0x8 },
+		{ RX_OVRD_IN_1(1), 0x8 },
+		{ RX_OVRD_IN_1(0), 0x0 },
+		{ RX_OVRD_IN_1(1), 0x0 },
+	};
+	u32 rate;
+	int ret;
+
+	/* Rate change only applies to the HS power modes. */
+	if (!ufshcd_is_hs_mode(pwr))
+		return 0;
+
+	/*
+	 * Select the M-PHY rate (rate series) that matches the mode the core
+	 * has negotiated with the device.
+	 */
+	rate = (pwr->hs_rate == PA_HS_MODE_B) ? CB_RATE_B : CB_RATE_A;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBRATESEL, 0), rate);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
+	if (ret)
+		return ret;
+
+	/* Apply the RX rate-select override now that the target rate is set. */
+	return ufs_s32n_phy_write_sequence(hba, pwr_change_phy_regs,
+					   ARRAY_SIZE(pwr_change_phy_regs));
+}
+
+static int ufs_s32n_pwr_change_notify(struct ufs_hba *hba,
+				      enum ufs_notify_change_status status,
+				      struct ufs_pa_layer_attr *pwr)
+{
+	int err = 0;
+
+	if (status == PRE_CHANGE) {
+		err = ufs_s32n_pwr_change_pre_change(hba, pwr);
+		if (err)
+			dev_err(hba->dev, "Power mode pre-change failed (%d).\n",
+				err);
+	}
+
+	return err;
+}
+
+static int ufs_s32n_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s32n_ufs *ufs;
+
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	ufs->hba = hba;
+	ufs->soc_data = device_get_match_data(dev);
+	if (!ufs->soc_data)
+		return -ENODEV;
+
+	hba->quirks |= UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
+	hba->spm_lvl = UFS_PM_LVL_5;
+
+	ufs->reg_scm = devm_platform_ioremap_resource_byname(pdev, "scm");
+	if (IS_ERR(ufs->reg_scm))
+		return dev_err_probe(dev, PTR_ERR(ufs->reg_scm),
+				     "ioremap failed for SCM registers.\n");
+
+	ufs->core_clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(ufs->core_clk))
+		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
+				     "Failed to get core clock.\n");
+
+	ufshcd_set_variant(hba, ufs);
+
+	return 0;
+}
+
+static const struct ufs_hba_variant_ops ufs_hba_s32n79_vops = {
+	.name = "s32n79",
+	.init = ufs_s32n_init,
+	.link_startup_notify = ufs_s32n_link_startup_notify,
+	.hce_enable_notify = ufs_s32n_hce_enable_notify,
+	.pwr_change_notify = ufs_s32n_pwr_change_notify,
+};
+
+/*
+ * MPHY reset configuration: vendor DME attributes programmed while the PHY is
+ * held in reset. Programs the reference-clock, RX squelch, RX Rhold and
+ * CR-parallel control attributes.
+ */
+static const struct ufshcd_dme_attr_val s32n79_reset_config[] = {
+	/*
+	 * Disable reference clock gating support and override the UniPro and
+	 * application reference clock enable inputs to 0.
+	 */
+	{ UIC_ARG_MIB_SEL(CBREFCLKCTRL2, 0), 0x8A, DME_LOCAL },
+	/* RX squelch control. */
+	{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN0_RX), 0x1, DME_LOCAL },
+	{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN1_RX), 0x1, DME_LOCAL },
+	/* RX Rhold control option. */
+	{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN0_RX), 0x2, DME_LOCAL },
+	{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN1_RX), 0x2, DME_LOCAL },
+	/* CR parallel selection. */
+	{ UIC_ARG_MIB_SEL(CBCRCTRL, 0), 0x1, DME_LOCAL },
+};
+
+/* Calibrations that must run while the MPHY is disabled. */
+static const struct s32n_phy_reg s32n79_calib_mphy_disabled[] = {
+	/* Bypass RX AFE calibration. */
+	{ FAST_FLAGS(0), 0x4 },
+	{ FAST_FLAGS(1), 0x4 },
+};
+
+/* Calibrations that must run while the MPHY is enabled. */
+static const struct s32n_phy_reg s32n79_calib_mphy_enabled[] = {
+	/* Write ATT offset compensation code to internal DAC. */
+	{ RX_DAC_CTRL_OVRD(0), 0x1 },
+	{ RX_DAC_CTRL_OVRD(1), 0x1 },
+	{ RX_DAC_CTRL(0), 0x8E },
+	{ RX_DAC_CTRL(1), 0x91 },
+	{ RX_DAC_CTRL_SEL(0), 0x1 },
+	{ RX_DAC_CTRL_SEL(1), 0x1 },
+	{ RX_DAC_CTRL_EN(0), 0x1 },
+	{ RX_DAC_CTRL_EN(1), 0x1 },
+	{ RX_DAC_CTRL_OVRD(0), 0x0 },
+	{ RX_DAC_CTRL_OVRD(1), 0x0 },
+	/* Write CTLE offset compensation code to internal DAC. */
+	{ RX_DAC_CTRL_OVRD(0), 0x1 },
+	{ RX_DAC_CTRL_OVRD(1), 0x1 },
+	{ RX_DAC_CTRL(0), 0x71 },
+	{ RX_DAC_CTRL(1), 0x7F },
+	{ RX_DAC_CTRL_SEL(0), 0x2 },
+	{ RX_DAC_CTRL_SEL(1), 0x2 },
+	{ RX_DAC_CTRL_EN(0), 0x1 },
+	{ RX_DAC_CTRL_EN(1), 0x1 },
+	{ RX_DAC_CTRL_OVRD(0), 0x0 },
+	{ RX_DAC_CTRL_OVRD(1), 0x0 },
+	/* FW Calibration configuration. */
+	{ FW_CALIB_CCFG(0), 0x100 },
+	{ FW_CALIB_CCFG(1), 0x100 },
+};
+
+static const struct s32n_soc_data s32n79_soc_data = {
+	.vops = &ufs_hba_s32n79_vops,
+	.reset_config = s32n79_reset_config,
+	.reset_config_count = ARRAY_SIZE(s32n79_reset_config),
+	.calib_mphy_disabled = s32n79_calib_mphy_disabled,
+	.calib_mphy_disabled_count = ARRAY_SIZE(s32n79_calib_mphy_disabled),
+	.calib_mphy_enabled = s32n79_calib_mphy_enabled,
+	.calib_mphy_enabled_count = ARRAY_SIZE(s32n79_calib_mphy_enabled),
+};
+
+static const struct of_device_id ufs_s32n7_match[] = {
+	{
+		.compatible = "nxp,s32n79-ufshc",
+		.data = &s32n79_soc_data,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ufs_s32n7_match);
+
+static int ufs_s32n7_probe(struct platform_device *pdev)
+{
+	const struct s32n_soc_data *soc_data;
+
+	soc_data = device_get_match_data(&pdev->dev);
+	if (!soc_data)
+		return -ENODEV;
+
+	return ufshcd_pltfrm_init(pdev, soc_data->vops);
+}
+
+static void ufs_s32n7_remove(struct platform_device *pdev)
+{
+	ufshcd_pltfrm_remove(pdev);
+}
+
+static const struct dev_pm_ops ufs_s32n7_pm_ops = {
+	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	.prepare	= ufshcd_suspend_prepare,
+	.complete	= ufshcd_resume_complete,
+};
+
+static struct platform_driver ufs_s32n7_driver = {
+	.probe = ufs_s32n7_probe,
+	.remove = ufs_s32n7_remove,
+	.driver	= {
+		.name	= "ufs-s32n7",
+		.pm	= pm_ptr(&ufs_s32n7_pm_ops),
+		.of_match_table	= ufs_s32n7_match,
+	},
+};
+
+module_platform_driver(ufs_s32n7_driver);
+
+MODULE_AUTHOR("Larisa Grigore <larisa.grigore@oss.nxp.com>");
+MODULE_DESCRIPTION("NXP S32N7 UFS Host Controller platform driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 53b523ef59df..d62cd4c085ba 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -13,8 +13,8 @@
 #include <ufs/ufshcd.h>
 
 /* RMMI Attributes */
-#define CBREFCLKCTRL2		0x8132
-#define CBCRCTRL		0x811F
+#define RXSQCONTROL		0x8009
+#define RXRHOLDCTRLOPT		0x8013
 #define CBC10DIRECTCONF2	0x810E
 #define CBRATESEL		0x8114
 #define CBCREGADDRLSB		0x8116
@@ -24,10 +24,20 @@
 #define CBCREGRDLSB		0x811A
 #define CBCREGRDMSB		0x811B
 #define CBCREGRDWRSEL		0x811C
+#define CBCRCTRL		0x811F
+#define CBREFCLKCTRL2		0x8132
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
+/* CBRATESEL: 0 - rate A, 1 - rate B. */
+#define CB_RATE_A		0x0
+#define CB_RATE_B		0x1
+
 /* M-PHY registers */
+#define RX_DAC_CTRL(n)		(0x10AF + ((n) * 0x100))
+#define RX_DAC_CTRL_OVRD(n)	(0x10B0 + ((n) * 0x100))
+#define RX_DAC_CTRL_SEL(n)	(0x10B1 + ((n) * 0x100))
+#define RX_DAC_CTRL_EN(n)	(0x10B8 + ((n) * 0x100))
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
 #define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
diff --git a/drivers/ufs/host/ufshci-dwc.h b/drivers/ufs/host/ufshci-dwc.h
index 6c290e272106..c66f33391b65 100644
--- a/drivers/ufs/host/ufshci-dwc.h
+++ b/drivers/ufs/host/ufshci-dwc.h
@@ -12,9 +12,15 @@
 
 /* DWC HC UFSHCI specific Registers */
 enum dwc_specific_registers {
+	DWC_UFS_REG_BUSTHRTL	= 0xC0,
 	DWC_UFS_REG_HCLKDIV	= 0xFC,
 };
 
+/* Low-Power Power Gating Enable. */
+#define DWC_UFS_BUSTHRTL_LP_PGE		BIT(16)
+/* Low Power - AH8 Power Gating Enable. */
+#define DWC_UFS_BUSTHRTL_LP_AH8_PGE	BIT(17)
+
 /* Clock Divider Values: Hex equivalent of frequency in MHz */
 enum clk_div_values {
 	DWC_UFS_REG_HCLKDIV_DIV_62_5	= 0x3e,
-- 
2.43.0

