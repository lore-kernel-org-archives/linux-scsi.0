Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021135.outbound.protection.outlook.com [52.101.100.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0112EF67A;
	Sun,  5 Apr 2026 23:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775430587; cv=fail; b=ewqv3ZpTmWfVlxZFAyXCUh4NEJm+KOUKVLKunTXQA6iSyKSb195NKy2mcKklTP/wZ27vyByutujiQJOuujwWGCNg6+YTNB3l6moMSwHiTDJAEVfL2A4G/32Y173fXuKoEX6MR8+aQ2CGiTY3IEfuACWBzBfjNAStSnd4ntwAqbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775430587; c=relaxed/simple;
	bh=ea5xP7BmMsdVTATyPd+iFkkSS3rK56Qexr6MznCjXhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jNhw2p+w0A+7xsFbmB2Jkf8K+kmftdDzblQ4AIcpHlfeh3eUjUzLGpnMvh/Nt3rHGq/uwDJn63GyHSglEjOPXimlvErFvA4W47/Ohsoi+Z7i53PAWzo3BLBcyJtNrB/sRjVNT8PbKesZJLXpTw54zZNwpoxzCGK0eMtMxZmTcwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=raDpZ3BmK4m1JOCCJPFrYUlzhJN9ayRFUzRw3dSoq4AxPC2RZ708R0+DuUJe2B+ioaFjOyimDlpVMhe05NZdIw21HfdxEofClYInac4FB750W9vn35EkgUKynZBEGutGAdSDrM8U0ra2AUel5PTiw+ucynDqx3qNfsCxd/rzmhvI1snAwDQundCYN9R3YFAGo2pRxXfeIWdT9pxI5+0MooCmtUcHMr0VJfczlQN7Mpwe1H42lKGCh7NW1DXtal308KNtsHd/qtD0pvD2Gn33U0O+SmsWazRhkMrZvDaY+loEa0olyJDROy4S1sEZ1vObfeSdxM6FBoPwaGf7bGOj9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ge872syXSbs5+S1lwvwTWP6d9BfEbYubRd2a1lZ6/JY=;
 b=c6mGiZIlSi0wx0gc8o+j+PA8W5FGNJP/NYLVhRnnruG8HQJViMHTHaZvwXpW2K0gI0LqI8we0ADr9arvPUtSndNc/CJIm6nIuI+belvpjOBMdoXg8+F2FDTPncghtTMgT6VTnh8tmcInAnw6x5xyz9FSH+EKfbIxP/pYOhoWg3PqHI4A0hIB5evI4SgwWDFPxVla5YRi1kSgxWsOzgyI8UAlcx2DSCpam/H/Ut7WInn3MAvjYWbbJyU1h9R/WwjIMqijT1IWOkp+InWoQxqyqGCjRm1StZGpZOZRMU44JJd/WDFRr3Oy0jNh/BRx6Sd1ikHAP+gEbypSQ+xrPdUYqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO8P123MB7746.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:3d8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Sun, 5 Apr
 2026 23:09:43 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Sun, 5 Apr 2026
 23:09:42 +0000
Date: Sun, 5 Apr 2026 19:09:36 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Waiman Long <longman@redhat.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	mst@redhat.com, aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, 
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, 
	chenridong@huawei.com, hare@suse.de, kch@nvidia.com, ming.lei@redhat.com, 
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 10/13] blk-mq: use hk cpus only when
 isolcpus=io_queue is enabled
Message-ID: <3arv4h74lojkgaxtt32yda7m5tl53ukx6jpyad3d4jipwjpcrd@bkmirs7jgjjv>
References: <20260401222312.772334-1-atomlin@atomlin.com>
 <20260401222312.772334-11-atomlin@atomlin.com>
 <c6189740-b741-41e5-a9f6-d09e1ddb86ec@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xwhxqp3rfibw6dmg"
