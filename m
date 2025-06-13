Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4FB223335;
	Fri, 13 Jun 2025 21:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749852001; cv=fail; b=QM+6m3cn7VubGa6q1qpHkTCosBSA82+Dsb+NkpGszu1kr7J011pGeFfXi813bVg/kst6g6a6MBd5tP73NGT7Oi7+PSQGyNHt654WS/1KpmyELreetBzKsMLZ5If10ktbcLD9uaLHGs5vqwjCjq4pTwCjrpo2VXUjZWEOmvtH4q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749852001; c=relaxed/simple;
	bh=D/hrNcguLKEW9o4bXNZ1MV6XpMM5iWwpDUrZKezYuIs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XhG8W1UD99ss/EwC3eMj8xqQTf322OzZrqlVv7NZYJT/qOO6C4m4/gSAXN9Ak0kLZLjdu6G6Q3ZV/543eVj/Gr7vo+VuBStl1wDza7j76gZEdIwtTFVZQRkxGjY89aZivqFAp5s6DQWahIyM9v+Ade+fpkGBfY8NCd0BOtt2Y84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=VcHRhfNK; arc=fail smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="VcHRhfNK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1852; q=dns/txt;
  s=iport01; t=1749852000; x=1751061600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D/hrNcguLKEW9o4bXNZ1MV6XpMM5iWwpDUrZKezYuIs=;
  b=VcHRhfNKJ8CSdc5B76XQLhdkJfIkF8mn3j/+LhXNRt2HWSnA3qWxVlDA
   ROA0NPjVFDEfZ5CPzlRtlfzQ5bnvcxycBxCt6hdSGB4Kb7F/KjfGEc0mq
   bwsYOpdwIx/xIWdfKgNlrsSnbHQoptGuAeY7tgIqYyZlwdX1YmaRGwxJU
   dqcUqAm/VpeIWiPgkeh3VJ8ibv7aBlp0SFwJ4WN229JRrgKJr3mOH0xHD
   qPHSldpCJK1DhEPeSzariRQYM1/uarxDUVCFRgjv6x+xDAI3UHpN0K38Y
   tlb8rxEKYI19hYBKFCfVbvsMgrNdIKs+LZgkPuxksGK/X3wZOn8Lwe5br
   Q==;
X-CSE-ConnectionGUID: oouRumDUQpmc0dFhE4sA6g==
X-CSE-MsgGUID: /dRyDY1xTDunu6Pp1JLjbQ==
X-IPAS-Result: =?us-ascii?q?A0A6AAAFnkxo/4r/Ja1aHQEBAQEJARIBBQUBQCWBGggBC?=
 =?us-ascii?q?wGBcVIHghVJiCADhE1fhlWCIQOeFoF/DwEBAQ0CUQQBAYUHAotmAiY0CQ4BA?=
 =?us-ascii?q?gQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhloBAQEBAxIoP?=
 =?us-ascii?q?xACAQgOCh4QMSUCBAENBQgahU8DAaNnAYFAAooreIE0gQHgJYFJAYhQAYVsG?=
 =?us-ascii?q?4RcJxuCDYEVQoI3MT6ERYQTgi8EgiREUo0WiB2LclJ4HANZLAFVExcLBwWBI?=
 =?us-ascii?q?EMDgQ8jSwUtHYINhRkfgXOBWQMDFhCEBByEYoRJK0+DIoF/ZUGDYRIMBnIPB?=
 =?us-ascii?q?k5AAwttPTcUGwUEgTUFmAKEfkwCLgaBFCkqllCwEgqEG6IJF6phmQQiqGsCB?=
 =?us-ascii?q?AIEBQIQAQEGgWg8gVlwFYMiUhkPyXh4PAIHCwEBAwmRcAEB?=
IronPort-PHdr: A9a23:FA4wnxdCSBEYuVNmki59urCAlGM/gIqcDmcuAtIPgrZKdOGk55v9e
 RGZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NCBo
