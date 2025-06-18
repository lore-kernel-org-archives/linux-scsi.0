Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1642EFDB4;
	Wed, 18 Jun 2025 16:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750262409; cv=fail; b=smfciViWPE0jBDKeZezHgUvKncDsoJjXhOzDartkBWdMK6Bav1wCM9av5p8KVfrr7vEZGRwNyYT3GOhd9jSf4n/3XJihwYAFqvPsdOQB/8klVFrZk9OJyR5VpucCoZsvtZMYeSMnRQRp+OZ5EZMVBe3L0Fhur4OpANang9w8UU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750262409; c=relaxed/simple;
	bh=C9Hn9b9J8bCoUBxnOvDckBDTOnH5KGtQToalTJFrdVs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YXBhB/5KxEzAO2Hsw/I3ZfwitxrX3rjY+dZkmTjUuXUrB5UCXv8MrLW9uaTICL2hGqa7nzVPItkWXkaGOAmATKH1OnM9iCph5svmOC/6w15BIx9+uGHovRChoDoTgdQH5rzXKB7558hz4HVJVpKrbw8ZnWyLx1NK5/g35q7SHmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=RJBexof5; arc=fail smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="RJBexof5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1111; q=dns/txt;
  s=iport01; t=1750262407; x=1751472007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=62y+CofJsQJcWsRdx5POaEm6jwN8sMR0yN1Rd6mLjF0=;
  b=RJBexof5z2F1rLzIb4ykgMUeTTgi+RBwQCrnbSdbeWAssoZTwVgN9L8Y
   0pLAFn0+hAa/Jh4ctZONlVfhhPznS7XEVEGIp4nfSLPaVNcGgLCpw40RN
   1ZeTcoZRZVPkswd77wt/AfkLGxQu7RC7ZSsV+Sb6aSrxvtNcMUlLfKOMz
   +Tosue5QCdpFUTRs6p6l3PG487v+1dJsq4y/+TvemZUg8OPgDQ4o92hFN
   p8OYYIdu7+GCX6XIGnqkd4jwriA/EuICgBPc/pef11D8yeKvtr/ftflct
   2AhGFtnOIKWD8ftsUXzHrqLTJKkxzRkrUG2HnZdk4s/sGUHy7AAWnX4TJ
   w==;
X-CSE-ConnectionGUID: k8N0qIYpRyKLrd2/gQzkwA==
X-CSE-MsgGUID: rNkehF0fTRmLZGWCgsogUQ==
X-IPAS-Result: =?us-ascii?q?A0AEAABq4VJo/4//Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVIHghVJiCADhE1fhlWCJItkkjKBJQNXD?=
 =?us-ascii?q?wEBAQ0CUQQBAYUHAotmAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFA?=
 =?us-ascii?q?QEBAgEHBYEOE4YIhloBAQEBAxIVEz8QAgEIGB4QIBElAgQOBQgahRoDMgMBo?=
 =?us-ascii?q?kcBgUACiit4gQEzgQHdPQ2CW4FJAYgyHgGKYycbgg2BV4JoPoIfgiaEE4IvB?=
 =?us-ascii?q?IIkgRaFYYkjiXZSeBwDWSwBVRMXCwcFgSBDA4EPI0sFLR2BLCZqgVAchD6ER?=
 =?us-ascii?q?StPgyKBf2VBg14SDAZwDwaBDkADC209NxQbBQSBNQWRV4MmexMcgiQpllCaf?=
 =?us-ascii?q?JQlcQqEG5tYhjEXqmEuh2WQcZIOkWaFGwIEAgQFAhABAQaBaDyBWXAVgyJSG?=
 =?us-ascii?q?Q+OLRa7NXg8AgcLAQEDCZF+AQE?=
IronPort-PHdr: A9a23:rUmt7xyJnDZ6O0XXCzPsngc9DxPP8539OgoTr50/hK0LLuKo/o/pO
 wrU4vA+xFPKXICO8/tfkKKWqKHvX2Uc/IyM+G4Pap1CVhIJyI0WkgUsDdTDCBjTJ//xZCt8F
 8NHPGI=
