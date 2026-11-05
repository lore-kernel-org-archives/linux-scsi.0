Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.10.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793839604;
	b=FSvRU2LtERTB060c4GN+cr+gwVgsbQVVZD+2kUBRKwOGh1PDtrYQIEqYG4pNh1RGdeqi
	 Sk9SZoFWcRuyJFtE98m3JKj6TM8M74Bu7ylPcq0QnoWmc2oM3ZRsj8WM07ZrqtvvJSQ32
	 Bxju01z64eRg+4guhReOgpli7R5fJYD21swqqCv2HLDC9whgzAQ3NwVp+bnWSCA9KuDXd
	 LuFYVYNomGd+fPV8Q1vZ80Vfzbj0WElV6/JCPugaba0tNeyXteboNj2j0d5Zb8RUP5DtS
	 7757l193gASNFn6moQRzfQ9+bpSuhdjFfp9bZ207Tp/C2TlgF/mbKDPO39GudJijIzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793839604;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=mncmxegEmvM4J0b4UI6Df8xvUMloP0ft2LE2jQaGWWc=;
	b=IhHii+ziESw2Ut9T8oLxgHdOz+4yH/IGVTb3XGiubovaY6ZU/we/CKx1qLf5Z8xAd4JR
	 hNDeUgu1f0ynHFcVGNda3/ZOMo4m37+5rrQqFBXzULHTpSXGpBOZmGu7Fga5edvn8ULnZ
	 Eht2TYTJjCkgaEssTif0EhaFjdPKONlBMCa7iPGejrytbs+TR/zoLK00+85J71jLvBWww
	 UoHSB338xvqxbtRmrQ3Cs/ey/X35+zZjK6z2Ct1dLdgDEZZ44fSNuubQKWy+or9rhkX6f
	 r/CqDM7s/qhDvVCPgvudkw/ihS4m90sqM/t+35Wvo3mfvx3YF1CSd5AGar/P6tl12gA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=kAboK+xm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.10.53
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azolkn19012053.outbound.protection.outlook.com [52.103.10.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA09606A31B;
	Thu,  5 Nov 2026 00:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FA09606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=kAboK+xm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HQtfizP5YwvNAI5adpVCA5isC9TEsZrytVkgcnIYAcWH8t5EyuCGsdffV0XeFozjl1p8ZkoExeurlulHgz/ASWLEiey9a+l05hSaP2zTfZHkPIQ9dVBKDAltOpC0i0YFTeodAhGXjvMCXM6UBoz8MiB3bJOYUI7xORV4cfhLJ7lEwSEupcBc7cim7GxOLLoa3lVHznqkCwIgeqpy1SbrK1U8g2lv393c2FusZx4mfXa1dhG3sq9e05w/2Vkjqr10Cx+XRLka/tehCv7vXAYfBhRhbDfuRbpLn3nUie12x1bWtgV1dBVpI9fcp8/CmUhYpLcyMhSD98Za4aNDBCzdmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mncmxegEmvM4J0b4UI6Df8xvUMloP0ft2LE2jQaGWWc=;
 b=FVWjsACtFuinn575e5KfbbBEouIadh5kXKrWVPJpsydySKcknRmiFB+GEwxyhoMjOhkkHXA8vu1dvUvGTE5Yt1z7lQ8X9nGVGT68D+mKhYgHzgEcHSwlKoJizZnZ8pbnOTxL8sGukfOYTclxhpUGlPMRm9bOnQTPrsUMjneoCuxKAjc/fTKkevsW5K/q+PKvN4tqC37tU/HqcdXRsyI0Chd+mlwSSItdz4J+Ujz+PkwlktAxLofHcUCNZpPvh8UJedu7C5stjAW73GvExHiEFfos/Npv3VinX9exoK5ApuxWRh3xfYmgFzHZvTHDS2e4jDzlnwBzjXhcuIn1MGZhgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mncmxegEmvM4J0b4UI6Df8xvUMloP0ft2LE2jQaGWWc=;
 b=kAboK+xmYsvKQBXrQ6vZSFeDCa2n6aTQ0IOLj1/Ogz/dJ/L5bJHp/oR0x7sNyLJQMzg9668d8q8uKm7mJk66a/J0ojw+MYddGDUufU7SffiEEdI1G8j7/kOnnNhGGRlGAb1tltkHTSqNqVN+umuYT7/uG9BpCz3DEYNtoLllYKiIvNpa3jGm5ZX2FzSOaGv0zItTAHPu9znakfPgfLnP3u0i8ethERltig6mOmOv1nCkf4KVHyPLNGQXUZRA0Fy+urtbO2fIEJJ2kICjoLJ0DbaAkiqucBz1sY6gmO8elV9D9ta1Cpk4jt/MkKk2JnKCCttmfcinm4EEFHC0nPwkSg==
Received: from MN2PR02MB6863.namprd02.prod.outlook.com (2603:10b6:208:1d7::20)
 by BL3PR02MB8297.namprd02.prod.outlook.com (2603:10b6:208:344::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 00:46:41 +0000
Received: from MN2PR02MB6863.namprd02.prod.outlook.com
 ([fe80::da67:fd0f:d96d:ac53]) by MN2PR02MB6863.namprd02.prod.outlook.com
 ([fe80::da67:fd0f:d96d:ac53%4]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 00:46:41 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Laurence Oberman <loberman@redhat.com>, "njavali@marvell.com"
	<njavali@marvell.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	Mukesh R <mrathor@linux.microsoft.com>
CC: "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "haiyangz@microsoft.com"
	<haiyangz@microsoft.com>, "decui@microsoft.com" <decui@microsoft.com>,
	"sbhat@linux.ibm.com" <sbhat@linux.ibm.com>, "kmahlkuc@linux.ibm.com"
	<kmahlkuc@linux.ibm.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] scsi: qla2xxx: Use the real INTx pin for the port
 number on Hyper-V guests
Thread-Topic: [RFC PATCH] scsi: qla2xxx: Use the real INTx pin for the port
 number on Hyper-V guests
Thread-Index: AQHdbKt3ZyutAdpuTUae8GsuWo12bbcepOUA
Date: Thu, 5 Nov 2026 00:46:41 +0000
Message-ID:
 <MN2PR02MB68634FAAFE0BA7C4DB3153D9D4772@MN2PR02MB6863.namprd02.prod.outlook.com>
References: <20261104222541.2675051-1-loberman@redhat.com>
In-Reply-To: <20261104222541.2675051-1-loberman@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6863:EE_|BL3PR02MB8297:EE_
x-ms-office365-filtering-correlation-id: 7efca029-ca14-440f-da73-08df3ad64204
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|8060799015|12121999013|55001999006|19110799012|13091999003|4140399003|25010399006|24021099003|8062599012|41001999006|37011999003|15080799012|51005399006|1602099012|10035399007|40105399003|102099032|56899033|4302099013|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?aQ6hB7um3fPhrSkElgF1pxUzJui2HbbVE7WdH4jNwq4qN14mYkj/8irZdiAF?=
 =?us-ascii?Q?0PMzGkNJwH1LmyA3gMjg6WxdZQBUYLo12G1/4EYkAEEtT08KUI7Qumhq0/4x?=
 =?us-ascii?Q?ZhdHgMXhf3aWQra5hW/t04na7XT9WRAiCSrp5PJwRr2UPrVnmAt0v4p/r9XO?=
 =?us-ascii?Q?Zi/oY/UY1Lc7YWsXdmzsGut5tjmlS31FDxcD2qyAo90qgya4ERvFBn0YLVgf?=
 =?us-ascii?Q?Bl4Wy+otY1CI+I5CrPbgyCWFyqcm3ff9C+nD9zOEnQSZH3M4tR0+rc7AnqBd?=
 =?us-ascii?Q?S8bk2LBbxh25pUTWfLRcX+KYn07UvMCcxigtlaGa3N3bVVQ8SZyCcnbmF49d?=
 =?us-ascii?Q?GK2S7rcBUGE46ckdTm+9uWh+hO1HfnDsjuh4nFRL5YQIN15GhCMR36rdNFJl?=
 =?us-ascii?Q?3QbZCqblxsIsCYm0QRWeqp9TcIsqlauB0Izsvr0IPNo/cSklgiImiKlItV0t?=
 =?us-ascii?Q?numNwaU4lhsyjaROr+nnlv5+GlCH6x5jnDit1PeukBx0Jh8ec9btZHUVPbEB?=
 =?us-ascii?Q?GkOM+SSsaJTz20J7ELETcrzJ2ZERrXfiLQ1cdiZgs6HW45o1fOK/ibcD9Ws3?=
 =?us-ascii?Q?9kM/utmotdKBVrX1MSUWNEQxNgkRiIigJVasmmYjeBBNASTMt+gx1euH8LfB?=
 =?us-ascii?Q?Skf+1P8GDYJnLSWtt47sWkHZHO7k5bMU/KVeUecHWeKDUlE1QU7XzFQDvE4x?=
 =?us-ascii?Q?epbEkR8MDV0V0kElYGQlanvBpjQ9ZZrciRQIL1jEgeJuMROYCp9Otvnnd131?=
 =?us-ascii?Q?OYweZGWRZSvb665uupBfzqCvSM23OQjo+Xfkc2J63OpWTcXfu3Ay3VnUhZ+C?=
 =?us-ascii?Q?0TmZHsNo2Wz6pPkfteuLggG1s9BhDDKyE3d9+d7mk+mmObWzc65hT7AYClNr?=
 =?us-ascii?Q?8SxYE6lkcYjCjjCeVgSHI3m2GVYWF/3jH875ON1tXjwCWITmKP9/kENcCpEr?=
 =?us-ascii?Q?93mwG7d1k7UY2rVenTZHlUTHJv5Bq2g+vQ8OZShqb0j6whKcQqkDhgZVjm4V?=
 =?us-ascii?Q?eooTiyTT776HKf2w+2KFqXdz7R0J80zTPL+O9LLS4R04bjVs0e73Vu6MImUO?=
 =?us-ascii?Q?tKvbLRrAz14Ae6mn3+DrJ4aqoyG7kVQj7BW38cejmgXhMneXE7ArS2JZTJJ3?=
 =?us-ascii?Q?/fQ8g4GneKiJM81qPEaEiHb0k2/BnXxEUw=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Z8EHwAdFfDKp4VBrTlC69aMb5AQM+foTJ/SjVkimTsW9EBNdIZ2DUdbdhxSw?=
 =?us-ascii?Q?gpLLaRY1E09LtEIqNUB160jXMThla+0qO7OnayoQ6ZDUJAgUYkunUym0GMGk?=
 =?us-ascii?Q?Bgv1+xhKNSBZBeYaK91z9l/KzinEeOXtssbLWzNEdKHkMr4L/x7X+oPg2VSw?=
 =?us-ascii?Q?aMUHVauJBUnMRmWi4etSq6E0uE0xZmtgMrssDmrxFB7blhJf7DROy6lf2eHd?=
 =?us-ascii?Q?rwvkqXhY+sKIZ4vEN+NVvhhRAIKlIKzAVbbx66Y1qAiqZJ4eQ/Wx8/mgYB7U?=
 =?us-ascii?Q?PwFg4JwtYdloNrj4XAzefcsDHXaEs9kBoScnla1ecuA11P1ug1RJM0DD12qh?=
 =?us-ascii?Q?C7qtS1bWWIrM1jlQZhLmgUIhRKKPNxV54wAHixmFKp+arP5ol/EU+jy7II2P?=
 =?us-ascii?Q?F0ni2L0iEIfU53ZR/gRMJApgRvQfhUneFCK2b8cQq2Qk6aSbrnJQFxwEFo9G?=
 =?us-ascii?Q?fgq0a36oDC7XczH754ypV97Utr7lVywEF4jHKcCJCPgSv1fJoQoO5HbIH6SF?=
 =?us-ascii?Q?1ncrANXe7R/nkA2JLnPSXk0dVYkwleFjjoirqKnYqjzyLNp5QaQxaLO+/VU/?=
 =?us-ascii?Q?aErt3S2FmR+wB+Nmzkdqrk7LN0euEJ6i5Ef9QULPyx/b1EAwe1POt2jfEv31?=
 =?us-ascii?Q?3ajwTM+rRE82ahcp8AcnY49SvDEneG5sfJ49Bo6P8cfOYL6l401xqv0BAF9L?=
 =?us-ascii?Q?7ilPw71iiQPTxH6C4skP2xCVH+XCcSlmJ/SygpOKOQLoNQM+Iygv2MsZ6RKc?=
 =?us-ascii?Q?qrOIn+QLJ4ONmxa2nRDqJSeZMjOwYTg5njO9btz7byfKg3R6oKVCA2kUWH6Y?=
 =?us-ascii?Q?5DtH3feAKILik6spID7sri/FnF1/PcX2jp4FEhxSo0ozC24BWhlT9mnTgI5Z?=
 =?us-ascii?Q?/ZirXyhbXUxTb+fXA2OeQlF5bvfEyt7ZMhdmFsvpN/q9s9n7P1X8198wmP0G?=
 =?us-ascii?Q?17FHl1UnviP1h3F4KFLtcl8ValjTAPHf99yPM/FW5uL000p3PYcsbYObqfiE?=
 =?us-ascii?Q?vxgAFnnVzGurbPRkVxGsG4RiyP4r3eN7dk/oNaT9eH29tk64MCw/PgF7zUg2?=
 =?us-ascii?Q?17ookD5GeCTavG6LrOlo2ALJd0yxag61Qd6nBTsos9kruhFs5q/n1Q7CnCFr?=
 =?us-ascii?Q?7CpQW79/yv2dodcrCBECKHr9eamPjFMO1Ac8nG8NAlVowcO9Pvr2N+gLR9hs?=
 =?us-ascii?Q?Ga+x5kUbvUV487XGnUCx+EUf8rJqzJkKKV7/noVKSVIc77DqaQkaphCQXMYh?=
 =?us-ascii?Q?eE8Qf+yWGr0BW2j9gpl1aSqRf5xpn5JoYYewLtj21DSFFscvsVsDbwd072qc?=
 =?us-ascii?Q?+V7MkkQJ/hQSPDY7tfaYLRIBdB8xGAG/7UUFwAb0bu7Sq3c8JNW/TzclLEC1?=
 =?us-ascii?Q?QDJVacE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR02MB6863.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7efca029-ca14-440f-da73-08df3ad64204
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2026 00:46:41.4389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8297

From: Laurence Oberman <loberman@redhat.com> Sent: Wednesday, November 4, 2=
026 2:26 PM
>=20
> qla2x00_set_isp_flags() derives the physical port number from
> PCI_INTERRUPT_PIN, and the port number selects the per-port VPD, NVRAM,
> NPIV and FCP priority flash regions.
>=20
> On Hyper-V guests, pci-hyperv returns 0 for byte and word reads of
> PCI_INTERRUPT_PIN since commit fea93a3e5d5e ("PCI: hv: Return zero, not
> garbage, when reading PCI_INTERRUPT_PIN"). Commit 7268e509b43a ("scsi:
> qla2xxx: Handle INTx not connected while passing through") then falls
> back to PCI_FUNC(). With Discrete Device Assignment (DDA), each function
> of a multi-port HBA is presented as function 0 in its own PCI domain, so
> every port gets port_no 0. All ports read port 0's NVRAM, pass the
> checksum and register the same WWPN, and nothing is logged.
>=20
> Without that commit, port_no underflows to 255, no flash region is
> selected and every port fails with "Inconsistent NVRAM checksum" and
> falls back to the default WWPN.
>=20
> pci-hyperv only zeroes byte and word accesses within 0x3c-0x3d. A dword
> read at PCI_INTERRUPT_LINE reaches the device's config space and returns
> the real pin in bits 15:8. On Hyper-V guests, use that when the byte
> read returns 0, and warn if the pin is still 0 so that duplicate WWPNs
> are not silent. Bare metal, KVM/vfio and other hypervisors are
> unchanged.

There's a patch in flight [1] that kills the behavior that your patch takes
advantage of. I don't have knowledge of the full details that motivated [1]=
,
so maybe Mukesh Rathor or Wei Liu can add some info, as well as
comment on the validity of what you are observing as a possible
work-around to the qla2xxx problem.

Michael

[1] https://lore.kernel.org/linux-hyperv/20260913232255.2801797-1-wei.liu@k=
ernel.org/

>=20
> Tested with an equivalent change on a RHEL 9 (5.14-based) guest with a
> dual-port QLE2692 (ISP2261) assigned through DDA (Hyper-V host
> 10.0.17763):
>=20
>   before: both ports "Inconsistent NVRAM checksum=3D0xffffffc0 id=3DNGKP"=
,
>           both WWPN 0x210000e08b1c5586
>   after:  port_no 1 and 0, NVRAM valid, WWPN 0x210034800d7065bd and
>           0x210034800d7065bc, fabric login and FC-NVMe localport
>           registration on both ports
>=20
> Also tested on bare metal (ISP2031): the new path is not taken and port
> numbers and WWPNs are unchanged.
>=20
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
> RFC: this relies on pci-hyperv not virtualizing dword reads at 0x3c,
> which is an implementation detail rather than an interface. It is posted
> as the smallest working fix and to start the discussion. Feedback wanted
> on cleaner alternatives:
>=20
>  - Hyper-V (linux-hyperv): could pci-hyperv expose the real
>    PCI_INTERRUPT_PIN, or provide the physical function number, for DDA
>    devices? Some drivers use the pin for port identity, not only for
>    interrupt routing.
>=20
>  - Marvell: is there a firmware or register source for the physical
>    port that does not depend on PCI config space? CSRX_FUNCTION in
>    ctrl_status is a single bit and would not cover quad-port
>    27xx/28xx/29xx.
>=20
>  - The check is x86-only (hypervisor_is_type()). pci-hyperv also
>    supports arm64 guests; a better way to detect a pci-hyperv bus is
>    welcome.
>=20
> This has not yet been tested on a 7.3 kernel in the DDA guest; testing
> was on a RHEL 9.8 backport. The upstream behaviour without this patch
> (duplicate WWPNs with no warning) follows from the code and has not yet
> been reproduced on 7.3.
>=20
>  drivers/scsi/qla2xxx/qla_os.c | 40 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 3c412c7fb6fe..4180d3f15231 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -24,6 +24,10 @@
>  #include <scsi/scsi_transport.h>
>  #include <scsi/scsi_transport_fc.h>
>=20
> +#ifdef CONFIG_X86
> +#include <asm/hypervisor.h>
> +#endif
> +
>  #include "qla_target.h"
>=20
>  /*
> @@ -2704,6 +2708,40 @@ static struct isp_operations qla29xx_isp_ops =3D {
>  	.initialize_adapter	=3D qla2x00_initialize_adapter,
>  };
>=20
> +/*
> + * Read the INTx pin used to derive the physical port number.
> + *
> + * pci-hyperv hard-wires byte and word reads of PCI_INTERRUPT_PIN to zer=
o.
> + * With Hyper-V Discrete Device Assignment every function is also presen=
ted
> + * as function 0 in its own PCI domain, so the PCI_FUNC() fallback gives
> + * port 0 for every port and they all report port 0's WWPN. A dword read=
 at
> + * PCI_INTERRUPT_LINE is not virtualized by pci-hyperv and returns the
> + * device's pin in bits 15:8, so use that on Hyper-V guests.
> + */
> +static u8
> +qla2x00_get_intx_pin(struct qla_hw_data *ha)
> +{
> +	u8 pin;
> +
> +	pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &pin);
> +#ifdef CONFIG_X86
> +	if (!pin && hypervisor_is_type(X86_HYPER_MS_HYPERV)) {
> +		u32 val =3D 0;
> +
> +		pci_read_config_dword(ha->pdev, PCI_INTERRUPT_LINE, &val);
> +		pin =3D (val >> 8) & 0xff;
> +		if (pin)
> +			ql_log_pci(ql_log_info, ha->pdev, 0xffff,
> +				   "Hyper-V: INTx pin reads 0, config dword 0x%08x
> gives pin %u.\n",
> +				   val, pin);
> +		else
> +			ql_log_pci(ql_log_warn, ha->pdev, 0xffff,
> +				   "Hyper-V: unable to determine physical port, ports
> may report duplicate WWPNs.\n");
> +	}
> +#endif
> +	return pin;
> +}
> +
>  static inline void
>  qla2x00_set_isp_flags(struct qla_hw_data *ha)
>  {
> @@ -2887,7 +2925,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
>  		ha->port_no =3D ha->portnum & 1;
>  	else {
>  		/* Get adapter physical port no from interrupt pin register. */
> -		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
> +		ha->port_no =3D qla2x00_get_intx_pin(ha);
>  		if (ha->port_no =3D=3D 0) {
>  			/* None of INT[A|B|C|D] may be virtualized by vfio */
>  			ha->port_no =3D PCI_FUNC(ha->pdev->devfn);
> --
> 2.56.0
>=20

