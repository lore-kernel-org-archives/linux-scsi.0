Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8A212C81F;
	Wed, 12 Jun 2024 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718231147; cv=fail; b=aBIGfvqErFB2ktA05cKJ1adyZqpXdY4Dp7ogqsmBvH6m55upZc5jZv30GjaXkXSZoSC4Up79VBkp4e1Cv1U6YfdatClMqnOxu6Q9LKLa7atYUOaAkCLpzSk2Ww5VOYJgBqqBzR3qQs9d5lMMde4V8WqGTT1p+0vBco7r5q1x2cU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718231147; c=relaxed/simple;
	bh=Q6SRhbTisosjPkLYQWNDvWcegejErohQ8VMRMFgsjoI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LhBlZjN3IHr42vcwxpnA5HtX+RSKCRxJQh+zToMaL1Cr+JZYK6rzcTwMYdzioonTFuN4iTjZInhRigpsLyN3uM+zX6M32UGSL6eIFdkDRFWT+g6/PN987joy87WZ6Bf0gIdivdtX/yqrzd/d2CUxS+hKOYwmNEob7TK2PbzR5wA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Md6z7vBl; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=jkQ9o4QP; arc=fail smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Md6z7vBl";
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="jkQ9o4QP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1322; q=dns/txt; s=iport;
  t=1718231146; x=1719440746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q6SRhbTisosjPkLYQWNDvWcegejErohQ8VMRMFgsjoI=;
  b=Md6z7vBlgNZf+JEaQi00DHoq6gxiUk4P6oNQQke3MKUsHVv1hsy7HErU
   LajTgq/an7yZCGYhaXRjSaAAg4caM22sLF2VfXS29BVfez4yV4aqi75wm
   fRLjgpfUzPU2wdOocBzGuIurnPrpztKPlmsILhPC2G2AWjPASUiCAgG2+
   A=;
X-CSE-ConnectionGUID: AIPU2tMySWOrWc75DsCLKg==
X-CSE-MsgGUID: 7NH0oI8aRkuKs/+S9flBPA==
X-IPAS-Result: =?us-ascii?q?A0BBAACIH2pmmI9dJa1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEZBAEBCwGBcVJ6gR5IhFWDTAOFLYZMgiWfMQNWDwEBAQ0BAUQEAQGCEoJ0A?=
 =?us-ascii?q?haIVwImNwYOAQICAgEBAQEDAgMBAQEBAQEBAQYBAQUBAQECAQcFFAEBAQEBA?=
 =?us-ascii?q?QEBHhkFEA4nhXQNhlkBAQEBAxIREQwBATcBDwIBCA4KAgImAgICLxUQAgQBD?=
 =?us-ascii?q?QUIEweCXoJlAwGjMgGBQAKKKHqBMoEBggwBAQYEBd13CYEaLgGIMAGBWYhjJ?=
 =?us-ascii?q?xuCDYEVQoJoPoJhAoFKGBWDRDqCL5lchDNXD4JlhBgmC0NrijIJS30cA1khA?=
 =?us-ascii?q?hEBVRMXCz4JFgIWAxsUBDAPCQsmKgY5AhIMBgYGWTQJBCMDCAQDQgMgcREDB?=
 =?us-ascii?q?BoECwd3gXGBNAQTRgENgSqJbwyDLymBSSeBC4MOS2yEBIFrDGGIboEQgT6BZ?=
 =?us-ascii?q?gGDVEyDNR1AAwttPTUUGwUEOnsFrx9ukx2DIUmufgqEE6FnF4QFjQCZNC6YN?=
 =?us-ascii?q?yCoQAIEAgQFAg8BAQaBeySBW3AVgyJSGQ+OIRmDYcc4eDsCBwEKAQEDCYhvg?=
 =?us-ascii?q?XkBAQ?=
IronPort-PHdr: A9a23:aovU3Rdclt0UtQtYW39dG5azlGM/eYqcDmcuAtIPgrZKdOGk55v9e
 RaZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NBsdA97wMmXbuWb69jsOAlP6PAtxKP7yH9vRht6r1uS7+LXYYh5Dg3y2ZrYhZ
 BmzpB/a49EfmpAqar5k0BbLr3BUM+hX3jZuIlSe3l7ws8yx55VktS9Xvpoc
