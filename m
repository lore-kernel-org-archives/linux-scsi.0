Received: from aer-iport-5.cisco.com (aer-iport-5.cisco.com [173.38.203.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C840C2BD031;
	Tue, 17 Feb 2026 20:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.38.203.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360901; cv=fail; b=BDd6kDRZ9+UUx/lwR6Vk90xPL46Q5vfuu8dk9KgUnNSDBMlO3PNBYLKb0j9gZby6qE5OBkmgkTRytpQs1ZNuzQ/AnwdbzmHzd05bOr5YQX0RQFcSHQ9dLOQxNkqPV7rDrMiQQHNuJMnuycUmFHNKz4iwzNNppsrrOIz4/AeHXNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360901; c=relaxed/simple;
	bh=azhrR9JuSRyR+CxBkrFfkbZK2YmlzMjaPjnuhPYaCTo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J014Dx4Fr1LkVyp7y06CSrc7j3eb2PjSNb0Cor+aH8MgSAAHYemqn5pUvOL0UvVkqyJXdjY5zkTeNEM9/4DREYbzO57rXItcp7a/jX22vGV5fKqtXZOJVP2HsLErvS0gxteaJWNz46/GWpd+vBL5zyg2SvyL0WMreksr05OSs00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=dCUV3ZYA; arc=fail smtp.client-ip=173.38.203.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="dCUV3ZYA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1718; q=dns/txt;
  s=iport01; t=1771360900; x=1772570500;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sFu6u3TopZs7q8Q4M4UA4ACutN2ZGcg1ENwDfmMVa/A=;
  b=dCUV3ZYAq2ae0qKsP6P3lqTvhWozeButWeNauL76G52ygTyM1pCo4/w9
   OvMwhwEwKdxg2HBWCZ7bNHhg+5Iubg9ynvNNY/tvvtt/soTteEQ0utfsD
   Aq1OsZHSBhkPBfI6+hiR1hhcVwxksnzMZYCIQ6a9jQ0+ivs+7tKLsRRyc
   teQpz4DD4RkfeUDC1i6BvwSPSzrtHahe/IVzoJBUrqg6m8HUwRfE+fEEV
   G3BXhHVXu9Ux1s/hlDaEJtyTwY6QgUUZGJN99rBpwwPHAOwrjZxMOyvrw
   7EwaRmBF8JM/2u40YWrrxh//Be7CoJKTxBHxHYihrgLUQnU2u4s4ZvLZ+
   A==;
X-CSE-ConnectionGUID: D+P5UfK8RoStdCyDdTM+Mg==
X-CSE-MsgGUID: 0QHXLDunS4+CM3av5kp9AQ==
X-IPAS-Result: =?us-ascii?q?A0A8CwDg0ZRp/85K/pBaHgEBCxIMQCWBIAuBblMHgg8SS?=
 =?us-ascii?q?YgjA4UshliCJItkkjaBfw8BAQENAlEEAQGFBwKNHwImNAkOAQIEAQEBAQMCA?=
 =?us-ascii?q?wEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGXIZaAQEBAQMSFRM/EAIBCBgeE?=
 =?us-ascii?q?CARJQIEDgUIGoUbAzYDAQKhTAGBQAKKK3iBATOBAd1DDYJeFAGBOIg1HwGKb?=
 =?us-ascii?q?icbgg2BV4JoPoIfgiaEE4IvBIIigQ6KRokWUngcA1ksAVUTFwsHBYEjQwOBB?=
 =?us-ascii?q?iNLBS0dgSMhHRcUH1gbBwUSISoHCYF1AgIEghB4ggEPhmx5Ay6BCQ4iAiwSX?=
 =?us-ascii?q?D0UBT4LXycDC209NxQbAwSBNQWOLUGCM4EOgS96lxKvLnEKhBybXIYyF6prm?=
 =?us-ascii?q?QaSEpcEAgQCBAUCEAEBBoFoPIFZcBWDIlIZD44tFsQjeDwCBwsBAQMJk2cBA?=
 =?us-ascii?q?Q?=
IronPort-PHdr: A9a23:xJuzvxGLf0OvTwarBEeeR51GfhMY04WdBeZdwoAsh7QLdbys4NG5e
 kfe/v5qylTOWNaT5/FFjr/Ourv7ESwb4JmHuWwfapEESRIfiMsXkgBhSM6IAEH2NrjrOgQxH
 d9JUxlu+HTTDA==
IronPort-Data: A9a23:wMNwU6wjPfFeO0eUOmZ6t+dZxyrEfRIJ4+MujC+fZmUNrF6WrkUHn
 WdLUW+FOf2LZjD8cot3PN/n8U8Evpfcy4MwHVRvpVhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4qaT/H3Ygf/hWYuaz1MsspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJG11BdAl9MUnO2Z16
 fAzORwBUjXAou3jldpXSsE07igiBMDmJsYb/3pn1zycVatgSpHYSKKM7thdtNsyrpkSQbCEO
 pZfNmYpNkyeC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OSwaICJJ4zRLSlTth6hh
 lLi03n/OU1ZH/nEwCTY8Wr9r9aayEsXX6pXTtVU7MVChFyV23xWCxAMU1a/iee2h1T4WN9FL
 UEQvC00osAa8E2tU8m4RBajoVaasRMGHdldCes37EeK0KW83uqCLmEJVHtFLdchrsJzHWFs3
 V6SlNSvDjtq2FGIdU+gGn6vhWraEQAeLHQJYmkPSg5t3jUpiNhbYs7nJjq7LJOIsw==
IronPort-HdrOrdr: A9a23:c3Ww/66oPnLO9sceaAPXwYeCI+orL9Y04lQ7vn2ZFiYlEfBwxv
 rPoB1E737JYW4qKQ8dcLC7VJVpQRvnhPhICPoqTMaftW7dySSVxeBZnMffKlLbalfDH4JmpM
 Ndmu1FeaLN5DtB/IjHCWuDYqsdKbC8mcjC65a9vhJQpENRGt1dBmxCe3+m+zhNNXJ77O0CZe
 KhD6R81l2dUEVSRP6WQlMCWO/OrcDKkpXJXT4qbiRM1CC+yRmTxPrfCRa34jcyOgkj/V4lyw
 f4uj28wp/mn+Cwyxfa2WOWxY9RgsHdxtxKA9HJotQJKx334zzYJLhJavmnhnQYseuv4FElnJ
 3nuBE7Jfl+7HvXYyWcvQbt4Q/9yzwjgkWSimNwwEGT4/ARdghKT/aptrgpNScxLHBQ+u2U5Z
 g7ml5xcaAnVC8o0h6Nv+QgHCsa5nZc6UBS4tL7yUYvELf3rNRq3NYiFIQ/KuZaIAvqrI8gC+
 VgF8fa+bJfdk6bdWnQui11zMWrRWlbJGbMfqEugL3d79FtpgEw82IIgMgE2nsQ/pM0TJdJo+
 zCL6RzjblLCssbd7h0CusNSda+TjWle2OADEuCZVD8UK0XMXPErJD6pL0z+eGxYZQNiJ8/go
 7IXl9UvXM7P0juFcqN1ptW9Q2lehT2YR39jsVFo5RpsLz1Q7TmdSWFVVA1isOl5+4SB8XKMs
 zDTq6+w8WTWlcGNbw5qzEWAaMiW0X2ePdlz+oGZw==
X-Talos-CUID: =?us-ascii?q?9a23=3AiPqvWGnCyIFSJ4xtxP96G501MuTXOVGe9CrtLWz?=
 =?us-ascii?q?oM2FSVLG+WHOcxIYntsU7zg=3D=3D?=
X-Talos-MUID: 9a23:k6ZZRAh5H6i7W0shmdbqUcMpbP5I04CCFUY2zdYtnpKNK3FzI2a0tWHi
X-IronPort-Anti-Spam-Filtered: true
Received: from aer-l-core-05.cisco.com ([144.254.74.206])
  by aer-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Feb 2026 20:40:07 +0000
Received: from rcdn-opgw-3.cisco.com (rcdn-opgw-3.cisco.com [72.163.7.164])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-05.cisco.com (Postfix) with ESMTPS id 39CD41800022E;
	Tue, 17 Feb 2026 20:40:07 +0000 (GMT)
X-CSE-ConnectionGUID: r4qN4Y7fSWuh0B0U7/PsHw==
X-CSE-MsgGUID: tnnl31NrRAGcZM2BKh6k4w==
Authentication-Results: rcdn-opgw-3.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.21,296,1763424000"; 
   d="scan'208";a="55703695"
Received: from mail-dm2pr0701cu00106.outbound.protection.outlook.com (HELO DM2PR0701CU001.outbound.protection.outlook.com) ([40.93.13.70])
  by rcdn-opgw-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Feb 2026 20:40:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y1lZnGKiKcWPRur0ibI52Y9qQoXoAaQkr3t9ylXc6SoXcjOA6lk9oV9peds1rILvHsaul/CgL7CwUzJL0oDw3wFez8Nv14kQD4yw+G5baOcJF9S+HgYLoyCnX+8OH2HAPakfuz5GZY4Vz6Id3LmxANy07EsifPqZLNk4tUbGDOi3rJTnKMll+syFs9ezRY4Nb1gUqaYtuYgNgzwNintbygpL/nKZ7L4d8YYHAzvROB8nqE38J/C/IpDYaZgSGtwzI9Y0/mePnmdVMvcAnXGFajVsF1is9gbAbb5w+7basKB//7m6r3UFrFunrrno/niRV1tjiiKP4G/+IpM1Rk4s9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFu6u3TopZs7q8Q4M4UA4ACutN2ZGcg1ENwDfmMVa/A=;
 b=ULhmjLFiY3el7vkxa3G/KJr00rEJCBD9kHoYLNE4hscdrGF3IxETVIah1V1U/YGFK9uPiVK7aL3C1k41TkljgAlKS3d616QOtZgk+Fhyp7zcXgTCtCAAUfTyc6DDikbcumLtdgXL6nfh/Ta41gGLNcZCGaKfSezVQ/F/Trl7MAdwbgIix9EEJ7qdMIH0Jccs1ty/bsDI6XXcpcl5dcIGgYbGgx2Mk7oKdbWTsfyucOuoptzlWDbPztqJkKdAOvNgIJbkaUsNjbzrZZ6SSa/R1muA7u50KBG6fdIE0N3xn2mtoIf/L2/AAuQnFA4639jk/xb/cASiN2RJITz9TYZMKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SN7PR11MB8042.namprd11.prod.outlook.com (2603:10b6:806:2ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 20:40:01 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%2]) with mapi id 15.20.9611.013; Tue, 17 Feb 2026
 20:40:01 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Narsimhulu Musini (nmusini)"
	<nmusini@cisco.com>
Subject: RE: [PATCH] scsi: snic: Remove unused linkstatus
Thread-Topic: [PATCH] scsi: snic: Remove unused linkstatus
Thread-Index: AQHcn1Al12nWvK9gpk6RDlGABB9OgbWHXAPg
Date: Tue, 17 Feb 2026 20:40:01 +0000
Message-ID:
 <SJ0PR11MB5896EFD07FB681EC55BB6B48C36DA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260216141056.59429-2-fourier.thomas@gmail.com>
In-Reply-To: <20260216141056.59429-2-fourier.thomas@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SN7PR11MB8042:EE_
x-ms-office365-filtering-correlation-id: 60f4c695-e368-4e2d-dd27-08de6e64b8ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?lNbzDCAzYtK1CMTyRYByd4Du8NyeYCNnkiYcsKMz65Qdd/+YSx77FRj+7aZ1?=
 =?us-ascii?Q?7TWi+9idXhx9TXKX9J9Ly6eA8j6ivSKZ23M7pI5Xqz1VoDDfH2pPkgdsjEyZ?=
 =?us-ascii?Q?xx7fPVwfXniLwVdkzcmLf/0D8Oq0+c5bPoYdo7AQON3nvS2nvoMAOaBp+7CS?=
 =?us-ascii?Q?ZE3frIWjlUE8UUW/pT8C/sUI9hqXwUd36w69znGHNPCU4oJOAci+6Q0gbIrp?=
 =?us-ascii?Q?xUYlRfIzZRYoOmLhRl3wVJxz2rxu4aSPlZ8tlxCB0gfHEwaImaMTjiIQNF69?=
 =?us-ascii?Q?7tpM2TIra+zAiIxB1nGcswruSJLHPNIGcQlCU0qpvCWcnnuQagzp/dUh4HrK?=
 =?us-ascii?Q?96UQOCwPSFKRi1qAN0k5Mqtu5kYxIDsZWaERA9cJTeYWYLdico654uQNLDDj?=
 =?us-ascii?Q?Cwi+NZSJn/ffwpVbw4saHp9th9prp2nzy7fyEEGFOs+Qmw5iHNT+66f7Peq2?=
 =?us-ascii?Q?9mSl36XKNK7b49c59qsHk+WP6jOS2g9ptqyCwUWrUMny6Cc4txvolKleT4GB?=
 =?us-ascii?Q?jb4MmdMq/j5d+z984CGXbz7lxV1D9DTz4PcIRm0ROI658Bd+t00yahMi9mwW?=
 =?us-ascii?Q?LctnHMknR8+uSYvvhpfHd2EuG5axXN+efgmq6uhOKHgfhxB7LgPgBic3sxIM?=
 =?us-ascii?Q?LYjtwFvaRy4PzbHarhA0QoQHW95pcb15YvYVnAJZFkpu8GEvKSn7DvYcbeXq?=
 =?us-ascii?Q?iCVhFTu7sjS/2xlQtZK3YXA3V4goe2I9RAvqDIZUKt9Y9zElXlMxJ8UGAuxn?=
 =?us-ascii?Q?hEJ9ZzHbGOg1+WPoW7vPYIukewEtqZI47ykmRtrGdhBldldIxIjJcD9nPiFP?=
 =?us-ascii?Q?w4/++cezN/2zsDupzkKpQv/pQQ+y/o9uylKwtb4pu8rmM1x8dEYb9nclrxw5?=
 =?us-ascii?Q?zE0ykuvndbfGv9tnICq0/nK/eTT0c/7iXwOI92PRxJOcvvsChlny2IAfL973?=
 =?us-ascii?Q?Ib2idSOYAdyFEcxGUWNMNdKU3crla9kALtWXQ0wEGKOA90o3ZqfgQj2N/y5u?=
 =?us-ascii?Q?MrAptqK1lbA/dzXIYkWnIA/dJIkbYPYX5uhktM9wbnQZruy4/1bU3RyGZ/2z?=
 =?us-ascii?Q?vUmZiFm80Db21Z25sra4KUGupXFdm0Pgdsn9UZK6gjOHCSjaI6QQKnPV27HL?=
 =?us-ascii?Q?y/Gj71xriadw7nDJ7q+Bgl+oNqGnt8O0OLrnaJXKUzag5hthIS5Z9pmXCPgB?=
 =?us-ascii?Q?9SNWrwm1N+m7wYZMbhm7uzEWydl8ddq0jrreZGgE5UZi4ImliNslUthCwsi3?=
 =?us-ascii?Q?mxPgamzAp+4qQ8jIKj6iKRhIv8/2R2a7rwhDMC+IsBxY1xmR685ysUQpbxO6?=
 =?us-ascii?Q?q8mXc8nJ8D8LMg+GYt3fQjhQrJaaT7cJMP6Y+w9dzYQlQr0hdIcE87zlI8vx?=
 =?us-ascii?Q?CHGRAs9muHYZo+Q7gvj7+IQ4y7ZiPY+mS6eQonVPc1y4E6h+8wpii0xG4hXV?=
 =?us-ascii?Q?IF4d8gALFniI8EgNhAPKTzU6n/i7mtbHsOwCuuDrtq+0SRz5TwxTQFWuB3TV?=
 =?us-ascii?Q?KR/3X5jEVAr2CUUMQLsgsuwU0/XKfTWNVP0ZP6s/QaF/L+iUpZl+nLyGlPHw?=
 =?us-ascii?Q?Q7yUJa/tZ5FcWB6GYO+8VvmJBL4ziAkPOvg2IX2NBLKfcK0SOaEgaSm6hEGA?=
 =?us-ascii?Q?MdeWyzlUDRWF1ewUHWj48DE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9HKAr3mA8+qWX4POvLSdfIG3FieoXc4vimiCHGg+9ZvYGuK/h7dSbP14bFRC?=
 =?us-ascii?Q?+BQ6Buxx8QLXYU6gJNa+R88In/LSkRsE9pOaXcZ6yXLfGsHiXxTBMqPBLQhe?=
 =?us-ascii?Q?vD/5oap4T+9vu4W5IY4jZTeHo8lHEcXjmX9uioIj2mUxIAegkc2oTH9Ym6oB?=
 =?us-ascii?Q?WK84ryfV/nMd2QTsVuy1WSwwYhd02nPnsh3T3j6e0zVsiiUt0xqoYBC/GiSe?=
 =?us-ascii?Q?d3uxlIl995iuE+lJt4bYDvvAPJMTSDvbrlCyTvlc4J4+OPOiALpN4hGoM7Ia?=
 =?us-ascii?Q?YjI5f75jxYhJpsV1fLrtRb2EcR2Ta38j2sIfnkqlHoEQ/06aNEUrYKFP915q?=
 =?us-ascii?Q?3Bs5p/mjguMvxbZOJ1ILnXtHzNX1g4Vmlr3gpPwOysvPLBetunR05BBMJIFJ?=
 =?us-ascii?Q?LR6QPdCoJhW/kWugPatnkEaRJTJBXI3jG4Lp1hAwRPiT+bMfozfpjndQIWws?=
 =?us-ascii?Q?A9zmfraYgOuEguJr0HF4mCXmstMUTagPn1h5U/O2b2YPnFRqQ9rWYhnO03y/?=
 =?us-ascii?Q?+KWwFXT8P2PxF0iQE/PwOlbJGyr0XMyI5tKUpU6Qfk+nVfStkibrL7SD/QdH?=
 =?us-ascii?Q?cpUg1sCbS3xOo5XlIfPZ5j+ByG9Q+7CVbmAKU3fjWTIybD1p/KaOJsMkwR7p?=
 =?us-ascii?Q?Z+Wj6fGXB8zEphDKgHCXSMdqL3W2FBeSfcOt3ZMlBs07E7KJgWGHGxRA4KZM?=
 =?us-ascii?Q?R12V9acgNQixQSytNqevwCMIvif4NOtKIQKNCMQGbvPxXs/5A64l3axURqh+?=
 =?us-ascii?Q?nxXP5pmpWSx5l1BvJ5+Q8YcpIxQPE20Y0xMju93bWAPvKXQBTZXeoBUOR54p?=
 =?us-ascii?Q?XiLnMbXDUHHpRj93HZvvjBdddN2FQo3MYejBjGhZ0oRzmXuQ6gF976xH9T9l?=
 =?us-ascii?Q?j5TkymKm27eFHamuwyeNInHNyh5L2WbCW0NfBO00GI/ZEcxWDzexz2t6Boq3?=
 =?us-ascii?Q?GWbz9cDE5U9nRNxK2A3QqkfKxKBor5LQpzlKM2j/OEz3FPnZ1aeqc9bWuSmt?=
 =?us-ascii?Q?8mmMpMYSYosHN8jz8kMEp7vkP8KMwQlpW88YhmkGpHxWSep9uMmMiPdjJf7k?=
 =?us-ascii?Q?WEFSTG7uDH/477cDMt6EeWlj49QVtwgxHKbfHGMwUykKqKaXXn2YWTJGSkKu?=
 =?us-ascii?Q?Nx2iM+Y+kZKpzOv+cbPIc7i6gzGxXBfZ+w9yo3rRyRx96yxsXKWHB96Epsnh?=
 =?us-ascii?Q?YfVWqbxFjCoeTO0QUrkLvuyE1KV+YNqAKXQTkSw1noVNWbjn4fMOQGfUWGzC?=
 =?us-ascii?Q?2oSF9Tj7BmGot1CKCfs1irMEU5/+KFmB19MxEOxbC4KZKPClPW2MZVwFDjdF?=
 =?us-ascii?Q?1krozbf9D47el/e/C+e0FQaW901v9tm5yuy73wKi/pXoRM/RCgx7hb8S8zlq?=
 =?us-ascii?Q?xpsMryzrqkSFH8jdqn+tLwFRyeIhn4mLWiWG6jr0LxvLv7oENL4w4fhApCPd?=
 =?us-ascii?Q?a6t5275X/qb84htQJ4KEtM58z0oaFaV2d8wG1RguLL68qYhlfwzwsQtNT1yC?=
 =?us-ascii?Q?4fJuvE1L5+5n8hym+eQ1TPKgbgXbdv9J4bykhwtMNby6lyXrtUtePoSnypSb?=
 =?us-ascii?Q?QeiklQpwliZ6qiemfJPmfvfIAeStf6CzWzqQZE6Zsqipcn5u9FbbHrkwnkl1?=
 =?us-ascii?Q?568/rQLT/mfSzw94LwptEX5W5Gl/OtQ/eo6ly5NE9VZHTX81zh4BxcyaT8hU?=
 =?us-ascii?Q?22OCkjmdNlOSriS+Ivvfage1fYEWtegFGnV/p0UQXBHDEuzQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f4c695-e368-4e2d-dd27-08de6e64b8ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2026 20:40:01.1133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cyt/Kwej39E08tFWCleD7STWh+iEJd+voL00o8BypfFK+2105z2XjRXP0HfH7nZFS97xDW8HDdk3DmdHaFP8LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8042
X-Outbound-SMTP-Client: 72.163.7.164, rcdn-opgw-3.cisco.com
X-Outbound-Node: aer-l-core-05.cisco.com

On Monday, February 16, 2026 6:11 AM, Thomas Fourier <fourier.thomas@gmail.=
com> wrote:
>
> The (struct vnic_dev).linkstatus buffer is freed in
> svnic_dev_unregister() and referenced in svnic_dev_link_status() but
> never alloc'd. This means (struct vnic_dev).linkstatus is always null
> and the dealloc the reference in svnic_dev_link_status() is dead code.
>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/scsi/snic/vnic_dev.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_dev.c
> index 760f3f22095c..c4df0b17c86c 100644
> --- a/drivers/scsi/snic/vnic_dev.c
> +++ b/drivers/scsi/snic/vnic_dev.c
> @@ -42,8 +42,6 @@ struct vnic_dev {
>       struct vnic_devcmd_notify *notify;
>       struct vnic_devcmd_notify notify_copy;
>       dma_addr_t notify_pa;
> -     u32 *linkstatus;
> -     dma_addr_t linkstatus_pa;
>       struct vnic_stats *stats;
>       dma_addr_t stats_pa;
>       struct vnic_devcmd_fw_info *fw_info;
> @@ -650,8 +648,6 @@ int svnic_dev_init(struct vnic_dev *vdev, int arg)
>
>  int svnic_dev_link_status(struct vnic_dev *vdev)
>  {
> -     if (vdev->linkstatus)
> -             return *vdev->linkstatus;
>
>       if (!vnic_dev_notify_ready(vdev))
>               return 0;
> @@ -686,11 +682,6 @@ void svnic_dev_unregister(struct vnic_dev *vdev)
>                               sizeof(struct vnic_devcmd_notify),
>                               vdev->notify,
>                               vdev->notify_pa);
> -             if (vdev->linkstatus)
> -                     dma_free_coherent(&vdev->pdev->dev,
> -                             sizeof(u32),
> -                             vdev->linkstatus,
> -                             vdev->linkstatus_pa);
>               if (vdev->stats)
>                       dma_free_coherent(&vdev->pdev->dev,
>                               sizeof(struct vnic_stats),
> --
> 2.43.0
>
>

Acked-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
