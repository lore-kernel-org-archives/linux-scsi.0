Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022108.outbound.protection.outlook.com [52.101.96.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E3A324B1F;
	Wed,  8 Apr 2026 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775663919; cv=fail; b=gdQfVi/MdLR6jTU0NUBETqmkRdpv2pmxDyb1XCMe8WebLZ65z+z1udVwS3KNSLlcKOkseK6yaeLeDe96ZmyNRwhIIZDr+r82JHRCNfAPgF/KUboFbryPxKAdhiCQ5PBM69D//0HYhOEPn3b9k8ZunCHC3aXZjhyLLo6LNQI6cKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775663919; c=relaxed/simple;
	bh=UJO7K918WFz2I8EfjCplW14pWqQXfyq1drYJyC2/k5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tLr6jjtARO2rVA9LFmXd7s2sgJtbNI/h+SJAbouopP4IoPwjHCCdbKuDrxO5RiHkt4pYsxje+yjOkQK4yVptWGutPM11P1aOnmHft+s1v94PMYQe/VZ82d2AT22J1xyPOSwl0gdkGi3Q9TNaOr3XK3z7SLHRCEGr+eJyckx7TqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UGAjYU1KEPZ6lhrgy6RBVmNdYO+oGfVZoR6hgfCOs+F8mMfFSnE5MqJ3gOB7V9sG9czXgWT5vMaQJa1RwXaQMOtueBrtgThZpL1ZzujyFsrDBOc5HR1CEgsywstgn+GuBLCkXKQ88vQxewRhLlXbrkw3V0Vq0GhAHSMNwAWrFlnuPOhXFYizfqrCtk5TiVTcnTBIrq4FETuEG4KpcpSjbNpudILJYgSb5r3zPQ7PadYFuJY8KksJEhmnepliclHowlD5XVdUOBiTf0gDxtkLnghT5pCxgo3nX5U5eJL3XenHor6C7M6syCmzdDenRgzZxpJJEKtwZyVX8S65lCt2PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJO7K918WFz2I8EfjCplW14pWqQXfyq1drYJyC2/k5A=;
 b=qsA31odHIZILG5C6TF8KlpyDSOoz5CUKPKw0B1NBNj1IZmPj9f+uLejscznpR/Su+0ODHB8i1rBudK7JPzVvU1HUZvsGi6WejTfEpw3ooYrEwhDbsv84Ai/aY5HNwxVOHIDvBIjMbXDh2dPSdqXPb64vr3sEqE0OemsIKZmhQ+bGydORUFQzzz5EYCtbtxLGKoRMI2Hr8+VRfXq2EeC+p0+91NoD62vm9bDBoFi4KTCKZtheAE3YbLQDb5+AHEbcLa7e16tJOzpTog8qa+9A4GKB+go+g1/f6VtsjpKbvPlLLvrW2/32pd9nTjEVmLNi6y9RGl9BsrG3kmTXFmQnBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7800.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:428::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Wed, 8 Apr
 2026 15:58:32 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 8 Apr 2026
 15:58:32 +0000
Date: Wed, 8 Apr 2026 11:58:27 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	mst@redhat.com, aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, 
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, 
	longman@redhat.com, chenridong@huawei.com, hare@suse.de, kch@nvidia.com, 
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
References: <20260401222312.772334-1-atomlin@atomlin.com>
 <20260401222312.772334-14-atomlin@atomlin.com>
 <ac8l-w8ERG1YN2Wm@fedora>
 <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xgsaf6uu5tur7btd"
Content-Disposition: inline
In-Reply-To: <adMoon3Zf6gO-UbA@fedora>
X-ClientProxiedBy: BLAPR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:208:335::18) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7800:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bf27962-57ca-45fb-5a1b-08de9587aea1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EFwR629TM+gUTEa6FlDBev0PDQ5MaMG4pNv6q6ZEJVFksXubBz/7ZskJFz8/pX4JX8p1OuD9YWHO7RirjDbzlolzql5XIGi1ZyhWOxrRTXPtpg63HZO2rFKfpMEXuIGYIgeqz2Vx5Je9NfwpMK0A6urSx0teAPfo2rZWr6fnK5E379mLchns5yEQeQ632NSKJftnBW76+gJq2TgPI8BWt9yWb3qvknCEgXf8xsV0CG8HrBoiN6E0YFez4GCmXkHvNIf8Ro7KEezUkn0ddT3QybbAmrve+ELm1E2ecALVwk5w7wSIQb9+Spt7NcfAQonqknMM5XHXatiPQ8JnlNlAry7bleOsedGD3scZisEUoF7TXRRDenSt0phcUNW3oF8qbTWfhN5W55f6LvG6eYAWuaFzGauk17EcObDld1BtCMjCizmsU9Bqb+QWTFmgMh3I4gnRXpgz18PTS3Funpdt73STuj3MrM5HIoJzJj59YpcG3XBlWODRdacVSCOj5KgVFeKvuniW9OEs0rshZSckFSRZmaj/TLkwd81SdC486C+VV3C6DfKPbwW/cOabAtKxBb160PGltldUyujxD/ToEZvmJAJwCR4t/Tv/gXzpDySjCH9rvCfaaT1dr2pn/rKziOjKj7NYYG08T3jkAQBaPm3MLfsI7B0Oq77uST46CczC4+Lmo6B5tVUba65KGfyUnoYcB/qn5pfzwjI6CAvQzpyCX4tgPeQFBSicJdh8TKs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MG9XVkhkenEyUWpKdEZYTHZKN2hGZEg2VkpNSEUwR1JTcGZIUGxIRURLbEdU?=
 =?utf-8?B?UDhSV0R0OHN5cEUyQjNxZ0M0bUc4cW1DdDArSTVPdzJHMFpieVJWdDB6K1lp?=
 =?utf-8?B?cUhOMmpmTzlrZGJQMW1UTlMrWXlRUU9EMzMzWTI1MjRHK0RGcktLdFdGNlpS?=
 =?utf-8?B?VEtXTEJEWU9Ob25mb0RKeG9zZEtuNHFKaGozeHNrNXBTRTV4WEJRbTl4QTFi?=
 =?utf-8?B?Q1lsd2lLMEM4QnBtYVM5UTAxeXFybFlDRjk1ZVlXeEZMeGZYZkprbGhDZm84?=
 =?utf-8?B?S1FDMERVQ0xPRXdiazd2OEVwampDRGJ3YWdTcTQwcFhWZVU0VFZsSTVueEpR?=
 =?utf-8?B?K0l5SkNpUkhuNm9KVDZ5cDZCWGZYZmE4L21kalZTNDVwQjM5WXJ0TlQ5Qjgx?=
 =?utf-8?B?S3Q4ay9RY3B2TmNMeUNmTjEwY3puSjZobWVWeHRtNTJETitxRTFKaFZSY0N3?=
 =?utf-8?B?OTh5NU4vMWZoelVZTFg3Q1BpUTNPaCszQWhsblFnOUMzem5mWGNwRnBvY3Nm?=
 =?utf-8?B?ejR6TFZHUkkzUzF5ZzIxTXA2UFJWY3lONjAvSE15ZFNKY3B1NDE3RDhVWGRq?=
 =?utf-8?B?cXN6ajc3WFlIa3JybE1pS0xwbHc5eGVudnl5Sm1TUGFFaEN2QmZNTEVwbzZ4?=
 =?utf-8?B?MDJ5cVZtdEhRcHd3NlZqV014NksrYW5zejdWd21lbmVodUg3Mm1maVJ1aDNo?=
 =?utf-8?B?MHVGa2tEcEhnTGU1ZEFkU21ueE84eFB0V0ZPS2FWYmdtanFoY1JsSjFWVGJO?=
 =?utf-8?B?Z1d1MENjbGo1aDk5cldneWhidkoyOUl5N21DcndGMUlJenpNc2ppWWxERnhC?=
 =?utf-8?B?VW00OUZXNGtxbjk2SzRtRXUxb1lYZjV4aGVmWWhua1FlbldxcmNQOXFhaGdy?=
 =?utf-8?B?K3FwTmZ4dks0VXh4T3NIREJVZXExYXQ1RS90RXlTSDBOUFZDa282bGo5N3Nk?=
 =?utf-8?B?UXpZeExWUFdUTDdlT2plVnE2SHNVV0ZNMVM4SHBwZE1FYmhmL0ZldW1QZzQr?=
 =?utf-8?B?cXRuc0JDNlVCR2FJQVlnZmtiUWN6TDhHWWsrMTMwVkgrQytVUVhsbmFaTlVQ?=
 =?utf-8?B?b01wQURCNUZsU2NPMnJhNXZKYVdjS2dQUjJsZmZZVm1jaGxKT1Vzc3hHM0Zo?=
 =?utf-8?B?ZVp6R3I2akVPSVBxU3lOK1VQYjBVYlRWVEZNYWZ5MWk3REtwUzRQdVA4OUg5?=
 =?utf-8?B?SWRsMkdrVVpySmhITDRkUnorSElDWVZSRStLMmJ3bDZNYUNXckdKV1FBcUxU?=
 =?utf-8?B?TUR5MnJUSUt6SHJtNzQzMlpxZWc1RW45dUNIaDN5dndKbGhSTUMxVzhMdk1s?=
 =?utf-8?B?MlF5NXhONmlJazYxQVpOZ2tqdUNXVldpL1VLWmhYRnBTYnBVSHVFSjZhT0lX?=
 =?utf-8?B?SzlmYXMydmVlamZKVWR4T3Z1NHlrblVXbEVxOVdPWVhmdmx1Z0hBOGFWMCt6?=
 =?utf-8?B?eW5aYnFDaStJUnlPOFhZM2FBcU9kcnJtVEl5VzdQaGM0TEl0NmNFa0FGazVh?=
 =?utf-8?B?NVFBNHBkcHhYQlVBSXJoNHJmblh1c2haNkVXOWhsWHVScEJmZ1hHUmFpV2xF?=
 =?utf-8?B?TEZwRSt3Qng0MkpFU2VVUWhRVVFHZzNHQWUrMGlpWVJxOWVEWFpoOGxWUWpN?=
 =?utf-8?B?RC9FNHZDK243REorODJBYzF2RHRlWXNqaWJBb2tXRTVweU5lTnBseVRqcFZY?=
 =?utf-8?B?eXEvTkl4d1lYNFhSM05YY2I0L3M5Y2d0M1hjVDZld3ErdE1CMk90ZHVoWmIv?=
 =?utf-8?B?elRRNEJvOC9hTEdEL3N5Wi9kQ3p5bENrWDIwMFhERTdDYXMwVFI3SU9OZzE1?=
 =?utf-8?B?MERVYk1pc05QaXYrY256ZCtNUFBMQjRXR3RRbS82S2w5SkxHcHFOTUNJb3ZI?=
 =?utf-8?B?M0o0R3lmWE16MWRGRzZqdlcwS25CVE8yTGxvUWdGNit3TlVRNklyWFUrcFpU?=
 =?utf-8?B?VkRBRWo0Wko3YjZHL2NHazVmY0pMZ1JvL1czRFNOZW1sb0Nua1JZajlpRm9l?=
 =?utf-8?B?ZDlObWhyTzBra0grMitYallpZFhsUzIwSnpYYU8yVURXZXByY09IVmZiVFhE?=
 =?utf-8?B?ODQ2a0R3NVNmU01oTmR0ay9DZDRXUnh1SHZmUlRaY1FRaWZYaXZIUXJrYzh0?=
 =?utf-8?B?Sk9kWWlteGJ4SUFGYWpTeUxMeHBWYWkwaVg1N1pLN21HWDZtUytQUUtxaFlo?=
 =?utf-8?B?c3VPU1FtSVJGQW5PVkRkNi9vbnRyWkJUVVQ0ZUFDRUt3VmczYkdIQmozdDU3?=
 =?utf-8?B?M2NJM2paZUsvdWx2aVpOTzZVeWI0SndPMWtRdUxueFZ2TFZldk9Sem9FVFVS?=
 =?utf-8?B?WVdPZXdSQkhORWJXOUFCMEZCU2hhQ0ZDWGhYVktUc1RHbUNNQTVldz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf27962-57ca-45fb-5a1b-08de9587aea1
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 15:58:32.0803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q50b9oho4sdsaChRspceKkSHAGp0yd70dFp795pG8a7GabxWQW9zfDKPcouuX5PhF82vqo7X4UzyEQjProgZSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7800

