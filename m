Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154D41BDDF;
	Fri,  9 Aug 2024 16:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723221438; cv=fail; b=pup/DH4FcZdaELRWTdWZIikeIW6VMC9s7T1DAm+ClNZ/4Kgn8aoztpEwPOW3wq/HMqBED+eOVVRU431LZxZIQMdtN9UV91n0YeS8/zzGv3LVq5Ukq6D5Frsd8oCZi3gj2S0Lwss5ogO1CKbnLaPP8eGklIv6iQ2SyRLk+GfAOHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723221438; c=relaxed/simple;
	bh=x7Km4VXMhsXxrvXckKvoRfGoKTXzPXBaHCm7sQehs3U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LbF3LPifvnV+OWVBglI9DhNxLmoNMCDdiTIGnxNy59WvFsMG35y50GBFb6e5xcoum99HKMnbZDOzeGIJJgJWjPmGyjJMpptXCalG/gjcN/pyINq4RAzPc6N8RkeOJZVrzztHBjXH8AU665RjvF9oUEHUIolrhW8y9rVDEFL45/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Ke9lBzPZ; arc=fail smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Ke9lBzPZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7580; q=dns/txt; s=iport;
  t=1723221436; x=1724431036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x7Km4VXMhsXxrvXckKvoRfGoKTXzPXBaHCm7sQehs3U=;
  b=Ke9lBzPZ9lcEaMqhFi1xt8VYp6eAhfvBUS84IhBQNJnlz+gSgdxt/bak
   Eb5pvugmfaP+MefW59/VojbCMG8VeZlz08tqEVp/7yrCE36mCli1LSaPy
   EvsDWigJHasae4nbiYqwaot17cyoC5DjMbYDQhfFN3AoGSd1+So/gMCWi
   I=;
X-CSE-ConnectionGUID: TUVOHS4JThuHoqArwszuSg==
X-CSE-MsgGUID: MvXbd1TLSMaUZMJBbluptg==
X-IPAS-Result: =?us-ascii?q?A0ANAADRRLZmmIsNJK1aHQEBAQEJARIBBQUBQCWBFggBC?=
 =?us-ascii?q?wGBcVJ7gR5IhFWDTAOETl+GUYIiA54SgSUDVg8BAQENAQFEBAEBhQYCFok+A?=
 =?us-ascii?q?iY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBBQEBBQEBAQIBBwUUAQEBAQEBAQE3B?=
 =?us-ascii?q?Q47hgKGXQEBAQEDEhEEDUUQAgEIGAICJgICAi8VEAIEAQ0FCBqCXoJlAwGid?=
 =?us-ascii?q?gGBQAKKKHp/M4EB4B2BGi4BiEoBgWyDeUSEMicbgg2BV4I3MT6ERRWDRDqCL?=
 =?us-ascii?q?wSGWTWHfoMQghIBCoNIg1qCOSZNV4dTfYgXCUl7HANZIQIRAVUTFwsJBWiIY?=
 =?us-ascii?q?QqBBoIdKYFLJoEMgwuBNYN5gWcMYYhUgQ6BPoFeAYNAS4NegX9CP4JZdFZIA?=
 =?us-ascii?q?g0CN0QdQAMLbT01FBsFBDp7BaY1gjmBD0I9J4EJDwEpkxUCCIMdSa1igTMKh?=
 =?us-ascii?q?BShbxeqQJhvIqMphSECBAIEBQIPAQEGgWc6gVtwFTuCZ1IZD44tDQnQK3gCO?=
 =?us-ascii?q?QIHCwEBAwmNKwEB?=
IronPort-PHdr: A9a23:6qhl1BOGg0n3epSsdj0l6nc2WUAX0o4cdiYP4ZYhzrVWfbvmpdLpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:oU2Ix6+Oif5n78kDWGVbDrUDvX6TJUtcMsCJ2f8bNWPcYEJGY0x3y
 zcXUGCDbqqKY2DwLownaIzgo01QuZfXmNc3QAY+ri1EQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEzmB4E7rauW8xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4ujyyHjEAX9gWIsYjpFs/jrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kKALM/2t0rI11O6
 NwfMRkXcQuRmtm5lefTpulE3qzPLeHiOIcZ/3pn1zycU7AtQIvIROPB4towMDUY358VW62AI
 ZNCL2M0PXwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQri+m2boqIJ43iqcN9u1ior
 G6fw0DCJxgnBvm94zCB72qwibqa9c/8cNlPTOLjrKECbEeo7mgSDgAGEFi2u/+0jmagVN9Fb
 U8Z4Cwjqe417kPDZt38WQCo5WWPpR80RdVdCas55RuLx66S5ByWblXoVRZIbNgg8cQxXzFvi
 BmCnsjiAnpkt7j9pW+hGqm8kQ6MHggucU0+ZTIkShIs+cb4spwIgUeaJjp8K5KdgtrwEDD25
 jmFqikimrke5fLnMY3loTgrZBry+vD0oh4J2+nBYo6yAupEiGONbois7x3Q6uxNadjfRViat
 39CkM+bhAzvMX1vvHLTKAnuNOj1jxpgDNE6qQUxd3XG32/xk0NPhagKvFlDyL5Ba67ogwPBb
 k7Joh9275ROJnasZqIfS9vuUZ9zkPK6SIu4Cq68gj9yjn5ZKVHvEMZGOBH44owRuBJ1+U3CE
 c7BKJ/3XCxy5VpPl2XrHb11PUAXKtAWnj6LGsuhkHxLIJKVZWWeTv8eIUCSY+UipKKCq0O9z
 jqsH5Xi9vmra8WnOnO/2ddKdTgidCFnbbio8JY/XrDYfWJb9JQJVqW5LUUJIdI1xsy4V47go
 xmAZ6Ov4ASk2iabeFvXMRiOqtrHBP5CkJ7yBgR1VX6A0Hk4aoHp56AaH6bbt5F+nAC/5ZaYl
 8U4Rvg=
