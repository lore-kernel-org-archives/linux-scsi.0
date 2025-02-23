Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C528B2D05E;
	Sun, 23 Feb 2025 06:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740293477; cv=fail; b=IqBUXhKK1Ykkw5lVHXd9ckHzhuJbMnc6pWC2nNsgCS5qI/1j5c+3Wxdwte85pw+jvoUZgWyB/fQLvI0p7p4/mb9Xf9/2oLLVSHZfYi0jD4w20jtuF0sIje99MLsGQT24jyiBbjYcBxew7jbArSwgaWpol24uubcFsgdSapvfqEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740293477; c=relaxed/simple;
	bh=fe2SuKvptiuiRfIf1m9/u6JwpI0HC6DtvDv/iKNzn3Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GTbJiIxQh8Y8vRXZfgXp1hqHBy8g5GobtIwMAF+M3hrZr4PPuqmZdqMTpmdRrWqWpLE4m9cDXElyoiITL3gr9gH8E8HfTI3FCcsHZmq/bSLjHp6I6HlTyIqT/RZLgit2tuWhrLGJZ8Ja4M1CSt1LDL9YLNeuzVfwcCSZTuYU53Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=tKmqRGjP; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="tKmqRGjP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1740293475; x=1771829475;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fe2SuKvptiuiRfIf1m9/u6JwpI0HC6DtvDv/iKNzn3Q=;
  b=tKmqRGjPwo/q9BvDjbZPbmPXOWPk+xEOCBEcE4cMZREWnEjpor1uMjIM
   B3CGbJdt1Oi18BTDeZr9PYZTYCbSaXymWqwOvKhGHse/yEPIGplICBJr/
   Gi1kns3OKoYIT9Pon9GDLrli8gk/6Kc8HlDWi4iQ+yTvHMiSfjB21VagW
   Gm4ZOJ3EBxZrYXf8IENTz4ee/mrhA1ilLHrY+rqwwSrkzuF9pHrSJuk30
   CZpwpUIBY82afxo7lvQvBz+Bxh+LAty414yzfMjTSVpDL///yNsEQCoZe
   ZDYXJ0JVXZCF9KZEFspNSWf1Qt3j3fXM7mj9Zosd25oxhBAsUFCAQtVXf
   Q==;
X-CSE-ConnectionGUID: Ldn4IlpjRa6HMZBMsxsRmg==
X-CSE-MsgGUID: efUiEi6PSBOBI7p8Nb+DMw==
X-IronPort-AV: E=Sophos;i="6.13,309,1732550400"; 
   d="scan'208";a="38679602"
Received: from mail-dm3nam02lp2046.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.46])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2025 14:50:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZrricZT4bI73OIYXpgGZGZmg6EI8zT45cTPVREw6Aqqsv2hZ5BcwZXyqSGcencijj1DWN+tL3ploIHzB9gjBP+tSSS+Q3vNkf4nr5Yl/+eKwAENMnyvj8Sx2eesmBEOc27LkV2rF+NUtaYJXwJPQYHG4RKF4/ZrdG46yTor2PJj0Mkita/G+/CM5QaF07eppQ559D1KIFNRo0ytMiCyqccE8R5J2Nu7hVD/4nL7HzqXCdAJwflvd1JKOAx8THaGC+YHRwgDTavQoQbgoRiSh3nVALzwB0iRT0X5org6Xh4lBWAyp9A09G6kdR1aSTsoPlQbQx6qHHBs08VYYdK3dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/en9PL5J+z4NM++iSxLwv+MhBMZZqdFD0ZsRsLYhkU=;
 b=d5UF+iD+Cgd/uY71NACDj8YkIQNbs2S7WRvv3VL/lQAl+lnIGnp2dCaTDGfItSmrovJC/n4x6GKxv5CevPe6tvShXFoHLav7jvUwc2hn8eGo5gPCC16Spn70WS4QI+m2NayYcGvQyFA/h6GAwBQ8X1D1hlB9FwbNypWm2D12FAZVMDyZIwDga8YWiZmz+18khA69RIW0ULgMkaQf3gATqKMbiTNeOKALqIBv+kn67ps2BspLqhUN0kX8G6g9yI1B6NJQnbnvA5Pvmc41UiwEesxPeKLUFCkN1AlzzR+/n7wLtaarT6DK1O3EkHNpsCQxzYPyC9RXlYd+UxGRxXjQ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by CH3PR16MB6448.namprd16.prod.outlook.com (2603:10b6:610:1e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Sun, 23 Feb
 2025 06:50:44 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::e087:8329:baea:5808]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::e087:8329:baea:5808%7]) with mapi id 15.20.8445.013; Sun, 23 Feb 2025
 06:50:44 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Keoseong Park
	<keosung.park@samsung.com>, Bean Huo <beanhuo@micron.com>, Al Viro
	<viro@zeniv.linux.org.uk>, Gwendal Grignou <gwendal@chromium.org>, Andrew
 Halaney <ahalaney@redhat.com>, Eric Biggers <ebiggers@google.com>, open list
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC v1 1/1] scsi: ufs: core: Add device level exeption support
Thread-Topic: [RFC v1 1/1] scsi: ufs: core: Add device level exeption support
Thread-Index: AQHbgzoqkjnv1bsx10+FyWCC/0dgxrNUdOjA
Date: Sun, 23 Feb 2025 06:50:44 +0000
Message-ID:
 <PH7PR16MB6196948621D2B89F13B4A12BE5C12@PH7PR16MB6196.namprd16.prod.outlook.com>
