Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9546B3FBB4D;
	Fri,  7 Aug 2026 10:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786096931; cv=fail; b=deMazAIDqHJpMGYiKFsqEbD6Qs4ixJPiteEKu3cN7D79jD7FAYiQ/eZ80PHAN3NlSB+ULW7dvQav0NqP3oGUFfHBEXCzOfBoI8lK4Xbfc801OVWdPD/GThuT85DF4TTMosfzhrERXPIYQbFtiQu1kXQZHsI65J8OZttvzS8kaig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786096931; c=relaxed/simple;
	bh=a6ZfS0vLcv3EtY4j15ETZNllvXubBavBUCxcZemulUI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ai8/hwtYUo8ACLtH8U3hCWZDfVxfK+Cvsb7Wm1l4PuZ1GQl6eOqF+wyys0/sz8iilVAFASQYGK6xgZYAxWWtpGXUoWWCaxEPT3nLB5ry9X35PKWP+jiaicLYE786nKZDINk8LVziEe5G4JLPj7pQIBb8zDKuIQ8+FqiSGiP3DKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jRrchuw+; arc=fail smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jRrchuw+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1323; q=dns/txt;
  s=iport01; t=1786096929; x=1787306529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YPi6LTudSqNHj0pPM/wQTemH5jsY13HmAYf6wKcsNfQ=;
  b=jRrchuw+/vZECQDwUKEg/t1rOKm3TVtqql2Tz6FNtp/UQeYacZmtS0Ce
   wSuSldB+mUgOMfwWJVgGIZ06S59ks7WFIKo6mGUJIeFxC01FJ8qLno6DM
   dxjtzu4LJYy7rqxpimHjOPEJpo8x12T/2seyQHkgNS533ntSNHRNgRcDs
   CimH1awD8Ex90cItSSGpPaByYC9M96QjrzDHZ3JumwRH2T4yrndVJ7wfh
   Zp6XuF+zPwJhPNEmzAqwUm90m4IZuku0fsXK0CexKRpBufN1khab26OkE
   FxGEivJ1oiWJYSnmnWs3hwfiqTaAhVahkYdO/tkxgGWrZpnpyaExj5aCH
   A==;
X-CSE-ConnectionGUID: L37hxo4ZT7e8Fn1tBtdVIw==
X-CSE-MsgGUID: o1RQhD9PSDqyLYgBz5srZg==
X-IPAS-Result: =?us-ascii?q?A0BoAwA+rHVq/5QQJK1aHgEBCxIMZYEgC4FuU4IrSYgjA?=
 =?us-ascii?q?4UrhliCIQOLZJI3gX4PAQEBDQJRBAEBhQUCjWYCJjQJDgECBAMCAwEBAQEBA?=
 =?us-ascii?q?QEBAQEBCwEBBQEBAQIBBwWBDhOGXIZaAQEBAQMnEz8QAgEIGB4QIBElAgQBD?=
 =?us-ascii?q?QUIhTUDNwMBArQ9AooceIEBMxRt3UYNgmQUAYE4iD0gAYp0JxuCDYFXgmk+g?=
 =?us-ascii?q?h+BazuEE4IwBIIigQySeVJ4HANZLAFVExcLBwWBI0MDKi8tI0sFLR2BIyEdF?=
 =?us-ascii?q?xceWBsHBRIgKkFEIwM+HUMFgU0CgXQ/Ixk2fIEJXoEtKmQBAhAXRi4VgmECg?=
 =?us-ascii?q?neBNQULbT03FBkDBIE1BY1+IYJGAT0+ExwnboEEC5Z7rzFxCoQdm1+GMheqb?=
 =?us-ascii?q?JkII5FwlwUCBAIEBQIQAQEGgWg8gVlwFYMiUxkP3jx5AjsCBwIHDgMLkWiBf?=
 =?us-ascii?q?gEB?=
IronPort-PHdr: A9a23:TG89gxE0f6SoGlZleEIaCJ1GfhMY04WdBeZdwpMjj7QLdbys4NG7e
 kfe/v5qylTOWNaT5/FFjr/Ourv7ESwb4JmHuWwfapEESRIfiMsXkgBhSM6IAEH2NrjrOgQxH
 d9JUxlu+HTTDA==
