Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020089.outbound.protection.outlook.com [52.101.195.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F12344DB0;
	Wed,  1 Apr 2026 19:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775071912; cv=fail; b=CEY02Bp2wsvjYlzsnMmHC7VftyUvPRs3qJaUhu0UywFQ7cljKs8j++4sWbu4jLu5nj/qeUl0SSvSyjbCAn0QRQgH8Xj2EKOwfSEDOY4KogbwqaEIilXtW+9i4vRih37c24cSzVNcET6zTY+HL8oZgPgqwY3zh3b/JPFY8dnysXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775071912; c=relaxed/simple;
	bh=25GgvNAoAVsQ0c0HPnOy+tdzboxsONyLGLWu2X3669A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rnISSV7TyAIfZV6vq7u5W2x5gp9GKkbr9O9dLv5MrrH6zXXI5zqP1gO1LPO2bseFyCRWUVpif20mukvVCqHMJ3ocHuF+RLBsg7u0gc70vyWkmO2oEyGXfYbRA1W8iZ1WkUjvYwU+t/M+2K31357iTe+yTpTWDOs9+Xr8u4WxLGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mc/Pp4uqLlTRaAxKz0VDD414ydd+fwdD1mYv/0H8RxfU4rCYwu61Uykq9NO5+cSChmGf/iwtItwnwhLrxXMCPG5IcBZBrLMaffxn/CB2sm9WUO4cGhFitTbz/9Z0FTz2A/OeZSU5GNG3/VUcAGIHxwULYDltPZF3+z1JIgkAtgwYoOIPdJnAq/y+3omPE9+smEH12oNP+MTm13BkAcpfrHhgCMs0AyS14qffiCDPUGvs2+VTm+d/6hLqoq13VAZqRPEioXWmL2LJS++ys7etY0ThhTCBLUWKtGDgafznxDDLlECDjYVijq3XXFh/4EkMTxH1TsBdcfoyolGNebbHaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25GgvNAoAVsQ0c0HPnOy+tdzboxsONyLGLWu2X3669A=;
 b=PJFpj+rtCZkhFQ2oJwQ0Nxs13YnXwlYKnQAi1QQ3q2/Ny5nNrYqFQjqR9m10xf1jCZFtfalUG0GPtiIfDzslvGcu++rFgKsT1fwqFIEqfNtMYgLOGkKZYoCBZQbi/B30J3Pc2SvMvH9/QxhJpstcp2t/k2RA5WuWDkbLX4odhWg8bLo80DfhsjpmWdX/Y2+3fUovtZLApyZBVs631tpmPVlx742vmVCX1QWA+NHW+oX/yFv2GxPP4hLLByU22l6HRSIAucXnq6l8nG5EAwBIifDtdXFMOYpbQB81P0e8eXJuK3lBvP975J6nR3wYqGYgBTABUZPDrs1x71sqdCKDyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB8615.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:27b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Wed, 1 Apr
 2026 19:31:47 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 19:31:46 +0000
Date: Wed, 1 Apr 2026 15:31:42 -0400
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
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 02/13] lib/group_cpus: remove dead !SMP code
Message-ID: <eli7act7zn7fzkoqa4d6zjpxl7wdoy3zebeib4bbtxpkvjr5s5@gpwkzk44gu77>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-3-atomlin@atomlin.com>
 <20260401122908.hxUnR63u@linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="txbfhqgc7wa7cjxq"
