Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C44DA34;
	Wed, 12 Jun 2024 22:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718232546; cv=fail; b=gUYomert49bvuY+xp+YqNcIffoo1j05LMJmtl1bat0ZM3xE0UQQaEkLZTx2yxGlL1SJJwrxMA+vUeyBcp8shf0W9a8BTocNelO11LVNk2TV2oE4SjcM3T6+0bsMKAa+F1T92j+oUYIDLv3XGMv9G/2oghETqzO5E2J0eiwcHmwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718232546; c=relaxed/simple;
	bh=IFH79KVtKqvZvX/oNTESTKnk/9jTxpNNCEBnyHk9pFM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TdPKG3s/6m8W+KmBvsbPlF9yPwJgRoDmqyrHy4l9f4Lg3fSgcK2Y/aZDMcPreR7p8zgjbFS13JASK83lhnx5wMkaCvI4luiGRwfbyY0hpt4XRn11cOaitcG2nP+v+A4ffanZLSFXfaDvB5aalIWYcRbkxK3fbuDVWdr9q8JPwf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=WfsUb//B; arc=fail smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="WfsUb//B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=6824; q=dns/txt; s=iport;
  t=1718232544; x=1719442144;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IFH79KVtKqvZvX/oNTESTKnk/9jTxpNNCEBnyHk9pFM=;
  b=WfsUb//B0paDQspKQmjwQ8cxe22kKQsLC8zw59SwKARhH6mTOML226P/
   3piIgRO3NKX5dMxB3v7g3Jy1LroP8DugZI4fS+Ye81r0iwjtjYhB4SlWD
   6I3O8roIJVbjQLyMd3CwQLiQcEv0JppYvnO0PJcdj28O2m5J07fpQ3I27
   Y=;
X-CSE-ConnectionGUID: hQly0ZNjSNGREndVlAszmA==
X-CSE-MsgGUID: PactSvqwRSihFJbhCMo6rA==
X-IPAS-Result: =?us-ascii?q?A0ApAAAVJGpm/4QNJK1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEWBwEBCwGBcSooB3OBHkiEVYNMA4ROX4ZMgiIDgROceYF+DwEBAQ0BAUQEA?=
 =?us-ascii?q?QGFBgIWiFcCJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEFAQEFAQEBAgEHBYEKE?=
 =?us-ascii?q?4YBhlkBAQEBAgESEQQNRQULAgEIDgoCAhIBEwICAi8VEAIEAQ0FCBqFICMDA?=
 =?us-ascii?q?aMnAYFAAoooen8zgQGCGAXeAIEaLgGIMAGBWYhjJxuCDYEUAUKCMAcxPoRFF?=
 =?us-ascii?q?TECgxE6gi8EjhMsaYoiDoVyAXGFMiYLQ1uKQwlLfRwDWSECEQFVExcLPgkWA?=
 =?us-ascii?q?hYDGxQEMA8JCyYqBjkCEgwGBgZZNAkEIwMIBANCAyBxEQMEGgQLB3eBcYE0B?=
 =?us-ascii?q?BNGAQ2BKolvDIMvKYFJJ4ELgw5LbIQEgWsMYYhugRCBPoFmAYNUTIM1HUADC?=
 =?us-ascii?q?209NRQbBQQ6ewWsEg0yQwcUS4EtDTkkkw+DK0mPQ5x6gkEKhBOaDodZF4QFj?=
 =?us-ascii?q?QCZNJhlIKJsQ4URAgQCBAUCDwEBBoFlPIFZcBWDIlIZD44tFoEMAQLKCXg7A?=
 =?us-ascii?q?gcLAQEDCYhwgXgBAQ?=
IronPort-PHdr: A9a23:km0AshZ/BDpF1IfB1NwFuVH/LTDlhN3EVzX9orIuj7ZIN6O78IunY
 ArU5O5mixnCWoCIo/5Hiu+Dq6n7QiRA+peOtnkebYZBHwEIk8QYngEsQYaFBET3IeSsbnkSF
 8VZX1gj9Ha+YgBOAMirX1TJuTWp6CIKXBD2NA57POPwT43bldi20+mx05bSeA5PwjG6ZOA6I
 BC/tw6ErsANmsMiMvMrxxnEqWcAd+VNkGVvI1/S1xqp7car95kl+CNV088=
