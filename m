Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E0315747C;
	Wed,  8 Jan 2025 02:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736304836; cv=fail; b=iiu2jPaOcL6/aZINibXlN3y1gktuBQSyW/5vIO7NoKlOtxjXs7jrln3LXfe/zoERVyi2YdzHbytOPQPFhWfGt+jDtnXk7Mb26FeFhHdw2aHOY+xG7M98IvgkLiHQMIQVJjscNXjV1L8z/LDcxeqE6uHDR0dn0e3i4YbnbFoSf9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736304836; c=relaxed/simple;
	bh=tcaoXJNgu3APHQ92k+WjNt3IiXNFUOXlVm6k1BQu+k8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B31NxfQ6swGF4yvi3GLE+EY+IEmc12WrOGYRAAUuI9jdHzVnO2qDS28TnJGWHQUa72hy1Kl6m3iu5lNomAC0r9oCu451JpndQxbE7lZJGwTFuPlmVb8874/iQmdf+SCV/vN24G31jThn1zDWV74ID1NhjgFJg8HISw8oJPm2aQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=ALkoaCJD; arc=fail smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="ALkoaCJD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2195; q=dns/txt; s=iport;
  t=1736304833; x=1737514433;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=32IONbu4K0I9qbD4cHr6eGTP4m/uAzI+N2uz9ZHrX/E=;
  b=ALkoaCJDiXa/V29+qm9Gkw7k5koikNf+NrTAau1PMENsrMPsZIzSGkYU
   blfmvuu4ItqjFDhdncuCRE+h+fyWC9ZvmqirIofTVHv8Vorky5fsNN2qk
   5KoR78s6Zwe+HfDOzYEB+3PNuuytC+xG0BGrdLFSt4G1a/bTKGKFejMlk
   Y=;
X-CSE-ConnectionGUID: ANcLaO7CS4SBkGD5zXh/lw==
X-CSE-MsgGUID: iGCoz23tT3uCNsfhJ3+LKw==
X-IPAS-Result: =?us-ascii?q?A0ACAADl531nj4r/Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVKCGUiIIQOETl+GUYIhA54YgSUDVg8BA?=
 =?us-ascii?q?QENAkQEAQGFBwKKdAImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBA?=
 =?us-ascii?q?QIBBwUUAQEBAQEBOQUOO4YIhloBAQEBAxIVEz8QAgEIGB0BEDElAgQOBQgag?=
 =?us-ascii?q?l+CZQMBpVgBgUACiit4gQEzgQHgIIFIAYhNAYpiJxuCDYEVQoJoPoRFhBOCL?=
 =?us-ascii?q?wSCM0uBK4JZZ54TUnscA1ksAVUTFwsHBYEpHysDgRQmgSsFNUE6ggxpSzcCD?=
 =?us-ascii?q?QI1gh58giuCIYI7hEeEWIVogheBawMDFhOCQD0dQAMLbT03FBsFBIE1BZpuP?=
 =?us-ascii?q?INvWiETHIITEZNRgyKMXaMjCoQboXwXqlOYfKNehSUCBAIEBQIPAQEGgWc6g?=
 =?us-ascii?q?VtwFYMiUhkPjjq5PHg8AgcLAQEDCZEcAQE?=
IronPort-PHdr: A9a23:xUE2pha27jF9H/R88dXnvMr/LTAchN3EVzX9orI9gL5IN6O78IunY
 QrU5O5mixnCWoCIo/5Hiu+Dq6n7QiRA+peOtnkebYZBHwEIk8QYngEsQYaFBET3IeSsbnkSF
 8VZX1gj9Ha+WXU=
