Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB56A224D4;
	Wed, 15 Jan 2025 01:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736903020; cv=fail; b=HvSeNkOpYU6COv+KYCXuo0m1KN/T5M0UMtUjpqLtr9M3T7jdBNYjK6MKvlp/UO75QZkspuNTO0s4/x03iGJ27sl1ZTDxCI40DV6AL8tOiVtgo126afZwRPS9yjrulKB0X09l6PraErau0kjvSSYbMGB0IIRQuuKyOOzgdCKnIPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736903020; c=relaxed/simple;
	bh=YRWvNL/T0vFW4l9phNFsK1Oz3DG2CLmIS6KwB0UUl0Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c+NrAeR22f0+GzemwqhWN5sIdHd5lNSlRFMjmKklptlrdO25YQoBR++tKw0VvkOuJZX3oJCdPjtOGGXVPEZzZ6MDkz6Mq1bDSAOwVUXkfkbWU5dkJEli1FTGG9qaT10GYMdouM4Tk0x/31t0Q92RlLjCfJE/eoQQ0PznMPbtSpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=W8gOqgMJ; arc=fail smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="W8gOqgMJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2320; q=dns/txt; s=iport;
  t=1736903019; x=1738112619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YRWvNL/T0vFW4l9phNFsK1Oz3DG2CLmIS6KwB0UUl0Y=;
  b=W8gOqgMJFlKFCCKLBB1ctXMUvURLn/7TbZQSXvtS6y2egUFSK2Z8GNE5
   L9gM0b70TKz3fLOrjvvLsajODY1R5rfHBIiYwGwV2zcjbTeqw/sOrOnVl
   BUyrDmkTziEAPOYMyhD3NPFfKthGZwJ5qJ67ADN9heJgZ/ZSbiWDxyGQq
   4=;
X-CSE-ConnectionGUID: 7+TGZ1E2S5yG2y+L/bDHbQ==
X-CSE-MsgGUID: grfL93cjTTe6pAkuEaDfGA==
X-IPAS-Result: =?us-ascii?q?A0AGAACHCIdn/4sQJK1aGQEBAQEBAQEBAQEBAQEBAQEBA?=
 =?us-ascii?q?RIBAQEBAQEBAQEBAQFAJYEaBAEBAQEBCwGBcVIHghJIhFWDTAOETl+GUYIhA?=
 =?us-ascii?q?54YgX4PAQEBDQJEBAEBhQcCFopdAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBA?=
 =?us-ascii?q?QELAQEFAQEBAgEHBYEOE4YIhloBAQEBAxIREUUQAgEIDgoCAiYCAgIvFRACB?=
 =?us-ascii?q?AENBQgahUQDAacwAYFAAooreoEygQHgIIEaLgGITQGBbIN/O4Q8JxuCDYEVQ?=
 =?us-ascii?q?oI3MT6EGiuDWTqCLwSCM4FzgVaBA2eGZocckHkJSXscA1ksAVUTFwsHBWVFS?=
 =?us-ascii?q?AMtNjElgScFNQo3OoIMaUk3Ag0CNYIefIIrgiGCO4RHYC8DAwMDgzqFYoIUg?=
 =?us-ascii?q?WUDAxYRgyhyHUADC209NxQbBQQ6ewWbLjyDEC0uBj6BHy1RPjUqlkpJrzcKh?=
 =?us-ascii?q?BuhfBeEBKZPmHwigjamKwIEAgQFAg8BAQaBZzyBWXAVgyJSGQ/SFXg8AgcLA?=
 =?us-ascii?q?QEDCY9WgX0BAQ?=
IronPort-PHdr: A9a23:cx1xfhAPyZESciEPl9q9UyQVXRdPi9zP1kY98JErjfdJaqu8usmkN
 03E7vIrh1jMDs3X6PNB3vLfqLuoGXcB7pCIrG0YfdRSWgUEh8Qbk01oAMOMBUDhav+/Ryc7B
 89FElRi+hmG
