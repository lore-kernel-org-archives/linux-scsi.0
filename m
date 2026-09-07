Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F61437BE72;
	Mon,  7 Sep 2026 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794989; cv=fail; b=ruUsjUfCcYmFAUNPKK8QbSQcW0mJkMjlaHkSO9ltRyV0ixhezJTBXCCHAGb2f5J6G3MlZYYK4gUyv48AJ63UyQ9BN0nYbv2NSCLjZzjbi+j2KCZIihLDzxpSknTIcjWbaPmuU8R1p2eMjHDu2TJLcWMYvRhDC0RUvddTtq0f0Rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794989; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fiHnWThrxSh288SJjxNWbnVhw/DMrtNwi4bgA5HGjghpFJ80JIhvmPE/B6TdMHpSTwV35KA5V0z78oRm+qD8VfeGg/SCra1TpwJ9XVrAAWKzkicVIGSwr5vwDfB2vtEEHhZplbRqfMulJ2Q05A2pGHuHFjN81xTzUbSJEZrP7pE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Npqzq+JP; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JJgTmwhx; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Npqzq+JP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JJgTmwhx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788794988; x=1820330988;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Npqzq+JPhj4fvkWOOUG7E4dK2qD9hRe6cdPRen+IJ/9VbnDaLaAA7zvd
   yHdNAjHGxVYeUmj+DEYqxtMMtYMvKHvjJeBC7Erib207pOAUQtPxlIP/X
   +Z6O3GYOKPr+ALr9iqXJ9WKZRN3CtE5VKE+kcZ5S+XgJNz+J2ng5W3X4I
   bBtCyTnOud4iB8F8IgTLEmNWYRKFAAJMhiqVGeRdM6Cl43M5U4xUwYQ0r
   e4+0LxhWcA400N0OSKYO/5tiME6By6XcqJC3JpjcR7920Oh0mKI2irFqw
   CY0JLQ+6sZepexb04krstVchILAjNOBjIPVt7mRNKtj7Pa30EOrJ8kJR9
   w==;
