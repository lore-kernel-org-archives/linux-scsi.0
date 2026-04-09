Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E9D3019A9;
	Thu,  9 Apr 2026 12:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775737120; cv=fail; b=g/Rs8e3+EIy37KOJMcDzHYFtJ2EZIeMty+3RgmPhoC898CYtdS7FxX8dllzMlS/tOGH3X/T5hsxI+iEAdmihUXCJDhF7ZPbFIPZx7HydKhEo1vyetXZUoWr9TljHzjODagEFtQc2MIzSd+sZrIFeb3upsTZBUQAz1g/VuDbpY3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775737120; c=relaxed/simple;
	bh=rI0hsb2lk6oFkioP894YlSWZBmKgGMwg5SK8nGi5oNg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hdjhQzunjG56ej+B8K+IVIwdZ4IGrqWh/mLA5TVUAN0dEk7KbnUBjjGhPAA2e5nm81TQYGVVUA/9yZ4gt1x4mQnTivTH/FmFvLalChAmhjlwF1eSRQ0VR8AlKtQgnPE/C1FuY4H7auy04DsGP+21wlF3Wfrq6hWEV5jVRA3ljD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UtgF81Si; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f5LQK6uw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UtgF81Si";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f5LQK6uw"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639ADeTb2240358;
	Thu, 9 Apr 2026 12:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y106hou8TJU6AhWhPrR92kbWuot7oqPZ2oE3pojlHHA=; b=
	UtgF81SipuQhrk0GO7DwCbYYMhc5kx9xsMIRR7NqCI8ZQucIdgh4wxmeNDg4MZTA
	5VkQvyKElMpK0CqFYk117zUy5LCSxkA1wy3zEw6Rbfzku8QZmrYksBjARmgSaYYV
	KMGgHAKR47YzpRc9QmxTRhLw3OvAcrQgqTALKUn+Vvn0X9sNcDt/NF6qkPFKsk+b
	CgivnyiVcljlRKGCKDZ3XQ+EbYg8tR/86YJFCneWX1Yc3vI9A0F7bGe9G++Z5oJN
	WkPuKG1ADHpi/O/h4GTjijrzRR0fP2UdUJ54d8pmc3mBiAKFaLtShVsfiMIF86hd
	0yFMZcBv4W0KaFuUqqiX1A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqaxq21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 12:18:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639Aa9g2005337;
	Thu, 9 Apr 2026 12:18:11 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011015.outbound.protection.outlook.com [40.107.208.15])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxrt2f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 12:18:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yohef0BIGTFelGhOoZWcgUDn1ZF7+DqFZ9XYQCWi0e/x99eCed73ZLdyVdFzkXJpbL3nD5k1WSBd2ebbqviNUkc73L/24ju4iVo3Ivi4qMtPxGCEvgQlUsriVAVQ/rqvA9LkAglomBdqm+68xrOyZH/oN1Cc47L8E+jrxaDk/srpziu5UiuaZ/pgpne+gaksh3NE0fqbV2p8hCYY1c+ppsZVR350EdYSivWf6sNlUCzqv6DCj7YZJ3vjRHegXilZdxWhouiyg7jzt83MryFT5F/SfJCUJCzI9ALhR0YHlITicOWIchiNdtnlc3NN92qJqREGVoVm8fn7sQVeeRWgFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y106hou8TJU6AhWhPrR92kbWuot7oqPZ2oE3pojlHHA=;
 b=f0HDtjBBZLJdSkGuhKOvy+TQkBHnc+oXxv9M8a7XXS9HWTLXVg5IhF0zh9pts7lwYS9/rH3PWJmC/tjDXKvV2j8b7azAz0u0VdIQrfkVWvXobkkCfgPjrJjCYN6vWwoEdjBlVl/xUFPKOtYeVpwlaYG1ibfIUjXT3KDRRjYTZt9tyDyHoxjwgvNbCCaEJESun5fs5jwG0JrhEpuRnxbssGQ68OSklTErBK8BX/XAu110I5j89yErezWFCZoVhTfEKMXFuJBDQvAbR4aYeUiccet/VVZhQ6pEaJyBtg8VDFLerJM3k34WCeYKQpB4QwBlq+xlIgl5Vx4JJxI2Tq33zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y106hou8TJU6AhWhPrR92kbWuot7oqPZ2oE3pojlHHA=;
 b=f5LQK6uwSwqnzpcGy7n768qZ6w7H4GcZnuPx8IulhT0ZOa5lkYTcQeefYfDkQkIu5hK3n58hJG5VT9IeiThA68LZLeH/U/prdiD89cYAIlQe4UKs5R+TltW9rZRlQRhvUY5xXxpiocGJJqSnvnMReXXNLrEVybLMlcQsZeHqUV0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB7756.namprd10.prod.outlook.com
 (2603:10b6:806:3a3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.42; Thu, 9 Apr
 2026 12:17:45 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 12:17:44 +0000
Message-ID: <c9af1723-550c-4f2b-aa04-3ce769bb4a84@oracle.com>
Date: Thu, 9 Apr 2026 13:17:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] scsi: enable async shutdown support
To: David Jeffery <djeffery@redhat.com>
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org,
        driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>,
        Pasha Tatashin <tatashin@google.com>,
        =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
        Jordan Richards <jordanrichards@google.com>,
        Ewan Milne <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>,
        "Lombardi, Maurizio" <mlombard@redhat.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>,
        Laurence Oberman <loberman@redhat.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260407153532.6395-1-djeffery@redhat.com>
 <20260407153532.6395-6-djeffery@redhat.com>
 <c5cb8cf0-9beb-4bc4-8ce6-83b4544beede@oracle.com>
 <CA+-xHTG9tMCCf11NZwKfvE5xvCfjXrttDXhFsyz=SCofAc9Mgw@mail.gmail.com>
 <069f3f1b-8150-41e8-a760-f85a0b1b0ce4@oracle.com>
 <CA+-xHTFdKaCCwkytXpWdvp6vZ4ZCh+Pp8wzkoVZYPOy--CjiSw@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CA+-xHTFdKaCCwkytXpWdvp6vZ4ZCh+Pp8wzkoVZYPOy--CjiSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0298.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: 05cd4910-93df-4418-97e2-08de963200fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zN8bMFP22I830q7kbfnTOZlnkqLNMpfvsK0TY/nvovvMaq8sKPNIN6XcIL3g7AhWyA0bJby0lueClBoX9Fif5YaClblaqha6s6qxSXQzRDFoBd1tqd3c0JH8Dqvui+UJgusYRbuw+D5Uzl89/5QfvqmqRlDkPf4hSRjHmwa9w1O2JDaw3Y1a+7DXrPfRRHenNJWcSvt+MRKYKxgrG2yKJ4pzj6jbWos9MzBmTk1jqZgUJX+NMZRIfamiQm7xigRAimzm4V0U/LlPT3xdz8ri/TpRW4G0Wvxm0QTdT1fgPFYzJdSwAU9CMAtQUyCIXf85mu6bnT83eZiVso1bqzezetgFuE8KdYZMj/DrTTVYnHd3S6mjNzqW2boEPsnA+jvniUAjIJAsnu/Po0Q14V6Tkk+/h6LMThqjG+zpYFUZWcoB+Z8fn3gJ3yQ78wiKgf3BPxq6hQWwataMdbyCKD5CwQvPFoHNed6jADZi0AYKKOc++yyHbuU1tAIjXMNRyYyr05cgww8pRqWkAsY2YzdgYzUmEBt95AEhmQJnekxw2eDbsI82no/7kavBICgwFWt8NDUG7EpWb3qq4BWFMDrMEjjbInVNGbQvSsduRmoUI9ExEcNK4iGCHCrFp19JFxpj5G3B8q43c8+tJDLnM71vyeE8tcDCj6s1m0cjZi9u7cPNSb+tC79oGQkWvptBhWrp/bcQORYBkkX3U5QHh/vXHSHR81b5m8Pxcn6mgPM2qQw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWp0ZjByUms5WXdQSVhqVUlkaVJCMmErVlF0MFNGV3c4V01vcGJKZG1ISkF1?=
 =?utf-8?B?TjR5WmlNQ1NXWU5GYlgrcmhNc3JyU1RaZy9hQ09PVzRmZGQ2N2IrbXNxa2Ev?=
 =?utf-8?B?NFlUMEorMjR1dmtmSnV4STFRbDU3MDFNa2QvazM0L1hscUkyQ0NwakJpMlFp?=
 =?utf-8?B?NjM5U1NhL2xUMXRWYVlycUJhTmFtQ0pJb2ZlVFdVdDFZWVhJSEd4TnlSYzls?=
 =?utf-8?B?cjZjSEVhL1pObWw1MzhzU3VCK0JkTTMrOXphOGRkY2hoTk9Oa1FPSDl3TlR0?=
 =?utf-8?B?V21NSlBRQVZoc2o1WXFBYUx0Si9pWGxFaUVLamVqanI0dDZ3eXVnOXA4enFw?=
 =?utf-8?B?NTY4NVdGRFQ3OXlNUHVrRE85S0U0MXJzbVpFL3hLOStaUHFOaEZreG05RE9V?=
 =?utf-8?B?MXVLS3FUQ2NVOWdzemVzMFExUUJNeURkVEZGeXFOSEgxWll1ZVlSMW5MMncr?=
 =?utf-8?B?bS9lVlBYeUozZjdXK3FHVjMvMmZ4OWczOUZ4VUpjT1FYZmRZOXh2eHF0Sllu?=
 =?utf-8?B?TE5reXJxZ3ZJNjA0ZnFBeTIzYkJOdy9zUXFSL3hiUVJPSVd3NXROMlVBL0dX?=
 =?utf-8?B?QkhZOTlxRGREZEpTeUV1ZHczVCtnV1B6Q0hvcHlYcXZERWloZFJJOHNwaE5q?=
 =?utf-8?B?emNOVldJSHNDSWZFWFdITjdnQzZaRGp0VDJDa25KNzRkbytGbnpGNjdXUy9n?=
 =?utf-8?B?dm4rbWVwVGxjYVVPdXVjTURBUkFSWFNyaktubDFTeFdYQWNMakd3SlN3dEVk?=
 =?utf-8?B?VndRdVU2by9Fdm95TzZCWWgxajhSa0I3NmdYN093U2hvL1NaMWF2L2JQYTRW?=
 =?utf-8?B?czdlQzRZcUZxYlhCSm1Za0kvY0Y3ZEhCRnFxZjZOUy9uK3ZZVWtmNFZHbmJ3?=
 =?utf-8?B?TFltUmxFMERucWdrbDhxbmpSS1MwWmtGN2c0Q2lOUFZZcHJJbk02VEpwMmJy?=
 =?utf-8?B?dTlIcElGNjI1NE5jekdSREd0emVLdVBhTm9tMm53L2wzRU5CaktRVWJYamZs?=
 =?utf-8?B?S1lzUGlBSEVmcEFiWU9YTDhUZU9oNFRycHNMN3FSdlk0NXlBc2o1U0xPT09s?=
 =?utf-8?B?UnpXUE84b3FsZFBQemVJWmNmUlR5OGFvZDZrNXpGQWcxZ2ZvcGEySzNDaUc3?=
 =?utf-8?B?ZTQrWWJ6Z1VJeFc5bldkYnVidTI4K294MzI0YTJHaUp4c2JmeE5HZ2YzTlZZ?=
 =?utf-8?B?N0Q3VW0vc1FqMlU1cGpjd0Q4ZHFFaFdlNExvRENXYllOY1ZuSEYrS1ZLbHE0?=
 =?utf-8?B?ZThkcXZUUG4zeFBQZWVsbTd2NisydkpXbGZmNmJUdGNKRkFrV2R6S0FBUXVt?=
 =?utf-8?B?NmNIeTQzZWZ6b3BFUFN4Wmt1L2pqWGp3RFlvV2pjWVVteGpHNDBIU2JmWVBU?=
 =?utf-8?B?Rk1sWGlkbVUzalJGL2JCR3RGT3lRaHVqdzgwK1hZR1hESE9TSHdnd3liZHhs?=
 =?utf-8?B?a00wTURxVy9JUmF3MG1sZ3pCZUU0QXNBbmNBUmRxVUp3aHBRemRCRzN2dTky?=
 =?utf-8?B?Nkw1MGxkM2EyUU04bmFVRlFhQXlMV1grUVBMTGJqdW01ZWgvUzR0SHNTSlpr?=
 =?utf-8?B?VEsvcWZpWUZCcjFPZzdOUjRWUW9iaHkydkpDU2hMTWxpRGY5Tjl5ZzFDZit0?=
 =?utf-8?B?K0ZnWGtkOGNhcE11dklYN0poK2NjWjR1SFpueERTWTNETFNmTG1sb2Y3bzh2?=
 =?utf-8?B?R0ZXZWpIMG1HaW5uL01JSVdTeE81MVNIMWZmcnVYZlVhR2dvaDBQbk1ZN3BP?=
 =?utf-8?B?TlF3WGtidFpyalpaMm5QUzY2ZHlSZGZoZnpJUkt2cC9IZzlyNHFIUUYzYWxx?=
 =?utf-8?B?UW5sRUU2aVR6YlFlZGZaQURqRllDSmp1dHJpdDR4K1dTV1I4bGY4a2JmRkJh?=
 =?utf-8?B?TEZla0U0S084MFN1Q3I2dE9TZnBJbC9ZN1JrWThKalpLYmZHNWIwemhsUVZM?=
 =?utf-8?B?RnBNMjN3ZHkxd2hINVJTV2V1M0lFYjJPd09IQWN1YjFSVkZNSmdFclZDVWJ4?=
 =?utf-8?B?emIvVUFZL3kxNEczSW9ETWtUWHMyWnVzdEhlczBFWUY0ekRKT2x2Zk4wTTFE?=
 =?utf-8?B?U1dhcWVobEpLS3NFMDY5SURRZUVZRkFHMDJmN3ZtSUxFS09scldLa2liVnpE?=
 =?utf-8?B?ek9MeHZkVG9qb05jVWpPT1NxT1VoRTUwR0VUMGVQNEU3ZTFlN1VjRDVJMTRX?=
 =?utf-8?B?WThPYlFCc1hWWk9na0pRckw1VE9uZnVtdzBXZzVlMDZwbEZqakR0QmViUFhr?=
 =?utf-8?B?L2ZtMWlxemc1YnBqTjNsZk1CYlNsdVVIMExvQXlVSXdqeXJLb2J1OW9EMGZN?=
 =?utf-8?B?bkZ2WGtnZklMc0J1Smlrd09uenZKc0I0RGlBTy9JMEU2RHJDbTJhdz09?=
