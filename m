Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FFB19ABD8;
	Thu, 10 Oct 2024 06:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728540658; cv=fail; b=hhgtJM4TVRjbpnHwyCZfwZG70hnO+7Ncjq4vT5SdZfLLhNv8yVH0/JXwEpRYe9PvXlUfvS+M1fj9ENwq6+oIkrLBTVWk8EKwt1Sz6wZM/vXWbPy1+q2zVTBvT4e3bAENhlL4rCXZyBBkggDH0t9ujEgO9GQAAnbQeiwCgyuH+1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728540658; c=relaxed/simple;
	bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RDtjzNgZUczKrHbpwR2GR3qRPJR07LRvwjIwTDRB/o5C/bZnALBUz9CUuen6lfGFcybsUIZ386AGY7pglNNuBhKzdMI4/+Vbr2oD4i9OXZ6IOo2lib203X9pWAquFVWhS7gMQEJMezdfy1uQQxnaCnjW+fRgLJJwc3qnm8VTBTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dFmmcCxz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=v2t5/XKf; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dFmmcCxz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="v2t5/XKf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728540656; x=1760076656;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
  b=dFmmcCxzW1LrQwoqIB2fpXRnNUo2f74YGSbVvONfLofbHg8AaeWDGTTt
   flWB0WB+pd/Od1v2KPIbs5VvuLg+1REegzS+mfWhmzB8kXktme6GIZs7m
   hAHEAbaZz1rmVIuG031M9HTjIP8WKtoUCCo61RBAeHlTc+uHzzK2idjo/
   Y3KrT+57JzP2YeB6ivcWobclW6uogKoLBFSU0gvuvv1Hb7NO4HXqqUyoH
   leBPhT/g8aAMLS4cjQCg1ewcSaHEaAuLsSEYO7kXU2ZjPwQKgwFPlusPN
   rRKEezvDVSpl6/cJz3nSGy4urRHumls9u4z+1kcjFLw5sPT9+M5qnxdee
   g==;
X-CSE-ConnectionGUID: 95idTZl7RFWNhQbOhQ1rSg==
X-CSE-MsgGUID: AqBWDbTRTaymbzXsDkh7HQ==
X-IronPort-AV: E=Sophos;i="6.11,192,1725292800"; 
   d="scan'208";a="28043970"
Received: from mail-northcentralusazlp17012055.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.93.20.55])
  by ob1.hgst.iphmx.com with ESMTP; 10 Oct 2024 14:10:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YjmD+uwAN0NhwQNAIR+5e+xc2OZPkmkQhacMgKi/BrE7tYpQyRyrAC822qsEbCxFdwPptL/zrDjpKo7sEFGQkV7UGl2g9IVh4IC3F7x4JDJ8UYV1j6mRBbWl51EXbUPB96HVFMSBWS+CbSqxL8nXBuJSXO+ZQ50Oeuzn+PDtoANQW6vRt/OQ9FjgYR5+y1Gkp1zGnBMIFLjrB2SRRF+0SKAOkSIQsknbYOhPkIUc109LSDrsVVcSAcQd4a5P6xC7xK2OwE77uNKFiM8tUxedak6UFSfc2Q3L+sykKvEqSA39fSBBnPa1usM/8NP5FR8b1RspAdGKk6K+3UJ06vbJ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
 b=WKyexnLn6/mlFxAzAYDGhVHB4OUnPdizx2i3ThQfr5oic25dKAN+7Iq80ornLw2FW3NJzKlTIvxkAwWD1xAPeAkqTyU7M2kpIspoQyezywGt2XZaqk1NlubokPNI8pbGvFwBS7nCfJ0SUrudFSSA0RPvCeAMNUOH0neO1etg4+NEcuoDDizufxd9Lxn3Is34suDVkVAY357Ji9RPM+iASWCF6T520B7OCJA/L6eSWdxpFc0s5wUYXUwr7XtP8I4MU4hyN0IK3B43b0PFw4vqp4ZvDjMpj4YFWdy3g4n4j1EyLoOdhwV6GJXjQVjftVIAwJRSwfDVoajF11eT6q4kLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
 b=v2t5/XKfN0Kf4blQv+UA+DamN+xuxNB3gC6KHIcdPOwJPbqdAFfwaGZB5JL+Qj7z1JGnyQSNfQNDIQvsHF1UvMATHQdQ5XF6N7+e3hzBuPT0LRpiA8O6ockEGdd6384W7FR8e0FFoULyYGhp56If4nsk9Om7RhMvJDt/G4sLG6k=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB8516.namprd04.prod.outlook.com (2603:10b6:a03:4e5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 10 Oct
 2024 06:10:46 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 06:10:46 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, Satish Kharat
	<satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak
 Kumar <kartilak@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] scsi: fnic: Use vcalloc() instead of vmalloc() and
 memset(0)
