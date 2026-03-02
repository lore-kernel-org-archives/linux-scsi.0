Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4728B36C9C5;
	Mon,  2 Mar 2026 12:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454148; cv=fail; b=qiVwirA1F4r3X3wKYBKyBC3U0LRMpVr1rrBOL2QotIKOiFrag0q53Xl9bgsW/Bv+zxnbTyB6NyxHkFedbNL5tMxtAtoJ4AXnzm6gf45jeNughTKwor5hwOTN2t/tuHbaIraRVSjOuasg1eRlkJSRL+EnfobBbTB9xdluM951ukg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454148; c=relaxed/simple;
	bh=8vzq5smkoGPq1JGfBBO3n3/+IE+u3KbAf7YZU5ixXa8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nji9HfTAEYbkPbnToY+9K8baUraUrgZICRoiEPYBPmksSrcvP+oOJNzRaItG0ATgLoEboVLLzs3lCBJ5siUFKWBuC/dwjRZvIX1PsvC2cvtdF2L1tzxO3BCYKY56hnvVP8ZS4hBcIkIMhmA2R0Q5MhBVp3OQ3KyKXm+4Ku2Kuoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ghkh4KfF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c2fBnLre; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ghkh4KfF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c2fBnLre"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622CJAaH1693361;
	Mon, 2 Mar 2026 12:22:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bh9r5+J39+cjB+lTDD0z9qccvWJuP/dRViNf8cZxUz8=; b=
	ghkh4KfF/qC4r9CMxNxbcfnmz0XOc07pg+fUG/EOJrNjTa1gmutgiUUTWGX18opQ
	+lVXGjvpG/8K4l11QZzBL/5ZicHvdP/4aXgSZGAL4pIgl30mZt8VilDyrRZWbSRz
	wbKnP8hgaxSRGkjHksVsEJ2JwfGwbMCRcpH/ZZQkhtNCbGwyzi40jWCdMc+E/xUh
	5MG3BHTgnhD8SMB23rpqyz2fexPUppJMxlRqzc3aidbZQQ4PzxwnK0hI+8gAeyC0
	hB5h3PjhVi4z37sxtGF9I1p+CLWr8oL+Q1H8iXQzTTh8E34u+itAxeBmlkuNliFe
	mzu6Y8vWyT81XRdVwTlSoA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnaeu806a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:22:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622C4t54029955;
	Mon, 2 Mar 2026 12:22:07 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8vm4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:22:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lmm2E49WuDGDVBZBYnZmOC1tcIkPZ64CAg4F83lU50GXcBKixDZBvLuu5bflzISSSRF9ZrnGhow8b8ejAZQ1S2mhCneMGnfnMAb91t+j5SY2ho4NtPX/p2Nj4UMmVOBB3zBxgKqDJo8Ve5wCiv7+1Dr73DU+Tbo9mhHGs21awpea6WTh2X/2HOjw0UMc9q/HXKHT/Wh+kYFvk1rFPPWn7+AlBQnDXKedk1Pp5HWd+Lbo+s7LMVi1wG3g8WM64fWS7Olumhjm7OY01ZYM4Ff+iGudFAZ2WQXKdrFOQ7IqoCC3nVLHw/iv/Rl45Iu1QUpB0pNqqHLP1E83XPwgzo4TZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bh9r5+J39+cjB+lTDD0z9qccvWJuP/dRViNf8cZxUz8=;
 b=A4ISbkKQpTwJWjvVKnlNe8DhzqZ3Of9LHftMyJC8SGYFUV+EgWKN7Sc/carM1zanTlwgCnikBGGhkSnQuY63xYy4LBqT4MTanTe27Zb1YAGvmNjplMm8+xkFbdbc4yoR5JjDgVUjqFwMz9iv3f3JwuUFw+ciJlHbDCb4ra5yPOlU/ChM/Ts+ywcpz77FoYL3wevrxW32axcjsjEG756IJPmlPTCkjrWmdctcQawb+bFP9TjIL7nrhCJ/5mB/WtPi1g0CfJqtmJfQW1HRv6hLU/nYHILn4d3RQW2KqGlhM+JAv2DMxJAsWH/+p8gOch/YA42ncBhjtYuj25t3HuY+dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bh9r5+J39+cjB+lTDD0z9qccvWJuP/dRViNf8cZxUz8=;
 b=c2fBnLreWK/dhbTHqp6w4oCJFbOwigoxM41Mq+4iuEl2pe1n/dsku4wJAkxtWdxtltpBi7SEWcBSNB+5aSAWhvGDP+mW9ioX9bCtP6bawt3Cdtt7ofcVf0nkpkaOK/hQJsmmZ/jNqMFiVP+DlloddtRCun+Q+Ptx/rMboPUDLIM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5035.namprd10.prod.outlook.com
 (2603:10b6:610:c2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 12:21:59 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 12:21:59 +0000
Message-ID: <d54922cf-c3ec-4f82-900a-c35b05cf1c18@oracle.com>
Date: Mon, 2 Mar 2026 12:21:54 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] libmultipath: Add initial framework
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-2-john.g.garry@oracle.com>
 <fec9dcff-b824-47e2-a5fa-bbc493d62b0a@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <fec9dcff-b824-47e2-a5fa-bbc493d62b0a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0490.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: 688cd1d9-fea1-470b-ce09-08de78564d4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	vHuPbVXRKzueBjp9NM+0zwkJ4yUCKtguaHG3cPJcdF1zPmklxXte/acarJPyh6ldk2MV81/2gL5c33F54HQBN9/vIdLFMsmurk2r1OvPI3XA4sz6LJABaIAJWjLUCPKotJGAVX1HW4aKEnemqtqGN294Sy//jWb1FzC2ovJ9vf8JbOzP9hmZGsyKy4/L0l1W5PBKhvObfbJICZh0uUgqAADHXPkduWiZ9EKEx87yZo4AOJnKFOoEQY34w0Yir1xDxK36CSyY+luf1sITOD+LVQkwzs0FhbEM1qfv5nTM4nZKhSl4iC+SUGAMQcsgZHL5Xmv5apOzbHuUCRdFrNVgzSq+GjdIUGbkjrEgMyUg1TRil0OAxTON5NfS/2HVQfLAABO4lTYsc5+1oErlX57GnMI+FNxdfti+H6AiXfxns8WzQKuwzTxLgw+wsswUrSdRfpALBolbpKDiMkAgUqEp7wYHZ68IQe8lfQVYDEQBOedKghmjf9fW8mUhoCX+ZTyd5jWVLoIy2l7uymrPbUBPai7oa9OXfzK+npyh4rBHBBBV24McRjMs/4YZ9tKBeA64txaN+tqHvi0VLxF1JO4AOv3t5KR9sNPllwJVObyNtncZuImnM/YGdPNuceAd3lKl4OTi5zvR8R0QCaTzAV4kiQD7hUn+j9Q76W4DdtrbZjakFwtbGTXhCfj55DFyf8VMQZvuBT33j2LeA1RsplpxFUTWAMzGgWXDa3jiHsOLoH0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bURsWVR5OGdyRXZETnoxWmxSUWVqRm9pOXhXdU9PVXBUR3VLRGdCV1dERDBo?=
 =?utf-8?B?UERWaXpiWlBQVVZzWUUvN0VndVZCQTVVVG1LSkZuWTAvK2N3V1RzRTMvREtB?=
 =?utf-8?B?M1pxK1kzUWFnQUVDSkd5VTVxN3lLT0hBVWw4NlFkRVVDT084SEt6TjFpdlVO?=
 =?utf-8?B?WVk1eU9jQmNnWlRZcUhkWVF5NUlyOElrbGU0d0dOby9EYzJIMHkwUisrbDlF?=
 =?utf-8?B?NFoydWVGdU9xdzNSa3BuOExmVFVGQjJ6c0o2NkpNZU5JZ2s4cXNwK0VsRXdx?=
 =?utf-8?B?KzRGTlFqZGVYam5Ocm5aTEFoVnRuaUVoY25JTHRJL0NPdmg3WldIRVVyeHRq?=
 =?utf-8?B?MUlkbHZtUlFHY2dRN3Vibm9HRHp6bGhOVTZiUlpEeVNHenRrWVFwRWFLN2Jq?=
 =?utf-8?B?cS9OUW55eHBZSDF1WXM3d2ZPMFBXaEVqZkZpbUtBeExIS1lqK1dXNnpXV0ww?=
 =?utf-8?B?T1VKV2tXVjA4MzV1S1dhMFp6VC8wVGdxY0hWV3BEekNFenlBTmJiQ20zd1dZ?=
 =?utf-8?B?dWk2emR4NVhKOE1CbU5UbUtHZkMyeVlaT05lNjZCckVNVDJEOGllZ3RTbDE1?=
 =?utf-8?B?aWFCN05QMFVjWE96V3dlNlFITnZVUGt2eXJlM0p6R1BSZHVSUEN6b0VsbUtV?=
 =?utf-8?B?cTUrbzIzVHdOdU9Ec25RQ2k3bG1VaUpXay9zUkZWNFVnTjRJU3RHclhmYW5P?=
 =?utf-8?B?cmh0VzZyK1RibnFUR2pnczIzUGJuUjQwZUxkeU5HRWZtdFZnTkRKN2wvM25U?=
 =?utf-8?B?bloyL2JoME9VMUdWeVlFTU15ejIvS0hGOXRESW9WM2o4RmE3VU9CNWFyZytu?=
 =?utf-8?B?RG4xVnRCRk1VQ1ZDUWlmeExqWE9wYnpaUTRkSXdmaEFGZUNTN3FseVRiVlZE?=
 =?utf-8?B?ckVNcTVveW5XRS9FNVZUcmdsMnVFWXJ3NkVFSEQrWWloZlNoQnc1OENsRGJH?=
 =?utf-8?B?MXV6YmN0M3dOSnpmSWxBV0JzVDEybnlBcVpIRzlpWWZtMXJ5c1NDdGgwSDA2?=
 =?utf-8?B?UmJJb29CN3dQcjhPODREbDJjTmR3cWpoWUJtUFcrR3h0NE9RVEFyd1NqM04x?=
 =?utf-8?B?cHdpblBhOWNxYUxWL1VKWlZrWUJXNVlWdVdjamxrL1J0WkI1K2NnYUZ5MklH?=
 =?utf-8?B?U0piUHBkTGxOTDRkOWxvVDY3VG1SUS9BcFI0MGlncnFra1draURyVDQ4eE1C?=
 =?utf-8?B?ZElwQmI0MGgwWm5wVVRqcU9tam1IblVUTzVtKzQ5UEdXb29OQ1NzM2FJWmZT?=
 =?utf-8?B?ZC9DSlF5ZVBOQ1FlbFJTNEZpSStaMHpES2ZUdWpNVHAwMmJmWWliUVB2RGN6?=
 =?utf-8?B?MmVzb08wRSt5WGJtWEljK2t0L2tPY1kyQzhMMjJLRVgwQjR5SmVhbC91VXJF?=
 =?utf-8?B?WGxWckx1RXkxd0N2RnQ2MHp4bHVDdFpQVTV4QWRwMGtiR3VvM1FlRHFkcVNv?=
 =?utf-8?B?L2ZPOU9uMWlmTWZsVWlMODVWZDNjTStnbENwMDlCam1DbXFhOXptelAyTVc0?=
 =?utf-8?B?ckY0L1YxQ2FWRlpmbmJKalE0czJkckc1Y0wxQVN6Q0pqNTVRMm0rOFNCQW9B?=
 =?utf-8?B?VEsyNy9rbVhGZHg2eldrUlNlalRSR0Jta2c2MFoxZ3NWck9lQWIranQ0dkJt?=
 =?utf-8?B?SzdLTnVLOGxyZ2tIVFVQZTlBZEFTWTBpcUh2QVNYOG1WeDhQdzJwdGxjZ0JZ?=
 =?utf-8?B?Z1BvRWl5UkxBK083K3hPR0tLNm13OTU4Q1BtRHRkNnRuRnUvZXFFdUZtYm5n?=
 =?utf-8?B?V1JSbm1CZ3J3cWZRSG5IL1RLQkhPUVBxKzdzTTV0SVBURVM4V1cwY1RiK1hQ?=
 =?utf-8?B?UjhMWVdXdzFGTmJ3cUNoa1RmUDFIN0Y4ZU1mbTVxMmFjanZPUG1nYXRCaSs4?=
 =?utf-8?B?K0l4eXNZNUxCVVlQTFM5eFQrWnc5OWFWV0RJakxrUDdIdHU5bFE4V1lnZWpY?=
 =?utf-8?B?QUF3WGRQOXkxSm93cTNVbzdJTEtRODhjR3U4VTdMTmd0TmRPVm1VYnBTQTRy?=
 =?utf-8?B?MkdSQkVsRW03TzUxMHkxYklyVm9XTUNRUW1FRmN3NklySm1CdnpoVFFhNnhI?=
 =?utf-8?B?elhLRlY3QldHVUVMV1A0MGZQcDNqekE4V3hkQitJSEdnTFFYNUl3Uzc0WU0z?=
 =?utf-8?B?a3lINUtQb3hHQksyMmVtRm5GT241NWlZYkFLOGZPVVBIM2dlcE5jMmNOQ3NL?=
 =?utf-8?B?bHZSS0krTzBURXFjUVArcmtSN2JNOForOFdHQThTRS9mQ3Y4ejVWK0pPbDFZ?=
 =?utf-8?B?b2RwREZrdE85SW9FTHZmZCtRTmV5UFJNZ2VwMExQUmNROTd4TEc5N0gwenNT?=
 =?utf-8?B?d3ZwNWtDdGZyZDVRYzBybDZMVkcwRWVRTHlrQWU1WTQ0ZjQ4TnFBclJKbHNp?=
 =?utf-8?Q?U3QORpvFFycioIYU=3D?=
