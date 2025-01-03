Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F4318E361;
	Fri,  3 Jan 2025 07:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735890331; cv=fail; b=OI7frD+lz1rR19Fw/pQ3sjjoYZ2duXk0tSIxn76bDHHvmFDtU3KGI7qrGuiAufwmYhTg9lEABLauFuuiTaKu2y5Q1us7c4ze3eipDgfZiCEEYfV2CdEHDQD/wt4uzimP3S6rlGMG8xfaT30ZECLPCujgnx803zKWQoVZ8x/Cnb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735890331; c=relaxed/simple;
	bh=PGKK3oJtNu+hbJQ4MLV0ctrctfY72okn5VXZ0lBAmg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MRbLLjxB68vRubJgNsJqMs8lzOiP3YXybYtox/TUYc3ePcWniBH5Hq6Bi0oZNULYp6RagrYmhijVeaSyoCfn36ZLi0HeDHAT2u8uDrQ6NPO4ONdKtW1NmVaekcPSyXbYaVU50TgbWCDbTz7HIDhdAjeoFqZuyye6I9UflG9ZS4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BLd8rZJR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Aaf1BV4y; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BLd8rZJR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Aaf1BV4y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1735890328; x=1767426328;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PGKK3oJtNu+hbJQ4MLV0ctrctfY72okn5VXZ0lBAmg0=;
  b=BLd8rZJR7Qjcf1PibOdlD4ljlRLmI+lauVvnJYQPzD5soUBRfPzMDYX5
   6nipEaggASW0gQhjjYfQLQvbo+MqT4yfZWiwltyYIjCtdRWtl2aj8NRYt
   FEqA5YAICQsnwyqgTi6VTPl1YFLGN91OXr47dz8WhhTmsBtNSL9+UluND
   64vwOhBOJ1iVfkicWTmfMG9HdYiHZn0TnwapcmzvmroxwK0Xy5OpiJuZE
   8Au5Lpg1+sBu4xbrJvHnmtahOHisbcEEI/uYl4zolG0YM6Hjj/wszDwxs
   jgrGQJzNq/fBGsvyRwEc2LP9vycS/Y/6LsBiPt8x33qCfxgff2fBBOLdm
   g==;
X-CSE-ConnectionGUID: /HubC69DRvuoWhR2dSiJZw==
X-CSE-MsgGUID: jyPpzQr4Ri+hToGXdRUW0g==
X-IronPort-AV: E=Sophos;i="6.12,286,1728921600"; 
   d="scan'208";a="36293025"
