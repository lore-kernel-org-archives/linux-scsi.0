Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021089.outbound.protection.outlook.com [52.101.100.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDA83A3E67;
	Tue,  5 May 2026 19:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778010471; cv=fail; b=XEFBZlpv9yocXue1VSpB7P6hz4paDPY0MnCKbLX74yq792lBnduak0SIA77j4bHFgY5YFqiyyNgrwys1npPwBGGJmDqYybrsvDryp2bwIcZ7IDWwzgoGQvNyPXvDAv1uiv2WYaxHTFfi8qBAYYmS/NIgWMzCc3ZI1q0e3wGkefU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778010471; c=relaxed/simple;
	bh=Bz+bnoLUMKHOOQUO1fyK9Y4nmOG3XlYI/ChfLfmbOMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rtyk0tDi+PKlSNqBMRuEGA+SqFEB6I0omGnbE/0gve7B1n2scFkFmRqDtpi5++yt2HTCV1FbYkLBl+ECyx7mlNHKPJTqcGMo2MY1PxvAtyawo/fPpw6rk546BJd1885XfuCzbewlJvkMc7dFY2W73cVejkJRBhTyZWIohb7I3qU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=liAXdw49pH00ToWBKDRyYx9csbrR4lxZhqPG3YTcJAT3VZVOpJJLzSfPZLY1GZ55GbvwoGZAeZWJLZG3zy/lM6ElBKmKNNDjzGPdkt9MtBQWvS8T4TPQmWWQqBb/zc+2hNE3a78oCowoDzl5W0zS2fbYG5p51INOtHJqUH6SrLnrpubBgHcJBBJEMNee33C6xnFB2v3O/GtHn0kMEi30sxzrovHIzrAIob1XBokP11q85ME2NLnFXii3zCdAzOG2JOlNw83XyorqoT8GnaapM+xNdYvX40ZDb0lB3qDjRNN3rL9y6q1TKabvI4rpwwMrSRSzxeAV474Ph+36+hPGcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqsePlFpca/2KCOFzWz/k2vTdFqbxSjEjj3dekm3P1o=;
 b=LNf0P99puAjJpXl9lLlLfgiSuCEk+ocFcZyGaPKr+U7Tq0MvNh0yvqJb8mNChOxsEv3y9EsR1o+O6q1POvT441sQBn4Z4WDntJFVXMSbc/ymoMvCdsjL2Jhb2yEqOlNkOeE4Qz3Q1ZDJi9UKFMqRxsAVVF1VOaFCoPEgAxcbJn9oTCVgehlJO1CoOWDUsfo3GXP7Qaf8ycjlGU4OYr91QChJ/pnF285uFJ/LIUQMkSHdZ3IXdUwEdNvb/yN9gZ+VxSmWbmqujir5l2NueE3cmCBpEhHtyjA4ZC8OsxLxdRShqJ/Uk819k1KOkC/EDH1qWw6HJaIqENRr0HKdWd3WRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7280.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:334::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 19:47:45 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.025; Tue, 5 May 2026
 19:47:45 +0000
Date: Tue, 5 May 2026 15:47:40 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	mst@redhat.com
Cc: aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, 
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, 
	longman@redhat.com, chenridong@huawei.com, hare@suse.de, kch@nvidia.com, 
	ming.lei@redhat.com, tom.leiming@gmail.com, steve@abita.co, sean@ashe.io, 
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, nick.lange@gmail.com, 
	marco.crivellari@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v12 06/13] nvme-pci: use block layer helpers to constrain
 queue affinity
