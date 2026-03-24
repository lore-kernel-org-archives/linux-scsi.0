Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DED0405AA8;
	Tue, 24 Mar 2026 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365181; cv=fail; b=hDNqhpXDd6eSHtq7hjnv8P8BOhy7FQd3ycy7//dzNkw7sP0gs1xcr8dUhhk22jnrntCt47Fx/Niz/asd6QvKDdTY7TepanG8fEi9F1noz//+lC+FjmzMFYKuy7rvIeX1fYtowdj7yxd0bjngVlxLY8LheFQ1wGiRuTdYOnyP9go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365181; c=relaxed/simple;
	bh=FZSZ6MkM+7cU5YhRmyUvj49hG5Z1TjMKbrn7rw5KNVA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IAiP4rYhvVBFzE61YlfdP6evODaWjSQKk9vKgPgzA06AIyCauqan9faJofbXA5xAzqm+epNYyry77xiwfyWiN4sTybqO3JqWAsmNvfOzbDB7qPHxFV+dyyn1ZOyC9wqod8FikU3vJof7wzWzvxcdD2pLVWFdCw6OzCox/lc15LI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bqI6Dok0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T5OHokrL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bqI6Dok0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T5OHokrL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62OCC1kV3886413;
	Tue, 24 Mar 2026 15:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xz0l1Wrkj7jBbRvPc/CClpQ5d5XtDKonpgTejJx8POs=; b=
	bqI6Dok0j1S+HVeYNvZGyzOehxQS9V1R7Gszd9LDRBqB6SfBC8C/KXl7Vdja41yX
	B/70fpliofgSZasyug9qMQkk9GcFl9QHCxlZACtpX+QXk2oI4DENdJOMHW+GaVXo
	uHIPOOjiI4v35rjk5UkBurS9rYcCnHxWjrfiJfXwyaS/xbGyMMpqlwaDjYaUzQuG
	xHrP5k5tMeclHoZRaINT/pTXsAR7k+9sIN691udRqNaM0UP3SGPne2egB/eRWfnV
	ZoUvDttouBe4bdptJ/xfynUXeizzYAUQMDGUD2ELIFJJOhBcKqgIy62TUBbepG1M
	bEjFOJxRnkxju/aOa4Izww==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kvnmd4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 15:12:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62OEdHg3039923;
	Tue, 24 Mar 2026 15:12:46 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010016.outbound.protection.outlook.com [40.93.198.16])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs9s917-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 15:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qy5omBqREJYR0Hb/L/3TXqlBKWznFAvub8QWFDf5KEPLnol5hZTSE++lhK72Xjy7OBeTVZziAg/AeSOBzIoV2UdksoFOFTgKwRoICssu9QgIZ95+H1+u1EVISoPzP38+KomZGTbkXVz6YVbcbAI/W3klS0KrHwLVI6yXSm6KLWa9ZPu5uh60eM52DJcOHoRtsYaSJbr1/zmqqkYnm7N/cJnnxnfhnhRfP71C9Im4IxNzRDNQ4k6Qnomt036pKoWRfphGjnspEYejf2dsUPZQ3ljAK2f3iVNEWef2W2edeURmW5multb5SSkE/IzBmMIBhuT1AMb/UK0OwMwBolrx+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xz0l1Wrkj7jBbRvPc/CClpQ5d5XtDKonpgTejJx8POs=;
 b=YqhWprj55VMRoehYpd3C50K133g1PreUXR4YDgopHAKGmxDNcP0jhsu/b7NqMIIsuj/99hZXCtJecmWYWFzI86uOTN3kHTq2CeXYkbBFo9XpraWi5etDjXodn7a1qpNrU1+v4tSLUuWDF47pgbuS02jK9esig105NZmBAM8kXXvUk5gLEwEou/vUGRhlwPE9RMJQpnWpq3k9VpYRpHGn7e3C2T9EX6n3CXuZy5d5dmNzr94BVPxWSKq97ivvz3Q6g0SarNT4RjhK23mGlDzRlN1I8pdzcGCwn1MkWD3m/LT2Esl5YSpmqKmrb7AXLdlzCCGNr9UBJBQqqk9pkq1Edg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xz0l1Wrkj7jBbRvPc/CClpQ5d5XtDKonpgTejJx8POs=;
 b=T5OHokrLZQAwjthAKZpxm4sUCdZx9s1nEbBwRECLrI4HyAi7jMD1Bx5JAsQSrI4VMUnIGf4GJxbVlBmxjBvOZ0jsXR/qLFi26kkNxqsdCWOT2Hi++belaoNwyemEwviENSSYRkfvPfxjcvOKgGybWuCZfhpQzEE6/HQrRoO7k3s=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA1PR10MB7198.namprd10.prod.outlook.com
 (2603:10b6:208:3f3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Tue, 24 Mar
 2026 15:12:42 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 15:12:42 +0000
Message-ID: <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
Date: Tue, 24 Mar 2026 15:12:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acKYbwGlfgWKDxnF@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0219.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA1PR10MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c042141-2850-4ab9-efa8-08de89b7cba0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Iq7mWmTNBa0eY0SyDDX6M0SaTYsA3IDrVBojOxXDxgEozOMqIiZaYI0Pix31p45dPHLW3Ar5brXotqVtdcerMYMIp/V1SWjFr38HAkIpNCCxTFrTkFalgozS6qYhsDc3TSNinRVNwvdJOqtRWoIwA3um3fvProKMz2EXEHzbsfrSmUV68cQUVIMY+RYLtcxgrXMgGtTO4QbH7jkXwp4fG++bSSzUlMIC3CN08JVLjHXBa1JQvFeUWdR5OxQksW+8il1Qf8yhN2NfVg0IsGRdVqdir2NvN79AuHkSfP1OWnG2YdC8yvYTii5EP4or0chmD0EfoN5s4J09kRP4fNcyH/f9wFGyfbQovQPOZCICCqGz88QfWxv8hooeh5mD9eSePQ/CPCsn9bGd2hVj6h9t5isM6NArsPsy+q9Z+Ma7odBrYJZwtcavmPUvF4EVaPZI7iKY65GlFnLxT7ukAy3fxnzeOTOz1vyoU25Lw4lBEuFKkDNmAVLrXlbBblXJTfh6IKkDZAbXK9ZCDclkp4QQpANBtCA2zPIRSRwaHobVNMjjAqfaYpKM3UN5ZJHX77skIqZJE99otTKh8OwbkAv/E1hP9vPCRIGjJWVcdTBI+V94axhxFE5jg20MzhkwNB/51+cCdhVuKXDs8BZt4ReQPibJdeThb6rvWawOE6wO/0L0TJ5AOXqM5BI/6NaqT3Y+tIb5iRtcSYVlNSHFblenVYolGBV3vvFEB19xdSegMdA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDREU1FOTzd0c2R4b25vUDByTk9BbUxQdnZWdmNaRFduRFcwRVIzNURDMXQ0?=
 =?utf-8?B?SGNGUmYzRWl1Z0JLRGZnUmd6MlVCTFVhWTFSNXljU0RsRUdtYjJ3YkxyUWc5?=
 =?utf-8?B?aXg4dmlpendSK09WUU9RczVOaDU3M1lBbFFtZFAydjNaK215bEgvamRPQWIy?=
 =?utf-8?B?cTJnR2ZMVnpUbzhZMUtZRGZ6VysyN2dYUzFoRC8wL2FKZFJnWkZlcllHWmtJ?=
 =?utf-8?B?cDFtVmxNZkIwRG5yQ3hwcFFTWXdBRWg1RHpJTFgvckRuQXJoMXdBZnpxZ0hQ?=
 =?utf-8?B?b3A5STBtTm5MRnUrbWF5WkVXdWVZVVJ3Wk1SZ1VqMkZVSEIwOXJwNC9wdGNt?=
 =?utf-8?B?djM1THpSSHg4cFZ2TXBkaTUrVHVRbU93SGlmY2QzVmxlb0VUbmJ4REhWcTJ3?=
 =?utf-8?B?c2xjNGNDR1JsRUNWZEJ2cWVUMEVGai8wMnFrbHNiUUJaT0pkNGJocTBJN3RP?=
 =?utf-8?B?VGNQQnhWYk1hTFlYUW1lZ1BKd3dLbzhoMlU4MzdxQzZ3UUJFWUFLYU1SWDRy?=
 =?utf-8?B?NHBOdTh3aTlwK3I1WTBCQ1lzVWFUUVJiSUFCbjlSU0UzczR1THlNbmFUMTEv?=
 =?utf-8?B?dXhZZzYrMjlocE9TaklWT2dLTytyNWlVWml5WWpHRDdYYmxUeStldmM3bzd1?=
 =?utf-8?B?RFkrL05TQXgxQ2xVOXVJeXd0SHlZRTBLOTlwckN5ZktOd01wUzFxMURjVVdY?=
 =?utf-8?B?ZFd4bmlybFAydnJGV2o2bGh1WVB3K3lXTThyMnpIY1FYSnFnbVBYeDd4cHVl?=
 =?utf-8?B?VFlHQWt0RjZHRVRWY0F5QTl0VDdoUkRCaktQdlVKZHA4aFdqc3N3SXFEa25E?=
 =?utf-8?B?UWdoZzR1d1lINEVJdVl2bnBMckJGcldMb1ozeFp5dExicm9HeGJnRUVSWDc3?=
 =?utf-8?B?SEpRVytqNXlFemxYN0x1ZTZvOVJUU2xXZjkxdmd5TFR1K05ZUWdoaHJYTS94?=
 =?utf-8?B?ZCtqTEVzZ1NGak5Cc2FXUWloK25XeHZKTGtZUDI0QWwrYU5WTVo2ZllZZUhk?=
 =?utf-8?B?OEQzbGZseTFXMlE2N1lHeWwwUU9CQktLS1JkOC9CVzY4WkRTZVNXd1lRMW5L?=
 =?utf-8?B?N1FQeEQwa3hJeW5JTlJVY3kvOUt6TjJIa3kvelBlVDJLT2lqQ1pXcU9ERGFQ?=
 =?utf-8?B?R1hRVHBmTGdmdXN0OUM3MVIyV0lBa2w4dnVwb3dTOG1QT210aDYzaURDMUd6?=
 =?utf-8?B?VjJJeFR3LzZTK2VjTnF4OXRaNEVIY1VxVVp2MlNVWlBFMDJTbExRMXJLdU5M?=
 =?utf-8?B?MkFYNFpseXExT3FoWEtqN1dhNytpNThmaXI0R3l6MDhKUlZGaDVSTmZFN2NB?=
 =?utf-8?B?Z1FmTHJYUHlGaUx1U0FQRkRzVGFUclpYOUJsMTNwZDRzYUtZejdDUGwzblpj?=
 =?utf-8?B?eE5PWVVodUdWNHFnbXFoV3JENG8zalVwU3ZqaU91M09mOURQekdTN3pBVk8v?=
 =?utf-8?B?T2xhY2pzUlR4bWxrendSU0htMzFOdUd5eS92a3NWZDJGTVNuNTJQWHk0ZEVQ?=
 =?utf-8?B?bVFuNTNRNlFMM0hMbFZzN0RIZll4M084RWxrdkxMNktVNk43NDZ6T0tReVNZ?=
 =?utf-8?B?WGRtajExaFdEOXpKZ1ZMbWw4Q0ExeVo4Z3p0cGhJcHBjYWNZTXpiZzRKd3ZQ?=
 =?utf-8?B?SldtbmFyZEY0WHltN2Y1TEJoMExOaDAvd0w1czBhZytIOVZic1VvQ0Zaa3Nm?=
 =?utf-8?B?L0NIMHNmbkVUVWk4ZVdYK1lCcm9nalRSd05QNis0ZER3dTVWcXg3R3BRb1R1?=
 =?utf-8?B?eGE2Z0UyTDZWdk82Q3FCcFNacXFnSEw5SG1zOHE1OFRrVWYySW9YRkR5SHJL?=
 =?utf-8?B?WVRmMmp0WXdveENUUVlPSy9PT1ZrbndNKzlWZEZyUDR3a2F2Rm8rUksrYXZN?=
 =?utf-8?B?clFIS0k2b1NoRmFPODdHQk9yYzFFalAzL1dpYXpydjhabDhQUWZFYkpuNjdo?=
 =?utf-8?B?UG9FTnRDNm1qL3B3R3VseXBBT3M3bHhrbGFLdlpTR3kxREhCNThoVVFLSDFB?=
 =?utf-8?B?SGsrUEJBOGFpNitqeWpNTEN0Y09veHNJM2dpN2lrOE8rMUJHVlh5Z0ZKb2hM?=
 =?utf-8?B?UFZiVGgvcDA0TXpVaFpmeGhsckxsSFVUeHNJK29PWHlhNWtZa0l5QWp1OWhN?=
 =?utf-8?B?NDNpREovcDJpeUpJZHRZOUQyc2lmbCsrZUF1Rk55aHA0S3pDNE9uQmxWbmZp?=
 =?utf-8?B?R01RZ3IzSC9xTHQzMGhFRlg0UFFoOEtEbDB4QzhmK05jZUg0RE40RDRLSFcv?=
 =?utf-8?B?ZGlESVVXbkdPcmJMMEhob1VRdnRJSDJjVzBWZWJHUGxrT00wa2hUbGVzZEVq?=
 =?utf-8?B?M0xhUDhWY29EVmt0T2d2MHIxZkFTNC9Xc0VPVTBjYnorVlFmZlllUHBKUGhq?=
 =?utf-8?Q?LSjN7CWEOF09DDzg=3D?=
X-Exchange-RoutingPolicyChecked:
	amG6YcX5/B8mM1i9wCZEp8BxSjDSpWtjhBAH0G408cIgJoef1buCYLL2CDwtHQ2L/v23NenfiejmUygq5ZsFzVIAWcIm+HcAVSTcqfXNZqtajk8iSPj1TwzqTZ/vTMMOcez1p+VoCKViWMnw1x2pdgUa0eMGSK5Lp3wpOEjpQuQSOBrwUpWSDs8axj6R8BEwn3RiIVbzR/w2XIkw1cZqioV7dsH9fR/iuop0UWpPhvdedcI6TrgnmRLV3VPPod9IVzp8Yl5TywIpxEzgyud2bXxz1Q9er6j8d+aY9e6RXi3Nilbm0oxe/swZqka6ZMmEH7OsdSN80IIiLdP5CSVKaA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iXrIlgExgKIuuWYFXjBOl2eZnms/0JHnCIfuALLbuH/wLZlJ70p7uHHxZtFlu/IhY1wT9k+xUHJlVTsfB8vQKpeGlYzAuqmdBWnSDY9WEaUvYV0QVQHKQf841KceWL4C7i6nszTnqBhU+G70U0Tf6J+SKzbU+D+gnZ2czzh7roHy/v7lc+m880eOQCjq/ngx/7bCUFWirZavUPmiPIDDyizFnaeTMaK6Mrpl9js/I1ggutArlKLnt5grr/yi6oRke8+SN73uJHtysm5c1ttPnK3J4toUhnvgxfhR3kal99eJ1vPcz3b1SY+D3/tX5sNMreBXEPKeQvEBSTtxQGrOMjgsm6OZ1sgqdi+BTMUhkF8PCYy/h2OM8WNJTjnyY2zNdGpN4GAr+QgqiaLQLFj88Wb1DWHwKlVSqga9P6qdzXNaQLR9kTdqOEbsA3vKC75dANz+u5NfTRW9OCG1WvSXCFiGm/HtLWswtkpIAlHgi3oDq6Az5at4Al5yX2abPqx2NjWqhOneeQ3hYj2wvY6eBv90JRO5eFGYyvjG5FX54U48jcbwlK4O1HdvRuHvulkkSy5k+Ow40uiagj2fBjm9tstlKXpmjSNyCqS0sXqupMY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c042141-2850-4ab9-efa8-08de89b7cba0
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 15:12:42.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F39r0abzPmCF2sDWvnzvMalXlgL8jYhAwa5NBssnoVFhdWOOaWJ2Ftwh5cYF8eXCjc687xtA5mQfHh+qwPahwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_03,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=903 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603240118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDExOCBTYWx0ZWRfX6rWTxj6JhxUa
 vjJnmXQau++tIeCIvVgPy3wEHGDaOZbA7vt6G6EXPu7xXC0aZ2Tnd8oynIJUADk/y0Jx7Efgakq
 4NUdd6kRpK48J07yKBq/qJ4rKP/EyDurgOCVFMmOKXdCCubCZ7yFHXTnJcwqTbGNY7yZHypS0nX
 CpeXJT/dk46LBUFVaBYqCVqw2h7vVzb4wKcgB3s0AgSJhQHve5+hIVIM51F/RT0QJQjI20ZZlG1
 HIz/U+QcnPuSPUdF9+qmJhUZ5KVLXdMpSGX0XgmCtzXlvkKPZQ4EV9w8qb54pvQkpYzX9TqPcdg
 /SI80rivhF04ql/k6sgiqKOg6/ISTmG1rzq9ImDFmBpX8xIjlQyAIA5RT0SWRr7t4bV6c9dnspr
 VBnL+obFJvtkp8g8P6Yiv4UEdy31OqmgrZNMLT4pPcU2NxSQ/sDIETy4YD+uez+DEPYAUCTLSKb
 6jLQZhZK7WYE8mQLrQw==
X-Proofpoint-GUID: Fgpllg-yfkCqXAkytXgRYMkpvCqdIzPg
X-Authority-Analysis: v=2.4 cv=GrtPO01C c=1 sm=1 tr=0 ts=69c2a9ef cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=tnr_ig7_CRdhM8NyZ14A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Fgpllg-yfkCqXAkytXgRYMkpvCqdIzPg

On 24/03/2026 13:58, Benjamin Marzinski wrote:
>>> If it allowed device handlers to get attached, these two
>>> developement efforts (native scsi multipath and refactoring the alua
>>> support) could go on in parallel.
>>>
>>> Or am I missing something here?
>> It just seems to be about this DH stuff is that there is bad history there
>> and no more users are wanted.
> Just to be clear, if the idea was that the Native Multipath code
> shouldn't use include/scsi/scsi_dh.h, I completely agree with that. But
> I don't see why it can't make use of the results of the existing
> implicit ALUA support, since IIUC it doesn't need the scsi_dh interface
> to do that.

We would need something like the following to ensure that DH ALUA is 
present to update sdev access_state:

@@ -80,6 +80,7 @@ config SCSI_MULTIPATH
         bool "SCSI multipath support"
         depends on SCSI_MOD
         select LIBMULTIPATH
+       select SCSI_DH_ALUA
         help
           This option enables support for native SCSI multipath support for
           SCSI host.

And that is even enough, as Kconfigs should only specify build requirements.

We really should be also calling something like scsi_dh_attach() for 
scsi multipath to ensure that DH is attached (and running to update 
sdev->access_state).

And I am not sure how the dh alua module is even autoloaded. I think 
that on my ubuntu machine the multipath-tools.service does it - 
something like this would not be nice for native SCSI multipath support.

  That shouldn't interfere with any refactoring that people
> want to do of how the scsi layer actually handles ALUA support. Again,
> this is more for Hannes than you, John.

Thanks,
John
