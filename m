Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB9A2570;
	Tue, 11 Jun 2024 17:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718128131; cv=fail; b=Ae6KDyHGhK2d+BpyQuJ0HiFJ+IvdZQN+ch7d2w9RHaU2TcY10Mv4RveCJ3csyiB1wUMEo47CgXDREw2qDWzuGcNsN9wWtdcDy9T55+6qtNCcx+ZRT6f/xX4Isi/imXQDiummdTus9rDHR0ZrS9negeRjK2tRZbyv24c64LSY69I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718128131; c=relaxed/simple;
	bh=CX10HQvZTmIwcWPSp8f+B83dyOjb/HZOLC6EKve8b7g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EKNDAYxIzQcakTFso99r0fOg2JhM+beugEqBaX6TFPiNU3kBj70P+cgfYaSuU1YUyrZjbsDjWBLYW8wMOtJ18hNPk2SEfD9Io+aQYeXD3VfUVDCdNj3AzQ6D6cF5dxCkoJi9cFxEXrwM0CSKVCkUWYwxDEaM4L/TMu/MyHVKed8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=dR+//mzh; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=l2plHh7B; arc=fail smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="dR+//mzh";
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="l2plHh7B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=448; q=dns/txt; s=iport;
  t=1718128129; x=1719337729;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CX10HQvZTmIwcWPSp8f+B83dyOjb/HZOLC6EKve8b7g=;
  b=dR+//mzhecKlSqpDEXRdBJxCCba9oY5yKz7NnSkPZX35QIA0y6YQau9D
   hKIJVHedg9fxP6AaUo52kFcpNIHUR5BvoNKN7v9ZbLYnPLgiunfqqYjSJ
   s6Uir0zigC/6H1lkyoiiRA+VcUaZ05C8SZgj2VbJWqfV/pKRGYUX7EACm
   c=;
X-CSE-ConnectionGUID: wkkA2QtNSESgW+Jn/KmkcA==
X-CSE-MsgGUID: iSsOjAJGS1aMv/N7M7TADg==
X-IPAS-Result: =?us-ascii?q?A0B3AwC3jGhm/4sNJK1SCB4BAQsSDEAlgR8LgXJSB3OBH?=
 =?us-ascii?q?kiEVYNMA4UtiHGeDIElA1YPAQEBDQEBRAQBAYUGAhaIUQImNAkOAQICAgEBA?=
 =?us-ascii?q?QEDAgMBAQEBAQEBAQEFAQEFAQEBAgEHBYEKE4V0DYZZAQEBAQMSEREMAQE3A?=
 =?us-ascii?q?Q8CAQgOCgICJgICAi8VEAIEAQ0FCBqFQwMBowwBgUACiih6gTKBAYIMAQEGB?=
 =?us-ascii?q?AXddwmBGi6IMQGBWYhjJxuCDYFXgjAHMT6BBQGBWwKBOSmDWTqCL45Dh20Xg?=
 =?us-ascii?q?xWCJYNOhiMmC0OKYAlLfRwDWSECEQFVExcLPgkWAhYDGxQEMA8JCxgOKgY5A?=
 =?us-ascii?q?hIMBgYGWTQCBwQjAwgEA0IDIHERAwQaBAsHd4EOY4E0BBNGAQ2BKolvDIEGg?=
 =?us-ascii?q?ikpgUkngQuDDktshASBawxhiG6BEIE+gWYBg1RMgjkdQAMLbT0UIRQbBQQ6e?=
 =?us-ascii?q?wWqaYQ/KpJsg0hJrUyBMgqEE6FnF4NyAaZGmGUgqEACBAIEBQIPAQEGgWU8g?=
 =?us-ascii?q?VlwFYMiUhkPjiE4g0LJaXg7AgcLAQEDCYpoAQE?=
IronPort-PHdr: A9a23:fXCCRheUCuyXbiqEwVvj2o9wlGM/eYqcDmcuAtIPkblCdOGk55v9e
 RaZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NBsdA97wMmXbuWb69jsOAlP6PAtxKP7yH9vRht6r1uS7+LXYYh5Dg3y2ZrYhZ
 BmzpB/a49EfmpAqar5k0BbLr3BUM+hX3jZuIlSe3l7ws8yx55VktS9Xvpoc
