Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022092.outbound.protection.outlook.com [52.101.101.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F0F3F20E9;
	Tue, 30 Jun 2026 11:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817783; cv=fail; b=iRuIUBmWZqia9odh4YiYaN2xbyNwAWXs2wnmKCx/BEwQpdp+cEBU4RLREHlnjDYdWvLbjaQjpUayXx0xHo2u/UQULbw8I2gu+J1IWMdz+DI2ggRXw72bpEX5Br8Z/Ybg6CxQahqP2+15UA/ar66OEr9aqQX5kk0c3qO2j4n4p68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817783; c=relaxed/simple;
	bh=0BTTSUlaHo/kRt0x/5Ae/tfZKK8GDqj8ro+qSX+JD/U=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=CC4gCU9/NopLZW13GIPZOEuA3IFXrUrYZMHnt+o2xLgTPDw2CKS0tH+T35Ua1fBLMCWflBYsEhF3qb9xm5W7sAsRKsbtvD5XWfV7Y+uwHnynrrqojSzN76172SijqHlWdMDWSjDtc1m1kqu7h+jUEjZ9oSjURoefm2FdYUZ+RXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=j91iHjzs; arc=fail smtp.client-ip=52.101.101.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="j91iHjzs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lShK+R+f9L0LRxR5H8ktmzaOEdNHEKDH/Ahh8TzEZ/GXN3D0pKA3BAKrqiSb/2rASReqj0OB/w+o8qfER9+zW+gTImT6lJPMrr8tJPv3nYZi5xLRr8uy7UKVwkiVgDojogd96g/JOMSbjWO9QlYf1w6c9pj9FyL30fs34ZVv1KCH+V9iLtg5eZsQytMAXka4j3ZxHgWiJzsWWq+x5yV/VHJ5IpJF81ux/emS03E6m7tqxkgvRA4If80d6wR3Hk/3PnCHKV7f6y9QYmeOPdznzxHAQqZAGNqK/vJJPt1ZRQh+tQ0anH/T2li7V7aT6zS2FFaH15syiTv+uSrDH9N12w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i60wG8/jQ+r4/OdRYg7rQcoHD/59jwkc+3hn98skLGg=;
 b=RcMlAHlD1muo1+qOw9IWP0K3oRgSIrdNBQEGQ60gyXZtTOu28kUMrOhxUZ4QlEdY+fKC2KNkQtasHceorywAr8MLFWw2jvmrMwc+WIcczzU3/o0I32+1j0+RbSVjh+dS9MDvpTMTUtJEg4jigKGQUtorASKvtY+Ak+vljhu2oylYiYnUzj236MM0iEcq3nfMYJXmUIcrGlro60FBmg2VIwt0vnkab8HUMf1A6wJF2rkpFhGd5vf7R3vsibpPPLSu3W6uOtLeZ8iog05ZX0XPCpGMPjs6/Z60/Qcezn0lf3Fc85HRE6ljFRlC0+uTTN78EkVdyLoa4V1f+dLzlxcwDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i60wG8/jQ+r4/OdRYg7rQcoHD/59jwkc+3hn98skLGg=;
 b=j91iHjzsIV24bV6eVurpNoigoLJDKdG3SQqicNm+AuTljI/b2Z+5gysdyAX7L6OZvX1PY9UjLYbP414Qu/StbtSDJyfvCC7ACeL+eCHzXVBRLaumj4mGO53RHFlYTp2RjFg5AZJn8Sn908z3ChapK07/54KhxfPVEJBeU5JXz38=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CW1P265MB7689.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:219::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 11:09:24 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 11:09:24 +0000
From: Gary Guo <gary@garyguo.net>
Date: Tue, 30 Jun 2026 12:09:01 +0100
Subject: [PATCH v2 1/7] ata: don't keep pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-pci_id_fix-v2-1-b834a98c0af2@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
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
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-pci@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, 
 linux-scsi@vger.kernel.org, industrypack-devel@lists.sourceforge.net, 
 netdev@vger.kernel.org, Gary Guo <gary@garyguo.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782817763; l=1444;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=0BTTSUlaHo/kRt0x/5Ae/tfZKK8GDqj8ro+qSX+JD/U=;
 b=7QfOF/UYpyqWExnz9YZUyJpcb+tw/J77Ahr2EX37rscj3Lp37L+qH3g6rClEgI6lT7Dd59zmN
 sYYY8uOgvUQDMSAlD/MzMUMJvwJRYQvHAmr5etj1IYAWjMxTfk57mW2
X-Developer-Key: i=gary@garyguo.net; a=ed25519;
 pk=vB3uIX95SM4eVrIqo1DWNWKDKD2xzB+yLLLr0yOPYMo=
X-ClientProxiedBy: LO4P123CA0142.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::21) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CW1P265MB7689:EE_
X-MS-Office365-Filtering-Correlation-Id: b770ec44-f6f4-4991-8a90-08ded6980ae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|23010399003|22082099003|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	LINaVqxztc10T6GN/zhUFHDLBlmWVVKQPoPjNs6KOjmi0aK81bZPCh4UvA36uC8VtX3cge7CZ3duS5nkjRDbTStM4nvAMe8kban0BxBQMPjCaHUXsKrYi5oaLMvirjb0uWddL4dja6rBlt+tz5RUipUeQpDMdU0X6Gn0ZQGb5eNXwoEpuwnnhK7ROut23JdWT5wopmrNw/dwUCyFWQNsunthpfT/YvdQMY2pDekR48EBjftIaL9YQms1/DbKLWqwwcJQyHTsLERU/c9KyuRFq3lnFYM+Zg3KxL6EPFXCdnjmfcyMm5l2yUt6cYXXwMzz83zXx5ArO9/X6S2w802cTv4RJAPm8DfDOIgTVMCQHRNz1ewrFOCjq832nxtKUsaGyNpqgmDQ/qfh6vvzmaJwPBGEqc77xN72JViNYmTzIENbKdsgt8LWqkpoWRGn8mmuanIFG8Zz/5xzsHzZKjcQfltfYVlnjnx0rnuHSkGL7lQwQH+nSDOKXMT0zeORRhOR2fryAbipMl64Gvdp1/NWKAqotP7uwa7OUoDPwRUPHPDtI56/6JHgPojJ7SAx0jlalHnUDbFbDqk7oGA/MxwnisiqhPo0ZwLu0dW79z06LarCrxrPBgOEB9gSVBtrDtXmBII1nqVUFUHrba16jito9pa+WPjr9d2WUJmEGLLcGHZaRyGliq6bFo7DmOFmbUT25a/7Nd5EtRy+5MWz7uMscw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(23010399003)(22082099003)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkRyUmp5UmhCSFJBeTREbFEwVkhrNUl1cGowZ1ZNcXdQQzBNbHlKRjZOdisy?=
 =?utf-8?B?d1h3dlo1WTJUSit3WllsU2pLaGIyY1BJMEtCbUFmT25lZkZyOE1XenVJYno2?=
 =?utf-8?B?YVhhN0JTclJBOHdnZDhSMVZ3dGxFZXFyZW4xWW10QmJvbTk0bVd0TDYzRUFI?=
 =?utf-8?B?b1pBNk12MU15TDJ2VVR3dHU5OHRsRFROTGhwSk5LNmZjejlmWFZkcVRvMkRq?=
 =?utf-8?B?c29GcFQrbkduK1h4aHFFQmREeFJ1WTZPYUtJdnBraG9SWkdVNVpNaUI0YW4y?=
 =?utf-8?B?ZDBpM1g0VnZSWkd1UjV4eDJxYlJOcUg3OTVkbjlkZGxWU0h4YUtDVUxlVW9l?=
 =?utf-8?B?TlVHRjMwV1JIMS9GUnkxM0dLY2x1a2dYOVVOdVQxcWVuUGNoQWtvdW1hL09L?=
 =?utf-8?B?UHVyRHFqUEF3ZHBTd1lPL1Npb25lbGt0MTVHSmxaNmF0bDJKcDhkcE83MGVN?=
 =?utf-8?B?bmFuYzErdlJmU2ZVZGN1YVFvOTVyblBBcElPcGFJc1BwbnRTUUhiWkNOeWNa?=
 =?utf-8?B?R3laZVZFajNsV3hSOVAxeEUzZEpVRFhOdDJWT1UxZ0NXYzZGNTR5L2lTK0M2?=
 =?utf-8?B?ZjJFTW5jd3FNSjlMampwTnFCNURKeGttaFRhTk1WVEVyQTI2SkQ0V3QxRklY?=
 =?utf-8?B?OU5ieGRMYWVFcUd6YWJiYWxnTFliaWhBUEM1Q0ZJNmVTZjNveVZncmEwMnpY?=
 =?utf-8?B?eFVicXpYcFE4dExnZExhRm9PMHhQcWF1TlJ1S2ZUMHlNa3NTQjZtU0E4RFdz?=
 =?utf-8?B?MXhlZmFDbHFQcjNNeU51SlV2OHhFZHVDKzRJUnBhOHhBVGVIdjhZNnF0Z2Yz?=
 =?utf-8?B?cG9VMXpiRXZIenBieWVmT3gvempzNlMwVmRzTmlwNmg1NGUzSHN2RitEbzVU?=
 =?utf-8?B?dU9MRDF5b3VIdlloUGl4Znd1WDhBcDY3aDR0VnNrZUtRU3Zvb1h5MVZTOTJL?=
 =?utf-8?B?Z2N2VGZDNlpRSU1Wc08xRjVKTmMzU05VeVN5d0Q1aHl4TUYrWSs3WUR3bzdq?=
 =?utf-8?B?MUdYZU5DbWUzYzNNSUl3elpUN3lQM2xrTWRmazIrYUE5aFhCNWszZWp1UWpJ?=
 =?utf-8?B?TlM2U2llRWQ3MDJUUkVrWmpycGczcS9maWZMR1lwSzd4T2FKeE1Qc2FSZXIy?=
 =?utf-8?B?emgzUVUrOXc1QlNmcFhvYlF1RCtoWlhsaytxaENRaFpqMVBRb0kveHpRNUhu?=
 =?utf-8?B?eDFzVGV6SXBUREdTSVNnOG5QbVVxMDR1aUQwaThhcDZ0ZXlicDlQdmx0dG51?=
 =?utf-8?B?cmtsbnhiRHBJbFZkWkpkVnpQSURNRjA0ZWh5WEJnYWtKMUZhLzJUczd2cEli?=
 =?utf-8?B?VEJLanNEV1VFMHF4MmNJZTJpUFJlUWxOcW42L1JCc1luenR5UFBVU2FKbzlG?=
 =?utf-8?B?a2c4MHRvcVdqUTc5YTc1VkNlbU9oRGw3U0pDYXJjKzVDN1pmcG4zWWVkL0dz?=
 =?utf-8?B?aU1Qbk1LV3BtZ2JkTFZJQmlXOGFlL0g0U0xWeEUwWjBvck5OeXhraEFuakYz?=
 =?utf-8?B?VUxYZmVqbElwV2srbXZsV2FaSFlBcW03ZitoZDBlV0F4QnY5S0tFcXFjeDk5?=
 =?utf-8?B?ZStTTWtlWDgrN3ZySDZYaE85QmZlWEtrS21wV2phb3orcGx6ZFZpNXBiYk5t?=
 =?utf-8?B?Z21WYWpoZXY4RXdJLzNIVW41WkNvRFdsUk9lSDlBZ29VTkFnMjFBZnhPZUVn?=
 =?utf-8?B?RE1YbXBPTGU4Q3ViL2M1YmwrRllGWkt1dzlkRWI1ZXFhMmhOUmxydEJJODBm?=
 =?utf-8?B?ak9CQzZWN3ZBV0tZV2RaU2xJdmprbVZFU2JPWnFKZXJBY0ZoaGRkdjNlbDha?=
 =?utf-8?B?V053NlQ5RFBYOFJZWituWU9GVk94Y2tJTnV3WlhrUFBSVzZlYVJoNWVIOVpv?=
 =?utf-8?B?WWZaT1dGNzdVZm5Vd1BnZ1BKTmRRdzRCMjZLZDFqa2pjYytZZXBKY04xcWJO?=
 =?utf-8?B?YkdWcHA2OGxKS0FMb1VUQ3FuZDR2OWZnejI3WkljN085U2J1RktJZXNYQU5L?=
 =?utf-8?B?bzVTK3p0UUljdUQ0YWJ2T2Q1R3c0dzh4d3VtL3FKZFNoU0xoQW9uVkpLYldU?=
 =?utf-8?B?cFhlYU1GOGpXNFFCZEc0a3EvalhDcE96cVVEQzhlYVkxTjNWcFR3UWphOFFW?=
 =?utf-8?B?dWxZVDFob2s1T0xhaUpkQnZWTXlpbU9xSCtxQUl2dkcwdXcxNG51VWw4QmVT?=
 =?utf-8?B?UTRnVVNKYldLR01tM0ZzWmJZN2Nzd3hpMmVnVENhVlJ2YzdFTHVNWHJwVm5J?=
 =?utf-8?B?QVdvNEE2UHJ6ZTBxV251bjU3Z25jbjNiK3lKQ3dSNEdxMmxUZ28wK1pvRGds?=
 =?utf-8?B?OTYydGRQMGxmdXlkSXMrVHVrR09nZU9oREJUWEttdFVSL1lXWmZ1QT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: b770ec44-f6f4-4991-8a90-08ded6980ae3
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 11:09:23.9928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HkdaHG0zeI3zlc+j66SVvdtqFBIervSqNPYeWN9IrQIQ/FeXKRM7ML8FaocFFM3SVbikKd36jY9GcytBhCpXMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB7689

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/ata/ata_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index e70b6c089cf1..18ea740ca582 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -51,11 +51,11 @@ enum {
 static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_port *ap = link->ap;
-	const struct pci_device_id *id = ap->host->private_data;
+	unsigned long driver_data = (unsigned long)ap->host->private_data;
 	int dma_enabled = 0;
 	struct ata_device *dev;
 
-	if (id->driver_data & ATA_GEN_FORCE_DMA) {
+	if (driver_data & ATA_GEN_FORCE_DMA) {
 		dma_enabled = 0xff;
 	} else if (ap->ioaddr.bmdma_addr) {
 		/* Bits 5 and 6 indicate if DMA is active on master/slave */
@@ -206,7 +206,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id->driver_data, 0);
 }
 
 static const struct pci_device_id ata_generic[] = {

-- 
2.54.0

