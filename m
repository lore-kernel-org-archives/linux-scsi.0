Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=173.37.142.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794956832;
	b=mMVQNBOx7vyAO6Fzas8pGRdFoCJj3TP2SUc1+JrelE+uGeh8XRDEUMYRMExduIFg9I7K
	 VL/aWiLTP/wdFP34+1y43/lTcZIU36LCVYC9QLSa7QXoYfwwTbrL3ocISG1GwXLGc5kQU
	 ratK/mMGzO+0vBVJ/eIe2IKLsO/uL29nSpDFIYObp1XzNDMIKtrukw3sOBd6JqaYUsm3n
	 bfiiZhcjd5suF6/LGxvI2nwyekAY/jgIH21i4phw8zREdoIbDxqgp5iPa1ZaFeyDmdwIA
	 MUgXjBElXurA6vc/uXlHXqG35CqDA1skn0DDEYrOEn2S0zVxOLRqpGAMR33ZFhsSh1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794956832;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IPAS-Result:IronPort-PHdr:IronPort-Data:IronPort-HdrOrdr:
	 X-Talos-CUID:X-Talos-MUID:X-IronPort-Anti-Spam-Filtered:Received:
	 Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:X-IronPort-AV:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Outbound-Client-TLS:X-Outbound-SMTP-Client:X-Outbound-Node;
	bh=pNbJ9wwwd/llU3sOLhbyLTJgEY9milH1QAvBe0KWbsY=;
	b=3qScoBF9COJpL0D786PSIYGNfRos9gXFpNVFRVMPPv6ElxO1fh5eNRiEXuIJmDQoY5UI
	 u7uVWknwqmhFKtwif+Ja+u0gF9d03d5kfqMpw0AxqbYNv3N6Xd0ycs8hZHmAzU6GJj4hV
	 PCyQI5vnagV6HOpNUQFEE9hwpjh86wN118HG03pNyv63LGpUT0jixtlF3teiMLu+mydWw
	 cvebXvffZNUtXNJsbe5VbQAkC+m2vr5k6D+DgakQWMGUcbTp/rklkiSf22nzpOdfS/9dO
	 YUfmPLSRA2kGqJsAZbsTLyKcZRPWPOI0YIvtbgNaiCaqXyOQrDuVZ+KSq57s7dTrOiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cisco.com;
	spf=pass smtp.mailfrom=cisco.com;
	dkim=pass header.d=cisco.com header.i=@cisco.com header.a=rsa-sha256 header.s=iport01 header.b=TeNhlDnz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=173.37.142.95
Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F44606A31C;
	Tue, 17 Nov 2026 23:07:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84F44606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cisco.com header.i=@cisco.com header.a=rsa-sha256 header.s=iport01 header.b=TeNhlDnz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1976; q=dns/txt;
  s=iport01; t=1794956831; x=1796166431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pNbJ9wwwd/llU3sOLhbyLTJgEY9milH1QAvBe0KWbsY=;
  b=TeNhlDnzlXAan/u8NjB++L26fU4wk0+3j3tSWT74m8EiVXA4XA/RrxIi
   LisAjfe/Jk5Mo6CvPQJ1opHZPFB2jMCzOYmodOcuKEVD9FaJEWx7Y3b9D
   G6GUtzaK+tOodx0dNg1ykR0PyEqklaMOgDVeh3XCA8kBRUWxdLoI/iYC6
   7B5c9b2ymNMd1e/ZCXVctRJEAj18DmZRWYG5iRyt63WN5iD8YU/F/n9uc
   fJfSQtgNAJnwpzuwQiGabmsG6x+EUKGxDIk1P5YtqUEWnBn259WA5N/HC
   28MWj94zsnC4s1DmAz9caFwfk/6ZrWCO27Sn+wdJaZPpG9tGfbT1U6w67
   Q==;
