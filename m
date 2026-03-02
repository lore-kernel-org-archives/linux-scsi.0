Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3574014A7;
	Mon,  2 Mar 2026 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772468049; cv=fail; b=lkTDkXh2jUX0mvH8asj3fAYKBurbEc9IrvoSO61/92uXzxqMAdpT+aYKyi6FHR4cjnQvVhyL6L3g/FUTi/X0PkxkUo1YuGpN1Iz217iJp+1+LFXbRJDcCWegxF5zkPGVz32zTvaK/tfiyeNM6FXNOVZ6LepZDGADvW0HmO28KDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772468049; c=relaxed/simple;
	bh=AhZd0+S8V9KgrAk7m2SsQRME8RRiM32cxY8go0Jfg/4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sLdHd4jOt19lXwiL9YNWBTCi+KuuLTqTVr7Rhx2fTPwipB6dt1rrt9iCPHmFoYAXjVPl9y69ofhi3MRz5icbLB9Ua4DAAavtyZsCMiBweFgyY7C64R9uRSynh2c1p2tY4cc05RqWZPia3J9Dd3sQvk9UZO9ourhJE6PwiMcLxwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rPjX6mEx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yIyjY7ZD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rPjX6mEx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yIyjY7ZD"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622FK2aI2493544;
	Mon, 2 Mar 2026 16:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ebwl92EYAsNUQD4D4CcTTHiHEoJRFVf8hmjCQpBCGgE=; b=
	rPjX6mExjEqjUpPnuZntzuejyBugPN0Ih6oAtOjGJhSZCwMo7q3jvlhWKy4PZ+xb
	aXqxd2PXTacLoh032RQnEsDeer05vUAz81BmAPIfPDoBygdq8JyDZxC2BZ5x0biK
	mUJj1Wqc9E5x3dxKK0kOoYW3bLait+RYdVCaGSPXMLzhNtQOMtVACFRhcMrJ3mQX
	EhAeCxrWblWlwXkJa8ecHkr3TlPmcDta1VGsGxVdd6TuAnmiZ20602B7rCzHXEVc
	z3jb35/+t1aqgXOFDX8q8y3U5tZ0GrERkuRrP2hfZPzr6+bn47j/MindS8a31dcq
	JxFdQSxjDJy2jUqlsvohtw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnd3r03fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 16:13:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622EV5ZF027494;
	Mon, 2 Mar 2026 16:13:38 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012006.outbound.protection.outlook.com [52.101.43.6])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8vem9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 16:13:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B3f8ZtUmfIlWOcDh9DwBnc4om/nJ4+latfgWy5E01C+i8wZdBeTvcrtwzgjAjCti3+g1CwM7ZlVulMRlL75BcvVaun7lw9KBfNjiPo/nhU9y6sFOpVfewssvV0xswBg+uFloFQK9JjWm9YJrsWo02sAZMvyKE+KtsCQ2/T4vfyp0oCy/OOEnkGaYyA8gJKaMv1QlGtXJbFE67tgg/1aTBosdWCwtN4AhW8pADXpFEp/7kDYoKjdetWX0u4pYlv5y5JNzfOJoHz64CCdE9wetAZ4em157ZY1SnqIXg+NA8lfVb/h0srsGrsxNIxqGskJV+NB/Y8hGK7Tc3eh2PHjHWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ebwl92EYAsNUQD4D4CcTTHiHEoJRFVf8hmjCQpBCGgE=;
 b=xRfV4SpMHiXvuUlpoIihSeZT/U9GLOjyKffpIX26nlTqJAgApYzjyn+6wXszbMJmdyMfYp5gP19cIDs6pSlFQyKGuiVtOkNKS6OnGCGlvVh5ujQR6wjBzrU1OM4i7ScNRzZ9bJro4RM3hi1PajEpTi3xIF8cNgnTZrOia/fTRMiFWLkzOF8F7I+sh7NxpscoNyYl48P5ddolTtZmgWb3XAGahrgrinYWWv9ocod1cvRXeinvH+CEoAgDrmtMLA7GdYDmD6is0SpczxHwiGKcx86bW3hcdXZLxkC5WxVmoYpKw6Hz5ptdRtlKrkCdksriQ/ynqSvBgn8QvDSzgIZpJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ebwl92EYAsNUQD4D4CcTTHiHEoJRFVf8hmjCQpBCGgE=;
 b=yIyjY7ZD3Q6ujpM3SGh4wlAhZJGneHfv39VuXyxflO1VX8O+i/jZNvoTEpm50L0Eu5m09Dyh4GOuj/0IZeAOJZjtXsNuYMjx41JAgbUTx05B3NhMcvPkUAMEapNz5BOTTMXdvhIN0uzWjGEHJIpcxujV2Qo2PcP2xakh0KOAWcc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH3PR10MB7356.namprd10.prod.outlook.com
 (2603:10b6:610:130::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 16:13:32 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 16:13:32 +0000
Message-ID: <7ee95e93-51c0-4cca-ad21-6588900e8208@oracle.com>
Date: Mon, 2 Mar 2026 16:13:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/19] nvme-multipath: switch to use libmultipath
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
 <20260225154007.1033735-20-john.g.garry@oracle.com>
 <bfc2bfa4-a28d-47dc-9362-b9ff6680cfab@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <bfc2bfa4-a28d-47dc-9362-b9ff6680cfab@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX1P273CA0003.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:21::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH3PR10MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: 18f31348-7ffd-4e6c-777d-08de7876a5f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	9FWGJ2q7m3HH/DWdbBDwyBORdiJ4TuIUy+zcQ2RDg6b5GojUMvi0RsYCe4nKBnUbK+6XA2Xe5WwHsY6N8qtbyE3rzwqGnqSHzHZo4wZllAiJLt92ECCu04dwV3f9bUfwURhFzPZHjPuo+SGUWbc130gzg4JfkjgYoiPg+GooLAFQxYZY/AqS8bO5BQUZIXxsIaAVVbSHKeXQXM0lnOBCH9CQozRr99hpwBcaPix641U0PYdsY+t1+zz59AeYUDEovGlR40NTf9knLJxhRoiBggEFVXdOgG4Ux1h9X/V3ETjYBeU1rHeE7wrWEQDBGDyHbCAhCT+VJWpcnD6ppInT8xfJgniPvjgBJzoYLP519QQvbOIOj5mg0G55IYJTKVIT5oaBE1pibwrAtbiR2MI2LPqcFqvXHwKnpKWJVluc+GkwUBbQHBD/3opC03SH1rVU68pU+1PMHI1/uOGgvNsG+lfxwLzmuz594xTMMeM2hvhLP9OpwSGp8P2Ltprm8xz2+M2WhoSNLoLuK6DNq7au4EmHHtyTnOZllymdeOVGHOYD/xQ1OM1zWcMUhkpo5Y9UqfJQf4Fms/1qzZjfD4BEu6GD19Vpbwdqb8Mi+oKphu197KiR1VgrscPwBDkKiV3BLiZcvaX0XaFFVsHNWbs+s/z8C96Ny6D91+RdLJ/UDl4X2qjYHh+c5liikMMYbp4P4T/MCc0uWUK/FvzC1cSvLNEj/34LkZ0wQYjsrA4U+UU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVBqVWJtMXlaUVM4c21oUGt0OThxYlBSQzJrZlNWMGN2SytYN21vSmFybnRI?=
 =?utf-8?B?VTNxYitUYmpKWGorNlV4VWRMaDlhMkRVWlQycUdMUkl4cjkvV0lKZ1RLM1NX?=
 =?utf-8?B?WTQ1TVkwSjlXSEd2MzRuZnYyVGw5amtRWDltdnBZREtCVnBoR0tMYkV4VE5G?=
 =?utf-8?B?SHkra1NpeWk5VFhINy80cWd5VzVmdnVTa1BJYTNtU1MzOUE4bHRXalNLYnZs?=
 =?utf-8?B?czY3akM3Y1JmOXI5ZDZpczBraDFRdG1YSko3Rnh3L1NQcHBUMFliTzNBZ25n?=
 =?utf-8?B?alI2SlZSSFkrRzFLemk1aDJBaFVGVnI1c3hBTFhqK1JSV2RRRi95T3FVVWg5?=
 =?utf-8?B?TExhVFdxSjk4N2JESmRlV3h2NDZ1MGxnTFd4MzZ3Q2dGdmdCa2FNaHZqR0hn?=
 =?utf-8?B?aGRqSFo1cVpTKyt5UStEa0JHWlpjdWx3a2hab3NPY2xYS2dIZzN2dmtOZHhn?=
 =?utf-8?B?bTJvbHdzYm9HaFI1K2dsL2hvR1dCSk9vRFhKRkNCamJnc1llN2hCUUhnWmkw?=
 =?utf-8?B?dTlYVmJDSTlSc1B2blM3L0ZsMFFjeVBYbWczT21rb3NkcithbjNGSTV6TmhS?=
 =?utf-8?B?eGZSYUlxbXpzY3ZjZ0NMOFVhYlY5Ny9xZmdjaDBVd3VGcFFJRk5rTGcxOEEv?=
 =?utf-8?B?Y1UwbWFvWWc3U0hTb09oMWdVQWM4QVIrTG9OWTB3S1JnM2Z2ZjcwOE1LQ1Q5?=
 =?utf-8?B?Y2ZCY2ZEVkxWVTA5bWZBZHh2dEZoSHA3WFhLcmgxaFp3ZGZnbmRraXlvSE9w?=
 =?utf-8?B?bUNjVFRMdTM5V0JlZ1QveDVvUkQwVkhPUXhlQStGRFMwNWt3bTFFdE5HNVNu?=
 =?utf-8?B?SXNCT0p3TDRQNTVZQjRsK3ZlMk5GT1lqUkw2bFMyMkJXZ1Q3UVM5R2N1d0w3?=
 =?utf-8?B?N2pnYnpSRVlSN2x3WlRlRWNkeEw3L3lybU5XNWdIS3JkY3BNS1BFMGlyK2NU?=
 =?utf-8?B?WkpZcmFUZDNIMWpFMFRvbGZiM0FGenNJSHgwYlNKVEJXcHVvc0FKVTZMSXFi?=
 =?utf-8?B?VG5HMDBQNHRPK1FGdmcvenVZbXF6U1g4a0hYL2IyNUd5SFllbDRwRVN5eUww?=
 =?utf-8?B?U01YQU8vZlVWOUZkVElkWG1HYzAweFp4S0JNWjlUcUg0YVV4Ykg2YThKdTND?=
 =?utf-8?B?VWVoSWpvYVgzeVE5ZTFPWldMWXJoSWxUVHRNZTU0SVNsOURHYkpHaEE2azVI?=
 =?utf-8?B?elZiUFFIR3lHR3N5L245M2MxVXFVNkhOaXIwMDA3S2JPNGJxSUl1cUNmVFAy?=
 =?utf-8?B?N2pkN2hJVTdZUlhVQXh5RzJPY3BWNnV4N1JkTmxScC9ISmxDZy95dEU1Tmdk?=
 =?utf-8?B?WXk1RDFSUXplQkxkOWZEM0JDYXI5M0w4M0IxWVVGdWRKc3Fkb1lGY1NJR3Vs?=
 =?utf-8?B?S285NTAvcHZpZWtyQ1RIaTJWeU1QZmpJK0htWktqNEpuOVFudzJDZm9IV2pF?=
 =?utf-8?B?TEczeDIxVFd1RHBwZjhzY2FpME1wRmJjMGFLbHQ0b3c2TG1aeGVSUCszR095?=
 =?utf-8?B?N2NhWjdyMGZVc0s4dlFVck5TbUlqK04yMEQ2WkZhNmdmRHBkaE1HSzg5QnZm?=
 =?utf-8?B?TGZjQ3E3Y1V6R1N1ZzFCbVJUUjEyZ2JRKy9CZWtzRy9TOVpIMUVJY1A4ZWZz?=
 =?utf-8?B?aWlDa0puVUdBcXZaUXpWQkpwaHB2Z2kxREtNenE3WGY1N0JWeVErM0xrbVUz?=
 =?utf-8?B?YXFlUE50VHhTNXNyRjRZL2JOMktraVZORXF6RmdISk8wS0dSdG1ack5PcjZX?=
 =?utf-8?B?UHN2Q0xsdDRzQ2prWGtXRlYxdi84T0xHLzBjOWd2Y2lSaHNKcEhrS2xBNFJK?=
 =?utf-8?B?VjcyNjRFVHUxandSU2lzajJuUUFZUFVMbkFQWlNPcU55ZlhpZTdUays2ODhM?=
 =?utf-8?B?WWlNKzlvTWt5L1hTMHd3V1ZGVlNaZUdiRENMcmUvUnFYL25LeU00dWRrdDVr?=
 =?utf-8?B?WDRpQVhsVGlJVC9OL0hzMWZoSkQ0NEFtMThYTWZNM0g1WjhmT3hjMGI0OVhm?=
 =?utf-8?B?aEF6a1QralI0VUpiS2VYenhUZmxUQ3lVRlNIdURGbXRwSk1qd2JnS0RBazBr?=
 =?utf-8?B?RWZDOW1yS1Noc2h2cFV1N0p6RzlrODg0d09OUk5KSVZkZGE1TE40cW51bmVY?=
 =?utf-8?B?c0w0VmNpanhYNEpkcStLOUFNS2phRnkwL1dDU2JBZ3c4TjBreWRGOUNQeVNQ?=
 =?utf-8?B?eFBlODRveVp1K2d6K2dJQUhxM2RRNmd4K29HVTd1ZTNMUTRScGt0OVVuVmY4?=
 =?utf-8?B?UHNRUHE3S2dqa3F6VUFxa1hDekN4MmhXbGxJQjhFWURzMzBWK0pnWkx5ejM2?=
 =?utf-8?B?MGlkMGxtbXE5M016NzI1Y3JIb1l2M3V4ZytYMlc3SUY2ODgycy9lbFNWcmJt?=
 =?utf-8?Q?CnHXCI7mCS0d1Dgg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ALGEEx85LIcQ57B8WtKiTcFzOlbp0lycRYSVK7CLLKT0+Q+YfQ9Qz1OeSjfD0UrYTDbnYc1bOCbElDM49OjIKh+kl4fRQUqeTzskimqvQFkYPhn0v3iZ6ZZta077SOw/2xw4z2YV485FKNZI+Us8O5r8mTTLNnVbDer/W1bi8aP4ZILG4PM3y6OH6ETgYy3GS+euiajz4dIHg4x/7XjNFeYUhd6zlZWIWFfvf4JkZro2fKA9S5hOpWkK+zwjo54s1PyvFi9ZHTbLKWHRJJOthFr3VwcY0qwruL6+rh0Uak7R14+Lpo83zwPFEPoe2suz1a9A4bhcJu9ba967Yq3nbp+euO90XJxD9cSsthuK1T1U4x6p2BAgxQiqGXMMz+XF2uNDON3VlqDV3/Tkd55CsPdzw8KC2zlere7H3ftr9Mx1DjJr+7WWLWVbZnzWVKZvLdjvuoxnrQY/Dm+uWib0yjS4/CC4560H8tnHk8vNQeWRvn7yJ/Q2UpAacWfgdo5JP2DtZjRtIwOHYj0xhkWh5dOM+7Z2tycbW2agRrehoz4YpO6KO0Vhc4AMgT31LHohr/QWKWV+CbpV1Wi6ohdzA7K3uFK8KhqZWtOX5BZxaSA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f31348-7ffd-4e6c-777d-08de7876a5f2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 16:13:32.2050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V732DPFw/DahfyYwig+V45/qelo3Zppu+Uw6+pDWT5HemevcbatcRsHcPgfsy9ZiFofjRF2DCoSKEoiKbAxm1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020135
