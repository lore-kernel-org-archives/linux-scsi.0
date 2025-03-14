Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A4F1624D3;
	Fri, 14 Mar 2025 07:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741936189; cv=fail; b=cbDvrvo03m+GlgZM/wB0cyt8GBuB9b7fpZ64dAFeDu9talkNNCQwzQI1AfXfb7VWdCo105aSiZcZfuojA/hg79cJsVhN/Fxh7JvrAFWk1h8PJ0gw9p4ZoiRcxqSrPaxJSfCzE9H08Fdp7t1MVMwxwV1uRuaMF4fGL4BVuCi0gLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741936189; c=relaxed/simple;
	bh=x0vIu3GWG1atWsEQ55nAo9SnRnbzcOh+rfr7SCeqHvA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SpTHpqiIRQG79JTZpg93MTvaEeP5Cu5XmTNiZ11b9l1ypU2NXppsONnLW7lFoEILCRgreIXvE1iQXS8aHLwEdkEhh2+cAQu+QuAn3XdLzSk3olzKF1h8r8IKlGdP5PmYT9V5waUvpcs0HXn1Cfn5Q2ToBhMw7TEBFvk14vwe94A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=1RraTkuJ; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="1RraTkuJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1741936188; x=1773472188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x0vIu3GWG1atWsEQ55nAo9SnRnbzcOh+rfr7SCeqHvA=;
  b=1RraTkuJ094zBgSAXu/RtkHB2kNVVQC9S/ya5TPN7YGsgtCC7yTk+Ok2
   2pswYp9AaLOcnnfpfWxg2vWFVquclj8rm+shbZpkMehJb9+KWPhtvlglA
   ARcNRuMwlke8yZKvbEBKokL4MrDIWguidL/Cz3r6U4lR7Daz2xEB6eFoA
   jpj9YyO1PqCKYY0rdQrpaTORkZI3BXIM6le2UJKG8BSJQ+JOArnSKjFev
   pU2JDnyNrnkzwrHi1i64eZwhLKS9xuNQFtAc0hT6SZxJwENZGcWqxozq+
   qAWBXl9+rB0rIdsrKCDKfo01wypjizaCfUmHT6uw186Xi/72xVRvsNY+J
   A==;
X-CSE-ConnectionGUID: zdK8ElMvR1G6BLvYC+nL1Q==
X-CSE-MsgGUID: DYv8q4YfTaGyy8BKqhXHWA==
X-IronPort-AV: E=Sophos;i="6.14,246,1736784000"; 
   d="scan'208";a="50514502"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 14 Mar 2025 15:09:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DlKFo0lSz4HGi7YkR6fjqf/j13g37Kf2Zt6eqp5dY+ppTN67cvEW1/YKttHYYTdHMQ1iL7yHnbPK1VQwDd23TyjVIDRWVyoQhdBoesQQKUj541Wa07XkB6hrwYZmY+Wb+OREBoS+CfBHe1/1lTpEWo8yM5qhnjkGcq2OKEvBv47Cn9cZ4wFMiUWtRcA9gWn2i28yE3jh43+ene5c7A7ndXJHXXtiB0xRQkHuUYjwKcQF+B/muRW1Kbw/LSk48DUnfvA7Ha4qKfMxCzoeyssFOrWkhKtbHDIONo+nWSQ8Go2qd/yTHvAFRRGviEtPu7DVooYQJ2YnMz9VkWm7Pck3fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0vIu3GWG1atWsEQ55nAo9SnRnbzcOh+rfr7SCeqHvA=;
 b=br6KFcAms/z7TrYXpc0jLopVtz98HWIa29iuKNGgyiY9lbbBGxLd58P9cf/1C85GWdKmkNIS/3zSMu8ave930mljuU0f6pQAbT5OcVfBnI5uI568ITtqajKRlHAKgU69ovw4yTD3RmUp/K3NQDG0UWbmg+LPnnwYWB1PjGtc0KfZ3t+gbIrVwHACfDmvqZbMJARdP1d9DGyK0JuGJDYvNA2Ob3FU1WZWl06x45ojCeD3KILSdCC8YZs+3VnmBoj8HIm9DpZl/0Xmcbh9lGHrqZXpjLtm66Qlf+WseWwY7ul/24gWD+C+RV/TN1E2/p2n8Jtyu7PfwWV4ZUiZ0h69cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA0PR16MB3902.namprd16.prod.outlook.com (2603:10b6:806:8d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Fri, 14 Mar
 2025 07:09:37 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d%4]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 07:09:37 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Bart Van Assche
	<bvanassche@acm.org>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Bean Huo <beanhuo@micron.com>, Ziqi
 Chen <quic_ziqichen@quicinc.com>, Keoseong Park <keosung.park@samsung.com>,
	Gwendal Grignou <gwendal@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Eric Biggers <ebiggers@google.com>, open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] scsi: ufs: core: add device level exception
 support
