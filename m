Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022103.outbound.protection.outlook.com [52.101.96.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A2D40DFCC;
	Mon,  6 Apr 2026 01:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775438145; cv=fail; b=Jh8pzX+RofXePxIWuejpBPx5lGVLmSmoLVgSB5DD851RSVwaGPewc3rhuUpwwBUEZLlxeIFEQaoYV4LoZyb5FKDfgNT3FSapCFyWVJ2g5zxFiuB4UMxSHp8BuuCbVStsl6Wb/U0O02ZUG5/kwPzwu4N1l04AFKQMGqYU6W6wS/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775438145; c=relaxed/simple;
	bh=aSVNMmnLnuDD6woK3mlQPwalp4a0L+gWue+UBY1xXnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FN+GBNqFpvsTZv/rb0Mj4UkVrdpv0PdLRZb2h6sOtaClQ4xGMnS5q6yDjQa8GZbLToRTMB/aizmQJWYOMdIbyjGG9BPpYIiS+0qHpF4bvzpvNozY0sqZnpLfxMDIxXKO2qo0DYIqjPjHgjMp0FTHLjKlN/PMKSgvPhfz1Zo6UUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bJuxukprHhRsNwdDHbEpNBUBVo6q+8HbrNL5Njz0I2JNsejNwlcQm2FhBeJiIY3gZwDL7sOIBVfJyc9ewsk8FzKS3iO4OLApC8eKtEoHPK6j4Uea93HCaVWByenZ5cyuPoyOQ2DlvvbVVyz+NtjzH376XTIRa1pQBQbCSzogNWfbjGr6uN4HAyBfDWYkrq3hzNivFgJVSobdHSeYyUuKWkjaVYSuoOBV8t6eAJvEx4xmgKPb2ZC5tn5Ypgl3I3VXQAQdJSOSa3k8uGvCWqyCZ7N9SmdgYLIAIDkp7WnSeVE+Vcga0+xytYMuOQrSmpsRJVg5RIxm9s7J6FJHKVRh6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5k/MgBZuZjYfVRvz1lTBcrHlNrYSK3llJsoxpE9O0rE=;
 b=w1qZU704OAG0Mx3jC2nrU5HdEGTPQ9gHK0chKcGMGhJ2tXqOAj3tMx2psNH8TlHNYjDaBdKzysJ4HaTcUWzf4YIJy8WL54Doki7X/5ef/l0m4YVS55j1S82aW289e3pKwFED+mbKpzd8jyOrutePgvwxIa3UM/NCUV+Rr9p+Jd2ENkFw4Bb1WBke8JrurswKMUA5FcP69Srczwa/pGWerr/HZJJ5F1Kqv/vkwwccV+hxaf1RJQDO8Sa3B+QK78G7rqPdqiTkij7AvXST3CmzTiBKt1gmDnsmFC/FhhmSDKmnRX88vG+VkEYYlSLZfASau1Zwd0T9SX6bH/9SYyqRxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LOBP123MB8939.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:483::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Mon, 6 Apr
 2026 01:15:41 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Mon, 6 Apr 2026
 01:15:40 +0000
Date: Sun, 5 Apr 2026 21:15:36 -0400
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
Message-ID: <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
References: <20260401222312.772334-1-atomlin@atomlin.com>
 <20260401222312.772334-14-atomlin@atomlin.com>
 <ac8l-w8ERG1YN2Wm@fedora>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="njnzdoupphczl3ro"
Content-Disposition: inline
In-Reply-To: <ac8l-w8ERG1YN2Wm@fedora>
X-ClientProxiedBy: BN1PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:408:e0::17) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LOBP123MB8939:EE_
X-MS-Office365-Filtering-Correlation-Id: d321f16c-b9a8-49c3-1a1a-08de937a0450
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	UXV5MgfnkDtwEeDDT83boQBvX7GCUu4zKRSU8/DxJII6s+O4MHUA0SC3GQ8Osb1Pa0b8g6oQIq/WXkQbCULwjfCSeCgK82ZsMDERogKprNl21+FHUdhxRC/kxcngnXpQTnj+dZ0Q01eZWcN1Da68ZNmlyuglslgRiNYUq6JFChHcVdinC3yaSqiycLCPllw6YGsKq8aKJrfy2qHj2vN9xNKnv88m4FdURgw5xlm6LVpkC5YiEpFZDvXZcHEu6DTDzHEUlQ8zkrOjnxd3Uv07nm5iV1d3HHyrQH/dqc/w5frK6JpqgEnFOafQteqKAhHKXls2OfCGlS8wOyZKPGkQfL+zK3FNYS2NBthbuDeOXAwwG+RmNaltAVhuvhkF4HesivsWLl47kPk0HamgZ1vYf6ocWqkW3IQD8ACrolQCMdmkX0X9rk2ISyAyks0U+n6Lc3ZoTr4+q7UBsaJfNOPF/QrLxGOUFWGDEsxlhCpN62mCJsWTaYaTSjpAT3scWlAD09NLcSVajW/SBBYjc/d+UbVPssHREM1n9zHtGpSfAySTVmfdD99/9XFyYiMr60YeBbmCOXiLnuyhpqG2ndK88eoKB9/f+yY5gVsLhMHZ5JqlhYKIG66LlON6yVjXGomSzA6tZ7avStAtLTfawBT6fpxwF4E7jkMNTAoxx9wxCOSoQFg53aO0lJ5JBlrLW2GJws+KxjbS6XHC0SsLbpliOvxXDsBiudZCCPE01bGQyYY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzIzK0V6QjFZWEJvVjR1N1ltUGMraXhvbmlJbFVnRjhZTzJEMWdteU5WOXFY?=
 =?utf-8?B?MzFQUnBGbXFKVHJEUnU1UjdsY3JONzQvS1FNRWpDNWE2UHRSSDJUSFZqWGsv?=
 =?utf-8?B?bVVWVkxhYVNFVFlxd3BhM1p1ZHF3RVpWTy9lM0ovemJZSE5zT3ZvcFpnS0s2?=
 =?utf-8?B?eG9WdDB0eXZCMklKZTN3eHE5MUJXTVYzV3RXdzhpUEc0VmVIR2Fqbk1UM1lE?=
 =?utf-8?B?aE9HUU0vRXhBeDN2MklUWEJCSnAySFQ4enpWajNvcnZ6K0NyNjVYeWhBVy83?=
 =?utf-8?B?TERpRXlvZE1xQjFlRDhhb3hSNVBlaU1FR3RlZnNGR1UrS1doZlF0TEw4SHoz?=
 =?utf-8?B?cGlSNjY0bVZlenJ1NktsdlBhMGtGeGVvcFduVXpEYzIrS2c3VVZkamJBNlRo?=
 =?utf-8?B?MVdub0dhYlduYkVka2lWR2Mxd3Ezd3FUWVhTZW13dmNkUjA2SmlTODV1U0ZM?=
 =?utf-8?B?WmovTDFlSTFjbjZwWTFUQjJnTXhGUTlydlBJNC8xZ2NZRjBKWTMrYXVKcW9a?=
 =?utf-8?B?UGRablBNYlF3M1dPb2k2Q0FLaHNoVGlxVlpFVjNLTHR3MXUvbndnSFUvTGlk?=
 =?utf-8?B?akRDaDNkejBZdFlmUUc0VUE5c3BVa0liZ3Y1KytwcU9HUlp0b3FGSHE2MlpD?=
 =?utf-8?B?SWlIYXFqcFkyTjdaVEprRCtkRGxkanF6RlREeWE1TVNqdE9XbGI4QXpodW5F?=
 =?utf-8?B?Sklsc0xBYy90V2l2dCsrMGNmdVV3S1JrUnBFVTIrYU1ORnFQVmxoYzZCeUhD?=
 =?utf-8?B?QVl2UG12Yk0xcHJNUXNjbzBDL0tMUG1SZzIrVjV2ZXNlUk1lQzdsQ2E5Y0FV?=
 =?utf-8?B?dWZWcEU5QmF3MS9CM3VSQVh3L3NYeHpKQ0FDZTZMY1BRZ1VkTDNqRHVnWHAw?=
 =?utf-8?B?S085T1dFbnhsdXE3UXZuL3d0WGxQekZ2blEwbG9pK0xNM2xrRG52WFA3N0Jv?=
 =?utf-8?B?RjFKVW9KTlIvRXROTjYyWHBoMHphUE5LSDY2c2hQWHovVUY0N0JrV3pMdVAz?=
 =?utf-8?B?aENCMTRKRy91YmdoQzNRUSs1MTJhblU2eFptZ25yWDZyTTVlU1RtNkpHSTBo?=
 =?utf-8?B?RytoaExDeUFWaXdkamRuOCthNVd6M2xCTjVJQTA1UDhYSHRVZmZEOGcwN0hM?=
 =?utf-8?B?UFNHeVU4M053dUhLQkJPTUlXYXQvN3dMSVRZQTVBSlRvUXZCbEFRRVZ2SlZZ?=
 =?utf-8?B?L0xxWEJ1RjRlSWg0dENzMDhEOXdady9nNy9idUZsTE1HcmFNT2E5NFA2WThj?=
 =?utf-8?B?UDd2blVOTWh1WlNMVDI0YzRWS2JuOWhEU1RHMnlTUm5EdXpaamprNGQzU01Z?=
 =?utf-8?B?WHRLVnc0UmozKzFGRFZwZGNZcU5xc0J2TXJweW5kMGh5a3NpQWxvWFNpZzZh?=
 =?utf-8?B?dlBPMm9qNUlGc0t1SGlnUSt4UUh2THMyVXo4VGRvdFlnR0M2cGFUL0hFUEpi?=
 =?utf-8?B?SXFOenViVG9EeDVMVjBsemh6M2x2WURiRlBKMmdRc0orazk5V3hSYldIdkZC?=
 =?utf-8?B?VHc1STJGNjlkcWt3TXVMYXZ0V1lEOUpXbEFzVXNZRHNPRHZtTW9aVTFaa2Zz?=
 =?utf-8?B?L0p5LzlmQkJLdks0aTdHVWZnVmwvMnlSakhpT0NMUHdzVTZIOWNUS2k5bjE2?=
 =?utf-8?B?M1dwK3NSeWhuOGxRay9zUFBRWjRoMCtQYUtVL010MzZsNjN6YjdidU8yMXFs?=
 =?utf-8?B?akM2VXZFNUZxMi8yK0Rjb0ZOL1BuSzFSYmhLQWhBZUdNcktzUmRtT2gvbWtH?=
 =?utf-8?B?TGxFZ2s0TDdZT202WnkwNGlCVE1JSEJhWHVYM1NEQmFTVGl0emdpYXZNWjFO?=
 =?utf-8?B?cDFyKzhWQW0rK1E3UjRoR1MxcWFoT3JIb1c4aXJlV1JZdXR5d1dNSmE4ZFBS?=
 =?utf-8?B?by92a2RGMWpqTStWNDBvRmIwZTAyUDNZem5aQjhQUmJmU3N3aTBvdkhZTkdI?=
 =?utf-8?B?T1JKb2lQTHBjTHpIdkVEZW9qa2RGR2l1RjFIUmp1cU5NRng1YlRlcDlzZTdN?=
 =?utf-8?B?VTlKS1VraTFjWWc4WjNTZmY3OGp6SjZQTmxyWHRPNVpJeExKVkdwYTBIelF5?=
 =?utf-8?B?VnVRTnBLejI0bUJkZVRmQVp4aGhlc2d4M0d1cnZYYVBZMkRnS29uU3hXWkM5?=
 =?utf-8?B?WFEzWUJUb01PN1lZWGNTVEdDK0lTMGkvZ2NoM3NuNE5uMHI2bXdpQVVoaER1?=
 =?utf-8?B?blhhbjl5amhqV05aYVRkMTY4Y2UrVklvTmtEVFVubHA4WWtOQ2ZwN0JxTmRt?=
 =?utf-8?B?Q2RWQWRLdGo2dTZFTjNCeTBXK0ZNZko4SVBzU2VGOHlJeGN1QjZ0Y1krREVD?=
 =?utf-8?B?ZkxNVnFvNmZjU0RTbVd2WXdNa0thUWdQOVQrMFNpamV0VDZNbUt0QT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d321f16c-b9a8-49c3-1a1a-08de937a0450
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 01:15:40.4570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fc8VhrfE8J7M+lfPe6S+Rdz9BvetRAmlWNnRi06jBXYWeF/t59ABjc5pFQBCvdOjztDNAzXBr6k+a+r6S42XYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOBP123MB8939