X-CSE-ConnectionGUID: 0BzZ3Hh+SWWPpcl64/1lvw==
X-CSE-MsgGUID: 6rbXT+KiRuOFcm09HYg2CA==
X-IPAS-Result: =?us-ascii?q?A0BvAwBy3fxq/5MQJK1agS6BK4FuU4IuSYRXg0wDhSuIe?=
 =?us-ascii?q?gOLZZJBgX4PAQEBDQJRBAEBhQUCFo4JAiY0CQ4BAgQDAgMBAQEBAQEBAQEBA?=
 =?us-ascii?q?QEKAQEFAQEBAgEHBYEOE4ZckBIBAQEBAxIREUUQAgEIGAICJgICAh4RFRACB?=
 =?us-ascii?q?AENBQgahRsDNwMBArBGcwKKHXqBMoEB3UoNgmYUAYEKLoUIgzogAYFxiQUnG?=
 =?us-ascii?q?4INgRVCgmo+gh+BazsVg0U6gjAEgQ6BFIEMjCyEEIdyCUl4HANZLAFVExcLB?=
 =?us-ascii?q?wVjQhAzAyovLRYNIikFLR1wDCcSKRcRHlgbBgUSICpAQ0QEE4ESgQNdgSsoX?=
 =?us-ascii?q?QECH0YtFYF2AoJRgSNdAgFJQQ4HRVMJFg8+BRJHJCIIEgkBExosCoEaNTwJJ?=
 =?us-ascii?q?j8VDFsMCxoFGkcIAgsCDHQoERATHR4kLwUaJj4bCoEMJx8eBG09NwYPGQMEO?=
 =?us-ascii?q?nsFkyaDFwF7E4JAk0aDf49+nmtxCoQhm2KGMheqci6YWiORcZcFAgQCBAUCE?=
 =?us-ascii?q?QEBBoFoPIFZcBWDIlMZD44uFpMdAblieQI7AgcCBw4DC4ZGiyKBfgEB?=
IronPort-PHdr: A9a23:2Ni7RhCEwzwpenaKpxLiUyQVXRdPi9zP1kY9454jjfdJaqu8us+kN
 03E7vIrh1jMDs3X6PNB3vLfqLuoGXcB7pCIrG0YfdRSWgUEh8Qbk01oAMOMBUDhav+/Ryc7B
 89FElRi+hmG
IronPort-Data: A9a23:7uMUKKO87RR9uqHvrR3NlsFynXyQoLVcMsEvi/4bfWQNrUokhGZUz
 zQcCmuAbv6OY2r0Ld8jPtu2oR4DvpHdztZgTHM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeap1yFjmM/ErF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WVzlV
 e/a+ZWFZgb8gmEsawr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj661EHnNtHY1bwdlIOXlF8
 aJEb2kJcA/W0opawJrjIgVtrs0nKM+uOMYUvWttiGiBS/0nWpvEBa7N4Le03h9p2ZsIRqiYP
 pRfMGYwBPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5F0pieezaoSJI7RmQ+0LhEyom
 iHl/l7kJT8RMYTO6QuKqFmF07qncSTTHdh6+KeD3vprhkCDg28eEhsbUXOlrvSjzE2zQdRSL
 woT4CVGhawz8lG7C8L2RByQvnGJpFgfVsBWHul87xuCopc4+C6QAmwCCzoEY9s8uYpvHXoh1
 0SCmJXiAjkHXKCpdE9xP4y89FuaESMUNmQFIyQDSGM4DxPL/OnfUjqnog5fLZOI
