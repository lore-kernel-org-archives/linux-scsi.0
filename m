Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C7F4A0F06;
	Mon, 14 Sep 2026 12:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390241; cv=fail; b=ee1ALGdKWRwvrNusDOSEXoKTXx2TBsDygI2/zUXql3poYX2RbMyM2l3HOyyZH62GS4CFUFQkOenVdPIZ4Sz0gpdRRaScCfAgoZOi9Rm9P50gpdO6q5sc67BcejhwhDLKfgr+v3dXYSrVmyEs7JfY8JSoc9iRfoZCmxj8z3LrePg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390241; c=relaxed/simple;
	bh=juXj1I8B7u57Y0ENsQVsFG8dR2ScyiVuBuUc9TmzcxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IU2kxvZYqPdM9Ea+mfiBJxsJusZI2UM6MsVzJlqV6356iaCRg9g5U/rMSrSeNhTBfgQ82pjXPm49x6rp3GRe8OlGo4FjyQw7CC10JYU46F+swyUbL2ZozWCC6qGNHXeJofucssGB9WGi1ov0U7M+O+ljRoVHhWrU7AxJgkIiFwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=vm3VsW03; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="vm3VsW03"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nux1LCG2xF2HcPQ43kiMSssYTGdEyEBmJQHJ5LUq8x+ktOMYy2E0wxIt5uC80gO8RFKbuLSjDBn0TQneYJ9YV9hUzXAQEDIJf+9XlS5RpL1h11qhHlnX5djTrL0d0zowKF2Yi8ATgYyKnk6QC9Hrrl2fl08uqGiJqKDFcWK6b4mXRLMERNDgr6Vui+FUcWlKJ0bT7U74zxO7V5obxSoETw8aFWOYBpFlFOkWixQsKvrE7oMdfHmYqYsA8h+azJlhvOvp7z0D37Oj5G+fm7MIPzk2scd8t2Qi7k+ALfT5faF8STmxmrQ9vLYE2PmjYxrTMGe7VILuflBs1adsYHP3gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWXony8wfdi5n1afM62kho0v7L1pj1ntzEmpUhQXVOI=;
 b=YPMqMiOWPaRHhx1RrawyYc+p+g38BB9yacolmQC+Oq79bWLN7YevplQ4d5iJfoMZ5ixrE3ttclOaJkSY6hGAg/k4eXZmsQsbVhXSGmNN31tth1ILNb72ln2lgXhupKKrKSMvq6306xYAy/FJvc9xlvnRrqfMZaGrKm5U6N0g6ro7ONIi1eMwpW8CjORfN4zBa5NUm50w7fsscxtQFr9ocSLuKPifSWYrIHFx4rm7nOnQDx0jl/FxqJXpWZ9IcwIyIs91qvy9M1mDsWVzCUT5mnpjdouNNrzYCVPphVL6dpmzzw/ClERUKmmFg5BzrDJH/9tgN3aaaapKn57HX1jS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWXony8wfdi5n1afM62kho0v7L1pj1ntzEmpUhQXVOI=;
 b=vm3VsW03daSxW1yQJmgly6IsLarU3V0tgaHGQZNpHZrXU61pDpx24MxyXlZmQRGR/FscS8EySkSeG0SnWwGdfucQs6kbC4Xb+Of1WKQYu5AHvxgvWTY1vqUaFNVfY/XC3A/ryH/TuV21FIPCnq5H343jd4pIGIoX0eH4hia+dDhxbYJh2QNFIj/zc4uN8cW2Rb12X1u/FpQfRVjhBG25019lRk4tIIgsjb6qY812mddvT/GXFgOMsglR+ST+hZgCx8wCfQ0TEW/qPurkH/Iynzz3qnYiVw4/6mPqcGmtThPXA27g8BoQ8QBKYGkkDYhAvefh31xJjPB4nsuIf31Ryw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7272.eurprd04.prod.outlook.com
 (2603:10a6:10:1ad::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:23 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:23 +0000
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
Subject: [PATCH v2 10/10] MAINTAINERS: Add NXP S32N7 UFS host controller entry
Date: Mon, 14 Sep 2026 14:50:00 +0200
Message-ID: <20260914125000.30812-11-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0018.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::28) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: d5129964-362d-47a8-11c6-08df125ebdff
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 jsCkgZz02a5uxpckLUv2kSDNapqtjGBUTC+Q6XVoFu8kQL7xbFnU1spY0HjifKPwX1fIqE4T4Jq4h7jwtuyHPW1rhOi7jGp2XO62Cjt/PjvFIP+SB02mfghogt9jynzvrUHs7WSVQd/u5GZfTem6+VtP8jtBHU8yMZxhQSJ6ozhwdx9yFeXgIt/uAmhscQnaJjjiEtylu52W9wK8hnWNQDLxiz1f8OhfXS1vDxxGj3kN6YeAruMwO+43I03W2m70mexlURc9PBp7AKyGKmJCbOHFHC9dxWnZwmM+B9Ypc7YjKu4TUvTqUo1ukMlPis55OZW93tJOfOqpQdCdtd2sIbELdnWx7Ebaptul1VfjI2bhe9wIXhPdqa8TFrr0+igOL+YHTgeGv4FtoBNQFyJ0OUTM4dJqV1X2Mt7hlYgmaGsty7vpjDctTPg556uejFcft7Y1lHujAVSHMKO2dGYLG1b/3aQRnhD+QVjy+5YOKy+IS0sa3TAOgJR9htpf08Rezqaj3VbNaBFUZejjDHgaiF6kFdBv0XHuHi3gbFD4raqLmea0wJ2l9A85USPrt9lrz8vdYRP4ECQrrc5I8vbD5pqkIKCD0bgeCX7j81soEvrcVy2XBwVcSk8ajO469u7b6shTS2oDI+VKgkZ34Of/DbLh1Txi8avReFuba9vEQUqfHFLiJXB7lwlIKFhSxMCScY1WL40gIRwWOpZz3szCsw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bHlmbGRwMHdIMlJHaGhCbms5aHJDTVYvODJsNS8wWXpVRzZneHBrZ1pkZzVB?=
 =?utf-8?B?MWU3SDJjUWVmLzF6eGRIaE5EdlhmZ0pvUDhhZ0dDMS9RcVR5TENtaVJocnJW?=
 =?utf-8?B?NDQ2dTF4NlFMUDhOMmJYZkIzcjB6cUg3QS82UjhwVm14WjNFK1NKbnJ6aDZi?=
 =?utf-8?B?cEFWZjZ4WkxhVXpWdlJyd2xRZjNCeXQyWUw0L3YwbVFSS3Rla1FiTzRuMDBZ?=
 =?utf-8?B?M3ZRc1pxNjVuR1VjS0E0NHNXd1V4NHE2Z2lnOWEzRFg2TTFwS2swVHFIajJH?=
 =?utf-8?B?WG9Jc0U0NEIzeFVNWk54NWZwSFloYmJDMG5Ja0xtRHhkb3NpUlVISXBMd3pY?=
 =?utf-8?B?NFVCK0xiSkUrYVN2Q2l1emtaSGNoTVp6Y1krbStrbGdYRmZDSUZHQ1RSRmk0?=
 =?utf-8?B?bWd0L2NRY3Jkb1hyenV0aEloL1UvRDdVb09xOW1tOURLSW1qSkNBcExBSlNp?=
 =?utf-8?B?NWNXMmRveEN6eW9Lczk4dGtJTEFTQ3FWd09hekxlWnp2cW9CQ1Z1TnBDMjli?=
 =?utf-8?B?Y1VqM0Z0bi82Q0RGRXZzY0pkeVlmRU1jYndtUlpVVW56eExtbDRMR2I5K2Jz?=
 =?utf-8?B?RDhRRFlFRkFpM1E0dTBIU3ZoQnNkaWgwSEZweEhpV3J4M3hIYm1IMG92eEEw?=
 =?utf-8?B?VFRPVS9Temt0aHVtZDM2OVRzd01zWDlzbFQza3k1MWN0VnJFZnpnMWM5Sm1q?=
 =?utf-8?B?M1pFSjRISWtaS2JYaW1rcjZWOWFuZlRBRjJnQzErUmNmRE1kcUJyODFhWXhk?=
 =?utf-8?B?aW9WTGNzSVNKZzhZb25LOG13endyRWp0V2k2ZzBUUjNpZjN2a1RRQ0Z0aFpC?=
 =?utf-8?B?dE55UEFZQkZ5clBQMWRNWGcvMnBtUFdETXl5RVJ4ZjM5YU9FQjExR3hYeVFo?=
 =?utf-8?B?U1BsUkt5alhBazloTkhka0UxKy9XM1c4ODFVcjUwSlRwUE5uTFUrRWVGaVlk?=
 =?utf-8?B?UVhpUlBtK0pHSzdDU0NFZjNMQmpIcjBqSVQ5Y3NVeE0yNC9VZE04dGV5c2cz?=
 =?utf-8?B?b2tBaE5nMkdUV2ZQSkVGV0k0cTlhUFovTFVZbDRDUnRRMWE3QUhvWEgzT1ll?=
 =?utf-8?B?NGRFQ3U1ekJtVHUyU0JzVHozR3NPSW5FMFJGQ2JWY1VlL1lKL0dtM3JZZmE2?=
 =?utf-8?B?NnQ2aS9KQ29Mb0VnZDY2VnJpSWFuajVVbWdVcnJQMmdFYUZhalplN1hnYmNQ?=
 =?utf-8?B?M1RYaEtYV1Z1WnBJeXFVSThXTjRTeExDbTFCRk9tNkxzOXFjOHgrenBWamth?=
 =?utf-8?B?bjNBNDBsZm5UTWh4MjhsNEZ0Wk45UEtCK0kxc3hORFo5TEduTXBLT24rLzls?=
 =?utf-8?B?b29WTjQzY3g2Yk44SEpnaTIrR0FWNUx4TmYvUm1GZEhBcVBFRVo3cmNoZ0V1?=
 =?utf-8?B?NGpxT3BhME9CTDBEZEdLZVduaXQxNFVPa0VXbnhicVJVNkhhczVTQm5xcEtq?=
 =?utf-8?B?SFRuNlc5VWFHK2QvNmNDODhvZm9iK3FkMkxpd3k3WXFSY3A5disyTndPcnA0?=
 =?utf-8?B?aDhlb05lR0hhVWw2TkNKYzBzaTFXelJuREJEYm80OUIvOHpDRjFKb2RvcVhG?=
 =?utf-8?B?ZFg2ODhmelhxUTgzNUdmUzQ0ZjZvK01sY2txN0toYVpOS1lsQkN5V1RLYnVV?=
 =?utf-8?B?SGprNjEyeDBGUTBRTkdBNG56RWVWbVFob2FQM2hIaVBMdFRRamdjOU9sMFdq?=
 =?utf-8?B?UnJlUXVWTjBVa29ZOWo2M0xMdCtiUEFYN2h6QWNhNjY0V0tSZkM5b2pNWnI1?=
 =?utf-8?B?c0wySnJRSXFSQUpZQW1PcUE3M1FpYndxcXh4UXVrRXQ3eGo5a3ZLVDVjYm5D?=
 =?utf-8?B?aE5jZ09zeTk3c2ZzZTNENXhNYnFLUXhGci93WDlFMWFqcUxiNHV3eTlPUzJs?=
 =?utf-8?B?aUZCbGI2YVZsazE5VEJ5cmtDanVpZ213dDk5UGU5Y3JqYXFWaFVLbFY3dElN?=
 =?utf-8?B?eVFTVlJNN1U0aVVZR3VBNVFOUU1LOVg1M3NIeCtkMndMMVNYZUdIN3ZzS0Q5?=
 =?utf-8?B?UzNSWjZIemxBZDkwS0k5Zi9iM0p4aVhHam1kQm5lVVp2TWRzR2xxOFJaYXQ5?=
 =?utf-8?B?QktmNEpMb0llMGpGY2t0M3pTcmxuZjlqd3lESVhHRmQ3bDQxMFVodENjM2Jz?=
 =?utf-8?B?WTdCWStoMVRKczRvUzVYR2JuVmxZUER4dDBualU4QjVLS2RxampUWUZxK3Ay?=
 =?utf-8?B?ak10UWtrd0V2SnlTWDZybmdBc2hEdzZMODkrK0J6MklrVnA5Z3krTStaT0RQ?=
 =?utf-8?B?SjhXVE1UTDZsOXRyemFTelNjc0ZnYzdyWWtqbVBSbW1EU0F6SUtHZW5GVERB?=
 =?utf-8?B?WlJBbTFqZVlkMjk1Ulowd2F0QXl5OElJMjZFSDZGdUhOUkZmVkFzZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5129964-362d-47a8-11c6-08df125ebdff
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:23.4663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f18uR62TRo57j7ftopNVxH2yiACWz1hMXLqPlY55m/cDj/34nDvrOuUJ10oSTTummoZs8+nEJQdtNU2Qxcr0zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7272

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2414447892c..a92a48006923 100644
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

