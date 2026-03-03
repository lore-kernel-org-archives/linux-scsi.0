Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780683B3BE1;
	Tue,  3 Mar 2026 10:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772535029; cv=fail; b=acLtlt5OQJkHmfaskhXfdUsYQ4UBirrcNoHA9UIyUKoeiTsYJhv7qhFqenZB8CHPLkWYmHVK95DaUne1QuKyrN14vZdq07jewxaL9qLARVBMKbe+iBSsPN/hhr3klDz0V9G5lZrJupcVPVUe3CxYVUxj9bMNKis0aSOd8EtIqjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772535029; c=relaxed/simple;
	bh=uBjIVFRNu7BSOlqtfWWiCtbtjpKfsA0PUDduqlQBBrg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mcjOirJ1nNK6DTcmm17MEgiW7OeisXcTonL9eubEM2wsF0Tn1PHq777gRfY19aoPkJw6LZXF1g93NG+hUpLSLeE8ZziY/iOHKavsgAWnJkwTnJyV7i8nfcdqnVpNm58K0mso6hzDgL/JZuP8TTlaosZ9J+ROmq7KIPTy4afccRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pOO9UbM0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZBynNhxR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pOO9UbM0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZBynNhxR"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239StNm3123912;
	Tue, 3 Mar 2026 10:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JhcSplDRJ4/hnocpH4ckQoYOxmQYCXm+tQxsAhD76no=; b=
	pOO9UbM0O2Puc2xwlKwdmusuJaSi6zvAQ7e5ZUFh36/8chCI/YmkI6KjPG99ushk
	qvOg8tuoQC1/V37COuFfwCSglFAso55/JnvgQXVhZsbN3xHPbY0vJsx4499sEqTf
	NYf0VsFqYt/zGVVCtn9eLiCOIPUgluV/zlrfhoTAmFkabF5GP/F9zXPFgniYDPTG
	BglmclGdshMl6xzNjB78vmubzIgzpBxt+gSUEFCMrslN/0wW2E17KYA0DVLtKvEo
	OIxlGE8gKFvOsZaVjPA4eNIA+CejT2Zq4ogOej82KORSki6p2AYxgmV8X0YqLWj0
	nazYoye2cnYCg8XJOqIrJQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnw1br49q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:49:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6239apuH034703;
	Tue, 3 Mar 2026 10:49:30 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpte68fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:49:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x+FvPIDAlFLC2sEDqMwiMP/0NwonQKCgVmFYTcYemLM7sKP3WBjfLJEQgXFvvzEWc0eHKX/QkK4y4Jy5YbefGptPtGPvbUFOnar8XvUdhShRyrBBqh4wOJosXZA+cnDk1pkwXuP8Pu282N1FaWG7cIa5NxxpRRadEavGRSZ3/zd/p8UPAeK7v1SCEqdn2c03jiM/8L07o0nJW7bG2wvbJqVA2H6U3VXXx8Q8VrQIjW7zeW0ztQshR1S5kOpXCyQB/E91gMrhndJpAbY0JiLzYCcLkxtQoAHw7fwPiWMLfC9ApeF/lFTdhFs+Qj1PDhWTONYzo0LsIY7mRSfWYIBMFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhcSplDRJ4/hnocpH4ckQoYOxmQYCXm+tQxsAhD76no=;
 b=n012q2xV5ibpH8ND1UDB+NUO41TCdLmMjpA/qs0DYoKqIcE8MDJfrxgO4cYJY0C0yRZJ2s64Fg3duhVrhmfwk+WC+WEnE2rSMoraLHEgNt0IHHamgGVsqlEZxTGYNvP9b2b70D05cFuTvdtYNimT7HGJ/dZrJWUhcu/U9HuUciyrg3+Nl34tlTgUQFGd481RlDNPhLlQw29qtlPaDxZhJ8f5hme64bWUHxOUOHsntDM0MjK4M/PklCxqUjJ31BMLvRTjDpfGBfOxzW6t4KTSfZ+KYRMAjQyUJEDdQLKLo4QJQhUEtWMUlUR2cZRYpdtWO5fq2pG4QF2oSB5SkhEcCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhcSplDRJ4/hnocpH4ckQoYOxmQYCXm+tQxsAhD76no=;
 b=ZBynNhxRGiDXjY+Hx16hSblEkfNsnFd9gS50H9HeZ+cRm2jXCnZRPcsQw84bs/ACBFj1TGMBC+d5VUWFaukCukYOK1L5XNLRxM8FxAQ5epa49og7RNp295gAsL3FF1BszOq5ERGhT0AKICGZWWLWF6mKdsGtALms26WsM0xCTU0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by EAYPR10MB997831.namprd10.prod.outlook.com
 (2603:10b6:303:2c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 10:49:28 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 10:49:28 +0000
Message-ID: <9b8fed13-ed08-4d94-813b-1991bd853266@oracle.com>
Date: Tue, 3 Mar 2026 10:49:23 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/24] scsi-multipath: provide sysfs link from to
 scsi_device
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-6-john.g.garry@oracle.com>
 <3c173449-bad5-4d74-bdff-4fc9fe4df566@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <3c173449-bad5-4d74-bdff-4fc9fe4df566@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU2P251CA0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::25) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|EAYPR10MB997831:EE_
