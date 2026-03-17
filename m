Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545B234404F;
	Tue, 17 Mar 2026 06:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773730189; cv=fail; b=GAEeE201Tc0l5GanloveA5WUvOeUSp7PqA/Yc0fvR5osN7ixYIhCJqb/NyD7egAM8gqaMSWJ78HdrtVWHRaFojN23ADtsB5lffSaRy6+7wQXzBh6RZGYU3SF675IK999W0CuvajD45bG1Ob1Ye0Y88NLbK05vBjVv7pcIdhtLFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773730189; c=relaxed/simple;
	bh=a95MwrWMHGp5LbDEiRLTdTrOB6Sbemup4Rx3XBiWaiE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Af0HRlSdJtYQLLJv5z9Lnx3ww8qi9fdx5OXb2d/4m9ovgGXD1NTNYkpPYIoKqH8nBKrdTvwd+MbNTlqcPtTnwVl/4dAm0sfSzMIG6IzOF8mtcWQu/6KUXyhDsp2Q/LOe3uj861LCJlSmiQj18j81h1hoZY0WZ2LphW0qvcUienY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gYJEhUhg; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=pLFzAcxf; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gYJEhUhg";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="pLFzAcxf"
X-UUID: 6e045ad821cd11f1a02d4725871ece0b-20260317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=a95MwrWMHGp5LbDEiRLTdTrOB6Sbemup4Rx3XBiWaiE=;
	b=gYJEhUhgURESDnl1yFSpusbb10Fz3wPwaJKoiFXtsrKCDzJYlKL1QLsbyZmQxodmN/YqUxFV+h2fVzxPUc7KVd0zQOIP2tFufhosPCdRgbiqhQxpJxC5kEecl+YyNurBef7A2PFaMQrJkKOjLyZPMUK1j4JKEMETex94zXGBiFQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2e839851-abb3-4fac-a17d-cd3a40ac290b,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:10c77616-77dc-40b0-853c-db53c3132fbc,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6e045ad821cd11f1a02d4725871ece0b-20260317
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1684040891; Tue, 17 Mar 2026 14:49:22 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 17 Mar 2026 14:49:21 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 17 Mar 2026 14:49:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JAwoON/atvL2dAWW/uZs0yKFZZ1hzs5lsh8gEsrpR9SbqW7+RXpuYGFPluXEvoEAq8Wv18W7b7udHfxITmsrOa8lX1d8fhEl58dvNfMYwOYSxYtdujg1Y16GHOFG6PYmN6VbGqqjn9povv5KkjkEUKisfLC7fUZDn+m1hl0RsJhb/XLwPYhuEijewFhAzynPINgcIRdpkXf9ij+RaqDAfTvk0OUbtkJOeN0xhykCflxth9NgED2ZDdIHXcsoEaWQgxjgCxNd+EM3b40YkoBUQlvzfh9HwX5S5khlwYncFqBh4IhFNz6LEjOG+xsMv10WGp5yFgk12TYvyY92gHW8rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a95MwrWMHGp5LbDEiRLTdTrOB6Sbemup4Rx3XBiWaiE=;
 b=WA/3h+ugH591LNy5pF02EtKYrbv5a5gLUNERxQnJns2ldZgA6jKowSIp5sYKPAao5wqKfVJdC5AOAEsh9FgsafmcwjXgNAWPpxqxkKQYzis0pmGUGzl9UHxSoqs2yqA0bZRa8sZnjKZsXeNcSyt3/ZcFup91HHi7OwrbvKN4/MCDJNYCoZHDKtRPWKMdkMOF8zGolLQ2N//Z7X01IBl2lKHiEkbfs6WOxtjR656nO31DEq9t3VGGSQ9yAfZOc5j9n3weBDaKDyb5ECwRHgLRRY1SN8p3E0Akj4UlD7IcMW5SepjxWn1OBIiOpSVlOH61RbI5Gs5aCH6fwVP8SPepYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a95MwrWMHGp5LbDEiRLTdTrOB6Sbemup4Rx3XBiWaiE=;
 b=pLFzAcxfAq18BOeTYe0QVy6kA+ylCkDpTGGdfD+0ynxv+CnOwmLvUuzprpvj1/s4o2tZgGJBHxvQkRRlmhggBJclEyamlmLKQkpmDB0cRLk5das4566NUKHQFOiqZklIMi5HCuDnW/wpCTk5GJWDwhrE7wZfunwPXhj+zlPfpaw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KU2PPFFA0747153.apcprd03.prod.outlook.com (2603:1096:d18::433) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 06:49:17 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9700.025; Tue, 17 Mar 2026
 06:49:17 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
