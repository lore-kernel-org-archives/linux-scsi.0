Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDEB1E8331;
	Wed,  1 Oct 2025 09:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759312096; cv=fail; b=q5mCMRRVoN3+M539im+FU3PmhcR2rmA+I/8OQBG5n4rM+4WFieloxQ+LHtXEkZYutQfKnScQnJZbKoID7/gwWPfR1sMhehF2OkYGxiu4RMwEVfldgPwyAVYygK/TlAnOs2g8SFQ29FeGCaHubbAmmEFjTqMOL4t/PPzfOKW7JEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759312096; c=relaxed/simple;
	bh=EGAR5ajbrWsDqLLiWuU22l1EN+x2N5ijjv0C2kWN+54=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m21dFCN0h7XqLPyzHF55jh07+51HfEW6J92rRwusf9ogbR1IekcfYD16Jzlv8PVZ7sn01DZS8R3s353cs4w3VjeMATBzkf81UcQnKjBpSPOvAH01TAOI0Tc1MRVypR1pLVneNB2KNJX70wFMoOrZMRaErpdvVpBhuqGRBPqyDPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=gptAtXLE; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="gptAtXLE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1759312094; x=1790848094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EGAR5ajbrWsDqLLiWuU22l1EN+x2N5ijjv0C2kWN+54=;
  b=gptAtXLEzBoVRdZz657XWDLc/8/mzmbPHyapUtP9YBF4+e9QTdzMj2Ux
   ufYiaG/l7OdsS3S7EsXIcoSClHa2NAbxKdk6l9XxC/6GSqwVVZGmBMplh
   NqTv3NJTsPoyeDQQIoMEO7Tzh/nmUik6DFCWhXb4Luh65VjptC+dYGT7l
   0JmdG6tCVMaug4KJZy+HArat31JKRLbuDSRbC8Psy7Gu1hEZmqeYXmJha
   NVV+vymbb1xhOj14NplxR+c+V17Jh6xAn64cNRArvPZtaSYm0LWUaNXhl
   nj/enh4cW4ZFJPGnXOL/Gaa7eOxCctncBZ7CavCOaqsAQME6lNLqYoy9G
   Q==;
X-CSE-ConnectionGUID: mfMK8o1fTTuQfTWytpOKFQ==
X-CSE-MsgGUID: bXtM45lCR9GhanjI9YkvgA==
Received: from mail-westcentralusazon11023098.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.98])
  by ob1.hc6817-7.iphmx.com with ESMTP; 01 Oct 2025 02:48:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BUilkkkg34M8TnnacyCcoHmznC+gDlrtqw/siEC9N0BicnBu90AWf1PWO8QMIvHEH+WVV2nvWADorMArlVzxiXfEx7twuyZ8W18RjJb6dqG55HjjEvbOLlFt6bsyUs6p7Uq6YCwm+w2/lC3TyiJIkSZy79iSOll06p7y0ZofxJ06njE67HJN2iTkDAZvgm9EXSe6qLt7E/6IkSurOGIEIEkTJ3wwuFwVcOmMIq1+NwdH1m8SRcuxfHq8m2VUt2lq8aFVCqw4oHb7yziIGterufaiyBGD+LqR7QHXUNPOMH8ynZ0mDEYx8YmC4cJzwzffX0+dd0C1TqzHx7t06DpK2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGAR5ajbrWsDqLLiWuU22l1EN+x2N5ijjv0C2kWN+54=;
 b=hzlDJCZLzNi/okb6qXa9EJfkRvwtFW3faH6+/VAkelcGlxTVQGe03/kdqOXd2V7gdwbprSr/B/sph2/Q7HiakA855L5HPXswtHi0YnJrlr6cG56V6h5uja+YdStNvonQuYRznKHOn3cxQ/olNTZmTMscZzaWkx4c0LuDeQANlYHbvSkcmyBrZdW8CmiLzMYT7d7DwvtiPc9HzvEyPaBbuFZMJ4a/m+WBXZZDPUc/+G7sTbzRfFI5NN/1r7/Wnv30V8LNobg4NbPPXLTdkZySyHSTlw7k/5aOmflq3fhiXqaUOggLMCsWffhdCUlfLqgSLZDXisOaqPYzc1X9i8GlRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by BN7PPF902AAC9F7.namprd16.prod.outlook.com (2603:10b6:40f:fc02::717) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Wed, 1 Oct
 2025 09:48:03 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 09:48:03 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bean Huo <beanhuo@iokpp.de>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] rpmb: move rpmb_frame struct and constants to
 common header