IronPort-Data: A9a23:4yLhu61o7ezZuotnWPbD5fVxkn2cJEfYwER7XKvMYLTBsI5bp2EAn
 GUYDTvQbPeJYGDxLo0jO9/k9R8Dvp6Em9VjTVRs3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ1yFjmE4E71btANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXV6
 bsen+WFYAX5g2AtaDpPg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauG4ycbjG
 o4vZJnglo/o109F5uGNy94XQWVWKlLmBjViv1INM0SUbreukQRpukozHKJ0hU66EFxllfgpo
 DlGncTYpQvEosQglcxFOyS0HR2SMoVv2Yf6e2SaoPes6Ff5eCSx7+5FKGI5aNhwFuZfWQmi9
 NQCIzwLKxuEne/zn/SwS/JngYIoK8yD0IE34y47i2qGS6d9B8mfGM0m5vcAtNs0rsNHB+rfY
 8MaQTFudx/HJRZIPz/7Dbpkzbry1ymvLWUwRFS9+owXu2/ynAVL06XOK52WQY2EQe9ttxPNz
 o7B1z+kWk5BboP3JSC+2natgPLf2CD2QoQfEJWm+fNwxl6e3GoeDFsRT1TTif24jFOuHslUM
 E085CUjt+4x+VatQ927WAe3yENopTYGUNZWVuY98gzIlezf4h2SAS4PSTsphMEaWNEebB0S6
 wWVusLSOht1j7bKFF6G3ZO3ombnUcQKFlMqaSgBRAoDxtDspoAvkx7CJuqP9obr17UZ/hmum
 li3QDgCulkFsSIcO0yGEb3vmTmgoN3CSRQ4o1qRVWO+5QQ/b4mgD2BJ1bQ5xageRGp6ZgDd1
 JThpyR4xLtSZX1qvHfRKNjh5Jnzu5643MT02DaD5aUJ+TW34GKEdotN+jx4L0oBGp9bIG+zO
 RCL6V4Itc870J6WgUlfPtzZ5yMCkPeIKDgZfq68gidmO8EgKVffrEmCm2bJhzCz+KTTrU3PE
 czGKZn3Vyly5VVPxzutTOBVyq4w2i073ivSQ5u9pylLIpLADEN5vYwtaQPUBshgtfvsiFyMo
 753aZDQoz0BC7KWX8Ui2dNJRbz8BSJlVcmeRg0+XrPrHzeK70l6UaSPkOx/ItQNcmY8vr6gw
 0xRk3RwkTLXrXbGMg6NLHtkbdvSsVxX9BrX4QRE0Y6U5kUe
IronPort-HdrOrdr: A9a23:yIb6xa6okFCfx098RQPXwY2CI+orL9Y04lQ7vn2ZFiYlEfBwxv
 rPoB1E737JYW4qKQAdcLC7VJVpQRvnhOdICPoqTMeftW7dySWVxeBZnMTfKljbak/DH4FmpN
 pdmsRFebrN5B1B/LjHCWqDYpcdKbu8gdyVbI7lph8HI3AOGsVdBkVCe3mm+yZNNXF77O8CZe
 ChD7181kGdkBosH6KGL0hAddLu4/fMk5XrawMHARkI1Cmi5AnD1JfKVzKj8lM7ST1g/ZcOmF
 Kpr+X+3MqemsD+7iWZ+37Y7pxQltek4MBEHtawhs8cLSipohq0Zax6Mofy/wwdkaWK0hIHgd
 PMqxAvM4BY8HXKZFy4phPrxk3JzCsu0Xn/0lWV6EGT4/ARBQhKTvapt7gpNScx2HBQ+u2UF5
 g7hl5xgqAnSS8oWh6Nv+QgGSsazXZc6kBS4tL7x0YvI7f2LoUh7bD2OChuYco99OWQ0vF8LM
 B+SM7b//pYalWccjTQuXRu2sWlWjApEg6BWVVqgL3e79F6pgEw86Ij/r1Vol4QsJYmD5VU7e
 XNNapl0LlIU88NdKp4QOMMW9G+BGDBSQ/FdDv6GyWqKIgXf3bW75Ln6rQ84++nPJQO0ZspgZ
 zEFFdVr3Q7dU7iAdCHmJdL7hfOSmOgWimF8LAS27Fp/rnnALb7OyyKT14j18OmvvUEG8XeH+
 2+PZpHasWTZFcG2bw5qTEWd6MiXkX2Cvdlz+rTc2j+1v72Fg==
