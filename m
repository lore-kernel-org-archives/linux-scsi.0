Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE8818AE2;
	Wed, 22 Jan 2025 11:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737543858; cv=fail; b=gFruQDSZHSKrKGx85cklvq/r+/qFAy7KGgHwSz1QY/FViyCEweOT4irKebN69CHtq7hiTXBKXeeQ5Mry10lbaMB9pgGaTQfZ3CSISc3kINGnsXJrDOPFRtR/q7oA2ELDMz5ZL5CATLH5Jvlt0iyhggL7dKPphmhm3ESE4ZQlkrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737543858; c=relaxed/simple;
	bh=0MPYGlLSMwfml0f4nGfSz3DWi0ySRSvIG4N0QVN7KNI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=daZ7R3GPWU5v4/R5QieOy49wl4v9s3w3S1SlSJhkaZ5CcboUqajtmbK9n9nD/u8maa8aRF1jH7iCc6o/FIr4E/dvbB5tsUoRv1S0ZrETuJo7Se2qIa5DZvtdD4nZyCXnbqahu6BVz8VNOpLx2MtI4DSU5+6BBCTtqyOB/VwDJMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hqChM/84; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TU7iE5cr; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hqChM/84";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TU7iE5cr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737543856; x=1769079856;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0MPYGlLSMwfml0f4nGfSz3DWi0ySRSvIG4N0QVN7KNI=;
  b=hqChM/847yi2wA+j+gxBpcdrkPuBUV1rgJQZiUct17oCZz9j2kXt4S8c
   KkpNieRyGX6uhhITqiTkBbAyEldClJV2SeRCXtTYFYO2sKh+QF7e3viQN
   PrIYXLJLlO80y2lyW8Wrg85aV3/yCDdaJsCvdVmmTS99ytdp0RvVzTvf7
   Ki34ozXAwuH9MwbCna8xWsTX/XuKu0o/MDhryeevlDHaHg2V/4jlLMGTO
   TEvB90sZbrJiN0ezhnoEqmd2MURCqDdpshvGHCzI3xdOBCTD9cW7wLBQ2
   eogN6UxbKXy3mSuaPsdAMoL4zkQD3cfQgaJi83n+csErIIUj7CTsPSS/X
   A==;
X-CSE-ConnectionGUID: i0vElZW2T1GW8kX1EwuGFw==
X-CSE-MsgGUID: TWKsm2xNSkqNb5uc3Eba4Q==
X-IronPort-AV: E=Sophos;i="6.13,225,1732550400"; 
   d="scan'208";a="37538535"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2025 19:04:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BzfJRnobdjCrtAb8k0W0SpchrdkdmvcMRZ7IUZyK7JWGTeMe9vjJK42QOiUl3Fv6Tlx8PhBnxsPjye27NPhAu9nyE/e5qMIu7BIUgUghWR+SnTzZxE8ODzhFaMA02fTh3OZzs0UQgJ2YwnFKHq08msASV0nDN6AZgn6dWk2gEJu5oGfabfGOI5L15QgdtdTHoV0ODHvGOoWsaqFYAMMDlcXbdnTgOEMGoqsfx2OdKPf1N2RWZF20GwKBb6ICxpyARuTgYeEHtHqQHQMz4cIU6ZO6QqfMoWvwO0dJVRe+qxfUrrV+B4lqjoSc4BFzyWQ4YW1LVFozXeB7Pq1b0Gtd2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MPYGlLSMwfml0f4nGfSz3DWi0ySRSvIG4N0QVN7KNI=;
 b=UBUHweVT1o5yK806AYfbSM6YNiSbTYuGnYY1w1V9Pc+C8idv3FC2Wz1dvNTNF68O6Enp/FFtsVGSNk++oAVJDALQBo+DRvf2Pvbxx4S7QspXxOA+9ZEeECSumhwfmTrekrFpxh2I1bAc+3DVZ/ZVMh/66lM3Ceqz7aoXH9CsyFdJtuhJ/pdT4w9J/2XvIuqHtOQIszaMH44vfZeXMpWlKxvkApVeck9vCG8b/fMc0i8AjhrldwoIf4CHkTVtw62oSNWNzca3+QdCtgL15szMOqDHpduJIy0gOBnZw4oFNugsRLrBJq/jX2iLVNIxY442IlzNXreqvSwMR/t/9DqnJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MPYGlLSMwfml0f4nGfSz3DWi0ySRSvIG4N0QVN7KNI=;
 b=TU7iE5crXsdcDcT0QoHkdZj/BrkzUE/la942SefJkDb22zoriBxSoIAzAwnHCnzJkx7eI4TMMO5r7Hu/4YtgySYthVbxm8kp6u7Dm/FEv6ejjn/V1FD8YJ/Y6faJ7wXIdIlAozn8M+GjuSchmBfBZhvL0R9THRm8YX7SXpo8D0A=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by BY1PR04MB9660.namprd04.prod.outlook.com (2603:10b6:a03:5af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 11:04:12 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%5]) with mapi id 15.20.8356.020; Wed, 22 Jan 2025
 11:04:12 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: RE: [PATCH] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Thread-Topic: [PATCH] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Thread-Index: AQHbbJcgG4YGDg9HUEa2rPQTDp+F4LMicxkAgAApyrA=
