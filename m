Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6463C13F5;
	Tue, 10 Mar 2026 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773166453; cv=fail; b=oNvSpMCy4V2jLZOituvN205Z0X8LJUff1GMxNLdJ7ItFPXqH3A8ni5IHe4vhgjhYvesuWeYwQTTURUP0lb5pRzuNTX87s1ICSkLz0uRKpv918pPukTsUk6eXRrVbgmSe22fTAmsaEOKTHycZzD+mhYlEZaqmlQf7R5iOyuWrF04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773166453; c=relaxed/simple;
	bh=0CBjS54VUf3FDzXj24WB17ZXS4XvkaxNmcc9XXCjSpw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qN7Qu+SBbT3sptdvc1hmNxYYulrmmBiI3h2EerEI5rp3h/GO0deOyoLQuNJx+6dXYyTzlmzWZa4g7q/bMokjBIrwbZRD9prEapcJ4oDt0ju/g91kgFYfYaOEIXCDXat9N6sW0sz2FVsT+6WpCoBCuPO1wZgKgECKYJWY7Y88Swk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ibjoSqGe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ENsR7KcK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ibjoSqGe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ENsR7KcK"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AA6pEU2344410;
	Tue, 10 Mar 2026 18:13:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J0D3TmULhhsWU3ON5Riy0H+LkQBW/UG0PgN8hFODUpo=; b=
	ibjoSqGe0exkmUBCtP0enayK+fdAM4LgDJv58SOayVIV7CftDD/Xue6vom3M/7ch
	0/895BL19gpdyuzI882en2qzH5ayJqYvJM4E1vz2KmkM5Ca1ajVWF0v5ESVk+52z
	kLRN3BaVT8zpNQ6T7ZzZKsnt8FK0HU3NjMYjtojhiORAA6a2L1hskPG6Fnnl8+v0
	xCYazm248Zh0VzHOSPXFA1QfQxmnHYSjeeSSTKK1DfC0JmkuCpP/Khh4O+0oO97x
	+/VJbKEDzofRLB2SGfXSCFtX8HgzFP5AgStZP8MbVRcfjN20W2kxTWPD0zmajB+G
	g8I2B1c6RbAJw5ECNf4DVw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csks2ke6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 18:13:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AHxPGC022712;
	Tue, 10 Mar 2026 18:13:50 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafafehq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 18:13:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbIfH7ij+SOy0f7g2sKU0h6YVLRiqtq2phmUEIOHGjSZ3vQOVumIZS/72o4IZRv2HailHJQKtp7eLqSDsarGpyF+jflmdYBEjqfCQlUbGo4+CSDiK93IF/nR3GpEOIicyqII4HhJKd+MfqeyK602qem2CswCWkqHcEuEQAmahJTnexGdQCd8DXhE+kjR/B/VvTW91MoWQSHg0azEYi2RXnO2E0BeI9NoT4THiLQ2+uwWBlj0NqgDjJuWYXTr/50Ebj7bEvulHGllSBSZsjlT59L/DLopD/VI1dx6Uk1BWSB0/LEyQEisyhND6dCaUvAsZw9qNOCS0E/JaM7EDJ1/UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0D3TmULhhsWU3ON5Riy0H+LkQBW/UG0PgN8hFODUpo=;
 b=KnpiXhcW3z5BtSNQdnHLc4uje7J3Z1EghLWvg0iuIVTgZEzZomHIU49IW4DpCQLVhTmRzmAcnVubMXnsbJ1NspWbtOPzLu8b801JTPg/hCt+M/YWHTUv5WX1c8Dy3ytDyTaL0sg6idn33r+i+hW6cCL42JZqPZNiWoJqwNYUl/0/kJw6wSrUzAoVIS5M1gAXPTM/kZzCue5d6KwLrbiRGrCTkn3hI5C/LqGM9WwXpzXkBPokrpfVgjWscrHT/E0EZWSk7MULAQOC5KH4F99Py+BGV8bq1uWFIRSq+WOsrp0C0lhr03Z797MaLsb6kQKdyq1wSO5h895oskMxGKqaFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0D3TmULhhsWU3ON5Riy0H+LkQBW/UG0PgN8hFODUpo=;
 b=ENsR7KcKCAM3YJJ30LzoViI2m1ZWUJjd2JXJmd4C9OZAMjFQJTweGwbexX48a6IFMlmsLzKB+55JMXwBMm8S+XTdixDa3Zeikh/CUAdTkuHTKK5kPlzbZV4UvXsQN9WHj+jAwpXpmE9U/sTfGh1sBcqZM+KGzDdWBppDrE6DlJE=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH7PR10MB5813.namprd10.prod.outlook.com
 (2603:10b6:510:132::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 18:13:47 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 18:13:47 +0000
Message-ID: <4f6527f2-63bc-4e96-b9c4-3f4a126222c0@oracle.com>
Date: Tue, 10 Mar 2026 18:13:42 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] scsi: scsi-multipath: Add basic ALUA support
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-6-john.g.garry@oracle.com>
 <f46807c2-0266-4143-9caa-ff938293f7b4@suse.com>
 <3178d371-7a4c-4d07-885c-42496190f242@oracle.com>
 <6b6a822c-4e49-4e80-ba57-57704e3c1307@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <6b6a822c-4e49-4e80-ba57-57704e3c1307@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0407.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH7PR10MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: 5af50a52-0ce1-4b0d-97ce-08de7ed0c5ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xr/FGPKR4MCzcv+Jq1CImgc5wIqyl/5mW1EWQNDBgoY/4/Z2d6N/be+Cx2H67Qkogwr0ezIPzxyBbrWbE7WKrI4FGdMrQjiEeO1tb/s3mWo87H5gyuZypudeiw/dDywxURZ9CDLazxapllpy/uK42wNS0QdUV3ePsSGbKaR/E5XqKXj2Rg3eJRyYf3ENktJf949tOJ8ODTfMFehZNQ5WZtGSVEiG/+DRVNpdSqoYd7j2aCtOLqgw75ZN4ZFZgejiCOojGLAUJHaveY+msl0aDjfCw4ATySNKFGX9m5jkr22L/NSNhu/mzW9WMxpdegP9MC31mZubcmRVy/pdTFJ972wP/AikXJ2ymmsweG0uN7+lbtQeF0ElpwERxE+2QvUdG+UknuujKyCd3vFFrKe0H42ZDcM6kNUpybbbTxqpSML3/rnklhURQHLKku7Gc1kDUUP9W3JGtw7pAOc+9jurFeK9DwT/P9Lpn7AXy6ZafIRZIZSQg1jIHJZKORmgbgVOpOVNPDK1gJzRoOjqf73JdjQaM4MoqQrkvWn2AgiPJGqmOyldkvyXDoz2RRVEhwZHvYuRabIy9F2UJuUy2p6MxxM5WBDYFIGexBkCdZhyM13TQx+/ddCLB6AtddhEO2Eijhcvndmq7HRmGOCjLn9NQd1TfyLvBoDpNGGsz37DnK2NS54JiSJauT9EuAamLky0wnlp6ckfb51m78Jb68INjczX96DCl66W//9dBTNO/s4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTc0NmRyMnhqMnB5MG1yRmtnNXF2dlZFb1gzRUZWY0duTjB0KzdWcVVLaFdF?=
 =?utf-8?B?UnlBWnF1SFBtNnkzL1FOczZER3pGVjZub1E1eHFhSm9DZG9zTXkvNGZUYjg3?=
 =?utf-8?B?UG40OEFzOHdab3lZU2tNeXZQblQ2ZEQzaS9XNlZKb0YyUVhURGZIOHZadjZF?=
 =?utf-8?B?K2NLKy9UYXp3d2hZQmR2M29YbkJkbkVIWlBmR1lkaWJRWVdjSVY2T041RmZ5?=
 =?utf-8?B?Y0pQV2RYTEVZM3RSbzdxcWFMcjNiZVNXTU9mK0tuVFB4dHlUNU81SW4ybFJR?=
 =?utf-8?B?eHB2QW5GdEZuMUhmcG1heDI0YzVuYVlVbUE1QlB3VndYRVdKN0ZENFMrSm9Q?=
 =?utf-8?B?ajNkRXVUcnlFT2dDZWwvRlNERCtaMDN3bFBVcDNtOEZqM2VxRzFrMzBHV0Fm?=
 =?utf-8?B?c0QvRHZLQ1JzNlJJUXZ0NUV1RGVpSEQxbGJBTW9wMTg4K1lCNDNQTitadUQ5?=
 =?utf-8?B?TjNwYzR6aDV0Vnc3NFdFKzZhMTFCN0xHcHNXckE2S2NVRElxUkt1U2pQY2Zy?=
 =?utf-8?B?aTlTcXh5YTk2WGlPQnQ5MGtiamVGN0s3dnQ1QnRwT3M3MmhEZitmU3NTUUov?=
 =?utf-8?B?bVdVNFpEak9YY1ZaNmp2S0pVMDlxVHZoZFZURDkxNnp1U0VxOWlwU0VNUEUy?=
 =?utf-8?B?aDJSK29tK2JURW5IOVZvOVFoVnl0KzRvalgxT1lxcDRnL2ZUaFJrK0V0eU9X?=
 =?utf-8?B?STRlaXZWTDVvQWNHMEw5cy8zVzRGbjVsa2VyMmdHeTh3VGhJdEZnMXc3ZWYr?=
 =?utf-8?B?OVZFNGJqOTFzbFIybGI0S1RaM0dGS1R1cFFPaHVXV1hLSTFaci9qRE9GaVVH?=
 =?utf-8?B?Tmc5bjYvRWFnSmNISWhJaHczRmcwd3hYbDVVVTdkM0w2MEtyQmxETi9iekhU?=
 =?utf-8?B?UVp6MkNFdTJHbnNLaWtJNGpGeHVBMURya0V0MGdhUSs5RzhFVGtJaXZpNEVa?=
 =?utf-8?B?MmxJeHErOFRQb1hiMzBzZFV4REdSQUF5WmJETDk0QlBQYVNJWHhiYThyWHZj?=
 =?utf-8?B?WTZKSHFJcnByMjN0MFg3Y3JEL3I4aFErdThuRnVSZjI1QWMxeVF4a0ZtMXhY?=
 =?utf-8?B?Q0ZSd3ROTDlvWDVFOHN3SWpzbVJPVkdIVC9paXVKYTBxbW1yNFNNVHBnTEln?=
 =?utf-8?B?S0R1L0JtaEJrbDV4TWw1RDZzcFlFdnZtMEFqUjFzQXlVM1hQU052N3YyTFFw?=
 =?utf-8?B?YmZubStLUDE3djlqUGZUVGEwMCt4RHpOL0NVdUhscFlLSUhBTVdoSXpIeWlo?=
 =?utf-8?B?WmROWHJOOW12UWdBTjdQSFV5Ri9pUEVpOWJMR2ExN0EwWlVvRURoRFVkQzF4?=
 =?utf-8?B?UUdqK2hyTHBPWmRmUGZUZGtiTGJRSlArbkowUGc4bkpNQmV0OHR5UUswaHdN?=
 =?utf-8?B?NzUzYnVPeG94Y0YzSm5QWnZmSGdCaGh4RHF2UWtvSmxXd1RobmV1dExyWmRG?=
 =?utf-8?B?ZmM0YVppNjZtVnNkbTY3NXBZVGxLeEZIU0dtakRnc2d5cng5NDdGKzlnK3pn?=
 =?utf-8?B?cStCOHdtZld3aFFmbUpjRWhma0p4YWdUTEIwdXM5R1JWZ2lIbUc0OWdQWG5U?=
 =?utf-8?B?N2FRYU85Sm1PdVE3dTBYekMvM2c1V3Q3Wm5BakRVVEsyTGVaUzI4WXZCQTJG?=
 =?utf-8?B?bnR3SGg5anZUdzUrTWd1Tm5JV1hlRlhuNmsvVGZvMGhYbVdBZnVZRWxXdWsy?=
 =?utf-8?B?dDBndFZ4UERqL2FYWFMyQ3JiTlU0VjJEUmIxa1JZSitYcGk2b09kRjgrT05K?=
 =?utf-8?B?UFAyZkNDTjRMY2c1MTFRQk5zRlJEL2pmbVlVU1poekRDaGpnb0xKNE5YOFJm?=
 =?utf-8?B?VXAxeERodC8zdFZVZjY3SHZjN0lRTDFpckxoaUw3Wk9zNXFHSjZna3ZUdVpa?=
 =?utf-8?B?b1NzNC96VDVXOGtkajRlNFpLcTFZNitYSmtPY2VrVXlFQlJXZzZtNjkraXR4?=
 =?utf-8?B?N0gwdUE0SEhkdW9RbDMxc2t5WGZ2ZXNyejJjV2wrY2NVWDY3Rk5nbmNUR2lK?=
 =?utf-8?B?Z2NCbDhwRC8yYWRZQlJUZ255NjZ0YlhVcjR1eDVBeDRZK2tRekplbmVzMkRO?=
 =?utf-8?B?SjNNRnloc3hLdWJYVXovMHBWQ0xMa3JWOWRFUldYSW9iaUVWcE5oeVd2eGt0?=
 =?utf-8?B?VEozMW8reHczRG9RT01kRHRZRVhvcWJNSTc3dzVlZ3pCOG1OaDRPcmFoR3VU?=
 =?utf-8?B?dG9tR2NDK2VoSS9saW1Sa2FXcDhJUUdxdEw0Ym9GWXJhZHpCWGVkaVJXdEZs?=
 =?utf-8?B?RXFRL0FIVGY5Kzhmc0pGaUswT0xhaStSTGFmOFpEbUhkUTJUMENnVjI4bDhw?=
 =?utf-8?B?M2dMUEtQRjhHZENoNmpQTmU4VG9OazQ1MEw0b0ZWY3NmUVhwVlR4a0JVMzVh?=
 =?utf-8?Q?MX86OXj1s/n6Oa6Q=3D?=