IronPort-Data: A9a23:NkefRqj/U0WTY4pfOvf8e/VJX161CxEKZh0ujC45NGQN5FlHY01je
 htvWG2PbPyKZjeketknbou19BsH7ZLczIVgHVFuqXoxRn9jpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOKn9CAmvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSBULOZ82QsaD9MtfvT8EkHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUbqsAvGEB/7
 cYJCxQXYkrEiNukw62SH7wEasQLdKEHPasFsX1miDWcBvE8TNWbHePB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgx/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JoPaHpoJxh3Ez
 o7A137fARwaGoSR9QCA1kCDucTAhiT0ZbtHQdVU8dYv2jV/3Fc7DBwQSEv+ovSjjEO6c8xQJ
 lZS+Sc0q6U2skuxQbHVWxy+vW7BpRUHWvJOHOAgrgKA0KzZ50CeHGdsc9JaQMYtuMlzQXkh0
 UWE2ou3Qzduq7aSD3ma8994sA+PBMTcFkdbDQcsRgoe6N6lq4Y25i8jhP4/eEJpprUZwQ3N/
 g0=
IronPort-HdrOrdr: A9a23:mf1saqzycEYEOgmEol7FKrPxY+gkLtp133Aq2lEZdPULSL36qy
 n+ppQmPEHP6Qr5AEtQ5+xoWJPtfZvdnaQFh7X5To3SLTUO31HYY72KjLGSjwEIdBeOjNK1uZ
 0QF5SWTeeAcmSS7vyKrjVQcexQveVvmZrA7YyxvhUdKD2CKZsQkzuRYTzra3GeMTM2fqbRY6
 DsnvavyQDQHkg/X4CQPFVAde7FoNHAiZLhZjA7JzNP0mOzpALtwoTXVzyD0Dkjcx4n+9ofGG
 7+/DDR1+GGibWW2xXc32jc49B9g9360OZOA8SKl4w8NijsohzAXvUgZ5Sy+BQO5M2/4lcjl9
 fB5z06Od5o1n/Xdmap5TPwxgjb1io04XOK8y7avZKjm726eNsJMbsEuWtrSGqf16PmhqA77E
 t/5RPdi3OQN2KYoM2y3amRa/ggrDvFnZNrq59hs5UYa/peVFeUxrZvpn+81/w7bXnHwZFiH+
 90AM7G4vFKNVuccnDCp2FqhMehR3IpA369MwM/U+GuonFrdUpCvgMl7d1amm1F+IM2SpFC6e
 iBOqN0lKtWRstTaa5mHu8OTca+F2SIGHv3QS+vCEWiELtCN2PGqpbx7rlw7Oa2eIYQxJ93nJ
 jaSltXuWM7ZkqrA8yT259A9AzLXQyGLH7Q49Ab44I8tqz3RbLtPyHGQFcyk9G4q/FaGcHfU+
 bbAuMhPxYiFxqYJW9k5XyLZ3AJEwhtbCQ8gKdPZ26z
X-Talos-CUID: =?us-ascii?q?9a23=3AwngXjGqSpgOCjJqNjHMjL17mUcN1VCXE7UbIGV6?=
 =?us-ascii?q?bLXxlEvqacE2T54oxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AQAsqlw52yDNH+AO0Lfv+gSQlxoxyxaejCG5Vn6k?=
 =?us-ascii?q?8vu22GhNbNCyagwmOF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Jun 2025 15:58:58 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPS id 2050918000252;
	Wed, 18 Jun 2025 15:58:58 +0000 (GMT)