IronPort-Data: A9a23:aBrLOaNAPAj/DifvrR3HlsFynXyQoLVcMsEvi/4bfWQNrUpzgTdVn
 TAdWG7XPqyLZmT0Ktl2b96/oUkP75LUx4RgSnM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCdap1yFzmE+0rF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/W1PlV
 e/a+ZWFZAf7gmcsaAr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj6+ptD2hsBJE+wctMDl4N1
 /pfCzUOZTnW0opawJrjIgVtrs0nKM+uN4QFtzQ+izrYFv0hB5vERs0m5/cBg2x23Z4IRK2YP
 pFIAdZsREyojxlnOV4NFJM6leSAjXjkeDoeo1WQzUYyyzKCnVcrjuWyYbI5fPSLft5ynG+6i
 Vmf9kHnRTdFEYOj4BaKpyfEaujn2HmTtJgpPLm58ON6xV6e3GoeDDUIWlah5/q0kEizX5RYM
 UN80i4vq7UisVegVdjVQRK1ujiHswQaVt4WFPc1gDxh0YLd5wKfQ2MDVDMENpottdQ9Qnoh0
 Vrhc87VOAGDeYa9EBq13ryVtji1fyMSKAc/ieUsF2PpP/GLTFkPsy/y
IronPort-HdrOrdr: A9a23:CC0qRKHw0fHgT9VppLqFrZLXdLJyesId70hD6qkvc203TiXIra
 CTdaogtCMc0AxhKU3I+ertBEGBKUmsjKKdkrNhTYtKOzOW9ldATbsSorcKpgeQeREWmdQtqJ
 uIH5IOb+EYSGIK8/oSgzPIUurIouP3jJxA7N22pxwCPGQaD52IrT0JdTpzeXcGPDWucKBJbq
 Z0kfA33AZIF05nCPiTNz0uZcSGjdvNk57tfB4BADAayCTmt1mVwY+/OSK1mjMFXR1y4ZpKyw
 X4egrCiZmLgrWe8FvxxmXT55NZlJ/K0d1YHvGBjcATN3HFlhuoTJ4JYczAgBkF5MWUrHo6mt
 jFpBkte+5p7WnKQ22zqRzxnyH9zTcV7WP4w1PwuwqgnSW5fkN+NyNyv/MfTvLr0TtngDi66t
 MT44utjesSMfoHplWk2zGHbWAwqqP+mwtQrQdatQ0sbWJZUs4QkWTal3klTavp20nBmdoaOf
 grA8fG6PlMd1SGK3jfo2l02dSpGm8+BxGcXyE5y4aoOhVt7ThEJnEjtYcit2ZF8Ih4R4hP5u
 zCPKgtnLZSTtUOZaY4AOsaW8O4BmHEXBqJaQupUBjaPbBCP2iIp4/84b0z6u3vcJsUzIEqkJ
 CEVF9Dr2Y9d0/nFMXL1pxW9RLGRnm7QF3Wu4xjzok8vqe5SKvgMCWFRlxrm8y8o+8HCsmeQP
 q3MII+OY6rEYIvI/c+4+TTYegkFZBFarxhhj8SYSP7nv72
X-Talos-CUID: 9a23:Ncuoh2Bq3ACeIFf6EzZk92dOI9wDSVDmw0iTAUn/KmNqQ5TAHA==
X-Talos-MUID: 9a23:pASzMwpElngDcE/Eep0ezzBZL+BqyoaBMxkEtItBnZahahBZFzjI2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-core-6.cisco.com ([173.36.13.139])
  by alln-iport-3.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 17:48:47 +0000
Received: from rcdn-opgw-2.cisco.com (rcdn-opgw-2.cisco.com [72.163.7.163])
	by alln-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 45BHmlpg013261
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 17:48:47 GMT
X-CSE-ConnectionGUID: bO8PXi4zQ+OBr5khnZKZIQ==
X-CSE-MsgGUID: KkXwhLX4QbagS+kdjfo5MQ==
Authentication-Results: rcdn-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=reject dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.08,230,1712620800"; 
   d="scan'208";a="15746853"