Received: from mail-eastus2azlp17010022.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.22])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jan 2025 15:45:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fk3DmP/D1XB/LE6MZ6A3Iyxq9ZvkYtWOPVYy2FQmIlslT8lKT3BHspeqPGcwFJ8aItBvN2MEd0nMWoxbALvsTy81zOqGT7YTSlEOqOtZ0YaB5DT0lz0tik2+7suByB3SKXi/CGxKRbWwyvaZx6kbGexJJIsnNhUKCKhDbCINER2ga4znG8AbLedwKXTB15JqlB8mnaJWtJQJoQ4xgnGNW+R7lFbc2beoVQPcfEuHHMMK5r1ty8ix9Sg8ZfdzoMfZnCVdYGCPRzCFhB8x5QSqnirXQUS2ZQj5nSMV1rC2ai3fGxMlI+aVcvjDZxrCI0hDuR5je2JZAMcaRCzNDQUM4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGKK3oJtNu+hbJQ4MLV0ctrctfY72okn5VXZ0lBAmg0=;
 b=BQy9xdi6LSvV6ZF/wt8KtlcTxHhfUriyGzY6NbHU15097syPV+e0woh9mK+WvghehLzpXDQNMaBcu5R2WiMxLt5kzmSsCw2pvtP72sDmjFsZ8ZmTlopv0c8cXf6WE+PDfYAQZ7m4S2RotiR31gxK2QWV9DMezpAWQiSq1yfwfLelNjG7UNri8fRzluq5st/VrMT23zNg6OzxV/YlSyuRqWWgs7u9Z0QzksO1vEamjqqll4wsXW1OGw+qcOi72QKQJg5+ZnChuuCO+YfDCVJBG71rfH3mgbfTT1S7nivRBRufwPdyiereQxv/8xqOO2/GU+sOJZm0/DKWLr47hxBvwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGKK3oJtNu+hbJQ4MLV0ctrctfY72okn5VXZ0lBAmg0=;
 b=Aaf1BV4ya98nsC+g1kV3XWW2juNADjAm4QjLNxORaoMVrBwId1Wa37ARvIuDImGX76e0TRP4tw46C/Tsk9DM6/iEz65yRT8bk5AM3KVMBnB4I8ah7rF761TW53VRcl1u3X8dcI9HnDDPsX18iYGNrybz0SN8mrM8FBpbmt2CcWM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 IA3PR04MB9303.namprd04.prod.outlook.com (2603:10b6:208:528::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Fri, 3 Jan
 2025 07:45:13 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8314.013; Fri, 3 Jan 2025
 07:45:13 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Can Guo
	<quic_cang@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>
Subject: RE: [PATCH v2] Revert "scsi: ufs: core: Probe for EXT_IID support"
Thread-Topic: [PATCH v2] Revert "scsi: ufs: core: Probe for EXT_IID support"
Thread-Index: AQHbXFM8EMr7OXA7nkaKSB6IrNT03bMEOneAgABwYgA=
Date: Fri, 3 Jan 2025 07:45:13 +0000
Message-ID:
 <DM6PR04MB6575AB56382F9BB641FDECB8FC152@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250101134140.57580-1-avri.altman@wdc.com>
 <c933571d-a87c-44b9-af44-4fd9230cb319@acm.org>
In-Reply-To: <c933571d-a87c-44b9-af44-4fd9230cb319@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|IA3PR04MB9303:EE_
x-ms-office365-filtering-correlation-id: f869ddd7-b0a0-4516-f6d1-08dd2bca8ee8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ekxCTnFKeHhiR2dIUWxybnU3OXYvdzdCQ1ZuNUNvblpMVTZLNUJ1dXJBQ2kw?=
 =?utf-8?B?R1hiMU0zbUM0NEttRDB1YXdkWlZZYVBwOEFMQ3hYZlNnbE9ZbUNZNmtIamc1?=
 =?utf-8?B?YmVJMzVtRnNPNWxHZFRML2dmeFFTTzB0ck9vY1JZMEVwU1hKanc5ZmZteFY1?=
 =?utf-8?B?dXNBZy95NldVV0xKYlppYWh5QWIxT0FCNHB6UFZ1bTdpWlBSZTE3TmhGUHRy?=
 =?utf-8?B?TnZnVVNuNTNiUytPaGtLaVQxUGhXd2xsMEFhanBiSXBGczZsUmNXbklYZW9q?=
 =?utf-8?B?NkN2TnlRRE9PbkcvQVM5Lzk1SmFDcTRNM0daV3hUYzZmVm4vaFZSdHRNN3Vh?=
 =?utf-8?B?dHVpd213UzRrUUhDdFk2QzdWeVY4Z1hLeldlTHdXQ0FJSzQvMDY4RnVhSW8z?=
 =?utf-8?B?NEJBTnJXbVloaGJmRFRzWU85a3NabzlJSHpjbktIT0ZBVFRJQndreS9yTWFp?=
 =?utf-8?B?VWh5YWZxVU52UEpzTkx4bmZ5WnNQUDZUZGkwR2ZvcnFxSC82U1B2UWhJUlND?=
 =?utf-8?B?WXVha2V6b0g0UlN3dUtwUkVweUJabW9qcld4VSs5c1RxSXFzNnI4S2NQbk51?=
 =?utf-8?B?NVBqS1J5cm51YmQ1Smo2TTg4RFp3dkZxL0lQS1lHYzM5blgxcEdPZ21WbkJj?=
 =?utf-8?B?U01pZmFCd01jTFAxVWRzLzJzMk5KQXUyK2lmdXN0cGd1ZGpuaFZPM25uaWlv?=
 =?utf-8?B?dnZ5MGkzNXlFK1hlZXcxTm1aclQ3MnRXb2hXdFR3VW9qMmdpRGZwSm5PeWwz?=
 =?utf-8?B?UFJORHJDMWpyVXlGK3FmVmN6YlNWTGJINU5vTm85S1h3a29xQWoyZkd0a24y?=
 =?utf-8?B?bldRZ2JtT1FFZ0t5UHNjMkZ2ZWJRY2o2U2VkR1BmZzdoMTRxd3NPNXRVVG0r?=
 =?utf-8?B?aUhiZXhpalRWaktUUkw0VTJ3OXM5eHZBUjdESGgxZ0oxSGNEbnl2WlhzaUlR?=
 =?utf-8?B?eVRCWmdMZWNHaDRwZFpuTEM2MmtLQklMMEtUQjVaSk1KZVZCVGlxYTRSOEcy?=
 =?utf-8?B?M04wSEV1WGg5VEttdzRoekVtaTBoZXcrZFJ4ckRDa1h1aFpRTGF2ekFETFBG?=
 =?utf-8?B?Rzhhd2UwMFRwc2s3Y0s4SnlURFgvbUxMRkxIN1pGM1lzbW9VVkpKMVVBRUxt?=
 =?utf-8?B?RjBlVFNHM2NKck9kSWl6N0QzYjh1akM3OTNIUEVQZUFVWnVDbnUvNTh5U0s2?=
 =?utf-8?B?bjZBNEVrMXc4TnBQdThRczJpOVRwSlI0Mjl5eWI0V2hxVHpyS2h2LytudnZj?=
 =?utf-8?B?UGdRNjNRdVdOK3pUYzFvRjZDZ1lYNVFidnRJUThZdS9NbXM2aWprQmZPRGNm?=
 =?utf-8?B?TFFVVUJUUGsxVUlybW54R3VUUm9scGE0ZCtON3NpdU5SdGhSdDc5TlVqMXpL?=
 =?utf-8?B?a3BNNEVlY1B2UlNMWlBWakpkWjRTZVZOc2REVW1YQ21CWWhBS0FOck1YZ2Fq?=
 =?utf-8?B?bkdlakJ5T2dPZXVqZGlvUkVBOUMzaFJyMDdzMGtmY2xHN2IvbTk4V2ZGb2Nh?=
 =?utf-8?B?L0FEdzNXY0pBT05OQ3UrT2VpZEUwQVlXTVVkb05QM2Z1RS91VTFiNUtFM0Rq?=
 =?utf-8?B?eUFtbFQ1QjNmSzJXRkttKzNPSU5ycEpwWkM1eGQvRllHS0hVajVLMytOUDVK?=
 =?utf-8?B?MDhoZzJRNjg2NktTcWxCLy95blpxWE9JWlNZYjAwWHdTdjhIak02MHdVRGRD?=
 =?utf-8?B?NjNjdzUyaVRpUG16UFUyR3BEbnNzTTVwdDVtQ3hCbUlsUzd5SmcxL0VEWHlF?=
 =?utf-8?B?K1BhbVVCRC81Zm9DcTg3QUwzczRLT1V2MFd1bFlESUgrQXVEOVZvNkxWdkN1?=
 =?utf-8?B?eVpxbHVRMWwzWmozSU5HTFdZK1Nic3p5MXJ6cmZwY2hEOURRMkNKWjdJTlVN?=
 =?utf-8?B?M2dhTDExL05MM1AxQ2V3SWovd1BOTFB0Qyt2TXVuMHF1STZKMDFDZVFhRW50?=
 =?utf-8?Q?mUvhu97W+0LHy3JLLLLzKq/zupH2RRD7?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z256L3Vrem8ra0gyYnF1NnVPdHo5WGlJM0diamQvWU5rekJ2RllTL0pjYjZ5?=
 =?utf-8?B?RUwvQ0RXTHFqTUdyQUNCQ3JnOGpjbEEybEZPbEtBdURhbndRWWlPYlFjYzhK?=
 =?utf-8?B?dzV5clM3MEZucUJwSlBsZ0F3QnFVOS85NlhTRHAxNEF0VVMrMTVpM0lWODYr?=
 =?utf-8?B?ZU1vWDR1dXlDTkoyeTFGcWNJOXlXSTNRMVJMWjR4eFNvWTBSUU0zWGRTdURN?=
 =?utf-8?B?YjRTbDYzUkZlV3BTUCt0ZXJ0b21kd1cvV2RsMktJM2lCdnpGY0x6MUx5Y0NW?=
 =?utf-8?B?a25WckljS3c2bCtUZDFsUWlwQVdydzc5VE1HdjB2ejRSU0RuWVFRT2YrRkR0?=
 =?utf-8?B?ZkFQTTZLVVdNMWVCYjZqY0pmczhXakpjOWM0alhiVGxpdVFlZUJOaEYyUFpN?=
 =?utf-8?B?Z1VNbjZaNzZzeGN0YXhLVUFpSDI3dk9pTitXajdSSmxISllOemNIY0lxbG1B?=
 =?utf-8?B?aTlGWWxhV1NCWXpiOXpEMW9xRDFiVVRydTVWbUhvTnE3OHpucU03WnFSQVFD?=
 =?utf-8?B?ZHIzbENCWGowQndGMFU1bUMzRzRxRllFd3NnZjVpaEszc28zS1Jrbkdsamhp?=
 =?utf-8?B?ZVhTZVFDQ0dXREVZVXVYS1dSeWhVY3lkalptc3gxdDlaRXQxZzkvZlZFWWxC?=
 =?utf-8?B?czJ5RmNHd2lUZVVlTWk0TUFFR3piWHExeFUwNEpjL2NBbWdXRTZxQ21CUzJn?=
 =?utf-8?B?TEN0bXJLL3BSS1pZbjlVUGdvRW5qQU11VXR4YXZ3RlFHSmUyVmFLZ0ZCTFZa?=
 =?utf-8?B?V0VKWlAweEtKRWI0YTBLSDhld0lNZ2pYY2tQZW1ZL0k2WXVwTjdCSFRpOUNH?=
 =?utf-8?B?amoza2VkblhpbWJuTUtRZmVLVnhCcElBNVIxNGphSzZrd0Z4NnphaHNvSEZx?=
 =?utf-8?B?RzhqM2dwMDRWY21WN21LL3plTVlUYTJlV2pGbVJGOXA4UUZwS3hvSEsyQkw5?=
 =?utf-8?B?K2pBZUt4dEVQM0Zncnozb2Z0Qi84Q0Q0Z0ZvQmh6WElyZjdxVnk4TFJjQVp5?=
 =?utf-8?B?QS91OFJ5VDlPQzNZdE1kb3hEUDREZ3QzUk1ncmZUWW02OTQvWE5pQVZkYSt2?=
 =?utf-8?B?NHZlMm8vd29iV1dBcmZSVUdHZlFNNndzU1ZoVUZJbFJYK2xER2Uvb2VuNllR?=
 =?utf-8?B?Ty9seWFJZHFiSnR6L1JmWk1KdUhya1ZIVVB0MDV3OUJlSWgxaUtGcitzNnhh?=
 =?utf-8?B?b2ZyZDh1VlFZTFJDM3oyMVpGWC9oTm90c09LcnhZU0d4b2hZTGFlSC8xOGdi?=
 =?utf-8?B?T3h2VmgzaitLck00Z2N5dE9NOHR5aThwLzR6NEJsZHdka0I3djgwdVFtRlRW?=
 =?utf-8?B?ajN2VXN2eFlIT3cxK0tPSVQwK2NYSlpocVRtcHdnOWhWM0NaMGwvWnVZOU5Z?=
 =?utf-8?B?RDFVckc1dUthZm13VEJ1SFdRRi9zV1lEdjlCcS9OVDEwYXBUWmZ1T2UvQmgz?=
 =?utf-8?B?TUJOUkZBaVhZUHlFekQzT3RMK3Z2b3hoSmpoYUtULzN3SjlCVzNOd0pqcTEy?=
 =?utf-8?B?KzNoRGJKS3pBNHJQVU5FT3dWcHd2ajBMYW84ZE5QZFRhaXBmQnNUamE4aU1K?=
 =?utf-8?B?UFJXaXk1UlBocUQrME9Ec2wvaUtJQ25ySG56bG1ZUG1MQ2ZYcUJTQ1NnVWE0?=
 =?utf-8?B?MHQra3V2U3AxVldNSDZhaUpZYVpvK1ZHek1uR0VVQ1RlUzRnb1c3cTI2TTM3?=
 =?utf-8?B?dnBiSmw3Q0FRK2QyZzBRTmZKWnkvQnZBTzFFaER0cEVvZ1cyaWYxdndPcy90?=
 =?utf-8?B?bFdsRzd1anphVUJkZHpKcS9OdWduMGh0cEFKS3k3eG9WQWZoc2hrQjh0Wm9o?=
 =?utf-8?B?UGFaalJxUEp0WGl3VVN0SjNrUUlmUkdhYVY5NGVhMFFKQ0ZlcUEySHczdzF5?=
 =?utf-8?B?d09BcEM5N1ZJQjFTRkxBdVNhdkxXYW5FWHhvY3NwNW83cTN5cURrSDgwM2x0?=
 =?utf-8?B?eEd0OWpVNllXMGg3Y290QlRPb3JaenM2b1R6eFZ4TG9Xemp0ckJ5eHFhU1NM?=
 =?utf-8?B?Yk5LOVcrVTZ6MGI3S09Zbm1PWDBCSHRYcmZtN05yQWIxaFhTQ2trTDJjTWdK?=
 =?utf-8?B?cHJFaUJQaGFUV1hFYTlOaXBETWxuRXdpWGhaUkR2MTMxYW05blM5QUJza1Zo?=
 =?utf-8?B?MEFGUHAzQ1ZiL1BHWDNSSlN2TWpaYW1jalBvcG5NNnhGTWJwUy9OYUh1N1hp?=
 =?utf-8?Q?x/hUIf7VK/R8KXxUz7D/HI0LbiSzct8IWzPYzd2HrgJ6?=
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
	ixFVFOmyjy2eXUNizHWqvlpe5JxZwQNEV3xhfdw/ue2z56VsIQp0BlE9ffLSgapyScYRmzRaYHWp72kCQx2bo5EPq8WZdhDjM1MGsNLgIkzW0XmOPgsBklFjkygfTHlrTYr2JKdRORF7TbSSC1dNUPacB9fDc5ps1uad1sGQDgrL5np4UM1ZZGQ3Irevgg2udk5nqCt8zxjW/CVsKa9v7INVg9+ondQCzQzbW7QNPW4qvjNYzDXsf3cVCbaspFn8IsOey+B+BlAh+kk5iqjLcQ+H8EW5zcIc0gtXcNLzIdjMx9KZ9W7CtrPJlo6LvMt17ZvUyNPE371NLGskGiwPgerbKM8c3u87S7kBPOaKL5Ul6b1nbcfaOzruDeZguvv1waycE1oinuEub+JQF7bV4lfVDAl2nWbvzoi6/BKdrxeje58plrDhBNEFoulpYmWSLYDlV71gCS+yvD2sZtiquXt/x7neb/UilzLTkFk2UfYRzdrU6HUr0QyJDKKWqnK34K2o1Ym5lHDDJwzL1ugxZWvuOhssCq1J7rACUkVyG97QVt/watcek0g3aUlkclt44/oVZjL0xP8xNFE0M1TgtQ/xFHG6P9eMMgAskxEvqSeaXbVYlNFUDxgH4vVt7lXK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f869ddd7-b0a0-4516-f6d1-08dd2bca8ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2025 07:45:13.6942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yy/OjayaKknYJykXYvMdc0ukjiDk9ItK+gcu+rvRF0ki5tu0l6iq+OW+Gm4CmdSRmGn4Y7+dL+KpdqQ0G/hpcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9303

PiBIaSBBdnJpLA0KPiANCj4gQWx0aG91Z2ggdGhlIHBhdGNoIGl0c2VsZiBsb29rcyBmaW5lIHRv
IG1lLCBpcyB0aGUgZGVzY3JpcHRpb24gYWNjdXJhdGU/ICJkZWFkDQo+IGNvZGUiIG1lYW5zIGNv
ZGUgdGhhdCBpcyBub3QgZXhlY3V0ZWQuIEkgdGhpbmsgdGhhdCB0aGUgY29kZSByZW1vdmVkIGJ5
IHRoaXMNCj4gcGF0Y2ggZ2V0cyBleGVjdXRlZD8NCldpbGwgZml4Lg0KDQo+IA0KPiA+IGRpZmYg
LS1naXQgYS9pbmNsdWRlL3Vmcy91ZnNoY2kuaCBiL2luY2x1ZGUvdWZzL3Vmc2hjaS5oIGluZGV4
DQo+ID4gMjczNjRjNGE2ZWY5Li4xNTVmMDgwMWU5MDcgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVk
ZS91ZnMvdWZzaGNpLmgNCj4gPiArKysgYi9pbmNsdWRlL3Vmcy91ZnNoY2kuaA0KPiA+IEBAIC0y
Myw3ICsyMyw3IEBAIGVudW0gew0KPiA+ICAgLyogVUZTSENJIFJlZ2lzdGVycyAqLw0KPiA+ICAg
ZW51bSB7DQo+ID4gICAgICAgUkVHX0NPTlRST0xMRVJfQ0FQQUJJTElUSUVTICAgICAgICAgICAg
ID0gMHgwMCwNCj4gPiAtICAgICBSRUdfTUNRQ0FQICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgPSAweDA0LA0KPiA+ICsgICAgIFJFR19NQ1FDQVAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICA9IDB4MDQsDQo+IA0KPiBJcyB0aGlzIHdoaXRlc3BhY2Utb25seSBjaGFuZ2UgcmVhbGx5
IG5lY2Vzc2FyeT8NCkkgd2FzIHVzaW5nIHRhYiAtIHdpbGwgZml4Lg0KDQpUaGFua3MsDQpBdnJp
DQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
