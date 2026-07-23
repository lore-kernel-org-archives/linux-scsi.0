Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022122.outbound.protection.outlook.com [52.101.96.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A85A3F6C59;
	Thu, 23 Jul 2026 22:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844103; cv=fail; b=fOA+xLyr7100S02UFvqG4fyleTV3CUyToWlStWMsDqloZ4+IaiysIS46xisJu61RG/uuH56cju43J6fgb4Qgw1aE0oOPzmm4EHsOeteV8Jp0mbqaOonWtI+omhPhJh3R4+UwzSODP4Y5cs09qexj3Tju92TfSguvIZXxrN/pKhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844103; c=relaxed/simple;
	bh=eQg3GQb7w8gWOp8afJfUjssOZdsxhaCSTJfIlKEFm38=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=YpSzc3LbEcJSjygnvgjZlosfMpawW8bvLRSfwcUkdeMmow3EOAAQHiojbqd3bips7ZTAPiAGiVUVunzklsil5/zaeitSpLpCh6HYUS4lPoLIMf8RP3glgDJA7VyRCB/7laHSY/frPZdS6C64SyoE/+YVxHLOQYdemq5Z0ZkWV/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=DfXCXQP4; arc=fail smtp.client-ip=52.101.96.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="DfXCXQP4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fCYfI6deHfjNdcoSix7XiOUKYTOU85csXpKquM6W8fgDLAFz8cPMMa/GMMc3Zr4RzAW8h05ILsrcRG2VoWokN1toyTtuB+zJcBGL8av6nWnwMusw6pUoHM8rxK1ASSZv6ScXiuzkliRPebDG5Kt4bVi3LTuKVzjsZ6m4lVk33UH9qJ+96PDfNfNnNuoId/iiC0VcnUwJ+/EKlSQPjpuNlqXRPf8XbM0vGcyGOOfmStt2mlwZlaUOC6YAE2POn/aiAju3YmOB6g/zQd50vpk6tpFHQ+EAy3dJInTWKfMqMNdtxna/bRF24kZU1lyC8AH/sb51+uFYPlh1gGBPnEcpfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAaHO316p+uUWJPno4GT7gYqby8ATDCVI/Vo5uUOJ3w=;
 b=JPFHzRvXp+d8r4UDnCgSMVFojijsKp0kdKfcfgvTCppunr9II95n3kKoyEFa6of9IM/BXLwBRFS7+RctxLZNEZMV39w+DJTg8D+FLLigu/wqOfe7yA2cWs0fzNiu5Mu3Hfa9ysUSRh2ADq1mLGhurppVRhFDXKe6c6i6i/AusXiM6usu2j8sJNwq3NXq7D2znWSPPTech5gU2XTPIMuU8hrtn8+B1LladlU5LmMoSnKfCbgheQoVvhTruiJFApPRB6zbB0s4gMkmcHFunvRelufrlQe3K/7LzLHt8RtPJw9K7z0jPBjLJeNa3r+g4hBxkAoSK6dvj7yMZO5NFh44eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAaHO316p+uUWJPno4GT7gYqby8ATDCVI/Vo5uUOJ3w=;
 b=DfXCXQP4jqBNMPCUPo4GXakN/qPRZVAdz7/ccxaXOvjx5fU0sFmaads9JJLzyOVtkESHybaofy0bZnTxlA7Slqgr4zAbuN/y3w524GfgtkBsXVggBBwahlFjtVGhwTFiTTnbKOjNn5bzVY1cm7ZTXve41KFnjdyrm4CxAffY+hI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 22:01:09 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:01:09 +0000
From: Gary Guo <gary@garyguo.net>
Date: Thu, 23 Jul 2026 23:00:45 +0100
Subject: [PATCH v4 6/9] agp/amd-k7: Don't rely on address of pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-6-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
In-Reply-To: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
To: Bjorn Helgaas <bhelgaas@google.com>, 
 Zhenzhong Duan <zhenzhong.duan@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 GOTO Masanori <gotom@debian.or.jp>, 
 YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Vaibhav Gupta <vaibhavgupta40@gmail.com>, 
 Jens Taprogge <jens.taprogge@taprogge.org>, 
 Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 David Airlie <airlied@redhat.com>
Cc: linux-pci@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, 
 linux-scsi@vger.kernel.org, industrypack-devel@lists.sourceforge.net, 
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Gary Guo <gary@garyguo.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=2669;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=eQg3GQb7w8gWOp8afJfUjssOZdsxhaCSTJfIlKEFm38=;
 b=kJ+lrNRzbyEd1OieZjJ+S0g5e3ptn76WNSF1MnU+h2KexXWHvQSe5FFnlgp7kFXzM496yWTAg
 o982S37wa0LDn8jaLgE0O1dbJHNoexyHNDTahAMLODIdvWIzWhvsof9
X-Developer-Key: i=gary@garyguo.net; a=ed25519;
 pk=vB3uIX95SM4eVrIqo1DWNWKDKD2xzB+yLLLr0yOPYMo=
X-ClientProxiedBy: LO4P123CA0115.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::12) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO0P265MB2635:EE_
X-MS-Office365-Filtering-Correlation-Id: 510e2417-5932-4830-e406-08dee905e736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|22082099003|18002099003|3023799007|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	QFIhYywHFganyLUd0VlPh0Xv8E9T65gOri2xrUZ8gss/GClZDxXTZnRXPWLWfr2Q8SgoT4cnAS564aKJCxmCZZm8QtDqju7Ce/P2i0TQ5BFdtWYW8cn2xzTb3RSvQ3kwXipVHmgmYLfrbFiJlEpqGRPFcXyYsLHFIpCprZ8PYKHL+3JfnUEmIvLdz7kpO8kGXMPDCa5csPKx9c00KTVIEQ6wBJntJ8sLpktmFblDNhdY2qizsaFcdygLa6vh8NOLWK1gs5URzmfICkASqOXWxaKNjSabYCLwYaTcNy6ebetQ6EOSP4SYZn9vJyz7GGJgQYNDRy/Dg0Y/ML/hYgqsps3B+xLCTAw0/M7YW4MX+akT7Ze9xe3i9YgUiBQnDEwuAAj7yUZwabBXH91yCS3kP3K0tthbzHKmlnix5qwAp/52wBXjynHrcIBE02lckPwsdsVY9LPHVwY7K58g0IvPBCjO+WU91llKMdR/RJSU5e/5+IEwVFXqcUkXcn+1NV1acLUwCDvPGhGGrmWXFXu/JXmHNdVKgsiLSmbWI05x+QOD8sVp70SFxgO6oH9gwdbBU2uSwharerGKv+gv2vV1kaRQxA8ttBCyszxEpES4DISvRqw9HSegA+uVIXSHkRx8El2o8f9w/fzM9tc74HqEUGcfCpQb1nw9QbgTDPfUiAZMGN5FcZsutSr5igr3cL6DarBWk2xKBmp9e7Eap51yUw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEdmNDRnYU9lMzdxTUpMay9wQUhpR28yellaeEowTDNvMzdaN3JxalV2dEgr?=
 =?utf-8?B?OXBMWEIyeUp5Qk4xdnJrbkhhUGRtQTZNTGUwRkI1a0V4di94dUZ5eXBZanJF?=
 =?utf-8?B?TzNuZ1h0NkdxeGtKdjA1eTVpZjV3S201YVpudCtOUEV2WksvN3kwR0JIRVhq?=
 =?utf-8?B?aGRiOVJIc1NvaWExeFZQa0QvSTdVY3ZYRkE4cEp2WGZvUzNqOENYc2NtMElx?=
 =?utf-8?B?RTFDK0VtRlVod2JzMm5MaVJvQWY0ODhsa3BBWkIrcGdzTlUySjJ4c0JHeTVO?=
 =?utf-8?B?YkhHcUxRSFIycUozdXBFUWpQT1Z5WHozVmpsOXozT3hMeU1iV2tTcHNIZVF3?=
 =?utf-8?B?MDJZZFVtNGE2bFQzT1dqZG00bnpicFdiRFpIektkRllIaTFMUUkrUGhkT0s5?=
 =?utf-8?B?UHByM3ZPU2lZYlpENVhhR1hxUWd1VGpvcGQzTTJPTkxMV2FzdXJXR0pURGJs?=
 =?utf-8?B?NTExcTFLekowSUJmMDY3ZjZiVnd5bFgrSWdKYkxweXBJdHJRUFIrbEkrM2RO?=
 =?utf-8?B?Q2h4aS9WRWN0UlMyWVFGallITEFidVUxZ2hwTkdBZzlZbkk1QXgyTmVXS2xj?=
 =?utf-8?B?dlpjd3JQVFBiZzR0WEJxQWlGTXlwRkJVUXhLelZ5MTlmQk1xODIwL1l1VXZT?=
 =?utf-8?B?QnRlOG1Lb285MzRCYzdEVXVkNkZZRzZUcG5nMWJIb3JacVNrbENwcnAzWEw5?=
 =?utf-8?B?cTBETEtzSTF6Ty9SZlZnenUzVUtGaWNIVk9qUnRoRmovUmhSU09KSXpKbUVv?=
 =?utf-8?B?c0d2TUFLamNiMUZFc1B6SFJOZmJOejVlOVhWMXExRGpkdGM0aGdwTk1yY1J6?=
 =?utf-8?B?Wk9wbVRBcFpIQmluZWtZVjFoSUZSZ0VqOEFUM0NBdnVrM3d3bVA3ZkZ5ZEhi?=
 =?utf-8?B?Rmdnb3JVL0pVQU9CaVFwL0F5TzVWM3Zidlo0bVFrTTVVWktibDVTajFwWU12?=
 =?utf-8?B?aGE0Ly92WStkMjNQR1ZYbkNHUGNNSW93SGdvVnpZeHhrUW9wNHo5MGVtMDBx?=
 =?utf-8?B?T3lZVXp0cW5NZkJJZWNOZGNFa2xlbDJ0aUpwSmdMZlV1R0s5eWdHQnlpUlEr?=
 =?utf-8?B?NlNYTjBsYURHWmkweDBjMTBNakl6dFduNTlKeS9tdFhqTWtJV2t0MGw2Z056?=
 =?utf-8?B?NHR0V2ErTGZtd01Jd1JvdE81V3crVFNiTUpKc2lBTHRQSkk4YXh1bVFBK1J6?=
 =?utf-8?B?RFg2YURQTjhNa3FqOVE1aXYrK2FpU0tnQ3M4QWk4MXJ0UDRuS3pMSHhobm5N?=
 =?utf-8?B?QnBBRUVvSzNuOXJiUGMxSG81U1ZJQ0Z6RDFKTVFuTldDbVdONWJxTTUzcHR0?=
 =?utf-8?B?SjJ4RWlXU0RYL09YWmtWbENDMGdmdnhvSFZNR3JkV1RGaEhiT2lDUjhSaHdh?=
 =?utf-8?B?WGYvVGdMeXl4R2pmUXd1M0JtTzl4djBHVnk2YnpTQkRzT1BNVUdQeDNmOFVF?=
 =?utf-8?B?SFNXRktsVDB5blBXeXAvbzB6VEJqQmNzK29yUXZzQ1VzRnFTamx6UjZPSFkv?=
 =?utf-8?B?ajJ1SXQ0dFp3OFE4U0YwaENhcVZlR1J3MzVIUkpqVGMwMVpwRi9JdWU0OXFm?=
 =?utf-8?B?cUx2cENVQ2dWMWxMbDkrOE16Yis4amRvZDFYMlIvdG1DQktHUlc5eG5hNzEz?=
 =?utf-8?B?ZlNHSFhBUExHemJSMGNvMVZpaHJyUk5VMDVRU2F6bUg4aFUrL2dzZVloSEky?=
 =?utf-8?B?VnQ4U0g2bHd3LzZXWjRUZG50REhtQXd3RldXMlZuenh2Zm93VHJBMFh5eFMr?=
 =?utf-8?B?bmZsRWRqVGU0bmRNeHR1bGlFOFlTYmsxb0JzREhNckoxeG9icFRsS1YvQ2xE?=
 =?utf-8?B?MjU5Qm5sTmUwZmlUTDI4MndDYVRZS09kYWF5dmdwV1NBeDlYblZwUzlNL212?=
 =?utf-8?B?Y05jaXU4RG5yNmJKaHllZ0tRbTVEemJ3dzRSc25ScjJDbStGRVpCSzkzOEtB?=
 =?utf-8?B?M1RDOGRqREFKTGlhb2hPOVFlSS9GakduZEdNRE1KK2pXc3BGNjl4Ry9uaXN0?=
 =?utf-8?B?dkdjeGMwUU5IQS91UkliUnA4Mm43dlBKeFhtQ1Z5anRQUS9zQm5NV1gxMzRK?=
 =?utf-8?B?UjhMKzZVdUJOemFjUjVWanlTTUVRcnlrdUpVZzlRTjlDOUsvYithNlVPdDNI?=
 =?utf-8?B?Q2pkaFhYUjFkSHhSaDdJZkhtWWtlNlEzc25VTmVESFVnbWlJNFVPMFJhRm1k?=
 =?utf-8?B?aXFWQWxZZzdmSzgrRDlUbXEzS2o1bnRpblZVWkFPK2p3OEgzTGVlZVFlbHFI?=
 =?utf-8?B?enlrc0xDT3J6aCtxcktDSHE3a3gzZG9DbVZ5MkV6czI1cW9OZHY0NGt4U0Uw?=
 =?utf-8?B?S3NIUWtMMVc0ZkE3cGptbFR4cTdBZFhjbFNwNW5MRHR4WWFCcHl2UT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 510e2417-5932-4830-e406-08dee905e736
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:09.6959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYSFrQlrPAve+M9XLidq9NlYWkt9GzcEwt2rBCNx+W8LRAyRewFK4RHgQ86U+fMg8Zpf3h8U/jqqUZQLjx//sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

