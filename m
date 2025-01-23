Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA520B7EE;
	Thu, 23 Jan 2025 07:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737618209; cv=fail; b=L4muRu8o8oJf1MECrzypeD10NnLMcA999u1P3ebyqhjltXHCyfZUQWKQK5S5B2Iq4uQvPBulufOv17ZxPoDirAqRYQR6yfj4VRIrVxN4MH2+05JMv9yMBhhvUn631QCrdfX1ULFQBL+Z/RYxmKVjtZAmlkn5dn9Fg82YRaJCEUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737618209; c=relaxed/simple;
	bh=SoyLFSOGBH0Ye6JazttKKcLU+RO1RAQ85hOiZ5rBLEs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lm8pD5jnZxtWnJJ39uW+u6+S9HppmJ4Hmj39PtSJkDmqewAq5zUTcV4D5AnVHNMlPquMDl8TSdU2ZrIju29CaPlfI+mGsbrGfhK6lEcK1mNdxywxDoVL++0o+OqnkW43EZ0Y4TEY9IzkYgx9/VAumY6vqd2xCWJq6bBLeK5Ws8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bx20Wjjz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=QzGcFUpt; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bx20Wjjz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QzGcFUpt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737618208; x=1769154208;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SoyLFSOGBH0Ye6JazttKKcLU+RO1RAQ85hOiZ5rBLEs=;
  b=bx20WjjzO9Ekpvxf9WIi682KEa6meO6jDPxraHEa0F73WD9yIFfhBqs9
   +chDJxbDlq5qHu3IfX6W/liie9Py58zVURMOOdji0s5iOUbC4FW1CvR+o
   paTIW2cw4aDs4V6RHEi8OeI394OLmozKE8Ad+r4URNNCpVwoXzZ+qaU9x
   wIcd2u3ncnUjrDoa1o7aG4ZYd7xICfoPaWX/i0cG6t7DRXMwFOSLT6yaL
   8m/lzNCqohWa1bJFc6vogsfAM5X5xqiELcH0KlBLrIOQi/ChqX0kZHrrX
   tUcVywuUybkzkw2zAlVKPY9ysyVGKH/k/CZ2CMyr1CjBJLHvA9DG20a2l
   g==;
