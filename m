Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513432EACEF;
	Mon,  2 Mar 2026 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772471810; cv=fail; b=ZlzOJimtHVRL8bCuAp0RN/0jfIjsrItMNX6j3WhoRQVIstft4LjPF6D1hPwt8tbdT1w9aYFBHd7PNxBnSu+bu8YUuMOB4PQ3KsAL9RsCA6Tv2BhnJpvq4U6rWBKoGNh6elsi60ah3XC7NIgu91l7fgfoTdD3iaZJAZD/PYyMbNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772471810; c=relaxed/simple;
	bh=efwWKR8YNg2Vu5tfmQ8iwQicaOC533ucH6COoj4QxSA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XM2F4XIdraB8nGJAJUVtjIO88pVDDUHF0xaBGJBb9hKzQTxTVOFe4pmWU5EfT9d08oT7cOPvxhQm78c6pO8KsweHOUnwohxekvWYtZAuNiBPXgvHalEbhY4kwMgF4M0TVEOg1Qqw07e7xpsY4v9cm/nFwgoXoTHOFkJzjjhrOz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LhIppWLq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UBI4ADlt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LhIppWLq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UBI4ADlt"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622GM1SY2116414;
	Mon, 2 Mar 2026 17:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Q0HT872WmSoyK8stNKMrVhwbdrQvDO9ci9frJqMsYKA=; b=
	LhIppWLqfIptnh7Iw/w+wbDQ3XM6qeXznLND5KlRxxsiM0gzA6KopWNY4Uqxr5aY
	LoIe5E0Ggy7Y8KUE5S2I/Abt16z1C9L7r9TMrsNm2d46Mav0cT0tk59hlnO/D83+
	3eBNYs1EhMhaN1tf/Fswi3Yh2JbWOyClpKtX+gprwoFz4eqWm4BqTcpev4r8c5BQ
	XfekTK2rjjSjGYbtsTn46rQg6r5qRvaYASmbDDm8iKsb2NzWnDzKf7pnGclpwPdu
	B74Pb5WEj0/MOvjHzyjzJf3ujffw2Y+XAA8NTJgAwjdTaSzyBuHQPFakcJC2unwz
	VDFEoTdo8UpaWnhPXddswQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cne0sr3gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:16:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622GPZg0026740;
	Mon, 2 Mar 2026 17:16:29 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012052.outbound.protection.outlook.com [40.107.209.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8xur3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:16:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CgjhWbDYj9/NgWWeVcLqi3L/ncdFTXt6q69hSglM+tWpnLgfR8d/X0TzwFD2j5SccUqfh9LyRDlOC29uIGXWcnON5c4qhgT4xpYFONZcK9ITtbHXnR+jfUpM6TDumjWjyHwm3a8zy2B+4uS+3dTZCbbH9K1RnSqo3Cttfy+0dtMvuwEF1OXRPlJGlgSPmfTh9r6heWngyT500Og9IB1YnDrBItqOoLReoLJl+AuDza7DmZ4dYYlgAG4BbkagCnReguFYfOYQmsXhqVjeVSBLC/SmwpcGDkHxfyf4IgQFy/6xoMEESC9f9sNGrbiiBwkffqZ7f/0bkrDIo1RrlEj1gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0HT872WmSoyK8stNKMrVhwbdrQvDO9ci9frJqMsYKA=;
 b=GtVMPmvrVyqbegG0OztqFtDrJiJ5XLtfHJHutKVFkrgNEqcErM2nj2849bCYgwWG5BrGQD9tr/UP6l9cJlsqujVJlGdthATgUazoRmDW5wc+P+5S7zEP5/v1xQxi/DfvG72Q69fiq1rnrJvsbQrs34+7Ql7iHtwrIzCeIOcLY5aY36KK5mMgFPrDwq/B5hiSL5+5L0/QolO+6IuTt8sVQvOSjiJuBrtADijvEqrpmOeVEeCea8+txXL6Fx8GGdSjSZMwl33mxCjCjuQptAp3zkgq5QXLKyFRIV7NYgK66Ys4Atp8sivEXeYGR5moXVISVMsx5K4yxmp2p05uaKWiXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0HT872WmSoyK8stNKMrVhwbdrQvDO9ci9frJqMsYKA=;
 b=UBI4ADltKeMlMoK6Iqxm9ChJ55zA3uMUZg3MQ9leEkES2VYKMML4IYr0f1DdATrFEhn7nXOoWL4Qui6hdtx9jiSzWFgUaXu7dnkh7D4sxGFc9UOCLrTAHXd6CwypmjL2h4MkBWLza7KdX0NDqvUZXt8rWhq4bwLa43iAlAvQfCM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA0PR10MB7546.namprd10.prod.outlook.com
 (2603:10b6:208:483::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 17:16:23 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 17:16:23 +0000
Message-ID: <08815f83-7185-4205-ba84-139b27bba13f@oracle.com>
Date: Mon, 2 Mar 2026 17:16:19 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/24] scsi-multipath: clone each bio
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-8-john.g.garry@oracle.com>
 <aaUCR-IoNItKVZCh@redhat.com>
 <bfe3a30f-50c1-4ede-a424-f342b80bfdcf@oracle.com>
 <aaW6Wp9AJV0emVs_@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaW6Wp9AJV0emVs_@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0204.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::24) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA0PR10MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: dd69d17f-4510-46be-09c5-08de787f6dcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	iz/yoW0UfQmNYsR3O/y40gOEEWFJ/KIQmy9sawoJ32E7qwPPgitA5smDU0MgHPhddDzQbMBJ0OQFBcVMdCY4TDQOfkl0sShQgAI2UikAmyCuO3rTxgvRM2vjsYcLhOvUNzpvzRZQyh8dgoaE8wlmr7XTZupVVTbx67WyyuWyoMW+CAuMjWiLqRWxTFd4p0r2rG5NUez14tXKI0lMBEa3RLCBWnl2Go7jZ8Yhn6EKlVFI3IGX01oAIO05I3MwjPS6uqBqXqXy0DHF4Uv8ousiuNoedC57PRfJM0k7mTKsqUDkFZA4iTFL1rcbBaNVU1j8FRxDa5MmZYMZX8HoQ+UhBQBNdveCzEAr3ZFc2vcQt1XEOUJ1kKNKaqgnkXl6NUofMFBIbW8oDYuZgPvrbsAagD+uybdXGwThAxrgZcR8Ch3e7Pm/jHCVucntmiUdP87EjHEhqtnfKTIbhmVZfDzI9JQ3A+vcXjozFjkbvMTsrfWYwtssgRaJWLHhXpz2lKPiUpk8hYVW7P/zfHxPZ3WWnsAMVD7IVneEaJkWe/CvazpkljtcAA/MjoDq6C74n1OfsG2Cetmu8KbE+UKPoy5MJD4WJEWy6vxEWPUKayoWo2a6WYrNxHx9nT6d+mOtGkNoVaDDrMnFSdIt8BCyC5rzWHMhXGEzr1Msat72IQ+d+qBMjfzUMddl5VvCnWjXU7G0yK/5BVvdH13wfgiiCnSgUwnDr0cMVnqgjSac9fn8+LA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1Nlc1IxVXp0c2FNWUNSRHZrcTdwSzlQTHFkMWtQUU9vVFlkNmE0aXNRTGRF?=
 =?utf-8?B?NlJZeEVNWmtobk43Q1RHK0tPL05wenFoRmFQNGRMQUhNYkdJaFVjMk9PR3ll?=
 =?utf-8?B?L2JMQ2Z3T0JLQTFxSERwbnpxUVdDK2VxY0dGYmtKdVZwVURYelRVcEVibkFq?=
 =?utf-8?B?bkw4R2N6eit1MDFjODJsZEtZU3JBWjVpM25ldktRSkdxMDNkSU9Zb2w0cEx4?=
 =?utf-8?B?VzZBaHhPdGRMdjY5KzhXZzNrWGNmZ3Y3c0E5VmZiRTBmNXQ0Z2pxL1o2ZG9B?=
 =?utf-8?B?VGFBeVBiYUovWTVSOEFWeHo5RS8wcmp0dGpodEQ3Z0s1aUxRSWl1ZFhDM1px?=
 =?utf-8?B?OVYxL0ZXQUZaV0ZlZjVPeEtiOUl3aG43ODlMRk0vT3IxbEhsUlR6aE5iQjFv?=
 =?utf-8?B?ZS9FYkhCSklMN01lNGUya2pPT0pwWDZNSTlVQmM3QmpCeDNnSTB6QjRTdnBQ?=
 =?utf-8?B?dWpSVTdjMmhGTkdTclhxNHdoYndxZEw2SGZuZ0o0TVdMb0xwMlFsbXcwVTls?=
 =?utf-8?B?SnoxQ1R2OTlZV1l1cGs4SXRSNGtDWUh2WS90emYzSEwrMzFXNjhIUXRRaTR0?=
 =?utf-8?B?UitQaW5qQzZCRnZEblZzVktTUWxNL0J4MXZXK2l5dU95TDYwZ0xyVTZxejVT?=
 =?utf-8?B?Z3E5Y3dkRkJoVTRHcVFhcE5XV1pMTDB2V0YrL0E4SDFiejVJUGl1djZUSUpR?=
 =?utf-8?B?b3A0VmJ5RHhHc2hqRFF0YW04a3ltLzdvUVpKcjRDUDdBN3JpQWdQMlZoT0tu?=
 =?utf-8?B?N2N3MzRoZDJVSnV1V04wOExyeWM3dUY3Nk9XS01IVlVtaUx1dHFjWVgybEZl?=
 =?utf-8?B?enJmY3pEckx1SWlUaEhCcUh6ZVA0a3EwZjRWWGRhRGpsb3RCMWxuQnFlREtq?=
 =?utf-8?B?RVI3UldqSjFBRi9YZVlOMU91T1Ird2VMeGZWcGhFZC9TK29SZmRTdWdOWGhD?=
 =?utf-8?B?c3Q5eGxGeS92dW52T3lCaVRjOEgyR3FiNXJTRnNnY1BoeDZJQmJNNGpIMERN?=
 =?utf-8?B?NERCYUljZGpzYTZ3QklPWmFTRUx3TnpYYnQ5bXRuc3lJeXBRTXAwYU90ZHZS?=
 =?utf-8?B?Yks2eEUrVEJHMG82d3dpdXNUcGRtNmJmRkZucEw3eHlleDJKaXFVbVl3UUNI?=
 =?utf-8?B?aTBkUU1EK1IvV2Z5eUpFYVdqYUFYME40bFlNRzUrUmVtQUN0cWVVY0ZnbUVw?=
 =?utf-8?B?QUQ3ZHZ4WkQ4ZnBOU0tiY3JvSzk2VldPeE9vclNtQ1Z4Y29LZUE4V3Y0Z2Nv?=
 =?utf-8?B?NkVSUkRDZ2ZlVmZvWGxYeDAyc0w4eGFYRU9mYS8xTDBHVEMza2V6RExSSnZa?=
 =?utf-8?B?Y2pDVXQ2L0VWTGpMeEN6elV3bGxYSGcyeU96YVh5anFZdDVzSTVpL0txRkNZ?=
 =?utf-8?B?S2dja2hPQ3lMUWFtcXErMVJQekorcG81aHN3U2hqS1lmejFLL1pRcnZqazFi?=
 =?utf-8?B?Nk1hWWFiWjhLdTJJR3NyNnE5VEo4MmRWbXlSWjlnNDRjSi9jN24zVWRkMGRX?=
 =?utf-8?B?OWtjeHVYcUhzbC9TSWpJakZlUFNwQTV1dWYwMXV4QVdPQnJJWlpnbWlwWGFm?=
 =?utf-8?B?aU1ZcGFYQU1LNHVFSzJGVjc0RGZKWXpZay9SZzNNc2VaVmQ2Y2VtRXZXSnlO?=
 =?utf-8?B?Z085ejFiaC9jVGVGeE1tQWMzTlp0Q2RhcjhLMFUzMmRwejA5ZlpsSVdjeWg4?=
 =?utf-8?B?U1NIZTJCckZraWdXVEptR3NJVFVBZkJNN2VaVkJTNGpIanpBckJHRjZ3R0dz?=
 =?utf-8?B?cmFmUG51RHVlUGI4akpTVUZyVVFLdCtsMDJJWmlWTFNST0hjcUJ0cGwzUFEw?=
 =?utf-8?B?MXFNMmR5Mzl4b3dKZW9ZMHM3SEZQWXlCbnJ1ajl6VFBzcUt5S1BsaFJLQzg5?=
 =?utf-8?B?QVIyNjdjTmtZakpaWit0V01OektJbSsxNi8rK0Z4eHBERFM1aTJJWUhwWGQ3?=
 =?utf-8?B?bUJkRE9GdVhtM2hObmxJS1dickdwU1ZsUTBjVVVFWnpyN3BRR2MrRmZ6ZTJ4?=
 =?utf-8?B?Y1U2UjFGNWVTcVlXYTFVYlRFT3ExSGxDT0VVUkdmWDBQVzFSSFFTVElOVjE2?=
 =?utf-8?B?UEg2Qk9aVHlDdDdCemluZlpQc0tEeVZCNW0xaURtaGZyNmVQVXNoN3VQZitT?=
 =?utf-8?B?ZVBEbGQzR29OM3Bta2lLdHF4U2pTaURjbDhYRHlJTDZmSkh3M3NWYzlSYU44?=
 =?utf-8?B?dnc3SlpCZ2d5Z2FWSjUzdkhJTzlQOUExQWRVbDZ3MGpScWhzMTRnbUpvU21J?=
 =?utf-8?B?dmJyWjBYdmI3ZXBiN0xoRDV0VTFreEw1K2JUKzBIUHR1S3hvMUtXUTZPMFJq?=
 =?utf-8?B?VUlLNjI4d3VMNVhCb2NSandLTlROeUtGRDdja0NBM0pwVHRraE80cGUveGYy?=
 =?utf-8?Q?Q7R6kF10vUmU14+8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/kzBZvYgJ5y5CmThQmKpXmoY2PDtjHxqy1s0UUOYa2qjB0zoIrQfgQjxcyN4A54CzwOuhUmDR3W+tSmJtIFGT8rmER4w8Iq7vG3lvFmAQnAIY5yGy7pDecPe2FMm4bh8isEfUKP6ug4TtNS4pjv6/Qk/eHwKLHdX7Ppf+Sep2WVe40wT4uWVcEA1uNgNIHFGFKRRvXDIO36QmrDRzAWSa+jUrWBjyyf6+7LhWr5/dA35TG6pnWY6FIcgOz+bVwIdqArM+j/O+jhQYBSMV3TcfUlcIe80n5oxhx62aAd6lLq6ofNO5SqtO7leDoQWjnY9Qj+Bw6I5zEx3J29ovVgqFRBRetZQWUXScE02tL/f+oO+vhrVYZLawMJp67bmAm/FH1YY5tNgKJ+J/zsAIlGveF6+3HJZ1gvg0W0XaMPRoLjtXYIukbrY9D6WCCaQi3R37KKYLU4mJd3ud0i9g4FjINs/Ti9rD4Z6eLDgeVbhPN4uTdFY/8IHIfHmgj5Qos2FPmgrA87FGjpPiNzhhzQwGQjzSg2LiRNNPxWTzNyWvZNL54JwNs6JMVoZaYs5NPBIpnm5IlrXHu131c5z4ytzhDIgbxNP0V/tsyDKtrtErMs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd69d17f-4510-46be-09c5-08de787f6dcd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:16:23.4308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHZ6L5QlNS0lvq+Ztg5o8LI/TVTO62qtTulV+K/HzPprsmceDLRCZK049V3KECnI+ZERSGVoAE3/3Gq/ku3udA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=922 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE0MSBTYWx0ZWRfX7gy4Cdtkd17g
 SSafePryQqAyk6znW2E7HPEKl3kNYi6XuYSTnOUEWg2xj2Sb2g1kQkzFKqRz9YF3geJwFus0FdJ
 wXYCii+r/avcAwYU9fI8wV3vE/iz8HyJcG6w4wMdiDUyqX22yzy88i5X1obFyJKG4PrML7eCRrG
 peF55U7YpDehnQKnpKABZuI5v8kjEG4E5nHrhJ0jNYi6BhTNWaZCklqJS4I4DASCQLuDIMNF8Do
 kAfiQRHtYlZkP9Ub6Mxwb4ophpiwgfpy/Y7g1aZXV+0SkJkbBaS0dCmC45DYp6Z8+ZMeTkAhRFQ
 XZ5sX17DeZDXzQdSQEvbCp6/mDM+Ftyp8EVitvQZwtwnEdtI9ajkyeHKX/9UQwHQzAOdCqDkOb2
 it9rrf7NjKt3H7DteHpyhoAQm1yXjtzyd7X2bpC4d2HieWXucfBlocH5X+Fyu/ZxeH7ZJou/0Ke
 qesO3gAOry/x3zx4Ltg==
X-Authority-Analysis: v=2.4 cv=ObuVzxTY c=1 sm=1 tr=0 ts=69a5c5ee cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=UXUjngeYCGWrpwhZi5UA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Qur8wN2nmt_OyZhZ3ci3HOjdEYg8DGFQ
X-Proofpoint-GUID: Qur8wN2nmt_OyZhZ3ci3HOjdEYg8DGFQ

On 02/03/2026 16:27, Benjamin Marzinski wrote:
>> Every bio which we are sent is cloned. And SCSI_MAX_QUEUE_DEPTH is used as
>> the cached bio size - wouldn't it make sense to cache more than 2 bios?
> IIRC, the reserved pool is there to guarantee forward progress under
> memory pressure, so that if the system is short on memory, and it needs
> to write out data to this multipath device in order to free up memory,
> it there will be enough resources to do that.
> 
> Under normal conditions, your new bios should be getting pulled from the
> per-cpu cache anyways, since you set BIOSET_PERCPU_CACHE. That's going
> to be the fastest way to get one.

ok, got it

Thanks
