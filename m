Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D5126E17D;
	Wed,  1 Oct 2025 10:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.152.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313222; cv=fail; b=JwBgAAeWU1AQtDFL7AeC2SZqCaoVg1oytaM4rmMWbrB5LYuj2GYIkT9BSXZr9amgePzm4Tpy4xwMONI/ZtQMfjDD2mZB8ZwTh1DdOroEP9Q+pjG8YZX+cZS7JhjjWDIyvYauamjdSeE0pRRh9RC9q0Jk3tA1Wl05Gy4aExbn4tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313222; c=relaxed/simple;
	bh=o3Ld891o12pwT+eIZozMA1adfbjvABuSxB9TZhoSQ8Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g3FI203L68l8a0o92T0K069yJZITdJj4uYfUyXyfDBs1zOe7Y6MQe/p8muPf9Qd7Evkpwc6SW0WVM6AID4TfhnhworF3uvWsN5e5cAtsUtE8ywbtlkkmWCAEyp3gJXbuYnJnbA8brkuJcdNHtiSQwffLi6Q9Ef1zdfsfmcSkM7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=OZBF7aSb; arc=fail smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="OZBF7aSb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1759313220; x=1790849220;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o3Ld891o12pwT+eIZozMA1adfbjvABuSxB9TZhoSQ8Y=;
  b=OZBF7aSb1EjRLbQ1Z4VB9ZoSrhL+JKMzPGKkdylLhvnHUyYmb590kXag
   exrT1SqRx+9GPSk3wtAMErCfUTMiJZvY4eBvaxXmyan9o6Lna6nh5qijK
   QFXQ4WNqYJ+j9pIor3nRCi5ZnMCgkmGJRqFcyZq+7l4KW6TLAS5oamn1k
   F0wIf32XgB9S7vR8ovLcfMbOvPaiBH8yJLCB9W11KHOKHHhNFL6ZkjUiK
   G9oAgRqNeMWyaeAHJYlzMSVz6Nu3H800UJdlOJA+r2QCO8agO2vfsw3o8
   qkkqJ/U6SYw2Yp7YmEBNj2tepmj0Ji6zclgyo6JQydhvDql5rF1PZNVDC
   A==;
