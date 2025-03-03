Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B611A1EE7D6;
	Mon,  3 Mar 2025 20:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741033847; cv=fail; b=l+p9ncX6SE+HiHD5QQXKG8xpHwCN2Gow+DUHtxd3dc1pkP2DauGJq5mBIcMI6pBFoPFWc3giyKJLL4W4m57QuMx8WfIAatwDFA1cyWnd28VUU51KfXEbEJHhAnGRn5TTkBYuO+D3w8KrecutZh5lhQzt8ZyntHJsRhGyrg7MM2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741033847; c=relaxed/simple;
	bh=PhBFfiV+OanZTty3A3idF0e8IcKsscQkS8R3lWKaYMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oUCgLCdan9BwaCb0R4O12DoRFSvLV5QPG2C/6Gs4TEEyUUWYW25qIBne7pigv0TxEfFf7RN2M5G1qGfAFZ0xU8vrWfSpIUCHHvYYG4tv5V1ju4MzpZEtII1RA8BymTiO7vPqh/FxKjeI/pv8qHFTkeoTSRGu5oYFNizgPhLIzMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Lr/lMHy2; arc=fail smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Lr/lMHy2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1194; q=dns/txt;
  s=iport01; t=1741033844; x=1742243444;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RxsCSce6qsuRB1NRRq/Fca/xa2ySV9QQP5NI0+0+FpQ=;
  b=Lr/lMHy2+fKsSRGS7rbQZkfLB31efF3oY1PDcuLSP5FrOm73ZKJbLdi9
   9WdteNid4IKs08NIorl2s530PZuoeOqyxZTgTznKAeWz8LV6CvDYxOUc1
   aCvqakGRdrIAvtwZAj/+sq6jx82neJTIrhrN1l3U7cCAOnvMnVyjHIka6
   otCpVI50lcxfUy3XVl9az8NZrpwrYYkM9B4uzusP/lXwlIXteTGz48T+V
   gnguutrFBR75SHypDXyDaizckQdZAOiVxaACmWkIU3olYFzKavmZmF29c
   KbNEFES/2JWmUUTCz5bVVW/ncwk/Zkof/rRDfZ9312ZXwfbUr5x8ge2vq
   Q==;
X-CSE-ConnectionGUID: Rm8rbkydQ0+R5xu9v4Tuug==
X-CSE-MsgGUID: EIyadQSmTSKafilTMzFk5w==
X-IPAS-Result: =?us-ascii?q?A0BbAAAQEMZn/4v/Ja1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEcBQEBCwGBcVIHghJIiCEDhS2GU4IknhSBJQNWDwEBAQ0CRAQBAYUHAosUA?=
 =?us-ascii?q?iY2Bw4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhloBA?=
 =?us-ascii?q?QEBAxIoPxACAQgYHhAxJQIEDgUIGoVFAwGieAGBQAKKK3iBNIEB4CKBSAGIT?=
 =?us-ascii?q?gGFa4R3JxuCDYFXgmg+hEWEE4IvBIIvRYEkgldnmgWOU1J7HANZLAFVExcLB?=
 =?us-ascii?q?wWBKUgDgQ8jD4EUBTQKNzqCC2lJOgINAjWCHnyCK4IXgjeEPYRAhVKCEYFdA?=
 =?us-ascii?q?wMWEIIwb3cchHyEax1AAwttPTcUGwUEgTUFoG46h3gWASmWTa5TgTMKhBuhf?=
 =?us-ascii?q?heqVph9pTSDUwIEAgQFAg8BAQaBbg0ogVlwFYMiUhkPjlnME3g8AgcLAQEDC?=
 =?us-ascii?q?ZFlAQE?=
IronPort-PHdr: A9a23:tH/fXBJOX0wZlWLqptmcuVQyDhhOgF28FhQe5pxijKpBbeH4uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:cUij1aPFIv2p2oHvrR3OlsFynXyQoLVcMsEvi/4bfWQNrUp21zYCy
 WAZUWiHPv/fNGCmKt5yb9ngoR9Tv8TdmN5lHnM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFjmE+0/F3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WljlV
 e/a+ZWFZQf+g2UsaAr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj689rXFs8PpwUw740Ozxe6
 K0GdAwQcx/W0opawJrjIgVtrt4oIM+uOMYUvWttiGmDS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2M0PXwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQqiui8YIuKK4biqcN9s2eJr
 27/xGHFOTITOt2b9R+X3HHxmbqa9c/8cMdIfFGizdZugVuO1ikQBQcQWF+Tv/a0kAi9VshZJ
 khS/TAhxYA29Uq2XpzmVAa5iGCLswRaWNdKFeA+rgaXxcLpDx2xHGMISHtFLdchrsJzHWZs3
 V6SlNSvDjtq2FGIdU+gGn6vhWraEQAeLHQJYmkPSg5t3jUpiNhbYs7nJjq7LJOIsw==
