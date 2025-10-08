Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1089D1C84A2;
	Wed,  8 Oct 2025 12:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.152.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759925795; cv=fail; b=h31/eSC30B02tLETkIDsCsgOfBoRCzEYvMOnEgg5vYBdborlI2z94TLWTDSjdPo2uKrAXfXQvgJwEVvXhtov68ThontHn05fbc8CGApy2Nw6fuW7xbWlA4sQ0TSHinKHGgyU+uOhDG9CDRMiVjwmIjCVyZunOcmRVUcut0aRpoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759925795; c=relaxed/simple;
	bh=0VkNeKMJLgwBPrZYWbxFbEA2POb1qu94Nj4eOpCDnOM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=McCek4oglZJMEJydI0RifkLWXsvW7iC9c/F9QDI98VVF3AWp12rivLT/F7+JpuShGm3lnCq8jh5JvzEx8hF/p+ssLoMeVx1a9NESkcRchi92USWsQPl+WZjIz06oGnGjVnOVR00iLj53gnk0N2QQuJJAffnJKUpH1UDdeRP9f14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=TkkErI6E; arc=fail smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="TkkErI6E"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1759925794; x=1791461794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0VkNeKMJLgwBPrZYWbxFbEA2POb1qu94Nj4eOpCDnOM=;
  b=TkkErI6E0KvBcSdbXuE2I49li9soxZ+uQU3Tqf7NfwuMtMahN6o4gPnl
   Uju8ziDPspixhp3ToPKDas+20YCpEI/aEEq/eKbaRtnWiNQ3Hy88IPowa
   PD1m+F3l2+V7i3/Li6mivvPG1YnjL+MdEs9s2ik4KMf3LjTHXf4lcY4Br
   +jay1E5bkuEgue2gybk7SM5AGHJNMqlUqmbsZM4BdTzJTruMgtrYAzCFw
   L8PUDACp1iD2O5BLs+XQArCdFlMwLfisD4q+UUSsb6KEjL8A/UyJdvll3
   rJkhcqZ+a1KKcb1l9fArIQSVVvTK12KGtZB7QUl6USQWehmQvD8IfY2IA
   Q==;
