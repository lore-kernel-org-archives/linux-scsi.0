Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480241422AB;
	Tue, 29 Oct 2024 21:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730237554; cv=fail; b=NpFxwJCIaflmJFJTzOhEakt6vuS+S7oMe1NE9hxvgE1WdKdHQiRWqpZVqW1MoeWnzcbBH35F1mkSsaeFcWxPLXhM63Zc4pctskLYWs0ava7Nac0c/4Vn1kinJSMEsZ7IUJEdevmA2S3QzxJxaZZgCWoaIiz3P2iOh0HKxVI3/Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730237554; c=relaxed/simple;
	bh=xnVam58H2rT8vX0+JDnBhCheKiJg/0EwcuIYvUx7CD0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YOZs18mC2P5oy4jz8r+D1LlLf4iJBGDEIlT5V4rdJ/a+nJjMw0u8N03va5NiSS1nlVTuhdAnimtf3cj57hvPtdfUVw0TUpCETG2+jFyhctAc9HmQH8ng9hIrHKbcQV4ke2wxxi3jsm+i8GeRzhMt0QjMojAt+duZH+waAw6B7tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mW/cb76R; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=f92UWUgx; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mW/cb76R";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f92UWUgx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730237552; x=1761773552;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xnVam58H2rT8vX0+JDnBhCheKiJg/0EwcuIYvUx7CD0=;
  b=mW/cb76RLX1QKbm+qSrDJL9L0oVZcKFnPuObnxH2felqvAZrdXfTQxZ6
   hvTnTrAk1aunvACjmSSG6o1/P+CkZdO1csgd75fsBWxB1rY3JHVAmwn5N
   LiKHzfeP3IqMN1dHzo7Xzydq6fu/QAETAmabt9xglQYxdK5fqHBzZOM6k
   uBAVPGjdqRBv5A0uEFesaV1LR+iHK/z9P1ViRFzlybs0NlTqWLrGEXr0J
   hLVTYLpQeeCNUQ20wolRNBkNwIYl22C5smGouqUZHI2tY4ScRCVpTDCKM
   WWPS6U83LlXvkU+ZDURf6kv2VtnocBfzJEmG4EP0PzX2fLXRpjKMjG3HP
   A==;
X-CSE-ConnectionGUID: HCKTh85hTW+9rM83+HBQ8w==
X-CSE-MsgGUID: 3hpBjZiIQLOa/7nplOQIFg==
X-IronPort-AV: E=Sophos;i="6.11,243,1725292800"; 
   d="scan'208";a="30160497"
