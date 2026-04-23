Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011030.outbound.protection.outlook.com [52.103.72.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF762F39B8;
	Thu, 23 Apr 2026 07:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776930324; cv=fail; b=JBXT+ozKE2TMeLcHAw1hJRn6/j5SbpBOPV2glNpnl4LuiXNuhKWoHV612JMN4wNhPDieycfgvib1r8DRk6ZXjgXGDub1UHfD7jFARlHSTsKGu1o2JMlHNpQSCf6jaXzADFNzU0At63c5feksdTviE3Pa8sjZv7WUGKG3zPO6oU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776930324; c=relaxed/simple;
	bh=sPzuiGE62Xgdf6d8+gf4Nha0jK3pqg7sZzzUWEDggrc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ihcpofZtpPNftYhm7yu+n/WxzBj9xjMEMCiF5mNSb4iosFvmOQo0SqWTyNYU1W1YAMUWaEr4qSk5L6gBDK4cR/d+rEc/XhiiRBb7m8XH3P4UNbGWnF2hcX1k41ZeOLiEPBBhTBmn+/MVmwAU6Rm2rAzgZa2afePF4n8ko3hUYTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=OMUQN4R5; arc=fail smtp.client-ip=52.103.72.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="OMUQN4R5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ci8H6RNkgSYwWcJxZTD03/YvJObxMQy6dWuIsPQyMhF0zsJjrtFMaKPVe1AUHLSwNVBQtDgIXaZ4GQg9vLRS7rn+WzF1Ogz/+aFmL4IcTWs0jEiM54E0Ka/mfyRnngnJwB6XH8uq9gVJU5659ZNpfXA28PTujgSU+QCqXNvXItM8e6kVcwfMJdAWOAD9JtV426P0WvwbEwIfErNgAe1d2710PQBG/9+QrzurOvSH+UU+UqaiCaFFaU7lQEj0F6PnFmGku7SU+pjEp4j3AAUt/SehXEUQ1pMl0bPzRfNh8P4sD8F91jwJvhVyR434eI1VUE3CtA6CxRxsP8h99TMRPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LAEhTP2M8vFdw1tD3vUjMCCyrMySL23feXdTefUqxpQ=;
 b=VPKxjij62j6AfH2WIlP7DY+JguqqaT4jgkLBASBWAPelOKrFsK3V7njuZB6sNe381gPp8XHy5zIhFJHJgsixqmqdGctu9NhvBJ8V2s8vxCY19vIL8DkWpW636x69yKUaXltnVBa3HvWwdvGXVm23GXpy4J0pEAfuXVZeL9uOck/w9SGM3xN2lWyg0/GapPN/PWZmXzBNb4X3jxZL+SyO6DXaSv3CYPO1bGW3EfSyZupWoWdCdyWG0dtBH5+iaTJugl/7mURRV2fv9k9pYqJe7s7OtU046P1xW+0hsWyJuLvCII0WcnWep6WaP9SwSPiRmT8JoArOe4THrG98nuc9jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LAEhTP2M8vFdw1tD3vUjMCCyrMySL23feXdTefUqxpQ=;
 b=OMUQN4R5v4bssHWI0TX0GHfIpU0y6KzV7SMbBVM73XIgsAY3ZG5c3CL7+qsyLv6IRozF6kFTORxb1S0NoFh82R2kq6VjSGwj8SQZKudq6qdfzlmq6a1F6qoGIY5GV+vfVWgHYPVR7gHuqkYtAvgKcF7rrBVnxKe8ljz+NcMxOczmUHmxh1bf8/BNNdsI5vG/59og3kZvFVdLeEJIJg9Ft2un+U5MDFOXjaSbRMWBH/VOeYYCzCD/lMoNPrJd71yDNrVC1ipsS918RuLZaPa4we4NbFhJ5oExrr5n3LBzqHno7XqAb60oWhHyI6bl5DsuXb/JGDTjkV1i7BhAz89Wtg==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by ME5PR01MB10830.ausprd01.prod.outlook.com (2603:10c6:220:261::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Thu, 23 Apr
 2026 07:45:17 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 07:45:16 +0000
From: Junrui Luo <moonafterrain@outlook.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, James Smart
	<james.smart@emulex.com>, James Bottomley <James.Bottomley@suse.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yuhao Jiang
	<danisjiang@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] scsi: lpfc: fix heap overflow in
 lpfc_bsg_diag_loopback_run()
Thread-Topic: [PATCH] scsi: lpfc: fix heap overflow in
 lpfc_bsg_diag_loopback_run()
Thread-Index: AQHc0jkEbPrp93J6QESyMQS8jMxCi7XrEz6AgAEyfAA=
Date: Thu, 23 Apr 2026 07:45:16 +0000
Message-ID: <E49826B4-1136-4DEA-8792-4FD708E1B2D2@outlook.com>
References:
 <SYBPR01MB7881DCD912ADB83C9D290F7AAF2D2@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <a265733e9bd63abe7be8f5e77e6a288247c4ad4c.camel@HansenPartnership.com>
In-Reply-To:
 <a265733e9bd63abe7be8f5e77e6a288247c4ad4c.camel@HansenPartnership.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SYBPR01MB7881:EE_|ME5PR01MB10830:EE_
x-ms-office365-filtering-correlation-id: 013b1e44-9d62-4fb1-f5c4-08dea10c42fe
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|22091999003|12121999013|24121999003|8060799015|8062599012|8022599003|461199028|24021099003|19110799012|55001999006|31061999003|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?wT5zm/3tfeS0TpxaHk0yPzOyg9kw31LxH8IX8lxytb55qGBgP8hN3d+Ry0TC?=
 =?us-ascii?Q?TY4zADE/L9dAgQHWBC0VyRlti+gXVgLbFT/beE54wo9BRb5d5RQC8ChBjpM1?=
 =?us-ascii?Q?/PFffTE4xc8Aigr/SPwu4CcdsunE8gbBHAdEMzuHtVytZ5vQDO/sIgX2JLEZ?=
 =?us-ascii?Q?gv8Blm7hT9plTgP9/boZUq+J1m/vJ7elZ8b1RIV/nswPFfhJDWxWMnQyDA1f?=
 =?us-ascii?Q?RWg+YjQU/Io0p3sYnlCFlYRgy0F4DfQjd44gEELJc13oQ/DAi4/XJJJFczYV?=
 =?us-ascii?Q?khLEOKuj+V24X9OZWf/rxHQE53iUeIDFUeH6n42URR1+zuoCNnBIXB472jN9?=
 =?us-ascii?Q?SgFMpJ1u46uO6nwT1mXEvMIFlAth2xAssxsv5HiR52gcKzsmORH6i/uatXpL?=
 =?us-ascii?Q?KTV0AslLQH19vkgXv3hKztmGxaQJ1zeV0Kd33ApEiboxrk5aRoipLH8qdUzm?=
 =?us-ascii?Q?/JsNtHWfIGUr0HpVtnT3eWN7KvcVc4pRlp5K/SrQU6QLjZAvdbktAy99BpMK?=
 =?us-ascii?Q?weTatLFwBdWcetk4JDDsCfTT1NL8MsxnbRbBtDpaaKlp2zmeWV2NypMreK/b?=
 =?us-ascii?Q?HRk+qFSE0L4MA31lB5Um4yoYhrCHOOLLVT79037PYBF23zzIb2kvKUuzNjXJ?=
 =?us-ascii?Q?3dJrBNqeYxxBc3lBaFcSXiCOw4D91REayQFIcsL7WLGkfQpncMAWnNdG0ADn?=
 =?us-ascii?Q?cgGEXeF11QPDhSTKRrnhzvlMS2hB7Stzgy7wseuy3grBpWFSlUKiS9+YlwRT?=
 =?us-ascii?Q?nNApaayrjEfx1RwLUdGf2DuJeO9JIS+NRwa2u8b840We9QJUV5K85PYliooX?=
 =?us-ascii?Q?l1c+/emOEtXk36MoTU+sHI/yOfLBl1xD+ox1ZN4wvjgjeIjsp6bYb6p1baC1?=
 =?us-ascii?Q?/myZewPE2PyziodVokWgO1bPc1+JlMZQXTvMxXynOuBb9Xn475Os6GYcsPaT?=
 =?us-ascii?Q?EdQ0qq+NHqisdFloaj9LGse+DH+GnAOu/QOlffOBZVI+IXXIJo4qeimC1z/7?=
 =?us-ascii?Q?y23QSH/gQfC6U7GzmBp/XygRtKcleJT8nF2KFpabfjkueSU=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UU3dexYOr58wnKwPMNeRO+PDW6975mlFsYB0JJ74vqpESRlFdLwYFNNJLSNV?=
 =?us-ascii?Q?p6EicaSJCT0wq+TPFjRqdM98Rg882nRjYG82a9fNTj5GB5x6JGK2dXT7a5jO?=
 =?us-ascii?Q?XnNzZUidsKXXVavzt+7c+aQVX4STdZckp3OL6JWMKTBXmT2N4PkMFbhl1qgY?=
 =?us-ascii?Q?/GW1N6x9kZpSpkt7kRxtgv2qnpS7aMFR1XKOHxi/ako1G5o/Xj6eCbB7mXTc?=
 =?us-ascii?Q?r1y/nrIYZwKisCDX1bbGFJ1ub1P4ADYfdgEQbyDSln+H97ecN0TMJ8rnD07J?=
 =?us-ascii?Q?aAeSE5tyamyb5lIbWYyMFsZf1QuE1ymojA+Ze8Hz++AP77zdZ1wqcx5wLcxv?=
 =?us-ascii?Q?EaydnGLOry+TvHp6UBOLFFi2ExODHmuD6FMoS8WvAjeabF89Po9yELlov64s?=
 =?us-ascii?Q?8LyK5NrjzrR8XnK5SfdK6gcwNIHYGufuRf44H+M7xT9ekHQB1T0DFc1z4sQM?=
 =?us-ascii?Q?SjjXzq2/lNhu63e8WQoQ9tgbvHNYYEqg2YJLJQIGpQF3ChVohOJPBPZ93FQL?=
 =?us-ascii?Q?0X67le874vfEsKXCZqFSkwlk47K9tCrPbX1dSySG7rh7mqIVgkNdSM7ESUh2?=
 =?us-ascii?Q?AHpEgHDnXjFkV+h2jWusb17sOWzlj4AGoZONuk/Ojkbnza7l5dPQCoO2oLJV?=
 =?us-ascii?Q?223aKq+37HPBySEqHi41U02O0QjBDI2Ow5r5MxGBfl/T7tJsztKPnaxW+B2I?=
 =?us-ascii?Q?5Tf07mo+Yc/sFqmT1enN+E0xvcXfgj2VKgO4ybG2Drz6WJvfYRDPVN2Ek2YU?=
 =?us-ascii?Q?6uMfUdgZi3HEY9G8j4tgrbZ/RLNcgxmYOofer9+XmcnNEUeI05ZCMonjW2lD?=
 =?us-ascii?Q?U8AJMkiIR5H4Cpr5z/qoEgVeXN3OTnS6fvbIq8ZcPn9oo7opDsj+bDDsDGvA?=
 =?us-ascii?Q?uWltyBHQCFRP5xKXG+iHjfc5n6g5niNRWD/kqJuyI6QLk6YFDH3Y3qgoTiM1?=
 =?us-ascii?Q?0J9UWPUc8Z2medZHNcaGgW9+M5pu+lDq+nzCHnjWbmPCz2dQHTcv9Xb1O9AW?=
 =?us-ascii?Q?GvkTPtO8BUWF+XUOUAWPVrh3xa826GvBXzCqyT2goLmhGMFFqNWhrI5ex25b?=
 =?us-ascii?Q?RN1TbLiX9dpNFhl9gSlji4kBmFi1zemYZhvjKzjnzxMyCX6R96Vi/IquLe/J?=
 =?us-ascii?Q?HO2qtkV1uOv2oJS1cyZ882/2LIZGCcSLI/UOWGs0SMT/sHhXUk0OAairw9Vq?=
 =?us-ascii?Q?hjP/3cfQGdFwUQLk5xHLBH/VZ64snR7dDKG2zT5VTCvYA1S0IAbhIhhIODVK?=
 =?us-ascii?Q?9ehDSaovxgiS+j7ZVo3k6WINrIbtAeK3DATvnf4zR9oo5lxPiRpSlVKcGjMy?=
 =?us-ascii?Q?C2Nd6Kp9R35HN1yMRenxhfvH34zSTRsWJGaW2jZl1pQACgwaELMXxS5Ghb6w?=
 =?us-ascii?Q?uuvu+wNj37oogB61Q5MP0uMFc5NubRLebonPpv7U/9wsy4wEJw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D9DD80996BE7C458262D72244A96A68@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 013b1e44-9d62-4fb1-f5c4-08dea10c42fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2026 07:45:16.8674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME5PR01MB10830

On Wed, Apr 22, 2026 at 09:28:03AM -0400, James Bottomley wrote:
> Are you sure?  The comment above the code you're changing says:
>=20
> /*
>  * Allocate memory for ioctl data. If buffer is bigger than 64k,
>  * then we allocate 64k and re-use that buffer over and over to
>  * xfer the whole block. This is because Linux kernel has a
>  * problem allocating more than 120k of kernel space memory. Saw
>  * problem with GET_FCPTARGETMAPPING...
>  */
>=20
> Which implies the intention is to allocate only 64kb if the payload
> exceeds that and break the work into 64kb or less sized chunks.  So if
> there is a problem here, it sounds like the loop over 64k chunks would
> need fixing rather than the allocation.
>=20

The chunked transfer described in the comment was never implemented.
sg_copy_to_buffer() at line 3127 copies the full size bytes into
dataout in one shot, and the list_for_each_entry loop reads from it
linearly without any chunked reuse.

The comment's concern about "Linux kernel has a problem allocating more
than 120k" dates from 2010. Modern kmalloc supports up to
4MB (KMALLOC_MAX_SIZE in include/linux/slab.h).

> This would render the if clause useless because the branches have the
> same statement.

I'll send a v2 removing the branch and the outdated comment.

Thanks,
Junrui Luo
