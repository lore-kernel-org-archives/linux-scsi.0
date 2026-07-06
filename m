Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020136.outbound.protection.outlook.com [52.101.196.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A552937883C;
	Mon,  6 Jul 2026 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347109; cv=fail; b=dHq8XYINc3MlTvN0wgsnNOEOSRGnq49sAAxHr2SR4DyLg6Wl7W9C7iHkXzztCo2A4cwKvLy8pVSKIleeNP2QhVjZ8Ob/sjtrT9sCps2EkWLfGPpebJ0oqYadB/Yyo0aKofsGOBP0piW+qxWbo6b5dc+jmQQZJY3G7BfBQNOkFBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347109; c=relaxed/simple;
	bh=VUc8nQX6CjZ7+EWLu/ehxZTKqVLjapMAkfo1g01iaw4=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=sTOt0Dfyn9bZYIoLjMnDWeiywpvI1+vMxD58RGR2K/I5lm80Z2UqchFhNy52+Pie7Uuxc7Rlq7bhTVcy41hW5MT7Zpvm6uS39HX67/d+4JvmweY5FzUfynWYQGakyOJvIZIpySMUPVqOchQyUUMsT6GGGX+rVZwoXCL93PXp380=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=Qh1Vmqsn; arc=fail smtp.client-ip=52.101.196.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="Qh1Vmqsn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVzIAVSIPBSHFjiabz261JIVBxNdZy25MENzSdtadRvc+CW44OyLZVeCwcOfCS2dEUtsCUqYdTsa8MKqYuMZ1gXksnJjuEACKHD6o3arwig5NHDb49KWCujDpEsJtD/oPgRpIWpUgSTl23PGWavAvVzb8igE/gqHtt5zTVqz2+IbTkI3oVvIH9qpWzU/6CJY6PcPtNcG6GMSyhGdN8Jw5Z6DjMM5TpL/BOC3EiUvqUUf4F+5Nzg+Cw8ZoGeLAbeOqvJr1orPBMqLteCY+0LdaiuhpNMeI5vaPh1t5qjnVOXwJCJPc69IWXDRzDdG0+iP2rUDohshlld95ICjEX9Nhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdqIbNvxzqUYiNRvCdlxrbT5wN+ir6dmovcR66lSGlE=;
 b=tnOcH4sjnpEczbiA9RtKJhHEp+xmAewJk+gIpcmwXjbNBl7RYS8ppvN+WpQlMeUr4FhXmpByFF8e44KqES248fdCZfyvR9tiGGLFrNwgNmXZiiZRRRSgVVY9bTWt2oVF+kUy36zyy0ZOmFo9FTjp1Gcjy/PocijUOMC6deTZ5mlYTd/QVmOVtHKsi1HGWmK1KJwNw9wWUfDZsQJayRgXCdN9Muw2YP163gHdkZLS/0mGCGE05iH38AmbhDJ0MyuJ0DM7QMZHP7x1WAJxXhji5yw+maT+U6DozRzr2r3PE6ShASqUQuRVS3llNlSA284i2gSiJe4QpRLv/vMncql5nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdqIbNvxzqUYiNRvCdlxrbT5wN+ir6dmovcR66lSGlE=;
 b=Qh1VmqsnSbXEBgI6tLgi0ximOAY5z8Wvs6fLA1Ng0wo1VOwjPtViQ0SmXWT6FCSxULd5n0l2yTp+C69cCOiPeaUu920Vd0YHxtcIICgVxuIuoK4wpV2x/6Dun0+aPBM/k5lG1TAAYLJmYc4ND5cx0qpRrOtYOzRk8Ph+ymJN3iY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CW1P265MB9444.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 14:11:39 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:11:39 +0000
From: Gary Guo <gary@garyguo.net>
Date: Mon, 06 Jul 2026 15:11:17 +0100
Subject: [PATCH v3 5/9] agp/via: don't rely on address of pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-5-2d48fc025acc@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=9887;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=VUc8nQX6CjZ7+EWLu/ehxZTKqVLjapMAkfo1g01iaw4=;
 b=NkhLqBIwxB/vIu8dBA9K0tAs1kFuONEeI6/8Hlqd5uMxGl+LwMqxLz7sB6kew5Oc9T2q+5ixw
 1gMSHw1/cjKBSMKB6tOzqIiChfj1+t7TzhZRYerLJ+MBGDAJTXwi7As
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
X-MS-Office365-Filtering-Correlation-Id: 16b324df-c2f9-46b8-0e09-08dedb687d91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|23010399003|376014|1800799024|366016|56012099006|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	CGgWFDv46c9SrgJ4C1Cdh6XmH90XWq6QAWFSoBCHn6RB2sFz+W4dTz0sPFp4Y9yPYJkA6Iqq32h0bXELSPsG7WvQF/JDSxiE0VB6gI5A+NADDRiQag4UBVe29Y5HewITmvsgXpLbHIU28VlXyw59QbZUJNAnnCEvIaL4Oy0rh6eTNAtPa8SJNyMuaylugGM6lxbRNhQR1NjMHdmNB0w9qsyKUEpfU4hhws3TRANR0VvpPgTmp1EJig4IfwYy8nAOM/X+Iu0sUHacsgaJuR6WnRVCHZta00V0BBOI72vmsxNn8chehwJiu3VjfFqbdM/Qbl708eu24KM1RabcjJgb2xaJ2ds3W3xYXYDifhHXJaE4CnhebjXUPknBOIuhjWbgkmuputRRa4bM3PZh9Uo8JMOYuvW0+jSphzhidxySamfUA/sXX9PEYFFi5/riJpM1YhzHIn1X72wfhQ56jln31kbXVYm2Bn9djUZklZG/k2nrbtLsctFuqk8CGNMLCLJzWV/3cCKzxo3cluNLqze8NfdLw8gj9UYKxL1ZhBStVeRyz5dejqmjNmxnWBUFnwpIJFBj8lQ4g7szEPt3Quy88xrACQUx7tmEzv8iJbhQAllKiWmJucDuANxf8PIBf5dUiOua2DMuKOvkbGb4bKAugU01yWkj8azbw7kLfxVAXJ5mX6rQkf8Vwvs3A3tUsHPatm573WyxZgvmatkOph52IQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(23010399003)(376014)(1800799024)(366016)(56012099006)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q09LUmRvb3Bna2djTnRibllHNllnWlowVndtSU1pbHhiZENkTmsyL0R5ME1K?=
 =?utf-8?B?N1Rrb2FIWnVNVlpjeUVIY1BHVkFsdnZMN3A0NFZqQjMxaC9FSnkvcGJRLzdT?=
 =?utf-8?B?NTcxRTVJQk5MREJlRlRIZWU5QlJhaHlUZnV3Y1lET25nKy9sQWpHYmpCZlBw?=
 =?utf-8?B?Y3BNMklYbUNidWUzNEVDWVQvaGR0KzhzRExRQUZMT1NsbmU3V1QxdEx5TStw?=
 =?utf-8?B?NVdDUklCcEJJSXJkNVdHY2xMUFdzQVB4K1c3RnVHYWJwbUk2ejhZZ3p0N3JY?=
 =?utf-8?B?L1Q1NGZ2OEdxVGt0VndMSzMwdG1XUXJ6cWRrdG1URDF3TWxpcVE5c0hNeWpz?=
 =?utf-8?B?UEtEQ0FFVGVRT0ZydVFHQjlrN3RrRVBnR0dTQTdTelRqdnVnUGFiOXkrZTNt?=
 =?utf-8?B?WW84TUpPb0gwYXlOUVJJdyt0dkIrWjAyNFlySGpZOXZMZUcxeFNJSUhtK1hh?=
 =?utf-8?B?b2kvY2lpM1gxL3QrUVRLeEdNc0J2TVZibmFEa2lFSVZJY3pyaVhrY2FOK2di?=
 =?utf-8?B?WDFLbTRZNlh4UXNiWmVNZklCdHdYUVJyMEtUeGQ1dGpNQ3hOV1hoQTdBeGYv?=
 =?utf-8?B?cG5TWVk3WTBhRDRPQVJHRkRiSkpIODVESGw4OTA1TGR5dHN2ZDhibTBKVnJo?=
 =?utf-8?B?M3A1LzE0b3I0Sk9mTzhaQ09FL1JOZHhFMFkydWZoYWZzQUVTY3RtUXRuMjJ1?=
 =?utf-8?B?dm1sNWxpdnFEY1JyekFYdy9JZGlZckpwajlGTkgrS0dFVFNvSmtZV0lJTWIy?=
 =?utf-8?B?SWh0M095VjJHZXhpRlFkcHlnaGJqTWUzNVhqSnNJVlVmVytOeS9KSzBKYlE5?=
 =?utf-8?B?ODhYdUJyWnduSThyUUFXUG5yeHhha2JQcTFIWUwxNFFlUVpxOElJMk9ncEJi?=
 =?utf-8?B?V3praHpJSFNObFZuOTZKODQ5V3JHQTdDcUtaYmxNekJpTUw3OU5UY0JkWjNZ?=
 =?utf-8?B?RkJtZVZuK0NSbjN1bjFyMGdSdk5ZT3FmTFVhMjNkSVhjcSt5eFpxZzUwNjA5?=
 =?utf-8?B?R0xZR3Fob0N4OUxpVFR6RTlJMHNOVU44aXp5UTdsSGp3SlNuTHlVL0hVRCtM?=
 =?utf-8?B?cjNIbTlybjQrRUttSyt5RjhwTkJsWm5BVndkdCsrMjUveEZBUEZnd2thZllw?=
 =?utf-8?B?b2JjN3lONi96bnhBN0VQc3dPcGV6ZjFMNUdHRlorcStkR01LeGdBMkJxSXFm?=
 =?utf-8?B?Q1lheCtqZE8wMmRaMDVqdjZITFg2NytDL3ZQbUZJYWszQmZyUUQrUytCenRu?=
 =?utf-8?B?bThObVo4RVNkQTNxWExpZ2U0THJ3K0ZDZGVveXVCdXRMb1RqTDg3WkdKNitp?=
 =?utf-8?B?WWYzQmtBYUYxTFdJZzVKb05jck5scTR4YktlVGV5dVJ0U3NrM2RaRmM1VS95?=
 =?utf-8?B?c3pFM3JkQ3oydElKWXFzdnN2K2hWcnBadzFRTVIvQTkzK2wzRVVvSDZRMFlp?=
 =?utf-8?B?d0R3aVUrL1hJSm8vYVhqQW11WllPR2s1bFRMSFFtblBITE9QdENUVUtaOHMr?=
 =?utf-8?B?Vi9rL1Z5V1M5UUtuaTJCTk5pY3Bsa25nL3IrcVFUcTJQOER1NHE5NEtXODZs?=
 =?utf-8?B?QWplMXI1V0I1eWR4b05meGo3cHhORkJOTFc2R3N1emRmOUYvK2tGaFF0d21q?=
 =?utf-8?B?OGlDZVgrMGZ1bk5qYXFCVm1vQ1N5ZXE3aC9mZkRQMmw1R2hNVEFSUGx1Wkdn?=
 =?utf-8?B?Q0FDcE1CZE1iUDZFYTB0WUcxVHlDTVoyc3Rwd3hVVUFVc3dmTDY1di94QlFH?=
 =?utf-8?B?YzRSUklyL2ZkTGUyc1BidFYwOHJrZ2R5c0JZNkZQRHRqNCt3NVIvNzNhQUpK?=
 =?utf-8?B?MWVnemJWd01rMmVtUHM3NUpYd3VCR2xsOUJzVSs4NER6dUhhZXBwaXMvZ3Fk?=
 =?utf-8?B?MFBYNW51LzFCVTlRdEJkUFBOMy9iRXhiN0txV2RXRXNkclZVTjNOVFhla3gv?=
 =?utf-8?B?OGdhcFZFblJTeVc5eThhU3lFMnFSSThkaEc1bkpheWFZRWFxVGJDaUZyeWlP?=
 =?utf-8?B?NC9Ya0dnTW5nMWVIbTV3UmFueU02dGlmc1dTQzhTWmRyRHlDbVYxdnIxcnQw?=
 =?utf-8?B?eit5c1Q3MzlxUndCMXRYc0ZLYzI4ZEhMMGhwQWdVbngrbjA4VUR6SUlGRjB6?=
 =?utf-8?B?Q3RhVVB3SURsVWpxWDNNcWlEc21zR21OZmdpakxyeEdKZ0RaY1pVTXVpNGFa?=
 =?utf-8?B?WDU1WFdjMk5CUWg3M050ODZoeEEzY21Eb0dmOHZJbDRDVnVmVDJqeDk3MVc3?=
 =?utf-8?B?dVNxTWIzUEtLU1IwQnpwQjhEcHM5aXhEYmp5clFXMWhPRTJCZTg4dzFuT2ox?=
 =?utf-8?B?U09uVWFvZVNWODNPNEVjNnNDWlhuV2YwTFVzWWFIaVVTMXJDelpmdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b324df-c2f9-46b8-0e09-08dedb687d91
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:36.3890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3omqu6CLJIWjmxA/OBNcAbyCnV4JncqN2T8Gly44u93Xml8d4sWT+whCk0+CX4xtZw0hfiVQ5hB2xIF3VkSyQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB9444

Address of pci_device_id cannot be relied on due to presence of dynamic ID
and driver_override. Use driver_data instead.

Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/char/agp/via-agp.c | 308 +++++++++++----------------------------------
 1 file changed, 72 insertions(+), 236 deletions(-)

diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
index 8b19a5d1a09b..ab3b73dd080a 100644
--- a/drivers/char/agp/via-agp.c
+++ b/drivers/char/agp/via-agp.c
@@ -221,204 +221,6 @@ static const struct agp_bridge_driver via_driver = {
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
-static struct agp_device_ids via_agp_device_ids[] =
-{
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_82C597_0,
-		.chipset_name	= "Apollo VP3",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_82C598_0,
-		.chipset_name	= "Apollo MVP3",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8501_0,
-		.chipset_name	= "Apollo MVP4",
-	},
-
-	/* VT8601 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8601_0,
-		.chipset_name	= "Apollo ProMedia/PLE133Ta",
-	},
-
-	/* VT82C693A / VT28C694T */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_82C691_0,
-		.chipset_name	= "Apollo Pro 133",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8371_0,
-		.chipset_name	= "KX133",
-	},
-
-	/* VT8633 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8633_0,
-		.chipset_name	= "Pro 266",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_XN266,
-		.chipset_name	= "Apollo Pro266",
-	},
-
-	/* VT8361 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8361,
-		.chipset_name	= "KLE133",
-	},
-
-	/* VT8365 / VT8362 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8363_0,
-		.chipset_name	= "Twister-K/KT133x/KM133",
-	},
-
-	/* VT8753A */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8753_0,
-		.chipset_name	= "P4X266",
-	},
-
-	/* VT8366 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8367_0,
-		.chipset_name	= "KT266/KY266x/KT333",
-	},
-
-	/* VT8633 (for CuMine/ Celeron) */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8653_0,
-		.chipset_name	= "Pro266T",
-	},
-
-	/* KM266 / PM266 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_XM266,
-		.chipset_name	= "PM266/KM266",
-	},
-
-	/* CLE266 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_862X_0,
-		.chipset_name	= "CLE266",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8377_0,
-		.chipset_name	= "KT400/KT400A/KT600",
-	},
-
-	/* VT8604 / VT8605 / VT8603
-	 * (Apollo Pro133A chipset with S3 Savage4) */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8605_0,
-		.chipset_name	= "ProSavage PM133/PL133/PN133"
-	},
-
-	/* P4M266x/P4N266 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8703_51_0,
-		.chipset_name	= "P4M266x/P4N266",
-	},
-
-	/* VT8754 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8754C_0,
-		.chipset_name	= "PT800",
-	},
-
-	/* P4X600 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8763_0,
-		.chipset_name	= "P4X600"
-	},
-
-	/* KM400 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8378_0,
-		.chipset_name	= "KM400/KM400A",
-	},
-
-	/* PT880 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_PT880,
-		.chipset_name	= "PT880",
-	},
-
-	/* PT880 Ultra */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_PT880ULTRA,
-		.chipset_name	= "PT880 Ultra",
-	},
-
-	/* PT890 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8783_0,
-		.chipset_name	= "PT890",
-	},
-
-	/* PM800/PN800/PM880/PN880 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_PX8X0_0,
-		.chipset_name	= "PM800/PN800/PM880/PN880",
-	},
-	/* KT880 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_3269_0,
-		.chipset_name	= "KT880",
-	},
-	/* KTxxx/Px8xx */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_83_87XX_1,
-		.chipset_name	= "VT83xx/VT87xx/KTxxx/Px8xx",
-	},
-	/* P4M800 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_3296_0,
-		.chipset_name	= "P4M800",
-	},
-	/* P4M800CE */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_P4M800CE,
-		.chipset_name	= "VT3314",
-	},
-	/* VT3324 / CX700 */
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_VT3324,
-		.chipset_name   = "CX700",
-	},
-	/* VT3336 - this is a chipset for AMD Athlon/K8 CPU. Due to K8's unique
-	 * architecture, the AGP resource and behavior are different from
-	 * the traditional AGP which resides only in chipset. AGP is used
-	 * by 3D driver which wasn't available for the VT3336 and VT3364
-	 * generation until now.  Unfortunately, by testing, VT3364 works
-	 * but VT3336 doesn't. - explanation from via, just leave this as
-	 * as a placeholder to avoid future patches adding it back in.
-	 */
-#if 0
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_VT3336,
-		.chipset_name   = "VT3336",
-	},
-#endif
-	/* P4M890 */
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_P4M890,
-		.chipset_name   = "P4M890",
-	},
-	/* P4M900 */
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_VT3364,
-		.chipset_name   = "P4M900",
-	},
-	{ }, /* dummy final entry, always present */
-};
-
 
 /*
  * VIA's AGP3 chipsets do magick to put the AGP bridge compliant
@@ -437,17 +239,14 @@ static void check_via_agp3 (struct agp_bridge_data *bridge)
 
 static int agp_via_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct agp_device_ids *devs = via_agp_device_ids;
 	struct agp_bridge_data *bridge;
-	int j = 0;
 	u8 cap_ptr;
 
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
 
-	j = ent - agp_via_pci_table;
-	printk (KERN_INFO PFX "Detected VIA %s chipset\n", devs[j].chipset_name);
+	dev_info(&pdev->dev, "Detected VIA %s chipset\n", (const char *)ent->driver_data);
 
 	bridge = agp_alloc_bridge();
 	if (!bridge)
@@ -501,9 +300,8 @@ static int agp_via_resume(struct device *dev)
 	return 0;
 }
 
-/* must be the same order as name table above */
 static const struct pci_device_id agp_via_pci_table[] = {
-#define ID(x) \
+#define ID(x, name) \
 	{						\
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),	\
 	.class_mask	= ~0,				\
@@ -511,39 +309,77 @@ static const struct pci_device_id agp_via_pci_table[] = {
 	.device		= x,				\
 	.subvendor	= PCI_ANY_ID,			\
 	.subdevice	= PCI_ANY_ID,			\
+	.driver_data	= (kernel_ulong_t)name,		\
 	}
-	ID(PCI_DEVICE_ID_VIA_82C597_0),
-	ID(PCI_DEVICE_ID_VIA_82C598_0),
-	ID(PCI_DEVICE_ID_VIA_8501_0),
-	ID(PCI_DEVICE_ID_VIA_8601_0),
-	ID(PCI_DEVICE_ID_VIA_82C691_0),
-	ID(PCI_DEVICE_ID_VIA_8371_0),
-	ID(PCI_DEVICE_ID_VIA_8633_0),
-	ID(PCI_DEVICE_ID_VIA_XN266),
-	ID(PCI_DEVICE_ID_VIA_8361),
-	ID(PCI_DEVICE_ID_VIA_8363_0),
-	ID(PCI_DEVICE_ID_VIA_8753_0),
-	ID(PCI_DEVICE_ID_VIA_8367_0),
-	ID(PCI_DEVICE_ID_VIA_8653_0),
-	ID(PCI_DEVICE_ID_VIA_XM266),
-	ID(PCI_DEVICE_ID_VIA_862X_0),
-	ID(PCI_DEVICE_ID_VIA_8377_0),
-	ID(PCI_DEVICE_ID_VIA_8605_0),
-	ID(PCI_DEVICE_ID_VIA_8703_51_0),
-	ID(PCI_DEVICE_ID_VIA_8754C_0),
-	ID(PCI_DEVICE_ID_VIA_8763_0),
-	ID(PCI_DEVICE_ID_VIA_8378_0),
-	ID(PCI_DEVICE_ID_VIA_PT880),
-	ID(PCI_DEVICE_ID_VIA_PT880ULTRA),
-	ID(PCI_DEVICE_ID_VIA_8783_0),
-	ID(PCI_DEVICE_ID_VIA_PX8X0_0),
-	ID(PCI_DEVICE_ID_VIA_3269_0),
-	ID(PCI_DEVICE_ID_VIA_83_87XX_1),
-	ID(PCI_DEVICE_ID_VIA_3296_0),
-	ID(PCI_DEVICE_ID_VIA_P4M800CE),
-	ID(PCI_DEVICE_ID_VIA_VT3324),
-	ID(PCI_DEVICE_ID_VIA_P4M890),
-	ID(PCI_DEVICE_ID_VIA_VT3364),
+	ID(PCI_DEVICE_ID_VIA_82C597_0, "Apollo VP3"),
+	ID(PCI_DEVICE_ID_VIA_82C598_0, "Apollo MVP3"),
+	ID(PCI_DEVICE_ID_VIA_8501_0, "Apollo MVP4"),
+	/* VT8601 */
+	ID(PCI_DEVICE_ID_VIA_8601_0, "Apollo ProMedia/PLE133Ta"),
+	/* VT82C693A / VT28C694T */
+	ID(PCI_DEVICE_ID_VIA_82C691_0, "Apollo Pro 133"),
+	ID(PCI_DEVICE_ID_VIA_8371_0, "KX133"),
+	/* VT8633 */
+	ID(PCI_DEVICE_ID_VIA_8633_0, "Pro 266"),
+	ID(PCI_DEVICE_ID_VIA_XN266, "Apollo Pro266"),
+	/* VT8361 */
+	ID(PCI_DEVICE_ID_VIA_8361, "KLE133"),
+	/* VT8365 / VT8362 */
+	ID(PCI_DEVICE_ID_VIA_8363_0, "Twister-K/KT133x/KM133"),
+	/* VT8753A */
+	ID(PCI_DEVICE_ID_VIA_8753_0, "P4X266"),
+	/* VT8366 */
+	ID(PCI_DEVICE_ID_VIA_8367_0, "KT266/KY266x/KT333"),
+	/* VT8633 (for CuMine/ Celeron) */
+	ID(PCI_DEVICE_ID_VIA_8653_0, "Pro266T"),
+	/* KM266 / PM266 */
+	ID(PCI_DEVICE_ID_VIA_XM266, "PM266/KM266"),
+	/* CLE266 */
+	ID(PCI_DEVICE_ID_VIA_862X_0, "CLE266"),
+	ID(PCI_DEVICE_ID_VIA_8377_0, "KT400/KT400A/KT600"),
+	/* VT8604 / VT8605 / VT8603 (Apollo Pro133A chipset with S3 Savage4) */
+	ID(PCI_DEVICE_ID_VIA_8605_0, "ProSavage PM133/PL133/PN133"),
+	/* P4M266x/P4N266 */
+	ID(PCI_DEVICE_ID_VIA_8703_51_0, "P4M266x/P4N266"),
+	/* VT8754 */
+	ID(PCI_DEVICE_ID_VIA_8754C_0, "PT800"),
+	/* P4X600 */
+	ID(PCI_DEVICE_ID_VIA_8763_0, "P4X600"),
+	/* KM400 */
+	ID(PCI_DEVICE_ID_VIA_8378_0, "KM400/KM400A"),
+	/* PT880 */
+	ID(PCI_DEVICE_ID_VIA_PT880, "PT880"),
+	/* PT880 Ultra */
+	ID(PCI_DEVICE_ID_VIA_PT880ULTRA, "PT880 Ultra"),
+	/* PT890 */
+	ID(PCI_DEVICE_ID_VIA_8783_0, "PT890"),
+	/* PM800/PN800/PM880/PN880 */
+	ID(PCI_DEVICE_ID_VIA_PX8X0_0, "PM800/PN800/PM880/PN880"),
+	/* KT880 */
+	ID(PCI_DEVICE_ID_VIA_3269_0, "KT880"),
+	/* KTxxx/Px8xx */
+	ID(PCI_DEVICE_ID_VIA_83_87XX_1, "VT83xx/VT87xx/KTxxx/Px8xx"),
+	/* P4M800 */
+	ID(PCI_DEVICE_ID_VIA_3296_0, "P4M800"),
+	/* P4M800CE */
+	ID(PCI_DEVICE_ID_VIA_P4M800CE, "VT3314"),
+	/* VT3324 / CX700 */
+	ID(PCI_DEVICE_ID_VIA_VT3324, "CX700"),
+	/* VT3336 - this is a chipset for AMD Athlon/K8 CPU. Due to K8's unique
+	 * architecture, the AGP resource and behavior are different from
+	 * the traditional AGP which resides only in chipset. AGP is used
+	 * by 3D driver which wasn't available for the VT3336 and VT3364
+	 * generation until now.  Unfortunately, by testing, VT3364 works
+	 * but VT3336 doesn't. - explanation from via, just leave this as
+	 * a placeholder to avoid future patches adding it back in.
+	 */
+#if 0
+	ID(PCI_DEVICE_ID_VIA_VT3336, "VT3336"),
+#endif
+	/* P4M890 */
+	ID(PCI_DEVICE_ID_VIA_P4M890, "P4M890"),
+	/* P4M900 */
+	ID(PCI_DEVICE_ID_VIA_VT3364, "P4M900"),
 	{ }
 };
 

-- 
2.54.0