IronPort-HdrOrdr: A9a23:SxnsyqtZjhiWuJOzTmPbcbE07skCOYAji2hC6mlwRA09TyXGrb
 HMoB1L73/JYWgqOU3IwerwRpVoIUmxyXZ0ibNhW4tKLzOWyVdAS7sSorcKogeQVxEWmdQtr5
 uIH5IObOEYSGIK8voSgzPIXerIouP3jZxA7N22pxwCPGMaDp2IrT0JdjpzeXcGPTWucKBJb6
 Z0kfA33wZIF05nCfiTNz0uZcSGjdvNk57tfB4BADAayCTmt1mVwY+/OSK1mjMFXR1y4ZpKyw
 X4egrCiZmLgrWe8FvxxmXT55NZlJ/K0d1YHvGBjcATN3HFlhuoTJ4JYczDgBkF5MWUrHo6mt
 jFpBkte+5p7WnKQ22zqRzxnyH9zTcV7WP4w1PwuwqhnSW5fkN5NyNyv/McTvLr0TtmgDi66t
 MM44utjesTMfoHplWl2zGHbWAzqqP+mwtTrQdatQ0tbWJZUs4RkWTal3klSqvp20nBmdsaOf
 grA8fG6PlMd1SGK3jfo2l02dSpGm8+BxGcXyE5y4eoOhVt7TlEJnEjtYQit2ZF8Ih4R4hP5u
 zCPKgtnLZSTtUOZaY4AOsaW8O4BmHEXBqJaQupUBnaPbBCP2iIp4/84b0z6u3vcJsUzIEqkJ
 CEVF9Dr2Y9d0/nFMXL1pxW9RLGRnm7QF3Wu4tjzok8vqe5SKvgMCWFRlxrm8y8o+8HCsmeQP
 q3MII+OY6UEYIvI/c/4+TTYegnFZBFarxmhj8SYSP6nv72
X-Talos-CUID: 9a23:zdZHUWBCzoJilJL6ExNipFQeGdEpSyWe9irAPh6mVVp0VbLAHA==
X-Talos-MUID: =?us-ascii?q?9a23=3A/TZu4QxngEGFXc9HYtvD5l4T2l+aqImPGUkBqK4?=
 =?us-ascii?q?Dh/KnPCJxPwu4nhq0H5Byfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 03 Mar 2025 20:29:34 +0000
Received: from rcdn-opgw-3.cisco.com (rcdn-opgw-3.cisco.com [72.163.7.164])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPS id B7C7118000346;
	Mon,  3 Mar 2025 20:29:34 +0000 (GMT)