Date: Wed, 22 Jan 2025 11:04:12 +0000
Message-ID:
 <BL0PR04MB6564A6B239E652983AC5A878FCE12@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20250122062718.3736823-1-avri.altman@wdc.com>
 <20250122081756.hehvpcbyl2nd3yvf@thinkpad>
In-Reply-To: <20250122081756.hehvpcbyl2nd3yvf@thinkpad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|BY1PR04MB9660:EE_
x-ms-office365-filtering-correlation-id: 1e121742-ed36-47ef-73ed-08dd3ad480ab
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZTd5a3BkWkNobzJya2RKZ25LaDNWTTJidnlyRFNvZEsrNjFWNGIzdXNhNm9F?=
 =?utf-8?B?aWxud3RxUmJXWVNPY2pOcnM1UXM1anRDRXdYNENWNjBydzhUUW5DZVBPZkRj?=
 =?utf-8?B?dWhQNGtkZDJGUzlLeE1Ja1lLTlFza3RWS3Yxc3c4RnBtTEMxakd5K2U5ZFRz?=
 =?utf-8?B?eG1ZQmFtRThMYTUvN3UyeUhYK2h6RCt4SjdGT1pmWnE2dHZlMEppZDZya2VS?=
 =?utf-8?B?aE51NWtWOWhGT2FSUmtXRkdpZGMxNTZ3WlIxeDhNVWF3NE5UUlJyV21zemth?=
 =?utf-8?B?WmxYZzNjU3dqaWNXcjNRM0VSV1ptNVNydEpvZWJwTXptdFd3bDVxUldEdW5z?=
 =?utf-8?B?Y2JhZEhqbk8wcnh6R1doeXV2SGxEc0Rqa0JrcFJkd1I5MGVZdkpxNTIzWlZk?=
 =?utf-8?B?ZlNQcGdFWTVsWWVnU3dWYm9uYkx5MDZkREg0aERia0FEdmFyVWR6Q1hDNGlL?=
 =?utf-8?B?VWVuZXpYLzBWVEh2dWhjbStCekJzczZsRlRWVXNJc3FkOTdrQlhjMytISitx?=
 =?utf-8?B?MUszRUNOWTlIUFBlNDhzNWVCOFlRN05RcS9Xc1FJbEZnd3Eya1BOQzkxZXBN?=
 =?utf-8?B?YlczLzZwSWpqRWxjSzU1d3RFWCtqZFVmZnlSY293U2RmTHZWdWo1TlhyUm91?=
 =?utf-8?B?VmY0RTZYVWNEQXNxN1hTa3ZnY0o3TnY0Nm9mWC9NdEo4bXFMZXBhSjFYajNQ?=
 =?utf-8?B?WXMvRkpDN3Z6blZBSTQyYTZETEIwSHkwb0xCTDhaNCt6Z1lqOVNDdVkvSzVP?=
 =?utf-8?B?cDFla2ZabUJrRzlNK0g2OFJpSkFhUkZBL2N3dUo3TkV3YTRXYVdVNVhuaHdw?=
 =?utf-8?B?R2RCSWRRQUFUd3hRczREK2JPZTdXZXkrOUpxZ0xZNUFEaVFnTjdZZWRuTFJy?=
 =?utf-8?B?N0RFazM4c2FKSHQrNUU4c25lVS84MjZ4Nm9ZaGlXUFZDOWx3WHNtSXFqZVN3?=
 =?utf-8?B?SDc2alR6Ry9xRVJtU2VUYm1nWTBVbzY0akhXV2tVdDI2MzIzV0VGcUVaWGdZ?=
 =?utf-8?B?VVZGdTZ2aWJZcEk1VTd2bmw5SkdGak5nM2U1VjZjWXNvYXpad1JTWFA3SWd5?=
 =?utf-8?B?N240ZmJhQmRUam1DVWpvamNKbWxsb2lmRWhiaDVmOGIzRm9XcG5qQWplcDNC?=
 =?utf-8?B?eW1LNzYxS3M2YmR0eEZHUmxkbHBiWFBQZTFuRWtWRmsvYzRaeWhzYVFZNWY3?=
 =?utf-8?B?bEJuTGNPYktzVEgzZXR2bmRZeXo5eCtaVklLT2lBZzVUVWtCRVdqeTZLbTVE?=
 =?utf-8?B?NkhYS3oybDgwT0hFdnVXWUVMRXNNRFhuOHlFNExvTm5VU0dWMVJKZXBpN1pu?=
 =?utf-8?B?WHNza2loYnhzWGZ3TUNYbnBUdDNOWmZVOXQ5eElUeWlMdHRJdUQrU2ZUN1Fu?=
 =?utf-8?B?cG5BK0JmWFhNZUlTM05zcnVNaUo5MWpCYURiRi9QN0RVSkFabG1hTjBxTmEx?=
 =?utf-8?B?QzR1TkdvMzE2YTVMNFhxTDY2cXJ0WG5ZcVlNSVREOEJOR3hERlU4ejRoZlIz?=
 =?utf-8?B?YThRYmtiLzN0NGF1MkJkbUNMMDNpc01UTjc5TityZFpRZ0VGMDFEMURMNU9Z?=
 =?utf-8?B?eHhEemMxbDYxMXFiWDBCZTc2STdpbzdRUkxXL09XajdLby9WQXVwbFI3Rm5k?=
 =?utf-8?B?WkNHV1ZRdDIwVGVGU24rVWp3dm9tdVNIN2NjRlZTWHQ3d3dsL2prZTU3YkFh?=
 =?utf-8?B?TnQ2QWNtWklCeFY2ME42S1AyN20wZ0phbHo3ZG9WV2JKZWJ1L0wxMmhlWUFT?=
 =?utf-8?B?bTJJcThkL3o4WnY0MTZvMTdKaGs1VFU1UitjRlRmSXpIdHRTQzJVbGdSTEpr?=
 =?utf-8?B?a0w0Z2pkTG9XM0d4bHpBT3ZMRnJSeGQ5Ni9SdjZwb1RvNnUwanVIRHhDR2hK?=
 =?utf-8?B?UldNVmlhdjlCUjlJNC91VDBzOVJEVlV6NVB4ZXRjcitsbjhxejlrd1pJVkEx?=
 =?utf-8?Q?HzmcgNn+hdE2fuFoHAcBRsUm3LzCOC50?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aUhFRHc0MXZTK0dxeVh0QldiRWREK2dvMXpWaldPUUV2bmxwYjNwcjF6Y0xu?=
 =?utf-8?B?S2RZd1NocVJ5SUFBM3p1ZllXeC9sQzkxTEZKbGZBcjhzRHRCS1plZ0RMM3RL?=
 =?utf-8?B?OXdWZ242S1ZBVTcwMCt1dEFqR2dhZHVHTUkyditsMVFFc1p5czVsajdGaTFJ?=
 =?utf-8?B?RXZhdDRMaEN4SFZtU3NMVDZlY21lZGc4d09QemNqNy9KNWZZemZxMjhWNFdl?=
 =?utf-8?B?SDZRbkJ2SkMxeGpLV3NCanFITGJZWGRqOGNQb2ZqM29vcXE3WXorNWZHSXdU?=
 =?utf-8?B?dktpQWFMK0ZKcUprdVdzT0d5OGFsRDh6VzAwNnNUM3NqYm5OdDRaazh2SzNC?=
 =?utf-8?B?L05BWFJRV08vWXBCeGFPTzdaSExuY2xKbDA5Y0tqc1EzVXpIYVhqUU5rV3FZ?=
 =?utf-8?B?ZTFkdEpVWjdNMGw4Tk02b0hrKzdZcHFDK3hQNi8xK1l6R2pLWGRZcGZEaEls?=
 =?utf-8?B?aHVIT2t6b3A5YVhCQVRzRTRXakkxb2tWN1ZTWXcxVzRtYmJzTEVtY05IRGt0?=
 =?utf-8?B?WFBmaVM2TXQzOVRoQnltaEp2ZWdIVDA5T2Rmak1ucHBhQXhGa0pkTEZUNCtP?=
 =?utf-8?B?THlIbTcvUEVXT1BKU3huSUdkL3FIMWhDek9xQU5ZVS9kVWQrYUpTOFhUYzZr?=
 =?utf-8?B?YnVTQ2RObHpjZGtZa3h2UEZtWWVGS0lJdFdyYW1vQU5GUDhEYkdtMWJ2UG15?=
 =?utf-8?B?clBuS2RwWitUZm5KYjNISThYZVpXRFBlOU1aUGVVdUFKZXJMcTlacFFHdjgw?=
 =?utf-8?B?dytvZ09PdENXSi8zcjNmUHBiZjIxVUFlSUV0emd3Qmw4cmN5ODhKT2ZkZ3l6?=
 =?utf-8?B?aVlEd3dESXRQUDR1UzZ4S0d5eTVienlSK1NheXdzT1oyUm9EeU8yYXFuSW1F?=
 =?utf-8?B?MGNlZ0JKT0FBaTdWcndEV2FhMHErVlNBalRnS1VTQW9hSStFMU40dm4zb09o?=
 =?utf-8?B?ZzRzS2FDL3pZYytIazRzcjc2anFJWm5oUlcyemQ1b0U0N0ViY2VZZEZ4Z1E2?=
 =?utf-8?B?SWMyOUFscHR2bkNSQWtucWp3NkF3Mkg4T25LR29qb2Yzd1luRFRjalJqdkU3?=
 =?utf-8?B?dkIxSWp3WW1IN2N2Q0wrSmkxNE9IWGU4KzEyUDNPK2dzOEx5aVFmbnBsOVZ0?=
 =?utf-8?B?eU8wUGhyTS9QRDczWkpWVThsbFZQTHprbG9WT20wMWgxUnJ2eXA0S0tPcDVr?=
 =?utf-8?B?RlNhdXU4ZUxaem5lVlhPWnlaZUxXQm1qaDNnaS9JY0ZPY2hCS2JvQ0RqL1p5?=
 =?utf-8?B?N2NyVEFMVSt1M3dDYTQrRjlEazZJR2NEMmMxeGZCdlpUNjRyaTh5UnpzN2Vq?=
 =?utf-8?B?ZWhDaGVpV0RWaGRGUTRWMHFJRm9lUWMzQWo4b2E4UTgzSnNRbVdyVERyNVpU?=
 =?utf-8?B?RndNK2VrYlovQW5lQlM0Wll2Y3JYVjB2SGluQ1R5dTRQb3MvcHV3aStuOXBk?=
 =?utf-8?B?UG9YQnk2ZlBkdStSTE9oUXF5ejY4VDBDVnVQbkd5a2REMkdJVDJCWksvWXpP?=
 =?utf-8?B?SVZmQUcvR1p2Z2VqRUFjNlBBQnhyUEtUVkgwM0ZNZEZhRkpTbEtlNUh2WFYr?=
 =?utf-8?B?aUdIWWU4Q0kwbkR3WEE0VFlKNWV4TElMMWNYb2tLUkNTeXB5L0VmMkVtTXJu?=
 =?utf-8?B?ZFBiR2NSZ2sxODladCtIamtOMmxxRTBrRlROOXhYMlg4b005eWlkdHV4cTlp?=
 =?utf-8?B?TkRjQk5PcjNkTGZoczJzb3pzOGpQZGJmbFpxQWpGL0VHOWovdDJ1NDA3Q3F2?=
 =?utf-8?B?TUpGNUhYQ3pnOE1aUXEvTTJYdXJDS1EyK0M0WTZlNlZ4NWVvb0liOWtaNkNY?=
 =?utf-8?B?QXdHbkZxQXlCa21pUE40K3AxMHFHRXZqWHBmMEhwWm8zcWNvNHFhUDFzaTNI?=
 =?utf-8?B?dmZzMGZhVXhQcHcxT1hFblovUVoxb3ZWTzVOdURoQVZiNW1sRmU2aWx6UWlW?=
 =?utf-8?B?bDAybndXeGtGc3RFbFNnVGU3UWhNd0VKcWR0OWU0UUlsd1kxbjhTN1puWDhI?=
 =?utf-8?B?UTBlcXM1Qm1SOUFUMWVjbDRNM2pXZnA3MitpYzVWYWVJUzYzdjhKcUV4elds?=
 =?utf-8?B?YzBKdkJROU5Ub2FkOW9nZFJtOWhJVHdlSnV4NlAzcjZJQ2d0dHovWlArUFBX?=
 =?utf-8?Q?xDk2BgQr3mU6PfgfF88o0xzTo?=
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
	t9X0LhIuyWo1B73Yj8NciRVoVSSlxUcSM4W0PuFFJhnabATtlu0WtesZZ3+f6uZBPXH58+bISDgp24kZo7u1zKH2e6witHsPSTKoUT01jUQ5Gb0fwkm1VCLPrass7IdJ4Ez8pR1T2xevbwx3C4DI66vrWaIOo/+b7firX/KhQrFuoIbLYDsYqxCT3+hKvosTSNmkip+8WvV7H8EFcaSIawLFJqIa1ZzY7SioiO+Bg82jV1ak1LyHPxauG+uL3BtzTVyYL/2v32vymZWGdHzkza9zv7oKQaMAQpAOzyhcQ0r8ExyCcRTLkgBvsv1ArpVSoDRVVykONo0ov0N4EpBsiwZS/7IEpIPgTFVcmVv9RFBzs7ZagJpK6d1N+BZZP55EkzhNoY/v37s2AhWgKMTazzGd82kuRKXH7TGwtBOg9qo7ksl7WvtGHRbcXLHvE4gRp7HEYriizORLjLpyHZ6Zvq8LnpOU9vaDuxUp1MNQEprdDPVjoeZz5V13cUU8sOfcN4/99PCDOnAW8Ny8OHAcb6/Rffb3oXVkSIhCSOYZCOFE9ghp61FKV9wcLiOU/RZywlUnKL7K54R7Ta8A5c8OSAD0S7F9uwVKixgd852skwUli7pYVJd4unzDsQCgflw7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e121742-ed36-47ef-73ed-08dd3ad480ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2025 11:04:12.2412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OKusPVbvmaYOo3pUc3YVes6/hMmWDZqIJfp1ZudZwA9Ox+irkpAdimkHIkDXqSzpoqRSjyCnZjaJWZElnl4IZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9660

