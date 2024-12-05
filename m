Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E0C1D517E;
	Thu,  5 Dec 2024 09:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733389661; cv=fail; b=qmk/IjAtnyVDSX/iSeyJLk+KRa5jhq2c5N36rkO1VX91QaDmrmNLv1WgOcrgNgbqTQRZjfaLmnm0kZ/pcWFlFkpJyMXxm4OaWEMktfpD7F7+Ai33nHF0l98LUQz3bxYqUlH6uENsgzhSa6gF7ZdujUZ0sQitdeIRqLSZ/eS/rsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733389661; c=relaxed/simple;
	bh=la52Nzjs2Fjod3uFveVSDAUJuz0tRU7nQvUFo/hVgxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IO0U5foXygR5mal2IDjeG1rDVVnr1FyP3ax6+2Yl4FWwb8qmClmliR3FaLk7/wNGVy/Ht5o+O48an3p/NcFrqhkJ5EGmQKoVXPQQ/D/7AuzwYLOE31OSsoWVUZFQJZUVxXHdaxGL6VVG/AeBL5ZY5Hz5Gk5PGVDxwoBeOLMJjwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Mqy2XjQv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ERjCNfFE; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Mqy2XjQv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ERjCNfFE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1733389659; x=1764925659;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=la52Nzjs2Fjod3uFveVSDAUJuz0tRU7nQvUFo/hVgxE=;
  b=Mqy2XjQvtm5MjLBEgmUo5eWjuRETARH5npfW/3iFh514xBhq43ByTcdS
   lKuhpNIbU9lUeGYsSSgd2oKqbsNQAijuGmXhMhkKVoLyY1RFAoi75RuyY
   KGvI5eILXFtQi61WquIl/6simn3eJyS1Kp9KWpDOWFXQr3s8cgPXIRryj
   2epMaDPwVIIZb/phI4d57014x9tYS+qgKjKMjaX3tGJRFPoj3fJmPrAKk
   4GZV60qgAA1KMYfidKnz16330kR1JJ8WPMkoNpivJonTl5FC9ZUYrI0kB
   mJmha2mT5Mi1z5W7fQ2gIcC38xY4ayP0uJf5kqOiav3i9sFymcQEIICuz
   Q==;
X-CSE-ConnectionGUID: UuKbKes9RTGUqFcHj5476w==
X-CSE-MsgGUID: oJqvOYOMSfO+hsVRqRYSfQ==
X-IronPort-AV: E=Sophos;i="6.12,209,1728921600"; 
   d="scan'208";a="33631374"