Thread-Topic: [PATCH v3 04/12] scsi: ufs: core: Add support for TX
 Equalization
Thread-Index: AQHcrw5m3AJ+eCzqYEGMTPJE+YMrfLWyVjsA
Date: Tue, 17 Mar 2026 06:49:17 +0000
Message-ID: <42587e16218f1c51dbcbe6bb1639a843e10bcd80.camel@mediatek.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
	 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
In-Reply-To: <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KU2PPFFA0747153:EE_
x-ms-office365-filtering-correlation-id: 5e4d4a78-8573-4d51-7da5-08de83f14f54
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info: LIHmZx77LNu/+cZcGdbX67YxXoKi/pSufL+B9lga4WAqZ/cA8GVcKZ3hJ6tGh8gn9yOi9TyGKADU0xF5nPfpzbh0tYfXGQX1gLIK1+Csqiq/Lp0gP0i7xuzyjyQa69593InbYVJXzMpfKVGMlqGoTykL+ZspU0+zYv2uEhT0jP73MRSLfjZOaSAMCzR3bEu4wCXXRXjkMgmV2KeDS5buQaScPoaCCjAri5Yj4lV0SPpdUMS+c1TT9aX2LS366lN4LpKznv1FvCSJ6DAaRJS9sLOoYjvzVvAJHFhqDpREvVqMQ/AOiQWdu+/JVXSIP8sMQmDMT3lZZctxzDAvc3alBfNsp4byaMGue/FXyxED7T4XF93e9WPDLsUgDDn4ZpVKIToqz1VeWfYQxrBpjAj/V8a2zrJsjo/YbksJlWWz3JsSRVRLvHQAAzs52X8+aWFgcEIY6NrJZ2R9msUNxZTagfLXdKqjXe0YH7osx00Fl32PKDAH7Sk6hDPrK7Ciz94toTiFDl4MU0TVxWAX4sZosdniiGvbXLGD2joU43uRCMWy59deorwVvxmtZXyRoXLmpj14LX0LTztdj32YR0E86YLaYfP7ATw2298wl6N1+36EXhESTO+hcn23pBui36x+NPrDYcVZ4yufJkaLRNoecZXmMqB7RR9rNUaZ2pj8wmdzvvsUaRk7YBEAZ62dkLArR13Zvh1+ElnRwiVb6RosfGbFz/ZZt8znG9BbIi66yEbHqzf7Sg7f27z8aQnh9uARBZfvxokkI/dQ4+zN8M4+2MQmFQfZNcJ9cOuIn6gr7BY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0ZmZFJzajExYWVJelhlWkNoeXRDTy82L1B0STNZaUR4a1hWWUZCYmYvbUY0?=
 =?utf-8?B?YlVPNWtxMGxZYThscExZUmo4S3p0bFJhamZBTm5FeTd4NHVkWm1OVDNMZGVK?=
 =?utf-8?B?NithSC80UzNpTXF1Q1Z0MUQvbE1tc28xKzBaTUZBTTUydGNLcFlkeTFzanFN?=
 =?utf-8?B?UWtVaDRNTDFBL0prdCtWUndDc2VPa2s2dEhaK3ZXdDZXYVhrNHF0bGZLMWlR?=
 =?utf-8?B?SHpSUWwwRlJRbUNBdmtSUGxISCswc1Rva0YvN3pRVDg5N2xoZnZDT3NZZXBK?=
 =?utf-8?B?YmcyV2ZPc0VGQThkRFQzUUdRZkFZNVg4Y3FsWWV2ZTNGeGhGV1oxakc3bGg1?=
 =?utf-8?B?b1didUpRTHg1TC9VQjYwUVI5djI4Q25OZlpnRGpjMFEzYjAvM1JyVGl1aCtn?=
 =?utf-8?B?bEFuVS9KRExZKy9LMGM0WU11V3IxUUlXa1dxanJlN21oeVphM0plaHgwSWlT?=
 =?utf-8?B?THdEdXl1WFZmcG9SRzU0dnB5Y1VOVktrTitEdFVuZFIzM0Y4bzhoc3hKZGhZ?=
 =?utf-8?B?QVZ3QndXM2NIMGQxYUJpN1pTU2ZhZWRSRE1kTjQ3dk15Y08wT2dWUFJMbzho?=
 =?utf-8?B?K3hocE8rVk5mSEtscUoxM2hlcG5ZN2JyS21OTGNqbVdIM3ArN3hLUUNmSlBN?=
 =?utf-8?B?UUh2ODFPd0pHUi9vOVRuaktRM1lzNEErb2FvYTRHNGlkWDFkaXplN3RNMm5X?=
 =?utf-8?B?VC83Z25tY29GNHU4eGJYbG5DVWpiMjA1aEhQQkcvbys4STliK2FabUtud3VK?=
 =?utf-8?B?aEhDbk1Kd1N1ZStGWUNMcXFsZW9EbHZBTXE0akVoakhnb1dvR2huWWROY3ln?=
 =?utf-8?B?dktWbXZnaUc4TWlxMDMrN082ZkZWMzNDTllPdVI3OU8xWWl1d0N5bUFpYTgw?=
 =?utf-8?B?RDdjbnJkS0NpRkhZcU1CbDV5L09HOGRCb3B3Z0lMR1htWVVJOC9xNEFLdUhO?=
 =?utf-8?B?a21lVUFGdHYvZ0ZzZzhCV0IwaUVRVWRabG1lOEJ2bzdEMTl1QmFINDRCQTVZ?=
 =?utf-8?B?NDhNbWZHd0s0clJKSDd2ZTdUY0o3SHkzOHIyTG9idy9sZmNXQ2ptM05PYVRO?=
 =?utf-8?B?czVaYWNmZ3A2bDh4T2w3MitTK2d3UkxOZ0FTYjJFYzIyTldyUzNoRzNCYkR2?=
 =?utf-8?B?SUFHSXNTN1NrQ0MyQnNQYkZ2QzdOMVBxTFdSNXVMUTUyWlhuRmhCM1kvMVNB?=
 =?utf-8?B?K1R3TWRMVUV3cWZRV2J4ZzVYNERaRWt1UFgwTzh1bGthbHZTOHhOeDF5b1ZB?=
 =?utf-8?B?Ri94NlkrR0FpMVJpRnZSUW9Ba0hKbWJxM2xERjVGay83NE9UUUtUc2R1VmhW?=
 =?utf-8?B?a2IwWDJ4Y3FaWk1pRGpUM3phMjVXdWlCRWpCWWs1dDUzL2h2RzBUVGdhcUdM?=
 =?utf-8?B?ZHBFcXJjVHNoUm90a01icjVsTkRKMWpWcmhyVm5Tc0djVlVra2FjSUFtTGND?=
 =?utf-8?B?Tmk1OUNZQjMwdzAwUjZaRk5wK3diZHpFczUrbjB6WTNYcDNPdjJzem90MndY?=
 =?utf-8?B?RWxqK2tKUSsxZVJsVVFwd2hYaW8xZVk1M3l1WkUzNVBZUDBYY3VyaVowU09l?=
 =?utf-8?B?UGNudTRyZytnbzBNNGN6dkh4a1RSd0lmNExqM09ZbENMUHRCNG4vVms5RXBX?=
 =?utf-8?B?Q1k3SFllNncweHY2aElXRExUeTRlblNyVDhsUVhKdUFJWUtRc3U0VmFIYXZK?=
 =?utf-8?B?T2Vlem9sY0g5SlpnWUtPekladUNvSThYOFEwdlB1ODJ3NzlPVnpDODR1WU11?=
 =?utf-8?B?Smd0SDRuMW4xZ2NjdnRZdHFia3h4U3BlSkJJc2lzSHV3YmhiN0swV3hCSnI1?=
 =?utf-8?B?MDBoWjlOMDVSbjJvcXRqM21wcW9rR1ZKQ3ZzdnJYQmdsY0hlMXpGblNtQkdl?=
 =?utf-8?B?SytRbFRDanJ6UERObFJ6SU84RU0wcG5RUUtuUG8yd0JIakYyR0sxWXhiZzJp?=
 =?utf-8?B?c1pVRFF1bXZEVCthc1pDUFRCcEpaSzA5K1lUVzljS1htSzRqRUNCUjYvWFJh?=
 =?utf-8?B?ODBnRmlLTlY2cGJSYkV3aXpBc090ZFBwb1ZISnpwaDd5RXFQVGY5SERiUmkz?=
 =?utf-8?B?WDlkZmlBN0t1emlZTWRpSFRmL2hZR1NjRlBTMTdUaDlFaXhtSXFUVXkxbWtk?=
 =?utf-8?B?bU9vOXFJaUd0Qk01VmFVbTdzSWlVczRHTDlVYkc4N0pXajE3T1NTZnpqZnNX?=
 =?utf-8?B?a0RqQTNVRHJvSnQ5Wkxwckh5VjNTT0thR2FucGZ1WTdNVUxQQUFlTGw2RHlY?=
 =?utf-8?B?ZFRFZlN6WlJNVHJ5cWhrZldlWFFpS1oxQTlkY05jT3pkbERNR0hyRnd0MG5V?=
 =?utf-8?B?ekdMTXFqUVN4djhIeTdrOXl5RnEyZkVTUEw1ZWZnaC9lcUlmMlFldE00OFdl?=
 =?utf-8?Q?lFwR7Rp1Du9mYJn8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A04E6281C160FA4F87764BE892E1AA2C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: rvgc0Yj1GciSxVIMnD5aGn+Hqn6YuDvIk2xlvMhy1yWMCnNzF4AMv5PN2hs2Fer9CCs37kH+uhrMiHurNzsHduiK34+fne52RdnNTQr+0kwiiugaOZGpL1MOBkOiSomqhg90ijRi3MjR6mv1kueMOF9pPTzKOXNi7qmgBrj6nzZw51bTv0l7Xty7S9jVeflK1jyEHnTexbuz3NwvsRusMgsfdCFCPirVgtI8uqpsn6XIEwm/++doBktSp5o/rHKgop78GjfLSPHkN97/WAgFu/8rHAYkxQXhin3g5rAG3a9pDWb6wcNGfOSGJk9t1Z+PlwBgiTiixSbhe0RJKYniJQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4d4a78-8573-4d51-7da5-08de83f14f54
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 06:49:17.4028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Js2EeDpN6K6szT7b2EFg3WjF4wMFg+RtjaOVLF+eB3URi1Anpx58KRXlW7xbi47AaUj+SOvwlnVPSYxxM4eUqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU2PPFFA0747153
X-MTK: N

