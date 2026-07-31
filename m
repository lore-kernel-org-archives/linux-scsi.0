Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19010021.outbound.protection.outlook.com [52.103.23.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16061343D8A;
	Fri, 31 Jul 2026 03:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.23.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785467503; cv=fail; b=XmqClaPSASdqfgG/dgIJtueFE13UCal54EXvuFKH/nHEaXL5glxg7JS3JfR0eQRP6u6s5zllp9/wUmbZj7zqj69Z2kkKOtKrV0EDcXxEFGLkNumQwhkzGknhKxH0iIndhju8njeQuKJmyNJisTSd83ldPvAldUQ4RmXPOhHkPhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785467503; c=relaxed/simple;
	bh=M5O/gfHW6h9lYhG1VrOxblZQb2cwjdTKYNiI9qgkvvI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ChlDA6w8aelyBXB0DwI50fCcUgQHD6E6KI1db3SpEJ3uO8KIvIa4rrdy6Em4du5nSj8ssmo+UB9PZ7ea1qjmCCQxm06HVkJuhvu14VyXw1GM0DgXvzzpzy5Dz2EthUgN6ZP48KkVo3itlM9tzUY3EtIjepuKRhmfLHN2i0VbvGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=gFgSpJ2R; arc=fail smtp.client-ip=52.103.23.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="gFgSpJ2R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=csWXfHdoLIxhUTm8ZmVZb2JPTSVlydw6gn7JXhF8h9iWrlltbnzsSL37bcDlv1Lys60e0IJl6DfNdHdlVGdFLfC/IzDhI/K1dS2HwV7IFTIQ8nMpIZ/F3FItAIXDL/JyuT6/PYvpmNNLtYckySdJdW69qLa0qnEdSK50sYM77cQZ07KWAvGe5ZOadD+xDghgSBdAut8THSTLSFLR698clM+nE1lNyasTGmRGO18KCyC9DhxZ0ty84XIgL95zHsCA4mXXfFnJKwB6NaIRjzkPGHdxkuyQccUysmVihQWwKmx4fpLUpJuF3nnFbRvF7p1+F4e8Yzog9j5vlUnUsCzPng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5O/gfHW6h9lYhG1VrOxblZQb2cwjdTKYNiI9qgkvvI=;
 b=ltSb6rvtE0Nqdp2ZG/2Y6eGCdqBN8h+3n8yXFfxv2iMpIKECvZF5kBudcc1yoAoGarmF7sp63nMt8nQHUqKnp/LRP2WYx7ISQ2MH8st10KWp10FeF30P70KpoJhBJs5bXNg82FajbwQIzY7bnUG0IoHHfD9oUew/Ay8SdQKmaKtg7d5Gh34rVBZIPdq7GSH35IjQ4GtbhV5v7z3z8XdJAGuXnlt5sA00aurxXuQzMKB/8e5oEIWowznlr6I0165Jm/huDYSTqARxLnBtsOz3IUwKTreNTP79KJDzG9F01P9R5D1mAu6lXDEJQGcN2R9JJJdPDJT8/RcnvDRsbBmBHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5O/gfHW6h9lYhG1VrOxblZQb2cwjdTKYNiI9qgkvvI=;
 b=gFgSpJ2RiIEwGsWgqE6gF1XVhW5eoYIZcEJs8M/abYHkLyK9JOglKvKsJlfYKCVcIOLtQiaHYQ1cMPXlpRbEUEoamtaPQTCAfBnXefDSm0bu7XiUB1RwknRvVHF9XAA4YjD4JE59aGcPkzpFFxt/Bqvng07TikbrrbOOQ9b39NsiE2Z8DtKs/3tcLporrbuklh9FlKaN9bkjeQelkN/AZ4LuxbeSzGOKiscVpBT3I53PThxe5otQjMAp+Lvy+a6pDW+4p/DlM0wEtUKybHBWIoWlBPpD2kuiBL1lTIIp4o0SFP8tOzinO/5nd7Sfl1II+zulA1SvuFJbqKVNYea++Q==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CYYPR02MB9685.namprd02.prod.outlook.com (2603:10b6:930:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 03:11:39 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%3]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 03:11:39 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	Dexuan Cui <DECUI@microsoft.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "daniel.lezcano@kernel.org" <daniel.lezcano@kernel.org>,
	"ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>, "tzimmermann@suse.de"
	<tzimmermann@suse.de>, "airlied@gmail.com" <airlied@gmail.com>,
	"simona@ffwll.ch" <simona@ffwll.ch>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "sgarzare@redhat.com" <sgarzare@redhat.com>,
	"horms@kernel.org" <horms@kernel.org>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>
Subject: RE: [EXTERNAL] [PATCH 0/6] Remove support for Windows Server
 2012/2012R2 & Win8/Win8.1 versions of Hyper-V
Thread-Topic: [EXTERNAL] [PATCH 0/6] Remove support for Windows Server
 2012/2012R2 & Win8/Win8.1 versions of Hyper-V
Thread-Index: AQLX8L3XuIcptfjfd7XUkrHzbwgCtLSQ47yAgABvYdA=
Date: Fri, 31 Jul 2026 03:11:38 +0000
Message-ID:
 <SN6PR02MB41571FC2686AB21739D8404FD4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20260730184846.3165-1-mhklkml@zohomail.com>
 <SA1PR21MB6683DC244AFD27148A0AA213CEC92@SA1PR21MB6683.namprd21.prod.outlook.com>
In-Reply-To:
 <SA1PR21MB6683DC244AFD27148A0AA213CEC92@SA1PR21MB6683.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d419405b-3d6f-4803-9a61-bcbca652148c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-30T20:23:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CYYPR02MB9685:EE_
x-ms-office365-filtering-correlation-id: 459df061-ce9f-4677-aad7-08deeeb17011
x-microsoft-antispam:
 BCL:0;ARA:14566002|51005399006|12121999013|31061999003|13091999003|8060799015|19110799012|8062599012|37011999003|24021099003|55001999006|15080799012|25010399006|10035399007|40105399003|1602099012|2607281247196008|102099032|3412199025|440099028|4302099013;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?x/MvPMAUkZ190kMWW4VYtm6rsR8kWOJ1dhTJeWf4K6WnNU+GvJw2OzrOLoOl?=
 =?us-ascii?Q?ie1lWW9sTXTTHYLScq4sEdUj+RmYe7V1oC1xmeKZZlCKD4C6NlCK84uHJfUo?=
 =?us-ascii?Q?jk7jD6egCZsO4ojS98BsJL+A9+PgBgr39XPgq9JsUixQGlXWElI1co3GDaQ/?=
 =?us-ascii?Q?Rj4vVPJiE+WGFRFu6Hs2oAzBySvRZroDUldgVJ9xzhVlRf/M7tPNs27qEhQT?=
 =?us-ascii?Q?rvmb6X4rCZ/NdiLfPDPYrlhRdPkJ54TanMTEysvwZem5SXm+XLsSqj4JJvBk?=
 =?us-ascii?Q?lP/6YJfWA86u9uNIDW2rkPDzKrSt5t2T9NqSMLUGxQlkBHQA4Wvgil60eAJ+?=
 =?us-ascii?Q?NEB+cRJf7eQFf736aT716eAFJ1aDOnUWuIh2Kb22C2ZcrbNMxTgYN7wpoX2w?=
 =?us-ascii?Q?9SVoS17fBVUNFJy89WtQ6J3PBrvXPOepqHaHNVVdCSwuJE/86VzVdKm5m6t5?=
 =?us-ascii?Q?ZBtleO06aBnqv4YPem7FdpD1t45XkziIeE9umv9YEP4N7sYqkqN/JCx0UZAD?=
 =?us-ascii?Q?TUhCcoLJQiBqzlpakRhDSR+ar2vUdi+KEd4R9chBNTvoX4AIR4BTr1e+5+qv?=
 =?us-ascii?Q?hLRF6g54KuPjHnahiQXEdbl1LQt6YBy8wcWTMTrOlmN8lBF3Sf9a6K3DDKDS?=
 =?us-ascii?Q?izKtRObe/7EGeVKig7aifEhAYK96+pbLm2HpPc2TUKFEjtq4wbURRIZto5T2?=
 =?us-ascii?Q?CtT5uMkDRTdMUtxoo2l1DCuVd6DnhkkyCte7Bd6URnMC+56HsNVWGVGx9bk2?=
 =?us-ascii?Q?I7X2wgvXjvz2h7EEne6J1lINeDme0OLU50WNgctBb61DeJA5n8cOAk/jQxQA?=
 =?us-ascii?Q?dcyYEYSMa0nurPeZL+uxilvDGEzmzGmkNbF7wdj1SrucQmnM32xQeKAVP+OS?=
 =?us-ascii?Q?EJ/03PH0IYbKsgKg6/LFJviYsngmj73pvmxL66dSYN3V5F7zMT0DzOxYcmtN?=
 =?us-ascii?Q?kJUVf9XXlAV7K0a7W5GBKlSmcIlVqreFo8eRryFobnl6oUSQExk6rjjX+9mv?=
 =?us-ascii?Q?YW15PRt6Sh0KqUlRy4bRzyXlPY1f9nHxcnHij5m2x0SF6uM/YLmIKnRuoR1b?=
 =?us-ascii?Q?IfOZQGRcvAqFgnRn3Z+cCdhNZyqXRmHtfmPFeRQOB3qIwuhtLXK5JDBoHeAh?=
 =?us-ascii?Q?ksyiMoyC39Ud5hqsp/EVPy9Q2zs/yel+S1eLD0zciUT5/3gC1uiSxzc=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?V5i35HPb6VbeDAe3W7whs2L704Almj6DINFXLDKfnZg9lniA8B+zht8WsUcL?=
 =?us-ascii?Q?UHXld1Fup7aUsUVqaE7RsFEzkyoiMRyobcB9YUx17ul7v5JTtKCnK7rQcJfF?=
 =?us-ascii?Q?bJ43uWuRecp53OGsxCKQ5amBAjt+wzyEqKrmMP5bxQmDuG3w6xzuefQrisOK?=
 =?us-ascii?Q?C9pzvjd/RzfzuDrdOkpEofiLMYTQUSbFYZ0LE13y2wuXDgAbmyc1y/cszS+t?=
 =?us-ascii?Q?CbGi+m9BQnrx8lr+2uZW5GpyXa+fhExbDpbLxDGzVc80ZtDtXeodW7jOjSDC?=
 =?us-ascii?Q?q8l+EoVPET2isoVWWRO9PSgtcVbi9VUbZZ0ZeASQSZKHtyI7MZUI12dxbc/B?=
 =?us-ascii?Q?d6JP/zez5nmXrB64BixwxWJEpnqWJBCSjHq0OPNnr8zmPi82FaKeKUzKiWNJ?=
 =?us-ascii?Q?7EkPiWHT+19/iyh3KDj7HLJIILmvI3E4+Jpt2eMuSMMddbB6Lc9/No9yWLVu?=
 =?us-ascii?Q?BduYAm6dzA82+jqc/FZj+AU06Yz4D0s9+Lb5LDVA0cHeNu3DU1cCPHB5nFoZ?=
 =?us-ascii?Q?UlDz8jemPcoA83oSaoceJA5bAy+qqCWeolVZbSmgydDzs6yicrcLo9qEJrHb?=
 =?us-ascii?Q?pV6xlt6AJeIYtrZOmW5CnCM3XzCOP5GglK7P+2lmekSrAVZrA/u9fjL7yAoE?=
 =?us-ascii?Q?qR4q3/pJARCdH5zqOl5g+bRDNz1UMorzD2R9+O/yFvCRXgAlHyImKatIBWUz?=
 =?us-ascii?Q?yShzrTJMX2bAP/TXwi4eAJq3LxjKIfkr27GM8KjRMOg0p7bkcW/fvOqPtbw1?=
 =?us-ascii?Q?1MtCrKKjBrpy9vlLqiVh0kaFLxbcBhO5yv6pb1O3Tqe+Lwf+6YPeFAw8ehVN?=
 =?us-ascii?Q?D7ffmXAamGp2Hgl5+0y4e6b8fYC/wzINwjhmkfnaBTGd7W1UC5rb/Ob7LCMf?=
 =?us-ascii?Q?UbJ4pxbJ/5RUKAnpCVn8K0F2gdh60NATWi/DospjNSag30XaEyoacKI0p0p2?=
 =?us-ascii?Q?vNZ+GzmLOlt+vy/JEIbrj/FUZ36jppTYly4v8h0oqUKQw8oueSW2jAM5upY7?=
 =?us-ascii?Q?PEFGbjvmQf2H0SaMd2Bdz70GL5maBH5aqK5RIquf0keFiy/H9JkHooIGjybc?=
 =?us-ascii?Q?dflsTCKnMUL+9powlncC9HDCcgxeY4WOzQxRvF6qdNKmfEz+Ne1h9TPfovkN?=
 =?us-ascii?Q?dwAeP+pQrwFkSU76AsUNpoAXaeKhYE60czcnoyPTTsM0w3yt/mK2OAeyolky?=
 =?us-ascii?Q?LH4UHNOeaIneBjgyyEnZ6OH7yuc7MKKeC+2hUC7Gxk9gO/d4Mh36jTLBnPX8?=
 =?us-ascii?Q?JO4x0M57OcfGObeYIdYE9fC0k5GAsnVHHAxl9RpNH99HiXCaCNiAUpVxbwVY?=
 =?us-ascii?Q?/HRIuMiF4ObhzqJ1dK/7ZDdHBGPQaiZ4on3gvEYYqrXGDKAKTkJXRwwY44jB?=
 =?us-ascii?Q?tQdM5fE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 459df061-ce9f-4677-aad7-08deeeb17011
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 03:11:38.9925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9685

From: Long Li <longli@microsoft.com> Sent: Thursday, July 30, 2026 1:33 PM
> >
> > From: Michael Kelley <mhklinux@outlook.com>
> >
> > Linux code for running as a Hyper-V guest includes special cases for ru=
nning on
> > Hyper-V in WS2012/2012R2 and Windows 8/8.1. These versions were initial=
ly
> > released 14 years ago, and official support ended in 2023 (unless a cus=
tomer
> > has contracted for extended security updates). Given the release of sub=
sequent
> > versions with improved functionality, there's no need to continue to su=
pport the
> > latest Linux kernels on these versions of Hyper-V. If someone is runnin=
g Linux on
> > one of these older Hyper-V versions and doesn't want to upgrade, they c=
an
> > continue to do so as presumably they don't want upgrade the Linux versi=
on
> > either.
>=20
> This patch set has significant implication for customer running older Hyp=
er-V versions.
> There are probably a large number out there.

I don't have any hard data one way or the other, but given their age and la=
ck
of support, I'm doubtful that there are a large number of customers running
WS2012 or Windows 8 for any purpose. Even fewer would be using Hyper-V
to run Linux guests. Of course, the Azure fleet was upgraded many years ago=
.

Before submitting this patch set, I had an offline email thread with Wei Li=
u
(Linux maintainer for Hyper-V code), and one of the Hyper-V dev leads, abou=
t
removing the WS2012/Win8 Hyper-V support. Wei checked within Microsoft,
and came back to me that it was OK to do this. Wei could give you the detai=
ls
offline. Perhaps there's internal data on lingering usage that informed tha=
t
decision.

FWIW, you may remember that I did something similar for Windows Server
2008/Win7 back in 2022. See [1]. To my knowledge, there was zero customer
pushback from that removal. While WS2012 Hyper-V was certainly more
feature capable than the original WS2008 Hyper-V, anyone who cares would
have updated at least to WS2016 Hyper-V as a mature baseline.

>=20
> Is this clearly communicated to all the customers in the field? Is there =
a link from official
> Microsoft statements on support statement of this:
> "they can continue to do so as presumably they don't want upgrade the Lin=
ux version
> either."
>=20
> Please point to the statement that they can't upgrade Linux. A link in th=
e commit
> message will be helpful.

The only external statements I'm aware of are the Microsoft Support Lifecyc=
le
calendars that show Windows 8 support ending Jan 12, 2016 when it was super=
seded
by Windows 8.1, and then Windows 8.1 support ending Jan 10, 2023. For Windo=
ws
Server 2012 and 2012R2, the end of support was Oct 10, 2023.

Michael

[1] https://lore.kernel.org/linux-hyperv/1651509391-2058-1-git-send-email-m=
ikelley@microsoft.com/