X-Talos-CUID: 9a23:DFXYR2FMlLf40T9lqmJO1XYpQNwAY0bi623vKBDlJX1CbJ6aHAo=
X-Talos-MUID: 9a23:eZ5stgiFx8Xv0s+W3+1ui8Mpa+FIu6OPWEk3kogloI7HDn1+Px2lpWHi
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by alln-iport-7.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 22:25:39 +0000
Received: from alln-opgw-2.cisco.com (alln-opgw-2.cisco.com [173.37.147.250])
	by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 45CMPdaK025705
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 22:25:39 GMT
X-CSE-ConnectionGUID: 18idyyddQimmpxlM73AMlg==
X-CSE-MsgGUID: 0Yg38bVjSEm99rSRVLqBmw==
Authentication-Results: alln-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=reject dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.08,234,1712620800"; 
   d="scan'208";a="8633962"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by alln-opgw-2.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 22:25:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxZDwsmCND2D2NmU1e3LPzyWYiotUW/uTEoY2/ltlnwvSJRATJFurTUAB6tfoXImBZbexMVrJGWmqVLoxsoBN2X4YEcDyhzPa45ZSY4IOhMeX6oLxZixNbxyZHiTRs9GtbL+ltiPUW2PFk6GHzwISwKr97FPBfNnf5ytidBeItzErBI5V5ZcFVxyyRYmH5LbGd3G5gpe5ALZIGIvjvKtOeVLGfrk+3PW5SFTTBHTDg3b2bqm5GPGZJ5S91Yaly3N0/4tMTpwCXIddTUU07CvlTH5ehfWiTTDLf8qiabSitIjzHb8EbOtqC9S4XB1BmLY4yAVIqL6pPcox0cZGgC31Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q6SRhbTisosjPkLYQWNDvWcegejErohQ8VMRMFgsjoI=;
 b=Qjv56UTO/+jcQe2eYtShY/9/zbb+Rm62ztuI2PWjVKNyiSiu1qxGSA8Z0aIEAXtb9RxUS2m32tAvDZaRAIdsRL96E2uhbFXMCqL6HdYu+Q45pHabHehYsPnVFtD5vVrhwq6PV15JxxBx09xuoxb1QhX3XlMy+ChD5d//2+1cIo+MPjqE5fPxYy4G0/tdAOMmYUhcZ0vwTeHHSJjYvQ+niDueBPVLKWL9/8WMaRGE/9hHsBxzCnkIz6IKCpKPYNhx1nSxL5UGy2Qj4Utzh7sLFDIUQT1WdVfoHCnkt1/Tb2bHvHbCfEZaTJjn0ShRfCblRpVcyhr7MUasYUcy4n6kZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6SRhbTisosjPkLYQWNDvWcegejErohQ8VMRMFgsjoI=;
 b=jkQ9o4QPW6fdrl2dnEtbK/PEnryR+3U7NBWZtyWVcgixIuu36o3eL9KgK9qaht04h2IxOxGb4Wqv2bhXv+OX52tyO+9qycBhcVSYdyrq8bAX2j5ank0YPiG/27ZoOyi3gffpGYGMx4EmWWpLQXxEhkuUIXqw+jnNfuKE8Ri5d6s=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by IA1PR11MB8198.namprd11.prod.outlook.com (2603:10b6:208:453::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 22:25:35 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%7]) with mapi id 15.20.7633.036; Wed, 12 Jun 2024
 22:25:35 +0000
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
Subject: RE: [PATCH 01/14] scsi: fnic: Replace shost_printk with
 pr_info/pr_err
