Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6C33D8;
	Tue,  4 Mar 2025 03:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057854; cv=fail; b=jfXckAjrfqer9oXZgsRCanMQ7FfUeyryL1rOn7fPTh6Ls34/XiZfATUt0iavQo9W1ldhbAFRiMaDVqGSpjT38+CHGOH+02nIbs/b8wdzxbwFdPGnGrVvftshH/DDGsi7ceSU60EkrRsdgdG15STah1jZ/QkBPykJhjDlVGuJhYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057854; c=relaxed/simple;
	bh=u1nkUYHLwhFphByL6H1JIOe1QzPcUXoBAawhUTtGSZs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h+SDnAYzfkWnDlA4eK+q88diBvBaRgwNi3IGa8qtO9XG8kzsyuemR89da4a1gkl6jmKIZUTEuFHYC5aA6ORMyVeIGZtODyWqWdlGBMmpzkniOlQI7+tgo/78iKzItDQF91+uOpTbAPK5Xnm7Az5yNlP/mz/Kc+5t6OMkZZzrCSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=f/2kUteR; arc=fail smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="f/2kUteR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=510; q=dns/txt;
  s=iport01; t=1741057852; x=1742267452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ftXMcj6ozb/43f2HQDeay4mg6prgkzUU1albd/KNlhY=;
  b=f/2kUteRF+9wdhvT2HxW6ZIcSFutSZLc/VNbmGwxglr9DbAu8S+o2IPx
   dz34vu5wmHDOsSABOll+xVwZyH7Mn5OCEkciuyvUIVEWoFA8iVWxCO2wk
   IBoMg7Lm02iHiKnsCq5piq5KpU+KB7KOaExTX3UagCjJdFGa3T86zpDyo
   P1uK94q6xC1guHp+iwmllRnNA165aYAedfE2ZmQxXtY2wqQRGo7DrIm/D
   npaiusFYGQZuWwoD5jRw8LLWsGhiDrhmSQtdru+tnq7bo91372P2inSPY
   BNenDfG9UgSaJkyqdMAGVOKEOCUHi16/yv7+QDSCPIdrTZz9mMj6b+jcL
   Q==;
X-CSE-ConnectionGUID: vr7TxFNjREmqP8k/2xpbeQ==
X-CSE-MsgGUID: MvwaJ2i8Q6+VFzxWKjinGw==
X-IPAS-Result: =?us-ascii?q?A0A6AADdbsZn/44QJK1aHQEBAQEJARIBBQUBQCWBGggBC?=
 =?us-ascii?q?wGBcVIHghJIiCEDhE5fhlOCJJ4UgX4PAQEBDQJEBAEBhQcCixQCJjQJDgECB?=
 =?us-ascii?q?AEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGWgEBAQEDEig/E?=
 =?us-ascii?q?AIBCBgdARAxJQIEDgUIGoVFAwGiSAGBQAKKK3iBNIEB4CKBSAGITgGKYicbg?=
 =?us-ascii?q?g2BV4JoPoRFhBOCLwSCL0WBJIJXZ5oFjlZSexwDWSwBVRMXCwcFgSlIA4EPI?=
 =?us-ascii?q?w+BFAU0QTqCC2lJOgINAjWCHnyCK4IXgjeEPYRAhVSCEYFdAwMWEIMfeRyEe?=
 =?us-ascii?q?YRrHUADC209NxQbBQSBNQWgcTqEQoM2NZZYsAYKhBuhfheDcBONCJlLmH2jY?=
 =?us-ascii?q?oUlAgQCBAUCDwEBBoFnPIFZcBWDIlIZD9pueDwCBwsBAQMJkWUBAQ?=
IronPort-PHdr: A9a23:piumExfHCmjgcam3H9EIEWgylGM/gIqcDmcuAtIPkblCdOGk55v9e
 RGZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NCBo
IronPort-Data: A9a23:hTZX5q5QCJhYrJntSDd1EwxRtFDGchMFZxGqfqrLsTDasY5as4F+v
 mVNXz+POfbfYmX0KYgna46zoUhT6MfXzoJnGVFlqyxjZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH1dOC89RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr+KUzBHf/g2QpajlMsPrYwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eI5dHxvZZJ2N02
 PkBEGAOKUqTn+i7+efuIgVsrpxLwMjDNYcbvDRkiDreF/tjGc2FSKTR7tge1zA17ixMNa+BP
 IxCN3w2MlKZP0cn1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3FbIeIIIHQHpgP9qqej
 kfY4G3bWBBKDYLc9xSX4k2PhO7JsjyuDer+E5X9rJaGmma7wm0VFQ1TVlahp/S9olCxVsgZK
 EEO/Ccq668o+ySDStj7Qg39u3WfvzYCVNdKVe438geAzuzT+QnxO4QfZjdFbNpjsIo9QiYnk
 wfU2djoHjdo9raSTBpx64upkN97AgBMRUcqbi4fRgxD6N7myLzfRDqRJjq/OMZZVuHIJAw=
