Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960844C900C;
	Mon,  7 Sep 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793040; cv=fail; b=QIL8rwDLlBxQdMfTurdxH0/hGAD4M5vGH27XPMsGoLoo3nJRbZX1RfwM3eZri2H+r5BJvXJ4V6Khz1QATZ0lcFWIMUo9D4Wi23k2sK6DinLUfEix5/5Jmz5zT3fc52ZStqiZk/+luL/XfyjSWXGABPbBqPzp4b8ZAL8XxKp863o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793040; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ulshNuWcHVeolrLeXs77aJkV4tZ2DEpTWLtHJpFZJbvxMvXQyqlavHqiuDYNjVHABsfbSR/P40Qf9koPrYFhR0Qq6cfKN0PxozfayWER7KPZHpcAyEAAjthiLKjRFx81xII9xqWnfsBTyyb7wqX7NtKsjrNbdkqYyQMm3mY1c8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KObqqQAf; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=du25jjAc; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KObqqQAf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="du25jjAc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788793039; x=1820329039;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=KObqqQAfRhYVZXxYec6Ug3jmWR+5MAQSxSuw6SEurW3zsFZIMdYApqWT
   HQl+wdfGn6fTxpR3NkdqLnlDtxnXMlwicwRJ/eXVAKfYRAhnD6yzB6do+
   AlOgG/MdsmyNxSGpkj6jfCCb50YpH/GgtPFOC6fMBeT5JLa538LCGb5kY
   IXTF/lpp1wL3VxLYfwTQf1XwpHQ7VlGSl60MViWP31jct16yE5VuXIdww
   cJdbn9tHQv1ImL0VG0euXyKY1SCw+iRPc7XsiZwUrBrgk5mDyAiLWxMcu
   AeMsxLGLNsEn0C3JlCMGDvo61765U3kfekGnczCO+OwVNQnjP/uTwvclW
   A==;
