Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795249642;
	b=TJ9X0+OquFZNpY7kw7Xp/hc1Y55UIH54E0fKWydplWfiDsKQ/SXD4ZrYw1fUZ0QkiF2X
	 MBbgxAnWOeQM06SakXCyfGXyf3hSO8pDbvaLLrO/4wbTaogoXDlGxSVEoYas5eM/jg4k+
	 uprhksw+UAY7je1ties/LUtVHCCYeA0opDKGo8JuDVtiXxRx9Yhtv5wSqZTrQPMEUoMxJ
	 QgsAdWRP228hMN075srZs5Qx/i4J/jKCzJ1wK1xE10B1oQu0m9K5voe67Ywcc+qW53Ph3
	 HZo6ufHy5oPLE7rxsuKavOskGhLUeEWqAwDfgS/4+J1oxG/i5WLjSrbgZm0yENguhhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249642;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=wfiGWsnz5SEvSDQvHNJ6HXTo+bKCMiN8rWDkDwWVmxQ=;
	b=QT6GCCmCra8T6FS6pZ1Ipi0E1oupFY3fO2GeaOUcA7ESzzFxIdsTpHK0htIFibYrYHsf
	 greaMWCLRmB8nsjRoFOkXP7eXdlUhUFwItktzTuuTq2Twx2BjJqZ5lbWtNQiCjIKLIKsN
	 8nq+tBy+a6FnPE1k5uUY7Na05hfLDywe1Kx7ci26G+GtOTss/pAslZ1Kj1MDY/vpLSgOa
	 zRFNoCXKwBAyK5NA7N9T4dN4t4FYLormFIOtkNaWXU+EpQni9vwtjJOxB9TQoJ5GXmWN/
	 Z38Pxl+WiRaNZdhfgFqRjTuJ4igV70e/xknFnolyfTDor/z/MXZQFbP+1x6NzzYg2PQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=XyfKuukt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.1
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19011001.outbound.protection.outlook.com [52.103.1.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF88606A338;
	Sat, 21 Nov 2026 08:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BF88606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=XyfKuukt
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kWrjY+7ew4GYk7LwL4B63IhMnRxqgJU4Vt6gdk1ezpFvg8aiN8ylUYYetwSEjAPRIA0BHyuFq1VbzJuV7QB7Bukxxt2a0WmA4ABrSuc0lUnb7vON4wp3g/UZwSk5Ukz6STIINLgvHh01uG+pNatu8fYcZl5jgoDigGnmwi5iwmdNFyGZ2GlAhcR7uF+l/CladRjxPLeH5qvMqSjRYQlm0QgdOOz8LewZpZkpEyrXsfum6tEZYEMzTOhDQQocbAjC9UOCsIsdkM7ZyqBPRnpYVOAXWLEjK8ztsGppHgYiHh1CsxMw6WCyq8VwH4oaWzimU0luYA6KFFqe37QEZbMMbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=wfiGWsnz5SEvSDQvHNJ6HXTo+bKCMiN8rWDkDwWVmxQ=;
 b=jozPzMVadLKoWS8QQdheZhdPHNlocKLb1dx7T90EPlv4b19wxbHCeujFosMa+3KdN/mUwF3n3ClJIw4j2PCZliakS27lGf73zhX2p+v+XvF5dElqSmL/q+4Rmjs9IblXfuXSjUCEFclJGov7hpmPYLVR4TykBzK4zGxTrJT9HOE6Szvv0ib0xBdVOW7+ZQ5QAtkYBluM7Xjs9B0LT7l6Ffn+FQwOWsewvQLbc8q1Vii+xIgRayP7KEQP1DPVzpdxqybYTn1xQ8N2p97F5Kth+VD5NragACwLVlQSBzB/WtwzcjQ3nHtO8u4L3uG87OJU47B0wX+EIRDA54fHCeEU/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfiGWsnz5SEvSDQvHNJ6HXTo+bKCMiN8rWDkDwWVmxQ=;
 b=XyfKuuktixxxCot8z3bx+jf82+JcETtAkXtrjv/+ak7W2GE2wcfDp0PvytFJTgHC49S291Nkih9of2Xge5eITD5U5YHyI3Noj/olRc8ElAsDRVgz1veZM7QIGPAkX/NeyUJk0/OGZklYySLb2qVWzxy56Yk68CpVIRSdZddZmKFzy62BVY7wIwEM46dcorw+R3dlNcY0Qnpz7p8yYYdgFILkrhuMhgBsuIGDPFTGw0MEFDQZrmS4kGTUnHufjeY/nJzDOrM6pIV75J3sJ2r+SO2TUms9SWCFUX5BvA/gm2hAEcfny3TUuVoz16Qv2mtrEmno7OmhOq1N9MGL18w+cQ==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by SJ0PR05MB7838.namprd05.prod.outlook.com (2603:10b6:a03:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 08:27:19 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 08:27:19 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v5 2/4] scsi: core: Release legacy ioctl request before user
 copyback
Thread-Topic: [PATCH v5 2/4] scsi: core: Release legacy ioctl request before
 user copyback
Thread-Index: AQHdeZIfWZfmiqTXLkudgvZO3YhcxQ==
Date: Sat, 21 Nov 2026 08:27:19 +0000
Message-ID: <scsi-sync-v5.1795249365940711260.2.x-professor@outlook.com>
References: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
In-Reply-To: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|SJ0PR05MB7838:EE_
x-ms-office365-filtering-correlation-id: 0264688a-95f3-4c4e-300d-08df47a94210
x-ms-exchange-slblob-mailprops:
 a+H6FLLcF3oArmUeIqZHaFYD1WEyA+lapili4tuDjGkzsyN/pmqsHmkXvrCPHE4JSS6WevwaQfJIThgbtxm1uDJPuQ6bcPNls9HsoY9PJ9ov9aVo6mdNKsdfmBZLXgvi59nNJ5BN3r89z401NES8k3jmRGSwSWX1FTCcnKLVIGaC7gYFsWT0PIY6465ba5DdorLULW1y2AWFzwVFce9arV6DxZFj6WQAHnYHUPjZvBLRy2TmosfK+7MvsfWn2r3Du5yV+KicvLd7lU1kwwVp5FRY+YmfVzFOvq4Cy2FVxeusCsTFMucfgag8J/MoWzgW09Hyl5jJ8RWzuYP33uGi9T1RblXU5P8kz5Z0lRqmj+CavSirYTJjDxCDFOFJWabq/AzZDeGmEbROlfMmg0sZ+6VDYo4dRI9K0fkya+GTbbMDRS0Zs3CoasqAFa9CGHfRM+vx+VTZkJ1LWLW+yKua/EJkiGL+RRyMtMWt263SanoUUZGBVIIHlMkv/WeZezsRvb0lGeU5lKVDpYhSnUf9YaHMPVl7sOE1ARjbg3kEAa1J/yrQ4+lwsTJH8vfF2KCVtaw5+Xr/2PC6YnF2CCu18Oq/St6pKFsvJVERhGAg9WvvrYtCF8bZqeDqTx6wv1LQg1l0wajiyV+5pNJe2BWmzruEN7eVxOKdSMrqZLFQmCymaOdGT1B9G3/NYKlOBoqJeRO2kdCPvm6A6VF6KuXkRSlSFV3a1ZVmJ64jITYbeZ9yxZF9cvNRai8VpkD6ctG8sablxNr/am0esWbpkGp2N9f9VdrHwbt1TFSnGCE1UAp4gpS2IF7OQFCm2KzBh4Qu
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|38102599003|41001999006|22091999003|15080799012|19110799012|4140399003|25010399006|8062599012|8060799015|24021099003|31061999003|440099028|3412199025|4302099013|102099032|1602099012|12091999003|10035399007|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?DxfrZy7cHa3Nx7AaSBfjvmeX9y9O7Pgi1V84kc1Ym6uM9SJKZ2RJeXJM2W?=
 =?iso-8859-1?Q?iBXezRG2SwvvazFk0muT4MlAhd9cYSSC+GdYdYLdPIY4CU5Iw3mrgZq+0x?=
 =?iso-8859-1?Q?cK+7TwQOUB1bHL1nbk6m8ZUJfy5OeMGOMWeL3+vzbxFH8OoQr25JZlLlH+?=
 =?iso-8859-1?Q?UtYgR4cmhKr285P/rt47LKUKpWlVcIrxgit0npBCB1fK5Tn8nSJeeA5VQM?=
 =?iso-8859-1?Q?J58qtRPBozpRFX8G7rbG8fvJdrCN9DpNKi8fVyJVDuSkvn73Q4u/BZzQk6?=
 =?iso-8859-1?Q?RThvSYxfk4P4WDKAlIFkstSz5Gbmgi2+rbp+mNQGRkf2twMFdKhtHRxf0i?=
 =?iso-8859-1?Q?bCL3HvUenX2yyPFjXusNUhK69Kn83Hj6Lkg4lV7eev+eacWyjFDX36b7a5?=
 =?iso-8859-1?Q?QoWb0/ogKtcwZJPHVH4PjqxPD61z1C4V5w3D1qnELE5AGrQPeSzwWbUtCz?=
 =?iso-8859-1?Q?cyHOc6jQ2q7ts0WYZz9QEAeweg4wC8hG2qq96DzttPxTPKJafYb5UoB+ch?=
 =?iso-8859-1?Q?bg8+ENfTP2C90V4FzijLmtPP+/mxTS38omQIyaSdVm5mC6ryNXEuby0V5B?=
 =?iso-8859-1?Q?n35JHk9DP7Tto2vqPIp1HFsCBVtHxB3ByyiOxLn6XpcJMfA7915RqEETXD?=
 =?iso-8859-1?Q?0ls0j7lY5T3AY27DcnMgOe0AlNL03Yq+3SkClKIo/c4cYb9fqsH6cAsqUZ?=
 =?iso-8859-1?Q?5o0c7/aBJMNEuEGzxd6+uOSd54cvqN3X2ukqFhoKyof5h2FtMEObpkjdW8?=
 =?iso-8859-1?Q?n7Ao1Y94qsGSIaIj5jHByhkSXNQsD6tNDv+amxhgQiFirnzFN81VAzoU+Y?=
 =?iso-8859-1?Q?GtQQ/gWIMlenh+VeMesue/pLL/6Hv1yOMkHa+3e0/QzouGyvaeDGTPfo5H?=
 =?iso-8859-1?Q?B8ClxyopiZ4NtSSylAawP+Seang0h7K4bIq2aLH36qySoh2KguY01+x5H4?=
 =?iso-8859-1?Q?Q/0Y0X47RMqQqZK7IvPmmXaLVDaaPv/gG8uigiksAFr4LXAxnBoGIa8VfC?=
 =?iso-8859-1?Q?UpjEbGicc2YUROT2wUFON8EKMFHXpneLMTd0Tj+fVBU44wisI0fBgPBFCG?=
 =?iso-8859-1?Q?MYexRqm0tsR4eGMYjdb+kNnukWO8DLmodydl0WIPCHulMw/zWidhZ3ktbC?=
 =?iso-8859-1?Q?OZ+BQYy9Q2xe4tgenNQDvaVqp5jKFYbPrAJpAxFb7NRaw2XqN/lV2R6PmB?=
 =?iso-8859-1?Q?5bXJa9V6Q1M2lrjL+GZN7ddn38EjOfh5OCs=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?tBnWmSUaB2CVFrz09Te3v6SHPNMqBAteuiJWXfsmqJdLwZNny9REP6dsDi?=
 =?iso-8859-1?Q?HiAg10JjasgUv6oE1y6R6BAoJZagTQMVc+UJZ0bM77GzUjWg/jEivL/zes?=
 =?iso-8859-1?Q?0aC9lJOcBPatI8VqO1oT2s+louvCyrdT8/XJbwV1NL0GhSfxzzF3fRI2W4?=
 =?iso-8859-1?Q?IJHsFneWBG9qfu3+THXioBr8HLg/xCBSIpcsSY2bFcGBWj8eRHsdProuuU?=
 =?iso-8859-1?Q?tiJjRWS8oFWRfWE+AHMXt2nFe9zQKE/20MFdzEzO29T2Hn+3o0zjOVtGhw?=
 =?iso-8859-1?Q?633iTjOMsNx8dbu7SlQkEgrBdC4ThlaNowOL5cfUKxbscNlCCec/UAV9/o?=
 =?iso-8859-1?Q?7LTVCTVUF/vfjgvJ1Zjz0qpXTSXb656jOeye/zg7mk4oL1OOnpZz6Ikv8p?=
 =?iso-8859-1?Q?Keq3P3iD4rbqt6w2BcLy7c0JKUgRCouKVqXLDlGkAMMFhUyoOOPbqF8PO5?=
 =?iso-8859-1?Q?QY4oCnmDU65zLkHvYexwbPAx18vSt4PXs0sSLNM+tpMU+mIVR/mpVeSze6?=
 =?iso-8859-1?Q?YAK4gy/x/JikgyCwxJHJSrlUMvajCTdFXcc0aknIOBxJSBL4jwVJLm1xrJ?=
 =?iso-8859-1?Q?nWzo3sjAnBJjzltIOnF98M9yJ9ufFC16jJ1LRVkpryxQ/F7/sjjUkEwVLr?=
 =?iso-8859-1?Q?smMh4v17dTaoIi+s4jlHbOhpG9syyxYhgH03g9VnDzK9F7dOZLdHmWvRmN?=
 =?iso-8859-1?Q?HUsUodQ98ghqTzw3GH6NVj76y8gBeEKNI5tdL5e7zF+RZPt7tbaHRUKL27?=
 =?iso-8859-1?Q?UGm+iMiJ4IB1+n38nMbYrakfeMtZUj78znaRD/HBZinQPxVaXxhSKKT+gR?=
 =?iso-8859-1?Q?9SzU6JlIxMj4IzcstIduMUK4aoZYbW/1Wsjwkmo+QFw1dyxA3NO9QlzHEZ?=
 =?iso-8859-1?Q?vUhGEMVHJHZQJBH8jVSKybdo+B2Zsl9BmnnAEshN2AzNF97M0GOCEs3Yl3?=
 =?iso-8859-1?Q?Wh7lbLZsmxDGqZuL25PVGL6DfQF6V+uzpfWvhJOzInOZJkScmEOAZwYVTv?=
 =?iso-8859-1?Q?voVNSN7tpVyyW6nR1pSz75ikZS5/yIiEAcpovsW1gOxnCCyCjLjCs6SJ6G?=
 =?iso-8859-1?Q?aU8rlyer9hnFD9zUrPguaRg4rLBaT0W3mjcmdaU5HLi26ELCjzuNyrevaA?=
 =?iso-8859-1?Q?X3gtBu8dTCTUTDUsnKbdl4o9hzXX5nBqFgqBBn3Q2s11VEniIoC9xJpyYD?=
 =?iso-8859-1?Q?ZCC7gGNRD1qLWcMUNnz9x13DtUMIQ+/rtlbCSUW1K13bUzkdXIGp7PH8P4?=
 =?iso-8859-1?Q?lhEcJQ3VUB2vQf4CInJrL/eNlvskFAIdcK5VWgOgOFNCgB2IjSSSFELmdI?=
 =?iso-8859-1?Q?HZc1a6Y1V7J+Xo+lrPlcr2qrtSAY+SVhcfa598VEsRafhdaZdzjycUeGdv?=
 =?iso-8859-1?Q?k+housufvpo+m+hhtlXPaU0fCCeSJcyH5+bpkSskRn2Ef58z4azCNG/Gwz?=
 =?iso-8859-1?Q?PHO1Jm1zwjM1Z8/Y?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR05MB3281.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0264688a-95f3-4c4e-300d-08df47a94210
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 08:27:19.2671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7838

SCSI_IOCTL_SEND_COMMAND copies sense or returned data to userspace while=0A=
the completed request still occupies its queue tag. A fault that needs=0A=
the same queue can therefore wait for a resource held by the ioctl.=0A=
=0A=
Save the command status and the compatibility-limited sense data, then=0A=
release the request before copying to userspace. The data buffer is a=0A=
separate allocation and remains valid until the existing buffer cleanup.=0A=
Keep the positive SCSI status and -EFAULT return conventions unchanged.=0A=
=0A=
Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-copyback-review.31b8d6a70f4c@=
outlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
Changes in v5:=0A=
- Set rq to NULL after the early free and use conditional cleanup (Bart).=
=0A=
=0A=
 drivers/scsi/scsi_ioctl.c | 21 ++++++++++++++-------=0A=
 1 file changed, 14 insertions(+), 7 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c=0A=
index 16a0b6bf573e..25c905c4943b 100644=0A=
--- a/drivers/scsi/scsi_ioctl.c=0A=
+++ b/drivers/scsi/scsi_ioctl.c=0A=
@@ -556,6 +556,8 @@ static int sg_scsi_ioctl(struct request_queue *q, bool =
open_for_write,=0A=
 		struct scsi_ioctl_command __user *sic)=0A=
 {=0A=
 	struct request *rq;=0A=
+	u8 sense_buffer[16];=0A=
+	unsigned int sense_len =3D 0;=0A=
 	int err;=0A=
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;=0A=
 	struct scsi_cmnd *scmd;=0A=
@@ -644,20 +646,25 @@ static int sg_scsi_ioctl(struct request_queue *q, boo=
l open_for_write,=0A=
 	blk_execute_rq(rq, false);=0A=
 =0A=
 	err =3D scmd->result & 0xff;	/* only 8 bit SCSI status */=0A=
+	if (err && scmd->sense_len && scmd->sense_buffer) {=0A=
+		/* limit sense len for backward compatibility */=0A=
+		sense_len =3D min(scmd->sense_len, sizeof(sense_buffer));=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len);=0A=
+	}=0A=
+	blk_mq_free_request(rq);=0A=
+	rq =3D NULL;=0A=
+=0A=
 	if (err) {=0A=
-		if (scmd->sense_len && scmd->sense_buffer) {=0A=
-			/* limit sense len for backward compatibility */=0A=
-			if (copy_to_user(sic->data, scmd->sense_buffer,=0A=
-					 min(scmd->sense_len, 16U)))=0A=
-				err =3D -EFAULT;=0A=
-		}=0A=
+		if (sense_len && copy_to_user(sic->data, sense_buffer, sense_len))=0A=
+			err =3D -EFAULT;=0A=
 	} else {=0A=
 		if (copy_to_user(sic->data, buffer, out_len))=0A=
 			err =3D -EFAULT;=0A=
 	}=0A=
 =0A=
 error:=0A=
-	blk_mq_free_request(rq);=0A=
+	if (rq)=0A=
+		blk_mq_free_request(rq);=0A=
 =0A=
 error_free_buffer:=0A=
 	kfree(buffer);=0A=
-- =0A=
2.43.0=0A=
=0A=
