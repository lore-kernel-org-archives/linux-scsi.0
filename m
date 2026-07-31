Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazolkn19010016.outbound.protection.outlook.com [52.103.7.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6A033F594;
	Fri, 31 Jul 2026 03:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.7.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785467556; cv=fail; b=ePgd6LhEIWVSjkZuh1u8+dqO7DDyGlkl4H2qZEt6Zxl5AsRYSsFBHkUCofdYe23AY+lyPRxq6AcVolWlzT+7YsRkKk2blBrMtb2RCD4Gxk2qd4X9zScxrNjgzXT33Is67Nxnhh3PWrTg2/bSArksO38Usht8s8HylM/FLP/sP68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785467556; c=relaxed/simple;
	bh=FnhjfAYxRE/5ced0xScqo1oLkpa+zvlktg7gmlQBVyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E7EHxclSFcUc/vKPfoNh2X7d72bp2jVa5fgJCHrxlNsoqgRCv4MvImcTHuobuamVRjJf8AkEKsDtjuks6WZl+ndnpy4k1QBujofy7Z/hpX4LJ1cNhZLOvBjNWC5zzIW/84QMVy5XbecB09my5A7fK1jiLtaxWnm0Z/xRynQzKGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=YCTDhqt0; arc=fail smtp.client-ip=52.103.7.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="YCTDhqt0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G8L/afOw4GlJjMWZWHYGhzevJi5xMUwsyt8vkztpPwn8FynxHLQUl1rQjy5NLrdrH7qXIxPahcTY88qAAyIw/ay5En6Zm8RK27s8/eqJ1AZVxSCfHNBsrWpI6KyNLGXRWLvqZR5bm27heLkIhZSv2zFA47ysAhp1mkhHCXTEZJa9YVTMgmorwxwoeKabKu8jHlkcll2QPrnVKTh3XNt5NZrWhGP3G8IouE/G+0L9abW4clgQKr8fSCHuswe3uAlthxzL2xgvPyEPUy8CtipexOSX5w/jJNcxkn8Ee5guyXgS3Fo+gKNN6MIr9VFlKYbPsCqCLdnJsyVmMB9miozg6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9VfwbVgbuZMHbShpQNB67mchKQpLlrAOVg5xNBtQX4=;
 b=eFTix7bXkUmiiL6Ip0/85w0hD0FPQMNZ1VttmsjlliddybB5LLW5Pl8spIrs2/bWgUN2LZ9NU5NVQIWSk2YypDy4EfUrSUkb8m2NuSsIh/uaWZR+tgRp7Bdp0ANoZdJ7yIv9NNPZbIoSv/F3JvjtK34AfHe0jsWJ+QKybnnPN9r7AvlGSQktZeFaqIhZkBbBqU3oQz1Arn5S8ese6EOps8lrAY4pAtMCivi2ZkYJXfOH5LkJ30DT3+d1pFamySKgf9b6Ix1TXsaGU+tVc2ykLKJO2QoBbEUSl6pElDiyHEPzyZ6o4zvado6dV6+VQ5SMYYwiyU7iDRsl+ahJ6WmqGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9VfwbVgbuZMHbShpQNB67mchKQpLlrAOVg5xNBtQX4=;
 b=YCTDhqt0Jnhr4+5mX7zAN3oABaO0oSKusHJaIbG2+FekYLDmWP7pNvAmzOxqdK1HnzZ9iCrCHJ/3W2ov8WJ1prse3LrAWSw4yCRqEykKeqZuR45WLYgc7M1wFO1f+bcQJCU4ZJUth5ASDv+xT+sO05b/INDpp4pF0l17tcdPENc6JogXn+8oddh7/f/CAfqq+Vt9qotbK1mKXMUnGCoP9Fpbz/ANRlvgcth3p+DlvB5aBBVYvKYBShZ6KxE71LyH0Pfuc5feFBNEiMOuEVHkTg3PDWA99ogZmyQswgaV0GPsFieRO9X4qFi0rZDacMZ53574bwm9boOq9EAo9enyXA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CYYPR02MB9685.namprd02.prod.outlook.com (2603:10b6:930:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 03:12:32 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%3]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 03:12:32 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, Michael Kelley
	<mhklinux@outlook.com>
CC: "kys@microsoft.com" <kys@microsoft.com>, "haiyangz@microsoft.com"
	<haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"decui@microsoft.com" <decui@microsoft.com>, "longli@microsoft.com"
	<longli@microsoft.com>, "tglx@kernel.org" <tglx@kernel.org>,
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
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "sgarzare@redhat.com" <sgarzare@redhat.com>,
	"horms@kernel.org" <horms@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>
Subject: RE: [RESEND PATCH 0/6] Remove support for Windows Server 2012/2012R2
 & Win8/Win8.1 versions of Hyper-V
Thread-Topic: [RESEND PATCH 0/6] Remove support for Windows Server 2012/2012R2
 & Win8/Win8.1 versions of Hyper-V
Thread-Index: AQHykTBh5c+ZTCJ8JdYW7ttKg4YPnLZbwfmAgABQfiA=
Date: Fri, 31 Jul 2026 03:12:31 +0000
Message-ID:
 <SN6PR02MB4157F550021CBCBCD8C9BEBAD4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
 <amvPGQcEqgzWe+yn@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To:
 <amvPGQcEqgzWe+yn@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CYYPR02MB9685:EE_
x-ms-office365-filtering-correlation-id: aa4bb39c-e0ef-4871-3582-08deeeb18fab
x-microsoft-antispam:
 BCL:0;ARA:14566002|51005399006|31061999003|13091999003|8060799015|19110799012|8062599012|37011999003|16051099003|24021099003|55001999006|15080799012|25010399006|40105399003|2607281247196008|102099032|3412199025|440099028|1710799026;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?hsnz/hw+JhcVIoLujhK/MmOYdeALh3whcK5hVjhhv4rS7iBt8sc2EEC9DN11?=
 =?us-ascii?Q?3ipPTzaz9jsCou6HT4GPcPu0UPtCiNSHkeH2oAble45D4/daSFHfat6ztout?=
 =?us-ascii?Q?GR2BzaviX1d8/dGDxJzj+dU84eEhplN4UOJqGuJ8Z169CS05Zk4+bSs06yh6?=
 =?us-ascii?Q?lDZCsQEREqe1lf3y00eIe7OeLgbPIjR4xtK2ydez+EMzjOMnLKctVgI+O9zF?=
 =?us-ascii?Q?HLEdvHShLeJ26TF5oWo9qri3q+sxH1WmFOo1sDydOhTADk14CCMgw/LKbypG?=
 =?us-ascii?Q?5b0tllrKjrb7FkbphBgNdummWoDQbNFWk+ubVqCZvVZbncOSfG+1HJzDc2MR?=
 =?us-ascii?Q?LQ2P/IdTZ7sPmkB+hnXGOdh94kLwuUabTTkpNSmTG67STChjTinSEE9WnpDe?=
 =?us-ascii?Q?iZNS2ZYxdpemEkvylMrzGI/FqFxZGHU0Ur8f/GpNj0rtX87X4KTyODgrFVNc?=
 =?us-ascii?Q?IyUNerGk3KPG7oGEa2d5SahOzZM6lqD19WH5KXkcCdwMEW5q872KTYnP8bPz?=
 =?us-ascii?Q?xdWZCuCs0n6apI5D0sBnlyY6UlmV1NksPN9NjzMYFcPiuTl4Dp9tMU/dW4qT?=
 =?us-ascii?Q?mF/58N6/9kjkZUDFdpy6fJdlPa3Vric4a0Ampjkyqmg2BQFFBiDMOnx/nx1N?=
 =?us-ascii?Q?jclkSn6KCLhEfHWKJSif42FALLQClv45Jfolpu1E9AOd8HfXIFDKgRjsXQeT?=
 =?us-ascii?Q?qOdNtQN3u5CwWYtIOI/TlKk7AJyEZlnBa+UXFb2d0cyfgnB6ziO84SuhUeZH?=
 =?us-ascii?Q?3SFcHUTnnsdq74PMWU98e6C0HfyqPBJ8FYJOS/JjeQ+Z/8TpciGPHrrX5Hdb?=
 =?us-ascii?Q?OUgRCVozC1maqBF8UspYcByV58tWwXcxl+IQYZYL8y3KEMs/y2CRrULGcHSW?=
 =?us-ascii?Q?OroKbu7duMlMpMqqBgNJ3a7wFcsMA1d5RjjcXgVqykC5yVvrKSgsGevbDZx2?=
 =?us-ascii?Q?M8bGG1P5FaAZ5x0WIN8T7tNRCIBbl53P+LJldXt2EaVLAgH371UoBdanD4w0?=
 =?us-ascii?Q?GQkGwomV1diWjxhB20mhxTlWo4YK65l00BVF/nqGE13Q+w4nf/UPmXAgvBb8?=
 =?us-ascii?Q?uxzjxQ+7rimPHiScl8MWH7iOUZgYGA=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qudyftHzDCwN37FmCNkGF8RnEgc7ogp7P7bC7oe5e6Tr5i5VCezc3aB0jt5f?=
 =?us-ascii?Q?rUcWiEl/GEzX15Jodc0ud9aBtjHe1vYXXksabTVF7srIvKrCe0JAW/ajSI5p?=
 =?us-ascii?Q?84+WsjuWPSnFXIeUXq/rEc8qCYtjkyxsJFzj4eb+ggRkV4F7hp9WwBpqDrzn?=
 =?us-ascii?Q?WjyTwzJT94lB2IyC7bqBnn3LD+mk0Knq3f+B2+vSad/hMUapmJ/Gf3dsbLLI?=
 =?us-ascii?Q?UfWQ03r9vYMhrqMJ79ayEsGOjvmMidUgPYNHkup/OpkFpU8XEjblWfcIR/Ng?=
 =?us-ascii?Q?duVIyKl4x9XDATbHLoiQ94VcsWsWqPCdW7DXyumvCEpmlMDVyyR3OU1oAirm?=
 =?us-ascii?Q?houXRSZUsHHvR4eFijfOOqyQ9Ol/yDwaW0b3h8kwB/x0YX5Ta4lfFEKpBowi?=
 =?us-ascii?Q?s/7SYrFfur0CnwRjdI+lBXfhSThaMyeZS+RS/xl/iQnxErs5C3ACJDilVPZw?=
 =?us-ascii?Q?wcnPph9NBb58EICjbYwj/uaaYrOUEexxJ2QlXSUV40dVvbHqfGckQFbF5HPc?=
 =?us-ascii?Q?kl3TaLsW0kJQIZLaXHpTwzhZKZAq9+vgV8F1hZhCqtbfd9GNG2Ow2N8sXBoE?=
 =?us-ascii?Q?8+z3zJ57nJHCZQFM+xBgPmuNVJojcaZwvXIUQm7gf8KnntGD0i9RcnrXD5dB?=
 =?us-ascii?Q?yj4DouVDMUzv3bGww913oT+3rw/CaiT/+V2nD+2ernTnSBZPPs3jMz/9INHF?=
 =?us-ascii?Q?2wJJIRH0A7tnglhoKBTxzOU/OZeG21aOmwlP6t+w+OcRmRLgm7EUzKmFjwu5?=
 =?us-ascii?Q?e3LGsO/qxCWoFTYgMZroqRJfqFtqj+0BIo/3dlWIx26lcXzTIurh+yfBQooa?=
 =?us-ascii?Q?M/rF4WckG+I5mfM6iCqJ0yscqf1K9WeH63n5rsd7X/+sEhH1XGv2dUeW+Tz2?=
 =?us-ascii?Q?5qmNV9nEsvF894AS5PjIDGSonfJ1IqVtYNJXFyExWCnQsX+GHDPNtNODT7Bp?=
 =?us-ascii?Q?0jfZEb9YSG8K6r4+0Wl42Qk10ExLj6pmOJS/YVVq36elG3kq8OmjhoyVLyEg?=
 =?us-ascii?Q?uUHuJkSFAFCk0DHgehP00Y1LFcddCP2RMl6dVxX0ZmxczE/3nBsU2mZ9n/yc?=
 =?us-ascii?Q?o7ED5TIKwxJdTRFyptCGKQQ5JJwNOUrbLCXEhZUEmbQZ7y+zouzoVAQPIInn?=
 =?us-ascii?Q?njDXB+Ax8CZnza3gGwkAv84adztN/0p5mrFDBSjcJpCygzlxbMfJ3ZsgiAeF?=
 =?us-ascii?Q?1HquZzF2hTvYQUs/AGgdAX9ItU8itFSXIgmV84YF8LqPlDT0Fehd22NhVhhz?=
 =?us-ascii?Q?yPyRfyFC9xA0wRVBcE8GFrOPidkexW9356uNHyG1cxnZBNqqiNBWtLIagKUE?=
 =?us-ascii?Q?MTc9WOUAKs+iBdHTjWPn7c+6Thdk0oDPIF+MeuBqL72HiqjN5iruH7unCzL5?=
 =?us-ascii?Q?qsb7Rkw=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4bb39c-e0ef-4871-3582-08deeeb18fab
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 03:12:32.0003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9685

From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> Sent: Thursday, July=
 30, 2026 3:24 PM
>=20
> On Thu, Jul 30, 2026 at 01:11:17PM -0700, Michael Kelley wrote:
> > Linux code for running as a Hyper-V guest includes special cases for
> > running on Hyper-V in WS2012/2012R2 and Windows 8/8.1. These versions
> > were initially released 14 years ago, and official support ended in 202=
3
> > (unless a customer has contracted for extended security updates). Given
> > the release of subsequent versions with improved functionality, there's
> > no need to continue to support the latest Linux kernels on these versio=
ns
> > of Hyper-V. If someone is running Linux on one of these older Hyper-V
> > versions and doesn't want to upgrade, they can continue to do so as
> > presumably they don't want upgrade the Linux version either.
> >
> > Simplify Linux code by removing special cases for running on these
> > old versions of Hyper-V. This includes removing the negotiation of the
> > VMBus protocol versions for WS2012/Win8, and the special case code base=
d
> > on those VMBus protocol versions. Changes are in the core VMBus code an=
d
> > several drivers for synthetic VMBus devices.
> >
> > Some VMBus drivers have device-specific protocols with the Hyper-V host=
.
> > Further simplify the code by removing the use of protocol versions that
> > are specific to WS2012/Win8 and earlier.
> >
> > Finally, the WS2012/Win8 versions of Hyper-V were the last to use
> > messages to deliver synthetic timer interrupts. Starting in WS2016/Win1=
0,
> > stimer interrupts are delivered to their own assigned interrupt vector
> > (called "Direct Mode"). So remove the code for handling timer interrupt=
s
> > delivered as messages. This removal has a broader benefit in removing
> > a key blocker to disentangling VMBus code (which handles the messages)
> > and stimer code, as they should be independent of each other. The
> > final disentangling will come as a follow-on patch set.
> >
> > Testing:
> > * VM on local Hyper-V on up-to-date Windows 11
> > * Added temp debug code to suppress Direct Mode enumeration. Fallback
> >   to LAPIC timer worked as expected (x86/x64 only)
> > * Azure VM DC16eds v6: TDX CoCo VM with HvLite paravisor
> > * Azure VM DC16ads v6: SEV-SNP VM with an older paravisor
> > * Azure VM D16alds_v7: normal AMD x86 VM with HvLite paravisor
> > * Azure VM D16plds v6: normal ARM64 VM with MSFT Cobalt processor
> > * Not tested running in VTL2
> >
> > There's no specific urgency to removing the special case code for
> > WS2012/Win8, so if the broader Linux kernel community surfaces
> > a reason why this clean-up should not be done now, we can wait.
> > But I think we want to eventually stop carrying around this extra
> > baggage, and based on discussions with the Hyper-V team within
> > Microsoft, we're past the point that it has any value.
>=20
> I do feel that this is a nice cleanup overall, however do we really want
> things to break silently if someone does attempt running the latest
> kernel on older hosts? or do we want to include (at the very least) a
> warning message that indicates that things might be broken (and or
> that we don't make any guarantees of future support)?

If one tried to boot a Linux guest with these patches on Hyper-V
from WS2012/2012R2 or Win8/8.1, at least two error messages
would occur during boot and Linux will fail to boot. First, the stimers
would fail to initialize because of lacking Direct Mode, but Linux
would continue to boot using the LAPIC timer. Second,
VMBus would fail to initialize because of not being able to
negotiate the protocol version, and that would prevent the VM
from booting at all. It would be reasonable to enhance the VMBus
protocol negotiation failure message to indicate that a likely cause
is due to running on an old version of Hyper-V that Linux guests
no longer support. I'll do that in the next version. I'm not sure
what to say about "no guarantees of future support" -- that
seems like a given.

Michael