IronPort-HdrOrdr: A9a23:fgLigqMr4ZTDacBcT47255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
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
X-Talos-CUID: 9a23:Z1J9rWP7kOXeve5DRjM4yF46PMIfX3jE9CfTZBWoEWxkcejA
X-Talos-MUID: 9a23:b8dqkQlo6pAvEuPppApCdnpHKthhwf6vWHlT0qsoqdm7Fi5xPRiC2WE=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-05.cisco.com ([173.36.16.142])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Mar 2025 03:10:40 +0000
Received: from rcdn-opgw-5.cisco.com (rcdn-opgw-5.cisco.com [72.163.7.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-05.cisco.com (Postfix) with ESMTPS id CD16718000166;
	Tue,  4 Mar 2025 03:10:40 +0000 (GMT)
X-CSE-ConnectionGUID: SARWEWxxSg6MoNvs3mDQZQ==
X-CSE-MsgGUID: Co8xaXyVTKqezwP4PhxgeQ==
Authentication-Results: rcdn-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.13,331,1732579200"; 
   d="scan'208";a="23112277"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by rcdn-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Mar 2025 03:10:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JnTjn2dTPCsGb4h+iP87VeqFS4VNnNuXbKZZwjkdN1VAJdO76OwiysnMgRh47qkJYKnqGeGowhCJw8I14nyF9FImN+AN2xZXiyHh9mpF4KS3phlWSvtzLZSLhQ02M5e8zGAEBpTCDY4mBILj0t7KKu4ePyaEUUBASAlAAy40Ow+LBRdohcNKgE1sNCMOvvd4csO/XYosqEQXU8+srghQTF5d7R8O81LafasulM2VIdGhZNas5BVr12ZYVdgwaxGF8oJ17xxg5jtvDafstqo18Ek6N53P7JcTeTN2BPAqA/PrEx1LWnzWARMX8yGGd++66itMFMzppyLUCINrVs8JPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftXMcj6ozb/43f2HQDeay4mg6prgkzUU1albd/KNlhY=;
 b=pNQ1dgmuxRi8uxM3f0UGFszcLADdQlZqRdaz6G97jmxMVo/X2wt45SdO5Qq/P+q/BASVFvQR5c1R9aEWOzFw86SpdqDt4zoABAaoYkeeu4tZ6i/VDc7QxITIavPz7FMkdhJyD1ECAqw8IvRf7vmkSkOtFXTRFtsaDMY3q3yCBObklxzT7cX8Szs84pDRcql3qI3kLlBxQ0wTdxT1E0f29xFORqS+v4UJkYl1UvLKWIb7GgpW3PMR0YrKHuh10Bwle9jWkRJOdhvAi6xWto3Tma79nohXqzjZeBWRvyvpVly41/1hU/kY4VshQk4MVAl/6qXvb2oTQSwpvDFjgnHJmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CY8PR11MB7291.namprd11.prod.outlook.com (2603:10b6:930:9b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 03:10:39 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 03:10:39 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy
 (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar (djhawar)"
	<djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>, Dan
 Carpenter <dan.carpenter@linaro.org>
Subject: RE: [PATCH] scsi: fnic: Fix indentation and remove unnecessary
 parenthesis
Thread-Topic: [PATCH] scsi: fnic: Fix indentation and remove unnecessary
 parenthesis
Thread-Index: AQHbh89NpdwrLCENX0qmfq0TKYgQ6rNiVWpggAAAtjA=
Date: Tue, 4 Mar 2025 03:10:39 +0000
Message-ID:
 <SJ0PR11MB5896D193B38619C4BE5CF60DC3C82@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250225215013.4875-1-kartilak@cisco.com>
 <yq14j09trz2.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq14j09trz2.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CY8PR11MB7291:EE_
x-ms-office365-filtering-correlation-id: 377a0ef8-8d29-4dc9-7c31-08dd5aca240f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?G5+pI6mDlgGSYPjc/P9q4AlYaATTINNlnFozkKz7vt3RHajZnDWg3El1VbfB?=
 =?us-ascii?Q?xmnzaENMYiHQtAtHNFqxVe8sUZ0+Cxam/Iyr4G3fjo6oWfeuY9VSUmXkas7o?=
 =?us-ascii?Q?fshN6ghhZmoow85f0ivLc9tutxBgvWfYMgzPWkktoPAHqCdwDQ3t8Nm0afir?=
 =?us-ascii?Q?TT8xB0RY8fx3vvBTKO24hS+Tf/MPYM/TamCWB9QeUYsQ0EM6n+KzPmjGci4U?=
 =?us-ascii?Q?Gv/0L1XF8C3y7L5dkB72/ri3t4TicdVrlrVe/ccvOuEiamEfCaWBCnCKEXhr?=
 =?us-ascii?Q?KQvVZk32fNbqLag4fcO41eumD3WGvl7btUi/rpXlXOiZdsejSfNXRu2t5vga?=
 =?us-ascii?Q?9mvolWSJMPXvEgsxSzTx/NfPPJZbX2jDg9czq50AON+s7eVYrxqxGYXbVBti?=
 =?us-ascii?Q?JNQQb74JnDt14RoHYJbNxOiE2a7LzM8RxFgVTmd4gTvkkNkXSKzRGJlU8bt2?=
 =?us-ascii?Q?oMqU7jgAqtbYG9nvQ+FHnMzgdqD2ZtMW3K6598MzV7kwnM9ciJoZEBc1UOiR?=
 =?us-ascii?Q?KMrNygzjE8yaTMJQiOnEfOTTn1P/kSce7LHbU0pcYZ9WfG2CykODbYKkM3ms?=
 =?us-ascii?Q?5TYpQDDMNDgVxdFIkmeEE/T8VXAT/I07RMQRpBQkEtoqhCIbS5NeLgHGG5BV?=
 =?us-ascii?Q?xxn/BxL/xpIz61PCyedITlKM9l68p40APj4Fa3CC8CYxm4RRWxLimVGBRlWG?=
 =?us-ascii?Q?VjMgI8hysg4DAIP7C89Oo44KsBSISjMI302VARd8HcuUdABARfh/B/9p+SF6?=
 =?us-ascii?Q?olhihrL0cs1XNnR4OwE369K2EEkf5q+NwKvx1DwT5diSNqpMN8cmt+5ijaFj?=
 =?us-ascii?Q?cs3ti4nf4VNf1bCIb+4DiYmQDJgiTMvm8tLLWZCC9/RuppDn7y60EwTdv044?=
 =?us-ascii?Q?o0UnyuaSWa8V6ee5zg8XPXx3gAopiFrt0478P2WrasoXvbcrrYXA3vLoVrY6?=
 =?us-ascii?Q?8G9qffEzsW5DXe3sftE78AjkfI8aEuMgme7468hxybDJFwE2IzVbGMQ6tUy7?=
 =?us-ascii?Q?+HjS/EshlDRtTTlJaLNTgymxiMtTitrMeHUbHbG/wE/cRy6SIsocWy624GRT?=
 =?us-ascii?Q?t080P5+G+2vhh0VERgH22KTlEEMb2sqhYG/8fz80Y6dHjzRjrbFB1cuAWscA?=
 =?us-ascii?Q?QLifMYyMgrT3qR6woydZbR3RMrR6KO91fdVd/EFTC1WvqZ+vqt0laUps84Ij?=
 =?us-ascii?Q?FgaSNQWPSaQx6BV6OokMtsDHxMMK/JeCzox3A+FBc64QPLjqmzDk4GCtiCoj?=
 =?us-ascii?Q?NJ9auFtlPOOEDGsgTFR6ysQWYDeqV/kDyMGlxUsrB400DoshASv7iK8uuMzO?=
 =?us-ascii?Q?hxSwyKPkHtQAilifAykPpD2sY3j38vvj8PlxngoQ8cYgZpCc9UBdxQc/0Nva?=
 =?us-ascii?Q?t/ZYmnXm2YxtS5HWCJsB+A8rM2N+5k5gxigfK1Hy4JnYvoyo7yjHN/gNA3SU?=
 =?us-ascii?Q?O/0Y68wQZU2qDWl+wf9W0E8OrxeTjpxM?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?THxpLKrENpbFhjfi3gx+fD8iNIayIEa69VkRamQLkyhLPfVE7eZgivRBxJhB?=
 =?us-ascii?Q?0mUPtOXzminSrLBegJcNg8I0Bbo37E2fm4DpX2fX2RDeH9m1JENHRFd/3oWF?=
 =?us-ascii?Q?4sOksiiOqpxr7syVY3IoHZfGa31J9zMYtzNDlhiL+r6NYciAKXCBf/UZvLYW?=
 =?us-ascii?Q?lJyR/MZbSh48QI3YdvvnZ/pUBdpTqZrRBu8DTJAyaG23PlTP9c+luLyuRCMd?=
 =?us-ascii?Q?HqFt3fr/6TNtHrUvrWZgfVSK600CL0rBJmOmQPvEjkePM4fKZ0lpMOCoJBNo?=
 =?us-ascii?Q?ErT1JwSNO4gCLAm3E9TBr7vUKHRzRzV3KFgo2whwoP5CZPwybbei5S5HqGBv?=
 =?us-ascii?Q?q4478I9tygTqh1wh615/xh28PTvGp/1z7JTdgx9nzJhUizWUT/X8ZJ3ToROL?=
 =?us-ascii?Q?cxZpm25v6YJexDiMnmH5eatrX6963zK9tU0HT+pXKR9HpHD4q0JDIlVgM4wJ?=
 =?us-ascii?Q?2CtR10v0Ypg2HXWNIIsjXq9/RnaipKrUyOB7AFHmzurqU72EPyex4l6LduSI?=
 =?us-ascii?Q?G20WIQUWNWFHOCK3v8Jwe4hl5k7GGMEDDnBG8iXHooE93dATo19VuMfsnyK1?=
 =?us-ascii?Q?IjKdRgmaSRxDFsgBJzT2LS2/zM9zc2xW8/Go9/s7k7LxRZhZi6TYKdbZ26s/?=
 =?us-ascii?Q?Eq3rP4w8O/B8Rb9MXNtpYBblgZ+Umof29j40MPagrqKgFvFxelmJJhvkxWrj?=
 =?us-ascii?Q?nQRAhs+Hxm81mhhr4APktW2x34amQMwepTUNlDQf0YPSIrY0jD56bzxw/b03?=
 =?us-ascii?Q?CmhyjRdDDozlJX1AzHLeNsQ+9NjiOSBuHSxuKDYkNpalSSDAD3pWzj52KOzL?=
 =?us-ascii?Q?RMs97of13x2Ml87a96VQtAWIO1GkMXaAzrrTsyHmQYwxn7wGLUvMAta6kqSI?=
 =?us-ascii?Q?0+/Ip1BAof+8RjmXOB9gjP333Lux63Qh8b+vI+ConKSu7TI241P4rUE2mqqk?=
 =?us-ascii?Q?ujLtOABGNQJiVo8e63YtDm4mF2uCJzAWp/UtxPfnN0ewjISrxMs22sX46vH5?=
 =?us-ascii?Q?0OawrHsPDlINL/3tMxhAijXQyup5QM0Dx48M/r3q8/RY/3yJ9JaEyibAF0vR?=
 =?us-ascii?Q?A9KjSQyE8YTGxWqfugWf2aExueU3XQ8O0GUif4294ZpReEAcreWS9aQUI7bT?=
 =?us-ascii?Q?Rc13pipUIk4BoTzWgdmKvofTijJm2f4dhoV8ejuuUlUQwJorrLspBfrBTc2b?=
 =?us-ascii?Q?NruRPNg22tUJRX/xdi9vYDK3gLlLk1x20CmYwzSolT0+pAsfs08hdkL4aUN6?=
 =?us-ascii?Q?vIb+nx2FWcLqZpgVigzDxdRenZYdX2TyyhL7cWtGwOskel4hb+PMCN+RtPOO?=
 =?us-ascii?Q?7KivTsxnXzm961M6lS9ohYBjuwyg/kKFl1JorWOGoQigVwGpJtFrfAEri2CV?=
 =?us-ascii?Q?25AwMLZfiSlQW/Wv8dba+TWGJxuCW6jFHG/MmJ38FWNo+BKn19Eyt7NcPWD1?=
 =?us-ascii?Q?nHEl5uROY3is6YEsdTf93SiWGQWue5TL5tKoY5Ksrk4ZvOxdNGgaMMCNVl7r?=
 =?us-ascii?Q?t9dXAgiRkpy1F83kNsSHiV9YnI8XE07iOB+NibLjZPp23TXM6skTnlCmCNrK?=
 =?us-ascii?Q?XrOU2OfjyT93Jf6cbLLBVIJr8axDBz3axCjmvVFwrLxtKTcEVJVCm5u0QExG?=
 =?us-ascii?Q?zDrjhIe6AMbmFJpH56qais0X/s14fCUe19CA2FQs9nOA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 377a0ef8-8d29-4dc9-7c31-08dd5aca240f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 03:10:39.1199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2eYlLAWt/yr0IzsATCohdeDJqUkRiqVMQXJ4VyXSKbeyKIpxa1BYLBsdOnyb8qZQ5Y8zD1At4tho4F3Ys7w5vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7291
X-Outbound-SMTP-Client: 72.163.7.169, rcdn-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-05.cisco.com

On Monday, March 3, 2025 7:07 PM, Martin K. Petersen <martin.petersen@oracl=
e.com> wrote:
>
>
> Karan,
>
> > Fix indentation in fdls_disc.c to fix kernel test robot warnings.
> > Remove unnecessary parentheses to fix checkpatch check.
>
> Applied to 6.15/scsi-staging, thanks!
>
> PS. Next time, please send your fixes as a patch series.
>
> --
> Martin K. Petersen    Oracle Linux Engineering
>

Thanks Martin. Sure, I'll keep that in mind.=20
Sorry for the inconvenience.

Regards,
Karan
