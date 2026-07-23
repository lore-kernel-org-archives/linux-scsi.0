Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AE5472F62;
	Thu, 23 Jul 2026 11:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806266; cv=fail; b=IA4DHR3y+mdK8LBNU+ujOqjjRVN+QWVwNkOOLawOKCrT6LxQZR2jqVwVWMXpljjEo4xcIiAuavWNM38nuHqJLjNHtnjyK7XWvatHSawHYYrSlBAsbisyaY9mgk/A0r8Zjb686twTW6jyCyareh87r5od9nlOuNh+CZbvP21VnU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806266; c=relaxed/simple;
	bh=q2v47KcaKUj43qZfX/2kKvanqj3woBbHbTXy3x3h7ME=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KwgDGMOqmoIfGGZXmAxpnFIUsqhvlgISYL8NITvXwH6sW4QfA0YenltlsAiKYDJN/amJEmdNGT1cTEiSnl/ylKJ/x+0lnOaONW/vNr7EEz2SI1ndwD98PhUvrsbmEMoZ+5xY8O4ei0QBecxbmOQGjVKx+4YRdTtuT8GhbtIfvo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WOfY1HmU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a9pH1IAt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WOfY1HmU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a9pH1IAt"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N0J9L54025196;
	Thu, 23 Jul 2026 11:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RGo6itFOkOxkksFZdbqn/k6i4jJt8XZRhZwHFwqZCFs=; b=
	WOfY1HmUcrD40gyuxbDwUcnmwGNxKVQ4HBx0Yk9fbShbXpe7izUzyt5EqFh18UL9
	QFLfuZ0d4eip7r3EY+h2S69B8gXmJzB6eJa3+CiPoGEySliQ20retTSONfKgxYH+
	qcj/N7w6fVwx0GvFi+E+tNyG6xEfcDMgEqcQoADO7i81XFPl6aN8ptsvfR99Wzek
	7k6l3R1PXzIqPbXi8770BhK0pm+Gmy6FRU7j9DqVqUI+T8ZeB1gAty7JFiBowX/Q
	8g5YkoQfe+MStm2nmJQ2zDgWNy8QGLhBZ3/FmP/nzhAX6YWYTyVxSl2ftw52G9KT
	gboPf9jtZxePmjiChRWehQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqptwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:31:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NBNA3v021733;
	Thu, 23 Jul 2026 11:31:02 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxeqwsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:31:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kyVT/PoapgFPrujVHK+td79/HsUUwrHLt28kM5K7jsATMwdQIGHHBjoOTgisPfmUKS7vCbByDC45Y9Bao7zDnkkjCY9VaEdoiP2hD34XogGh5uOapgkFt492dQDeeuH6vPnE9MKjt+aK/aPDHstqE3EYs7rmyi9KgEdbYNpUARALATpCSkQpNNOONE8QnxV9rhSgOwv1GxrssXlKDaIilQl7SvdF/YGkGYre/zzbeIZpyzYYucqs/62Z7f6YhimduySwmLiVK0LOxT9SllJM20X55A1/gQg2ZWQZu72iblDL7zNLrxw5fjvVHY5qPBW7Co0Urvq5Lg3j2wC8jGRvdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGo6itFOkOxkksFZdbqn/k6i4jJt8XZRhZwHFwqZCFs=;
 b=AIPBAhlJCKfCkxgYAh0erD7Y3ij6BaTmz9Pnv6Qusd2vXUU5FF5syfFXKYvLlFe7C689ZbBjsBFsWRw2BHIHXWSpfvdk/dmyH8ebomtIsjqwkbkelizurptNVBrIFujbwU/fZVUi82C6vPPI8KejoXygg8UXpPVzrCg9GYzto0k7ZIvfIcX118gubnn5lRowvyVst88iQGRRdVRDz9u3N8sL9QbvuL6ncw1lnmcjZWqcv+Uu2Jfu5EeM/OJXWg2e0oIVnS/X4hRx0iEnQR4bVERbyw5oohcehDGEimkhbnNWfgTpDhbqJ025XRi3bF4dtBqq21qJ/OQ3RZxlJ6+z/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGo6itFOkOxkksFZdbqn/k6i4jJt8XZRhZwHFwqZCFs=;
 b=a9pH1IAtwjwQKW+XDbGmR7RH4H3gO1jYXEe6ljOB6ijMOPih6ZSU8sUQqA80FSjD6SeOCRM5glNhhNRLD2ULAxx6O8RrxHJJLkakSJZSp1COMaNwufOR2ZMhiMzMJ4PnkMzZH1SDS5NT1AKVQOjQJ1VAANo3h1i094GsqNg8C5M=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by CH9PR10MB997856.namprd10.prod.outlook.com (2603:10b6:610:345::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:31:00 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:31:00 +0000
Message-ID: <3cadc61e-25d1-460c-912f-7ab4903c5fbc@oracle.com>
Date: Thu, 23 Jul 2026 12:30:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 26/28] scsi: sd: add mpath_dev file
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-27-john.g.garry@oracle.com>
 <20260723110737.D313D1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723110737.D313D1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0105.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::20) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|CH9PR10MB997856:EE_