IronPort-Data: A9a23:R/xDZaLl1h64wkcuFE+RuZQlxSXFcZb7ZxGr2PjKsXjdYENSgzAGn
 2UdXj+AMquOYjP9eN0nPoW2908BupfQxt42TAAd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnQ0
 T/Oi5eHYgH9i2Yrajt8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1KVx42LYpEyNooDDFg8
 6UEAiwBUDGc0rfeLLKTEoGAh+wqKM3teYdasXZ6wHSAVLAtQIvIROPB4towMDUY358VW62AI
 ZNHL2MzPHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQhiOGwa4WOJYDiqcN9mR+in
 2LqrlzCLggLEO2Q4yjY6Wieibqa9c/8cMdIfFGizdZugVuO1ikQBQcQWF+Tv/a0kAi9VshZJ
 khS/TAhxYA29Uq2XpzmVAa5iGCLswRaWNdKFeA+rgaXxcLpDx2xD2wASHtFLdchrsJzHGVs3
 V6SlNSvDjtq2FGIdU+gGn6vhWraEQAeLHQJYmkPSg5t3jUpiNxbYs7nJjq7LJOIsw==
IronPort-HdrOrdr: A9a23:kb/evK1spLOouK6J0Qi+KAqjBb1xeYIsimQD101hICG9Lfbo9P
 xGzc566farslcssSkb6K690cm7LU819fZOkO8s1MSZLXjbUQyTXc5fBOrZsnHd8kLFh5RgPM
 tbAsxD4ZjLfCdHZKXBkUeF+rQbsaS6GcmT7I+0oQYOPGRXguNbnntE422gYzRLrXx9dOEE/e
 2nl7J6TlSbCBMqR/X+LEMoG8LEoNrGno/nZxkpOz4LgTPlsRqYrJTBP1y9xBkxbxNjqI1OzU
 H11yDp7KSqtP+2jiTby3LS6Jpunt7gwMtoBcCHiMQZQw+cyzpAYr4PZ5Sy+BQO5M2/4lcjl9
 fB5z06Od5o1n/Xdmap5TPwxgjJyl8Vmjzf4G7dpUGmjd3yRTo8BcYEr5leaAHl500pu8w5+L
 5X3lieq4FcAXr77WbADpnzJlRXf3iP0D0feN0o/jpiuEwlGeZsRLkkjQdo+VE7bXrHAc4cYb
 JT5YrnlYZrmBuhHgPkVy9UsZyRd0V2OAuaSU4fvcHQ+T1XkHdli3Y8/qUk7y09HFZXcegZ2w
 wCWZ4YyY1mX4sYa7lwC/wGRtbyAmvRQQjUOGbXOlj/ErobUki94KIfzY9Frd1CQqZ4hKcaid
 DEShdVpGQyc0XhBYmH24BK6AnERCG4US72ws9T6pBlsvmkLYCbfBGrWRQriY+tsv8fCsrUV7
 K6P49XGebqKS/rFZxS1wPzVpFOIT0VUdETuNw8R1WSy/i7YLHCp6jearLeNbDtGTErVif2BW
 YCRiH6IIFa4kWiShbD8W7ssrPWCzvCFL5LYdznFrIoufow36V3w30otWg=
X-Talos-CUID: 9a23:8mN2HGxI0baS/jCzNN96BgUwQZ8lYnqB/kuPLh+WDz91YqGZd36PrfY=
X-Talos-MUID: 9a23:2u5g8gYF5wC37uBTsGbWvTFOZf9Tz72/LHECu4dboNO2Onkl
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-11.cisco.com ([173.36.16.148])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 07 Aug 2026 10:02:02 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-11.cisco.com (Postfix) with ESMTPS id AA5EE18000386;
	Fri,  7 Aug 2026 10:02:02 +0000 (GMT)
X-CSE-ConnectionGUID: pupjpFMoQOGIkWjJ6rksXw==
X-CSE-MsgGUID: cRGpQhq4Qw2tdjCAkCrnBg==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.25,210,1779148800"; 
   d="scan'208";a="82796149"
