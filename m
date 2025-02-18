Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13BA22DF95;
	Tue, 18 Feb 2025 09:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870993; cv=fail; b=exVwLur34LirprJEYecO9bb3k6EhAkDBQPeoW3iVx2Y7OL1RwKPe4xqrCG3f4lsTjx3IqhWthlDgSLW7MF4/FzaVTZPG7r8C7o3TgbHzmdwkSiqKlXqLyVtA+K6SJYT+88NUvUH739W8XwT1/fdHKys7wm/LXH5j8zeOSQR+cNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870993; c=relaxed/simple;
	bh=PcN8ANjBWtE7uC0SLVaF1sWgzC2E9F690nCRuaEOAKM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NbHmrXNL4sxklKQj11uVTLlTHmIb0REyHgCKPM1ez+EIk3UcEbVjpIOZAXm3iVB4JEn8+iT7ugvT0aRpyJZYhKckQpO6fiIvgXUHRtPbITUKw6jRNdSzrA19+I/OH5Uugtl+vo5+ssz26+ZJHYFw3OlCSpxqUI0CzoqoRla1rWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=IfHz60//; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="IfHz60//"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1739870991; x=1771406991;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PcN8ANjBWtE7uC0SLVaF1sWgzC2E9F690nCRuaEOAKM=;
  b=IfHz60//y7HW8pVqXxKOeCwkybF0KuLLdNoweU1g31fiGdrGDYu+0PHQ
   bqnxv3Bx5ApMLTn6szdpsn/ZgtvY4jXuRp9Q5Y2wZPiK6dZo/xreubTa6
   NCeb+v9Ycnok8f0X6ujEhx0ByYQbtfroby21EHZ72yn+6sWc8RchWrqvZ
   EpKj9BmNWyV0DKpVjjAXMckl8ey/jAIqa0zYsPdc9XZ5XJMrkyTXs5uB0
   OhcIm8NOGeEGgT84EDGhUPmBaehi5kXnd81jT3uv6piw/PW+8Z3WyyVe/
   S3TOzwZwf9ov4JdW++O4zwC4OqJA9OewhxxzhBxllP+gkjfLOPRqwf7po
   A==;
