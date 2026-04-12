Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020135.outbound.protection.outlook.com [52.101.196.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853DE2D12F3;
	Sun, 12 Apr 2026 22:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776034242; cv=fail; b=Bu1H9fwR/DLuXmlRMPIIfUrWI3/xmA6RljBHe5Ph+yVKJXIAbmO47rk9iUAMNZpVak/VrWjfdvvIZ7xEfHCfpBrDij7yXnKog+pLiETxG/DPTFwIj2q0Wnb9a/SX5Pc/qgNzdDbTedn5vxayy8aJYMctWLUqY2nBw1iMmzpVf6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776034242; c=relaxed/simple;
	bh=CQEzQ3rkCkc8lll7V4dviVMjUep2BbhbDDqVe9u5XyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PUglFRkRr3av19FBn/c5CvTFaNWtQ/bmrPA7bw1j1wklMU0Fx8HuWFYlUcJgf6uWmFt0BImDBL4yi99ebYkXn6kJuNOMJy0Pm3EHllPh6Dil3sYaCMeDiJJtueeTkAhiLlS5TdQ6R2l7L7WatoAuixvudfpiStu8PlLw5yGRcQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTS87+hIX9YTqVVF86asGVvB/xGCcHyfESIlTfuNWHGadg/wiNFc4D24TIroUUqS0m9x/otNc9+uH51annihOBCtllvkj/Zj5jXtmQjEy8K5weQSDgOPrQKaYZruWOLD/L9YjowV7a9i/vk5HcgaXhaPG1DlSB2jFN+uD9/NqDzqAnbvARgLpDp5kELdD0/kex8/DVXr1cdJWPcjo+Wv9CP4No7tgKNGRcWymGZtFLA0lCELzY1Kkr3BGhBbkl4jN3IbmOgLf8enkmwhKom3YOS5ETpmN8wTrfCiFFPTVSnJcq8DoulXm297X8AB0DVz4djDtoy1MhJxb/BGFNz4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBJmPteoFrZ8v2hwYqCotrRzSFy1ya3O4ytBitRVMsw=;
 b=UkfT2DRUaZ3zflEcvdpSutirokSDpbM+tdANlPDc+HOHVhRhkd93nN4H8wX/hF9BK/ruztKcwVfSYGteJu5bj9ogg74AEBm+ftiHbjr+CQvOSJRlidTtWQniOSE9wkIVLvOJ/CqAMNYdXO6jdIcCPZi/8hLdlBSYypxgngd0V4Dy1Ap9UCihi77rq9xMeoO+k2ECRTMBiINItKMjuU8lEZpETbInHbQRbRgzzHyjHOmjoI6GjAv+u25NrvixAJeR35E2Q834s26WWDOEyf+/pyWyvuGltovNhiurscHXFn4mPvjHH/Hs/nJtB9itM+6q6jC6bGS5wcGPdl9NZIR/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO7P123MB8492.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:460::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Sun, 12 Apr
 2026 22:50:37 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Sun, 12 Apr 2026
 22:50:37 +0000
Date: Sun, 12 Apr 2026 18:50:33 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk, kbusch@kernel.org, 
	hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, liyihang9@h-partners.com, 
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, 
	shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, 
	jinpu.wang@cloud.ionos.com, tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	maz@kernel.org, ruanjinjie@huawei.com, bigeasy@linutronix.de, 
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, longman@redhat.com, 
	chenridong@huawei.com, hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io, 
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>
References: <20260401222312.772334-14-atomlin@atomlin.com>
 <ac8l-w8ERG1YN2Wm@fedora>
 <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora>
 <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
 <adpD8M8cNu3IZzEL@fedora>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yxy73jv5o3rece2c"
Content-Disposition: inline
In-Reply-To: <adpD8M8cNu3IZzEL@fedora>
X-ClientProxiedBy: BN9PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:408:f8::9) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO7P123MB8492:EE_
X-MS-Office365-Filtering-Correlation-Id: 21b03789-1e25-4236-d930-08de98e5e981
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	ok4mA/srVznrtz5HW/bgsjZkKh8KGbmtppTHew6kTUTPrfJxzOoZ117iYXh3d0BV21PN7E3mQTN2MHwVp5XsLwAH3MaxBTb8LpwfurPC8l+Fwy44pxog/QSNmh88JgpzgYk5aX1pB6w+uKl2+YLsMrBoq7Mxc4iqauMjtJOWijZIlXyt2vZhv0NmiQTb1QwKVFNirmiOw74rrBYGzvC8ox0QF/3UJuYWbptxJ8K1amMKCF7yC/85op52fbZRLQo/aIHX+4oYADZF5UPiisbwPJuWwKsjxDVpzlOFKHyr93lgRwbmDjEDXx50P+DETf54j1APFBnGCIElfQb3Z1dpKULGnjQdLYqLLDIve5ddAOGE3GegNh5abGGBHPTSsAWeBPyLffkXiCUk76Nxyz5XrhxdUZakJyFtSEem+p5vhOjzYmjXM0GwPs/pHCgH6E6Sb6hxcVU99IFnHEGCzcFMMcpnw/qGBu5FP6aW3sKaG0llB7zj/KgL7CgkWGGB1UDzDnj/HfHyCWPsWfWBy3CMegAkAA6YPpDLK6f52bJCPs0jI85VLBrAJdV3qBlj/lVqSUvpvcDRSwqz8dSxKuN29OmYryGJSYxZJodOgz29axp4OnVOcBi+wJF6THYcaPmAhOEvJGJyexGwYw3IVrnz4VhQzuoKOioCjeZoyAR4YAGBW0FPXVAepLWXP7exETpyGdHfSGFzfYgKsahvhYhgprOxckGMxDmer+D0vugsXmA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkZRWnIzeUdQSWw3ZnBIdHA3YldYUnBpQzBMVVlLWVhPeVpUTjgwcWY1YUZI?=
 =?utf-8?B?L2Z0ZTlYVWxIZ1Q2V1JGUGhjTjI5V0VwekRFeVZaZGQrcXVPRXd5YzNONWQw?=
 =?utf-8?B?azZibFFsTXUwMGN2c1dNV3RSWTI3QlhJNlZuSzU2dnBZMUlja1NtaVFHQ2cv?=
 =?utf-8?B?YUQwVzlOMnhYY1dsa0ZNQm1LTWNsdXZUdVptVWJDRXpDaXhlN2gxVWhGa0to?=
 =?utf-8?B?VE8xWGlmaXQ2QStZVmwxUkd0aU5sbWZsSHI4Lzk4NmNOc0QyMFZReVJmKyt2?=
 =?utf-8?B?MDNuSmR3Y3dCSkdRejdyMU5tcmNRcG1BbXdBWFRtTm9lOFd1M3E3UlFSYVZZ?=
 =?utf-8?B?dElEajcwTDAzakxBK2kreFJucHFHVG10WmR4WENlcjFhanpzY3ZKYTRsSk1E?=
 =?utf-8?B?THZhNFM3NE9JZngvSU1uK3FIaTlRQk1LN2FkbGhYYnVHdit5WmtYYm94UEpk?=
 =?utf-8?B?WjVVdWh2TzBFTFdxYjF3cVcyeng0UVVCMkFZQmpyNTgvTFh1NXp3OUNkaTdZ?=
 =?utf-8?B?bUtOVHVoK3M1cUMyMkFIK3I3alpjMnE3blVxV1VoQnA3U3pldmtTUzFjM2pG?=
 =?utf-8?B?aklvNGhVNVlEVGhUekt0eHhaVElmOTdEWTNpMFBFaGY5MTZXcVBBczBUclBz?=
 =?utf-8?B?aHRLb3BOSkluZzhLMnVpc2tNalIyM2E0dlBIazAyWitib20xUE9KRnpxNVlm?=
 =?utf-8?B?R2sxQ253SWxQaGZtM2ZySFdoNDc2Q0NZRWw5bFJhcHI1bzI4d1IxdjZtUjh5?=
 =?utf-8?B?NVN2WFZEd0U3clJRa0pXRzltNUVkOVFPUjBQY0R0Y2VpMEx4R0Vjc1lMUzFU?=
 =?utf-8?B?Q2lVZDZHQnlUVTk4RndhU0pMWm1Za2h1T2FuRThjZ2FrWlpwb2V3Y1VERzk0?=
 =?utf-8?B?a2xqWFJZUlpOVnN1MTVtMEdITjBPSVlQUjIybXByVWVNY1NoekFaRzdVOFVG?=
 =?utf-8?B?VVNiUmF6a0JSYW1WbU1Mb2FoT2MrVnY2OFpONDhrSndFUytDUEtieFYrdUd0?=
 =?utf-8?B?UnRvaVdsYWQrSSswOStEc2xpMkhZclg5Q1U5WEgzc1ByaHVhcFlYUmlSQU15?=
 =?utf-8?B?dVAwZnNSdUgxclUrM0Z4MW41L08wOUxYNGVBendIbnoyMmNsZnFiY2RTOTI1?=
 =?utf-8?B?dS9KOTByNFUrWHdvRlRKd0NGVlZJZ0wzc2xCUFg4NjF6UGZnL1phZ3lVUUIw?=
 =?utf-8?B?WjVzbGt4S3doVzJlS3dRaTN1RFA5c3A3SG9TdHUzWkZBclVYbGpKUUI4R3Iz?=
 =?utf-8?B?NEdvbkQwYTR1d2JSNElKSDJKOWwxZTBnbG5UTlJlWjMvcXp0Z0dxN24yVXA5?=
 =?utf-8?B?b2VzaS8zc1lWZitPa2VqRHlvS3dkRldWNXBodkNKenZ1aW8wYXJJOGJhNnQ4?=
 =?utf-8?B?Qlo1dThMTnZVZXJlRXJnRy9iZWhoU3d0b1grWmlWZHZaU2pveit0YzRldXhi?=
 =?utf-8?B?YVg0b1pyU2t2TEMyRjkrQStJOTAvTTFJWUdCck8rcis4TmhLT29TR0xSS0ZT?=
 =?utf-8?B?NWtpWlVXRFFxRG5OUjI3WTNCSVFHbEhkR0lTczM3eVE3bjFNQWZ6SXpaQUdj?=
 =?utf-8?B?WFRvVEgzcWhWMmMySDRKc1JHSlpicWdsK1ptRmZyQUVydUVvSzBtZVF0bVRo?=
 =?utf-8?B?L0kxalJibG4rWjgxbWdST1U5UXRCcE5XM2tTOEtNSXZneEkvZi84c1hUTGJw?=
 =?utf-8?B?QmkwamZWMmxuQnp4ZW5OQk04eFVFRTJ6OW9CMXhBbStOMGFBamFXOWVYSlFw?=
 =?utf-8?B?MGUyaWh0M3Yyc2JnblgzUHJXdzVuUFJWQ3c3L3I0U1QvSmlBTGZIbXRXcEVM?=
 =?utf-8?B?VzNpQ09pYjZhYVdJNERKRXlYT1Q4S2pVYnFiYitpVjNFaXBqczArSkJES3BK?=
 =?utf-8?B?NUpPVGpHenZnQWsvMlRvY1FkZUk1ckhqTmcwbWlWTXloaDNWaWNUV2JwYzYv?=
 =?utf-8?B?L1ppSHk1eXRHNlJOYkNJTEhwZ3dwM2U1NFRhVXovcXFac09xYmFkYWtBS2Jj?=
 =?utf-8?B?eHRXVUhCMENDSnVsczFwTGdnVGZHYnR1Y3VFc3ArVnh2dUw5aWUzTUhLWVdQ?=
 =?utf-8?B?RVEzeWhiOHZpTTVhNHlzYlFOY0tYVU4wQ0xnVEd1MWdvYnFWRHZycE5xMWVI?=
 =?utf-8?B?R3pZeEJwVzk0Nkh3QXR4T0ErWHhrR1pleUExRDhXYXFiSUlhdUFTelR5dm1V?=
 =?utf-8?B?VEdOZ0Z5OFBaUDF0alpjQzUvdFhDM3p3WC9jaHNSeDA3dTgwRkRnWjZINXl1?=
 =?utf-8?B?UEEwWW9wR25mMWFDTjBuQ2lPRXA5OTZaNGd4WjVLYjdRZTlIcEtKdWlrTmxo?=
 =?utf-8?B?dkJGSnFUY1BMYWtjMDBiU2VFU2FIenJIbUdPUXlwdUVhTlN1SVlNdz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b03789-1e25-4236-d930-08de98e5e981
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2026 22:50:37.0372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBDyDnvWLZxrwA1qxWlqR3UfNXp3Ha6YFeUlWAjM0YdMtdEIWm/2FeeeRYTHkxVremCZngJk1ZQRFr6Kh1v5WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO7P123MB8492

