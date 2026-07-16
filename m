Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE263F166A;
	Thu, 16 Jul 2026 11:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784199779; cv=fail; b=MEF5fmMAkb8mlNg6Gw6jbdWHCaHi3IVDsbyvvryToZ30Ag0KmN54iT0rau4oobT1+6BZLwjjWbmCpcHn/l2wSPjqYhtcVjwccIhMZIv1XeYJkuso1ZkoLtuaRJh7KMZOPPA9JxrZlxt89ByYfP9GrBza/qxvMkaqHOW2tZSpFVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784199779; c=relaxed/simple;
	bh=yudSIyHgn7aURB9671p7OhZC1N1T+Q/D+zb+tPorjiU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ec/iuXw7+qnoFzyuZ87d0mT/pQhg1N/dEHE4vkKdhnUhJhM2wrxkpI8B68LoWlGo3rWyomWvwCBh8CN35U0WcSkXLLfQb2DRKfpJUdkllLUJhwoEKN5OaaRERjJsiG0StGiDaxn3hn8TmQW61ZA9wnbvpyrszEvTsVJDWY/TQXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A2EsXh0l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZDPTlUzN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A2EsXh0l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZDPTlUzN"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G9F2FC3130409;
	Thu, 16 Jul 2026 11:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EEeqExMhSTtVkF66ymzKyRRgygpqyvLiG9yxDOvJsuc=; b=
	A2EsXh0lcD38hq7jrRGAdgKeyS4IK3pqELMq3rm2QDrdDItC7F3ETX4q39SABuUC
	JbROVvLQiHf+vZ4pXjGeZMNJlNIqnT1jPmDZJHB/zZ0iDTLbtJNz0qXqf+Ai8GBi
	sc56B8/OPhiG15Qf6JDyKFQhvR68Hi8rWYOFEhBnqCaqL/yePex4U+5rYoIC3JvH
	DcEsqAy9ILwOKpR1k3Qz9wsz716GD8fZHxPXuSe7FbHS9J8iMaPVrhPc7wLr8uFA
	H+qdQ3GQsiipEP3hP7C2aWQf4s4IYwXucJUKw6WHP78VcpLIMv8nodgvgL1ghQ7s
	ga+omFaRgqO+Axqwm7HyFg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbef10bqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jul 2026 11:02:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66GAvwb9008880;
	Thu, 16 Jul 2026 11:02:45 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9g6jga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 16 Jul 2026 11:02:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7TNycZSeu99IGOrsxHHqgkKhbFJzrl1GEm5Tcto+gnGUnuurZ8daWfVmvmid1zd88aLnXREx2LnwmKPz2nDbodCbYuUAbO7+iClfjTJQx19r9ONxr9AjbALrfKf921GxBqxb9iGQqMcuFs+HaT2Z5ZOg6eJuPAPDQJrZx3UY9ckYSHdgDBg0mAUmykix5bG8EOtpnMej5I9An0/l+UEztoSZUP9nuqnZ+4/W1uOP4z2jq4mFe86vVlfLWXL3ErbvQtA/CzITbxW7d6MFF9BSfqC4JGoGaOo35KK0bzk383TaByeq9dvT5mAZQNnKDte/b9BCY8otVQALhEYnzGHwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEeqExMhSTtVkF66ymzKyRRgygpqyvLiG9yxDOvJsuc=;
 b=N8L5vWWg2CNJrPe8gtpekJ3Bh8QdNzmpxJX+zAMIur+CdqazrSKxQ22Eym2xYFIhRingCtC+ycsptsJ2Gk6ePzyl+dEfna8LhY1i+DZqvT17rBzpIHeX2qgCE/SYSCubQSKsCF9pmnYepc6UxUzfdlsCJMK1smYgIaQ3EZ/XJLlFuFcFi8VsYYsSAmPWiExoSUXUIFzg807HPbtbD/0yK2NaenRsOOdHk1ntd2cEnb7vHy9Zr3k6AX//4rxlmtIC5w/Y+8SydEr89mBSJ/BsjDWPGJNkzOZs1YZjS6/gyT6J4UN9EuCBn3vuTrjuUlpGdIgvUlhqJMdFePjhyj14vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEeqExMhSTtVkF66ymzKyRRgygpqyvLiG9yxDOvJsuc=;
 b=ZDPTlUzNFctCl+zMwDvzKELLCzDPRnjwGVtHIEXPNPRIxzTaAt0gs7K+sFxcJy2//62NYDF404yGgw9db+lXm9euyLjRvDTNY7XWwk0L5+ktdoAftvBM82HMaOIg/fwaXauWt891+aXAx8oxGaYZo629AxNjaBEfpnY8pTJd6PY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM4PR10MB6885.namprd10.prod.outlook.com (2603:10b6:8:103::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.11; Thu, 16 Jul 2026 11:02:36 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Thu, 16 Jul 2026
 11:02:36 +0000
