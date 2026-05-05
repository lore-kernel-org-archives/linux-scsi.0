Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022087.outbound.protection.outlook.com [52.101.101.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011A04A33F0;
	Tue,  5 May 2026 18:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778006552; cv=fail; b=F2PcdXRPE20io0wyOD6evgF0oOy9sxsQ2HMxQ/TtLbG4cB/MwmcPfzZPE9WgKK2JE33ZVGlvVPtm8Oaepv0XCx21ARJ7S6mpWmfu+16Rp/Q17I+L6AgT8KiQgonmWNHf5W9eajJgBw6obU63Y7SiNLQxPU6vyt2iVCzG4rAb/Xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778006552; c=relaxed/simple;
	bh=ycTtMOPtbODDsV2VDyGEWbIGS3YniwwYVA6hMo6/GH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sFe1NS9Jwa0m73cBMmJHF7VGhObv7Ox+5MluVE/9nLYfKPwSkN2JyW3jpuRJlMLPwnkz92zp07QIuPribPA0LNgbtbgeKJm8vlZnHr/5xAxjB2HOShXnYRUO+2cdT58jyCn+z4VSGFs85kFCtOfxiHUPCwJyXFF4JK52gV93BIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AC+pMnJpcpR9wOnNr7p3SA8+g4dKvEsyCEUERNEJ9+zBXMjhgDQSzF+MKnFxJMjJoh1hDEEdcV7UdpMFxKngJYK8/pEesv8QaVxrRPhVAmP/whAECL7WRJs0emBy9f1UJsxLSPVw4TXu1+ZefJ4R5HsPPUkRWqMMpQNQPyTH4fg1ubtXU/uh7+xRScsYYCUS/p+oi9E7QhiYgjbOq7aHVug5pJkI/jAbQOieHDVf8hACUMjvJqixuAkhaumdAef5FUWYpiaZweKHzQlr6qDlcD4fO+iClqsDwYmPKMLJuBkojbiA3v/DVgF/MY9u/9wpDEkmKKwS5aSGz0aY5nW/Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhOkxrjJVAkeKIK3dAvPWKkQjHjXGsoVlbiHamENfuY=;
 b=ad3yWO/I8/wgsWVl5jGT2YPD/BTnRHynO8/E5L9DBlnL2m1WctzOUeM2nGiF2noNekxwD8Ti2WaUVudnlv7zFhgPWw/uNDusxAzYkllPd0GToEuoiBmrh6bjbyQC0HFkMXpePMDuDboQRImn46/uN0iqVtMfFWX2+I/eFr8mqcgcEpA1VxgANyqR2PZUnpoXC0QaPOLEVahodOJibDV6cIMgSwEMqmbI819Hm25yg2P7MQHDRm3NX1dT6UlUscOxpjae5Ov19VXWxnZJvMJnmcq7I2tY5vUIhS1VB8dlo6J+b/uoRXK9ggUJ/cHZm/cM915hWkZaoZknYxqDhCe9Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB8568.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:27c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 18:42:27 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.025; Tue, 5 May 2026
 18:42:26 +0000
Date: Tue, 5 May 2026 14:42:19 -0400
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
Subject: Re: [PATCH v12 01/13] scsi: aacraid: use block layer helpers to
 calculate num of queues
Message-ID: <ipymclgw2laol6aqwabsbwqhvnt57d56hvbyr5qh5k77rfxos7@46xma5rhedm3>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-2-atomlin@atomlin.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lulx5av7ree2nb5v"
Content-Disposition: inline
In-Reply-To: <20260422185215.100929-2-atomlin@atomlin.com>
X-ClientProxiedBy: BL1P221CA0031.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::10) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b76340e-65e5-4abc-01aa-08deaad60d10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AGBl6n23A18w78qhcDF3FAlbpTG3ttcm1mBqWMHS42mIOCD9SOKOihYfYDOCuRFSDofnDkxY1HUHpRB5RoIlqDJyCQNIh7ammCgxg73Sp8QOqS7oBK9MGBWm0/yaFej/YVovNuDe6qEmaW1G/cJ5/xwlvXbPNtSEC442kRSc4b/bJdi2TPz5Gqt5SlQDsG3OQCOaJgZ11A6qhAIpnq3ybO0Z5MUtju5jbY9tCGirR24RL5qRH7pwmFOQvi3nF1ABVVRochPULTpiKX1LbJfJEcq2ZHGfbkIRFZAtrY4G9beKTV/234ZlXDDR0Z9M3MpIl8q6X2R2X0vE7+pwD2AkNreEvfr2aUfwPsRbEDYPhKIYS9hvcxAHOlRncDni0L18g82WXlLgfAlv0FpCjD5xwqzHzj4H4mjPS6RTZqE2YTTtVk8GmBDSAe029KnF3iwsXiXLlw1HCnVaSr3a0ZXdp0saO/3aLe6o7fQNwN6Fac/cZWKiv2m39EQ9vz7/7sNCNz4TWFzexm4d0jXc5ajRBGnwnv9tSGo9I2/l3h5/1PVdVZ8pblDiHI4bG8YV1mSSe0IAVhjCth04Pb/pB4PgoPvBugsJ4t5VU1T/vi4BGvtm0eUFWhuceoWvMVVrPjh/01bT02z4soAP8dL+NEzoMm+jEXR/gj321z4E2UL4ONLtyKEchzzPPbHOLxvAUQPb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0JyR0pKRFdOMVZNSjNaWGNBNDFyaldRckN1UFFuUHJXd2psa212STJjdVhq?=
 =?utf-8?B?TmNsMFdrakt5dElMazNlcnFzdC9GVStQbmZmN0hCK3VRVk01blR4MndPc0R4?=
 =?utf-8?B?cDJ4U1RsUVI4U0RadVMzMi9hVFdubzRibU5xcWlOaHRPcGF3cVNYQkp0eUhO?=
 =?utf-8?B?T0pobitUZjd0dGxhR1ppcWYzY0VOemd2S3FYVyt6RElGemo0VVV1UWtnajRL?=
 =?utf-8?B?OTk0SEhnNlEwSkF1Mi81eXFjZWh6SDlubkZQRkZuZFY4Ykx1SmdLdlNySXZv?=
 =?utf-8?B?eCtUMXdhU01INUtwSm5zODJtZkxyZU90SjV0b29FVDFJTnBhbEUzaTZ3eTJF?=
 =?utf-8?B?WkJBYktEaDVkaTZRcVZUTWwzQ1A2YXp4a3dnV3NlK1RJQkR6ckRERnl4WGJl?=
 =?utf-8?B?bVpFN0NwU1RRZFJKR1FxRUNPWDNQR2ltb1drdittc280NDRVVXdOUm9QQ0hX?=
 =?utf-8?B?MGlleVhkaVJVdXAzVmpXa05jQWdyRkdhb3JHZzFlNEFPVXYvNUhjU2Fsazd2?=
 =?utf-8?B?RmsyUExyQ3hMVjRhVEQvN3FwaG9DSmFlcWhRU2pHTzFETUtwWUdDRWNlT3JY?=
 =?utf-8?B?N1cyMU5NM3dQM2FaYU9wWEhFK2FyTmV0cEdGR01uWWdwMU9vYVY4QU9iY2ZP?=
 =?utf-8?B?SGg0RVVQNGNLa01NdFVrajE4bE45Qmt4Z1FvQVpMYkVsbExQbnFRQy9DYUNv?=
 =?utf-8?B?aERBc3I4QU1tMXdIWU81QWVuOEhlOHBVWG9CcGZrbWIrNFhzSmQrU3N5Q0VK?=
 =?utf-8?B?T3BscFVLdVRvdnBFaFU3ZmxmYXVkYlYrbDBFSE50eHE1NjNMcFhneDVOVlBP?=
 =?utf-8?B?ZE1JdS9neFp1VTR1VWh6NDVPZmFkTSs4SjhNWXBVM2lYekFqSVpodE1mbURr?=
 =?utf-8?B?UXZpY2tkeUludVYyTkRoWHpCbzdacThFR0xBMTFXcVptcFIrMTh4c2xJd2k4?=
 =?utf-8?B?YTNvTTBOZkRTdDZNVmt1Vm9PamNqUjVZcGNscUUrM3pnbnYzS29GcG42aHVw?=
 =?utf-8?B?ZlV3YjFJN2NrVTI3RkNZWUZpWTNqMGMyYXZMM2ZCL2l4NUxsSHJIZ1dZcEY3?=
 =?utf-8?B?S05PMlA2VFlxYmI0TGNFWmk3UUdDdm9HNW9LV0tTZlY3RllHN2h4bFNiSysw?=
 =?utf-8?B?N1FJMkFuNXEzbDJXMmdQSlBLUncxUklWVFhPYmRwU0FZL2N2Z01LU1M1UzBO?=
 =?utf-8?B?UzZ6blVHMVpXTFpOdXdLRW1FQ3VFWnlGeWRWdDlXTFlhdmdiRk1XN05EQU5s?=
 =?utf-8?B?ZEpxWGtQeVdxK1FSNWJKcU0rM0wxMCt5TjZ2SnUvQ2dPNm10d3pYcjJzVmw1?=
 =?utf-8?B?aEYyVzB4bVNNbWpaeVFTQUVwNHVrNWZlam8wcXEyNFNKU214cS9xNUNvS1k5?=
 =?utf-8?B?NVE0RjJzbHQrTms0OGw4VjZaL09jR2xjUlJvTW1vOXZNVWNFc0U3RmQ2aU94?=
 =?utf-8?B?N0lQSmZyWXgrTVFnaVlYbmhESTExZjhmU1JOaUJYT0RsQ2JoZzVtWWpnVis2?=
 =?utf-8?B?amFSenc1MFA1aUZLVjhtOEE1R0FKZEhkYTFhQzJoZDIwaXZFWmVwaGsvc0dX?=
 =?utf-8?B?cy83MDlhS2UwTnJ4WEZpYmxqY1dIa01RTUtmek81enlQOTdpRjNSVXZ1ZHI3?=
 =?utf-8?B?RWFRQzJjbUVJN2hpZXhmZ3VFakt1dURjUXpVQjFTVnhBajBSWnRsYk0wSThq?=
 =?utf-8?B?Y1NWeHFwaURDMTVtSkIyQzZ4RS9IbzJNRXY3cWxXSG1acnIrc3cra1lvVFN2?=
 =?utf-8?B?aGFnMnpwTjVhVGJrUG9HK2FmeWdUVnhmNFFwaTZKNmtGTDI5OXJtRVJVWHd5?=
 =?utf-8?B?RFByYW8rd0pPR0w0MjJXSUFlVHJiRkcvdXZDbUhlQXNOREt2RjBwcU0vRy9B?=
 =?utf-8?B?VlVZTXFsS2pXWmQ2Q0prMUlHVzBDeHFLb3E1SklVRWZCWGJJMDg0eUwxV0dN?=
 =?utf-8?B?UVpPekRYVy80QVhkREJGMmlxZ2xuUVZwa0VvWXFVdTBlbDBMaGtKOXdlVXlv?=
 =?utf-8?B?dHFOLzgyVGV2Uytwa25QclloSlE3MGwza25TWnhudDIxNFVGeUdVS0I2L0Vh?=
 =?utf-8?B?M3VGM3lRdHRRR0F1ajl3cHNINzJZOWR5OGVDYkZYWFpvb2I1ZXZIcVpuSE1k?=
 =?utf-8?B?MlJhcnVRSUc0L3g4aVNOTmlOdTUxVGozSVA0QThKLzJPVk9tdlVtMzFOYWFH?=
 =?utf-8?B?STRZWGJQTGJwZEJscVlpN2ZGK08yRHZ2VEhWbWJFNzNFT2ZyNHhhNEN4VndI?=
 =?utf-8?B?SlcvL1dQVmVsWUhralE1SUcxTEhNQ0dJZUx1eW9rOEdCUGJIMzNGV2NvYjFH?=
 =?utf-8?B?SkV0eGxhdHRuMlg2a1lnL1dIOWFPTWJTWmVSRkMwM04zNW5vVGgxQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b76340e-65e5-4abc-01aa-08deaad60d10
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 18:42:25.6991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gx5JfUI3huAHynU/48gplf9ifcsXRZXgFgF7yDs3n+e1Jx/BJWEUC9xKZumWAo5e0JBX6LRtLE2FaQh/aZ5Afg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB8568

