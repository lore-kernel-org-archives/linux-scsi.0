Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022143.outbound.protection.outlook.com [52.101.101.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E782F39CE;
	Tue, 31 Mar 2026 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.143
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774964315; cv=fail; b=Mq3XBXUsJCX++tJ8s5ENR7t0ATLCl4XXBTSoqCEA+6JWv7IQRaI2CWqUkWqw76Ps1JfjZ9nL9DQO4gBnp4NwGdPlBc4VIpGTwwUh4dHJC9REht/GBhswMgFONoohUZxkNybJwN6l+aJ9tcsgEkUDmYhViXXVpEbIEzVekIDr4oA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774964315; c=relaxed/simple;
	bh=Frn0D8Q9IR8zZzf56wCiD+ErHidJ5N2S7sdWgAsYyRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GQgzzhlt4KjZq6axnCTnrpS7n+UzN+VASI2KSShTn2aj1PjIqm1p20ulmIFG7jPvdv+sSuCXXWgBalI1/dnnS2iCilRAwROhOGrXcbZsM/wncBo+A/xWQUJZ3BYV0U6qI4coNLVtdmKhpPcrRxZ6N5m2cPwPwzIfGxGKWPYaH6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rt0E+dIVmIujbf4Pk3m+SRZ+V8nNkACif0+gleyvzBt5LRuTaFXEmIiV6bnbPH/7mH4HwJe35E1VLcq8JrIEliTeehmCqc81/XHUjV+x3rS+tkQhpXLW9DLFb7XdEyYJ271KHZ/zyyBFVW3kQxYsxpJdcJlrA944/S6v2XkJ56QNtDKpx8aAz3vl1nXcJMMK2JtGw3V51X1nPEZMAPdlekQZhzkTzg7mPDkF+UN38baxUBCAj9ojIxfVQfJMGN7AvMdSxBpMYhrGaRn1KpDZN5dDDshpF+jLdAf4Di1KtC13tJet7MkkUGd79JiMjV2RuMZX+Pp6wDJMeSACLbWKyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Frn0D8Q9IR8zZzf56wCiD+ErHidJ5N2S7sdWgAsYyRg=;
 b=WKjYsXc7yNaS6WWFvhzvao/O5O01/8eZ/9adb5GuMzL3rkNdyyBM7S2yG9pUtVI8Y9/dYDf+2fbQJBjdleagTL10uqBepZP/zQidNWVu+tPn3167jersic5+Foxt8Qkiy1qBt/aUe8xvssdQZJyd/rogyeJyZEKf5w86PCZcXdHbsHFX6s3TRiy7etZRWnHdP7gDf9uSeMNdilWqyjVkouMOu0F9f8QcQetgw9zP/bSnsOPl1MC1jzD21DrP0Pb3UUlNtByNIO+MThiLvd9UyLEPmvFFEN2Z98QS6rj2gD2t369pOQEAshkTnE2WApotZglNty6IsnM5l/7uZRtKyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO7P123MB7840.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:410::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 13:38:28 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Tue, 31 Mar 2026
 13:38:28 +0000
Date: Tue, 31 Mar 2026 09:38:24 -0400
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
Subject: Re: [PATCH v9 00/13] blk: honor isolcpus configuration
Message-ID: <d7tpb63momaeufwu7o3syov4dn6bcix7rn5rhyvvvhc65rp652@sie6b7vi4dml>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <acsc_GHv7Q04U1db@fedora>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ccto2smyg2cbwx4v"
Content-Disposition: inline
In-Reply-To: <acsc_GHv7Q04U1db@fedora>
X-ClientProxiedBy: BN0PR04CA0075.namprd04.prod.outlook.com
 (2603:10b6:408:ea::20) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO7P123MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a1f82e2-0a0d-4dbd-22fa-08de8f2aca1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	h9UDNpEpu/60qEs/Sd6IK1brGC7i4faxOAH1BKJnzO2LY+KnOURwb4bTAzpelZhUoH7OpXStdVXNSVuglswNa8UWX51LhTi11XmtHicKdXBhK10fto3BGE/5USExqFqztJ7a7jtTQIF77lWLoFCLRvGl51fhT24GoEcTutSgA1V+9X0Pym/K4FEQB+ia5LiVKyxjT3FNQUm5Qeb5D4A/GT/48e3EZOWQNnfDKV6NzRfo8CGykQGJPiRMvg2AXHq+WAU3MHOqh+bAk3F6/N59AsMlOaFnz9s+CiF+AdIgEnl3eUZFDWpOMGe3R7QDhkvbE8Hhlfq9mncujEBsgrjWe7AIVSZJ/43sSn6HfmTh9quUgZgcFUVfTXeI/m4c7BFUOzICn6gTmv11tb1dYf/3Pg3+Q8bRjyn8nd2NX21nLb6rLoukwfoIwD5eY0u97kgWW4d/h0MviMVFpyhRHUJzK/kt1GjlcQ+CCS5CwQFEgO1IYNiotT5rY2grsa9YnkH0FS8vTlMUKOI/ceSQtDlOz4F1FU1UpHeJ4+DCA6qSvuPeGNTN9Zb7cl2rcWt+oHg6bS3/3fZfAQlUGZh2aXSEBYEWL4DI78xOGDATV5buGUHonnuBq5VX6JlqpN0svZC83Sr0VTrOifIkldS3f7zGvjM/IekmX1X/7jAsNExcQ1/OalkYCM8+BVRupTxgxbnIEGsy1DENXe4JOBL0jNNYNQRV2cmM7fyzInHCY8rjPng=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnBGUURPQyt3VWc4V0p2ZnkwT0REYmVEbFkxaVpubmRubkhScHpUMnk0eWFv?=
 =?utf-8?B?Z0pvaHdMZkg4QklaZXJXZDhIRXQ5ZXNRM3hROW16SWFJMGpWZUhjNzdXRnRn?=
 =?utf-8?B?blZsTXBoL0lHR2JwU2tnbU1Rd25IMjBoeEk2dEZpT1ZmN0V6czNJRy90WlBa?=
 =?utf-8?B?bnpveFIrb2xUcGwvMlYyZTltNTZEaWM1R0hYRitHeGNjT0xMelJ3Q2RoMm9T?=
 =?utf-8?B?UStmRCs5bXZHei8rNUYxcUZnZjN4cE9PSGdPbGt4Z1dYODdMemlYK3BvdG5B?=
 =?utf-8?B?RGFaYUxaSDV2MENEdVpyMTVobzNCMVJ5RXFESVdScG9XS0NSRS81L2JYUTlj?=
 =?utf-8?B?TFhTL0o1R2pMYThUR3pweDV5UVozLzBMdi95aGVKOWpFeVFTMGl0QU9YTi9R?=
 =?utf-8?B?NXR1clF6TTFRQlpCTXhvcmgwaDZ4ODZjZ1VXUmkwa1ZPaVRCNEFuam1wcWEr?=
 =?utf-8?B?VTR4Vi9OUkh3RWNQdGM4U2lqWS9XRjA5Z2NtU1A2S1lyTnB1TjBQeWFtN1Vl?=
 =?utf-8?B?b1ZkVVZlV3ZVdXhaL1E3bHhTMUp1dXNIVTd4TS9oL0Z3K3RaR0hIcEY3NGxq?=
 =?utf-8?B?NnVXSlp4MDJ2Ryt1WURydXZrNFNEOCtVKzNhb1hXVExGc0Uxc3ozR0k4V05k?=
 =?utf-8?B?T2tGSEV1QjNRS3pTcFFVMkJhbmgzdzlvdzBlc2FQU2JiN2lSWEUyYUJKaTVk?=
 =?utf-8?B?eHQvdTFqS2hmUGZDRmhkNXlYK2FqSDBPSDZBL3JrZlg1V2k4b3NrZjl0eXJl?=
 =?utf-8?B?ZHJJbCs5TnZjaUFVWmpaL0xCeFpsRkZPU3o4VWtSdDRUZnVVbk9HbHBIcVZQ?=
 =?utf-8?B?SE10bHdxRjZ2b09YVitld2xVbmZaMmV3eWtaQVkydmNZUDJSbUkycU1nZmFu?=
 =?utf-8?B?MUp4OVp0Z05qazFIdFVQR2tuOUtpTks1UGw1cys5U2JNcDhsWG12czRlWTlX?=
 =?utf-8?B?dVFvOHhzZnJ5enA3bDdXVWYyK09UMlhFaE1xQk1KUVBKREU2Y0Z4M0p3RzBp?=
 =?utf-8?B?MGtmdHVaYmEzMnVtaTNhWXhObmp0c3htTEJxK005bW90Qlh5ckpZMmI1ek8w?=
 =?utf-8?B?QXhRSWFBS3hBUTVxcGphSlVhNFJ1SjdqSnJtL3krNVB3bUZWdG9FeVhETVpy?=
 =?utf-8?B?ajRyNmVENUJTbVFlcjRNUnZnOUtHVENYc2liUDJGK2NNVmVPL0tuRHJXVmFz?=
 =?utf-8?B?VHlSL28zb0VpRVJIcy9HNDErcG9wTmJIN3E3OHdGcXVBVXl1cEwwekpQMnlz?=
 =?utf-8?B?RzNpbTNZUkxWMlFiQ2YzNFgrTWtZYTRHMjcvQUNHMUJkUWprV056OEduMzYv?=
 =?utf-8?B?Q28veHR0eGhtd3U0MmFBZnJkRnRJRU9EOGZueWdldVJld24yL29tK3JObGhF?=
 =?utf-8?B?UytPYXRLQjdGak9JT0kwZndFWC9GRU5paDhWRFZXR2gwMWJTVlg3L0pPL1Nq?=
 =?utf-8?B?Y05RUEFudmFudzA0MEZnT212N2ZZdUxFNnhEZG41NnZESFYwMUxmTXVHMERn?=
 =?utf-8?B?c0h0Qk1YOC9abFlWQTk5VjlPS1BHK2JwMytlajY4RFNHSnVpc0Job1lvVldY?=
 =?utf-8?B?Um5wdUhEbGFvYm94T3poN3lXU3dxMXUxTzUydzhDencwNzBZZWFoVzd5ZDMr?=
 =?utf-8?B?MTJOSUZQTHkrbDZmT0dHMUlxVnhHSDl3Q014Tll1SFFucnZvUnVpRTZ0bWRS?=
 =?utf-8?B?U0hXd2dyNEpqc04rdWVuemp1Z1JNRDQxMXM4QTFYL00wWFlXSXhpeUlWbWN0?=
 =?utf-8?B?L3FxM3Q1R2xtTFpISmYxNDd2OFQvUXRGdU5ZZGtuVmJMRGl6ZzZtRmcrVGlP?=
 =?utf-8?B?MGs4K2cwTVBlTWNPYk1VNlFINmx6S2IxRmVmRENFR1BhYU1vMmJTdHpvdjFj?=
 =?utf-8?B?RTNvR211bkJYQm1yZ2RUcmFCa2xLY3M2S0RGSjhVcWNCYzFWVVhIU3V1ZExp?=
 =?utf-8?B?Wk5RQitBMXNxbDloaWdsTGtSeW1paVdNaHdRNk04OUpXRjZvVDdzT3pweXZJ?=
 =?utf-8?B?eEt3ejU0TFJXQzZjWCtTUWloS0NmaFNPbkttS2FBYXVwSGdpU2hpTFFlMnJy?=
 =?utf-8?B?ME1ZaThFTUt0a3c0NkREaFgrTVlNS1lDNHpMQkx4MEZpdC9vcW5WYThxWmU0?=
 =?utf-8?B?ckducnJkeE1hSkliRTlpdytabkdnazRLRjN0YjlKRTBWeG9mY3hjTjFJVHhX?=
 =?utf-8?B?N05GdUdIOStVUFEyUVhLUUxwaVFXSDNxejByaG1aV09yUkFNditUQkwzZHRl?=
 =?utf-8?B?YzBNU1lMeEltMTRzMFF5NnllbnBXSVRmVmlvWFcyTzdkYTlwNS9nM2NHY2l0?=
 =?utf-8?B?dVJHVXI4dExmYk5BckJtck1TOXhDdmw5RU45ODdiaWd0U0FMWndFQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1f82e2-0a0d-4dbd-22fa-08de8f2aca1f
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 13:38:27.8532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VDG+mAroNBLtugKoYIem18gI0VPkb93fv4r+8k9C5SwQo+Zzbf+lWeBmIJpKjyzDZ+aCj/rFzfr9DSatdmHXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO7P123MB7840

--ccto2smyg2cbwx4v
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v9 00/13] blk: honor isolcpus configuration
MIME-Version: 1.0

