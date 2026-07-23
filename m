Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022093.outbound.protection.outlook.com [52.101.96.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D0A40DB36;
	Thu, 23 Jul 2026 22:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844118; cv=fail; b=SdqHzU7e4N8wvcrv1sAWdjTjt2NtU9lAEHkb0XwzOZ15KynmoU81RTPbYb4KT9bUN1w3EiIWiHlho4yZQ/Myw4xtvIoGZMc2UFQHikqRjlh435X8gMXenRZjGqCxGCOzLSPWS9Ym5bogij2Bi6eO9hLP1NkFTqpbReNlZAkWz1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844118; c=relaxed/simple;
	bh=XiFu9kvrFQK90dvD0aweCU++dyfWZ60ULurPbb9FcZY=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=rkeGwDbMQzD++0hm/jFAF1SBimoYMSyGy4CMuh2KcprOuLbAjeDAAE0Vp45LR0w41zNtzFjahITdLaNGWBJsLLc8zwlLyzFOHHOFvsfwgTlgsMJiOI/hy411UEdFevWwAU3RunJn0upL6mFWzIKE84LcHaHvmm/RqU4i6ag/JTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=gybejE8q; arc=fail smtp.client-ip=52.101.96.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="gybejE8q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H46OO9jxhVNqB+7FAoP5CnodEUwFyk4AK1TZ35Z0otaWxsHdpW8AmaUp8au3uuHUvX9Od3a8QjuaOsf3jUwjs07NiKigv4yTgnJG/FPb80PEdBS8i9LEk07r3qwtAyKko0sTy0Jd8SrOOM4q1Ghql2/++/yzx3cAiWHnicHilfZtoZ/r40ulRCp2RIvakR0v1a6cSEKmRO0dq8+djMLvTeuEdGTXgc9PKBgUw51gbuHU0rtzcNOKZpR9/3gTHQ+mpU2YzVVFj6e5/LTIdt4xcFWHamtR17QrRl7wgUf8/m3vU7o9o6P7UrhuDicL6EBOUucjCjLniO9VPwskRIcPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WookShkx7VXJwJSRfOgruHo6ExGvguNel5hk8sj2yNQ=;
 b=xo98O+Tk2/MUePlUSl6AFOQzIwh8JQDjv6EamjdqFKtJdR0WFJu5PHR6D1Wk/JE73hfYlj03mwQLqZOFZjKALzexHC5n5lo+Mkln49UQzd9OfNe7HjDTy92I+jOm6Lc4642WxoPpOGQFFh6qZfxIYGqvlL7h5QzaTJDSz5UxotsM4QEVFw9ktGL6skkcm8LS/XSMVFgc3EMwWJ3oEaE1i8CnhgNHO7tdqsXeOwUzT8uLtAaa5kI82OzqhudOfaSpumsWq1kaeghyqTnj33gS4oBJ1M4Lqz6B/YelbvdbEnbgdpkCLGJe5KWVh6gRb66GOtL6Jh1vIX2r2BYDhX3kfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WookShkx7VXJwJSRfOgruHo6ExGvguNel5hk8sj2yNQ=;
 b=gybejE8qgADSLnmKfyflC3sgcM8lUgZfvBhdj8k9eaTbzufqUwFJjjIsGN/hRp24YufxUInKj+h6UPXMWxFfte1Es4BqEtppdjS+vifttxiIFFQLFERPl++HV9o/gOmJWxB8wgVub3No8ptOUweEsYbburGWrKYiW52bi2MeeSU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 22:01:10 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:01:10 +0000
From: Gary Guo <gary@garyguo.net>
Date: Thu, 23 Jul 2026 23:00:47 +0100
Subject: [PATCH v4 8/9] PCI: Fix dyn_id add TOCTOU
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-8-3580726844e1@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=7668;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=XiFu9kvrFQK90dvD0aweCU++dyfWZ60ULurPbb9FcZY=;
 b=qEXJ3xmlrn1iCu1uPTRZtIY7dBzayXPCWqKIH/apAzlZwmqKztCxdlKW9kLjQQ9d3ZOX++47z
 G4pCpZ6xKFwBzkAZb79jBhAO7jfY7bHiA9SVn0KwMgt+LtLZBk+aJvU
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
X-MS-Office365-Filtering-Correlation-Id: a8ea15f4-b508-4d59-e8bd-08dee905e7bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|22082099003|18002099003|3023799007|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	paMPsxkJmAykSFqtiTmP0Xpoe2dyLqMceLrM8K+RL2rDSdP0hWGIzuJd+yYKsJiNjPQoYm6EUdJFWzzwOVOJ3rgd28Su+ovwfAlXKPLJX6FNQs4kj+Pq4m1oPH1ogpS7m4OFGf2fJQinRA1/CHsR42KcUz1+gLOuHCcIVsNaM2t0SPcTTQyz9KuLXhDLW6Bwm3ZZbq7WDmfmzgg4w18wKGoj6XpUIc7y8iUMEO+Fdq+9bX1AzLn2RwKLZTpWboOTeXrVRMbxa2k66XPZcs6KtyH/dAr6z8qgSeCREW2LCX8leWRN2NfpS3DzxiERJ63wEu4vyeGETjPR4HgBKy+K6zRLpjtzGQliqnxk+rKFKPN8e/CMqBLzkR6NVg9Jk4CRburUnf/LfKvB1+rASVef8daWTkg+qhIIzdGVQZ3NKcusQsxLegP9yS7AKMAJy+zwnN2Q1Yuj3gyHvzthb3ik7aC6PCXeRcdwhsQE9OhgBUaL0NtZvg77MQlsa7+wpA++s7MN8ErXC19SQyIbKfvEcCsM0SXdNh5haQAkjIk+Vytrfrj+N7jEgCGmVEdUTfJGppCkKU+q5L4LCwNLtqlsSQodzCYzO/soNkUgQvYmHOIHSXdWKR0fZ7tq6O0Sy1Poanlnp+WJGAnWAR5Dm4MLRN306n49gAAfliy64/gx6a7MZJGEKPlxcWeWiIx+WFin7zwfwi78zJS8TmhOxEqZRw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nkd4bGxOcEY4SHQweDg2TGN6Y3hURHJWNEhucUd6bFZhT250NXdSNGpsYlEx?=
 =?utf-8?B?SkpkVFRNaFBzcmRiQjI5eWw4bHFaVmRweGZQdVR1S2VselI4bmk1UnBEdUg1?=
 =?utf-8?B?VWI2cWNDZWdhbVRJY3VTdnVWZlhwaU5PMDlvS3ZVYnhCV3FSNXAvZXlvQUNS?=
 =?utf-8?B?RzBraXNxaTJWeEdmVmo4Y3dZRmdEZzlmMHJTcVp5cy9GKzg1Sm1PQVVwVHRp?=
 =?utf-8?B?RFk2NHVwTHdrWS80eVJrL0xpaGxTTk9xeXBIVnVBQlNwSUNkbXlTdThwOVBj?=
 =?utf-8?B?OTJhYTU0SVNxWFRYd1FuVFVPUmZqcGJHU2ovQWhRYUc1aElJa0dxamNtZys2?=
 =?utf-8?B?SVhqU1lIaW9tRzU5Zk5pVkd5ZjdMMnBkSWI4QU5XeW10UWdmME5taElTMjV2?=
 =?utf-8?B?VXFuWjZlZEpmTGJMclMxTkhyMFhucW9VaS95Um5QZWd1eEdLU2hwNFJtS3Fq?=
 =?utf-8?B?aXVzN3lONkpnWGowSTRXdk5pQnUvSXFqSklOb1MyNDVVeERPekI5bElqRmlL?=
 =?utf-8?B?elBPZlVBR3VBY1MzSjl5WHlRNnU3enFKb0FPaXBHbG5iVkcxRUZZMGt2WHEr?=
 =?utf-8?B?V3U3V1phekE0UkRLV1F5M0ZSRzJnNVMvSENhSWlPZ241d2l1T2ZJUW5HZmdD?=
 =?utf-8?B?Z2Z0eGhzY3N0cnlBaUJkN2VENWVmd0c4Y1p1SldieGYyYVo5WEVnUUhvdmI0?=
 =?utf-8?B?L3B3cGptTXQwVjQvcjJGVG4xQVM0V0tCV0RQZEw1Mld1V29KQnRqd1RYTE8r?=
 =?utf-8?B?OUJic1pLY0l0Q09lWHJ6V1g2cGU3TUxDRXAxNUFJT21UTUxaWXMrU1dkZXBi?=
 =?utf-8?B?cXFPUUFOV1hCWjkvRXlNVlN4bHVBaTFyUVBpeVVFK3JTVElOdlZPRjBkelRJ?=
 =?utf-8?B?NFowM2tERFFtbEY5cGVudXJwRnlYZ0VYTHJBNis0a1prclduQnA3cjZaQ09V?=
 =?utf-8?B?YlVCUForbGN4RDJ1bzFMNFF1ZTlYMFVtTUJZdmlwLzl4SjBVdTNzTythUjJU?=
 =?utf-8?B?NGNBMmZDejNkV0dTQTgwK25EejB4SlFkQVVBZGw0bHJ3c0w2aFNRSDhwZlhq?=
 =?utf-8?B?Tmhha3ZjaTNzVGZ6Qk05TTJlS29aelg1Y1dWTzNMbzRnd1RQdUJ4MWZxdVBY?=
 =?utf-8?B?VFVESmhHZ2NldlkremtYckxGcG1mNGZnZHpxSGhtMlRaY2VsVDU3R0FJSXNB?=
 =?utf-8?B?eU5jeTQvWFpiWmZzT01YalY2Mk9DYUt6aWYxN3hVUjF0aEtmaXRUWllGVVZO?=
 =?utf-8?B?bFlHcHJaYjMzL1BjSDhnQ1d3dG5tRjZVZlBrK1lYSnFYcFZiVVBIV1FOREph?=
 =?utf-8?B?eEl4TjRDb0JkZ3lFMVgyS2gzRGtNVVJERzlkU2l3cW1Mc2Z4aVBla241QWNN?=
 =?utf-8?B?RHJCaVRWYmRLaHlPbkNxYmNsUzZvMlpkZjBSTHUxZXBLbFVmajIwVSt3ZTZZ?=
 =?utf-8?B?akQyOG1xWlRuRG1HUkxxc29sbFdHVnROT0RtTTcyT2ZhdSsyZU5IdHBNM2pE?=
 =?utf-8?B?czcyUW82VllQbGZadHVRVjQvcHVoLzdmNDRrbG5Jcyt1bU4zYU8zMVp0WmpV?=
 =?utf-8?B?TW0zQzRSRFlxeUtndlkzQkYrZTRGUVFpNWNHZTJUVE51QXBuNUdGLzU4MXdk?=
 =?utf-8?B?UWx5ZG1TcmVnQU5Nb1FFVmFDRndlaW85RFZYdnFqL0lGMnpBdXFZd29WK2Qw?=
 =?utf-8?B?dFhydHBya0sxQkhjU21pTVo2MmtnYk1lYkJTQjF6M1ErZ3o5dURtSEIzTHc4?=
 =?utf-8?B?amx0SjFoZTlTSDlPZUhFR25XMitadGRTVkVDTmFpTDBxeWg0ajhheU1UcFFs?=
 =?utf-8?B?KzlBMGljNFZyeHdhUmxwUzluUGNFUURkVVd4VHRoZmZXZitVeW1LbytaTmlQ?=
 =?utf-8?B?bmZodzU5SWlBaVZOcVZiYUcwdVIvaFp4Y01jSVRqWHBHa2p2V1lBZmNwRTRX?=
 =?utf-8?B?emI4Y3oxVmQ0bGszYTUvdnJTL1NUT09QdHIxVjc4cFVncXZTcHg1QTFITzB1?=
 =?utf-8?B?L0dxN1BCNnd2OTlBUkdZS1dVVytjRy9zVU1ZWHlPRDRaUXdmdnFoWXZpVHh4?=
 =?utf-8?B?S0hBeTEvbWJ5Ykx1Y2ppZzVWNlRrRmk0QzBlTVEwNDh2YzRVdThsMGNOWm1Y?=
 =?utf-8?B?K3d1cTJnSHRwV05VTk0xZThMeDJJQURaZ1VuRnNzdzB3N1l1VWw2WjNTYnA2?=
 =?utf-8?B?aTh4MTdaNEcyOVc3Mm91czlSb2grUXNnK2VQcU8zZGRqcUJFekZlc1Z3SnVI?=
 =?utf-8?B?NVo2M2xneUczOG85b3psbng4Y05COXA4WDJCenBwV3k5a0JNWDEycEJsa0U3?=
 =?utf-8?B?Um8wbGpaaFZMSlhHbHBLdXBqVXdOZzdkT3ZuaWVnL1ZKZDdicFMvQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ea15f4-b508-4d59-e8bd-08dee905e7bc
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:10.5755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xm5KNQ+mnydI33sdFIGbhKMyCdyWrrltzz0k4ooxhYL78VVXngJT61h/CzSHsmns7im5EkFwHM05RcPvk1PTBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

Currently there is a TOCTOU issue in new_id_store() as the dyn ID insertion
in pci_add_dynid() and the pci_match_device() are in separate critical
sections.

Fix this by moving the existing ID check to inside pci_add_dynid() and only
check against the static ID table outside the critical section.

Fixes: 3853f9123c18 ("PCI: Avoid duplicate IDs in driver dynamic IDs list")
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/pci/pci-driver.c | 140 ++++++++++++++++++++++++-----------------------
 1 file changed, 72 insertions(+), 68 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index c9424edb4548..ab3bb756ce89 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -29,6 +29,47 @@ struct pci_dynid {
 	struct pci_device_id id;
 };
 
+/**
+ * do_pci_add_dynid - Add a new PCI device ID to this driver and re-probe
+ * @drv: target PCI driver
+ * @id: ID to be added
+ * @check_dup: whether to check if matching ID is already present
+ *
+ * Add a new dynamic PCI device ID to this driver and causes the driver to
+ * probe for all devices again.  @drv must have been registered prior to calling
+ * this function.
+ *
+ * Context: Does GFP_KERNEL allocation.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+static int do_pci_add_dynid(struct pci_driver *drv,
+			    const struct pci_device_id *id,
+			    bool check_dup)
+{
+	struct pci_dynid *dynid, *existing_dynid;
+
+	dynid = kzalloc_obj(*dynid);
+	if (!dynid)
+		return -ENOMEM;
+
+	dynid->id = *id;
+
+	scoped_guard(spinlock, &drv->dynids.lock) {
+		if (check_dup) {
+			list_for_each_entry(existing_dynid, &drv->dynids.list, node) {
+				if (pci_match_one_id(&existing_dynid->id, id)) {
+					kfree(dynid);
+					return -EEXIST;
+				}
+			}
+		}
+		list_add_tail(&dynid->node, &drv->dynids.list);
+	}
+
+	return driver_attach(&drv->driver);
+}
+
 /**
  * pci_add_dynid - add a new PCI device ID to this driver and re-probe devices
  * @drv: target pci driver
@@ -56,25 +97,17 @@ int pci_add_dynid(struct pci_driver *drv,
 		  unsigned int class, unsigned int class_mask,
 		  unsigned long driver_data)
 {
-	struct pci_dynid *dynid;
-
-	dynid = kzalloc_obj(*dynid);
-	if (!dynid)
-		return -ENOMEM;
+	struct pci_device_id id = {
+		.vendor = vendor,
+		.device = device,
+		.subvendor = subvendor,
+		.subdevice = subdevice,
+		.class = class,
+		.class_mask = class_mask,
+		.driver_data = driver_data,
+	};
 
-	dynid->id.vendor = vendor;
-	dynid->id.device = device;
-	dynid->id.subvendor = subvendor;
-	dynid->id.subdevice = subdevice;
-	dynid->id.class = class;
-	dynid->id.class_mask = class_mask;
-	dynid->id.driver_data = driver_data;
-
-	spin_lock(&drv->dynids.lock);
-	list_add_tail(&dynid->node, &drv->dynids.list);
-	spin_unlock(&drv->dynids.lock);
-
-	return driver_attach(&drv->driver);
+	return do_pci_add_dynid(drv, &id, false);
 }
 EXPORT_SYMBOL_GPL(pci_add_dynid);
 
@@ -94,16 +127,20 @@ static void pci_free_dynids(struct pci_driver *drv)
  * do_pci_match_id - See if a PCI ID matches a given pci_id table
  * @ids: array of PCI device ID structures to search in
  * @dev_id: the actual PCI device ID structure to match against.
+ * @include_override_only: also match against device ID entries marked as
+ *                         override only.
  *
  * Return: the matching pci_device_id structure or %NULL if there is no match.
  */
 static const struct pci_device_id *
 do_pci_match_id(const struct pci_device_id *ids,
-		const struct pci_device_id *dev_id)
+		const struct pci_device_id *dev_id,
+		bool include_override_only)
 {
 	if (ids) {
 		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (pci_match_one_id(ids, dev_id))
+			if ((!ids->override_only || include_override_only) &&
+			    pci_match_one_id(ids, dev_id))
 				return ids;
 			ids++;
 		}
@@ -128,7 +165,7 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 {
 	struct pci_device_id dev_id = pci_id_from_device(dev);
 
-	return do_pci_match_id(ids, &dev_id);
+	return do_pci_match_id(ids, &dev_id, true);
 }
 EXPORT_SYMBOL(pci_match_id);
 
@@ -153,7 +190,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 						    struct pci_dev *dev)
 {
 	struct pci_dynid *dynid;
-	const struct pci_device_id *found_id = NULL, *ids;
+	const struct pci_device_id *found_id = NULL;
 	struct pci_device_id dev_id;
 	int ret;
 
@@ -176,20 +213,9 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (found_id)
 		return found_id;
 
-	for (ids = drv->id_table; (found_id = do_pci_match_id(ids, &dev_id));
-	     ids = found_id + 1) {
-		/*
-		 * The match table is split based on driver_override.
-		 * In case override_only was set, enforce driver_override
-		 * matching.
-		 */
-		if (found_id->override_only) {
-			if (ret > 0)
-				return found_id;
-		} else {
-			return found_id;
-		}
-	}
+	found_id = do_pci_match_id(drv->id_table, &dev_id, ret > 0);
+	if (found_id)
+		return found_id;
 
 	/* driver_override will always match, send a dummy id */
 	if (ret > 0)
@@ -197,11 +223,6 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	return NULL;
 }
 