Content-Disposition: inline
In-Reply-To: <c6189740-b741-41e5-a9f6-d09e1ddb86ec@redhat.com>
X-ClientProxiedBy: BN0PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:408:143::6) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO8P123MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 3013fc6e-354b-4502-35d8-08de93686a48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6q2H+eyiRpy63a1RkLuZq/twJwOLEnQv5L+m47JPXX/Bq9SoPeAVsgLN4EB2xHaZSMPIudFnlj+X9BF9viYp5rEDxmqed5J+TZxlvgpifVsf4V1VWDn+EhI3/lCGiC6pKpoOzqhVtFZNj+WG5VfkQC9zAE1pqTvrdG06a0udGUk8nwW3HxEkaJQFACIKAhYf+ohEgHopo72WM8F3JrVVnxEeEYtrcfx6fPVL7dxbrVkOf4KtLE43Ic9co3vEkd/Bqq4PnvytjQWtUnhxWLl3G/rXZBO+8+dj+gvxofR9zy3oVbAF9PYn+sTSHKnYtXPxdpxV/XigIVPgAtkD1dNXpVLDzCc+904Cso4LAVMTkMrAcN1Ry/BjKE1eCXjepzRM/ZeyHK033mzDPvKz7A+Fo3fcjFdwrTSy1CGrz3y4/x1V1T8yL22izjXCTx0ojypZkwAuNE2pylwFtDj4YLV7c83wwj8WfIjdbZNwcS6KjsZmstrlHi02IuVnqkuXGNxWYN3/T1Fkb2i+t0/LT4ckRp0TdORL8vCEcHDrHpU7ezFRHYsppFsnjyBMJvItZyvrQwj6/g6wFr2ITXyznZjL9cqNskkL4MU8xoPc4mJR3aYc2/ZYEBHY18PCFtIdSwiclDUImVj3yhTUV6411ilEc4+9xXB2H8iO8TpcW+0UWSfL1cHvaXSM+m/NswK3Roqp6e4pb6P3F55zsNbunmjpHvukZe+ee73t6bvXkCsDzrM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VkpoeDZWSjhuSzcxeHdGOHBIR1lCV3owTzBPS3doQ2NSR1ZwbkxkOVRiVzFu?=
 =?utf-8?B?TWFmN01vWmg4VXFjdDZDa3Z0RTlqMElYUXJHNmx5YXhQTXp5Uys4a3kzb2VR?=
 =?utf-8?B?aDJxeE5NbGFjSk9rOFJiV0EvVTJFSnJhNzV0MUhuNUNQMXBuY1dMWDBLeFNu?=
 =?utf-8?B?Y29ZWVV4R2pPOWtQd2cxTDZHQ3dJeE94R1NKanV5cEw0d1lkTDhhczBhQTZr?=
 =?utf-8?B?ZEFrMXpqbVhuM2d3WFZYYTVBN0dBL1JEZ2t2THo3YVhmUmg0NC9ZWit6WU4y?=
 =?utf-8?B?N2x5bzJ0S2J1cjQ0YVh6eW9yZjNqSHh1MUtMVDk4SWJDMFdZa0djRVFkeDlm?=
 =?utf-8?B?SkpwL21HV3lDUkpuREJaSTU3RFRYZUVIV1J4eC9VRG5iQk5iWkhROUpRZmRN?=
 =?utf-8?B?TDNhWGtrYkhsMTUzV1lRKzVYdEwrVFFRRWt6d3NsS0hyTU9DamZUcUVubUt4?=
 =?utf-8?B?T2ZOeFQrckxUVFJpOGVUUmY5OWQvYnB0UUJVaGVNSmFQQldtSDVaUG1ocnpY?=
 =?utf-8?B?Ni9LTXoraEhQa2lDRzVVdDUvNy8xdCt0OUhqMXpHcThZNFExSXpzejNlNlVO?=
 =?utf-8?B?M3lySGxHK1g5Q01OZGpWK2wyVkZyQ3ZsVWhjMnd0NTdqWWJkTkdlUldUNEln?=
 =?utf-8?B?UXhCc09IUVpZZS81aXRVNUFrMzNJMmcwQVJHekU1YThVRmNhT25nOUx4ang0?=
 =?utf-8?B?cjVicHNLaDhsalZERWRYVTZTYm5MU1VMUWl2a2hmNmdQckZNREhERVljMkxW?=
 =?utf-8?B?UGpQWW5INGhVMVZEMnA0eERCcTJ2NHVIa0d5alhRamRSZGxFUEZBSTNQNGNq?=
 =?utf-8?B?TkFZWVBkaGhzTHcwQkNHSWxnZ09GemxjN1loSUkzU2FjQUM1LzA1bVhKdWQv?=
 =?utf-8?B?Um9ZTHRDQ1BVbm1YcUx0OFlNVnk4b0dyTkliS2NqWFNldEtpamdSR0FPYXV2?=
 =?utf-8?B?M1Z4SnBrV3lqd29WWVU3UEdNKzBlcm1ORjRadjRjNE4yRnZSbHFFRkxTRDNv?=
 =?utf-8?B?Mzl2MFNIWkN4YUluVGRieUM4NGp1QytZQ2pOSUJNMlhVNGNIQ1g2Si9yVmpa?=
 =?utf-8?B?bmRnNFBOWUtaeThXVm01aXJ0OEx6T1ZJaFZ4RzBRdHJGeENzbzNQUWR5YVdi?=
 =?utf-8?B?bzJJcWdxMUd0ZHJ1Y3JvRkRSMDJsWjd3eG5RWHpCbm5aYU1xaGE4YitGVnNt?=
 =?utf-8?B?RUJ5MWppRmlLZkNqWXIvQ3FiM3k0V2tYeWpic1pZeFVHT3Uyak81K1k3MVBt?=
 =?utf-8?B?eXZhbHFnRzJJNVVBb0pHZGhYTFFzR0VES0FRQXRQdTkvckJnMU5OTzdQeGcx?=
 =?utf-8?B?UmJMblVVT01hazVZQWJyOFVjcGY5Y1FDVVY5OXl1bGRVZTh4d1BnZjhlSXQr?=
 =?utf-8?B?d29LSWV4SlMvRVNuVkROVWdERmZOZFN0bmdoK0dmS2VyOHhodE0zSDU4Nlo4?=
 =?utf-8?B?Y3ViNlRERldYMWtzd21hVGorWHNSNnUySHhJajNNcDl4TXFxUlA0SzVlMkZF?=
 =?utf-8?B?KzNRWWNSTmtQWjZSNnVET0c0cTlJb2VpV2NNNUVCRm1ydWh5OEx6Z1JyejdZ?=
 =?utf-8?B?dXQ0eWJFd1BhWEp6amEwbVhhQmF4ZlZENU9Lb1BldDUyOGdEdGtQYU0weW1k?=
 =?utf-8?B?L0NHMVVVcVMxV1plNGNneWhMdkFYd0ZuaFZNemNLdVA1SUp3T3ZPMjRndHFV?=
 =?utf-8?B?cXNSWi8wL0hJU080WGlwd05pZk9MTllzcTZkTGxhU2JlYVZTd2h6WXdpTldC?=
 =?utf-8?B?b1c0VlJmeEhHMG1LSGpTTGR6azdiUlZ1OXFrc3QxN05hdXdld3RWK2JNQkxV?=
 =?utf-8?B?Q1RGU3RtbUErUURuZm5FNk5uMEJZemlWczlWQzdXWjBHRlZRSnhmOHI3OUFC?=
 =?utf-8?B?OVdTOEJEK2ZUYnZFZkdrNWJQZHFpaXJ3SE5ZV1JjNVVvdWxESlk3TG1FVnl5?=
 =?utf-8?B?MmY2dklEMDlIbDJWKzliSVh5Rys2UllvWHN6MHhDbnJ2VkVaY2o0cHlvczVQ?=
 =?utf-8?B?aFlwWDU4QlVDSEdqQWt6UjdvWVFQelZhRWNOQ3EyRTdvVTE5THNpSmFXdmVm?=
 =?utf-8?B?azNLSHVNcy9IZkJjWHcyb095aTd2QnhTVkJvSll6a3ZSQmFSVEtTVEV1cEFL?=
 =?utf-8?B?RzYvYVlFUDV4c29OR0xzK3VMU2xZeEs0RGppL0RYWUl3bEs0NU84ckM2UGRk?=
 =?utf-8?B?bSs3Q3h1NjVxUXlQaFRNbFhUeldGdjhCc1doSHl6NG0wMG92UG0xYng2b243?=
 =?utf-8?B?NzdKdUQvL0MrNUhTTTlZQm5HSGJ5blRKZmhUNmVJNkJ4Tk9ab3ZQZU9DM2s4?=
 =?utf-8?B?d0krSlQ0ekJiN2c5U0ZQQzhyb0F4SmdMNmFXN1ViWVFTdFozMzZIUT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3013fc6e-354b-4502-35d8-08de93686a48
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2026 23:09:42.5752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEFtsVv7ijb6rKUCtyYFs7p4g5m8cqBxvfgYUn7wyrE0lIkgBOuVGHv6zLqXpBlaFrsUyNWb475PoShtl/kyaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO8P123MB7746

