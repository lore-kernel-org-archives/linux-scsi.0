Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020136.outbound.protection.outlook.com [52.101.196.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E4E3939A3;
	Mon,  6 Jul 2026 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347136; cv=fail; b=W7P+QNqUChjpZhCGzIUc5YCaG/H35j8tiXwqvGH0EN5BFxcQSEqPvW2uD3AnwogT2krlwHI42NZt++Smg+joTAF4YTcpmt4zewALk8cdCg8+Ca4OJY93CCBPCcuH92Y2JSNNix1atDoTNMUrYzOVIE0/JDcbg0D8oJz+7LX3p40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347136; c=relaxed/simple;
	bh=TDdsV/I55ZZqAffWsj7qX9Ah2rjfQSGfyhKlJd6/clI=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=YnbrXWdolETJEqOGlCZM3itT3CDRr/XI6/6+Rg4hwtLtwlevR8QhxpXZCGaaqrpOBLvJECT1bJFnmx8d2slbmhll6PlS7gRCIZYlVpYeC+r0bvCuuSyyu5RJBHqges+PxmSZh/kPe2vdVcVNsQ+M97qxllJbtHN2r8NME2kKxtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=EpcHIvhD; arc=fail smtp.client-ip=52.101.196.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="EpcHIvhD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yEKIQkITvFIDLwwa3rYWrZ7PVd+V9GRi4Pa1Qa5VxwNVJGA/ax3IWTD98aveMLC2sHVxZpTa20lflw0O1nN180kDd9DzYzxqOA4w+S9TB0RypwmDW+VKS4HGHPwAElAuQpS0dGi1XUuairbk9ulgFjMsStSm/SU4yezC/YRdho0MO2MWSvYDwOozaFmYDnB4DzbXo/em7RKQTbLbYdYvkcQfsqMJNwORbMhPFrZhtK0G/H4A3qFydRBNJ35vMkx2MNVHPIQ2f6DwqKuCVvrTyYhRV1Cmod+Fez/N93vb+e41/1WE2p04kX6MtYkiNpMXYq+VP6YLv9PG18BCNKAzgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dn5GfkAHBwl6DlMqCNIir8ki6qq2M4UNsYDn2heV0L0=;
 b=GV+Zkh2ONYI+we43pKX7NX6JQPI0JdHtIULEU+FT8uLUTuqlnKaBfP1YLbzIif8bmgFQsYJh3ikFN95Mmn4IPEKN9J/hRfkGFXD5IImYkSwELzo+3WA4JT7UyVXA3IPczBnMMZxHdDZGw9SI/1DHjjDGZY5IgUkdkcGU5OcsEPHR4Q5c56iiBU/Rlu6ibWDpGhq8FLpTFyR3mY4QYDhRogc7lkJJ6ct339nSy3zth+4LHaaldDP+HDv3XXwVqYClx82bnVb4aQNSDnwSw81lY45PcxbJr9EYi1GeBitdsWGbScgCBp7exVK/Usv5nCBwYhihYNHqrZmA2j2Zf8ACrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dn5GfkAHBwl6DlMqCNIir8ki6qq2M4UNsYDn2heV0L0=;
 b=EpcHIvhDgTEkKudXhFPU0BoxAFWGZS1cCVQWmfUFEMmtdFVvuvEwgIv+LQ1EZiUKztb/r+Me2XnM3D/FcMUl4vja+bIwmoJTKriP1+mOE8dO6pWl6spLAYSmOaB+Md5ukpnFYLH4Y9IwPWd8Dn+TmqDv7oyJVKWOrX9bvnEETiY=
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
Date: Mon, 06 Jul 2026 15:11:21 +0100
Subject: [PATCH v3 9/9] pci: fix UAF when probe runs concurrent to dyn ID
 removal
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-9-2d48fc025acc@garyguo.net>
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
 Sashiko <sashiko-bot@kernel.org>, Gary Guo <gary@garyguo.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=3982;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=TDdsV/I55ZZqAffWsj7qX9Ah2rjfQSGfyhKlJd6/clI=;
 b=+DMYV7M6raQTuaiuwv5aTzj5U3FZ856wubyHoyHmFByzWMezRBiRds1a95igsvRgRKo77IoaE
 BFeunoBkY8eCcJqZILBchy+BomLG/ZMbUhl+O17L5wbpIiQnvewtbCX
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
X-MS-Office365-Filtering-Correlation-Id: b2588099-4b92-48e0-0689-08dedb687ec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	0QRcjdJtib4t6lRQHjPF24nB2zycJB6qSoVXN+3DVrkm5IYwBg3KUEXJCx+LpeLGlXtKTxNaX0xX3fgDobPVOBxITqMCuBDVn9/wJQHgWVwOd3Bi2FADxiGr8S7dVHQjzH7rHESAEAo+1OMblO+mGzwjTk2PYssM8+KpRrHdtYNkZCEbH9w/Ivu2ZWTpS49uVlKpzwTKVeMkIdfF0WcXdwtLRqPqL7GhdhRQl8WWDnLv0mM8KcEedlPi8X2l5vTHLLHS3HRSkILFZ8TqnslwL8+M22bfTLwfsgKIDOX/rX92HxedfowpqtQFU9QzIvbMDRc8C6NBBvxWa5UL9pN7v1/nH0QjAZrlmzeNcJbD2UiJ1Vj6lfsFtfes+98bFyHi5avNV9oSSYEHTP8+tgTlZXWijF3UkuIzWVfpnoaZHg2p4Wv1Rb8/PBpmbY1YeoLVblTKu/1HL7b26HJL0uUL5kA9Xa56ovnnq4s2l+ytbnqhj29mua6wa937ctJVTHyxqoYBboML2wvH/1P/rz9RLFb+YuuwvU3YDWmzoYrpEcR6ixXQsgEG2qubpnkNp0M9RuoC1oZhdMq3dA6UYo4kzqzvx2cnu97mlVNLB0zTIHMq8b7RdDyX256jX3gAlEt25/eYRF5p/7t2bRbdGdZPP8qgMRuM+ULRxydNK2YBCg8VVf+53BzDFOdGuuJlve5VwU2KM3RElUgTwdY3NW1XuQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlExWEtlNGZjaE5hcU1iRUhicThGSi9WaWY2c3o1d0JHRzhnVE1GKzZMZ2Q0?=
 =?utf-8?B?WHV0WHFsQUhXQzdjcWczMUtSQ01JRDE0amxSMHUxOFhBSjN0VVZRdk8vOXBY?=
 =?utf-8?B?Z0p3dmwrY25ybTF0VUlLeXBQNGZUMG1LVzJlVngyZkFTRytCT0RXelMwbyt2?=
 =?utf-8?B?bEZXWXdVRkpBRytOWDE3RS9uUU4raXk2TFhYMGt5S281WnVrTVVsRFEzeUpr?=
 =?utf-8?B?WUVoK2l5U0ltUFgyOUVYT0oyU2dpSVNDZWVLMjJKclpJbzVSOUJnRVlMTFo0?=
 =?utf-8?B?NHFZY2UrUlU5YjdBZVY0ODZ1bWFzL1pEbkt6QlJ6UlJmWkloSzFOWGQwUlJt?=
 =?utf-8?B?ZnZTaWlFS2JFM3pDUTVGKzFQR05UNzcrdG1xSUU5K1o2WTdac0hKQnNMaGZT?=
 =?utf-8?B?MVBPdUh0T0hVWU5aVngvaGlEdUFuTHJFeDg1RW9kMFdhS21kbGNMejUzek1i?=
 =?utf-8?B?V2JENXh2MDRDWlFDeEFiWm9abkhBM0JjVVRVeEtiTGxvZFMxUnMrNXE2N3pp?=
 =?utf-8?B?dHorM3Y4ZDVwM3VMbjRUUmRLamxaYlpPQUZ0S2h3YnBDa0ZEMk5pTWVTVU1V?=
 =?utf-8?B?VnhJNVJCUHQvV0t4TkE3R0xSbkNNSThCTklYMGpyMFNiK05qSloxK0djZGE4?=
 =?utf-8?B?SENHd0R3MWlDbWJuYSs0dUh0SytWQ216Q0wzb3RJeVVrNFE4TlhYL2NrQ0pj?=
 =?utf-8?B?N3paY0x6ZzhYWGM0VkVpUFYyT1FGKzNrd3k3Y2EyUUl6UnNrQ2JRNE9ObEpL?=
 =?utf-8?B?M3B4NUhGYTJtNTN4cHQvU3dBYktqcW11YkFySnFPRk9NbCtuTXMvUUkxUllN?=
 =?utf-8?B?MlpPQzN5aTZkK0xDenZkYWo2dmRuQU5sZHRGWkhzbFdpYUhtY0hUdkwrWXJH?=
 =?utf-8?B?bjFzZFRGVDZYVXRMRjZtOXorcTdUa1ltSkVRbHZzSjFlK1lrRld4UTJzQlJR?=
 =?utf-8?B?azdITmtOajJVa0JZMm5uNzZ3TGNtUUJBZm5uZDVVUWtudldTd1kzZTR5ZEpq?=
 =?utf-8?B?b000VHUwdHh4Wi9NaTNROWhxMWcwcFU4ZHMyNnNsbGJCMmlETElOOUNXcEpV?=
 =?utf-8?B?bHYwQ2xjMnMwREFVTTlld3pxMXg3YlhmeTlENTRuSUFMdzdVcnp3R3RwZ1RP?=
 =?utf-8?B?QW9RaER5SlZyM3RyZ05KZ2kwZkFUN1MvUmtvT1IrN0FaQ0VZYTI5ZEdMbnNv?=
 =?utf-8?B?WDhmRnBHWGVRTmNuYnEwUUluVzBlcUR6cUN3cGdCNStqaWF6U0NmUWlIRDVR?=
 =?utf-8?B?SU9DVXJSWXNhMFdrTXo3Z0s5L2F2MlRNeHpLVkZLSlNOR1FJNktMY1drWXk1?=
 =?utf-8?B?RnVEbGxPeVZ3Q3NRRFdVcm14eHZIajE4QlZrMkQwbTlCZzE1M0NLVnZxK0Qy?=
 =?utf-8?B?NW5BWmVtbW5SeHQxbnJYOHF4Yk15MTZFb3BLdklmSmxpUkJldksyL3RhV0JC?=
 =?utf-8?B?UzluM05kTXpZWTREL09XWCtSM1hDdW1YblFyZlArRGNxaU1zbGRXOXhyNVVx?=
 =?utf-8?B?MTZDcjIvNHRGMjJGcE5hYUtJNnFiZ1pRS2lKUEJ2NXVDQ0IxVmVWSEhXNk10?=
 =?utf-8?B?UGJNWGhLeTFwK0RRL0pMbGZNUEJPL0tWekhxNWZxb1ZsYW9pZXFjdDIrQ1pH?=
 =?utf-8?B?Ry8xbW13MkhUNUkrMmhGZE05Zk8xemt6LzlSUDByTmN6VTNjUEl2OGYyRXBR?=
 =?utf-8?B?L0N2ZUpvTFBycGFzVlhURDJSUTNNU21QSXhDRFJXUTdESmVjbzVScXllamN1?=
 =?utf-8?B?TEQrM2VsOWdRSEJqQkw5c2loTXhkSjZ4UG5YS2hxa0hyemN1b2tadXFWajg4?=
 =?utf-8?B?bW9iK1ppNWYzKzRBdW5seG5tOGlxRjdsWkhGQUhEOHJGendZdGMyNnFNK1g2?=
 =?utf-8?B?V0hlM09qQWRYUFVzQ1VrdjJWTHF3TUkzNzR0b3VEQUFWdjNhcGpDNmJnMXBV?=
 =?utf-8?B?T1ByQkVQckluVHRmREZESThDZUEwaTRMY2pQSmR5WFNaZmJYNGlGdWxNZU5w?=
 =?utf-8?B?cmNMdWRmSGJYeit6N0Q0NnBzN091UitGYlUwTlc2YmNrck5iQ2xFZklvTEgz?=
 =?utf-8?B?SWltVDZTRUJhUUE3MzNPVzd4d3VTTnpYUEozYzJhWlBqZFBBRGpGU2JoZVBH?=
 =?utf-8?B?aWVlTlFUN2hMVUliWmxJeGNCRWV5bzBpSWh0cndMdWlNRVY1TzBneUdsdGxT?=
 =?utf-8?B?ekJRZVozQjA3cWxjampYN3A2QWl6WVM2N1NWSXp5WnkvRko3eWMvVHNNM1Ni?=
 =?utf-8?B?MTFWYlR4UHE2RDFwQlFxYktWeTlIMVgxSkpyaHIvMlJuK3N1NXlmUXRrSTNZ?=
 =?utf-8?B?cTl6aWR2ajVDTy96WEdGNDc0OEpWY2xIKzYwdkJBK3o0RDJ3cU91UT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: b2588099-4b92-48e0-0689-08dedb687ec8
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:38.4104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZUnxxOpG5p97CCr74kSLPcruxAX7U4o5SYk2LOnkQMSb0zCHDbYESyL5Yqn/4cEENGkGBB7Ljkt0DwTnPon+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB9444

Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
as remove_id_store can free the node. Thus, make a copy in
pci_match_device. Also, clarify that the id parameter is only valid during
probe.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/
Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
 include/linux/pci.h      |  1 +
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 2e80ae150ff4..4851061babcb 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -179,6 +179,7 @@ static const struct pci_device_id pci_device_id_any = {
  * pci_match_device - See if a device matches a driver's list of IDs
  * @drv: the PCI driver to match against
  * @dev: the PCI device structure to match against
+ * @id_copy: Place to store copy of pci_device_id for dynamic ID
  *
  * Used by a driver to check whether a PCI device is in its list of
  * supported devices or in the dynids list, which may have been augmented
@@ -186,9 +187,9 @@ static const struct pci_device_id pci_device_id_any = {
  * structure or %NULL if there is no match.
  */
 static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
-						    struct pci_dev *dev)
+						    struct pci_dev *dev,
+						    struct pci_device_id *id_copy)
 {
-	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL;
 	struct pci_device_id dev_id;
 	int ret;
@@ -200,17 +201,16 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 
 	dev_id = pci_id_from_device(dev);
 	/* Look at the dynamic ids first, before the static ones */
-	spin_lock(&drv->dynids.lock);
-	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (pci_match_one_id(&dynid->id, &dev_id)) {
-			found_id = &dynid->id;
-			break;
+	scoped_guard(spinlock, &drv->dynids.lock) {
+		struct pci_dynid *dynid;
+
+		list_for_each_entry(dynid, &drv->dynids.list, node) {
+			if (pci_match_one_id(&dynid->id, &dev_id)) {
+				*id_copy = dynid->id;
+				return id_copy;
+			}
 		}
 	}
-	spin_unlock(&drv->dynids.lock);
-
-	if (found_id)
-		return found_id;
 
 	found_id = do_pci_match_id(drv->id_table, &dev_id, ret > 0);
 	if (found_id)
@@ -466,12 +466,13 @@ void pci_probe_flush_workqueue(void)
 static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 {
 	const struct pci_device_id *id;
+	struct pci_device_id id_copy;
 	int error = 0;
 
 	if (drv->probe) {
 		error = -ENODEV;
 
-		id = pci_match_device(drv, pci_dev);
+		id = pci_match_device(drv, pci_dev, &id_copy);
 		if (id)
 			error = pci_call_probe(drv, pci_dev, id);
 	}
@@ -1559,12 +1560,13 @@ static int pci_bus_match(struct device *dev, const struct device_driver *drv)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *pci_drv;
 	const struct pci_device_id *found_id;
+	struct pci_device_id id_copy;
 
 	if (pci_dev_binding_disallowed(pci_dev))
 		return 0;
 
 	pci_drv = (struct pci_driver *)to_pci_driver(drv);
-	found_id = pci_match_device(pci_drv, pci_dev);
+	found_id = pci_match_device(pci_drv, pci_dev, &id_copy);
 	if (found_id)
 		return 1;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 64b308b6e61c..92c17c116de6 100644
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