Thread-Topic: [PATCH v1 1/1] scsi: ufs: core: add device level exception
 support
Thread-Index: AQHblEPHWWO7/SVWJ0iW+Aeuhetca7Nxl1wAgACfj1A=
Date: Fri, 14 Mar 2025 07:09:37 +0000
Message-ID:
 <PH7PR16MB61969A76CDEA46C4F81F2465E5D22@PH7PR16MB6196.namprd16.prod.outlook.com>
References:
 <772730b9a036a33bebc27cb854576a012e76ca91.1741282081.git.quic_nguyenb@quicinc.com>
 <41678800-470f-4ea2-802c-f9f4d21817f6@acm.org>
 <4c83f8c3-6cfd-81a0-afeb-3e8854fa1efc@quicinc.com>
In-Reply-To: <4c83f8c3-6cfd-81a0-afeb-3e8854fa1efc@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA0PR16MB3902:EE_
x-ms-office365-filtering-correlation-id: e462743f-212f-4bd5-6b40-08dd62c72ebb
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?TytTdmNHZEYwSUkvSTVKQnpOUVhmUG5xK1lUNExtaS9GSWpqaVBaSVhUMVpo?=
 =?utf-8?B?aGNJTDNRNi9RdGkzamlhZDd1WW1lM2VCVTRzcU1CZ0RZTjVRNVV0M2UzYWxh?=
 =?utf-8?B?aXRESkRydlUvMEpXVUdFcHgwY09GdEtneFdINDJoa0pHemtpNHhHTDVMcHVV?=
 =?utf-8?B?Z1NvbXBqeWNYRmpSU0lKSHdNYWRIaWl1VlkwZmFweXpOUUhrbnZRM2ZpRThn?=
 =?utf-8?B?Y2lPZkt0Umc2VWZUanErWkRtNWJFdEpMS1lwSDZZNHpiZkova2oyMXJtT0Vn?=
 =?utf-8?B?ak5ETCsxWHlEWGF6blhLeHUxZEtTWUdvcnpXdEZFc2pTM1VkSHZXK1BHVUk3?=
 =?utf-8?B?QjY2QktuVDVHSThnUzBEUlBackcrbUJPWnVMa1ZBSHJVZjdMQWtuVWExRjZm?=
 =?utf-8?B?WjNWOS9EZzQ0VGpsVjYwQ0dhb1JuNG9QRVNVbHhkTFBZWTd1M3dxUzhLZlJ1?=
 =?utf-8?B?bzRmRGViaFhHb1lkWUdEbjI1dm1LeEVzMmtQUytUSGZPMU5TNUs5OUZTYUN0?=
 =?utf-8?B?Nkc1cS9LWDFOeXhkeGZ6MkpWM1pabWdFVjBrQ2g0V2UyRE9hT2tRYVFHY1Zu?=
 =?utf-8?B?SWhyaFhPbFEvZlhBRUVoeHNKNW9NNW00aUFrVjJ2UUViZHlCZUJSUS9iTVNF?=
 =?utf-8?B?cms1d3cwZEk0V1NqaGJNMndacm4xREk4QVd2Uk9vQmozdHhrS3pwN3V5TDk1?=
 =?utf-8?B?dWZJandhREMrbnBjdVB3WFRoTm1Ya015ejM4YXhNdTBzaUk2TzlrK2V0dXN0?=
 =?utf-8?B?V0g4REpZUEdFbWN6cFBBTy9sNVQzN3NFTW1zRXZaam9PR2RON1U0VzcvbVFj?=
 =?utf-8?B?blBaaGFvdG1ybFRpUHBFTGp2ejcwSUhzQkt1Zzk4cXhFS3h1ZzlFUE93c0Jo?=
 =?utf-8?B?bWhkMlN6RjVxbGliL1E5R0d3bWgxd1NWdGplYTc5bStVdDZjT0hYczJxNTho?=
 =?utf-8?B?aU92ODJOQStxaDBaSjA1RDUvOFNscXBIUkkzTFF2SkNhYUhVc3A3bllGSGtN?=
 =?utf-8?B?ai9uK3oweEVNQ1M1ekhrMkRWcHhDQlpKTmV4WU10b1Q4aENxaHZYYzl5REhT?=
 =?utf-8?B?cURpZ0xUaHYzR0hNZUlYUWpiclR4b0w1ZDUwVTJtOGVBaitlV0tQREZjeWhR?=
 =?utf-8?B?NWE5VThWTzhzNFVCbG5iL2d0Ung1L2JQWks5M2g3d1J5UU1ENTRUTm9sdm52?=
 =?utf-8?B?NzZqaVpKc201L2NNbGVWTzZBcFdKMXdZYTVJSjhVZ2ZUZG5SOFNvRDNPcVV5?=
 =?utf-8?B?cDNkdGhPMmV2TmZkWjdBQ0ZwRk1oWVh1emgxSVZFanhKVGhnNG5USHdCQ2s3?=
 =?utf-8?B?VnAybkQyaUZsMy80a1o0aFFBdVBpL2xZRU53QkJtL0U0TURWMXJjeHBFSW1n?=
 =?utf-8?B?ZncrdmhlQ1JxaG4ycGovQ2R1RlZjbEcrS3JwYyszMnZackpaOUJQTUpIeUxH?=
 =?utf-8?B?R3NYTXdVVTRESkVtWlhCK3A0MG4zQzJKYWY1L1JpMHRvcy9KRU5zdzJzb0No?=
 =?utf-8?B?anc1RDFKSkVQZ013cGIwMzhSTFVFcm8yUUw0REZLdzFCSnZLNmxhRDlmM3k1?=
 =?utf-8?B?aWNZQ1d5VklvMHloYnhEZWxwUE50eWdiNEk1QnNUNHZiS3ovQzJsL1ZReTM3?=
 =?utf-8?B?WTY4UUpFUWVRYmxkaVlUNWJlSEovdW40K05ZQ0M4WndJWjhKNkE1Q1hLU2U1?=
 =?utf-8?B?d2Y2T3YwQjZIMlowRUZDd3Q2emdRY21xUjUzODhHK1JxVi9LTjAyL2R5WTIy?=
 =?utf-8?B?ajk4Vzd3aGQ2U1hGZVFBMzEvVDJoNGp4Zktyc2ZPRlR4NHVsNm9NcWVncFVq?=
 =?utf-8?B?OEVwbHUyVDZUOGxQakFiY3lzY0FNbytXLysxbFhXelhVUUJwS1FiSGVQNWpJ?=
 =?utf-8?B?VENtb1hxUFlIL1JSU0MvajVpeHFueE5oV2tWVlg3Ym9VT2U1NGZWMEpFaXo5?=
 =?utf-8?B?cllWb1RhQTVzSTJ1SkdHeTJ3eGdyeldORk9LZGxSMGlSS2loV284ME5adnFE?=
 =?utf-8?B?RnBuUHlVelVRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UG11MVFaRmJkRzl4ZXA4ZUFVamdOeDRaVkZvamlmRmtpRnZSY0Z0M1oxUkVB?=
 =?utf-8?B?aFVBdFVaT0FTcXVTelFTemhaeHFzdnVkMjVyT0g5MVdQQUNneUd0bDVGc3RM?=
 =?utf-8?B?MHRYUTdjbkIyOFBFTnp1anYraHJRczdQM2t5eE1nZDRFV1hFVTIyTUFzbGZC?=
 =?utf-8?B?aGZ3L1g4MjlFQ2w5aUczZklmeWdDaXNqRlFlbWx1MDFIR0RhTlhlN0tQV2JU?=
 =?utf-8?B?Y3laWkhRVGpxeExKMWxTU1RnaGJzZzVBTU1JYWFhRUFkNHIwQWRFa3JEM00x?=
 =?utf-8?B?REtiUUZLUnJuRGIrNGRPaG1lSm1WcEdLM1QwMGdvK0lNVEdBUzVKcERycU0w?=
 =?utf-8?B?OEpYMDJGOFdyUEN2YVJRZEhUWFZXN2Q2ZjlFR2lnU2NvSENiajN0d3gvSmti?=
 =?utf-8?B?MHVmWmp4RUJYNFdReGNMdXRzMmQ2UDZmSGpyQlNNVXNmV3N4QlVnM1dseHJY?=
 =?utf-8?B?ZU1XSnQ2Z3VNUkxqbG1tME9hNktyOGJRUWRteURsZjY3Ti81NEZGZ0ZBeUd4?=
 =?utf-8?B?eHVURmRzWTFqYUpQNVVwMFZDb0o0bEMraHc0bUtaSjFDRlJicGF1bmk1b3Va?=
 =?utf-8?B?UjNodk0xWmdiR0lqejlmT0Y5OHVlVy83ZXVGL3NkakZPb205TE5BSi84Sk1M?=
 =?utf-8?B?Rmtya0RnQ0gxK09JMWFBbHExczBZSWRmcVhsVlo3SjhiWWFTcE9VNlhwVUIx?=
 =?utf-8?B?UTRzWUpwQkhqSlFTVm9sY2VSYkxzanN2TlRaWXYzc3l4TGhZNThJSm1WRk5X?=
 =?utf-8?B?UkQ1Y3RpaytSY0ZYZ0lDOWhOc3lhSUx1UzFqWlJwZldQUStERG5uMDVmZEVU?=
 =?utf-8?B?TVQ5dWdRZnZlSUpJR25yN1I0Y1FydjdtQkR6MmtoeDA0Qm92VzlVZ3dDbXR3?=
 =?utf-8?B?V0s2eTJnQVppYjQvNUVFUm5pb0VKdnNyUTYzSXRIbHlxN1Z1S0NDMDFOdUFW?=
 =?utf-8?B?MlpVNzgwZWtVUUdybFlaUzFOQ2Q1MjdmTFlCN0V3Qlc4VTZwSmZUVCtuQ28r?=
 =?utf-8?B?U0tMU2JLTG9tZjRUOVVLbzhkVWh6UlkrcHBLV1p4WjZsYXpzN201Y0lNQnAy?=
 =?utf-8?B?L0pTWkdhRGtmSGVDWFpPNFNYTVdCWWJSRjdnM3p2bHByVzgrWXR2dkk0b0hi?=
 =?utf-8?B?dHpkbTQwdEQxTDRpVXBQOGlhaE04eDM0dS9tOStWSHNSOHkvVUxMM0hpSmlj?=
 =?utf-8?B?d0xDUXdGcjNyTktIcXV3NS9DK2xWZVJsbFlsb0pYNkpvMkcybExON29LRno2?=
 =?utf-8?B?ck8rYkdtNTN2TzFvUU0rRTUrWFdBYzFmMVVmNWhKVE5tWFQxWjVDL1JFNVBQ?=
 =?utf-8?B?My9uV3dZREcvQkxLdkF6MzR1cnBzakpBNUZYRHVuaFpmdXgxTWtEYWlSWHZC?=
 =?utf-8?B?bjREUSt4NmlGSE9KT1dWdnBTcWZ4TjdkL1JUQTBjb2FUUjEvUHhsUEhxRDd2?=
 =?utf-8?B?N3h1SDBlZjlhdVpiSWE0cVBKNkZ4d09HelV4WVhtQi8wSkxaeUZrZy95S3JQ?=
 =?utf-8?B?OTJXa1c4c3ZBZXZ4UEJJWkpzc1JpOHRFMWxjbnVpcUo3M0ZLTzVjRVg4WkxE?=
 =?utf-8?B?RjZ3MFBmcEE5REVyUjg3WWl4SE5MOUFPUERVUmF2dVJxcmM0aGRRSUtJN2Rq?=
 =?utf-8?B?eEticlNtazc0R0JFRDZTcnM1ck9XZmY3RHVra0lmRDVHQndGN0dxa1lCVlVZ?=
 =?utf-8?B?cWlBQTRwdy80L1lnbC9BeituWkxzdk1QSlkxQUhNaHltNFpyS3VNQlZHbkZa?=
 =?utf-8?B?Z1BiNmVkSjlHMWMrZW5NMUFFTGVOMlQ1RUhlZzJXSDBjYjd2ZHJycjl6bzZL?=
 =?utf-8?B?THZXTW9UZllFL29WMkVqTmp1RDJsUTNycnE2eTNNRUJKUElIRThIMVRwRWQ3?=
 =?utf-8?B?MTBDcUFEeWtVV3NKTHlNWEdvYWNQNG54MnRBZmZYUHFISXFVOVNidHRiekFP?=
 =?utf-8?B?WW9lNjlGNnpXK09pZFRsMktLZXVHTXZzQmdNZFZlMkVjK3l6N25jMTNZVncv?=
 =?utf-8?B?S2lUN1psTWlBdlkvemxKb3MzQkZKd0ZWQVZDcER1aHVmenBDNS8ybElEeDVG?=
 =?utf-8?B?QTh2OWFuSWwvbmpRamlBcm4wcFlSK0orRzBtU25oN3F2N1dMNkpzNVgrSDhu?=
 =?utf-8?Q?D/1NG0oK4QL69svVerd8k3uTz?=
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
	Bd5w4XvOppq70l2bw9ny9yhNwyHhwxDUB+tNSMLQ2MAp//ecwflzluwj9jOVOMGUSXJszlEknR//Afd0TJUFK7vhXAoo8jXkSZCpHKyStF7Cccp5ghLGlxlvIzsRkYXyFnvw0UTd2oSARl2NfdgOyRLufbRLzgDZfCMeRfESL/9+427HiGtq0SHFqL2tyiamoZvMsee/2IlCj5fHRjy/lqJtkR/kf0FpUF5Jtq9/TJ29xjKHGfUYmX181sNiLKKAX3FAkuiwXXLJGc076Hvtagx4AftFU8YuAqBNA5PhDdBuJyg9OIqnEWyESx11J9SHnCkkLP9kAuRhXFIbMDfFes7k6zSqW6mbs3OhOFbDzS6wfD4tGAo+J+DkTBhX4zA3wQR76u0X3CdR9un/bbjWNGlqlxHAY2NMBSesuPhaYSc7sqXO4XQv7RYfytvG2CVc0vQlgcDv+AvT8JVjRlpcMEuV26kEO5edK3nXPs6l8bBsmua+4w4KvyXiWdTsBo/xO/W5slN7xYOdmmMLTQ6+IWLyLOby6grw0lw4aXQAQD5NSqLEiyHc3mcxwuwh/mDQd/4ZI2YeZyHAHgVqIfEUk/7/f8K+pSFNJ6L4LTJUoRofaid+jxjjqkAfTnLQpZRx7br+BTRrXl5RcAFibEjiNw==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e462743f-212f-4bd5-6b40-08dd62c72ebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2025 07:09:37.8026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J2D8yKoCwPtovTH0oPpCQVQcjxG5vzA/Zt+xD7JQu5NNlVx8b/9CsdF39fFAwNP9JQjdUQJaJv+5bWrfkpExiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR16MB3902

