Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512413AB47B;
	Mon,  7 Sep 2026 14:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788791303; cv=fail; b=fk3lGupbAyrmr8jXwPAtiMLWIt0cmLaQbTuASYTDuE9KR9EBqUciSBqNDjR+jefLj8Hh4V8iLYbUTC4g+yQLQ3m0yD5gPvyqzJVZPGVr9s/kVjdw0QCfKdS6TpKbogKfL55BKWgdOj2fM/XjeQAL8GUyZN/LCBISKMG0n0OeR9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788791303; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DOtpUgt/O3X0TNLAQjXsRN81YT3/WRKLJMedVx5UNT2GZWEU7x6pGJlhN61TNfYLTosXKKZEFAclYDy2/Wj6MsLlDahqyDH3/THSXRNcXT3fihllsuqScWnQSil1s1esNZEuoPjyna/oUDCi+r4y7qCciW4Crlekz6c4r0YDlu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AWEmwQg7; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=CitUxXVb; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AWEmwQg7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CitUxXVb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788791298; x=1820327298;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=AWEmwQg7w8mSJp3INDlxRxmuA9pH5bcWHyRG+rQ5H2coUv0lWHB9xOhC
   jv1bPCc0SjGUI5Duf+R9AgMtupA8smfmnBhQHNEsOJ7jYK91KvHgXjqgI
   sVHruQmLFm7S33AgKJDLphjqm5IikCed5bGXkJ3qS4Y4anmQaa4r9HChf
   TzP/I5ajhFGFg13TqI+D/IpyiIQE45Id55GtoSCluHeribAN0vCxruqLg
   t+ZBmpZVztKt5QSYa+ylqdiMOykVCCdgM9LB5w0Vz/lJbwpT9QlwOb84u
   fOccCM4SQWV6F9A2cZvDxrKfhqMDiGoMXFZBubR8/2iDmeQCvHlQxquzN
   Q==;
