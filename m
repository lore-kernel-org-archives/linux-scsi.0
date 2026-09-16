Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011054.outbound.protection.outlook.com [52.101.70.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360B2488229;
	Wed, 16 Sep 2026 08:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548298; cv=fail; b=gjZxcbpbPnyMt5M5pdaKsfGR5gDMSURpsGZ1DhvKrrZQokefA2beuGKR/7Bfmg7+I63IgsLjwODi6fbOQ30M5jcfz7ZxKTAJGvps2EEi/thB4g8QXX1DtmNuLC51g3plpmal2T8a3or53/vBVcQC/a7hrM14AXCnjQe5u2fOQak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548298; c=relaxed/simple;
	bh=N3b8yvZL8nOr1bSjt359XhvxmXu8OPq8MUm5GsZ50P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bKCM3wswCeZ8Y/E9V0x0/3OMcjdAVvsx9HkhVaYcxZB2qguB3W6KYc5Pn4320MciVk89ArV4F7MjRl+HjW2BgFblG98J1VpRB6XqVFC0866M/6wRhoSdCZIfenfmhOORZazhqyyETp9qyb83a9seZ0NC7c/QHyrfWHur25GB0KM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=G9ZbvvjA; arc=fail smtp.client-ip=52.101.70.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="G9ZbvvjA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhx8Hl1DaUbMD/OCr/p24F/xRo+AqVEN388HeFZDP5F+AYhIReP+JLseJRqjR8zm691FB46JmOGNb890m/9O2A50WiAEv/MWHovpBsPSt4AYkoDHBzI5eNrSWfz0u7m4nNFA/txNFJw/pu0cDgA9+XN0X49Nv5fFBiPR2goqpYajr06fb7HRjzMRjT912AaYRGOMXXYONXgtAu8ubL2/OEJ+saM52ftWE5G36f8cLzV7GvcRvafTLdZPA88f2x8J5P/rOIAXcu9uLORYAp3tmjeU75OLIl8spIXIE9bQXISijSHfVZUxpKuEi4c33E6Nwxx9LVKbt9Vy5y0I42VyXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1fYQlKK4Z5jSC4WP88E0Oc7f/fULS2/pKPT2PzeWXM=;
 b=Ol1Z06UTF+evxKiZDkkpeqrAHR29rbQQpOlAawsY/1Slj/tVNti5DEW7eC2jElodchsPKd/qRHPw3KgBhZaCmLfFIjjzwujf/xnnQiYlllh1bACEQ1W5L4qXynmrpiB+ZaDx9zr/kDrn0q7whxKQMdNpdIYQoobH3KabAkQzskOb5an3eyLviRjOzFpWjGj/c5zCLFqkXXsVyk+bVZe8TzgY+5DyHNthXkUm5Rj/72rDL3ImsbosKqwxNaEOXGFNaxRjvyf54zCCeK7qMiMOA0JfklkhljZNdibNa2CKAFSBALPUXARtrxhAsAKLnz5kUkiI/wiuTJf2vnKo5lQGgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1fYQlKK4Z5jSC4WP88E0Oc7f/fULS2/pKPT2PzeWXM=;
 b=G9ZbvvjAP7myXJCw5ePUruVvbmPJMxhmm8GyKf6ZbkH37jBss45YabWdtWR1Bk1mcOXXepz4iVfzYV/kplY94njBRPVT+kmQU/UrocIgrBPohug3azj9l+PcFFujCOCJKAvI2/MtGOkJoq6Fyf6/MLbCsJuRPuvf2JtbDA37ExfldZfhmuqrRjXy6ySNN4vf/dNKGSGEgAJyHJ9Twtt+h/x8fy9Ch/Kx2dx0C2bYq1AMhcZxkJTA/hHPRpXax6J2bXGPY5otNA42EVF9YBeiueMTQqmexg20t9743zYwRsB1DPHJmsIay7WQxMvwgmzjoL6zJOGm+X2N4tMKjjw4Sg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:35 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:35 +0000
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
	=?UTF-8?q?Pedro=20Sousa=20=C2=A0?= <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v3 10/10] MAINTAINERS: Add NXP S32N7 UFS host controller entry
