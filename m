Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A073512CDAE;
	Sat, 29 Mar 2025 09:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743241541; cv=fail; b=GewjcYM6UiyWyibvkyfhnx1Sj47iXsABgm2aYJY59H/etDmbH0jtMLUtR2ya7ZQk+qT3SyxmXUB+5VlzWwKqoRm29/0fOsrbXrcnjk+17Ubtp+B0btmAxXpg2vQ2mmTFryLB2UoLtD6TN2zz6jNK/diYXpAaZOv0tERRtv01w3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743241541; c=relaxed/simple;
	bh=ZzhwFp8WCjlSjPmnlzUKe6o2sEkpXTFGNH5pRrOqJJ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lV5PRecP1Zr8F9xdXTf25sWvost8UG8DH2LZp+ZJT8v9CRtmrVR68BMDhbYZ1+zK9HsFc+KARbD9TYBjj5pucbRCWUv9aWK/V3/XfDsGa4Lm8psNSdYtG4qtUdoUN3L4jWnkWCeGsKSJPo1kQ4jGPSNW8yfn4k/11W2gY3TeuYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=BRT6y7Lj; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="BRT6y7Lj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1743241540; x=1774777540;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZzhwFp8WCjlSjPmnlzUKe6o2sEkpXTFGNH5pRrOqJJ4=;
  b=BRT6y7LjY1SkgpCdo+Ceqv487eOla5JOt8mlgTs2u4qzlr7CwSnIL0Xh
   biAkxatkkYbgkHW3XJq/EO6ZC5JCxN39haTw04+3LUm3RaoLwovvtm6yw
   3mlYCvHd8fZbdfNkwrkOAd09OW7p5CUOqdkR5gl+lMhEppXjwueBehVkb
   hxjsZXNhnSH7VKEC4ZUOgBhS0sJ9Z8h+zRwh+5tVWTGI/11jEqfGOr6KG
   FBEe7EQCMFBj6quijCDc9pg0qewpygNQIbLt5p1Hk4fmn9+d0HqxzAv3V
   5jOetKiPBBkSOvqV3UI3LIvd9VwdiGg2X276CkYnwSzURj5XC7lhHnTpa
   w==;
X-CSE-ConnectionGUID: J0ta+RzUTCud13h9mUtVQQ==
X-CSE-MsgGUID: 6tq1TcRZSLWWJHXJWoC2zg==
X-IronPort-AV: E=Sophos;i="6.14,285,1736784000"; 
   d="scan'208";a="63904353"
Received: from mail-mw2nam10lp2043.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.43])
  by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2025 17:45:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPoMJDM3yqU4oahfzu8oZbmnHDvrJC8pMKDVe145lJJzoIg1E8SiVVzf38nzETtr0ryqx3v5dxvhWHZJ7Tz1Pl/0rY4HnXyvTsLXnMSQE/KHIfd9HOmVnDZb80OYihwxsUpxjAs06Uly0v1OO6i1pYC/jCmmC1yoy+q4UkztSzGRRgYfwbr04R/AnOJpfP+pujjSg82MSv944xFjcTVxcGdh6+KrNXKxuTdSnhNVVo/TE+rbgpGyw5oeFqlz1XDAY37Uggf75Cs3CL/AcbPdrcS8cwQnJPPvEb8yQ4eorxmjbhFZLE3soqioIkruMfgqQ4v2Fl4+9I9tZ7GSydN6aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzK/9njUkxiqTBWOludQCP3B0bjvETskAjpnR2qU914=;
 b=sHvgegdy8S8jO41vqoIwoHrl3unrK/3ExATxHaknvAnFZCYwdN4PNsSvj8gdnGQz2NtuMphIozPo0tmrfW7/7J/19KvGchhGCpoPgta0Ti+CGTKbVTBsMmzFOxyOYbtoVjdkUz3LIW+jvjoiEmUjhtJ5QIjYccbyO/gjnyq9ZCupYoavN2cEzx6Q5JVqoGt8LCeGF6ovIBz6uz8dVm5hItaBdUQLncv5jwGJNMkMQ0Ze7UvlzFfUG/7kzH9TPAogThp8ZJGhxJXD3+roLfBkjxBUjcQWCkm6s98IDThxeBR72UyHYF53U52BVDtzkvtw9tFZYhJfpZ9ZYinr7GmLOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by PH7PR16MB5036.namprd16.prod.outlook.com (2603:10b6:510:15a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Sat, 29 Mar
 2025 09:45:36 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d%4]) with mapi id 15.20.8534.043; Sat, 29 Mar 2025
 09:45:35 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, open list
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] scsi: ufs: core: Rename
 ufshcd_wb_presrv_usrspc_keep_vcc_on()
