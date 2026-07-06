Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF0938238A;
	Mon,  6 Jul 2026 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783351939; cv=fail; b=Zmi9xab/8WwwbnK9JX+brwBBGqzrelvMr8l7WIsCqL8ftOqyPuszyLChoq/OyCyYtHnAg3LpZHEoYq5IekRz0cg9+VcbIOPsiy2CuyecR38wt4ya6nBKuXw0VN7RGLyelOtRUbdVmB6B71gw/aWuGaFx5s7vrZLbglx0sb0mgfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783351939; c=relaxed/simple;
	bh=CHy2R9Ko9beKFfflD1J8mKKKMJMZhj+Qrhf4NW4853U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rMjluTHLZxx8K1A5a/WjM4hStduFjWBIKIVvYkjjItMGqo7bx9l5Hlxptk2Fi2R8A/yd8hLbv46mhc7WN/DvzjAz5MeCbmTsfjUHU5xQpm67mEZBl5L1iKKmdCEohukehG2cbFFX5PocKV2zCVd7paVSS0u0+JMAJjTmbwTGGQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IKg8Oa9W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RLnfAkSG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IKg8Oa9W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RLnfAkSG"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666FAwDm1420136;
	Mon, 6 Jul 2026 15:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0XIiH7yxbgrYtJQQqQN8olJTBpyngQMh0whgFnX2uNo=; b=
	IKg8Oa9WIJJlOUJTsF6hNPSu4A8jtl7vyDomu7s7xWleXubxTdZ1oHxAuRYrmqj8
	xENasX770122wsnwTVU16Xk4E5vnkK+EKWOPPByRmBtLBxRUIXwz2qKqzbTGLDc1
	ZFE1l5txQndcUXR1ZNdCb0kn4wQ0uTJeG/qWdV9PDyRzYaC1sOB9rsMJBflXStby
	Xqin5zWG3Esf1qa+5L+Psh8EUT/zZkdRc1L8Cm7OBfsojxtC/Og7D2/RcFYigpze
	KlGQF+swee2URTqO1ktRhDldjREqixs+Zuqet/zypNzMi+CjAYB7xoNl1NbkeiE9
	6Ui2LQVKqmhXthFjWm5zhg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6sssbwn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:32:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666FSVDX006916;
	Mon, 6 Jul 2026 15:32:15 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012002.outbound.protection.outlook.com [40.107.209.2])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmp9k1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:32:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wSkiUTTo8gEmOMMLMjqpyMfCu5qWn5jvgXlRXYFcWVb4Mt43+ijOQhcd7sQMZUmzQzy23L8MW7zIP57CZOJUrY38WaeT4hQ1BujQGyykIlLGgOHxYZ3CLHYTVYC/xQONRL9Z0dM62x+qv62nBGDnqyZ6NI2f4E3WhDr1P2/ug6oqOi8wiEfWljYDJl+fmb47yrjpMdfHkOacEOEjtx+I3LSjjvkNloIAk0bdfy86PJkkaPhsZLrs0w3pu5CCJXYWVWttfFdgHZ96Y5LLFkvkG4svw0Hs++DFBtzocv7Ln6Dm3IcsxBQZDp7naFPsq196zZdCMOSOrJNtnFl1LyDjlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XIiH7yxbgrYtJQQqQN8olJTBpyngQMh0whgFnX2uNo=;
 b=CwqcmHHYmxfhmWzI+4fUvNDAAKMmdNzm3K3nJYR98HLGvngr30vfXhDSMyVV3z3iYpnp73svVU5XssyqHZnA/0an4Z4dIN6/KBlSLYENS9CJ37cBU5kVbXrzxHuLCfA2fHwbGybaTIvcy/BGlkBPMAYBnSzKFu+IxGmm4rfB9J0lKJncOeGDZcXvlVPTwpH7pl5RQdT+PT5LBZhW3i3sis+fH6tagDexrdIqfrjVHrigsWzMdkI+FWA31i3Gv14XYZ0P67/H6cLfP1y9z+E5AOdMAXKKXX2CM4Tej8fxaTURuyv4spIrfeUxnDDVA/LX/zozE0i9N7l8SH3qEsdzZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XIiH7yxbgrYtJQQqQN8olJTBpyngQMh0whgFnX2uNo=;
 b=RLnfAkSGIkqkOdcsRpnf/7OYNHmTZmvN4RtOtDWSBWCXbK7f8QKeqOam4SShs4o9+z/21VFPIlqgYb9lb+wLJpScrtellJE+KG8u0RfzuHdbB/rYDtP5iay3n5i9YmgHMPQjzvx5Vzowm/Y3X18fWmsY8U5M1idgI45mtnVRn4s=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA4PR10MB8518.namprd10.prod.outlook.com (2603:10b6:208:56a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.8; Mon, 6 Jul 2026 15:32:11 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:32:11 +0000
Message-ID: <cec1f810-cfab-4585-88a0-385eb57f5c86@oracle.com>
Date: Mon, 6 Jul 2026 16:32:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/17] scsi-multipath: failover handling
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-8-john.g.garry@oracle.com>
 <20260703114052.6437E1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703114052.6437E1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA4PR10MB8518:EE_
