Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDFC3976AF;
	Wed,  4 Mar 2026 11:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772622607; cv=fail; b=uxJcsqIVubwJduB3K6GhJaGjXASXWg5+yfLc0sZytxSgWgYwMyu54gJrP+lH1QN603szXb4buyOOZ00tLxlMNAPnrvvSLQnBL5gTt6UKwKjKQSvE39ZZQTHt6JUHZP0wWj7wYjzhVDxIBX4oNmg0lBFVa5PBMXqI7/+tcXp8wBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772622607; c=relaxed/simple;
	bh=CBim0t8is/2VpukcjrGeRuHRKFM5YO/Y8jzqpIaeL4c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZywS9cvVHED8ORsOE5z9Wr0fztMSG1j+QogBrG4oaJUZuw0BFh4mllwmfXprq9TnbEXiQnjnHCnpCn+B+5PeSQeIQbSkbmU4+kyXy72V/uzPoupOmZnG2x9Mt5Jyq4yXrnzLB3OE6CVpgnjDP/JNZSfAoMAIGgt0XxJAiEEt/sI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EtFB6yIL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zrqdGBD6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EtFB6yIL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zrqdGBD6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624AWsaX2306855;
	Wed, 4 Mar 2026 11:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=isFuux/rcHG6UVbG3M3U/SNty1TNZGejioTTlEW2RTw=; b=
	EtFB6yILIjEm5GqdJ0M3EoyJBCIRPOG+ZHtOBk+RFr79YAa/LfrQOh6J6smJSo4z
	DX/Aux5bpP6RRdZ+OV0/V8v+GtBir7aBtK6Gntnokib8DtODMltbmsm9zwXzbSO5
	SzRA0yaCBn3m5y/wVRe6YYTq6VeYUppkLjo4Zta9jQbxuSDda3B9Fkb6H6hzku+w
	/br/z6q6DPgUFEpuGmFHSmrLbsXR0cZihggnodj9M2qtITpy0BL8xrxLPSFbPLQD
	PDO55GV/wSybTTdmLm2r8uX8WtiWyFTFkvEREnv1tt1vmAiM/sNi4cURu1O6JRjk
	0nVRnA0hYy8qCj4udJq2hw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpk2cr21w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 11:09:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6249P1Ge023016;
	Wed, 4 Mar 2026 11:09:45 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptfxqb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 11:09:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oihuJSmX44pGEzEgYrgZDHoXXO0SOLww4KsYpolJZm9ob6QxtYh/pCKbvY9rOx+7t8idbXHKSSRs5G6k0XCCm6h5xUnrnxmNxp6qre4th+1MvNji6N0Sl0hGrzrPshL5dNF6HUnUG4dvVFHqrzkyN6EB28lIwuUnQ9KELRLcwyofK/o44BZPID06NFFiwB8iDdXFLFkEFFKBZgUJMEuYx6gXCKZ4DmFz/bCm9yzUAqtA98lEknPPMMiywVus4Krv9PwjxagzWw1VinG3fLu9GUvYQoNLgn9/SpHjsF4YOFkZu1OZS53/PIrNnC0fX9ZMheuNtAgr7AzKjSXhoWT5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isFuux/rcHG6UVbG3M3U/SNty1TNZGejioTTlEW2RTw=;
 b=MrD3Yjb4r++D+RtPuiS7OguVj0sNSwt1cHAFXBPk0BRMdgM6MJ4TOwXSHta/d8HcVYRTGTtyJRZLx2ETtQKp65pPAWqQXEesrNfMkKpl5sBPNZJg1t2DveWc+9MFWnTqEHsHFS3CJTJN9tQ+TXY02Z2AGQF4nCDMpgzerxJ6kiRLGWN9f5t+LLiHM1Y1mP6FaKypIvKKqOFWlyUn//v9Df6H0WnIYdeO7hTTWwEPhWeSiT9XJnJh+4DhIQa7jOdoLPCBjgq4hWckQmL2GojmbHSQZJXpuSaGQR/LW5ehcrgQA+a/TGkK6nWG1xVgr3rjj+tc8gUNkgL+5STReHmZzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isFuux/rcHG6UVbG3M3U/SNty1TNZGejioTTlEW2RTw=;
 b=zrqdGBD6CrzylD9vlqFC39NJQooj1Rtp2plJD3LCAGU7xK82XVv7WAcXdSE0P+tPBHWGSeNZigLWn30kJw7aHzLUB3knxGD6sgubFPG61bmz6/GkailZ3yTj4ZRPCAik8w8cpe9uiiNxD1nv4iYVIE/W8ckz++OnE/KbOHFaSzs=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ0PR10MB5615.namprd10.prod.outlook.com
 (2603:10b6:a03:3d8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 11:09:37 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 4 Mar 2026
 11:09:37 +0000
Message-ID: <f6904ce4-ad85-4d5a-9d0b-825401954005@oracle.com>
Date: Wed, 4 Mar 2026 11:09:33 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
 <775dd360-ea41-4e27-9690-e0633e0522d7@linux.ibm.com>
 <f9fb6d73-9b90-4c11-ae1f-3f2e76773d7f@oracle.com>
 <bb4df6e1-cd83-4a73-af67-f83c543d6e6c@linux.ibm.com>
 <bfd8c2c2-65f7-44f0-a4ec-01158e249505@oracle.com>
 <02288590-486e-4243-8352-c756c6879629@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <02288590-486e-4243-8352-c756c6879629@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0166.eurprd04.prod.outlook.com
 (2603:10a6:10:2b0::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ0PR10MB5615:EE_
X-MS-Office365-Filtering-Correlation-Id: bb44f1c9-fb71-4708-a5f8-08de79de85df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	JB7EwJJRG8TU/dx6d6agcJZE21qajDC2g5+BGrI+et2vB3pm79o1y+YJtRTYZPnUzmb9zd33dKKQa7aSpUNVicNNllnjw/9GsjgUUs/cZqHsfrCwy6Y+R43EhhSUXlUUZ9pFH0fsj28SvBHUdwojbJjhGHGNTLexjwfVMWlaGzNgLDbDpOoyDtXSF4T4uCl0wtw0cZgO4Loj9pnbqYdZZhxwbulH4JP0h/Hn63zQP+9LMQuJOF2ERiFo0UePvxEhwdd6xrSNJQVrEmDVI10EKofqrLfPxcHm8YXBamK9JcZ7j20g/otKITPxhEb9LfPZwa8cWSPy1ozXGHAToSJG1wDbOdbdQeHSViM/P3DYQahfHNZp5VsMD0FEfdg2uOMQNS8xux0iFMbL+SzsWI4SY4TTtk1Hqxwpx1aUYPYBdtuj1Ak7Zmcc5ns1k4UEoG3PBHtOooPEVNZC1OL77MnqTfKxqnNrQ1qEsxnSrNDxabmOFwFWX4sGOWgx93NgSg7y4kKWEHD+eu4kBnVB5py2tK7JuHBF0HKYVMEEhs+BXWk+ZdCWU5W6roMODHv70y2iJWgmOZMpPGXD7fxzqIpBu03jKtYOOf2yW39eiJ4nYDAKf4E/6DV5K62KuawRhkRIh9PEwN27uGs+IrX3Kw63F23MbuPgi3DLnwrVEitnIwqS+zj3zOr4oeJuOtYqTd4ipv7hxeh1eFSg1v/0c9sHPocznJKO4Ds17qsoEei4csI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG5QUjhWMnF3OERuU2dqb0U0WDZxa1hNYTRBTms1aTNLbmJBK1cwa2toRnJj?=
 =?utf-8?B?aG5EU0hVRTNiV1I4WVdodUs1YWppVFBNS1hPTVE3bnpkb2ZoSlRKZlJydk5s?=
 =?utf-8?B?UUhBQ0VKZjR4eFBMU0dNa25kMWtXR2hnQ2ZrL1Qxc1dnekw2a2hYdmR1MU9i?=
 =?utf-8?B?dTJBbXFxR1BZbHVGNk91RUo2QTZ0RTRKYmo5VXpjQllVWm5SeVdxanFyOWVT?=
 =?utf-8?B?cVZVaHd4VS9lZWVPY3E5QTJDVzVJeXhuNnQ3b3J3OWxnY2dvb3g2SzJsaHVp?=
 =?utf-8?B?QmljeFk1NUVEY1RQdzBtWFNvc2U5dUZUVEgySHVwRFh3M3Z3WDhNaDVBSGVa?=
 =?utf-8?B?QS81a2VTRXFTVjlkZS8vbFY2R3NrT3p4bkhuM3pscGJUZ0d2Sk5QZURRV2pO?=
 =?utf-8?B?ZHRCSUlXNEp6NE9VZUNVL2doeVowTHVmTnh5bGZvL25WNkVRemNnbm1tK0ZB?=
 =?utf-8?B?WjBNaDBLNlJjQ2FaTWkrS1ltMWJveURyZzkrS21QWVRJVDUwTTR2Uy9KRkh2?=
 =?utf-8?B?NVFCdE84Qk9VWDlPREhHazZpUjBKb0VpcWcraGdzb1RwdndxRU5Lb2E2d0dB?=
 =?utf-8?B?d2hYTlloM0g5eHhXeW9DbWtCN0Rwdy9MZ3UzbjZlQWk1S2NaZVpjbEExTGlP?=
 =?utf-8?B?alVrd05aNWljQUdHRGUyZmNxL004czEzYnBJYzZGTGRObUtwUzl5R3pIemlX?=
 =?utf-8?B?VXRQMGhyTHBSK29xU01LSDYzVElDUFQ1dFV3SzZXVFh0bm5sc0tsc1V5bVp3?=
 =?utf-8?B?QTBnZTI4RlZDcHJuUzNQZ0dERkZDRzh5UXBBczJvRTQ1OHNzQndHdTNPWUIx?=
 =?utf-8?B?MklxY1JwaitRdGR5OENMMjZIOWVlcmwzU0JqS1V0dDYwMnFKWkpUNHgxcXNF?=
 =?utf-8?B?NWRzVEo0WTVCRnR1aGU4MUd4bGFFUVpiSWo1Q0dhQXdPb3BPeDhDN0ljeVRk?=
 =?utf-8?B?cmM2UENkYzlwa1hQRFJFT0RNcjZ0U0RHOTZHeVhVTExvNHRpaks2Q2JKcVFY?=
 =?utf-8?B?SWZuakN1M21WVmpyclZRQ3FJanZjQkxvUWtyYXBTU2VBRDdFL1U4ZExHL3o3?=
 =?utf-8?B?cEVGZUpoOXo1T3ZFWkcvMTE5Qm9WbVBFRmRQbkxRbVhwRlRseTRYRkNydHNV?=
 =?utf-8?B?WWVjYVR6VVpsMGFrT0U5WkhKd3BlbktuQVV0akxjTXdMQ0tVM1FoQ1Bvellv?=
 =?utf-8?B?bGpQVmErVnpPOUVjZHZpSmhDcUxrWFlzREUzc0FGOWpNKzZSdDNya2Q4dXpX?=
 =?utf-8?B?MlU4UG1TQXFmc292SFJjeWszR1paWkJrSVFZc08ybUQrOEJYSk4wa2ZwSGZH?=
 =?utf-8?B?cmdleWRweTFpejcrdTl3WFU3c3kwdTd2alRpOWtyTVFIeVBCVjhFS1d5RStG?=
 =?utf-8?B?ZGN5TjhPdjkyektEVTJ1ZnJnaGdHUytFNDdWNStqZDd3NjhnVVFFVVRtbWt4?=
 =?utf-8?B?b2U1NFcxZjBxZGREU0tidFkzTjUrTmlpMFAwclZodTFsQ2prOG4rL2xVU1dO?=
 =?utf-8?B?bHZWMm0veFdXbXE4L3FYZXZ4KzlCSnhHcFhnWnd5bGx0cWhlVkllVmdDOENC?=
 =?utf-8?B?amtCekFKQXduZTJ2OVl0UlhkemVFV2VxMkw2T0EyS3BrQ2NLSUErZjRwTmpZ?=
 =?utf-8?B?SmQreGwra0xQcTJvbytXalpuYWpJaGlqYStsaFRIOXBkVFpvNFlQVjVhQ1p0?=
 =?utf-8?B?dVVqaDhJZTI3SkYrTjEwTUlBK3FHemZjODYrSjdRSm44azAwbjA0SThOR3dI?=
 =?utf-8?B?VlQ2U1JOdWZwV3ZDeXF2YzdIZzhXcFhaeXRwbm1tQkNNZW13SXpXUmc1VTRn?=
 =?utf-8?B?TmVoaTBDREpZaGF2WmI4MjNMUC9DRkNoUHU1OWxUOTJ4b3BVK1ZYWmMyZHBx?=
 =?utf-8?B?cUhZTHBtUXE1SVgyTFY4aDlObWJCc29wMzAyY3VDNGgrL2J6VGU0RVc4dGZQ?=
 =?utf-8?B?VHRNM0xOM2VPTU8xaVplcEpjUDNhSW1zZllsOGFiejdBNmF3dHlNczJINmZm?=
 =?utf-8?B?aHVEc0k4cnJuNlNReFlvdGZlTVVZNFRxdWdZelZjQmV4RWllK3BrdWFBUjkx?=
 =?utf-8?B?dkUvUFRHR3FZZ084Yjlnc1k3ZHVsSGNLMmQ1WkhWWmo4Rk1sTVJzdzZaUUhQ?=
 =?utf-8?B?aEErWlJ4OEVWWW96UVFIbkpSUUVBVWs5L0pxdDRMaEcxQ3FzUUFnUDJPQ096?=
 =?utf-8?B?ZWc5dU8xSys3QUdESnViZXNsWk5iM3RtYXdMWmthSFYyVmFmRzgrQ2VHSzFK?=
 =?utf-8?B?Y2puWm9xTDRYSEk5a2JMcUFxdjVScFBoYTgwb08xWTVEdnNQb3VlUjl2YTY2?=
 =?utf-8?B?U2xKeE1yZ09lZUlVSlF6VVpxY254SjVYeEl4N3EzbjkrWG9OWWpmdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	44moI8FYexfJHePlP3/KiBZz3/QeJzs86bKKisYJg5P5LAmi7+7Z+N7yt/pGvbT3DvHWCQzo0ZAm+Zq7ZhMWWNkah7/jUC+/r3YCJ3HfMOSWJHNvvua+T+jfcNSt8dEObrXz+AKCDFMJCJg2ZZiCyrnVCs50Z5jwEhlrtnV37Gn0wmEMDIcQInBoTuKA/48UAuyve7SvHdQUAwILuhJ0UgblZfqtQLWSBEr3o/R/fO0Z8ul6Lk1JZV0fLwcPSiJcI5XohYmJFWzp9CucP3Y/ds3FjMsJNRHWFkHiFidYgPJTM21x0mL4Z/L5pR8qIVquhy60MYi5erASsq9sB3sHuKNIb2TkE2FPkNYllZHTTafUOtPGOXUIjiSXVyVpt03ihSjgUa9GgPRvhNP41RplneNGgIoctothAi4n35IhQY3vTMGWLSmiTXDTdquKdUDw+6PuLRTJDGrk6nEdQAhdgPePpeq+Io6kh+WNgH/us+ICgRJZhhmrfwqwHDBVMXW73OYSGhYqs6Mg/+vaIf6FzGWHbRFDmEA68dr3GJ/pzWpHVAhLTGKBWebKv/pU4R/dqIea4eq5H4X6Eb3jqvVLSPXQhclHDFT6PXKOzXesfCQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb44f1c9-fb71-4708-a5f8-08de79de85df
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 11:09:37.1205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIXQw3IAPVY7yyQ/Clgwp9N1nAesSAQiSj4UW9FAn1bLBgxC4R11Htw9f5fjhzAuN56kpEfuqxTi5uoap8iaBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=955 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040087
X-Proofpoint-ORIG-GUID: cHcPfK0Y9STVVjIekTp0F-XzB2GXQd4j
X-Authority-Analysis: v=2.4 cv=Pp2ergM3 c=1 sm=1 tr=0 ts=69a812f9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=Ox4tpwnkimX-lmn1Y-oA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12267
X-Proofpoint-GUID: cHcPfK0Y9STVVjIekTp0F-XzB2GXQd4j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA4NyBTYWx0ZWRfX+Y5m0yq6HYaZ
 ovdVQOjAE997Iiv7ehmjn7+8q9ljL2vb5BTOViUfReVsM90YS2jDZs33MQGD5xWnOAqc7Gd8Asf
 Oynw0HAx6QdInk/ta4ICdFG+5R+jc9FmnFtEQdQt/MB6yPNBKXedxofUkUNBKe5pUwCYoqSoZuw
 P4XIOWuyF/C9Js2ouL0SqTlRJfu0Aa9WTsirQYqjK35o2NbyTqo+CDf9YEBp9hFU5NsXgiffl/j
 6d1ON0IsFc95sP85lPTxRJHc1gUECBrp2EnSChgNfHxQYH4wVtxvAhoLqUYNzsi9A6PuN/kB98z
 FhRXn400Zt3aaM9PHoaNIDIIfygv19lK1SGUr6QKJQMTUvYWuY+OG7fO+nybnPH2MOnTsa2PmvH
 rZMRjkkIvWGhSEUY5nIdRwjtL5rv4p8U5EiXM1tzxdepu8PTq7fPzz/1ajjqsXmKsgl39X0BHpV
 qYTk26Ij6znmYTLUWX33iqiUSCo71qGVkv7qzATQ=

On 04/03/2026 10:26, Nilay Shroff wrote:
>>
>> I think so, but we will need scsi to maintain such a count internally 
>> to support this policy. And for NVMe we will need some abstraction to 
>> lookup the per-controller QD for a mpath_device.
>>
> This raises another question regarding the current framework. From what 
> I can see, all NVMe multipath I/O policies are currently supported for 
> SCSI as well. Going forward, if we introduce a new I/O policy for NVMe 
> that does not make sense for SCSI, how can we ensure that the new policy 
> is supported only for NVMe and not for SCSI? Conversely, we may also 
> want to introduce a policy that is relevant only for SCSI but not for NVMe.
> 
> With the current framework, it seems difficult to restrict a policy to a 
> specific transport. It appears that all policies are implicitly shared 
> between NVMe and SCSI.
> 
> Would it make sense to introduce some abstraction for I/O policies in 
> the framework so that a given policy can be implemented and exposed only 
> for the relevant transport (e.g., NVMe-only or SCSI-only), rather than 
> requiring it to be supported by both?

I think that we can cross that bridge if it ever happens. It should not 
be too difficult to allow a driver to specify which policies are 
supported/unsupported and the lib can take care of management of that.

Thanks,
John


