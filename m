Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391895677;
	Thu, 11 Jan 2024 06:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ggOE6Q8b";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aKCZWXG3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1704954474; x=1736490474;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=jyJxsa5GnKgY7nfFM+dvL6hmsKnU/2m0KmPh+0FXUl0=;
  b=ggOE6Q8b5bKwYvwscUCcND0j10YI37gHmx943oWlrzUjPRiLIND3/zJ3
   PQI+a/5vhW3lmkv064yoL8c7ucvEOO3iZZj/rfOrz2txUkP6IH5C9iY3g
   NQo6cP+Z4dUyvLUjVmV2WxfCrefBTVl+p6YaGHFbkwPSrnxw+rpI9Vp0n
   tgU9nJcrG6PsZGpSNlR+uaCTshBe9m8aTQ1/RxOSrkZtjJEpWGJYolud9
   R3oTgly99crmhNl017H4WP7CNlTqCWNWovE/DcuRGv76bizFaRPiRVJC4
   181nzSqkuv/YP6zhG+dxgmZyDySLwqG1EttF6gHN9/JZ5Z5SzDOI2sndl
   Q==;
X-CSE-ConnectionGUID: lyCsd3ENQdmdFmwjDaFiZQ==
X-CSE-MsgGUID: N7bQuvnaRfm8mHnKz6io4A==
X-IronPort-AV: E=Sophos;i="6.04,185,1695657600"; 
   d="scan'208";a="6612169"
Received: from mail-bn8nam04lp2041.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2024 14:27:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCpdXI7WInbRcJsrMGFY63MPu/JeM0uAG1bLQA32M3bWUWvD9dmeunQ37332t1C2/jPbIi3lUOWoiV/3ZmU6TF1OqwCwR5G1GYyH2dg0ajbHS5o0KFCIjh3V4jbRMOvduKBuYpWAIlAZ9fbYld8U/oWyQLfpg2nKGkwwv3f5q9w+cHjA/BHgE4C2NkECooVxI9Gi8KN6aUU4mtt5zwg9sYJj8wEYj5hR9Rrk0lk2D3JdE7rEusCOTfls1yQDhhpSeRrloIo1F1+LJfM9FhLtRiThkpFbm4vj/QNhOSwdzqCzIV2WsLpJdK/vOkGc2MU6L1H3B32mjz3CN5BVpi7ozQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ufesvswm/qodcgM910m7VROg/wi4/rlhQ2KPDy/aoRQ=;
 b=IR0LHYQrsO++th4xVrT3rQKtKmMlL01uIPvjGYxyJNdYXilcSIN6ND2Wm2Hwg82SZBdWKTg89TNbL8WUC9ZQ7W/seMf88PqXawkEVbjdi0IphglWuyvzjfVB66ayMbFMQn+tJdh8CypC1RM/P8VxB7fHjupggi5cxmsCZBK7YMzhBWzo4r7dHgSPd37W4MV21iMpvkQgzYTDvQ/Pa4H/udq8YcmO68Iy4Decqyzz/2CkHlcLWI9d3FXGrCz5BZw38Yzr8okcbtWT6pWn8VlG+T1XGgtK8LMcx9GASfhbKlxQjsluQsyOrt/DMD9/KxYJ+IEKgWkJ1voiyNfRFal0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ufesvswm/qodcgM910m7VROg/wi4/rlhQ2KPDy/aoRQ=;
 b=aKCZWXG3RK88yfU5Aei6ROjSAfav8p+K3VYcFlqRp69jo30tHJbK2nxitXwSGcaaLTDX570zIPNySqp2HCr9zEW8XSJHky6b/bvvNim71mvG4AvYf43dxOdzGerI/ZL0fDHslPdsM6fMdVTZj8ODlpri1PlNODcSWR8gzE1QQBA=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH0PR04MB7383.namprd04.prod.outlook.com (2603:10b6:510:13::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7159.18; Thu, 11 Jan 2024 06:27:44 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4%3]) with mapi id 15.20.7181.018; Thu, 11 Jan 2024
 06:27:44 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.7-rc1 kernel
