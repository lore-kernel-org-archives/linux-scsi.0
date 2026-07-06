Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020136.outbound.protection.outlook.com [52.101.196.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D3837B02D;
	Mon,  6 Jul 2026 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347121; cv=fail; b=QV95uWv2Cs+DFo1iF6+7CZjSvuFBb3f5bIOuK0Mt5o7Cd/GN0+4d3KV6OYjm0Ftvs04X/ZYU13U/NdsPAyu6E5UpCs9c2R3ML/xHcS3k6X9iDmBXV3EOZ4DSyaEigDc4QGNNuKacjMGdjL9cky190rwWlihFrBmX8Tddlh+ebVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347121; c=relaxed/simple;
	bh=kFfIKB6rLf3rYqlBORCZNV0kLHmJM/RcViPZey/jmpo=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=lKPrlbbiMtDMsSEkPwS8dVVX4JgH6dLglUqPgEOVrLaYnCFaXmLWz1gVK03lC4Vs+KPlAJfAKoVAjXjjIEQ7JJMFf6StR6Onz7W4uxK0sEA/dF74EI11FZVqF+Xhd7BMk3JpLwpqlB3AafMzZO4RRHtGOq/G8Yg81eluc9WW/JI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=RrVGicDH; arc=fail smtp.client-ip=52.101.196.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="RrVGicDH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kYselLHTZ5bNFuE6QIV8WJT2F9VGxgwPmpy6vSnGZBP0TbskJCRxNyIST5PttWRpbjXXg2fy24a55qFLI5eP3K8qdIfYoEcWP1Ue4W3DdT8TQmCppNu9kua92k8ErEgrXlPZYBgckWEO7VMEHEo9Rb2FRuOaJq3HU3bz2wLZQNifNHz0n58bLQ4j6IoTxof2u4zPCM+GK+Rw30VxIjvWJZX+5mmskSNGNCBwpZ+w0ExlszzI6geFMWekc5UNl4GAwz+B+ZrUrCEFRDgTVp4BFjcAQcK5nbQvKQMCfIElY+NGiV3XNDO2wyZ6ZNUUlgyMsuqa41WQzwP5liZUwlsr3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdbuemIQW74JEsLmjlNZxbdKBkI6pXKixjRb0L4kpsk=;
 b=ULe2FY8iDPSd4lhBuu6e3jEBotrf5/2ZWlllA8IV1Kw5YWtGcwZPKkylPAeJjz6YH3pUkT6/Zmzlf02+52uopxqpvVn4PliC7SZ3vyuBCVubSF7WMLe7Evf9O/ZhkyF0b8GO+6aZzbUcM7d86mW6Pi8abn0lEqJJe79qOsJ9j+ulVHmf1bzGcl0qyLTWR5aYawUtazeQxpHEItva5PyhTJCj3lx6cH4lO80XltL95sdI6KcRwW7tDKH1rY9ofT9K7EGYpVUwCc+R9JbgxT8soHyba6rhsQFRYvX/cbuGSADamIn1l7kuxOKCjO8HpR/XMObJCk8+MaiFNzXMgNM6kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdbuemIQW74JEsLmjlNZxbdKBkI6pXKixjRb0L4kpsk=;
 b=RrVGicDHlxrrgaCSEv4dvRCvgdALTGiKpIXhRo4TdBBvnUem2b4T+DHhl+yfQclABl7+YuVt67jicvmxFDha8tdkOVWWMSiU1p2wbRe+idIHMqVVEBgky1afeqByNSZRhz/qCW5XJNUhEi1uB7ViXCdDyNgrK0lLod4NX3QPj64=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CW1P265MB9444.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 14:11:40 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:11:40 +0000
From: Gary Guo <gary@garyguo.net>
Date: Mon, 06 Jul 2026 15:11:19 +0100
Subject: [PATCH v3 7/9] pci: make pci_match_one_device match on ID instead
 of device
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-7-2d48fc025acc@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=6628;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=kFfIKB6rLf3rYqlBORCZNV0kLHmJM/RcViPZey/jmpo=;
 b=eQsavX/os0EzMWTNomgUJSk0TjwrQL88lXVz1F9yxQvO1+dYljO3m/5MWTGnvGr4xL3G3n3PS
 9kyi+mP83nKAlIv36kcarIG0u6mA3beP9HWmjh8cq3dY/x+OYWalXAk
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
X-MS-Office365-Filtering-Correlation-Id: cf28d868-065f-4b00-84bb-08dedb687e2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|23010399003|376014|1800799024|366016|56012099006|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	XToZJgEhr3uPVt3tQvbDvoq6aHJUz5Lo0t5UvzjO44y7czGc5ebjb+T38nPan0ZdtaBrox23305OROH+LLs6nL7f5H68l5GXUWLdE0yn+DYnixrb/1LyqGEY5+LlElirGh/FXt0HGZ9lu71ksATXPGUwGX4tWEtonWQ0/0ccRPYn0ehQ41vqnlvuVnIN8z32pRmZjsiVFwHbqGtbttHvTnakzkht3s3RAykE6xnnLjjsWd9BNTHPmnNST+thWNyMLZoCc++TIqOy/8rp0jv4rOuKzbybTN9h1pv7F2Fc1PETXrA23c+ToAnjAqbvg5TuSn+sTu41JRaVQ7NeMWZnmewFDziV1z+uitywiOv7kMd/SYPUX/CGNImbefMahdKosJRWEyOdkqpUHBMj00HSz2gN76oA0ry7f+11xDl6Rd0258oqT4HCo7c1M2nUZJLhhox7emszNNbC7s7bjYyECkQHHxIumBPkFZ8kE0e3PYQYDCDO8M2XoHmwGRQdYVczDpM6VAYJg5KtS93Kdo4OxzumTmc7nvm1UFLk3+/H5/YOlYBcQ9/dno9e0SqVx5UlkkWbdSzg+mGYbsIq61Sopt5tr85Og1gkwyYpGrQ/lImU7uEfa85+yYMt+zMufkb5MIYeWXqmjoa74SXs2mDWd5Ealo0wiNwYbRi3/CRNMMQPZeF5q65xp+bgYqLCM2JeCNMLvFP2MEqZtyREMbdcDA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(23010399003)(376014)(1800799024)(366016)(56012099006)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3ZFVTVnaEpBdTV2Z1p4cXlsT0o4bkwwNm44U3JlbUhPRUxUMDJEY21BVlE1?=
 =?utf-8?B?S0ZqMDZSdGwwTTdXQzdkWWx3cWk2bllEV3RRSFVKZlpzcU9qOEU5aEtoM2Zz?=
 =?utf-8?B?YmQ3dlRxZ0M4VUVhMEJFR1RMVXE1eGMrajZpRWhVSHY4Mm1oV2tITkxhaEQ5?=
 =?utf-8?B?QThjN2hyUm9PbXgwd0txdERORkVLNk5HMHp1T0VCZFg4MVRvQ2NkU0tGM2VQ?=
 =?utf-8?B?OUFzNExMTHdZcjZZZmt1bEJwbkprT2lDV1dXOGY3RURsTlk1NHFCa1VxZ0FU?=
 =?utf-8?B?cUZzVUVaTU1DdWFoM0x5V0JSRjBRVlRHb0NkL3NUTTJYcXFBRDd4RkhNeGox?=
 =?utf-8?B?VEYva2VCVnRJNmhDajg0YW1uRVJabEVncGFHWlRSd3l0TDNudXNvU0FvaFdN?=
 =?utf-8?B?b2VoZGJhZHdZRk1Ybm5tWVFQWTB4Tlhkek5HczhteWdIb0o1dWZqWDJjU3Zm?=
 =?utf-8?B?UXhkOHovb2Y5U3VWamMwTmdOOTRMMUFsdUVYYXZ6d3ZpaGtjeHZlNnQ3VkJP?=
 =?utf-8?B?cU1LeTV4ZklOQkF2NkdYK0ZUZ21ubWJTOFhkYWpJTXlydCs1aFN2MjJZeU9r?=
 =?utf-8?B?bk5sUWMrT3AwbjIwbWpIclUxQVBpMjBPRkV1THMrRUQydGhxZnd1WnplYS8y?=
 =?utf-8?B?aTJkOG9zZy9UaXNTSGxPVEZoZURzN3hpMVR0aEJ5anRwcUR5c3lpMUwwVDhq?=
 =?utf-8?B?c1lOcjdkSzBDenlQZS9relFmT0dwekRhWWxheWxTTDVRck5XNUwxcVdHVldD?=
 =?utf-8?B?bFh1Vkp6Mm5UN2hSUm5sbnd0TWhXK1FKR0w1NGQ4RE43QUc2N3psa0ErekFH?=
 =?utf-8?B?enJLcXV5OU1sbExzVTNSTk5La2k2eG0zdndycC8rWllMbXZMcWhDdW1GanBn?=
 =?utf-8?B?clR0aWF1eXBvN085S1c0bnBGZlRJaEtLeVNHajMwQVUwbXpTMHpZMWJWS3BL?=
 =?utf-8?B?cXV0M1VQcTZGcjBPR3llcWMxZXljT0E3MmliUHFvamtJMmxFemtacDlza3Za?=
 =?utf-8?B?R09RVjZ0cEZIV0lQR1EvYWRoWlVyOGRmLzJobVU1NWxUWitURUp6emZ1MER2?=
 =?utf-8?B?b3Fra016QjNBcFViakZXdzFWMUhuM0YxVkljanFGQi8zZDIxRUZScnNzMVJp?=
 =?utf-8?B?aFZROUlEOXdTMzhCaEZiLzZuaUd0TmJNQnd4dTNyc2VPaTUxSDM2UGZGU01o?=
 =?utf-8?B?SHQyS2lJK1lKS0MzMTc5Y3JUcmlCNTZ1RGdOU0FjeXJMT3ByaE9RancwUGJa?=
 =?utf-8?B?eU4vcUlUa0RNeEYrM21VcW5nb253VDIrbk5POENEZEdUbnVJSGtHT0l4YjJn?=
 =?utf-8?B?WmFWNkxWY2E2VVIxS2hPcWVvT3hybVZxYVduMGo5UGJwejRhYWxvMFdPOWNv?=
 =?utf-8?B?UVpRVVVMTis2ODVtUDZUTHg2ZVN6M0dBK3FrT0JydXB2Q2cxZXQvWmRrWGov?=
 =?utf-8?B?VUQrdHlKNytTNEhJL2J6V2swZlUrNUZuZG9YSjcrSWdLSGYrdmNJRk1nbFR2?=
 =?utf-8?B?Ti9ZTHBmZlAxNDFxUUJRbHl3RkJ3dmpBWEJpNHVkeDM0Und6Y0ZXb3NjRmlo?=
 =?utf-8?B?S2hpNkJ6TVR4UmxOeXNZelJTWklxVkZGdXdHMzBSSFlvandndkZTK2V5Y0xJ?=
 =?utf-8?B?OHJsQlZrL0g1VU9NS1dnellVVVArdzRGK2laN0N5a2JWWjlTcjlhWTV0M2lY?=
 =?utf-8?B?NkNVMjdHV1UwclRlZmF6dTNrb1BoWHliUUZ1NlQ3cFJNM3Z3dWhHMDlWUmtt?=
 =?utf-8?B?UGtIVHBjSW1OOGJEL0pHNnFjREFEU0RWaWNjcGxXMExFd08zdzFheGlZWWgy?=
 =?utf-8?B?S1QwV3pFY1Z2MjlWRlV6NUt0RndWN1VtVVN6R2ZEdnNvUmFlTjl6UUZzNi81?=
 =?utf-8?B?NlY2dDlUeE9BM3BBaEhhYkMwNE9HZ1hUTHJ2cHVtLzk2dUJFQk9NRzVFTlVI?=
 =?utf-8?B?V2VQelQ4bTVRVmZrT0NFeFkzSEs0azNranp6UCtkVHpKYm0wOTlkUUxQQy9h?=
 =?utf-8?B?MitxRGhvN1cyNjd2eVZxT3I4Qy8vdysyOC9wY3Z6OTBhalFRVDFUSG5lTVVs?=
 =?utf-8?B?RlN0ZDdTaWJNUXl6WmtrWnA0aXFwUFV5aW14Z2lDUzUxYW9Dby9tV2lZVGNs?=
 =?utf-8?B?L2dqeERlV01wOWR6Z3J1WDlmeGJJell3eVh6Q1YrQ2duSWo5ZXVvTlVSMlEv?=
 =?utf-8?B?amVrN1dRZTJNaVB5NUc0b0tBK2J6NmQ1TDZZV29RZVdITUN0OHRPNlZYZGFF?=
 =?utf-8?B?b0FvTm5RdXhDeWZaRm5JSDk0VEdHSFVsR3d3ZlhiS3JCbHB5czVoYzVVdlNH?=
 =?utf-8?B?blhXL1hhcmdGaFIyTXZzbFJ0RmhsZDRlQ1JkcVdiVnBHZDhMQ2Y3dz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: cf28d868-065f-4b00-84bb-08dedb687e2a
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:37.3888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62z4DiwJD/fhgaIVDGFEx3vLDWDdf6L7a6AM0BMlRZL2Jmd9d9PwBdRSmAmRJTf2e8h3aN73Milf0B/m3JDc9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB9444

There is a need to match just IDs instead of against devices. Thus rename
this function to pci_match_one_id, and add a pci_id_from_device helper to
make it easy to convert users.

Similar convert pci_match_id to do_pci_match_id, however the existing API
is kept due to quite a few users.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/pci/pci-driver.c | 38 ++++++++++++++++++++++++++++----------
 drivers/pci/pci.h        | 36 ++++++++++++++++++++++++++----------
 drivers/pci/search.c     |  6 ++++--
 3 files changed, 58 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f36778e62ac1..0507cb801310 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -90,6 +90,27 @@ static void pci_free_dynids(struct pci_driver *drv)
 	spin_unlock(&drv->dynids.lock);
 }
 