--yxy73jv5o3rece2c
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
MIME-Version: 1.0

On Sat, Apr 11, 2026 at 08:52:00PM +0800, Ming Lei wrote:
> > The critical issue lies at the invocation of group_cpus_evenly(). Witho=
ut
> > this patchset, the core logic lacks the necessary constraints to respect
> > CPU isolation. It is entirely possible, and indeed happens in practice,=
 for
> > an isolated CPU to be assigned to a CPU mask group.
>=20
> It is one bug report? No, because it doesn't show any trouble from user
> viewpoint.

Hi Ming,

The lack of a formal bug report does not negate the fact that the current
behaviour silently breaks the fundamental contract of CPU isolation from
the administrator's perspective.

To illustrate the user-visible impact, the following demonstrates the
difference between relying on isolcpus=3Dmanaged_irq and isolcpus=3Dio_queue
under 7.0.0-rc3-00065-gd80965e205a5, which includes this series.

The Broadcom MPI3 Storage Controller driver allocates a full complement of
48 operational queue pairs. Consequently, a number of MSI-X vectors are
generated and mapped directly onto the isolated cores thereby breaching
isolation.

    # uname -r
    7.0.0-rc3-00065-gd80965e205a5

    # tr ' ' '\n' < /proc/cmdline | grep isolcpus=3D
    isolcpus=3Dmanaged_irq,domain,2-47

    # cat /sys/devices/system/cpu/isolated
    2-47

    # dmesg | grep -A 6 'MSI-X vectors supported:'
    [   2.981705] mpi3mr0: MSI-X vectors supported: 128, no of cores: 48,
    [   2.981705] mpi3mr0: MSI-X vectors requested: 49 poll_queues 0
    [   3.001915] mpi3mr0: trying to create 48 operational queue pairs
    [   3.011214] mpi3mr0: allocating operational queues through segmented =
