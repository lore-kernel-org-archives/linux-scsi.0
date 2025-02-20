Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABC72AE74;
	Thu, 20 Feb 2025 04:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740025128; cv=fail; b=O303EhGUVflV/OMsdKHS4R8apoHtHeRaLwkm5kH0NAYQrr1qoymP1EtHuiCgpNOXLK+19NVpWmx/msA3lIJfreRzYkmwd+kt1BkcgbL/TvBfyiyxNhEIaXZTiabxtDfaG9uV1XuCI1paE+yqS/laAz2MiS5XAahzI6q/xbaPAYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740025128; c=relaxed/simple;
	bh=3psYaB8eRxky6dfs+CpMh/mtmUbeBp6qWBcfiyvNhgE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ff3Q5o7PuncBCuocW0fYkPeGUWb5ZcSGBKaJRWSerx1tHDdcb6fzPaTyeFi5IUHj4zizzgRTPHzuGnnDEv2Dc+wiqkH1xg8uSjirpTVYiHiOx3SIUMBfwE0LNklwJkBuuhPu0M0L23aqjoT07j6fVxKJ+0nP29UAu9Zg7HXbjds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Rm85HJlE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=WxFpAY/6; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Rm85HJlE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WxFpAY/6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1740025127; x=1771561127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3psYaB8eRxky6dfs+CpMh/mtmUbeBp6qWBcfiyvNhgE=;
  b=Rm85HJlEpZ8hSypHMvATRiB9jKUWhckEJGD9JGH6IFzUd7JZqCY6R5es
   GLJ+8BBGk91CEifIb8QwVkzw1qqsRGQM39/GelsS/FqAb6p/29zZ8RsPo
   T+X3goirRGA7i5eJ5SWl5F51FtSvDkMmJ4MmC842VWdFuWGeYKg5xHHRs
   YMtWMM9fhc3S/KX+UATOcVU8fMSyf+XjcwXPXRWDPzmN9HfUzEBH0KjKQ
   FTprtq0aGdmhJS/bEvpN+n3O7j+i5fm50Gfu5jbVZpeb87E9MNVkZXLrp
   Mj4bUzbiB3vTZ0hQlJQHybsyhUopSmYBeVnw4rwOGQZU42LxFlomr8IHw
   w==;
X-CSE-ConnectionGUID: daF0yfbGQ5O/FyDxtVvsKw==
X-CSE-MsgGUID: SwtBkv9ESYiGZPw6QSuXFQ==
X-IronPort-AV: E=Sophos;i="6.13,300,1732550400"; 
   d="scan'208";a="38932323"
Received: from mail-centralusazlp17010007.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.7])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2025 12:18:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iX6KzkcQM5/GpWDYoFJ1VMbPNViX6q/sPPRaG++mSBlO4IXcmAJR/vMGQThdJdLguOOFZj6hrLJyDcAc3IdsQ727s0wMvXvAofIwJ+hd5ZBTfYYuH/uTMdNJaU4/vQi/tWxQ2Zy9HFq19ZZZRf0MGm7UKuSvodWGaj9YMHM5p2Jo4Pa/jKTG52eJxYJUjgw3Nk7tZGF6YGqDY8CfaTiwx6kDlL2GUHSCU1Ja9oGeZV/JJvp28zfXNkbvNk5Kajcjef6vNY02SI/jtcLAY20xJxwCD+ExP8GNmFNUULUfYBvp4FJym7IlGt3zzvLoctqRBBWBbccnBiiyD6eUWra1sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8m73hp45CgqOCMEcyAAS9jT58P10NFSqqbpr0CXhas=;
 b=IOF/aitWc5Bclv05LtVIIcVE+KU5LWrL6hNqJDnSxly31bD11t36INfPbpsVkFtAGwKCGL0uSgs99U/XDj76isEBPxkRmAzEloO+4Hjg/NfiqBr3uoMgrpa4ZTKaxXu+dM+f7kOzSFQay+5EWnIGGQ8qMX88Ugsxbk2zOrUT0xgpFJAFlwEKnwunkDhD6DpwueQ7IiiUY626qo8Lx06E699yEiFti+tPQwn+c3ckNP1shPPoLSUGnFmNkc7jCwJvZ4fo/g2FcsZFXOLquZPj55HPJKw3jl2xfZ9a3j/NGyoQgUesry4O+by+43zLjileaYqLm8OsScYFlVxHM9Kfjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8m73hp45CgqOCMEcyAAS9jT58P10NFSqqbpr0CXhas=;
 b=WxFpAY/6Lt9OlMSQk1mChC3UVGBg97umOkuF0oY/bPlwv6J03rWLc0Metqys/jAjWETy8vUNDNwCC5e7A08XDJbqmAb3PLmRDRklxh8UEzuL3U2IjeQ1wz0Qj9p7sD731aIVZuNQcsNP0ErOuAz02FsKktkpwosWZT7FbGCgnDc=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 LV3PR04MB9676.namprd04.prod.outlook.com (2603:10b6:408:28a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Thu, 20 Feb
 2025 04:18:38 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8466.015; Thu, 20 Feb 2025
 04:18:38 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Alan Adamson <alan.adamson@oracle.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v4 blktests 0/2] Add atomic write tests for scsi and nvme
