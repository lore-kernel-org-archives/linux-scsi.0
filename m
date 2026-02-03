Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817AB7261C;
	Tue,  3 Feb 2026 19:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770148486; cv=fail; b=NuOBQ+VBejsQldIpkIJsWWR1ps009ME66klLM+KYuCzjBiCP9yqoFZgyVtO55ELT5YCRxNMcma1kTMqpdSJPVJzCWAO37/yeBqGI5vRJlLxtGEQxJbgrCf7wOinq3HxKcDdfdF9zMmR6KjBRlEb2K//XXuz4Ymlh3D8kB2edvfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770148486; c=relaxed/simple;
	bh=4Jf9nRyKbljqzrZ1WBru0d32yxYr40xvHqbFmE4URm0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XU+UzivW5ltRi6RoPV3c7ClqlhqM1d2Qz5LRf0n0bBo7znuJIzLwLgdijtEp3HI9MYd+viVDZvzc32SCKhf2Nn+rYsEtS1B/dresGJJ5s65AuocYMA59C0LrnXTAGEbCLr/NMNFMICEi7yo4d7JgeE931MMmx8FmlbQcRnZ/a7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=eE9EnR4N; arc=fail smtp.client-ip=52.101.52.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="eE9EnR4N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AVUK0QuqaC6o3ilnekUrUFk+jAwiKUxqTf+JhjEn8z3dsvwqEpuoNQQW2Xonjs8316hGo4GQ5oKLGrqrUbf0bqEigcGKijS+d8x7aDUR4JJVj+nreSKFHvagcAyWf51R3X/uE+3gHiPUqk04o3EImKQf/2hnKf52OUlsQ58gcyAjUP233BJVuL5iyOleN/20PZuER6YUj21DxuUERYVHg38bBwq4q0YuyykAoTZpMsl5oRvUGM0YNhcHAeJDqBD8vInsdMBxssccqRfxLOJBtas1Qxv/naeRC9TcHNHRyrupmlWTG82RJDpcaxoFDWbjCuoTb6XS5XPydFi17c9e2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Jf9nRyKbljqzrZ1WBru0d32yxYr40xvHqbFmE4URm0=;
 b=SK+N6qOe49HCFJ6nG1ZaRT3FTIwilBEULGVvnqfnh5FqpiM+V+SbE+nrXb7D/pLS7RZN57uTZgm1LXCYdvnqSMTSM4vMLkAQp77QpPH95O+fgo62ONFsx2eTYF4fRcBUFNbIgOU6+z5KIr8DiEqFJorbyHikZHKnTvDH+hdIJ6PmhK0Bb5h29atwM6hxfuclMTKJjAvvhV8KAG4AZXU+4wEWs+8ObWJP84ujwCUQTC/FhrUAn9x8d4BUAxziCOa1wmh/SIIbW0ub7Nq2pbm4kKT/AFd7n9/GYlhYT+Am0/xt6IftC+iwLt5OIu72OSxRMY0KH9D5Q6vyxB+9gJkazg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Jf9nRyKbljqzrZ1WBru0d32yxYr40xvHqbFmE4URm0=;
 b=eE9EnR4NvlYvnbKBw5J/U1J5g4lPnRRhCHCxPUOnOlWppF+spAbx9PbLl3Gqq9fBTJ4lzuP03pXk7EXJJNj03PTEBtUbi9AObc9aGv2rj2RLpgcFaIFZBfUxVNbvBiVpNukNajaOyLP8eOv7vIcP+SfT1fmDDuPSd2/uBzIRbdGGhPUmjOEqj0vA3v8vDmhfsuR1xPSWoSGjMyOX0O0/GxNT9CbkA/zEfMZixP3HBR/J1wKTcz+xTRQ2hA6r7a1oA3juKR69RqL+ZOTsqOuGRKjIB1R+gxS2PYfXoj6lh4JE7tdsvsdZ6nIz5a61BmCnhOSf6G7O6AJDucZRT6ycSQ==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by DM4PR11MB6068.namprd11.prod.outlook.com (2603:10b6:8:64::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Tue, 3 Feb 2026 19:54:41 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%6]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 19:54:41 +0000
From: <Don.Brace@microchip.com>
To: <zilin@seu.edu.cn>
CC: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<Scott.Teel@microchip.com>, <john.p.donnelly@oracle.com>,
	<Scott.Benesh@microchip.com>, <Mike.McGowen@microchip.com>,
	<storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH] scsi: smartpqi: fix memory leak in pqi_report_phys_luns()
