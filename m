Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927014EA394;
	Mon,  7 Sep 2026 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788796766; cv=fail; b=rdr7qIG4Bcq3kwlNdpe5aUa2tdHJ+4lZqrii6RDEGTf2woNr/eaQxWX7aw2dffSjBHZxtC7w40qt4w+mGP69L7Vm9lm7uyeThX1QnaoW/rrz/z/gGhWa/v7cVTLnlGiPKSSDWVcejC3kOSacFMTqKp9usRYuw3RIpw8Vlr3YTu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788796766; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GvoBnapX4bgi6g94ZFB657el8FoiWBLUdWoXivG+FSwoOzvNJYZfuoRj9gQvrXz9NVnvHRTdBkzNjPIJXDJrrHpmGqlAxDxJrmdeTDZuR1Fko7bOsyRvlC6nkUjtP5Ka69DQIkYjzhkb5Q/s9LkOUCqRyZkW2HZl18IuLlGKqQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=atL1vShG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=sTIZl4rl; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="atL1vShG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sTIZl4rl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788796764; x=1820332764;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=atL1vShGjgYI1rDcegkhgnhv11QNT8m2lMdSz60jK3CzgKVJOR3Rx7hW
   zasCz7Br3/+eXoyyrAgEEAcLFkqJVUVtrgfWPD/3f0JoT36jhJ8Iwsy8H
   X/qQY2VJ5ocegOimD4OtQQgz8pfLf0Li/08u7d535mOfvAXLInD6nhZTR
   Ps8a8mO58hNE4VHDhreA2Xq52dEgwXk/sNVubY6+yfNXqsAhxrpctiLJW
   KpBB0aiTpJcx5AQMEaO9H735nNe4tJ76X1t4uhnYIW8lUiT2ALq6d865K
   HnwttY1KgU7dOTLO1Tc12gjh11rgDe8As9eeqm+gFQ8mvCpTcNGz0CMz2
   g==;