Message-ID: <bnklzljfve53m33xdxv4mlu75kqrkpc3xooxgd3pnbvwjst5hr@btomkooj4crh>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-7-atomlin@atomlin.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bdutbjsvmktzruuh"
Content-Disposition: inline
In-Reply-To: <20260422185215.100929-7-atomlin@atomlin.com>
X-ClientProxiedBy: BL0PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:91::30) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: 31e9f723-568e-40fb-3e57-08deaadf2d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	upbFZqig0zsF1rdtEpWLMApkivUazhMQvE3WFMnF2q5TfupVGozLMa30NzghKWL6WaaHxPQ7G0uP0X1umVwHL1jWqg6Djp6C7Ci9Tw1IpzwR4kmfjUXHZbg/H/51tGVQ6pYNIZK66yGini1JQxJ2ReQjy9bzB9/NG+wgdhJ+hMTzReHLRIXVxQOIRo0mFDRJgAkLBHlbMi4X371SOLuQSjv0v2FOIQ0E6/rpuZ2x4D+Vsl6zHqXGMfjNSWjsq6Op+kClVVQOt/pfYQkFU2fT0PI8IfTm5pRhflO1iiMGiHaX4/XutQpn1Mdb9j0wLfYaLJHfT3AtvlJshiyGoLbewH6Z7JwYPk9CrxSYivZTixydRIu1TvhPpmBwtDSvadjvTL4ejUO+Vvj2I6c2TKUywGOh3Ktjv0b2V43Gw3XvbhXspDWOVN4ccbDL1CjHbqyBVWltOh79d8mNjlzpoDPPtKqQncq7sXM4tNbvjhU8JlmBZPfKEmdzyW92PGc5t2iiCh/seVYh7aa7ppyYhhl6zDQOClkpG7xca7Wi58c7RfgmzZ6t295WF0pzCpLBg4tKvPmB146/cBqvFyzOGt+opSZSA06RAZDyzvL7qsc4852eE8JrGP9OxlP3+YsRpZcbUsxRKYg4Aogzthl5QQRn2HLFssF0dCZziuFMOcS3Ow/OqEfovWARilAbisV0X68W
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGxPbWF6aGJNem5ZY05MVVpyWjNyS0lKNFcya3lhTnpYMlBqYXdSdnk3WVFw?=
 =?utf-8?B?blZNdXhWdEpiTWNBZzFTYmduaDh1QVo5WUhWYlNmc3gyL3daeUZZUnJyMitK?=
 =?utf-8?B?L3VrTTZUT2pxRDdRVUhIWGF3V21UTlU0RlphY0dURHlDOWxKb3BId1hRcTRG?=
 =?utf-8?B?TEU3Vzk1Q2owbW5yWlpPNUhya0J4Wm1RT0VaSFdZMC9tWi9ZbkV5WTZUY2dX?=
 =?utf-8?B?Mi8xRFFzak5JeHIwdEY0RlFWYTBXby9uVGFrbmV0RDBZUzAxTUJNUy9mTlJ4?=
 =?utf-8?B?dzJFc3pTR2RpRlRHT0Ftc2x0andZYm5SWGRHK3hQMUltb1hFSGlZNlJ4dHRz?=
 =?utf-8?B?d3ZzYWVsRG5RbGZodHpJWnA2QlFVV2llTTBFNEc4WDROa1F2NkhUZDd4dGcx?=
 =?utf-8?B?V2ZsNHBjdkl6ZFVGR290aEU3SThaWnJKQ2dXb1dLR1pRUldhZXFVUWg5aTl3?=
 =?utf-8?B?MktlOGhvZlVmSDlOcDZUdS81a3JLdmdIU1pjMnlGejA2c3hFWWxyN3E4WXVH?=
 =?utf-8?B?L0FCK1cwWS83dFRUa1czQVAzM3l1ZEtuUmpGZTByV1Uva1VxanlObVQ0NEZ6?=
 =?utf-8?B?aEJyQjlIREdMTWNnN2k3a1kzd1ZuTWZlK1VYUFh4aFZFTzZQc0ovL0M2WThp?=
 =?utf-8?B?QkNIQWdYZHFacEFWMmxaMXVYL05HclNHZkk5Z2IxR1JDWFdFVGtkb2czK3c0?=
 =?utf-8?B?bUNxRmRmLzE3Y1RmN0x3RmMzZDRSVGhBdU9qRnU3Q3BOTWVjRFVyaDhQazV5?=
 =?utf-8?B?T2JUNTFoL0ZFR1JmZjM5TG9pbE9OdXg3cHFqRjIwcjlsNmVBVGhUVnpsZDdP?=
 =?utf-8?B?b24vME1qeG9nSUNlc0ZvSW9jWVoyNDJIeXVJV3dEcGljdHdCSzBaY2szblBR?=
 =?utf-8?B?WUV2QmNydDdVVDMvbnArYkpOM28ySUQ0QVVvZ1d0cEV1RytyQTMwRHUyd2pW?=
 =?utf-8?B?Rlh6RThJWm1oQ1gwOUozbGVwa2dxNjRCeXdOYWR1RXdkYndSN1ZMK3RyVldO?=
 =?utf-8?B?YkMwVTZ3dXVTdG4zTWJvZk9lZmZoM0dnQU5rTzBqU1ZJWW9yK29ycmJPNEww?=
 =?utf-8?B?NzJPQ1RML2NXa2ZFZkJqNTJBbkVkZmJ4UXpUaUxKaStvL3JVYnY4cUF4c3Vh?=
 =?utf-8?B?NGlwTWhrV2d1TXkxQWdXODJPUXRMMzhNQzhhTkd3SWxMKzk3UHJrcE5GRHJo?=
 =?utf-8?B?aEp0TEVacDZydG9PeTZ6TEhCU1paWmVIMjZSbzdGNTNrb2NJTXAvZmd0YzhC?=
 =?utf-8?B?Vks0SVBSd2RVMnNTY3FtOXdyc0V6bnB0MXFmVXRERXRhSDQ5TzVsb0xuUnc0?=
 =?utf-8?B?Z1pMb0dvTFd2VmQzZnJrZ042eVRBRW42U2RKR2pibHlDRlFmOThrYVduSnA4?=
 =?utf-8?B?ZGxXOGNNVzYzT3Nrcm9qVHdDVzlYYVpMaVRWOXMxSWdOVE42bHpEVHB5RFRl?=
 =?utf-8?B?em90TmFmaTZDYmpXdTlKQnI2bnZXZFZTdCtlNEdNcXBGblJOYTBVNXdCRmg0?=
 =?utf-8?B?Nm9KeUQ2UXU4SzNVUWJRNmxtcm9Wbm5FQVMrS0tiNGlRYjFNZnRNdXNpUTJS?=
 =?utf-8?B?UDRWQy9od09GNzdkelRIaEtwRFhOTVRiWnBNUUlhKzU1M2tjYmlMSm5iUlNZ?=
 =?utf-8?B?NWN4QjJuYkF1R1FVWjJFbXBSTjFMbUZueDNwUlZqd21BRnZYSnZqckMxNzBY?=
 =?utf-8?B?eDVWdEVDSTM1MXp4LzNWT3k1MTgwTDR6dUVuQVJ3R2ZneTZUbTVvT2ZjL1hQ?=
 =?utf-8?B?ODQwU3AxWEFGTzJtZjRVSTF6VHEyVjRmdjNlV0dnQ09QMHdNMnZMMnplS3hI?=
 =?utf-8?B?OE9MM3JMdzBsdFhWTUJ6U1ZXemVIY3hpd3NCUHBEVG5PYkR3RnpFUzJ2TWh1?=
 =?utf-8?B?RmFtUkFwdUxhUjZJQnZKOVJHd3NrZFJIVGZ0UUNadGU5WWpiNUNsZ3JlOFVN?=
 =?utf-8?B?ellyaGlsaXU1Y2Y2dWpBSldFdVJsTHl3dllXeGlqZlNNWlR3U1hSQk5BWnM3?=
 =?utf-8?B?WlZWdDBTazhSTDN2K0Y5cnhkZlNsV3ZvVCtZQlZWYXlPZkhZMHlBTXo0TkNa?=
 =?utf-8?B?bjJUNVJ2azJTbGFsK2FOSGdhSWtOU3JDQm9RREpxU3dGbVBjRDlJRW9QQ0xT?=
 =?utf-8?B?bnV4VzlMUXhheUVJVmE0dkhJclpDa25PNHNSeE9udEpEbStpRkxBM3FNRlA1?=
 =?utf-8?B?cTkyR21HS24zckNtaXg0TXl3Z0hMbjJtU0pLSFBpbUV4K2xSMmNRa0JsSFFo?=
 =?utf-8?B?YkM5TXovNWRnUE5yWWFyOFJ4dmo4S0NieHNDVi9uMVFoQkU5ZWxjd0NCZUVy?=
 =?utf-8?B?ZENPQjdvU1NFRXBZTUl1Y0dvK3VFZGN6RHhHSVFONEVjZjJ0Z3lmQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e9f723-568e-40fb-3e57-08deaadf2d3c
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 19:47:45.3079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+ti0hjJHyUf7ZeO3ueh9l7wly4WMoPPp7iliAfKbBLnhyNpxGfuKw5taRFtwQqyFWjlgTqdf8YCvPvKfHrHYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7280

