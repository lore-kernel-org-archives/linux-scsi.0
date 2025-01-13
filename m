Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C1A1CB9EB;
	Mon, 13 Jan 2025 20:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736800134; cv=fail; b=tq3Ij5BWe/ByFCHkByvsfaRaLEhBtnrdU5GFSPnj7vCjt3RFGj2/5WfHL0GQFDP9XvLBHqaY66EGVPAdvYbLJnwuklxu+tEfVwv+wdT4pVwG3xLh+X2iTZ40Sk+ukvrd5rN2ZWDhMS9rE12rq0iV920KT7+PZzYtt4gyTVm3gZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736800134; c=relaxed/simple;
	bh=PIWrr+LDJQJeJp0XsHvUJ+B9QzzDkktSRNHYXYmt4E0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mWAAVU2TGVzLRvuxVMVsHlUwXjwDeSxfX+77vjHQRFMxau42HIELg2DU/sQuw6FhIFaxdWV3O0oraDcyKHROH5Jz0XUzwJTW7KHequnJrqOVhq8uu43lwTYDWJ9BJBIu5KTbmnbwhFORayzr8eACK3O2cFUmsjfTiy1V0U/jHFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=cf12/xP4; arc=fail smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="cf12/xP4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3728; q=dns/txt; s=iport;
  t=1736800132; x=1738009732;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PIWrr+LDJQJeJp0XsHvUJ+B9QzzDkktSRNHYXYmt4E0=;
  b=cf12/xP44Q/zQ23M3xkOETH5CizZKN9o6ZbbnB06EGRSW2nxd4UM0+dM
   1Z9Gv8Ot//t9RcmoFGhiy676UXmiKbCsB6Oj+1XL6QEMkFOptilspSIzu
   W4YpTPsSHYUxKyg04qbb9jgBzgz5pEmQXZSaLezqZUYInG7P0ahh3nn+p
   g=;
X-CSE-ConnectionGUID: prU9ybX5RVWYPLR6JN3N1g==
X-CSE-MsgGUID: K1VcAQ/dRLyqxwTaSKoCcQ==
X-IPAS-Result: =?us-ascii?q?A0AIAADAdoVn/5P/Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVIHghJIhFWDTAOETl+GUYIhA5FKjE4Ug?=
 =?us-ascii?q?WoPAQEBDQJEBAEBhQcCFopeAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELA?=
 =?us-ascii?q?QEFAQEBAgEHBYEOE4YIhloBAQEBAxIRBA1FEAIBCA4KAgImAgICLxUQAgQBD?=
 =?us-ascii?q?QUIGoVEAwGnWwGBQAKKK3p/M4EB4CCBGi4BiE0BgWyDfzuEPCcbgg2BFUKCN?=
 =?us-ascii?q?zE+hCkcg1k6gi8EgjNLgSiCWWeGZocakG8JSXscA1ksAVUTFwsHBWRFHysDL?=
 =?us-ascii?q?TYxJYEnBTUKNzqCDGlLNwINAjWCHnyCK4Ihgj2ER2AvAwMDA4M4hWKCFIFlA?=
 =?us-ascii?q?wMWEYMpYh1AAwttPTcUGwUEOnsFmys8g2t7IkaCG5ZKSYwUoyMKhBuhfBeEB?=
 =?us-ascii?q?KZPmHwigjahAwQmhH4CBAIEBQIPAQEGgWc8gVlwFYMiUhkPjioDFr1leDwCB?=
 =?us-ascii?q?wsBAQMJkEtgAQE?=
IronPort-PHdr: A9a23:x2glORcAPdUu4rYN3g4LbdqQlGM/gIqcDmcuAtIPgrZKdOGk55v9e
 RGZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NCBo