X-Exchange-RoutingPolicyChecked:
	VjuPuqrp3Id+6VYOn1nVaMKtrCMtF9HNpjUNhlaZ+YekU+9VGAeNP/PMnHTB2Mgb4iziEai3j2w9iFwtIa18LMCW8re7SxnJLOBCWptH31Xflv/md/5q3aNtsd9U9Iu/UVI/V72hnwOzmv4babteJA/FgcAJ+afUMw6Ln/WdLC8uqLkvzyKKBtco55ChG0V/93ZULhOt3+W+rqHBKYN6FMtcX2VLFsFPPaUN2hUxUuiHilTN8oTUz2bFwDhnuqObHhgDcbUhp39sBXbY6hVjfDYhJSfmS8ZErrWP3HK507Ao+8S79yrs66lr/BmmM8kut+k9MfZblxzETe8enaYivw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6o3zCWEwPWOmzC59TwCDYyvLY8WQX+cazXOMMHPu/b7JBDF7NcAQzz/OWXcVP4EkqJCXSdvGbAMe/YCMAa3i/U8friIng1DGeVczMrDP6IHnbIyDhJShD7g8/RQHL8KX+ZG6DeF5U0q11IabzW36BQADlnb9SdU0gahiizlVyMF0L7aCdB4vaTi9aNoJxN+776sPmFj4IkwgUz6zirjPSia5tTGOMVJGu65hXSl3wcsuMrME5orlyyUKNKOJPfqjpWWaxGkvoLMTelCljZsUXo/QfE3yQCxO2eYyIK43aH3g3dAQILZmq5TYTBOTVfFzEJM7USbQv04mM66Pz5pISNrW6fmX+vBMWA0+TjaDPU1P/WnAg0ZhIgZ/Exh88OAnXTwV/lxuiGdofONNI7JBUvmhhko33oLo6Y6WkP9X7twZlLC52TPIp1byuP7BNtzyq89FoZgFLBvm0qh3n6YLf7XsVTV1s0N62Zr06szVp2PFXPSoK9nGjOPPvF4/EvhSoqtSSRhAh7xnl14tkCk+SA4Yjj5KnIihU3T2Xv/D94WDGQ9t8aaGDl201hh9Zj+yN5ce7wiJTovfhaKBSnbeDVJXag48iZorJKsF0KrbiuA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05cd4910-93df-4418-97e2-08de963200fc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 12:17:44.7488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHKK7OZgOTexul41/q6wFP21fGSyCLpnuLIgvoCvyUxp7S+xgCNR4KmcYKr0mIjEAad5yG97jerxkURD9euaUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604090111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDExMCBTYWx0ZWRfX1ykPrx2YNMsV
 sw3cH70IkRl9kM40NTB6XIccy9Q/cXx+E1oE+3TONCqRHUB9jW6Jbl2J90uK3GtLOG9WKJegfr8
 9tcdfbgt18L1kOx9uOZ5/nTanqPyNcQr2ZKeef3DzqTxLS3AiBpqhJU3FM7aRtoCbWGpXE1JsdM
 Tacf2YV7N88fMvrWmSxV9deSOCMJzs2dq8ODsZ3x56+H+CouaqlMS9i1ivDBv5z4sUDgaNmlogL
 s1UkhD2eHUwBD+YAY4DvTIAFP+SN60eRHraNY66eBi/Gbswp0PIVLsS3opejVdAUkyqBtSoJgcd
 XyDevH+lB82E3TybuDcxF+b/dl5tYRgIl5khe6KFNidiEBjXNYuo058zmmDExK0z5PgspR/sPiT
 5cm8C/oi4AycI5oEDObBblzQS95jVuWjEIeT3HjDZs0A2fof3CYbZBN81fsc3MA2y4wJii6uZAr
 iJylO1dvGnZzcf8PDnA==