X-CSE-ConnectionGUID: GGkrqmSiTsikaGjdNCMXqg==
X-CSE-MsgGUID: xSShOmG3Rp2LoNz+O3rUGQ==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153545610"
Received: from mail-westus3azon11011036.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.36])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:28:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VmAZSG+87b21fvLNYGiXNkCg2YHBiHz5WAaRnlgWlz4OiUTHRsnDrhY6wkHVzXKrt+7YiuN9QWPlHZZ9LVDw0qnC9GSf6P/h+fW5yQ/1wobufYWLTW7MtFzIvbJPnWyT1WbBLpngj24Ee3yTXJmyslH8CpR5qFOX8FuSVjp2l3MjNbuOF+LyzP180hRF//nlNqu0PRIfwZCw1lm3p35zBPixsLIl7kaFGGoGGfEqfYxAmwci3BT9acXZv7HljxkWKiUBRM+huj2Od+++7Yl94MHztqK9HQbc2+OrWUL3efHhcuafda7OBBRsMoTJ3hTTNbLlR7cj1A3N/q+6keIvZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=ic/pqvLgPAoT//foR+u0eNygRnGqbSYeQ3ko2h6epnt3hI9688wiwBIvjk8PHNVCSLstsl5Q8OQsHyBWRUCxSj55TFsy74MxqHgF5NCKDVOQeYPuzwvTSJlTqSCZWqnl164sOeRsNmlKqM3MfZucGnMfUA36qnyVejSIGmfiggRFaXXafEl6X8Ww3v1FVFk6W1xzHtHVENXfd3ydcqHBb2XYWNcjO4Qj8ukkkicG8VjbS8G3eP6CXyu4P/4fxoHQaknOEtcNjukFscPz4hUp6/Lvm2Fjhg6aLaiFofQJ+v6VSV1kkwzKwKTStOVpVAqfkNdGVRK8uHRNluf+cQxSrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=CitUxXVbmL3zPE++0TEpRcYJCQSuDHv5X3PI2qVo0Q0VDpZrJUJLZc8MijQMyZje2GBHLAqER6aXFtihJRFH+2EBT0zX8Ve8XHeASqrTktzi4XcJwgk1/zw76zI73YFvhzsllz6M/WUa1Y8JedeMaGQCCOY4HwpVZurd7EzSizI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7534.namprd04.prod.outlook.com (2603:10b6:a03:326::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:28:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:28:11 +0000
Message-ID: <d7b3bb8f-ecf2-45a2-ba47-03d118d49122@wdc.com>
Date: Mon, 7 Sep 2026 16:28:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/40] scsi: mpt3sas: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-18-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0077.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: fa4f8623-6273-4870-1130-08df0cec3e72
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|19092799006|23010399003|1800799024|921020|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	flhvkD1AGSC9+JvuOBjjJ/Dx/oB+9P4qn+Di1sQxARhXPWRA0/NfWOpZh7XfPgzI04ZjsKdjdh3fcSBNNzhqGwTyViWIGkr/Gym0y3D+zJ29ZknqYMJ7PXcHyQoaXZtMO1QcNvV8tlxHHPZeOTUzeb1BAV0jTDbatWhe7i74YKHPovizz7BKaTBpzUPMzO1wGxGEvoOU8j3QFjjpShwHBjmBAfIG3jFipf5v5gsybv5A6wuSqkCeqUd2uIfNFVdtJZomyioaP9cP8OSXAnzmUNwL5IQq6k9E18rYSZ/LaLGjVL4/B6cgPWl4f09xNq8u7uq5SvVjBrhSVdw13NLxj+uDSmvN/JHRYmB1OZN0Epk0KZoJjXrOXuK8UHDFdiAiila6yYHwrq75rk2/cY2osdh6J6laSjYveRvseWqLP1S/6G5Io6pJVYec+CellOFv7BrZCr/hp/JKvhYNyNttLoby3+pRow+g/da0t1opbmMWElkLoic8i1YnUzjMaidkAcc5ABJMqOZNI6M5TQHOhuBmxNlzvA6f/A8SgSJCADvOOZacyZ1NwSfepQbvw3bDre+6LZs33lbXWx3XXGXVBtQ70D4tCE/Ii0oL5AG1n09Put91Zl8Miicqn5s2qx7kzLATYrfA9iV7z4wN+QpW6+OJ5KhABdDF7gM0/IaZUaaG1ngZMFr1CWXkxuuzvi3Ottc2FRud5rRdCOSs7uQfpw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(19092799006)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHdmWTllZzU1S2pOZGN1M0o5Y2tZNTM0OWMyVDVKU2ZYUVR5Qm4rd2prL3Bk?=
 =?utf-8?B?SWdpWHNtYkdPS0dJc0x3NlhnaFI1SmtCRVhhZ0U1VlR2MDlmR2d5cDU0em5j?=
 =?utf-8?B?MUhkT0ZXa0dZL3p1eUtFUHM1a1FMTlFWR0tTVUI5Y2hQT2Nudy9TNGllUldW?=
 =?utf-8?B?Z1YvTElvUXBkNGREM2x1OWgxUDlSd3F3OXpLdHhxQ3VjS1AreW92czJrZHB5?=
 =?utf-8?B?R3JxVEd2ZVR6andUVzhlMVVFb0lTUlJ6UjRySldJQUZic1R1NEJ4MEpNelFR?=
 =?utf-8?B?ZWQ3VFA0a1hNWUtaVTAvSThlbWhFVEZJUGFVUzVNOWpCaW0vb2pHZEVIaU5K?=
 =?utf-8?B?UWhWYWs1MkptNi9qOE5DUnRNaTdheWx3Q1BDb2FUVXJ5RDV4Tmp0Nms3N1JD?=
 =?utf-8?B?ZWVHZk9tNFpSZEczb3hNUWF3elU5bkRpYVNma0t3Q2gwK1hDdWFVMkZrbTRo?=
 =?utf-8?B?VS9TUk9iaEZmSUhtMlAvemtxRHlZVTlpaFRkVUZZK2JzaUtYUDJoVklYU1hR?=
 =?utf-8?B?TnFNZmdqVTFveEdPd0s3RXdKRFRQMTRKMXVXdDhHWEdSZDFnU01IUUlYRzVk?=
 =?utf-8?B?ODRCZjFadU5lbDRzaU44eVZxK3JzWWJLTGlpTDRRQmlCVDU1S3FLaHJUeEhE?=
 =?utf-8?B?S05JWXhCL2VQSi9hcnJBWkZXMERUNm51cVA2T05HcnBCSmQ4N3dJc1kzSENr?=
 =?utf-8?B?bVJyMnQ1UWMxb1hwOFl3U3A3M1VzY2U5SFVEcWJ4dTZRTll3TCt2MkJJWVM4?=
 =?utf-8?B?S3AxbFJDQnNBTjRRTFFLeHVCd0lWSFUzNVZNTXhLc3NDQzc5NlQzeW9TOTlx?=
 =?utf-8?B?dHlWL3F5QjRWTFkzRXhNaHhWSHU1OXEwWXh2cmgwam1iZkpMMmRTOWlYVVo2?=
 =?utf-8?B?NFVRT2VIZngxTnAyQ0pScVg3bUZwYkdlTzJ1Z0NROW9qdnJuaWczUHJEc3Fr?=
 =?utf-8?B?cWNuOU1JVTcrMTlPR0JnVEtUbzNsRjdXR2Z0NDJ3ZTQxaitkWFF5eXRKUkRT?=
 =?utf-8?B?c2lSWlNKTTJaZ3NrTW9neWN3Smk2RHlIYXNLV0RFUVlEbElCQ1MzV1hXRENF?=
 =?utf-8?B?T3dOcjBXMUltMjh2OURYNFZYdnNnOHQxSmhuMExhSWZsT2ZGV3JpMGs0VjFu?=
 =?utf-8?B?cktVZUNvbkZINHpzMW1kclExc0lheFNoR043cWxYWWtWbExpM0o4dVVMSkVy?=
 =?utf-8?B?NmpySXhZOTArblBkUHNaUmV1czRPZUExbmY5ZXFoTnllaWMwdTdEZ1RDMjJF?=
 =?utf-8?B?cjhwZFV4US83SUNUd3VzNnNWbXhlL2Rib2x4dDNQK1ZIcmRRMVFsc3JBdDlY?=
 =?utf-8?B?eVNWVTFEcUx1S2lvTWNGMnBqYmwrVkdoMFRqajZmbmlJQnNqZ211R2xRSW9D?=
 =?utf-8?B?R21sSzRyV3YxdWZUSHVyS2RkOVBWNmt1Sk5iZFd2QkVYdzI3a0tLS3ZSNlNo?=
 =?utf-8?B?eUR4RjlUN3N3eUlXcTNrbWVqMEZXVFVCNVNrSmJ5TnhiSHBUTk9ycGpxYWxR?=
 =?utf-8?B?UEg5d2J1VmtPSkNOQXVSVG9IaFZRWGJqQVhwSGlVbFd2cEJQbEh4cUtCd2tw?=
 =?utf-8?B?RXltd3JuMXkwNXpZZWlmN2tlMGpyaDVvOElRR1cyZmxUdW5QcjdtRElDbVBq?=
 =?utf-8?B?STVaY1RTRE0xVlVJWGxyTWxsakFTZ2daM3poWWQyZXZyM0NHN2hsVWkrMU12?=
 =?utf-8?B?SzBsRExGZmwxN3ZZMlROMHhKeGEyM3pNK0FxbXRpRllRRkR2M2hMbXJGeXc1?=
 =?utf-8?B?UEZ3WEY2UUN2NC93NVFISjFCbTRnTjZ6c1lPVEFqTGQ0ckZkU2xsWHpRczR0?=
 =?utf-8?B?MzJhUEx3UDE5eFd5RlNhSExNK1ZlV1JINXdZVDdCeTFjMmFQVXNwZGRMQ3FK?=
 =?utf-8?B?aGFFaEhkaFgzWWxHUDlwSDZKMVlHSnlzY3RYZ0VjYWhGcXNqbjkzMVZETHdT?=
 =?utf-8?B?djRBemdaVXc3UjZoK2dtS1hpWGM4RVN0RHhqRzgxeW9WQnoxQlI1RmgwWVlh?=
 =?utf-8?B?ak9oZEJxeEdQZmJTTXhBVXRGU01nUklJUmh1M213YWR6bTRYRGtlVGZBcXhW?=
 =?utf-8?B?RkF3Z1lqU3gyR01lNjZCcDE4ZjMzY3VreGRUVGxmV0o4YyszbEdiS3FZdUFX?=
 =?utf-8?B?Y0JsWnF0WnN6dThRMzdEa3Q1RitpbENlRGFSVi9Wek1SMnJjTW5LTUdrTEdQ?=
 =?utf-8?B?Tkdtd0lZOGtkcFdOWStzOHNWclY4MmxxWkJBcXhYb2NtY1ptQTYwR0E1ZGw2?=
 =?utf-8?B?eWNPU0wxa1FRVlRmSWE3TldaSWVrOFdRNnJIOXkrVjN0QTVmSkRPQWh2SlRn?=
 =?utf-8?B?VG41K1ViREhrWWUyUUVxWmJLMFlQditnbG9hTDh3dFhSbTh1UDd5L2RFdk80?=
 =?utf-8?Q?R/TFwYdinERillw4=3D?=