--njnzdoupphczl3ro
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
MIME-Version: 1.0

On Fri, Apr 03, 2026 at 10:30:26AM +0800, Ming Lei wrote:
> On Wed, Apr 01, 2026 at 06:23:12PM -0400, Aaron Tomlin wrote:
>=20
> All these can be supported by `managed_irq` already, please document the =
thing
> which `io_queue` solves, and `managed_irq` can't cover, so user can know
> how to choose between the two command lines.
>=20
> `Restrict the placement of queues to housekeeping CPUs only` looks totally
> stale, please see patch 10, in which isolated CPUs are spread too.

Dear Ming,

Thank you for your careful review of the documentation and for raising
these excellent points. I completely agree that the administrator guide
must be as unambiguous as possible.

Regarding your first point on the distinction between managed_irq and
io_queue, you are entirely correct that the documentation must explicitly
guide the user in their choice. I shall revise the text to clarify that
where managed_irq solely restricts the affinity of hardware interrupts at
the interrupt controller level, io_queue governs the block layer
multi-queue mapping algorithm itself. I will add a clear explanation that
io_queue is required for users who utilise polling queues, which do not
rely on interrupts, or specific drivers that do not use the managed
interrupt infrastructure. Without io_queue, the block layer would still
assign these polling duties to isolated CPUs, thereby breaking the
isolation.

