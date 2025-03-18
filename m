Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2344A15B102;
	Tue, 18 Mar 2025 01:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742262495; cv=fail; b=XICwkuyoowzr0/vZomB7FNmyQ9fZf/hHgjmqFUh8oGe/GgsqzTuOAmMC/HsZ8Le9k76Zw27F+kay6pqDDSVpGzCsiPA5DDiR0Apvz381U/QaigVwtoHwBZd6HJHqMdx5vPyvu0Gxh/AVc/FqsSthjoXxNktLOJgfal/DbN10uUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742262495; c=relaxed/simple;
	bh=TzOeffeYffH7HKDO8i13lHmmR5igA7X7VDcDdoq8tKk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MxKhN048ZcUBeavhF4WchtgpUJIGuJDXrBnHDR69NNbTmTwR48z+pxmEIJ0GedzsJMzyFdkxnZxiRvIipvALB9YYNZJ8n6z2YjNg/CDQKZnwk+gff6J+5lp9B9xaSxEBnwTuRZK3Rb5OootzJI5P6G1/fL22J+eaOxsi+C76e50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=irqOcJVF; arc=fail smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="irqOcJVF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1898; q=dns/txt;
  s=iport01; t=1742262493; x=1743472093;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iE630s9DGDVer3kMufDWTW1TQ2E3FO5hGlpsoPxHUYY=;
  b=irqOcJVF1iiTyFDZpbfdG+lVqS6K7v2N734blTvaAjEb/sJamTAZ03f7
   oz2/LVnG8hBkhTl/n+P04P3FJtsJStX/dj7MxeAcYpX/NvZUya0TimiHE
   cUK+ARSkKgPKz+n8mHs1sgoGC14pkpQ38zcCK9FDaMMw6TwKLqGZ5DwAv
   3LYS3S3VOvrUqR9E90cwDJlri3RSbMEQFH4ALmF96GhAAj0RQGzfffs8l
   SxEza0cWKn5zsFF9KksmDIFd+J4ExSommHmlImt6oZwUbIIah1FacDYkJ
   6D7GEIcg+iQjQ9DR14/zb0RczuCVvuUFIuc2xr++Lg1SnFZSHrwv892Jm
   A==;
X-CSE-ConnectionGUID: i2vMOCb1RMSuQKtKIm6siQ==
X-CSE-MsgGUID: nDlSLiyfTD2UVEURp24Sbg==
X-IPAS-Result: =?us-ascii?q?A0AOAAAc0Nhn/5MQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAUAlgRoGAQEBCwGBcVIHghJIiCEDhE5fiHieFIElA1YPAQEBDQJEBAEBh?=
 =?us-ascii?q?QcCix4CJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4Th?=
 =?us-ascii?q?giGWgEBAQEDEhUTPxACAQgYHhAxJQIEAQ0FCBqFRQMBoTIBgUACiit4gQEzg?=
 =?us-ascii?q?QHgIoFIAYhPAYpjJxuCDYFXeYFvPoRFhBOCLwSCL4FpglpnmXuFdIooUnscA?=
 =?us-ascii?q?1ksAVUTFwsHBYEpQwMqNDEWDSV9BTQ0DjgpgWNpSToCDQI1ght8giiCF4I3h?=
 =?us-ascii?q?D6EQYVQghFxbAMDI4MfdRyEPj6EZC1QgU0dQAMLbT03FBsFBIE1BaIPOoREg?=
 =?us-ascii?q?Q4cgg0XsW2VEgqEG6F+F6pXmH4iqGcCBAIEBQIPAQEGgWc8gVlwFYMiUhkPj?=
 =?us-ascii?q?i0WkxUBqnh4PAIHCwEBAwmRZQEB?=
IronPort-PHdr: A9a23:nb66TxHZ/8dR8hzBgRgvzJ1GfhMY04WdBeZdwoAsh7QLdbys4NG+e
 kfe/v5qylTOWNaT5/FFjr/Ourv7ESwb4JmHuWwfapEESRIfiMsXkgBhSM6IAEH2NrjrOgQxH
 d9JUxlu+HTTDA==