--bdutbjsvmktzruuh
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v12 06/13] nvme-pci: use block layer helpers to constrain
 queue affinity
MIME-Version: 1.0

On Wed, Apr 22, 2026 at 02:52:08PM -0400, Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
>=20
> Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
> constraints provided by the block layer. This allows the NVMe driver
> to avoid assigning interrupts to CPUs that the block layer has excluded
> (e.g., isolated CPUs).
>=20
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> ---
>  drivers/nvme/host/pci.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index db5fc9bf6627..daa041d15d3c 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -2862,6 +2862,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, un=
signed int nr_io_queues)
>  		.pre_vectors	=3D 1,
>  		.calc_sets	=3D nvme_calc_irq_sets,
>  		.priv		=3D dev,
> +		.mask		=3D blk_mq_possible_queue_affinity(),
>  	};
>  	unsigned int irq_queues, poll_queues;
>  	unsigned int flags =3D PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY;
> --=20
> 2.51.0

Hi Daniel, Martin, Hannes,

I think we can drop this patch, including other similar changes [1][2].

The next iteration of patch 12 [3] in my queue, irq_create_affinity_masks()
has been modified to respect the housekeeping CPU mask. By intersecting the
base affinity mask with the HK_TYPE_IO_QUEUE mask prior to topological
distribution (group_mask_cpus_evenly()), we ensure that managed interrupts
are kept off isolated CPUs.

