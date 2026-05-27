Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123DD43DA5E;
	Wed, 27 May 2026 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779905855; cv=fail; b=XMhgdlIe4mmgiAKjSXvwAQ2oEb5LkY4huxQIOax8wrt6H28RMJXQn5hfHBy+o5jSGETYQRwlMPp2zbdopRGTrEW3c1Gqxrk6ot7NZGFQG8rK3nWQBTix5qgTY30P0iiK0c+tNdgqMXomSG5Er21S5z1WyxyPx+KidIpvgad9ir4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779905855; c=relaxed/simple;
	bh=VfqxFB2h6Z3hc7SdwqVIXAYd6FQtubhwkPrwYqgVFm8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ku5tImihkCUAkH1MCoelrjpuWaRdc8CNNwvuBcLl+QNWbHnxgCFpeTCLce0e523KvjCtZY+S4DBok8huBxXK9UxA0bdVOI64w6k7zwy21XOCifOHvuGcMc0b+Zz0Wq7WGaltCjzkXIC1F4cCg55qNF5BhQcETiQSeTwasQ22vp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=kQGsBXrX; arc=fail smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="kQGsBXrX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=571; q=dns/txt;
  s=iport01; t=1779905854; x=1781115454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FZUgZMso3BtndoG4Bc2Zzf+Rc7yjS9hw8ccUsRQ29uM=;
  b=kQGsBXrXxTw+fkcy/ilWpkHgAbEhlXQlIMRCOVnq+1qD6CMaLW+22ufE
   RddVJUR6/U9vObxfGnvWo6IOaWQRDRKuguR1qrQzKS8/s5gAi9h7ZSc7a
   h2FBam+Xbh5x1VzVtiCjxHsEMvpc8ayc/3hcuXbmxdtXF0Bv+pIkUvtwR
   5QiheUvtL7gbMsH1xYYysl+jHCK96WUJQohoVB5ypoAMGmwRSFJIJdtvN
   My0gvSwN/Z+S80DSRTSql54mygayZz9seMyH2y8o0D7iUZT4fkKtFKXe9
   3u87VAC2QcdPP96Sa6kTVs8M2hLxh51Zff97f+dyQ1M07T38jdj4FfO+v
   A==;
X-CSE-ConnectionGUID: bdcmLE1ISjO18b3RrYklIg==
X-CSE-MsgGUID: ke1dj4BlT32AbjYpUaPD3Q==
X-IPAS-Result: =?us-ascii?q?A0AmBAApNBdq/4z/Ja1aHgEBCxIMZYEgC4FuU4IpiGwDh?=
 =?us-ascii?q?SyGWIIknhuBfg8BAQENAlEEAQGFBgKNMgImNQgOAQIEAwIDAQEBAQEBAQEBA?=
 =?us-ascii?q?QELAQEFAQEBAgEHBYEOE4ZchloBAQEBAxIoPxACAQgYHhAxJQIEDg0ahVQDA?=
 =?us-ascii?q?QKoVQGBPQKKKniBNIEB4DEVgTiIPRwBBW6FA4R7JxuCDYFXgmg+hEWEE4IvB?=
 =?us-ascii?q?IIigQyPEVJ4HANZLAFVExcLBwWBI0MDgQYjSwUtHYEjIR0XFR5YGwcFEiEqb?=
 =?us-ascii?q?kosGgMDDSEkEVlCOAtGBYFjAoIaTiMmA06BLYF/XQMLbT03FBsDBIE1BY1Eg?=
 =?us-ascii?q?yBNll2wIQqEHKIRF4NxE40UmVOZBqNohS0CBAIEBQIQAQEGgWoBOYFZcBWDI?=
 =?us-ascii?q?1IZD914gTYBAQcCBw4DC4FokX0BAQ?=
IronPort-PHdr: A9a23:+H7mdhfBP4EdChaWKSkzq1HQlGM/gIqcDmcuAtIPkblCdOGk55v9e
 RCZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NCBo
