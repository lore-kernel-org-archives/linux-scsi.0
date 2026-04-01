Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022117.outbound.protection.outlook.com [52.101.101.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB8E1A5B84;
	Wed,  1 Apr 2026 20:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775077113; cv=fail; b=EHbZFHnQc6oKl0xFcf6X2lQKf+2+VP5TR4edgpuS1YBAiGAV1SK12otmvej8HdzoXHXK32vvHKdAZwzeTYG8oaOKKezLz1JnqPsLTjV/9047xY8gmeZDuuzvaUirFVjPJcd/p/MXhZUYhOYseBeg1pLvB/Tfkjzwrzv4+ymjZo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775077113; c=relaxed/simple;
	bh=tC116IZfiuhR/8/6V2TFugIm0YIJ8edsmRcHzZmlhMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I3Nn0fdBSS/2pKDi4f26M+2/1nutMDfnwwevD3GVGB2pvtgV6BOiKpydl+uT1KarUbB3nhOuIjn3EJt4mil72ZOJ2XuswAJRE13aP6Nlcv07BKuDwbGL6uu55MI5GY9aPGPZcdJljzAr1i6BLPkOZDEvC9y4/+P3Hr7GKJyCVDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jOqYxMS3iIW9yMmBA5/cBti6aa0PPVtRCOTZNizE5/MA9b91lTWI7WG6c9hg+BB3ohDJioaUbFeZcmxvijB7jUE7Wjmd+aFg1SIPmDW/9ZTomVXWSnzx2rcGWonS4nG+ALJsDvKtOOII6ohZdxeFW5Eo2yfteRkz9wreoTRjgeWQhGhQ0hHefIrSUawW5qd9HFDze8oqeU/ELlbIl2/jdYo/LpsDfGmuK9l4Anw4jIKgUNCUvCFQY+ZIKS955QU8Ze/CFE+403xlHIbFPIv5UXN3FrIK+gGE61WbLN4hSgmDgJG3Pd/Ojrh+LRao8c1ke7n6NGveMPo2TZhI16DS9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IH3QkPIFqE+eeOvozAbqovfx6dkavu2TPrUucG6OhU8=;
 b=cMkDYfresiH8eVTwQQ+U2Q5hpAqpDi5bz3PLxc1IlJoqOLuSZVKAu6cCmCubZfbc97SG7hN0SKM44NO+VCv4QOSEFnoAFzOOjQJpqFwsRirDZ9GG7KlJ1Ahy6nJ5U648JPBILnQW40y3aNARfugMTUH6s2ilstcFNYE0iTzZ4YBuo0mVNx5r8q/iWEQ18iWILlGAA58cfaDFJaCmdVWFyOOLf/VdtJLRWJbHgMN+V/4eXzaHS8JyS3i5uufXm8MMnnLzNM2FJFooLCUTvOoXtAfFj027FzsfYhMSv3++qwf3z1r5Q78P5dBamzdJvnZthjuyEu1GLJVRMG2xgKHH0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6480.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:186::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Wed, 1 Apr
 2026 20:58:26 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 20:58:26 +0000
Date: Wed, 1 Apr 2026 16:58:22 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	mst@redhat.com, aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, 
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, longman@redhat.com, 
	chenridong@huawei.com, hare@suse.de, kch@nvidia.com, ming.lei@redhat.com, 
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
Message-ID: <c7phvlvohdn2ksc2jymxk5foolwlqaqq2jzcdv7oic4uzomh3j@yjimbwcnnst3>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-10-atomlin@atomlin.com>
 <20260401124947.-d4D5Cr-@linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="acbgx3qyz7va6zfj"
Content-Disposition: inline
In-Reply-To: <20260401124947.-d4D5Cr-@linutronix.de>
X-ClientProxiedBy: BN9PR03CA0766.namprd03.prod.outlook.com
 (2603:10b6:408:13a::21) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: 4680ee29-1aa4-40a3-1cbc-08de90316b57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/xWIfKOYCX818LCWnsJYcdfDPRJIWBDgmoMG5Czx4UWNEH2M2/LuUMEcs73o/CO2RbfV7jW63n+RS5PBKhMmv1hYElYhj4+/O2ntRF5w5IMUIfvwTwOFF9sEi2RoAoalVGUW4HUWPK0fKFaN40wMi3AU7dyZ8pUTVLrWrSMHQ6eFJ8kH/8AjDn6xla6ZiWKAwnjoKDbib1MtnXEjwUc8rGDRiFYT7X+lTrH3TBOiJS4S7Eho47cufVEA9YgzFAkOBqOkF9BSM9lFOSTGOiE8hpUF3ZyDl1fcd1WiZIkoqDUwFeTiep0wb/qe6H2FfX93uCLYqIOXvCKxRfDr7ZUdnD5z5ACkGj9+s6ix/a7ef2ydEjUeTNfC4j1CsW+eSnGDxLvgWQpSpWdTu1CC3LZ331o+VrrDrdmLFfmW3ugUmxwsVArYtxYNA9z/Bh+CAXSs9Oyu0VxX0Eqpqg8giVfJvfjMGsFQE7TixqOeVyDKy/7vn5v9YRYvBirIzNKRgtWcCdroYYRywwYfSplbDl4kX1AFdYBffbOnj2r1UJwudOMHAGK0p5dhtJ8cFRc4qsr14vAW2YkH7lHhReRKFIBmOXKm28c7U+IMgDYBqdgQnMUu5XCQ2+NESxZrAKbJxfi0CgOiRnkZqZnfWlZjZBoEhAOLYcAjD8F6w9bhQylpscbDIk9W/eU/nkHIe1trVwIow1lBHJzuyery5hxOQcjBlccAEs8wZ1Xq+uleqSL6mgw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0R1Vk5kRTVKaFNHeCtSaW11emY0TmVNZE5BVTNPeWZTTUNRajEwcTRvT1pw?=
 =?utf-8?B?clZISU1GOEo5a0NaMitqUC9XOFpQdmNYeEZseGhhZmQ1QzZsRVNrK0Z4eit4?=
 =?utf-8?B?YXp4RFRZR2VoYmpzR0xwMGpKVzg2RVcwSkU2cHhFSTNDRm9ZMmppNEJiN25E?=
 =?utf-8?B?R0lzWjQ3dE5Lc0g3RGh5b2ZiOTFkcmJ1Q3FEZVl3NUJ6RDJEdWRXcXgyaUlv?=
 =?utf-8?B?WGRiMDRjY1hobXZQUlUvWDlKOEpiK0pwdkRzSXh5U01WSHFFei9qWldvNnZM?=
 =?utf-8?B?NVZBeUFJZGxVZzFXUmtScWpsZFBGL29SNTMwODZlNEdxbTY3OW41RWlhMHNx?=
 =?utf-8?B?RlQxQ2NZNUZyL29MRXBxVjl2NTM5UStoaU5lZ0MzR1N3Y0orSncvVnBDU2Fh?=
 =?utf-8?B?bEJ6cVNlSThGc25XSFAxSWRJd2IrSndCT0h6cjNSZEpQVzVXb0JQQWhNL0pr?=
 =?utf-8?B?RUFKSE1LSVFGaHFTS2Juc3R0di9Ob1kvMGlmQ212SkVDRUZvMUtHamczTjRz?=
 =?utf-8?B?TElwRmd5SkJRWkJMWURGMXNuazlDNzg4SEFTWkZENjVsVmJwM2g3cFZhNm5I?=
 =?utf-8?B?TnBBWE83NmZIdllaekRCcFVEU2U0UXlkWC9RZlJyQk56L3ZGSWt4T0JCbDZK?=
 =?utf-8?B?M1M5UHFVNHJzTkk5VS9oSHU4d0FhVFA2YjdBVGRJZmx3aC9hYy9xdzh5MTYx?=
 =?utf-8?B?TDRBVU5vSlJkbWRKWkViWHZQTUNDMUZZZE5ROVYwNE5hWXV4MEUzR3JRZEJJ?=
 =?utf-8?B?cnlxNlJhcFBSazIwVGFTalJ0U3NQT29NTkMyOUhnZU9BVFloaVYrZHhyb1Rl?=
 =?utf-8?B?YU9GSjZUcjJ3RUVhTnV3eEVzQWJ2TTNadHZac3gxK1pqVGlPbklxOVFSTXdL?=
 =?utf-8?B?Wmt3TEp4cFhkc3BwRnFYM3VFOXA3QkxmdzVvWkp6MXFSUFlUTUZKc0Z3WitW?=
 =?utf-8?B?czBpblQwYmhtblBkemVOZlNDMHRYQ1hIZGlnaVVFazFjRjJOQWg3c0xXcUZz?=
 =?utf-8?B?VStYYllpTHZFUGV5dXNhOGl6cTEzNy9Pc25mem8vVlZBWGlxY2JsK0VRYlEr?=
 =?utf-8?B?NlAzM2o1cHc5NXMxcDRNTXhEaHNVb2VhVkNvVHlCQ2FYUHB0d3ByQVpaQ2hZ?=
 =?utf-8?B?YTA2Ym1PTXNQZzBEdGFBbld0dHplOHNiaDJ1bTVSOGUzWmlKaDhSVU9nbnZQ?=
 =?utf-8?B?QzNONEtZUmlDTDZ1VndpaHFjQTVTOXFXcGxxUW1NWC8xYVVXRWFvd1dEUDBp?=
 =?utf-8?B?V2pDVlREZmhpMWJCbTJYL3JJU2pkbUlBR3dNb2RRS1BhbVEwLzZ5dURLeDUw?=
 =?utf-8?B?M0Z5UzMvcFZ6ZmpVUWFENGJGS2lGNUtPQWptcm1RSm9QcFd2M0JUYklGZklh?=
 =?utf-8?B?UGd2QncrKy9OZkhheDdLanNUYjdwR2NoTkJtVnk1NXBSdk9TYzBOVXc2Lytx?=
 =?utf-8?B?eXJOcDFUQ3VnUjhiZ0J1c091YnErVzkwMmU4ajRoM2gydGZIb21NRGwvWFVh?=
 =?utf-8?B?WFQ5M3lWa1l5S2R4WHZvYnFWeG1aOFFPbXVzb09QMHh2OWIrWG8yWG1qWlRi?=
 =?utf-8?B?Y0hnakpxWFhyUVQreTVubDIxcy9HWmJXVzNTQkRWTFRVWmUxUG9QNWF2eE1p?=
 =?utf-8?B?WUNnN3o0aFFXZTFxMkF2RFNkdkdiMEpNV0QzU25udVh5VVg3THoydGZ5WlJN?=
 =?utf-8?B?SjhMVU9iVEwxRCtXTnVJZFY0dElhaHRpYlNraUJaSVFxdWhkdktpbzFYcGlE?=
 =?utf-8?B?L2xwNTMvenFHN0VrYm5VMWRxZ2JhSXJxRlEwdlNERkRLQzYrYnN6RUIydjZW?=
 =?utf-8?B?V2VzVFd3NWZOVlhSNGVjeWR5L29HeHdMaFFYMFE0S3V6ZndMT1Iyd0Q5Y3Vk?=
 =?utf-8?B?UkRBZ2VLeWl1L3NlV01tSm5qaUxSalc4OFdxeEhacjhuMkFmbVFhbVBLR0xj?=
 =?utf-8?B?enBFR0NiTW5rWHV1VDRDb1IxTGE3Y1dRc1hpWThBQVdCdWFuOTVpZGdvd1Z6?=
 =?utf-8?B?STBvakxNN1hKcmo0N3Q0cGRxRTZ1VVk2dkYvZ2hSRmhQeUdKdXhkNk1wL241?=
 =?utf-8?B?cHZkVmFITzRicmdXVlNPMSswRGtGam1VWVJxV3JTWEY5bTRUS3FZTDBleCtS?=
 =?utf-8?B?UVFWWEJpc0EvUWNHWTZkb2RuaXdGSnU4djFQUWY1eDEwTVc0REVYWGpFeXYx?=
 =?utf-8?B?eVJUWnF1UERjU2xEa1NEYmZtYlNUYmU4Ti9VVktLYUtTQ0V1RmVLcEFQVFhU?=
 =?utf-8?B?VmhTc0ZsSkxsTGNBSExibGdvTDVQK2g3dm9yUGdCSDJLaElNSmJxTXhpT2xS?=
 =?utf-8?B?ZlQzUStyN3MvNzR3d01qMlpqRXozVXNZZWREdCtYTVZYQW1sVUEydz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4680ee29-1aa4-40a3-1cbc-08de90316b57
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 20:58:26.4351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLmIlQGgw4Llmzss4+W+0zQlx5AWU8+JeU9lWmBNb3t0cRX4uTOoFg3qEP55/NvIfxRLQYS7XOP6vHuFRBh1Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6480

--acbgx3qyz7va6zfj
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
MIME-Version: 1.0

On Wed, Apr 01, 2026 at 02:49:47PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-03-30 18:10:43 [-0400], Aaron Tomlin wrote:
> > From: Daniel Wagner <wagi@kernel.org>
> >=20
> > Multiqueue drivers spread I/O queues across all CPUs for optimal
> > performance. However, these drivers are not aware of CPU isolation
> > requirements and will distribute queues without considering the isolcpus
> > configuration.
> >=20
> > Introduce a new isolcpus mask that allows users to define which CPUs
> > should have I/O queues assigned. This is similar to managed_irq, but
> > intended for drivers that do not use the managed IRQ infrastructure
>=20
> I set down and documented the behaviour of managed_irq at
> 	https://lore.kernel.org/all/20260401110232.ET5RxZfl@linutronix.de/
>=20
> Could we please clarify whether we want to keep it and this
> additionally or if managed_irq could be used instead. This adds another
> bit. If networking folks jump in on managed_irqs, would they need to
> duplicate this with their net sub flag?

Hi Sebastian,

Thank you for taking the time to document the "managed_irq" behaviour; it
is immensely helpful. You raise a highly pertinent point regarding the
potential proliferation of "isolcpus=3D" flags. It is certainly a situation
that must be managed carefully to prevent every subsystem from demanding
its own bit.

To clarify the reasoning behind introducing "io_queue" rather than strictly
relying on managed_irq:

The managed_irq flag belongs firmly to the interrupt subsystem. It dictates
whether a CPU is eligible to receive hardware interrupts whose affinity is
managed by the kernel. Whilst many modern block drivers use managed IRQs,
the block layer multi-queue mapping encompasses far more than just
interrupt routing. It maps logical queues to CPUs to handle I/O submission,
software queues, and crucially, poll queues, which do not utilise
interrupts at all. Furthermore, there are specific drivers that do not use
the managed IRQ infrastructure but still rely on the block layer for queue
distribution.

If managed_irq were solely relied upon, the IRQ subsystem would
successfully keep hardware interrupts off the isolated CPUs, but the block
layer would still blindly map polling queues or non-managed queues to those
same isolated CPUs. This would force isolated CPUs to process I/O
submissions or handle polling tasks, thereby breaking the strict isolation.

Regarding the point about the networking subsystem, it is a very valid
comparison. If the networking layer wishes to respect isolcpus in the
future, adding a net flag would indeed exacerbate the bit proliferation.

For the present time, retaining io_queue seems the most prudent approach to
ensure that block queue mapping remains semantically distinct from
interrupt delivery. This provides an immediate and clean architectural
boundary. However, if the consensus amongst the maintainers suggests that
this is too granular, alternative approaches could certainly be considered
for the future. For instance, a broader, more generic flag could be
introduced to encompass both block and future networking queue mappings.
Alternatively, if semantic conflation is deemed acceptable, the existing
managed_irq housekeeping mask could simply be overloaded within the block
layer to restrict all queue mappings.

Keeping the current separation appears to be the cleanest solution for this
series, but your thoughts, and those of the wider community, on potentially
migrating to a consolidated generic flag in the future would be very much
welcomed.


Kind regards,
--=20
Aaron Tomlin

--acbgx3qyz7va6zfj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnNhuQACgkQ4t6WWBnM
d9Y8PQ/+M6Cz0mJCKeBcPxSVFvb+Z5xDWI7jd94xhZ8aEN3AP52ZG4SRrTZ/oLXo
yWa9XGFc7m/gyCal5E9pIkxODPGtv/SDD0XUNJEcg8NTQmNjpca2g1eHiOKTYfnd
Pvdnd2rhLd7nsgwxzbFpi3FULQC2TdTKTx9T38qcsxcZwmbKSwX+ggmi2lbrJyjK
4595KhQtwV1o1P2TvjVyA73w2lbifyiNNGGn/O+9F6fdAE6zwVbfOJ+6T8nOC1nt
/GiyStADhOSQQtpIs0WiaWYel3Cp6sS8bOo9KgXnAWoXimRgTy/zdena0wMLQcZT
tkaT8+e10tzs9DeJH7vWCy+0qMZFYRu0cLcDKCQhmRmFW/pRWLjTyxMgNqqLDbvY
JZ/yvg030lSuVKupBVe11L9doQnLk57GrxbiD86k+2VsFOm9yeS9cCl6ZXQIZyEU
uJqevdGTAUawrXm/Fb/6tUw7Y4HcQI8hJ158wIedC9xhurfH4NorFtp4Yyz0Orm2
nfVkPgj+aW1qTqpA614ozDsft7MeRkZSpD68T50coWPiMUQ0w5oXlYz1xlT5q9Xx
yl/uQh9HxQRwuSj/O8buK2P9DLttiCmOunzZtgrdVT1u2mYpZnYEfrBXS89M03GT
j1J2xDxJOfXTDX09YiV7DsjBY02fviKLtGPnmvu5HeRBidWooeY=
=cNcE
-----END PGP SIGNATURE-----

--acbgx3qyz7va6zfj--