Thread-Topic: blktests failures with v6.7-rc1 kernel
Thread-Index: AQHaRFdJ1vordNedz0mJr/DRG4EWRA==
Date: Thu, 11 Jan 2024 06:27:44 +0000
Message-ID: <gaz42xjzjsf2w4zj5sory23wpoym4wuz7y4lz2wxwx2eum5jl4@4s64tt635abf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH0PR04MB7383:EE_
x-ms-office365-filtering-correlation-id: b94dc3ca-609a-4c0b-d18a-08dc126e6be2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 zqkoe7Li+zKBWALCiFW3zt7gmx8c6JANyQtGxkX/aWKpMBNdqsnwqG9hYvoXfIQfzG6KuiQjVwXO3JobhIYOCyCwAmBSr6O0MIiYvBKBBR6+Fq/WQ97LfV7cKWvFk2ApON2GJPRxt/Dg++I2fbClnNgVvXd3wQuLuUQaHznI93d/fBXvavWwhziDZF0E0Ckh06PgTCgImVaOTZqoqy08KBGk9JLcMbLsr5eDJS3mf6Zgsf+g+YXHyt9YNh+Q7bQaUagaQD0kIW+TUxdVMj94qzT/LYl0TbJBsE+VszB1Iwbdb+G2BtFQiuOaxz+VmRxDCP/Wk6S27ioGni2z8A1whAsOt4y6dL0o3J4arJ3zsjJrSxcMVui3Md030iphR/SkoRsUsCNxQ957W5HSzQSBzv7QpLU3m5sUBfLWGqxKljvnfB+K9bJ7nG35oPfvvYUv2CCU92jKxFxmH8xZt8FJi72VfIoR/nK96fNf5//mXVxqmL7UP4BQRA8b1KzdqwkkbreCNGuZUtsB6XhZsW5auHKqRpyOmB61Lr0MbsJn802B+PdUyhOFJyXgAfA0jlB3S3W3D0G/plqHkk8x2kK79coEmNRb5hCE3PLDvozeSJWuOXjkZOKfcNu/b5DIx8l3yNmoeUk2P0Km5IFXTIG4dHuXl3v0kjiu/D2fi5UWHR46oFvOknyL67C2Eln6VKNM
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(39860400002)(136003)(366004)(376002)(346002)(230273577357003)(230922051799003)(230173577357003)(1800799012)(451199024)(186009)(64100799003)(82960400001)(38100700002)(122000001)(41300700001)(2906002)(5660300002)(38070700009)(110136005)(9686003)(6486002)(44832011)(86362001)(6512007)(33716001)(6506007)(8936002)(8676002)(64756008)(316002)(66946007)(66556008)(66476007)(91956017)(76116006)(66446008)(71200400001)(83380400001)(966005)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?G3kW91s1QJN5zh00VPBLIPMDsQEzfNl2D4wBVa7QsvMba0th0pXLwyLe1GET?=
 =?us-ascii?Q?kkg6/taRHN8bP35yiCC2RSFVqlhuHJA7Gjnqm9OstoSnYu9L0Hp6IbJ8ULab?=
 =?us-ascii?Q?AgFEQKnxLMnfITuor20krnuaOnakJr2LdXWA8c4ZiEHqQueGK13zRHT82Gkc?=
 =?us-ascii?Q?zAeqrG/NDFGkqhG9LpRiAb5Up3DycV55BVSJkUWgl+aDX48PEA8z2UIn4Gyj?=
 =?us-ascii?Q?mL0TbeCxJoGPI7E5YdYQvNCUmlaek5J2wW3FxlFh1LShOQdk+GdgyOU3+Zzf?=
 =?us-ascii?Q?GCrNfGHfupaVOdXc90iUf10pzUaocopcMQoBJEQRV4WuUofIsGsoZZEDSC9r?=
 =?us-ascii?Q?WW34GanD7ovM1wvFVZcLbX+vK4ACQmD+JKzuKwvIXVnmbNO23Mk8VfZk4AnF?=
 =?us-ascii?Q?VHHnueRvY2Tmjvz1ObbZLbNDvBBfhi5xUGAf1AQjFjEN/IJvaWx8/UCg8yc6?=
 =?us-ascii?Q?yAyjmlTlbSA+OfnZhIcYfMjsMlT07v6W+EisJXojGa1r7n/ned9+7icd7dNC?=
 =?us-ascii?Q?rIkqHg14pkuU4qJd0wMbehPe5oDfjdy8o/0yJ7pn8nGdV1IEnICvavpbMWYX?=
 =?us-ascii?Q?GBH2X5CpWESB2OzPOGN+JAGs148BJngHlTVr+yoPxKIsyAjyF6VbugDsqvz4?=
 =?us-ascii?Q?tJcnEastU6XIRSAjF8ePaLxqbbuJnmZbg44m9AF+zExpPgRxZspWqsyp7Ds6?=
 =?us-ascii?Q?3+r2IsEHbHHbTmJhjo1jIOkCOHse0pam4K2gvaHWDd89Y5vF3aOMww9IGRRx?=
 =?us-ascii?Q?apwRWyEnRbB3DmcVAJsoMjKuLHOGpl76Krci5tSvqIw9OPmGCJzAutXAfZfv?=
 =?us-ascii?Q?U4I3aXTOXhgSV00mWomsE/NmQ3+MYJ08j6w5ZdOCTY8MxsVrkQ+JAFUsZpgO?=
 =?us-ascii?Q?rSnqYzbkvQOzKkWBOCRQn27IXesU/00+Xa45hs4uv5MzFvW5caBQssGesmkA?=
 =?us-ascii?Q?rSHUzIDY5bTvhBIxAF/yKcWXJ7pXNQAlNMpYieeO82uUMj0mMvg7JiOdT08c?=
 =?us-ascii?Q?ZS+aZLfTLrrrr22cyTTpWal5Vha9YG2dOhlo6W3JedQnU1wP8sKu/i0fg9By?=
 =?us-ascii?Q?3mAbHqr3jTkg7cYQ5Lq/241kMOcrNJCmZ3E6FGWwt0qpI2eoCWpsHRLiKQvC?=
 =?us-ascii?Q?xoiys8W7H/iJkJ9OuWHq1MO2oYDrFNZ3HcnZJ3RT2H0DE3eJpKzy4NFPV/uR?=
 =?us-ascii?Q?vD2QiBF5Fj510OuIrKMqem9CRHP0P39rLOtiAN2I47mAcMyl+Dcu9usxCsBu?=
 =?us-ascii?Q?IFNKnJUPRRWE20PM0n/lSc+aAYnnwi4kN7yIUbO1ug+BLI76WAgx8QI9G/HX?=
 =?us-ascii?Q?j3cMQnerlffTJmebNX6O6UshV/IaqJav+owoNKdqAY6aKNwsJyM2ZV6SvcLT?=
 =?us-ascii?Q?Nrm87xMYevk7LivMEB8FDcI8Q3wbetn+wzuYWe0SHDzU7xUsN2b6NI0CfHaP?=
 =?us-ascii?Q?bXciDYdNe2UN7oO21tiZkiN0OhJXBjI7IobfvaYL/eGp23ZoV61go2FUnpBZ?=
 =?us-ascii?Q?Usk5N3xTaMECoJLQ4TWRu12DCq/K72E5uj1WCzoI4DV31Mh4U66QGcDXBTbL?=
 =?us-ascii?Q?EHcHejg2atQrvk8MOawwRFVpMme5WlehA5Shpx+OGI6YPEZGd238YwIVwj11?=
 =?us-ascii?Q?eMCVBY+s8P2xh/QhCyBgDs4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A140981B17EA3C4D92283D948E72A223@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YdHhK6fFqFpNDTiH2tuRwKWihNXe/Q/qF4eZD3LfjgD4OpMxPxRMYN7tmOoMJlGUxOP+INOdHz5ePXlFVrqRkLbefVZg51mcOM05+JjoLiLwuDuCb0lVHki38hPpBTuk7lymXqa0a2eR/B3cD4RBj09VwfAPBow6b/dHUGrWoUBBwrK9sSfTjh5bo765ruNBFgZhuevty5Tzq8rxvnZPWbbH7qmn7SzCFA8RqpmwUtQvSMwLUrg15n8hbVvoINLcDD+vFILbYCimBgCK8gwId7LSYtppj0+fTwMiGcg8+h7HrgFiTUM+8FKbrDUF5Mw7G7Qa42mtA9s8yXTfXF4bXw/pvIb6GFcZWUOFcZv29+JqTlshtcM3uyWsQEYLH1eeAubL5BJX8PXoADmNIdhu2n+5XfOEZcmAVu1x/8D6LTDnbkKLdO/iY4PFi+bllY6QRa+7jfUIcL/sQr66ixG41clRshJlsoEIbCXcicbHarmkBChlUykXuWP8HvRxGuXCMf20gdDZhyqyf1Ldic3TWZE4QNJvyG7qQbgPY8+09mLLoFSXzdpnD8FFM19i1/rZjzi4pBE4ltSnXRdoQzqhnOW6Nc1xKCTdOVxPYSrO2YgG94adpdxWW3Jgrxx4tJ9E
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b94dc3ca-609a-4c0b-d18a-08dc126e6be2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2024 06:27:44.5151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eFXDPCXOCfzyil+t3uvM14a4L8Ypav6rh3LCr4qMYnKYYQ9O3Nzt9Rrk2Nt8BzVPAoPqHB2ibieBeCli1kVTY25FUIsPhVtjLWZy5hms3Cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7383