IronPort-Data: A9a23:pSoZU6sYl48iqVu7o9s1V5f//efnVD1fMUV32f8akzHdYApBsoF/q
 tZmKWmGaP/ZZWbxf951PYW39k5UvMXVzd9lHVE+qn09FnwXgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav656yEhjclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuGYjdJ5xYuajhJs/va80s11BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw4vxKUHBEx
 aEiFg88VjS52cCQm5TiRbw57igjBJGD0II3oHpsy3TdSP0hW52GGv2M7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtIYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUofSGJoJwhnG+
 Aoq+UzaWy8RHeXYxQCh42u8mdPGpgD8c4krQejQGvlCxQf7KnYoIBkXU0ar5Pq0kEizX/pBJ
 EEOvCkjt64/8AqsVNaVdxm5pmOU+wUXQNt4DeI38keOx7DS7gLfAXILJgOtc/Q8v8MwADhv3
 ViTkpawXXpksaaeTjSW8bL8QS6OBBX55FQqPEcsZQAE+NLk5oo0i3ryohxLSsZZUvWd9enM/
 g23
IronPort-HdrOrdr: A9a23:lCHDbKMtTuXLtMBcT47255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UgssREb9expOMG7MBXhHO1OkPgs1NCZLUbbUQqTXc1fBOTZskfd8kHFh4pgPO
 JbAtdD4b7LfBZHZKTBkXSF+r8bqbHtntHL9ILjJjVWPH1Xgspbnn5E43OgYzZLrX59dOIE/f
 Snl616jgvlU046Ku68AX4IVfXCodrkqLLKCCRtOzcXrCO1oXeN8rDVLzi0ty1yb9pI+9gf2F
 mAtza8yrSosvm9xBOZ/XTU9Y5qlNzozcYGLNCQi+AOQw+cyjqAVcBEYfmvrTo1qOag5BIBi9
 /XuSotOMx19jf4Yny1mx3wwAPtuQxeqEMKiGXow0cLk/aJAA7SOPAxwr6xtSGprXbIiesMlZ
 6jGVjp7qa/QymwxBgVrOK4Jy2C3nDE0kbK19RjzkC2leAlGeVsRUt1xjIPLL4QWC3984wpC+
 9oEYXV4+tXa0qTazTDsnBo28HEZAV5Iv6qeDlKhiWu6UkfoFlpi08DgMAPlHYJ85wwD5FC+u
 TfK6xt0LVDVNUfY65xDPoIBZLfMB2BfTvcdGaJZVj3HqAOPHzA75bx/bUu/emvPJgF1oE7lp
 jNWE5R8WQyZ0XtA8uT24AjyGGGfEytGTD2js1O7ZlwvbPxALLtLC2YUVgr19Ctpv0Oa/erLc
 pb+KgmdMMLAVGebbqhhTeOKaW6AUNuJfEohg==
X-Talos-CUID: 9a23:C8M5HG304s0hEnQL32RcXLxfAtoYI2zX/CrqHXCJMUJTFp+zEnnJ9/Yx
X-Talos-MUID: =?us-ascii?q?9a23=3AxN/RzA4mxkQVoHPe94gTMuoSxoxLupqlIXlKna8?=
 =?us-ascii?q?iqtCUKhB5ABSapz+OF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 13 Jan 2025 20:28:44 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPS id B01BC18000266;
	Mon, 13 Jan 2025 20:28:44 +0000 (GMT)
