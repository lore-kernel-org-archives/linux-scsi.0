Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022093.outbound.protection.outlook.com [52.101.96.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115DB3B95E7;
	Thu, 23 Jul 2026 22:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844088; cv=fail; b=qYS5DGoXJyoey547I1ajoWwl13oRxKOIcGNFx+qloD2ftIQ2vkrwRfCa7JpqNrxN5+JZl9CI/VzOILngwxxz2AYSsSegBoSMy53BcdpXb/glpjDrnq0yVq+6/7D138IBrJm46btSchqupep6+QNCwJmrZitIOrv8o9YcmCFPM6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844088; c=relaxed/simple;
	bh=U7uXjdSKmDse7k/sCbcN5jPL6x6YmINvafdMIYA71+E=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=t/Pw/txMH2DHmleCeI14a8xOyIR+FH0nT3aJnvY7CJuIofvLap1WfKExrxvgggKR6AJJb7br88xcQLcMogd2z9C44huepJLh9vqpTIq2RMA1OkidHWBmROnMZYVpkq3Y2QIc9UpmXsF3ZkEShrdyiWkauwj8T/U5RhBJjdcJicQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=RKPwXb/q; arc=fail smtp.client-ip=52.101.96.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="RKPwXb/q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4c98e/m2Mzns/Q1pIho9DnhCGoW/wTOroNfhzRIEeshykSP3sMjysY1bOzg7npXBuDW5yGmX64nYe15LOJ0iaEEtRSxBpCl1hbQVKuDOFitHIwPIRE4N0o0qygD5M9H2OaOQkR3c6d8ctCLQ2qwZhp2enLwrvNXwTn0P3+qptZ26NaaRIHvm1Q392/QWzK4S9FBORY9sH9/qL03rGoeRWJbLK11RPXRcKI4gLdVTEmGw4NvZI9fwq/nG32HL3PhqX0yl9v1O/U3l8FzZma8nyvKEZwgrgVjfLphTvluSZU/abHo+MC60OGHoXippYovKlaFmIZHEEcnphUJZRBT7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8pTx+hmMFStEfx50Hw+BD+74x++0Ir3LXQJRrbKqSA=;
 b=mWSqBLauqC60u2rhGVSZvBjlitfXTfur5hQtEi/ITXruVnfarZtQOrB1DFvrMr3jjJf1NYaDFsegh5YExJaLW/AnSBWDRSnUkstGoP5m6zCIPFU3G4kvQJFewjHhIq3pwv0K/nJ7FTKWgjClkg6TDf2KZqIGaSl4EGTJDF3W7bT/AIxJFu3EDlkWX9J1fG13grrPGtHzsTnW+bNxqShe3VSw6bfve8XvYfD36ZQkEqVUKMDciYpfYdpz/71pxbvEvUnmt5v8Tp/dx0NupM1T3ReRi7mc7SshMc4MOcS/aPlXRGRnKwJZMhtztt9HuUOGX/DFhG4G74DjCWzCjduqzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8pTx+hmMFStEfx50Hw+BD+74x++0Ir3LXQJRrbKqSA=;
 b=RKPwXb/qk/Gd6ipjBuKchsEAN3o81pnrMBmEKgxEk4ZWmqddFx4RCSaJ7LfUX6mwXst1ZJtxu52N/OdsMVyeYrNXTjgR+P63FDO7RZIyeVUMLC1nHj7+o1SU85TYEDgFvcXmkI95Ma6uGTxCfbpUZm4XMnMrs99cguZD01TrHUM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 22:01:07 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:01:07 +0000
From: Gary Guo <gary@garyguo.net>
Date: Thu, 23 Jul 2026 23:00:40 +0100
Subject: [PATCH v4 1/9] ata: ata_generic: don't store pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-1-3580726844e1@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=1540;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=U7uXjdSKmDse7k/sCbcN5jPL6x6YmINvafdMIYA71+E=;
 b=0zcBkx1mfhqNGnjWeOzrl9U1ciXvwYK4rHnE92uSFQORZQgi3nYIOcL7jVTB5MF3m4tkEZ1hv
 UymJl/GNodfDwMC21QZ9UeSEM7jkSCWwu4Om4mGv2KQ2//ecIXLd9DL
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
X-MS-Office365-Filtering-Correlation-Id: 2fcf005a-0acd-4088-2ab1-08dee905e5f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Xoy61JP193PzPowYtb4vMterJAdikL4RHTZyvx3nnJ7yaAJcUtHi1az/kff02KDm7GvAXOvPpNvXlvFBKiRBswAG+bC3i2Bcs0Z42L1F6XtBcvV8M+COfIBVlzkxhTxiCAVnL5EBH67db7GV+1mEKrnjfxRvlhplqMxpdwiB3o+515orsYlOG1yQInsFPRiIM9vNeQUZVaX/VR7uO8E0QjA5HbGnzqIx95eh8eoYGaVlmFOPCu8cJfjC9FHTMxHAgRNCc+Z25Ms3wig124YpnLnN0VwSDCEyRoV51qeuMZZ9Ngs0PPni1mQhpo6kSrD1B1blJ93XCcx97PPIWiSZgoXGdHUXrwzq8aY2f7nu340mGO9NtLKwAUZO3JyWOvSogCtLuY6jbygGlp8QAEHegmyAeKRqMF9s0NaSR+BiWXk7/+tdr47/cd5fF4sXGMjqYG9JGDmr0fS7h8Xnt7FtWtfEldEcDQcp6Dio3q/XVX+6/JA9DiaArArMLy7twS9sSWqUk7rT5PuSsgVWY6S5lH8aEK47qwFVpL29LGWCER3RgUQQdR+lH8wIPAC/Lb5rkFBdnFS4CJuu9mcmifD9a5uNQpJcuGFSDd8vKP67y55/BUoJBn2e/m1b/vNhmWXjTrP9yzKKd4yW1WPzMxrWL9OR5PCQVduOcSHoCok3Cf/g4at2/cUuJL2YwjYbeWonNPS/QTclR2mJz9MURvWhhQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2RoSmt4Zmp3MlNXemIzdlRLalhiUk52TTRGR3lmc0o2S3VGWXRrT1B0c3FT?=
 =?utf-8?B?S2YvMC8wcHdEMVNwZ1RxdFJldW9NQzNtRUdYQmNCRVJxWEF0elZHMEVMd24r?=
 =?utf-8?B?OVZ2UDVoYTBJbHVqWUROVkdtY0dtZ2V5ckFIYWF1NGJZOEdZNVZIYTBicEt6?=
 =?utf-8?B?TnhvOG1RbThsR0lpbWRtcVNkdjM5ZzhXamZoaFFoc2pONFBHdHdieGhEcXo0?=
 =?utf-8?B?MUY4NCsrOGdjZlI3MUZHWlVrRGJScFdieDlya3U5NjMzOXQyRkNCa3pwK1Q4?=
 =?utf-8?B?Ry91Y05JMnRuNUxlY2NROUdIWmViaDhwbW9DT29rNGRmUTZqZ0R4cGdHZEIv?=
 =?utf-8?B?bXJkdlBlZmpyb3pLWW55aGk4aUpJRWZ4NURGa3h6T09mOHM0aWpiYnY3U1Uz?=
 =?utf-8?B?LzlFd1c4NTJZbW9yZjhkYTRLRnJwSjBvd2pNS21qekNUYlJUc0Y0amQxTS9C?=
 =?utf-8?B?Y1NoTy90VitGS0lCTWs2S0hTSDBvNm42L1NSWHpCeFV0dW5VNkR6R1o1TFhz?=
 =?utf-8?B?UlhzbDFtb1NuTjJ6RVY2TWpNNnJZR1M0Znh4LzVmUzZxcHA2c29PQkt0TjJS?=
 =?utf-8?B?R01TKzlUbTgvTWlrUU1lOGRldDBhZWFGSXdLMmg2bGNTRk4rMk5zUVkxNXpm?=
 =?utf-8?B?SC9GQlRHNTVEMFB4SWNIUENGM3ErMVhJTzY3ZFVhNlVRS0JnYnFpZ1c1bWdO?=
 =?utf-8?B?RlNrN3EyMG5WU285WFpjTHlxS3c3VGNJenJ2L2MrWUlCTTBWQ3NSbjllOHVB?=
 =?utf-8?B?WndNVVF5QjUvdGRmNi9TcVVUczBVbkYrRFJqWmhRRlQ3Q0tSejFEYTZvazNl?=
 =?utf-8?B?dERvYk43aGZGM0FYNFF5eDdkaXFGaWhXRmNrSWVXS0xNRWpZcU9UN0tUZEw1?=
 =?utf-8?B?RXlzMEgrNjhkV3gveUIySG1oQzJDd05hN2RBUnZSWWdHZTNoL205TkJub1ZV?=
 =?utf-8?B?blBtWjV0cnZLbUxIY3pKbTExMTR3cjdYbVA0ejdzeHZ0T1M3VEhOWFdkRm0x?=
 =?utf-8?B?U1NWbzBxWXlIRXJCWEZOdk5uWiszRERTNE9jWWlOQ0tMZmVEKzJnZ0krZS9J?=
 =?utf-8?B?cE9EVzZaVnJUV2g5eUN2SFBwVnVpelJHUGc5Q3VSL1RTMWdkVTEzSTZEQnJQ?=
 =?utf-8?B?QlBNYjVSWFZvczFvMXRaWXlGMHdTNU9ZMWZ2L0s3NXRqYmljVS9zaW1BdDlP?=
 =?utf-8?B?UmtyMElSUnFBcHZFNksyMmtxTXBISlpQY28vRWVLOHdEVTQrTVJxM0FlYmJV?=
 =?utf-8?B?RHlENjVQa3hac0VJekJPdWJ4cVZYa0Q4U3ZPV3VxOVh6cFdDYWROdFpRSXNE?=
 =?utf-8?B?UXhYZlJBVjNTSmhGajlwbCtQWERRRnAybnY5eUhxcURXby9vK0tjSEdSK1J0?=
 =?utf-8?B?dWhneVJNQmx0dVJFQUpsVnJMSVVUK3JZRzNINzMwdlk4V1ZHWnRlUDVnYTkx?=
 =?utf-8?B?K1ljWFhBZytsQmdYQUx2RHg4YTlVTUhQTkZia3hkZHRYcE9Mdlp4anFhV3VI?=
 =?utf-8?B?WEY5d28vdkJQTlFMYVFaZ3dIRVdlclNyTHl3RjJLeXhMdTlrc2V2Zi9PRlBl?=
 =?utf-8?B?TjVuR1hwaFQ1RVhZcThNdXhieG1FS3orQmZocGhPUUFQakN0NTVraTRJK1A2?=
 =?utf-8?B?WHBiOUducE1YVFVERXVBc1R4aDBwMmJXYkF1QVVoT2FEUTdBbmdoakpRek04?=
 =?utf-8?B?d0xnOG5pVDBYbHUzbHZaREl6bHJ1MkNmWmMvYzYzRDVLU0RJQTZNZWtaVlhZ?=
 =?utf-8?B?NFg1dUNZRWNybGRoUEtOOXV3RE1nQnFKeVVBOHdVenJRejNlSWNpSU92NXE0?=
 =?utf-8?B?YzhxU0tBZUZBdkJvOHF6MjlsU0MyVm5zV214RzZUWE5ZM1ArM09pdzR4bldU?=
 =?utf-8?B?UmxmTFlFZ3VDVXN1VUdtNmxLdmRTMU9MemRuQlFlL1htSGxLazl6bThZbGVM?=
 =?utf-8?B?MXdma2taZlYwTXh3M0RYSDhTMjFiaEpyaTZ2SExrc2NqOXBoalQ1WWQ4bDRx?=
 =?utf-8?B?NXVDQlNQVnBJNnFLRCtKS05ZbDBQUVJHWmFWRy9BakJ2cGJ5a3E2RExKTnJH?=
 =?utf-8?B?cU5zdTZtcVY3Y2I4YktkaEl0QXlzUkFRZ3pIUEZURWt5YUtCSFlFSmR5Tzc1?=
 =?utf-8?B?bUc1c2Rnc3l3d2l0Y05rSnY5bThQWHlkWTVUZTYxNVpsa0VYSnllOW5jemQx?=
 =?utf-8?B?dXdzUkxNT0EzVitjMU1MM2FMMnArRFpMVlRTM3BNMWljSXJxZnNvaGZ2LzI0?=
 =?utf-8?B?N2h3dGNXTFJ3bUptVUQwaHpnejAydENpc1dHQVE0NGw0RS9PQ0phWFMyM1g2?=
 =?utf-8?B?NXl4TjlBMUFWeVNoS09YQjU0ZThtdE1XRzRyNUNSeFJQdXpldERnQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fcf005a-0acd-4088-2ab1-08dee905e5f9
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:07.6121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rr0tRCEvv+s2DeO6ai2svXF8PK+tu2Fwne1LcZMDRBKClFLY4jrPbSo138V1pC4ICf9pUxtqRhWonDISBpUfEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
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

