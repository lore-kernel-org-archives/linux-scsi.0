Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020108.outbound.protection.outlook.com [52.101.195.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE7533DEF9;
	Fri, 17 Apr 2026 18:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776449214; cv=fail; b=i48iqR8QCMtMuycZTw7nbpRH9M6E815xsQQR89TUQJWCCG3x1MFEYf7IEJssxC4obLdJzPAh5vMHL9F1eHCWfBUguUCKYzlWCW3KCzxy+eSK4sqmHo4myucicVdWJPQ2eVzARTm4d7+Qw/mP2D+F3c2eQkeAZmMXWkjySTvwrno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776449214; c=relaxed/simple;
	bh=vPAaXhBXd7lv1daqcMYZDDTsptjZ97dPCkF6r5fCDZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ePqEG/Lce2cZJHSaVDdMcb8aJA3LWfhnVWnJVJuGg+X+4235XqvVGhZ+ZQABfc2+FVucHRG65n6bsoG+BNyE1ZQ9XG/EGfSXqI7U909hjRBz5k8kh1PEjQ3Gj4niPtSxUMt/usmkrpKunCn8V+DF1nad2MNBFNIJ0vp9orflNXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I9UVLoZeQvZIwNJNGAdFk2skxxuKWJQi46F13aq9ekqe+QCY9Ze5tUlUg+Pqn4BHk/px780z0oZlOdonv1Jn1LDEiNG8TMvvkuWDYbQPB6klFY2+s4r6WalSxa/ZwAWcazOPmEOzKFHRByStDpAYAfS+b6iqDVa9EiWRXpcWnnn7dl873lBvYQXf2hZcIctQIKc4EV5qvq9JkCt4gw8dxdtapnipGxa3SXono1PIeKc3pzGAxZBWe86TcY3ifVBe0b3En9IChiZ/pzbGSFihse/himIUNVAoixnuzpXV7n2fZN0s9OCDh6R1vqZcZSHFjxDqDetQ3d6LKo/wtEDklA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPAaXhBXd7lv1daqcMYZDDTsptjZ97dPCkF6r5fCDZE=;
 b=CSYX8AmPFXgUV3uyiy9c6WZireDrfvJcjKPysWcCFf9R97Ci2GuJ/BGbqQl8CuG8iaJHMJa/iYO06LD27xePc7TGEBl03KFOIwXpkhkFo/frQFqbSQt/3Sj5Tjgwdxvom4Bf4ga1Bo/fPNO1LiMxe5+snqVDzEN7u5ZYIwb/7nS0q+0OTryHZpfLsL8i1KExaUPvIfvUTCfUNnuuMkJ1/4JY4umjzmyIoPyz6Xe7KxNWEJwqlU+0qjmXnv7bmy/VBj4FIAiHMG4m92dFnuiwX0590PJtFx8QzuqWa8hxeS6cRfZulKO1v7S/eaqnu8Xpl3FwMmvrx0YpBbApyDk/uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO7P123MB8117.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:450::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 18:06:44 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Fri, 17 Apr 2026
 18:06:44 +0000
Date: Fri, 17 Apr 2026 14:06:39 -0400
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
Subject: Re: [PATCH v11 11/13] blk-mq: prevent offlining hk CPUs with
 associated online isolated CPUs
Message-ID: <cgekb2d2jqw3syuiqk4fyta3iawhjkg7jvoeh5cpq62gcqinbv@77weoahh36oq>
References: <20260416192942.1243421-12-atomlin@atomlin.com>
 <20260417161116.373130-1-marco.crivellari@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ecd72ejjb7lu2kts"
Content-Disposition: inline
In-Reply-To: <20260417161116.373130-1-marco.crivellari@suse.com>
X-ClientProxiedBy: BN9PR03CA0934.namprd03.prod.outlook.com
 (2603:10b6:408:108::9) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO7P123MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: b67531fa-906b-44c0-3681-08de9cac1530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/9os53Ch4xDlsjB5p+X5TXT5PBR48Nj9Fqdl4btTRHZ9lOQ1I/kLWTmDJaqi0/kx7zSQmPUtjVRXyvfytvWTki7vvSa4QwsgaI3+kJN+KKbTENI0yPsphQ6w+kqkLEQ3dztgPYQXRD8MIIZRIsaTvZ5IgtALyAiaXKr3FzM4xZ0Z8QB2a7RkSZZ7851E5iv/axteHCL7C7c5pmgC0DsLqetjAEYoRqywNLjyuI9/tjOHnl0XB+VNPmyd9+m7MV4MDxVqtURjJ7olYnNhXtmtQDaeeIjAo3HgMN2fHPqbYUaTejbU9dks5pO71D4l/hLAc9Gfix5vidmjNr8YUjEqDfmcVoHJ8wvwVF//eNihKBCMxbuhYcV4wPK+dv7o5qH1m0y/3fZVC3mBSD+EhdMRlpb+kNZFBRU0cwDtvp5j5C/Nq0i10kg1nGY1QE2p31vr+6SUPJnOQQfd1HDuN0mbTpcgj9TPbBtfY1TFX4f/Lpe7+2DU7eZTa/xiQMfGNv8pUHnoQcp6VrwgniXYAXVRrb8iLRd3fkNwx2mGZYdn27on/AXCFvR4fUIOob+PpZ7K2SPjjioLs7kyoDUgvceyUeQ2kYFVYa693rs0Yx9Ao1efEvVCyi+a7rKNraeQqjdkVX5jRAcPl0CR+Nyyt3S8CCKQYzcVdVi9CpuzDIi6CVfeos40fqdAKEgy4AIXhH4+cizQyZLYaWiffEyNI4jmI8WeLW9cG9btUNRtZSa0B+Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmU1Sjdwbi9jV2I2eG4wQXI0cXpFQk9aVCtSeHoyR09YbmdmaTRLWkRDSFdZ?=
 =?utf-8?B?cFdNMVAyNVM2MmRCOEQzWVJmZWJ5WTJmUUJSSVpGb3Q4RlJwNDJydExBd3M3?=
 =?utf-8?B?WGo0QXpZa3pjVGx6UGZyUmlEZkxZdmVuTmI5VjBoeFk0Ry9RMGNLM2M3OWlE?=
 =?utf-8?B?OHY3UGdxVGUxeWFsRXRhRFJWaFg0YUFoNCtxM2lONWhaaGxUUUhRQnF1YVRS?=
 =?utf-8?B?azhlN0VLYTNQTXlNbi9iU0g3b3dGMDQrMXVOYVRBQlJHZWNHNG8vWS8vMEVq?=
 =?utf-8?B?ZzJFZDdDTFZzSjBXNHArQ3VNWDhPSUhqR2RkY1FEL0VtR1VWYmIySTlnbHdK?=
 =?utf-8?B?czdscENiSzQ1MWwzOG1HajVIRHdoRWVZK2FhZUZlSUg1aG1LeU1BUTFCdTMr?=
 =?utf-8?B?S045bzFZZStQeXZiWVBkUCtnY0FaRHc0bFJpUHhZQkZ2ZXhlNVhRSVk5Ykl4?=
 =?utf-8?B?eUl3bVdmMmlIb3dxMXNwTDVxRXFHREZsOFlKaFpSalNhNUNkWno1RnFWUC9F?=
 =?utf-8?B?dnY4dExzTEE2Mzk4ZVJUbFFOKzZYQitXUm8vSGxySi9kVFhjSUk0Z280dCt1?=
 =?utf-8?B?ZVpTQjNoSmpoVFBRVkl0T3ZrOGxKdi9wOXlmSy9ROEN6RVNYVVZKRXArbXc3?=
 =?utf-8?B?VzJZQ2EyUDhSU1ZlU3FyYXdJR2ZYamJzTFQyU0laVm12K0xkbjNkWXUrSXpZ?=
 =?utf-8?B?aDBPWTdWMG9xWERCY21jVDk4YUpnVTlQL2w1QVlPVHJhenRhanJVUWFFZ0Rx?=
 =?utf-8?B?cTVDK2lSaXQwMDViSmxRdGM4aFl0a2U2NndvNEVpN2gyNWs4bE00OVIzOGhX?=
 =?utf-8?B?V2JCa1dSMFJGVnFlSnhJQm1QeW9FUTdvYlduc1lUUS9LbU9uRWRQR25xOXc1?=
 =?utf-8?B?c0drQjdqNTZ3V25BOTBVUzNSbWFGaWNsSGNaTDhKSHowYVF4cEI1Wkt5MEZl?=
 =?utf-8?B?S2NReHFGZ3RnZWh4cWI5cXA3RWRGQ3hvc05lc2hKckUramw0UHo0M0tjTVNT?=
 =?utf-8?B?ZlVCWm1pbWZMa2JpaUdlSXoyd0tUME1Rc1prZTE0Q011MEg2VHJwSEU2YVZT?=
 =?utf-8?B?b2FrMjVnMFY5WXdmS05pMU50Wk5rbllCcjB1YmlrU3hyMDMyRVZPaGx2dWdX?=
 =?utf-8?B?MmpoTTNVakwvS3laT3E2MW8vMEM1blFQSDE5SmhmRGV5VERqRVRXbCtpMHlG?=
 =?utf-8?B?Rkp2aXoxeEJmcVZuS3lxV2NFaVNkTWhraHRudTFrRU1md3RlcEw0WnFVTDNv?=
 =?utf-8?B?Y25pNzcvQjBTWHNnd3crd3BGTlpnci9rd0d2aHM2czBZdllIZ2FjbGZWVHp5?=
 =?utf-8?B?Tk1qaHdRdHJOM1RjSTgxeHFTRjcrSkRyME5UZUtuSThLOGNoc3hjQkxzTmJl?=
 =?utf-8?B?alFIa3VrVXkvcWZOdnRpeTVaN3BLV3NMeGE1aUJBSzIvVnVhV0lyZE1HQ0l2?=
 =?utf-8?B?U1VsRWhFa3h1aGhVTkFLMExMT202ZFo4QzN2YWVBVW9FcDAyR2d3STl1NmdX?=
 =?utf-8?B?MGlCVFpqTWFaTEdSSmZFSURyaDI4REx3MUVvTVlGeE9pVU44YmtLWWprbnhZ?=
 =?utf-8?B?QWl6VloxZnNKcTVrVHNpSVdydjFsVHppQjdJRmIzYWNYWHNQaExLT0VaVXpL?=
 =?utf-8?B?TlpCVVJaNEpSNzhkc0w3UnVETDVjLzRsc2NJWDBia0gvc0pwSlpYeXNWMnRT?=
 =?utf-8?B?dnZ0d05LTFV6MUZmN1c2VkNwVDNoNmFYWm12Q3M5ZnBQbHZTV2c4SUpyQVU1?=
 =?utf-8?B?ejlad0tjSWJXR0NyTnhxYmpEdlVFaDVNbjhqMzZiQnhHVmdncS9ZU3VtazZN?=
 =?utf-8?B?b2Rxb2ppR1pHTUFkNjZIejlLcXBzMmdPdTRSY1FKUzUvMGlNTUd4T1VEMXp4?=
 =?utf-8?B?S2VPY2V6M0VROGFwdEl5SjE4U3llcEVqMGU2UktVSDgvQ0pxVW1kSm90OXlE?=
 =?utf-8?B?ME95dEZyYkpuOWNpL2l3Y3pXWjc3Mzd6VVhCZ3JDTFlYUWVQVzYxdDM2T2N5?=
 =?utf-8?B?OU91TS9hamFuMDl0R0hIb2d4U3piRm0zcktvVVJrNUQ0MGwwNXpoaVo0YTVP?=
 =?utf-8?B?akdzR1VrTE1UcUdhcXlWeng0djkzMjlNejl6QnJhZmIwVnIrN1dvVmNqRWl2?=
 =?utf-8?B?ei9wS3BwZ1pLV0liSGVpa01IMEhUNitEeEJrWDBwdU81Y0oyMzFWMU1uZW1W?=
 =?utf-8?B?WHZTb0Izbjd5SFAvdTcra0prUmZ6UjUvS2VKUVZ3RnFESVFsYUY1K09ja3RH?=
 =?utf-8?B?d0NhWitDb2xVb1JvakxFN2RkT0ZzTE5IZGpWcjhWdkRaRDZoQVBHUFN3bDlx?=
 =?utf-8?B?WVd3bDlIMGE4ajJQUUFCNGdhMmZYd1FvOTVEZ20rZ243Vmh6eGN1dz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67531fa-906b-44c0-3681-08de9cac1530
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 18:06:44.0657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJxA/TJi1xyP5X1X0aPA6HPoV9WcxfjfX1Wviia9dfc/1J1Pfv4EXUwaNgKPse3dkE5owLc2Q7lUNjchr09Rjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO7P123MB8117

--ecd72ejjb7lu2kts
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v11 11/13] blk-mq: prevent offlining hk CPUs with
 associated online isolated CPUs
