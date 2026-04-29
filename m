Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C195286430;
	Wed, 29 Apr 2026 21:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777499285; cv=fail; b=Db379g+HWMawsJcGU6ZC7BLJahORLhjcmvaM3ZAfYYIjy9uG3QcC0x4EtMQOslRfHXSljwsaFMjyr1tnsjqr3B6TnUktwnCLPpR73zDr9hfXeCrnb6SjXHh2YtSqJfNY6/NQG43AllWDy2xNVHpT+AmUEgdaxOGy25U388s64BU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777499285; c=relaxed/simple;
	bh=OnfTwzuHuIxlr5i+Q/vhKCsTlG0RZUQgBysa/XpbCvY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jy3uF/AelW8ov/yEcEyrzfpx41Z3VridnC8+4X7PPps+SRrj5k3H8rYAm1p2e4cQ4ppXUav8kp1hkN894vTGkQtOI4aUxxv38xjqwVbsKYYa2/TOQTg6eB68Yq0rxZ8p1hkLCR12+Jb07Lw1KMYsRyOvBAP1DbcIgRWA7nItuOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=X6vAOuHu; arc=fail smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="X6vAOuHu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2165; q=dns/txt;
  s=iport01; t=1777499283; x=1778708883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OnfTwzuHuIxlr5i+Q/vhKCsTlG0RZUQgBysa/XpbCvY=;
  b=X6vAOuHugGtj5DObTSRwyJFicqo1Nvbinmhxpesm3fm5KJRHINI2TpVl
   QY/dg6A/Bs4eik5w2dLSW4rWV3tYRigm2Ed5JpJ/qCQbMDtAheEC4Nc8t
   V2fHnSk17/hS7UNN4tVD5q5IJTE33vpTdKyzUxXWxCz4gje7aDwNQtYDQ
   l1cky3bHgkfjqw/Hx6ij0FNNvuJNUHJ0rpCzsi+OdoUTcJEjHc7ysufoG
   pFM3w6WDJlGL4vKvsrax4RF693yk8awlcHpIA7mPX8pbJw1uV+o+4we45
   Gx+rLewFxUJh5aOfVZlVnvJglUkz3nuZMmRiN/unYhe0QJ617M/jX5rbV
   w==;
X-CSE-ConnectionGUID: 6drrQtpOSBejk16ndDeKSg==
X-CSE-MsgGUID: 2VglecbDQPmTmMVFoR2l5g==
X-IPAS-Result: =?us-ascii?q?A0AJAACwe/Jp/5D/Ja1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAWWBFwYBAQELAYFtUxZvgRESSYgjA4RNX4ZYgiEDmDyFXoF/DwEBAQ0CU?=
 =?us-ascii?q?QQBAYUGAo0xAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZchloBAQEBAxJnEAIBCA4DBAEBLzEdCAIEAQ0FCBqFGwM2AwECqy0Bg?=
 =?us-ascii?q?T0Ciip4gTSBAeAkAQsUAYE4AYU+gxgBAYQ8gSFUhD8nG4FJRIFXgmg+hAo5A?=
 =?us-ascii?q?oQTgi8EgiKBDo8WUngcA1ksAVUTFwsHBYEjEDMDIAovLQIUDSIPGgUtHXAMJ?=
 =?us-ascii?q?xIPHRcVH1gbBwUSISpugRR0LFwaDiEkEQNWQzgLSQWBcAKCHhlfIywDTjEDC?=
 =?us-ascii?q?209NwYOGwMEgTUFikYeD4IoBgGBDoIplC2CZY4ljGOVFwqEHKIOF6prLodlk?=
 =?us-ascii?q?HMipACEdAIEAgQFAhABAQaBaDyBWXAVgyJTGQ/WXng/BwIHDgKRc4F9AQE?=
