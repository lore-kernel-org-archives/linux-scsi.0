Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBA44682F;
	Wed, 15 Jul 2026 11:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784114898; cv=fail; b=h39okieVEbPHoCkujzwXezODniVu6DwVxzmqzss/ZGEgEYs96VfU9AwKWOBAWGnc7NP3K2YlG/4iOFaixKXzdhfbriv1NPP5nMOqWlpvXmqITrZDb9arCyPdPYIFAw1vDCZjqoug2lw9/Ks8/mGQGerfqgftVBkyslsYfLMNe5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784114898; c=relaxed/simple;
	bh=BPvCqB8/HG+ZLSgeVe/tdFFFW9XTECwPi0mXGb37vIQ=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q/4wXqAX9crBK0tVnJMlWbMSb/CIHBskGABnrlkaw1Wgcc2Ame3vt3YgtTjLdHjwQrB7yFBqsd+VUKsTcPFmee4x3389WjJndE3idXAYFmXpLQH7f5FBMMLeJhX77DIMTAi8OncIlNWtlJtv6AlmsHiE/mjLLxL1Z7FidSaQ478=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gofyk7zl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M7nMjPFj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gofyk7zl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M7nMjPFj"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66F9iUEh231225;
	Wed, 15 Jul 2026 11:28:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TJFo2zoAdPgTofxfVlYmBCvNkZgJ+Ztf0OnsmoxCfzs=; b=
	Gofyk7zlKUtE45ug2wqqpNdGldwrFcfbbfM+YwPmh2U+hSFfleQxy7nqFS6060iW
	8Mz2d656ym3BnffnGg87ucmOkRslXkHn7gvCksp1t/i7LbdsgKNDKT6/q5sZTpAV
	7XaYNP0Ce6u7wMSmrnZc6bg8oJJMQrywu7ZcdVsLueC+AJpWKaW2ggGOKMVS+Q4e
	d5TqzuPWjQpDXTWusJLrmOomI5anrrcZPHvtoex+pGz4PHmvkRuANA8TTYuKQLi1
	cNgQnt04/Z0Kl+nD7anuQYyCceCIFhn7vAncX7cU0nh4so5WI9NYQyEgTKklOCGx
	B2tFkbDM4SqaJPj9STDaag==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed2ek5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 11:28:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66FBRxhV033530;
	Wed, 15 Jul 2026 11:28:15 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fa6ju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 15 Jul 2026 11:28:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lwYDM+743kzu9ViC5O7BdBlZoCnKaPKCZqOqVhBSgoxjNC1i+RPH5P2YlQUZ1xxZe6Ptyh/7EsvOaTC9vxjv6HnTMq971NFwdvIOiX1kbGMWBhaKUTP8brIqwEFSjD7Cqq5u6swn/rAQc1ORUnnyAvKCBqsr0VQSrddfhFMcfDTi4DlcoK5UYzwAOP/Sqeu3iqH6y7svFxMgcp8LAgH98kN4Og03iIhcCzg8k6Fz9IpIBHya+zt+pU6qnMcjvSo+AKmlikNNSYB6E3Sv3SxbX8e9vJIYpbM11Q+ONPE3h9Xw+3C/MOi2PIXbXHYVIbb1C4KMfHxBorizp2lUeWYa8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJFo2zoAdPgTofxfVlYmBCvNkZgJ+Ztf0OnsmoxCfzs=;
 b=SLeZLp1xRdwEn+oW2mnyWWu5umHfuB5LAmDCFRDxHn26u7bRN6C3kEmlwd/AnOR6K0q89pJjX/mu09JFcDZ1R4yMLnGVU8TcwhbootwhLtgNX+33fQ00yZsfZ/+WUm+yG+ChxVS8QMimoTwWPAJ9wbS1XWgy5LfR2OKwZqX2KMfJG7PTTfIhstbtbRKt2GofYSUV2igOzNcShvaJSHP7jccyMya5vQQgbtmqx6rPM1QbHCBGgluuP7AhEGqq2CaSXmhdQ9uVkVJEVFnE6DVuusvk/GYnyfrX9Xwh8fBTscotDoBt2CNq8Bj6zqzoKCNhoQHLJC9j0bl6KGoNSoKLHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJFo2zoAdPgTofxfVlYmBCvNkZgJ+Ztf0OnsmoxCfzs=;
 b=M7nMjPFjQbw9iCJtpBVFlHb0+TlbsUj4hPfr2CGe9G07N0ax1UojfDij9/vGcIahlEjZP7ub4YtqiYXXGBVIIL7B7D+RuM9faDepHoXk3WwJ1BOhrXP+dXdCMwMP94xa/ENDdgmUVgEraO8hc7n9kUlgrhsoDqQPxwZ9AR70wFg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BLAPR10MB5153.namprd10.prod.outlook.com (2603:10b6:208:330::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Wed, 15 Jul
 2026 11:28:11 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Wed, 15 Jul 2026
 11:28:11 +0000
Message-ID: <5bf49e1b-ccd9-4d49-a982-6c288e03a9a6@oracle.com>
Date: Wed, 15 Jul 2026 12:28:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/17] scsi: sd: support multipath disk
From: John Garry <john.g.garry@oracle.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-14-john.g.garry@oracle.com>
 <20260703122406.84E0E1F000E9@smtp.kernel.org>
 <c64a4c05-6f00-4249-9cf4-94a222429b0a@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <c64a4c05-6f00-4249-9cf4-94a222429b0a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX1P273CA0034.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:20::21) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BLAPR10MB5153:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d8b3c0-2c6a-4a29-4786-08dee26426de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|4143699003|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	3c4gqkr4IgvIcw1Z3ku720XFMnvfyHSMxFeRMS9Mt1EeuL3gos6BPVFtR5jrmyDaaKfL3uQexfoPm2vN1kkbi4NlR0wvf0Zx4upGKKs9LLC8idHHIWqgEjofnC5Nes5lrmlzvICTQ2y9U0WgNTbD+VRTjyqX/HA47eFBZaHRsKlPGWroLqwO3Ui2S1ujE/BNjZTnGGDDdO0b7Yw9kPspDCiYLpi85NQbOU74AFmmcgrpZ1I5DO2IIiSX0fkRBmXwBZipGtERVD2VCb1d+kQfpmNmPuzwJMlG7bw6aCLilba/SyhKQdvtWe7/mgate0dyv2OG1MOpZ5JJxOUZWY7bbW1Bfiwu4RJUXwrZnu4HASBpYwY6yCsWE66xBoTxzQKpsb7Dg3FwkD+vYnZadBst1ikhMVcHhLGw99/TK90K5BIuCvyKbKcEBRlpHyV6GOllF8OMp4oOS8zEVn4rpIF13sYTKPhSyob5kYT07mbuhuCaiikhG2o0VatdEZZILlnzTgJyzm+/uTAr2mWhz0NmwglIpv8h9xaUn/2cjatLdjpleCHyJ80UVQiHFEQjvPQOlumOLlT1le3grxdI5osusKlACf0qYs6WvzuHKXQR9xpoK28O+Ri1lIIsOZC/arST2A+3qJL0jbQs696WMxKj0NqAHQx43nCmqb6yqkT2Jv0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(4143699003)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2Y3a29sdHZ3ckpXRGxpVHVUckVMa1c1YnF4VzE0Z0w0WC9oRmpWVytNOWU5?=
 =?utf-8?B?cDdHWm9ob29GTlV5NFhya2lRa09NemlVOW9IWlhFWHltQ0dhTlExRzJ4N2JE?=
 =?utf-8?B?cEFhVlc3d3E0SUxEajFvQ25mTHFZdUt4VGlYVHBVVUNxejVWZFk2bHI2NmhM?=
 =?utf-8?B?VzVycXp1SmczS1RFeElkTTlJanRjb0RRVjRoNmJUM0htZ21OWUl6Mkh0RDl1?=
 =?utf-8?B?OEVrOWxzQ3RFTWdYbUVaL01pdDBpb2FiUDcza0pvdnNSZ0NEZnRBMW1SSUtt?=
 =?utf-8?B?RHdaS0hzeEF2d3NzY3BNbFFKWGZxaVBCd0h0T3FoQkdMZkhmZDJGdEt6Y3NY?=
 =?utf-8?B?V0hyTWZlZ1hpdWZUOEhPRkdsZ0o1R0FIUGZYcG9NU2RZS29KVFB5T0JUNjVo?=
 =?utf-8?B?cTUrenJHb3FPSnVLRFdrVk5SQzRITDBycnZvcWtYZ0lPdTMxNTdGZGx2OE5G?=
 =?utf-8?B?aEpISWF3U1lwZlhCcDRKK1ZkcUxRby9pUjZWY2JUSUw5VDk3S29DVUdtZC9u?=
 =?utf-8?B?MmhqakwrdjdDaldrY2Nxb00xQjVOWnpUMld3WGp5cDhrL0g0MkFOWHlGaEN1?=
 =?utf-8?B?OCtiNFp5S1FzUm9OMk5TeVhFMXVuNHFoWU1jZlRqQmh0T1JqUTRZdE8vYmMy?=
 =?utf-8?B?TDM4bWtyUG9yMTRGQm14cDBxblAySHk1MVFUdkFVUzIzUTI1YnNrdVJGc2Yv?=
 =?utf-8?B?dGNXalpBNWVyNUlqN1dMVVpKdVdhRVFXMmt2VWlaMHRUaEk5NmNwYlQra3Ay?=
 =?utf-8?B?ei9JUHBKWThqODNCUUIyMXQzZWFXUEZPUndJNk1BYnVncTNaZzJaU2pwbmhx?=
 =?utf-8?B?ZEFNR1h2NFVReXM1Rkh3MFl0ZWcyQndjZHBkazJMMjZhNDZEY3B4ZWUvcUtU?=
 =?utf-8?B?U1VpcXRxUUN2bmxwMGpUTUY5c0R1c3VLdXorWVhtTVNBM0dQVERuUDNqVUQr?=
 =?utf-8?B?b3pjRENFcDdIaUppSnZvVGtQWVFuck9KVGdsekk0VThzd3pkZUU5Q01PRGxX?=
 =?utf-8?B?MEM5NzN0SExacnczcTNPRGcxZXVpYWdwSndnOWdIS0pUQnFIRnpadTdYdTlR?=
 =?utf-8?B?NXNSMnFZd3Bvc2NYL3lPbXFSY3dYVWs4TnFaOHBlUGFCUlREUHFJd2g5bVkv?=
 =?utf-8?B?TUhOSXQrMEdyTWUrbldHNXVGTnNxWGlnSFFPZ1pBQzlrREZtR2FTc3hFQmNW?=
 =?utf-8?B?bFpPN2lhN2k2dFlHNVBxMG5QQlViSHhZVW5VNnNpK0ZkWnlRMm53Sjc0Zm12?=
 =?utf-8?B?SUZRazlsK0J2WDlibnhzQ3BJQVAxamc3VmJVd1J3Q3BtQ1B5a1lqRFAveTdh?=
 =?utf-8?B?WXJIckJRMUtKN0ZVc0J6T0pnbERDUHlET2VpdzJNY0JJQ2o1VUMvdmZhakF6?=
 =?utf-8?B?aUY5KzhRRTZhSUhMS2cySFVWd2xmSUNUWWg3dEt6OUViQUR1TnhXVU42Vys4?=
 =?utf-8?B?SGV0ZFJTS1pwTU0yZWdQUzA0dXczckE5Z0dEOWlZdFk1MkJhTit3RWFtTzc0?=
 =?utf-8?B?YVJNenFzYmxrRkwzd1BlbnE1UFFsdGFHRXZZbUVmMmpha3pPR3BsUzF1Q2M1?=
 =?utf-8?B?bi8rUDJudnA5VEdWeW1IeTZ0SThjMDVJWVdSUXJsa3lCbm5LOGtOS0tiNmU3?=
 =?utf-8?B?MGJmWE5UcTBIcFJtWXhPcFNpZyt4d0VNOFRKN2Myc0puNFdneDY3Q01RZVlT?=
 =?utf-8?B?LzFzNEI1NTNkVmxaa1FENERFcWVlZ2k3SnY1TlMwejJZY0VRWHJpcE9pMUxK?=
 =?utf-8?B?NkYyN2h6VWZjUmRjeVNQK2pmSU1LNmtHQzJiQXRGMXVMVUpHNnF0MlBPK01T?=
 =?utf-8?B?dEVjRmNGdE51UTFwU2J0cDZYUTBQWlpHcHZuN0NaekZoL1l2aXl4N3JGLzVE?=
 =?utf-8?B?N1d1OUVFdkZIdHEvei9HSnRVZCtQMTk2ZGVod3RubWdOcjZxTUdPVWp2SHBR?=
 =?utf-8?B?bmJlRlJEM0gyM0JhWTJWTmx4a3NqSklyOXpQdmtCU0diUGlKdW1RSWtRS1pV?=
 =?utf-8?B?bDBuSU14NkluWUZXUWZ2QVRaaDB1Wjd5bVlHZ0NLZmhCNHNyakRpMktnTzVi?=
 =?utf-8?B?eWU0eGJKOURHeHMzRTg0cXZVYjgvNkI2aVNxZGRGQ2I0NnlrZ3FKME0yQVJq?=
 =?utf-8?B?SlVpMWpJcVhhS2ZvV2U5UG1lRVZBVlh1QlMvVmhhUDJnM1VUNTZwOVJhMFJT?=
 =?utf-8?B?NEk0YkdBR2tuNi8wLzR2aWZ0bUhaWWtLOVhaMEROK0pZZXArVnBzMHA2d0hv?=
 =?utf-8?B?aC82amZVR25ENks0ZzZtQnNSdDllVlQ5a0hXQ1NBZXN2QWZQbFB5cWFITmlx?=
 =?utf-8?B?Q1dkVGhjOENOSm9lWFpCRHE1Z3h4NEFBWVNPNmkybXRGN3hnTENRQURla05B?=
 =?utf-8?Q?wPYvcrGorB2dj9Wo=3D?=
