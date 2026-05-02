Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022086.outbound.protection.outlook.com [52.101.101.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FC92C21F2;
	Sat,  2 May 2026 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777757158; cv=fail; b=EuO7bdKcytRera68WleVetnKv9yJ0o/+/SoDdnmKPoXbPYFnPRKcxtt/fAbUhgOw+IqMtShSVGUIW2Qc+iZwG0MOeC3zzkPo1JsReKd+DYE7nz/m5s9rWJ3PZW6tIUMSy/g7sHmiy5hAjMvBA6j7SjvY07tMae379kSbZChBl+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777757158; c=relaxed/simple;
	bh=XKUojS3E06bsu5ppDYkEVtzWbeLSnQZczqL6xq7HHWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GTsYVvcAcaHMIZgVEqI8Ujr8//OhPoDhIKB/nOiyt4nDoR4xtyhFh/dsYCKZuV+ZJBHJV+5Og/9dr1sWqBMXqlL8kBByDA07O1kGM5A68MT9+FPsHLQBDZOjpWgte95KyQU2QyumToipGFhqorKjipuS99/LdmJy0f2MybuubNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DMenDb+KnB55ZoDpIDdH7V2Pjh7zYLSl3eD/z9dbn2SDYVc6AkHuPDJUBDVZpI/p1KU04sMP88h+ATAG7xqbTrso13O5+OwzLax5hf5BvEIrx60LnEJKoNSd4XqXdGkMqbdRbx5fYESwnSagQYvgc8HK7SrOIeYzGvPILGfp8ioNb2MOmxz1s+g9TX5lr8bE60OgVF4Saq+6IBr7fhnDTwX+9kAKD90f3hgZeBlO+IKJMKKEYMj8BT1tskkmAVFFXbXkgB1EPekWjNWT5vlKZ2uU3tMZkPdklVr1cPjBPzhMoRw//jPaYQOgp2iL9jbuvhiTi8eKDTSUehoDQxiSsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcAq+pMB7L665JoWfUxLGepshlBOBBfGLD6O8ljNGzs=;
 b=V9ZfN3VSv0ghsZ84O9vGN6IBTo6tZLjsMVgFLPKKJN8IvvIA+jwxe7cmFf3y77hCbpsfMlZtsZHo2xYuAXlsjL/aM3bNu6fnWR+/vWGMsQ8A1vsu3yVx/Dxf0q3a4oqI4MdaBVReM1uRT1BHr2vego6d+WFt/QC0a+AkL82i9Fuxa6vc9Aftjd3wOTPSUh9CG5VISuFMzHpM7q5I6rGzwKJbr93ICAkhZotRJlQ45HJLNphP1MCEn1v8yeSxJFlG+Vcmop8ehlvpfVCz4g263ilwprwQp/eJ3DkyiYcx0R9yrmLUHESs7cjnTTXT+F+VmAT5DHhJLRiQZ5kRaF5EOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3857.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:a7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Sat, 2 May
 2026 21:25:52 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.025; Sat, 2 May 2026
 21:25:52 +0000
Date: Sat, 2 May 2026 17:25:48 -0400
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
Subject: Re: [PATCH v12 10/13] blk-mq: use hk cpus only when
 isolcpus=io_queue is enabled
Message-ID: <pqpcky5knzppvk3v6ldgpwgu6agjl3lkdletbkqpg2kl7t7zhq@xjbgeuas56sf>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-11-atomlin@atomlin.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="llp35ou3kozi5xin"
Content-Disposition: inline
In-Reply-To: <20260422185215.100929-11-atomlin@atomlin.com>
X-ClientProxiedBy: BN1PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:408:e2::27) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3857:EE_
X-MS-Office365-Filtering-Correlation-Id: f1575383-5b0f-4716-5bc7-08dea8916319
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+5ZDs1Bb+lfBA4AcZSvMBCXlYWIZNpBpf99sScxlFrYYXa2EzqqUjTjfUJgnsT24fjH4+dJR7Mw7w/Sn/XvWor43N+iVxdx6Q/fEpD1AU8fEsbcR2MTWAGuAsvNO9iUoOEut1+rpk5cbd4j9lPysCYnUOWaTHIwZn3XnNHfEATFwotjZj/3q+GFpgjfo0RcUPF/DEobC4Gpzbmm+kvA8gqLG814WYEaUOYqdMST32DXYGtSM84IAnNy/NJrSjeLvlm4KFFYo0uE3VI9S+auqKWaIrCR4C7U5JcM1Ct/PUrQH239ilDe8gHZx+IcekR3pgVoB7+uWnwl46pyNccRBVQ6e6O64Noje8PaG6p4VGDUduAw5mkM4A1WtRFo+B3LK3jzTIab+QorhAA1gFn+oSDaxu2ab6ABaMM+H1d4JGYyp/5zJ1wUkG/I6T9ZJsqDLDdn3dI8vGNlIz4S/6l7wodYY3Re14DCDv69EYRd/S6Ss2cIzSFFx30JdQHD0H2TAfgdoCxgLT3eo2rfMZ8LNMuFSjd3wFRqRU+s58wSstDFchCf2fVEABrEYYUoinm3xkn1tMItgJUUFyMnQebkbPBlLmxBoPe3+gfFuPL4pMlFRLR44ZMlJN3a3KOy01LOS+qvSnFCILoTkbqgtzf+tnBp9PKYxHROl0y3vov4J0warhxrbxoii9OmeA4e7rxTM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1dhUjNPS3UwWWpxQzNLWXFqbFhBTmZVeEh6enpyazF5UFFRUytGdWRIVjY4?=
 =?utf-8?B?Q0JnQ2lXTzBkSWN0bG1BT0YxdDNIcmhONXdQR21zRmNNTlJURWhXeGVzQ09N?=
 =?utf-8?B?d0VwV3pkMmQ5eFJtbDNzWHFad2lEaDF5VmN2RzJZK1pnL04vOElYZ1M4a29p?=
 =?utf-8?B?amZtSDgxa285VEVId0lmNlZqQjkxbDJLdC9UdGNJNEhUaWlTWDVUbk4rMkl3?=
 =?utf-8?B?ZU9jSFErMnltbnp2b1BSWFY3anFTcGp2QXRQVWIranM4VEFEbVZxUXUvZndr?=
 =?utf-8?B?Zmk4bUwzbXhpeTI3aGV6c0IzT01SZjgwWGFJNG5HQkJ6WTBpYmdOdVNkVHJE?=
 =?utf-8?B?NHJjVmVOR0ZNdXE1UXo1WUpzNFA3VEJhUU1uWkVzUFh3VE9Dcm5ZTEJMUlZR?=
 =?utf-8?B?NlBYM2hEcnU5dmQ1dnNGYmZ4R002NmQ4RDByOXhWdE1GM25kOFZDMmVVRDJ0?=
 =?utf-8?B?UmxDKzNLdDdxNnQ0bjNWL2htVVN0MTh3U0NleG8rU0hpMDd5WWpMWTlCWHJh?=
 =?utf-8?B?a1lVeWtRTEU3VjlCRG81Ykt5TE4zM0oxU0tuT2NtYlpFbG4rb21PSitqaFVL?=
 =?utf-8?B?dW1KdjZFc0VaTEo3bmV4SFJRQlpsZWJaRldOcTRnSk8wR0FkRnQydGRtRXNP?=
 =?utf-8?B?M1o3UlhCeG5WNzZXbDZQcjh0ak1iTnFPZE8wUlRuUUQ4MCs1KzlMRUZxb0Ni?=
 =?utf-8?B?a0xZd3lsVE9QNnBJVS85emtoWDd2Z3F1QXdnLzRubnJ6UUMwd1lLTXkzcU93?=
 =?utf-8?B?NGsvV0pmaUpraHdWZVE4ZExEZ2hBdmxmZERUZk9nM25qK2toUkNkbmVHODd3?=
 =?utf-8?B?MVAxQ3FHSFNYdjlzdUpjOFBZTXZhR0hNeGNBVzlLUUFRaHI3bnJFSFB4a2F2?=
 =?utf-8?B?cUZLOTNNWDNqRkdHbFAwNUdHMm0wNWwxYlJ1U0VGdmt5dGZBYWRvYmF2RHdB?=
 =?utf-8?B?Rk16VHlHSVBiU0QweWdSWjc3SWxIQXE5bG1yc2ltREJRSVAwWUxQRWFrMWJn?=
 =?utf-8?B?eEFGQmlCNE5nNXU2TUQrMExHSklXMUpMTkw1V3BTMStPcUl6MHlRZWlXbm1s?=
 =?utf-8?B?SGpxUE4rZWJYNmtZVjVHRHRZZnl2TlZoUnVmcXlZZmxUVUxQWTNZMndWOFN3?=
 =?utf-8?B?UjhmbHEwelYrTG8venB3NXdNS3F5R2VQY0xaSzlFUmxBZHNoUHFQRXhuSTJx?=
 =?utf-8?B?NjdmTDhwVE42N2lqbHV4dmxxSE5hUnhFTWdqOFpRZHp6UmNmYnFUUXdhYUtG?=
 =?utf-8?B?WTJHaUNEaWhoNjNaeHBxNU5STTZINHgyWG5rdHdhdU80Tmc4bldjMDQ0a25W?=
 =?utf-8?B?RFhoZzBXdzNhVG1vMHlvUHdJK2ZkazQ3SlhleThlb0h0cU1hU1V5RWJhTjRW?=
 =?utf-8?B?dnAwck8xT2lmQmlOeHg1Qzd4M04zTVNFU29TOEdJWlBuYzRlWFJmcHl5V0wz?=
 =?utf-8?B?NFlFQTBqVDBhcWNabmkvT254VWwvOXYwSC93MTNjVldhRmZFcjdrdDNud3k1?=
 =?utf-8?B?NlUyL1h1OU9pbjRlMkhiMU90RnhZNWNlamVCYVIxbWxuc1grc1J2T0p2WWEy?=
 =?utf-8?B?R2hpY3pGdzZrRzExZUpQTFBlb2lWYjdscFBKUmtUbERiU0RlRERwSEd1azB6?=
 =?utf-8?B?TGxHVEFYcUhvVFR1K2pNSzdYbTBBZkZuM3R0bGhKU01Tc0JCMDZjSWthcElr?=
 =?utf-8?B?L2dnT00zNFRDSXM4K05xSFhQKzNNVWdnU0cxN3V1dW9LL25GQVNHY2lnWEtL?=
 =?utf-8?B?Q0IxbUFidmVJSWpLYWpZWFMzNmd4L0RrSnk0WFAvMzNlczRUZFZXY3c2eHk0?=
 =?utf-8?B?dkIwL1ozK3FwZ0FTY3Mwakp2L0o4eWFVUHI1MjFSZHBWSnE5YlM0d1Vvbnls?=
 =?utf-8?B?bnJ4dzhTZjNFTVJwU3ZXNGdXWlVkYXlXM1k0VGdOeVdBa2VmeVlSbWhDYVBI?=
 =?utf-8?B?WGdvNkl5TkVQY1dUL2FOUUZFSGl3R1hSV3dZVndFaFJNOHBSbzVXc3ZnVDNN?=
 =?utf-8?B?MXFsQUI0elpVd0xnL2hpZ0J3K3pnUVB6cHpyaktjcEYrQXM5aXdMRnA5a2RP?=
 =?utf-8?B?MDYzV3Bxd0dPU09JY2E4bVRZWTA5czFHb1M1MVF0S3JtVWtjZkZjVXpMV2oz?=
 =?utf-8?B?V1pHZkt4MitBQU5sYi85eXFKL2FyR0gzbE5yemtmdVhUYitSTENDT2R4ME82?=
 =?utf-8?B?bWRwRWlCcERhVmFJQmpDYTV6SVNaSmRpVmxWcTlsTFNqUEpPQWROY0pQQ2tY?=
 =?utf-8?B?ek5EVVlVR2NQSEFBQlNkSk5HU21LdHNPVCtkSWN5MWNkTHdtN3I1TGFwWHNx?=
 =?utf-8?B?K29YZnV0UTVUKy9vczkyZlJ3UlhPc2ZwUHdHWExGNE42djVaVlp6QT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1575383-5b0f-4716-5bc7-08dea8916319
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2026 21:25:52.2931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8a8EorpQN3IO5tRHDtc/mxFr8gtMojc4N2CnUot0XFXoWNbLmCAmDJLs49UIJMX1c1XWAah9KUqT7HsmDJUyjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3857