X-MS-Office365-Filtering-Correlation-Id: 05bb7048-08c1-4dd6-5e4c-08de79128abe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	iAYZY9sPBExmkt7DYlFFSBu4NZVzBml8EX4E9Tvl7SGRRw3VwVy6K5ahBYGvResVAPeku3jJcMu4HX4UC/YRRSuUFC6Vo5dx2v6wsb336nMNfX57Dkx7uQft5FgTStSpS9P2j6uSB++80GKo+3TOgJoyeypg0NKPpKRrWKwsNnlMzRxp95/3ER6GlK1sHsTZov78LogTW//AH5PPXCtbibvX6xlMCac/l55Ba0ZvyCME/6iAJYjEVx0wHcFZ5IZORanz4g8q22t41dj6m+Tb/c3OTSvu4CvQ/Pcz4+1TdeL+gm13sqZ+DG2H+5yayvUJHl0/gAtHpqxOSs+1VMW7ye/PFkCrp4dx3uzHj3WP5w1E3pvhrFT644CVPo17lMQyfZDOHCEFsfA2NsbF9XnZTHwQrhYO9yTBcdRxFOHlAW18h0S+D0K3PDE9oBl1BxDRD3YLHyuk3UEKQUXkiiqeK7Nlz7ep16D8WFjRJDKyZlg+S79iMGyKerQKd81O56OHN0T/waBOTrQWjJEwQY4N7PWScFWk5MQzoCtEADzIQontPYnaS9SPMNdMJleGT92slJlnxRpNl7k9wjw6sAgIpiF3dAORXsQMLxnHMNTiJEKx5VRTDASGrDCJ6AURD4cdjjiHDPGkla+ZGrzHlckv826iVe4pNBcem21Ui5z3PHUDSttUVCG6VgITDSGYQxmvxLBSYfhpuZK1wpMy4omfaz83Z13U7mGbMV7SRmvNoc4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0NIL3BEYXgwRDZJa1BLNG1pMmdIdDk2WVQxRkw4dHBCM1QrRUFIblpVclhk?=
 =?utf-8?B?bERLK2ZmZ1dOMlp5cW80bStSdGFVWmFCZHhQZkYvaGxseE00QkdrMEJKVmtu?=
 =?utf-8?B?VWpKak1vRTJVYk55bEVhcWo4UWZBR3IwbEJNMzMxS1VwKzBHaXhMQkpuZHlF?=
 =?utf-8?B?MTNlKzNhNVBwQjVpd0I5WXdITjcwZk9nR05sSW92VFdzSk9NbnRoVUJGaU9D?=
 =?utf-8?B?VE55d29BeTE5bnVhVGNkazBIYzdLVkFlc1FvQncvOERRYUo5VGp2VTd5TnVv?=
 =?utf-8?B?Q1VkWmpQcGI0b2VtMmVsdWd4Y1pGZFFyUlgrUWMxZndJbDNIQzR1SGMyUW92?=
 =?utf-8?B?dmxPckhZc1JRM3E0ZVFhU2xud0kvVkxMcWFpd1dEWnJMMWtQb3JEaFYxNjdB?=
 =?utf-8?B?UXlrYW1paXhKdUk5WFkwNms2Y3hRcWJjVEl6dGMzY3NvWmgyZm9lUXRqeVVV?=
 =?utf-8?B?cDBUV0ZQSWdNTDhicXFIb2tlL0hLcnpwaFVsRnhFSERRZzQ1aHBzVnNFWFpv?=
 =?utf-8?B?VVljNUl2elJnY2h3YzNIU3F2ZWRJcE5HeTN5NHdIQk1RSVRJMCtjN3R6dDlm?=
 =?utf-8?B?dDEvQW9jT3REZlE1a1ZhcDljdThYWnF4RVQ0Sm1PSTg0alkxZlRKRjcybTgr?=
 =?utf-8?B?QXJ2MC8zd1RhYm9WWGlxa3Y4WlR2SW9FN3lCSUZQNjlBY2VaMU9wdXZ1eXl2?=
 =?utf-8?B?NE1mU0JOanZpN05QV3JLSHRCbEVDYW5odnpKTkEyVGlDOTVqdWFycHhxMmdw?=
 =?utf-8?B?V3pmWGRFWmtyOTc4cnh3QnR1T1lMbFBvMTduUWpJd1E2bzhEMFUwRkFHZWty?=
 =?utf-8?B?WXFZVDNTTjdOUWZLdDlkZzRQcUxlekdMNDNWNHJwVGloWUNVMHF2VkZreE5L?=
 =?utf-8?B?eUQzb1lOR1pPUDRxYmlwQVZycEZtbmZPK1lGRncwcVlyRi95cHlBaEI0UjlE?=
 =?utf-8?B?dG8vakRjYmdseXhEaGZPcDY0UThOa1dqNDVIbVZHcE5ZK29yL1dWb25kM0Jh?=
 =?utf-8?B?YWw5L0lZa3U3cFd2Q0M2QlBlQnVkKy9WanpuYThEUXZCZlE1M0ZFaXdjVmxn?=
 =?utf-8?B?R3BDMnJBc0NBTGhYdVRlc2lhcms3MEI3U3BWb256Q2RGNllPakZ3djRTQXZL?=
 =?utf-8?B?U1V3T2tkSEhES1N3YmEwc3NMd2ROd3ZVQ3pQMlZ3eTVVUGNGNzhjRVl2SHJq?=
 =?utf-8?B?a3JkTDJ3NTRVQ1BORWpnN2RORFNSd3F1dlJjcGZxaXBLR1JQNG9vQ0E1MS9F?=
 =?utf-8?B?VFhNdUIvT0U0RjVjemJrNzYxbHNpenZoWXFQN1VlZ1ZjdUExN1lMc091d3Bq?=
 =?utf-8?B?elJ4emNsVHRNYnQwM3JzYlpkWnptNUUvSCtpSHpIOFhRTExObExRRlkrM042?=
 =?utf-8?B?aUdHTlp2ZlRqY2dxTjVZNk1jVmlkZy9NcTMxVjl3WDZ3UkR3TngyRFUwY1NG?=
 =?utf-8?B?RVROajd4a2lKdFp2SFMvN1dGK0xtaXJUSGdNK2lMMnVpZFFncElqQ1lxMzh3?=
 =?utf-8?B?TDk2bmMrMmp3a1BMazFHNFBiakhwZFcrdy9DcWk5YUg3TDkxTFlqWlN5eGd4?=
 =?utf-8?B?a1ArdS94RWpaekJ4bFBpci8wdXQ4MmxQYmNIYTVGMFNZSnQrZ3BVaTJyWStp?=
 =?utf-8?B?eVdxK0lSZXMxazM1Q3E4a1UvZ3M4a3ljbi83aHBWbmdBSGowWDc2VTJpdUhX?=
 =?utf-8?B?VFJqWk1PcktnazdvOGt0aGNTd0NmMDlEMXZ4VEF1SzA0S3dEMjZQdEFJSEdn?=
 =?utf-8?B?NFZEY1JvYjhPNSs2RTRreXU0Q0g4TXhTNmFQeFVsNEdHSndSZ0lGemlINWFk?=
 =?utf-8?B?bCtnL1NocnBFR3hKREwrbCt1Ykw3S1MzbE84Q29tcjZaVmY4WDNQdXBrUmdH?=
 =?utf-8?B?S0NRZDRVeHBBMDdMSVhvNmwxUHZqVzZ0bHBGdWZzMUpsVE9uRzVtNDk3Y2V1?=
 =?utf-8?B?ZVpwUEpyUEorQ2h6WlZpRWVlaitvOVVHYzFYM2dadUxoUk9XalpaUTZsQitm?=
 =?utf-8?B?OWZkNVZpOUprMDJpUlNTVXVVME42eDBUODU3L21tSjN2dEdsZDE0aEtNSjBr?=
 =?utf-8?B?YUNUUkFDS0xtTElpTU9sNFBNcEJyL0padVVXdWp6UXZ6dWxkMVNNb2lRK2RQ?=
 =?utf-8?B?VTdnM0M4ZFhiTVVJaGxNaGxHNDhKN3BnU0x0WDlsR2xPMHMzMzB0dDJmQkJk?=
 =?utf-8?B?NndFNGE4V0NIaklGb3lRU2xUdGhSVmdGZlVJUExlZ1N4Z2V6T0FuNExTcFJr?=
 =?utf-8?B?M21BcE9sa09GQi9lbnFjYlhGSnFtU1hIL1lHRVU5UUxYUFBCQjMyVTYxcVJZ?=
 =?utf-8?B?TnJqZEpQL3RjZ1hiRjhpM280bkNYbk1CVjVHcCtlVUtaeW5IcXRzdUxwZ2FJ?=
 =?utf-8?Q?Ih44dSaPrUGR++nk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1c+svAOCdk1H6lyxVAccY9KR1WwC3Oabfyk+DPR6Tj8ENoYPWNVVpQnuVzMnR9KTJlTTONFVLqglQ6IGzuDeUfG4y3U1Lc5oDYIchb6zblEYv95cyJNierKHk+D6Hk5xvA5GxSqY1oMDxEoSyJ2T55MpY/mqHNybu/Vcp80eJQkjF9T95AQxZ6Hn5YjqohiyTR72A3MozeD7IubXBBB8MhSm3X21K1dpwNxnONMb7eWxmub5fUEfRkwZHlH4zdHwBbdZ2Gc+RPoq3iZJ/F98vkBmrUdSZXHmwoR5tQLy7zqV2vM92XcNCUmsW5stI92aTT5rWfs+sWyLiobY/AGN+QAR6je7VQ+80xX+fWp4Duy5kDVq77wE9jbk7u3rmpyGumEdQO94LDjUJWdrJCAJgIsWEkB5B5EAl84WN9vPf0Df4LPFGbEiHYFSs/2RZi/KmE3/SwWvHdXBG47DhssEcph+UT5ogpufJyrNGK0h5hKWmooK3bpsCNaOux0mROedNumvQvlSmhWVQnJqh2oBwT7d/VdZ3ax68D+W4CcYE8OCzBU6KZn2KUQZBAsVfgGB0Ox3F66n2k1RdlaC/eGfCz7BVLKfK1jHrK5LxDm5eYQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05bb7048-08c1-4dd6-5e4c-08de79128abe
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 10:49:28.0069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JpsxxEo+tjL+xw93eH+C2EwbBgEumgNcXyLDRX551CJ0iif4t/VyOwzBMJkCS2X4TesZR6Hnwgvom2zM77J0uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR10MB997831
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603030083
X-Proofpoint-ORIG-GUID: wGdewu51DascJhsv5Wd-bPWnJE4xmslJ
X-Authority-Analysis: v=2.4 cv=JPo2csKb c=1 sm=1 tr=0 ts=69a6bcbc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8
 a=lq0t0m91CCe9axNVpt0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12261
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4MiBTYWx0ZWRfXySyEoz/He1we
 kIaQ3O9OWsU+qIEAYB+xTjxdZe7cfVpc8BnFAcwlD0ojdbPzYIMM5Ncn8Mnj4xU5yetRaAGMIHB
 jVCVpTzpjJG0Xj7m2e0vmz8a3g+d5KN2CwAlHWw1vJsJAdNtFxA/cwtBO1jC8KKveuc75opKg86
 n/z+l7NpYpxKzXUGQ+sGyDlrIw57iSYw4fVvy9hiunLZjwRgg9RoztnYTEJcdIK0jqtyHQOtZL3
 CvmRUvE/b0HLnGU/IajKB5PcDjuyrLz4yQjU0HYpME+CGBUU8k4y5x2oUzogAIGL5yRhqZZp/Va
 YjKxHjC4gp/GiuyxE9ChYCocJqTjSkaSTffxkYj5HzzVhhf5X8o1fGuQEcdJqM/iIuPy6NiwICn
 kJ0Cj8ETC3/P9AKcKxTYKK3rCgRUmxFhebhB+Fa8syhfj3b4Uzi4ceANWE8LOOg1oGACwyHWSpo
 k9Ujx1h4qXL5Ej1OLPBWt4xQVEe0FnD1NM4qeYEc=