X-CSE-ConnectionGUID: klqR2qSLRym5esrxfL8jsA==
X-CSE-MsgGUID: 6QBV5+uYRSKxAkOa5Y3AJg==
Received: from mail-westus2azon11020095.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.95])
  by ob1.hc6817-7.iphmx.com with ESMTP; 08 Oct 2025 05:16:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qRx4FLJrcXDnBUNjrLfjAK24owTwA+KONittrNE4GksCJ6oKcNwjM3GqjSp2WO1EhR1OFfHpARKcpw4wB0pzKVMrxmqW9xrmwjY969mjNolNbuEGs9zUFVFAp1FssNZfhdJcV89xXaRTnKC7T09CzyKUsLgtm7ifRykCvvRtKEX1PnXWDys5bmG3Q/QtdsNNNU8fYw3a2HixgVQch7gORAAa/O8ZjgCevxa6XD3xYln3I50QJ1EitYMyweG72qc2e9MjbEePUJyK+yVGlo3SjG4xDT0ry09N2KIfZ0l2Sn5ydQCHhBbN7nLs52A48Tejb5GYRzA4lkYnsgwCzFPT9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VkNeKMJLgwBPrZYWbxFbEA2POb1qu94Nj4eOpCDnOM=;
 b=I439cSrpkWLM4mwTR1ZRGrtzt+zPLfybCk1evnKmGWFDLuSdv3YFV4ZtE7USJQZcQwUjzJ4voCo1DMPJo4ktiH691MMm5UbAxxyUv8VGG7DO5/boGmLWO5XVa7NyPY6P9q6co0f844T5CGZYQMCr225FoVAhMtx5DutDNMEVpzcJuphMvXH/L8hCDxapr2WJNbNxyw9zY3qceSpg9GSj0DRBWSOo6suv38vdMeFQ02LrXxWpoALBQHLCv3BEcmGh+whskwv/jVI0qAX+U11xM8/5Qa0kjM75Wv9+a4tj5nrhHvHEsY496k4xWGg7OYzfz7+jCZRBj2c8TAy8Ha5rAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by CH3PR16MB6447.namprd16.prod.outlook.com (2603:10b6:610:1de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 12:16:24 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 12:16:24 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bean Huo <huobean@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
Thread-Topic: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
Thread-Index: AQHcMpninJZ2iAUFjkahnHpKkVJvdrStEBWAgAsdOgCAAAgCIA==
Date: Wed, 8 Oct 2025 12:16:24 +0000
Message-ID:
 <PH7PR16MB61966F897DF133E14AC693DAE5E1A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-4-beanhuo@iokpp.de>
	 <PH7PR16MB6196ADF912182709D465970DE5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
 <5f12fdaaa49aad21403a0a9b96d2b8b3a6d3ca1e.camel@gmail.com>
In-Reply-To: <5f12fdaaa49aad21403a0a9b96d2b8b3a6d3ca1e.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|CH3PR16MB6447:EE_
x-ms-office365-filtering-correlation-id: cc45bb83-ce82-4f9a-a904-08de06647ff8
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?SDkwcS9XOXhYa1BxdGkwUGFlZjNMUU1MZ1lWL3dONi9MdHYwdW92SEUra0lK?=
 =?utf-8?B?OWtvK2VPVlhJSUowc3I2a1AxS2xUTVRtREd1ckJWeXlBZmtFK09BTE9TaEls?=
 =?utf-8?B?VGNSUzF2V2tjaEhwdi9xS0hLUTZ0YktzWFRydEpvK3QzZ3lXZVc3dEFCQllV?=
 =?utf-8?B?dDhra3R5SGpIekFRWERhdDF2YkNJZ1pJVHp3cmJ3NGJxYXhuTktnbEdoMld3?=
 =?utf-8?B?UERITHVNMU93M1liSnR0UU4rSkE0UDVKSG1zVWFOemdYaFNFSndoVWMyZG1s?=
 =?utf-8?B?c0trRlhkWmpjY3YrazJ2Y2t5b2hsL2ZpK3c3T1ppQnVtRW5UUk9ya3U2MGor?=
 =?utf-8?B?MmhQWDlMZm9Kd2FDTmRHK3Fnb0VYYittcnFHb08xa3lEZ1JaR0RqTGJMNUxF?=
 =?utf-8?B?UVJCbEZiQ3Z6eVBhZWliZG1sWjJ3eThsVEtFcjlwUmlwWWtOZE1Ncy9IR3Na?=
 =?utf-8?B?ck1CZnJaYzZYWTdiRXk1emJJY2lvNzZJUGI3OVgyTGE4STdYU3hKZ09VKzhp?=
 =?utf-8?B?eTdPMXFWL3l3eUtxcmtQY1lOTm1XMndPa2NQQ3hJMUNtNk5rQmVpNXZUUGJI?=
 =?utf-8?B?c2VVNGNhYklPd05GZ0xXS01XQjFSTWFaazRCSmJ0OEcrWVlnNzRkZWppNEF1?=
 =?utf-8?B?S2JrUjZkQXhiV2t1OW1oNlJmcjhBVTl1VjUvWEhtVjROaDdIblhjVEgreGZS?=
 =?utf-8?B?TmdFN2Y1VkhLUVpyUGdxZ25vUCtNOVQwS3pacjBuby9rWjJ2Z1ZWNkhGc0Ix?=
 =?utf-8?B?VGlaS0diRS9GaTZ0ODBpbmhjc3VuRGxVSHhUVG5INUhBdTYyU01kR21tRHpW?=
 =?utf-8?B?d3JodFJ6eEd3WkdpdXkvWk5QbUgwKzNabUFIZUxTNEhYQkRQd2pOL3JPeGZv?=
 =?utf-8?B?WmJjVURMbk9nZHYzc2prbjYzRVNaTzh1V2VmM0xDWW8xZkZOYVk3SjdXVUhy?=
 =?utf-8?B?SWlNeXFON1MzaFZSTHBwUFdMcjhnK2ZwdU1uMW5zU3JXU3F5VllsYTlkVU96?=
 =?utf-8?B?OFNUOGNHUEV0OENnZ29Gd3Jha0U1NUFla3cyS2NpY0NaVzhhWTlCNFdLZ1o5?=
 =?utf-8?B?blVFWE9SVC9BOTJwYTRzb0lHWEQ2WDkrSmFySGVmcFE2dE9Rd3Y0ZWpicmpZ?=
 =?utf-8?B?bExrb1Q1NmhoblJMc1VnUThkNXNzZHB6OUNuaDB5a0haU2x6VGloMnV0Q0Ft?=
 =?utf-8?B?WDJ2ek01bmJzRnJhNnZEdklUUTN6SFg1MHpoQ3hpTTJMSnpKMUFMSFhYYkRE?=
 =?utf-8?B?OVJBYnM3RVhtSkFDZFVMcWtkem1EMjRIanRIRFYwV1Y5TVFtS0w1alVGTUxR?=
 =?utf-8?B?UFZmY3FLTEUxTzc3aWQ4dkhvWVJMaDhXQlBhWXNPZ3lSM09IZHcyZ05TVkMz?=
 =?utf-8?B?T3l0S29udXM1QmJTMm9JdVZNRXhxclJwdk1TOFlaRmdjbGhlK2J2NG1TbStl?=
 =?utf-8?B?VzJnOVlGN1ZibWJPNlU3alNCbTNRZXQxMFl3akpESzVPODkzUnRQZ1N1T3NX?=
 =?utf-8?B?RTlCdnQva0YwZmRwNDljUzJhSHFoZ2QvVVFwenNhRzAyeC94TGh2MGU1SjQw?=
 =?utf-8?B?QzM4VWtOd2VpamJIQkZkQWdqV1JIbmZYeEdNYzBvV0xxc3lpdlFSTFdsUld4?=
 =?utf-8?B?VnQvVkxaRDFzSzlrc1FHNWlqN2w2VW5jb0hvSmg0TFI3enVYLzczRUY5R0Mr?=
 =?utf-8?B?QlFpcSsxWFdMYXVnOUxReEh6YllLUVovZWdQbmJrVnFzaFhpMlZiQUNGU1Ji?=
 =?utf-8?B?cGJqL1lVT0dKQ3FNOE5nTjB2aDFvYTBjeStxVElRcDZEaExXSURlZVpxNTF2?=
 =?utf-8?B?OVljaVhGcngzdEtmcW5BY2lnZEsyQTZ2M3hzdnhjZHVCcS9TM1FDbzhMVG1S?=
 =?utf-8?B?Q1FDRHlsQVduU0NNOUZPdHZIL01qeStXT2IzVWxqaVp0LzBHbjU4WWQ1RFh5?=
 =?utf-8?B?UmVPa2JZODZnbUZLUUtGMlJTOFJBQlFpRzBaMERyR2hCdDRwdE5Qb0RhUVFw?=
 =?utf-8?B?QlhNTzIyQ2wwSE8ydlBsMnN3Z3BQdm1jbFc5UWFrUGhQY3J3RVhNYjdoSXM4?=
 =?utf-8?B?T3lmdE8wNW1TOTZzTm1xTDk3cXB5b3czYlVzQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?azRTcTNnUGFXWGdFbkcvTnlMSXdoK0ZYMTdOVmpOL3ROellHdFhuNTFBSktU?=
 =?utf-8?B?SHErcDEvbnpjU1FkNkNlamNEbG8rNDVrb0k2OUcxbnFLR0x1QVZ5TFEzVW5I?=
 =?utf-8?B?U0tRRVd6TmRablFHem1jZkZ3SzZOeVBSUjY2YzVtZ2h0azd5TlNVaVhvUGdM?=
 =?utf-8?B?OVVWUjFCRFI0MEdPMU9XNG5BRXdOU1BjWG5LOTlCRlpUek0vS0FLUnRRWGJp?=
 =?utf-8?B?SlFwUzJVN1pnNHdrQjY2aG1tQUo0c1BaRVJ1TnkrYi84cmFzNkFOakIrTXR1?=
 =?utf-8?B?bjN6R3I5WTRuM1ZTaTQvZlpKeENPMjJUdTk2NUtndVFzRWp0ZmlEZGFyL3Nz?=
 =?utf-8?B?WU02bC9JSTF5M3B3Z3VuSnR2blRUYWlhdllXL3VoTG9mK293Z0VHaDdib0pr?=
 =?utf-8?B?UXVVR0pkZWxueGU2a3duZ3ZsUndyMHpFSkg5L2pvUFhDMzNOMVlodk9uUzBH?=
 =?utf-8?B?cEVYMWQ4QUdMWi9DbVNGdzllcHh5N2Q5QU5hNzFqTUVkaHRmWVpueGZ1NTZL?=
 =?utf-8?B?bjAzRk5NMTMzSWtsNUpRZUZHU2tQMHR5SS9lUkZ0R29oYnhERndYVHJac2FZ?=
 =?utf-8?B?Qi9kWG1EMGpFbE1lT1FVK01Uc3pMNUZiNDFQWVpuNVJXT2sxdEZ1dGNxUG5u?=
 =?utf-8?B?L1o4VGZFZzJNWWxwcHIwMlgxayt4ZWx2bzZ4YmZZMlhDMWZTS081RnRnNE94?=
 =?utf-8?B?VlVrR28vZ2ZOY2VZaktRMjFDTEFtamt0MGd5M2tqa1FSZFVwZU5Ob29WR0Rn?=
 =?utf-8?B?L3diZG8rTU96SitpMVZ4YkMzak5lYVdXaHRBWGhCUmM4bnJDZ0lEZTR2SC9x?=
 =?utf-8?B?cDZ3UkFwUE5ta096WmpveGhxcXY0T1lKMmhtNGNmTXN2U0VuKy9hemNWQzBj?=
 =?utf-8?B?VVVydGFzOUtjanVEODY2cUc5cDFhdlY2SUk0SDM3djdjTkg5WjlGVnVhd2g0?=
 =?utf-8?B?bi8xVnpCa2x2bzYzZU9RVXRLVnFwRnBjTi9OYXJNWWN1SmdDMjFOdkRXYk1Y?=
 =?utf-8?B?eUk5NTVwYXhoc004Tk5IYXlhQktHd3RnSHhwdmZCYnF6dXk0ZVFqbFcrUzV6?=
 =?utf-8?B?NFVMMVUrdXMrZndrWnpnVUlINHVNdW1Eb3NjL1EzOVVhQUFmQm5HbUNMM1BD?=
 =?utf-8?B?d28vaENjd1g4N3p5a2d1RGRxWkVQZDlZSjROanRhSUM3ZnhsZk10dCtXNjdQ?=
 =?utf-8?B?R2haeTNObGZhbVpvV1VUVDBRQ2pnaTJhSFdidndXYUtjNnNPd3BBREU5Z1JB?=
 =?utf-8?B?OHRxaDlBc1MxREpnSnJucG85RGo3SUVRWVdUblNWTyt6ODZDYmNTNlFkclBj?=
 =?utf-8?B?eU9YQllUcWxFNlhmY0NCUEJUQUdSR2V3YWEvcjkvdUdpK1pVL2hWSitDMXdo?=
 =?utf-8?B?Q2lpSFhZRmVEbUhKTU9OdW1WZnVvNzVNeGh3RWpDWkF4Q2lqVlRraXNYQnVa?=
 =?utf-8?B?RldXSXYrcTVoRUN1V01oUUpZTS8vSEtlMEZtNkpWdmlKWWFvUWVYNWtLQ1Fl?=
 =?utf-8?B?Nlp2cEtLeHR4MEdxNnFqbU9kY3l5WEJxcUZlTTJESyt6ZlYxM2NlREt6TUVv?=
 =?utf-8?B?ZzU5QUlVNHo5M1J4SGt3N1ZoMExuVzFZdG9ETTY2d0NXRDlHOXV4cXFyZGxV?=
 =?utf-8?B?R1Z6WkVpMnZ0SWE5L09VbGZLRE1pNStzS3l3QWZiWGlGYVhPckthQndUbWRH?=
 =?utf-8?B?ZnNrQTE3d2E4aVJtOEJnZURVRTZrNm5UY0tHUFpaN2FzaDdUcUtuMjlKdTh4?=
 =?utf-8?B?ZE5yRm1aSHh2OFcvQ2lvREVuREZuRkZSR0NEUjVNMjY1OWg0MWh2UlkxeWI5?=
 =?utf-8?B?b2FDTGxVRlgrTGRaaVlPNzQ2QW9HREVncm9ydXhsRXVZRk1iTVdYU2R2ZWN1?=
 =?utf-8?B?eVcrbzNuVlE4bmQ4bHlidmxnbmh6RUFOTDlpNVdzYjlKNVhnbm5tSTd5MTJM?=
 =?utf-8?B?MXlIMUZoSXRCdkZUQWZUaHAxOGg0c0lzaHpZbC9wVS9iUkdkaElJdk4yK2g5?=
 =?utf-8?B?OFhaK3FIV0JBYi8xWDhjKzU0WmhXZzNRSUREblYxWjlObytWUk1YalFOYmxG?=
 =?utf-8?B?OVU4dlV3SGRENUQySEhyMW93K2xualJhR1Y3bWNpeCtDV3V5UXZJcE1zRytJ?=
 =?utf-8?Q?oXIZ9yM8J3EGDlegmxDXdcSkP?=
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
	rcRdR8jjnQQtb6+sJKqxfxKUI2JqSd2BTqpPvQXkV2IrEQI52+xGwfbOhKCGFm9rW/lL+qi9UFMbMoAJH3C7zmwUFiYoxeZJjTG727+EeEgAYQqcUaQmyaPo4p97Pc3wJz4+gUNZH693wWQspQhBne7hwE22wo0XjoVM3LTnx3Ww5Af7Lwlg3cEBHujPu85/U/wdI+KyxXhAUHApsRF33FsWuat6tRA41n/y9Lkzchtr6/9XQt7CL4DIfe8CJml11okEBDzEbWA1Vif4QHw0uneuLIPEzk07i7LMEGebGlLjJ+ieuJ7vI4/GymXBxr66JT7qbkZAVQpr2PfzM2V1bRNGdp9ybKf9EG8N6qvp8l3QrDPuPOxUoY8RLac/kWmhXzDtJhcfILNL9EM0Ow/nI2JaCorQTvUREZur7XqMDOlIhr8YkFeyqkHYiOW/WEJa1rI9jaHNhXPiBx+/Y6W3aV7IbAmeHvP8dqftiOzihcleJswCcGPpl5y8IXBIiU+Bxo6rN92U4GOLBRU9bm9TxEA+2QdTdhbizSon1tXjNpcx3mp6y2G8bZXUfS/zNropM4dbLC48cRmLTRdWVAConbPtCuZb0rcUul27ziPNUHd0xWFB9vWvzFetufzmPtUSp0q+agg+BV/BONzeuTYD0Q==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc45bb83-ce82-4f9a-a904-08de06647ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 12:16:24.6212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OLhBqBz/ehTqdKngQR36J9LQqi7ZtbLjHsvfmjP3JOGwWgH9fvJXpWEWKsohFx6KC2vfwbNchHGg4/BW3WC6Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR16MB6447

PiANCj4gT24gV2VkLCAyMDI1LTEwLTAxIGF0IDEwOjA2ICswMDAwLCBBdnJpIEFsdG1hbiB3cm90
ZToNCj4gPiA+IEZyb206IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4gPg0KPiA+
ID4gVGhpcyBwYXRjaCBhZGRzIE9QLVRFRSBiYXNlZCBSUE1CIHN1cHBvcnQgZm9yIFVGUyBkZXZp
Y2VzLiBUaGlzDQo+ID4gPiBlbmFibGVzIHNlY3VyZSBSUE1CIG9wZXJhdGlvbnMgb24gVUZTIGRl
dmljZXMgdGhyb3VnaCBPUC1URUUsDQo+ID4gPiBwcm92aWRpbmcgdGhlIHNhbWUgZnVuY3Rpb25h
bGl0eSBhdmFpbGFibGUgZm9yIGVNTUMgZGV2aWNlcyBhbmQNCj4gPiA+IGV4dGVuZGluZyBrZXJu
ZWwtYmFzZWQgc2VjdXJlIHN0b3JhZ2Ugc3VwcG9ydCB0byBVRlMtYmFzZWQgc3lzdGVtcy4NCj4g
PiA+DQo+ID4gPiBCZW5lZml0cyBvZiBPUC1URUUgYmFzZWQgUlBNQiBpbXBsZW1lbnRhdGlvbjoN
Cj4gPiA+IC0gRWxpbWluYXRlcyBkZXBlbmRlbmN5IG9uIHVzZXJzcGFjZSBzdXBwbGljYW50IGZv
ciBSUE1CIGFjY2Vzcw0KPiA+ID4gLSBFbmFibGVzIGVhcmx5IGJvb3Qgc2VjdXJlIHN0b3JhZ2Ug
YWNjZXNzIChlLmcuLCBmVFBNLCBzZWN1cmUgVUVGSQ0KPiA+ID4gdmFyaWFibGVzKQ0KPiA+ID4g
LSBQcm92aWRlcyBrZXJuZWwtbGV2ZWwgUlBNQiBhY2Nlc3MgYXMgc29vbiBhcyBVRlMgZHJpdmVy
IGlzDQo+ID4gPiBpbml0aWFsaXplZA0KPiA+ID4gLSBSZW1vdmVzIGNvbXBsZXggaW5pdHJhbWZz
IGRlcGVuZGVuY2llcyBhbmQgYm9vdCBvcmRlcmluZw0KPiA+ID4gcmVxdWlyZW1lbnRzDQo+ID4g
PiAtIEVuc3VyZXMgcmVsaWFibGUgYW5kIGRldGVybWluaXN0aWMgc2VjdXJlIHN0b3JhZ2Ugb3Bl
cmF0aW9ucw0KPiA+ID4gLSBTdXBwb3J0cyBib3RoIGJ1aWx0LWluIGFuZCBtb2R1bGFyIGZUUE0g
Y29uZmlndXJhdGlvbnMNCj4gPiA+DQo+ID4gPiBDby1kZXZlbG9wZWQtYnk6IENhbiBHdW8gPGNh
bi5ndW9Ab3NzLnF1YWxjb21tLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNh
bi5ndW9Ab3NzLnF1YWxjb21tLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEJlYW4gSHVvIDxi
ZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFs
dG1hbkBzYW5kaXNrLmNvbT4NCj4gPg0KPiA+IE5pdDogV291bGQgaXQgbWFrZSBzZW5zZSB0byBz
aW1wbGlmeSB0aGluZ3MsIGUuZy4gOg0KPiA+IEluc3RlYWQgb2Ygc3RydWN0IGxpc3RfaGVhZCBy
cG1iczsNCj4gPiBVc2U6DQo+ID4gc3RydWN0IHVmc19ycG1iX2RldiAqcnBtYnNbNF07DQo+IA0K
PiANCj4gSGkgQXZyaSwNCj4gDQo+IEkgYW0gd29ya2luZyBvbiB0aGUgbmV4dCB2ZXJzaW9uLCBz
ZWVtcyB3ZSBzaG91bGQga2VlcCBzdHJ1Y3QgbGlzdF9oZWFkDQo+IHJwbWJzLg0KPiANCj4gT24g
dGhlIGhvdCBwYXRoLCBydW50aW1lIFJQTUIgSS9PIG9wZXJhdGlvbnMgdXNlIGRldl9nZXRfZHJ2
ZGF0YShkZXYpIHRvDQo+IGdldCB0aGUgZGV2aWNlIHBvaW50ZXIgZGlyZWN0bHksIG5ldmVyIHNl
YXJjaGluZyB0aHJvdWdoIGhiYS0+cnBtYnMuIEFycmF5J3MNCj4gTygxKSBkaXJlY3QgYWNjZXNz
IGFkdmFudGFnZSBpcyB0aGVyZWZvcmUgaXJyZWxldmFudC4gYW5kIHRoZSBsaXN0IGlzIG9ubHkN
Cj4gYWNjZXNzZWQgZHVyaW5nIHByb2JlL3JlbW92ZSAob25lLXRpbWUgb3BlcmF0aW9ucyBhdCBi
b290L3NodXRkb3duKQ0KPiB3aGVyZSBwZXJmb3JtYW5jZSBkaWZmZXJlbmNlcyBhcmUgbmVnbGln
aWJsZS4gVGhlIGxpc3QgaXRlcmF0ZXMgb25seSBvdmVyIGFjdGl2ZQ0KPiByZWdpb25zIHdpdGhv
dXQgTlVMTCBjaGVja3MsIHdoaWxlIGFuIGFycmF5IHJlcXVpcmVzIGNoZWNraW5nIGFsbCA0IHNs
b3RzLg0KPiANCj4gTGlzdCB1c2VzIDE2IGJ5dGVzIHBlciBhY3RpdmUgcmVnaW9uLCBhcnJheSB1
c2VzIDMyIGJ5dGVzICg0IMOXIDgtYnl0ZSBwb2ludGVycykNCj4gcmVnYXJkbGVzcyBvZiBob3cg
bWFueSByZWdpb25zIGFyZSBhY3RpdmUsIG1vc3Qgb2YgVUZTIGRldmljZXMgb25seSBlbmFibGVk
DQo+IDEtMiBSUE1CIHJlZ2lvbnMsIG1ha2luZyB0aGUgbGlzdCBtb3JlIG1lbW9yeS1lZmZpY2ll
bnQsIHJpZ2h0Pw0KWWVzLiAgVGhlIGNvZGUgbG9va3MgZ29vZCBhcyBpdCBpcy4NCg0KVGhhbmtz
LA0KQXZyaQ0KDQo+IA0KPiANCj4gaG93IGRvIHlvdSB0aGluaz8NCj4gDQo+IEtpbmQgcmVnYXJk
cywNCj4gQmVhbg0KPiANCj4gDQoNCg==