Thread-Topic: [PATCH v2 1/3] rpmb: move rpmb_frame struct and constants to
 common header
Thread-Index: AQHcMpnm/l4p3Z1QsEqHWmDVKsrzbrStC5Rg
Date: Wed, 1 Oct 2025 09:48:03 +0000
Message-ID:
 <PH7PR16MB6196D072A8A753B06EB8B2AAE5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
 <20251001060805.26462-2-beanhuo@iokpp.de>
In-Reply-To: <20251001060805.26462-2-beanhuo@iokpp.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|BN7PPF902AAC9F7:EE_
x-ms-office365-filtering-correlation-id: edbb2ba7-3ade-4c4f-0353-08de00cf9d5e
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?bGhOSStQeDdVYnpRS1VLUmtZbktFa0hDUUliOEhPYzVadm5acU5mWXdFV3dv?=
 =?utf-8?B?aGZmVUc0RmxOWloySXZrUEFTRDBiNGw2NmVFNFpoclJRUFl3aVRGWWhXQUsz?=
 =?utf-8?B?UERnaStsZmFRWHhhSDhrdzlwZUlUU2N4ODVGYWViVWlNb3dIbWhGWnExbkJa?=
 =?utf-8?B?a2wxM2VFSzFXKzQzU0dhN3FUSUt2ZjRRMFJjeWdQbjRja29SYXJqRkd5Uzgv?=
 =?utf-8?B?MUNOcSs1aDVITGs1djFlTGFjZEVlR1h1SGt2dlNjUHVKcDFiQ0VxS1VyKzhT?=
 =?utf-8?B?RnczSG01UFdKU0J0WW5WZzJXTGtlMVdvd0s5bTcxU3J3Rmp0eExacnNWTTV0?=
 =?utf-8?B?NmFMYUlKQ215aDd6Z2hXNG5Nbm5Eck1BVFdDU21vRUppWDF3YmE2TmtBNWRs?=
 =?utf-8?B?NDQyUS95Tzd5UTVKa3lWNEFDY25kNzVPcVlRNnBzbFpDQXFkMzd4dHpSNGlx?=
 =?utf-8?B?bDdOckdiRTZRL1c0NXZIMmtWOGtnRTRSdDF2TElMdnZQS094cENSRDRlNHl6?=
 =?utf-8?B?ZzlHbWhnejY1anZ2ck5wekJ0c1RPWjAvTWRnMXRFTWYzUllmRXM1RUEwbnFh?=
 =?utf-8?B?K1h1KzdrMXhmdm9QbUJERHZMQjIvM25oR3hncnNxY3NCTFNGUjM4YUZ5Y2FK?=
 =?utf-8?B?WXQ0SExVMzcrN2JoS2hZNzJuWjc2b3hCZVpBdStPT04ySmZPc3lWY1hhN3lN?=
 =?utf-8?B?S3JwaGdiRmVRZDRuTDNvUzNUSXNLZnBKT1BGOHVTZUtSUkVDNTdMZEFCSGUy?=
 =?utf-8?B?cjgrMnJabWxUaUhNWlU5eVEzTE5YeWxGRU5JZWd0YmxSQWZ1ai9ZMXRwa2ho?=
 =?utf-8?B?QVdNdzAwcWFQOWlRWTh5RHJ6YkpSelQ5cUZJVzFiSVZtZHp2REIyS0NRdW1M?=
 =?utf-8?B?M1ltcEl4bGJ2R2JWbVZ4SlNUZmNha2pwQjh3aG5oalBSOXVMRDFJaU5xSDI4?=
 =?utf-8?B?eFkxa044WGhUUFRTQ1dRa1FOZlZoZHh0ZVRIN2g3NkxUdnVzTVY2eTArYndY?=
 =?utf-8?B?cklEQjVuazQ4dzJRQ0czMHc1SUVxOU5MMjV2WmttOTJ3NGxORGh4TU14bWpK?=
 =?utf-8?B?VkRXOEYyNUMvYVZBZ2xRQXFra282RjhuTnprQjFwdEl5TkxoNU5EYmNBZmpl?=
 =?utf-8?B?TFV2MEJIZzBPTEJwYkJiK1FVcWRES2pUSkljSEViTTlkQS9QcWZKMjRCY1Y1?=
 =?utf-8?B?dXpCZENHM0hQRjJORHA4amtCd1YxbGlCTnNYa1p6YkIyQzBLaG1xSmpIZ1c0?=
 =?utf-8?B?RUw1aThwODg2UG5HVEw3K3ZlT3c2RzFCNWVVeTV2eVBBemtkTmhOK1poaFg3?=
 =?utf-8?B?bUZFdWd5bjFUU3RBTStMUHF3VUh3N2kvSE1sQ3hXcUk5dStoT2tyaisvWDJS?=
 =?utf-8?B?SkVrelJZdi8yUkxQblBTcUgwZm5BT2pRSmhsQldLdWtjN21FYWwvUlovM2Yw?=
 =?utf-8?B?clUraFoySHR5T2NENmpGSy9ZMWRIQzljOWFYUGRocFN5bDAxQ1dlVzlLZjd3?=
 =?utf-8?B?Y1pZcytiV3NTRU9zTjF0LzNPaTROMm9iZDZSK3RlNjFGbElsdFZ5STBQVzI2?=
 =?utf-8?B?UnpzNklWRmhvNS9Mc2o4S3NyVURCNVliMEdyMlZNNnUzU0pzYlB3UElOQXNn?=
 =?utf-8?B?VzN4bENGVXNldDkrVmdUWWE3ZXcvSFB5WlQxbnBHME1CQjdjTFliQ3JhcXY3?=
 =?utf-8?B?WHV1dnl4dXZsK2VRL0dMUURSS25PbjZjQWV3V3gyWlRvVkZOTmtiWnZVT3Qz?=
 =?utf-8?B?N1BWTlBCU255RU9PRi9nZnB3VWRNbWY0SzlBdHBFWkJYTlF2TU40bzlrTU9V?=
 =?utf-8?B?UjAxdGpmaStna0hkWDBEZlNYelNadisvWmNubElZa0lEektWOUE3T0JkdzZJ?=
 =?utf-8?B?MzFwcUgrWGYzdWxLeXpMLzhCWFl4T0d6ZGg3Zkt1Ym56RFNDS2JNdEFwaisx?=
 =?utf-8?B?STZwOE9vZFBLSWVxWkkxb2RmcUtHNmRUQXlyT1hVVEExU05iNy9HSDRSOFBu?=
 =?utf-8?B?N3VIa0Z6ajNkeVgxRG9rQ2VOckhsakk0djdnaHFuQkEyeEIrTGE3RkUrOWE5?=
 =?utf-8?B?LzM2eGxCTG9OeWNTQWRUb1NkMkxzQlVncVpwdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0JjT25RQ2g0S0FvczROTTJBRGMwUWErTThnWk96UkxqV3Zud1B4MVI1ZVNF?=
 =?utf-8?B?cXN3RGxXUGNFRVhtSmIyRE5jSml3Vk0wazBMM2QxWk5vL2xSVlVGcXVjMEMw?=
 =?utf-8?B?NzFOVnVVSGw3MnY2dS9ISXBPaGxwN3RjcjBmTWJoa00rcU1ZQjl3aDZvVFUr?=
 =?utf-8?B?engrREFPR0dOVDBPajR3YUJWckwvVWxhREQ5a1dGWlJyWC8rY0lnNkNEWFlN?=
 =?utf-8?B?T3h4ZnU3czM2ZXR0d3pHVDZqb3dMeXF1cnZpUFdPN1hDRnR0RWEzVzNsTHla?=
 =?utf-8?B?QWpYWVp3eldrcjBNRW9EUUJjNllqbXhLdkl0R2FvQ1FCd3ZHN0lCQjBvVHQ1?=
 =?utf-8?B?eDNxZW9XaVA2VHFBMGx2cHZmZTZRUGdSdXQwMVNjc0dFRlhwN3R4VExNb1d2?=
 =?utf-8?B?cEd3QVJlYkZLaE4wcTFVdXA5WTRySHlQU0IzKzdYclN5Z2lNLzJXZkNLaTVX?=
 =?utf-8?B?Vm1NMEI5V3hJZkxDY3JDZ2U5QnlqTXdOT0xpbGZRRDBaSGRGa1ZJNC9GR1pW?=
 =?utf-8?B?Y1B3M2txcXZOVzZtVS8remV5UCs0bzU5OUtGcjJXUm5aZTBsZlJJR2hGeVNm?=
 =?utf-8?B?dGpiK3VlZHEzVjNIRWd5VE5pMjBRNVZmYUc0RGVhaUpzTWVja3l4Ty9rUHBS?=
 =?utf-8?B?cnZ5VzIrbXJVeldyeHJBZ045NCtDam9OWm51cWdjZkMwRkIxVVZIMDBCem1s?=
 =?utf-8?B?a3pHR3p0Y1RwYkNjSDNvMHR4SXA5T0Z2TCt0bHBhazFsdHphaVZ2ZXBnaUZz?=
 =?utf-8?B?ZDZlZU5Nd2FQRXlaeml5ZStWN20wQlQ3TEJuK1d2dGVwaXRLN29CN01wbFoy?=
 =?utf-8?B?anVRaHZ6T25BZkNxOW5wd04zbU1EaWZOVVBBN0JBWjQ3U3UrRTA3aHQrRHN0?=
 =?utf-8?B?WS9IZkZKcDRXZkI3M2NVdUQxcXBwNmlERk04TmlubG1tV2RKd21NT1JtNFJU?=
 =?utf-8?B?NmpWc3NUbXdsdFV5cHJvVVVDMDBvaHg0WFM4cG9icDJUWElQblhjSllBRk5N?=
 =?utf-8?B?R3NoMS9IeG1lbkEzUVUwSTBDSkFBeWh6VUxFUlFRTytaV0RYc2piUUUza1Zw?=
 =?utf-8?B?dDc5QnBpNzRzQlR0ZCt3enUwUjNNeGQyeWpnSUh4eE5XVWFHQWlGRlIyd3NV?=
 =?utf-8?B?bUJkblJTSWtaQzh6UlF0SmUzZ2hCN2c2ZWk4MmVIcDgzbGdrNndsOHdkVS85?=
 =?utf-8?B?dzlZQURzUTMxTHVFblRKcjFQZXFGSHhCZXdrbm1kQjRBM29PVmsrbFY4Rzl4?=
 =?utf-8?B?T0N5Si9kOW5Zd0NaRXFYczZySzZjTGg3Tk4zMUMxNEtNWlJKMVdiTzdvSVFs?=
 =?utf-8?B?d2h6TUNoenZYbGxKMUljR3lyNnNnd0MyNFBsU2hvUlNjMDQ5RFhrYkQxR1FN?=
 =?utf-8?B?UktGY2hNVjUvK2JnK0JLNGZPV2EzalY5ekhxQzBWUXlSUXBKRlFkbnNHZ3RR?=
 =?utf-8?B?VWpWc0l6c2dWL085T25vL3k0dG5VQnptUTFsTWJocWVxQ3QzRWNEU1ZDWXRs?=
 =?utf-8?B?UXVmL3hKQUZqcERFNzBJeE5YclFWWGhTTDh0RHZKSkt6ci9mUDY3WU9EejRk?=
 =?utf-8?B?ZS9Dd0dYdmlsL2xCcHRlOEpsYXIza3JIcEZRb1RJQWpETTl0TER1VGFBbldk?=
 =?utf-8?B?eWExcVNMUll1amtmcTBjWnoxMjRMQ1NsODdoQVVmVHJneU52Sklqc2F0cFo4?=
 =?utf-8?B?UXlLYy9qaDVya3lnYUwraVU5ckxkN2lZcGt3NzB1UitPei96dFMyNXlYTVhB?=
 =?utf-8?B?ZW12NDBCZXZDZ0RHa05Na2RkNE9wRmx1NFBDRFpQckZ6UTE5czNWWk42NEtB?=
 =?utf-8?B?eDBmcW43bGM3UkJOWC80MlBNYlh3WVVwTTluMHVjd3YrY0pwM0pOWVg2dTZQ?=
 =?utf-8?B?dUhYVXlvQ3ZrZ3B0VkVtbUxhMkZlMUVPYi9sVlZDTFpHUmdPaEpMZFhZdkVP?=
 =?utf-8?B?TGgweG4ydkZUWGVNTVZOVTh0QTFhTDd3WHA5MU9FYzh2KzE4cnZpSjJhT0FD?=
 =?utf-8?B?Yi9JMWhxdzNzODhMSVlFdDFzaWI1aTh0WjRMRnBJaWtOenZ2OCtJYzVoZ1Jv?=
 =?utf-8?B?eUVaekhQY1FtVHZlYktJaGpGUWJWNld1anZJK3MyeTZ6aHM0OEVYUHczWSty?=
 =?utf-8?Q?OQcqCrmZDKYH+RyNdAFLUhGtM?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GtTsLPNa0InU7Ahj7WX8BvZcQejm/0kPX5ZzD9mes8XCxHAOgtwy6osM8KRGNxe9gwJItJ06FxOEecjDgrwO+FFwgEJCGdEVgZ770pcbShVm1YLdHUdQJMx2PO287BpWB2oLB+aNUWE+rviav90zSOWmO8OWDX1nBstW1OEU68owTCQfQWOtdF8cRx+pt71gQRaIa6VM8Rrj2Nq8x+DSA5nqkFR4KbAvvSYQU8CflRjihhXNnIXVNPTUaogRRPl4qBMAU4Pd6U5Sv649hjOY6lFtvsoG3ISyF8wwMvoSPculg+uLQTOV+GiECOkl49OiFmMBf5SDR7gXb1sX6oFv224QyD2APFjIxFJSrQOMTe+7Z4+WZ2VKsJQ8leJ2nBp+V4y2qlQ67ui4OOY2EPAAEoW3//Vx2vlEi5KXvHsGoctmGi954JreljpttuOhYKbALtT0FzviryOgSTeQLpH08jreLLvYZr7lBRaMcxGd1osp20RNu99yTOJJhvmoM7SQDtUYfOjn9atShQG3yoUhU7LDpBVeuYYivPUNC0isf85VxPgxlnE8/At52EO7EMBoz6OqXhlRYuYtBSE48njcBYQTHj5oIAiTeSYk0QwB4dhsMWELZkV6Y06g3d1JZLTBtbMq6JkWdwiTRpoeA8RA5Q==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbb2ba7-3ade-4c4f-0353-08de00cf9d5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 09:48:03.1482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5u2omXg1ETBMHCuD4orp7y8l6LEbc/t1VjB1dbgM1tse/w92YLqloxPzbgQ2ESzsO5W80C/aoW2LlA+7vhZZhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF902AAC9F7

PiANCj4gRnJvbTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IE1vdmUgc3Ry
dWN0IHJwbWJfZnJhbWUgYW5kIFJQTUIgb3BlcmF0aW9uIGNvbnN0YW50cyBmcm9tIE1NQyBibG9j
aw0KPiBkcml2ZXIgdG8gaW5jbHVkZS9saW51eC9ycG1iLmggZm9yIHJldXNlIGFjcm9zcyBkaWZm
ZXJlbnQgUlBNQg0KPiBpbXBsZW1lbnRhdGlvbnMgKFVGUywgTlZNZSwgZXRjLikuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KUmV2aWV3ZWQtYnk6
IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkBzYW5kaXNrLmNvbT4NCg==
