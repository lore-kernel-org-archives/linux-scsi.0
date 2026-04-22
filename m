Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022114.outbound.protection.outlook.com [52.101.96.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E36314A90;
	Wed, 22 Apr 2026 17:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776880071; cv=fail; b=LAEePsOz7zlB+/4zA5UKOtlnegpsP/7aZbn48KaLv3ZgK9Gf5J0FjMXJI8Z6/IvuzFMKhE3L/B7YbzSI0NM6iLArCRyF58zwG9X+jQJXbbUk/rjsGmZuf4qeEHgI8iBak0aroH6jX5xHFB9BLb5o0NdQlZCKegWuYq77cXD2xgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776880071; c=relaxed/simple;
	bh=XpAmwj2mcMBDUVk6EjZ4Kwyb8oh5iKD/c69VyvPmuDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h5s4TBbi1RYMPUpKguuHMHfmAW+XNjcCi4ZFphgNecF++tceP0MNhMRaJtojDKDyzTnN6/zHJr6eziWDYwhffjbGjny+A1kCgWjF2pYZFB6whgq8+b1kb4ZBvknkld5tnBRoTbNmFPFbANfd+W+g93yk8z2B1qfCw2R+HhWG/r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gfg3S4+/FfflgCQanDbC0RCkY/B6BBjMR53Ox37YsrYjBM8Y+6OFUQ5ZIlrmcYbS2AEiZzNYFm3A3XZ5ZUkawV4+WJMja8TqWaUdZnaoh387Bq0REII0IykN+aclv4ZfnkyukH/zywy8gz8DgDkt/xWrrrCJwTXH5tu+x64s281sbO/Z3mKT9oNtboDdoC/vDGxuYOejlQveFdpOzqRoaNpzkNBshGC8CAYfTJINXPKl24qWGs2lcL1xmXDRlCzz9tZyha+AMCMLQaUXGmdw40Gn+eA32eKEKK2F3RfZ1mH9PAt3MlOSkeiDmSmtuxlLZUzHr9xC1RctCYmc6V/CAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bRnhfPkuG+fmlgN86uERCKE7/s7OwlRKFpLF0ymBto=;
 b=im4EEcCEeFxG9Xe/rVdOJI5xQ+LSPIdXscWs5YFwRLHUnrSqx1RyRVHAQ6jmuVvHCBjZduLouo08Y0WLHAQ/Ird0w4xucLIEBCEW0+wvCG09mlmi57NOc4LsNbHsXONPaV6PWlZ1nCVrxwFeucqJVY4H8h15YlNsFNLQ7SoggdQm+uDKj4YWjFMJHfeESxsCUfC6peUb03yeDwtNGnN9adzu1R46CuvV6BxBDVpOocM+PEdmVNe+ZjOenqUh10LjffY5juOSwfrDJDbGInzQvRWQ2zP4SBlPzvsmeD4+zttkPYewBrCd516JAmVCu4VYC7P6Ra/Dx4R5YIK1E1HAgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO2P123MB4255.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:157::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Wed, 22 Apr
 2026 17:47:46 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 17:47:46 +0000
Date: Wed, 22 Apr 2026 13:47:39 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: James.Bottomley@hansenpartnership.com, 
	MPT-FusionLinux.pdl@broadcom.com, aacraid@microsemi.com, akpm@linux-foundation.org, 
	axboe@kernel.dk, bigeasy@linutronix.de, chandrakanth.patil@broadcom.com, 
	chenridong@huawei.com, chjohnst@gmail.com, frederic@kernel.org, hare@suse.de, 
	hch@lst.de, jinpu.wang@cloud.ionos.com, juri.lelli@redhat.com, 
	kashyap.desai@broadcom.com, kbusch@kernel.org, kch@nvidia.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	liyihang9@h-partners.com, longman@redhat.com, martin.petersen@oracle.com, maz@kernel.org, 
	megaraidlinux.pdl@broadcom.com, ming.lei@redhat.com, mingo@redhat.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, mproche@gmail.com, mst@redhat.com, neelx@suse.com, 
	nick.lange@gmail.com, peterz@infradead.org, ranjan.kumar@broadcom.com, 
	ruanjinjie@huawei.com, sagi@grimberg.me, sathya.prakash@broadcom.com, sean@ashe.io, 
	shivasharan.srikanteshwara@broadcom.com, sreekanth.reddy@broadcom.com, steve@abita.co, 
	suganath-prabu.subramani@broadcom.com, sumit.saxena@broadcom.com, tglx@kernel.org, 
	tom.leiming@gmail.com, vincent.guittot@linaro.org, virtualization@lists.linux.dev, 
	wagi@kernel.org, yphbchou0911@gmail.com
Subject: Re: [PATCH v11 03/13] lib/group_cpus: Add group_mask_cpus_evenly()
Message-ID: <tfkr5mlsdzbhdzv46ookoy2e7ed2wcozuxanv4wagjf6hqb4sa@7i753lpqkxvp>
References: <20260416192942.1243421-4-atomlin@atomlin.com>
 <20260420131152.243488-1-marco.crivellari@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="q5uktf36yk35ntpm"
Content-Disposition: inline
In-Reply-To: <20260420131152.243488-1-marco.crivellari@suse.com>
X-ClientProxiedBy: LO4P123CA0124.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::21) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO2P123MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: a34e153b-f6c9-4047-026f-08dea09741cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	HMcNbUQtYzjCi9XCTrGfKP4y3MugYWUNfVX3nuE/ZyGe19bZlMCrm0fXgK29E1XL9Qyg4+VcR1UdT60Ulc2t6hFvKVBEc7h8anVm78zQPZCM8ptDBEZ4G0Oc0MbXKPXRM/pEUpFxmOFt0EOGD/z39ikg44gz2fg6gXpzD6AQUQg3n/zIAzXijLtn3+aD1tHQ0fukp3Q4bAM6PDISO/MwBywCmzQGlKAQBUoqGGZMPe7Fd+oo69BGGMOa+O7nWj+uj0qBtAd+TInnKbe5vwRiNMHZ3JEuOwRK7MNQKnQYIB4MQLOg9hKklK4JMlWFYCbzXQGg6TX3ioG/ywV7lcPU8X71HNSpr+kfMDmlIfk52YgawueojpCf3zLztb2o8fUaEtbbiIzt/LBX5rp8DjxUjae4zl5+g0kiA0gaYtOOLRydjTC0y/0SYxUxs0ZFasJDie2OE78DRqmfdBCxA3Ux/KicSs6FXs8Md1OJjoaca1VtPVz/nNuNoazZxmvWXNjQrqJVdoqLqDPBSs8sZ9k0DmRj0mx1P0ZpPvVNMt++IVGLZ0Fb8iZKoSi8kbMigJn+96pte7fxWAIDIwZnNWMF1SMDqeDvVa/gH0WgRwe9+v+UFLcohl3leFHp0loyc4YYnnqG6QYAPm1Jkz744EHR24S3my1xRxyLrYavSQlHgxERAktF0A39Zhp6t9kP9I2LQVxswUmQSYnZoev8TcSf4F4cdaxL/6DeHBkK1oaTtVU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUttcDRFTUtsWU1jUitiRWZoRFhMVlJtMTVFMDFvZTBjM3A0NUpheEFwU1Ex?=
 =?utf-8?B?V3VVdHRGTUIycUNZdzk5MU9ZT1lpRzNCYXpaNi9RWlVyZ21xZldjLzF0VzdM?=
 =?utf-8?B?OExpc0RDSTlteUdWNTRSWkhqY2MxUGlVUkw5dndPOXRBdVdLWU8xUzlOY0Uv?=
 =?utf-8?B?UjZhWWlHcWZacWtuSFNGZHVXVnkvZFUzTlVxWHBJQThYYmVRVEVGVERVUFJy?=
 =?utf-8?B?WnJIc0s4bkZQQ0dnOXNhVTJNR2xSRDhmbGxETU5lOXJQZTdpcVBOdXVXVlVU?=
 =?utf-8?B?VEkrd3lCRWI4aklka3hhL1NTVWoyREFORnN0VWpFS2NvdDZWRVV6S1duTFlw?=
 =?utf-8?B?YU04b0V2QW8ydHJnNDhyRXhhVExWcEJjMkxtVndjdlJPRElVbzNBVWhUaG10?=
 =?utf-8?B?M3FlV3hPUUVXeDdUUWc0amhoQ1FjMENINkcvUEpZQWpUdXh1Z0VoS1JDWFNQ?=
 =?utf-8?B?UWVmRks1bGVjazc4TFFsVVFneGV5MmxKc09ONGQ3S29FZmtmcFd4elVrczNW?=
 =?utf-8?B?YUtCL3Y4eEN6bTlXSEFTK0xBWStvZFhsWTVGTkhmYXlYMWtZZnlBbU9WZTJs?=
 =?utf-8?B?WTVYRXQxV3A1K21xNVVtNWt1a3QwaUVBYXJjM1BMdHNpUHI1V0V6RHlGbnlq?=
 =?utf-8?B?MUR4YnlXbGtaaFQwZ2FwZHY2TFhrZEhzc2FUbW4vOXJzTkE4Q0c5d0REU2RN?=
 =?utf-8?B?ejEyQjFURjREVUlYR1RyR0Y4UUxwektZRXliZ2NON1R2SDdFN284eWc4ckRX?=
 =?utf-8?B?RkhSK2RsZ0ZzSzZQRWZNMmY2ZlBRaVM5ZlV6NzU1RE4vNFphSTI1Q1ppZHFZ?=
 =?utf-8?B?WG9TYzFHQ01KaEhiNnlkNmpEaW1QV3R4dk5rTVI3VTRXMHQ2Z3czQnBlRmZk?=
 =?utf-8?B?cUZPeWtJckIwRk5rVytENXdCWXVRM0sxdm9xQTNoeEJlZkxTeURKWDZEWERr?=
 =?utf-8?B?cHE1QVNwRFl2WDZWdDhBdVNZWG9LdktVT3pRYmF0L1VxRFA2dCt4L1Zvakty?=
 =?utf-8?B?YUhtVk9mcEVlaUdXRWZtTE0yRkxwcEVSQW56QU1JWjJEOVNRTS9VZ0NzdFl1?=
 =?utf-8?B?TFR1N1drK0NtSEtmb2lUM0Z5MGYvRGU2VDdQOFhkOEs5b1VPVU5kdmprRE5W?=
 =?utf-8?B?ZU5KSWdMQmNXSEdLRllLcTgxTGs0dlRydzBlSWdLUDhCQ0U4K2FmaElrZGVp?=
 =?utf-8?B?OGo1UU8rellrZUZjZ1VkRWZlaXJSbUVkbURsYmRYMWhzbmtEUXRHZ3BuMTZ2?=
 =?utf-8?B?NTVPVGdUT3c5bFRrWUk4bi9HQStUdDh0c1VIZDJtYnU5QUFxcG1lZExKN29W?=
 =?utf-8?B?UURqclFGcFpwb1ljUkoxUEpuK29MZVlOb1ZkczRvOTNDemNuUUx6TEh2U0c0?=
 =?utf-8?B?NDkzVTYybnVWQW9YeEdBM3dtWnc4YUNPT2swOXZuTUNiU3BtbWplUDd6RVB2?=
 =?utf-8?B?bWUveE9mNXVjcVVGaWx5WXVudzJ6UThhZEY3cTNMUlRJcmFlVW9XaUxvNXhl?=
 =?utf-8?B?c3phTHh3ZmFIZmczMllQRklFc0RVWU9UeFhkeE5WamVZc1ErL1Ezd2JaYklS?=
 =?utf-8?B?aTJWVXZxYTgyeldsUjc2eFRkUmVvU3VCamQxNThXRWRySk94aEZEV25oYWV0?=
 =?utf-8?B?RG43NEwwUFhITHJQRkhPZ1lmNGsrNXR1aEx0WUxmWlFOY1I2aUN3SVdvMGpt?=
 =?utf-8?B?bU1kdGpMMEtmYTlCVHpWKzNxeG1pb20yc2J1V3Q0Z1JBWVd5bTg0Qnlqai9S?=
 =?utf-8?B?c1RaNGhqVkpoNnVkSUlrcDB1RGl1eEl6RDY4bjZxQjhTYUg1eW1KZFRuOCtO?=
 =?utf-8?B?aUZzc1ZJT3k0dEZRTW9hYkRFWmg2VXFNZ2dCWTBnLy8vSG9KOTJROGtQa3l3?=
 =?utf-8?B?OVducGZEd0RBQ24yeUJPUU5yTVljUVVlaWg2U2lqN3NLQWdHMUlkTk5jSkRF?=
 =?utf-8?B?UEExdnhrajZYU3plcGs0NE9LOEV4dElnREF3MHJhR3lBbloxc0lvQzJ1NHBP?=
 =?utf-8?B?RXoxZDdiV1hmQzBYRk9GVHM3WjVsL0JMUDVORi9uQzlHOHZMSXdXcEhMTWdq?=
 =?utf-8?B?QTl1S3ppakM0M3NJRWZSQzNZb0FBdHh2Uld5WGtWa3hsNGdqeUJvVDg4ekE2?=
 =?utf-8?B?ckhpUStqTFdEUEFkY280MFYwRFcxSi9vVEFiWTlpMkYzNXY2ZzJKUVhreEwv?=
 =?utf-8?B?cUt6Q09vU2g0ZjhWT0FCY0lyNGlZZGViYlBXQy9RMTlwWU9TMnM0K2EvRFlS?=
 =?utf-8?B?Y3dKckRaZU4wellHSjF1SGdlQ3dRYkQ5UC9zTnJ0cGFIVUtYNjV1MHpSQ1p3?=
 =?utf-8?B?RnRrTnBEK0RwVGx0d1UvdTB1c2ovN3FPQ2tkUm9jemFOdjMxVXA3UT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a34e153b-f6c9-4047-026f-08dea09741cd
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 17:47:46.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZFiZn2051CjQot1bJfZ8cn+DqjwqU5eP746j0gjzF8NMKbYNVcKC9n52ye0tRWoMV2BhjmGuztsC0OffboZpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P123MB4255