X-CSE-ConnectionGUID: q62BPB4TQjOvwRzKH4gGew==
X-CSE-MsgGUID: DQ8Cw8sYS8i4o2ROoyjBlA==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="156050788"
Received: from mail-westus3azon11010045.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:29:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oBgYCcva9UCv36Zk2cC3cFZWJxT8mTuEd5HiTQwmmrPOZ2bvcXwRA1kYT2N4h/UjFAh9cim8L6x/RPJsiL90yjWNgiLWYC91t8ywUbH/s9QG06dw8EI80NUiAYuSL1XO3FNNHJfSNwoxnZxBJBCch2FpkfwzVrZ7rsIr29A2W2pKtT+3at+tR5rB1l1AoHd0fWB3yjWPZt2IB8KqSd1vPq6dSgenYVuefKf81l1lw9oRejLwVl6txVDgofH3IVnKfKq+2ot3at9k5kwuledlRLSmKf/bRa7DSuOWfAWDwZJYRUpREfhkM32gWpRIqQVzWXxXUy/1vtadSPU31EeLCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=e1dyXH2gDi7KrVEN//YwLsRiHJTCAIKdRinQxWRv2UQyaLxTTYm9GsjXyciQpTokQwtFIuPdifH2Kwrq2gmWl3yXWB87For9Mgg6HOUuJuEBY/A0cEhfJx5JZqtZoaGexz1x3c4cjLz1/t0Fe7OReFWiikVNHGjI4xEa68HTfCCIfVLuh7KKI4E6Uer/f6YjNPINIOacjOK7ike9ecKFsuF7bjdc0GtJ1Yz7jMT49ZbGZXBOcd5mAyi4ZaBZswMk9Q22SImSn7kyDKRM7QLlCRbncLUZpiGi4KWrDVq6cKP2mUhIS/oP6MJrrzhCfJpkl7in+6zD55oWdI0CFPAECA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=JJgTmwhxiPqvWE+aYr9gdt4b5hXlpfCGxBg/jdMeOvxmDTuQYOy64si4Tr8+usxUZPMaNsmQQSLRGcsBp9EYupvfhGXI0LArVBISlVePJbMKnTzpg6zSO5fM/EwHlBo5N0NSkVDiffdDtVQL56uiX3Gsv8viwKJNiOkdZYNcybs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB8960.namprd04.prod.outlook.com (2603:10b6:408:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:29:45 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:29:44 +0000
Message-ID: <77c5966a-8579-42c4-8492-ef334fe41df5@wdc.com>
Date: Mon, 7 Sep 2026 17:29:39 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 29/40] scsi: libiscsi: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-30-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-30-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0210.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d42abc2-4acb-4d75-4d40-08df0cf4d799
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|19092799006|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	nOzG0IayZbmvnz5CGyD8Jx4MQAtW/NI7daGh05KKEtey43lohN04gPxSsvxtHJhYM9kBz/b7JUJ9fKG4CL7Reft4IgiR25TuFoi5M7db813DAXf7aPpAV9f29J5a54jcJxoUhFxzDujhkDG2evFqIEugMF6FfcpQL71Q+UFDiHiciLHWT/A0ysu1HTmjjXGvWIgnhYCVvtrAMceJQHT4rXwr3jvcwp08ZVyGN+RcjXGEynclZKaLHoyUkOOQl6phGoW3SSOT72mcUSNbqom2nxhd6br0CANMcUXvAo3/Vl9v/J9clPrBI6Hcq0+5YDXzC/cF6eUzULwGaxeroNKWIhbEoW50XgZ6E219Fz2sbhyImpqc84hEwNokr+WvmQQyY/Ypk9er71OjwyI0hGXr969P45RZNLGeJi53fRZaB1NDlg7KfrXgSIfOj7aOnZufF4l3JdcxYw0MiuCOBNm0XEB0wocJZWXwLe43c4kl/zjUGDEXEUV6/OlnFG+DR8qRcbbuHdk9+Eb+zvckVYgRwds3zLYNLiWMGe2ERjXeYXg1ComqY/L6INYqW8D4TdY4oab1FW2WaSGE+xyla7ZHAgRU5I5/qgfw/9hf8QdgT777KTHCbFtrq8dSMJkiQiN8zCt77KInxq1yfZtrA8HfgIfvNcVrYkUceSNmMNGL7oe8WFVKAGD1lkHJG8EX68KbOxKxobmqCn8g9jYpRNYxLA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(19092799006)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1c2TDc5V1hzZTJTdnYwcWdHbVdCWGVnUFkyZlFIZGUydWpycDhNZzJ2OERV?=
 =?utf-8?B?WUhMTHVINHE5ZUhtclNFWlJ4UTY3OE1pdFhRYnJMUy80NVppL09ZVGNuS1dz?=
 =?utf-8?B?YWxFai9RbzhNUjcxMTVCc1dITWRBdHJTaHFLV0lJRWlvTU54MG9zZ1YxNVg1?=
 =?utf-8?B?RW9wSEdDSGQyRk9rMDJVenVqdmxyQ3RJMW5PM3VCV0V1RUc5TExqNjNBVU52?=
 =?utf-8?B?NS9ZTXdEMTA4alUvMVRkeFkzSmVScWU3dFE4TStKZUg5YnZoNkk4Y09uTytW?=
 =?utf-8?B?YkNTbU5aTmFJeFErNmVvalZVbzRWOG5yUXBJOWNnK2w0RVlEUy9aSkQ5VkdZ?=
 =?utf-8?B?VFdGbDVpNzNQb1R2azU0YzdyN2l1cVBtdTFudkRWZXY4R2RUTnZlOVEraDkx?=
 =?utf-8?B?Tit2WE82UlhLU1F1OTlWOEJsaHkva1A5NEtTMXU2U1FzSFBycXBUaXlwamRh?=
 =?utf-8?B?RWp2SjN1dDVZSnR4L29GSlhGd0c0d05jcUl5aXBlZXJLWnQxV2VzMkNpT0Vl?=
 =?utf-8?B?MXFYSTY5dG1yb29oL2p5ZU5Ua01yaGZDSldmaXlVZXpnY3BVVWszNXNoMXlV?=
 =?utf-8?B?bVJvNG9CYUpNSnNKZEFSZVhjdnMzZE94dHZ0RjUranRxRnA3R3k5a0NyQVpP?=
 =?utf-8?B?VHdYaStxbUFkSmFIUFIrUzRXS2RPWFJaSHFlNjBZNmx1K3Z1bC94dmZaSUgv?=
 =?utf-8?B?RUN0OGQzbmpwazhNcitZdjlXQlEyMHJWY2gzQzRnK3pFeUQ3c1ZOTFZzNEh3?=
 =?utf-8?B?ak1Tb0ZSbTZKNEhBRXNVREJmSFAzRnB5YnVLYzhFamlPWStSZG9YQkhvQnE5?=
 =?utf-8?B?aEtiTzlsNktsRmlkZ3Q5dE4vT0t1b01GRXozM3lpYjA2WWNNSDRJSEhGRUg3?=
 =?utf-8?B?V3ZLRUxOS2NST1dXVVdJU0ovQ1F3c09OajVmZWkzVTgrUVkzQk1qbmtNSFE1?=
 =?utf-8?B?by9WSmNWZ0N3VzFUTkFienppVXVOVHBiK2NCS3pZOVBQeGFhT1h4NmFrVE5T?=
 =?utf-8?B?dGNEUjZGeWljWnJ1eWNxT09DSEJvdzdKNFZTRnhGUHJoL2JRK3lVd0JtVUwr?=
 =?utf-8?B?VjU1VUNwZG5sZnNodGNPb1VKbWtDcHJqRXBGY3UyWSt3UjkvRStNTmM5UXRz?=
 =?utf-8?B?ZDU1WXNqNm41TG5BRTdLT2Z5ODhLbzNmSUx5YmRxb0RIeVlJcEF3KzRoV05C?=
 =?utf-8?B?N3dta1FPOUtFRkE5VHZvc3hZL20zcGZyZldVblZwdWRhQWh6d2JVeGtEQXhK?=
 =?utf-8?B?dU1vOFBNSGxUMXJGNW1RV2M5Y3ZUR0Y5UWFidWFHU1ZkRFRXeWhQQVZERXpK?=
 =?utf-8?B?ekM5NHdvNTMrQjE0OGdLVzUvQmxWalFlTzFLZzdOdkR4c01BUmZjUlB0bnRx?=
 =?utf-8?B?YjNJYzgrendOZlhkaWx2c245ejdTM2kySVVPNElnNXJ0YWZLQXhLbWtaV1Mx?=
 =?utf-8?B?d0RxZXVvTzFlSFFWUnZ4UFllRUZORmo2UnY0Y1AwVzBIa0xSNk94NmtXVG1K?=
 =?utf-8?B?czhOWlRRUDFua0dQQkhFT1ZUS0plcmorRVdQR3AyZzhlSjZranZNbWRyVm1D?=
 =?utf-8?B?K2Qzc3RVODYwUkV4aXZ3N2xEYzJEb0JCL3pCZWJaQ0o4UFdkd2h5UHFwVFJQ?=
 =?utf-8?B?TWZ6cWQ5L05qL3RrN3dVYlQ3Ti9EczBkS0hac0Y2NHAyMHJFc2d2U3htdmxa?=
 =?utf-8?B?M3RNZjBKUXJtZVU2ZVhLVjFNNGpmdElhYXpjNFRYbUc4RkFKRUtIZkozM1lV?=
 =?utf-8?B?cDIxR1l0YVFvSWNxTzJoemtwaVpDZUhJNERLUDYxWXZybEZTN1FlbHlTSENI?=
 =?utf-8?B?c01XN0IvM2hzbTA3b0ZTang0ZEVPenVOZS9DSnhOaVJSeVo1OGtvWlErcG5H?=
 =?utf-8?B?M1V2MWs4VE1zNllCQUc1VEZkYnRMVjljbHpJMFgwa2ovVVB0dGFTT0FKS0lG?=
 =?utf-8?B?M2VjNkJ5ZDVMUUtXOGdHK0N4VGU0OEFiVHJWMmI4Rzk2NURyR1c2YysyTkky?=
 =?utf-8?B?RVFMbDhjV1BEcjlYTy9sc2dPbXN2S2ZQeTIyU1RvbGNTNm1DTmxrdmpnaHVG?=
 =?utf-8?B?aHl3MGR2alhYbmMzQ3ZleExqOG5NMjZtQUxVcTJOMXAza3A5ZDJQZ1JMU0dU?=
 =?utf-8?B?bzRPY0w0ajViZTBaSGdudFNNRXJpeWFrNTFDek9aVjJYTGVPamh3Q3BXeG9y?=
 =?utf-8?B?MHBxcTFlbFczQmdKcFJSR1ZFTjdnbVRQR2VPaFhPUmcwSnhpY0RXaFlKbUdC?=
 =?utf-8?B?QzhuVFBBUFg5RUVkTGtkc1RGQm4zWkhQbEduSndXSlAyQllFQ1g0bW1jaW10?=
 =?utf-8?B?WWNuTStGa2FJNmVDR1JtYVlIbUJiZzc4SSszSFk1NDdJZmRiZ0d5UkpJam9I?=
 =?utf-8?Q?3C58NYXYYzY4TRqk=3D?=