X-CSE-ConnectionGUID: gC0d65kYS22TuBO9MYfqXg==
X-CSE-MsgGUID: QOA4kxxFQOqzzw4Y7jU5BA==
Authentication-Results: rcdn-opgw-3.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.13,330,1732579200"; 
   d="scan'208";a="33212451"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by rcdn-opgw-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 03 Mar 2025 20:29:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afn7gZv8DPhgjVNi5MxFCKbHNMOm0QjTu2fkBFd04v2fi0Icx/NlULQpZDnyO6k4oOa5efYCv28PmCSI28BxbFKxFaDBkCqg1V8dec+eFRwBCHLI2hQ9R/xWJa5nNehvDforblhOuz4ME5WxGNgYa6qc+PDUCYbgL3NW89Wvaf8wOCRuB9d9nJJnP7tRh4dgzseZCW4B/yf1Er0qab9c89CInZH6seDf7ZtMXYaNz6ZuLOf8odvEb7lvobxo7BI2AgO05mkg7b7TGju5/ivpkNQc9lVls8OEcHVlbSRg+hquINrY8RwZ9xOxTZ/GkQmZ3qD1dMwLkequ5QfJg2xv7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxsCSce6qsuRB1NRRq/Fca/xa2ySV9QQP5NI0+0+FpQ=;
 b=MZoa+KVLr/Kpxld/HMUToFfcBU6YHz1NOa3YMFrlTbei5Xs0yA+mENRWkVlA4ou2rjoeVrRHahPHc16ZKOQ2c4sJgUs4AkeTeTZsnsxE9lsoZ2JQn5GK1PdVNkIG1SquQzk4Y5z4YmTUNSnfqCiv2DLqE8sSZXg4gGJcmZXfLW+2hnWIiI06bgtWRQSau2e0lmWqwX32tFDCDNaTbgYN6Rh9RcX44pqjAXSevtibOGmISKQDpLrzWcu2y98TPDPC5ihEmEA0GnyIL+wrX8Jyjg3jH5kikrap9RnudA0tUYoQYx5HId9XP3krJXUniwep+HffH6piAJ4athKFoNZ4aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SA3PR11MB7525.namprd11.prod.outlook.com (2603:10b6:806:31a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Mon, 3 Mar
 2025 20:29:31 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 20:29:31 +0000
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
Subject: RE: [PATCH v2 2/2] scsi: fnic: Remove unnecessary spinlock locking
 and unlocking
Thread-Topic: [PATCH v2 2/2] scsi: fnic: Remove unnecessary spinlock locking
 and unlocking
Thread-Index: AQHbikqVLC/w869I+USuWBacBB9ftbNeJakAgAO7TXA=
Date: Mon, 3 Mar 2025 20:29:31 +0000
Message-ID:
 <SJ0PR11MB5896B3B54B679A023A3DED2FC3C92@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250301013712.3115-1-kartilak@cisco.com>
 <20250301013712.3115-2-kartilak@cisco.com>
 <95135f06-cd1f-47a3-8253-c4275e7a5c3a@stanley.mountain>
In-Reply-To: <95135f06-cd1f-47a3-8253-c4275e7a5c3a@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SA3PR11MB7525:EE_
x-ms-office365-filtering-correlation-id: 72acee97-2240-452c-43f1-08dd5a921aac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?uxAtVLH5BWnvmR63C1tuvhhofrszWfQwhFAJYkkG4+6bqa6cC0kSbDjeRxz1?=
 =?us-ascii?Q?/3z+gT5IaCpan53JSye8pStMj2ReiqcLBLVtgZaiyhX2B4PVZN9zoG5U85yL?=
 =?us-ascii?Q?9qvvKLMl+NEbOmbOHSmKK4vnPfZmRCIKl5wDYkxHqtmTTd/wvvBlhjMTBCNH?=
 =?us-ascii?Q?K+4kqrfoNQEcd3fsVUBBqwZyi2o0q3eQ2YEZk5k07326kALYQ3y1eBvC0vJZ?=
 =?us-ascii?Q?hDiq7styJlZ8jjqjPOXa0cEe98BuaqT4lfbm4MSuHzFTF8Sy3p6Zj+r1cc0R?=
 =?us-ascii?Q?rZGUnNTJIfCrGJs/XI88k5ISR+qMumF1eZjs9IGs4J73gcn3SynUDC7V+GCY?=
 =?us-ascii?Q?IWOKqDADjJsM69WFAkgfEAze3zYFwVf/cFaJf8pzYBUR5VoDTdgK61IX0eA9?=
 =?us-ascii?Q?UrbU6+9HHWOmtFjmaUY31VlzFxfFyf22tYWPqiWx71+KGflK3LfMFuk+W5bM?=
 =?us-ascii?Q?7Tlg9UKcD4xxE+Oh2H4P2iJqDs8SRVamNIkQuT5/rWFPkrveMwTED0Svc7M4?=
 =?us-ascii?Q?zQ23gvLcFUDrmcT8dEKG7Qh5SFkK5wovDpSWRUduNci0x0Qgz9SCP0cl83uj?=
 =?us-ascii?Q?Dzr/ajiOB0dIot1LV0FEMdw1tuhr2qrkBmy0fSWUDrcUgKf3BzWhs17EeOtv?=
 =?us-ascii?Q?+wZ0pJGh7Kw67swPuC4vcd831+fELAb2suQJuKcXQtnsxwPq7SRI6PlXPBe2?=
 =?us-ascii?Q?3mKPqTPbrCvUy2m+jHd/eefabbv8WA05llFwhwqwl64vYyDJE9DQ98Z3HXYB?=
 =?us-ascii?Q?/G/+LENVXuP65AII4hGHFPNf2j1itWFwrE6Q3NslEVojaaQ345lb2deGhaKx?=
 =?us-ascii?Q?djzKc2OKCRcx5a/36zSe1Nc2J34oU5jrzpzS0a0jLSRAJ67ZEHhAWAeWoG8j?=
 =?us-ascii?Q?Zo5TSLZuqgIR8e6xKf8j5LSEcVuTE112F+eGWk04USY4om0C4kPsNNSVfx9E?=
 =?us-ascii?Q?zR8C9uBft64XGRj94s1QFJxs9YUJBrjZCO2Z7locpkibIXv7AprzIVTe39tH?=
 =?us-ascii?Q?f512tqVI7oE+Hv12YhhjziSblsRljsu9qOHiApblvBuFQMB3KH+/uJPtZkaA?=
 =?us-ascii?Q?0be9aPzSs3Dh1mg6z90mHy/lWQcdKQm7ZZ4tHOBVf0MJxknLdNkHFKwzPCLg?=
 =?us-ascii?Q?lVmXWutbojkHY5mRb7KcgWVCsYw+Q6X0ZghTDf9CA8DTxAqsVZverMbHJxtT?=
 =?us-ascii?Q?TBjHVlQ/5xmla9VB1KKbWdzik3RG/0pBiaewLd1h7Z/i8FX+8mrM2B2DCde1?=
 =?us-ascii?Q?8eIcUsZA+3F17+6FSQCK8EFgGNNKAePxRa7TGw//B5IjWf6Bu3gv6GltQrG2?=
 =?us-ascii?Q?a2o5CYzMgzERak1PDg/xylE2eouPpaVzKlMcxsFf8qVWwxbhfYQSD8SIZz7Z?=
 =?us-ascii?Q?dAHfULqXh7DyaCQiDtbXK04Hp2VcxytRM5kju42HsiRI63GLWk7b5d7zFc7T?=
 =?us-ascii?Q?QwQuv3crX/M/sZrcGapPehLUF2CMn9RT?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?KjzVOz7+zrpQVmmgGceKnQ8P/e4dHmDMsbQH1brinevxLSipuA3ErF2+wvEq?=
 =?us-ascii?Q?jVJO1P8xcE/sVTdGBZZGB4pj210wHS+oXCpwqlcFVzldzuMs/w77+Nls+oWK?=
 =?us-ascii?Q?gvz3rakHjM0CARReJOoUpqefmdt4pKNYkqQ5rz+RteQcJo05A7vMBAeyiWE5?=
 =?us-ascii?Q?a3BBBVE1ZlKW0Vsv7k2QoYU1aHsA3LXYrk/tcTliFTYsD2RUpNiIIR3OAvwi?=
 =?us-ascii?Q?+Q+Q/x0ytKmr+Zt37knkpxLYo2Vrhq8dnWj51f4eXXAlIQbhvN2NjoQgQAKk?=
 =?us-ascii?Q?ehtUz5DbgdoT6E9aP3gLxh6eGMbiR7NVRyuvGUG+74JVWWOfBmWatmp00b5Q?=
 =?us-ascii?Q?I5HNrwO2fuwDp2++zKOYdkg95rzmWJVK4hRIlEzSOnSvqFjjz8DJ3VFZr8Rn?=
 =?us-ascii?Q?G21WDMmzMEXReSdLzmRVni95tYPSExrDUGPc//Djq3XAQgH6g1mSVphe/sLN?=
 =?us-ascii?Q?8tFhujykgbboFUANHxnHYp33BDjhhx1tJfo+DgIIBp92Z4/5uiSv3vU/5EHI?=
 =?us-ascii?Q?uLqZNX/QR4UG+ZuNF0UFtrsrVTaPz/q26w8xiDUxfDjAMokcGvnrr+pEbqDU?=
 =?us-ascii?Q?PrqKm56VZWzACHVq8wGQ4R7t6NdWrBhhqldR/O9svPWEt4krWXBVM8FDfkR+?=
 =?us-ascii?Q?ebzMq4swGK7ueCqv5WAO3eZYosbfZ1sdFhnZ0UVwB+OWHIiVZk6V6f9fPiAm?=
 =?us-ascii?Q?it79yyRiqRhNd6gAz4tLrQvcNmJy3gr74tI8c8pIV67NuELzHu+FA3J7bQZC?=
 =?us-ascii?Q?QH4VxnFGdfpfaQFHnPdwrIQAkUW3THgPG7t4fhznZ7nMYHK6CCjApBmYOBMa?=
 =?us-ascii?Q?ILvvRtTvpxoEW2mPhP/lcq3aGRClNmWYkgDCWdStikWgmNVpEgq9ax7v6+2K?=
 =?us-ascii?Q?F+pfHYLvG0OfsLf7aetCmMeVJYkDeF1eqfDQyiaMT1sqyVH5ze6kgJfJ4uF7?=
 =?us-ascii?Q?F2Iqa016Z6zjiLQmJr4gS1PpanRfgBMHjQU+J2GDFEG8ZK5tl+Xs1kYRJ1D8?=
 =?us-ascii?Q?OzZUXFx/1TiRvLoTsMKkIDXqoOlOKKpRv+nMfq3C51GQDwCexNs6KumU5O22?=
 =?us-ascii?Q?v8oo798NxuGL7R22XTgWLUTwdxLXca03SfAXnoOkbl8YDOaeiCVnxAIm4zEn?=
 =?us-ascii?Q?O48rdzy5IUbsgsacGdB0StzB8ath1QSOCogXriiUhoGue5qHJMDtyj1w/z+G?=
 =?us-ascii?Q?NZRcKMLfI/8xy05X61tjPjp2OiTWR8qppgDghBNzNg5Hr4uXIIhuHY76Xs1q?=
 =?us-ascii?Q?fkKKjuLIgPBcOtmKgKEIKmuR3++PSi8QexnvRz02AXwVhBvONqzs8YTXG37k?=
 =?us-ascii?Q?mDgbPWGDIhU86eT9wVTA+Tetjb8046CMLFvEi7QubMfhtOcFvUiIgohoPBPZ?=
 =?us-ascii?Q?ecPEdr3paOACqwWvGuQqD+aRC0t15MuiQmwx4/wigGrgH9QSiRvE29Av/cN5?=
 =?us-ascii?Q?4PRvh+WAbiWHSfAwwDseW42mcl0gJFX/i+nI4wUjOPOU18+U2nXQ9ZmuL0HL?=
 =?us-ascii?Q?B8RX4zuaZGKfXInxSzhPrF0GTpKPsYxeXXyAsKSYVNAJm0B5gfC43+J6eMOO?=
 =?us-ascii?Q?+nsK5MiRqsMHsS0HrrXDHzwSLVDzVQKhP4T1Eod30HI9jNqIgqZl1V8ULFwG?=
 =?us-ascii?Q?Ci35mkwUeJsdgtF3U1YByFYYwCigngYsjCMWf9nk/gxr?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 72acee97-2240-452c-43f1-08dd5a921aac
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2025 20:29:31.5212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CZ/an+Tw9OavQRJgDPQwUC/XkpYIg2CYqwTG5Ufsl++xCt44oSYnmKI6vw7YldRoL0Fw6eeGRXcNB7RpbGwyrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7525
X-Outbound-SMTP-Client: 72.163.7.164, rcdn-opgw-3.cisco.com
X-Outbound-Node: rcdn-l-core-02.cisco.com

On Saturday, March 1, 2025 3:29 AM, Dan Carpenter <dan.carpenter@linaro.org=
> wrote:
>
> On Fri, Feb 28, 2025 at 05:37:12PM -0800, Karan Tilak Kumar wrote:
> > Remove unnecessary locking and unlocking of spinlock in
> > fdls_schedule_oxid_free_retry_work.
> > This will shorten the time in the critical section.
> >
> > Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicite=
d requests and responses")
> > Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> > Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> > Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> > Reviewed-by: Arun Easi <aeasi@cisco.com>
> > Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> > Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> > ---
> > Changes between v1 and v2:
> >     Incorporate review comments by Dan:
> >     Replace test and clear bit with clear bit.
> > ---
>
> Thanks!
>
> I'm not really qualified to give a reviewed-by tag to this, but it looks
> okay to me.
>
> regards,
> dan carpenter
>
>

Thanks for your review and comments, Dan.
Appreciate your help.

Regards,
Karan
