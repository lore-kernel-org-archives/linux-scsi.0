Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5025E1EA7CE;
	Tue, 22 Apr 2025 07:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745307466; cv=fail; b=sPfc0vO6BpLmFEGT8vulY0Au/8usVNeJZTQUPjMUZsRi5V9dryYQwzm9IGGirknJaPNASiAp1fT2DZ6CoZQN+f6xa48+zUlfNEZZp0Q7Z6AwauBhdA24cBx/vwvMndd7lWsk6zBkiN0737nd1pJzRhfwON5mwUco1UWGfi2e+2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745307466; c=relaxed/simple;
	bh=rRIZwpxs43lB0SHjPvVqwaVDz2HzYs9sSTHzsfziH4Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h258I4V76sTuCcvZIicTIMG8u5ufVpX9rkpsbfMPyjv9d/zzTWeaCgfvhDFCRo406ONedl8kIkcPpK74Xo7cZ3vBh+sia8mS7eWPqcOgjCieBkYO1pQ3SEYTHtai3fQqTI3fVLdY7foKQk1OA5B9gkiVJJ/ONBHyFiOFCtcZQyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LpBhxMBx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=WhCU84ir; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LpBhxMBx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="WhCU84ir"
X-UUID: aa3e378c1f4c11f0980a8d1746092496-20250422
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=rRIZwpxs43lB0SHjPvVqwaVDz2HzYs9sSTHzsfziH4Y=;
	b=LpBhxMBxSdTQalUf0Cn7tGBmPeP+18xWb2nMHUShSDacDLU2y7XiqXG9f7lwunH55qTotWsl0bA1nTVN1H2vRJ+bA6YnuPpNzzHWSUbFOPpeSVbnNMOwDE87HTfpMA4J0Zsx4gsXtAT4vKnuYH0R5YcOnMahBX+V28QiZYtLBN0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:d0c62ba0-1e21-45b7-9785-abf18a3dbdef,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:7f9e888b-0afe-4897-949e-8174746b1932,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: aa3e378c1f4c11f0980a8d1746092496-20250422
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 516114335; Tue, 22 Apr 2025 15:37:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Apr 2025 15:37:37 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Apr 2025 15:37:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZ0Qvq5UoBOcDCXCq/GDlitMiXbNJxK5NDx7LC38Lm7LkhnouqccyAzSCAtIRDFPpFPXl6rq+8AR+soxa90QbTHfK5B64ERWpaTbfz/k6/A1AAIBOLX6WRKmSJNgwBCzpHrUCxSvSvr+0qIZ6W4g60gVD84hfAkigLr0kxKNBewyez35X36hJc7l5eLSORdUgSrmvbSyAsnmU7FhqUbz5DDWajjiL68uJ7HT3PpXjmpe5FLUwo3IbucBOo4yZU07eEkhWdbnBXjbL/exMS5Is9pJNp6qkcePfvko8pZfwAxZ7rGYIIJqUDNNwPj34IRsjSKoD7B3Rz4WQVvSzz2PsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRIZwpxs43lB0SHjPvVqwaVDz2HzYs9sSTHzsfziH4Y=;
 b=o8KNso+MXUsL/zrPPMipaOb7gL+AQC0qGg7MNVaCzKUlMw/6GoekiXKDMSckwr9OhDwzDeAHlepHLrz4yDittjFzDgLLhHLWRp67ND7LQd2fe57BfTXaO3NEij2jnyXuxmSvKt1F1wc1S4WZ3h1g1n/LgLOMw3puK+KWk7I5FFJVcjBlXD7hqXRFOrxGbDnTDcXTACC/InANIiIyf9TDGEa+NIfUsHCUlxwgMVqA1wVXKtHlX8gKwOw7/eOGJU3DhLD6UHhjz5FMO+0LqBxeZ6RAg6XMTd4bndJU6ARTLm4vqOZN7TzLxSI/SHy2P3Eya8E2JJ0RyG0htY3hI6TqYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRIZwpxs43lB0SHjPvVqwaVDz2HzYs9sSTHzsfziH4Y=;
 b=WhCU84irMT3PAUVgdq4VZ3B/2z1LJSN205YgWdutGLIwFn9ro7TZHlJb0f900wfJqzPb03PJr8+HfkP3jXtrq2LVVwLAxM6vT53kjNiuRsK7i0v/aoipwALGqOHj0vR5HDDB15wWUDCH5Lbz4IfFTcXMXD/Iswjh7hr37L8NfLk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6449.apcprd03.prod.outlook.com (2603:1096:400:1ae::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.27; Tue, 22 Apr
 2025 07:37:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 07:37:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "ebiggers@google.com" <ebiggers@google.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_ziqichen@quicinc.com"
	<quic_ziqichen@quicinc.com>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "keosung.park@samsung.com"
	<keosung.park@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "gwendal@chromium.org"
	<gwendal@chromium.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "luhongfei@vivo.com" <luhongfei@vivo.com>, "opensource.kernel@vivo.com"
	<opensource.kernel@vivo.com>, "wenxing.cheng@vivo.com"
	<wenxing.cheng@vivo.com>
Subject: Re: [PATCH] ufs: core: Add HID support
Thread-Topic: [PATCH] ufs: core: Add HID support
Thread-Index: AQHbr5dd5UFxpgoJ9U2vrHOPQ7eIPbOvU6CA
Date: Tue, 22 Apr 2025 07:37:31 +0000
Message-ID: <59e91374fb4232ba22c8d80defe7ee65666dbd40.camel@mediatek.com>
References: <20250417125008.123-1-tanghuan@vivo.com>
In-Reply-To: <20250417125008.123-1-tanghuan@vivo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6449:EE_
x-ms-office365-filtering-correlation-id: 9de137c2-91fc-4ab3-48f6-08dd81708aae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SGhDTS9vSFpPN1RLaDA3amdmMThNUnRtR0JZek5mSXdyQWFBcFh3U2FBT2l0?=
 =?utf-8?B?OTRnaSswb0hScFNpcW5kdmxZYk5FSmZ4NDdDd0ZVbWJ3dGlUUll5ZWtvNmE1?=
 =?utf-8?B?ZDNZY3VrK0NtV3I1TndzVEZEVUZPeHFxT3Y2S29YU29XdGRUMVZsYjJnOERT?=
 =?utf-8?B?aFBKaWE2aUtQd1ZYUDNoOUw4RVY0dWlVODRHVElJYlpKbDV0WkxTQXRudnhO?=
 =?utf-8?B?dnFEdkhMKzZHa2gwSjdIK0RiM2JrenZPYXJOMDlnQ09KWVRCakZESWRrNWli?=
 =?utf-8?B?a2F6RmdYNG41SjVmL1VUVS9JNWdvL2h1RmxQYUpHQThiaHh1bHZZTk5tT2Zj?=
 =?utf-8?B?VXZYMkhaSXlIcHRJeGRMZnJLcFhUcDZUekJKd1ExN1JmODZiZGZXdTFEOXNI?=
 =?utf-8?B?SEVEdkY0dWhVNXJjL25jMVlMOGt0blFoait6azlkOFNNcXlNQnBwQVNzUmdQ?=
 =?utf-8?B?QlJPRnZHRlY2VU9hZ2FXenVWVjlxU0I3aDUvSjJxV3dNV2p3WDhXcHl2Zlo1?=
 =?utf-8?B?MXBuQWg2RTZOcC8vRkVhZGdSUmd5ZmY5R3RoVjBGYUZwMEdCSFRVMllEUTlZ?=
 =?utf-8?B?SEkvbmZtdzN3ZHp2djllMzVzaFI4YkhFclFJVU5FMjU2MlFhYjc1VUNZNTUz?=
 =?utf-8?B?UElCUW1CTlczb0ZXZXJVV0lRZUJZdUVFczZKOHhibXRiVUtpcDZhdWNiWFRt?=
 =?utf-8?B?VlU5SlpZQjdQMFVtS2JzWHpYMTBoR3dVcGhDVXpCOWlkcXoxeFdzQzlMaHpx?=
 =?utf-8?B?RnVnaVFWUGlHYmVIZjd5OGlkM2U0cHo1ZW9HZSthbElWT1BZMThiNktUdmtw?=
 =?utf-8?B?Zm1qbHZtYnE4di8rc0lnVGY2MXV2RDliQlViSjF0UkpqcUJ0MFVTWklkZWlR?=
 =?utf-8?B?SHIxR1pZdjRlbHFrclVwNEllcFArTkZFOXc3TElkd1BHb1pOWmJxYS93Y2kv?=
 =?utf-8?B?T2hzdGxveXZ5bFA5aHFTQk93Z0RoVlNZRks0Z21uVFJselNWSERQbzhjRUh2?=
 =?utf-8?B?bTNIcEx5bmRod3ZDd09UZ3ErV3BvZjJoRkxMTTVORURad0xvb2ZOZ2NaaHo0?=
 =?utf-8?B?STJUZWh5QVJ1bHVZaGFDTlh0d1NGNEVOZ0ttdUx0bWZpU0FwTnZJbVo4TXVV?=
 =?utf-8?B?M1FmcGhoc2NIeHJ2YkxsZ3poSXRsb3JnVkVHMHRocDd3TUVYQ0hEcHhlc01K?=
 =?utf-8?B?NTVzalNjRTFncUVtQWpOWlU2S1E3S3VHK3NXTkRNQXcxQVNIZDRqcjdJV1h3?=
 =?utf-8?B?TjQyVlBWYlhLemV5c0QxbzhyQTRtdnBHbjV6R2J0MitSKytjU3VqK1ppcGhi?=
 =?utf-8?B?QW9POFhSL3FtSzcxMVhmNmdqcVVIUHRBNmNETENQdDFjckxCQ2RmM05ZNHdN?=
 =?utf-8?B?c0hZQWp1cWlvdXA0dnZWbFZDaTVvcUQxNnA3MUV1ZHhENGtHNU84eW5YdFIr?=
 =?utf-8?B?SG92MkpvY2dpSURrTEFWN0N3cUdvbVh0bmZZZUd1MkJ4R2ZKMDdyZDJ6Q0Jx?=
 =?utf-8?B?eUUzOUM5MWdFbHk5b1J3Q3FlUUR4WVU4dXhhVFdGTU5ON2x3SnBqdXhpb1Zy?=
 =?utf-8?B?dWw1d0xiWmVpdXJCOU1yaURyU005aWRQa2hNT09KZlM0TENBSHZhdzFXd0lI?=
 =?utf-8?B?TGMwcExUZXdyWms3NXRwNURLRTJzRGNsSUZPT0NMbXEyRWRnSHB6bm9QV1dl?=
 =?utf-8?B?S1ArcGhSNitxZ2dzNGVNN1EzNE40Vit1MU5lU0RKTFc1czNwWnR1VVlNQWQ1?=
 =?utf-8?B?UE5tK1FQblUzV1ZobzlYU2M1SUVnUXRkbmR0emxrTUFYOWNZbm4rYkE0V1Iw?=
 =?utf-8?B?LzFqZFgxeDd3aXFsbVlvNk5zVUo0VXU1c3paSWsrd1ozQmJDdWk2S1I3aW16?=
 =?utf-8?B?Vmx3c3pBTXBKSHVSQU0yd2xyd1RZK3IxTzYzaDMrOXgzRzFLSW5HK1Q3OVhq?=
 =?utf-8?B?Z0x4WVloMUQ3SEZick45UUJ3TnozYitKYW9oV0JMZTFZQ2JtWWNXcHRWNlpr?=
 =?utf-8?Q?dFdREAqpiEWgbPl5O2MoB8Erf5jXMc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlFFRkdjdVRzKzYxYytsdHhrOWpiUkxNZDJHWWgvYTViUGF6Y0JrbGVsZ1BQ?=
 =?utf-8?B?WGF3bVVWcTlLRThad0ZmaThvQU9PTEJVSytZN0wvenFPckphUXd6bHMzalBp?=
 =?utf-8?B?T0x3LzdVUmIxc3lqcFBaSmNlNHAwa09OM0dPcnNMcTF4djliTTcrTm5jZ2FN?=
 =?utf-8?B?a1daRmk1MGpRYnZWamU0dHFVNTdRV2pNSU9NVzM4R05yRVoyclhScTZnYXVR?=
 =?utf-8?B?RHFweVc5eVFTQW9sSnpld1cxNlROZEtPOHd0WW5DaGNOTWdCekgwVytFQ1hk?=
 =?utf-8?B?dG01SUI1MkRjQUJSUFBtYjVHeGU4Lzg4NEFObFpJTStGOUtGMDZWRWJuY1VK?=
 =?utf-8?B?dXVPYWE0M1RLYlVkRUlieU5IMFdhZXN5WGwxVXJDZjBiYkpHWlh6R0FRYXV2?=
 =?utf-8?B?MzBTZERsdFVGOG5DbkN1TW51OVdWT3FrNTFmYkRiaDJvb0JBNzFtYzdLUW5F?=
 =?utf-8?B?S05xYm45dDZ5dUVScGROaCtUdU02ZFZNWjVyL3FzaVZieG90dTNRNitFd2Mw?=
 =?utf-8?B?VS9EbFBHeFdPZW83WTRUZnY4enhtdEd1Qm5jMHpSVlUzRUFvcVFxOFg3SDgw?=
 =?utf-8?B?ejJ5WGE1c3BlNkZTSDE4dGwydUhaSlJ3TmdPV2N1Qlc1OXAveTBQekZ6cmFZ?=
 =?utf-8?B?MHkrdWJ3VExMMEJwbUJFblEvZ3YvWmJwb0xnUGpKY3R5Yis3MzZzcndwUGw2?=
 =?utf-8?B?NXNha2pUMFZ0akZLemdETC9kS3RqaWx3VFZGWTAwaWRWOW03K0dOaHJMaUx5?=
 =?utf-8?B?ZWR5eFZHWjFPaDdqVS92YUJ3ZHk4ZWwxazNnNytSZU9YOHFjNVNzSXVTV2Zw?=
 =?utf-8?B?ZzFDdGxuSWZQY3dXRE0rT0xqQmdUNHQrS0ZmZG91dG1lUTFUS1J0Nk5qQ3FU?=
 =?utf-8?B?S1RlZjFtanZDQ3hVbjloS3lYcnFYbVcvbVBOZC9TMGFKaVc3QXE5T3BaZ3FE?=
 =?utf-8?B?TytTcHppK05qM29KbC9OcHFCUlJoZDgrMWdHam9rdWQwWERGOW5BMDVCc0U5?=
 =?utf-8?B?N0thQ0taMHRqWG5XT2JJZEhXNXFXaTFzREJac1RwcGRQay9GMjc4cURLUld1?=
 =?utf-8?B?SG9DaVhmamlVRVprTzlLSXpXM2ROUldBMkc0NHlESHpGZkZiOUNyOGQxcDRN?=
 =?utf-8?B?TUFOb0w3THF6WWl2NURqQlZCNnk5bkQwT1RDMzRLVngyK1U1Mlo5cDlHZTlh?=
 =?utf-8?B?K0U4dHBXb2tVbXI5WTZkeTg2akQzNlNiK0hScHQzQ0dXbUpyNlN5RnR4alhx?=
 =?utf-8?B?YVJ1NlR0S3JueFZZWXBGZGk5d1ZoamM1Tnl4NjEwZm9GOFJ3eGpjUVZqcU01?=
 =?utf-8?B?YTJVSTNZYWlzNkg3RFcxdkt6MDVJdXFtQlI5OGVqTlZqSkRpaU50bTk1Y3cv?=
 =?utf-8?B?ZGdzOG9vMndwM1BKcURYaHlIU0xnNFhtRktTNG9TaDNUL284dDB3ejJyTmJa?=
 =?utf-8?B?M1N0elpoaGI4S1ozNE1hZ25JdFR4V3E0eVZkVUVQZG95bktBVFJLdmdqMWVt?=
 =?utf-8?B?MkluV3ExS0Z5OTA3eG40VmZyZzZDekFGYnN0NmFXQ0t3Wnh5V0tNRU0zTGti?=
 =?utf-8?B?WlpOVkY4YWZJdzRvMThQVkJqZUtLUVJBR2FRUHpXcWtIRFUwQ2FoaWIvb1Rn?=
 =?utf-8?B?S0QzTTdESzJGQ1JrR3cwM0d2T0FheUExTlJFRnJUN3RqUytnR0xpbmkvOUdh?=
 =?utf-8?B?Uy9GeTViUlFaZXU0MmZtU3VXMDcvWFBLNUovMkZlbU9iWEdzaE4vS2ZnSkhi?=
 =?utf-8?B?RjNWNUpvTlFmMHhBcjJTMGNObm0vbHVlQ1FZbk95eSs4V0RNVEpzT0Y0TnBK?=
 =?utf-8?B?N1pwN1JJWGVWalE0T0RuZkJyZ053V09yMTBxZEk5Q0tCWWtMb001Z2VtS2M2?=
 =?utf-8?B?T0FrSGlNdzYrbXJkOUk1NFJjZFJwaUxtb3hpY2F2R0NQTmw5N1IvVW1Oamkw?=
 =?utf-8?B?WDBZa2JhNjZFZUYvc2s0MkwvUWNycDFGWW0vS2RMNThyYTFacjUrM0psUGhR?=
 =?utf-8?B?MnZJRUdOOFhHNE13MDgwQ3dVZzAzSDhYZDgvQ3gzUHdIU3piMUMwZ1lnSEZr?=
 =?utf-8?B?QlVNTGRpM2I5U2dlTzN0aTZIN0ZBcHZ1c09xd252UFB1ZjFmVHlSMjFUSFQy?=
 =?utf-8?B?ZUhCUGd3WXB4N0xYTmZGQ2txWkk2VnVmc2xLNm5MeGFDSExaeTczcTF1WE9m?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DBD6D0EE29E604A8F009197408867B2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de137c2-91fc-4ab3-48f6-08dd81708aae
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 07:37:31.9077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E+bjbtu/Mjbi/07rJtNMq9ydMLmKzcNJVoH3eCNG9unDxJfpj2JgpywwKkZcFKXij2IJoiA4S6utdvheVQw4pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6449

T24gVGh1LCAyMDI1LTA0LTE3IGF0IDIwOjUwICswODAwLCBIdWFuIFRhbmcgd3JvdGU6Cj4gKwo+
ICsjZGVmaW5lIEhJRF9TQ0hFRF9DT1VOVF9MSU1JVMKgIDMwMAo+ICtzdGF0aWMgaW50IGhpZF9z
Y2hlZF9jbnQ7Cj4gK3N0YXRpYyB2b2lkIHVmc19oaWRfZW5hYmxlX3dvcmtfZm4oc3RydWN0IHdv
cmtfc3RydWN0ICp3b3JrKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3QgdWZzX2hiYSAqaGJh
Owo+ICvCoMKgwqDCoMKgwqAgaW50IHJldCA9IDA7Cj4gK8KgwqDCoMKgwqDCoCBlbnVtIHVmc19o
aWRfZGVmcmFnX29wZXJhdGlvbiBkZWZyYWdfb3A7Cj4gK8KgwqDCoMKgwqDCoCB1MzIgaGlkX2Fo
aXQgPSAwOwo+ICvCoMKgwqDCoMKgwqAgYm9vbCBoaWRfZmxhZyA9IGZhbHNlOwo+ICsKPiArwqDC
oMKgwqDCoMKgIGhiYSA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QgdWZzX2hiYSwKPiB1ZnNf
aGlkX2VuYWJsZV93b3JrLndvcmspOwo+ICsKPiArwqDCoMKgwqDCoMKgIGlmICghaGJhLT5kZXZf
aW5mby5oaWRfc3VwKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsKPiAr
Cj4gK8KgwqDCoMKgwqDCoCBkb3duKCZoYmEtPmhvc3Rfc2VtKTsKPiArCj4gK8KgwqDCoMKgwqDC
oCBpZiAoIXVmc2hjZF9pc191c2VyX2FjY2Vzc19hbGxvd2VkKGhiYSkpIHsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB1cCgmaGJhLT5ob3N0X3NlbSk7Cj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+ICvCoMKgwqDCoMKgwqAgfQo+ICsKPiArwqDCoMKgwqDC
oMKgIHVmc2hjZF9ycG1fZ2V0X3N5bmMoaGJhKTsKPiArwqDCoMKgwqDCoMKgIGhpZF9haGl0ID0g
aGJhLT5haGl0Owo+ICvCoMKgwqDCoMKgwqAgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUoaGJh
LCAwKTsKPiArCj4gK8KgwqDCoMKgwqDCoCByZXQgPSB1ZnNoY2RfcXVlcnlfYXR0cihoYmEsIFVQ
SVVfUVVFUllfT1BDT0RFX1JFQURfQVRUUiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgUVVFUllfQVRUUl9JRE5fSElEX1NUQVRFLCAwLCAwLCAmaGJhLQo+
ID5kZXZfaW5mby5oaWRfc3RhdGUpOwo+ICvCoMKgwqDCoMKgwqAgaWYgKHJldCkKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBoYmEtPmRldl9pbmZvLmhpZF9zdGF0ZSA9IEhJRF9JRExF
Owo+ICsKPiArwqDCoMKgwqDCoMKgIHN3aXRjaCAoaGJhLT5kZXZfaW5mby5oaWRfc3RhdGUpIHsK
PiArwqDCoMKgwqDCoMKgIGNhc2UgSElEX0lETEU6Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgZGVmcmFnX29wID0gSElEX0FOQUxZU0lTX0VOQUJMRTsKPiAKCkhpIEh1YW4sCgpDYW4g
Y2hhbmdlIHRvIEhJRF9BTkFMWVNJU19BTkRfREVGUkFHX0VOQUJMRSB0byBzYXZlIGRlZnJhZ21l
bnQgdGltZT8KCgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGhpZF9mbGFnID0gdHJ1
ZTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiArwqDCoMKgwqDCoMKg
IGNhc2UgREVGUkFHX1JFUVVJUkVEOgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRl
ZnJhZ19vcCA9IEhJRF9BTkFMWVNJU19BTkRfREVGUkFHX0VOQUJMRTsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBoaWRfZmxhZyA9IHRydWU7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgYnJlYWs7Cj4gK8KgwqDCoMKgwqDCoCBjYXNlIERFRlJBR19DT01QTEVURUQ6Cj4g
K8KgwqDCoMKgwqDCoCBjYXNlIERFRlJBR19JU19OT1RfUkVRVUlSRUQ6Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgZGVmcmFnX29wID0gSElEX0FOQUxZU0lTX0FORF9ERUZSQUdfRElT
QUJMRTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBoaWRfZmxhZyA9IHRydWU7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4gCgpDYW4ganVzdCBicmVhaz8g
QmVjYXVzZSBhY2NvcmRpbmcgdGhlIHNwZWMuIApBZnRlciB0aGUgaG9zdCByZWFkcyB0aGUgYkhJ
RFN0YXRlIHZhbHVlIHdoZW4gaXQgaXMgMDRoIChEZWZyYWcKQ29tcGxldGlvbikgb3IgMDVoIChE
ZWZyYWcgTm90IFJlcXVpcmVkKSwgdGhlIGZvbGxvd2luZyBwYXJhbWV0ZXJzCnNoYWxsIGJlIGlu
aXRpYWxpemVkOsKgCmJISURTdGF0ZSB2YWx1ZSB0byAwMGggKElkbGUpCgoKPiAKPiBAQCAtOTYx
NCw2ICs5NjE5LDggQEAgc3RhdGljIGludCBfX3Vmc2hjZF93bF9zdXNwZW5kKHN0cnVjdCB1ZnNf
aGJhCj4gKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJlcV9saW5rX3N0YXRlID0gVUlDX0xJTktfT0ZGX1NUQVRFOwo+IMKgwqDCoMKg
wqDCoMKgIH0KPiAKPiArwqDCoMKgwqDCoMKgIGlmIChoYmEtPmRldl9pbmZvLmhpZF9zdXApCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZo
YmEtPnVmc19oaWRfZW5hYmxlX3dvcmspOwo+IAoKV2lsbCBoYXZlIGRlYWQtbG9jayB3aGVuIHVm
c19oaWRfZW5hYmxlX3dvcmtfZm4gaW52b2tlCnVmc2hjZF9ycG1fZ2V0X3N5bmM/CgoKPiDCoMKg
wqDCoMKgwqDCoCAvKgo+IMKgwqDCoMKgwqDCoMKgwqAgKiBJZiB3ZSBjYW4ndCB0cmFuc2l0aW9u
IGludG8gYW55IG9mIHRoZSBsb3cgcG93ZXIgbW9kZXMKPiDCoMKgwqDCoMKgwqDCoMKgICoganVz
dCBnYXRlIHRoZSBjbG9ja3MuCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZzL3Vmcy5oIGIvaW5j
bHVkZS91ZnMvdWZzLmgKPiBpbmRleCA4YTI0ZWQ1OWVjNDYuLjZlODU0NjAyNGUwOSAxMDA2NDQK
PiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnMuaAo+ICsrKyBiL2luY2x1ZGUvdWZzL3Vmcy5oCj4gCj4g
wqAvKiBEZXNjcmlwdG9yIGlkbiBmb3IgUXVlcnkgcmVxdWVzdHMgKi8KPiBAQCAtMzkwLDYgKzM5
NSw3IEBAIGVudW0gewo+IMKgwqDCoMKgwqDCoMKgIFVGU19ERVZfRVhUX1RFTVBfTk9USUbCoMKg
wqDCoMKgwqDCoMKgwqAgPSBCSVQoNiksCj4gwqDCoMKgwqDCoMKgwqAgVUZTX0RFVl9IUEJfU1VQ
UE9SVMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA9IEJJVCg3KSwKPiDCoMKgwqDCoMKgwqDCoCBV
RlNfREVWX1dSSVRFX0JPT1NURVJfU1VQwqDCoMKgwqDCoMKgID0gQklUKDgpLAo+ICvCoMKgwqDC
oMKgwqAgVUZTX0RFVl9ISURfU1VQUE9SVMKgwqDCoMKgID0gQklUKDEzKSwKPiAKClBsZWFzZSBh
bGlnbiB0aGUgYXJyYW5nZW1lbnQgb2YgdGhlc2UgZW51bXMuCgoKPiDCoH07Cj4gwqAjZGVmaW5l
IFVGU19ERVZfSFBCX1NVUFBPUlRfVkVSU0lPTsKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMHgzMTAK
PiAKPiBAQCAtNDU0LDYgKzQ2MCwyMyBAQCBlbnVtIHVmc19yZWZfY2xrX2ZyZXEgewo+IMKgwqDC
oMKgwqDCoMKgIFJFRl9DTEtfRlJFUV9JTlZBTMKgwqDCoMKgwqAgPSAtMSwKPiDCoH07Cj4gCj4g
Ky8qIGJEZWZyYWdPcGVyYXRpb24gYXR0cmlidXRlIHZhbHVlcyAqLwo+ICtlbnVtIHVmc19oaWRf
ZGVmcmFnX29wZXJhdGlvbiB7Cj4gK8KgwqDCoMKgwqDCoCBISURfQU5BTFlTSVNfQU5EX0RFRlJB
R19ESVNBQkxFID0gMCwKPiArwqDCoMKgwqDCoMKgIEhJRF9BTkFMWVNJU19FTkFCTEXCoMKgwqDC
oCA9IDEsCj4gK8KgwqDCoMKgwqDCoCBISURfQU5BTFlTSVNfQU5EX0RFRlJBR19FTkFCTEXCoCA9
IDIsCj4gCgpQbGVhc2UgYWxpZ24gdGhlIGFycmFuZ2VtZW50IG9mIHRoZXNlIGVudW1zLgoKCj4g
K307Cj4gKwo+ICsvKiBiSElEU3RhdGUgYXR0cmlidXRlIHZhbHVlcyAqLwo+ICtlbnVtIHVmc19o
aWRfc3RhdGUgewo+ICvCoMKgwqDCoMKgwqAgSElEX0lETEXCoMKgwqDCoMKgwqDCoCA9IDAsCj4g
K8KgwqDCoMKgwqDCoCBBTkFMWVNJU19JTl9QUk9HUkVTU8KgwqDCoCA9IDEsCj4gK8KgwqDCoMKg
wqDCoCBERUZSQUdfUkVRVUlSRUQgPSAyLAo+ICvCoMKgwqDCoMKgwqAgREVGUkFHX0lOX1BST0dS
RVNTwqDCoMKgwqDCoCA9IDMsCj4gK8KgwqDCoMKgwqDCoCBERUZSQUdfQ09NUExFVEVEwqDCoMKg
wqDCoMKgwqAgPSA0LAo+ICvCoMKgwqDCoMKgwqAgREVGUkFHX0lTX05PVF9SRVFVSVJFRMKgID0g
NSwKPiAKClBsZWFzZSBhbGlnbiB0aGUgYXJyYW5nZW1lbnQgb2YgdGhlc2UgZW51bXMuCgpUaGFu
a3MuClBldGVyCgoKCgo=
