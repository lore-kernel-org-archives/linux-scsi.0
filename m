Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022141.outbound.protection.outlook.com [52.101.101.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DAB3D0930;
	Tue,  5 May 2026 20:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778013639; cv=fail; b=U63OggkbBHAceDqAgND0tJ7x8mMpoLaLOYZLrWTpm9lAQ5VU+y/zSREbFEMqy5GVA0gfYuc0ISw4TAnfI35drY/Qgkv5c1lp8UFtCwV25jzDPnj/OyxXbaeyW9v1b/peOmnGrMprZ2F6Gqif8ll/DS8boKUIDHvbmZZKUiinr98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778013639; c=relaxed/simple;
	bh=dXVF7O8iiWkZ+9YneI1v6JKmcClRbJwxCUxm8osKHew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=obhuSI2Mjxu2HVmTFoozg0oywhFRoo8/nGk5od7P3cO2uZlXbBP0MovcIL5y37hrzaXTBTVuefziVqGgDimudKCzNcEcUa0qPiN1UrW1MleaeLf8njnUcq9ZWDOvXsDlvYp5B0EOArsa5zKnnq4x6rEyw2lF/oM5fshbOHgiOXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XTwVmUjNRGIUqtlU/dKTxtAyvY6UMircpYZBfctZllZuFz1gfQ96Q7x9/WIDtII3uigLNCOvLgpDyvfs/BvfoZhteGHlP/Xqs87eFEP2hT1KU+Vzn4JWrrvtUf0+HYP/QMQrOM+QRijZ78VuXijTkF7Emf+1dQ6LjBafLkgHHbHqzc2spmotU2e3FrfTAgf6d7qn1es21e+lQkioS/3Hexk4EPw4Bur22AsGdDUVq3Q88Xs9nq9YR1v98zBKFjWRYysYjNke06dREKAwBKRDPRSn0zlxrlB/7+GdJe5ng9GhwkwdUqooFmU36LnMFwRlrjNAlLLSyU7UOhvyhBo3WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BR7WG/efwTX9bX8PezveaFBcy6kZYWsmHrOi2ptqEHg=;
 b=xxV4mMxYbrlMpOMg4sYEUh8OfRK3EPbN2v4bc2oeyMMoNhVCFCjF1oz5Bf6KX2yhd/Z7AKJTwA8VbEP47bqLBG00dKkuibGAxNCZlsLjJPvIas95873qS2uG9NKSbV6Mjmb7wgBERH95H8ORzemgkp9uauD+xEJvQvNuRJjxr6Vg+vRYv/qIte9AY8YWiLjorjxbPUlo6RxCoASzG4ckAt+SXTY85WC3M8cxR++1NpjUH6egynfIFNb0SE0opEHMDXrumvYso3d4UMmaT/pmJo5tJTsNWzBCDZYnJUJtml8P64j13AFf/1D0XeHErJkW4PqK1bhmB9lolkhVWYNC4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3651.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:93::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 20:40:34 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.025; Tue, 5 May 2026
 20:40:33 +0000
Date: Tue, 5 May 2026 16:40:29 -0400
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
Subject: Re: [PATCH v12 04/13] genirq/affinity: Add cpumask to struct
 irq_affinity
Message-ID: <scgwyxxbvzm3gch2azhy3bs44fwik54hmf3b5wicplp6tt5mmm@nwzu5ezbqmwf>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-5-atomlin@atomlin.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r4aze7klgyanajpr"
Content-Disposition: inline
In-Reply-To: <20260422185215.100929-5-atomlin@atomlin.com>
X-ClientProxiedBy: MN0P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::13) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3651:EE_
X-MS-Office365-Filtering-Correlation-Id: a520361c-82c1-4b7f-46ce-08deaae68df8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rl85BEPXifeQfjcYcLNqM6DZk8XGvCKolVAakgho6LHY7NMG5pBPBxid+3hBn7sArpJknC2efTV0lTyPCVVOV842mQoCdlKgi/Wkgd64dvHvfjtSGx+65keVaEN009N5Tao+3Pd2vy4r0OpxoN1h/Ct7jgdLKzVbDdq2+Dtc0UVjJQVSuDraGE3TTQaLL4aPunn25JIK/kIQsrdT7tjZ5DgZBoAP+NZS8kbKBkib5pUUsbpSk4zZ+8y3MjE/1iK+l84QLJ0eLVkS5Fl3GRXObkfAc8kCEcUhN7UKobyvpJ1L6BKvhboO/wsgN4KPRTn2SB+M8r7CuxzNgp4UWUhMnV5a6ty5DdNxrJGCTs6KU8WizSaSEc5YDmdyb6HfS5DncY7l8wdr1wviU/fJNryX+c1Q5U0Wj1C3vvTfpgbAkQZnP3vX3z3DoFqDXYOEu20vEkdY07wQq5j1xwmOrijM7W0vjWlvapIEec3YEMAZjaWCOHRK323xBBTL6UJLTaldTkNeZPVSA+hG+gJDivesUAtgqQ4FjVVQYL/9/QVYLQ4FxuLARLwxTN1eOQmB8AMjhOu25adtEI3q3XhKDCN9iZt+sHnruZ5NT/U34SCRZwAQe/pEuRHZHTscHeUDA8T67Qqh3ET8IPlnQ1T5OhtkrbnYIa0xzFi8K49DYwDB6Hi8MI+siFCAVzhcMiZy3H2g
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWtJUzY0VlhBZi9vZlFpSVVVdjFoak1vWDFvY0p2N21WY2VPSjNINCthS29j?=
 =?utf-8?B?d1pacjRqWE5IWjJSbmVNQ2lYSHlGcy8zek5RVUpuOExDcjhPcWk1Y3FmY3ZF?=
 =?utf-8?B?U3RrTkVxQXVCcUpCalJPenp2aHRxZld4anlBSGZ2TG5NVE9qQTVMbTAxR3hv?=
 =?utf-8?B?c0NDV1pPaVEzTVVPMm5PMXNuYjQrRitSVThDR1JISVV1djQyck4xQTh2MVJ3?=
 =?utf-8?B?TE9OYkovQzlEK0ZhWXpVVjJ0MDVSNTNaOFAzbmFOc0hpWnFBanRhNU43S0w4?=
 =?utf-8?B?bzluQW5MYWRVRy9ob3dJUjUwOW0yL3JkUk1NZFhRM0ZPQUR0SnFGb0cwRHFS?=
 =?utf-8?B?Z0V2QzVJUVhRUXdvM3h1Y2NlWXJBazlMYnNRRk9iTlUya0J1aGFzRnRGMXBo?=
 =?utf-8?B?YkkxUWllbVRObGdJcVRaNS9uRWNXMTdDRkEzY0o0UG04RUFyVzM3TXZPd3Zi?=
 =?utf-8?B?STUybnNCVFMvWEdhcXZtc0huQVZOREpQRUtWb09oZlIwU3VTWlFjNFZtS2dQ?=
 =?utf-8?B?SG1FT2VsbkVZbFNJODc3SHY0TkF0SjlrcGxOSGZkd3F5eUJFR3ZwaFdHZzNu?=
 =?utf-8?B?aHZhbStQUWxna1FMVWVVZWFnU3JhcTRiMjZFcEJGVGNHMzNtVjFOUkU1WTc1?=
 =?utf-8?B?dE5SbkhkVmJoTVJsRUlBRnlZemQrc05Pdy9sU1FyZGhlWEYraDNBeDlYMWlC?=
 =?utf-8?B?SmJvdUljSTRDVVpQVkh3WmFEL2RoZVdLQkplbFF5NEJIemVBa3h6VEtzYVJz?=
 =?utf-8?B?MkUzTnY0NnI5ZTdsNy82bktsWlVkUWVOZ0VTUGJSZW1GRU9ObGxyUHJzaGs3?=
 =?utf-8?B?MXZRWmhaL1Y3KzVoRVR6R2M3a0tJV25FcDEyTi9KTDdoQWhwRnNINWZyTnc2?=
 =?utf-8?B?WVYzZTNVbFJVWExIZkhvblhsMXJ5YnpMaVhpNTVKbm4xb21QWWVINmdSR0VX?=
 =?utf-8?B?OFpVQXB3U0JSOWpjK1RrUzZhdWVMajdsaDQ4Y2lwUjU4YjJlL3NKVjNWR1Zh?=
 =?utf-8?B?OUtYUkVsODhaRVJ0UmRhOFhiR3lUOFJRdnIwdDhjMWFGK3BHWUZGQUJ5Rkli?=
 =?utf-8?B?cXpqeHVWNEREMTM4ZHRzTlh0SitvVTA2ZlpMNEtGa2UyYTNzOW1LbmF1RTZ5?=
 =?utf-8?B?RkNaTkNKSzJvdE5oVHA5U1JUY2JDMGZwbWM5RFJ0blpNcnIvVWpQZFpEaEtx?=
 =?utf-8?B?WU9mNU9yczBVZy91V0RPaldZRkhkQ3ZlUGNTcTJ5cnN6cmI2d1Y0SEVaZnpJ?=
 =?utf-8?B?c3l5ZUdncVJPdEFhTmlkOG1nRGpIUTNJcW9hYjZYd3kyN2lVUzBzZ1R1S1hz?=
 =?utf-8?B?R0xuR2RpQTZ2UWMrZDNzUTVvdXlZaVBYd0hSMkFrUHMvVWNtOE5rSmYzeXdR?=
 =?utf-8?B?WkJLcG9xemUrQVd4c1AvUkI1QWx6SEVpY2NuV2xKUFc0NFIvcWVVdnd0Y0c3?=
 =?utf-8?B?YkZKRXV3SHQ0V25NSFhBUys5OUtrYWdzV1hlOXZXK3ZnNXRtZ05XZW10czhS?=
 =?utf-8?B?WnBjMTBScmp0OFlTRVFPUFhhN1I0WjZ0cVNaK3l6WEhUR0NBUjRpN2llenp1?=
 =?utf-8?B?c3h1QWpoMkNoL1ErNnV2azBRN0ZYWS8vdTUxUVpaUEtGV2ROVWxucllDclJY?=
 =?utf-8?B?MHNxQ0NSVExqVVFYakNaME9OOGFRN2lFaWt0UUxpNUZzNjc1eFhoNWVndXhN?=
 =?utf-8?B?MzBQZ0pxZGxNNGVLdUViaERYSUtsUit1Njd3VWZhTkM0dU9wcEtBWmNJZHRt?=
 =?utf-8?B?MXQyanZXQlNoa1doV1doMUx0dEFMK2lETWp4UHA4dzhPYllWYnE0aGwrbzYx?=
 =?utf-8?B?UVFqS1M4cVVaTnJDbVdVSUZxZHRid01PaFRieFhRYk9sV1B5RGRWY1JldmpJ?=
 =?utf-8?B?VkVBNURxZFUvS05OMDlzK2VsMG1sUnFyc3crWmRGV2MrMzNqSHR3cVhYUExV?=
 =?utf-8?B?Z0s0ZVZ1clkrRWdZVnlqckF5RE5saVVXeXE3NXdwdk02UExTSU8rNWd0N0tU?=
 =?utf-8?B?aGtmR1NYeHQ4MWlTVUs3bW1nbFZWbitBT3hMbTBlcUczLzNEcFkxSVVaUjRT?=
 =?utf-8?B?RDd5Z0wyYXFmWUdUUi9rS0NRSVgzajlqTmowUHBPOFQ5V0dGV0xBcE1hUll1?=
 =?utf-8?B?R3dpSnFDbG5kcDRHc3lzdWFwZURraUdqZFE5SFlTaWEyQ2dmTGl5U0lwYnVt?=
 =?utf-8?B?KzUzSm1mOCtsL2w2N0VGWS9HcEVBbHM3NCtndlZjRVlOWXJxbURRNGV1OFpv?=
 =?utf-8?B?WnZiS3pYWmJLaElQS1pPcngwbmpyWlVzTUZQRU81R2xXVThZcG1jNEYyUTV5?=
 =?utf-8?B?WnlPVjE4TEZLaU4wSGxYWnZxRGl6OGN4Y1lhb2h1MjdiOVhtV01yUT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a520361c-82c1-4b7f-46ce-08deaae68df8
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 20:40:33.7434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CE2GL2c5wSxs3rGgtcKL0nzNzRXY8Q6OVQtexaG3Y1eURnaOxtShXak9W4Rtq/B0Rzw1112uuxKLOY7WBV0GzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3651