IronPort-HdrOrdr: A9a23:CIOtXKAChBVrklTlHeijsseALOsnbusQ8zAXPh9KOH9om52j9/
 xGws576fatskduZJhBo7y90KnpewK7yXcH2/hhAV7EZniohILIFvAv0WKM+UybJ8STzJ846U
 4kSdkANDSSNyk1sS+Z2njELz9I+rDum87Y55a6854ud3AXV0gK1XYBNu/vKDwMeOAwP+tAKH
 Pz3LshmxOQPV4sQoCQAH4DU+Lfp9vNuq7HTHc9bSIP2U2ltx/tzKT1PSS5834lPg9n8PMP4G
 LFmwv26uGZte2nyhjT7mnX755HstrswNlOCaW3+4kowzPX5TqAVcBEYfmvrTo1qOag5BIBi9
 /XuSotOMx19jf4Yny1iQGF4Xii7B8er1vZjXOIi3rqpsL0ABggDdBauI5fehzFr2I9odBH1r
 5R1W7xjesUMfqAplW52zH7bWAsqqOGmwtlrQfVtQ0HbWIqUs4UkWXYxjIMLH5PJlOg1GltKp
 gfMCiV3ockTbrdVQGYgkBfhPqxQ380AhCKBmIGusCTznxquUoR9TpD+CTa9U1wqK7UjPJ/lr
 n5G7Utm7dUQsAMa6VhQO8HXMusE2TIBQnBKWSIPD3cZeo60l/22tfKCY8OlamXUY1NyIF3lI
 XKUVteu2J3c0XyCdeW1JkO9hzWWm2yUTnk18kbvvFCy/DBbauuNTfGREElksOmrflaCsrHW+
 yrMJYTB/P4N2PhFYtAwgW7UZhPLnsVVtETp78AKhizi9OOLpevuv3Qcf7VKraoGTE4WnnnCn
 9GRzT3LNUo1DHcZpY5ummnZ5rAQD2KwXsrKtmpwwE68vl5CrFx