Received: from mail-westus3azon11012003.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.3])
  by alln-opgw-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 07 Aug 2026 10:02:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iy4n6Akiygl50JVEQQqq0LZ46LzObXLqMvhlqC/BieEiv7Yuzyx2GWhihT2zPF2cxVJAeUjK992nvsIM+r+VRCV8/oqTgCkCRmaXlPKQDzkrBv56uuoTaCnfSzwAQDuhAxh6aVrKBb2MD43sKQQLT/OBF4MP8wTkOYohJgj/Xht80HiTpcFLyl32fak8yuvr+cqxj8hQNQeTzghL1k/D/0fBqdiat/6E440BSJJscLD874IPjplBG7FGxZvQFxEyGHYsy0B8Y7c8jFwFvfYXHHq4BHMb1DIBAIGrxk7a0SFCDtTlCaw7qn7RhGvVL8r9ib9iCA1ZW+QCecjv11guHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPi6LTudSqNHj0pPM/wQTemH5jsY13HmAYf6wKcsNfQ=;
 b=DNvP8tSy4hRWAroJcWq07MHY1rvCytwQD8vfkXx2Bw4LSgkcymfCLWchw7gk5I2clepOlfN5eOBgOEqRXBCK7tpfC7z5oK8P8B2eJ6MnL/0od0PkRHg9xSI6d67OuMakMIcOMMTRdbFZzXgKmTtXNEDdEg8wc4JmzC0en3/UJOvlm10jITSAwFxe5zLViehvMoSKxdkVYYeXEm9SzQUn3QIPBoHfPee2DXDCGqsV+LHo7s/X1KqIHRSgcOJ3MS906qxQlTtkci7M72sN8MREgKFxRVLGTEOwJtiE27D5hymhY7fdxCmkewoQQulw5hap3zFhUspJIYHY+5uiomPICw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SA1PR11MB6662.namprd11.prod.outlook.com (2603:10b6:806:256::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 7 Aug
 2026 10:01:59 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%6]) with mapi id 15.21.0292.013; Fri, 7 Aug 2026
 10:01:59 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Roman Demidov <roman.demidov.nn@gmail.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "lvc-project@linuxtesting.org"
	<lvc-project@linuxtesting.org>
Subject: RE: [PATCH] scsi: fnic: Fix invalid comparison for error
Thread-Topic: [PATCH] scsi: fnic: Fix invalid comparison for error
Thread-Index: AQHdJk3Vobc0uOVneEWU/bSp4FEAPbaSVExg
Date: Fri, 7 Aug 2026 10:01:59 +0000
Message-ID:
 <SJ0PR11MB58967244C1A1AA8F49E621BEC3D12@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260807091852.13151-1-roman.demidov.nn@gmail.com>
