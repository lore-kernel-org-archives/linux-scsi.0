Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871F222AE75;
	Thu, 10 Jul 2025 06:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752130182; cv=fail; b=rfJWI8tnVKYLLK32fsZ84PkF2k6MfQeS1UpFAxESsozkvcx3l9NtTdOZbKnORfZrqCoYZyKEbtqs9lol1OkvH43oGJHDkjNEs1hvWNyYvqd2YtSFsz8dl1CCldsD62fd4zq28OW/1ihFIZ+/3USXOIhYpRn+werpanbwvvaDlKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752130182; c=relaxed/simple;
	bh=PEaiyhkLR1iXBquuj5fT4ZM1TrL/CqYxcxoeK9huNNU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VWiJ+8yMpnqZ0eSBXLx5V+n9N9F6tDN1nxEoYqWndk1XEMI0I55t/P+LNsQ3Su5GnkiZb9Zr3107lILeMnyn+t+f+fhEI3Yh6vCMP1sg8EkIDe8cW/wmTe1sJuPUMaciBPbqrjJmXLmtpJZtvN6BRtVjBGc2LGPSzpKbAYYimCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=pBj/mwTL; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="pBj/mwTL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XssF0eL6tv5Sfe55J14XcsExFz4cy2DyuyRW1X/Vjaq4A5Vz4IDkeA96WtauQxkqvVJXsql7nf3P8aMp/tVPODATL2MZ0FFEOwozxf2zfb7f8xnVMvM04SXIgx8r0JKrHAQ0D8RHhOo+976sFqK0BGsjE/T60CPC/ecjhxh0iMn6N0chHi08rQrlZ636T36GrS6qL/VlkfKDcxOkTATzitaj/t+doSjow0BpdTxsLjfkzQUy0cNj9EE4XxPh32CohAtwFcSAMqzx/jZacQtfsqm+QSmHgHZrWdw9svLoiO0Ls5P29EijI3kBhq0BkMH1crH6F8FdcEY1i2jOBZ3u9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEaiyhkLR1iXBquuj5fT4ZM1TrL/CqYxcxoeK9huNNU=;
 b=HC11hHC7WcL8qxZ6TL/XqWULbd3f/m8e7XKB8C9UIMPfAkicR/MlMqdHnIPckwZfcLycAqMKkH+IsPSOcI6Oipsf8qe8HrT3k4t4aY9e+HbAJymav8YUUA0fFBvmmqkKP7jMJHflpJ2qsD3h3r7ldnFc9qNHcZmrREM6eilnUpdJc5nPi2qBgSc3Ag9DcV4xh8zfttUr5j+rGCixkyn6e34pt1JykTJbCyN7dd+Qij3xIeYJYMl/q+AgXHl18b1gv7/G9dyl9//3B0RCqFVJ/WYqEB1ZleYlRe3AtVL3OgzlhEofTmFOirTka1PoPcnt2nWnZ7mNeX1+8bV280SsOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEaiyhkLR1iXBquuj5fT4ZM1TrL/CqYxcxoeK9huNNU=;
 b=pBj/mwTLvp5w0Ph8GEuLeFweV3ANBjdJsyiY41BDfw/s0hF+11++KAGqSFXA+TVZh7e6Egru5PozLqq/09MxAU1ydTvVm7x7fbahYX63CwGyccUyq+6wQUGjAitvmZrp6B37+wNGwZApr9yS+ztVVYdfzG0MAYugnI0jwBndJrzoxKIV2oVOwzBqhmMLZ0jM4jblQKTLEqjMrDQYILOOsFqMfp0tqOes1fe217nkBDyATEvDsoRDzDPowvMg/N17oAxZ5OX2zMpKiYAC4/UgvxiUAUBsHRW3LldQoHiCbIV+04yn9dkfYVMVvO/mKs6OZ4/wfgzBOnIDMMhgBmEQxw==
Received: from PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8)
 by BN9PR11MB5275.namprd11.prod.outlook.com (2603:10b6:408:134::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Thu, 10 Jul
 2025 06:49:37 +0000
Received: from PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898]) by PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898%4]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 06:49:36 +0000
From: <Sagar.Biradar@microchip.com>
To: <john.g.garry@oracle.com>, <jmeneghi@redhat.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <aacraid@microsemi.com>, <corbet@lwn.net>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<thenzl@redhat.com>, <Scott.Benesh@microchip.com>, <Don.Brace@microchip.com>,
	<Tom.White@microchip.com>, <Abhinav.Kuchibhotla@microchip.com>,
	<mpatalan@redhat.com>, <Raja.VS@microchip.com>
