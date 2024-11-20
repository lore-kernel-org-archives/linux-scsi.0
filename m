Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA5E647;
	Wed, 20 Nov 2024 00:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732061048; cv=fail; b=IrBAxOWsMmQ8F4q+2EpXiUf6x6lr2b488QPvbZEcVOdnNkPz5KaQs+RDo+/dCjc8qXXcTErH/jcTVUQnije8r6DvMnSzbi781kXCbUkYeV0cufJsmBuqjJuzxrK+LxEU3DUaQPIN2BXCRMEnEbDJRlOTrYIsNOfHL7RlZ0ia3KI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732061048; c=relaxed/simple;
	bh=XRXduDgLyyoGUMz02ZookNqQAPppOcUxM4/qAckVqao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YzfXf3CmFZbzAnYc8piA/4L3maXAZgCBBTS+kBLX1YeyP29oKKEHpv5hkHei+SlSNB4bvDLQxTLxbV/7Wt07Yg0Y/NHca763GiM1QOCI14OyzVv0FMEvUdOprD7wmX1uBUQYtMZLonrrLiUqwh7NWJH00pQp0b+rubcuesY/xr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=gNEPBTca; arc=fail smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="gNEPBTca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=6250; q=dns/txt; s=iport;
  t=1732061046; x=1733270646;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XRXduDgLyyoGUMz02ZookNqQAPppOcUxM4/qAckVqao=;
  b=gNEPBTcawMOjVG5Of3qM8D7gQkkS7CyHmQrAM/hg4CrU4Nr1v9mTxMh8
   Al1oxJrMoAnkjw+MRtZHkTiuHMLbxojnB5QsqYuV3phBxZfNLoYPwcMxo
   ylKMCDjsSxZygFCh2aTE+A0gVq/SxglPNSK/n+LVCribRESBh0skcOo5l
   s=;
X-CSE-ConnectionGUID: oVGSuUCWT9mVgAZFayQ5Rw==
X-CSE-MsgGUID: NvflShFdRhqQxH4kAcRZJg==
X-IPAS-Result: =?us-ascii?q?A0ACAAD1Jj1nj48QJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVKCGUiEVYNMA4ROX4ZRgiEDgROdBBSBE?=
 =?us-ascii?q?QNWDwEBAQ0CRAQBAYUHAhaKPQImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBC?=
 =?us-ascii?q?wEBBQEBAQIBBwUUAQEBAQEBOQUOO4YIhloBAQEBAxIRBA1FEAIBCA4KAgImA?=
 =?us-ascii?q?gICLxUQAgQBDQUIGoJfgmUDAaYTAYFAAooren8zgQHgIIEaLgGISwGBbIN9h?=
 =?us-ascii?q?HcnG4INgRVCgjAHMT6EKhsVg0Q6gi8EgkF5hBYlTYdKaJpFCUl7HANZIREBV?=
 =?us-ascii?q?RMXCwcFY0YhLAOBeU5/gTaBUQFCgk5Kgy6BXgU3Cj+CSmlLNwINAjaCJH2CT?=
 =?us-ascii?q?4UXgQuDYWcvAwMDA4M8hGIdQAMLbT03FBsFBDp7BZ83RoM6FWVfAi59FxkXk?=
 =?us-ascii?q?z+DM0mPYZ9MCoQaoXkXhASNApV7g02YdyKjT4UMAgQCBAUCDwEBBoFnOoFbc?=
 =?us-ascii?q?BWDIlIZD44tDQnJPXg7AgcLAQEDCZFHAQE?=
IronPort-PHdr: A9a23:zHXs0RJSxD6KtTCX2tmcuVQyDhhOgF28FgcR7pxijKpBbeH+uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:LUbIAKouAYxa0u+2Da1ET853XxpeBmI1ZRIvgKrLsJaIsI4StFCzt
 garIBnXPPbcY2L9ft0iOYWx80gHupGGzNdjHFFkpSE1E38U9uPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9T8kiPngqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQXNNwJcaDpOt/va8UI355wehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0uFJLlpTy
 NcnFGEIUB+qtcy/0YvmcPY506zPLOGzVG8eknhkyTecCbMtRorOBv2Uo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtMYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUofaGZsIwRbG+
 Qoq+UzfHB8eD9yxxQCF60u8prPMtCjBaqAdQejQGvlC2wDLmTdJV3X6T2CTpfi/l177WN9FL
 UEQ0jQhoLJ090GxSNT5GRqirxasuh8aRsoVCOYh6SmTxafOpQWUHG4JSnhGctNOiSMtbTUu0
 lnMm5biAiZi9eXLD3mc7byT6zi1PED5MFPuewcDcyQ+/uTIn71iiyzAZ+RNGb+M0+fqTGSYL
 y+xkAAygLAajMgu3qq9/Ezajz/EmnQvZlBpjukwdjz5hj6VdLKYi5qUBU83BMuszbp1rHHd7
 RDoeODHsIji6K1hcgTWGI3h+5nyu5643MX02wIHInXY323FF4SfVY5R+ipiA0xiL9wJfzTkC
 GeK5lgLvMMKZCv1NP8mC25UNyjM5fW+fTgCfq2FBueinrArLWdrAQk3PxfJhDG3+KTSuf1nZ
 MzCGSpTMZrqIf86lGXtHbh1PU4DzSElzmSbXoHg0xmiyvKfYnXTIYrpw3PQBt3VGJis+V2Pm
 /4GbpPi40wGDIXWPHKNmaZNdg9iEJTOLcytwyChXrLYelI+cIzgYteNqY4cl3tNxv8Nz7uWp
 CDlASe1CjPX3BX6FOlDUVg6AJvHVpdkpnV9NispVWtEEVB6O+5DMI93m0MLQIQa