X-Exchange-RoutingPolicyChecked:
	N9DpTveLlzRG3qCYgh84SF6SJojALBApK2xOmmzmh1kcOyEvmry+SxBU7YhABmPE4lJRWEHScOVqDiMjUSgyO66ISHzIIEvCThXGAmSnDnr5eWbHU6z/SX3jlmNadujVnHulQ5JJilVDRj68Q2XZb28mLjLRqJgW8a0vKWljcvT43nEWqOXKDG+ozoWmX/xr4r/JdB2R6bZ3abawRhKhScjcVf0agu60jnfCWCkKnGOKLSIhhHmfNprFkxWm700Cf4X5WPhmjuS3dDbZty42HvmKPNzrpt7AJRovBquqhPzgYblRdR4glRY0d9ItIllz/Vien/H6nGp9ekn7S0p8Dg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dSLpTL5CQsgZR21IB5eLFjGdjMnmx2VibdWfjupLPdEMzbxBBNPP0JsTfhzh7X6jxBVT6kVtw7YuFc2sDVG+H5y/xHcrLPC6GYJxU2Q3NrNIKBgoqS5gFsmBhTkNMk15kxqHJKK1H7c9pjXCkR/1O0RDmWaJz/YVBHZsa1q8VzvAMEtF5Zr+C1j6DqV0dT2cf+e6x+RAPxynBSVAIsjMWLgv1r6G8pty0Lo5Kmi/R/cWLRkCWxcWaIKMFLaO7n+rSgffN7HfGJaDNrnvax76Oo31+PnXifbpQXk+WUv6hDGaokMXIDTPWiWxp9TXahc/5tagJ3cCB21U/Bn9nHN4bywMt7tgBIpHv6JMLHDSfxh/L3aUprisevJ8VepVgpV6/UuR7SP6r9829587btgVBhsDA4V7DrcDNzZDLEr/Bxupn8LpVyxbREnE3whIMRqqR+/CN5oWrFfXCZ60MRA26OrRcY3xLWKaR9QN1W9VjIXZ4DnnwphVWJ6mwSB7gYoD/o8aF2nAHx+dJ6yQjBGEFtu4f9hcVFazPq05eFhW21HiXsJUTRHem+0mL1K6dG7WJpTRRlpQGd7Ueg/QFBtPvg9cisQDfSgH8KVKNO1A4UY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d8b3c0-2c6a-4a29-4786-08dee26426de
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 11:28:11.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okT3Oufr6GoJ3mnQdQ61IWB8uV0GbDleocOiCTPj6Sc4WBvPYz4WYMofO3bi3/r3Tlt8uLy+ae/PHlM/fIWzpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=853
 malwarescore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607150113
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDExMyBTYWx0ZWRfX306mifs/oYfZ
 i4CpHHfNnHN2ouxUQAtoJ+nrzZDrRigoKb6d575KeY1ZYUDFXgU9GIcXUKp4IxbN4+rm55ZVFLH
 oFBQLy+idGyBQBy/CTIhHqihRm4UMFNuNQpjTe8Bi85lOj06zZghwT2Og/wxGyG184FQ4qwMIbO
 W0bx2kT8yTYrHYptPBi0GkRdT9wwNRI6fjA2YiASfEk5IRzWqKAnS6Tu+irQUfVLRR5NOdZsBVT
 Npbb6BWshdEH9iksYudAh6HlA6k1dsyhiu6W2pO7aMRAP+C3bXCqtgryRScDjK4gRIj5b6cphM/
 DurjCnxc8JXbQNoMDsqiepZ5i4po4NbhC/mey/0CbC4EO2m93epi3izgE2Iqpw1fNtSciPItXJW
 pPT1woIxuBYGmO2qJsplGg8fWCS5c6v98m8oQXc0X2lT/RYuxa1tbI7Mqbt0tjKzsJyk7IXwUxe
 G10FErgGuo2ZlTsTIpQ==
