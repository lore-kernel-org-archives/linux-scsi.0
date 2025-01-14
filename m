Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2C61552E4;
	Tue, 14 Jan 2025 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866897; cv=fail; b=YEspxmKWoIYt5H+iy8DZV9RkspDSPaQppw1XAMmyzjBCB9vYVYDNN5sWcMFReRwxpgMEr93iJFv51yG7m2duz4Q+NZBzccebi6MfKmmt2cMe6gfbBUatfcwIZAh3/ZbEsxWl4fxF0PDo90Gw1YRP+9RE6PdRx6qc9S13HLi8bzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866897; c=relaxed/simple;
	bh=mMtXvVoB5ija8LFYDROTkORZ7PLbBXqmnq16++Dd/uA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YDGJlV/9b8p9zzXe7rWlLmoylhpkJAuLqx7Cge9ZQ+BQd2nbt8+UUgxJK9HpvkVT51bwUgu4fReAxVyjboBreZMtjh3cdlymGRUdO+fuycaxnXPgP7po5dCRdddXQqD/iiRYOwc90vHnOxfKV9d4ock75rBjhl6dNJwleYdurxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RqjmF70d; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RXdQKpET; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RqjmF70d";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RXdQKpET"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1736866895; x=1768402895;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mMtXvVoB5ija8LFYDROTkORZ7PLbBXqmnq16++Dd/uA=;
  b=RqjmF70dyQukZkD+Kd2jtLX1B9JHIcY7TJKS+AQa8rFzbb+1bEYy8Nld
   wNpwoDVejPpp8yFyx+GXPoKuIJC5UwMNNGh2UF9z78cQ29zOLufYjEjoN
   NDAMfDFi6uZEOkPVSW13tlJZolTnc5A29vd7ZrY43He5iuZz/aycVFBZC
   Eo3mnmF6Tf7qDarZjUeRhUpqNvCaVN2vcL+hhse0DcI9e2i4El5w0kNTT
   zCIfe9l+xS6LBolYNTOtDeitr6ixyNgrj1p7aV0iOpudDQd5JtyiZLrlC
   FONMIwAldIdtjV9DKlvF4GhB2DK50jYEryotomZD8xRJstEc3eLqu4laR
   A==;
X-CSE-ConnectionGUID: 387QY/RKTjOK9uteeVYInw==
X-CSE-MsgGUID: 0reCalqtRx+0k13Y5ml4VQ==
X-IronPort-AV: E=Sophos;i="6.12,314,1728921600"; 
   d="scan'208";a="36420434"
