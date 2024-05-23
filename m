Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7530A13B7A3;
	Thu, 23 May 2024 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716469778; cv=fail; b=g/G6tvzKr3iNwwJ6RsYHtHNPlu4pGHsWYtlWLUmvZvLYBWbdo8Bi+c1ZIu5YzmMdv0CHkN1fnSdLu+YCOX67RzjEfoIoMiIvvMOGt1K+UvRj9jmCsUrO4/FoP3MC7ulhgmsDbEKxL/3u9+6F+zmiddzJqtvd26ErWBR0/Rf0vkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716469778; c=relaxed/simple;
	bh=sgUVHjEjpbYgT+i9Br+0J7maQ+25MMPIgp5Weai6Wl0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qoS2EhiT9v5o9i5+AzVQQjr8pHS1AkFw17O+z/+uzmNjC2u9llcl4sgtArm+thnW+saX38AHDPwCWhtZXxb97iHUha975RtvCWx8qexBU1NRu+bYSB+eNl1Jg6S2MtVA6uPXenZwdKL38NM8AhsPFk63QxWYY1ppS2D8LHRfhrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kc6yTPLc; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TFTmFDhY; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kc6yTPLc";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TFTmFDhY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716469776; x=1748005776;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sgUVHjEjpbYgT+i9Br+0J7maQ+25MMPIgp5Weai6Wl0=;
  b=kc6yTPLc1eeVrdVEoJrzjB4E8M6gg7njRv4fJQi5iA3Go7sqgStLsXUP
   22CGEVmW0MtFA3tkxggC0i5sgtA05fpqaxwlnvn3qPs9hYePUR6dmR/00
   LR47bsFPVHY6CKDmW0tjlLkfonawFEg5umgZy/OR/v7xwdKgphsTGrpJS
   Y3m32a0MdyCQqSjrYt/OQSs9N6NutXhfhBBG2mq1j8kHlpFvOuJuPwSpj
   g9YihIRJ6oH0bK13tpXFzFA+1lmQYwGe7BcT7vxVq32kCvlg7qQMwUTI2
   6TGt5IMkA0uHUjRTD+qtkuNEW+QmPh7HGkzKzAR3DSOS05Tpw2ggEo2dt
   w==;
X-CSE-ConnectionGUID: ibXaWJunQ8Gn7XZTPeYApg==
X-CSE-MsgGUID: 5meFav2YQh6IY1s3BgxatA==
X-IronPort-AV: E=Sophos;i="6.08,182,1712592000"; 
   d="scan'208";a="16406150"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2024 21:09:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGqkRzAcr4hw1yoZKVDGrMXsW0psMxZfC7Li6OpuZV19AEns71g4nHGc8cUOmQttQI15q4exzONWl15t7oi3Hkb/WGwamMyaqmUiCj4t2GaZUUUHNchjRAt7vq9pGhq7GJCXxlCM8pnajlHFkRXENWOjqT4EUi8PqbfXKjOGVE4U6yk8RqY6zXsOGIvul71Ijt/D4ZfcTgxTCvWbjW16iSdaPvVEn+eO4uxhIgcp89xXLfylf06MnuR1Y7TQjpfhiIABDAedw3LUG/6b81iu0oaPP691czYMYWAS5ApHrSlbwKAuEe5Co9GW+ff2a8kqtTlUBNzONkFSlOEcHF1RfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOHzq0mv9NNwK+xEe1t3XKZNTJ8or0qjKvHr2ABAXM4=;
 b=RSfqztqxR9/gZdrv9I5RXq3ZCMm30wEic1fN8zSrNNCTq+yxyksvfXTLpoEevjbDwq3Sc3hvO0VH+c2MbKrwb3AxVYwgdG571Yv23yqizzXZ/cfwWLtAiyN2ggeEU32r92C0A7kQ+lBX9IIpfEykNvZSb4Sou9upGYI+jzuTwW3S68YCPJTl2U/C0ghAUr32XCufQ6kK6O2Vydzqv8M2QW/Nor+TbszYknqbnpN6oJKsjUD7G3IYOhe5LXO48X+v1sqxJLPNVTbrBmLoJj7sA5mPD2VmCWZwbxU+ZuRjW5MqpikjKiVPl5hdHfKyHQ230WLEKLuIi7jaQ7NexhPUyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOHzq0mv9NNwK+xEe1t3XKZNTJ8or0qjKvHr2ABAXM4=;
 b=TFTmFDhYjlH99pdLeaDozTIVBBE0ZloRrOVRkpaTEZ+zWGC4kwef2uXIcZzAzdiRXH2cj4M1G9ba9P/J3f/XipXDIvDzPeKDWViWzc8G2uKBX1NWd5viiE4SEtVzpFUVvN6tftyfo8HpGThjov1Mc3hxj1w+75DmhKlXe0wxxJ0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MW4PR04MB7284.namprd04.prod.outlook.com (2603:10b6:303:66::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.20; Thu, 23 May 2024 13:09:26 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%5]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 13:09:26 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche
	<bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, Peter Wang
	<peter.wang@mediatek.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Thread-Topic: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Thread-Index: AQHarRD6GlDrvRC83UqcB9DEZGGuErGkySWAgAABXpA=
