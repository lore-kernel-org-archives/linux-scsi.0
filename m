Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022093.outbound.protection.outlook.com [52.101.101.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCD1378D92;
	Mon,  6 Jul 2026 14:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347112; cv=fail; b=c9ITU/itQbxXpWoGljYcp7osIJbWKMIM8t9oM2mxIxX+4T1I20G3ADtyeI0bJonr3rW3gjNAnDUJTytgrOSvlmIx7yfuUDVU3Z63GCN2RL8we8vOBoqTl6NqKeZgcWEoPtmKUP0bLzKQ/+82aN6oMXCl6OzvebfDpoh98N3YtS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347112; c=relaxed/simple;
	bh=dNONMJwZvIvO96LeyvKz2H84MhXaDVMPLrLQ2NQ/QuQ=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=aYRfUbrZJBR8hksbj0f0GnTVi4TI7JJ5r6WG3M1C3z9D4QzwCayuUzu2zkKggRRDm5QZ5loYnzjW5br47RfoH5u6ezq3A2/fkaUnzOzeZJKY1GKrowsP4/rt7Hj5UOiucud6QqhICZbFjQ6H4R9WR9nj2AW90nm8B3BZSy8QTfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=vZGw+Vj+; arc=fail smtp.client-ip=52.101.101.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="vZGw+Vj+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cb02xQD4xJBYZUMIq+nuGnUHrix1AUzTBINQb50P0pGvJryTn1dXvVek6eYAmRH3pzDxz/554ZlaZm+WAZRjfX+BWJ38KU8U0bFnLxEuq1gdGXS6aAmb5aj/AktDGUrRGJ4UMxSsna3xGw/IF7RZ7nxbhJ/MZZxdhdL+aDLef+IeEwrHI/LqMDLdx/7tTyZG6c4yeNyDS4mGabgmzzKxXNnAAU3ZVatJuxbDOYD/kwWZGhmZ47yC9y7Rjgv/M0Nh+qZZsu0RtJv4aIIPMWd+oerCo/MY0JQwINcsF6Cmj17q+bLKTBwb0Gn6WiKUb+eTL2zYj4xU4hZaY9S5o71eDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ECLBQ54kBBOoe75t4JLyiJ/8R3SIavZzr7IQDwteu0=;
 b=e0LklwUxIX1mRR6x6KeWz7UuEbebWoTDsadhwQraF0OYdLYj7j1cFxKlcwQPLPl34LZRlI2M/tYHrDeDAn4WEK8ZeDNzvgCVu4BtqGDipuFIAlUmMux56Pgb/AbDxiFm5Z04jnGF3DBqjLE6hTfwJvYIM4+BD8krf4cgdYI/uM9gEjgeU/SXqgSgroJ+FakPQYocAEaCpafzGIwjb0OpDiQCOfhTt5eB0lsIaBRcg/K8sy1U2MIgDF3nnkUSVpUsGAeiDChV1BoLlC+duAE2lFiRNMvpdVykvRTPtcNoHGaE1J4Nxaoi/iXjLis0IbQKH3/dLD9D9+E2wUD9A3tVRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ECLBQ54kBBOoe75t4JLyiJ/8R3SIavZzr7IQDwteu0=;
 b=vZGw+Vj+F/TaCX+MIoM/Wdk7SVSSM6GyR50DXybsD5hBOIyUpQZL0R7X8WgqAltE799VsUNb2NT/2kYoox+OvCUW10gDCrqAtn1hhI2NFIhAi6gIKaJe5IKrz2Z/+/UenQazGMVH2O2heDg0HIhUFldMG6Wycamy1d0x3xokDYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB7176.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:334::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
 14:11:34 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:11:33 +0000
From: Gary Guo <gary@garyguo.net>
Subject: [PATCH v3 0/9] pci: fix UAF and TOCTOU related to dynamic ID
Date: Mon, 06 Jul 2026 15:11:12 +0100
Message-Id: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIG3S2oC/22NQQ6DIBBFr2JYlwZBEbvqPZrGII46XagBJTXGu
 xfspiZdvsl/bzbiwCI4cks2YsGjw3EIIC4JMb0eOqDYBCaccckkl3QyWGFTtfimSoAGw1ghi4w
 EYbIQzkfs8fyyW+oXmDkW4qJHN492Pb75NO7+hn1KGdUiN4qJNq3L/N5pu3bLeB1gJjHt+Y8s2
 EnmQa6VyHSpDNMtP8v7vn8AyCYoyvUAAAA=
X-Change-ID: 20260626-pci_id_fix-83eaec007674
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
 Gary Guo <gary@garyguo.net>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783347093; l=4033;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=dNONMJwZvIvO96LeyvKz2H84MhXaDVMPLrLQ2NQ/QuQ=;
 b=5y6BbygToOJ012t+F8G7r0Ez3S7QvNfd/0KMA4CqbvtYOZIkhaE7iY/UtA4bDQOHMlmbaH1i6
 k7elfRrZD3uBPBK439ValxDF4Dn2MT18v5sHyx9SjcykOoT3B/q/T6g
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
X-MS-Office365-Filtering-Correlation-Id: 527986cf-baf7-4b78-8543-08dedb687c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|366016|23010399003|7416014|1800799024|921020|3023799007|6133799003|18002099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	kPHFpB17yH5+VZ1Bhmrk3PqXFMFVrG19FN1LcYBkA5F6joO1brkJR0hDmzzTFORT+AJsoBnm7HfFt62KWdy3yRA6Lgo7Mib54xMklo5AT7QfyAwAUJB17YIbGm3Iy+PlUPk/KHLKY7jOO6ZnDNT+sXxwGVLx3Im2wMPzmtDWMOKwwMufmT99+AIz/MM39VoKwWV+ArFkin9eAYUpPlpGGS69QzlnrGFmOOqkbGLhM1bIuTSSkeja3rDGstGv/8nI5D6xTrjQlofkg0BgJfhBNRxs8kQpHiEEVpA1T9M27L83s3J62yj3fmnmCo2AtpBT9bFopOv3IOtxQDENzWnvo5Mv2NQEw1tV8TXk0V2BCnlLm7jWa+wAKAuEw0uTd8DWJHe2TjOc0zt/lhPgP9MW0gOJx5RdAtlLrgadCxk+jspdoDIFUyMQU6rsNoda/jasUw3OyYP2HhQzoYEQfpOy/G6mB2V5AXAWR4Cihyf44E8vZ+Ojq3zMYyvsiwIFk9lrM9OZ1BmxggwBTShnflhNCRQS71Iirv2t6w6N2cOWx1vVA3YyUhkV/vSNztqVALElVfft9VtEHwKZSxxC9XL+0xpzFLHzcAZp0quc0j3xsV+OMDdLV3mSO6mfa9HzvItir25ikTFkmNZ3hvddgWHcBm75yD2P+WFyRncBZ7VLmvI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(23010399003)(7416014)(1800799024)(921020)(3023799007)(6133799003)(18002099003)(56012099006)(5023799004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N05Hcmh4WllENGl1TXpobUNibjRyMWxtb1pwZVAzc2tiUGtqU0RHVDVscW1q?=
 =?utf-8?B?bWJFTFRGQThxcUZLd1RPajZ5aVlNTUxQL3hsS2FiMmw0dnJCdUpYUndGckph?=
 =?utf-8?B?dHFHTHBTVGN5dUZ4aGozYUpIeGlBSjBWeFY5VDBqSzlYczRzRzc4aFNpMEpl?=
 =?utf-8?B?UmZsMVpJTmUrcTNJTm9aK1pWbXk0YUM3OXNPcVBhMXZqUjFoL3NqRFYzd1dh?=
 =?utf-8?B?b3VjaVlFT0ptWVIyZk9abG1oTXBBcjZyVk1NcUNuaVpRSW9sU0UzNHc3ZjdQ?=
 =?utf-8?B?ZXY1d29zejNxNjhmc2pMSysxa2p4dWIwT1N0U3p5ZVdmS0Vac2x1TVRNL1Zs?=
 =?utf-8?B?ckN3MDAzQjBjS040Nm5wZWpIUldzMUs0S08wZHhNWTRndE5aNmJvN2s0TjBv?=
 =?utf-8?B?eHJ0NGNpM0NVbWNBUHkyNzAyK21OQ0NEWG1uc3JtR0lyUC9jdGkwZm5GdEcx?=
 =?utf-8?B?cVJsUzBaR3VCUWJ1cllWMzhaUkdGc0hqdmY4UjZZQTRFcTl5ZWJVelRHZVd1?=
 =?utf-8?B?eTRRSU51UWxOeWxGOXlMTEl5bWE1NkhKZkpvRlQrTWFkSjFTZ2tiNXZhUWtj?=
 =?utf-8?B?c1MrQmhiYzJiTitWS3JLcWo0dUFoN2JNVXFjdk80Z0VHUXVGTVAweThPdTAy?=
 =?utf-8?B?QkpNVk9GVWhmNmRMR0hXaEJvM0IyODlrTXBCczhuU3NjVjFhcnJiYXd4NjJz?=
 =?utf-8?B?d2dmcjhaZ0Q0VUxYbHZZRkJZdEJzT3hzN202T1N1eG5Xek9lWFNVQmhTK0JN?=
 =?utf-8?B?TkhiWVlPSHFXdlJKR216bGFZVjEvQTRpS3daNnQvaWNIT3lyclUyeDRma1pv?=
 =?utf-8?B?Y1ZGQXUxdzZxZTZIekJSMDMzZTFzQTIrbDJxbzU4L2cwZzVnbnV1ajdSY2gv?=
 =?utf-8?B?TjFZY3Z0dm5BYmFwT3B1ZlJpK0htdXR1TWd5NHNodmNlOVE5azVBU2d5S2lm?=
 =?utf-8?B?VzIrMVNXWmhubXRQczBXUUFaOVVTT3RCYlVFRzV1UnNCZUs1L0tVZkZqZG05?=
 =?utf-8?B?b3Y4QmJFLzg0THc5SHZYUDFhalczM3AyRGVUcmRJNXJiUnJQeHc2aDBkNUtU?=
 =?utf-8?B?VWNaKzJneXB3Q3dvWjg1aUlLN3ZrbmdMdWZlcjRaaUpLb2ZDQ2lublFqL3BD?=
 =?utf-8?B?RXpqWWxJT1RPNUhUL0c5QzBIbkFTWWlrR2svazA1MGovc1RnQmp0Wk1RcXIr?=
 =?utf-8?B?T1N5UldsSTZ3UEVPdnN4ZHdtemVVMmFoUG9xa0paT2NheUp2eFVNZzB1RFZh?=
 =?utf-8?B?L3JaSzBNVlBHR3RqNUYzZlFjT1FjR3NTTkp3SU1uTkttdEo3anJpMEFBenpT?=
 =?utf-8?B?dUdTUVAxeUFCdGJQa082WEpPTnM0Si91eDhFbGxNVlFiM0hiTE4wWXJNZjdL?=
 =?utf-8?B?NmZXbGhnQWpPZ09sNTB2eTBqcXIxOG9PM010YTFKd2xyYzlkY3lualQ4dFpD?=
 =?utf-8?B?eU02Vk5hQUhtRkgvV0NFOEVkaHZYeVgwdEw3akJvQ2w0a0QvZG9HRi9vaGtK?=
 =?utf-8?B?NTlJZCtSS0E3elJPM1UxWlFNVmhqejJhNVhralR3b3k3dFNzdVpZYkd6emJr?=
 =?utf-8?B?MERCTFdBVWQ0dFlZOFNnaEs3aHFTYUg0ZVo0MWIwNS92RnQ2RkRDc2xCK1Zs?=
 =?utf-8?B?T251dGdsMTdnSmV6WTlhMVd0MVhndXZjaGRuZjVWSU84NVluWlNBRVVxZHBO?=
 =?utf-8?B?cWVtUzdEODJ3TTRJeDh6NlFlSG9idzc2TDZEL0MxN1YyN1VIaytSUmZaZllh?=
 =?utf-8?B?SlVtTXI1VmU0ZE90OFlHVzNOOGc4UTlXTURZNFlkRjRLaXhMNnFHRnNuVDZT?=
 =?utf-8?B?N1VVWDVOdjVjb0VNNmhKY2NvS0U2akZZKzJzd1pJVktJa3RyNXdqWDJKRnBD?=
 =?utf-8?B?b3hvdTZtWHVMUWZJdFpLU2Q1SE82Vk5HNnZ6dlJSR2o1bllndUFhcmFRalVk?=
 =?utf-8?B?N0lRNVA4YklVZjBsT3czTVRmN1UwckJicmJjYjFGVXNXTnppY1V3YlhkSHV0?=
 =?utf-8?B?VC8zVTVzc1FqYXFSOHVIdGNRYjhUeFRJbTZKc3FLOFBRZkRuT2FqRStvOWZP?=
 =?utf-8?B?Y2JNdVM4TmxQTU9GeEY3YW5MaTJ0aGFFdnRJT3J3RldBQkdPc0dTZUpXL0Qw?=
 =?utf-8?B?cm5QdTkvSW9yeVVOZFJLdDZKSXlTRXFJYXZqNmlQSUdlQlc3RkxHSXEzOXIr?=
 =?utf-8?B?UjhzYmcreXdwWU1oY3I2SXhVUXQwYXU1ZkRoTTlkMlFUZWNUQnlWc1IwNk1L?=
 =?utf-8?B?SU5VbkcrRno5TFBMaEVieE8rc2VkY1RMdE9wK2RSSUE3YmtoUC9QT1d5YVdw?=
 =?utf-8?B?eDlSaFVlN0hPbElSemk4aUNlQTJ2Ly9Cd0Y4L2NkK0w5UElzQzNwQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 527986cf-baf7-4b78-8543-08dedb687c0e
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:11:33.8790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rT8/6FjQoM4brHxjbxpxLy1A2m8Cs6gvF/H2miJ5SS9L5kwm3Qh6NijVyEH3r2b9ifsSXbeksTs3IOTyezpJPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB7176

While working on improving the Rust abstractions [1], Sashiko reported that
an existing UAF issue related to dynamic ID, which I find to be genuine.
When taking a look at the code I also find a TOCTOU issue where the
existence check of dynamic ID happens in a separate critical section as the
actual insertion. This series fix both issues.

There are two exported functions "pci_match_id" and "pci_add_dynid" which I
have to tweak to implement this cleanly; I created separate "do_xxx"
functions to keep the existing APIs because they all have multiple users.

There're a few existing users which stores their pci_device_id argument in
probe callback. This is a bad pattern because nothing except driver_data
inside pci_device_id is what they want; actual ID information can be
retrieved from pci_dev instead.

There are two users that performs pointer arithmetic on the pci_device_id;
these are also problematic with dynamic ID and driver_override, so fix them
as well.

I've used the following coccinelle script to flag all cases where the
pci_device_id is used other than reading its fields.

@usage@
identifier fn, id;
position p;
@@
  fn(..., struct pci_device_id *id, ...)
  {
    ...
    id@p
    ...
  }

// Due to cocci isomorphism this needs to be explicit
@bad@
identifier fn, id;
type T;
position usage.p;
@@
  fn(..., struct pci_device_id *id, ...)
  {
    ...
    (T*)id@p
    ...
  }

// Good use cases
@good@
identifier fn, id, fld;
expression E;
position usage.p;
@@
  fn(..., struct pci_device_id *id, ...)
  {
    ...
(
    id@p->fld
|
    E(..., id@p, ...)
|
// Redundant checks, but ignore
    !id@p
|
// Redundant checks, but ignore
    id ? ... : ...
)
    ...
  }

@script:python depends on usage && (bad || !good)@
p << usage.p;
@@
coccilib.report.print_report(p[0], "suspicious use of pci_device_id")

Link: https://lore.kernel.org/all/20260618-id_info-v1-0-96af1e559ef9@garyguo.net/ [1]
Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/ [2]

---
Changes in v3:
- Fix users which uses pci_device_id for pointer arithmetic. (Sashiko)
- Convert to scoped_guard. (Danilo)
- For static IDs, still give out static pointers and avoid making a copy.
- Link to v2: https://patch.msgid.link/20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net

Changes in v2:
- Fix users which store pci_device_id.
- Clarify in probe documentation about the lifetime of pci_device_id
  parameter.
- Dynamic ID conflict check now ignores override_only. (Sashiko)
- Link to v1: https://patch.msgid.link/20260626-pci_id_fix-v1-0-a35c803f1b95@garyguo.net

---
Gary Guo (9):
      ata: don't store pci_device_id
      nsp32: don't store pci_device_id
      ipack: tpci200: don't store pci_device_id
      mlxsw: don't store pci_device_id
      agp/via: don't rely on address of pci_device_id
      agp/amd-k7: don't rely on address of pci_device_id
      pci: make pci_match_one_device match on ID instead of device
      pci: fix dyn_id add TOCTOU
      pci: fix UAF when probe runs concurrent to dyn ID removal

 drivers/ata/ata_generic.c                 |   6 +-
 drivers/char/agp/amd-k7-agp.c             |  26 +--
 drivers/char/agp/via-agp.c                | 308 +++++++-----------------------
 drivers/ipack/carriers/tpci200.c          |   1 -
 drivers/ipack/carriers/tpci200.h          |   1 -
 drivers/net/ethernet/mellanox/mlxsw/pci.c |  11 +-
 drivers/pci/pci-driver.c                  | 193 ++++++++++---------
 drivers/pci/pci.h                         |  36 +++-
 drivers/pci/search.c                      |   6 +-
 drivers/scsi/nsp32.c                      |   8 +-
 drivers/scsi/nsp32.h                      |   8 +-
 include/linux/pci.h                       |   1 +
 12 files changed, 230 insertions(+), 375 deletions(-)
---
base-commit: 2b763db0c2763d6bf73d7d3e69665222d1f377cf
change-id: 20260626-pci_id_fix-83eaec007674

Best regards,
--  
Gary Guo <gary@garyguo.net>