IronPort-HdrOrdr: A9a23:C8xbVqPmHfp81cBcT47255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
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
X-Talos-CUID: 9a23:gUUM4m3x/FVKLCsSqoS577xfJv0bVV3mkFXsI1KYDn9AUqKOW0Kr9/Yx
X-Talos-MUID: 9a23:SYDaFwp/Tx7fpKJSHjUezxR8BM1kupiKM2UErKcjmeOOMTFoJzjI2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-core-6.cisco.com ([173.36.13.139])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:36:07 +0000
Received: from rcdn-opgw-2.cisco.com (rcdn-opgw-2.cisco.com [72.163.7.163])
	by alln-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 479Ga7wI017104
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Aug 2024 16:36:07 GMT
X-CSE-ConnectionGUID: 4DQnxNveRv6cKRCcBDSgyA==
X-CSE-MsgGUID: spVb8jWPR5SXAs5awNMb9g==
Authentication-Results: rcdn-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="19777163"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by rcdn-opgw-2.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:36:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dmCl5E1GT4EsyeCqJiTAzZWRueNkoov88GJ0Re5flkilsnCy1U4t1U13c1X5Wt9RuIpR8lh56dbxbL8XFN6qciegFvEIVZCTqPEP+BW+KzeunJ8lF3CxJBGmS+G0cGImf+GWkS8cNlk2tt0ltdxdwzwUrHMK0C2Djm3yJEFtIjyc6/tmU28PEHdI2X85xjbXzjYmExsY8tZbyM7MqfL6OpqRtMNlUJAzBEalc/zjWA3jPcxN0pSc2i3GdYZ69GBHTxXZDfdikG3E0HMbP2/WOLuRhp0YC6gKfupuLpboOOb7ctHS82g8zAWikCgKqQntBwCXdzfhWzrsGswbbKfiKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7Km4VXMhsXxrvXckKvoRfGoKTXzPXBaHCm7sQehs3U=;
 b=e+oahAV9sxz6oyFVgTYgbgujjpK6p4aANdOYjTwmmq8h2cFlyXquH9EBf7ilcm+iS58+JgyjDpvaYhFHDdTMs6g4jqDhmpzKByixg0cgjqqHpnkrnGc+NbF+V9JtFW6AMJj/phva+mwwtwvw910qLySB9JjFV5emvzLwlJ7YOJro2hfDosy1lQU1qdLZYq9BKbqDiqrOHCGWUcxS0KpsUSQ6PaBhFf2Wap/hLlQ7z22WkbXKYamoRpkPlN4xKxl+gMRco+IdC1q8aYLCr9/a6a40SGZ1YZFLz8uyUdc0G17XZgCDNz8Pf5lW6QTnbAFRFi7/8zf8alvTBlQ0LMsCRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ0PR11MB4944.namprd11.prod.outlook.com (2603:10b6:a03:2ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.31; Fri, 9 Aug
 2024 16:36:04 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%7]) with mapi id 15.20.7828.023; Fri, 9 Aug 2024
 16:36:04 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: John Garry <john.g.garry@oracle.com>,
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
Subject: RE: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
Thread-Topic: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
Thread-Index: AQHau4DaQOSKJ2YKKUeWgcrHrkbAXbHF2ruAgFmd70A=
Date: Fri, 9 Aug 2024 16:36:04 +0000
Message-ID:
 <SJ0PR11MB5896CE3F203F4904D3B0D20CC3BA2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-8-kartilak@cisco.com>
 <5ca4b94b-8695-4355-997c-3f531d8b8702@oracle.com>
