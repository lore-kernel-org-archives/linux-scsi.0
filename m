Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020139.outbound.protection.outlook.com [52.101.195.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115CE39EF3D;
	Wed, 29 Apr 2026 23:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777505555; cv=fail; b=YnhRapHbdRUhZcB7sIy0hcPkWv2KbuzauLhhoge01kr3CZ2ODcpHnUUn8xFDZ3MfCCH+Jqkz32w9fDJiLS8B3lVA8DEQfGoih6OOQZTAzIP23kOYGfVSfPYcP1FP4p/jrvw9TNiZgZLqV4fmuZ4klxK0htNvpJBL9T1LRHe2Tu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777505555; c=relaxed/simple;
	bh=kKc3VjlfIDZ4/nvRZFvy86K8Q3CG0qVg1vTyPrfQlzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SXHSPyih1JzOZwqvKtBYOXawMfByVoUuLwugSIsx8s8Cfm0bm/7t4ahUZI9HejTsaOl9oYcrgxCpjxaugWPrhScTPQnKlVal+mMO8T53C9+K5mMu29F4t3NT8uDL/qvMEncMAXDGP5wHswvUNBlDNr+McllWzc73ccuryrrCsrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x1RK/Y+RpxOLgu57h6O1rjXVyRpCJL2dN+DanlINsspAY/SeErriqkWUOTujlIjGbEB+JtY4gNogUoxxfg6zZCT5DRcvmq0+rrVQzMpN/yjcgVktAGQ7lAs9ACNYtGMFblycE472sBwp5XNp3G+WdsVdMRQsaTn5xoOk7nXe0CY/yqUMnWBcvh9NmOQu+SP9ZFU2o82Pvvo88TnRsw4Syecgt7Oj4ZSqxwCEUq5taTNHw/bnbzcn3j8nObNRH9+AqmqKRNsXC12H7+EOu4728KnOZJKnSZfhPXWhDfWLf4BTIMfBjoefxedT5w/x6t+BNWREjSu2gwJUT7yUE8xJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dawF3b4RaIWUEiy//po8fh6kJaB714rQDtdWg97njKI=;
 b=lMPxyQqjx3EJbOzNTAZ3+U1Y7uS9U+uP9S8dmXBIm7DGyufjYcGPk2ITKuE0yZ7kHzSVkoyS9sWp4tTDxPJNROB/TEqLeYUFsfaFsMSbQEYxLpR/AdHC/LiheA5VMCxE8GWeO9qODpGi+5JQD0uVT2gPBCTEHd48/1mX/B0wdbutl7RJffS63eNw7u+gDbTqPIAvNj0EYEMVj5tZTff3+dJvgGW87rQp00bxKJSeRpBgi21AgBnhDp8L1ia9fn42WkmXohyVAr7xPvoUm20NpIZZGHYXHxvgBD1c1HkFPiIYJJf0rjGMHcMcR6h4tgFH7i6wm3m0089MU7hX2P6zEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB6267.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Wed, 29 Apr
 2026 23:32:30 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.025; Wed, 29 Apr 2026
 23:32:30 +0000
Date: Wed, 29 Apr 2026 19:32:26 -0400
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
Subject: Re: [PATCH v12 02/13] lib/group_cpus: remove dead !SMP code
Message-ID: <v2xfjap2dkljbhz77d4437tbxj7tngm2ywiujgelpigvpphecg@nr2qtntp7lyk>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-3-atomlin@atomlin.com>
 <20260427152104.WTGAesGs@linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gjvyk77mxr2rqak6"
Content-Disposition: inline
In-Reply-To: <20260427152104.WTGAesGs@linutronix.de>
X-ClientProxiedBy: BN9PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:408:fd::29) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB6267:EE_
X-MS-Office365-Filtering-Correlation-Id: 03da2b25-01ab-488c-859d-08dea647948e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sczNzkK6M0JgCkgd+TFyVmmVS65ofhd3jmI1N7OJgL9NbMnxyez77Vh9C/bg/ut3jQ4FD8G2sT+V+sN67RS2N9gkxaMzPVHsPD7+/AbanRC1pwMyt4F9+U0M1Xpp+VKFJnDIy97kNvkG3kJupdykUrqNFwpAu4yoenv+xHj3oI0UUW9FWGKbA/8u85Nw1vJgDKEbLjV7i6LZ5TEnYfnQq9eUDI1B19GqHm3nt9W9QRFm0mq14OvQ19q72FzDJsfb0/jCtzkvJQx9I+stbuHooyRSGU/Ul48rqG6hZDIPOFZrTky0QRhSK9+MJtMp4C7U9sgiZ60/q1/acHdcz/ncdCyw9th6vu1LYWxfU/lda+mmrsrMQ9cn3HSSYXxjbG70HQ1h6cg34Hl2j+K3azvjLmpN45v/Aw00Gd0rGxavQ4/2pJDZLiqYnIdoGOKiYWspckU1iB1AJmquVpPjIjrMf88nIsiHJqvBxmw/hrLfrQMYiJHTmVB5+u7qGvcQZbwPPU9dcIDRavoUjh7RIFueg7PoSvqpVZi/UayXw3SdfAJxhP6hg++tM80M1ZSXYSHyNAgRJ2LRTZSxaYpi6W7iKc9BNZ5MYnatKE1tXyowvCIa/fRBDH/jcJOVr+u5CMr2Sj1a97pSAZi0TGOnW4VMY/X9giWIZmjsPQcU++iDrMo2g3S+vgTwAxZbZoaav1Q4WhdQFUxWnmUQfi3hMyzCFrwQtGDMYzaZ3btvZuVQ+Eo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVRrVFFPRG5TaFA4eUVqaFN1akVqSldTcWY5MjVGWC9KSVFqQ3hhT0NEYkhR?=
 =?utf-8?B?YVo0TlZCOXkzRDJ2RW9yRE9BRjN5c0M0dlhIdlJVZ1FzcGRta0Q2Z1B5TWxH?=
 =?utf-8?B?YnY5L29WSkE2dUZ6MWtKV3Z4anJaOVoxbGpYRnk5MUpXeTRYVE8rUEVZNzdS?=
 =?utf-8?B?SHJ3dkpYREd5cmxyOXYvUmRzRm1JeEtBOWpHZHRXelZNdjF1dDRoMmRMbXV6?=
 =?utf-8?B?UVErdGl0QjNzaGo3VVhSNGxjbmcwNEhNLzZRYkxVcy9kQjRkSldseDR2Y053?=
 =?utf-8?B?WGx2S2FEL2RCaVhEdnRBUExUK2RCNTN4YnRpaTVKTFhVQ1k4eHpMVHVuWVJw?=
 =?utf-8?B?bUgvOThrakVJV3hOVE5yZGRJNTVsZkpQZVEvczhmS1JQVlRYKzdyMVpjQ2xn?=
 =?utf-8?B?TDNjWW40eEsvS003U3dxYzdRS0lOeTd1elQzaUNiRnY1YnlVb0d6SkpmTmZq?=
 =?utf-8?B?NmdCaXNKQnkyVmw0OHp1c0FJM0RWVkp6Yk8yaUE3RWZHLzZvZ2xtVnNwSlRl?=
 =?utf-8?B?NW9wOXgwZ3NWSXVEUU9kTnR3dzR6US9zd242dmN0eFc0YXhaMGxKcy93emNn?=
 =?utf-8?B?YndpaFZEVStaQzgrZTlRNGJaQ1FBSnNxLzVXL215N1pYcGpvSnpSbUFvSmlP?=
 =?utf-8?B?SExsb3I5K05teHdxclhWSU1vT3Rwd0x2NXNEbVFjL2Q1eTBTNmozMFpRTWVi?=
 =?utf-8?B?UUVMUFg1VUtvK0RVYlFqY01KcDBNbTlrajk2SVQ5cUVuWHpWaW84S1FsSTZU?=
 =?utf-8?B?NFlxby9FNEtEaDhsSFFjRjdncXFJNW5EYjU3bUUvaUpYdGJlQWFYODRWK1ZQ?=
 =?utf-8?B?Q0JaZGVkU1E3TDRvQlZUeXFWZXdISnBwZDRtMWVueUh3MHJMK1QyUEhIMXJG?=
 =?utf-8?B?ZUlUbThadDVNaWNsTk0vRGRMNnFEYmxCbkpzTjQ3SVRYT0ZrYTBwUTEvYk1q?=
 =?utf-8?B?TUVlaXFNQUwxRmkra2xrUjlQdXozei84Q28xZ1NKd2k4cXBEblRCOGNXc1Zi?=
 =?utf-8?B?NFU5QW5TL0xuejIvWk5OeVpzaFpJU3gyU3Z3a1dXY0JlbDdZdW9XMkRMNTFo?=
 =?utf-8?B?eHhDN05tTTkvaTVPQVAvaVh3anE4cXRWcVRkWUkxNTR1WVlxTTMrMGg2MUQ4?=
 =?utf-8?B?UG5NSmZVbW9xMHBrVFlyeHJ1bis5dDhRbmhDaVBxcVZRQUZKUHhnWnJlVTQv?=
 =?utf-8?B?SkpGdWUzUjhlU0F3aURNVVdBRUxIN0lYRHJCekJ5UXZzZmVkWFdNWHJSTEQ4?=
 =?utf-8?B?dFZhTzBhVE8wK0J1QWFOQlZrTWtGYzFjcytHZmNMVHo0TWFUdk1HbW5IYlRZ?=
 =?utf-8?B?aE16TU95VWE1STJHVGJtK1pyd1A2WTNtTHM3aE8zTzVINmJYQ0RQYnBnTGVD?=
 =?utf-8?B?L3k2bnBXdlIyVE0rWDI2VGczV3F2cXlKb08xem9saU9Qem83K3crWG1hTHRH?=
 =?utf-8?B?c0dHenZ4VVhmTTNjWDIxTHN5V2hTTlNrZkh2MkFROUhOd2puVUJlaWR0KzlW?=
 =?utf-8?B?TEZGYUY5ZW10bWxiRllqQ2ttMTZrb1JYd3F2ODZuWG5SY3luOFFXT2NYRE84?=
 =?utf-8?B?dWZBeHlTcTdWV0c5dkxkSGVVY0FjdDFIeWNCVTduRjJhY24xRzBHcDNYZUJZ?=
 =?utf-8?B?Mk9OcWkrbWN6SmZoeGtzMUFCSmV2SnJJOEVpeG5VZVo5dXFpb0xtMXlmcEd1?=
 =?utf-8?B?WkpWRWQ2K1RtemVVVi9LWHZNUVdISk9LZzNhRE1zTzdOMm9FcU9XelAvMFRX?=
 =?utf-8?B?ZW9xWS9hQkxScWZ3NHg3dExIa0dpTFN6NXlhdy9BRHIxUXg4RXBpNE1CdVRj?=
 =?utf-8?B?eTMyTnlwcXJmQmZTeHcxQjdETVpIcHpiQy9nUnIreENMVlQzTUMvRE0yRXM2?=
 =?utf-8?B?RU5hUERJU2xVQy8rekFVYTRSUFNmdm56R0MzZ0ZIeEJ0V0FCbXRPcHZrSDZG?=
 =?utf-8?B?MWRtTEpOTExwT3lDcS93ZkgrUGF2UWZpaGFpcVgxdmVYbmJTTHJLMnA3R1E4?=
 =?utf-8?B?NGVLRThSMmxkbkUyZEZWaCs1Z24yVXVxVTFkZHczQWZZZG9zRWt6QWZlU1dh?=
 =?utf-8?B?YktzSHdJMXI0TkJ0TUx1ajM4NTBpZmJtdkw0RXQ2V1ZDWjBVWDBmenpqT3Bw?=
 =?utf-8?B?Snp2RnBadWNvRHd3c2lsK3E3L3Z1N0orZ0J4cDlmYXNEb2g4dk5JVjJrUWlV?=
 =?utf-8?B?Vk1Ud2xCTnA4TlJRSDR4VEdPSWdoMkFJZSt1MGUvUExaVUM4aHpTVDFwaE9m?=
 =?utf-8?B?QTBHQkNRL2k3dWpnN2p0d25qbUZoQ0ZNeFM3TjdEekV6SXFNekMxTW9DVEha?=
 =?utf-8?B?Qk5ZTEoyVFZZZzJuaUwxT3JNUFFTMlZpaG96d1ROaTdWaTR0WGs5QT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03da2b25-01ab-488c-859d-08dea647948e
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 23:32:30.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAZArLuWVPQ/VDcsaSI1TNs2ibLgrxNUwi4/lc4PkpOSRjQKK6/t0MAFH/J2c9RRpQtNVVOENyk8iaj2p3lGDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB6267