IronPort-HdrOrdr: A9a23:MCike69weegM09/pvBxuk+GXdr1zdoMgy1knxilNoENuA6+lfp
 GV/MjziyWUtN9IYgBfpTnhAsW9qXO1z+8S3WBjB8bSYOCAghrmEGgC1/qv/9SOIVyFygcw79
 YFT0E6MqyOMbEYt7e13ODbKadc/DDvysnB7omurQYJcegpUdAd0+4TMHfjLqQCfng8OXNPLu
 vl2iMonUvGRV0nKu6AKj0uWe/Fq9fXlJTgTyInKnccgjWmvHeD0pK/NwKX8Cs/flp0rIvK91
 KrryXJooGY992rwB7V0GHeq75MnsH699dFDMuQzuAINzTFkG+TFcRccozHmApwjPCk6V4snt
 WJiQwnJd5P53TYeXzwiQfx2jPnzC0l5xbZuBylaDrY0I7ErQABeo58bLFiA1zkAo0bzZdBOZ
 dwriekXlxsfEr9dWrGloD1vlpR5zqJSDIZ4J0uZjpkIMojgHs7l/1EwKuTe61wRx7S+cQpFv
 JjA9rb4+sTeVSGb2rBtm0q29C0WG8vdy32CXTql/blmgS+pkoJh3cw1YgahDMN5Zg9Q55L66
 DNNblpjqhHSosTYbhmDOkMTMOrAiiVKCi8fV66MBDiDuUKKnjNo5n47PE84/yrYoUByN83lI
 7aWF1VuGYucwblCNGI3pdM7hfRKV/NFwjF24Vb/dx0q7f8TL3kPWmKT00vidKpp7EFDsjSS5
 +ISeRr6j/YXBzT8KpyrnnDssNpWAsjueUuy6MGZ24=
X-Talos-CUID: =?us-ascii?q?9a23=3AIYJSFGj0l/+cqzfdkAR+jWcx8DJudUPy92rtCHC?=
 =?us-ascii?q?EWGNXR5SnZ1aBwf5ejJ87?=
X-Talos-MUID: 9a23:aW2/4QpJByx19KKrPysezxd8OsNT44qiMkAUqIUm58qtPhZCGTjI2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-06.cisco.com ([173.36.16.143])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 20 Nov 2024 00:03:44 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-06.cisco.com (Postfix) with ESMTPS id B2ABB18000114;
	Wed, 20 Nov 2024 00:03:44 +0000 (GMT)
X-CSE-ConnectionGUID: yd+wJXnQR2i7UI15Vb/OmQ==
X-CSE-MsgGUID: Qe7oGHLFQRCZIa1Elm5SeQ==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,168,1728950400"; 
   d="scan'208";a="19901588"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 20 Nov 2024 00:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RGR4FL4FDz/SrkeFM6LN7PUqwJpyaTxv6vrlq9wiqJIBwPqjt+xM39+9cTJz4QIZJz6oNz9/+dU8aE6pBMgpin2/xy6pYT4SdlEtmjmLtFW8RCIXRIIrgnXszd+LQXnrkUrFuSinQIvCBuPmsFDrtt1+54ReHfopEb3UD8+QuvU/Fz44MYBGvgn57J0b7/HiHyLzs83lPPQ2+okGjPDvJ8nXIL7cI51nTowjucRAyBHRrkVqZqR82dDaXb5br1wg0xYmC7p13OTEU5nxrKP8pnrJ/L2S87gAZy2l67FaTQwUr4O/XUM8+2ELG4lgY+IN+EZlHG2UJ74SG7SbSg6T9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRXduDgLyyoGUMz02ZookNqQAPppOcUxM4/qAckVqao=;
 b=qoHTiM4b2xlMiUHm8zcpxvjOS7f6VZUDZga+2qe3QUbPwv4NNHkU/6sD01V8D4k6KG48iFY/lOhkW+ZG6bnMoTpfEcRUIc5j1p7JJg1KXqPJdeIdIsKBE2bqlRYH8UWUOh4cXjGpVADYC4vjBL5/sU2hd1auds5Qq5Pa53sZNL2v7BHB/iRfvivwWFUyONKAogGvwPuGRwxooyjcKUmL08WyXxk4dMuXNkGH8P636Ax0kzck9Ut0ed+kKHzxClFFkTM8OY37UN4UfU7jxGt45flOj+Kr8Bo8e/3jfdc8hjjs7xP+AAOyVT81+InNh9tpPrMjtyJjW/tcZcYcMl8/5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SA2PR11MB4777.namprd11.prod.outlook.com (2603:10b6:806:115::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Wed, 20 Nov
 2024 00:03:42 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%6]) with mapi id 15.20.8158.021; Wed, 20 Nov 2024
 00:03:42 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@suse.de>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>, "Masa Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 09/14] scsi: fnic: Modify IO path to use FDLS