--llp35ou3kozi5xin
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v12 10/13] blk-mq: use hk cpus only when
 isolcpus=io_queue is enabled
MIME-Version: 1.0

On Wed, Apr 22, 2026 at 02:52:12PM -0400, Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
> +static void blk_mq_map_fallback(struct blk_mq_queue_map *qmap)
> +{
> +	unsigned int cpu;
> +
> +	/*
> +	 * Map all CPUs to the first hctx to ensure at least one online
> +	 * CPU is serving it.
> +	 */
> +	for_each_possible_cpu(cpu)
> +		qmap->mq_map[cpu] =3D 0;
> +}

I suspect we should use 'qmap->mq_map[cpu] =3D qmap->queue_offset' to respe=
ct
the specified map's boundaries. For instance, secondary maps may not start
at zero.

>  void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
>  {
> -	const struct cpumask *masks;
> +	struct cpumask *masks __free(kfree) =3D NULL;
> +	const struct cpumask *constraint;
>  	unsigned int queue, cpu, nr_masks;
> +	cpumask_var_t active_hctx;

[ ... ]

> +	/* Map CPUs to the hardware contexts (hctx) */
> +	masks =3D group_mask_cpus_evenly(qmap->nr_queues, constraint, &nr_masks=
);
> +	if (!masks)
> +		goto free_fallback;

According to Documentation/dev-tools/checkpatch.rst, pointers with the
'__free' attribute should be declared at the place of use and
initialisation. However, I suspect we should not use traditional goto error
unwinding with scope-based cleanups in the same function. I propose we drop
the use of __free and free 'masks' during the success code path.

>  	for (queue =3D 0; queue < qmap->nr_queues; queue++) {
> -		for_each_cpu(cpu, &masks[queue % nr_masks])
> +		unsigned int idx =3D (qmap->queue_offset + queue) % nr_masks;
> +
> +		for_each_cpu(cpu, &masks[idx]) {
>  			qmap->mq_map[cpu] =3D qmap->queue_offset + queue;
> +
> +			if (cpu_online(cpu))
> +				cpumask_set_cpu(queue, active_hctx);
> +		}
>  	}

[ ... ]

> +
> +	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
> +	queue =3D cpumask_first(active_hctx);
> +	for_each_cpu_andnot(cpu, cpu_possible_mask, constraint) {
> +		qmap->mq_map[cpu] =3D qmap->queue_offset + queue;
> +		queue =3D cpumask_next_wrap(queue, active_hctx);
> +	}
> +
> +	if (!blk_mq_validate(qmap, active_hctx))
> +		goto free_fallback;
> +

There is a potential out-of-bounds write vulnerability here.

The variable active_hctx (of type cpumask_var_t), after the call
zalloc_cpumask_var(), the Linux kernel would have allocated exactly enough
bits to represent the number of CPUs the system is configured to support
(nr_cpumask_bits). For example, nr_cpumask_bits could be set to 16.

Now, in the above loop, we are using active_hctx to track hardware queues
(qmap->nr_queues), passing queue as the index into cpumask_set_cpu().

A modern, high-end NVMe drive can expose 128 hardware queues.
If we plug that drive into a machine with only 16 CPUs:

    1.  zalloc_cpumask_var() allocates 16 bits (perhaps rounded up to a
        standard word/slab size).

    2.  The loop iterates up to queue =3D 127.

    3.  cpumask_set_cpu(127, active_hctx) blindly writes to the 127th bit,
        drastically overshooting the allocated memory and corrupting
        adjacent slab memory in the kernel heap.

Because active_hctx is tracking hardware queues and not CPUs, we must not
use the cpumask API. Instead, switch it to the kernel's standard bitmap
API so the exact bit-length based on qmap->nr_queues can be dynamically
allocated.

Additionally, if all CPUs in the generated masks happen to be offline, the
bitmap will be empty. In that scenario, the bit-finding function will
return the size of the array, causing the unassigned CPU loop to map those
CPUs out-of-bounds. Checking if the bitmap is empty before that loop would
prevent this.

I will address the above in the next series iteration.


Kind regards,
--=20
Aaron Tomlin

--llp35ou3kozi5xin
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmn2a9UACgkQ4t6WWBnM
d9bD8Q/+OO0PyVcAtVbZlLAvtxiraHfbmws9c6C+3m1Hnpv0AI5I2S3MT4hpyXzu
CU6v+QHfWw1+clBm2plqfQRDiHfl0lAtjXVCBmNd5bPxrwL8iqKneS/w9yhihQNh
hrj2gGJbt/YD8odiyZ8md74PofdtpWZg46pyRPoz4e/UQd7iY9vj3Qxp/xqyIVqV
/hh0p8fKfGa+UdMJsgk2kpvYFdSMNa13DgUTJSShJr5fX36rYBj8CypdmEa9Nh37
OpokwAlpSI+gFYLEpNeAxvNqJDgchkq7E7uRki59gY1M7VLi8r8uRzAnEOcwKRxD
9JjF3pX5SUc3t4+sQYmo2zEhe5kPR+Gw6162HjUbSFTc7YzQ0LenuTeHorkVemTq
LXztV9uItfHDiYF0pWbEmFGz3G3xQnlZEXqp+A3itydpaTIGYkp7PwFBR8r4yAQC
Wb8HIzR/gjKJkCCwkgBPOoU2IaOsfZaoyiSYhbMre6pEtEkjRTibR9MEidLjMeRN
y0OVVSg9eblrBownwr1ZTjigQvtplu4Q1L5K6t7wISie79KO/oRS+VCNL/6EhCfL
PdAgwENuy9iLottAjKwsYlxjfjgRi/BV5jIXYuuVmeazotaKzpmngn+hKvuRAL1S
AfreKUwsWQ3OWknrRiCUyshqPhkCFqCq++kvq1wmLw7GZPeT2nw=
=1G8j
-----END PGP SIGNATURE-----

--llp35ou3kozi5xin--
