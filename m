Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA641758B;
	Thu, 27 Feb 2025 01:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619035; cv=fail; b=J4g3q6pTdae2jP/Kg7TebZjhGl08uMb3iM+roExksdQacRKRncg446+aNfPrax5JSuRUazxyK9QtB9HZl6olMQcEYxjVfUYTSsuB3DMTlDzTiwzCdDp1HOeBj/X4gVGFtkiOe8bccfS5etaA8BMgdkIVPLMFfLS7id3AXC+wTsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619035; c=relaxed/simple;
	bh=4rOtJZMYss/z5pb0L1P/zo7gQirnpA6AzSd4a69Gt+g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aDSldX0bnPprK5DQqQOuBC6DSONPX59nkJmyCMmzmfZA2eIh4xKOwvxBK8sPjcxcOFjnfXI2VELJkXOYu70e2f/Qkk2v0kCw00uEolR9w+krCgviXZbFeb8rtuHk16ahHAE6YI+mEt0JS4H5j11GPEAymRkAvhxbd6QGCwST6c4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=iWYVBB4b; arc=fail smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="iWYVBB4b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2589; q=dns/txt;
  s=iport01; t=1740619033; x=1741828633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iWWAtqtdJgwfk5+3P8FVI+oCE9kN9LwpkdKngcs3lQM=;
  b=iWYVBB4bRR9TAxeDcxWaMvJWrUSdRGPXFuUjXYRg0rIBud9y3RFmiacn
   ObcVl6UWRPvQBDgt6px9suSJbYPvBXqfyjYzDMlVHn//d5zxxPbpKWczo
   O24oZNRn/j6Uihvcs7lrlXVIY9I0JC2nVKDqpFpZl2XINkcknafMW+0Us
   aVbiA3E5qTnRIodK/4ooTv//KFDXn6uS7CvF4G49P2qKQwJBInYoyf47T
   C0U9qhshE8d61HMCfkaoFwC9TNNL62DVS+2AkfzB4AbsYwPKqeefcoPYY
   2Kqzj9hnUiYSulJm/nvjG5EjZwAgnhN7+1HPgszD5zrNwHbRwtmfBe4Y7
   Q==;
X-CSE-ConnectionGUID: zF47s4UVTSuj5bwHT5B7Mw==
X-CSE-MsgGUID: E+uz1cBxQ4Sw5uAV+dd5SA==
X-IPAS-Result: =?us-ascii?q?A0AoAAA3u79n/4r/Ja1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEaBwEBCwGBcVIHghKIaQOETl+GU4IhA54UgX4PAQEBDQJEBAEBhQcCixECJ?=
 =?us-ascii?q?jQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGWgEBA?=
 =?us-ascii?q?QEDEhUTPxACAQgYHhAxJQIEDg0ahUUDAaNWAYFAAooreIEBM4EB4CKBSAGIT?=
 =?us-ascii?q?gGFa4R3JxuCDYFXgmg+hEWEE4IvBIIvSoEkgldnmg+DVopRUnscA1ksAVUTF?=
 =?us-ascii?q?wsHBYEpSAOBDyMPgRQFNAo3OoILaUk6Ag0CNYIefIIrgh2CN4RDhEGFUoIRg?=
 =?us-ascii?q?WADAxYQgjBvdxyEf4QvHUADC209NxQbBQSBNQWlTSxUIWyBKRYBAhxFkyeCa?=
 =?us-ascii?q?65QgTMKhBuhfheqVZh9qQYCBAIEBQIPAQEGgWc8gVlwFTuCaFEZD44tFs4Lg?=
 =?us-ascii?q?TQCBwsBAQMJkWUBAQ?=
IronPort-PHdr: A9a23:EYbNcxVh8i5xxXrGvUkOl0U7Gl7V8K3PAWYlg6HPw5pUeailupP6M
 1OaubNmjUTCWsPQ7PcXw+bVsqW1QWUb+t7Bq3ENdpVQSgUIwdsbhQ0uAcOJSAX7IffmYjZ8H
 ZFqX15+9Hb9Ok9QcPs=
