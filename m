Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022092.outbound.protection.outlook.com [52.101.101.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1529B3EFFCD;
	Tue, 30 Jun 2026 11:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817773; cv=fail; b=NCAHs1PqkaXJH8I2BgGqmJH7TMtRCU8OnsnZUfCrnRMB1PB4bhZsZ09/zMrPprIsopKx7pPauhqzvuCWCcYnGDwHX2zbYdblzDUeMl2Jb9zrtkYsTzC6GgY6K609VSjv1TpNegl6Q7L61eJ5y+X4rKHuj8MxHs0kV11a6HUzgfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817773; c=relaxed/simple;
	bh=URVlxCKrNXlskLSRwIpElO7/qHxGKe3hyqpRwCqwJTg=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=G5fWuPb7CSW9WhqpsziCxGoaMzTiO5Yb+FstFkbv67p1fjsONNuo1v88aqO5Skh1n/4N76GB+I5IQ78fPo8qctEmyXGhRrI3Y7q1orddyMYjGu4wAdLpM1lG0c1C1W6faau7UUIINyak79HGymj0UUyDmypdqMb+jXGXF+So8jY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=I15L6Che; arc=fail smtp.client-ip=52.101.101.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="I15L6Che"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uT1s5QkBR4b6I8u+/It07hSZ+/pKjGs325UL9mME9bFMgcsOx6KPKgQrhKZtzzMouSip/4QgndLbvOwsVbG92iEuaaHaJbgiM2GFIAQvE7Fh/9ET8ztGP+7ROdseTgs3eeHyausGzWhTbOL26DDfzLHwjo53fCuVwxKNIzqK+b4ST5BeYUYwyatYB/RG65UY0/eVlXzZA+1b4kMVRXl7O2MypL1gADoXNGhLwO5J32ylSPB4+Pigav/KUBYigQ/IC2/rCZIAlrTyrSZfN/Ssd3bgUqtX1DzoThKuMo9jN4XD/ZsM+gba/+4CtVtBWP7jJJc7qYEchXSzxjfEA7CGig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MyBJ2W49i5U8t58o716FlfGVJhrj2538HPyLnwy/b8=;
 b=mIRYSVsFj0haFLgehfxH7Z787WIeM+N88UEBXhQ03ENBFsXtUpnJC90oZTD9gNa1t2IeH+/v59K5ms705SKibZlIkBYrsh9eiow5KsO/IyvMzhnQ4yx//uFfHuNXF9hAhLFl39I3midWJx2Vh/gyFElO9uhfLNANXaNrM3UxxyyCf5ww7Pjth4yYm9vrk6Hz4I9wNUfXTWcqZsLNaWOjBPMTmRylJeL7j+KQQaQ/zog20nIoy2hP4fvOYls5PuEw+jHz/7eug8s+9JjuXECU9QWFLySkSsDgUM1bhYMBY60xoGYlrfwbGlxz2jsO8S+khbuHNxkfnc8axLUhUdKwRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MyBJ2W49i5U8t58o716FlfGVJhrj2538HPyLnwy/b8=;
 b=I15L6Che26n0a4zgAAmXa92NnFKcqXasqfejqYmHTX7f54ugDUCvy7evlhPfmpMnpmJBsSGEi0uiScQ+ZYB3uxmBqPOnJqXHEdZq2XmFTyewWmoUFJYvFGVTbQ7MvWoebr52rtfJJtBlzSEef4MYHI+mEceSM/Cb2c5u4LvMtcc=
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
Date: Tue, 30 Jun 2026 12:09:02 +0100
Subject: [PATCH v2 2/7] nsp32: don't keep pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-pci_id_fix-v2-2-b834a98c0af2@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782817763; l=2099;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=URVlxCKrNXlskLSRwIpElO7/qHxGKe3hyqpRwCqwJTg=;
 b=4EcNAzrflKrP+GRQixnVrGMVgfvcQPTUpvpc7l6mQ6BwtCLAzCumAVXj0OY1YlfMlqP1Utccx
 AAFV+g5IYjjBDaeKNEi3WZIjYq8rAGaIV5N6eMFwAsJXwVKrobWqPYF
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
X-MS-Office365-Filtering-Correlation-Id: dd827a6c-c251-4447-a382-08ded6980b26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|23010399003|22082099003|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	usfzHoep3zsuTKldNwRIYq30PtDoWZfeY8wum0ixqUTFgzoZDCbbYk5TBe3LM+HJEUri5QD69o57+2wb0j5FaxFc+eL4IXAI4ksnoMdBlpkOgWVaZmDIOFH8ScfDCbZf07q56LSJTTNU1n4jwOx3B8gxPDOurtOcttdIBxJt12gsO1hOk0QKU5Z1hr73jcV3e7j3VLACDLEj8ev6vIUJv6vQXTE1rbLTTUUlVNmRnpvLA8cU3dD/26+84vsrDO0uU/xrOi/W2r8xq3wDCPiX5Mw4OyslZFkewdjyW2h72eXnG0YTTgj/2bbWqnRHdQmGJZG4Ny/No53tLtHgT3eI0wpgmBl874GVeIf4u+un61uDvhwXsKcjjvSv/FOu38R0ysfq5ReYTfqGE1MOd5q5WT6FCdSWQGHg5plSld0jFPJ5zUG/+SJvieR6d21cWCkSemWKOxYizffFpTQ+lwxh6GHaHg9eCVWTAX+uQTgk9SzOiInve9Q6ZpPWXUexl6JL8s8AOMd6el4nIfWc+GUN46IOFeWgsDZvzfoUIXC1yGtCts+pHq6kdLfR/Xmc3ExKconI+9oygXn7SZ9RBAtCXPh9QpZTpM+uTyYoeS9AuHrn16ET/lSUQ+L+YwoR39AmE5ChPNTp70JhkQ0DYJm53KiYLxb0dlUoU6hFmZ2ZQE2UbkvOaoUZvAQe51wq2N7lGEUZFM3D5lIATBg8F+e1vg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(23010399003)(22082099003)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXRhcUFjdlFYODUvMnkydmlsQmwxR1VsZjFoZ1pFTk04ZkEyT1p0YlY3VTRh?=
 =?utf-8?B?emh3eEJDbURtdjRtQ1pVK2hwaW4zTjlmZ25kYzdBNzJHMUE0aWRMcGdXbUxr?=
 =?utf-8?B?NjZyK0txdms0K1lTbGN2dFNtSW1VMlRkc0VzQ25zTkpza3ovYWpwNGF6WWRt?=
 =?utf-8?B?MWY4WlJDRlozamRwTSt4NTFud1BCSVhVTXpKODhBMmFpYXBuc2FvYmdtcWly?=
 =?utf-8?B?cWg1YVY2LzBMNHJNNFp3ZVBEMTc2RU1admR3MDE0N1dyM0F5RWpJRkszZHVD?=
 =?utf-8?B?VGV4bUVWTkd3bzZ1UHhXMk8wWnQxaWhmdEd4dE5QajVBaDRYQ2Nkd3FERzV4?=
 =?utf-8?B?cnRuSUgvTEJaM2lHTXJ0b3pXV3o4L0srOXZ1WUxETWI0emtleExGR01TbFNQ?=
 =?utf-8?B?L3h3b0JTQ3N3VjlXb3gwNVRUMjY3ZW5QUVZnUzczSGpMNUpiTGFkTlVUbjE3?=
 =?utf-8?B?cmNHeHdkVFN2M0ZOZHVjQTVQV01NOEMrV2xCZWg5OFc2RWc5OGJaRnJ4cGcr?=
 =?utf-8?B?OWo3RDdsOCtObGlHREJDUlhib1J3UUMramp6b284QWU3UUh5NVlSajJZRnM5?=
 =?utf-8?B?QlE0WE5tbTJhQnRtWkNMRmI2SkgyaXFTdmpBOVR1M3M3dTY5NWdxcStzNmM0?=
 =?utf-8?B?cnJubjlaTWhrTmk4SEZOZ0NHUEtGazJ1bXhFSXlSUlJBTWkyVFI0c0xDMWx0?=
 =?utf-8?B?WDR5TFgvNHlLUmlZeUhCSmhnVS9YNGYyWStLZGdOUE1UUSs4eTN2Sjl6YThq?=
 =?utf-8?B?RWZ1MGswcjZRVWUxZEVXd2hCbUJSb0ZWdWtNdjRDaTZUczdSeDBUZ0RJOW1n?=
 =?utf-8?B?R0ZqeWh3VSs5Qmh5WUZHT0JCd1lKam5jMGl1MEpxNVo0RDhRZXhGbnNwclhN?=
 =?utf-8?B?RlF0Q2NNOU5ldW8wSmRMU2dKSGNERnN6ZXFJRDdmbmZzSnNrOWRSeklvaW8v?=
 =?utf-8?B?RWRqVkE2Qk0xRmZoQXh0cEh4S1hjd0lEdzcxK0UxZFpyNE04Kzd5S2U0VW9Z?=
 =?utf-8?B?R245M1ZabjRIbGt0K242L0xkOHJJQ2xuNmw3d0dreFJmWHNzYjdzM0RiWktz?=
 =?utf-8?B?ZHJNWU03dmNvSHRIVVI4Z3pmbm8xTGZ0ODNnWXZqTmdpV3Y0Nk1QQkVpQm93?=
 =?utf-8?B?cnRweEFGNXpHdVRiUEc5NkVMUE5Rbm5qeXBwc3hONzR3RDVSN2J2RlJOekt1?=
 =?utf-8?B?aHZZczRzRVA4cXhsMHV4enZuTzZzTUcxZCtFNDJQOG96YURpQ2pGV25wbWVH?=
 =?utf-8?B?dmM2R1BpWFlhWFd4MmRaMFNwT2JZK2d4S0YrZGd6Vm9mdUJVa2JkVmorT0lz?=
 =?utf-8?B?dFdHQmoxZ0lZTGxqeUtkZ3dvRHlTZnZRajBTWFFmRUxudDcrVlNucEVEQnFX?=
 =?utf-8?B?Q2pGWXZYajduTHVlSkNwTlhUMk52SFU0ckRCZHFBTUdNdzlxRlBrVW5kdmNX?=
 =?utf-8?B?QXlnTWJqenpaRmdJWUJVS0JzUzRyUkNuTzdIbjNlakxtTXZWRjdGN0h3K3d1?=
 =?utf-8?B?a0ExRkF3Q3hGNHJzYlRYMGR1ZUgzVnVvV0JDYjJGNW42L005cjhBQWpwTkFw?=
 =?utf-8?B?WmJ1VUdoZk15bVVwRWhhOWFlelJTQ1ZBZjlUQlMrbHMxamo1d3dJTDJPRllj?=
 =?utf-8?B?eCt2M3U5ZzFGNGgycWs0RmRvdUVGS3JDRm5DSUNYcFkySnBQWFZySngrUE5x?=
 =?utf-8?B?eDRIamtnYzl3dG9WOXN4b29oMndic3NXbW1HR1dNU2ZBL3lBVE1FN0E5RWRG?=
 =?utf-8?B?Z05ZcXRIT0czMTFQSytKYVFDVm85NHI5VHlUWFpyZldzK1FSYTNGOVZPLzJp?=
 =?utf-8?B?c0hHSW9hRmJUMVFDMGU3ZS9KUC9UM1ZvSjBReFBxdkxLcnptdWQ2VHlucmxF?=
 =?utf-8?B?S2MrRXFPY1ZBSSt1OVZRdm44K25QYzdyV3dpWEdJajh6RlBKZERTTjFDN0tN?=
 =?utf-8?B?MzhFV2VYVDV5b2VIeUFjYmpJbDMwdE9QWHNNemJYUzIvbW9PVkJkSFZySWNp?=
 =?utf-8?B?OVhuUkt2WVhVWkQ2SEpzQXB1Z3NtTEw2bGZORXk5SzZUSE5iUmtHUGEzZmNZ?=
 =?utf-8?B?TW1FajJXbklDYzhqUWRlSnB0TllwNlRxVXIyN2N1YW5TeERxalFaTGJTam1s?=
 =?utf-8?B?b1AyNVJGNTJGZjg0ZWkrZGpOUEJCaEVpV3ZDcGRjcWR1bGJjYWt3cXBvWlVU?=
 =?utf-8?B?SzVoZ0xTcEZXWEFRZTJYcXlPNVFIQjYxN0NuWTBtMTYrWkF6QW9Fd1Q3OFRH?=
 =?utf-8?B?WFBRVTFvWlh2YUdqc2NVZmt2Q08wWmNuYjd3bmR1YXU0QmJEcklBZzJZY3lH?=
 =?utf-8?B?TlBOWFNWcVNsYXlVdTFuUEtaclhaRTA5R2pKZzd4N3BiS0Y1YlJSUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: dd827a6c-c251-4447-a382-08ded6980b26
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 11:09:24.4348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pP7q1Z5FULLwI2A6byYtBPUURuAxu6+J6RyhdRuieiMRR+2HYTLuBLy5kh5JZ/bIyKK4dfty6gzVN3WVCQX1wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB7689

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/scsi/nsp32.c | 8 ++++----
 drivers/scsi/nsp32.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index e893d5677241..9c9281222a0a 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1470,7 +1470,7 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
 		   (nsp32_read2(base, INDEX_REG) >> 8) & 0xff);
 
 	mode_reg = nsp32_index_read1(base, CHIP_MODE);