--q5uktf36yk35ntpm
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v11 03/13] lib/group_cpus: Add group_mask_cpus_evenly()
MIME-Version: 1.0

On Mon, Apr 20, 2026 at 03:11:52PM +0200, Marco Crivellari wrote:
> Without it, I guess the kmalloc() in `group_mask_cpus_evenly()` will
> return ZERO_SIZE_PTR:

Hi Marco,

Thank you for reviewing the patch.

You are correct. If numgrps is 0, __do_kmalloc_node() will=20
return ZERO_SIZE_PTR.

> Should this check be added or it is not needed? Or maybe rely on `ZERO_OR=
_NULL_PTR()` ?

 - File: mm/slub.c

    5275 static __always_inline
    5276 void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags,=
 int node,  =20
    5277                         unsigned long caller)
    5278 { =20
    5279         struct kmem_cache *s;
    5280         void *ret;
     :
    5289         if (unlikely(!size))
    5290                 return ZERO_SIZE_PTR;
     :
    5298 }

Regarding your suggestion: rather than relying on ZERO_OR_NULL_PTR() after
the fact, I think it is much cleaner to just add the early exit at the very
beginning of the function, exactly as group_cpus_evenly() does. It avoids
the allocator path entirely.


Kind regards,
--=20
Aaron Tomlin

