Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B07E330B00;
	Thu,  5 Mar 2026 16:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772726419; cv=fail; b=Bxg6e7QgIVCJD68AJXSQfhqIete3cdIaes9WRs5ucFEfthKUdYv5MYpHr/j65AaFDNNF2EXUAU46w0MAyXZ5beDuwX8jbRS3z6nTTP7uVmHThiZBMQX7zLTYbeGTpgFf+2AN60rvVIzgvmhVaaytROk33mOfWvMX/iKnX5IdGyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772726419; c=relaxed/simple;
	bh=CRXJGn6WG+5aUiwJLLUyWOh2M/tXugDeiiRn9ht2Kso=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gd5fONJI5fQXwn90YJ8OJTxwiCiWK/9zOI+6uEYHSPEnByncB2FJzxaOOSIwI0Cckx6iq7+kM+KXK7eS/lxBcxxZ8sXh1gvtkmohPM4ZPMq986PVhXZl6ju9pPr81VjMiI+JyrSnhGsZ0QQSeLGTcFEsppUsoaYnpj3cfpIHyd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IgYGHnIm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aMu6WFXh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IgYGHnIm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aMu6WFXh"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625Fo6dm512146;
	Thu, 5 Mar 2026 15:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bWoI+IE0aV12anStGcCwbcjPDjACxvwGAXVOkrwiU4k=; b=
	IgYGHnImafNxrSixJG4QQVz9MzIrSHxIZkzWcN5k9FQ/NIXuaZwn5hUFDqvYK/3n
	lWW9zejAhtohQHZ7PCJjogDfyhvnGuTWVk7CibGkdzwqECqLwODNfZUYxUPrlU+2
	Pc+ZRHX8v2ZNFbOU8u7AmF4ZIbCM/H9sk+ZDYwYtO+lAmDLepb8vK8t+tTiQqtkc
	tYP96XEGAkaQVVhS5SO/w8EY2UHdvfyRc+Hm5z9PkNamQh8RcGPrtr+iJ7DXFpW7
	qV3pwhBNu09nfRYjX0W+EhVGH9eCNReMSOdYbqtnGpXmV6vEzsdFwRnyqsMQzpZt
	iabiP/C3LOKBbKIrK1qxJw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cqcts00gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Mar 2026 15:59:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 625FZldj023072;
	Thu, 5 Mar 2026 15:59:43 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpthq66c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Mar 2026 15:59:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Srnw23oTa4rN8ycxhsbRJvlNKs9dc2d38aJBMA/53/19la0Z8hGEYgodZVHjmFNynqYvHc0xqGjO+RtquciVUOYj+G6JyEXUhGVG3ognInDVMoEg3ebeCPbzTwWvtuF0a8NodGIYOa3XTBTCpn8CKNnnE/p+7WdhUCd/egDeIdLOibE2oQYkZbi7Ez8gL/6vH+znZJ8NET3acAndXkQEp6wVFL15ckogpOJooByWj+g0VkU2RDNYxq3m8k8zLFh9mpUlyqkRVKyCqqwuz15mlLoRJVeT0vCPYypKjhUKPKLay9hNqxLn5yTlwYCVhrOKGHUJyBki9cvvoEU0+XUsUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWoI+IE0aV12anStGcCwbcjPDjACxvwGAXVOkrwiU4k=;
 b=vXcb7OYRhg6VFxDTfB26OrBXth9YhZoYh+jXljJv3EmIdqfo10FPmNb5fDDAt2CogJmgPH6zL6eS7tX42k5p2n2VmyRyzQSLWqQT/BbGS1FpxxgZVLZ9vq17+4AJuH9SXXAQsWZ+dDsUfd74TbDEiIpG5GYsaw9fkaCHky9Ysdeflrdzlo7EggMzlhDy1ie6afSm71PTjflUE782zJHEGpRbxg5tfxggAXo5cJv6AxaAQg0uKRlQ5uJ+EFHrEI48SO4Nb1/XmHn8RYwJnHKkbGk+rNRkL0qKjWX+TSAbi8cIaRH/62Eiyv6K3C1AYN/RL3ZPua3ZI7iZFZIMwtcnDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWoI+IE0aV12anStGcCwbcjPDjACxvwGAXVOkrwiU4k=;
 b=aMu6WFXhd+sDglpBthlFTIV7HZWJf+vS3mF8DcoE0+NWpV/u/5o/VOojF6JpyinufS52/iuZVCnasEffK8ELaOC4uTJH8WW6GC67MuzT8JNkkuYdiA3KUrXJ/mvoLQRaJiWekRvJkJ1EANn6E3GKLlOpW2aUkdwb/AGpYa56BDM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH3PR10MB7678.namprd10.prod.outlook.com
 (2603:10b6:610:17a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Thu, 5 Mar
 2026 15:59:38 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Thu, 5 Mar 2026
 15:59:38 +0000
Message-ID: <6c92a5ae-66ca-4c47-9185-60d26f4c1c87@oracle.com>
Date: Thu, 5 Mar 2026 15:59:34 +0000
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
 <aaT0Taxs6WgX6m-j@redhat.com>
 <784abca8-9dc1-4fca-b72f-62d55b4cc3f1@oracle.com>
 <aaZ0Kf9n79QF4gbR@redhat.com> <003612c1-ff07-466c-93e8-d7766a9ec2db@suse.de>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <003612c1-ff07-466c-93e8-d7766a9ec2db@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZP191CA0041.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4f8::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH3PR10MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: c83b4133-3fc7-4192-15a3-08de7ad03411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	cUKUDnX/13TswrlwlRNqSSGbXFgESJaR5moW44w/1wCvikBpV5rYbOIGJYyjK64a1DeElpf9vxRgVRKqpZ0+ksUzPZVPdRQrPMmZ7yPe/sLwSESMSd2E8dzgapefaSnq68FVJd/EaIj/bCyk2DHCTxz3Beg2HurIJWfFmOThjuLcnOfVXFVS0jWpSi88aIiRJDbzIWedgFV3+uns4162rl2MCHRp7j2TAvWAbcAQABXQ83PhT7Bzp/5rrN53x+DLAJBuWR3yUuyAPvYEWQ+4EMDGZZ8UkDgkoogUtNAdNoQmwy/2tEKJXwFPzZ/60GGSZZ4s6lVWm/9ov7i/vhDHn4uo/2dEo8ZXho/uIjZ5CgNZ8znDda9sOssHY1mzIykHOSX10ood1rMd83L9M3geAmGeYpYuZMPVolMH+16Cz/z+8Z5JbJn1Lt8J6n8qKa2XT4uHCd2Eu9UnA66K2qcSLr52RtYf2ja0B09EOnLatWXeqXSYP7O194ynIdQezh2jirIpC+PVg18o2TbApGlZVfH2LIqWE8YEOzehtm9tkKGb3olVUudwNS/LkAzCEFNgneZkUlOFGCBRUcdQgLJlIEyzgTzYWvDR+3KiDlH9jThEjSmBmOEXB4O6752Fasvkddj8dalagPeGRq1Ft0vbeDcJJH6wde8dsnA4wfEdpaVC2Xdm/xMmjlULAJqFYIiwUuuB+Tm0K066Z+cBsPPYVpzj7LbQ7GvA8XacJd7W33w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnBRNlVIUy9KdTU0eVRCZ0JlNXVhd3dYeDNGVms0dnFLNzMycjFnWnhnVlRP?=
 =?utf-8?B?V3JWNDUrWm5SclUvZlBZOVBrMGQvOGk2WjdNSTNGbEtYUGN1VllkeHVxZGtu?=
 =?utf-8?B?WXFKWVZQam14MWNFT0E2cnJJYm1RZDcxc1JPYnBFd0ZOQnh2TW5oTU8vV0gx?=
 =?utf-8?B?OE1qaGNNM0c3MlIrQzZsSUxhWGorMHlJQ0FxdEl2UDUxZ3VPeUI0MVJnTGN3?=
 =?utf-8?B?NnIxTzFFRDdnQUJiamRVZkNrMHQ2S2hyRDZxc1JURDZpM3VLQ0Zuam0xTDN1?=
 =?utf-8?B?NnVtMlh2QnNSMnlGd2x4NHg0VFRzYjl1dmVXaDhONDR6bzJHQjNXZU1HVGtY?=
 =?utf-8?B?UW9Wd0kxbTlNNXNHYkpBQkcxb0t6aU11N3Y4Z3B4WGg4bFFiRFNMSDhpTDE3?=
 =?utf-8?B?L1lGVjFYdUM3ZU8vTm9JelZxMW9KcVQvMVB2V0lqM2s4L0NRbkh3OWowQzBx?=
 =?utf-8?B?bjU0a1UyY0FMYVVjeHdFczFUVVRVcDJCMTBtSzl5dFdac2pXeUhzRzBTUk81?=
 =?utf-8?B?cGtqT2xuTUlJbWxiWFBlSlpSb0lNSDVyR2dXckxXNVQyamE2ajk2UEFFeXJ0?=
 =?utf-8?B?VmF4Yk1HVFJoZ1lhc0tKV1NyOFgrcFhpOVJHT3hUK0dSSHAxTmxacUZ3RG5T?=
 =?utf-8?B?V2dCMnI3SENFanVlRTAwSzFEdXZmVEJZT0xWZDZRbXBIT1ExU1h4clRJajkv?=
 =?utf-8?B?U1B0d280K3BQV0JSc3F6T2NNRVJYMzlkU3BYaGxhTTBCdFRGaHFWUGV5N1FS?=
 =?utf-8?B?Y1ErU3FFbDhFa3I1UzNVMzY4elFsbktISTZFR2FLNm1VQktEZjcrL2Z5YjZR?=
 =?utf-8?B?ZzZLSVRBVUFuYlJ0cUt4TmJvb2xLMjd1YzFOVXUxNld4cmFudGREK0M3MUla?=
 =?utf-8?B?VFZxeFNDK0s3ZDZ6c01UbTZ5K0pxS1pRMmJ4dDF5ZkN0ZXZ1S29yemQ1eEkw?=
 =?utf-8?B?MEl6R3JTSFUrM3h4OUxWM0hLWnZZekpNRkkzWHU4ZGxBQnZoQ3Y0UHBmWG1x?=
 =?utf-8?B?NmQ0MFIxSHAwWjJMVElrbmRLeG5sN2lGWXNDMzE4UUs2N2tZV3FyUkR5TER6?=
 =?utf-8?B?U05jaTNsMjNjSk1adnZ1dTkyNWlGa21QYlFraUZnU2NEcWtLTmZ5TzFWZjZE?=
 =?utf-8?B?YXdiNitTZHI5UERFSVNTOEFKWk43SE9FNVZKNENMUmNTTW9Ca0hrUjJQbzV0?=
 =?utf-8?B?M0M5eWtyd2VMR2hVUk9WQytja3p3VWxETGhxQU5aajcxZWl0QXEzK1dkM0Z6?=
 =?utf-8?B?cmtTbS9OSjg2N3BxRCtRamxjZGlweHlnMUF6MUJqd3ZtREw4bUtWaGl0U2Iv?=
 =?utf-8?B?d0tQNVJLaFFXNTRjd20wNUd6ZHlreFM2eHdMTWJxYXNhVzgvK29NbHdPWlJk?=
 =?utf-8?B?Wlo1SmNnMTlPeWhZeHhmR0VEYmRZNlhDYUExV0lkNGJaM1pxUTJuY0JCWGdr?=
 =?utf-8?B?SUF4WTFFR0thRUR0T3FoQjlHTkVRY1pZbHBhdzFyMHVCMG9YS2xNY0IvbzVT?=
 =?utf-8?B?OFFvQ1VGZERzZVhzYWUyaEI5THcxTDZJVFZnSmtCcENabncvVU9GSlowT2dD?=
 =?utf-8?B?b3VXc2liZ2dkV1dOYjlwTW96VmZ5SUFIVjRCcTh4RnNWdElwUHZBZDZLUUtM?=
 =?utf-8?B?blQ2N3d2K2IvOXZsaTBUR0lrcGp2Q0lsckw0TkRJRnYzWEoxZmZibE9XNm8v?=
 =?utf-8?B?Mmt3Y2FWaGdxNlRkcmxXZFIzUm8rdEwyQ3Z3bTVmZVIzVUJiUmhSdnNGaXlG?=
 =?utf-8?B?eFFIVVY0VXZTNzRCcVRtbzlwc1hKTDlQcXFsUTJycXgvSVllWUdDTGpXdDZL?=
 =?utf-8?B?VHhFMzh4dTZ1R1JobXB1Sk5kbWM5cm8vUUpjUXFFdlg1S0U3d0kyWlVVRkxw?=
 =?utf-8?B?Qjl6aSs1YldmVHhPdFIrRlRCS0lGYzVndmV2YXJzSGx1WExUamhIVTIwditK?=
 =?utf-8?B?Y1E4R0FFRTRYQnlMTy9OQzJlN1RmbmtBRW41V0R5U25sbHFucm5WSzRrVWJL?=
 =?utf-8?B?alVSZmhWOTlkN052T1dFZlB6SDJrakpxTGZxQUJvRFE1UlFTeHZRZ09jWFdF?=
 =?utf-8?B?aTR2NndHakQ1OTVOeTZlbGRrYzNwMmlxMm5EQ0xLNjF3QlQ3TGNkNExZSDNO?=
 =?utf-8?B?UUpwOFlNNFZDWlNlQnhKaU83N1dyL3hFdlllWHdja2F5Mm90QTBQVFRjSmUz?=
 =?utf-8?B?ekhGTlRtSWJHSWltQk0wMFR0L3VmdG0rMmVldWM0T3RFZDZmNUIvZ3FPTzJ2?=
 =?utf-8?B?UldSRVowY1BlVk5LZXNSQllVZHpaejlDWjZwaDk3ZnRFc1RNM3R1ZTh5d3k1?=
 =?utf-8?B?Si9vWjlVOUswanUzSWJiVUJNbU9kUksrR25YNXo3SjRWOXU5TUE4UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lXVb9V2EGkVvUvqJ7j0t+jfcrk1zX+CYx8Vs6xG7WvKyHg2vEiwufSnquVkNJHgDooHFlOqXkuN+bD/cm06KxK+DpBB8MK3BWACCWb6QmzHH3JgDehpuEZGyzSbQXnATjeqk8vxu+yE3xb79MB6j5nzlrIeiTsKhSKh12vy014HQiC5C7TbYISx2sFXMKyiA6WUjPwckR63an1IlkQroeUpnw6O/yUZxhA+uqEY8IT1uB1gqtHf0euBBc8gydO6lljHF3D+R3Nh84egQxY1zHcePbS8IF63mAJAUyxZWD1oRlXoEwuF4S4eP1tpKge7huUwUX6WWp0STUhHgLN/T4y9ji7atsV1xCRu9Ox7B/tiF0kypxoc8OhE4FJuyNBuqZLwZe0AWPNMyNqFgQbRLWZl3oyyukUu817OpJRpTt6ub8GtVJZCGTwbmpeQi5eoslG9JdKREPIoa2fiv1wDjas+k6JTwjJq4IBTqT2TsP2Go4sqd1q7Zud7l/WQe8sH0a/AqWmLiq5nIchgZeeHkIp/TPSOWgTlGK6OpaRngiF4xx0o/NHWe2hnjO8MTMT0N9faNBK0Uzx29l3lLfXorAC7hKChxGW3vykUFnlWuie0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83b4133-3fc7-4192-15a3-08de7ad03411
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 15:59:38.3279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hGnUfORXrDnVCU7AFw4R0PL1sGyy48FaCgkTA+tIdo7ymlI3lTLuDggciRrY4Vh7+5CCMj5XbS5TPYXUelurg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603050128
X-Proofpoint-GUID: xSkoGl6IuSUtwCBzIrhidUcu5Y-cVez_
X-Proofpoint-ORIG-GUID: xSkoGl6IuSUtwCBzIrhidUcu5Y-cVez_
X-Authority-Analysis: v=2.4 cv=HYgZjyE8 c=1 sm=1 tr=0 ts=69a9a870 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=kURMqUUlrb8xE-WrhHIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12267
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDEyOCBTYWx0ZWRfXzldgZLvXWKAy
 XjqPgjmLdygA2c0keqBfkNVTpc5IJMipAaT0KLhtBjoxTnPSFT4KuVx7drNeNiK34K+1Vt5lwGV
 eOaY4jN7rxcEp+Uc5UHqjUBnIl+vUs3vHqy6HtscwNT9Q+9Pr0AuaZr71Dn+gch4hLVKco/VUaQ
 Fdg1sbIytGVVF+sBYsKLA1wPb+zPpSxpT4xE/6wE/4yyxUobZU1Os4U99bP2ngwMKRMuyGqYwFT
 z2/QEujr/N8RHNq8uhWgVcBnXUAlo0qgas1xzeJdtrFnaMKVtRLz1rRJOO2NIYmJLVDHh3Yf+T9
 Ws62FEUkRS724PoEZ5D4RcsVGEXjQ03bB1YOGzSN96EoQDGl86hG/j8ZVyX6t8EaOfnZg7PPihu
 q+ya4iuCT9xkkkOL6XMWavTggBap6B7gwm4h6Gcbkb9a7kWsGfXuHNtYx41ANrRS0QmALrEAZnS
 no7kdO7g10sAvmlQ+1QlTqMYpBFamM5+xyc53KNU=

On 03/03/2026 08:01, Hannes Reinecke wrote:
>> I would (perhaps naively) have thought that the device handlers would be
>> a useful abstraction for dealing with ALUA devices. But, Hannes knows
>> this code much better than me. like I said before, I'm no scsi expert.
>>
> The main point of the device handlers was to inject a 'start' command
> whenever paths needed to be switched (Like you need to do for some
> active/passive arrays).
> But that really caused quite some issues with complexity, as you easily
> can get into array path ping-pong on path failure with no I/O being 
> transmitted.
> 
> So for this implementation I would stick with implicit ALUA
> (most modern implementations have done so already anyway), and
> then there's no need using the device handlers.

I want to mention the problems of trying to not use device handler-based 
code from scsi_dh_alua.c . I would like to have core ALUA code for both 
scsi_dh_alua.c and native scsi multipath, but it's easier said than done 
to achieve.

I can easily extract the protocol-specific helper code, like alua_tur(), 
alua_check_tpgs(), and submit_rtpg().

But what about the port group management code, like in alua_rtpg() and 
alua_rtpg_work()? As far as I am concerned, we need that for native SCSI 
multipath support. All the port group management is intertwined with the 
DH stuff. Even stuff alua_port_group has DH stuff, like dh_list and 
rtpg_list members. And we also can't easily take code only relevant to 
implicit ALUA, either. Any suggestions?