IronPort-PHdr: A9a23:wnOSLxPyFCuGJnUL3hAl6nc2WUAX0o4cdiYc7p4hzrVWfbvmpdLpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:ClxOwq/fT8HRzr9o0AmPDrUDgH+TJUtcMsCJ2f8bNWPcYEJGY0x3m
 jZLCj2Eb/yNNjeket1wOou1pEpU78WDyN4yHgM/rSpEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4mpyyHjEAX9gWAsbjhFs/vrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2loMZcCw/pvJlpk+
 P4bcW4LYjyOpNm5lefTpulE3qzPLeHxN48Z/3UlxjbDALN+HtbIQr7B4plT2zJYasJmRKmFI
 ZFGL2AyMVKZP0En1lQ/UPrSmM+ug2TkcjtZgFmUvqEwpWPUyWSd1ZCya4KJIILWGZQ9ckCw/
 FzJ+2nyCD0jDNmjzB+73HWW3OuSknauMG4VPPjinhJwu3WXx2oOGFgVWEG9rP2RlEGzQZRcJ
 lYS9y5oqrI9nGSvT9/gT1ijq2WFlgATVsAWEOAg7gyJjK3O7G6xHXQNRDpMQMIpudVwRjEw0
 FKN2dTzClRSXKa9U3mR8PKQ6Di1IyVQdTBEbi4fRgxD6N7myG0usi/yoh9YOPfdpvX+GCr7x
 HaBqy1WulnZpZJjO3mTlbwfvw+Rmw==
IronPort-HdrOrdr: A9a23:qMjOSK/AjU5FF2m7Dv5uk+Hedr1zdoMgy1knxilNoENuA6+lfp
 GV/MjziyWUtN9IYgBfpTnhAsW9qXO1z+8S3WBjB8bSYOCAghrnEGgC1/qs/9SOIVyFygcw79
 YFT0E6MqyOMbEYt7e63ODbKadc/DDvysnB7omurQYJcegpUdAd0+4TMHfjLqQCfng8OXNPLu
 vl2iMonUvGRV0nKu6AKj0uWe/Fq9fXlJTgTyInKnccgjWmvHeD0pK/NwKX8Cs/flp0rIsKwC
 zoggb57qKsv7WBzAPA12jc1pJSmNHw4NpODs6Bh6EuW3XRYwCTC7hJavmnhnQYseuv4FElnJ
 3nuBE7Jfl+7HvXYyWcvQbt8xOI6kdt11bSjXujxVfzq83wQzw3T+Bbg5hCTxff4008+Plhza
 Nw2X6DvZY/N2KEoM293amNa/hZrDvznZMQq59Ls5WZa/pHVFZll/1ZwKqSKuZaIMu10vF8LA
 AkNrCt2B8fSyLoU5mehBgt/PWcGlIuAxyBXk8O/uaR0zRQgTRF6nFw/r1Dop/Fn6hNFKWtII
 //Q/hVfL0idL5lUYttQOgGWse5EWrLXFbFN3+TO03uEOUdN2vKsIOf2sR+2AiGQu1B8HIJou
 WLbHpI8WopP07+A8yH25NGthjLXWWmRDzojsVT/YJwtLHwTKfidXTrciFjr+Kw5/EERsHLUf
 e6P5xbR/flMGv1AI5MmwnzQYNbJ3USWNAc/tw7R1WNqMTWLZCCjJ2XTN/DYL72VTo0UGL2BX
 UOGDD1OcVb90iuHmT1hRDAMkmdM3AXPagAZpQy09Jjv7TlbLc8xzT9oW7Jkv22FQ==
X-Talos-CUID: =?us-ascii?q?9a23=3Al+VdPWrJj/3OGqSIKeanYzfmUZ4paGfk0G/3GGW?=
 =?us-ascii?q?1C2UwFruZZVKzw6wxxg=3D=3D?=