IronPort-Data: A9a23:F0pD5KOR0iYK/qzvrR3OlsFynXyQoLVcMsEvi/4bfWQNrUomhmQEm
 mZODT2HPK2KMDagKdAlaoizp0lVuZXdmIVlSnM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFTmE+kvF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV/lV
 e/a+ZWFZgf4gWEsaAr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj6/9iB0QSENQ5weRQWDFEr
 sYCGTMJTx/W0opawJrjIgVtrt4oIM+uOMYUvWttiGmCS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2MzNHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQtgOaya4eOK4PiqcN9nUvBq
 mCa1WDFWUszPt6u0QeMyl73v7qa9c/8cMdIfFGizdZugVuO1ikQBQcQWF+Tv/a0kAi9VshZJ
 khS/TAhxYA29Uq2XpzmVAa5iGCLswRaWNdKFeA+rgaXxcLpDx2xHGMISHtFLdchrsJzHWds3
 V6SlNSvDjtq2FGIdU+gGn6vhWraEQAeLHQJYmkPSg5t3jUpiNhbYs7nJjq7LJOIsw==
IronPort-HdrOrdr: A9a23:2KvKtKGnWiQ4L2x6pLqF55LXdLJyesId70hD6qkvc203TiXIra
 CTdaogtCMc0AxhJk3I+ertBEGBKUmsk6KdkrNhTItKOzOW91dATbsSobcKrAeQYREWmtQtsZ
 uINpIOd+EYbmIKw/oSgjPIburIqePvmMvH9IWuqkuFDzsaF52IhD0JczpzZ3cGPzWucqBJbK
 Z0iPA3wAaISDA8VOj+LH8DWOTIut3Mk7zbQTNuPXQawTjLpwmFrJrhHTal/jp2aV5y6IZn3X
 nOkgT/6KnmiPem1x/a2VbU6pRdiPHhxtFACMHksLlVFtzrsGmVTbUkf4fHkCE+oemp5lpvus
 LLuQ0cM8N67G6UVn2poDP2sjOQkwoG2jvH8xu1kHHjqcv2SHYREMxan79UdRPf9g4JoMx86q
 RWxGiU3qAnTy8o3R6NouQgZSsa0XZckkBS19L7SEYvCLf2XYUh6bD3OnklSKvoUhiKs7zPW9
 MefP00rMwmAm9yKUqp/lVH8ZiLQmk5GAuATwwpv8yY1CUToVVCpnFonvD2Whw7hc4Ao14u3Z
 WYDo140L5JVcMYdqR7GaMIRta2EHXERVbWPHuVOkmPLtBNB5vhke+/3FwO3pDjRLUYiJ8p3J
 jRWlJRsmA/P0roFM2VxZVOthTAWn+0UzjhwtxXo8ERgMyweJP7dSmYDFw+mcqppPsSRsXdRv
 aoIZpTR/vuN3HnF4pF1xD3H5NSNX4dWssIvctTYSPFnuvbbonx8uDLevfaI7TgVT4iR2PkG3
 MGGCP+Ic1Rh3rbLEMQQCKhLE8FVnaPia6YSpKqjdT74LJ9Q7Fxjg==
X-Talos-CUID: 9a23:1gqcLGwfy/jiB7kCOmA3BgUeFssgVlCE7UzSBBboAz1TUoyWTX6frfY=
X-Talos-MUID: 9a23:zprOcwi+hhFJyL+inSjlGsMpN8ox76byIkQxys8vscu1LRF5AxvGtWHi
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-03.cisco.com ([173.37.255.140])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 18:17:27 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-03.cisco.com (Postfix) with ESMTPS id 69835180000B5;
	Wed, 27 May 2026 18:17:27 +0000 (GMT)
X-CSE-ConnectionGUID: ALEBVcTBS+eYdpnZRan6Lg==
X-CSE-MsgGUID: FW342wviRYqMnFiirBzU8A==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.24,172,1774310400"; 
   d="scan'208";a="82775229"
