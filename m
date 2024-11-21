Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1E71C304F;
	Thu, 21 Nov 2024 21:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732223226; cv=fail; b=Wjuujv6cb7KrkkPVONnRBXRHTR/bgtzWZcu+MjsM3eObp/+kLaAmW0pLVv25rcCqkvK3UV5M0Aqn75KUK36vqUkltAAD63urgwCZk6AjwDqhHVGeoZ+FPM+jwue8ebTBvmCX7GG3Lu0QYhMu1r2Xdb73wy8GmulUSYoCkNTLO7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732223226; c=relaxed/simple;
	bh=89aG8XgPZxDGUhkx9DsE3bpdwwMBizzo1cx3V5W1gRo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rCwHyol63NyITDo9ZhMcxvCLhyPs1rrWL8I1TyoT3o4+0QZ+xiAObbp2LcNNTSEF2TngpqG3PVgj49qRKgtxLq/fuLxND7XT4TXXtQAHh66Um5A47QV94Be0JOCvyAHCZDOlRbjFWVkSphfpqg3sR1u2m8zcbmwoQFmoedgxfRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pmiQEJN/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=t3HYSxd8; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pmiQEJN/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="t3HYSxd8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732223224; x=1763759224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=89aG8XgPZxDGUhkx9DsE3bpdwwMBizzo1cx3V5W1gRo=;
  b=pmiQEJN/clIuGLUD/V3O9iKRZo2Qo1zURip0VqgcP1J9U9gZVZ375ciL
   /TTzGwfQGe+VVeerAblWWVB2UozbLaF649JGEaMqCfmit25oOJ1i5EscJ
   ymARCaNz0T1r0Vwbi4ekbOl13QPkvUeVCloM/t5DtF9QAOUM1M1Wj0F9t
   Y8PAjzWNNCXAf4ZxG8NP2VI0s3GPgLPEnHaqhm0HtLKLLkVKCTvvMC81N
   VgnPewailDqMWbGpc9/H05tTSUlfoFwLAp4XBv3r2zof8anKeIBTBuhkh
   oITTbguzT62W1Q9kSk7f2l3yXlQx//l2t1e+4A0no852gJK6t4XIFdze5
   A==;
X-CSE-ConnectionGUID: hDu2QRfSSPiXQ7dPB/2Ihw==
X-CSE-MsgGUID: DvAm8Hs4Tie8FEe4z+lZWA==
X-IronPort-AV: E=Sophos;i="6.12,173,1728921600"; 
   d="scan'208";a="31424269"
Received: from mail-northcentralusazlp17013061.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.61])
  by ob1.hgst.iphmx.com with ESMTP; 22 Nov 2024 05:06:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXYlkvymr6TY9EHLXntM7QqDZzvqFvCr2swXgxk2p8wt+WeLG7UJZTk3g94CEs0Myu6U8jJ7CaIcK19nOUoeTItO/RcAMPT4WfQJ+hDbz2UwgTK3NWjspWDH9OukJe3kP9aTMGQ+b5QeLaxYeRxeFC3Lwo49a8LZL1Cuwmg665e4G3LsdAxUyyp8ha1JRw85ZjMcVF87PWJiuIjq3XZdDU8GbymtRCLA9u2N4UWzWj3vvS0J9yYpkPD019wGb6RPG6CHceE9wTnjhZvAEf+NRdB7wyPXt9n0Y2xq98qfEqcdp2OcaTWPGsr8GMp2GRLxThURRtDrCG29SlI5cQkGKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89aG8XgPZxDGUhkx9DsE3bpdwwMBizzo1cx3V5W1gRo=;
 b=N2FbSwSkPXmKwHZdoFLUxcA1Beiudax0Io0YTavSxAK1cM5QRi+NZBULcR+LDOH0pDYiCIg62l+lwf3YpnzZShIZeF1Gp9MvF47mqj/dulEa7g64lbkA7zkDft2aWvAPksTtAEJXD3JXKGAhxzvHc4U+aUvMbFINgMsy765H7NrbC21FA+T9KNwwAGXJe6TH11pHg0C88ouCWTODuuT2b6+rvff+1CyZfn80W8h3SmVGKXrU125rvy201KJocRphMEZDvMSSLfUPr1f1jjQhR9+QAz8inUnYYeDfInsKXMkZ/kAnS3UB8lTiXNRwLHVeLGgnZjhDWoJn64tZEfLMEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89aG8XgPZxDGUhkx9DsE3bpdwwMBizzo1cx3V5W1gRo=;
 b=t3HYSxd8IT4ne8mLmYijxjIELMTBXioHu7L4+sdXGiFWijFRQ5xkUEXuYgG9tip2emGhFnCFurdki7uVYTRogV6vNYqLu4MptAhkL7J6LLfh97bWEqhlHs4MA+CqaAtxdECiqUUItYwyB4E92SqRNcwuz1jIn+rAxvvB7YmjtZg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SN4PR04MB8318.namprd04.prod.outlook.com (2603:10b6:806:1e9::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.17; Thu, 21 Nov 2024 21:06:50 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8182.014; Thu, 21 Nov 2024
 21:06:50 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bean Huo
	<beanhuo@micron.com>
Subject: RE: [PATCH v4 2/3] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH v4 2/3] scsi: ufs: core: Introduce a new clock_gating
 lock