In-Reply-To: <5ca4b94b-8695-4355-997c-3f531d8b8702@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ0PR11MB4944:EE_
x-ms-office365-filtering-correlation-id: 470c573d-8166-41f2-ef5a-08dcb8915cd3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SUZBcU84VlJXNWorODhnZDJCbThWM1JxQWJCb0lvS2EzZzdqL2NYbjVrOHFq?=
 =?utf-8?B?cmdKTFlLYkJldENmR2crSm1xYVQzZzBuVkhCQ1FQQ2dGY0JzczNDMlNybE4w?=
 =?utf-8?B?MWhoekJpS2YyMkwvcnR1Z2F6dERvSHd4YmR1Y2VpaDJiWGV4Vnh5MWV4akZo?=
 =?utf-8?B?cUU5QjdsUXBTMWM1aVNPVndtV2d3b2NDb3NPK01JZWc5NTlPaEZ6dmtDNTh4?=
 =?utf-8?B?dmE3UzJsa0drRUF6a2MwT1ljQzA1Y2hXWWpXMzhYZTRYRnVqTG9BWE01OVFr?=
 =?utf-8?B?cFUzc05oTVpyV2MrU0ZEMlN5TDA5cDE4TE9jTFBwdy91TCs0SFVWaTUrc2ds?=
 =?utf-8?B?bnBtc20wNk12Tk04VGtLSVk4SWZZR0pjczBmVjV5QlJhYVZidTBKYXdsd0Uv?=
 =?utf-8?B?c3BRV01wT2FjbnY1a1Y5cjhZVHlUQVhZODhaNDBUOHBvQzJaTms0c3NWd3Qx?=
 =?utf-8?B?NUlUNWw4V2htN2ZPbjFEUnVad3ErVVBmemRiZ1gvUFFESjFpU3N5UVFPUE9L?=
 =?utf-8?B?eTYzOVJ6WHN1c0NFamhIdmNMWUp4TmtVa0ZkN0hYbDB0OGRJQWtydW1qcU0y?=
 =?utf-8?B?eUMyQkVmeCtPb3JNTy9VMXN5ZGNjVmx1cGxSUVNlbEFId2RxejBBT21zcmEx?=
 =?utf-8?B?MTVLbENZSHU5cTUya1lVQjUwWjY0NDNQd0FjeWJsUmp6OWt6Z1hkZGpXWGt1?=
 =?utf-8?B?Ujd1N0IvdEVxZ1FGaFdTUUFNVEpmNVBubXUvcG5MYUNsSFpBd2pTN3N1dTU0?=
 =?utf-8?B?WjZJNG9hakRObUxKSUxXOVM4azF2OGhNdVhubGxVeGJ2YlJzSkNsdVRGOGFV?=
 =?utf-8?B?blBEYkJaUlJPSUZrOGx3V1VNQnVtTGlKbmE3ZHdmV2wyYTV1b1ltMmdXei96?=
 =?utf-8?B?bW11ejBqWHlmNW9WT2xOWVRLbGtlaGZETzJVTEN4QUIvdUFSTk5IbUZQTU1Q?=
 =?utf-8?B?ZDhUbGJsWmcxZllFN3BmUVFsVE5oRUlMNHBmaVdQa2loeGMxU0g5czZUb3Ra?=
 =?utf-8?B?aXc4cVFJZ2ZVcVI1TEZCVDNVZzQwTzVydVRtODFvUXFQRU9xcTZaLzNSOGI3?=
 =?utf-8?B?MFZ4aDk5blBqbm05VjExdWJFcmZPdFM2M3ZURmVWQlEyZXhQbFBHVjY5MVpF?=
 =?utf-8?B?MWJ6Q1hHb3prL0RnRzFnYlpRWkJQWEdMNnUzU2x3eWM4OGc2Z25Femw5eUUr?=
 =?utf-8?B?Mi93NnBYZ0I3QXdCUkRXMHNIQ2k3T2pOWEtJdUVSZm04dGZKYUdjRXo1dDlh?=
 =?utf-8?B?VUsvK01CeWNWMjNHTjhWY0UrWnpxKy9BSnQ0NndabjRWSVJEZGhpWkZ5endS?=
 =?utf-8?B?eUo0NWpqOWk3cUtBNG4wREk1Z1RzbmhrbU1uQnd0bU9sNDBJa25INDhKa1Vj?=
 =?utf-8?B?dkdLZ2x6YUpSTGhsdVR2Q0pNR1hkcWpVQTMxaFpzWlkvTFZZQ1pOcitHdXRu?=
 =?utf-8?B?M2FISWMwWmt3K2VxekJvOU9YR01xMVBtNHdzczRWRUVuNVNRMVRzR01WeHFz?=
 =?utf-8?B?c3ZqZG94dkc3L3IvY09HZzByTitZTkYzeDhnVWZEV1BhSFM5cVF3NDZ5cVVQ?=
 =?utf-8?B?VHZFY2dyTFc4MFFkVGd6Lys5QTF1Z2ZnNWNpcmZVSStNTnBtK3M1eG5Nb3Qv?=
 =?utf-8?B?VkxVNURpeXhMRVozdSs2a0w3NzZEMXpBK2RybHhEeWtpQjVnR2hIbllwYjdM?=
 =?utf-8?B?SDVXZmpsNE1hbVBtQktlVXpVRVFWZHU3Y3VyWVlVRy9UWkJiUXQwUWt6dUVz?=
 =?utf-8?B?QjJ4NlVaVGI0TFVlZkNUTFg4MU9sdHJDc1lmc1IxdDNoVUFZbUlESkpXT3Ur?=
 =?utf-8?B?TlFZb25TVlJIVXN1c3hyZDNGOHJnU1RUWlUxRWtOQ2tidXBRQmdqS0VKQU9C?=
 =?utf-8?B?OVFtcVBrZG9pOU5aS1pyL1lVY3JoS3VkMjZSZVVPbkNQaGc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dHNaMGVRVVAvaG5UN2Q5N0svNTQ2Wk9uM3NlNXdjbHlVSlBNTUdtU2hYSVVr?=
 =?utf-8?B?TlZHMVZjYXlvT0lISWxnTE9nellBS1k0QzVRSng4RUtIRHd3Ri8veTFJblk2?=
 =?utf-8?B?RzQ2V0FlYVhrU0VzZzlYenZROUhSZHZLaDZNcWRhU0g1T0tmbjN5czRZR2xi?=
 =?utf-8?B?cTJZR3UxYmlpSEsvZ1dhUmpPL1p6Nk1ZQTVJekhRRllDVkxmL2hmUWJPK251?=
 =?utf-8?B?SDZYZG1YMnNqK2dpNTRYYWFxajd1S3lRSzBtRStlMlRLeUZ4SGNoYTdRVXhB?=
 =?utf-8?B?WmRxYVZmc0FYTmZCM2xBNkJmcFdvZ1NkUEY5T0R6REpqamdGVnoxUU1sYW1W?=
 =?utf-8?B?Mm5JZ2w1YXJsRWc3MzVuVXB6dGVXNVBhdG12U1NuUk5UNjdHNXQrejFuL2w1?=
 =?utf-8?B?aS9WcVc4czhQdmpFSmhxU1pyOVJiRCtPVUo4bEdwTzZTQkFiMDVlZ1gzNDQ2?=
 =?utf-8?B?SEZuWXZhSnVHaEFYQTFXNzgvcWdWQld0dXdMVXpETXBVak1XdklxTUhmdklG?=
 =?utf-8?B?Zk1PQXNGdEswblNjTXh2L3FQdGRCMDRqWXIxLzFnS2ZjbWUwdGJGTVVsTXBo?=
 =?utf-8?B?T2JPYlI3TnVxUHd3SU40cjRxTGRLWjVHVUNqSllkVWh1NEZaVC9KbzlHQW9q?=
 =?utf-8?B?U3JiV0NCQk4zY3BWTmJEbXRDTUxtUnBaaDJMSFIrYVJ0cGFpTm1GcHlYc0lz?=
 =?utf-8?B?MkNXdWRXRTFpamtMT3BuMFhtZzFuT0hqaW1naDljbUZBZlBHMllxcmhPQldM?=
 =?utf-8?B?a1A2c1A4MGtoY1ZrN09VK3pBV1NaMzVJNlJtWWZaSEdQT0VRSU8zNW4wZEpC?=
 =?utf-8?B?NWtGOW5jdFJ6QloyVUpsKzVmcUEzaHRYUjY2RngvYTRrNTJnd2xJMW9WK3dY?=
 =?utf-8?B?RnV4MmZ1dmVsUUVkMFlaR3ZtVkZrWEcvZnFOeitPbDVwTSt0blRhN1hnb3B2?=
 =?utf-8?B?MjBzSUIrMHV1Ni9MNjhqcWlsQ3Y2OTZkMkwwNnVxdzJ2TmY3RlZVSUZQakdo?=
 =?utf-8?B?Y3FBcUhlM2Fnb3BEYVo5NWl6eC9memdHUlFLMERKcWZnTndnbUhXc0tWN0hm?=
 =?utf-8?B?NExCejJYMXpISzN4REsrMVQ0UFVKNDFLZFdYclE2THVDSU5VMzd5TTVuQ0Yw?=
 =?utf-8?B?TjVxa05YWDZLemFISmFUbEV4ODNWaUJIeW4xTktCRjl0Si9rUkhHTGR3Nzlr?=
 =?utf-8?B?RXhTWmtidkg3Z0l5eXkwcHB6c1ZSVVJOTTRqL2phcWU0czhBaDUxL3FVTWts?=
 =?utf-8?B?YXBTN3NKYXBCRWRHSjZRM2FUSUVxWE51WG5Wb0xaSDllQ1RvbHNSQ0g5Q2xQ?=
 =?utf-8?B?SllvRjgwNTNVUnExZ1A4WDVNL2NnYmtIZjV0QnFQditoZnNQYkNZOHdLVnZY?=
 =?utf-8?B?ZE9IUE8rQ0ZtNnR6d0ZTS3d1ODBOYlh1RzZBeTBIalVXdkxoN2VoZDVNWkx1?=
 =?utf-8?B?Z0ZSbU5TNFNwa095Q1BJUnQ1SG5kdVk1MngrRWdUZzJlU3A4ZzdyVnNpWWxh?=
 =?utf-8?B?RDAybGlPTlR3emFkUHcrdlpEMTJjWGpIN3lsZnFSeHFWT2RUdGUzVzZEMWM5?=
 =?utf-8?B?bUoyMzM4OFpXeUNHbzdpU2h6R01hVGNIZHBKd0t3TlVUVjhwbnNpRU04QUJ2?=
 =?utf-8?B?UC9obDN5Tk9FQkJuWnNpclhpbHYrZnBiSUJxdGliQWxLcCtRK1N5dFdJc3l0?=
 =?utf-8?B?OCs3QUpzWVBJQnYzZXZXMWRKZVZ3ZEVxRW9qazN1S2FNVW1zL215azdkeHpo?=
 =?utf-8?B?ZnQ4WmFCUlR1QVQvOHY2WFZaK0pzOXhRN1cwUmpOelI5QW1nQWRqRVpBWVZL?=
 =?utf-8?B?c2VnZmtlZzU3ZGZRTUY4Ymh0L2phWDJEZmZ3azJwdGZjTDEvTmU5U1ZHazA1?=
 =?utf-8?B?S1lidnNKQjFsYkhOcjYrN2hpWFh2dk5jbzVYNkJEQ2UxTjM4SnBTdkt0emdI?=
 =?utf-8?B?YTdtTTFrNUNPQ0d3UnlENlZNUkV0UXhCS1hPbHNnRndIekVMTG95SkhpTGVC?=
 =?utf-8?B?QTBjUGNocE5pcGdKc3BXMVVRYkh6Sk9FNDk2YllEK1ZzaWhBdTNzbXBHbmY5?=
 =?utf-8?B?TnJXQ0VCenhFYlZidmkxWXJQUjhRaW9GOXJlL0hRRHBTRDdJSFh4aUpVREts?=
 =?utf-8?Q?WjOai+ao1A7ZD9+AIRgdaTrvY?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 470c573d-8166-41f2-ef5a-08dcb8915cd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 16:36:04.6878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x8jval9mP1T3X1s25saE0rBH+84rT9fUXk2vxBX7tpmUhNYZeu+CtOhMlq5BI4DH1IMLgxJ7PETtjqkCGzVwLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4944