IronPort-Data: A9a23:OyEjvaixwuPrJfDkyC8jquJKX161DBEKZh0ujC45NGQN5FlHY01je
 htvUGvTM/mOMGXxc9EnaNjk8BkDvsWDmNVlHgtvqH8wRHxjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+1HwdOGn9SQhvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZWPULOZ82QsaD5MtfvZ8EgHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUYw+JmWVNo9
 8c+BwogaBy9g8ut0reSH7wEasQLdKEHPasWvnVmiDreF/tjGMiFSKTR7tge1zA17ixMNa+BP
 IxCN3w2N1KZOEcn1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3Fa4KNIYLTGpsO9qqej
 lrP9HjCHAgFDueeyRSn+HKHo+iRhwquDer+E5X9rJaGmma7wm0VFQ1TVlahp/S9olCxVsgZK
 EEO/Ccq668o+ySDStj7Qg39u3WfvzYCVNdKVe438geAzuzT+QnxO4QfZjdFbNpjv8gsSHlzj
 hmCnsjiAnpkt7j9pW+hy4p4ZAiaYEA9BWQDfiQDCwAC5rHeTEsb13ojkv4L/HaJs+DI
IronPort-HdrOrdr: A9a23:AhcXc6FJF2s+E8fkpLqFp5LXdLJyesId70hD6qkvc203TiXIra
 CTdaogtCMc0AxhJk3I+ertBEGBKUmsk6KdkrNhTItKOzOW91dATbsSobcKrAeQYREWmtQtsZ
 uINpIOd+EYbmIKw/oSgjPIburIqePvmMvH9IWuqkuFDzsaF52IhD0JczpzZ3cGPzWucqBJbK
 Z0iPA3wAaISDA8VOj+LH8DWOTIut3Mk7zbQTNuPXQawTjLpwmFrJrhHTal/jp2aV5yKLEZnl
 Ttokjc3OGOovu7whjT2yv49JJNgubszdNFGYilltUVAi+EsHfpWK1RH5m5+BwlquCm71gn1P
 PWpQ07Ash143TNOkmovBrW3RX62jpG0Q6g9bbYuwqgnSXKfkN/NyNzv/MfTvIf0TtngDhI6t
 MP44tejesPMfqPplWk2zGCbWAbqqP9mwtQrQdUtQ0fbWPbA4Uh97D2OyhuYcw9NTO/54Y9HO
 Z0CsbAoP5QbFOBdnjc+nJi2dq2Qx0Ib1y7q2U5y4WoOgJt7ThE5lpdwNZakmYL9Zo7RZUB7+
 PYMr5wnLULSsMNd6pyCOoIXMPyUwX2MF/xGXPXJU6iGLAMOnrLpZKy6LIp5PuycJhNyJcpgp
 zOXF5RqGZ3cUPzDs+F2oFN73n2MS+AdCWoztsb64lyu7X6SrauOSqfSEo2m8/luPkbCt2zYY
 fEBHuXOY6VEYLDI/c84+SlYeghFZA3arxhhuoG
X-Talos-CUID: =?us-ascii?q?9a23=3AqJPcOGs9CQeqU0gW9gKCkPBQ6IslS3nMlEX2IXS?=
 =?us-ascii?q?eJlxETrGrTXaL6qZNxp8=3D?=
X-Talos-MUID: 9a23:EBBqrAUSd7jjmXLq/Afljy1ZKt532Z+vCG4vm5Utns7aLwUlbg==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by alln-iport-3.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 22:48:57 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 45CMmvTe003253
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 22:48:57 GMT
X-CSE-ConnectionGUID: wVcmfueFQpyeNNKm0GZKeA==
X-CSE-MsgGUID: nTkcVGyNQH6tjtVH+hY0tA==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=reject dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.08,234,1712620800"; 
   d="scan'208";a="31364066"
Received: from mail-bn7nam10lp2048.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.48])
  by alln-opgw-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 22:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0MYCt1ogU6keF7b0nxTQLnDdVyCedj4PD3yrFGH2J1d9Hfdtzk8IYtt81pGWW/PsTK5UHFqtou/PlFb7w7bUeB/goyuXdf1A7uebLGW/ZUWgaYrmK65zFh1ok8kYcE5ood8cZbOTpNqTL3RemOeotb6Me7mx+0SX3RYIJNwQm2bv3Trx+gJgIJEa6XsUFi5BeVe3Aiyhwo/hOx9opLp2tq7jwQSUz1NAw8ngenQz/fMKg8sKig9ZoTgX36qCkVHzIIDnQ0GJHApuXDr/T6iejxvfBvQKtsfVt7jj2F2CCf//X9US9F5VRxU+jZqsUyRpxK5cHqTEd5gp5gy9mAucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFH79KVtKqvZvX/oNTESTKnk/9jTxpNNCEBnyHk9pFM=;
 b=n5TnknQS2Pi4wTVHFpwNNlkpfbmprgxBWPPQb2iPUxvaBdImgTcHQO64N7zunORBL30yjN1v+jA2NBaIWPsadhMyHEIc3ATJLxEywEnr4mnDFZQsheYGkRXAV/KVtnfPf6mbRXxhHClaSJiXHWlKQa1Tf0MuldISLUbdzoVqsLHTnvQqdOAc3QV/f0nEtl0ERh/Y1drzdCM4neqhaUlYhZ1DEzMlzOz+qDYnBpwNkQaRWHvgOoCg+Ow7Y4ta8NBuIXHyEP7rYgcuCh/RZkgniC40yh1fHRoHh3/qAabX0q5vNMvR0D63yS/Ozdjb1yJ63sn/mvTiGzDeoVJn5WsQaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ2PR11MB8538.namprd11.prod.outlook.com (2603:10b6:a03:578::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 22:48:54 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%7]) with mapi id 15.20.7633.036; Wed, 12 Jun 2024
 22:48:54 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@suse.de>,
        "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>,
        "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>,
        "Masa Kai (mkai2)" <mkai2@cisco.com>,
        "Satish Kharat
 (satishkh)" <satishkh@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 02/14] scsi: fnic: Add headers and definitions for FDLS