--gjvyk77mxr2rqak6
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v12 02/13] lib/group_cpus: remove dead !SMP code
MIME-Version: 1.0

On Mon, Apr 27, 2026 at 05:21:04PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-04-22 14:52:04 [-0400], Aaron Tomlin wrote:
> > From: Daniel Wagner <wagi@kernel.org>
> >=20
> > The support for the !SMP configuration has been removed from the core by
> > commit cac5cefbade9 ("sched/smp: Make SMP unconditional").
> >=20
> > While one can technically still compile a uniprocessor kernel, the core
> > scheduler now mandates SMP unconditionally, rendering this particular
> > !SMP fallback handling redundant. Therefore, remove the #ifdef CONFIG_S=
MP
> > guards and the fallback logic.
> >=20
> > Signed-off-by: Daniel Wagner <wagi@kernel.org>
> > Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > [atomlin: Updated commit message to clarify !SMP removal context]
>=20
> This look unchanged vs previous submission. You could explain why you
> want to remove the !SMP case. It looks like the !SMP makes things
> easier ;) I don't know how much of this gets removed because of !SMP
> code elsewhere.
>=20
> The description still does not make sense/ is accurate.

Hi Sebastian,

Yes, the !SMP path does make things "easier" and lighter for actual UP
builds by bypassing the SMP overhead. However, maintaining two separate
code paths and #ifdef guards for this specific logic adds testing and
maintenance burden that we'd prefer to drop.