MIME-Version: 1.0

On Fri, Apr 17, 2026 at 06:11:16PM +0200, Marco Crivellari wrote:
> Hi,
>=20
> Seems like the commit log of this patch is duplicated, isn't it?
> I noticed it's like this from v7.
>=20
Hi Marco,

Yes, that is correct. Thank you for bringing this to my attention.

Kind regards,
--=20
Aaron Tomlin

--ecd72ejjb7lu2kts
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnidq8ACgkQ4t6WWBnM
d9YjDg/8DZ1Hu1plSV/eCB02YDOOCu7qr7cxF5c+jTOTNrynezJB/arpUh3M5ePD
gWbhkcl5FQDUQwDPiUcb+6UMJZC+dVLuJBCyPZeyPKAXVGXeLGf1Wx/VIrv6j08S
t8VLakxJ6kFDl/ftep073/bDvKCnqk7M+YnIpVO9YSBPKJffI7qHRmQwIngeBVvd
QkF7uL52lQcrD9SHFfgmdmf+A6CYYjsP1bIxP7x15OOShwvrW4lOOJ2O1dp01MFM
DTrXrZmmI4F2lIRfr0GCRKpPBvV8ruB7A8J1A4axfA17WcIkEbCcfz0QynjnQ5Xu
Qvvzy7XMfL3lp6FLEqZd3S6T/55kTRAbcZxD1kvZVp4vxw1yMzylpyMpRDFahZCH
bNoIler73vG/vIycn9bIijuKXi7h0fSJdloDp4ylT9EI/t7MG5QZMoeEyiTc8mo3
+eYN+uJRxI0P2BWB05xtjlR65DPt9KgIuJRqXSt0/oyWNXjPp/xz7wn5YSiUBSph
EbWOtU4RLKEMPrg0XFcIDa/WIY8qxYlULoO6pyGZ4/9yAMWyOSjaOszgqpPAWg89
2GJX8M2MdlxRs7megFkxN7B2HKsRIryiru57n7m2mXjsf17lrwQAYosmE/mGGvfc
rkcse7W6Qx1NEdWfwxtVkIeqNrbkVBebBk9wYEPgqIL59Iva1Lk=
=C89G
-----END PGP SIGNATURE-----

--ecd72ejjb7lu2kts--
