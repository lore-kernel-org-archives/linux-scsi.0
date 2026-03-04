Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F8B394781;
	Wed,  4 Mar 2026 09:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772615563; cv=fail; b=iJtJ9mBQq7S+Ig6DGIbfSy1KqJAF+FqSAzR0P8COqWMusIz/yDD2ERMZ+pkAFhQ/vBzlC7AH7KvgenOMsuocKV9eWNEgagjD2kpkK91Ns+5MM5qYihtHl5Qqx+cJlWAfoiXWHthqn7VtGH2d8Ru5nl/TnVm4E9koO3MEiHEHQoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772615563; c=relaxed/simple;
	bh=X3W3qgXwW+zLLGh8LDezb002jPnoee0PrkZwTvGIHLs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BNDlUP2RMQlSfzkOQDkEZPozJvfROvNA/Pepoymrdo9BMlvc8+IMVpUptNqtN8j9RKZwtZvnsRUAr8vpRezvy3h4frv34RnzPew6z8drkwsVbFZNcFZplFCT/A+DAYNoBYZ5WXGf+LGvWsdgJZ++pVBDJY8Tf7yIcjYAIo2HHIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ESzwKG3H; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Mxg+MrVI; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ESzwKG3H";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Mxg+MrVI"
X-UUID: 45d8ed1217aa11f1bcd7499a721e883d-20260304
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=X3W3qgXwW+zLLGh8LDezb002jPnoee0PrkZwTvGIHLs=;
	b=ESzwKG3HAVEDqiwPBV1gG6agoTbXX7dtST/x16Qr0H7wmb9C7Ds9w4vB5E3bc5ykWMaziace0Bid3G5+UYBt3Q7M/izC99bn1YGtpHVZA8YAJ4CEyPz2WVso6NBYTAlGBb3u5KwXFEaYLcZ3eQ4aph5Cc2FB3E29W/p7/NdYAJs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:49136274-26fa-4233-91e0-11888dd5aee0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:b4a73ff1-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 45d8ed1217aa11f1bcd7499a721e883d-20260304
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 657297389; Wed, 04 Mar 2026 17:12:30 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 4 Mar 2026 17:12:29 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 4 Mar 2026 17:12:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbcFU6bwnYSRKB/S0W9s6nt3P7o8KzcTSAwNz1hbPLxgf55pplG82k5vtPIdH3Cib3WFk/bQS+V+ZqU5vKr9UKtLJfO5sWOEp7MSIV77zwFxG6CuaJ78t4qDctcNlO6er0/aSrFikgJPQEmck+pzCXbmNGVKIKeJTeBYFPp+3vrxJQIVnQ7NZkwKTv05d3nMPHmGP+X2J1mpZ5zz7cqRH4dWbrYU547CC1K/h9oMsNyXX7JEGSvf4V/5HN7CEUD1N18o54SuL2eP85Cp0kIP62CTCdBPnfQaiZwhnom9cIC//RvG3KJr8FKgOpLWi4hd5t/nFQtHWg5OYky4nI0HQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3W3qgXwW+zLLGh8LDezb002jPnoee0PrkZwTvGIHLs=;
 b=V8xukzBsNZJUNNZ3Ai20XXfeXmUgbrQr/gWQCQEw4vQkzy0z4N/qDO6gU2KvJ4OT9RLEabyIjGUqLU4emMlqEtSVtNn8DpVQ+4+FsuTkUnhehbxgvN2wL9D3y1R1ZUPiihhlhedwTvv/cOSOsu5VaGMzS5nwSYJfe+0g+IjgYO+AYgsm/omRPXFdyu80e/f36+qhDs1ihBYLIwFRbFzPd27sxounDobvxGCNRMXiwznWt735DHsY9d/fH36+19UBY36JECOrEkzBJHf8xM/xUUNdznuJYJPq8j6t0kjS6iTN6GmEdCBTMU6T3Jy7DmqhnjS1Mzjowun/v9bXS8RjtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3W3qgXwW+zLLGh8LDezb002jPnoee0PrkZwTvGIHLs=;
 b=Mxg+MrVIAe6SM2gJXhWuGI3R7hmbMdHKXPisryh/XIKKsmCXDN2/EbLI0wT0u8YibIk3etiIkg7T7a2yDw5yTyRD8rCKUPgQUwgpJqD9IMXAm89F4Twmf4oe/rWZd6VyH5OJme+unzkIMnf3sID2iiVxluGEOyOo727rNxX8Zzs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB9534.apcprd03.prod.outlook.com (2603:1096:101:2f4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 09:12:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 09:12:22 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>, "huobean@gmail.com"
	<huobean@gmail.com>, "ram.dwivedi@oss.qualcomm.com"
	<ram.dwivedi@oss.qualcomm.com>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "chullee@google.com"
	<chullee@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Add support to notify userspace
 of UniPro QoS events
Thread-Topic: [PATCH v3 1/1] scsi: ufs: core: Add support to notify userspace
 of UniPro QoS events
Thread-Index: AQHcqXpZVY+KKHbJdUmUSWZGgRugnbWeGw6A
Date: Wed, 4 Mar 2026 09:12:22 +0000
Message-ID: <f5e4e0e44b071fb355a2900e2b8c9ef504fb15a7.camel@mediatek.com>
References: <20260301125116.808992-1-can.guo@oss.qualcomm.com>
	 <20260301125116.808992-2-can.guo@oss.qualcomm.com>
In-Reply-To: <20260301125116.808992-2-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB9534:EE_
x-ms-office365-filtering-correlation-id: 7a613791-9a36-4130-fb1c-08de79ce24db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: VAgXaAHG+PySOhPtDcvFAh8w5iKTZ0Xh+U0IU5WyqLZ3rdRGF6zCa0dnTHjAzpjMz15Rbjt+VoShLVbjq8ATntQ8kRj0H0Ot4mwcMkyGTzxAgTgq1N+YRE+50u/YOZsrYMP1hrFQ5deOTbhQqBKCwxv7Y/q9sMeQHevvZtdYssqFcGyeIGinv1v63fmJ4nkw4WLWDozn6KHEvkZ3svnqZ+I3p4lbwlY+U0k5C9vkHBN+s+hDzrijrq3UATpskey1xs/Rwn8id/+vLq55XnM2Ivf1y4o16I4CJhnxsb0QNB9W4584B+Sj762mhnb436sWAGdGMCKdGnonvueqtA7qOYkmo32yPkSVxptMMf+YLQr7hmiAWWsgBg0MKXB+UCxe9RS9iXNevo/5Tkrrrb3vu7YD+I6m2/cg0x/HzUjntkkAXa12Zrz/vxQNmimOC2eJp7dW6x5Hm6K07VmVSfAXriqbW6UTEHViIl4DFsMu8iwqhucO/Z7buUYVNQzcQh/aQxQDMuqi2mgdVWaJUHG3BJplUwdbiPQpevWxJlBHWqbkiujcQG6MbzyzmpFAjuEAmP24fstCEP97MFrF9L7e3KHLJdUBu1OFMNRxx48iuRVZhFIGurEN+0CtbW9vLMX8OpgCPoiTdOk16ZiHPwRkscpdemGw/MDdTdKc7NfAPXLbNdNPx7xiXgEoOGMFm11EDC2481oEUUI5jCdeWIRtx8SisHts2+8lTlNVhYGgTbannpw8S2VlbhVhxWIrll3es/vdtuotUKIadf1Qs6zZp/mcGZ/X3ltcK+u1a07hznw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zk9zdjhOUEtCaTBoQk5kNDY4Y09IZE9WQk1BdG1JSG42d0x4d3NVY1BwaTda?=
 =?utf-8?B?VDhLSlNXSjFha3ZjMVhEaE5zY3VERlhiREJYY1ZzVGsyNmRuOVJUVWV1TjNh?=
 =?utf-8?B?MTlseWNZaTFBa0U4cWttR1VuTXhOTkZJNnJoNHNrd1VtejcrNk9JMS9BUWpB?=
 =?utf-8?B?bEV4Y0FXV1MzZlZlVW5ST2lLeFZuV1A5OUhGVmVVSktITThUc2g3OXovTHBX?=
 =?utf-8?B?d2dHZDZWajJsUGFKdUVHQVhHQXhUYk1MNjdua1hGaWpvMHAwWmNQeHhML1lU?=
 =?utf-8?B?RjVqQmdnNDlxRnp0TGhGK3lOdXYzVVlCTC9xelRzWXRwSWN3Q28ybUMxNERl?=
 =?utf-8?B?VlVWUUxkOG5Kd1JsREFpSkE1MjNiTUlPNXJjeTBCUjFEaE1hemQySGwxYVFR?=
 =?utf-8?B?ZWFyY3BIcmVabzNkTWhtUmIybEduUkZFSFB4RWZYTE4vV2c1a29qS3MrUC9Y?=
 =?utf-8?B?OTIvUTVSbnNNemN0ZlBhWnlKYnpkclBGN1lmNXdPLzNsY09BMzNSZklVUEdO?=
 =?utf-8?B?V0loOHA1RkxxZ0owWVo1NWFjRXF2WFMxZFUzR2ZoejlOTWNzU1BTRHJNU1lG?=
 =?utf-8?B?UTN0MDkwbkVKOUZmaFM4TVlBV09Qb2FkaWhoRjFJRlRwZE8zMjZsUUo3MWha?=
 =?utf-8?B?MzM2Ujk1bFVRZG9lU1Uxc01qYmRUbklmTmZoT1hYYVJzSXVQUURqdkMzVFBY?=
 =?utf-8?B?eXhyNFBrS045alJQZG9Rb2JTL2s1WVhaRGxzUmx4VDF6TFhURktaOUtwbjhi?=
 =?utf-8?B?NkNyMGcxRXdDVERBUnBiSkhwL1JCVldCbHdIT2EzYnZLK0xyUElxakp3SlZy?=
 =?utf-8?B?ZXVZREloeVovSWdaNVV0SVVUUGFoQjFlODRMSG0zWmpGUHVpelIyait5ZktS?=
 =?utf-8?B?emdhZzJXakh1SzZ5czNHL1A0bnkyUTNud1JNV3Fkd1ZBRWNkeHNYK0VET0Q1?=
 =?utf-8?B?RzFDVHNKQzdMTm50S01ady9SdCsvSm5xSFpmMys0bWhRY1RjTXRidXZ6K3Z2?=
 =?utf-8?B?d0lCck5KSnBTaE9rN2RxWjJDWXp0ZzJHS2dQZ2tBTUwwbSsrTTREa0NEVXRr?=
 =?utf-8?B?OGRzTG81cC8zMW5rMzRuTHlVUHhmNkJjU0hWa3lZNW5sK083aGMxT2pCZ2hL?=
 =?utf-8?B?SDlPeDh3ekVDRlJpUnAvMlBtUHhUbENEMXJqZjVUZDkzcEtzQ3FYSThJc2FO?=
 =?utf-8?B?eVRSRVdJUWxFeWs5aG1KUm4rQk1keVFRZTJVMCtnRTRMbllwdkxVa1ZzSDdW?=
 =?utf-8?B?dFIwZFhGdnFveU5mMkE4d2V1SHY4VVZvbnExbmEwYkpFc1h5NVMwaWhlR3pD?=
 =?utf-8?B?UkdPcmIzczA3NERZcm0wVDRFNk1sczBobzREQ00vb3N2Q0dBR0U1VWR0c3FO?=
 =?utf-8?B?VTRQM21ORDNBdVg3UmEwbXJYRkYrTSt0dmlsS25WSVl2bGhYTm9BUmVaVTdN?=
 =?utf-8?B?ZlFNT2Q2Z2lUVDlteExyN05SUVRld1puUzRFbVAwUWE4VWJrM1dSZHRqTGhJ?=
 =?utf-8?B?TkVNaDRmdkdoV0hjdTNLY3pYSy91eG9QMkNQZnlqSFdna3JrdFRScTk2T2tW?=
 =?utf-8?B?QnUzaDUya3o2UHZhRU8zbXg3RXVtQi94SHBXb1UyNHNaaWxZWTZReUN6eW9w?=
 =?utf-8?B?bTNpSnJibFZ3ajJ2VzF1TTNjUjh1KzByQW9mV2xYZVZXMVBrbzVQRkNUQWJ0?=
 =?utf-8?B?VE00ZEtma1AvVlhBcDNZVVpMM0ZUMm1YcmRabDIxSnkrRDhydkRCVENGc1d0?=
 =?utf-8?B?TnhkWE5vM0IwSGhjcVdtVVVXR0hOMm5aNndoRUtqSm9rNUFCMGJmbjlYbHFV?=
 =?utf-8?B?R0tBcU9GQk8wSjBKMWJCc2pzaVhoNDVKN0RUM00zTjdKUHBwY0VFMytaTEs1?=
 =?utf-8?B?UWZielhrVlRKMzUwUFpBeVptamFpU3lQWTlsLzNyTkZYTk5xWG5ickwrMEht?=
 =?utf-8?B?ZGcwMVVUMzB3bkMrckhrSlJER2VPY1VsTXpnc3RXL2svbVduVUt6TE9USmN4?=
 =?utf-8?B?dVhLUE0zaHJiRmNVSTNKMTBZdWVMOWFDRllQTlU0NVpodk5LaEZ4MXFQRGww?=
 =?utf-8?B?Rk1xVGVxQWtQRy9PbDRHKzNTZUdQUU45eGxIS3pNODNmdVNmZFZyZ2wzcU1m?=
 =?utf-8?B?ZE9pemZhWFNDTWREc0lFckMyZm1YaEtwcmZETXdOY1M1Y1dpNnJxNUI3amh4?=
 =?utf-8?B?bndPYUh2bUFEb3VxRmtydC91WndRZ25zSmlnWERhVmNxM3VLNGVSTkcwWXlP?=
 =?utf-8?B?R1FLbDQ3MFFCVTJqWDdxMGlUQjJ1MkswR3BTZDhRU2hMNWdFU1lsa0M5Q0JQ?=
 =?utf-8?B?aDJ6N0gvd1pNaWlqejI1eGM4bm1jWmMxY1pCeHhBb2NWUEFrM2o0ZEJaWjli?=
 =?utf-8?Q?mXqlwWZU2utwD3bA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <610034D6D772D14BBA730E97FB738DC2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: fGjZ/stiZr1myTjLlpFhtlsqUGVeh1AFuD0D0gp9euAbmDcCzJ+qeDfGDbseii6s8TJtEWhaQn2A6ISDjWhinUKyWqmHot+j5DQVximBP2bXtUwc+yBxDbPg10ZkV8WjpNzgWZ8QB7/8XFFpcJoceGTIhfoOOYLBRJqv+sqseqmBVa6jbgzplNjjfgZn0tl/9Q992hBwxvcACwxpVXJ0+2Y0b67ey3a90ENS7e1qIxlW17YDBxzrG+DdPpjAECoXJEkgNrc9hHwFOSoZz4hpWTXHw5ZjGI0K5yeaMb8axNdKwwhnc4TrjWt1TEbtlRbsm+urNRL67MNn8FjBQ8j/lw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a613791-9a36-4130-fb1c-08de79ce24db
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 09:12:22.1709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g0iJ3rtYrhjryl6pQT6BUH5z3iB+Jfmx+DgoGXOMAS+6ymcWhk1Hi35FktvNqP5mDfrbTQK2OeJDSTG9K3tQlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB9534
X-MTK: N

T24gU3VuLCAyMDI2LTAzLTAxIGF0IDA0OjUxIC0wODAwLCBDYW4gR3VvIHdyb3RlOgo+IEBAIC0x
NzY4LDMgKzE3NjgsMjYgQEAgRGVzY3JpcHRpb246Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgID09PT09PT09PT09PT09PT09PT09wqDCoCA9PT09PT09PT09PT09PT09PT09PT09PT09
PT0KPiAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVGhlIGF0dHJpYnV0ZSBpcyBy
ZWFkIG9ubHkuCj4gKwo+ICtXaGF0OsKgwqDCoMKgwqDCoMKgwqDCoAo+IC9zeXMvYnVzL3BsYXRm
b3JtL2RyaXZlcnMvdWZzaGNkLyovZG1lX3Fvc19ub3RpZmljYXRpb24KPiArV2hhdDrCoMKgwqDC
oMKgwqDCoMKgwqAgL3N5cy9idXMvcGxhdGZvcm0vZGV2aWNlcy8qLnVmcy9kbWVfcW9zX25vdGlm
aWNhdGlvbgo+ICtEYXRlOsKgwqDCoMKgwqDCoMKgwqDCoCBGZWJydWFyeSAyMDI2CgpNYXJjaCAy
MDI2Cgo+IEBAIC05MDk3LDYgKzkxMDYsMTIgQEAgc3RhdGljIGludCB1ZnNoY2RfcG9zdF9kZXZp
Y2VfaW5pdChzdHJ1Y3QKPiB1ZnNfaGJhICpoYmEpCj4gCj4gwqDCoMKgwqDCoMKgwqAgLyogVUZT
IGRldmljZSBpcyBhbHNvIGFjdGl2ZSBub3cgKi8KPiDCoMKgwqDCoMKgwqDCoCB1ZnNoY2Rfc2V0
X3Vmc19kZXZfYWN0aXZlKGhiYSk7Cj4gKwo+ICvCoMKgwqDCoMKgwqAgLyogSW5kaWNhdGUgdGhh
dCBETUUgUW9TIE1vbml0b3IgaGFzIGJlZW4gcmVzZXQgKi8KPiArwqDCoMKgwqDCoMKgIGF0b21p
Y19zZXQoJmhiYS0+ZG1lX3Fvc19ub3RpZmljYXRpb24sIDB4MSk7Cj4gCgpSZXNldCB2YWx1ZSBz
aG91bGQgYmUgMD8KCj4gQEAgLTExMTYsNiArMTEyMSwxMCBAQCBzdHJ1Y3QgdWZzX2hiYSB7Cj4g
wqDCoMKgwqDCoMKgwqAgaW50IGNyaXRpY2FsX2hlYWx0aF9jb3VudDsKPiDCoMKgwqDCoMKgwqDC
oCBhdG9taWNfdCBkZXZfbHZsX2V4Y2VwdGlvbl9jb3VudDsKPiDCoMKgwqDCoMKgwqDCoCB1NjQg
ZGV2X2x2bF9leGNlcHRpb25faWQ7Cj4gKwo+ICvCoMKgwqDCoMKgwqAgYXRvbWljX3QgZG1lX3Fv
c19ub3RpZmljYXRpb247Cj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3Qga2VybmZzX25vZGUgKmRtZV9x
b3Nfc3lzZnNfaGFuZGxlOwoKV2h5IGlzIGRtZV9xb3Nfc3lzZnNfaGFuZGxlIG5lY2Vzc2FyeT8K
V291bGRuJ3QgaXQgYmUgc3VmZmljaWVudCB0byB1c2UKc3lzZnNfbm90aWZ5KCZoYmEtPmRldi0+
a29iaiwgTlVMTCwgImRtZV9xb3Nfbm90aWZpY2F0aW9uIik7CndpdGhvdXQgY2hlY2tpbmcgd2hl
dGhlciBkbWVfcW9zX3N5c2ZzX2hhbmRsZSBpcyBOVUxMPwoKVGhhbmtzClBldGVyCg==