Subject: RE: [PATCH v3] scsi: aacraid: Fix reply queue mapping to CPUs based
 on IRQ affinity
Thread-Topic: [PATCH v3] scsi: aacraid: Fix reply queue mapping to CPUs based
 on IRQ affinity
Thread-Index: AQHb4IardvPho7iCCkmONnezDl+aX7QKTdcAgCC9v3A=
Date: Thu, 10 Jul 2025 06:49:36 +0000
Message-ID:
 <PH7PR11MB75708E49B0C0714421E2812FFA48A@PH7PR11MB7570.namprd11.prod.outlook.com>
References: <20250618192427.3845724-1-jmeneghi@redhat.com>
 <682ff953-9130-4920-a9f2-88dfd6718be1@oracle.com>
In-Reply-To: <682ff953-9130-4920-a9f2-88dfd6718be1@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7570:EE_|BN9PR11MB5275:EE_
x-ms-office365-filtering-correlation-id: fe80869f-7cc6-44f7-22c8-08ddbf7def67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TlpzZ3dud05SZ0IxbG8yZ3VHMGVEQkd5V0RaeXNGUkpjUGFzNDVhc1YxczhP?=
 =?utf-8?B?NVh4bWxVTVR4SUJVVHVMTk5nd3YvYVJwSUxSOC9HdkY3WUUxSndMQmM3SVJh?=
 =?utf-8?B?amg3Wk0vOURYQ3R1R2lBZWdxd0ZVT1dvYW5HRmxmQWxvQnJJMERUYzlUSlVR?=
 =?utf-8?B?Z3FPVFl6Y3o2ajRhekY1amw5bklMVlZsRWpMbk9ld2l2L1U4aTluV1lLMVRO?=
 =?utf-8?B?ejZnMGFhMGVscHJrd21XdHQrcmhUNVIvSDc1ZVltWlNoTnBkYUtzaUJtRVQ3?=
 =?utf-8?B?aXduR2tRdXVHS2xnSm52Y2pZODBTdW94dlA5T1RKd0tqWXF0U0hPK3B2S1Fk?=
 =?utf-8?B?SzhPeXdRT1Z4WDVENW56c1R2eGd1RjF1azd5TXVnMXVCaW5VcWhmS3NBbk5L?=
 =?utf-8?B?Qlo0djdYc3BxNEdqdVZwNWlQM3EzL3MvcTE5LzBRMUREeUVMNGhXcUlkaGFa?=
 =?utf-8?B?eU5XejlZdm1jbzlvcnVTSDloV1dlcWlnbDdqZXh3QmI1V2t6VTY2MWZjTjNz?=
 =?utf-8?B?Ky9vQjRqQWZkRG5QS29nMCs2SnVpYXRORC9uUi9EUk5pNmR1YXlIemdHMjdS?=
 =?utf-8?B?c3gxZDB6Z3NoVnFtTDRjakkzR0szU3VYYnhMbWlpRWl6NTBMYjdDQmVnOFNE?=
 =?utf-8?B?TDZFLzZjSkJmMC9Tc1NpMEdUTU01Nk50eUU3d1VyU2dETVJGV2FVTHpLK05Y?=
 =?utf-8?B?UlkzSCtzTUh4WXh5ZlBPUkRISU4yU24wOW92bFMvWWFGT1Y2c2ZMTWtWUWFo?=
 =?utf-8?B?QkRFc2VNcXBxWCtZZmFKUGRGNkhYZmphT2lXeUplbGJKRGx5dk5MR3YrbjlT?=
 =?utf-8?B?eHRNWktSZjZSU0puUndtM01mNDJVZ1gxVW1HSnlRTUhpMXo5emdaT0xrUUFh?=
 =?utf-8?B?Ykk2OFR2Z1JOclFPVXNsMDFpK1d2elM4aXNYMk1XTzhDZ3Y5enZUYVJhWjNY?=
 =?utf-8?B?QmpUM01RT0hoaTNFamxHaFhwZnZwNDBFR2VRdHNvazFsbmM1VW9Zdm5JUFM1?=
 =?utf-8?B?eHFSL3ZQNXJ3T1pIUkNsRFF5UzZLTG1qQ2dtVHQ2TitZSjhRQjk0eitBYUdj?=
 =?utf-8?B?ci85ODJha2RSYzlLV2cxSDhvSExyRFA0L2gxTlYzdXI1b09VRU1QZWJNMEh5?=
 =?utf-8?B?d2I1L0ZaM08xb0VlMGNzeTE2S29BSGNsL2ZObGd0NUkwZ0t4U2RhUElxU1Qv?=
 =?utf-8?B?Tk8rRnJBOXpaL05rbHAxenEyeDUyNUpraFh5alVzblNPdjA3STB5OHdURFJZ?=
 =?utf-8?B?ZllxNzIrVjFHSGlBM1ZnbHgvbmZXQkc2a2JrN3IxQUZtTTFjVExsaitLdTlx?=
 =?utf-8?B?cmhDUUNnSnNlSlR6dThFYTZmYnYyZlIrMUNYZit3c2x3a25rWjZFQmNHZTY0?=
 =?utf-8?B?bFpWMXdJTGpPYzUreWU3L1lxV1JJUldKVzEydGpkL2JZTXRUL0JiRjZHV1Fw?=
 =?utf-8?B?MlV4RVVJNzJ3K000aG0vT3VTalBtWDZVb3l2a1IwSTVPb09DeGR4S2FFODBq?=
 =?utf-8?B?S3RZMzlqSHg4eUdRVkFOdWkrSDBqMlp6bkUwbCtUaDlWcC8wL3d0SStwcy9D?=
 =?utf-8?B?cFBER2xmOHlNZ2xIMWhxQ1I0S3ZQa2NGclNuMEo3OElZOFRJRml0Q3cvOENM?=
 =?utf-8?B?ZE5pd3dCR0s1NVBSUGdhUmN3MFFDTHVCMDhjM0tuckV3ZnNreExrOHpoQk56?=
 =?utf-8?B?MlZFbk4xUTFPSWNqWGlKQTl6UEpKMU15cFlHdVBSSHoyY2xBSTFNeGlmY001?=
 =?utf-8?B?Q3c2YTNUVFJqalhiNlRZYWpndFBlWXp0STJqWU9uT3hUOEJvdTkxQ2NtMFN1?=
 =?utf-8?B?cVgzSG82cVp4U0ppMVg1YWp2dEdFR3JMbjRxSUxuVUdHZERCMjNsS21qRndy?=
 =?utf-8?B?bElFWlFkbHdCTHFvQXVWL1kyeWFpVk5VVVk2Z3V0MXdZV3c5dTZpZFlqaTI5?=
 =?utf-8?B?QmR6UmltMG92UmpNZHROWjhlL2JKaXU4Wi9LcWZUa2hZZVFYZG1pNWhodnl6?=
 =?utf-8?B?VUM4eXoySDdnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7570.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K01lNHNMUmRhSUxpZGZQMGNueitpZjVPTWpFL0ZaanZ2cmtrMEg1WWkrMmhL?=
 =?utf-8?B?OU9ZRm9YczNJcHdad3IyYll0YS9FcE1SeGVtOTloL2ZucUQySHdSaXZZYlJH?=
 =?utf-8?B?UzlPdlBIb00xUUpadXUwU1pXOHh0dkZWTGFLODV3bFk3bFZDOUlmcW9hb0hU?=
 =?utf-8?B?YjZRRDdaY1pvTjZpd3JhUDZoM1hwNVg0VllVNjh0dHBnbk1KUGhHRFZxbDdh?=
 =?utf-8?B?Sk9wYUtKa0hLVk85QW10NThVbkZFWEhYYjFxUW0wVUFzV2dZdjFxQ1lXNTZ4?=
 =?utf-8?B?bGovWlN3ZWxaVW90WGdYU0ZUbStDVVZYeWRoaVJWOHdlcDZNZW0zcUI5Ry9R?=
 =?utf-8?B?RTY4dE9ocVZ1RDhJelNjNnIrZTNkWFpGRzJmODgrSW5UcXp6UUlqbTJEMkpp?=
 =?utf-8?B?bndtWjlkUlNqN1ZDa2xBNXNybkNQYjF5MDVGZWREdWxaR1ZNbUF1dWt0MGYy?=
 =?utf-8?B?MDM0NjJ5MHZ6aU85VmpwRTZmN2FUVEFQcmFSZjQzZXc2WW5UTE9RK0dVS3Zs?=
 =?utf-8?B?eWhWbUdmUkxZOEZEcUtsVWhablhVK2JyZ0xOY05rNkRFRjY1UzVhRlpCUWNP?=
 =?utf-8?B?QWNMeU5iUExDTE1aYUxVNWg1MVZ1MnpEMmZ1a091ZjQrdnFrVm5tQ0x2djJz?=
 =?utf-8?B?bGY2RFVNYlJ5Yks4bGVvTy9jNUl5Y1pyYUZkT3c0M0t3MVAzc0FvVDV3ZjZK?=
 =?utf-8?B?amk4UldlcjdoSHM5SFk3dHRnamVYdklmNXpIRnNyNW1ueDhTekJyQ1dOOG8v?=
 =?utf-8?B?R2dURUdxOUZNT0hGUkMxc2VObkJ0WmRnMlFvYlRqTGFNR3FtVlJSQjk3czRr?=
 =?utf-8?B?b3dnSkZteGFFQ2pTR0xxaXFZTmh2Q1pvOVJ4emplaVV5SXVWMjYyQVZsYWtt?=
 =?utf-8?B?TjFlK0JTRmQ1LzUwYjJ1b0MvS3dxdmxGMHQrcytlVjhmUlYwVEVIdEgxeVEv?=
 =?utf-8?B?T0pvWlcyeis5QjJRcWJ1Um1qbXpMOWlvUC8yTUlQaFdXZkJ5eGNXZGhvdnJm?=
 =?utf-8?B?dVJtZDRDOU5DWTRDQWpCa1pOcVNqL1NHYXVqV2tFUm9ubUdmR3JFcjBRUk03?=
 =?utf-8?B?TWRGZUIyWUx0RjlPZzlYV0tPME1zY2dTaFhiUnc2VXVLN2NJSG01ZHdRbmJT?=
 =?utf-8?B?L21lSnJxUVd2aFN3UUpVSUJYMGphMFpvVHVPK1p2L2NjZ1lkbXdESU1heXl4?=
 =?utf-8?B?aTN0U0pLMVo1M1p6cVZVT2NpM1B5SWkwYTc1RmtyZHcxanZpZ1NZVFB0M1dp?=
 =?utf-8?B?MkZxWEkyVDlnUTJZbEdZUWtacjJ1QmFtYkxkSHJvSDRTZG41a1lzZzZJNlFy?=
 =?utf-8?B?cWlxZmVsMWVGS2drSStxWVc2VzVPd2dUNnhxMXVSay9aT1lteHFJSWd0dWQw?=
 =?utf-8?B?RFJKcUFkbFFyZFQxVGNVS3V0bUNIeWl1RGhTNElIU2JPNW1IcnRFY3Q0M3kv?=
 =?utf-8?B?NkdNUVlsS0oxL3krUjNtaElvbDhDZDc1UnhYNW9MRXZsYjEvREpCT2FpeFQx?=
 =?utf-8?B?Mnl5UjVMNTVSRDAySmRMbzhteUc3ZEJGRWVDZ3c3ZU5SSXkwTGxSc2NMRGtW?=
 =?utf-8?B?UUovN3FoMk9icm9CcENlMFhNVEd6cXdIdTNKQWV3T080VUNlYWlCVC9LVHAy?=
 =?utf-8?B?bGwvVXhSRXFwVEFoTSsxdDhUQXJxY3diVi9IUGpRaHcvSHc2ZHlQZkphaFcr?=
 =?utf-8?B?SlJJVkt5dmRtRlduVUxxY2hHU3AwRFIyUFZaODRlUFhSTTIxdGhxWWJmU2Ux?=
 =?utf-8?B?Q0h4UVBIZWJPa0R6Ui9zcTZ0YzU3a2RFV1VFSjlsTXo4aVY0K05xUkJTb1VC?=
 =?utf-8?B?M3MrV0JtaEJJcEZ0MkNuNjE5ZmZDUmVUd3FydXBFRE5HZzQ3Z3J5UXlMbHFT?=
 =?utf-8?B?dXdQZHFOY2kybjREbkZMODEwakt4NjQwb0diMVJuNjNkcVNEWDlJbldadkNG?=
 =?utf-8?B?YUV1OU5iNS9VQWJKaGFsTFZ6ajhQRklUNmxMc0R5L1V2NE0xdU13UVhOMEp4?=
 =?utf-8?B?c0lwczZUQkNYOUxNYzlEeFkxb2JoKzhEUTBDbHRaam9ZNlFsNjlobWFDb2tR?=
 =?utf-8?B?QVBLOFlObEpEY0JaZzU5djY1a2d3cXFmOWkwYVAxa0E0NnNoYlNQemtKY2pE?=
 =?utf-8?B?a3VsS2dqdUIra2dGOFEvdW9GTzdwNTY2OGNGcUdJSHlmQ1prL1dPcUlIU3g1?=
 =?utf-8?B?OGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7570.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe80869f-7cc6-44f7-22c8-08ddbf7def67
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 06:49:36.4739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: USFTciWX9qfDtbE9xjzslM5r1frOu1Jl8i1pH8ceuNO3+eNDPUP+GqhOtKzarH7FZdP4pmtRtuPdxLrXP2MAVqzGkn1TrHdt5Tz7HUfttUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5275

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBHYXJyeSA8am9o
bi5nLmdhcnJ5QG9yYWNsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDE5LCAyMDI1IDM6
NDcgQU0NCj4gVG86IEpvaG4gTWVuZWdoaW5pIDxqbWVuZWdoaUByZWRoYXQuY29tPjsNCj4gSmFt
ZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbTsgbWFydGluLnBldGVyc2VuQG9yYWNs
ZS5jb207DQo+IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBhYWNyYWlkQG1pY3Jvc2VtaS5j
b207IGNvcmJldEBsd24ubmV0DQo+IENjOiBsaW51eC1kb2NAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiB0aGVuemxAcmVkaGF0LmNvbTsgU2NvdHQgQmVu
ZXNoIC0gQzMzNzAzIDxTY290dC5CZW5lc2hAbWljcm9jaGlwLmNvbT47DQo+IERvbiBCcmFjZSAt
IEMzMzcwNiA8RG9uLkJyYWNlQG1pY3JvY2hpcC5jb20+OyBUb20gV2hpdGUgLSBDMzM1MDMNCj4g
PFRvbS5XaGl0ZUBtaWNyb2NoaXAuY29tPjsgQWJoaW5hdiBLdWNoaWJob3RsYSAtIEM3MDMyMg0K
PiA8QWJoaW5hdi5LdWNoaWJob3RsYUBtaWNyb2NoaXAuY29tPjsgU2FnYXIgQmlyYWRhciAtIEMz
NDI0OQ0KPiA8U2FnYXIuQmlyYWRhckBtaWNyb2NoaXAuY29tPjsgbXBhdGFsYW5AcmVkaGF0LmNv
bQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYzXSBzY3NpOiBhYWNyYWlkOiBGaXggcmVwbHkgcXVl
dWUgbWFwcGluZyB0byBDUFVzIGJhc2VkDQo+IG9uIElSUSBhZmZpbml0eQ0KPiANCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUNCj4gY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiAxOC8wNi8yMDI1IDIwOjI0
LCBKb2huIE1lbmVnaGluaSB3cm90ZToNCj4gPiBGcm9tOiBTYWdhciBCaXJhZGFyIDxzYWdhci5i
aXJhZGFyQG1pY3JvY2hpcC5jb20+DQo+ID4NCj4gPiBGcm9tOiBTYWdhciBCaXJhZGFyIDxzYWdh
ci5iaXJhZGFyQG1pY3JvY2hpcC5jb20+DQo+ID4NCj4gPiBUaGlzIHBhdGNoIGZpeGVzIGEgYnVn
IGluIHRoZSBvcmlnaW5hbCBwYXRoIHRoYXQgY2F1c2VkIEkvTyBoYW5ncy4gVGhlDQo+ID4gSS9P
IGhhbmdzIHdlcmUgYmVjYXVzZSBvZiBhbiBNU0l4IHZlY3RvciBub3QgaGF2aW5nIGEgbWFwcGVk
IG9ubGluZSBDUFUNCj4gPiB1cG9uIHJlY2VpdmluZyBjb21wbGV0aW9uLg0KPiA+DQo+ID4gVGhp
cyBwYXRjaCBlbmFibGVzIE11bHRpLVEgc3VwcG9ydCBpbiB0aGUgYWFjcmlhZCBkcml2ZXIuIE11
bHRpLVEgc3VwcG9ydA0KPiA+IGluIHRoZSBkcml2ZXIgaXMgbmVlZGVkIHRvIHN1cHBvcnQgQ1BV
IG9mZmxpbmluZy4NCj4gDQo+IEkgYXNzdW1lIHRoYXQgeW91IG1lYW4gInNhZmUiIENQVSBvZmZs
aW5pbmcuDQo+IA0KPiBJdCBzZWVtcyB0byBtZSB0aGF0IGluIGFsbCBjYXNlcyB3ZSB1c2UgcXVl
dWUgaW50ZXJydXB0IGFmZmluaXR5DQo+IHNwcmVhZGluZyBhbmQgbWFuYWdlZCBpbnRlcnJ1cHRz
IGZvciBNU0lYLCByaWdodD8NCj4gDQo+IFNlZSBhYWNfZGVmaW5lX2ludF9tb2RlKCkgLT4gcGNp
X2FsbG9jX2lycV92ZWN0b3JzKC4uLiwgUENJX0lSUV9NU0lYIHwNCj4gUENJX0lSUV9BRkZJTklU
WSk7DQo+IA0KPiBCdXQgdGhlbiBmb3IgdGhpcyBub24tIE11bHRpLVEgc3VwcG9ydCwgdGhlIHF1
ZXVlIHNlZW1zIHRvIGJlIGNob3Nlbg0KPiBiYXNlZCBvbiBhIHJvdW5kLXJvYmluIGFwcHJvYWNo
IGluIHRoZSBkcml2ZXIuIFRoYXQgcm91bmQtcm9iaW4gY29tZXMNCj4gZnJvbSBob3cgZmliLnZl
Y3Rvcl9ubyBpcyBhc3NpZ25lZCBpbiBhYWNfZmliX3ZlY3Rvcl9hc3NpZ24oKS4gSWYgdGhpcw0K
PiBpcyB0aGUgY2FzZSwgdGhlbiB3aHkgYXJlIG1hbmFnZWQgaW50ZXJydXB0cyBiZWluZyB1c2Vk
IGZvciB0aGlzIG5vbi0NCj4gTXVsdGktUSBzdXBwb3J0IGF0IGFsbD8NCj4gDQo+IEkgbWF5IGJl
IHdyb25nIGFib3V0IHRoaXMuIFRoYXQgZHJpdmVyIGlzIGhhcmQgdG8gdW5kZXJzdGFuZCB3aXRo
IHNvDQo+IG1hbnkga25vYnMuDQo+IA0KDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHJhaXNp
bmcgdGhpcyDigJQgeW91J3JlIHJpZ2h0IHRoYXQgdXNpbmcgUENJX0lSUV9BRkZJTklUWSBpbiBu
b24tTXVsdGlRIG1vZGUgZG9lc27igJl0IG9mZmVyIHJlYWwgdmFsdWUsIHNpbmNlIHRoZSBkcml2
ZXIgZG9lc27igJl0IHV0aWxpemUgdGhlIGFmZmluaXR5IG1hcHBpbmcuDQpUaGF0IHNhaWQsIHRo
ZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGlzIGZ1bmN0aW9uYWxseSBjb3JyZWN0IGFuZCBjb25z
aXN0ZW50IHdpdGggdGhlIGRyaXZlcuKAmXMgaGlzdG9yaWNhbCBiZWhhdmlvci4gDQpUbyBrZWVw
IHRoZSBwYXRjaCBmb2N1c2VkIGFuZCBhdm9pZCBzY29wZSBjcmVlcCwgSeKAmWQgcHJlZmVyIHRv
IGxlYXZlIHRoZSBhZmZpbml0eSBmbGFnIGxvZ2ljIGFzIGlzIGZvciBub3cuDQoNCknigJlkIGJl
IGhhcHB5IHRvIGZvbGxvdyB1cCB3aXRoIGEgc21hbGwgY2xlYW51cCBwYXRjaCwgc29tZXRpbWUg
aW4gZnV0dXJlLCB0byBpbXByb3ZlIHRoaXMgaWYgeW91IHRoaW5rIGl0IHdvdWxkIGhlbHAuDQoN
ClRoYW5rcw0K