IronPort-Data: A9a23:RacO06841AtcO6ny3F+eDrUD63+TJUtcMsCJ2f8bNWPcYEJGY0x3n
 WJKUG7Tb67YYDb1e9knPdix9hgH6p7cyd81QVBt+S1EQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E/rauW5xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qpyyHjEAX9gWMsaDhKs/nrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kkE9FH4bpKP1116
 P5FIi8tUk2p2MeplefTpulE3qzPLeHxN48Z/3UlxjbDALN+GNbIQr7B4plT2zJYasJmRKmFI
 ZFGL2AyMVKZOE0n1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3FbIGIJIXbGp4I9qqej
 k+F4nagCTsKDYCk1meY20zviuOSpgquDer+E5X9rJaGmma7wm0VFQ1TVlahp/S9olCxVsgZK
 EEO/Ccq668o+ySDStj7Qg39u3WfvzYCVNdKVe438geAzuzT+QnxO4QfZiRKZNpjsIo9QiYnk
 wfQ2djoHjdo9raSTBpx64upkN97AgBMRUcqbi4fRgxD6N7myLzfRDqWJjq/OMZZVuHIJAw=
IronPort-HdrOrdr: A9a23:XTI10a14+gbTqmXq/Yr1egqjBf1xeYIsimQD101hICG9Lfbo9P
 xGzc566farslcssSkb6K690cm7LU819fZOkO8s1MSZLXjbUQyTXc5fBOrZsnHd8kLFh5RgPM
 tbAsxD4ZjLfCdHZKXBkUeF+rQbsaS6GcmT7I+0oQYOPGRXguNbnntE422gYzRLrXx9dOEE/e
 2nl7J6TlSbCBMqR/X+LEMoG8LEoNrGno/nZxkpOz4LgTPlsRqYrJTBP1y9xBkxbxNjqI1OzY
 HCqWPEz5Tml8v+5g7X1mfV4ZgTssDm0MF/CMuFjdVQAinwiy6zDb4RG4GqjXQQmqWC+VwqmN
 7Dr1MLJMJo8U7ceWmzvF/ExxTg6jAz8HXvoGXowkcL4PaJBg7SOfAxwb6xQSGprHbIe+sMlp
 6j6ljp8qa/yymwxRgVqeK4Dy2C3XDE0UbK2dRj/EC3F7FuKYO4aeckjRlo+FBqJlOg1Kk3VO
 ZpF83S//BQbBeTaG3YpHBmxJi2Um00BQrueDlIhiW56UkeoJlC9TpR+OUP2nMbsJ4tQZhN4O
 rJdqxuibFVV8cTKaZwHv0IT8e7AnHEBUukChPeHX33UKUcf37doZ/+57s4oOmsZZwT1ZM33J
 DMSklRu2I+c1/nTceOwJpI+BbQR3jVZ0Wm9uhOo5xi/rHsTrviNiOODFgojsu7uv0aRtbWXv
 6iUagmdcML7VGebrqh8zeOL6W6c0NuIvH9kuxLLm6zng==
X-Talos-CUID: 9a23:u3rfO2E9MLGT38Q9qmJ12hJLAZwYTEHm0XWNKVCYNTtDF5iKHAo=
X-Talos-MUID: 9a23:noPcvAsIdVaunhj7qc2nqXJ/Jp5jybSXVHsSzIgvhYqIOXFLEmLI
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 Feb 2025 01:16:03 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPS id C3598180002B3;
	Thu, 27 Feb 2025 01:16:03 +0000 (GMT)
X-CSE-ConnectionGUID: uqR/ujrlRISG5tqYCkLXnA==
X-CSE-MsgGUID: PbTtK5JFQsOuIx+12PbYAw==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.13,318,1732579200"; 
   d="scan'208";a="47766653"
