Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793003376;
	b=3XY79N/MM8nDSigh27WySf26l6IsEQ1xyRQrdOSj8wK4qNHC+hAhT/ClIxi1E+mh3Bnp
	 /KIQvIjPBduaHZ7cG5u7pY+qeu6DDifzkK3AXBII1xETMywbJ4rSOkuQPrFZcJJAi+1K0
	 7rNNthGqzPmnKs5fR0/t1nUB368UKHxiXuC/SS+ohxJzwSAshjRNryYVBnyhAzKGO07pW
	 nmDMcnDv5DFmgi/GwnzxlbXOLIAvEcboa2uhXJkwkySO7L5h5mey26GAfHTIclCEmQHhJ
	 ZhJP9KEglCuFi/yI9E/KxSXzcWbbTYkOXLZywZRbSGrGWONj8OLHG1oAGxq/nQ/NZlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793003376;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
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
	bh=t1wtmQKjyuDnp8WkFtNlMavUix1jkkQ4AU29n+LI8KI=;
	b=OEg/xUMjQmCbkRsS8Yqb20U0XxujTQpngDosnTTuxGjslAKMBzC5SH4FX0yB5r6hkW+y
	 ltzuO8rpWjrSVjw3KeH+89lyQK+EL9wUjjwGSeadsDqUo26lkxiU2g8QRWIdqzFRz6a/t
	 bpO2HpB/uZ5R3V7BhSOSa/tlHMJg6Ya8WnHypvUQHsc8jDgury61EVAqaSxPfiJ0IOPng
	 aHBP2gNI6ZA01a6jdqdOjv3Uyjh5GjQkAhMoXOnRhsiOsm4N57GMC+kN80OPyxxqR0vfV
	 QCqCRX29XMDsVZKZdEwHBdYdIqms46/gY9tNI3XehU7vvq4BlQ5iLXp1ipBYSSTtJKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=DYOXiJme;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010017.outbound.protection.outlook.com [52.103.12.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EFE606A31D;
	Mon, 26 Oct 2026 08:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74EFE606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=DYOXiJme
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZyJvd61iQk3BgVc8INAd3wsF1ciTW71jUBQ/4MVEt4D4mOgwiw0hBFOyKrtp+mw6P5ym2cpKmM8O1iMZ9GNjARiMQhHPvQgtdIyoAkm2g1ve+3wbPoiNqwawwhl9Lt2SexNA6Ujp6aFqUnIw4KyZUMeDjZvfALoRXpcZCsi5yzeL2W0YtQ2fe1SNyZmvEunxybBlc9gvXJPVDhu5OOHBHWUIt6i0wqed86kquTfYgyT19SLatQXP8MgjUSqkz6aYwCfnWAi+UX+s4Q72dsITymHhUJ7LKRLkZQ/dmTxJ93puWxXZeY/WBn4/FKxjwFPef1rb9EoDuNBEvP+PPz9/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=t1wtmQKjyuDnp8WkFtNlMavUix1jkkQ4AU29n+LI8KI=;
 b=U3bBvkM5ligpQmdaoQvFQm4jPIXGdPl3aFp39YQrxpLn40T+1QY5uwaxVfUcELrgCT7CcAxEH40ZJu1n3XEzvR6N3zREyw/dZB7LUrDNj+MY6pSnXDk8v48Ep81YNG6p7qaV+X0iHbUXz2GGgQ7V2F4Gt0sRD6RNTmdsgWYD3TkM8JbIRw2kdgxypaYMhevzdQ0+Ttmpa0F2ETRfuTbzVmbBGh3gmcZtmaB1rDQp7BSA+UxLxG478XX/u0FwUwGSYpf6iHs6osdJqZxslKqIFW4NImDDaFWGlqEOiqL8H9L9/GXPCoTXIHXCY5YAzsY7TJImfISQlcJ+nW3VDDnDXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1wtmQKjyuDnp8WkFtNlMavUix1jkkQ4AU29n+LI8KI=;
 b=DYOXiJmeB2x248WxDIJoM6V6biossZpUzubl/jC+F6s28wQFVQciueSPdYgarLUbK9I7n4mQAOLaHi9XnhkkaQthosuuTXuQNVKPvzMwe8mV5/t+oOlNmHR0Th9FHUlnjnCYbx0HESao83SLxd8mtx2fokMGkUduG2M3Avjnp/TtMPLVdOLohaUpOty/BbTkJNV4VKrTcR5XIJkekAbAHzjvg7VYsYSm2RmiMu/FMjz1l2aaLu8lew6tdQcrSs6PAUttKNKgYXaPmcyEbM+klPhJ6Mfe2EUg4Hs+TlYl3S1EEnlvsNZqwEEMTEZUID9hM1sQyUcSskK14+7yv4BG6w==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DSWPR05MB998753.namprd05.prod.outlook.com
 (2603:10b6:8:354::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 08:29:33 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 08:29:33 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, Jens Axboe
	<axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/6] scsi: release completed passthrough requests before
 user copyback
Thread-Topic: [PATCH v2 0/6] scsi: release completed passthrough requests
 before user copyback
Thread-Index: AQHdZSQgvl6/Ea3SW0C4L7JKFZIPew==
Date: Mon, 26 Oct 2026 08:29:33 +0000
Message-ID: <cover.1793003363.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DSWPR05MB998753:EE_
x-ms-office365-filtering-correlation-id: 44675f21-fa68-4a27-14ab-08df333b432e
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|4140399003|24021099003|5062599005|39105399006|41001999006|22121099003|22091999003|24121999003|31061999003|38102599003|8062599012|19110799012|8060799015|25010399006|102099032|19061999003|440099028|3412199025|4302099013|1602099012|12091999003|26121999007|10035399007|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?1KWd+7FBh8XWEeuTUpTPhwfEKcF/xQLJbE4LCOXmQCWXhuwTk47+vf8Ay/?=
 =?iso-8859-1?Q?ctC1hSUXisRMi2KwtIwP6fYU9ESHc/M5gkio2+YxNToIJFuBgRsb9dCPKW?=
 =?iso-8859-1?Q?pN95qDEsVIyPFCT0OtedBugfgOyROdm/+8EHNwotaZ5AWeyDWXBCQed7HD?=
 =?iso-8859-1?Q?duVLbasBqA25WS8fBz9/GCX+bwjQEuFr+61Sbs4WqvdylMRRDkV5m3d6pI?=
 =?iso-8859-1?Q?m3tEDyDDXta0pgkh1gza9b9vbaDXlukxy7Rip+MOFvrdjX7wB9rdqy/fi/?=
 =?iso-8859-1?Q?QGTeM+irzUmcfL53JUWs0lUMNS8M4hpJ/3Mgm5KEu/evLHuymzcdPiO/Up?=
 =?iso-8859-1?Q?ufza9A1QcooFbM+Y2/2pNcgjHLGoZieuxKo6puc5Wwypnm50npv04d9Qwc?=
 =?iso-8859-1?Q?CgNzSYBgEOpOuv06Cub0lFH0cqE7+DzWda6BVuprejDuTPS08UUf8AcF59?=
 =?iso-8859-1?Q?8k//+oIkesJg5WL2gD+yGNTabysFwVjZUwTEuo5Pub15PnBEi+aZAxcPXx?=
 =?iso-8859-1?Q?uyYcUetwEKLfHE28r8o/qQE3q/SYjI0nzpXweneK7yaOgDbGqDWG7oZkAT?=
 =?iso-8859-1?Q?oxBknmZ/LkcR35rETMZ4ItPYwFatdcJISPNgkqdXYCuhs3Svwwyb6MNlLa?=
 =?iso-8859-1?Q?duZjPr2CqF56sBf4UmjfnL/Pn9VRtFIEWaqwZSLaaBYAw6kQU6KEmCUM2a?=
 =?iso-8859-1?Q?REtNI5ENi3VzCHlq4HVjUegJ2fPSlcSA8vANJAYoB4kG+I9kdG8w15lUou?=
 =?iso-8859-1?Q?Tymfz7IlFVQ6e+kEVhiWXhPiuYq0ExogU/GJ2u1K/OWJab36ytlpFYwy+u?=
 =?iso-8859-1?Q?q8RKSusrn+/wUDOpyEh5OSdwqLxxMcq1YvzbtkSvamXixB4NNxghHdxKKM?=
 =?iso-8859-1?Q?BEQlPmBlVzMWJ+SUqpjQNMFoGGp4b2O88HRNbsmdJHtejtANwDLRV5Stf5?=
 =?iso-8859-1?Q?cvw6rcFdxVmbzsQNZGcBqBtREupYWfVkchvDZ8L0CUeFreIUm3ujFHdu2v?=
 =?iso-8859-1?Q?MSp3Kz9dhsTLdfVO/7KoXyPIyXIjy3Wvb5qIB+A/3xWnpxBMvC9hO4iiJ+?=
 =?iso-8859-1?Q?1PqdzzFddNUmMpU/kxmI6jBhJ1zhVpDTPjXh+Sj8h1qmDR4+w0qZS8Becn?=
 =?iso-8859-1?Q?+SwRPKX2mKH6XHFvB/F4mtPLEJyhkXFx31JEFCk8f+XbX0kMMQNwBIFDor?=
 =?iso-8859-1?Q?6fcqWduNp/BYqxoDUvdoP03zNF1nXVs5xncNAJzXO84xTVEgDtv5IbgiB2?=
 =?iso-8859-1?Q?CHg9vR+lPz437UdpHBOSm8L0Oag4zm0lV1Pka/vroDn3oF4Gr7s/OUG9yB?=
 =?iso-8859-1?Q?CElC?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ttRsz3Mzuj+C7QC8XsFAIid09x8vo3Yl9lhONA07XMeYohz7MeclN6+yrv?=
 =?iso-8859-1?Q?f2VwbUCxHhAeUj49giRGaIPFxxI5UAGEu29p4RcIV0ugTMly2ZN07XNYNq?=
 =?iso-8859-1?Q?x+4QlicIuhcDVw58OMxXcniVCGJqIivqnpLCkXI/bJvlGsAteE8Q3/ynXC?=
 =?iso-8859-1?Q?T+ZFXO7sdril2jwMCQdzqMbgnsMfB7/Ma9loQt/+ux2BwZ4J6V/f0knK2K?=
 =?iso-8859-1?Q?BzZuWiLdokGIXQG/IFYme54537YmMKF/PMEb2/Ge/5I7TE5vSxrI/g4Y6k?=
 =?iso-8859-1?Q?T96UAgVvmcRG755vUhYAKbRQ7BWvI5Xq91BIvn/0TU7kZY1RDbSxv2yQH8?=
 =?iso-8859-1?Q?b8bpNM23hLdyLtOF8KgPOu5B6A6szi+AecTN+mAuQN6ym72ockczY9nYUP?=
 =?iso-8859-1?Q?4Z+RqX4kTJK8x5MIIT7gxXxaShhubaH9KHStu9Io0Nq7QPuYt7cxCfa8Z2?=
 =?iso-8859-1?Q?Yt0p3xEafp8jIomTBN35F4u8ViReEuht3MCDPdbYpfwo5ITdSd/cHjcZoz?=
 =?iso-8859-1?Q?rJuaM6RcDN+ugp7txt7VFGt2QJ4m2uvKJEpjtA81/jNQhWNcEPthIBYs1I?=
 =?iso-8859-1?Q?rpONvUCKMwy8SyPvj7226i0NL8plvjYQqotaY6QcXAbd0Wm+g8tnHguCkO?=
 =?iso-8859-1?Q?UVWURbFZPbpyZeZhKpPthLSzlIbcc7yZDrilVc0eUCvdeSkVYNTNwtFY7x?=
 =?iso-8859-1?Q?jfRiOGia70MX0cO3TzJS1ltZ/mLXQKfOGqjUON6hL+R2tTazUECo79OyDQ?=
 =?iso-8859-1?Q?pz+eMNhIRwSewYGPDw/mqYqzHgoKWaV2I1FKsEK50Jb/RfYVK/yamh21vv?=
 =?iso-8859-1?Q?ZyuHsGqtCFOwkI5sLfO8aQtL2wLvOKbEo6MzGuaQQzUCzOp9Iuoa8WzxUL?=
 =?iso-8859-1?Q?SnzafHJMnn8JCw26Gw7umfPRLT5totolW1t7u+glRnBKiZP9hP89CEBxsZ?=
 =?iso-8859-1?Q?QYzatB1IKSw35WINDpJ2TOyJFZzqutKx7g6ARYt9hRcvPo1jgqSMicbx8D?=
 =?iso-8859-1?Q?1azoG5y/xv7GBYF2j94HyKOVDPlrL+6lhm6ZYzK8f3aw8wAG4ahUuhDlfa?=
 =?iso-8859-1?Q?Cvq833SPDFI+Fw5RqfP8xbsc0bhe0lC9nClCBek3sGA+n7lR9sZusYJ2uv?=
 =?iso-8859-1?Q?adPkvyulH2uE1OnnB/sXnl97A6vdM/tGU+4aZH1cP55IoTQSKWOUh20u/c?=
 =?iso-8859-1?Q?yNdhSf51CBd/6eDrits4FSVN9/PvZ+8Gnhb+pylLvNL4YOYZ1uIG9DeG1N?=
 =?iso-8859-1?Q?Ul3/fVr3wcxHQsus86Tj298RSp1r9GTpQhUxaxuFDOtOPjUJIlBHZcHGDA?=
 =?iso-8859-1?Q?c9X5zrjFkPzVom8SuT+jw5EReF0IA0FCbdpeCxBwUEBDhJ5Mq7uIh3noBf?=
 =?iso-8859-1?Q?TEMrjotj2Zn3955ctBIMAMYIpqd3VAedST1tE8MGiUPIz4h35WKgvZJ4wE?=
 =?iso-8859-1?Q?WJ882ZaJJnfrBmfP?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 44675f21-fa68-4a27-14ab-08df333b432e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 08:29:33.1947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR05MB998753

This rerolls the request-lifetime changes from the original six-patch=0A=
series. The independent data-copyback error fixes have already been=0A=
posted separately and received Yang Xiuwei's Reviewed-by for the series:=0A=
=0A=
  https://lore.kernel.org/r/cover.1792772194.git.x-professor@outlook.com=0A=
=0A=
This series is based on those two patches applied to mainline=0A=
390febb5805d ("Merge tag 'for-7.4-part2-tag' of git://git.kernel.org/pub/sc=
m/linux/kernel/git/kdave/linux").=0A=
The base and prerequisite patch IDs are recorded below.=0A=
=0A=
Changes since the original series:=0A=
=0A=
- Release completed synchronous requests before sense/data copyback,=0A=
  with the request-backed output fields saved first. The original BIO=0A=
  chain remains owned by the user mapping until it is unmapped.=0A=
- Include SCSI_IOCTL_SEND_COMMAND as a separate fix for the legacy=0A=
  sibling identified during review.=0A=
- Rework BSG io_uring so end-I/O saves completion state and returns=0A=
  RQ_END_IO_FREE. Task work does not use rq or scmd. Optional sense=0A=
  storage is allocated and charged to memcg before acquiring the request;=
=0A=
  nonblocking allocation failure returns -EAGAIN for retry.=0A=
- Keep the pre-existing sense-length reporting error in a separate=0A=
  patch, and bound the new snapshot by its allocated capacity.=0A=
- Trace the synchronous lifetime dependency back through the file=0A=
  moves to the scsi-mq request pool, rather than a 2005 merge commit.=0A=
=0A=
The old 1/6, 2/6, 3/6 and 5/6 correspond to the new 1/6, 3/6, 4/6 and=0A=
6/6. The new 2/6 and 5/6 address the legacy ioctl and sense-length=0A=
reporting respectively. Transport BSG remains outside this series: its=0A=
separate queue needs its own resource-dependency analysis.=0A=
=0A=
Validation used matching x86-64 KASAN/lockdep configurations with QEMU=0A=
and virtual SCSI disk/CD-ROM devices. Before this series, 20/20 traced=0A=
DEFER_TASKRUN completions retained their request before task work ran;=0A=
afterward, the request was released in that window. The tests also=0A=
cover synchronous ioctls, sense/data copy errors, fixed buffers, io-wq,=0A=
pending-ring close, and fault-injected allocation failures. CDDA testing=0A=
exercised the virtual device's error path, not successful audio extraction=
=0A=
from real media. Each intermediate commit was built independently; i386=0A=
and modular SCSI with IO_URING disabled were also object-built.=0A=
=0A=
The earlier one-tag fault results are historical evidence, not newly=0A=
rerun deadlock tests of this revision. The dependency when completed=0A=
requests retain all tags available to nested I/O is a source-level=0A=
argument; it is not a claim of a new multi-tag exhaustion experiment.=0A=
=0A=
=0A=
v1: https://lore.kernel.org/r/cover.1792237341.git.x-professor@outlook.com=
=0A=
Review follow-up: https://lore.kernel.org/r/20261022.scsi-copyback-review.3=
1b8d6a70f4c@outlook.com=0A=
CDDA reply: https://lore.kernel.org/r/20261022.scsi-cdda-lifetime.8f31a2c97=
b42@outlook.com=0A=
=0A=
Yingjie Wang (6):=0A=
  scsi: core: release SG_IO request before user copyback=0A=
  scsi: core: release legacy ioctl request before user copyback=0A=
  scsi: sr: release CDDA request before user copyback=0A=
  scsi: bsg: release synchronous request before user copyback=0A=
  scsi: bsg: clear io_uring sense length on copy failure=0A=
  scsi: bsg: release io_uring requests in end-I/O=0A=
=0A=
 drivers/scsi/scsi_bsg.c   | 102 ++++++++++++++++++++++++--------------=0A=
 drivers/scsi/scsi_ioctl.c |  34 +++++++++----=0A=
 drivers/scsi/sr.c         |   3 ++=0A=
 3 files changed, 92 insertions(+), 47 deletions(-)=0A=
=0A=
=0A=
base-commit: 390febb5805d3bb830402679f277f1d5f309e6bc=0A=
prerequisite-patch-id: 8dbaa81edcd4c0acbe43169d7d1c7012f6bec995=0A=
prerequisite-patch-id: 321b182025cad20ba75cc00122e50daba8d1a52f=0A=
-- =0A=
2.43.0=0A=
=0A=
