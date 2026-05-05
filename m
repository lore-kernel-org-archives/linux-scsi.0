Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022111.outbound.protection.outlook.com [52.101.96.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC9333B96B;
	Tue,  5 May 2026 20:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778014553; cv=fail; b=u2pZk4qgQemc+pn0jm7zqH9Xks47nxt1WmCgTGdb86b+ehy2I/CNa6SnBmGKvw79CxUH5OlT3JFN+sCi6JhYUHvPMEW021flInIISHhWLdTpqJY19z6ihC/45kyLA4AV5v374H1eFYF3PhP4hXMp/N689OedHtdWlcG45HT0HYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778014553; c=relaxed/simple;
	bh=41fFYxnLgZ1eeOZDJjYNGpWdDN1gJdyw/DHC3XV3OcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ud5uUrHC3d2TrdBNTBBLtCygRYQ0oZhcrKmS8OFX4gOekaYJ0axpCnfLo9Vi0o0ndoUF+jT1RoOGC50QaxcxLNyxwG2LI0q8suqHS343KsGw2kvgSixOtyZGIlZI9LXAWmZieo24SAYjprxJSc9NDFShZI+LfddyD7pr9sDzMKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsMZ6aOOVo21kopy+9k9OVXyNRhtUKSlVDNmPLkDVai38+2Aom7+jz46jQJI/CueqOvE1ihNbax8ZoXBpPhAbaxAIjR+huSqR/ZBfLjCU/+nkOst7dK2Knfsw6e9Q/MtO/Fx3XAJeCW0mGu/S5DSgwEicKVYGEFMuoML8ag5l4t/t1woS8Xd41mURU37eqptxl88Yfz3Ob57HJ+23lnXo+xmMejde9dEeWKmVPhSJ+uuu/ZCiOe/JXrUWoH351xtYJwRQMwkClJMGbBvZWwHw/VMKSIddf3jOhVmPW7TbroLFboJ0Ifwigx6PVeZo26qArlnPMJLFWsJipV4uA9JGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41fFYxnLgZ1eeOZDJjYNGpWdDN1gJdyw/DHC3XV3OcM=;
 b=tnLp4qxXZ4Y6AZrIXovBzioSZOr6eUY6iFtxolRlmHOGq0w5+9UnfNVNRuQWOSh86+tLS5A2HJyz/y4SOJIzZ6Ggpk9zQ5a7IuWC8fuH82ofRF+SXzVz7YNFFErJAONySBVxbiRDPE+WKRCs6Qp0kpiqo3xE9duZT3xxaPybDLuurvw35rlxWtZj/7QASmlMxD3aZYTeZWpWqqmgzmDpmEeDqTGU/rCUCzDgNixheirDmhGDIKAcgvqe5dWSuoWCFNgB2kU3GaphZB6TbksSmgixA/OG8VLekwmGwAE2eVWgQZ/6UvceHxSZQ9EoOTguIA9hH0Iu1l2eXbFLyN4XbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO4P123MB6927.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:349::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Tue, 5 May
 2026 20:55:47 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.025; Tue, 5 May 2026
 20:55:47 +0000
Date: Tue, 5 May 2026 16:55:44 -0400
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
	tom.leiming@gmail.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, nick.lange@gmail.com, marco.crivellari@suse.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v12 05/13] blk-mq: add
 blk_mq_{online|possible}_queue_affinity
Message-ID: <upzho73gttte7bb2lggvrugugsypfdoyjrfhpwfs6sthpfvu3p@b7s42t53qtzt>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-6-atomlin@atomlin.com>
 <20260427153416.MeVS8yxF@linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qbww2g5iwecbyeqm"