+/**
+ * do_pci_match_id - See if a PCI ID matches a given pci_id table
+ * @ids: array of PCI device ID structures to search in
+ * @dev_id: the actual PCI device ID structure to match against.
+ *
+ * Returns the matching pci_device_id structure or
+ * %NULL if there is no match.
+ */
+static const struct pci_device_id *do_pci_match_id(const struct pci_device_id *ids,
+						   const struct pci_device_id *dev_id)
+{
+	if (ids) {
+		while (ids->vendor || ids->subvendor || ids->class_mask) {
+			if (pci_match_one_id(ids, dev_id))
+				return ids;
+			ids++;
+		}
+	}
+	return NULL;
+}
+
 /**
  * pci_match_id - See if a PCI device matches a given pci_id table
  * @ids: array of PCI device ID structures to search in
@@ -105,14 +126,9 @@ static void pci_free_dynids(struct pci_driver *drv)
 const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 					 struct pci_dev *dev)
 {
-	if (ids) {
-		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (pci_match_one_device(ids, dev))
-				return ids;
-			ids++;
-		}
-	}
-	return NULL;
+	struct pci_device_id dev_id = pci_id_from_device(dev);
+
+	return do_pci_match_id(ids, &dev_id);
 }
 EXPORT_SYMBOL(pci_match_id);
 
@@ -138,6 +154,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 {
 	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL, *ids;
+	struct pci_device_id dev_id;
 	int ret;
 
 	/* When driver_override is set, only bind to the matching driver */
