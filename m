Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazolkn19012063.outbound.protection.outlook.com [52.103.2.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66784A23;
	Fri, 31 Jul 2026 03:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.2.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785467608; cv=fail; b=f1aHfslxtfzs8UWePdYDmoSGob1A3FGVetPC/4KjHIxvPkLjx1R4HcHa5kcTBIcaKX2/sNabD+8CTLG4IGH21iVYh+dY+dh/BhFp3gDEPqlNaTf8uGROi+OmSRowtXS/CSy7BuNIWUmHZv+JKD5vJUJgQ7K8ncAYxMrDbGqEc4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785467608; c=relaxed/simple;
	bh=CRyB1LrG7O1VZvKrhJqrg5oo0LSU1QdXYOAqiq/gHB4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e4uAzniT+YonvaumtZWWiswluYtlc1QTqsCOFIR8zFSdtX+mzRtzEBuEBU/PTVzVij6QNgIk++Pss8CO2b4mOpi9DDg8vY99si2bZrVLOaWRsgNzxesGrIb5OIVVs+hHmFDofe4sjObk16hxn7l3xMO5vLBMMTpwhfJUvqa+/AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=MgjrSi3e; arc=fail smtp.client-ip=52.103.2.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="MgjrSi3e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bMe3ZaDf04GFPzaLMWT9Iu5vqvlJfpSWVHbIN+z+IGGtMGf2D0IzS6Jq8avYvPHZBJv618LEfemeZ5dnLfuWwEtJMKKvfUwPKQ2zqVSQgwEO4+T8I7p+W384l0LfTizr4VWGsqyKyKhVTje8HzoAUHeWMBVYTuRuYs6rFgCe+0ZoN9cZvikMm5UeiS5jUaBRz/Y+SapFHTFfxuxE/lWRtnqzTqOxhx/2NI/zZzomfAbpsvmSCWoKdIKfcCcqg6HEqzjifghKMspbwZ3FVBcqLJU19HK0ASG0Bgye76prAivHsZjSbuqROxtgCM2TckcmxdQ7wGMCyPBR5bh8o/E5Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRyB1LrG7O1VZvKrhJqrg5oo0LSU1QdXYOAqiq/gHB4=;
 b=YVPREyJJcHUmSbWVnLuxkrCbfQqKddVKFeyx0z6kmWqKuzTbGCh3NmWgVZyEC+Y7itv2vEEdnMeQY4hAUtaB2QaFNn7gmfwWxdAV3YxPnjg9Q7RyoNCKZ+wXTEJvYfZh173ylDZAtxqFHORsk/fAO2PDcnRmjDBjV5HzI1121pOZIBXdtV1Ey4Sw6VR1B1ZjeJjLPp1DixHXtogPNddr+3aaMKNGscjB1aE1c9eYrBx1JMFLAeSxXx5lFzToNrKXl1JhCgjBhAIlTSP+nMCfjPvnHEj4+oMWFp3xHfbTEvRP99gQHpiPQ9aGZzKsTxlEQbCnAQFEGIMz9PaSFy6kBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRyB1LrG7O1VZvKrhJqrg5oo0LSU1QdXYOAqiq/gHB4=;
 b=MgjrSi3eGjjxwTKKq2PC3HxI7qlz6FzaxT9UXJxlhEMIY5wiOzht+NOEKPDyl/wG3efAbOWl5z08qwsM31zNZsC8cPGVYNL163MCwpf+13onC955DfsKYvlf3NvAleYTbkFu9/feFIj1MBlsFSvwucyysJ4T66PWSwy0nSLYRl/h1YecxHTYF0pbDThlLtzuo8bP/UtzdKj7kCWIh0tKsa8TiKjOgoRvuDXg2JjJN/MAS2IdH4dulxCa+UG5sFxdxMon85NmZsMrFJvYUfB6pGaDTzJcjiUNd5qkWHSekL74Q15DycISlS4axFxz4G5oBuwt5vpiOXirIEOevMPEaA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CYYPR02MB9685.namprd02.prod.outlook.com (2603:10b6:930:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 03:13:24 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%3]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 03:13:24 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Dave Hansen <dave.hansen@intel.com>, "kys@microsoft.com"
	<kys@microsoft.com>, "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, "decui@microsoft.com"
	<decui@microsoft.com>, "longli@microsoft.com" <longli@microsoft.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"daniel.lezcano@kernel.org" <daniel.lezcano@kernel.org>,
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
Subject: RE: [RESEND PATCH 0/6] Remove support for Windows Server 2012/2012R2
 & Win8/Win8.1 versions of Hyper-V
Thread-Topic: [RESEND PATCH 0/6] Remove support for Windows Server 2012/2012R2
 & Win8/Win8.1 versions of Hyper-V
Thread-Index: AQHykTBh5c+ZTCJ8JdYW7ttKg4YPnLZbx+cAgABKzoA=
Date: Fri, 31 Jul 2026 03:13:23 +0000
Message-ID:
 <SN6PR02MB4157C85C3BAEBD81262BF3D4D4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
 <a5c7150f-44bc-4ed9-80de-631ddb37794a@intel.com>
In-Reply-To: <a5c7150f-44bc-4ed9-80de-631ddb37794a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CYYPR02MB9685:EE_
x-ms-office365-filtering-correlation-id: 231179a8-840b-4d66-1b43-08deeeb1aeab
x-microsoft-antispam:
 BCL:0;ARA:14566002|51005399006|31061999003|13091999003|8060799015|19110799012|8062599012|37011999003|16051099003|24021099003|55001999006|15080799012|4140399003|25010399006|704163111799003|2604032031799003|40105399003|2607281247196008|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?3J9FjV8iaMYWZP9jth8W9/ERbboZ6UK3RVhTlKdN9P+2KWmhopBay9X10LPn?=
 =?us-ascii?Q?kriqEvoEosA7SscrViJr8hTm484AyQxKOaXI46U6+6lu93DGcnEkUfqeIQ/S?=
 =?us-ascii?Q?NQDHdlHHjcJxUgDsV90Wv3vsgiemSecSV7+gTNi5qJV4//XpAEjMPQ1v7JHM?=
 =?us-ascii?Q?8RhxnQE5Zb30NoCvqALxTAyUeI0EsY3KahGUHbwKsEtLsbSYfo3VhZCnNfQw?=
 =?us-ascii?Q?qvgIz9SO9Mi1iG7Ec8uRQF3VWy33qoFaAjIJsdnU4Cq6mO1OtQGwnDoJYZ4K?=
 =?us-ascii?Q?WtKgKrx/MSVbKNurX7Ad2FkePJGGOVcNReO+6SCKQGzLow+18LYuKYSipLfL?=
 =?us-ascii?Q?5ygFHpDpjRixPgLQB56GvCeOXzKif4vIrSI08YkIBAG22BxuJfle4Jzp8ocC?=
 =?us-ascii?Q?VQ9d+GP27rLjEd2hiqOFnwxgltfxAbbT74ZgB5d+h/IKFmLGn9m81Azzv1aV?=
 =?us-ascii?Q?qrJTGrbtHK8sMMrXm+Eo7FCaVQO/P+iMVeln27KMIUKaDAVRtEt9DfuJAudp?=
 =?us-ascii?Q?IqBxmvtnUXpkDbegc8p7l9/rsp1zmVqJK7KZlxr9U9WIjEeAtZH1x4Kad/ay?=
 =?us-ascii?Q?DMpnb/NxiknegWoCzN+W1pTJVrVtwVQkDbudFNWjwBzrwH7Mi2V5zJdbNQvm?=
 =?us-ascii?Q?Lu3HWLoJQi25J3grAA/lnMX26sLk4L6St8MJW2UZOSeCo/x8N51L1HZdpzNC?=
 =?us-ascii?Q?bW6fVqPBgriDie3WKq+/kaGlStM3xVrt0E5LeVgET2e0anFyF611MMaGQub5?=
 =?us-ascii?Q?Nq+++DeBj/Oo5V0+BPLvwN06BUSD+qtL6YiWPeMuDKxhG5VYn0zzKNzhXJW2?=
 =?us-ascii?Q?HmCMbvi9wq8Z4EOWa6GUuAKctOnkxgNwFNuM5RmQ9O3aHXLn4OOto6K/uYNh?=
 =?us-ascii?Q?7Wob2XwWUuFlyC42VY2ZCUm46GoZ1PRDjbEQVTifxb/kHPX/3VzEXeW/xs0i?=
 =?us-ascii?Q?yeC8oFyXbSqMGRwsw4mDNgK6Ul4JVABN8iTTJT18xEADYKFIcVMRQUL2JK7I?=
 =?us-ascii?Q?NnuSHSfbKbsbbxE5RNGfx/DQyXeO22sR382ThGaiw9iN192QFIXFTO9x33NZ?=
 =?us-ascii?Q?zPDRVevkS6Yp5WfJUc3RetCnqX5AkC8fc2waE3PkbWFoxSH3aBvEVssmKUqr?=
 =?us-ascii?Q?8k0NJcREcwXVOsYxWRiSvGgkZHdId3oZBQ=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?jkEkQ8CtYbXJMiW7ShLAfU8Tu9QyPK2f7UT+ToOVwwl3qisoXW4lCEB+f8f6?=
 =?us-ascii?Q?OVPOyZB6e4c5RRYD7wILwDkAyzO7j4s0wg97CDVjjGCja2K004jR+g1qwA9z?=
 =?us-ascii?Q?UQzhFBt3Eds6kZS1/4KGkKbIqEaMFczVZlGbRLof32Z6WtwHRrmWV3iZAbwb?=
 =?us-ascii?Q?uZQ8U8oPzrNcRbn35AqEJE0hcFLnS2+V0KxnkCX7N0OmjPwg6Bo62I3Y2sfR?=
 =?us-ascii?Q?TF18bVhdwae1thQ9y8PwFJ6QWnAS2QHEmrNPdMcyVjcYrkfjTKpRKfqIHtIM?=
 =?us-ascii?Q?bKZk/YXB/NTtqVCPJiyaYTELjkjne8Fn4rSDh3jhdipM7JrNStqMncAeieb9?=
 =?us-ascii?Q?lIEQe0XeWGYxgOn1S+EmNAxENfcu1LsXd7w7BkzCujfpsAjFNTPJEAgPeiM/?=
 =?us-ascii?Q?28OMU6ZQHhUA+eKUNDcMMO0keFvg4Q8/PzaJNOEf86vOpC7VY43X3v2oG7/p?=
 =?us-ascii?Q?sfvx1Zm0SVO7lSS2gd+NY+gP6IZWnblV6IoBFZCyS9l6n9cT6JgQh1ESTwpB?=
 =?us-ascii?Q?xlYhp1DulpSjn2hxKZWw+r/XnUOdCA7D2/eytH3ylGzYZ5bN03TF8gflBy2R?=
 =?us-ascii?Q?IHuWJeHvCs/u6iAazsplGo/8wdyZOxfa5gi3XJrXsFkzIOGr0IK+pZ6nnsff?=
 =?us-ascii?Q?YdBuS65EpGyQXuvfqnFfUk7rA9aOC578+Idn0qTUUSKreeHrt/y0hGfxTVKo?=
 =?us-ascii?Q?wuWPG1nd9t8qc0WuRVneveGXbAthcr7P47yNd7zcnIC4qyhaAndqzyORmELO?=
 =?us-ascii?Q?0tNVgHEDfddrpdXt1O5NRpqBBH3+FEsRlzK/E3u6w/A1GLoP5qb/4W3syv74?=
 =?us-ascii?Q?F9Upd5rEgAlo6w+bXvRz+sAV1rJNvrXj+WboWBj2iQuCBLv0nL8SRJCQN7P1?=
 =?us-ascii?Q?/PVk3xZ/6OCJHplO6Tx4aBXkpOvzOPZ3fd8idawGXDdcE4IXzNSO43w2HMra?=
 =?us-ascii?Q?ved1zeX3g04LryRWQLLhvalDX8aEOwrdNvriSvVVOQ+FbRHWTGWguno2XTxj?=
 =?us-ascii?Q?yajrYqyYordAaZ7MFhARLLEJmI5qA+R8wvhWtIZISB9zPTMJ/sZPdaWz+xcf?=
 =?us-ascii?Q?KnHJvuboxDYeDsTkWU0WRh+WHeNtedEUIQUdV8iys3KKklmlECt08DoMAvfe?=
 =?us-ascii?Q?Qzm8lbDtO8PZgRL6tzn8LBoX7FJ+AIP6UmbX7cqXhYrW0ukZ9lXQJsBk6vyg?=
 =?us-ascii?Q?Zt+sT4n/yUv92kksXop4WihA4yNa8a+Y3DVOBhViVsGPMUtoMJswkWTYWv1s?=
 =?us-ascii?Q?e7Bc+nEJhcL1gdQNofQePq6QDroKaRxs+b9opMwXp/DFqQSOrnUD3BCxpzIg?=
 =?us-ascii?Q?iOx4YyEwdgspaSErxcJPJZvh0lw6wZTOAX+Dfj7vgc+4EN5hcVEFDrCoLsFG?=
 =?us-ascii?Q?5J6xOs0=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 231179a8-840b-4d66-1b43-08deeeb1aeab
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 03:13:23.9824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9685

From: Dave Hansen <dave.hansen@intel.com> Sent: Thursday, July 30, 2026 3:4=
6 PM
>=20
> On 7/30/26 13:11, Michael Kelley wrote:
> > Linux code for running as a Hyper-V guest includes special cases for
> > running on Hyper-V in WS2012/2012R2 and Windows 8/8.1. These versions
> > were initially released 14 years ago, and official support ended in 202=
3
> > (unless a customer has contracted for extended security updates).
>=20
> If we had a time machine, it would be nice to go back to 2023, stick
> some warnings in about this, and see if anyone screams. Could we add
> some warnings the next time a Hyper-V host ends support, please?

Yes, that's a good idea. The next such milestone is Jan 12, 2027 when
Windows Server 2016 support ends. I'll see about getting such a
warning included in Linux 7.4 or 7.5.

>=20
> Also, what will an end user actually see if they boot a kernel with this
> series applied on one of those hypervisors? Will it just not boot? Will
> it run slowly?

The VM will fail to boot, with some error messages along the way.
See my response to Hamza Mahfooz. I'll update the VMBus error
message to be more explicit about an old version of Hyper-V as a
potential cause.

Michael