Received: from mail-northcentralusazlp17013058.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.58])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2024 05:32:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nz+6ZXlMwtQpn9g7cWbxo7aSCHW3spOJrS+a3j8UylF62Y+V6soMrrdl9cgxuKZCLl0NbGfq9YKSAl33cNhdWtWkn2oOVHNk7KbFkChy6QaCMgIP6RzLxdpn2Hr2rhhlliOpjJLSepl5v6pTvyyJGuLEsgWX7nuqFmimqNTHKOCVwJtFb4knJMnJzht9R/mWXHeFFVZZeqD4msDrB/YSW7HidH8DMgUKtmPXsDRL5jvFEfM63//RJQVswx8xNw0pHyvWVNcrVgob07rffLREJO/zpT8w0EuzPwhhG4hG1ReNRQa5TXvr3apn4+oWIoLpvqbQarEcbwKI68ZbDF3STg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnVam58H2rT8vX0+JDnBhCheKiJg/0EwcuIYvUx7CD0=;
 b=w1z8yw6pu9hALcSVNCeL37hmQvIxlCiOJGredO/7SXqtt8ZmzS95EMXr+GOCg4e8ibLF078gqMaiNWieJOQ2MOz3ljv+CUyqYXs/8yKkrLYIzeCb+wt/Wa+qJPtqdwtENhZ+yE/3ch8gVukn+w2Bp1a/uGkcI8PBA/h4bSMhUeL4WJvpy4qH4dsnX6KFsZIgaNUSVgKmKqDLjPCXDcbZhhwR/JE8LRvvfAnGtOtA3p2UvfOucfSe0Q05fwuntCDH5njmq43zGsUZvUWc+si05lobiy77ibacXt9f0igtjBzaKhfoMwuNYHVs1352uitY0KI0A4Z7074xbdIAYI6tHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnVam58H2rT8vX0+JDnBhCheKiJg/0EwcuIYvUx7CD0=;
 b=f92UWUgxsSVrk0lsPrKbLK+7lXitx5Cr5QHEVWy+b4kL4dzIV0tFHpe9RT6z1Xz9vGGKFbrRLyJm69/wwFJ6eYYUXzAfqoImfCo354jgW0glTvBt7qDSux7xmxUuieEp/hOaHGGZbGalIi4EKy6pU2wfObEbbkD4dgbGXxsWjxw=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by SA2PR04MB7707.namprd04.prod.outlook.com (2603:10b6:806:143::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Tue, 29 Oct
 2024 21:32:29 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 21:32:26 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating
 lock
Thread-Index: AQHbKe3M/6h00Nm5DUau61FIkVY2VrKeCAMAgAAGuyCAAAyIAIAAJNcA
Date: Tue, 29 Oct 2024 21:32:26 +0000
Message-ID:
 <BL0PR04MB65642D234FCC0B70A879F49BFC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241029102938.685835-1-avri.altman@wdc.com>
 <20241029102938.685835-2-avri.altman@wdc.com>
 <611fc99e-c947-463a-82e1-9d2a68d67aa4@acm.org>
 <BL0PR04MB6564D3BBB11D00067485F5CBFC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
 <31df356f-9160-43e3-b1b9-bba43da5f0f2@acm.org>
In-Reply-To: <31df356f-9160-43e3-b1b9-bba43da5f0f2@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|SA2PR04MB7707:EE_
x-ms-office365-filtering-correlation-id: f3e8d825-925e-4a7b-0904-08dcf8612f3d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MFJ6ZzdYSjB3cnRyL24zeXI3Smtac0FWWTdBdlFiNE9peDVzMWVneWZBeE9i?=
 =?utf-8?B?ODNCbVpVbzZZdFVFZTNxa3hTT0gvbHNZUVJvWWh3TjlUcUszZmVyUldITWhw?=
 =?utf-8?B?V0tzR0dRS05RdFptSjEwUTJRbGc5dDNXS0o5R0g0ZklxNmFmaGFDZ1djVUNa?=
 =?utf-8?B?OXpYN3BMWUphT2NBQURTZmF1TGJ0aUtDT1VzOEpEYmlzUkZkN2gxRUV1T2pD?=
 =?utf-8?B?RnBRS1lmTzEzMkdwell5RFp6R1g5NHY0bndqOHE4NzhzYjhocWo2U3owQzZM?=
 =?utf-8?B?b25CeDZMQXRNVzJ4Zkk3NHlVNlEreVVDbGZnTnpmd2VqYUNPbFN1WXF6ZGhs?=
 =?utf-8?B?d01Da3lMWStqeFY2M2w1ODRNWWtYc294MHhNbEMvUHlyenBxUDZRY3E3YU85?=
 =?utf-8?B?ZEhhR3hmazNsQVF3dlcwNlh5b1B2djRqOHV4ZmVTa0FBQkNTOTFWaWlTRWVL?=
 =?utf-8?B?NW1oRSt6ZGFxeWsyRkk3c3lKaW4wdmJyQjI4TzBVR0FFcHFtNHZ5WEN6SzVy?=
 =?utf-8?B?QWxZdkk0RXYyRzYrMDJxYzhEZ2t2b3V5UkxERVB3WlM1VnVzNjdtR3kzaFBV?=
 =?utf-8?B?RkZDazhEQzd1d0VVd1MvVjUrMzFjWGFNTXBzZGJ6eVl2Z0pMZVZVNzI3T2lO?=
 =?utf-8?B?MXdLaHBKdkhlZ1ZiYm5lQlZ2RkMyZXd2Y2txYWpOYzNUSkFPdkM2Mk56dWlk?=
 =?utf-8?B?ZDJnZFF2UnhIemRocU8vS2hiR2tmREJuTFJLb2x2ejRWYU5QdHBSMmZad2JD?=
 =?utf-8?B?cVZoRGkwQ3ZsYldLVG9qWkVuT0ZsK2Q3QW45bzUrMldxanZhazZBa08wRWRM?=
 =?utf-8?B?U0JaWVArR21CdXIwUEdoak9ncWt4UzNWVWorVWhCOTJTMnNlYnNoOERFNVQv?=
 =?utf-8?B?b2VOMnFpcVFnYmVVd2lDek55VDRlaDMwUjJJcWtSZlluMW1vVjhXTUxhUkF5?=
 =?utf-8?B?eGhEWUZYZmVQUWRDNmJWM1NKaXd0QnptdGtZVmdyM1drQ0craTJSQ0pteHVy?=
 =?utf-8?B?YzRkL0cvN2ZUMHhmbDAxZk1jU3kxaDhzMnM0cmZOY1pIcEdiQ1FIUnRxVUM1?=
 =?utf-8?B?TjcyTld5TW43SmJRZ2M4eHlTTEt1V0VYU1BjZnRpQklJNHdCTWhrVkFqZHgy?=
 =?utf-8?B?QlJhY2hrbGVFdVlOb1pCdUhDNGVhaWExdUYraGJZQ1k2S3B3WVUrZ1UzMmxE?=
 =?utf-8?B?M2xDVUtEcDVuTGRhT203YWtqaEFaOUprcEYyYit0aFFJRTNjUlVDSVNhdFc3?=
 =?utf-8?B?c0xIS0syWHdBTk9VZW5IV09QMUtrb1k4TXJ1WTZIUWUyU1JubHB3Wko1YVNY?=
 =?utf-8?B?MXczZFBSLzMyV1l5a0ZETHh4aXVqYmRIdDJERmdHNGxkZThzeHFKaGlaZHNF?=
 =?utf-8?B?UlMvMEpaSUFRMEtKNG4wek1kNGdPMTRueTFzNWszb2V5L1JUbkVNbVJZYTV2?=
 =?utf-8?B?Nmk0OXhETm4wWnUxa096b1BoRzFwU1U2eTlpWkd2NXp1TXMxWFNZSEpocVd3?=
 =?utf-8?B?RlI2T3dPaXhOVSs1Q05qYTY2OWUzQnRzSVc3ZFZuMnpENE5oVWtzNXNHYjlS?=
 =?utf-8?B?Ym5QQVcvSUtxNkw3UjRad3loMS93RXlMdzUrMndYdEJDQ1dhWHRmNkJTaS9Q?=
 =?utf-8?B?NGVrQVZZMWQrb3lIaDdzK1FzbzE0dnMvL0ZNTkkvNzRiNDJIVHNvQTAwc0w4?=
 =?utf-8?B?MXFBazFMZW1jdFp5b2dhRnVHcExKYkJtemNhZ21DZnh3YTR4ZE9XZWdSMlpn?=
 =?utf-8?B?NE1hcVJ5MkJJZkwyVWVCclFpRFd4aElhUm1uK2YzQ1ZHTXZ2OHkvNGtlb1pL?=
 =?utf-8?Q?1zcJKENH6YOEFWdVdkLRCiOdnidpeVV/Ha8pw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QThmRGhkTnE3T0laK0hEd3h4ejlCeUtScmZaR0xFTUYxdFRWMWpSNUZGQzdR?=
 =?utf-8?B?TWdHbTZwRkszU0RYYUdQNVU5UGJOWG50ZmJWcWoxYlhxY0U2SDR0Qjl6V29L?=
 =?utf-8?B?ZC9veUdYSHI5WllUUlJEaDQ4QzBjZXc0Mm9ta3NqQVIzTmUrN0YvNWp0RTBH?=
 =?utf-8?B?WjA0dThvdnVjYTVtYnc5N09UQlY3aHJpczUrUDE3dXRXckhNSCtOeGo1Ymov?=
 =?utf-8?B?NUh5VkczNGFDc09YT0hQSngxOWtaWWVaNzYrM2pSbUdkSDM5R3p1b0xKa21i?=
 =?utf-8?B?cXJSUUZVb05HMnd5S28ySFZZaEY3cm0vR3Z2TDZhU0ZmYlJrZ0tIcUNqU3ZV?=
 =?utf-8?B?WVBmYUpEanhRdkhUZmZVQ2d6SVZjM3Q2bzNKemFuMStuYmZKUUZLak4yeEVo?=
 =?utf-8?B?cUNsWWI4ZHdTME1XR3hsQmZZRUZUc2NnTlpldWJpTS9HVi8yazh1ZVgwMGVU?=
 =?utf-8?B?bWQ3L0QrbzlZRDFrSTZzMnRPQWZXVWpkbzJkT1FkTVkwQmMrTm5Jc1FWN0R4?=
 =?utf-8?B?RmF5Ri93YUpvelpkQUlvTzZxUUkzbkxOTFN6Yi8xRHFXV0ZtcXBiZ1Q4MC83?=
 =?utf-8?B?cXZKVVg3ZVlZYWRNUnJDd0F3S0tXRTZ6dDBQem51WFRQb2p5aFFTNjRsOWk3?=
 =?utf-8?B?eU5xdkJJaGIwYVNLNjdMZEdEVUg4bUgvQjIwZnA0TWl1VzQ4dU90YjRFQk9D?=
 =?utf-8?B?R3Z3SW1lR0dqajZJK2VmQSszc1QvYmVsOTNZZVdWUXpxc3Urb09WbjU4UTRm?=
 =?utf-8?B?djFTbW5oWkUrQUEwZlRiclYzSU5pWk04SkFnQjY4eEJCZWZSSDV1MWhuUlEz?=
 =?utf-8?B?U2tMRlU4ZlhLa2ZVU3YyQkNQZWV5eEZzbFNQc29yQ3JyR09vR2xwYXFNMmhj?=
 =?utf-8?B?WktXbXZqa2M4dldTNlBJNmYySzB6R0JMRzJhNjIweXAxNitlclprMEhPMUlB?=
 =?utf-8?B?NlcvMlY3NStMUVMzUUJBcCt6a3l5TjVmSVBlbE1LbURzSFBIY1dHY2RKWE5E?=
 =?utf-8?B?Y0w0VFk3SGIvNWtackhnZUFHTUNMZU12VGJtT3VQdHBqRFRZUnpRZXlBSUxM?=
 =?utf-8?B?SFFNZklCRTFrZysyNE1lb1JvL2JkU3FFTzBXbjJlSmxJMFV5WEV1YWZvWmZ5?=
 =?utf-8?B?eEFXT29BN1R5cWdQdzN5b29nZytGMVgvcU5HdFV2NDlRamh0WDdWOHFTOTIx?=
 =?utf-8?B?SStuK0tNaS9pQVpSNzd3SWsvT210ZThNVmszbjllMVBiZGsrcW1UUldvNC9P?=
 =?utf-8?B?dE4vWm1YYXRwWngzMkZFa0VaSVkxT1VXZDh2Q1R1TE9KeEtBRkwvQlhUV3kv?=
 =?utf-8?B?TEVlU2RyYXUwYllIT25VWFZ0NzEvNU5HVVYzSjVPY0g4RWpzMGFFWE1OWE9n?=
 =?utf-8?B?eGtna2txeHBvc0RyR2ZVTW5hL0o2K1ZneGluOEYxZ0pDU1A2Z09GdXRpWnU4?=
 =?utf-8?B?M0dQckNmUVYzYy9KNzl0bWl6Vm1hVSt4WmoxQkQwUkM3SmxUNTVOUUREeHBK?=
 =?utf-8?B?OG43Ym1JNXIrMW44VE1WYVhaSWxtOXYwVTdBK09zS3A5TTVHZ0NYekhuODE5?=
 =?utf-8?B?b2JhbEQ5OVdZZWEyNzVJL1A3RDQ0clZGdDZwTEZQNitXQUw2NkZacnZHcDlY?=
 =?utf-8?B?U0ZLMmRZbWhMQkVyR2FnU01DejBYYU5mVnhJUmFxTnBkUkpkUFVqU3VvZE5F?=
 =?utf-8?B?RW02ZzlsQVZjMytoOW1QZ0lXcWgwbit0WWF5KytaSi9FMWViQ01yMXM0SlRM?=
 =?utf-8?B?VWdrVDArZ2NVeDhiU292Rnd3UmwzckgvQ2NpYzlIc3I1Y0ZveVl2Tm9KRGYz?=
 =?utf-8?B?RXkzVEdvTkduUDlsaGdkM1lHSTloZjA2WUtvOEJOei9ZTUVzK1N4eEx0Ny9t?=
 =?utf-8?B?QjUweGlZM29YVnFTTjJnUmNxT2YzbVlkSU1yNU1pYVZsTnVqUjFxOVRQNGt3?=
 =?utf-8?B?blZRNzlHT1ZpVEdsU1BxZld2NUhnT1AvcUNlNVJSVlc3L283RmNMRURMUEt6?=
 =?utf-8?B?MlQzNXV5Y3lQZWtHU0xKMlJPM0hXSWJMYlEwZkRaV0EwTkdZN2hXMHFFRXdM?=
 =?utf-8?B?WXMvem5OVit0dFB0cHMyQURTZ0tPZUtKV2VEOFc4NUx6amRjMUdQZkFDRHNp?=
 =?utf-8?B?TjVPR0hHalpwOGd0YkZudXQxejZqMmxvMXd1Wkg4ck1WS1dOL09mSmM2VVFx?=
 =?utf-8?Q?qnbC1e7GOyZJKOXXIvGe9/FJ500Qfyo6D5lrV5d2P6J3?=
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
	Cikvew6lHgccEhTYAaOfTZUsI/hC8EN/VMDi5EN4VDRPzWD9fV1ge+xBHR1gDu4KIWjz+lCMsqChJ+1wrvSJ56twSM3bAaJd+tWgQoHQFPT+nRLV14q+Y68Su+9FWDruFxlXviPtepgsX6n+gPMlYO7J2DusyqvUVfBKirpO3fpZb8ql4KF+iByCdR6rC3nVHWrzs05UUIwk0YqP0g3q5YYCoNd1y/pc3sc9BEEA2iC06NLg1D10ymC/m/MGnSIt3ZCVbq32wJO0aK6fiszOTXOUiKtybs9XzNiIdIBcinvnj60j0dcmYLm9dFyQq8NlNU5feU1MdD16f3HUeMcMqLbrHP/ooan9PmVUIEG3bcEfuSD2jZL/5HIRDCisDHZjcX8v1PAKktpXxk2xGMaU8n2Aph7q+t1GXdugN5Suk3+fg9+jBohLB/OzyAsJUHvwdz4O/YjJyBDRjrHDnfclqFVOw11m+Xebn/P2iPb7QXqVGF8kJ9VgmpCokjfL00YBj3jJCBIXRLGpLR4OE+rNJpwmVz3pvsbZDieRrrX1vBEFMh9HntCgFyxLXUU0BgcEs/hRjwXdG4D7EJK0FRpRgBqArOjuwAdGCBJrvVFkxUhg8B0hsEX9Y5wuIEQ52c6L
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e8d825-925e-4a7b-0904-08dcf8612f3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 21:32:26.7726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VMhsvU1QxAed9yz5Y5E6n24BwraMtFYKSpWMhMtxeTvSC01JdGecLJJ7aJUhlNGqMyATV42S6mWtW4dBGVmsGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7707

PiBPbiAxMC8yOS8yNCAxMTozOSBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gQnV0IHRoaXMg
aXMgYSBmb3JtYXQgY2hhbmdlIHdoaWxlIG1ha2luZyBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+
IEkgdGhpbmsgaXQncyBjb21tb24gdG8gZml4IGNvZGUgc3R5bGUgaXNzdWVzIGlmIGNvZGUgaGFz
IHRvIGJlIG1vZGlmaWVkIGZvciBvbmUNCj4gcmVhc29uIG9yIGFub3RoZXIsIGluIHRoaXMgY2Fz
ZSB0aGUgaW5kZW50YXRpb24gbGV2ZWw/DQpEb25lLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+
IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
