Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8646513AA5F;
	Tue, 22 Oct 2024 06:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576944; cv=fail; b=gqNPi1wC1RiZSTPYqcaL/NBEbFzArmBPTsvZACV3COXO53rog7tD7lsBtkbYv+W8wkMVwR09va2tbF2R910uMw3JocWzNFD9DyIWVMNeJR8/dmn4U0OjMV5kLQuKxiOF0IiLzofxqV0UyxzYUrQdPBC8fZRLyRcYytG/oMfAqQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576944; c=relaxed/simple;
	bh=eCP/UA8AFw1q+GV7Jc0tdyZ2rB89aj0QOtZ+Gdmkm9I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jKl602ruv/pYaFarFFzFs0LiuOY4lVqtsC5iOtYnqsHgOXvNsTGQGE4jBzkQmU2QFNKbalJSNe8NWrRFzm5JLEsXY9wUTYGegej6hgCZl8Ssvlbhw80jERLk3j5do95UEg2rQihb9qjmcDa6JRMN8VqKkxmREWjV6ElTFKW1HJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pjbuyeWW; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EotN5M/v; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pjbuyeWW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EotN5M/v"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729576942; x=1761112942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eCP/UA8AFw1q+GV7Jc0tdyZ2rB89aj0QOtZ+Gdmkm9I=;
  b=pjbuyeWWJJF/q304Hj1ANgkPgMmNiQiXBiIjueTw5D4pVSL/OKP3HCIx
   RBMZChq9FZF1eLlj6CK/Hd5p4r/jL52oEh8DCB23b+FtDqCATeYgXvJor
   hHS/XcHCH4dazUOomsdhTf8Li7Nl+UcIN7YYUSAhjIx6lfbPfaZbfsP3q
   KpxGH9jpueZ9n5AJSTisZvGXfePoeu0RgefBb0ZW/ONm66mel1UPzNxhY
   Z29U6hVKFQ5kb3Y+li+GqsMKwN+2porwGzm2EDHTfq+3bs4OyV55NXFHt
   PUv3J6BTvtVMS4g3a5da/3seXEyhv4UU/E+lFJpFfdOE5lHVhMH2THjur
   Q==;
X-CSE-ConnectionGUID: ZZnF/t16S2GqsCKZMUW0zw==
X-CSE-MsgGUID: Le9M7OvJTAuZ2NevvJk1Yw==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="28957432"
Received: from mail-dm6nam10lp2041.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.41])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 14:02:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgRD6En/f/Tv2b1w6nbJRuq0x8/hJNjqksXfAhNo98iNAF9D9OAcSvST7vu1Jueet/krrrzAH4bfLPGNpEvbJk5AqARoHWCfVLmVy3mzKzuSBN44/BN+LfSxSh37DeoIwjmhn2e6TZ7zdr9NOIHQGCoLY6LAVfVOrnIOsPHEeqodR1ytX2iNH+rrlhZkaqlY3DDoIwyRDXTJ0UC43CHEdpfqUgujfIsrbhWIHo0AiRgiOI88BPKC/5F3Tn1geOoIp0ofGR0QiwZS6KsrKyu4nNsHqknPcGXAI+tgbWBSLTNWvsqtrQYDOBKbWNFocVEd+LANbfnB0u9BpXNfICqooA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCP/UA8AFw1q+GV7Jc0tdyZ2rB89aj0QOtZ+Gdmkm9I=;
 b=NDaniPaQsv7zTFsAMtarhHk38knvgvl39XoPWy3YndkDySSZVhpSCXRh+wd5dJLyLX24J4Gs73ef+K17BpR3Crqc0//vKz8JexKmn9sKhtZhBucvp6k45P6LZKY3CCp0b7RdGLvg5Lg5RAsJKAGdG8/UNKehUngN8MAt6lix78utQpvYVxV9RjP+ieDJ8UeUUHdUSsWMAfqxA6nBX1GoiqsLParPdPNnAFiPxM+iR7yQxGa0fzmQ8Dx3QR2yCecLE5gLzamf/wWLg3b5mKADCXsYEjIcb3WIkTDE6+X/1l0CjEnnLQd/ReRWjO1tNu/1cC8PCcplTmEOTC94Qv5bMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCP/UA8AFw1q+GV7Jc0tdyZ2rB89aj0QOtZ+Gdmkm9I=;
 b=EotN5M/vnCvXIQlZTkcMjkaGBP96qqMmtxoN8/+HEV/ECs7LitP7k/6I7eFKuPj3ff9ktxBr5aWTS/RJQwxrT1aOew6p+dpLI0jUf4abHTRcxAnJXf8gs0WhHmNCSjOYXCr430PiSGfqopTo67s6/C58Z36/4zwKEO9vwpemRN8=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by CH2PR04MB7109.namprd04.prod.outlook.com (2603:10b6:610:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 06:02:13 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 06:02:13 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] scsi: ufs: core: Introduce a new host register lock
