Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022092.outbound.protection.outlook.com [52.101.101.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49413F9A1A;
	Tue, 30 Jun 2026 11:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817776; cv=fail; b=sqOOezvU+UoCPzGfTfJ6UE5TaESs+UDylrDROozjU+ZooIYTU6faYX7Fzp4arIfUo5aUsFz37ZtLADdGe0csKfE1FJvZkZUnUz3Hzt+q9w3HauTZUSFqrI49pnDQVtGO3DZjzToPNqL71MADsUe5ejyklJ++q3pKm+xUbqrd3Ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817776; c=relaxed/simple;
	bh=zT8CR1hu18sGi5f9+9wkDL8BzV1/sK8mE83mrlSqGJw=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=Z6RYtfQO1jk9eIt+NpyVvyuorVWs32RbkxRiQTuG1Li0UomKZDFEcBMw/ljaIGp3gVCuzqVpO4uh84j2j9RvsDX8rdSsD36T7yvj8Ze7HZ+sDAdDkTPbjSqZQl2O8WZkUGrz/Mk2VqclbLR5Foyt0NFNIdgeS8fZWAuNnX4TKhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=nimkejgQ; arc=fail smtp.client-ip=52.101.101.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="nimkejgQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GlcQPn17G/qv+q/8HvuhuqtdV7HTODLng26BgtSZh3GhLQOWvBgSIW6WrgG4bXScqE9nBL13lADhLwtgiEhVCTIsCnQrZW2WP1DIuq8ojdIvILHdmcTscKEpX1TAQwuw5iS+vYyhlfENfs4VuNP/GwpH4nXcKGrC4dvayF1tMv29lb4VC/5iJXELIc/KrR347+Hebht+Y4SqtqniuYXyDn3p+I0iZdob3rzoWChjhkG8Mr1ttWzh4boUAZbjo0aqJ8pHBFhFoXvDgj6QSa3DBBiJv2wZHKVq4snjLNSUjlLLCs3bBUoN9gmtKVtwynkx+8+bO82Tp61hAjvNG2yYSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSYPIBBvbhQ1YIoGfEmexoBK4XfmyCD7yKFk9G1YL/8=;
 b=usrfv99BODLXCDJCsl1CeM7xSZZ59SDSdWoxZ6NshKAWLxTjl7oq696vE5PHrvpORB6VXKSji9a7MpH2YUPeRWiwimglrjPPXTB4rptsFRTnPVw+xTGCYVwE5QlkXJ38WzliajHVCXiGz8lIhN2QFRmLq3C1XPi3xCjJI5FmhE7/a1z3fvyWBiF0851mAc7rVJ0DvlJZXWjhzULBP8mBxoE2qpItkoqWJfgQX4a9tP2GnvOzklx+45nJ7vdTjYwV7BypWcQgfoEoG0/PubLVjFE71Jq3p8GQvQJ8kMhwP84A5rLYbptaKlTqjYgq/8j82j5y+HvNHYSSfqgkiJEY4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSYPIBBvbhQ1YIoGfEmexoBK4XfmyCD7yKFk9G1YL/8=;
 b=nimkejgQcsjYf30lBlOP0HjFQq7XgfX6JvbamuLdkavsplRiVbxzuDTCue+Ce+UAQaRf+yZ9XnMew9kCUypPYePk4CU1+o/0wHu4JoZ+d7nnSpCzGebWR9EQNdlMHbRThq+/3RPs2GbxmIto8uPKLUY5KONldEEl7b0l3exR26A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CW1P265MB7689.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:219::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 11:09:23 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 11:09:23 +0000
From: Gary Guo <gary@garyguo.net>
Subject: [PATCH v2 0/7] pci: fix UAF and TOCTOU related to dynamic ID
Date: Tue, 30 Jun 2026 12:09:00 +0100
Message-Id: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMyjQ2oC/22NQQ6DIBREr2L+ujSAFW1XvUdjDOJXfxdiAE2N4
 e5Fu+3yTWbe7ODREXp4ZDs4XMmTnRLISwZm1NOAjLrEILlUXEnFZkMNdU1PH1blqNFwXqryBmk
 wO0zxKXvVP/ZL+0YTDsPRGMkH67bzbRVH7694FYwznRem4nkv2nvxHLTbhsVeJwxQxxi/YX7bW
 bgAAAA=
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
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-pci@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, 
 linux-scsi@vger.kernel.org, industrypack-devel@lists.sourceforge.net, 
 netdev@vger.kernel.org, Gary Guo <gary@garyguo.net>, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782817763; l=2995;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=zT8CR1hu18sGi5f9+9wkDL8BzV1/sK8mE83mrlSqGJw=;
 b=dAL3MZAHGdq/f1A/Dc23e+hpW7HjiDscNeb1WUmBG8M0zwhxEmtW2JcB1Sxda8l9dM4iS5kFZ
 gXJhrcBh+apDxEs35LdGkfVA7RpAZjzwYT5L+LNlkyJoV121PGaoRjF
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
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CW1P265MB7689:EE_
X-MS-Office365-Filtering-Correlation-Id: ad4e9196-c1f9-41a8-161a-08ded6980aa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|23010399003|18002099003|5023799004|56012099006|6133799003|921020|3023799007;
X-Microsoft-Antispam-Message-Info:
	7SMa+fTXpfOFdZ6s7LkS7UxByOX0tObGy59wMJZvQTmdqGlp27HNMD+U0dS+7uqjYhUHqVfXOPfHL+PGotEAAWvhLnxsupcRhJpo8Ka27y7bfLLmYO0CPplRJQ5FA/nYpL8Vy3HbYxEa+PQX0iEZEcz/u9Ad5unoTuJLnPaDbDhlKTCgQcQk3T2Wmp6fnv6u9++23M98Z/fJdFP9XZbE09fE7jFxfROJPQ0xsl9U1XEPXn+XZsXLZmvLolOjwJb2rEcSYZhRG23HAzd+QOk70MjsEZtyRKSLl95xA2rbD+tryBTaFIvER3Tfk+YEF7jPiHnxrpghY/jRgAcxPrRKaNvGm9eu0C0LHAYEP8cItvNhiIPP6M6dOQWTtLoXS/6UAKt2+MT8koo4qRlgPZw32pmgssGqa9+zVN+KMmOmmj2m5+BqFmIjVvCDZTdugKsEmOykboJPWZhqkQk4tXCIYw9WpdtonSAB4hDPlfxyTy6J25nSSX+jh0Xv6jgS3t7epWpM8nQwUzaOWJzBErPmrl7w+sIinUwlMBTEG/IljHxANhG8w6HgY3wIeXFAO1RupQXfnS7mboTUrC7iYlsVp7oU8DxDx+C2rpfXoi/9HZ7TW75cZ2WWuLQgdPAGSMJ6Moe+J1iNn5B2tsmWlnFSPjk0+20qmxHRRcoBWV4aYuQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(23010399003)(18002099003)(5023799004)(56012099006)(6133799003)(921020)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXd0WWFPcWJHSEQzU3FMY29BaDM5a1g3SGFVTUVPSzhPQjY5VzA4Ti9BVXpx?=
 =?utf-8?B?RFE1VmdISlR1Nkd6MXVyVHJFdFZmOHpuSE1Ba2RJd25rd0RwSHVqRmRjUHNz?=
 =?utf-8?B?Wmt6RjZUTTZqYk9CVkdUZU5JYXdZNGVVL2ZiTit3b3BBYXp0Zi83YWx5MUht?=
 =?utf-8?B?d1NXM1FqazBrY1Y2Ull5UVIwQ05rMlpvT2hBWUROc1FoZDQyNHU2NUJmU2Vx?=
 =?utf-8?B?S1h1WU8remd6ZFh2VVN2cFNhdUZzNzZiN1U5MnQxV083NnY4S3FqRHc3LzBx?=
 =?utf-8?B?N2lFc25ubDlORVZJWUJmNlMyeXk3NzlTSFdUUUorSEo5RG0razdNQjFENlVS?=
 =?utf-8?B?dUxmdndIZjA0UmZFWllPd3c5dVVLOG5UdE5ZZGZTaEptUklUbTRxeHBxYmRZ?=
 =?utf-8?B?MUp6aHhCcjV4M2grcmpaYVd1bnVSTzQzSUt4Uzg3Y1plTmVSVnJjS21RNWhm?=
 =?utf-8?B?Zmh2cmhKNnBaekJNKzNoT2lLb3gvTkIwVzhLYlRlNmI1SFBDWFBlQ2ZacCtl?=
 =?utf-8?B?eFp5OHBaQ1hHT0h6NGFwb1VnK3VydzRSalBaRGpHMGl0WFJMK1I5THE0bGM1?=
 =?utf-8?B?NzZ6K2FaaG9RRUN5RWtKY0g4cHA1ekJCcjYzSnhGQVEzM2pzYm5NdG5SVkw1?=
 =?utf-8?B?L2lZZFVWWFN0TloxZW5rRmY1V0M1aG0xbldZK2s5eTRZMG9sdTVVNmx6cE9r?=
 =?utf-8?B?Vks2RGJlSjJRTGhJMEhkZ3hPUXJxMDJCc2Y1eUZsbk1vbDlEUERKRXd0WUdI?=
 =?utf-8?B?MjBFQ3NoMjlYTlpBUGNkdkg3YURhODdvTU5VR24yYzBLeklCMTF3T0RjaFJa?=
 =?utf-8?B?YmVEekhlWkFHOHpIbjNrL2xWNURoaUhNRVczZkRMZGsvSUhCaWs2eXQ4eDJO?=
 =?utf-8?B?aWdjUjFuTXRFc1AyVzkwNWlsUmxRSFlwSEtOQlNidEkwcjdtUE54RU9uOXV4?=
 =?utf-8?B?TGpndXlMa1RPd2tuSE9wSGJySkowM3NvekJSeXkzK3ZXY3RuZjI0aGM5Tnpr?=
 =?utf-8?B?VlBKMUZoVjRNYUgzd0hFVEpCOUhrQk56L1VpOFZzbTBNdWhJbEpzVFpqSU51?=
 =?utf-8?B?RnUyeUsrTzR0TWhqR24vUXIxWkx6b2RNVHJyc2xFVVhQbWJ0bVhOUXBtSWQ4?=
 =?utf-8?B?djBEcDVGRXZFMzRrdFFmdmlEMk9LbkJVRExqMTdtcjZEOXRKS0RRcjJkbHpk?=
 =?utf-8?B?ODZ3MmQzWVJTUTdwUVBDNTZ2R3U1bFRuQjVnU1BBYndadGZhMGlvcDIzQUFu?=
 =?utf-8?B?ekZ3QnBFSDlMZzRBNmpoV3d0NU1vVXBudEV5UDZWc3RZenREYlNNd3RwWTVm?=
 =?utf-8?B?VVhQUU4zbDFVSUplQ1JnZk5ad05vUG4xTjFDTjVNVS9admorYmF2Q0xNUHhn?=
 =?utf-8?B?SHAxUWhUTFRYTm9Hc1V3M1pQQWJtc0pLWGZXSEltMTlGRFI5MFlNQW1OSDB0?=
 =?utf-8?B?WEd2VHNjd2k5T0V3cDBMTEt0dGg5cWxWM2Q5VTN3UVNoSk5mR1cvWUJHRlN4?=
 =?utf-8?B?NWliOXN0TTZDcjZQUGhRZzAyVWw5WWZFVklWT3FVeFdJUXNvbS9vVzdJVjRW?=
 =?utf-8?B?Q3VrRDZZMFlKMkp3dEhldkdMd0RYRERCSEN2TG02WXNLZXBjRjl3cXY5MzJB?=
 =?utf-8?B?NlFqRHl1b01UdEYvZmlmZmRRaEx4OU41L2VYYjBhOXJVeVlRTk5xam82YmRl?=
 =?utf-8?B?NGxMZHBTMjJyQXNvQUVJaGhOSG5DZ0hiOXA3ZFpQN01iTS9Wa0RhcWdPZFFa?=
 =?utf-8?B?dEwrZm1Sa1pLSkM4RVpsVGRqZEllU0RXSDlJdnFzYW5GcUpBRFFjVElZVFZZ?=
 =?utf-8?B?eVN5ajVscGxlbUE1a1BoSWRGSDRZWENGMkl3R29QZFFTMm1MMDlFZm5ua1Zt?=
 =?utf-8?B?RFhnTjJRTytJYkVNMHpTR0tzdHFONFdneVlWZ3dXWjVSclFrbGp1MHVCTG1P?=
 =?utf-8?B?YlpHcDhMOWFCWmxEV3k5ZUNnZVRwYk1KY1RUSUd6Rkhmejg4RWF2OHpQSTZX?=
 =?utf-8?B?bEwwSFg0NUF0WEtVQk9VSTVCUURYblZqcmJJUnVYY05pMWx0TkxtR2RMZEg0?=
 =?utf-8?B?a2FDTlVYcVppT2k2WUgzd2l6eGp5d3dZeUU4cU9WQmJSRzdFay9JcDJSeTNh?=
 =?utf-8?B?YlBSekNsb2xTcW1laUlWRDYxRy9MQ3FwbE52Q1lUUUIxYzZBTnRZTjhRMUpG?=
 =?utf-8?B?N0FJUkhZTG9Mc1ZDSmUrc3lpNG5sM2ZsRVB1Zmc3ZUVrMHRqaUdyVGtudFNt?=
 =?utf-8?B?UzVod1N2OVpiQ05zQmJNZkQ3MXk5TmRFa1ZScWVsaFdkWXRSUDJlY3NNRUxv?=
 =?utf-8?B?RERiU1IxcDRsZWI4ekYzYkhkNE1wbFduVldCWDE3ZXBkVlhTNEpCZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4e9196-c1f9-41a8-161a-08ded6980aa2
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 11:09:23.5629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DP3ZlZgnMbqi0CrRn+o1NeTgleT429F+nzcVvt4E+D4tGEIO2cYyvtvUMyCqFDtmxzZbEEA4EpfbcCrFDHsEmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB7689

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
inside pci_device_id is what they want. Actual ID information can be
retrieved from pci_dev instead. I've used the following coccinelle script
to find the cases where the argument is stored and converted them to stop
storing pci_device_id.

@store@
identifier fn;
identifier id;
expression E;
parameter list[n] ps;
@@
  fn(ps, struct pci_device_id *id, ...)
  {
    ...
*   E = id
    ...
  }

@cast@
identifier fn;
identifier id;
parameter list[n] ps;
@@
  fn(ps, struct pci_device_id *id, ...)
  {
    ...
*   (void *)id
    ...
  }

@in_struct@
identifier s, fld;
@@
  struct s {
    ...
*   struct pci_device_id *fld;
    ...
  };

Link: https://lore.kernel.org/all/20260618-id_info-v1-0-96af1e559ef9@garyguo.net/ [1]
Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/ [2]

---
Changes in v2:
- Fix users which store pci_device_id.
- Clarify in probe documentation about the lifetime of pci_device_id
  parameter.
- Dynamic ID conflict check now ignores override_only. (Sashiko)
- Link to v1: https://patch.msgid.link/20260626-pci_id_fix-v1-0-a35c803f1b95@garyguo.net

---
Gary Guo (7):
      ata: don't keep pci_device_id
      nsp32: don't keep pci_device_id
      ipack: tpci200: don't keep pci_device_id
      mlxsw: don't keep pci_device_id
      pci: make pci_match_one_device match on ID instead of device
      pci: fix dyn_id add TOCTOU
      pci: fix UAF when probe runs concurrent to dyn ID removal

 drivers/ata/ata_generic.c                 |   6 +-
 drivers/ipack/carriers/tpci200.c          |   1 -
 drivers/ipack/carriers/tpci200.h          |   1 -
 drivers/net/ethernet/mellanox/mlxsw/pci.c |  11 +-
 drivers/pci/pci-driver.c                  | 219 ++++++++++++++++--------------
 drivers/pci/pci.h                         |  36 +++--
 drivers/pci/search.c                      |   6 +-
 drivers/scsi/nsp32.c                      |   8 +-
 drivers/scsi/nsp32.h                      |   8 +-
 include/linux/pci.h                       |   1 +
 10 files changed, 166 insertions(+), 131 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260626-pci_id_fix-83eaec007674

Best regards,
--  
Gary Guo <gary@garyguo.net>