X-CSE-ConnectionGUID: JipL2SMLTC+vG/SukcMYaQ==
X-CSE-MsgGUID: HFW5UACwTkuap99oVagsng==
X-IronPort-AV: E=Sophos;i="6.13,227,1732550400"; 
   d="scan'208";a="36593836"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.10])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2025 15:43:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eo7Nj1ENhEoR/98kRhMfe5OpmxD2RDE1I5CGb1E40VaOupjXD+X7jgieXXQPjbzZvKK/N4VvTeHsXqwaebCiEUSMZBUFCukbhU5+ckxdzaiMiH2B0r5NdhvOGV/YpRmBEXTHlqvlrUngFBbfjwhjqNs/IOfAc9hGemLjRfyR6DfjFB+tO6Z6VXJvtTYW2QnOl+NGa8+U5J08jnIyGVETJzKNYdFfV8FRGG9pl39UdtNmO1+4v9v4BRKe5mgU4zD+1a6j1wNPqaeqbVoAtXF/WBb3VbOc2U+jFU3evcByNP+gCLyrKBhZ9cbv9jM10fVn9YuLqzifhGPPK0cCFBw+PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SoyLFSOGBH0Ye6JazttKKcLU+RO1RAQ85hOiZ5rBLEs=;
 b=OEv0oMfIIik4YSCsEKBhFWCEcscvLPcUxKT5wYmuyc4EZii6zOoOdCP7PDcR+QMLVdZ78yt0NS5Rye9nR/j83sgKT2lA0l4mEX9SYE0CEe031J5rj0gP2lbs8ugq83lQUbY3tKgwWdMM24gm6auc5GGbS308JV0xLSuY/IrD+iOpPjGCULvx3RFXWgUCpEyWHuA0uZtNgCERzijGWEVoT2zO4dzEyIMqFYhp+RvkIWwf8QzqgdS+c22H46Zwy+9p9EDfcVetPEPuCermxK85j7DHxcSvKCCd2ZMjKT8NdM2J5DJ7HtzltEIU0cyDWm88C2JS0RGjpTVguVwEWVoPTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SoyLFSOGBH0Ye6JazttKKcLU+RO1RAQ85hOiZ5rBLEs=;
 b=QzGcFUptXYjPfqUBc6LjstJSZyD+mB7ItB3TUSPg5gB4n20BTiWE6aChV9d9eGxnlZO7MqBqC0wpA7GRb7in+1udxIvZ6hgzPL9vxMAhZerC3i0JdnhhSgv9a/facPVL2l0og7/mFYgpo4tCqija3tKmE7iSfNy7c1EOaL3KNT4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN0PR04MB8128.namprd04.prod.outlook.com (2603:10b6:408:144::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Thu, 23 Jan
 2025 07:43:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8377.009; Thu, 23 Jan 2025
 07:43:25 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manivannan
 Sadhasivam <manisadhasivam.linux@gmail.com>, Dmitry Baryshkov
	<dmitry.baryshkov@linaro.org>
Subject: RE: [PATCH] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Thread-Topic: [PATCH] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Thread-Index: AQHbbJcgG4YGDg9HUEa2rPQTDp+F4LMjKtIAgADP7PA=
Date: Thu, 23 Jan 2025 07:43:24 +0000
Message-ID:
 <DM6PR04MB657565424F925890D1E1CB3DFCE02@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250122062718.3736823-1-avri.altman@wdc.com>
 <4b3a1e3d-b555-4791-ba8b-73986c07c1b9@acm.org>
In-Reply-To: <4b3a1e3d-b555-4791-ba8b-73986c07c1b9@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BN0PR04MB8128:EE_
x-ms-office365-filtering-correlation-id: 898d5349-8506-4b9e-f189-08dd3b819e5f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RENxVG1WeXQyMmI0WUR5ZXdaZHJ6dE8vTHBicEVWRjBkN2pYOElJa0tPQVd0?=
 =?utf-8?B?SHBqTkN2c1p3WG9HVnZ6b3RmSVNIeFJwVXpLTHJRTDJOZlIwemtGY2c1Y1c4?=
 =?utf-8?B?ZlFmZXQ2RDIxbTBqVTdJdVpQcEpDMHBOMFVTVndSMngxb2NIbGNKL1cxekNz?=
 =?utf-8?B?dk5xOTdub3Y3ekg1WjZpWEF3NkdmQjFmY0VQcnNMMEZmRGRsMmtUMDlwSFcx?=
 =?utf-8?B?Q2RrNGY4aGtuQ0pLa0FWZjNxU3Z4ME01dENFSmxlMW14L3IyNDdDQ1VHZVpu?=
 =?utf-8?B?VkdhenR1NHVkc0xRamora25DZzNMT1VZVXIrZVRkdWtmMVRyWno1NFhpNm1B?=
 =?utf-8?B?d3ZoMjh1RHV1ZjFrZWcxa1p2Ukc5TDcydHJKMEsrT3lqdFdCT2diV3JtdVZB?=
 =?utf-8?B?cktEbk9ZKzZMaHB3eWUrK1Y0K21ka2hIQldEemVUSDhpUnV2WVVIVDJ6aGZR?=
 =?utf-8?B?Mk5LejJ2d1o1RHNCR3VIMEZ6ZHprUmRLYjhMSDVPcGYwdTVsazlnSlpudkpO?=
 =?utf-8?B?dVc3a1RMYTAxMXhJeEhrb05YWk1XTEdlRnN4cDB3RzVYY3BQM0NRQkptT0VF?=
 =?utf-8?B?Nit1ckVtOURmMm5nbkVrUU5MWXA1Sjl4d0JlVmRSSkVOL1kyMHN2azRqYzRG?=
 =?utf-8?B?NHJCZlF3Y1FaNkdVWGpxOU9xczR1ajliNmc5T2JTbWozSkoyNUUyWXRTSUFz?=
 =?utf-8?B?OGNKYytpZVQ0U0JWTzlFUVQwcUlRbFVLdm1VK2QwS0wwQXlhc2JUL3pPUWIy?=
 =?utf-8?B?ank5MVhob3FYLy9LbkM2eFdFWTFiWmpoWEsxbGNESjVTbGlpV0o5c3lSaThH?=
 =?utf-8?B?RWlWY29TdDdmV2pJU1ZGTUZCN1NKdEExYU9iRG03bnNVeExQYjRzR0hScXpm?=
 =?utf-8?B?VVp4V21ZMkJITVpOU3piZHRWenl1Ky92VHpxT1k5MXhoejJ1N1BWTDdNZkhX?=
 =?utf-8?B?NjAxVEhxZ1locnR6SkJoang2bTlxdk5oRE5FVzNldkhVWHlGUDFNd082aVFy?=
 =?utf-8?B?TlFJTFVGTXJsbXZTRUhzNFVUaWhZaE1hN05CWjd3a2xKd0ZlYlE3eUtsNVZo?=
 =?utf-8?B?Z3BrUDlBN1cvenJqeHhKTlVtZVowdjZjY0owTEU1Znhkd25NekU0d3I2Zk5h?=
 =?utf-8?B?WFNoV0N1b1ByZlFIeHpTUUx0YzBSOEtRV0x0QS9nS0hKSzdFOVNMajMzVFJP?=
 =?utf-8?B?N2tDS2oxSlR1d3dTOGV0bU9BckxFeVVLbTRHbG52VHdaQzJDck05c2o0WUp5?=
 =?utf-8?B?OWJabVFpb1l5QXZwcElBQktKOTk5S0tNZHJ0dXJJc0lEOUpWb012VmFTRllP?=
 =?utf-8?B?UUcyRFlkaW9MRm1xazFkTGVzOUpRUHJTYTREcy9aeU5IR3FTMGREYldBU0t6?=
 =?utf-8?B?OXBPWjBpZ2g2OVNEblpaaThqZXR4eVVtdmN6NnF3aWFYeXV5c0ZwT2hvS0Jq?=
 =?utf-8?B?UFZSQTRwOHhBYnRhWFBXVk9sWEE3WGhpT3JaR0U4cnhVR29IM3hFV1ArQ1FY?=
 =?utf-8?B?SDdoUHphY29JZFRIbjVIL0hnM2NNZ053OXhYV3ZEM1lRTU52ZG5GWTlzbXcz?=
 =?utf-8?B?aGpoakZQbFJlbUNxNGtUcFp0ZDJ3YzluRjNCRk5GL2tWRmRERzhha21HVkVN?=
 =?utf-8?B?NE9TeDNCQm9NN0ZvTlI4cm5MOEhFRmhtUHVtSEl3YUhJRkRSZkMydW81Ukk5?=
 =?utf-8?B?aytRcTUvUkc1em1JZHZCVzFyLzVpVEVlSWl2eVloR1kvZ29kekFkM0JPWTI1?=
 =?utf-8?B?dm5tbkkxbXZwS2tkZ1cxS0ZVR09ER2RYNmhBLzVYTkdyazRuZURSeVRtb3RY?=
 =?utf-8?B?NGVNWGppNStxdWEvZE5EcUpYOFM0SkU4ei8xUzd4Rm83T3J0cHoxaXB2TjdP?=
 =?utf-8?B?L0hPMUFQTHVValIrRHMwMTJuWlZyd2ROMmhwam1Rd0NJY1RBTHYxMWZ4bExF?=
 =?utf-8?Q?zu5ucJEO2apee0KhRwF7fnwOW/8OSpw0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NkV3Wi9yUnlJdWlMVG5wUCtUbll6Ykxqd2EySkVuWFkxUEM2bmdjU2dTdE44?=
 =?utf-8?B?R2JQblNKczlVbk9XUk9zU0kyVHNpVVVBMXZLeUNFcFYxTGxYN1JtVDZ1UTQw?=
 =?utf-8?B?SXlDSHdOcGt2elVmekFMbXkzNEpuMXpERkNZMTFZcjFGSjNCQ0tZbGg5MDJ2?=
 =?utf-8?B?UFFFbFpjaUVRSUpKYytMUzAvYTdKNng1ZHp2b2dBK1hyRzVuZUF0OVBLRitw?=
 =?utf-8?B?aS9JcmNWSFpQNHpvWTJmNkNMdVh0OGJSbEoybUZ3U1B4Ukk1TEs4cFBuaytB?=
 =?utf-8?B?Q1pPL1NMSnpoclFKcktDZUo4S1dVZ2NaczF0dzJJVkh3YkUzVlJPbnJ0Znlu?=
 =?utf-8?B?dzRTKzMxWkNrOEpaUjREWnZOR0NjQ25ORFNpRzBiblMwM2J0YnlxMWJZSzhl?=
 =?utf-8?B?d0lFRyt4aTdEOW1VdmQxckx4VUx4d041TGVnb3J0RGhEUk1oNGN2TWFIU2R2?=
 =?utf-8?B?ZGlTRFdMbldPQ01Kb1NSNkFtS04rS1ZBUkh1dklWS3dNZkhiRkhpeXBBdlZv?=
 =?utf-8?B?QlFhT1d3WDREdG14T2hFTGFReU5GU3YwbEphVGFwVDdRMVUrQ2lvMTE5emEw?=
 =?utf-8?B?akxKaW5CaTByY3RlR0RUOTlqdzA4N1NXOU1wckxiLzRFc0J3TnVYcmFxM2hk?=
 =?utf-8?B?Nmt3VnYxZUxzWE85L1FmNloyMW8vYXJFMGNpVitCL004NTFUVzJTYlBFaGg1?=
 =?utf-8?B?OUZTNDF3WVlmcWoreXM3cXg0UjBxbzdRbWkxaDVzeGNTcCtWcHVsQ2E5QnIr?=
 =?utf-8?B?OU04NGc4SklOQUZWYzhuRVM5QlFaZ2FFSzdiUUxWcENIV3ZZUWM3ekVUbW5C?=
 =?utf-8?B?eXBKMkNZcUFlVUtTOTU1djF6UGs4enkzQUVxOW1VN3BBZWdiSWJhcFhIVVU1?=
 =?utf-8?B?UmNsaFcyVS9zb2Zqd3dVcWs1RTZhUElWeVZOaWUrOVBvWkgwSWJvT1JndlZl?=
 =?utf-8?B?ZVA1UjFqSlBzNU16Tjc3WXlwcUx3S2M3bVhZdnFMUldEM1BmSWJZdW1TR3lk?=
 =?utf-8?B?aHE4eFVxaHNoNjRPTUJCUWdWKy9DeWovSjdRendhUEVRUGN1b053WGxQOUNw?=
 =?utf-8?B?SzZPNStYejZyd2Fra3NPeXpzOWlMLzRuZjRKVlE3cnRuUG5sMDFFa2NnSDBz?=
 =?utf-8?B?WTNLVGJYOHlJZGlhc3NBaEhVMjRtNWFZU3ZlRnVJU0FkZ2pmTnBMRUthektH?=
 =?utf-8?B?bXgwek5hVHBseWZmc2FRdGx5eGEweUlyL1dWcDNNQ0drZ2JoeHEwa3Axam13?=
 =?utf-8?B?TkVxNzFMT3Q2KzZYREhqcEFocFlId0xJZ2x1VHBqOHBsUmxMM2tzTkU0bmNy?=
 =?utf-8?B?c1BSV2Q5WU1CSks3SE9hTEtnR3cvdjVYQXB3cmp0MFFlWWZmL09IcGZwbWRm?=
 =?utf-8?B?cUFJQ0kzZi9vZDJZZE01L1d2SDFzQUcwdlRVczg2dnpqd1NSVGpNaW5wdDBF?=
 =?utf-8?B?dS9lbFdHdzRnM0k2cDd3SkhGU09ISUp3N1FrVVU1a3dKRVdyeWVZTnhTV2xq?=
 =?utf-8?B?VUpzV0hlRUNtNWFydEtVSzhvYWZzUXpOR0JGSiszaFlSUXcwTEpKNTVRakxU?=
 =?utf-8?B?czMveXZCaGwrWTQ5aFZReXM4WTlROC9HMzZhZnNaTXR6T1pYU0xXQTJZSkdF?=
 =?utf-8?B?VlBTOU9pVUZGd3oycG8yd2UxRHY1M01jeHIxUFRkOUJVVmJtTkRscytBM3NK?=
 =?utf-8?B?VEtEaXFGc0dZUGUxdldRL1NSSnFpUUYvZXNTYnU0c09mdVRkTXNIbDVSVUJ2?=
 =?utf-8?B?MytiTTlIQVhLSXNycFNlTnJMWWc4V0VPMmNqWjZWRW9vamVuR0pwanZRMi9r?=
 =?utf-8?B?bHljU05GWjh6VWdhMFh2bTRFTDUxL0lsUUU2dDMzY25NU3hqdzBpNFQwRWpz?=
 =?utf-8?B?QU1Yd29yRFQxRE9ma3NUVXdSRUJkTTVWUUpRSGZyTFZNSm1qS3IvTk5aRGdF?=
 =?utf-8?B?K2l1d094Wm0zSnhUSExCc1pqY3cyTjFMakJEb0x0ZUErTUxQbWttTHpLZHNM?=
 =?utf-8?B?M1MvZDVOS3VGZ2p6YjhJendhNzBMZG1KSXFRUUh2T2lQMkFjaXdKYUIxdXQv?=
 =?utf-8?B?NEtndEJiWGxYeU9JazVyaEFHMVFzNkJSS0FPRlluTVFJbVpNR3E3QTlHdmpy?=
 =?utf-8?Q?Aw3f0rH6EsPjrLJ/NWadnvQ0d?=
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
	AXuNjj8/RiZvtMUaGUuQpiDXkoWjTZzTWho8ZFLRQ+t6eIIjUjBh050KoGvojY49zj8e1BTuVu7N7QmzOy3E+hbkMEwWlfA8bhOz8sLEkkHfR81q4NNRUH19Ax060mNdSOvAg1JY6cpaSdKqYBpcclIj+SwKaJJAJhxxLsOQZIR4hd9xkhuD7YyXD2zTvHqFIqKnOMyvKQcIh7k2Z3RhjVcSkGdMXxPWLQHAywxPoWar+t0HbSvB7hJr5uZbRCS/5DfFH2jLkuqxfbWkFofhY/rsfPMkVeKQqDHb0/9Yy7uqX+pvXnaf5loa46Q0A9rH99COdIqTsIXTPko25fTBr5getXBypVCB56fBU3gqJUJiFJMBbfZBVl2Vk+hZ72QZSk+usuvCufiw0MZnrif1J6tq9SFIWgfYs/WgAhPtInB2rcZnwey1SiQzgOXvyd81xlXpmOxn/7zshAKTMxheIcQkVFt6uoVDsLD4iEnmR5DoYUB7/qLHpS3G+vCoa4EvZ6h645Rh1gtTkESoBuRHOoKmNc1WBU9hw/te9g1Zga5QtmHOk2OCT9qz90HiTCL0aSDjxWYJYuqibqAiBOUVOzb4N2BQKJ8PBE+sBf2n0HEbw+q+l95tuwxBqmjTF9aR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898d5349-8506-4b9e-f189-08dd3b819e5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2025 07:43:24.9776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kspuCD9KIyVVTbO3/gNvCDydlRI7LnyaOy3FvGOZsCemhfnbvN0nb73VVT56L0o4cbig8S22+zD/MLYIxySk9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8128

PiBPbiAxLzIxLzI1IDEwOjI3IFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBUaGlzIGNvbW1p
dCBhZGRyZXNzZXMgYSBsb2NrZGVwIHdhcm5pbmcgdHJpZ2dlcmVkIGJ5IHRoZSB1c2Ugb2YgdGhl
DQo+ID4gY2xrX2dhdGluZy5sb2NrIGJlZm9yZSBpdCBpcyBwcm9wZXJseSBpbml0aWFsaXplZC4g
VGhlIHdhcm5pbmcgaXMgYXMNCj4gPiBmb2xsb3dzOg0KPiA+DQo+ID4gWyAgICA0LjM4ODgzOF0g
SU5GTzogdHJ5aW5nIHRvIHJlZ2lzdGVyIG5vbi1zdGF0aWMga2V5Lg0KPiA+IFsgICAgNC4zOTU2
NzNdIFRoZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRzIGxvY2tkZXAgYW5ub3RhdGlvbiwgb3IgbWF5
YmUNCj4gPiBbICAgIDQuNDAyMTE4XSB5b3UgZGlkbid0IGluaXRpYWxpemUgdGhpcyBvYmplY3Qg
YmVmb3JlIHVzZT8NCj4gPiBbICAgIDQuNDA3NjczXSB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBj
b3JyZWN0bmVzcyB2YWxpZGF0b3IuDQo+ID4gWyAgICA0LjQxMzMzNF0gQ1BVOiA1IFVJRDogMCBQ
SUQ6IDU4IENvbW06IGt3b3JrZXIvdTMyOjEgTm90IHRhaW50ZWQgNi4xMi0NCj4gcmMxICMxODUN
Cj4gPiBbICAgIDQuNDEzMzQzXSBIYXJkd2FyZSBuYW1lOiBRdWFsY29tbSBUZWNobm9sb2dpZXMs
IEluYy4gUm9ib3RpY3MgUkI1DQo+IChEVCkNCj4gPiBbICAgIDQuNDEzMzYyXSBDYWxsIHRyYWNl
Og0KPiA+IFsgICAgNC40MTMzNjRdICBzaG93X3N0YWNrKzB4MTgvMHgyNCAoQykNCj4gPiBbICAg
IDQuNDEzMzc0XSAgZHVtcF9zdGFja19sdmwrMHg5MC8weGQwDQo+ID4gWyAgICA0LjQxMzM4NF0g
IGR1bXBfc3RhY2srMHgxOC8weDI0DQo+ID4gWyAgICA0LjQxMzM5Ml0gIHJlZ2lzdGVyX2xvY2tf
Y2xhc3MrMHg0OTgvMHg0YTgNCj4gPiBbICAgIDQuNDEzNDAwXSAgX19sb2NrX2FjcXVpcmUrMHhi
NC8weDFiOTANCj4gPiBbICAgIDQuNDEzNDA2XSAgbG9ja19hY3F1aXJlKzB4MTE0LzB4MzEwDQo+
ID4gWyAgICA0LjQxMzQxM10gIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHg2MC8weDg4DQo+ID4g
WyAgICA0LjQxMzQyM10gIHVmc2hjZF9zZXR1cF9jbG9ja3MrMHgyYzAvMHg0OTANCj4gPiBbICAg
IDQuNDEzNDMzXSAgdWZzaGNkX2luaXQrMHgxOTgvMHgxMGVjDQo+ID4gWyAgICA0LjQxMzQzN10g
IHVmc2hjZF9wbHRmcm1faW5pdCsweDYwMC8weDdjMA0KPiA+IFsgICAgNC40MTM0NDRdICB1ZnNf
cWNvbV9wcm9iZSsweDIwLzB4NTgNCj4gPiBbICAgIDQuNDEzNDQ5XSAgcGxhdGZvcm1fcHJvYmUr
MHg2OC8weGQ4DQo+ID4gWyAgICA0LjQxMzQ1OV0gIHJlYWxseV9wcm9iZSsweGJjLzB4MjY4DQo+
ID4gWyAgICA0LjQxMzQ2Nl0gIF9fZHJpdmVyX3Byb2JlX2RldmljZSsweDc4LzB4MTJjDQo+ID4g
WyAgICA0LjQxMzQ3M10gIGRyaXZlcl9wcm9iZV9kZXZpY2UrMHg0MC8weDExYw0KPiA+IFsgICAg
NC40MTM0ODFdICBfX2RldmljZV9hdHRhY2hfZHJpdmVyKzB4YjgvMHhmOA0KPiA+IFsgICAgNC40
MTM0ODldICBidXNfZm9yX2VhY2hfZHJ2KzB4ODQvMHhlNA0KPiA+IFsgICAgNC40MTM0OTVdICBf
X2RldmljZV9hdHRhY2grMHhmYy8weDE4Yw0KPiA+IFsgICAgNC40MTM1MDJdICBkZXZpY2VfaW5p
dGlhbF9wcm9iZSsweDE0LzB4MjANCj4gPiBbICAgIDQuNDEzNTEwXSAgYnVzX3Byb2JlX2Rldmlj
ZSsweGIwLzB4YjQNCj4gPiBbICAgIDQuNDEzNTE3XSAgZGVmZXJyZWRfcHJvYmVfd29ya19mdW5j
KzB4OGMvMHhjOA0KPiA+IFsgICAgNC40MTM1MjRdICBwcm9jZXNzX3NjaGVkdWxlZF93b3Jrcysw
eDI1MC8weDY1OA0KPiA+IFsgICAgNC40MTM1MzRdICB3b3JrZXJfdGhyZWFkKzB4MTVjLzB4MmM4
DQo+ID4gWyAgICA0LjQxMzU0Ml0gIGt0aHJlYWQrMHgxMzQvMHgyMDANCj4gPiBbICAgIDQuNDEz
NTUwXSAgcmV0X2Zyb21fZm9yaysweDEwLzB4MjANCj4gPg0KPiA+IFRvIGZpeCB0aGlzIGlzc3Vl
LCB3ZSB1c2UgdGhlIGV4aXN0aW5nIGBpc19pbml0aWFsaXplZGAgZmxhZyBpbiB0aGUNCj4gPiBg
Y2xrX2dhdGluZ2Agc3RydWN0dXJlIHRvIGVuc3VyZSB0aGF0IHRoZSBzcGlubG9jayBpcyBvbmx5
IHVzZWQgYWZ0ZXINCj4gPiBpdCBoYXMgYmVlbiBwcm9wZXJseSBpbml0aWFsaXplZC4gV2UgY2hl
Y2sgdGhpcyBmbGFnIGJlZm9yZSB1c2luZyB0aGUNCj4gPiBzcGlubG9jayBpbiB0aGUgYHVmc2hj
ZF9zZXR1cF9jbG9ja3NgIGZ1bmN0aW9uLg0KPiA+DQo+ID4gSXQgd2FzIGluY29ycmVjdCBpbiB0
aGUgZmlyc3QgcGxhY2UgdG8gY2FsbCBgc2V0dXBfY2xvY2tzKClgIGJlZm9yZQ0KPiA+IGB1ZnNo
Y2RfaW5pdF9jbGtfZ2F0aW5nKClgLCBhbmQgdGhlIGludHJvZHVjdGlvbiBvZiB0aGUgbmV3IGxv
Y2sNCj4gPiB1bm1hc2tlZCB0aGlzIGJ1Zy4NCj4gPg0KPiA+IEZpeGVzOiAyMDlmNGU0M2I4MDYg
KCJzY3NpOiB1ZnM6IGNvcmU6IEludHJvZHVjZSBhIG5ldyBjbG9ja19nYXRpbmcNCj4gPiBsb2Nr
IikNCj4gPiBSZXBvcnRlZC1ieTogRG1pdHJ5IEJhcnlzaGtvdiA8ZG1pdHJ5LmJhcnlzaGtvdkBs
aW5hcm8ub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3
ZGMuY29tPg0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDIgKy0N
Cj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vm
cy9jb3JlL3Vmc2hjZC5jDQo+ID4gaW5kZXggZjZjMzhjZjEwMzgyLi5hNzc4ZmM1MWNhMmEgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBAQCAtOTE0Miw3ICs5MTQyLDcgQEAgc3RhdGljIGlu
dCB1ZnNoY2Rfc2V0dXBfY2xvY2tzKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGJvb2wgb24pDQo+
ID4gICAgICAgICAgICAgICAgICAgICAgIGlmICghSVNfRVJSX09SX05VTEwoY2xraS0+Y2xrKSAm
JiBjbGtpLT5lbmFibGVkKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsa19k
aXNhYmxlX3VucHJlcGFyZShjbGtpLT5jbGspOw0KPiA+ICAgICAgICAgICAgICAgfQ0KPiA+IC0g
ICAgIH0gZWxzZSBpZiAoIXJldCAmJiBvbikgew0KPiA+ICsgICAgIH0gZWxzZSBpZiAoIXJldCAm
JiBvbiAmJiBoYmEtPmNsa19nYXRpbmcuaXNfaW5pdGlhbGl6ZWQpIHsNCj4gPiAgICAgICAgICAg
ICAgIHNjb3BlZF9ndWFyZChzcGlubG9ja19pcnFzYXZlLCAmaGJhLT5jbGtfZ2F0aW5nLmxvY2sp
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IENMS1Nf
T047DQo+ID4gICAgICAgICAgICAgICB0cmFjZV91ZnNoY2RfY2xrX2dhdGluZyhkZXZfbmFtZSho
YmEtPmRldiksDQo+IA0KPiBIYXMgaXQgYmVlbiBjb25zaWRlcmVkIHRvIG1vdmUgdGhlIHNwaW5f
bG9ja19pbml0KCZoYmEtPmNsa19nYXRpbmcubG9jaykNCj4gY2FsbCBmcm9tIHVmc2hjZF9pbml0
X2Nsa19nYXRpbmcoKSBzdWNoIHRoYXQgaXQgb2NjdXJzIGJlZm9yZSBpdHMgZmlyc3QgdXNlLCBl
LmcuDQo+IGp1c3QgYmVmb3JlIHRoZSB1ZnNoY2RfaGJhX2luaXQoKSBjYWxsIGluIHVmc2hjZF9p
bml0KCk/DQpXaGlsZSB5b3VyIHN1Z2dlc3Rpb24gaGFzIG1lcml0LCBpdCB3b3VsZCB1bmZvcnR1
bmF0ZWx5IGJyZWFrIHRoZSBmdW5kYW1lbnRhbCBjb25jZXB0IG9mIGNvbmNlbnRyYXRpbmcgdGhl
IGluaXRpYWxpemF0aW9uIGxvZ2ljIGluIG9uZSBwbGFjZSwgd2hpY2ggaXMgZXNzZW50aWFsIGZv
ciBtYWludGFpbmluZyBhIGNsZWFuIGFuZCBtYW5hZ2VhYmxlIGNvZGViYXNlLg0KV2lsbCBkbyB0
aGF0IGlmIHlvdSB0aGluayBpdCdzIGJldHRlci4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBU
aGFua3MsDQo+IA0KPiBCYXJ0Lg0K
