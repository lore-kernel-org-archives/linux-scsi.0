Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D3C19452;
	Thu, 25 Jan 2024 06:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706164487; cv=fail; b=QGFK0C1jljWpM0Fl/NfYd7BrOJH/Tc2lKaF4HaYi1XCRI5US0YT0UVNzgU2ltfgLebv09wQnjlgB6BCcCBDw2qNdCa+givWUXqlscRDayJhBIwevH9Iq1i9lMhr7dHGfDf1K5df+Iz6b2WYzl6G7MTjoBuDlXYY12EC+JnGqnYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706164487; c=relaxed/simple;
	bh=oW9Lgps/dLQrMQykRI4NLrP4Dm3a6fFxavM0lg4PMqk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Kfdu5gciz3sfclzPF5goJFq5M1hBei4/BTEmBEqoe5lTjaMsTJM61bNLkVBd+rbohsEOZDR7IYdiDKBF59FKOxIcf9JqUcf57E+T3GUvGXRAAETWetuiQCLtq+1fQQaAwjZQvH9FQEx7BtUHADqlq39Oidbm+3jLga1rA+TqfWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UKWp+Ai9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pM5H+2d7; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UKWp+Ai9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pM5H+2d7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1706164486; x=1737700486;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=oW9Lgps/dLQrMQykRI4NLrP4Dm3a6fFxavM0lg4PMqk=;
  b=UKWp+Ai9cs5gM3C/jnbIb+OIicCpqsaTV4znOHVr+48T5f0zqnf895ef
   Llk0CAaRZRy5P7HWjVLkbrEoF1oLuxgMIq/ziw9OowJuZLL9KknZ29I+9
   sktAUVH9zgnJGisJLVpA0oudXrP3MzafNoMl0IrAAYsz1Ttud7mSGmWhR
   tLwqiqWYAtY72mBDeDe0MXOzTYzkHNWO420a5RpsryTTlstrx13XuK3PK
   D1AS6Az7/7MlwU0W4N7zt58VGpEnWbMPeX3/JbUFEqEWGe1DS/Ed3TJNC
   EdSd0wxzX0L1ep5xjX0upiJf2WUkqZ3z9N2Yjhy4GEw6yVJh80bVTVQm2
   A==;
X-CSE-ConnectionGUID: AsWyeEIdTMGUCZNgNrUu6w==
X-CSE-MsgGUID: r5Taaen0TVK8w7Puu87FQw==
X-IronPort-AV: E=Sophos;i="6.05,216,1701100800"; 
   d="scan'208";a="7640379"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2024 14:34:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZBXKBs2PztQkPzpwylIta1SXt650FCgoX4JoG6eHo+J7e25cHAZwEQl/9mTVUBzY6HD4dLTZAkGGX7SDsY1ab6CB46r8Cw0zJ1GmNQyuRFi2n633CZxq5N0uAOtcLi9MMFB5+zlKsVVMmFlRqW4Lne3EIAFUaLPgqGvwcOgMZTzyzlRCmAUfrUqU/8MKC0c7tidCluijLaouyzU7bTzHbThDXM7FWGvCUcxxot2ZM4YkXi/jBMx8W3JQFg1oHp/6w/du2LezhuG8Fb9RKPkUfDFPumE01JqqRC5zq4ZbOrt2wrZsqb3JykNW42ov+PDZczQFowiq+EAc54Jxrv+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uc3yS/ByiEp/o3hycHMdtu9K3bVbE7euzRWVybMFnA=;
 b=BO20eVxpLKWGwrz8zhM/dYL1Ac1R6urccPEXuHfKb184DLnW/dytJZ0IRR9td9ZCQKuLOizvy9F7E2KhwESlUxnCHDvkulfMQlu3SSWa+oocI1sQM+aWaCehWrwVpy2NdiBaC2h4XDJW7t08OzLD8tluXj6QT9HWTuzdjoTCtgZyIAoxavOzpNcvGzdsXiXWVwZIVRTz6thlVHtsH1PsbKgrYcWAZ4e4jXNGlUusKosWhu0WUUAzY7wZtyrUqLhfOR2upy483GaZB5fxA5R2h2NtaS7h1d6AxxhrlHUxHIDv2UmEm4MjKkuoiwPxPBi0CJB0F57tqu1+moYgFZhVQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uc3yS/ByiEp/o3hycHMdtu9K3bVbE7euzRWVybMFnA=;
 b=pM5H+2d71BLEEWJPQCVR7w3770ZJH3v3gUuy79RcGel4c+LMwmcuMt3oCOxzO3m0w2VfLVsZmKFrA0bDCvwcfOiuwx/DKl1dS7/QvdKH4yQ6b4i6hQOl4EEd++d8/GJIoueGMF9uG6g9VF9pqyXFyaFBBb2lLzlQsZbnKSnSmnw=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH0PR04MB7208.namprd04.prod.outlook.com (2603:10b6:510:b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.22; Thu, 25 Jan 2024 06:34:41 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::25d0:1445:7392:e814]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::25d0:1445:7392:e814%7]) with mapi id 15.20.7228.023; Thu, 25 Jan 2024
 06:34:41 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.8-rc1 kernel
