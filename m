Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E122C171BB;
	Sun,  6 Sep 2026 08:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.152.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788682101; cv=fail; b=YY9MAFmd0hoBnAx4y9b0nizDijQUtCOxzAfra3t52ik1uyTn3GY6+hpcxoxIQahL4duHHXMvAqC9HGVOhwKpssFAv9WStq9941qFTvuPnY7hRBcEsBDwyaRhvWBKqtQhhEgyBdT0zeo1zKufxcXs1SRA6QTPqnLC+JCVYBia6cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788682101; c=relaxed/simple;
	bh=tmlPyshBaJyta4CumNq72zZKpuB0t09JkRp2lWbQ0SU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iXmZCL5g7ks3rTbCPM2ZdY1tGTFncupl81/73idY4tc5s3S85gzNhRo+CdLaBQSaPuWesL/qKsC2uyEXBq/O96r7cNl3qLqLfr21Vda1k+Nf/IjeIvjXuSA+RCT2voyHLHXoFtDv0r4VLJhmIVW0VGluptAF8Fmcb2BUjCNFxXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=a3reMo80; arc=fail smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="a3reMo80"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1788682100; x=1820218100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tmlPyshBaJyta4CumNq72zZKpuB0t09JkRp2lWbQ0SU=;
  b=a3reMo80MD14D/9leiL6uMC9KxeXvyEe9L9TNcfAUwzwz6sNA4mR8Vwv
   1jeaTnsDoWExkImYqYQZ9ODi+yp94ggWIvMojFdgtqSal/4MF+XXbZYvv
   ko7jLKs51zvfFcjm/XdEFrIdC2/x/oLgGhxz9DKyK9SvkLRI8MfasC2rS
   8AOPqumeuaMnMC66iXiNsqVJ6SZkGRP2qZ8kKsluSvPFE5qpOnCTpOjiC
   KiM95MI2o61m/wo+jXs9hqvE4jWLBJ14aZDNjBfCFrdFDfsKGPUlCP9Mj
   R44p8+G/EPSvp5RnCFz0mQOMMqYyHoOrF6YTK41WLgEeCMFc/WaI/KJ+e
   A==;