Thread-Topic: [PATCH v2 1/1] scsi: ufs: core: Rename
 ufshcd_wb_presrv_usrspc_keep_vcc_on()
Thread-Index: AQHboB6B3gu6WCxyDk+DGuS6elEXLbOJ3i3A
Date: Sat, 29 Mar 2025 09:45:35 +0000
Message-ID:
 <PH7PR16MB6196F65E925B22880D0DBB2DE5A32@PH7PR16MB6196.namprd16.prod.outlook.com>
References:
 <02ae5e133f6ebf23b54d943e6d1d9de2544eb80e.1743192926.git.quic_nguyenb@quicinc.com>
In-Reply-To:
 <02ae5e133f6ebf23b54d943e6d1d9de2544eb80e.1743192926.git.quic_nguyenb@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|PH7PR16MB5036:EE_
x-ms-office365-filtering-correlation-id: f3a918e3-66b8-49ef-4792-08dd6ea6749b
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|10070799003|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?eO9fhf2QwFfVmEZQoHOROsn+pRUPxRvXKfuGW9kLNem0ZNbSLVFzvitjlsn4?=
 =?us-ascii?Q?fXldIAoeA5EMAAIgkjNTTUxtTyFgS1BhoN2HQ8b0IEIsiUDV0CyrW6OpqzLN?=
 =?us-ascii?Q?mpdN18MENTjBN+o9vYq2GhrN914nZJBNQM3Y/NfHBqnvKkrPgKg6gkPEq9bu?=
 =?us-ascii?Q?NxxIODl4bxjXlli+w5ol0rxbHY71pfo6tkRiTn8UbfySssgTg9+PkALADrE8?=
 =?us-ascii?Q?EUlaBgROmq28SeLoV8ebRZVMy233bXpHsV8OQV2AxugDQrjIblY6/6421gAM?=
 =?us-ascii?Q?ooNjOQqQG3Xr76ScSCiTqYCNjf8VILGv0gHRDnE3DTglhR8lv3bXi6e6LC38?=
 =?us-ascii?Q?tP1c+UYY888WB9IZckfbQXUiJtOEgrDtXMwGdrg3jtVgKgz+343eA5e4c6YL?=
 =?us-ascii?Q?wX1324zAoXH4iMSUJi6s4d/exFfDqOVf2d1UObl+B6TiqrIafQ8T+orFv3sa?=
 =?us-ascii?Q?mGBUC8o+3f7huPzRanne6FazypqgxNEphQXSwWfefL+V3NZ4xa78yvdfGqCY?=
 =?us-ascii?Q?W0GQqJl/YxuoHVRQdwPTgiUjaRVyCBHhKh5N4DtUuHZ6Wd77YpfKXeQalTyt?=
 =?us-ascii?Q?pqZ1q2WVHt32Hc31W1iiRLll0ZiWXxPEXcQsqZMb/XcwDn46hFJcfB0oWx/+?=
 =?us-ascii?Q?h+ekWgGHOb78f1qQr/9P+6JerDO68B+6Ky+F8fNjmmyxV4h/naKA0BE+ERg6?=
 =?us-ascii?Q?ApGycT5V0SgtVac4/i8WGuyAPO6dTRYfG75O7IouO/QvZzDCE4E7CTakw7fu?=
 =?us-ascii?Q?uN4/nz1jwiWEL3q2k3Eqb0cKz4YlnrnyFbTan8Bz+nQDtdW4w8P1zLl8J+0I?=
 =?us-ascii?Q?jq/wAKolWLQTDsvHnN7Nd/T5tkMiAwyxtPuzxTiQIv8jyD3mLYmYvJg2853p?=
 =?us-ascii?Q?bX8rnP6z2jkAZ8HEFL/MMXats3cfh8Jl7d/lERKZIV1nK5LbBjvaykIOaiO7?=
 =?us-ascii?Q?rS4JYJiO7TwMevM7F2aJSyhci3ZySm2O/93UCXYnojaeofKSGbiJQsy3EVgW?=
 =?us-ascii?Q?yhif90nyDpoimoJjxTLcHikxxwo6Y2Yh638mEJ1GFTmFuipYbRXj6jXpGTug?=
 =?us-ascii?Q?PwJPY7cTQRwM86LE7t578E871S741dz9XUc9v2jTlL96l06hm3uHtJal06e6?=
 =?us-ascii?Q?y+dPf5lVLS2SSa3I1HeWN6tZgvLzhj9se3jm6WV2IhEYE5HLQr7f/I6DmktJ?=
 =?us-ascii?Q?2w6wtu0lEbx2dacsT0OFnNoWwiUSg5DfbxDdiu0oVTgCaG11p9CqmtpsgFaP?=
 =?us-ascii?Q?vNQXipl/9JL5/fC7qgYKF+PCRA7GbH10hzVmpUhm7mZOt9xMbASviTIe4Bj1?=
 =?us-ascii?Q?WMu+XHZh9+4/+8sK3hfwDtImpJsSMydTmOL7DJBLMUiCDmAw1t7Ob8LGyHHr?=
 =?us-ascii?Q?r0nX4Ct5adjdIAyKXWg/LK980RRWpu8W1i7E+PKi9jRK6uSHOc0nWFM8KbKV?=
 =?us-ascii?Q?+2bPKmEoilzk/ssnowdGPGwydv8xdfMi?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(10070799003)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0PvZ49Bnxrb4oWGLODQLyEHi/FWGH6wOJ6P6hfYorqGc4ea6M3iFl8ouyR11?=
 =?us-ascii?Q?qpw/sBj38vDKp1OW3awD40Jt0B8P+2b5Z4TvZXsu4d7KCIStlueafeXnQRb+?=
 =?us-ascii?Q?30Tu8JWiTOXIVfpqFJ20l1qu/QssIeJ6DsjGD4l3o6Sc2zk5M8GTi2P6u40Q?=
 =?us-ascii?Q?IQgSZNX/vsEx3Ww1K+6LRs89xfLNXF2Iik7FemmJ4T29T8aao49ah4YxcAM/?=
 =?us-ascii?Q?CYOG7hfT0/md2MHbj10gh/9tFQrCQe/VsM+dDbZaLK08NbIHu9gcQYzmh0Nt?=
 =?us-ascii?Q?xzkfwnCykRaiizfkLKdBdnD04wkFWh4QX/54Y2HMvoWr/l7OnBcJNd4by9FJ?=
 =?us-ascii?Q?+OPw1HJzDWR8v5fheL7DSEBuXWe752Bmg1sT9D2Fjhu5tIzuJqgw8UrRDxFY?=
 =?us-ascii?Q?vls33utjNN2AdrZOmh/tf144xf6sCiZTJRRNgYftQTGpwXRLy6LNY+nRBS5M?=
 =?us-ascii?Q?xGanBW8GWzW4ndH8BAwqj1Fy22Ds/xGDRLTc+VJIWCuOBdKHMslt59+lkPId?=
 =?us-ascii?Q?eEDx5NLfsNzKzphXLYA69ZVI7bVNrcZ8hb09zegEOLpQKhrOP+PluXR8vkGD?=
 =?us-ascii?Q?H97ixa4QwUWomNKOj9rcVMDBvW+jDfRMKQBrxcVNe2DLsIsjkBJk9Egy29Cg?=
 =?us-ascii?Q?nnkjMPJqXKazviS8JiDSk8wyvRVD4+qb3nX8GZSIHgSh+TVV71OCjHH08CLN?=
 =?us-ascii?Q?6Eydw8i4MZG1WhCm0hifEMXEvnlCET6WVsuTY62esMZeEeyRu7JqHHs0kT0G?=
 =?us-ascii?Q?YZc5T0kWNkgWweeuBsBHdu7FYuT841vKv2rYN4buYJMUaduGcekHGqn9nvYs?=
 =?us-ascii?Q?602MEay6UkQdFmoWjfHnkYWBZZDyFUMUMzOVu2NfiFhu8OM4ehqKBy12bNLO?=
 =?us-ascii?Q?xQfljL4fvtQ7D55W7H7gGSZHSMgJoiwHZLmPPQ3JwgdBQ16KZ2FhOhM7T+mR?=
 =?us-ascii?Q?TSace9GuY0iq1KviJVmPh1/zk7vzEidY1OBYcSQ2+Cq00wyQU+dWc2jdGV7Y?=
 =?us-ascii?Q?j+PlpXPYCX9XnpjMIFoRa5E8YsYYZMkp8+NGREUYDrgc22URdH+eTSI60bHv?=
 =?us-ascii?Q?5JHZbj1SG3YfB089qIGbi0dFHOPuTh+hj7l6BQZ7YNUNcB+j3487Bkx38KFd?=
 =?us-ascii?Q?1+hRMrpa2dP72w+X9UTBj1u/vjxnpiyqSWvpbYuLMD2KA0g4sdG8gUuZXT6E?=
 =?us-ascii?Q?4SiEvH45+8I/vhYeo+Xlcq+zm/iUxiYt8Jl3z+VD45VM7c1CdCkG6uJqluVI?=
 =?us-ascii?Q?LU3cyb5X3vzH+QOaUl2k2wgAcd4TL2K7pyRK16D/B99SGaGEhDy0dRg57NIJ?=
 =?us-ascii?Q?/kk2RwYikN/mCTTVASeOsz0+O3yG7/m+YI2okTXMTlkO+hE91cnwdqo7WvV7?=
 =?us-ascii?Q?yyBHdfQUKuqx/5Hmx6BFB3GKfY9B1eruavrc5IUM+udaNCncZbNwGOjtS6WT?=
 =?us-ascii?Q?US/n8mZ0p7PtQw9g+AmQTNrXeFxiXFa51nnx6o4BcwvpWnbvenW15ScMG+JJ?=
 =?us-ascii?Q?1zSmXrciIoWPUDsbn/nU18hBzG5LdKOQeX5bPB/U12KKPUhSr/gdoCK/7VGp?=
 =?us-ascii?Q?Iawb1jMRoR/JdAo/EW9cPG1xoXHDMYHArXtHq80ekKAbXbjF6ZMMiikLT2B9?=
 =?us-ascii?Q?BMvzPaW7P0OIbqTdCfPTUysJ2fNxYe5pCyOe1zKqMUl3?=
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
	mgUfd6zQP+eJuD85CfiB3nLJ/bkH/MBLg8Z73tbrZ+gWINctN2LC/72XiOIHiPLo/YzrB5BCh5kw9WYaOu1cSqqJMjB1jVJGem/eGwTPZqLnwRcQxxBXi73WLSC/4z8OlR1FyZzrUNp9bE9BsbPJ+Dwj4gUrmUuCnFO57yv5W7RiPBottxpTPL0nUV46DopSmIqIuDWY8IIz/5zwgD+ORBiRBtjxlN3RZ+Vggy683IIojWYXxuU9tKCwX7LXsqGsGnPEZuZXfdSXt641yn8o9jjv/Yu0TxDiSZBsCrL+9yvZmGamD9xzFa8Dy2rajFd6x8RYgbP2s9gjCwuWZBxn6709uTBcxviHVLJ+UNikwzz4S9yQPN7XEnUcqfVVEqUQHwm13TjtW3YtsMVM5u2E/50NxwLt7ZwFU8Es0PAAQBeXFNSpDpgyMKlbvM0BJOgY9FN+pOpPG9ZKF+bw1KIW6hrq0WcA5WH4AdalFkJKuNexGwWqJaQeY97kbvzato2vzOe9tsgoX0sY0olcLP9X/jy4/tzGik1u5qIl7+03RzrrTDR5whq3kpy8pP6ncBTKzi9LU5/HsqZB02UwC9Qz+CzM2SZ4DbWst2/NqtVb+Dmmgo/KrUNaGZd6FJMxPId4jfyE0O21SZNBWSUlbn35LQ==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a918e3-66b8-49ef-4792-08dd6ea6749b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2025 09:45:35.5980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xeEtW59+PD4y/yTAP9NmOGqzE1yePGqerN5bDG+9y8Ve4mzZjxm8aGOujnB12mrfoZrw/TWQHzHjQOd9VtLb9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR16MB5036