IronPort-Data: A9a23:G/0r0KJSJo1syuFcFE+R0pQlxSXFcZb7ZxGr2PjKsXjdYENSgTAFy
 DMXC2GAbvmMNGr1fItxPdi2pkMAuJODxoNqTAQd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCWa/073WlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrT0
 T/Oi5eHYgL9hWcvajh8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1pC1wMIIg0x99vBGoW+
 dIYBWwWR06M0rfeLLKTEoGAh+w5J8XteYdasXZ6wHSBVLAtQIvIROPB4towMDUY358VW62BI
 ZBENHw2N0Sojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZi+eyaoqMKoLVLSlTtgGUn
 HPqzj3pPj0HMsHB8SLc0FaujNaayEsXX6pXTtVU7MVChFyV23xWCxAMU1a/iee2h1T4WN9FL
 UEQvC00osAa8E2tU8m4RBajoVaasRMGHdldCes37EeK0KW8yx2FD2IAQxZfZ9E88sw7Xzon0
 hmOhdyBONB0mKeeRXTY8vKfqim/fHBMa2QDfiQDCwAC5rEPvb0Os/4Gdf46eIadhdzuEja2y
 DePxBXSTZ1I5SLX/81XJWz6vg8=
IronPort-HdrOrdr: A9a23:YxGD7amh8QIeRiCdo1sWpEn0UMXpDfNjiWdD5ihNYBxZY6Wkfp
 +V7ZcmPE7P6Ar5BktApTnZAtj/fZq9z/JICYl4B8bFYOCUghrYEGgE1/qs/9SAIVyzygcz79
 YbT0ETMqyVMbE+t7eE3ODaKadv/DDkytHUuQ629R4EJm8aCdAE0+46MHfmLqQcfng+OXNNLu
 vm2iMxnUvZRZ14VLXdOlA1G8L4i5ngkpXgbRQaBxghxjWvoFqTgoLSIlyz5DtbdylA74sD3A
 H+/jAR4J/Nj9iLjjvnk0PD5ZVfn9XsjvFZAtaXt8QTIjLwzi61eYVIQdS5zXAIidDqzGxvvM
 jHoh8mMcg2wWjWZHuJrRzk3BSl+Coy6kXl1USTjRLY0I/ErXMBeoh8bLBiA1/kAnkbzZZBOW
 VwriSkXq9sfFb9deLGloH1vl9R5xKJSDEZ4J4uZjRkIPgjgflq3M0iFIc/KuZbIMo8g7pXS9
 VGHYXS4u1bfkidaG2ctm5zwMa0VnB2BRueRFMe0/blmAS+sUoJhnfw/vZv1kso5dY4Ud1J9u
 7EOqNnmPVHSdIXd7t0AKMETdGsAmLATBrQOCbKSG6XWZ0vKjbIsdr68b817OaldNgBy4Yzgo
 3IVBdduXQpc0zjBMWS1NlA8wzLQm+6QTPxo/suraRRq/n5Xv7mICeDQFchn4+ppOgeGNTSX7
 KpNJdfE5bYXB3T8EZyrnrDsrVpWA0juZcuy6QGsnq107f2FrE=
X-Talos-CUID: =?us-ascii?q?9a23=3AjCCTpGtOD/jyBDulhWXEFyut6IsidWDn0XL8Hna?=
 =?us-ascii?q?gDG0xRJOVZAOL0f1rxp8=3D?=
X-Talos-MUID: 9a23:mEJ+9wqdG81Jg190ilMez3ZuDtZE0v2+NGwQl4hYg9HdFwhyMQ7I2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 13 Jun 2025 21:59:52 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPS id 9C4D9180001D2;
	Fri, 13 Jun 2025 21:59:52 +0000 (GMT)
X-CSE-ConnectionGUID: beiIqe7KSI+0d645qzGhCg==
X-CSE-MsgGUID: 8/248eUaQW2W9Vu9WBA+vA==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.16,234,1744070400"; 
   d="scan'208";a="29235335"