--xgsaf6uu5tur7btd
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
MIME-Version: 1.0

On Mon, Apr 06, 2026 at 11:29:38AM +0800, Ming Lei wrote:
> I don't think there is such breaking isolation thing. For iopoll, if
> applications won't submit polled IO on isolated CPUs, everything is just
> fine. If they do it, IO may be reaped from isolated CPUs, that is just th=
eir
> choice, anything is wrong?

Hi Ming,

Thank you for your follow up. You make a fair point regarding polling
queues and application choice; if an application explicitly binds to an
isolated CPU and submits polled operations, it is indeed actively electing
to utilise that core and accept the resulting behaviour.

However, the architectural challenge arises from how the kernel handles
these queues structurally when the application does not explicitly make
that choice. Because poll queues never utilise interrupts, they are
completely invisible to the managed interrupt subsystem.

If we were to rely exclusively on the managed irq flag, the block layer
would blindly map these non interrupt driven polling queues to isolated
CPUs. If a general background storage operation were then routed to
that queue, the isolated core would be forced to spin actively in a tight
loop waiting for the hardware completion. This would completely monopolise
the core and destroy any real time isolation guarantees without the user
space application ever having requested it.

This illustrates precisely why the io queue flag is a mechanical necessity.
Its primary objective is to act as a comprehensive block layer isolation
boundary. It structurally restricts both hardware queue placement and
managed interrupt affinity strictly to housekeeping CPUs, ensuring that no
storage queue operations of any kind are mapped to an isolated CPU.

