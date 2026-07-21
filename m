Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020083.outbound.protection.outlook.com [52.101.196.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BEA35F19D;
	Tue, 21 Jul 2026 13:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784639853; cv=fail; b=MBc0hecTuHukYbcYo7KIlZ0Yr4nICXKoR5hrREM72ZUZ4lqEwNAocBd8JbulBW/obn1ygmeiT7lkS9YoVVbrL8dXTchEeh5SsgVp+QmPwKZyIZKWIvyV9KM5KyqnLJNaEhwpZZ9jb63S0I1xLWBhePFY2A7TMuSMJcwOSBYlFnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784639853; c=relaxed/simple;
	bh=Z0bpieTNOHx07Z9iq/uv9U6z0bjxL3b+wtFc2pQOaNk=;
	h=Content-Type:Date:Message-Id:From:To:Cc:Subject:References:
	 In-Reply-To:MIME-Version; b=TzXK/+PIAs3Sy3G52uuCXbSjhoLX1g7J1UpOCbUkkzjBEekWzNU0B+Onie/yRxjKgYxGEZ2wljCqJmMwxfEtAo/ithiSJqmCUtiaYtPOs7cSDaOm7NK/jaexfSiuNpTp/CdNKyk/xDCZYS8Jnlzq6OhVkr1hTtYFalqOVoH/524=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=e8soE8b9; arc=fail smtp.client-ip=52.101.196.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="e8soE8b9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCwMiBCsbhGkSftUcNyVUAJg6pW5whpb/GlA0ewlzEAYN6TqqZ/xp7cKiqP8UYZuIbsfyQuSYGcox661wZ9eEY/NcA5PnW0Dg/106DTnMcwPIQ0VTRWGGXV3mVuVFiUKxLwrZkVl4DfLgGxfOK60vIXxwgA2SAvQtHRupFZyzULnb23VUGueCMG4c1wcFdsJbcFlz8tJ0PkPVwgoPyYr5/SEnOTmBVnuZb1RW22u7up/ZUzVL/0ml83XE33/nAo4Of6IR2gnRYUMJJcSysxuIUZch7M3CJ9Wa7lbGSzUsk/oikbdqd0EV1PwP/sSdufNY0dwtcq3swSZ5Y+wVBZ4xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ab/euh2779ge0fwqSyRg0m0xs/DjxeCz8RqLFSjPi3M=;
 b=IuXGl7p8cnqy1tr8ICGvcvAFqMvgGtpwTyNv4lQvWif18vlmsCN04zfCALA4Q3u0qV0nGvDqjbZF1XZKygVNfBTYuGiP33Lk/CKrlWpFEDmIprYYS6mi/4Zvr+UzXZr03vb4d0xPZgRMCM9kCZhvJ0dY2fS8jiInq7UtmhpUgh0AcxFc/g3bKb9Z/FL1GZy0LcI3q2VSN0Q0NbABZyWS28TlWqZZPVPBkaCIgZhBeHAdZtMBoVf+Vr3XE34sqDsyVnlBhmxLZg3DUQeDdbQzn3qscz+UOKEMOsfthF2iBA5Yvf9pW2r99gz0WtChpYVM83+arHtZmfly65tHWp/C3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab/euh2779ge0fwqSyRg0m0xs/DjxeCz8RqLFSjPi3M=;
 b=e8soE8b9QgQ0I54VH0jGzwPFvEdK4s8Ys+MhrZe1CXyr+TFdptGKzca45TTqoW/xDJ9btXYBveuxCVWyksuRMeUkEvHPEDLgVO5AnqcXIybYYtnELSOOcvUQFHKA2dfFiLTJUEQolVMbzrY7DD9d6eraRQOd9GcfYK05PmKTmG8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB5941.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:290::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 13:17:24 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 13:17:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Jul 2026 14:17:23 +0100
Message-Id: <DK4A0XTUN6JD.2NLSFKQSU7R9I@garyguo.net>
From: "Gary Guo" <gary@garyguo.net>
To: "Bjorn Helgaas" <bhelgaas@google.com>, "Zhenzhong Duan"
 <zhenzhong.duan@gmail.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Danilo Krummrich" <dakr@kernel.org>, "Damien Le Moal"
 <dlemoal@kernel.org>, "Niklas Cassel" <cassel@kernel.org>, "GOTO Masanori"
 <gotom@debian.or.jp>, "YOKOTA Hiroshi" <yokota@netlab.is.tsukuba.ac.jp>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, "Vaibhav Gupta"
 <vaibhavgupta40@gmail.com>, "Jens Taprogge" <jens.taprogge@taprogge.org>,
 "Ido Schimmel" <idosch@nvidia.com>, "Petr Machata" <petrm@nvidia.com>,
 "Andrew Lunn" <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "David
 Airlie" <airlied@redhat.com>
Cc: <linux-pci@vger.kernel.org>, <driver-core@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <industrypack-devel@lists.sourceforge.net>,
 <netdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>, "Sashiko"
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH v3 0/9] pci: fix UAF and TOCTOU related to dynamic ID
X-Mailer: aerc 0.21.0
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
In-Reply-To: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
X-ClientProxiedBy: LO4P123CA0042.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::11) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO0P265MB5941:EE_
X-MS-Office365-Filtering-Correlation-Id: 7828293b-410c-475a-5e1c-08dee72a6726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|10070799003|7416014|376014|10067099003|6133799003|5023799004|3023799007|56012099006|13003099007|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	F8Tz4ziEvOjWx2hGD1cWBZhCD/xU4pTChYzvDdgGizbsQEentsIAWbGRva8mn1k9OL+AOtyP4VI/8O4i1qAym14q62yxlLSPVgWzZTtNS3eb36Xey1TLjQ4ItrvCZAt5gVZKMd0ASDe/a60xeHZBMH01TiMXujByTA3JVh2imwo2ezC/xjkPa9wpaik7J7P3LF2tXWQjdx39FxYKZ9HAAUu/oWAflZVMTHAkrejMULPPMQU5j79OPyBIRaJaKV6dUnsH8DE7MM+TPSzMzhhAiz0+27rENoa4sNU8zvy3ahYzoOYuv/KN5sxwKCge2FOR78iIIm4jlMjBW8I2y0SFnqECRl820pILGhgrxcpO6X6Hs4o55sQrpaAGmPpRTThlN/S7JSCcDMH66jWJW7gcZRnKRZn/twPT0/3VTN95JHhbSHhwKmU8nugwmTeoosG184iQfIneIZACz5Vylw4+gwalquZnGDi3huXnTqi75YUzKU78PMdbAm8kHDsRxkeD78wEGoOQsLO1u+ey33C6W7nsx/C+rkvJIWU6IpnS1sjqFAzR4LpUDm6b4xm83TRk/xAZMKyKqnqpJgRiD4ilnGC89YnfOUZjT5bHq9bk/o+Gwnr9BEa49G6t4MhsAI9/JOpkLkEqF7szDoe6pz4H/DAm/2TwZJJQm+uJ4ic2r8k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(10070799003)(7416014)(376014)(10067099003)(6133799003)(5023799004)(3023799007)(56012099006)(13003099007)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Snc4U1JOTkIyTFhjVGtUbjVZN0duK2hqMHBab1N2ZUJ1aVM3aWhRRkcwOGZF?=
 =?utf-8?B?NkVaZmpVUi83c1c4a2YyNHdMdDFIejNtY2I2V3lGQUxpLzM3UjJ6aitYMUVO?=
 =?utf-8?B?Q1ZraXJVMDJXK3lWWGloL3kzUi9aYUQzQy8vREVVNDA5d0ViMnhnNjJYZUJo?=
 =?utf-8?B?SkRzTTNQMlJmR2czNmVZNXVHa1p2alBzM3pIeUFHREtDT3Nka3RkTmJjYi9o?=
 =?utf-8?B?NURCeE9sOGVhQ2JQMXV1alIyV3FaK21SSTZ3Y081MnJKb2dYdkE4T0VFc0pm?=
 =?utf-8?B?b1NtQThTOE5CaEpCY1AxeHdoc2gyT0JlbXk0cjJMMmlyNEo0WjVMd1JFREtL?=
 =?utf-8?B?NmxuMlVHazRTdW5sazZQZnZFOGY5VFhpSSs3RlRmVmJLTk5xTW9tU2ZETzR2?=
 =?utf-8?B?ZHk5Zy9oVmR3aDRvY29QMWZRZ1laVHhiWDlZam1RaTFCODBRTTYvNVZ6YTdB?=
 =?utf-8?B?MnAzSkh2UlJZYmVjYTljY1R0WEhoUnlhUVE0bTJhQmNRZVFYSTdseS9CYjY4?=
 =?utf-8?B?TVNVV0h0NjNPZkdLZ1JJMTdEbnVwSVVwb0x5MHpFejJhaWFLbkhmRG00VnFp?=
 =?utf-8?B?ZHFvWWxQN0pLNHhpd0l6L1VPbFN6Y2NLbkdMeUV3SG9xeW9QYjhTSkRiOVBv?=
 =?utf-8?B?Y1d0TEpMNG9kcnZLTWFSTlY2VVgxMGhsVFBLZ1pCeGIxM2Iyc1huUkRsMk9k?=
 =?utf-8?B?aGt1N2VHblI5OEZFZ09XTG5BM0w1SHZCWGJvRDBNUWFpU2FMQklUY0NHL0ZF?=
 =?utf-8?B?N1k0ajBpNDVRUzU3cXJXTXpHZEVmSEgzNEFyRi9VenpvZm9LcENGZEJVWWFB?=
 =?utf-8?B?eXVLYUdLbWJ5UnhXQ3VtUVNKbXZ3TXVZcERjK1N0aGZnY2VvS3JWMVNDYXFS?=
 =?utf-8?B?NjNlQ2dvUGFYOXFidTEwUTZTTGFhQzNFbmVZSURXTmNaQjRhSW1NdTUwd1FD?=
 =?utf-8?B?aHlJZnJpN0lKT0EwUDV0OWVMV2h3T1lsdk1QdTFVRUEzTWtJUm9HVjlaU2lo?=
 =?utf-8?B?d3habTNPZklFODVOR2lTeWlIeFhDaVhEbUlhd2tGQUdGei8rVEVvUmd0K2NI?=
 =?utf-8?B?VUVQRzJmZG1NR0xFZlJkQXM4eDEvaStRMlJQTDgzOHFSNk95dFFVY3Rhclo3?=
 =?utf-8?B?Yk03bEE3dEFiaHBXUm1jOVUrcm9YTlhiZlFyR0hXYTc1WkpyS3lmc1NaRVZE?=
 =?utf-8?B?WXJXUEV3WWR4UG44R2JqeEMyTUwwTTFuc1Ntb29tVDJMeDNrUzlLd1FXUWp0?=
 =?utf-8?B?dTF6cHZua28vOHJmYnRpZUN1SmRZbHh6YzVXOGwwQVJjN2ZwTjhkZy9sRmpK?=
 =?utf-8?B?YmFldGpCSDhNbXdubThNMUwvbWhvUTBvN2ZnbTBsY0dYRHhFQzVkaklSUng5?=
 =?utf-8?B?Nk96NkYyVmdWejV1QmNMdTFkaWMyRjhRbnFVVEVXRENqSUxEaE9sZ2dlQWdF?=
 =?utf-8?B?U3dhanRMdzQ1T3Zia1UzK2ZkWjVUOGs5Z0RJcGFvY1d2L1FKRTZONUFhejhN?=
 =?utf-8?B?dnBxcmRXdkVFd1BmK3IwVWNzRm9MRlJ2VkludWM5Z2xpdHE1bVFoOUZTZmd3?=
 =?utf-8?B?ZVZEMDdIU3NyUlVKN0RhOGhHWFRWaWhOZ0FiK09jRGovMnBmeFNRdHo4dkdD?=
 =?utf-8?B?c2p3ZjNzVlMvR25vUE5KdGR0ZFk1eFdCNHUwZ3VSRjUyajYwTVhBbEh3eUZv?=
 =?utf-8?B?V2IzUW9JSHVjQi85S3hLc0daOG1JanVoSzdSdndTMzRpMTRIWlY1ck9JMWt4?=
 =?utf-8?B?V0h6SWdLdGxJNWlPaGpXSjFDMG04bG8wTFFNUHI2OHNVWXhXRTM4UEJCNmdT?=
 =?utf-8?B?bkFZSkQzMDZOUmNRSTM1V0Y0cncvNmZHZUhPOVN6STI2alRQeUtnV0VqTSs3?=
 =?utf-8?B?ZHlRY1p2dDFSYU5GMXV4Vmh5QjVQNzJXNHZBN3gzOU1xY2ZvbmtwdjVxQWdR?=
 =?utf-8?B?ZVQ1REhNOStOTXJRa2xBK1ZobnRpMitUcFRpempvU2dTb203L21yUEpDQkEv?=
 =?utf-8?B?WGdLVExwUEV3MTlMMGNqamlXL1g4SHYzNHRyaTVnM0lQVVlDTzdEYmovbU1y?=
 =?utf-8?B?QURCN2lwS0c0K3lEZUx3dThwNC95YXczN283TmZFWitLZUdLdlVGZnZEZzVw?=
 =?utf-8?B?UC9wY0E5NVpES3pyK29Vc2UrWXRMM0tqSGhYWktybVVFMjZabmlyZ0tHaTNM?=
 =?utf-8?B?MVc3MnZJQTluVHE5d3FmTVNTM2VQTkRCZGRELzdWdDF1b1UvN2RZQnVqeGhu?=
 =?utf-8?B?cGdYajNiNkVDaTR3Rlk1TC91eXNCUlNSUUlFcUpxdHhYRU94TGtqZjRCdnk4?=
 =?utf-8?B?cTQrWlZ5aUk4SzJNbXdHWVY3TVJEUC9ZVmlvNDN4b2NzdUlGZ2VYdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 7828293b-410c-475a-5e1c-08dee72a6726
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 13:17:23.9729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjgZ6KwZMeXXIKF30Gady7/4lt5WfNJB9/akPvvb/QoBDEBHNUioGU5bpg5zrK6XbE9qNldeMVp2oNe4b8ORmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB5941