Thread-Topic: [PATCH] scsi: smartpqi: fix memory leak in
 pqi_report_phys_luns()
Thread-Index: AQHckpUlw+GHilWRp0mTS51FX0Bl9LVxL4kG
Date: Tue, 3 Feb 2026 19:54:40 +0000
Message-ID:
 <SJ2PR11MB83691484F9F6DAD3F347EA2BE19BA@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260131093641.1008117-1-zilin@seu.edu.cn>
In-Reply-To: <20260131093641.1008117-1-zilin@seu.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|DM4PR11MB6068:EE_
x-ms-office365-filtering-correlation-id: ab9de53e-d40d-41bb-29f7-08de635e11c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?JM7m/uNgx41jLM0ddjs+y6tBLYwe+rMMscPfbx5/HgbyrOWCaxz4wKiTlG?=
 =?iso-8859-1?Q?QNMuD1Cgv86po5FR9p7F0mB9l9Sd8K7yKIMCnesqB+wy5X0qcZKpiiU2Zm?=
 =?iso-8859-1?Q?5cZ9S+sAPkr+iEQjYachO06MihT+joL0Q2j9TdDOZMejVXaS5fChrPIqP1?=
 =?iso-8859-1?Q?epVX3aqss3QcDtW0QOJvG/EN/QmePMR9eSpXUHpyY18iaP1ZTPg+WiRkG+?=
 =?iso-8859-1?Q?cYG1amX6ADFVCWKu31tXmg7l8gBgbxtg0RZmTWWJ/6Q52nyHWfA2Vu+Nq4?=
 =?iso-8859-1?Q?QiWV7UdNlulEGzt7bUS6dKsOLt0jppGfsdzpC9oGTXcqOpeKghV704haxc?=
 =?iso-8859-1?Q?4gC2hAil0d/CLIILaJzF6QmmjnKsvdpP9G8eddbDEDm8e0zZdX+rj5+9lA?=
 =?iso-8859-1?Q?SyxO0Y8R5aZc9lqVJXgc8sLNhkUuHr+2TwB9zZKCEbvvtUcmY+rNNDajvk?=
 =?iso-8859-1?Q?vHbyjLOHaFkhcpwysn3iW2jfRtgDtDEetW6pRs93ppbfqXBzZUufg3yBAz?=
 =?iso-8859-1?Q?Nor/2fCMoK8PZfHVk/gjJMITlvL56fofm8fBIbJtSdN27LSotPJ8P2eOcu?=
 =?iso-8859-1?Q?8lRjGjmkRVfVMg1xnHe33uRSyD2Hh8+tndyd9ZQZQCSJCi+uu5ruUBfRdl?=
 =?iso-8859-1?Q?fYW/3Kbtw0kob6Q+M9j/C1Yt1c9fEhF77F9Bwjr9uhTh9UnVm0MCVialhf?=
 =?iso-8859-1?Q?mMKMRuFL7SMSPWlXeQ3VkbuaH9AMnhMUxE16yttlV6UUqdT9Lg3oq2aSh0?=
 =?iso-8859-1?Q?tGsx67iUgAN1MgRiykiirftYNvmzOfGN28pgamjuZPNGbhjCBkBEJduFbs?=
 =?iso-8859-1?Q?8I1eVkCSSjuS3f2+ZnhuKLiZZePcfl8nJS2vPdwYlvKfyl3n/frfyjf+03?=
 =?iso-8859-1?Q?txRDTBQBkR6yA+h5uSFk7ISRRcawV0SJ89i7q/EKgauQJOFukhANq9mJaw?=
 =?iso-8859-1?Q?9DJFMoffODy3P0+kBGlPZr9REYMpcFMy/krCSdVXcir8zRC/J6GzXr/1SC?=
 =?iso-8859-1?Q?EUoHDYin06mM9APj8GDvk+ijAZFI5mqUE1b5Enx1A/vwJM5HQJMQ5ATG4T?=
 =?iso-8859-1?Q?59Eqku80xgQG0UlF3d+FXnJSHbYnT8OU5XcpfSRrL08PKypsfCTcsjC8kA?=
 =?iso-8859-1?Q?9JYZYp42+1C6KpyZ0eC1Mo+QbmRcUgc31SbQYtSo/5Hz2zVThS3r33PGVQ?=
 =?iso-8859-1?Q?pqGIfYwmBVA9Ym3M+Lx3ss4WvPlHUE6o0G/KmXH+nSSYIqz+OeQ7Ryv1xJ?=
 =?iso-8859-1?Q?Frwaj5LEYE5nR2Oj/Jhdwk+7Km5nHeE9dWM5QlaQULn1E2eGhbQaKcWeJH?=
 =?iso-8859-1?Q?/NrsyQ0O7t491onL4brp92WNh7MjoqhVKKm+fjGGXmF68FJtnzY4Hr/gbO?=
 =?iso-8859-1?Q?bQV8XYtMJxbWgcR6tYKdnMyD8ZunZRVzpozFXRk/C4oj9ovnK4VvOzxhQn?=
 =?iso-8859-1?Q?0RUrohzoGvDRDHI7tE3H3lJvFgc8/Cv9whogD1k/7RPjO+71w65qohiYR4?=
 =?iso-8859-1?Q?T2SI7GpwsZvcKAk3Y+eSmD6Q/Y9h8BfHNEoq+/obh57zd7uE+7Fu8YXcul?=
 =?iso-8859-1?Q?vzr2itU/umoau3+UK0ENa2qYBo6tdSNH4ZdoxVB5yOgAy3v2ThzNn2AiZ0?=
 =?iso-8859-1?Q?odXzrz8dyL8kvXo9BQwsF71asgjSZ+cJuDy1bo5pBQB/Xok+cIrO1PVSZz?=
 =?iso-8859-1?Q?rppATLjtdImZF6yI970=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?e1DJYGQEgKQXHv+THzYjFuM5sOjVZ1S6y6a2gegSiCXWr4KEzDKk7DH9z/?=
 =?iso-8859-1?Q?ejUWQLexfyOTcSSgBnMrRM4J8ixTdU/hlTOSRA9GEonIOFoomQuKz8E4qD?=
 =?iso-8859-1?Q?dHsYNkMbj4Ub/H6Z+/3lLG317ZJe0pdcpY0wLDJ8QxEll6MyEeVLh8SGor?=
 =?iso-8859-1?Q?i5SY8ECmxnBaqihON/Ztf3F9+uZpKX+nbBJvG6mlD6j5F98QLVdwkS2YD1?=
 =?iso-8859-1?Q?H8Nuk0vS9GfGWl5AWdNkykFlvmqJyR8Ada7PetCwY6Thg4Y9ilCL9B9YTB?=
 =?iso-8859-1?Q?WJK8O8c5IQzpBvyacx+EL1VSiRZEpP/JfB5PknzpAatJUvcFYEDwC1mLS+?=
 =?iso-8859-1?Q?mCY2X3ghQE712d0ueUxx3ea6d6KkK7er3YDiVDlWBZE15go2VNBLd9Fcs7?=
 =?iso-8859-1?Q?Tn49xDHPIsjxGHOYmnnDKbEYMaN5I6aaAsf80Y4Qp1oTaktl9YKk+uC4PM?=
 =?iso-8859-1?Q?B20XHs6q0QbNeHFVWcBmG9sgqnxIgLIZsW9645DcjfiG/HVR7VPHcwXKmL?=
 =?iso-8859-1?Q?evyNL0sTSRdXr9JPyYOUhmYtkH6nJKCNdq+e5GxpyrlIHpbsaySA0i8l8s?=
 =?iso-8859-1?Q?smMaMB61XLkD6gf2s87WkZpB3BoxwK5e01s71E2FBI6cybDMx4/YxmbzVZ?=
 =?iso-8859-1?Q?F11+oGOD7ohU1HODXK2YnmIEzsN63F/F+DDO4yqjK4yg82VkdW1Iz99Oum?=
 =?iso-8859-1?Q?clypGVoAimuDwUZWJjTpQKRpn0LbXJ8kpYpFyjOaMftcWEvzHYItOPEM0W?=
 =?iso-8859-1?Q?Q7Wj5cCYW4Z+RVDEfnhNy0jHMwBry+rcCyMlibZXqh4KUfLkO+eUqtdZF7?=
 =?iso-8859-1?Q?C31H44aJFY3EHcPF159Eogk1/wdYBkqwnhkWPcfxcRnzp4uQDSAbyWhLRQ?=
 =?iso-8859-1?Q?HpYu2DfI0OO2ylrMMc70PaewmRbNQbdbbqAnVeuTXk/o9JQOZmZcB4gnZa?=
 =?iso-8859-1?Q?+VjF21kKEOFXU4d8LGEofmtaHNamjAOT8oNfUyu6I0k3Pa5maAKDQd9XIT?=
 =?iso-8859-1?Q?hm+54AoCTwaqmbzHvOLbOGD60IX/NWA+RuuGQhlD5Uc/30nz38z8ffh4b7?=
 =?iso-8859-1?Q?0asT4mmNFmasDsQcMz6EZ1uWB//pD7zYPtWH4nS5A4SNsfkMsXbfzEGCXO?=
 =?iso-8859-1?Q?XDLpBZ0MTjV2HN5sQok6S/46+iuxaMZ0gN/CWjlqDgnsUVjaOKvlYNjz6H?=
 =?iso-8859-1?Q?pHpHqPyeQVi3OM0rOAt2/b9RSjwc3Ak1iBGbV5ht1iqvNqheyE/Sekyw/w?=
 =?iso-8859-1?Q?44gxaXwRsT9PoGX5JdG6ZaLBHv1adW3DQ23Dpd7vQB+tdxB2vn0kSnPzEj?=
 =?iso-8859-1?Q?RmbnCT/Rd/0Ov5ikEAM7hciCFpCfA4Wo6R/85jHhCMXJcJyIS5M3TrDk3Y?=
 =?iso-8859-1?Q?hIyDMPz578iDL4LwlNNj9iDSLPzEhxTYvttKGlntJlpem1UoYb03rcuJB6?=
 =?iso-8859-1?Q?O4mqf3M1vA8z48DMGOUvNEp5onjnOGsq86VZq7HGBfQFonP+dP+8ZlbTaP?=
 =?iso-8859-1?Q?aLSTfWL1xedF6XJBUBmohgCkPyK5pxZ5SGDL2kFv59ddtus7ZOXHxaAbQR?=
 =?iso-8859-1?Q?nJcxvyk6pHXmfUDqJ2CWTMzguMG+OZwLG77FATIk0+E7H7ChAW2bxY/IGV?=
 =?iso-8859-1?Q?n0CM4V2aod0g0N09swaUaCiVOx0vaX/GfDtTsYvBlbPtUyD/US74DbxGOW?=
 =?iso-8859-1?Q?aUq8AsdwqhwuIKPKW+wXxxx9QICfdHc7zHY8W39C+U05LuCg+HnP+P1DRa?=
 =?iso-8859-1?Q?04UVoVO4SmpGjtM69FE7aVlym6LmokMZcWQGBvzINbgasFgYjkFBcwr04c?=
 =?iso-8859-1?Q?rNMpqZU8yw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab9de53e-d40d-41bb-29f7-08de635e11c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 19:54:40.9009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aT4sboUd67aZ9hICEkCVjASDAoP0hQYQRJ8p9+b1cFEKtxQHNwRT+Vt6Lm0y3f3JD/KUWRR+0FQMjjToOFfOJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6068