X-MS-Office365-Filtering-Correlation-Id: 6649e0ca-2a0c-4209-39f8-08dee8addedf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	k6n36juV8ScfMCoeznFBxlaeKR2Mf6YHj3YNs3iqDub1RyAalwlA7YuwKXGQMDi9DI265JVaXCEy9JnMyojSZgAlwGTOL8R9kk7miyyWyjMjc0qfJz8b0LL48ZazSSdv8dj3btU2uIklLmVlcWqOhMkIF5DKFUj5d4QtRVrFJQVxtmdvs6ODrqSax9E9Z6eGLwUkOq9MqMo2bL37/OiZ5Xl3VocdS8ti828biKQ9Vwyt3Wq+OUY8LY7W09a9oxWbaqpzwZ2NG7mGfOXa37KMEdeQ/x3SNO2VzI0LtnQAgtIvJlR5/WpK594+rXM3FgFyLj1OobtF/huhG2GV7GWxwSkj06cYEQ6pHymYVsXyzP5DYw6kSaqMC8s3MhXhvwMwydstntxI3JajzecKumY+j1ALtSooPqbBmPtpAu/mZSyw4QNS8v+aMCCAaayDs0PCcuFBOwV99Z0+P9upi6frS9LnHPOY/x37DEMKlmgZVwRODW210VrP3a/swXrsLHto85bMI8zaLCUGWeVI2a04ZF96UoV2sNngEKOf1qJd9q98+Mzds6t054Gt0r5SZq1OHOTvSBh7hTMSL4WeSHvcLMsx+5mk1F93fnCdteB4lYjWQV+ZFoQADR3HambeQnq+syrwerhe9U+sr+80UjekMkbsz2UHEiqon3DJxOTjFi8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmJES3NOTHdQdjlBNUhVSTVIMWZCOGVDZ0lmd0dtNjkzNHBQVzBSZkZjK2NO?=
 =?utf-8?B?N3Q2VVMrQWlrWTlqVXhCSjVJRU9mU0NvaWlNS0k0V0dCVnQ4bExtd1UyQndW?=
 =?utf-8?B?NXM1QTU5UGloVUVxUzdkMVZoYXVITjdwSi9idjhTQjdnb3ErUFpUclMzTWRr?=
 =?utf-8?B?SWFoSjVQOUY4Rmh3RWxjN0ZNS1ltdmdiZ1NtRFduSjVya0lKclJpN1B1MkNC?=
 =?utf-8?B?b2ptWkVDWkdvNEJROVA4MytkM2c5cmhuRFB2aFRzUE9NZ0Nkc3M5eGZoU1ZR?=
 =?utf-8?B?K1pibjdmL3NkU21ROTZIV29oV00zeGZXTXdKZHFDcmUzTjFEMzI1TUlZQktD?=
 =?utf-8?B?UlFodmVuSmlOUjhEbDB2c0VkUzYwMHJhdXA0bEs4aXZpb0tQbjBLdVllMVpa?=
 =?utf-8?B?Tkg1TnRqV1JITGRXWWVSYVJSRHJYMFJUUDlDZkp4UWwxQzNicHJtSXR1Vlk4?=
 =?utf-8?B?aUNMMzBLa2NHVm44VWZsSEMzak4zQUNnSW5ucmloU1ozdGZpeFM0SlhCM3Nr?=
 =?utf-8?B?bElEZmVNS0laaFhHVnY2KzEzTlUwRDVFNHprUzBVMk81aFM3bDl5WDB3aW9m?=
 =?utf-8?B?TGkzckhUenJXdGNHY05qbjJQSDhIaURkQ0RTSWFhbEtaVVBqeUV4Z2ErZldu?=
 =?utf-8?B?U0xhYVZXRlRTU2ltNGhiV1Y0eE5SWGkxNGRuelBXaGFlOTVvdUdUbkdVZnpO?=
 =?utf-8?B?VFNJSk9ielJUdnF3bUczZEhUcmlDOGJVYzRHQjhlM1k1OXFiY2tjSktpenJs?=
 =?utf-8?B?SWUxNFV6aXA5eERsNEhOUTFJYTFBRWI3cEhFWVora2pWVG1VREZLa3dMSkth?=
 =?utf-8?B?ZUZaNVU3N3VtQ0twRklHTFlUUlFGWEdBbmZrOFVNRVdWYVRteGozVjdsYjdD?=
 =?utf-8?B?SlhTamY3K1V0SzhLaWVVVS96QTZmMVZUYkhxc2ZjelhkbHMxRFpPZVo3cHJY?=
 =?utf-8?B?Q3MwQVF2ZTI5dFBoYWZxYjZPYW1oRm1JbWVZSFRvVmZSSlVFdnJiM0E1dWdP?=
 =?utf-8?B?ZVhvTDQyK0kwUEhiSGVodloxVzQxdVlQbHMyRFZRWGkxNDZ6VUJOY28xMUo5?=
 =?utf-8?B?Z0FhNFdxa2ZrWkZuaFpEc09rWlJNVUViZitaUmZlN1Z0STFqWkZIU1VzVTJa?=
 =?utf-8?B?ZlljOEtsTTZ4enJQeHpJS0RQWlJtMithM0RTcWltTS9uQUJsK0Q5akhVU2to?=
 =?utf-8?B?cnZabUxTQWlvdlJnakFFenFLTVZsOTkyemx5TDZOTmxzQ29yNTl4aTZRSXA2?=
 =?utf-8?B?RHM2RWltT0FHREE5bS8rZm82aTlWUi9XbEtEMzFvL3JHS1I1VDh0WVE3VlFR?=
 =?utf-8?B?Wm4rTVByT0haN0RPNDU5eEprUmpMc0d2alZEdytWcVNlS3BEZDVzWXU4UWFw?=
 =?utf-8?B?WUhQZXVPWStEU2x4c0tYcTgxcmFKWEhHZkZpUkRydDgwTk9GRjlxUm9oWFln?=
 =?utf-8?B?ZzdkUTM2QjNzMWgvM3lRNlJHK3JOWlhPYjJrZ1RwQ0tKRm9tYzU3dWdsK3Zr?=
 =?utf-8?B?TTU0KzFjdTJvT1B2eUpSeFFvL2NvUVZWakdvNUhXd0U2V0lZUWx4eFdITmUv?=
 =?utf-8?B?TmsvMmdEank5MHoyNExyS1JNRkFtc3RYVmE1ZEYrWXh5Ymd0SkN5WW9XcC9Q?=
 =?utf-8?B?REgwTFNldFZvUklYWVRVVU1yaytJLzA1V3R1TUpoOUs0TW9wVXN6R28wcFBx?=
 =?utf-8?B?aDcrV2NZa2pKZUhFakkrYTlqUll2TElTeStUQ0FiTnIwV3JadEFpOWZ5YnYy?=
 =?utf-8?B?UHQ4TGE0QTFMRTc1RWYvNC9hMHdjdDllcUlta2lkdTg2ZlFtYVBpaGVENlN5?=
 =?utf-8?B?dW00L20yTkFON1pubzVrQ3pqd0lIcHJMT2YxWDRuZzh2eC9yckEvTHRyVTBF?=
 =?utf-8?B?aWx0dkhEejBGajFIcTRBTE02RHNwaEZ1OVEyWFFEUTZhV2ZSeVBaLzQzTXg3?=
 =?utf-8?B?WkhES000cGtoWHVWdHNITEdtUHVZbDV2b0s5V2l3ME55bThwakVOOW9HMzBU?=
 =?utf-8?B?NHNFWDR4eUxMMTBJTGE2VHd5OUVqVmNQUHRWM0JKTENsRUpDWVA1VUJVTnZL?=
 =?utf-8?B?WElKb3lwMWNjOXhsaUxvUThvUFlKNXhQbHM3bHk3T3BKYlFpbjZ1SUVmZ3ZW?=
 =?utf-8?B?S2hLdEtPMS94OEdUU0t0bGVzelRTMHhaaFVLZGMwRkNZM3F2VkRtUmJudjln?=
 =?utf-8?B?SVZsdjR6WGUwRUlaZGJza3VpVEN3dVBHN1VPTWxvZWhTMEVrS25rUjhkYjJQ?=
 =?utf-8?B?bVhvcklYRGVJSlFvbkJEbnh0WnNwY2tQMjhBTDdDbnlLWjNuTGRkaUhXVWJX?=
 =?utf-8?B?b2Q1cDhIMG1Cc2pjeGNtbjUzaFFTNDNrMzNROUpVaDc3M2ZhSmMySWJ5Yk9l?=
 =?utf-8?Q?0eUCDBuL9M/THEcA=3D?=
