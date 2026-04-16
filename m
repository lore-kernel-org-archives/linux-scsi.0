Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022112.outbound.protection.outlook.com [52.101.96.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E2126560B;
	Thu, 16 Apr 2026 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776346859; cv=fail; b=G1nPg2LlpQ3pZ9RLUObC5aU8vSgPMbw2fAQD0WRVqEie90136lzCcCGxRggAWDLRzWYrEbDmUPaUCLZJS2vl0N1HiGlQT8xMAimuN2e7bSUp+o+GCDKErJu0yPvHUo3jfOq6AexzwZoZBnIwZbBSS6dxkgKj2JFW3Hrlv+PVuKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776346859; c=relaxed/simple;
	bh=mtd3EVd3P6Q+Tjt62o7NkixfbwmsNz8vei5XwHE69CA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V07r8Ekz/ukPGepeKr2RPCTY2DlqhEtx8BR3UrmUV4kNh5eCvq5hy57KXdQC4sT0NG/1JdiDGKQ0Gl79L3LU2ga5mcDAucIDw6rM7JJkErf1yXspIIYQALOI0n5g2REtLf0GfiNs/iq19ZHCPKNlcyBqIhFm8WlY5omOvcFsAbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oN19tlZILbIQn84BcrN0GFM2CkpEGidQ3CwFeUvRvspGCaaATdCRm0OyFwRIbcCxNObcW+IYrrAXomTbKc1ktd82Af8VPtJWeBOOhcl1BqHa50WMb5cA0YSUvmpI1Bw7IoZ7+2V2IATNXhDCSyUg5bfqpmTP6hWmsFnD0AutS2iSJSN5B+Ti5D+mDZB5cKCYbRVfH3/YaIANPbTPF898GYkVE8tlpxPNztCh7jHLm03PN6RtOUfJ9dVIdUk/C0v6Thq2/2DjiRrDFeVetMLkq12DRI7X+xVxQe/mhO49Qud9FWXsq8qZMnghWRCDA1S/WAz+YMKsSwtTsjl9Eu0UYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtd3EVd3P6Q+Tjt62o7NkixfbwmsNz8vei5XwHE69CA=;
 b=NNMIq5ZZS0ojQ8rtnvyxto97UCLjg5zc1X05puR7OUoQTzmavKbShIWx6yaCQeLkFXy4sAbQIvW47zoK2hIqLKOwRGqRbQ2cJiPyRkg342/WNQDzjFBoAno3NBqQt9a0XfgJ85tNRbHi9IBr/k5/J1Hq+boqtICXhZkkepdVGHJpzVYLbEX52yVOCVHdH5KDwnBEx+igtYrB2QVn/pjfKTPJHlBzehYRRJQB3YzNCQfMaI/YMlhrCsfwAH8sFlQHLYaeIiKVnopordzbFfP1ut7n4rp5tjhvUYrX3hJbgolOx25F6lG//sGnCAi/GXEnoi1Nc+LwSLCZArXab5nbpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB8411.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:268::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 13:40:54 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 13:40:54 +0000
Date: Thu, 16 Apr 2026 09:40:50 -0400
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
Message-ID: <tgbghfg6uplw7hdzrujacevacn7npkwf3drqrpua4lib25tr2l@tvzdt7i77e2l>
References: <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora>
 <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
 <adpD8M8cNu3IZzEL@fedora>
 <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>
 <ad0Hk48y5JEeMlFk@fedora>
 <fouvg7qn7g4yah7jsvzkdmweesbp4aqmhx37gf3ow5medzvuyk@5n3ddkijosr6>
 <aeAx2g-nJQO2yyS4@fedora>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jsq37ysngafktak2"
Content-Disposition: inline
In-Reply-To: <aeAx2g-nJQO2yyS4@fedora>
X-ClientProxiedBy: BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43)
 To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB8411:EE_
