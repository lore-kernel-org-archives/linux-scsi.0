Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC356FBF;
	Sat, 21 Sep 2024 06:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726900243; cv=fail; b=JoMMgtsC4sbdVbx0Wiszbk+fzIqgKB7WQcEgosJWGBCyP4zTSKu8LTi5czacFE/BnBvm/Cn9GaAn/26pLeUiZrbjbFFnZ2MwsA9WT2m6bHMvT1G0xqy29/726QDoPK6PI2l28/NVEQucY5eZ7xf47kgVhrPmNtRwpVhdnyL/SiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726900243; c=relaxed/simple;
	bh=xoNGSo6X+mQf0L8L+DD5nwOpTicKoxYFyEouwDl6FLw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PxfzzAUlF5RyC1jgX8S1jFfLi6LWZHbPzDl57pnDab0sCTDXcUJPhEPMxpmXu+O3m7UUZtoEBtLHsmlUamg4lwzWaF4OuLFp6l1C0X8yb00HsYYvKuRjihjhXoiTTSHV/il0WhdiyPqwvcLfZQmOjjpIbe0oSPl1A26JEIKftKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OQfwz73h; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=0LeK8Z/d; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OQfwz73h";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="0LeK8Z/d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726900240; x=1758436240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xoNGSo6X+mQf0L8L+DD5nwOpTicKoxYFyEouwDl6FLw=;
  b=OQfwz73hVCcGixWgMsSNGKInmvPWyPfG4v8TEinBpNoNYsM+k5MQR/WI
   y9fDSu//rsycZJ4abeLwa8qRziyQfrCKRPNwH3Ys80Lw9twcV8lGX5Pbo
   5of09cs3OrMX9sr6ZzL52umtEb/wG7b2Cf4c3fbjAph9jXVbgPDkaONDe
   b70SpgJ1qXZomWG41U3xd0+SZQfz8td6NItoS3Bbnz3eB0lVK59mCEuRa
   CGmGiMYeQxgFhfEIR9W4OOrLwSRrY2YsGhl2SamVHGdsV4Z/TkIjojUNu
   Ubb9c1w7OMg4zIJmRdcMF6MD1SRPlaDZyC8gpWvVXBP3L+duRXnrrNC6y
   A==;
X-CSE-ConnectionGUID: BYcacIGFTmW31dVtIfibjQ==
X-CSE-MsgGUID: y2mc/Yc8RtyJ7A2MDrUZGg==
X-IronPort-AV: E=Sophos;i="6.10,246,1719849600"; 
   d="scan'208";a="28072322"