X-Talos-MUID: 9a23:0igB3wYBj+Rr4OBT7QHjgDxpPutR26GSDWUzv5I84c3ZOnkl
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-07.cisco.com ([173.37.255.144])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Apr 2026 21:48:00 +0000
Received: from alln-opgw-2.cisco.com (alln-opgw-2.cisco.com [173.37.147.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-07.cisco.com (Postfix) with ESMTPS id 73F0F18000210;
	Wed, 29 Apr 2026 21:48:00 +0000 (GMT)
X-CSE-ConnectionGUID: /+vdXqQoSwqcPP4d6w3rUA==
X-CSE-MsgGUID: T/DiCTq7TPGv2vBT/+StLw==
Authentication-Results: alln-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.23,206,1770595200"; 
   d="scan'208";a="48194197"
Received: from mail-ch4pr07cu00100.outbound.protection.outlook.com (HELO CH4PR07CU001.outbound.protection.outlook.com) ([40.93.20.96])
  by alln-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Apr 2026 21:47:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fv3h1STnWwax3AQLOZ5CQCwnVwySC20PfqpjDLszmbVIOfqIluNGPrSrFO1ovE2J6ZEjjI64mvz5gKK6Ptn1WHO30OzYCnFKhDEhM0konCu1OSV51o14uTWY1xtIH18AOVBLawrLNIXI5XkC1RtNnVzzH7djJopND9GqfrLlJKCYYWAw1F55yQ1IMR9ewugrud9NKUSgCmnK/aaRu97VyEl1Em5AB/TylS/+HfqpfkX2QW5aYbz4hfBuWSQpegO7D3a193g/KmEkbxFesvlPisEW4WogwbgGmAOBNzNUw8x+eKMKeOD9Qk9wjwkDq93aeRSvQ8wQtDCHZtDNC4YqcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnfTwzuHuIxlr5i+Q/vhKCsTlG0RZUQgBysa/XpbCvY=;
 b=Wu+M90sJGynYCAKx0RNSYNnk6FAujdC1NEvQmPDJ/C8zfvcOgf0IoGVkc4XPVbDL2U2gOqGR30hKdyPEEiiaRQwtsOYiwWIP0Y8BQQpjLvY1fdV3NqSqszsn4jfmX0a8xcHnWRXyYJA57mSroPPmqFo8FGXc4ebBxOfYFA/9tW0QhnGGEDOBZjmh7ge+L28Iu/Vm3lj4e9tlKHQ3aUpWVJZyzdPpWRavJUOYLINfS8S32k/8bCLz+krWtH68U6QPBtgyUZPo3fwVbhzG7veyJXaRUbQ0QDeile6izeW4FOKuRM1LqcBfQRXNDDQqNJ25T2tMD9bxTaK+ma99uhTtCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from IA0PR11MB7281.namprd11.prod.outlook.com (2603:10b6:208:43b::16)
 by SN7PR11MB6602.namprd11.prod.outlook.com (2603:10b6:806:272::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Wed, 29 Apr
 2026 21:47:57 +0000
Received: from IA0PR11MB7281.namprd11.prod.outlook.com
 ([fe80::2ffb:2690:fe8a:1d8c]) by IA0PR11MB7281.namprd11.prod.outlook.com
 ([fe80::2ffb:2690:fe8a:1d8c%4]) with mapi id 15.20.9870.016; Wed, 29 Apr 2026
 21:47:57 +0000
From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
To: Evgenii Burenchev <evg28bur@yandex.ru>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] snic/vnic_dev: Remove dead store in
 vnic_dev_discover_res()
Thread-Topic: [PATCH] snic/vnic_dev: Remove dead store in
 vnic_dev_discover_res()
Thread-Index: AQHc173ncd9GU+qmIk25VGZdpEoNH7X2k9D9
Date: Wed, 29 Apr 2026 21:47:57 +0000
Message-ID:
 <IA0PR11MB72814B8E68CB6EFEA02B76B9AB342@IA0PR11MB7281.namprd11.prod.outlook.com>
References: <20260429095212.11251-1-evg28bur@yandex.ru>
In-Reply-To: <20260429095212.11251-1-evg28bur@yandex.ru>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR11MB7281:EE_|SN7PR11MB6602:EE_
x-ms-office365-filtering-correlation-id: bc633b35-58b9-40fa-c98d-08dea638f9b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|22082099003|18002099003|38070700021|56012099003;
x-microsoft-antispam-message-info:
 DACWr26YpBQgl+PIzbOEJWnczFAZ74Lry48UiWJwxTNd1WVzcV3GeoaNZFh3S3srL8yMcCgoPkDTPhLmbDhgj0BM3aI4qRciz/Ev5NUINHecnA8I3z7beOxlZjq3VXtybR+ZJxBgnqLFMzA4ZiJunYMUw8ze46pTpBJPMhaUzoRyCjOPFtHuI4kH592lSlSYXG7q3m0IdQc+tYFx2A05Q+StM165pahUB9cuEjkWaqnJnuL8bPDrQiGbCal1E/chMinqGtY903PohBuFDgJXIPK1AGwUxHTMO75t/t33a24Szo1DMsl6Qhb5R7QHOifs0PqD7aJ0svqVBg0Db4xwlASltxDgN9xxWMFORfIuFxGxHmlv5BDOIVMm4MZUGiJgRb1bv7AD3Zgk5sKsv0Ag53oJE/IKqTvpuxdYBz4qCqsVvJGtrNoDdK1ILYXGRoE5tyIrVC+nBZhZrsfxSXKnG5k/eAWXA6EvpU9W+DWmrEnMnWfGCOjOwunGyKXY11SBQRDRybuEcBVOUoQLFNXJv++zFtWemcSGvHTRyYrymbxKb9oblbfWInhtcBXm+b/qx5uroYUDbnR7FLhYKi1P/hKgGKywzDikc/UXNNveAAzq0KaGy1+gE10QQXGbYQJ5cVjo6prFQiWcobdmM6g6g32g0Kd7GXhBG9DHsZYWF1nV34zDw1/hviFOVqXPX5xfMAz9vVgtUKvIVkn4z+f+htTmemSca/O4EDENUBFO3MAdy2Fo7mQxT40q2w/boC6DfLj3JaU2QvNf0qoiM/HrANad0f8vAtSLbSAa2tVic84=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7281.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(22082099003)(18002099003)(38070700021)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?AodMEC3ESyLSDlWN5+OvHjqfeOBqjgYUNuWmDVjO4hQnaDaN80V7Oqy9fC?=
 =?iso-8859-1?Q?q0zzOKmQPaL3p8XfQyI/sBPKz32PZMxbJBcZ0smHsMt4IW+gfTwYt1UP3r?=
 =?iso-8859-1?Q?fatqeyjoqzJqjTJtjKIIykmx0K2kVi9vkeVA+8xBi3EpriRx2kpFZo63pr?=
 =?iso-8859-1?Q?03Xpaq8AjzHbHCnkgbQAjv7mjyly0W0Z/UwLPWJTj6IkfVnqb1ug2QhjLY?=
 =?iso-8859-1?Q?vKzff1TpdatNJBCysu6AwjP6bNuJvfXV6RDF+yMzJpX/I276NC9AetV9m5?=
 =?iso-8859-1?Q?VFUdTbf+4EihW3M+ZKtSzJ1Dm3vpZTikFBNNkulOFBzOqXM+TP0dFgVLnH?=
 =?iso-8859-1?Q?lzahQoDSlEBRohuasdwuFd6tIWrtKCpt4vZfcb2x1YYNEFVstePIof37b2?=
 =?iso-8859-1?Q?GlmDNcm8g0DWqiPnUDEXzWOc0jcmat7KLXEsgph5RRBozsk2yW3pz2WRA8?=
 =?iso-8859-1?Q?vHw8u+wN+JprO1fr5yVhGY4p/i39TEbx2uNhLnjW+PLZyj/gblhlUNoJqc?=
 =?iso-8859-1?Q?0ieWmjGTd0IUxMCY2hT9C0YAuqz/otE9m497SMzmN1l4N0Ywhr/y1MzJs1?=
 =?iso-8859-1?Q?oQgliSrQFdofTNi1G0qqil50me39mXOAmRkpHlFRntLh5eIlc5pTmSJs3q?=
 =?iso-8859-1?Q?+HjZeC5J8deM2Ije+p0rsCrzrtA2+jjg1RC1ZLdB59Zp5ruvtCodWsiMbv?=
 =?iso-8859-1?Q?eS61w+ubxmd79jB97pMisxgWm4qpxLmO0RpuxviFFRbOCT9iAqQLMwjMOi?=
 =?iso-8859-1?Q?cohlpqp/M4GLBCCgEAZdnHPQ/eeEqy7C1A8waAVpmLRz52BCGTfq9Zhwe5?=
 =?iso-8859-1?Q?5mZIGtdbBrfX/OUihJmimwy1BW2N5gWRMLt3FCG34Pa+lVP14yoLnzZBpN?=
 =?iso-8859-1?Q?Zz2hlkbh3Zo/sn0GFdSIrlX9j9vzAOf5FDMlbWpAmEE3cBxxTegXR0wRkk?=
 =?iso-8859-1?Q?FB6hW8BOk6I947FsKF2IRcdiFekONR37N4EYhDIq5k2k74BcY/e/wtgSYL?=
 =?iso-8859-1?Q?Jd6kLLsMHDOsXJMUKsmcy77CAu3jalvkmaWXhUW6vJm1hFZ3URkY66PsZt?=
 =?iso-8859-1?Q?28gdK8jgbEL+OEA7g2ShWfJmKBDrtVIyXSWDGJ7MGlZsuYdFYkfTJb+OI1?=
 =?iso-8859-1?Q?JTSy7Sy5woB8BU00m1TZMHSc3HTnoB6Cr8OjTGsig7881xoCGoSVSApyRJ?=
 =?iso-8859-1?Q?/B8/gkusdWGMIZ1Oxs/VF1htQyQRnQ/EnE3+E8sE+cg1RL6TY+82PV2QJQ?=
 =?iso-8859-1?Q?1MmUfuXgxxKE2eQ7va9WYsqQE9NulKbiIPliflPa1KSBGkXE/eBSiksK6D?=
 =?iso-8859-1?Q?Rq7ao3gW3oGs1eCjoDeZk74ipSa+aRw6uO2fGFO/fIjRmbVvNaxWE/ti/a?=
 =?iso-8859-1?Q?ay7sAtL2MHag3owl5AAKVqNwnktf1Ulz6685LlWkstsuj7FUZKuLDB0Quu?=
 =?iso-8859-1?Q?7zop1GkktKZGSOqbfFGnjtrDDVlhQ+mZYtbr2Kq44HMXSjR89twjw2N7+j?=
 =?iso-8859-1?Q?1CixV020GRq7QN3J/lwFQjLuSTGqnmVJgtkqnqhbwIooeDBcaPQDLrQ+8S?=
 =?iso-8859-1?Q?bwN0uR6f6E8WlBO9t+XquAIE+1YxfV4CY+sfo+nuemKxqmoBkG2c9sJCm1?=
 =?iso-8859-1?Q?/IRdXicjT8l4d6zVCbmOFpmo32QXMz+SQBR7bKoZ2nDhvmvL69CNrM7uqt?=
 =?iso-8859-1?Q?pDElCxgKMd6MOykkUgAyjGfcSuHj39LX4GSht7a8QNMbJOFFIScrEgpzOQ?=
 =?iso-8859-1?Q?9Oridj7hUTiQ8O0xLr7DAOMrkcfH9xg44Rdj8LRsYdOzbZYo0Fr2pdI1HR?=
 =?iso-8859-1?Q?nB6MbQ5Q09Zb+FOmTT969UJEuQZIli/MgYr3Sfqo3wCDqs2WVQf8?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	osHdg5OOuv2roFXi5F9J+atBnGVreSf2XSIr0tI4z+j1Da+haPTVVKhcp6TxFTwfKcEoSonWxWzE4LZTugK5BjXxdRdpKRtopVaXavGh6/6tlgy74w2lb6PZ2s1DwsZP/AztekUzmjnlAdw2aHktN0H2JzfDIMkMXS6rFPiIu0oU9VQjNySyMI3KMX34fgVWOuzxVaCOoLkwbW9ZTP1zHwlEcIzxQ62rzZL4p0dYPo/7OfJsmVVXiaqCtdpLXZdKcvSf11x4ANzqcp6gXPH9o+FilL8UTbo7IKK38lbsDCHHb8xjwPAvtbTmrQc1Pv5HQC8y403dXIIFh1RLgtE6ZA==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7281.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc633b35-58b9-40fa-c98d-08dea638f9b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2026 21:47:57.0717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LYC+eqX8wQrdNVXTFQcqEgLgeK7pFt9lleJbKJB7KNlENoU6wHTSJ9V6Ghcje2UweTU1mZczEljt1xhBucnGaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6602
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-2.cisco.com [173.37.147.250];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.250, alln-opgw-2.cisco.com
X-Outbound-Node: rcdn-l-core-07.cisco.com

=0A=
=0A=
________________________________________=0A=
From:=A0Evgenii Burenchev <evg28bur@yandex.ru>=0A=
Sent:=A029 April 2026 2:52 AM=0A=
To:=A0stable@vger.kernel.org <stable@vger.kernel.org>; Greg Kroah-Hartman <=
gregkh@linuxfoundation.org>=0A=
Cc:=A0Evgenii Burenchev <evg28bur@yandex.ru>; Karan Tilak Kumar (kartilak) =
<kartilak@cisco.com>; Narsimhulu Musini (nmusini) <nmusini@cisco.com>; Sesi=
dhar Baddela (sebaddel) <sebaddel@cisco.com>; James.Bottomley@HansenPartner=
ship.com <James.Bottomley@HansenPartnership.com>; martin.petersen@oracle.co=
m <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org <linux-scsi@vger=
.kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>=
=0A=
Subject:=A0[PATCH] snic/vnic_dev: Remove dead store in vnic_dev_discover_re=
s()=0A=
=A0=0A=
The assignment 'len =3D count' for RES_TYPE_INTR_PBA_LEGACY,=0A=
RES_TYPE_DEVCMD, and RES_TYPE_DEVCMD2 cases is never used.=0A=
=0A=
Drop the unused assignments to fix the following static analyzer warning.=
=0A=
=0A=
No functional change.=0A=
=0A=
Found by Linux Verification Center (linuxtesting.org) with SVACE.=0A=
=0A=
Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>=0A=
Acked-by: Narsimhulu Musini <nmusini@cisco.com>=0A=
---=0A=
=A0drivers/scsi/snic/vnic_dev.c | 1 -=0A=
=A01 file changed, 1 deletion(-)=0A=
=0A=
diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_dev.c=0A=
index ed7771e62854..22303f827583 100644=0A=
--- a/drivers/scsi/snic/vnic_dev.c=0A=
+++ b/drivers/scsi/snic/vnic_dev.c=0A=
@@ -132,7 +132,6 @@ static int vnic_dev_discover_res(struct vnic_dev *vdev,=
=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case RES_TYPE_INTR_PBA_LEG=
ACY:=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case RES_TYPE_DEVCMD:=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case RES_TYPE_DEVCMD2:=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 len =3D=
 count;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 br=
eak;=0A=
=A0=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 default:=0A=
--=0A=
2.43.0=0A=
