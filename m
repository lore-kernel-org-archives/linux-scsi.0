Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18423BE16B;
	Fri, 10 Apr 2026 11:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775821797; cv=fail; b=ONKc40htmlO78SQRuc2jUWoGrEtQWSgZQi3SOLZeySuPXQ0tE8K299E26OirUC0UdDJL9Wd1XLeZ84wDYppVKCf5lMzUlxflqfMU/aoY0wxc7XqT/lsbetRrzWEkXotaM9tOmWd7vOjCjmJhAgSKqYquOdqu8zXAEwc9KUrsIxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775821797; c=relaxed/simple;
	bh=yNrCO8bk2L7H0lxRR9a5sZYmhKLc0tAhqVQpiSkxhrQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rhnAuXtBlPDLTtqgXZ1C2/gZ5edlBeyuA5hsZ+VpOnMybXYIo+ibG1pBU1eJIBhhMEN021pdaiKcUv+FZ5k/GpNH9OBtO1vNmt1poXL479DZNql1Q9HlbsZH6MiUB2QuRL+59HMI1+Wwaqj3w45pQPhWqAgHFn1+Lz5Wp2bVC8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ITzMwgsQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W8XlNb5d; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ITzMwgsQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W8XlNb5d"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A8tWWU3970046;
	Fri, 10 Apr 2026 11:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PtTln2P+Jf5iiI4Gy8kC+8IEe1IzH/3FjRbPoXOtwOE=; b=
	ITzMwgsQk27dcF8ETRHI79OH0Vc761pJkjzQirpRD8qgQd6b0UeC+Yq1PmML3nhd
	nUwK4bPb6prTFd4CSkd4gHkKtA3DL0uLSF9vpA6bIssbWFU8xi0RsKg0laWx8TDE
	MdnYR6/2bk4uaFEER5s2qaKvcSyEnrIlIUR2hzeNXngeJ/BEp/l9xG6ckD8cZXlI
	/sfEspMcleNkAV5rs8jdnE4MPSKL7PM2wTgQelRsRgoMCyuTco52/szMt+ryjRtV
	3c6T6K8NvkLB3iFI5G+lvxjZssX8Ozb8szjO8TZHlUIxqAd386vrPnYOeMRgR3qd
	IQnXP4M2faRTwN9Yrkcpcg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqaskvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 11:49:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63A99C3G005017;
	Fri, 10 Apr 2026 11:49:24 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011053.outbound.protection.outlook.com [52.101.57.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxt35sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 11:49:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ab82PHW3nRxc7mOC4Unn+Pgxuqyuwa6wQjIYBmnV19W+B8o5AD7SbszXU63KF5PytWUK2ykJkXjdLa7RkYSPBlcDpnlR6u91lWUZfEr0JOfnXXeKIcTMyiVd6ZxPq8gr+zMaMBAAtm5inCC5afDpLkiFpJ0iMY9z/8Hwbz5Rp21vq5zTNk20hYL452cH414qfBo4xMaFzK8NhzxEJFEhVipnd+AhMIT0EUDw2sjEesYzbvlDjU/fWVkeOaIsLvTiEYpcOmr76ilBTfWF7sTL76LtlU5hz9P3SdAOI94rh7e3vBQaZUBiT12Cvkj1RhURa06P1FNd3lNs4lBkNzcjUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtTln2P+Jf5iiI4Gy8kC+8IEe1IzH/3FjRbPoXOtwOE=;
 b=ePU+tlE4tyBWP9br613qQtz25KFAyItZwiZ2YsJBk7iYQE2PM3DBIxtPN1hl1lerCv1i+vx+8Rr5Sh6yVBwdG6Tl1MDrsHjimxG++GBQzQyI/CSf/Tr5+Z0BjnYV+gowYnsoAadeR5hBvfcuTTYS2i4bcItjMNhCiC7jeohCsDl2hkVBbMfKJP809CYioYDnpswXZQXivqeW3JpXSoYMbTzkrTWl3/6xvJ2n3QZYcjQTtmUfJZVOQALsUI4HShmlNM5vjE/O5RpYzfd/6pyQ2rZkbFzerKFQmE86cnVyNEWYenh8utWT02Z55Sc7nTP8ysuLRQeiPMgo8PcqlcUQHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtTln2P+Jf5iiI4Gy8kC+8IEe1IzH/3FjRbPoXOtwOE=;
 b=W8XlNb5def3x0L5su3LDia++OxAwp/aUQIJylCgA4TcGTVqP5YHCP1NSf3bcPjgk45FNBCD6JSA/cKDk88WwM3L882G6Hqorc+8wxRe5eWJOe5Sw+ZBPd2IOpS2bh7bk0gey6yN98jx0EugyiVAl+lYwuwLPq0exScj2grIsml0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB7190.namprd10.prod.outlook.com
 (2603:10b6:8:db::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 10 Apr
 2026 11:49:20 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Fri, 10 Apr 2026
 11:49:20 +0000
Message-ID: <bd7b829f-701e-477a-b3cd-5517d4459812@oracle.com>
Date: Fri, 10 Apr 2026 12:49:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: Nilay Shroff <nilay@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
        hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
 <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
 <6d7a4076-a4ad-4185-8e82-8e27d704d20e@suse.de>
 <c5334a6b-8089-4ee5-abd3-8340133db29a@oracle.com>
 <79725a83-3dc1-4398-ac86-c3e317e0e107@linux.ibm.com>
 <ccfc867c-e744-42a2-9b22-47245a6c06d7@oracle.com>
 <da2bfbb0-70ef-4c3a-a235-1343b4a02489@linux.ibm.com>
 <b77d5eab-d50f-4102-8bfb-f907cf39ca56@oracle.com>
 <a1d72045-7b0e-4354-8365-f21f03765659@linux.ibm.com>
 <8d9c2ee9-0c2b-4c64-badc-b5b0fc1eaf67@oracle.com>
 <8502c8d6-2958-4c46-bdba-95b91c2ceb10@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <8502c8d6-2958-4c46-bdba-95b91c2ceb10@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0274.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: c8f8c849-0846-43af-74d9-08de96f733ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	+3of7XTkm3sBBv/G094MBqleeCmF/T/Mpgp21lpSRzksI+xXb9NJUslh98+fDGGVYR+0zlFZLsMpFaUy0AeXntzXjdWWdpQpCqFgt7kwBcHzoyBXDbb+mSQFzkkdNgZdzsb15thWVELGAXtPAOSXuU81gAKPoYyMxErKRBDqXiWnSEIY6X9wnBixK/EVgVdqCLtBCARvlzKaE7NmzsPgnjRiW9PDxaC47c907cj0BXNYnCqbqXfhsrSB9Amk2b9Bsj0ijj2UYjRRUkEC7XCDtRmaHl9a72lplrKkqerF3bMFB6J+UVfMWWlH+UBzvGsvvLPxfAzElY1mF4T5OazzF4L1OHjSZD6Z8sOBaShmOJyldo3pQpmIm+TGZt3vMMeK8ZiQWY98YH4QEPBoh0wCZVI7TGV/dcRWCwOlPD737WQwmFhEuU37na9cC+9d0s9iuO9XyooxXeSfuqmrR7LnnyPNHpvfIWolgaSRP3W35vGO06ODZK2wevPm5jAvXGaGXrrmGycBd364kbdLZR1OfB6zFz+n7NMkXbBargp6j1+UpfdRusM+7g47QwGMgHBay+lwjaL1ukdO/HHmeuqcTJJZZpmqh5ekdewVMCwQiLwgI4iAvWUWt7jGg8/AN9pTPQkYrgykIRlxyMjVLVEo95D+XZOYfRAe7TVmjoFYlsTqXI+P91mRs+xVKRF2ye+uijgIsM1xCtoIIUeknu/uGrE8Tc5hzJ59A1YY4AxDTtY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nm8waUlkQ2ZoTE1EdmRTazh4TXhRclpLL0o1QlRHZ3NJajJXVXh2bit1UCtt?=
 =?utf-8?B?MStJQ2FreGdUZlF5ZUhqRnNBR3lCaHNuMkQvazkxN09rcWo3blZGSlJldDQ0?=
 =?utf-8?B?Z21wZXFGSlcxbjdwYWhqa1A2TXJSNzZoNExrQWZ0SEoxR1J2ZXNEMWJKWmlZ?=
 =?utf-8?B?QklNRzZObzRYMDQ3TXJMWk1zZXhWbngycityV05UOGxZRUdEd3VuQXp0bVlL?=
 =?utf-8?B?KzNyQzRnclZoZEN3VHEvcUtCWStMR1VFQ3JqVVFQNytQMHd1TEg4SVBJak81?=
 =?utf-8?B?NUdBNGFDN3lzV1cvSjhyamJWUmtDdEs2SWN2bXdiY0pwQmxmOHp5NGhJNUZz?=
 =?utf-8?B?dnc0UllURmJVdUkrVXF4MHVjTk5JMlU4Y3g1eGs0b0VUVUhPTklBSCt3UTlD?=
 =?utf-8?B?eFZGSW8wK253Q3FyZjVPQWhyRUVjcVV3WStnNjlyd0cvUDZ0dUpZU3VPOGg4?=
 =?utf-8?B?dkxaSThEQ0hIMVZ1aUtWSFFLNnpteTJzRDYxN3FpOFNKclF0MHYyamZ6OFV6?=
 =?utf-8?B?V2V1UkhKeElEVmZXRzJyUXpWWkZEZ05nbkptSTlHaWZCZjFUU1ZsdUFNUGM4?=
 =?utf-8?B?WEszbG1oNC9HOUFIeVM2aFFlNUVjbVkrcXFCU1RlSlgvcVNyRzMwZlBQekNi?=
 =?utf-8?B?QU5zM3E5NkpuZEdmWTVWQk9jMThqS1dhNlRwdjdueVhIc0dhZ0pYUUlSMDd3?=
 =?utf-8?B?MU9SMjg2YytPaGc1aldwU3pZTWRBNmFGUGNUa2wwOUNwZWY1SFZoNTdYK1Rm?=
 =?utf-8?B?VGtaZVRWczk0Mmt3eHFLeUw2SndsYzhrY3F4bnNOR2N3WTFXNnFPd0VlZVhZ?=
 =?utf-8?B?MlYrbmpjS3ZqMmpseHhHUVhpSWhEd0hVaFRIa0VhQVY4MHF4Y25zbE0rRDd0?=
 =?utf-8?B?WWhTWU9kZG1VZ0luYVp5dFRqVnV6TGhIdmdHYmdKWDF1UHpTYmFESDE3T0dh?=
 =?utf-8?B?WjgvYzZjT0tWTzlBS2ltQ1F6VnFyYnI2bUR2ckViSFU3UERFMjU5b0dSNDkw?=
 =?utf-8?B?ejB5ZW5IZzJjRnBZRExEd3lVM2hlS3REdTQwT3lqdGxLdHpnUE5MSzhGZmhk?=
 =?utf-8?B?NEZ5ZXh5YTNNN084ZFVMdnhIUzc4ZTM1YXpNVDdPR3BrYzJmNXJiYkY1b0kv?=
 =?utf-8?B?Vkk2SmVONmNwR2Y1T3lndXJ1aWFUblZxR0hvUEFqajJvTTJCZ285WnhjVkdr?=
 =?utf-8?B?SytuME0ycFZ5bGFkRzVwanNvTEZCQkpJdmlpUkJnMndxQTdTNURnckF1TzZp?=
 =?utf-8?B?dFg4MzRidk91RUEwTS9VUndOQ091djNTTkk4eTZzRXFRMENsbVJWRWNVUFo5?=
 =?utf-8?B?NWd5NFJuaFBDMXhqdEhvQlo3SGtBcFV5QlpoczI5MC9wUFljSnYxbExPcVZr?=
 =?utf-8?B?aUg2dVJGSlVBcnFtL2JlVFMwYjZGRFl6dVBTTlRJUDEzeEhKRzY4ZTY0Mk5i?=
 =?utf-8?B?akk4aGNXeU1Bb2pxSktBdkpzeGlMbWV2dmt6ekt5S1l1WlY1YTFteGY5WTFB?=
 =?utf-8?B?NGNkTE4rTzBrb2gzNVNieUZYRjRrNm91eDhEMDZocmk4V1VhM2FEenpNQncz?=
 =?utf-8?B?MlNabzA5bmd5cENTa0JSQU9SRlR1UUpRQXVlWEFWSXA0cXNSbzFqNDJaRTFl?=
 =?utf-8?B?dEp6a2UyRHR3cm5qcElhWDNVWWlZbzJ4VVVZMDQxc3lZL2RvRW9oZ25GZFdY?=
 =?utf-8?B?UGxoa2RJUEU3MzV5NTNsamxJYkdGaysySDVCQXFqRU1VcDJ5enpWcmdoc21V?=
 =?utf-8?B?Rm8va3VGR2IrVHZNLzZjbVNrMVhINEN5cGVWN04rUHhYZW1DWmlCeEIzOTdm?=
 =?utf-8?B?VXhpUS9nSk5FdFFqUmpFQlNJSkFWMnp6UmtQTHBmb21CU0d5Y0ZTWUEraHY3?=
 =?utf-8?B?cDBod3RGa3lvQm0zQ3F4cXFDREREeWtyamRjTThuQVEvK1BrUnF6WWhqaEFI?=
 =?utf-8?B?MjhLeXdaM3Z4SFZUb09NcXBLZ1Yyc0w2dFg1V0tQQkhLb284bG1XZkczU1Rl?=
 =?utf-8?B?Zm54SCs4anhHZTExTEU0anZ4MkxDR3lqYjVZNkp3YU45Rjd6ZWE5dXMxYjlI?=
 =?utf-8?B?Mm9BTktxQnJPM1N6dGx0RW55VU9VU1BVemJ0NXVITnd4a3JiVXhFeE05WEor?=
 =?utf-8?B?dnBuMHZ3UXFRaEJXOTduZENwRWwvenpRLzkrR25zWTIrL1h0SWVnVFRLVzlK?=
 =?utf-8?B?TVp5NElYblE5ZFdqTTc4dGdjOGkxcDJYTUN4T3phUkcyQThsRUZtdUcrU3o3?=
 =?utf-8?B?RDZ6RXpWeG9hWFQ3MHNLNi9FRUo1S2xnRU1pS0U0a0xXc0NTZmNsRkI2eUUz?=
 =?utf-8?B?eUtzZkJLNFpUdWkxcmdGNG9jdkFFQkZDYlFJYVVXdmxRZlZyeFFvQT09?=
X-Exchange-RoutingPolicyChecked:
	h0K9Om07Sx3k/2amdUuIPhp/P87S0gOnqC88oh2RCb78AfNjkQVBAWbJnaHah5f+lJ/ozYY2k7LFkolO4zISaXH5wuO3tb1AGQO/YWdW9IWq1tOgqBMyq5FHWFUQ/ZUfne9i7W8cPkXIGwpGNjbEKW8/RLqYoy0DhYc2SIAE8QunQJcBxyRHDD4VjHGrUOArJFzmLhCQMsXv6TVkzE3aBnD4Gu8aMvfrGK1nwH/FHFWnq2geaUWYlnOAGmT4J825mXitxdA1skjNlys5CepdVT7k4M/Zqd8rWvYiZEjhBJx4DusyP4EpMIStVhan28w7/F0OD8KABebaIolxpjxBHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wP3k9lH3Z+8xNnvWRDsOMBzGZfSTSfUiU9g9oXjbbabynbkTrQvENt9lAMRxKy2+vJ3pYPTlBZO2uRMNXUw1xQVqzRv/PpBckTkLLgtw2XF68YioyyjmfdFz7KsQpEr+tr+q12m0rKgGwULD/t1NYsZhGWYNLN5uBdAPlmvmlFvcTbsfwy79CobkXWfpjGT+0eJkCgWwpH39cbNneyOoAhwp3KDAopdS7QaN4osQkBbyLK08TV6C2bbERskZGF618p+338NP7/++kUsTi2bvA4Fea6IXsm9NVeNidQDOTFLGL0+SV0JdMJe4YcRssgBpezLvnRvIZlxArO8BPzEs/K4L7+jjMN4r6C6MRieqvieeTklvO2LPqJ4AB8Ll6iWlDojq1rsK34iBcqYWDiqFe1ksf//mRhw8MVUx0stSH7H3f1zLW6mgfDNZWMohLsCmOhkt2HMAf6YD9DjnEywA3/MJEcDVxuyAXkOEsaCwed8ew7wKjwUpKqfnrBa7NVreu03EiUHwSF/PCvTz62L8GNvw9u2jNdW62ToG9Z0objHy5Ry97ntBqAOkHOQsR1Cf8Y53E6lSxYyleX/V0iPVn8XiX78FUnC7QUfz8Gn9YHk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f8c849-0846-43af-74d9-08de96f733ab
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 11:49:20.4204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCkhS+uSBnCbKDoa3NV49Y8CmoC+JIREuUWJWU/MKbQWfx5nGaKrgsQIv3fmNv0QBkxweY/+v5qv4t5Ge1flIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604100110
X-Proofpoint-ORIG-GUID: KxDrtLpu_4EmZB8p9EHTW9bCigK75owI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExMCBTYWx0ZWRfXxcJM2gSlygz3
 KfOW9EY1mYzbkECJYJFjRmbK9sqzBwrG1TpivCCdVaPzzeGKhoOsBWt5TFuKRqwzESQgl0VkLYT
 P1zXXCN8kyadp0wNdbfQpC6QC7GMi6DkIFp2EbGg/Ke5BZxQAk6f0tatq6Bqz8kqnwE9GWsSjWU
 caFDfLevFTIfwCVBVIm6PDO89WNeoTVOa7Ifibt+uhVsD7WPWTeK1eaIR7c16ZuBOxaUKbQ/CYx
 FX8TuGTlPlCYRKKgAWnaPT/AqpAmzBXSBfz2XHrO+kmrJatRm04X5uH8xbY5AiBPsp7/Uo+0nNe
 i7l67vpV0/locvMq+zbgDfxepcTrIKUVMkLtUWd1BxHvznqu11lBg1udW1oWTvgd7deIzWeEQWV
 L/6aWdH4lhFKMMs9Oz2DgmSDgt2aODKvDGkftOuWGApo3GUJIzeGa6dk969gb2QhJdRdZqJEWyN
 /rht11ajbav9SVGx6qQ==
X-Authority-Analysis: v=2.4 cv=AsTeGu9P c=1 sm=1 tr=0 ts=69d8e3c4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=I-_9VvOg-TPdbGo7vVMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: KxDrtLpu_4EmZB8p9EHTW9bCigK75owI

On 10/04/2026 11:51, Nilay Shroff wrote:
>> About the module refcounting, as I mentioned earlier it's hard to test 
>> this effectively. We could use lsmod to check refcount on nvme ko 
>> during the delayed removal window and ensure that it was incremented. 
>> I'm not sure if it is robust and whether the complexity is worth it.
>>
> Regarding module refcnt, I think that's easily available
> if we read /sys/module/<mod-name>/refcnt. We may not
> need to parse lsmod output.

Sure, so we would be testing this behaviour:

# echo 40 > 
/sys/class/nvme-subsystem/nvme-subsys1/nvme1n1/delayed_removal_secs
# cat /sys/module/nvme_core/refcnt
3
# nvme disconnect -n nvme-test-target
[  562.533253] nvme nvme1: Removing ctrl: NQN "nvme-test-target"
[  562.565462] nvme nvme2: Removing ctrl: NQN "nvme-test-target"
NQN:nvme-test-target disconnected 2 controller(s)
# cat /sys/module/nvme_core/refcnt
4
# sleep 40
# cat /sys/module/nvme_core/refcnt
3
#

File /sys/module/nvme_core/refcnt would not exist for when it's builtin, 
but I don't think that blktests even support builtin modules.

Cheers