In-Reply-To: <20260807091852.13151-1-roman.demidov.nn@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SA1PR11MB6662:EE_
x-ms-office365-filtering-correlation-id: 39505b0c-7ff9-4749-7334-08def46aebc7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 P5TNbNkZ5oF7zXUhBb7jfmIdECDHwXuV08sbLUmdJYmGv59FwU9obFVoVnGIFMaklhsJQqhyfkdKg/ZG6ocBRFhom7ZIEEgzWU7Dn9q/8jgNvJtRZ3nORTFC90xBm9RR6OPSEgV4SDMg71d4sme6/8Rnlu0Ubv+08fpG64fUUfAlYCNGWBZ3Ho/gRfwN2LslNREi2U4sCFGmVBQVZ+qAmQiYpW5rd1IOAN8nxbzrkTyfF2mirxS7IvjX0wRwBOg8K+anR/J5DM73JnYXfy7F7btw8CgpZgYAfsyEDLh0l+dPvhYozC5q7nOVc/wki8QhWzjUrsvj9slJ8WBrY5vcaLh1X0oTXhBYPrIwKOZ5mdiikFyDFjzvVkh7r6isATyCyRh0ggAtji7YFjbtU90wgSZgWVkNysv8CHRz4jVd/WIwbREc6z886Iyl832L0SoZGB3nmlb2XHLyuuvKVTztrcE94yfrIrbyvoPrLvGfHa+h8a5iKgGtgPNhmgsCxXAVN25/hlxHcTmpjY31XhffSVcZcHRYBv9BtzC0PQmN42ing9sGXKUppQDNXsKIASWWnhtFlCoiSyv0mruQvGhm/Xmx6N83gX0bReYTQM9Wbfpr5VLur+9r7tQ4PK9vnV2UcLQZCd7lLfo8WLXQ+bwdzMKSEo04KjtBp2WAogrtI0Gkb1OI4UiPQSMtvUa2BEyegqoB+VzvVPN89TJfsbpl/SGbtZ70h6NrssHmWYgW72U=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Nw59GUyA6A1qEjgozZVblhK3HNqT/aLOWRlBhKdtW9jcP4SIIBzfW3z5NP0j?=
 =?us-ascii?Q?mfQcOOHTuerbRP+g+jfqLufHsYQ+Ak6cwnD3xN0FROKufW5tqg41zq4dUOba?=
 =?us-ascii?Q?hRhLKQMhhIhZPABsk0oCE+MpQVSm8f/3fTRJdmLCXFyZEBZRlKlA0bN2ZXhh?=
 =?us-ascii?Q?woVMv/r04hYb8Cdek8Cx6MS60g+XbydyQBQa4YHLJyQzd0AUL7OOSXf8q3yA?=
 =?us-ascii?Q?06wVs1dF7Jwcuk7Yrhj7ta8NFX/RFpbGfbAYu0faTB9lhR7HTYISR2Q3mp2q?=
 =?us-ascii?Q?jIbQ3ukwRjUsqkIdu0fx2tdq0Y5Mtc2BOLxs7nhPcDkmUVcYc7Vy4sR0Tltr?=
 =?us-ascii?Q?AY0+CFY+tU4rVZyzHnIaFJ91V68wRWCUI275aUjH44bZ5I3EprThZ3jaJrrL?=
 =?us-ascii?Q?dX6sUFBGoy52dAEjMmNK63dAQGwPmat7Fmh4ihzKENCB/IBHS6+ETQwq5Kxz?=
 =?us-ascii?Q?dEskiaC6OJdAUMZen2ObtPiY6kurP0gtYO8dPM1uKtT4CdasfAnrci7+KMru?=
 =?us-ascii?Q?U/SqJUmon4qJQeyr9vmwggKDr5UlCVTyXTT24vzpxl4FD+gGNBih1fhqoXqv?=
 =?us-ascii?Q?lQkoJSUdWd4iQgHh6XwdFEwXJi8gmvhbqxLH981Fz9x1oUf3KavG0iRYgzws?=
 =?us-ascii?Q?OUYRVBXx059t5m2j7ANZ1NdQ6HwAHwytm0NC3Y6qelPYNubQY1uniXLoCNBK?=
 =?us-ascii?Q?ZsQDpBPc9gfoBvTRTCK3Uq6QOHUqeiJLdz2EXJPQ1436uL/j1HUkhwvFYp5P?=
 =?us-ascii?Q?jjOI0ChCm53UpC3MW9tna+K5tiOprdD0RKoMuQ9R4tPUVzo/iAi4HRwBHi84?=
 =?us-ascii?Q?9X+kpwGHKxdc1druo1sCzSYkkF8PtDIEIBIDcvCyXB/3kAQaU7vBRpEwUjfA?=
 =?us-ascii?Q?kdqz4uawI4swEmvzNbm9DjFBsEysA0KiVloWHy5ryLWKAMp6TyGtysy3fpnc?=
 =?us-ascii?Q?ljhlWXdT+QFUjWxxrhbhNe8bES9RJcKEpB31QQCXX1gOEXdGPwODgEkqMFHk?=
 =?us-ascii?Q?ti+VL9yrUwnug5Yqonxwgc7YiMX4Tz+nOK0OnnfZoCUy5l4LUg7f9GWbmJb4?=
 =?us-ascii?Q?d2KDCt1e7Zv92w+XrhPwT+LsvOMTvuKVddQAqqi5dtniZ5rwcIG/l1lR0lW3?=
 =?us-ascii?Q?a7AOP6byDDwbrfIQzAWvGz0VBFaMHWRwG2tl/3+udjxPcnkM9UgG7gv4PFib?=
 =?us-ascii?Q?bbws+2oI9jtx7qji1mGPY7tjyyoJYw4KNgltR/BYtPcSATVv+jkwrFUY89gs?=
 =?us-ascii?Q?u5D3w+LHQ+77K4G5r96Dm6Yz/WqRDZJWGWBE3Z/uwg5nrHl2EYz2h+GIARLw?=
 =?us-ascii?Q?iXd5pRCOJlr8o3sQXqOn+6eo4OtXC/+2vFpDMi3GJpuhmQbbb1FWW2xvHJNz?=
 =?us-ascii?Q?v1deDrTzsJPahSVPUuhYNOQwUn3V5v8bEYgmHD+CwJ+1goqlydLS88tcDZzQ?=
 =?us-ascii?Q?4psEBt/uZhfxucgEtks6cdNHtNleV87sS4UklHY85OfedNugexr1LLW9n5dZ?=
 =?us-ascii?Q?4xbSYVs+9iQ5TfRZtyWy4iZp47603jLc4O+jvdtgZkFy/e3dPsVMlU3A8qfP?=
 =?us-ascii?Q?QInx9MqBEwnreLjd7dtr52fKQIod1dxt/lNI0IYR6el8IzFRpW66bhfLGgEM?=
 =?us-ascii?Q?554e225J4oionbZM5+CReMo5ygVOHJ0EojIh/Rxmnv342IElX1uA9Z5YyhAa?=
 =?us-ascii?Q?U9+43y5GFKR76XM2nHcs67Cyys0t9fzxyKqfdr4Hp+c2wLVG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ANRWosHGsnGut/sTPUqTQYrgq0FYirsFJcvY8KTVZ/dkOt4i7PyWUxZZ+K8It8/UQ39yGr3FVIGmyaUNUbwnzpYa1izf/zR5xd4BEV8SrzDz8+nufxP9x1UI04BQs0//8Nz/5Qg9e6CqBPWOYqhYeyN+M6xVwTkai3pCYOse/hHYgSXsUtoLmABSyu6xz5dwoTYVA1DWTQ285vTjnZabxJJ7JF1V2eJeanVfk/eAjT7fJE4f6THG0s3zhHGwJT5eVAUocY397QoEdoDWsczhf1slCnrHXRCRBi3o9Dv1aEk+rtb8fuvk3ie9WUBXYv3i2i8YdzFUSnVZt8Pmy1YzHQ==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39505b0c-7ff9-4749-7334-08def46aebc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2026 10:01:59.2026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ongDv2yu0MTUnH68md85EML5WJi04umKzEhnWH5zBawYkLNZqL2NQ3F4Z9bRwznLUgW8z3HelPnF9Is8SFeosg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6662
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-1.cisco.com [173.37.147.229];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: alln-l-core-11.cisco.com