X-CSE-ConnectionGUID: VFGCLR9mSJWX5556/XXgfw==
X-CSE-MsgGUID: WPfe8MRSQhGkn+upYjZflg==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153549198"
Received: from mail-westusazon11012048.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.48])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:59:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LQY/JbahVFb/ULWntDra2m2iKFRTSKxaQ+x8nvJ2KZ+9nxXJZqNiHMEWG1cIGev3vzULVQLvMk+n1bk3MQP11LFvaqqYfGezA5iWvNjH4EYp4uZPnga6PbOzWoPIFcHEv83coFMLWZL3Y3cg6dMg9xlDZt7SUGFmErBKAx2KC4wR2kveeraeW40l6LfAQNgfqzTUhN3RJnGNos7hwk5fDYuNLqY+bWDt/1YUEkHP6ZHBJjVBOcojFV6vk61dWfwTHss2AYYSZqhvalpYuG1K9OE4O4YgRQYXCriOWyGESY/QC6tOkk5ZD2jExg+nKE02n/1RtlR9VLFyGWHCd0xACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=wTyY5e4Ea51zT6F09Tj6CMubkT+yaopOtOpL5c3BvBtFAFz2/r3ieg0tnskN6Y23B8jOKraaNZN5jhaBzndTVq30BNGERdsnvfcSw0Y478or3Sdlsza0ufLNjwQz/HNQR1N8Qj9toef0uLnLLUpWKkuOdpyY25Zzr2XJ+pXUGSncoPd5yc6YVHeDkHyvpzSwhcV/GzXNFQzwksIDZBPN/q20yHf5eRhPEp0v3ru6kQVNyyNFnSviDUKqGXuNlCvmirm5hBiliOy+nRh33ZWriCGE1cMztS7Pf1Y6EB1YzKRXanhvs14i3cNf7hPM0DEvjrAp5mpebhHPmSAOviuADg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=sTIZl4rllgRUGPuI+mTQCw6tHdT43+RG0yi6VLANlmqQ6L9aKcZ/a20TWa+2/hi78wn5ZHmJiGBcKpmRmiu25viXSJ/RfI92L6jIlnFOtnpvyGuGXrzlyJ+lNeaL3xGGYYEBVhLK8qlXcDzPv0HN4OStTX5Hd5fODZgvZIbcizY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7470.namprd04.prod.outlook.com (2603:10b6:a03:2a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:59:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:59:22 +0000
Message-ID: <e01079bf-828c-4168-9319-8bd6aac23293@wdc.com>
Date: Mon, 7 Sep 2026 17:59:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 33/40] scsi: storvsc: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-34-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-34-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0383.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::6) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 88c8c9bb-26c3-42de-b72f-08df0cf8fba3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|19092799006|921020|10067099003|11063799006|4143699003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0gUxaV62g5woQCnjefApYPhz6+fnSCkEEBeYQ3Hv8TiWdTPMU9F6nOni5KbEi08D0opKnylQZS3g4D6rYtT9xrIvgYvV9AJWbhEpz38hdRk9IzFeASHC/zLM9cU96mcPuJC4yy0xXu1Q0jnnV/wLj0GBECi8act17WM0DZzKgTXwnto4dQKqVAqY9LkgOhNNMe4ARnYuzkN3grLuTrS7he9ktBKtXrX6ksuQ5IiRTV1vSR+fm3ZcUKa4rs6VfHlumOWRE/t+f11uHbvbd8dfyr6kNEQJrJJtvsFZ6kg+4/bsW872FDVdq/riEkSxryn/2LAsG6nUONovUGJ6SujzN6NY6XMeUntFyYrtRAK66ag/uL+krcBRCcOpCEQJk2GNahGtfordZ5LcUySd9+nAeTriZcw7ue15apV7X2ZLissWSNO7Yc3T5by6sY01PRttnkQa64ftXfTIVZMCV0SOntZOBc4NREnWLXPLA+IMN2dhJYmK5OFqpTD25oofuaDP8zCc/rbd5Q3wpyR7TWiyb78Tj78PvFZQ1lbK+iQ2/hOI+m8dsXSkMQor6pXZgUTNEumlb4Sgvfzl66dTS6nRwVGKRFqx0MkTBlckG2DS/0M7++jzgg6R+Hbr6u6VH8M1mHqdcxsQ3K/7XM4vaPOAy/ZvlrDyViYcaVfqrPbYvqpPUcAojNU9wOPZ/bC1ZhnacQbaQegOfZkreA6q/zWnqQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(19092799006)(921020)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEhFNjRKaldXc1IyNzBDUDNZbE8zTVJBbVBDeU1iODdYalp5akZWWWJlUVRT?=
 =?utf-8?B?M2oyMGlEWllPazhjUytrN2YvN1o4NWkrYXk0dFBXYXZXM1VaVC9OYnE1WWRD?=
 =?utf-8?B?TFdscTdRcTdTM3AxZC9rNFBvMExUd09nSS9EYWRpalo4MXBHZTl3azBXR3gx?=
 =?utf-8?B?SVM3YktIbjFBZU1pLzhHeFY5aFhjOWVoMndXUVE1d3ZEcEZNQ29IY0NSQkJu?=
 =?utf-8?B?SWdiU2RkVGJ2a2hFUEsram9ZeThFK01lQnlzdlhwenpMTG5wL1M1a21SVGZT?=
 =?utf-8?B?aE5vYVZqZ2RHa3dMUnY2RitEZTduR1RUeFlTUHhqZ1piLzErckhuQWNUUVVq?=
 =?utf-8?B?RVFtUGk0OTV3VEp0YWZtRGdiVkxVcXE3TEJrajYrM2N1RC8vdjdsblVFaXRH?=
 =?utf-8?B?WWQrcUFmaFdCSXdRMzhRNXBXLzM4dlgxYjVyT2huYlBXUWMvSWI2YWVaUlVQ?=
 =?utf-8?B?dWhpMCt1aXlhT2paYjJ5KzJXaHFPVEl3UzdPaGVXcDMzZGd6bUZmYVcyYUUv?=
 =?utf-8?B?dHJua3V6UDdwRTBXMjV3THdwS0lsb1BBdy91NWN6elFwU3p2cVRpNG4weWdY?=
 =?utf-8?B?QjFIYWJ2VEtNcnM3MmEvS0Vmemx2UkJ0dUtpajRRb2hNaG50Q3lSVWt0T2Mz?=
 =?utf-8?B?T3lwZWxLdjNZWTFQZmNpL05UOTdjNkpvYldQYUlqZktvVFRIUlhDWVl6Sy9h?=
 =?utf-8?B?clZ2SUNSd1VVdndUWmpsSElkSFNrSUZvRjRYMGVHSmlteWozVHpTMVhRU2ht?=
 =?utf-8?B?bWlhdFJIUWdLczlCdE1qWWNXeTRCWGN3MVpLSGEyV05OWk9ydDBQeEZSbFdY?=
 =?utf-8?B?b1RndmhnS1RKeEpjNG9NdUVscHFiakNmcXc5S1BubEprTWJOV2RwV05iYWxk?=
 =?utf-8?B?bU1MY25oRmxQUm95ckJ3OEo5d3ZhOEZBVmFYTzJWYlc0TkI3OWtGRWs1K0I3?=
 =?utf-8?B?SHRLNHcrV3pqbWg2T1k5WHo1QXRoYlNiV0hIWm9xemN1R2QxdmJnbFNoclcz?=
 =?utf-8?B?Z3JSRUwzMG9yRGNBMzZ2a3NYOE5KaTNSTFRwQ3ltYmYraDVhZDNFK0d4enkr?=
 =?utf-8?B?REp4Q3dMUm5UdnJaVDhNVEJ6UEhiY2dPV2Q5R25rdThWOFF3MTBGakYrZ1RN?=
 =?utf-8?B?RzJhOXJJcWZ5VExmTnppNDV3UExkTGx4eVFsUzE5ZlBTcllOdCtqSzFGNXB4?=
 =?utf-8?B?aGJHZjg1MGlqRHVIM0x4ZVZUUVJrZHRhTFBhVTNIQ0J2R2JkaXducEhkYUgx?=
 =?utf-8?B?bndhcS95TE5WWWd2dkVhd0huZThzNlV0Q1dRZ28rKzd2RkJzdlNRSHB5Tzd6?=
 =?utf-8?B?cm94ZnhsS3AxQThXREF3eGUwTzRjRjdzMGhOMGp4VUZzR1ZIeEk5dVBMdlYz?=
 =?utf-8?B?bHd2Y2QzTmZrb1hITlhMOHlKQ2R4Wk9GUXZCeGpFZXRUWHFxZ2xsVE9sZkcw?=
 =?utf-8?B?d1Jwc0tMUGRNNUxReldUenlkSTZzK1dkOVVpMTZyR0dubEZ0clhMY3N0Tmwr?=
 =?utf-8?B?RlRad2hUZTJiNGdVTHhPaTBydlZYVnZhU0svNHNyallHZnJEREd3TVpzZkpS?=
 =?utf-8?B?TEpUVFBhY20vY3ZBM2xBc1BOb05RbDhweWZDNzFTWE1ZNnFMUUNWM0FGUkZz?=
 =?utf-8?B?aG5oR09LWHo4dnBNUHFNa0xHZVN3V0VDRlJscGl0NVp6ZndGQlJEYXFrYnBF?=
 =?utf-8?B?RngyVkhWcWIzeWkyQTA5S3lTMHdmT283Q0xldEV0VmJJcDA2Y1d6MmZvdG80?=
 =?utf-8?B?VWNBejNKMXNucnZXT1hnM3UrWTJhTjFVOE13QTJXTkZpanRNNXdGV0o4aTUz?=
 =?utf-8?B?ZE5nQm9NcklyZHljZVpwVkh4TkpFb3VSaHBGSHhPTTZ5dEV1dmVPTEp0aGIr?=
 =?utf-8?B?RTgxemE3bTNkMWp1TFdxeTlyYmRyY1IyS3hvMExpK2JRb2h2SWY4a2FaTFNN?=
 =?utf-8?B?YWxxUmV2ZGRkSlFad2hmYW5NUWgwZnhNMXp6cllNbGFYTE5EQmJDMndsQktX?=
 =?utf-8?B?QUx0bXd5blVBVC9tYVFQckZlUm9hdWp5MkxzL1ZqYjd6eVMzMFUyWTVNUnBv?=
 =?utf-8?B?WGpNUFZ5ZzFXWjdoRTBrUjhONU1LUXNVbXRiYXdQU0l4MUdCd1BXT0MwS2tU?=
 =?utf-8?B?Z09XRk9Xd2hmSExneVFpVjYwTTN5VnpMUDVjcHdDSU5kVDI4NFd3NnpPK1M4?=
 =?utf-8?B?SDZFeWZWYmxBOUxzenlrTTVXTjF2ZmxKK2o2SUxiakRNKzJsKzdVVFFBUE1N?=
 =?utf-8?B?TTdDYlJCd1ZNZDJwd2RUaGtFdkRpZHFTWWY5K29reE9kUU9KeUsyWS9neThv?=
 =?utf-8?B?Zjc5NzQ0aW8vQ0tCV21RTXBBVnA0Qml5K0hMM3FKNDBkOGpzdnhHWE5GeDZI?=
 =?utf-8?Q?M/nao6h/RYgE1AvQ=3D?=