-static void _pci_free_device(struct device *dev)
-{
-	kfree(to_pci_dev(dev));
-}
-
 /**
  * new_id_store - sysfs frontend to pci_add_dynid()
  * @driver: target device driver
@@ -215,38 +236,22 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 {
 	struct pci_driver *pdrv = to_pci_driver(driver);
 	const struct pci_device_id *ids = pdrv->id_table;
-	u32 vendor, device, subvendor = PCI_ANY_ID,
-		subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
-	unsigned long driver_data = 0;
+	struct pci_device_id id = {
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID
+	};
 	int fields;
 	int retval = 0;
 
 	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
-			&vendor, &device, &subvendor, &subdevice,
-			&class, &class_mask, &driver_data);
+			&id.vendor, &id.device, &id.subvendor, &id.subdevice,
+			&id.class, &id.class_mask, &id.driver_data);
 	if (fields < 2)
 		return -EINVAL;
 
 	if (fields != 7) {
-		struct pci_dev *pdev = kzalloc_obj(*pdev);
-		if (!pdev)
-			return -ENOMEM;
-
-		pdev->vendor = vendor;
-		pdev->device = device;
-		pdev->subsystem_vendor = subvendor;
-		pdev->subsystem_device = subdevice;
-		pdev->class = class;
-		pdev->dev.release = _pci_free_device;
-
-		device_initialize(&pdev->dev);
-		if (pci_match_device(pdrv, pdev))
-			retval = -EEXIST;
-
-		put_device(&pdev->dev);
-
-		if (retval)
-			return retval;
+		if (do_pci_match_id(pdrv->id_table, &id, false))
+			return -EEXIST;
 	}
 
 	/* Only accept driver_data values that match an existing id_table
@@ -254,7 +259,7 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 	if (ids) {
 		retval = -EINVAL;
 		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (driver_data == ids->driver_data) {
+			if (id.driver_data == ids->driver_data) {
 				retval = 0;
 				break;
 			}
@@ -264,8 +269,7 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 			return retval;
 	}
 
-	retval = pci_add_dynid(pdrv, vendor, device, subvendor, subdevice,
-			       class, class_mask, driver_data);
+	retval = do_pci_add_dynid(pdrv, &id, fields != 7);
 	if (retval)
 		return retval;
 	return count;

-- 
2.54.0