Received: from mail-westcentralusazlp17012038.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.6.38])
  by ob1.hgst.iphmx.com with ESMTP; 05 Dec 2024 17:07:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdOA1ubL4vwRCy/xpqyr5tmEsx96Qd9h+bu8O/oD6IfcBmvRsQl4l8nkKMEq05/01ORmyybbZ/PLjIyu0HGBbzK65nJxxx3zg7scND2yPG2O7JdFnUG/imdmaulY4KlhQM3Ab94U/ZfMfvdFlTh4nhItHx7IemdcdeFyJbb/s1i4TXStcfEZInSwDi4lrnYJZTpVDLAnuMJDYPI6pfhUp95tSOBibAHHkdLlTNzWkIJSGCiDpSOa/y3b3VAGyUPqy8v49HbqlALB8po2Y5FLd/xUFZnCB4SE7i+AJtS6WP+4WK6fSANJrlTqPLHjLXY4eKm+yKUYPvaWAbHNzTXS/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUr2YEcznA+pMdmNaFAaGMEpcWSnVhigY/F0yx+lQLI=;
 b=vXRnQ9GbeBak3cjIMGIbQEdunOay17y1f3/RBbQcUamD2Gv6FSLx7Q+xEEjOJc8HoM0PosdCeqT1wVDWPPtgBfU+2f6tdO63Z9gwrpIw0aUR7ywo4z3aHsCAVFs1h5tiHF/m6FfB5yAq51YgLTQ+Odk6N2sUkhv65Y0bMSemgyGvhS5uKDzMvIpoYG6JA+YXKqQK06PEQ4qjVxS8iZpgMuauoUmm8DodjQpvxy0+sl/4wHusar20CwrjwyoG9HNM0IOrgDc+seSoCGPnclSQNVJ6xwUxQkk3PISMWW0uCvPs822lTZqqTGQhipcpLPrRsiZ7asRIaC160Dw75V9aRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUr2YEcznA+pMdmNaFAaGMEpcWSnVhigY/F0yx+lQLI=;
 b=ERjCNfFE6ZS3ejp3f0FCPow4dOSWY7NUXoUzoMSnnG/MF42uJh65wJDuVOse8IYIPdWGFAFvcmzae17qBAD+FerMb2JyYJ6y0BtJJ/4eejHWv8M7DImTNsYhjNsQpw6eDcyYpNFgpHCU9QJ6i9I+sTT1ifcafyH1kD012JgkyBc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB6672.namprd04.prod.outlook.com (2603:10b6:208:1e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 09:07:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 09:07:32 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "liuderong@oppo.com" <liuderong@oppo.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi:ufs:core: update compl_time_stamp_local_clock after
 complete a cqe
Thread-Topic: [PATCH] scsi:ufs:core: update compl_time_stamp_local_clock after
 complete a cqe
Thread-Index: AQHbRkLwREgx5e/iaUW1EDH4l9wh07LXXV0w
Date: Thu, 5 Dec 2024 09:07:31 +0000
Message-ID:
 <DM6PR04MB657515591FEBC6EA15DC209BFC302@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1733313004-350420-1-git-send-email-liuderong@oppo.com>
In-Reply-To: <1733313004-350420-1-git-send-email-liuderong@oppo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB6672:EE_
x-ms-office365-filtering-correlation-id: 6c10d1f1-a39f-44c1-c34c-08dd150c404d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?qU3YetGUsVtU51mcvgaevZ0yD47j+L4y2cOgY1p6mA/KrM7QyqRrXLRxhqCP?=
 =?us-ascii?Q?S/DmNzgTM8MDT4/uLzy2klMbPZYEn+QLAUTGGEHIcEew7HtkxOaW2gQwJCUK?=
 =?us-ascii?Q?wJQ7bETOPhwmCtOs1mnrlugiyEFmIBRVBvHloxvcNxfdxFaHFvXr32tNUSFZ?=
 =?us-ascii?Q?Vf0SCxxCSbIj2x0T6bnNnOdv2+BZnv3/+eLjFkOae8sHmTN9CJBKhb77YDeg?=
 =?us-ascii?Q?GoGvkon1Odx0Iw684tg3Jk2oJtojrIjOS8Q5Pp62BeMGM6rXUDeKigJblOuR?=
 =?us-ascii?Q?dP4V/3R0RanZYPxjqaF6+ziQw62wSJwWfqPknKeLi+v1hXQ/BDgECxuT4IEc?=
 =?us-ascii?Q?lW0R93cwUMZrATvqz/IKXLofZ3xBDUwxO0Tisv8pDUayGSuWK/QvXy1VRpfL?=
 =?us-ascii?Q?Guu8ilyJW/Wezx6wNpdyrXLvsqakCEBxORIBY3jC7SAyOVdHG+y/r9gvy3+j?=
 =?us-ascii?Q?wQhRWk3i07X4tGxCs6Cx2pL6yVR2UxRGwIXhhbddQBE/hqobX735nGsj4Mps?=
 =?us-ascii?Q?kTaAWCw7id+9H7HDWC2/jefO9+3fFZAuYFfGrM8HZN4MeIruuvt04PwImPZ8?=
 =?us-ascii?Q?JqCtxraKySYH7Yn5kltz30mbumZljOSvhsNobNdJOxyoDDJC6Y9BPbuNNgRa?=
 =?us-ascii?Q?uAUQP+f1nB9dGQegaURhsMIohBPJYWDeixDoaVfnXc4UKX+hE1e2SKrvoHSZ?=
 =?us-ascii?Q?fWztxIynzAenBpOLFQzy8fYOHphuvPJLhhU7d8TpDGmHCaXNJvDs/ys7gKts?=
 =?us-ascii?Q?FtMj4549oNOa4LZ+CrB3m/VUJ5zONYWnujdT+TidRwLmJDCly1Vi1pqhLtih?=
 =?us-ascii?Q?hIbPVCNuROcmih+ZVzBFIb/mm7DXGhO0HwAz2ugggM9YNoHiFnlxw0QXVxkB?=
 =?us-ascii?Q?dxfgdYmHJHYLE4jPfCSnXWV6aP3CuORBcG3WxGif01ZRdzSv1s9Oyjr/VXTb?=
 =?us-ascii?Q?scA53en1z1ujJR1/esc0tL58WvArsXJGb8OX4Rmlucx6A3N7HLtgCALrczpb?=
 =?us-ascii?Q?oi2p9YzNmwMheAX9a6m8sGaTFZVyCpOkIKAxx9f6ZVcpaN/Rv/UedcuKFi2W?=
 =?us-ascii?Q?475wc/njednxvS+4LrCW92wsmn6ESedifxJkT6xhgfXn/t32fqS+yePlQNEu?=
 =?us-ascii?Q?fnORAb0J2GL7+f5JZWUyJVMEYJkkbL3zhi1XuUpQwva2T3HpfoSp+HVN4VzQ?=
 =?us-ascii?Q?PrRcBReP7QQj++x5WHM85bKHxGM50PAFJA2a8EoSs8G6tGrZgJ1LLEBQqhus?=
 =?us-ascii?Q?LvJDHf3f0VxSRQFeZUG1M+VR18PabyMPB8xY/P8ZC56hPs9wlctW+5p8oXKz?=
 =?us-ascii?Q?AYDqfdzW9V/1ZYb0Cb3ayPcdW7inGg5Gg4+TDO5xGXOioGYVoGgF2SRRa73r?=
 =?us-ascii?Q?pgwC4srEfsoZvUowQOIPgVPvBiW1JiQTo8RHpSYZ18LKS95aSKwYUWZJAAoe?=
 =?us-ascii?Q?N/VqS3HqcCI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/aZ1cupxBHXq4Jgs0B/+sfj3bwC6ilb5BD7+7b6dVRZE0/MWL0J4tO8vOUfl?=
 =?us-ascii?Q?AQSVJvHKFanaXRdO2KzhkJ7l6TiWaeSj6IufBWaSWIQ3B1ktlF+kqXvWJttL?=
 =?us-ascii?Q?gseepmEM7K7ioTtTgjlNzXa1l6qlXUOwP+RHdSDB32uFO3BPoe4BD2gFPROu?=
 =?us-ascii?Q?N8eDX3SCVOXcsiNoja6wpLFQsV0KeUbagMxC5/eeyq3rrJkVs98thx1qCJ32?=
 =?us-ascii?Q?nCU/O8Ov9myoUxlcqaIsDGbIhibxRMJZsdrzIcR0GhhOemp8WRbLlLfyGqy1?=
 =?us-ascii?Q?5Fw5ZuUIi3lWxt6tlCdnMLDjiVO1fFMkyOuXcQsbadV1DehoEX8qyvvz8y/L?=
 =?us-ascii?Q?oXUqqsmAGCe5bTYgI2/Fyqut9rFFh/guPictaraEY+HQnVVMbw1Ii37FcyTH?=
 =?us-ascii?Q?qcPwirEXOWOpjaXBUo6+FDGzFfffSj5TAMpnZlj4Rf1wCN8yiHh6ZOq0rveK?=
 =?us-ascii?Q?8GThnlV+TuGvsTzL3Vl6LsMQ9pAWEqE/VCHmUFrU7fLV0lnpZArUas4Mw1Jp?=
 =?us-ascii?Q?l3acyaaS5d5Mfa4Qp2Q/O94ihWFVaAFj8v8TwwvyyelgaZMsIQrX/zcWK4P6?=
 =?us-ascii?Q?1D8YHKR8GrPhqAEcQfwTkrpxjRrhZFARPiZmkF8tZ78EBWURcc2jIrt0JCEs?=
 =?us-ascii?Q?2FVHdQ5KNLUYQpjUfMf7I5kGFtl9FSTuBKMk5a4h2Q7+VLy8wN+dbdShyUi8?=
 =?us-ascii?Q?eJPMJ+A+21ElVWqdjtItJgA/ud4+jDbT8xNwDW5MOk5PQiGJJcRuqVArSWyE?=
 =?us-ascii?Q?6Q43Gmq+HvEMMig3y+s6sf9OogGJIc4G8ZwdbAfXiymN8zHJFcabtdJnLnNB?=
 =?us-ascii?Q?JqY9w6ZbNkPhYbbN39D+wP5pn07ioNQyPc4NVUqOsJEj1UCffCF+wsH5Aks1?=
 =?us-ascii?Q?kpLmfezSIkPqGCyDziVrZ2+rPx1Xbm8uDJiXEJHC4Tz3g/fNOavlhN1pIkd4?=
 =?us-ascii?Q?qf8YJkJCKSo5cqKm1QIAy4PaNR0b/2uoX/0IYpDkwimdbaOE5R/HWlX0+U+y?=
 =?us-ascii?Q?zDvkLnbTL22+/mlalOXzB9rDkFcs6FEjDcMJkfshs5mAjRoefb7FY1PseD6i?=
 =?us-ascii?Q?bL3zGntByf3MzZPjdO4NicsVjABaM6UqkhofYWV3WUYvIMspkvLWOy4hDzyj?=
 =?us-ascii?Q?CCRNVn/VoI/3XARLM9vJVtwtTwWZFfsUsDez5nxlsRjyny2gsJQ0smA4B+Ws?=
 =?us-ascii?Q?zW/qXIdohgAUzN5iopHk7OJJiucoNM/6G0KzYVnBh2lzEZMaOfW4jraAG1xQ?=
 =?us-ascii?Q?jIMb8fOoZ80RoG6xENySGyLRWMjWxwkI67/CjCvVwruuI1KOtgeUSuqBmdro?=
 =?us-ascii?Q?cixSDV8hfHAv2Ns/Sd3JU2I4YOLrRv2UsFhbesI1SsqgNhDjnoM5vaLGtuyf?=
 =?us-ascii?Q?OpuLHQ78B3lc1Wge6WKLDdpKNbqf85qmb6fiAM+h3DgZb/vl1MwycTFJJVyO?=
 =?us-ascii?Q?OgIhiflhnzPWLaYXsKwz+duJaa6NAQ7YOECix0A6orcCa2qKkIgcLhzMJ3S8?=
 =?us-ascii?Q?W1KjNr8aMFDFSu6bbkgwMq2DZtg3cLATqm9dG67ndfVvpzo7k/fyWU+WtZac?=
 =?us-ascii?Q?EOBCpS56Zd9OiEdzJW3TwPXDNGU77kHYgyIvAd1u?=
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
	sgWVGUSmx1u/Xne6ZeAHXopJdNzIepfiO6X/02sifpyZxHXUi9+XeUYgqLFVEU3p9vyo/QxD3rK/eoIOXHzEr+OPfRToeDo1RE+DmsK5U0G8Xw5Rs8y4ULSVWXFJwVFuzJc/ZxM5L7Uwl2LlR4wKcspjfC64jddKjURyvxWbV9EZprBVSOwU65E2CotlZ5XFCtWXNFm9vjD5SqI58GP1im64r4m8sePF5H2g2wlYkDbXm3JgQZbJHwuwc/t2FNp/r1q3k/XPaM09Ye+TMRwMRXRQjQQ35q460eEk5MeHf+o0AIjVqiTSuMduUFIDNV0Z8QXXRfGCzu9LoXHMXgLlzxV7JDQq8x6t8WgCDrB5epCcVJqy9le6jVFJya53QTMJe0QkzXRiyw3rhwUxHqNGturSnMkcPwVJf5Vwhm3eJsQHaOFZkAhbPB74kL+MHff25xsOL8y1cPi0aNEjBbaai8zKVyeWGRmHp23ibHTbe/JMLHs2Y/dHNCdR5rKHIn1yhBcdwL7gd9LkLfaRrF1XFHhWkXjyIiILvaMfeIUP+cGYt+4IdCPWFhB0bJOrMfuNtG0c/GG7i1LH13zpB+lPuEsuyuXoUp29+3Hr89RvAgRmhfrpl71J7WO6LnfZ9J96
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c10d1f1-a39f-44c1-c34c-08dd150c404d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2024 09:07:31.9085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2kRyfjZF3bTLUeECCbqhPm61TDe6ikPNbOR65jyRoXzt/Ex1EJt77cjFtPacfRR5MxgfqW/JafHebHDVw9pCew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6672

>=20
> From: liuderong <liuderong@oppo.com>
>=20
> For now, lrbp->compl_time_stamp_local_clock is set to zero after send a s=
qe,
> but it is not updated after complete a cqe, the printed information in
> ufshcd_print_tr will always be zero.
> So update lrbp->cmpl_time_stamp_local_clock after complete a cqe.
>=20
> Log sample:
> ufshcd-qcom 1d84000.ufshc: UPIU[8] - issue time 8750227249 us ufshcd-qcom
> 1d84000.ufshc: UPIU[8] - complete time 0 us
Fixes tag?
I think that the commit that dropped updating it is:
c30d8d010b5e scsi: ufs: core: Prepare for completion in MCQ.

Thanks,
Avri

>=20
> Signed-off-by: liuderong <liuderong@oppo.com>
> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 6a26853..bd70fe1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5519,6 +5519,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba,
> int task_tag,
>=20
>         lrbp =3D &hba->lrb[task_tag];
>         lrbp->compl_time_stamp =3D ktime_get();
> +       lrbp->compl_time_stamp_local_clock =3D local_clock();
>         cmd =3D lrbp->cmd;
>         if (cmd) {
>                 if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
> --
> 2.7.4