IronPort-Data: A9a23:OEsHh68vslhsBQbYLEELDrUD6H+TJUtcMsCJ2f8bNWPcYEJGY0x3n
 zEaCmHUMvzZZjH1edona9uw/E1Xv5LSmtM3G1BppCtEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E/rauW5xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4quyyHjEAX9gWMsaTtLs/zrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2k3Z5M93c19WFtrz
 uEhCywuTxXdnOOPlefTpulE3qzPLeHiOIcZ/3UlxjbDALN/GdbIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2cPHWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxbICEJ4XXGJw9ckCwo
 E7CxED4Ex8mGIai9xe4yGr22tTFknauMG4VPPjinhJwu3WXx2oOGFgVWEG9rP2RlEGzQZRcJ
 lYS9y5oqrI9nGSvT9/gT1ijq2WFlgATVsAWEOAg7gyJjK3O7G6k6nMsRzpFbpki8cQxXzFvj
 wfPlNLyDjspu7qQIZ6AyoqpQfqJEXF9BUcJZDQPSk0O5NyLnW35pkunogpLeEJtsuDIJA==
IronPort-HdrOrdr: A9a23:eoPYzKwT6Ub7se1+ayAfKrPxY+gkLtp133Aq2lEZdPULSL36qy
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
X-Talos-CUID: 9a23:xUCZBG9lovqFUrExRneVv09OBOUCWXeE9lLrPnabFUVITeOOSGbFrQ==
X-Talos-MUID: 9a23:dPU7gQvU7hmY+z4cKM2ngh1mD+Np8qqSJBowr7g7gdHeaRd6NGLI
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Mar 2025 01:48:06 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPS id 6684B18000541;
	Tue, 18 Mar 2025 01:48:06 +0000 (GMT)
X-CSE-ConnectionGUID: tu7KlYBMRHGt4fqygBuXcQ==
X-CSE-MsgGUID: +Nm3gkILRjqAQzLe3AOhzA==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.14,255,1736812800"; 
   d="scan'208";a="48543438"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Mar 2025 01:48:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BYkZlIiEa0J3DF6blRLMNwzBhmHjq1C1+aQu++7AL0K8Vg3dLcguzYwLhq8LaYy5IZjFa6iQHyS+FBx/LNBc8wPZbqNYqnqamL6lflq5z8rLAWUWjBIjR7+ERiOdUdKNzUi8DkIg02kyuSIXKVxJ7rAwM44ar3GvbHGLvfDif7QGF5ukirCEUFK05VVxMc8OsfuAC0cDMt8IpaHDl+/ls7wyidCXXY0kpTx9tuN7haB8SWQsfgHutQp/0m8Rqw2rpsEItStAjk/Zj+O0RR78vaDUlN2z6Mu2UyPB2R0O8ZwXaxxowrzUl+/XQhadFt692rRVOX2i+/Yjq9glUCp77w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iE630s9DGDVer3kMufDWTW1TQ2E3FO5hGlpsoPxHUYY=;
 b=N7I7usMnHO/s/uL0L06hy+cMh/KQFB5fbG6/1kFMZ/5Guv4K7yTePPPmCYSJ3/yUEZfVEofDqthcXNZAyY0yScuerTZ/hgCM1ZZj4oAeA6Fx/Xn0Erk3Lo9Yp0ZYMy4+sJe/wb62M9SEf79PD0elEPBlZogJtUeDly5z0ySw+hUG/kVKzDR3HSN2P2LJxlL1MmOSPy438zCmdcS0LVaMf0UyozMt9ng2ZqPt6zdbOPlzOOG70AuyoyWjUbYjkirNqCGHKfVYSqySq6kBvtpQRXCSayoSvBpgDTXlp8d7vcEH8ktmBRHLv3hKrtiy9DwyLpzMsvYZ72a2wtcObghZJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 01:48:04 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 01:48:04 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: Remove unnecessary NUL-terminations
Thread-Topic: [PATCH] scsi: fnic: Remove unnecessary NUL-terminations
Thread-Index: AQHblS7mmy8YtcNNyECIwQhwrznJW7N4JHTA
Date: Tue, 18 Mar 2025 01:48:03 +0000
Message-ID:
 <SJ0PR11MB5896B37C2998850BF11B58F0C3DE2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250314221626.43174-2-thorsten.blum@linux.dev>
