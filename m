Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64AE1991A4;
	Mon, 17 Jun 2024 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718652325; cv=fail; b=GBgC8rB3Ha7AZ7DJSIJTW7XcmqbLr2KSVICP6ruyfKi+voNo46TNuqFOX/jZuzw3K2bUzmBN/uFydHKiEZBPLyOiOsi6x/bBc6Xa9MIbIEqeXTI20RdSgJs38JznbGOaj6F1fnoH2RuCs3Pbi6365rNLvaSR/HDAZGY6hj9IKcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718652325; c=relaxed/simple;
	bh=SGalDcKQF4aF/Y/VuPdTthy0unRdZ3Crl3b2me6pDtc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=clhCy9SsMRA/IPPhySJX3YNImpoaOJzJ2f4wHuI4MSZDUWuBxWlBtDzjRQPeCHmZfFgIbxMNSwar7SfqD5cUs++XvPzVk9RSvGNRdkIi7XcUgInUsgyqkGfeAmDSf++WyFss2fodp7v9FbdiGzr9ZQzw4BdJ1A/oki9uV5Qh49g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Lum2XwPS; arc=fail smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Lum2XwPS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3520; q=dns/txt; s=iport;
  t=1718652323; x=1719861923;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SGalDcKQF4aF/Y/VuPdTthy0unRdZ3Crl3b2me6pDtc=;
  b=Lum2XwPSHif/Nr3ntZchYvncWHBgxV3+H0hLCWfJuIsl352E4uxGtOl8
   MSn/a9gLzD8BrSPJ4V8R4h/9xrSCVTCUnkORFkkSYMaaeCrhyNWLCd5x+
   JUOpt0Xm15vD9avOSJ7ijA42ZgQ1CWsXtcN0GAbfUpStjqSqc4rwfoQyf
   w=;
X-CSE-ConnectionGUID: +vP1SvVyR5qAK9pU1iregg==
X-CSE-MsgGUID: ii2udEU9TvGK3IKeVvphNA==
X-IPAS-Result: =?us-ascii?q?A0AUAACajHBmmJJdJa1aHQEBAQEJARIBBQUBQCWBFggBC?=
 =?us-ascii?q?wGBcVJ6gR5IhFWDTAOETl+GTIIiA54MgSUDVg8BAQENAQFEBAEBhQYCFohfA?=
 =?us-ascii?q?iY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBBQEBBQEBAQIBBwUUAQEBAQEBAQEeG?=
 =?us-ascii?q?QUQDieGAYZZAQEBAQIBEhERRRACAQgOCgICJgICAi8VEAIEAQ0FCBqCXoJCI?=
 =?us-ascii?q?wMBohIBgUACiih6gTKBAYIYBd4AgRouAYgwAYFZiGMnG4INgRVCgjcxPoRFF?=
 =?us-ascii?q?YNEOoIvBIYFiAE4iAiDEoIaC4NMhiEmC0ErMItTCUt9HANZIQIRAVUTFws+C?=
 =?us-ascii?q?RYCFgMbFAQwDwkLJioGOQISDAYGBlk0CQQjAwgEA0IDIHERAwQaBAsHd4Fxg?=
 =?us-ascii?q?TQEE0YBDYEqiW8Mgy8pgUsngQyDDktshAOBawxhiGyBEIE+gWYBg1BNhDMdQ?=
 =?us-ascii?q?AMLbT01FBsFBDp7Ba0HAUBPGyY6gUMBIwaTEAoKLoJiSa1MgTMKhBOhZxeEB?=
 =?us-ascii?q?aBlhU+YZSCCNKYMAgQCBAUCDwEBBoFlOoFbcBWDIlIZD446yxp4OwIHCwEBA?=
 =?us-ascii?q?wmKaAEB?=
