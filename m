Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856603A0B2C;
	Thu, 26 Feb 2026 09:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772098001; cv=fail; b=VecY3ufMhiHILWiVhwNIqxufAE4/r7KC3IIuRX9BUdNDBfXVB6FHcJcv2DBuPe24TZ54lVhWBquhh8ceQpSfm8sgX5Fo2vmPKvhQH09rRk3oNwDP4JL8awaTAEB02L1KgJ7q+a8Kn+wMIj0e0cXJKJXeosaenVdxzaiySzD4fUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772098001; c=relaxed/simple;
	bh=dl7MEJlxuc+jfrMUiT5nG0WhB9x8YIfHBKgoLJNLPJ0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DSJwwJZekxNtXyaXHYrmm73vHgTzKDsOQ02iVjFEgwPBqUELLDDs+9XWlNB7SlFlZdsw8rHSgStbL/kAhTPgX4dEORUCAIOsDg8sVNo2CTLq91WCOn8W27WWdrjDsSFzoF+sOsX8nGZ6J5FQ1Yi/OvbRwN7dg/J6JrEfAaTqIcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h9Ay7thV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wQcIbVil; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h9Ay7thV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wQcIbVil"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q5w1uR3656078;
	Thu, 26 Feb 2026 09:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5jqN3NUSuGyjbdvJvzOMW25AKtr01das9QlikoOw2SU=; b=
	h9Ay7thV71iwV1cPtqvvsTpsqKOnZUqvtX0u6VyWEkThP0bMudpjrGr6nfr5+xTu
	zXdyZT9w/r42SslaDk1zaw7YqYGeZFG/4Whi0/YwMpKLlzt2B8ekDm3bFgeSUkzH
	S9HNAmqrmyqjJ2EIFcm6cnydvy6z9DVAC7Va2t/VQDBGSdY3ZFUU4SJ5ytshMAVj
	05YJ4s+y7Nq5C/xf88e1ZxuiAJER5Ris5vq+DeA5jE+tIQRZXtl1Opyln1EBP0fo
	CYSdwncnGWdMT7Wx9TQonKwp1zj/gf/dZa3aqJuzan0fTJLTW8r8q6aoVkB5TM/t
	Gv0U4Q7adQtf8LAUYw9Pyg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cjgg3r81u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 09:26:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61Q7Bvpb028514;
	Thu, 26 Feb 2026 09:26:10 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35c826y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 09:26:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KUusPXcxd4nEpOT69a6f8MC9hFusWnCJdBvMFLDDSw8Iwb5lxDoS5Z11t15g0UR685khZeIpXqJ7dIxDMThINtkYmFN7VG7WWo4L6I/lHb089m2N1Uu6Ay0eeEGlyq+Kvozg49mXLb2pM+nTDnclHHBIrbcZ3B1SIkQELZpWjwh/1VX2s/tEUGDpIYvghaHT/WaQuG0p0mAdPwtWuHMn2Ji+1mEL1+2I46G+Qkcrk/XwMHLGaunnriCDMVafS5teOWEDLO5uRBhPmEFL7LBw3Y1Ifv7wGCvbMckDlYiX9X0iKdk/uF+cEMkdZw52lpAs4IKDOsx2IN7TyNdPaKiJTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jqN3NUSuGyjbdvJvzOMW25AKtr01das9QlikoOw2SU=;
 b=jdWJGBLm+C+IInhSRgzquqKiGFgawHvOKLTid6Gtg5gl3o7r59Q2i629dCPlfIvQoJKN09YqumEuyOXY3uI8SjIJ2RO7IQy7humRnwxvGQPPKd8sxvLWEcunZ4xEqGY5qMVvghDp7nYfJqwiuIepwZcVK5tl5VBPY9ZYHchttmOta7xG5KCEYot4JA4un32AVbueK7feDBC63dqhEGp7Fbmn4rAI4MQebhoidrq4uqFAt184HRy+HOY6S/qfBVhCSOPwl5s5NWd8yMbCx9kcKtLe4XDG6W/6Ivq/fRYDowKO9amW2WyMAYB9g2OwSigAtKoVmJOb2KteqEzfpwY73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jqN3NUSuGyjbdvJvzOMW25AKtr01das9QlikoOw2SU=;
 b=wQcIbVilYsEWPGBbaolUQPW7xJ5+osiKmERjrPFgUPKZ/6OkNrVi1MQjut2Wv+REPxAzD7/rTP3P1QV3a8w2QHIkoTThcgYZjZT+CbcVZoq9qFhzzGTBUa0E+Jr1UBmalNo2AHJrcUvLote9oUvJW7zcuCsEwFr6KeOFC5a5T7o=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH3PR10MB7496.namprd10.prod.outlook.com
 (2603:10b6:610:164::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 09:26:06 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 09:26:06 +0000
Message-ID: <4a23e863-2ec5-4a63-a345-a83f0f8ba81c@oracle.com>
Date: Thu, 26 Feb 2026 09:26:02 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
 <aZ-_3_hXEkFEClhs@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aZ-_3_hXEkFEClhs@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH3PR10MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: cede9d16-4ecf-4c15-8c38-08de751911d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	VGgphHjPB8yjvaKzi5sNijxSkny0xe3wpGwUl2tMTK0dgdU4CeUiZJZfOUTX0kRr4yLUyFndp1+kWHrBpCyUn5CznQd65kPLqFNM5ny0M3g+NdQJiEkWg3KksYHYAawlFyaCM3RyGa85PgyBmy1ztOqgav0bu7RIW3s7gfQw7ZKQPYgPd58IxRdP5+O74oVGzEVKUCiIVafuDBOzjDFVwEcjJfGip6aRWm+kg5HJ5SaY180sMeTMEH2nrWgMbHS1kk7ngYQXjbq5LNs3e6AV3oeejeGP5r3iKcM0C2K9fxhVWqSP7QHzffjn7tHA4Gadu6vcUS12tCjWvhqGoL/gai+igDFEHVud4koh9xzaj883X+5NDcixigNa6YYyHrVXNzY7wl8ioNbgXbxIRIvHuu3D8mxE4CGDJabgb68jvYNlLtWW+De8t6A7TruJlsmx1CtXapYpLpnkjsTsNcfeMiXbA51TQJaPaC7EEIPu01yB7gTtMyqiMgoBgJ0C28R+/Y0uG826i2dmv1xrf4fL7+SCmtD+rCYjkPBMB9vLqxS0HcyiwbQpizEFSKSFs2w7+ZYqsD314O5PERkbxTxtNRsGumxzs3ZSj9e2LyQwpIBq6vxpYEX57HJ15IISdqy++Spq0Uoj4PcsxCCKKS0gyMUD6XAnuuJyce1GZuaw3DJ91YwT2FcXo2tTrqi4Nnmh9eRwz0yfikuL3lLWcN1zQoqB5IbZSgGosSALLRqwV9o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZklQT2lqazNxaDZJVzBnK01JVm40S1RWZWRPMkVRQmh2K0l0UjBnd0JsNHh6?=
 =?utf-8?B?SHltRkV5ZzRVVU9oWWRpWlpsNWJKWER0MElSdzlTekptaUd1eVJHWXJxZDc2?=
 =?utf-8?B?eEZDdmdzbGlUTmJFZ1cycGJ5a2E0RnhpSzRiTm5oTjNjTkRtVVloL3Zqdnkw?=
 =?utf-8?B?MDM2OGI3NXQ0UVhLTGQxQzhsaXBmZGlncXhSeE9OMEU3bXJIaHNHa3FQSGxz?=
 =?utf-8?B?VnV3aXhYS2VweW9UMm1FZEZjQmoyY3hCOEgvRU4rQW9iZ3c2aEw0cFVxWitY?=
 =?utf-8?B?QWhVWDhMYVJxdVVWbnpwWUFOSFdUMjNnaWdFMG9RWGl4UEZJMmx4V20xVGpI?=
 =?utf-8?B?QkdpVVlOS2p1ZUVBaWtiZU5yVnpWNHRremp3ZUJFcFFETkJGZzV6eGFXTlRl?=
 =?utf-8?B?Z0xhRzRMQVBBRGpncW9WL1p2ZmJpMWcvd2ZqQ3NnN2NXZzFFRnJBZ3hSamZY?=
 =?utf-8?B?K2N6UDZ3NEpXZDFPbEhIaG84aCtUMlh2UFJpU3VDeUs2aENHNWwwZjBmWW9O?=
 =?utf-8?B?YnVhYUZRMDRROEVXUkt3dk5ZMmlZemp4MExEL1hTcU5JTVluY3VMVUJaL2lC?=
 =?utf-8?B?eGlBaXZ3a3hDQmNuanE2M2xPSDdIVkRONUtLeE9xRmhTSzY3YUNsbnF0aDVH?=
 =?utf-8?B?VExHK0VPQlNZMnpMSklCU0FrcEs1bVNqVnd4OUhpNEsydVFKQWpadjlKWlh3?=
 =?utf-8?B?OUpWaHlKc2d6WUNCKzBJajg3MjQrOTlqdnFzUG9tNW91d1haL01yTkk3RW5t?=
 =?utf-8?B?SG9KeUp5UVYxSU1TSjU3TzJCV0hkVXpDa1JmNUp3NmM3OWh0TzAxdzc1cHJu?=
 =?utf-8?B?bXpaK1AxVUxSQ051cUN0WCsyWmYwUjM2eHJRbDhjc1hEU2NqTVVvSEJobXBo?=
 =?utf-8?B?dGk2UjdJYUp1Nmc4dlk4b1ZyR080ZXNVejRWSHJzZC9ITnB5WXk4UjF4L05R?=
 =?utf-8?B?bXBwRnI2RUVnSGR0dE1QOXhXOHkyME9MNElvMXZVS0RNME5HUnVRbGYzeXlE?=
 =?utf-8?B?NDY5SjA4QkYza1EvMzRYa0lQQ0Q5M1JxTkZRb1ZWVVMyRlMwVXB6d1ZUMEF2?=
 =?utf-8?B?NWN3dTNKaUNKTnRBS3ZIN09qOGRkeTlKVWErT2taUGQrMmxmMy9KN3hkcCtQ?=
 =?utf-8?B?TmRXSXFLOFNYSllqU3FYZlNtTGluYk5NOGMvT3JNK0Z1cXM2NXhyemdSNWpm?=
 =?utf-8?B?RDYwRnVOWWxlZko5b3EzMkdCTlNYUmxreVdIZnR2cjZsK3ltTmQxY0VxRURZ?=
 =?utf-8?B?cFNCeVNJZCtSN1dwOGZoU2VXWFJNYkVXeld4dk1URXppMlNFY3UvQVVReW5p?=
 =?utf-8?B?WTZLVTFDNkhOSXNJdnNBL0RGWFFvZzNmcE9lZG1IaEw5dkNOWmZWMGxPbFR3?=
 =?utf-8?B?ODF0TGhwalc0ZEJHaGFGc3lIanh5M1c1OWxHZXd2K2NiRDFQWHRGR0JEZTVH?=
 =?utf-8?B?SEVDMGNjTnJ5T1F6bW5WZGo5MjZlL1ZLSVhRMlZKTXlWVHl2QzhBSWxVNGE1?=
 =?utf-8?B?N0VmbXhNZDFKb1JDWGFBUE1MVEhocmIxSXZPYkJXNURiRUpNWXk1Y3E4Q2ZX?=
 =?utf-8?B?NzM3ZmUyT0pRVFNhMHVwVTQzYzFQNnBqdGhvRUk3U1Q2VmttdmpYbklpL0Zp?=
 =?utf-8?B?Z2ZFamRUYy9nUnNIOVJTUjV0UHNzZk05QmlITWNVejNhNkxOdzJFVVlmY29j?=
 =?utf-8?B?TzhFV2ZrTytrL29MOTZRWGJaQWEyNkFGQkppVllBRFZJMzRyOURRazRIUXpV?=
 =?utf-8?B?eDFRUVd4dUlBTjJnYXJzTWc5aDNORkh4T3NEQmp1Z3h3azhtblJaL3ZqbmVu?=
 =?utf-8?B?RmN4VFBQZ2FkRHlCT201dzRWNzdJZ1dETzdxVlFQUVdYL1VTbG5LT1oveElh?=
 =?utf-8?B?aFRDd0Y5dkRsR0hBamY3REJwb2VPZlpBUDAzUHRwREFtU25uTGtUM2N3aWpN?=
 =?utf-8?B?QnJmY3N2OHN5SGZoMW04dis0amFFTU5SNlFwNWwySnZCLzIwMVh2TWlVR3Nh?=
 =?utf-8?B?UURKcHkzSnpIT21tcXY5U2IydXFhRTJhZWQ5b3dLTUpvMUYzYlNZenNFV1hm?=
 =?utf-8?B?cGxoYzlPRzUwOW9Mb1RLd1pobEpQUi9MN0lRK2VVREpiUHlFd2RLWTB6eVVW?=
 =?utf-8?B?amkyQXdaMHBLRVhPT0N0Q1NnUmtOd0svR0p1ZGRyQnJTV3E1dmdNdWlBa3pI?=
 =?utf-8?B?dG1DaGVxYldjZ2hwZTlETXFXdTFOZXZHNmtqSzNHVTVFTXl2N3U0NnZ1Z1J3?=
 =?utf-8?B?QVRrUW1Bd1pKZVFnSHZmbFFMRTJtRThZYTdhMlNmck4walE4c2haZ3Q3R1o5?=
 =?utf-8?B?ZzMvaDdVdkgvai9TOWFBYkJRZGhZZVlodHlSdnZpU2F3R3FqaGw0cnBQYURj?=
 =?utf-8?Q?VcaqU4pFcRp07J+I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AvEUkz6QIFuJOCXTPRg3kzh7pNMibZ4oc7RblFvlmbetTTK/Yc6ozpgpdOiHDKhhN5vm4xQTjP7HjTEtEqSNfiA7xuM7N9qIpshfEvcgrQ6R6LPQF/dN/G6kUo7dqKPiDAF4L5cB0tmLn2c/PFMukxD+vP/91XRvk1A5LARTCFDNpjVQprssyv8k859ycPIHT4M/hMsznGXrddoITJWaR/muAky5I2y8Px271RopIgUkYP8eF2sp1ONZpwFbyEEeCGaK0cctVMazDAZeA6SIFfYq88mUqtTObHs4SRila3zozZ0HoKD0Cgox7EGE6v3AfpL2XYcr5cYqhtvMpzaObUEhICvsMvNLOxtdVdDOjlIjzC2gp2Ippdd8nJc3FhQVHQrQo6M9xZ2hd7Emq/AcUtM2Foz/IRH85R57eDPiXM1Va/H5CSj5ZGopUQslAWvEqKqZ1C+gphy3w1WCkoOMJx5N4mcP8cFoZdKu8pdXojBahsQs2d0xcANhESo4DNxsY9MZSrcvXsc8kJwtlOwpKnwn8RLlIUQtol+TyVCSZWXNhP9a5MT2PG0A2gsYtsuCjIzxKXpHSQePStK3ByQKgXOCYFwXCWttVaMKUagSHC4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cede9d16-4ecf-4c15-8c38-08de751911d1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 09:26:06.7946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AthtTTc/SOYl+YLyNLj1gHtxddTLVX6nSduJIo+lB9BByoToYjGDln5w+16CUSgfn8uyZyPckAs5IaBuM8y9iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602260084
X-Authority-Analysis: v=2.4 cv=XZqEDY55 c=1 sm=1 tr=0 ts=69a011b2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=vLsSOtk62a251-r6yIYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0UB-TAu_iHEV6GaWGzgSsQOP-HNlDS9p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA4NCBTYWx0ZWRfX70z33C1IJgOj
 sN4bMDeEtdiWjZT16IMIC2rRGG+i2ibLK8PO1kqfAeCBFSAUUuI8OKnxrUeML6eQdQCAShpiYHR
 R45niZEhjdampX8LRNDs2YfrvcxgaR1U0oBXtwdWKmtQ3cmO8fSgUGjYWBCDTdHs98yq31+x8eh
 uImQs91LljN9jlG/EZFVXejGwfgzEVmUmxcqh2875f7x4vgKIMhVs2FOQ0gP66c6xRqUAs0JD6W
 ARlDUk/aZsVIZpYj8m5vuQzcMBZjgRabKkHZT1b+DKGl7i8g+X0sjuB9Ru8XfsburIghyvMNS+H
 FTtbxEPmFiP5T5tIYqdyQ5zrT9ofO+SGCZBj0HeuILyZunOAhNzqZsnkGHyNMdL7yd9cuSm3wto
 nTkkl0so8iGgf/cGXPJtilR6fyOw1kNrUrT72Fc40U27LM4I++PbDOYBiTQxyYud4huz/VeiDpi
 stlvXRVFDf2kCpWhMKg==
X-Proofpoint-ORIG-GUID: 0UB-TAu_iHEV6GaWGzgSsQOP-HNlDS9p

On 26/02/2026 03:37, Benjamin Marzinski wrote:
> On Wed, Feb 25, 2026 at 03:32:15PM +0000, John Garry wrote:
>> +__maybe_unused
>> +static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
>> +{
>> +	enum mpath_iopolicy_e iopolicy =
>> +			mpath_head->mpdt->get_iopolicy(mpath_head);
>> +
>> +	switch (iopolicy) {
>> +	case MPATH_IOPOLICY_QD:
>> +		return mpath_queue_depth_path(mpath_head);
>> +	case MPATH_IOPOLICY_RR:
>> +		return mpath_round_robin_path(mpath_head, iopolicy);
>> +	default:
>> +		return mpath_numa_path(mpath_head, iopolicy);
> When we're in mpath_round_robin_path() and mpath_numa_path(), we know the
> iopolicy, so we don't really need to pass it in.

Sure, I don't need to pass that around.

Thanks!