In-Reply-To: <20250314221626.43174-2-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DM4PR11MB6020:EE_
x-ms-office365-filtering-correlation-id: de8d4d4b-954f-4d6f-4233-08dd65beec63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?DmrQvATyy5PBT8Qac9ScYPF27+ZAeGs7lFlJr3R2Rq9y5YAkuXyHlQPTEqfp?=
 =?us-ascii?Q?/yO9znniFBr6ZLCRjFxPiJc7RpcLHb3X2Qv+nuvixMPsdhlDRsuTsT05qU8G?=
 =?us-ascii?Q?tutD95QN1raDspwaeDxWhv/GOZIj8NJHlu7G/+IP39fPvBfAUd3ni84MUvOZ?=
 =?us-ascii?Q?J4rKkrBD6w0yqBNWJtOUsgrfUXKedu5VrwHdqaPMgwzHIz2sYggXCEocQme1?=
 =?us-ascii?Q?ROJuR/Mo/OtKfN27ArsHmF6J4k30+4P+71qZIdCIouoZAg55xQPqobLWEUTj?=
 =?us-ascii?Q?N56vfAdH55hbDzAnF8u3hcOfzTaJ03BqKRydN29irZa0otJZi4h36RqswDfG?=
 =?us-ascii?Q?oeL11Lploi8hkgf7mlhOo23X9nIH6e7jwO+Oyo5SY5mNWc49gcjI7zkmLb9P?=
 =?us-ascii?Q?xmpBPJzJaGkKRpxJP44fOKa1KnTh/lpG9JYVOm53e6fnbr8M7CNJTmq0jJI4?=
 =?us-ascii?Q?xEzMOcPmUs6IOQs2LK5Immx+Za+s2j1Eb5aK22irnBoTPSZp1iTQGaFVCV03?=
 =?us-ascii?Q?40HzZOoaEZl3/iwR6n6LkVOWTixvpK1fKpjh2moOjCdDM4jENcoBTU6b2LXM?=
 =?us-ascii?Q?7bWoKLcd/IWuSin0wt98qNBI1fap9jBQ+GfzKRI2SC9GUFOcdtwa/InHRYt7?=
 =?us-ascii?Q?Qg9QFwNOIwkYJA2Q3lU2xz8/7iFysps4t+lri2a2wYNNINxpBFhQyQJGSSVF?=
 =?us-ascii?Q?jyrpcgzmKEHA349Ms7jIuI3cn0d9AWLyNauYXQutCMNksu6UdJwephpwFKH2?=
 =?us-ascii?Q?aPPVt2ZvTNFjttNFozB4KhyRmHFvPtUDlDWTFe9nBP1bw05N5crXqhNocfMT?=
 =?us-ascii?Q?4P1DNxnqEpPqxWcv10mBEBJjKcMOnc/inxVe2lMpR2gaxXUo7shfh+gaPZH9?=
 =?us-ascii?Q?x9kgH3Yw/FHJ2CMu6x7jabqZrJOOLomAChff3bCYVy4CTRRsHX7FKPOfg9K/?=
 =?us-ascii?Q?KPBRQTXYcDlslt0KajhHfJ7UXdNOvXZ9I97F4hjBTDhaQZX93uLJxwmmDmxt?=
 =?us-ascii?Q?rQe4rmQO6K4GFCtzMdBwsH31bVI2qFjFM/EXL3vXL8Dyq3/MkKrj1ca6iSas?=
 =?us-ascii?Q?ifuAovdt8s+0nyC4+laGz032PXhUnLDfaxFSOE+kdK7PI1jPFP1DJtEUtc+M?=
 =?us-ascii?Q?3dr9LREQE7hmXB5ldOChsC4BwTzZbMYAU+dpIcadrj6Qpoc+n0RHlVo9RMQW?=
 =?us-ascii?Q?NJuZjZf+3s338R319grGgRQ75ToutUOwzgLJHNH5LY980bhS8fhGiaWIxPF0?=
 =?us-ascii?Q?60PFydKJzn5M7PwZd9pjMeurjss60nsqMYvnVtgBzMyvdgWkLL/vOLeWQGae?=
 =?us-ascii?Q?03qGspuWJvrB1Td3l4IND6M0lGmvba8QFZ96PxrX65sZo+OUXQppJ4Rgeyo4?=
 =?us-ascii?Q?2OGBcxNUBdeIBtfkT62GA7M/PRlTAQEEYeu2y79WSIrGFzxkTRgfCxotd1zv?=
 =?us-ascii?Q?TZcaCIT37ngFSL2190p7IX5+7oCYF8k6?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?h5tpqSl6Lm9S9SER4FbHUeK2n3o3gGH1zBeSGM52goOFXH2dvuBBDEPy+80q?=
 =?us-ascii?Q?5B5H8FAk/bIg7He3rbQS6maHNCVl6cpw/L8IJPCpeNsl6KN09QrDH9yQ7Ndl?=
 =?us-ascii?Q?S7OqRMLhGGHFY6UCZZf5KXwYfm0FnJ/pB0tYr+DaKE5wpExU/vpbL24NPbK+?=
 =?us-ascii?Q?re8id2c7+eJefyBGwGQlNAn32tbdCMcsw1FPu/APZf5R3vH9p7CNCl8uJDY4?=
 =?us-ascii?Q?cqPwLEFybeZkNc50noSBCKRxxbbgzFQiPCfTbO3YplvZZiR4J+WCqMCP24xo?=
 =?us-ascii?Q?hi1OZ5Q6jFPVsSvLCqYvf9UO0syoBIp8gCmyFyH2y42FOUk3Ri7/jD6YMHaj?=
 =?us-ascii?Q?a4bFSc+8jLJGm5ggK9QYj3OZxbNednt5qfRx9PeRADhFdsVtp403qHftfFwZ?=
 =?us-ascii?Q?rjsa5Zqww2M3v0DgQU8l7hkh0jvOfHIva841bQJG30TFbMG6YlawLsyIYPbL?=
 =?us-ascii?Q?BpqBhoV6klpXAUEHo5O9wSR3BlMn9+8sRFJV6TOehw5g7ucWcj/LjFD3Nntr?=
 =?us-ascii?Q?O4N8XEDiqi9ZcCt+fojFLmsSj5gv1S+Gr31YUlkczrMKVyXxp9SrwgoKxkmE?=
 =?us-ascii?Q?YyetTjhElTF/pHM78FVOy8/Z8CgjmsJyiOVPQw/zzXdN+HcOf+BZtV/M5tr2?=
 =?us-ascii?Q?p8mSy0hjS46oUK9lKqWYlubwQYZUvlY7JNJgZDQrUwPnNiTpvBzKbCAhUs0q?=
 =?us-ascii?Q?Mx1teqca8PgRLlDEWCUOkFkQgLx/57ZpZ9BxqKKSwijRcNlFf6dzbjSJTC5y?=
 =?us-ascii?Q?mGCieSWiNLsvpgCREf5OmJJEurDkoaMrEnwvnsUTm8G2kwggImbAZyvRY3WE?=
 =?us-ascii?Q?P4N41TU5xkR8lESIzhf++zs3vFbm2COPCYWFJ129mPDH9scj4gkcrfOBgeCA?=
 =?us-ascii?Q?SZarpJ9rBITCVyiiHu4XL/4ffkow2hWTiPXk0h6yfyy7k320MHjEEr7K2ugp?=
 =?us-ascii?Q?tOrGdUP37vjEOFjt6Ax4W3NgDbmsC/wk1P2giuidt/agVI+WYUI9h4/mJGtM?=
 =?us-ascii?Q?Wet3aNO+4kNNyW5TyWB5CPrTJSA/6A9FSQ91iminqS+k8OYDuJX+idnMYYHU?=
 =?us-ascii?Q?g1rGOlm8oMOcmt4IpFcaKc1EHbhOeg0eE7WVfdNM0f2n2agPVGQtGER3cLR6?=
 =?us-ascii?Q?0oIffSmCRKEtRTJuYzChKPXzIgRYLXUXlSA5yZTkRkEZCvpWQOh7xQU8V63r?=
 =?us-ascii?Q?LrtWcMip06xRV3tMaBjHQS2H9LQ6fWPN3b2sEErNt/Ouax1m7hGNwGDiYTTJ?=
 =?us-ascii?Q?yYXayYvV8hgZBU2SLurhq8JPgHSeJKahk7xyqNjLPcuLrIlt6HLFcLbmFa+r?=
 =?us-ascii?Q?G6bgJfU6pw5g6PyeuJdVfNoV2trJbSXcSFjTfy4ku0ffT+1OrXhTU3bBajj9?=
 =?us-ascii?Q?F0w7n7ThQqYI3nptVZgkZMF/vogSD8DBc4jfYbQcmPTfpRmV+z7+r+JbqyC5?=
 =?us-ascii?Q?pWWzUWOP60v6Q4BJ7Mpn/DVmRFHZ7vK2idpzr24s+VR5MayToPQ7gkspxIlm?=
 =?us-ascii?Q?PLiz3GR/3l1/xwy5bh4MBo4amcz1U/RNheQ76jMgaOntkspESxrf+JjhcM0I?=
 =?us-ascii?Q?bOgXKwZY4xvSeVybJWvc7WdzN/n9eENW5n3jMHWRp34WeQIHPXwVmKQ8RRQ1?=
 =?us-ascii?Q?lBfRLUvBncMbaQEQql2zBKQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: de8d4d4b-954f-4d6f-4233-08dd65beec63
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2025 01:48:04.0116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EjVRmvkmVUZbzSzOzNpeDNYqcX+sfbjjN3T7T3xEDhUjYblgC92CI3QABDZIFWMhVGOzHBF9DLG5hePns2I99g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6020
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-10.cisco.com