X-Exchange-RoutingPolicyChecked:
	voBLT/khV3yRpCBd3SZXqk0TFkEXYiC6VZaY9XFN2fNOfXyIbS5XCLNlAnrlYjWaBZPGnaIFEpFM+I3UFUnlSOgMCDAeoaL17Hf7DuJv7WUlhXIb7FLY8KAaCC/rvN+5HFACvn2F1wnXdvI/4MdCXyHXDTfk143WI4tRdQgI/yhZY2pn/o1kQwoMQkaQ4EmkSJb5WnukwV8lBwERVIvjHfwZ5IwfLBeaQy3gvqR5CblWAEu2giIgh9AbD83ylhmp3PK4WY3Po2jN+Uj0sQEMdB6q53Fmma17mAvN+0K3CaLDc9GJ61GvdmMpJDMKSXuJrQ8etQGKV7pCH+pwWqE7Pg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Co48JCitJGyJR0G6zPYwP7uz8OlBl5msMsmxDcc3xUh0AG8or4E74cZGJGarLtf9NnDeIVngwpzdZUA8P444XDBwIJltacF994OM3EesGBzQgjWwQnjF2ZZr5YVhxXFfvJTKO/cpfN1I4PSbTqCuULd8EMKgGcPAANMtehkD/TcykVXVf7rCQsLTf0GvyjCqV8oE3zPyJ4Rzd/V+mLSSd8cpUb251W4FViN2J+pevO+lxwo7PO26D3kXq4c+Qxgc7pO7IIvQF1JYvMp+T8boL+ix0Ftw+nq3ONhpzF/2wkgKFFD+aW7SGgFUbtiixAJ2po2FRm7nZlzSbuz/RUhu8PZXlKo2fOKIuZWVtY/P7Mxbbhr+d+Z2aSl7YxGzwLnOwJ2gBRAdes74P4nwAAvz4vCZ6Tr4HtlfVIe3Eum0fSjEts45yMxlwCI50gLQ4f8EvX03pEJLGHJtMUmSrc9oKaKaOlIdZkyGVXIG4pcRZnagPf8FxUHcqJAQLcoJ1BWrcMN+ZtGNOCMPLJ7alm4U7EOxUAGARqTV7ADRI9MV68oV/MhKdpE/t/6urSkoGp6TqgqSvME9HejQ1y1atPnykiHsc5pXXJP0Zpwrfdc+iQ0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af50a52-0ce1-4b0d-97ce-08de7ed0c5ab
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 18:13:47.0481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCKApsRXMr+/B6ix29GfhwJPfn4yBBU+wvFnAIM/fKT0WaUVS1QF6OGUmaHXnGcaHHsDrD2sAyVvyPVeRfVKfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5813
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100158
X-Proofpoint-ORIG-GUID: DZOP3HrFgTbvJaGzHDuu2sYNDDgYV3p7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE1OCBTYWx0ZWRfX16nbNx9zJyLj
 dMpt6IRXJDbOnl4biUXkTt2AwtxApSza0MWAlNGDVlphvg1BLquhSS50SpPz3Kf+ZJfwq3LFd6D
 friXzZTxGsettyAKFjaALLBbIEhZP55/KbPIpVZEvPB6bnmgnnD3C7LN6OUniMRJm/PIceeU2hr
 1ehdxwCG5LQHIgAAa+P6PqG564bICeHJIJiYP1qDP7Orhw/scjrQE/1dA2OQVlrq403AlWQHU8L
 QxkX0w11XD75FY2iG7/TkVRJnpv357iPgvOCggmREdIdnFFC6tUZcuH1L5OawGVlY9uGIpvuMs2
 1IoIOv4helvS2fPUchb5fkaLHG3dUihwQcb/+4VUzDiBMOJHicGQzwhFmVZMGZ/vp/1e0nkdH4N
 Te1IZt+qdnkonJVVI7FP+qZp2TiQmhyQZ89sEQiM8i0NQmTGElraM9vn6q/hlIU+kACb+j/0JJl
 Wz31XB/zJ4qMEcDDTBQ==
