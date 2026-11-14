Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794634768;
	b=5mL1sVmRrnTzJbHLDOKnPh6W4CrZHccm9cmwAmBcyjV2y2uH2PeB6WaPXrfy2RQz+2aE
	 S6lw5m7iv86hWz1+Zj9ckyz8vtTJUkoolASomqD90ke2xIR2X5Nim0t0BzPlJEowV412X
	 SPNwCG3zFWIutCshq/sGOpQ8ATV7qPCKwJM9IUBUZt5bHp6+EszMb38Oy7NzvM6+64ols
	 TW9pZljUzw0CcGADWgnIRxes8Q67o27O1Kwk2H+uh7YRlvtEGW9Gng0PMicCfos1hcBcd
	 D637wgetPxrhiokiSTe6+E80fpo4tYsVIAZ5qNkqtSzim3ugprtSLk1MsbjWnLPkadg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794634768;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:
	 Subject:To:CC:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=66UaRVS9teJM1xSCIXzi2VOl3r2uXhaB1SlGyHwM+5o=;
	b=TfIlcFn6gAqY6+SxJTxKWXgUzgPSl3cSxEwsM1fh5JBRYZggmbpAiTUs4bFnG7yAEf/3
	 XchMXGsQcMLPUxp3y2U31h+G/CrYxl1eqs320swsFSPIP4WIzUpFXmMpZgrjPccQOUlE1
	 Tok5y95r+sfPWO6lznQshMvCo/H20QWB6g4bofsPvmg85O1/kLILeRAMcxqiaAA0dOlO/
	 3FsCJolz0EOIqaFRB8ao6jwR3EC2XkMxudDmXUIlB+MkXAg1fFqrt2LiR+ZzoKqwYKbjU
	 AXrg33KP9nTRPCWJOETWNEAtkWLH0RIKvfxpy9Jy88rX2h/BUg1uNccHo0/OANHny2A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QdKkcY8c;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b="INDR/7Ts";
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A62606A323;
	Sat, 14 Nov 2026 05:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10A62606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QdKkcY8c;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=INDR/7Ts
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794634767; x=1826170767;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YsEdB0DicvGojg05Qaz8F+EsbkWQy5wuzObmzp/5P8o=;
  b=QdKkcY8cQwMD78B9HYKStdiJHvOLPUPVumTOrohW00l+b4KrXh/gU3vs
   spuCqDNSZSpSYfgOmxxXFGv7M8yVzS5z/a7G0/2cKjw0zfkC2aMvWicRZ
   QB1kXeXZGSZLEd5ZBRebabhTWdjYRpVaQjOndt7PdjZSNjz0on/ZzMyis
   VkN5PBoswc8YSnBhDAXJlwlrO1lODBOrEpEU9pngSF+yjc5v1AjNNJLvx
   ib9aTilWzMIX1eZCiqJcRYM0ZM1wbOo52pWabZ8s43jjm8ggjXE/UK+1d
   I9lIu81egnvwQrzmqd/DnbRVkT/onm5d/vs6FppkCjQlMwW4dHoxQ8FL2
   g==;
X-CSE-ConnectionGUID: nAzBHG50RFCIwhhf4aZpVw==
X-CSE-MsgGUID: NSZz8uRbScKGYy2EGkKaWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3479348"
X-IronPort-AV: E=Sophos;i="6.27,213,1787036400"; 
   d="scan'208";a="3479348"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 21:39:26 -0800
