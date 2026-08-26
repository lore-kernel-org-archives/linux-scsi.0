Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011022.outbound.protection.outlook.com [52.101.70.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA74334C4;
	Wed, 26 Aug 2026 13:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751680; cv=fail; b=jDbwS1R0xpKegEJ5cU3fbLgcojH3jYlPslfP1kJuvvqPpc6/ZD+B5++hsMJRGBQhPHmteVUbxSy94uWT8GyL/cnpuAhaoby14JGb7aLsEAPvNFXenQwtJGbFVj912xU7p08qViF3e1dXDFIeh0dOnE6RAO2nuYSXpZ+DVVp5RuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751680; c=relaxed/simple;
	bh=QFJpOo19MOGJfPSwkH3FPNr5ZA+OubZrTxt9DuuW6FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QhCe1bIDlsdRqo5VqOQBIll9Wn7Bz2iLZyjFnwcf/qpE6YFXefnkbLIBZIA2BrkD/nESE19dU/0aVgKHGnXUkGFnoGrIaXULJQXqucz7RJGq+npN3uSFjpeqCJJbIY4ZRIljJQmWtObw8qsAiM2C/gawIm0jEyCk6z7gSjBYcuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=xjUQ2ozu; arc=fail smtp.client-ip=52.101.70.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="xjUQ2ozu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPBMlZ5Ttlf6/ADQffWwyYf1HtW8rSnvlIAAItEiF1l53A67sq2VPwNYX9I50mNqaD20gSl1HX2eBArzcBVlHTbILXXIrEcJzxTE7KXCEwZH3yPOCGBRcizyi/5YhLU19iNUxijHUXun6xaZmhMxwnKRf9MRzmNyJiZboCbexPRSRSVvFWZm+aWkGciO3Ine+GOnahO8KhbD8FnmLSuI1k88LYQvqkK1eWz81z4wELv4QHlQ3tSz1QG5ojcQzMOpLV8kqdX7vBZGsVJdD6BthycZHkzrr5kzVCT5+6LQCmf5BYcJGDm5oChKYyD4J8GGZOjqWuqzf4bz60Ar7lkq/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf7NDMgOMrqJHg1nXXc3/un8xarW8Cmu7OckwWb0Xws=;
 b=qkYR6KnTDKtPV+659pr4F4CIw1tQv87uznzPWQflUZ/l68fusYkfxBvxpx6XWVulldDYCcaPnrqxBHfrGHQQNQ9LfUlkieG7TLA9eBxi3Zzb7BXoxFU3+Fjnx1cf2aJbEZCRBKtOaKegpuhIrpqUWfQf0OpI9xJdRojM/XCLmYT8keIc6wUOsnznn3+J9lKHUKdL8kaFWXqd1lYibb2WoK/my/32n+pkKP4j5+RnzDXeorLNPgP/lUp146InK0AZjkXPIbPAqBhb1oGaBAcI0sEUDfA1CpZvbHCbVIwSNZw99+w+2zJWcMMN75kA/ZHXUCFni/CI+YdeQTalG4QgBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf7NDMgOMrqJHg1nXXc3/un8xarW8Cmu7OckwWb0Xws=;
 b=xjUQ2ozu0BG9a+oF1K0wTq6ioliFBBarmhB/Az4Zvyp8P/jHAnoTKV9NQgBo5jDXwIwINlx+YSfVHhas/1B42HVWUynZck01pr5MuIXn/QqeAe3mMxF2WW5RqkK4hMx0tlCCRjVKuZ8S1lnGtLJAWsHgou3VaLCp22H2BBZgxAUclEOV48JT7H0GFUzbcxR0YTdbAAWWWHU1NgqUdYJDuDlidL+S/UIIiU24qTpmYM6njW+lvtr3qLRpWcf2yApt0c36RngVw2vhoD9p6wBIehFT3pCDVhsUF44KE35dqG+ciVLeS7h8WdihxJSsaHPxQH20CMs7XzIYO4BIWuVlFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB7556.eurprd04.prod.outlook.com
 (2603:10a6:20b:2df::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.8; Wed, 26 Aug
 2026 13:41:12 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 13:41:12 +0000
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
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org
Subject: [PATCH 10/10] MAINTAINERS: Add NXP S32N7 UFS host controller entry
Date: Wed, 26 Aug 2026 15:40:48 +0200
Message-ID: <20260826134048.854748-11-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0428.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::11) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM9PR04MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: 22ec0579-579c-4cfa-b2af-08df0377b143
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|7416014|376014|366016|23010399003|1800799024|10067099003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 YtVrYT4gQgYhTzpAc3n3YI/LGnLWlMUxwFPQeRhB9d+3ju6Qb0PIc9eCmwlt0qdEFnDmvZox2pjFa2C8JmmSxSvor72gS7y76wlYs5B1LPHZZOVF32zAiPIvG8y2CwOJBJ+xnaFqZ7ldyY902Pg1U5QkB2IXkNR9AoWx2AHZtt7UnukYCFmwfP+DZYuZkBKkzD5bK19wOrJa2iJawZRsYYRVKvA8FAl5bg3RjENloQ8UdZ+W6dE3eHjWwBQf67vyDeCc6ovZ4iDZ38I47YQf8Z+iEhbKrBA4zlxGXjFPlybYZqidu3pTLUSTFvJ51t5vr5TFFbt5NQ/l0PcY8xpH8+uzddkNK4CXjNesDOAnLzaWlzSTIUAVojLPOxs5dT4Bxlp52WohfqVpw0wu38AGY06b7aXdoZStHwjKtm9PvBSjp7J6Qrc3Y8/daecMmWEWQPTsiNQrTQSc5btdJQ2MxArVVzYNUXXnEnpQJB+epEED9XKIVY2gy/FFfyoguZ39RQDhjJr//qRdk1zNjZhRFeqVIbTLvjxYX7oTMdpEeWtXKlsClDpbrohGJgcJ7FhIWW0EwijLksjjDzQlD1GPPg8FRCTZTlXJEYSJ2aNQV/NV/felXqkvHgzy+82iByZVaVFTraU+maT+jBNnLtn6p895IDQI5fspfEjKE+C6QvPRFged55Fw9+IHUzhXazl3B02vpiKTJN7YUdjjCJdrgw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(366016)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c1lldWRxeVlGVWhzWk40SW4vbXlkNi9qaWtuK1FuUmRVOURGaGFBbTRSSTRO?=
 =?utf-8?B?c0NNTGVMWkk0QjR2VEUvajhOV2RmMlo3aFJYWmFxSnNoR2wxK3J3d1NIM0VO?=
 =?utf-8?B?NFZHOEtJSzdJOXN5bkwrTHNyaFFJNE1Ub1huMjVlckpPZS9Da3l5UHdCMXl5?=
 =?utf-8?B?UWhwOENJcW03SVBzbjhVWGUzSzVqOUh3dVplRDBSTS8wZjdzN2w4RmpJdUJu?=
 =?utf-8?B?QWtXclJIemdCK0M3Ky92MlFGb1NTakhoRE9WS3E0SzhhejBOd25TOU9XRXha?=
 =?utf-8?B?ZFJZTUlEelNaTy9kZXhOU0ZZVjhxUFB4REt4THNyanVYTXRBMno4L3ZLTkw3?=
 =?utf-8?B?YnJ4MVQ5elNhdExMdVVtaDhzODYzZDVOWFFkMTBOUHlOUWMrTi9wYml4a2lq?=
 =?utf-8?B?dUVvZFJzeEw1dGR4MUVvczRuYTlMZWJzbGU4NlR1Wm9jck9EYWpkM3hab3ll?=
 =?utf-8?B?ODhtUUJkNGtOdU9sRUNRQUUrSFI1V0lFa0Z2QXNEQ1M2bUJhV3kvTFh0VUhv?=
 =?utf-8?B?bExWR05IaktsdjR6SkxkNjNHcTA4NjhzTGd1eVl6WGlvSjIrVGxzbTVNUyth?=
 =?utf-8?B?MUdLc0Rqd2RNNkJvaHZVVUNzQm80WW4wQmgxN3FZVE84THdFNHZteGtJM3cy?=
 =?utf-8?B?TmtxRklRcjl5c3lqU0hVRjZwc0VORjdPa2VkSVkwZmt6UE1Mcm1UUGExUHV1?=
 =?utf-8?B?VTZ4UDgzUTI5UVZTNWdsVlJ2TlRVOFZGb3pzUStsNFdCRHliN1d1TXhHakNq?=
 =?utf-8?B?bmNWS3F3d0gzU3hBZXNWNFY2RFA3cHhycGhKQmNYUCtSS0p0WG82aHVqVWNV?=
 =?utf-8?B?Tk1OUklSTWR2a3YvWW9HNjVoRnd1ZkUrTEM1S2FlM1ZpT1lCdmVyNjcxaEFB?=
 =?utf-8?B?VTJqWkhkUGZPSnIzS3ZUZXJGb1Z3M1ZIRHBnSFlINklwbmxOR1BjWGIvSFhK?=
 =?utf-8?B?WmdZQ2IvY2RmNE5XOGNzTEt6RnJnd3l2MkZEeHdvdUpUSS84TEtIb1o1ZTZT?=
 =?utf-8?B?LzRINWVZVUlqdzRyZVd6eGNKSXl5ZExZQjBxR2FHU0NJNXZiTEpyTEw2SVNK?=
 =?utf-8?B?aHpNZ1BrTk5YYitRMngxeTRMbXQzOUZNcGlZRy8zelNxZUdiaGIwS2lXaTl1?=
 =?utf-8?B?Y2tHNm1yd3p6cUs0RGI5TmZVdjhFSGlYQk9kY2JwdDFVWk9zUlo0MGxPUHRn?=
 =?utf-8?B?RmFRR0JtaXlHck1BdXJGZUNqb1FBclVQQzhzY0wwcWJ3Yk8yb2FIL09CWHhi?=
 =?utf-8?B?OGd0aFlaTmQ0OWQ2SHp6UlU1V0lLYisvWW1LUklZdzQzTUhEWHFmRk1jRC8r?=
 =?utf-8?B?aEhPS09UOXRNcmhmUzBXWUV4NzJ4Z3lCRGFoWElrNkNVUEFRdWhFZjFFc1hV?=
 =?utf-8?B?ODNxdUp5ZFU2dFhpNjJRSUhoR1VxTXliZGZoaUZHSG1XR29SS2k1UTFOdkpH?=
 =?utf-8?B?bjhkeEp0bDZEZnB0MFR5RTJINVBoQ1JSWXZ3SU4xaDE1YTFiNm0xczZwcE5k?=
 =?utf-8?B?ZFRoSmtYelZCeC8rZWZRNHIxUGV3ZU5CT0hHRGZEQ1MraHo4OExJS3BFclRw?=
 =?utf-8?B?ZCtVZk9ydVk5dytOSW9NV3FCYUlnNGxQSDNLbW9XSGJtSy84ZHVsUTVaVzFO?=
 =?utf-8?B?MFl4dUN5Tnkwa0ZhZ0QxSHNwOEVRTk1zdkZiQlNUR29GUmZnWVYrNFlqZDg2?=
 =?utf-8?B?WEJKR21sTWprYWQ0TGtETFJBdUdNalluZEx1MkZrcmJ4Nk9RaVhjNmhLbUpo?=
 =?utf-8?B?Vnk0REl2UktFWDZxdGFtUTlONStMRWxCMDlqc1l0NTFLSFV6cGhpWEh4UmZw?=
 =?utf-8?B?S2UzTHN3OTZFOTgyN0E1eWRmREk5aXdDTlRTNDJrNTBxWC9hOVVWak4rNHAx?=
 =?utf-8?B?ZHhWM3JkTGVQMmh5UXZ6cXFtT2VJMERvbnBBTHIzMS8zN092eG1CVTdPNEhL?=
 =?utf-8?B?K0w3SXg3ZStFcXpIYVFXYkJLZEhzVzJYaXF4Y0dxUmZIRThsbWEwcnJNSFZI?=
 =?utf-8?B?TDg0aUM4VmdZb3hnZ1lGU3NLbXV1TE9aTllER1A1dkdldkZPNzl0Vi9yZFhE?=
 =?utf-8?B?dzRXK1lKSSs0RmNZaWJXa2JwbXREMzZzRUJlbVZncEh2L2VvZ1ZuM2txUEpS?=
 =?utf-8?B?Q2NuOVpiNXF5OUpKczJoM1RxMmt1L0FIRTQrQjRUMWZJU2txMVN5TUQ2UTFG?=
 =?utf-8?B?Y242cWN6TnFsVjJzV0pJbnIrS0RNdnloa2Z6c1FLT2krTHlTNGZWWS9vTkVX?=
 =?utf-8?B?MGZLNWc1SC8wMlJ0dXZjL0pvVzZZanFOT0M0QzJCR3dKdTRXTU80a0k3UXNE?=
 =?utf-8?B?Q3V3M1JnQ2xNZ1RZQmhlOWRWVHlzTldCV3IxWjJEZE9wWi9EeE9NYUxrQWV3?=
 =?utf-8?Q?0Al4xAtsohlchzWA=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ec0579-579c-4cfa-b2af-08df0377b143
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 13:41:12.0735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iL+yK27fOqU/pHvQbHXsReD44FGiajm9/NYo2VBbrm9KY6VwyVdA6sn0c4eSZ6geci/C8UBX0WOkXm0BgTgWhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7556

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cfee5d47b214..cd9f1d0c5406 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27768,6 +27768,14 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
+M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
+F:	drivers/ufs/host/ufs-nxp-s32n7.c
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.43.0

