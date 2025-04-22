Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5259230987;
	Tue, 22 Apr 2025 06:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745305051; cv=fail; b=WfrA1T7AKrqbzVciaMvjMnY7FSaQCDIl2RgSbMYoSb/4ERjCq7msfe6unfwq8HkcaNIlkM6UYR74WveM4aeCcTbIWaNVusy3aSF5EASFliMGqDUHXlmenlNZyb/wF/ZkV1SGu6G0wDr9G+u6pU3EJfV6QGyoVQqHICbO270A96o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745305051; c=relaxed/simple;
	bh=dAsVeDR3xVSenlHOH6fM/H/sw73PBxvcPcHPfF4NzM4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LY5nGF6gCitKyn54IWnQFqNpkvNqyyWPNm9LWKqawPQgCh8ELZno7dgNuTTe2cgHfp6BvmSYtaYg5sgvE9QKzPZN7xGo7culebXfwgOJ0gb/damuZn/6SqJRk2AYlxzcE0xdm4iAJVOeIfQpQ2WeEwqrt68kq8ClrKCC2gTrStM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=DP+bhCkm; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="DP+bhCkm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1745305049; x=1776841049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dAsVeDR3xVSenlHOH6fM/H/sw73PBxvcPcHPfF4NzM4=;
  b=DP+bhCkmLGSo0uQcpwUOEy+WRo8s3UGa2MiuKwVli3d3m/NTuJE6nlgo
   3w3QoWUqvJs3ZMcMtyoL4vSmz8534zHNdVYUTkCBqEOQOych2rKDXAy8G
   BA/g3E1x1ttYt1OLsgr0y03AfH7/GldqpTPu0ISxx7p7wEetVprWlVfUp
   LCTttBOKDnLKKsJfGvpuNveOaJA9XTn7auZLpbe5h6S0MO1s6c/5NJnx3
   /to6NddgFcsHlpyT0S+mARgO6rxCGVI7xVrs2XY63XT2VWyl7lX/omCA2
   s//SkQTKl2RuYLqfbS80uMoiX/5Vu5n4ZCtDZeG+VbTvDdX2yeaZLdEnm
   Q==;
