Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022120.outbound.protection.outlook.com [52.101.101.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2B93D5229;
	Thu, 23 Jul 2026 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784835898; cv=fail; b=p+x7EOxiPG9a76OQ4dVwOHiALT3n5a4ldnl9FkgDwpzexFKrXKwZhUYIy431Nfb2ypZoB54fSHPktOHI8QpgEk8IjAxvo96iMjymAB6wp1H9Zcc07fbX14Ziyp0ed3VacwBPPoZeNXuYy7QDvX4KwLZsXaWNwcrICR44r9iHW3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784835898; c=relaxed/simple;
	bh=8hhpdN1vcdI28kmA+3EqfwyF69z4Ub+TqygK3Zz174g=;
	h=Content-Type:Date:Message-Id:From:To:Cc:Subject:References:
	 In-Reply-To:MIME-Version; b=WuQzW2EarXAyOdfGjVATkyhqmBGj3/2HgrPVlNref+YwdFOg/7cnyfiOkfEWA1u5kHJYm6Tn/4QgMfElEj09sGruuwE14suvcFJNX7BJ3VHJSFyeLP0GLgOEq0HMEHvxosEojeYYbEzaj/BwCGgf6iZW8MAqfdrChToz0T+bKow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=L8HgI8tO; arc=fail smtp.client-ip=52.101.101.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="L8HgI8tO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gyspf9s0T32bbbDCyJ/8nBgMhsRjJXAprdMbJkAXGterzHDOvBhrmSJa3O/H2hnAk1JrkBlJJJphbBg6IaIMC37XWnhpyMjUopENc9i5Bzum9/rkenQBw+O149WSNXzfWps5jqIPpbekxPwdk3iiORsbz2YkkSwhRixcoG/Aq5FU3YxPXjRrhkieJJ6epLCkGzd5d83lvg0vt67Db5bm7ofeZ+PCb54Nxy94AMjwdB5VX17BwGq4CF8MTeK2xuPODUQRyIzV/j6lCyfkWMukipnRQbI9BEII1Vx4g8PIgGQwcv3j/R3W0/4meSA9uIwxlvQeew9EpliVtzmdN0XC2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOaNLZB0McQ3sghz2DY2ek9AWnK8rSxnnGvmFGwp804=;
 b=U5/dkBAmBsNbJmOS184lH4Oj2MaUDjJ9/aRgwZ5BH7i0JZgyoQmM/RIlLVrDnaUDqF9NC118huvmgPwKcgv+Yw3fdgJmdUILA24pItEDNKZLYQQdQzroAQ6NwOBsApte9BCMMBPUiP6fZtRRxn+vOlFTxganPGocFq9pWiIA6ZuMEQFfBf5Mi5xLdhKvsaSv+CB/QhnnN4w98SR4YzXCAZuLHHN1YlN/PBVqjf1+RP4DstzfC3/CCkOyRmnyKCuYBJXcbXR5+KAMFTBnLN2zfy6afMIEZqUklJIz1GfG0F4nJVTVxgLo8BDrwv95X00QnKSQruazGF+YoowpntMKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOaNLZB0McQ3sghz2DY2ek9AWnK8rSxnnGvmFGwp804=;
 b=L8HgI8tOhvTwMkkQJeXyOC3Aswd5SmW93pfWZMk0QJk8FuNiD7LGamyxce4aOkRc5D2JFR+bueuAQCUvOrj+vEzqeR5MAhxPkqVAJRC/ZMJiZ+ihXV2MgefW2doi5TCFFLTaixDb/UXKugAxxjffm1UyP8d8IGVf3KmusrvpXl4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWXP265MB3686.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:f9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 19:44:49 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 19:44:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Jul 2026 20:44:48 +0100
Message-Id: <DK67INM1MX6H.1FA6WNE8RZ9R7@garyguo.net>
From: "Gary Guo" <gary@garyguo.net>
To: "Bjorn Helgaas" <helgaas@kernel.org>, "Gary Guo" <gary@garyguo.net>
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
 <dri-devel@lists.freedesktop.org>, "Sashiko" <sashiko-bot@kernel.org>
Subject: Re: [PATCH v3 9/9] pci: fix UAF when probe runs concurrent to dyn
 ID removal
X-Mailer: aerc 0.21.0
References: <20260706-pci_id_fix-v3-9-2d48fc025acc@garyguo.net>
 <20260721223500.GA690676@bhelgaas> <DK66ISTEVM5H.3K5O68CW1F8ZB@garyguo.net>
 <20260723192957.GA839273@bhelgaas>
In-Reply-To: <20260723192957.GA839273@bhelgaas>
X-ClientProxiedBy: LO4P123CA0641.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::7) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CWXP265MB3686:EE_
X-MS-Office365-Filtering-Correlation-Id: 694f0370-89e0-4742-51a1-08dee8f2db09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|10070799003|366016|56012099006|4143699003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	IXzwlFePMP0CFJ9B4HWqPAv8Tm7T1X4jlBWmo/y/lwGoeIusuE+gK0gFvm3owlw8oliGGCMcIv9slJ7H+JUfF3cZ4lR1O7KPbcuDyVxO/VTX3ufUoYQVIWV9ld+USSGaTpA/vO7ZpWsxXsCVZ46RvUJJfjyE/aw78qLCJi0Sv4OimshEVaKbLZPzH7LCLmQWfJBiJ2n24w19pNHMpeQIeaEzxBIqUVaD+jceySYUppDN52qOch0lEn07sh8uMGC6sHGnWXq+kFBjbKz+S+cuDf7evut6ECLciCeSScH0eoovQdPj0dw494JFKxNUstKMUzzh0GnzKvJ+qwkARk1Sdu2jVR5Dvy8mA8+y+af31dZfvKlc00Vp91ekfALCS0X19wqv0meOMbjGlqwA/yaRM72SOz7z1s4i1Fnmkxi+o446PaaQGWu+hVNrQ6lXxtfymKZRG8D7SR8bp9rD8fax2OqWAxTlVb2JTSS2kr+iOhQ9cc3r0qM1aWegxyI5tzTr0veO0Pl21I5gpuxaQspJngrZaD0BcrTGWyXjytAYWtT6sRjrfri+ZrwMpzFcmV2Wq7ulqX2RFTsSZmwfX6ZIZO9ptUAgwsbhNI8c6dvgcNHlf3zfXjheOvIALlV2ffGz5D03XJ6LcbjieITKxbY8IrGrFgFuoxqxxb5imapR8v0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(10070799003)(366016)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUQzU1NXbk1pUjVGOWtCbDBQNzZGbzE3SnZCcWZzZklicDdZWXg2L3FYcFlu?=
 =?utf-8?B?NVgyblpWZWRldE5wVFM4Q3R2YVpOdmZEa0phV29DU0s0eW1NK3ZUYXMxVFdK?=
 =?utf-8?B?YU1FZUEvN1RWbnJvb3hndll6aG56eEZaWEhRdFhkU2g4YTlJZmZOQmZqdXZ1?=
 =?utf-8?B?U0laT0FXSS95a1J5R0cwTWhSSkZkN2FCU0NoU1F5TTRTU0toYnliVmlmc09o?=
 =?utf-8?B?TjIrK1VpalVabWdJdUFPU2NMZnE0VGVpSUowUzdzaXNqUXBEeUE1TzhHYjAr?=
 =?utf-8?B?MjhPVG5ieGFGTjUzRWJkN3lKeWNLVGFFMkM1Q2drbWZXMmppS2VoeEZhWHp5?=
 =?utf-8?B?cmlId1dlNWZpaWxZNitabklqc2VoQjVyZjI4UTRHbXprMTVKRGZuQjVSQitx?=
 =?utf-8?B?UncwM0d0dmhKK1U1ZjdZa3NMWWRYZlRRT2s1ZzEvZWNLOGRkVVZleHdGZVd5?=
 =?utf-8?B?VFFySzBPTU1yZTcrRjNnQVVYc3pLVWJ5R3lLcWc2ckNGY1R2WGhQUnU1SjVp?=
 =?utf-8?B?V1VOSDFzMlJKNVljb1lvbG92Q3F0UjhORlFzVlArMGh6NnVJYmpGaEd0N2w3?=
 =?utf-8?B?QUJOeUQxQ0tiMjMzMi9lVGZlcE1xMjVqdGZKdWpJLzhMWEg5a1lDZG1YSzZ3?=
 =?utf-8?B?RFRVVnA5VXZqQldwT1BFZDllZnhNa0JBak1BUGFhMVJnem95VDlEMmxjVy80?=
 =?utf-8?B?UEk0REpKMEdJT0lRd3MwM2RaN2s3bUFQUnZSME94VVRNd3dsV1hiY2daYTMv?=
 =?utf-8?B?ZGtyQzVXUmtTQkZlS01kS3lMTFVxTm9POUZLVVRKbjhaNFNDUWdtNm5aKzZY?=
 =?utf-8?B?MEJUVGl5b0phMzdaWFRQWVpPa3k0SEQyWUEreU1aazFibHoyNzRyK1ROWEtS?=
 =?utf-8?B?MVRVVEJBYUluYmQ5VEJ2OGM5YWxoVFl2d2llUmNPR2lCVm03akxSNTBUbUQ2?=
 =?utf-8?B?dEQyZ0tSSDMrekUyeW8yc0xOOUlUMVY2QXVWNHpvbERSa3FmS1FEMVlTeGJl?=
 =?utf-8?B?VlUraTNESzRROUxmNndnTjZiT2NUcFcvZFF1RUk3NW1Xd0dpVlNTNkNlNk1G?=
 =?utf-8?B?dzJrblg3ejBLRXFKdFdHaFhJYWJ4R1krLzYzcHY1MzFGdUxtdmEybmpUQm1p?=
 =?utf-8?B?aG5BRlZnQVovSkRuU0ZES0lKcHY3bCtaMVI4RTF1L1V1WHNDT2hIYUFPeG04?=
 =?utf-8?B?TFVSK25xNnhoWm9GaGxzbm15dGhscHBOc2V4OHB5Z1crQmwxOHkwS0t0ZEM0?=
 =?utf-8?B?YzUwMFltTkdwTzFsUm85TXpCRER1by9KdHM5WmtqemY1TlF2SmFSelpVZVgx?=
 =?utf-8?B?ejlPM24vL2NtRjJYRDVEMCs4Um5NN3ZvTmxQdFUxc0hMSy9hUVZxZUhhcldX?=
 =?utf-8?B?UDl1Wlg0TDFBZ3hnbi9PVnl6V25FN2ZPeXpYSjJ2K081OXVDREZzalJlVSsx?=
 =?utf-8?B?NWNuekM5QVptN0tDQjFVbU5mQWdMY1BaWkJvS2NLOVJFeEN5bkQvVnQ0aUV2?=
 =?utf-8?B?RkdubXNyQ2oxMmQ3cGFoNWVjdUlLUHRvK1gzdzRITWlVZlZEZDJId2pONmJu?=
 =?utf-8?B?UkFKaWZzcjRmeFFicFc0Q1hSVzVaZHB4U2puMmtXZjNaZHp4eGEwbVV0alZH?=
 =?utf-8?B?cFlQYVJObktSdFBsMDh6ekFkQjJVcjZFZ2t6bThRRU4zN0M5ZWZ2ek9iR0Vx?=
 =?utf-8?B?eEhLOXJ5NlZjd0FadklIcVNSMWNZTHpZS1U0Ti9qVlNXdEJFOW5kWVg3dFh4?=
 =?utf-8?B?TFppQ1hHNU9YZzZIRVJQMEtWUjlmZ1U4Uk9EcVB0Ri9GNklwc1NNVkp2K3JG?=
 =?utf-8?B?TDlHYW5NOS9tM3FGWnE3QUdBNDA1MjFlTEpjQmJNWGphVmQxWFZzSzJaMlpr?=
 =?utf-8?B?ZUxDQUtraDdBeU5EOGVNNnhvb0lZMGdIVEl1cXJ1QlNEbHp4TUJHUktBcjFh?=
 =?utf-8?B?TGE5SW84SHNBNWF3OWVzZFlnblVaSzh1K3I4VVBWTnUreUpLbXIxaC9DQWhB?=
 =?utf-8?B?dGsxa3FkRGhiaXJoU0EydlBqWXRCR3ZqTGVVaVZ0RHpPWG14STFmS1cxTVZZ?=
 =?utf-8?B?UktHTnpoSmNWcHp3dUV1elJnNHl4U2JoU1ZOU3lMVUw1UnBGU21hY1dFUG5G?=
 =?utf-8?B?TzllcXIxWGQwTjJNaW1VOFBwNXdONHd1RTl6aDFYQkFHREZCUEo0M2hwZ0JE?=
 =?utf-8?B?TTJzR3VoM2ZJUktqeUdOOVNMRmtxNGdMZ0dWWXhXRWtrS2dYbk9RemVTbkVy?=
 =?utf-8?B?dUlaR0tUUnFXcE5VZG1kakl6TklPUzJkNXVuUVAvU1ZNQ1NzQ01iK0Y2ZnZi?=
 =?utf-8?B?eGwzQzVHMmFjaW42aU5ENUpPTnNZZzBEY3N2a3pnd2kyRmFXTDRIUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 694f0370-89e0-4742-51a1-08dee8f2db09
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 19:44:48.8375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juNy8C80p3JHMyueDfsjHP7hkaYeNGVIRXLHlUlSNwUXL1kLqFCOnwFIhvdxT4Mr/ccsog4M5XAzU8ZT1iy5ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB3686