IronPort-PHdr: A9a23:rrwwqx+IgZnbm/9uWOnoyV9kXcBvk7zwOghQ7YIolPcXNK+i5J/le
 kfY4KYlgFzIWNDD4ulfw6rNsq/mUHAd+5vJrn0YcZJNWhNEwcUblgAtGoiEXGXwLeXhaGoxG
 8ERHER98SSDOFNOUN37e0WUp3Sz6TAIHRCqNgNvOuXxE436hMWs3Of08JrWME1EgTOnauZqJ
 Q6t5UXJ49Mbg4ZpNu49ywCcpHxOdqUeyTZjJEmYmFD34cLYwQ==
IronPort-Data: A9a23:qdOw5q1ZYGcc2GxBA/bD5e9xkn2cJEfYwER7XKvMYLTBsI5bp2BTz
 2dMCzyGP/yNNGr8LtgibYm0904HsZXRyIU1TVdk3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ1yEzmF4E/wb9ANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXV6
 bsen+WFYAX5g2AtbTpKg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGT18OZLYGxPdNXHhn1
 q0AFWkMdB2MiLfjqF67YrEEasULNsLnOsYUvWttiGiBS/0nWpvEBa7N4Le03h9p2ZsIRqmYN
 pFfMGYxBPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FYggOW0boeOJbRmQ+1UnxyFq
 k/7rljnLTJBFf+S9ySd8lSF07qncSTTA99KS+biqZaGmma7wm0VFQ1TVlahp/S9olCxVsgZK
 EEO/Ccq668o+ySDStj7Qg39u3WfvzYCVNdKVe438geAzuzT+QnxO4QfZiRKZNpjv8gsSHlzj
 hmCnsjiAnpkt7j9pW+hGqm87i2KYBMLE344ODYtblod3oDiuow8gUeaJjp8K5KdgtrwEDD25
 jmFqikimrke5fLnMY3mrTgrZBry//D0oh4J2+nBYo6yAupEiGONfYek7x3Q6uxNad/BCFKAp
 3MD3cOZ6Yji7K1hdgTTH43h/5nwu55p1QEwZ3Y1T/HNEBz2pxaekXh4um0WGauQGp9slcXVS
 EHSoxhNw5RYIWGna6R6C6roVJ16kPa6S4S/CKuNBjarXnSXXFLelM2JTRPPt10BbGBw+U3CE
 c7CIJv0VSZy5VpPnGvnLwvi7VPb7ntjnTyIH8+TI+WP2ruFb3ndUqYeLFaLdag46qjCyDg5A
 P4BX/ZmPy53CbWkCgGOqNZ7BQlTfRATW8usw+QJLbHrH+aTMDx7YxMn6el/K9UNcmU8vrqgw
 0xRrWcBkQWn1SKWcV/bAp2hAZu2NatCQbsAFXVEFX6j2mMoZsCk66J3Snf9VeNPGDBLpRKsc
 8Q4Rg==