X-MS-Office365-Filtering-Correlation-Id: bcc0684c-7ad0-4765-22e1-08de9bbdc80c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QCPtUo5VU3cXFFnaTfGwdbtmoZ6kuHjqpWfdUsW+x8so8MzVB19DOCGSbbIF/vxCQrNzK9ggSEko21So71n1CGHTG8zl0y8NRKRDu/sAnyePVeHjGlQoZGM5nnLZ5ZYKsdx7yEnvdfHBZwBYitbj6akELgyfD3e+EIazVlXlt6+fLGetjFcAn3r5+wHQzhtEgoLfGS6DxY6lu6lNiMoYe2Z1eXEJdZb1mSumiG1Jr57o62tiaXCYfy69+IwAeB9r7RA6QJ4Z7vBVE/mkSHxJvJItJia2nvZAPT2RI38Cq5KREN6V3Br8EN0SG6GcphncyihwPDuZJGjG3ZJuek3lTaCAmw4h9v7Hz9Xuhop28EP5QfvTs9wnXau5uhcl6peTsm1It1iSOer0fF6XDYU4rbp89YzAPTyOmjl8cKB8Wu7C528eUURDwXriqLHYOkF+Nu2cc7k2fR9HfrxL6V+xbKeBg9n4HbGzqnJLFHFPK59HkVDp7GQn5LSNQsaitWh0PdO8guWOTRiX88Cr0pPP5DhTQpSALwEBtZg3nTYAyh3KMH8RwQmr7bfLeg/Aru7RaPRX4slakuU1V558caRTNGYUK8ceyWfNqZaUPUNp+xQncySOs9IEO8+USdYrFtmY5zRB21seWbvQD+MPk/uxLRnZjBkWOccSy4dzRddbkFGawdFQNqI4Rzr5dv22hzZQu35e0ZgniPd0mgJm3/0F19Y6gUWeRP0wlZbz1rblOvQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzBud3A0VExqNVFBN2M0TENZYVUyY2ZQWnFka1piTDU4dUdHT2FoZ0FLSGor?=
 =?utf-8?B?SmtJZ3QrUFFzME9IMzhlN1RxSVNmZXlZR1o4dWNPNER4ZzQ5bHppNG5LbVR5?=
 =?utf-8?B?dGtNeG9JVkFYMkxORU5oYXdVVTluMUszeWRVZEtsR0FKZXA4S2V6SkxsRWxQ?=
 =?utf-8?B?WnRSeGJsYzNxSm1JS3doWUdBazM1OWFTOXV0VkFMa0owVW1jK0xxbGtWNkVE?=
 =?utf-8?B?NEt6eDIxY0hFLytta0g5WFdEWEJWcSttM2JJc1FjdlRicTdKQkpxLzJpaHRK?=
 =?utf-8?B?aVhRdjd5Tk14eGpmck5abXlEUFU5NkJZQkljTWVWVTIycFVRbmw2a3VEd2Q4?=
 =?utf-8?B?UnZKeWZyekFtc0I2c0FBeGd0WEhlbEtrZ3JDNk15N3EvMVoydWlmTm5tcGs3?=
 =?utf-8?B?QmdGTCtXc2xBRTJ6MllOcXNmLzY5RWZ4VzdjdDNlUjl5SW5UTWdUdXRQbzBW?=
 =?utf-8?B?c3pmZTZRMzFuNUdRUEduUHp4K1prNXhZa0ZIVktPaWVpY3NXZUtueTRoTWVy?=
 =?utf-8?B?UHl1WmdXQ2xZTWhGdkYrdVoyeTlsZ3JZQnBmbEhRUHJlbWNyd0dENTRBRHMw?=
 =?utf-8?B?dmRjY2hrQ0JDendIMG1jZVdWMGQzVmt5YkZGZmhTenNmbVpDVmc5VzJqem5k?=
 =?utf-8?B?QnZkVmkxRS9tUjRha0FnMG51U1lPbGV6SEEvQzNhdEdzSE9GUVkxakxwN1Fh?=
 =?utf-8?B?QTJmVEc0cFlzVGdDUFEzVU1kNmErWjMyM2MvM1M0QUtvaFUxblRlc3ZiYUYy?=
 =?utf-8?B?Vk51N3BiT0pOelRzdmlnbUNOcFRacm1vSDVRN0ZlN1cySzYzaGRJZFRGQ0lk?=
 =?utf-8?B?dm0zUzRVVGNMc1BUTnptWHcrbmQza2NidFFrWTk2RDB0bDQrVnVxMUdRUDU2?=
 =?utf-8?B?Tzl5eER5NzJyZ05FTXg2SVdvZnVPYjYwcFNzRWs1RTd6YnlzWXFlZTBZZkt2?=
 =?utf-8?B?dUJYVCtWaTFlOHpoNWlCRy9HUjloR3A3ZUkrT1l1RE9qU0EveFpyaERkMmhZ?=
 =?utf-8?B?VnlRamwvQVROUndZazdieWwrWmh2dlRkTzRqQWJRanJWUWI1dXRUYXY0bCtF?=
 =?utf-8?B?dml6ZFU2bWIxOXh2RTZOeHBaVmMxTU10NHFzYVFTVzVXRDA0KzBlaE1pd1VT?=
 =?utf-8?B?Y21pMko5QjR1YlJ6cVhjT0FXaDhXVHg1OUhOOUd2cS9LelBld29NN0dta3RY?=
 =?utf-8?B?TVFWUUcxVDZpZDAwZlBmRXUveDNpc25Eb2RMRVJjYzBjei9jVTJDb2FNMjVW?=
 =?utf-8?B?ekczdGcxeUZ4WXcwU2JPMWpKMzVVNTNqb0dXRjhEWkdkK0g3RnhBcWZNWWNZ?=
 =?utf-8?B?TmdWajZ1M2xleUtNdHlzRFJrQTJBcHU1K005VVdzU0ZhTTFFNVZnL25nMngz?=
 =?utf-8?B?SkxLd3ZNdlJTcUkxRzh0UkpzWXpRMDlveUh1eHk0STdrc3Jpak1XZCt3QUlO?=
 =?utf-8?B?NzNwZFdaTDZGQnljSWFnSTIzcnkzNmpXWjMxeW00QjFBY3oxWFZMeXdGUmtl?=
 =?utf-8?B?MCs4eFRLbXN6VmV3eTlnSVU1N1RsaG9pOXVRaCtNNHQ5ME4vekFqcTA4QXhP?=
 =?utf-8?B?Wnk2OW8rcnBCcEZtdGhZUHBha0ZtWk9Pams1MXlFMVFWSXVPRHhxMDA0SEFl?=
 =?utf-8?B?Q1RJU0ZtY2cxMWdEazYxS3dIU25JL1V5WnhKR1ZEeStCRmhVdWF3bDd5MVZ4?=
 =?utf-8?B?VjQ3azdYQzVKSU9lL3Fta3JPaU15Kzc2RjdRajNiVmhzdGJnTlVaRlJKOU9X?=
 =?utf-8?B?eHRzaGttc3BvcHV1MW1GYnRYYTNlK1FHeFE4cFl1dEk1N2ZOOGJYc084Wno2?=
 =?utf-8?B?eFM3aFJBcHU2RUp4ZEdqQ05ZTFd5ZFEreWlVVitmenIyUVZ2TS9RSkx0TVk5?=
 =?utf-8?B?OWhseGtQVzFxc0QxRzhMOGNxby83WmlmT0EvNUp4R1FrUVVpL20wN2h0aUVz?=
 =?utf-8?B?dFlra0hRWnpFK1V6SEwyeWxBNG1WU2svRVBETVF5U2ZUNnlzdnYxZkN1YlRs?=
 =?utf-8?B?MkhEZkhEQ0g1RURwa0dQL3Q3dDlZVzM4WFVxMnNwWW9ROTdGS1FabDZkZzBs?=
 =?utf-8?B?TnN0OTVDbUNUUGYvWnc2M3ZSejZRTk1aMjRQejQ3S0VPOGEvc0d5eFR6akQ2?=
 =?utf-8?B?d0ozMldEbENiYVJMbldYeGJKTW0rRURLc0RIb1VRTll1ZFEwcFl6QUtCMExP?=
 =?utf-8?B?VlFLOWVsVjFSb2RacEQ2YVNrWVBuMEYrcVNNTDlFazFvZ292bE5VZTN3Nkwz?=
 =?utf-8?B?Q2oxdFRXOERQdHh2aUUzZXJVZnhsVEFHSWFncVFBd2JjRFlHTmNTMXlZWEl2?=
 =?utf-8?B?K1MxbDZEOFN4TWFOTi95dHBQL05LYUJHMThJWi9hQTRNM09MVER5dz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc0684c-7ad0-4765-22e1-08de9bbdc80c
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 13:40:54.5061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htUR4NlQGZyIsjgsAcQqkYK0RsBTQz7LKk/z9inMavq14mg2k7FjRoBGK1ypkvRUsHO0vYVO5RcGU47sxfH9Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB8411