X-Exchange-RoutingPolicyChecked:
	j+W+7/5H2NLZRjcV1uOzKlRQR9H48qXNKv5r037irajkH1KV3hX3DLyiNn2Vw/cs/jRTN9saZ9DyAQQ8gLeQM9OsV7wi8zL6hdVSyH7Bh6gj00tZmx6xIYHfqWZn9swI6Hy8NJBlYfEiUNSbB/AlVb2cE9GUu5zODy5xiLWXQNpAahOI11Y4zn/XVz7ZFmB/FdICipjsW1RyRCsN7Qr7mRxBjQ3Dddq7mB6RW9Z5MEKQPDhaOfLZc1zv3Glx6jfwdONbShrzDMvYyij5AH7YKWO2gr/QWwFOLqlst7C7lF/7vv0dUzZTngMH3O9Imlbyky1JiMMTfjzThXonua3AvQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4yqyspyNA2QAWTovVOK9N3ybSJayJK9ERTUHhQitPYgnmjELPA3w1mdEhMCGdXDVGc0UDTg4XTRpOg97N9Y8nYuEoywJ8CZyBQkFYv0muJpfgYDPBFmhHR1EJ5RKFdv1usc1qK5sY5MIfVao+OLLQY6Z78hPe59m5IY0UxbS/cX1Hczlw2yesaWM2w+pZbskABhrthjDpwFgiYeZbWJBZnZ0Sz0KDUb+G3asog4gGQuEPmfSPqw9tmEvnz6p9xKvwc2QpKOWey1980GtP37JNEKhjH1xy8vbANiFyRNrADnf6SJKtyN/9g4o/MKSWXkjxEtDv+DNNrXAgt9Jq4IOm0uNJR9JIWoFD/ijAB3r1DuQu0VeHJmibmC2KsorgZ3qb+tYpzO10pJEsycpcF1gax/g/JQlEjQ+Fr4Ba0P07EtbcyZRaeqpK5pBnNQenHJIjhQ0TACGcxGcwGs/ndqbXrPmwagQm/awESUZD4xmGdBNG9LrmIPGeyXDsCB1e55y9aMPz10jvPDr2vZ1/+c5Dh/KoYxzyWwwSzbzu5l4UJQ/GqlhEuqTHIHWnPoehgp53l4huXyalp0mxv7kLlqdAKWOs1fZc/eAwJsY5PLuN2I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6649e0ca-2a0c-4209-39f8-08dee8addedf
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:31:00.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJXcuil96KyUtD+iAE/w9r+04uY5Ln/45xWLe0J0rgcZRMsSY+sX7f0Iyd4p+uqHJpIsrZZYdob3U8h7mMwLrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997856
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230112
X-Proofpoint-ORIG-GUID: uizVYa9PhpzGNZ7SE__YqCGDhO2P9v0v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDExMyBTYWx0ZWRfXymL+QSQSWpGy
 v4L3zAP9yzAEdf5FWrZvQwpJ1CUxl35XF4CER9H5U2L5LMjjsCe8hzcLJWcFMNj5JeHCnbIEudH
 TCtUIN2dNQIhG/fYQVIuYbPIVluRYeJy99PtJohNYxHkBsF3FgirBU0fIFnnmHUK8P6GaWekyym
 b+YUpUEmvY/G6ogBx2DsUPnIAPZ98R+N2htgoLYQgvoToSPPgeewBVhXst8R/nIGs5jOyTz76SX
 ZpVYGBW+d564Ma1BTcMhk6XPakL4hJAU+sfrxuyvnzBjG8Rxxc2A2kcyp6DedyNDhTA/JaSKje7
 3XVjS3fiEi20gDu9XQsFwtR/zlt8K0ato0wet2M1R/uqcewGiT+AiXOrqvLimqH1kzC7hVWlKwG
 mi+B+3+7Hike9zMl0BCodJzygrPFYoQtLaxSiCobv08pher7VtGC6il0/yVD0xgPJHrtDPVnpmy
 9IsOrmwtk4afMY/nWLA==
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61fb77 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=ve3NZVQUfVgnLGR_-usA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: uizVYa9PhpzGNZ7SE__YqCGDhO2P9v0v
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDExMyBTYWx0ZWRfX9rrAL70vrnC0
 PBLAhynrPkgSLVHeV2cRGkcqWDW9BC++yk+KG5ZYFnS5XTUQWZtAPW0PgapIr/vkVhcW1S1mbG3
 QzF6BtxSs1U6tBeoViomuwRQi4ocHDZ6MyPyCcO028Np9vz+M8Oh