@@ -145,10 +162,11 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (ret == 0)
 		return NULL;
 
+	dev_id = pci_id_from_device(dev);
 	/* Look at the dynamic ids first, before the static ones */
 	spin_lock(&drv->dynids.lock);
 	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (pci_match_one_device(&dynid->id, dev)) {
+		if (pci_match_one_id(&dynid->id, &dev_id)) {
 			found_id = &dynid->id;
 			break;
 		}
@@ -158,7 +176,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (found_id)
 		return found_id;
 
-	for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
+	for (ids = drv->id_table; (found_id = do_pci_match_id(ids, &dev_id));
 	     ids = found_id + 1) {
 		/*
 		 * The match table is split based on driver_override.
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4469e1a77f3c..0567a8762baa 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -442,21 +442,37 @@ static inline int pci_setup_cardbus(char *str) { return -ENOENT; }
 #endif /* CONFIG_CARDBUS */
 
 /**
- * pci_match_one_device - Tell if a PCI device structure has a matching
- *			  PCI device id structure
- * @id: single PCI device id structure to match
- * @dev: the PCI device structure to match against
+ * pci_id_from_device - Obtain a pci_device_id from a PCI device
+ * @dev: the PCI device
+ *
+ * Returns a pci_device_id filled.
+ */
+static inline struct pci_device_id pci_id_from_device(const struct pci_dev *dev)
+{
+	return (struct pci_device_id) {
+		.vendor = dev->vendor,
+		.device = dev->device,
+		.subvendor = dev->subsystem_vendor,
+		.subdevice = dev->subsystem_device,
+		.class = dev->class,
+	};
+}
+
+/**
+ * pci_match_one_id - Tell if a PCI device ID matches a needle PCI device id
+ * @id: single PCI device id structure to match against (needle)
+ * @dev_id: the actual ID from the PCI device (can be created via pci_id_from_device)
  *
  * Returns the matching pci_device_id structure or %NULL if there is no match.
  */
 static inline const struct pci_device_id *
-pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
+pci_match_one_id(const struct pci_device_id *id, const struct pci_device_id *dev_id)
 {
-	if ((id->vendor == PCI_ANY_ID || id->vendor == dev->vendor) &&
-	    (id->device == PCI_ANY_ID || id->device == dev->device) &&
-	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev->subsystem_vendor) &&
-	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev->subsystem_device) &&
-	    !((id->class ^ dev->class) & id->class_mask))
+	if ((id->vendor == PCI_ANY_ID || id->vendor == dev_id->vendor) &&
+	    (id->device == PCI_ANY_ID || id->device == dev_id->device) &&
+	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev_id->subvendor) &&
+	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev_id->subdevice) &&
+	    !((id->class ^ dev_id->class) & id->class_mask))
 		return id;
 	return NULL;
 }
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index e3d3177fce54..c8c4bfe7817b 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -245,8 +245,10 @@ static int match_pci_dev_by_id(struct device *dev, const void *data)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	const struct pci_device_id *id = data;
+	struct pci_device_id dev_id;
 
-	if (pci_match_one_device(id, pdev))
+	dev_id = pci_id_from_device(pdev);
+	if (pci_match_one_id(id, &dev_id))
 		return 1;
 	return 0;
 }
@@ -418,7 +420,7 @@ EXPORT_SYMBOL(pci_get_class);
  *
  * Iterates through the list of known PCI devices. If a PCI device is found
  * with a matching base class code, the reference count to the device is
- * incremented. See pci_match_one_device() to figure out how does this works.
+ * incremented. See pci_match_one_id() to figure out how does this works.
  * A new search is initiated by passing %NULL as the @from argument.
  * Otherwise if @from is not %NULL, searches continue from next device on the
  * global list. The reference count for @from is always decremented if it is

-- 
2.54.0