Content-Disposition: inline
In-Reply-To: <20260427153416.MeVS8yxF@linutronix.de>
X-ClientProxiedBy: MN2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:208:23c::34) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO4P123MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dea50f2-0fa9-4d60-42d1-08deaae8aedd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LATExl51SG5MNplBOPyW0huwjzALO6QAlOl2GLpwt+7F3tJaMQKKtLbX5JlWzg9YJRqVzpzmbrCUwxYjSEv/7xTxuEf8l/qCctZDdmKAZ0DmFt6rm+UGFD1DLmk5NODqFuK6/1lpXubfVUuOaKfiDDL9m0U//EJrwz4Z0+w0XiZcgxok5K9AO58GmlFW7Tj1pNLeg8+Tz5hyRouxOfaPjyO1z6BXQBPYyjFpvmc8bZUODwWHIwzKDmU5z1byzL8Hrt+ssftD3mRvIWISegxNLbnTieDJ5uPp7zxNBDswMygC3fSAf7tPLhh4lq9GywcghBmz4V8LUI2JNSBDuSveFECb7kM0OlUUYEvg6+GPAtbnlwqI4TPoNM9m8ZLWbT+najV760JxRtv756QoNFFtCOKkTBRHL/NJVasxevHjpMgsDviJohjB9HYmXoeZbbKlpZH528+IUyMy5bqkNwvdKhfNOh3ZZDWZteVOeWeTQHivN93u2KI+OaAVdgI9FbfMxTM9YkjFvBpZs/xN/P+AQB5ZEI1lHR5blKfRmEf9RTD5+qy42Ch2YlRtMS8JQlU95S2+b+n6LiH539fOs61NZYjoghaqYogvz7cObzuPNndFVpQQuUJMe5tCISg2Xxzbu/3EyhmZUyAEUELyqsmFt5yt0jM2yhJiHHw/nyQEji//J4LI3TMaf+HqTDB5k76xKKIQwsBImQ89ZDeuP6gzfg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmN4TmxtVWR5Ry9CY0tabGJQQ2FPcXlwRkZCTCtEOEJEekJRVVQ2YTNtWTBJ?=
 =?utf-8?B?blpiVzViOWN6WU9KMVFjZW43dUpDYlhFN2dsNlZaU0ZuNm1MdVZkbXd6cHd6?=
 =?utf-8?B?enpMMU9DazA3VXBSQjlxWUtmdHNDcHlrcTIrbHZHaGlkRXhHNWh6ZnRFc0U0?=
 =?utf-8?B?NmpUQW9iL1RsUnl2cm5uRWd2OTd2MnF4VTJmYjRYMi9TQktXVURyMnRtWVlS?=
 =?utf-8?B?S2lydnRlZ1BabG9rZ0Q1eDEwaWRzVmcyTDZ4SlI4bVM3eDZ5cjQ2RzA2WEdT?=
 =?utf-8?B?VWdvSXB6N0cxb2ZENmNVa3B2M3JJanZMWm81R2gxWG0zS0ZhYkE0MDFkTHFj?=
 =?utf-8?B?b1JsYkRjc2ZObDh0NHdyNS83TDBsOEUxMHR5VXJNVHZaQkRHSGZMRjNtNHVh?=
 =?utf-8?B?amlKWWJ5NDh5VGZPQkNWbUdRaUN5L2ZBUGlUak5ZZjFYSTJscnBjQ0V3QU10?=
 =?utf-8?B?K00xL2xmd3laWWg3R1pFNWdhT2JpdTNIdVRMSFFDSHlQajRaM2RMQlBudmlN?=
 =?utf-8?B?WDZudHk4NkFPU1R3UE0zZithWklEZXlqcEE3c01POGxEQUtxblNpUTdnTk9h?=
 =?utf-8?B?RHp2SGRKMmhNQ2krWXhsL20vT2RkT0NERzJPUVhSZzQvTDN1UFFtYUE5YjJX?=
 =?utf-8?B?Wk1MbXV0RVhwTE5scFNrWGxvL0xpRWxJMW93T1ZnVUtQMWVyRDhiYmNGRThH?=
 =?utf-8?B?MlpiRVJLejZXbGpCM2t1WXI3eUpMOGdVODJOTFdwQWF3VmpPWFcrNmpQdmVl?=
 =?utf-8?B?Y3NjTGxrcU54MmZFbktqNnVPZGtnSEZ5MWRiSW5UNGVscEJoMUxPV3pjSlMz?=
 =?utf-8?B?TUZCc2hXVUg2enRGR0pad1lJTmJyS2ZMMkRHaVdlRWFsMVZ4QXBLRGlIZHRM?=
 =?utf-8?B?U3JpWFBGRjlFTlBNenJHbGhMTVNUeHBTcXBQcXp6L0RtRVFjNFZwRUVlUDZF?=
 =?utf-8?B?UFFTWG5JWWFkZTlSekJaZnk5Yk1FaXNJeVZDZTJURkxFdXB5eFA5ZzNPQXZI?=
 =?utf-8?B?M1AwNjlZQzQzNWd2aG85Z1RISDlFNnE4Q2w4WlA4MGpiV0MrQXI5bXUxQm5U?=
 =?utf-8?B?QUpVYUhyR2hDUVBTRHYvV09jd2RVUG9SNDBOMVJVVUFrZzllZVVVdEEvcnhK?=
 =?utf-8?B?MmRUaXY5Rk9RWWtnWHY1djVUZ214Q3c1SlIvN1NnU0piSnJsUmZkNVNOamFU?=
 =?utf-8?B?QzAyWFlnRlcxSVNsc0JjTDFzbUVBS29tL1ErUVArZEV5ODM4SXNxem5vUWNX?=
 =?utf-8?B?MGZTRUM5UnpUUEV2MEQrUmplRy93dGgyWGxER3VSc2EvNTRzNmlySi8wTmtB?=
 =?utf-8?B?MllMV2FVMmlVaytWQnZ1aXplemxneDBWWW5KV0g3b1VSYkhZUGFEZGpPTjRN?=
 =?utf-8?B?NXpHUmNzQ3pFOUZINzlpWUJCRUJoSU8wQ1F0RkZ3aWNaTTJKTi8yNmZYSFRE?=
 =?utf-8?B?RURuNjFQa3FOM0t2Mk14QmY0TElUQm5jMGNOOEJUOTY2bUdPQk9hOEZsbGY3?=
 =?utf-8?B?Ukl1TU03bXFHWSsrb3FScDMzY091Q09yV3pSekc2YVlQeE0rb01kNXNWNjE5?=
 =?utf-8?B?WGYrMmpvRDRXRVpqeE8yazZPZlE5TjBpVHY2MWNxa01PYU0xTkd1cERKY2Fz?=
 =?utf-8?B?VTl4c2hCQjI3REM0L3YyelIvNEFHQldsTkFDNTJSUk9aekNxYStUTWowbnZ4?=
 =?utf-8?B?dHZ3MFJVbGdhV3hiRlZ4cmFvMm56c1JlSVJmbFh2SnhiVVV2QVgxeVJaQWtX?=
 =?utf-8?B?SHhLVzRJcEZ4THRQVXhuS05mSFZ6cC9XOUNwUldYQzBDU0V0bUdBSG1sRmF0?=
 =?utf-8?B?SzE2OEVJK0N0cEhFdGdVcW5hWlg3VE83cGdNNy9pa2FGQVdKOUpMU3RXUG4v?=
 =?utf-8?B?amJrT0lBYjZxajFoamRuNzNPZ1pVOVJVNkpGS1c2T2lobUgyakhFd1pqb0hj?=
 =?utf-8?B?ZG9EQmVJNkZUbXFkeXQrcXFsMHpjMUcxVWRvdnQrSnpzUGlwRTRCSkcyWGpE?=
 =?utf-8?B?WFBGOFFFQmJOcE03VktTR3hyNHhqbVhNL0t1WC9xSDRhR1A2clhxdzExMTkz?=
 =?utf-8?B?Y3YzdG9UalFWeUJVNnRjUytFbVhVYTFCeEhncnpuWEI5eVducGZpNENCYmhK?=
 =?utf-8?B?b0NoMmpadzR1azUvRmVFZ21ubi9XT3ZvME5USnlpd0dYZldaNFBmRktCOEJl?=
 =?utf-8?B?QTVzUWFLbFQ5MVd2MWwvSVM0VEJQWFFHTGR6R05TZDNjTVdsTFdGWUg5b3BI?=
 =?utf-8?B?RjUwaGpiSnRVVEFORXk5ZU0yWm9ZMFcweks3d0Y1eDZRYTE5d3dpZzhuY2Ri?=
 =?utf-8?B?Zkl4WTdkTEdrSFlQTzVjaENGQ2xIVWcyT1F0OFgvZzlVc3pNa056QT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dea50f2-0fa9-4d60-42d1-08deaae8aedd
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 20:55:47.8028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BsHZ3hkIfsP9A2u8xiS4xGEdP5aST2EYmglCif8SJ2AEWqWz3L+YWXX57KXxgkKISwB1SQ6T6p8rb4gNbJKw9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P123MB6927