X-Outbound-SMTP-Client: 72.163.7.163, rcdn-opgw-2.cisco.com
X-Outbound-Node: alln-core-6.cisco.com

T24gVGh1cnNkYXksIEp1bmUgMTMsIDIwMjQgOToxNyBQTSwgSm9obiBHYXJyeSA8am9obi5nLmdh
cnJ5QG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gMTAvMDYvMjAyNCAyMjo1MCwgS2FyYW4g
VGlsYWsgS3VtYXIgd3JvdGU6DQo+ID4gQWRkIGFuZCBpbnRlZ3JhdGUgc3VwcG9ydCBmb3IgRkNv
RSBJbml0aWFsaXphdGlvbg0KPiA+IChwcm90b2NvbCkgRklQLiBUaGlzIHByb3RvY29sIHdpbGwg
YmUgZXhlcmNpc2VkIG9uDQo+ID4gQ2lzY28gVUNTIHJhY2sgc2VydmVycy4NCj4gPiBBZGQgc3Vw
cG9ydCB0byBzcGVjaWZpY2FsbHkgcHJpbnQgRklQIHJlbGF0ZWQNCj4gPiBkZWJ1ZyBtZXNzYWdl
cy4NCj4gPiBSZXBsYWNlIGV4aXN0aW5nIGRlZmluaXRpb25zIHRvIGhhbmRsZSBuZXcNCj4gPiBk
YXRhIHN0cnVjdHVyZXMuDQo+ID4gQ2xlYW4gdXAgb2xkIGFuZCBvYnNvbGV0ZSBkZWZpbml0aW9u
cy4NCj4gDQo+ID4gUmV2aWV3ZWQtYnk6IFNlc2lkaGFyIEJhZGRlbGEgPHNlYmFkZGVsQGNpc2Nv
LmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogQXJ1bHByYWJodSBQb25udXNhbXkgPGFydWxwb25uQGNp
c2NvLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogR2lhbiBDYXJsbyBCb2ZmYSA8Z2Nib2ZmYUBjaXNj
by5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogS2FyYW4gVGlsYWsgS3VtYXIgPGthcnRpbGFrQGNp
c2NvLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvc2NzaS9mbmljL01ha2VmaWxlICAgIHwg
ICAxICsNCj4gPiAgIGRyaXZlcnMvc2NzaS9mbmljL2ZpcC5jICAgICAgIHwgODc1ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAgZHJpdmVycy9zY3NpL2ZuaWMvZmlwLmgg
ICAgICAgfCAzNDEgKysrKysrKysrKysrKw0KPiA+ICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5o
ICAgICAgfCAgMjMgKy0NCj4gPiAgIGRyaXZlcnMvc2NzaS9mbmljL2ZuaWNfZmNzLmMgIHwgODg5
ICsrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiAgIGRyaXZlcnMvc2NzaS9m
bmljL2ZuaWNfbWFpbi5jIHwgIDQ3ICstDQo+ID4gICA2IGZpbGVzIGNoYW5nZWQsIDE0MDIgaW5z
ZXJ0aW9ucygrKSwgNzc0IGRlbGV0aW9ucygtKQ0KPiA+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRy
aXZlcnMvc2NzaS9mbmljL2ZpcC5jDQo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9z
Y3NpL2ZuaWMvZmlwLmgNCj4gPiArDQo+ID4gKy8qKg0KPiA+ICsgKiBmbmljX2Zjb2VfcHJvY2Vz
c192bGFuX3Jlc3ANCj4gPiArICoNCj4gPiArICogUHJvY2Vzc2VzIHRoZSB2bGFuIHJlc3BvbnNl
IGZyb20gb25lIEZDRiBhbmQgcG9wdWxhdGVzIFZMQU4gbGlzdC4NCj4gPiArICogV2lsbCB3YWl0
IGZvciByZXNwb25zZXMgZnJvbSBtdWx0aXBsZSBGQ0ZzIHVudGlsIHRpbWVvdXQuDQo+ID4gKyAq
DQo+ID4gKyAqIEBwYXJhbSBmbmljIGRyaXZlciBpbnN0YW5jZQ0KPiA+ICsgKiBAcGFyYW0gZmlw
aCByZWNlaXZlZCBmaXAgZnJhbWUNCj4gPiArICovDQo+ID4gKw0KPiA+ICt2b2lkIGZuaWNfZmNv
ZV9wcm9jZXNzX3ZsYW5fcmVzcChzdHJ1Y3QgZm5pYyAqZm5pYywNCj4gPiArCQkJCQkJCQkgc3Ry
dWN0IGZpcF9oZWFkZXJfcyAqZmlwaCkNCj4gPiArew0KPiA+ICsJc3RydWN0IGZpcF92bGFuX25v
dGlmX3MgKnZsYW5fbm90aWYgPSAoc3RydWN0IGZpcF92bGFuX25vdGlmX3MgKikgZmlwaDsNCj4g
PiArDQo+ID4gKwlzdHJ1Y3QgZm5pY19zdGF0cyAqZm5pY19zdGF0cyA9ICZmbmljLT5mbmljX3N0
YXRzOw0KPiA+ICsJdTE2IHZpZDsNCj4gPiArCWludCBudW1fdmxhbiA9IDA7DQo+ID4gKwlpbnQg
Y3VyX2Rlc2MsIGRlc2NfbGVuOw0KPiA+ICsJc3RydWN0IGZjb2VfdmxhbiAqdmxhbjsNCj4gPiAr
CXN0cnVjdCBmaXBfdmxhbl9kZXNjX3MgKnZsYW5fZGVzYzsNCj4gPiArCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7DQo+ID4gKw0KPiA+ICsJRk5JQ19GSVBfREJHKEtFUk5fSU5GTywgZm5pYy0+bHBvcnQt
Pmhvc3QsIGZuaWMtPmZuaWNfbnVtLA0KPiA+ICsJCQkJICJmbmljIDB4JXAgZ290IHZsYW4gcmVz
cFxuIiwgZm5pYyk7DQo+ID4gKw0KPiA+ICsJZGVzY19sZW4gPSBudG9ocyh2bGFuX25vdGlmLT5m
aXAuZGVzY19sZW4pOw0KPiA+ICsJRk5JQ19GSVBfREJHKEtFUk5fSU5GTywgZm5pYy0+bHBvcnQt
Pmhvc3QsIGZuaWMtPmZuaWNfbnVtLA0KPiA+ICsJCQkJICJkZXNjX2xlbiAlZFxuIiwgZGVzY19s
ZW4pOw0KPiA+ICsNCj4gPiArCXNwaW5fbG9ja19pcnFzYXZlKCZmbmljLT52bGFuc19sb2NrLCBm
bGFncyk7DQo+ID4gKw0KPiA+ICsJY3VyX2Rlc2MgPSAwOw0KPiA+ICsJd2hpbGUgKGRlc2NfbGVu
ID4gMCkgew0KPiA+ICsJCXZsYW5fZGVzYyA9DQo+ID4gKwkJCShzdHJ1Y3QgZmlwX3ZsYW5fZGVz
Y19zICopICgoKGNoYXIgKikgdmxhbl9ub3RpZi0+dmxhbnNfZGVzYykNCj4gPiArCQkJCQkJCQkJ
CSsgY3VyX2Rlc2MgKiA0KTsNCj4gPiArDQo+ID4gKwkJaWYgKHZsYW5fZGVzYy0+dHlwZSA9PSBG
SVBfVFlQRV9WTEFOKSB7DQo+ID4gKwkJCWlmICh2bGFuX2Rlc2MtPmxlbiAhPSAxKSB7DQo+ID4g
KwkJCQlGTklDX0ZJUF9EQkcoS0VSTl9JTkZPLCBmbmljLT5scG9ydC0+aG9zdCwgZm5pYy0+Zm5p
Y19udW0sDQo+ID4gKwkJCQkJICJJbnZhbGlkIGRlc2NyaXB0b3IgbGVuZ3RoKCV4KSBpbiBWTGFu
IHJlc3BvbnNlXG4iLA0KPiA+ICsJCQkJCSB2bGFuX2Rlc2MtPmxlbik7DQo+ID4gKw0KPiA+ICsJ
CQl9DQo+ID4gKwkJCW51bV92bGFuKys7DQo+ID4gKwkJCXZpZCA9IG50b2hzKHZsYW5fZGVzYy0+
dmxhbik7DQo+ID4gKwkJCUZOSUNfRklQX0RCRyhLRVJOX0lORk8sIGZuaWMtPmxwb3J0LT5ob3N0
LCBmbmljLT5mbmljX251bSwNCj4gPiArCQkJCQkJICJwcm9jZXNzX3ZsYW5fcmVzcDogRklQIFZM
QU4gJWRcbiIsIHZpZCk7DQo+ID4gKwkJCXZsYW4gPSBrbWFsbG9jKHNpemVvZigqdmxhbiksIEdG
UF9BVE9NSUMpOw0KPiANCj4gDQo+IGlzIHRoaXMgYWxsb2MgdW5kZXIgc3BpbmxvY2sgcmVhbGx5
IHJlcXVpcmVkPw0KDQpZZXMgSm9obi4gVGhlcmUgY2FuIGJlIHJlc3BvbnNlcyBmcm9tIG11bHRp
cGxlIEZDRnMsIHdpdGggbXVsdGlwbGUgdmxhbnMuIA0KRXZlbiB0aG91Z2ggdGhlIHJlc3BvbnNl
cyBhcmUgc2VyaWFsaXplZCB2aWEgYSBmcmFtZSBxdWV1ZSwNCml0J3Mgbm90IHdvcnRoIHRoZSBl
ZmZvcnQgb2YganVzdCBkcm9wcGluZyB0aGUgbG9jayBmb3IgdGhlDQpzYWtlIG9mIGFsbG9jYXRp
bmcgdGhlIHZsYW4uIEhvcGUgdGhpcyBjbGFyaWZpZXMuDQpUaGFua3MgYWdhaW4gZm9yIHlvdXIg
cmV2aWV3Lg0KDQo+ID4gKy8qKg0KPiA+ICsgKiBmbmljX2hhbmRsZV9lbm9kZV9rYV90aW1lcg0K
PiA+ICsgKg0KPiA+ICsgKiBGSVAgbm9kZSBrZWVwIGFsaXZlLg0KPiA+ICsgKg0KPiA+ICsgKiBA
cGFyYW0gZGF0YSBPcGFxdWUgcG9pbnRlciB0byBmbmljIHN0cnVjdA0KPiA+ICsgKi8NCj4gPiAr
dm9pZCBmbmljX2hhbmRsZV9lbm9kZV9rYV90aW1lcihzdHJ1Y3QgdGltZXJfbGlzdCAqdCkNCj4g
PiArew0KPiA+ICsJc3RydWN0IGZuaWMgKmZuaWMgPSBmcm9tX3RpbWVyKGZuaWMsIHQsIGVub2Rl
X2thX3RpbWVyKTsNCj4gPiArDQo+ID4gKwlzdHJ1Y3QgZm5pY19pcG9ydF9zICppcG9ydCA9ICZm
bmljLT5pcG9ydDsNCj4gPiArCWludCBmcl9sZW47DQo+ID4gKwlzdHJ1Y3QgZmlwX2Vub2RlX2th
X3MgZW5vZGVfa2E7DQo+ID4gKwl1NjQgZW5vZGVfa2FfdG92Ow0KPiA+ICsNCj4gPiArCWlmIChp
cG9ydC0+ZmlwLnN0YXRlICE9IEZETFNfRklQX0ZMT0dJX0NPTVBMRVRFKQ0KPiA+ICsJCXJldHVy
bjsNCj4gPiArDQo+ID4gKwlpZiAoKGlwb3J0LT5zZWxlY3RlZF9mY2Yua2FfZGlzYWJsZWQpDQo+
ID4gKwkJfHwgKGlwb3J0LT5zZWxlY3RlZF9mY2YuZmthX2Fkdl9wZXJpb2QgPT0gMCkpIHsNCj4g
PiArCQlyZXR1cm47DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJZnJfbGVuID0gc2l6ZW9mKHN0cnVj
dCBmaXBfZW5vZGVfa2Ffcyk7DQo+ID4gKw0KPiA+ICsJbWVtY3B5KCZlbm9kZV9rYSwgJmZpcF9l
bm9kZV9rYV90bXBsLCBmcl9sZW4pOw0KPiA+ICsJbWVtY3B5KGVub2RlX2thLmV0aC5zbWFjLCBp
cG9ydC0+aHdtYWMsIEVUSF9BTEVOKTsNCj4gPiArCW1lbWNweShlbm9kZV9rYS5ldGguZG1hYywg
aXBvcnQtPnNlbGVjdGVkX2ZjZi5mY2ZfbWFjLCBFVEhfQUxFTik7DQo+ID4gKwltZW1jcHkoZW5v
ZGVfa2EubWFjX2Rlc2MubWFjLCBpcG9ydC0+aHdtYWMsIEVUSF9BTEVOKTsNCj4gPiArDQo+ID4g
KwlmbmljX3NlbmRfZmlwX2ZyYW1lKGlwb3J0LCAmZW5vZGVfa2EsIGZyX2xlbik7DQo+ID4gKwll
bm9kZV9rYV90b3YgPSBqaWZmaWVzDQo+ID4gKwkJKyBtc2Vjc190b19qaWZmaWVzKGlwb3J0LT5z
ZWxlY3RlZF9mY2YuZmthX2Fkdl9wZXJpb2QpOw0KPiA+ICsJbW9kX3RpbWVyKCZmbmljLT5lbm9k
ZV9rYV90aW1lciwgcm91bmRfamlmZmllcyhlbm9kZV9rYV90b3YpKTsNCj4gPiArfQ0KPiA+ICsN
Cj4gPiArLyoqDQo+ID4gKyAqIGZuaWNfaGFuZGxlX3ZuX2thX3RpbWVyDQo+ID4gKyAqDQo+ID4g
KyAqIEZJUCB2aXJ0dWFsIHBvcnQga2VlcCBhbGl2ZS4NCj4gPiArICoNCj4gPiArICogQHBhcmFt
IGRhdGEgT3BhcXVlIHBvaW50ZXIgdG8gZm5pYyBzdHJ1Y3R1cmUNCj4gPiArICovDQo+ID4gKw0K
PiA+ICt2b2lkIGZuaWNfaGFuZGxlX3ZuX2thX3RpbWVyKHN0cnVjdCB0aW1lcl9saXN0ICp0KQ0K
PiA+ICt7DQo+ID4gKwlzdHJ1Y3QgZm5pYyAqZm5pYyA9IGZyb21fdGltZXIoZm5pYywgdCwgdm5f
a2FfdGltZXIpOw0KPiA+ICsNCj4gPiArCXN0cnVjdCBmbmljX2lwb3J0X3MgKmlwb3J0ID0gJmZu
aWMtPmlwb3J0Ow0KPiA+ICsJaW50IGZyX2xlbjsNCj4gPiArCXN0cnVjdCBmaXBfdm5fcG9ydF9r
YV9zIHZuX3BvcnRfa2E7DQo+ID4gKwl1NjQgdm5fa2FfdG92Ow0KPiA+ICsJdWludDhfdCBmY2lk
WzNdOw0KPiA+ICsNCj4gPiArCWlmIChpcG9ydC0+ZmlwLnN0YXRlICE9IEZETFNfRklQX0ZMT0dJ
X0NPTVBMRVRFKQ0KPiA+ICsJCXJldHVybjsNCj4gPiArDQo+ID4gKwlpZiAoKGlwb3J0LT5zZWxl
Y3RlZF9mY2Yua2FfZGlzYWJsZWQpDQo+ID4gKwkJfHwgKGlwb3J0LT5zZWxlY3RlZF9mY2YuZmth
X2Fkdl9wZXJpb2QgPT0gMCkpIHsNCj4gPiArCQlyZXR1cm47DQo+ID4gKwl9DQo+IA0KPiBleGFj
dCBzYW1lIGNvZGUgaXMgZHVwbGljYXRlZCBmcm9tIGZuaWNfaGFuZGxlX2Vub2RlX2thX3RpbWVy
KCksIGFib3ZlDQoNClRoYW5rcyBmb3IgdGhpcyBvYnNlcnZhdGlvbiwgSm9obi4gDQpUaGUgY2hh
bGxlbmdlIHdpdGggaW50ZWdyYXRpbmcgdGhlbSBpbnRvIG9uZSBmdW5jdGlvbiB1c2luZyANCnNv
bWUgYXJndW1lbnRzIGlzIHRoYXQgd2Ugd291bGQgbm90IGtub3cgd2hpY2ggdGltZXIgZWxhcHNl
ZC4NClRoZXJlZm9yZSwgd2UgZGVjaWRlZCB0byBnbyB3aXRoIHRoaXMgYXBwcm9hY2ggb2Ygc2Vw
YXJhdGUNCnRpbWVyIGZ1bmN0aW9ucy4gSG9wZSB0aGlzIGNsYXJpZmllcy4NCg0KUmVnYXJkcywN
CkthcmFuDQo=
