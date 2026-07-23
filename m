Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC4A431E4A;
	Thu, 23 Jul 2026 11:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804527; cv=fail; b=BgEcShLGMYbxvrmy5dW9De8SHTIobWbzRy2pUNBK9Q+0cZhCImpzt75PB2ZoBYPC34nvxnDGDDv7Q2SOZ3vw0TgrtBZWiSE1JqBkYLqIg9lI7CUL/4K95GSHqiEoNn/8GtG0YCj3QQ5yCb3DX17uiRBdUHN7swwfz/iGoZa5k8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804527; c=relaxed/simple;
	bh=wKVCcyG7vJX5IckJD1UZ3w+HAJoxETtq3C6VPXLSC48=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b5nFFIZvoHrGw9CB7rxsjwVG5fFXreDwkQwcBKMALBOniQvWZ8koT+ieKhtqolMQR3FPr1R9c8HbSuXQeLZH5n9WyLWILddnNfKWC7qe1TUPbEOqhQeSKGp9iCOlRM1QkNXAohosn8ms6wLe9CrIU3C9M2/KscdFAgiCF+jvUwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qr1vbHsl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hOP8v4Aq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qr1vbHsl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hOP8v4Aq"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtjbs3404255;
	Thu, 23 Jul 2026 11:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=537VpToOVDoZ2vDRuh7yNfdC68slWoRxDtkAdBwj718=; b=
	qr1vbHsl1qmCb0X0HRJGe1E3HNHhatHqpczIDi2ti7VXmhD8K+4+gQ0dnMQRYltc
	zR3n0rzaB4Cz5U5L6mf9lZ4KYlmKEgVX6bCgCfgzPRWIRSwQRkQV1c6I6VsparI1
	rC0UnBhB89Ue3PbiYHRJw5GCE0jntFXvlLnObhOtoRDfgJKAQqIy5lkhuJ+yOCWg
	bNStyZ2zeY31jBNI6h73gufHonZgas8ipIXO0q6CQ3nvvQykIUyQjeiyd1R7UqbD
	PVdwsktj3xRCtY+alB3IrZ+ZnoG4G4j9M0r/OdKoE5LKYKs42+5YuCp/VyPVCxQc
	/gfa1CdrlytElL3ofq81mw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3pqgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:02:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAwHwZ010488;
	Thu, 23 Jul 2026 11:02:03 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012059.outbound.protection.outlook.com [40.107.200.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts1166n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:02:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLLkR9SzNsvOKU/wZqYzYZGtZvhZg5R3oIia9DJQmvMuilmZEi6LXfSuP2W6NJtqUIJgShyTKVVzFatj+EMZMq4aN7aRCS5eMHjmJ2Kj0hCANGDT2PISGHy4haWlRGNtNUDhNGhHJuGasdBDq2swKBN+b2olkzP6mqrv1xEbByyoubucRLTYC9um1Vbof/wesCAnQmX4gDeYmKruFERf/oLR/LidRJrQt5Gs2nzELUUuxAfxnQ2iSxbnsrxudMNgxaBzaEKLG3ZcIh6qmVTeItKB4d1OYIi2McVrMgf5KEKvSfG6kiU9uARQ1FQN/wL/XB7bJ/NAoNGCWU+OE91Ybw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=537VpToOVDoZ2vDRuh7yNfdC68slWoRxDtkAdBwj718=;
 b=t6NbRGlfH6TEDJ2r6uPjnoCBv3FKKb8M5OquAdF/sMLEZgPn6N8AbC3JkGDH6yG3bVHONLF6KOCl5FiYV36HMMCEnm8qfDJWJzg3AynR31N3MYWLmktpEMHCWj8zreMeYGr4Yh3mljcR29tW8eZYMhkHiyAcpq8DHjK6Lm3PR/pBiN1Ig2YWHV+gsBx9JYNBz3vHfZxD4J666l3v1JtjYAJ+R2RWWBHwKS5umrGuPdOJwuz0b2LI8dfeTV+LkRJ0PhRNwuhQaPnvpPPvqLPW2L3B/ZgmOAGdTRpYqEESSzo8CLtYEogOLKbfvldPrL0tSmtfo4q4+wFsQn1yHKl6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=537VpToOVDoZ2vDRuh7yNfdC68slWoRxDtkAdBwj718=;
 b=hOP8v4Aqy3YXTv+8pyV8ZLqfmOepQ0IqvftMJl3YqH2zOlOtX3xWJZ6foYFAGzBfx1AO8PBr2RUvlbiY6b9DWyPrxR1bYfPoC/b8QgzPO4X69FtXDXEufVawuq2js1MUXIjScvs+weCkMYViSrW+BpbJSeZzznhAXDwnph7M0Co=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by IA1PR10MB7486.namprd10.prod.outlook.com (2603:10b6:208:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 11:01:59 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:01:59 +0000
Message-ID: <ab939fb8-dc24-4ab8-b567-cb561c8fbca9@oracle.com>
Date: Thu, 23 Jul 2026 12:01:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/28] scsi-multipath: clear path when device is
 blocked
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-18-john.g.garry@oracle.com>
 <20260723103311.816FC1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723103311.816FC1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0664.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|IA1PR10MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: dfe052f5-7103-4d84-aac6-08dee8a9d0cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|4143699003|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IPU2y2q8ugirExBaiYjWj8YGBCfIGuMRCzMTCnRsdC1Bonw9/4nLXKE42nvqU0Dni5XZNOJmvSd9cx+e0od5ZmmoTKMw+CMYl15U2qKn4N6AHXMCSGUgeLj9y9kwrPVEzfg22akxEjqN5tOMBeZQUN8UZywFAAWavhVAMW0ILoifI9LfIphP+jVdVVc8FCkHyglfrGS4n6iKF8gJOXOLbXEgxZHmc/nNIM50hlaIhKok2IwybRn69fB5hJhgMdcxF0PriwdNRUl+Eg7FW6mqbu+xhYfQscpjUin3JxYJ7f3FBoWi0dwCJk3E8VnHencBG9m+awqyDz7U2BEgUT/tEuZ0GC1bWYBlPcIYkChdYUtukHDDWRtb10O5pTyMiyIjPYZHTPD+dZLsOFlyRMX0PyWEplJhpZZ1cesWA+A0dXQREqhICLyXntiGOrWWwpHDayJ+YDki3dfmOn6aVuXBCwSSXDJ2YKDTgrxWg3UA0jC4DsVmzxYe28mJ/skSJnbjyyG2Nit4Op+VgpIYO0PHWn4yVGOVoKZFYSyD4pvxX/sK8Uydfc7OnGWM0jboo1Ip83njsC0BhPpXftz4G8KGk4nMOp0XwzWCkw/WxqkxnCrt5CNFH/RgjVaf9a7O7tYKeQ14UIZZmFtfV6ozvk+n7PjIkebXH7AleKq1j2Hs6uY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(4143699003)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wm05ZHlCVHVSOVdya3plbWVzWFpGRlNIVHRlVjF3ZGRESlZ3WmxVSGJqbGZ6?=
 =?utf-8?B?OHNqWHUwTEdmQ0lmdnJzaVRyZUNEVVRuNFV1bTJzdGRYd3FZS1RZaFg1dkhu?=
 =?utf-8?B?c0xnd2MydUtBZ2xEc3VTbDNjNmxZVnN0V1NlLzVkY2x4OUtRUC9NT3pFbko1?=
 =?utf-8?B?QzhIZEJkK2Q0MmNGNzNNT0ZKTy82dXNQMkRXOVRsd3NpMFhNUUdkU2dlR21Y?=
 =?utf-8?B?bFZzbUNqelhXT2FEUThvTiswdElEVDZpVEQ0M1lNcm1uemxFN05RSGZEWnFz?=
 =?utf-8?B?S3l6NGJCL0lTTFZaeXdmdEp6SmcyZ1RQZktyMU5YNFUzV3duVmVwUk52UVRR?=
 =?utf-8?B?ZGs3MnVKb2duWlV2dVJRaThDUlV4cGI5Ly9sYXV3cWpsUTBFYVJDNkFqY3pL?=
 =?utf-8?B?b1poQWJFRzJYTG4rSFllMzltVHlYZGZkb2tEcmFCYkdxUEVOVUpVR3VCWUlX?=
 =?utf-8?B?emRYeGw5dEl3d1NnU2NkTHZ6dVJuNmtBaFpkTmsrSEtZWVJGdFVuQ2tMeVc5?=
 =?utf-8?B?TWF3VVUra1FDQkdwdFBUTlRjRkI0cCtSTktUR1h2c2dUV2c5cUNCUEhpak5U?=
 =?utf-8?B?T3k3Z3Z2MmU2V1liZnJabnBQdlJjTjEwOGpMc2VRaHIrYlovWDVZVWdST2xa?=
 =?utf-8?B?dyt3QmttM0gyKzdLN0tVZjRhTW4wdEhjWXVIL0wxNnNvSXZLTTFUQXRSSzNu?=
 =?utf-8?B?dkZneWJBMmRLUFpTNUZVQnE5TlZWOWVDT3lBTkYzUXhNb1NuUXpWOVBKc1FC?=
 =?utf-8?B?TC9yb0lLdWU2WUtpT0t6VjFqb25jK3BaZG1CbG9zVWorRDFoNTl2UEFZTldi?=
 =?utf-8?B?TVJrK21nNzBLRFhGcThwaWUydVZzdEFiTmRId0w2QVNQY3J3cUsxMEh1VEFZ?=
 =?utf-8?B?K0ora3pFVklXNXBPTkgvUGVJYWFaanZvS2ZjUFhsUlh2djI2NmVaOHR0eFpJ?=
 =?utf-8?B?OWd3eFE5bldDYmlZNEFsa2FwRStrbldTMFFoMWpCTVZZeHVGazJ4Tm1XUzF2?=
 =?utf-8?B?QXJGbTYwWDZucDZROUdVTTFHS0JhYnFCb3Qram5abGJzMjgrQXAvZG0yZXFJ?=
 =?utf-8?B?bmlkK2hhU2oxclcxMldkWmZBVkQ0c0lPUkE2QjYzb09zVGsxeWwxNENWTlly?=
 =?utf-8?B?UVJrMm9rdWVRQVBPMy9YRGpmWmxGK0hSYVlJSzloUEJ4Sm1RWmdqS21mMCtB?=
 =?utf-8?B?UlVGMFBkSkpzMzA0SmJrNHdBVEJPdGM1dWh5ZTQvRTlKWXFySXpzc2hOZGZj?=
 =?utf-8?B?MUNqaDMyckJ2bWxjdFVLS3BXcDg1NTdTb2JwWTRKcHpTN3JGTXNuM21tYTNO?=
 =?utf-8?B?S3ZHd2ZKY0JOeUp3Z3NTWkFlL1FxWkRiNWdCc1hEajIwTGppTm55akw2SGZp?=
 =?utf-8?B?YlJjNHlTK0JESUN0cVRMRTk1VU1SNHJTWXdIOVB1REVsVGNqb2ZIdUtQakdB?=
 =?utf-8?B?OGIvRVhuZi84L05GVVZzLy9tUU1WdGFaY3V3ZURFWG5EdVNDWjRIQTJjTG9Y?=
 =?utf-8?B?cit1MGxEVnZPb1Mrd0JONGh3NTVXUHJYRVpDVkhCOVRiUnh2cy9WV0J0Mnk3?=
 =?utf-8?B?RFg0RHArakcvcUtXT1ZTekxWUmdXekd6TVJMOGlmNHZ0dWhEUldrNkoyZmtL?=
 =?utf-8?B?L1pRWkptMU40R3NHOGVCeFF6WEFhaGFMajFCUVpEZ3lBekVaQ2NKKzVveDVH?=
 =?utf-8?B?aEpwSjhtOXdIOTd3dytyQVd5NTRjM2FPaXY3NnNGbGUzRjRBRW5uT2JiM3Bp?=
 =?utf-8?B?QU1WSWFtVkxOaktKNFB4dlZxN0s1T1paaHY0dFBYSWRGTDV4anEvVnVPbGZP?=
 =?utf-8?B?dnNUSS9lYmM0aWp6ZjRueWIyOUlmVzdIeWxVcjRuN2tZcG5Ea3R5UzVFcXlp?=
 =?utf-8?B?OFhPaXoxcFA5SWJIUG5iSW1xdjhaSmxzWUwwYkhrbkQ0dUlkNXltQ296Zmd5?=
 =?utf-8?B?L1MrU0VNb29UM2dmVUgvUmtSQWh4cUNlNXBwSkI5em1ldmJyTG13WHdWeU1C?=
 =?utf-8?B?cTNGRnNvNE1aTkcrQnBITndWMzZyZ0V5QnM2VXJ4UzFBZzRmaFpiZmpzeDFS?=
 =?utf-8?B?Qld3UjJrTlVjVUJtM1YrM3hGTmo0aUx4UkFpdUR4WnFXb0RhaVJyT0ZzUXN3?=
 =?utf-8?B?L2pOOXphRW5jak1YWUlmVDZxcEhKVTZKeVZkaU1UWlBxVUhOVVJZa3NCVmo5?=
 =?utf-8?B?MWsvcUo5OUJmNnVTN3QvN3NyOXlWVFk5bEpHZ3FDS09WSnZXVFFOcE5RUHcv?=
 =?utf-8?B?VExENEpZMVlna2tSYnp5VTZXZmxVVFFkb25TSStOaldZZ2Eyd3cyZjNEMDdW?=
 =?utf-8?B?eFNlRWRzMXYwN0tuc09GZllVNXVIWndxcE5wMWN4ekd0ZmRpK1kveXVMSEYz?=
 =?utf-8?Q?CIjPsXqmR7GjRATE=3D?=
X-Exchange-RoutingPolicyChecked:
	KGbgHX/Ibh4m1NJR5nSpBGhCKACuwQWcIfx/PxCPvlwUMzXX/o8cprIDvWMWgkwSi6agnjeLnN3CgjZYD273N7LWkZgaRYRgpblIgA8VCWJOSnTCAPSkwUxOtbAVKs+VBMfvpw5u1BfC3lHrdMQmQRTdbdSpPm8xt9DDF5bzjmda+jr3CiLMVVFiY6gJm8p+2SqASRaTyBfEE6shXckGT3k5dauCM9rHWnEKF0tgirkMUiRbDx/gcyXwjLWcVN63RdgSJpkYLGySIJZFhIpIF0kyfN3R5/P7uWCSgOS2imiFEET9G0bhBR2XRdEnrOqNZyk+pVQbmP11Zu+Otwsn4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MYuQLdlXtIlVyQf5y2MNklJCtLaEskiNlYF8jROpN/occXjBnJuS1PbOIMiIqWNld+BXpPEbVDHcAqkYbWmY0edn/1aRjZ2I/iw76AxJ3ALFELujogstiSDHt+0uWyDhbs4zdtbdJZo/xNm7X4E1dbCxOUMBRKaeL99qLgVbvMkd2RVVV9XY9kPQuhWBj1LxE7wfMy14NfqvnO6cCyaYND/6ay1u3ME8TcYcp0Qck1lrHwEMLTTbVeMSi1wq4U5O1nZUh2BCR0FQ9ngduGsb4YSP1JdOdyNMsGzBy+34izvdMo8S7K5XqOuaR4kG6XK/EDScO6J3G6Uer/Q9NM0CJclL6/tcJcAT8RCQLn4hB97VHdSNDqP7sildzQflNynwNYW7RjBzwnYJRmUyphsMiGVtcPgYLXloLkSb5EeZUBZpWp+QIe//zG6V+ywFO6HSIf3fnr6EDBw+zeDJp5EOeeY71dsNmdDCjneynLItze2IjbaQ0hngxG8hkQUR7FuEj97s2H49+nEtC4HrBUSl27UlZ4dLSoLm6jfyZeCsG8oikB+1S+RlfcEx8TPaRg8BfnqhTkZp6uDOGLXK+Jnkv7UomlR6zz/IgO2PjIteqGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe052f5-7103-4d84-aac6-08dee8a9d0cf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:01:59.1741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hE5wVqNM6m2cxCU5KiJgbAgZTiO9sYx/cuNexgA8d14JGaLXDLxxKONWNlAssywf8+SE1fdpsRmQJiXfvjo6mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7486
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230108
X-Proofpoint-GUID: dPDontLe0Lp-3XPMay0bbwnBJgzbunGU
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwOSBTYWx0ZWRfX3CukhYpIJMHW
 IvXzjlMU9QOy2ojqWgRQHP2aa6RpoAGJ3K6bi4wfIUrpkXwa0eHXif4Btj2Rvf1h9YybwBh9/CQ
 1Fu/20rFn0/ekdS6FAjjkfB67YDlbjMwH/pLRoQ9eaZcnCuzW633
X-Proofpoint-ORIG-GUID: dPDontLe0Lp-3XPMay0bbwnBJgzbunGU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwOSBTYWx0ZWRfX0VwqiL525kYt
 sNHccER5W93eRKeIcIx6XjULYQG1C+JEeo8kpjn20Gd4eTBsrLYGK3IHEFIK1JJThfboADLMuTS
 JkBzlWYxdjfhwFtjF3aslQ2xPhaiNYdkb2QE7GxIwiTWRocWUsKF0g8gaJ+ZQDs6355XVyWIVIq
 D8R/lTrEgUVYLVBpBxGeyTqcB7bPAM+PDoz7jFQ2NuFbQ3Ye0YI6deEO4Pd1BlK8uKE32K0SbdA
 u3QRyukVnbcz1qWBBzWN5p8tV5GMjkA59ULX0pjYv2gBKdoq1bNmnobczmLca8AaNA07fx19r4x
 X50MwI26sFwCl1rj4fp0dLxba2oZnCZ/N/gby63nSPN3o03FGxTZCLPE3NTm/LGjIaSRxK22o7w
 HY7494/h2tcxWv24yoX5r6HveBXj0j26wHJpbwDtJjtxGw/ZzjySC7S+BzaztsF93qa4SVzv24m
 GENrPzWp4znQTWuf21Q==
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a61f4ac cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=zduArGy0bOXgoa8-eI8A:9 a=QEXdDO2ut3YA:10

On 23/07/2026 11:33, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Calling mpath_synchronize() while the block device queue is quiesced and sdev->state_mutex is held causes a circular dependency deadlock under IO load.
> - [High] scsi_mpath_dev_clear_path() triggers a guaranteed NULL pointer dereference because mpath_device->mpath_head is never initialized in the SCSI multipath framework.
> - [High] Lifecycle races during device removal, initialization, or error paths cause scsi_mpath_dev_clear_path() to calculate and dereference an invalid pointer or freed memory.
> --
> 
> --- Patch [17]: [PATCH v4 17/28] scsi-multipath: clear path when device is blocked ---
> commit 5b8022a9b2f8e87d8f78b7424101ac5ed615cc6f
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clear path when device is blocked
> 
> Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
> blocked.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
> 
> [ ... ]
> 
>> @@ -2999,13 +3000,16 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
>>   	mutex_lock(&sdev->state_mutex);
>>   	err = __scsi_internal_device_block_nowait(sdev);
>>   	state = sdev->sdev_state;
>> -	if (err == 0)
>> +	if (err == 0) {
>>   		/*
>>   		 * scsi_stop_queue() must be called with the state_mutex
>>   		 * held. Otherwise a simultaneous scsi_start_queue() call
>>   		 * might unquiesce the queue before we quiesce it.
>>   		 */
>>   		scsi_stop_queue(sdev);
>> +		if (sdev->scsi_mpath_dev)
>> +			scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
> 
> [Severity: High]
> Could this lead to a circular dependency deadlock under IO load?
> 
> When scsi_device_block() stops the queue via scsi_stop_queue(),
> no further requests are dispatched. If it then calls
> scsi_mpath_dev_clear_path(), it ends up calling mpath_synchronize(),
> which executes synchronize_srcu() while sdev->state_mutex is still held.
> 
> Concurrently, a thread inside mpath_bdev_submit_bio() could be holding
> the SRCU read lock:
> 
> lib/multipath.c:mpath_bdev_submit_bio()
>      srcu_idx = srcu_read_lock(&mpath_head->srcu);
>      ...
>      submit_bio_noacct(bio);
> 
> If this submit_bio_noacct() path blocks on tag exhaustion because the
> queue is quiesced, it will never release the SRCU read lock.
> mpath_synchronize() would then block indefinitely waiting for the SRCU
> reader. Any subsequent attempt to unquiesce the queue would require
> sdev->state_mutex, which is held by the thread blocked in
> mpath_synchronize().

will fix

> 
>> +	}
>>   
>>   	mutex_unlock(&sdev->state_mutex);
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> @@ -230,6 +230,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
>> +       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
> 
> [Severity: High]
> Are there lifecycle races when dereferencing scsi_mpath_dev here?
> 

will fix

> The scsi_device_block() function calls this while holding state_mutex,
> but pointers like scsi_mpath_dev->scsi_mpath_head are mutated locklessly
> relative to state_mutex. For example, during removal,
> scsi_mpath_remove_head() sets scsi_mpath_dev->scsi_mpath_head to NULL
> before state_mutex is acquired in __scsi_remove_device().
> 
> If a concurrent device block event occurs while the head is NULL, computing
> &scsi_mpath_head->mpath_head will yield an invalid pointer. Similarly,
> initialization error paths free sdev->scsi_mpath_dev without holding
> state_mutex, which could lead to a use-after-free if scsi_device_block()
> observes a non-NULL pointer before the memory is freed.
> 
>> +
>> +       if (mpath_clear_current_path(mpath_device))
> 
> [Severity: High]
> Is mpath_device->mpath_head guaranteed to be initialized before calling this?
> 
> The scsi_mpath_dev is allocated using kzalloc() in
> scsi_multipath_sdev_init(), meaning the embedded mpath_device is
> zero-initialized. The mpath_device->mpath_head pointer doesn't appear to be
> explicitly assigned anywhere in the SCSI multipath framework.

it's done in sd.c -> mpath_add_device(), but I can move it to scsi 
multipath code

> 
> If mpath_clear_current_path() is called, it executes:
> 
> lib/multipath.c:mpath_clear_current_path()
>      struct mpath_head *mpath_head = mpath_device->mpath_head;
>      ...
>      if (mpath_device == rcu_access_pointer(mpath_head->current_path[node]))
> 
> Since mpath_device->mpath_head is NULL, wouldn't this unconditional
> dereference result in an immediate panic whenever a SCSI multipath
> device is blocked?
> 
>> +               mpath_synchronize(mpath_head);
>> +}
> 

