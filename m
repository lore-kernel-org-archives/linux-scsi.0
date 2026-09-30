Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0A638DC66;
	Wed, 30 Sep 2026 07:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753465; cv=fail; b=i9hy36STy9M0XqqRkP8uLtClZvwxdz7v5QDFfm2ykIZGPqc2MdsELMbKjY/A/qxnm0XlulyzVzuEUeurP2oPm6w2b4GRLB9cP16QpAHd0Nu7JfAe/FF3m7RQewVtJrNzM7OmIgInr+yyjJqtlUXxoF3V2WgkrYHL+65inB/H3pM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753465; c=relaxed/simple;
	bh=SmqmlpOjH99juZyBsYowusTn1HVWoCNFZIogV4SPug8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CAQLTsY2zrfvdLYb8DuNE0+MTe4AwyUafPhLd2lt3uLk7Fsf88Sf+0Q42E3LSFWoIsm3jCjl2h0w8bPMaQmU1jYHCo5oSHMWL7Xj2gwAAvbtCHqeyp0xoZW5Swq/RAtVZY2BpWHVVcvydlxtF1/8riKdJqzALhlSd4Lz4Z5ge7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=FvDPsMWu; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RUTYVM86; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FvDPsMWu";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RUTYVM86"
X-UUID: dadc58f4bca011f1b1788b6acf885367-20260930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:Message-ID:Date:Subject:CC:To:From; bh=SmqmlpOjH99juZyBsYowusTn1HVWoCNFZIogV4SPug8=;
	b=FvDPsMWuue8tWlMNjV7ZfP6jMnIwzntol4NmuIBkPd3HymTM4mEIwKRow2h/CXdtidZ6UjOCsDeL0GI/Tvy4fb4vHeFRHI+Bmrs4NKdDyn9HcVzoPP21GrkI5n9NQTRC8Zcv/4xd7ed4Ej9tf0WN2DpKJK5ay1LJWCIEV/FuFgc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:0801a60f-d052-4373-ac6c-1d4fce68db0c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:ad2eb458-f207-4360-abb2-8a360f715574,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|136|836|865|888|898,TC:-5,Co
	ntent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dadc58f4bca011f1b1788b6acf885367-20260930
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 771209858; Wed, 30 Sep 2026 15:30:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 30 Sep 2026 15:30:46 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 30 Sep 2026 15:30:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTWuoEqOU+/hElA+gjvOWaTkD5928kbXIjoIB/bgBJIZMT9gG/Jzis5Md4o6Hr1ThZpNR5S0KxHlYs5nuVC4fSelW7trLKvPhBPOBLXJST7KTxdgL2+qjXvhdDexechu4c5oS8Os7zEhKfeaD4/dBbdUhx3fl2kJHXU/jARFEyXNWNfws9YVI+Mm9hRFdrohC13xQNDAjL5a6KXFFZ2w+vdIIzlW01lKYk7HBGcweDcfzn4MjjJR3HUX6ehfeD3Z0wyq9D/EBe8d4pF/jTLvUOxMDk/4IqSBfEEwXw+oVnur6cQHeqoFLjjHpzQJ1YvZ5W73cjAY4aRQA5vL4Qj7rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmqmlpOjH99juZyBsYowusTn1HVWoCNFZIogV4SPug8=;
 b=YM9t/Mh+g+E/OcWMSjeJsWgBXaiafX4OxMQqi40mthLTIBeOiEo6fQ2/rE86ZTNiPv67qeGdZrdQn0nWkWwQYax8BtQ9rvnfG8KqraWfUaF9Wb+GcMko0HtwY0FlDV7t5DzgjZvFcewiqU7PJKas3sKOSxNz7ed3j/ObjQ690ROa3ZrJSOf/maZqg900k3WPBfEtlTEBwuwuarrIg9Nftm8y7g2I1gbBuUP8WlQsDxDiP813LKiOSEpZgCWjFTloCMpyCI0PrfH0wI+DV10z996DoUjbeXD+JCo0MNyZwvNZMZCIl4Gl7o1CCqvDEKf/uJNYAHSMcov3wXNs/ZlmfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmqmlpOjH99juZyBsYowusTn1HVWoCNFZIogV4SPug8=;
 b=RUTYVM86jSDyDrgw83PjjS0BNANeCXLDxwq1ODBgIuBFCljhfIGuCVxobVUJj2FsfrwfBPmE61ruqcmcSgdcdhW/etA5A8mOJuRmw13K1V8IOgUAmAMzqnVJm7CnBuX411CZZ0puPAGmlciQqgxFtQP+0F8wJ01IAGXxD1jWo5o=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB7277.apcprd03.prod.outlook.com (2603:1096:4:1d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 07:30:43 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%5]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 07:30:41 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <stanleyjhu@google.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K.
 Petersen" <mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Can Guo
	<can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