X-Proofpoint-GUID: wGdewu51DascJhsv5Wd-bPWnJE4xmslJ

On 03/03/2026 07:19, Hannes Reinecke wrote:
>> An example is as follows:
>> # ls -l /sys/class/scsi_mpath_device/0/multipath/
>> total 0
>> lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 - 
>> > ../../../../platform/host8/session1/target8:0:0/8:0:0:0
>> lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 - 
>> > ../../../../platform/host9/session2/target9:0:0/9:0:0:0
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/scsi/scsi_multipath.c | 45 +++++++++++++++++++++++++++++++++++
>>   drivers/scsi/scsi_sysfs.c     |  5 ++++
>>   include/scsi/scsi_multipath.h |  9 +++++++
>>   3 files changed, 59 insertions(+)
>>
> And again; just what I complained about in the previous patch.
> Still not sure about the naming; 'multipath' conveys to me
> the opposite (ie the multipath device, not the devices which
> are part of a multipath device).

Yeah, maybe "paths" would be better.

However, I am just following the pre-existing example in NVMe, which has:
# ls -l /sys/devices/virtual/nvme-subsystem/nvme-subsys1/nvme1n1/multipath
total 0
lrwxrwxrwx    1 root     root             0 Mar  3 10:42 nvme1c1n1 ->
../../../../nvme-fabrics/ctl/nvme1/nvme1c1n1
lrwxrwxrwx    1 root     root             0 Mar  3 10:42 nvme1c2n1 ->
../../../../nvme-fabrics/ctl/nvme2/nvme1c2n1
#

Some of the sysfs code/structures is also shared from libmultipath also.

Thanks!