Every logical CPU, including the isolated ones, must logically map to a
hardware context in order to submit input and output requests, saying they
are completely restricted is indeed stale and technically inaccurate. The
isolation mechanism actually ensures that the hardware contexts themselves
are serviced by the housekeeping CPUs, while the isolated CPUs are simply
mapped onto these housekeeping queues for submission purposes. I will
rewrite this paragraph to accurately reflect this topology, ensuring it
aligns perfectly with the behaviour introduced in patch 10.

> > +
> > +			  The io_queue configuration takes precedence
> > +			  over managed_irq. When io_queue is used,
> > +			  managed_irq placement constrains have no
> > +			  effect.
> > +
> > +			  Note: Offlining housekeeping CPUS which serve
> > +			  isolated CPUs will be rejected. Isolated CPUs
> > +			  need to be offlined before offlining the
> > +			  housekeeping CPUs.
> > +
> > +			  Note: When an isolated CPU issues an I/O request,
> > +			  it is forwarded to a housekeeping CPU. This will
> > +			  trigger a software interrupt on the completion
> > +			  path.
>=20
> `io_queue` doesn't touch io completion code path, which is more
> implementation details, so not sure if the above Note is needed.

Possibly the original author intended to suggest that the software
interrupt is sent to the isolated CPU?