Content-Disposition: inline
In-Reply-To: <20260401122908.hxUnR63u@linutronix.de>
X-ClientProxiedBy: BN0PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:408:e8::30) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB8615:EE_
X-MS-Office365-Filtering-Correlation-Id: b1c5edfa-50f3-47a2-6cf6-08de90254fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Eym+5R8q7eiQw7AQfzI/aODBHIZ68620vavIAXs+641s3gr5zDszslA5bPRzFEp6b6JhqFNLiBiv4Ky5xgFTG0B9CO4Fx0EicWCDf9Rk3n3Mv0ywIFlHmn/zhSmnw2Feg9nbHXIaG2/Nri1YGAcu/oEoit5wh9JQt/AGXp5zWO+anVsPLlkVYSTx9NGqIFIVWpXL+ixGt57E1lmc6sFxKD3MGUErW/TU7TWQkqDE0zCnp5xgoO35z/wRLcL0uDf0MlZ7+DvffC2bGu7xvHzv6mTNLA5z4O6KIWkEgZe8FTMVNMckTDmlX4i2fd7gxoYTDT+Ksm1IHR0W4MuI5EGnY7xuOXbvazaZfPSKTii7YSppJ7qs9rCmj+DtXKTPi39lujFphrJmGG+g78F0x1eubmIXPQ5MmuDBskIYss8GPNOExmFDICJRPuq6Eon89VJzfnRNdPlGNJkHL/PZKnBl11yQ5GAPhv2SlEyDTmBFnETNDjkypZu9pKVKN5ANqoWoxIAP9Dx3QkU7tBi5/PLFMhEUhg49R0J1DQvAv/tYZOPC2CEqNnVsTERkwW0v4cmljeg3sEjwYvn1bR3bOwnhtF4kdHUvNnsO+bgRLxYInc2nsYRtOwIxW3DrJsLlkMDA1aTsHWtCv/19ODa4mgaWM7ljvMRGza65t5pDbkRV8xAIUVXbwPS4rycLF2MP6kJ5RaBnDb50vyhGs2fXmWZG2bP10QsZs65UKw9ZDZmjFR4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVBFUXlNQzI3M01TL3BJN1F6YUYwdThYRnNsOTE4RzEwMVd3WHJGMmVraElo?=
 =?utf-8?B?UW94Z3ZDdUFCa1gwUCs5VkM3dkJEdngxanhaaGtOL2UyeVR5WThEMk92SHZm?=
 =?utf-8?B?OUhtZmRqczNKenE5RUp6dEM0M1NJRGx1cWR0OElMWjZqQ1pQV2M0Yk5iZ1d0?=
 =?utf-8?B?dHBrbEg5M2ZUUXZ6RmJndE00SFJBQStPZHdKZm1Sa3RBR1hUQlE5eUVtbyt2?=
 =?utf-8?B?NVhxemlXN2VTaXJMMExlNVJQWFpWdUlKYkZweWNkVHFoejQ5aTBPVVpiL3Fu?=
 =?utf-8?B?U0pUUk1zUG5wanJoZDMzS2t1UTRmd1crMktHVnU5UTluUWpyQ2VDL1JhWlNo?=
 =?utf-8?B?aWNxbGNPdEUwYURKSm1wUnZ0SHF2QjY3N0hMM3J1YjEvaTIyUDNnMW81MzRk?=
 =?utf-8?B?SlJab1B6Mzhyby90UlZDa3IyVFgrUGZ6aUlaYjBWUzBGU0EwM3FVUVlnendj?=
 =?utf-8?B?cUNxMEtXeWx3aHVHR3Nhd2x0VDBvQmw5bGt4ZkorNFUySVVzRnFkOVdZQWdi?=
 =?utf-8?B?L1lVMkVydG9CdGFCcTZveFlUYWZmd2ZhQU5aQW9EeThsRE1mK1hwdDBiWUR1?=
 =?utf-8?B?RUQ2L3FVcGZJWHNsSUV1NmdNMDFBbGhldGordWd1K0NLT29SK1k3MGZZY1E1?=
 =?utf-8?B?RmJtY0RRdGVIQVArVjZkcDVvMm9oV2FtOGYzTWR0blE0YXRuM0pUUE5VVDRE?=
 =?utf-8?B?b2ZQdEVIakh0N2FTeStQaEVxeFM5bnJuek43ODJCU3VLRHQzb1BDOTRZWUV3?=
 =?utf-8?B?MjdnNWRpcjU4dUlBNm1vOGVUSDBYZ3MwaWJEQmNoL3pCMDBQVFJNKzRLZ2ND?=
 =?utf-8?B?RTJzRVZ3eXEwdTl0SnNmN3k0aGd5Yy9SbTNhMVM4MTY2WUlBNndhYkNjcjJG?=
 =?utf-8?B?dXFKSVNNbXN5QVBKQUcraExSUHllS3dzT1E2dzJ6S1N6bUlFQS9sYThpZHlP?=
 =?utf-8?B?WmduQUZmWGJmdDIvTjBFZkZSZmc5YjJxbDM2N3FLV094Q0JlbU9RY1JKa3Bx?=
 =?utf-8?B?dWxuNENTZTdxZVF4WjViNGw5SUxjOEc3S3ZWYVpRbHRPZlpTK1dMcU5rNm5D?=
 =?utf-8?B?SGlNd3NLektiR29LNDA2bnAydmFZQVJtTnFOVjc1dXk4V0ZsemNFbVZ6VkJW?=
 =?utf-8?B?TXNLR3BDUjBja3NtVXV2TkFLdjMyZDE0NytqalpqVjlRWWxDVHVhQ2FSNzgw?=
 =?utf-8?B?bE55NFYvYS9CTENFWWdGaitjMEpINHY3L2pFdFpsK09lZkRpeC93WFpNQXdy?=
 =?utf-8?B?QUcwei9YVlpPdEJwOU5GaVVVbTQrNHFuS1NicnRydHloQ3RCKzNiSVB1TDVw?=
 =?utf-8?B?L2lnTEtHbnpKUnpJRlBpZzR3QzBrQWV1NXVtNC9Od2J4MENnQmo2TVJrOVNu?=
 =?utf-8?B?TGJ2cURKTEdFcmFwQm9YcFNEL0RJekRQR3JFaExGaFZtaW04T1h2ZGlBQy9C?=
 =?utf-8?B?NGNtT2I0MjlKbEdZZVhaeSt0dGhENVVQaGRpSmNRcE5OSUxSR204SDdKckJs?=
 =?utf-8?B?blZyME80ejVzZTZkNGRPaFlPYjIrQWlmN0lBZjFsR1AzRGI2Q1pDV3ZCdkZY?=
 =?utf-8?B?bVQ4SzNzMHhNWUlmMkdNK25LdmtKclpneHFjOStTaXRrVUJRMW9rUmlFeUZQ?=
 =?utf-8?B?QkVoM01wamgrd1B6Mmh6S0J3S0tIYXVPVGIzbUJTc2VtL1NwWEU1S3lhR0po?=
 =?utf-8?B?RnVzYVhIdFdHaEExRTRqZ0ZrVW1CS3F3VDVtTkxNUVNVQS94Z1NCa2NkNjJX?=
 =?utf-8?B?MmtlNDAwQXR6aVZqeFZnRGJGbzMySEFZYkM1bi9OS0I2NHEzQjBwZW42SGVB?=
 =?utf-8?B?WnZwazJhZnQ1ckFoMTNCSkdpeHlMeFNuKzhoU3NORVNxWnY4SjZxU2FTSld0?=
 =?utf-8?B?bWFFMERZREsyQW5VRDdBY0d4SXczNUM5WlNKemxxbFNLOGFNeDEyMGI0eWkx?=
 =?utf-8?B?Qnp4ZStlYmRsdWhnNFh3clFpZEJxeXlLN0Q5dmRidDJlREtTbGtIb3ZsYUZ2?=
 =?utf-8?B?OUVxaE5MM2tkdkRRbVRQTlNLWVZRNE1ObTNKRHcrL3l1SlBhYzM2TjBsc0dF?=
 =?utf-8?B?bHNzSzVxOHhTdnN6OGtYd2dsZVM1TmdtMTFsVDJaR3JnNGtnc3BEczBmaWtP?=
 =?utf-8?B?c0kvNDJGNHJ0MVYrc3RiaUNUTXlEaGdmaWNYd1ZBMUZIcWFCVlkvbVk3N2Vi?=
 =?utf-8?B?c3dNMHhNM3N5d2k0VWxUbHFOdUFtbURodGIrRVk4OXRPNDllVjFvbkJjcjZ6?=
 =?utf-8?B?enp4NnBjQkZ0M01IZlVoZDhRVUtMR0VuM0haRnFMZi9CVnM1aEJZQVduT0tW?=
 =?utf-8?B?ZytnSXFtVlcrdnZDR1RCeWdXTlRURzU2eDNUY2M1WkZkYXF4NWhxQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1c5edfa-50f3-47a2-6cf6-08de90254fd0
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 19:31:46.6237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXlQ95394hlYN+JzCCHZgtllxUKCCf3gv6yBOk4j7kTsb/RFE3n94DWo9mCxMk9QSXKUOsWgkOsC9CTxY9/KQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB8615