--qbww2g5iwecbyeqm
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v12 05/13] blk-mq: add
 blk_mq_{online|possible}_queue_affinity
MIME-Version: 1.0

On Mon, Apr 27, 2026 at 05:34:16PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-04-22 14:52:07 [-0400], Aaron Tomlin wrote:
> > From: Daniel Wagner <wagi@kernel.org>
> >=20
> > Introduce blk_mq_{online|possible}_queue_affinity, which returns the
> > queue-to-CPU mapping constraints defined by the block layer. This allows
> > other subsystems (e.g., IRQ affinity setup) to respect block layer
> > requirements.
> >=20
> > It is necessary to provide versions for both the online and possible CPU
> > masks because some drivers want to spread their I/O queues only across
> > online CPUs, while others prefer to use all possible CPUs. And the mask
> > used needs to match with the number of queues requested
> > (see blk_num_{online|possible}_queues).
>=20
> Which driver uses cpu_possible_mask? This mask is assigned at boot time
> once the kernel figured how many CPUs are possible based on ACPI or
> whatever the system uses. This mask does not change.
>=20
> I only see drivers/scsi/lpfc/lpfc_init.c using it. Looking at
> cpu_possible_mask might not be the right thing. It is usually the same
> thing as "online" except on system where ACPI thinks that something
> could be added via hotplug _or_ if the admin shuts down a CPU via
> cpuhotplug _or_ boots with less (there a command line option for that).=
=20
>=20
> In case cpu_possible_mask !=3D cpu_online_mask the intention is to
> allocate memory and setup irqs for the offline CPUs?
>=20
> > Signed-off-by: Daniel Wagner <wagi@kernel.org>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
>=20
Hi Sebastian,