Date: Wed, 16 Sep 2026 10:44:11 +0200
Message-ID: <20260916084411.941297-11-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P190CA0020.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::25) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DUZPR04MB9981:EE_
X-MS-Office365-Filtering-Correlation-Id: e97a9df9-3727-4df2-4df7-08df13cebc6e
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 2dZxZD7z486S9WSjxSqabL9WIfvPvF1qz51jiC+hYK3pLH8PT3Y5+EuCJaRlzASTEQtBg84t4m4vWsEPSBMfg5fJ+QkqxEegkNWyjSS7hCr1xTwEB7L5YfZdXiWWKP7MWQMhfKJ5UnHIx54wvJXOIghyWIEqoG8vZkIFX3CRezuFb5syy62Hbx1z5a3Hks3cqq7vgyXQB+q4uDAXNbXL4i2OxmuIe3ISFfT4JDQjKHeXWZ66Q6cL1De/aPhRiZGkoA887kGEqEq5KrxGOOwEWQ6pYZtI5wXwx8HjaPhCh9k0IwLMTjs2FqE8Pp7WADheIOFiFHgCwxt98mvfFs1XQAMv94ZjJFtJPJY3ZlpB2caAVqnTC/rCgHHNZSCEWNyitbFMZA5zHzvmF6Hd2JjGrXpd4QF9uheehK6WzrSc007Njn6EoXJSI7FQAb+P5CvkZT7BGPix0sNv4U0TIAdVzUiDPSmTmVFDtBCkteTsh683k1zlXK1WNzV46pYIr9UNq7XVWByLd9JMMzNVG+wkcnQl9sTv0QI0oELFwgMNv3Tndp3sLLWGKxM8M9nqq8DEGWqB2cmH2Y+1Env851VdGB3eSRWONPt1Xh11WJTzY7vDhRcQK1MPGtwiP5M+Kq/kmIyZGXT/vKST7WJsaWG34W7NWs3OCgdsSydSHtqBTi/pCHBupZsBxoXTT8tjyIK9B+VKg6XmmPA/DWJUefrkNQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c2dwYVZkaUFtbUNHRTBjYytFM2M1Njkza25mVW54UFNVNTMxTWVablh5ejNM?=
 =?utf-8?B?Q1JSY3VXcW9rS1lwblRWN0dpSlpIVzIyZUxoSGNTc1dJSk9lelBUc3Y2eUI4?=
 =?utf-8?B?TExyN1JtajFSd2toVkJKWnZyV0pPajJoY1BzMG9QaVNYdTJkcEo1SWtuV2FY?=
 =?utf-8?B?UktkbGtkd0krUFdpWFFsdzVqTmhOZ2tWVk9GRTBueWZ1enJmNzUvcHQwL3RP?=
 =?utf-8?B?TjNwR0VnTnhqd2twNHpIS0Z0bkVSa2lvNi9rU09Hc05qc1I4VHdoV2RISVdY?=
 =?utf-8?B?VUltZFFxbkt2T3NTakswWnBQZFgxMjVpdGFqYWVXVnlhbXFUdVZ0Y2EyL1FH?=
 =?utf-8?B?SC9aRzB4V0pZKzJacCtkZ3pHNUk2ZW9CTTY0L1lPQVVVUHNnTEovQ3lFR0t1?=
 =?utf-8?B?UjdkSndiQXVET1J4SzZyMEhWeHcwS0t1VHhnYnJ2b1h1TWZqWEw5cW1NTmJW?=
 =?utf-8?B?R0NnalVwWGNFSW82dnIvbC9nS0ZmUHhjVHljZjVHSFk3eThROFBBdHhtaDdM?=
 =?utf-8?B?OEdlU3hoWnEyckJCWHE2SEFGdktmUkk4YW50aE5FajlTc1VvQmg1Yk5pM0Vh?=
 =?utf-8?B?S0NtMG9IeExmMmE3eUxBNWRDZDhZMzhzaUphWHp5VFkyWHRBT24rcERNY3Uv?=
 =?utf-8?B?VG9qa25rZ2MzZERZYmlkSWNPa1F6MXBzcnROTXZTMno0a2oxNGF5OFRMUVNQ?=
 =?utf-8?B?dlpjQ05nd055aDE1NytBWmtPczNWMjlvRmZGbi9PQjk3dnRad05RVHg0Wnl3?=
 =?utf-8?B?N3JJUFJUMUNVcForVjRWcUJPSnp0dWUrczhhM2c3emNROXpwTURkZitRcXFr?=
 =?utf-8?B?YUJEWEVhbGJRVGwxZmw2Z2FOOGxrY1g2eXdGUllra2FjeEZqVGE3OWQ5ZGh6?=
 =?utf-8?B?VEtZYjdKbXdlVWpXRU5UYnBKVHRlODFXdzBJLzBONllrdHRkMGNGZ0l6YWVV?=
 =?utf-8?B?UUxLeGFxOUttSjNrcm8zWkVKczlSNmRmSzg2bEdaQ3dwMXBUYW5IRUlTcUdH?=
 =?utf-8?B?MGF5TUpJV1Zsekt2TGUvUlJYM3JKVVY2dkJzb05SL1FOUnVJbjJUVXY1UkZ5?=
 =?utf-8?B?SC8zNlhmbktQYVVJU1FuWkZSc0wxYy9ac01HdE5lRW10SmIvRUprMGJ3eExr?=
 =?utf-8?B?K1Q2cTBycHBCY3FCd3duQ3Y1ZTV6VlQ4eW1rUnQrTFQvMGx2Yll4SzhndE0v?=
 =?utf-8?B?aXhaajdodGZ6anFueWg0em1xQzljLzNyU1Z1NGtneXp0U1RFVTVkSzZ5bThT?=
 =?utf-8?B?MWJtQnpLcm84bWdEdnBtYlBpMzlFTmFLMkN2YlpyaGcvVlZKZmF6T0l0YjlL?=
 =?utf-8?B?QlZxdVpMQW9aa0tCWi9paElLZDVlaEdZMlJxbmIrZVNZTkZLWW9IL0haeUFS?=
 =?utf-8?B?dlBqN29TekZKVzMrWm51b3pHVHp5UUsxRmk4NTlmeHNOTS9TTkVTMjNNOFI3?=
 =?utf-8?B?K1Y1TUE0amV2ZDVEb2VhRk9WVm90NTI1cXJzVlZORFV6WkpvL2NBNEZaL0Qz?=
 =?utf-8?B?ZGxNbzVKbDJhc1NLaWZMZ2xRei9MZWNqdGV0UnZRcDFVaTZzQ1ZXSHRMS0xp?=
 =?utf-8?B?eUdUaE9wZnYvYUFmaTF6Qld0T2lGVHE3TE1QOWdqUDk4cm1jd2hNZTdZWXJj?=
 =?utf-8?B?VTZDSFRzamppeU9KWTlVL3lpWmg4SURjQVYwWWQ1ZjJDc1dpWE9tSXU5QkJP?=
 =?utf-8?B?OW9xOStVSnpwaElZVzJWOFJhc29jSTBPalhOUjJGL3FPYmFwUWEvd2pHM2g0?=
 =?utf-8?B?VVc0dnBqZ3RzdDhNKzBhSlVLQ3REQTVTcEdpZnk5MVFBbDZ0MnVOM3lXVzF0?=
 =?utf-8?B?dGRKNVhWd3hLRStEUHFuQmxJcWI0TGF3OFlXOVF6ZklDU2hreUhOUExiaDU2?=
 =?utf-8?B?TVNiVXhZNUNOWTY2K0RUaGVDK2VNZG1OQ3J0a2FoZjMvd3ZjcEh4SUpXMllH?=
 =?utf-8?B?RyttcFF6OGpVbGNYZ3VscVMyNW5BOXpNZTd5bkZUTHd5em9XMjRYZmZLK1Aw?=
 =?utf-8?B?OURqRktMQ2lxTDJWQmtXdnloYTkrNVNYcnNiQzBoYmo1VHVjcDlXQUtkN3pS?=
 =?utf-8?B?K294QlFPcHpJNWtpN2xYdUVnbTRBNDFwV2VOamFkRWkwc21VbFQrYTFkTzVU?=
 =?utf-8?B?UkVZTXdhZG9WMFkwOTN6ZytvN1NBZlRPQ2JEMGZyT2MyQzgwQWpxU1pjRy9o?=
 =?utf-8?B?cUs1NW1XN080T1pKcmRsNW1XN0ZDb0R2WXc0TitmTEZ4VHEyU1MwUFpvRzJC?=
 =?utf-8?B?RlVEdkVxbHhBdk5KaTkvaFhRcVc1alo0UVRZOWZWbHkxcnhnVmI0RHM0eXdQ?=
 =?utf-8?B?VXlKNllDelkybGRxRjl4c1lra3hNenNZSHJDN09RWktJZlhQc2ZJU3Rsbzdh?=
 =?utf-8?Q?K1uu7orlHFRqOlro=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e97a9df9-3727-4df2-4df7-08df13cebc6e
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:35.6166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHuu7889wvvNawrOV19Jn90VJrrmlidG06NxAkTaNVQTq1+sT1c/50fYUionlCcJavUjWqAvV1tEOQxwn4oVGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b2eb2a7a89a..32b01db895f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28096,6 +28096,14 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
+M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
+F:	drivers/ufs/host/ufs-nxp-s32n7.c
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.43.0