Message-ID: <160b8fcb-6020-4a97-a23c-3515bfa39e43@oracle.com>
Date: Thu, 16 Jul 2026 12:02:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260716081145.3950172-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260716081145.3950172-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0208.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM4PR10MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: cb3a727e-4dc4-46bb-6a45-08dee329be43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|56012099006|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	igUXIcmAKgWxgKCak6/nJyghU5hIJ/TXQUnxvmDrQbbhfofw3W2AVG5joBqG5n17rL/GkEtrUFU9PsoNmbeZfmM7sXoSp7tDGcwKEimSiJ/AlXSkqgKZ6a6b9m/4zMWsL05pfMhU3eCXJMkirxhLAvYbPTRaKu3ZPnhcUiY9Sr4ccS/fFP+IAXmjAA7Q/MP+atJeMj6oTgeAlsDlqDEvbaY52ROMSebqeZeAzeAzHfkKt4/iRbQbXkra533hzb2FrJ+3NaYuVw8nmMeaiCs8Rn3f1aLQhhkKxr0FWBJcL8XFdG/TAXLWeFVIoXQ0k8mxrsR7L3ilLRcRMyqwdnMnWCvklhXn3aKucAOnw/2Vt9vZFl+2cwU/S0TW1dDVLRqcVfrHtlkrosLKznPyAgS1qO+IGnRLbOssb8Y1UvQKsKfYP1mVAbH17yMYxYU6wNdOU6e+l86kTwEUECDBimcuyi6/i9JELhAVdlqMafca5FL4TJWgJSVv44VstxYW3qzIhf+W8nakpaCrrNGJTFVLz1WdmpKZI6IsjduHqLOVFldndGSjewzNoioq9Oa+e80gt4h727VoOvQOcAw+AnZBN8KmEWgDW8uwpdJeAmKjX7LxK9hXGnNXhN+gsq6i54MfEsBun1dTpzlJqUHUycBPc3IUapksfzfyLjRIubIjlIo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(56012099006)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFkweHI2cFgveEdCUUEyUlBMVGRRODdrS1NYUk1kTWpGS0xLczJieXNsN3p6?=
 =?utf-8?B?R3FCU3c3Zkt2M21oRnMxM2p3NTgxVEtJV3psSHNZMnhkVEpJdEFhVjVRRlRj?=
 =?utf-8?B?V0NLSjhuYTJMVGVDbG4xSndZUi8vNXk3RU1hL2J5RTNmYWU3elMxR0hOR1N2?=
 =?utf-8?B?OGovb29NN1Y1NWZ3eDBLVjlFYVRZMm50U1lPcCtsZVFhTEhZRm5xckpud1d0?=
 =?utf-8?B?RXRBL2pwWlU4S20wTzFyckZsKzlzVE01S3Rnek93eEtXWVd1WXY4dHEwVWd6?=
 =?utf-8?B?TXROV0xZOG9EVWFMNjZDRGhaWEI0YnlIT1Z0RXZaSzFEY0NPTWhHUS94UlRI?=
 =?utf-8?B?L2RqYUgzS0w1YWJ6ZWg3N1hTdXRxT2hKRjVsMUljUnBNZnJGc2svZVNQeXRB?=
 =?utf-8?B?QXJOb0xKZ0o2OGtZaURrU1ovZUhLcmFpSFgyUjdXUnNiV2pDaVdtS3NTK3Fm?=
 =?utf-8?B?TmI2UVFPc3d0RW9JdFlNSWp6bFRDbnB1TEtud0VRdDJMUGFraUorZU5oNjJY?=
 =?utf-8?B?blo3OTRFSHdNY1pDRVFJVC8zeDRXK1ZVS0tJd2I5ZFJmOUpCSXFvMUVWRE51?=
 =?utf-8?B?bUhMeVJOOVBiNHRmWElFeW1uT3JFRHM5QzdBY0NPcCtlNE9DbVFXaEo1b2tR?=
 =?utf-8?B?ajB5ZXBOMms4cVBpMWxwZ1owYzZ0RVlnUlphcVBIcmQwazE3a01Nd291VGE2?=
 =?utf-8?B?cWdaYmhIdkpRd1RrT0czT2VpUHY1Z1d5WUpndmFFTExtWEx3eHppUkZWTWE1?=
 =?utf-8?B?U0VWNGVTa3Awc295VUVpSmNrcHM5aFZNZ3NITys2eVcrOXlRY05Wa2p6cy9R?=
 =?utf-8?B?MER3LzdoL0dqTHNxNnZsTnBiZ1V1b1N4ekViMGMrMW92UjIzYmpaeUR6eHR6?=
 =?utf-8?B?U2FFQjVZMXMyR290MC9TZ2FFQkw1Wi9Vd3ljazhmS3pDc3hId2FINUZ6dnhX?=
 =?utf-8?B?SlZKbi9hcEsxWWtxUmhHK1o2Smh1RnNRaFhsS25ZakxXZFFRcENoMWI4M2hP?=
 =?utf-8?B?SEVyeDBiQjJCemRCbHF3WW9pTWdNRkVWL0Z3ME5wcmxuZG9ZMll3VVhQbEd0?=
 =?utf-8?B?VmlpdVNIazZUWjE1eVFkMEM3QjcyK29UcDRjdzBCT0tlaGZuSE5Wc2E2c2tL?=
 =?utf-8?B?ZGNMVTNuVmRNZnZJbW9VaCtvd2VYTUVCeXhIUGVhRy9pZWVjakp1RGxlUXRL?=
 =?utf-8?B?Y1hzZGJqL3dsMFpxdFRWOThSOVFtcVlIcmZFWlczaGtRMFdqREFVb2VUeVgz?=
 =?utf-8?B?UkhsQk5ORkVGTUoxOFJXMngxTlRQRVBVVURhQnJVYWlnOTNZb3Z5VGJ5aURB?=
 =?utf-8?B?aVIwVjkydkFUaW1FbUdob3ByTDNxL2hibWd6bVZEZFhXZEc5Yk9WcytCYm1r?=
 =?utf-8?B?T1NKYjRySlZHUjFNc3NxaC9id1Q2NTBhQndsUVJXeEpYRlFRODNqYUd3M3BS?=
 =?utf-8?B?MmFSV3ZBdFVyM29XWkhmNXRpeFlCdkNrR1VXN0VISS93bVhNWTFFZWpGYjlS?=
 =?utf-8?B?TEZBVDVHWURzMnluM3YzT0Q3YmJCWjJpdEQ4RjNVZkRjU0oxOFA0SkdaS2x3?=
 =?utf-8?B?UFUrbjkxTEJqb0FwaGlvcHZrL2p6R3BDaWhBUld5RXlVc3hadkZmblNjRmoy?=
 =?utf-8?B?U0hpODRHaGtWSmQzRitOOUdDelJJNWVUalJkSlpmNGFGd2RPSTVVbUN0OWpm?=
 =?utf-8?B?TTVEZXNSS2VTVU1leXRyT2tRb1ZVU1BScnBxUDVyYnZlVGpEYlVBN09ZQ3cx?=
 =?utf-8?B?aEZ4aHJqa1VLU0RwdTlvZTNHSk1NNnM2WjNzOFdMTDRSMjFTVVUzQWJYMk5M?=
 =?utf-8?B?Z2hsYUlrbDkxMmJaYTJ5VWplVVErWHJuRSs2eDFmY0JHank1TGlKYVJtVG9R?=
 =?utf-8?B?YzU0aXVOM2Z5TGdBdk15WTdOTlRuby9tRzJjQzdqMk8xNEk1elByQW5lVHJU?=
 =?utf-8?B?UldGL3AyK1Qrb1ZiZFNUWWF3NXRZNXI0YUkzYXVWRlNld0hzR2lrRlp4ODZP?=
 =?utf-8?B?V0J6VUtXNVZQOWdxaExGUTc2YTc1MTNmbTB4YWhzamRzRjhnemFnNStMd3lx?=
 =?utf-8?B?dUd2T1dvbU1LZ3RQcGRNZmo0b3hIN3FIZDl1ZmU0bUY1WmIrUHIxWDRMMVlC?=
 =?utf-8?B?L2h3ajE0VFNDRTRpRzFmcEhNUkxWZmFyM0cyVGxIZnY3eFFkMDZ2YnR5dEVj?=
 =?utf-8?B?ZmFyZGhBcVJweVlzM1dsYmJCbEhiU0VaUVlCc0h5OXlhaVBQU1RqalJtSWhX?=
 =?utf-8?B?dmU3MitaSXYrUk1HYkErM3B0TVNDL3NvWWpYZzBHT09jbUpKTm5Kb0h3ZUVK?=
 =?utf-8?B?MnhhZDFPOUJ3SWFDcEFJQzFCbmpCa1RaeFJZWHNQUlVCVmtTcVdFT2dNaDdV?=
 =?utf-8?Q?AaOIx791BAh0eWy4=3D?=