In the next iteration, this patch will be dropped. Moving forward, there
will be no more consumers of blk_mq_[online|possible]_queue_affinity().

Please see here [1].=20

[1]: https://lore.kernel.org/lkml/bnklzljfve53m33xdxv4mlu75kqrkpc3xooxgd3pn=
bvwjst5hr@btomkooj4crh/

--=20
Aaron Tomlin

--qbww2g5iwecbyeqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmn6WUkACgkQ4t6WWBnM
d9YKxw//W0/II84g4ki/gNO+NG7JDjhXH4flQk3JHnq/LP2KNHjW6qNqYgXunCIn
pZwht5Ud0yjWcGE8vZWuR69johnOmngbyAZbBOZGml4vc1Vv97M6pHWuNx98ml80
Ks/A7WJ4LTb04vSC5VxE77x1E7LBQDa75tvt5ZOTER4cXbl+4b5weL9hQbCZLmiO
keSWH/aPL1gUZznqxnbZQSQk1TFlpah1TOfIFduWUARuKCf8dmuqwzqOfP9hBSuV
MV71qH14BBbywqAanJYPUfco1fx5F0BSJFKWwhbPjjzono1WNnULWUlWVwDbFyfi
w44kDZXioOoAjUKPe0xeIkJ4/HDD5zwPoFPEW8oSgv5kE1EpgzjgY+KvDNLktQ40
AwS+6Lqm55pRw5GCgB9qjbbpgmuyC809uZNhaeGC4YCz7MpiG368o5ZTO97NS8Wm
1zIfqyimmB2gYe8n8v6FJii5hkdeYUG6gaPIEqxFlFlucCzw6Gw+wu9bTW4Dc55P
LTjkYWn6RdPLr1rOpC7ohqWCFfAhBHOvaxQvAF/TM4gpyxk7Fi5UhyVvpo1RFUCS
YBpmKd28jq7COQuBI2CTnkppmCjXp55r3HqpQvEF7t2nBtGmOf53i7i1QpmrnIWv
NKL5Jmwj3wwCUXINE8ShaifunkSgIzwYdcrO2MBjLQP0XWE/n3M=
=micW
-----END PGP SIGNATURE-----

--qbww2g5iwecbyeqm--