X-CSE-ConnectionGUID: KQK4AoX3QfGpcLWlxImQcA==
X-CSE-MsgGUID: MF0YqkgxQFmGlCYMT+Iq2A==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.16,246,1744070400"; 
   d="scan'208";a="50012311"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Jun 2025 15:58:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xw5ZS8ffKA7YfJdBoyhw5oc09IWCNbZm++HVznFEsVo/TJXGmBuFkGY2cAUgpfcseYpwuxoDvGxVnUdwvJksUoQvELnr6u1ro/b6lRSpQkqOd9pt5+jqoh5b0bfjt3TjmH4d3FhNU7j7woKnOZKJJdNzSJTLvU/l/GGpN126kEKS1t/iocnBR2pkBjPpgeqzoAPELemHBhrafYsfUJYyECFYEP5uMHoHb6VHWXeOemJbPa2js89BKqgJmRnhB58UaToNJKS8d4PlVkMgjkv0hKSbELETmB5yshfAL7dQuRibaYaR8/At3TbhXnoVZ0qWSycWvRtxTtmxaSo1arx/Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62y+CofJsQJcWsRdx5POaEm6jwN8sMR0yN1Rd6mLjF0=;
 b=DU+MyfLGRlnvte0M/TKDQKxbxB7ClqIT0BNjXyC4K+DggzXrabfv21x2064q71R4wCM6gIECOAIIlN0VNTILkJ4pouJ0J4j2+Ihw0OcpZ8rMa8M/Y/c1VeJF3Q2YndkiebOHDNFpnWzSHO/e1gwDdnZy5MTbNI0FBlC1A1XaI6GRAinNM1H6G/OIHXPOsZ6zQgd0wHc0WqPyzHavwkSZ2thu6s9Ii1585eRfTxViplbfWcu5aeSuyC3U742/ajvcRooO01MMzw3V+U02bYrZtxTH9SXydjjFDdLP8hO3errercXD/QgIfYOPc8h2qwNmUrsUH04aHTyp8kGK/XOEsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CY8PR11MB6916.namprd11.prod.outlook.com (2603:10b6:930:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Wed, 18 Jun
 2025 15:58:56 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8857.019; Wed, 18 Jun 2025
 15:58:56 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
CC: "Satish Kharat (satishkh)" <satishkh@cisco.com>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>, "Gian Carlo
 Boffa (gcboffa)" <gcboffa@cisco.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: fix missing dma mapping error in
 `fnic_send_frame()`
Thread-Topic: [PATCH] scsi: fnic: fix missing dma mapping error in
 `fnic_send_frame()`
Thread-Index: AQHb4B5fejGhsDnG00afRZKa6/sbYbQJEvRQ
Date: Wed, 18 Jun 2025 15:58:56 +0000
Message-ID:
 <SJ0PR11MB58961170A23E4D151BC2FAD1C372A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250618065715.14740-2-fourier.thomas@gmail.com>
In-Reply-To: <20250618065715.14740-2-fourier.thomas@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CY8PR11MB6916:EE_
x-ms-office365-filtering-correlation-id: 29a895ff-70e5-42ae-11c8-08ddae8107ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?PiZ+NRIYKx/YLbHicf4wdcsU0nCLnARGf0eVq1/drl5Oxhqb5eOyYdkCMfuO?=
 =?us-ascii?Q?XBh5rxdFJnXTmnz6BG+op2iuHAm4EayXOjjJBeJvVUsnfsCI9NeELpUmZyyi?=
 =?us-ascii?Q?9jMyX9ld6gYgKR/benFQwyNEA1b7gw7xepKh3b4QNaI2Ik+RjhYrpwftcxq4?=
 =?us-ascii?Q?2HWyp7+9DMVjclc/f1KFclMrNrCDSzuWdz7p9GOpk8udvbZNDX+7kVWI5rue?=
 =?us-ascii?Q?GtJ0cGKKTjqS+mfsHt9VAK7XtGWVLpVr475pC/ouQZHDX4yr3RIjSm3PwqRn?=
 =?us-ascii?Q?P7tAVDMwRL4mWbXCfJARFt/lXdQXXVfQRbcnwama8Uq5Sh9ogr2HZfSz0CmT?=
 =?us-ascii?Q?6BNTzbJQYuLgghrIjkTaQQDYj9HJfNah7TBMl6GH0ZTXw18u7Sejnz9qMqqh?=
 =?us-ascii?Q?PYdV4shgYHS4T2p5zN3PNhlPJ52tQIagmukm6z+U8uJdJRxKyU0Step6LKYs?=
 =?us-ascii?Q?j7yL9Pehgw36CcdzkBBQtizf4sIrqBBHbOY7tv5IU0xo/zIciQmthFohziTg?=
 =?us-ascii?Q?71fNhTxNWFqreMvhrR++rEqiWYnfvzX/cSUPi0yzUfAqNInu4dx3IjL9zWHF?=
 =?us-ascii?Q?lj8dxQHYqHexVap97j3boY0kzfreRT5a1WaATQD1EMN1ukw8n78ACH5u83Ag?=
 =?us-ascii?Q?IZ5I30gRKKb7clz0vogWPj8+CSv2T/MNzGEne65Bl+7gIgulL7EKlbKUdcnx?=
 =?us-ascii?Q?ZNFRk8hPp+uLfvZ/L8M3qfHsd8izRu/qgGtlVIQuZHOFWr74jlL80RK3hO3p?=
 =?us-ascii?Q?hufiqsp+GKygKcoK9Cndac2wo647uaU57uiq45D7wdUuY4/mMkUtzcZMcj9s?=
 =?us-ascii?Q?BYK5kcwJeDfrWeijl5XZ/e9lfBgu7Jcc2FAaNh6hVOS15zs8ySkUmakjhP+5?=
 =?us-ascii?Q?twfx158caWllGjmYrtiUD4blU8iWMXuhDscBrx29ib8qvgNLyhXPOah3+GO2?=
 =?us-ascii?Q?li6uJf6kN48Mn2do/O3prD0Ij8ey9wqAIB9ACyOJd9V6CR5mUmRItmOr4BWl?=
 =?us-ascii?Q?KQL8CzHArStxhtgfBMjP8bPwc7ho9fU2vuF5rxBfLWpILF3uXSDpht21YOPV?=
 =?us-ascii?Q?a55mbZO94d2WgT2WH+WR4KGDwHrm95EJyOVVFp2rOa+grhNQGOlgIn4bWt4K?=
 =?us-ascii?Q?/z73ffBf9NCBdJmQPZC/BdfrPuwL+PNyhGynqOXqSCHOY6pv3rmp611+yVqS?=
 =?us-ascii?Q?hlJNNTMEPjHODlypsV3dbilkqHKQf92yMbn4uQaJGhHUvV/kotzCaAG6Fy4E?=
 =?us-ascii?Q?DB9TTv8dQTvy+GgmasVZxAW3w39tjF8Gvd1u8ODimmXEDvjAYGo6C8+Yv3BV?=
 =?us-ascii?Q?IoA8UhE8kjmvUa/23EeWjLKibGxNhqGV4InTqB1hbG4C7dYqebYOCQt3mYA0?=
 =?us-ascii?Q?5GPpyhIN0Yvd96ZVmYyylrfjBYNj9+t2/H2wGGGDR3hy9wOxBJKIBnaCI5w6?=
 =?us-ascii?Q?T+Jlt6HzvRpz9leK38GwTjHdFKl6nZkbqahLU4BddEgMzar0k6a6kNyGisWB?=
 =?us-ascii?Q?d57EwvAQncRad8c=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?PZm0xtXrQ6MgeJj1lMRq/tTYJXO7YYL1672gLfXyD9Vvherejp4vGnRgWMeW?=
 =?us-ascii?Q?RgSt4+CGPbT3ruZnNqxKZowLbRW45//TW/CVtuPoCzgCFdM7Xr3OmYI5IoIz?=
 =?us-ascii?Q?uSM7jTQNesz7yzIgARIYkfkMtaA+Dtou9dDqYr4+GopZU6kxWiwaBPFrA6cp?=
 =?us-ascii?Q?IQeBbZDHuChJYbIcX1y/DKSzhzKDum16PZnsI3b2wp1Mvg4ocBu1I3fsQYup?=
 =?us-ascii?Q?hdNslYGDaj5/BDgwT3JvhBand/iDmaO1h6+GYTkISk3OxE/P9hGe1njUDlFR?=
 =?us-ascii?Q?5SAAE0G5xHP6UujDpxCdtc0zhPI9LvTNIIjhgr38u4LM9oHeJeC6+X3kuLBM?=
 =?us-ascii?Q?DAOcPWp2T9ZgIe5xtFxSeDY5kWrh32p7+ygnNxygeZ1cli2WWLHaiupOFs1i?=
 =?us-ascii?Q?jchAKu+BjgreqUpfLWaPYS0XbyEgJ8OqrAolq+nPWIHycrwJcZpB8+PzGcVw?=
 =?us-ascii?Q?ck1qTrpuQCuxPFFB+IjiMcztj4Z1VBUy2zSADjnjayZppI5MQU7B0yDO7BpO?=
 =?us-ascii?Q?IQ1v4NhLAH7gqJdvypJs4Bu1GL3+7x7AORQNelTl0zkoZ4uANefjlAyUdtPn?=
 =?us-ascii?Q?Jg+b9NK4Tvs72mQ2I8p6F4xhE7RUnlbr7DvPzI6PjAlBInCkxWnOeQKwfZaG?=
 =?us-ascii?Q?sbep+v1Q1RsNpaGBjC6ltU9mTwTM1J+0A1xMkD72yVQxxfvAUaEvgLLKmvvx?=
 =?us-ascii?Q?zpCtSa++5svgidyVNi4mNNPa6OMZTonSPxMAYXR7TRVmiTQPGPhN4JqkCsSC?=
 =?us-ascii?Q?gxI/kELVg8qu5t60tvhvBxfU75qLiarIj4sMJzHEJKHw6pnojF6T0z11dPgv?=
 =?us-ascii?Q?pUwPLs9Y/eoufjhsoVFafQR1DP3zCIET3kcN6btzvc3Do1HwG+M6LU5TZwza?=
 =?us-ascii?Q?TAlRBcv0MbjFIkbbxNOAgr5DTmH8jtRfJrCKwcegS2fqS3WIHAivJ9gfvnb1?=
 =?us-ascii?Q?IrqtwAMsYM89RXXwnlIII5sxn9OqFf86q1uUPx+PSmyxHVDzM7U+e5dEr2f6?=
 =?us-ascii?Q?HGOlp0Mcj06CzSoxe3mw9VjxVzuraSoezRicRAwW8HPd4ODjh3ZUXCJk0/O8?=
 =?us-ascii?Q?aCWYB+8I/Uaq6rnB8zP2j6aUqxi1jMJ7yTDi5nveIfHlkiT7xBblrQcCvbbJ?=
 =?us-ascii?Q?PPmTAatFGVGDwS8HFKsvkH+xleVQ+7W2TMiXpzzZi9gPApe8ZEhSX+67h4pA?=
 =?us-ascii?Q?Gzbcc+dd1D1jxrPiuCLvXl3OVHYi0yuOhKrKNMdS8C/0f1zdVoCdWsi1k3fC?=
 =?us-ascii?Q?1t+tWJ7nMAWF2SBCi3CCQL7vqbaky8wd2cNIB4//X3y/1x582z1C9Z4i6lk/?=
 =?us-ascii?Q?f29ShD/drH5gE9HaLHVIZqLlT9MftA9NIjy3HXQLRYQ0/6dCiDoxaeMQZKv0?=
 =?us-ascii?Q?JPfAGl5rQnEaeVxX7b29JDMCuett3WP1OFuxpNJ+CufEnpqDlEU7cI2jUhHa?=
 =?us-ascii?Q?kGCfmK5YbXJcXKQePpXpxVJQKA5gl8ih75tUyDzEISDxPtPIOTIMQBM8iIUM?=
 =?us-ascii?Q?gGXQ/YoorDBnxOcpLRiyUe25avhhLVwP9YwSX9Y+c3zXVDg5qX5z7TyCH1lb?=
 =?us-ascii?Q?1cVbNwX2Dkx8keGDsWGpryYTjgNJswfV/KENW3R8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a895ff-70e5-42ae-11c8-08ddae8107ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 15:58:56.0911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2x5g1mWSSyezy1bg8Z9nLptgD5iiKV8tbvClu4erl4YpOoIx2zvgyNDxuTS3O3xR7XeCsL56pIWbay7lMrLoAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6916
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: rcdn-l-core-06.cisco.com

On Tuesday, June 17, 2025 11:57 PM, Thomas Fourier <fourier.thomas@gmail.co=
m> wrote:
>
> `dma_map_XXX()` can fail and should be tested for errors with
> `dma_mapping_error().`
>
> Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited =
requests and responses")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
> drivers/scsi/fnic/fnic_fcs.c | 2 ++
> 1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index 1e8cd64f9a5c..103ab6f1f7cd 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -636,6 +636,8 @@ static int fnic_send_frame(struct fnic *fnic, void *f=
rame, int frame_len)
> unsigned long flags;
>
> pa =3D dma_map_single(&fnic->pdev->dev, frame, frame_len, DMA_TO_DEVICE);
> +     if (dma_mapping_error(&fnic->pdev->dev, pa))
> +             return -ENOMEM;
>
> if ((fnic_fc_trace_set_data(fnic->fnic_num,
> FNIC_FC_SEND | 0x80, (char *) frame,
> --
> 2.43.0
>
>

Looks good to me.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
