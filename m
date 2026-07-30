Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020092.outbound.protection.outlook.com [52.101.85.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606303793D5;
	Thu, 30 Jul 2026 20:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785443594; cv=fail; b=dJkeF0Cquet6UhA79rhgy2aB+MfhDMyjJ+X/wbuHUtVq0oUuA+b5mhuQULEE5RTApf0W3OtmsBN+JY5NjxRUsJqdgkIAYVUAMKHElyJeofDQTfbi5EP+2S7Q6o9tD3gsbaAyXlKpNRyK4xfXmpk1qyaQqB7fmLlve7LprfOUM9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785443594; c=relaxed/simple;
	bh=GkIT42zWVRqyKYxe5m/RwrSWmGrVVgZNaWxMih9cnmI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S/sZsR4V892sQ3pcygYbCAk4bgb1VhjL59i6TveidlldmzArTsZ/Ji/yXv4/cHEtC/k4dcztE71kLin2Y6qUSunrV5PJYiTKDFqeJALjnIAQPxEXtDmLpBfXtqENc8X16VMvnvtQ43FRgzxLNU0SI57xA3me2PXl1GDV3K453mE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=NEd7wd80; arc=fail smtp.client-ip=52.101.85.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="NEd7wd80"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPreCyD9tB5kbZEPhLSp5vCagjyA8+uTS6jR8dCOQbW3bDIkijTdBF5+Dg2t3aClz1EP0KLyH5m/SSC2zhjSt1GTEpBAl/9sK2QWzSDA6KAzhgUL7bm8kYBAmxacCpZfLksqI0UwdXX9189iAS/4MjVoJK84TE0reSPWhVQ1A1mcqH3XljA6OYNNGF2j49Ea9a20rctkC+et7P07G/Ds9o1uC94xOW1eD6Y68OagKN6N6IYeFKF4wNSMtNO/dT3ZWEGEmRGeIqI1qK4arJVKBD9BxSj1Dyy3tHwSytbspYjthgwOzaorzV1Pqq8gqrmAaUoTHl7JA7tlILHe1DPwhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UOqOy1R1gkSJ2ohJca6naY2kCl3Dg7l3Npz4h7qTBE=;
 b=B8VOnzAgQe7AfXJVBOtFKmvbHQp/By2Riy9la9KC5UdiXbj70kPBRD5yVZeS7R2fAMjUJH+B/QirEgsDFsifm75YJubdSO5A9McHHRXlX/VcXaiX4JVUaumxP4N7zdEmMAkgC8gnuHomBKhgnhS8xAaW5p2Nx+PqMBXt782Ehaug7yyBOyKsNJHMTegJsMBz0QkUbI3yGVl0oMb3cfnPyOpeSB0+FiSZ6p9u2/4NuHHI5Kh48cfBqihbgVmSgcNe7To5+dvPeHhb9ChnZ6A5IwTmkPd33zNBR38zohKmSwKqtOByBLNp+di8KJgydm1x2ZKSpP0Zb09gUTu20wheIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UOqOy1R1gkSJ2ohJca6naY2kCl3Dg7l3Npz4h7qTBE=;
 b=NEd7wd80MPPRn/0oYFQLb1zJPBvhla8FJBPFcxaTlWY9K3/wCa7jfLxpntkT6tUu4Sp+tvypkJVcSmQ6ydOq7v9Er6vueCvpzbLqQTJA6Sz3edHoaR0wRtFhm61B+B+t6wWv6fLK0BiUP3XqP4k+xKH/bA9VunfbMCSiWybrsCA=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6875.namprd21.prod.outlook.com (2603:10b6:806:4a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.4; Thu, 30 Jul
 2026 20:32:59 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0292.009; Thu, 30 Jul 2026
 20:32:59 +0000
From: Long Li <longli@microsoft.com>
To: "mhklinux@outlook.com" <mhklinux@outlook.com>, KY Srinivasan
	<kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
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
Subject: RE: [EXTERNAL] [PATCH 0/6] Remove support for Windows Server
 2012/2012R2 & Win8/Win8.1 versions of Hyper-V
Thread-Topic: [EXTERNAL] [PATCH 0/6] Remove support for Windows Server
 2012/2012R2 & Win8/Win8.1 versions of Hyper-V
Thread-Index: AQHdIFQqRGj7TkvvckWVjqDGVKcFOLaGgguw
Date: Thu, 30 Jul 2026 20:32:59 +0000
Message-ID:
 <SA1PR21MB6683DC244AFD27148A0AA213CEC92@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260730184846.3165-1-mhklkml@zohomail.com>
In-Reply-To: <20260730184846.3165-1-mhklkml@zohomail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d419405b-3d6f-4803-9a61-bcbca652148c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-30T20:23:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6875:EE_
x-ms-office365-filtering-correlation-id: 848b87e5-6eef-40ab-08f8-08deee79bebd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|22082099003|18002099003|56012099006|3023799007|7146999003|921020|38070700021|11063799006|10067099003;
x-microsoft-antispam-message-info:
 /oSbzXtpFjR25B34EZ3NWOq/8+lr1viW+X31bpNYgDCoI30QgnhAoW4N7CRK0AxbgEYV+fU90vAq4EC+fyKrNduUljXrbGft+E5fWVTtgFcaN4Qy/bTUCZ2EQXG70jAuupJMAIR7BvcScxzYT7yBXA+Z69Sz2VWk4dQZS1eQvUx3X/bhe5X9wWgbHzgJH8rr40XZxxXYV6dl4D/wwhVZNgVr0G3MlfGpORRnP09DywK1VISCPpFu435o6876jKma/Ta/M0O4I0xwApggcCFCyhrqcfkN10QYx9UA8rqX2L2YUnKNrmu0s6meiIDcaLnqX5FGi42x6Yj8S0hG1fx2P/R+EOAHAV2VVme/pzENa6cixyvbFfnlDOB0V/QOighWzvSI++INKUrKZlBA3XZWcKhUhP1vaFASLI9UeIo74S+e5yK8XJpLiddKoQkCMdLhpttdAg4kp4kK+KlkyG9CIHC7y4DJpcg6NuiW0bLbGQlNjuLOOdQ6rsT577DHGdTR20ZiHdC6swD0RFFbAYskEYns7yh2KttVow1DWXEyfzlf+OWnIEIe9aC6UqdC975V2DlhVHVNUKAdWQI1B0vh7yUrYDM6K96NxfelSl2H4Xhbyfy/jmcSlfqP6gDc8D9rlaoL1dOaUKNA//fGrTPoNbXI61P4t5RkfMCibpVNd9WPDjlS5t21hpn8MF/HvvucN8llqNRATZaVY3nDQgm2q3i80FJS9VzI5pBWLPvFwyDtYS4jbv0LitINFa/OTku4
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(3023799007)(7146999003)(921020)(38070700021)(11063799006)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?WxFu7pS0jv+InVlkABy+5fkh1BE3YYCyIDV/+WVvStrQaft5w1mU8km5UZgD?=
 =?us-ascii?Q?sKnGBcfAXVZXVoeqfWV/kE0HqI4oBeqa0kQcAbSWxDoSicIm9bKhFhx7nav3?=
 =?us-ascii?Q?Pbv0vq6CXaqcS2pfbkMNnCeAQkTem1Vj2u6VgZiuDEp0LNkLmNOuHMdvItGU?=
 =?us-ascii?Q?Gr2kBXJrCjjIMzWtoi27HXfJM+Ixdgxuf2pjvpKNo3v9xqZfS7fNaVsWq8B0?=
 =?us-ascii?Q?kSxTHZb7EqmA9crBfmg8okihsi8QwS9FO01O8IyGV4NHHDBZ4ZbqtEhJk2AA?=
 =?us-ascii?Q?r/FQ1ic9uYPpX3IeSS3EOZEtp2YtnH6cWyC6WbHMgpqahyratdONs7ezfGNr?=
 =?us-ascii?Q?t+ybyRFW4ZtgHPnFetAh2rW2+sOT72pfMbZQld/C0yOAEOqTFGp9yOf0Np1P?=
 =?us-ascii?Q?4ubeHJk1OZinAO9zEu6ULWe/m+ZKYY9/gY0ezQH6/a4lGGsetd3Qckk7HF56?=
 =?us-ascii?Q?OBtcq07N+L3W6zcjpPttgrytpPYIN/4BjfaKVujRKP2l0pmvWGWwYGqumiht?=
 =?us-ascii?Q?0unruBxK765PtTO7QHiXZxlnzMobRNoHjlpqlLGuB38bxmbBIR1RTbzmr80G?=
 =?us-ascii?Q?Zc8lMS/GhxeIyfkln5teS48wZgU7iQw3LV1QkOviEnzbtFrbzirNJEJvCQoy?=
 =?us-ascii?Q?56JABBL0ue2Um/WB4pIyEcWRwBO0FTf62E29v/W9RuJik+Cin9aU/YB5PwbS?=
 =?us-ascii?Q?9DBcp2jdh5kx5GKTOTKSH4FUL4V6/In8SpXrJxSwKyKC54f2vIt5+aI4DGAa?=
 =?us-ascii?Q?sSNE2SWIKDtIs1oN7gZjCWa0yWvnIs+3CSqGzzMPKWUBc5OEUKL+4S0Q8B53?=
 =?us-ascii?Q?e7tRsRV0klY7yvoiQT2FxegpQeBrLxBFabPsg3e1ai7/zx+IDn6+7Co56vIz?=
 =?us-ascii?Q?bOy4LMBo/bUK/1k922kvClaeNtzzs5n3hm6Jbd89yywTC2T5+HTxTKB37pvP?=
 =?us-ascii?Q?eNqneVtv1xN2salOjqO/yjez0m+q9+xRmihdG42EVjPcX1W/gWHo1tG0+bNk?=
 =?us-ascii?Q?70z4BaZLptEHH5Z4gyOqv1gtXIjhMB6vNDx7Dbswp005VWXjDR91OMd+tktz?=
 =?us-ascii?Q?RzYubalaD+JCXpI0HBgzDjVRco3arV916/IjeOa/J9s2vZwgNm7e818EFwV5?=
 =?us-ascii?Q?J2bRhalwxk+yW2LHIXf/JRowUMa6r3P3hRNfAF2z/X/uND18JaGt+IIGeBjA?=
 =?us-ascii?Q?hqqxmibUxLWZ4O+YAGf62ixDAcLQMVZcdP7qe2Hwp9ivSY/YmqpbsT7HbJO+?=
 =?us-ascii?Q?ggdQXWsTJlnvj+F07Ji5IPg0T9eMXDuCjA0ncMp85oaFSi9SPW0FM/t9645p?=
 =?us-ascii?Q?qkef1wEJxkySW4C2FLx6bohmxkFR8pO9uTBw5Y06Ey6h84qSv+ciYRPdoJXr?=
 =?us-ascii?Q?J3Np0XFeNyTcVLmFh1Rp05QfRA9w7Gp1NUPLaZCjdZAyT0+b46i6wjipaifa?=
 =?us-ascii?Q?+Kv1Wp2bb6BgdzUaAMDCIYT2XlL1Vo0eOhWbHYTa2Pm75ID+5iCEK1AgMImA?=
 =?us-ascii?Q?3AJLvY1q5OJX2Yf4bm5l152Xm910WXWX2cPK3BJk8xtT/HkLbNP1eA61VWLk?=
 =?us-ascii?Q?SPMGqElWpkPZhQWoMIKUAwwxj0FrFejddS0MB7jJQ+GK9xl45MVXNUP71DV/?=
 =?us-ascii?Q?9cHPRc5fzMYKe1SbrkhRHCsscRrfvRPL0rbDYcS3z6v1G357qRcT6wdEr3mj?=
 =?us-ascii?Q?jnx2XLuSQYD4DpDeVNDnR1AqA0cKvEhcDhj5ftqFpirs8STR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB6683.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 848b87e5-6eef-40ab-08f8-08deee79bebd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2026 20:32:59.1150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6DwWpca0FXX3on7cCo6jWpB+IxzqJ5UQel6nqv3sZeaCpOwK7ps3QzQogn5PfEiAwhmToB18Axlx+BnBLpDD/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6875

>=20
> From: Michael Kelley <mhklinux@outlook.com>
>=20
> Linux code for running as a Hyper-V guest includes special cases for runn=
ing on
> Hyper-V in WS2012/2012R2 and Windows 8/8.1. These versions were initially
> released 14 years ago, and official support ended in 2023 (unless a custo=
mer
> has contracted for extended security updates). Given the release of subse=
quent
> versions with improved functionality, there's no need to continue to supp=
ort the
> latest Linux kernels on these versions of Hyper-V. If someone is running =
Linux on
> one of these older Hyper-V versions and doesn't want to upgrade, they can
> continue to do so as presumably they don't want upgrade the Linux version
> either.

This patch set has significant implication for customer running older Hyper=
-V versions. There are probably a large number out there.

Is this clearly communicated to all the customers in the field? Is there a =
link from official Microsoft statements on support statement of this:
"they can continue to do so as presumably they don't want upgrade the Linux=
 version either."

Please point to the statement that they can't upgrade Linux. A link in the =
commit message will be helpful.

Thanks,
Long

>=20
> Simplify Linux code by removing special cases for running on these old ve=
rsions
> of Hyper-V. This includes removing the negotiation of the VMBus protocol
> versions for WS2012/Win8, and the special case code based on those VMBus
> protocol versions. Changes are in the core VMBus code and several drivers=
 for
> synthetic VMBus devices.
>=20
> Some VMBus drivers have device-specific protocols with the Hyper-V host.
> Further simplify the code by removing the use of protocol versions that a=
re
> specific to WS2012/Win8 and earlier.
>=20
> Finally, the WS2012/Win8 versions of Hyper-V were the last to use message=
s to
> deliver synthetic timer interrupts. Starting in WS2016/Win10, stimer inte=
rrupts
> are delivered to their own assigned interrupt vector (called "Direct Mode=
"). So
> remove the code for handling timer interrupts delivered as messages. This
> removal has a broader benefit in removing a key blocker to disentangling
> VMBus code (which handles the messages) and stimer code, as they should b=
e
> independent of each other. The final disentangling will come as a follow-=
on
> patch set.
>=20
> Testing:
> * VM on local Hyper-V on up-to-date Windows 11
> * Added temp debug code to suppress Direct Mode enumeration. Fallback
>   to LAPIC timer worked as expected (x86/x64 only)
> * Azure VM DC16eds v6: TDX CoCo VM with HvLite paravisor
> * Azure VM DC16ads v6: SEV-SNP VM with an older paravisor
> * Azure VM D16alds_v7: normal AMD x86 VM with HvLite paravisor
> * Azure VM D16plds v6: normal ARM64 VM with MSFT Cobalt processor
> * Not tested running in VTL2
>=20
> There's no specific urgency to removing the special case code for
> WS2012/Win8, so if the broader Linux kernel community surfaces a reason w=
hy
> this clean-up should not be done now, we can wait.
> But I think we want to eventually stop carrying around this extra baggage=
, and
> based on discussions with the Hyper-V team within Microsoft, we're past t=
he
> point that it has any value.
>=20
> Michael Kelley (6):
>   Drivers: hv: Remove support for WS2012/2012R2 & Win8/8.1 version of
>     Hyper-V
>   hv_sock: Remove check for old Hyper-V hosts
>   hv_netvsc: Remove GPADL teardown special case for old Hyper-V hosts
>   drm_hyperv: Remove support for synth video protocol of old Hyper-V
>     hosts
>   scsi: storvsc: Remove support for storvsc protocol of old Hyper-V
>     hosts
>   clocksource: hyper-v: Remove support for stimer interrupts in message
>     mode
>=20
>  arch/x86/hyperv/hv_init.c                 |  17 +--
>  arch/x86/kernel/cpu/mshyperv.c            |   4 +-
>  drivers/clocksource/hyperv_timer.c        | 150 +++-------------------
>  drivers/gpu/drm/hyperv/hyperv_drm_proto.c |  33 ++---
>  drivers/hv/channel_mgmt.c                 |   4 -
>  drivers/hv/connection.c                   |   8 +-
>  drivers/hv/hv.c                           |   4 -
>  drivers/hv/hv_balloon.c                   |  36 +++---
>  drivers/hv/hv_snapshot.c                  |   5 -
>  drivers/hv/vmbus_drv.c                    |  10 +-
>  drivers/net/hyperv/netvsc.c               |  20 +--
>  drivers/scsi/storvsc_drv.c                |  53 ++------
>  include/clocksource/hyperv_timer.h        |   6 -
>  include/linux/hyperv.h                    |   5 +-
>  net/vmw_vsock/hyperv_transport.c          |   3 -
>  15 files changed, 76 insertions(+), 282 deletions(-)
>=20
> --
> 2.25.1