X-CSE-ConnectionGUID: gQcP54sGT3u4cp5DZyKFjg==
X-CSE-MsgGUID: rXtE3y3aQ/mHyXVJTTWBeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,213,1787036400"; 
   d="scan'208";a="9099184"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 21:39:27 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 13 Nov 2026 21:39:26 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 13 Nov 2026 21:39:26 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.52) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 13 Nov 2026 21:39:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=el2zuYjtmDHsTU8UH2c0xp1S52/ZmcgE/Y2M2HkNo6zWgUUTNcaJK1NXDxIGHpKIftJ2nUt9RqIbLS8Bm1x0iXLiS0vl9+x2NvhJadcI1T+Aoo3H9OBHpiTvpzPSAnCku2ieWgSeX7pG/NCcJ440yXfYNEex16MNWg6uwBOquyGu0JLSwUG6EzZR61vaO6+PikUqvgqUbLbbrZvDk1YlT5LQQtAgu/RRtfs/3lkV5tUqEj1EYrPpjHN8Rc6KHBLkdcFa4bvpk3oixe+EWBc1V82Uk8Z63vHP7CDKOZoNRXGS+i8wEZa7lhVsWJl6fJhXe4Zpr6zNUqGnwSE04s0F4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66UaRVS9teJM1xSCIXzi2VOl3r2uXhaB1SlGyHwM+5o=;
 b=vQqd7fm4h5wkd1YUBzSCXB5SV9hmqgOUHnOvvQa7ZJDR3hjIhTDVQ6Jul8iQmbX8ApFsnVN+tE4vy9rWPJuqxTgfY+nNLyMNgXQnZ06HX8SCi9PeRqD0XICr5N8HxAeIJgTkAD+K0k4axauf7TsBUqbd7BrFJbxS6HPP/QvMuR84yRRG82QzUXTHtO1vaFMye7VyYRZ+AfI5bUf/humCIebjxMxy69ax+8tqghLoMr8pG2l8MMDW3HiscJxWYFwajZqgiz3gX6uBcif68bx7vPX4/eeZ5wO1cBB1vtEL4QpLH1JiGqa9UiKbDM2db9L37oXQsiTKfCYvZXsOkseIMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66UaRVS9teJM1xSCIXzi2VOl3r2uXhaB1SlGyHwM+5o=;
 b=INDR/7Tsdhe1YBT0oX7vvlAGYzA3T9hL2pXjPKs37MNNQfKP8hStPUFQT5rRCxyL1RMHz/QzVqtNzQN0/Vv+cIkfggpVe26JrdtIoPN7U//Eg34iqJW2Paq/icA9mjMaR+07W6k6FeWSWj672RtnCDxn51/iLh9v1wRnG8SLA2I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by PH0PR11MB9522.namprd11.prod.outlook.com (2603:10b6:510:3b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Sat, 14 Nov
 2026 05:37:19 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456%3]) with mapi id 15.21.0615.009; Sat, 14 Nov 2026
 05:37:19 +0000
Message-ID: <02d67da9-13a5-4e38-89aa-30de10df85f4@intel.com>
Date: Sat, 14 Nov 2026 07:37:16 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Check hba->vops in system PM
 callbacks
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche
	<bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, sangram kumar yerra
	<sangram.k.y@intel.com>, Rajeshkumar Sambandham
	<Rajeshkumar.Sambandham@amd.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20261111084853.3530107-1-stanleyjhu@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