--lulx5av7ree2nb5v
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v12 01/13] scsi: aacraid: use block layer helpers to
 calculate num of queues
MIME-Version: 1.0

On Wed, Apr 22, 2026 at 02:52:03PM -0400, Aaron Tomlin wrote:
> From: Daniel Wagner <wagi@kernel.org>
>=20
> The calculation of the upper limit for queues does not depend solely on
> the number of online CPUs; for example, the isolcpus kernel
> command-line option must also be considered.
>=20
> To account for this, the block layer provides a helper function to
> retrieve the maximum number of queues. Use it to set an appropriate
> upper queue number limit.
>=20
> Fixes: 94970cfb5f10 ("scsi: use block layer helpers to calculate num of q=
ueues")

Commit 94970cfb5f10 was a refactoring patch but it did not modify or break
aacraid. I believe we should drop the "Fixes:" tag and use the following:

    This brings aacraid in line with the API migration initiated for other
    SCSI drivers in commit 94970cfb5f10 ("scsi: use block layer helpers to
    calculate num of queues")

--=20
Aaron Tomlin

--lulx5av7ree2nb5v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmn6OgYACgkQ4t6WWBnM
d9ablA/8DPA5XZOuwm2+ZxczNPy+0djdx/Ba6I48QLmXUtByVVHoCJS3b+E5HaZj
HbktiIrn4LY1LOVs9hHpRNJCLliRhv2DBqSSodCs9LAXt0UKTd/0SJQTnAUMCW+T
wusVO2jDaWADwIaxwKCHoP730sb2Vv4139/tVV10LJc2otreKSNcjs6HFa/8AxIA
ZSgGUjjpaPYCt72i32HClY8TWdzml1+63fMrnAjOv1ROwUF++dvtSoZ0p4Cu6Stj
RKbFm+SzIiMkRBFWunOaswa1vOKS5RUuIa5/T8nrR5E87n8wG9Nns734znAfHIVZ
9HEVGSUrDEdqA26/GadpXr9tcDtaMTgKCMIhSbRcDp2BXlC1xJsnioQQFertZTs5
wtYfF6k4/he/WvsYNCJQhnMohLdU9o434t5D8TB11w5zefG1/uUPnP0nSz2772XA
Y0jVnVMB95myLeUUdkG1ao+Y8Ynt0jQ3/phexPxNUKe/+dQE44abnVxNJoBYWXeq
PqF87EJNW2jNyNU+3ULTy8EuKQxj1XVY2s1nV8V8UXvGfCCrzXOsiKO5wuHn8M1I
NKGoeIdCpbPUIWx23swq9jDq34XMh5D5uvqgNcM6tSnZlhPplLbA1zgEhDG3moWk
61Q/9Thx7ahuWgMcZy+dpbMDRLD+kZQQGmw+DrsNCVsFM71FDes=
=CeOH
-----END PGP SIGNATURE-----

--lulx5av7ree2nb5v--