X-CSE-ConnectionGUID: hPGhU5IlQuWsXO4thTXNMw==
X-CSE-MsgGUID: Eb5iLgEtRpuk1Hu7HIDv0w==
X-IronPort-AV: E=Sophos;i="6.13,295,1732550400"; 
   d="scan'208";a="39758061"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2025 17:29:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o1x5+6xixvtzffChlfN2nakzPH0PBvbQfg+zrs6qRfJr/SjVM3YQzqjG7F8aXEhQkk8T1Ro8lDYbjHVBQnrvgoq3glvNiEBQW8QNAe0M1W4PUiLn6sa2G+DfEKvPPkU7UJLe9CzvfrjvO2Em1EWGdIVcW3px59sbyX/vOwWmCCn0CJzClJM9FfycK4JBcE3MzwLi+DIdtlmnasITOdsXno3lkiG+ciX8VlzV0KSCEOTHOcqJclWX+ACWYpa+cKqc080Jyi2/Rnuw+Gch9azIQF5Y9XYojuvOvOR2z1qMWjncmW0D5vZPSMMYIQg1pabQPMKavJNp36hkMHak+kwuaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcN8ANjBWtE7uC0SLVaF1sWgzC2E9F690nCRuaEOAKM=;
 b=we/8VQvzuoROEV2Z6AZc88I3qzcpW+0ayVM4RihmoqssuimjppCAoYTrq1yy/SWLNbCDEdsjhDT5AHzNnwgdB/aRuMNzryurbRqM79pUE98s9BGyX0dWKGll73RJm3TGkRsvya1ghyp264OSCgxDwTiFkekOjrUlFItaCXylQvgx3E1kkW/yso4YqLraSSP+1X5Ia2G3rZD3toivegfrHGGFnJrP4LerGCXklXZwUf7vusuZ5G7Ad+1h8TNvusSrettoSxm25Oa7AWry9LwWDTS1nvoegYZoqzDp0Ge6+MXAhyrpNFOBzIw3KdUT5XCVkEXTXwP72Asz9be+CCWUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH0PR16MB4245.namprd16.prod.outlook.com (2603:10b6:510:56::15)
 by PH7PR16MB5034.namprd16.prod.outlook.com (2603:10b6:510:158::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.14; Tue, 18 Feb
 2025 09:29:47 +0000
Received: from PH0PR16MB4245.namprd16.prod.outlook.com
 ([fe80::a5b1:875b:ec99:3121]) by PH0PR16MB4245.namprd16.prod.outlook.com
 ([fe80::a5b1:875b:ec99:3121%4]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 09:29:47 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: Bean Huo <huobean@gmail.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
	<Avi.Shchislowski@sandisk.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>
Subject: RE: [PATCH] scsi: ufs: core: Fix memory crash in case arpmb command
 failed
Thread-Topic: [PATCH] scsi: ufs: core: Fix memory crash in case arpmb command
 failed
Thread-Index: AQHbgVsf725o2qgU30amhA11YdbJqLNL09gAgAD4r3A=
Date: Tue, 18 Feb 2025 09:29:46 +0000
Message-ID:
 <PH0PR16MB42454F50A606CC55274124F4F4FA2@PH0PR16MB4245.namprd16.prod.outlook.com>
References: <20250217164330.245612-1-arthur.simchaev@sandisk.com>
 <1fdfb9221f1cab04881d91e1e2d56ba97054a580.camel@gmail.com>
In-Reply-To: <1fdfb9221f1cab04881d91e1e2d56ba97054a580.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR16MB4245:EE_|PH7PR16MB5034:EE_
x-ms-office365-filtering-correlation-id: 1bc1ab8b-4afc-441d-9928-08dd4ffec91c
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L09IdnIzMlBlU2hmM1dvd3BvZ1NMWkxoS01yMDgzMGZTYmg3NElzNjFGT3Y4?=
 =?utf-8?B?V0lvRlF5czdadUtMRlFFTS9yQXBVZ1c5WGQ1QnZLd1FCNEtCcDZkalNuSUUy?=
 =?utf-8?B?aE5QcHUvUDc2d24zZ2Y3dDloTDdHS0hPejJKYzhlRlVXczZPMjlucHVEQ3ZC?=
 =?utf-8?B?dW50cWpETmNwb25QbDVpQnVYTDJDOW1GSjNCRi9jL0FKbXlDZWF4Z0hFWS9i?=
 =?utf-8?B?QjI4OTcrWkRUQXFXSkozM2Qrb05oQVZhMUtxcVAxd3A3KzNnWVByWXlqcCtw?=
 =?utf-8?B?eTM0Y05UT2R2c3N0QUdlaWs3T1hDR1NwN09qcC9IendXYnpybU5yNEd1V1Rr?=
 =?utf-8?B?SEE2YlVETHBZRkY3WmpsSitVMTRmV21YSVRieWtTSFF2aDVneEFOclBRMlZr?=
 =?utf-8?B?MFFQUzg0cEFFaEdZb3dISXYyQk5qeHBmMnFSOWFaRlZsYm53cUhTdHkwMkR1?=
 =?utf-8?B?b21KRmphTmViWlY0d1haZDNZbi9XTEY0OUsxL0wxNEt5K01wNTNGNG1VZ1ZK?=
 =?utf-8?B?dWt4L0lVUlZqek9DSWNzV3Iva1d2K2hsT0JIWk92Zy9uQ3dXY1FnOUF6TkdS?=
 =?utf-8?B?L0RRNzJ0aE5WQllBK3J5UUF2c1h2azA3a0tBQVJVRnpBSDVGWkFKcjNKTW1V?=
 =?utf-8?B?SE1Mb3FPMHJqUmZlOTA3d1dUR2Q0Y2N2K0JVTDNEa0xOT3lxWVg1RDE1MHh0?=
 =?utf-8?B?WGVOREhHNmhrVTdEaVVxdTZtdEkyODJhMjFmSXowa2xheGxrQWFxNXY2V0NJ?=
 =?utf-8?B?S3BhZmFSS2NpZlY2MzdUdEo1T1BhVDM1NWdHWjhudjJERDFzOEtIbWZmVkc2?=
 =?utf-8?B?YTJQY0o4VlpEZmlGc0ZCb1QveEpRZGJTczhWK3h4MER2RXpjUjZxbENXU0pB?=
 =?utf-8?B?bVhXWGFkaVdOZHRBZXZGOFV2ZHJ5dG9ya21WajNKSk9MN3hZNlkvdERreTVJ?=
 =?utf-8?B?MjBudjRWbTZ3M0lGT2VoYytmbmNuczNaaXZJZGpHcUk1SGIvMkVJTk9YZWlp?=
 =?utf-8?B?aWpQSXF0YTlFUExoMWQrRDc5a2owak9MeEZPSGh4cE5iOGNjanJyYmwwNjU3?=
 =?utf-8?B?dXpDdEpFclU4QnMrbFlTaXFXS2hBbmZFTWRkTng2Nkt3YjcyQmNhZkw3aUZL?=
 =?utf-8?B?dG4rczBUd0VNRXNmL2NrQU82aWQ1WU9nMDhiVzNxSUEzZVJSQTAwM2pBOVJq?=
 =?utf-8?B?QThvVWd2ZEdpcU9McnI0QTR1Tlkrd2JXNzZEaXkrRHl6d3lOUnA4UXhUejNt?=
 =?utf-8?B?Rjc4SjJRVFkrNXV6d2M2NE0yd052b0luN1UwbEhjajhOOW0zUDdGeGNKTWFt?=
 =?utf-8?B?VDZxL2h5ZklsWmlIdTRCTUowYTJHWUVDU0RUSWtsOTJ5ZXNmbnhBTXk5TmZL?=
 =?utf-8?B?S3lXbnpxN29US2wxRnJnVi9ZY2JrVDNpY1UrM09VVGNnSnI5ZHRCVm5WQnNH?=
 =?utf-8?B?S2ZIYU1UTFdPKzhiR1pPMk1mRGdwSkg3NTJLN2RBOURKT0xKbmI5V1VZVXlL?=
 =?utf-8?B?bXRTZG56K2xia0VvcHl5aktmZ2NaeU1PODM1THQwZTZwTjhHa2Y2NjlWamZ2?=
 =?utf-8?B?cjZJRmh2KzhZcWloKy83SExZWHpBbEx0Q2JaUUk3ZHlONFcrQk5UMmp2c3FC?=
 =?utf-8?B?VStnR3FrcDhhbXZQT0xxdkoxV2NtYXpyRGEyQUd3TEozcGNqeVZ2Y0E3Umwx?=
 =?utf-8?B?MzZSSlExK3ZLN3pnbEh2QzNubEtLemtpMzRaNFlYay9JTkc2WkdTeU4rUkFK?=
 =?utf-8?B?Mk1IeEVNMW5rK0g2Nm0rWExmSXJaSTltSHA2RURqamQrb0RCQWFvb0NYTkJO?=
 =?utf-8?B?RmhaQmo4eHpJQVJYYWFFaUg4VjRoYkdKNVhiNE15dDlRcW93dktyNlZTQkdk?=
 =?utf-8?B?YXRtdVhsRGV6TWRkMWZRNTdmVnE5QUt5VG5QaXhES1c2bXV3Z3gvczk4VXB4?=
 =?utf-8?Q?VWKBW3BMvMUcKdXsyrgP/WUNyCLbnTrA?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR16MB4245.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SzRTNlRzUS9XRS9kUnRCbmtsYjdoSTliTWRSbEJqTGxIeGFFbnZyOHVVNWZD?=
 =?utf-8?B?TjRPdWFmOG16c21zWDcvZ25YeEhpMWJ5T2E0RDZjc3B0b1ZXOFMzQ0VJU1Zw?=
 =?utf-8?B?eXJpRzFpMlpVWGVpWEp4TmNzSHlMeHdMQ3NWcm9FSkhPelE2cUxzWllaMmxY?=
 =?utf-8?B?eGNoQlhlWFJ2VnJPSTUwVUlFVmkzYkFQd1hSNGQ4SGJyUTJsbHJHYkFmMUFx?=
 =?utf-8?B?OTRnYVBYNkdNNk1VM05TNVN0KzA2N2NhcDdIODRMSGk3Wkx4K011M3Q5bTBv?=
 =?utf-8?B?VTBzOTk2Wms3TlE2U3o2UG1idW16MmoySnZqWlkxSmZpU0JyMFVjejdJOHpY?=
 =?utf-8?B?RXZDdlpOL0REaU9HM1JOSEZoK2VxTTM0VklEMXRxR1J4cTBaMjBjeGlMVjVh?=
 =?utf-8?B?VjJyQmhHS0ZzYTkzZ1BINlRMd0hMV3VjalA4bUVwT0FpZEQ0cG50Q1ZYcnMr?=
 =?utf-8?B?L1dZTmFydmtuM3J6VXZ4VERucVgrcW5oVThlSDRhcGNGa3pDMUlJT2xaVjY0?=
 =?utf-8?B?RjFDQndRZ0k4Wmx5ZXoybmZRbEJiQWIwelBraEdZU1ZmKzU1NCsxQjNZNXpm?=
 =?utf-8?B?aTc4eno0VnVCblBuTUFyL0tzV3ZHSnVSOW5UT1NGZTRHL0ZDWk9QZU5XWDRL?=
 =?utf-8?B?dnF3eWFTd0tpMmZDem8yVm5jRlRFK3dOZ2UrOWlGcnQ2SFV1QjJmSjdFUU5P?=
 =?utf-8?B?S1ZkTVM5S0JsMUxpYmE2Q1puVHRHVFFBVWgweGRaVEJXbjg3MUJ3NTJxMGdl?=
 =?utf-8?B?TzJTL05zUklvWUZRVDJFL012dXZkWjk1OVhDVkR4N2I2V1N5Q2tveE81NXJa?=
 =?utf-8?B?LzI3QTd4amJCSlJ1YjdhMjR1VkdWM2lpN2JjcFhLZ0RIaXpLMWdKUEhYby9x?=
 =?utf-8?B?cmVpZDhPM2MzeHBwemdSQkpNTDl1ZEV3V2lnbjRPMjd6THV1QSt3UStldmNM?=
 =?utf-8?B?ZENseHZxeGNudTBoSU5MS3BpOXlHYWQ0OGJOdkZQWkVSNW9IMlZPc3k5UEtB?=
 =?utf-8?B?NnZxZWZPVTVtNjFNN0FScXVxWjJFUkVVMzh4ZmUwU3NTWHI5VnM2RGxPUmU4?=
 =?utf-8?B?WEFmSzhRZ1MvUlpMdVhZZVUyRWRXRGp3TTF6L0RIcHBPdEgxZDVCY3FjK0pH?=
 =?utf-8?B?Q3lCenRXTzlLMVY0YVgybEpRc2NXUUVUL0l3MHY4WHZZczhDOHo3QnY3ek55?=
 =?utf-8?B?Wk1uMld2TkM2a2wrb3llR3lTU3J5eGNzUit1cGdZcm1LNFBGa294S0JGSi9o?=
 =?utf-8?B?UDJpS2NNZU8xbzE2WmpVcnNyRFAwVlJWeS9DQm5EaXdHWVdVcStDbmtkTmFC?=
 =?utf-8?B?TTc4dm9XMDNrUEpZRThnc3lnUGR5eTF0U2VDV3JYTWNkZWVFcjU1cDU3cmx4?=
 =?utf-8?B?UUdpbFMwbE9KSldJY3FSOUpEbndUcGVLNE1jTzd2Y2s3ZlZEWTh3R0JIMDRy?=
 =?utf-8?B?ampYLzloQW0wVGVXYWdhdEMwc0pGbCtld1oraGh1UmR1b25aNWVlUXlEbzlK?=
 =?utf-8?B?aUljQVRzc0VYRWMzTGhJS0IrRXJHU0xZZGZGcW5zbGxkRXYyQnVSOGlTZm53?=
 =?utf-8?B?V3ZudlcwTTJmekZOT2Rra2N6ZVBMdzMwalBhZU9WVmtROVFTWFVWVnM1Sks1?=
 =?utf-8?B?b2x6aEV6MzVlU2FJQi8vVVB6UVVCT0dYVGIrTXpKNnBEaEZTRDZjNmFuUVBS?=
 =?utf-8?B?RzFOQUtzcXIwWmZJU1R6UERCYVNzZGtKY0Rub0l6SHI2dmRnOXo0K05MbTI4?=
 =?utf-8?B?aXpNSVpJSWFnZVZCKzdDRkk3dURKbEtaYS95Y0tueURLVVdoR1RsTTlFMkJq?=
 =?utf-8?B?TmpuSkZqTDREZWdyM1g4MFBFTUlQNTZwTUgrZTZLa0VsK0VJNm51TWhUTzZ2?=
 =?utf-8?B?akFDUTdONjhQb21XMURTcyt1a0tWby9mV1c0K01icUxhTmJoeVhOQll4TER1?=
 =?utf-8?B?Sm5uVVhGdHNHU2hQL0ZUdTd3enhSM3oyZjM4emIzZllPUTVEcHdVQklwaU5z?=
 =?utf-8?B?ZjNFQTU1YlloUDJnRUJPNVVMbGV2T1VWbmgycU9FSnMzVGhFTVRhQ1ROdWNn?=
 =?utf-8?B?NTFqR3c0MlZhdDFJbkM4UldZUmVwLzh2a2dtbS8xbDIvbUpWblB5cGgyMjdq?=
 =?utf-8?B?RzJXbmErNHJDa2crdHpQQ0JueHJvY1FvZGlscU4wOFhObVVPT0pZSTV1MUg4?=
 =?utf-8?B?enc9PQ==?=
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
	gOBtmmUrqQO3b4YaSOWGJHgUqgsKPhwRMLcn4VwdAUn7jtqWkb/4YNqA2JgU+6FwJ/JaeNX6SK0RygsxKvGhBQpeoYpXVwdiPHZYWvyt9u6+PhyGI/9oxCs/WNnjTxQth0XcPnLkTErVjJVLEp6uqhjxqSldrGptWBTi1Br2hWAlh//HaZbXs39V1ojFduxiwytL0TCQ0oyVCu3kPe2VYXYvMEiqp8K8/410i8gvv5SMfNRn+/b+AKNrC8CcSfxVOdIQ50VioZcm3U3vbVKzLeLXmtPI4KeEtAQMMrG8dd/I8jNbK/qA2m1h09psaZ9bfTcAfo6F7dXaE7Xoisd8KsKsSRsq3SBC8J+K5xa/HOO1oZvv4M6hdMX2r/XzmSOnO7kvMyl6p6N3bnwEbp9/c7MQ4+X9BZX5J18VK9RPcsafoDBjKQ93MjHgLpraz4l3jtWvuSPxhHdhW9uh+JVB16nXMsPGR9y2F4PhI5UDS3yql40FlmyVpjbfR4FJ7gif0OJpCWiZCPvYIH6QtNX+R5qlrs6qnkavVIrAI21GjlaHoJwL5B5O9+ss8lOGpH1yd42M5rEPwyCeC036Tw3OkOClk3BtGHL0E3EseqrYiPOllPZPZHOTs4LhRpmKX+LZ2JYC+ynydIgDIYVIW+xIvQ==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR16MB4245.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc1ab8b-4afc-441d-9928-08dd4ffec91c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2025 09:29:47.0458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1oZ8q4oMmaGawhl1jrQ0GP6OfOXCKSlk6DWEpbSnrs1NIS9RVggvCNfnOwXZE+sYe24aEfdOupf3ZpXMBSu7uNmnM2CqCTxG0IlfUokSb+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR16MB5034

RG9uZQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogQmVhbiBIdW8gPGh1b2Jl
YW5AZ21haWwuY29tPiANClNlbnQ6IE1vbmRheSwgRmVicnVhcnkgMTcsIDIwMjUgODo0MCBQTQ0K
VG86IEFydGh1ciBTaW1jaGFldiA8QXJ0aHVyLlNpbWNoYWV2QHNhbmRpc2suY29tPjsgbWFydGlu
LnBldGVyc2VuQG9yYWNsZS5jb20NCkNjOiBBdnJpIEFsdG1hbiA8QXZyaS5BbHRtYW5Ac2FuZGlz
ay5jb20+OyBBdmkgU2hjaGlzbG93c2tpIDxBdmkuU2hjaGlzbG93c2tpQHNhbmRpc2suY29tPjsg
YmVhbmh1b0BtaWNyb24uY29tOyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsgYnZhbmFzc2NoZUBhY20ub3JnDQpTdWJqZWN0OiBSZTogW1BB
VENIXSBzY3NpOiB1ZnM6IGNvcmU6IEZpeCBtZW1vcnkgY3Jhc2ggaW4gY2FzZSBhcnBtYiBjb21t
YW5kIGZhaWxlZA0KDQpPbiBNb24sIDIwMjUtMDItMTcgYXQgMTg6NDMgKzAyMDAsIEFydGh1ciBT
aW1jaGFldiB3cm90ZToNCj4gSW4gY2FzZSB0aGUgZGV2aWNlIGRvZXNuJ3Qgc3VwcG9ydCBhcnBt
YiwgdGhlIGtlcm5lbCBnZXQgbWVtb3J5IGNyYXNoIA0KPiBkdWUgdG8gY29weSB1c2VyIGRhdGEg
aW4gYnNnX3RyYW5zcG9ydF9zZ19pb19mbiBsZXZlbC4gU28gaW4gY2FzZSANCj4gdWZzaGNkX3Nl
bmRfYnNnX3VpY19jbWQgcmV0dXJuZWQgZXJyb3IsIGRvIG5vdCBjaGFuZ2UgdGhlIGpvYidzIA0K
PiByZXBseV9sZW4uDQo+IA0KPiBNZW1vcnkgY3Jhc2ggYmFja3RyYWNlOg0KPiAzLDEyOTAsNTMx
MTY2NDA1LC07dWZzaGNkIDAwMDA6MDA6MTIuNTogQVJQTUIgT1AgZmFpbGVkOiBlcnJvciBjb2Rl
IC0NCj4gMjINCg0KDQpJdCBpcyBBZHZhbmNlZCBSUE1CIGFjY2VzcyBhbmQgbm90IHJlbGF0ZWQg
dG8gdGhlIFVJQyBjb21tYW5kLMKgDQoNCklmIHRoZSBkZWl2Y2UgZGlkbid0IHN1cHBvcnQgYWR2
YW5jZWQgcnBtYiwgZ290IHJldHVybiAtRUlOVkFMKC0yMikuwqANCg0KSW4gdGhpcyBjYXNlLCBp
biBic2dfdHJhbnNwb3J0X3NnX2lvX2ZuLMKgDQoNCmlmIChqb2ItPnJlc3VsdCA8IDApIHsNCglq
b2ItPnJlcGx5X2xlbiA9IHNpemVvZih1MzIpOyANCg0KdGhlbjoNCg0KIGludCBsZW4gPSBtaW4o
aGRyLT5tYXhfcmVzcG9uc2VfbGVuLCBqb2ItPnJlcGx5X2xlbik7IA0KCWlmIChjb3B5X3RvX3Vz
ZXIodXB0cjY0KGhkci0+cmVzcG9uc2UpLCBqb2ItPnJlcGx5LCBsZW4pKQ0KDQoNCkl0IGxvb2tz
IGxpa2UgeW91IGRpZG4ndCBpbml0aWFsaXplIHRoZSBjb3JyZWN0IHJlc3BvbnNlIGJ1ZmZlciBm
cm9tIHVzZXIgc3BhY2UuDQoNCkNvdWxkIHlvdSByZXBocmFzZSB5b3VyIGNvbW1pdCBtZXNzYWdl
LCBhZGQgYSBGaXhlcyB0YWcsIGFuZCByZXN1Ym1pdD8NCg0KDQpLaW5kIHJlZ2FyZHMsDQpCZWFu
DQoNCg==