X-Exchange-RoutingPolicyChecked:
	DeOdeHafvymdhKV3A8liYr4RkNhcORyfHG66jrGBx40Em42d/piKO15kDWPzuMWoWTbC6xgN7+hmLYianpq94Ld6/krSOJJp/x4kQrlgFyBPkO2eTc/lSTyIzFOMhHQMWqXMMCJwYtunf7VoiIq55E3qUFewd6I6KE8RuYQStRlNWiY8vC2iFIQND2IuYMSGgvw9BDq890np4YYiD7/DmQQcLYT/MEpBquaLntse70QNfBgWA9wvmsnJ2Lq5Gl93ZbcVu1W2zTnZrWYgiLGp6ewzu+yN7vW7GntaKwdmytq+oDZtJGyHY7VIsFl3vIX2Hninlq1Pg27SDSignDQ+zA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ms7li+EOoTz9LWshcqp9q5TNJ7h7fDjkXJ3+SMbHWpxXTnBfCZm1+Hw/mu2hfc0SIBHkIqBq8aondfrNKRUy1z5Wsaf4B6vM9WrFXcnnCMmOMGEpDlxxiPJG2SWx69pQBPRBfE4qVCUGXwh1SoNi5XYyuj5dMU3uzpyvAO8ZYNnf6dapoLoShcVzY8smybmx4834DypUhx+HbtwwHj67HouFZvS8XIhnSlvppP85L87i6i4coPh7uVfLoeeJhuTtMvTiqeKS6WVnG70r7wi/nbNRbjrjvQTQFSkAgzPzk+KNaP39c/wz9wMTKO4JRAYOj01CQKk14AoxRjnUhaceojEl5Bg3AvUDTD9PlXTfyPJ7aKyhlfumraSKN+LAT2J46hgb0f/JDw6IDw4Z+9/4aP27ivd2zeQ+r+ldVRU5P8W2yxbL6cMRGLEdmZaUddHq8LL48Oy0rDkSx/pf79bx28O5URkwNXXBuxsv8EcPIO50gzmoKNBVGmyrsFACbdBb7TqAC0O6gTce3586t7Dz8LstQEEOMUUEBT5lA/YH3+S6q+k2cj5amzr8y52n5PDBM11bQpy3UJcTXdv8h16DiSHJVoGujJlGG2j6lVmIEG+6esSL4aC7cZVVmOOE86Z5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d42abc2-4acb-4d75-4d40-08df0cf4d799
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:29:43.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVr87NNvcWaHaaCZZslqU+LvYb8RPb+PkVBLpWQc1SPmlVKuk75q8LVwznhdU14/N3w2ZcgTVrN1EoxaUm27kQ/9nuwY8Q/E0yVJxaFniIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8960

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


