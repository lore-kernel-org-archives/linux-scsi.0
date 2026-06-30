Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021075.outbound.protection.outlook.com [52.101.100.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D26407CFB;
	Tue, 30 Jun 2026 11:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817779; cv=fail; b=OUy+zMuwMs0qvjgcTB/G1NiGJburSkz6KIWeIWe4n64pttvSeVW0E/TjCiGm4OOyVF5UZmimheN+yNYdZmvdSjWYL5upVWBBdZ4utm6BFPZXL59k9lcwbM1PIRX/XlJSf9dRB8M0dz8nWHuYFvA2Z8L67VOcHhF1nY42o/PE/Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817779; c=relaxed/simple;
	bh=89KkapWbv88nicOLg38FIN7IRrD3WropbzSX4CaDkUk=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=vC3HdCVNk+cAaNRY3H2LJS4xC4x4u/cpNVJ/gorpionLV1zNjlVoTvCB13iL1HHv+QhxHEsO3MXwhxgxI4bt/y9CIC/snisirTiZyhg0XITkkyPtvlu83MA/ubUDtfiBlqRJnJDh09JWfyxtUlGaLX9fLXqGkMrCh4v2tFb35Cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=Ty3eJKdY; arc=fail smtp.client-ip=52.101.100.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="Ty3eJKdY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNS0CifYU1zgGllSFhY7Eq4DgUHZQwOzrkX8j7FOjU1GQVNnpDSLoMgLC6iftrBc4+2hx/Ye9NMtJQNjzw+//SefBTo717Wk9Yf1YbOgCP37PR6RIsSGhwvS/E+lwBPlcrVvi/fzyQMe8lFLXZNOmKM2vlBQKHwMZkSVp0n/v8TxdS2WEsERwIxHrGZ4tYe1c48JvqMMB8dFSY3Vrn7wj9XqXeg4nQF9iVyeBJbu1k9lsviIPWC6OV21SHluQB5k9Naatcdpdr1BuyjJyq9a4ZEGiN8XMVWu7hojoWJpCUXSLCZ7g2tQ9URaGEkMAjHcD9a/8/KhwwCegNYWZMxKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IM1U+UrEg6Aig4u/4mKyaYSNuTMt+peDccM5jCsKkc=;
 b=r9FwYEBF2h/x+I6noQofOdzpZEc8J7W3VhpDoVSMvngNljHaKQX+WgBj9jfoKfim8ngyIaOh3HmquV1e5Tq6rYQ264oULNgvW5qVbBPOoLDlUBZXbGlF7e2w1e/HrOniqaHPlsk8vF0l7Qln3fXm5HMeDUJngL6pUxpnLkSAZ+jmXnyvufSjckY+iFibfZWSmIeEYIpsy+N/HWBq2/M/MKlZGMHyu430W6tW32a1gwRd9z4SLIpkz6lGxZ/KvpfF3EBbEghoxjIjqCCx7RHKFtW+WU3ehMo+/vPjd2SFfsfOHyFiaj3GyQfTc78s+PSWJhjzkPRxwxXOAZ/pIv7VRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IM1U+UrEg6Aig4u/4mKyaYSNuTMt+peDccM5jCsKkc=;
 b=Ty3eJKdY9hJV7NThXu2/W4oV7g0uGpUHUGNgk9orFDaiXAN7E6By9PXFT35la1s7opHppzUSu4blPJCwIid3gTlGFl2NWULUbqEDklmkfAh6YbZ0u5bm1dvFAGyYQ+q20mqK8ZhOUWw/AHBgeFmdQc/9ajx9uDo7RrvPfeXbJ7k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWLP265MB6625.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 11:09:29 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 11:09:29 +0000
From: Gary Guo <gary@garyguo.net>
Date: Tue, 30 Jun 2026 12:09:07 +0100
Subject: [PATCH v2 7/7] pci: fix UAF when probe runs concurrent to dyn ID
 removal
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-pci_id_fix-v2-7-b834a98c0af2@garyguo.net>
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
 netdev@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>, 
 Gary Guo <gary@garyguo.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782817763; l=4607;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=89KkapWbv88nicOLg38FIN7IRrD3WropbzSX4CaDkUk=;
 b=yoTLvxj4cxLVVJfvlIBmUw5UaXV5K8JirIC3GO86umk3IEqgJsEX20JTLcMAA5AdptQdf5jDt
 vL1e16/pVZYDr/xCIJEWG8iPZF3pus0vY+yCw+6zsqt9Gsk4FAMYByg
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
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CWLP265MB6625:EE_
X-MS-Office365-Filtering-Correlation-Id: cb378601-2042-436d-7893-08ded6980c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|23010399003|18002099003|22082099003|56012099006|921020|3023799007;
X-Microsoft-Antispam-Message-Info:
	KGHJKViJojSJgLXKzGtNjzxkEbEe4ED0NEEXyULG54mOkrQWR9JXXEeSd4Mt16WnhuCQSfKQFk7YhBPISx/yOI33ABBw3VMf6KJalGBeri9z4z6ka1iLydR92BvQBq0TuJcCoIFHcG5J7A1Otw6GtwWYQDII+qLOpBu8oXqhbDy5qfoR1dlT3iPnLhuIDtKqfowwd2vKUxR8KETe6BwBH8/6nicKM7MDaixuY6xuapTMHxxqxC+JlZlLAKJbAwJP5w7vMlEEeXH/AvpB9LhldvXrTJZYXvtE09kg7Deikp62Mb2QK6eMV8XDpAwXcijP34QglcFsyHeu1lipvWb5sXo0f60LjHIGBWeAbCUuIv+Y+PrGChbtYrdZariwWVWHgYwRR3KuK4fr75jFhMCYqaGv60u4iVMs6MtSALvzZOFD3yNlMuU3yC+64jrZbdxMAx8zRbEvF8iv/gXK63lySojCvvWTC0Y0xyXzE6ODVrF6UylRhmzoWR1QEoyZK4+MfaBiBa6fuNal8hT2+nTqn99DEnYkWiSbllJB/boYXDNXjPwBHPdACBP5f2dS0Bbs+sfuXgarrivuJfsi+vIcI/nhS31QOmhRdAtBa0/MhHGBQ69i60R/UIJ19J0XO8DC+579yRp/ke0dIOGx9ulccgKHyJ0/4tfTVu/EKYp4US6m/lMVugqopHY0g59gN8DjbzicH8d53baN5kuVhgi/ig==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(23010399003)(18002099003)(22082099003)(56012099006)(921020)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3FuSCtUc2c3bWVFSHVzM3hkZjRKOVFiUjdnaVgxNHdnenU4THExd3ZJQTNo?=
 =?utf-8?B?VEZiK2xEUFVKM2d1Y1BZcDlHWE14VFNUR1NxQWhETno3ZHJHeW5XbGFWeXJO?=
 =?utf-8?B?R29DNUVKZVNYNVRISkVUUGg5WTNoL2xmblU1R2tocnZFOWdZMGxYQmZnbXVI?=
 =?utf-8?B?UCsxTlM3WW45cmdwcnNWK1VuYjd6VEdyMko4UE9wdFNSY2hwL2IrUzRZVnl4?=
 =?utf-8?B?TlRLK0pJVWRKd2lUME1hV0xKUWdpM0k1THM0ZXA2aDVWQlZoQml2R1FITTFQ?=
 =?utf-8?B?N1BxVDJ5WnR2cldFajYxOUJ0QVY5aDc2Q0o0YmhieVk2VDdUS25hMFlzODli?=
 =?utf-8?B?ZnZrWGI3NFVjampUWlk2dzFkcjg1d0o5SzNXMlgxL3hPWWZQMHc4Kzg5TVpJ?=
 =?utf-8?B?SE0zSmlPQ3gycFpIdERvWlRLWkRMbmNJNEYzVm1BK0NoL3JlMDV0b1d1cHY4?=
 =?utf-8?B?V0tkQ1Q0VGg1bkFBcjRQVitYa2hVbG1URFlVVE9TM2ZIbHVCdTZZb2t5cjdi?=
 =?utf-8?B?V2xVOS9XWmprcXJTZXNGbHdNcDNISWRNRUFHWTdWdS9weEhXaHRqc0plb3g1?=
 =?utf-8?B?RlhXMjUrdGdPRnZ6Um5GRksyNGVyL1NpK1JqVFVrYWtOVnA0Q1Z0cXFoYkNN?=
 =?utf-8?B?YjdkV0EzcWlua0s1T1F5RFNISDVVNFF5QmhsTlNBN05Md0JQRHZ1bEs1YzFv?=
 =?utf-8?B?SkJTZDJNR2F4U3ZKUDludjFEV3ExSytTR0loNGRQOEM3N3VsSnYwRUhQVEY3?=
 =?utf-8?B?QzJqa1B1bFVSaC9weEswR1dmUzJwZDdad3NFMDJUMHMrQ0k0dWRQTU9uTVVo?=
 =?utf-8?B?blhobVFGNkVleDhIQUhvcEVjYzBaZlBWT1IwN25oQjFLQWI4NWpmK2tQemtX?=
 =?utf-8?B?ZjJnLy9lNUUvTzhnV1NvNExONTVmdHZWSmxpNFdoRzJKdFNma1JXYVVrQldO?=
 =?utf-8?B?T0syR0VxdGdwR3hucE9RZVNCa1NxNTB4aU1sZWh4MzB4Y2tMOWVZZjltaldZ?=
 =?utf-8?B?aWpFTGVaRk9rVWlGMC8wZTFtQmp5anFURmY2dnM4cVpiOWwvelJRbGVwWnN6?=
 =?utf-8?B?ZjdGWUZMRlRySThJUm9aMmNvL3Zwa2JObExrU1N1WkExSitCNmZFM1FCcWQ4?=
 =?utf-8?B?NHVVMXAxY1V3VWUwNjc2T0hLMWV4R0NqbkpVaUhNbWRCYmZGK1VmNFRBUUt1?=
 =?utf-8?B?V05XcmNlR09BNTc1bGo5RkpCS21neXlnR2VPc1lSamdpMno0NEkxZkNkUTBW?=
 =?utf-8?B?dDdUU1I5Qk9uRUIzMWZLWFdLeFlnUmxCcG9Cb2tHRFZHdHY5VlJRa1ZZNUNI?=
 =?utf-8?B?RzhVVGVFTVN3bEVpT3NXenhVb3ZWYUdIUE5kL3ZNU25rUFdPWUdEb1dFRHZo?=
 =?utf-8?B?bkpxWHFoSXZBUXBsb3d1WGFLZmswRVk5dHVjYU55QisxQ0s0azlIVDZuM1E2?=
 =?utf-8?B?YTBXdGthbTJabUdKTk0xV2JkWmpEY2JmZlU4am10S1dDeDFqeTZTVDNUUFJq?=
 =?utf-8?B?WVdVNEFXaEVQcUt6dFRVbFFXRGY5RnVYV012VEJta1Y3NGkrbjhUdzh3emd3?=
 =?utf-8?B?S0p1cTFOSXQwZmNEUTcrMUF3NE1ZU3c4UnNuVWR2b0pOdEFxd0UyeFZLU0N6?=
 =?utf-8?B?S2ErU3hPT0hUYm5OOVlzRmNOUmhkUnVPQit2MUhEMUx2UEhTMVFvNjRiQ3RF?=
 =?utf-8?B?c0hFN29ac3RRQ0NqbFB3azU0R1prZGtsbnFpc0M3bW9Lc1ZCcXlXdzJVOWlz?=
 =?utf-8?B?MDhVREVXaHlMYy9NdHkvbElORnlka2gycnRuNy83R05PdmVDTjFWNkFwaG1H?=
 =?utf-8?B?ZTAwbTd2eFlZRHZXbnVqa1VmOCtvVTN4aGRFZmpaVUhPKzgrVnBOVGdoZVpI?=
 =?utf-8?B?MjVLY3ZjckNxNStKR2ViRDZnT3V6Q3orenR1MXBnTnlHRlZBWVlFeXN0SzM3?=
 =?utf-8?B?M1htWmhUOHg5SFZDS2F4WFlJL0d2MGdGRmoyNGp2LzJ1bHVUV2E0ajRCb2ox?=
 =?utf-8?B?SXgvUmVmc0wwOUF5VGpsUThwYXAvY01zbWtPN2VDdUZaK2g4UC8rNDJYUWJr?=
 =?utf-8?B?bkhiR243VHZqUzl6eU9YMmszQm1aQ3gwdzRjU2s4ZGI1VWx2aG1vUFROTU5N?=
 =?utf-8?B?SG1Qc05uMFZJWVJxUy9UL2FXOW00Y3hPbUo1WXc1TWwwMDFCVm1vdzk0cE15?=
 =?utf-8?B?NFpyVjdrOCtwcVVvWlBRTVJ0WnhUbUpDR2M0NllpNWNycXY3Tm1GVDlCb1I2?=
 =?utf-8?B?cDNDZVpkSjQ5Z0lzOHVRdDRnRVdvR01lM2VKSXZCSlM0Y09vUDJRYXJHOTl3?=
 =?utf-8?B?ZDZZVTdSL1FIRm1ScWRBVytsdS84d0l3cEFwT0NUZUtUTHhvQ0RRQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: cb378601-2042-436d-7893-08ded6980c66
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 11:09:26.5273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KKyAwTs0OpeEpioSErv1+V5nE5b8JwBMERASSAll1R+sD4wbn69aE+FnaiGDrdrxVxo3+Gu66d+/DnGt1DZDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB6625

Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
as remove_id_store can free the node. Thus, make a copy in
pci_match_device. Also, clarify that the id parameter is only valid during
probe.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/
Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/pci/pci-driver.c | 58 ++++++++++++++++++++++++------------------------
 include/linux/pci.h      |  1 +
 2 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index df1be7ea2bde..fad028b9dc53 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -179,14 +179,16 @@ static const struct pci_device_id pci_device_id_any = {
  * pci_match_device - See if a device matches a driver's list of IDs
  * @drv: the PCI driver to match against
  * @dev: the PCI device structure to match against
+ * @id: Matched pci_device_id
  *
  * Used by a driver to check whether a PCI device is in its list of
  * supported devices or in the dynids list, which may have been augmented
- * via the sysfs "new_id" file.  Returns the matching pci_device_id
- * structure or %NULL if there is no match.
+ * via the sysfs "new_id" file.  Returns true if there is a match, the matched
+ * ID is stored in @id.
  */
-static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
-						    struct pci_dev *dev)
+static bool pci_match_device(struct pci_driver *drv,
+			     struct pci_dev *dev,
+			     struct pci_device_id *id)
 {
 	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL;
@@ -196,30 +198,33 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	/* When driver_override is set, only bind to the matching driver */
 	ret = device_match_driver_override(&dev->dev, &drv->driver);
 	if (ret == 0)
-		return NULL;
+		return false;
 
 	dev_id = pci_id_from_device(dev);
 	/* Look at the dynamic ids first, before the static ones */
-	spin_lock(&drv->dynids.lock);
-	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (pci_match_one_id(&dynid->id, &dev_id)) {
-			found_id = &dynid->id;
-			break;
+	{
+		guard(spinlock)(&drv->dynids.lock);
+		list_for_each_entry(dynid, &drv->dynids.list, node) {
+			if (pci_match_one_id(&dynid->id, &dev_id)) {
+				*id = dynid->id;
+				return true;
+			}
 		}
 	}
-	spin_unlock(&drv->dynids.lock);
-
-	if (found_id)
-		return found_id;
 
 	found_id = do_pci_match_id(drv->id_table, &dev_id, ret > 0);
-	if (found_id)
-		return found_id;
+	if (found_id) {
+		*id = *found_id;
+		return true;
+	}
 
 	/* driver_override will always match, send a dummy id */
-	if (ret > 0)
-		return &pci_device_id_any;
-	return NULL;
+	if (ret > 0) {
+		*id = pci_device_id_any;
+		return true;
+	}
+
+	return false;
 }
 
 /**
@@ -465,15 +470,14 @@ void pci_probe_flush_workqueue(void)
  */
 static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 {
-	const struct pci_device_id *id;
+	struct pci_device_id id;
 	int error = 0;
 
 	if (drv->probe) {
 		error = -ENODEV;
 
-		id = pci_match_device(drv, pci_dev);
-		if (id)
-			error = pci_call_probe(drv, pci_dev, id);
+		if (pci_match_device(drv, pci_dev, &id))
+			error = pci_call_probe(drv, pci_dev, &id);
 	}
 	return error;
 }
@@ -1558,17 +1562,13 @@ static int pci_bus_match(struct device *dev, const struct device_driver *drv)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *pci_drv;
-	const struct pci_device_id *found_id;
+	struct pci_device_id id;
 
 	if (pci_dev_binding_disallowed(pci_dev))
 		return 0;
 
 	pci_drv = (struct pci_driver *)to_pci_driver(drv);
-	found_id = pci_match_device(pci_drv, pci_dev);
-	if (found_id)
-		return 1;
-
-	return 0;
+	return pci_match_device(pci_drv, pci_dev, &id);
 }
 
 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ebb5b9d76360..f128d8c0cbb6 100644
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

