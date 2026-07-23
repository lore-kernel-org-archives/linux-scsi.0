Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022122.outbound.protection.outlook.com [52.101.96.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307ED40F759;
	Thu, 23 Jul 2026 22:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844128; cv=fail; b=tmQvWBVnqOy492e95AxTEN2G8DlvIZi7vcmhU8Z6lO1SCijBTzHsLDmVKM+XOTMS4c1otSacpWKHZeeHH712CqGNZ9shVb4wx2hPS4nj4nvZQ9sWvfNydUxgpCdS3iOOSyDUZV+kM/DfiL19DRd3OBLLneVJUpwV3vb4mWU7lc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844128; c=relaxed/simple;
	bh=lHva/dma2dhjWQsmx2fGGemN3LY6Pzjje93ttaBGl9s=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=EnVTnXNVFuoP2z+lsIV7TD16qeiYWohgyHsuPIGgjztprlegKK0CQlOynGQMnV/4Vi9VpyzzE1V3jBmAMQhh3j6cko5/KSPO0lKvW4S/zqSGpioPFMBcNAANnT1ptm1+1k5lJSOG6/cyKEWnvc1lM0zI3CVxGQIshVCOtn6aWZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=ZUXco7VC; arc=fail smtp.client-ip=52.101.96.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="ZUXco7VC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ge93VeykG/XhaTosN0XKrunv0anpbiQf0N7L/7DvefbbDNmo7nl/22fMNzE7O8yHvi1W3RdS7WDVsad4kD+ERWey6cA4xVd6a0QI3wVfAWrovDTFBxvQ4yY2kTkk4Zd4HMkJL/3njQxRR8rGIVQUGYV6Kd6kCekrRc6Msi37ikHpgSj+lSkhz+59pOgucMSDnItmHxUo/45tapCwB81fLq4fPLynTqcINL6wsOL9km6wnJeFeODYtaeJP8UcQqqJreJNgKFjjcYMMxXJCrHkvn0hS7BssPK9DOHPSfvQ8Ge9fBEs2stx19sTFYar3dKRZhDWCCYTXOIJwGca2RNgvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Co5kdjmHbYEl4DCl1tDECg3+TXAiKFmIIs3avtbaJ8Q=;
 b=kIKMuFf1DWUpUpGe/bYZCk+xtyflV0oZmyb/zFoZuCZLs36vX/1wcDi/en8r9zMIw8S5/VuN6BPb1GZq7qYdkRkgwbIpX/z+e8XJik93pPU6Di5EC6Eo1yNk52Jg4Ucb1HGmz+CUH7RjsHW8Ly4zMsXKdXsLQGOg+U7+dsx8TJIbKMDKnqd2KC1LSK+m8U93e/6iOSftpC03B4oX8X8GnXsTzKmWMgrJQSC80pjsHv8jmdU9FpZvZNrRJ0aS7oAQUVKHVsDVl1d8MSvlYIDvvYiQNZiiZYm0nBBN1ChYjqBOkb/2V4fClkCyxjZkO5SWbla2Uy5zB7vCK3avJB8GPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Co5kdjmHbYEl4DCl1tDECg3+TXAiKFmIIs3avtbaJ8Q=;
 b=ZUXco7VCX+UDmBtei1BtwJ/9nLxUmXBKgz6Np591SMOEzxt7iHHaaKSaazPm3jT9n4xjEbD9JSdUCJ0t5UH8nypgpLQxO/6CPnl1M3iAfhr4nKyhhG1uPkcbJlKT+xrmosootqAaduDZfLGHSR+NxgT2zZflXxhUAWkXNyq/GDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 22:01:11 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:01:11 +0000
From: Gary Guo <gary@garyguo.net>
Date: Thu, 23 Jul 2026 23:00:48 +0100
Subject: [PATCH v4 9/9] PCI: Fix UAF when probe runs concurrent to dyn ID
 removal
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-9-3580726844e1@garyguo.net>
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
 Sashiko <sashiko-bot@kernel.org>, Gary Guo <gary@garyguo.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=4035;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=lHva/dma2dhjWQsmx2fGGemN3LY6Pzjje93ttaBGl9s=;
 b=PRpoM33KIVcuLWUlxn8nVZJmx89ogQe/kUyc0oKz9B1+e+FStVQw+oLIXU+fW6nX1Ym14kr31
 JqvL8iK2SXIALrn1fyHEzic/O9VRJlsrXDW2sfHe7DORDCEEsZ8XUxA
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
X-MS-Office365-Filtering-Correlation-Id: a7ce7b36-e754-4197-c17e-08dee905e7fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	fhTG4FoRvy0J0DSORGwc9FqJnQ2lVy/1WKsjhRLUpwf+Th8oVZ8R2ZYK2L5z9Zi02VCGF0N9SCL02t+qw6RXPg7jcPym4t15fSogpqNfKSTq9QFNOHnWSPlyh0zbPnS1AhknYsFEAeXaQGgRgFqsbUnTWbevnkS4Qs8CZH2tFFAKK0YFcZ41OCelELzNlBrzF26nmKNOb37W29VakkfRCp2FBIDmuMZGdp0byCeerzrfz8E5Z45MeF1Y3Uls1F/t4RMrih53cwWsaONLPOSqRYOa97LzU/94hz+cCsnwPdtpuvHes/uH4qxDCKW5fPdD0pp+u6l8PHjO9Hxm0d1LQkB91c0H+2GPWeEyxGl1o31vn85XQnyfaHfclvvjI4f7mbSrpDNUPA24ivo2Je+HbuEMHIejMV6dh/FzfoqHy+FL0OOSoKElCbP+DRV+YY1a4Yqa0JF9EYVxNrxh2JBYMKnxvXxvoDy0VIDwGUZaWUU3Aeiso7ozGP5hAc6qz0XhT9nqZLUGrsdV1u/V9+H6ajyKC004GcLDD/orp0KsEXJxqMt+KpkLajdOU3ZYabFQcry4glWkZzH0okLbTVY9MNDSKI7n4OdZQou4scGHG+OT57Ux/XjhVQL1Kh1sAWVgcopD5CGBPsjH5dgX/TIYxBMifxUZ/XpnW2mk/py8TEUCGKiIWJy2JjUYy7Ri3PEfBG90+hboWV+292Ysec//tA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clNXUzQ0Rm9BNzlQb0NFdUY2REZFWVBOOUM2UmdZb0k4UitLL0lpVFlHaWgy?=
 =?utf-8?B?OGRWdkpTa3lZVDl5OVVncHJkQUhVVzNVclhLNDAzV28vSTdLcmx0VE1ydjZ2?=
 =?utf-8?B?L0JCSkVwTHdkb1JNRDVIbi9QNVBUSWhnb0k2QXUxUkt0VW01NjgrVjNRckJZ?=
 =?utf-8?B?TXVKdWNTY3o3SEs3SVJFQmdVZE1BZ1RvSm95Y1Bja0cydWExWkhtM1pnT1lC?=
 =?utf-8?B?eitEMFh3ZHBSc3czekphcFVjRkw0Q1hIL1k5bmx2TEJ2V3IxRFVOaWduNTJk?=
 =?utf-8?B?NWdEWUVsNnZKMHJOdkFmKzgwVURCOHVwd2UxNXdxY2RPKzVJclpSTnIzV3Ax?=
 =?utf-8?B?d0lUSGZNbVBnNkFaZFRxUU1IWUtucEZvRWtqV3NEWXF6dk9aMmJwRzhYZGJj?=
 =?utf-8?B?Zld3TE1mVlhOY1Q0VWhMVTNBTHNLTFlMVkxsWUdPZGZ0VE5GV0dXMmVHRHFq?=
 =?utf-8?B?NFJHdlZTTlA5WjJZbGVmclBaVnBsV1pwblFJdVNvd2xBTUVEaHFqbGVzTThv?=
 =?utf-8?B?OFhxSnJWV25EMm94N3FMZ3ZtQ01FcU9rUWFObFJiQm1BTmYrTUZRdWZvejVZ?=
 =?utf-8?B?WVptUGtZeko1VjA4MytralFrbzZEb2pBeEZmNi9JNkpyVHFsZmdqSUkrUXBi?=
 =?utf-8?B?djRoaVd1cktVOHVwK0Q5Ykt5MElQL2VoMC9SUE1RYlJqYTMxa09yMnpwd3Ex?=
 =?utf-8?B?K2tySHFlMy9EaThnSDRWQnZDQ2pBMDNpZ2xRek5MQzRBUEw2VW5HcWx0aWxa?=
 =?utf-8?B?QjVwWDRRWExHZWNZcGlvTWc1cTg2WjR5YlNObytya3lhb1MyQ0x6UHROSXU5?=
 =?utf-8?B?MUZCRjIyTzFidSt6RnA2U1JRbnBoaGQ3eXZ6VDYzZGFyR09CYldYb2V6UzB2?=
 =?utf-8?B?TVlOYk4yZ2N5YWtKb1JQcFhvdk1QRFA5aFVFeUs1R0FXL3h3MzEydFFXMlZq?=
 =?utf-8?B?TDhubzhBTzQzYVlIVGg0M2RpMFRVTHlQd2NFUXRReW5wQjhWNFRzZWF2ZVd6?=
 =?utf-8?B?b2poSmEvM0RRUEJLZnpwUEo0eDhDY3FRZUcvL2xVbHYxcUdZSTJwb3I0dm5Z?=
 =?utf-8?B?YVFrUWlvcDQrTDRkRVNEQVNhSUpYMGlCRXdBTVhNOERhL2RsYWthYzY3TERx?=
 =?utf-8?B?bUNuekxndFM1SzE4TWlqMGtDQVBaZUFIdUh5VGtPU0tnVUYycmdOTmcwZ21G?=
 =?utf-8?B?c0hBcThzSkordkhkWTBGUDg4aW5IK3NRZUhSUWVvZy83RXR4NENHVjdCNnY5?=
 =?utf-8?B?Ri9MNmlPVXhiRGZpRlpWeERUck0xTng2S0c3QU90WnVxTlRZd21ObkJwLzZE?=
 =?utf-8?B?VG42c3QveFlxUFBWNmtob2hYWVRzcWZpNEM5UVQrVC9GVU9xYXNhZjdNbUpx?=
 =?utf-8?B?ZG83T2JmNnAzZm9QWTZsbUFwSjdiN2tDcjgwMXhPUDZFRlRtUDBTL2tlZVh3?=
 =?utf-8?B?QW1pd0RPVW1OZW4vd3FhUGhaRzUrRW44LzVtMGpaNzVmWkx3ekVTbUx2UUhV?=
 =?utf-8?B?d21zME0rWmw2T1ZjRjZ6NHVjZEJOTmIzR2thL0M2amRDcVE3SDNURGJ5ZHJU?=
 =?utf-8?B?N2NVVE1LUXZOUWRaWVJZWG8vY0xDN0xjTXMxOEdhbUJMR2lzL1ZiK1VEOGVO?=
 =?utf-8?B?QlNSTndaWHM1Q3Rtd05iSHIyNlVUek1pbU84d1JXUGlDdjVqUHhqSTJ1b2E1?=
 =?utf-8?B?T2c0SUhaMTlPWG52MUZGdU1wU1lJR3UzQzZWbG1IdXNSL3pGRTR3QUJTR000?=
 =?utf-8?B?cERaVjVCc1IyVEFqbklMV1NYOFh1TkM2cGZFMTdEVFJoc0dHWnhUcE84Y1RV?=
 =?utf-8?B?NkQ1T2FOaDhzS1FrbUNWbVMybVdKQ20zelMvcGM1ZFdLNmZUZ0xzVHRoZUtX?=
 =?utf-8?B?VTJVOUxRMHNxeTdIeWpxZnJSbFBJRlQ1MkprYjllT2lSTDFrTUZKREFpalQ4?=
 =?utf-8?B?QUtpR21vQmJ6eXBTUVRlb1hLSEV6NUd2dU4zZ2Y3WXl6QXhMeS83L25ENzhZ?=
 =?utf-8?B?Y1BXN1FpemUvRldSN3RiNjRtNTZQRi85ZG5VMjBHR3FaN1FRZERqYXFVY0wy?=
 =?utf-8?B?MEJ3ZWJRVnhlVlYybHhvbSt2b1J6QTQxZnlHeWFlaXUxWlZXN0V4amxKL0tR?=
 =?utf-8?B?bnIzclJiYlhvZjBFYzBSMklGdzhZcVljR2oybENsa2VZb2tqa0JVNE9PQjZ3?=
 =?utf-8?B?SjNlTFQ4ZUczTmdPQUFPa2t1WnczKzA1QlhtSlNoT3dQZC9JaGh3akQ2SklS?=
 =?utf-8?B?c1U3NDEzQVJIV29NMEFPK0pmbDNsN05tS0lCbnB2V0FBTFhBZzJQdFM0Y05r?=
 =?utf-8?B?dlBnelp5cGRwZ0F5aHk2TENUd1JUUm1KYm5nbXRZT0pGbXdKa051dz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ce7b36-e754-4197-c17e-08dee905e7fc
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:10.9869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PelTRcD9LODMA2jDHVvb7HoE5dWMXZ2nOOb7zx9LOpLxd5kp/bvUdY+QHw2V2ZC7lgGiFlNrpDZBa1D+/JGSaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
as remove_id_store() can free the node. Thus, make a copy in
pci_match_device(). Also, clarify that the id parameter is only valid
during probe.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/
Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
 include/linux/pci.h      |  1 +
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index ab3bb756ce89..e16aa59dd7ac 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -180,6 +180,7 @@ static const struct pci_device_id pci_device_id_any = {
  * pci_match_device - See if a device matches a driver's list of IDs
  * @drv: the PCI driver to match against
  * @dev: the PCI device structure to match against
+ * @id_copy: place to store copy of pci_device_id for dynamic ID
  *
  * Used by a driver to check whether a PCI device is in its list of
  * supported devices or in the dynids list, which may have been augmented
@@ -187,9 +188,9 @@ static const struct pci_device_id pci_device_id_any = {
  * structure or %NULL if there is no match.
  */
 static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
-						    struct pci_dev *dev)
+						    struct pci_dev *dev,
+						    struct pci_device_id *id_copy)
 {
-	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL;
 	struct pci_device_id dev_id;
 	int ret;
@@ -201,17 +202,16 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 
 	dev_id = pci_id_from_device(dev);
 	/* Look at the dynamic ids first, before the static ones */
-	spin_lock(&drv->dynids.lock);
-	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (pci_match_one_id(&dynid->id, &dev_id)) {
-			found_id = &dynid->id;
-			break;
+	scoped_guard(spinlock, &drv->dynids.lock) {
+		struct pci_dynid *dynid;
+
+		list_for_each_entry(dynid, &drv->dynids.list, node) {
+			if (pci_match_one_id(&dynid->id, &dev_id)) {
+				*id_copy = dynid->id;
+				return id_copy;
+			}
 		}
 	}
-	spin_unlock(&drv->dynids.lock);
-
-	if (found_id)
-		return found_id;
 
 	found_id = do_pci_match_id(drv->id_table, &dev_id, ret > 0);
 	if (found_id)
@@ -467,12 +467,13 @@ void pci_probe_flush_workqueue(void)
 static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 {
 	const struct pci_device_id *id;
+	struct pci_device_id id_copy;
 	int error = 0;
 
 	if (drv->probe) {
 		error = -ENODEV;
 
-		id = pci_match_device(drv, pci_dev);
+		id = pci_match_device(drv, pci_dev, &id_copy);
 		if (id)
 			error = pci_call_probe(drv, pci_dev, id);
 	}
@@ -1560,12 +1561,13 @@ static int pci_bus_match(struct device *dev, const struct device_driver *drv)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *pci_drv;
 	const struct pci_device_id *found_id;
+	struct pci_device_id id_copy;
 
 	if (pci_dev_binding_disallowed(pci_dev))
 		return 0;
 
 	pci_drv = (struct pci_driver *)to_pci_driver(drv);
-	found_id = pci_match_device(pci_drv, pci_dev);
+	found_id = pci_match_device(pci_drv, pci_dev, &id_copy);
 	if (found_id)
 		return 1;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 64b308b6e61c..92c17c116de6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -979,6 +979,7 @@ struct module;
  *		function returns zero when the driver chooses to
  *		take "ownership" of the device or an error code
  *		(negative number) otherwise.
+ *		The pci_device_id parameter is only valid during probe.
  *		The probe function always gets called from process
  *		context, so it can sleep.
  * @remove:	The remove() function gets called whenever a device

-- 
2.54.0

