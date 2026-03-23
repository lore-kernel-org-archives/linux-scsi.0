Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FA03ACF0E;
	Mon, 23 Mar 2026 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273429; cv=fail; b=BWCGkiOgGXd3CWUyn5Sm/oTElRApeI8LNvUH2vREwpFxy+n6SwCpQlWHxxZk0bhm7ryeslHl7cdIGJMZUSBJX4px9nR5q1vev9WsMSRRnNVtugKKhEr8paKfRrQRj/ELTvdduPeOBfK4RD6sCCMpjAMtdky5yhND6hbEFH6+cP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273429; c=relaxed/simple;
	bh=P90TAwXhQBQp3SjPhl8nwD5BHA14RaPjcQvWsU62LnM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ucBu8ERBqbd0QD56Q0a8ErjSnzcLA42rXbf1UYFuGDl/0iuhJg9xy/Z4PFc/CoVfeO6FLJP6cWRq4QnrN5zAhNJsEKWamCnRGi7ZowcVN2Xrf4PEWJQW4i9TEp6RYTghvWyLjqH8vTH1VPC9mj9Sy32007myb0YOdJw6QK9xeMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BcAEzWT9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gsLQIHyd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BcAEzWT9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gsLQIHyd"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MNeUev1554459;
	Mon, 23 Mar 2026 13:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fGpDyQXWrQBHzbATE0r4WcB6foKFAwWPdc75bXoZMzs=; b=
	BcAEzWT9Z3f+R7whDqW8m90/2Ey3JVJow06n18frrWfoTssWp7lP24mRGwRwuXQg
	23U7wvQ2nuivU3I+7Q4JxqL48fxh3QTgaAd81q4Qprx7NxfbWaC3F6JhV69QWTz2
	ZmmYyA6pPCdIz2uenFOf2rxDVy+K8ceQKPpCP05HiZ5Ijgik202bykk/Xc0i0oVO
	ONrwx28BZGqiRABk5kZNMkNn0KOLSSqRIdOi87u18ba+mdUEE4gn6pM8ioY2rRkO
	She/vBOya6thtQxXOW2jxNtw9oqYeeo5meMydzP/coBVyWLmfrOvT9qC5X+9ZmiT
	tdriP9ojJyAo4Y+jWLXvvA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kfpj9tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:43:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NBWhOF012334;
	Mon, 23 Mar 2026 13:43:36 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011059.outbound.protection.outlook.com [40.107.208.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hseh5eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:43:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+d6/HUzG5mHC7VAuOnPqC/HyO/ZbYCBEQNZcjLWqQaeHLX1y685HxsyE1cvnpsfoDz30HMtgAIjpSzKeKDLbvf0l6LLEMPzaL6fZmYdIJqnFIIi+E426XXsTaA3DwEhSIrZLOncGq4EmJMPcxDoW76P/tm9U492OThCDc8x0iZUJhRuiRj6sykA7WpAtrqrzDNrZDP6CwJvBNcLojYmTyL4751aS4COOgi59PFQ3jjeGhTv3v3CrxiopAg5LFPhNfTe8qtv9Y9A9IhSk+fDS2GLAI5YVhIPxS6xYO0+bSjXdcfezu4GG7do5vo6g/BP2HuGFiZSkr1S0g3AthK3gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGpDyQXWrQBHzbATE0r4WcB6foKFAwWPdc75bXoZMzs=;
 b=DHORf1Ozv31G5+t7J8LgFGipJgnLEwIn36qLD+zOW4y1WrBWdG5JDki+eUHlJPXMEL8Bf0d71cxqav6K6R8TmIB17zxvFgJ4kRpgc5ow9Hn9/+mu2eixvtgA5L56zS4MTnsFVhDS9j+h/4FuD4Qf9t/S7maw+zva8YhdaARGgM3Pdc6fybcy5vHH4A52Hzgd6Ke/Bv9h80+ETwJxMexGOr0wcqxNdt0HVUvrX6Ij2xafRp9grSIpAiX389+hUNjSXT3s6A7o5ufz4KrfooPcq3RjfTvWc/IqBbQZgrp8EZqZ1ob2qEgmitX5sO8k0ep054Xq3Nomi8M9O2pepQQ9DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGpDyQXWrQBHzbATE0r4WcB6foKFAwWPdc75bXoZMzs=;
 b=gsLQIHyd2+6odkUYpkWYTSO53pk7Qhvr/KNPkdBFb/wTHabQW5J6dWDCoGiaWNFNIri6VwuAOT8jMy+Kc2RWBtZvr+GHHxYKLFuQyefuIxOdJ8wU9uu6NniLp8uiNwq8m6y5y/XMX5eMs+5gKggNhOPIT74ua0a90DdQE2f/zOQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MW4PR10MB6348.namprd10.prod.outlook.com
 (2603:10b6:303:1ea::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 13:43:09 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 13:43:07 +0000
Message-ID: <649e8a2b-b0b1-4eff-b2f5-56e37b7da980@oracle.com>
Date: Mon, 23 Mar 2026 13:42:59 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/13] scsi: alua: Add scsi_alua_tur()
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-6-john.g.garry@oracle.com>
 <692a4803-743e-4146-a48b-2a9e65326907@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <692a4803-743e-4146-a48b-2a9e65326907@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0038.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:58::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MW4PR10MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: b269853a-aae3-4efe-6ea6-08de88e21d8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hDBhuSjJVd0X/iOMLOoUDS0i83w+U2m5kxnNPDNX6z5IBwbS8Jmr1KcIpr2Bnryo3rXefnB9Kb57oUh4J9yTMFbmq04kBTJjsdJKnqQjEDoZQKzaQF81JSs76EQJ084j2H9caPBmehnhgNJjI1s/y0TcGWP2G3o1J/mFOkXm5AVWv7qdO049RkJBTvKzmNSdC7uKVj687K8rxLhEXIKQAJfACVqR1MgLOUZRveziEA07Q95YNsT7WTVqLT73pLVIA9RKyE+IzpfWcMubTgg5M3Lz53Su2T7eFv3RK8sC02PzdF5FkaRvdtWpww2FFFmKmRPTTnj+1VfT3yBSMhg+ob5+vhC/3dQ9LAXnsIUaJWHmp22Q0NlVvQ1sL7gCRsOToAxIXYBapVkGk9nrOv8c5b4U+wEuzpmnnYJ9Iqojfg/Hn6V9wZgA85bVwhVqFiP1tBLrM47MtaIpPQgyPb79QNWjBCp6DnITPLeixMRog5UMGqzt4lnXVXyXFUbzer4srTfPaFhiWjmNzetNLJbXrAkciToRDb4wqhmhy26ImMqO6HGM9+lG1qrDCtNVuvFU2qaNVQzzw3PMT4ZZJ6brBgrn/aWttIbV+OYftroQIjKQC+5PUV0GbkBfvHhgUGOTTOfkM7TGQ0EBTw/xJ9NdtisKZ3qtUfHTFLXeKHi9iAVrUSO1hD5jke1FAMhyqjVLCEbWxYuuZMaSSRt6Kqu8Emnh5wkZR7L/lbuAsxo6V3w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajdwejYzN0NnZ3NYYXBteUdnOGorbjVTYm9qcmI2RU96WEhzaWIxUGdoTm1I?=
 =?utf-8?B?ZDM4bTRmWDk3ZCtSOUVmZzBOUU4rTWI5RlAxTUNrdGttR2N6M3hiNGFHcUVR?=
 =?utf-8?B?UEM3MVg3a1VHQk9mcGpDa3h2SFBLMEJKZTM4MjRDNzRTZFBTOXFMdDdlMWF2?=
 =?utf-8?B?cFB1MmpCYi93MHk4NHJMVklKZUJ2KzZLdHh5TStWRXVFZTJjQ2dBZUxuajVB?=
 =?utf-8?B?Y0l4Q3F0bHcrMkp4MlhNcUVONW9SNG9oSHBHb1hkMlQ0SUFEYkZJS0dxMDF1?=
 =?utf-8?B?Q0pjS2hTKy85TjlpaXFCTzdkcERWVjlNVU5SaXNxYksyZDVaZGNqQ2FnYnQr?=
 =?utf-8?B?ejcwWkExSGp5dTNVK2J3RkRORWloNHVKOVpYbnhxUlZ0VEgyb0xjSlFnWEJV?=
 =?utf-8?B?QUpUWEhEV29jRlFEVVlDUytXVVRlRm1GdG00UzhsMlB0ZFRUUHVHRTBXTUlY?=
 =?utf-8?B?OG1QVWlSZEFpRHFHQnNjUlhRa2VxUW1hSjZJbGhFZW42aWpFcUR1Nk9aUWhh?=
 =?utf-8?B?U3JPRTAxb1A5RDZHcmdFbUpOL0U2RFhQSjhpRHhEUXlJazlWeERHMWlhdXI4?=
 =?utf-8?B?cW1zMzU5ZDEydmxmVEZvWWIxL1RDdmJFMy9KTVpwL0xuMmRseFQ1MXpabkZz?=
 =?utf-8?B?ZHpWdmkwSlNrZWZaRUpCRVFZRjFPS2hKL2hoakpEL1h4RFB0Y1lvYmwxK3E3?=
 =?utf-8?B?aFZwSkZXSWtaRFpjbmZZN0w2VGt5U2tySjNHRkFyVG1TZGpRV3BYMDRYc0Ry?=
 =?utf-8?B?NW5STEJvNWlQM3Vrc1VIeThRN3ZVRVVjZVU1Qkx6bUttSkpzZS9jY1N4RkxH?=
 =?utf-8?B?OWFDKzJXcjcxT1UraTFVekNrOHIwRGVsN3BadC84VXllRWJ6LzBJcVJYS01v?=
 =?utf-8?B?ajJ3UnIyd2hZbTAyZFFEdGxMMWl2T2U5Z1VHUjRNTjhRd3RrVWVNMXVPTU9j?=
 =?utf-8?B?NEtJTkdQYmR5amExaVVwaVI5VTkxZGtVT3JBM2tscTg1ODJnT0xMK3hwQWpu?=
 =?utf-8?B?bEJUVkNsZ1QzdElOUGM3UUhJSjAzSmovd0E0NkJMdERieDAydUYvWE9RcWdj?=
 =?utf-8?B?dTU5eEl3b1REY0hGemNLNHVTTWVHTW1mMFF0WWl4WEdmbmFYVmVzN05qN1NM?=
 =?utf-8?B?WkpwTEVYVjRXMENYRW9QWUFmcldpeDhscWpKVGwrVkp0enRTcVBaZjRvZTF5?=
 =?utf-8?B?NXpzZWNkU0VGNDBQekVNdEFrQzVZZEZGcUUyUit2Y2RhM09VdDVjRnVJMGNL?=
 =?utf-8?B?a21pOHB6aXREZEw3TWExMGw2ZkFjS21ZOFNvZm5UalZQalU1L1JmOHdtT29N?=
 =?utf-8?B?bWlzcWtURllyR2hKbDRpdUJLTnNyRXdXYnBUZjFubGJRd0R0TGxVMGNMYzlL?=
 =?utf-8?B?RWxOT0Q1TExnVGNUNkhkRFBuaXFSdytxVGF0eUpoK2dra21XSGR5dXZ6SXBs?=
 =?utf-8?B?TlVZeXZCd0VjNWlhZWt2QUFjakNWWlhRVUVyL0lHVWpDUWtDN084V01ub0lY?=
 =?utf-8?B?QnhXQjEvd3NJdXNaVjlrbFBPWWlKV1NXSEx6ek9aYXdpQlNkWjdYUmI4NXZh?=
 =?utf-8?B?QWNoNWxGcjlrZWVpY3FIZWZUMzVVWXR6QWRhRVBGczYyMUF3NGRlUUtSRUtB?=
 =?utf-8?B?VDBpaEV2bnU4TWt6VnN5UDhObVV1eXhxN0VsZlg1S3FOQnUvcU5GMk5TeVZN?=
 =?utf-8?B?cVFjVGtnVFdRUUVlZWNQelQ0d0dHb1hxNUJvYW1jcnlQYVRKWGxPT3UxUmsx?=
 =?utf-8?B?aktCTU1IZGpiRzdVUXZaMVZxU3h0NkxpSFVXa0dRYVlwVHorejdHaWVFM0Iz?=
 =?utf-8?B?dVhuZEF4NnBLMTQyVkZZN1M5bkRib2ZBS2gwYnhRMjZobUVhZWJXZDFHclVr?=
 =?utf-8?B?cUl6NjlQQ01XUW9BTlp5Z3VNU2tiRXlCRUdVeFpJRmdJQUpmb1U0aVVkY1Nx?=
 =?utf-8?B?VE5UTTljaDFkbURablgrOTVzSEIra1FoZ3dKWENWV0NnU05ObUt5ZFhkUk9m?=
 =?utf-8?B?dUxlQXdPT3poZC9sN3hIRm1GYnRFUk8rc0k0WlVremd5Ny9ud3pOSUQ3NWgx?=
 =?utf-8?B?aDE2M2hGSUlGcEZQN2lxS2FFMEMyOEgrb0MweEpQL2wwVVhSQmlpRlRNTVcx?=
 =?utf-8?B?bmgxN1Jiei92M1VjUVJ0YWYrZ24vYzh6NGt0SE5SUDJTaHhJNmhUbG9WVHp0?=
 =?utf-8?B?Z01SNTNnaXNncWdCZmtmQjRqdHd3YWhmdzJWa0pWUDE5aFY1Q3prTVRYd1dW?=
 =?utf-8?B?MUVoRnBaMTZORTlEYTN4NWhqS1Q0MCtCKzJkZTRPaTRzdGRtZmNKN2NqcCtT?=
 =?utf-8?B?aTlITStNYzR5L3ExQkgyVVdiT2FXN0FRWlM0V3VsWm43cGpnOTYrQT09?=
X-Exchange-RoutingPolicyChecked:
	q2wlgX3ifl91InR0BbZy9ySwioHu/5LNSYHB+4UBJsj1VvnVi9Nv6ibIIK0J+oMTjVnL2m0puerpGDhdvaAoEJ1WdGcy0hvdh8J6FRyizvbMD+qnyf/9EHyWhanRxyDlZYXwKe4RWjy8yhmbq4jmWfZN37HkJgHrOKEYDGnaEI0/Btrp2SZra+HlGh9NM9j1BDipF74rfNDf1wRyn2ALOYHHj8GYoOKlUX/7dsKK6s/F+cKpPgN/XAGSTZAh0Qy1cMJoQqlCIdkEU26yWaljTzgJ1k2BAkjWkfzYUhUDhTinjunuyTZv8ORjdhxMntZGcxx4ppn2PWS+ihosUMbxbg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qbTKR4VTlbk5gJYzzbF9ggHBl+VK/Qmw0HM48TYSSmVIzVmzfvOy+aIFmDNn05jamjicv1sNl0Zenp5eMcF4qmEykGuJ+Pk0aL3UgNhYIIRvwhbFTdM72KoAh17HbAdYoTSbQU/wcFelgvccsJX7dU3+R6e6ZZDc4q9xNw86m/7aRncMh3TP1c/LrS7ru1l1le2p9izs+DlPPKA1eK51TIYX1HnQNjwwKk5NqpwIUYDYIlsKBKt7anziZf3EWj2Lm1FxkobHCKpN/nnuYQ/dkiMvbksRMIDZAjK3JaEDOMrZy9Lzhj0MShI0TjLEe6jFIwtR/S7BErpsFMW/XEnhFr27LbwvfeoLdltlylubPoNeVKECU2KI+X0DFfSZdmcjGEapuv5FTCaw+3ifUHGSKaBCqdHk5fk4ZFjzz5I5tcDuA2wPvT3bvsDlYmDSsGHWERNx3YEfwEqsIiigSxDsYERsZbXv4Q2YSIj/yO5liYDMAuoPkqhMu3byLdJ3TyFTuXRj1R1eok+CE+c4djaN7vsKSg+4m4v9qsAy2QrmPKH+3X7shDXpvq45vsTkZn7XXOEP/EaeEwQ8P9NrEWYOG++Qh8UxqWultr70Wf2OcjY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b269853a-aae3-4efe-6ea6-08de88e21d8c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 13:43:07.6764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1iJGpGVZ36CzOGoqdys4vFcUiNqlUbOi2t8gjrlSujYK2WerI1vgEabMwuNjR/UOoDDwghsNlmVYrpvk/xFEsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230106
X-Proofpoint-GUID: yrm6vRsjjACud_FuBTW9vgoA0tVD0uiI
X-Authority-Analysis: v=2.4 cv=VKnQXtPX c=1 sm=1 tr=0 ts=69c14389 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=pV8DdWYO6HdUmJoECXIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-ORIG-GUID: yrm6vRsjjACud_FuBTW9vgoA0tVD0uiI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEwNiBTYWx0ZWRfX8aGeVHxL9guB
 Ti0mSSgOVIu71AwVOwFlxL3IpGHKOdjJXF3jPfvBfBu0mV1LyuzTRHFxRk2bOyhrF0AN+yylwwT
 0S/I4r2CvJUHPXiShlOYNYcQMmFC9RoAZygMZnyWGrGxrVeFdt93sr3H60Qqd2L+aTSuMYwabPf
 nZLe6x+vGIVIf6RHkONI4vmr2FnsQukE1x84OQodSrEwOIL4ftpQ5bpuhcTVgnuxl1UCKdFlykC
 8BT4Z8G9QA/zrQ4M2cKRB2OidStgw3joJJOfrW73S5BZp+wMQwPrFGT+uqNl1G4sa+NC5pElOzd
 w5evh+mhdMDicXcC3dauBQ9RfBRgzPWjJcmRasnuSgxxckDQSttU1/GHjMIYjqMpLYWuchYK+9u
 M5dHcn1cWNBwmZUOfDCS0O331LEntKRivALm5V5ws54dSjDjdSSeRTIwz3j9MFbNpxGEJj+feHU
 NxlUwMq82EtGYRcS2dSnoBIkD4wgl5iFucRMhU44=

On 18/03/2026 07:54, Hannes Reinecke wrote:
>>   /*
>>    * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>>    * @sdev: sdev the command should be sent to
> 
> ???
> And this function is useful _why_?
> We're just sending a normal 'TEST UNIT READY', it has nothing to
> do with ALUA. Why do we have a special function here?

This is used in the STPG code, and I added the STPG code to scsi_alua.c

Thanks,
John