Received: from mail-bn8nam04lp2048.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.48])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 Feb 2025 01:16:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VuWTn/X48T473a7cfg1/nhUXPdFoOQgqfU+ys2bAMjQ72zG3GEH1roj4G5FAbOASjk1T/pVdEh/4UT4/cKC1VIrI+xad0ZKBkoWLnNFQd763F8rRq9WTckCIcft/3d3/xw5EKWZOD7zUE+YYjHC1isnB0rOF07fYU0vQKrpc/mpE6iSBf4qsx3yjBRkbldHMY/lBjvU6M/qM8iMzO/KlRth5WeOR8rmSJO73OBKfteHT0X7c18DYMbPs/aZFFVyOMU6KNGumDvVIud9/QmSnl12A58Qw3jNynef/SyxtDa9/5SjobXBZ3LIae3nT6JZFuSzvwl/LGa6txFYtH1FbpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWWAtqtdJgwfk5+3P8FVI+oCE9kN9LwpkdKngcs3lQM=;
 b=jOVi2ahEdPwaUmpsJ2kCj7VKF4V/foYfilp7wZYl1WAOE0BldRhtzuzZ+FjpOuKM6ikmkM/ulMCDsZacYpzTyeIEYL8TnsRmXQaCvmzxxUUAaGfBBAo2vS7NTrLMtnxXB9evGbrBp8M6xRTyFpuCHr6Fu0XDHmcjzCKrMG1ycpNl8S87YCr2DCgR4oaIEbmj9LdS/cT4a/uuFMUJalq7jrbmKjr+Z2ttf6Nc5Dyfb5VC3S4A6rjdfGXfuuOEzk/M6fBuduyCGV0qQyP0LjRlei614VzP+djvFPqBdEm8aRw/wWbGu32VDPOxrIS3US9Ro4azlCv92yFyI5wuohZLMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH8PR11MB6684.namprd11.prod.outlook.com (2603:10b6:510:1c7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Thu, 27 Feb
 2025 01:16:00 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8466.020; Thu, 27 Feb 2025
 01:16:00 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy
 (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar (djhawar)"
	<djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: fnic: Remove unnecessary spinlock locking and
 unlocking
Thread-Topic: [PATCH 2/2] scsi: fnic: Remove unnecessary spinlock locking and
 unlocking
Thread-Index: AQHbh8+WFN9AqalFAkKOaU9U83dlu7NZMXAAgAEnjgA=
Date: Thu, 27 Feb 2025 01:16:00 +0000
Message-ID:
 <SJ0PR11MB5896FD24A1AFD61EE36F549EC3CD2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250225215146.4937-1-kartilak@cisco.com>
 <20250225215146.4937-2-kartilak@cisco.com>
 <80809232-9490-4a0d-8159-af53228b612b@stanley.mountain>
In-Reply-To: <80809232-9490-4a0d-8159-af53228b612b@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH8PR11MB6684:EE_
x-ms-office365-filtering-correlation-id: a0648e49-5d03-46cb-1681-08dd56cc4c30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?8S3rtk5lD+V3jckx1INtdwCWUc/P+/YKymZOYu+Ce7GwTOa/Cp5VKrmmofkH?=
 =?us-ascii?Q?/b+waf50GzNU20SreLjyM9Rqn9SVOhnQAsrGjLFijuMdZ2dQHWqjpuDE2v3L?=
 =?us-ascii?Q?Q7EzyIqvcxAU75r9PQcOqIke0i1C5ty0H4A/IMb9REM6qnuf6chuJd5I6jtm?=
 =?us-ascii?Q?S9H+SMWJ/vpHLdlCqx/WTScYiYh5WbIn5uhN74HIWAFXhTY9OTq1BVemkwg/?=
 =?us-ascii?Q?K8jjzn4SgQjIi1/tnBtg1jExroYOw3RaGFqQxiGXz715sD6iX0ZQFtwFVPZy?=
 =?us-ascii?Q?ldPLIPsWIX0csqEyoa7dBcCLQJN6X962vxXTo+LbksZXmJ2El63DE+ATKKAq?=
 =?us-ascii?Q?dq2KS30jTdUQXIP4g9kUazbT3CkOKpBXP74L3RVUFibCpeXGw+5j+l/Hh49b?=
 =?us-ascii?Q?yQDU2vrMKPW4ap5nuA0bQj/KwG5YSLmtTEuZUb8mrx7ebUSCQxx0eKnXxISK?=
 =?us-ascii?Q?9YsZCNaqf6gbbUAl9BcCHZoCuGikdrCauUC8bm0HsaiiRPvzktujd0/NV5av?=
 =?us-ascii?Q?ADOAWHXFM4bQYW+dkp1Qw6BnPdb2x5wv3lGvabrwOrorgYtL2sf07SFce5nW?=
 =?us-ascii?Q?rrL/sMQr+cE7sWdXZtXwwk3ktQt5M0oQxWY4Zf/Q625mcnU22aZgB4aKKYFM?=
 =?us-ascii?Q?Bewx0H8yK3zXvfEYY7YQzqZYb0ws3ri1Kbnw3u4XeId9v49aOPXheRCC6gNr?=
 =?us-ascii?Q?NEYacLOb8l2J/LBDBWehBz3utiqtUjo87H+oUOeBQLy/jXGuBb5r4Zm69F8x?=
 =?us-ascii?Q?R1+n9kz6qGZGqxNfrH9viAg6or6wxQ1LcqkqGY4zPUuOU0eX/uwPtDThiyVh?=
 =?us-ascii?Q?qoNgbFFaOOc6RRp0UFaUza67/bMePf1Tkzx0hbWTfAINBfErPZge0r2upF97?=
 =?us-ascii?Q?yqFQiB70VHCnkDG9AcVVEEkHniD5zf5k0hlcli4gKdOHJCkI62tCGdmMlsTO?=
 =?us-ascii?Q?OXqm8V1cqx0/la9s7thPXf49loIvFDp5WLQmBaYgKdJx5vjYHwvjJbF7I2e1?=
 =?us-ascii?Q?Ib4R3J7J/+2KcFxsCv+sv/jeU5eyccz1mFh0dEF0PQXPfX6HMtm0+1iJHbu/?=
 =?us-ascii?Q?z6Ip+/gNcGVJi0LxCFaq3ObP4Was8I0BnILZF1ZQuF6LuKALmuh6nA3SbN8t?=
 =?us-ascii?Q?PpE+RuEW3YGrKgP9BnCr5hgm1GXPvDJy+HcSc/EqX0cmspNEQrScHPcM3Y7C?=
 =?us-ascii?Q?fecJAzJTB5/2dpW/wGqAZjYlcB1D+xKxHNBuoHfQbCiMkEjcZRrD5t/ciibQ?=
 =?us-ascii?Q?CypLPy1CXTLOCZZ1sVXJtObkmKpMKRwZJE8gVrsL8tU9TXpF1zwuds91D8Ox?=
 =?us-ascii?Q?Sm2uRZajruDy0hLnIWuXcKs2EPcIuUKqv5zarHy17F1//GqwodfAXi+M5xZW?=
 =?us-ascii?Q?3OcxaMxIy1XxlRXVrKeVLwxjh65TW5tWBxboiSohK6GGjLSuZr520fYq8jC3?=
 =?us-ascii?Q?Y/srFcfEQqST0DCH6p3/IxFPKzvbE5za?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0sPT9yV09dsaBn0JN8p/i9EVU2be2SMAB7sK3UY3H2sOkeSssUNn4zkIAsPC?=
 =?us-ascii?Q?b95sjuLIkYEAMZenr0/5fcixIhTgztiUi3hvq1goePzGcJtgldcOl5Qvvhgv?=
 =?us-ascii?Q?7FHP335+S3ZHAzjfejyLPrgXUbFUkEyioEV2Xx5skimri/0t4Yor7GL5UhWU?=
 =?us-ascii?Q?+WII6e5OtCG5GILBFHlf8DxR/U7teaXjOdV2i+J2XnDH1bGPnR1+37/hr1iW?=
 =?us-ascii?Q?tebkPVlLm7DjlPHSecYh5q7yn6femJEWS3uJt4EnWptiN61zKKcoBY7FLxWH?=
 =?us-ascii?Q?6AViO9ARAXM687/XkT5+9GNb4z8BKioNYMh2WY4CF7d6yQVfjvZBcNpqmIlp?=
 =?us-ascii?Q?BQNAHgu2TIQxyFUR2OUJdj/oLjzhbLDsDzfaJ9SqpSyu1hVyUArP6PpjD4/8?=
 =?us-ascii?Q?mgrkPIL4EgPDC8d8P7Z+MiKKqiPDSBycwkM9zBlcCY15tNWhfJRRwxpapypO?=
 =?us-ascii?Q?k0iVpVFdnimQNtLL6f804gIzixkE3AJQWmb7wumaIL7VBwheljk9/wH3cgWm?=
 =?us-ascii?Q?+i3YcKWwMgVhhg98TldveeWZjdIuXx4fCZl/AKbokcOP6eo1YqWWaRaOwzAZ?=
 =?us-ascii?Q?US932XJ5wohMWjDM1MliR3SvcUH8+5zgZ4IhOk+BpVuPrxk3yUSLD7dRWlM/?=
 =?us-ascii?Q?u+c+ccgVfQH5G0HxBH+EzyzEsFE4AwBqogOI5QkOvpj6uW4iD+Y733XSGiFA?=
 =?us-ascii?Q?UwzyPrzitAEXaAPgF4XP8YF5KZTbHJIIfE0dXv9tZ19iOdegqb66a7NFRl4j?=
 =?us-ascii?Q?I2XNUZgIHGhQCYHm02LKIrcdJUtv4fFIK4/DiXlwHVS2OxWhh98vtZoOcYLW?=
 =?us-ascii?Q?y8piWnKPb9jKv0WXaobEMunM1yKzGDGArFg2teEfEYGfaS7yILyq+MSKd4vj?=
 =?us-ascii?Q?Y9Edw74lykt6paPLV4Iee8zlnY2Ono1d58xtI9lHu7DmBIj/ASdDWrt5lOsW?=
 =?us-ascii?Q?axOKPV+ZNyPYkaU5ZUbV9ZinudCbpiPiJBpu9cNDWRfkBs29Y0zfTa3+M1Gg?=
 =?us-ascii?Q?f3tknyOku48fvBszc6S8hzUS9cXKJJyMkBwy8Yv0GL4YJ1xysMqBroxIKdC/?=
 =?us-ascii?Q?Cz1PuGfnBSykxbTovY+Gakag/FO8yDL6XZxDMTjOgE9nPzGdgUVmSQ/oCLCm?=
 =?us-ascii?Q?IRydqts0Fb10JOC3wDNgCrEnHnRdyRBIj1hEQfTWNSYX5K2cCSnHzdszrv/G?=
 =?us-ascii?Q?nY3clGul9gexVWKSK0jsKmtZ7Q5sOZgO1c8z+gidgDlBkPDahFAh97G/KE4z?=
 =?us-ascii?Q?PJfgl0XDUhAZmw+O6vkg9IQqAWpb+Pv0ZGN2+jL4rm3xE2O0JFETOL5tLhdC?=
 =?us-ascii?Q?BDXdhR9YYF6Fh3KdVcN6NebWwcgDLGY884GOHADyKUGAfwi2l2r2lqS+2eU2?=
 =?us-ascii?Q?Ts0GeBQzYm7bbg91BcsTPFH7YEykc6U6KPr8iom7/R/lGgnI2ZCqaaufKBOR?=
 =?us-ascii?Q?Hg7t6KBQ+h9XxUtfhNLAcUiQip2OlXjSp3RRT3XOyNHUyfdy2BeqoGOArZ43?=
 =?us-ascii?Q?AjhzWKIegRYySqnJHT218Karasdw/zNJgnb+m8g2+10ink4ozgIybwZ5+4iR?=
 =?us-ascii?Q?DXDzFY3kdeiSLcx1oXMiHjHFPMtSZSOmWSBWCr0SOomH5fMqACo6JdkW4paw?=
 =?us-ascii?Q?DPtZ+a+V9l7Zo82VA6oh/h52pc9H/EYAsDvZmZB0dssw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a0648e49-5d03-46cb-1681-08dd56cc4c30
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2025 01:16:00.7438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qhzfLdt0PUS9KMj4IWJuQwNC8RTq9eKE4OHAVgKJLXNzE5WBO/XX0JbPr5c41Me/xthG9aVqEIsqZ7dIBEpAHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6684
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: rcdn-l-core-01.cisco.com

On Tuesday, February 25, 2025 11:32 PM, Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On Tue, Feb 25, 2025 at 01:51:46PM -0800, Karan Tilak Kumar wrote:
> > diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_dis=
c.c
> > index 8843d9486dbb..6530298733f0 100644
> > --- a/drivers/scsi/fnic/fdls_disc.c
> > +++ b/drivers/scsi/fnic/fdls_disc.c
> > @@ -311,36 +311,30 @@ void fdls_schedule_oxid_free_retry_work(struct wo=
rk_struct *work)
> >     unsigned long flags;
> >     int idx;
> >
> > -   spin_lock_irqsave(&fnic->fnic_lock, flags);
> > -
> >     for_each_set_bit(idx, oxid_pool->pending_schedule_free, FNIC_OXID_P=
OOL_SZ) {
> >
> >             FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> >                     "Schedule oxid free. oxid idx: %d\n", idx);
> >
> > -           spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> >             reclaim_entry =3D kzalloc(sizeof(*reclaim_entry), GFP_KERNE=
L);
> > -           spin_lock_irqsave(&fnic->fnic_lock, flags);
> > -
> >             if (!reclaim_entry) {
> >                     schedule_delayed_work(&oxid_pool->schedule_oxid_fre=
e_retry,
> >                             msecs_to_jiffies(SCHEDULE_OXID_FREE_RETRY_T=
IME));
> > -                   spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> >                     return;
> >             }
> >
> >             if (test_and_clear_bit(idx, oxid_pool->pending_schedule_fre=
e)) {
>
> We discussed this earlier and I really should have brought it up then,
> but what is this check about?  We "know" (scare quotes) that it is true
> because we're inside a for_each_set_bit() loop.  I had assumed it was to
> test for race conditions so that's why I put it under the lock.  If the
> locking doesn't matter then we could just do a clear_bit() without doing
> a second test.
>
> regards,
> dan carpenter
>
> >                     reclaim_entry->oxid_idx =3D idx;
> >                     reclaim_entry->expires =3D round_jiffies(jiffies + =
delay_j);
> > +                   spin_lock_irqsave(&fnic->fnic_lock, flags);
> >                     list_add_tail(&reclaim_entry->links, &oxid_pool->ox=
id_reclaim_list);
> > +                   spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> >                     schedule_delayed_work(&oxid_pool->oxid_reclaim_work=
, delay_j);
> >             } else {
> >                     /* unlikely scenario, free the allocated memory and=
 continue */
> >                     kfree(reclaim_entry);
> >             }
> >     }
>
> > -
> > -   spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> >  }
> >
> >  static bool fdls_is_oxid_fabric_req(uint16_t oxid)
> > --
> > 2.47.1
>

Thanks for your review and comments, Dan.
You are right; We reviewed it, and locking is only needed to add to the rec=
laim list.
We can use clear_bit. I'll send out a revised patch for this.

Regards,
Karan (on behalf of the Cisco team)
