Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022122.outbound.protection.outlook.com [52.101.96.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE8B3FAE1D;
	Thu, 23 Jul 2026 22:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844097; cv=fail; b=Rq6QNrNHv6JzlH6wFyLbJ9Pnv5R3l62AMybEK92rE8mE8C8AnXHBYh63TgG6DIgTe3OOIvITD4zuvGxYBoeQxNIquuuHByKstiLhySRsrv0XwOZPG4yAOoJTk9ekASFDowmzLbB4Q+iJR+AVvYwbbWoVN1XNDMmcGdaUwFI7A2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844097; c=relaxed/simple;
	bh=Uq8OGAcHVw6a6nyxNc6mSwt8JEqAoheaziIIndM7prc=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=nGK3vVu9FtBZYllJM5KbtTxf28lWgnOKhEO/jU7q5KVpaBPBinCnHuzrfKMJtj1cKQQnODCAPYbNN3shcgXSvAwLPHVed70G9CJtf/EUVVYXV4YI+YYNjvedICyl+cErO9Q5W3mg4HKTvlUYh8r3YtQ/4Y6BU3uVuvuvHxsXsLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=HN1Abj/m; arc=fail smtp.client-ip=52.101.96.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="HN1Abj/m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vTVIAmZ5gGDPuJCz6Q+/0CK4ABpqziMzFa/4InbH88V/zM7Jpxq2NdY0rY+CNJD+UwIjJ7YUW+JppcIctRnBlY9qYnCBIO1mNppHfU+9HeH4sqC3wGDkmH73qrIt9ABq/7Be61OjROLBW1BvSJfDFOR5BXGdeJcmeT7du35YYgBH2eEdLlf3QdVveuPL32y2uGLuoF8TX8KR0M8bRkXR4LcYo+ZHq9iUuhZKX2RzcvXQE/Rkj4aivbxHZy/WRrx3OsMmdhJCyRX/vKXYJClyu83pUpzwOr/cv66czeHxVp65lhtfizdG7vXA/TtFbO3gm0LLiRwGl8FJTDq1rMhZug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqNSoU/Ele0jA7ni0VEhW0LfdshmnP/44N5SKfvrdQA=;
 b=oB82y+RrQSOuMF1BrmGmJkLY2+DmmEZf4W9D5dvOydVlFe5H/fmldllEJAmDoDrPt2AlGJNgeVPcaSenjoWr3IwkBg9OBi5JH4AIyOCmqUp8kkCKxp0u2ZngZstr8rAOglud3APtDNs3yTyvAiMY5C9Bk8ujr2KeDBI3vp6fHYPFtundsQ3cPfVv4/nmOGs/PyB9D6DkSYrOYsSzMF9N5qwQ2cCglSSlUviGiMnB93V7Kle9UoCRbrDKVlfvVLy30oFtVRSpw1UgN2GeUp43Tu/DwBDEeCYUYHHHzz4cKI08Zz6RdgkOtdlxbP5ztdH9VCuCDfs8iN6QVKmwutkDxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqNSoU/Ele0jA7ni0VEhW0LfdshmnP/44N5SKfvrdQA=;
 b=HN1Abj/mBMJT82InpOTf2VGDFBqyLnkVXhNHRhxRmUjcvl1zJwa5MQh4fK+nZ56BGBDCNBwv06KJeMZddu/8nI+jZwJ0FvztP3ecDmb0J/ZjFB+ZYAJbyc6ANBdQhGrsOfXCMBWd/IhpHKgQMSCz+Y2VTI0+q7AqwN/rIYNUZLI=
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
Date: Thu, 23 Jul 2026 23:00:43 +0100
Subject: [PATCH v4 4/9] mlxsw: pci: don't store pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-4-3580726844e1@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=2901;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=Uq8OGAcHVw6a6nyxNc6mSwt8JEqAoheaziIIndM7prc=;
 b=gX/Kkw2ll+bV9TpBy+GT8a4PfHVJimt+tYWkAX3H7b+CI4Ipq0dbW4muJF7CbX7W81A0x2X4+
 ea14eokWIfZDoSNG5C+3OLhIibwpjdSIEoHPqH/k8fPIhSzQeeHyUE1
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
X-MS-Office365-Filtering-Correlation-Id: fac0001a-17ae-43f8-d640-08dee905e6b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|22082099003|18002099003|56012099006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	Fa+1bOO+nhnSUd3NnxHRimJp9eIREr+OKjqFZyxSWF2PU11aI28hfYsmoZo7p0P9PlkKq9IgWgdR3ehrpFeggvWSNN3KdHvbfL9fb6gb0kydBrtvR/geejOL02pEor07xh7TqBFTG/hDxE5ZB3Kj5wYcbE5r12g/jK2GNuI3qaRhL81MN8e2Ic/gLxoCXUC670mCqKB+WtUcdTSQ+RJB7YTpwsUJHhBsoVAw+q4T4ip5T6iF/8InCJISdNdGJ1CG8gMUUzR+QL7khLGvijuyiZCM1fQ4d3BdPtYUarBfTQxAHKBE+pmB/NARsx8mVCPVV+e5Ct3kcZwX/HoI78ECYSy5bHWgucJYix1MR3PfrAOe3LScxfjwgawQfYr4vEc9f4c64loPmCfWM+tEL9qC9UIyGUEs1azEofjdt9O5NR/1qGnGoTXjfvTbn0yYlYuW/9DaruQ1YQmnIN8Cpg+71r4sLmpY6SM8DexJyixOuR99WZ2SI7rFp8v06nughI4tAShrBmwe0pW8QrEewIL+G+toFsQbKKJRi+kD4IFnLvVcVstyx8xEBAY4ZqntdvecdqFxi2g6ZxlFbiGOTkUGKMW4d/322qbzjE+6OhM+GbgUTlBonEa74hoP/NRnvtWMhdWtG998AH3f7sJR2pghqHj55DSMjn/F2ONElKv5QSNfaq5Dm98T594sZ5hhKViypChs284CoLGT9uCKcUgUjw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(22082099003)(18002099003)(56012099006)(5023799004)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a29zNU93VWxGbXJoRUxlZkNuNVRhYzFYRk1kcUZyMGZYem9ldVBPSFAwOENv?=
 =?utf-8?B?c0dYQ3M4cWhkY2g2QkdVR2kzbHFNc0kwOVByb3ZXTzdRbEdzc1lWR0lXTEtZ?=
 =?utf-8?B?VFZqSXVlQ3ZRVWl4VEdMb05lSHdYREdoLzZTazZZK0Z3d21zci9HMzNQTG5t?=
 =?utf-8?B?YkxyN1ZEUWUwa1R1YUxiUFQwQ2xNUDhnYzU4R2hid2FDbytyRzE1WEt1SHZI?=
 =?utf-8?B?SHY5eDRwSUVGZHh6UzlYZGFwZHVmZzFtNk1LSUZVNzRNbmE5SCt1Sk9YL2w4?=
 =?utf-8?B?dkZldm5JZDhEbWk0eGVvN3BBem1XZE83VklKRHBXcGpYSC9IeE9JTmVSVmNN?=
 =?utf-8?B?OW9JQm42YXRuOXRUempvWUFnZkt3OS9nT0JYNVdueGpSOWZNWVo0V2hVQkVN?=
 =?utf-8?B?cVZTMnZXeHZZMGhMbkxKSm9ic2ZLcXdlb0ZIM1RhQkhJN2RTWS9tYlJJMitW?=
 =?utf-8?B?QmRPZnE1R2RJdFlnQUZGeHFabXdhclhvNzNUSGRFMkJZQUZpVUFpN2FSUExY?=
 =?utf-8?B?ZEF6QWJMWjB5RXlKVzJJOE5JZGNMMjVaVjRNR2lVOGhVRW5CSGpMVDFlRTg0?=
 =?utf-8?B?c3FUMkx4RWJaQzFCMjgxaFlPNjVGd3JCb3NxQjg3aTczRkZ0SzI0djR4UEl1?=
 =?utf-8?B?Q2JrdGdBYnY4OFBxSHh0bUhPNS9pdnFQSURteFdpd1RlQzhCQzZtVEROOS82?=
 =?utf-8?B?U2ZXU1BDMWd1Q3d4NlRyM09SV0ltZUpIYUpwa1JYejI0aG5lbk5uVjJtT2d2?=
 =?utf-8?B?bmNKbkdTQmJIOTFPUDlLcUlxenFaNHFpM21ORTdqTm1xcktNc1BPY3pTUE9w?=
 =?utf-8?B?MDZSOW56Nm8rNkFLSE5HS2w3UDhkL2s4S2xncXdSTWlNWnRBcnVqWkRYVm5o?=
 =?utf-8?B?ZERWZk5BQVEyTStaY1diVzNXSVRHeEs1dUQvejhPa2h2RjM5aTIwbmtHcTM4?=
 =?utf-8?B?bnhQZkI3OGFUNTNKZ1grSm9WOUJYNFVrU2VoVlhaVG1VeCtZZTN6aGMvU0d6?=
 =?utf-8?B?ZmNOS1JWL0pycWhwclFJRGgrdmlaYVBLWGFJNmRqUC92aEZmbFJOeEFsTnRQ?=
 =?utf-8?B?V1hFSjBDaE5WeTR0Q2tyaUYwR282TFk0S3RwVVJuZDlpZmduK2kvUlU2MUQ1?=
 =?utf-8?B?WkNMRTRQWmUyeWVTcUxsV1V6TGJqVmR0aUlSQmVtaFVPUWdPaEwwcEc0Mmdk?=
 =?utf-8?B?QVhRRCtEa1V3Y2NHYUFLRTJCR2Zud0hBMDZXS3UyK3ZOeTNUU1dYUStMUUg3?=
 =?utf-8?B?S2JqaWt3UzlQSGJmQkkzejB5NnpPVmMxQktmcmlxUDEzenlKMmk0RnFUS2Zr?=
 =?utf-8?B?RlN0aS95ZWQwa01PZTMrTmliWXN6YXYrWTFSVzVkSDJodENwS0dmdFhKc09h?=
 =?utf-8?B?OVVwc2YxVmdLV0xYWTVhMlZFOG0zS2JabDBXWFRNOG82aVNjdVFHUUo4N1Qw?=
 =?utf-8?B?emlPR2N6blNya1c3UVZnQnBEK1RaM25qWnhvTVpOVFlvV1N4aXdtRGpPa3Ja?=
 =?utf-8?B?bVZKdzVRTVNUZCt5RVFkQ3l3NWhIV01wT3JlQWNHVURTL21Hb2EwOEZxcjE1?=
 =?utf-8?B?RENXVmNXemFHajFvMktjOS9qbFNtZTBJUExHQmRKYkZiR3dlanpuQ21Ycm03?=
 =?utf-8?B?enFLc29TQjQycFZkbjFoQk5tcUU1UDFUQ25aUnBtK1NDS2EvZGlrZ29WVkpJ?=
 =?utf-8?B?d3J2RGxOMTFVQ202a3JIbU4wdUlPK282amtNaXYyV1FSa1cwOEhlSGVOWEtB?=
 =?utf-8?B?Rjk0TVhZNW93bkJTTm9PSzlFbVhMcEtTdC9KeFJRd0k4SEpFd2REc0treEpE?=
 =?utf-8?B?MkkvT0RVc0ozWWRtekNKeWFINUs2K2JOVlJxS3d1Z2dDNThxYW5tQXBXTnVH?=
 =?utf-8?B?b1ZhV0ZPNkZGSjhubWE5Q2Y4MXE1ZEU4NVBTSWNZNVVPLy9KV05KM0ZQZExh?=
 =?utf-8?B?eTlNc2Q4NWlCZDREVWhOcjRtY2NFd3NoTFpZcWxidDRQNnBlM0NSQ2JNeTNW?=
 =?utf-8?B?T29RbFRNRTFRYTZpOExNSGlaaHAzbG12RXMvSmh2Ym5wcGozN1lsUndEUE0y?=
 =?utf-8?B?THE4N3JyZzl1SFlXRmlqNDJqZ082dUorY1ZPR2Q5MWFZMHBtMWlNWnBzS0R3?=
 =?utf-8?B?Ukp4UEEvd1NqSGhKcU1ka1BkeHM1ejROMEF0LzByWDF1ZGZXVTRnemgwQ0Qx?=
 =?utf-8?B?ZWNleTM4WjF1RG4xTGNVUjBJWjM5SldUYUFmUnd4T01CK0hDeW1ybmRDNWVz?=
 =?utf-8?B?UnVWYndIdzROSUJpa0ZWZmEybjYyV1pRRU1Yd3RkQ0JHeXNSTzJZQnYvYVNX?=
 =?utf-8?B?aGZFZXdQRWVOdG9UeWJZWG9WU05DLytiMDdmUk9yeCtCeHhickhYZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: fac0001a-17ae-43f8-d640-08dee905e6b5
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:08.8424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R4fnMcfD2oi7v34pw1CZvtwaKqINEp1ouerEumRCSmJ95uquWtK7Km5+dSnNBY3i8eDBms06MyqmG7NpVCB5xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. This stored ID is unused so remove it.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 0da85d36647d..bfe3268dfdc1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -130,7 +130,6 @@ struct mlxsw_pci {
 		} comp;
 	} cmd;
 	struct mlxsw_bus_info bus_info;