On Friday, August 7, 2026 2:49 PM, Roman Demidov <roman.demidov.nn@gmail.co=
m> wrote:
>
> The current comparison err !=3D ERR_ECMDUNKNOWN is useless because err < =
0
> and ERR_ECMDUNKNOWN =3D=3D 5. The logic is that if the CMD_CAPABILITY
> command was executed, there is no need to respond to unknown errors.
> Therefore, the sign of the number in the comparison must be changed.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
> ---
> drivers/scsi/fnic/vnic_dev.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
> index 991c86eb5aff..0e5ae0540d85 100644
> --- a/drivers/scsi/fnic/vnic_dev.c
> +++ b/drivers/scsi/fnic/vnic_dev.c
> @@ -381,7 +381,7 @@ static int vnic_dev_cmd2(struct vnic_dev *vdev, enum =
vnic_devcmd_cmd cmd,
> if (result->color =3D=3D color) {
> if (result->error) {
> err =3D -(int) result->error;
> -                             if (err !=3D ERR_ECMDUNKNOWN ||
> +                             if (err !=3D -ERR_ECMDUNKNOWN ||
> cmd !=3D CMD_CAPABILITY)
> pr_err("%s:Error %d devcmd %d\n",
> pci_name(vdev->pdev),
> --
> 2.53.0
>
>

Thanks for this change, Roman. It looks good.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