--q5uktf36yk35ntpm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnpCbYACgkQ4t6WWBnM
d9bNpg//fMQ0fHERmUYbC9kPBFeo9XAozUah6n9gqnZU72Zw77e9jX8u7a/yGbO5
l9n2T9HWutb7lvFMy2HbAfzc3L0C+WgD/fzY4s7Rf8BJUegtnBuAuU3c266i4/RB
MxbAgo4LZD6jFxIMYWh8VcQa8u3lm9TjdhCsWRsIZo5lO2rQQI36sM7XGn+ONoRm
Ql4ZYFaV1ri0mOLU/0Jpmbm+k1wJ/5Cp09entDobOKPxc9/cK34o4L15VIPtB6/I
NDACdT5Hpt+qwzy8MEqmr0BHo4aUmCfyY8lfg1SPkh8EKLexShnvNfyAY9qzqGGH
chAQeC4Cfw1gTkKJDD/fCT+dpwsln1jb+wCRs9nI/WKehIRhmbm/BCH3ekS8ebAk
NL2+yBhqQidJlIHUFhn4s/96Q5KxNCQYYlGfsfFmzomfFqfdr5gexgREIgg8f9n6
sUn9e36VFwpTNAVttzHv41pNi8eA/rX8SO7wjl9APljaqvRSzktOKV9WDWnRWJ+y
T494wgz7cwSmwmz5GiM7hYZHIrG1sDIVdvKfAmGq3rsuSYMpRgfTi3dI/iiXZhcw
kpzIgiKO/ITqWwDAOUMS1PNjrFkm6raQXfROEucUrqrtoEMurVDIUaomIvsRLptC
KNErAS1o8jIk+CF6WrascBGsCFSJNd7H3F8lnAVBZjqoz10j1QY=
=APr2
-----END PGP SIGNATURE-----

--q5uktf36yk35ntpm--