X-Authority-Analysis: v=2.4 cv=T4qBjvKQ c=1 sm=1 tr=0 ts=69a5b732 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=2DmcCY958jqXNkOs0LoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzNSBTYWx0ZWRfXxYcnTAaYmYc7
 7w6LK86cwluXljzCkgm8pjqvuCBO3ISYnFoqzctC+Fi+rT32HqJ2a2244aX8dkPr5F+YEAtbm0J
 C6Fbv7VVKOypv4B2Q8E/OqeEWXT9Nr6q6/W3YEb4jvVF+EqchbyqSmI3k3ImnocnST3NB1LjC7p
 RifL34Vm4eeRXQBnDHEZsF5FofRNRJlxSRpQjiTEL1tXQ6oR5bRDoVZLS/VGzW21SzXIR1EnlCd
 87gTp7m4QntJc54C3eGatSOWcmTzUQuK5Mw20TSYfgWOhHu6vPFTS3hb41HZruZrvFRMxTQjo93
 WVSRcs5di9F+GNsUtCVsQVcSdK5+/xZL9AtO8fGZqcgM7OBC8lD0xD2SDbL0la6WTDxkYdH+vSj
 t6iqPxO1vIQ4xYDwK9BWlliEWIW6m7e4l7+C6aeLGlKF40WeIB++EGnwIMGe9Uxm2yty0s9vwNQ
 AeswUqa8O79RTNLbasA==