X-Exchange-RoutingPolicyChecked:
	GO0Cv2bffCbl94UBlYpSKryR5zU5XbYPao2mElayYmy9lHtwyQzNpenjbsDI5NPqC0FFkR8vUbo3QUqYy2qE21dbfuC8QU71SwLBwVv3Ak9vJu66UmTPsVOGnK3IfOuOA8BnjWVmkE1M9gyuCtsPPrFopzwLk3f4lNdDZUe5pc1gMyzmogi2ciI5wKddf4QNJAz2PijKKYjLN8siZvvqzoCeQK0Yg5jZDdlL4b1C4SMzx2xCt3nEhSzkrqMBecgTxW0Q2VVnJkfkRDIv0FohNeqnsZQUtA4/A4hqR94+hymKP5HHMRUdCfbdAi+mA96mECtuQQi/QZbRvnQGxhzkuA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6aOIeFkl9eILWoXsfUROcl62a88g7FF2+aWE1op0Xtk0j84q9ZlRIMKqoKH6JGjABqnDM2mUVx1yC+rk3DBx7u8SdUA4Fwsgtz4vNSc+BlJZ3qUK0azeO3nq8ETsDIghNXMWsiqtAgQYKxU+/yZDskAvu3dwRvvQOQ6rSJUKikjLZwiUuzFsSyyl3uhT5ekpuLZqhDQjlVzgSLvlGPvamEa8AFqJS/vt9n5lEu/kYg96raCdY2xxkoS8lCNGLtLN8BCRE7CYxhlHoZVbTQ2Uqsca/HRFN+f9UsKWwoFWGAZHKBM/4b7zQ/ARTKIHs5CrdpCyYOZ81TiOYjeP+A4iUafgEaPQXQ37ePRKSIwoHxewyNBZP+6DPeDxYMwSBHt1VndG2QpdLKsTQd8Oyr+ixuXOdALgkis0FywY0X8ZI1aN1yu0O7waXBjs2x4zQSFE1JI3zzouNLtafN2VbifxdHig8I5dX5k+nLNQvxwfXNQbFSuPufAYrDf3rT7EWEb90z34DnwhLFP8KsSjJadxPq9ifJw5jgnR57GIjDFLOwDQxMPpTdZoI3uOKJfs35gpXeRbgrYucTFaelufyNyHc0XzJ12I+7eoMh1yDwtl8cQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3a727e-4dc4-46bb-6a45-08dee329be43
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 11:02:36.1885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PS0yVC4FE6kUAw5jUEZvkd+OAfFM29/GvSg1MGBHo3gc5EqgzriabK1g69mtCX0kxbxQzsrlZaXlnihec65X+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6885
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_04,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=868 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607160113
X-Proofpoint-GUID: bg2W7CliFNuaTv_3VYJOFveN9RJZ-VVM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDExNCBTYWx0ZWRfXxSEd7gjKuxUR
 02r9qPEQubJDNnOBWFZhIVVDw4uVfp92atVma5ywRWssvh2jWgZK+fY4cHiqfaOYE1q2w0f8zWt
 Q36eLPVDUaKfxtX6GpnFFms6dpxUa0Nzib6PRxXGQP8i2cVxZCVW