Thread-Topic: [PATCH 01/14] scsi: fnic: Replace shost_printk with
 pr_info/pr_err
Thread-Index: AQHau4BlRssJkmM1aE6kuN7P+5uUuLHCGyaAgAKcYXA=
Date: Wed, 12 Jun 2024 22:25:35 +0000
Message-ID:
 <SJ0PR11MB5896A22BC30000E6A0E7CB3BC3C02@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-2-kartilak@cisco.com>
 <6b5e96e6-8c57-44ee-a763-3b91791813af@suse.de>
In-Reply-To: <6b5e96e6-8c57-44ee-a763-3b91791813af@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|IA1PR11MB8198:EE_
x-ms-office365-filtering-correlation-id: a6b290af-62e8-4dd3-6303-08dc8b2e9450
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230034|366010|376008|1800799018|38070700012;
x-microsoft-antispam-message-info:
 =?utf-8?B?SVk2a1A2ZktSSWVnQ0JGVGhSbkFZQ3RPQXF2dk82MzNiVnd6OC9pTWdvYzh2?=
 =?utf-8?B?Qm56SlJjUXhtVDBvOEJTYnhYNE0zRWRxOU1DalltMEJzTng1TitBVlErNFla?=
 =?utf-8?B?ZGlsY09ZUG9DaHJ5ZEYvb2E4dStvWVZiTldiVkd4N1hoVFM5N1Qra1FxZnFU?=
 =?utf-8?B?WjUrQWpLeDlDeEc3cHM4Z242aHVRSkNtZ1BNOTJ4RmZpWVdxNGNEaVhJQXB6?=
 =?utf-8?B?WTVzTkMydERVc2hRYWVldWQ1a0s1cy82cWlBNDJuRWtqQm9wMWJXdVNBZFV1?=
 =?utf-8?B?b1JwOFBjY1JYSGNqOFo5VXFwRzNBWUlQbE9HLzMyUG9TZHBjNGlvd3ZDZGlF?=
 =?utf-8?B?d2N4QXZ4cWpvMHpsdEVzeGNkTW9QUDVFT0hhdVlXZ1hhSEo3WlNjQ2VlOUI5?=
 =?utf-8?B?dUdtekY0cFhBVzgwSWVQM2k2UmRrbkNxYzVsK3JkaXZ0UjJDWUZnMHRnZ29m?=
 =?utf-8?B?L0tYSlM5ZmtVUUwwOHFTRk1KUUdFOHM2TG1QTWNZVy91Q1ZVSWU3dDlmSFVX?=
 =?utf-8?B?Q3JNYUNMaENYSHUxNHVrcGZUVDVCeWRmVldybWdPNjNVUkc4bHJEL1Z2U3pu?=
 =?utf-8?B?Y0FQOGtmUEFlMndpMUMyeG1NN1F4QWlCMW1NU05GcFRKTG0wcm05REVaVnhD?=
 =?utf-8?B?Vm93c056VDRYdEZGandUNUtEVk0wZm1rVTZyOU1qcWZhVDNTR0RaSTVzRzdn?=
 =?utf-8?B?QWZOZDY3S2xRdUpCd2FEUVR3R25MVk4vUm9QUnVubWtkOVRsSUJheFQvZE5v?=
 =?utf-8?B?eXdKL1VGRmljZ1pBOHU1S0owQTYwK3ovS2lQd1NJYkJsYlZ0ejJSc0lRb2pT?=
 =?utf-8?B?bDBCd3ZrUVJQa1NiYWgyZ2JYTktxVzFqclVyVm1lVzkxckdnQjB3TTJpU1Nj?=
 =?utf-8?B?akpta0R0YkJNeE55ZzJZVUh6bXBDOHgvbnFBbmtnNjMzalJyUTZVNWJMKzRS?=
 =?utf-8?B?RkphenkwMGl0UkV0OXdRWjRWZUFxNmplWW5QLzFXRkVrRXh2bThBeVl5czR0?=
 =?utf-8?B?Qk9nRm9pSC9CdGFYcGRpbXdkcDdYTjFpN0lYNURwMlM5S3lTcWhmcmxpVVhY?=
 =?utf-8?B?ak9PbXJUU0Z1YUhqSVN1M3JzOWxrMllDN2tCdk4wQ1VVeDBWRHpta0k3RllX?=
 =?utf-8?B?anFDbTJPekZZWGgzTDdjcGtyZ1BaanNCbDI0TlR6Rk9kNjlRREUvYTZ4SVZM?=
 =?utf-8?B?dWFoK1pvempHU0JxWjZsQmg0dUc1QjNWemswaFEwSnRraTl4Rnh6bHZpQ2lv?=
 =?utf-8?B?dVkxeVRmQjZPV0tZZVRJVExHTHlGd3AvNi9hTUpmQ0ZzVitRV3RNN01KRWxJ?=
 =?utf-8?B?ZkVwRXJDc0pEMVQ0RnVFd3lGTzFuRkRyMU10cW1nZHp5a29idkVKVHIwWURp?=
 =?utf-8?B?NWxEUW9KREFCRldZdlRoaUQ3SmVnRlBqS094dno1QmNXcDExVEJ6UE80ZUtC?=
 =?utf-8?B?Ym1vVFU3YzhPZ2dqK0hpekhFWlc3NS8vVDRXOVFTUENUblhpTjhYbVU2TVNm?=
 =?utf-8?B?RW5nK0QzNUtHUWFNNGJ5TmVEdlEwc2tEb3drRFNDUENUZ2psTTM4dE1zc0JK?=
 =?utf-8?B?bmhRSCt5TTZ3bzZwMXZER3FWcVE1MG9tSlJZbC9uVHJvcVkxQ3UvajBseWky?=
 =?utf-8?B?UGR1NGxwcWdYVUhoblFyL25tcGpaaEh2Y2tRZlF4Qzd4K1c0WEh2eFpVcmtF?=
 =?utf-8?B?eWQ3dlpoV0VoamFUbzFjMXJPankzMmhWNEhsMDFTakVhTDdWMkN1am1CWGFR?=
 =?utf-8?B?MVJDUDYxc2NqSTA4b0JFcE15RHA2SXp6ZFdMM2RWdWJndWJ3cVFFT050NlNY?=
 =?utf-8?Q?lgtHjqbGCs0/o1m/yH8TUAxC2FmztGVe506IM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230034)(366010)(376008)(1800799018)(38070700012);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzNpL01GaG9OOGVUQlI3TEl6V1Bzc0xndWJNTWVEaitITlRmTCtta0ZHS3d3?=
 =?utf-8?B?VCtiY3Zkc0tzeXd5eUlLbEd2WWs5VlVPWXI3a293SFpEOHh4UXdXR1N1UzIx?=
 =?utf-8?B?N0taVmZqTk1LZ3NuWGdmUjhCQ202MW5wemNQQm1JVDdqOVpXREVWVSt4c2RL?=
 =?utf-8?B?ODU3NzRkdC9vK0ZaSjJxV2tjNCt5UzRKd2toVVpSS3RXTXMwRVg4bkRrVXBZ?=
 =?utf-8?B?NXVBYkVHdWUwRnczR241NFY1d1ZOc2NtWTNLVWs1bzRsYUsraENHem5TNFBu?=
 =?utf-8?B?empQc3hmYjE4UTJqUXBJKzhPL1BucWo1UjlTWlhNdkw5ZExYbS8wZUZRK21W?=
 =?utf-8?B?Q2oyQ0VVS05TN3QySlhUUXREZkl4RWsxNHhYNzFXTU5RTWtMOXZWV3Nvc2Nj?=
 =?utf-8?B?bDhwU2tBRUNIVGJyMVRTVGxlOUtORjd1a205Z01NTjBKbGMzcGFqcXV6cVQ4?=
 =?utf-8?B?YW9wOTJ6aXlxeGdvbkFKZXlKanhsOXRQWW92ZHR1VU9rNnFURkpweU0vZEVv?=
 =?utf-8?B?QldsRmZnczBxcDhQLzVRR3R0TGdzSlNPNWpPOE9SZWlxcG1WV1V6NGIrVkYr?=
 =?utf-8?B?b0lRT1FDWkp3SmZ0V25NaWpBWDZ3aVJ2QjJVODBhT25SWmRDMEhKTFZMUENF?=
 =?utf-8?B?WCtNTTE2MGJmSDZuWU5Kam1WcU1oTUYxR292RDMrSmd5Qm9zd0k3c2FpMnk0?=
 =?utf-8?B?S2dqUlFIN2REQTJxZnpKWWRwZWNONlM0RHU2TTdtdFJ2RFc0dXcwWVZEU3ZX?=
 =?utf-8?B?SlZZYXIwSysxZVhKazBHMm5VYk55WmxHdlZtSG5aU3ZiTmk2bjFKRHAzN0VR?=
 =?utf-8?B?WW1DRVljZVI2UXhUYlAwdVZWTVhlRW1KOE1qclJVajMvbjlNRGFpZVFvMVdz?=
 =?utf-8?B?ZGlJR3FNa1VNU1NzMENyRVRwUHE4Rm4vTXNoMllpL2RxRWxITEIveEpHbWhj?=
 =?utf-8?B?Zm8wUmNQT09ua1ExbEhrNXVUTGExVy9EM2cyaHJJYkorcmZtaVlMZUZlRzNU?=
 =?utf-8?B?TnRQNXBSTXZFTDhYOFdXVkxoQTY3cHg0LzdaZTVtcTRDOGpUb0dVYjQvTCt2?=
 =?utf-8?B?ZE1heFZCd001R3VoNSt5U0tkSmdXRUtnaWNSK1JIOWk4UkxxZy9UaS9hS3JK?=
 =?utf-8?B?M2l1MlRNSXd6bWlaZzVwbjhSQmxFQmJBbE43VTVkcEhxMFc1UGg5YTdKSXVz?=
 =?utf-8?B?N2l3THl0VzNTbklzRFVxS1BWSm1Fb3ZsVHp0dEIrWkRqQzFuUnVvRFl0aVRl?=
 =?utf-8?B?RHZmRW9ybWlrZCsveW1EOTYwNnpmeU5pcktqeFJLQXdiendhV2tTNzExME1u?=
 =?utf-8?B?bCswVkRoSW9iVkt0Mk95NS83ZWhtdnREV1JIcTlTYlR3QllNeDlQTTk5bm16?=
 =?utf-8?B?MTBJQURBT2NjejFjaXhheFdMeEU2cjF0TGtaaXlZNDlaSnl2RlFQcjdwY083?=
 =?utf-8?B?dWZNOTdLTDREV1VOVDBCV2VtVGR6SDk0K1d1dkRHalF1QmwySE5YZUJjd2V1?=
 =?utf-8?B?TDBRWXlGd0xVcFpyc1o4dFNyVHBUVmZCWlBEV3l1bzZmM2RhdHZxQk0xb0l4?=
 =?utf-8?B?c1ZEc2F2dXB6T2NSNW1HNzRDdVVWTWFnVlV1SHcxdEtQODBUV3pZYkl3SXFw?=
 =?utf-8?B?bWtRK21aT3NicEsrTUoxN1U0WmVjMll2bENqOUQ3YXFEcDZiRlFWdVRhR2hy?=
 =?utf-8?B?TWtaNm1FYlEzM29hZWdkeDRPbllLd2dWQUJpbVg5VXQ3MzlZVWRRRWkwVnNt?=
 =?utf-8?B?dE50N3M5T3ZaSTV4cTRzaHVrRndsNW9OdEs4MllaRk4ybVdrR3FLTmJFSUJD?=
 =?utf-8?B?V1lTWmQ3T1FQSXg5c0tzU1NHM01rQzhvNit2ZytkRWh0dVh3ZjQ3enhlT2Qv?=
 =?utf-8?B?NDJtRXhTOVk5cGRyZ1F0VmtCc1FLemx1blpBSHpNYjlyYVJleW4rQnNIWGFh?=
 =?utf-8?B?ZVFodmJxYk9QLzlrK0JsQkRiN0hHd1pnYkZ1ZmoyM0tLTDNwTjg2ckRSODdM?=
 =?utf-8?B?dzkrdEFsK09WbEY1aUhGc29MdWNkVm1sb2hFaFhTb2xGbVBNT0E2RE5NUnNr?=
 =?utf-8?B?ZXpnakVMZGF2bnhZd3E0YnplbHRoN2MrVlJ4emRJMzlSaFlYaTR4VzV0S2lv?=
 =?utf-8?Q?gdzBgBvtnph/Rex4vbsksvUVg?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b290af-62e8-4dd3-6303-08dc8b2e9450
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 22:25:35.2462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/OBqEUhkqIDrHfv7F7Wv2yb42xK7Nb0BrTU3+biB7M58qKu/XlKZt0s5LZUc2ySjeCrOxtFu4E93Hltd+Bs9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8198
X-Outbound-SMTP-Client: 173.37.147.250, alln-opgw-2.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com