PiA+IFRvIGZpeCB0aGlzIGlzc3VlLCB3ZSB1c2UgdGhlIGV4aXN0aW5nIGBpc19pbml0aWFsaXpl
ZGAgZmxhZyBpbiB0aGUNCj4gPiBgY2xrX2dhdGluZ2Agc3RydWN0dXJlIHRvIGVuc3VyZSB0aGF0
IHRoZSBzcGlubG9jayBpcyBvbmx5IHVzZWQgYWZ0ZXINCj4gPiBpdCBoYXMgYmVlbiBwcm9wZXJs
eSBpbml0aWFsaXplZC4gV2UgY2hlY2sgdGhpcyBmbGFnIGJlZm9yZSB1c2luZyB0aGUNCj4gPiBz
cGlubG9jayBpbiB0aGUgYHVmc2hjZF9zZXR1cF9jbG9ja3NgIGZ1bmN0aW9uLg0KPiA+DQo+ID4g
SXQgd2FzIGluY29ycmVjdCBpbiB0aGUgZmlyc3QgcGxhY2UgdG8gY2FsbCBgc2V0dXBfY2xvY2tz
KClgIGJlZm9yZQ0KPiA+IGB1ZnNoY2RfaW5pdF9jbGtfZ2F0aW5nKClgLCBhbmQgdGhlIGludHJv
ZHVjdGlvbiBvZiB0aGUgbmV3IGxvY2sNCj4gPiB1bm1hc2tlZCB0aGlzIGJ1Zy4NCj4gDQo+IElm
IGNhbGxpbmcgc2V0dXBfY2xvY2tzKCkgYmVmb3JlIHVmc2hjZF9pbml0X2Nsa19nYXRpbmcoKSBp
cyBpbmNvcnJlY3QsIHdoeSBhcmUNCj4geW91IG5vdCByZW9yZGVyaW5nIGl0Pw0KPiANCj4gQ2hl
Y2tpbmcgZm9yICdjbGtfZ2F0aW5nLmlzX2luaXRpYWxpemVkJyBsb29rcyBsaWtlIGEgaGFjay4N
CkFjdHVhbGx5ICdjbGtfZ2F0aW5nLmlzX2luaXRpYWxpemVkJyBzZWVtcyBsaWtlIHRoZSBzdGFu
ZGFyZCB3YXkgdG8gZG8gdGhpcyAtIHNlZSBlLmcuIGluIGhvbGQgYW5kIHJlbGVhc2UuDQpBcyBm
b3IgbW92aW5nIHNldHVwX2Nsb2NrcygpIGFyb3VuZCwgSSBoYXZlIHNvbWUgY29uY2VybnMgYWJv
dXQgbW92aW5nIGl0IG91dCBvZiB1ZnNoY2RfaGJhX2luaXQuDQpIYXZpbmcgY29uc2lkZXJlZCB0
aGUgYWx0ZXJuYXRpdmVzLCBpdCBzZWVtcyB0aGF0IHVzaW5nICdjbGtfZ2F0aW5nLmlzX2luaXRp
YWxpemVkJyAsDQpkZXNwaXRlIGl0cyBsaW1pdGF0aW9ucywgaXMgdGhlIG1vc3QgcHJhY3RpY2Fs
IHNvbHV0aW9uIHdlIGhhdmUuDQoNCkkgYW0gb3BlbiB0aG91Z2ggZm9yIG90aGVyIHN1Z2dlc3Rp
b25zLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IC0gTWFuaQ0KPiANCj4gPg0KPiA+IEZpeGVz
OiAyMDlmNGU0M2I4MDYgKCJzY3NpOiB1ZnM6IGNvcmU6IEludHJvZHVjZSBhIG5ldyBjbG9ja19n
YXRpbmcNCj4gPiBsb2NrIikNCj4gPiBSZXBvcnRlZC1ieTogRG1pdHJ5IEJhcnlzaGtvdiA8ZG1p
dHJ5LmJhcnlzaGtvdkBsaW5hcm8ub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEF2cmkgQWx0bWFu
IDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vm
c2hjZC5jIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVs
ZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
IGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IGluZGV4IGY2YzM4Y2YxMDM4Mi4uYTc3
OGZjNTFjYTJhIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4g
PiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gQEAgLTkxNDIsNyArOTE0Miw3
IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJh
LCBib29sIG9uKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBpZiAoIUlTX0VSUl9PUl9OVUxM
KGNsa2ktPmNsaykgJiYgY2xraS0+ZW5hYmxlZCkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBjbGtfZGlzYWJsZV91bnByZXBhcmUoY2xraS0+Y2xrKTsNCj4gPiAgICAgICAgICAg
ICAgIH0NCj4gPiAtICAgICB9IGVsc2UgaWYgKCFyZXQgJiYgb24pIHsNCj4gPiArICAgICB9IGVs
c2UgaWYgKCFyZXQgJiYgb24gJiYgaGJhLT5jbGtfZ2F0aW5nLmlzX2luaXRpYWxpemVkKSB7DQo+
ID4gICAgICAgICAgICAgICBzY29wZWRfZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSwgJmhiYS0+Y2xr
X2dhdGluZy5sb2NrKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBoYmEtPmNsa19nYXRpbmcu
c3RhdGUgPSBDTEtTX09OOw0KPiA+ICAgICAgICAgICAgICAgdHJhY2VfdWZzaGNkX2Nsa19nYXRp
bmcoZGV2X25hbWUoaGJhLT5kZXYpLA0KPiA+IC0tDQo+ID4gMi4yNS4xDQo+ID4NCj4gDQo+IC0t
DQo+IOCuruCuo+Cuv+CuteCuo+CvjeCuo+CuqeCvjSDgrprgrqTgrr7grprgrr/grrXgrq7gr40N
Cg==
