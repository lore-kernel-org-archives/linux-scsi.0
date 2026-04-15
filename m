Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021141.outbound.protection.outlook.com [52.101.100.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321103D6666;
	Wed, 15 Apr 2026 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776264443; cv=fail; b=oqNg3IPpwnmpZZHD3Qcv1A/MMYyYhd33gEc9YvV2hhlS38Vjj3x0wJtR2jjXsbzlryBZ9oLMRqlijVHTxouqGnMFLtKik3pR35l27MTL0cvl2Ocli8c4MqJnYRBLPW+lB8S/1I6YG15rC8Lv2itgUEDMZB/D9iHFQ3K5Pfp8qrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776264443; c=relaxed/simple;
	bh=ReZwYvnE5xkN1rCKFb1fE+/k7DquvA7PQ3h9PZVKluc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iNABV7UfFnTqF57BFEQmMmWTmte3cAS1Oe571rpnds4Sf7ilpmhwlw43JY3RV90sYq2YRFFnhE3NutVv9dADbtSLEXWZ5j2CZ21G+w7prKwZHtnc9hAEKxaIHnHa3dLUTMvxlPVY5klBBvwdv02SnepE7MJbxDHSp3JeVhVPS0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o7eo0B5fF5SCqSUFA4Tob/0v7Fh7e9mK9Z/2kP0fRsnjH4QsdrJJjTYWefkRIXwgGmWBmIfbiwz3wLfzIIk70en2SMHhqP25BuyCyYX0atxBQ0vRp/opfs5o3rBjUUM4+9McSI6EbemHjZbcKfHcAui3wqOmeVNG4uSGwXsMgLpon+2LY807NLgq8nl4CUlksOm3/oXrI6lhKI0YHArG04xrplxreKGXd4SQ9tKPVGsSm3hQq1+IxNz7MhuUs22sn2TxR1+y4iAA++JJPGg94sLgkAx+SSGAqNuUNaNNodtoTCwNto7/tP9guJSWK3HOxHInmJUGv3Qu9UlygUDEVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRLhu0j/455Y5T9J1TaoFJFpEu8bzcu/RdTbaPAl3X8=;
 b=bib6HuYCF1OZNc2Z4dnfOMHqRt5gC/+zpSEoW+tJJ7Kwl0eLSlx04+qUuaSawbZdGJ/LsYKUho4Jub+dUTXVDjMQc8RCOHsZW31m+aJvOHFGuGbOmg9EwUsWdgmowF8LHM9HOoRIV8U8nICt3S8Y1FSbfmNG8I9sH4IKGyxwcbnzhQjL0wfT7crCg2Php6l5s16gQ5IXKs8DgxXjH0rpXUVzG6VLzkNc/7KivHGSBi7xuI9nKmbLdklJcB0t686eItpip5sz/Fz2mf0TtvcSGmWAc9wOuU8y9gluRMcR0QrBauMqzAZmRXgchZbitHdT+D+/HshqrPb0AfMF2qKQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO8P123MB7476.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:3b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 14:47:16 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 14:47:16 +0000
Date: Wed, 15 Apr 2026 10:47:11 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ming Lei <tom.leiming@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
	axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, mst@redhat.com, 
	aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, 
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, longman@redhat.com, 
	chenridong@huawei.com, hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io, 
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <nvumw2ekyms6r72uhq3nnyhksc3zxd3svom4agqhltz3tzeufe@i4zh7pvj5fnk>
References: <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora>
 <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
 <adpD8M8cNu3IZzEL@fedora>
 <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>
 <ad0Hk48y5JEeMlFk@fedora>
 <20260415083458.UD3cF5IQ@linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2qhzsoz5szogc6ye"
Content-Disposition: inline
In-Reply-To: <20260415083458.UD3cF5IQ@linutronix.de>
X-ClientProxiedBy: BL0PR02CA0110.namprd02.prod.outlook.com
 (2603:10b6:208:35::15) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO8P123MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: dcfd38bc-2653-4d88-3b98-08de9afde2ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	n9oasinS9ekXn1nqNEmOP3q9i6p1MHQUHEz6ioaw7hnuqjwT9zHDzv6cu2dF5YZrL3qlFsyYLIjpBqwxH+zEVFkk+AqtlZ7VKLu6mE4DcWpg/Z/yVUSk3320UUyAE6aTG05sxNcXexItRb5rqgIepuHrsoXQLaEc3cpVMqM7E+lWgdzAU43TuHsRXn0ndWUjhPlWQJ2YmAJLasNT/kjQqxjLUbx8VSrbuCZvkSqZYkV7Z5FfklpE8H0cG+sWekyrz4vvm8Tu0IQzuLO9lJVOWb25ew2nwRV2+7Z9SpF+BIi90j2htoz55evfLJMbGv7o7i1li23F/u6rbxdGVpaV47fUlbKcLhrjHzll0pNuE3/cFJJeq/vYkFO98yqUZk/op+poK0ODoUuoRHeHCYTjmV27O/zOaNc4A1U3CT5/Qqswa8OthTQVJCiz1v4yy1bi9RBNGkDPopDBqGFOtcUIfzb4DLlA6eaDGFLQ8avU18kaGi1rGhTRZQcVw90YQfQOdMmzYnLdF95cP/zco/7Gx+SlavP7TOmdFJ1LeX+Te6FnCa7Wetcke+3wbvOONqB9VP3F+zAa+mRD9M8aUjzeCiZZ9fYDcyV5B4NL6QkkKzZjjDXT9fcBRhPS4WhzoVGmQ82HVA3DO5VSThrz4k4mmHRXlhLqRbTXF+CH2Zd6Jlda6XdJ1RTsAeHARi+QdSFgz1ZB37fNcLhl9b3E/9yZ7Rx1d61ycglOXam4ih6Hm4s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STFnc3lQK0FsL2NSU0dOWElqSnlPQnFKNnhBbndTQ2NiUHVjVEZRNTdxUytC?=
 =?utf-8?B?UGk5cEwvY0hQV0hGT09EUjZxVXpOSWFOUFRXQ3RNWEV5NWlnVTAwQndsWWVZ?=
 =?utf-8?B?VlZuOW1ZVklBdjdKUGFsYzU0M2RFbHVSeUkzQmZkZWFxeWVGZ2QxTjRYM3dS?=
 =?utf-8?B?T0p3OTdSYzVyZ2NlMjNmUE96VlkxdU13M1NoVWxSYWc0ZEdhNEFJWHg1RmZX?=
 =?utf-8?B?d2ZvNW1nbDZZSFprWFU3b2dMczVRTU9rYWVWYW12ZkdPeGM0MkVVdkVGSHlF?=
 =?utf-8?B?ZFdTSERyZGx3NGNCOFNSVllHZjZtaEJtN3BQbnNwemRrYjRuZFFVc3YrMitC?=
 =?utf-8?B?eVU0bEc3b2lxN1NwNFBHYW43VFZCYlpNcnVEUC9KU2pWTVZoVFNGWUxaVXo2?=
 =?utf-8?B?YzQwWVMyeVNJOXJQbkNPQmkyYzhPblMrc2hOZVVheEdwREl6bzdpSFNJMXR0?=
 =?utf-8?B?NVlTYUpWa25CSmswMFZ6WlJYSk5jblhjZmF6eVlGa0dBRTRxZGNoRUJEclY0?=
 =?utf-8?B?QlRlSGFpRU9MOGUvRjlaa0pid2FYc2dXSGxXWFlkdzBMbTRWWWY5S2FYMzlz?=
 =?utf-8?B?eTExL0dnOFdRRWhxeXc2V2xQUXVZYzBPK2dnbE1sdTEvYlBZQzlJNlpCbS9N?=
 =?utf-8?B?aTlnZDAxYnFqTUtJTkF5cHRidzA3cmlKanBjUmdmMDZtQWpJWUlPbHVHNVdO?=
 =?utf-8?B?VndsdnBPR0FVajlMbHRmS0hQSDFTeDhuRU1hQmkvTlhYbzVVczMrdVlQUlRK?=
 =?utf-8?B?S0J5OEZOMkkxVVE4MTh1UnBXRFlmTGgvTVZzcnNaUkFyekpqZDhzcE9RTURF?=
 =?utf-8?B?enBUVW91NkYwU1JJWkV4QkJwcng5alFhbjRITkRBSDBueUlBU2xlOHZEWFFK?=
 =?utf-8?B?V1JycHZscnpxOEdvK3ZEZFc3R3dPMXhocUNqSGw4YUU2c0pYRE9YZFB5RHFr?=
 =?utf-8?B?U1psWXo0TWgzUmg5SDJaekQ5S1VuSTB0WUNvMEFjMllDYWlCRG9IWlZhVy8w?=
 =?utf-8?B?a1NFWlY4MU5MUzlNQjdScW42UGJZekdvdTZwSTZXdEg0V0lSNGFIS1dPT040?=
 =?utf-8?B?Z3hKN3ZqTHI4akpEd0ZndTN0eDV4YXlrUzdnZHhlSVJIanV3VWtIY3pCbHZw?=
 =?utf-8?B?TUlkSEQ0MUt0aUJ3ZmxnbmlTbTlZbGRMdE1YN1BNak9ZTTBmVnNlVVBRMmxt?=
 =?utf-8?B?OThEMVpBd2FSbWJCeDdtOUFqSUJSUnhOVE5iTHdZR1VtclV3WUM2ZUlhYlh1?=
 =?utf-8?B?OGgwQnh1TnpVbmhjQVRyNm1Gc0lWdDNyOUxyY0txTmhxNTdkRzBaSGhNM2JH?=
 =?utf-8?B?VkNXWnZZTnJNRlhDVExHWXNJRzJlMHRVY3FscEJ3M25OMkR4aVB1NjJqbVp0?=
 =?utf-8?B?NWZBbFQ0Sk1qWjV0VnMyWmQyS0RuL1VhYkpzaVh4N1ZIbStBNmZNYUMyZGJX?=
 =?utf-8?B?SnBta0xXK2lEYVJLU1FDdG9uL1I2V1loOUNTNkJ3aVBRVHltWXl3NjE4dVho?=
 =?utf-8?B?cFNNNUFUREJnbVVjbXFSc2IvNzdvT2tRRXVlU2Y4VVc5bDhMT0ErVm1meUNF?=
 =?utf-8?B?RkZ3OERmOURyaTF1bWNJZEdpWHdPV21IYlRYbSsxN2lGdXNpQWltcnU4cGxn?=
 =?utf-8?B?ZnNvdU9FQmo3VmFCcGNwSmd1N3JFSHZ1VWdhRTNVQ3dJWGlOTlh2R2NUNVFp?=
 =?utf-8?B?UzBSK0JHOUhzWWw3dzBKcW5nV3orSGRkUkU2K1djWXpUcHNhRFRGcGtuZENP?=
 =?utf-8?B?MjQ5UkE3ZkVLOHkwQlgwSnJjckY2THJSL0lLS2NRYmFSajhvOUlQaW9yMFZI?=
 =?utf-8?B?dnVSS0tzMnpmY2FYRkhYeWdHYmh6aWMrcVc3R1JYMjY1b2pPR1JUUm1LZmNu?=
 =?utf-8?B?eU5LdzQ3djRkcmNDcjc0WDhjZ0hiVk9uUXdrK0VmbkJRUDFaaVRleXdTQmVj?=
 =?utf-8?B?UEtQeFNxaUxaMHBCVEVmanF1S1FDbndDaDFWNE80cGZYdGcrcGg1Y1daZzJ0?=
 =?utf-8?B?UWk5a2NXWlRrUWpqeVJob2VQKy9tZjlibFAxS1hjUkNJRzVQaXVTWjdNNzho?=
 =?utf-8?B?MGtrbVNmcDg3eW1HT1hkQ1FCK1gzL1U2NjVEdlRFVjUzOTZpaC9JaHloSG5G?=
 =?utf-8?B?WEN6R1h6dGhiL0pKcXRGWDVabEZvVi9vRENDbmt1ek5mTUVoTlBNV0VXZHli?=
 =?utf-8?B?NFdRcFFzRmtjMnRvSjl0eXlQcVJiRi9IK3B3YUhkQTJWY253dGdCM2k1MUlr?=
 =?utf-8?B?RjMyZnJScDYvSFJ1a1l6QWVDWUlOQ3IyMGpnQ21yL24za3BVc1A1b3poTzNw?=
 =?utf-8?B?TFUzRno0VGJsejhhS3NHaU5vM1BNN29Ud0xVSTcra2l1WTY5cDFaUT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcfd38bc-2653-4d88-3b98-08de9afde2ca
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 14:47:16.2894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHoZEA5nKWAW3AdcB0qGZd1UIdu2w6VjVyBSFFYYGsvrd6VOKUbK024pKofW2cPqw7PLXNMfgcFql5GS+F9Epg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO8P123MB7476

--2qhzsoz5szogc6ye
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
MIME-Version: 1.0

On Wed, Apr 15, 2026 at 10:34:58AM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-04-13 23:11:15 [+0800], Ming Lei wrote:
> > > > What matters is that IO won't interrupt isolated CPU.
> > >=20
> > > The isolcpus=3Dmanaged_irq acts as a "best effort" avoidance algorith=
m rather
> > > than a strict, unbreakable constraint. This is indicated in the propo=
sed
> > > changes to Documentation/core-api/irq/managed_irq.rst [1].
> >=20
> > Yes, it is "best effort", but isolated cpu is only take as effective CPU
> > for the hw queue's irq iff all others are offline. Which is just fine f=
or typical
> > use cases, in which IO isn't submitted from isolated CPU.
>=20
> Couldn't we tackle this by limiting the number of managed interrupts the
> device asks for and then limiting the CPUs it could be bound to?
>=20
> So if have house keeping CPUs 0/1 and isolated 2-63 then managed_irq=3D is
> futile since it use 64 interrupts and map each to one CPU. Even if the
> device supports less it would map them evenly across available CPUs.
>=20
> If the user wishes to initiate I/O from all CPUs but not be bother by
> interrupts we could limit the device to ask for 2 interrupts instead of
> 64 (with the consequence of more queue sharing) and then limit those two
> interrupts to CPU 0 and 1 instead to CPU 0-31 and 32-63 like it would be
> now the case.
>=20
> Wouldn't that be what the io_queue flag tries to do?
>=20
Hi Sebastian,

Indeed, you are spot on.

What you have described is precisely the architectural mechanism that this
patchset implements to resolve the issue:

    1.  Rather than permitting the device driver to blindly allocate 64
        queues (and 64 MSI-X vectors) for a 64-core system, the
        "isolcpus=3Dio_queue" intercepts this at the block layer. It
        throttles the hardware queue allocation to match the number of
        online housekeeping CPUs (2 queues in your example). As you rightly
        noted, this results in the isolated CPUs sharing those submission
        queues.

    2.  Once those two queues have been allocated, the new
        irq_spread_hk_filter() strictly confines their hardware completion
        interrupts to CPUs 0 and 1.

By structurally enforcing both of these constraints at initialisation,
"isolcpus=3Dio_queue" entirely prevents the vector exhaustion observed on
large topologies. Furthermore, it provides an absolute guarantee that
hardware completion interrupts will never be routed to the isolated CPUs,
even when an application submits I/O from them.


Kind regards,
--=20
Aaron Tomlin

--2qhzsoz5szogc6ye
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnfpOgACgkQ4t6WWBnM
d9Z+Dg/+Pe9TdJNDzD3IRPZIKV47tJNaJoUvEVSSwVqCnWecAM9WiD9HmSzknQqb
R+3CBwN39Z5AX06sOIw9wp7M5xOo33jqQsCI5nmsawKG+LV48uKLEmCsXIaIQXMM
cOuwGe8KVMqeHxvwyjeLe1zimvz2c61GAckXpPPxpLQSCLMRlWnj5xI4yVR8+5NN
BPYtMgKuSnswJmCt6/ZN2VdEx+ybDxBCXFacgXcIbr8uq2QM02X02w/BjtlmaY/x
OwYFxrpucSTDu9gwHtEgzAhBc11J5pTm1kie2nr/132meFNVVNwFC6HTsJzapIw2
zy9SdCdTJh+fp30PaOGf8VRe7WQTjyQYqARN5WjXU0hk0vIO6CB6WU+y1Fhyt402
zny40fIg3Ik8s7H3vQS5xQrxnpEbsr6jxrYDLuJR5mpLRIxB3dSXyuacj61o8CXK
qwN/DhTcsXAqt0j5JioYwb8Op1thgVmxnQdoar0vFLpNN+vSh703q5n9qTQF2zz3
UuL/EvnbZcXAUnM8ugnLXsbVxIaQ58rrDETOzu2TTsfkQllHvu3vpV4Be08GT4Sh
iPZiRONBc6iopbw1ykgvEUw7mP0gjhI0HvmfWKCGGbifB5oi6yNLE5M/HDW5MK/C
bUl9O7+HFwfEpdHA2ikWsh69GuIv3XS2ANQM8vkcZ0I7DDDIhsA=
=88NS
-----END PGP SIGNATURE-----

--2qhzsoz5szogc6ye--