--xwhxqp3rfibw6dmg
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 10/13] blk-mq: use hk cpus only when
 isolcpus=io_queue is enabled
MIME-Version: 1.0

On Thu, Apr 02, 2026 at 10:06:51PM -0400, Waiman Long wrote:
> > diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> > index 8244ecf87835..8d09af49a142 100644
> > --- a/block/blk-mq-cpumap.c
> > +++ b/block/blk-mq-cpumap.c
> > @@ -22,7 +22,18 @@ static unsigned int blk_mq_num_queues(const struct c=
pumask *mask,
> >   {
> >   	unsigned int num;
> > -	num =3D cpumask_weight(mask);
> > +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> > +		const struct cpumask *hk_mask;
> > +		struct cpumask avail_mask;
> > +
> > +		hk_mask =3D housekeeping_cpumask(HK_TYPE_IO_QUEUE);
> > +		cpumask_and(&avail_mask, mask, hk_mask);
> > +
> > +		num =3D cpumask_weight(&avail_mask);
>=20
> As said before by Ming Lei, struct cpumask can be rather big in size if
> NR_CPUS is large. I will suggest using cpumask_weight_and() instead which
> will eliminate the need of the local variables.

Hi Longman,

I agree. Also, it perfectly circumvents the need for the temporary local
mask while achieving the exact same intersection count.

Kind regards,
--=20
Aaron Tomlin

--xwhxqp3rfibw6dmg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnS66YACgkQ4t6WWBnM
d9YPqRAAoFcUNHyWdvDMJCO8dOPI9polAhlnfh4VhKeJb/KEtkukH+nZLzDEQWUj
pvZXRU5qbUiICDMs5nFqy4XJIlcWZyYn8J+w9KxC4m0TI5HR99LWyr99raQdH2by
ec0NYJWpCmcoqZjX0a5RZlCHjlF3SnC/zdZLCh4eZdGnzY+A6VvSXYJH0c0DpK/Y
dLurxUtqdvs4ARHp6P4CLIScbiV2byudKewCqGDTMCDQmF1h5FVADF9Cm/nmshI7
XN+nKehr7QT04LtaddMhtb54lN5n8FCKSunym9jFfaCJ9z9fL7YWnXsb27BF5oGw
fdxxRgcC3nd8DeK9HtDK5CoTjl6cvcFvhDRij41v+GBD1GxR56+6dEzwJr4YAZIj
u1m3jq5ZhALc3acLww6VOAtpMTDZWk6f692k6iLWotuR7vFXFO+JewhmisAv3OT2
jzmaRJoKJhYBggjXn7S/c5Zx5bPbdvDQHJiMSC4MPrL2ZjKf6fyg3+KiX+VyCL2A
m2yXox2A/2ETKMVQ6apVfzFTsCgZyitSCwIREp3SjCYbQZz6a4bfrlDU+g0eU9Cq
O4KFcp2qXdSUjXpZA6WID5pFEDOXbuGUjYE/62/dzCj8VzWcgXSgAx1qdzsLYUWO
3xW8DVoY1jGnBJX0LccMmn6fLS6K6p2xguYkVcK2Mfpbsb5TGn0=
=Xxni
-----END PGP SIGNATURE-----

--xwhxqp3rfibw6dmg--
