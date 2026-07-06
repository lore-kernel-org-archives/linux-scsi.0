Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022093.outbound.protection.outlook.com [52.101.101.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8697F37B40A;
	Mon,  6 Jul 2026 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347126; cv=fail; b=puJllpglcMjRWMFNUxHcap56d8QxUcEB4piKvj0yGXzT5ifWUprSX692SsPQ57PqMVaEDcrCMq06ETmcUzHdk89ptrr2pq8iIoKu88ud16KOjbHg8LRV0J7bUknFtTSaqvLTL1Z3XbbJSvTcs1Zp4rYMF7VLNzRuBh6jyze687U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347126; c=relaxed/simple;
	bh=Uq8OGAcHVw6a6nyxNc6mSwt8JEqAoheaziIIndM7prc=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=V3xt91t7zAVGBUnzFnXQw1MgaljN8V6VXg1uNJ3Ue056H9RBaJHRLjiZyjHJeQOdLfXUQUp/yytpQwhGSgR7+bvKHFUIWMXnsDnouvi7L1PLT81psqduURovprgPhV1qg83mT6JKZtny4KY0IrFnyQ8p4ZlFL2LChhbzm/RgnLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=NerLvY/P; arc=fail smtp.client-ip=52.101.101.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="NerLvY/P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GesQYXXRRgAbtu4axPLFZxLDkh2yoXzYdWJ0ehr/e4tn2fDhw7N17f5q+XTeg5ScGZ3Sh8myOwD8jlHU/5alkjOR815WDCFkf2lyebGwY59PSpxqoSHv0tIeCTeWkL51NLmzoiqqNeeBxk8q6r5V0kpkJiFDGK5TjW0DIW6RUYH7uuQ3NGAAC7z12wPQcJJK7Y5bqlhT9l2+0jqXZDe+as6QuS9AQ9S8JogG16PBELlBYupjDFQFTWgzKi45KTkZ5lwGaaqGxSMq4fmD/vFDoPrPF2ts/C+gBCcQbyjufCtgzivwBpFgL0Qp2VKuYkUJ4um6xPWKIvgHJE1xtPHtVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqNSoU/Ele0jA7ni0VEhW0LfdshmnP/44N5SKfvrdQA=;
 b=fYzRWn2gyB4aQL+70JQ+Hw6r1W5tj9YwfFs1FQeoAr1uzJxcfMTPaSE0OKf1TFJPM6hsr0Kv078AkGmJMwRMLpfJWYXx3M+3gstrw40vBtNcSsDPOoKOGk3+WWtsutbs911eky85RGS3O3+Lujyj3cpAiGSImx/3bmR5Xc0+HB6Cylim71+OAitG0uNe3zSAVHl/TrONW9x3/mbBmC36c/O/OZmEE6FysB2Qbm+JF+3zoAKj3hY1YXYu2HfYoovESkpmyqy07PXZeo2NhRDIFyAfF4xwImM/6txq1bAAzZOhaRy2CThZhePgb8S7FOlBa31nKfY1pWSfGYPIn9vJOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqNSoU/Ele0jA7ni0VEhW0LfdshmnP/44N5SKfvrdQA=;
 b=NerLvY/Pa5lbdWxUyMup0bquCo2OfKbhpeigxLNc8sMiuba858daigLJj55zCIdJCbiEzJEUM+UDzVm9TRk+4rYYj0LTspUpgsr4oVcsVJEzeXY85V3UgKk9DwC22hHsrIHaCqyPqZcEoir4wGGcam9OA+60Hu6Ga3U+fcOApmc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB7176.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:334::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
 14:11:39 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:11:39 +0000
From: Gary Guo <gary@garyguo.net>
Date: Mon, 06 Jul 2026 15:11:16 +0100
Subject: [PATCH v3 4/9] mlxsw: don't store pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-4-2d48fc025acc@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=2901;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=Uq8OGAcHVw6a6nyxNc6mSwt8JEqAoheaziIIndM7prc=;
 b=nw7XATEUQSIcDCGNa111edihd5qn5Ot8tHlwsGG5rd4Ars8pNuxoLwrYfAC2WRLZigZM4iFRs
 ct1IgT2GWJQD2fMN8jcHUpxReD78e1eipWOBh7Ler07eP+JYqE+otJR
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
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO0P265MB7176:EE_
X-MS-Office365-Filtering-Correlation-Id: accfc1ff-0aa5-4e56-9805-08dedb687d46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|366016|23010399003|7416014|1800799024|921020|18002099003|22082099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	i87hpf+8vjoUBTc/+B75ewdm19XYTPsXO3Agrsaap+O64n+rLbmu4LoPOcfWgfpx60eGZXCYOhQsrne97USuhmkVWvea9+dZYgkF0l4F9nufEXaFOYwSLdchI6uZuOLYIgUeaDsZHYhivEwGYBtCOeQcKkJ6U0baLmlQ/sv/w37YODC9upMRKfmBBrSW0EtYwyZGgoZWzmlBugyjFkxVCoKR4C0tRCuQywtHIfvnvqajCicBUEHDEZWBDb5v56AGwznRrCgb7Po5h1mSBcBCKgnoHfGEBN7GG7XvR+H8Es/molAlPJbQN7PrlsYnpzxP2e2EtCLUkASnM3XcoxfJiqIaNBxOWHvolhXUz9fGfn8m0znC1L1G0YF/5gg9F2Qu6/h9VdkXwSzYpmHv86UqtpAtnuZAF0wgTNDeVcFmy881JlkCIf59XZo9QXSZ4X7m4tPrbi2XeAPc3kBRFMJvwKw6+vaS/bRNz/xzPH0Ip5FeTVWRNch1U0H/LUYedXagv5ItVI8VU3KHk+1WLfsTXKIoVbFzWzf/7xT/wiv/l/aebF9XINvDHx49sL9v9e8U5iSnEsv0Ue7ODtf1M9aG7dU4vpPr/XKwQFwOtMI0rELmbuZchQdH72/11ajkPP4JwuzaO8u7O5QCojKPJlqPiNcA6aL7NIRXJfGDioeN6lv6UvJverDLPjEYJrZ9HkYksstLYxHIhNMufB0ES9Jnzg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(23010399003)(7416014)(1800799024)(921020)(18002099003)(22082099003)(56012099006)(5023799004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0E1bnJFdndVdGwxbVk2OXVVMnRONWJjWFp6OFVvYW9PNDJ5VFRSOE9jS3lu?=
 =?utf-8?B?WmNacGszSXNGOENCWXdtOVYrQWhpeW1SaUtNV1ZBTlBDZHlvMEhscWdtVnRi?=
 =?utf-8?B?V0phcnBlcUZqcjRrS0l0RE56VkYrYnN4TFgzSHd6eVVoR3V0OWMvZDAxb25W?=
 =?utf-8?B?THVQbzlyb2xGL2I3enh4ekNZTVg0OVg2S3g5dWQvak5lS1k3T2x5NTM1WlM4?=
 =?utf-8?B?YzlNdVVtekRsdHdJaDVySlNmVHB1S2VyZFVoMjA1YktabFMrdk9jSTg3bTBr?=
 =?utf-8?B?QmtiRy9ZU3ltUzdkUDNUMmd1MnB6b0tIemFJRlBHOWR2akNYRnhJYVQ4OU5Q?=
 =?utf-8?B?NDczMlFWaWdleERteGpwNVBqbW5qbFJSdlhFM3B3NWsvRjM4TTBKMjExbFZw?=
 =?utf-8?B?cXNxMmtXZlEvTytYM2loYlZtOVpPYnpVU1hZWUhHdkFzN01vOWFvNlFoN1lI?=
 =?utf-8?B?ekNoYlNLbXVGODdEVjA4S2NORXROendQVGJiRnpMVXAraGxNbWxYSnZwOGZm?=
 =?utf-8?B?VXE0T0tkZTZuQmM1eVo1QmZMa2xnS3BtbVc3RlVIQUJFTjUwTlgzSDVuVnhK?=
 =?utf-8?B?eWFJZEQ0WnpaZnYzMWR6VG93SkY2U29MRmVzeHdHRm5YLzVGK0ZlQnBBTFRt?=
 =?utf-8?B?Tm1Da0RpZDFKZStRazluanZ5OHA0OEZ3MzY3R2doOWNGYW5rT2hHSTJTQm80?=
 =?utf-8?B?K2IxVjRyNmNjcXo0RnM1OFZXSnhaT2FZUUpYRWN2Vzg3bTJ0V2dIWG5KYkpX?=
 =?utf-8?B?S2lyZUJhZmtySHN5Z3ZZMTVJWTNZODJVQTQvU1U5b0ZHZmVkTWZHVlJyT3NM?=
 =?utf-8?B?SWJMYTJYY0Y0UkFEUHVVanEwZXNwMDFYb0tRdmFvWHo5UGkzZVFNb2Q2N3Q4?=
 =?utf-8?B?V21XcHpaN3ViQTJvcGdzYmYvN2xWS1FxdlNuOVY4MVNsRkludlp2dEhXaVhz?=
 =?utf-8?B?WGFsU1pOeWtGMmVnSVlJUlZXdXhzSnRmZTFyLzNIVVlLVzVCZ09lckYvSkMw?=
 =?utf-8?B?c05lRWZ5dllhWDJTbDZMNnRlVk8rc1pLVXdueWFHWXpSTVVwRGFvSnMzazdm?=
 =?utf-8?B?L1dYRXhzQ1JtVEh0enNoNXJUblJvNmFhMSt6WmZQakdPL1lSbEpoMVdHQ1A0?=
 =?utf-8?B?c1lBQW94cFJndGlJazd4VTIweEFQZ0xuWUJQM1FOR0dVdUl2TFppbDRPNjl4?=
 =?utf-8?B?Zmc3dE4rbTM4akx3ZzNlQlZQU1B2WVlwUkVMNDV6QlluQ24xOC95QVRwRklw?=
 =?utf-8?B?KzM0ZFovOHJ0UnFJSnRuR1M2RzRHT0J2SDVvMFZUNU5IcnI3bGs5QU1rMnJs?=
 =?utf-8?B?VWJ1cVVvcGQ0L1d1NWVqMzlaeTdJV1dSd1pvcWFFNHF4Z0ZkK2FwTnJ0RURq?=
 =?utf-8?B?dmlvRUtnQXF1MVROTWN3emh6ZU1pZ3JTQm1VL01MYmx0eFo0K0RHaEI1blNC?=
 =?utf-8?B?Mi9nQWE0c2h4N0czOEZGUnZGZmJjMitPeDlsVWNhek54LzV2V0ptL1Ewb1Z1?=
 =?utf-8?B?ZnhIWFFtV3VmSkVKaUw4NHZ3eTlFWTJsOEJmaFVnK0NJTk9PcE4xZWRUSFFE?=
 =?utf-8?B?U085aEkyRkNscTBhcVZEaGJhL3N2aGsyY0h2UGhUakZWVld6clVlY1RFVWF2?=
 =?utf-8?B?alJUaThFY2ZsUlZhL1RrT21BSERsTVFtMmpXVWdLd3l5bjEyMnVJRHdsMW5E?=
 =?utf-8?B?M0phY0xqNVdnQklHWnlOa2MyN1M3TDREY01WUXk3bHFVbE1jK1FUUXVkWk1Z?=
 =?utf-8?B?NkloZThsb0hld0JqQnRDY1AwRG9DZ0IwSmRCQ1RSVUQyR1dNa0w2VktGZGk5?=
 =?utf-8?B?dndaSHBBWmdUWTFjZ3hBclJXR2xRZ3hNSk01VHFpUFdaT0d3M2VtRXlTZ01G?=
 =?utf-8?B?SzBCQ3FqQUVSb1hTd2hPQWpNWGVnUVIzRCtoRkFwUFZEYVpGekFpQzA2ZUJq?=
 =?utf-8?B?WWNNVmlaTnU5eDcwa01OZ3AweFhqRXNYZ2k4UnhCai94UlFiUkc0SXBlTE5w?=
 =?utf-8?B?RHB2QUZ1Ly9rUFpSaGpxUGJrdFRRY1cxdVNZNis1Ny9aekRnbk1MRUJKY2hL?=
 =?utf-8?B?VU12UGNxcFcvWW9RWSsyUDUzc0dZY3lGWUlTcmVoUWRiN040b3VmUlk5UVUy?=
 =?utf-8?B?L2RyR3Z6dDlvR1duUWoyb0E1cjNjeWNLWDFKN3EvZVM5eHgwNHdueGR2Q1Zj?=
 =?utf-8?B?b3hlQ2Z3RU1lUDFDY3dRRSs0aUFYTFdBbkgrejVoVzBZWjhzZWNYREdBcVZ3?=
 =?utf-8?B?Z2hNYzh6d2toUHg3YS8rOWszZS92ZDRMTFZXNmI2QjVnTHU3VlBrQ0FxVGU5?=
 =?utf-8?B?RThDc2VkZDc0dXRITnJBZ3kwN001YkRFUkZSWUtzTFFCV3ZPYnhQZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: accfc1ff-0aa5-4e56-9805-08dedb687d46
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:35.8836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6lDmt5l2x8QhPYCVQsB/Y9ZY3ytbVebvdDUmOefYj4p2Jydi6XlDm7TpFO/48dneqyAgrduh0bMpqmPVRdHAQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB7176

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. This stored ID is unused so remove it.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 0da85d36647d..bfe3268dfdc1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -130,7 +130,6 @@ struct mlxsw_pci {
 		} comp;
 	} cmd;
 	struct mlxsw_bus_info bus_info;
-	const struct pci_device_id *id;
 	enum mlxsw_pci_cqe_v max_cqe_ver; /* Maximal supported CQE version */
 	u8 num_cqs; /* Number of CQs */
 	u8 num_sdqs; /* Number of SDQs */
@@ -1768,7 +1767,6 @@ static void mlxsw_pci_mbox_free(struct mlxsw_pci *mlxsw_pci,
 }
 
 static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
-				    const struct pci_device_id *id,
 				    u32 *p_sys_status)
 {
 	unsigned long end;
@@ -1839,7 +1837,7 @@ static int mlxsw_pci_reset_sw(struct mlxsw_pci *mlxsw_pci)
 }
 
 static int
-mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
+mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci)
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	bool pci_reset_sbr_supported = false;
@@ -1848,7 +1846,7 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 	u32 sys_status;
 	int err;
 
-	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, id, &sys_status);
+	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, &sys_status);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to reach system ready status before reset. Status is 0x%x\n",
 			sys_status);
@@ -1880,7 +1878,7 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 	if (err)
 		return err;
 
-	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, id, &sys_status);
+	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, &sys_status);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to reach system ready status after reset. Status is 0x%x\n",
 			sys_status);
@@ -1932,7 +1930,7 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	if (!mbox)
 		return -ENOMEM;
 
-	err = mlxsw_pci_reset(mlxsw_pci, mlxsw_pci->id);
+	err = mlxsw_pci_reset(mlxsw_pci);
 	if (err)
 		goto err_reset;
 
@@ -2464,7 +2462,6 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mlxsw_pci->bus_info.device_name = pci_name(mlxsw_pci->pdev);
 	mlxsw_pci->bus_info.dev = &pdev->dev;
 	mlxsw_pci->bus_info.read_clock_capable = true;
-	mlxsw_pci->id = id;
 
 	err = mlxsw_core_bus_device_register(&mlxsw_pci->bus_info,
 					     &mlxsw_pci_bus, mlxsw_pci, false,

-- 
2.54.0