Thread-Index: AQHbOchMsHzJ8dy2eEyFfqftsiUG+rLCOLqAgAACVTA=
Date: Thu, 21 Nov 2024 21:06:50 +0000
Message-ID:
 <DM6PR04MB65754AAF1FD62DC4ECF32A69FC222@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241118144117.88483-1-avri.altman@wdc.com>
 <20241118144117.88483-3-avri.altman@wdc.com>
 <2955aa00-824d-4803-96f6-35575ae9560e@acm.org>
In-Reply-To: <2955aa00-824d-4803-96f6-35575ae9560e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SN4PR04MB8318:EE_
x-ms-office365-filtering-correlation-id: 7bd14008-739b-4658-e0a0-08dd0a706b04
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RFRzdWdTSFJEMitmNXRpN1NZdTlUbEp3SklwUStHNHQxbkJ1bjVJTVE3SXIx?=
 =?utf-8?B?ekdnT21pNlBJb2JWNk4yV0NNeXJ0ZVNJaHFUZTdtVXZjQk54RHdTYi81NDlS?=
 =?utf-8?B?bXNHOXd4eVpUSkgzWXk2eGZJMjZFRzhIU1daaXBpeStXeDdET0tmWWpVMWsw?=
 =?utf-8?B?K2o0VWhjRURsaUJsMVhKSUlpUzBuVGVseUtvaldNTjF1RmNYZjltVUttc3Jm?=
 =?utf-8?B?ZzBHbDJVNHd4a2RiZ2lLTWE5UzdUWm9QUkQvaWdjRWd0enY0YjdjVFVsUnFr?=
 =?utf-8?B?N1NiMUN4d2cwUnFGOGVVSEF1U3l1RWZxYTRYTU5ycFNjd1VhWFRVMEs5anRF?=
 =?utf-8?B?Q2xhVnNCME1RTmZQd1lOVVBhelpZWEFyRUxNKzc5a1AyRVhQR0YxU04xdWgz?=
 =?utf-8?B?SEhTWCtueHNLamQ4dGgwclVjTHZsbVlmdElaNGtDTFZBd0t3dVExSEwyejJK?=
 =?utf-8?B?UHhXMXA3YkZ3ZG56dysxbEZidlBmV2xFUTdTT3hSR0IvUGZKTGdQeHNqOUNs?=
 =?utf-8?B?dEt0UGloT0wyTzY3TzhRVHFSTWpRQTgwU2d3RjlaLzd4d2FxdWdIT0owbFB6?=
 =?utf-8?B?YWVDdGxYVHBFY2dWcExIZFNDMXlRa1VmcVJaREtxWllWM1FpOElkT21OY08v?=
 =?utf-8?B?aC9lbmFQZks5OEJWYS9URVl6R0FDK1E0eHNURmovL2F4N2FSRDlDUjl3MlNF?=
 =?utf-8?B?RUNxQmMwYisrZEsvOHFiNThvUHZVWlM2VkloYzV2aXpuQ1RVVGd5REMzTURD?=
 =?utf-8?B?M0NZc0I3Y0Njb0VhbW8zUFVwdzZWejNWR0xGaEV5SEx4Ymg2MW9iS0F5VTgr?=
 =?utf-8?B?RkZnaFVRdk9IbDRVbzYyaHUxWmRyTnZQcVFnbllxREJXVHYxanFsKzc0OGd5?=
 =?utf-8?B?MUhhZlB5TjNRZWFoWFBQRUFOS1BRVU1QMWJKamhxTzFyQ1ROenZPdVNsVndS?=
 =?utf-8?B?R3JvMUJKMUx2U2lXR0dERG9LTzZJSDJ4WjF0TjlSKytuM3M0MEhzS0h4SzB5?=
 =?utf-8?B?UG9jc2JYL21XZjdRc09mZllmODBlbmZoSU1KUFcwdEJyNkgzWlROZkd0V05I?=
 =?utf-8?B?YUZGUjFXZFJwY2ZYWDdHV1RNYktabDVESlZEVmE5a3lnVXFJWDA0K1RoWkdv?=
 =?utf-8?B?cjdZNmlHai8vTkJ2Y2tFWXJRbU9NTW9RM2w5VklkbmdsczNCZUZkQi9Ca3Fk?=
 =?utf-8?B?bVNua3VJQmJiWVNwV2VQV2JRVlpwOXJjbGNnMTF6dkdUSEJwR2JpclBIdGUw?=
 =?utf-8?B?SU5jSFZOdyt5SUVWbjhKTk5BNmR2cXFYWmc5RzIxdlJYQ3VTR3RCT2VwVktu?=
 =?utf-8?B?OGwveVZtU1V0UGJnRmtNRC9aRk5qSjRpdVVLUHpKdFE4Z29aOStTREtSbEZO?=
 =?utf-8?B?MXFXaTlNT3YxNGxqeHNYbkF6WlR1SVRGRGZXVFNUMHVQbjRPSkJQUkxiSURP?=
 =?utf-8?B?cGQwZDE4TVBZcytOWXplZ29McTRHWEpxbjBlY2xXWHFlTHBmeGhXU0VidEtZ?=
 =?utf-8?B?Y0duKy9veDVJZ1d2ZGVsTHFoRU0yREw4Vld6dHRqd0FIU1haK2lUc3RmL3gw?=
 =?utf-8?B?V0xnUGsyS29GVy9haVJLNElpSHRuZkJHTUVFS0F5ZzhUWE9RN2M1bHRtU3pt?=
 =?utf-8?B?UnB4UmZOZ1dTWlNTeHpYeHBQanBUZjZOdXFld21YN1hJVEVsWG5wcmhsZVY5?=
 =?utf-8?B?aDRLd0lHMTllTG9PeHhJVkN3WEpkamlsSW5qNWl5K092WE1Tam1pbDhzOU5V?=
 =?utf-8?B?cmoyUzYvUHROeHFQSzhIS1BVQnR1RTNCczE1eTlXa0p4VVdlbnB5RVFwTXdz?=
 =?utf-8?Q?e7VjKZXKXnm4Rf6nL513WYqEAP0XInvShDq8o=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VnVreTZPeGFNTW9wTDFiWUo2TlAwYWJBV3lkVW1UN0pKNVNNMXp2cHg4VzJ4?=
 =?utf-8?B?aEV0bllTeHd5bWJ2aG9pd2FMYnJMZ05hQkV4NzhWWHZVL0UwR09tcnU1bVRK?=
 =?utf-8?B?OEhhY1hLOWNjSC9hQW9NYW1hbVYzTXo4T1lMSFV2ZXhlaGpaU0NhRGcvZE40?=
 =?utf-8?B?V2ZTbWJRQmpPYSt5dXdTMTJUQnFHL2RVR2w5N0xoWXU4NUoxNEM5RnFxVVRr?=
 =?utf-8?B?ajBTVm1DeTB1Yzl6dUpYVS9aSWgwZElDVlJRSVNoa2VQeCtYTHc3WHkrRzdI?=
 =?utf-8?B?RVhhVG5QcDYyeHZTajc0R3IyRUYrR2FrWlFzZTdxNWdjMlAranM4V2FDZ2px?=
 =?utf-8?B?UUt0UEN5VEwzTis0R09wZjA0R016blpkUzZ4YXI5elRYKzFoZmNOVnh4b3Iw?=
 =?utf-8?B?L3BZY3JBNi9oQTVDMWRZQmZsb01odnE1MVM3V2xrWElab1FMN1Ftc01KTmM1?=
 =?utf-8?B?SERqSFVTVjVVRUZ2TnVscXVQbXVPZDBzZ3BLM3RSNHp3YWVzMlNJSGthaG9o?=
 =?utf-8?B?YllYbmZSSk5NNUxHejNtTTBySzY2ek8rNDFYMWdGWFgxQTl3bUxuYlZGeTBa?=
 =?utf-8?B?M1djL1VwMWdjSTJlQVJBMFRFYmM3eXpuSEoyblpScTBNTkQ1VmZINXl2UC84?=
 =?utf-8?B?YmU2b0VLT2pTcElRaDlrY0dLcC9kVkxGNmx6WlY2M1plVnAvRC9HYWNPSEdr?=
 =?utf-8?B?QjlRUG43TkFjc3FKZlE5QlZBMkVVK1VvY1E5T0ZCQUVVbU91Wi9pMmRJcFRo?=
 =?utf-8?B?TlBSaExZeUtCQUEyd0FDNVk4N0xNVEVrSzdKekREaTVGZGFIbHJZd0xHellL?=
 =?utf-8?B?SGNmUks5VmtKYTkzOU1ITmllWTdBTWVHTnZYMFFxUU9Xb3l6NUt4OHhka1BO?=
 =?utf-8?B?UGt6dXJ5QnJ3ZVRLWlNORHNFaGFYdFYybk1ZN1hEdytWaHlic2pJM2NqWlRX?=
 =?utf-8?B?QXU0VkhQeVBzajdrdGZUZjFPWEpNaFVOMThCb2EwVE9DR2ZDWDk2Wmpuckxu?=
 =?utf-8?B?R1YvcXYrYTFINWlEdml4L0hoTVZJSCtBOFNZaGFrdGxXNTZ1SWNsTUFDQ3pz?=
 =?utf-8?B?ajdBcWNzNTBOWllMcmJ4Rm9HbldCQW50bHROYzlTZm1VYVJhWHVSWXhTYjdZ?=
 =?utf-8?B?Ung4eU9XZ3FRZDZFM2RtMjdNb05EbGlsTjlGZlNSb1g0OHhra21kSmljSXor?=
 =?utf-8?B?OGs2emg3c1lZWk1Odi84UmcySjRwcXFDYTdFYXFLSHF2eWdzMGpENmlYUmIw?=
 =?utf-8?B?QmlxS2kzLzhENkdIUFdPU0tCcGZRRUJyTzdscDMyTUFHaXN3TEVzdStBNVpm?=
 =?utf-8?B?bzFaTEVFVlVibktCNlFzTzJIWG9HNEhydUFKMmhWR05yMmZuMllRcXJodEN4?=
 =?utf-8?B?T09VZVJaeGtiUHRPNm5nME1wdWQ0aGtnZlgyWHZoNTFzZzNGSlBscHFaMERS?=
 =?utf-8?B?U2xnRU5kdll1NlVDWDdIOEZyelJsZTY1cEd1VVpSMVdZaVA0RVZWOXBTazRT?=
 =?utf-8?B?S3ZkOWZvRzU5bEVHY1k2d21vaDFZclZIZzMxTENkWWZ5V3loeE1VcFNnMzBr?=
 =?utf-8?B?RVN5cW9ib1huZWlsU2lJMHhlVkdERll2MEtZMlJ2WjBhZ1B6VlVFR081UXky?=
 =?utf-8?B?SSthU0REbXA4MkdvM1JSWXdvZGQ4YjBzdk5nL2JoTjhnMXNpRjJ6Yi9rNHBX?=
 =?utf-8?B?aWF6SS8wRVgwbFB5ZlhUV1pTdVRMWVI2c2VkcVZGTGY0b3NTZEFtK2xsVjlp?=
 =?utf-8?B?Unk2WURacm0wb3BFMXZYQjh1YUswMFVOaE8zZkdqWHBsWWJOU0Q1d1dCbWNi?=
 =?utf-8?B?cFk3OGZhTFV5TzE1dnNFVXF5UGszWkhERlBXKzQ0VWhkRlVka0dydU9kTDN2?=
 =?utf-8?B?dTdiSXRhdERqSzVOSGVHU284Nk55NDJJcHA4WS95cEo5cnZMUXZIUW5BU2NF?=
 =?utf-8?B?R2F1d3NCU1lxM3JvUEFxVkZncUhkbEJWeVZCaHhDUlY4UnpFV0JXbXFjbzIw?=
 =?utf-8?B?ZkgwZmZ2MnczTjFLVGF2M1VzVHdTNTd6a2F2NnlJUjB1NHMveUIwUlZ1dDV1?=
 =?utf-8?B?SFA5MDJYZXdRQzRVdExuTUxFMUxnNnlUL2JJSGRlL21zWCtNZFdON29pT0pD?=
 =?utf-8?Q?9505Rqonv0sty3OB+48IBtOUW?=
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
	gjXx3kzr20ZGitDc1V/ujE80drKc4h4v53lGT65G3aBZFOmdpQVgVrThLvpV5hZXjjx/DY7fOEZFnv4hqbcIWD7S04CcQNlkzl9udSqEKBbQWlMTtExtkfaI9HkxHEii36tkgXxdxVJQOXejwNwECHu9eicZBSlYCRsXhowpu9CqIOJy+LXb/Qw0TRLHRUlY6R3odVX8Sd0k9NsblEBhyMsvRIYHrSyN5Xys1g+dWhCYvfnMp1cSzTxaZ54KntGVgL6GljpQsrzhdNhQa6OxAdkB2CbVo5zlNuTHKgAcCRlPKHgk5c2Jpf4I6SRuanPYcyiwaRcvHCKct8EXyNF3OgrFjfE6W5T+zV4M1Mexr2ucrZADKHGKPJQuh8KdXeV2Vwf9+wSybk4cEdvT/jYUGoBt0lKZrfhC+gcJPDib0RIxkocIHfA1uF3fp1z7O++GQaUdD2dLN/7I1z0pNXF9NAWWxkVWtUyzkJUDrCPraIRih05p7tYWH39IfxixReSqQ1+/9ngmVke7bvnch/IxqlOogg3y2ddCfXYwy0E3iNQkWIVZX6KRUMK2tL+YhHem5Mjquxv47c/1v4s5Ayblf1mM5z9sH+D6QyA56wrAPn30snslLrrBIs5TRnVAPzK8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd14008-739b-4658-e0a0-08dd0a706b04
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 21:06:50.4412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5cFgwsB8AcJQCmdf7u1jsZEX4zpybDOjW8GvRcI0KqJtlhTHPmOTmMza9Hw68RsSbXtt9h18Wr8WZ0DbqGmHIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB8318