X-Exchange-RoutingPolicyChecked:
	Pm1UHrLNiy9ob2nKiCCHrfpkKTtVgagb3VY6ghXPomrCOOsB8jD6fHO+/GXlNs032gEtHm1ffw3uuV635gqvhfDszHK9tfMtfz9IJhYdzCsg/9+QaJ/td9Vp/cnbBeJoCEhnd7N7MkvOwAuVZK0Vs7gLtOEeRtG5iKJS+wsowx9xLIig2ycMFn5XoyznVM0ylvAmQXoYd/d/yyyB8p0hY++hTwNNh9nc4VDhNwIvEg7R9tg91SDZ6gQ8weLfAcReGHWghC9Xo3J4yD/HKwoIV8UWoJaiVxBA5yDGyQFNMD2dc2ynmV5z+GjjlzV5qD5udvzQu7ni46lz42v6wz6ycw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ovPOTWSDPqdCqzebb3hSYPKyzK5LHsANV18pK3Q5iLLmnpiX+Yy9RxiZkZixo+PKhBEzmuqjgR5XneygSHm7w7Rvu2ExqRrSjJ07R1lp/2sqpS+YAh4ogfQcZbckhtfKX4t0DBqU5R2/s7E7V/UQinlbqCVmU/uNiFL0Rif9Tv32Nq6kdeX0y66MAgGwUhiwkHaWnxp/r1kg1I5fkwCd0PAlYpcdJh9K6gUA66MhLaOizJEbd1lhjASH4zZCWx3u/3hmx/shByAuxKUqq59OpHZNRRSonx7llDZODhomx6YO4qNrLHSUiUMO2mplRlx0DNoNRr+0D15mnLfr/iccu/8WQepK8D2aZrzKRybmpKO+EwdnhG9spUmEDFOFMHJt5UAFbECLtUm78xx7jjmT6Fm8hX7I6qPB56Xrk9C3z2JcOErhcr4+TRnWNZbaNrgZ9n1SZxdlIkbEIdlKh1PPZnvNxQ/WO8tHxqVAyq9VUZJeKDAsU1QNoTNjGLAo6OVLFADVhY7+3F1cPXVNxVuRcPA6XVbPMvfMaB33dPTSigrHIDzoG01Jaba196UgLC524fWEo1K1/to/pZ1jGwrNMCzQgQlBB+ZUNLnEDAVoHpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688cd1d9-fea1-470b-ce09-08de78564d4f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:21:59.4973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jY4B4RXUeMhi+gVKt3dYAtFxs8r9Syk1c6SeXChL20RVHT8szUusIsWgIZfW40DxrWyfichVhVfn/XGhutdf2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5035
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020103
X-Authority-Analysis: v=2.4 cv=UJrQ3Sfy c=1 sm=1 tr=0 ts=69a580f0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=K3cOYKMlDh4z-Iw_9fcA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: P5QP3SkutdDTJsbR1N05yCCxk3RPSnlP
X-Proofpoint-GUID: P5QP3SkutdDTJsbR1N05yCCxk3RPSnlP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMiBTYWx0ZWRfX8XvCrPF8pXAl
 JHd5XdAV7IGoYRrksnOtj7OVKXzDIIbKkhYzALjn8peJ94R0DagIVcHmXKMzednD02sUH0B+H/k
 Ejogi/706GOHr/4WyGzv5lQtFL4KdVUHpT+RC+OaZrxxjNY84UA630/Fe681lNFGYUHEZdo+rGc
 5Umx7tgUMPrGMopMX26vy0Yxce1BLtwbUnfPuyLyYr2BIwwRsmMpPppIIVTwBbHpSyStSmF4KM8
 SfZWd0JDrLKUtwEa6y3IQZpY61x5HnvHDHwWmEdsW3Pm1A5yfTVVwNNikHCma/9L95iI51XKUJG
 qlkSX2AURWaslYH6Da5AE4kQ02mbJ0ZwxozBAXfuDVo/4FfPLeeD+d8sVxtzJJ1ioJnslOqYEnx
 ZcDW5U1SUJsWS61keoGvkeAR+3dmv2vkwLWf00ZgiKfjLvlE3pmjXvlLKTjyDHuJpFqn2WMSk9Y
 Q/HD2hyf912PvfqELNw==

On 02/03/2026 12:08, Nilay Shroff wrote:
>> +struct mpath_head {
>> +    struct srcu_struct    srcu;
>> +    struct list_head    dev_list;    /* list of all mpath_devs */
>> +    struct mutex        lock;
>> +
>> +    struct kref        ref;
>> +
>> +    struct mpath_device __rcu         *current_path[MAX_NUMNODES];
>> +    void            *drvdata;
>> +};
> 
> Can we use current_path[] as last element and flex array (same as what
> we have today under struct nvme_ns_head) so that we don't need to 
> allocate array as big as MAX_NUMANODES? With flex array we can use 
> num_possible_nodes() which may be much smaller than MAX_NUMANODES.


Sure, I don't see a problem with that. I think that using MAX_NUMNODES 
was a leftover from an earlier dev approach.

Thanks!
