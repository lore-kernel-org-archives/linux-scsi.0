Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021075.outbound.protection.outlook.com [52.101.100.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDB03F39F1;
	Tue, 30 Jun 2026 11:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817774; cv=fail; b=k3qOQ07Jxmsp07UXxNpeJKmhdZr1Qrcdx+tzpnBDeblF3GqQagS83Qi79Z8bxnvz+XjifiLO5EolNERyU4YqWMHWtIycNUH45d3ateursmjfKVreB/DIyF+5jEJoe6qy+xaHx6RYrKkwVSOOyuFWZqxIOXz6PErYuQuIBUs+Y8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817774; c=relaxed/simple;
	bh=pht8AGCFm7R8iqT+/2D12+1o2p/bRi+SVscRTG3Bq8U=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=HaytEG6G0h/6i2XwNF/GXl5w39yPCM2K0FNT82ocnB9eaYOfBACwfrv1hzPMLWs8b4Uq6KpJw57OrhxoglA59Sc8ALC8f9W070wDj1ry7VQafAQoe3VDIwha7yNinJrLtG+pHwsZTkUp4hUK/S3uxIh7eKXEvO0HkqTrpZP9d+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=LDQN4L9s; arc=fail smtp.client-ip=52.101.100.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="LDQN4L9s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CzmXFq19zaPuGWMQZprIV9xN+c4b5Cdvl7KSfAo1nh86Xz1TKZa4w34wmhuuH/jV+sYlhNPfIDYFPWUI0oEKp4CcUyalx3HJM97MEzjErY68qRTXvrOiSqecxiPn0wXOM3GFZv7vocHvzSKd2LNlKlXRYJEjsAIOkf5BiSBd7mrDwMQUKx+pYXuoDYk42J14qj9hjR+r8oO2xcniIrVTp0aLdBiWtYn/X6/XYUoS5U208l9WTBPSAi1mV0dzMXMPfXcEq63cjex7zYgSTUMl6B1l76eI1W0ufTbhNWtevczLC2ICbgxts+7b5nYqmwhjJxUQ2ukuRdMWMfmL3cWGBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQ1kuLhdvNmzUPvO+CGtVYR7uFAhtLXHQIrrIpARxuM=;
 b=fNZOlJHvhUZ+ZapVCPuiBpbFRG5KxcWuIGcOhT0GJN5yHAFOpIU8ZEiquCX2WK+m7L4hW5B4zimjv8nIVhM7OsHjRo9+v/580fGqEe4gBhw3M28ycYmGoxiN1aQPzg8u3l8moRDKPp2QQiILoZ0T23NsHunVBCKjluh6xfTQsJuqrJRH52Ecvk6BB3yQFL55j9zO482vAhYweHXSkCS4tQ6PTOn8ipDjO9tMvGPIZ+yei3AjyYYh0baoGQ2U2PXe5fGSvfOr4bDPH9xFPlqCHZdGbElUUVcxrZPLp9IP2bLeX3MsIfjD7ckGjRohR16dQMbNP5FskrxKB+gnNZsNpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQ1kuLhdvNmzUPvO+CGtVYR7uFAhtLXHQIrrIpARxuM=;
 b=LDQN4L9snLXDpagys/Ng/Pr7B1fAcekRwuKwRB7M1Hz8MEhyAg3G5mRNOTv3oZzUSFv385+ZwePtTNCCD/ppydf0eS3mJMw37q//so6aIBla2L6bA+w2MyrU5KhLV5cGS1vZ4tppC/Vb79nBfnIRLJiFbBLisbMbmF4ftpCYpB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWLP265MB6625.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 11:09:28 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 11:09:28 +0000
From: Gary Guo <gary@garyguo.net>
Date: Tue, 30 Jun 2026 12:09:06 +0100
Subject: [PATCH v2 6/7] pci: fix dyn_id add TOCTOU
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-pci_id_fix-v2-6-b834a98c0af2@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782817763; l=7259;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=pht8AGCFm7R8iqT+/2D12+1o2p/bRi+SVscRTG3Bq8U=;
 b=PgL+oGhU8/Z2f2Be07UyYqWaj5vIyrZhav41otUzX9EibCP6lOGxck3vEy+xz8TKp3lGDF6Km
 sk2UJ2j/qA3AUK/pkevYWd3wfzQtEJOmv6/+NwXOJOGgJypXZIrAbA/
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
X-MS-Office365-Filtering-Correlation-Id: a2f8cefb-5eb7-4d03-ea54-08ded6980c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|23010399003|18002099003|22082099003|56012099006|921020|3023799007;
X-Microsoft-Antispam-Message-Info:
	V8d+nT3RxvKY6eWSbzyaYM4K36wz1M5+rzqhUkQOCNzxZyyvOBLSnVZgPzxE9vbinzc4ieaPVuRJMOg7rS1/Fv8Vi0wLbH2xoMwJQpcGefOABD+BP/jOUJAlICtMBTirj6R62d9usL9PExTNsqVozvyBGTKvhNC3wqNRbBl1YxLznLTcFMPdbUmwEZM962DTSZ38p0B/MrKpr0nME66Dp9CYhCVeiaFyVYGxWC7HG3jOynwXWGIPrLs27nfCVvk37nlNMFJ54Zo/ugX491VcL7FWb5iZT4fZHpuG+Z+4iKxAxw5BETbQydvCyd33AEyzdqPnc/nI06usvm1GWr5Zi1K31lNB6Hn0FtG7boYaFqywd8ZbLXaSz0is6tCQnltT89bcPHAxieGWo5uoBG5kf1kcpsNJ82svgIKBGZt416CPf+dRcA8JaRVvDKgJcdDjJghqrCTohgM6Z248N9ppWHBQ1MHSOMJLMHf9FhWLSfTKPKgqV5CKvVLWveMCtXQ885VYsj7eiKrz7Aws3cNBMnWKmwDd3bZDnXyGVsczuCZt/RKXRBzI9mSEN7wRK9EYzrNhOYnUsf7hdcNYLXeB8wsGd/wwqTOAJMJOrO5lBzzqpVwtP+7HDmLna1U/ffc/c4hW9x/hqDMk8i01inDWgSrI3NGK3fn4Tltcp+4NYlrn0TN6Xgeezj9/Xh7Ak8d0eacGPZymxOfZImOs6S36Mg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(23010399003)(18002099003)(22082099003)(56012099006)(921020)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXZFZ2NmYXJ4WlVYdWgzS3dIL01QTVZDRVBjK3AvYy8yU0pCOEduMTRkWmQ0?=
 =?utf-8?B?TVI2MUhwR2VtU0xRZUdzL3ZNNUVVZWhNVFhuYUFhTmpUSjJnaTVTSnJYcitE?=
 =?utf-8?B?enFoaGl2S2o0d0ZEYk5NRkV3a2NHNE5SeGtpdlRjajQ2eHFCVFhYZDg5NkFS?=
 =?utf-8?B?SlhieVV2SnhqQmRnL3lsQ3paTmY5Y3VCV21zaXlFL0lpaUUyWlJYdWRNMEd0?=
 =?utf-8?B?VEJTV1haaGdBT3RhNWdPeVFoV1B3SUhjbmpUUzZnY0dRRS91cXM5V0NGNCts?=
 =?utf-8?B?OS9XT2o3TkZHSENCckNKM20xWlBSdTRmOVNMUWdqUDlyRjFKZ3J1VElWZUtE?=
 =?utf-8?B?YmdXVHlNOTJDZTdvQVNmRGJVQmxKM3VYVk9lZit1anN1SU4zRWJnNzB0M3NF?=
 =?utf-8?B?VE9JQzZURmVCMFRzUjVnU0lScGhjUjd4ak9yNnVObytBa3gwWWJsNElMREMx?=
 =?utf-8?B?Q0ZvV1hhNUJlQmpUZ2hTT0llNkN4ZytyT0tYb1BDSUMwaEd1Wk5GeHB3dThV?=
 =?utf-8?B?Vjl4eHc2VkRxMXIzWXR2QnkwQXpUYnhleGREaGcydEgxYVVTY2VyV081VTZK?=
 =?utf-8?B?UDVGa0pnQWhiUEJFZVcyeTdJRWFsZkVNM3h3OVBZVGttcjlzN1B5TCtaeTEv?=
 =?utf-8?B?cmV1SmhWTGFobFZQbXh1TFRlZlc2ZDhRWEIxKzdqOGpaSkNicFgrRUpWbFpx?=
 =?utf-8?B?Tm1PYjAzbWlyYm5QdDM3cnNOZzB0eGdkeDdVMkpURHJjNHZzUlFPVDJiMm9j?=
 =?utf-8?B?YS8rc0sxaml2Wlh6NlVFTDNRZ0oxaVJhaWVMTHNxRkxQTE1HQ1RUa29ZVTM3?=
 =?utf-8?B?bEt2b0VtNDZpbmQ1ZlRPdExKSmhmOUdKWkwvZHhhaTJ3SUdxUXRhNU5WUVdP?=
 =?utf-8?B?dFhqclgxNGtqTGIweWdlY2lVT2I3bXhNcCtsN3d3YUZOblFRaTVPdDd1OVp5?=
 =?utf-8?B?SXlWOG9VRGFlaERiSFMweXk3cXhZK1UxS1RXSWg5bXMwenlHUm4wRlhsNHh6?=
 =?utf-8?B?RkdwYURKME5yRXpuRkNhclFTRHNlZ1k1Z1Q1cW9QTnIxR2x2T1NOZ0dacU05?=
 =?utf-8?B?VDYwOTBwRE9LajNVMU51NXFHRnU5SUhVbTNLdWpYT3J3UkZNVTN6b1VpejBq?=
 =?utf-8?B?MWRtZ2w5NGpmOWN2YkhEOS94Y0VobFhScGJHZnNqV3ZzKzlLWHBYaEpYekly?=
 =?utf-8?B?eU9LNktiTnYreVZxLzFURmZVc3Q4UXF4c2FZYkN4OTc5Y2R6VmpJY2V5cXZE?=
 =?utf-8?B?cThPY0d5bWNUdGlWQ2ExWnppT2d4Z1Q1UjVoWVJZUDFpbThuWDdVemlPelZV?=
 =?utf-8?B?RG5aTThJVmhncXB5UWlwTkhSbjlnTmtrZ1ptR2N1Umt6MXU2OE01ZHJqbm5n?=
 =?utf-8?B?L1hjUmlkQXRCRFUwWlZ2SEF0bUdXS0t6MUF3UTU0QU42RXRFUVBjc0Q4dWN6?=
 =?utf-8?B?azk0UllBMVkwS2lkOHovbkZ1Y0pydEk1amJKK3B3QVE5VnJVeXMydDJCb3NK?=
 =?utf-8?B?L2kwbXNGaStpbGhST3Q2dVZSSS9XQzVEU2ltWFIrRmovNnZYc3JEU2k3U1la?=
 =?utf-8?B?aGtoZ04wci9hVHM0cld0cEZSV0kvZlhnZ3c3MW1QSnlmTzFHeU1JWC9SNUN0?=
 =?utf-8?B?VGFwdDJYWlhZQkl3N2Y2eFdUZ29jaVlHSVVFNHlycjhoQTlxNE9VU25INkNp?=
 =?utf-8?B?MDhqR2FXNW5MSDhHOFlpd0orWFRlNXVXSnNKSnVKeVAvS0ZXeDFDRGFhRU9R?=
 =?utf-8?B?WTBZcTNTYWUxVUNYbXJIR1BkZFBjcnNGL2xDWEs5eEMzZTYzREsxOG11cXow?=
 =?utf-8?B?MkMxU2dsRWdlZHQzVEtYUGp0Q3ZacGFtMEdFOE9acnlmZStmU3pHV0o4NmR6?=
 =?utf-8?B?S0VzeURmSDlNQzdzVEJhdW9tRnJMN25tTjF4SE01MnY0eXVySmloQVFmbmFJ?=
 =?utf-8?B?WlVZQXFKRTdPU1dLUm83KzVLMjhlOU9paHJSaTRKKy8vVTFKWmx6eXAxMXFB?=
 =?utf-8?B?dmVvL253Q0RHZDdJMTZHZXlLRVd2RVd4bHZ0ZENXWlhRZ2R2TzhSbGFBNnIr?=
 =?utf-8?B?VXQ1QitiLzVrOThwb2djYjJwVHcxam82OHJLV2NLVlBPWSt3cXFiVHowOGxq?=
 =?utf-8?B?Zk9ieGVMWmNBQUNXUWZmbDZXbVhQVjhkNnlGTktVbVlSZmd6WENsOTc1MUR4?=
 =?utf-8?B?dGRORkJWSXRLM0pmQ293T29leG1oeDVoUFlVU1hoWUFDUWNIUFM1QkZlaVBD?=
 =?utf-8?B?NTYxekozV0hRUnlHWWN6NkY4TytCTmgwb1pyZllFaW0yY2I3TmhpNDk2QWJz?=
 =?utf-8?B?YjFUdGQyNGpmZGxBZURBc0ZxT0Znb1AxTUlUaW9DTUZYY3dMZUk3dz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f8cefb-5eb7-4d03-ea54-08ded6980c26
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 11:09:26.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zRhgKcr+j3qJOwhYnviTwRbIZrv+Zy407ZbfPkC5GuDKwGztJQCOyFuMvAiv5FrYa8qUkDVbVJLclj/QdrReg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB6625

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
index 0507cb801310..df1be7ea2bde 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -29,6 +29,48 @@ struct pci_dynid {
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
+	{
+		guard(spinlock)(&drv->dynids.lock);
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
@@ -56,25 +98,17 @@ int pci_add_dynid(struct pci_driver *drv,
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
 
@@ -99,11 +133,13 @@ static void pci_free_dynids(struct pci_driver *drv)
  * %NULL if there is no match.
  */
 static const struct pci_device_id *do_pci_match_id(const struct pci_device_id *ids,
-						   const struct pci_device_id *dev_id)
+						   const struct pci_device_id *dev_id,
+						   bool match_override_only)
 {
 	if (ids) {
 		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (pci_match_one_id(ids, dev_id))
+			if ((!ids->override_only || match_override_only) &&
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