IronPort-HdrOrdr: A9a23:GjK+76GwHNq0CfZ2pLqFp5LXdLJyesId70hD6qkvc203TiXIra
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
X-Talos-CUID: =?us-ascii?q?9a23=3ANquC0Wne9k8VPESufOIVH50kQCDXOT7D9C7rPXG?=
 =?us-ascii?q?pMztwYZ7EUWLJ+blpnMU7zg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3Aiiy02gyW+Zt+jhjnIy8s/4gsf5+aqKWvUl0BvKh?=
 =?us-ascii?q?Xh9erFndRGDqjkiy3ZKZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by alln-iport-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 19:25:16 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
	by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 45HJPGFv024350
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 19:25:16 GMT
X-CSE-ConnectionGUID: xnwluQniTFyzqGTZxisXkg==
X-CSE-MsgGUID: z+Pdsk6+SKmsmTKb1b5fbA==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=reject dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.08,245,1712620800"; 
   d="scan'208";a="31442217"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by alln-opgw-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 19:25:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANJ2heGcX3TVoBfJG8upAgdXCIyT6qgzIcy+0g4c32griYbmzqsO2W3tBa1oBA6+kbRpOywSVRRcH+T/f8cRKKrMOJ/GaqwBUvMynOsipgQZ/rPJEqyD9pzo80tiA5euHtdMcDdzi9a/3B1Mrt1da9CdpC2T7N1yk9IH6pnC2gfw8zYxUFjMrfPE4vQrTYafFrRc+qrmlkeMvRQLjsDXCksZpvNvT89xwLiPOsQihfOaUeBg6QTJagWjliXbztFUAjUWr8rie3Lpgu936BUc5/KFIenaTM/TlQa6EaLSUl7UdmSXmmstvncVQexcONvMh/sC06SoNG4/VjeEa4Thsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SGalDcKQF4aF/Y/VuPdTthy0unRdZ3Crl3b2me6pDtc=;
 b=Sv6iTPFGWvt9bnX6jH6wz03Cmqql5HmtlcpKd2hPeRb6+nEdNdNv85q2fl3F0iOdXaLli14gFZJSuHovGmRMmzDohY1EbvoFf3iOIbtil+c12cqmG6s3tfJZ1eFgmzyS6ZnLdYlapNhAzYKKK/5zbyiYPfxnauXMFU0DSLSl0uqvzw9/Lkbp63X+ndk1pZ7yxXSeBuVFF4PZgNQH6DW+8/HMkOkIP87b6BBDvBJoOIdyhmwTm2ht4OMEkvYxklRrjronufTVDBG+SU9lzLi6XE9rg8+Sqg/nfXEf8pCewsbhqVdD3sV8cmz2Y9xvH1+JdDxPF6ycLkliDNmGKs/APw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ0PR11MB4911.namprd11.prod.outlook.com (2603:10b6:a03:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.29; Mon, 17 Jun
 2024 19:25:14 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%7]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 19:25:14 +0000
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
Subject: RE: [PATCH 08/14] scsi: fnic: Add functionality in fnic to support
 FDLS
Thread-Topic: [PATCH 08/14] scsi: fnic: Add functionality in fnic to support
 FDLS
Thread-Index: AQHau4DvpVnghoIY5kqokjsHnUcQ/rHDtJEAgASBORCAAFoHAIADya7Q
Date: Mon, 17 Jun 2024 19:25:14 +0000
Message-ID:
 <SJ0PR11MB58964C9EE86FA71903143E8CC3CD2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-9-kartilak@cisco.com>
 <f992c0f2-8f70-4dc0-b679-e522e3fd6101@suse.de>
 <SJ0PR11MB58966D39EFAAD206CAE0A313C3C32@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <5d9c3107-5d07-4fe8-9782-cefb8d058ab5@suse.de>
