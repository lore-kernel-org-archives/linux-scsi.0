Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022093.outbound.protection.outlook.com [52.101.101.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48F537A49D;
	Mon,  6 Jul 2026 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347116; cv=fail; b=gWdgPv/zsGxJ2QEh8VtdkRDJ2VefdEgtJLZXn9VVvTj77tAmFjDa0hhKTlLTETytoE9sXb5BYhoROL8g0ktpMsb+8xqMvQ1KrxwfRKBglV6LFVY0sVaYaYX9K7WsN+0keWuucs7Cszy68sboSvK4iQIujal2e9vqZSXIIvQ1dSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347116; c=relaxed/simple;
	bh=8gJVnailyzMYXVEeFt/Vs6x7yjYC1eVNKx3NdE39Fcg=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=eEI6vH0JSRwWnKP3F7uQe/kQRMM+MgA4baeiX/VYKCnVpnhfw6ByhtAfOX3gCdZ0k0G9GdkdzlX1Ui/bAZjLAKvsR8zOUn0JQSnUe9MTnujii9VRs1Vpunw+01zbJfMAHPZgNueQd2X5wStmx3fFUR3pos1KliDIRkBFDtW33jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=h80EzHfX; arc=fail smtp.client-ip=52.101.101.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="h80EzHfX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XYySDryJ/buv9mQmv4xEDd52qMCeZHzJcuBorl2UgwaIw1DYNGGDSpZsZ48cNDSujZRwDgF+WLGu2HdlwlEaa/xehS/J5Q9c0zyOEIi6+pSQnLKJ+7VYRAWlb7t9lmwJR4wZiiNoaXOaLCBUwZcpEYCE5tcvQEbiIJHANH2sxhyGy9LU3b9Dlwmwzn4dZ7y1PwdGVD6juizuXECRZziV2Oirp3miRju9RB+I0bQu9WrOGaXzAM7eyQRDKA3YdDvi+JrfztUmAE9n+ifJqwAhkakuyfH3lEiYvfhdGoSxQFt1kYtoNzc8UeWKDoPwWWTB4Z2O1z+vUQVGjMuA9/is0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xq9AjxX3EhxMdox1zaGtdiqE4DTflnHv8h5VPtjrvBQ=;
 b=V1hYkrmzaW1mwjinE1H1YW0Dp67Dh54NUGjvban8PdWAyPpZ9i2yeh+sBfiXx5+1V7U9BQaQGp1Na/vqLMYCVsOZdTPcQaEvDacJ0AHMCP8DzT9gCk/k7WfT2zNjNZ9R1+DmEDDPcchfPOL1c+bchSZ2hPb08S8D7M7hD81Tiryf4gpFr6ZDK9M93h7NWxApiMlArrzSmZ8G+m10UTFXmc2vbUq/3Y6PXfk6hMxO38T1zC3TsDeB4eGKiQ4eibK3fnwstrSSgGWD8TcT2Gj1skc4VpmHH/YmCGeq9xosuT+yBvossOI5a3R2yawFFpr1f/hTa6foO9rTqis4s8T7mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xq9AjxX3EhxMdox1zaGtdiqE4DTflnHv8h5VPtjrvBQ=;
 b=h80EzHfXSX7+ZuRb1JGRPniAHT6oiWrry7XG0AKT1Dnk9aeWjC2bDYfmua1zbSXFlbauzuwMqWMzFok/S5Z2rK2EtzGLiANiiU4Kn/ftVr6q+1pzinZPINkIWh4skmJG3Ox3sA2aIdk96LMQEUsZZo4sS1Hsda17jrQhvI0+xQ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB7176.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:334::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
 14:11:37 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:11:37 +0000
From: Gary Guo <gary@garyguo.net>
Date: Mon, 06 Jul 2026 15:11:14 +0100
Subject: [PATCH v3 2/9] nsp32: don't store pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-2-2d48fc025acc@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=2148;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=8gJVnailyzMYXVEeFt/Vs6x7yjYC1eVNKx3NdE39Fcg=;
 b=UCYP4Ad+cGJRz7LHkxbQP/fAbWQaXxUU0/ZomDW/7YEd/lc8WqjI8UKyvDYeA76FqM5Fby0XC
 Mw7KJeZAzz9CMR/lgW8R9LRsWqXs0bCxjZ4wVWHB90pW1Qx09NkoIME
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
X-MS-Office365-Filtering-Correlation-Id: abec78db-9d4a-4d12-7e4f-08dedb687cb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|366016|23010399003|7416014|1800799024|921020|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	UbXG9GsU1FSKbryXNj1ixY8ulEGz6ba0NrFDpDeBNP8/dymKu0d1XcL+j4SEtPU49xL4Crs60B6s282Fq8hE6fOjCzI3b7guO1YQHXTszoAhgIQ22HETr0rPA1OU+8k1HrZcxy6jmNRtYLb/sEbE5FIC9C9ioPa61cuv7ndC22cXg5z39Wpu4mMU8I6MxAmp/bmINfo7NMhKBFmxf+5Q+T801zcivTpLJnn/imnLqfslclZT/1kciihDFEFAdUhukgh+A+vx262QpW03mxIDPNsw2PS+cGK3vFLwwCv6sXoUGeADwCMLqOtM877EhXhVTc+3R5G6oSE10oP5M9StMOsmWAzCqsrjavcHZzpIcp9kiiKEpXeLXFyM4hvwuyQ50+c2l8Kd55CVTnqoLYoUrp0l+86SleyGyPlQG0YoBynqANxyOwbunngRAWTGHT4yqdaiYrwDt8RbzbdHCKlBfFpQSGt616XQrvKGOffpIRtifMj0oIuZE/Etg7oSyj1pU7RBrjsJKqNDox70wOhf0nGGHlOxXxsxF15uxoQWlt0Z5Wu+3IjWCdV/lE8Hq7RO+bjU1xlu/i6VQqYLz+3rzWMfXhZnJTIIGUZp/5Av8lUvwrMERoZaQgWkNHFO/YvZxOulFZRrjSkZCK+3tC+X9KKAMPQ3lF82YJz/CdX3R5ufYwBXb9GaluQJF/7xatx5fcJbU4D+OBs6+4rkWO++iA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(23010399003)(7416014)(1800799024)(921020)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nk51bEFvWlFoL3VnQWZwWW1TOXJXQk0yV2J2UDFHSGJTcm9Cajl6dS9PVE93?=
 =?utf-8?B?UkF6RFhyZURRS1dvSjQrVHc5WkpsaG1JVUhNb24zY1pLbkJkUzJnOWtqV0Rw?=
 =?utf-8?B?Ym1oblVmcFB4Zkk1UExEcmk3c2tVa3kzb1cyZnQvbUpiRUJmNmpkYlVnRE4v?=
 =?utf-8?B?TVZrMEdzZnlNNHloaVd1SEhZU2IvdFZoTEQxWjMxalgwUGtZWmhwT2k2Wlg4?=
 =?utf-8?B?VXZUVmZXN1pYZGVYVkFsNkNNQXphZDZadW95cG4wSUJHaDBRUzdLbGJLZklu?=
 =?utf-8?B?bWV3dWtyT1d5MDV1REVLMThsK2dRWkZrOTFtMTN2Tk5XNm0xSmUrTU1oWldh?=
 =?utf-8?B?TkN2NWNDOEdCakM0Yk5uSW4vZ0lCMHcyN3NiNDhWb0pDUnBsUWVtdVZmRUls?=
 =?utf-8?B?VFhxeVdnZEE2dGF5TktWMXVKaUxZSlRMTzhKZEdMcHlRb0c2WnIxVUpENmpG?=
 =?utf-8?B?TmY1djVlTWdSZU1FYThJenlid1lEKzFsaXBTTEYyWUc5MDkvWXUxRHUvcjY0?=
 =?utf-8?B?UHhvR3A1NnNyWCtmM3dNQUtCekZpeTdwSVFGZjdHK0ZYdXNvYmRiQnAwc2Ew?=
 =?utf-8?B?SzcwN3Bzd3l3TDFoZzlwSE1GMHgyYW9la0JZeDBuTWZhdlZJVHJwQUJxMTNT?=
 =?utf-8?B?SUFZVWc3ZGh2V3Q5YUNYbVE5NkVCaGNHb3djYkh6THpwcWtDT3BZTlpFdkJO?=
 =?utf-8?B?UVJIVEVJZHd1dUNXRE96VVRxMkhrdC9Bd1NmVis4M2pzU1d6RzFHU04zQWhX?=
 =?utf-8?B?Vy9CSTMvZyt0UktOK3RONm9QQlIxOXdyU1hybHJxRGlrVnhxSjNuYnpLVG5B?=
 =?utf-8?B?aWlhd1FKU000UHV1T1JzR0RoTVMyVmVkMzRTMkVncThwT3IrdXJQcWFWM2ov?=
 =?utf-8?B?YzVhUmZWL3pDeFQyZ09OSUtiVHRqc1NvaVBTZ1lCSzlOZDFacFJYNW5sZ1hu?=
 =?utf-8?B?YVJuRmpXNmZ3eUNRdTI1QUdwcTlUY2I2Tkt0anBuN0s2L3p2ZTU3Vjl5SC81?=
 =?utf-8?B?VUFTRUZtKy9VU1paZ0c4eHZaZlhBdDhTMEh1NnpqKy9CaDVoTDdIZXljN015?=
 =?utf-8?B?anFBcllaZ0xTdnBqK3JTRnd4Ry9JRDgzRmhaeFZyWkc1VkNpSG9lb2NTWDBw?=
 =?utf-8?B?aDU4Mi8wTjdTZDBBYnpPRnlZMm45ODdIYmlxV0dIa0ZuSnJMUG9OM3FIVzd1?=
 =?utf-8?B?VW05VG5mbGV1QXQxM29zbnNIUHQ5dFowa2drM0VMbWJCSFpTd2MzVW9kUUNX?=
 =?utf-8?B?Y2FSanV4emZvWkY5VUhoeFVPTTNDU1lMS2tCdTh4VytVR3ZPT2d2WC9KRFNI?=
 =?utf-8?B?TVhCa0ZkYzVtQTN1QTdRelI1dk1sN3luaEprbWk0UlpiUmZmVkFXeGdjZWUz?=
 =?utf-8?B?M3hZNytETWovYWJYVWtjZVEyckZyMkpISXhsNmgvazAra0F4NTVHSkgzcG0r?=
 =?utf-8?B?eURxK1kxNWhLTnZ3bExLSHIwTHN5ZXRiOWJEN1NmSVo3aDYxZkNraXdPVGZw?=
 =?utf-8?B?Q0FmckFhcWZnbEEvYTVqRGQrTExSbm9GRTNIa0RpLzlmV2gwaFZCcjFHcnRa?=
 =?utf-8?B?bmFQZk0xckNtenlwcmNpYURiYnZjdDEzbldpdVc4RmFlNlNuRm5sMkVpMTlt?=
 =?utf-8?B?QUJQcUN6dDlkcllPR0RyZ0ZOdEdCL2g1V1JlcWhxMTk2S1B0NmtLU3NHeHRi?=
 =?utf-8?B?UEtjRGVyYnhRbFNjTUlRVVh5MnQ5UjBTNi93Q0lLcEozcThtMXNLKzVaTU4w?=
 =?utf-8?B?Z2orQ09kbHNiYW0yYW9RWXRvRXJ0TjJ5M0Y3K3orWnZrdGs4RktiemdGRGE3?=
 =?utf-8?B?VGQ3OWxCSTJNOGN4V3BFRkpJUjlscU1VVVVHOG5sc3pCUXlhWUpXbGQ2SHNv?=
 =?utf-8?B?QTRaZjlDVmZVbWFyL3FKM3JrTEU4VFNjeTUvMXlDTkFMNGRMUHBlTG1USHVQ?=
 =?utf-8?B?UUlQVnRIN2lWSDRBWW5kdVR2TE5NV1hUTnZEeVZhY3BxN25kVUdSeXM3Rk1q?=
 =?utf-8?B?R05ZNXNzVmxVV3VlN0c2YVUyK1NHMHc4QXZIK2JySmw0bW1ka01TR1VqemRH?=
 =?utf-8?B?eDJwVWhUd0pvdi9YWEljNTkzQ01tYnFWTk5WYTJ3YUVRZkdPazM3WkhNRGM5?=
 =?utf-8?B?MmpIVjFiMFNiSUwwdmJnTndONW1GeVlGMVVWdXVHRWtBYnFmMG5PNHEvZmtq?=
 =?utf-8?B?T2paTnVUZW1leGdNRVE3dHpoYWNaQzFsclVCZ09mTU9DVVZkRklFS2w0Rlox?=
 =?utf-8?B?d0ZkVFUxcG5aaktHbGpQVzc0bnNLaVB5RnJ3VDErQWtsTitlbVZxUFQ0OW9i?=
 =?utf-8?B?MlZPaTlKVjVnekZ6OWtKSWtPNTZsYS9qY3RYQXFFMDJnczVYU3JQdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: abec78db-9d4a-4d12-7e4f-08dedb687cb8
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:34.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6LLbmIV2viLKIyn3Od+tY3bpCYNEf0S/1yO/m8li85uNWU7Jc/2a3vK6z3M+H1IOtaFwLctlpJdFnRr5zu+Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB7176

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
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

