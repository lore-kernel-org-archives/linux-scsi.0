Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020136.outbound.protection.outlook.com [52.101.196.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05FB379C5B;
	Mon,  6 Jul 2026 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347115; cv=fail; b=vGgyvTJkcU1r4jdNtQFJp9nHJ5Eo/xJrOZ0xBtLteywBos6fQCTa3JlK4ipthFSvqYWUa5fSCebQXtorUZAyPN1cpX8Tycp7UjUCk7qw/RzJcvatnJvwXrPcVhac8Wh5fBZbZ1IW1c6PoxX4R0EAmD+YUjgLyBOGXu01FTpY8rU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347115; c=relaxed/simple;
	bh=rbBgToMbuEBiN10J1PqepILFai3LonLZ15AWi0qSW/I=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=QbXaVjbGMFBPd7WGw62uWsIRCQNvObFU8EcX9FUm2WUzxh753uUMDBL7hjToEExRqQRZORY+y6KQXqWzo1UrWriWsk5nnv8B4e6bAhLW1VgvwN1nGvdeWQD6FLn21Pak3SgrASNTnPqwChvy/rVPM3/dxW+D6JLUNp1nqhL8UqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=mDlQIOi/; arc=fail smtp.client-ip=52.101.196.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="mDlQIOi/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xd6CzndBlAIcbiMULUx/yVdabptshpvwJw/RUzLhFXanH3ZvSkqK/o5LRdaeJAeGuW+OEki4S5fClKR2MAidJ0t7MCCpgdMd2awUgCCk0qz+4x/6/qSaxqSNg/gSvutzM096cjjqM/pjit/eykOU2xhqHyKgCnI9H/2YvtLfkPKeYdUmojbg1pznB59gc8Z1Pc/z1IYqmx4qyswVCL7fpf41A8gZ3hFsXNWslWoufnFFGlnzfzz10CWku2HymxhZuLXx3TPyMPcE40VHUXZqKiGg2xu6D8zmdzMwiBJkfXOS6AxOtvxAPYtkPv6oMdn/Wos5e/15asx64HmL9ydABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oT1dzY/rsFmfcLIFZ+LzLqLLm1cGpsCS2Uce9MdN8AY=;
 b=eDnUwIB0fPdKks/0+CWeH5pID8BxwgGtUNcU7wmS2ESf5lN20WnEJCt9IHZXrm+pG97pVa89FYWjsr2f+ySqq5okID1U5EAuU8PDLEkmpPObdCjcn/iiMZAhkItGxLy6IIVnS+vMsO5LQ1VzD0Wq0CdlYgZHZouciLHsOMzO2JFQHR6dDf1BC+5yDx8/M1A6biNFoASF2YnEKj4aZL+54/OkVgNU2XDKITJAYNV27bPMjyarzP+gC/AQf5zts3Unq86TtGbBZCXzwuwjQjiCLwyTpkHm4G7OznWN2jVv+xnHbiPKywxIqiKExqv+Jd2BGqofwjJYV/W6TGcLPO3+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oT1dzY/rsFmfcLIFZ+LzLqLLm1cGpsCS2Uce9MdN8AY=;
 b=mDlQIOi/+RSbFvpx0ILBltaHB7rFES3YJd8UXI+ceYT5DS3l1YiWC48eHs3FQGo+seG8PCjmCvLt6V6f0BB9kFi45oQ69rGgAKGfCinFY4m44USpe4Y/bgpZjHe2pVt09Rq5TCuSpovmWmzO1CskQvVBgy+7YxClB37V7suvqgY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CW1P265MB9444.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 14:11:40 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:11:40 +0000
From: Gary Guo <gary@garyguo.net>
Date: Mon, 06 Jul 2026 15:11:18 +0100
Subject: [PATCH v3 6/9] agp/amd-k7: don't rely on address of pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-6-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
In-Reply-To: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=2620;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=rbBgToMbuEBiN10J1PqepILFai3LonLZ15AWi0qSW/I=;
 b=wBtOqWl0+YJ+nMZ++pzf1Dr9tZh7MtGUgOXaUJYRJvgqMrdLY5acGNmdmmbE9fKJrw0Vxi06K
 bcNCUC6oVJKCdesTQFEssMOIqTyZuZssGhcwcbCiPJN71nFO5jF22RF
X-Developer-Key: i=gary@garyguo.net; a=ed25519;
 pk=vB3uIX95SM4eVrIqo1DWNWKDKD2xzB+yLLLr0yOPYMo=
X-ClientProxiedBy: LO4P123CA0509.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::13) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CW1P265MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d7a3806-7eaf-4de3-672e-08dedb687dde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|23010399003|376014|1800799024|366016|56012099006|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	NrUgavoWYu+5PlftNIV/l6HZzmfHeWhFYOL3vd4t1prg3Gfh0DZu0DtuwMQG2ps2NPM3txKJZywi3rHquKdtqLP3u/1bFwjmWY1BWn3IFzWnXvfpX4Lp8tknpImwwxCRZ/Bwo4YGP2zhCFWd7TtXDC1ibQR9MqlaHqA8NoQ6seZuIz/pHSpceinCinHg9TFeyDLdnsjtw41zf7PyjqcKN0eTfq0b/i/424MboEMjcgBIt4BJvGnUebmNde4Kj4wCmbmGrzD0Mb5cSGEzOVbld/t6NxWwSlmokevdile+9CbYnvQMIgLO5QpH8aR1d4B+tv0jHgas4+dYc1mm96PF/eFjt+on0qTqv+c8easlE50YukEiOwNeG/tfo7faR6RkwgeCPkh36UZz174bD+bTskv/Mhmz0bFgGy1qqNLuEZ/TXq1eATKf9686dfPgyjW79dM8oYhFnAOcps0A7+nX9QgzeC/Aqx57fC3FI+ajiQLLf3ooHrMnarMCyL6TyLq1Eozzu1p8Jz1OdETXYH8OOyJTTp7Oiza9Ej1luQ1unt2SMovAIkvxpW7nB9oj870L6BmwS3sAcG6yZla1K8HqH3kp1X3BWWispntEjAKNEuHnnoZC0A9As53C5RtTOdp4foAaXN45opTq2kwzRzYbHh0EwlqkCXaRDQf4+AuVf4xIFcPniSGF5CEVUVQcVxvy5uOvX1uttwAWJE/fcMbfQA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(23010399003)(376014)(1800799024)(366016)(56012099006)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkxQTWY3WDRYL3NBelJkbUFjV2M3b0tld0crWE9pWnYvUDluQTRPR3Voby96?=
 =?utf-8?B?enZsRkFZTWVwVXpxU0RhN1hOaGtISDNUamxNVUF1OUtuTlo4cUxybWduVVBV?=
 =?utf-8?B?dFk2eEdnbUltZVRFMS8zemtQU1J0RU1Ya0xLZy9TWmxoWXlma01xOXYwbmVs?=
 =?utf-8?B?bTBZS01MS0ZlY0U3VGx0c1VBS2FlN20rZ0RhREtaMi9qc0h3MGNuUWs4bDJM?=
 =?utf-8?B?cWV4YTJnRjZ4S0R5WSt2bEk2TjJNc21kQWEzVmN6R242WmMza2l1TW8yeGRv?=
 =?utf-8?B?RW9WTzgzWlZTWURjcHprc3QxNFozVzBLNWRnLzJIN3U5TDNnWUQxdXVvRkI0?=
 =?utf-8?B?bmIxTWVLZXVCZW9nWUZ5YkxQbkRKa0RoajIyQmVjV21sc0xRVUpoQk9qOFNn?=
 =?utf-8?B?Ylg3RmE3a1QrbEZLa0JWMnlMeExlTmsxZmVNV1BWYWNGSXM0eVc2MzNJVGxh?=
 =?utf-8?B?Q3kwZWJzeHJlTTRsb0J6cEVLSnJGZVdiMjVaRWtGbkovZGhPZVZEbmxUZmZ5?=
 =?utf-8?B?QmIyMWRWQVZya3FrUU91Wlg5TEd5RlFSMkpSUFErMm5ZUHhwcFJYN0FsTFB3?=
 =?utf-8?B?bHQzbWVIWkZvbklCR0g5NEhFaVNxQndBT1o4UUZnWkxobHU5UW54SUxLNlhJ?=
 =?utf-8?B?MDZ0YlVpR2g1OGNhaFRSbWRRR1prakNjL0NYbTdEZFlJeWIyVy9mOWFCenlO?=
 =?utf-8?B?dzVNQVVNdHBzdkxFT00wQzZXeEpJL08xbnZFdkR6azZYNnprblpUaGpodGZo?=
 =?utf-8?B?Zmg3UCtXVHI5ckJaVHdMSHhJTUl5M2JKUWhJTGZqV280cHA1T1IrYkEwUGNo?=
 =?utf-8?B?RG4xb3ViWC9TZzQzbks3a1hYazIydXp1V0FpWEptbjhiTENiankyUVovanJX?=
 =?utf-8?B?U2gvZHV0VFFvajRlR2R3dVpodzAybEdCMjhSaFFWbG1zWGJqaXNzaWNsMVpm?=
 =?utf-8?B?bXhBb2l2UjN5WFRzY2xZaGFsdWF6bDN1aUZ6NE9pajBZR0w4QkdGMGJxQzZZ?=
 =?utf-8?B?eEdwREs4bnZRZHpYMGNzaHd2dnBveGtEdkhIM2ZnQi9KVVk0cGxNdnY1ZEtU?=
 =?utf-8?B?MFZUZzFPdHBaREpPYi95ZmErWEpYZ1lzUmFvZmZjV2dEUEhyS3EwUDQzR3Rv?=
 =?utf-8?B?VkZVS1o0MzJpcWtCbEVUWnVhVWxwSTZvc0ZUK0xRQWw2T2Y5dXZlVjRoNFY0?=
 =?utf-8?B?NjlHZFVMb2IzcDZHM1RnbkF2Y2F3Vy9kYTRuZE1kMHRkQXFRajZ0T1lIaTdt?=
 =?utf-8?B?UkdCWWJpVkExcS9sQmh3UnlseVkzdEVrUFczeFd2WFJKeUpHblhxaXpqdEFY?=
 =?utf-8?B?RXNzV2gwcENlM205Z21LcVMxc1piNkNsVVlyTGJJa1E4UVF0VklhS3BuN1Zl?=
 =?utf-8?B?M2hIUndhbWpsRWxIRVhXLzBySExQbEw2WC9zcVNtWlFPRDNDeDhlTEJ6aG8x?=
 =?utf-8?B?WU40RWtMYVNvbjR4QjBxcTJGcm5IUTk4aG9wdlN3S1cyK2trL3Y3TXRGYklF?=
 =?utf-8?B?a25XOHMySTM4L2VzdGFvMisvTTViUlZweUhydkIxMXRtMlR3TGh2USthR21k?=
 =?utf-8?B?WlhJQlY2NTAveGJBTHJoNkZ1VHFzQnhjNHFBUFp5M0M3OU1xTkgwSVRuNHhE?=
 =?utf-8?B?TllGVjhGSk9WRHZKK0NsQk5hQmV4RDlyNTVkNnRDa3RLaFpqSzh6UFdwU25v?=
 =?utf-8?B?MDVMWXkzWHZkalByYmVscUVtUDlvZmJ6VDBGV2s0VGFGY1hqc3RYZGZDanBG?=
 =?utf-8?B?SnpQVnRtSkM1Nm9HNmIveENjYnNnY0xDaUJWNkpTd1lFYkw5Q2FxWlhLZk02?=
 =?utf-8?B?ZnRreFM5K3o3SmxZb1dZVU5iSTYwK2xvL3AyZTVZRXRoQU9Cb3dMaHJLMHli?=
 =?utf-8?B?ODkvWGdYQ0ZEUENHL1lBSkxlTHlTVEJNeGQ5ZU5pSVdCcFE0TmhUU0xBWGNm?=
 =?utf-8?B?N0NOZC9DQ3hHdEJzR2V3aW05cVVMZHhJT0V6UUsrZitxQ29yNDkxM0htMUpn?=
 =?utf-8?B?c3dJSFNUbTB1MHErK3UvM2hTMGdlc3VtMFJSRnJDZUZVRW16V2tIZElYQXRL?=
 =?utf-8?B?Tm90ck1PdUxiQmtCTlhuMmpRZmRGUTZZbkZCSXhCUXZYeHBrQzlCMTVQOXBX?=
 =?utf-8?B?Ym5tRzk4NVZmeG1KQnlTM2tDM0FZM0hJbXZTSTJHRmZTWUFzMS9BRFVUbk9V?=
 =?utf-8?B?RWtWR0kwOFVJNmRRZ0trUlJJUTVMc0h3UHZjTGZtOTVmYXRrbCtGbGtRZG02?=
 =?utf-8?B?VVFvd3RuTTNvTDIyWEJBd2V2WkQ2blMxTjRUeWUvZzlpeUZ3aFdhdGhIYWI5?=
 =?utf-8?B?OHdzTG0wM25ZTU8xRXllR044UXZNMERHeG5ZOFhxaXVnVHhtSTNNUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7a3806-7eaf-4de3-672e-08dedb687dde
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:36.8847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBcAKTQg69JF1C6h/RJcb4IG1OqRxDwF5RuUh9TsBybMM0FP+z7ulu2eUddD6URm45i8SoHlHXQAjMLcfQJC7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB9444

Address of pci_device_id cannot be relied on due to presence of dynamic ID
and driver_override. Use driver_data instead.

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

