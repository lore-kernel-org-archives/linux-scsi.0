Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786BE20767F;
	Fri, 10 Jan 2025 09:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736501839; cv=fail; b=Zc2+gJnIsQLaky0T50s8at3DXRm20ftKQeBW+5iUYnBsObJi2a/9lzpcnfeqGKXb7msERakF+IwfiP6oodRGtgKPp1w05SytUu5BdHQwyufk5nMjvsJWXHODiDMQC7nStDbqTUlNV4rLVFe1miKcRKX0zXF2rmkpeto6A5xmBO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736501839; c=relaxed/simple;
	bh=HnJMK+STViQwjq8bonb+GefH1E+C/MT0R+zjmlMoYQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BCkanEJcE4sNvDUMeEF4FH6SmQ2OHE4+OtuGmVmBeMc8kVhA8197T8aHozHBezfDmERq6eR7AO9YdjDc44W5g5VcXOIkfs7rabQ2LxKucUYlSyca5PyiGj+P3istF31OBx3WvAOT8Mm2m2kLDB0eA7mT6Tve1+KNdEdDqXtkJio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Xaar7oRS; arc=fail smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Xaar7oRS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2160; q=dns/txt; s=iport;
  t=1736501837; x=1737711437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7B3B4tqNBxH4dLXzmMm3CxJZg4NTUJaI03Mcd/EQty8=;
  b=Xaar7oRSzEssMUOJ9i7XL4FDCk87I1NWfw+nPKp1ZAbqiY04NQxTWVQh
   niQuPUJ5SH9YFukaYBccluww2z8mfxbSJukkNLZ43ezcM7sU7rdKY9wR6
   6PIkGvoiufwzGykdNLNFTPaUWg3O7LOBZWQpXF1VZ/QzqlCEeJTOY1REy
   s=;
X-CSE-ConnectionGUID: jT34K6dxR7623bZTTp4jNw==
X-CSE-MsgGUID: VBEf1hOqTq+uZr0MjF4fkA==
X-IPAS-Result: =?us-ascii?q?A0CaAQA46YBnj4//Ja1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEugXJSghlIiCEDhS2GUYIhA6AWDwEBAQ0CRAQBAYUHAop0AiY4EwECBAEBA?=
 =?us-ascii?q?QEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFFAEBAQEBATkFSYYIhloBAQEBA?=
 =?us-ascii?q?xIoPxACAQgYHhAxJQIEDgUIGoJfgmUDAadRAYFAAooreIE0gQHgIIFIiE4Bh?=
 =?us-ascii?q?WuEdycbgg2BFUJ5gT4xPoRFhBOCLwSCM0uBKoJZZ55KUnscA1ksAVUTFwsHB?=
 =?us-ascii?q?YEpHysDgRQmgSkFNQo3OoIMaUk3Ag0CNYIefIIrgiGCO4RHYS8DAwMDgzqFZ?=
 =?us-ascii?q?YIXgWgDAxYTgzUPHUADC209NxQbBQSBNQWbETyDb1GBCoFdAQYPlAoCgmiwA?=
 =?us-ascii?q?AqEG6F8F6pTmHyjX4UkAgQCBAUCDwEBBoF+I4FbcBWDIlIZD44tDQm7d3g8A?=
 =?us-ascii?q?gcLAQEDCZEeAQE?=
IronPort-PHdr: A9a23:kv36ixbjVD5tn5lY3TyJSPD/LTAchN3EVzX9orIuj7ZIN6O78IunZ
 QrU5O5mixnCWoCIo/5Hiu+Dq6n7QiRA+peOtnkebYZBHwEIk8QYngEsQYaFBET3IeSsbnkSF
 8VZX1gj9Ha+WXU=