Thread-Topic: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
Thread-Index: AQHdUK2YCBu+MweWNk2uePNmKp5hwA==
Date: Wed, 30 Sep 2026 07:30:41 +0000
Message-ID: 4d761d64eda0700dd2321393e63e7e8e9052be1f.camel@mediatek.com
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB7277:EE_
x-ms-office365-filtering-correlation-id: 3eb5f144-ef29-40d3-966a-08df1ec4bb19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|10067099003|56012099006|11063799006|3023799007|18002099003|38070700021;
x-microsoft-antispam-message-info: N2qdC6CgEv1Fyk7/VieIK1YbPqCNr+aPWv9O/ZJNgo6ao/mGvVJ782mBSfVgmIwA0bQTDT9vuWhHCJKVvFchZrmK12YATwQdYXX30ie7o8Ra3CrBcZkG0hIsqE0fNZ6cl0XlHHa48RE5nhXd01iobju9TCXA7UC5ODax2hGZ+O7aCln/FrI+6XrlA6hl+UHgnW/Xq+RkjC68uJA0XUKlIrso5zNnc6gWVWrpucmzwl/zAe1ER4WZ6KAC/Wu06SZOH8CaJd2zJGJVtgx13r06S+Aq46m2ErecKZjcD8zC+Ok2exP/6CHYTkjfSwg3Hf+C9Y+sOJZeg+Pz59NQqsgI8b02OL3t74M400geCTBcwlSCGUU1H/K2O+rJrIWqq4dl5e0CK66FBWJC6pQAB+jtOu73uuyFUUBXO7hwiUuZ+6fWMzz9cYM3Cg887vM1BZnYYmk0ArDDqDtRMbWMW7pRQBtRebSZ/9GaQqv+IX3vjPZqKlNQztvoJ+zjCoMEbqmE5nPDJfPDO5t6qHtChDhfcWx3NrdikGfOuY2QARI63DlO7v+ohWhp02+CChhYVB6i9lfVNX4YJaYQFDn2Y41ydPw2+Jq48KoMzmgGT+/1OY0K5xAmy94kKimmbiROmZa9v6SjZ2vlZ87PpaNoRHklXJ5bx9QJNG4//pZ/SnX17U8V0gIUfntmKHNMRzIeyPLuC6tAOL2AWuw1zgkNEu6nc+/7BGa5fYWH/DQk63s/LSI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(10067099003)(56012099006)(11063799006)(3023799007)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWg4MWlvQXBpN0lVMVBSUlFsRDFzZ1REVnlFZUUzT3EzZGg1RUNBQjN5SG13?=
 =?utf-8?B?ZXY1NmpGZGdTZVFoL3hyRGZaRUIwNHVwK1Y3SndXdUlQaTlDWEVnSXE5UktT?=
 =?utf-8?B?S0N6RkU5VjIzY1F0OG5pMnFFQWhVZHpKV1hxRzN3clExbS94dmdHQytscVc1?=
 =?utf-8?B?WEVWcmZKa1NhRUJqQlJ1SHFpZ3pMTWZzWk9YUVFlVDNwWlRxU3gwcGw2bEV1?=
 =?utf-8?B?YWdDOXRyaUJWSllEbnhudHdqbUZnQ2FpclFHZGxSMlZQdnAzdTFvd3EyKzQ2?=
 =?utf-8?B?VitockxCNElIQlAvUDMwR1JwZ2ZQN1RVVzI4L0RTVG16Rkk3d0ZrbmZVOVlT?=
 =?utf-8?B?REF4ME1UYk9UNHZ2VnhickJHa0tNWWovTnZRajZ3Q043VHE5SmpmVDBHQWVT?=
 =?utf-8?B?VkF5UGhQZTdTdFk4eVNkK3JIN1VBYnViN3MvRG1NcUlHemttMFY1WWlEU2dD?=
 =?utf-8?B?MEdYSXhHOFgwTXBRbmIwOUxGNjFrcVQ2MENFandqY25SUHpFM0k5a1UrVUJn?=
 =?utf-8?B?UzJQeThIV01zL2VPQXB2YzNXZVJiUllkQkduVHdZSHh0Mzdudk1sZXpML1kx?=
 =?utf-8?B?dkl5cCtFc2FCS0hONWM1MENHZE1vN3g3R21tdTJKV21DTHZvNG9CSXZHWHBH?=
 =?utf-8?B?dm0vc2N6Wlp5eDNtSzlpdUhIUXMzM2R4bWRpRU51RmxBMERsTStnMkY2WFBE?=
 =?utf-8?B?TVlXQmJEOGY0VGR1UVVKT0I1T250QVBBRkQyeWkzbFQvNFpqaWF1dk52V28x?=
 =?utf-8?B?WnY4TVB6SzhxdXhBWkFTbWJvUmlEQjh6em1wVFhwS3pneUxPVEh4ZklKRTdT?=
 =?utf-8?B?SnlITzBFQXgrMUZwT0F2TzN6TTdnN2lxNTFoME95UEJZMnhPNytSdjIvRkZW?=
 =?utf-8?B?OVZ3S0FkMDdUcFZmeXloRWdhSXI5STNaOHdxNk4rTjNhYk9uV1JzOUkrYU1M?=
 =?utf-8?B?SlpCNEtramZYVE5tc3NtSWNuSVNmOU1XdEQvd1lId0p4YTNLZ3laQzM2RnU5?=
 =?utf-8?B?NzlIYlRnV3NpMDl5cXdjd2NNZ2hxbWxibGdyRzBGUmU1WHdiT1hDbk1LUGZu?=
 =?utf-8?B?LzIyUnh6ZHpKWkJ1aitMUXFLdUpGZG9DUTlDKzRCTVRVUnNXQXFIbmp2Q0hK?=
 =?utf-8?B?RG81YjcybnlaM2ZPRzF5KzBiZ3V5cVpaOGEyZnRyTHRQQlhrbmFJZHRnUFV6?=
 =?utf-8?B?YjBpZHc2bWpGRE5VcXU4ck5BMnlYRFdlZ1RCaXBMMHEvMHRxMk5Hc3lMTGJr?=
 =?utf-8?B?YWFWNnd0RDVrRnNUaktGS1FuZWhwUDNhcFhoUXcwaFdjRTY3YVBsWVhnK1ZH?=
 =?utf-8?B?UC8yLy9rMkhZU3Q2TVNERGd4UVF4aTZ5N3orZStSakxxN0xiUmY1UlZMNXNu?=
 =?utf-8?B?dVZmc0Jtak4wbUZwb01WM0RIOGpPVHVkUzNRMmdHbjdsbHVzYjdJcEU4azcw?=
 =?utf-8?B?Yjd6UXBUT3l5NEcrRHJ6KzRXNGxaY1VnV1d6SHBzV3FKa0dTVnBGVENZdnNu?=
 =?utf-8?B?ZHFKVkRhR0xYMjdncGU1L0I3OXVpSEkrNEphdkRSSWlYa0hFV0lzVkZncWdx?=
 =?utf-8?B?WlpzcGp5UGJRU2RSMnlDN0tEVHdKaHZaa0VaaXJ2SzJXbkhVZTZPN3Z4NUdR?=
 =?utf-8?B?eE1WQ1I2RFJZalRicG9SQXVSVnhmL0dpWVN2UEk5UVp4WTlSVWRPUXgzeG5r?=
 =?utf-8?B?ZGVZMHNJWXpOS0N3NmdSejBrZzV3R0hzUFdCS01qT0laR3g2dVR6ZVJYdUR0?=
 =?utf-8?B?ZExIQ0l2RDZBcXZoa2d4S0h3blptdng1S3dWTVFrT2tNZWNnU09KdGhPQVBI?=
 =?utf-8?B?RCs2U0RQNWpMR255WTJtMUduay9lSUNiUHJ3RVhWdkl4TnhMOW9YOWF2Vkpl?=
 =?utf-8?B?YmtIZE43d1BOZ1lBZ09kb3IwNEc2aGE1bUZLellUY3dXODhWVmZraWhNRHQ4?=
 =?utf-8?B?eU1NTW4wNXFMMnQrdFlzV2JMcjRMSS9sN3ZhME5NUU9pbklvbG9BRkR5Zm8y?=
 =?utf-8?B?WGlBcEFuRGJUaE5EdVdzMVUrQ1R1NjNFekRFQU0yMFZZSDI1UXp2OU1UZWcw?=
 =?utf-8?B?dDlnQlpvWVVBMGdJYTBhcUV2TDQyanVYbVMvYVQyRjI0Q0ZQeVlMUFpkajlz?=
 =?utf-8?B?RFFYV2lBd0hmVFZscXRYQnBBMEFxVG9IcjRYRmNRdUxScTBTdUJ3RG1ZdkN0?=
 =?utf-8?B?aS9CVDVvMHhPK3cvWmg2MUJUQldGUHE0UTJ1cFpYeS9XSDJRZGVQeDBDTzAr?=
 =?utf-8?B?MzZxbUZUS3JYaGI5M0djTVBkVElIeEFaOEdSUjZNNUZMdmFCc0x0ekhWNlBv?=
 =?utf-8?B?eFFJS1lQUlZmdDRGK0lMSk1LWmRaVGJiNHJBZ1NuWjVpa2JHNzRndz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: bCx1uvVKiP0lrWCI7B41PjHQvmDUEUoCsrJ1Io8YQkkV3BZXFxMFVumn1nutad7jsyzKsuhv1nqtN+v9i3mi9f8zRb2Y4Ri3ANvRhi5PcNpRmQGnUOdvPY+f6WaBdjTOjJxMAz+kf5tE2Ik6HmRiiWr6IJLNsQ0Zil3M9SVoWRADZByeaH8IsZ4uu1LuQl6KEK3XBf25fiEZIjelmuEsbsAArWJqnA2ufN1VmdHHF4NWfzzoXUxn5+rIe0T+1DgQ3nM6R6nhcDm+H/sr2+wn6VUSGQQaIVm1HgS3VMu4BQvUJ1j2XBcXjFad9BHng2XxyaU+Od51USGNY+WipTPvuw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb5f144-ef29-40d3-966a-08df1ec4bb19
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2026 07:30:41.1229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xtcBgzDET56IYGpthgxe5jrEv+xA90mFarze25B32YAXpIt7+B3eoDq1wij+ywhiGYqvaOJ+JsrkRx12zb3XQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB7277
X-MTK: N

