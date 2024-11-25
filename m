Received: from PUWP216CU001.outbound.protection.outlook.com (mail-koreasouthazon11020139.outbound.protection.outlook.com [52.101.156.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAAC198A19;
	Mon, 25 Nov 2024 11:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.156.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732533701; cv=fail; b=COPiiFuExCIyyxNHTVGXO38+Wg49F4SBnY5JDCXuku0VICo1xZr0S1wemmRUgCdeguNbG6Z7K88KeXTfQyOp7BDFHzCszxYCVFEET6QTfWkJzaQSZ5MDvlhBOhZ1Gz050B1PkAnL4hVj/7Q8gv6RKVxr+IX81Y+7+hZAzjKEdII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732533701; c=relaxed/simple;
	bh=TQzQzqPoVX3t86N+eoYcAWGHm+nyrgNnBgR7RJdZ2iw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ugARSSdi/o6lq+WkTjG6l8QsdbcwDtB2b7mBhqU8YuUeZhSO5YCXFPknNOB6Spsw2qQ8lxKS+pIhOj5JQEql34/tfqINTjfTNff2nAhYne+eUMP8hf6QAccDK3Uhzk0ngwoxZlTz0bttQVGZ27GfV5cjAC6m4xTNWutRzRFPVAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=unist.ac.kr; spf=pass smtp.mailfrom=unist.ac.kr; dkim=pass (1024-bit key) header.d=unist.ac.kr header.i=@unist.ac.kr header.b=PZNXFSVT; arc=fail smtp.client-ip=52.101.156.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=unist.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unist.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=unist.ac.kr header.i=@unist.ac.kr header.b="PZNXFSVT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkuOxdzKLblxQiMjxM0qDio9CD8gVc76W/yOF7Fk8DJG/72iQLKKrcegyZnRQ7Vma15TTDKeTm4+wShyXC2z/Ehr8tMXFCHnv9XeNTrf00yqAg4oPNcl3JVnA/8Fb0YAYE01v+mNh9961GWdT69W68kCWmMgKPEkV1JkmR9Oylp46yaseNOFOYN0wTeBcf/2NUzP1+tynufTLv8YCU5FlbeuGF99V8qWMI8ocjnQGEAP0nzqoUs8IvKl/xNq2uQM6CqXPJ4tuw0h7Q4MTXGeCTqdNrnU5GPelvgI6Of34x33mC9n+6mlMUiCuKKvs1v8cvA+cYk7cgHpEbFO+/qNRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQzQzqPoVX3t86N+eoYcAWGHm+nyrgNnBgR7RJdZ2iw=;
 b=tviooZuoXiRzxvp5m0NQfsvXQCuqiThRyah2Ls0N6TFOw0fMcEuf9UOo4B18AWdnIx3twT+NJJ8A+a9/VuS6f5TZEjIBe/Aji+saloE2WQ0gEyfFu7krM9jrt7X1ABrDkJHhKCsMY5f2gzQ82Ya8ZDMgsKZLFl4A38dZVmzpN56fr517fxycgD2hPAqhJxLa/qpK6r1EO9rv/dxu2/Ua4N2WTmdezTyi5lUtxXjRvVlI5bQ/HheFJKStLNBXLJRNHUCFuTv7myWtQ4RZ5HU8IQJNXw35ig0rTTs2h31/BKyrWBV7BzrzIKqz6sGBD79OfQaP/tcthDR741o6vyTd2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=unist.ac.kr; dmarc=pass action=none header.from=unist.ac.kr;
 dkim=pass header.d=unist.ac.kr; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unist.ac.kr;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQzQzqPoVX3t86N+eoYcAWGHm+nyrgNnBgR7RJdZ2iw=;
 b=PZNXFSVTpHwawdnW+syU8a5LRobn/l66bGC90YmKYOKHNthbIFzSP1Zm2VUanHk1/q2ys6BlV1xYy3eyWLtKn6Iq6RR1y5mpDSI86NeDIb3lEOC2yUSYpWWkpSwBE5K4fXaQjtfFRcPxBXZ5y9MR6GQrCnKy8C3GyUSsR9IQioE=
Received: from SE1P216MB2287.KORP216.PROD.OUTLOOK.COM (2603:1096:101:15d::5)
 by SE1P216MB1962.KORP216.PROD.OUTLOOK.COM (2603:1096:101:f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Mon, 25 Nov
 2024 11:21:35 +0000
Received: from SE1P216MB2287.KORP216.PROD.OUTLOOK.COM
 ([fe80::abfa:51df:7a24:2f06]) by SE1P216MB2287.KORP216.PROD.OUTLOOK.COM
 ([fe80::abfa:51df:7a24:2f06%6]) with mapi id 15.20.8182.019; Mon, 25 Nov 2024
 11:21:35 +0000
From: =?utf-8?B?KO2VmeyDnSkg7J6l7J246recICjsu7Ttk6jthLDqs7XtlZnqs7wp?=
	<ingyujang25@unist.ac.kr>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "njavali@marvell.com" <njavali@marvell.com>,
	"GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] qla2xxx: Fix START_SP_W_RETRIES returns positive
 EINVAL
Thread-Topic: [PATCH RESEND] qla2xxx: Fix START_SP_W_RETRIES returns positive
 EINVAL
Thread-Index: AQHbPyv85Cfgq/gmnkyVNLOsUVYuDrLH2dMJ
Date: Mon, 25 Nov 2024 11:21:35 +0000
Message-ID:
 <SE1P216MB228778D3FDBBE2C3A45FB9A7FD2E2@SE1P216MB2287.KORP216.PROD.OUTLOOK.COM>
References:
 <PU4P216MB228137E6848B4C5BB032D577FD562@PU4P216MB2281.KORP216.PROD.OUTLOOK.COM>
 <SE1P216MB228748FD61C2B6903FD2E26BFD2E2@SE1P216MB2287.KORP216.PROD.OUTLOOK.COM>
In-Reply-To:
 <SE1P216MB228748FD61C2B6903FD2E26BFD2E2@SE1P216MB2287.KORP216.PROD.OUTLOOK.COM>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=unist.ac.kr;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE1P216MB2287:EE_|SE1P216MB1962:EE_
x-ms-office365-filtering-correlation-id: b9ce9248-93b8-4412-b3bb-08dd0d435263
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|41320700013|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MjhEbGNaRzFCR1UxTXZ0NGhSQk5iNytnMEF3YTJGdFE5MldLZ0FHbU9LclJJ?=
 =?utf-8?B?SWxPZkNCRlkzc0ZTN3FCMnh6M3RCVjM0ZExoc3dJei9CVDdkMExjKzJjWENC?=
 =?utf-8?B?ZCtTVEsrbWtlZmtlTWdldy9Td1lQS0ZZQWFvMWs0VWFnV1c0U1NOb3VOSUN3?=
 =?utf-8?B?NWZ6MEZXTHRqYXcxVktnWXA2WkpMTUY2ZDA3QmF0NGJ4WEFYcnc5aFpha3Ja?=
 =?utf-8?B?K04yZnJ5MHNSd3c1dFlEa09DQkFiMk1sSnhBRVU0bUd2WnlNNy93cFNqczlj?=
 =?utf-8?B?QUpibTJEK2ZVd0VlSDA5ZkZCeDU5R05Ec1hzY3Q4OWwvUXJzMjdrVVcwd1dv?=
 =?utf-8?B?Nmt4M1VvK0dmNmovOHJRU1V0U0gvNnFoUXRZT3JtUWdsTjdOejJYa0NTVUkz?=
 =?utf-8?B?VDYxaUJnZVNqdW1XdXdISUZEdmFpeisxVGkxbDRVdUpFUjZjMVZra1piQUJF?=
 =?utf-8?B?SUhFNkcwRFZJWDE1UDY4R0tXcUhKN2FPTFc1eU5RbWt4TWpwSFBoUUZYRDVh?=
 =?utf-8?B?enN2aFhJc2tKS2JSRjR6eGxaaEQ5ZnVkUWljSjZKZXhEb2dNSTZqcVVVM2lL?=
 =?utf-8?B?UE54YmhWWWJ5Nmk4anpHbXB0dDUyOUZmQWpEbk5zMjlQSUdISUJ2cnk5Wnkz?=
 =?utf-8?B?eTJ4dlQxd1RaTTI4OWpiM29RRlIyL1BPNHZyVFJEaUhXOXkxamVtOEttYzYw?=
 =?utf-8?B?TXU1UEt2eXdXUFZzTnI4T01qMzE4YmN0T0xVVGpxZkxBTmczOUVvem50dUk4?=
 =?utf-8?B?b3B5VkIzQy9MVlFwbDk4cmh4c2pNOFlSQ3JFZ2dEOTdDRExPS0JTQ2ZYa29a?=
 =?utf-8?B?NUNnTXViQ3RWbGRQbW1tb2c3V1RXODBVNEhtdGVTRVAyN3l4UVl0S1dxdm1Y?=
 =?utf-8?B?cDhsMTlnZUtNdTdDVjVrSlBqYmFCekN1SG04YWI4Rmc3R0dhb1lzQjd4cnBV?=
 =?utf-8?B?M0FXUjV1OEdpRVB3REd6UVdzQlhpOC9mc0hYLzB1M2dOQlVYUzFONGEyUFVh?=
 =?utf-8?B?eXpPcEpZdmdSQ0RNdGgremNmK2NPTlRDcDNCUWdRcjhUNmVYR2tkVWRibXBt?=
 =?utf-8?B?VkU0Q1hzME5ram1Nc2U0dVpUTkhZRWdIWGEyMlYra2VDVHo0dUEvb1p5bXpi?=
 =?utf-8?B?d3BYOCtJbTZRdFlwZkc4TEk4ODFwZXVxY3RvbnA4b0hsaDdraWRlUm5QVk5i?=
 =?utf-8?B?VGpNMUNxdDFTUkt4UzlCdk5sM0Zibk1sQS8wZGlqMVQ3emZjNi9Xck1Ma1lW?=
 =?utf-8?B?QWErTjgwSDN3ZjBpbTlpWjBFcHM2ZGwxSEQ2SkN6UW5yY0EzS2tnN1ZWN0c2?=
 =?utf-8?B?eXBSeXdzZ3FUOEpDclZndjlzTU1yeXNiWGFHWkNWRTM2c1lOT1djd0pkZWVT?=
 =?utf-8?B?ejY3UDdpdE9MQmZ4UEVmTFRQYlFCLy82eDQ1eDV4cC9RWWJOR0xzUE1zaXAx?=
 =?utf-8?B?eXErRjFlellFRHpGMzBkU2F1NEUwSmxaV3UycEo4eEU2enZPN2V2R0RvbUxS?=
 =?utf-8?B?TjdNWC9ITSttdXpVeWRJaWF4S1kzYmd3ejRxSzlkbTYzOHZNQTl0Ykg2WWVC?=
 =?utf-8?B?dlBUeldNc3dqdUhjc2xTUnk0eklrTDVaWm9EY0NYWnFROUtCVCtMSFllektJ?=
 =?utf-8?B?WXZiZ2hJT05VL0tYNlB5WDk2NllMd3hLR3d2b3lwUmh4Smo5d1g0MXdpdWhq?=
 =?utf-8?B?Uzdjc3lFWW1UTDBmZkhKQ09ieU50THpENTAySzF5cGZENkkrZXBGMVdNbDA5?=
 =?utf-8?B?UTYyK2tndy9vNmJUQU8zaDZHRmVQVERvQmZQTEZMcUY4cnhTRTBjWVNCdDIv?=
 =?utf-8?B?SVZQZ21rVXhjYndrZUc4U0QzK0lzSldPSEcxZjJERnJIRjczQmU0b0VqdUlV?=
 =?utf-8?B?WW9ZSTJaTkYvN3VjRCtJbENlNDlNVVU4RUswNUw5T2xrY0E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ko;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE1P216MB2287.KORP216.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(41320700013)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y3lXWU10My9ZSGYvQkIydjdIQU5MUWtETU1mODV1RXIxNTd1ZXoyN1VGY3V0?=
 =?utf-8?B?VWxhVWpiVzZJVVN3aENNckczNDJIOEp4TDZoUVdubHNXQjFtWDZYOVhSTGVl?=
 =?utf-8?B?anFGTy9YT1M4VFhKM3dyNlJCeUhzMHBaSjZ5NkVjSTBkVVJzRXRtM0RMU0FD?=
 =?utf-8?B?QTNRa21XZnlhcHZLNllBV0tZdGNUbUlpbEM0RWRPZ1BRS0dub2UzUElUVEIx?=
 =?utf-8?B?azJNYWN3YVlaNFY0MVkxeDVtVVRuMGNlUGxDUG9XdndGVVVuSXVYQlh5TGpX?=
 =?utf-8?B?Q0I0US9xMFd2T3ZTbi9VbENEaWJPekpXd2hxN0gzNDJtR3NPTHpLZ0JiOVor?=
 =?utf-8?B?aURLRFdvWGovd3hreEd5QTF0cXB0Y0VPbDRKMDRnb0ozN3ZKTEdoZEVPL3kr?=
 =?utf-8?B?aVV4NTJXcFFyV01KL2RFeFRnYkZzTzBtNEtid2lNVnUxL3RzZU5FUC9tOFhN?=
 =?utf-8?B?Unhzd3JmMXp4endFa240L1MyZmtxSElhbFBOeWxJNUJoTVFPQW1md1JhNDZC?=
 =?utf-8?B?Z09OSjd2TjdJcXhyci9LQWFSNmV0NFcrTjNOZmVLK3dERUhra2xwWHBlWFBt?=
 =?utf-8?B?L0NaTytJaE8vY0RuYVRKcW5vcGcyQnF2TjFRVllib1h6MGthV0wrUTVqYnQ1?=
 =?utf-8?B?SDM2WHlmcWZsd3BrYVZBK0pBSmsxekNuR2k2NUtEb1VwVS81OVBKbkRZSlFJ?=
 =?utf-8?B?dHRLRTR0eW5hVnVMWVZtait2YkludW9jMnFIYWpvak1kY1pGRW1oM3AxM2tL?=
 =?utf-8?B?WEJ3MjlVeHVNRVpTZW5FMDBaa1Q5RXVPcnZiK0o3cWE4YXNGeDJuVUE2S0Rw?=
 =?utf-8?B?YTl0OWVEUEYrWHFGMUt2Z21COWRlamJVT1BTQjBiaU1CUFJ6OGdTTUV1Zkc1?=
 =?utf-8?B?N0RvcDdVV1ZDUVE1RTBhWnhhQXZxZmtkd2MvU1RjNk1Od2hTYXBOTmgxVFFo?=
 =?utf-8?B?M2F4SnJHR25VYzE3elBqZXVhWVRmZVQzK1ZJYkc4WldrUW9iM25rOExQb2N2?=
 =?utf-8?B?dGU0bklpNlJVWVpjYjNnOWdUM3JTMzFJMVdTUGFIOWQ3UzNUcHNqMWZYN2tB?=
 =?utf-8?B?R0doQkhpMTFIYTRGTi9mNkN4c0xaRmtGYWtibUhicHI0RTBpNnpXRGZrclA4?=
 =?utf-8?B?Y045TENpMHR0Qy9KdGEybUtlYmRHd3ZPVTR0Umt2L0lsNGRXaVZuQlR0cEdp?=
 =?utf-8?B?bFlUVDNDNmlKUzNoUGdKYVJ6Rk14VDVLNzBJQi9LbU01Y1NrVHc2ZFc5Ykhj?=
 =?utf-8?B?RlQ4ZWR6WFBYSmRSWHkyVXZKaitEcDF1OUh3dVRFWWlYWjBuQlo4NjZMOG9t?=
 =?utf-8?B?RjRucFRwOTZyMjl2SzFrcDhBR0xGNWNLRGtaV0lJVWg2dEJheUpISVNwSU5w?=
 =?utf-8?B?bGJFOHFRZ0gwSnVmZlhKMUc3cEZCaXF2UGFiZ1A3MHUySW5nZGk5ZjhBdjkw?=
 =?utf-8?B?MzlObHc0WHFQTnlCKzVFaUVPZ2tCYmxsUTAyb3YzVXN0YlVMRmRiL2lCeW1w?=
 =?utf-8?B?ZDNFcytoekl1Rk1rQkJMNStwTGxPYUJOK1Z4T3FjMHB3NHhOMlBJeGJhYmVr?=
 =?utf-8?B?RGlEYzI3VXZhY29IZUdPN1c3OWl6VkVSK1NxYjlYUytpMVMvak5tN0RnK0FL?=
 =?utf-8?B?dWUzakd2Wlp0dEFxSmIxa0RUZE0vWERQZDNYdjZRblFnSHhMQnRsN3hTdFRD?=
 =?utf-8?B?aFpOZTlwTTZGYkt5VEVNaUV2VVF4OEZVRmROa3lic2xxbFlyNHY3cm1QYUY2?=
 =?utf-8?B?YnJNRkpBN0lqZHJWV1RWUjBqdWxkeEF2amVPdEl3RnhWQnZhTzJDU3RJeXdw?=
 =?utf-8?B?K3ZuVk1YRGp6bVkvWCt2RTM4UGZqYlEwT2ZnMWtkRGlhaFFoQjlqWEdaZDRi?=
 =?utf-8?B?SVJuakZvUjJCeWFYaGhtRWZockJ1TjR2ODRJZC95czJ5SXo1ZDJDWUdJbU9X?=
 =?utf-8?B?d28xYVNnQ2o2MVkvREY3N1ZsaFZGeUErRU9peVdRYzNLeFEwWVJtSjk4NHhL?=
 =?utf-8?B?UyttUDBGU2ZOeTdGTE9rdjhvTktZaHFLQjZ2ODdsWUVnc0VROUZyaXZ1d3Z3?=
 =?utf-8?B?NXNkaHljakl1TDNPWWQ2eExkajZaSVRGcGk5WlNNWlhWbzZLRHowZUV0MnE3?=
 =?utf-8?Q?DN7pZ9BHMsr8TosZivcC0BbST?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: unist.ac.kr
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE1P216MB2287.KORP216.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ce9248-93b8-4412-b3bb-08dd0d435263
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2024 11:21:35.2323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e8715ec0-6179-432a-a864-54ea4008adc2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ex1ZPYYTPaNd04Oz8wfOjd+RsHOgXM5V8j3FDU6z6mPbpRQcHYKZ4RqnlK0fOfileCfoyyLpC0rcAnlMMNWdbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1P216MB1962

RnJvbSA2ZTc4ZmYyM2I5ZjExZjY4OTZjMDkyOTllMGEzOGI0NDQzNDIwZWVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJbmd5dSBKYW5nIDxpbmd5dWphbmcyNUB1bmlzdC5hYy5rcj4K
RGF0ZTogTW9uLCAyNSBOb3YgMjAyNCAyMDoyMDowMCArMDkwMApTdWJqZWN0OiBbUEFUQ0ggUkVT
RU5EXSBxbGEyeHh4OiBGaXggU1RBUlRfU1BfV19SRVRSSUVTIHJldHVybnMgcG9zaXRpdmUgRUlO
VkFMCgpUaGUgU1RBUlRfU1BfV19SRVRSSUVTIG1hY3JvIHByZXZpb3VzbHkgcmV0dXJuZWQgYSBw
b3NpdGl2ZSBFSU5WQUwgY29kZQp3aGVuIGNoaXAgZ2VuZXJhdGlvbiBvciBsb2dpbiBnZW5lcmF0
aW9uIG1pc21hdGNoZXMgd2VyZSBkZXRlY3RlZCwKcG90ZW50aWFsbHkgbGVhZGluZyB0byBpbXBy
b3BlciBlcnJvciBoYW5kbGluZyBpbiBjYWxsZXIgZnVuY3Rpb25zIGFuZApjcmVhdGluZyBzZWN1
cml0eSByaXNrcyBpZiB0aGUgZXJyb3Igc3RhdGUgd2FzIG1pc2ludGVycHJldGVkLgoKVGhpcyBw
YXRjaCB1cGRhdGVzIHRoZSBtYWNybyB0byByZXR1cm4gLUVJTlZBTCwgYWxpZ25pbmcgd2l0aCBr
ZXJuZWwKZXJyb3IgaGFuZGxpbmcgY29udmVudGlvbnMgYW5kIG1pdGlnYXRpbmcgdW5pbnRlbmRl
ZCBiZWhhdmlvciBpbgplcnJvciBoYW5kbGluZy4KClNpZ25lZC1vZmYtYnk6IEluZ3l1IEphbmcg
PGluZ3l1amFuZzI1QHVuaXN0LmFjLmtyPgotLS0KwqBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
aW5pdC5jIHwgMiArLQrCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgYi9kcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jCmluZGV4IDMxZmM2YTBlY2EzZS4uMDg5ZDU2MGU0
MTE0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jCisrKyBiL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMKQEAgLTIwNTksNyArMjA1OSw3IEBAIHN0YXRp
YyB2b2lkIHFsYV9tYXJrZXJfc3BfZG9uZShzcmJfdCAqc3AsIGludCByZXMpCsKgwqDCoMKgwqDC
oMKgwqAgaW50IGNudCA9IDU7IFwKwqDCoMKgwqDCoMKgwqDCoCBkbyB7IFwKwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKF9jaGlwX2dlbiAhPSBzcC0+dmhhLT5ody0+Y2hpcF9y
ZXNldCB8fCBfbG9naW5fZ2VuICE9IHNwLT5mY3BvcnQtPmxvZ2luX2dlbikge1wKLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9ydmFsID0gRUlOVkFMOyBcCivC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfcnZhbCA9IC1FSU5W
QUw7IFwKwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJy
ZWFrOyBcCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0gXArCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBfcnZhbCA9IHFsYTJ4MDBfc3RhcnRfc3AoX3NwKTsgXAotLQoy
LjM0LjEKCgo=