X-Exchange-RoutingPolicyChecked:
	OqzQ1l6rxNb71+s/8FhWbz8hrXnnCgVrgqoa37k/ap8g0joyxsGn/+6XFGmlXupKl1Alwr4s9eQAl1qHpQZnqpDydnFgtxBGe2JAzUR693aQU39homZU7Ht1D5gdrZ7UpT3yxgeI7+PO2m7eB/krPnnUunigxfDbolufD6pp8+dewrZDeboCO2XgTwM7LoIiZq00QVWMZENBjj72EE8NETlrbcWLgGwKI1Yy6yRMxKC6Twl/hreBbG7mlDH5BxY7FSu/TRajrbot+IKwrpe6QggXNaGRpcutasSbfpfKkwISKNnCQ/WRCgYQ4QS/BE07i8AFpD0ngV8eFY6BpkGFQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hNSH4Aa+qoYob9PAPLwkHt9lli9UOC6Cw38w4zQeiWgT46gBSgO3noNRM6fNNBjGiyLPP3FYTrn92hTaWiMOpQBYZEOlIIiwWsilVC8Wz5o+mnC2mB2xt7Aw8mZGiMwME5AKR7DH49p1nhlZOE3wOy1hJ546dkOUymGLHrXHWFbIkADB0m1rlxfDYiCsSuIeI8/gD7y6RhrYD4QDeTq7N9UpuBce6bOjoc2lFOH22n4+EeKF6nM80Ttqv/Ni74rGneVYnAT4TwhUwVwGWcG0CPzfpjQgL8ydwwQGsZqoDDbjZpdGjviy15ZPGZcumx90hiKr22C2sbgvA+8ifgMoE+4XmBQysRV3PLn5v63S6yo87s/niCGSKK+LvGIkktGT4Fld2RffXm+FSAzzGFej2zpGu1NDCgJqfQg0rNzxLM1GhkY+cV0ek5R9e2y7aSj3rRu51NR+kCDyhXqFRclJoz1GQfr6tCy45sLVyByFA2lj9+OCHuXSsFyn1i0udCxf6xCm+fESH8mZIxu2bExeu7MLvHB+iemBW7Ojw9qSspqc+C13xGsTkWRZRqItKydaM5zpYmehCCPWmiJjUgVwloi3Wda3E3O/dGP5Dxy9ljNflDupdm2wI+BCl0KcAHmE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c8c9bb-26c3-42de-b72f-08df0cf8fba3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:59:22.5402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SibYtFXcVWH7Wd1OW5plkoTjwzrddkq3akxYw08WcPWFwzySlD8D123NZ2x9liBZnWOVh0TTcjW1cLDAp9paP/k8enmG/+GjRYn7KqhaKcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7470

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


