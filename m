Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B46F18B483;
	Mon,  7 Oct 2024 12:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728302693; cv=fail; b=ZenDOmkMRQwq59v+JBltY1Afj9Mu4Sdl+oLDkQucoNGlwD0LBiEPwlFFl6hq6N9ffrfDUxZ1PknPn5NoI/YN/oD8r3LJtF6x4Z+BKLRnDYo1bM8prm57VhTeUaeNXLyOYeuVGU4IvbVENtAfQBZBQrC+8WtBxDjCBu5y2Hg+A1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728302693; c=relaxed/simple;
	bh=xJMoJc2R+kov0ShnWnPSQMZf+VhNakH3PurL/LrvDFo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o94locN8KaerzCuU2A3RETmpd1u1S6h7tZpCTrtxV+qYLWa/eF0vVT665l8wDr4sBAL8Di7AQOUiVAWDVru5K3FmpsxcH/QfK4VZWZjA05Okqo6wbvm4xO3GZQu2ohPf0bRepvj1V1320M7DSaTaSOSF9F4q7zSrey0stnRTprY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UeAsCGWF; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cedecJMw; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UeAsCGWF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cedecJMw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728302691; x=1759838691;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xJMoJc2R+kov0ShnWnPSQMZf+VhNakH3PurL/LrvDFo=;
  b=UeAsCGWFdeS3rMyMNArdLEkApQMu0iYziuizEVR78Ekj8ETrtwXQgRqT
   Mi6CrHcpBf/YfWnnGQRi5KzrXPAEECmlLr8I7EZKShAxfwvGxkfO9FN4S
   zXsfkzUMEfrxVKvRdK8GTSJA7lSaH7lOmb5QdhhFpdL5uYQd7h4VqIP/w
   6pKFa8PWexgBKuchofWwz4nepe8n+p00xlNWjTQUq9IoSAW+AVDbP1wgW
   C1gIaUL3CftQUxgFYTSpYBJHQA+WsoQwUsM1/Tk+j17LEv9HV24QPKdML
   +jNWnhzbnXOz8s0+FuazkdRLyamIK6z+5MVEWT5RRcY7dDJCOlb9KyesI
   A==;
X-CSE-ConnectionGUID: 5bb2V3zBR+mr4Tg2m3NTzw==
X-CSE-MsgGUID: hkCAJlbTRByYWdPUYPtxHQ==
X-IronPort-AV: E=Sophos;i="6.11,184,1725292800"; 
   d="scan'208";a="27781037"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 07 Oct 2024 20:04:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnLbENwXt/Sl6ewJ75dURm/E+I5jodJ2REI2D7mVAR5y7aOtkEnlbtbQuYMV1e+OCYpZWGdFwYMZaigzJoTyu5RctqQDNTswKGuhO/P25SDYBGZomBgcmU0aE0rEqEgGDZnsdwan0gymeC9Z5AraF0Sb49vx7jCt8hVxdkgcE0W4/Axmg1pGnncyznoHfIKkmbaFQ58ht7YJ1m2SIHP1o8SU+ACAi04V8Iug1SoSXUCmr0zvNp+JS2bu48XFnSAm00AJM5p9CNDba+P/KeaHQFGGQWS9T9pfAdxfXEmu1WH2IhBPyb24BHrYWbVVMQpqGZtEdlWs3e1ti+DmlqNzWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJMoJc2R+kov0ShnWnPSQMZf+VhNakH3PurL/LrvDFo=;
 b=pnk2+XwxUuyCq2vctPSOGfPVQA7RXDeRgrwq0b2Lcb5j1ckA7xo0l8uaRoeyJiEbeQjvsC1h+nivBVQ2mY98n8x3NbD1GyTamWN0Nu3tCaS146p2N9h++huS3KfkirQ2ctNxUSR9JxyxMbjGxzeY3X3RKTjiYv4lkyrzS5X3DxUfGPu1IvEanF2uKronQe75s7zadT/CjA0mrEqrxrxw7NO7yNe/ZhxVE455Cd9CewUM4pOXI+UCYX9mWA6avcVEAu0TjuaJP7PmhaTzJojhN7bsVz8cur+zsOzjZDycrVgkxUu0kHc9NaIv8sd9CpwNQdV5XOg9hVZTco1/xfhw4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJMoJc2R+kov0ShnWnPSQMZf+VhNakH3PurL/LrvDFo=;
 b=cedecJMw14dIgSdYatoYX6DMP/NU0VVSU+GG0jzMBbqbxcI/WxCb+1uznzifCPEymExc3M6PqfoRald5Ty1XE0wXOyUwGBwmkl9NRgqPNGSixMNJZSE/9iQzXtYIfduoXJySwJe+DTrLALpAftyk2pck/zwSgtjAUAVBVISIYiw=
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by DM6PR04MB6826.namprd04.prod.outlook.com (2603:10b6:5:242::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Mon, 7 Oct
 2024 12:04:43 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::17f4:5aba:f655:afe9]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::17f4:5aba:f655:afe9%3]) with mapi id 15.20.8026.020; Mon, 7 Oct 2024
 12:04:43 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, Satish Kharat
	<satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak
 Kumar <kartilak@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] scsi: fnic: Use vzalloc() instead of vmalloc() and
 memset(0)
