Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022093.outbound.protection.outlook.com [52.101.96.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0413E403EB5;
	Thu, 23 Jul 2026 22:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844108; cv=fail; b=WR3lygaEGu6otdOlqwQNM/8Vh6wnhGku4ubesdck54yHfvq7NPAeV1HwrOuh2ogqkRg4SrOxtJ+ISSDM3WzEDftdI96yL47FzKjshnYf9BPuUZtzBgHrqxh2K/tFMdKLNNbYuVbMF5o4pCZPTQ7TuU9xs0XhBRc835S6l7FHw3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844108; c=relaxed/simple;
	bh=O4AeIwouKxfz/v8M6iU/+NbWvDIMsUu6ikPZv3LI3Cg=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=WOz0sQ6AgFxJzKdPQKn4waOdLjjoZaaknBRSfIwUkr/fwj7pBJlENZxqDa642BMQqdsDFi3Wj++bjFSGg9PY9/zMcRDSd70IYhP9BP1c9EQhTAaI/QQrfsnnG8e5tWeMlQ26NABqjoi7AJjjOC+bHOZ/CzZi2xAA8oCwAMZDDds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=yC4hs8S3; arc=fail smtp.client-ip=52.101.96.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="yC4hs8S3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FlAajCSzsN0XCpOidpgxgUssbcDapAeTmZCcjvy/Fq1raDROI3HWPTQw5qATMJqJgv4mJ8qUvxJW9nCeRRspBeOGFOALjPmEeB3YVBgE7KXHHywsD0octQ/8QouZtHinO2aA7tRa2/rbXa/FDO3OS1lf/h/e6KItMGbpkXIiNzshBIu3pYnkbtieBD/1AGwWJ3XA13NJLzp7gW5Zh6wUbPz2QD9nyVWQ5UFFa8IKSrs6ompcnGnv/o8gbaFtvvXkDGtSCrrJc5LgiWaUabluBlMtMXdzADsL6fNtPRQMSNAkYCT7sT1hj9wou3iqXPW9g/sVvih9dnLlVtEw+5dn5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0rlONosCECIyzqAGIa7AyjryVFCu/U7s8IpHHskCWg=;
 b=wG8S2t3uu1hW13XBWK2aZRB2EZHJhcC/VtOJJR6zC/DHZpJTuGepHGiltSmf1nzUfdh/bWtStCvDKSa3oL5AHL59cLKLiVft7YPD1Ug3qA0MDdMxpmpr0Af9FucfyP0iINAVfpPtM4H6c2X0MT1D+AIqngGb0ffWEeqCI1+JPyY2RssvOvNQjYT3GZNrXnLbZ2q4T060gR2gWh5S0xDQq8cp0LmSUnddRvT8bt65pJ9ldyY0NZSwwzN29CMa1gCcuSpABXHJ1ZWsGyq+X/70sU+4yZcvHrVCimGWxEbdAzCKfBqQ21ANcNGahlcaMfQP3Ydle7IlieBxECgwttgt1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0rlONosCECIyzqAGIa7AyjryVFCu/U7s8IpHHskCWg=;
 b=yC4hs8S3JJO+cycddcAsIl4UnE9+jS2NnG5Kd8B1wyhpbRF4EuknF0lMM95eVxGtpGATCOtXotb1YIi1Eh4OUYzYewYHIOSKzLGGNWLH/YXOwE+beE1j8LWO3hwtIQbcmdshByL7HCL0b7mDF/MJlovt1qyqqVzt+ITc/KzNIWo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 22:01:09 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:01:09 +0000
From: Gary Guo <gary@garyguo.net>
Date: Thu, 23 Jul 2026 23:00:44 +0100
Subject: [PATCH v4 5/9] agp/via: Don't rely on address of pci_device_id
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-5-3580726844e1@garyguo.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=9936;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=O4AeIwouKxfz/v8M6iU/+NbWvDIMsUu6ikPZv3LI3Cg=;
 b=mGneCNVMVv937raqOpRbSiEmWEspoI/PNT5nf0QZ/3QFvKqqgjCEemTBKVWRlJR7er0D1Eq5u
 mdqkzKu6XcqADbfZv2TttE1PcrN7iNsiyJGohireSrFewNm9h2ddfGC
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
X-MS-Office365-Filtering-Correlation-Id: 90111ae4-8a42-47a4-24c8-08dee905e6f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|22082099003|18002099003|3023799007|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	na7Z5EdzK4s1RV7B0je3PoJ48vdUhd3OcebZ7Z9OJHYXeNdJNqcHaBd1ScSK9aCI+zuKaE1FaYLu0DtpEb6G0nRwmGAFNBB39+1qrSmV0Q3w+oFEVq/j/jNi/5evwnX+e2fYNKECrCqLv8ANQbsSbpWtVf5wTDiiRX9lTtGTHRg9A/iAV1th6PxdmLmkuVbIyVtjqD2xvewY3iaoDeYVVG9qUOSlo3Dm0YLe8TOBjR+q/bsQotbgmNHAhifwontjboZCA7Il+6XVGfStjaelhn/tTm0eqFTlEj04axLu28JhUb4pi9TiDXj7Prk6U/nRjMCY+9vd4C3nj97SxOnnAYFWPDe5aXkHYefzObXqpmjiDa09neFJRcJXDWUa3RomYZ5qe8tWAJDRWVdyEZ0jymMKyyAhhZQnyv5o0Myy+De+JWPoVqucJy0t+RtdQQPrmUGFowvrDB6wX1HAxzi3+5gch6s4m3xW/yVPLBdilDmwioSPjaYM8EZOOXrH4NlQgcn2L4Le7AJ9fE8FL+FFoNNYqNXjnX43HTkg8tragJAnrYisi0tOS1cK4c8OMfoSOsjvYnF/9Q+hunuaT8M6RRIpN9HiHka/2GT7Fj3sp2xvYUKiFfSyF6tTqC+6OhRqasGCxZ9USZ/BN1meJ+4CWDw3fxXs0zIPptCZER/uK0FO3fF+5uRfGQwOJQUHrIGeBKUnqMtfnukOboyyUxr/fg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVc5K2N1ZWh3OXRERHFlTFJMaE1TdSs3RjBub0hsbWZnZmRCbUEydW4vc0Y3?=
 =?utf-8?B?bXVINXczQnRXTi9jVEx0NWpWc0p5MWVrTmY1VDJCUmRuV3lGb0xmdWxGM1d0?=
 =?utf-8?B?TkxESzRYVmdlWkxuNXNVTnhpZzlTaHFvbXRHSjRWQzA2bDdtbWliZGNpOW5L?=
 =?utf-8?B?bVJNWC9LcTF5bDI4NmFMTVdZRFpsU2Z5dGNRK3RVNktFNWVURlVYbHZjY0Zx?=
 =?utf-8?B?cFhLNS9qbnVSZmhSd3NQKzQ1Rmg4QU9zRVM0ZDViTEJqNFNZeDd1VGQxcnQy?=
 =?utf-8?B?b2UwZzM3b0l1dWR3TWRaalNLSmFQaytzSW5NUVJiQWJUTHpwcXVHOUI5Tzln?=
 =?utf-8?B?TEtIUFRadUpGUndqZnFUM3NFTWlET1EweDMwWStLRmdvUzdRNnNJVEROOFc2?=
 =?utf-8?B?Mlc3SXRNVUp0YjFJYXBjUkI1Z0xYRDk4UXJ4RjZxQUF5ck5CbkNhZzRhUk1u?=
 =?utf-8?B?Ym5tc2hVczQ1NUFqYkhtTUlvN2RRcHBsMFZmRHFpQjRrOXYwUUJMeW5kLzZZ?=
 =?utf-8?B?VS9sMXp0aUFMS2pDUHFqTHYyZVlGeHV5MUdKSEVDeTV1T1pqMTFNdHFleUlx?=
 =?utf-8?B?TTBDRy9Ta0tubVgvNU0rWUlQQ0RZdklDV3gzUkV0VlVMZDFad05sWGVjTlFh?=
 =?utf-8?B?RWVxWTNpQTVpanFJOE1mNDdhVkVEY1kvV0k0azNRTzFVZEdEQU4yVmpLOWF5?=
 =?utf-8?B?YUtvN2hVYTlzcy80NklhUlllWEFmbWY0RmF3SERWRlhUMEtmM09TWk1BcHR2?=
 =?utf-8?B?R2lITjF1R1JxZWRxWkEwSllTQWhwcHF3Ykl1TVh5aTk0MHNpdFhUZ2ZieUps?=
 =?utf-8?B?MVlVRXJTOHJweitvYWxIRk9qelNKT3BVa0dMK0ZvbEZBd3p4YmlyT1NQeFZS?=
 =?utf-8?B?SUQyWVpqSk84UWlreHo2MjRibWpORWRicUFhNDNkYUpiUlpNa1gvZW53V1p3?=
 =?utf-8?B?NmlaMVZGQWZiYXltelhQNmI4M1BnNGlkZjl1OHNUYmRGL0p4MGpiT3hXeVdB?=
 =?utf-8?B?TEs5S3JHV2ZYcndnWml6UU10Y2M0d0s4YU5OUXVlVVUyajhMUkhXUTZBNjRB?=
 =?utf-8?B?cjlVSC9tdEpTd3hZTVcrMHFNSkpzYjliOTZQNXRVWTg2MVQ0UEFUMHBYSDQy?=
 =?utf-8?B?bDFYWVlJUnZQVkE5TU5QMk0yTTgwdWhXczdGRzJzY25PMTN4SHRSbUQ2UUdL?=
 =?utf-8?B?QWtnY3EwTTNxbC9COE8yNit6V0ViYWh6SzVHYnN2bklXdzFtenVGdkQ5NHh1?=
 =?utf-8?B?VCtqcS9FUGFScWIyTUdKZzdLaFAyekhheDBVVFRvdXp2S0NBUjZ5REVjbzhZ?=
 =?utf-8?B?L2dFRGwrd1RlTElHVkdkNDFMVVJXSjVna2ZtNVpOazNUZFVlUWFtQ0hOaEN1?=
 =?utf-8?B?TEppRTBzOTFZL2N5N2lRbms2eDJCSHkxRXlNUDNEamxSNENtZWZ6VmdBcE5n?=
 =?utf-8?B?dEJPLzdCMG5qQUhsNTJLeXRnY0k2SXU0QWh0VStuWUN2K1FVRXpydU9RL2xM?=
 =?utf-8?B?SHB2RmVzOW1iQ2t0Q1pJTFZxKzZSK1ltTW1lRTdtcUcza0ZsODhmZUN0Lysw?=
 =?utf-8?B?N0UxTE5UQlBxYy9hNFdGN3JXNWFZZnJHY2Z5M01TRUhaTEI4dFd6WHdhQ2pQ?=
 =?utf-8?B?ellqT21hdmIwSGNZVFFicWVVakF1NktWVWZDa0xKTUpwRzIvNTcwUUVpc09S?=
 =?utf-8?B?VEVBZG40MHJMb05rdlNQZUJMUHI3enBWMlZTQmF2UENranJPQUtXcmNBbzB3?=
 =?utf-8?B?RkFheE5SNXRYaEphL3pPbHByelpMbDBmVmJ1VExRNlZyOFV4SHBxZVBUUGlp?=
 =?utf-8?B?cVNBZ29MMGdPMmwwbUZ5UFlxT2ZwR3IyNGVQWlRxcmlIK2lmVWZEd1ZZUGpN?=
 =?utf-8?B?d0FnMVVYRXUxNGhOVWJNaU1tUXdLL0Q1YS9wMzdjODhBTDNJZXR4SVdLMmdR?=
 =?utf-8?B?RXAvNHJDQXM2dkdoSFlHSXNQQlEvV2lMR1VwSDgzUm1KWjl5a1hhQTIzSDRr?=
 =?utf-8?B?SmxXRUVJdVJRQ3hhZ2QwaHlJMHg3MGtwQjM3ZlI0QmxhS1BpU2lYNERNWW5Z?=
 =?utf-8?B?aDAxeUw2dVJUTmVPUFJQSjBlaklMbzQyS0czSXhuQ1B3YTUvYy8rK1JUSjRv?=
 =?utf-8?B?S2E5a295QW9BU0J0MkwrTjJ1aktMSzRVN2wvQ0RqcGh6QkdscHRtNXRTV2F1?=
 =?utf-8?B?T1l0cnloSFgyUVJybDUyKzlycDhpS0VTM2kwTnR4N3d2UFZYU1pGSlQyRnhl?=
 =?utf-8?B?M01OSjBSbmpXbm0wUmVhSG5iT1JaczZHTFh1QS9MaW0rY0YyclhLRUpQcUZw?=
 =?utf-8?B?ZjBrTmtzaUUvMFFab3ltS1BBY0VsMmVtTVU1ZktTTXA4WlJlTFJEdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 90111ae4-8a42-47a4-24c8-08dee905e6f9
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:09.2891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tepQ8A7WZx1jdSzgd7SIx9ZEh5Mi7EsFYlKjBjtTviz00d41C44VkJU6VUAw7rlJyoPc+dURpafsWlcGIkDaOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

Address of pci_device_id cannot be relied on due to presence of dynamic ID
and driver_override. Use driver_data instead.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/char/agp/via-agp.c | 308 +++++++++++----------------------------------
 1 file changed, 72 insertions(+), 236 deletions(-)

diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
index 8b19a5d1a09b..ab3b73dd080a 100644
--- a/drivers/char/agp/via-agp.c
+++ b/drivers/char/agp/via-agp.c
@@ -221,204 +221,6 @@ static const struct agp_bridge_driver via_driver = {
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
-static struct agp_device_ids via_agp_device_ids[] =
-{
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_82C597_0,
-		.chipset_name	= "Apollo VP3",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_82C598_0,
-		.chipset_name	= "Apollo MVP3",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8501_0,
-		.chipset_name	= "Apollo MVP4",
-	},
-
-	/* VT8601 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8601_0,
-		.chipset_name	= "Apollo ProMedia/PLE133Ta",
-	},
-
-	/* VT82C693A / VT28C694T */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_82C691_0,
-		.chipset_name	= "Apollo Pro 133",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8371_0,
-		.chipset_name	= "KX133",
-	},
-
-	/* VT8633 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8633_0,
-		.chipset_name	= "Pro 266",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_XN266,
-		.chipset_name	= "Apollo Pro266",
-	},
-
-	/* VT8361 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8361,
-		.chipset_name	= "KLE133",
-	},
-
-	/* VT8365 / VT8362 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8363_0,
-		.chipset_name	= "Twister-K/KT133x/KM133",
-	},
-
-	/* VT8753A */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8753_0,
-		.chipset_name	= "P4X266",
-	},
-
-	/* VT8366 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8367_0,
-		.chipset_name	= "KT266/KY266x/KT333",
-	},
-
-	/* VT8633 (for CuMine/ Celeron) */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8653_0,
-		.chipset_name	= "Pro266T",
-	},
-
-	/* KM266 / PM266 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_XM266,
-		.chipset_name	= "PM266/KM266",
-	},
-
-	/* CLE266 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_862X_0,
-		.chipset_name	= "CLE266",
-	},
-
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8377_0,
-		.chipset_name	= "KT400/KT400A/KT600",
-	},
-
-	/* VT8604 / VT8605 / VT8603
-	 * (Apollo Pro133A chipset with S3 Savage4) */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8605_0,
-		.chipset_name	= "ProSavage PM133/PL133/PN133"
-	},
-
-	/* P4M266x/P4N266 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8703_51_0,
-		.chipset_name	= "P4M266x/P4N266",
-	},
-
-	/* VT8754 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8754C_0,
-		.chipset_name	= "PT800",
-	},
-
-	/* P4X600 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8763_0,
-		.chipset_name	= "P4X600"
-	},
-
-	/* KM400 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8378_0,
-		.chipset_name	= "KM400/KM400A",
-	},
-
-	/* PT880 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_PT880,
-		.chipset_name	= "PT880",
-	},
-
-	/* PT880 Ultra */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_PT880ULTRA,
-		.chipset_name	= "PT880 Ultra",
-	},
-
-	/* PT890 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_8783_0,
-		.chipset_name	= "PT890",
-	},
-
-	/* PM800/PN800/PM880/PN880 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_PX8X0_0,
-		.chipset_name	= "PM800/PN800/PM880/PN880",
-	},
-	/* KT880 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_3269_0,
-		.chipset_name	= "KT880",
-	},
-	/* KTxxx/Px8xx */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_83_87XX_1,
-		.chipset_name	= "VT83xx/VT87xx/KTxxx/Px8xx",
-	},
-	/* P4M800 */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_3296_0,
-		.chipset_name	= "P4M800",
-	},
-	/* P4M800CE */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_P4M800CE,
-		.chipset_name	= "VT3314",
-	},
-	/* VT3324 / CX700 */
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_VT3324,
-		.chipset_name   = "CX700",
-	},
-	/* VT3336 - this is a chipset for AMD Athlon/K8 CPU. Due to K8's unique
-	 * architecture, the AGP resource and behavior are different from
-	 * the traditional AGP which resides only in chipset. AGP is used
-	 * by 3D driver which wasn't available for the VT3336 and VT3364
-	 * generation until now.  Unfortunately, by testing, VT3364 works
-	 * but VT3336 doesn't. - explanation from via, just leave this as
-	 * as a placeholder to avoid future patches adding it back in.
-	 */
-#if 0
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_VT3336,
-		.chipset_name   = "VT3336",
-	},
-#endif
-	/* P4M890 */
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_P4M890,
-		.chipset_name   = "P4M890",
-	},
-	/* P4M900 */
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_VT3364,
-		.chipset_name   = "P4M900",
-	},
-	{ }, /* dummy final entry, always present */
-};
-
 
 /*
  * VIA's AGP3 chipsets do magick to put the AGP bridge compliant
@@ -437,17 +239,14 @@ static void check_via_agp3 (struct agp_bridge_data *bridge)
 
 static int agp_via_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct agp_device_ids *devs = via_agp_device_ids;
 	struct agp_bridge_data *bridge;
-	int j = 0;
 	u8 cap_ptr;
 
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
 
-	j = ent - agp_via_pci_table;
-	printk (KERN_INFO PFX "Detected VIA %s chipset\n", devs[j].chipset_name);
+	dev_info(&pdev->dev, "Detected VIA %s chipset\n", (const char *)ent->driver_data);
 
 	bridge = agp_alloc_bridge();
 	if (!bridge)
@@ -501,9 +300,8 @@ static int agp_via_resume(struct device *dev)
 	return 0;
 }
 
-/* must be the same order as name table above */
 static const struct pci_device_id agp_via_pci_table[] = {
-#define ID(x) \
+#define ID(x, name) \
 	{						\
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),	\
 	.class_mask	= ~0,				\
@@ -511,39 +309,77 @@ static const struct pci_device_id agp_via_pci_table[] = {
 	.device		= x,				\
 	.subvendor	= PCI_ANY_ID,			\
 	.subdevice	= PCI_ANY_ID,			\
+	.driver_data	= (kernel_ulong_t)name,		\
 	}
-	ID(PCI_DEVICE_ID_VIA_82C597_0),
-	ID(PCI_DEVICE_ID_VIA_82C598_0),
-	ID(PCI_DEVICE_ID_VIA_8501_0),
-	ID(PCI_DEVICE_ID_VIA_8601_0),
-	ID(PCI_DEVICE_ID_VIA_82C691_0),
-	ID(PCI_DEVICE_ID_VIA_8371_0),
-	ID(PCI_DEVICE_ID_VIA_8633_0),
-	ID(PCI_DEVICE_ID_VIA_XN266),
-	ID(PCI_DEVICE_ID_VIA_8361),
-	ID(PCI_DEVICE_ID_VIA_8363_0),
-	ID(PCI_DEVICE_ID_VIA_8753_0),
-	ID(PCI_DEVICE_ID_VIA_8367_0),
-	ID(PCI_DEVICE_ID_VIA_8653_0),
-	ID(PCI_DEVICE_ID_VIA_XM266),
-	ID(PCI_DEVICE_ID_VIA_862X_0),
-	ID(PCI_DEVICE_ID_VIA_8377_0),
-	ID(PCI_DEVICE_ID_VIA_8605_0),
-	ID(PCI_DEVICE_ID_VIA_8703_51_0),
-	ID(PCI_DEVICE_ID_VIA_8754C_0),
-	ID(PCI_DEVICE_ID_VIA_8763_0),
-	ID(PCI_DEVICE_ID_VIA_8378_0),
-	ID(PCI_DEVICE_ID_VIA_PT880),
-	ID(PCI_DEVICE_ID_VIA_PT880ULTRA),
-	ID(PCI_DEVICE_ID_VIA_8783_0),
-	ID(PCI_DEVICE_ID_VIA_PX8X0_0),
-	ID(PCI_DEVICE_ID_VIA_3269_0),
-	ID(PCI_DEVICE_ID_VIA_83_87XX_1),
-	ID(PCI_DEVICE_ID_VIA_3296_0),
-	ID(PCI_DEVICE_ID_VIA_P4M800CE),
-	ID(PCI_DEVICE_ID_VIA_VT3324),
-	ID(PCI_DEVICE_ID_VIA_P4M890),
-	ID(PCI_DEVICE_ID_VIA_VT3364),
+	ID(PCI_DEVICE_ID_VIA_82C597_0, "Apollo VP3"),
+	ID(PCI_DEVICE_ID_VIA_82C598_0, "Apollo MVP3"),
+	ID(PCI_DEVICE_ID_VIA_8501_0, "Apollo MVP4"),
+	/* VT8601 */
+	ID(PCI_DEVICE_ID_VIA_8601_0, "Apollo ProMedia/PLE133Ta"),
+	/* VT82C693A / VT28C694T */
+	ID(PCI_DEVICE_ID_VIA_82C691_0, "Apollo Pro 133"),
+	ID(PCI_DEVICE_ID_VIA_8371_0, "KX133"),
+	/* VT8633 */
+	ID(PCI_DEVICE_ID_VIA_8633_0, "Pro 266"),
+	ID(PCI_DEVICE_ID_VIA_XN266, "Apollo Pro266"),
+	/* VT8361 */
+	ID(PCI_DEVICE_ID_VIA_8361, "KLE133"),
+	/* VT8365 / VT8362 */
+	ID(PCI_DEVICE_ID_VIA_8363_0, "Twister-K/KT133x/KM133"),
+	/* VT8753A */
+	ID(PCI_DEVICE_ID_VIA_8753_0, "P4X266"),
+	/* VT8366 */
+	ID(PCI_DEVICE_ID_VIA_8367_0, "KT266/KY266x/KT333"),
+	/* VT8633 (for CuMine/ Celeron) */
+	ID(PCI_DEVICE_ID_VIA_8653_0, "Pro266T"),
+	/* KM266 / PM266 */
+	ID(PCI_DEVICE_ID_VIA_XM266, "PM266/KM266"),
+	/* CLE266 */
+	ID(PCI_DEVICE_ID_VIA_862X_0, "CLE266"),
+	ID(PCI_DEVICE_ID_VIA_8377_0, "KT400/KT400A/KT600"),
+	/* VT8604 / VT8605 / VT8603 (Apollo Pro133A chipset with S3 Savage4) */
+	ID(PCI_DEVICE_ID_VIA_8605_0, "ProSavage PM133/PL133/PN133"),
+	/* P4M266x/P4N266 */
+	ID(PCI_DEVICE_ID_VIA_8703_51_0, "P4M266x/P4N266"),
+	/* VT8754 */
+	ID(PCI_DEVICE_ID_VIA_8754C_0, "PT800"),
+	/* P4X600 */
+	ID(PCI_DEVICE_ID_VIA_8763_0, "P4X600"),
+	/* KM400 */
+	ID(PCI_DEVICE_ID_VIA_8378_0, "KM400/KM400A"),
+	/* PT880 */
+	ID(PCI_DEVICE_ID_VIA_PT880, "PT880"),
+	/* PT880 Ultra */
+	ID(PCI_DEVICE_ID_VIA_PT880ULTRA, "PT880 Ultra"),
+	/* PT890 */
+	ID(PCI_DEVICE_ID_VIA_8783_0, "PT890"),
+	/* PM800/PN800/PM880/PN880 */
+	ID(PCI_DEVICE_ID_VIA_PX8X0_0, "PM800/PN800/PM880/PN880"),
+	/* KT880 */
+	ID(PCI_DEVICE_ID_VIA_3269_0, "KT880"),
+	/* KTxxx/Px8xx */
+	ID(PCI_DEVICE_ID_VIA_83_87XX_1, "VT83xx/VT87xx/KTxxx/Px8xx"),
+	/* P4M800 */
+	ID(PCI_DEVICE_ID_VIA_3296_0, "P4M800"),
+	/* P4M800CE */
+	ID(PCI_DEVICE_ID_VIA_P4M800CE, "VT3314"),
+	/* VT3324 / CX700 */
+	ID(PCI_DEVICE_ID_VIA_VT3324, "CX700"),
+	/* VT3336 - this is a chipset for AMD Athlon/K8 CPU. Due to K8's unique
+	 * architecture, the AGP resource and behavior are different from
+	 * the traditional AGP which resides only in chipset. AGP is used
+	 * by 3D driver which wasn't available for the VT3336 and VT3364
+	 * generation until now.  Unfortunately, by testing, VT3364 works
+	 * but VT3336 doesn't. - explanation from via, just leave this as
+	 * a placeholder to avoid future patches adding it back in.
+	 */
+#if 0
+	ID(PCI_DEVICE_ID_VIA_VT3336, "VT3336"),
+#endif
+	/* P4M890 */
+	ID(PCI_DEVICE_ID_VIA_P4M890, "P4M890"),
+	/* P4M900 */
+	ID(PCI_DEVICE_ID_VIA_VT3364, "P4M900"),
 	{ }
 };
 

-- 
2.54.0

