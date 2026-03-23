Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C338AC9C;
	Mon, 23 Mar 2026 10:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262029; cv=fail; b=RzCU+9l0KFuWeWoNEuKBIVdp3amhz1MBXzJpWr/fiZ4JyZWpjoUxbdDhQd+gkmc4pGqZ6kILe8FV26OoOhhdQVUQQvZUptsRmRCDGG92vvnsVl7Up4pcTLjTL4pvbqFQ6YqVWdiTZqNNXskt49V+bKoUOp0q5QHcxYnstXFlh58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262029; c=relaxed/simple;
	bh=MGEnvKOjLmXJXHWWAQllL2dJ9nTdB4qY3qlVaCUb9v8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fP5MhqMUA8sqIAZKW5mSE15ys9ldeOeLcHP4pxKa7MYCVNNOM1KylH00C9Xmmq+hOdpmiWAtYAIJ8vo/d1aSwRyB1ip1mgmwEJgO7LyNFpeTxZ0a2Id3CbVfHPvMQ/UflMIQkZMW4F6LYs4vKBmgY7G/SebO+KGjTtO48cIv7PM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d1M876uV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=choqLUNz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d1M876uV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="choqLUNz"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MNvFtW1715691;
	Mon, 23 Mar 2026 10:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3WYOuZrmSxsXGsRkD9/nwtveLoZduJ+fGtYCLrYTzDQ=; b=
	d1M876uVLiwc0Dc3UxRLh1ffgwF5jD9rieVss5xbXmOdPsUXpd9joB/oNVJJHJFb
	chfgZsVfjKDp1dnh6d0yJ4KExlSZ0sNQTOEA8R3VFBKAY/InFkiL6EXJgcTAP6cp
	O2RcgfYI8cQdtz/9qyLoXESjf6k3C7PbwTDSb3+cfs6LSnm4gjjMGINjKvpE93ZP
	k/HvVwExuHmcTjzM72cRjvjx+bDp3k38EtIIJy+JibKdd9ff/xhJKt1H7gBlea/k
	nXebkQfNzVQG/5UiuC4osLEcbZkdeY91BarKMAHEu0BrHOiww17gDS/tXY+XPH95
	acS/orzvLPzS9R3A5Y0aVQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kgfhyg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 10:33:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62N8mO57029002;
	Mon, 23 Mar 2026 10:33:39 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011049.outbound.protection.outlook.com [52.101.57.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8a54f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 10:33:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bSarVQ4QWEzaZrcow01ZZEB7moxdyR6EQhab/jD5il9dxvPUP/NuIxG3CKU95D9+3dcZkPg/PQ51cbC1BKFb82e+poubvYha8VY2CBgDX0kKM4yPB7qHENHWDBIyyBLg33tEjblL/YFkTu2Ygff/VEnooDGwqzFglu9JYX8TERbb1u46tLPjsNIYoNgnJCMLHaYXb7I//R/ihHaI7vNHfQWzUQ/Rn8hZyPr9fZ0xg1Dn2OUovyNtJvrKeQvGU4cP3xTq0AHnIveXl4JftU3UhCeiC9P3VTZ7v0XcvxETsEdJSi6ozun1VBRd1TokNaE/O9MPtddiasA8jFQQ9CPFow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WYOuZrmSxsXGsRkD9/nwtveLoZduJ+fGtYCLrYTzDQ=;
 b=P5FY66mdKOcaf69W2c/z3RsjTVhyWgH1/ECkuYu4uGULwVSNAtrXjfuizj0YTa3NTDUrPuFcAeFzwEZT7tFJ7S5UA3NMeP7K9ghSj+4xLmx3fTYFeuNy+pqey+b4SsAp8APsA1VO8gjllEkttGj+pT2bkqFnPqAhDnXya5J70eZdUK3j0t/PeX5ScojoADKmoLyo29nPGYNYbzqoL89BueB8uG+3797UyG+dKxuy4H9BQ3LxfuHWVx07N3MEorJh31y0lt7YyYoiNXRfdFN/qamC2BtLmW0SJHP6fossA9C3F17kY/peLNWZBUVGRAgq2LcvP2dP+GDNqcIpXCLgeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WYOuZrmSxsXGsRkD9/nwtveLoZduJ+fGtYCLrYTzDQ=;
 b=choqLUNz73HAQ5Y4KJpI0BD7VV+5dmLu65jevEOTHauma1VSrHQeBoHAnkF1cWg4PVNw4J1l80090YkauuK7aKExdSX3AY6LSE6H7FnLzL4XyJSifQKiC6/0f13Q0TzQ1b/1Qki//LGhBY6JXTdk5jBJ9cXpVezqb4rpWZ2EhXQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB4909.namprd10.prod.outlook.com
 (2603:10b6:5:3b0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 10:33:15 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 10:33:15 +0000
Message-ID: <470edb84-1621-41e4-b172-91f9388a813b@oracle.com>
Date: Mon, 23 Mar 2026 10:33:12 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] scsi: scsi_dh_alua: Delete alua_port_group
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-2-john.g.garry@oracle.com>
 <acCEmFgVgxr8qx39@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acCEmFgVgxr8qx39@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0396.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::23) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB4909:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b5714ef-2fc1-4c98-bc45-08de88c79771
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ACvgXIjGrnLB7FtWh+hsE1/twIh3fMJG7+saGgvDAPXtekYQEAlkyWuobTpvJ5v/6+JDwVZx4foetcZ1Cps9Dvkg1httEBZNzqa/nyMDKZdySlntsUcknfyQxZ/hK+R1o3eZv1wYTokQv7QI6Gi/Fapkv3GoEwat/c1uZwYb0imxps/dphU9oUU3REpwDFtKNsJGlL45qNCK5rCbmAwf7rUs9yQ9LjfdfoJ25f74c4b56r0tFAZNyWbDynATl4+f37Y6eOkYmlHxT1KiJmsMXGDSup+HoGkW4BYRsL3O8Ijtfov4QFr9qh8QPMOS/SiBG986KYMgrK+xWDaXfCzcsxVQ4D4xhaSiG7poDfTR+5Dvbo7qrQrOxdfRixe1cwdRDhIBnER7RqDd4YdjFQndM0QgeNxrSXpvgmN9Et2KJdPrIRoj1uyW9CzjhW39gjOpHLm2GwZ1wqfoSwKzIRXU1bdPybc6kC7UqhO6EHfsgD/XO3x/voqWicgXkjRkkjTSxZ5TswgfYjFdy2zY1Uuf8PYx+MBuhn3SdMy8A+tC9YjXvPYaN9lI+fAkVzAKWYIj+xODmJtkTNZW/iG7nQklYjJ76Y02Dzd69X84AcAYe7+Wp+U2po/cJWyBGnOsHYF/uK22gFqNO/ACHKSRFwpS6NBuuJpvAm8Q9XBH9vjBZ3dDDeClxdhPmjakW6q4JwgRnA1MKP1ktgHUE2Px1MYjDCsLp9t1gpRP6ug2BSHzOMw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlU2RDNRMHh0MzVTV3FPN2MvQUVGTmQrNDE5RzFOcmtxQnhZWmFnZ2JsTmR3?=
 =?utf-8?B?RDQxTWxPWWx3SUJNWjNtb1ZCeWpWblI1UjVhWUNSNkFWUjAzdkU5NEJoY0R6?=
 =?utf-8?B?ZUc5d3M0REF4ZTd1blJVVlhZdXJYTFRQY3dHZnk0OUhEZldhbzEzcm4rRmRW?=
 =?utf-8?B?M2JUYXp0VnNYY0tiaGpaVFNQVHA3MkxSTnZBSGJFSE1tT01rUW9laENBZmV4?=
 =?utf-8?B?SUJWWnBrRmV0OWJOYnNLbVJodFAyd21pdzRwUDAzSm12aU1SVDM2ZEtKVTVW?=
 =?utf-8?B?ck8wZFdRTDlyczZUckg3TUIwUTdueGl2S2JGQk8zTEZlQzRvaGRzZFBnbFll?=
 =?utf-8?B?YUNPdExvSS9aaEc5VWp0NGlRd0FYMCtWQWNWN2dabVd0WWsyV1Q5M1gzMHN4?=
 =?utf-8?B?VUUyRytaN1Rsd2tsdEtMbC91a21zMEVaOEthMUhYek93eWJ1RHoyZU9KaXQy?=
 =?utf-8?B?eFRwMzIzKzhKQ3FDOTExM0xEZ2NicFp0SGxlZEFsSXR4VzYvMlZPR1liYVdk?=
 =?utf-8?B?U1pFaW0vT2hVa1pteStEeE9nTHZseDJUT3dkS0Exb1cvMG1ObTNhZEJVTjFl?=
 =?utf-8?B?VmI0SXA4WGo5NUk1NHhwQ1JaS1ZSMDByeWpuRDdCd255Mmw5aFlzdTZiemVu?=
 =?utf-8?B?cGpGcG5QcTJJdWNXaVNNR0FqQUJ4Q0FXcm4yeVBiRzNNaFVXaVFvcHo5UWRJ?=
 =?utf-8?B?RGFxdmdSZWJzVzVZRkJ4TzV6dFJtUXE0bWk5M2dEd1Jud3M3QjY0QTRzRFdw?=
 =?utf-8?B?Q1hsSWl4N1lXQnlzNUt4cEwrOGlzMktaZTJoQ3d2VzBINS90TkFZTEVUcHM2?=
 =?utf-8?B?YVFVWTN4OEFMNStYS2p6VkErM0JNT1h3LzYwelUwOG1tV3dYU1ZGOVZNdkFv?=
 =?utf-8?B?Q01TcUlDbDBzdnkyQ3EwOVVnNElIQ1lyWG9oZUdBek5qNllxTFJiNnRrcGNT?=
 =?utf-8?B?NkVxais0eGhaS2YyQ3UxTVl1cmZSZlBVSXhucXFkS3VsZUFiWkdOSVVmNWR1?=
 =?utf-8?B?WllDU1JyTXQvdlB1Wm51R09vZWZXWDhrbytJZEFZRFc3QVNzRTRNZmdjVG1C?=
 =?utf-8?B?YnBCL0pKT2tNMDcvNHVPOFR5NnpRa29renBIMW51bjYxR1pLOXdldzBRc0o5?=
 =?utf-8?B?OVpYRS83dks4c3RTei8zLzlJbnR1cFJnQUdZaU5iNEJIR3NTZ0cvUjhhVzZy?=
 =?utf-8?B?TVlXaEdzeXAyNnhQOGpPVWdzQloxTWNZQlhzQmJGRnNPK1ZiTXUrNHNHSnlE?=
 =?utf-8?B?WDlXOCtTSWd1MTdwTlFuVG9CVW5mM2lkWVd2Tk81RUpWM0FvK1RPTzFIaXU3?=
 =?utf-8?B?NW5wYWRGTG9aQVlJb0FwOHorOHZ2c1ZpWXExeWIxejRmRXhjUVRMdzBmWWpq?=
 =?utf-8?B?Q2szY3p0a2dtNG5LTERWRlZFVWR5Qm81UVFrMG1zM2EyZlhYbGxuRWk4OUVu?=
 =?utf-8?B?cGcrcDMreUdBMi9RSzAwWEtmaUg0Tmh3WFhtZk5QeDFQazlSNm9MSHlsakhh?=
 =?utf-8?B?MUxqMTFIOVBIUnhsM3A1NHlIZERuWTBxMlZ5ZHVpak9IZHdFek5LZHRyT0l1?=
 =?utf-8?B?WUtNeUZZcXQyRkNjaENyZFdpMTFreGFKK2RZUEpwTlhOZjN3YnNPTzRVZXdC?=
 =?utf-8?B?aW5BdWMzMldtc25VMDluaGRqZkVvTkRnN3pyd0Y1d0hlWmhyU1JQUzhyZXJT?=
 =?utf-8?B?K1dVR0RkSXoraTNBN1lCUVMvQ0tKQlVSQU95aFZjYUpWYmZJZDNTT3hma051?=
 =?utf-8?B?UGxEN3QyNHNuVXYvK2RBa1UycktqYlhCVmxHYWl6NmtEa3pZL2hJNHovSFZE?=
 =?utf-8?B?SVhJUFhhNXlWMVlUS01leHJkcVlqakIxUlRRQ0o2THBDUXhORUV1cmRlQUlM?=
 =?utf-8?B?NUxPUUxLdVpBTTlRZWk5MVFNaVUvTTV5YWcxRURzWDhoa09BNzQvOU1EZFY2?=
 =?utf-8?B?V2tHbHdsSkt1SU1iQVNreXd3N3kvRFpKRVZWb2dhU0l6YTN0Ly9JOE9NMzJT?=
 =?utf-8?B?bW81Um03Uk43VnVTenpPN3dQamZXVEJ0UlBYVVoxV0N6MWxrR01sL0lWNnYx?=
 =?utf-8?B?Ulg2cmYwMFJlMVNuWFlIZ3E1R2hQNlJ5YUo3RkswbDAwOTZFUlN4MnBSOGR2?=
 =?utf-8?B?Q3ZuVlhuVXIvUHhOZE9US1FWcS9uQ2NsZjhUNlk1Q0FhVDUxM1RwWk1kTFl4?=
 =?utf-8?B?SUV0dzcwbTIzS2hjbWxsVmQ2N016WklJNzdmMXBrQm40WWNYdmlyckQ3Sngw?=
 =?utf-8?B?cnpSRm9ILzd2aUdFM0UrODdJSnV6UEZGVVB1bytLSGw2NDJSNC9xREcwdXNj?=
 =?utf-8?B?ZWo1TTVLejRjZ1hoRG9TVDlHbXFCNWVHelljRWVzd1BxQ3BiQ3I5UT09?=