Address of pci_device_id cannot be relied on due to presence of dynamic ID
and driver_override. Use driver_data instead.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/char/agp/amd-k7-agp.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index 898ff30ffd46..4d201e71c517 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -387,37 +387,17 @@ static const struct agp_bridge_driver amd_irongate_driver = {
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
-static struct agp_device_ids amd_agp_device_ids[] =
-{
-	{
-		.device_id	= PCI_DEVICE_ID_AMD_FE_GATE_7006,
-		.chipset_name	= "Irongate",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_AMD_FE_GATE_700E,
-		.chipset_name	= "761",
-	},
-	{
-		.device_id	= PCI_DEVICE_ID_AMD_FE_GATE_700C,
-		.chipset_name	= "760MP",
-	},
-	{ }, /* dummy final entry, always present */
-};
-
 static int agp_amdk7_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *ent)
 {
 	struct agp_bridge_data *bridge;
 	u8 cap_ptr;
-	int j;
 
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
 
-	j = ent - agp_amdk7_pci_table;
-	dev_info(&pdev->dev, "AMD %s chipset\n",
-		 amd_agp_device_ids[j].chipset_name);
+	dev_info(&pdev->dev, "AMD %s chipset\n", (const char *)ent->driver_data);
 
 	bridge = agp_alloc_bridge();
 	if (!bridge)
@@ -492,7 +472,6 @@ static int agp_amdk7_resume(struct device *dev)
 	return amd_irongate_driver.configure();
 }
 