Thread-Topic: [PATCH v4 blktests 0/2] Add atomic write tests for scsi and nvme
Thread-Index: AQHbebqoK0+Pf/YRw0S4Sqok/StndrNPqZGA
Date: Thu, 20 Feb 2025 04:18:38 +0000
Message-ID: <xsollvpubwfivrcp775pk3eehza4nfpsowetr5wwyhlkmqrc4n@kz55i4owi5sj>
References: <20250207235553.322741-1-alan.adamson@oracle.com>
In-Reply-To: <20250207235553.322741-1-alan.adamson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|LV3PR04MB9676:EE_
x-ms-office365-filtering-correlation-id: f6c38fb0-a3aa-4bec-063e-08dd5165a691
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?18vlgz2LHdA0RtgFnA3SnPUwFNRZytx61PmAK5gK/963NISBL+STFA8QvdFv?=
 =?us-ascii?Q?GarhxBE6GlfiFdbqbw/6MIpPigFuHG0Xo8tIpfSpKJt6Yk65NfbVl0GkKxg5?=
 =?us-ascii?Q?gJvd4VmxHizI26s/B9bt9uNbHFv63xNJA0WJa9UL9vciyHwLrc+V3L2pAMrq?=
 =?us-ascii?Q?0hWAIDTCqnuD9QluwaTrNoOCfWsAoD/1WzOVe+RG+yUgo3bcnK4niavLHNN0?=
 =?us-ascii?Q?fdZ8Nenh1EinJQyAxBkOsVYFL8sKt64sefdCRHDK7j1Svvk4B/M8eoukjgjV?=
 =?us-ascii?Q?uT2Pl6djFOoVOV5291vAxtEpTTt2CyNfFbS8pl4cFvxGLmqjW5AoEBq4T8HZ?=
 =?us-ascii?Q?mxnQnE1joJgzT46nk++R5RR1jFy7r92lvo2XqqDgYlfxYYuZhvE073C2jiZ8?=
 =?us-ascii?Q?0/rFoeBaLda062TtG3E+cQQaO2S3EKJZzVenkAzng9FfuB7rM3z9QEYYE/hM?=
 =?us-ascii?Q?PTUlnfKmueRqR29Oh+6Fa7IISgKy0PEGsc99+SlUThBRIErjjs1MI6KbO7q+?=
 =?us-ascii?Q?PtDq2THe22E/V5bQ2i7cMViclXPN7JXxbhAdic0UloKjBytdM3wt4aR1G9Zh?=
 =?us-ascii?Q?wWo/AO/qlNZfqIEFmD0ywUl+dWiEqPPCdNT3qdqCuhGIJq/n1kMtjwkNkvy1?=
 =?us-ascii?Q?EIyHOyz3be6b7M6ARagjB/Yde96BYYc+nUfhLKdTrG3RPmTdaZkvxWdxsLrZ?=
 =?us-ascii?Q?8RxYHkFj6XIyy6xsCzV68lQTXMbrVdJlS1wf83weCZh+hKfOeEPYp07+cZvj?=
 =?us-ascii?Q?jpMIojAq7t2QH0mZyy7d+dhTE2tG3EtfbDwDWpkcWuAWcBquXSRttAV2yVjM?=
 =?us-ascii?Q?OiVdpu7YBeIUxHczX7Upn/Wede4OQRrYgGMAmVPQe8xmyUvoQO7hnynQT93U?=
 =?us-ascii?Q?zVCwYd+wlSTgy4R9exwvw1ZJ9IThuwuKgc4Rk5yeMCSPoDXS+UJRVuExfWiA?=
 =?us-ascii?Q?BwM20PppxetiiBC7a8Er6H//kMe6yXpGGvvEopaJvee1j8lc6WHmUv4ey2VU?=
 =?us-ascii?Q?CPDf8P/dqiTSt8vKbCgPmVKgTa70T08gP2UCbm3r0RuGWA2yTuDGKCrc3l1n?=
 =?us-ascii?Q?J6B4W1M+YrU5DL/qG/TJJBGGiraTyiBsBZ2krshANx7uQHuuQix21SjEbfiu?=
 =?us-ascii?Q?WTAx6E1lrbTm1rCn3MARt3XE8m2RaAS1DYBarGw0V7eI1qYg5L6BdHmKPdqp?=
 =?us-ascii?Q?OrFz7+S3ZoCSQya1OcGIvlX9xOO3/vWFCRSd8ubLh5eKcgqTzR1cDAZVYSzl?=
 =?us-ascii?Q?X/eGeegtClB3BZ7wp3/4qMUPJKbhHtwuUAskcggqHWDPaHwBRE6SaudkjHmt?=
 =?us-ascii?Q?LfYe9SAkoS4s3VzPQJefDwWzGnPZNKeb4/DOTDukCoyzAiS8zefN0JjOQ7yX?=
 =?us-ascii?Q?7tDmqrEss3ebab77bblgwTQJvtzYv4tYFMXjADa2Kja4FJdjtq6aSUHMl0UG?=
 =?us-ascii?Q?WJkTBfc2pEILcgXx+QaCyo0Q2tn71Fgg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?PXkrBgggauSz9OVZZd0k+xxJ5oD7+ACTWIrgvTgAqTxFNXK3FfO5lXArSMXL?=
 =?us-ascii?Q?i02Ty9eHNhJyfCzS1sPNMzSs1AkMj118HUsBwACVQSgj/NKFZoUPo4pqzels?=
 =?us-ascii?Q?yrtl1ezi5vB+dJgA4qw0X8hdAZMVpq5GWd37ogoANnN/um/uJ+3BttTwgG52?=
 =?us-ascii?Q?7V1B1lE53SziUPmNIUvDVl0xzYHfiXTiRU6ltpVS5iP/qsHCyLfKmhA1W8lG?=
 =?us-ascii?Q?FTYmXTB1dzW532QWeitgmj/2Uy/RnFeN6LBLop5tWHYWUXqjnncSByxvvbHz?=
 =?us-ascii?Q?mMWr9AQJxVuVCQzxPAwfA6NGraxNhr6NnGM8ufXsFcz1Pght8/sIl+db1KEQ?=
 =?us-ascii?Q?+wQJuAZkLRb91sdmZ5/LAOhBMN8+eljpovXAnefPBAI1Ar7rQPNV82Ijsl8f?=
 =?us-ascii?Q?mGzvwmacETVm7f7X7copu/uD+ATHrEr03DiYbaonNBw+dkGgqUyIekuCaQC9?=
 =?us-ascii?Q?wZhyYJL96bcMxCmENRQL2rwQYQq5Hhr43vnUPPNJOhzwmAE6MQx4px0wBnQY?=
 =?us-ascii?Q?ZnmwInu6kDb2s9Ug403r+MHAbnifCAsHbwRu+dzlpQok7axQAhPJFohrd1I4?=
 =?us-ascii?Q?I88RVgoMPs3Z0I2EAmkoB/lZUFHWMy/QYHUk8WHKAO88DJuFLjjaqtPRAZf4?=
 =?us-ascii?Q?OIFGl3dNWSsh1OvG1/mgolsogv+OP33DbkZRADdLWu+bhXmt8nOhq8DVzrbI?=
 =?us-ascii?Q?sahuwdqkdYh1JDXd2MfcdBoCS5S6W/EW2sLsusFa06OmkIacrZcHip8wAx9+?=
 =?us-ascii?Q?03o602XXh6Btj89f9Da55mTrry/CXCp/bCYwIVkSHCibB8xWw2MJZg2qeyWD?=
 =?us-ascii?Q?oKB6cX38VN/fQ3NUrA8mjkpdCgg6anOlIYUgR14TBTIXXui5sT0PpxVR1xbC?=
 =?us-ascii?Q?WU/hb48iRbgKBxabOX4Qlc/dW7HDz7nbwy5pKzYK4/ZN5UjQNXHBaQjEcb7q?=
 =?us-ascii?Q?zHOg30vL9uGmjAAlXodK6DyGHXpnQ5eJi+pSvVCu/NML7hNxLjxfNJKyakjE?=
 =?us-ascii?Q?WktovMuswF3wScIvgLjwy1K+k+Miaw0CghFdIztQlcZzQw0Zr5tPXLpceWlG?=
 =?us-ascii?Q?hWylE63DeWNXYbwlAeK2PKz/eUS03bbRd02mkVWDDtmjLcCHOmsdxBiSWJlO?=
 =?us-ascii?Q?bIOtbQdBIHszt8xzJqJDYoIfmbPbPUNecBy0rkcXUL7LEOLM+qqaeYLNPWir?=
 =?us-ascii?Q?UUqCl+PEw2ydZR9fnviZGNKaVPdKqYfm2dQ+MI27c5B6CDPIZ2yGlAQp4UHN?=
 =?us-ascii?Q?HtTYoZg1dsj+w77IH8RyxpUm68yzsphfgFbWEsRDKxTLRRvKVeNtl8EgvbO1?=
 =?us-ascii?Q?woP9zGaulwpYr6p0TUBoNm2jkgTSPVAya2vuQDIA09IlIYNS9BoHzZIu25/8?=
 =?us-ascii?Q?jmVcAz9dH4+uy20A2TqNLjKPJ9Hfe4M7iz1LBY6Qj/aZ7F+hOXUBH0ZhLFf9?=
 =?us-ascii?Q?HUBXr83qF8isr5cW8uXiFkL+atTxwoi8xsEdtjTHfSqJ4AamDSjGzOr9t2+S?=
 =?us-ascii?Q?NI35ZTIyrAUyAcAntAKFsfKYLVprhS77EkQ+d2H6Q4NZN93BKxBhTNO0De4l?=
 =?us-ascii?Q?H0KNZK6hoZca4LJ1gK9HdTN5R7TOIWZaY5fHIi+ivniQVzzc5JWrmUo8N+/F?=
 =?us-ascii?Q?zYnX05FG2052rdySR4qRUQw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78D20D365D61D94582C1CF279A7E36A7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3KrQCwoftd1hgz1vsTVmNR1fyC+0/eidCtk25iJfgqlmgltVGPU4hl8bCukd9m6zHGSZgkZJcVyCsmyRTCueNusUTTdMSAP1PynELX41UYIIbE+U9QfZTRnS3s4tGp2YbS/d+b9t2YTWrYpuwjMbFqTN5Lmsbe7hi7IeQkdf96DhvE7nB9to1ov/HX9CPqVczWckKiAEck2/CkJUjb8gq86bTF2epSGP43FBxEjPqyQIfmr4SlTEn4SD72GNVSTIRb52pKrPzwf4C5Bvbmw9EdY65KZ/uih9STnMbqg3Au0sjs12bp6bSSMgG54hCDcOWayuNb26nSzs6PeTUfXDhQTBnM8+bA4pfM9UHYf6KZFYABpDYx0PwO2NVSfe2Wep82OC/6DZBzUH+45KkhpkCb8LmzP4b9jdXHelcEB8D6aCWR62hr3tf9Xka8NcHZh9lo3y8HfYOcjozhHYu7UcjjcY5bSG0lDYInh/7SSpeqMdaiQ1xMpioJ6Rn0Xgcpz2iv1EfXHHVcnljJGNmLyv0cgyIASprWTwF0VGoA7l4EQLIHlPI8z5MpEmnYCiVODrznMDgzULSt5STwX5UpzJAira4uiY6l1IwnAN1uiFKyYyl9ARIQaZyAu1RAn0cvrK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c38fb0-a3aa-4bec-063e-08dd5165a691
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 04:18:38.4443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9hLpILp0aVPal7801mMRzpGMBUyPRLJIl6gJl/TvEcTc3F32Q96zakHVp00W47U+p7x7ybIhUiq7zcHohg0kTlfzszinZ1iB+Z7fM/mWwps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9676

