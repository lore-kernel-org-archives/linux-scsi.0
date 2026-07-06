Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020136.outbound.protection.outlook.com [52.101.196.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B1B39656E;
	Mon,  6 Jul 2026 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347130; cv=fail; b=W7ZoF2JSGqEg7anLnPEZFhxxQvhgfPLwYDfiR5oJdKFvYoC2csrLVIkPiJCfv+ZlEecfPpk3QBMc4yIaz2v1VPZOXcTC1qWj7JIysjfCEBx8Grpox0HgTyc4s/w4cQZyVy0ZybW7e1S0hFfdMkzPhychfgSNFav5qWllkVkq0Pk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347130; c=relaxed/simple;
	bh=UPT115siC/mowzkXpKSrbBzoZ/yNhYdNqJQpSheUE8Q=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=RDGQDbtcLJ5rCaJmTGJiMBqGZJtmyAxqdkF89/dMgWjm0LNkXc9DAVcyUKK1xrC1NCfTMTAKF3V1pXzGXVXukmFRV3DRqVk8D3brTgTGaXJfnNwE2In6vgveWN16eoVkeY8JEg0lz0cLMeYVL5GjK60m++ZsrE+29wxUBqylb38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=JUYdC+VE; arc=fail smtp.client-ip=52.101.196.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="JUYdC+VE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HuqTET298WmehBa7Yp5bths13deE+ve5+0S80gw9IL4/a3ctd5Z/r3cIB2kaEDlsD1z/OgWzjZlMIiMj+iMQREGAeKWJaPng+tAaWrr+Dn7jqh2F+VLPPf9nXINlNiXtsXzTNoqnjAwKjSK9Bjn78F/Sm/63f3eyzTm2qBq3vS0y70Arn2c74fmzbrxZubfmby7zO6mRA4nzl2ZtAe0FrXDR1mqxx3GNiMvnWbCwgr3mxzScJRJXRpAJ4ftw8mpMNamkX8fN3Hk+AbMP9saHjgc75V0cTTkss5AKP/BbteAHYZtvMtLulsy1RO9AUr0UAQ9TGkz3MtOYgVeGDKQ7qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0N4TKM0N+HYmetRy0OFU8IUf7UgS8VESaKid11Druw=;
 b=GG39LDovPW75utxwbeLKOB6LfUIdIJPYJi8hsw9nkDJtytUsRVP4VpaqG/0+3JfUYnNBkTwVwNFftwYPvNwgq8ayXfo0R9dXQBhcf8VwWJ+ifJ6IC6EvdG+v+pxg5UgUNbj2txFhU+FBw+1tOk9gpP24tRbOtD0KoqhXt6gt2t1KRf/CYn6NdD7NV91pebL931fxA9Uj7Ul6R89aOCoVcN1dmZ8eYxHa3hNaH3aCB8XqG3DpOW6nZDF5SmQ0yrddUL8ZPTHumHDIsTWVQIuQeCXfnDPQRqdlzmk/4YHrpBRFB0AdfjaMMkloYwdP3EIsx71vANr9brr24zYCkLApUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0N4TKM0N+HYmetRy0OFU8IUf7UgS8VESaKid11Druw=;
 b=JUYdC+VEbKmpwcmXewCr9SZTj4NtRpxdMgZDRpHlhqMdz2j9o8+yOefjuWfE0vMHbEYvC2zZoJGr5gsnPwtWbK6rEtL/oOa+kKtj3Skw1C1fnVLCBk1qeGlFUOOL0U56TgxOjEOqzkZM8Ru+RN3BxJT9kM+G0l2WtBQ3M5zGb3E=
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
Date: Mon, 06 Jul 2026 15:11:20 +0100
Subject: [PATCH v3 8/9] pci: fix dyn_id add TOCTOU
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-8-2d48fc025acc@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=7607;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=UPT115siC/mowzkXpKSrbBzoZ/yNhYdNqJQpSheUE8Q=;
 b=1k+CCJTldQNKR6BGJNiCLVZcjEYe5LpjmFteaR+0vkTJMpFetxxjuwX31uuk2YWQIWcZ/+v0S
 QVySID9lgH1BejSovfK0L4eSXl6sfzNICbWvL9gzDyVnC8gAemfYr34
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
X-MS-Office365-Filtering-Correlation-Id: 590ae5b3-93c9-4a45-670f-08dedb687e7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|23010399003|376014|1800799024|366016|56012099006|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	bVbd/3Lvc1Z/gBmWKcOGScJMYc1k7uf0+pHIT4cj5haStFE+M4qLUzKBwLpDyoP2KPzgdGdrKuFZxR3VGdRcgTP2h0wZvqAYCElYI2R8oipKSfzo3jIsBF8QxebxZjlSU1da8yG7blM8uxyvl1BkcKAqBDoFhzsnNxtOQ6qq2Qn3gd61qf6QBVJrevV1hyQvnGM7NSg8ibgyPq1jf4eLJrA/UhdSOBFZkryJ1AFwdOYWp1P1BHRktpXKT5AfS2wWxx7V6on8i/Z38+4j1WWv9VKE/DSEqzFCmzlID2EJohFb+COMGvbGB/k4S3nLdxmpZWtA/DgxuVbTwN4wfLZkoWaUTpI2JWBZ/wztTsF/YefUnsHb7qh8Z4UTXEahNC09ORWUKY/GIXzKjqm2PepoznW9ou6jSIhCSiTO/PJxwZJdRcV+pf9KGYwwDSZeqrtBuMoEX+75vd3/Zd82lBJ5sVl76AmVqo0ADWHapimYQk0y6AnuNtqy1IUa/CEPJCrkZS/o44JxnaChOcViJMR9Mmxpro9/KPNV10b/ZJwY6BkpUhZ8BM5M5zch85BLYFlVm8jXs/g6T3Jfs8IeEyczOvkB9I0zRbjPwkJ6i/4khseUC35cUp1ez8FuO/XVdupz5gf1pZywkQfeI6jRZ7Um9habSkHAP3LERDuJfs+45htVkcUHkFQRmgXc5ZK8Huf7OysVus+s7QeCptvX9VnlNQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(23010399003)(376014)(1800799024)(366016)(56012099006)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFZ2VkcxN3p0T2ZzekNzaTdqVjExMWtvdjI1UE5GcTdDdHN6Z2lpcitLYjVD?=
 =?utf-8?B?eHV6OERIVEVBalowV1ZUMnBZUWd1aVdMeWtUcVJZd3dTSkNINnEvTWNQQk5t?=
 =?utf-8?B?b2xEb3JSQUtBVmttcE43NmZZV1dIcGVOS2psWExXdmNPUjk0V2FlaUJ3VzIr?=
 =?utf-8?B?WjZTZ0NCQXZKTVRFdThRUVlxaDBncS9CRVYwL0pWUmhGNnJQM0NjaFR4MllP?=
 =?utf-8?B?M2FrRi9uOTlDM29KR2FvUlVrT01jTFNKL1FNSjJvUHhPbndLdVpCSno3dEhm?=
 =?utf-8?B?bGJiVHNsZmhzdm9kc0JHV0VhUG5BbjJMeVdtMWswL1Y1UVhIaG5aem1ZMHV2?=
 =?utf-8?B?RHhMOG9qY3NOVjJ3b0hoQXp3OUlNS1BCRlZnMWttZHFoUjVhK2hxSzFrL2ly?=
 =?utf-8?B?K3hUTlpiK2dpT0lENnBEMlhjRlcxUlZLbHowY0hXdUJQalEzem05OU1OSFFB?=
 =?utf-8?B?WTU2MWZnbzVycUwrd1JFRXdDNUdBWXpRNU5ubkRBOWdrS1FrcVFRV3luUlhS?=
 =?utf-8?B?ZmFHZG9wQ2dkSmVUUnl0K2RpWXdQeC9pZkVTaDJQTmVXUTM5aStqL0NaelRG?=
 =?utf-8?B?a3hkRHlMT3c2QkluUkxoMlplWDVTUytHOXpaSzRJNlNNZFE5NzEzU1cvcENE?=
 =?utf-8?B?bmVadVBEMHMwWG82NUYvV3haa212c0FaQ2Mvbldwd1d1ZEQzY29SZTU1aTV1?=
 =?utf-8?B?L1JDUnNXZjZ1d2V5akZ4cUVTUXVPUmRCV012OVc3ZTZhSW84ZDY1QWpuR0tO?=
 =?utf-8?B?VnRudkFENnlVYVpQK1hoK1doRCtDQVpqWWZMVkRvRWxzd3kxSG5mMjM1NmJZ?=
 =?utf-8?B?Tm80WlVUMkJ2K2thWWtUNTBXUy9NOXdkYUlxQWRQV0tBOEFOeUtqMUE1Wmcy?=
 =?utf-8?B?MWQzZk16S0RpV3JvblhSS2tXSUdzT1c5bTM5TjIwbkJpdUxmdUl3YTlKNUxx?=
 =?utf-8?B?NEttOVNiU2pjc3ZDUmRRZ2Rld1Q0V2JSaks5aFFxaVZQNDVLVjYvaWxtTXhR?=
 =?utf-8?B?QU0zREs5RFVZeGl0Y1lXK1ZCWG1FcFAxMmZPQnJqa0U5MGYzQ2xVdlVRQk9I?=
 =?utf-8?B?K1pQNzJVcS9lckExNkI1akdJckptZWcvWGo4YS9jSmg3UkVOZjRDV2JJVlAy?=
 =?utf-8?B?T3hRU3o2b1hiTFRyaHVqU2dBZ1MyS2gvZVQrUDF0cEZOTzhxYWQxYkVaQ1ZX?=
 =?utf-8?B?TTVRNTVRVGtSbkZ4RVNNMmdFTWJrT3NBZXptUDBELzZpTkI5TVhDVlRLNXJL?=
 =?utf-8?B?SW5nR3VHQnc3RzhMYXpGZDkyRnpEUXZkMk9VZDdjVWJoNUFLbHV4STAyaDJX?=
 =?utf-8?B?WXMzc21ITW02ZFRPZ00wRGNndklQZGtGUEVhdy9uU2xqdjV1VzVrWUxoT2lJ?=
 =?utf-8?B?WDFYc0ZkK3hxYnRtSVJOSkNySmJkU1NkNWZxL1ZrTGFkd1pGMUpPaHA2UTI5?=
 =?utf-8?B?UXY4cER5L1NTTSs0N0hzZUY2QU5PREpnWlZGTVZUb3hZVWVQRjNHQ2w4ZjJn?=
 =?utf-8?B?bnppRTAwdGYrU2tkZFZQTXhydWxGUzRlTFhjWEFadStPTzVEaWdtWVFWRWhm?=
 =?utf-8?B?TGpWVjlJeklzTVpWVm84bUJRNWgrWXZJRjlRVTRvWDJZNzAwei9yRkxZV1NE?=
 =?utf-8?B?TmU4UjNGaEdqMXJuYUZTa1JTWlpaR3A3bFhSSEUxbi9QcFkyTkwwWlVIVlEr?=
 =?utf-8?B?Sy9ZWmw5WGZpR2NtR2tJRlhNclk5cFh1YkoxWkg1b1JPblB5V0g0bEt2dFdC?=
 =?utf-8?B?RmgxM1VlT3BNNHd1Wmo2RitwaHVkWUNFMFB4MEhNMmJyamkwUzFBUmV2aUJa?=
 =?utf-8?B?WjJIdTdudmtBY1ZnVFZQazZWR0RyTWR2b09wZDV3bUJCWDlnTVQ0eVJsZ2FW?=
 =?utf-8?B?SUFBVlVJaEp0UGpGTm43SVBMSldMd1J3TUo3dUlsYWZsdlE5cU01QTB4cmhC?=
 =?utf-8?B?L0F6emd1TEpxTE8yNWdiYzkrbDBNeWZKdzhkOURDNWVFcEtGTzNtb0RJRzVa?=
 =?utf-8?B?VVQ5Vk1CRVBXWmlFLzJhVU9JaG41bjJrYmc2em9heDY1RXdBWjMzR21oT0I3?=
 =?utf-8?B?ZSt1aUtROGY3Vkx5S2M5dDFXT0x3VzA2SDZUZm1BQS9zMTllYmthOGJXK3dz?=
 =?utf-8?B?b2pvSjkyY3BvSHNDZmFLRjdBNnhvMHg5WnBob1dYQ0hxRDVRWDNHaGZLejR2?=
 =?utf-8?B?UThTZjNyNUpsZ3RGV2loYWJPUlE0djA1ODd5SlZPMUtHMnVaVjlYZldqTTYw?=
 =?utf-8?B?L1c4blEzdjVFZnB1ZDNIRDd3OXludjExLzBmdHF4VFZqTEpkU2w4WGVCa2NT?=
 =?utf-8?B?M2wvVnF5clRGR0c5OWxXRmg5QVF0UGdJQmt0ZE80c1VWRjlzblNzUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 590ae5b3-93c9-4a45-670f-08dedb687e7a
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:37.9006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKVPrKiFxU/mqBJjYMm0xKqbkfx+IJcUKWPncFtBsLgasiGMDUKn2gYVsXKHm1sYGd1rqPdwqkETftJk19XTuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB9444

Currently there is a TOCTOU issue in new_id_store as the dyn ID insertion
in pci_add_dynid and the pci_match_device are in separate critical
sections.

Fix this by moving the existing ID check to inside pci_add_dynid and only
check against the static ID table outside the critical section.

Fixes: 3853f9123c18 ("PCI: Avoid duplicate IDs in driver dynamic IDs list")
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/pci/pci-driver.c | 139 ++++++++++++++++++++++++-----------------------
 1 file changed, 71 insertions(+), 68 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 0507cb801310..2e80ae150ff4 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -29,6 +29,47 @@ struct pci_dynid {
 	struct pci_device_id id;
 };
 
+/**
+ * do_pci_add_dynid - add a new PCI device ID to this driver and re-probe devices
+ * @drv: target pci driver
+ * @id: ID to be added
+ * @check_dup: whether to check if matching ID is already present
+ *
+ * Adds a new dynamic pci device ID to this driver and causes the
+ * driver to probe for all devices again.  @drv must have been
+ * registered prior to calling this function.
+ *
+ * CONTEXT:
+ * Does GFP_KERNEL allocation.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int do_pci_add_dynid(struct pci_driver *drv, const struct pci_device_id *id, bool check_dup)
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
+	struct pci_device_id id = {
+		.vendor = vendor,
+		.device = device,
+		.subvendor = subvendor,
+		.subdevice = subdevice,
+		.class = class,
+		.class_mask = class_mask,
+		.driver_data = driver_data,
+	};
 
-	dynid = kzalloc_obj(*dynid);
-	if (!dynid)
-		return -ENOMEM;
-
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
 
@@ -94,16 +127,19 @@ static void pci_free_dynids(struct pci_driver *drv)
  * do_pci_match_id - See if a PCI ID matches a given pci_id table
  * @ids: array of PCI device ID structures to search in
  * @dev_id: the actual PCI device ID structure to match against.
+ * @include_override_only: also match against device ID entries marked as override only.
  *
  * Returns the matching pci_device_id structure or
  * %NULL if there is no match.
  */
 static const struct pci_device_id *do_pci_match_id(const struct pci_device_id *ids,
-						   const struct pci_device_id *dev_id)
+						   const struct pci_device_id *dev_id,
+						   bool include_override_only)
 {
 	if (ids) {
 		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (pci_match_one_id(ids, dev_id))
+			if ((!ids->override_only || include_override_only) &&
+			    pci_match_one_id(ids, dev_id))
 				return ids;
 			ids++;
 		}
@@ -128,7 +164,7 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 {
 	struct pci_device_id dev_id = pci_id_from_device(dev);
 
-	return do_pci_match_id(ids, &dev_id);
+	return do_pci_match_id(ids, &dev_id, true);
 }
 EXPORT_SYMBOL(pci_match_id);
 
@@ -153,7 +189,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 						    struct pci_dev *dev)
 {
 	struct pci_dynid *dynid;
-	const struct pci_device_id *found_id = NULL, *ids;
+	const struct pci_device_id *found_id = NULL;
 	struct pci_device_id dev_id;
 	int ret;
 
@@ -176,20 +212,9 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
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
@@ -197,11 +222,6 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
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
@@ -215,38 +235,22 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
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
@@ -254,7 +258,7 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 	if (ids) {
 		retval = -EINVAL;
 		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (driver_data == ids->driver_data) {
+			if (id.driver_data == ids->driver_data) {
 				retval = 0;
 				break;
 			}
@@ -264,8 +268,7 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
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