To achieve this reliably, this series expands the struct irq affinity
structure to incorporate a new CPU mask [1]. This mask is explicitly set to
the result of blk mq online queue affinity. By passing this housekeeping
mask directly through the interrupt affinity parameters, we ensure that the
native affinity calculation is strictly bounded to non isolated CPUs from
the moment the device probes.

This structural enhancement allows device drivers to seamlessly inherit the
isolation constraints without requiring bespoke, driver specific logic. A
clear example of this application can be seen in the modifications to the
Broadcom MPI3 Storage Controller [2]. By leveraging the expanded struct irq
affinity, the driver guarantees that its queues and corresponding managed
interrupts are perfectly aligned with the system housekeeping
configuration, completely avoiding the isolated CPUs during allocation.

[1]: https://lore.kernel.org/lkml/20260401222312.772334-5-atomlin@atomlin.c=
om/
[2]: https://lore.kernel.org/lkml/20260401222312.772334-8-atomlin@atomlin.c=
om/

I hope this better illustrates the mechanical necessity of the io_queue
flag and the corresponding changes to the interrupt affinity structures.

> > Every logical CPU, including the isolated ones, must logically map to a
> > hardware context in order to submit input and output requests, saying t=
hey
> > are completely restricted is indeed stale and technically inaccurate. T=
he
> > isolation mechanism actually ensures that the hardware contexts themsel=
ves
> > are serviced by the housekeeping CPUs, while the isolated CPUs are simp=
ly
> > mapped onto these housekeeping queues for submission purposes. I will
> > rewrite this paragraph to accurately reflect this topology, ensuring it
> > aligns perfectly with the behaviour introduced in patch 10.
>=20
> I am not sure if the above words is helpful from administrator viewpoint =
about
> the two kernel parameters.
>=20
> IMO, only two differences from this viewpoint:
>=20
> 1) `io_queue` may reduce nr_hw_queues
>=20
> 2) when application submits IO from isolated CPUs, `io_queue` can complete
> IO from housekeeping CPUs.