-/* must be the same order as name table above */
 static const struct pci_device_id agp_amdk7_pci_table[] = {
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
@@ -501,6 +480,7 @@ static const struct pci_device_id agp_amdk7_pci_table[] = {
 	.device		= PCI_DEVICE_ID_AMD_FE_GATE_7006,
 	.subvendor	= PCI_ANY_ID,
 	.subdevice	= PCI_ANY_ID,
+	.driver_data	= (kernel_ulong_t)"Irongate",
 	},
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
@@ -509,6 +489,7 @@ static const struct pci_device_id agp_amdk7_pci_table[] = {
 	.device		= PCI_DEVICE_ID_AMD_FE_GATE_700E,
 	.subvendor	= PCI_ANY_ID,
 	.subdevice	= PCI_ANY_ID,
+	.driver_data	= (kernel_ulong_t)"761",
 	},
 	{
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),
@@ -517,6 +498,7 @@ static const struct pci_device_id agp_amdk7_pci_table[] = {
 	.device		= PCI_DEVICE_ID_AMD_FE_GATE_700C,
 	.subvendor	= PCI_ANY_ID,
 	.subdevice	= PCI_ANY_ID,
+	.driver_data	= (kernel_ulong_t)"760MP",
 	},
 	{ }
 };

-- 
2.54.0