On Thu Jul 23, 2026 at 8:29 PM BST, Bjorn Helgaas wrote:
> On Thu, Jul 23, 2026 at 07:57:58PM +0100, Gary Guo wrote:
>> On Tue Jul 21, 2026 at 11:35 PM BST, Bjorn Helgaas wrote:
>> > On Mon, Jul 06, 2026 at 03:11:21PM +0100, Gary Guo wrote:
>> >> Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
>> >> as remove_id_store can free the node. Thus, make a copy in
>> >> pci_match_device. Also, clarify that the id parameter is only valid d=
uring
>> >> probe.
>> >>=20
>> >> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> >> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.ke=
rnel.org/
>> >> Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
>> >> Signed-off-by: Gary Guo <gary@garyguo.net>
>> >> ---
>> >>  drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
>> >>  include/linux/pci.h      |  1 +
>> >>  2 files changed, 16 insertions(+), 13 deletions(-)
>> >>=20
>> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> >> index 64b308b6e61c..92c17c116de6 100644
>> >> --- a/include/linux/pci.h
>> >> +++ b/include/linux/pci.h
>> >> @@ -979,6 +979,7 @@ struct module;
>> >>   *		function returns zero when the driver chooses to
>> >>   *		take "ownership" of the device or an error code
>> >>   *		(negative number) otherwise.
>> >> + *		The pci_device_id parameter is only valid during probe.
>> >
>> > The probe function takes a pointer to a struct pci_device_id, so I
>> > think the requirement is that the struct pci_device_id only *needs* to
>> > be valid during .probe(), right, i.e., the PCI core probe path makes
>> > its own copy of the ID and doesn't retain the pointer after .probe()
>> > returns, right?
>> >
>> > I assume the caller determines the struct pci_device_id lifetime, and
>> > it could be forever.
>> >
>> > Could say something like:
>> >
>> >   The pci_device_id parameter only needs to be valid during probe.
>>=20
>> As a contract on function parameter, the caller needs to guarantee that =
it lives
>> at least as long as documented (i.e. during the whole probe) and the cal=
lee
>> cannot assume that it will be valid beyond what's guaranteed.
>>=20
>> How about:
>>=20
>>     The pci_device_id parameter is only guaranteed to be valid during pr=
obe.
>
> That's ok with me.  My only niggle is that this documentation is that the
> *consumer* end, and of course the consumer, i.e., the PCI core probe path=
,
> can't guarantee anything about the parameters it receives.  But I guess
> your point is that the *caller* must guarantee that the parameter remains
> valid during probe.

I'm not quite getting it, the PCI core probe path is pci-driver.c which is =
the
caller? Do you mean that the PCI *driver* probe path cannot guarantee anyth=
ing
about the parameter it receives?

>
> The only thing the consumer can guarantee is that it doesn't depend on th=
e
> pci_device_id parameter after the probe returns.

How about:

    The pci_device_id parameter may not be valid after the probe returns an=
d
    must not be used afterwards.

Best,
Gary
