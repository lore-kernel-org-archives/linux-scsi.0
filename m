Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C78E1C2335;
	Fri,  7 Mar 2025 09:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741339116; cv=fail; b=MvG3lArhFtHAKrfJ6ZKrTF4SPZc+tNbJFzuIOQk+aR3ukqUzukQYhpUQQuTlFq9bMGIze5PRu4byyIjy8LhQRSy6lkXE6/pjwhUBVpSSwQM4lRPeBNHC3Z9BTwHZCLLlIXcuC8JTWMGwxGGSD7OgggXXx0aZsuXSltLNpaQjohI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741339116; c=relaxed/simple;
	bh=PYEAiyzJvZ+gQlf32GDS7vNPw/nuCN7AixgTqxfDoeM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iOYUvrTIwRRR/rh0k8OfPXunaDRoTRe1V87Bgcn5QYtJ25aqfoLzIt7/sOnu5izPIS1eT1o9ir0SmLA7Sxwqiu6HVZNEWmIlO2eBSZ51aoa8AHP1OJEreIlq/ueNstgWeZzeUO1gWeKR4BdYhGYD+sYBDMrMK0tuKxAeNYNbSOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=WplqucfC; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="WplqucfC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1741339114; x=1772875114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PYEAiyzJvZ+gQlf32GDS7vNPw/nuCN7AixgTqxfDoeM=;
  b=WplqucfCNA5Gz47D9SeBrQBuys7pEeLnBJUm4Pqulr4uoxlEg8HglR1Z
   tz2VXmsn6E15ikVAjoIwjjLsJjhw0A6iH16cPdxGruO1xsF7TzUqvcktr
   pFMe1O8EC+7YmnG4YIBK7YdP2iQ7f/2WVlqxKHG5LsylwzE55Z8zaPGVs
   s2Ou82h1fF3Flk2SgrByjP1ixMKSVjPTVnnfOVAWsmolJIm9+gCJQM691
   6cWk/sDvSBp2Wjt5EATF+5YC18rTI5+aWFqWmo1qGioID49XF28phWja+
   ppge+3qkzcW8BLBna9820rpBeGX7qLPPHfTT5LeQrl5FlwVH6J04iD5jL
   A==;
X-CSE-ConnectionGUID: gxbu7T6hSTGeX6edqocFlQ==
X-CSE-MsgGUID: nUZHjuRWQX6m13zD8EBnmQ==
X-IronPort-AV: E=Sophos;i="6.14,228,1736784000"; 
   d="scan'208";a="43159824"
Received: from mail-dm6nam10lp2042.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.42])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2025 17:18:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XWqB7Khd3c/BUMt54ckSzR7ovTkZ3d9LneeBDutZWlRFCvSKLX17htrfEFJnb0JTP8B6TCgbeVl014VbNpzpAzTQb18OxtZhyAinMNjf4x6rBi72RvC3+oMwIr/QP21W38hvIR2d9tQqDihhgGT/Q47RkLer/ppkHr7XH2BLWkG3t/Nc+7JKqc3Wjv4ahlfHTnaHF4BTo2PXh3fwVZf+7d/0tt76Ar0m951FfhD/7XRzZ8ZQHlURU2wrrj+QQd2z8kVkjPxVSYZWFjoxWWOyBOKK+lmyXucjv+282ykFWJwI04oCjVX+u6m24ATfDjfI/qyTrb+amz0Q8ZPArYzqOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYEAiyzJvZ+gQlf32GDS7vNPw/nuCN7AixgTqxfDoeM=;
 b=bv3zviTMZ0zRo2sIA2FU61Xc0eUr4JPU/xCmkTmcSyUimC7VRb1lD6m63x8sT1zx3QHLwoTUADJU9ywp1jJs13AEv5iHzlKzcimIoma1xxwfCgl3uLI+ItUIBaYS5MoC3xvai0pSMdoU7wkWn2XhVs4BnQuLoBCeX1jgTuz6y17A0Uk6qaipHK5+Qv0chjgChoHhiGqg4H/scV+ipQNNWQ932zZFuXTfJQQcFN6WzDjr/TJRdJQo3+fo0dq82m9DMGXtpyrab2HaK+dC6SZUZ8JYza+RHaCP+OA9YGvJaVlPr+jCnYgL1iyEGF1llXfkJjHQCBr587epqMXs1AVEdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from SA2PR16MB4251.namprd16.prod.outlook.com (2603:10b6:806:136::8)
 by SA1PR16MB6504.namprd16.prod.outlook.com (2603:10b6:806:3eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Fri, 7 Mar
 2025 09:18:25 +0000
Received: from SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2]) by SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2%5]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 09:18:25 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: Bean Huo <huobean@gmail.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "quic_mapa@quicinc.com"
	<quic_mapa@quicinc.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>