Thread-Topic: [PATCH v5 09/14] scsi: fnic: Modify IO path to use FDLS
Thread-Index: AQHbIXmydO7YoK2wI0+5Z7qfLOXk9bKVgwIAgAdyzxCAIoTMwA==
Date: Wed, 20 Nov 2024 00:03:42 +0000
Message-ID:
 <SJ0PR11MB5896CBD4F94402C6615520A0C3212@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20241018161409.4442-1-kartilak@cisco.com>
 <20241018161409.4442-10-kartilak@cisco.com>
 <6a66c3ec-1b43-44ce-a3ab-65ec794a2dc6@suse.de>
 <SJ0PR11MB58961895AF8525FCE32DA301C34B2@SJ0PR11MB5896.namprd11.prod.outlook.com>
In-Reply-To:
 <SJ0PR11MB58961895AF8525FCE32DA301C34B2@SJ0PR11MB5896.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SA2PR11MB4777:EE_
x-ms-office365-filtering-correlation-id: 6a7465f8-5f74-4774-77a0-08dd08f6cb86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RzJlM2lrVEdhcS90K254SFNnS3dBcTlkRm9YdThNSFVObCs0N2NxMGhTb1Bk?=
 =?utf-8?B?WG01MEFWc3RIdTF0UUxWNit2enROYlF3M2pvenJidVhyR3BOejNqUEhoZHhM?=
 =?utf-8?B?NlJjaVE0QlZ4cXdvOVlsZWxDL3BOUlRxN3NSN2k5WnhNWHBBWUdxclhuVjZK?=
 =?utf-8?B?V0xza3EyYTVQMmRTWEJLZ2tqNWtFeUxwRDNydjZLRXI0M0NEUFlhK29BZ3Ux?=
 =?utf-8?B?T0ZZbkM2Z0dOR0NRakp1NkYwSGhDajRlQ3M2QWpKN2QvZk44ZVF2czNyZXpT?=
 =?utf-8?B?d3JsMnlTYVlVWUs0MUF1WjNjVG9wV2t1c0FvQmZPVElkUkZMMXhSN0ltTVp6?=
 =?utf-8?B?b1d2d21IcmhyRDM4bnRzQ3U4VWhNL3lWc2QxNVNjRWtFY2ZtU1lCbSt5TEdx?=
 =?utf-8?B?QUQ1cXpXTmxZak4xN0thOStKNVNEQk83T3hQZEJvWVNBR2pldjRPNXF4b0NZ?=
 =?utf-8?B?UmZ2SDRVVnN6eHgzQXg0OGlvUkYvUzQ2VUd4OTQ0dFpTUHdqSDhCMlVHTS9n?=
 =?utf-8?B?em5rSTdMSlBBQ3JoQVBOd0JWYWlkcDJCTWhleTI1RXNqNWJmK2JwMlRIMWRx?=
 =?utf-8?B?aUlqOGpCSk1nVVJTT3hKOWNjdlE0cmpaRzJQY0ZTZmVITlFDU282ZEhBbURF?=
 =?utf-8?B?T0czZWkzZCt4YWxiTDJIckE0NTRMeVI1SCtPNThyMzNYSHdMcXV6TlBuSzJ1?=
 =?utf-8?B?SklBTXVHa05OdzcrZkI3ZG1naldjWHRVWWhrVnpVNnRjOXpZd09FUTZGSmxm?=
 =?utf-8?B?VVJpZFNyMXVseTNHQU9IQ3Vlbi9nNWZzT2ZZdng4SjVMSmVBRFZaQk5hV1dL?=
 =?utf-8?B?ci9PQ0U5cnpsZm5zVStqaGdLdHQ1dUhIdnhJTGJlM040aWg5T1htNWcvQmZs?=
 =?utf-8?B?QmtoWTVLMXlQMlRFL3drSCthaEtSVVZoWHlabythdjlWTjBJMEhmRVpnTXJ3?=
 =?utf-8?B?a0s4MnkyTXptRHBrK0NGSEpndThUcFpuYnphWDYzaDd5UHBqSWxqQmNvdTVV?=
 =?utf-8?B?Ym82MjV4RWt2ellPeThzdVl4NSt2c1hZVFZROURYUFZwYTYzWFBhZ2ZVNGhT?=
 =?utf-8?B?K1dNQ2lBck9qRGc1czRUK0xIZk1xaUZ5VG55MlFLVEpmQlR0NkZIQXhua2F2?=
 =?utf-8?B?STR0VXkybStTMDF3N0Q5UXhJMFRldTZ2MmQyOHd6dnlwdnRUYWdSYzJEMCtq?=
 =?utf-8?B?SDJTQ3BsVDlMNUdGSUFZRFg2Q2dGckVsWnd6cjRnbVhUWHllVHJqUld5UG92?=
 =?utf-8?B?VkM4eS93M0hiQlFNYkdSNkVBTUtEWm01Q2FhY01HNDZlODIxTTh3UEphOFgx?=
 =?utf-8?B?UmlXWUsyOFRiNXJjWFg0VUtFK1dDQSt5Skxrb1A2SUtNYThJeUJNa1JzR2Jz?=
 =?utf-8?B?bWg4THZkMS9GdWlhSjcxclViTDY3RnJzQURXSFZzaHczNEZ6Y3diajR3RXZk?=
 =?utf-8?B?YjdCV2x0VUhnZWJveWxreWJMbWdBN1pXMGlSS1hjSzlSM2ovaStqcVAwdnI1?=
 =?utf-8?B?R3Z4dExicVZTb294b0REVW1tTHdLMFFDalFVUnBRb214VUFHd1V0RE1tZUVD?=
 =?utf-8?B?MDl3Mlc3VXBvOU8yY00wY3RaRkhSTUwxdUlxWjJWZjBmQzlkZzZ4UERUVWZ2?=
 =?utf-8?B?ZkVXazBpWHhlZ0dEby9keGZ5U0NMaUs3U2VEMUQra3psbXdoZ3NMUEtuNFBo?=
 =?utf-8?B?WGRaTG9wR213aUtPaWpkUXFNSERsZ3hHdkEzTW9VUjQvbHE3TjN0RG5RbnNx?=
 =?utf-8?B?RTkrb2huS0NDWWpnM1kwa0ticUkvZzgxWEl6aGxuR1orSkw4dE1adEZEdnlv?=
 =?utf-8?Q?8PlhVTcoP4iF3udJNaNE12VACxqoYUYkzEJ/0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VzBuUlNTT0pWbEdyZkp1NDZWRzlvaXhFVW8wTWVNQi9zVEgwUFlMZWFEUWNi?=
 =?utf-8?B?L1F3YUN1MXhVRXFHZ3VMMXdSbStlZFVhQ09sWk80dzlGZEN2ZU1QUnBRTmZs?=
 =?utf-8?B?TmFsLytmQkRmdHY5YWYvY1ViY0hSOGJiczh2OEZuS1hhWC9uTDkrOFNyM05r?=
 =?utf-8?B?NUpOQnArU09aR2lxTUZOVWdhUXFLVkZ0SG94Y01aaDRJSmRsWjhGcnRMaUFD?=
 =?utf-8?B?d3Q4NjR5SFBaNE9jM3VqMGg4L0lLZXM5K1YrS25TZC9BazlKZE5WYy9aVUtu?=
 =?utf-8?B?VXduM08veDJzUTBUNlI4YUc2ZlF0RU1WWWRKM20yd0o2VlFpU1UzR1l6NW4y?=
 =?utf-8?B?OXRTL1hhTG51alo0bXNJamh6SjArWVNtcGxPWnRXWWtnQnB0TWdQUlNsQ1lX?=
 =?utf-8?B?N3QyOElFVHNHQkM4eE5KcmJiSEhzV2o5aXV1R1d4UE5rTjhZeGFVbWpxQXpC?=
 =?utf-8?B?Rm5oUnFQOGRUYXk4REhmQktRb1BjYmFwT3BtNGF3cGQvRUNqMzQ5RFVkVjhG?=
 =?utf-8?B?bFFPMGdWYytEanltOUp2bXNTYzBUT2VDMlI0Wjl4WXV4K0RhWWlWYUdFc3hq?=
 =?utf-8?B?ekRKQmUwQkMrYWRMdFJ1eW1YaGh5WVdEYU4vbkI1MVFSV2M3dUV3amJQZG02?=
 =?utf-8?B?YTZvWDZZWmFXbWd3ZUFjbTA1eUwxdDdnTU11NWk1Rk1kQjJqOWdOWUNPWlZR?=
 =?utf-8?B?SXNSRk5xaDlWZDBtWjRLOFdmRGdQbmM0WURTcCs1OGVSY2k0V1I1V3dBTEhV?=
 =?utf-8?B?N1Z6aXFSSnZCRk5iK1J1THNiTlJrdncwbEkwcEFDU3g0UEpYbGNJdnIrWTRP?=
 =?utf-8?B?V2pkWnhZa3BzUmhoaVdLUFdBZ1VIWVUvU3VyZmwvMkFQS1ZsVzhTOXlDTkQ1?=
 =?utf-8?B?dmxKMlE3UmRJQ2twUisyckRwb09LRGIzbisvT2QzVElYL3NJUU9NYmpMaWpk?=
 =?utf-8?B?ZnNGYk5PZm5QOWpCMWVUS3NVeDJuaWpYcGlMbUVVOGQva0Rja0lTYXVMaFk3?=
 =?utf-8?B?eU9zYWo5bmRKNHBZd3F1Ukx2UVR4NnV0UEtRMDh3bmVSdFIyNmNTbm90V1RJ?=
 =?utf-8?B?Y0RSZURid0tsMTFWNnRsVjFQQmRXMHhLS1dIQ2wzR1FnVk96WUZyUlR0NGE2?=
 =?utf-8?B?YmswS1RjN04wK1RhZW03c2h6d3hlS0NkS2NwT0JucnFDWDJDVHBTdEpTS2dU?=
 =?utf-8?B?NUtkdStibFJBUjgyZkxOUmV5VndvcGE3L05KenhOMVNjSVpGamo1MzFEeWI0?=
 =?utf-8?B?RnhiV3lTaEVxZDZMYXdLRjhPNnpUWW96bEJFZ0dONHF4ZkU2N0hmOE5wTTV3?=
 =?utf-8?B?bmlaZEN6VW9MVHUxZGp3WjBUU20yZEZDdGU3blZha3Z4SFh6a3BFUzFQMWxP?=
 =?utf-8?B?dXpNV3Z2UGNKeTlqRzU1ZFVxMjlCcExwamNJZWV2ejQ1OEl0YkZkY2svbTZx?=
 =?utf-8?B?MUZERFBhZFMvUnJ5YVhiMEllZXhOV1VPRHZyczhnUCtSU2xVZVJRSFpQcjNm?=
 =?utf-8?B?cVpoSmYzdFBaTmJnMlhPb3pNejhWWE9FK0NtOTIyVTNsSVhaMGRlN1RRUXJT?=
 =?utf-8?B?N3VGeXExRlB4MytrSUFndVZZa0c0ZG9TWWllc0o4NWNpMmVqaWNML3haYkNH?=
 =?utf-8?B?bkVmU1N6QmVaL05IVVhMZFV6azRlNGttS0RGREtvMUc5SFVIWTZ1eUh4RXRR?=
 =?utf-8?B?OGRVV3RHcktTamxYTWtjTW8wYUFOU2RES09Xbm5FTGQ5TWlDamdwYXBNaWpB?=
 =?utf-8?B?QVRtQzh0OFZOa215aUFUV09Ddkwza0VtVTl2K0YwRUtNcVpsaktFdkFhVTBp?=
 =?utf-8?B?YU1mVEZSMTExbzg4Y2pudmZEM1lvZEhIdmQ4cTdpTzgxcUg5a3pzNnFpNUht?=
 =?utf-8?B?VUpjSGwvMW5Zd0k2QytiMGpyUDIxZFNuZXVxQm5ScXVoc0JWQWlBd3NSVFZN?=
 =?utf-8?B?dnZqSjNCTEdvZW5KNVpIbUNQZ1dwckZ4MkJqYm83cjkxRXdiL3k4NzVzREF2?=
 =?utf-8?B?OXV4NExLVEFMdXVEQkl2QU10ZFJyQTRCWmwxWXNjbGpkd1JQV1ByMy9LemJ4?=
 =?utf-8?B?V3BzYmI2VHprd1lLRlJVcnpEa0hlVUsvOXo1akFSM0Jqa091Y0NhbGo2NmhY?=
 =?utf-8?Q?9m9dCU/E8lTZVjrreVHoXpoxJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7465f8-5f74-4774-77a0-08dd08f6cb86
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2024 00:03:42.5562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ELmA3wCH3fvZxbZoXhosdO+bB660E8Ml6obT1p7GXTPTmr5TQoh5OPutLIoA4NxY0ecGOVW2Z++I7ExSb4Obxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4777
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-06.cisco.com