On Feb 07, 2025 / 15:55, Alan Adamson wrote:
> Changes in v4 (per John's comments):
> - Verify sysfs_atomic_unit_min_byte attribute (nvme)
> - Perform atomic write test using sysfs_atomic_unit_min_byte (nvme)
> - fix spelling mis (nvme)
> - Remove tests that don't use the RWF_ATOMIC flag (scsi+nvme)
>=20
> Changes in v3:
> - Remove _have_xfs_io routine and use _have_program.
> - Comment cleanup in 0001
> - Add SKIP_REASONS when xfs_io -A option is absent.
> - Keep lines <=3D80 characters.
> - Move device_requires logic in 0001 and 0002 to common/rc.
>=20
> Changes in v2:
> - Add additional comments in common/xfs
> - Remove xfs_io and kernel version checking
> - Simplify paths for sysfs attributes
> - Fix failed case output (missing echo) in scsi/009
> - Add local variable that sets Test # and description (test_desc) for scs=
i/009 and nvme/059
> - Only use scsi_debug device if no scsi test device is provided.
> - nvme testing done with qemu-nvme.
> - scsi testing done with scsi_debug and qemu-scsi (no atomic write suppor=
t).  No testing on
>   atomic write capable scsi devices was done.
> -------------------------------------------------------------------------=
------------------
> Add tests for atomic write support.
>=20
> Tests will be delivered for scsi (using scsi_debug) and nvme.  NVMe can u=
se the qemu-nvme
> emulated device that supports Controller-based Atomic Parameters (QEMU 9.=
2).
>=20
> The xfs_io utility delivered with the xfsprogs-devel package (version 6.1=
2) is required by
> these tests.
>=20
> The Linux Kernel 6.11 (and greater) supports Atomic Writes and is require=
d by these tests.

Thanks for updating the series. I have applied it.=
