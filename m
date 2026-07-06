Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022093.outbound.protection.outlook.com [52.101.101.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D743B3793A6;
	Mon,  6 Jul 2026 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347107; cv=fail; b=YZJf+/296lwtRpFudNzLf3tO6lODufZ7hnqYhooS41AUVRFvQfzD+lyqTyEtFmc3ndddfaY+gIGsqkBb6xbnqBYPdn183ggLR8W73U1E4+hbAgO0d6qB2Y+FzXbJ71hLZgDUZ8iO6TrVfYYSqKMbyBF0u/t8LeSwKtx+ypQhfDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347107; c=relaxed/simple;
	bh=hgLPWjQaUwagNcLXsPJWrpRlC2DY72pxnf8mOZiCdOs=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=P0huRAC11Z9w3FGbpANJ3YqtTd6zksMF3wr1xRzMfAp80RYB1UenFucXrW7xGbvOLI8bykvlJNJiq7L2H5hymQRmm+SgTt8QT5nC5FASbfM1wF1YcAhV0b2RawHjCE4TWB+4nC6EAjHS0VG7VUdudySUiLNA+Bg4+THjMSls1Js=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=mppw4seV; arc=fail smtp.client-ip=52.101.101.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="mppw4seV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T6t+vgK2I2eqx3XOdsV9SXXyAO/vEaDlEK4izwfK+Iukx06WTgDSARRhdl6IvQ4Nir8k7a17MyrbXqYvHJFMhlIiW/5+4M6kAnIvlNcJLa8+Jm+wRRiocx1RrNiepnW/wROg36KlEVxJlosTVUOYphJvOuv4bZNbaKevO7yotu+MKRBqbVwavzO2WfSVU462fNSmPQrqCGB3y0UC98u4E4giT6rd6dlPhKeeUOcvHDscZWDKE9YS498a2wgriKIkrj+nl+fZDuAfc+TvuftDy8zdbV4+zzp9uFVBB36a2mVH1bUHaoEJOHzkfdTlqFaRgbTJHQ2SCZA4AhKpPCe4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNmRDXktq4l0Pl0CNybrMyJa+6ejGjiP1Zg8Zfoh4sE=;
 b=k8M4vYxw4vDRmIlpKhgQtM7b5cerSymJqyVIq12+pgs3ISSQOy58Ku75r6mKYu49IrGeCcrg0aSYE+P39D4o6TNTN1r7xR+Z008QswXFSR4TqQX+h9L7hxcl/XV6GaV4WRt5zL1ciKwDBvHCmujvE3jEVrZUJ9yaU7Ej4jWGZT9Ghlp/zJ/r91tQfjiZD90ubVYshirtJVkslzsSj0D3ipfM/yovIgMPjBO9B6qnGB4KEFdnmkp20RimzYUpz/9/NfdUvHXruWo7tXHgxwJk7ZkOubOJ6pF9pEdwK53Hqae+zfFeLK9yhVQIjNeCiDJRAr2CVJHuoixGafEe7DQSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNmRDXktq4l0Pl0CNybrMyJa+6ejGjiP1Zg8Zfoh4sE=;
 b=mppw4seVpl2C/qz06jZADOk6lj4wSRHoQb4X5z9XKBBYYfEe/zPvLuxaA5cl1PpmlsV5XAzdlH9ENh3W2x/5jomQ90nz/H1dQLANlm2YgR1qLN2ZfxZza3KWgFeMskFR/nCvmkJ66391UMFH2iFIcHLgN0qasqB6+mI6XsCMCiU=
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
Date: Mon, 06 Jul 2026 15:11:13 +0100
Subject: [PATCH v3 1/9] ata: don't store pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-pci_id_fix-v3-1-2d48fc025acc@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=1493;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=hgLPWjQaUwagNcLXsPJWrpRlC2DY72pxnf8mOZiCdOs=;
 b=TXMCAoW7M4zOu+3jdJGFlx6pPlVTiCpgn29UQfZbn6jtMhLxrOSOw2oi3PZGOBB5awdwMp9vG
 qf8F1zFX1gYD/zZCWbzy7+/jDTn7IpP0RihdiiNJK5C0hRboMWKzcVp
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
X-MS-Office365-Filtering-Correlation-Id: 1425410e-07b1-4ace-ae6b-08dedb687c5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|366016|23010399003|7416014|1800799024|921020|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ieiEoOzBxHNbqTAL44lyGzGLbkMf7aI5thpEWX/0Rtm1/1M4+1xFM1ZlP0A6XEWZpQUY2A5lk+GYj7DJDVVLazYirk1GILSkOlI4BbHoBId6kN1eHfSju9L2qVnFPCsoTbvU7vkQs7uZFOoaUtU+3MKCqlmr9BMSbFJukM5qN0bpjkdKEXFOv0M53aXOkvo4+Xp2d/M7wHKGjqFWKu9jPJWsBeNNqoN2kXknIBg97UCMFjnM6ahLbYS2hs8tXVLD1/RD9lN1+baDg2ahvI7dlP7FbSPMBinLA+LVEGWLCa9wuUidu+UK9cx+nSU6TP2odFmrhOoTXeTFfqpv9rdzcgSP22dqoV2COVwYvc3gqYSVLKnU9pfloCbsbh5EhIqR7Aj2TPDFMZMaAV5C0REowTdNjUw7DJ0/kJ7IoEzA71qJfkU0msgBs4QaKU/GOdFSdRpI+dvT6YamWuvptxdtYIbtuQIoUL1CD4Q/Cmt6waHTwvWoQw67w+N3Nvrb9tyJoqIowOsVKu3qbuIP+Fugo1KFf+A5OBPau8YpzYWWUf/ZwYcl2apZZi9OswDzzW6uL8nf2WICjuC9ZPueKl9ClqEASIex3N+tNiRsg45mL//033YbfWOICoNM9SUcu7Lfh0wnMetnG1mjBDeV/KG9xpDMerSDSVOkCtoqZSgNKUiAPifsh0DvXofGED/nflsfiZhRzqwFDTd8x5UB36KDpg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(23010399003)(7416014)(1800799024)(921020)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnZSRHRUcElJbVhBSWVuS3IrQUZuS0N6MXgwdXhPUTBWRlUrQWdTNlptOHJU?=
 =?utf-8?B?Q0d1Y0pETkF4ZmxoSnNTZXUzbEgyTDdrVmY5YWFlZk80Qm9tUVBVaGQwSDhW?=
 =?utf-8?B?MnhRUHB2ZEVEVUo1MTBLMzhnRFlDbnJKcTFvRmxFTU9RdUlzcUpQT3pEN1R3?=
 =?utf-8?B?ZlJBYnBBWWNDaVBrZmJIK25pR3ViWFBRR2crRmlCOHlBQjZXei9XZ0NpUzBC?=
 =?utf-8?B?OVNaMCtGOE5FNnRaYmdKNU4xSWFpMG03TnA1elN0aHIvOGhMazBtdll4aFNR?=
 =?utf-8?B?WU4vVUxQanRjYUNXZkc4R1hsVXVVZEdIL2pYZ2RYbzIvMVc1NEQwcVdVa3la?=
 =?utf-8?B?THBqQWdKTk9Ic1ZTcXh0SjhBaGtlUG5DTk4xU0ZYcTZMUDd4QkllNk81aVFZ?=
 =?utf-8?B?SWRlNE5BYk1uaGlRSTlTcUdjejYyRXgxUzdMRXA0SFZtc3lmdFlrWDJ1MFZB?=
 =?utf-8?B?c21FRCtnUUlERlRPVXQ1ck4yV2piMXV0c0VETk1rTmtQdmFWZVpsQVVxK1dJ?=
 =?utf-8?B?YXFVOHZIQ0pZNXM1OFUwVFU3TCt4dG4rWVdCSkJ2TlNwUnloTkkvVERLL2Jw?=
 =?utf-8?B?bTg3aVc4bm41TFJaKzh5L3gwUmk5UndMYjk3R2lycHBBZWpPWW5mZEkzRm9Q?=
 =?utf-8?B?akxUMjBoa0pscmN3dGd1QWlDZnc4OXo4NHFXQ2lTZm5oTFd3UmNFMjFpSzRW?=
 =?utf-8?B?NGVnckl6dklBQUNPeE5ub1dPVnZWL3Y2SEd4TUIyckRzZXdNU2lBdk9aWHoy?=
 =?utf-8?B?SWFMU0JMVkxnbm40VXZMSy85T29ZZ0V5bmlPblhNRTlIckx4QUZVYm9LYlN4?=
 =?utf-8?B?M2FadU5jaFljVnFvTEtJYmZrOVJ0bGJRQ0I2SlUzQkJDd0p3U284ajV3VnJQ?=
 =?utf-8?B?K1JqTC9FalpnVHNLeWl3T0tGbTBSS04vZlR4Q3hzdWNPUnJPSHpTeDN0aGNS?=
 =?utf-8?B?d2x5a29CMC9WSEluQmpnWlNuZVNRZ01qeDIyNG5TY1l1MUp1akxxOEt2czY1?=
 =?utf-8?B?NldhdFhGb0pjZVZZd0hXMnVNWFpmeFZCN0QyYUlyaEpCMTkvUnVFRExuT0tY?=
 =?utf-8?B?RTJnWDNpbCt5UjRSL21hZ254MEhzcmNMWVZaU21iM0g1d0dKZFZPRG5PMENR?=
 =?utf-8?B?RVlpVW5PcnhRQ3lUeEkwWC9wZ3pZOU5wQnBmaTJmUXVtdk1wcEtHYmh0UHUy?=
 =?utf-8?B?RDZwNHRlRmVvUm94RmpOblJ4Y1MwWkNXbE1UdEY3VkYzQVBhUWI5ZGJJQXlY?=
 =?utf-8?B?SnkyRDFhY2xhYVl5UFBpbjlzVnREeWRkcFM1NVBUZ0Rua25CRlQ1c0Y5Wmsv?=
 =?utf-8?B?c0dURFc1L0JySjBLalhHN3A0NnVGSitLdHdLS25ja2wrRzdTN1picVBTZ3Qy?=
 =?utf-8?B?Q1lvOTdaTHBsZEwrV0hlK3hCdkJGQ1pqMHBnTmVHeWF1OFNZdTVLeHYwcTdI?=
 =?utf-8?B?N016TnBVcUQvckJPbGk4NlBlVUR1N25GSEZ5SVZQSlF4NVRvQUV4UkYwUHZq?=
 =?utf-8?B?eEtVZSs2MlBVZWxIYWF1Z2V5U1U1aWsyT1p1OGxQYkdSK1dxMGZZUitWcEZH?=
 =?utf-8?B?YzNjS1hhM2pad3VraVBRdzZueThIajZkTUNLSUtEaDVzYzkrc3RWS3F6M2lP?=
 =?utf-8?B?WW1oc3R2R2l2TDhrS1VrNVVrekNRcFZrdmMyVzBxb09EbkRDWkVUdmRKbVJW?=
 =?utf-8?B?YTdPZ2h5M1I0Ylo2QkdFb2N1NEhBUm1TRXNCQzUvSXkvSmpjUmx3Sk9HM09W?=
 =?utf-8?B?djlibTZLQnRvV0ZrNFdDRk9PZWFGbm9xMVdtbUNnME82SjJmU1ZoTWRHL0cx?=
 =?utf-8?B?bGdYUjQ1R2trRUdHcnR3NXFnTkdoc0hSU3Nma0wzSVpXa0hiS3lGSE45QjNW?=
 =?utf-8?B?andKZ1dZTHVwZ1hPb1VKVzMwaTY3K2o3b0hOLytyRENRdFZnSkhmZFMvRmZo?=
 =?utf-8?B?L2pKTlVhNm4rRjJVdW5vQ2NaRmRZdEFmZEtma2x6RXBFRzhYVDNUY04zUUpX?=
 =?utf-8?B?Tk5YVWp6VEt0K1EyR2xwVDlLZVY4cFQ3TUlydGhFUWJpVTJqL0owK1Z2TVNQ?=
 =?utf-8?B?RytQQ2hUNHBGc2ZpNmJKQjVYdjR5emRzWWJRMy9kNDhwSkV0aWg4OUhXaDRs?=
 =?utf-8?B?OXl4RmxhWGJLZzdoR3dkN0hab2dkYUlPY3EweURvWnh0ak5pYTNiZHJlUTFk?=
 =?utf-8?B?Q3pQN1R0ZFAyd2NGWDBSYzFMcWtDbHdtQzBLRE1LUEZKZUhsZlB3ZHZvMmUz?=
 =?utf-8?B?Y0lIcFhoMmFLRXVIYnAvMnFlTWxwa21tYzhSQXZPZ2o4amhLeHVPSzg1alNL?=
 =?utf-8?B?YVBiVVBPSy9hNnlWa09WbllISi82Ni9ENEhDOFB1OEw4NTRaQTQvQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 1425410e-07b1-4ace-ae6b-08dedb687c5f
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:34.4235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/mDhsgen0QH085rScHkM1kYVuyRbJuQIsiKDPbHWWhSNojDV8mXCuEvCCr4AKTnn3YZ0Qt34GIRo3tNzextcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB7176

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/ata/ata_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index e70b6c089cf1..18ea740ca582 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -51,11 +51,11 @@ enum {
 static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_port *ap = link->ap;
-	const struct pci_device_id *id = ap->host->private_data;
+	unsigned long driver_data = (unsigned long)ap->host->private_data;
 	int dma_enabled = 0;
 	struct ata_device *dev;
 
-	if (id->driver_data & ATA_GEN_FORCE_DMA) {
+	if (driver_data & ATA_GEN_FORCE_DMA) {
 		dma_enabled = 0xff;
 	} else if (ap->ioaddr.bmdma_addr) {
 		/* Bits 5 and 6 indicate if DMA is active on master/slave */
@@ -206,7 +206,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id->driver_data, 0);
 }
 
 static const struct pci_device_id ata_generic[] = {

-- 
2.54.0