The reference to the scheduler commit was meant to highlight a
philosophical alignment-trading a slight performance edge on UP builds in
exchange for a single, unified code path without #ifdef clutter.

How about the following:

    The core scheduler recently transitioned to compiling SMP data structur=
es
    unconditionally to reduce code complexity (see commit cac5cefbade9
    "sched/smp: Make SMP unconditional").

    In alignment with this philosophy of reducing dual-path maintenance, th=
is
    patch removes the #ifdef CONFIG_SMP guards and the dedicated !SMP fallb=
ack
    logic here.

    While the !SMP path provided a slightly simpler execution flow for
    uniprocessor kernels (avoiding SMP-specific overhead), maintaining these
    separate code paths adds unnecessary complexity and testing burden.
    Removing these guards simplifies the codebase by standardizing entirely=
 on
    the SMP logic, which safely resolves to single-CPU operations on UP
    configurations.


Kind regards,
--=20
Aaron Tomlin

--gjvyk77mxr2rqak6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnylQYACgkQ4t6WWBnM
d9YScA/+Jn6xsgpnu2BMvcSxCAa+OL1nEeKhRo2Rb2/KrA8hU6VhV7W5uqt7zG4i
i2dN2smjUN5Te5DjyqtxK2G2HeyWhJ2ti8RV8Rd7wuXj+/bqOoveFXMuGLb9QnG5
mQlQRmCkl4sDfbbt7lvCEXM410XqUgu8KiUB4WBqHkxbVgayK8h2Ws3mAe/rp5d/
ajM62SKUyRmNdYb4dGAUpk4padLVCH6K3FTUn6pTpAgooQg5dR8vwMfDirIKtIdi
4umSypyCb6jUqoGs9Z+Dr78lyNKfmYPL+C3hN0KDGr+i2LvvD3+ECdkBkqO0fRtF
yAkqCSYTefDBxRq1MxsU2Ek+G9pnHND9MaVYHNZuebAs3u/wVkTQDnZpdi608pmz
uPDZeLhdFreO40CZRA1VpEIegIz+3DfpIvbn3hV7NvBYBn+9k1Ug7AJ+ZJqfDU/5
uzmIBwew6+LenSjZAvMt4vqYf6qJlE+K/2AvCSSoq24AZyMEGRJA5i/o0j3GQxWP
ojAe+2KmB68BgHVip+FIPqEUrEu//mnmo7MCM8znfwELj6bWyc2Hkxbuu2ys0sl9
4axtPveOYEBXrmo0264j6wjPdxtCoHJvSYXIxT9F50lr+krjb4JC8cW5fx6t+CCp
+q6GURVDH7FDoLW3wjJ4qZURewKhD1rgdim2uuuVCg1tu3BRDWY=
=g0hT
-----END PGP SIGNATURE-----

--gjvyk77mxr2rqak6--
