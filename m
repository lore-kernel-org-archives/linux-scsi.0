Received: from alln-iport-1.cisco.com (alln-iport-1.cisco.com [173.37.142.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC5E1386DA;
	Wed, 12 Mar 2025 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741803904; cv=fail; b=F180WcuGeOCI4nM6mOPTbYuP081sVbY4HQtHqGsPjp5gc1xe+ViuAAFY/HD4oiJ+uVHvs1btriZ1U5xjk1paSBD8zVGAdnhTLb261tBbfEw1cQdEIkdW9zN4jE7mVaq7qwhwQm5SYb/q2uZ3NGr4GqV3tadll4pf5ugsi1KqFjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741803904; c=relaxed/simple;
	bh=2oDdPkbssEHYYlNRzSefWEIV136/IzSiaxbpl2sndgk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vx0B1SUoCWD/7v19QsWOaSsAA/GCLxbDLufwsrchyWd4L/tlKLaSJ88z2/EDZUur3Vr0DWgGaW/eyFhiSKogQ1QQc3IHBNorq4M4qfLt3NCpYZuz2pT7QRmImAPZfpgs5ZiZUXE0MhA/+WmsXG1CEfcMzqwIr1ss96gA0EfemlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=VA/Go50W; arc=fail smtp.client-ip=173.37.142.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="VA/Go50W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1340; q=dns/txt;
  s=iport01; t=1741803903; x=1743013503;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=SAVeua9Zadk00RLuWGGxhFhrQgk2TZpKK97Louba1aI=;
  b=VA/Go50WM8I7VF9xyMugSpJsqhq2pwxA781sYrgSTE4F0reS7KE7At47
   36R0BTVJ/bqNTxAOPBXnKPRp6lb3g18S7taf1mqLYBrw6xk7tShvDN7Kg
   MtT/2mKeOb4vzY/d1DH23yr+wSX3aJ9Fvym1P+rNYpYrjAa6Diot0RxFn
   eE4qgGfY876oFr34ki6IZcngEatj6FuPE6qfcK3gqAxil46TCOngMg4Pb
   MNEnd6aCQN8gJQmKV4kwX+a/dvaaE2RPTD4Prx/4hkFt+v0+J8rN8d3W2
   4+tw22aT1O56gTffIJ6m0f6oPN6RGESyQzMtj7gZRIVwyPDUfq8DbP4bT
   A==;
X-CSE-ConnectionGUID: JJPDuOjnQTSXXVG1GC29JA==
X-CSE-MsgGUID: 0pjg6JvrQoeKUDtIMkRngg==
X-IPAS-Result: =?us-ascii?q?A0AoAABH0NFn/5MQJK1aDg4BAQEBAQEHAQESAQEEBAEBQ?=
 =?us-ascii?q?CWBGgcBAQsBgXFSB4ISSIghA4ROX4ZTgiSeFIElA1YPAQEBDQJEBAEBhQcCi?=
 =?us-ascii?q?xoCJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGW?=
 =?us-ascii?q?gEBAQEDEihPAgEIGB4QMSUCBAESCBqFRQMBolEBgUACiit4gTSBAeAigUgBi?=
 =?us-ascii?q?E4BimInG4INgVd5gW8+hEWEE4IvBIIvgWmCV2eZe49OUnscA1ksAVUTFwsHB?=
 =?us-ascii?q?YEpEDMDIAo0MQIUDRAPBhAEagU0QTiCC2lJOgINAjWCGyRYgiuCF4I3hDyEQ?=
 =?us-ascii?q?II/T4JAghFxbwMDFhCDH3cchD49hGEuViEdQAMLbT03Bg4bBQSBNQWhPDqEQ?=
 =?us-ascii?q?4EOHIINF8Z/CoQboX4XqlcumFAiqGcCBAIEBQIPAQEGgWc8gVlwFYMiUhkPj?=
 =?us-ascii?q?i0WkwwJAbgZeDwCBwsBAQMJkWUBAQ?=
IronPort-PHdr: A9a23:q+WkZRJoYIaEHNkx6NmcuVQyDhhOgF28FhQe5pxijKpBbeH5uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:ksf036tmZDR11NQ7MtFEdEEutufnVD5fMUV32f8akzHdYApBsoF/q
 tZmKWmCbKrcMGP8edpwb9uwoUkBvZHUn4JnSgJt+y8zHnlHgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav656yEhjclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuGZDdJ5xYuajhJs/na8ks11BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw2MRPLXxp9
 /ohFAs9Xi6s3s2dmuOZY7w57igjBJGD0II3s3Vky3TdSP0hW52GGv2M7t5D1zB2jcdLdRrcT
 5NGMnw0MlKZPVsWZgh/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JoDUFJwLxhbBz
 o7A1zzhAB5EFsKF8D2I0U+Ams7qnhn9V41HQdVU8dYv2jV/3Fc7DBwQSEv+ovSjjEO6c8xQJ
 lZS+Sc0q6U2skuxQbHVWxy+vW7BpRUHWvJOHOAgrgKA0KzZ50CeHGdsc9JaQNUisMlzQXkh0
 UWE2oqxQzduq7aSD3ma8994sA+PBMTcFkdbDQcsRgoe6N6lq4Y25i8jhP46eEJpprUZwQ3N/
 g0=
IronPort-HdrOrdr: A9a23:w/ixCKgVuAGycEcQ9m6WRTWGj3BQX5J23DAbv31ZSRFFG/FwyP
 re/8jzhCWVtN9OYhAdcIi7Sda9qBPnmaKdkrNhQ4tKOzOW9FdATbsSoLcKrAeQYBEWmtQtsZ
 uINpIOdOEYbmIKwvoSgjPIaerIqePvmMvH9IWuqkuFDzsaFp2IhD0JbDpzZ3cGPDWucqBJba
 Z0iPA3wAaISDA8VOj+LH8DWOTIut3Mk7zbQTNuPXQawTjLpwmFrJrhHTal/jp2aV5yKLEZnl
 Ttokjc3OGOovu7whjT2yv49JJNgubszdNFGYilltUVAi+EsHfoWK1RH5m5+BwlquCm71gn1P
 PWpQ07Ash143TNOkmovBrW3RX62jpG0Q6j9bbYuwqhnSXKfkN+NyNzv/McTvIf0TtmgDhI6t
 MI44tejesQMfqPplWl2zGCbWAaqqP9mwtTrQdUtQ0QbWPbA4Uh9rD2OyhuYc89NTO/54Y9HO
 Z0CsbAoP5QbFOBdnjc+nJi2dq2Qx0Ib1+7q2U5y7qoOgJt7TlE5lpdwNZakmYL9Zo7RZUB7+
 PYMr5wnLULSsMNd6pyCOoIXMPyUwX2MFjxGXPXJU6iGLAMOnrLpZKy6LIp5PuycJhNyJcpgp
 zOXF5RqGZ3cUPzDs+F2oFN73n2MS6AdCWoztsb64lyu7X6SrauOSqfSEo2m8/luPkbCt2zYY
 fFBHuXOY6WEYLDI/c94+SlYeggFZA3arxmhuoG
X-Talos-CUID: 9a23:M/xyzG2FodzVWWeXXtszRrxfOOIdXmD6znHpH3SIOVhGEZK+Ew6y0fYx
X-Talos-MUID: 9a23:5MFudwvUVaIoX9kecc2n3ClgO5lK/b6XD00urLkamuyHDyp/NGLI
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by alln-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Mar 2025 18:24:56 +0000
Received: from rcdn-opgw-2.cisco.com (rcdn-opgw-2.cisco.com [72.163.7.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPS id 7AD121800026B;
	Wed, 12 Mar 2025 18:24:56 +0000 (GMT)
X-CSE-ConnectionGUID: yAttZCECQwmtuWrnHyBi4Q==
X-CSE-MsgGUID: 2k0EaDsvRI+jbyYjdfFZzQ==
Authentication-Results: rcdn-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.14,242,1736812800"; 
   d="scan'208";a="28360102"
Received: from mail-dm6nam10lp2040.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.40])
  by rcdn-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Mar 2025 18:24:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sHbP9wCbGSw7AN+PrRePEvgn5WWyrsXdtA6GrMLLKh0803gpYAHGqQRIrlEd0+DOFJwYPRYl9eNncrJtmA8trUZttkqDNqnktTPI5j8DuyOQC6zngZU9j44vT2TY/hX4yG/Cs9zXHaolgJtPSAwQFG+GVq2fGdbQdntVQ7AEBZ77sdTCavwRtt2xtGb9/dq3mQnIQUYmTskSfcGSsV0XQV4+K223r79BaRZBsYjMpR3abuqhrP+L1yGuwWWeJTGT82YxHdGnQmM4K47KkpqvH547ySA5a/nLd6F4wtQazu/FlxqyJqm+PAxVt5I86O4MZITjPhfZkI1PH9djdQW+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAVeua9Zadk00RLuWGGxhFhrQgk2TZpKK97Louba1aI=;
 b=mX49oa+cUOzXIJ59sLohVn418kjln5e60kAVLVNgElAmuBh6Sr1mOLmisp4IzYU+qdsYeJwyX1OXEWXHjGl3/3x3ZaK1SiS6JMC0j0B86v1xkHh6ERFRiYlUa9/SthJAniSvqVZgCjWdPe9wRWaTimJ9Mqv68fPCyqfV0IznKD+/PU9hcEC64HBvDM/C8t4TvCW07QanxswZnwoqOVl2ifrjG8ib8D6KOnAjYmrUKEwdThn6t6z8zT2yGwE5EJXDRs7oIRf9lQCr07HMtb0aMRzuaCb+9nbQF9dAEwb5K/p74tCLXtHMcv51HUDfHOF2GLUd4ksaUfhPFlfXrP7GCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CYYPR11MB8408.namprd11.prod.outlook.com (2603:10b6:930:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 18:24:54 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 18:24:54 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Chen Ni <nichen@iscas.ac.cn>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: Remove redundant 'flush_workqueue()' calls
Thread-Topic: [PATCH] scsi: fnic: Remove redundant 'flush_workqueue()' calls
Thread-Index: AQHbkyKR1rI8JYbHiUuwm7uqdvt8L7Nv0SqA
Date: Wed, 12 Mar 2025 18:24:54 +0000
Message-ID:
 <SJ0PR11MB5896C0AB0B355B4BFDC29041C3D02@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250312074320.1430175-1-nichen@iscas.ac.cn>
In-Reply-To: <20250312074320.1430175-1-nichen@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CYYPR11MB8408:EE_
x-ms-office365-filtering-correlation-id: 9b4c7b1b-35a7-4b61-bd48-08dd61932fd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ZoU1q8sAIeUUjYC+bNY3L/5WrM7gZmBnFPjl8v+Ps7AKJz4+S0SUgy7jTNqh?=
 =?us-ascii?Q?hBTovm0j3xdQHcWKVmPKCSWoAnsY7Jt9Uqze7L11BhG6gLbczBYAm3mNROap?=
 =?us-ascii?Q?CfPR5JC5RJRHbk57LZg8P/WdputUIMglrb+9babQwARfuz92xcUcRTkitz1c?=
 =?us-ascii?Q?tpfduPJhJp/I9z8XFVlWDMzN254/+5znlnYean1rlV6KriOwe+20Am/MOA3t?=
 =?us-ascii?Q?5fv+APuazsI669595cFZc1/OtwKyt4TXdFs3Zz5CduXe6ipd8ul566CWndKa?=
 =?us-ascii?Q?ZUQWEQ/ED0xPc/HwvnRjP4Vqu6QE4Mx4W84xPhKYmherXgiR6b/aub0N4Rxm?=
 =?us-ascii?Q?F8yw9s+4cvC1RY+N3tl/dUXoi6PVUTFhaQzeU1k75JDcYw24kiUCx9Y08NgP?=
 =?us-ascii?Q?bQdZqgaKspVwSaUqvU0I55hIg6aOf4m9yfSFT0xVZ/Ys3R+f7gkyctq3mrRO?=
 =?us-ascii?Q?3XFywVPacYE3yM/Dz490tt7ZOtu34lA/n6ef0gmCof6NQqFMB1+ugDAal2iP?=
 =?us-ascii?Q?w4TaOES6jii7Dz23OzAxhHuywl9x3KuvT2axBDXjeQigEjHgDTO2HhYHhgVU?=
 =?us-ascii?Q?lHjYHrd2NqlrKHZahfKrNF1jEBZW85sFJJBUvl83cP4PndsDXKcyHksIjTVV?=
 =?us-ascii?Q?uVvqp+ZXiveyadiGsFbTUDCla10c8SBi/DqU2LpSesIUSBBOrvX5R/daTRV3?=
 =?us-ascii?Q?4izv7iP5pryg0mDSg/eaeBjADr/FOGIPPyxe27hiXtPLfhv8P//1FcJ+uwg4?=
 =?us-ascii?Q?nsAGr108XBIIZZb38QWDY+7TE5pdiZ559Mk4t5moHofOYcAJpy0QQ+UZY44u?=
 =?us-ascii?Q?Z9XUjVBgTHUlkTksaZFMrVNbPLwvbm1IgCd/AIutWSh579y8hMviGEwTQpq9?=
 =?us-ascii?Q?kp8+WnjUJ0wLmKdG+Z9nbZR8nl+Hv6673n0LBG9XvroNGOXU99+yqWkL9qzJ?=
 =?us-ascii?Q?rwK4pTGLeOetQnMGQUr1w8gsCZOoJniyJHgnBN7/9DgubXK4U7F2mXYGRvAD?=
 =?us-ascii?Q?lzvWI5VTnZU8NzmH7gHWoK1+10/J3ivdz3GELN4e6TZkT7c4+n75d4Ar+8SQ?=
 =?us-ascii?Q?Z4Bh6AqrpgtmwuysgW753hg4wl1BrwvPXU/bsZNqLv42PY8jBthMR6+2I6Og?=
 =?us-ascii?Q?UJUytY6KFJ+QSJ+FgsJClk8otM38hXoh060Ya39nxA8OvLiYn9Mr2MjdxlfS?=
 =?us-ascii?Q?Bh/vZrc1ui2rAUaHtrI+IE+oGP3v1C1LOcokcEzKeUeJjUwn9nZGW28NHkPI?=
 =?us-ascii?Q?SnlK3Lj27W8M1nkNE+O/sxPqFwyCYDwvm4v5alfGHcqmV80OwHcyurbmBK70?=
 =?us-ascii?Q?8rfUbwCe/nA5q5SzjHIgR6W4vZDBF7ACDeZuM5xuKDuTgbemnOY2Qx2/VYze?=
 =?us-ascii?Q?LFdXibiqhm8ecdAlWAswiD0Hje+1D/MsHaSs6j5KTNXk70jAKJJqYRnst0uG?=
 =?us-ascii?Q?pco+Busq0SYodiBPL0ecpbKM1XOZYTSj?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?htAzVJXO07Yc9e97KDf/dkQjwRHNhXg6G2fUVlNh4F/W84vE16HLAltqdL8r?=
 =?us-ascii?Q?FmUYfUmDOldJLyTxPaXV4HJfbTYr/Wf2ahKYaeJae5Xd73DxY/87C8Oqi0OL?=
 =?us-ascii?Q?CcGTMxmaRGnCNmbiNhdpZMJ8kzSifPlceiiJMMWADehU9XeBu1Ee4c7ugjbZ?=
 =?us-ascii?Q?9R9wyUZY1L0eHs29y/nFNbaYSe7kYSNdAjkW0IHbWqcO49a59ffkZFTA5ddZ?=
 =?us-ascii?Q?InVqdbaS4KPGAf4h7y4Qz/0jKQwfBetfEgF6xnGpEd7qrWMoHBUoO7X1sCK/?=
 =?us-ascii?Q?ZLGa0sieVScGGqLHV6CY/JJRpVcg9mPXuQ2f6Xtr9upRJ9qOucYDMvfVphdT?=
 =?us-ascii?Q?LZuu7gQ6tspC7AmtyNC1lq/vQxunNCMhR51vaXpOv4RNGXL+/v5jD7BflnOI?=
 =?us-ascii?Q?hi1lCVWLHY4qVDkqHDj2J+V3sqDdp1UZ3ynwYZEXSNjGMxK+3xY0c9wKPfTs?=
 =?us-ascii?Q?EWtJbYXXg+6WuwdjL6Hprun9uM1UztykwnOMM2mneeueD4rkFeKNSQavoupu?=
 =?us-ascii?Q?9KTJBGQpZFcNfi+GgtLZ+6Ws+lwXA3mv/U/K7t8n59TR6qMAURelRF24dZbg?=
 =?us-ascii?Q?77hQ0cxXBMOU/tMZ6HNtrqaTSn/mC86910zmrH2JvBiZ3L81zk69eEsiDyhI?=
 =?us-ascii?Q?wDqVuz0OrbI5K1iFzZCY1yaaNIvNwTOWD3bY7K2FpeeWeIvhGYDN873eaYwm?=
 =?us-ascii?Q?309/iPMmWYVAy+m0iJ4EcxIWnL5jm9kcb+4E3G2E8Q7Nm4XvcJ4MA9I2ZIKt?=
 =?us-ascii?Q?+tZCys6HgZBW1HHkp5NXrU30IDwaTVKwQXOWnE465siX+T+5UjcNkQFtsHLz?=
 =?us-ascii?Q?aWIk4y1qLR8PG/GzuvS/+ewZXFnvFsjA+flAP1R28WlHL3heG1fJ8ikf/WeJ?=
 =?us-ascii?Q?2OD0zOot7PLCp+HJJIv1uFI/lCceF157+QaEss9krirUw5iAhHGZ2YX4tpI6?=
 =?us-ascii?Q?R/kci4d7/uNSbLJEvhauZRKIUsEP76FDfl+lcXhphYvXsmGcuNXtcaxyz+Ov?=
 =?us-ascii?Q?9NN0lPUvRwDG8livThJHBbJJ77ouD9l+nAmlClhPUbIv2fIFrhgp5SzlkrXQ?=
 =?us-ascii?Q?1C9RpvoZsl9Skcin5CulSfIdHWpAGrqZiE1Fe28NNff/qBHFRPeEni/Mtjnw?=
 =?us-ascii?Q?45i72N2OrFrySAc9eGXqbA4ZZ72L6TWK/wlTl1/Z4+vJVN1T7jO1/ArWhVUn?=
 =?us-ascii?Q?HdyYUn0VOuHbqMfGy1QIp8LW6ATszA0B0HU1tH+YGhqscUtRis9cn+rXVALO?=
 =?us-ascii?Q?ihAh2JlJqOkCL320yOI2YtZ4Q2oyq16M/EvgRE3qcVd7IOjTUY88b28FaM61?=
 =?us-ascii?Q?wAfTNP/7hUWAX/wCV7B5vYkh9vJ0kKVB177HTtLanZGDQ6g9grIF477eO7OX?=
 =?us-ascii?Q?lanmmy2b3VBGs8Wcyy766V4m/ibOOeuU7pMIaa9csfu6LWoIAxl3gYBpoc/V?=
 =?us-ascii?Q?Kk7ZHqmMzXoWMX2fZQIbb/ao2VDcyfRtE4qSVR2CpEOGnLsodPVf2UyaEz5Y?=
 =?us-ascii?Q?TKbdI6TwISroXOtaBpLYAm973PlKGV2/oBrVykrTUYgayIGXaTQHdHSDv0A8?=
 =?us-ascii?Q?jKaYgFXSjH8UIkL5UMuLSi43+xbYlJa4wQLxsuIirQnN4fYzV9CRysiDM/zp?=
 =?us-ascii?Q?mxGOyPovF2WsQAl4Dxsl+Is81OaYTC7mAMLxurMaKVD8?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4c7b1b-35a7-4b61-bd48-08dd61932fd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 18:24:54.7131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: of+4mYYXIWbp+KwM9iJvpzypy/jcVXzfgpLl9Y2vmo/q5axVmb92ZRC+wqtB+g/rehE/vBsyVhJxuunGLdS9Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8408
X-Outbound-SMTP-Client: 72.163.7.163, rcdn-opgw-2.cisco.com
X-Outbound-Node: alln-l-core-10.cisco.com

On Wednesday, March 12, 2025 12:43 AM, Chen Ni <nichen@iscas.ac.cn> wrote:
>
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
>
> Remove the redundant 'flush_workqueue()' calls.
>
> This was generated with coccinelle:
>
> @@
> expression E;
> @@
> - flush_workqueue(E);
> destroy_workqueue(E);
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
> drivers/scsi/fnic/fnic_main.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.=
c
> index 0b20ac8c3f46..3dd06376e97b 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -1365,10 +1365,9 @@ static void __exit fnic_cleanup_module(void)
> if (pc_rscn_handling_feature_flag =3D=3D PC_RSCN_HANDLING_FEATURE_ON)
> destroy_workqueue(reset_fnic_work_queue);
>
> -     if (fnic_fip_queue) {
> -             flush_workqueue(fnic_fip_queue);
> +     if (fnic_fip_queue)
> destroy_workqueue(fnic_fip_queue);
> -     }
> +
> kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
> kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
> kmem_cache_destroy(fnic_io_req_cache);
> --
> 2.25.1
>
>

Looks good to me.
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