In-Reply-To: <5d9c3107-5d07-4fe8-9782-cefb8d058ab5@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ0PR11MB4911:EE_
x-ms-office365-filtering-correlation-id: 5a696ac8-d7f6-4c26-0e66-08dc8f033678
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?WTFtME9vYmJublFsVmxzMU9jM3pId2JzTTN5L2M5RXc1SWNJT0hyL2pNdXAw?=
 =?utf-8?B?d0UxN1hxTTVqbUtKdWh5VTg3ODRKT2FmR2lzbTJNbisvNGZpcE5RazNLREJU?=
 =?utf-8?B?K1dQSjU1STNBbzFIQ1BsM2dzcjJWSHBzZFlFakFsUElhK2I4VDNWcjZoNkNn?=
 =?utf-8?B?ZDJEU3Qrb1drZERrejBpYWwxVEo2a0xRdHNoMjRoQXhWVUlralFmMGRlWVhh?=
 =?utf-8?B?SHMxYjN1QUw1WDBKZGcxK2taZFNmNnpCanptOTM3cDV4R2NFdkpJS0N3Y2k2?=
 =?utf-8?B?NWc0SmhqUS9HS2UwQmp3dHFwSmxWNld4M3RYcy8wbnJtRVMxU011dnhJRnJh?=
 =?utf-8?B?OFdjQ3VuMWNRTGVNMHRIWWliMDFBZ2owK3pXcXdCMHRiMi9iT3dRRzNCenFa?=
 =?utf-8?B?c2xuZXlVZitVc25OZ0RselJPMWp1dWxDMFlHM25MMVMxNkRPcEJCZzZPQnJp?=
 =?utf-8?B?bGlZUk9udk5MRHNBcm9jdDY4d0R2djliS2dkckgrRE5SY2F0VUprRXpVWmxz?=
 =?utf-8?B?dFEyUlFOMWY2NjFVQXdKSFl6SjRReUczWWxhMVhHRG8wRm5ldFc1SldxcCtr?=
 =?utf-8?B?cFRuTXpsQkxFc2ZwN21XRC9SMjZiVWFEUjJEUkZ6eS9INk1iL2hrQU5KMzYw?=
 =?utf-8?B?MjRZNjkxaVRxSi9QZTZ6T1FmcVNGVHBWcjJyRkppaWZUTEdZVXRoVGVsL0gw?=
 =?utf-8?B?Z3djMkRsbkQwTXRzeHQrY2dudzA2UDMzdjRuVzhRSEpwOHhsZkRBaGkwL09t?=
 =?utf-8?B?cVF4TG9OMTQ5bDBnbGtqYTBxVjJqanVpUFpwWnRPT0hZYlRTOFg5L1lDbTB5?=
 =?utf-8?B?WGtIeFYyOW9PMGxUaDZHS3RxLzlzeWM0QWZhNEl1K0dud0Z2ZzFiU0cxZ0M1?=
 =?utf-8?B?MWo1VHVtalllUVRuRVVaZlNGdDlLOFFSWjVOcjJHNlA0dTU3QllnNDkwM05l?=
 =?utf-8?B?d1kxTzFQTld5dHVnbFQ2STh1cldFMFNGZlRWbGJxRDlEbjFJMW9IbU1RbU1Q?=
 =?utf-8?B?MHlDbkYxSEtFQWhMbEkxSWJyWFRFWFBCWFl5a3ZGS0J2eSt4RFRJdlQxdERm?=
 =?utf-8?B?blhjLzgvWXJJSFVJQllIZ3JvemsrbzR6QXJ3ZUxuOFU3ZFU0MFRWR0tSeTdh?=
 =?utf-8?B?aDdOZHFpbDV0R0p1aVhoMlNvek1DemJHUWZSWE8vZmtLeHgzVmdMeHFEczZ4?=
 =?utf-8?B?VU9hMnRXeHdEcE1CZHpOUmRkYmNINDR1OW5GallLUXF3UEM0Ri9ZR2hPZjFU?=
 =?utf-8?B?ZmUzdVQ2MksrRnRIWkFQVnFQdGRqVHhXU2E3NC9UV01HbEx1cjdFNnRQUGk2?=
 =?utf-8?B?WDhuMGZqMHN0dW8xdWMrdjNXdUMzTHp5eStwYkszTkl1cWZweGRYMWw1bzdV?=
 =?utf-8?B?bmdLT0I1SUJXcHY4YlM3RWlpZ2Z5SmlCYXB6RzAyL3FUY3MwTjFnMnRMaDFw?=
 =?utf-8?B?R2puRjc2VGJycnNGaE9lUnQwT0laUDdObFZjVDNJNHQ5OUN6WVdNZzdGTmtz?=
 =?utf-8?B?WlRVRXAzeHhSdzhTeWVvRHR2RDF4c2dEUTE2WWltbEtCR0l2Nm9VbkExTGox?=
 =?utf-8?B?b0JLRTN0cG9mcEZ0ZGZtQ2I2K3FIN28zdml0UHk5TlM5ZDZYeWJhb2lxcWFw?=
 =?utf-8?B?YWRGN2w1dmY1dVo0NHNOUysxZ3h6ejlJUm5EeHExbUxKNXZIY0phdXZqZkxv?=
 =?utf-8?B?aUkyQWE5RHhQRGxVb05YVnpaVUprcXQ4VHNWR0lFWVRudXdKelVUdm5OSG5W?=
 =?utf-8?B?RFZZdW54NW5rTEVFSzNVcG5QZkVtVFBQYnp2YjBJUndCM0RaTG5VUlBVNVdB?=
 =?utf-8?Q?45d/Jy9nPgqeO3k2n4CJafyEtKNOwdH0RRFdc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eEY4bFBqaEdFNzRKci8wRUFWMjZQV0FhY3pYMVJ2RU91NE81M0hobi9OUzFh?=
 =?utf-8?B?UGF2NHlSOTU5SVZYbE9sSXJ4QXBwVXNmeUtsb3E3L2k1RmlLVDRlQWlJSkh1?=
 =?utf-8?B?WFJmdVowYSt1ZGlGczhLcmNTU0FQMDczSkFvRUUwblhiV2VFNEpDZVZsUFRu?=
 =?utf-8?B?T0RLbkc2NVVvM2YwWXFoUzBaNnJQMmNpR3c2enEzUm5ScE1CMjZ2SlBURHdK?=
 =?utf-8?B?bzlKUDVyeVNrN0JSVjNzQ01MUUM3K2o5ejB0VE1SclJ1NlloYVlLWHhwSnVT?=
 =?utf-8?B?TlNpLzVRbC9UUUVsVXVBdWtkMjJsMEhXb3dielh1dDhtYVVrZ0lTL05ZcFZS?=
 =?utf-8?B?UVhnbEYrZkZ3Y3M5S2kwb2tpdTlQRVZzSi9QOGpVZWZNYjlRY1Z6a1FLNEMr?=
 =?utf-8?B?dzd4dVhKT0RjZWJ3d0ZNNUdUSXExN1dpQTY0ck9MN1JtVUJhS2hFMWNSSmNT?=
 =?utf-8?B?VW5tYUFmbFpwa2ZycFZwZnZFdUdmQlpRMjlnNHA1b1VSVU42b0FFdEpRY1U2?=
 =?utf-8?B?bVY2cEFmN3V2U1hKVkhjdks4VFRHV2N6RHZGajladnBILy9KZEJmLzRLNnVG?=
 =?utf-8?B?S2ozZVhhUEI4YUVwSnpJdUZyM3U2bG9JcnR3NzZRaWtudE9RWVVUZWI4V00x?=
 =?utf-8?B?b1FoNVlPUG9jYnRYUG5zWnlOYVJWei91WEc0bHEwS0hIdlNFczAycUw0RFQ3?=
 =?utf-8?B?NnEyc1RsalhPZUJWYVNXOUNrVlRlRG5lczZQRjgzY2ZKUEZIS3IrenRINU42?=
 =?utf-8?B?MjlReUE0TUNMMGhDckY0STkzOXhaVjBOSGEyZHFaYmpJSm9nYU5NWVJCTkxv?=
 =?utf-8?B?WnpGVHJuVzlxZGVrcDN5SmFVSXdhWWhEMkoxQ0oyZGdFNVpVWmUzK21pNjVF?=
 =?utf-8?B?UDhnTSt4a01JL1NSaDc2T2QrVWJZc3grZW95L2tqSER2YUN4clJvWWtiMmxy?=
 =?utf-8?B?cGZiOENzdUYxVkNTbG5HbXA1UVYrUjg0UUZEREhZYTUrM0lHTXdhQ1gySmlD?=
 =?utf-8?B?ODRVbzVEVi8zSFlDeG5lK0R2bWJXanJOYW1xeFJXTHNRZFd6Ym5KUFd4Z2g2?=
 =?utf-8?B?TDU0RGxyUmY1TmJaOVl0dlhvK3lmdzF3cytRaDJlL2E2YVdrZlZxYVdFbkJj?=
 =?utf-8?B?SGZrUVl3cHQ5cTl4c0Myc3dJazlPalM5dVNEdkFUM3BqZWt6am5mMFVnU096?=
 =?utf-8?B?aWZnTjE3L0EwZU5wSytSZC9tOXhhMXVCRldqYVY4NGs1YW1BNE1BWkZxYWR6?=
 =?utf-8?B?aEo1dWM0d2FYVE9VZ3FyM2RRUjdlWnFrck1nK3VYL1N0Yk9KckdxbXQ0REhq?=
 =?utf-8?B?VkxVbXpaSlFzNUIrblIxMlBNRnFhZEtUaTFGbzVXeHk5VFF2QlczOW9idjA4?=
 =?utf-8?B?bmMwNWYydTZMYzBvQ1BuNHdKMHpLQWRNdTIzWXJiU1V5ZFU1TzBhS0hnODdV?=
 =?utf-8?B?c2UvbEdyeEZqNFFuTktUVjFIMjZQNk96UE5MYWJVbXRSMTBaQzlXTUUrSVo0?=
 =?utf-8?B?bVhQVnhJZjViRUd1Tmhqb3NFOTRBUU5HTmFEUGNuNXN1dkVwZzdkbE9hbm9Z?=
 =?utf-8?B?YjhqSmRKMm0xZmsyOXFxZmF6bG9aOGNqU1NwbGJ0dXVSaU00b2M2MW1jLzBQ?=
 =?utf-8?B?YWN4SkZkWjVJVWJkTEZZUytXVFRnSCswOVV6YnM1SldlSXJlQVFBNHJpcVRu?=
 =?utf-8?B?ZTBFcWs2NXE0Z203anFOSERwK2VZVUo3RkFFU2UvaDV0NVA3VHpBYklNejJJ?=
 =?utf-8?B?VWJKSER4VkNDYmZvcTNna29obEpzaTFUdzRqZUMzTUVremJ5R3V3OWUwODNE?=
 =?utf-8?B?RVFWSVB1VnV1Qnp2OE10MUYzQ1lLMVliUGsrRExPSGdLalN0RGE3V0phR2g1?=
 =?utf-8?B?SWZoTmhTN2FlRnhqbStqUTVLMjFHa3ptTXdmd1psQnZqWThmbHBudUJlKzJL?=
 =?utf-8?B?ZTlCbFFTTGhUTDd2dGRuanFVV3BjMlhpNjBtRjZRZlF2ZjcvOEY1VU1PRW5r?=
 =?utf-8?B?bWdxK0s5S0ZaQU1lQmt3NCt2RUM0NlFybURTZkNhakcxYWJZeG1nOHh5cHhR?=
 =?utf-8?B?ZGozcnpGTEg4MGlZaGFJUnlVenZQZ2dMVmsyTldFSzlUK3ZOVTM3dkZick1P?=
 =?utf-8?Q?ZePyhKwYt7wPUKplkzu3fQJWO?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a696ac8-d7f6-4c26-0e66-08dc8f033678
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 19:25:14.0890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xBcSI8oxCONLB+tH7gM/nN7NvR+m4L6zHQhdDAJAIop6XFLc82JXRjxaxs8eoBWT37qfVuYubG29ki8IgMBu5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com