IronPort-Data: A9a23:ijC8v6870ihSZ5eA8CkODrUDTH6TJUtcMsCJ2f8bNWPcYEJGY0x3z
 DYeWz2PbqvYMWfwL9B1aY61px9Tv8CHmtMySgs4qHpEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E/rauW5xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qoyyHjEAX9gWMsazpEs/vrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kfG4Y888EoKloSz
 tYbBxxQfCCDwOaplefTpulE3qzPLeHxN48Z/3UlxjbDALN+GNbIQr7B4plT2zJYasJmRKmFI
 ZFGL2AyMVKZOE0n1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3FbIKEKobTH5QK9qqej
 mPp1GPrWEoGCIeC4hye/HKO3azrvjyuDer+E5Xjq6Y12wfMroAJMzUVWEG9rP38iEe4Ws5YM
 Vc85CUjt+4x+VatQ927WAe3yFaAvxgBS59THvc85QWl1KXZ+UCaC3ICQzoHb8Yp3OcyRDo3x
 hqSlMjoLSJgvafTSn+H8LqQ6zSoNkAowXQqfyQIS04BptLkuox21kuJRdd4G6nzhdrwcd3t/
 9yUhAEYjJEaqpEg7PmA11Por2++lpiOShFgs207QVmZxg9+YYekYamh5l7a8etMIe6lor+p4
 iJsdy+2srxmMH2dqBFhVtnhC11A2hpkDNE+qQM0d3XC323xk5JGQWy2yGouTKuOGp1bEQIFm
 GeJ5WtsCGZ7ZRNGl5NfbYOrENgNxqP9D9njXf28RoMROcYrK1PYoH8/OhH4M4XRfK4EzPFX1
 XCzLJfEMJrmIf48pNZLb75HiOZ1mnBWKZ37GsCjk0nPPUWiiI69EupdbwDUMYjVHYuPoR7e9
 J5EJtCWxhBEGOz4aW+/zGLgBQ5iEJTPPriv85Y/XrfaemJOQTh9Y9ePmulJU9I+wMxoehLgo
 irVtrlwlAGn3SWvxMTjQiwLVY4Dqr4m8S9hYXV3bAbws5XhCK72hJoim1IMVeBP3MRozOV/S
 L8OfMDoPxiFYm2vF+g1BXUlkLFfSQ==