In-Reply-To: <20261111084853.3530107-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::6) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|PH0PR11MB9522:EE_
X-MS-Office365-Filtering-Correlation-Id: ceacc6ee-6259-437e-6182-08df4211593f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|6133799003|18002099003|261009223027099003|22082099003|11063799006|56012099006|10067099003|261102123227099003|261021123027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info: MEEeeDRaxrTK+2xqRMIjWk9GxeJgOAjBqjCe9hTaCOsS9/PnpzrIKN0YvJK2hiGkKLImE090mAWor10OS2pnBEZg5HDBf+1Ve+f/Usgf5B6a3EESvt+tOfC75DnfR/y/o2gZEUjNahuUCFaovIqqEbMJR8X82Y+aEYEwZTOJ0nkEVfqxPeMUG1skMsY5Hz01fVjDrRQ6fZHfxRPA0toUoJ5J0+tf4gwJTsV9OVS7y4nWEDJwvw6GntgPVYu98euIEN8rFWOPQHjZZO4TwJEPBAxX9TI33nSEOZnpj03K4oZEXH9LH+PddnNMUoKW8AGuSdC0ovgQBe0bMf5asB/3ikx84+QLy7u2gozNbu4Iko7ZG0ZDkGBzVRa/xBKv8nHFGRVjT276k/iZNt1HutSUaDtML/6gAIweBLLtDfH47UUIZYJU8DItJtF4JZacjM0ItCqJ4LfuMWT21fsXkYRn8UJusKeoNVQEWpyr4fq/9epkeykKJekgT/8SXuCFEmRJKOZ9wZCsVt2mLQHKjzj/GXz7iwbknEzH7Rb4LmxGjfhnNLJjlhgOmbs+9P5cDow3gJQXGZNVxzOmBWWwX0pxhuJ0yIJIZI11aTqzgBjYRdaci5oyS8wSPN4bsJmGym9Cp8CXEKoOTLNhMvnIS+nrTiw+PNRYk2RjKRbTsigw7dk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(6133799003)(18002099003)(261009223027099003)(22082099003)(11063799006)(56012099006)(10067099003)(261102123227099003)(261021123027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGFTS3pLUlAzUzJQVmJRbDRHemd3eEVZS3BZdzRKbWlVckxLU2dZTG8xSU54?=
 =?utf-8?B?dHh6VHhzbVF6TUdMVWpyNDgyTnZDM0UrQ3kxY00rUUxMUzkyeDJDREVkNXVv?=
 =?utf-8?B?bGVoODY4MVExT3h2aW8rUlorVFZvaEtlZXlXa3liam9GMXVKbExDY0dpN3ZR?=
 =?utf-8?B?M3BpTjdWT3ZoZk1LTG9oWDZqUTdoeFdZSEJaSnY2UThiQ3k4OUp6cjlTUi9K?=
 =?utf-8?B?bEcwU05iMzE4RWZET0c4clh4NVRxY3ZUUWNqOWR4cGxYaTg2UTB1UElzdWVR?=
 =?utf-8?B?MkNlWGwrUzR0VExQSkIvMnlGS0lhSGVQVVZUQkc2dGJrSG5OeXQvRFQycGdP?=
 =?utf-8?B?TFNneHNQVm9rU3prZVdzSFVrbG5MZ1RIRWFQTzJlVjhuUXhoc3hNY2NYRXlR?=
 =?utf-8?B?VGpna1ZtZklFeU42NmlLci9zQXVKRmFuUk53TjVIOVNIRDBjVmxtMkhuOWFk?=
 =?utf-8?B?S0hIZnhhNmMwQ25XNVdUMEVrcnllZHgwRDVseURUbEJmY3ZMRkYwTXFJSHBz?=
 =?utf-8?B?SUJZeUJVcHNUSEt5bklEbnpJcWJ0U3B0YWxqL2U4Z1hKWkdoV3JhUGpsTVZC?=
 =?utf-8?B?UEhYQkhqT0o5b3o1VW9nS204dEdadFlFaW9MSGFWZStWWkFiLzdscjhtcnJD?=
 =?utf-8?B?KzFjR2xldEhPQWVWTWZLUW1iTXpOeWNWcncweUlxai9uWG5SVlpNbmNzdi90?=
 =?utf-8?B?c0RXQWR1eUV2MnRrWjRyeXhDY01nbEMrbTVHNE5jQ2VNUkI2UmhSQWQ0Sm1Q?=
 =?utf-8?B?NHpuUkcvdkxROTNTdGlYMElRMUFieDBBNk9nUENUSmk2UGVSQWo1ekNEclRX?=
 =?utf-8?B?Z0ZLcGVxUUUreGlYMzdLMkIxSUF5Zm56WXVxL3ZJcnd4OVI1MFpoYUFqaGVL?=
 =?utf-8?B?dUdhS2w1bWFYZXhma0ZtVURzdWVzOWdIbzBqbnZiQ3JsRi9uZC9yVHJjcWhL?=
 =?utf-8?B?cW85azZqL2NEQUpzT3JFNVV3ZjFSQ0VDTFNNd3lSejhNU0NXWmx6UUZDNVd5?=
 =?utf-8?B?WVNtaVlhaXpiNFk1bDZwNW11ZityL25FN1Z5NGc2cXFJUGZlbEsrYytZNEF5?=
 =?utf-8?B?NXRPcWRIdncrWU9zcW1PR2dKNkFGS2tsaEt1QnBlN1pFNFJRRDUzNnJ6QWxV?=
 =?utf-8?B?MEhCSHFXUDd0ZlhlclhBR2RjbHgxaTFnb3pKNFp3TzltQmJidlEycnN1Q3hp?=
 =?utf-8?B?RGlOWGV0MzhiSEVqd1dWTDV3NGoraUpSdUxVRWdKNktRaXlESW0rZjRRSkF5?=
 =?utf-8?B?Q29sZ2NDNG56T3ZHd2tpMjVZOC9TMVBqYWl0SmJ5cVJteERudGI2UFc3ZlVn?=
 =?utf-8?B?d2ZLSHVqd1ArT2hzKzNTVjZtc2dvNFBCR2FxaXk3T1M0ZEV6TDV2Z2RFRmRs?=
 =?utf-8?B?NUFjMTgwemczaUdHaGlIdk5UVTNFaGY3Z2d1eTJyb2Y3YWJ6bjVURXlDR1Vm?=
 =?utf-8?B?Q2NJaGNVdFZhS0hwcGc5UzN6MDFVaHVpWjMvU3lHUUtCRkwyRmhFeFNuUDVZ?=
 =?utf-8?B?SFZUejljUmh6Z0RhcGF5RmxtNVkxaFRRQ0pJdXhQOEtlckRZNW9QS1BKWTRK?=
 =?utf-8?B?bDJYOUhCOXVBK0paT0xZNGl1c01IT2t6QUJTbE9NYUxXSG1UK1pTVC8rdjM0?=
 =?utf-8?B?dHhZclkzSk9WMmUyVnJKYm9NOVVtVUZVczFUMnp0bW5DSTJ3NUE1STFQa2tn?=
 =?utf-8?B?cXlTZjA3QklOdm9ld1hzSnNiNEtZTE90ZTY0WWwxVU00YWRWRjBVYjljdVp6?=
 =?utf-8?B?U3hvZ05CVGxPQ0JhOXByYVFSNWo5THhJdUl0VFQySlZKZ3kvN3BkVGdWeStR?=
 =?utf-8?B?UDUwSGlPNDlWRHlwTTF6MTJzR1Vabk1ZRW1xZngvK25xRWpUN25oTSt5L2lm?=
 =?utf-8?B?OXBlZXkxUjB1QUh5Ui84cGY1TmVGMmsvb3dReVowbVd4enowd1hkT0F3b1Z3?=
 =?utf-8?B?TGhBMm5VWUtQZVE0bTlERkhKMFVvVnNBU1VNUUc5NEd6dzVnVlZmVytxOFJM?=
 =?utf-8?B?QVFlaytiaHdzSlozTnc1NlV2SnZkWmg1MWlMQUJwUUFTUGR0ejkvOVFVU3dS?=
 =?utf-8?B?TGNseW5jd3A5aUlGYkxTNU9YK3gybzBBSTVTQ2hWZ3V5QjZMQmJwdmlVdlZ3?=
 =?utf-8?B?bC9iRVNlOFRLdjZvQ1BGM3UzQXhrODZjZnhtUnhsa2dMV2RVRDNNL0dxZTAy?=
 =?utf-8?B?VCtISnVrZEwyN04wT1VZY2hTRXduVEdBMTIrUWQ2UFFWMG13T0wzNVg5djJ6?=
 =?utf-8?B?YWVSN0tHQXRRTW1zakxzRWVlZHVPRTF6VWN2L0tDSHhLT1ErNVZoTmtTVDYy?=
 =?utf-8?B?UXJYT24yQkFQdDVoNnlzRXNXcHRWTVdHSVFUM214a1RnREcwd2Z1Zz09?=
X-Exchange-RoutingPolicyChecked: vl4h7UN2U9f91s21RdBe/DKTvjFCEYpfvAMQ9yW6CWihIvGsqs4xj2rB+m+I/6Dn47nloJThEvyV8NtjYRQZSAnPbDFV+AfwT/EtkiuONkGwQVOSFqAe8KlNJDUbwU5T1/NR1MjdSIAxiBdMir/9kqKxyHiBNJu3nxI8glkErjpWHfLNsWusgnJVcBQG62quIP/qWub8kQnpcLIuDDLHQeDmU3pKn/v+Ff2ILrlJn6mww/4udlgg070p+XW45Nuliwma/IJFWKUaq9yLlBxY8OfIOkOMdLrcRB42PPghninPmz6ZMjPuPsChMpwzNF/H+xgsLZQK5vqApQ1lngQV5w==
X-MS-Exchange-CrossTenant-Network-Message-Id: ceacc6ee-6259-437e-6182-08df4211593f
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2026 05:37:19.1715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KyTn4Ir+IFflNnXydbZhNpu0VhoVflQbDgjk31H4nKYTWV8EcSz+B2blLzO6kke/8j8Iq57LJZQGv6HhfQvew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB9522
X-OriginatorOrg: intel.com

On 11/11/2026 10:48, Stanley Jhu wrote:
> ufshcd_pci_tbl[] defines the Samsung 0xC00C and AMD 0x1B29 PCI IDs
> with .driver_data set to 0, so ufshcd_pci_probe() leaves hba->vops
> NULL. Both ufshcd_pci_suspend_prepare() and
> ufshcd_pci_resume_complete() dereference hba->vops->name without
> checking hba->vops:
> 
> 1. System suspend on an AMD 0x1B29 or Samsung 0xC00C host enters the
>     PM prepare phase and calls ufshcd_pci_suspend_prepare().
> 2. ufshcd_pci_suspend_prepare() evaluates
>     strcmp(hba->vops->name, "intel-pci"), dereferences NULL, and
>     triggers a kernel oops in the suspending task.
> 
> Check that hba->vops is non-NULL before reading hba->vops->name in
> both callbacks so hosts without variant operations use the generic
> ufshcd_suspend_prepare() and ufshcd_resume_complete() paths.
> 
> Fixes: bb44826c3bdb ("scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>   drivers/ufs/host/ufshcd-pci.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> index 668b57403e62..f9abbbc436f4 100644
> --- a/drivers/ufs/host/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -644,7 +644,7 @@ static int ufshcd_pci_suspend_prepare(struct device *dev)
>   {
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>   
> -	if (!strcmp(hba->vops->name, "intel-pci"))
> +	if (hba->vops && !strcmp(hba->vops->name, "intel-pci"))
>   		return ufs_intel_suspend_prepare(dev);
>   
>   	return ufshcd_suspend_prepare(dev);
> @@ -654,7 +654,7 @@ static void ufshcd_pci_resume_complete(struct device *dev)
>   {
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>   
> -	if (!strcmp(hba->vops->name, "intel-pci")) {
> +	if (hba->vops && !strcmp(hba->vops->name, "intel-pci")) {
>   		ufs_intel_resume_complete(dev);
>   		return;
>   	}