X-CSE-ConnectionGUID: 1T4Lp+rVSx2GO6YoZGTeJQ==
X-CSE-MsgGUID: uJveRbwTTgSXmONs0nf6FA==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="155128647"
Received: from mail-westus3azon11011049.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:57:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SOAIww1SEEbeDFdpLiPaf3tz2+kj4C6baKCMMcQEXuYM7FR162cZfAft0tumagsUDcLsjcFeObbxt59QloO+xMYDww6thD01AXazeTZfC0b0ByGuwA77Zv2GGchBNPRbinSXo0v23LhBmQJfcFadXPTkJCw4oVcnFKvKsmBqWbqae5LtkcDvRaJ9EZXQSMec48djehT6KRld9nAXQkWpy/vsQnnK+Ka/W1+oBbKdCH5tpr5giKnjEtSwg7skdbAbNn2XjtN4arFwk2gwcz54/eZFFDj7V/bijanYaKW8eYG+Gu70lUU+lUiJ9vFZgReGbDgyK3dFSgoppbz2KW3HZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=eleCUdGSKMUGoWzGXV23iAlL7xO/VBbqzlkBcmLsgxEjvsgfiZIwth3f8tUDPsFcgIjg/MCnVktvS8TA3H9WxpBTrNTgDFP5OqkDYerRMg62+4jzLlQwnLdxaiOnsKN/CvEzGVNT7LImV7Y+gOgJnbfHPwsauJrrvwXsu87VqmTUqxj7+po9c220Kclj/0rVJwnQ//VGFzfII6aWi8lQ8NjORa3hkGDQL9uWjZ9ianyBOXmXLYqDDmmxfLTgPeUy6+hjsNUOfUu7jXF1v9g/MyQzJFjRVsGZrBW1NIKunz77z9jNMpOMeFxxlCPpXdSfYu3c3L5Jf04l2vtRvypuqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=du25jjAcgelG4i0BluTEYLJIyKTxX3BZYpoGdkOWu+Q9Ne9p59VT4+oMxAfSPRaYBBtfkzQNa5XWjMYQXgz/5mOcM7srOcZqAOji1AVehIcM2hvRFAFDSOjMWiwW7aLQ8dyrknNazrTmzNpo16n8eK/o6LRy+JNCCsUQ75WxsXI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB7076.namprd04.prod.outlook.com (2603:10b6:a03:222::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:57:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:57:15 +0000
Message-ID: <a4fdf4d8-a8ca-4a0f-8ba2-dea84e33d99a@wdc.com>
Date: Mon, 7 Sep 2026 16:57:10 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 23/40] scsi: smartpqi: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-24-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-24-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0165.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB7076:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d0566bb-fa67-42b3-18bd-08df0cf04e31
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|19092799006|921020|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PcpjTcQYVU832nqSDWpFgpkQ2D4y6Z/Cf7NsTu32RYDRyXGYcEkfDXcbu5M3IzJRPJVJJ0X+qUNj4QA7sFeOCCMkxzYfUf9m9o9X/DpbV4Puwj3pcpqO37zAZLHqoa4gK78nTOVu4m+mjHY36ygvPyJgyp6kaS3VCrV4qwC7Eet5QfGb1WCBK/v1fTLRhiEDvYiNqpop2JxivmcXc6PBDRFwhiDc2IUsMC6WV9KBH7XPiJkAV39Lx+SGYAD4mw4vc/4TiAUXt5IcyVHFXyT48XvGDyEmV1xm2kQmQ+hAu6p7v8yMxwK9pAAH1kChV8JcFd1LOupFTYIZonKZ6N2oP1g4dzLB1HULg2Y8FwenYpNZZK2W8NVhUHPIQ+61IVpTUXEQQtnHDN+rdGK/cUDCHa73V67xo7JWbaSEZ6KDMlzvsv/STYeF8gCvUZfJZzt4Ph0oi2EYI2bxkkYhGoiBGYDoqnZ1Q1FynhGQ9t5plgpyYkerwTHrtdgsYbKWSxdIBUxE/G9q9DAys/Z8u4XfNsPnhCEJEtsev1i4SvAPssJOaETMqSCoFJpMRL2hPpIMPJtHQdgA3U2PxLPjnJC7c6g1NAMIf5EZCyGYvqE0d8nq0iys+r6RFLw/s9iMPVAPt4naFzsxxDOL9oXkbG70VkSh4lTvLM3x0reeBgV2Ru3o+ddfEX48zQZpAYrjt3qUSP9iRUpBJ7HSFPlAMyfT/w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(19092799006)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elhQYnR6WVIrVmlaeE8vbnlQaEl4WkowOTgvblloWHFDWHFXaEdDalZDMmp0?=
 =?utf-8?B?aWR1NkpNOWJqcmFGRExvTWZ5dUxVYzdOb0pvZmVGMjVBOG9MS3JLTHRoS0Zn?=
 =?utf-8?B?eTMzQXZSdHp4cngyeE96QUEvejM5NlpMVVVxZENtTlcxYlVkbDRFQUk1N2ps?=
 =?utf-8?B?cTBFQVBNdWJPZFJPVjB0NnhLUUFOTDJ0TmRJN2Rva3hKTUwxMVZ0TG1PRXhG?=
 =?utf-8?B?aHlyK1JsWXRKMG03L0FVTll2bWJZMUtjeHlFR3RMb2VZS0FhOE85aGhhVjJ0?=
 =?utf-8?B?cEdTNUZybzR3NnArNTl5Z0JNTFVjOXdVaEZLUWgrcWpjUzNWVi9FQVluNGdk?=
 =?utf-8?B?UjhEZXEvV0dtTVpNYnd5c2orYURWTFJSNmFzNlJwSS9GdFVIM2RQc0pEZ0lP?=
 =?utf-8?B?UkM1OGx4RnBkM3hjbG1ra1VacEZkdHBCTlVZZkNJd0FTcVpaQ3BBTmRYWW1G?=
 =?utf-8?B?VGRJWFkyTGpmekQ5WEVVekdYMCtGM3Btd3BEZGVDTzBJK1kraDlQNkdrcHJN?=
 =?utf-8?B?M1VjSS9KM1VwOXljc1RJZGdUcHorM1dhaUIvV0p0OXMxTHNSbEdXR2tsTlB2?=
 =?utf-8?B?eVRhU3YvZDZ4K1VUd0YwQzE4NWRZRkpEanZpNWF0V2RMRzlMYm13MW93SzZV?=
 =?utf-8?B?YTBWdXBYaHF0Rk9TS2puSFlzN1pWQ0FYRWRMNyticmlQT2puSEVMYk91dndk?=
 =?utf-8?B?MmdHZnkyaDBPMHUvOVQvRmpWczhDRzRCT3pESHpxSk5BRWFWaEVnK2xFaGh2?=
 =?utf-8?B?SERQY0s4RHVqUFlTdjJIVmtnWVhFS1hnamJJVVBIbVJSblFBUUJOaCtSWUZr?=
 =?utf-8?B?Ynd1NFdDa3R1bWJ1VjY3bG54UFM1ZGVYR0ZrODFFK1lLYnEySHY1b2lsZjYy?=
 =?utf-8?B?cGhNRGw2MXdSMXNha3lVclpXYnJEQ2k3SDViYTRhWTNhRWdzTkxjVThqV1FP?=
 =?utf-8?B?UTJxM09kNGdoeUlDbU1TQnhKWEhNa2lwdk5ZbEhyYXFZQy9sNGFseStDYTJU?=
 =?utf-8?B?WnIrTmlmQ043SDFaNHh5Wm1ZRVZwcThLZVVRYmhjS0dGWlpJNGlYWEZmRlE2?=
 =?utf-8?B?SFhXcnZmV2Y0QWlFY1pISW50OWVBMlBIK1llUUVndmVMNVF0T2Z5a2lxMjhI?=
 =?utf-8?B?bkpWQytKVjRJbitVcVpsNE1KSmpXbUh6VVM2ZlZua3BhRXZxYThyU3BEMXgr?=
 =?utf-8?B?MW1IZzd1NHhOZit3c0JhZ2ZFVFVQTTJRNzk1TWRtcEZwMmFNNE5TU0piN3JO?=
 =?utf-8?B?Q2ZocXE0aVBZSVNCbGl0bTZQWEh6UmVyR2RZQnJXaEhiNVZQUzc1Z0U0K3RD?=
 =?utf-8?B?ZURwRVBHVGhoNlZDNjlsWXZza2JkMFNlYkYvNHZYZ1BFZndqdmtVVUtQSUpM?=
 =?utf-8?B?aEh1U1crbW1CemFpcTJhczU5WEtudmphdEE0eXU2N3lKaGNvcHF6MEtKdHRY?=
 =?utf-8?B?VUd4b3pXSlgxUUtkTG1KK1lLZ01QMnIzOW0weHh0bmtOaWV6VVhSMjNnWnVG?=
 =?utf-8?B?MTFwZXF3b2hNOHJjaUtjZ0VmQUVNMXB0OXBSVTZNWjRjV0NSNFlhc1VCV2ZJ?=
 =?utf-8?B?N3dvRk5XVCttOXlSNGtwSGVlQ3M2U3dWZW9GQUFqMEdVNU9tOUNyNXdKczNM?=
 =?utf-8?B?UTNBdUhuUDlyK3ZoUVRySEMxWWY2TDRGaGhWZkYvNjVQY08rbVlaQ1c2TElL?=
 =?utf-8?B?QU5ycnFXUllzRWtITWJoTG9ISzhBK1RLY2ZpMXNiaUxKbFBCeFlEWk1xQlIr?=
 =?utf-8?B?c2t3R3lvZE5qUWlEb3l4b0lsL3Bsc0ZMZ3VKNEFXUW9tL3VscFpscGVqRFF6?=
 =?utf-8?B?WFZnTlMxSXZ3WjJEVUpNZXRWRkNiV2dneVVDQlpYRHFIN0NjTUJlRUt6OHVL?=
 =?utf-8?B?TW81cGx3VmhoRjJmZUZCZWVMdllGSEE5UEVSTm8wai9PVk9JcFJ5TjllL3ZM?=
 =?utf-8?B?aCt3amRPeUNGM1NSc24zZTJoSjFqZG9NeEVLOElKcTBwNy96c2tQSlFOS3pN?=
 =?utf-8?B?TG1SeXlUdHNGSTArQ21tV0c0c2dILzZzVTIxZmJ5enlYRGlDdHREM2R2NkVu?=
 =?utf-8?B?VldrbkI1K051d2xRblk4R2JMcEYwUWY5a05SWU1rOGQxRDJKMlVTTVJJdGsw?=
 =?utf-8?B?YytabC9TZFc3U2wrUU50VUFJMlBRM1RSUlplUzI1U3phTFNtVG5wWlpoV1hE?=
 =?utf-8?B?QnRXMDNxcEY3TnBrWnhxQzN4UHdNdE5VZWUrcjVuZSttRXd0SWlJcHV1b1VQ?=
 =?utf-8?B?NVA1U2VzTjZNd0JlWXNaZDNrZjRKTGNSRXdKRHBzUC9MVTNxS1BQMks2M3k1?=
 =?utf-8?B?TWxRejU5VG5sbTV6UjI5djNsOXJjUU9Za2YwbW5WdS93T3NxdFNldEhqNGJ3?=
 =?utf-8?Q?oNTXrFG0sQZh4uXc=3D?=