________________________________________=0A=
From:=A0Zilin Guan <zilin@seu.edu.cn>=0A=
Sent:=A0Saturday, January 31, 2026 3:36 AM=0A=
To:=A0Don Brace - C33706 <Don.Brace@microchip.com>=0A=
Cc:=A0James.Bottomley@HansenPartnership.com <James.Bottomley@HansenPartners=
hip.com>; martin.petersen@oracle.com <martin.petersen@oracle.com>; Scott Te=
el - C33730 <Scott.Teel@microchip.com>; john.p.donnelly@oracle.com <john.p.=
donnelly@oracle.com>; Scott Benesh - C33703 <Scott.Benesh@microchip.com>; M=
ike McGowen - C62625 <Mike.McGowen@microchip.com>; storagedev <storagedev@m=
icrochip.com>; linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>; lin=
ux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; jianhao.xu@seu.ed=
u.cn <jianhao.xu@seu.edu.cn>; Zilin Guan <zilin@seu.edu.cn>=0A=
Subject:=A0[PATCH] scsi: smartpqi: fix memory leak in pqi_report_phys_luns(=
)=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
pqi_report_phys_luns() fails to release the rpl_list buffer when=0A=
encountering an unsupported data format or when the allocation for=0A=
rpl_16byte_wwid_list fails. These early returns bypass the cleanup=0A=
logic, leading to memory leaks.=0A=
=0A=
Consolidate the error handling by adding an out_free_rpl_list label=0A=
and use goto statements to ensure rpl_list is consistently freed=0A=
on failure.=0A=
=0A=
Compile tested only. Issue found using a prototype static analysis tool=0A=
and code review.=0A=
=0A=
Fixes: 28ca6d876c5a ("scsi: smartpqi: Add extended report physical LUNs")=
=0A=
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>=0A=
=0A=
Thanks for your patch. Like the minimal change.=0A=
Tested-by: Don Brace <don.brace@microchip.com>=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