Thread-Topic: [PATCH v3] scsi: fnic: Use vcalloc() instead of vmalloc() and
 memset(0)
Thread-Index: AQHbGXQxSko0cI//eUmLapQpuIvUarJ/g2CA
Date: Thu, 10 Oct 2024 06:10:46 +0000
Message-ID: <670492a1-6318-4f8f-b354-836005e668de@wdc.com>
References: <20241008111928.49004-2-thorsten.blum@linux.dev>
In-Reply-To: <20241008111928.49004-2-thorsten.blum@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB8516:EE_
x-ms-office365-filtering-correlation-id: 30acc210-28fd-4286-8f63-08dce8f247c7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Mjl2aWttY2tZMFpkVlptakxkR1gxLzBhWjFKTXYwL2JoZ3UrYnloYU45UTZi?=
 =?utf-8?B?UDZ4cDE5UTh4QkR4ZXl4K0dFVGdRMEhzTWVKMFRRUEM0OW8wMHpaN1BwUnpY?=
 =?utf-8?B?Mll4ZW1tUWRzL29Dem5PQjAyc0lqbWpHNUxKS00xSzYwbTBOZ3ExTlk2TjBK?=
 =?utf-8?B?ak1nY2ZDY1BFWjhLTnZVdU80ZGhjd2YvbzZRSWlieEhUaDJyUFQrR0xIWFEy?=
 =?utf-8?B?NWs2TDludGd0emxoSTRNRHhBanA0NEFxWnZ5RXpaQUJKWkFEQTRVaVBlNHJy?=
 =?utf-8?B?S3dWT1p3NUNLSzB0Z0NxVFd4R2dLOUtpVUtXb3UwWjdpS3dIZ2ZLVllpa1Ns?=
 =?utf-8?B?dkowYlBlSDVSTEZ3V3B4cGNGK2dMNEFNTGVDVHJQK3BETThsN1hYNDQ3MFhH?=
 =?utf-8?B?N2NldHZPV0w0dkliL3RmSDI0RFgzRTloMFlqT293R2VEeG9TSzlEOGVvMkZN?=
 =?utf-8?B?WnpuRnZhRU5XaDVJMnhKc21BVVlSZGtlMUZsTWRGRDM0MFk1R2FJOTJHU3ZH?=
 =?utf-8?B?c2h1VXJrWmprQmJmOG5qWVdSOXY3RGNpd2lBM2FWZi9EQXZrOUtoQWtYaWdZ?=
 =?utf-8?B?SERLUm5pUGxvL3hEODhzNjFxRWVIRFVKZ3UzbEpBMUNxSUp1bG9Ea2tiTEQ4?=
 =?utf-8?B?ZkxyWm0wVmhYZWlPaW16UEJSNmhabUE2WWhUZEsrcXRWTHcxTXpLdHN5N3lO?=
 =?utf-8?B?NUQyNXExWnkrMmgzNStUSHNWQ3d3aWZvc0d0OC92OGp3VWJXSnVrdldQbjVt?=
 =?utf-8?B?OHhoQzRqcWs5Z2RKQzR6WE5pdXI0eTBFTVB5d1B5ckV2NURUKy9heStiSm1O?=
 =?utf-8?B?S2pkMVNCR0E0aXF3YVZiNDROUEVOczJkb04xOHBhN0ZSdVJaS05PY01LZVNU?=
 =?utf-8?B?WDBNQTQ0RXUzVjJrY1AxckZYdHBvS0RURUlpTGVqTENzM0tSVEZCTitaTkFh?=
 =?utf-8?B?b0Rtc2JId29lVlBWcWp1MnJ6bnhLUk1mNXBxRWplOE91QTJCUkhWR094ZTlj?=
 =?utf-8?B?Vk1ZUC8vYkdBczU3NEtzTE40NEZJL2pQeTNZa3RmYVpCNlBLd0VlTXgwSnNh?=
 =?utf-8?B?NUJ6NXFvVHkxK1JEUG1MdGZFczFld1VmRHVhWjFsdThGM3pOWkQxMDVFcWpF?=
 =?utf-8?B?Wmc3dHlGbU9scmlwaDd4UUdhalZuWW1nbUFLbWFqdkxaWG5nTVlyNWVLWjJX?=
 =?utf-8?B?dDZBV1NkSFQ4Qms1UXBuVVFrTzgvbkJIWnUwN2pYa3htWHJOb0t1UHI0bTMz?=
 =?utf-8?B?ckNTQ2dXZUlueDJDL1lTYmZFb3JoR3RxOGVPTWZJa1VuVi9RemtTdWZZbEI2?=
 =?utf-8?B?by81ekNvTXRrK2tRUkVrMnh4eGJGdHBRbFp5WGVWZHhXWWIwQ2E3VkhMdGsw?=
 =?utf-8?B?UkNOS0kyUzl6OGdBSHh0SGt0TElJazVITmhXYnRSa2NCZ2pOeTFnSEpzeEor?=
 =?utf-8?B?TlBpL1FqR3FKbmg3Q05HUWZjSVArWTNiVjFYOEpJZkpjZEd5QmNlM0N5UEor?=
 =?utf-8?B?RmorQVFCYUo0d3I5Vml2WkdsY2p2Vk5yd3pMaTB2YUI1L2NVMHIrZm1nenRu?=
 =?utf-8?B?WlNJRjlaY016VlVsejhoOFFlMGhZc2RoZHdZVlVVMC9JWjFqRnVJT2ZXNUox?=
 =?utf-8?B?UGh2VTBzeXVFb0RLQnVPT1VUcWFWNnBxVU1MOUlub2NGSEdORHF0WDIrRjcx?=
 =?utf-8?B?RFQycWtiM21rUlVKRkw3NE9YMWlhVnJwUEQwdTZVcEFmWG9IdlhpaXd6UWVL?=
 =?utf-8?B?cWpwcHFBUkVwSEo4d1JQcWw4ZDB4aWR3YU81T3B5RXFoTytDTHhEOVh1TFV0?=
 =?utf-8?B?VmZDaHQyakUvZVU0S21Xdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eTV1RTUwS3V6bDlaeWJucDZIM3R5K05UY1l5djJRZjZRemVhb29ZWGpzdnpH?=
 =?utf-8?B?TzB4TGxZVUtpeGU2MDBzUDVuU0VFcmxVemZwK3o4eEFOYm5qcjVDQ2pKM2V3?=
 =?utf-8?B?TGQyTVNtOThxRm91djVoMGQ2dkZTa3V5Ykg5R0ZIYU9nSXNYT0F0dXZJTzBD?=
 =?utf-8?B?NGpQSVd5Mm9lZHphakJVd0I4a3d2ekRoaG5XVjcyZWNLbEQ0RDVUUU54WVIy?=
 =?utf-8?B?MUlISGlMNlJJSWZQV0gwcVd4V3ZhdHFiT1FyN3lOYzNPQkNXbW9nUHkyUEFk?=
 =?utf-8?B?MUhqNEFRVU9sWmpGOVBrMHp1eE9maHo4Zlk1a3A0YjhWZkViaGFWcmI0dU0z?=
 =?utf-8?B?VENKQk85UnJhMjJ2NVdLU0dDa21nanlhMFZ1SXNDbGM4dkM2K3RPRXFiU0JW?=
 =?utf-8?B?a3RWbmYzM1BsOEs2WGtVbDRpSXd0akNWSStETElTcXVGaUVWalZkak9wZU1r?=
 =?utf-8?B?bEhNQzNIcDQwTW90QWZocWQxeGJFcXRqbklnS1RrMWJUdGZBL2RLK0RrdkJh?=
 =?utf-8?B?eThsRVJtVG5QZ3BucGJ5bzBqY01VOEptV2xrSTVsYVZIRkFpeldjVklFZTdI?=
 =?utf-8?B?MDJpRHMrVkQ0VGRiSjhMdWJCbEl3ekViaWpWNEtRdm9hdXVLQ1ZNeGxYOTB5?=
 =?utf-8?B?V2ZpQk04NTU3M0Qya3I0MmNONnhORTR5M3JZb1Z0d3VxWG5OeGhJejR3Y3ZJ?=
 =?utf-8?B?akhZUmpaQUdYYkYrdFlyZFZnWjlHYXZxZ2ZkWlkvL1dPcnNROE9nQm9raHQw?=
 =?utf-8?B?eDFOaUI4RjJQVld3aXRLOHJ0MU8zc2NqV3FjMWJrUXYxZ3pzaGlQU1JBb1lx?=
 =?utf-8?B?T3ZYbnk0Z0FwNFJBS0YvVHRRbnczUk9MNDBDbUJOeWdDRUd3aHlhN1R5dk9N?=
 =?utf-8?B?TVNGQk9odzdQMEpxSlRRRjZzbHZnWkRpQjNuY3huQlRBTnVrejNIaXB4ckhM?=
 =?utf-8?B?MUFVQ1dkRWI5ZlBab3BlaE9Qdmh4eEd5N215dDhxZ3BiaVphWXcrVjZHUHdk?=
 =?utf-8?B?S3hDRm5HTUhCclFmOWFMZmZBYjYvRlJKaFJkY2YzUzV4cThrRWdTeVlCZUZZ?=
 =?utf-8?B?dCtaanlxZzMxT0hEdjhJYnBHMlRWaTFMVktoNXB6SVNNK2hhL1Y3c1JwKzVi?=
 =?utf-8?B?SU8vcHA4b29oL1lnNnVNVzM4ZWVuN2l1a2hLeG1YQjNxTllkMUtoc2RDYlBF?=
 =?utf-8?B?aHFwZ2tJRDBvVVVENjVyNm1VUGlyVmZ2ZnhFN1NNVFVCQXFTMURIaHYyNlhr?=
 =?utf-8?B?VmpwT1NjWXdyaUFHMkpUdnpBUkhhTnI3enR6Yzhubk9UWkpDTWhqNjN6MlVr?=
 =?utf-8?B?Y1EwRUZXWFFKTVNnK3ZrMWZDTGNTTFFpYWh1dVBHeTJXc25rT2M0Q0lDUkJS?=
 =?utf-8?B?YVJrWGQ5K2lNNERGM1BSdWxTR2tuOWRDRjFJVWFpOEtXMjFaTGdDUTEydXNG?=
 =?utf-8?B?bDM0ZmZ2V2x5Vzd4R3VQQjllL3FrQ1NqcHRjeGFub0JWSVRjRDZRL2p5Q3F2?=
 =?utf-8?B?ZDQ5OUJSM3kzSjYvakR1ZWFrR1MzcVN1bFVPTnNLd1RGemNjdDBmTFdPdW5x?=
 =?utf-8?B?LyswOFZUZmtNSzFPM1JjVVA2dlRmZTM5TDRsY1JmWmZCOEhBMnlFUVE1amlv?=
 =?utf-8?B?VXhWb0xOZTNLVVVHWHBQVFlPaGp6Si91NFQ0eTdEd3B3NzFmNjJvTzlNNHJn?=
 =?utf-8?B?RHVxVGc2SitmQ0I5S1l2K1oyMEQ4WURiZDBjbENqay82em1pS0NYZmZMZk56?=
 =?utf-8?B?QmRQaWdDWCsvaUUxbDMxZU9ZbjRybEZENXJNV080cUhtMzd4OUhvcVJaNE9s?=
 =?utf-8?B?SGlac1hJU1UwTnZRM1BZZzVoY0FSZkFUUm1aRzNFOG1ERmFoS2RnSU1wbW0r?=
 =?utf-8?B?eWVRZXZ0NTdJTE02ekNsV2c4cEdjc0RDZVZmNk5ZUklmUExqdjRPcERTclhw?=
 =?utf-8?B?a3RZUFl3ODQ4dVNGV21mcndFTHVTRk4rNzA2YlFFUWRCWmk1NDQ1ZzJNY3Z1?=
 =?utf-8?B?dTNHTmozdXBQOTJWZTFHTDVVOTZRVk81NmdZMkxlY002cFA4WXhYVG0rT2Fj?=
 =?utf-8?B?WTJZR1F5UmZpaGE5NXZUVUd6eGlkOGdFQ1FBcVRJSFhURzZaeHN4T3U4d1lM?=
 =?utf-8?B?WmY4OE9HOWFXZ0pzamovTU1jRUp4N2hNWm5UUG82dlB6UUN6VXBOTk5GMGFJ?=
 =?utf-8?B?VXJwcWtGbWtIVmVETGUwOWN2d2twT3QxY1NmZUhjSFlKa2szTmpyK29hRTFV?=
 =?utf-8?B?WERRTnhqelMvSEw2YkJCOHp3Y053PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05F12396662F1648B8F2B58FA950CBAA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5D7/KwEyNwd816nbdrdpp3WUt4Y2IG3xzTbmAwOUUTkH09FZ8fVat2O7If3/6PKUsSkYT5iRlSrWZnm8yzPvBF0t3tAGxl6bXW/darOy/9hK32ey3CGzS6m8SCyLjnceMiorfWkKN1/lOlpw/nDDXcYsHKS8ATqJ+p4oGFbhq8JQSFJzweKEYBaMfoG0/jb0h25yM061gqiOHqhvSFn4TkTb6GXquEltfkT0LEQ/Qkqg7NsDE2l31i9wKfjIaqUvW1HgpZeIwtIvn6/OQweAqxhICqbvWJkicVYzvdxh0V/cqqD+sd5AANv0De0geO55z60Y0ExI/YkwAh3F31VJKXR0c9mnaeYrqHJNNXAzgcqLBiIul0aQjwCsDotCHy9cidaGT/j35vQlCSwmsT17vD1RqQ/82T76krPMUfPFCIF63hwD2a7q59mQG/evkQGEnGywOZO791Ia7KWhaAKoiKuc5lOWpSRI9bKaRenPpxtonWAnOCjtnweyx5WY3B6lKtS08+bcpD/YC/GS+CtQoTntechd+IpLhb87c7drybxiBw4urwOYGd4cgDeTmLcxP2/CfDyMthyTmhmruXIIeRAcKrDzh0/RLyZWXMtW5LcfEm/QHqieMbk2bRQNuL/e
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30acc210-28fd-4286-8f63-08dce8f247c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2024 06:10:46.3297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s95LeO+sfQKdtAsdcHb1hIEfIUQuh+0m+KghrETrZxRneM0xJh0oSQ4K6afZlWZy1XxRTH0YwpLvkQZYo/6ppMyd76cv0QEAWHUkD4U8eJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8516

TG9va3MgZ29vZCB0byBtZSwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFu
bmVzLnRodW1zaGlybkB3ZGMuY29tPg0K