Thread-Topic: blktests failures with v6.8-rc1 kernel
Thread-Index: AQHaT1iTzSaxRkeHd0KucenPxbdjIg==
Date: Thu, 25 Jan 2024 06:34:40 +0000
Message-ID: <44i4y3fyqcz6k2pmum6toqylc2lvveb7x37ngskzfof52hoi2r@vxdxdnmggbj5>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH0PR04MB7208:EE_
x-ms-office365-filtering-correlation-id: ecf78aaf-ae84-4803-b4ae-08dc1d6fb64b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ANUVVDn0eNaiedyviMSAs0K1Ra8aYrK24QXPNzGOvw295jVAg3Zll8EQgiE6i3ax4hGzvGcUO0WoOwbRiUUFgqw0BXPYWeGkM79qumYX6KwL5cNEkIXmmvfmVtcAKSP0LqOW9LOGDbnWdE3H+UpDj0003D6vVWDWJ0GfoMqvG01znnpRQimndWWmr3trkQMwp8ntOYFPrTmnN2rRF5oauBLVobtBrv9MrDSJG7AY7vjErZuYcnWM1a0lRUB6RhOeQiZwrc+ZC41qa+k0l37iKSmLFlFwQakvg7DXYc9M0ZgtO92ziIta3R2iMXl62AYq9GOtR9z/ztfHlpi1L2iDvJWzi553y3UzInJfFnC+I40UZCtMEbT2Y6kkP9SZnuCt5pg8qEk15LuXux5LLzfGOZDz8RoXGK237jegIhwtdWs4dBCfmAaQEPtngPxxhF54h4wge8HrraSD2x84dRQv39pgPHRqa2D51HVhkH38Cn+GwlJowzCxvGNi3XMriOY3xJmV404pl4xCvro79nCWJvz3IVgmj/vzs49McXhfwtkjO7O54rpEd57SzCg3TD1Cnr00aAmHrEpPsTa86vEOIq9BHLmardLhvaAboY/Ddi26bhtgfB/28o6Xnqt1wefB83V/sP9FSCb5CFFkYc0rgxL+W2/yWZymthsgaRB/E3+gX8UekRPkGuVGc+GzK9UG
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(396003)(346002)(366004)(39860400002)(136003)(230922051799003)(230173577357003)(230273577357003)(451199024)(1800799012)(186009)(64100799003)(2906002)(33716001)(44832011)(5660300002)(26005)(86362001)(38100700002)(82960400001)(38070700009)(478600001)(83380400001)(966005)(6506007)(41300700001)(6486002)(9686003)(6512007)(122000001)(71200400001)(66946007)(66556008)(66476007)(66446008)(64756008)(8936002)(8676002)(316002)(76116006)(91956017)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?VAN5HuD3pk88W6AbyXoJAEidqtqm7oLyrUyJlFXaEiJuvGaEZpsnxi5NwikP?=
 =?us-ascii?Q?LXs4X+q3LvyQIDRkdbq9quqGxp7dw/y21Zl20Zha/BEeViKlJDnp49d+QbIx?=
 =?us-ascii?Q?dRsIRE3qL6ClG6WqQKSQVd/Y+1J7Eb1krA2xHYgpRAo4ER9WlMn6pwoscFkg?=
 =?us-ascii?Q?W9RNqrz6ZCA0MOgltk/Y/zLis9KsbSUrV4HWCOsqRWGWsb5+5VKoDzDLgES6?=
 =?us-ascii?Q?JDDf0fukT4TKSfoGjn3XpfW7xpDDlueXutU3m6b7sfQf6FMSptb4gSRxStN0?=
 =?us-ascii?Q?Rw/+671dayMsWZwfk7tuhz+rY3J2BKjzAhyx59gC+nsxlIE2O1mjat+F+4pr?=
 =?us-ascii?Q?OTqG2eniJu1zuCvhqDoFUI0JmZQUPyaYkFaln+iHN1eA6QpZVHcnI3geD+eN?=
 =?us-ascii?Q?WapmIfWiprbw3LIYArdM8UIprl9yai1SENfyyQPROyx32TNiiDqVUGOCP2S1?=
 =?us-ascii?Q?xZJ0uKn9k3U6AsC/TpGeKv8DopmyFK4iINluCqk0y+Z419IrWjMzSQYUqRZf?=
 =?us-ascii?Q?/gtlIHKrrXl5mOpOL0D0NvY1zko0bM0YkjV5Tz1x5jKrjcb/pl7azH1d5Q9g?=
 =?us-ascii?Q?RSlwz7NXw6iCZEzFmZafYCXU5AkwfpVqqwLPUO6eLsHsBa/TBvqPqCfuGney?=
 =?us-ascii?Q?v5EoTo+QZwFT+YksEMSazSB0IqEBL7Fq/CKCqIevDrHwy72sbX+QLGCcPEw9?=
 =?us-ascii?Q?BCS6XijMBjWl5zu4PRVKAn5FdxyFg3LJEP1S5FXV1FVYgi6WyQFAGusTvw19?=
 =?us-ascii?Q?ZV9er1ZSCpVfF6Q3rBtKGbtzM7slU2LB/FjKxeeEvTS2E7fbMTydGRiin1Bp?=
 =?us-ascii?Q?MfghyWDwH7wXcsxO1yZNeKNIy0Eg23C0UpAHQ77d/XCGDxxMirvlLMmjjjGi?=
 =?us-ascii?Q?e0k4iPTpc+f0r4TDjc6WIaBIF1DkBuy5WtZGuBzBzwXUijTK33dKf6d3zdKG?=
 =?us-ascii?Q?ngwJVvk5k06YvMZ8+WwqOlL9EHpPEojjnFpQs6Rimgzk0zdlMbuvXlrvc/YT?=
 =?us-ascii?Q?d5wtOkNA6WJjNgMKpcBXnsMGtI0q9DSPbnMBu9SWttKR4lG/xpU3gM8TpyyY?=
 =?us-ascii?Q?IfSzpKQLwOsPwax3DbZJzeLpaqMfE37LGGXbdram48SyANNnF8Hawi524zE7?=
 =?us-ascii?Q?si35IW6EkzM8bfRU6ppdFIpYmLctPMcYW3XRq2oGfYs85gjV5iU9UegObRsK?=
 =?us-ascii?Q?5Nd1pAMLFygx5XBvPg9OtRsATz16CSDibu0VKerkewVvS83U9kk5BUcej+Lm?=
 =?us-ascii?Q?kqgR/I6zg9qpKPeqadaqvuxm9fTIDFVFbZIZ7nHk0i+JSsr9Pbz3GWl/cBZq?=
 =?us-ascii?Q?H1A2UpgSIMyZKfCrn/Vw7Hat5mJerdzhlmBYjLZIMjx/5W86wyz6LSpQVoNw?=
 =?us-ascii?Q?cYpItxyT5YFvIvlQOLoXZlHfh9lz2lhjW96pqpiUjC/d725wCav4AVcg8Fjo?=
 =?us-ascii?Q?BSJLLZiJ+rV3cwefHnTWJZEmr/YkkF3lJQ7XyMxB1RhW9pzg76EvAgqXhLlo?=
 =?us-ascii?Q?2dd8IhcZ597VNeX7/4f13PRs5OgIA+bgqzxm2p5CuAfAcgDh5BzvJP4qWrty?=
 =?us-ascii?Q?qh1qmJAFbbNmxsqxrZfhT9gp9s7euzG3SJemjeEbkhgRWRWoBgNcBZH0G1lb?=
 =?us-ascii?Q?wah/HaZzi6ASv3AQhFe4uWI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <594A879331BC174BB0757FA8835CC376@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/wYvLbxIT8Q6s9UztlDuaAUC3VovR/a2KnZSIBM8GLQ4FcP0J0/Td8iLwab8xcJ6Zg07X/a8Xmxcso4Zfe4iqrd5ILIMYi0LcJ07ySDKKT9I3UWhjYRAhDOjH7secBpPQcS4OavUw2PuluU7SjKUTRoMjOlldgRtm6iuCggO0nGJYAb0q8PQLWbhud+d3zIMwWkxDkqAQfAlFpznUzj8HapSHF90RdDTt4VdED3XLusvbB+iKPJzv/pc9bn9v2S/42a8jwtRIW1aWXFfyLstgeDJkuoRfDlYfCWorR4l+8CpdRsbfMI63IJqX0WBRiLiS+QHoe1EddEAZ/Vikr8TpPAWFlewgj/1qyk8P/sfij2v7jrOR1qVbK7tcObyYy9mVdO0X3qKCIbbPhv9Aiu8IOxabsFG2p6NQaH7GiCCIcyOS5IVvyPXwmG9OyyBZ9oRpZr+VpYiGw695w23ybkL1wErUz9ObzBkIBCDrfBfHK7mW4mbAkvSy2bpYxCDH/3a12YDfNzTejQQ1bGpSwRUlJ0aGXdDDOCjdX6SdjRwIeLAFIeOhV49q4RXSqslnNb2Q4Hssb1RpvMSjJu5UBkxy7fpSD/uDluucjHlOXhk7rIJol+y52TZ1mS7/lnzXVn9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf78aaf-ae84-4803-b4ae-08dc1d6fb64b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2024 06:34:41.3952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YWGASFpkY5pEkiIrh5jd7XgOCd0uT1BkVfpWYqL4f9Q57JPl9jFEWr9TLcynt6cjY3KeVrrEcSh7HJ7Zcy6ADpxsk3iI5cgYgRZNI1BvOFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7208