T24gTW9uZGF5LCBKdW5lIDEwLCAyMDI0IDExOjMyIFBNLCBIYW5uZXMgUmVpbmVja2UgPGhhcmVA
c3VzZS5kZT4gd3JvdGU6DQo+DQo+IE9uIDYvMTAvMjQgMjM6NTAsIEthcmFuIFRpbGFrIEt1bWFy
IHdyb3RlOg0KPiA+IFNlbmRpbmcgaG9zdCBpbmZvcm1hdGlvbiB0byBzaG9zdF9wcmludGsgcHJp
b3IgdG8gaG9zdCBpbml0aWFsaXphdGlvbg0KPiA+IGluIGZuaWMgaXMgdW5uZWNlc3NhcnkuDQo+
ID4gUmVwbGFjZSBzaG9zdF9wcmludGsgYW5kIGEgcHJpbnRrIHByaW9yIHRvIHRoaXMgaW5pdGlh
bGl6YXRpb24gd2l0aA0KPiA+IHByX2luZm8gYW5kIHByX2VyciBhY2NvcmRpbmdseS4NCj4gPg0K
PiBQbGVhc2UgdXNlICdkZXZfaW5mbycgYW5kICdkZXZfZXJyJyBpbnN0ZWFkLg0KPiBwcl9pbmZv
L3ByX2VyciBoYXZlIHRoZSBwcm9ibGVtIHRoYXQgdGhleSBkb24ndCByZWZlcmVuY2UgdGhlIGRl
dmljZSBnZW5lcmF0aW5nIHRoZSBtZXNzYWdlLCBtYWtpbmcgdHJhY2tpbmcgb2YgcmVsYXRlZCBt
ZXNzYWdlcyBpbiBhIGxhcmdlIG1lc3NhZ2UgbG9nIHByb2JsZW1hdGljLg0KPg0KPiBDaGVlcnMs
DQo+DQo+IEhhbm5lcw0KPiAtLQ0KPiBEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAg
ICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0DQo+IGhhcmVAc3VzZS5kZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgNCj4gU1VTRSBTb2Z0d2FyZSBTb2x1
dGlvbnMgR21iSCwgRnJhbmtlbnN0ci4gMTQ2LCA5MDQ2MSBOw7xybmJlcmcgSFJCIDM2ODA5IChB
RyBOw7xybmJlcmcpLCBHRjogSS4gVG90ZXYsIEEuIE1jRG9uYWxkLCBXLiBLbm9ibGljaA0KPg0K
Pg0KDQpUaGFua3MgZm9yIHBvaW50aW5nIHRoaXMgb3V0LiBJJ2xsIGluY29ycG9yYXRlIHRoaXMg
aW4gdGhlIG5leHQgdmVyc2lvbiBvZiBjaGFuZ2VzLg0KDQpSZWdhcmRzLA0KS2FyYW4NCg==