[1]: https://lore.kernel.org/lkml/20260422185215.100929-8-atomlin@atomlin.c=
om/
[2]: https://lore.kernel.org/lkml/20260422185215.100929-9-atomlin@atomlin.c=
om/
[3]: https://lore.kernel.org/lkml/20260422185215.100929-13-atomlin@atomlin.=
com/

--=20
Aaron Tomlin

--bdutbjsvmktzruuh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmn6SVgACgkQ4t6WWBnM
d9bcQhAAk2KC1UTEVn74BQrwFZbjmi9ct4gqQVaZ/KWQMgvX6cAej2lT+T4UaItU
UJ+5+H3MwX+Vwz/pQDHLcE2BcteAEAVwaoMZ4W9qjW81M5SLgovJrBUGW1EBxi5n
RGny7oGu0ofmaE/7T3td5d7pyLpO/SkqkrmVfBiE2fEFlM4R2CGPcJWg31m34Yxp
B9U3klph/GxTU+VeQvcxioXvcu4IXzAxC1PfirXRmA/AKE6Ao5srDlEexE1TuLha
+EDF82Qqka+R5r2ZT2noceRO4Jx3mspOeqcebB3H44xHsHmTt0YsQSZufIz+QcKJ
IILaXk9/V2iZbUPqd9l5X+DqWamjzrq6EoTMeS8Ee4heu6ZzvbFQCYKRYin50gPk
o7lB92QY2Z+3oDStaA/o4AjdTGAQbqP8OMC71793hCToi6HPIT4nd0Hsl1o+AFmd
Usln3LDMJ4Kfmat936ZWKqyNqSaitYZqEk/OP73exmD83ir9iB8xH+nXmbokClYj
JLUKgIqOhcwC5ZBRJSlxIs61awavfcXRSgVteeH/uHUvPzzLvqQEd79ZS2IkBq1z
x3kLMFEaqEILnY+pY9G4LuOuZy/sqRXSx67O4bfMQQ7jMW6bmo4E2JyVlv3sRV1C
WDH8tIozgWOZlccRRVJEc4STjhBEMgbMgKZGtVWvUnTvtLdQaZU=
=0Nlv
-----END PGP SIGNATURE-----

--bdutbjsvmktzruuh--