IronPort-HdrOrdr: A9a23:eQR8PKwNGaMzv9SmPMmYKrPxY+gkLtp133Aq2lEZdPULSL36qy
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
X-Talos-CUID: 9a23:zRto1G34ILsB1wlR+pBtkrxfM+YuVnT6k1zrf3SSCklFFa+lSRiU5/Yx
X-Talos-MUID: 9a23:9xjjwgrm+6jaB818NlMezzBNH8B6uf+yNBsQurMdtcmmbm9UGCjI2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 02:53:46 +0000
Received: from rcdn-opgw-5.cisco.com (rcdn-opgw-5.cisco.com [72.163.7.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPS id 2C25E1800029A;
	Wed,  8 Jan 2025 02:53:46 +0000 (GMT)
X-CSE-ConnectionGUID: v+nWbBujSku6X17d/ujpzg==
X-CSE-MsgGUID: YAzOOh2rQdmb8trDcRC7uQ==
Authentication-Results: rcdn-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,296,1728950400"; 
   d="scan'208";a="21083350"
Received: from mail-mw2nam04lp2177.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.177])
  by rcdn-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 02:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OvaV1KBpSFQcaFZwPWLK7bNV1dRurH0YZ0PfypkXJhHWBLGOAOepouahbsKwL4Bb1dNxEMrbDeO888NMD5JScFomhS1ixuT4eiEWcemANyfokCZ4hMIYL9HyUhZjIV67IgMFVi+x60aEK9IpQ7oUnOfpdg5kPAIznltWSCOZFxW6gd9GG7SWg49VaY1ZfTgFF+hiIhPmu6BzxulPhhlUg5WElJybuMRvM6VmR6m2C93d17+iXSBkuTOV79kooRyxVyF6mRNQciyIhDXj6LUks9RJtJP/nm/SWkvxFbs4P75geATSAsmYorBy+kIPCy3ev/KuQ6gasFxPr0Ok6ds+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32IONbu4K0I9qbD4cHr6eGTP4m/uAzI+N2uz9ZHrX/E=;
 b=dDSe01D048pUpGm7aZNy0WyyjElkBwAwUh9B+uVD8Ier8aamf/sTC9pISfYsBDkksXX1pZn2lH8vMU2p2q6FrOE0x3BQvNCPp7RfqX9D3HA3+ZRA7WQHBgg73qunjonDe6JIu1LteaywuclnjJxOyi+KrnbQvSqmqDqUF02Ml7Hv9C9HYLEE6KJPHS/tQmMKGF1vaLo7hAvBOyx2rgSvUn23VMBq8K2BhkTbcgDDcImSE/70tLspeO1XsescJ0Lg+WH7qdiB77T6cYhdEHedS6hl/Xp/S830cikZ4Xrn0DAZZk7c8FAt+DOnG1+8W1Iaaq4Kx/hbOmOd2nRr3bWcJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by IA1PR11MB6193.namprd11.prod.outlook.com (2603:10b6:208:3eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Wed, 8 Jan
 2025 02:53:39 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 02:53:38 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org"
	<kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: delete incorrect debugfs error handling
Thread-Topic: [PATCH] scsi: fnic: delete incorrect debugfs error handling
Thread-Index: AQHbYQkEG3bZWqGvEEixAtVDaU+AvbMMLkKA
Date: Wed, 8 Jan 2025 02:53:38 +0000
Message-ID:
 <SJ0PR11MB58963644926C264D0413D893C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <a5c237cd-449b-4f9d-bcff-6285fb7c28d1@stanley.mountain>
In-Reply-To: <a5c237cd-449b-4f9d-bcff-6285fb7c28d1@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|IA1PR11MB6193:EE_
x-ms-office365-filtering-correlation-id: 2c27c991-75af-4b77-3383-08dd2f8fa6fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?rZFh3kbA0ReheCAZCjIBbKomioUdbp7r5D7H0XvU3XDgXs9uBjf8dhRCfgWe?=
 =?us-ascii?Q?mRkuy6ekfzbt9x4EMYU2UlUmXZSYw0ZMI7+I6bS37heB5rBCDDRTNyxUpZxB?=
 =?us-ascii?Q?f2BfZ5SWRnncdcUyUToXo9LFHbVkpbFHxTyQprmHBiZm63TTpaYSfSmnMxa4?=
 =?us-ascii?Q?yhvfDIlItre3NdUzEoAvksXnK3JSK5IOQAOwnnIdfPt4edL3394x/OAGQOLB?=
 =?us-ascii?Q?qDbisxbCYwnRewU0xrRcHSgr5n2GJfrlmYAYjBrkGY/PmLUUDy2PmqIVyI6M?=
 =?us-ascii?Q?IRp030a7thCKDbJM77TDlu9x//ASUeGVkckPs8YXCEIOG5gOCfj7UxoqwBKH?=
 =?us-ascii?Q?3kUDa5XIu6ij/N0vV+lOvYOxcOGfXFFBhzmdTS5DIxIPFV/7AmKa0EXR+AWC?=
 =?us-ascii?Q?j8cPYt1CYaXQtCAnfJrtEQV6gbqe7KJRy+rE1Y0Zf3M0kvBkgBUbBhudAMMC?=
 =?us-ascii?Q?4W7TYadjWrDMxUzT4pp+cP+fRuVBBBAapJQI+VhDITvcueJRXOmFAUupT3Fr?=
 =?us-ascii?Q?r5+ERRiCxZ/ucncwrwXLQX6r+lFZUnHY9nbGk27Yfx12o8+ELJlOyIi+rIMa?=
 =?us-ascii?Q?BVoRbDxDi3/z1gYOIvyEFSCLaR34YwJBSz4n/AWLxSe0MALmA0torqzjSYYY?=
 =?us-ascii?Q?8F1DCbxrBbM7n1qiNygIe+0guZcYZI8JU3z4qf87SevBPLH1lrB+bO+XvcZb?=
 =?us-ascii?Q?/qZOhCM1I4jvs15V87DRrDkR7MtX3dKV30SOy3WBT5INiNePK1r8cBx1fPtX?=
 =?us-ascii?Q?yXorBk9rCAHVbjYc+0XGtc2O8sWYndM6UxTp5b868uwdDt7Rpk+aSq+0gyBk?=
 =?us-ascii?Q?bCV3/Ko3uqu14pMHlwXf5fuJMC9NmGpuncCuv1rBS13QEe4tq0GRGt3sazsI?=
 =?us-ascii?Q?aJ9bLr4HE1WUT2jaQf+Al4FQBVVqlxFEm3fBvsVBPf8yGHHodQhcm49glIJV?=
 =?us-ascii?Q?PQ/WNLvj6opsuuhlRfpTzlNabtHDkN3if4ldTQaJk4lGgWrFcSIE1Qe6eZHd?=
 =?us-ascii?Q?97N0PKWMFa6WtbAn+adFxQdJU4yFb7ItJJL9M1fxlDJeqAl5yxtSW0OCr8ot?=
 =?us-ascii?Q?gUL7/tGuN4w2vOEE6Yl7LsnlYehee7fI6amxNy6hAQ8IPnY+QWpt3BiRVV53?=
 =?us-ascii?Q?2kyHaWyPm0Oz1NKpmNNv9HaihzWJXfdLhtizD0OAyawoB2iYlLnqBbd6iC+i?=
 =?us-ascii?Q?myn30juidcKNkNapSBlrA5Z6kMkGzVhqu6YXg6iipDIuIMByc1oN1F8n7pED?=
 =?us-ascii?Q?ghYYz0yI2ohndND6VW0u1nSyPV+7GOBkgqauvr/gr8oWmtbcouM1AfMaJTN2?=
 =?us-ascii?Q?IM2z1meE8oLpXDlbkbDiwuXuGvfQG2g4UvdbDKhloNjgiruTcrtE/4KXXj+u?=
 =?us-ascii?Q?A6GXNU/BcZr12PYSAmYV8Ai/f8Fo+sPPcYVKvhY+uz+JBfUya5KBo1TTBxeC?=
 =?us-ascii?Q?E8JYXmH0to4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?2kCLitvAuxSxAhnEC0gJomK92Aj+8b0uYmxDz1gfd3Vp+B0tfVm6u2o67pRC?=
 =?us-ascii?Q?nMz7VF1MIKkeNESc71cFoDDtyl+PzcK0JEde3vftdTtAISvK3/u0hBuLU0qn?=
 =?us-ascii?Q?x2DxCuKN48WrW1vDk3PNVYzHSYRLZSE+0yTNpFImxpn5qET3gILoqBgb3JJo?=
 =?us-ascii?Q?RppFr4GI7Pjl68JKyx/Htzc3REfAeu7ehhmW9bLx4QhWAIbC4yHxD7pQ+a05?=
 =?us-ascii?Q?lET06Xr59jPyjS5DSdaFs2+k5NoD4hzhy135uKC0vR6o1TQD9/xr38K5P8U8?=
 =?us-ascii?Q?xZUSpibNTgH8ximFM4Nea05rY9VJ7a5BNe7Q3j0gDaYZhMOTq+vK/FsKqOLp?=
 =?us-ascii?Q?KMy5LZbv+zdfUeMDznKXzkM5eWiF7W1iodJx/Oqcj4p/ccUhyECB23epgaox?=
 =?us-ascii?Q?9TYCcBn3ZIW2nlizoAz4mx13wftE9MQ1s+vsA3vUZjfXF15THuhit+UaIZ8F?=
 =?us-ascii?Q?B3dLk6aGPs8D8Ti3OcXBIYEbeug4DoWgnxItnP37vRJzqf+coFAEBiZq3ye8?=
 =?us-ascii?Q?t+hgZsT7IlxZuHukaIoZ6yFXxmLyFEX4CDrwpUufzhomkKWmvet+AE30ALXN?=
 =?us-ascii?Q?w9ObX1yzfmYcBkNDBoXaACXHfaUopfN/FF8o/awhweZFvvcpmLu6CZJTJnRf?=
 =?us-ascii?Q?v3Tct1zotYtYENzLlYxngYbndlIBb2rez7mcfEpGi0dLBYr+vF/14SwrskVK?=
 =?us-ascii?Q?eEvXa5QoAUDVQJkJFV7Rzc5YVYlwz2igssmSbjPg9o8+8aFLqmzS8MXC6UI9?=
 =?us-ascii?Q?i83C+Bh9tCQQHXBJ3u7z8GyJMfvBZ1gUoNJm9QGU5x7YX0KtaESrK+tsUqxx?=
 =?us-ascii?Q?klH+aLCZUyV66R/y29zFChvWiVOuqfmJASDjPHbDU3A8m2uFK0LV8Qm3pgIg?=
 =?us-ascii?Q?BtcU0HEVs9N5avWr0R7I0Akp6YIXU3ly6DWXMF2INuIOTMFzSYgykvr8sNf0?=
 =?us-ascii?Q?SgntoQ582EI9InllavlMnI80yRoCX2PXfKV24DtUirMSbaxkrvj69EWeLp0v?=
 =?us-ascii?Q?m6phcr5XnGsE2rEId6mmBXoTUUrYdU3kBKO/0KFq2jg8gvx+f0Zd9h6uUHd6?=
 =?us-ascii?Q?ckwy5T38NxGomBtrG7Z4e0Y4BNRba20ry4eWIYP5HKpvwyl69AvOLjng6YiB?=
 =?us-ascii?Q?qMwPGPWpEGKOFGQnLMjBlntrM5tVTRN2DRuWaUU8ZPUNzcLhJsQ6jO9qOATz?=
 =?us-ascii?Q?OxPWfoEydRJ6E/s2rNviCQCIKuChLOHH2mPunm48C50n6z/uEG6NC9wj9/Ly?=
 =?us-ascii?Q?e0f/fyURzeAl/RZ/VTmhed4gs2oVfpfLwPjBSlBshu3IKrxrAhOqPJ22QMQ7?=
 =?us-ascii?Q?m/EujKzLKb9i+r4i1bwrn5KS4yF5f0vn+4KCH6GuxpLNRuIALHfAA6zOgaC6?=
 =?us-ascii?Q?hsp8t7mHAHKThtrMJ243QpcWGj7gEo69yqAEuFtGwlOGTOa54YMWEqA53X3S?=
 =?us-ascii?Q?ZYEaSBQHiqrhkd70YjHsop+Lb0TDawS7Jde9aIu6Kckn/BrK8pdnXtt9x+XY?=
 =?us-ascii?Q?ggQlJzQumkoYK+5d0+wjWCebdFQBhPrgb1Ft34gXbGCOPnc4uzmIPQ/9bPnX?=
 =?us-ascii?Q?uZ+u6IeIS/aUcXJJpsYcYll3qRlCliLrvl1b8zy61K9dV73hgEHe4HXYgJuF?=
 =?us-ascii?Q?zCM0JmcKimDHtFql+3jI7uw=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c27c991-75af-4b77-3383-08dd2f8fa6fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 02:53:38.4439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GXlZQVqn4SJaRQCwKukkTZAq87uOBxx2Dm1afu/1AQI/7OBhTYOXOyHUuNsyodc9mX9nMQ3Cc7Glqjc94CBfSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6193
X-Outbound-SMTP-Client: 72.163.7.169, rcdn-opgw-5.cisco.com
X-Outbound-Node: rcdn-l-core-01.cisco.com

On Tuesday, January 7, 2025 5:35 AM, Dan Carpenter <dan.carpenter@linaro.or=
g> wrote:
>
> Debugfs functions are not supposed to require error checking and,
> in fact, adding checks would normally lead to the driver refusing to load
> when CONFIG_DEBUGFS is disabled.
>
> What saves us here is that this code checks for NULL instead of
> error pointers so the error checking is all dead code.  Delete it.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> drivers/scsi/fnic/fnic_debugfs.c | 25 +------------------------
> 1 file changed, 1 insertion(+), 24 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_de=
bugfs.c
> index caee32bc9190..5767862ae42f 100644
> --- a/drivers/scsi/fnic/fnic_debugfs.c
> +++ b/drivers/scsi/fnic/fnic_debugfs.c
> @@ -679,46 +679,23 @@ static const struct file_operations fnic_reset_debu=
gfs_fops =3D {
> */
> int fnic_stats_debugfs_init(struct fnic *fnic)
> {
> -     int rc =3D -1;
> char name[16];
>
> snprintf(name, sizeof(name), "host%d", fnic->host->host_no);
>
> -     if (!fnic_stats_debugfs_root) {
> -             pr_debug("fnic_stats root doesn't exist\n");
> -             return rc;
> -     }
> -
> fnic->fnic_stats_debugfs_host =3D debugfs_create_dir(name,
> fnic_stats_debugfs_root);
> -
> -     if (!fnic->fnic_stats_debugfs_host) {
> -             pr_debug("Cannot create host directory\n");
> -             return rc;
> -     }
> -
> fnic->fnic_stats_debugfs_file =3D debugfs_create_file("stats",
> S_IFREG|S_IRUGO|S_IWUSR,
> fnic->fnic_stats_debugfs_host,
> fnic,
> &fnic_stats_debugfs_fops);
> -
> -     if (!fnic->fnic_stats_debugfs_file) {
> -             pr_debug("Cannot create host stats file\n");
> -             return rc;
> -     }
> -
> fnic->fnic_reset_debugfs_file =3D debugfs_create_file("reset_stats",
> S_IFREG|S_IRUGO|S_IWUSR,
> fnic->fnic_stats_debugfs_host,
> fnic,
> &fnic_reset_debugfs_fops);
> -     if (!fnic->fnic_reset_debugfs_file) {
> -             pr_debug("Cannot create host stats file\n");
> -             return rc;
> -     }
> -     rc =3D 0;
> -     return rc;
> +     return 0;
> }
>
> /*
> --
> 2.45.2
>
>
Changes look good. Thanks for these changes.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
