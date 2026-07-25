Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020129.outbound.protection.outlook.com [52.101.196.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BF63FFD;
	Sat, 25 Jul 2026 12:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784981878; cv=fail; b=PHWFW1ggmTUr/BIFgYhIqUouHvIBFgn59+QnUe7RPdFAlUkJfr3Vm57+bj0YfhKIuYakBNKyYCrjuTda8+2AieIdZyaxpVc2k1o5E9Mo4lBylFalrraOapy1+NwImmBBIU7m/hN3oSQKY3WpDWRkMZPqyzxBnkZm7r3WEEjUqV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784981878; c=relaxed/simple;
	bh=yVMGbhaGodUwjJriF3oWaZ7/rDJaKs5pPrZRnRSZ4/Y=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=QSftGdfmVTlBvbR+uRJqPl+bVUuxG2dk74DU/LXFaZqShw+/S0UfWjlifxQFLvmNhj0MW4eEn8NMluKEVs76Fw8lIYiqVGn6l3a1romvv4YEGPD/kRFX56lk/OBXyUrRHsBMXoTIQwnfSDxBP+P0HaFjLARcpL9nRUGQY47CSfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=NaeaoYmh; arc=fail smtp.client-ip=52.101.196.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="NaeaoYmh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nGQ+PuAzyUbVuCUFjVhbFcPEEVKnzUQTsmRA7HD9m9CB5qLQBjqJ5yWsPFGAP036Mlh+iWVGzcVD186XVZGN8ItHfgRpeeMSEyzztpJ2F2DyijbH9Z1rnbgfdkGNtIIN/ivBIuhUOhEnbMfJf17eFahOTuq/icDZWp2xOpQygGOL4DZuQ3qqNaEkewcrkpmUmRFoW0CJQ19mfdJRVnplNkoQ37Uri2XW2Q+3lWbAXoCq1UFGWpEaTV75hlbWkNtkGT4n5xLJ9bnVorAr3/aSEwc3s5JPPwwAiZlO9eOe8wMxVBXldhwJvU8NGDx3EpXUmkgt9WaqBIcSRfHojZHkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNk6UvBxyZWHa+zO5lIgmskVo9UP5aaS/0UK+T7ned8=;
 b=a/53jDqoqgzcPot6BYbN5LO7TrQ07YWIYv27PKZaCE+/EW1wNqaG1DYTzF+5RDTKbzhfF7VK5rHJ38dk/HJ45gHy+I5+/Ap77D1dObqUszITZv/pjxtc2Ub2M+nD4lHWo/VZXkyZfkk1yrpkzO9DvdoV/JKEaMvbKSGJhZxrubZxPzCCvpIG3/MJuJOMJ9G0n4NHTPaGiZWVxKLAwcrhot/jGh23V8kRKYZAQcD62Q0G55vPLP7y+ZkcOVPJcfxlelzQF+E4MVOuFSyVUNY29Rh7EdD9+sUNEJVH66PBZcryTVwuqNs8iM/egKNF2LWk409Tbs+dXG/nJOAWnMtaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNk6UvBxyZWHa+zO5lIgmskVo9UP5aaS/0UK+T7ned8=;
 b=NaeaoYmh4WCuFYoK1UVmxH/I8sBFSlVIfEO78yuo7/535dnXqN4XIrqBrQ1U3aoepytrzK0kpUdqRvyqcedmYe8PYgPK9PaNn+IlMFmOoQhf9R72vp44MeRTzn1GVFbktJcLHXE0Tdw9ozGjnQs+DBD1otXb+0Aid7d1SA4pAJQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO2P265MB2638.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:146::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Sat, 25 Jul
 2026 12:17:51 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.012; Sat, 25 Jul 2026
 12:17:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 25 Jul 2026 13:17:50 +0100
Message-Id: <DK7N9IZPWPIT.2AKSZR5CU1H9L@garyguo.net>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>, "Zhenzhong Duan"
 <zhenzhong.duan@gmail.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Danilo Krummrich" <dakr@kernel.org>, "Damien Le Moal"
 <dlemoal@kernel.org>, "Niklas Cassel" <cassel@kernel.org>, "GOTO Masanori"
 <gotom@debian.or.jp>, "YOKOTA Hiroshi" <yokota@netlab.is.tsukuba.ac.jp>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, "Vaibhav Gupta"
 <vaibhavgupta40@gmail.com>, "Jens Taprogge" <jens.taprogge@taprogge.org>,
 "Ido Schimmel" <idosch@nvidia.com>, "Petr Machata" <petrm@nvidia.com>,
 "Andrew Lunn" <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "David
 Airlie" <airlied@redhat.com>, <linux-pci@vger.kernel.org>,
 <driver-core@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
 <industrypack-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v4 7/9] PCI: Make pci_match_one_device() match on ID
 instead of device
