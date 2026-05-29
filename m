Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DA73E51FE;
	Fri, 29 May 2026 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780063790; cv=fail; b=G4C9uML+jAx8LTgpwj9LyUCY4tFR8SdU2PkdQDmDJO+/WE6F2cw7N3lTz87cOnE4cHslC6SMfCSDwI1c+eoGEDh++9jCcX1zTlEARJ8FjEv5QH+lnv0STw4vJLasohYxkrSJmKdQ2L5GbOv5k/0jrn6pJ2x382cKr6VKf9Q/0TA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780063790; c=relaxed/simple;
	bh=S29i8eqYkSypR3knf/+/K9frhC9YwtjF/HpNQi9OhiY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bDy4o/Lin8uGB8hVUsFfuz6E5RbIQ5L9hChYy1yd7LKrmFoOjKRNNuSyMcdeM+zDZW2FTzFez9TBBLT0ndJUQ3FBSN/JaFvtFfRUblhA/+/x948nOQViDktVJltpK5PMWsODCGRNPCe7nxFv289T170MUrzRqOBD6KX8MB7t27s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D6TVjJLa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j17+CIdZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D6TVjJLa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j17+CIdZ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64T6feIt986485;
	Fri, 29 May 2026 14:09:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FBvNe69VB+OvwMpbcHqeVcU7sU0hcHK3o4Y4Lw1Fnvg=; b=
	D6TVjJLa0HkJc6FVXmIE2qp5kcUTqsYhEhoHMtlCA1uDvzwBl7Zv9mwVWVoFtl+B
	ry6Bva+jWCm22SZeYudtHLkeWHdCY6UrTotv9TTRK13jjEsCFgv0rKAcejlfG5Tn
	UIBANy35/H6ylgzZyuX+UVPenkE5BgqWWdgY6+dDc7wkmdFSGLGBfcNl22vL+g/S
	MzzzBdvcCg4bedMPOn+/Z7ntc5TWJp7xL1y7D2R7b9bJTN5SWO/SHGkDfT3nzofW
	Tlen6xbijtGEGdhxr7AeVlSjHQw2gUstGhe+6tfaASAjNGSfHlOBBCc/M99dem2R
	ihMvylziWiILyPAawSnGqQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ee7wpas76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 May 2026 14:09:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64TE0PHF013387;
	Fri, 29 May 2026 14:09:12 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4edjshcqsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 May 2026 14:09:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gniIfmZ2iNowKmMNRMbnkBD1jBS4xMRsrgmtZgjUkhOv0Kr/QytHZB+B/IqOQ5bEnM3581zANoOxmw7H7fzRO8CJL8V0zgpLNFd3Ud0hsmwmbTAnvhMgf5sdOSNCXPuWiHFFm80gdvahNJPsMNNyhI0t1EOdVObfaUdoLCQsG+Zv1T5BglPha8M4s+iUIHdd6DKZTggkzWDLVpv2Y5qjzE82z0LtimJ0eP9AODknfxoSYZCUU3CbpXAv/B60f01x/sFwuIEfz3hS/x6kM55bXFyWv9s3ZbJcejc3YxH+8iDEu7oIZ0sRjTXPnztplGifylN2OdCJS1xfxOOEvEK9Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBvNe69VB+OvwMpbcHqeVcU7sU0hcHK3o4Y4Lw1Fnvg=;
 b=XBt5x3nrw82dQuLbeTGrGV1kEgyEZO1s185btI8wiVdplut62dGBWHB+1XIUDlmE27RaOujZ8c3WyfLgHGkjJq0q9qS80QTvOYHEmDK5CvTYe9/VlSq3FBOfEwzy2NuAeQHHJElLmQrMU1JkONYw4qFox3LZCXM2ueftYh55XoNMBOTN7mkaWmdb7gUL5OrwKOgb/Sx88E5KIZWH1UHRjLuXdTEH/HGv6ouqOZxrnBwG1ni9udb7a21xMnG/NSrxauhOYzpoGg5ku8lwYmu2WhrxSbqMuxMdOSgf1n9BaEplQ/wBM8enOLCLzrRhnaIQYWf1KvWHFWp94txHfIx3dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBvNe69VB+OvwMpbcHqeVcU7sU0hcHK3o4Y4Lw1Fnvg=;
 b=j17+CIdZNQIlQrh4WcZ49hppkrDwPeKx0MOcwAza92QnihxDScUrtIqL6XB4LIjJtQvlYo3c1SVo/NSD44OadtWWfVc/Fncz8lhkGWVroFTk7cmNGte5w9Jzw5ceLdwSyQqd6eeVae63g3bTVtiry6/zoCxL5vbtzUvcKmmVxAA=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8183.namprd10.prod.outlook.com
 (2603:10b6:806:444::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Fri, 29 May
 2026 14:09:07 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 14:09:07 +0000
Message-ID: <cd70e2a4-91e1-4237-bdd0-7568b2dbdc9f@oracle.com>
Date: Fri, 29 May 2026 15:09:03 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260526015418.2022398-1-yangxingui@huawei.com>
 <20260526015418.2022398-3-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260526015418.2022398-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8183:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d02ec55-4862-4379-10a4-08debd8bd8d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|6133799003|4143699003|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kKKlDmtVvTiB9wmtjPAjTCMzdEyT4RJNGk/0pV7ZkRh34Anvc1IQ9FBm2fXv8sRSfsglMBmZgKplzyrr9QXEFoe0knhWe18cD9tXhKXkR8U4+V8CXqKlCTrrWPZHHRp9uAhJMQzKkDIyIyvio6zMgAdzNThe5cBCp5bkc1i3q3BQGnh0Ne34YB5t4MSNaSWC1XLaoO8/WDbi5T3kOUVxaXQUZIvRYomi9Dk8/o5WCTupXZsveyZl1Vd5WnBFLO5ORh4fTFhwT5i4FdWEdX6zl/qvzUKz0DOpjCcCUBt5cUP5yTbDjycYrgshF0RfEkKofeo96sVBl3jYUQcA9+Ii9FOdbyWJ6AMo4OGan/hzXAaTvfmrh5qHyaUSHj61NQHTHzAHbGmUKvGrC/QNkqtQgRd5C6K7zsCAvgGeG8aFkaMi0x9doPdWt96nj+hC77FRttDPUnH3MedKmmtXnRcpHgaUzhe2iltepMHfufQCus/DrzCXVB/zOZzepowy1w3aAycgmhVV7L4cztCg+V6VFhEyoXqVQaQqdiGvndKE/RBwxSsWuuWE3LFlTlSXFtoyJCoVwaJITN7Ff8+Nq9Gj1QOjMgXF0cpDKXAwm02yvGYcybFC8KIGUAZ62BK8nTfh2fHU0kPP7HJX924VkovAfmbmHQZr44jEjm1dnX4Q/DoVcfCP/wzIuyu24Q/aNSs1f6+fdRFIu9mTI+8MVO1Cvw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(6133799003)(4143699003)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFJuK2dBTmtMNzJDUEg3SlF6SUZjVktrUVE3c083Mmp3dUh6SFpwM0VHTUxU?=
 =?utf-8?B?aWpYK2R1OFl4OU5sK0trbm5UaTlMMFAxNXdVWjc5SXVnVVArNGJUdFE3bEdq?=
 =?utf-8?B?eXpJNDJreWpjVzlZeDUyS0lFMk9aWDlJamc3ZUp5Wmd5TXVlUnNBZFE1U1Bo?=
 =?utf-8?B?ay9PMm5oQXgwdHpCcWFlRWc0R1Vzdm13RU1sRi9SZG5CM3U2V2kramNCWTRJ?=
 =?utf-8?B?Snd3VlljanhEbXdWbHUydkM2RTJtVERFMWNXUUR2cDhzTnFsdHZnTnY0T1Qz?=
 =?utf-8?B?clBrbE4yQlVwSVloUjJiVUFEeUtEblM5WlNmZFhHOEFISVluc1RZK2JBMFU5?=
 =?utf-8?B?aFRzcGFKTXVqRzhLeitRa21RUVM3bFZlZG80REhvYzJBVVRYTWhGN3F1VFdH?=
 =?utf-8?B?aWd4VDZNRG9SV05MdDVCRHQycEM3N2d2L1FxOS9jYXRSaGJvcW9CN1IvZFRj?=
 =?utf-8?B?Rk1yUWVCWnh5cE1zVVhQa28yUG14ampUalBrcTZoYlcrbFJNODlMUHU0WDVV?=
 =?utf-8?B?ODRCUEpESXBXbDRTcm1XWWV3V0dialNScHZ0eWc0YWJNUnZ3MS9aaFY0eWQ1?=
 =?utf-8?B?alRicDQxRHkrT292QVJIekdmRzk4cDFFZndrM1l4anpVTFFnM2I1MVFqc1ZZ?=
 =?utf-8?B?RTllb280ZitqMURpT0NTVW5DYmREWm4rcW1hZmpwdk9JRWpEUWp5ZmlvUm43?=
 =?utf-8?B?L0s4VXZobTN2NC9mcGVOZTdYb3A0RC9uR3pJMDNKbitqQk9UcFdSc3JBTERQ?=
 =?utf-8?B?MjZZM3JiWDVIM3UzWjhObk1kMmdNSEUyUnUzdFIzNFB3ZDhtZUtXVFNsOFhQ?=
 =?utf-8?B?QTQ4WHhKaHExb0g0M0JXcVJWd3VDK3kxNzJYN21DL2lxaFhCaitVU3lnSDgx?=
 =?utf-8?B?YUNEUmRwb0NuYVpoNE45b1ZwSXB0Z0l6RnlLR2psd3MzaGJuSHUzL2d3T2h0?=
 =?utf-8?B?d2krSFI0T0xHeU5jSXFxR0ttZkxwU20vWU1UT2orS29KdjU0VEc1UjJGL0Y1?=
 =?utf-8?B?ZGg2cm5FRm5WVWRyUC9rdjk1OUtPc3RMK1NsU1Fydkd5V2QxRUJ0U2NIOHlk?=
 =?utf-8?B?WjN5WXNGNzk1NXk5MEYzU3doOVZ4UHUwL2dUa29UczdncjVzN1FnL1gzd1g1?=
 =?utf-8?B?NExqcmV2Zllrb0RIMXkyTW5vSHlzeGhMaWVZMHJZUmo1dUlIVGJZQ1NFNTh3?=
 =?utf-8?B?NjZaR3hVUWMxTGhoY0RZdXpuWHlUNjB0d3JjRlF5K0ptMlRucGVoN0pBOWQ1?=
 =?utf-8?B?RmU0RHBUNW0zRmwzTXFBQlNnU3RIL05EQzB0bGZqYmU4TnR6YUVJdmY1ZUFT?=
 =?utf-8?B?d0Y5V3JBQ2NETXYwOHVmd3hzdTgrbzRtQzJCNGFVaEo0dzhCeEJVZVNGNmpK?=
 =?utf-8?B?MDdENkpFZ3NzdXdOQXVLci9JSW1xYlFyS1BZeUlodlpmMmdIaVJ2YnFock1T?=
 =?utf-8?B?ZGlNeW9zM0NuZUZnVThOOEF2SzFyTnBJaU5ZTnJnZzRCOVp4RXN4M3I2ci9W?=
 =?utf-8?B?TFpxOUhlcnA1VnlHWk44Z0d2RFk4SFBUSjd0RC9NL1hWUGxLZU5rZ3NhUVk3?=
 =?utf-8?B?MW5IYmVGdG1Nd3kzbEpvRkVWZUo0Znh5OGtxMzZ2S3ZxQ243NnR6dk00OXhE?=
 =?utf-8?B?RW5Nbyt5c2RyOHplWXh6aEl3UVEyTXp5bmZYdHM3RUcyUzhJVDhjUTJYSGE0?=
 =?utf-8?B?OTRKSFhtZVg4aFQ2Z3pzOXlVK2svQ01IVWY1OVlyeTdXMHUwOEthMVFCZW40?=
 =?utf-8?B?bFVpY2NBUnBOcU40K0Y0cWdIdzE4Z0JQNm9KaHVwS1FSOFRaWndYTHRPa2RY?=
 =?utf-8?B?TnhKdHlFUnRqU3NaM01lK0YyaFl6TGlLVnZ4Sk1sSXV5d0FXZ2RIMGVrelNC?=
 =?utf-8?B?KzB0ZFdSbXMvVlZtektNK2htUWFZc0RBVXlsaWlPSlJZamt5YlRsemJQdndX?=
 =?utf-8?B?L3Z6NlltdFNhVFFudjJZMmxlWUN6ejJLU1J4MkFvNkJRK25lMkt6TmcvcDFE?=
 =?utf-8?B?Um9FaW1wU1Q0OHFnVUhJNkMwSzNISUpsckIxL0diMDQ4WGFRRTBnbEs3T3dR?=
 =?utf-8?B?eUxOUWJXaTVaZzRqZnRTRlo5dThLNnpEZndNYThXaGt2RVc4ZG8zZ2dzWnZR?=
 =?utf-8?B?SU5CbTY3YVdkanpKbmZIdUpUV2tJRy9Ob3I1WXk1QmVwd0JMb2hVNUU1RnBY?=
 =?utf-8?B?c2Y1ZWs2OVQwNFZYRkI4NFFnakh2Q3p4aTJBQVdPQm5JN0FsRnFIcEo3VEwy?=
 =?utf-8?B?MDAySzQzYzB4YjQ4dUpXUkMyVkRjN0syN21TRlltTTJxdytsRW42K1J4STJP?=
 =?utf-8?B?bDN6OXIrZUpMem1od1FjNTNISTI2bnpTOFpIdWZqd1Y2SWtNZS9kT1EzWlJR?=
 =?utf-8?Q?c4jtv9EBz2PHWonY=3D?=
X-Exchange-RoutingPolicyChecked:
	MeCHjhxPAAZ03y64+B/sUfM8NoxzdzCGEbE0J0jJpcXEuL7AOtUcL4MPtMrJriJl7TrK1ZeRYi9US/HeUzu/e4IJ6dSblPF/dbctowRgr1CnNv64tXaGvvolen9bBwQ0Rrz9EIzAxX9mTTwDBUCiTrwKuzZ8dF/uBWIEu/3Qo/0WZKmqgX3zV96GrTKPu0jaR32bwXsakSbCjmkj+R426/eoDUJ6ZoDLHT5TILxYFj9VZRFb0eylYkEh/9vqzINiNkkl1VIU5M9ICS0Io4/bRWUVksOeF2OjY3lCYPsm/TMxaBeooupfUrqyk1ws9QkevqlB5u11yoWnT/YpQoMAYg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fm8f6YVd/t5zZurHs9jAQtfCJ5Sh8P2oUlWQOMoHNKdFDxcMBFrqFaRCxLhrWbpFQfao2a0cpkafBCeubMeqm9i9Ne11OMSaVwqrsENYmg8ynab2iqYmBGszNpfNAb2WHaGOWeI15jKBYWgtjE5O9wY8dxXd9n3VtMUVuduuBb0LdduOgLgHhrYhpJMYLiS7b549lYIzaYs9mysrvw25vGRytlY9r9Ec1K0DfdyA1jZH9P7fM1n5OfQixjr1oiNNTJ6jF9LB6Y60nFvk316xY83l3cobejFTN1CtD98KsroLXsuXAJqiAcjuQCHLaZBA/TSvczkN1K24K+OSNrW50gM4x1Ka77xgdaxBwRXBi183IYVk17XPyx4UaZyacWNkLqEXZxvfyf+yQ833fiw0tId0U4rhrBXRlt/YQVYV5R2WhvyCjaJ4V4JC6YSrdECMXDM8HWbuHgKJfACdh5fWhZxpMRZeeyDv8DCGHHTrVXGYA+ywkxu30fpyyit7QmOyZxaOv3YWNfhNRSFSUskwX0LW5tO5XQy/chwhDDWgoSWqfZ8bj5PCwqBdxyvC0E65uBM8eLkApacbWJkpILN5tJESMxKQJHN0egmfT3W6cJs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d02ec55-4862-4379-10a4-08debd8bd8d9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 14:09:07.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DEwz9wDWZXZmyDWfPr+PzbJ5cbqc0ym69CXnq8WYwRaqHeUd5kZ2w1wErP8S6+Bt8JSQXyNqvBshVyYjEaWDYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8183
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-29_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605290140
X-Authority-Analysis: v=2.4 cv=PsijqQM3 c=1 sm=1 tr=0 ts=6a199e09 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=ds5yzcVYOOp9gmie_KMA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12303
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDE0MSBTYWx0ZWRfXxnPbJDgje2bW
 s28iYR4YTf+Q7PotAXybFa4lgS5DeA/crclDLQ3Rflt69vPAmZ7GuIwYiwIl7Yu99PENysS8jdO
 uDlfwXKwNUN8JyTmM2HEELwnblMpFN554h5I44iXffjzwMLH2DINAbPMCmgWAoqJ1+m6mAz2w3D
 7HLGqXmfv/VyAlI9SQCUVfgO45ho2uK1TnsqKFW+q+e8i0n/ruA0W/3UIKga3/AD/uHhDXcmvCP
 FwCU0O37AvJIM9RkjLO/hrMPCdBiO1VJJHlynQKUHD2h60/NyzVjD1R3yKdDv7eLKs1YEnJbQUl
 LvoyXVxoF1i5cVmJtRYta+cYPWodbWvDjpBc8gFrBniUVsWuO4luGmyhJL2f2hruGj04RYox3nZ
 ofuyfFDNuyY5tXWeG56eoY92JPW57YzQUXnoBjerihrPrE5L8RVOs5jeQExEbmSv6IX7NBh1k3r
 PKNlEpiOuwFFjhICG836SkrjIWo0orDutukaOPpo=
X-Proofpoint-GUID: jXagy2Eo9FRqmiIl_bdKhsTHCxjgU2mc
X-Proofpoint-ORIG-GUID: jXagy2Eo9FRqmiIl_bdKhsTHCxjgU2mc

On 26/05/2026 02:54, Xingui Yang wrote:
> In sas_rediscover_dev(), when detecting a "flutter" condition (same SAS
> address and compatible device type), the code assumes the device remains
> unchanged and only handles SATA pending state recovery. However, this
> approach misses two important scenarios:
> 
> First, the flutter detection only compares SAS address and device type,
> ignoring potential linkrate changes that may have already occurred.
> 
> Second, after sas_ex_phy_discover() re-queries the expander phy, both
> linkrate and attached SAS address may be updated. The current code does
> not validate these changes against the existing child device.
> 
> Additionally, the replace code path (different SAS address detected)
> has a sysfs duplication issue: sas_unregister_devs_sas_addr() only marks
> the device as gone, but the actual sysfs cleanup happens later in
> sas_destruct_devices(). Calling sas_discover_new() immediately after
> unregister causes sysfs_warn_dup() errors.
> 
> Introduce sas_is_flutter() to check whether it is a true flutter with
> validation for linkrate and sas_addr changes. It returns true for normal
> flutter and false when changes are detected requiring rediscovery.
> 
> Introduce sas_rediscover_phy() to handle async rediscovery for both
> flutter and replace cases. When invoked:
> - Set phy_change_count and ex_change_count to -1 to force revalidation
> - Unregister the device via sas_unregister_devs_sas_addr()
> - Queue DISCE_REVALIDATE_DOMAIN event
> 
> The old device sysfs is cleaned up by sas_destruct_devices() at the end
> of current revalidation work. The new event triggers discovery via
> sas_discover_new() since attached_sas_addr is cleared, avoiding the
> sysfs duplication issue.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> Suggested-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 67 +++++++++++++++++++++++-------
>   1 file changed, 53 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index f55ae9a979cd..4e8e1b339889 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1962,6 +1962,56 @@ static bool dev_type_flutter(enum sas_device_type new, enum sas_device_type old)
>   	return false;
>   }
>   
> +static void sas_rediscover_phy(struct domain_device *dev, int phy_id,

most of the expander phy symbols have _ex_phy ending

> +			       bool last)
> +{
> +	struct expander_device *ex = &dev->ex_dev;
> +	struct ex_phy *phy = &ex->ex_phy[phy_id];
> +
> +	phy->phy_change_count = -1;
> +	ex->ex_change_count = -1;
> +	sas_unregister_devs_sas_addr(dev, phy_id, last);
> +	sas_discover_event(dev->port, DISCE_REVALIDATE_DOMAIN);
> +}
> +
> +static bool sas_is_flutter(struct domain_device *dev, int phy_id,

sas_dev_is_flutter may be a better name

> +			   u8 *sas_addr, enum sas_device_type type)
> +{
> +	struct expander_device *ex = &dev->ex_dev;
> +	struct ex_phy *phy = &ex->ex_phy[phy_id];
> +	struct domain_device *child_dev;
> +	char *action = "";
> +
> +	if (SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr) ||
> +	    !dev_type_flutter(type, phy->attached_dev_type))
> +		return false;
> +
> +	child_dev = sas_ex_to_dev(dev, phy_id);
> +
> +	sas_ex_phy_discover(dev, phy_id);