-	model    = data->pci_devid->driver_data;
+	model    = data->model;
 
 #ifdef CONFIG_PM
 	seq_printf(m, "Power Management:      %s\n",
@@ -2907,8 +2907,8 @@ static int nsp32_eh_host_reset(struct scsi_cmnd *SCpnt)
  */
 static int nsp32_getprom_param(nsp32_hw_data *data)
 {
-	int vendor = data->pci_devid->vendor;
-	int device = data->pci_devid->device;
+	int vendor = data->Pci->vendor;
+	int device = data->Pci->device;
 	int ret, i;
 	int __maybe_unused val;
 
@@ -3340,7 +3340,7 @@ static int nsp32_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	data->Pci	  = pdev;
-	data->pci_devid   = id;
+	data->model       = id->driver_data;
 	data->IrqNumber   = pdev->irq;
 	data->BaseAddress = pci_resource_start(pdev, 0);
 	data->NumAddress  = pci_resource_len  (pdev, 0);
diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
index 924889f8bd37..9e65771cb592 100644
--- a/drivers/scsi/nsp32.h
+++ b/drivers/scsi/nsp32.h
@@ -564,10 +564,10 @@ typedef struct _nsp32_hw_data {
 
 	struct scsi_cmnd *CurrentSC;
 
-	struct pci_dev             *Pci;
-	const struct pci_device_id *pci_devid;
-	struct Scsi_Host           *Host;
-	spinlock_t                  Lock;
+	struct pci_dev    *Pci;
+	int                model;
+	struct Scsi_Host  *Host;
+	spinlock_t         Lock;
 
 	char info_str[100];
 

-- 
2.54.0