X-Proofpoint-GUID: _Wdp9zF7znH4pDRb77NfiK2an1e3H_ix
X-Authority-Analysis: v=2.4 cv=Oux/DS/t c=1 sm=1 tr=0 ts=69d79903 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=atVB50EfPHK63WI-mUoA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _Wdp9zF7znH4pDRb77NfiK2an1e3H_ix

On 08/04/2026 20:35, David Jeffery wrote:
>> Well it is not exactly like that. We have the following:
>>
>> scsi_sysfs_add_sdev() -> device_enable_async_suspend(&sdev->sdev_gendev)
>>
>> and
>>
>> scsi_sysfs_device_initialize() ->
>> scsi_enable_async_suspend(&sdev->sdev_gendev) ->
>> device_enable_async_suspend(&sdev->sdev_gendev) when not async
>>
>> Maybe similar needs to be done for this shutdown feature. AFICS, Bart,
>> added scsi_enable_async_suspend(), so maybe he can comment.
>>
> My inclination is to drop adding device_enable_async_shutdown into
> scsi_sysfs_device_initialize. The intent is for normal scsi devices,
> and I see little value in setting the flag so early to flag partially
> initialized or pseudo devices.

That seems reasonable, but, again I am not so familiar with this async 
suspend and shutdown.

Thanks!