To achieve absolute zero disturbance, an isolated CPU must either entirely
abstain from submitting standard I/O, or it must exclusively utilise
polling queues, where the CPU actively checks for completions and entirely
bypasses the interrupt and softirq mechanisms.


Kind regards,
--=20
Aaron Tomlin

--njnzdoupphczl3ro
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnTCTMACgkQ4t6WWBnM
d9b9QQ/+JCzx97YwazAkv5w1gsrM8tiWZz3fhUaWv71zRwkDQINO+Zcd3bvhPO9K
4sATmloBW7DbwO7saC90perS65z2fsOAD/WctFEFio8ukqHt6LO7e9U3PNBbNIjb
YqLZhMpFugHSDM8iJe59o+N6Yfrik7XWfT4LmeGtpMI9Ck1YYV/Xde1NO/iN73/O
GiNis+CPNxZQ0q/Bz5q4g/o2V8oldeamrkIJLKVIXTMZj4AZPpX4Hl6CSaUUDf9m
3/sHOlBzpIxADIuvV5Imk0sL4tjUONYHY3XiGZK8fMb3nK6+0NZzjkjuDg+sS7fB
+CZdwEcdNxIPj0z4iEA9KDkI/DfgVlrtS/cFgxMKSsmVnLR6glywCpNQyLEVORrU
kNPeNMLP6eyt1nn1+OuQe10EQS/gCUs1S3mI1H10JyKfTXZbtPHA5VOzdFcUJhfv
VRs0kWNNZwgLHzOcLC+vIYAyJczE5bYnRyeBGPciZ/7AY4zaVEMbLXl+yLiL+jZt
hPvS4x8sKBzbYlnGWcwwntJB/EXrwhdubdJT7HXresxRQXCYlnws5tEm7lDITAwC
2yQ9eWtjb7e0I5qk8gjuOhGyLZOOjznj/3N1no85AoH+qIt20jO2oSDs/L6qSPFl
7hQhSbqSfCWSkdncJ43VPsMOIkymXs49RFpO/bz54Jprz9GrXkk=
=W4yV
-----END PGP SIGNATURE-----

--njnzdoupphczl3ro--
