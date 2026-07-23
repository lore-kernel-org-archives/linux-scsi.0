Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022122.outbound.protection.outlook.com [52.101.96.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DB6350D74;
	Thu, 23 Jul 2026 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844081; cv=fail; b=q9bHABPXn5uqe2BWjYKQMDhJ+Oa81rX6PFNSGqio0olRIMwMGBc7/iVHN2CutfIsONNo2hIPJefavSKjMk0BLRm7ZNmg1ivM4ZFtn1Kk6sW9dvoxM8yhj8HRofiJgtGFIxg6fiMmDP/RDa+DhiGPC39F48Brsjt/Qev0UjyJ9gA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844081; c=relaxed/simple;
	bh=8gJVnailyzMYXVEeFt/Vs6x7yjYC1eVNKx3NdE39Fcg=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=igHhgbJWFvUAP2huL2nCZyda2oa1t2B7queuYU2oGupoGPFYr6QwHj4T2KWbio4CABgHaE/AcoL3961SGZQJ8KHEfR6w3WqBflLWWBjBq41GXlleDYE55oZwO+mkZWikRVBJrgACLdEPN1Sgf/G3OfSS3YgwwEUsYcqFjGiy+bU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=LvM2Vqib; arc=fail smtp.client-ip=52.101.96.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="LvM2Vqib"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NhnNX9sXl26WB4qUfrL9QXLd0Kce6+g5da49eA+o1o5vJ1ihFtlQkRmbOL265IMYn7RWa5BGs4I0+wZu8jtPqZcfEfrigwPml2CMY/wyQZb4tzJwOcnhd0cmAhe7B95t+N78rENQb0Nylw8nJ2Nu7HA0ODniAOXXujpKC4M/uGP4Mj+C5/6y+SpC7Mfl8R2cBdcMRlxveUT32bvhzazmW4JnaPph64GNuLm1bjaYL30LBF5xDLKf+QP1tz1wkt4LPyZqvO0/b2WzriTQKymrlDcmiykQ9eik2kyLNyvFaaoHHB92cmV138S/JJUKiYQXv0kH9FA6VVzizO4wRtYqHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xq9AjxX3EhxMdox1zaGtdiqE4DTflnHv8h5VPtjrvBQ=;
 b=vCK6ni/ihXEM9h1ZtrJgzGrbmCIuxyq6cBOoVg9B/mffKn23ZD1qgxlF59f4g0T8D129LEgMSjRLei2HEpVnsvG7vwgs/Du+vdsl08O38pnWHTXqxitLvuQVU2F8Mswzgln7vJXN8+scbpCIvhbMUu/H9nQhdImEANkTBFJNsfffnLfs4Xhk6Ucu09fRpQE+GMzKvzV6NrSwIam+Q5v8Riy2NyZHmZr1fbjp+sZWA2iyUE3wmktJOMEpeg0CyVILBxeQUjnHgW+/SbqXvFkBBH62bzCE/xX5HMsQi1+obKZY0+k/GQEVH0CD2xVVlh98HY6eZNXwOs6fCWDMbY0ZGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xq9AjxX3EhxMdox1zaGtdiqE4DTflnHv8h5VPtjrvBQ=;
 b=LvM2VqibrDmaBZkVLKbRLphHMgzQA5A6cjWO8mUIksTESeSEnZtd8l7b//jJOmiZBkvDR5XEsgRLvdLMFDid2mJWedqrqqayeX3DbpUQ0e8KVDnqfJWMwNirlxgZ2WWK2SwJZchxqBXVcE0IksjkzZWboTpeZe927k7u9lvdkBc=
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
Date: Thu, 23 Jul 2026 23:00:41 +0100
Subject: [PATCH v4 2/9] scsi: nsp32: don't store pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-2-3580726844e1@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=2148;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=8gJVnailyzMYXVEeFt/Vs6x7yjYC1eVNKx3NdE39Fcg=;
 b=+Y+fiGQUF5x/hbvd3vvEL3to+g6aAWun5gT/qaiQ64JweWsJ3wp9j9C5yS6BaYpiuQqXRxemS
 6U4y96CakbKB4N5eQRmmZDdSo9vrXiJizoriNzEYw/xeztOELvxLcgS
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
X-MS-Office365-Filtering-Correlation-Id: 5a64cd77-66d5-49c8-abf1-08dee905e638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	btJc6/u4K18qirAM0S1yJV1b5uaM4dGG8/OAEuJ1h0D3A52vkkOuSmBsWVG88/j8nOfMXuw5eUdewsMSbN6pU/uoY4Fp/1srjPa4fbGvx7ARdnDiSs8/DcASSmm2Bxsr2tv7tGOImWTayRVVsTHkeoEdfVLVqSxHmCGm4EnMJ7yqtxCB5WS5YHNr5QsZfhdW7hFc9Ds7f6PRkL4QDHSUmam+Fbu7dAq+SqP04KcmDN37V8v1pzF/ttNAxYFcOtxzsihega+ARcnJP/qeJT/2Zr1mu9yl+fN085izilbkCEaKhch3LBpYBB2u8/njMdFylRxkgOyeHovvUjvy5x7NkFO3KucUr02jlgn9yecBxZ2alE68Z4qRkMfL6HyKQ1XYMqTAESgtgdLzX/u5fhPKHPZZhyeEd1mQN+QEHExvtQ60jWc1QtYaV6CAWsl0Vgz825/nEwybgSgBYHHqTCB9ZE5V9JbGhxlWE79ftA0Uqb856/QxZrj7PWkZCkj9NhilruP/iFViOxj2xlWL94NHK/rMF7sgmC02bbAzmScspMx4XjMeRjHtC1lCm8nJEiGMGD4IeOzyFolvds+te98F+XxrvT5aLeYqKKs4yWhYtAlWz44XfBjriiu1jgkHV8Z5hVltbVATKAozg4WU91gu/njq/R64OSBu2/NeCU08PsCgCMzbW6vf5CD62BP1Rh6DUyOUludaNSRRGqrY6Ig45A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEVtL0R2bVdpMVBVVWJYdnZFT3hiOGZNdmhQSGFvTHRnb3VRaTR5Rk9nQ2p1?=
 =?utf-8?B?OXE4M245eG10aG5NYjhNS3Mvd0gzZFJzNk5BREpOSlBiZFlBeU5udzFDSk03?=
 =?utf-8?B?RFFTRU1PbWtrd3Y3ZitMb21LUGZyTGZRRTRLeHd1RHc0ckFvbGRhV2ZVV2lk?=
 =?utf-8?B?cUp3Uit4NEIrcW14Mk1pdnRxeDUxNE93ZGhOSzRMZTI4OW93YVpDaTRkL1dy?=
 =?utf-8?B?cFhNV0FZUDdmSzhpZDhBeGQ5OXJZUlR5TUUzbU1TaWc3R1lFZk5xRFNBTC9T?=
 =?utf-8?B?UHpBWURRY2JrMWJPck15b05YZGNOTFdYRkp6aWd6bnhiN1ZiMFV2RTJNNVd3?=
 =?utf-8?B?L1o5WFBjYkZ0TFd5Y1Y1QitoK3VRRXNKYzRXakVrY2xSang4T29LRllHc3ZC?=
 =?utf-8?B?TzNWN0tZK0d2SGw3d001b1ZaOW50MkZiaGRaL29iTW93YU5xTDhxVUQvYThv?=
 =?utf-8?B?cUpnVCtBVVlSNlZBTXVpRlpZT0dxZ0pLLytwWVBvUzdjRHJrUHM0akdydUJp?=
 =?utf-8?B?Q0xHRHI0YlBPMGJLbXBEdmVhMlo3a0tPVVJRMDBLTlhmTTlhb0VicSt5QlUy?=
 =?utf-8?B?cFc5MnpmSGRFeDlmZGFUVk4xMURqSE5BTnlxR1ZrVFdnTDF1RllmSG9lajhV?=
 =?utf-8?B?ejl4eXBHS3VXRmlpNVN5SGNhTnNydFRNanZYY2dSeUFOTUtBbkpBazRtR2Nz?=
 =?utf-8?B?Mms4K2Q0Yk1BZlpUMW1ISkJTT3pLYW5iMVNyR0loRU9FSnNRdGhzSnA1dTh2?=
 =?utf-8?B?U3pFbDBoMmxzaEJPTVRKUjZPbGtzb3VnNFdlR2dRTXlKTUswYktZUGF5UEZ5?=
 =?utf-8?B?aHpkaGdXZnJ6bTlBVnlYUm1mb1BBMDlvU0VZR2pTdWx2MTRVbDFCd3UrQmJ6?=
 =?utf-8?B?S0dlZU5Rbjg4eE9rV3hENkM0YXdIZUV3bE5OdWliMERoU01XbjFiZVFQWjhj?=
 =?utf-8?B?dENNRmNGeUR0UnRheSsycU5LQjByZ1kySWZlckdsbjN0ZFovaGVxNWI0UTZQ?=
 =?utf-8?B?M1ltelJVV09sQUkvTjF4ZFlnNHN3c1NMbEt1WnVQZmNjSHJ1ZkVwT0lqcVR1?=
 =?utf-8?B?YzBaWE1RZFVDbmhKTmtneWdPbXJMS2dnQkRER0NZUWl5bUZyYnRNMitrYTRx?=
 =?utf-8?B?bWVtQ3NyQW0vR1BnN2NIcUtZTE1oMWdVbWhPeEg3cUsxLzFkdzdRNXphNTZZ?=
 =?utf-8?B?bjIxV3RpbG1CMExNK0dLSk92OXRyd3RJa3pzQ25vazVoSTJJaE95WlA5ZW1B?=
 =?utf-8?B?V0ZuZkp4NEtIR3d6QVplaVg5a3JkS1lDQmlORWxjcE03eE5iZFF0SW9KVStn?=
 =?utf-8?B?QWRjLzl5djNza2FmZzN5YVRqWlFnK0VPQnU3SlFsV21ETzJjOUZQbUM2SHR0?=
 =?utf-8?B?b0wyRnVGSkVUM2U2eTZJS012cmw1YlVNV1VOb2tPQWhiSU44Z1gyc0k4T3hU?=
 =?utf-8?B?VU5BVC9ULzVXckpBN2sza0c2ZkZucHVCb1BxeWpXanl3N1E5akduaTVJYUtV?=
 =?utf-8?B?anp2ajFMQ0Y5ZkROeXhFc2RUMHo2WXRkRys3SnZEL0NWRWZNdXA5Mng1UmRk?=
 =?utf-8?B?UWxmT3BHbEZMV09ZOFhuWE5ob3E0ZzhzdDg5aVBpY2pMY1dkNVllSVJ0aFNI?=
 =?utf-8?B?akNEY1NLQjFuRWRUeWRWWlc1QVk4WG9Ha09wQ0VJR2FSdjFCUDY2VnR1K2hk?=
 =?utf-8?B?ZEtGWXJQODVuR2FvUHdIaGdyUC9RQ3VRbU9oWmxlVm9uYWVPYkh4YmhWaWpI?=
 =?utf-8?B?MDZlbFp5emZDRjl6NVVUMjRnWjJwWDhsWlRHNjRuK3ZoN3g3KzJudVVSMk96?=
 =?utf-8?B?NFppZGhTcHBTWnM5L1NnbGpqUm9sYVF5ZlpXNXpQOURLanFoN1RIblVrRzVQ?=
 =?utf-8?B?UmxDVC96VDZXS3JXL1pKVUcrUitweUhINGZRa0tnRWdZSkZuK1lTcm5uL2Jy?=
 =?utf-8?B?ck51SFpvT1V4MjIxLy9TaS80SE0ra3Y2YnI2OTc2SHp6cDhVRm1BaUx4aVA1?=
 =?utf-8?B?TE9HckErRWx2M2VyMWRxRjFxZ1B1dHcvUjZCSGlxK2l5R2M4Qm5Rd1VkWUhQ?=
 =?utf-8?B?V2p6VFhvZHJXZDg0R3djRVpPWVBnNC9tdWhWVXExRFkwSzg4ci9mL2ptYm5m?=
 =?utf-8?B?aDNVWlNRV0NhNkkrbmpzTm9XU1lzOGJQSzZ1SVhWMXpORmgyQkRBdVNNcnhU?=
 =?utf-8?B?UkxGa1c5TENuNkc4TUFsclRXR3UzWGg2U1ZNczVTQnlrckRabVJkenY2QkxT?=
 =?utf-8?B?Mk92UHRPWmhtbDl1d3ZmeUxBQlVMUVQzbHdiT0lVNk1ia2t1ekRVa05ybE1H?=
 =?utf-8?B?V2EzNGZsazN1NytLbjZkY0N2dkRuTFhXdVZnTDNTN0NRZEM0NkR2Zz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a64cd77-66d5-49c8-abf1-08dee905e638
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:08.0352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1mVLXb4p3g2xhuef8MsKIs+iZHx270Lv7FeHAniV3BHJAufNbubx6+M26t/Z5ax4ibP38yfdpUCP8em/f5g7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

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