--jsq37ysngafktak2
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
MIME-Version: 1.0

On Thu, Apr 16, 2026 at 08:48:26AM +0800, Ming Lei wrote:
> However, as I mentioned, I don't object this patchset, but you have to
> fix all wrong comment & document & bug found in review first.

Hi Ming,

Understood.

Kind regards,
--=20
Aaron Tomlin

--jsq37ysngafktak2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmng5t0ACgkQ4t6WWBnM
d9bU5g//XqCf0cdqjC2MlHiLRxdLyF+qgUWDhkss9GqCKU7NrqWD2I+fRbvYSWoX
tgPzFXHFpvmaZQr39ornZe8UEFlpSrcF4nbi+o/7QRPh/Vsqx3bD53qtOaKxK4VM
Op+eap54wQDN4FzpHJYlz/aVBujEvc5SacwImTR1wgMLa3BobAWlUa8wOIvP0Hfb
i0mjtcfSOq0XgJ60YFYuZpdlPkvfR6ExtcSTF7AAZVFp5O7qZ+dMHTwTkH8BAQuL
qX7oewEqGTKarreKHIadJ0/ol6hpBdC8uMSpJC3ktjHqVZzNjx/ns6Q/fM06FqkA
JiW/761jBA1KvHfioTmpK85kn6QL7GlZijKHmPxgVnkcwmr3/6wLKk89yK5fgHv8
LJaY1whRz9OFo4fAVxUeQCAffYr2UY7J4oXF7s+fYxZTn21ZWE1gzicszoLqvd+f
iNI3YMHrnwwm08bvmdQwKZDxKhy7t19zgPAxWy0rQnDuzF59R1mSweoofCr2pNFz
PWiBcswhzmnVDDBS7lN8htMLyZLJBXZuT3kxnDq4Tzf5QsBrQ6/RNFujekYdHG63
737D0A8qeI1Z1VqPw4SCbyCw4YDo5auQ9dHieR47BTR8yAzaxQzvr6oh7ZLj0fiz
/yfmrjmMZveyELAwC8bO39OaCp/x7Q9IGeRvhv0P9Ky4xsRD4TQ=
=nihA
-----END PGP SIGNATURE-----

--jsq37ysngafktak2--