IronPort-Data: A9a23:jVsU76q5LdE/j3MJx9cbHj2xLbpeBmI1ZRIvgKrLsJaIsI4StFCzt
 garIBmDMv2LYWX8Loh/bN+18BxV7JaEnd5jTVA6+CA2QS5H9ePIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9T8kiPngqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQXNNwJcaDpOtvra8Us35ZwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0uRLWj1tq
 /AIEm9TNEuJtd6K2O65bPY506zPLOGzVG8ekmtrwTecCbMtRorOBv2Uo9RZxzw3wMtJGJ4yZ
 eJANmEpN0uGOUASfA5LU/rSn8/w7pX7Wz5Rsk6UoaM0y2PS1wd2lrPqNbI5f/TWHJwPwRzD+
 zuuE2LRPDs3OoWf7iO56zGxtPWXuCHVBIwRPejtnhJtqAbOnjNIUkJ+uUGAif24jFOuHtFSM
 UoZ/gIwoqUosk+mVN/wW1u/unHslhodXcdAVvYx8wCl1KXZ+UCaC3ICQzoHb8Yp3PLaXhQw3
 VOP2tesDjt1vfjNFzSW96yfqnW5Pi19wXI+iTEsTzdev/q9rJEJ0UyVFdxRLJKt0t/TBmSlq
 9yVlxQWi7IWhM8N8qy0+1Hbnj6hzqQlqCZrvW07uUr7tWtEiJ6ZWmC+1bTMAR99wGelorup4
 SNsdyu2tbxm4XSxeMqlG7pl8FaBvKntDdEkqQQzd6TNDhz0k5JZQahe4StlOGBiOdsedDnib
 Sf74FwKusMPYyb2MfMpM+pd7vjGK4C9SrwJsdiJP7JzjmRZLlXvENxGPBTJhj6xwCDAb4lga
 c/BKq5A8kr2+Yw8kWLpHL1CuVPa7is/3mjUDYvq1Aiq1KHWZXieD9843KimMIgEAFe/iFyNq
 b53bpLSoz0GCb2WSneMq+Y7cwtVRUXX8Liq8KS7gMbfeVI+QAnMypb5ndscRmCSt/8Myb6Qp
 i3iBBQwJZiWrSSvFDhmo0tLMdvHdZ1+tnk8eycrOD6VN7ILO+5DMI93m0MLQIQa
IronPort-HdrOrdr: A9a23:X0YboaNArGrw28BcT47255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
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
X-Talos-CUID: =?us-ascii?q?9a23=3AjuJXx2uadNdAAS5mHwKQ9aMm6IsnTiaB7yncM3X?=
 =?us-ascii?q?nVzwyQo+pdUfM+oV7xp8=3D?=
X-Talos-MUID: 9a23:AZ7IXAZtdIZXbeBTiRXBimhiE95U+uezOlpVtJco58eHHHkl
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Jan 2025 09:37:10 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPS id 6C54318000251;
	Fri, 10 Jan 2025 09:37:10 +0000 (GMT)
X-CSE-ConnectionGUID: 1QGSjt5FQZCY72zmaPmzzA==
X-CSE-MsgGUID: SZvAdmhqTh6GL+gqWNYm9g==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,303,1728950400"; 
   d="scan'208";a="41976404"