On 23/07/2026 12:07, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Reading the `mpath_dev` sysfs attribute can cause a use-after-free of the multipath `gendisk` and `scsi_mpath_head` objects during SCSI path removal.
> --
> 
> --- Patch [26]: [PATCH v4 26/28] scsi: sd: add mpath_dev file ---
> commit 4a0e7acbc6d2b78e6b014dfe6924983c812cc80e
> Author: John Garry <john.g.garry@oracle.com>
> scsi: sd: add mpath_dev file
> 
> This commit adds a mpath_dev file so the multipath disk can be looked up
> from the per-path gendisk directory. This allows utilities like lsscsi to
> find the multipath disk even when the gendisk for the per-path scsi_device
> is missing.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index d5a37b1b312c3..f8c9096e6c43c 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> [ ... ]
>> @@ -4059,6 +4059,53 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
>>   
>>   	return ret;
>>   }
>> +
>> +static ssize_t sd_mpath_dev_show(struct device *dev,
>> +			struct device_attribute *attr, char *page)
>> +{
>> +	struct gendisk *gd = dev_to_disk(dev);
>> +	struct scsi_disk *sdkp = gd->private_data;
>> +	struct scsi_device *sdev = sdkp->device;
>> +	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
>> +	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +	struct gendisk *disk = mpath_head->disk;
> 
> [Severity: High]
> Can a concurrent read of this sysfs file cause a use-after-free during device
> removal?
> 
> Looking at sd_remove() in drivers/scsi/sd.c, it tears down the multipath
> structures before removing the sysfs interfaces:
> 
> sd_remove() {
>      if (sdp->scsi_mpath_dev)
>          sd_mpath_remove(sdkp);
>      ...
>      device_del(&sdkp->disk_dev);
>      del_gendisk(sdkp->disk);
> }
> 
> Since del_gendisk() happens after sd_mpath_remove(), there is a window where
> the mpath_dev sysfs file is still accessible but the underlying multipath
> structures have been freed.
> 
> Could an unprivileged user read the mpath_dev file during this window and
> dereference freed memory for scsi_mpath_head and mpath_head->disk?

will check


> 
>> +	struct device *disk_dev = disk_to_dev(disk);
>> +
>> +	return print_dev_t(page, disk_dev->devt);
>> +}
> 