Thread-Topic: [RESEND PATCH] scsi: fnic: Use vzalloc() instead of vmalloc()
 and memset(0)
Thread-Index: AQHbGLC/oybFGpC9AE+UnfEPeQG3xbJ7MMyA
Date: Mon, 7 Oct 2024 12:04:43 +0000
Message-ID: <d4198e3e-cbc0-4b9c-baf6-6aada7decdb6@wdc.com>
References: <20241007115840.2239-6-thorsten.blum@linux.dev>
In-Reply-To: <20241007115840.2239-6-thorsten.blum@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR04MB7418:EE_|DM6PR04MB6826:EE_
x-ms-office365-filtering-correlation-id: 86a66856-3bcf-4289-5b3f-08dce6c83aaf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?S3BJbHpDUWJReTMrRmtnMmFMbUFQR1RXaXNVZVY5eHNmRWpYSzhCVHh5RVNl?=
 =?utf-8?B?bHE0OUViR3gyK3B3NTBKRkM2ZFVFZkEyOEdkL0V3bTlRNmRJL2RqR2Y4SnNS?=
 =?utf-8?B?OGFZK3NzdENTSnFiM2k3blBvbDcybjZ4OXgzcVkrM0tjckg4aEJOVG9hNnBY?=
 =?utf-8?B?Vkp5N3VUTitlRUc1KzlqUmphZ1hpNWdJVU0yMzhyUThKNTJBVW9LODBrSDFL?=
 =?utf-8?B?WXlHeHNXb24reDZGdkh0T2dqbHd1eDZDZ0ZrUjJLZ0pLcWpVNnVXcVVwUmV3?=
 =?utf-8?B?MXN5R2xDQ0FxanFrNTRnR28vQytaSUE2blBrYnExRld2MmtJbkczVDRZNEVh?=
 =?utf-8?B?WVNVUksxU2V1NFJPd0tiNE5sSFRnaHRXWVRVeGlZcHVGemxkMUNvWU5zZFN0?=
 =?utf-8?B?OXlFMitscXJWRWRnaGFYMG9LekFnZUVlY21GTmliZ0hyc282aFZRam5MNjNC?=
 =?utf-8?B?MGZjRkk4QmpsVXNlSGRkYmRsT0RoRnR1WXBPVXVkd0pkckM4UnFPSHRpWHdp?=
 =?utf-8?B?SjFUQW1FZDYrbkdTc1RSWXRTVjJDVEswV2FiYTFiMk5UTDBRQkhDb2hmYU1S?=
 =?utf-8?B?dnMwaDRWaDZjdnBudjFabEZnZnVaNmhMbEpDWmV4VTNPT21SdndqdTA1d3hL?=
 =?utf-8?B?ZGNBUlVPQ3BXZWtNS3B2YjlmYytDcHV5SGdsMzkzdmFoSHFkVVdnVHBIcWRF?=
 =?utf-8?B?Sng1Sk9Rc3hQanA0NGlhVTBNWkJCb2Iyb0gxbFEyc09pbmZ6clBKclpPMk9U?=
 =?utf-8?B?WDltY0VoTkRLbndoL3FJMlJkMGRyMmQ2SWpHK0NWYVFnMjUxUUhBNU5KdE1M?=
 =?utf-8?B?YzJ0ZkNVMmliUG9DeXppaXdWbGhBMWE4RmtTVFlwSmo3N015VWVoMFZqb216?=
 =?utf-8?B?U2hIM1MrMlNIOTlUd25WdHZkMURaZ0tXN1Z4UFRJMU8xbGoyMWJaUHVxUU9F?=
 =?utf-8?B?SVRkRVljVFljdmRIWmt0cjhqS0lRN3R3eCtiaUVnV2JJaDh1b0IwVUxFMHZM?=
 =?utf-8?B?aEpSNHUrUkQ0aDgwU1hxWHBjbGhzU290b1FHdHpLUEhCSG9NcVlNL0N2MU9o?=
 =?utf-8?B?Zmh0RkRKNnUzY2ttWGtsUVZvaENVS2Z2T2ZvejQxWEdHMWhyMVBmaENHVE40?=
 =?utf-8?B?d1o5aHBST1V3T2xDS1JBaElyTDhLMTg2SXJGbU9YU2NmelBYaTNNaDFFRFNz?=
 =?utf-8?B?VTh2MHF5OTMxZE83bk1vT25SWG5qcU05aWpmakV3ZG5IcmIydFhKZEJwQXlX?=
 =?utf-8?B?ZWVtdnd2d3FEVTUwdWRaRFJMK1lVeG5VS3lUK3FpOTZzU3NXaXdmNHNMdS9z?=
 =?utf-8?B?aVdVeGVZTmQ3SURsdGtIQ043MGpNeTFHSFN3RW45U0t5blFLMXhtQmE0OGsv?=
 =?utf-8?B?T011RTR0aHBVb2sxZjNkaitEZlRVS1Q0ZUtZd1R6aEtPQWF2UUQ2aVViWTZ2?=
 =?utf-8?B?bXBKS2FRV2tDeHBtRlBmNkNOVmRzSFpTYmdPOGl0UmczZGZxNnlZa0NsRG0y?=
 =?utf-8?B?QjkzKzduc1dwUTlibkhSMTFzK0dUc0tVdE5HN01tMkFpczlEVTdVY1ljZHhi?=
 =?utf-8?B?TlV2YXZlL2NUSTlXZ2VvS05WSVpDMC9SeTZtUDQzbE9YRjQxWEExdnpNc3hl?=
 =?utf-8?B?Y0paa04zbnlDRVBGWVYxWGFCOVVGWWptbkdCY1QrelNwYUpJR1FMYldpMU5z?=
 =?utf-8?B?WWRFbEgrM1c5N0pDQngwZE9sODVmS1VWTDdMaXgzblJzLytaZnBqL3IxSm1I?=
 =?utf-8?B?R0NZVURwLzlLdlJ5RTlGTW9IY1AyNDBuRDg3T1laem01WnlGcS9IbkJnUjJL?=
 =?utf-8?B?aU9YV2ZvWTcyTlFLdWQxdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7418.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UDBHVFg5ZkdOU1FPQk9jbGZoMGs3ZExGbWVnZzZ4TVVCVnB6d2JaRlZUT3l4?=
 =?utf-8?B?eXlVVHpGa3M5WHRrdjBqNWxYYmdpMVhyUnVVcFlmdHJZREJHZS9ldk1zUGRJ?=
 =?utf-8?B?QmdORVFHZGlnR2hXV1pYQzBkcDBvQUNzRDZHVS9aelp4SGxvY1NETzRkUDlo?=
 =?utf-8?B?a3A4L0RYN01Yd2ZXbUN1T09Oc01GRStINW5Scmp0SGdOWStVbzV1a3pJS1Js?=
 =?utf-8?B?U2xpU24xeGlzcWI1Sld2bkFxK20vQkVpT2hneHozaSsrNURqRzY2SGxJRmdR?=
 =?utf-8?B?cjEzRWdzanBvZkQ4aXhVRTV0bmNHalBHQVRwNFlrQmh6K1NzQTdEOXNuUFRH?=
 =?utf-8?B?Q0VXZFh1aDArSStETmg2YjJWeTNIRWN1SXV3TjBReTBURU9NRFFyblBSaU9s?=
 =?utf-8?B?cTNkK2J3OE5la2l5ZDRDekYrYnozTkQ4YncrbVJMeXNmbHZ4eElXMGh5dmlD?=
 =?utf-8?B?UngwNlpvOFZ3WHgvVk4xVjh3S01KVmhqUXI0dGN0MWc1TzRUQitHZzlwS2Js?=
 =?utf-8?B?cGgvYmZaaFpTRVZBV1dOV0lFZFdzTmZiQ040RXFHVkRKMjJzK1FqUElNMzhL?=
 =?utf-8?B?ZlFJMHQraVgrdi83QThjNDFKSVFxZWlBOURVZEFNTzkyYk9SVFV2eXpDa2ln?=
 =?utf-8?B?UXE3VGQ0Rm5pYkFwRjBBTk5OY2xMM09vWWFESEtQUnhqMTY5MDY2NkRKUnlK?=
 =?utf-8?B?QlU3Uy81VlYyMmIrcWZlM2FOZUpyYjNDazFwK0pTYllxZ3drSS9MMlZGWVB6?=
 =?utf-8?B?K1RFeWtaWFRBd2tUYVM2MDZ6OTg2Si9DS1VuM3YzTisrenhYWmFHdHNPSlhV?=
 =?utf-8?B?Q2Z4OFdxdFNabFZYY3crb21nOVdPZXhZSTE1SWF5clV4SnExZkxyNlNRN1R1?=
 =?utf-8?B?VVE2QWVBWUUwYy81WE1veGxlbVR6V3JQQTl2RGJCNy9qTmsxSzVVMS9mZWta?=
 =?utf-8?B?OWdKUzhIeFdRbk5Ua1RLa2hXME52dnhWdW9vVXUwK1FmUW9CWU9NK3F0N0pM?=
 =?utf-8?B?RnhmYjVJOGhDVnNITGlLQm1nZnNHNndzMVV2UUo5SFhRaWVCYk81b1dOOWpG?=
 =?utf-8?B?RHUwK1dMcmxPYnhNYzdrdEZ4eHY0KzR0ZDhOQjk0Qmg5TmJFcGpiek1LUU1l?=
 =?utf-8?B?MGlHTGNHTGpmdjRiTEJwSkg3dnRRVVY1N2pYc2VxUlBLbWdVVU1xdmNpSXNY?=
 =?utf-8?B?QUN2cHJIK25yUVZwbzY5WEdoa3N1OTI0dSttOXp1dzJGeGZSVEZGdVNUQ3Ro?=
 =?utf-8?B?RDloU1ZNdUdHU1RmZ2Q1T0lVSjFhZkg0ZlNZWTNPTDVwVmVoNjRWS01aQlZx?=
 =?utf-8?B?MlMyemRzYUFTSldZUjJ2MnAvZ2FHb2M3ZnNzSkdCa2EzUEprZ1FVdktaRmxI?=
 =?utf-8?B?cGNmV2d5TlB6UVFnUEFpQ2VSSGNsZkNkN1FtYy9JNkZPNG8vd3dHdU9Na1NV?=
 =?utf-8?B?TCtxL0kwYnZmK0MvSGZIcWJCelZYcUxVVGFjbmxnSTgzV3Fuai9heU5VQUxP?=
 =?utf-8?B?QS9IdTBIcW9WOXZjNDl2NUtJZk1UODJRTkFwWEgrWlppaWphemxHdVdpWXNu?=
 =?utf-8?B?Y2VsR2tPVkpGNEN6U3FSQWhmSFM0S01kenV0b1N0UStHQ3c2ZE9rOEtWb2Q4?=
 =?utf-8?B?Ykt1MzQ3bWV4aDVuR1g4cGk3bndMLzYrempMTkFoUllTUzFuUkVZRFc1VmpU?=
 =?utf-8?B?WE5wRk9Yc0JicDNjYjNGOUNSKzEzSjRzOWFqQUZLd1U4eWR4OU4veHJEcitk?=
 =?utf-8?B?S09MSGNrV0ROTmwvMlUwRzRzbEFVUlNMSjRRcjhMcUthemNrWlZRbTNKL21o?=
 =?utf-8?B?bzRnYytKVldqYzNBTDBTTWd2RVovWEY0eDNaVm5OVkdwOXNhL1hDMy9KUm52?=
 =?utf-8?B?TDZOeTg4eno0REsrTE94aHpVWGtkWVlFdlRsQTJTQ0pURmtVMm9hOFRCcW1S?=
 =?utf-8?B?L1pHOGxtV0UzZ2RDdFFXYUU2QzJuMjdGVE0wRzVmeFdRS2tsaUxmRll6VzJO?=
 =?utf-8?B?VytTelQvNnJWRmR2a2QwSEFWb2FoZDBkRzNhTnJYSXZUSWdGL29BdmtJU25P?=
 =?utf-8?B?SjI2ZjUxbWU1dGpROTRYNmMra1QzR1hlT1ZuTmk5MDlSdUZEa3VZSnhZcWJp?=
 =?utf-8?B?azVFVlVqTlBmd3FCTTkzbWF1SEdGUnJ4am10VlpFOFFmeENkdWhlMU51Z0hM?=
 =?utf-8?B?RThIZUpSVkN1Wm16RXpGdUFNT2ZpRXZoZTNYTjQwejBvM2lWSm1XT1djbXMw?=
 =?utf-8?B?UE5pSkJuUzVoSFRiL3I1dTAxV2ZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <979783E572DA1749A189AB0F1E33D0E8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qrc+slN/ru8pFFf+NK24PCvOvDG4Mfsu1c0FmDxRngCQvPcfZKcE7PFrjh+XpWvJ3uaZsqV5Rg2bdMJAZCuUfIMl+Ufza2fr1+LYBPf4U0MPJO1CQw8FAtRrxFDgrMlOc/F3B4UZ/tnnv8404lvkqDvziwh834MvNfsqxM2dbWBmS+7b1Q170wlij+1Pc8dUXdDypLrya/KEl2rfJ94wmeGNWGokbwHQW0yVgYhBuC9w8pofUNwK5i6vqIS6vVgNyU/N+Q+cRRyAHlTUnta3zZ+bi1hc3l+NOF/PbQlF01ThoXzi9v6PP+rlD5QY/cum4FXcrsPASttIK7vTtMuI0XI6BrmV1xDzjzsol8GfTFI3cFzKeLJL5kiV9/xhPxH4nJLWAmrgQu5gCH+Lx4t50ingnXb2saX5mF/n1YJWtu2tdzh+35k/XhF9wgm/v4/LrU7oJaFavDXWVClbPZhifTxpdJ65eu5AaCe1h+vGqFPv+Rqu30hI96Twysoes408BSpoaHhM++wRKPAKJOW1Xfu3UtR5RnuhwN6WHi2NWePY4eQeYAsrQhT0LGDjjv0ypEqqDCUisWsnrCc2KVzcQ8hZlrZWG18J3ezQ0t2NN7W+DTsafwNUkTfG0yrPUKM0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a66856-3bcf-4289-5b3f-08dce6c83aaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2024 12:04:43.1771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s4W/Pibt1lTKWFQ0sKF7AgSV61LdoQOLwtdizZX9l9NTg9zh9b9mgm9R4HGsqAeeum9jxsxGo/ZFKNg88d8pmFp34yxMHkoL+1KcTJWJeKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6826