X-CSE-ConnectionGUID: 2LOtYOodSE2sYzS8l3TU7w==
X-CSE-MsgGUID: BNfXR8KUTRSnkr76x7f7YA==
Received: from mail-northcentralusazon11020078.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.78])
  by ob1.hc6817-7.iphmx.com with ESMTP; 01 Oct 2025 03:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vJn4MHNBjx5i2JjWwlTAieDqVdtFPZCVEm5KepQPRjkJUyfkgueZ4u+PFUYf2CwiJC1ewOdAKryQlvJUiGnYL39JYJL7UpQ4BqEp5QlRfQWVFVnmXXNmhMaYEsCmPZecpY677xPYJKdF3x87N4joUC3qEJExvdno3d1swsS0DbB4UwC48858ggGGB62qdK9nL0MnwqGY2hQLLRwKxmGYDmnuH7grlylty8+N1N+PBDtVvARlhOC3XubusGpztyORu3+xR4AiE5beAtVeWLytdK2mXCQLFglqPe22IK8Z7J+E0xYZo9HcaoaZRpAp9fel5+ue+T4V2MTIwwB2OxP6+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3Ld891o12pwT+eIZozMA1adfbjvABuSxB9TZhoSQ8Y=;
 b=v2LyArnPhQqoiwleNEfoRaZPnOJgNndhz9mYzp7CwNgNkF6WLJnEBuGXvfyUXCZyxFcFdKZ8+9XBxEJKtN+vTtkdfuxiFmZDVJv7njm6KN3Q/UfCITw7ACYGSnyJhDS6Wf7hziyW1aYO8EGTOtZd34Hi2b2zQUgJVFZGSkNnXSTAZhT76iNJ5i/iq858ghexdjYaJl3Rk1T7GEiwFIFgCoDq4ylw0AleKS0zUoLKO57gZw7RJDCLh+0GEBygN3hVaZCe0If0PftYesqg6jksk0ykdZkpMdj+Se7xpiNPGpHBWUlCm4K2sxh9NBMSKI0u4Zx3h8IVU1cgU/drKpHqaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA6PR16MB6799.namprd16.prod.outlook.com (2603:10b6:806:40b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 10:06:57 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 10:06:56 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bean Huo <beanhuo@iokpp.de>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
Thread-Topic: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
Thread-Index: AQHcMpninJZ2iAUFjkahnHpKkVJvdrStEBWA
Date: Wed, 1 Oct 2025 10:06:56 +0000
Message-ID:
 <PH7PR16MB6196ADF912182709D465970DE5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
 <20251001060805.26462-4-beanhuo@iokpp.de>
In-Reply-To: <20251001060805.26462-4-beanhuo@iokpp.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA6PR16MB6799:EE_
x-ms-office365-filtering-correlation-id: 5d8a48a7-a3d8-49f5-8c88-08de00d2411b
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?+KpiYXqSx8c6zAOvb34Sl/vdD+KPHdvHfKGSobOOO5bPv3wpglyPKiH6/8pK?=
 =?us-ascii?Q?BkrXp5ZjMYJBq2hCetecZeJ58curjNrv/paemR9jMAbifdUa3lkhtagW4RCP?=
 =?us-ascii?Q?cG4aoQy7IgaRI90KLkwqcCicTD3lkrF3nx2yCz/dop+i0/X+g5ppiGZlwICo?=
 =?us-ascii?Q?kBHALLO4ss+jUBRULTiSntlZ4oZ1yX2Hb+Y67BFleMOcBPfdE/8Uz2z5GR0K?=
 =?us-ascii?Q?pTnZXGtyAH0lNEwmyV5X854mGCJYhn9F7fYJfJbr2iDRHhP7evro+JUH8sSf?=
 =?us-ascii?Q?wiw7jy8bqF/wlJyuLiRQgPBwiKRYtXyqTJF/S9LDOz+qo8asEp9SX46lo8jg?=
 =?us-ascii?Q?fAm1Pqe01Ldm51fSk580ZkOLzbAOF0gdKnoVFAlqSVUUKivUvewQkyekWeXm?=
 =?us-ascii?Q?ehT30DvqrbLJAXuntlCnyAOfuJXx63xirfmejj1I0+yThL0PXs5mKK2ONSap?=
 =?us-ascii?Q?yERLNimpjD3oy1+sZAmHx6Mn+LxxiWww0sZwelpdN1eFNjf1LM2JkU3z/FkW?=
 =?us-ascii?Q?mbtS5NKxaDPwZ32SKRyAoJAv6DpJFNafWFzwMkiZQ2DLtsZnE6JaHDOHAg4/?=
 =?us-ascii?Q?UUjs9LIi4/GMSv2PvsTIzYt1g15/S3yNtFdITBJAvxN8pZG3BSNIwBKu9HIx?=
 =?us-ascii?Q?H2xcScYDEloVR6MSOn/Tsc6wNygHs33e/e1JDUlefVBsF+FGoCAa7qc6r+/I?=
 =?us-ascii?Q?DSdlkMRuDlsBD+QDYT3ZI3rxvSLzbyl0MoMERdFGbx/wJAL+MEa1oq3pst3I?=
 =?us-ascii?Q?KtA0g65096FtHP8ZrTl713Ha9mczQxkxexh2R5T06ahuOPCv5qyRmONe9XGb?=
 =?us-ascii?Q?RqulJlp+VNhuI+EDIh9dAuwKaaP+PByf5Sm4EMfHSgUMLJdJsB2bb6hcVUne?=
 =?us-ascii?Q?hoRJu8q9Gl9iFlV7gnYirNB7KOCVV0pGuim+Q9axhgpw4lA3Hg+TRv+OKiI0?=
 =?us-ascii?Q?Hfo/RWB3E40lE+5B2vCrA3K+1oGjiuRJgtd95DM0XmOADO2Pov+nm3rytwit?=
 =?us-ascii?Q?NvwghMni4kqQxgdvg5iMe7qFJq5W9BgohA+03zgHvLBtvUPxVtnsLARQ3iP9?=
 =?us-ascii?Q?nT3/+6xvOJgJrnZVw7pvBe2gkysqjLUY02bTy8pQohfawjC6rSVUFRlDSrba?=
 =?us-ascii?Q?oxtjxz0EXIGAceBuU6v9Vi39efXg6VPA4zRU49aW78lKveUrwaMdbTgTD8WR?=
 =?us-ascii?Q?CuWmPZ7w6l4DocbbTQv+fe5XPAN2Ofo79JrAD8+qaXVD2U92ZSF1+s3PDnZU?=
 =?us-ascii?Q?/RPkemt5N/n9U/CM1lZlgl6FQv3j3EGpfDKWuUqdubAquAvvjFdurvi3Kbu0?=
 =?us-ascii?Q?X9cVzB+Le0oSdRw023F9xFZtF/ChOz1Hz2pEz10fzVu6+d6k+i8HO65H9iCy?=
 =?us-ascii?Q?rK64tx4Wbbe3nfkaawNdw0aqOMf9fYkNXHvJUCipMC0EV5b/UYsRdzf+9hZU?=
 =?us-ascii?Q?0bVDAX8VdaIHnHTVzrod5BrXnu3NYSBqpeJhOZVXT8CqF/ERneSTB1+hpL83?=
 =?us-ascii?Q?KomAsSgMzzkqu3Q14jtGDBPp3sTBEiQq+dHhVFv08UT1wBexv4940CqgcQ?=
 =?us-ascii?Q?=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Xc9o5kWHMePxrPTm5P92g0oBClC1FOzpFpM2fMpEG3c0e4GyxcTPF64GpyBN?=
 =?us-ascii?Q?G9Dau2xdXsr7MDYmEwtIXF45WsvgOjb4Is9yUk97uKVSOesuVCJ9PCjf9d4z?=
 =?us-ascii?Q?ny0OmYPoGAXl6aaDkGK/ebPsOHRGmpQnARVjvJ01pRcyWM6hZ3v2iao6C9FS?=
 =?us-ascii?Q?qzA3EA1rkO1BR1CvlJTGoBbkUaIpCgMlcMDju6Dlugo1x0CVF5pa0UECrqAS?=
 =?us-ascii?Q?khnzpjUjqN04yO8iWNV5aaN83VGePi62GdBjCivxEpWFYdTXj8ajqNegSGfb?=
 =?us-ascii?Q?2sq0qqcuOIkMIPiUO3lO+OH4jut3ic/R894KoQTZE0Oi3CF+PPAlYzvoiZKp?=
 =?us-ascii?Q?vnMEpp/IzOQqIzlZ0p4SNnz1yfDQLLftmayL/bVp+CTxFVdvI6h2IaVTCreM?=
 =?us-ascii?Q?T7H3WiVtDG9sG3OnuYQ09MzW1DY8VACiLiW2mld5fu0wCPovAacyg1DuJQyi?=
 =?us-ascii?Q?evNNq7EejHLeVteqW/Mu0lPpl5Wd0S8gRX2yA7KRdt1oZR86DjcSDEGnC5hI?=
 =?us-ascii?Q?izlLjuTkc5RkPCIm1gw8jqqzrSmTSj4wjQKb2xOpJfnVhzBEeu7bgXLo+rdn?=
 =?us-ascii?Q?EX+yJs5RtIJIXdfHddAWR0O/BFJoPav6e+UFCnuN3HkmY8dJr/C5U2gcyWZN?=
 =?us-ascii?Q?OPv0DaLnkj5prYYcLd2nIFps+gvJfKtOsnhvD6loC8/nMHcoDe0kHkKCMle9?=
 =?us-ascii?Q?9UJv6d7EMqHbLyBooCHMr9hxPLA7rjUzTlJfRmHXCqs/HKouDbY9Ye9S6F4Z?=
 =?us-ascii?Q?wA+0SYChX3MX7EZx7PH1DXFUDBLATdLL2MNjh+IjDXd1mYbAts8zPNBH4uE/?=
 =?us-ascii?Q?pQki08PLJa9/4zYmp8bEm/IdwEfyjJVcFjWrDM8zSc32WEbxCwqOMeFwnhZj?=
 =?us-ascii?Q?Y3AgRLatJkxrSyENZI0kosBHy8Xds1vQ/RT+FCDGxxOuRv0LT7FM7JqlY8vs?=
 =?us-ascii?Q?ss2YuoXhOYMBbbTVWN+pTtRYzULTxa4nMU8DpOMGM7r3APtlPZJ95LoTVTqo?=
 =?us-ascii?Q?+Qe71PviBMY1e8FnrEIk36aYfkbNA4B3AME/kHgDs+b8Gbd2uzC8xYESgoIp?=
 =?us-ascii?Q?MtU2C+6C3IK7wJBKalkWwEXcBfx+dHJlS4XN2zpg9LIXqd0xGcInOxzQnIfN?=
 =?us-ascii?Q?uLNzF6Mwdjt3N0N1GLZLF24kHT8lGzc8/GDajnui3zBPuqhZyYSbIhJUXBam?=
 =?us-ascii?Q?seE/LW+QR/s25QpcR8CgjffIHC+70JSJqmPK/8H56v2MhU79vh7En/qrzQQY?=
 =?us-ascii?Q?OYuTMaXey723iAmxrOeHGStr5igejG7enJScFxFNPlC/zq4/JXUz1Jx3WMg9?=
 =?us-ascii?Q?D2tR13HWFuN48F/5rChSgaOWcH4ZIaekXx4G/T7JR651R+ud3sDb9m6mA1RZ?=
 =?us-ascii?Q?0r5akT68CT2rTkIy40UzMkNxCQVYHt4PRyMCIJYQChbca4bv5SnEyE70DhYM?=
 =?us-ascii?Q?iT8QoUEo/pWo2diRKlm5RNn2y841riSAIGVMn/hVFAY5WV06m+eUfs9zuQKJ?=
 =?us-ascii?Q?o8IN6CTMzuV9OcT3F78udNDo4rZycQn9bnDkdJBEMQHsWqa5wfm67xsDXVlK?=
 =?us-ascii?Q?zG+36+stc05fi0A4PImGO0nFKyisMLk/5wo3LSsz?=
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
	e5gWKc3Ivr8OxzmXPvRdve+YL2GSLlNC8tCxN698YoSOzP4HgirtSme0gP90Ny0MdAwNH3oBNHf2iCVWOcuJED9qyOIDgEV1xmUMeUX3SQjZXpUHJDWHmPWSv7sLUUFwkEbT2okgAnf5PAsIgYQNx4kJWDOEUzfMYB78gRXN+Qy0xRY7twKDwD6ZlnD4aSLQImFKMYgQADxYBCcbvPLu4yEMUDXocqyUVWoTBxBuEzcR0tAfndL3wQ6i3YnsrvjVk1ZEb33yuMBxjKYk9iZEfuBTH8nDx8YHUrXi/dV69loNoq/x9e+OuYL/NmCrKK0yY9FeNL+hRuZcQ0nSet5tCwGDc0Z/5pOcGqHSMQPMpn4ag+isCFgqMsFenRhI1BCqJrFUIIoqL1h9rpHG/aUcu9NLtUPk6QXxULPBjAf3lPrSJhF94Ge5Auj7UDVNPt1KElVC+0MgMFV/VH2ZDLXYi/UK3m4tSfmJI00CoptZlX8w7z9V8pCHtqFFRXZ3HvxFVFotY6Jq3CaYV7ux/XQFFsmIx0+PlhBIuAO27LSy53MBRrkgKkgS833cN+JgMLeLLXRokiZY4ixforCWNXCgipv6cwlF25mOKUBpmvfslwyQkVLLOMN08H7IMBFu/AlvIEJ/huIFWya2dwzWb4mRoQ==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8a48a7-a3d8-49f5-8c88-08de00d2411b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 10:06:56.8461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hyJc/vA4T8vnJsSKlTu0EV0EMD5BADnulERYg3y6A1/nj01ERctmmC+OhFAcB6Jw34VY3zqyTMvTkO0SQkDUaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR16MB6799

> From: Bean Huo <beanhuo@micron.com>
>=20
> This patch adds OP-TEE based RPMB support for UFS devices. This enables
> secure RPMB operations on UFS devices through OP-TEE, providing the same
> functionality available for eMMC devices and extending kernel-based secur=
e
> storage support to UFS-based systems.
>=20
> Benefits of OP-TEE based RPMB implementation:
> - Eliminates dependency on userspace supplicant for RPMB access
> - Enables early boot secure storage access (e.g., fTPM, secure UEFI varia=
bles)
> - Provides kernel-level RPMB access as soon as UFS driver is initialized
> - Removes complex initramfs dependencies and boot ordering requirements
> - Ensures reliable and deterministic secure storage operations
> - Supports both built-in and modular fTPM configurations
>=20
> Co-developed-by: Can Guo <can.guo@oss.qualcomm.com>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

Nit: Would it make sense to simplify things, e.g. :
Instead of struct list_head rpmbs;
Use:
struct ufs_rpmb_dev *rpmbs[4];

Also, I don't remember if you were planning to add the additional rpmb oper=
ations (6 to 9) later or not.

Thanks,
Avri
