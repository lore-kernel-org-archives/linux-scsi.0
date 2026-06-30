Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022092.outbound.protection.outlook.com [52.101.101.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD8831F987;
	Tue, 30 Jun 2026 11:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817771; cv=fail; b=LsU7AsBFjwCfA1+6eEiQFgmfEk/4kas40eLPz9DE9/9ZAQS0Xu5fgSPANT1kaDdQdOzK4ft7eZdfV7vzai1lluM04RbstYr3leEta9O82wGJPbdrPBPPryx6erOzCAH5zhCCmv4F4ZmlzIGVTSwwP6kP0nkikkXyLg7qGmA6Pzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817771; c=relaxed/simple;
	bh=l4CXLFt6tecKyrw1r68avqNK31x2gvQF1ZUdysw5CjM=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=fMqcPdnAOamDy4gmQ8X4MwQh0wpQMTUXcMu5TOSPtNV0Axhe4msRoqBXnLPst3ltWanrloblCa9U1zClnW7vkFVINWzHK+DOLBTQY7IX6VHCCKF2x7h3qIXusrTLiQvRbMM4nYCfQHqj3EsDgNqX1dPcsdnnxEfYzNBtR0x0420=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=MUMoEAV8; arc=fail smtp.client-ip=52.101.101.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="MUMoEAV8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DJPMNODuk0OWTmWSbVbotaINscjqaqhNtDdlrOb8RxOLPhyX8ZqmQPszWyPLcuvAZ0hZ8z9FrFCITvurC4i2HU7prPzCa09shfzb3bQHqfkyONCHEkQ+kKzKJ4T2OtpEiv2MXHJl3SVXMisyELYefGkhSG1FP92Lypbgr1NJUNxBMby/ksIF7/fHJyqg2TwdmPsAuvRs5ztAq8GmJJQLNqwT/yeufDqFvvlhoeAyLTJUE7IAmirW7PPwrDvTBTQ3qbdZO0LygzckN7VAEreTh9JHVMYT9NzBcc6Q4fgBO7pqSnHWQ63rV1BNb4TGVdLAZm4SFxJMk/VLZWOQuv0LzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mqar+vzlKueuHBQCdrGSFeRugKmKY9oRZr7pBozKqdo=;
 b=bGUmbDXqh+LFuHsPcriydRhwn4YXX5XjbTy82i0cEqOl5aMWwo78PP7/I+0oE6svP75PFej9MmtMIt0zZRGK6rhEzDqgIKFAl4eG+iZfHKeCGBvTxcT0YYYakNRuSg6vf3Kno2p6wprh+qJD6FVthU2GnT9WlFfG8DMKRw52oqyhz9K2f4VXw3m9Nm/mBYXFjQXzbb1qEKM2Y72oxco9bP/y3+SZZ1GXnxg6UV182p4WW43XxTKbmnxYHH0nZsUG/rZeYEUTrjs9DAcqPll1nhysiaM6MSvRJ/hxMZ+O6L2m33T7l8fPJV0Wy8rBzgmF8oppGOYnES0uk2kHVxguWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mqar+vzlKueuHBQCdrGSFeRugKmKY9oRZr7pBozKqdo=;
 b=MUMoEAV8boepzlGi8vP1kljrMza6V86AAe3fYBx03g6LlhVN8jObaJkb7yfSFxgiRb8N9IG6m2nKyaCdJpBUAXlhoPPR3d1fEGvBBjtNc8JktUKlEbL0NFauQR9XsyT4B25W67G/slNLxAjbJY+gr+Q/gKbQrcuUvzkogVpdYvg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CW1P265MB7689.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:219::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 11:09:26 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 11:09:26 +0000
From: Gary Guo <gary@garyguo.net>
Date: Tue, 30 Jun 2026 12:09:03 +0100
Subject: [PATCH v2 3/7] ipack: tpci200: don't keep pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-pci_id_fix-v2-3-b834a98c0af2@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782817763; l=1259;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=l4CXLFt6tecKyrw1r68avqNK31x2gvQF1ZUdysw5CjM=;
 b=e/rsPbWy/JsdqLfFQ5caBhbrIMHGsss7jMcTpc47bUn4JnZhgpQs9ussWG40ntwt7DkBK9Db8
 14b8Xch7MeyDLPzGgGzrcBrTCc8iLtViiuT4GLomzfZOmo2MEkNQ5YJ
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
X-MS-Office365-Filtering-Correlation-Id: e19feaa5-c255-45be-20fb-08ded6980b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|23010399003|22082099003|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	wg/UCgGbc7KTE47gfHOW2ZBnsYgWOhfMlxCXMEpCTcPrB8hi2b3JJFQQhBv3a7/ebw/ngg2uwPDzlmt941PiIVJyyjqoowxXo8iuyAdnilGf0jC/Ep4TFQXbOzDkJlcA0NLrXXa9gMUTd3gq6ol17wJMLqEuGMzS5SaNapSPEzDFz+BSrF6bKZQHfEK0ZWuQM+4MAPqhUVLLHdSfEb1wE0EpVWjaInNvjo+YfmcW7yHFjI+M3POeEf8AlQAGmhZ6TATkW4U4l+ZmqhwcjQa6QlLNS3HMtmpMq4MBtskcXkk4DEVO4SBWDFJQGevW3W3TE2C5lAPkXKOJ3PabtvPsUZq6ZgylsXZEblz3XFpQS9W9QB6qNZ59b1wio9PQgjsGQgnIO0iSlo7lo3fiYGVWjee3B3LYU3/4O+8resvT28IJkdhZjOtauw6WFt1ryrm9VrOojz0dx0+74aXzj632rjEdivsiK7PlYlDoJYF4qP66H8BWIPy3JB23Qa/gxRIXyHLZiPi/9pwd7H7z3WWGhr+R3QFLYLNwGQOURbX6aVGuY0eme5wCVcDyw3q8gzB+la1Tdy8R+xE7nWpp8d9MUFLmKhOX/A3x6oAgnYMqHhSCmYiFXQMh+0rYHPtJuKF6M28tcmCQmQk/QZIKVf4SOT9hSvPhJivGfl+tf1SYxYFA98EOLaaQ/I9qQJcoYy5mwGwilD5cDYYE/PF1cYCcLA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(23010399003)(22082099003)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmJjclAvdjgvREFhYjdTcmk3WURreXJtdS9oYlJOUE1BOUdsbEs5R0RtcUFk?=
 =?utf-8?B?RzZhT1Q4bXRMUytzZWcrc05lNHlwS0ZvSS81a0dqRGxpcjlSc09CeGtwQU1C?=
 =?utf-8?B?MndKRnJzdjhkc2xkYmFHek5YOWp5NDRBZ2hkNzlrTy9XV3R2Q0hPNUluNFlM?=
 =?utf-8?B?S0hwVmN4Wmw3NjlSSFppQ2praUNqYmpRZUJ4RGVDbUlMK0d0ZC9sMkVSRkkr?=
 =?utf-8?B?K1NkTkhHQ2lOOUxtVnhMdUhzVm4wYTg1d1VUZS8zMzVsTlNIZ2NYbzBBSklF?=
 =?utf-8?B?Y3FNZHBGb2VmdjRoUFdEZVo5NDhZWHB0YjlXdnJMam9rYXJJZnkrZVh0MTVV?=
 =?utf-8?B?UVdUKy9kRGRqdTZUcm9XQUJPVHZ4ZDU5Z1NnMG9YZEhoVnVGb2toK0hJT09K?=
 =?utf-8?B?MWJvUWgxQVRiZ1NWWGZPSVhyc3VrdjNSVHlvM0xvUW5rUE5ZQjEyc3dDMGxN?=
 =?utf-8?B?Y0VJTkpURWxVOTRSQ2pQK2h3TUJSa3ZWRkJWYVlBK1J0eGErcmhlbHBKVzhz?=
 =?utf-8?B?RTdWbFhRMDdiY3YwbURMcUQ0QmZLUFJPQ3RSc05hMGdJcTd5Ni9MeHRQU1dt?=
 =?utf-8?B?aHFVeUJrN291cnZwL3RkdnhGNTV0NldyTGJnMXJaTVdtZ1g2ZUVKVjZHbGVR?=
 =?utf-8?B?OWRJV2trbDcyQ3NvZk45NXk0QklIamp0RmdiRmpjdWNTT1FiTTBiaWUzZ2pF?=
 =?utf-8?B?UzRkL0l4RnErS0llKzNQdVJjeWlnU2hLL2lFT3ZjOCtEbEJWUkYydmFzYmV6?=
 =?utf-8?B?dWhwUkEraDhyQzRNUTl2bHJIR3VxS1dDbHE1SW1McnlhclBheEk0RWlJMGV5?=
 =?utf-8?B?dFJ3bXloMW5VK0U2M2RMSWR5d0d1V2NZYnZkczZKaEFaWjlvMUU5WVVjZ244?=
 =?utf-8?B?d3FLTmxsTEVlYzZzTlRwTHJveW9jUXNiN0Y2bkZOcUdGMmlhNkhEV0lYR1NW?=
 =?utf-8?B?dDZWYlhLMzJTZUNqOXlTMGN0VitpTGdOZ2JOZWNxcEpPR2xScVhpSmlKY1o2?=
 =?utf-8?B?L0MwNzRFS1JvK3k4TmZpRFE5M21LVjgrbHh0OUtyeW4ydEp3YjM0ZSt0ME1x?=
 =?utf-8?B?T3NRbmE2SFRCK3VJZ2U4Mis1U3d0OHhYVSt0cElJSlpzMG4xNDRBSzBLNEJD?=
 =?utf-8?B?YTVZczRuc0dib1FyL2dtOGpiOGNhMFVNS2hPYUVFM2RmZzJkcU4rWVhMOE5l?=
 =?utf-8?B?dVYrTXFpM0xUUzBhMjBpN1ZFR0FQRXRTWjVEVFNuVzM4NFMyVzIvMFdWMzFn?=
 =?utf-8?B?RVhGNEdUeUxQUkwzNVNUZzg1aVRGdStsTHpGM24vUGJMNnZyOFVVYzJkQXpo?=
 =?utf-8?B?ZlF2VE9HTVlncG9BS29yakovKzFPbG9RejQ2UjMyZ0VGQkh2K3lkbjNiVmRx?=
 =?utf-8?B?MWVrVWp4MWYvYkVVN0VMa01UUmJkZm9URWJPZ2IyVlBOazFsd2swRWpOSTRu?=
 =?utf-8?B?Zzl0NEVTZndHUjdGWm1HQTVxUFJUbWdGcDJVZ1N3R3NkLzBObzVVU3E2M3F4?=
 =?utf-8?B?ZjdXMGlFdnBiaEw5STN5MUY0YjR2RDZTWURYUEU1ZW9XRGozaHRwSFpXdjY0?=
 =?utf-8?B?WjdWTkpRSHlYcHphZ3M0aEZvZ2ZkeWh6dkRBMHU5MithTE85elMzbFN3a0dh?=
 =?utf-8?B?djFRcnEyQnVSeW44YlVTYUMzcHV4VDZ4V1pvU2ZaRVRqOVFLK3ZnS1B1TElw?=
 =?utf-8?B?MjgrU1NhL25GN0x5Y0V3SVdpMks1UVJEOW9hcVVxcjFTVXRkZmtuOEhaQXBK?=
 =?utf-8?B?YzBlOVJlbUtmMHozcUpKZUFydTY0VG5WUVd0WjU0enJBK2ZFMU83NFVFT21h?=
 =?utf-8?B?WDdmNzJhR3ROR1l3anBrNmNPanE3NmZ0SllaYzVqTG9SQzlJZTA5Z2dvOFRi?=
 =?utf-8?B?R3ArcUxNOGs4NWxRMjBOUGI5a242L3VZbG1XSDFEdmViQjdWWGJ6VHJxTjFJ?=
 =?utf-8?B?cXVRdTJ0NWVXQTFOSk44WU50T1RkU3htS1FYS1JNcUZsMkFaclZwNG10SGN3?=
 =?utf-8?B?WVVLcDcvdFN6aUpGNlpEcFJjZkIwL1JnU3lBOUQ3ekc0NGFYQVQ5ejhvM29Z?=
 =?utf-8?B?MnhYNUdZQUpXSlM3RXcvUXZyaFdSc3ZJczc0M1B5OHVvOEVXYWNCQ1ZrU1Zv?=
 =?utf-8?B?MlRySVNYOWdvRm5tUXN1TWtLQ0s5MDRWT1NSTExlWU1ablJHc0lpV3lHNkFY?=
 =?utf-8?B?WWdSMVpMVkZTVjZFM2lscXRRSjUzR3lSVEVnRU95TStLRzlMcmx0UXlNZ3Bw?=
 =?utf-8?B?YTU0T2dncGZzR3lLUkNzU3A5d0tJdndlWTl5a0ZsaC9SUUlwUDNhR1JFU3RE?=
 =?utf-8?B?K2JrQ0d5YThoTjVVaXc4YzN0bzYybVhqUC9SNmEyUlc5UTBmWVJvdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: e19feaa5-c255-45be-20fb-08ded6980b69
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 11:09:24.8648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSxfrrf5BFnXsLSENwTWDC3rF9TLiYhSuXphpIzGakaxjD9afUyBkweG+zv8lw7pdztwOLeDeEvRExXq5rSVJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB7689

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. This stored ID is unused so remove it.

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