> The ufshcd_wb_presrv_usrspc_keep_vcc_on() function has deviated from its
> original implementation. The "_keep_vcc_on" part of the function name is
> misleading. Rename the function to
> ufshcd_wb_curr_buff_threshold_check() to improve the readability. Also,
> updated the comments in the function.
> There is no change to the functionality.
>=20
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
> Changes in v2:
> Reverted to original implementation. Only changed the function name.
> Updated the commit message (Avri's and Bart's comments).
> ---
>  drivers/ufs/core/ufshcd.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 4e1e214..310707f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6083,7 +6083,7 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba
> *hba, bool enable)
>  	return ret;
>  }
>=20
> -static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
> +static bool ufshcd_wb_curr_buff_threshold_check(struct ufs_hba *hba,
>  						u32 avail_buf)
>  {
>  	u32 cur_buf;
> @@ -6165,15 +6165,13 @@ static bool ufshcd_wb_need_flush(struct
> ufs_hba *hba)
>  	}
>=20
>  	/*
> -	 * The ufs device needs the vcc to be ON to flush.
>  	 * With user-space reduction enabled, it's enough to enable flush
>  	 * by checking only the available buffer. The threshold
>  	 * defined here is > 90% full.
>  	 * With user-space preserved enabled, the current-buffer
>  	 * should be checked too because the wb buffer size can reduce
>  	 * when disk tends to be full. This info is provided by current
> -	 * buffer (dCurrentWriteBoosterBufferSize). There's no point in
> -	 * keeping vcc on when current buffer is empty.
> +	 * buffer (dCurrentWriteBoosterBufferSize).
>  	 */
>  	index =3D ufshcd_wb_get_query_index(hba);
>  	ret =3D ufshcd_query_attr_retry(hba,
> UPIU_QUERY_OPCODE_READ_ATTR, @@ -6188,7 +6186,7 @@ static bool
> ufshcd_wb_need_flush(struct ufs_hba *hba)
>  	if (!hba->dev_info.b_presrv_uspc_en)
>  		return avail_buf <=3D UFS_WB_BUF_REMAIN_PERCENT(10);
>=20
> -	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
> +	return ufshcd_wb_curr_buff_threshold_check(hba, avail_buf);
>  }
>=20
>  static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
> --
> 2.7.4

