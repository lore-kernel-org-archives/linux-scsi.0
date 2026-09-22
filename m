Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688973E6DC8;
	Tue, 22 Sep 2026 07:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062422; cv=fail; b=PRW55UP008+Ye5AQIiMYDdaqjT/rtbcYUW3dM0kvR/Gj8UfB1GcBLvtarhhvSyGm98MFz3GxChSn3deSqJK+67bzvexfhzjN5g+BkUAF7rl6vFDWYammHNDlsvPfmPQncWJBi9ArJBbCp7ViMBu6KBycuqp3ryDrHvQPMgoAHqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062422; c=relaxed/simple;
	bh=m6szGpBKsXIUl1/uJVhVROiVGi6vyEU658NnP6M97sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pcr20VzsdWQEczoqSUUszNv6OsidP9k2OlE8Eu44cGQ8NLinyx6J6aLIcfqWS0oj5weG09QpFHZ6ANkhnB9N9WkpqliiDZc03R5SbXGPB9xoY0BXmud/HCdA8q3m2XhjKg6sdB82fN5h6p33sEFZl1YqMjOhY1g8jaAGY9RXO6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Xe6ng8W5; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Xe6ng8W5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lK9WHIzo/O2am0dPBpu7aJWpK3BvNpLuR+de2rEPURFs/YTcp+VHnMNHkxbVmlAA2PCm5Bw0BeRixUFytqSswXK6HGTZU59sHQmmDqCUgqHohtluvuubVNlmcc5a/E7NZYW1OCmdyU+mPFcL7o9aCzdO+uuOctL/52guoEx1+icD/oeiOX7mQDNU/K2uUrXlBKRyR3wxARAZvIaOxk6m9nFCJB+u4Yf9FfBo6NVQ+hqC9hmqed7ySY036A7SMcuW5Q1f7XAvlKsPAFc6Vrix+wHY/6CvfCXdQMKYRQv+23TMhSzlhJV1kOz8qhW4EphfKIwblz85XqSYzBfiLkwR3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5VCOxmrakOZvoozZLzX4mZ50JYYQpMdb1k6aGo+n70=;
 b=OzYyq6r1EgxM11ndk+YGZqx9dHN2HjnaT3BbbcTqruJgsBISfL+P9y0y4P9+xMK/2uHyaQT5zjCKtm9/o2l8ktFviW3hHzJVivbw7cMhaYPhWdDiBkSxRPrKE8Gg0r4+/ZLVodJDUKEoU4X61F90splW9likGnITAieX4pLkO5nE2OfjraymQ/VSycHytTAve8BjugfXVr7xSC3zu6/+STH8gAOa923NNtxNzmCQus4R3GEr3cMKJW4olng4ZMr40/V4RglFt9CWYMWfUorxM8ESB3M4iFimE79jVVbejTbN6se5vTcYwyz1KX9kZS+682uLBmgjtFdavR+k4s3q9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5VCOxmrakOZvoozZLzX4mZ50JYYQpMdb1k6aGo+n70=;
 b=Xe6ng8W5F3/Nwo2Fyxq0BAz7m9Z3Pg4C9XFt7P9XdpaMPfWTS9YVCUFe2ONX7V8XtSgquBOALWBQKBbUt6Hx2VdEIJxfI0tbCtDJ+X+86pSGSF2TfeXkdQLcYs+PhIi4FTtX2M4MaPAVtl9J9xy4ZAmYlHGWETtvD8BkRUw3ZrYj305Pg7ax++ePFwmnBj/bjU1l/WbqTyUCS9u8S6Z2iiQzcLfRCUnkbhdYi2gHKHw/tNXVzZSgy9yeA+C0ep4cGwzkYtCqrqXlInGq4fEoT4PJL5V9NFbBfx/X8Z8Yx52D3ARxZ8EFMDiAW86L3gZrQg1k0fE46BDlVv7+7BW+lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:21 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:21 +0000
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
Subject: [PATCH v5 04/12] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Tue, 22 Sep 2026 09:30:01 +0200
Message-ID: <20260922073009.1449688-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0001.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::11) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 1eb83102-07ad-443b-0273-08df187bc71c
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 c1swE1nrYgDeAve6onmxqi8QqMjh8bZXpH8urRt7uFNxTBRv5dmgg+QDx4v/3Kqr2JoSsL+X4+F/aZ4cDdC9GXCrz6/8GqnG4C6YOHFiG/VP+qsDnXZg8NpZmqbtYrOVSQa8sQ+KsiHkygvfaH0HbNgx2GuaYWw0WFnaa80k/M8J/4lIxFvY1b0NGPwDdtlKcZGfcQwHmtvtdP/YjHu2k3YgTApLby7mqp41yqyNUo3m++Ho5xQT2VKr6YbAAHkK3xTuBmoc5Nd8OovH4BrIx746fQu2N8BysTYwhJfA8yhWKq1MP56FKKKWfax7F9dQisPbsAgO6jYtRYRV+mDr7bDhfo4kK51JdwNgTSMDl/ynUk7mGML+9paNQjJ1VB/sJ3sM6eDex1cfc0lYN3rE6HJUZgHMcF3vShWouztBDaz2lnNksO+0N7iR4q/YGwBDHMiV/Ryo1kLVk2EOT7WNXSgK8lt539jTyryqHivyWDHc0r6trwvGQbsumpn3A9XUQuHk/7ZKZ8DQthl7BTurQmro6p8oV/m8lF0WoF07LjNrVMhV6euB1ZNNS3dSNv+FjNqAkLF+JYtyDbxBxEcityHMDoKhMzHK9Tf3QoHLzt9DMLuhgRb0pxuM6oRicYLmyYDE9Zpi1BJHNpitF7xiFEnm4EQalnPIcfTzuL5EmuYFdvOP8oziWEVsZWpm01LdNk21XvKKUwW2FHnj27sELQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?eWhXN0pEMEQ4Nm9SYjJiYWFVNWtQeitHWUF5ZmlIZXdpK3kwM2wxUmYzTFAx?=
 =?utf-8?B?dW5NYmp2QTRYdHRKb1lTUjZZZmY5eUNGTExjZ3gzMHJHQ2t1bGwrbDFaZFRj?=
 =?utf-8?B?LzZrcDJGbHVzRXBhbmVVUU9qTGdCOE44SFpJZVNZT2FPWitneWYxWVUxS244?=
 =?utf-8?B?L1FYUmk3Y3NYOUdhdUlLQ1UwNkpKakFlZVRDTFpLUWpabnYxeWhFaWYxZ3Zl?=
 =?utf-8?B?WEhoUDk5Tm1CNFlwMk1VMXdEOGdiWVU0c0lzcUh1KzdMNVQrMG1sRkI5TGdW?=
 =?utf-8?B?M2dLZjNvVXhOWjdLS0ZsUGlNNXFXaStvK3FYSkxqNTBlTUs3ZVZXQk44WnJq?=
 =?utf-8?B?cklTRzNmcU9oT2UrVWZUMVpKT2lBc0FteHc5VFkweUh0SmhJbk5pdGFSYksx?=
 =?utf-8?B?V25pQmp0Vi9FU0lKNXFQSVJWeUxRNWgwdDFqMURrWTlBdndzMm1lODZFVlVO?=
 =?utf-8?B?dE5XQTNCTERCN3UzN2lGd0JBYnZrNFFmN0ZuY3YyR3ZlK1FRZStiNTFxbmdi?=
 =?utf-8?B?THZFZzJMVlVSNzdTZUwvYjd6NFI5TGoyclZpcmVnMEhyZ2J0dzZiaVVoajZL?=
 =?utf-8?B?ZjA1TCtCbVllVmRyNE9kemxEVUVuVEV4ekxla3lQREtyRmpIbk5UeFIzWnhv?=
 =?utf-8?B?WnUxQmxCa2RMMFF3cE9SV2JMQlhuNEpYdzQrVVFDWE9qK3pTc3FkZXJiWGIz?=
 =?utf-8?B?TTIvZHpSUHB3aXJNcXczNzlUYjlyZ3pVYzB2L083aWFNMmRYL01DMkJFV0hz?=
 =?utf-8?B?SjUrYitFVXVzNVNKdnJsMFpJczZ5QjQ2M04rNVlRMzZ0NnJXU05ZV3VtcFVT?=
 =?utf-8?B?L0xtaWhickR0RFJCNko2dFlCL2VscTlnMW05eWcvY3VkZ0JqclBXVFZERzRw?=
 =?utf-8?B?NVBYUzVwS3VvellFcVZtUkRxTWV1WUhldFFSaEtLQ3RCRzM3bEFXcGtKQTUx?=
 =?utf-8?B?SjFuUHY5d3BOWXpCRUU4aXAxei9XSGdsUG9XWDIvRDN4SXNhTEkvQTlOTzFu?=
 =?utf-8?B?S2d0NHFVamRtcVpzeHJvZURwWitPVmJIZHVBbkdIQUZTTkRaMys2bzQvaGNO?=
 =?utf-8?B?Tk9ERnBseGRaek1qMG5SZFBSNnJOVmk3eWIvSng1TjlGQmZ0cEVaTFdCMUdo?=
 =?utf-8?B?SU5lUmYzQm0waVphOVVrS2g5Q2ZENmhrU0k4RWZLcHJmaDBMbG1rOHA2aXor?=
 =?utf-8?B?Qm9oelJaSExCc0hjdTk4OGJhZWFXUkI4R2YrT1hyQk1SOTVWTTNCRU1uUk94?=
 =?utf-8?B?RmFqYm51UkVlN1pBT3pGN09VNmVEdjZTdE5TMG5WWEpIKy9yeDJhaDFqbVRJ?=
 =?utf-8?B?Um1oVEJCc2tyNmJLeVh2YXd6RjFveWFDSmt1Z213bTlISjlzRGI4czJGbnlO?=
 =?utf-8?B?STZ4cC9SbGlxTmJSTmZvRHBJSHMzVlBmNDhzT1ArVnJjeDRJVmk4WEh6elgv?=
 =?utf-8?B?cW1nN2g2STRGMG5Xa201Z0VsZFpacXNBbFNCWmdGMWNsSC9LL0RSTk1KOUJS?=
 =?utf-8?B?Ri9heW4wU3RWSUVremVQY0tzQlc3d1d2ai9iK09uQVczSE5kSEpCdGo3aENv?=
 =?utf-8?B?bTFJZkw1WVk1SHZycFE2bWwreVZVajZCdUgzSzdTWFpPQ1N4WHdmY1IxeDhE?=
 =?utf-8?B?ZHV4ZGhFbVlQR2F6ODlxSkRuWFhLK0kvMGJGZXlzT1lyWHFCZFNLMUUxZ0Ja?=
 =?utf-8?B?Y3d3YlhZTHluVjk3YjJNNDlpR0ZndUdZL241NnlKbzl6TU5rTys2cWMyOUZJ?=
 =?utf-8?B?OTM2bkRhbnV4Szg5d0wwVWl2SDBKMkpNMnBwbFhVbEZGUVRxOGpuY1ZMU1NJ?=
 =?utf-8?B?amg4T3Z2R2lHUDJVMWYxNzU0S2xwbEVWL0grNEtzUWl2Q2Q2d2Q5MHBMSlg3?=
 =?utf-8?B?REpQdDI5cnJlbTdjdnNINVRQbjVrdHZzTi9qRW8ybC9xYk1QQ1A2YURwMnht?=
 =?utf-8?B?M2Q5MVJMeWVJdTVQZGRTbjZHZFRjNWdPOG9wWGxnUUU2SVh0NE5LS1N3SU5w?=
 =?utf-8?B?STNpOEdRVEJWTjNYQkw0N2hUU1gwdUFma2VnZnppc1Y4NE9taUVDVUFZcTBl?=
 =?utf-8?B?REFsQmJxOEMwOGZTQjZlbGlFbmZsTkFpQ05ueHVWandhT01lSGZMcTRtY2Q1?=
 =?utf-8?B?a3pQRytHSWZ3dlRRRzNpSWx0cUQ3YXdxbDlDbVdLalJ1bXhHc2wrbzk4QWdE?=
 =?utf-8?B?UmxjTFhrOExockNrZ0V0R3ZNOHJ1azh2dmliNHNRNkpIQnNnaTR0Zkpaa1RS?=
 =?utf-8?B?UWdqSHRIZzU5TFhqaHRpRWcrNXBXQ2JuSUo3UHdEamZoMCtwQ05pVEJLa0FP?=
 =?utf-8?B?N3EyL0dJazJ1eTV0V0pJQk55K0UzZ2ZCU3d4RVhmVHVuTXYwUjRqdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb83102-07ad-443b-0273-08df187bc71c
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:21.1242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wjt97RGiKNzv6t93/JK86kAIs65ONlAiQqXBHKldbCHlGKczZMD8NozlcWUFqwaHABBX81W/2XLI5oxuGcmY6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

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
---
 drivers/ufs/core/ufshcd.c   | 73 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c | 48 +-----------------------
 drivers/ufs/host/ufs-qcom.c | 42 +--------------------
 include/ufs/ufshcd.h        |  3 ++
 4 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..985573726d67 100644
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