why not check the return code for error?

> +
> +	if (child_dev && dev_is_sata(child_dev) &&
> +	    phy->attached_dev_type == SAS_SATA_PENDING) {
> +		action = ", needs recovery";
> +	} else if (child_dev && child_dev->linkrate != phy->linkrate) {
> +		pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
> +			SAS_ADDR(dev->sas_addr), phy_id,
> +			child_dev->linkrate, phy->linkrate);
> +		return false;
> +	} else if (child_dev &&

Can you factor out the child_dev checks for all if/else legs?

> +		   SAS_ADDR(child_dev->sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
> +		pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n",
> +			SAS_ADDR(dev->sas_addr), phy_id,
> +			SAS_ADDR(child_dev->sas_addr),
> +			SAS_ADDR(phy->attached_sas_addr));
> +		return false;
> +	}
> +
> +	pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
> +		 SAS_ADDR(dev->sas_addr), phy_id, action);
> +	return true;
> +}
> +
>   static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
>   			      bool last, int sibling)
>   {
> @@ -2015,27 +2065,16 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
>   		if (res == 0)
>   			sas_set_ex_phy(dev, phy_id, disc_resp);
>   		goto out_free_resp;
> -	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
> -		   dev_type_flutter(type, phy->attached_dev_type)) {
> -		struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
> -		char *action = "";
> -
> -		sas_ex_phy_discover(dev, phy_id);
> +	}
>   
> -		if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
> -			action = ", needs recovery";
> -		pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
> -			 SAS_ADDR(dev->sas_addr), phy_id, action);
> +	if (sas_is_flutter(dev, phy_id, sas_addr, type))
>   		goto out_free_resp;
> -	}
>   
>   	/* we always have to delete the old device when we went here */
>   	pr_info("ex %016llx phy%02d replace %016llx\n",
>   		SAS_ADDR(dev->sas_addr), phy_id,
>   		SAS_ADDR(phy->attached_sas_addr));
> -	sas_unregister_devs_sas_addr(dev, phy_id, last);
> -
> -	res = sas_discover_new(dev, phy_id);
> +	sas_rediscover_phy(dev, phy_id, last);
>   out_free_resp:
>   	kfree(disc_resp);
>   	return res;

Can res still hold non-zero value from earlier?