T24gMDcuMTAuMjQgMTQ6MDIsIFRob3JzdGVuIEJsdW0gd3JvdGU6DQo+IEBAIC01NTksNyArNTU3
LDcgQEAgaW50IGZuaWNfZmNfdHJhY2VfaW5pdCh2b2lkKQ0KPiAgIAlmY190cmFjZV9tYXhfZW50
cmllcyA9IChmbmljX2ZjX3RyYWNlX21heF9wYWdlcyAqIFBBR0VfU0laRSkvDQo+ICAgCQkJCUZD
X1RSQ19TSVpFX0JZVEVTOw0KPiAgIAlmbmljX2ZjX2N0bHJfdHJhY2VfYnVmX3AgPQ0KPiAtCQko
dW5zaWduZWQgbG9uZyl2bWFsbG9jKGFycmF5X3NpemUoUEFHRV9TSVpFLA0KPiArCQkodW5zaWdu
ZWQgbG9uZyl2emFsbG9jKGFycmF5X3NpemUoUEFHRV9TSVpFLA0KPiAgIAkJCQkJCSAgZm5pY19m
Y190cmFjZV9tYXhfcGFnZXMpKTsNCg0KQ2FzdGluZyB0aGUgdnphbGxvYygpIHNob3VsZG4ndCBi
ZSBuZWVkZWQuDQo=