Received: from mail-sj0pr08cu00103.outbound.protection.outlook.com (HELO SJ0PR08CU001.outbound.protection.outlook.com) ([40.93.1.75])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 18:17:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uYh87XqKbjXevb9mG2w+17cm7jvfQAn7O3Cy0yYwZHbus8VL8w1f0immJAXwP2VIWNBsySZozUw+w+ztqo30SiFqwAqvpCrHLDkD0HNZ27zX+BxRniaGd3rhH8vairYUyepcWwqQEsgYFZpef+W7T4cuJxSxdNYjSy2kA3YabM1zHw7WgO3DLuUqH+2OUKmeiN40POhhTIv3ajhl3vXPTMb4H30dbR0rpT8iCvTeSxaqdDNuZ3Fho3e0sAWxtk0d3okE8+tgbwgNHg8TAP+Quyox5ehRpTzwdeM3hFZhrop4UbbmkGSz3hgaNbyaIy+7+3C+xBKVkutUGHVhwoDELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZUgZMso3BtndoG4Bc2Zzf+Rc7yjS9hw8ccUsRQ29uM=;
 b=poULxZmX8p6PEumvuuIjU03JEyZXL44Jvzcwc4aZgBlyPtQgtSg+qAq6GHEOT92sPRI95boeRrDNkS5DSQF8eKC0dnxfGhPSo+YBp0rJa+a5dz5PMDqSqil7vIw6elPqwX8h0agxUy+5zd3DBNQULcJkAhVjROfOFlxHnjCTPI0SLTSLv3tVtUWZ+TMZJNmrO05sNLwj7vNjthz7oC5xACaQWjFX6S1lVcGrDlsc6QOEVaH4t21TTc/eP6F4A8msX8zYueKQp/tcud2fdksINAthE8bm6OQfyPocR2kEDleaXtaD7HU3+cHpxF7tOTUaFeiI/9taWMED5sT6SK880g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SA3PR11MB9512.namprd11.prod.outlook.com (2603:10b6:806:47e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.18; Wed, 27 May
 2026 18:17:23 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%3]) with mapi id 15.21.0071.010; Wed, 27 May 2026
 18:17:23 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Marco Crivellari <marco.crivellari@suse.com>
CC: "adakopou@redhat.com" <adakopou@redhat.com>, "Arun Easi (aeasi)"
	<aeasi@cisco.com>, "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>, "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>, "hare@kernel.org" <hare@kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "jmeneghi@redhat.com"
	<jmeneghi@redhat.com>, "lduncan@suse.com" <lduncan@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Masa Kai (mkai2)"
	<mkai2@cisco.com>, "revers@redhat.com" <revers@redhat.com>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
Subject: RE: [PATCH 06/13] scsi: fnic: Add the NVMe/FC transport path
Thread-Topic: [PATCH 06/13] scsi: fnic: Add the NVMe/FC transport path
Thread-Index: AQHc6UzHFX4kE2AiPUq1zy0c1MSAbbYhnAcAgACa6SA=
Date: Wed, 27 May 2026 18:17:23 +0000
Message-ID:
 <SJ0PR11MB5896634AB9B9C308CEE06365C3082@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260521180458.5448-7-kartilak@cisco.com>
 <20260527090050.123291-1-marco.crivellari@suse.com>