queues=20
    [   3.101903] mpi3mr0: successfully created 48 operational queue pairs(=
default/polled) queue =3D (2/0)
    [   3.111468] mpi3mr0: controller initialization completed successfully

    # awk '/mpi3mr0/ { print $1" "$NF }' /proc/interrupts
    78: mpi3mr0-msix0
    79: mpi3mr0-msix1
    80: mpi3mr0-msix2
    81: mpi3mr0-msix3
    82: mpi3mr0-msix4
    83: mpi3mr0-msix5
    84: mpi3mr0-msix6
    85: mpi3mr0-msix7
    86: mpi3mr0-msix8
    87: mpi3mr0-msix9
    88: mpi3mr0-msix10
    89: mpi3mr0-msix11
    90: mpi3mr0-msix12
    ...
    122: mpi3mr0-msix44
    123: mpi3mr0-msix45
    124: mpi3mr0-msix46
    125: mpi3mr0-msix47
    126: mpi3mr0-msix48

    # grep -H '' /proc/irq/{119,120,121,122}/{effective,smp}_affinity_list
    /proc/irq/119/effective_affinity_list:42
    /proc/irq/119/smp_affinity_list:42
    /proc/irq/120/effective_affinity_list:43
    /proc/irq/120/smp_affinity_list:43
    /proc/irq/121/effective_affinity_list:44
    /proc/irq/121/smp_affinity_list:44
    /proc/irq/122/effective_affinity_list:45
    /proc/irq/122/smp_affinity_list:45


