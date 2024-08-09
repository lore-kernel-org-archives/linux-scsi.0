Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2126.outbound.protection.outlook.com [40.107.93.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AC0381AD;
	Fri,  9 Aug 2024 19:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232455; cv=fail; b=Uf75oYHFB3VQACIfyFdIJnpIDNiyhG/dUH5eGrutyDRzMInzzEw9tGGdtcJVJsTCNN6zZVJbFtsQgpOAChayXaqFmjguLrwErZ9xzLMxoPPt+dTTDwOv/g2p3ytaFLFkp+IqfXgE15wtxkH/eV0TgP1J3JskmulfLXfwF/W12qs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232455; c=relaxed/simple;
	bh=THfTm9FqohNsZJcKKU0rWo+h1CoH04KpVxBMbNrc29A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GfDLouRiiVQnksSArwcTBszrqx6/Q5P9clavGNmlpZEXYzdCxPDTM/dp5ofXuM3GC89QZKehSAaNOU9W7PL0GT1naIHwAkAWvY0FeeaYWDWfrkSZBdhqLI3511SDwTWEmBMCr5TXhlAKXbPn6cc2lGiW0QuRNseMKTUGj35b7c4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=perforce.com; spf=pass smtp.mailfrom=perforce.com; dkim=pass (2048-bit key) header.d=perforce.com header.i=@perforce.com header.b=p9qjwiCK; arc=fail smtp.client-ip=40.107.93.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=perforce.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perforce.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=perforce.com header.i=@perforce.com header.b="p9qjwiCK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFlhGHpFm+qddUe84Ekucjpkfno7Poexahzly6J4brUR8K2qyZUVdVq0K1pl92lOIvXYKYBQh0w+Lg2S+VMWrNxfdIvA3yjN+aMFYPqw3JCmSbPPqrnr8ltr0cki16Rwu6grp4CGttRVZGQOjHfCuYZWijHBvfVfaT3vLeuWSI8LgXMvdW5OJ2292kTYRaUvRpK2RH5dNdhaLSXUU7jpV0rNkabT9FnoZTQPBf56igWTcSQWgl79fKLJ2fEbtGMoKgdRORt+F7kU20TDp10gwvwTT/IaSGy6HqK4lXOgkIQJHh1X8AOfAdYJOxzemOXhsINC/qHQiIhmXe9ovFFlJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THfTm9FqohNsZJcKKU0rWo+h1CoH04KpVxBMbNrc29A=;
 b=L9RQMXSlU0dQbI858jBN7W6/c3aCYCVqYEwrG6s1mdjMTz8S7GmRMa26Q4Msa+Nj5P6mnrCdnlUmnUntXXW2jR7Sd8P0k5bXE+FG/+72pBD6DtkUUi1crMDqFuCJo85tkM66YgrEKwVFYg4eeD00es7ld39yrc3/gk3kP0fwFiPwC6K35BKcglfUE61Hj+y1oFRkS1U0ySz7kEdew0BLAiQKPXsYt8YLDzJYCotb9Z98brUaiSFFpNNQ7/DemGza1xgkOAlbP9K0zBXQAgvbXXIcfpmM9EFkj4/e6Ok1WNx2CtyfhALjTytubl++GZ7ik5MqPsUISQOeLMulAY8bvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=perforce.com; dmarc=pass action=none header.from=perforce.com;
 dkim=pass header.d=perforce.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perforce.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THfTm9FqohNsZJcKKU0rWo+h1CoH04KpVxBMbNrc29A=;
 b=p9qjwiCKuulP36kyfNTBtbRCiocfmTf1i7jWrjzTDS8MJ5vhznQFpid05dkiluztItAWRk0wWI2RNt3einDAnyaYH79CIpeIqaYpK+5NiKU5syygGmrdago4rEy6N3feu0TvWiZGYUBpGtU9WE2GvLMb+aWmdKyoOKrGmpzjo/4DBAz6VmPeQ9q300DcQKKmH7YyFfXx53a83UjB1M7pJf17uHz2I7Wc4VZgmwvTTp+/YNOQ//fcYqKNaEE+HKizoLFi17WeePVkUeZk7QoWgV+n0HifGefj2YylDGA74R4m1NgLjHSbFbMDJoA1HPOBrwxMVeImlEpeb1H88sFAVA==
Received: from SJ0PR20MB5136.namprd20.prod.outlook.com (2603:10b6:a03:44f::11)
 by SJ2PR20MB5777.namprd20.prod.outlook.com (2603:10b6:a03:4c5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Fri, 9 Aug
 2024 19:40:45 +0000
Received: from SJ0PR20MB5136.namprd20.prod.outlook.com
 ([fe80::f788:9323:b138:c410]) by SJ0PR20MB5136.namprd20.prod.outlook.com
 ([fe80::f788:9323:b138:c410%4]) with mapi id 15.20.7828.023; Fri, 9 Aug 2024
 19:40:42 +0000
From: Paul Dagnelie <paul.dagnelie@perforce.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
CC: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, David Mendez
	<david.mendez@perforce.com>
Subject: Re: Leak of tpg->np_login_sem, possibly due to connection
 interruptions
Thread-Topic: Leak of tpg->np_login_sem, possibly due to connection
 interruptions
Thread-Index: AQHa6KRbbFI4qD4X8EGlMr55N6qqtbIcZtmQgAGnnDKAAH7tAIAAyIDV
Date: Fri, 9 Aug 2024 19:40:42 +0000
Message-ID:
 <SJ0PR20MB51360986B3A965C61BA164CD80BA2@SJ0PR20MB5136.namprd20.prod.outlook.com>
References:
 <SJ0PR20MB5136CD6B38D86FD141070F7E80B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
 <SJ0PR20MB5136C6C85B1B82FF78ADECE680B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
 <SJ0PR20MB5136A763BB1792A1FDECABD780BA2@SJ0PR20MB5136.namprd20.prod.outlook.com>
 <20240809073958.GA30598@yadro.com>
In-Reply-To: <20240809073958.GA30598@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=perforce.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR20MB5136:EE_|SJ2PR20MB5777:EE_
x-ms-office365-filtering-correlation-id: f79daf9a-8df1-497d-4a56-08dcb8ab27f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Lf44i4VxvKmKAUj7vSERiSFb8dlEktmGtVNFadUudu1eiLhAaF4mdBDAnS?=
 =?iso-8859-1?Q?80+PZRUvD7oFH7fMNJDGYBE10cB/QTaZfRiCGgKT4pxu2JdjECGhpb+RpV?=
 =?iso-8859-1?Q?kMjtN7OR8PW0Kt8FcNINRqJJ/UTM4vYQTLyPVBNjDtYvGHsMDq8immNNN1?=
 =?iso-8859-1?Q?OW7y4FRF1iKWE2+X4OnZQrZT3V1tBWB+fKJdRr+dXvYel1LP+0/6zgjTGZ?=
 =?iso-8859-1?Q?n8U+yPM9hf6EpTS75svfKmU5Bnon2B1yVDn+vshO1JI5VDMpIK9uU+eY2C?=
 =?iso-8859-1?Q?BIwtVJ6ZRa0v3YmP6VHpgukM5BR1as/L7Atd7fz5Yt1D/BeCJ+UHpP2sut?=
 =?iso-8859-1?Q?UoGVP9IbxsgRc4b164hU8djjIY9r0nKHGZvscHWSnZ3gy+YKLYcLnLI3s4?=
 =?iso-8859-1?Q?yXpPyGVxT9O2Z6cAIe9X2LJcmsasuPCgcaiC9IQ7dJdFIc2q+bePJpb0BT?=
 =?iso-8859-1?Q?lg7zZS+BLalR7UNxypRds0FIDWCaMnaf+vIg92sOj3usKk44rW7aY+kBYx?=
 =?iso-8859-1?Q?vVAgNw+qrxwEsxpkgg4j0KR04PfaanFCR85SCyWhQouEX/iiYFY8ZTniwq?=
 =?iso-8859-1?Q?XCbJcX5WWJIj6FZktR3M+OjA3E7joHTyyeWV8ezCaHQPZ3bQi0QgjGcsMm?=
 =?iso-8859-1?Q?jnntTxQl4iA78/KiWiHG520hwE8RW46JAIaYJpgJhZIgFciJrPaPguNESN?=
 =?iso-8859-1?Q?rPuT/2LZ5BAOGmjBaZOmjA9trdpTEPsdHcz6z7CLEpi4DtCgI2uHkJDJhV?=
 =?iso-8859-1?Q?NnMcJtqpeU7TmvN1aQW9pirtbm2o8M4PCV1lqWkoF61yCrknwHopN7SbAR?=
 =?iso-8859-1?Q?4VT11F/8eR58HFaSFFiZIxaR8JvNQjJo6LL+DGlIWugGiEP6g/hQB1aHFM?=
 =?iso-8859-1?Q?z3tdIopAz8hEWaBd24AGHho0v7so72UE/DHVa5DZsNK6TXr0ksDvfsRLqu?=
 =?iso-8859-1?Q?DpC39+27UsMh4ovpuV87RQcw1UceiDgQMmLqdf4rfc0iTOCVTsSmXco1ll?=
 =?iso-8859-1?Q?qYfJ9/ZMFd+hMO55RWyqQun3feqNfoceZvDRlIFKPD4LTu8W2QGDP4NARh?=
 =?iso-8859-1?Q?mY/81pB0fkXPF/GOlqqNhaqVufaou74NlX7Ob1v4L2nfjoMnqGq4LKB2C3?=
 =?iso-8859-1?Q?v2GIyoZKdQ70hlbzp3YktQzhX9t0L0XQh0I0BCYHsKKXBMTaGp6Cp/hIEB?=
 =?iso-8859-1?Q?9ZHshVPTCEyPzzfm7TcQSdMKr9GEHnX9twA9K9HwYEa6XBXBe81evx/pEU?=
 =?iso-8859-1?Q?A+nmwFxCtgr58EuevZP7xJAa8AkXbGR3WJTApdAITRMb0wP56eY88KJ/B4?=
 =?iso-8859-1?Q?cg4ZoVUF1zYK1N+O8/I6YvKMbIkGfG5gH7EtSmE5eFlAt/6usFqXrzse6m?=
 =?iso-8859-1?Q?SEVZUoD3Dg3KK4WDCupMBItexeLznTmw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR20MB5136.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?30MJaGj/VfqsfUTsR0Xm1vlEIZRZX0jwPdq3QROD0vEA5wBImu+3ZRcaZP?=
 =?iso-8859-1?Q?yGDDBzfn1MnQ5/7UUJwFaYmYeqkGbMVk5a+IwDuzQFlOraaVGflj5IEC9b?=
 =?iso-8859-1?Q?YPRS+bnJzUVhp26iy6sfcffR349xEZ1NcVKF3+GRbp1r4F2aKnqSHqB9hx?=
 =?iso-8859-1?Q?uiL9H1/UAUeBg7mqrVFa+AQ+QP3QxYsa2xNU+XynK6o4gshrygRXPW6rX3?=
 =?iso-8859-1?Q?Vg47tKhQhtWLOB/CVwxkkSM9WR12wXhww5rGALHSXlOBsXaOq8/OaEgm5Q?=
 =?iso-8859-1?Q?m22WPEPMCBFjGG1aUAXOJwd1gtwGantKOX9xPBirDKj2bIw1WH3rYdG1Dk?=
 =?iso-8859-1?Q?so6G0oJGJ/OdwE3houHpw+jg+cqFXaxdxmFD4HnKos95AqQJSisyB7aIa8?=
 =?iso-8859-1?Q?dro1tFVLAr8jzYkgfblEEpdhBq/zkxUPvIgKpcb1JB9Hsc3wxHzsvcMs0g?=
 =?iso-8859-1?Q?YHL1SMmGk4hceGlO435TBWv561pbhpdcXR8V0aa9DpFncdMaqgMSz6Uubi?=
 =?iso-8859-1?Q?qVgsHacPN91xd41y3LfVum/sgpchLm8GotUMeMUgBi/I03mxaBZEFeZqVf?=
 =?iso-8859-1?Q?ICPktJO7L5PJPu352VFBaBbPCUrbZ3/G0v1NDkseN13L0PxBf57Jz377eV?=
 =?iso-8859-1?Q?OF6r5xpmKh96c0a5K05YtAiDbyTOEJuvutd/BjBb8iOFDzA82Byx15wouQ?=
 =?iso-8859-1?Q?e67I/cGcuO0OYkt36fi7wYiorBIkXYzawwNdAKzlNjC0vUytTcAvqWBjf/?=
 =?iso-8859-1?Q?9GBIGsGk+26hmLrtx6qFm57DRn4HdYFe/VxAA3m6VAhWKXrl9oY8FqpD9v?=
 =?iso-8859-1?Q?gjvUGmA88C0DpbUMGzFtM3PKORU/GRR/1am/ovF67PaRkg8Gqtmty+asdA?=
 =?iso-8859-1?Q?ECcd3u8Bq7Wk11/fxZWCuwdhUO/8DE+AG+Bgs1y+mp2XnpffHAKutjE9wW?=
 =?iso-8859-1?Q?znR0TdGUIKkNWIWRquxf58W8XNruipx1q0QPebpzS8vH11I8MzdYu4zCOG?=
 =?iso-8859-1?Q?mMmw/Gt90wxXJg4sVKHKwuxcZIKhj76aVHZpuaUUW/ddSxXMKCJS1TeRyL?=
 =?iso-8859-1?Q?4b7DdSaR5ZsqUCBn12gv16qCULXQHQx4UW6qOL6dCeyBxO4QDj31MQ49aL?=
 =?iso-8859-1?Q?n56Ltwf1pfATSDsUFvODhhwVcM1daXHW/ABOIOy53g0vcr9gA2TzCSyjJT?=
 =?iso-8859-1?Q?RGRyzgTVD0izP5uCR4HLphBnmGFY+p5v9Nwu/pxY8S0FELdejCon5hpg3P?=
 =?iso-8859-1?Q?gCchjfS1X+lpAu3tlSufwgdImVpfcT+p6rQqUzHft7bf9rAstRaVnLIG2/?=
 =?iso-8859-1?Q?Ge5PW8yFBtsxtOSOm4U1vNrwyqESkLTd+mXu9uN4npgyAaQNZBcX9+4Gs2?=
 =?iso-8859-1?Q?gxyhfHyi2USq1HknEBudJ+FUpVW156gbgkwMMA926n+xv1ZHJE/bn+cHXn?=
 =?iso-8859-1?Q?k6nO2VFrNL+agoclEt4jrVVYnxCSnL7NEMDNVqF+NaTOVPO5Vafv3omiNS?=
 =?iso-8859-1?Q?wTWACDZVzgVaVWO4hkmiZXr9qbsNuDBftUvaKfiBiZ4lOelH/bd5ehtuJ1?=
 =?iso-8859-1?Q?Un7u3gOF155XHTq9BhDTWZC3c+gIismmvr1QRbD09wOVt3e3M0re/RlHKh?=
 =?iso-8859-1?Q?ZR/eTJTC+Tli8Yzmda7AEMMzkifRwSj0bV?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: perforce.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR20MB5136.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79daf9a-8df1-497d-4a56-08dcb8ab27f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 19:40:42.8823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 95b666d1-9a75-49ab-95a3-8969fbcdc08c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4JcFPPG1gRtAUghBEk2WGuYarc+ZoiLjVyEVBpz5xOzJzhWM1BxY/8KsgFMr6c4DDg3b/9J2UDppZFDKRUzF9ere8Q79qUgeEHKz//O2ejo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR20MB5777

Hey Dimitry,

> 5.15 is too old kernel for iSCSI, there were plenty of patches that fix
> commands hanging there.
>
> Definitely you need this patchset for the beginning:
> https://lore.kernel.org/all/20230319015620.96006-1-michael.christie@oracl=
e.com/

Thanks for the pointer! `Handle abort for WRITE_PENDING cmds` seems like th=
e specific issue we're running into here. I'll add that patch to our repo a=
nd see if it fixes the problem.

We're aware that we're a bit far behind the curve in terms of kernel versio=
n, but I'll use this as an additional data point to help prioritize the upg=
rade to a more modern kernel. Thanks again for the help!

Paul Dagnelie

This e-mail may contain information that is privileged or confidential. If =
you are not the intended recipient, please delete the e-mail and any attach=
ments and notify us immediately.