On Friday, March 14, 2025 3:16 PM, Thorsten Blum <thorsten.blum@linux.dev> =
wrote:
>
> strscpy_pad() already NUL-terminates 'data' at the corresponding
> indexes. Remove any unnecessary NUL-terminations.
>
> No functional changes intended.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> drivers/scsi/fnic/fdls_disc.c | 3 ---
> 1 file changed, 3 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.=
c
> index 11211c469583..7294645ed6d2 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -1898,7 +1898,6 @@ static void fdls_fdmi_register_hba(struct fnic_ipor=
t_s *iport)
> if (fnic->subsys_desc_len >=3D FNIC_FDMI_MODEL_LEN)
> fnic->subsys_desc_len =3D FNIC_FDMI_MODEL_LEN - 1;
> strscpy_pad(data, fnic->subsys_desc, FNIC_FDMI_MODEL_LEN);
> -     data[FNIC_FDMI_MODEL_LEN - 1] =3D 0;
> fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_MODEL, FNIC_FDMI_MODEL_LEN,
> data, &attr_off_bytes);
>
> @@ -2061,7 +2060,6 @@ static void fdls_fdmi_register_pa(struct fnic_iport=
_s *iport)
> snprintf(tmp_data, FNIC_FDMI_OS_NAME_LEN - 1, "host%d",
> fnic->host->host_no);
> strscpy_pad(data, tmp_data, FNIC_FDMI_OS_NAME_LEN);
> -     data[FNIC_FDMI_OS_NAME_LEN - 1] =3D 0;
> fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_OS_NAME,
> FNIC_FDMI_OS_NAME_LEN, data, &attr_off_bytes);
>
> @@ -2071,7 +2069,6 @@ static void fdls_fdmi_register_pa(struct fnic_iport=
_s *iport)
> sprintf(fc_host_system_hostname(fnic->host), "%s", utsname()->nodename);
> strscpy_pad(data, fc_host_system_hostname(fnic->host),
> FNIC_FDMI_HN_LEN);
> -     data[FNIC_FDMI_HN_LEN - 1] =3D 0;
> fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_HOST_NAME,
> FNIC_FDMI_HN_LEN, data, &attr_off_bytes);
>
> --
> 2.48.1
>
>

Looks good to me.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