References:
 <fdebf652abb4734d37f957062a2b4568754db374.1740016268.git.quic_nguyenb@quicinc.com>
In-Reply-To:
 <fdebf652abb4734d37f957062a2b4568754db374.1740016268.git.quic_nguyenb@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|CH3PR16MB6448:EE_
x-ms-office365-filtering-correlation-id: 5c6044c9-dbec-4457-cf33-08dd53d66511
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|921020|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?CgojtAcUkfUfGwrAJVvPUaOR6OjqyZcieyNXVvGF95PHinc/hDXQJpYnIqQy?=
 =?us-ascii?Q?w+og8MOTf1LNFPvsfT3YxmEXkDeIG4BxHNNE0CupnOzdAA7DXc+PG7sNDJgz?=
 =?us-ascii?Q?vWTCDdBE4Ct39MDqnz2UVAzfuo/AvyHtMP1pVn7Ibk4RwaK2oE1s2HjXUCGB?=
 =?us-ascii?Q?6f1cfaJekOR22fADFoCT1480nR1i0/ZwlrG2shXdkuFGxsCVKIqCt+Ca2Wvl?=
 =?us-ascii?Q?RDs/yNjCAdtH3yRLbNRvSTSJXqpLrFW18ufD4KhQPYpWetknHwVxqp6HeH+t?=
 =?us-ascii?Q?xuXWiC0AiDPYJDy22iXmC4AlgtH3b8AySwlpOL2/4m5VVEJhhoBln9ra/dxg?=
 =?us-ascii?Q?Fw0eGgqm0VlUjrZ9lqSb59GSBirQo/nnqqcarVIbQQ1tRAOIO2LwMR35tX3j?=
 =?us-ascii?Q?xlk8QrmLF/5TcWWBlV4Z2tB6Bwm+DeS2Cb2TvCpT52Ha1Mtl1b3otNTdusIu?=
 =?us-ascii?Q?KdxVVRVA9g9blZYXa7rWTlipQBYF6/3V814S4sz+L2hX5wXFsbvunB4aYPVE?=
 =?us-ascii?Q?xrtaH01Sy2IjK7x2cHYPEenY6irvUHLGaPBuGfp6DVPQmh52wjCNNyN3JHRb?=
 =?us-ascii?Q?zB4TpnA14tZdOZodUHOoZrXl4QYPf5LiSdPkQdG6INxeG/ndyArYIy4nbrEq?=
 =?us-ascii?Q?G7mpLfw4YKoIQgFPUQWbw342ickxHeXiFmMv8g+VJURW7eKLWjMkq98gx3XC?=
 =?us-ascii?Q?o8nUb/mOkoLgDtUTfg5rSY7m/88wc9njj6ZNgtlwnNiGP748i2ITLOYvP5Kz?=
 =?us-ascii?Q?fp5jlS/FGBBN3Sm6b3pLMbqhSAuuqYhyDDzd1TP97y7Uu06in6XlZhVyDF3x?=
 =?us-ascii?Q?aadU9w02etijI6XWcuyiDUcMf+1FIx3sycJ0V0zFrZ66BqX4CCPur6RPBWLP?=
 =?us-ascii?Q?9aBu8pQ2Hf6sL4y6CJMOrZRZL6VWqfbWy1/7DYnyStx7FQDWyaR1b4jxcma6?=
 =?us-ascii?Q?Dyks1+ApfzckMEbadBMxF3Gdk0VyLOHWTnnTX1l9PKmjmDdMnGPkvGAKSxrj?=
 =?us-ascii?Q?+jvGoc8b/JC9X+t2FKytMdT3ZFAOHDeYhGyk6fD3JT7ZkxyDRn+P5ckEdA0M?=
 =?us-ascii?Q?pvSV96Cp2ijCcsspTnBIIUi+vPEb1cMSxDfR6uo87KGIEnpHF5CO7Tc4Hz1G?=
 =?us-ascii?Q?7A2LZ3CFKNM+4jYS+62GAasxmXsf2zvdP4Zgtbd/+MbHQsxy+vAzk8oy9FRF?=
 =?us-ascii?Q?PKL2BmrPsLEHaRNGNc1KZ/yCKMun6Ddt+ukKcpbLC3VDtDR8uoafFNyl8jgw?=
 =?us-ascii?Q?ZwAhzfv+2jZ5eqdC6DzPhxhYt+PooQCTawVH1U5hnL615fzSiVbquggPVpfS?=
 =?us-ascii?Q?fnEPIPHbtMMZbPRlQ19hz1pKpr7g2wRD4i5GVlnpDaDiUmwgwkyGLKWGBQjl?=
 =?us-ascii?Q?156goTktbBpYySVplas/U3NGypLw9+tHLNW07s/iC6JbMq9q+qKEldA30f4/?=
 =?us-ascii?Q?Qy9i0c02C/KeQVUVNp3vyQ0f+Dg1pdVe7LTuxHxYhhZm8mdVvehN9A=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FzefJNARbZUOPenZq3PvRTUP4ZA9Y/Yxz7yAN0gqfmzn5tyRd2uE4XYlCQYy?=
 =?us-ascii?Q?7e45HqYZYx9eoVUbMutTYlqrQl7eEiYvGD5tm9ObdVK3ciCIGIRKtU8UUrmj?=
 =?us-ascii?Q?x8i/7fjbScy22+28rzoKcyQ86UHhxg09GihZpcwZuKuHqibPEUF05+hAK4yN?=
 =?us-ascii?Q?XfDS4T186btqD/W+VuO1pDwnNIY0Y9NHNFSBnogIfGHZ29FR/87DqSrs06sM?=
 =?us-ascii?Q?B90UgWGdcPfkiD32W+HkfGR9S90ZNv3hZakVfM1wIxb8PKM/6sW9RKwBkrsz?=
 =?us-ascii?Q?GSU2SgudXuHye4W04nJqnYAZOrVjvaf6TDOIiqHZ5KiHLxO9S3vP4Qm8132C?=
 =?us-ascii?Q?uZH9XaUtd/WbGdiFdEhorcGQRIn7825UA0MIivsXWzxmxytL22Ydr08NHTi8?=
 =?us-ascii?Q?cewCvV6b23zxT01bqTHpbfRrMTOLgxBmP3lAHj9YLMmThzf6FvxvIvnuL1yZ?=
 =?us-ascii?Q?igi8CcLSKAAQlf3F7Q+t9TgnUf9o5KJKkvv9oUv+tbsd5Lv5TdzNcqPsU0jG?=
 =?us-ascii?Q?MHL8baLeqoon4g+382+rvC6Z9+6O71BU7SVbqem3EbnPnd8zPkTGjiWcu7fd?=
 =?us-ascii?Q?szPSX8gOLZXl8zvn+jZk+4WVrHDVYtQYkpr4/26GSxm3R79ixB9WbQXo6oRS?=
 =?us-ascii?Q?g0+J1plRkkfeIuvAZPFn+M54PlaQXb2w9vyTlasJUc3Pnpo+npJc9fDc1yU0?=
 =?us-ascii?Q?Z/nEIhXDqMefvfrez1MxuY1xOu9fVXau/72uapWBqFOysXQWxxYB5rq7DBxQ?=
 =?us-ascii?Q?WctzD/OjCRqGxufwJiuqNLi1gKG8JQfkghj9Hf92gYmgTIJBi84WtCi16et6?=
 =?us-ascii?Q?oW2iOsASrJNK2fR/dgJgpzQbH1jnnEAUbr8e7bYrAGhQmLzmyVbcq9xuGNGw?=
 =?us-ascii?Q?eTPFl9iKCcMctp7a4Ilbw4DtrhK69rmv6Qr6rNTe5s7+Dei9HcNROx6xwbDy?=
 =?us-ascii?Q?OhjluNKa06Y7c/vYBmN7hCaQ5yuV9XtFqP6zlIz4wQHK/ODe5SA4Sh1zLBUV?=
 =?us-ascii?Q?w9lzrRxtJjrcSfHSLblgIy7eV45hvT5BjypengnONknURqRaaG437eUczrOh?=
 =?us-ascii?Q?FDHs4KY4dwiBQTX0aakgXUJwn5KFx4TOf5WTf4BWYnZXd5Yc9frwsVySAG3B?=
 =?us-ascii?Q?SYYpr35hU9FDveb2u4M5gThBqBrFvWdU4S6bEE+h48WYnoL+hRbnABeODosJ?=
 =?us-ascii?Q?3XrcIIL7Rf7C9CPh/RbBgCKhNkk0JHczpP/3uBVs531F/kpkyeRBDDrCwqmH?=
 =?us-ascii?Q?HbmHaTrNPfPNBLlMUp9CoYD8U+RpbrDCpr9fmpAzCIzVoOK+yQSu/rAyrwNB?=
 =?us-ascii?Q?B0TQ/1wj/g0pLS+bxtvirj6fGgsZR9g2EmFGnlqEFAkAKHOrREaJkeSmiqOv?=
 =?us-ascii?Q?xpsQtzGZK/XxQodCrIiOXiHdNEWJKvjpXd5q4mrFqVt3josBp6NNmwmqSR/r?=
 =?us-ascii?Q?CMCpqogcsLLlVvYirVlwkKapDJzRKnWq1smcSvsk8rKvLB2tZ27/WGH1E4Uu?=
 =?us-ascii?Q?tBadDdwf8BOkoZlfQaPstoQfIazaxWGI2vn9/VJt4r38qschOE8SWZUMVxmN?=
 =?us-ascii?Q?+qi7LxftQWtluGM9A+ugKslgMeZyvyJBscU/rjm+l7VyFCkAkPeif/PA6zPI?=
 =?us-ascii?Q?ato+FEMsFLdxj92/htpNRYNfk/QMXt11GX+OmDAgO4jp?=
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
	sJcbUtgV6laNMp3qyXentQrJuxtkXY6p2BUKKquZebD+fJG0sZXXq0oGi4OP0UmcilL95hibOa2UK9pA249w7pN/wOp+uEFtcyrnYnVc0ZXB1OvO+svymv8BLY7xyFozfZJGLxf4OM56vRL8nAIkSO+fRRnVsi5H3qfB+fayXrPIRmq06hjNTWaTU1STgET5K9vxKxKdM/6r1GJ0pw0RaFEXE/mFJzJJ0/r5A4gaEvo83Ifi+exwwyqDbu7IU5dOG+hg2oHCNZvlPSISynsRCp1sxzMKGcw+VWNR9rDWRpkQVttNvxJc/SGZInHMxw+qPt30Ovbpi0q81nuQf6ypr0tZ6xbFo/uBojdLZlZcFdoIfR6KhSPlutWDZkEX6HHvalEbD1rqN/u7raBoIHFslUK3nuBzzSLQaK2XJu7YYyo9Tncu4cJOCvCh7JlzscugZWZq8c66Ef8keCrxuT/RSZQ90/ANj3saPoE7BBbbcWhtxqXeNnAHSRWXxglaEJDSlm2dTI4tag8I+RMc4n1GrA9gTI/bzOEBacPnWT4T8MGWXQXTzG3ftKS5G+6GYybYK0O4uBTkaV2Z7GbkVHiZ3SA1K25GylJnGrPJsmhUc8TTVcggv9xkjC29OG8mGD5AtMpQGdBEcaWncB318aDeMA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6044c9-dbec-4457-cf33-08dd53d66511
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2025 06:50:44.0157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s8VHLQEPdNHQb7tC3GTxexfhoRd6i2HuExmRjh0CcSXfknsvU9RKhtxu6lN1H9raY9OjmJwT36Cq9iuRqvrAlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR16MB6448

> +static void ufshcd_device_lvl_exception_event_handler(struct ufs_hba
> +*hba) {
> +	u64 *exception_id;
> +	int err;
> +
> +	hba->dev_lvl_exception_count++;
> +	exception_id =3D &hba->dev_lvl_exception_id;
> +	err =3D ufshcd_read_device_lvl_exception_id(hba, exception_id);
Why is it important to read qDeviceLevelExceptionID immediately?
Why can't it be added as part of the standard attributes sysfs ABI,
To be available for read once the exception occurred.

Thanks,
Avri