X-Authority-Analysis: v=2.4 cv=KJZqylFo c=1 sm=1 tr=0 ts=6a58ba55 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=i0EeH86SAAAA:8
 a=7AElrDZCdZOXMqn8pPgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDExNCBTYWx0ZWRfX7mVbNEiZ+33y
 Da45h0Iyg5g5kcm+L1rw/TczD+gXW6FRXLdiNA3gKZuwENjlJlv5+lUtqMoalUm9GVztKoyaTGC
 CKIaEE6a/2z/z1pg+SHXvXteY9b9LwrECwHArpciH/8G1rQCcit5oOyoZswRc/ViQ6XCCNeXKny
 lEGy+RmQsLp+ZLT5rJuQEuS8WQXaP3PgXpfHM4SKciAlZIuEBPp1XeFg7c+vMvADCLLTMAPZfBE
 kE1KjHrPxKEfzqewxqQHW4m96zV+UJqu8EQ4T5No+1mZnP/W49rsotfmEqQ6xwJrg7Ujluc9i1g
 NDADkkq04wNojufL6AeQXfnVC092QS4oydxh9XZ11H5JQmGJgO2UYMgnVOzTWE/KvbsS634ppjc
 N7VlxwRN2EGEROMs6AfatGMpsetktvG2MXxsmVOObWV0V3S0wRgIfqdhVooyBZwD99lhU66jZyB
 TU7WLir6GgkBWnbxRZg==