T24gTW9uZGF5LCBPY3RvYmVyIDI4LCAyMDI0IDU6NTUgUE0sIEthcmFuIFRpbGFrIEt1bWFyIChr
YXJ0aWxhaykgd3JvdGU6DQo+IA0KPiBPbiBUaHVyc2RheSwgT2N0b2JlciAyNCwgMjAyNCAxMjow
NSBBTSwgSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+IHdyb3RlOg0KPiA+IA0KPiA+IE9u
IDEwLzE4LzI0IDE4OjE0LCBLYXJhbiBUaWxhayBLdW1hciB3cm90ZToNCj4gPiA+IE1vZGlmeSBJ
TyBwYXRoIHRvIHVzZSBGRExTLg0KPiA+ID4gQWRkIGhlbHBlciBmdW5jdGlvbnMgdG8gcHJvY2Vz
cyBJT3MuDQo+ID4gPiBSZW1vdmUgdW51c2VkIHRlbXBsYXRlIGZ1bmN0aW9ucy4NCj4gPiA+IENs
ZWFudXAgb2Jzb2xldGUgY29kZS4NCj4gPiA+IFJlZmFjdG9yIG9sZCBmdW5jdGlvbiBkZWZpbml0
aW9ucy4NCj4gPiA+IA0KPiA+ID4gUmV2aWV3ZWQtYnk6IFNlc2lkaGFyIEJhZGRlbGEgPHNlYmFk
ZGVsQGNpc2NvLmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBBcnVscHJhYmh1IFBvbm51c2FteSA8
YXJ1bHBvbm5AY2lzY28uY29tPg0KPiA+ID4gUmV2aWV3ZWQtYnk6IEdpYW4gQ2FybG8gQm9mZmEg
PGdjYm9mZmFAY2lzY28uY29tPg0KPiA+ID4gUmV2aWV3ZWQtYnk6IEFydW4gRWFzaSA8YWVhc2lA
Y2lzY28uY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogS2FyYW4gVGlsYWsgS3VtYXIgPGthcnRp
bGFrQGNpc2NvLmNvbT4NCj4gPiA+IEBAIC0yMjc0LDExICsyNDk0LDExIEBAIHN0YXRpYyBpbnQg
Zm5pY19jbGVhbl9wZW5kaW5nX2Fib3J0cyhzdHJ1Y3QgZm5pYyAqZm5pYywNCj4gPiA+ICAgaW50
IGZuaWNfZGV2aWNlX3Jlc2V0KHN0cnVjdCBzY3NpX2NtbmQgKnNjKQ0KPiA+ID4gICB7DQo+ID4g
PiAgIAlzdHJ1Y3QgcmVxdWVzdCAqcnEgPSBzY3NpX2NtZF90b19ycShzYyk7DQo+ID4gPiAtCXN0
cnVjdCBmY19scG9ydCAqbHA7DQo+ID4gPiAgIAlzdHJ1Y3QgZm5pYyAqZm5pYzsNCj4gPiA+ICAg
CXN0cnVjdCBmbmljX2lvX3JlcSAqaW9fcmVxID0gTlVMTDsNCj4gPiA+ICAgCXN0cnVjdCBmY19y
cG9ydCAqcnBvcnQ7DQo+ID4gPiAgIAlpbnQgc3RhdHVzOw0KPiA+ID4gKwlpbnQgY291bnQgPSAw
Ow0KPiA+ID4gICAJaW50IHJldCA9IEZBSUxFRDsNCj4gPiA+ICAgCXVuc2lnbmVkIGxvbmcgZmxh
Z3M7DQo+ID4gPiAgIAl1bnNpZ25lZCBsb25nIHN0YXJ0X3RpbWUgPSAwOw0KPiA+ID4gQEAgLTIy
ODksMzEgKzI1MDksNjEgQEAgaW50IGZuaWNfZGV2aWNlX3Jlc2V0KHN0cnVjdCBzY3NpX2NtbmQg
KnNjKQ0KPiA+ID4gICAJREVDTEFSRV9DT01QTEVUSU9OX09OU1RBQ0sodG1fZG9uZSk7DQo+ID4g
PiAgIAlib29sIG5ld19zYyA9IDA7DQo+ID4gPiAgIAl1aW50MTZfdCBod3EgPSAwOw0KPiA+ID4g
KwlzdHJ1Y3QgZm5pY19pcG9ydF9zICppcG9ydCA9IE5VTEw7DQo+ID4gPiArCXN0cnVjdCBycG9y
dF9kZF9kYXRhX3MgKnJkZF9kYXRhOw0KPiA+ID4gKwlzdHJ1Y3QgZm5pY190cG9ydF9zICp0cG9y
dDsNCj4gPiA+ICsJdTMyIG9sZF9zb2Z0X3Jlc2V0X2NvdW50Ow0KPiA+ID4gKwl1MzIgb2xkX2xp
bmtfZG93bl9jbnQ7DQo+ID4gPiArCWludCBleGl0X2RyID0gMDsNCj4gPiA+ICAgDQo+ID4gPiAg
IAkvKiBXYWl0IGZvciBycG9ydCB0byB1bmJsb2NrICovDQo+ID4gPiAgIAlmY19ibG9ja19zY3Np
X2VoKHNjKTsNCj4gPiA+ICAgDQo+ID4gPiAgIAkvKiBHZXQgbG9jYWwtcG9ydCwgY2hlY2sgcmVh
ZHkgYW5kIGxpbmsgdXAgKi8NCj4gPiA+IC0JbHAgPSBzaG9zdF9wcml2KHNjLT5kZXZpY2UtPmhv
c3QpOw0KPiA+ID4gKwlmbmljID0gKigoc3RydWN0IGZuaWMgKiopIHNob3N0X3ByaXYoc2MtPmRl
dmljZS0+aG9zdCkpOw0KPiA+ID4gKwlpcG9ydCA9ICZmbmljLT5pcG9ydDsNCj4gPiA+ICAgDQo+
ID4gPiAtCWZuaWMgPSBscG9ydF9wcml2KGxwKTsNCj4gPiA+ICAgCWZuaWNfc3RhdHMgPSAmZm5p
Yy0+Zm5pY19zdGF0czsNCj4gPiA+ICAgCXJlc2V0X3N0YXRzID0gJmZuaWMtPmZuaWNfc3RhdHMu
cmVzZXRfc3RhdHM7DQo+ID4gPiAgIA0KPiA+ID4gICAJYXRvbWljNjRfaW5jKCZyZXNldF9zdGF0
cy0+ZGV2aWNlX3Jlc2V0cyk7DQo+ID4gPiAgIA0KPiA+ID4gICAJcnBvcnQgPSBzdGFyZ2V0X3Rv
X3Jwb3J0KHNjc2lfdGFyZ2V0KHNjLT5kZXZpY2UpKTsNCj4gPiA+ICsNCj4gPiA+ICsJc3Bpbl9s
b2NrX2lycXNhdmUoJmZuaWMtPmZuaWNfbG9jaywgZmxhZ3MpOw0KPiA+ID4gICAJRk5JQ19TQ1NJ
X0RCRyhLRVJOX0RFQlVHLCBmbmljLT5scG9ydC0+aG9zdCwgZm5pYy0+Zm5pY19udW0sDQo+ID4g
PiAtCQkiZmNpZDogMHgleCBsdW46IDB4JWxseCBod3E6ICVkIG1xdGFnOiAweCV4IGZsYWdzOiAw
eCV4IERldmljZSByZXNldFxuIiwNCj4gPiA+ICsJCSJmY2lkOiAweCV4IGx1bjogJWxsdSBod3E6
ICVkIG1xdGFnOiAweCV4IGZsYWdzOiAweCV4IERldmljZSByZXNldFxuIiwNCj4gPiA+ICAgCQly
cG9ydC0+cG9ydF9pZCwgc2MtPmRldmljZS0+bHVuLCBod3EsIG1xdGFnLA0KPiA+ID4gICAJCWZu
aWNfcHJpdihzYyktPmZsYWdzKTsNCj4gPiA+ICAgDQo+ID4gPiAtCWlmIChscC0+c3RhdGUgIT0g
TFBPUlRfU1RfUkVBRFkgfHwgIShscC0+bGlua191cCkpDQo+ID4gPiArCXJkZF9kYXRhID0gcnBv
cnQtPmRkX2RhdGE7DQo+ID4gPiArCXRwb3J0ID0gcmRkX2RhdGEtPnRwb3J0Ow0KPiA+ID4gKwlp
ZiAoIXRwb3J0KSB7DQo+ID4gPiArCQlGTklDX1NDU0lfREJHKEtFUk5fRVJSLCBmbmljLT5scG9y
dC0+aG9zdCwgZm5pYy0+Zm5pY19udW0sDQo+ID4gPiArCQkgICJEZXYgcnN0IGNhbGxlZCBhZnRl
ciB0cG9ydCBkZWxldGUhIHJwb3J0IGZjaWQ6IDB4JXggbHVuOiAlbGx1XG4iLA0KPiA+ID4gKwkJ
ICBycG9ydC0+cG9ydF9pZCwgc2MtPmRldmljZS0+bHVuKTsNCj4gPiA+ICsJCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJmZuaWMtPmZuaWNfbG9jaywgZmxhZ3MpOw0KPiA+ID4gKwkJZ290byBmbmlj
X2RldmljZV9yZXNldF9lbmQ7DQo+ID4gPiArCX0NCj4gPiA+ICsNCj4gPiA+ICsJaWYgKGlwb3J0
LT5zdGF0ZSAhPSBGTklDX0lQT1JUX1NUQVRFX1JFQURZKSB7DQo+ID4gPiArCQlGTklDX1NDU0lf
REJHKEtFUk5fSU5GTywgZm5pYy0+bHBvcnQtPmhvc3QsIGZuaWMtPmZuaWNfbnVtLA0KPiA+ID4g
KwkJCQkJICAiaXBvcnQgTk9UIGluIFJFQURZIHN0YXRlIik7DQo+ID4gPiArCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZmbmljLT5mbmljX2xvY2ssIGZsYWdzKTsNCj4gPiA+ICAgCQlnb3RvIGZu
aWNfZGV2aWNlX3Jlc2V0X2VuZDsNCj4gPiA+ICsJfQ0KPiA+ID4gKw0KPiA+ID4gKwlpZiAoKHRw
b3J0LT5zdGF0ZSAhPSBGRExTX1RHVF9TVEFURV9SRUFEWSkgJiYNCj4gPiA+ICsJCSh0cG9ydC0+
c3RhdGUgIT0gRkRMU19UR1RfU1RBVEVfQURJU0MpKSB7DQo+ID4gPiArCQlGTklDX1NDU0lfREJH
KEtFUk5fRVJSLCBmbmljLT5scG9ydC0+aG9zdCwgZm5pYy0+Zm5pY19udW0sDQo+ID4gPiArCQkJ
CQkgICJ0cG9ydCBzdGF0ZTogJWRcbiIsIHRwb3J0LT5zdGF0ZSk7DQo+ID4gPiArCQlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZmbmljLT5mbmljX2xvY2ssIGZsYWdzKTsNCj4gPiA+ICsJCWdvdG8g
Zm5pY19kZXZpY2VfcmVzZXRfZW5kOw0KPiA+ID4gKwl9DQo+ID4gPiArCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJmZuaWMtPmZuaWNfbG9jaywgZmxhZ3MpOw0KPiA+ID4gIA0KPiA+IFBsZWFzZSBj
aGVjayBpZiByZXR1cm5pbmcgRkFTVF9JT19GQUlMIGhlcmUgd291bGRuJ3QgYmUgYSBiZXR0ZXIg
b3B0aW9uLg0KPiA+IE1vc3Qgb2YgdGhlIHRpbWUgYSBkZXZpY2UgcmVzZXQgaXMgdHJpZ2dlcmVk
IGJ5IGEgY29tbWFuZCB0aW1lb3V0LCB3aGljaA0KPiA+IHR5cGljYWxseSBoYXBwZW5zIGR1ZSB0
byBhIHRyYW5zcG9ydCBpc3N1ZSAoZWcgbGluayBpcyBkb3duIG9yIHNvbWV0aGluZykuDQo+ID4g
U28gcmV0dXJuaW5nICdGQUlMRUQnIHdpbGwganVzdCBlc2NhbGF0ZSB0byBob3N0IHJlc2V0LCBh
bmQgdGhhdCBjYW4gDQo+ID4gdGFrZSBmb3IgYSByZWFsbHkgbG9uZyB0aW1lIHRyeWluZyB0byBh
Ym9ydCBhbGwgY29tbWFuZHMuDQo+IA0KPiBUaGFua3MgZm9yIHlvdXIgaW5zaWdodHMgSGFubmVz
Lg0KPiBXZSdyZSBpbnZlc3RpbmcgdGhpcyBjdXJyZW50bHkuDQo+IA0KDQpUaGFua3MgYWdhaW4g
Zm9yIHRoaXMgY29tbWVudCwgSGFubmVzLg0KDQpXZSByZXZpZXdlZCB0aGlzIGludGVybmFsbHkg
YW5kIGFzIHdlIHVuZGVyc3RhbmQgaXQsIA0KcmV0dXJuaW5nIGEgRkFTVF9JT19GQUlMIHN0YXR1
cyB3b3VsZCBjb21wbGV0ZSB0aGUgc2NzaV9jbW5kLiANClRoaXMgd291bGQgY2F1c2UgaXNzdWVz
IGlmIHRoZSBJTyBpcyBzdGlsbCBhY3RpdmUgaW4gZmlybXdhcmUuIA0KV2UgZG8gdGFrZSBjYXJl
IG9mIGNsZWFuaW5nIHVwIHN1Y2ggSS9PcyBpbiB0aGUgaGlnaGVyIGVycm9yIA0KZXNjYWxhdGlv
biBwYXRoIChob3N0IHJlc2V0KSB0aG91Z2gsIHdoaWNoIHdvdWxkIGJlIGluZHVjZWQgDQpieSBy
ZXR1cm5pbmcgdGhlICdGQUlMRUQnIHJldHVybiBzdGF0dXMgaGVyZS4gDQoNClJlZ2FyZHMsDQpL
YXJhbg0K