Thread-Topic: [PATCH 1/4] scsi: ufs: core: Introduce a new host register lock
Thread-Index: AQHbI7GMY5o0GAxtpUyP0oN+iSCN5rKRiK0AgAC/wcA=
Date: Tue, 22 Oct 2024 06:02:13 +0000
Message-ID:
 <BL0PR04MB65645EEAEBAFE56E9067998DFC4C2@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241021120313.493371-1-avri.altman@wdc.com>
 <20241021120313.493371-2-avri.altman@wdc.com>
 <85d2cb9b-75ba-4ab3-a50d-0f8161456fcb@acm.org>
In-Reply-To: <85d2cb9b-75ba-4ab3-a50d-0f8161456fcb@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|CH2PR04MB7109:EE_
x-ms-office365-filtering-correlation-id: 9cedf445-a526-42ec-8e58-08dcf25f1332
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?T2xwWFJJdHBhU0NIMEJReXN4T1NtbTJlcHJmcU5oYkU3eDM2SXZyLzhLOGdp?=
 =?utf-8?B?RTdsdW1iTkRKdDBPY2R5VlJGQTlIWnBTOXlNNGxPRXdNckRNYktBVmNQaTha?=
 =?utf-8?B?eGxYTWx3ZVdmRStVb3Y2cXBIemZvYmg3d3hTcXgwcVFDY2JZZGR1RFM1bStw?=
 =?utf-8?B?WjNkclp5MjFQc1BrTk5vdHVqRXVOYktjb3dwNXI0ZVdST1oycTF1clk3NVdx?=
 =?utf-8?B?SkhSWmVGVUJyWXZoVHc3OEdOQWhlWUI4UE10cW5HRjNIQ1FvcDM5Q3Q2NHRY?=
 =?utf-8?B?K2xuVktoVEVsSEc2VWZpZVk0K0h3OEEzdzh3OXVGaEQyaEZpZW9iaFExalNP?=
 =?utf-8?B?b05icDQxbXR6UXI4bDZyMUNFeWNQRzJtSG5LNUlwMDZpVGZUVUFBVndVVVNh?=
 =?utf-8?B?NnRCTlVDZnBrM21MUFBwMUlac01lUUV0bE8vMHkxbURMZ0NDdHNKbEU2eHhT?=
 =?utf-8?B?aC9icHhQN3dHZHdGRFU0N0tsb3ZtVVVZV3dBMmh0WnoxWnhYWncxb3BUY01O?=
 =?utf-8?B?OUZ2dGIwc2p0djhudHZWNGJpT2pTdnFNUHBNRS80YW52cXQxazBNVHFVekRN?=
 =?utf-8?B?a2V5WE5VSE53VUhJb29XZjRZdFVocFZ0NitKQkxwTXpZVjd5c1VzbExHVy9K?=
 =?utf-8?B?YjYwN2JwSG82NWk2VGRsWTJjUjJGS253T1JPa29OcDJVWGcxUlhCczYrQmVz?=
 =?utf-8?B?Ym5uRjhxay94ZTRvZTJmaDhPWU56N05mTCtPeHBuOVpPeG9nOHZGT2VFblA3?=
 =?utf-8?B?MWxTalhDdnh5WnFHY3pzN015YUtrWUY4WnZHZzgwREQ4MC9UQUhXNGo1TU03?=
 =?utf-8?B?bnFnZm1IMUZwdFVPZGxYR24zT0k1c0pSMk5INFRBUy9URUxxNmE0Wlg0ZU5n?=
 =?utf-8?B?VXozdDBVbDFiNmhJWEpkaGZ1YVNtL3ZQZlBFSjNTUHJoL1ZkbFJ3dWdycERR?=
 =?utf-8?B?SDRzQVloTVVpN0ExN3g0WjIrQVRwR242M1A1d2RMcTY1VVIwQTJPL2xPQnhR?=
 =?utf-8?B?MXpXa3JMcS8wdk1jRnZaMFM1VEw4VUdPVTNCTWt2cjF4UTdHNmY3b2NRa0hD?=
 =?utf-8?B?STUyb21RbVZYeHFTTFV4MUlHaFVIcUpXeW9MRFZkTk9oVnByZi85WThHbDVJ?=
 =?utf-8?B?eUo2T0dsTU9LZHNkcm50anY2VUZUNTRVMW9BR3ZjZFV6UlRFT2ZralFGam5a?=
 =?utf-8?B?VUhPWURFWS82azNSYk5NTUhhdkZ3NWdTMGsrT1dhUjNTYTZKWTl3YWRqTDJM?=
 =?utf-8?B?Y0FHcUVOeVB3VFZ2MDZyK0gySVBBQWI1QURiUXVWd3h6MHh0SngzNVdhWXVu?=
 =?utf-8?B?R2lTTURRNGJ2MXcrWFNEVEY1bXBkcWZCV2hadTEzNjlkWTcxU3YxNzV5elE2?=
 =?utf-8?B?dzZQdnk5Nk9yWnpYM08ySytZUmxHUVZETDZTTmJ3TWJ0QVk4NEppNHZWQ3A0?=
 =?utf-8?B?NDcxM0gxRzdMa3Bhdk9sVjdyNW9aVGlnQ2hHd3JyUEQ4ZUp4V2ZFdnlaTnRx?=
 =?utf-8?B?OXo0dFVyY0lja0xXTkM4Y1JZa2lpbEhMbGVFekxxRWlSV3pheFErK2dSQ3FC?=
 =?utf-8?B?WXU3cXJsSW0wYzlNbEF0c3VTVllFUU1qU0c3M2pYcTVJWFh4UTBIZ0dwZzNl?=
 =?utf-8?B?bjUzcGNPdU1DeTc2eTMyTVFCVitCQ0tNemREUmtSUStzbmZHWC8zVnhnKzhF?=
 =?utf-8?B?YXN1b1NEeVVaL3E1Ym41MnkzSmg5NmorMFV1ZCtWQ1I3bXE0T2JCRmcxT1lK?=
 =?utf-8?B?ZDhpNDJJZ2p3MnlWVmdaanAwZHZ3OFJ0VUxta2VQR25GRnhhTkkxOE5LbWNG?=
 =?utf-8?Q?Dr+M7RShYWjPRqvBWQKj1jdhz2baBQIxkDyVU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NVllZUpkaWNhUnc3YkJiYVBmbEo3R2xEOUZjVmNEYkFrOHFZNVhoZktEa1A0?=
 =?utf-8?B?NTF4MCs0UWVQMGVXaHNLSjg5eHFaeW5PNHBWT2VYNUNvbHR2RHBQeGQxVnJX?=
 =?utf-8?B?WFFuWDdJM05hd0wyQXNUamdFKzBZU1EzMU5PNENHSmFiV0hKZW5mYzlaOUdV?=
 =?utf-8?B?SEN1QUUyaGE3aG9IWGptMjRGSmt3R0NIUzkzK2o0dXpxRUdMSXk1VlZKUC9a?=
 =?utf-8?B?ZUlGWU1wTVh5U0dEbHN5QWxETTRhRUhjYStNUzVySDZRTmRiOUlHeUE4d3BH?=
 =?utf-8?B?WWlKbE9RcEZSY3RKL3k5c3RJWDVIaXBmOW5kTVRSb082QTNGWHErYzJRWmRT?=
 =?utf-8?B?TDhlN2JLenFRV2tESzh3aTFIR1o4TXdJSm85aUJSczQ0RVZ1dmQwbENkckNp?=
 =?utf-8?B?cGJmN3NQQjRPT2lnYUNCcUY4SEpVUTIva000RldjTjR0TlNWUU9rWjZDOEdN?=
 =?utf-8?B?Wm5qZDFIOWhHbHQrT1kvckNVK1pHRndlSndYM002cmx3YUlYQzVaV1J4enVV?=
 =?utf-8?B?NUtJWnRmNXEwNnUydW14dno5MHBvVnpLQ25lcldhT3pPRmxEOW1lcnFmUFVp?=
 =?utf-8?B?TTFvUnN5UTBYYW14ZEhmSWt5UkEvK1BKYlRkZFkwUTlSZlNWdFU0anVTbmVy?=
 =?utf-8?B?bDRKVmdYcUYyVHllekd6SzVTa3VsMzdGamZSQUFkNk5ZWEIyNG1ZMjQvZUpW?=
 =?utf-8?B?SSs2akVnTkZaR2xxZkhaVE1KaGRYUzA2R0tCWndQNzUzQnF6TDJTbmJ5OUg0?=
 =?utf-8?B?alhhNURXSXdpT1YyWTZvbDhCeVZPeG41MG9MVDlWY3BiTXhVbVZkemFHN2VW?=
 =?utf-8?B?RTU2ZzJXeTF5WHRja2RxVGhtbUhYaHVra1JiQ1RQaWVTQmE5R3FuYVhOYjJL?=
 =?utf-8?B?ZjErbEh1aFpsUVI1RmVmeS9jMVFTL2pRemRleG5nTk1XYW9ST2VodEZZOUVh?=
 =?utf-8?B?cnk5bWxLYVVSNjMwYXpoYmNUa3BzbUlXVnJuUkt1OHR0QXczWnpEbXVTWVM3?=
 =?utf-8?B?dldpNGNscWUyN3luejlRSG4yY3hzU2J0ZWhWdlNZR0VLYUVLdXBTckVzRXVX?=
 =?utf-8?B?cCtEMDE5ODR0OGh1RU11a0xubTZ2REMxMzZHZmdEbXpPd0h6ZG5wQlRnRXcr?=
 =?utf-8?B?MWVKejhxTDU2UkFPTHl1dnVNcFpaT2gxclpRRFdGNjc3YkcxemhTN1hqM2hK?=
 =?utf-8?B?ZVhsN3BkdExjaVR1OWZGYXBjWmtuSVFVYjRMNGZBMW8zTURzbVl4aTZxMUVI?=
 =?utf-8?B?RFBBenFDak11MUNYSWhVRzcxQmFOaVNhU3FLeUd1OWRJUWRWM1JaVWxYVGh2?=
 =?utf-8?B?QXZGT0J5ckNpTXYvTWk3NVphbkY5bkhZRThQbDY1WTJCS3l3WFZDNWNOY3No?=
 =?utf-8?B?SURXYUR0QjQyNE8zWlR2eHdCemQ1Wjg0dTdyUzdvOHNGcTdteEhKS0lTWXhv?=
 =?utf-8?B?QWFuKzJNcEo5KzdXaTQvYVFnaUVTcTJwUDE5U00xb1R0Ukh5bDlFNXFjS0Np?=
 =?utf-8?B?TGNHK1NvUjA2WlVmQkRUZkRhRlg2SnZmV2JlK3AvcjJWeUxrZmdEUldPZCth?=
 =?utf-8?B?WVpBL01tLzBVeFkrK0xIbUZaQ1ovd1M2czRiUzRpYWx1UDZIV3JLM0Y0b0tX?=
 =?utf-8?B?ZURBRVpJazRPNlhxRlpZYllMbFRRSVNDVVZnUll0Y0VjalNhKzlwOTNzblQ4?=
 =?utf-8?B?a1ZiSHhZejN4SzFXUGYzSGNBUW5LOUpCYjVjRk0zOGF4SUsvT2MyTWx6elBq?=
 =?utf-8?B?UlM5L2ZvdkxQc0VmbzBDbU9najVicjI0UXlLa0pqUjRtRS8zTlV0ODdYeWxq?=
 =?utf-8?B?YVNkVjZYS0VpZEgzVzFwZzNzUmhYNFZJNUJzWHpFbFdYdlFNQWVRTzJDTDB3?=
 =?utf-8?B?aU10ZkVSZHdVdk0ySEtjVkJUWEdORWVPVXBUVXFLSXlDd1JydXdMY2JMVkxQ?=
 =?utf-8?B?OEM1MTkrdGc3R3NHN2xPaDFPTzhhWmhhM2lldFBQV2ZabjBTekRYTVAveUxP?=
 =?utf-8?B?QWoyVDUrUVo2QVBVbUptK3ZZMkRCRjl4cFg5bXBiM1A1N2cyaVFOM2hNZU5S?=
 =?utf-8?B?dFBHeFdYNmt6bk5DOEkzdHMrREZENFA0NlFsWGh4QWJhUnZ2ZHQyRTFmc3N1?=
 =?utf-8?Q?sUI0BQuWOpsxrjNtaXupFtgCM?=
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
	sPMX18NLR6AUB1woq3VJdvN0PfLJx8eSY5Qq9CMRUB4k7H0bgAqxGCNs0q/jhYzkzbMGY3ngbD3Nk2LDFVgAvpYisI95YpPP9852L2SfRwb6B8+HQh1rlglnBfES6PCR7FuT8rajAXlklusKqFIZgQA9vONQtM7ij5qlQGf+JOl95vlbBqJGvsKOS7zq3KK0Z+BJYEg7F1SidQdTtFXKp2mGNxi1m7Hns89CcfcjGAA6S+FSZhctoeXouDyhOLZafOGlcYdlV5aNuwyVGN2AIp1X1SALVaUucezvQLPHwIL7gQn4B3HLrDFrR8XY+EefU/C2bN+0F+o9Btp8V/W1MmYZa56sakw/U/XPpKlm8O6rW4aFQreM7UoL4fmRyPIn9/fJJ6irjHbywVEBpUlc02YxUDNqYBHl9xBfhV82TXIeFyJv4ZnYEk3ALU8i2yBuKYndY0bnmh4eRzJ6Tz8g12Va9cxg2MBQZxKrWBtULPEoaNVyVbHCHJ6NHxLxTyJds+gQvxRpX90AoYEqAGwYNz7T0ynMT8yT04yiZz2SERoeG+Bzkb6a87WWL4fBFQvPBRDpcfuS1vWLrt5lu58Ze9LTRbKySBDNeH5K+55CukiSYWlDYbnFTUg0ATtymPKW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cedf445-a526-42ec-8e58-08dcf25f1332
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2024 06:02:13.7585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y5jx5x+FSxwqaRipPt4wMZVIFOawsVZSBNpZpUEi1SmDfn37K/UuwXneV86DdhAS7YJL4wy8sLWwMkd/xdVKeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7109