T24gU3VuLCAyMDI2LTAzLTA4IGF0IDA4OjE0IC0wNzAwLCBDYW4gR3VvIHdyb3RlOgo+ICtzdGF0
aWMgYm9vbCB1c2VfdHhlcV9wcmVzZXRzID0gdHJ1ZTsKCkhpIENhbiwKClRoZSBkZWZhdWx0IHNo
b3VsZCBzY2FuIGFsbCwgbm90IG9ubHkgcHJlc2V0cy4KT3IsIGhvdyBjb3VsZCBtYWtlIHN1cmUg
dGhlIGJlc3QgRk9NIGlzIGluIHRoZSBwcmVzZXRzPwoKPiArdWZzaGNkX3R4X2VxdHJfcmVzdWx0
X2V4YW1pbmUoc3RydWN0IHVmc2hjZF90eF9lcV9wYXJhbXMKPiAqb2xkX3BhcmFtcywKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Ry
dWN0IHVmc2hjZF90eF9lcV9wYXJhbXMgKm5ld19wYXJhbXMpCj4gK3sKPiArwqDCoMKgwqDCoMKg
IGludCBsYW5lOwo+ICsKPiArwqDCoMKgwqDCoMKgIGlmICghb2xkX3BhcmFtcy0+aXNfdmFsaWQp
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwoKSXMgaXNfdmFsaWQgYWx3
YXlzIGZhbHNlLCBjYXVzaW5nIGEgcmV0dXJuIGhlcmU/CgoKPiAKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyogU3RlcCAzIC0gQXBwbHkgVFggRVFUUiBz
ZXR0aW5ncyAqLwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByZXQgPSB1ZnNoY2RfYXBwbHlfdHhfZXF0cl9zZXR0aW5ncyhoYmEsCj4gcHdyX21vZGUsICZo
X2l0ZXIsICZkX2l0ZXIpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAocmV0KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfZXJyKGhiYS0+ZGV2LCAiRmFpbGVkIHRvIGFw
cGx5IFRYCj4gRVFUUiBzZXR0aW5nczogJWRcbiIsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
KTsKCkNhbiBkZWVtcGhhc2lzIGFuZCBwcmVzaG9vdCBiZSBwcmludGVkIGFzIHdlbGw/CgoKPiAr
wqDCoMKgwqDCoMKgIHJldCA9IHVmc2hjZF92b3BzX3R4X2VxdHJfbm90aWZ5KGhiYSwgUE9TVF9D
SEFOR0UsIHB3cl9tb2RlKTsKPiArwqDCoMKgwqDCoMKgIGlmIChyZXQpCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4gKwo+ICtvdXQ6Cj4gCgpUaGUgaWYgY2hlY2sg
Y2FuIGJlIHJlbW92ZWQuCgoKCj4gKyAqIEBpc19uZXc6IEZsYWcgdG8gaW5kaWNhdGUgd2hldGhl
ciByZS1uZXdlZCBzaW5jZSBwcmV2aW91cwo+IGl0ZXJhdGlvbgoKaXNfbmV3IGlzIGNvbmZ1c2lu
ZyB0byBtZS4gUGxlYXNlIGNvbnNpZGVyIHVzaW5nICJuZWVkX3JlbmV3IiBvciAKInVwZGF0ZV9y
ZXF1aXJlZCIsIHdoaWNoIGFyZSBjbGVhcmVyLgoKCj4gK3N0cnVjdCB1ZnNoY2RfdHhfZXFfcGFy
YW1zIHsKPiArwqDCoMKgwqDCoMKgIHUzMiB0eF9sYW5lczsKPiArwqDCoMKgwqDCoMKgIHUzMiBy
eF9sYW5lczsKPiArCj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3QgdWZzaGNkX3R4X2VxX3NldHRpbmdz
IGhvc3RbUEFfTUFYREFUQUxBTkVTXTsKPiArwqDCoMKgwqDCoMKgIHN0cnVjdCB1ZnNoY2RfdHhf
ZXFfc2V0dGluZ3MgZGV2aWNlW1BBX01BWERBVEFMQU5FU107Cj4gKwo+ICvCoMKgwqDCoMKgwqAg
dTMyCj4gaG9zdF9lcXRyX3JlY29yZFtQQV9NQVhEQVRBTEFORVNdW1RYX0hTX05VTV9QUkVTSE9P
VF1bVFhfSFNfTlVNX0RFRU1QCj4gSEFTSVNdOwo+ICvCoMKgwqDCoMKgwqAgdTMyCj4gZGV2aWNl
X2VxdHJfcmVjb3JkW1BBX01BWERBVEFMQU5FU11bVFhfSFNfTlVNX1BSRVNIT09UXVtUWF9IU19O
VU1fREVFCj4gTVBIQVNJU107Cj4gCgpEbyB0aGVzZSB0d28gcmVjb3JkcyBvbmx5IHN0b3JlIHRo
ZSBGT00gYW5kIGFyZSBub3QgdXNlZCBvdGhlcndpc2U/Cgo+ICsKPiArwqDCoMKgwqDCoMKgIGt0
aW1lX3QgbGFzdF9lcXRyX3RzOwo+ICvCoMKgwqDCoMKgwqAgaW50IG51bV9lcXRyX3JlY29yZHM7
Cj4gKwo+ICvCoMKgwqDCoMKgwqAgdTMyIHNhdmVkX2FkYXB0X2VxdHI7Cj4gKwo+ICvCoMKgwqDC
oMKgwqAgYm9vbCBpc192YWxpZDsKPiArwqDCoMKgwqDCoMKgIGJvb2wgaXNfYXBwbGllZDsKPiAr
fTsKClRoZSBzaXplIG9mIHRoZSBzdHJ1Y3QgdWZzaGNkX3R4X2VxX3BhcmFtcyBpcyAyLjJLLgpJ
dCBzZWVtcyB0aGF0IHNvbWUgZmllbGRzIGNvdWxkIHVzZSB1OCBpbnN0ZWFkIG9mIHUzMi4KCgo+
ICvCoMKgwqDCoMKgwqAgc3RydWN0IHVmc2hjZF90eF9lcV9wYXJhbXMgdHhfZXFfcGFyYW1zW1VG
U19IU19HRUFSX01BWCAtIDFdOwoKVGhpcyB1c2VzIHVwIHRvIDEyS0Igb2YgbWVtb3J5LiBJcyBp
dCByZWFsbHkgbmVjZXNzYXJ5IHRvIG9jY3VweQpzbyBtdWNoIG1lbW9yeT8gQ2FuIHdlIHVzZSBk
eW5hbWljIG1lbW9yeSBhbGxvY2F0aW9uIGluc3RlYWQ/CkVzcGVjaWFsbHkgc2luY2UgRzEvRzIv
RzMgYXJlIG5vdCB1c2VkLCBhbmQgRzQvRzUgYXJlIG9wdGlvbmFsLgpPbmx5IEc2IGlzIGFjdHVh
bGx5IG5lZWRlZCwgc28gd2Ugc2hvdWxkbid0IHdhc3RlIHNvIG11Y2ggbWVtb3J5LgpBZnRlciBh
bGwsIG1lbW9yeSBpcyBleHBlbnNpdmUgbm93YWRheXMuCgoKPiArI2RlZmluZSBQQV9QRUVSUlhI
U0c2QURBUFRJTklUSUFMTDBMM8KgwqDCoMKgwqDCoMKgwqDCoCAweDE1REYKPiArI2RlZmluZSBQ
QV9QRUVSUlhIU0c2QURBUFRSRUZSRVNITDBMMUwyTDPCoMKgwqDCoMKgIDB4MTVERQo+IAoKVGhl
c2UgdHdvIGxpbmVzIHNob3VsZCBiZSBzd2FwcGVkIHRvIG1hdGNoIHRoZSBjb3JyZWN0IG9yZGVy
LgoKVGhhbmtzClBldGVyCgo=