X-CSE-ConnectionGUID: G838uAw5QOKS0wKMbMj52g==
X-CSE-MsgGUID: RHJ8/SKSQDa+A3v0kTxuew==
X-IronPort-AV: E=Sophos;i="6.15,230,1739808000"; 
   d="scan'208";a="76108989"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2025 14:57:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BJzGDTepDZQtaJoWBS9krHAgp0WMFxuaO3wsQpe9kstFUBykOnNVn713vhgoUUjWX4pb08aZ49cBhPRtEpJ7QRSV7DKeRMRrm71ZEZTVh2cTq2JrQp5GKUVJkpDPoZk7e4lUoTrnPsV0aI3+UoGvPvJxXGTAbZF/Gpfr77oyaPvaXLiDfL7bi5EDHWlgeF9mOhVo3y6fmHZkvtP47BSNwpCDLjcEG1/+cA+3M3ytCi/g3eQHvmnND+KUZLWNZArDUrdrELEJ7Pekwu3nwVyvVOczTgF5klTF/eOzqp/7c11jhiCw4W7eT3+eF1R6tTBS0+KIXT39ncM5GbDM9/3VGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAsVeDR3xVSenlHOH6fM/H/sw73PBxvcPcHPfF4NzM4=;
 b=uujo5k5t+a34rcKojHpPNJ5881ombgMQih/HMbC5eityFu7bUy/lI6XRcwEpN0HDUN1WrEmstaQgUzu5B8FqzpOOBv1TTiMkzHr8LyBdS5CMF6ParUo/3sWsd/PFJXT/Eh0QbIg+BtAN8N/gH7l6CtCKkBSaZJxINfNpxqV5GevbEo3dQIrgdSNEvxc4CiU2U2XtIqVEAbvE6xFJjxw3j75tiHOu4/40oBnJXHbIBoMTN5AT/LSxvR/3Y9A3Sk9WQZh1VIweb5TfHa62PNRF/hc0KDXJJFd1xdjKXquI5O+z+sc7ForRviVvg568yb0wRA+3HJ+uoxvZexjCtqtlEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by CH3PR16MB5316.namprd16.prod.outlook.com (2603:10b6:610:15e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.22; Tue, 22 Apr
 2025 06:57:25 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 06:57:25 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Huan Tang <tanghuan@vivo.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>
CC: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "ebiggers@google.com"
	<ebiggers@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "opensource.kernel@vivo.com"
	<opensource.kernel@vivo.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>
Subject: RE: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Thread-Topic: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Thread-Index: AQHbssSLc9WQg4rlL0i8HmFOHJYfrbOu/piAgAA6rICAAAe6UA==
Date: Tue, 22 Apr 2025 06:57:25 +0000
Message-ID:
 <PH7PR16MB619679B002E0AB4CD28CE93DE5BB2@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <7619479cd692a5ef8bf3bdb8424d173b774dc146.camel@mediatek.com>
 <20250422062555.694-1-tanghuan@vivo.com>
In-Reply-To: <20250422062555.694-1-tanghuan@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|CH3PR16MB5316:EE_
x-ms-office365-filtering-correlation-id: b785df7a-f94f-49c6-ae55-08dd816af04d
x-ms-exchange-atpmessageproperties: SA
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Z6q6KcprqR+BbFUOK2imCfbU2Ha+auKXsgtC+rF4MJwsDlWQnyGbLfcffD6+?=
 =?us-ascii?Q?RhACVJu4ZAEVAWPXeHXiLOikcOlDoIJyfxmp84/ecbAlh824XJw0ZhvmQ4/Z?=
 =?us-ascii?Q?SzU/4kDQg08PMpNb5NQZ/K8rL74i4EhPVKxq5pCwkIpMKoMQeHW/BiQozQor?=
 =?us-ascii?Q?2pnLyB9EQoD7iosy5aIZWya7thybFjso6ltKg0lE6IMeW5idTsGY7Ejua+Oe?=
 =?us-ascii?Q?rvX5yfxjZKQNKXmU7HqXcwdF1BQuK2O+xso2gb0vNud5xZWwrpOtqx5+LNxG?=
 =?us-ascii?Q?sm+qIaHwV371JQJpobGfgyo4gKF8w6F+t6tyuUPNXznebzuZLd9uevL/aRa5?=
 =?us-ascii?Q?TAMi3a/GcXuHpanhm3fnvJQMA6t0uXig7vpluGKO1J3EDVooPCoWNgZ8mXiA?=
 =?us-ascii?Q?WYWm6ph9tRhKNopTs0uQZSWTRtQYadBuCMDdublfbHpZLKC6jvOsKPNMg6qL?=
 =?us-ascii?Q?q7wdqq+pC96Gf/2PA2NCjWzHIW1EuzwiuQP5B4TL9BaohzUiV0PZOZ7nE7UA?=
 =?us-ascii?Q?mp+PWLv4UD16+RyB7PieBempNDAeD4N/bIOSedUmFo31+3n4EeRWzRtfsNr8?=
 =?us-ascii?Q?1NrIZoFBS2WSN1j9/ejR9W3B4Qj/XgVh2NvpHl/NsoHaSkiAMYzACU10Z22F?=
 =?us-ascii?Q?XfFpe5FMhrha8AJtu5PNEkImQVb8ce3gTyVeZMQVo2X3zf5fP8Vt4GIV8SAq?=
 =?us-ascii?Q?2E41B/pBd6LVAg2c4oFFKxA+cMWuGJimMuQtcaTf4aJw/Q0iGdQSQ4+mfoqq?=
 =?us-ascii?Q?/ALyQsC3YRRh+mehLUnpm4CdRYkqKEXNdW7y0pLiBbmjHjxTC7BKfJFCKO9l?=
 =?us-ascii?Q?NhELC7w+snEQ2I+jsnGKbIMLnCOvEJ5L5kCxjhKx5Gp1WWf1nSPZRx5BdI5y?=
 =?us-ascii?Q?CaGj/PlBmC6+1jbqYeiqIRmLale7Og6gYMWmwrDp9IzC1chUV+0tQNMtxsHG?=
 =?us-ascii?Q?BLTdYJ9h0px2GvHzavLxXj2O+DZjyRZzhs859KZOt6I9nY4Cru6EL6tm/Md+?=
 =?us-ascii?Q?jUnlBj1hWeBgVmEUD5Kad8yBMZq0VtTs8ub7LRt9nZMSetqdveBBoXq23RnI?=
 =?us-ascii?Q?hGN3UpiEBdKwPXCxl3dijAc5bxJFqkSJ4iNZD1PRg5cJ4iAFBGofiEhcLWyf?=
 =?us-ascii?Q?VORXPlqxkeHEUFmT/1Q5wCCeUr49lFJ9QIziIavxGVtmor2B3GUz2qYcgM/D?=
 =?us-ascii?Q?kSxQivyjCmBAj/s61hAKc3XCgmbkbKglQhdkO0dT7ydbEmJncM8bgdcieB63?=
 =?us-ascii?Q?vilEo0YqSzyMVrL75EDq7xBC5pQugm0/DNgVsIbKtzeeh2UW3xGpMO9g8uwl?=
 =?us-ascii?Q?7hrJXeZ6xxy0xIDvqHSAzDmgd3QVAI92UA2fZ1xAnIV/ipvjjB8WyMI/Iuod?=
 =?us-ascii?Q?VnyUf5oKGQqSxbZk2R3JDcb6hWK5R2WYMSCkf/agrbkm6ckvJBCXLVrnCSdb?=
 =?us-ascii?Q?Xn3sUFkxCQldo+8bAYg1VhcjKJhXBLDO+rjU2Nc19ynZuJfvmG8U5Q=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ami7i8Y2kjvZULnro+rPPpkcQApyrn0PsndmyjtfIoXfMxlCpI/dNOWBClfW?=
 =?us-ascii?Q?twmdtZ4E9j2EWup/1BOh5xicjNlisMa71DJtfb6xBfS8xuLOFRAPqKpVwRH5?=
 =?us-ascii?Q?VAhk5itvuPQ9/utCgtOrV1oB/4TEc9jAG24nJ7x4XuEdEHA+wWO+nwI3L55C?=
 =?us-ascii?Q?5PVNjEFkg/VmDQfv8ewiDZuby/Rol3SWa3fFeNiNZZQeBzuDLDBy8gx/OVx8?=
 =?us-ascii?Q?4bTQg7w6u08O8u4FXnc6QccZ2uVJ8AyQoa0SzgmK9UarCJ4laIwLJ1bfd+tn?=
 =?us-ascii?Q?J6bh1is7IJN5Js6w0hR0CPixV56R/Vnbww2r37qAtz161oG6ThXjYJyoj2aP?=
 =?us-ascii?Q?gjT7gyuEiiC+bd4QaZrqz7kAFYwcT99EhIl6CjU6nFQNlIiE2/dlgXhClaiu?=
 =?us-ascii?Q?+3YxxMrYYtKOHJN201FtVIn7peQeHDU18hHYQwpmdPWUxS9Vj2cqb3onp+Sf?=
 =?us-ascii?Q?r1DI2NT0Ihv5mT/Awvd5D6g6hwR4GM+rNWR0Up5vNABUNVZpnWjgQgG/+b6A?=
 =?us-ascii?Q?N+e4XjtrYwOWwq+XNb2U0/+1FcuxZvMH5kX7ODj7UcsNvzPDyNU/HSZtrHQj?=
 =?us-ascii?Q?yIcXAJ9GnGbT7yYl4AKoAOE5QtMGS7Cwg8D1DR3bNe46cmB7cBnRnnG7WfpU?=
 =?us-ascii?Q?tQqMZ1eeUCvS1VOdgROO7EPUQp2Tu9uWKD7nVzYzO6D5ktSd7FTBViZxntLl?=
 =?us-ascii?Q?OWH4m4haR8vYxe9PYkfh8Buj4SHCPhQGk5sT+jUiFKiUfqun6hs2GPUhOogn?=
 =?us-ascii?Q?zh0BKA8tOBTynSJhf2omP9RYHOmF+iJGPo/tPhJxdwwy3cOU0P8o1yhQuCsA?=
 =?us-ascii?Q?3Up4mY9LgmDjGMrgKfElWhovtF1UgICEHbr/znHQupEcB/VKXFe2FmtG4HPO?=
 =?us-ascii?Q?9hINKgb+KNwDu4PCuTybq5q0+9AKekRT9MXVakus2NnuyY1NXeSpHBsHX7o7?=
 =?us-ascii?Q?qNtaieYI1e/jD7LNN8bSsjY4ZPahNftwLcwDNe6f6bNuDhys4U3k94OfgE7H?=
 =?us-ascii?Q?UmddlgxsES9cl/DfahHhbNNw2EF+g51mW5IbgOMTL0NnM2Oolk+mu7WMtOt3?=
 =?us-ascii?Q?+nksW3Q8Swcf8bnhmK7GXDrOv5jUy8SvSp7zynBzl//MXxzR2Un3RmK3dbjb?=
 =?us-ascii?Q?0/Lxm2y7m69JeuI3//ypHRqKaO8SLEMDDRxX7mfcnhAF1zCRIbfyT9Ux4XAM?=
 =?us-ascii?Q?8jQHvhMB+t/avyf6wxTBkl/uHOG2SgXOMpC8AQbq3Y3RvGw4BKjprESJVGhS?=
 =?us-ascii?Q?8NP61nhKsADWUzpWAi+nMssx4QaLVR+iTC1PxO61ASryC5ekCiz83gGzsMTW?=
 =?us-ascii?Q?PmjfHHVRz5xBUTravEu8BwtQh2C2wKANZb+riEt7Yo2tjfE3Y/85zgnrKxcw?=
 =?us-ascii?Q?o0O+Rco2jTeW4Vy3KqqI3kNqaJjhXECeL0pXAz84o27i/grk2df0SIdUg2xb?=
 =?us-ascii?Q?iytcqvJBKnaShpc8nEYOpY6/bHN7os05q1a8NbTinTnx30DnlUT1s36jZ2YN?=
 =?us-ascii?Q?JDctsU4Dt9ebIw9FFI7+b+/EgueoQTVty7J4zd/hbKRbPy3phU1kLw8/iFP1?=
 =?us-ascii?Q?FTuhOHf16ldDRbUS6oK0uEjHLqJXgWBHc787f86e?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M0yov75eFG2fRXmWoRCqlcEuwqppeFhc9qSECjCQDnRyvIDFEzJKAmvngvw7vfXSnXtXwvz4Et8ot+EONY52xOQsR5ydYNV0qE/4rAqIfTj2mpqMEmu2PYNNShWuuNmgdLvL5N9r8ZdwYNvpogWxuJf/oXQipYMBNeUNLNQ/CVBzP1NLsSX78GnXcN1CEx3cxuZtObl7pD1OS/FTwyGD21v/qn3PMmBVy8OJaom5dVg6Km1G0F33r+701caoanJWXiyYtIoOcIkHxidhIrzKFS+leEjAZlILdxdnPvdAa9Nnrio9F7l83cA1RSUtlX56r1W6faXfHNXLldVcWAq9u3q9jJ/mn/QT/wrlz9HVIr23Rs6l1BIZJ4eO6KXlXosf14GzaHEDE0HR981U82hegEfo6NN7DNm0kxoIzOK+f5IdNzFdXN8IPVPIEdrpjxhS+Wy3jF+ON5RFmd2fq4cPyUDFrqA9t5oZPRPTP5hWx1voXKYzu629U7lVlwq050jFzmw2PivvLYLtmMblYHWkViUbVGBXa+kdARf0pwWMpA0f5o+3M6LmVvhzBCtuCT773pdVGVkbFSxTnfb5fjT/1Ppa5XZ2+5XccwidbTTpCDENELXscJufAMcq1bZXCqOb9zauE3WtLr35RowVWM+0ug==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b785df7a-f94f-49c6-ae55-08dd816af04d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 06:57:25.4229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KDcx+EEkVswfoDxZ5KFJ7PeI6meN32aVt9falioMh4V5Z4d8vBdwLOF+6+0U5bc1xHiP/dTGMVc8WpE5fH7nUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR16MB5316

>=20
> Thanks for you reply!
>=20
> I found that using low-end UFS in SoCs that support MCQ may cause
>=20
> device latency to reach extreme values.
Do you mean that the device reports wSpecVersion >=3D 400 but doesn't reall=
y work well with MCQ?

Thanks,
Avri