In-Reply-To: <20260527090050.123291-1-marco.crivellari@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SA3PR11MB9512:EE_
x-ms-office365-filtering-correlation-id: 6612674a-b067-4e54-c1c9-08debc1c331c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|56012099006|18002099003|22082099003|4143699003|11063799006;
x-microsoft-antispam-message-info:
 4Wt7Y0kC72kBUqySELpMK31WVf6RQL3IXN5mU5nH7FJrXfzyhdjjT0v+0Mn8I+KxITMtOGpVseOz5C1hqqN2gM5gyWaFw7zxC+mx1X3lJJ7Jyh0bOXilKcx9Ap9TWb/pbIDja3LsM66azLJ6meNQNCRNuKOdfrBp9UvI/7I91z3XkZAZvO9reTzpNk225IUaASkLiMm0WHLIVDtnJI3Z87uV5t/w7ZURMkhh6ksIQr0AM1aMwq4mC13aJ3tFC3Cwg1OMJI2w3fBpNfzfw0M60IDuC5yzWZaiyU0v/pm3TSAFrHXfU58+a7VzVPfxACpcuzjRrFZxnv1TV6JnoXFy3wxvnrUY4NxgzGT63ZifdcBu2LP+ayvNAqyOfn0VoRZJ+VsOBl2Ns6Fypq+bvAHXW9Eig203vpy9EHgw/9QANMHyQLx9CSSzuUutcxTyGCYFzkQz+EbkyU4ha0Xk86y1qM6eGtBdI4T3HTuZwfdcg6Kw9Lf0srMSvAAX34b4OWo51uhTxz5M/ztQNnw3SpwfYn2l08cveM+Bd3t5CaD5xRd6so6ptLgkV0rhWxL+AszhVsH0bux6Fsok0hwMdXB9kPCqehoEPmKV/rzWJLdy5AYhjdZUtlIjziGrTqPNaCbbdJc5o0pWsk20hAv8xzMhhiRTJXxadn9bashiaA4YrKRrcSeNgEGf7+XZEDtX2MlChaH4DZttz9RdUtJLJlNtixtoCiUOgf5i40Tcqk6WLVkiD0pA1p+075hSq6dzYjon
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?kRLR5+Ov1CMGPe/nWhyc49/k9Mo26SQE9DWwTj0W8eyQMJfC+Lq/Mmz577JC?=
 =?us-ascii?Q?Bf/DBsqbRejtLZck0Exb0yX0EQFK8YMFhI5/dKMKiYvTe2pIN5vp1Oex+Ldr?=
 =?us-ascii?Q?L4O+OnfjLuORM8bhPgBARIxnTcud17I5oGjewQeI+fAR83JzvdrrM1+3ib7c?=
 =?us-ascii?Q?FEGzPZBkMOdld3woCETfieUCwIfs2N7zWNwjcsP0nK1AKiOVB8SsJbFtfkJo?=
 =?us-ascii?Q?qcQeM6fExalwljugBiVZqfsMKnFgvj+ItWO2MjsrSJuWwUepiD7sffapyEwT?=
 =?us-ascii?Q?e5l5EtvcAJ7pbf/2mkGQT/Rm0T3Z2a9WF/knSUGC2Ln+IW4pvY/iILM4IYwf?=
 =?us-ascii?Q?Z50JbDBixJjCJeZBsSju9vz3hUqlaNGrPIMop1W7DnM3RtWQwyW+4QEzkLbt?=
 =?us-ascii?Q?hdZM+ZD3T2s8aDwfsbB073P4kXZr/BGD5pD29cBRdbxrGCKYDSQ0FFfs6+cI?=
 =?us-ascii?Q?9q4GiAkloosy2RZUYCZRlRFYtKpst2YIeyxWahcgw9Kk9J3wWu9heyKOsDXS?=
 =?us-ascii?Q?tnv/Gm8JUEYTjB3uo9m/F/1EJy5tcjufNGZNvL0fqZDKHvltq1Eh3Rtpmy9W?=
 =?us-ascii?Q?vCU0/6FNkD1aTk7ty+E93u+vGjaZ7JEdy5W2YZpaXDFeU4yETEIYEBNDhA4v?=
 =?us-ascii?Q?gU8L6j8+zmjfdHoBVORe4jdC/fFmm7q91M6IhkOSzThUxpfVoQI5obCXP9d+?=
 =?us-ascii?Q?S8GWZgp+imPxycuIZoJy0SKzQNiRT8dDceq5uMv3R1PLINOnG5dDTfm+2ftf?=
 =?us-ascii?Q?3NIf3JcInLsdIMwNhv6baA4/8OBdRhZrd6Na1VTArF71P5KtmbWhEHMqrbA5?=
 =?us-ascii?Q?i83TTs58qqBsfjtCZGCUEwJTLmNqvKZl47vQF9Fdh3M6Cb9v/BeuLyjF075b?=
 =?us-ascii?Q?NbbwVZJYjyIQx/01KnmQNIh0xfMQfr8iYAgwaW0MT0bGvKaHnS+FYOMqckOq?=
 =?us-ascii?Q?th1sV6JehQREVuSeIL8kmWSr6CkBmZVAjld78D6BGHhSnqRkbTidU1K0Ywsn?=
 =?us-ascii?Q?xihRSy/Oauz9oGVR9OTPbM+p10DID7APu0lqG3/N/p3zpBQ3rTVhtgRXGLrb?=
 =?us-ascii?Q?EDUuxc1nKIzep9GcWx5K0Q3ZNgXYliyeSSksWqxUFIo4Nym2xbHC5jjhYv9r?=
 =?us-ascii?Q?TFijUfcLUZNCG5cLgifeBR2LC2rWJQoPAUdyFVHge+fG5EafXDkwjlhqxuNw?=
 =?us-ascii?Q?BDL4secHGkMnDBq3g6b3xL6FnB+qQu6+FVIV3/rhY173KSUXXTiStP2MHjuS?=
 =?us-ascii?Q?yFWeVM+cMGIrXOzuP/tRrvje5wS8vNbBxT8xpAap4IO6egAOk37M3E/nyBJg?=
 =?us-ascii?Q?QFuy5xFk6JrBASO1r6fXCTx0K6fTcOAVm4YABdZku4lOmZ1cl4Ck5XajO/E3?=
 =?us-ascii?Q?3blH67BcthFnfLUsGt05hIdqRyqeUhGKQOXPLt5Plrtlz6lS3nWbiTpGOLl4?=
 =?us-ascii?Q?Vrlgp7xBX8OLuCJ/ANcUvZXb9tueCOI4DZh0H6/mC9xfexXSDrkRiFNNaMlO?=
 =?us-ascii?Q?v4KThhMhqzxI/qAAxLsx4mTr6vLNg3dPnYCwpIOYsBdKBhv7KIa5RziWyqcH?=
 =?us-ascii?Q?joYjrO97H9uz7sgN/PuFPgX2/NAiISU6TuUKq19cOiVEqXwspJ6BG4aH0P6u?=
 =?us-ascii?Q?RANtEm1l9uygEGdmDqrS2dcG9duR76GB+tKVlwmk/VCdpEjDt3j9eD8tZ4B+?=
 =?us-ascii?Q?fuR0t0JO4IDb/+4YK/Ejvaq1RglRjE2bd//21PxGYvJOkPOP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	MH3vAf8PVQQg1RjfCPg2Sgo8gX6mg49DxIcuucGwWG4FL0d54xp2s2+en1DrE0VY3IjAybmTHOUssfA7YXRxHV/+yUbfx5TbiKwicDTOZbSENqvaWaKGeHrmfPo8yEOwDtDQ7MXpLD47FFhwDTL1g2UqhiEvq5hR6WVEmBkL+UlKkoPnWj+wceyFY7AENc5v+NBNKRefYXmfe8WM7j8t5+r4jqMHk3WviOI0m2skRDCjWLVJ/49fKV1d4Jm96EVHZc89XF8CXqp9POtYKTtxF6A/yl1GqFIkK+YmfufjeJVPQjFCjPz7FFd2AtNUaRyFUXtCQId3xEgcq28Btc1AKg==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6612674a-b067-4e54-c1c9-08debc1c331c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 18:17:23.5319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qINQ+KJeQu/ES8agiJiXM1LkREkRSLj8DtihUGpElimk5ezz/7qT9y7MJUN89AbPLlXXmdjY04G+7hW52MYcKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9512
X-Outbound-Client-TLS: ANONYMOUS;rcdn-opgw-4.cisco.com [72.163.7.165];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: rcdn-l-core-03.cisco.com

On Wednesday, May 27, 2026 2:01 AM, Marco Crivellari <marco.crivellari@suse=
.com> wrote:
>
> Hello,
>
> >+    fnic_cmpl_queue =3D
> >+            alloc_workqueue("fnic_cmpl_wq", WQ_HIGHPRI | WQ_MEM_RECLAIM=
, 0);
> >+    if (!fnic_cmpl_queue) {
>
> Please note that this workqueue should specify one among WQ_PERCPU or
> WQ_UNBOUND. If it must be per-CPU for performance reasons or locality
> requirements (eg. per-CPU variables), use WQ_PERCPU explicitly.
>
> Thanks!
>

Thanks for the feedback, Marco.
I'll make this change and send it out in V2.

Regards,
Karan