On Tue, Mar 31, 2026 at 09:01:48AM +0800, Ming Lei wrote:
> Can you share the bug report link?
>=20
> IMO, it should be solved as a backportable patch first if possible.

Hi Ming,

Thanks for taking a look at the series.

Here is the link to the kernel test robot's bug report:
https://lore.kernel.org/oe-lkp/202509101342.a803ecaa-lkp@intel.com

Regarding a backportable patch, the NULL pointer dereference is actually
not an existing mainline bug. It was a regression introduced specifically
by the previous iteration of this series, specifically by Patch 10:
"blk-mq: use hk cpus only when isolcpus=3Dio_queue is enabled".

The previously implementation introduced the global static
blk_hk_online_mask variable, which caused the race condition during the
robot's cpuhotplug stress tests. Because that flawed logic was confined to
the unmerged v8 patches and never made it into a mainline release, there is
nothing to backport to stable trees.

Version 9 simply drops that global mask approach entirely in favour of
local data_race(cpu_online_mask) snapshots, fixing the architectural flaw
within the series itself.


Kind regards,
--=20
Aaron Tomlin

--ccto2smyg2cbwx4v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnLzk8ACgkQ4t6WWBnM
d9YVPxAAjpzioSymLGTiMyL9YPgMx3OAPMvhQ93izn4Bh0m6OJmSDpJH16Ktfr0C
T3lwl6z/6OwcukpOTPGwoaatnAjVPfOIow7LiUkbH7TB9xVml3X9M4bhm+GmIc4a
CrpBjKh+s6LUfkaNNB4hlKdA8R9W2rbWLkfYqHwzOybQPshn3epH6kUpg35YDqvz
sZ24napFSNE/gPH9OjTlPDQLzTqF94UsBnM7U0lGNZOLGGcHLg+WPTkhPcLx3QN+
FKyp0AzkZYiPM+U99GaZSaynzp6lIcluEjVzjs1WeE9R9N87FPBtLYKN1McwFi+P
fxoLFOHhHHBV+qWt/KEPUJ4eY+ITwAW86oxn038pzi8os23V/lR4U6mtO5YAi0Uu
XdOLBdLg64/GNhJkdx7xAR0Tqc7B+fvZpWhTbnWzM423d0K1oAyNwPEb4i9owKpb
4/Im9SCCAtsH+TzEAyZwQ/QIVGuyCqz+K4Uas4jaVVTiVBDSucfJfcWw/se1tD7e
lWLZG+WV4qf67NGk7/K9BzFqcyFoNWDuqkLqJFCSHV9EWoImo1YeU28N8edI/U/s
M6oT39NcYzQH3ipOcpj8B/S73DejAqDjscTn2iPmFXjas+/ZMZVddU1piTtLTyka
/FO4xmmhSlmumedE9wNW1vp+QH/5BgPlXxMRF8S9+FbS1vJ8p1w=
=11Ct
-----END PGP SIGNATURE-----

--ccto2smyg2cbwx4v--