Date: Thu, 23 May 2024 13:09:25 +0000
Message-ID:
 <DM6PR04MB65758584960580363D43AED4FCF42@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240523125827.818-1-avri.altman@wdc.com>
 <20240523125827.818-3-avri.altman@wdc.com> <Zk8-rwjFvgP714Mn@infradead.org>
In-Reply-To: <Zk8-rwjFvgP714Mn@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MW4PR04MB7284:EE_
x-ms-office365-filtering-correlation-id: a9380d16-1ee2-49b9-7a6f-08dc7b299263
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?MaWKOL6jFdezCTdvZHCAwa2LVlIG5aw7578M9ljOlYKwAHBAh3cR1jbAcJwo?=
 =?us-ascii?Q?knDRBsUcNqV+6UmRzXn0DNZgsjVrZVpdoGpgGAKfec+02IAlVJQEPUmJGN6u?=
 =?us-ascii?Q?WhkBZbcc/IRdv/QU+V/OMnBYk9ascLJRpozdZiQ0csS93LlFJpupVJ42h3t6?=
 =?us-ascii?Q?95OjHRwJqhD6qSQLnOIFCP8Fq9xSMO9lardDu+yjl68mpHwsYJahB1YkjHyK?=
 =?us-ascii?Q?fhuSlhKnkfhYPTOS4Ulq8e93LN9hDQahnU3pRWdKCjBOqgsiEyd78p+w/gaA?=
 =?us-ascii?Q?x4G7CVOoxas19b+dqnsgxU2jBihG03uIaRL2G8XzvnSQjEsLJqOSWMn3AWke?=
 =?us-ascii?Q?W47NZXywYUZ6uYsyavyKYgL28gjPH0qEKyhtIkZW7e+GMZyzJeLrCU0rmc2h?=
 =?us-ascii?Q?ANRwX9Zu27hmIYWRtBsI39Ge6CDTmxBeNfnfd9skD6+imFJEyd/FUkR6I3qv?=
 =?us-ascii?Q?1qAiQEntTkSh/qioAANvoKk0/ctsbzbcJB4qdphWDb7/tRy7vHCEmT3f8znR?=
 =?us-ascii?Q?d1bQ9rUf5P4ou7wEsBr1GMkMkVuVcN9r/O5SOsr8Yg5gEdN74eSfhXOZyq+9?=
 =?us-ascii?Q?9PJVvO6wAF32jS1YWtjTcx0nl9HwGCHlC3XWbvlRzVOrBQPSCzSnn/sou3uF?=
 =?us-ascii?Q?BrbKN5jWxPYNiS08vRw4k9P1v4WBZyYsvHKXs/SlEpvjixUBUde3a/52j41u?=
 =?us-ascii?Q?C9ffXjXZk8iOP588TpxIJu0iovrDEJUdJ9MdCReRo3Pf1SVC2dpwpuiimZD0?=
 =?us-ascii?Q?Fu8NnO7IAyIiCygOBOZEpZE1T1zrmSrC0pr5sJN6IR9/SSlefVFPsb78Z82Y?=
 =?us-ascii?Q?ZO/R6nxl2TIiLiFt5q1IoqKmiDyQ4+Kp+ClHgPOPy11FBrQxd4dbeWClu07/?=
 =?us-ascii?Q?TtCZbRCNgIaoWPmhmNRrul3612fv9PH8qa4gkl8Yfr0nAROsxyNmGQp0bD/D?=
 =?us-ascii?Q?RnxIRRyTR4GD8mBm1TLT8ovKOIRQTuIpIjMv3DxlEBdrzZdrh9xZ43VWutjl?=
 =?us-ascii?Q?y0czNCjjdfyE90TWLjhncO5iELg1/B6DegLq6D0m9NLn+6D9tk1PDPhNwxPi?=
 =?us-ascii?Q?4VMX+HmDoQMpdu8TyKykkgoxWUJyF4TXAiPwc6MzcVN2vY2Stm09PVxthUx+?=
 =?us-ascii?Q?2SI5kRHhuqhlZZR/Wrv79f/lyPGj3wonfw4bmUj++zdhPP9u2gCz3NFhwvAX?=
 =?us-ascii?Q?8U4s+I6OWasNzXuSMWhBNok5n5iT1IFRyzdsyQMVTqmwz/wcmMQAfMcDBJ8y?=
 =?us-ascii?Q?287sVJOzsttDnRsN8MT7/Cnte01wLzYcFRZewiLslhOPvLZzBnqjfj6+ubCH?=
 =?us-ascii?Q?ftxmydKnue7sqadsyG3Tz++eFJQaewx10TE+JSRN/dxYWA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YbSztSULs4cYg+rCQcMVjM9+FYEYaR6pNfcZKguC+AtKxe40CL6Fmlb9MEd2?=
 =?us-ascii?Q?a5Uen8btTpqH/w7+7L7lV326yiRT6ZAiwol6NxEnubz5wgcIdK6U5ZAZkoqC?=
 =?us-ascii?Q?OxQG3wHuBY9MO6z8GoXolOM/IDTx4M8EUuhu2AIBuCml1KH2WZkYh/0nUAof?=
 =?us-ascii?Q?tCUYpfS73IUmmJQt7N7ReIovh4NarUiE+6dYiMwqdsOcxK7KeIZVSW5Vm7Cp?=
 =?us-ascii?Q?Kd1sKIxDFoNPiHBROau2FEO3o9DF1+MraJmmsW95uKnf/70AggyQ1ge96pua?=
 =?us-ascii?Q?MX1X90jkNMiaRQ3uxk/QRsYxeIIkMLNYDcZa5oEwgvCFTlR0PLId+xS2Nr6E?=
 =?us-ascii?Q?XlGimQ5F1pBGFFO7LYJyjT4McKLi+26D+pSH5swPGkvq4SvyTDzpkA2tZ7n4?=
 =?us-ascii?Q?uyKFJ1XC01fKNwjE4R7jgVxcAv7LfaaVV2yx3yvmVY2wvfH+b9cG4NZq9VBz?=
 =?us-ascii?Q?ifLZyF30YLK1Mo9HFFItm2ItdB3hRW+fRXJNIFWxgo74JPsOiUg37bzQ/daN?=
 =?us-ascii?Q?lGV6APVkm5jiB8dFB4zoQFxAr7iGkEaGW4ZmL+7/RD2x3jGU3XjVrb/qI344?=
 =?us-ascii?Q?au+rrou3aGoc8ROliQ9m3MQV96IZLKuaM0DiZ+7VJC47WOL0Phuez46rSR38?=
 =?us-ascii?Q?6xxHIFsGWVK11fuIhaYP6esaQ1PYr9Ufy4soEp7qAjUtFby7XG/pNuHZpsCA?=
 =?us-ascii?Q?90K9ijHtsKEMae8g6TJgzk9MNPgRzZAvoO7/ijo6/8gErI8i9LlEb5ksU+Sv?=
 =?us-ascii?Q?3JLFHIYpRll4SiqA9P8wcBMEaQvpxjmmFcthn3LE4EeHitJI/pC3XGZBrHEr?=
 =?us-ascii?Q?Oj3tVKmOvt9F2BxxPFAlisJzlqy1/90CIpkMeG1HIfevJ5t8IhbWYtYV718l?=
 =?us-ascii?Q?PL3kniyvaR8lZ89q/s7wLflby/9lpSUQAXJpyWMaF8ME3TBvmMNdsoAlFwcy?=
 =?us-ascii?Q?TMXgyO1f3Ww83VFbvHBKtdBlt2huGgXNHY1eEwNuCnWnxcuk78YxA0qzc5LY?=
 =?us-ascii?Q?pE4ZGC+bqmjy0M10GxpqjLiSz/DLJQsaE+GcXya+mA2elvnrpzD1lP12rNZz?=
 =?us-ascii?Q?wC9JV52rguiIz/zEnlYbktgJJXYI2YpIqdk2baR51j3ncKUOx2otNQmzb9yA?=
 =?us-ascii?Q?/8t6R4IpLtkRDlpuJZ/ZN7GElanAvLy/GsBLycLa3JwrJmlnmVAvb8wcZMG7?=
 =?us-ascii?Q?6JBHSJsSj38ryMDa2i/wudOlaEglxH9yPY1t/1S4iaOgfcIxH+eyPQSohHo9?=
 =?us-ascii?Q?z2ijsSzLEnrgRUC8EbGth3YMmf+S0h5sDtTDbF4lCTKE+U0z0jp8QgD/j/SQ?=
 =?us-ascii?Q?SeXSXRXFMRZk4LxYOc5BytXX0x1PHqaDrHcxFvhhliJczHfe3iHxxn7yPXkL?=
 =?us-ascii?Q?gC85V6LPhnYTalPbe4LH3C3Ztw+TjYr2P5d5smcJSwUNMegrcGVCbuU9VGcf?=
 =?us-ascii?Q?EJW7shf+2bVDfojd0rE1c+cpcIiHAulNqbd+XUAmomsdMfavzZClqfT4zAVe?=
 =?us-ascii?Q?bYNRvYt7hR0KLN04rcm4jMo6b2lrvw0GRODqPIGcXLwQUNJwF/tj40jXffrs?=
 =?us-ascii?Q?wQEC09bhZ4xYxQKjAEQ0Ygx51dnto1bHE0r1NEqi?=
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
	Ki8g472HJOSihEGL/dpSw1iuH8WZfHDE2v6QdK1aDDOjbA8jrUNoiNIwtYVALU5Qk0z8W1FU5o7aPL/dsRfjDgFhHn8GleWDuI1KoaSIoJQrS9nHkf2GkIRuOCBV4kVHD0lr62y7O/fB5tvHn0lu2xyWtVai1wvOWgYGhHOHhmxcPPDCu9UKBqit5vhQ4DtKFwFx3zO7+pI5wxRKDR2/3ejqfY48BNELOvNs/sGkRrmH0zHn01iVWnrLuiKXMwJXtmWc3N6lkWPvd6hxJxaVSDsRQuupDk4UO0aFqzT9+fC3soJF04Ff/53OviNznDeESRg99T1mi2T4cl0YyairNRGCa3Sd0BzcxPtegFRuVtrqFYqbyHcv5g7m5GHiaffLpU2I16e/pBHeXgEVHDN1qwicI2RnCCyFLr/4c1dGPep1DmDjKFpdtGII6Z5PuFqRQ44J+FgxHEFd1xNrHpQ8PWlOVwttzjKEE1rVfZsiS1lN04eSJCax9CY7hjwnT2Dhy0VSkicRj5e4HoMTVZdBf4hVgCy5aGNuoOgUqERtWsvoHtWjKmeKKxSKrQIkDBa8UnLvZJrte8/ZyGs819bxEkpMF85v8c92GE741cXfq/rtXPf8GAQVrujUo73SpNbD
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9380d16-1ee2-49b9-7a6f-08dc7b299263
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2024 13:09:25.9426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Js2lQjDToJY+Jpinp1eZ3LdzO/h+Df+4peObc5luSuPdvhTFmIgLQjNmhXHS38L1OPfdcBGj+CnKmR4/ba25WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7284

> On Thu, May 23, 2024 at 03:58:25PM +0300, Avri Altman wrote:
> > Allow platform vendors to take precedence having their own rtt
> > negotiation mechanism.  This makes sense because the host controller's
> > nortt characteristic may vary among vendors.
>=20
> Platform vendors have absolutelyt no business saying anything.
>=20
> Fortunately that's not what you're actually doing, but I really don't und=
erstand
> your vendor fetish.
It was a specific request from MTK to allow override their host controller =
capabilities.

Thanks,
Avri