PiBPbiAxMS8xOC8yNCA2OjQxIEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMN
Cj4gPiBpbmRleCBiZTVmZTI0MDczODIuLjYzOGQ5YzBlMjYwMyAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNo
Y2QuYw0KPiA+IEBAIC0xODE2LDE5ICsxODE2LDE3IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9leGl0
X2Nsa19zY2FsaW5nKHN0cnVjdA0KPiB1ZnNfaGJhICpoYmEpDQo+ID4gICBzdGF0aWMgdm9pZCB1
ZnNoY2RfdW5nYXRlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiA+ICAgew0KPiA+
ICAgICAgIGludCByZXQ7DQo+ID4gLSAgICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiAgICAg
ICBzdHJ1Y3QgdWZzX2hiYSAqaGJhID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCB1ZnNfaGJh
LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBjbGtfZ2F0aW5nLnVuZ2F0ZV93b3JrKTsNCj4g
Pg0KPiA+ICAgICAgIGNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmaGJhLT5jbGtfZ2F0aW5nLmdh
dGVfd29yayk7DQo+ID4NCj4gPiAtICAgICBzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhv
c3RfbG9jaywgZmxhZ3MpOw0KPiA+IC0gICAgIGlmIChoYmEtPmNsa19nYXRpbmcuc3RhdGUgPT0g
Q0xLU19PTikgew0KPiA+IC0gICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEt
Pmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+IC0gICAgICAgICAgICAgcmV0dXJuOw0KPiA+
ICsgICAgIHNjb3BlZF9ndWFyZChzcGlubG9ja19pcnFzYXZlLCAmaGJhLT5jbGtfZ2F0aW5nLmxv
Y2spDQo+ID4gKyAgICAgew0KPiA+ICsgICAgICAgICAgICAgaWYgKGhiYS0+Y2xrX2dhdGluZy5z
dGF0ZSA9PSBDTEtTX09OKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4g
ICAgICAgfQ0KPiANCj4gSGVyZSBhbmQgZWxzZXdoZXJlLCBwbGVhc2UgbW92ZSAieyIgdG8gdGhl
IGVuZCBvZiB0aGUgInNjb3BlZF9ndWFyZCgpIg0KPiBsaW5lIHNpbmNlIHRoYXQgaXMgdGhlIHN0
eWxlIHVzZWQgaW4gYWxsIG90aGVyIExpbnV4IGtlcm5lbCBjb2RlIChJIGtub3cgdGhhdA0KPiBj
bGFuZy1mb3JtYXQgZ2V0cyB0aGlzIHdyb25nKS4NClllYWggLSBJIHdhcyBydW5uaW5nIGNsYW5n
LWZvcm1hdC4NCkRvbmUuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gPiAgIC8qIGhvc3QgbG9j
ayBtdXN0IGJlIGhlbGQgYmVmb3JlIGNhbGxpbmcgdGhpcyB2YXJpYW50ICovDQo+IA0KPiBQbGVh
c2UgcmVtb3ZlIHRoaXMgY29tbWVudCBzaW5jZSB5b3VyIHBhdGNoIG1ha2VzIGl0IGluY29ycmVj
dCBhbmQgcmVwbGFjZQ0KPiBpdCB3aXRoIGEgbG9ja2RlcF9hc3NlcnRfaGVsZCgpIGNhbGwuDQpE
b25lLg0KDQo+IA0KPiA+ICsgICAgIHNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9s
b2NrLCBmbGFncyk7DQo+ID4gKyAgICAgaWYgKHVmc2hjZF9oYXNfcGVuZGluZ190YXNrcyhoYmEp
IHx8DQo+ID4gKyAgICAgICAgIGhiYS0+dWZzaGNkX3N0YXRlICE9IFVGU0hDRF9TVEFURV9PUEVS
QVRJT05BTCkgew0KPiA+ICsgICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEt
Pmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuOw0KPiA+
ICsgICAgIH0NCj4gPiArICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9z
dF9sb2NrLCBmbGFncyk7DQo+IA0KPiBXaHkgZXhwbGljaXQgbG9jay91bmxvY2sgY2FsbHMgaW5z
dGVhZCBvZiB1c2luZyBzY29wZWRfZ3VhcmQoKT8NClNob3VsZCBJIGFwcGx5IHRob3NlIHRvIGhv
c3RfbG9jayBhcyB3ZWxsPw0KSSBmaW5kIGl0IGEgYml0IGNvbmZ1c2luZyBiZWNhdXNlIGluIHRo
aXMgY2hhbmdlIHVzaW5nIGd1YXJkIGV0IGFsLiBpcyBsaW1pdGVkIHRvIHRoZSBuZXcgbG9ja3Mg
b25seS4gDQoNCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oIGIvaW5j
bHVkZS91ZnMvdWZzaGNkLmggaW5kZXgNCj4gPiBkN2FjYTllNjE2ODQuLjhmOTk5N2IwZGJmOSAx
MDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiA+ICsrKyBiL2luY2x1ZGUv
dWZzL3Vmc2hjZC5oDQo+ID4gQEAgLTQwMyw2ICs0MDMsOCBAQCBlbnVtIGNsa19nYXRpbmdfc3Rh
dGUgew0KPiA+ICAgICogZGVsYXlfbXMNCj4gPiAgICAqIEB1bmdhdGVfd29yazogd29ya2VyIHRv
IHR1cm4gb24gY2xvY2tzIHRoYXQgd2lsbCBiZSB1c2VkIGluIGNhc2Ugb2YNCj4gPiAgICAqIGlu
dGVycnVwdCBjb250ZXh0DQo+ID4gKyAqIEBjbGtfZ2F0aW5nX3dvcmtxOiB3b3JrcXVldWUgZm9y
IGNsb2NrIGdhdGluZyB3b3JrLg0KPiA+ICsgKiBAbG9jazogc2VyaWFsaXplIGFjY2VzcyB0byBz
b21lIHN0cnVjdCB1ZnNfY2xrX2dhdGluZyBtZW1iZXJzDQo+IA0KPiBQbGVhc2UgZG9jdW1lbnQg
dGhhdCBAbG9jayBpcyB0aGUgb3V0ZXIgbG9jayByZWxhdGl2ZSB0byB0aGUgaG9zdCBsb2NrLg0K
Tm90IHN1cmUgd2hhdCB5b3UgbWVhbj8NCmhvc3RfbG9jayBpcyBuZXN0ZWQgaW4gb25lIHBsYWNl
IG9ubHksIHNob3VsZCB0aGlzIGdvZXMgdG8gdGhlIEBsb2NrIGRvY3VtZW50YXRpb24/DQoNClRo
YW5rcywNCkF2cmkNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