IronPort-Data: A9a23:xNcXNK7YoIGb5HKcT3JWygxRtFDGchMFZxGqfqrLsTDasY5as4F+v
 mAeCGmEMvbZa2fwLtglPYjnpxtSsZOHydZqHVBl+ys3Zn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH1dOC89RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr+aUzBHf/g2QpajtNt/rYwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eYs4k1dQuLDt1q
 O03ciFOSleJq8K8+efuIgVsrpxLwMjDNYcbvDRkiDreF/tjGcqFSKTR7tge1zA17ixMNa+BP
 IxCN3w2MlKZOEwn1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3Fa4KLI4LRHJUK9qqej
 m3c8UCoWRoYCOCSlyKs8W+Bj8PBsgquDer+E5X9rJaGmma7wm0VFQ1TVlahp/S9olCxVsgZK
 EEO/Ccq668o+ySDStj7Qg39u3WfvzYCVNdKVe438geAzuzT+QnxO4QfZjdFbNpjsIo9QiYnk
 wfT2djoHjdo9raSTBpx64upkN97AgBMRUcqbi4fRgxD6N7myLzfRDqWJjq/OMZZVuHIJAw=
IronPort-HdrOrdr: A9a23:54msxqH5Jh//Wg9npLqFp5LXdLJyesId70hD6qkvc203TiXIra
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
X-Talos-CUID: =?us-ascii?q?9a23=3AueXitGlhRozRb+R8dM/KiYWAAyDXOSKe8FjiemL?=
 =?us-ascii?q?iMjt4Z+eECnvX8o9EmfM7zg=3D=3D?=