X-Proofpoint-ORIG-GUID: bPu1kfuZ_C95_yK-RIRXw5pMfR85dNZM
X-Proofpoint-GUID: bPu1kfuZ_C95_yK-RIRXw5pMfR85dNZM

On 02/03/2026 12:57, Nilay Shroff wrote:
> On 2/25/26 9:10 PM, John Garry wrote:
>>   void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
>> @@ -277,30 +279,35 @@ void nvme_mpath_clear_ctrl_paths(struct 
>> nvme_ctrl *ctrl)
>>       srcu_idx = srcu_read_lock(&ctrl->srcu);
>>       list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
>>                    srcu_read_lock_held(&ctrl->srcu)) {
>> +        struct nvme_ns_head *head = ns->head;
>> +        struct mpath_disk *mpath_disk = head->mpath_disk;
>> +
>> +        if (!mpath_disk)
>> +            continue;
>> +
>>           nvme_mpath_clear_current_path(ns);
>> -        kblockd_schedule_work(&ns->head->requeue_work);
>> +        kblockd_schedule_work(&mpath_disk->mpath_head->requeue_work);
>>       }
>>       srcu_read_unlock(&ctrl->srcu, srcu_idx);
>>   }
>> +static void nvme_mpath_revalidate_paths_cb(struct mpath_device 
>> *mpath_device,
>> +                    sector_t capacity)
>> +{
>> +    struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
>> +
>> +    if (capacity != get_capacity(ns->disk))
>> +        clear_bit(NVME_NS_READY, &ns->flags);
>> +}
>> +
> 
> I don't quite understand the intent of the above function.