T24gRnJpLCAyMDI2LTA5LTI1IGF0IDEwOjI2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gQSBjb3JyZWN0aW9uOiB0aGUgSU5JVF9MSVNUX0hFQUQoJmNtZC0+ZWhfZW50cnkpIHN0YXRl
bWVudCBpcyBub3QKPiByZWFjaGVkIHdoaWxlIFNDU0kgaG9zdCByZWNvdmVyeSBpcyBpbiBwcm9n
cmVzcyBiZWNhdXNlCj4gU0NNRF9TVEFURV9DT01QTEVURSBpcyBzZXQgZm9yIGFsbCBwZW5kaW5n
IGNvbW1hbmRzIGJlZm9yZSB0aGUgU0NTSQo+IGhvc3QgcmVjb3Zlcnkgc3RhcnRzLiBzY3NpX2Rv
bmUoKSBza2lwcyBTQ1NJIGNvbW1hbmRzIGZvciB3aGljaCB0aGF0Cj4gYml0IGlzIHNldCBkdWUg
dG8gdGhlIGZvbGxvd2luZyBjb2RlOgo+IAo+IMKgwqDCoMKgwqDCoMKgIGlmICh1bmxpa2VseSh0
ZXN0X2FuZF9zZXRfYml0KFNDTURfU1RBVEVfQ09NUExFVEUsICZjbWQtCj4gPnN0YXRlKSkpCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsKPiAKPiBIZW5jZSwgdGhlIHNj
bWQtPnJlc3VsdCB2YWx1ZSBpcyBpZ25vcmVkIGlmIHNjc2lfZG9uZSgpIGlzIGNhbGxlZAo+IHdo
aWxlIFNDU0kgaG9zdCByZWNvdmVyeSBpcyBpbiBwcm9ncmVzcy4KPiAKPiBCYXJ0LgoKVGhhbmtz
IHRvIEJhcnQgYW5kIFN0YW5sZXkgZm9yIHRoZSBkZXRhaWxlZCBleHBsYW5hdGlvbi4KSXQgaXMg
Y2xlYXIgdG8gbWUgbm93LgoKVGhhbmtzClBldGVyCgo=