On Mon Jul 6, 2026 at 3:11 PM BST, Gary Guo wrote:
> While working on improving the Rust abstractions [1], Sashiko reported th=
at
> an existing UAF issue related to dynamic ID, which I find to be genuine.
> When taking a look at the code I also find a TOCTOU issue where the
> existence check of dynamic ID happens in a separate critical section as t=
he
> actual insertion. This series fix both issues.
>
> There are two exported functions "pci_match_id" and "pci_add_dynid" which=
 I
> have to tweak to implement this cleanly; I created separate "do_xxx"
> functions to keep the existing APIs because they all have multiple users.
>
> There're a few existing users which stores their pci_device_id argument i=
n
> probe callback. This is a bad pattern because nothing except driver_data
> inside pci_device_id is what they want; actual ID information can be
> retrieved from pci_dev instead.
>
> There are two users that performs pointer arithmetic on the pci_device_id=
;
> these are also problematic with dynamic ID and driver_override, so fix th=
em
> as well.
>
> I've used the following coccinelle script to flag all cases where the
> pci_device_id is used other than reading its fields.

Hi Bjorn,

Could you take a look at the series?

For reference, this series is the USB equivalent which is already applied:
https://lore.kernel.org/driver-core/20260707-usb_dyn_id_uaf-v2-0-632dcf3adf=
ba@garyguo.net/

