Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022086.outbound.protection.outlook.com [52.101.101.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF58D36606E;
	Thu, 23 Jul 2026 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784833094; cv=fail; b=Vce+jWbUZ/3mk36KkQv5GMnXF236IFtT4BNLK++BUVGJd0hGsO5XxXFlH5r/2M1k/GznoVNSxcLiejk3NjLP9Hoo/MF2mCm3bcFhRi3N7LSQiBHO2LvhdTuCt56100LngW5PkASH7pa2pPkr3UQSId1OY5S0cAbd9PLgW/At7v4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784833094; c=relaxed/simple;
	bh=FmfkcHw4QqdapG3+OrbGkAXBmDseorsdja9ku6UtdKo=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=fRAgzJ2+Wakn5Q8YvkfYyE+zMzXSCCWKB0gyh47ac0q4rn7hpsHDvB4kmQiihwPy8Cox9WGhgkrdOn693hdYmIiwFUhfdaVPNo6pWp7uk1Qd1z8Y+bWJ6atG+Q8cY9f5vr8HHAvRw+NP3G2Zp0qrUgOY22tdVOqanfzTrL+0WLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=gGCCPfKo; arc=fail smtp.client-ip=52.101.101.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="gGCCPfKo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sC93KypOVk7SOBVE6myQou09DcQsKhfP7zJl6+N2/p4IWkqEanM0seN3+9Fev0NQro35T9mMfLGLaUCEDqpqszdYJdjAtYROfYoMZxA4HGiAGZ7bEwNKlGP2TTIBJpO3c5TsorMmohGpa4LdbGPbKk/iwQKWKf+O2qUdZBaHhD7cqz6kZHO8i++TH63ZH6g8DTyJVsrPaBLPJIVwvKT+4zq9eeJ/Uck8zRhhDhtmzoadtCun2+uGY1jnsSwXJr7+gz9t8fO8aAuNUF4DpGsfq1X6qwD8kIxdwKTA+GJwkSMFgUuXG5k948b8M9LxPqdASMxnsom2agadvAVnzrsLXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpzpsCWwZe4bG2fLGxYvu0P/ao9Y6eo4U9wAjnm2A74=;
 b=ETgh23pH7OtL8R8MLUXtJ+uvKzXEwXEq+ZWheAQTQzOSAnvFA2JJK9RfOiljCbL3zYraTRPWpKhBNoMHxsc5+fh2cKnNXE8DsVt/qy+c/wlLDJL02VxRBoFixrszqvroz33AIrEgT0X4Kx8RQHYdm7uyK2E8HFAKW8ncHR5Upxqc8+wnFsnuqBmNTgqQo9o5FWdNO1x9/8w+ejhqSYVbyFWa83u1awvOCZOQ9yLVdjZ5+ZQ8K2VVpIxlFIKeGyHvFTZeY9KnLN95DnSFK5M9ylzS4zdJDvP64sXOZj4O+dwQk0RuSIWf5q9l70xdE6dWKrXyJ4Opve4Ud6+g0hR3wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpzpsCWwZe4bG2fLGxYvu0P/ao9Y6eo4U9wAjnm2A74=;
 b=gGCCPfKoysJvsAeaUiHa5ZrwaHDoNPzStO6u6qz3i8qwwr+a1IT7Ew3NZpIkiClJU15f6FOHc5ay+BBRTDpeckKxKoBII/MgHfzSdYDNdqaAf9nTvR6x+/aRoyBwF4hTeugthPpEclBiL4uNmd5YBEpkyh3uu+GbqKyW3Dj2yRk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LOYP265MB2208.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:115::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 18:57:59 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 18:57:59 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Jul 2026 19:57:58 +0100
Message-Id: <DK66ISTEVM5H.3K5O68CW1F8ZB@garyguo.net>
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
From: "Gary Guo" <gary@garyguo.net>
To: "Bjorn Helgaas" <helgaas@kernel.org>, "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <20260706-pci_id_fix-v3-9-2d48fc025acc@garyguo.net>
 <20260721223500.GA690676@bhelgaas>
In-Reply-To: <20260721223500.GA690676@bhelgaas>
X-ClientProxiedBy: LO4P265CA0180.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::11) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LOYP265MB2208:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dab689d-58d1-45ec-e3a3-08dee8ec5045
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|10070799003|366016|1800799024|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eImn8aTkxu2wV3Viu+bGzZD9g8s15EcJb/oteLAfaHyMJ9poOVk6AYX9xuoZhjdHU0HfJOYfuYnjb6iKW8w+0bR4lo2OQq/m2lDQs8HaxiUIq60+gw20eiGZxkd7kcxxG8/4tWhLlwyqn3ildX5I/+zjxLwZQQRZG5fqI9ATNl2TsiJxlHhsColwlHS+xt5W/8yxdpV4ulvDvhpLE9zeQUEenQBeAxEIrq6HQbM5PwTJIUBdp5OGoFQyTi3Q8UQPcjBF/g5hQCDmpsli2/UrE5qiJEeoxZx082SXmiGwESSwyG8WHj2y2UAznx7k60XDamkr2+oNqVQ9N79ibSxrbs9BMJIb5lq3fGuDXhdPp63bV7EaKv0j9mnyVrrXt7t865ghBsNoYbHaRwnN3yShc2dvbsBhvzhSqfrWhNR3fKSbMj1emNfiEhHDTJY5cbDqYXgmE+/TG5ZyD8NhznPvnvrvgz3DXrfNPVlavwXOqyvSDpzAQJUtYpowPGhpIlGPhZH39pZTr0eYaa1cq+i7H6s9ZjsBXIMOEGB+ZB9mG8HnqgJ3eHjPgUoyzHA61YbMP6kiQv6zesTxXcpH5aFDHHq7Ttgr+tRZ2Rj2RmZls1ZWgo44FMHzRl1XsIv1oexquA+nzwbSYmLSK5Ti1ZvhxJ28Ag6OZ48OMP0zzbtyKts=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(10070799003)(366016)(1800799024)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2toTm9LdWVFaVdVTnd3OUZZYU80azBlRVFWdXlGeDFOYjdtaUlCNEZEdnpO?=
 =?utf-8?B?RVEyL1JpbEJYaHhaV01pdGNYcFNQWEduRDJvdWYwZFJqdVlUNEp2QWhEQjdq?=
 =?utf-8?B?TjhvNk9YL0kya0pJRE9zVEQ3NE1WNXY2emxUVnRSRytCYnlBZUpHR1ZqN2Vn?=
 =?utf-8?B?bDVUczVTd0tpV3o2SUJlQit4UE9Ld2pVbXorOVpQQys3SjF1eXJsOVRoUDJh?=
 =?utf-8?B?Z1ZRbFh0d1I4RklLODFTeE9kQm4reGttcEczTmZldCtWWEt1WU1vcEk0RmNq?=
 =?utf-8?B?VVpKZml5QVk3YjBzZ1B1OW1PUDd1STJuOU9tU2ZNNWZUYzZsN1BraW42blNX?=
 =?utf-8?B?d1dLcUpzUHVOV2FxM2FIRG1DYS8zekMrSnkveWVYVVhsbVpzQXErQm9kY0VS?=
 =?utf-8?B?YW0rbVFTM2p6SmZHZThXYWtLNHJkV3dWUUh4NUdLU1gvOWhQTzlVQ0NhZEln?=
 =?utf-8?B?TjdBQWFPVHBZMWhuL1FXYVNGWXE2L0xuVzVGZEJSRGhMUGJrbGVFcFV2bVI3?=
 =?utf-8?B?aGFzaGpxK0Zia0lseEVJb0FjdlVFUzg3TTB4cjRDbzZiU2tsOTJGWkNCTys3?=
 =?utf-8?B?MndZa1A5UFNaMSs3ZE9Mdnh4ZE5OSC84WG5zRHVHTUYrb3I5NXMwcmR5S0Vt?=
 =?utf-8?B?cEpqb3hLYlMxQkRQbWZBTjFHVlZaRmU4R2JsYldIb1lDRllJcEZQMEJKQjF1?=
 =?utf-8?B?NURGbGJnRDA3TGlRODR1ZmhNUmFNbW9WR2hKbkVqVXpoZVc2anc0ck55RE5u?=
 =?utf-8?B?eG5WSjZuekFCTjBxOGRWaVozSGFZbUZmS0JjUC9sQm56NXNRcWVhK0h6d1B6?=
 =?utf-8?B?VWZCcWhmR0dKYkJ1a0s5Wk1MZmNJQkwvaUVjMnlDSmMyVEk2aXBXV2JPU0pt?=
 =?utf-8?B?b2sxbDlLaU1TaTJBMFUraU40NTFyNVRsa3Ntam1OWFFPbnlPd0VseldXNHlC?=
 =?utf-8?B?SGZtaGwzQTErbGVGd05KUWNyWVBrZkRGQjRBc09Ec3lqM0oxa2JvZFRBT2xq?=
 =?utf-8?B?VUlxZGRXMEs3SEVIaDhxUE5vem5iR0U1QjloMUhYbnJ2Q2gzbVQyMGNtaDVD?=
 =?utf-8?B?c0NqejVnVTBNbWhWcmFZc1JVc3NUM2t0LzJGN003Q1NRL2kzVUpFMkZrc2wz?=
 =?utf-8?B?VFVha3lZNjZHT2tDbXNOZDBNdVNaQWJIKzNybWhROERrWE5FaC9hOUtLd3Jv?=
 =?utf-8?B?T0ZqZkJ2bGlRVFJGZkFBcUlRTTNhZWJ0VUdIa1N2NnZJTGttVEFxSVZkajdX?=
 =?utf-8?B?ckE1QS9QR3ArU3RoWjZQNWtCQXB3bjRlTUUvMGlIWW15dFh2eDBjMkJGWDYw?=
 =?utf-8?B?bE1JQ21UcjJTcFdSV0VNSnJoUTdLVWVwbHRaam9meGs5bisyMWpJQ1N2aUhE?=
 =?utf-8?B?WThRL01vUEg3QnRiRkZ4Sm5XUmFRZWZhZE9peGhvSWczcm5ORUpVdkVQcUxU?=
 =?utf-8?B?WTM3djEwUTRUL1FZOW9EQTMwNE9vYVo2WEFYZnk1K1FpNlY5bVYrbDVzS1Bx?=
 =?utf-8?B?dEtsNEZqTjVOWHV6UUozUVQ0V21FTWQxcjNnem9mZVlrUHhlZGZMUWNnOXBG?=
 =?utf-8?B?MDJIR1FPQzhVcmkvWnFCa2ppY1JHMU5FeHVSVnp2eEhBZ1B3TTd4VmZMcHZj?=
 =?utf-8?B?b1pPb2k3WFpiTmdpZnRXSmtJQVFTNUtQdnoxMkM1eG1QUHdoQXJPM09xRm9o?=
 =?utf-8?B?VGhHcTRSUHdhNHVDbzg3T1RBR1RyWEMyZnovaEZuS0ZIUHZEeGpkVjl3cjRj?=
 =?utf-8?B?U2FDUlVSYXY2K3l1aTN5ZE15VUE5NENEMWxtUXJjNngxRVB1dDRTKzVua2lW?=
 =?utf-8?B?QVJ6TTZpWUN2Y3pJLzB4SzlNVnRjVmtlcUhrVlY2YmFHYkszWnRaZDZlcGI5?=
 =?utf-8?B?dXBMbVdXVmtXdndCOUtiQXhRL3hMekhINEc3dGo4bmVodmtuU0E1N3llb01G?=
 =?utf-8?B?Y2RLYWV5NmZKSC9nZU9vVk9HWnMzb1g4R2hnNEg4bnY3U3k0SVpkZ01qSkxX?=
 =?utf-8?B?S3lzSS9TazVWSU9WWFJWYjcwMUZWd2JrajFENkx0MklMQTNEQjBGUkRoeVdk?=
 =?utf-8?B?eFoyeElCNDBmWlRPNi90a1JnYXlYVnlzYnVFYzRkUlJuNHgzc05DMGI0ZWNl?=
 =?utf-8?B?TFFGOEZOSzZleWxaZGplRDV5ekVKUUtPTTQvWVdnU2ZnRytqNHlxUm9vdVdw?=
 =?utf-8?B?dzRDc1lwdkVQM1Y1WU5sS3h3am1YaFROTVp1Q2lUaTg0bVpOT1F6Smp2a0FI?=
 =?utf-8?B?ZFFXV3F2cUx0dEhrL2g4ZEVoSEkwT2dLR1hMTjhSK2I5ZWRJUlN1SUcxS1gv?=
 =?utf-8?B?OUJEZTh6Y01KV0dOd3RlZWhDWGYzM1BCNHJaQlgzTjJpampnSWdqZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dab689d-58d1-45ec-e3a3-08dee8ec5045
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 18:57:59.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ec/ftnzcqW2F6OazifJQh0L70kJ6bsgcbITh95Gz8KROVEBnF0azZP+jjXeYUYFZwHtXknAeWhh1DBXywHFlrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP265MB2208