--r4aze7klgyanajpr
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v12 04/13] genirq/affinity: Add cpumask to struct
 irq_affinity
MIME-Version: 1.0

On Wed, Apr 22, 2026 at 02:52:06PM -0400, Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
>=20
> Pass a cpumask to irq_create_affinity_masks as an additional constraint
> to consider when creating the affinity masks. This allows the caller to
> exclude specific CPUs, e.g., isolated CPUs (see the 'isolcpus' kernel
> command-line parameter).
>=20
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> ---
>  include/linux/interrupt.h | 16 ++++++++++------
>  kernel/irq/affinity.c     | 12 ++++++++++--
>  2 files changed, 20 insertions(+), 8 deletions(-)

Hi Daniel, Hannes,

Following on from here [1], this patch will be dropped too in the next
iteration. Moving forward, drivers no longer need to pass a custom mask.

[1]: https://lore.kernel.org/lkml/bnklzljfve53m33xdxv4mlu75kqrkpc3xooxgd3pn=
bvwjst5hr@btomkooj4crh/

--=20
Aaron Tomlin

--r4aze7klgyanajpr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmn6VboACgkQ4t6WWBnM
d9bIMA/8C2btBjysiL5M3m/kEau2B9dvIf9JITF5qSfdQY37WGdWcFYUa4eC+x9w
D7lUuq6jNjiBgaRs1vbcbteQO4w1z8ogVPy5jj+LuHzoMpKbL9Gi/71AoNtxERA2
H8d8k0dCGq3HnwkNx+itwpvQ2jl/NOB8OQK4NY3hZrsc67IU7RNo5NKbGPUnrdue
0u+HuI7SneD3DDfjKpFAVvjvXc3Ac53dvocF7mc3JYnehBAPeTKPg3RtmgN+P4xX
xWwnljTICW/q/Lm0G0hePmosvsccyd6dnrcQgHFluH2tjv4TxvSJFMsm20tqpH4P
QIG+u1gfLGxkN+4XaXaGfO0xEZnBkOCFsqwQY4+6f3kfxKO32uWNTymsVbuc3HHv
tsCdUCDdzCpa45HgeyUE8LMZYVTEc52gZw8oJIXVnMsE3av+1jHqyfvZUleWs6Qw
gBhP27fQQsLGXCP4PMv78AjGC62X+G6J+KC2EN6sAm0M/prqbFFkyrVGYH8OsSEq
Xt0vJRQMn30CMsK/J4wSe+eZdofJyReMX0R5YAL8yAelhjxLScgsKJIKAl9hOzOq
sE+IsDWQYCoZrOWp+xxJakW+wW18OwdSlpfcrCN1cxj+8o51QMom4KG1/HlM1Yiu
WUEKJqm1AbFBG+f/w6sAHDK5UcIQTse6TuEA/CaJxxlz80AoeIo=
=XJBr
-----END PGP SIGNATURE-----

--r4aze7klgyanajpr--