Acknowledged.


Kind regards,
--=20
Aaron Tomlin

--xgsaf6uu5tur7btd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnWex4ACgkQ4t6WWBnM
d9YIlxAAq+CQzWsH3k7sPdGQaVilwFChzqQOrZidIWLqYoMbmalJ2/hrhJflioyJ
Ppa6lAIFzZJTlOPr2QCrcoNO+fgDi5NFTsIAT/b6+9UDYNm0XzNudZJjVSqVBy+Q
PK59W3wo5GikG++B4jDQixQGy5Dqccyapy1xFB0ErwbjPjry9Nrv7VOyt4zuux3a
76Y3L8Iz8QJvI0a+sH1YlV+wLhkkcvd5Mxgy7jnOM5YnBUWT6AbUDcH9VXSjNiUb
5sUQh3iC27foyWhhAKTkpInW5HA3fxPSFRJIDDcV93UifXFzXSixRiXYLdrWrPHr
DH0VjzGUsJAQVXqmBvrhgp2EKeePcDRZhF5uXql6RhV+XIKLkZ+cbTb+mSPTApaY
DBU/W7g3G/PPEaSevI29EihQfcpZ2+pPbX5pO+2yizIUSYgwOk3Ab4dNtHQgQy9H
8G5VowiU8szmOmPywnYJs8iBQaClx7zE4ijF2hZPpavK/wkLf3uZj07TR15nXFRN
OhE/BJ1R6joHie/jSMrO2XqgAmVqA7/lgAdll7ZTlhufurfewsPCXixbLdN36Nef
i3uDEJRwqsLBYbptsjglor0Jg61JFLPWqeKfWjzy3QbO/YOMarpMmZcbfujRi/hS
m69V0q2tO4o7o5tZzahIzOdZW0abWdtusQ2okt1rzZwrfrK6B80=
=hHsP
-----END PGP SIGNATURE-----

--xgsaf6uu5tur7btd--