Now with isolcpus=3Dio_queue,2-47 the allocation is structurally restricted
at the source. The driver creates only two operational queues, confining
all resulting interrupts exclusively to housekeeping CPUs (0 and 1):

    # uname -r
    7.0.0-rc3-00065-gd80965e205a5

    # tr ' ' '\n' < /proc/cmdline | grep isolcpus=3D
    isolcpus=3Dio_queue,domain,2-47

    # cat /sys/devices/system/cpu/isolated
    2-47

    # dmesg | grep -A 6 'MSI-X vectors supported:'
    [   3.284850] mpi3mr0: MSI-X vectors supported: 128, no of cores: 48,
    [   3.284851] mpi3mr0: MSI-X vectors requested: 49 poll_queues 0
    [   3.305492] mpi3mr0: allocated vectors (3) are less than configured (=
49)
    [   3.316528] mpi3mr0: trying to create 2 operational queue pairs
    [   3.328013] mpi3mr0: allocating operational queues through segmented =
queues
    [   3.340697] mpi3mr0: successfully created 2 operational queue pairs(d=
efault/polled) queue =3D (2/0)
    [   3.350664] mpi3mr0: controller initialization completed successfully

    # awk '/mpi3mr0/ { print $1" "$NF }' /proc/interrupts
    79: mpi3mr0-msix0
    80: mpi3mr0-msix1
    81: mpi3mr0-msix2

    # grep -H '' /proc/irq/{79,80,81}/{effective,smp}_affinity_list
    /proc/irq/79/effective_affinity_list:1
    /proc/irq/79/smp_affinity_list:1
    /proc/irq/80/effective_affinity_list:1
    /proc/irq/80/smp_affinity_list:1
    /proc/irq/81/effective_affinity_list:0
    /proc/irq/81/smp_affinity_list:0

> Sebastian explains/shows how "isolcpus=3Dmanaged_irq" works perfectly in =
the
> following link:
>=20
> https://lore.kernel.org/all/20260401110232.ET5RxZfl@linutronix.de/
>=20
> You have reviewed it...
>=20
> What matters is that IO won't interrupt isolated CPU.

