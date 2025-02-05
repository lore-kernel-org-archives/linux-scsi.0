Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7001FC0F4;
	Wed,  5 Feb 2025 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778672; cv=fail; b=nv8wf5ZcVKzYk3NbcoviwONeDWQeONpCEiPJ7mKylhqzZlR76eAsfAOPQf1I5PHvirKg7HIDTkncKOwh29f637H0vgBP94YZvTT85jeVhaQRefJzL44f2MTDhn2ZDcGp5ccLKQzTMq8NRjCZEaYCQfOukK1R7f6JYfdM92T9g6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778672; c=relaxed/simple;
	bh=yHxYQXs3kZ2DGD/zb38bwuvWsYbRiNMWnDdb2naDYeo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NHiNesBCWwTRPWwddMcaI/BrYglKesogi9NsCXdl1ztY1rZrvbwfPxs3B3M1i0hk4cV+XUYK3u9DxdT4scM+pHNs5hZ7fr6V/TIIwL0/PK+aYaJYGt6wZSazB+CjgDR81CtM0IpgI9NbtY6C6uyde5QX9dqVgcPxjytJMroZams=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MNADr0LO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=uPjIBBS/; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MNADr0LO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uPjIBBS/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738778670; x=1770314670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yHxYQXs3kZ2DGD/zb38bwuvWsYbRiNMWnDdb2naDYeo=;
  b=MNADr0LOCuV7m606+bNHur3v2HUlKave7hFF2kV3HKI2SwYYZcLDFnyj
   X2cqftMYUO/kQGFi9vRg4otM1faSpr7nyK1huGEt3+/b9lQPGaDoPTRSX
   a6Xt4bLDtWC6UdWzj6ecAxyEZP04m1Sd/lvIxQ2Gk0lDPWYboTHT8MqbC
   z0HmlxaRvBgAzvzjJJRCbtAmFl9nHy8lctJN7zhuxYfB3KwkG1Qb23U72
   wHf/Mtc7VUTSJEz+TjzkH3Lqm0m4Xnt1XgUgGR+CjXOUMMt6MUGpVrdsf
   k/Sh7vp/XoJffXXy1/Wm0ZUoMzlTDfUZi3kUJhBajlCzLD3yl8vzi4yls
   A==;