Hi all,

I ran the latest blktests (git hash: a20c4de2306e) with the v6.7 kernel.
I observed four failures below, which have been known for months.

As for the two other failures observed with the v6.7-rc1 kernel [1], they a=
re no
longer observed with the v6.7 kernel and the latest blktests. Good.

[1] https://lore.kernel.org/linux-block/ytcn437kppvuj6pwokthrh45asmupbbmbp5=
ybf56yipo4tukv2@g3qau7lqoooj/


List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: nvme/003 (fabrics transport)
#3: nvme/* (fc transport)
#4: srp/002, 011 (rdma_rxe driver)

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: block/011

   The test case fails with NVME devices due to lockdep WARNING "possible
   circular locking dependency detected". Reported in Sep/2022 [2]. In LSF
   2023, it was noted that this failure should be fixed. A RFC fix patch wa=
s
   posted recently [3]. It still needs more discussion to be fixed.

   [2] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmcv@=
shindev/
   [3] https://lore.kernel.org/linux-nvme/20231213051704.783490-1-shinichir=
o.kawasaki@wdc.com/

   This test case caused the following test cases to fail occasionally. A r=
ecent
   blktests commit 1e6721b87d5e ("block/011: recover test target devices to
   online or live status") fixed it.

#2: nvme/003 (fabrics transport)

   When the nvme test group is run with trtype=3Drdma or tcp, the test case=
 fails
   due to lockdep WARNING "possible circular locking dependency detected".
   Reported in May/2023. Hannes provided a kernel fix patch [4] (thanks!). =
It is
   expected to be upstreamed with kernel v6.8-rc1.

   [4] https://lore.kernel.org/linux-nvme/20231208125321.165819-1-hare@kern=
el.org/

#3: nvme/* (fc transport)

   With the trtype=3Dfc configuration, tests run on the nvme test group han=
g.
   Daniel is driving fix work.

#4: srp/002, 011 (rdma_rxe driver)

   Test process hang is observed occasionally. Reported to the relevant mai=
ling
   lists in Aug/2023 [5]. Blktests was modified to change the default drive=
r
   from rdma_rxe to siw to avoid impacts on blktests users. The root cause =
is
   not yet understood.

   [5] https://lore.kernel.org/linux-rdma/18a3ae8c-145b-4c7f-a8f5-67840feeb=
98c@acm.org/T/#mee9882c2cfd0cfff33caa04e75418576f4c7a789=