Received: from mail-bn8nam04lp2042.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.42])
  by rcdn-opgw-2.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 17:48:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0fEusuUsNIgExEipAs4F2+Atmng0+GlOl7UGZ3dRupyxaJrOk8O6pfAConGmsJHsDiTQbGLMDz64duoY102Uf13ct3GtP0IMsu6v1cJvr7QoQFy3ht9IPrtyo9ZEzKIrPYTBbz1CClJ3rC5RpTcJ2ggeZeS0UcjFYsu0uLJoQ0GtIo/a0BxY1bEeGgyPXctFwhKnYZ2soek0g9a8mTuqA/IA4kToU4a0gkBmyPmCLFFqGTUoOSlTIS7Ag6Acd1cRYBvaT1UrUQ9vehHxLDw6cPgl+OI8vzfBh1obUsPX2tkd++ojnDG3lhfehuZR73krll+LyDkSOjB2KyDxF+fPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CX10HQvZTmIwcWPSp8f+B83dyOjb/HZOLC6EKve8b7g=;
 b=OZoFdW0E2CXKhfSA3CwK5cFklPSrGdye1omJFsFmfRwYtOQ7PwIKFRjW6G2bWXji2I729dGaxdwRjnLjaXjRrwF6RTJOtTyJCmQWSfCQrRwxn8QB4FC7SLT9vOmfXK7dZO5MpsbLboA5MtZZtlBD98RassfKaMVBAQ7QUx3r5vlZRwoebOODyjIRQktF/+DC6Q5Tc+vIOxu2+vf2Kt5yqpqUFZGoB7YWP74GrBhgQitLVOHT9V1h4+i/Ps1dYaFUnuFR50Jcjwp8SFiARQi/jsmviDMC/8euKMaLBsBGrvRrTBsumljdIPMtjuMxH9Z1CYVPkOyj8CRFGziQnYbmOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX10HQvZTmIwcWPSp8f+B83dyOjb/HZOLC6EKve8b7g=;
 b=l2plHh7BWNs9Op9qrK1gzK9uM3mGhvA6i6jA/W+xJNUvGIYGwfxvttqZ2owQiufep83DCUE3o3yzJ7x64sd1ocnq3d+5szC5+otOT6v8wXGhUrfo9yuZR0mhz32ycYLJtbradlG7alRVFkSKR45xHN871gTYKg0xlxTvtwzCpyk=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by LV8PR11MB8487.namprd11.prod.outlook.com (2603:10b6:408:1ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 17:48:44 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%6]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 17:48:44 +0000
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
Subject: RE: [PATCH 04/14] scsi: fnic: Add support for target based solicited
 requests and responses
Thread-Topic: [PATCH 04/14] scsi: fnic: Add support for target based solicited
 requests and responses
Thread-Index: AQHau4CNy6vhW6L1PkehFrT7789Nc7HCkGaAgABGbZA=
Date: Tue, 11 Jun 2024 17:48:44 +0000
Message-ID:
 <SJ0PR11MB58969E1EA7204885395CD6BAC3C72@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-5-kartilak@cisco.com>
 <a963acd7-7d93-4cdb-ad9b-045c22ed8ce1@suse.de>