Received: from mail-centralusazlp17010000.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.0])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2024 14:30:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=paJSfS3s/s/NjnOLIn3S7iahzcQm5ZCUBkTthLZw+0uJXO2D3goysy3VgyT/BbKA4A0s2L3PY8cDfH+Q1BRkQNiKDHLMTwCE9pOWMmkdPR5mshnG1vABw6VpTPTbGC7B69m32TA0U0LAP9zMJ7dyAtwaWJgniBNmrPmLIPZONyY2qiAoVciESBGnCpz3+uCD7751+3rKyuWGXAGS6btIVskh6OOyNsV+kywsJZxDmmO3V0g+cEW5I078Yk3jc59n3qZkGzXCfeBAgwBItxBToQS61g97DAT5jePQg/3apQ8lHswtZE8mQKR5KygN35xKzTFU9vGQ3pzD+ztmyFwp9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xoNGSo6X+mQf0L8L+DD5nwOpTicKoxYFyEouwDl6FLw=;
 b=LaH+kzeTImmqPyOacc2YM7pBjQA9FRw/Z3/PVzc9sTX4MV6Sb0xca0/Ww5vMg0s2JE4C9G0C7eV3/t6jvYNy5cAXQqSC+2KgtlwVVhrMflmaicfOwEQZAIRvVMkf1DAB+mRc/Ymm6eoJNQaOnB8vdMLMZGz+UZmsrxGQdKfHQHce6UJvT+Z1Zr4mX+Yo4gmC7EmrdgYkDOXvYbrA9GAheTrPXvBbdP3pfMRszgduODCk/OOOUxNjzkKyok+EfvQD2yZP3OEIqW9NzdJk79bBlxCbxNTPfsd2iOo5ta92k8BU4mKIpRMdhEu5maO6oFItjGvZIoFYjtCaOOnuR/A1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xoNGSo6X+mQf0L8L+DD5nwOpTicKoxYFyEouwDl6FLw=;
 b=0LeK8Z/dSjXFdgJ+52a3dQMJYT2ZOHZ2ms4QWdSFiACCJZy5MEfIZnFxKub4d+vDxaG9HPJKeB8HmjVtRRjLSpVmHSkqpU+w7SlEjSe+ae+hwUz6f4uFvhxfsujuj7HvFkRuhr0l4PtN3/nxvKJ3mAvKbCESnl1p/6Mm/KvXax8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 LV8PR04MB9244.namprd04.prod.outlook.com (2603:10b6:408:25b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.24; Sat, 21 Sep 2024 06:30:31 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7982.022; Sat, 21 Sep 2024
 06:30:31 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, Daejun Park <daejun7.park@samsung.com>
Subject: RE: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
Thread-Topic: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
Thread-Index: AQHbAzySHjbFr5s36kG7QyddcK5yL7JcVmaAgAWCLjA=
Date: Sat, 21 Sep 2024 06:30:31 +0000
Message-ID:
 <DM6PR04MB657594C85E06F458EEEDB7C0FC6D2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240910044543.3812642-1-avri.altman@wdc.com>
 <5c15b6c8-b47b-40fc-ba05-e71ef6681ad2@acm.org>
In-Reply-To: <5c15b6c8-b47b-40fc-ba05-e71ef6681ad2@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|LV8PR04MB9244:EE_
x-ms-office365-filtering-correlation-id: 7028b9d3-20ab-477a-19b3-08dcda06e42e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?N29JNXE0SExnQnpKYWVtcUplTmJYU3I5a1NlTE1YWU5YY2kvUnRvcnM3Z3JZ?=
 =?utf-8?B?bUpBQTNzeVZZaXEyQW5vdElzVjVHdGpNTFBIc3o5R2EwTGNVa3U0ZHVFdTJt?=
 =?utf-8?B?TXRqNHFSN0tNdFpkNzMzOWV5WDZpK1ZKbUFCWnhYeW8rcjkxMHU3TzFvWnAv?=
 =?utf-8?B?clF0RWlpOTFRQzgydm1UaHBScXdieStuN3BEcnBrMFVxZnlaYmNrV3p4alNa?=
 =?utf-8?B?TXVGd3FDNCtFZktJMmhsc3Zwb2xTQWovRUl4U29hVm9lTm5xRElOYUY3OTJS?=
 =?utf-8?B?RUdWM2FmRGN3dzJESTBhcG9KbFNKbEZNYzhOTXpOaC9zTjhwVXl4WDZwdElB?=
 =?utf-8?B?ZnNrelJmUEJZL2VVemJtcjI3R3pNc3FSVGRQNlFrekxaK1BPNXFKTHdoSE43?=
 =?utf-8?B?NGZtVGxIWEJ4RzF1b1BHM0dHZ0MwajRNczE5SDRUbldJQ3pPQi9NTEZ3RENZ?=
 =?utf-8?B?R1VtZC9VNGtnN1phZXFNbTJEVjZ6V2lYZ1FoWXV4dXh6WU1pUVZ5WklybzF1?=
 =?utf-8?B?aElGdXFxYnZGK0FXUWdYQlA3c3lXazMwS3dqbjIva1FhVGVydlAzVGIxY0E2?=
 =?utf-8?B?NHVLRm5hT1VLUXRGVHNKM2tKZ2xOQkJ0YWtXME1BdnQ0aTNqVGRtVHl4eGsv?=
 =?utf-8?B?bVpuajJ6bzZGdzVtSmREbWJpZEJ2MDlWOFFrSHZra1VxVkN0RGxVUU4rb1g1?=
 =?utf-8?B?dUx0OHJxL1dJREZYNFI0UFkyclg2SkQwUEJIVXNOcjhuQzFaNi9RK0U4M3Ja?=
 =?utf-8?B?UTdKTmRGbmVzQmcrcWxyRWk4ZFU1RU8wR0t5bGhZUXg4SmhWTzhjVWs0RDRT?=
 =?utf-8?B?dk5zWFdDdXM3RS9IU285bDR3a1A5dU1acG1ZM0ZrVzFuWW1IQUVlajR5T0tr?=
 =?utf-8?B?RnBONm1wbUlndXk0UXhaM0ZlVGNoVCt5ZlNMb1RoQjQ1eTJucFFzWGh2bDNp?=
 =?utf-8?B?akVQZ0g2MC9keVIzK09yb0NHbFRDUW92ajBya3ZFWjFHd0hMTlRwOGlMYkd5?=
 =?utf-8?B?WGl5VEZKa1lZSStoSjlGb0Z4ZWZ2RWpFYW5hVnJpTTJJZ0E0TEE4dDBHNzZX?=
 =?utf-8?B?Wkl1TldOMFQ0eGVleEpiRktib290R0NGKzNFVlk1OVlBYTFyMXhidksyano3?=
 =?utf-8?B?blQ3UFArMjJKV0I5RU00UzB3YWNtNVdKNjdtZ2ZEbVZWQzdMSmFJN2R3YlZy?=
 =?utf-8?B?SnpVdnZ6ZS9JRkFDUzBPdzQ2MFJObGczSGl4VldUQlZvaGRSN1QxV1pNUDFx?=
 =?utf-8?B?RnhsblMydW4wNXA4eFpVendKUjVxWTBlaHh6dW15N0lXbHFSSFpzQ3hqcSth?=
 =?utf-8?B?NjVtaXU4bDJPc1l6d0pGYlI2V3FxcS9za3lzc1UvcG5xeFlEaTRQb24vRXZ6?=
 =?utf-8?B?aDI3TVpkTDlNSEQrKzBMeDZPUWxYbWd3bFcrd0RNODR0L0pzRzRoRGFqOU5t?=
 =?utf-8?B?U3NmWWFLSk9IaHJldTl1elc5UU1jK290b2xMTmJuZUZtOUV4VXdsN1FQQmt0?=
 =?utf-8?B?NTJyMFo5anNDZE44U2JrMWZWeTJKcThRcEY5UUNHcEozdC95UWpGeWp5NExq?=
 =?utf-8?B?WTFhRnFaS255Ukp0ZW90ZGZwdU1hQVBRMHh5TE5CWUs4RHRjeVkyOG9OcEZo?=
 =?utf-8?B?Q05JV1kzUEtKRmJ0L0hQR1V6bit0eUQ1K0gwRU8vamIydS8xc2FmZkYra0RP?=
 =?utf-8?B?azAwSmVSaFFlZGZ4elZ2ZEFodWRvYzJtUzFicHo4aHhIdWUwc3d2Yzh4Nkhh?=
 =?utf-8?B?cTdkVXRTU2NKS2RYbCsvNVczclBNQnJHS1hUcGNwbHpFTGxxaTc3MTB6eGh6?=
 =?utf-8?B?c1M4VGFDR3VsLzh6QkRpOGdsU3kyczZqUFFObXBOa1llQzg3cGhhRUplVm1F?=
 =?utf-8?B?ZlB6ZjZjK0lTODNtSWRWNWFhNVFZU1pSVjl2ZnEwdVFPRkE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ajFIU09nalA4R1pIV0VlYTJSbW1xeDE2dXRhVGVhbExpTzU4NDFjSnpTYXc0?=
 =?utf-8?B?aDdwS1ZpME1KdU9UTDNwUEN3YldDT0R6aHpCN2RKY0hJOGp1K2VuWUllYWFF?=
 =?utf-8?B?Vm01NWk5eE04SVhPbE81VkNIYzFRR0pKNFNTdlA0Q3ZjK2xjTmNZaVNURGdk?=
 =?utf-8?B?UmFXUXJOUnB6b3luY0RZQVVpV0Z3UVRRNlN0V1ZFV3dzZXVDS3ZXdFRSTkta?=
 =?utf-8?B?bUowanVxRGdkLzJMeW9ya0NHbStIRWpvZXdoN2N6TnJWWHJmdXhrOU12emtU?=
 =?utf-8?B?UDdRUUIzUXB6RVlnNERpZSt5MUJXRDZ4NnAzRndIak9hay9UY3kwZ25XZU9Q?=
 =?utf-8?B?R1I2STVsUUh0N0lnTmlsZUxnNUgxTWcwSk16UjB0c2RGbjV2SFB1eHF2THpa?=
 =?utf-8?B?MzM5WHJVM2gvRUdhZTdqckN6cm56UFluQnBYUUt5RGNxeGZnd0ZNTi9mQmVS?=
 =?utf-8?B?QjRCZFl1cFRZN09uSU1xOGlEY2tKY0c5VEhHa1hVQTQvYkpKZjZyc1ordEw1?=
 =?utf-8?B?WmFGTkVHRUNwNHRSNkl4TmkzQmJIMDBhZFFUbXltRDllQ1U2U1BFNGsrTzVX?=
 =?utf-8?B?NC9aZ2NteWdBcVkvMm1nWjcvWHA5K0ZhQVZEbW9KYmthTnAvbm5KSkxBbUZj?=
 =?utf-8?B?bXdZdkV5YzFLRVRCOXlZb2Q4SDZpRkFOWlBBNS96cHEzWDFiWVMza1o2aytY?=
 =?utf-8?B?NEVyT0Q3RU1EQyt5bVZTcUdHRmZMVnZJSytyZXRaL1MrTHhjMFpqbmJjd3Zn?=
 =?utf-8?B?cityeElOc3JMK3crRHJ6ckQzdSt4WEE1WU50Qk1VbThwUFkxZjZFTHdlU2xj?=
 =?utf-8?B?cXpXbHlmRmN1eUxZMXNTM0NqZXJncUROeGtZaWNja004L2J3Q1Q5ZXhwQXRp?=
 =?utf-8?B?VDBTT0QxL3JySEJ1bnFlSEQrcTRXTmtMSzA4clN1bmM3VlZ5ODlrNjk4Zjh4?=
 =?utf-8?B?Q1VQdndhN0xndUVVTGdGbmROQXFLUVppbC9aWVFUdXdKeldxWDJFVTV3U3h6?=
 =?utf-8?B?MUM0azJCdTRkM3Q2NUJYNG9hY0dWa3grTnJZWTRUSGtyeldiZDJqSDZMditZ?=
 =?utf-8?B?UGU4MkMzamMwQ0FHVzQ2aTdTWUNGcUN3NCsrUVd6ejBmY3AvMk5DZXdmMUJv?=
 =?utf-8?B?ZGMzaXJyWG96ZThmdkRKR1dTM1puSXlrNTZKWG1hdm5IQXBMS2FteE8vTUto?=
 =?utf-8?B?ODJBR3h4QVF1a2RZQmZmUXJaQkt5OXhCMVRCdVhNZHNCaVg2dnp3NzNmam93?=
 =?utf-8?B?MFNRWEhBcFhYOTFzU0REdkU3MXJhMnhpK3hzMjZ0dE5PVE45V1V4UUhpYTZF?=
 =?utf-8?B?clk2bHg3Z3llQ1NKZDdQK1lWVXgxVW5Id05iYjE0cWRHbjZHWHEySDBWdzFs?=
 =?utf-8?B?c2xBVkpQbG5HWkJDOGhGSWw3cjIyQXZjM2xOMlo2WElJbW9pT1JGVUFWUnFE?=
 =?utf-8?B?MGxjVTFOVkx4RXpNeFNOSzllTWo0UWdML2dpVW0wTktneU1obm02cHRxZjg2?=
 =?utf-8?B?aXBkTGlDZDdUWXFBR3RxQmRHdXo5aHBpdFlUQjhDQnJXSmFMZ0dGN3pNcjlX?=
 =?utf-8?B?VUZjYzB4VERzRit3MG9VeU8vWk9xcXpYWlJCc0I1dlRqUzJiMi8xdkhDaEdp?=
 =?utf-8?B?Wi81YjRQdGJHM2tMdndYZkNJM0dvcklaWkd6cENwQWQwM1EveEE1WU9mcVNj?=
 =?utf-8?B?UlZXd3MvcHJaVlZsQ0VJYndCdTErUUxrVFY5ckFjbE9hTktvclh2R1ZsVUxp?=
 =?utf-8?B?clBLZFVwdVh0UXQxWUVZK283TzlVS1Rnd2xIWkdidGliR1d3RHlhamMyUHEr?=
 =?utf-8?B?ZnBLSXpTUG05VmM5d0hPcUovNE53T1YyV2Fjak9jY2FZcEJQVFFQZTVFU0xs?=
 =?utf-8?B?OTg2RWVQYWdocHN1YlVvb2t6aHI2b1gxNkVsYnFlNW85TSs1ZVRGNGV2TnIr?=
 =?utf-8?B?a1ozZGFYNm9FdlpFa0Z6OEg2K1p1MGYvVVhzeTJlb3I5a0dFSWhoaVprcFdC?=
 =?utf-8?B?Qm9CeE1pOFJmYmNUaHNvQzUvWEtiWmFTNlFhZU5YWWNrTG5XaUwwYUd3bmZj?=
 =?utf-8?B?T1pZYTI4VkZnS1NWbkV1d2JkS1ZQa0JGN2pxak12TVoyQUJJSVNaVDltZTZX?=
 =?utf-8?B?Ri84VDRXd3pTL2thMkdMdEkyVlByd2tYcThJVnNHRDlKYUxGdzhWZHk5RFU3?=
 =?utf-8?Q?mQ5ymucvyJYX8I0h2wv7Go3u6DCpDgUqajxcYr7WEAML?=
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
	nRKAedAxkpcqgi7PjN8L9n6IRKdSadW6j8FRKs7DjuUQXMdHH0YV8T8XoO7jFB3UuvXf65T5lA+soxqfmnsCosRLVgtupJx2HYyH6BX9hynMNiL+4KYJSHpjyUljne2xv44pbfB9yZ6+B4fDjJgC6k+QRPTX6tT8kymN3aiwSxzEFJc5BEoNcnyCLXqWWzbnNwE7tq2wq5RaEe1M4YLmyEAOHXmxMiHapwqWby0je8djL3dEaFHfCz9eI0+wNsXrsDHnyxuJsenH57SChKgjbYZyLXGmktbksfNsCUZuApffqeByywiMdHGaA7bsmxT3vwj2en5CNXRXtJ/0LGh5MK8iSgDUiHd18zPRdJfGye757YW2X5TArs8GPqbB/5+zGdDXW79XgUxgP3crLVkrGnGlIMWF3PraR+oxOasxLzymu6wvdmtuIdSR9lj3aMQARHlKLn2O0MvviiU/WeeijBzL869/toVIYmpMdpIMTCbf6m/lNCOtIca+qcwcqsw0XR47l5CLNZQp0dW3ag4dZJbND/uEr23W563Xq2s86iglZHdTHCzggGvpKZdWBTuVdICeVmXk18dr1I7xftiNMUrAcS5MpN90UbUfROTh7kMaNeW0ObCVkXmVyIanW6yR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7028b9d3-20ab-477a-19b3-08dcda06e42e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2024 06:30:31.2500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qmoQLA6qVncOf57paPuVNs1TOUC/ujMsB+L+bNul5Y+rEFc/9faNuo2CxMCwr6wnnB+iGRFXsmMweDNlroTSHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9244

K0RhZWp1bg0KDQpUaGFua3MsDQpBdnJpIA0KPiBPbiA5LzkvMjQgOTo0NSBQTSwgQXZyaSBBbHRt
YW4gd3JvdGU6DQo+ID4gUmVwbGFjZSBtYW51YWwgb2Zmc2V0IGNhbGN1bGF0aW9ucyBmb3IgcmVz
cG9uc2VfdXBpdSBhbmQgcHJkX3RhYmxlIGluDQo+ID4gdWZzaGNkX2luaXRfbHJiKCkgd2l0aCBw
cmUtY2FsY3VsYXRlZCBvZmZzZXRzIGFscmVhZHkgc3RvcmVkIGluIHRoZQ0KPiA+IHV0cF90cmFu
c2Zlcl9yZXFfZGVzYyBzdHJ1Y3R1cmUuIFRoZSBwcmUtY2FsY3VsYXRlZCBvZmZzZXRzIGFyZSBz
ZXQNCj4gPiBkaWZmZXJlbnRseSBpbiB1ZnNoY2RfaG9zdF9tZW1vcnlfY29uZmlndXJlKCkgYmFz
ZWQgb24gdGhlDQo+ID4gVUZTSENEX1FVSVJLX1BSRFRfQllURV9HUkFOIHF1aXJrLCBlbnN1cmlu
ZyBjb3JyZWN0IGFsaWdubWVudCBhbmQNCj4gPiBhY2Nlc3MuDQo+ID4NCj4gPiBGaXhlczogMjZm
OTY4ZDdkZTgyICgic2NzaTogdWZzOiBJbnRyb2R1Y2UNCj4gVUZTSENEX1FVSVJLX1BSRFRfQllU
RV9HUkFODQo+ID4gcXVpcmsiKQ0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4g
U2lnbmVkLW9mZi1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo+ID4NCj4g
PiAtLS0NCj4gPiBDaGFuZ2VzIGluIHYyOg0KPiA+ICAgLSBhZGQgRml4ZXM6IGFuZCBDYzogc3Rh
YmxlIHRhZ3MNCj4gPiAgIC0gZml4IGtlcm5lbCB0ZXN0IHJvYm90IHdhcm5pbmcgYWJvdXQgdHlw
ZSBtaXNtYXRjaCBieSB1c2luZw0KPiA+IGxlMTZfdG9fY3B1DQo+ID4gLS0tDQo+ID4gICBkcml2
ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwgNSArKy0tLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IGlu
ZGV4IDhlYTVhODI1MDNhOS4uODUyNTFjMTc2ZWY3IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+
ID4gQEAgLTI5MTksOSArMjkxOSw4IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9pbml0X2xyYihzdHJ1
Y3QgdWZzX2hiYSAqaGJhLA0KPiBzdHJ1Y3QgdWZzaGNkX2xyYiAqbHJiLCBpbnQgaSkNCj4gPiAg
ICAgICBzdHJ1Y3QgdXRwX3RyYW5zZmVyX3JlcV9kZXNjICp1dHJkbHAgPSBoYmEtPnV0cmRsX2Jh
c2VfYWRkcjsNCj4gPiAgICAgICBkbWFfYWRkcl90IGNtZF9kZXNjX2VsZW1lbnRfYWRkciA9IGhi
YS0+dWNkbF9kbWFfYWRkciArDQo+ID4gICAgICAgICAgICAgICBpICogdWZzaGNkX2dldF91Y2Rf
c2l6ZShoYmEpOw0KPiA+IC0gICAgIHUxNiByZXNwb25zZV9vZmZzZXQgPSBvZmZzZXRvZihzdHJ1
Y3QgdXRwX3RyYW5zZmVyX2NtZF9kZXNjLA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICByZXNwb25zZV91cGl1KTsNCj4gPiAtICAgICB1MTYgcHJkdF9vZmZzZXQgPSBv
ZmZzZXRvZihzdHJ1Y3QgdXRwX3RyYW5zZmVyX2NtZF9kZXNjLCBwcmRfdGFibGUpOw0KPiA+ICsg
ICAgIHUxNiByZXNwb25zZV9vZmZzZXQgPSBsZTE2X3RvX2NwdSh1dHJkbHBbaV0ucmVzcG9uc2Vf
dXBpdV9vZmZzZXQpOw0KPiA+ICsgICAgIHUxNiBwcmR0X29mZnNldCA9IGxlMTZfdG9fY3B1KHV0
cmRscFtpXS5wcmRfdGFibGVfb2Zmc2V0KTsNCj4gPg0KPiA+ICAgICAgIGxyYi0+dXRyX2Rlc2Ny
aXB0b3JfcHRyID0gdXRyZGxwICsgaTsNCj4gPiAgICAgICBscmItPnV0cmRfZG1hX2FkZHIgPSBo
YmEtPnV0cmRsX2RtYV9hZGRyICsNCj4gDQo+IFBsZWFzZSBhbHdheXMgQ2MgdGhlIGF1dGhvciBv
ZiB0aGUgb3JpZ2luYWwgcGF0Y2ggd2hlbiBwb3N0aW5nIGEgY2FuZGlkYXRlIGZpeC4NCj4gDQo+
IEFsaW0sIHNpbmNlIHRoZSB1cHN0cmVhbSBrZXJuZWwgY29kZSBzZWVtcyB0byB3b3JrIGZpbmUg
d2l0aCBFeHlub3MgVUZTIGhvc3QNCj4gY29udHJvbGxlcnMsIGlzIHRoZSBkZXNjcmlwdGlvbiBv
ZiBVRlNIQ0RfUVVJUktfUFJEVF9CWVRFX0dSQU4gcGVyaGFwcw0KPiB3cm9uZz8gSSdtIHJlZmVy
cmluZyB0byB0aGUgZm9sbG93aW5nIGRlc2NyaXB0aW9uOg0KPiANCj4gICAgICAgICAvKg0KPiAg
ICAgICAgICAqIFRoaXMgcXVpcmsgbmVlZHMgdG8gYmUgZW5hYmxlZCBpZiB0aGUgaG9zdCBjb250
cm9sbGVyIHJlZ2FyZHMNCj4gICAgICAgICAgKiByZXNvbHV0aW9uIG9mIHRoZSB2YWx1ZXMgb2Yg
UFJEVE8gYW5kIFBSRFRMIGluIFVUUkQgYXMgYnl0ZS4NCj4gICAgICAgICAgKi8NCj4gICAgICAg
ICBVRlNIQ0RfUVVJUktfUFJEVF9CWVRFX0dSQU4gICAgICAgICAgICAgICAgICAgICA9IDEgPDwg
OSwNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