This specifically is a callback for when the NVMe driver calls into 
libmultipath. It could also be supplied in the function template.

If you check mainline nvme_mpath_revalidate_paths(), it iterates the 
paths, and for each part checks capacity and unsets NVME_NS_READY if set.

Now libmultipath manages the paths, so we provide an API for the driver 
to call into the iterate the paths to support 
nvme_mpath_revalidate_paths(). Since we are doing something 
nvme-specific in nvme_mpath_revalidate_paths(), we need the driver to 
provide a CB to do this driver-specific functionality.

> Here I see that we compare mpath_disk capacity with per-path
> disk. Do we really have sectors allocated for mpath_disk?

mpath_disk manages the multipath gendisk - it is no longer in 
nvme_ns_head.disk

> 
> Overall, IMO abstracting out common multipath function into
> a separate library is a good move. But then I just want to
> understand layering here with libmultipath. Does it sit above
> the driver or below? 

I would say neither - or it sits above the driver, if anything. It is 
just a library for managing multipathed devices.

> I see in some places we have back and forth
> callbacks from driver to libmultipath and then back to the
> driver, for instance:
> nvme_mpath_add_disk          => driver
>   -> mpath_device_set_live    => libmultipath
>    -> mpath_head_add_cdev     => libmultipath
>      -> nvme_mpath_add_cdev   => driver
> 
> Does this intentional? Or am I missing overall picture...

Something like nvme_mpath_add_cdev is a callback supplied for 
libmultipath to do some driver-specific action. About 
nvme_mpath_add_cdev(), I think that this can be pushed into 
libmultipath. The only NVMe specific thing it does is the device naming 
- so a method for the nvme driver to supply that is required.

Thanks for checking all this.