X-Authority-Analysis: v=2.4 cv=GcknWwXL c=1 sm=1 tr=0 ts=6a576ecf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=qysrUgcoccCelITg0qcA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: R38AjOrOvIFwlYQLwDg7X9wqyYfjaXWk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDExMyBTYWx0ZWRfX1ji+SccMF3ep
 0i4net3czfw82MEnmDAPz70ARFCWAReUTW3foTB6HZKgJJh2WLURGoPZewzdieAJ4gpWKeWYJJ4
 tJ/ejPe9m3Ts0lIb58MHgAeuzEu0iky7aw4HWfLP+g8qhc5lruUG
X-Proofpoint-ORIG-GUID: R38AjOrOvIFwlYQLwDg7X9wqyYfjaXWk

On 07/07/2026 10:18, John Garry wrote:
>>
>>> +    mutex_lock(&sd_mpath_disks_lock);
>>> +    sd_mpath_disk->disk_count--;
>>> +    if (!sd_mpath_disk->disk_count && 
>>> mpath_can_remove_head(mpath_head)) {
>>> +        list_del_init(&sd_mpath_disk->entry);
>>> +        remove = true;
>>> +    }
>>> +    mutex_unlock(&sd_mpath_disks_lock);
>>> +    mpath_remove_sysfs_link(mpath_device);
>>> +    mpath_device->disk = NULL;
>>> +
>>> +    if (remove) {
>>> +        device_del(&sd_mpath_disk->dev);
>>> +        mpath_remove_disk(mpath_head);
>>> +    }
>>> +    sd_mpath_put_disk(sd_mpath_disk);
>>> +}
>>> +
>>> +static void sd_mpath_remove_head(struct scsi_mpath_head 
>>> *scsi_mpath_head)
>>> +{
>>> +    struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>>> +    struct sd_mpath_disk *sd_mpath_disk;
>>> +    struct device *dev = &scsi_mpath_head->dev;
>>> +
>>> +    mutex_lock(&sd_mpath_disks_lock);
>>> +    sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
>>> +    if (!sd_mpath_disk) {
>>> +        dev_warn(dev, "could not find mpath disk\n");
>>> +        mutex_unlock(&sd_mpath_disks_lock);
>>> +        return;
>>> +    }
>>> +
>>> +    list_del_init(&sd_mpath_disk->entry);
>>> +    mutex_unlock(&sd_mpath_disks_lock);
>>> +
>>> +    device_del(&sd_mpath_disk->dev);
>>> +    mpath_remove_disk(mpath_head);
>>
>> [Severity: High]
>> Can this lead to a double-free or sysfs splat if sd_mpath_remove() and
>> sd_mpath_remove_head() run concurrently?
>>
>> If disk_count drops to 0 inside sd_mpath_remove(), it sets remove = true,
>> drops the lock, and unconditionally calls device_del() and
>> mpath_remove_disk().

It also removes the sd_mpath_disk entry from the list of sd_mpath_disks 
under the lock.

>>
>> Concurrently, sd_mpath_remove_head() could acquire the lock, remove 
>> the entry,

It will not be able to find the entry as it has been deleted (above) and 
then just bail out - see "could not find mpath disk" print

>> drop the lock, and also unconditionally call device_del() and
>> mpath_remove_disk() on the same device without mutual exclusion.
> 
> I'll check this.