X-Authority-Analysis: v=2.4 cv=S4vUAYsP c=1 sm=1 tr=0 ts=69b05f5e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=RFK9nMf20UTRqAQgSEIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: DZOP3HrFgTbvJaGzHDuu2sYNDDgYV3p7

On 10/03/2026 17:54, Hannes Reinecke wrote:
>>
>> If yes, to repeat, it is hard to separate the DH stuff out...but I can 
>> try. Examples I would need to deal with (and associated handling):
>>
>> - alua_port_group members like dh_list
>> - alua_dh_data memebers like init_error
>> - everything in alua_queue_data
>>
> While the port group handling looks nice (and there certainly is
> a certain neatness to it), it kinda assumes too much about the
> internal layout of the hierarchy within the target.
> Technically, a target is only required to provide a device
> identifier, and a group id (such that you can match with
> RTPG output). However, you have no idea which of the various
> device IDs are part of the same enclosure; that information
> is not required to be present.
> So you cannot assume that group ID A reported from device X
> is the same group as group ID A reported from device Y.
> The only reliable way is to check with the RTPG output, as
> that contains all device identifiers for the defined group
> IDs.
> But: caching RTPG output is problematic (as it'll change
> whenever a path state change happens), and it'll need to
> contain references to the SCSI devices, introducing all
> sorts of locking issues and race conditions.
> So probably I would not go down that way (at least initially),
> but rather read RTPG during scanning, and set the values
> directly in the scsi device.
> 
> We then need to re-read that information whenever we hit
> a relevant sense code, but arguably we'll need to do that
> anyway.

Hmmm... what you are describing seems to be now more like what I have in 
this series except only I did not have the ALUA info stored in the 
scsi_device struct.

So if I go down these lines, maybe for sense-triggered updates I can 
have something where scsi-multipath.c or scsi_dh_alua.c can trigger the 
RTPG to be issued and this updates scsi_device ALUA info. It sounds 
simple enough, but probably isn't for scsi_dh_alua.c :)

Thanks!
