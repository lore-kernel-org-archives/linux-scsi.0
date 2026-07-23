Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022093.outbound.protection.outlook.com [52.101.96.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9FE3546DF;
	Thu, 23 Jul 2026 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844096; cv=fail; b=WrfJ+dXQeVdcJSN0OsrEndUZlCqoWnfU81POgS2qcEYRNgrZRZnxA+SUtZGWYuEWyXzI8Tmvno3hdNk8axZvrDhxVKqGyFFk8LWtKpiAgSobHkdi3b9mICTqYeK6S5rC7WGWmpjoIRpzQI2JJsnau4537KCYDgSyHdo1MuCI7xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844096; c=relaxed/simple;
	bh=wgL7fCE//vjwzTSIhjUwV/F00oWziqEaO95Fl1LpTDo=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=I+65glLIWgyZuyYS2qF7PPQUnruv20qj4iXNNBtW3R/gLjblOBPe7ui7VIonPspiPwleXg61H8pApRUnzhMvR4enW5wd8pUIluuOVozkOYUSFyrvMejvqSZ/t6XzsDU4u4yQ1ml2q3TtrXRBZ4BGA3yg/DViKmVk0PbcV794thc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=Wjbzalhy; arc=fail smtp.client-ip=52.101.96.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="Wjbzalhy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xxpxQljjeF7hpuVJw65V0NVUoThJnE16ITUtQPTmEl7sWO12YPRT6OmXgNAxwJBUE9F9qfNDdCYqRL8LnpJbpgjKxsRhXCcdo6nXjTN7BIjB8+4K83PPUTz04RzoySNIEd3N64atqWY6ZF8Az2yy5Yf/IByJDGYt0G+2wwwmaV9GEtar7FV9jFrrj+PL5+MfxNLff33FQARvKy9WNxaza7PRhbZ3SZFdBYfkq3FRZkYgjfhtEX3ieCgDY2fng2kfpclFkIF+fyDXBdU1pRO1FoiArIVOq+Jk9RyJgb5/CLtI9F9UfhcCitbUoyYUv9oUJYiD2Vu1U7SnndMIjndXbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7V/cR9AyVAcL4HsXPbg162VLpkBkDOgBZmZ687ae1M=;
 b=ZNGqqxKVfrrw5X5jSSWOHy+h1GFSd3HSad1EStsc8YE4qtBO64sErFXl0VMWyAfvIEB2zWfwpM+UF0j6qWofHLXKe9Mg2luHx7qSXsOAqsl1vWdQHN/rbM/Vu6F0zUUI1DhYrsLLpi0D5Ne+MUIfEvtjojxxNSsDSpXT2WaXwiKRXxsOryVFl99fxhE46a2ObD5HwffNuvNEp5WNzs6L+jgQxOvpYgUqtMc0UNkzqekEEZ9RM4+oEcIQqjbjLAnrvz18Mx0qI6ipJFASMU1kMQjody135CJH4127UCiBejVeVlRFoTVEcBCBm2stSrqamujis9CPLB3/ZojzCWreKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7V/cR9AyVAcL4HsXPbg162VLpkBkDOgBZmZ687ae1M=;
 b=WjbzalhymJxEI+VZ7X6TuE3p+QPI4DjYiP35d/jCc45k3eTEJBaCMo8OUTfxI2vEJGczM4a1kY4PAwl51njSl2qAQBUtXicXs80PHBtaq0oXSAxoLV0ElEyswMQTqjdD3bpAt4PUP6LPvHvyBVHirBn2SlDW1X08u68t6P/rIYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 22:01:08 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:01:08 +0000
From: Gary Guo <gary@garyguo.net>
Date: Thu, 23 Jul 2026 23:00:42 +0100
Subject: [PATCH v4 3/9] ipack: tpci200: don't store pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-3-3580726844e1@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=1308;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=wgL7fCE//vjwzTSIhjUwV/F00oWziqEaO95Fl1LpTDo=;
 b=R93S+PTbAf9QYW0nsAfTg/yQsXSru11QUm0q9HbpH8ecie9MSXW8hub7SfcOT07X16kTX+SwU
 /YuSeGSV8++D7hXe7zHlNS8APaW2k11F279ycBWwImLSptbURSprPSH
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
X-MS-Office365-Filtering-Correlation-Id: 3f9c9a39-63ee-4795-4085-08dee905e678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	/ZOe5fYFK8BbxqXkWeWH6TEB9zgUaHgg5qEK90GeqDBOBt+23DBzsS1fYkQ8GPnv16ppGu1Y4QjloF+92HA6tMx9bYDvOcbAgCZwgSE/nGsC3ZIR3XL2YBX8jEL/cisfM80IuHbI+fCsHwY7mUIyM0WYfC4IlHM6GxH/7mVXTHmLMKBHLDwGyZOm6LQlhjKj2akdOcHoMVl+MPIYXc12WPQ84/9B5/SJZUydkYb1fINfImhztouWIe2Eq8hzJLezP0uwosxd8W7fpkgu64Qhth3UqG5XEnLp1AvOgkLACrmq/jt62ioDCJoAxE/ic/F5vdQk1MLx0w6H+NjCEdUYB/zF6ol7oT0tF0HKjJ/F9QTyjOPN9trAc8gy3krTr9v4wSp77t6nsdHWjqiMlvIcTG3or+mbeck6A6uckAxjcmLiREjCPAvshUOTf41VF9H0Ft4990erHp8YmhmGPX0b2vlb0IfYbRcAvArJvCjTnzjPHsMPb2KwVgbOywffc+cA8jfGVH2/YTErc7LOUmsTyjSHNX6ihtKDCPo2POMj27PCnOsmGOaij3QVB4hKifKeqs9flm/3nf7QhyUBWie5xlWubm7EeSKJgiDVclKr447/L9mHgbbaAr6zWrrta+C/iSDMvXIC6XlzEK3IeYJ1jnZ6FOPgAiji+bXnvDoqfa1rsNzCB7W/IgawK/hGAW8pFc6s0hJPTUmt67SLZ3OI9g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enV6N04xMlFobXRJTkRZT2M1eVlNb01ZRXpTMitLeWFZMGJ1cGFHV295dmNB?=
 =?utf-8?B?eUdHbUNpdHZCcjh4T1U4R1JyYk5BZFV1U2pHZFN6WjNBTG1XeWhhaExZYkl1?=
 =?utf-8?B?bllCWjZkTngyQUUwVG5xWjJaSzJOaVltTTJvVlJqcFJGZjlxZXNQYld0NzF3?=
 =?utf-8?B?b3BVOE1NUmh5b2tMYVViVWtVVkIyenluSHFFZXpyUkp1YmVQekd3emU0bE5z?=
 =?utf-8?B?aGhxS3kwOFl1dTlMUllob0pESVNFbG5UaU5KQmpsR0VFNkt5TnNVRGVZZTJq?=
 =?utf-8?B?U1dKNXZscGVjaUcvZnA1VmNrR2s4V0VYcFFmeG1icm90UEpyZUtPdFpWQlgr?=
 =?utf-8?B?NGtxUkZENUxYVFZlOWtveGtWN3dRZjVnc2s2cG9jZ0h2RkE2akl4YkNkSXdJ?=
 =?utf-8?B?UlpiaEtKWkdrRGRnZ2lSWm40cjRlZmhCNklPWGFYZzhZcmpBOXZoVlpwSnYz?=
 =?utf-8?B?OXQ2RzJldnBYZ2lRVnNsZXd5TnFLQmZqSm9Fa0RzdE5tMXBCek4wNWRBUU9n?=
 =?utf-8?B?aDV5SFkyNzBHd0JOMmxYOVBsY1BJM2ZOR3F1Z2h2Q3R1ejR0OGEwYkc4YlF0?=
 =?utf-8?B?STBMYTFJZnB6MEQ1OWZlcGxlUzhRbmlqRktoQVlsUmlXWVdZTmxyeVRWT2E5?=
 =?utf-8?B?VkUrKzZuWkg0SXE0YUVNQ2hCQnQ1UThuMUZRYUJNbmFGSG5nQWF4L0c1VTgv?=
 =?utf-8?B?R3dUK01LREQvNlBmQ1EvbWx6cFRidU1UbFFzT01nb0ZTblhlcjhidlF3WHlu?=
 =?utf-8?B?dTd4MDJXL3lKY2dhRzNWcHgvT0pKaHdMazVUcFk1YUpsSGlQWGNzM3RTNkVQ?=
 =?utf-8?B?blE1ck55elRYNmdmQXNsQTVDVkdqd1RuQk50c0ZIWG9YeU1Qb3VZV0k0bE5M?=
 =?utf-8?B?SVVDLzJWNWVsWkdGdHp2eWtJY2VZYjRTNnorTkVSeHdSWk1mRS9ZWVF6OEx3?=
 =?utf-8?B?bFR6cWVCQXZnWTBueGZrNkdTS2pLU3oyQmNJbDFudmQ0bzloZzFoTGMyTEhI?=
 =?utf-8?B?S1A2Y016M2Q4YTNPWkpDaDM5NmlaZ1QwRXpYcGxmcmlaQXVralJVcjhFVHVa?=
 =?utf-8?B?di83emR1MG50REJsS1V5aksxcGtRWkUwOHRUQ2I4M04rQVd2NER1QXBsK3ZH?=
 =?utf-8?B?SEI2VlUrb3g1RFpXSVdrMGFuRHY1cnRSakc4ZjFYSFVobUJPYXU3Zjgydmcx?=
 =?utf-8?B?YkJBcTg1Vm5GaFhmSDd1aThSd2RTUnkrMEovRVo0Y2RjL0JwSER3VmtXQ3Y1?=
 =?utf-8?B?L3NpbzVQN0FMUVo0YlNJbXhpOW5oM3k2NmMrcWdaU0MxanhoaXVmTVozMisy?=
 =?utf-8?B?OFJsL2N5NFlHR29UR3I3cERCUWJyL2hLVlUvNEM4TUkzUXRaclpYbGJzYmhD?=
 =?utf-8?B?NFp4dnFGWlBPMWVLRnNGZWE1WW5jcWtyL3EwK0F5ZjMwY3pWOG1pemU5c3kv?=
 =?utf-8?B?ZW04d0h6YzRZcUFxQWVVSHJKVkVmRkFlYnlxK1oybjlCTytpMkJrUHE2bWpu?=
 =?utf-8?B?dW92Uit5cmpNck4xY1pwL09VMXpkTGZTZHRoUGtrNCtsMXlOLzltQVVhZ0RI?=
 =?utf-8?B?T2x1K1ZoZnFVcEVuczdOTTFxQ0NmT3dxaENyMEF2dEVGaENPK1k4aFMxNEpK?=
 =?utf-8?B?Q0g0V3c1MmtnWG44bVM5UG51WlBxUUJjNmNnTDZvSnllaUpCZ2xHRG9FSW5h?=
 =?utf-8?B?MHBXUG9OUkp4VllLaGtadWd6dWMvV2RYWG5JdjNQYUpCaktQSDBOZ2RJT29X?=
 =?utf-8?B?cThmeDBiZHBIZkhpdzh1OVpwN0FwL3djUkVHbXo5Wm1zQXNMRzdLeFY4UDlP?=
 =?utf-8?B?djlKM0pqVUFkZ0h2eHk2WVd5UTFiNVB5K1l2YW5zVnU3aFRrVmlyVUZEeitZ?=
 =?utf-8?B?dzNlMHoxbkJjb0tseVc3dU9kOTJUQUo1RjUvM29BQ2pnVnRWak54TFZidXVM?=
 =?utf-8?B?ZGhNMWdjbWFQZzZ0d1hxWXlBK2xDMkZnZUFqRnpCTFZjKzBhTlo2N3ZDcUpy?=
 =?utf-8?B?enJrWDVqK2NQM0ZQVFR2eWVQMWdVOFBsYldSb1BuSlUyVUY3YjZJbXh1QVdY?=
 =?utf-8?B?aUhRc2MvU1p1M0NjOXNnR05MWTBhelAzV3pWS011K043aEdxOCszNm9QYlgw?=
 =?utf-8?B?c3ZGaWg3eCtxR0JRZG1lYmhIc1FmN1NJMnJRNGYwcFFDVEc3SkFoV2dGSTAx?=
 =?utf-8?B?WS9KRVExaGpGWS9ZN3BSa0hOWVZnWjE1b1lwMk1PKzBoL3FPd0FPM3N3bFd2?=
 =?utf-8?B?bHYvRkdOSFp1TjI4Qm9tMDhVR3hheTZtVlMwVkczL2NaNkx1V3ozU25ZYmFa?=
 =?utf-8?B?cjlWNU1RaXJ0dlozQXM0RGlOdWxqN0tId0pra3prdk85YXV5MFA4QT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9c9a39-63ee-4795-4085-08dee905e678
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:08.4432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cMBYAXF74RyS/X3Wafm3kWBklyBUn9eImzBm5eb4eopbkG853NHvmtEe+Ojll5uCYRzbRjd7cs8fc70bHGtmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. This stored ID is unused so remove it.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/ipack/carriers/tpci200.c | 1 -
 drivers/ipack/carriers/tpci200.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 05dcb6675cd6..1cf51f763293 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -562,7 +562,6 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 
 	/* Save struct pci_dev pointer */
 	tpci200->info->pdev = pdev;
-	tpci200->info->id_table = (struct pci_device_id *)id;
 
 	/* register the device and initialize it */
 	ret = tpci200_install(tpci200);
diff --git a/drivers/ipack/carriers/tpci200.h b/drivers/ipack/carriers/tpci200.h
index e79ac64abcff..a2bf3125794b 100644
--- a/drivers/ipack/carriers/tpci200.h
+++ b/drivers/ipack/carriers/tpci200.h
@@ -145,7 +145,6 @@ struct tpci200_slot {
  */
 struct tpci200_infos {
 	struct pci_dev			*pdev;
-	struct pci_device_id		*id_table;
 	struct tpci200_regs __iomem	*interface_regs;
 	void __iomem			*cfg_regs;
 	struct ipack_bus_device		*ipack_bus;

-- 
2.54.0