X-CSE-ConnectionGUID: BvacZw0nRr6rx1t2zFA43w==
X-CSE-MsgGUID: B2nQu1PxRUSMHaN5Reqrgg==
X-IronPort-RemoteIP: 40.107.208.120
X-IronPort-MID: 29565208
X-IronPort-Reputation: None
X-IronPort-Listener: OutgoingMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
Received: from mail-westus3azon11021120.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.120])
  by ob1.hc6817-7.iphmx.com with ESMTP; 06 Sep 2026 01:08:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+E6qr1Hevp5+pYWFURmS6ym3pBF1Vry/j62xcg0A8FDZyBOb8Ocppr5TNVEquFBRFnmsykMvCNNCLcczJIOxjR0ybj11TzvCtTJkS35LBZ3KhK2MIYWR8hV6tY6e4lasdPygbuVfbvU5ZZyoJSlSSMijMqhWvYoz9nqInNPeb5xUdGKEGxYc3uRtWcPYlJTrOFUfJZxwUfk2WXOkTGxa0al74lYTPyBUyX2TNaLPuZZvs9bTrbjdnptPHS4axbjV7pROSOBGE1fAyrxPZC5D6QpQDYZDdhfAzQLLtZIaz91BQHqAs+5ZfsQEVL4oiwLoApOKPBgCRy5l/GjcFj3tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VlTwdVQLGQfcnykMidu0AaLMZ3aTULFKVdLCfDdO6HY=;
 b=IuElIjwDIDpsFrtIqjlfThDjlQLNcr8d7l1ScJk66uiQXIZwyOARaqLugoGoxUIoLRP8VAzWuvrUd4wBWz6fcFrm4YLJ28oyDSi7vbHet7HGdBtF1BUqXIHn+4nPnE37yiS9y9RM3PQWJVJUCumRiouKIH+7wahzxUCDNpZ4t8Aa0krs1kpVrjzw/idQP5doV1wyILk0IAw9OSjrpAFido0gBVzoBb0nNpsJblvmNiNPYWEa70PNOFfYcIEQkUF5b44N+qV2QIvI8OD7TJchgzjfqW+8Ym/goJAe7H9fOPYQSuDWJrWLAgqjgqALdYJ8SMWt5UC9MCQvOO78YYNWgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from DS1PR16MB6753.namprd16.prod.outlook.com (2603:10b6:8:1ec::5) by
 EA2PR16MB6298.namprd16.prod.outlook.com (2603:10b6:303:251::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 08:08:16 +0000
Received: from DS1PR16MB6753.namprd16.prod.outlook.com
 ([fe80::72d7:97b5:4539:a90]) by DS1PR16MB6753.namprd16.prod.outlook.com
 ([fe80::72d7:97b5:4539:a90%5]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 08:08:15 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bean Huo <beanhuo@iokpp.de>, MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi
	<cw00.choi@samsung.com>, "Martin K . Petersen" <mkp@kernel.org>, "James E . J
 . Bottomley" <James.Bottomley@HansenPartnership.com>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche
	<bvanassche@acm.org>, Jie Zhan <zhanjie9@hisilicon.com>, Krzysztof Kozlowski
	<krzk@kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] devfreq: check the get_cur_freq() return value and
 use it in ufshcd
Thread-Topic: [PATCH 0/3] devfreq: check the get_cur_freq() return value and
 use it in ufshcd
Thread-Index: AQHdOUktBRAI7WjgiUuJ6XA+5MLw07bBOsTg
Date: Sun, 6 Sep 2026 08:08:15 +0000
Message-ID:
 <DS1PR16MB675360A4866B9F6568D74179E5B32@DS1PR16MB6753.namprd16.prod.outlook.com>
References: <20260831130129.3979454-1-beanhuo@iokpp.de>
In-Reply-To: <20260831130129.3979454-1-beanhuo@iokpp.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS1PR16MB6753:EE_|EA2PR16MB6298:EE_
x-ms-office365-filtering-correlation-id: 52dbae05-0820-437b-d1a9-08df0bee00f2
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|38070700021|10067099003|56012099006|11063799006|18002099003|22082099003|55112099003;
x-microsoft-antispam-message-info:
 birK/HT53F9gtBtIftaWgGapfMdWH6oSHyV7dNdNdBdd0Nm056+ZOG0nEBG5JFkpUuOmvBwv4ILKTS1OHUrXCjgpMpAozWqOYeutqBFbqVdMDOcYJL0Bdo1AjNAQKC3BX4WhMvXq9kMeQ3RRTKZnKbhIgtD+aei2ybZkMhW5RX8KA2N56s8tNGMPokBNixpi8+edlblR+xLlvkujlyj2vOGzbPLX9zO22JRNhV0BK1X+hn8rcy6Pzg2PhY9FIuHFqf0m9bvdhsAu7bfJjVlNmmzsE0m9FeKQMe/qmsGMRd6xuDmpVAhDJ9U0jHRt+/y0kjTuFMCb/BSVc1aUE6uSgHRjloKNnREOqY+LiSkrQcUNd/PXKUEn9QoObbUjnRgXAEoLYtO4pz7mbfFHrAcnToqp6jME5fGVArvcpGxoV9zHPOLYSwvWQHj9nlXmhGQRBj7r6ojQ717RVT+vFgSEAETKhFhZREseT3tvI4ZJeR7mAfekwIlXENtV0PrX9DbTZmA3vIwWFk0C0vICZ0GUZtQpa0MtdTVRnqfMwv0g8kOrbDvw/o3uRO7Xf3Of7/HJVa3Tj5LvwAwaHuwo1/p0SNxj3oGL6S/k1T74YUVC7qgdC0Fouy8276nT1637s+inva/bjExau+tmSIn2bz8vbc7MNcyM2uzZdnPctidu7wXe2z55bHPVgeC3BTPEWdKkCaBvZlZErF3IPcWeZZvc+LkBmsfCZvEZ1Xyg23DLr3w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS1PR16MB6753.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(38070700021)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(55112099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?u/7Wv1hMUvpsiVrVYLJ/+IvqyTOM4NfpgW6Q2fiUfDKP8TxRthqdZ7iukMbZ?=
 =?us-ascii?Q?6hRKsUrjhp++7Ym6hMCDII4IDSPeeCOxVWkQJVtRWBlWRN8O3AUNzx9Y+wye?=
 =?us-ascii?Q?o2+l2IU6WOKojr3DzEwuFkFwTG05uumEJqys07v5XKFiYk7AIHhoVXdsfYI3?=
 =?us-ascii?Q?hiU3zpkz5pZpQ4E8cmcEkAHBbESGNiZHbiu4KdzVdX2fTjf55RoX8f5rvbIb?=
 =?us-ascii?Q?YVQVZcSlELUTevtyakAGTfNikeyJVwpihXLt6IT5IbmbdLHWeTIaCw/r+RQ6?=
 =?us-ascii?Q?fGjbmI2aUU1tVr6nQQf22L8LhWQSYqJSF/RrybdJYcRDsMQ6bIKVWgUefWQy?=
 =?us-ascii?Q?SKfls34h2iIprTzkK00X9Hn6u/r67hW4Se3Ab9gdCz7hAEb7Pr9Z6k44lUfY?=
 =?us-ascii?Q?OuD+wFECUseGx6MkCx0gLfsLKH8D1oVTnoWw1Lxl0HRjMTVgF+k1+kPqt5Zq?=
 =?us-ascii?Q?uTV3ZejBsYGK89cZQqnd+6E+vyujz4bGhMo4RLri2flXL0AIHpKvgQxfUWVy?=
 =?us-ascii?Q?7znrWJgpr3v9u8em4x7eMd0JQ1Kpn9XK3qo8pIobIVy3UHw0Hxjh9QijMckj?=
 =?us-ascii?Q?6r19l4GKo+1YJHCpTHakFoj/imEXmf/PBIhXOmurWx9t6R+3RWjBtvxF0bOr?=
 =?us-ascii?Q?MJy+jPJWAeD4NtPKqAIjhomTeclOHfSFCwvip6MfBf+loOXSctVZWnAhUX83?=
 =?us-ascii?Q?A55v8uuoYh+We2noKo6ZX06RXnErD2I0YX3xtrDVQwYv15yJR+ogtXfeyJuH?=
 =?us-ascii?Q?V7LtG0LAf4G0bQxQt1hEA88esVKFbhad4gMLuR1LUQEdTKFA7Q5nDuRre/YF?=
 =?us-ascii?Q?3weJh6s1qCPRa8jYTN8vgEDSNC4mdo5E08ktsD1s3H917O1cXJI2E5OuSeKZ?=
 =?us-ascii?Q?bVqR0gPgnbt4fsWMS6FJe3IdvviE5ZNI1p5aUvHpxKO6CaOCD4iQa4Q0K/n4?=
 =?us-ascii?Q?RbeL3B1XDcDDvHhPmOgOdckT94rgyOZCYSPU2FFVX03nG7rRtR55vNI6zm7P?=
 =?us-ascii?Q?ulieyz06UsbVkvHx7/qBtEoKpjFv1hLIigBCfE0261i3wEDVVnYi+oZ0M6FH?=
 =?us-ascii?Q?1AW802VBN5iwH7uR+sI69Ng7Rja18/HtTT5U7WatK4nIIf07i4gv0oktXkmK?=
 =?us-ascii?Q?PiS6OL2d8XTX45FHkchTW9GDmAoLlyfYfVEdoUGZ5z3cZB6GtK3KCZYA0aDd?=
 =?us-ascii?Q?pGdG1OdQcP2pz+5zwNuFoRCsUIBEmnWDYhAZn4U5c0dCMEcpfUOyviQvOhXA?=
 =?us-ascii?Q?3HqNAotq+wJv/sL6DW2hMygEGDIPqAr7vHi9HLjQ8FS94STEhsCTx9sYVlqR?=
 =?us-ascii?Q?NUeOfJnxax1LTh6UBUaOEkpQopYwM42nPnzDsopCQe5zKafcMRrp9G6cG0A3?=
 =?us-ascii?Q?oBE6tFwTe2SA/8/l/L5hwywckTyYRxPwtBTvd3wJrNvWIjAyqCVHCJAkygXI?=
 =?us-ascii?Q?/c8FvLEy/2s0dilUuZvlF/fznkYBLelSsZr7B4qiGoi9lIw5uX9iyGVuTo8F?=
 =?us-ascii?Q?yz3Ws2H7oeVypc+snF2tzo9Jm0UT8zduB3Rndq9OMyGJCkMfIfiX8QmdczQa?=
 =?us-ascii?Q?wtzInPuE2GJ8v3FQgXNigPAjuC9sah/PitznSAUF7A3+rdbrZ8W95TeTSRZw?=
 =?us-ascii?Q?ZUHNeJ8LlEXBsCfCsbZYW+zSxrQOYVWIYzqaI2X1Bq3jDnmdXUiTdCbti3a7?=
 =?us-ascii?Q?6cGfDfSlALxQZiaKXGDJN0nSlkyvS/+hWPcBdXrUCustdm+UmoamDKmjZmqc?=
 =?us-ascii?Q?cF8SAs+9Iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	HRJuS7qQ9e7HKYSLcKQ/Oi0miWaWZQPKrj300Ikz8hnbLf5GO5d4lNGR6vzR3k/3sZqCRccUWuZt1QNdUVjNOkoGX/GjQhVwan2kCC7CE71ilZ4EAF6ljdkSS5tPbVqaB1WpGJZmWlrm70OsO2qlMF3irso4FIxBxhNOH+SriKFekrmk4qRJI4+hoB9U5r7gW0b3A55xiEqnsNko6j9DLIKvr+iUPXaaKFdJ9GZRPXKwOD6B15ZdVGCVJcKvpgyE2Ta1tI9KAcpWrWEPsa84KaF60k8TQNpiGrmTCvM0tr2wFAANqWjF1f4kfIMR5ZvrHY3a0qY4e8DvLMO4XsyqWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4kKT7QFssO7zo00xe7D0epVOWvV//BEeFcPJN7LRu1nyxVsQ0c4171BcvQlfVSqioAuML3GUHMYsCAZOJDvwCm2ZsF2wlo0sqQyxC9GeEABFR4lGvPcH27RGs3PcKOqkBcSNmnIeUm6MELbtKUBdS3pDzdEL6vwiU9SkzUAmy0sBWiUFycy39hHIA5wCDHqNT+yZqtDsbHiDHogiM2ROT4y8ve0v7bekC7LjG3LrmoPECGx96yweZZ+F/xlVBle54ZbCPr87xILYWKojXVlvkexCkZ6ZGKKH9P4PpjITs8/3Z9fvnF+qQg29dv4lRYP0sYbr1E8CMx4XhJyfxgZfYTxZv2pacvLdSMkB+lzaNkpRsE3oikXE6Bmk1+GvIkx+gj0dVOnhDQbiqyf2YnAD4Bp9Xu3Kd7ruUuFvdhyG7YQhB/pkn9Cs771uZjKwfQQPG4+alVdRwntvPPtTzuSHnkijruaM5i2qBr1QJjUeHI9cCVxjh37IUZ+0Co5gq+RBXN2gfIriSTLtd5/2EDzcFyWpHNrzmA4eTBxwFQ0HJba2vWHKfo06ylZLSQhRpqXBYpzvO05DcOTPDR0plpmIDgkcRF1Q889nYMKwMdKZS1AAUFL4C91hREPAfMUhrKYFHoRdIsYLXqzzphUOXXSO0A==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS1PR16MB6753.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52dbae05-0820-437b-d1a9-08df0bee00f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2026 08:08:15.5797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 34nfum46KCAchZrfXO7H9UXP7Ty6ZmSCK7jKzFl1+bQL5+IfaA9goCsUbPAiUWdlmQnCCimFhjXgFc4+kga5Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA2PR16MB6298

> The devfreq core has three users of the optional ->get_cur_freq() callbac=
k.
> Two of them check the return value, the third one does not and passes an
> uninitialized frequency to the transition notifiers when the callback fai=
ls. Patch
> 1 fixes this.
>=20
> Patch 3 adds the callback to ufshcd. Without it the cur_freq attribute sh=
ows
> the last frequency the governor selected, which is wrong whenever the
> controller is scaled outside the governor, for example after writing
> 0 to clkscale_enable.
>=20
> The patches touch two subsystems. Patches 1 and 2 are for the devfreq tre=
e
> and patch 3 is for the SCSI tree. They do not depend on each other at bui=
ld
> time and can be applied separately. Patch 3 only needs patch 1 for the er=
ror
> case described above, which requires OPPs and happens before the controll=
er
> is scaled for the first time.
>=20
> Tested on a Radxa Dragon Q6A with UFS 3.1, with patch 3 applied:
>=20
>   before "echo 0 > clkscale_enable":  cur_freq 75000000, target_freq
> 75000000
>   after  "echo 0 > clkscale_enable":  cur_freq 300000000, target_freq
> 75000000
>=20
> Before patch 3 both files report 75000000 and keep doing so for as long a=
s
> clock scaling stays disabled.
>=20
> Clock scaling itself still works. A 4 GiB direct read moved the controlle=
r to
> 300000000 and back, and trans_stat recorded it.
>=20
> Bean Huo (3):
>   PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
>   PM / devfreq: Add more details to the get_cur_freq() comment
>   scsi: ufs: core: Report the current clock frequency to devfreq
>=20
>  drivers/devfreq/devfreq.c |  5 ++---
>  drivers/ufs/core/ufshcd.c | 32 ++++++++++++++++++++++++++++++++
>  include/linux/devfreq.h   |  7 +++++--
>  3 files changed, 39 insertions(+), 5 deletions(-)
For the whole series:
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