X-MS-Office365-Filtering-Correlation-Id: 89fb352e-aac0-43e1-f776-08dedb73bf16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|4143699003|3023799007|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	+ijCL41kyGKQuQQeqlyG5cxsAM2gPeuilsrDnQjUiyPAV0TWW9VKIHalJ/WpezO4YO6JeXPmqMMKxCzZU/uk5mcctb2UPvMkwqJxVxIf4hsOdpnyypD+GnaGRITJagqh/Z6DanRJGdv9L3S9XbkVMc9XzHOhJQj2HsKPAohmnFVBnYVHM0BByXiiBfmDNefd4h/IWUsX/voZD+Gcf0Z9ei+7GSOSfD73UwEbSKDnJURP71IpTI7SoOAMH/nbUwCDpes+U+vnqxtFJeVUaOjUAqrrx3E4xodSLIQQxNjZ/ronQZU7LoJM8yeBRGz3M91XGOxRwNqfhY3YHeoNLoYmcU6w+TglG+PTbM9FX3289IzpMIpHuC7xW9xX7z2oOYAWmOxXbyqkMzwwBB+37WEwOS8lpdsqLRRKojgcO6n+IH9Ce5Q6fdj4g21/hHNwqGexiUixeoCvaAP65Caq7JzlyGBntN3zZbkfa4ud7VQWfSF/a49wCTcMniUXVgijCUZKnaQx1n3OEHhkqzheBT7pQWyEXURc6fCJ1xJN46GesFKOUwLU24PH/qkYS8Ai+cjHLVrKgyATow/6OdgnnvIrfq5BNWPpt/J1SBvyct+twALghI8BeVcnJWRwoIgE+JDCyBE9wRpjIPblvDQt5QEnLVX0Ej7cxmrbUZhskiAX83k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(4143699003)(3023799007)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUtIWCtPSkIxSGVmSHBBQjEwYlJFVDJITnlmWkU5NDU0VUtpRzVXV1FYMGVU?=
 =?utf-8?B?YXF4ZWYzdVB5OWJtL01FOThjTWRFbFRkVytKVTRidzVaYXc2Z1B0bWpSbzB3?=
 =?utf-8?B?Z1duRi9NM2swYTRVUGZtOGtqaXowNkRaUE1mcWpxRlFqbTZ3WDFmYTA2Tkk2?=
 =?utf-8?B?d0dxajAycDA3bytFMmxOOWhoWGVhWDc2V29DZlBuMmtsdC9tcGlDMVNuRHZq?=
 =?utf-8?B?RThUcjFjaHBwZ3RTSThLSmJvSS95SkJ4aVlKTnQ5am5hZ0hhR1VQQjhpRENL?=
 =?utf-8?B?RVhiTm83K3ZZaXVpMWlaWHBZZ05uWUsvbk5LMnB0MnNLUkhlSWxCLy9ybWJB?=
 =?utf-8?B?QUViU29xZnlTYlAwMUdNYmt5K0dnR0dqRzRROUJLSno2bVRGbEV4TGkvZlV4?=
 =?utf-8?B?RXd1Q3VENFNHRWpXdTNVTkhva0ZlSWpiUUlUdUxtRTdxOFNPRU5BZGh3S2Rp?=
 =?utf-8?B?R3FpVjBGanFSWVZuaUo2bGhIN3E3OHd0WG8vVmJEN1FiM2ZIcE9IZEpGWHNH?=
 =?utf-8?B?enZXblJCMFRsSWp2R0ppRGVINHlYWjJGR3NzbVZ4Nyt0RS9wc0kyNkhVR0wx?=
 =?utf-8?B?WTZFTG5MRUp4U2ZJM0QvK0Znekk5ZGFrb2FtaHIreDNpeFZ0SWxzQ3ZGVFBY?=
 =?utf-8?B?SDNoY1o3bldCY1NYZXlyZ0RQZHVwTzJ4NmFzSGQ3dUw3RlJOK1VkTTRUaDVi?=
 =?utf-8?B?N2hSbnBmQWwvenlKWEJIZHRGN2U0a1grWjJtcVdwbGpXNXdFaC9FNDQxR1cr?=
 =?utf-8?B?UUFwcG92MW9XN1BOTGlsTWdlak4yQkhIRytCSHQza2JqaWVTaTc3L01QcXpO?=
 =?utf-8?B?WUwvaFZGUHA3UTYwdzkybEEwL2NjZ1RDd2VoQUk3SVR3S01hUzZ5UjJTODN4?=
 =?utf-8?B?b3AvbFNWL28rS1loTjdSM0NoS1hFSndXQXlzQkdrWXM3dGtSSHd3UUMvdmht?=
 =?utf-8?B?SElXZi9vbEIwNjBWMldEcWxWUkVHcHlGOUcxSjV6cktFQUVydG04Wmg4UTl1?=
 =?utf-8?B?UUtrcXdhSTRscllCbC95UEJYWG4yNUdJMEI0amJ1SXExQ2Q1N3Z1U2MxSVZJ?=
 =?utf-8?B?dUQ1ajUrQnlldXNlME1hbTlTTjluREJWMHgxVUZzSnd2WnAvUVF6NERDN3Za?=
 =?utf-8?B?OGxpT0ZiYWZ1a003Z0ZiZEQweHZhcHAybUgxUE43NENqZHYzQkNncXlBaC9w?=
 =?utf-8?B?UmQ1dTdqRXNGT2JmSlZkZjR5dzBVa0lLN3lKaGdMMndIM1dFS0xsZ2hOazNk?=
 =?utf-8?B?aVV5UlVPRWNxN1NIUytkV2themFyMXRRcjc1N1B0eXJ4UitVaUpzZlpDRUt3?=
 =?utf-8?B?SDhFQWJ5VU1zenRFUDlwbHlNYmJqSk5yRFNzbjFJRzYrSXRYVGdMVDhQT2RN?=
 =?utf-8?B?d1NFNit2amtyTWhIdDEyd3JCVmRUcnRuVHo0d2JYeXI4UjhBY3FscUk0L0pK?=
 =?utf-8?B?TWszUGovS2t0azcvMGlDdkYyQnFPeEt5eVo5VXBVZ2JqUHZma1J4YXdyMXNY?=
 =?utf-8?B?UitzTEp2cGZ2SXIxbDd5Ly9JTzdrbEorMnJRMW1kMjFWeDZST0N5dUhkQU5B?=
 =?utf-8?B?M2ZaTmljQUNiUFU3blFwajA4Q1QwRG1xeUZubk5CYlFGYzBNWmIxNmIzM3BF?=
 =?utf-8?B?QWhzR1JjYW84UE1XU1RhK3dIa0NiY1Z1dk1DZXk0Y3V6am9DR3dSTGcwTFNG?=
 =?utf-8?B?MFlkVGE1RE1EcjU3ZE5hb1ZVLzIyWGFpMzAwSmdnTnJ0Y1dsWEpYWnVCNEth?=
 =?utf-8?B?eXVwODJjc2I3ZVE0RnJRdWNpTzFRTEovS3R3UDhOT1hmUmhJa2tSUG44eU9i?=
 =?utf-8?B?ekZqaWVySERkZnoyVkdXVDBRZC9LcUE0dXNYMXUwQmp2K0QrUjRCdDlKcmxJ?=
 =?utf-8?B?akNIbHYyalFhMWw4R2QxNzdxZkQ0SjNMTWtoalVsK0VxKzhMZUhSOVdJUTZu?=
 =?utf-8?B?SHRrMnFyWTVaeFBrWGhFMDg1MTZMSWVSejBQVTNXOG1ZbTZ6U045UlYzVEU1?=
 =?utf-8?B?dlRENGxtUVR2NFFQdTdJclV4U0FEUmVqMjg0TWFQMnliTnowUHlzeVM4SDZ0?=
 =?utf-8?B?VzFGZnV1NDlhMXpwcFY4YjlMVUNrdkhnOWxxZjgxc1Nna3NSY0tqS3JId1Vv?=
 =?utf-8?B?ZHRqSEQ1bXBoMXFSbEFDeGVpY3QrbmFTZzYwdnRnTWxlc0RzU3BZS0V0U3dQ?=
 =?utf-8?B?bnlIbll6K2xGelJqNFZ2ZnRITjFiL044UTQwOGZLWmd5bFFtcEl2dWo0cjQ1?=
 =?utf-8?B?VVJwSm1sam4vRHR4WnJBMnVyNzBIbGEzamdlQVJINWY1ZzlHYnVORE9hYzNY?=
 =?utf-8?B?ZGRXODBVMUN3cnVTaUpMb08xVG5tUEFocG80dnRmR09DYTc5Q1BhOHRDTkJr?=
 =?utf-8?Q?TXf7g2bfL8plA1Sg=3D?=
