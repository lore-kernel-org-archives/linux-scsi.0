Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A958529B77C;
	Wed, 25 Feb 2026 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772038360; cv=fail; b=g4tqV+FkhMUDhbUT1idTpUtTSEODbIcwkDvJuhfJD5kPuzF6PewuAyqHmrqxRwbfxj/WVG27DnB9ixpkKY0itGvEz/aWXuUMHBAniMAzxub4BTao9nyps8HdaBx4PeWxouNIyx2NJSWjLBjCn48r1+wVi8LwDrenvsOGHJF+oLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772038360; c=relaxed/simple;
	bh=64ugQlxqMU1+p0BvfT8LAWt+wm973mWyrA9bCWrDMcs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sJHrbtR6JLZBZ8lWxpl58q5JVTkW+uuHfTj06lOPd22qEDWmSMx6zhN9a9ibNjGj1dXxbn/RBOnKGeaHKnF2SOPNgZgXAUfGxxTx8GueO1wQm8RIEgMAtNguGQ7Scq6DiR/iXIgV/GIKRXvEkQkBKUu+6ks5gco4YS++zgWVKfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CfOYIao0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bXPpTjpm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CfOYIao0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bXPpTjpm"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9rHfY372361;
	Wed, 25 Feb 2026 16:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NfuESPr+em9JqUJihd2WWOTJkR4qzuiOfU/NmJyjmWk=; b=
	CfOYIao0vfyyEYbJmfo4gle1leFjSvAGEO/NnCDKM/+uqCKN+V6HUe2dvWIhIbCB
	5jH2JiqdW7yLIc8b0aSuQ1TlQz+Xe5oMlT5hlaQiUZ4AdBrYwGg6KmL1Gwf3e4NG
	Vfv9WyIQoUFHzEJePQgKAyz+kCphncV2TkQ6clwRadh9Q5HxbwaFGBdoHjDQT/Xo
	YXLLlTWc9iUHf1L33Vd5fSK0xYsN/4v/yETy34YreBQxyvs+9f7Fgvj4qMhNl5d8
	y/1sfLLlilw9ohO5t27VNyotsMq6Cpsh69kJV1ha1ruVCytdl4I3IiYDcaZ5eGOb
	LVAldoDm8V76AhQ6LXVpEQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5xjx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 16:52:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFbVsV027860;
	Wed, 25 Feb 2026 16:52:15 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35gbtmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 16:52:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KqPZp5+6kJzwrINpNVN4qWt9l48IkCAveBCfPH1pS76+7RIXQnTJ+8vhxQFB+obJEJCWMjGPEyu7plPqpJEd5Z3j+R1OY4OLk02WZvSigdw+uTLx6XI6BMSsiMcOANW0t9lJ+Jom3Z/3I6Ir3QWf8WOy03Q9iaYuqXx+Qmny6WOqYwNe2NDKwPwFG+ZkpHsgKApYzwuRcCt7DkDnlHkoYloynApm8yDwm2zrfqwkp3cumQoqPdgPCLs8hveiiC2X8yDGwO7VJO5Df9/c5h8yp3kOkFL3bn6+sOXKOIVKk6ogKOfCiXX0g89fP56IafqZmXwuk9JAeoKl9nLDW/rUGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfuESPr+em9JqUJihd2WWOTJkR4qzuiOfU/NmJyjmWk=;
 b=Iklr8fPP7VMq6m4t3b3gJGWCjjHOPQnAQ3KY5BT3r9OoHqDdz/x/D6rMZgs7H+WefgSnXAgitfkybXYfsM2SyAyDL0lfteAjaiK1kLsetL7Nq+3njboMkb/ltIvdN/jQ2RcvHHi2+kbj7LcS3l+GgEE4wwrN1KIMx620iWVY1FqiCQv1MM5jAp07g05pfg4ShLZ/PgUvjxBNNGPh9VSjEKWMBKZSl9906ruD+s49PB7PJIrQjZLkyL57Gz9fXqF2W8NKsXTjXP/rLCM4D5pE0KmnNs9VoMhk9peQ331p7zC66daoO+6kStAxmwdnfiTikNaBRcHbwZxQpA6lpXZB8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfuESPr+em9JqUJihd2WWOTJkR4qzuiOfU/NmJyjmWk=;
 b=bXPpTjpmIKywkoSFtIkbkXk1ft1JNR9Qoy7wd7TfBJLRP5zHVV/dnFN21vlltcMpQrmWMcxh2US90sRa5fXXMr17M7Omla90x67RRoDTZiS5f51URlw7kDe+MHEuZOUEuQ1R84FNQ+tGcXOt/r1d5e8I4JJlXCpf75IzCsG5tQY=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB5870.namprd10.prod.outlook.com
 (2603:10b6:510:143::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 16:52:07 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 16:52:07 +0000
Message-ID: <74df33f2-6d14-41fe-aa5c-45dbad136bc9@oracle.com>
Date: Wed, 25 Feb 2026 16:52:02 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] libmultipath: Add PR support
To: Keith Busch <kbusch@kernel.org>
Cc: hch@lst.de, sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-10-john.g.garry@oracle.com>
 <aZ8Z7A4uOFfOTDeY@kbusch-mbp>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aZ8Z7A4uOFfOTDeY@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB5870:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bf06740-cf0d-49b1-0998-08de748e35eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	mTtn9a4uOEaM5IWL9fw6LsoTlACeJbTVr9woOCXOeryaJAWku5shYEGTBKBQqSPuL987a2eOtCKsWJ3+juuYORKIzmzKEQ5k6glqJRgCl6PbRpVEHqwvYelStzq1jyMWmYAIvyqZc2+P3NVbI8Qw1XVqMcUfGJxuA5DZyO0To+xIcQN/UhRQDvIKWZi/n3KQmwq6zSAEP0TmCgUMHWcsux60XJo1QFbwsrbVdfbfyS5S3nJmUWoCUhqspjfqGELtL1Gp7EQCEuVgwvcOfZyoGoXBOrneeZtgP/2k2j/OEglQnEWSwfSbVgujjYGPmLFRA0w0k/ZBhESkCxw4q3M3/GTUl8SyLANFUTD62YIcBS4dbGPDbvWpywZJcahQRWkB3RFPbccsDpPrKGkaRKoTzGczkU6bgxtKcb81s9olu/094ASO79nGiOuLRSLj9GaXKT/KUErUIwEi/onI4RHD0pdsvSW4Q90AOZO6ap2x+buOKDz/61VfEeF8rS88X8CiDjBldpl8vWh8gbv98ka8mo4WOcWP+TiGiaQT9vr8TgXQX4nUwcxIiCqy5BSVyHVXRmE3jJRF29SkVsnC/pVFtWEgjmRmnGsTV+Ym9CO5WpkfcdPyh83OaZdnyCJOsgswXkbq1dN/6kKtXZ6FLDLfdZqh9JNiF/M5woyfhcjd4YvMnZ6vlsyw82BTxxk0UZfJE8b77dBIgA4jL3Hv4MIA7nKorL4S87EWUq7w0H5GKw4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEZSRDNSMTVCWFBDTStLNFJ0Q0JoR2VKNXdaOUxDbmlkdDRFODFJY3d3cnQz?=
 =?utf-8?B?dGFOWVZSeUcxVGFzL3JMV2hOMzlKTFdmNFFDUHM0bXFDU0o3OXdkRDNYeENJ?=
 =?utf-8?B?RE1hd21XQlhZQjMxY2VCMVZyS2lYK2Zna2FLRDBFQXR3VjMxOStBSmIzbHZ2?=
 =?utf-8?B?dENXcVhXaVBFbDRySzl3c1hOeEFkYkZjTTdOVFNPaG1GOFdkMDY4LzBPaTBp?=
 =?utf-8?B?OTUrR2gwL25TK29MMlNYVUtEa0JRNHpLWDJIckhiR2JLekkvNCttcXhTM3V3?=
 =?utf-8?B?bTNBaEVUenNSK2JSS05PMzNzeitzd1VHVE9YM013NzB3YXVlZnhXN1hSczdl?=
 =?utf-8?B?L211NEo5SHBLTVp6c3V3TGxRZW52anJHQXc1dUVaaGpWU2JhL0R6UEt4bzhC?=
 =?utf-8?B?cEs2MHB3RU1wQmJlc1pZMlpGN2ptczdkNytRU0dHSUVuSXBIaERjcDYvcTZ2?=
 =?utf-8?B?a2tOUk4xN3NqblBnV3dtcURkeTV6dkNMR1pDMC9MRGc0WjlBTTdCWElra1lt?=
 =?utf-8?B?ZGZlU3ZBSVFlUm1YQW91THAwbWkvZjVuUW1XNldOUnFqb3dXN2RRR0FHbmg0?=
 =?utf-8?B?OEtFN2h2WEtFbkZSV2RhREhQbk9GbjlDUnB6ZUNJYzdRbFlobXRCOEthczZL?=
 =?utf-8?B?eTYxSmF3d1JYeEk0TXFpYUZ1bnRvK0NERkFNc3Vwb3k5NUpLLzY2TjhYbm15?=
 =?utf-8?B?Wmpjd2p6NEVFRUk3QnNSVXJ1UEh4RmxFaGgvTDNQaHFzbGd0eGNQVmR5bjM0?=
 =?utf-8?B?SGszcFZveHluM3hyS1NxV0RVQ05SZ1l3bmd2dGRvbE5tNzlKSkNHU2dHTGR6?=
 =?utf-8?B?VWRZMjAwYnY2UUdZQ3dCNURZam9LOEZTOHVHdFlRaGdTaDJtcUVEYzEyUDdI?=
 =?utf-8?B?c2t0RkwrTW1ScDRrdk8zZUU5Z21iMmZxcFp5aStYbkhmTU1mN3JBNGU0Tmo2?=
 =?utf-8?B?S0prbUg1YUplUDhzYWV6bGNpc1ZFNTlCOHRLUFBzN3FvTGlvcEdJOVU4MCtI?=
 =?utf-8?B?bFZYTCtBTXpTdkJKbVlZM1FnbW91Q0hlN3hRMlRCczRMT1l3UDhSZDNqMFZ2?=
 =?utf-8?B?Wjl2L3RwbEhMQWxGeFVNa3F1NWw1Y09UdmN3bGlDRGxkaE9aQ1dQNHRKWFRK?=
 =?utf-8?B?bnd5SXBNMkdzOWlGRGhyWkJ6bDdlcDFaSTdMOUFPRjZURW40Zms0RGZDY2JT?=
 =?utf-8?B?ZGdLRkJlaWNURWhsWG9CajNqY1k2MlhVdzRmaDFKT2JGWUovK3l1T09LdEQ4?=
 =?utf-8?B?TWtuaUtRRXNwMisyaTROUFo2VWtjVzQ5Q2tXNm5UWUFXbE1zcFNiUWQ4a3VV?=
 =?utf-8?B?TVl6TU5PdXcrRGdlSkVsN0d5cHJqNFF2SUhzSCs0ak81VFdaWVpFWjYxY3d4?=
 =?utf-8?B?eHFmQ2FlWU1LbGY0djZ1REFlaEs1R0x0MS9pV0wzanlPUXdYZWdqUzVlOU10?=
 =?utf-8?B?ZW53Q3ByamV0Nkp4WkNwZFE4d2RFOEhLK0NVUTl0QTVrNHFLMVZxazY1SnNJ?=
 =?utf-8?B?RHpXV3pnbFErQVphV3VGODQ3ZjhLbVJKOERrZGRCR0hTcFZ1OEhlQ2o3YmtL?=
 =?utf-8?B?U0hQVDVGSDJ5OHlOZ2tsWnBRbnQ5eVd6cXc4RUZYRnhuOUdsU290L0tBMFJP?=
 =?utf-8?B?WWFqRGxMcXU2QXNhTTJEVnViUUZlSkFXRVh5YmMzZzVDcms5SkNDeDgwZXRy?=
 =?utf-8?B?UHJZMENHQlBMVkU5MnRYL3YxWFdsTWlibVhGS3p4TUdOUzhDS2J1K29teG9i?=
 =?utf-8?B?QWZxQSsvWnZObWhJVG5JRTFOZmNiUUo2dktoemwwK1pMdFl3L1Bhbm92bytO?=
 =?utf-8?B?NHErSVEzNjRiY0F5eVdOWTg3YzV0SDl0QXpudk9KcGZxcmhENStTUnVPRENK?=
 =?utf-8?B?cDAwNGh4RnJzdzN2WUdpQTBNNVJyRG50YXBBdFRSc0xEdGp1SmxHNE9qUjZT?=
 =?utf-8?B?eW9iU1l1SkVuTlZhWXdaY1oza1VXZ0xkbWRlTXhtUnZIZzZjVzFFQTE5U3Bp?=
 =?utf-8?B?clRZOWdaR3JIb2VxQUJQYkUvcHNvZmpFWnBLOFJDdVFaUmM1UXFRd05GR0I2?=
 =?utf-8?B?N2F6bkNoRGlZVFRXeldTYnFWbndyeXc5bGZyV0U4SlYrRGRqSitkSlMzWFZ4?=
 =?utf-8?B?OHVETXc3WHMxbklBbFVOVjdUTS9qbHg3QWlReG1EZnBYSmxtSnBvNk1jRUQ3?=
 =?utf-8?B?L1E3SFFxV2lhblYxU0g0cHZhL0o0ek9URkl2d2J5Nml5UkxqaDB6UmtEdk0x?=
 =?utf-8?B?emF6VXh0SFltajY5Ymoxdzl0M1BiUHAwWEdmeTZRNjNmR0FpNVZ0QVNrZm9p?=
 =?utf-8?B?NUpLNHJqd1hUZ3d5SmRTdFpoMGlHRGpkSkE2YlRhcjAwWnJyak9TcmhrOXdq?=
 =?utf-8?Q?F/tqI4imBHfU1oik=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	23TA1lWnrFSJ+ACPu+xaLBrEjqQks+tCcsOcpgeaq4H1U33MnLtyIRUkSTGovX8Omkn42deTG7YExlxje7kasQgoKXDu5xRPv/8D7HsHzHFmCVnKxXP3wyrQDEP6Ne+6WxENHr/v8B2uzU4m2gwjvbRewgOscNcMTFdwD29aMypIEAqCHJFArplDNl+kvO5bQdfCcL0FEMzyMynxl/DWs1nV1Qbbx3d56+GaxIO4WACRln2k3+E3FZx+9hozZiaFrMZoUWMviRxoau4GFUaG2k+iM8keDoiO2D0tvxmTHfJDpptFwNY+eCYVvSIiFSZ29uAW9Xruuh9KtNxNcanVTdpuHVDxBYLAw4IfHytN6u93cVTzk3g5T9+QgwD1s6sJJhJDHnUTMUbwaNWlnNF4emt4THDPcC7B32pMWDZrSwBStgM+nlcgWTxG9ZonrDuLSk/LF+O5btTE3obbbfp8tv83HLOBmusPyNfZv6PwlB/kQp8RUuspMIxOur/pTS6ZCnV4GMFax6ikdGqEy6wWo7IJHOmSJjh9jZYEhOsovxVOApdGKjsHoPXCiDQugjVuQynCAJQ5Oo29cSqLfKLogGhQuyY5wHH0AZm1fv48yNw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf06740-cf0d-49b1-0998-08de748e35eb
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 16:52:07.3355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b51ZqW8J22Z9QIXDh2nzXjuZw1FgjG1mp/nihROSyE9ygSUyqXQB0j+dgCu3sP2W2cenGGeBSX9EjG4zMuU4oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5870
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_02,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250161
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE2MSBTYWx0ZWRfXxN7yWANpTtsa
 PchegDxzNbv/OWBD83jJMCmsg0SA7Q0cYZlbShbRI+JNSeFNCKe6SyTY4UW7Kw5St5y1Deb+12u
 uV1WivkTNC4F9GarYxuKssKLotev7cjKYssO6rXKshQRWnRd4ImF6Ag5lZnwdpQ4x3ewFRWspkM
 bgJn/4Xl0VwXYM7vx36C2wATljTlnyNeZdYJeswEigo4kWX5yieUWzrdr24n6geAt7l0UMUHRhw
 3K3Z/3HRICAhP/mZ51M4ThIg4Ue6bZpQiokw9jPauduEaZPVwAnyg91Kba8axOTzbc7OGIFMaJw
 D05bsFXGsgRYFXDxez8W79MUK2Jp+t66GnK9j5z7BiCDTT+vjWWGghW0uJtMxvCM3Gq5BDvlrm4
 EC1CsxlT/fqny/anZgi4nf2sflrN4e2ONXCE3K5xvZNBmTsFGivpUjtzPwXCI9xkpKS6Ybo9fOE
 0MKSanuwbxUQoqEp8nXZfxZR+ObtLqa0ee9ZpdUk=
X-Proofpoint-GUID: 7q2Rm1y2OGCMzKWsqP_cPlQeJsb_G8gj
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699f28c0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=IT8soIvghSBJdHo_LvgA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: 7q2Rm1y2OGCMzKWsqP_cPlQeJsb_G8gj

On 25/02/2026 15:49, Keith Busch wrote:
> On Wed, Feb 25, 2026 at 03:32:21PM +0000, John Garry wrote:
>> +static int mpath_pr_register(struct block_device *bdev, u64 old_key,
>> +			u64 new_key, unsigned int flags)
>> +{
>> +	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
>> +	struct mpath_head *mpath_head = mpath_disk->mpath_head;
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, ret = -EWOULDBLOCK;
>> +
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +	mpath_device = mpath_find_path(mpath_head);
>> +	if (mpath_device)
>> +		ret = mpath_head->mpdt->pr_ops->pr_register(mpath_device,
>> +				old_key, new_key, flags);
>> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> Instead of having the lower layer define new mp template functions, why
> not use the existing pr_ops from mpath_device->disk->fops->pr_ops?

Yeah, that should be possible and I did use disk->fops elsewhere. We 
would just need to find the per-path bdev. I just wasn't sure if that 
was a preferred style.

cheers