Received: from mail-bn7nam10lp2043.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.43])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 13 Jun 2025 21:59:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S3GSP3YVUleVtjwMbLrtqJYD+MRmh1jXtq7tAop1f5ntgil3J9UU5RDhgJhqfAINa2vSInaOlQhcxkbTdqNhUxmkYIRtwpc+Ta3P+9DP0ugPmMTh3AKhZm0t8a+Y5gzELjtcMzU9/4OMBbuy3h/NH8B+O9XEvloPMnXakUVp0qA4a+HfqX0oK6Dp7ZEy8X8vZDxCEU5SukpDrBJpSfyikMDWm1b/Nf/ve3tjTk6KUdrA2lOgb8ExQOsHezo7JPIHe1YEKBa+G4dLw63TMNiQAu3l6P61agcj0rf02IToURMpM43s1NisW6xo5fa1xkTlLnOAk5iW+Y5uWZ2eAkMvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/hrNcguLKEW9o4bXNZ1MV6XpMM5iWwpDUrZKezYuIs=;
 b=s8VFFLvD1gJXqASsEWErtX44s3SRBiIV0BHNCg7tA+4WpfWaAuycey4vNwGMbJca6beR6dj5B4uWHjG2tpUITCUTnoKvY7RNXXEyzCtGAu+PoINwhOiK+OAXXQHLHokck08GaL3Ei5UieWWUjiSguWbrWmxijeWJ3gXAz9/8/JyTjjeu48Fqg22b3m11KkQdzDFBlNFWDMRO0MjT9NXEuTT9WqGemL1nl/SLNH9+qB0edvu9R/SKtuAfR0Ka0Fi/+ivCV17esuv/GKefy/8I/Wfbcr1jVs1nh+NXnLGvbgzXK0OoG1h2TF3jhdpDbBbi6OgTIpRHwLlZ040hTWwFpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SN7PR11MB7592.namprd11.prod.outlook.com (2603:10b6:806:343::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.24; Fri, 13 Jun
 2025 21:59:49 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 21:59:49 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: John Meneghini <jmeneghi@redhat.com>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>, "Masa Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "revers@redhat.com" <revers@redhat.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link
 down
Thread-Topic: [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link
 down
Thread-Index: AQHb2+gh2qiqCptSFk+Aa/HWmBvPLLQBi7YAgAAV2cA=
Date: Fri, 13 Jun 2025 21:59:49 +0000
Message-ID:
 <SJ0PR11MB589646EBDF785F570E35E774C377A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250612221805.4066-1-kartilak@cisco.com>
 <20250612221805.4066-4-kartilak@cisco.com>
 <7a33bd90-7f1b-49ad-b24c-1808073f7f5e@redhat.com>
In-Reply-To: <7a33bd90-7f1b-49ad-b24c-1808073f7f5e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SN7PR11MB7592:EE_
x-ms-office365-filtering-correlation-id: 29bd4374-cc91-436d-c3ec-08ddaac59e2a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Ar5SD78ODLlbpwGExJqNRC/SbKE2tMU5C049W0jKE+wStTq9nFYEN2b6+BVS?=
 =?us-ascii?Q?mhnXwslL9ei5fIqTpB7EF5m2ykMmS/NqBORFrdgd/VA0Cvc8fZmb/v4aokig?=
 =?us-ascii?Q?yxVTIEbt576f7o2CvK7DxFZ66U3gEY/1Cae2qdC3A18PvovOSXgglXSWhHCK?=
 =?us-ascii?Q?HBKZBQlJbsBBxKZ99unaaqmjawqZbQCsB489k7HmoHvaMEe0MkQFskQsnbUf?=
 =?us-ascii?Q?kkMW9biqUkCCEgPrOYo3lrYiuvpDSHhiuYYrGVFq/tHw+XWoyXmvPfXvEiVo?=
 =?us-ascii?Q?umhaivsahlHtB8rdnsymiVrHbDVP6sXK9mJuC5EFD+e/8ysbhxTxceBzkAbw?=
 =?us-ascii?Q?bWNa5wMHFVzBiGfDEGYh5z40ZDGrIWMKz87qwOcQgklHiZtSGO+YDIAQt/7q?=
 =?us-ascii?Q?0zHNtIG1i9pX0/Brf99gfs5IGu9N2Az0EgQGweBJ9pXOg1oggkg8XUAOr8SF?=
 =?us-ascii?Q?F2uOJaHVtWdqjwnJbynBnTMf9vvQSIB8iHqXcJFUi1Vdt2uMMi8af2FQ2yF8?=
 =?us-ascii?Q?GTehtltDpcxBSjW+AUT5wvlNoxfwUsO6j7brIyw70OamO+g8grwInHctnA1y?=
 =?us-ascii?Q?MSqh9CyEBAxd2vtIDBw5us+pHUpWcKzYGKmcHfu7T4OuOMQ0o78T1nBKf7l6?=
 =?us-ascii?Q?Wxg/mOvIL5Jr9tm52msNZCPnAVmnrDjztMCvsTKhFMTV02c7R3NjLB/INVkH?=
 =?us-ascii?Q?oF9nf9VgE/sFpite9Abfon9Q4iDYvTNe2WdxfFWczAWBA3aoH0f0SmTpOzqg?=
 =?us-ascii?Q?S9y51JNA57qK+6L9yZNbwcxkGK4gDYtBVkFlSzAM/uY4BM2g+Y4l59Tx992Z?=
 =?us-ascii?Q?MUIkDGRccx+P0kfLoSYywIHhrY1TlRyR7ywJE5uHlG1JGa1Sh34tTIc84i20?=
 =?us-ascii?Q?hYnGh63BtnNtb+4JDo6j85zkbFydLRVir1Pg2CUPFONRnCaG2l+GivSqhSqY?=
 =?us-ascii?Q?MpZuM0kTxFwb3H//h8RvRrS0jsFRfndCHQpuuUSb4MB4Gp3y7b4OxqtxTpOH?=
 =?us-ascii?Q?mbywJmShbz4XeZjAk0MHJG+a0HIiOXhdtJjJQJSBU6ebN2GOdMHP8uti3jCQ?=
 =?us-ascii?Q?OdLCMEUTUviee9NkjQ3kbv9xu2/7o8YeK509kLx6GJ3hzKVBBuYXE9vONyfw?=
 =?us-ascii?Q?azzcfoPsndQW06OHgEqGf7QDN8FgLrzl5bcUZpq4IyzxT8I8bjo/cWc177hF?=
 =?us-ascii?Q?d4QhE2Yy7+8rasVaW888hXL27EJyZH4I1On/T1lASEHWspuflnMA/fxaVZVW?=
 =?us-ascii?Q?KMwHW01K2r5wYzY4eZzIh6JFNEtAdAtdoO7hm4nCY49f/hlb72UoISpC1RuG?=
 =?us-ascii?Q?Kf/Kwjgy4xa5QGWAypYIkexg4QBQqnHkViqMEbKIui2+Oc2VqT8y2pNbz7KJ?=
 =?us-ascii?Q?SIP2kr67jBDvpHl3U5hQj32VGniP1Whj1sSaSv7C98cJrIQUfNipUDV8Ol2S?=
 =?us-ascii?Q?SRAZqNQDVTRLkk36cs05Pk3rQREGtEc7vHs15pGHNacZotemvbxxXqkMB28V?=
 =?us-ascii?Q?Kfy5k+eKLjccPc4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?S5mDna8z+AIgYnVVOUd7YVW8h+4kFlNfRh0KSTOgU312X1fg4hPXAWGvRhSu?=
 =?us-ascii?Q?mxLnUewO9rUxTwlp6qWpdRM21OT6WyUpAg8uxmELIKdx99XLdbT5p8GI7HWT?=
 =?us-ascii?Q?6bMWyFYu1RcdrpIQXcDIfoKPqpFgCNBpuSlcRUkw3ZE6py8t4yFnmEVPWRpt?=
 =?us-ascii?Q?/nT/bqqD5sMTQbpWrUTNC1H3I6LKaDQL8SorJFbznS8BO57/89fvdb+cB231?=
 =?us-ascii?Q?pJd0tH8XVyBuwc2lHaJNzgYOmsnDsdXJSPy5mb/h42iEKI8arLPcl2DlJpn+?=
 =?us-ascii?Q?elgS1OHKm4fg8NrFVf0Xpk86Ny/bGFTcBaCsaSclt4G5qFu/rPw87HEou3Tu?=
 =?us-ascii?Q?tUEu+IP+m4oXQcQYhRwz13ULcD2+qH+OZK2xjUmldxg2H1CHlcW2ld7v/zpD?=
 =?us-ascii?Q?Ep6Bam56PvaKmrbFMI5BZ1Fc6CryhnyWTLukQ5o3xwFLGPxCiOUxchJ9ETA/?=
 =?us-ascii?Q?Fbk0vUpBUAyJCgbsGxBpH74K4dje/NpuRNEShwGfVzMcqBYfSkU415MnLZbR?=
 =?us-ascii?Q?tNRYUmlnFEiR/IEIoBVj8UuYQC2S4LxyHbqZA4ZPDZnnt1yeTbd3MiTHYYP4?=
 =?us-ascii?Q?3zcXtD14ZxoAGajwbiZMMewc6e6d4H0KnosJTehiYoipCXAjx/hmt0k4uglK?=
 =?us-ascii?Q?yn2bnigM6PdasYD3mKLk8ZcrxYJcHpTeRThSOHLkO9l3opWsUg7OTMYxfcJZ?=
 =?us-ascii?Q?yTJkZR1OhlBj7oMHFzw8T7ggPaKWlnm+PISXLvGZIzDPlJYqgwVXZru9u5Ur?=
 =?us-ascii?Q?OfD5/oGG+CKNGzzdJ95cqzEVjxGuqsggfNrPtILIlFETuZj2hIBfgJsUtlBy?=
 =?us-ascii?Q?S4yDF3p03kRF0F4A2NVLyKJe0uClDV4fyrrGeqzR6N78lNAgxmzFfwHok68A?=
 =?us-ascii?Q?y+xNzbel2wn1mUlPl7xWIE0jMm6Jn7TlMD1XrkzVEtwcgANmdtEoCOmrFZfL?=
 =?us-ascii?Q?UVSUvtUZ34N81bnF46OOy28g37xMZOMZNWMVsZfTWO4SoK6N/tJ1vf0RdEtm?=
 =?us-ascii?Q?tKROy1NwdDrbJ3bVWRqD9NruSW2FZwlIJSsrAmnMeic94NllrQ1orEOfipqy?=
 =?us-ascii?Q?SKafT7KeY4H4wWRv5w34tyVng6UoxvKWEgZV9ksZX8xlHFVNa5UkOZJfSyXy?=
 =?us-ascii?Q?VwjoQjZxjNDJgMmZbQhtXOARKT0mksdw6eN7BGa88NZlzYaKzzUD6p0btzfd?=
 =?us-ascii?Q?s+xlEbYVKiN4D+7unvVRZBapKnfi0pkoHIyFYW1aWShfNA+7rYo+mslqn6yf?=
 =?us-ascii?Q?OZLoyyKRCXBnjnAZJXoN5TELJjJKYb2QhVKcb3aBfF8H4QGlkEEaEmc+p9Ky?=
 =?us-ascii?Q?oeIS7pq+B951KktqMg4PgweAOcQpuNlhzoB/D3q5N2D2BYNikq0Y529QlDN0?=
 =?us-ascii?Q?OmgtZXjhE2zVTpyE6LH5qTF08M7S5t1gKi8nOPAah7hqmnO6tzma3xrIKYyW?=
 =?us-ascii?Q?uXRWFRonQOSs7pErjx0tAwqSJyVe8OV/IZ2H2+GeKHiNNigE9ivdDA4rFmbt?=
 =?us-ascii?Q?sHNPXsijaRpGjPnoKT/VF+NGLHmCq5MRjTAqul5T06lyeEVIQ9WeL/nXFQMy?=
 =?us-ascii?Q?Noy4N8Wi74EsYNtjvqjVGsI9tLDpIafxQ6buoHqB?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bd4374-cc91-436d-c3ec-08ddaac59e2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 21:59:49.5247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UgfrpYgksFG8PCA6bIHen9tGN+gNvu+qV6iqHXctcQppYTJmwl0tG13lcOcliCvPkZSaxljedMSZhX8mwaPdbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7592
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: rcdn-l-core-01.cisco.com

On Friday, June 13, 2025 1:29 PM, John Meneghini <jmeneghi@redhat.com> wrot=
e:
>
> Hi Karan.
>
> You've got two patches in this series with the same Fixes: tag.
>
> [PATCH v4 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI ti=
mes out
> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
>
> [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
>
> both of these patches modify the same file:
>
> drivers/scsi/fnic/fdls_disc.c
>
> So I recommend you squash patch 4/5 and patch 2/5 into one.
>
> Thanks,
>
> /John

Thanks for your proposal, John.

I'm a bit hesitant to squash them into one since each patch fixes unrelated=
 bugs.
The reason they have the same fixes tag is because we found two separate is=
sues in the same commit.

I get your concern, however. What do you think about the following?

Move this patch to the beginning and increment driver version to 1.8.0.1:
[PATCH v4 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI time=
s out

Move this patch to the next and increment driver version to 1.8.0.2:
[PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down

Move this patch to the next:
[PATCH v4 3/5] scsi: fnic: Add and improve logs in FDMI and FDMI ABTS paths

Ideally, I would have liked to squash this above patch with the first patch=
 in this series, since it's easier to debug if and when an issue occurs in =
that path.
I separated them since it would be easier to review. I could add a Fixes ta=
g here as well, but I'm not sure about that since they are just log message=
s,
and they are not really fixes.

Move this patch to the end:
[PATCH v4 1/5] scsi: fnic: Set appropriate logging level for log message

Regards,
Karan