T24gU2F0dXJkYXksIEp1bmUgMTUsIDIwMjQgMjowNyBBTSwgSGFubmVzIFJlaW5lY2tlIDxoYXJl
QHN1c2UuZGU+IHdyb3RlOg0KPg0KPiBPbiA2LzE1LzI0IDA1OjQ3LCBLYXJhbiBUaWxhayBLdW1h
ciAoa2FydGlsYWspIHdyb3RlOg0KPiA+IE9uIFR1ZXNkYXksIEp1bmUgMTEsIDIwMjQgMTE6NTcg
UE0sIEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPiB3cm90ZToNCj4gPj4NCj4gPj4gT24g
Ni8xMC8yNCAyMzo1MCwgS2FyYW4gVGlsYWsgS3VtYXIgd3JvdGU6DQo+ID4+PiBBZGQgaW50ZXJm
YWNlcyBpbiBmbmljIHRvIHVzZSBGRExTIHNlcnZpY2VzLg0KPiA+Pj4gTW9kaWZ5IGxpbmsgdXAg
YW5kIGxpbmsgZG93biBmdW5jdGlvbmFsaXR5IHRvIHVzZSBGRExTLg0KPiA+Pj4gUmVwbGFjZSBl
eGlzdGluZyBpbnRlcmZhY2VzIHRvIGhhbmRsZSBuZXcgZnVuY3Rpb25hbGl0eSBwcm92aWRlZCBi
eQ0KPiA+Pj4gRkRMUy4NCj4gPj4+IE1vZGlmeSBkYXRhIHR5cGVzIG9mIHNvbWUgZGF0YSBtZW1i
ZXJzIHRvIGhhbmRsZSBuZXcgZnVuY3Rpb25hbGl0eS4NCj4gPj4+IEFkZCBwcm9jZXNzaW5nIG9m
IHRwb3J0cyBhbmQgaGFuZGxpbmcgb2YgdHBvcnRzLg0KPiA+Pj4NCj4gPj4+IFJldmlld2VkLWJ5
OiBTZXNpZGhhciBCYWRkZWxhIDxzZWJhZGRlbEBjaXNjby5jb20+DQo+ID4+PiBSZXZpZXdlZC1i
eTogQXJ1bHByYWJodSBQb25udXNhbXkgPGFydWxwb25uQGNpc2NvLmNvbT4NCj4gPj4+IFJldmll
d2VkLWJ5OiBHaWFuIENhcmxvIEJvZmZhIDxnY2JvZmZhQGNpc2NvLmNvbT4NCj4gPj4+IFNpZ25l
ZC1vZmYtYnk6IEthcmFuIFRpbGFrIEt1bWFyIDxrYXJ0aWxha0BjaXNjby5jb20+DQo+ID4+PiAt
LS0NCj4gPj4+ICAgIGRyaXZlcnMvc2NzaS9mbmljL2ZkbHNfZGlzYy5jIHwgIDc0ICsrKysrDQo+
ID4+PiAgICBkcml2ZXJzL3Njc2kvZm5pYy9maXAuYyAgICAgICB8ICAyNyArLQ0KPiA+Pj4gICAg
ZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5oICAgICAgfCAgMjAgKy0NCj4gPj4+ICAgIGRyaXZlcnMv
c2NzaS9mbmljL2ZuaWNfZmNzLmMgIHwgNDk4ICsrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0NCj4gPj4+ICAgIGRyaXZlcnMvc2NzaS9mbmljL2ZuaWNfbWFpbi5jIHwgIDEwICstDQo+
ID4+PiAgICBkcml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYyB8IDEyNyArKysrKysrLS0NCj4g
Pj4+ICAgIDYgZmlsZXMgY2hhbmdlZCwgNTg3IGluc2VydGlvbnMoKyksIDE2OSBkZWxldGlvbnMo
LSkNCj4gPj4+DQo+ID4+IFRoaXMgc2VlbXMgdG8gbm90IGp1c3QgX2FkZF8gdGhlIGZ1bmN0aW9u
YWxpdHkgdG8gdXNlIEZETFMsIGJ1dA0KPiA+PiByYXRoZXIgX3JlcGxhY2VfIHRoZSBleGlzdGlu
ZyBmdW5jdGlvbmFsaXR5IHdpdGggRkRMUy4NCj4gPj4gSUUgaXQgc2VlbXMgdGhhdCBhZnRlciB0
aGlzIGNoYW5nZSB0aGUgZHJpdmVyIHdpbGwgYWx3YXlzIGRvIEZETFMsDQo+ID4+IGNhdXNpbmcg
YSBwb3NzaWJsZSBzZXJ2aWNlIGludGVycnVwdGlvbiB3aXRoIGV4aXN0aW5nIHNldHVwcy4NCj4g
Pj4gSG1tPw0KPiA+DQo+ID4gVGhhbmtzIGZvciB5b3VyIHJldmlldyBjb21tZW50cywgSGFubmVz
Lg0KPiA+IEFzIEkgbWVudGlvbmVkIGluIHRoZSBvdGhlciBwYXRjaCBjb21tZW50cywgQ2lzY28g
aGFzIGJlZW4gc2hpcHBpbmcgYW4NCj4gPiBhc3luYyBkcml2ZXIgYmFzZWQgb24gRkRMUyBmb3Ig
dGhlIHBhc3Qgc2l4IHllYXJzLg0KPiA+IFRoZSBhc3luYyBkcml2ZXIgaXMgYmFja3dhcmQgY29t
cGF0aWJsZSBhbmQgc3VwcG9ydHMgYWxsIHRoZSBhZGFwdGVycw0KPiA+IHRoYXQgYXJlIHN1cHBv
cnRlZCBieSB0aGUgZXhpc3RpbmcgdXBzdHJlYW0gZHJpdmVyLCBhbmQgbW9yZS4NCj4gPiBUaGUg
YXN5bmMgZHJpdmVyIGluIGZhY3Qgb3ZlcnJpZGVzIHRoZSB1cHN0cmVhbSBkcml2ZXIgb24gb3Vy
IGluc3RhbGxhdGlvbnMuDQo+ID4NCj4gQWguIEdvb2QgdG8ga25vdy4gRXZlciBtb3JlIGEgcmVh
c29uIHRvIGhhdmUgeW91ciBkcml2ZXIgdXBzdHJlYW1lZCwgdGhlbi4uLg0KDQpZZXMgSGFubmVz
LiBUaGF0J3MgY29ycmVjdC4gVGhlIENpc2NvIHRlYW0gZmVlbHMgdGhhdCB3YXkgdG9vLg0KDQo+
ID4gT24gQ2lzY28gaGFyZHdhcmUsIHRoZSBiZXN0IHByYWN0aWNlIG91dCBpbiB0aGUgZmllbGQs
IGlzIHRvIHVwZGF0ZQ0KPiA+IHRoZSBkcml2ZXIgdG8gdGhlIGFzeW5jIGRyaXZlciBkdXJpbmcg
T1MgaW5zdGFsbGF0aW9uIGl0c2VsZi4NCj4gPiBEdWUgdG8gdGhpcyBiZXN0IHByYWN0aWNlLCB3
ZSBoYXZlIF9ub3RfIHJlY2VpdmVkIGFueSBmZWVkYmFjayBmcm9tDQo+ID4gY3VzdG9tZXJzIGlu
ZGljYXRpbmcgYW4gYWJub3JtYWwgc2VydmljZSBpbnRlcnJ1cHRpb24gc3BlY2lmaWNhbGx5IGR1
ZSB0byB0aGUgZHJpdmVyIHVwZGF0ZS4NCj4gPg0KPiBBaC4gSSB3YXNuJ3QgYXdhcmUgb2YgdGhh
dC4NCj4gU28gdGhhdCdzIGZpbmUsIHRoZW4sIGFuZCB5b3UgY2FuIGRpc3JlZ2FyZCBteSBjb21t
ZW50cyBoZXJlLg0KPg0KDQpTdXJlIEhhbm5lcy4gTm8gd29ycmllcy4NCg0KUmVnYXJkcywNCkth
cmFuDQo=
