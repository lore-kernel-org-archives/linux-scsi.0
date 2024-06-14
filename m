Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489093EA7B;
	Fri, 14 Jun 2024 06:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718346478; cv=fail; b=UCn6N3uw40+x9NBCfNrc44orXZ0cJCEyYw8TCCFL9lJdF7iI/ImVcTpEnFp5V4h2jTNSvZVyR0y8nWYZh+O9kToHfVnh9qJ8htiOGF4jto9a1RS6k0U/aDErkKWCvkC3P+Opk/9UrBXLsMvWO9Wm01EM4ZO7VZokPcVBIlRadJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718346478; c=relaxed/simple;
	bh=Gwsu212BkLuVmLeYbFtLBkPqYc69gbNUV6bbzmugE1U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=udLLhmib2JgT9yvnCy7B9Sgn6CQtWD6/hSHX7HlUD9A966OBgfl6Mu7E550cywzJ7my5meLgRVJd9ss6u6FS83Z+WjpfDom7Q5T5XsUyWMluygNxAS39pS8u1rdGYsXUnK0Fs4I+m/NFhdGN8vCmSrRnYkeiB5rhEHV1UXe9qTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ogsBOJL6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=gn7kM8E2; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ogsBOJL6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gn7kM8E2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1718346476; x=1749882476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gwsu212BkLuVmLeYbFtLBkPqYc69gbNUV6bbzmugE1U=;
  b=ogsBOJL6E3D1GbJNqjJsx5YAkp1qmXPu350/8EwXVt0K1yhaIC40lpdf
   sG5xbEkx0ZQEPpJsBg+/WQ8BXjydYOP0OFm5ivRMUK5LCUe1X4TPvkR2b
   Xd+ZaFlHPLRF2UfYIzhrXfOWExdEFuemLJc8TD0CwQ1rEhIxk35BEbIWj
   BODgJQW6IKQ4KiJUwxKTpwwVi13hEtNYWJh9ZWzPcbZKjzHRI1kNB/b8T
   aYmXQYgIYhWXR8vbI6OeldurCZFI1q6cyU7+YOYtWfbvye0O++pAzB6nV
   viP+VRAukT8IZ0pHKiGUfDWQFnSOOgIw/ghs+yM0XPh06Hui+wJMagV17
   w==;
X-CSE-ConnectionGUID: Nns5Z2gKSRyPGHSUrkXLUw==
X-CSE-MsgGUID: wXWY4XUWQuyr3B5g3AR3NQ==
X-IronPort-AV: E=Sophos;i="6.08,236,1712592000"; 
   d="scan'208";a="19147941"
