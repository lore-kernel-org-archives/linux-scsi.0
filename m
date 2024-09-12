Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9447D3307B;
	Thu, 12 Sep 2024 06:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726123918; cv=fail; b=JzRty5Ti7HQjcehdtXnRM8BeSYKHb+0Xg5G/BvLRBFZo8EFQ1pvocevuslKy3fxJ09FXtKNHxZCcLLl0XGCWP1/uqf8c/t+pxEBOe22bHAeo2zA4hUNEmKGkiOaCiu5a/0/TWobv+KWYSKJRrkiEPy593aCONqeb5tp7X2JMAGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726123918; c=relaxed/simple;
	bh=rNrUOuvBWJ00bp4R8vde7Q31XJOxp54aFoqYWSZocag=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dhgW5FKg/pvUMnwA3L1NGlTfC/h4isYlhts/qSBVtPYfFWgOcGZuyjF4aciNEDsnQDS/9GbE8f8HI9B9cbDjMEDSOL/OhBH44OLYlPBXLCjy0C1Ahe7CfhM1eeQ/VG9995q+hpQ7voVj2PcHVDolUb5mVqwa23HvGj+Q2oSIdBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F3nS0ByV; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=IhF2cFNz; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F3nS0ByV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IhF2cFNz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726123916; x=1757659916;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rNrUOuvBWJ00bp4R8vde7Q31XJOxp54aFoqYWSZocag=;
  b=F3nS0ByV2NxVZWReTWJaoHoq1BKcw2HXGlGG3o3zdEEdhAQkMRtHPG4M
   BsMQIqniVR534jnGA0z6px1q979Ynwj4+BswgY6yAHtbhVDy+1Y1VPFG1
   qXgoFTeqoblJAmT0ef7fwrUuhSqw+l2xpxP+ARr5oPDExmoga8tkPRtyo
   s3o8NEWQC8pDSBUCoJGbfl6LlFI4aflpt6EoRof9otYif9vhRx0KSQP+t
   LxJFDBNbsb15e/AvYUNss2Pt8RpeEl0GA1pndowwk8g9mDkBMH1MpsnvX
   Adhb0+0EUM1zV4PBX0VBMnVTE0FH/z9lQfj7pXJqVv6kRRsKO8Q/U3wc0
   Q==;
X-CSE-ConnectionGUID: wCAU3JgqT2uP4azpcp0Qpw==
X-CSE-MsgGUID: Duzw3mKWRES/XzcUpD6qDA==
X-IronPort-AV: E=Sophos;i="6.10,222,1719849600"; 
   d="scan'208";a="25874371"