Received: from mail-mw2nam04lp2170.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.170])
  by alln-opgw-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Jan 2025 09:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xu5F/5l2p+kJYsxlsD1+jdcQJBMqRJ01YOCIGFZHURGF38uJWOxe40hW45Yn5RLq0oFizUa+ck9BhRjAtdmCF6zj7BBN5x23ITZN7E3YR6FdZfX8m/CwWnpVakw+j8GvYLv9cPB7HMNydCAHA6QHIgz/RKHnLLxfOeS5zdxndBhxkZ8TGY1Rhy0KpHocYwK9LGa/UbG4IeWXZxFgZsYSPEXwctiXxV2sXIVUEFQwv9o+igsLbey9kydwyu0kFatbF+gMyHUUUI/3WOlpmfhhHwtrAA7Ps/pT44FyN8GQzgwQGLMhh+HsD9QRN4MRN8K3QcQDYOHaIUixAmCoQtL6ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7B3B4tqNBxH4dLXzmMm3CxJZg4NTUJaI03Mcd/EQty8=;
 b=XMApi9NRyKTbcHJVlu4wVE9Gg1VKRsQa1iCQyF1jI006wYApem4lr0GgCQ4AA3FYblzyEXyUc+9v1seZPHcnXhoLoP27xqvghqvB5omQURsrQ0obUTE0WkstUxGoLbk9k1z20GQxr0eEP3jHpWYC/7RSU4ZSS6VhevCwi5YoEGfUo/UWtSxDt144CEhlODENd7HyzAByGzOLk1whjxDN3N/sVzqXQXLpIu8QbZ75/c2ddWcDbMSnE++4yrCfqKUnLMvyHzUZJfRhY7s0dZznphm19MjfDNjZ8lBOZjVvhO+kdDkE86x3RjzQ5dYBY14tIZCQHTKXZmXB8DcJ7GMqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CY8PR11MB6914.namprd11.prod.outlook.com (2603:10b6:930:5a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 09:37:08 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 09:37:08 +0000
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
Subject: RE: [PATCH v7 11/15] scsi: fnic: Modify fnic interfaces to use FDLS
Thread-Topic: [PATCH v7 11/15] scsi: fnic: Modify fnic interfaces to use FDLS
Thread-Index: AQHbTDsxPk6F5B20lkuO2Uul0xmNtLMLdLsAgAIQJlCAAMJRAIABpZ8Q
Date: Fri, 10 Jan 2025 09:37:08 +0000
Message-ID:
 <SJ0PR11MB5896CEC6CC503E43D7A00D5FC31C2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-12-kartilak@cisco.com>
 <9d458a93-c2bf-4414-b050-98631fcdb1a3@stanley.mountain>
 <SJ0PR11MB5896C6D97A0A738C7B67EAC9C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <232ddea0-3c7b-45c3-8851-566118a893e3@stanley.mountain>
In-Reply-To: <232ddea0-3c7b-45c3-8851-566118a893e3@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CY8PR11MB6914:EE_
x-ms-office365-filtering-correlation-id: b1e436ee-ce2d-4160-a71a-08dd315a59ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?WeAk62Sn0Y3AKXYhJOdANrNmCTvnP51DnvZhM65WDW0nTdQwqsFsG7yMdKWK?=
 =?us-ascii?Q?+Ekyw4+2NS7/cyG5sYfLkSPRHTQolrOYEBcKgc4Ek42irNWIZdWhCq9K9YEJ?=
 =?us-ascii?Q?cVyIYm4SKPI5FfrvNwkUGmqBrS8ZDa9yLX9DjBTd70xGIBdzVG+YGR8xQmlW?=
 =?us-ascii?Q?dzU8Fw8eetjxm8cnkt7R7zm5KDp++UZDAlFNHKD3wdkceuqJX1Hje92GIauY?=
 =?us-ascii?Q?U3JJHn4CvuazPEdrWNOlk/j3lMUJqHT7nJ/oj5cEbcYkah7KPCUwwVJCBKB3?=
 =?us-ascii?Q?kaW4Wi/TzLKwij9ktc5w7gj0Gi7uI5J7S31AA4+XFNm/4mxSI/iFzbgUE484?=
 =?us-ascii?Q?zXRBan2QATOjjmO/dQbRuzLZl2fqXofAxvMu2dq9M5CiWSrvj8MS52A17/Bp?=
 =?us-ascii?Q?Agk2e3D7pl+Yri0x7+CxDzBQ7khanMNzb8NFHSehsNMR2ai+P+bq2rBkzKTU?=
 =?us-ascii?Q?+JIb3RH3baOO0pm1kTz1YyJHKMHJ3VYI2YOMlQGMp3u3B+lzWORYN2dbiEVs?=
 =?us-ascii?Q?62CfLmnC3HvYop//VCDg7s5N+cRYwoxLpBB9uBKGirAIklgyJMa3Y8MjtzPE?=
 =?us-ascii?Q?gfy13krR9hrn3VaXvYqsSTp0dcEf1qYL4l1fOJDvx5PGfsUU4wwdzcb8W8Fj?=
 =?us-ascii?Q?GR9rr6HDOo66Q219jVBz9MMqn66sjk7PAJdL2kTGX6ArSlE1cTPBqU8QoEvt?=
 =?us-ascii?Q?HMkcqpQplf59fO3LmnS/oe0e7f6OIo7Z5ubS50rKeI6NytR7kcz2m/s5GSsC?=
 =?us-ascii?Q?Ijnf0gnZtiz9awdzJqxjy0Uf7a/S5hFJM/R6kQuD7cuLB7tyJtRYET0XbwNL?=
 =?us-ascii?Q?tFZKPK+naH9Cz57EkgfaPg4ccyUqL22w4IJWIR7+NXUhFcN/b8PApErldnQ2?=
 =?us-ascii?Q?4t1Qcidf7jCJv+sbDUXkKFTyT4CGWHGdofzOGDiY8KuEoijgaRT/RnNiFEzf?=
 =?us-ascii?Q?sNOrqI2+ipOXrTtse47CUhgug3nBIQ382sIGKWvgAPIs/ik1Sf9Z1MifDEMc?=
 =?us-ascii?Q?w88tWEk2uxo9CYazA5FXGa4Ua93mVCvfbS8PgsLcIIr+gCSbfVeM4TH6nDjr?=
 =?us-ascii?Q?EDtZjqh5yAjSOVRzGTjUst1FA7EQZBl/nalikhMG/wpyUkLYIHq+3pHQdy4n?=
 =?us-ascii?Q?TrsOiv/GtIUizf4YSJ6DKWnB7x0UEpUBXaT4AsulP3VTwo9R45uFf9iqTBOF?=
 =?us-ascii?Q?fcIcvHJ9ynnT/br8LX5YZ6zFSYfgLLDFyzdTIDp+Wl/nHELA1g5W3uGZlS7P?=
 =?us-ascii?Q?FYFV5WAg31rEr9Qn6ncMs+uJTNb4G9d7E0rXaQ7omrgv54JDfIpnMMvbDF6r?=
 =?us-ascii?Q?69zpd6Xzv7SHYciqIVGSo4reHDYxqvi6sVmw4o7gogq6BUe//Z9kVoq/X/TS?=
 =?us-ascii?Q?7su4mmyUMKi8N4ZCdOd8KTCtGK2VFwd6SZ+z544B4YvJVxFrnmBgOTBRqoJV?=
 =?us-ascii?Q?dFlO5ayFCv8hCyE/E3VmzF6w00iWafi5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Z40CmOhfYMqKSDExChhL7slQ+aSSAUNuTFIKZMNRNc9cH1leX2QfmDC4qHQj?=
 =?us-ascii?Q?RxLBOkvqUedL7uoXGw2CKGiAeN80aWXBZyVC1xXlceA6zQA+yVeCQ/lurtVU?=
 =?us-ascii?Q?MR+IIkMFcxvOK95V4dIXR/BvL7q6/SiDJVelDKNGb1xyREPCiH/xKARnScIq?=
 =?us-ascii?Q?D2EzWCpzAODNiWZ4vclkr3Ub9iPaEEg9Mw1OtCKVJx6S1EREmCfBz2D5UqKT?=
 =?us-ascii?Q?xupJfgg7+WPI6xOEFCLL/7XG5Q056StZlhC5M1wZt0zwPnhVTM1+8U9QFeod?=
 =?us-ascii?Q?QZSA/bsVX+D6ES9Lkr3L0qpGjFk3wktuhsYoX8MsBowXPVmKRCWgiL7dMQUy?=
 =?us-ascii?Q?8Vz1iS5aiiFN2Bj8UTCdg9f48JgkAQPkhGWEWZAxqbTvauXXMZlcUoEfQxrc?=
 =?us-ascii?Q?G/IyE4oJhuZze9JBKMih3RsqGdS/1blvhBY9euLPYwSdAcWkFXyBbnrmyYct?=
 =?us-ascii?Q?HcLOdLodvDRCpnWG9QdbtksWZG/XMuNTUzDH9/LwJGDLfzBVBCaHTMNpxytJ?=
 =?us-ascii?Q?0/H2RMYvOeEG+RDFdTgpl7GtnuUMkXRX8ZLReel7Ky+3/PTEEaGlyCWbW/om?=
 =?us-ascii?Q?Cv5nRfR4+VG/gLncwR6mBV+OBAxm2AbP7n2mtR+tYrmF4A1mNQOlDsgYi6Kg?=
 =?us-ascii?Q?VALrlnsjf8uyfwYijpCQ0DwrmjFOXtG0pF16mrdZphWWSwCg/LEXRpzuuCHf?=
 =?us-ascii?Q?1FTv8RJGaFiF1szMNKntt6Q3rPJOYitB/bxiaaF36I7TLh6K7NZPHd8Z+Jbz?=
 =?us-ascii?Q?XX1eMgEapTWdP9L/lcyZD6QPtkYA3ofYb0D/Y6/qDG+AKrkbgTyFZte4TV+j?=
 =?us-ascii?Q?bmztIyAK7fkAmYDlWD1gNPz5g1M1byWSH61ESI38GKq8TA5SKFFxDnLKV4Pz?=
 =?us-ascii?Q?arNsnsXmTV86nnVXs+cgFhqkEeg3TRLZlWPjoscozCZFh8mOrPbFcIFezQkA?=
 =?us-ascii?Q?y3+ToI6W3av4LJoYyr+5OObZsdZem54QqNDQo5oEkgim7HaNMIc588SZVWPq?=
 =?us-ascii?Q?VTjL/Who16gYDaABcrlgLQjXh/zXNPcA3n4j/5bRU16ay3VjPi11G6fqJZUO?=
 =?us-ascii?Q?qfD5lQwhGnzVEl0xzwXoOEA4kuh77ZiCYeyxhtMkeCodeYK+m4ZYlfjoJCro?=
 =?us-ascii?Q?kTCFKFr/z1+QpbSJjrsWASCpSROVSqHi3S+pCYhA/0PCIe8G81mTm4Hn6jeH?=
 =?us-ascii?Q?MbxavsHXQzmXiG9sVa6TIwhuUs86GJIvF+nN6b+06v5V1k/5o7FwZi8plpco?=
 =?us-ascii?Q?bSqda0siPcEEfnZZ2dddsTt7k7i1OFXiHDXNTy4ZCqODxHqMjCTR57cNk5PY?=
 =?us-ascii?Q?haM7dkyJVm3AlX9msAyWg4pqJCsJnO4WJnoM8Ig2Tp8TffyGPIM3TXZFqtJZ?=
 =?us-ascii?Q?n0ZPagPDlqxGYaGJDb1bNWSuaqfnKC/1ufJIxeVo/4aataD0oDgsDjKlHtYX?=
 =?us-ascii?Q?AXh1p7zb6plZGUkZml4IwbHTXsRGOK7Bzk1FeQ59vAh8mzHdERaP+h3ammEL?=
 =?us-ascii?Q?WO73v/xa+e95WVH2aYa5KWJmb31TTQt76ueU0qXab4RwBPCFWqJG+chZm6xr?=
 =?us-ascii?Q?WqOREepORuLyYOEnZXOLjcTCCkx+EorpI5KyAZ83jKfYEG7NSXR0PHdYebd1?=
 =?us-ascii?Q?iG1/Ypf4NDINDcP0LD2tFkK0l4TO8SsFv5t/6vgb0MHh?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e436ee-ce2d-4160-a71a-08dd315a59ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2025 09:37:08.1854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i1W/hLavlc3P4//+Lu4xXgoVgFzTmikPjlK+WdjN9lGBFgxhvTVOlk2M3+sJHZPv9rnJDHU8zEwNh1g9lYlw7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6914
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: rcdn-l-core-06.cisco.com

On Thursday, January 9, 2025 12:24 AM, Dan Carpenter <dan.carpenter@linaro.=
org> wrote:
>
> On Wed, Jan 08, 2025 at 09:40:48PM +0000, Karan Tilak Kumar (kartilak) wr=
ote:
> > On Tuesday, January 7, 2025 5:18 AM, Dan Carpenter <dan.carpenter@linar=
o.org> wrote:
> > > > @@ -1236,8 +1286,10 @@ static void __exit fnic_cleanup_module(void)
> > > >  {
> > > >     pci_unregister_driver(&fnic_driver);
> > > >     destroy_workqueue(fnic_event_queue);
> > > > -   if (fnic_fip_queue)
> > > > +   if (fnic_fip_queue) {
> > > > +           flush_workqueue(fnic_fip_queue);
> > > >             destroy_workqueue(fnic_fip_queue);
> > >
> > > I don't think this change is necessary or related.  But if it is then=
 it
> > > needs to be split into its own patch with a Fixes tag.
> >
> > Thanks Dan.
> > We believe it is necessary to flush the frames in the fip queue before =
cleaning up.
> > We would like to keep this as it is.
>
> The issue with the patch is that it should have been split up into
> probably five separate small patches.  Each change needs to be considered
> on its own and explained why it's required.  This flush_workqueue()
> change wasn't even mentioned in the commit message at all.  I don't blame
> *you* for that because you didn't know but someone should have told you.
>
> With regards to flush_workqueue(), I have looked some more today and the
> flush_workqueue() is not required so this chunk does not need to be
> backported to -stable kernels.  But if it had been required, there is no
> way we could have done that with it all mixed together with other
> changes.
>
> I think there is a tool out somewhere which complains about code like
> this because I've seen a lot of patches removing the extra call to
> flush_workqueue().
>
> 97d26ae764a4 ("bcache: remove unnecessary flush_workqueue")
> fb4b9685779f ("EDAC/wq: Remove unneeded flush_workqueue()")
> d81c7cdd7a6d ("net/tls: Remove redundant workqueue flush before destroy")
> etc..
>
> regards,
> dan carpenter
>

Thanks for those references, Dan. Appreciate you taking the time to dig the=
m up.=20
The Cisco team will review this information.

Regards,
Karan