PiBPbiAxMC8yMS8yNCA1OjAzIEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBJbnRyb2R1Y2Ug
YSBuZXcgaG9zdCByZWdpc3RlciByZWFkL3dyaXRlIGxvY2suICBVc2UgaXQgdG8gcHJvdGVjdA0K
PiA+IGFjY2VzcyB0byB0aGUgdGFzayBtYW5hZ2VtZW50IGRvb3JiZWxsIHJlZ2lzdGVyOiBVVE1S
TERCUi4gIFRoaXMgaXMNCj4gPiBub3QgdGhlIFVUUkxEQlIgd2hpY2ggaXMgYWxyZWFkeSBwcm90
ZWN0ZWQgYnkgaXRzIG93biBvdXRzdGFuZGluZ19sb2NrLg0KPiANCj4gV2h5IGlzIHRoaXMgbmVj
ZXNzYXJ5PyBJIHRoaW5rIGl0IGlzIGFsbG93ZWQgdG8gc3VibWl0IGhvc3QgY29udHJvbGxlciBy
ZWFkcw0KPiBhbmQgd3JpdGVzIHNpbXVsdGFuZW91c2x5IGZyb20gZGlmZmVyZW50IHRocmVhZHMu
IE9ubHkgcmVhZC9tb2RpZnkvd3JpdGVzDQo+IGhhdmUgdG8gYmUgc2VyaWFsaXplZC4NCkRvbmUu
DQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
