Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D911537A8;
	Thu, 23 Jan 2025 07:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737617471; cv=fail; b=kkuguJxrOxk+CX9PTxod2GNQXtUPFdPq1U20KZQJs2RNRdUMkMukcoe1dCx4qoErCZQtH7E5fmI0pHLXeAcoqXyjO3Z+EOtINuKMOjUM9lx9Vl1vSciKYhyt1ISiDiFzKGX8beMxG7ps9aomXkoPaPSo9KCGcJ1NsrO9V5WKVkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737617471; c=relaxed/simple;
	bh=0GXU1CJLb68LcO+nt+FXf43jfyyDgDE9N77AB5qG234=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WvC01W/631CuJb9fKf5VvAn3muq2hSwNfTXavzSMcO1yqelsaTq8kjesJpP2usR4hnpJJPOZTiXscvD+CxAhka6lAZq6eOIVgCzRnJlfNw37aRuDZmkmT3H4Ss+ymo+unlzBv7jH7GKoJJpEINtigLcZTszEtk38rnijmwdvgSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GsyXExo8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=YWQpP1nA; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GsyXExo8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YWQpP1nA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737617469; x=1769153469;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0GXU1CJLb68LcO+nt+FXf43jfyyDgDE9N77AB5qG234=;
  b=GsyXExo8faxq5KrD+AKgAZ0pt6IBKik2BEuXJGMofcb7kxfWiTxS5Zi8
   KJY4+pL8RKN2YNcyeL6McFi9+j/ln9N1jVQ7fJc1DQ7IxJNhKNPXs3doS
   JeOZnzDPfFFv2aazszZf7TiTVRS95a/EHR+B7ccMelqKSgEJL5sBtduIc
   D3cL1Pvam8g3AjgeEw/8tSWX9+lH8ChtaZwCl+6DyDGU9oh6tUtgfflw2
   csf+IrKCcNOQbP/ieiSbRkJ2Nx0KGf8UNYg9zx+Ix5ESCGBj5QUlOyWM6
   FF3NMcRnxVORpVDPHhK5UeaRnXRN/imNHTeUeIznMP16XPN00dD7IUuEc
   Q==;
X-CSE-ConnectionGUID: oZlRyAFkTJ2UdUjIgChSnw==
X-CSE-MsgGUID: dVsLn1ACQwWf+sisNL7uzw==
X-IronPort-AV: E=Sophos;i="6.13,227,1732550400"; 
   d="scan'208";a="36592866"