X-Exchange-RoutingPolicyChecked:
	Bt5IpE3ua/GwHfPnGDlGtL+pC1J7lUWI4t0RNyCyQsfn99Cf8tkzeUS5EE/5L9z+TPXhC76f21nNiIdqDVIjoym7gtHsJJrpt1455aYiDI/zRMZlXMvW3XNdb+KjYTsmlHMN+CeGTAVmvCLksi7ktmXiUKZOEf0dXvEyZrmStmOfdyWAwC8x5vIyYuOqxwVi3RB3SCjziS4WBiFOg6RDFHjL3JZMeKkF1rIdr6CaPIF55jD75qN+Du8tDJwSlDZrc0jWng+aAXN15Jpcu2fapadq0QZiEppqCwge6TbhtWNPX4SNWrmBuBGhcMqd/zVkc3qoaaplv0D7vaqxQkOTVA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tOcRrn8/0m7R9ay6sFp5m1JChwCyfISpxAeyUH2csKx0QziktIyg98Z4VBwJUip59V0B+KMzPQ3Lxov5kkZ4WZHu7xtCbCRQiHW9DhTqDJtZh8AJ0Y0JcSdMAh2MFeAAFaDQYS3tYguZb1IlG3gQvTQkxzArgeLYK8oVmVf8eannMo3bZMxN+x0QcAnR/KAVXQLxQwVtplJF1YLlXt8MBVFLRDNZr2HqH+jVctfnZKRnWp7heOfUiJuL4Kqp5SYpRM7baCKnn0DRks50miF1db8yd/6TJZcK5b9qVImprjCU3tgLLhnbsT9LvNuGjfu0saURycmKZstelP4p3m3s20EozO7h4PBehS9+eU/69WW1zm7Aswuds/g0DXYTFzTd5RdPSFZPHjwYjrrOR0zea2F+trOZ5hdzJrV+slVPFJVFVWi7kMZEfRPIOmjE3Blh85nyveFZGC4YsoxGEXtScV1oBtPPMmDVErhKchvzbWvcz5hpise/ZxxkFIkHVQnPfqO33me1TTFGiodxhiH7yqP08Z56Xe2bgKV1viibC2Qdu3IvFmpi0ZYsJEmM49dvkb3diU4SQwpDkTWoxupzMOol8KV8hvVG6NkkcSTCDBQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89fb352e-aac0-43e1-f776-08dedb73bf16
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:32:11.2755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JyM9Qj10gGH0c7NV1OwH4Skd00ROOb6zZwpLlPLorEu/oDgLusPeqCFx1pIFXEuBcxRVWkifeZGgzRk2wRr+Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060157
X-Proofpoint-GUID: tvuLUjZ0miCbCF7OZS5tIrsmK6sBP_3u
X-Proofpoint-ORIG-GUID: tvuLUjZ0miCbCF7OZS5tIrsmK6sBP_3u
X-Authority-Analysis: v=2.4 cv=LpuiDHdc c=1 sm=1 tr=0 ts=6a4bca80 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=dnnAxsMERWVMCPj51iYA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE1OCBTYWx0ZWRfX1FoRPfEu63b3
 6XYPICvuEzJwAvnJaAiuoAhfgs8BgXgWWXw1RM0Hgky33A6BpbEQ1MXsxx4gbxYwhb9ScVOWQ0M
 iuN7E6Z/zzHmOZI0VvXMMpdgwG/eAlIh41cq8jEJ52CrLx/dyMeO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE1OCBTYWx0ZWRfX1VF5ZQStSCP3
 3zhS1LDK6wvVOHNKeVtWzdfIqk/YDcRM2iT48Fil+rDz4DKESsX4UXpCNjGzWLKXX4FaC/7avdG
 9ZtfRfG8lHVwhCj9/aiyrjueZXUGQNjdFawAFv6jD38YXn1xCO/HODBKSsdJuUW2HCLlmc58KLx
 8Uho7qcd3vpTC+4TUKbEEj+mtwzwD9XWhm7vTN8Dx2FvzmrB+AgBjO06Z+EGjB1OPpC6ouLJzSS
 PjXAmq05UqZC6roCGNTLiKLGj39ZExiwaPpa7MAQQCvRB40XErdEMHuA3C4ghVilIJRwQZWQGaX
 Bgi8zQ4g6ymlj1ceS/7v+M+C5Yycr/HQWwHf1AHEkHPha46fJws9Dmi88+pwJ36xplY/lL6kScm
 m61SH7wiuM5fJYrGFi7eU9znIf4BPJOiV7D6xqSdcAWiamPxkZLviKAmSaKoGytz7Yl53w5ih4u
 njMNQWAZHN7RQzyOnPThwpAPzsbn5Zx/TW9GDnMs=