X-Exchange-RoutingPolicyChecked:
	BSdDSJ7M0Ru6Cu8Lcc90QRXOeBnn514mszHH1/laxWqvKZhsXhrOB9cJQhET2FkIfL6Ca2IDT7B02GU8ON3ZCNwKM9FMA/v82lk3rYOWSc9SEf2BU3NdRgSoIQPpcGlaLMWwYsGcHMEWMp9daraNe0OVhrx4Ife8a3mcxGKSMmjjHWH0leiSgk5njqhsEfKb8Pl6bkW2LAng3Xths2vOA1YPwPxp7Uvwn2+SACnM6Juey1EeUS+O8fqCdtV5gOD84ywqYalFozZVZpCe23QRC7eNeo6JxKx73MfuMW9/5IMMU/T46oNRYZ1QYtdULmCUovmEuz3Ztxlb7wo0C2zeMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WCcCD53tSEtnbq0DHhlQjPkH4SqS4S16rqezMPdGjbdOfhuKcZsCPw8xcCrujvashMnQra2BWa/b41xhSXQg2olKwQhSpCa0hPRuPmq7ToYz05sXsO5vrU2cP5D1R4Vmy/TLMJJcDf4L7ljOI93MKdobiKMWSfygsbm7h5eyJ8qIp5+mSS4GR1//8cqaAn6KcODu36yzs5sZACWk3fXiTr8NANjziOUYvFYOwbA4doC5/5dHfz9AXXozsDKFzHKgVAwdu6/Hbvjt/QWTXVH0S7lJyddl4+Kf1WEgvA7EUTeVmdgjr5WjaU3r0dYApGRRttf39DX4lIWzyM7uw6zIixmu6XfWL54RzCB0oibfNJEhu/sdS3RGWvTIEhYn/F3gGbBsbNoMfXijDzTT+LBnEvrzJa9yx1Kr5LI14DtgaJyVlPGBtk4A/qiKBkwFUvav6DIlgPnc3OyM0siLaxQf7lUoxeR4Cj6CRpx8kkkIMzTySFwMh3wUqTEo8JO9ULMHFGB8mvPe5goBhyQavt9YaxPgkpc2Zmh+vzte+QiXFdIozRy0RhueloGW5V9LH1uWMpxIG0WMM4YtnP9Xn/IjAeK6FTNqiB468hqzey0jvuk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5714ef-2fc1-4c98-bc45-08de88c79771
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 10:33:15.5746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYFwVUzcD2dDt08tbft6VEv4ZwnOuG6IaOtuaUEYGOgWsRcf2geIM2JkfBs+2bHas5NtH7yFpRVyjY12BvMubg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4909
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_03,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230082
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA4MSBTYWx0ZWRfX583H+WhBsDla
 RRkzk0iWWZUpRXEqSO0v1ONNXqOQHiTXQdJqA58uNOkInBZxDCWs/QJmDTfTdNMJhPgOgGgLyPn
 npadvE0yomQ+GlgaqKAQpJwUF4cPEvY+TvKYIY6IOF/daYQNiC8+MIZVhTBwwTCcKnQszeF4NNo
 4ZOAyojYnQT2nmJv9rdlTTkzDUh5c5cJab/iVdVEoL74B4TQIT5/bxTKT548wOk7ywN0T8u45FN
 5QWvph3dx2U9Mn6O6c9kBXqpNAo83NkPbReRfiVuualkg0Uyvf1pWeaUHnosH0jJANm8CVL1u/l
 ukTs6JpdPiBEwPeR4bbTUR2n8nTmZhijCO/xMK/ygwQG9CwzMg+hau1T2LTkzvlD3Q3Do5PO8w8
 Wu6xdlJvGr3YiX8V+JIHbWPc+YacTsHTF9No6DaUFtsB7W8in3JsJG+0/INohujsv0CN3qQY6+1
 mQuBp5EvqPPN0ujq4OQ==