Thread-Topic: [PATCH 02/14] scsi: fnic: Add headers and definitions for FDLS
Thread-Index: AQHau4B16fJJFXhxfkKzeOo07vOFyLHCIT4AgAKWzCA=
Date: Wed, 12 Jun 2024 22:48:54 +0000
Message-ID:
 <SJ0PR11MB5896CB425BF89696F52DF8E7C3C02@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-3-kartilak@cisco.com>
 <fd07ed26-11f7-42d9-be43-0d0f5ff96982@suse.de>
In-Reply-To: <fd07ed26-11f7-42d9-be43-0d0f5ff96982@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ2PR11MB8538:EE_
x-ms-office365-filtering-correlation-id: 6f9af692-c95c-40c8-d4d0-08dc8b31d666
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230034|376008|1800799018|366010|38070700012;
x-microsoft-antispam-message-info:
 =?utf-8?B?ekhQVnE0N1JlNFpFeGdIbzRZZUJtZWJoQkVjZDlUSzRhN2QrWXBiT2NMR3Zx?=
 =?utf-8?B?eFkxRmVTRTdSZVJIQWZ3NUFHcXFCWVJyTEZTUkN1VW9qWVkwRk5zbnZyUDRC?=
 =?utf-8?B?M1NuSzV1SnQ4VnhBQWRibWZMb0ZVbjNBUW1uQ1VOSUxTRDNIejdZVFhDTXZv?=
 =?utf-8?B?TnYyaEQzMmp4NGFiWlBmeDZNZnJzM0dQMUE5VmFoNjlnMGorNU9ydXJ0K1lI?=
 =?utf-8?B?OHhTK0cxcEVENnJEZGkyODdKOVY3SllESjFabFpMTkI1UW1wcEIyRTAyQTNN?=
 =?utf-8?B?QmlSY2JWZ2w1ekx6N1ErZk9xNjI3Z0tOdU0wekExeU5tYTZ2c2RZUDZMd2ha?=
 =?utf-8?B?c1R2Y0d1a0kyNXd5emZubGRNL25lZEgzL04xcDA4dU42NEJoQjBWQkt3MExI?=
 =?utf-8?B?Mmd0ZzFOQ21Da3dSQ2x2S2JOUXE5UWh6bml0a0hvSXd3alpjbzdVZ3lWL05j?=
 =?utf-8?B?SDQ2dmo1b29SeEEwNUlVcmZEdVhSR3JVaHFQZnRncjQwdmdkSHVTN2ZINWJS?=
 =?utf-8?B?SmQycTlzV3h1QUZ5ZmRUYVFLZGdqSGZwYUxxTUk4ei90K2wvUDcyOStINkZ5?=
 =?utf-8?B?WDVSU2RHa0hWUW11Ri8xQ3M3KzhtYzZTK1psODlqSDBWenN3bXhzK0V2SXNP?=
 =?utf-8?B?c2N3aSt2aVlmNGZZVjdHUmhjMGY0VVJraTd6WitaMm95bXJnNW1qTGYyNitw?=
 =?utf-8?B?WFNqcVpMR3o3bGhkelZUYlI2S0Z0Z1NyQTJpaWk1czUwSEgrZFB2NkJJOWY0?=
 =?utf-8?B?KzJ0aXJnMEkzaEUycHNuUWJuaVlGaElhUTk1Q0ZOTi9jakdYVzVIQjNiMDhI?=
 =?utf-8?B?YmVJa3JwVlFGS01xUVZaUWRFTFZ1eFhwaStPYmtxVEZNVTN4bGg3VU55Z0Fz?=
 =?utf-8?B?TUVkSzBYYktnSWcvWTZsOFVJT05WaGRJTnFMNmxDaTBkMDRrLzdPNnRnb0U2?=
 =?utf-8?B?OGFqWlVXOWFPMlBOd1pDb2dMbWVNVDlKRkMrUzFQOVlrcGpvamdvd2pHOXFP?=
 =?utf-8?B?YXVhVnRaeklwWENzSC90Y1NRYkYzL3VDK1N5NGQ0RTNwNHRGZ2JKazI3Z1JP?=
 =?utf-8?B?ckNuNUhKNVgvckVURzZ4N3J1S01ZUm05akc5blZNbU11dVV6bC8vN21XK1M5?=
 =?utf-8?B?K3NSbzNkM3pRaE8wYm81L2hjc3dSZmFRbFNocVRBZ0ZBSFRRNTVkeWpxS2hM?=
 =?utf-8?B?U1VLdit1bzV4d0M2K3JLUUdZZFlpdTdrM3RvaGk1NDZyOGtzY3pzbEJjZjZy?=
 =?utf-8?B?WnBnSTVNck1CbDdwdnJFTUJ1azFrQVEyMVRrMUJJUDZFRGpKV0crR1BRWWJW?=
 =?utf-8?B?aHp6b215UC84dHFxMVdBUmp5OGNLdFRKNjBwbDZOQVE0ckZQNGMrL1dYTkFL?=
 =?utf-8?B?YkRqSXViaSsza2ZBQnpOT0s4S1ZSYmUzS3JvdUY2VTRUaU1abFFlTTZLTWQr?=
 =?utf-8?B?R3hTRmJxcHBLa0NlZk9rUEkxOEduY0ZPeG9GYjdNMWs2Z1Z4UlBPNE5yamJO?=
 =?utf-8?B?c01XeDNvYzRSUTFwaWI2R0J2K3VCMllQaUNNd3FiVVVEeFZxQk9mcy8vRW1p?=
 =?utf-8?B?WXliWkN5bmNSR1N2NEQ5eVd1dnVZUFhoK1dkZk5LU1JtNDVvb0Z1alBVZDA1?=
 =?utf-8?B?RzJJa2tPUC85Rjg3cG0wYkVOZ3VBK2IrcjMzVzZ5NnphQXEzTkE1RFdsMFpn?=
 =?utf-8?B?c0x4YkFkVS9LWUhHYUplV0F0QkNRQzVOMkRkVkxKQVZKcU5SUmd2amF2T20y?=
 =?utf-8?B?eFpJZUlnS05sUHhKelFpaTBjQzZaeFdQNnVCQ1I1c1cvMnpDbXQ0dTdsL1Jp?=
 =?utf-8?Q?Y9MFI+VKyt9p5DReSKaPLX03GNXFPYmZJlXBU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230034)(376008)(1800799018)(366010)(38070700012);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z0xNT0pCVGxpeHNmNXc4MjNJSmhFd2x0SDIvUUFiUGJVVXozY1lubVh6Umhk?=
 =?utf-8?B?WWhFeWM5M21aVFlJZHpvdXZONkxCOFJuQXVXbzBsYnN5WmpJczd5VHQwRENL?=
 =?utf-8?B?a3J1ZG1STXBHVytFZXdqQ080NEZ4NXl2ejE4Wk10Vm8zbGRYRGxSeCtmR3FZ?=
 =?utf-8?B?UlFrUStSaWg0NlZQNnR6MnE3M2IxVVh0Z0xvcFBicUNSV0Y2Q2RtbGxpVFlH?=
 =?utf-8?B?V3pYaE1DbVEzQkpaSTcrZzhkcEc3Y0ZpRWNONzVxQWNOZFVRVnRqU2dCdjk2?=
 =?utf-8?B?Tk9vbXZDK2hKZHdXQk10TWlLSFBkUVlSV3RVNG1rUmQ5ZUZndkZ4OGEwR0l3?=
 =?utf-8?B?WU53RFp5U3hMOVVEWW10b05waW15cnBZbklsb3JZUCtxSXdCWExrVncrY3ds?=
 =?utf-8?B?aVo1eEtpNjZad3lCNm1SM0prRHJuNnpmQms3enVWYlVKN3NZVlMrYzhXRjVw?=
 =?utf-8?B?ZlB5bEE1bDVTNmlTYmttQ09JZVpzWDFVd3k2M1pISTdhK3dRTW93cmFoSWFp?=
 =?utf-8?B?aHZoQXZXTGJEbHZHY042ZnBmS3NnNWpPUWpxcjRaZlVKMm5kYlI1b3c4c05D?=
 =?utf-8?B?Z3NrOEN3MVNCMW5QWWUxV2prZ3hkb1FLOXFJSHVDdHpiUzV1czJkV29jOXRp?=
 =?utf-8?B?cEFMMFFXMHdmVVhvRytiNElWVXYyQTJmUUJVLzh5cUdvRlYrZTY4SU9TZEdW?=
 =?utf-8?B?WVVtV000UUluUmpCbWpEVTRtcWNlRndwNjBZWVdDMVA5NDkyKytXdFRkZTNt?=
 =?utf-8?B?Wit4WTRBVkp1S1JoMG5HRmgzczRvMGtiMlZkSHlteXBlZFljUXR5T2V1WW5K?=
 =?utf-8?B?WVpYZ3ZrdU9jeDhyTXhGSXRMM1FnWnJyeFRLQ1UvK1FxRklNVUhIUnFSdG1C?=
 =?utf-8?B?OThnRFRyQUVkeVhqWWZGN1MyWmZYR1QvUHo5MXFETkZmUHhudVByZEtycVZC?=
 =?utf-8?B?MzZOK0hYL0k1K3E5dFdqdVFyejFJUW1MSEEzL3pXYUpsdTUxU2VZYXlNeWVB?=
 =?utf-8?B?N3VkL1R3dWZmVFk3eVZSUnpEUXpUWC8rY0VsMVVSUFo1ZW1GOURMVzEvTUpl?=
 =?utf-8?B?cS80aHdCTXphOVJWYW9reFRyRmNTSDBYMi9wZnlqVFN1WEtoQllIcVBMbHFX?=
 =?utf-8?B?Yk0vdml2ZEdQdWhGV0FxeldsOCs1RHBLcThUU3drd0lrVmU0WE9XelF4MUJ6?=
 =?utf-8?B?dC84ckZUbjZwMTNIK2o2Tno5bkx1U1ZHRTJCWmQvaFJmRjlxUEZXM2lQQjNO?=
 =?utf-8?B?bVlsc0Z4S2ZYZ0JTWGYzUEpuTWFUM0duekJQT1pQU1NuVEd5VDdYWjdkZTE3?=
 =?utf-8?B?QnJxVlpEVWxyTnRKZ2lndnVyVk1kR1pnZkVTZ2FseXZYUXBFTGp0NXhnRnAx?=
 =?utf-8?B?OEMxS3dVQ1VZQUxqWVl4b2pOWU5naXZMMVBnRWZ1Zlk2N2JoZElWc3dIMDEx?=
 =?utf-8?B?Uk1GM0hRcU04ZW4wZnVZc3VZWEw2TVhva1ZWVVZ6NVBaelBtZGpIZUg5RHV4?=
 =?utf-8?B?MGVid2tJNGwxYmJZOEZESTk0dVNURUxBd2cyaTVpcU9MMDQ2bnpaRWtwUHZT?=
 =?utf-8?B?aWp1cU45VEZmN0lRYXFhSDNHb3lzNkJ4QkNuWnlRR1F4b3N5Tkc2TTR3UFE0?=
 =?utf-8?B?blI5Snh0V21Xang0eGttNXZpbXRrRi9rTDM3UHVjWEhCVjFXREc2MExJOXJp?=
 =?utf-8?B?OFhJV0FncTJvZWFiWUZXelp0OFRxaWtmZW5rS0lEenlkeXpBRzF5N0FCRFZu?=
 =?utf-8?B?N09Uakg3YzdsQnZGbTNFaXA3SFJycmZ6NURSQ0w3bzgzMHY5YTlTWW9lM1Y1?=
 =?utf-8?B?bzhmRHJ0ZHNsTyt1YnAraEdQUjQxLytqWGlhb2R6ek15cllMUjBlb0oyQ1BZ?=
 =?utf-8?B?aG96dEdaK3FKR2toTjN1US9CZzY1cEd2MmxzblJzWEpCYk4zVWkzd2VWR0xS?=
 =?utf-8?B?cTZLRDV3cTJ5MUJPY1ArRXRVS0hEdU5ycXpkUUl1Zk9WNzl3WlluUDU5Nm1s?=
 =?utf-8?B?bmtqbFBwRWF5bnZlcXJncDhxWEhGZ2JZSEk0aVNQMmpIQ09tTHBXME1EYk90?=
 =?utf-8?B?eDlQY2pKeWthTWZzejBJZk9TSmxHdGxicFYyeDlzZTdXandSSWpJTEdZQVJM?=
 =?utf-8?Q?k9jNCb6yc82hDnw4W56S0ftWe?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9af692-c95c-40c8-d4d0-08dc8b31d666
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 22:48:54.6342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w25cPUi4fWX2faIwS71oIyLFvZL3/u7bsrk8mdSVXrEfEq+gyT6UMm1ZKQqs85cqu2QWQvZCoi6Eg5alPIDioA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8538
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: alln-core-10.cisco.com