From: "Gary Guo" <gary@garyguo.net>
To: "Bjorn Helgaas" <helgaas@kernel.org>, "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <20260723-pci_id_fix-v4-7-3580726844e1@garyguo.net>
 <20260724222939.GA1065077@bhelgaas>
In-Reply-To: <20260724222939.GA1065077@bhelgaas>
X-ClientProxiedBy: LO4P123CA0501.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::20) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO2P265MB2638:EE_
X-MS-Office365-Filtering-Correlation-Id: 590b93db-b5c8-41b2-d862-08deea46bf76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|10067099003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	twevpjES9NDYHMjfv2iCR6znR1SwXBTZEaA12FyFjTI7kjZH26kvoNtrQYHgxwPqf3G38EB2ij7tEMZ8935MLg2xcKrWkS5+FRCQNjcCl0NRmH08kGYbcqcwUaLVEoryy+Nnq/WcJqsgPAPDbf1uFEa824oT1slbwF72iHsLQvvoQuN06Trb617wB0ck/LpRTdNfenTwJcdUlziGGbN/KpZKduhX1UidjGzQZy84lZ3g8+yvbu5V967AZs1OFbL+4SRXK5uEiBgG9qWFBcbPpdc4g00QnnvwgISR5+o2kiIOsbI7em5o1+2/nQQiDM90A7qFMsMbmkB70iVXIHavQKhNtvxPftLuzxPPR4OYgxMESZZiWaQy+RfvbT4CiX+S2T7dmwhcqqad67Qsxi849uXRFY1PCiJN1T7/ZdmemygaoQLtQi1NnJCwqLmORLMe8psTMHj7x/NG54HnCxpX8Pi9hlOqGpu+SMbZw2JVzu1CJoWCMFL17Blw3P5TDeBYgxJuAg0tIk0kQ2/QPfRbadzgAUy0HFFkKCP8mL7dzpMwU1CvME3n9LE6Rm/yTY0wVtXW6xwz6esLfhOYLfrj1Cq0f8WabAaI4o6miR+g5TC3x4Doo8R9HtcQI1GTNgQ8Gh4yM18DWkMJ4LREq9io9Tr9wOAg2+/yiUADtLUjTLg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0xtMTZvQnVaUHhwQWEwZVJYWGlZTWY4T2JpT2F2Z1N4bFYxdkRhZkxpdGpl?=
 =?utf-8?B?VFlBOVp5Q00wWThhY0JiWmg0cjFZbWpocmFnTTN3WXk3UUVWb25mbzJNMHJn?=
 =?utf-8?B?cmt1Z0JlbzdrbUNmVC9tNW9xVm45bEFuNkxTcVI0MGJqSmJjWUJKUUl6TEs3?=
 =?utf-8?B?SVdXV3lta2RlSS9ySFI3Z2h2ZlI5RTNySkw1OWw3NmVuMmZxUmZVeVU3aGZ6?=
 =?utf-8?B?VzlNa214MTA2SUdLYko5Njc1T0g3aW8wQ3VHcVc0U1IyZkdpbFR5di8yWnhw?=
 =?utf-8?B?b0pWaTJjK3c1YlVmMnZ2bWpDM3BGZHdqZEdTUnFpTkVHcTkzbTlXOVUvSTA5?=
 =?utf-8?B?TnBBbVQ2TklDdFIxRkZHSjJ6a1ZjSUNPV2JEdmUzdFFRNWgvOStoN1hyUEY2?=
 =?utf-8?B?ZFZGb2xBWDBrT28xQ2xodzFCQkdzQkIrVDF2cUlEODBzdlBqKy9RL1hsTXJ6?=
 =?utf-8?B?WDlLWjVLeGhMNXZlV0pOaHJVYXVNRnFjLzJ4S1FqenpNbVhWV3g1TzVuQ2ha?=
 =?utf-8?B?aGh2WWJidG0yUm9RRTFVeXp5VDR5Z2s5eEdOSEhqODBrOWtrNzRXMm9UOFZF?=
 =?utf-8?B?ZWx2Y0t2RW1uWmtRNi9PK2czSUhnSmV5ZHJ3blZyNlJIWU5kQWlkR0Jjb0M3?=
 =?utf-8?B?aFJmQ0s1MGsvbzRGMzNoTE9jK0l5TUVxQTBWb0liQTBtWDJadTlvdGg4bkxD?=
 =?utf-8?B?NUFOYkdPaXZ2TUszcXpPVzIyT1MxaG54RHdZd2NyV09GUTJmTmVFZUQ2Qjky?=
 =?utf-8?B?N04yMTBXVVBvUUVtbTZjREcxR1l2bnNWaXlITmU2amtxdklXcXcvWnM0NThk?=
 =?utf-8?B?ZzQwd3E3cHZ0NWlOYjkyRFVRdzRjR2dPNDY1T3JpcWlUNCs2TW5sa2V2OCtP?=
 =?utf-8?B?S1pBRUREZE9ldDRQS1ZxeFJVd2YybS90T0wvekNrOXo5WkhubVVMZS82OTR5?=
 =?utf-8?B?azl6NHJVRzhtV0tlZDNOdHNDQkd3dEhuYTZQRzNpVXNvNUZnMHora1A5QzBR?=
 =?utf-8?B?amhmSWRPR2xPcE8ydTlPcXJKQTRnelIzdm5nak5IWno5NE4zSlY2aHl6Sk5w?=
 =?utf-8?B?Q3FreFNtbzM5M05ycjdadW54S2RqUGcrU1YwWC9ZS2svVHdLaHpqZis5Mm5u?=
 =?utf-8?B?MHpNUUJiR21haUp1UWd0S3A3S0VDQVRoT0tkVVg0aXovQ3k2eEw4eStBSXNm?=
 =?utf-8?B?aWlRVXZyZTFQdUcrUXJtaURVNTNRdGNJeEVLNENCV2ZVRUN6K2M3KzlZblhx?=
 =?utf-8?B?RUQrWGJmMTZGS0xMNTdJSEkzRFJhdVpGZTFMR2dIY1ZOMXpQVjl4TWsxbVlS?=
 =?utf-8?B?QjhaUVRsTjViRnE2eTRqSnZEdXFNSktDaHNjdlFLQjF3M3dlQ2dxY0FIWVJQ?=
 =?utf-8?B?UWVXWUd2MDExeUZuc2w5aXU3ZkZGOURUQ241dEEweXNLR0FEejJHSllmOWR1?=
 =?utf-8?B?cUhEd0xlNUczd1MzREd6SjNQVXhYcC8zN0djM2UreU53bUw2SHplYWZtZTRj?=
 =?utf-8?B?ZG9hL1U0Z1NkRTRJVWNHaHIrdnBSTVgzc1hwQk1GSk1wMFhEc2hBUXJZdURu?=
 =?utf-8?B?UlRPVE5XUjl6REs2SkZqS1c4c3MwZjIzR2syYzBPRnovRVpOa2dlKzN1MkNu?=
 =?utf-8?B?TzJmeG94N3hKeDhnWWNSQnlUOElzVFBKQU5wU1hqMy9NeE5TNlJaWU9nbFRJ?=
 =?utf-8?B?OE5CWEtjWFpHK3ZWbWY0TTZ3K1drVDBnekkxQlRKcnUwTC84ZXVoVjA5NnNp?=
 =?utf-8?B?Nnkvd3l6cW41S3grbjNIb0hKbTNsaDNpc3dBSU5DVk1yUkk3VFJtbi84cm1K?=
 =?utf-8?B?TWlSS2Q5MjZrTWQ2NlJ4RDR6S0FoUmdMZW5JK0huNDRCNDAyTjJXVGZEU3F0?=
 =?utf-8?B?Z2F1L0R2MlF6SFp5US9UY25sazBoczY2RmpsU0k0cjEwejNud01KbEVQd2Yw?=
 =?utf-8?B?cWM4T29LV1hHTHZRWk5DOUxtNjgwc1lUSXB2d29mYnpQLzhldnpQZW41OTVP?=
 =?utf-8?B?OHdxMDNac1B0UmtobWVIN1p1eDZvU3FmcnRFSlM3N1pSSjgvVTF1bFMrUldl?=
 =?utf-8?B?WkdaMDF1ZnV2emI5S3dtV1Nyekh5bnpXUVZFR2xlSWVRNGVIbzg4VFJ3em45?=
 =?utf-8?B?dXV1V0Nrbkl2Yk10SkZUYTZzcWlrblJMcTJFMEtreVlKYWJ4WVRINk5ORzls?=
 =?utf-8?B?TGx3aGZralZLRll0WkVDK0czaDNpV3dHcldvU1I2K2ZFek9BOUE5d1ZVWUhO?=
 =?utf-8?B?dHVqaitzNkJ2RU45Z0lJYWlwOGpjOVVtWHZmL1J2bWpqQjI2VDlKaUFEUmJl?=
 =?utf-8?Q?tTSXAWx/9D4aJ7MRKP?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 590b93db-b5c8-41b2-d862-08deea46bf76
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2026 12:17:51.5026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3XvqxCyXzM5IfK76Z5HKahxNgqhI4WvcZXGISWp6cvHb/98CapHB0saAto3grq5INQiEJKkt5totJEGv7gFow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB2638