X-Talos-MUID: 9a23:n1p0hAXbK9KXtZfq/DD2ihUzb8xq35ijVlgkkogrsuWKGgUlbg==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Jan 2025 01:03:31 +0000
Received: from rcdn-opgw-5.cisco.com (rcdn-opgw-5.cisco.com [72.163.7.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPS id 8479B18000151;
	Wed, 15 Jan 2025 01:03:31 +0000 (GMT)
X-CSE-ConnectionGUID: Y9G6YonTQQaOqfu1h2B6Jg==
X-CSE-MsgGUID: asj+ZmEQS6u4b+cpJprX4A==
Authentication-Results: rcdn-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,315,1728950400"; 
   d="scan'208";a="21334205"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by rcdn-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Jan 2025 01:03:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tfA9KjRdh3cxyNL4Ef3HUsauXju/K5Gxp6fJrKpN7L4ilW+4tcj4riHVOToNlklzRm2cu/f+bfyF5pY0Xk4kqOMDCf6NSbx6EKW5jN0huTSR3YPpguTu0EUurNRb7IGo0/bXP+NjnFZyUdl38Y/22s29xLwGn78wpHHKJM9fOdgViDMniqfcw24BPclL/ZLBq900ODq1F/3l4O41PUwALIU4P08CEHTt4UzPebQwNUg5nnXFib8WxnhfDxt+iOFXLWsQb49WMT+pNGJS4AXlmpiew2ZthEvhqq7g2GUuJX3uOyt8FNje30uyiilBg09M9jnHcPkQiluWqlArnCey9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRWvNL/T0vFW4l9phNFsK1Oz3DG2CLmIS6KwB0UUl0Y=;
 b=vwDpB1wfJNM3+BcEZaskYKHv64bU9d9DICeE8hexsKyeEuPLqxFm6n0piNCK+EKyYHViRDpskG/+bAers04r69fYNExkZuguhGNAfRiraAzlPQklgyYpvTma46f3eY6mjndh2ebSm/TPdbcYrpO7XtTKLd2P4yur2M89RK7rPn4JUArOWslOOARBLO3V2Dgm7XDCip7q/o1i8PnaN0ddKJJAcC45u2ckDZqKmvngiKeEnsjf5ZiK4FrgeSyaYu+8P9cxvC7C7+uqWqiKKXFa/sh30CTqR5dgnnXf4pza54IOyZKZc8LaBxVRGCRwGZmkhvJDcW+4L4MQ2fWTKI0dUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by IA0PR11MB7814.namprd11.prod.outlook.com (2603:10b6:208:408::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 01:03:27 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8335.015; Wed, 15 Jan 2025
 01:03:27 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: John Meneghini <jmeneghi@redhat.com>, Dan Carpenter
	<dan.carpenter@linaro.org>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy
 (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar (djhawar)"
	<djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: RE: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Thread-Topic: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Thread-Index: AQHbTDq6HSN+iJUXdEijLsA+yRSpm7MLZ02AgAnDMYCAARMRgIAAWDEAgACiJPA=
Date: Wed, 15 Jan 2025 01:03:27 +0000
Message-ID:
 <SJ0PR11MB5896722C05C2573D26DB26B4C3192@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-8-kartilak@cisco.com>
 <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
 <d18ed046-0d16-49d6-b666-8ef8ee20f6d2@redhat.com>
 <b3c29afc-c49b-42af-9733-7cf2b934cd90@stanley.mountain>
 <dfa5c473-ef65-4065-b64a-6bcd213a26bc@redhat.com>
In-Reply-To: <dfa5c473-ef65-4065-b64a-6bcd213a26bc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|IA0PR11MB7814:EE_
x-ms-office365-filtering-correlation-id: 7c8bda13-2957-4a51-3e83-08dd35006b89
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VDc3Uzd6Q2gzNEMxZWp6M0FaVFYvZzEyQkE4QzlvTHdBRXRNSEhvNVFPU0Jn?=
 =?utf-8?B?eDlqK0ZXSUhHbVNzTHpvUmhuYkoyWlFNWU1zeTZWNi9Rb1h6RmRCZ1YyaS8y?=
 =?utf-8?B?TElnaU9meUJLVHMzbDhobnJZTFZTTHlnSU1MYVA1YzZVMktkTlB1OHZUeWtn?=
 =?utf-8?B?cGlQdjNNUU9XbzVFMVZjbFpvR0hNWW5HMXhRczI5MXlTWmdkWWdhRVlyVlRP?=
 =?utf-8?B?UVpMVUZDYXNGcjRqYU91RXc5ZmdtRWRobzh1WUpOeXVLZmRMUVZMM1llK1dZ?=
 =?utf-8?B?eUJMeDFiSzhQczdjZ1E5b0FWZUtxKzhvbWpyTnZQRnF4b09kWngvcnFZQSs1?=
 =?utf-8?B?NXZRY2ZuZy8zOEF0U2k5YkJ0TVp2b0Q5dUg3VHE0cmgzMmlRSGtzZGpzL0xJ?=
 =?utf-8?B?LzJMU2ZUS0dPZzRyMjlsSmdvYVZZSlVQT2FVYlAyZzdMYk1aakRVamNFQTYv?=
 =?utf-8?B?dnRxbyttVVV4SG9WUUc2NnF6NmdDUm54OGlrZ2kxMzBBMTRLV1pyMGJaenBm?=
 =?utf-8?B?ZnNQS29BcEY0TTcxQUpyRVI0SU0xcHRvMHduOUlpZFZ2TFlHdGw0QU1UUkN4?=
 =?utf-8?B?T0FBMGxLTG1CUHJLblRvMUhKSVlVSHl4UUlEY2dHTXQ5MDFldWh3VzZOaVVx?=
 =?utf-8?B?dlo5SDF1UzhIL1RDREFWWEk3R2QwSWFENUROV2MzMlhVUW5oaWdTemxWTndl?=
 =?utf-8?B?clpJU205WGhkVXc2dDFyUUZsSzJYeXVDUmRFTUVrWVg2cDBMSXNrWE5KZTEr?=
 =?utf-8?B?ektlQjlMVXFNYUxxeGp3N2x4cTloeUYxOHNla3hQSWJGbXkySzkwZzcrRlVV?=
 =?utf-8?B?STArcHRET2hVdG00aTJ1WjBHYUlLV1drWkdXSTVKdzZxY3dvT1kxRjhGN2VE?=
 =?utf-8?B?VjhzYTUxbDZqVXBYV2JCaWlxM3Vham05clZNYWUxcitucTludHYxejhjb01S?=
 =?utf-8?B?NEVUUGlFS1d6YWdGYUlTL1BmdkU3NE5NTWdDa3kxUFlWWHlQSW5BczU1MGEw?=
 =?utf-8?B?RzM4cTBZdWVDdExRLzRGaU95V0ZCYi9CRUNBbS85Sk45MW5ycGRjYi9wYk83?=
 =?utf-8?B?TGcxRldkTElHVzVMSUpZeFNZaUI0RG9tT0ZyV2psejg0bHlvT2VKYWtlaWdN?=
 =?utf-8?B?aDRVUWpiaThIendiU2ZzL3loeXZzalZ5ZHNodlRJOUwyTklKWGgveUk0WTlR?=
 =?utf-8?B?aUVwS1NCc2JMb1JIYTJBWXlITnpKSTJIb1JTQ2ptalhzOHVxalpRNklWd3Z1?=
 =?utf-8?B?T0dLaUlWbncwZU9ySVNGUVA2NXdpdi9Jd3QxblNNeTl5T1ppbWhCNzYwZjNK?=
 =?utf-8?B?SUJrYS9wQXY4UVV1bi93K1VxN0gvKzluM1hYWFdpcGZBM2lZQXNTS3dJR3pF?=
 =?utf-8?B?NERlOUdLN1BLWXZuZGNrV3ExdVo0dTcwaUljdHRoZ3VmOTJTUDZ1RGNNcndL?=
 =?utf-8?B?Tlk0TEg4UlV3eWNGdndidDg5ZDUzYmJtWiszQm90WFBVZDduZmdQbmRTWVhP?=
 =?utf-8?B?WTR2aDZyZEtxQzUyekQwQXlyVVNCRmNxNzZXVExQWW13K0w2Q3Q4TGdJRHFO?=
 =?utf-8?B?TkloajdVRnJyVnVVVHhPb1NCUm9YRmFqUkY3M3FrTlY0d004NjhaSGVoZklx?=
 =?utf-8?B?cDRZNlVzdndMVEhmZXBYa0hOS1lCWkFFVU5SRFdIdUdHQWlWd29hVmNhUFRI?=
 =?utf-8?B?R3A4UTdGem95Rlg2bEJvTlBNeE9JaW9YUWxqcUpSSUNndHdQeDdWQ0hPd1ZO?=
 =?utf-8?B?b01BbkhqSG1DSjJCbjBzWDdpNHpKZ2pxTUQ0eU44akZ2VzNoUFVGUVJmKy9P?=
 =?utf-8?B?V0djRDlnZklLNXdEaG1UbFM2ci9KM3krSHRjbjFsbFh3ZllkK01jZHQ3Skgz?=
 =?utf-8?B?UGtxSUdmdHJVSTBPelRmSGxtOWpiWDRoVEY0Sld2YzhxelVzZTNCKys5NlNy?=
 =?utf-8?Q?+e5pTfVfH2eB3qU4//eWmi5m7wbrB+Mx?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eU5RMmtBYURFa080NWRtWnRjWUd4OENZQWgrT0pkRkFYRDhwNnZvRWFWSXlm?=
 =?utf-8?B?K1BjZW5mVVRLa2ZCTUc0UGJINnRHd1lZbW5oUmZXNGtYYjJZbElZKzB6Q0Yw?=
 =?utf-8?B?bkE1ckdhZ3M4STM3RmN3WktBb0FwQU5uaHkyVWVRKzQ4TWJDc2dQMUxyMTN3?=
 =?utf-8?B?UEdOT0hBRWVkRTliVHErejYwMVNLcDgrdFhxOHZxOGZhbWdkNXpaY3VUd2Ew?=
 =?utf-8?B?UWtJU2hsL0EvZXJ4NTdkU1FKeDNQRmNId2hkS3BXMUtFSmg5YUNaSEpLamNC?=
 =?utf-8?B?aDVFSGJxRFY3YWRvNlJrWUJvSk9zUEhtVE4yMm9Sa3oyZldwcmxiajROS3Bx?=
 =?utf-8?B?L2NZRlBFSWk2WW5mK3UyTU5WR0lWYVg1cFV6YWdoOXEwK2p2Wk9vb1N2VjNM?=
 =?utf-8?B?bzV3dy81RmV5a2RjeEZqUnVrZWc4QkhTRkF2QWtUVFlxbmNTeWFNWGQvQUkz?=
 =?utf-8?B?eWJlVmM3akJjS1Y3ZnpSTkkyYkIzbFl0RVZOZCtwYWRNOGFqOGV3VHlUVnFY?=
 =?utf-8?B?aGRrR1gybzBjZnE5cjlFQ1NlbzBOSGxQQUtudUpYMVRtMVl3VkJxb01GQlBP?=
 =?utf-8?B?OWxVZkY5Y1E5cVIvNStld3Nyck5hUWgzUEdlZkl2ZjhiN1pxL09tTkV2VlZH?=
 =?utf-8?B?TG5nd0w2bC9uci9hVzYweUlHejJkUHAwRXFTOFY1NXRzdmx1SWxOaURxd1hq?=
 =?utf-8?B?R2ptNUYzZXhXc1hpcGdKcjEwejFwWFhaUEE3VHBRUVViR2l1ZkJxckxNd1hL?=
 =?utf-8?B?dVhvS2dnNko0dEhsbG04djdBU3FmcS9PR1hCMXdnTFBhUDMyZGI1T0VuUHZD?=
 =?utf-8?B?QlZXd1VvdHpneUQ0L2tzOFl4TVNFSkZXVGxMTzc4a2p6VmkwOGVkMytJVjk5?=
 =?utf-8?B?SEtnbE40c0lJdGhTeFR4ZE1mc1lIMXBQVGJDaFNJSGdtNzlZY2psMUR1Q1B6?=
 =?utf-8?B?ZHhDVDBicmpNMFE2Z0hHYkx5THgzcHVZREJvQUhUcERzcmt3eTg2WHNpS3dW?=
 =?utf-8?B?dW5zWG5obDVTVFIwaTNsOS9IQ3cwc0kwTHg1WVhrRkV4YzVBWFNiZFNGUHhF?=
 =?utf-8?B?ZHgxWERtUmE0aUJLMU1lQitqNXBabWN0NEdxd3ZmSllLeHBrV3V6VHhad3lS?=
 =?utf-8?B?NzlXY3VJRHhRTEhKM3U3SGgyaE5KMXBmTlJ5eVNSblUxc0xQUHdLOE9veW1V?=
 =?utf-8?B?QjVjeHJkSDQ2T3F4Z0NETk1KeUdiWHc5N24zVnNaUk5sNUxxY25qakFZMGFt?=
 =?utf-8?B?UERuT01DNkZnTHlITm5WMXJjSzQyWWoxQUtRTGdWWU12NWFDRm84elpieTU1?=
 =?utf-8?B?eldGN3NnN2FkSWxuUkRDYkhSSWZiYzcxN1l1S0pPTUQybXd6OXlSTUpoRks5?=
 =?utf-8?B?U21DSkVKRkxqQ1N4SkFqejZkZTFzVDl1b292RnlNaWRGYUs3R1p0SlpjaTRa?=
 =?utf-8?B?UWd0RWxmcFRTdUdNajJpUEpkdFhsZkIxemxJUkRQUTljaS9pcUd2TDI0bGRX?=
 =?utf-8?B?YlJCQ1h1YzJ1aGdKNDUyYVZqSXJiY0FqWEc1NitIbnhpZTF6cHM1YXJpUG93?=
 =?utf-8?B?QlZGRHpxM09VMUtVYmcxc25yUGVjdXBTZEVYc2RaQmhDNzVZdEVsdmNqenVo?=
 =?utf-8?B?SjVoZVNYS2ZsTktrMHY5bE9XZ0xYbkV4bVNlR25MTS9ZZWk2YXNtLy9yZUNn?=
 =?utf-8?B?ZFgxMktkcHgxc0JseUY5NTc1UGRtbmcxQmhxTHViNXJmN3FtR3l2Z0FwN2tI?=
 =?utf-8?B?b0JUSnhlb0JDb0ZERDYydjNhWFlPWll2MWo0TDlzUEd2V3M3Q2pNQUNUOEM5?=
 =?utf-8?B?RDdjRTN6cWsyQ2h0bVZFbUhqZlorRWF6K0p6WDloVjlwT1JiR1AzQ1prclk2?=
 =?utf-8?B?OEVjZ2dib2lhWWhoNjNlUERSYk5WMXNjb3VrdE5HRUtMNTlKNm52ZG9yaTZN?=
 =?utf-8?B?aXNjUjZ0S1pUOUFmRUZUM3RUWXFqeWdCTENsby9UNUtoTDlnTUhpUVE4bDZ6?=
 =?utf-8?B?K2NGL0ZPdERBYURyWSt2azI2VENmekZkYWk0ZmdmY3NTOFM4c0RKbDNKb21m?=
 =?utf-8?B?VkVvbTBvR3dRZ21FM25ST0RETkRZVzFPNTZncFA5dHAyVnUrUXROU2dKTVdo?=
 =?utf-8?B?SWJwVXVlR1B0L2xpWS9sL1hiNXpWUGVWbUVFd1VJc3RINHUyMDVWWGNuNFh2?=
 =?utf-8?Q?Y+/j5roUUC1cuysI5ZBgyFRND4tpSmlphipEI0BvGWxU?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c8bda13-2957-4a51-3e83-08dd35006b89
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 01:03:27.6878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S6AyWNsofTXr5Zhbh3FrSFU39qUYLvX2+T+N7Xnek7svhZPq98NASTH6LNEXQ4+QVAKH+oIpYOaPG62SRUiK3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7814
X-Outbound-SMTP-Client: 72.163.7.169, rcdn-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-02.cisco.com

T24gVHVlc2RheSwgSmFudWFyeSAxNCwgMjAyNSA3OjE1IEFNLCBKb2huIE1lbmVnaGluaSA8am1l
bmVnaGlAcmVkaGF0LmNvbT4gd3JvdGU6DQo+DQo+IEhpIERhbi4NCj4NCj4gSSBhYnNvbHV0ZWx5
IGFncmVlIHdpdGggYWxsIG9mIHlvdXIgY29tbWVudHMgYW5kIEkgYXBwcmVjaWF0ZSB5b3VyIHJl
dmlldy4NCj4gSSBhZ3JlZSB0aGF0IGFsbCBvZiB0aGUgaXNzdWVzIHlvdSd2ZSBwb2ludGVkIG91
dCwgd2l0aCB0aGUgdGhlIGV4Y2VwdGlvbiBvZg0KPiBvbmUsIG5lZWQgdG8gYmUgYWRkcmVzc2Vk
LiBUaGUgaXNzdWVzIHBvaW50ZWQgb3V0IC0gZXNwZWNpYWxseSB0aGUgc3RyaW5nDQo+IG1hbmlw
dWxhdGlvbiBpc3N1ZXMgLSBjYW4gdHVybiBpbnRvIENWRXMuIFdlIGRvbid0IHdhbnQgdG8gYmUg
Y2hlY2tpbmcgYnVncw0KPiBsaWtlIHRoaXMgaW50byBMaW51eC4gQ2VydGFpbmx5LCBub3RoaW5n
IHNob3VsZCBiZSBtZXJnZWQgdGhhdCBkb2VzIG5vdA0KPiBwYXNzIHRoZSBzdGF0aWMgY2hlY2tl
ciwgZXQgYWwsIGF1dG9tYXRlZCB0b29scyB3ZSBoYXZlLg0KPg0KPiBNeSBjb21tZW50IGhlcmUg
d2FzIG9ubHkgdG8gc2F5IHRoYXQgSSBkb24ndCB0aGluayBpdCdzIHJlYXNvbmFibGUgdG8NCj4g
YXNrIEthcmFuIHRvIGJyZWFrIHRoaXMgY2hhbmdlIGludG8gYSBzZXJpZXMgb2YgMTAwIHNtYWxs
LCByZXZpZXdhYmxlIGNoYW5nZXMuDQo+DQo+IFRvIGV4cGxhaW46IHRoZSBmbmljIGRyaXZlciBp
cyBDaXNjbydzIGRyaXZlci4gQ2lzY28gaGFzIGFsd2F5cyB0YWtlbiByZXNwb25zaWJpbGl0eQ0K
PiBmb3IgdGhpcyBkcml2ZXIgYW5kIEthcmFuIGlzIG9uZSBvZiB0aGUgbWFueSBDaXNjbyBNYWlu
dGFpbmVycy4gV2hhdCdzIGhhcHBlbmluZyBpcywNCj4gYWZ0ZXIgYSBsb25nIHBlcmlvZCBvZiB0
aW1lIHdoZXJlIHRoZSBjb2RlIGhhcyBiZWVuIHNvbWV3aGF0IG5lZ2xlY3RlZCwgQ2lzY28gaGFz
DQo+IGRlY2lkZWQgdG8gZG8gYSBtYWpvciB1cGRhdGUgb2YgdGhlaXIgdXBzdHJlYW0gZHJpdmVy
LiBUaGVzZSBjaGFuZ2VzDQo+IGFyZSByZWFsbHkgbW9yZSBsaWtlIGEgbmV3IGRyaXZlciwgd2l0
aCBzb21lIG1ham9yIG5ldyBmZWF0dXJlcywgdGhhbiBhDQo+IHNlcmllcyBvZiBidWcgZml4ZXMg
b3IgdXBkYXRlcy4gVGhpcyBpcyBoYXBwZW5pbmcgYmVjYXVzZSAtIGF0IHRoZSBpbnNpc3RlbmNl
DQo+IG9mIHNvbWUgb2YgdGhlIERpc3Ryb3MsIGxpa2UgUmVkIEhhdCAtIENpc2NvIGlzIGJlaW5n
IHRvbGQgdGhleSBuZWVkIHRvIGJyaW5nDQo+IHRoZWlyIHVwc3RyZWFtIGRyaXZlcnMgaW4gbGlu
ZSB3aXRoIHRoZWlyIG91dC1vZi1ib3ggZHJpdmVycy4NCj4NCj4gS2FyYW4gY2FuIGNvbmZpcm0g
aWYgdGhpcyBpcyB0aGUgY2FzZS4gTXkgcXVlc3Rpb24gZm9yIEthcmFuIGlzOiBhcmUgdGhlcmUg
YW55IG1vcmUNCj4gbWFqb3IgZHJpdmVyIGNoYW5nZXMgY29taW5nIGZvciBmbmljLCBvciBpcyB0
aGlzIHRoZSBtYWpvcml0eSBvZiBpdD8NCj4NCg0KVGhpcyBjdXJyZW50IHNldCBvZiBjaGFuZ2Vz
IGlzIHRoZSBiaWdnZXN0IHNldC4NCldlIGhhdmUgYSBmZXcgbW9yZSBzbWFsbCBmZWF0dXJlcyBw
bGFubmVkIGZvciB0aGUgZnV0dXJlLCBub3QgZm9yIDYuMTQuDQpUaGV5IGFyZSBxdWl0ZSBsaW1p
dGVkIGluIHRoZWlyIHNjb3BlLg0KDQpSZWdhcmRzLA0KS2FyYW4NCg==