The isolcpus=3Dmanaged_irq acts as a "best effort" avoidance algorithm rath=
er
than a strict, unbreakable constraint. This is indicated in the proposed
changes to Documentation/core-api/irq/managed_irq.rst [1].

[1]: https://lore.kernel.org/all/20260401110232.ET5RxZfl@linutronix.de/

The following is an excerpt of irq_do_set_affinity().

 - File: kernel/irq/manage.c

 232 int irq_do_set_affinity(struct irq_data *data, const struct cpumask *m=
ask, bool force)
 233 {
 234         struct cpumask *tmp_mask =3D this_cpu_ptr(&__tmp_mask);
  :
 262         if (irqd_affinity_is_managed(data) &&
 263             housekeeping_enabled(HK_TYPE_MANAGED_IRQ)) {
 264                 const struct cpumask *hk_mask;
 265=20
 266                 hk_mask =3D housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
 267=20
 268                 cpumask_and(tmp_mask, mask, hk_mask);
 269                 if (!cpumask_intersects(tmp_mask, cpu_online_mask))
 270                         prog_mask =3D mask;
 271                 else
 272                         prog_mask =3D tmp_mask;
 273         } else {
 274                 prog_mask =3D mask;
 275         }

    1.  If the requested mask consists only of isolated CPUs (e.g., 2-47),
        it will have zero intersection with the hk_mask (which contains
        only the housekeeping CPUs). Consequently, the resulting tmp_mask
        becomes completely empty.

    2.  Because the tmp_mask is empty, it cannot intersect with the
        cpu_online_mask.

    3.  The kernel triggers this fallback path. It abandons the empty,
        filtered tmp_mask and reverts back to the originally requested
        mask, which only contains isolated CPUs. Consequently, the
        interrupt is routed directly to an isolated CPU, proving that
        managed_irq cannot guarantee isolation.=20

> > The newer implementation of irq_create_affinity_masks() introduced by t=
his
> > series resolves this. It considers the new CPU mask added to the IRQ
> > affinity descriptor. When group_mask_cpus_evenly() is called, this mask=
 is
> > evaluated [1], guaranteeing that isolated CPUs are entirely excluded fr=
om
> > the mask groups.
> >=20
> > [1]: https://lore.kernel.org/lkml/20260401222312.772334-8-atomlin@atoml=
in.com/
>=20
> Not at all.
>=20
> isolated CPU is still included in each group's cpu mask, please see patch
> 9:

You are entirely correct. The actual structural exclusion preventing the
interrupts from landing on those cores occurs subsequently via
irq_spread_hk_filter() in irq_create_affinity_masks() as per patch 12 [2].

[2]: https://lore.kernel.org/lkml/20260401222312.772334-13-atomlin@atomlin.=
com/


Kind regards,
--=20
Aaron Tomlin

--yxy73jv5o3rece2c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmncIbIACgkQ4t6WWBnM
d9Y5BQ/5AcNQ0c2n8+kNI2LFqNuABLZ9U9I+k195fJot3VTU9cKouItSQJkUO8n6
UjShB7HpJSxcSiBqPRT5yhyhiWV4z0vh+SRWs8+rNw2VtGdlmMKYpqch3ofaUdv+
pwNIbRVibQgZDsCxJFqDSbigIl6IuufeLRwfwEawpt8uB/qocM9QBwownjeK60IU
etsfuv0Dgs/oWHoWday3YWu5q7amg3rmsOiuse4IArg4TXKI/WcHAqOvEWekns+w
3LSLhn7XzIP+CRXKZLcgiEIvvwicYQrLVYwwgZM4ZqDPf2pXWdxRMIxpr0B+8PqM
4l1wGsWpnbJiHI+qIDX+T2IqlBcPNhJkTysJZK7x52JMWbaOd1eq1FS1twwxUk6E
CBnkFUCSiYXsYBB3SW1gVA9m+ycuWkS0IREtpFhS7Szh/GQBpIAd1P2ySbp31CfH
U8zfTyOWI/J/rNXtl3VAT94oBwwRktuP4dRaB5Dew0eH6FyHrm2bEoj1FdmLFBui
EWmRfs49TRLVN+VbkbOOhN3AYi+lFgZ+1s1R2nklr6jTbfo88/EKvQRe2L2YZJye
+uZQ740rrxE3vK1Qp3Koct94UJLm47AthcK208n5XsEsa30REvN17roTseOOHLqf
BqEWMm4ySN98PHpIIRMj/bgtopH9ytThxH8kM0oTEgIy7wHyK9I=
=t3PV
-----END PGP SIGNATURE-----

--yxy73jv5o3rece2c--