--txbfhqgc7wa7cjxq
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v9 02/13] lib/group_cpus: remove dead !SMP code
MIME-Version: 1.0

On Wed, Apr 01, 2026 at 02:29:08PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-03-30 18:10:36 [-0400], Aaron Tomlin wrote:
> > From: Daniel Wagner <wagi@kernel.org>
> >=20
> > The support for the !SMP configuration has been removed from the core by
> > commit cac5cefbade9 ("sched/smp: Make SMP unconditional").
>=20
> !SMP is not dead code here. You can very much compile a !SMP kernel at
> which point the code below will be used. It is more that the sched
> department decided that scheduler's maintenance will be easier since we
> don't have to deal with !SMP case anymore.
>=20
> If you wish to remove the !SMP case here you need to argue as such.
>=20
> > Signed-off-by: Daniel Wagner <wagi@kernel.org>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
>=20
> The previous patch, this one and probably the following lack a
> Signed-off-by line with your name.
>=20
Hi Sebastian,

Thank you for your review and for clarifying the precise nature of the !SMP
configuration.

Fair point. Describing it broadly as "dead code" is indeed inaccurate,
given that one can certainly still compile a uniprocessor kernel. I shall
amend the commit message in the next series to properly articulate the
reasoning: we are removing this specific !SMP fallback logic because the
core scheduler now mandates SMP unconditionally (as per commit
cac5cefbade9), rendering this particular handling redundant for our
purposes, rather than it being globally obsolete.