X-Authority-Analysis: v=2.4 cv=aq+/yCZV c=1 sm=1 tr=0 ts=69c11704 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=CKLdGQBdBfwLqkfus9sA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: QGle7kvwoR4OhPYjviHWN0yk8Zef1c-n
X-Proofpoint-GUID: QGle7kvwoR4OhPYjviHWN0yk8Zef1c-n

On 23/03/2026 00:08, Benjamin Marzinski wrote:
>>       k += off, desc += off) {
>> -		u16 group_id = get_unaligned_be16(&desc[2]);
>> -
>> -		spin_lock_irqsave(&port_group_lock, flags);
>> -		tmp_pg = alua_find_get_pg(pg->device_id_str, pg->device_id_len,
>> -					  group_id);
>> -		spin_unlock_irqrestore(&port_group_lock, flags);
>> -		if (tmp_pg) {
>> -			if (spin_trylock_irqsave(&tmp_pg->lock, flags)) {
>> -				if ((tmp_pg == pg) ||
>> -				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
>> -					struct alua_dh_data *h;
>> -
>> -					tmp_pg->state = desc[0] & 0x0f;
>> -					tmp_pg->pref = desc[0] >> 7;
>> -					rcu_read_lock();
>> -					list_for_each_entry_rcu(h,
>> -						&tmp_pg->dh_list, node) {
>> -						if (!h->sdev)
>> -							continue;
>> -						h->sdev->access_state = desc[0];
>> -					}
>> -					rcu_read_unlock();
>> -				}
>> -				if (tmp_pg == pg)
>> -					tmp_pg->valid_states = desc[1];
>> -				spin_unlock_irqrestore(&tmp_pg->lock, flags);
>> -			}
>> -			kref_put(&tmp_pg->kref, release_port_group);
>> +		u16 group_id_desc = get_unaligned_be16(&desc[2]);
>> +
>> +		spin_lock_irqsave(&h->lock, flags);
>> +		if (group_id_desc == group_id) {
>> +			h->group_id = group_id;
>> +			WRITE_ONCE(h->state, desc[0] & 0x0f);
>> +			h->pref = desc[0] >> 7;
>> +			WRITE_ONCE(sdev->access_state, desc[0]);
>> +			h->valid_states = desc[1];
> instead of alua_rtpg() updating the access_state all of the devices in
> all the port groups, and the state and pref of all the port groups. It
> now just sets these for one device. It seems like it's wasting a lot of
> information that it used to use. For instance, now when a scsi command
> returns a unit attention that the ALUA state has changed, it won't get
> updated on all the devices, just the one that got the unit attention.

The fabric should then trigger this PG info update be re-scanned 
per-path/sdev (and not just a single sdev in the PG). From testing with 
a linux target, this is what happens - a UA is triggered per path when I 
changed the PG access state.

> 
>>   		}
>> +		spin_unlock_irqrestore(&h->lock, flags);
>>   		off = 8 + (desc[7] * 4);
>>   	}
>>   
>>    skip_rtpg:
>> -	spin_lock_irqsave(&pg->lock, flags);
>> +	spin_lock_irqsave(&h->lock, flags);
>>   	if (transitioning_sense)
>> -		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
>> +		h->state = SCSI_ACCESS_STATE_TRANSITIONING;
>>  

...

>> -
>>   static void alua_rtpg_work(struct work_struct *work)
>>   {
>> -	struct alua_port_group *pg =
>> -		container_of(work, struct alua_port_group, rtpg_work.work);
>> -	struct scsi_device *sdev, *prev_sdev = NULL;
>> +	struct alua_dh_data *h =
>> +		container_of(work, struct alua_dh_data, rtpg_work.work);
>> +	struct scsi_device *sdev = h->sdev;
>>   	LIST_HEAD(qdata_list);
>>   	int err = SCSI_DH_OK;
>>   	struct alua_queue_data *qdata, *tmp;
>> -	struct alua_dh_data *h;
>>   	unsigned long flags;
>>   
>> -	spin_lock_irqsave(&pg->lock, flags);
>> -	sdev = pg->rtpg_sdev;
>> -	if (!sdev) {
>> -		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG);
>> -		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
>> -		spin_unlock_irqrestore(&pg->lock, flags);
>> -		kref_put(&pg->kref, release_port_group);
>> -		return;
>> -	}
>> -	pg->flags |= ALUA_PG_RUNNING;
>> -	if (pg->flags & ALUA_PG_RUN_RTPG) {
>> -		int state = pg->state;
>> +	spin_lock_irqsave(&h->lock, flags);
>> +	h->flags |= ALUA_PG_RUNNING;
>> +	if (h->flags & ALUA_PG_RUN_RTPG) {
>> +		int state = h->state;
>>   
>> -		pg->flags &= ~ALUA_PG_RUN_RTPG;
>> -		spin_unlock_irqrestore(&pg->lock, flags);
>> +		h->flags &= ~ALUA_PG_RUN_RTPG;
>> +		spin_unlock_irqrestore(&h->lock, flags);
>>   		if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
>>   			if (alua_tur(sdev) == SCSI_DH_RETRY) {
>> -				spin_lock_irqsave(&pg->lock, flags);
>> -				pg->flags &= ~ALUA_PG_RUNNING;
>> -				pg->flags |= ALUA_PG_RUN_RTPG;
>> -				if (!pg->interval)
>> -					pg->interval = ALUA_RTPG_RETRY_DELAY;
>> -				spin_unlock_irqrestore(&pg->lock, flags);
>> -				queue_delayed_work(kaluad_wq, &pg->rtpg_work,
>> -						   pg->interval * HZ);
>> +				spin_lock_irqsave(&h->lock, flags);
>> +				h->flags &= ~ALUA_PG_RUNNING;
>> +				h->flags |= ALUA_PG_RUN_RTPG;
>> +				if (!h->interval)
>> +					h->interval = ALUA_RTPG_RETRY_DELAY;
>> +				spin_unlock_irqrestore(&h->lock, flags);
>> +				queue_delayed_work(kaluad_wq, &h->rtpg_work,
>> +						   h->interval * HZ);
>>   				return;
>>   			}
>>   			/* Send RTPG on failure or if TUR indicates SUCCESS */
>>   		}
>> -		err = alua_rtpg(sdev, pg);
>> -		spin_lock_irqsave(&pg->lock, flags);
>> +		err = alua_rtpg(sdev);
>> +		spin_lock_irqsave(&h->lock, flags);
>>   
>> -		/* If RTPG failed on the current device, try using another */
>> -		if (err == SCSI_DH_RES_TEMP_UNAVAIL &&
>> -		    (prev_sdev = alua_rtpg_select_sdev(pg)))
>> -			err = SCSI_DH_IMM_RETRY;
> Previously, if the rtpg failed on a device, another device would be
> tried, and the unusable device's alua state would get updated, along
> with all the other device's states.

Where specifically are you referring to here please?

> Now I don't see how a failed device
> gets its state updated.

AFAICS, I am only not omitted how we iterate through the devices per-PG, 
as now we just do this work for all paths/scsi devices.

Thanks,
John