X-Talos-CUID: 9a23:CPN1J2OkVeYWhu5DAAN1xhU0GoMeTULl1HzUfRP/UGJ3V+jA
X-Talos-MUID: 9a23:sF3IUwUv3og+tJLq/GH2jgFed+Rp2bmJJksIycQmisbeHgUlbg==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Nov 2026 23:07:02 +0000
Received: from alln-opgw-3.cisco.com (alln-opgw-3.cisco.com [173.37.147.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPS id 717571800055E;
	Tue, 17 Nov 2026 23:07:02 +0000 (GMT)
X-CSE-ConnectionGUID: sv+UxhZbS7S2itLVpeyiIA==
X-CSE-MsgGUID: wY7uDeE+RRORjHOSSmGukA==
Authentication-Results: alln-opgw-3.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.27,218,1787011200"; 
   d="scan'208";a="71411107"
Received: from mail-northcentralusazon11013053.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.53])
  by alln-opgw-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Nov 2026 23:07:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EWOaX8s33M2BWM6jIWX6ksBUR5oPvQytB4T/JD2kix9Fn7OXk1vPQqY++w3Ri8q+wEx+1Vfn0NdKeh40CqeUm5sm7OiPhoGD9qh3Fj9SV608ebdu6szbQEGDaUHkh/PKrQDAae8dBjU+hch9pJPqjLIiW6x0Qul7J/WdQct8TAGUl6mAHW0MVwaVWp85IYxo0GzVbzDZl3bCmYsbFm7hIAx2xsCTnm5haQQDyQ1Tb+4NmI4oNGaVqqOeuqFcurQho8Emmm9mDylYFeGYnuvzqkkTAhJW4F/iL8bBXqbmrK6QPM3KUzEnHwOy6hjZCYLZksRGrIwoDYncI4Q39U9+eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNbJ9wwwd/llU3sOLhbyLTJgEY9milH1QAvBe0KWbsY=;
 b=kmnmHZneSKU5ItPUKUM0nprFKqubETdiZVczROBqW0XFL35m6prHdSqJm+0d6iOvWd7dqkd08uFt+JSJy1GlBLsAElQDSxttpaMCFfIbLAINV1wVMjqxLnUeiSNkHbic0oIjA0m6Q/K8d7XiSAX3qLIOou+I2Jc97qQuvBESzVfr6Kj5DIRBQNd0M3VCVCx69VkFV1kxYFimw8IDXxrnwv/YP/NHk0ThOaNBoJWRYpPHxnjfqG3Y00VFl3jWkLvv1rbSk9tg23jCe7oLpqy81ttviuLeGpFrsC+E7j+IWd2v1LpzZpNeVgCJs0OMxFCXFRyDo4Qu6MtM2/xv1Y6/Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0SPRMB0032.namprd11.prod.outlook.com (2603:10b6:a03:3ef::15)
 by SA1PR11MB6917.namprd11.prod.outlook.com (2603:10b6:806:2bd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 23:06:59 +0000
Received: from SJ0SPRMB0032.namprd11.prod.outlook.com
 ([fe80::83be:7011:3e75:6244]) by SJ0SPRMB0032.namprd11.prod.outlook.com
 ([fe80::83be:7011:3e75:6244%4]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 23:06:58 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "izaacchong934@gmail.com" <izaacchong934@gmail.com>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<mkp@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: Fix typo in kmem_cache creation error message
Thread-Topic: [PATCH] scsi: fnic: Fix typo in kmem_cache creation error
 message
Thread-Index: AQHdc8/fO3PBjsEEjUipxY4YwlDqHbcy6JIQ
Date: Tue, 17 Nov 2026 23:06:58 +0000
Message-ID:
 <SJ0SPRMB0032DA58C7ABF4C2AA0C4567C37B2@SJ0SPRMB0032.namprd11.prod.outlook.com>
References: <20261114-fnic-typo-v1-1-a9f70c9c4a6b@gmail.com>
In-Reply-To: <20261114-fnic-typo-v1-1-a9f70c9c4a6b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0SPRMB0032:EE_|SA1PR11MB6917:EE_
x-ms-office365-filtering-correlation-id: db894571-aefc-4066-0b35-08df44ff7b68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|38070700021|261021135927099003|10067099003|56012099006|11063799006|261026140227099003|261028144727099003|261021123027099003|261022075727099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|18002099003|6133799003|22082099003;
x-microsoft-antispam-message-info:
 9onYetWWt5uuLoNIQ0WFfnrdApZ99/medJvXTMBOfWWBuO1VK3UvvuyNP7HqyvuhSpSBiz433FRVlNDvcqnC4robQHyCka/yQTZsaa/NqG1WwfyFWf9Y5HK6RYBH/mbboonfSvzPBssLCu09puxKfELsvt2BM8k+egydsL6BFBUl9QUJp9lo2DSdTYUFRtMUWeIyKrk9An5xbV9CQhQPRLjlnr4cH9Z1e6IKEXV+5l5OPv7cLhdhDNmI75r9F93OxJ5MdJMVutcvYmy0+FiZzKegy/UPhw4vR2RXMM50TF1+h9354WBqHanYIlw+6GaZPIVuqzFNYUzZmDZ61jZ6XxaBmY6tLoKlenmKF1Y5b7r0BxUUx+1gkJAl3H1ae/MHKGSSUxBeVCeGja8DikVYj/LRuS/uEfdLG19HGz5s3LSm4hhyGNM6nboi39wfxVj5mBduN7Pgo3VAdIcWdhJsY3oAevjhVzydyyqzkx6a49pVzd7IEVo2g8YgWp/NlL2bHxLK5ycotEtLR/yj4Z+XRn6kKHmIHXey38YHtb41roE1Z5W4CY7cX78/xgY0JYBtrXLrRkMXWcIabGR33c7vU+m12uNsyA6Um8cOvDd8V6F1jq8oO7Ga9KHGfpDaQy6LYFBXu9F7uQ93vz5cFq/qnlYdlmgTF5uUs09eXGQyRrkeFb2uIpdtibbWFv365PXaDj9vKwOf+QgAnH/gNAnk00Sr9RUw5uNtygngkoEGblw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0SPRMB0032.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(38070700021)(261021135927099003)(10067099003)(56012099006)(11063799006)(261026140227099003)(261028144727099003)(261021123027099003)(261022075727099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NDEyLytuVUh1S0Y4SVoyblpTZlJFdWtsWXNuOGl1TXZRL2swNC83NEY3YVNz?=
 =?utf-8?B?VjVQMHpmR283N2xvN0pMVlFLb04wV05qVG5kbk11SUx0d1JUVjhXV0JoalU0?=
 =?utf-8?B?NGhkSUF1OW01ZWJLVCsyTDhDemhFOFlLWjJqQWVCZkFxTm5UVHVBWnFNTFVz?=
 =?utf-8?B?TURzc2NCdjQzcThEdTdMTUhLd0RnQnpScC9oaHBMM2E3enhxQlVmemt3RjlM?=
 =?utf-8?B?KzhBVVpyR1RYRUZEZkdkNVZFWXpFVDcvNXVwUEo5cW5BVm5xdEtWV0dzK0d4?=
 =?utf-8?B?dG1DTXRDZCt3d1FDWVRpQzFScFNqVDZBdGZZS29kK0V3NFEvRmFYWmFob1NJ?=
 =?utf-8?B?VjBiRldkQk55ajBuQ3d3Qkt1NGFmVGc5NVJTY2w4cnVOWnF6KzkzWk1URVBz?=
 =?utf-8?B?OFkvU090alNJQ0pEUFQ2dDR4MjNWV3RHVlZuVUtNYWNCSHBoWkYyZGI2QkQw?=
 =?utf-8?B?NXFXQjFraytHSmNUT1U0R3pZNGxYcDR2L2tWZGxYbnJFVTlYVFlJWWhGTWdT?=
 =?utf-8?B?WERPV2dBRHY2Q3VVU00zcVVrcDN3ZDhlUnlVakF5clQvOU9FVTYxQlVPNE8y?=
 =?utf-8?B?eFFHTCtMR1oxNVdnVWtGc3pLVDVzTUV6aXBqOW5BbUVlU1BqUmgxTkFLZ3Jx?=
 =?utf-8?B?Y0xENHdBY2JUcWFLbk55aVFncjJJcFh5YVU2d0ZkTUExYnF5VXVtVE9qYkRy?=
 =?utf-8?B?U2xkN2dzckxWWVFPTHJyaUkrakhEc3Z5ejZmcElVbXdQR29idFFUN013T1dl?=
 =?utf-8?B?NzA5RnlVV3IwS0dUYnRhNzNyNENldnFvakN6N0Y0dFFuSDZ4TlFRaUkzTVM2?=
 =?utf-8?B?QjhzM21zT0VvM3k4UmlBZU9RenhxMTREUHkramdQOWZHbWRIa3k2RWprTFpw?=
 =?utf-8?B?TldWczkzRThkbDNZVmtjanBMaXFKUGtiQWl0M1BPSWFYL1JINXQ1d2tONUJM?=
 =?utf-8?B?YnoyeGN1L0pYVE1kRENJbmpET0tKb0JjaForOGYrcHpOSnp6eFZyUm9aaGt5?=
 =?utf-8?B?NitTdHhITFdacmZkeEdEVENMMWFETndnbE45aVVLQ2lsYnZYdjRJY1N5RlNK?=
 =?utf-8?B?bm1TenpnSFIrNHk2a1NUTlZ1TGdxa1hING5CeUJFdXBMQWNXbmp6SVU1SGJw?=
 =?utf-8?B?Qm5xSjVYazE1Qk9MU3RJN2JXbElXOUZOVlI0UG1tNW82UmkrZVBPRzRDSk1v?=
 =?utf-8?B?d3hPWlllb3p2ejZuRkhoZkx0UzFvZThPTDlycm9GOUVxTmFDcDlDQWhjOCtj?=
 =?utf-8?B?MC9pcnAzU01UdG1YSG5ON2dHM2NWZzJDWVpOUG5QU0h0QTNTOS9tNnJkamFn?=
 =?utf-8?B?dFJQS1V2WWNFR0xORmZKOTloMlVCSW9wdFJHeTlyUGM5anA4eTJWS0g5c2hk?=
 =?utf-8?B?UzhvVHFSYVVEV3o4NnpIU0hUUzJBTGNKQTRyczdNYzdjTHJ1elNsTjBPeTlp?=
 =?utf-8?B?d2d1UmtCa2xQT3pSWFRMcUtNYS9ualREODM4bGtacHpHRVRmczdvSDRmMG5w?=
 =?utf-8?B?TDJQbzZLMVZBR1k0ekNDT2hFS1Y2R3ZEd1B3VUQ3cCtTVDRBY1hLbDdXK3NL?=
 =?utf-8?B?WlliTzJNeURidUxSa0Z1c2QvMy8zRkR2dWp1YzVJWmRGTjFoRUlRNWN2R01F?=
 =?utf-8?B?SkFtSGdIc01wUGYvK2llL3F3TjV5NHVlRmthaHBhN0FWNXRyczUyNWFTWlNs?=
 =?utf-8?B?SDVoQzlOWDRhOE9IYkZESytVem10U3ZLMFZadEFaU2loVS85SjgwZlFnOUpM?=
 =?utf-8?B?SjRROW5hZXF6a0lWNFB0NXo5MzQrUmJBSWdpZUM3cU4rVXNsZWNoSmg4SEt6?=
 =?utf-8?B?SEdvdFZCZzZiS1JpQ2xtK0dxbmFjS2JxNzZ6bFdUT2R5WFFXVXBldDMxK1ZK?=
 =?utf-8?B?bFlRckRCVEVmMmpEakJiaHB4Sy93c0ZtZlpYZVMxZGwrbC9kNHpFajRzOC9m?=
 =?utf-8?B?Nys3VU5adXVaV1hZS2N6U0c5Tm15d1dzK0ZJWEdXNDhEdXpLR3Z5c1R3enlh?=
 =?utf-8?B?cE1kcHpndEdVOUxYZzA5K2JBQituVXB3N1RKbmdLNXlFRTY0WDZZbnZqVW9j?=
 =?utf-8?B?SlA4L2gxVG8rK1VFSlJHMkhMMUQ4b2RDb1lyUFNSYUU2SkdkWmhsK2xOSVBM?=
 =?utf-8?B?c3hiSDdualdJbEd1cWJLMkc2WDhDR2IveUZnR0wremczQTg4U2NGMjUwWExO?=
 =?utf-8?B?dm1UcmFPZGl2a3hIZXhGTkVBQllWNEUySVoyZmtkSERUV1VtS2R6amhkM1o2?=
 =?utf-8?B?VFFPWEdiaTRVNXNQMjM5OFBZRG5VbVgvSFltZ3BXNk1TcFBWVWtMdmpFbCtT?=
 =?utf-8?Q?ILNGyHYJ6LbLZ5/mqh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	cJ4vfPRVdy8V1i8d0HScsmPYKw8oVJ8nmD3ZdiWMuJKBmwGOGuzyRT9gEb/a2/1DMluxSgzGlEGGsPXNEWl2oupoffUqBNp3U01U28esfS9C64EmvDMb75iEVz+5vHTK/XzjLRRxZVDLQQUaf4jiW96uB+QX93smwvQDR8o8nkNCYsT4fBPeV38xsEVI358rGZbihNZpSXoAebR5GuCIJs60ooqR4EvnkgDFT8/cbukou6cXPFyIohCPGEBq5W9qelAYBfVsSAHQx3zfb70/XImqdWVle18oMVl0fT62sbeNbYbIVSLl1Vwgm2c+iZySMAN4qVCS1JXZ0qL+Hkf4nw==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0SPRMB0032.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db894571-aefc-4066-0b35-08df44ff7b68
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2026 23:06:58.7285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u1OBdJmGJzZx8TE310d267CoD4YSYWzUD/ZVlTZJAJ15GCHBGz/lkVJDkEKLEcJ9LvzyxX1oBMMCRtHNGg6d0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6917
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-3.cisco.com [173.37.147.251];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.251, alln-opgw-3.cisco.com
X-Outbound-Node: alln-l-core-10.cisco.com

T24gRnJpZGF5LCBOb3ZlbWJlciAxMywgMjAyNiA1OjM0IFBNLCBJemFhYyBDaG9uZyB2aWEgQjQg
UmVsYXkgPGRldm51bGwraXphYWNjaG9uZzkzNC5nbWFpbC5jb21Aa2VybmVsLm9yZz4gd3JvdGU6
DQo+DQo+DQo+IFRoZSBlcnJvciBwcmludGVkIHdoZW4gdGhlIGZkbHNfZnJhbWVfcmVjdiBrbWVt
X2NhY2hlIGNhbm5vdCBiZQ0KPiBjcmVhdGVkIHNheXMgImNhY2giIGluc3RlYWQgb2YgImNhY2hl
Ii4gRml4IHRoZSBzcGVsbGluZyBzbyB0aGUNCj4gbWVzc2FnZSBtYXRjaGVzIHRoZSBvdGhlciBj
YWNoZSBjcmVhdGlvbiBlcnJvcnMgaW4gZm5pY19pbml0X21vZHVsZSgpLg0KPg0KPiBTaWduZWQt
b2ZmLWJ5OiBJemFhYyBDaG9uZyA8aXphYWNjaG9uZzkzNEBnbWFpbC5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19tYWluLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9mbmljL2ZuaWNfbWFpbi5jIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19tYWluLmMNCj4g
aW5kZXggYTE5YzBiMGQ4Li4xMGMyZGU3NDYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9m
bmljL2ZuaWNfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfbWFpbi5jDQo+
IEBAIC0xNDYwLDcgKzE0NjAsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBmbmljX2luaXRfbW9kdWxl
KHZvaWQpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IEZOSUNfRlJBTUVfSFRfUk9PTSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgMCwgU0xBQl9IV0NBQ0hFX0FMSUdOLCBOVUxMKTsNCj4gICAgICAgaWYg
KCFmZGxzX2ZyYW1lX3JlY3ZfY2FjaGUpIHsNCj4gLSAgICAgICAgICAgICBwcl9lcnIoImZuaWMg
ZmRscyBmcmFtZSByZWN2IGNhY2ggY3JlYXRlIGZhaWxlZFxuIik7DQo+ICsgICAgICAgICAgICAg
cHJfZXJyKCJmbmljIGZkbHMgZnJhbWUgcmVjdiBjYWNoZSBjcmVhdGUgZmFpbGVkXG4iKTsNCj4g
ICAgICAgICAgICAgICBlcnIgPSAtRU5PTUVNOw0KPiAgICAgICAgICAgICAgIGdvdG8gZXJyX2Ny
ZWF0ZV9mZGxzX2ZyYW1lX3JlY3ZfY2FjaGU7DQo+ICAgICAgIH0NCj4NCj4gLS0tDQo+IGJhc2Ut
Y29tbWl0OiA5N2Q3M2M4MjUxMjI2Y2YyN2NjNjY1NmI0YzU0Mjg2OWJiOGM2OWZhDQo+IGNoYW5n
ZS1pZDogMjAyNjExMTQtZm5pYy10eXBvLTc0NDlkMmU0NDk0YQ0KPg0KPiBCZXN0IHJlZ2FyZHMs
DQo+IC0tDQo+IEl6YWFjIENob25nIDxpemFhY2Nob25nOTM0QGdtYWlsLmNvbT4NCj4NCj4NCj4N
Cg0KUmV2aWV3ZWQtYnk6IEthcmFuIFRpbGFrIEt1bWFyIDxrYXJ0aWxha0BjaXNjby5jb20+DQoN
ClJlZ2FyZHMsDQpLYXJhbg0K