In-Reply-To: <a963acd7-7d93-4cdb-ad9b-045c22ed8ce1@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|LV8PR11MB8487:EE_
x-ms-office365-filtering-correlation-id: 348ef5f3-7e21-46dd-0831-08dc8a3ebd39
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230032|376006|366008|1800799016|38070700010;
x-microsoft-antispam-message-info:
 =?utf-8?B?b0UxRTgxOGpCWHRGWkFPbnYvQlFaZ25sWk9NTW51Vm5HWnZaRStReDdBajVs?=
 =?utf-8?B?ZnNkSFltdGNBSTAwVVVSOWZXTndFeFBrYUgxR0VWRmZadXVqRzZLSUpEZWNn?=
 =?utf-8?B?R0swVUFraGZsaDZXYW5lLzFKbVRid0ZGOUxJSS92dkpHK3U3ZnN1UkZlTktM?=
 =?utf-8?B?TTJLV3hMeUZQTjVuRTgzbUVuNFZjeXc0UzVEa25iMWJsODJzTzhuR1NnME9r?=
 =?utf-8?B?Nkp5Vytmc2NKdmhuVHhHQUZSUExJT1c1M0dyVDJudGxIK2NvaDBYdEYzc3F0?=
 =?utf-8?B?cmZGcTNFUlF1UGlvbEMwNmtjKy9EdnJ2VktZblBFenNabitlZ1N2VGt5T2RL?=
 =?utf-8?B?OEo3UW40V0lRY1orNlhsTkFFV2o0MUxhcFZvTzJhUmVWbE5YYVQrZTVJelhn?=
 =?utf-8?B?Vnd3eFRHYlpjL1F4cXhqNTZuK1JLU0dTSDlsUHY2TVROdHZ6VXJPSGU2OTVq?=
 =?utf-8?B?Rk5yMU1ndGJkWElZNmpvY1RvK1VDVG05dnN1eHdpeXBhMllQamVaRUFFeXEz?=
 =?utf-8?B?TXlSSnB0dFRyNXJMQlVjdSt4Y2VHWk5SMVN4Q04zeDkvWGFtKzlPKzN3UGVL?=
 =?utf-8?B?cjFMK1Z1UTVqSWtodlZvUzRZVmZ1a1UzS0ltK21WZWpiMmVSQmFlalMxN3pX?=
 =?utf-8?B?TENKVllWMDNYQzNEeUhuVDJTOEpzc1Y2Umdjc2xUMzBjR2JsVFJLU2Jmbkp4?=
 =?utf-8?B?WjZGalJ1TkhILzRjYXBOUXdNVXFrU1FUbjVYa04wcFo0eHJreXFzMmxuTWZL?=
 =?utf-8?B?RXVXZ0hUTmptb2RFdnR2Q2M1TGpIZDN5aHJZOVZBRkg0QkdENzFDeW1xRW9i?=
 =?utf-8?B?R2FOa2E1SHpycHR5ZXkwZVo5djhlS3FDRlBUengrcUV6enJjRnpDejJmM20v?=
 =?utf-8?B?ajFTMWVFcVdzcVEveklPSXJjM1UrV1VpZHRVNzlORHRzQWRxcDR3TDNwZzZO?=
 =?utf-8?B?UE5vTzFybmIwOVYxMytDU0dsMmZQczZHWk9ycWM2VExKTlZrQVpFSTBSVlZC?=
 =?utf-8?B?MzVLd2NkWSs1ZGZWbXdENlhiMkhKRDFLZjNhcUhuVzVENlpydVNUVmtSNWxF?=
 =?utf-8?B?anlPWXh5bmpzY09rQmdlZVRKNzk3T0xiNXovaXlqVHNGZjRoLytWRVJHWG5O?=
 =?utf-8?B?dHBMaHNXMFVQQzdoUERhanFuQ0ZBd1dZVStKQWtoNGtoaHpWcDVuSW9nTjdw?=
 =?utf-8?B?OVg5MzFVUVhVUmpxblpUOWkrcDdnSlAyUWxKcTB3NzArY25JRktXUGp4N1Z3?=
 =?utf-8?B?bUdienQ5a2I5WlZqTmx5eWJEZVZSSkhaTWdxU0oxZC9Ra015cVFhNmdaeTM3?=
 =?utf-8?B?MjNNbmx5YjFPMWdEYjFCZS9oOGdFSWk4L1BScUVXTENoTmd3aHlYbEIzMEZJ?=
 =?utf-8?B?Z2pmNTNJZXp5OVdyNGNMUUdBSHFKUTlhUVlKUXVJN0lZSFFZY09mOEhmZVJM?=
 =?utf-8?B?S0NZZ2FCUlI3cys0Z3NZR25pUkhMcmxvUWphM2Z0aHljZW9Bekl3ZTlIaHlo?=
 =?utf-8?B?UmZmcldpaGcrb2ZYWnRkWFJrUVJ6RytucWxmOGROakllK0RucUpHOVdMZVZG?=
 =?utf-8?B?T1Fpc3BSMmpiMDV4cllscWhYU2xXcExDblNZbncyVUtscmx4UC94NkhmQmlt?=
 =?utf-8?B?WWgvSU5ETnVrdnE1cTVUWXkwa2o0cjdBRmg4OGpNV2hYdFBLOVZIamlIaVhP?=
 =?utf-8?B?N3FkKzMxVGpSOGhTTWJ0ekljRlZqT2VpUlF3K2RjMm1pa29RaU96MTFia3Ez?=
 =?utf-8?B?Zjh1b1Mvd21Vc0hyYlpwT1c1dE5tQVNHdXBXMHgyNHRDakQ2TXNYVDNiTXB6?=
 =?utf-8?Q?79pzkESUPD8GZors7wSLTnhS6GlDBIFFTjFUw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(366008)(1800799016)(38070700010);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N2VRMTZnZXdkZG43bjZiZEpmVDdCZUlLdm5wOUgyQWVVN1krUkgycEdpOTF3?=
 =?utf-8?B?bnpVWjR4YzdTamIyUUFZc3BqS1JkeFFVNHBxdWY4bEsrVjh1Y0F1TUJZQ1Vp?=
 =?utf-8?B?cVFhUndySnB6ZUdMOXBUNEc3a1Nkbjc5bEFMRk5oUUs1R0laUGR5TW9JbGdv?=
 =?utf-8?B?NHZoQVl5RUVGaUJ5b0RSendNRkVKektwWVh3QjNPaHJ2bXdFYVVKZEFzZE13?=
 =?utf-8?B?RGxFTVV4T1pDSDNoZ1B6N1VCMnU3c3BXTitSRkpkVms0KzlDKzVLeWgwcXFy?=
 =?utf-8?B?cTJEN29oejZ3VVBEVDdXdnRDQ2tRekRIUXJPRnJLMUE1d0gzMHg0bnd0REt2?=
 =?utf-8?B?RGRJNWhqVmt0L09qMVdmek14TUNWT0lSQXU1bDlPTWJ3T1RMMlZ6VlVWZi8r?=
 =?utf-8?B?TkF3enNmRjdyRjlWcWxGM1RndFF2MnRaQXJiOU9OZGZoY0lRVlhqY2s4T1d2?=
 =?utf-8?B?UDVhK1NTUXhEYmNZeitKRUhJbE80NU5jNXpobnBsbVdMcTM4NUJzb2V2ZHAx?=
 =?utf-8?B?dXgwK1hkWWtMTlVPVFhmMnVOblIrcUw2ZHVuT2psR3MzYmRKS2FIYXE3eTc0?=
 =?utf-8?B?VEVqckwxeDVQTGVZMlc2YU5hKytERGdjdDVjdjB4TW9mVTRkVTg0eGJuODE5?=
 =?utf-8?B?TmoreWsxc05pSGxYcEcvN296T2ZkbWxtTzBrNVQwM1JkUnUzcW90amNpcEJK?=
 =?utf-8?B?NlprSkZTc2pWdTFpMkUraDY1NjBZR3ozclZjZXh3RTFqVnFlV3JpbnFkdERr?=
 =?utf-8?B?SVQ3ZllMTHV4MFBjS1dvKzVLMUZKemlmZU9nMTl1RjNtVytaSXNpSTdqQmhP?=
 =?utf-8?B?RDY1NzF3UEViV3FLR0txNkN3dy82eFlkTS9PbWRHQk9SLzc3dHd4Y0M0SmU2?=
 =?utf-8?B?NW01Z1ozbDhzMXdXUlRpN3BRMlM2U1hudmh0d0tUWCs3N1hENkt5d0laSHpp?=
 =?utf-8?B?OGplcXAvVk5RNXBKV2VkeWR5eG0wMXk1cThLZ3JpLzYwS3l6SkFjcHhqcGtk?=
 =?utf-8?B?a2dCaVNxQ2hBWk1ISjlWNXV1UEw4aDlja1ZzZXNRWFpTV1ZVNGdySG9mdk1N?=
 =?utf-8?B?YldIVmdmYVgvRnZPVWZScTR0d1FocDY1alR6bW1LQ09zZWZBTEVxSVpNOURr?=
 =?utf-8?B?bjVXTDBHeUtCSG05LzN4cWJ0MzVZOEVKWlZLa3BnL2wyaGxPNDVLL2NybVBM?=
 =?utf-8?B?WEhPbWdnZUkrT0ZPWUFCdEFFb0Fac05Hbzl3MnBCZHRENUJya2J2K2dUcDBn?=
 =?utf-8?B?TDgva21ESlRNdmMrWWJiN2xiTzhzbFBoanlyTE1KbkIva0xZYnE3M1EvNngx?=
 =?utf-8?B?dXkrTmluZFc0Zm80YlMraXBsaEpUeFZNV0h0Q0ZmUUZaMTJzbjVIQWh0anVp?=
 =?utf-8?B?ZmszdHJhYWZhOFBETVdEb1RINVREaHR1aVAyMG9PdS9CeS8zck5nK29iQUNH?=
 =?utf-8?B?SDVYQnA2aTRxSGdadFhDdVMwSzMyeHN1Sjh4V2NTTFErV0VQbi9VMjFGN3BT?=
 =?utf-8?B?Sm8vSlVGV3BaUTlRaGpGTzdkMzNVdUdkUktXWEdvNGM2Wnc4VDRsQjY4aFZj?=
 =?utf-8?B?ZWNmYytyK1hqeVFxbXFDYm9IK2ZWOFhBbmJycVl4bmsrUDlSeSs2WVVHaFd3?=
 =?utf-8?B?RjBERmRpSmxpN1RVM0hZblYySmpSOWNTWTl5cmcrZFZleG1OLzBDQXgybWQr?=
 =?utf-8?B?Z0daYnpVNDFBNHhqU1E2aUZPZnhNNDN2cHJXdEN4eGRZbGNtUEdUbng3WlhJ?=
 =?utf-8?B?bGd2T2REUXF5akdkVG0rcWIxcUxoa3E2YU8rU3RZMGM2S0g2WWJscTJTMkRu?=
 =?utf-8?B?SzNQb251cTBsYnQzWUtvRGNIUDBOWnlaRGdvbDNWNkpLakZiMEJQWmQySzlE?=
 =?utf-8?B?SVlDK0svYXllczdRMlE3YmQwaGJrT3IvYVF5QkMzNEtoQ0pXMU5ZVHUzYjF0?=
 =?utf-8?B?bFIzYlV4bGNjUEsrc2JWZFBqcis5dFhQTGZvYmhsQktndVdZckNoS204SGY2?=
 =?utf-8?B?R2p2ejJHd0RIajNzb1JjbW5VeE5ZQlp0NEhqcjh0RXBTc0JtZWZ5RWYxbHRk?=
 =?utf-8?B?TEhraStKalk1NjZ2Q0xwT0RXcnhjQkk4Yit0a2x1NUhFSzg5dGFPUE9DQWpq?=
 =?utf-8?Q?bEaPhPf64/xAORsMciljacgWA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 348ef5f3-7e21-46dd-0831-08dc8a3ebd39
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2024 17:48:44.6584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HmCpP13CIOstdQ0ekR4f6c4DGvorpU8r0fdWknl/8CZEpRB4tibjHpeCb1XrAOvUvrS5OCz7VJicsFLctRDdAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8487
X-Outbound-SMTP-Client: 72.163.7.163, rcdn-opgw-2.cisco.com
X-Outbound-Node: alln-core-6.cisco.com

T24gVHVlc2RheSwgSnVuZSAxMSwgMjAyNCA2OjMyIEFNLCBIYW5uZXMgUmVpbmVja2UgPGhhcmVA
c3VzZS5kZT4gd3JvdGU6DQo+IEJldHRlciB1c2UgYSBiaXRtYXAgaGVyZTsgZmRsc19hbGxvY190
Z3Rfb3hpZCgpIGlzIG5vdCBhdG9taWMsIGFuZCB3aWxsDQo+IG5lZWQgdG8gYmUgbG9ja2VkIHRv
IGF2b2lkIHJhY2VzLg0KDQpUaGFua3MgZm9yIHlvdXIgcmV2aWV3IGNvbW1lbnRzIHNvIGZhciBI
YW5uZXMuIEFwcHJlY2lhdGUgeW91IHRha2luZyB0aGUgdGltZS4NCkknbGwgYWRkcmVzcyB0aGVt
IGluIHRoZSBuZXh0IHZlcnNpb24uDQoNClJlZ2FyZHMsDQpLYXJhbg0K
