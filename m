Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6AE19D894;
	Fri, 14 Jun 2024 06:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718346875; cv=fail; b=ttfpRC9vXN3zzIpY3+1K82jGFpBLrqxmFmCl94E+Pp28cB8ipAtjfnxiJ5DC31+WRi+SYrdJ4q0clmezU4ZofjKWGZcWBGwaU1WLeyyzXwl6Avet1lcVWlE+wDOgHmE3vMNTiFQDPldwgFXCWg0VJNzhzN6Rx6c9XWZSH/KZZmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718346875; c=relaxed/simple;
	bh=LM4ZzTdU41pAkgLbAwlSlwbhd8cL4CqkC1lL/N10wxk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cn7WfTQeRyi/SRxd+wikZD1FXYiFO/bnMgLWMY7oT0JX7yzJ5pRIZdfK57d6IimfucNRAKibVhUgX2IvlZNpNmfefpHEQTBdM3BIekdEESSTly69nG5xrLHkO+TR1QloU1vDVlrB/Qpw7dkMVZi182IHpx6JNwZ1/kEPJ2Z/AvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gWDCt+vn; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=vVansb+l; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gWDCt+vn";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="vVansb+l"
X-UUID: 271fc3cc2a1811efa22eafcdcd04c131-20240614
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=LM4ZzTdU41pAkgLbAwlSlwbhd8cL4CqkC1lL/N10wxk=;
	b=gWDCt+vnCMMIbYcd+aZLMZxHgIhXM/2bLn+yfE7gwjwIYmR16dv1bnC2BXzP5C4hX2Tdn4blMJpX69ZnZMqupxG0qP+qYdkyHEkVmfYLLm/+y5cYkHIT9zUQJTwpUuU/WZbytwYCzYEpyjWA5t4+B84tNQycz537kCGClYcJA3s=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:f4f6c925-ea3d-47c6-af5c-1ac155e917ef,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:b557fb93-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 271fc3cc2a1811efa22eafcdcd04c131-20240614
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 836077683; Fri, 14 Jun 2024 14:34:29 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 14 Jun 2024 14:34:27 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 14 Jun 2024 14:34:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bin47tt1p7mehKe+MYXg4KxTZbFvEoMHqpnknYl1TUz8orpvg1HGAiLrqk3CvN5ISZOaHCErXVNtHWHaKIGbTPOdBJaWKH8PeuqYxQK38+EnDux1oRSieUmlNNpGhG4fIZqVcE7V5CS1hP7ruHRL0NJ+FafyRCqkw8KhgvC/7EZ7MmW+GNbngN5xiFkrjpYGMzKndvj11USiG+iafbOmFby6daJGtZrYji0NS6/D/Vm3U/7tM0DEPJv2Drr8Zgzw9h1nO5Qps+o1RgQkXs16ikFryhNgbPaKfk8HGgJE7xLQUDUjBPYfVHn1Sdm2UUBEOi8nd4vE32kFmQDdotC3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LM4ZzTdU41pAkgLbAwlSlwbhd8cL4CqkC1lL/N10wxk=;
 b=MQI5etogtkQvEZf670DhQps5IIkO36Iy+lnql+dr9R6i+cPmD+QF5+3tXbDLrTk56xiFuV2LH+ePDDIZHDeBK6QxuEGwNcBlGC3aZw1M9U7IvcBwU+W+5/h/IDjRXBTqSYR0w59lsF7GGRJDqnzvJMgRqlTcJPWD4vIAC1SeOxur9iEL1Y6hT2OVEOMjdY9hi/pIxvr9r64VvwySM1GgozuOxBNQ685FGt0MS1dpZX752jJf7wfb+AULjqZ7URJfeOOOy+QGeq9/ckmJ5q8J8G4hvnhVMZeQ56UG84M7vUNt+2AH0KFcGrT45zIorpUzsEnnCR2gV9X1sBhOKHNl3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LM4ZzTdU41pAkgLbAwlSlwbhd8cL4CqkC1lL/N10wxk=;
 b=vVansb+l4qSGk+cVpNAS0f4K+VyjNhZ8tPvfPSt2s6hZ4KwdezHY8pqBJlcTqfGC9gW4IvuPP2Aq62B/eWR28BhXl37mAnmkUVXXopDJj7HFrnPDM6tUvhf9rl2vlBrbhoGtvAZMVQb/X0Eop0MZDhFo7vNejqfmck9DpvieoPo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6597.apcprd03.prod.outlook.com (2603:1096:400:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 06:34:25 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 06:34:25 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"wenst@chromium.org" <wenst@chromium.org>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "broonie@kernel.org" <broonie@kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "michael@walle.cc"
	<michael@walle.cc>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"robh@kernel.org" <robh@kernel.org>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "krzysztof.kozlowski+dt@linaro.org"
	<krzysztof.kozlowski+dt@linaro.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>
Subject: Re: [PATCH v5 3/8] scsi: ufs: ufs-mediatek: Remove useless
 mediatek,ufs-boost-crypt property
Thread-Topic: [PATCH v5 3/8] scsi: ufs: ufs-mediatek: Remove useless
 mediatek,ufs-boost-crypt property
Thread-Index: AQHavJxJPpATA7yBPE+L/yI6PCX/TrHG0JOA
Date: Fri, 14 Jun 2024 06:34:25 +0000
Message-ID: <eb47587159484abca8e6d65dddcf0844822ce99f.camel@mediatek.com>
References: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
	 <20240612074309.50278-4-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20240612074309.50278-4-angelogioacchino.delregno@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6597:EE_
x-ms-office365-filtering-correlation-id: ffc7677d-0d08-4bf5-988a-08dc8c3c090e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230035|366011|1800799019|376009|7416009|38070700013;
x-microsoft-antispam-message-info: =?utf-8?B?OWdMY1dWNEwzZG1JbDdWWU15aCtRWDhNVVZySGp6Ykd0eitYTXhvL1JLVVQ4?=
 =?utf-8?B?eFVSbGxaWmk3RitzcFFJR1NKK2l4VFpjQkdhNnFkY1dyV2dTb0s1ZDhGRlY2?=
 =?utf-8?B?M0x2OG1mUWJJR2tlb3E2WVVjeWdaU1YxYUxiNUtHaG5UK2hFRHJzSFU0RnFZ?=
 =?utf-8?B?UXlmQW8vdEU5WEtTUHFCOFZMeTNiSHZ3SmdteTZIMlFxT0Y3aG1wWWY5T0ty?=
 =?utf-8?B?NExzUVdSbUJjbTJiVXdQRVRLdFpuKzFLUHo0V0FLQnV2eG5KVTJxUWRUZFNs?=
 =?utf-8?B?S1FpSXYvSHJTRjY2eW0weUJpRUMwT0hCREIwVHRpN1h4NWtObXFTQnlweVp6?=
 =?utf-8?B?NlBDaXdtOXJiRTE0U3R5dEZhdmIyYXRFd21jclBIU0tXUGVnNHJBWE9wOXh1?=
 =?utf-8?B?MkpRUUZVSXFLYTNsQitpNWRVREROeVA3dCtjOUFhYVB1VXVDQTlRT1poeDlS?=
 =?utf-8?B?ZVlwbytucWJCTWtueDFxd0VWaE40clJpRXM3M2JMTGZLdTN5VjdDcC9rM3Vj?=
 =?utf-8?B?SzdHUEZWOUd1b2MwNXdZQ0VJMlk1bXFHYUF5dVhBN29oOWJzQ29Oc0pHdTJo?=
 =?utf-8?B?aWxONjUrd2g1OU1hTk1HeDlhZ0pVWnhYOTA3azRwTm1JaXVzbDJDR0RSS2tS?=
 =?utf-8?B?MlRUNkZUUlVUSFFMOTRCM3VTOEdCbGRxQi9XazRMRzVFUUREdWh6cjFIUmND?=
 =?utf-8?B?N3l6Tzl2WHZUYzFwTlBQUjArNUtvdGtOZHcrbTRCcHZKVEJHdnhqQjkrQ21s?=
 =?utf-8?B?ZmNYSWlWTlI0c2FJME4zS1E3Qjh3aGFiM2VUSlBvU3R1RURkRU5sSGxIV1pZ?=
 =?utf-8?B?SDFpa3dMUEFxdmlzWVhHYmVpL0JPYnRNaEZZYzAxbk1wZDdjVTZ5Rkh0d3RO?=
 =?utf-8?B?YndpT2UzRmtBZnNkVTNiZndqenNMSldjcW1oeE5aU0xXTFc5dUhrUHQwRUNQ?=
 =?utf-8?B?d1dEMkdBMVE3T1NYTUNLZWVJWkZ3WFdhMmxIcnJJQmdaUWlhZlpKaHo2L0hs?=
 =?utf-8?B?WUtobjN2bEVhZGlRSkRIcGdsaFBKU1FxbzdBMEZEM016Y3M3ZUFHc1VHMjFM?=
 =?utf-8?B?TUdlZEFDRHU2ZGZvdXRRL3RxT1hCZ2FDZjRTUlM2dFRXWmc2eElCa3M3TG5t?=
 =?utf-8?B?b29oNnJONkNHOVpOZ2QzU3RRWkJiSndwWEU0ZERZWmphdmJpREx5WUk4ckFt?=
 =?utf-8?B?aEJvNE5PYlR1RSttdkMrSWtmemxuZHA1Y1ZEVXdIQjBJamRmd3pjN3NnSVRv?=
 =?utf-8?B?Y01uaWh1cE9zYkgrT1NtYnpmckozUnJnUkFnT2t2cXBJQlVDMkF6R2YrWGlF?=
 =?utf-8?B?TSsxbk0yT0lYTlpVcGdZSDBROFk5VUNLckRTekJLb0pNbHhlYXZpeE1RUXpv?=
 =?utf-8?B?cXl3OERQUm1JakRTV2R4TWIxdXJ1Q3lqaXN0VnQ0dWZqcmd2OGdFQkFoM1pJ?=
 =?utf-8?B?WWZRaTU0VFI4Y3FGQ21QckVyYnF6OVU5dlNUOWtnSWliclJRZ01MdW5VcC9S?=
 =?utf-8?B?UTVzQWZwRWpuN3dXQ1NSdGswS2FXRVRDcUpHSVZvakUvL2hsN3FFNnRwY2cz?=
 =?utf-8?B?eHM5L3ZkaDhaaVBLcGpXU1kxUzlYVW5melhrZXZoWlFKVTVvaTgyRnFrZ1pk?=
 =?utf-8?B?TjN4SmlxQmd2YlI0cnM1WDg0cGVpb0dpcFh0UTM4UnMwZW5Qa1RrM0tEeEZI?=
 =?utf-8?B?QUNEanpmNXcrZzdjQmV3QTVkUDRHNU9WZnp2cjV4ZVpCWVJUOFdUellOT0FU?=
 =?utf-8?B?UU0wZSs1aFVDSyt3em4xa3dXa0o2ak8wTk5uRTRPQXRIbU5VUFhPQUx6dXk3?=
 =?utf-8?Q?z//sp2oC7I+hXUPzGpU0naveHylFZWalcbXT0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(366011)(1800799019)(376009)(7416009)(38070700013);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDhwVDZ6dVRORTlPL3F0NmhDd1V0VS9tRXgrQTlvL21kQWNQT0t4K3VvRlh3?=
 =?utf-8?B?bHJWSWlLdGY1VGkwYU44QmFiYjBkQXpVR3c1K0kyM3JHWStRZUtDZUt4bll1?=
 =?utf-8?B?V2lsTkNyaXd5b2pHR1NyQVpsSEY5U01vZFY4N21pYlJTRHZUeHZnY0lsblRq?=
 =?utf-8?B?cHcyZTZ5a3pFWmVIN2dObzUvRVpRVVdnUGF1VHl4dUhUeGlselJMU3NQMkd4?=
 =?utf-8?B?R1RlQVdFSytBN3BaODF1QVdFTmF5eGV1R1NnUk1pU05tNC8xMWtCV0NuN0hm?=
 =?utf-8?B?cmZBQWZNS0hZSTI0bDBNemp1Rk1DQms5eDR0UEEyR3dyeHVsVUFoYUhFTFN6?=
 =?utf-8?B?Y05jVEFkWnhvbFpPWDU4MFM1L04rV2tJZEI0Tk5rRG1ZR1hWeUhodlhNTEJQ?=
 =?utf-8?B?WXhENVN4V2p6ZlVNWjJrWGp2U1JZczhoclhwc1BjMlZ0MGc4ZmRERHJNSzVS?=
 =?utf-8?B?eHZRdGVpTmtJdW96OUU0amttaDR2b3lubGVCcThPZjdKdzIwdjJNYk0rTmZm?=
 =?utf-8?B?TVRkdmNMV3ZiYUpvOVU2OUFsWS8xdkg5c21QUGtJbVBCWU02eVo0dWQzdElD?=
 =?utf-8?B?Y2tXczRtejFmTnl0TmdzNWxzbkZ0Q1hPeWpOSGVmWWl4c0RQQlRyNDRWTzMx?=
 =?utf-8?B?K2ZzdGd4MHZ3dXFyOXlwSUhkbnVoRVhPb3dFNzl1d3A2SWg0Z1F3WW5MbllR?=
 =?utf-8?B?VDNDMVQwcDUwVUFGckRHK2pPaGZvY1dFcVU3SkxpcUJCbnpqYVhSS3U0K2lH?=
 =?utf-8?B?aVlOdG9lQlU5Skd1U0s4K0pJRXV5ZEM0YlZMQTE1QzZnZFJHZWdRSnVzUW5p?=
 =?utf-8?B?bkZwaGI5MVpYaFBQMWt0bFJXRDdzTEFiYk5xK3pHbUc0M1RTcUhFV1FYNE1P?=
 =?utf-8?B?L0lQZWYvTGQxRlJOTHJ5Y0paUlN0d2x1dGdyUVRHK3ZRZ3FsM3d3SkpsTTRY?=
 =?utf-8?B?VkIrKzllQVd6b29kVlA4Nnk2NU5BZ3pJdWYvVGhjUUJOR2RaMnVtSWRzWnZT?=
 =?utf-8?B?QmhDL2h4bUhscVdJbjAxUHdMUWptbDRxcFQ1d2Y4OUxydGJraE9tT3dhcnhX?=
 =?utf-8?B?TWF0MUNnak1SVm4vMG55OFBiYUxMSGZST2VqRXdxaDYrNk5FWnpNYWJ2WUF6?=
 =?utf-8?B?ZHlaT002bTV0K2ZqNm9tNDRuVFl2VGFWOE5Ta2ZCM3VmWnlrRHFqUEU4VVQ4?=
 =?utf-8?B?eVd6eGNyczdxTUdmNm1oUXF0VTNDa1JFOTlhSkE4TVE1YnpQSWtJTHNsR2NT?=
 =?utf-8?B?RllmUy84bXdaRWVsQU80ZGoyMmZucVRGZnAvcE50c1dNb25zZTlZK0YwdG5Q?=
 =?utf-8?B?VUJ6YTkzckNvRWpGeFFOT0QwWGh6MTFUYjcya09pUldHK1E3SFcrS055bkdt?=
 =?utf-8?B?MUh2eWNTVHh0WEtLN0ZRUGpQOEZQbmdoQktNU1BsYVRsdzBVM3psVmFFZnM2?=
 =?utf-8?B?cFlTNW9LZCtLa0hzMTFmOVpObm4yOVVHT0s0eUZRb0FXQWRhVUlRYVByeDJx?=
 =?utf-8?B?M0RsMXJmeUtPZWVqbjlQUGNva1ZpMVNFRFZPUnpIN3lubStrZmV2bkNxUk9n?=
 =?utf-8?B?TmRGTGMwdlBDenN1djh2MlVJV2N5UzdpUUU4cmhqTndVZ3pETk52SU0vbnc3?=
 =?utf-8?B?R3MyRUZ3MVJyTlkvTnh1UExMZjZ5ZFdzNDVEcVVXWlZWK2wyb0RJYWR0ajhs?=
 =?utf-8?B?eUoyUUFhOUxRK0cvTnF6YmRES2U2TDBXQzByN0FzaktQL3pvSkNxZ2kxKzky?=
 =?utf-8?B?REVmSFAwaDRwYnowbWVTc2hVUDV2SmNrR2FEU0JRSGFkaldlemxFZFFkY2d2?=
 =?utf-8?B?Vko1M1NtWTdmdjY0R1BXZnFjMlE0bXdad3F4ZWNlSm9ab01QaFArbEZKamND?=
 =?utf-8?B?SURwb216cjBTMEZSdEhIM0FaYjkzNXU0UVZUMkY1WXRZRTAza29LS1JxVzhI?=
 =?utf-8?B?ZlF1ajc5RTJHcG5uS2M1T1QxeFpJbkZ5VlZKWnNKalNSME1HaGp6N095WXBt?=
 =?utf-8?B?STl2OWExaFl4akdDMDYwYjM5R1VSWGh4MzE0ZHhtcEp0L0ZaK0RxM0hMZ1lF?=
 =?utf-8?B?ekQ1T3hoT1hjajh3L25hREtNUEVNV0tQWWxlZXlPMGMxYll1TllRZEF1ZGMr?=
 =?utf-8?B?UDhSQ0xFQ2dhY2d6OXU0SUQ0RnZqY25hdVdKRDJiWnRrVndnOWJka2xvUWNY?=
 =?utf-8?B?cHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81DCE0D021DE91488FEDE7F5B2B9A4E2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc7677d-0d08-4bf5-988a-08dc8c3c090e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2024 06:34:25.7503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EjXS0WAUwIcjpi2fwm//Y9adtPyuHsa7ytd/AUkMRhOk4vb48QDJswuMd6gp0h86tUHrm3TOt02m1AXR1iIffw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6597
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--10.434000-8.000000
X-TMASE-MatchedRID: gIwa0kWWszLUL3YCMmnG4kD6z8N1m1ALjLOy13Cgb4+qvcIF1TcLYBEX
	WgyXQw/xEtDxvbZ9TpwKzukrjRISELnuANUvLzt6ZJkHIcEn4m3CUVFtj6SUoA6QlBHhBZuwk82
	bVam9OVpVdlnqdWZ3OazHhA5MoDSvmV0RTJuS03wXrP0cYcrA20yQ5fRSh265CqIJhrrDy2/q0j
	L31aMKiwovLqYDUaWR1FSbfEOqAoa2hsS3l/En5OEbUg4xvs+wQfvCwHnjjjCykL7HJ0lm45iF9
	1oJeq4SgyZRw3+XwTuRk6XtYogiatLvsKjhs0ldVnRXm1iHN1bEQdG7H66TyH4gKq42LRYkknA9
	kDuzCafdXN/ISsG3/y7CBZZpXqhmvJjsE3fCmE5+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.434000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	6C975C195E1EF753480FD404F7A4AE928E41F592587F747583DC0039DE68D8922000:8
X-MTK: N

T24gV2VkLCAyMDI0LTA2LTEyIGF0IDA5OjQzICswMjAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gVGhlcmUgaXMgbm8gbmVlZCB0byBoYXZlIGEgcHJvcGVydHkgdGhhdCBh
Y3RpdmF0ZXMgdGhlIGlubGluZSBjcnlwdG8NCj4gYm9vc3QgZmVhdHVyZSwgYXMgdGhpcyBuZWVk
cyBtYW55IHRoaW5nczogYSByZWd1bGF0b3IsIHRocmVlIGNsb2NrcywNCj4gYW5kIHRoZSBtZWRp
YXRlayxib29zdC1jcnlwdC1taWNyb3ZvbHQgcHJvcGVydHkgdG8gYmUgc2V0Lg0KPiANCj4gSWYg
YW55IG9uZSBvZiB0aGVzZSBpcyBtaXNzaW5nLCB0aGUgZmVhdHVyZSB3b24ndCBiZSBhY3RpdmF0
ZWQsDQo+IGhlbmNlLCBpdCBpcyB1c2VsZXNzIHRvIGhhdmUgeWV0IG9uZSBtb3JlIHByb3BlcnR5
IHRvIGVuYWJsZSB0aGF0Lg0KPiANCj4gV2hpbGUgYXQgaXQsIGFsc28gYWRkcmVzcyBhbm90aGVy
IHR3byBpc3N1ZXM6DQo+IDEuIEdpdmUgYmFjayB0aGUgcmV0dXJuIHZhbHVlIHRvIHRoZSBjYWxs
ZXIgYW5kIG1ha2Ugc3VyZSB0byBmYWlsDQo+ICAgIHByb2JpbmcgaWYgd2UgZ2V0IGFuIC1FUFJP
QkVfREVGRVIgb3IgLUVOT01FTTsgYW5kDQo+IDIuIEZyZWUgdGhlIHVmc19tdGtfY3J5cHRfY2Zn
IHN0cnVjdHVyZSBhbGxvY2F0ZWQgaW4gdGhlIGNyeXB0bw0KPiAgICBib29zdCBmdW5jdGlvbiBp
ZiBzYWlkIGZ1bmN0aW9uYWxpdHkgY291bGQgbm90IGJlIGVuYWJsZWQgYmVjYXVzZQ0KPiAgICBp
dCdzIG5vdCBzdXBwb3J0ZWQsIGFzIHRoYXQnZCBiZSBvbmx5IHdhc3RlZCBtZW1vcnkuDQo+IA0K
PiBMYXN0IGJ1dCBub3QgbGVhc3QsIG1vdmUgdGhlIGRldm1fa3phbGxvYygpIGNhbGwgZm9yDQo+
IHVmc19tdGtfY3J5cHRfY2ZnDQo+IHRvIGFmdGVyIGdldHRpbmcgdGhlIGR2ZnNyYy12Y29yZSBy
ZWd1bGF0b3IgYW5kIHRoZSBib29zdCBtaWNyb3ZvbHQNCj4gcHJvcGVydHksIGFzIGlmIHRob3Nl
IGZhaWwgdGhlcmUncyBubyByZWFzb24gdG8gZXZlbiBhbGxvY2F0ZSB0aGF0Lg0KPiANCj4gRml4
ZXM6IGFjOGMyNDU5MDkxYyAoInNjc2k6IHVmcy1tZWRpYXRlazogRGVjb3VwbGUgZmVhdHVyZXMg
ZnJvbQ0KPiBwbGF0Zm9ybSBiaW5kaW5ncyIpDQo+IFNpZ25lZC1vZmYtYnk6IEFuZ2Vsb0dpb2Fj
Y2hpbm8gRGVsIFJlZ25vIDwNCj4gYW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEu
Y29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgfCA1NSArKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tDQo+IC0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMzAg
aW5zZXJ0aW9ucygrKSwgMjUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRp
YXRlay5jDQo+IGluZGV4IDIzMjcxZWIxYTI0NC4uOGQwZTdlYTUyNTQxIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hv
c3QvdWZzLW1lZGlhdGVrLmMNCj4gQEAgLTU3Niw1MSArNTc2LDU1IEBAIHN0YXRpYyBpbnQgdWZz
X210a19pbml0X2hvc3RfY2xrKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGNvbnN0IGNoYXIgKm5h
bWUsDQo+ICAJcmV0dXJuIHJldDsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIHZvaWQgdWZzX210a19p
bml0X2Jvb3N0X2NyeXB0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICtzdGF0aWMgaW50IHVmc19t
dGtfaW5pdF9ib29zdF9jcnlwdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgew0KPiAgCXN0cnVj
dCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCj4gIAlzdHJ1
Y3QgdWZzX210a19jcnlwdF9jZmcgKmNmZzsNCj4gIAlzdHJ1Y3QgZGV2aWNlICpkZXYgPSBoYmEt
PmRldjsNCj4gIAlzdHJ1Y3QgcmVndWxhdG9yICpyZWc7DQo+ICAJdTMyIHZvbHQ7DQo+IC0NCj4g
LQlob3N0LT5jcnlwdCA9IGRldm1fa3phbGxvYyhkZXYsIHNpemVvZigqKGhvc3QtPmNyeXB0KSks
DQo+IC0JCQkJICAgR0ZQX0tFUk5FTCk7DQo+IC0JaWYgKCFob3N0LT5jcnlwdCkNCj4gLQkJZ290
byBkaXNhYmxlX2NhcHM7DQo+ICsJaW50IHJldDsNCj4gIA0KPiAgCXJlZyA9IGRldm1fcmVndWxh
dG9yX2dldF9vcHRpb25hbChkZXYsICJkdmZzcmMtdmNvcmUiKTsNCj4gIAlpZiAoSVNfRVJSKHJl
ZykpIHsNCj4gLQkJZGV2X2luZm8oZGV2LCAiZmFpbGVkIHRvIGdldCBkdmZzcmMtdmNvcmU6ICVs
ZCIsDQo+IC0JCQkgUFRSX0VSUihyZWcpKTsNCj4gLQkJZ290byBkaXNhYmxlX2NhcHM7DQo+ICsJ
CXJldCA9IFBUUl9FUlIocmVnKTsNCj4gKwkJaWYgKHJldCA9PSAtRVBST0JFX0RFRkVSKQ0KPiAr
CQkJcmV0dXJuIHJldDsNCj4gKw0KPiArCQlyZXR1cm4gMDsNCj4gIAl9DQo+ICANCj4gLQlpZiAo
b2ZfcHJvcGVydHlfcmVhZF91MzIoZGV2LT5vZl9ub2RlLCAibWVkaWF0ZWssYm9vc3QtY3J5cHQt
DQo+IG1pY3Jvdm9sdCIsDQo+IC0JCQkJICZ2b2x0KSkgew0KPiArCXJldCA9IG9mX3Byb3BlcnR5
X3JlYWRfdTMyKGRldi0+b2Zfbm9kZSwgIm1lZGlhdGVrLGJvb3N0LWNyeXB0LQ0KPiBtaWNyb3Zv
bHQiLCAmdm9sdCk7DQo+ICsJaWYgKHJldCkgew0KPiAgCQlkZXZfaW5mbyhkZXYsICJmYWlsZWQg
dG8gZ2V0IG1lZGlhdGVrLGJvb3N0LWNyeXB0LQ0KPiBtaWNyb3ZvbHQiKTsNCj4gLQkJZ290byBk
aXNhYmxlX2NhcHM7DQo+ICsJCXJldHVybiAwOw0KPiAgCX0NCj4gIA0KPiArCWhvc3QtPmNyeXB0
ID0gZGV2bV9remFsbG9jKGRldiwgc2l6ZW9mKCpob3N0LT5jcnlwdCksDQo+IEdGUF9LRVJORUwp
Ow0KPiArCWlmICghaG9zdC0+Y3J5cHQpDQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiArDQo+ICAJ
Y2ZnID0gaG9zdC0+Y3J5cHQ7DQo+IC0JaWYgKHVmc19tdGtfaW5pdF9ob3N0X2NsayhoYmEsICJj
cnlwdF9tdXgiLA0KPiAtCQkJCSAgJmNmZy0+Y2xrX2NyeXB0X211eCkpDQo+IC0JCWdvdG8gZGlz
YWJsZV9jYXBzOw0KPiArCXJldCA9IHVmc19tdGtfaW5pdF9ob3N0X2NsayhoYmEsICJjcnlwdF9t
dXgiLCAmY2ZnLQ0KPiA+Y2xrX2NyeXB0X211eCk7DQo+ICsJaWYgKHJldCkNCj4gKwkJZ290byBv
dXQ7DQo+ICANCj4gLQlpZiAodWZzX210a19pbml0X2hvc3RfY2xrKGhiYSwgImNyeXB0X2xwIiwN
Cj4gLQkJCQkgICZjZmctPmNsa19jcnlwdF9scCkpDQo+IC0JCWdvdG8gZGlzYWJsZV9jYXBzOw0K
PiArCXJldCA9IHVmc19tdGtfaW5pdF9ob3N0X2NsayhoYmEsICJjcnlwdF9scCIsICZjZmctDQo+
ID5jbGtfY3J5cHRfbHApOw0KPiArCWlmIChyZXQpDQo+ICsJCWdvdG8gb3V0Ow0KPiAgDQo+IC0J
aWYgKHVmc19tdGtfaW5pdF9ob3N0X2NsayhoYmEsICJjcnlwdF9wZXJmIiwNCj4gLQkJCQkgICZj
ZmctPmNsa19jcnlwdF9wZXJmKSkNCj4gLQkJZ290byBkaXNhYmxlX2NhcHM7DQo+ICsJcmV0ID0g
dWZzX210a19pbml0X2hvc3RfY2xrKGhiYSwgImNyeXB0X3BlcmYiLCAmY2ZnLQ0KPiA+Y2xrX2Ny
eXB0X3BlcmYpOw0KPiArCWlmIChyZXQpDQo+ICsJCWdvdG8gb3V0Ow0KPiAgDQo+ICAJY2ZnLT5y
ZWdfdmNvcmUgPSByZWc7DQo+ICAJY2ZnLT52Y29yZV92b2x0ID0gdm9sdDsNCj4gIAlob3N0LT5j
YXBzIHw9IFVGU19NVEtfQ0FQX0JPT1NUX0NSWVBUX0VOR0lORTsNCj4gIA0KPiAtZGlzYWJsZV9j
YXBzOg0KPiAtCXJldHVybjsNCj4gK291dDoNCj4gKwlpZiAocmV0KQ0KPiArCQlkZXZtX2tmcmVl
KGRldiwgaG9zdC0+Y3J5cHQpOw0KPiArCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMg
aW50IHVmc19tdGtfaW5pdF92YTA5X3B3cl9jdHJsKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+IEBA
IC02NDksOCArNjUzLDkgQEAgc3RhdGljIGludCB1ZnNfbXRrX2luaXRfaG9zdF9jYXBzKHN0cnVj
dCB1ZnNfaGJhDQo+ICpoYmEpDQo+ICAJc3RydWN0IGRldmljZV9ub2RlICpucCA9IGhiYS0+ZGV2
LT5vZl9ub2RlOw0KPiAgCWludCByZXQ7DQo+ICANCj4gLQlpZiAob2ZfcHJvcGVydHlfcmVhZF9i
b29sKG5wLCAibWVkaWF0ZWssdWZzLWJvb3N0LWNyeXB0IikpDQo+IC0JCXVmc19tdGtfaW5pdF9i
b29zdF9jcnlwdChoYmEpOw0KPiANCg0KSGkgQW5nZWxvR2lvYWNjaGlubywNCg0KQXMgcHJldmlv
dXNseSBleHBsYWluZWQsIHJlbW92aW5nIHRoZXNlIERUUyBzZXR0aW5ncyB3aWxsIG1ha2Ugd2hh
dCB3YXMNCm9yaWdpbmFsbHkgYSBzaW1wbGUgdGFzayANCm1vcmUgY29tcGxpY2F0ZWQuIEluIGFk
ZGl0aW9uLCBpdCB3aWxsIHJlcXVpcmUgTWVkaWFUZWsgdG8gcHV0IGluIGV4dHJhDQplZmZvcnQg
dG8gbWlncmF0ZSB0aGUga2VybmVsLiANCldlIGRvIG5vdCBiZWxpZXZlIHRoYXQgc3VjaCBjaGFu
Z2VzIGhhdmUgYW55IGJlbmVmaXRzLg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg0KDQo+ICsJcmV0
ID0gdWZzX210a19pbml0X2Jvb3N0X2NyeXB0KGhiYSk7DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0
dXJuIHJldDsNCj4gIA0KPiAgCXJldCA9IHVmc19tdGtfaW5pdF92YTA5X3B3cl9jdHJsKGhiYSk7
DQo+ICAJaWYgKHJldCkNCg==