Hi all,

I ran the latest blktests (git hash: 4f6b3fc593bf) with the v6.8-rc1 kernel=
.
I observed three failures below, which are known for months.

Compared with the v6.7 kernel [1], there is no new failure. Also, the failu=
re of
nvme/003 is no longer observed :) Thank you for the fix.

[1] https://lore.kernel.org/linux-block/74ytefsd7byav2bs5q3lr4yj7v3yfmbe4bv=
wo233bri7ufl7xe@btts3u37s4op/

List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: nvme/* (fc transport)
#3: srp/002, 011 (rdma_rxe driver)

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

#2: nvme/* (fc transport)

   With the trtype=3Dfc configuration, tests run on the nvme test group han=
g.
   Daniel is driving fix work.

#3: srp/002, 011 (rdma_rxe driver)

   Test process hang is observed occasionally. Reported to the relevant mai=
ling
   lists in Aug/2023 [4]. Blktests was modified to change the default drive=
r
   from rdma_rxe to siw to avoid impacts on blktests users. The root cause =
is
   not yet understood.

   [4] https://lore.kernel.org/linux-rdma/18a3ae8c-145b-4c7f-a8f5-67840feeb=
98c@acm.org/T/#mee9882c2cfd0cfff33caa04e75418576f4c7a789=