X-CSE-ConnectionGUID: eG0qe6rJQz6XT22P+Sf1yA==
X-CSE-MsgGUID: 5xCWmBFlTW+KLH48V9DbiQ==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,312,1728950400"; 
   d="scan'208";a="21594642"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 13 Jan 2025 20:28:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mUvt91hDUUYNl6wA31fLRshI/2yxyGk3pdWbPKmTwgl2v7eweNBxNRC4Aue5aQvPHQajVKwD7UHx8EfNhFek1J6xVTsiNnl/Mc6pKLzypuSxzKOZmtTbfzZuLKgZ+FD1U43ClAuWtTLangOQ+xESNxAAfoR9gQhjmNvTvn0tM9PCVYdvNxXWsIbgy+lrffk3fbcRwJf1x/j4fa8O2dW7VBi+OdAi2bVpswm9VfpXneO090on2MqDWoDLTD0XgG9f98VFpP9Q40Gsu/BMjRWS4PuBkOrulRovYiiShCx1bf7htQgZNuh00+/f3D8tFPM9mU+AIhdJSa5+Vedo/i3e/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIWrr+LDJQJeJp0XsHvUJ+B9QzzDkktSRNHYXYmt4E0=;
 b=vahCdBaz1YBW83bB8faBOFgCGL1MBbs0j4LcCYPcqLOowXOxr4M6PTM6/A8JaW/XwOoVP3ZbYeccwFsUUjR2FA7ghiHxCyJ8g5FiGhBMZONet+PzqQ9tJvXy7aU/ez3DCsq1DUVOQrf8GOEVPhMhU1hIRMBaNBGIWXFdpg/3rGYAts+VUiliGcfQ7esauRgMY8uj6d372AcOL/xP+eThi8SGgUGLxyDXv9ckilUzrVQ1yRnF1louuhMSghny7CdRsZGkte8tDwn8HCiFRyA0wP2lXTHPDVNmHrPkTMWwDkgBZuaTz84X69UXUGNjgOOSvA/zMKGvghWxB5nuCAVwIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DM3PR11MB8672.namprd11.prod.outlook.com (2603:10b6:0:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 20:28:42 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8335.015; Mon, 13 Jan 2025
 20:28:42 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: John Meneghini <jmeneghi@redhat.com>, Dan Carpenter
	<dan.carpenter@linaro.org>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy
 (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar (djhawar)"
	<djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: RE: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Thread-Topic: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Thread-Index: AQHbTDq6HSN+iJUXdEijLsA+yRSpm7MLZ02AgAnDMYCAAC/t8A==
Date: Mon, 13 Jan 2025 20:28:42 +0000
Message-ID:
 <SJ0PR11MB5896ED0B5D190413AA380EE1C31F2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-8-kartilak@cisco.com>
 <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
 <d18ed046-0d16-49d6-b666-8ef8ee20f6d2@redhat.com>
In-Reply-To: <d18ed046-0d16-49d6-b666-8ef8ee20f6d2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DM3PR11MB8672:EE_
x-ms-office365-filtering-correlation-id: 8a459e80-2d41-4364-dcef-08dd3410df45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d0treTY4WThaa1hLWStSSEtqOE5hNEpLd0FxbXI1RmR4aTh1SDdoaVVuemEv?=
 =?utf-8?B?SUhVbTNJMWJOaUxxZUY2eVZIak8zdGpla0t3cXh0Z2JHSDZDUmV5bkhRZ1ov?=
 =?utf-8?B?R2NPdk1iN0IrSE8xYmtxVkc4MG9xNnJrSTFnaS9ZZTliVzJwbW1Bb1ZjMXlL?=
 =?utf-8?B?KzZsYlBQS0xaYXNUT3ZNYnJiWnYyTGdoYkYyRG15SHFoUmZobmE4TDhtaE5N?=
 =?utf-8?B?RVF3ZTcwVVAzY0RpSDI2dlFiSzc2Uk5nOTRoNHNZODQvdmdiZWdERUk2QjFY?=
 =?utf-8?B?QisvT1JWSlljR0JPNDUxK2VCbVYxZWFsS0M1dHJQQUhWYVBLUkdqS2t1M0hJ?=
 =?utf-8?B?Uys3bndacDZWUERCd2FxZjhKVVJPeEpQZzVsRk5tTWNWYWZna0ZaVXBhaVdC?=
 =?utf-8?B?ODEyWlBZWkp4ZUJndjZTYXM5Ti9waFBjUEpxdXRFOFBZT05zaHNWdFBWUUZr?=
 =?utf-8?B?L0h4RzZZOHBnRFJHUTdoT3AwMU9SKytMNzFkRzc0S0lzNEVJTkxxMW5ydlRU?=
 =?utf-8?B?YWtqTXl2akpSVlJXVzNwTmJxM213ZnczN2xNVEhRV0JncWQ4ZFBGRURWaDBC?=
 =?utf-8?B?Q3c3dUdxeEMvM1J6elQ1eUd4SWNyNmg5WFhmYXY1YzRtT3JhdkpLN2ZmU2h5?=
 =?utf-8?B?bmdEdzVsV2RpRlgyM1ZyMWVpQUlYcnVTdVhHT3dVZ1lpTGR0MURmc2lCbEp4?=
 =?utf-8?B?My9icHZmZlU5OGl2dUNGbHpwS2t0TXppYzZrS1hrTUl5RE5FMFFRc3NZWFEy?=
 =?utf-8?B?SHNrajBoTmhhRXhvbXdlTFJ0MkttdmovY2tFWWF1M3BHR2V0cW5kMzNEZjE1?=
 =?utf-8?B?LzJKQ3NBWE4rbWZaY3VQZlpDdE9QckRvcEpCYVRvOWlRWDl3YmtQM1piV2F6?=
 =?utf-8?B?QUVXaktDVk9QcyttWUVqM3hwZ240T3c1RkFHMFNOcVlWeFBrSStRTCtEcEdx?=
 =?utf-8?B?MXRlc3JHS3IwMTByM0N4RTlHdWloY0JVVVZyNVFYQ2N2OGxxTkVMRjhjOGdw?=
 =?utf-8?B?VndmQjJpVW9hTWUxejYxOGtRZGVLU2xYcGV3QThyelhMQzZqTlJrcitudmJr?=
 =?utf-8?B?TGh1aFhnVGZwTUhWbHZaQ0RVbHlYQm1wQlRQM3NhSitYRENWY0xwVUZTdEZk?=
 =?utf-8?B?UXg5SHBsaXdGL2JmdjdNWXVRMCsxZUhCMER5NStBQ1c3NGh0WmhHV0NRSFcw?=
 =?utf-8?B?c3NDNWtZNk1ENlNxaHR3RVhkenlSdnZGUmRmTklrTitoWmFGNko4NVV4MzJF?=
 =?utf-8?B?VW9zd1FuL0Iwbm5MRlQwNWcwVjFlUFIvSHY0am8xNzlpNFluUU13cS9QaWNo?=
 =?utf-8?B?dVNJRHJIdkEzemdkV1ZHeXBhbFkyRWtoUDc5b0c4VHNhWk1qTWQ2a3FTR1dC?=
 =?utf-8?B?dGk4azBicHRpaUt6QUVLQTBlUjhHSFhnRDkyWFF0ZnJ1K3NncFlFMlpDVXZD?=
 =?utf-8?B?Sk9NMUpxZW9lNS96WFNIb2toZFFzZ0FwWDU1N1JmOUtQaEYvcFMxNlNiNmNW?=
 =?utf-8?B?bUF0QUVwaXRmeFY1YUtJdy9iVTJ3Q1FSVWhNQzMrYVRlUmRzb1J2Nkg4R280?=
 =?utf-8?B?T3ZwMTJ0d2xiNjJnaU1GSEYreHR2Z1ptWGtIMm05a1kyVDRBR2IzdnkwMFZr?=
 =?utf-8?B?RTBlZjAwQW5TRHd5bXRTRHQycWkyak5pQTVKQ3ptelBxQ3lKVXBnUmRzRnRI?=
 =?utf-8?B?Nkhsd2pKVVQ4bjRucFNQMTl5NmM2TDJUNmRuTnZMZEpsOUQrM0p1bmpkd0t4?=
 =?utf-8?B?YnRCWElDWDZwQ1hqTGMySllOUVprSXRxOEsveVh0Mlo3U2xrUWp2WWdwMERD?=
 =?utf-8?B?NVRCZkxPRFU1RkFkOEI3eWVaYUJXZ2JISUFMaGp4ZHYvTjlNVmdNRktyczBn?=
 =?utf-8?B?RE10cUkrczV3OFZRVFd5OWMxOGlNZFkvb0gvbmlvbUsrSTlQaHRyZUoyZVdE?=
 =?utf-8?Q?2VTMx8oWbOrp1KVg3x+apmPQuluW9ITp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WjVrM1A4aFZrYWpWUmsrR2EwOXVIZDNvWEFrZXo4VEk2b0duS1VGd0pwOHkr?=
 =?utf-8?B?SHAvMThRS1F5V0VYdVRvQlVhWDRPRkwzaFF1ajYxNjNaTUdrUkJkM2VQVmRo?=
 =?utf-8?B?Qkp2K2RWM3U4V0h5OWhKWjRXRCthNktSa2N0M0trMnRCSFhQeE1yZWtJdGwz?=
 =?utf-8?B?NXFNaTNBeVU5N2FuRkFNNE9VQ2hhSTljZVZHcm5mNU9LNFZKWEk0RUF4RWd0?=
 =?utf-8?B?WkhvSzFzQzF4ZEQvTXRncUQyY1RoYktSNlhnWHdoT01RZEVKTmtVdjkzZE9G?=
 =?utf-8?B?Qm5rNzdpSUNhNEtLZjBGZ2lsd21mUFdwa2NoazVBQWhudFFXTnZSeUJXQWNk?=
 =?utf-8?B?dHhYSDQ5MHpOdG96L28xMWEwN1grc1JoaUovVlpCbnVxS25mTnNJT1Y5L2o4?=
 =?utf-8?B?N1pEV3BrTk5QNEhyZDBlanhxNFN0bjhsc1h3M09lQWxIb1FDQ3ZoVzJ0bkxu?=
 =?utf-8?B?ZlkwRXp3RTlhTmYzeTZ4NHBwYkFsZ21LSjh4S1lWejVhNkJPcTZSeTdzWXdU?=
 =?utf-8?B?aXVlc3BWTVpwMU9DMFFxaUoxT3BNMFF1Vm1Eb3poajgralFlUHFDUTNTU25L?=
 =?utf-8?B?bGJBdnlqc2xjTElvSlFXN3BDdXhaTU56L0ZWZElTdlMzcmY3TG9aRkl3VCsw?=
 =?utf-8?B?aGhLRkppRGdXZVVHUFJlUXhHT0hVMHpyOUhBYUVzMjhQcTRESXFOdVJzUkE3?=
 =?utf-8?B?OVVnVmpicjg0aGgyNlZEWjNMdWFkSkIwWkJTNFIzMWNnVDF2N1dXS1N2NmEx?=
 =?utf-8?B?ZWw0QmJIZHMrQUpWM250TUptR05HSFJ5VkVyd1M0M2FGVUVZaUJnTkRodUFL?=
 =?utf-8?B?OVBHTFdnRzBtYW5nRlN5Q1htamRqeEltRk5CSTFvemMxZUpFenBDZ0V2dENz?=
 =?utf-8?B?T3B4clZBNG9LdkVaYjM1ZS9KZVVRWFNtRWVtbVllMGxzOUltcFZkeWtlQ2M0?=
 =?utf-8?B?b2pWSEwxVWE0NWFRYUlLYWlJMUNrUTkzOEFZVFNhOFU1OEZWM1ZvZXZ4M0pY?=
 =?utf-8?B?dGRWak41ckRYbE9URUZjd3ZUdFJ2KzhIY1ByZVd0SjZvSHVGWFFLemx5cDFU?=
 =?utf-8?B?WGlMeVF6UnJnKzVIOWxxbldlbkNGSm5ITGN2bmNwN2NVSWVESjZuMGc5UmNp?=
 =?utf-8?B?UDBYM2tXUjJmN21WMkUveVl5UURnL3hnd1pOa2RqVjhIb1gxSWdqdmlXdDJK?=
 =?utf-8?B?MG0zTnRHeXVFRHJCbmRSMmhQZEJwZjJvWDEwWDdKd3FEUkkraGJPcUs2Znha?=
 =?utf-8?B?UWJZcTVUbnNhZ3RkSHBmS2ZDN1Q0WmtDWCttQ0pGUjg0eXJxelM2NlhLOGFI?=
 =?utf-8?B?WFJHeTMxWHpNK21KNjh0S3pJdWc5eEhIRGtlZXoyQVZ2bVJvTFlOeUVJclh2?=
 =?utf-8?B?MXNrM0NXOUlaaExHUS9ZR0psU0dNWUR1RkdoYVY4QWo3OW9OOWpHNklWd3lE?=
 =?utf-8?B?d0NKY01KRmM3RGhaUXFWT0RSUmZHMnJuQ2IzT2pNL0tIdE5OT0hSZk9JV3RC?=
 =?utf-8?B?SzkvUnR0aVdDY0dlWFNTN05JdWQyR1gyQmlCV0VXdW9zRmcrNHlBWk4wMzVt?=
 =?utf-8?B?Z2NkYS9WeWs3WXlqeWYwWFl3VFZ2S3BQZng5ZGNIRVRBWU5melF1SVpocDFV?=
 =?utf-8?B?clg3Wm9qdXVGMUhGWWwxOVlZTFZYVk1qMFRtMUlkV1RBRTBVeHV3SGlYbDRs?=
 =?utf-8?B?M090UXZ4QlRieDlvalZYbVA5ZllTYjdja3F4N0dUMzkzYmJJZ3FlZUVPTU9J?=
 =?utf-8?B?djBBYWlWUXpUWDdZek85Q1FyWEFtbm9nZHBPb3REVC9GUGJrdXAxU2p5am5q?=
 =?utf-8?B?bFJCR2JmenVZQnVETWFMRWFjVmtVVzU4dnc2U2E5RStUWDg3U0tSb0ljdFNH?=
 =?utf-8?B?M21wTGlZSSs0WjMrazVFQk5tdUEzdGpOdXFrazVjNWxjWnFSYVg4MzVwYktV?=
 =?utf-8?B?cHZ0QnA3ODFQNEFVUWtGMHZ4Q2VJa0lENlkyTnk1QnpmTzM5blUxemV2bita?=
 =?utf-8?B?WEJvUWFOT213aEs3ZGZ0TFVMeFFJZjZNUjVxQlpjNU1vVlY1VE42dEZ3YkRl?=
 =?utf-8?B?eXRnRFdSbHlZa0VNUjJDSkpKTmxHV1o3ZlVveFNvYUZ6SHoybHUxK3FPeFly?=
 =?utf-8?B?VDc2R3hEU2FCMTA4ckh6Um1ENC9DVk9IZlE1Q0QxZ2hNSWVxeGd0Nk1JbzR2?=
 =?utf-8?Q?tyljCmLKzTHyoE70Dolo18onC/PArgFP1m+9xL+R+2Dm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a459e80-2d41-4364-dcef-08dd3410df45
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2025 20:28:42.6473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anBbcJsaOxnHR8x150GONoIdSC+ahlYmT96pu6mKpzPu19JfmTFgzQ5k2iDPEFXp064GIHbGJEmjhI3bucVoiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8672
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: rcdn-l-core-10.cisco.com

T24gTW9uZGF5LCBKYW51YXJ5IDEzLCAyMDI1IDk6MzUgQU0sIEpvaG4gTWVuZWdoaW5pIDxqbWVu
ZWdoaUByZWRoYXQuY29tPiB3cm90ZToNCj4NCj4gSnVzdCBhIG5vdGUgdG8gc2F5IHRoYXQgdGhl
c2UgcGF0Y2hlcyBhcmUgaW1wb3J0YW50IHRvIFJlZCBIYXQgYW5kIHdlIGFyZSBhY3RpdmVseSBl
bmdhZ2VkIGluIGJhY2sgcG9ydGluZyBhbmQgdGVzdGluZyB0aGVzZSBwYXRjaGVzIGluIHRvIFJI
RUwtOSBhbmQgUkhFTC0xMC4NCj4NCj4gSSB0aGluayB0aGVzZSBpc3N1ZXMgdGhhdCBEYW4gaGFz
IHBvaW50ZWQgb3V0IGFyZSBhbGwgaXNzdWVzIHdoaWNoIGNhbiBiZSBhZGRyZXNzZWQgaW4gYSBm
b2xsb3cgdXAgcGF0Y2guDQo+DQo+IC9Kb2huDQo+DQo+IE9uIDEvNy8yNSAwNzozMCwgRGFuIENh
cnBlbnRlciB3cm90ZToNCj4gPiBPbiBXZWQsIERlYyAxMSwgMjAyNCBhdCAwNjowMzowNFBNIC0w
ODAwLCBLYXJhbiBUaWxhayBLdW1hciB3cm90ZToNCj4gPj4gQEAgLTYxMiw2ICs2MTUsNyBAQCBz
dGF0aWMgaW50IGZuaWNfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBw
Y2lfZGV2aWNlX2lkICplbnQpDQo+ID4+ICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4+ICAg
IGludCBod3E7DQo+ID4+ICAgIGNoYXIgKmRlc2MsICpzdWJzeXNfZGVzYzsNCj4gPj4gKyAgaW50
IGxlbjsNCj4gPg0KPiA+IERvIG5vdCBpbnRyb2R1Y2UgdW5uZWNlc3NhcnkgbGV2ZWxzIG9mIGlu
ZGlyZWN0aW9uLiAgR2V0IHJpZCBvZiB0aGlzIGxlbg0KPiA+IHZhcmlhYmxlLg0KPiA+DQo+ID4+
DQo+ID4+ICAgIC8qDQo+ID4+ICAgICAqIEFsbG9jYXRlIFNDU0kgSG9zdCBhbmQgc2V0IHVwIGFz
c29jaWF0aW9uIGJldHdlZW4gaG9zdCwNCj4gPj4gQEAgLTY0Niw5ICs2NTAsMTcgQEAgc3RhdGlj
IGludCBmbmljX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2Rl
dmljZV9pZCAqZW50KQ0KPiA+PiAgICBmbmljX3N0YXRzX2RlYnVnZnNfaW5pdChmbmljKTsNCj4g
Pj4NCj4gPj4gICAgLyogRmluZCBtb2RlbCBuYW1lIGZyb20gUENJZSBzdWJzeXMgSUQgKi8NCj4g
Pj4gLSAgaWYgKGZuaWNfZ2V0X2Rlc2NfYnlfZGV2aWQocGRldiwgJmRlc2MsICZzdWJzeXNfZGVz
YykgPT0gMCkNCj4gPj4gKyAgaWYgKGZuaWNfZ2V0X2Rlc2NfYnlfZGV2aWQocGRldiwgJmRlc2Ms
ICZzdWJzeXNfZGVzYykgPT0gMCkgew0KPiA+PiAgICAgICAgICAgIGRldl9pbmZvKCZmbmljLT5w
ZGV2LT5kZXYsICJNb2RlbDogJXNcbiIsIHN1YnN5c19kZXNjKTsNCj4gPj4gLSAgZWxzZSB7DQo+
ID4+ICsNCj4gPj4gKyAgICAgICAgICAvKiBVcGRhdGUgRkRNSSBtb2RlbCAqLw0KPiA+DQo+ID4g
VGhpcyBjb21tZW50IGFkZHMgbm8gaW5mb3JtYXRpb24uICBEZWxldGUgaXQuDQo+ID4NCj4gPj4g
KyAgICAgICAgICBmbmljLT5zdWJzeXNfZGVzY19sZW4gPSBzdHJsZW4oc3Vic3lzX2Rlc2MpOw0K
PiA+DQo+ID4gS2VlcCBpbiBtaW5kIHRoYXQgc3RybGVuKCkgZG9lcyBub3QgY291bnQgdGhlIE5V
TC10ZXJtaW5hdG9yLg0KPiA+DQo+ID4+ICsgICAgICAgICAgbGVuID0gQVJSQVlfU0laRShmbmlj
LT5zdWJzeXNfZGVzYyk7DQo+ID4NCj4gPiBVc2Ugc2l6ZW9mKCkgd2hlbiB5b3UgYXJlIHRhbGtp
bmcgYWJvdXQgYnl0ZXMgb3IgY2hhcnMuICBGb3Igc25wcmludGYoKSBhbmQNCj4gPiBvdGhlciBz
dHJpbmcgZnVuY3Rpb25zLCBpdCdzIGFsd2F5cyBzaXplb2YoKSBhbmQgbmV2ZXIgQVJSQVlfU0la
RSgpLg0KPiA+DQo+ID4+ICsgICAgICAgICAgaWYgKGZuaWMtPnN1YnN5c19kZXNjX2xlbiA+IGxl
bikNCj4gPj4gKyAgICAgICAgICAgICAgICAgIGZuaWMtPnN1YnN5c19kZXNjX2xlbiA9IGxlbjsN
Cj4gPj4gKyAgICAgICAgICBtZW1jcHkoZm5pYy0+c3Vic3lzX2Rlc2MsIHN1YnN5c19kZXNjLCBm
bmljLT5zdWJzeXNfZGVzY19sZW4pOw0KPiA+DQo+ID4gU28gdGhpcyBpcyBhbiAwLTE0IGNoYXJh
Y3RlciBidWZmZXIuICBJZiBmbmljLT5zdWJzeXNfZGVzY19sZW4gaXMgc2V0IHRvIDE0LA0KPiA+
IHRoZW4gdGhlIHN0cmluZyBpcyBub3QgTlVMIHRlcm1pbmF0ZWQuICBUaGlzIGlzIGhvdyB0aGUg
YnVmZmVyIGlzIHVzZWQgaW4NCj4gPiBmZGxzX2ZkbWlfcmVnaXN0ZXJfaGJhKCkNCj4gPg0KPiA+
ICAgICBzdHJzY3B5X3BhZChkYXRhLCBmbmljLT5zdWJzeXNfZGVzYywgRk5JQ19GRE1JX01PREVM
X0xFTik7DQo+ID4gICAgIGRhdGFbRk5JQ19GRE1JX01PREVMX0xFTiAtIDFdID0gMDsNCj4gPg0K
PiA+IFRoaXMgc3VnZ2VzdHMgdGhhdCBmbmljLT5zdWJzeXNfZGVzYyBpcyBleHBlY3RlZCB0byBi
ZSBOVUwtdGVybWluYXRlZC4NCj4gPiBIb3dldmVyIEZOSUNfRkRNSV9NT0RFTF9MRU4gaXMgMTIu
ICBTbyBpbiB0aGF0IGNhc2UgdGhlIGxhc3QgMyBjaGFyYWN0ZXJzDQo+ID4gYXJlIHJlbW92ZWQu
ICBMT0wuICBJdCdzIGhhcm1sZXNzIGJ1dCBzbyB2ZXJ5IGFubm95aW5nLg0KPiA+DQo+ID4gQWxz
byBzdHJzY3B5X3BhZCgpIHdpbGwgZW5zdXJlIHRoYXQgZGF0YVtGTklDX0ZETUlfTU9ERUxfTEVO
IC0gMV0gaXMgc2V0DQo+ID4gdG8gemVybyBzbyB0aGF0IGxpbmUgY291bGQgYmUgZGVsZXRlZC4N
Cj4gPg0KPiA+IHJlZ2FyZHMsDQo+ID4gZGFuIGNhcnBlbnRlcg0KPiA+DQo+DQo+DQoNClRoYW5r
cyBmb3IgeW91ciBpbnB1dHMsIEpvaG4uDQoNClJlZ2FyZHMsDQpLYXJhbg0K