Received: from mail-eastusazlp17010007.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.7])
  by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2024 14:51:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h3qn5sAAp9mOLZmKP1GSfQX8duNl+8w7ZvsQayNvhtwzqM8iHFYmOUMl8wBYYatv3cIKbfxQR+utM3zOWGlKa29l/30sH2YZqyCzRoia16WMeJpd8v0mXU8o9DoWe5ASY3EZiar3wxyVJQA7IdsPvZwyRecpRp6S56XSoxeeRHvksheQX9vVhBS31lYzgRsvNIqz5nlzy9Ww1Ox3PH7+5CIfK9eTXuDPhNxxC63Z2yJPWsdKmPRZKN4V+epigaHA9yBwBlAnjO2yjbo2VFxVRuHs5myK65kHXzC1BVJ0sJNeF0eMAEDDzJPJKFXqALe4M7H3jxf8P3FwldUO97tw4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNrUOuvBWJ00bp4R8vde7Q31XJOxp54aFoqYWSZocag=;
 b=YSujP1wv/3dqjl2IdQUFk4PGzzqHQ0vEtKIs8pOhppe9ZWdzFxeL6aVskoV+aXtniKkcGVRzSnlAvujzDBOmwBIeA+Uhbgyka/F1CWSL5knXz5YvapcRFZZ27aFDgfDCsJS0jSamGcVhGVz+72iMBOCjZrMw7Q1sHvOjHX0ZQu+c1wrYPjAhf3L+s2k6YFcdW/GP33A/DpsiLwSsflzFFg7JL+tS2YClnrnVwDuTCk+WgDlUxpukac876wYVGQ7nMOzZoNelJDeP/QAwNFkUs76pckuUUCbhg9/bnZJsX76E8Kd3tRSug2xAVkXDGXqYbVNlaEhyrbODjlgfEtdiOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNrUOuvBWJ00bp4R8vde7Q31XJOxp54aFoqYWSZocag=;
 b=IhF2cFNzwFdihKHmJoF9isQcemUWawdGdbDk2ZBRvic1ZwurFMHABugZp4WGm3NKJaFOGYdWk8CUgBynuPyRcnw7bT57/warrO4WmaYvB0zt6b0MxhrscmjgRHT0/VoCj2cHBQT/QhTAMmrZzy7Am+0z+6oMDRjnZP/gtcQb3LU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM8PR04MB8006.namprd04.prod.outlook.com (2603:10b6:8:9::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.17; Thu, 12 Sep 2024 06:51:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7962.017; Thu, 12 Sep 2024
 06:51:34 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Topic: [PATCH] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Index: AQHbBA1MJoW/Ge5VA0G2ZwqG167dA7JTXwmAgABX8OA=
Date: Thu, 12 Sep 2024 06:51:34 +0000
Message-ID:
 <DM6PR04MB657592C1289C605D13ECE214FC642@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240911053951.4032533-1-avri.altman@wdc.com>
 <e19fc109-9711-4a3d-9aaf-4a7159946a2b@acm.org>
In-Reply-To: <e19fc109-9711-4a3d-9aaf-4a7159946a2b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM8PR04MB8006:EE_
x-ms-office365-filtering-correlation-id: 3fe692fe-74a6-4b5a-59d0-08dcd2f75753
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d1M0Z3JaQytza01pcnNxeVZDd25BYk1XeTJZN2tOZHhRTnN5c3BCTXZqd1lz?=
 =?utf-8?B?RlNxcFA4bnA5ZnRYK0R1ZHRvcFV5T0xxays1QXpIc1JsRWJjdDJnZ1N5eEtP?=
 =?utf-8?B?T0pDLzlTbmNIMldSeXlRMG5pYjV5L21qNXNwb3Jxam8wM2ltRlpLUXQ4Mk5a?=
 =?utf-8?B?aStFeTh2c3IrQjJLODd4dnNQNE0rWWY0RjlCZUhjSE9uNUh3cXhKNE1abGQ4?=
 =?utf-8?B?TEZkalMyUHUxV0dxTWM2bU82Z3V1WGFobkNzSzRNaWNYQVlTdDlvTmNFam1X?=
 =?utf-8?B?cUVUVHhqcXJyc25LTVJTcVNGTDZoN3RQVGFteU5xS1FmMmxKQjhMVFRnZGcz?=
 =?utf-8?B?ZHVnVjRhTDVXeUVlODZ1bjZRKzFkWnNzYmUwYVJXa05aczhSSExXY29sM3BK?=
 =?utf-8?B?bDB5UjRuODRNSHZYbWpsdjIxdDBHS01nSk1UbU1KMkltWjFrSWxhczFDc2h1?=
 =?utf-8?B?ekF2YWo1cng2ZEpIWTJEdFRGd3JYSmFUTWhWam9wcDhrYmpqazVlWDBYczhs?=
 =?utf-8?B?dENmQXRkQWxFZGpvelVTcGEzRURvSnV2YUlocHVpQTBVVEtwNjJObjU0YXRM?=
 =?utf-8?B?eU5yQkhjZllyWllkUEFUSUVFUmZLQVpWTVJxOG5CL05NZFlPYzAvck1Ba1VY?=
 =?utf-8?B?Y1BZSlJsRnRmM004MDhwd3JvN29jd3VvdnlUUDMra2lGWVNyUW52aDlrNWZl?=
 =?utf-8?B?anhIVVNOVlBMdElvZnBpOGJDZlVLWk1veFIvTnZSbCtZa2dLZjVoKzU3dlVL?=
 =?utf-8?B?YmlIcGRXT2cwVDY0czNyVWE2cmZaODdSZEZGS1dUckxyUlJxcExYaHkwbmtl?=
 =?utf-8?B?Q3BLNldCNmMvQWpKcmlHUmt3SVBFcWd2VmpSNjVEQ3VaUU9oYzY2Y1paSFVG?=
 =?utf-8?B?Tyt4QzJvMXd1S0ZkTFZTUVRIY3l6OG10cDhvMTRvcFlvSEJCbTZ1MEdPM3dO?=
 =?utf-8?B?cFk3eUtyU3JCaVhiVStXKzRTSTNrbnJNaURuZklBSTdQVE5pMFpTTjROSTd5?=
 =?utf-8?B?SE93emFQcEhjWjJlUlZnQlZnalJMUmJyQkMyU3lFQ3BjV1cxUnk3aGUySHNS?=
 =?utf-8?B?UmZIT255WGM2bFlnYkF0Z08vV2hCVkxMVFdkUjRLeUlmL0RsNTZYZ0hQank4?=
 =?utf-8?B?Y2Z0WWFwemNNSjVaWW50b2VvRHY2OTB0bGg5UFJPT2lvNjVBQ0VuMDZ3L2kv?=
 =?utf-8?B?RG9acVZBc2pDeXBrQ3ZzS2hWUUFqNnduNTFxZThQNXlQMzlNbGdWaFhUakVR?=
 =?utf-8?B?L1doVmVJVUlqdm9iMHhRbFhubnlrdGVza3JYQTMzRUlRNHRnOW1TVlhFczFW?=
 =?utf-8?B?aUl3aWI5MUtzbEpabXRLU2ZzS0UxNkZXWXpTOVFlMU0wNExRWXZzVGp5bjly?=
 =?utf-8?B?Q2VMWVdya1h2VmNzTGFsZkRiRE9GY2FVdlpWRkdmWWxNUmIwSHN1U0o0aURu?=
 =?utf-8?B?b0JORk5DUWRKVktXUFR1ZGhsS3NpcmhSN3BETG84eDB2dUhRSDFRZkFObUxv?=
 =?utf-8?B?TStjMEpFeWZ0cFNDSnBQazFORzdxeGZWbzcyK09HVm5MSURQUlRHVVkxa2Q3?=
 =?utf-8?B?VkE1R1JSQjVNaHd0bEFXVmszcmJpYzNjcVkzMFZBMzc5enREN3FkQ3NObHZn?=
 =?utf-8?B?YndNYS8zL2ZnZFR3NmlUMVFGcmdyc1Y4ajBmQVJpOWYzbjRaemhBSUp3VEpt?=
 =?utf-8?B?UllsUWcvZWFBTHdHTjhHaUtVdzdOdS8razVKU3RhVXdQT1RuRThqTEcwY1ZD?=
 =?utf-8?B?bTJLZ3B3clplVUZQL1o3QlJEQi9Ea3VnUEp5Vk1CY3A2blFhVmd1NFpwQTVY?=
 =?utf-8?B?ZERlUXZ5RGRtQmJjcmNDVmVVQ3NXdDJ5eVJoNHdaNFdYQVhhOFZrTm1Jc290?=
 =?utf-8?B?RmY2RGp1cnFSSHhycUNRQ3o3akt1Nit6eXdOaFBSZStjOUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MWhyWkdTdVI4LzJhUlQxWEJndkpoamErMU1MemN1TUYrQnR6ZkQ4ckNHOVo1?=
 =?utf-8?B?K21DRnZnMmV4OENwbWpFRFAvZHlkMUMzTlVObXRJUGF6T3BvR1hmbDdYZVVu?=
 =?utf-8?B?T1BOaFpzY2NyY29oczREeWJ5THVFNUxmeE1QaFB5a3o5dnpYNVBIV1FkcldZ?=
 =?utf-8?B?c0ZzRFlXM0dJVmtYT2lIUkU3aXFPejZvSno1Z2tad0NET2o0ZWZLL1V4OVJT?=
 =?utf-8?B?endJUmh1V28vWHFUTWpNOXpuamRBMTlsRXNianFHVWxabjdXMTlOc3c4MFl0?=
 =?utf-8?B?eHJkcXlWa2tEeUh5d3RiWmRwRW4ranBsY1hROTZWQTdYRkJIN1ZKU2QwN2xN?=
 =?utf-8?B?L1JxckRCdXRGZlR0ZXhYZFl4dnphOU5GSVoxMzcwSEtkaXoveUxFcWNVOEVL?=
 =?utf-8?B?dnNGT29CYkE2RFRlZm5ybjAvdnIzNk1sMlF3V3FJQUpYT2E1VlAwY0UyazVV?=
 =?utf-8?B?aHN1amczVHhmMkZqMzQweHVoYm1hVFhlVlNmOWlLcHZvSEtzWE00TkhmSllK?=
 =?utf-8?B?TTF3c0MzQWNXV21KaVRBaGpkcWlXRDZSWjlTTXI2SWx0TVRVdGErWVZkaXhV?=
 =?utf-8?B?eFZrL2VNN0FCdVBmZUluSGx1bGJ5N25DZlhndUs5bU51dWJDam5hM1hGQ2ZX?=
 =?utf-8?B?N3JZRmJKeXFCMUZRbTZMRWM3eGRQMzNLNXNRZ1AxSFZ0QWZzYzFwbGFFRDJZ?=
 =?utf-8?B?NzVhRytWcFA5YUdwejFxeFl3NjV4L2YySW0ycHlidlJtZ3dyMkhFRVNFc1hk?=
 =?utf-8?B?YUt1OUFKT2hNdWd3WjlkMHBEdHRIWXJsZy82bmdLaTVqVE1WU1UrcG5nblgv?=
 =?utf-8?B?VFlOeGU2bnZSN3dhZkNwejkzMGFHenNWZmJwSGx3OWo5cElEQUxLTHpNYVJZ?=
 =?utf-8?B?TGM0UGgyWHFNWWdod2h0bElNRUdyZmp1S2hNVkVvbUNjT25ZbU1iRzdQTE14?=
 =?utf-8?B?Ulh4Um53cnFubTRDSkFsOVdYQWpTZVFKRDBNWVd3N01LL3Vsa3htRWRTOFh0?=
 =?utf-8?B?dWxyUmlwZDREeUtvMmMvbjhqK1BHYlNDMDFVZTFiVTNubXVwb1NPbUo4Zm85?=
 =?utf-8?B?SVk5M09ueXVwanNyekRMZWRYYnJSZTNLVnF6bU9MVWRPMEhqa0xnVmpoUDNL?=
 =?utf-8?B?WWROOU1VY1JVNlVDY2ptSEhocC93VGFqVXZhalRNRWRxbHd0ZjFYVmE5Qkl3?=
 =?utf-8?B?dWdpRXJMT3BZc1VFSWZvcjQ1WFFQdGpSbkoxVDkxUHhYb0Y1MUNsLzU4S2Mr?=
 =?utf-8?B?WDN4OVRrTkdmdFVjeElzU0EyUHAvZ3lYNjVEQjA4QmFHdm5wQmxySXp3MkdO?=
 =?utf-8?B?eGxzR0hIREZWS2h3a2FmakVpTFd4anFxYm5iTXlVVUU0WUF4UFVNaWNxQlNG?=
 =?utf-8?B?STFYR2dobmxyUlZoazl1blhZYXRCMzBSMi9WUHlXdUpVOHlzaGxKaE8yeGtQ?=
 =?utf-8?B?b0VVTlNpZ1pYOU1sVlpIdFBXMWF0MXYwRmhFNENPbUNBN2pBTkgzY1k2VXc4?=
 =?utf-8?B?dE5EKzNVeHVnaG5jUHJIZGJJRVIwWUo5MC9DZnJ0WVlMY05Cc1RuY2dMeWFB?=
 =?utf-8?B?TThNWENaTHprQ2FuMkpBdXFVZzVFOUl6eU9mdU00ODBDbnd2ZUphMWN6K2do?=
 =?utf-8?B?N2w1OG1OV0ZxanBVbVJKUHdKWk9PbjRFQjRRUTJPSmZOemdLS0VqSEhTVTJK?=
 =?utf-8?B?V0VlcFVmUTdCQmlyM25KUk9idmhLME5jb3BralJrZmtlbExYNWFFSS9BVUkz?=
 =?utf-8?B?OTUrMjZGZEw2cUZuazUxU3BFQklzdEVJYlBXUnZoVHIwZlAxSG5LaG4wbWM3?=
 =?utf-8?B?S29ZTjdKMFhxMkFyUlBlV3B0b0prZ3NiQVdyb0p4dlNFU3F3dFRwbFRmdmMr?=
 =?utf-8?B?akVWV09EY1RQVjNYN2xMa0Q4b3lnSUZKVS84Y094bGNQTW9iZHMrN2xjbmpq?=
 =?utf-8?B?MTdRSlBXTVcvcVRqZUNWMVpVYlpFYWhaYkhVenNhLy91d2x6Wk45TnZRZitI?=
 =?utf-8?B?Wi93TitRZDFQWVdQc2dCM1JEdUhyYWJiMDFEYTJVNnRrQTFla0wxdWExSGtr?=
 =?utf-8?B?UUZ0ZWxDcmd1RTdZclE0RTJUakVLaEk3SDFHTS9UM2VDOHJtREdrc3RvZTly?=
 =?utf-8?B?dzlyS3lhRXhkbktPRG5wNkRSL1c2UXVoeXQ2R1Z3L0tvMGh2ZXFKRTR0NWZi?=
 =?utf-8?Q?fzpDu1L0lZOXre1nInKfQX9d4Upe/glTHYnKrLtxKael?=
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
	AlKcFgSRKeAaxTFb+njv9En2iF34QvF8p5NF/e1nSLCVIMOJ/kcm/ju8W6DGHHSgimEOpddJMVr9YOleNadNxUkyXcaPw17pUXxQlVhwIx7fAdPVVBig5jjPH2fLYOV8I9oisoxGFkWQnGVRaFEk7UTe5ZwvFUGisoR3A+y5SYcUiMet841fa+XHl/aHOeaZ3TXqjIO0JzDRDbCGwnkTNQK87ud/x6fUcZ2OMBD3j9ur9raz8OZkjRsSTOrVt3fMsCsEO+QioZs+GDgzCF0f3bL8Ne9boOw2fAcruDQqceZd/xZVuTpVcaIijcfUxPQ35h4/wnZeJ6/0QFm+H73Kcj6hCEGPoVe5RyjtlEpTF3eB5C0ZA13KIYj6FI8QfIU8uZTVo7j+W1t8YaqKST2XG/xhnFYKWOm6fzV+HlnbOCVJsCNVJXZV9P+F9ZFffeXF19cLucr8MpyDiXAwwj+5aSOILiaCl9bzQAN7Ii9QIIRMmoNj46v+JfR8TfEExgVDX665rAJfm7WiBeqnHHooDh9sei3Yf9GWdpr7Pyn/nJMFoIPv72Ws2g6w2fKKMQ03B+DH3mf1wUXVJAtVOOs7Tp0vAMJzyApaVMbsPdDDZOF2jdG9F8T9nyPQsDx62PAb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe692fe-74a6-4b5a-59d0-08dcd2f75753
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 06:51:34.3485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UAoqNboTDpoOf3VGDFg93sbPTItg4dbpEr5ADflcoSXdqU7hAiezz5DMGk2NkG5DlXNqSAmf4K7XfFYn52orPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8006

PiANCj4gT24gOS8xMC8yNCAxMDozOSBQTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gK3N0YXRp
YyB2b2lkIHplcm9fdXRwX3VwaXUoc3RydWN0IHV0cF91cGl1X3JlcSAqcmVxKSB7DQo+ID4gKyAg
ICAgbWVtc2V0KCZyZXEtPnV0cF91cGl1LCAwLCBzaXplb2YocmVxLT51dHBfdXBpdSkpOyB9DQo+
IA0KPiBJbnRyb2R1Y2luZyBhIGZ1bmN0aW9uIHRoYXQgb25seSBjYWxscyBtZW1zZXQoKSBzZWVt
cyBsaWtlIG92ZXJraWxsIHRvIG1lLiBQbGVhc2UNCj4gY2FsbCBtZW1zZXQoKSBkaXJlY3RseS4N
CkRvbmUuDQoNCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9zY3NpL3Njc2lfYnNn
X3Vmcy5oDQo+ID4gYi9pbmNsdWRlL3VhcGkvc2NzaS9zY3NpX2JzZ191ZnMuaA0KPiA+IGluZGV4
IDhjMjllNDk4ZWY5OC4uYjBkNjBkNTRkNmM5IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFw
aS9zY3NpL3Njc2lfYnNnX3Vmcy5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBpL3Njc2kvc2NzaV9i
c2dfdWZzLmgNCj4gPiBAQCAtMTYyLDExICsxNjIsMTMgQEAgc3RydWN0IHV0cF91cGl1X2NtZCB7
DQo+ID4gICAgKi8NCj4gPiAgIHN0cnVjdCB1dHBfdXBpdV9yZXEgew0KPiA+ICAgICAgIHN0cnVj
dCB1dHBfdXBpdV9oZWFkZXIgaGVhZGVyOw0KPiA+IC0gICAgIHVuaW9uIHsNCj4gPiAtICAgICAg
ICAgICAgIHN0cnVjdCB1dHBfdXBpdV9jbWQgICAgICAgICAgICAgc2M7DQo+ID4gLSAgICAgICAg
ICAgICBzdHJ1Y3QgdXRwX3VwaXVfcXVlcnkgICAgICAgICAgIHFyOw0KPiA+IC0gICAgICAgICAg
ICAgc3RydWN0IHV0cF91cGl1X3F1ZXJ5ICAgICAgICAgICB1YzsNCj4gPiAtICAgICB9Ow0KPiA+
ICsgICAgIHN0cnVjdF9ncm91cCh1dHBfdXBpdSwNCj4gPiArICAgICAgICAgICAgIHVuaW9uIHsN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHV0cF91cGl1X2NtZCAgICAgc2M7DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB1dHBfdXBpdV9xdWVyeSAgIHFyOw0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdXRwX3VwaXVfcXVlcnkgICB1YzsNCj4gPiAr
ICAgICAgICAgICAgIH07DQo+ID4gKyAgICAgKTsNCj4gPiAgIH07DQo+IA0KPiBJcyB0aGUgYWJv
dmUgY2hhbmdlIHBlcmhhcHMgaW5kZXBlbmRlbnQgb2YgdGhlIHJlc3Qgb2YgdGhpcyBwYXRjaD8g
SSB0aGluayB0aGF0DQo+IHRoaXMgY2hhbmdlIGNhbiBiZSBsZWZ0IG91dC4NCkRvbmUuDQoNClAu
Uy4NCkkgd2FudGVkIHRvIG1ha2UgemVyb191dHBfdXBpdSgpIG9ibGl2aW91cyBvZiBpdHMgY2Fs
bGVycy4NCkkgZ3Vlc3MgSSBjYW4ganVzdCBkbyB0aGF0IGJ5IGp1c3QgbmFtaW5nIHRoYXQgdW5p
b24uDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0K