Received: from mail-eastusazlp17010004.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.4])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2025 23:01:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=reHJ1d3/wL6u0mpcFcVgKNiNgQZRdoNBrvJFVY7ggfyKYvzGznlGNL314CCkn51ZJEdYKAY4qAkq/eO/8qbVU2k1mjHsBz9xlaQ2o8kzun1JVwKm6rzS0ucwUhqjEg8jYP//Ynn2ICjxpJzzHKTv9DBodyRKQJi7KozdyAPDRGH5bsQD/NrK4cARitwyaOvOEGMMyujSuNUVvwoTiiArSqVd/U3AB82xhbVIdPfIXvQXLBSVbyNNqP2/HUs3+MgxxgYJ9HcWy2PCLzxA/N5x/U41UCmVQbFZ/80IZS1d8UOhoAkvaUSbsvGO3wKhaymgYS/eao87BIctlIQwyUlmwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMtXvVoB5ija8LFYDROTkORZ7PLbBXqmnq16++Dd/uA=;
 b=c4/KpjQpO+7umlgsO8MQRCjO73N7xqijkkgCOgus9mAPqEydmvfen/hzwLdY5FTxrJu4iJ/HnrkoWj+1nC8DogXCpF9cA+LCp269vmx6djlH8AndMhT4hb+Ogzs5Z0mvUocvCIgvUfeRTJqVxo/WUlh1P7ztwZZ6G24lKnR6ZkXsJnWjvHDr93svWRuWH8OPySHqXjt6vy4ODlvgw7zyGu4tlfYDZbFXdOkXxkkTG2Jz2OeRtXoXPxFmicvEsOWQqKEuMRAyAKPjia8lY6rWhnRap/yXyLvO8i3uucebjGfLRCOWqlFWRelSOD+pw5h+2sDsZV+gnjbvZMpY60AuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMtXvVoB5ija8LFYDROTkORZ7PLbBXqmnq16++Dd/uA=;
 b=RXdQKpET2PL350Hb01XyQUqviU+KpGf6gCQouM0Z39vmC1azhsYJSH1BmHNccBsLWmVlye9pZHKt4RPByuyqtQ7AEm0baqXo4+XhEQe+Odf+V40mifLOY+SyCVOVUS7LI1U0YWUFRq1bP0WzpqIUxMK1aAavwsP4+++cDkr+8Vk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA6PR04MB9424.namprd04.prod.outlook.com (2603:10b6:806:438::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 15:01:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 15:01:25 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Guenter Roeck <linux@roeck-us.net>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>
Subject: RE: [PATCH 2/2] scsi: ufs: hwmon: Add missing ABI documentation
Thread-Topic: [PATCH 2/2] scsi: ufs: hwmon: Add missing ABI documentation
Thread-Index: AQHbZmgIWMxTBFm5Nkir5DgTTrDXZLMWWlWAgAADBdA=
Date: Tue, 14 Jan 2025 15:01:24 +0000
Message-ID:
 <DM6PR04MB6575F5273B102C74DD3AD96EFC182@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250114093512.151019-1-avri.altman@wdc.com>
 <20250114093512.151019-3-avri.altman@wdc.com>
 <2f2fe6f6-cc10-48fc-8df6-b82e4ba22247@roeck-us.net>
In-Reply-To: <2f2fe6f6-cc10-48fc-8df6-b82e4ba22247@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA6PR04MB9424:EE_
x-ms-office365-filtering-correlation-id: 9aabd7fa-3d92-4362-ce60-08dd34ac50dc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bVQ3Z3pKaFZWYnNJRURtMU9xWk05ZzNROEFSRUxickdhbFhyaFcwZHdHWTV5?=
 =?utf-8?B?UzBMTDFMWGdpdE1XZCtCNjFxU3dnVyt4YmthODJsRi9sNGYrWDJFdVlSWG5G?=
 =?utf-8?B?YkVYbHlYc1czQ3VwQVRhWllOdUVvZWMxcWFjVlc1TUhwOElJRE5WbDJFUU9X?=
 =?utf-8?B?RFRlNU9DbHhBbndNazAzV2VtbWJvSUFWUHhoRUxRWEFBS2tLWHN6NENUWUQv?=
 =?utf-8?B?ajdqZzh4cU9JY09UU1lyK1JFNUxJeVNDaUtFcTRyTTlRUis3bXJYR0RyVzlD?=
 =?utf-8?B?WGJZVVpENnhYNHBmYWdMSEFzSkkvZjQrMWhxNVQxbk11dWRnMkRPZnBCblJq?=
 =?utf-8?B?RllSdHBzZ0ZVK044SUZzQklVWVBjTHAvTzlkWXJtYnJwQzk2dGhJZ1g0cmJE?=
 =?utf-8?B?eU5Tck9HMzhtTCt4Y25YQnBjZzhDN0I0bnFtZXRsaGU1dlNJRStJc3l5WlFN?=
 =?utf-8?B?cVdNVmszWCtYWlY3a3oyR3lEcjFMdHloaS8yVlM3eXdiTGszdkxydWZDam9t?=
 =?utf-8?B?alNhdTdPMXZodjk5WjArL0NPWVd5QURQdytBRFVuYjh2UEdVUE1UeHNZaFQ1?=
 =?utf-8?B?SFRkeU9UT2JFSm1TRUVpZG0xQldSMTNuQUtTNS94SDl3MzBEam1HZ1pLZ0Zr?=
 =?utf-8?B?NmhoK2hybTVFQUhVOUFaclQyeC9iSXpYZjVNdjF5NHlKamROTW1ucTVqTnZB?=
 =?utf-8?B?aWd6MzNXcGlScStSbjRDRGhOVFFvRndkSTVraXJLMHh1bzYxN2NMbGNsRWRl?=
 =?utf-8?B?RENpd3YxTnVuQlo3QmQxTHI2UjE1cjN0RFpMaUFiLzgzQU43VU9RWmk0cXl5?=
 =?utf-8?B?UUh4bjltRU8zWE1Ic1VEc0V6VTF5SitISlJ5ZURkc1lEYnlZb3VYR3VBVFBT?=
 =?utf-8?B?RStYdzJPSHZmVHpGTVlaSGRwNnFnZ0hPMkxkK21FTUd6ZThxVms1bXlXbFVv?=
 =?utf-8?B?ZW91Tk5BaFZmVVdEdnhUVG9qc0RabVdOYlJyRW4vYUlXNE0xTzk4QVpMTVZa?=
 =?utf-8?B?R2prbytSeVQzYU5qelRsK0M2T1NSTHdzM3YxK0NBeDlmdCtrNHZJYWdORXVL?=
 =?utf-8?B?ZmJMZ2VZaHZ1TWtNK3ptNXM0ck1qc3hoY1BsMnFZTCtWUjRmTVY4VkM2d0Mx?=
 =?utf-8?B?YXpZRjQrR1I1VGpObjZsZElmWmxhQmxBMnk3TzV3ZE9OSHBabHZLTFVWUjdW?=
 =?utf-8?B?L2QrWVhXTVNZenR5WDRZeTEycXh2Q0RSV2NQL1VRcVFYTkVHdHNVUFhxbUU1?=
 =?utf-8?B?NlBuTHdhZS9lNG5abHR3K1VQTkJ1anVPN1VZRGd1RzVmUWprMjJ0QlgxOFJ3?=
 =?utf-8?B?dHZ0Wi9lNXl4am5uVC9pZE85aGp2ZENiZGMrN3FnZjcxVDBKcTJjQmRlWWVO?=
 =?utf-8?B?OFNOdnIxWHBEUGtPY1pnLzY2aE01N2VwdGpIczJvdU9oVVJLQkwrSE5ucjFH?=
 =?utf-8?B?aUN6T3lUcW1SR3R2aThZMXFWMGpKeWVmejU5OGovc2xqTFBCb1hpMHVoT1JS?=
 =?utf-8?B?RUh5R0o2amN0ejBCUUVwSENzblZ1eENLWjRlcWoxQXJqRHozRHYzdEtkYmJK?=
 =?utf-8?B?SUVsYWxQY2k3QTd0ejhrV1FSbmZmZ3N6TjlsazB1djV5MEVRM0JQTlhjMzI0?=
 =?utf-8?B?TjhZMXpLOG9rYyszbnhYZVFReE5CTDlYQjVKNmQzME9aUVBVVklUVnk1N0d1?=
 =?utf-8?B?U1ZLTlovb2NlWkl0TzVwZzBZTjI5amU0UWVWRXd6NmZJc09qSUJzL2hHNVpL?=
 =?utf-8?B?bWFiOFNoUDNlYUN3bGEzeVdaaHo4NmdJNTk3TXI4ODRBQzkveFBONUxzNnFm?=
 =?utf-8?B?N0VaZXcyelViMldYVmlCR2FqSlBwUlFDaG9abnBiSlphQzhzSVEvUGp5cVIv?=
 =?utf-8?B?UlplYnQ1K1RNcVVpOVJFc0pnT0diSTRDM2pyZk0zczRDUkpKTkM2TVhJOXJF?=
 =?utf-8?Q?tREk4Xwq/006xKKptlFpSoerSnCQyffl?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bmNOLzIvbldzZ1dSNUV5SmcwSU44UzVMMC94YzdDcXMxWFhFVzlrdWgvL2Vw?=
 =?utf-8?B?d3hyQVp0UGdrUDZVTk53emJHTGRaL2hrbWxseVJzNCtISUZVTGkvbGJ6eTFI?=
 =?utf-8?B?RmNKdm44RTlPR1FacHZKOXlBVDJwclhYRWRGbytuZlZzeXlVU20wZ0phdm5v?=
 =?utf-8?B?amhkWEMvTmRVS0pyQ0ZrQnhCVlpjRGJKdkhLbExOMDUyUUo5OFBBYW84YlMx?=
 =?utf-8?B?QTRDMFBHd1RuNnhHVzJ6cTYxZFQ3SXVZT3FrTFMxdm5xWjRudm1JZnNOb3M0?=
 =?utf-8?B?M0VneG5lNUlxbjJqVDRSNTgwM0licUtvWC9vOXUrWmorM0FRT0xQbi9Dc2VN?=
 =?utf-8?B?Q2hkanVROXFHSkMrSCtYMUpEbTRPcXdyMm9NWkNyUmU4UFF4YmNGcHJoMnNC?=
 =?utf-8?B?alFkWEtlaVhlVWEzOThJVVIwbWgvNFFOSW1xQTdyT0NMSTZKaWRxM1ZpaW9r?=
 =?utf-8?B?RllYby9jNW5EYjdNa3E5bUxzcWYyNitmWjNmZUtFaE54RFNqa1lxOEhORm93?=
 =?utf-8?B?SEE1bWhxRWZhMzFxdEhLTTZxcjV2UFpoWFp2MXRWdUlUL0tZeVFINlRtaUFh?=
 =?utf-8?B?d0NnVFhCOTlXbjBrRHdkNGROYURQS0NndXk0OThZTUduVmdSdjV6c1I0cFFS?=
 =?utf-8?B?K0pHdEMxbDQzMDdSL0ZtVk43M3hTdWJwdU5Ga3ZFeTdpVVIxWXhBdkpnNTk2?=
 =?utf-8?B?QlFYSXo3M0IwQmN5MzFKalZSL0xjc3dHMGR4OFpwUzZPUzIzTGV4bFcwSGdJ?=
 =?utf-8?B?Q3RpUmxSR0o1V1I0MVMzOElJdTRQZFN5eVpzcmd0ZmVqdEtaOEM5VWZvMnVm?=
 =?utf-8?B?MkxmOXJpNkd6aENjLzBXS2pudWZRMnNDcDMzS0ZxNXNzV1g0endPMWNieHRL?=
 =?utf-8?B?ZkJ0MzJXM1NtbXJFYy85NVNob2ozTjRJaUJ5eVcxSXR2QUVRaVp2R0wxT0hi?=
 =?utf-8?B?aU9PVHd4TnZLYXJ6YUFCVUtDakF1dEpzMXNjMTBZV0ppNEhoZTg1bmZ1QUs2?=
 =?utf-8?B?WFVIY1FhWTdKZ3pTYndTQkl4VDJqYlhyalRpWnlsdmJHbjNhdmRBc2ljOXpI?=
 =?utf-8?B?NW0rcWI5RUFnQlJaT2dLL1dJcWpwZzkxK05WSkpLeXRxUm1tZ0FlUVNvcWV1?=
 =?utf-8?B?UEdMTTFLczVqSG56aDRGcTJwa3JWbjh0MGNvclM0R2NNSDNjV09YWFBHK3Ru?=
 =?utf-8?B?N3g3eHdjMnpxVTZIaEs5TDJXeDJONndJQ1A2V1ZSTU16dkpjNFFnRlpIRXp5?=
 =?utf-8?B?U2ZsWmhkenlob0pyV3htVHJCWEQ4ZUs1ZW01NUNCOXA2RzJ2dTFSV0FrZUNK?=
 =?utf-8?B?dnJjcG9kb1QzcU1UbElWeGsxUGVmVUdIZ1duY3gySzJjb3haU3ZmVE5DWitR?=
 =?utf-8?B?RHY1UGVOZkVtK0JUb2ZSRllLaTZxSHVTTjVza3g0K0lCMFhoL1EvSWdZV1l6?=
 =?utf-8?B?NDViRzJwbzNJdVNOaXVMckJvTW44VDgwdzVtTGdIVHZNMzJzLzJLTDNaQVY1?=
 =?utf-8?B?N21YTGhIcllQWHlia1dFS0pTRlJ4ZG1EdlU4YVg1eGtZNjNsa3cwcC9QRE9X?=
 =?utf-8?B?SGRUTDR2aG8xU0dzbkFGUmNVQUlXYjdzVVhBK0IwdktCcHN1NkhhTmRVU2RY?=
 =?utf-8?B?WEdUKytjNDBOdnBiWEExQTNsS2NrL0cyN2tTS21LUGJqR2xyQUdBSDZwZCti?=
 =?utf-8?B?bldQVk1rcit5QkxjVDBtbGhMZDJQMGc4S3puQi81eHQ0cXRtZHA5c2dGbVd5?=
 =?utf-8?B?TjZiYUR4NmFYY0dQY0t2Q014S0k4WHhNTVNaNzd6dTlZZEdaRmxaUFM2NlQ4?=
 =?utf-8?B?UGk2Um1NQWdXbXBpUHp0aElUYmxsdllBVFg1a2tsRVIyZzF4NjB3QTdPMU44?=
 =?utf-8?B?Vi8rVmFnckMweEhaMzBOVVhUK1I2WHIzM05pckJGcWFLQTJlR3pJQVN4cEZQ?=
 =?utf-8?B?VnMzVkhqY2RrcUNtU2hrdlJ1anJDNnNjOEdzYXlOR2lZaGFVNGZKbjFrRUtB?=
 =?utf-8?B?T3hQaUFoRTJNRUNwRTY0bkNIRWJobHgxZUFpRUNhdGN5ZXlzSVFEUC9mL21j?=
 =?utf-8?B?ekxkQTYyNi85b09aRnozbVdDUVgySTRzRFdJTkN6U0MwNVhmWDRNZHZuT2Jp?=
 =?utf-8?Q?QcMgu5FXgBszVLQRgqT10QvZJ?=
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
	+i+kHhll8HMiAMU+TD1t5zcmFHNZfHKlFMSgy/IsrVo1xtsnOR2F3Scajz6WEXdHmCUngVGe2Rd2sT1LUAHyNfxesf+jVv4uKc/3cYSFrr3XazMFVFu2M1XwqEkxqDhUAzhRR6VO0MnbDcT8FREbLuFXnCWO9X9o7VwZO4Sz9UWM5juSboy7wBtcosnxTNyLlkfB0NVKEhTOjuM7ZqlA3RN69f1926WAcBZinaBICJj/Q4G720xrG3Ey/n3HWm8Nbfws0Lp98IK8rvOmJEZ+4r9FIBAtAEbjUHzdDdnrjffLzPWL1dezO1GjT44xmnr97qmGMLXcNylsqzoTS9VDNHo0cbZ4R6IrthumFztWkGHvm/YtpdvKgjsuHlrBeYRBShbHf1mhqCvOm8jDIQGAgKk945te6oa2oj44ZUW6sl6EDd5hRV5AIix5RxSxJWnsK59GIJa+I75xBVi/l7+dQZ/W95a/WuxLmtbDGWcDIrZRKht62wIEm6BcTPiaVdbU+DltFIRdODuiqqWZ1xwF8swnEf2J2djr+i4P3mReLPWHWHezQ1v7IGQrVlPMElNbozCw1nUEcASkUh09KTsls7Fr4/G8qtKW/I5i4X4uPt0KGr1yagm8Qxdbnnv1zxdw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aabd7fa-3d92-4362-ce60-08dd34ac50dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 15:01:25.1971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fKjbpnyBEtpYgUUnbrVf/Nr9p6vkrr6ophMX56wu0GLLKECmeAHxfzfW0Uo4ZiREKKUDBNrxzcmPk6mDtJUaPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9424

PiBPbiAxLzE0LzI1IDAxOjM1LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBUaGlzIGNvbW1pdCBh
ZGRzIEFCSSBkb2N1bWVudGF0aW9uIGZvciB0aGUgVUZTIGh3bW9uIGRyaXZlciwgZGV0YWlsaW5n
DQo+ID4gdGhlIHN5c2ZzIGF0dHJpYnV0ZXMgZXhwb3NlZCBieSB0aGUgZHJpdmVyLiBJdCBpbmNs
dWRlcyB0aGUgbWlzc2luZw0KPiA+IHRlbXBlcmF0dXJlIG5vdGlmaWNhdGlvbiBlbnRyaWVzLCB0
aGF0IHdlcmUgYWRkZWQgYmFjayBpbiAyMDIxLg0KPiA+DQo+ID4gVGhlIGZvbGxvd2luZyBzeXNm
cyBhdHRyaWJ1dGVzIGFyZSBkb2N1bWVudGVkOg0KPiA+IC0gL3N5cy9jbGFzcy9od21vbi9od21v
biovdGVtcCpfaW5wdXQNCj4gPiAtIC9zeXMvY2xhc3MvaHdtb24vaHdtb24qL3RlbXAqX2NyaXQN
Cj4gPiAtIC9zeXMvY2xhc3MvaHdtb24vaHdtb24qL3RlbXAqX2xjcml0DQo+ID4gLSAvc3lzL2Ns
YXNzL2h3bW9uL2h3bW9uKi90ZW1wKl9lbmFibGUNCj4gPg0KPiA+IFdoaWxlIGF0IGl0LCB1cGRh
dGUgYSBtaXNzaW5nIHJlZmVyZW5jZSB0byB0aGUgdWZzIEFCSSBkb2MgaW4gdGhlDQo+ID4gTUFJ
TlRBSU5FUlMgZmlsZS4NCj4gPg0KPiA+IEZpeGVzOiBlODhlMmQzMjIwMGEgKCJzY3NpOiB1ZnM6
IGNvcmU6IFByb2JlIGZvciB0ZW1wZXJhdHVyZQ0KPiA+IG5vdGlmaWNhdGlvbiBzdXBwb3J0IikN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4g
PiAtLS0NCj4gPiAgIC4uLi9BQkkvdGVzdGluZy9zeXNmcy1kcml2ZXItdWZzLWh3bW9uICAgICAg
ICB8IDMxICsrKysrKysrKysrKysrKysrKysNCj4gDQo+IFRoZSBoYXJkd2FyZSBtb25pdG9yaW5n
IEFCSSBpcyBkb2N1bWVudGVkIGluIEFCSS90ZXN0aW5nL3N5c2ZzLWNsYXNzLQ0KPiBod21vbi4N
Cj4gSXQgZG9lcyBub3QgbWFrZSBzZW5zZSB0byBkb2N1bWVudCBod21vbiBkcml2ZXIgc3lzZnMg
YXR0cmlidXRlcyBwZXIgZHJpdmVyDQo+IHVubGVzcyB0aGVyZSBhcmUgbm9uLXN0YW5kYXJkIGF0
dHJpYnV0ZXMuDQpUaGFua3MuICBXaWxsIGRyb3AgaXQuDQoNClRoYW5rcywNCkF2cmkNCg0KPiAN
Cj4gR3VlbnRlcg0KPiANCj4gPiAgIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAyICsrDQo+ID4gICAyIGZpbGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMo
KykNCj4gPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5
c2ZzLWRyaXZlci11ZnMtaHdtb24NCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9u
L0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci11ZnMtaHdtb24NCj4gPiBiL0RvY3VtZW50YXRpb24v
QUJJL3Rlc3Rpbmcvc3lzZnMtZHJpdmVyLXVmcy1od21vbg0KPiA+IG5ldyBmaWxlIG1vZGUgMTAw
NjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi5hMjdhMTA4ZmZkMjgNCj4gPiAtLS0gL2Rldi9u
dWxsDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1kcml2ZXItdWZz
LWh3bW9uDQo+ID4gQEAgLTAsMCArMSwzMSBAQA0KPiA+ICtXaGF0OiAgICAgICAgICAgICAgICAv
c3lzL2NsYXNzL2h3bW9uL2h3bW9uKi90ZW1wKl9pbnB1dA0KPiA+ICtEYXRlOiAgICAgICAgICAg
ICAgICBTZXB0ZW1iZXIgMjAyMQ0KPiA+ICtLZXJuZWxWZXJzaW9uOiAgICAgICA1LjE2DQo+ID4g
K0NvbnRhY3Q6ICAgICBhdnJpLmFsdG1hbkB3ZGMuY29tDQo+ID4gK0Rlc2NyaXB0aW9uOg0KPiA+
ICsgICAgICAgICAgICAgVGVtcGVyYXR1cmUgaW5wdXQgdmFsdWUgaW4gbWlsbGlkZWdyZWVzIENl
bHNpdXMuDQo+ID4gKyAgICAgICAgICAgICBSZWFkLW9ubHkuDQo+ID4gKw0KPiA+ICtXaGF0OiAg
ICAgICAgICAgICAgICAvc3lzL2NsYXNzL2h3bW9uL2h3bW9uKi90ZW1wKl9jcml0DQo+ID4gK0Rh
dGU6ICAgICAgICAgICAgICAgIFNlcHRlbWJlciAyMDIxDQo+ID4gK0tlcm5lbFZlcnNpb246ICAg
ICAgIDUuMTYNCj4gPiArQ29udGFjdDogICAgIGF2cmkuYWx0bWFuQHdkYy5jb20NCj4gPiArRGVz
Y3JpcHRpb246DQo+ID4gKyAgICAgICAgICAgICBDcml0aWNhbCB0ZW1wZXJhdHVyZSB2YWx1ZSBp
biBtaWxsaWRlZ3JlZXMgQ2Vsc2l1cy4NCj4gPiArICAgICAgICAgICAgIFJlYWQtb25seS4NCj4g
PiArDQo+ID4gK1doYXQ6ICAgICAgICAgICAgICAgIC9zeXMvY2xhc3MvaHdtb24vaHdtb24qL3Rl
bXAqX2xjcml0DQo+ID4gK0RhdGU6ICAgICAgICAgICAgICAgIFNlcHRlbWJlciAyMDIxDQo+ID4g
K0tlcm5lbFZlcnNpb246ICAgICAgIDUuMTYNCj4gPiArQ29udGFjdDogICAgIGF2cmkuYWx0bWFu
QHdkYy5jb20NCj4gPiArRGVzY3JpcHRpb246DQo+ID4gKyAgICAgICAgICAgICBMb3dlciBjcml0
aWNhbCB0ZW1wZXJhdHVyZSB2YWx1ZSBpbiBtaWxsaWRlZ3JlZXMgQ2Vsc2l1cy4NCj4gPiArICAg
ICAgICAgICAgIFJlYWQtb25seS4NCj4gPiArDQo+ID4gK1doYXQ6ICAgICAgICAgICAgICAgIC9z
eXMvY2xhc3MvaHdtb24vaHdtb24qL3RlbXAqX2VuYWJsZQ0KPiA+ICtEYXRlOiAgICAgICAgICAg
ICAgICBTZXB0ZW1iZXIgMjAyMQ0KPiA+ICtLZXJuZWxWZXJzaW9uOiAgICAgICA1LjE2DQo+ID4g
K0NvbnRhY3Q6ICAgICBhdnJpLmFsdG1hbkB3ZGMuY29tDQo+ID4gK0Rlc2NyaXB0aW9uOg0KPiA+
ICsgICAgICAgICAgICAgRW5hYmxlICgxKSBvciBkaXNhYmxlICgwKSB0aGlzIHRlbXBlcmF0dXJl
IHNlbnNvci4NCj4gPiArICAgICAgICAgICAgIFJlYWQtd3JpdGUuDQo+ID4gZGlmZiAtLWdpdCBh
L01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMgaW5kZXgNCj4gPiA4MzhkMzAzOGUxZWEuLjcxYTY5
NTUxYWVlMiAxMDA2NDQNCj4gPiAtLS0gYS9NQUlOVEFJTkVSUw0KPiA+ICsrKyBiL01BSU5UQUlO
RVJTDQo+ID4gQEAgLTI0MDcwLDYgKzI0MDcwLDggQEAgUjogICAgQXZyaSBBbHRtYW4gPGF2cmku
YWx0bWFuQHdkYy5jb20+DQo+ID4gICBSOiAgQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFj
bS5vcmc+DQo+ID4gICBMOiAgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiAgIFM6ICBT
dXBwb3J0ZWQNCj4gPiArRjogICBEb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZl
ci11ZnMNCj4gPiArRjogICBEb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci11
ZnMtaHdtb24NCj4gPiAgIEY6ICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZz
Lw0KPiA+ICAgRjogIERvY3VtZW50YXRpb24vc2NzaS91ZnMucnN0DQo+ID4gICBGOiAgZHJpdmVy
cy91ZnMvY29yZS8NCg0K