X-Proofpoint-ORIG-GUID: bg2W7CliFNuaTv_3VYJOFveN9RJZ-VVM

On 16/07/2026 09:11, Xingui Yang wrote:
> Commit fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue
> for HA resume") introduced sas_resume_ha_no_sync() to avoid a deadlock:
> the PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue, calls
> sas_deform_port() -> sas_destruct_devices(), which removes SCSI devices and
> waits for the host to become runtime-active. But the host cannot resume
> until sas_resume_ha() -> sas_drain_work() returns, and the drain is blocked
> on that very handler.
> 
> However skipping the drain reintroduces a race: hisi_sas returns from
> resume before all PHY UP work and libsas discovery work finish. The
> controller may then autosuspend while disks are still waking up. The disks
> issue IO to a suspended controller, the IO fails, and the disks get
> disabled.
> 
> Fix the deadlock at its source by moving the PHYE_RESUME_TIMEOUT
> notification to after sas_drain_work(). By then the host resume is about to
> complete, so device removal through device_link no longer blocks on the
> resume and the cycle is broken.
> 
> With the deadlock gone, restore sas_resume_ha() (the draining variant) in
> hisi_sas and remove sas_resume_ha_no_sync().
> 
> The reorder is safe for the other libsas consumers (isci, pm8001, aic94xx,
> mvsas). During suspend, sas_suspend_devices() calls
> sas_notify_lldd_dev_gone() for each device, which sets dev->lldd_dev to
> NULL. When scsi_unblock_requests re-enables I/O in resume, any I/O to a
> timed-out phy's disk is immediately rejected by the LLDD before reaching
> hardware: isci returns SAS_DEVICE_UNKNOWN (mapped to DID_BAD_TARGET), and
> pm8001 returns SAS_PHY_DOWN (mapped to DID_NO_CONNECT). Both complete
> directly via scsi_done() without entering SCSI EH. This is identical in
> both the old and new ordering since lldd_dev_gone runs during suspend,
> before resume. The reorder only affects when the PHYE_RESUME_TIMEOUT
> handler runs (synchronized by sas_drain_work() vs. asynchronous after
> resume returns), not whether I/O can reach the device. aic94xx and mvsas
> do not register any PM ops and never reach this code path.
> 
> Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue for HA resume")
> Signed-off-by: Xingui Yang<yangxingui@huawei.com>

Can this possibly be tested on another SCSI HBA which uses libsas? And 
using SATA disks.