X-CSE-ConnectionGUID: PgLCOomCSU6wTZxpkZ0cOg==
X-CSE-MsgGUID: UbBx+GmFRd+x4476pdULyw==
X-IronPort-AV: E=Sophos;i="6.13,262,1732550400"; 
   d="scan'208";a="37085144"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2025 02:04:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rFS9wHcTtw7QVj5PO1+WSp4eFRxcG0M60/OJiJC0FZqzMKFa2Q0ICb7u91o0DeVWxOjZs97OqKuMBvFj7674ifeejfHCqu1cwwLq/wu+VInBUXFFY3tvaQ+9CyDKVY5VV9VDWO+Y9Tu/6M2DCABjUDPAWAqSS6vyqBKvcOT2tl0WjQxGeToN4FUD9qxJY6M1XmlsecrtJkmEmJqMULN0XasWweSEHCLC6+IRSsKxRZlImsXbNGor8XmMzdmbMcJwnTa8QoNDCJCJKChNuCcYbj13R4RqvJp+xGaOshcBWJR8j8Vj/OXB2FpwKNGxPbAgBJ67b5W3oDf5K8PuBDEEJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHxYQXs3kZ2DGD/zb38bwuvWsYbRiNMWnDdb2naDYeo=;
 b=jpxuHuRAdj5jCRIsxfaiE4DvdHx9InVyG+OKcYrO8QyR7NYXKDtJGUUrBQH1oNkAsAsnjRV+amfwUVZqCw1HI0FLMso7xEBrP00H0iH2R/YIptIJTCou134FVYQGQrSshnEoohXHCjw6SnVxZ8N936LbxQ2akHPd48JBWYNQ44+0d6xq9yJohoIVp0NSgGf0r45t5KZDUrcQLGTqfTjco5qIABkrgcIMKXkB2x8LpjxSpXfZefOZ+870BpNXvEtlE4aeX42dz+TyaWIHSQ0kw+ml1qQ1mY4Ufy/jbkg2CIEx7dbEiftEj2MT9ytLXQE9LvX4sgM2HyWbaIEsHL++Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHxYQXs3kZ2DGD/zb38bwuvWsYbRiNMWnDdb2naDYeo=;
 b=uPjIBBS/cn9UpzMteEd9bLBmJe6jBwCyURxtJX1BRTuuwa2VqBlK0mxjambP3nvcAerFkVWCyiMvFFQ+w5how9cYt6+e+wJwvN2ht6k/ZvDaRKzy8rAOVdRrWErCIYgtRLGpswPgqVaB7GSpmgOKfRvvW8ZqFL4D/BPGRw/gImQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7293.namprd04.prod.outlook.com (2603:10b6:a03:29a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Wed, 5 Feb
 2025 18:04:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.8398.027; Wed, 5 Feb 2025
 18:04:22 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: critical health condition
Thread-Topic: [PATCH v2] scsi: ufs: critical health condition
Thread-Index: AQHbdxHmvf69B4w9AEaXxutfZEUuCLM5AagAgAAAmeA=
Date: Wed, 5 Feb 2025 18:04:22 +0000
Message-ID:
 <DM6PR04MB6575482D4C10F31D633E95F3FCF72@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250204143124.1252912-1-avri.altman@wdc.com>
 <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
In-Reply-To: <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB7293:EE_
x-ms-office365-filtering-correlation-id: d992c9a1-7f4a-466e-5c14-08dd460f84b9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RnBNSDJTcTZqYUpLRlpVRzg5c1BTUmgzNnNvNVk5ZnpIRDZ5VWlKa2MzSnB6?=
 =?utf-8?B?MzUwdnl4MUkvQnMwMTh1d044b3FqK0Z0TVVqMXdBZ1cwMENOQWVPaVpKNUYz?=
 =?utf-8?B?aGZnUmpNWW5KcTcvT0hyS2ZmZFhOSko3TnhOUEZ0QUVCM2F3OGNMSkFoS0x5?=
 =?utf-8?B?QksxSThUdWxDa1VCVS9WcytZK0R3NVQ1eStpK2k0V0JJVmlJaHZ3T1gySmJP?=
 =?utf-8?B?d2ROWEp2c0tNdjVOb0w2TmR5OHcrcVdPYTJaTjlqOFlqL24wdGhKN0laWEtD?=
 =?utf-8?B?RWVYeHk1QmI3KzJmNDVYcmZpMU41aW5yUWRNZDhsL2lQdVpsWEZCMVA0VExW?=
 =?utf-8?B?ejhsR0VGUWRnZ0picEo4VngvUk9Pam1sbDZuRGZWZFhKb3B4OFpjMUVtczV6?=
 =?utf-8?B?cG9RMmExZnBDZCtyaGFvcVh2bDBHNzUwKzgyNkFYYzNoQnh3eDgrY3NlNERN?=
 =?utf-8?B?Rzhpbk9Ya3JJb2Y3bVExUVpNZlJsNmI2K25zVlRaMWRIVHJSU0F1VGRXQUJ5?=
 =?utf-8?B?ZGVUbUVzU1ppSkVXVVdTQUdSSmVDRlp2aUJYVUlEQ3UyakFEMjFISWlidVFB?=
 =?utf-8?B?ZVkweGMwNFN4bGs0R3JkbGJJSHk2TGhOQnFUMmNYS2hjSVlCQ2lSVXRhNlcr?=
 =?utf-8?B?azJjV2hDUWIvVzZaWlJOaVU5SGs1RVFMRHFTOFBQR1k5VTdzQzJPbS9sSHlp?=
 =?utf-8?B?WkIzaEMrcmJNaStCTHlPTHpoVWVuK0pscXovelBnV0lPcVg5cXQ0NEFkTC9I?=
 =?utf-8?B?SmF1dW85R01FejF4Tm5kVXNDRXVvekxEM2RPUjFMa3hoTHZKcjdEbmR3c3RD?=
 =?utf-8?B?QlZqUkxsSjhoTjJ2MXRtM3FIS05hRmgrcENSZW5GUzBsekhJM2QvOFpIcDJj?=
 =?utf-8?B?VE5ER1Yxc2ZLK0JvSWFoTGs3bjVkbnhYWU5yTUk0Z2lsUDk0QkFEMkFaV0ti?=
 =?utf-8?B?MGhJS1IyZ3RqQ3VXZDB5bEVNS0k5OFpqRGJDRmZYM0ZYSWxQVllNcGdDZGNJ?=
 =?utf-8?B?bGRKdzJBSEh6QUJYS1hNZWVROXBCa05DRHpqdGVMZU80ZTgxOHJkcTBGZENp?=
 =?utf-8?B?cGZYZVBNNHc0R0JTc2ozeHVYWnltN2ZvV2NocFZ1RzdRT21ZLytIT2wrU0ZI?=
 =?utf-8?B?dzcxUHFPdURSNEx5Q0JRRWx3a0NoLzdkRHJVVzQ0TkRKeHhOamhrK3RtZXVk?=
 =?utf-8?B?RENsb3MrU0swK1JDM1VzSEdYK1QzTlErVFZ6aFZlZ3g2YW5QNWpZei8zSGRn?=
 =?utf-8?B?eUNpS0k4NWN4aXVnSGNGT2FvNjdLM3A4TXpLNENraXhUVmRlS0ZsS3VVenBY?=
 =?utf-8?B?YkRBekgzNU43eFZ1T0VKSEovM3BaL3RqSTFHcmphVlVSdXJNV0tBRVBLQVJr?=
 =?utf-8?B?dEVpejRuUkkwT0pWY3h4SUlXN2VEaE1xL2FqeVNBMnRmclFtSUpic3Z3SnpH?=
 =?utf-8?B?VHNrc3lDL0w3OHZNMWtWYzlsU1FqUE52M2lBdjJGc0ZDOTJqenM5cmZvaDFq?=
 =?utf-8?B?ZENkVDJyRFFzL0pZQmRZVXFlRnJHK1VHOGRwZEdZOEZibUF0eVJUcVlKbnRT?=
 =?utf-8?B?L2k2NUY0bTNaVXFvZVZIcDlMdGorMEl4OWFVQzFqS01GSE1SV0hrMVZqRmU3?=
 =?utf-8?B?SkR4QWtoRWpZOFdWT3NVQ1FLdkRlWUlTRk5EdXk0M3YrbnZVVnpaaVJqY2JQ?=
 =?utf-8?B?UEgvRndqdmZqd0haN1FGK2phdHRZc01vcVZCZGdmb1hOQ0ZWY3lVNTUvYVhk?=
 =?utf-8?B?eThWNzZ2aU43MlRodjVYVHBHR1ZCYTdkdzd3UXNQbkF0S0pqdlk1eFJWaFk4?=
 =?utf-8?B?am8yekpLMEdvaFRWWDRIWk1nQzlmU214WmlOcFFFTE12VFpidjFweVh3dmVX?=
 =?utf-8?B?b1dFcmkwMUNFY1ZRSldBdTNoemZ4Y0paR0ZLSmt3Z3p4SzRIWGhmUUowTi9z?=
 =?utf-8?Q?q1qWlMUZ1j0qv0FuA+jg435PUANl8/D0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MmhvUTViWWd2R2RPelRqdWJTb1RHTzJBWWxCSHQ4RC9XeUxQek0xVWFwdlEz?=
 =?utf-8?B?bi92VnAvZ0duUGgxdnJkcDhDZ1BNL0ljeDhNeFp2VXY4NXV5VVcrU0I3WXlq?=
 =?utf-8?B?VElvbkMwN3oxaVl4eVVCZ0xaQ0xCaDVMRjlJSWpibHZHOFJJUXRXV0JhYk5I?=
 =?utf-8?B?RzBPRkVPc1pMZmRHQ1daWnh1K2lmZ1dHSVdJRDNVYTc5aXVsL01JZ3Frcko0?=
 =?utf-8?B?ZGR4ditRbVFKSG1GTmMrRFZ1NzdZRXdhcUx0YU1UU3o0QzdnYzFBYzZlemgz?=
 =?utf-8?B?d04vL2hGdWNHSnNOTHhPQXRndTk4YjQzUXM3SVNkTDFyMTJRNC9qaitvSE45?=
 =?utf-8?B?cEZTUFVUNFVvQ01DNjdJQ3g1QUloRW1vd3YrejNMTTdWQWFwSUMvSTR1dlIw?=
 =?utf-8?B?b2N6b3dpVGJrUkMxN1hLeTVYSnA3WHh5alhISFpOT3BaTk96OElIUURaUVlx?=
 =?utf-8?B?RXRBaSs1blBEbnlhSkJXNndtWU4zRlQwOGpBMzd6NDFZUHlJbmpUdVhjeVVO?=
 =?utf-8?B?SW45YkFHZm9tejlGUko0SnYwYm9ZRzYreDJqU29PNzNYK2ljOFNPVWNOa0N3?=
 =?utf-8?B?TXRyekZYcGJEUmNsb0w1MkVtRTY4Q2tXMklYN3A3NlB6eE82SFhua0V6RnEx?=
 =?utf-8?B?MGVsdm1oR2U5UGJJVGZRbDMwRWxEeFVHdCtpSXJlTHMranE0cDlXMUhwUlBi?=
 =?utf-8?B?Z1JzblhndWs2MGdOVHBUQUpST1p6bVlUL1BNUnprWitDaUdQY3M4TDQ2WnJx?=
 =?utf-8?B?MEVOS25PK2RaVUlKeTBnbGtKcEN1czc5YzNXaks0bmpOWU1XQW13UFZHSGR4?=
 =?utf-8?B?K2xYSFNqODVWMXhTVEJFN1JDcXVKTEZWcEhFN1dMZFlHbXNBbkI2SklpUm5K?=
 =?utf-8?B?UjA0MndqWnR3bWRNaVRUdTdhRWFVMVgwWmxza1RlcHpxcW5kQ25GVmIvZlIy?=
 =?utf-8?B?eHh0c1hSN2lTbllvNDlock9MdGJBTDU3N2ptMkNvdm5jYi9RQUppVitOTDcx?=
 =?utf-8?B?MmMrV2hzemx2S0RlQ1JuM2dZWng4MEtXNTdwa0swelovWmhtUWMzekJ2bnRD?=
 =?utf-8?B?VlI5R1lSZWZnTFF5b1BEZ2dKSzhvUzBCSlV1eUc2cEswNEFLbUZ2T0hJYzNH?=
 =?utf-8?B?bml5c0hCby82K0Q3dnlKTjdMOSsrREU5K3Z5VEFRdXhZZE9hbHgvclZtTkNC?=
 =?utf-8?B?cFJsNkFqajJSSkxtNWhLdXEvRUk3dVRaWkV0RXowcVEybmh3eXNtZEZncmx4?=
 =?utf-8?B?UEFPR1FVcjYyVkZoVDVOeVc3UThjR01zUXYrQStsVWFqU1Z3STdrTWhZZVhX?=
 =?utf-8?B?UHoyZ2dVKytnaFZhcUdXa3ZpQWJoQ0h3a01EOW8xbGpZRW91YjRTQ01QM0tW?=
 =?utf-8?B?S2hsaTZicE9SVFUxQ3Eza2V0a2RKTEVEVTIrSmJyS2hiVUlwbkdOcit5UGY3?=
 =?utf-8?B?bmFGM0plMUltVjJ2NjdPejVyQmgyZmJwYzNFRE9pdTM5Zjh1b1hkYjhjUTRX?=
 =?utf-8?B?LytYTDFrU0w0S1hCK1V6RU1URmJ3T05OSVZxcmYvMTBTR1hPMjJiWWlocE12?=
 =?utf-8?B?L1hSaWd0NkNTeUtJdFJFNXJvbGxVVnRNUm9HZElFTDJkSjAxb3RCRnJoR3Rq?=
 =?utf-8?B?QlFudkRtb3N2WTBiN0VWSEpsTXM1Z2hPeUR5K1Y0bUZGczZHWm9lM2hFRnpN?=
 =?utf-8?B?eWx0UlpyUGpQNUFZOEdmQi9HSVJmd2czVGVsL2xEaXFTc0VhT3lLcFFMSUQz?=
 =?utf-8?B?WnV6cjc3eDdpMGo2eEozSXd6aFlzb0VBM2Z6TmNRaXBjV3FrTEZXcjZtNGMv?=
 =?utf-8?B?MVNJQ0VmeHBEcmNmRkFLOXAzRUp0SjRqV1BSb2NXT2pPbDVVT2FCSWY0MUFK?=
 =?utf-8?B?ZnRKN2dGam1BU1ovUmdlQ3k1T0tIZ2lNdnFYOXl6Rnp4dDdqejhMMHpwQUEz?=
 =?utf-8?B?NGU5aGVyYlFPeUtsM0IwaUhqbW1BVnFYclN6SmQ0eEhDazVmR2x6RWNHSm40?=
 =?utf-8?B?TU5rbnR6amFmZXhLcExkQXNBdmhPOTFBVG1VTHl4b2RnY2xYOFFBekVLTHZU?=
 =?utf-8?B?ZWVPaTBqSVRBcmh4L2k3ZVpUaCtSaDlNdnFlYVZlMlJ4RG9CcmZPSnJSQ0Nl?=
 =?utf-8?B?ZGlRZnpKTWh4WHIvbFZRd2pHbG44TEw0b3hrZXpVWWNweDVoNG5Sa2VOcVV6?=
 =?utf-8?Q?vPFzjd5CnUgbKXcDra0jnFKbvDa4lteFGrNDoVf5Bk3T?=
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
	VBo+XWNkbm8boSi6rOurQbYayCJgBweT9TJtBcKWkLvzZxo9x8bR32OeW9HT9xACAG1qVTamBfsjhFpE9cfBDbWBZx6TPz+VKc5fR+/P5cPZgEB1sP1PfAak9L4PSTl/GWeZ4UbRvkvM+S29tPWPowDRnTE/AE96HyYX1MRBjHmB80OB0Swj6/jdL3/KZuX0vE9vedgaUC3YckoDA5Qz/lBNUKnVz867awRX6FXjl6PsaFkHQsOLvM6upTcO9Veip5lsTeqFcXGGei+WfY0Xt69XGwhrn6+W+i+v14S4vRP+eaDY3Tv6aa7aE89EqH8IoR7uja3LqeuqZMnswDLog2RQ/OeOTEoZxuglgX6URAapxcv3G95SEe8mNMb12nuvBXIPb1P0Zitxg7/BvMAkYIzg3CeeC+o0zOaOJzYmNTt9lODVEz875k9DQFWisE0NY7teaIOToeQ77fEgKm5RRB1qe83y760ZR+fAvklDzlQ/fmdt7uYgBoKaj2M4sDClKM/QhBHaGao7EARMbad9iegKwe14nWHCPXuoh2KFM5nqq7Wg7EUTXt7tXVNzNg2wX1EdIWkbQ42lzWeHJlHuSO5Og1DYly4RTSicC5aNf9RWfEjCRzBp3d0MapfhiyYo
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d992c9a1-7f4a-466e-5c14-08dd460f84b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2025 18:04:22.1306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yeCG7Y9xtSMUCnH8vGEoppaetv/L+7iIz209uZzNPG0X8d15lKVBIFDbz5ndZrfTv9Dc6i3dF0u9EygxR7XcmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7293

PiANCj4gT24gMi80LzI1IDY6MzEgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ICtzdGF0aWMg
c3NpemVfdCBjcml0aWNhbF9oZWFsdGhfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICph
dHRyLCBjaGFyDQo+ID4gKypidWYpIHsNCj4gPiArICAgICBzdHJ1Y3QgdWZzX2hiYSAqaGJhID0g
ZGV2X2dldF9kcnZkYXRhKGRldik7DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiBzeXNmc19lbWl0
KGJ1ZiwgIiVkXG4iLCBoYmEtPmRldl9pbmZvLmNyaXRpY2FsX2hlYWx0aCk7IH0NCj4gDQo+IEhp
IEF2cmksDQo+IA0KPiBNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgdGhlIFVGUyA0LjEgc3RhbmRh
cmQgc3VwcG9ydHMgcmVwb3J0aW5nIGEgY3JpdGljYWwNCj4gaGVhbHRoIGV2ZW50IHJlcGVhdGVk
bHkgd2hpbGUgdGhpcyBwYXRjaCBkb2VzIG5vdCBhbGxvdyB1c2VycyB0byBmaWd1cmUgb3V0DQo+
IHdoZXRoZXIgYSBjcml0aWNhbCBldmVudCBoYXMgYmVlbiByZXBvcnRlZCBvbmNlIG9yIHJlcGVh
dGVkbHkuIEhhcyBpdCBiZWVuDQo+IGNvbnNpZGVyZWQgdG8gcmVwb3J0IHRoZSBudW1iZXIgb2Yg
dGltZXMgYSBjcml0aWNhbCBoZWFsdGggZXZlbnQgaGFzIGJlZW4NCj4gcmVwb3J0ZWQgYnkgYSBV
RlMgZGV2aWNlIGluc3RlYWQgb2Ygb25seSBvbmUgYml0IG9mIGluZm9ybWF0aW9uPw0KSSB3YXMg
dG9sZCBpdCB3b3VsZCByZXBvcnQgb25seSBvbmNlLg0KTGV0IG1lIGNoZWNrIGFnYWluIGFuZCBn
ZXQgYmFjayB0byB5b3Ugb24gdGhhdC4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3Ms
DQo+IA0KPiBCYXJ0Lg0K