On Tue Jul 21, 2026 at 11:35 PM BST, Bjorn Helgaas wrote:
> On Mon, Jul 06, 2026 at 03:11:21PM +0100, Gary Guo wrote:
>> Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
>> as remove_id_store can free the node. Thus, make a copy in
>> pci_match_device. Also, clarify that the id parameter is only valid duri=
ng
>> probe.
>>=20
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kerne=
l.org/
>> Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
>> Signed-off-by: Gary Guo <gary@garyguo.net>
>> ---
>>  drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
>>  include/linux/pci.h      |  1 +
>>  2 files changed, 16 insertions(+), 13 deletions(-)
>>=20
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 64b308b6e61c..92c17c116de6 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -979,6 +979,7 @@ struct module;
>>   *		function returns zero when the driver chooses to
>>   *		take "ownership" of the device or an error code
>>   *		(negative number) otherwise.
>> + *		The pci_device_id parameter is only valid during probe.
>
> The probe function takes a pointer to a struct pci_device_id, so I
> think the requirement is that the struct pci_device_id only *needs* to
> be valid during .probe(), right, i.e., the PCI core probe path makes
> its own copy of the ID and doesn't retain the pointer after .probe()
> returns, right?
>
> I assume the caller determines the struct pci_device_id lifetime, and
> it could be forever.
>
> Could say something like:
>
>   The pci_device_id parameter only needs to be valid during probe.

As a contract on function parameter, the caller needs to guarantee that it =
lives
at least as long as documented (i.e. during the whole probe) and the callee
cannot assume that it will be valid beyond what's guaranteed.

How about:

    The pci_device_id parameter is only guaranteed to be valid during probe=
.

Best,
Gary