On 03/07/2026 12:40, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Unchecked dereference of `sdev` returned by `scsi_device_from_queue()` leading to an immediate kernel panic.
> - [High] Leaking a reference to `scsi_device` acquired by `scsi_device_from_queue()`.
> - [High] Calling a sleepable synchronization function in `bio_end_io` atomic context.
> --
> 
> commit 8a70735872bb7cb2125e8980a60e0bae2a38b040
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: failover handling
> 
> This commit implements failover handling for scsi commands that fail due to
> the target device's transport going down. It requeues the master bio of each
> bio attached to the request by handling the failover inside the
> scsi_mpath_clone_end_io() completion handler.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 0f3f3f9fa5fae..f22e3677cf2ad 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -242,11 +242,44 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   static void scsi_mpath_clone_end_io(struct bio *clone)
>>   {
>>   	struct bio *master_bio = clone->bi_private;
>>   
>>   	master_bio->bi_status = clone->bi_status;
>> +
>> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
>> +		struct block_device *bi_bdev = clone->bi_bdev;
>> +		struct request_queue *q = bi_bdev->bd_queue;
>> +		struct scsi_device *sdev = scsi_device_from_queue(q);
>> +		struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
> 
> [Severity: High]
> Can scsi_device_from_queue() return NULL here? If a path error occurs
> concurrently with a device removal or hot-unplug, get_device() inside
> scsi_device_from_queue() could fail. If sdev is NULL, wouldn't accessing
> sdev->scsi_mpath_dev on the very next line cause an immediate NULL pointer
> dereference?

will fix

> 
>> +		struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
>> +		struct mpath_head *mpath_head = mpath_device->mpath_head;
>> +		unsigned long flags;
>> +
>> +		scsi_mpath_dev_clear_path(scsi_mpath_dev);
> 
> [Severity: High]
> Is it safe to call scsi_mpath_dev_clear_path() from a bio completion handler?
> Since scsi_mpath_clone_end_io() runs in atomic softirq context, and
> scsi_mpath_dev_clear_path() can call mpath_synchronize() which might sleep
> to wait for grace periods, could this trigger a sleeping in atomic context
> BUG?

I'd like more info for when this is called from softirq context. From my 
experience we the failover completion call from blk_mq_work_fn in ... 
scsi_queue_rq() -> blk_update_request()

> 
>> +
>> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
>> +		bio_list_add_clone(&mpath_head->requeue_list, clone);
>> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
>> +
>> +		mpath_schedule_requeue_work(mpath_head);
>> +		return;
> 
> [Severity: High]
> Does this return path leak the reference to the scsi_device?
> 
> When scsi_device_from_queue() is called earlier, it increments the device's
> kobject reference count via get_device(). There doesn't appear to be a
> corresponding put_device() before returning here, which might permanently
> prevent device cleanup on unplug if repeated failovers occur.

will fix

> 
>> +	}
>> +
>>   	bio_put(clone);
>>   	bio_endio(master_bio);
>>   }
> 