X-Exchange-RoutingPolicyChecked:
	4ASbPP7qn6dn1bp+FykCfTZZryLq1fzAD9pshvq7DMQza88X8bTB8sUKuFHoIPaffXWt9sCtNS9WLt4LKUktvuPU5R5xE/v30ntQXTX8okq7KfWL7FI6uSh8Q/8js/1/zgQJsj1mK46TK6p5ARiQj5uI/+uE8fzqrf0BjA8sTSKMLOOmJnhOajR8Jc+3cgdJQtw1GGRWG8PStOolL2/FYe2VxTPYxdTl/fZW/5e8H385NL0S/KbijDEVCxi2WhmdxBYqfJSWSXo8aaDI3keBfIsJpXV4o6QFNgFCO0mGUAlGJnsJ83S6jpDrTDgrPqcg1jDJTDZS2mJMSTBjGvDFJg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pXx/992r/8fde2zDe/iAC0adtMngrMudwhPi5B0l65IQ5y51XIhF7Srr2uFbAHhPMwM8CAAt48zLaP94KUU7X4TqJeberbv9mRd89QIDhiWtBN8HCldP5wSZump1vzN51BB3Y7pQoe1jGTKkyNe5lIBpgJmokEsmRjSzOLCBuOS3YcExjVTlBD4wjePiV16ACj+ucpUQq9Y9HmVddYFm60UQSLD+dtqEz/2XSO72mMQgcia5NzpusEQNzWEVbsG4xmiof5DJ+FsmN0/xr7QF5f2uNYTkT9S0tz9LwqpyY76aT4HD4rhtupCkR/aXlGaDibcjNKclL9wiTVSw5QVAgOU8RVPT93vImbsRcSHtTjkyI4Y5JHQsHbyfbzALAJM9RDzQKUtlGlS4ha7LdFIlRVAr+b40aYriWC6a/afnHxmccGekqXfKVmXyImm2gadXV2Zz2OeaJMIDu/nem47cdPA3DVY65GXkItW7b7oVc9CjKrUuUwCaT3Gm6cR8IVIDcW9lmb3BVfWPb8EZ/F/7+QdMG/7ULeibLWUmofyEYDih2RFfDialWW4Ad34Pzod3yK6tF1NGcwgfKbEFmVx3Y65BXGn7uigXIaq0PosqSeuqGXVB99ErR69ZDlFigCMz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4f8623-6273-4870-1130-08df0cec3e72
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:28:11.1811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdgAKPoTpJQfov/Sg0H0GND8/qfrHfPD0eLKTFW4drye38HmZNyO06dDqi4oNCk+I5yQtrCM/w571b705gYdbAY5YRFK6vTuTQUxBVGeaqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7534

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