Received: from mail-dm3nam02lp2041.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.41])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2024 14:27:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCBHPJScHsNsPnSi/YA5AwuTniQrwxp7Dla6bNcw4N256UtSO1RI7iOaC+itPOEtsPjleg9mbaRkq7G9ULlsNbQhHc+A89V6pN2TXULuzK0BgycCr9n+Jx2QZpY1uKL0XzbmSvoXxKz8kn4gNuQsAKR69Ks95SZL57RariVjlhDfzcsVMoz7ciCD/tEGEwlq/fnjWKAhqWTt/yCPr7sEuzA8pQp9jWxsBf8fM/nbFHnjxjbz9HUkrc0dMXnF+d26YP9gxNc4y4Ufsoi+XYFjYvj/UvIVUnkJooljxsmrCIWZbO7aT+cu7MdN4tX1qqqeR3yaQfcUbByc373ofakGgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUJkEqVB67jN2kuDgT3cXsv5m3iDyMGHI7wo2jbFBMY=;
 b=iLZ0AiDcncyYj37N+ixh3kT6z87MRq2/3mXjAwEPgO+AtC8rCEMNehSGvU7LmgzOAl0zFfpMklYsEnm4cKjdLs4AdbVE05hpt8KE0pEtbq3wrC1RSpVGASywA+GJm+PBhlQAGh/o6XLZt6c1ZlbyS7nHoVGT2jHaJ8Br6pwoZbPnF4IFyF3/bvOTnr636Wp5wHdqFmAJfc8n68nvQprFh0Kl93T/5wtvNDS8UsjkCUJ6f4Hvg8Lojx7VS4jbZbAC37uT+XYpwaWr5aE5BjH2Fy0kxt2Y7usPTR2kdjMRZ7CF4rRsQSGG9eoPZVx3TC57mtnpoUU43JYFMT4anreX4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUJkEqVB67jN2kuDgT3cXsv5m3iDyMGHI7wo2jbFBMY=;
 b=gn7kM8E2Seu8BJeuC2QaY7S60kyjeF1cXApv9OosyvpCzgywDwyI0tYpgmOvKXFJJPP3FKEC+UVwMOaLMfLrxV9OfyGx1JNaq6Omafih3iXqvdcRuFFhxtE+JghObAlUT7ia2kjb6VqHN2jCuXXWf7i61279nsNaq+qref43oOc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB7795.namprd04.prod.outlook.com (2603:10b6:5:35b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.21; Fri, 14 Jun 2024 06:27:45 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 06:27:44 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Joel Slebodnick <jslebodn@redhat.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: core: Free memory allocated for model before
 reinit
Thread-Topic: [PATCH] scsi: ufs: core: Free memory allocated for model before
 reinit
Thread-Index: AQHavb95/lPaUQt0S0akgSoqvJltDLHGHZ0AgACuniA=
Date: Fri, 14 Jun 2024 06:27:44 +0000
Message-ID:
 <DM6PR04MB65754C0FF7EA562C33BCB0FBFCC22@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240613182728.2521951-1-jslebodn@redhat.com>
 <20240613200202.2524194-1-jslebodn@redhat.com>
In-Reply-To: <20240613200202.2524194-1-jslebodn@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CO6PR04MB7795:EE_
x-ms-office365-filtering-correlation-id: f36293e4-869f-4a32-834e-08dc8c3b1a0e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230035|376009|7416009|1800799019|366011|38070700013;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?vRlSmeWVgKYtCmyG87LXG0BO187sa20zez1XDm/ISbfmEBSMMnjml7a5lCPM?=
 =?us-ascii?Q?5dW9yrY9pecKVw4eqxgFQlxaE7BrDC1WrrayYFv4Tp5rwTW0Pmxulf4H22Ic?=
 =?us-ascii?Q?A8aNLAKi3+DbKaIBUzbF5Kc6Y45m+91WqcEVP3BIBLxVWrUOyCkHaqhyGs01?=
 =?us-ascii?Q?v4A18S4nG2rKSrXxj9qwmdLKSx13XzOE9TY14Q6y7tsLQJczjv1w4u7Mi0dk?=
 =?us-ascii?Q?E//7A4g4y/LCFPjPuc3kI1iDD5cms+cLu5y/3ve2m4JwbmM/LH8aLRZiZrE8?=
 =?us-ascii?Q?uIsbUQeAXrsefktU4agBum1GNzXfCaTOa4L53M1ogsIwwFF8iU0wp5Tz5BrO?=
 =?us-ascii?Q?hYVmVxL9vzXDK8VWXsoV6sCf4u5VwR25eTG61Rvs+9FUcOhM59ofXoBQrKgp?=
 =?us-ascii?Q?IDKWIXoNpflZk1IxYClSSHo9XLgarHIDJoLgA7AULNMSqzZ4TSRGMAuIkjAl?=
 =?us-ascii?Q?jilW+R5Z1aZwl/lWu3WjZMvYuc8Kmu2tl8D0wJT2946OqAaMIZnVo4g4BAgY?=
 =?us-ascii?Q?fDelz9pFom7hJ6gOYG4m7ShN+DfVjkQ3uDqddQTDae8yt7ymOvigZ1KVyLOp?=
 =?us-ascii?Q?exzXKeDcqctxzq5weIBz+T/RmbLmgd/awd+56tSTzLrZqWO21tJXIJ26r420?=
 =?us-ascii?Q?gu0BDZ+7uEhPbMPL4a44q30mOn6S7pvMG+RrKJHI9Z4oIkmxZN8qfBTUF228?=
 =?us-ascii?Q?yqwveyxZc6RL3G4lR44XWZZyPPzNbdyEIXK46qjk/UmSK25u9n8vfCZV64PG?=
 =?us-ascii?Q?xpD4YfoVh35tTM9BqDWcWfZLbVK8Jmc9YWjW6dZb2he2w6t0RsaWnSBo8OQH?=
 =?us-ascii?Q?kYaLNUA7XJ4A15duTumkmDI8/NLuLiQhIv7KG1myitXMNZZmjHoEhFUMsHSo?=
 =?us-ascii?Q?Z+PwszwRUeXQoGCW4LKGQRRjwZMrMGZIPz5Z8hcpct0fF36PrjaoPL9wAkVP?=
 =?us-ascii?Q?F7ZML6sNtFCf13kTfjnuYycrIO1rzSEFcNURJwxabvl0xoPbtuJau2fS0bYl?=
 =?us-ascii?Q?Qt6wb7JJCOpeSMDjzAxzAAVfrowhMo7JElye8Iv7sqRQ1Z2JHBZsMlymV2nr?=
 =?us-ascii?Q?TuD9XZajkhWocYYKF+sqivrGzrYcdLWfFrUGrkMhzGDBxhbsosYGo9Zrt/25?=
 =?us-ascii?Q?6iHJe2zBNAafNFkuK++AgCHqn5UtVP+9QzvJUt9YZd6ZKm4+HCkjFXguDmh9?=
 =?us-ascii?Q?gfyhBHgXHfVvH3OMguXhZ2Rn/YmzAAkFcY5EVyCpICz9inkNkGUzkgmD1vTz?=
 =?us-ascii?Q?y2EhTrjPuTnk0QC2637UnQo94NzoMrNEXCTrY52vIcqZslg2Ap6b68rcHS0I?=
 =?us-ascii?Q?AVy7TcX08I81ihCLAoCQ0xgNtFBeQHdpN3knhyXrGBjvJKRSQFtiFdqSE9W/?=
 =?us-ascii?Q?sxhEjkw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(7416009)(1800799019)(366011)(38070700013);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?mILFjHIB9XqhDW3SdsxRzBaXyZWy4b+dOH7fvYR5pgMH4ya6lU8XvhKosiR/?=
 =?us-ascii?Q?xqHkj2nN6pHjT76Ig4chqG+K/eS8TtjXJ5yEXIzdSg2eW+JEcLWMqtePlb9C?=
 =?us-ascii?Q?Tf8s3EkR3+4VTM2xzBV9abJiKUP4IpwQ/PGfMpa0InJetgo8Xf/8Xb66gl2F?=
 =?us-ascii?Q?n8LnMfmhFj2gZyReXS9tccCxCDrbQMXUqGtbRxWtK67E1+73nqyjFsGjVhS5?=
 =?us-ascii?Q?iN+Qbc7c8uKNVydFZYeaXra6Zgd+B9yo8zaBwnpPoKVJGfurIkdg51vyNb2v?=
 =?us-ascii?Q?XbFGtfzynK+tDFEFZo0C6BFNz7ppVi+B/J7xvX4R3QLdGINmTpRlqOCcqhep?=
 =?us-ascii?Q?kKjJyj0w5qK+FetgtaC2Dq+qMh65ZFU8u32UpEs598nRePMBLMdrd5bPLAGR?=
 =?us-ascii?Q?FZRgtWDIbFuw1NWZ6zTsM8tGHb/+BQ1C21/0nZFz8ChqhDCX/CLti1crJ2Ij?=
 =?us-ascii?Q?CKPH46DQAzUhb0wJjORAWJg9r2Hy8epvdqJAirU1mF6m+PqG8nOIss225dPW?=
 =?us-ascii?Q?fI93zjjj9d62GMzsW39SKuT5ZJK4tmePvWNIQL/ACRIgvy/0cSt0zGs4Txub?=
 =?us-ascii?Q?lsNoU9eb+Gf381zSfo9sTBr49DnZzeDzDdMPl//o5txHbFPcMCefj7W5XRhM?=
 =?us-ascii?Q?0fGomoCvK/UzsURrT6c9lZtllxuzb6pYUq7DwKnINPdoXXQJFYv760ZASP8h?=
 =?us-ascii?Q?mzuXZ90OhEgL0SJdDi6vDnXXYe6Jq2Udf7yj8t2fzywA6YDOix1Q3KMTIfOP?=
 =?us-ascii?Q?GlAUf/lafYsnGAVcKS0bM0NBJG00PXcXH93qqhrzTWIh9SZ3k30UijqTDYsV?=
 =?us-ascii?Q?8h/syh4ZHYIDA4oJNomiZ/yYTjVws8LboBzdvm/dmF0X5JdSLhgxpn/sy+lc?=
 =?us-ascii?Q?K5NvaoCqRR4OwyLot28B1OIIm3jswd1gq8a/bKl3hDOS7TpmBkcn1ktJRY+s?=
 =?us-ascii?Q?8Qk3THfu+sEXPwqH1vrADb02CATiu4SyBsKFuyHjZPc1B5QtrnI23KkhFdqB?=
 =?us-ascii?Q?nB5rtIBG57/VmfDWt98wfGyYZE4SPdnyKuIDy5QiihrNupKorilTtpYh5nli?=
 =?us-ascii?Q?liabVmD+gFrlJ9WU/mNepyqg5Zb0r4AAvXA86D5eDWuQ3DvyDabUVmE4IWBC?=
 =?us-ascii?Q?SK40HOZZtXcpNNgxUa7+bQqAptfvHJ9TszJyy0VPIVKqSzrTNUmg1WzMikNW?=
 =?us-ascii?Q?XPDM1IpxmLIIKEC7PNMafgh3tL8t2S3oxDQSCLrXYrmimfr4iiNF7t07Dwbh?=
 =?us-ascii?Q?M9JRAcfERcBQRzzJHNE+33ScBO8wNUp6V5EMiMiR7rCUPhlQsEALLBMOou+H?=
 =?us-ascii?Q?IhbFjCRXqmE1vh9KzIeByQxHu/i0onRAcZ3pV5zFEWIw4BjwzjrXhOf/c1ad?=
 =?us-ascii?Q?+JWugX+4JTHyynKYi9R0oCwUJSqWl57/oXUDPDVvCyevPEpmPgLoFXoQLaob?=
 =?us-ascii?Q?s5FsOdQxE2ge+ZMZtMAfUFiOsnpHVJEtosHXiBsUgxchmZ+hF7haDBUOZ+mb?=
 =?us-ascii?Q?llQ39oMZc3uqzcOJF4Oq1sDEW/AmlK3eyv47AE3q0UK91P/+7hwLZ88KWKik?=
 =?us-ascii?Q?QuT0wjs3rPOEQjS1VSbAAv6GNTG5AQrY+rWopVtqohCpOymw141T1UxJKnw8?=
 =?us-ascii?Q?rFpkDtoupHX5Je3s01czEV5JrqIBh8I+hci1t5iw+J4e?=
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
	Qu2pwIqNo6KuZ99d37sGo5cQ3Da88M9YRKzpYUDZy2BDJTdz4LiWC9UyFh7sTA4YtiLfb9YV6ZPmrr/L/RFZzFdho4xOu2PdOqPcXXuwVxrHgcBuUe4iE6M4cSNwBNHK9VUwddkaq+aqSz7SB6A2yaoy0UE+ySVJdYjfHglqthUt7w7IWeF035AgbYfgzjWrIDcMLl7gifu92yAcb+lvieoSKAlihkBSbgh+HvKWAXr7nB3pedtAkhIMPEoVVZBWwcEy9ibPlAP0V4KD3ZUO+ZGhTdM0mkBJfkz6s+ZIR9xouRD6hZpKo2qv2WwQncNNIThN/gCYO+ERzDSg47wSM0M3I/sK5uj7rmXi1og/nQmUdQCV5b8pAFZ/d4BS8rdHCJp8f0uPW1suJ4eE1td4KNmAzIQ8XoRpk3w0unlocp3lHIUShqvY8IYa6WgtowJIpTr4eQ2OJ5S1MB7e0fAt40Ryl3ve+IHayfZbJKh9ThWukro5tKOhaCtPUK7IfEW4Fo1wA0HxUJkBxxqBNs5JOPyyeZoNHBRINNILvBEzKWIlGc6EPR9dNJ414dgX0ixmSqnzKkxYdq3VBIdTu6IK2lOQuH1QaIH+TnefMypi4EQr3rABSXHI86SEIPjwsEr2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36293e4-869f-4a32-834e-08dc8c3b1a0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2024 06:27:44.7267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lTi48hEFUuajPq0+e31f/yXfErI5/qJ+2s9ia6oISipmRli3dZpX1jaWwsOuqgVwSoctPMN2/phy1Jl3hWJRlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7795

> Under the conditions that a device is to be reinitialized within ufshcd_p=
robe_hba,
> the device must first be fully reset.
>=20
> Resetting the device should include freeing U8 model (member of
> dev_info)  but does not, and this causes a memory leak.
> ufs_put_device_desc is responsible for freeing model.
>=20
> unreferenced object 0xffff3f63008bee60 (size 32):
>   comm "kworker/u33:1", pid 60, jiffies 4294892642
>   hex dump (first 32 bytes):
>     54 48 47 4a 46 47 54 30 54 32 35 42 41 5a 5a 41  THGJFGT0T25BAZZA
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc ed7ff1a9):
>     [<ffffb86705f1243c>] kmemleak_alloc+0x34/0x40
>     [<ffffb8670511cee4>] __kmalloc_noprof+0x1e4/0x2fc
>     [<ffffb86705c247fc>] ufshcd_read_string_desc+0x94/0x190
>     [<ffffb86705c26854>] ufshcd_device_init+0x480/0xdf8
>     [<ffffb86705c27b68>] ufshcd_probe_hba+0x3c/0x404
>     [<ffffb86705c29264>] ufshcd_async_scan+0x40/0x370
>     [<ffffb86704f43e9c>] async_run_entry_fn+0x34/0xe0
>     [<ffffb86704f34638>] process_one_work+0x154/0x298
>     [<ffffb86704f34a74>] worker_thread+0x2f8/0x408
>     [<ffffb86704f3cfa4>] kthread+0x114/0x118
>     [<ffffb86704e955a0>] ret_from_fork+0x10/0x20
>=20
> Fixes: 96a7141da332 ("scsi: ufs: core: Add support for reinitializing the=
 UFS
> device")
> Cc: <stable@vger.kernel.org>
>=20
> Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Joel Slebodnick <jslebodn@redhat.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 0cf07194bbe8..a0407b9213ca 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8787,6 +8787,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bo=
ol
> init_dev_params)
>             (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
>                 /* Reset the device and controller before doing reinit */
>                 ufshcd_device_reset(hba);
> +               ufs_put_device_desc(hba);
>                 ufshcd_hba_stop(hba);
>                 ufshcd_vops_reinit_notify(hba);
>                 ret =3D ufshcd_hba_enable(hba);
> --
> 2.40.1