PiA+PiArwqDCoMKgIGlmIChzdGF0dXMgJiBoYmEtPmVlX2Rydl9tYXNrICYgTUFTS19FRV9ERVZf
TFZMX0VYQ0VQVElPTikgew0KPiA+PiArwqDCoMKgwqDCoMKgwqAgaGJhLT5kZXZfbHZsX2V4Y2Vw
dGlvbl9jb3VudCsrOw0KPiA+PiArwqDCoMKgwqDCoMKgwqAgc3lzZnNfbm90aWZ5KCZoYmEtPmRl
di0+a29iaiwgTlVMTCwgImRldmljZV9sdmxfZXhjZXB0aW9uIik7DQo+ID4+ICvCoMKgwqAgfQ0K
PiA+DQo+ID4gc3lzZnNfbm90aWZ5KCkgbWF5IHNsZWVwIGFuZCBoZW5jZSBtdXN0IG5vdCBiZSBj
YWxsZWQgZnJvbSBhbg0KPiA+IGludGVycnVwdCBoYW5kbGVyLg0KPiBJIHdpbGwgbG9vayBpbnRv
IHRoaXMuDQp1ZnNoY2RfZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIgaXMgYSB3b3JrZXIuDQoNClRo
YW5rcywNCkF2cmkNCj4gDQo+IFRoYW5rcywgQmFvDQo+IA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+
DQo+ID4gQmFydC4NCg0K