-	const struct pci_device_id *id;
 	enum mlxsw_pci_cqe_v max_cqe_ver; /* Maximal supported CQE version */
 	u8 num_cqs; /* Number of CQs */
 	u8 num_sdqs; /* Number of SDQs */
@@ -1768,7 +1767,6 @@ static void mlxsw_pci_mbox_free(struct mlxsw_pci *mlxsw_pci,
 }
 
 static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
-				    const struct pci_device_id *id,
 				    u32 *p_sys_status)
 {
 	unsigned long end;
@@ -1839,7 +1837,7 @@ static int mlxsw_pci_reset_sw(struct mlxsw_pci *mlxsw_pci)
 }
 
 static int
-mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
+mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci)
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	bool pci_reset_sbr_supported = false;
@@ -1848,7 +1846,7 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 	u32 sys_status;
 	int err;
 
-	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, id, &sys_status);
+	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, &sys_status);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to reach system ready status before reset. Status is 0x%x\n",
 			sys_status);
@@ -1880,7 +1878,7 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 	if (err)
 		return err;
 
-	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, id, &sys_status);
+	err = mlxsw_pci_sys_ready_wait(mlxsw_pci, &sys_status);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to reach system ready status after reset. Status is 0x%x\n",
 			sys_status);
@@ -1932,7 +1930,7 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	if (!mbox)
 		return -ENOMEM;
 
-	err = mlxsw_pci_reset(mlxsw_pci, mlxsw_pci->id);
+	err = mlxsw_pci_reset(mlxsw_pci);
 	if (err)
 		goto err_reset;
 
@@ -2464,7 +2462,6 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mlxsw_pci->bus_info.device_name = pci_name(mlxsw_pci->pdev);
 	mlxsw_pci->bus_info.dev = &pdev->dev;
 	mlxsw_pci->bus_info.read_clock_capable = true;
-	mlxsw_pci->id = id;
 
 	err = mlxsw_core_bus_device_register(&mlxsw_pci->bus_info,
 					     &mlxsw_pci_bus, mlxsw_pci, false,

-- 
2.54.0