Furthermore, my apologies for the oversight regarding the missing
Signed-off-by tags.


Kind regards,
--=20
Aaron Tomlin

--txbfhqgc7wa7cjxq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnNcpkACgkQ4t6WWBnM
d9YvzA//WO2Y3H+oDKPlR4+y1NRkMHTIQj0u35COgDSOqGBDbT/qcmhL6+Q2Cp5n
PtUHsCMPfeiY+Du4WuiulG71+h45S8FpCotp6u+m9d4Z1uHvIAZj8aFCKKiOxdWK
Pywf8I44OYbxKrRBMl/xB5eFUMKINZfa8xHU/xVU8yx+aN0PKpi3sJcYkutZaj/3
gpIGTmMrJyzBmSQew4AVTLY834GhZxXyiEtRSEs26kAPvxWTyuknjkjPAMbpn5FO
NCVC/mRUTTTCPE72XvoAkYclhDhpwxqJWNvFU1YCssQS4iBELuh4xeOrlAZUsASh
ZMmwNZXzpww3ITl265uv4AzXM1B3kk75I8oKxFg44+oR/POFG1a+NPAYvD1gLES3
lzb9M6EtCenv/hE1ySBQwXzKmNOgAve6+Na2/ebfit+mlLqAkSFwvZhhAmMBLsL8
vBRGfNXErnukyFmYZ0mSQvDSF12/4M2oFtLzYC2fBV+SvEXavfed4rnwVAdiqeTW
D2aus/lrs5dwB6SvKPfIFw+ll07vfuoq0e6bBdsCKX0yveBjFKBMSkM1iJpUvVT3
5YTQhpDtAXSL5oERUJi5ZSZEOjOK5ZgC11vFgs/F8MUwVTGSoq4Q6jfuU/egIKT1
WVej75bJR6lo1NjHInmwP0/ggwiLQGwWo1848N8TtYZRAI+rP/4=
=sKVn
-----END PGP SIGNATURE-----

--txbfhqgc7wa7cjxq--