X-Exchange-RoutingPolicyChecked:
	oI8nWrAoC+a7N6GBfU1pHEwibzZ5xbtSEkc7Qb+ywHoHuAP4X412ZRYM9+EKugawFWZhXs+7GaOAm5pVd4mEsjkrdPTGgD+eHfL4x3JYNM5iQQLl9po+rh7Pi1xKZ/4zYwWNusnL+0yQ872qCGs/QhQeKx4e+xRSLPW/5acmAxZ5JrnJK4fDlDB48xO75aEskJYJQHkPmd+Pm57xwqmjywOnpuTTsGetbGu2n4R+3OX6UJyH3PhoKvhTND4WhvoqrzHdzDIdiPikC9pR8fnoE6LqrctFFnnFRfHyscO8+pnJCwsQVh2av/K5r6yVJv6dpLqBHLPQZ5b3J0l3g7y6zg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BEy7S9WRD2ZDdq33UhTKyls6Ew0AtBUoGbKC15QlalggcUGBkXCr3erZJYfALX7mzsJhK5CPJ3xUcADSTI8bzEkGfiB4VyfJVOJQIx5fGHRhndbIm/iWjiyWKaAWa1WWhKsdDou7icyx2JOwe/q7iPBdRXgsVKo430lxL3/+W1+UD2sKINLf4eVlG5zBE5EK8fQP9BM+ocfFAvJIfGpSSC+OtdgUc98QhCKbhb2xgaCmUJkOXRexCNoMqbTzK4kiEpySgkblLGKDHa+rMykhTv6w9Z7dGNK768TU02worMcDO6WhvfkHHjTIj8zF254JqkaIDzzp0B1dGk3r4MZf3UE8GrEtDrcwtacKaMkKeEPegQVxn2WmrVWjXD7W0RxtpKeD/9oyAi47uaOdKrve+i09NVWqmYw1Bg+4uhMtMRw3CObhVK3lvLngMkxPsHOBYbMBs+P8AJB8+eNK0VQs7CQuRKARlVRxu5noP/yxzuJfbXk8WIE8Ut01/D28UvqUh9MItFy3OSVgKsBX1k8/yR890tOMnyIH3m4JyQYEutaRWWx3V9zzNmYEOKvDTz2wHfKf7HfYhQShsRuTRFgQ2mytBHCR7Cb6Pkcl6GzPLn8UMBUCNRiRhgQD7jrzKZ7p
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0566bb-fa67-42b3-18bd-08df0cf04e31
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:57:15.5784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKqZZKA7CD/WMCpuJOkRjn29S31BijdndelPbHrjePVCAUGxZMvdqFqxGgiRyrqY1n+wZ72Vz24ZyzFQPCZQVqOGkiq5e6iMsGuD24rSbg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7076

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