Received: from mail-northcentralusazlp17012053.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.93.20.53])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2025 15:31:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cqasFpSIP/ugSIluM0esz0NnAj/93VQ9QnYshdB8c8cU13dsoGl0fH587jtNZhqFeKEXSNIdAomPbda7/qG/Cr+GW2mgIaJM/+QwYPI0DHLMcLZXe83IKgDbAX5+RawYbRVf22hxNDYgOqvddtNeHG7eVo7hyUQCshcyyRgwopDOBiR1ZrM2uuqeEwf9MORVsbKEJnpYJu6VehpoLzJ82V1MAlwYp6k2rskQjnnBsZrwsFaoDgOb//ejKkL/+2zRGdzRqUdpb2DVoGUX0lwSIBYpS6fHuaH2BG79zV9QJGRcdE52GvJcX8IbK9vnuAy9WzN810qb7VbUN+hfjJ8NkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0GXU1CJLb68LcO+nt+FXf43jfyyDgDE9N77AB5qG234=;
 b=DLceeTQ80M2dj4cyMeAISeXeGRdos5WoW2iY7+bPQn031V6EjfHbbN4XAPs7Ri3ukUshTxthwjcbvVNEI5eKYlW6VZr971URamsBp30hz9erMg5yTXYclIoas0XOwVGq+Xq/yJF2q7M3s5nXl0c7wKrplLcxoeqQPCUhCYFrPjFv2ONblZHLHiZS/6C9Tie2RVTmHJDx+mss7gWaF9zgJgPVn7ccoSv7QB8BQRl0yl0fK8yat1QGaGN1kzBudeR13PSa2tkhMjOJ8mm+62ZXdI3pBXvk1CtQvFYnBDrQm2xrkDiK7snNtR2otiqMPQGv40PHYz1gF8c1QKKWlF6TqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GXU1CJLb68LcO+nt+FXf43jfyyDgDE9N77AB5qG234=;
 b=YWQpP1nA7wXcYrkNhiWYXhEvGHLnLSsNKN0IZBoqjdh8N6m4xeQ4DmKV0V2K1OWedMXZlFOsbHnQ7GraywzdE6DSkqnlb+bHHcGBapVxfBU8LmliTgME/eIqGkssrS2eyMvR8mdCfhwwqlogJFVVF5amd2TtAU0oyIi/9mf4ejI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MW4PR04MB7380.namprd04.prod.outlook.com (2603:10b6:303:71::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.22; Thu, 23 Jan 2025 07:31:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8377.009; Thu, 23 Jan 2025
 07:31:05 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manivannan
 Sadhasivam <manisadhasivam.linux@gmail.com>, Can Guo <cang@qti.qualcomm.com>
Subject: RE: [PATCH] scsi: ufs: Move clock gating sysfs entries to ufs-sysfs.c
Thread-Topic: [PATCH] scsi: ufs: Move clock gating sysfs entries to
 ufs-sysfs.c
Thread-Index: AQHbbNtf3b+v2i0m4UuvxCr2kqq9sbMjICwAgADWnjA=
Date: Thu, 23 Jan 2025 07:31:05 +0000
Message-ID:
 <DM6PR04MB657584F352A1AD45FBD7B23DFCE02@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250122143605.3804506-1-avri.altman@wdc.com>
 <52d287b6-f6e4-4644-aef8-2c22bff59613@acm.org>
In-Reply-To: <52d287b6-f6e4-4644-aef8-2c22bff59613@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MW4PR04MB7380:EE_
x-ms-office365-filtering-correlation-id: 4c3d2cc9-46fe-4e36-457e-08dd3b7fe55e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?R3RNQk40V1Q4NmVMdEhnaFdpK1FFRlRCWmlVTlMyRWhQekFKV0J5QXprWmdq?=
 =?utf-8?B?cU1DL2tvRitVRGgxUERBZGxtaCtOdGNFeG5yaElOWllUcS9JaHFIYkVJRk5v?=
 =?utf-8?B?enQwL043UHh6VkphdWt0bkZ4NFo1VFFIdDN5NjcvQmViamtCamZNdjV6ak51?=
 =?utf-8?B?bHByK1p0dEhqWjY2M2JCMlJHU0xEaW5nY21jTm5kMTRJd0FvUHEwcmxVbWs2?=
 =?utf-8?B?MWQ5SEphV2VzV3dlWUZWVlB4QU13Q1lZeWNNd05LYUYrU2dlQ3R4c1F3ZThQ?=
 =?utf-8?B?YTR1Y0xvR294cXhIa0ZocmdBME9Jbm0xL3N0aGNVbjFSYWpWVXVsWUgwN0hv?=
 =?utf-8?B?TWhGY1FrajBFTEl6RTY3N0kvd0lGc3U3ekpXWEtQWDhwYURzWW9VSEd0Zmsz?=
 =?utf-8?B?MG1XZTRrRHdML0tMVC9sRmo2UFI5cHVjeEN3KzRWYkt0RHZhVVI2cTZITHR4?=
 =?utf-8?B?aTV0Q25adEE0cjdlZlVlcDR2cFJPZXlWYm5oNTB0c3FxWUwzdXh4MXpqbW80?=
 =?utf-8?B?S1JoWjR2enp0Sk1uZDlXc2ZzT0t4OXJWL3FMQWlmV2JOY0NwY1JFU3h6R2hY?=
 =?utf-8?B?TzRtL0IwSGJoSU9ObXZteWx2aTI3TTVLS1RJYmhtZ0FzMTZMeE1ja0hnb3hk?=
 =?utf-8?B?cDh2eHBFTXB2RWp3Z2djLzZvYlphOGl5WEFmWFVxbVNlZkhVWDBkL0hQMkh0?=
 =?utf-8?B?c0IzSE5jdTZrNGo0ZXppdjE4enJCYTRzT2puczQ5NW14LzZHQVlVY1BBdnJ3?=
 =?utf-8?B?cTkwMm15TGd0cDBwaURFWTZQNkNmdXdNU1ZnWUFydTJHU2Y1OXIzT25NNzEw?=
 =?utf-8?B?MFhXQk9JYjBCQ3ZNeE5HVHF4ZitNVnZ5TGNMc1ZiaUI2TVpqRHlGOU5YME1V?=
 =?utf-8?B?cWUvcllBUjFhOXZ1ZW8xZzYrbXJrSUw1Z0YvejNSbTNZU2tmN0YxcEVXL0xy?=
 =?utf-8?B?emhYVnY5WUZBR09KakhBemNHZHh6WHp3dGM1NWczZVhmMHl2NjhiekFqWlJR?=
 =?utf-8?B?d3Y1bnE3RDhPcnJEc1M2SStkS051cGx5VWMyWVN3MGtGZFJBRmYrNitkeW1L?=
 =?utf-8?B?SnlWdnlWVGN6UHozMnNxbkJ4TURvaHFRNElRVU5ET0h4OGQrOTFiMGR6M0cr?=
 =?utf-8?B?ZTYxV2JPVGFtT1pFMmRhMllkVnkrdDY5dmJtZE5OM0dWQnhOVnlWQjd0V0VI?=
 =?utf-8?B?SjFzbmEwVEF1a1NZR2NCN2U1Z2NQR1UwTU1QQk9TUkw1SGFrelB1NGh1ajlL?=
 =?utf-8?B?bW1NTVVjTHFOcmRpaTJpNGZEazVSdEcwVENEc05ya09nL1RCbGY3Y0NyZlFm?=
 =?utf-8?B?NnV6eUlCaGdkQ0pIYjdVTHR5TXhCbTJBZEc0Rzd2SktoVk5YMjU0ZXZsUVNI?=
 =?utf-8?B?dVNWZzJYbkNrV3V6TWVpMXF6Y1J5aUFQMHYrdVhoZ0JxV3d5dGp5d1ozN1B0?=
 =?utf-8?B?V0xLUGx1Wmo5d0t1bmVsaFVqUnMwR3A0czY0N3kwL0xzVUFwQUFDTU9HTlJt?=
 =?utf-8?B?R2hlcUZjOElXK3ZqS2Y0SFhvNjRMTitEZDRNT3oxemVxb2dEUk4vL3YwM2ZS?=
 =?utf-8?B?YjFnVFlEL3ptdXFqUDZhWU5xZTNlZTMwMkNwSGRvSEtrSWJYME9RUUJrRTQ5?=
 =?utf-8?B?Y0ZDd0NGdDJyMHhkMnBROTN4Q3JaOWJTeWtIL0JMUTR1S0Nrd1FsQTNvTmtX?=
 =?utf-8?B?aU5ydU5Nd0tnd3RHU0MrMi9BbmVEZ29tSFFveXBpSVlDN1BqaUVyaGJXVGhm?=
 =?utf-8?B?SEtqcXVDaGlsam5tLzkrSUhSbjZQb1FmbXJaN01rVVl0bXg5YnlyQ0lDY3Bu?=
 =?utf-8?B?VGdRQWs0RFZYSmVrUVpKQnpCWmhKTlZraUNJRG0wbStFMU5BWkFYUzNhVzNC?=
 =?utf-8?B?QWhSbWJUdWJpRjRGMGo2eXliQ3d1b1JLWklTUGh6ZS9Qdll6MUFCWEhYUEs4?=
 =?utf-8?Q?uhOUfVPNJ87342Jki0pZbVjsj+14bYC8?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RTBwRHhVUGlkTHZWNktHdDM5eG41emZnZm5nWHZaK2lMbkZqNEswVzVIclBz?=
 =?utf-8?B?dW9ZVkxZMUFOYmV3K25EcHprNFdNWXRENEt4TFBmaUZuMk5WeTRQRzhqdFFs?=
 =?utf-8?B?WjdpSjJkeUxOWFV2emlmWk9tdnFORkZCZEhtMWl3a2ZJb1pWZHBwQTdyZTZ3?=
 =?utf-8?B?Tm1tWllpMlVvenFVeVpjT1U2S0t1SlpPMWFHdmNTdEhyeUlHLzZjWVMvejZE?=
 =?utf-8?B?Slo4SE16OGYzRUQ4S2EwcGpvcksxYTEvT1ZJbExjejl5SXBSN0UzV0JyRmgz?=
 =?utf-8?B?cFpoZXJyMisvR05zTFZsTzRFTFB3YkNMVzFrVVVXM1pWVHl1QytaNWpabDRo?=
 =?utf-8?B?ZXF1UnhRZ3JEbHVSUWNNMjRYNm9IYVdGT1VNaEhRS2YydVYvdFBySDU2S3VW?=
 =?utf-8?B?YXpHRTQwdmQ1NGlmN0JmTHNyQ0hFWlUvQ3lUclo5WnlHdDlXZmh2bTQwbW4r?=
 =?utf-8?B?OWd6aG42QUVldkZQSEVMcTlmOHoySXhNaXBwdWdoQ2NpeTBjVWVoZFptWlNQ?=
 =?utf-8?B?dDFpdW1IeWZDZzM4Q2pVL1hQbktUSVc2OEVMZXg1VDZERE1naGRHeFl1dit1?=
 =?utf-8?B?ckdRa0tha3I3UzRtb3hRYXI1L2hxWEozSkJORUJZdG9nbG5vMitwaHhBNldr?=
 =?utf-8?B?MTR5NmVrTVFnTmsvT2ZQNi9xY2QwNTJoR2ZHMVhrVERFcnlLcUpCOGVRWVNW?=
 =?utf-8?B?akdtZlV0WHRQbDFQY0tramI3SXBZVGdPZUMwQTBaREszQnpTNTV3VDNRZVVa?=
 =?utf-8?B?NXZpR2Y0WS93Y3JhbWtLUC9idkVmYXlISXdyRTBURWFadlkyZVo0RHFJWGhK?=
 =?utf-8?B?KzlERXNoQkVEWmZNbzdOMlltS1Y4NzJvSGRvcmZQM2FqYldzQ0F1elgrYU5T?=
 =?utf-8?B?UGtsV2ZpaVRKdGt6N0lkNkd4WXE3NnZhbmd2QW1oeGFlQWE2QXRpSXAzSTRu?=
 =?utf-8?B?Y3FLdXQ0M0dGeThGU0xHQjAzVk4yN3VYZmdzbEhLVTcxck05ek5NZ21ubEdT?=
 =?utf-8?B?aHVQTnVnOTBsT0hhK0xWTFFlVjFBQWdzTUhaWGV2elp6VStFNVFHbEVsMm44?=
 =?utf-8?B?ckNvQll3bFU0ZHRjb1Z5S29aa0M0SXFwVG1JZXFPTGp5bHYxVDhiVXlBZnZB?=
 =?utf-8?B?YzBVMEpPaXhSOWRDRC9IK1dTV1FEc2pYZHJ6SHJPdXloZndVNDFxTkdwSkxv?=
 =?utf-8?B?TktvRUZFUHZlTEhoNGlmSzE2TGYya0drWEI0VEtEOGlTWjJxOXJyMmxkSkFt?=
 =?utf-8?B?WExJajdpRS9NOWxMcXVtOFlwMGxzQmRVbWc2ZDNIcllpOHQvQlVaaXBnY3FY?=
 =?utf-8?B?L3duRTI2VTVwUGZiU3lXcmpESU50QUVkYXRNdDRaWFhCV0xVNDVnS3cyR1Fj?=
 =?utf-8?B?L0V2bnFQdngxSkMybDZ3OStuY1UycVBmRzFRb2ZPL1VqVEw0THhBaGZDUGhk?=
 =?utf-8?B?UlNuUkFFVk4zVXl3Skp3UDRyS0FRQm0zdnE0S2g4aVBBVnJYU0ZMVUp4VWRP?=
 =?utf-8?B?T2U5cHloeGFiaitQZGhMc0o5ZWhpb2tIVk9WbWR0ajRIOTN2RzlqeTFFelRN?=
 =?utf-8?B?UjJaamNzUUhKYjNBbHdpdndBMXZLOFBQMDRoNkNreEtoT3lqN3ZMaWpCclNJ?=
 =?utf-8?B?NlN1elV6QkhmbDF2VnJNZ0tqU2NLejhsOE1SN3dYWnp4WXR3bFhTU3hHbHBi?=
 =?utf-8?B?dEM5RURkdk0wUDVmay9adjB5OWlodUhHdG9rQVBrRDlBcFoyNmMrLzZObEhF?=
 =?utf-8?B?S1RzUldkdFFzSlpJK21qMVhwWVVZM2NzVXlDTTJvS3dSVVB3RFpkTmNnYWp2?=
 =?utf-8?B?MnRSV3Rvdy9DMVdmUGIzUjY2ZURZQU42b3pVRDFjVFVEMkJsZ2hvTWp2Z3Fp?=
 =?utf-8?B?S0tpQUFUUERLaWdhMVRGUXA3MnpXQjJNaWZjMkh3ZkU3bTdnc2JjSWIvd0dx?=
 =?utf-8?B?clk3bGFnWVpwaHY2a2ovelpJSmdIS1NaWUxFQVd3OW94MnFDZDJhYmlNMTZi?=
 =?utf-8?B?NUY4Y0NVQ20zZ3lYVnl0VFVqMU16dFhHbmtGTHJZWGlhWlc0Z3VQbUcxUHR1?=
 =?utf-8?B?dUtiWDJsWnZZSlJVeVdObkFDaXZtL0RWaFE5Qm9HMWRTaEJwUHNnR1p1cUxC?=
 =?utf-8?Q?CyaBPcM1xn/4ilBIYGYWXBEMV?=
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
	IdIvGT2laF+GVqA76WGsNHVYZ2utBX6U04snOtlWQGycjj2qHfVRglcH+x0fNHjM0LHhsFwRE2hCR97ewHfQaVRtQb4x4gmmodV95+UfjfQc5dEo1riaB3RawLDTFRp9wCqgzQ5arx9egJqyG6fcl/3IOG/NS/P8ZonA0ce+RJHWiORCyyge7NNKZsfQQ7mJt4lLwf2lnrk8GTwryNcvUtf3QxlLwSAwaH7HQpw/iBNte6M0sfCU6TsHwnCP6zRm12NJSqbTRk+oCPNJWt5vrTwRl5QhpBqku50w3X8UYUmSt0tvjk4WMUqbhWUFZc+m+JkVRvgSGEUKItjtjbq6za7KCgxtQbYSkduBwTnfqugp0x4jC5Fkv3bBVZK5jjUS1Eg1tS8IB8KRRRcOujk+NTLVXKcN1e8AvRiNVla58rhwpvAcJ4icocsJAFQ1JMMK+sg09W8FQjV7Erdup+h+uI6Z5++4Nhsh093+oACGjZgt3TpVTe2Vqnt9PUedVQ368wW5PMSBKWaIslvBNN64eN86pJ96ndcB1K+80twkkXloXJbTN32Oh6BSpw25+TTwKTdApWdLeOtCUDJIt7C2oT79uv6ucmDh8KE/7fuZO+6TSXXAxp3JEiK5+tu10NIn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3d2cc9-46fe-4e36-457e-08dd3b7fe55e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2025 07:31:05.0902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQQ5Lg0bfLyqQhqWQzKuAZ6G2tRTm4nddM25TqcI7giCXL80wZo29P2kxV9ywlVTuwIXrDFkWvghbvJLBBAk3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7380

PiBPbiAxLzIyLzI1IDY6MzYgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ICtzdGF0aWMgc3Np
emVfdA0KPiA+ICtjbGtnYXRlX2VuYWJsZV9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0
IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsDQo+ID4gKyAgICAgICAgICAgICAgICAgY2hhciAqYnVm
KQ0KPiA+ICt7DQo+IA0KPiBUaGUgYWJvdmUgZm9ybWF0dGluZyBkb2VzIG5vdCBjb25mb3JtIHRv
IHRoZSBMaW51eCBrZXJuZWwgY29kaW5nIHN0eWxlLg0KPiBQbGVhc2UgZml4IHRoaXMsIGUuZy4g
YnkgcnVubmluZyBnaXQgY2xhbmctZm9ybWF0IEhFQUReICYmIGdpdCBjb21taXQgLS1hbWVuZA0K
PiBvbiB0aGUgZ2l0IGJyYW5jaCB3aXRoIHRoaXMgcGF0Y2guDQpEb25lLg0KQUZBSUssIHRoZXJl
IGhhc24ndCBiZWVuIGEgZm9ybWFsIGFubm91bmNlbWVudCB0aGF0IGBjbGFuZy1mb3JtYXRgIHNo
b3VsZCByZXBsYWNlIGBjaGVja3BhdGNoYCBmb3IgTGludXgga2VybmVsIGRldmVsb3BtZW50Lg0K
QW5kIHllcywgd2hpbGUgY2hlY2twYXRjaCAtLXN0cmljdCBhY2NlcHRlZCB0aGUgYWJvdmUgZm9y
bWF0dGluZywgY2xhbmctZm9ybWF0IGRpZCBtYWtlIGNoYW5nZXMuDQoNCg0KPiANCj4gPiArICAg
ICBpZiAoa3N0cnRvdTMyKGJ1ZiwgMCwgJnZhbHVlKSkNCj4gPiArICAgICAgICAgICAgIHJldHVy
biAtRUlOVkFMOw0KPiA+ICsNCj4gPiArICAgICB2YWx1ZSA9ICEhdmFsdWU7DQo+IA0KPiBQbGVh
c2UgdXNlIGtzdHJ0b2Jvb2woKSBpbnN0ZWFkIG9mIHRoZSBhYm92ZSBjb2RlLg0KRG9uZS4NCg0K
VGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