T24gTW9uZGF5LCBKdW5lIDEwLCAyMDI0IDExOjU0IFBNLCBIYW5uZXMgUmVpbmVja2UgPGhhcmVA
c3VzZS5kZT4gd3JvdGU6DQo+DQo+IE9uIDYvMTAvMjQgMjM6NTAsIEthcmFuIFRpbGFrIEt1bWFy
IHdyb3RlOg0KPiA+IEZhYnJpYyBEaXNjb3ZlcnkgYW5kIExvZ2luIFNlcnZpY2VzIChGRExTKSBw
cm92aWRlIGZ1bmN0aW9uYWxpdHkgZm9yDQo+ID4gZm5pYyB0byBkaXNjb3ZlciB0aGUgZmFicmlj
IGFuZCB0YXJnZXQgcG9ydHMuIEl0IGxvZ3MgaW4gdG8gdGhlIHRhcmdldA0KPiA+IHBvcnRzIGZy
b20gdGhlIGluaXRpYXRvciBhbmQgY3JlYXRlcyB0YXJnZXQgcG9ydHMgKHRwb3J0cykuDQo+ID4g
VGhpcyBmdW5jdGlvbmFsaXR5IGlzIGVzc2VudGlhbCBmb3IgcG9ydCBjaGFubmVsIHJlZ2lzdGVy
IHN0YXRlIGNoYW5nZQ0KPiA+IG5vdGlmaWNhdGlvbiAoUEMtUlNDTikgaGFuZGxpbmcgYW5kIEZD
LU5WTUUgaW5pdGlhdG9yIHJvbGUuDQo+ID4NCj4gPiBUaGlzIGZ1bmN0aW9uYWxpdHkgaXMgZXNz
ZW50aWFsIGZvciBlQ1BVIGhhbmcgb3IgcGFuaWMgaGFuZGxpbmcuIEluDQo+ID4gY2FzZXMgd2hl
cmUgdGhlIGVDUFUgaW4gdGhlIFVDUyBWSUMgKFVuaWZpZWQgQ29tcHV0aW5nIFNlcnZpY2VzDQo+
ID4gVmlydHVhbCBJbnRlcmZhY2UgQ2FyZCkgaGFuZ3MsIGEgZmFicmljIGxvZyBvdXQgaXMgc2Vu
dCB0byB0aGUgZmFicmljLg0KPiA+IFVwb24gc3VjY2Vzc2Z1bCBsb2cgb3V0IGZyb20gdGhlIGZh
YnJpYywgdGhlIElPIHBhdGggaXMgZmFpbGVkIG92ZXIgdG8NCj4gPiBhIG5ldyBwYXRoLg0KPiA+
DQo+IERpZG4ndCB5b3UgaGF2ZSB0aGUgcGFyYWdyYXBoIGluIHRoZSBwYXRjaCBzZXJpZXMgZGVz
Y3JpcHRpb24/DQo+IFBsZWFzZSBkb24ndCBkdXBsaWNhdGUgaXQuDQoNClllcywgdGhhdCdzIGNv
cnJlY3QuIFN1cmUuIEknbGwgbW9kaWZ5IHRoZSBwYXRjaCBkZXNjcmlwdGlvbiBpbiB0aGUgDQpu
ZXh0IHZlcnNpb24uDQoNCj4gUGxlYXNlIHRlbGwgbWUgdGhhdCAnT1hJRCcgZG9lc24ndCBtZWFu
IHdoYXQgSSB0aGluayBpdCBkb2VzIC4uLg0KPiBIYXJkY29kZWQgT1hJRHMgZm9yIGluZGl2aWR1
YWwgY29tbWFuZCB0eXBlcz8gUmVhbGx5Pw0KDQpUaGUgdGhpbmtpbmcgZHVyaW5nIHRoZSBkZXNp
Z24gcHJvY2VzcyB3YXMgdGhhdCBlYWNoIGZhYnJpYyByZWxhdGVkIA0KY29tbWFuZCBuZWVkcyBv
bmx5IG9uZSBPWElEIGF0IGEgdGltZS4gU2luY2UgdGhlIGNhbGxzIHRvIHRoZSBmYWJyaWMNCmFy
ZSBzZXJpYWwgaW4gbmF0dXJlLCB0aGVyZSBtYXkgbm90IGJlIGEgbmVlZCBmb3IgYSBwb29sLiBJ
biBhZGRpdGlvbiwgDQpkZWJ1Z2dpbmcgd291bGQgYmUgYSBsaXR0bGUgYml0IGVhc2llciBzaW5j
ZSB3ZSBjb3VsZCBqdXN0IGxvb2sgYXQgdGhlIA0KT1hJRCBhbmQgaW1tZWRpYXRlbHkga25vdyB3
aGF0IHRoZSBjb21tYW5kIHdhcywgd2l0aG91dCB0aGUgDQpuZWVkIGZvciBhbiBGQyB0cmFjZSB0
byBkZWJ1ZyB0aGUgaXNzdWUuDQoNCkhvd2V2ZXIsIGJhc2VkIG9uIHlvdXIgcmV2aWV3IGZlZWRi
YWNrLCB3ZSBhcmUgZXZhbHVhdGluZyBhIA0KZGVzaWduIGZvciBhIHBvb2wtYmFzZWQgYXBwcm9h
Y2guDQoNCj4gPiArI2RlZmluZSBGQ19DVF9SRkZfQ01EICAgICAgICAgICgweDFGMDIpDQo+ID4g
Kw0KPiA+ICsjZW5kaWYNCj4NCj4gRHVwbGljYXRlIG1hY3JvcyBmb3IgZW5kaWFuIGRpZmZlcmVu
Y2VzIGlzIHF1aXRlIGVycm9yLXByb25lLCBhcyB5b3UgaGF2ZSB0byByZW1lbWJlciB0byBhbHdh
eXMgY2hhbmdlIGJvdGggc2lkZXMuDQo+IEkgd291bGQgcHJlZmVyIHRvIGhhdmUganVzdCBvbmUg
Y29weSBhbmQgdXNlIG1hY3JvcyB0byBhY2Nlc3MgdGhlIHZhbHVlcyAoZWcgYWx3YXlzIHVzZSBn
ZXRfdW5hbGlnbmVkX2xlMTYpLg0KDQpTdXJlLiBJJ2xsIGZpeCB0aGlzIGluIHRoZSBuZXh0IHZl
cnNpb24gb2YgY2hhbmdlcy4NCg0KPiA+ICsjZGVmaW5lIEZDX0FCVFNfUkNUTCAgICAgICAgICAg
IDB4ODENCj4gPiArI2RlZmluZSBGTklDX0VMU19BRElTQ19SRVEgICAgICAweDUyDQo+ID4gKyNk
ZWZpbmUgRkNfRUxTX1JKVF9MT0dJQ0FMX0JVU1kgMHgwNQ0KPiA+ICsjZGVmaW5lIEZDX0VMU19S
SlRfQlVTWSAgICAgICAgIDB4MDkNCj4gPiArI2RlZmluZSBGQ19FTFNfUlRWX1JFUSAgICAgICAg
ICAweDBFDQo+ID4gKw0KPg0KPiBUaGVyZSBpcyBhbHJlYWR5IGEgY29weSBvZiBGQy1MUyBkZWZp
bml0aW9ucyBpbiBpbmNsdWRlL3VhcGkvc2NzaS9mYy9mY19lbHMuaC4NCj4NCj4gUGxlYXNlIGVu
c3VyZSB0aGF0IHlvdSBkb24ndCBpbnRyb2R1Y2UgZHVwbGljYXRlcy4NCg0KU3VyZSwgbWFrZXMg
c2Vuc2UuIFRoYW5rcyBmb3IgcG9pbnRpbmcgaXQgb3V0LiBJJ2xsIGZpeCB0aGlzIGluIHRoZSBu
ZXh0IHZlcnNpb24gb2YgY2hhbmdlcy4NCg0KPiBodG9ubGwoKSBtYWNyb3MgYXJlIHR5cGljYWxs
eSB1c2VkIGluIHRoZSBuZXR3b3JrIHN0YWNrOyBwbGVhc2UgdXNlIGdldF91bmFsaWduZWRfYmU2
NCgpLg0KDQpTdXJlLiBJJ2xsIGZpeCB0aGlzIGluIHRoZSBuZXh0IHZlcnNpb24gb2YgY2hhbmdl
cy4NCg0KPiA+ICsjZGVmaW5lIEZOSUNfRkNfRlJBTUVfVU5TT0xJQ0lURUQoX2ZjaGRyKSAgKF9m
Y2hkci0+cl9jdGwgPT0gMHgyMikNCj4gPiArI2RlZmluZSBGTklDX0ZDX0ZSQU1FX1NPTElDSVRF
RF9EQVRBKF9mY2hkcikgICAgKF9mY2hkci0+cl9jdGwgPT0gMHgyMSkNCj4gPiArI2RlZmluZSBG
TklDX0ZDX0ZSQU1FX1NPTElDSVRFRF9DVFJMX1JFUExZKF9mY2hkcikgICAgKF9mY2hkci0+cl9j
dGwgPT0gMHgyMykNCj4gPiArI2RlZmluZSBGTklDX0ZDX0ZSQU1FX0ZDVExfTEFTVF9FTkRfU0VR
KF9mY2hkcikgICAgKF9mY2hkci0+Zl9jdGwgPT0gMHg5OCkNCj4gPiArI2RlZmluZSBGTklDX0ZD
X0ZSQU1FX0ZDVExfTEFTVF9FTkRfU0VRX0lOVChfZmNoZHIpICAgIChfZmNoZHItPmZfY3RsID09
IDB4OTkpDQo+ID4gKyNkZWZpbmUgRk5JQ19GQ19GUkFNRV9GQ1RMX0ZJUlNUX0xBU1RfU0VRSU5J
VChfZmNoZHIpICAoX2ZjaGRyLT5mX2N0bCA9PSAweDI5KQ0KPiA+ICsjZGVmaW5lIEZOSUNfRkNf
RlJBTUVfRkM0X1NDVEwoX2ZjaGRyKSAgICAoX2ZjaGRyLT5yX2N0bCA9PSAweDAzKQ0KPiA+ICsj
ZGVmaW5lIEZOSUNfRkNfRlJBTUVfVFlQRV9CTFMoX2ZjaGRyKSAoX2ZjaGRyLT50eXBlID09IDB4
MDApICNkZWZpbmUNCj4gPiArRk5JQ19GQ19GUkFNRV9UWVBFX0VMUyhfZmNoZHIpIChfZmNoZHIt
PnR5cGUgPT0gMHgwMSkgI2RlZmluZQ0KPiA+ICtGTklDX0ZDX0ZSQU1FX1RZUEVfRkNfR1MoX2Zj
aGRyKSAoX2ZjaGRyLT50eXBlID09IDB4MjApICNkZWZpbmUNCj4gPiArRk5JQ19GQ19GUkFNRV9D
U19DVEwoX2ZjaGRyKSAoX2ZjaGRyLT5jc19jdGwgPT0gMHgwMCkNCj4NCj4gUGxlYXNlIHVzZSBt
YWNybyBuYW1lcyBpbnN0ZWFkIG9mIHJhdyB2YWx1ZXMgaGVyZS4NCg0KU3VyZS4gSSdsbCBmaXgg
dGhpcyBpbiB0aGUgbmV4dCB2ZXJzaW9uIG9mIGNoYW5nZXMuDQoNCj4gVGhlc2Ugc2VlbSB0byBi
ZSBzdGFuZGFyZCBGQ29FIGZyYW1lIGRlZmluaXRpb25zLCBmb3Igd2hpY2ggd2UgYWxyZWFkeSBo
YXZlIGEgY29weSBpbiBpbmNsdWRlL3VhcGkvc2NzaS9mYy4NCj4gUGxlYXNlIHVzZSB0aGUgZGVm
aW5pdGlvbnMgZnJvbSB0aGVyZSBpbnN0ZWFkIG9mIGludHJvZHVjaW5nIHlvdXIgb3duLg0KDQpT
dXJlLiBJJ2xsIHVzZSB0aGUgc3RhbmRhcmQgZGVmaW5pdGlvbnMgZnJvbSB0aGUgaGVhZGVyIGZp
bGVzLg0KDQo+ID4gKyNkZWZpbmUgZm5pY19kZWxfZmFicmljX3RpbWVyX3N5bmMoKSB7ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAg
IGlwb3J0LT5mYWJyaWMuZGVsX3RpbWVyX2lucHJvZ3Jlc3MgPSAxOyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICBzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZmbmljLT5mbmljX2xvY2ssIGZuaWMtPmxvY2tfZmxhZ3MpOyAgICAgXA0KPiA+ICsgICBkZWxf
dGltZXJfc3luYygmaXBvcnQtPmZhYnJpYy5yZXRyeV90aW1lcik7ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgc3Bpbl9sb2NrX2lycXNhdmUoJmZuaWMtPmZu
aWNfbG9jaywgZm5pYy0+bG9ja19mbGFncyk7ICAgICAgICAgIFwNCj4gPiArICAgaXBvcnQtPmZh
YnJpYy5kZWxfdGltZXJfaW5wcm9ncmVzcyA9IDA7ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBcDQo+ID4gK30NCj4gPiArDQo+IFBsZWFzZSwgbWFrZSB0aGlzIGFuIGlu
bGluZSBmdW5jdGlvbi4NCj4gPiArI2RlZmluZSBmbmljX2RlbF90cG9ydF90aW1lcl9zeW5jKCkg
eyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwN
Cj4gPiArICAgdHBvcnQtPmRlbF90aW1lcl9pbnByb2dyZXNzID0gMTsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmZm5pYy0+Zm5pY19sb2NrLCBmbmljLT5sb2NrX2ZsYWdzKTsgICAg
IFwNCj4gPiArICAgZGVsX3RpbWVyX3N5bmMoJnRwb3J0LT5yZXRyeV90aW1lcik7ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgIHNwaW5fbG9ja19p
cnFzYXZlKCZmbmljLT5mbmljX2xvY2ssIGZuaWMtPmxvY2tfZmxhZ3MpOyAgICAgICAgICBcDQo+
ID4gKyAgIHRwb3J0LT5kZWxfdGltZXJfaW5wcm9ncmVzcyA9IDA7ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gK30NCj4gPiArDQo+
IFNhbWUgaGVyZS4NCg0KTWFrZXMgc2Vuc2UuIEknbGwgbWFrZSB0aGVzZSBpbmxpbmUgZnVuY3Rp
b25zLg0KDQpSZWdhcmRzLA0KS2FyYW4NCg==