CC: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
	<Avi.Shchislowski@sandisk.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: RE: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Thread-Topic: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Thread-Index: AQHbjPsw3ucJcBmYkUmzp81f56cI4rNmEpWAgAFVAxA=
Date: Fri, 7 Mar 2025 09:18:25 +0000
Message-ID:
 <SA2PR16MB42515681881747A6B5C83352F4D52@SA2PR16MB4251.namprd16.prod.outlook.com>
References: <20250304114652.210395-1-arthur.simchaev@sandisk.com>
 <bd2e01d8b33413655a4215221c910eaf2cdf6461.camel@gmail.com>
In-Reply-To: <bd2e01d8b33413655a4215221c910eaf2cdf6461.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR16MB4251:EE_|SA1PR16MB6504:EE_
x-ms-office365-filtering-correlation-id: c7696a17-98f7-4ecb-e107-08dd5d5903be
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YWpsNUtRVEdIUWMydGI1YUFic2VTZDVCdU1ISEZqM0FDVFZOczA0Q2UycHJZ?=
 =?utf-8?B?Wk9hOXd6d3RYb3ViL2RsSFc0TlFVSDhlVTRURW40eWdQNy9XUklkRjVyVXQz?=
 =?utf-8?B?R3NxVG5kOWRmR2ZBUS8vS0RLelBqZVFmNUU0NW1DdE5ubWx2ZG9qR3U2RWpt?=
 =?utf-8?B?K1VicUNMckJHa2VJTDZjdHVneEJ5eXk1UUF3NHVlb1dUUXF2SUcrd3RpOWJy?=
 =?utf-8?B?czFCOEFUZDMrNzJmYVFoeVpyY3kzWTlhWi9pOEJiOHVXWWFNV1NlTThTejlV?=
 =?utf-8?B?WjlVVGs2S0tFcGl0dzc4dTlaUll0SWZnSzRtaE5mVmZtMDQ1UHV1Nnd6a1VJ?=
 =?utf-8?B?ZW5lb2VtM2hESkx0a2ZuRHMxRXk4S3N2THF5U3kyaW84VzhEKzBYMnFPY05Q?=
 =?utf-8?B?U09ZU3lEN2ltR3dDWWVtZXZJMEx5S3BhMmRGL3g3YTJHbWhCYmlKTGVLS3RL?=
 =?utf-8?B?YkFQeXNuUmhBWGh2U3hWUVJ0R2U0KysySUtMSUp0dEVxYlFoZHNnR0JidlZ0?=
 =?utf-8?B?NW5xZld6NXNzdXVPNnZrWkw0ZWFOTTN2NkdZLzA2UC9OOHpMekcrb2JPNXQy?=
 =?utf-8?B?amNiQ2daSHRlWDRSSTlGTHRyYlRWbHZlTGc0dVVkUjZsUkxBMkVvbHdJVmc0?=
 =?utf-8?B?dUF3Zm1DMCtQWU5hVEF0d3FkYVJMbUpFKzVPbGJJWE9zaENZcEcvRW9VVW9n?=
 =?utf-8?B?bEhqOGFSRGZIUWdOd0hldEFNS29EYmVCeEw4NkllWXpxSWlPMzhJZ1VWTDFq?=
 =?utf-8?B?ZkZ6VWlIUXNBaWlpaXg2YVMyNS8wREhkSUlnVFlXWldzS2swdHB6aTJONkt0?=
 =?utf-8?B?RVVmVlFiMVZpdE9lU2lLRFV0eEROVUthQ0NvVWhFcldzZUZCa3RqdUNQTVZz?=
 =?utf-8?B?NEg0NUdOaGp4allQdzU0anZZbHB2eEdBMmU5Mm43aXIwdTFXVnhZWHk0RUZM?=
 =?utf-8?B?emxML2hHU2hrNFBCWThzbVB5STVSLzYwU3lZemNpcDdyZm1hT29EVllDbTVx?=
 =?utf-8?B?cnBxVDVDV3pqRldyUFgrRFI1ZTBsRFV5d0ZzY2djL1ZnU1IwazdraUtRVXBS?=
 =?utf-8?B?bFV5L3NFSHRzaXhoMDFSK255UGlSaFZlZFk1azgySGpMcDkybGNTVFdJdGdW?=
 =?utf-8?B?bGZKdmJrbldZeTFrYWUrbFhMUHdWRHM0b1lCY0JzMm1zTmZ0ZzEwZkdUbkoz?=
 =?utf-8?B?NHFYMC9aQldzNlR2c1JtY1QwaEN1WXhVZ041dmtmOG1jNURmVndVWE5WQXpM?=
 =?utf-8?B?U2w5c3lFRkhVa094MmdZcTQrd3NacGF2RCtmRjlJMVpXWGd6M3BrSVdMaUh3?=
 =?utf-8?B?NzViR0xuQ2VoZm1IN3V1cmh0UkdRcks2Z0tCWGl5bCtqNDZKV2pvWDZ1dytT?=
 =?utf-8?B?ODRoN1BsaWs1NTZ4b2VSMXRoRlhQVDUvcGNPTU02OVVEeEhVTmJxWlFnekJT?=
 =?utf-8?B?UTFTdVorTkRkWEpQMEV5Ykw1a1E3WlVqd3dUem5XMEs2RklqZ0lZc1RIK1Vn?=
 =?utf-8?B?TXF6TExYdWNnQk9kQ21rcll2UkRRcGhKdkZoSlY0UzdJRjFiL2dVT2xmK01E?=
 =?utf-8?B?WUN4Q0l5aG13NG8rL09KNDV0VzlBMG1rMUNnVllOZlh0Z1FFd2tPL3cyZy95?=
 =?utf-8?B?RlJoaTJpaTFEWEdrSmQzK1l6dGxQaGllOHRKcHcrZG45cENtTU03Mm9YOWVG?=
 =?utf-8?B?Wll0T0U4KytSQVFsRzYvcVNvU01CUGozb2IvMXlQek1UcVBkVnhHNFZ3SEF5?=
 =?utf-8?B?cEhTQng2RHpVeUpvMUxZUWNCU3dSSHJjRkdnelhZb0tsZVhmL2YzdWsrSVFh?=
 =?utf-8?B?T3BFWUFCVDZXU0dlNE5qc3Q1ZnpwWjlXaXVtL0M0eFdleWxHeFU5RW1CbGZ0?=
 =?utf-8?B?OFF3SmkzeEpTcndlTGFzdEJkcHpJMytiK0VPam94dTdpMlB0a2NkMlE3a2Mv?=
 =?utf-8?Q?34NNx4DhGJwWVQTh//4LMtyKm2BBTbPy?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR16MB4251.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eG5udmcxUGUveWF2aFZVN3V5UVA4NzdtaXFPekoyaDk3WXhLS3JWUDcrdkl4?=
 =?utf-8?B?UFJUTTBqYkIxdS9ZbjFiL25ueUJ2ZzlqRnlEL3RjSngvcUVhL0g4Y2g0Zzhn?=
 =?utf-8?B?cHQreWtxbTZ1TzYrelJReWRMcW1YTkgxL0hiNXFhN2FJR3hmUjlzOGtBMkFz?=
 =?utf-8?B?WG0xenhxc0had1Yrei9UY3hqWk9kdHR5WGdqM2p6Y2E1NWhyMjdWS2dncUpL?=
 =?utf-8?B?T21aOUt6RDNGUUdLMFlIUXYyRG51bzV3ckVtUjEvZDhTZndTRlYzbVpJMUhB?=
 =?utf-8?B?M0IxZGRmOVoyTElrL1hPUXJnNmh6VTgzNko4dXg5SmNmUkROQUpxaHkvY2cw?=
 =?utf-8?B?UmdvTXVVYTc4VFpRWHZuckpqdVljRWtRNmFleU9NenNQOU1QRFB0M0dmQmRS?=
 =?utf-8?B?eW02R0VmNXNWelBHLzdSUkh2WTM0TE1EclJVZnpCa0dVTDN0N2pEMDZjYUYy?=
 =?utf-8?B?NkVMSlRIWXZwQ2xKSHljaEpsN0lyTmRJOHFySlNoZXlqTFJwaW01WVF2Tzd1?=
 =?utf-8?B?dU9Ya3k1bHhLYmNVRFV3a3pRYjY5VHJwbjJ2UUo0dVJrSDlrcXlRR3lIQjVx?=
 =?utf-8?B?MXBURmlGQ25vMDdyejJ3TVBuTUJ2ZXlxREtUK0FqdGNnZDBWV01ycS83clpt?=
 =?utf-8?B?dXZDNUgvbTNseXYvcndvT29HSUwxT1hySHJ1R2hOV2NQVlZVTSttd2d0OWdS?=
 =?utf-8?B?dURGZUVya2hwTmcvSkt1d3pwOGdUWjBxWWdsa1hWQzFoWUNZbVpvNlhuRlZa?=
 =?utf-8?B?QUtybldiVEozSGJFQzNzaGRuM0JBOU1QWnlpT2dPMUtlYWJtSjJPZ253UU9k?=
 =?utf-8?B?NXZnVUZuNUpESTVzejdxOGZYbFNUWU02Z1pxVDkwMWxtWmpPcXlIU1ZUY29Y?=
 =?utf-8?B?dWFPdVNmeE1CMjdrNWdrbVg1Mjg1enlxTzNRMHpSaEZNRUZZNmRRRTB3TEZ1?=
 =?utf-8?B?R3Y1a0JLMnNHd2duWjUrNnZoRjQrek5HdFQxV0lURm5NSmJqbXpNbHBzeGFJ?=
 =?utf-8?B?amJybXhTeWhZcUIzekFUL0FlVUdqTjdZSUNjMmdEenJ5SGlkZXBLWTZxZnA2?=
 =?utf-8?B?a1k3V0llUTFuSlNsQkZ3T0NaWEhpdkhQS01LZGhOZ044ZCs1UVhHUjIwMERi?=
 =?utf-8?B?dGdXTFpRZ3FWNjF1VFczWndqdEE4Vkt0Q1dlR0cwRGFBckFXQ29vV3RRWms5?=
 =?utf-8?B?YjVvTFYwSjRmTGxQNVhyN2paellQQlRyUGE0c1hZd1k0VDNuRXoxUHZxSENw?=
 =?utf-8?B?elBNdDdnenFtcTJ1dzN4cnJkR1o4alhaMzJydjFyVEFTY1MwNGhVQU9aZ3Fu?=
 =?utf-8?B?NEtFZnlRRHRsMDgvTkk5bzU2RVBWNXJGRjhkV2RGT2lQb0dFYUw4YmJuT0lJ?=
 =?utf-8?B?b2o3VjRRMnNLOFhCQ0doUFlVaml0VnVWNlFSNWI3UWV6VTBkb3J6MEd0Ly9a?=
 =?utf-8?B?dFluSVFmbk93TSszd1BEb2gvWGt3UGJVYmJUcUNtM1dJQlhRMVFuM25Namtl?=
 =?utf-8?B?RjJ5Z0lZblNuY3FXdXhSWWdYSUhiZDdMTVVubmYvN0p0SUpWbmtyYkhoVUh0?=
 =?utf-8?B?d0tnNXZuZUZGNmRhUHM2MFhReWVlQkZZWEZ6TE9PbUI3T1MrdHZGaFg2dzdq?=
 =?utf-8?B?a1BDSlcwZyt4ZDg0bll1REFZbmpsREtwc2pJcGhkRm5DWW53T1l1Z29GTllF?=
 =?utf-8?B?NnBsNXhvRFJDTXV4V2VFUkQrSXBISW9KanpnWWZudE4wR2NUOHV6Zm1Odmps?=
 =?utf-8?B?bUcxN1Q2NW1xRVI4blJsT29yVFFmZWp5Zm5QSE5RUjlPSEZYdlZDMHZzZ1Rm?=
 =?utf-8?B?MnVpV3pLY2FNZXZ6N0o1Qm4zOFhHTXBXYnF4eFFVRGJlNUNlS2hINmpZTXlt?=
 =?utf-8?B?NTYrRm12Y242aHNyK2QvRDVvUCtHOUlkdWtmdU95ZDMzeGx3QzJGOFZnTFFG?=
 =?utf-8?B?YndlSzN6dG0xMzlZWndJelNubW5IVmhSRWcyM3IrSkhKYmN2VG03bUpGWFVG?=
 =?utf-8?B?K0ZSelNyQ1BLRXdpVDdDMCt5L0ZsY1dkbWtCR0RFLzJwdUIzR21qbFNpbmhM?=
 =?utf-8?B?YWNWNkVxN0NndFlOY3B2aEhnRmxJOUtHWExZUVBOVWpPazNpUTQ4OFlFN0Iy?=
 =?utf-8?B?TU5NTnowNzZOUzd6VFNma3hPOVQ3SkRzL0RlNDUxazJ5RzdidjRhZXAyT1Bs?=
 =?utf-8?B?Tmc9PQ==?=
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
	l/p3OEtqCfO0pdg9S1meNRZJOX04ETooOCIDvQa16NDOWHmh1LQEk/7HleoGcuq0kuaTEFJvqwdo4nWgAFEzmVOciy5JdVlSUrQrYtF6FIdtv4/tvfv+iHn7uVHrZ4+kxnp/B7VNFghIo49PSWh0D9/9zVIQM+vQ2/JC+nE2lcJ2XKV6v9R99joyefq2eJW5b3z618CbsPXwniIejSiIRbOMD/L85LAU4sw7qpZCzKG1L/RyMmru+AcfSCTvCEnmTM3aWiJo2s4yVSJRnKxr2Y/UnBXe1Y3SWMgu4mFh8eUdvMiL7J8aNsDhKRMIqNzRc5TTglPBvEov1GNM6eEifaZwat87oAkQlkXa6uHSCzwe2SBcT5oleIEHopaI5WyAlbnCdc39Dqg78We66v85aF9Cp0g8Qj1qQhdBVUTu4zN9Pf3m4CnSJ3kwzgQ/qpCIdXyEadLgZvaZpkUpeXTDyCPNKHqKx3YWdkAORjBA0BWIV4qTtkSVwmZmF9b0sSg9+DiOV8cYIBuRCs/6Hnq3dWZgBkDJSWrSLVnnVS/4qxaQUhxydI3TpOyyI8Q9jpTKCgtOcYk+FQojt/YRIFeZ9qWwiv71IXYgiKJ4anRKVacQMuYQ9inoPpn3B1k6pgGi
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR16MB4251.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7696a17-98f7-4ecb-e107-08dd5d5903be
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2025 09:18:25.2298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vqRxdG9mwLajhQ+K+KpaRj29EszkIfqtaHFo3KLLvuVGFdcZAPoLIoGb4JbSHvydzyB8wX3cV/tY/R/UbL6TNDb31xAUOHb1JhzNxy2AlVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR16MB6504

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmVhbiBIdW8gPGh1b2Jl
YW5AZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggNiwgMjAyNSAyOjUwIFBNDQo+
IFRvOiBBcnRodXIgU2ltY2hhZXYgPEFydGh1ci5TaW1jaGFldkBzYW5kaXNrLmNvbT47DQo+IG1h
cnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBxdWljX21hcGFAcXVpY2luYy5jb207DQo+IHF1aWNf
Y2FuZ0BxdWljaW5jLmNvbQ0KPiBDYzogQXZyaSBBbHRtYW4gPEF2cmkuQWx0bWFuQHNhbmRpc2su
Y29tPjsgQXZpIFNoY2hpc2xvd3NraQ0KPiA8QXZpLlNoY2hpc2xvd3NraUBzYW5kaXNrLmNvbT47
IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgYnZhbmFzc2NoZUBhY20ub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHVmczogY29y
ZTogYnNnOiBBZGQgaGliZXJuOCBlbnRlci9leGl0IHRvDQo+IHVmc2hjZF9zZW5kX2JzZ191aWNf
Y21kDQo+IA0KPiANCj4gQXJ0aHVyLA0KPiANCj4gQXQgcHJlc2VudCwgd2UgbGFjayBhIHVzZXIt
c3BhY2UgdG9vbCB0byBpbml0aWF0ZSBleWUgbW9uaXRvciBtZWFzdXJlbWVudHMuDQo+IEFkZGl0
aW9uYWxseSwgb3BlbmluZyBhIGNoYW5uZWwgZm9yIHVzZXJzIGluIHVzZXIgbGFuZCB0byBzZW5k
IE1QIGNvbW1hbmRzDQo+IHNlZW1zIHVuc2FmZS4NCj4gDQo+IA0KPiBLaW5kIHJlZ2FyZHMsDQo+
IEJlYW4NCj4gDQoNCkhpIEJlYW4uDQoNCkFjdHVhbGx5LCAgdGhlIEVPTSB0b29sIHdhcyBwdWJs
aXNoZWQgdHdvIG1vbnRocyBhZ28NClNlZSB0aGUgbWFpbCBmcm9tIENhbiBHdW8uIFRoZSBwYXRj
aCBzaW1wbHkgZXh0ZW5kcyB0aGUgVUlDIGRlYnVnZ2luZyBmdW5jdGlvbmFsaXR5IGZyb20gdXNl
ciBzcGFjZS4NCkkgdGhpbmsgaXQgaXMgcXVpdGUgc2FmZSB0byB1c2UgaGliZXJuOCBmdW5jdGlv
bmFsaXR5IGZvciBkZWJ1Z2dpbmcgcHVycG9zZXMuDQoNClJlZ2FyZHMNCkFydGh1ciANCg==