Thanks,
Gary

>
> @usage@
> identifier fn, id;
> position p;
> @@
>   fn(..., struct pci_device_id *id, ...)
>   {
>     ...
>     id@p
>     ...
>   }
>
> // Due to cocci isomorphism this needs to be explicit
> @bad@
> identifier fn, id;
> type T;
> position usage.p;
> @@
>   fn(..., struct pci_device_id *id, ...)
>   {
>     ...
>     (T*)id@p
>     ...
>   }
>
> // Good use cases
> @good@
> identifier fn, id, fld;
> expression E;
> position usage.p;
> @@
>   fn(..., struct pci_device_id *id, ...)
>   {
>     ...
> (
>     id@p->fld
> |
>     E(..., id@p, ...)
> |
> // Redundant checks, but ignore
>     !id@p
> |
> // Redundant checks, but ignorehttps://lore.kernel.org/driver-core/202607=
07-usb_dyn_id_uaf-v2-0-632dcf3adfba@garyguo.net/
>     id ? ... : ...
> )
>     ...
>   }
>
> @script:python depends on usage && (bad || !good)@
> p << usage.p;
> @@
> coccilib.report.print_report(p[0], "suspicious use of pci_device_id")
>
> Link: https://lore.kernel.org/all/20260618-id_info-v1-0-96af1e559ef9@gary=
guo.net/ [1]
> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel=
.org/ [2]
>
> ---
> Changes in v3:
> - Fix users which uses pci_device_id for pointer arithmetic. (Sashiko)
> - Convert to scoped_guard. (Danilo)
> - For static IDs, still give out static pointers and avoid making a copy.
> - Link to v2: https://patch.msgid.link/20260630-pci_id_fix-v2-0-b834a98c0=
af2@garyguo.net
>
> Changes in v2:
> - Fix users which store pci_device_id.
> - Clarify in probe documentation about the lifetime of pci_device_id
>   parameter.
> - Dynamic ID conflict check now ignores override_only. (Sashiko)
> - Link to v1: https://patch.msgid.link/20260626-pci_id_fix-v1-0-a35c803f1=
b95@garyguo.net
>
> ---
> Gary Guo (9):
>       ata: don't store pci_device_id
>       nsp32: don't store pci_device_id
>       ipack: tpci200: don't store pci_device_id
>       mlxsw: don't store pci_device_id
>       agp/via: don't rely on address of pci_device_id
>       agp/amd-k7: don't rely on address of pci_device_id
>       pci: make pci_match_one_device match on ID instead of device
>       pci: fix dyn_id add TOCTOU
>       pci: fix UAF when probe runs concurrent to dyn ID removal
>
>  drivers/ata/ata_generic.c                 |   6 +-
>  drivers/char/agp/amd-k7-agp.c             |  26 +--
>  drivers/char/agp/via-agp.c                | 308 +++++++-----------------=
------
>  drivers/ipack/carriers/tpci200.c          |   1 -
>  drivers/ipack/carriers/tpci200.h          |   1 -
>  drivers/net/ethernet/mellanox/mlxsw/pci.c |  11 +-
>  drivers/pci/pci-driver.c                  | 193 ++++++++++---------
>  drivers/pci/pci.h                         |  36 +++-
>  drivers/pci/search.c                      |   6 +-
>  drivers/scsi/nsp32.c                      |   8 +-
>  drivers/scsi/nsp32.h                      |   8 +-
>  include/linux/pci.h                       |   1 +
>  12 files changed, 230 insertions(+), 375 deletions(-)
> ---
> base-commit: 2b763db0c2763d6bf73d7d3e69665222d1f377cf
> change-id: 20260626-pci_id_fix-83eaec007674
>
> Best regards,
> -- =20
> Gary Guo <gary@garyguo.net>


