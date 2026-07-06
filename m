Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022093.outbound.protection.outlook.com [52.101.101.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580DB379EC4;
	Mon,  6 Jul 2026 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347120; cv=fail; b=d0UrtDr+qySVZsHMHUokWjl2UDhKsj6c13ff+8Z8Ilk87T0ToZkjZyvXxolZ/gNm8IBAJTKWbu4S2w5xn+7J85TrZ2FtzoQhQ0iHSiJr6qOpqs+fs4cmxDmcKDW3Va0rz1LU1Bb/2z67Rsjh5uyyroxy3j+yo5Z0SdKPJT3Kjuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347120; c=relaxed/simple;
	bh=wgL7fCE//vjwzTSIhjUwV/F00oWziqEaO95Fl1LpTDo=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=KCeYKr8vUeETa9XQH/FERNRp0OQqSuzW+mdf9I7Ag3M7STtDfFCanpRYckvuP2fjnMffb7yyAwtbXpA73himzGEk7jUkfCd4+Ap+hG2H90CIb9SgNXVRTNNhgieCqipRKZxGy8wG24bRa6WDNfUl1bp5yDV/TZRhL0M11WleJxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=nGEXcFZ4; arc=fail smtp.client-ip=52.101.101.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="nGEXcFZ4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wfgHmy1wcCQeFSEvnt9xHlPU8Q461zMJqY6bbGa2EXtXOca08aCuyQkZxTGio8rMvYouKFWFvKzihZkOa4E9lRr7dXxKhpWH/h3pZKI8n/P9SKz5mPPjgpM/q7w7Vt6pcSsxbjh8wvq1JMl6nMufaU9TCvYASoy+QWN7+ZFksBCgRAhTdGJfcPATKulSzFpIaMhsnYDl05W+wkrDQ4rkIOTms57LqrD5/nWpn94Cqe2mo+ZSQrLTnFNt5z3gZ67IUerlvkPTQDqFsCgtyOEVhizuHTqgks/nD0RGigBon7lFTlh8K2Zxgg0xGIr/pGXPWqg6tJtPLqu0SrTrJR/UPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7V/cR9AyVAcL4HsXPbg162VLpkBkDOgBZmZ687ae1M=;
 b=WTdhBkqk6NvhQ34bxyI4JJ2DN3Zix/L3R80ji+TcDdrc5POJHgEKpwsisdp7oppPylh8ab/iWuvV+iMB+diSN1PUtLB5EDpcQAws7r5dhU9zCdm4roL9vU+l8xxaEJs62UwhTNVn0eXSlnZAwENI3SuWYJ1losOQ/YK5sGmx9uczpTcg29wHi6YcDRImD/yXGjL4uV4/t15M1Cge7NE5LXfHy9RJJ3rUUBcWHG6bojpXPH+rIWFA2d9KgBnxs1R0xfYnh2gcE2hE2l1i37hf8kzZXyTgK+fpQaYXJpasZIBIdO6zKORQcrZzoNRsJcyHD5pBoO4JNQoZaUfEbWPIHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7V/cR9AyVAcL4HsXPbg162VLpkBkDOgBZmZ687ae1M=;
 b=nGEXcFZ4REgShT0dqVr+8I0IfeUgEtxplL4krPKDrn1dApC5zddycIziR9fhCwoI53L2BVdlHIXv8nZntmV36Hl1f3sSSjAtkgciLL4/Bx7L31Rz0PqWHbQxol3/sldL8zn7w3NFBuHgxQbXkIapexjd4bQUwJA1tVW728FrG84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB7176.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:334::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
 14:11:38 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:11:38 +0000
From: Gary Guo <gary@garyguo.net>
Date: Mon, 06 Jul 2026 15:11:15 +0100
Subject: [PATCH v3 3/9] ipack: tpci200: don't store pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-3-2d48fc025acc@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=1308;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=wgL7fCE//vjwzTSIhjUwV/F00oWziqEaO95Fl1LpTDo=;
 b=w6IWltVkNOk3Kgj4a05tI8UjZIgRMOz2CTfA17eDgjK/7TAR9Mx6+J6XX9tZlYNbSbBseQRf7
 6dN8rr9NW8PC23Z3udaku3z0O3xEruBYAU/tLC2GoxKeXjqlxpT8B4h
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
X-MS-Office365-Filtering-Correlation-Id: 3f06db9d-0160-48c9-dcc9-08dedb687d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|366016|23010399003|7416014|1800799024|921020|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	I2s2ga9P8O2o4fsxOBGTVDQxjpjECu6z3ucEaEJqwxLyHsO6hjEi2kVxMsnhmbAJQOiO2cUCIDehS3+q5vnZkkpSZ1yjlb8xSjZfLuB0T8bjt1hta+M9+n3WusuFiYtypO8L/ERiO8WIovokcS0GG9EQYg/2ogZzh4nUDchCeTDtBGQfTAhRQUcyA1p964y2dENpj90TKHPTpk/P75eVz5+liWeC8Ug2abN4mwrg8At9x6VQ0vnZ9ODYah73GVGx/pApltaqarCRUOwYGYuOvqNbVEoe1d49TG/7sBmvDgqDT5Y7hhYgJcj/Qu9dwPHf5pOiQO1nYEMTI33dBLlMkrhyQu3NoLNMiGnnSEJN9E7PHJvFiFgCqKIFR2dpRWmYU81NLCipe5Du034YBBks6Kf22LiXJNBn7OE1w3QvIdwo3ImlFJQ8eggpwy5s4/DwvixwuEnjBHOSYBRCe96/iwzpZStzrEAXXZ1HeDhAeyar9MBy53KJ49SW+9ouurSUhWAagjJtWA69PtXJFtqTdZqkIMMoGpkGvQEHVeRTmNq06/ikBD6ffJtkD806CIlhDfEuFPdQ8bTNPhkVmJh/15wEZDQO3eyD+w/ipBg5J5Zroa7BXSTgb4Jkg3wyFW3S9Q0pBoKvYaTPMpHNw0hypBxsw1Vfai9y6UZ1OsE27pyRK7/olclAaReyzumL1g2sRHt3Wl2vXL6QmznVkzU7Fw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(23010399003)(7416014)(1800799024)(921020)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTdGZmRMOWhLQ3o5YzJzWEdoeHptR3BCam9QcDNYK1VrSmF0NmttZUYyTnMv?=
 =?utf-8?B?ZjMzWXlKb29DNDhnZUJzanRqOENHZEsvWFNlKy84TEdQcTBDM3FDUmMrZDZi?=
 =?utf-8?B?VUFmdHpzWE9OaUwvckRUUmJRQ2c2UzQ4QU9sU29qKzl2S2JwaVlTQ3VqZWhC?=
 =?utf-8?B?N0wzMTNWUUZWY1RtV0ptNEpCT05nNXFjOGFjcXN2anB6ZkxibFZ2eXE1c3FI?=
 =?utf-8?B?UitWRUgvMTRCWkRXRmR3bW9kYnBaZ0RwQ29tbFRZdVgvUGl2elVCYUhOOUw3?=
 =?utf-8?B?ayt3azMvWDlvWGlSVVRiZE5pc1RuQ2J2eTNiTnJNUEVDeUdDeVpqTWwxdHFj?=
 =?utf-8?B?YTlJdTdGVGpSeWZ5K1E3UnBXcW9MMmVXZXEzSkFobkNTcGh6a0tDRk0wQVVq?=
 =?utf-8?B?VTFjd3BHclVVK3JVUFdwNW9qVjVRYTUrMzJmVGJWNjF2OVNKL3lWditXZnNn?=
 =?utf-8?B?d3VEM2Z1emNQWlBHUVdMaml0TEwvMk83MWhuZWp0QjF6TVFMczJyK2h1NGtv?=
 =?utf-8?B?NlVGSlNheGhjZFJITVRjSmVZbmJkQ1Q0aUZ2dWhXaS8rb21uQmw1VjRCYm1s?=
 =?utf-8?B?RDI5L2JpYmFpZHFXMlB4Y25mMWtQK2hBQzhDNldmY3V6QlNJVTNqQmd6T3pH?=
 =?utf-8?B?aWVEbHBaeDZTbXdieGg0b0JFVTdGUTlCR3BQZFNNNEhEeG5EZ2lQakhpZFU0?=
 =?utf-8?B?N0taTmlqQlFac0Ira3hNd2FBaHR0VVJrWi9GdUpHMjYvVWF5S3pwTlhZRGNn?=
 =?utf-8?B?SG5OM1I3dTBpeG1lZ0tSUWx6WXo4RGc1SzlRR1RnSXd5SElaSFRKNUtSM2JC?=
 =?utf-8?B?YjV4MTgzZXl6Yy9Zc3BpRERVbk5yTTM4VnJkdHJYcENaeG1xU2ZMNFVKMWFo?=
 =?utf-8?B?bVc3VEFzdC9HRjZZRmVHdnJMOWJhdW93V09FUlgzK2RVNmVteGNXN0kyRzNW?=
 =?utf-8?B?MjN4SExQQkhoNE5iQkNpdnM0RDd6ZDFtSGNzUHlaNmRwSTRseGJjVVJCTUhP?=
 =?utf-8?B?SHFzd055QjlhT0lETGxweGszV05DYjdLblZFTXZqa29CRjd0OVhNcHZxbi9o?=
 =?utf-8?B?VTMvcndMc0FaL1lIMmgyTlNTK1luUWd6K2pCVk8vUlZMbW5vVVI0UlJvcEFH?=
 =?utf-8?B?MzZmRW84YVRFTWV2ekNZTytiZTlJVkJPQUtMQk5nOWtRY3FhNTBJZDloZk1r?=
 =?utf-8?B?SERhZG8vV1l0VjBOU1VpZmtlcVk5UTVqK2dRcEQ0YXBxaUhjMFhXUiszYndu?=
 =?utf-8?B?SVhwWWV5M0VlTnUzZjJucDRJQkQ5WlR6WGpabStVMHNnWHVlV3dMVzljc3Zi?=
 =?utf-8?B?b1hUS2JLeU9HeHpBRFkwTDNZMndIWTUyVVlHV3pYNStIQXdKWWpvcVM0UEdB?=
 =?utf-8?B?Y0N6ditZQTBvb3dXNVJYMjlHUjVucU9JUHh3WFV4OEp5UGExaExWZjlqbUQv?=
 =?utf-8?B?dTE1SkhyeE92YXZQYmxtWEl1ZGF0cmdRSEtoQTkyNkNCQTdBSWpRd1BFOGxL?=
 =?utf-8?B?VkUwSWdUS1k3eHpVRGh2b0xoYmk3QVk4NnNHTzBmR082NGpLbStOVFFwczRZ?=
 =?utf-8?B?U1ZadkRRc3M0clJRLzk1VStRak1sU3d4dkRhU0pqVllNZE9ERklLdHpVZGhB?=
 =?utf-8?B?KzB3UkI0TnlLR3ZwakR2anFFOTFOV1RFNTNEeXZjYTE1cWx6QU9LeFZ6UWw4?=
 =?utf-8?B?Wlg0SVpNbWNVSVdEZWxESGtFeXhxaU5pZWt3M0tNS0tUczVHYnlFVU9vRS9r?=
 =?utf-8?B?cTJBcG9xN0pLbTN4SkVOZUJTclVOc1BCUnlhQkRXQ0pmQW9UQWI2TVd2RFRM?=
 =?utf-8?B?ZzMrRGxnYitQVUlNNkY3djZqUEswRjA5cTFWMGxBUm1tdDQ0SE9lUzJBWDNu?=
 =?utf-8?B?dkQyMStTNjBxOFJ1T1BtUkRwQS9LQlltSElGdHpybHkxVllpSHlMLy9uUUo0?=
 =?utf-8?B?cENxcU1iV0NVVXBnemVXK2tWK1dUWkYwUGt5aDBCdDFWNFQrZVJKenJyTm9S?=
 =?utf-8?B?aitjQ2pTc2dZTGlrTCtWbVpRMnRTdXQyelIxTWwvRGNnTFplc0R1YVV2cS9j?=
 =?utf-8?B?d243RFo3N29pU3lSOGpBZ1p1aWsvRXhSMyt6K0g4Rkx0cUU4Ni9wOTZYaWNp?=
 =?utf-8?B?ZVB2NUZqMFc2TlBFMmtwcWVHYmdRMHk5dWkwK3BJWHp5WVNWV09WTE9aUlBM?=
 =?utf-8?B?ZDYvREE5OWVIQ0RqU2crMTh4VENpU0tWaHBqZ1M3OUZQbGRxRGVmbGpabVR3?=
 =?utf-8?B?cWlQRjYzc3c4OWNTeUdTa2Z5dmQydW5lSlVTclY3Ty95MldPSkhyRjB3RzUw?=
 =?utf-8?B?UnI0a2NKblI2akZjNnNNTzgzWGVRaFFsSmR4SUhrSkpVeC9YMWhVdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f06db9d-0160-48c9-dcc9-08dedb687d03
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:35.4453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QynX6zaSupMjzzHdZ6cVIV2/a16/hltGrwhz/68wGdVht3wEO3bRDRqYI1s5Ra9G6Sv2FEfpcjxPgjs8D/bxJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB7176

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

