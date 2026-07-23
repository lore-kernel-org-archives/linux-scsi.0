Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022122.outbound.protection.outlook.com [52.101.96.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DD0263C8C;
	Thu, 23 Jul 2026 22:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844088; cv=fail; b=XOWyKMK8CiuGTfeUsr3jYChKQVXTheYakIbWQ2aoUewOrLkpkHq9/sYpWnwnn17t56CZ+CcoyRDIso6GXz4z7aXS6xtBQAwQ2Q7vOJvaJhTcazE79DEAjx6O4Oj0db6l1McyRJSBx3Ptfk0y8ezHttrTM0PYW6iaDBy578jeYII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844088; c=relaxed/simple;
	bh=T0hf99+IJoZUBSGGKR43Wt5BsA4i8gZgK+neuWxAqgc=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=VksrRPF6o7ybR8VVAHnrCP0EhPgaQedqyiPQomTVuI/N+pg5e55poaSuGPZ/J6I06akxuqJixSnaMif/wPfW6V2TdWGiP9pscoO8nQ6xNqXBpHL/uCWoU97/E3eeLPOr82YlKecMlwhA7VgRQdOJcFqlS7uVvTl8O5Knm+tQgWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=xWI8eTS7; arc=fail smtp.client-ip=52.101.96.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="xWI8eTS7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b1KIAvYWi32TfkOYyYcPgSzQu4fyEX5PR+skljUkE0a/1b8KSyY7eUcZhbhu729M7hhRVW85TM3KENijQ2kjncM4zdomBGB0UnmdDOWVvVUBgjMLf7rPqGsNvL32m0LcTzHYs8qCmQwLR41tL9yGzc2tmIsHH7bJUGUEU/Xh1FuAqT5xt5LtUSKhztSkURdmzXR0cafsijDOVA0rjH/nwtVJgOVMFIye5t6mGKKpGxtxAUOemCAjs6EMZf6r9oJdm1ZI1CoWbT8lED1pSvWvF38d28ecCWpCxkricBG01yJ98NPWrIHvkwe4B90y9rrw+IgNcN2Fy7OhCGzkfkDkgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7MeqlMmRYlsJ1CCEZ03jZ9ZfZDfNFx91OD9GBvw0yc=;
 b=IiQtfJYMA611tcT/B5HE7ukRascxThec6aBcTYeCwgAH+MhjSLkfNrcHIw/GsEd7Uvj0d9VskeaD8ehcLx/Ud0MorbsoUTTqn96jq04Xd9DTQv9HVN+2F8YPb562iuG8GkApzIhcYerNfG0XKM0bIgDCHC6dfEU8VROiTNaR6wYFwumRa3XI4RF3trBs15iiAs2D4673vdCCY9aVX5s5ZsLhoqyPbE0vwb/ZO3iEY8tdlJQZSWO25oFvePcLe5AWfz0AYiC0A0D9rakH7K200k0sS8yxvlbjjab+xFUUSMIrxiiCTk9lFVlLYusM5eCAIdxcxBgWSiqV0kxE466P8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7MeqlMmRYlsJ1CCEZ03jZ9ZfZDfNFx91OD9GBvw0yc=;
 b=xWI8eTS7Lno4vZov+ryYl1KArmYLCgcO4DQpyTOBW1wW+wsRLZBincmwEf2damS2QAFBjevDPAs2/vumZKZvEIhrytjZkobC10ahE5YjZkzg8oloZb/CKyvxQsB9SymOBPHWISTOiDk4PZm32FoKCacUUe+IsA51By9OQJ6zMf0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 22:01:07 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:01:07 +0000
From: Gary Guo <gary@garyguo.net>
Subject: [PATCH v4 0/9] PCI: Fix UAF and TOCTOU related to dynamic ID
Date: Thu, 23 Jul 2026 23:00:39 +0100
Message-Id: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAePYmoC/23NTQ6CMBAF4KuQrq0ZWn6KK+9hDCnDAHUBpAUiI
 dzdggslunyT971ZmCNryLFLsDBLk3Gma32ITgHDRrc1cVP6zASIBBKR8B5Nbsq8Mk+uJGlCgDR
 JI+ZBb8mf97Hb/Z3dWDwIh21hazTGDZ2d929TuPX+Dk8hB65ljApkFRZZfK21neuxO7c0sG16E
 l9YwgELjwslI50pBF2JXyw/OIXjZ+mxKCNVIYhYIx7xuq4vilxvSDIBAAA=
X-Change-ID: 20260626-pci_id_fix-83eaec007674
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
 Gary Guo <gary@garyguo.net>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=4215;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=T0hf99+IJoZUBSGGKR43Wt5BsA4i8gZgK+neuWxAqgc=;
 b=H3IjCn8lBKZzy7uL7oMUrc/+i+pICcqAf6fYkAR6A6gNy1kSEAoFqeq2lIqJwD7toBXPHsH3r
 30CuGlUrB40AtBUc4GJ9dZKqkdDj234kSl4JgoEPSWoppbqQJQ+p38K
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
X-MS-Office365-Filtering-Correlation-Id: c59147b8-d19f-4778-23ed-08dee905e5af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|6133799003|18002099003|3023799007|56012099006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	6g7hjK9j3jERtG9Jxl++842F7yitv6rEtAHvVRUhgim921aLCKVuYDMVqohqBAarRC91cyIy1trcOd6pxiKYYWXHqXADDvLc79ot6sPWwuIH79Gd+VA30dRqXmvIg/z8/Rlfwvmr2WiBTrGIbTagI5JJlSJXN13cv+eVQkhUGnCr8SJ1BFL3+5SV6M6oCqpDZAoPnMBGZnUIx2eS2TEVlw2S6mxeqV818gDr68wcQdXe2T0HMJJjuS+21KOG68bW4CLk7Ftm7Eex7oVJch6npgomnox9lmYdLTnzeCSCfQLx7+oYbnnBng/UclVPKZTuBglGMbpePmel6TWMiw00GmVdvu0EgSXu1NUxLO+RUQcY1aQmcRRO962P9kN2R4JuQ38p92/YH73cPN6nIeXdgR+4tTsMUJCKxE0J94RNzSeGrwYlUBZUOCzoWaBRT/q4awbLIA2KWTBojBs/KL43AOO/YQe7C5im6jMeWqp8BLjw0+4+d01cyx7R4iWSG5NbUtkvqlrXd1LouX4Tm8zepo4d8ibSrQosB6Asf10Fq3yVQF+BmhOTrOh4kOc01Zyqr4Hzsq/wiqPpx01EiGkJj3VJh3OALOeGnIfWO3g0qNk3M8CjQI5CTEoUMr1qUaszoAUKq3KRrkZtd9/jnCTV6avDrB1T8TyxcD+yb5izlFs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(6133799003)(18002099003)(3023799007)(56012099006)(5023799004)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFlINmpWdVl1Ynl0NUUwUDNpdEpiaG5xRGNFcDY1UXRTbWJnL25NdGJhUm5k?=
 =?utf-8?B?K3FDaUxTMzZiVUpuUk1iZVZzaEZvN2pPU0t4T0x4eFJVWGtZK3B3TkRlRkFv?=
 =?utf-8?B?RDJzNVJHRVVMaTV5YW9vQ1hCcGFKQXpHNE9GK1cxdjhoUlVTWWRITjlINC9M?=
 =?utf-8?B?ZndRSi9mM3ZJQWZjaW1jWDJWNzZ4cHE1QXQwZiszUFRXUkRZTDNueFlaUGFT?=
 =?utf-8?B?MjdsOURzR3NEOWFrMFo4a3JLU2gwdXVJek91T0pJaC9KVWxRdFBMd01SOG0r?=
 =?utf-8?B?UnppS2p1OWloYUVES1J3K2ErRTJvK0NCSzZld0ZiUkJ0QTNQMWo5bFdsUjZ2?=
 =?utf-8?B?MHdweVY1eXJuSHAxZUUyRzZuSHBwSUVLR28yM2Z1QmhFTDBrbG5tU0xVRUE4?=
 =?utf-8?B?Sit6a1hRbUg4czlFL3pENEtFVlBXSWxqK08zY3BkSHcwRjVjZlpEeHhkZkZK?=
 =?utf-8?B?Wkx1QVQ1Q2t5anptZ2RYSGIrWHd0QW1ZWFUyam9HQ3QvVU9hODhaVjd0emRl?=
 =?utf-8?B?bUU1QWQ1SnorUFBUeTNmWFpweFF3dXhic0VnRmU2MDJ5NnFtYURxLzdvYWhs?=
 =?utf-8?B?WThvQXo5eEFMSGJpWWxINFR1RXREUjhaR3UvUy9HTUo0Ti84c2IrWHRodzEy?=
 =?utf-8?B?cktCNGVBL2RrcWlQYXFZVnZIU3VJVVUrN1E2QlNoblhCWUNlOTVvSU5Sajlv?=
 =?utf-8?B?akRXTS9udUYrdlp4U28xNE0rZzlNZ3JBbG5mNmg5T0QyOENLU3RTTTBzamxT?=
 =?utf-8?B?N3kyZW5kVlphOURjWUVKK2xOUDBLYWs0cC9LU21NanZ5b1ozZlFkdk1Wb000?=
 =?utf-8?B?RzRmNnV6RU1IWXZodityT0RrbTZPaUZyZDh6UVdMQjdCVEZacElTSmpkR0pC?=
 =?utf-8?B?K1pKM1hRVkErQi8wSm1DaDQ1a1BaWDJGbDJJRjk3L3VsaGk5aW80VWdVZjRC?=
 =?utf-8?B?RmtQUzI2Zy9rd1VJNkIxeEVIaEY2TUR4WVljVkgyUGRFTXFoWFdDOS90aElL?=
 =?utf-8?B?R2h4UGc5bnNXeG9UNjlKOTFTL2RXYnU3eDRBNFA1UnpaakJUOVRka3dyV3Ja?=
 =?utf-8?B?UnhHM0xyVkdMbUF5VW9YMEdES0VEUm1wMWk5N3pzeHRQNTg2L1VaQlA3UW5w?=
 =?utf-8?B?c3FhdGsrRVZTZWhOVjdBR2xmZHoyNUc0YkZaNXcxaTBrTzhGZjRlNDhjSFow?=
 =?utf-8?B?NXFFVnFIRmFSRW5BOHFBZWNpZlZOdG0yeUpDbllrcGI2ZzlMbjQxR0tSUHY1?=
 =?utf-8?B?RFJXVi9laGtsMlBUWitwYlp6Qk40YTIyWndMUWQrdnd0NUdOZ3MvV2RSZlR1?=
 =?utf-8?B?SHNRQkE2T3doUUFKREU3ZDlEME50TlZxNzRmYVMyampGZVlBRCttTHFqNWt6?=
 =?utf-8?B?NFp3WU5LNTlKQWdpVk9QMjl3aGtzUDBlaFRVU20xdGFGVUhpYUo2ZFpsQXRC?=
 =?utf-8?B?Mno3Vll4MFN4anpOd0V5Y2llaFc4NnhkNS9nZVpmSUViaVV4VFdYMk1xS2xO?=
 =?utf-8?B?bCs0MGpFVnBqT0JqT3d1T1ZmVkh3VVBKRW5ycnZuUURyWEZBR3gwM0ljN0Jv?=
 =?utf-8?B?aW5uMjlCeStHbCtVdjRDWDlBZjRIT1N4bHpENk9yZ2NWdm5KME9TRjFaZVlQ?=
 =?utf-8?B?ZzA0Tllidlc4c3Q4M1prOFNtc0puUDhUUHoxdUtaN044ZDUwNnI4NUY1b0tV?=
 =?utf-8?B?eUM3eEw0OHJEalQ5K3p5Yk52ME40VFNVOFMvLzNyWnJCYXN2NExaODdZMk93?=
 =?utf-8?B?Zkd2bFNxSDNlL0xzZHFidFdUcjNSOFRJbDUwNWNGdk55amR0VlJJUDZUNUVm?=
 =?utf-8?B?U0tjYmtvd2NoWngwVWoreVUrTWhGaGdTcFZMdjNrdEp4RkJKREN0R0xBcGxp?=
 =?utf-8?B?SjVqLzcxK3ppbk9TMjZKTFh2TFMwMnpZN3NJaGovcjNlcWdKaXEwZ3Z3b0U3?=
 =?utf-8?B?Mmk2TTdCUElpeGIrZ1ZjR3dNRGpNV3lmZFN4bHl3bVNGWnFLNkFuRHFjVE45?=
 =?utf-8?B?WWVoR3RGTmtqNzQyZmQ4UWVWeGEzZWlTRURlM3RnRVM1WHBlVTU4bTkwL0pu?=
 =?utf-8?B?VlRKY1ExMFhGSExkWkcvMEZueXAzVmFLcytWRWRsSXR5N0hVZldYM1lwaGE1?=
 =?utf-8?B?RkxiVjFPYWlUYmlNUTNjTU4vcFY2M3lxMCtzckZuTUpvL1lXWjRZaStOSUEz?=
 =?utf-8?B?MC9CZ0srQzBBZTlreWRHVDJFL2U4andSYklsSkNPT3N3TGZRVldBOG1Md2Rz?=
 =?utf-8?B?cnR6d29meTJaM3Y2OERZalZDNTQvbG9IenZMOXk0eUEzTG9BU0dxM1V2Nzlt?=
 =?utf-8?B?SFFDUVJISjBoNXhBemZkV1pTcGtyKzVndU9qVjlubkhkNTJFcVhZQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: c59147b8-d19f-4778-23ed-08dee905e5af
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:07.1856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DcLqWDR1rt7f7sLQoStXg/RcnMQhLaUf3iCPOVl9SbtPNrm+sv75GfICZtaPByjjOKFOKcQpnKF9nnlQel8EcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

While working on improving the Rust abstractions [1], Sashiko reported that
an existing UAF issue related to dynamic ID, which I find to be genuine.
When taking a look at the code I also find a TOCTOU issue where the
existence check of dynamic ID happens in a separate critical section as the
actual insertion. This series fix both issues.

There are two exported functions pci_match_id() and pci_add_dynid() which I
have to tweak to implement this cleanly; I created separate "do_xxx"
functions to keep the existing APIs because they all have multiple users.

There're a few existing users which stores their pci_device_id argument in
probe callback. This is a bad pattern because nothing except driver_data
inside pci_device_id is what they want; actual ID information can be
retrieved from pci_dev instead.

There are two users that performs pointer arithmetic on the pci_device_id;
these are also problematic with dynamic ID and driver_override, so fix them
as well.

I've used the following coccinelle script to flag all cases where the
pci_device_id is used other than reading its fields.

@usage@
identifier fn, id;
position p;
@@
  fn(..., struct pci_device_id *id, ...)
  {
    ...
    id@p
    ...
  }

// Due to cocci isomorphism this needs to be explicit
@bad@
identifier fn, id;
type T;
position usage.p;
@@
  fn(..., struct pci_device_id *id, ...)
  {
    ...
    (T*)id@p
    ...
  }

// Good use cases
@good@
identifier fn, id, fld;
expression E;
position usage.p;
@@
  fn(..., struct pci_device_id *id, ...)
  {
    ...
(
    id@p->fld
|
    E(..., id@p, ...)
|
// Redundant checks, but ignore
    !id@p
|
// Redundant checks, but ignore
    id ? ... : ...
)
    ...
  }

@script:python depends on usage && (bad || !good)@
p << usage.p;
@@
coccilib.report.print_report(p[0], "suspicious use of pci_device_id")

Link: https://lore.kernel.org/all/20260618-id_info-v1-0-96af1e559ef9@garyguo.net/ [1]
Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/ [2]

---
Changes in v4:
- Code and commit message style fixes (Bjorn)
- Link to v3: https://patch.msgid.link/20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net

Changes in v3:
- Fix users which uses pci_device_id for pointer arithmetic. (Sashiko)
- Convert to scoped_guard. (Danilo)
- For static IDs, still give out static pointers and avoid making a copy.
- Link to v2: https://patch.msgid.link/20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net

Changes in v2:
- Fix users which store pci_device_id.
- Clarify in probe documentation about the lifetime of pci_device_id
  parameter.
- Dynamic ID conflict check now ignores override_only. (Sashiko)
- Link to v1: https://patch.msgid.link/20260626-pci_id_fix-v1-0-a35c803f1b95@garyguo.net

---
Gary Guo (9):
      ata: ata_generic: don't store pci_device_id
      scsi: nsp32: don't store pci_device_id
      ipack: tpci200: don't store pci_device_id
      mlxsw: pci: don't store pci_device_id
      agp/via: Don't rely on address of pci_device_id
      agp/amd-k7: Don't rely on address of pci_device_id
      PCI: Make pci_match_one_device() match on ID instead of device
      PCI: Fix dyn_id add TOCTOU
      PCI: Fix UAF when probe runs concurrent to dyn ID removal

 drivers/ata/ata_generic.c                 |   6 +-
 drivers/char/agp/amd-k7-agp.c             |  26 +--
 drivers/char/agp/via-agp.c                | 308 +++++++-----------------------
 drivers/ipack/carriers/tpci200.c          |   1 -
 drivers/ipack/carriers/tpci200.h          |   1 -
 drivers/net/ethernet/mellanox/mlxsw/pci.c |  11 +-
 drivers/pci/pci-driver.c                  | 194 ++++++++++---------
 drivers/pci/pci.h                         |  43 +++--
 drivers/pci/search.c                      |   8 +-
 drivers/scsi/nsp32.c                      |   8 +-
 drivers/scsi/nsp32.h                      |   8 +-
 include/linux/pci.h                       |   1 +
 12 files changed, 237 insertions(+), 378 deletions(-)
---
base-commit: b4515cf4156356e8f4fe6e0fdc17f59adab9772f
change-id: 20260626-pci_id_fix-83eaec007674

Best regards,
--  
Gary Guo <gary@garyguo.net>