On Fri Jul 24, 2026 at 11:29 PM BST, Bjorn Helgaas wrote:
> On Thu, Jul 23, 2026 at 11:00:46PM +0100, Gary Guo wrote:
>> PCI dynamic ID needs to match IDs against a new ID to see if it already
>> exists. Existing APIs can only match IDs against devices, causing the
>> dynamic ID insertion code to create a temporary device only for matching
>> purpose. Rename pci_match_one_device() to pci_match_one_id() so it can b=
e
>> used for this purpose instead; add a pci_id_from_device() helper to make=
 it
>> easy to convert users.
>
> s/causing the ... code to create/so the ... code creates/
> s/purpose/purposes/
>
>> Similarly, convert pci_match_id() to do_pci_match_id(). But keep the
>> existing API because there are many users.
>>=20
>> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
>> Signed-off-by: Gary Guo <gary@garyguo.net>
>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
> What's the merge strategy?  If these all need to be merged together,
> feel free to include the PCI patches whereever you merge the series.

I think the series should be merged together, as I consider the driver chan=
ges
included in this series being "fixing the users".

The series should probably be taken via the PCI tree. I suppose one can als=
o
argue that the lifetime issue with device IDs isn't unique to PCI bus so th=
is
can also be considered driver-core material, but given that Greg has alread=
y
taken the USB fixes via the USB tree the only unfixed bus left is PCI.

So unless Danilo thinks otherwise I'd suggest the series be taken as a whol=
e via
PCI.

Best,
Gary

>
>> ---
>>  drivers/pci/pci-driver.c | 38 ++++++++++++++++++++++++++++----------
>>  drivers/pci/pci.h        | 43 +++++++++++++++++++++++++++++++----------=
--
>>  drivers/pci/search.c     |  8 +++++---
>>  3 files changed, 64 insertions(+), 25 deletions(-)

