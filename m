Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399D639B945;
	Wed,  4 Mar 2026 11:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772622693; cv=fail; b=jyVtbEgVeTIg7/l0jQBtS/f6MEqw0VdWFJBQ4URc3eqFaSkPctuYbrHS2mtXA5lr2+S9knRLgmpX5d8a4gOhWn4uMB1h41CK5E2yTFvUe2JbyBiN99GXesPFO3mh0NdiOXPKU6uNMqT80UMYBUC0prbmeHc/0Z65qWsrVZ6O7IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772622693; c=relaxed/simple;
	bh=33nj9ugrTXSi8HipJ6IKVMKhfy6/o3x0qkyoGS6hgPA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GoBGP9JsOFX18OaiZAmDcXujlymUO8HpZLT/fKzKXJyzwIWCLKzSZTKCrH4iaSFrd6HeJ0fwHHM4PwMIhkzrY75bU9KwgFwdnB7OiYSlABE1DjDPqhp+YIbJlmLXWc/y/Mmznb7NvvW3LuFWIxNRFeZo5+yhZH3yKTPIS3Kpvig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e+Q6xP46; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TZ1laRzR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e+Q6xP46";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TZ1laRzR"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624AVHVW2304975;
	Wed, 4 Mar 2026 11:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=erOPpXdyfvj3ulWZDxLQvm6/vJslp5q+x06q33+LSAs=; b=
	e+Q6xP46uOlF3+DZnPYxCy42jt0/D3K0QzDqrBjb3F650dJVIOdDI+jZlhsAybWR
	km+WDzPa8qikaHczvYRVvHJKU6aqPt1kOP6WmUT8O0cstHFvvgnokfXSh84AKyIq
	5LpxwqMPcUzhljkP0ta3QSY54ZIIBORi2zS4r/bEs2aB/Wfji18qVytOhy/oFpwz
	tZ/ZEi1cHh8sAaI4Th/xUa6fENPIiMSYNRvVaJA0OmDbOGaKVQL8g4aRTqKCUshG
	eYu0jVYv1Fjc8UU9VP1lB+oT+6n+06obKZn5vPiOXq7yHJRkz0BxY5dk19Z7wYZU
	2PvSCVCHgaPC22t6sVoTVg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpk2cr257-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 11:11:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 624A0v3A037056;
	Wed, 4 Mar 2026 11:11:16 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbddct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 11:11:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSHx8AH/SeMLmfA2abAcqubntgBIUiuiQzBQulaKc9TS1VM5ncVpkKn8tafhw2GOMoLbi3/49pXXu3J/FtnkA5PHxurecK5eivMIbe2y/S+kWxtkseOxBY62RVd8Q4oolskkxzDsQUVnAU2nLJgPwproCH4aHhBkEOjVF65xV2ETxJZKv2jjMJQeeIqH8h0OnEmMErtP1CEgBZa3HAFqJkLMTOagOhfegb3AcXWPr89E7XgaQBCu9vEUsG4GFPcSLDxJ3ZfR+sMrH1usX0edWOb4BFcQPaQYQCak49ioPk+6XbzQWgyetbJDPkOKm5MPmBpfrokmw9Wg/GcqHjKu+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erOPpXdyfvj3ulWZDxLQvm6/vJslp5q+x06q33+LSAs=;
 b=X6vafJAkasDX7SgjgQGjj3llC3G1nbeihTPo6rkB1K3MoaBUTNRRaubz/aJFqsyZuLJPD2LfgiKcc0mf+hBJRT4z+k6Z1+tAgzgWN1WqeGFtAbY/tfRDMHm3zgzRn+zbvtkPbmLKEDTUTrBdzVKxgFuxkA1FwG2pbSq1TA/vlgl+XZ8jj4VYfq6VvbnCaMFH9MfX133LmfJz3WPPDMZYsNeiF0srarJd9ZaUuXbw/zOYTrPnq4OKgnFGncH8JqSu/La4Wuefx3wSYo/iVFExKppmUF9ILjTWkYrDqKikQTbtPz72nCCcKtcjGvbNoFhItIxQY0F1mQxtVrmWeXeeJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erOPpXdyfvj3ulWZDxLQvm6/vJslp5q+x06q33+LSAs=;
 b=TZ1laRzR54PoX5hOX4tHGt4IJStWV3L++QG/YlBuUM29Zswb9noW+EjrLl+5NDIicFOTnwMqYX7652EiRBL+A24U9+iHA7nfYdccK745tvAcx+x3gK2a/yCvgesAs2tdT9iRn8ZBNrKHaO7b3m19bOKULHhJ0SY1a5e8ww0UPPM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ0PR10MB5615.namprd10.prod.outlook.com
 (2603:10b6:a03:3d8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 11:11:12 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 4 Mar 2026
 11:11:12 +0000
Message-ID: <93752514-3225-4cdf-b9a5-e0964d693b5b@oracle.com>
Date: Wed, 4 Mar 2026 11:11:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/24] scsi-multipath: add
 scsi_mpath_{start,end}_request()
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-11-john.g.garry@oracle.com>
 <aafNnO6o2yoeLjPs@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aafNnO6o2yoeLjPs@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2P251CA0015.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ0PR10MB5615:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bc0f62f-c415-4c7c-2e03-08de79debea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	cIUBjHgZcnxZyZwDPSyhCs46e4bTLDOtLyFv5T/l+lGFrGLtcEwtrJj/Pct/G9pRH+VejYcgZyfboXE12lZG/TjGycO/v+sFK2vxNYcnxUqXTgW8D+7ku+7BcD0NsMrmNatO8ZC9BdkiaBVfNgU9Q8IxVNiCczZjmhqF80ZTbR0IYCmjoTpgKZrjyyV6cMuAauVUg/4khQ2MV6R7aRPanxX0aJ8YnoiDZLXUcwkH5Q00SxIqIB/F3EBxBvRd+Ons3vdYK0X4khy2ozsVVMDTXUot0slQYE3p9siSsDIA5Tb2COVCkbF5k/o5cHgGmzNmWXsE5BMy7MyPsFPH/NVUyBdE/GrfjOGNe7EUjkDf3fJJyYJk4Z1VqxWFW9X64oXtn+Gw1zWLJZsOw/23HL4GG5L75MB1c3YU2cQPsmEGHdSPiFQIyJORBKfcqdQa6P0hIVbJqKzNQ+pCE/AlctE5C1wzk60zRTmE0L9lHxDZwP9kPNp/C9b9HJjYlKSIr5RTrn1WL5jqJ6uW8ZNoL5nCqZZ77iJikzcGyN+QNVF3Q4pNksbqadzedH1DXJb2ueuX6ZP3hxAdlbQQnuwzCtup0utEE7WeYRRMlcIIUXOAoY/3Qz12413AMlIwAtmLvu8yxSXATZj8aEIu0H45GcvjH539bfZD2JWPJf9eQbnmXzzuHQNmNwLn4qL44GF3X9CM+E4ME85m2vNm5t9uM1N9gNbEUiSJp4tSHLRdbA46Btw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?em9GaE1QQW0rUGVjeWN2T3lla1BDZG9XVFRvdkpLRXNwV2FYdVBRenhjMFk4?=
 =?utf-8?B?Rzk4dkFLODhmekRTcTVkUklhUzZINXVucDJ0VzBiSTd1TGJ2Qk9NZzdTb1Jn?=
 =?utf-8?B?WEFzdTFyUGJaNFVGWGZHbEwzSFFJYVpROFhXVVZSSDBZelFXLzBxKzN4Vzdo?=
 =?utf-8?B?Vi81akhBamJwd1FEa0g5QTFTOUg3a3pzMk1VQUg1MFBSVGZ1TG5yZXdQd0FN?=
 =?utf-8?B?cWdySkhoWTNNdTVjbTIwVGFPVmR6a2hsY0xHbzIvVU1sbzA1d1lyYlNINXBs?=
 =?utf-8?B?SUtpb1lzUUx3ZVlqWVJpUTc0SityMHBYRUs4c1hYNG5zblovcW1pUlI2ajZt?=
 =?utf-8?B?eHdvTDEvUHFJdDMrMDk1aE1aVGRhaU4rR3pWbi80UFMxRHRwRGN0aEVLUU1C?=
 =?utf-8?B?THAwT1l3QUxNNEM3UU9WOGJwZXYzRTFUcDM1UVBOU3JSMW84bW9SR3Ayb3h1?=
 =?utf-8?B?QURBSmtVdjE5bFlob3E4dG16eVVtSlhyK1N1RlFRMTY0dHBzVTJqeWwrUjVy?=
 =?utf-8?B?NUw0dkk4T2gvSnB1SGpWaHlkdzNIS1FqRkJJVzRCeHBFb3AzSTN1UHRhR25r?=
 =?utf-8?B?b0ZuQlZSbVZLODRBcFM0RTBrWnNxZE5CdzBoVndEcERHYUtRQVFjcE5xc0F3?=
 =?utf-8?B?UDdiM0FCVkw4VVZJQjBpZllPS0lGUmVGaWZwQ0haS3BobkI4eVpLRHhMUTVa?=
 =?utf-8?B?ZzhWSVNMOXpPaVphZ1Z3MDhuNUIwRzZHVG56Q0Q3bjJTWWpPZnVyUWlidXBv?=
 =?utf-8?B?VEc2SmkwUUN0Vnh0SEZBMWIzTTF2RDd0dDdKS0ppSWRHdUVvc1NRUjMxaHVp?=
 =?utf-8?B?VFFFRVNnRDAvcnFDbTlWMGVGVDNPeTltbmMrdjNtUFRXeCtJeldFWmtydlph?=
 =?utf-8?B?L3IxUWhIL3BWK0dmMUhGZWExc1UvVE1vNXFlcXdrNzZ3dGdpai9HeStlUmN6?=
 =?utf-8?B?THVKeDAzUFh1SHNERm9BWktLeWZrMmt1OEVsbzhDMjhlYkpYcVhsbWtaSmlE?=
 =?utf-8?B?MkROK0daNFJuYlpuYy9nT3pKVXU2NHluY2VYdThnYzNKc2hoK0dRRkxMaUM5?=
 =?utf-8?B?U1RFZkdVakhDRURPR0pvWXl0bHhzSVJSMlFlc3pyVDBheGlWdys3MVpHazlZ?=
 =?utf-8?B?STZIckt3Z0NDRkNhcDQwa3lkWHVEQVVZMHhUSjh0WGF2eUUzVks2N245Znhk?=
 =?utf-8?B?RU9IK1BiR0pMbWZDODdDa0VURnQzaWtvK2VzTzFGckp3NStKRGJTQTN3TDF1?=
 =?utf-8?B?a3ZWQW1OZ08raUR6SXphcWVsaDRoeGVWd0t1NjM0ZUtLcGxZTklzTTdseSt6?=
 =?utf-8?B?YStib2Jqdythdk9DT3JLUjViOXNoVEZKS1ZsQm1MaGxMd1h2d0QwbDRzQVdv?=
 =?utf-8?B?NDVTU3RUSlliSEp6cklLNzJKc2hhWU9mOGFLZDJVRkNrRVRZUEZNRGtqT2NM?=
 =?utf-8?B?eEtOb3Y5ejdFMll0aUFXSkRiRy81RnVER0VPUStudk5VM29RWmtIdXJWaVpB?=
 =?utf-8?B?NWhDTk9va1RkMTVjTjZiTW1WbG9Tb3JKRllLMmRQWlNTZGh5TUpYM0o4R04z?=
 =?utf-8?B?eXdGQXJ2TURnNW50YUlCVzNmVFQxaTBNSUNFYTQ2dzdNQzFCUGxUWnYxbWlv?=
 =?utf-8?B?Lzlmdm0xUnFGSWlXL2tMdW16S0JoTWJIM1hzVVJ1L0dTdlYxSUkxQnN5eXNL?=
 =?utf-8?B?bDloT2R2dWxrVnc5cUZFMVhOUnBxdGFRZzI3cHMwVmJwaktYek96YXh0WFFQ?=
 =?utf-8?B?Vk5nalZNN09oZjJjU01jeFV2OCtZbzJTVVcyei9HWFREaUJkcUtUTk1EdU5I?=
 =?utf-8?B?YWljb3dreDA5V2Q1ZnZSNkU5UmlzVmhsb0pmOXA2ZGxOeHNQdG10bFdEZWVS?=
 =?utf-8?B?ZytpQW4vTmNwQUMrU1JidkdId21mWVdYWkRtaVl5RlZhektPRzdycXZmeXB0?=
 =?utf-8?B?ZzhtRTJOQWFjL1c0MlJzOW42K3U1WWJ2WWxrUE5WRkpERnN1ZGQwL0taS0dm?=
 =?utf-8?B?ZUc5STVxSnFjcHpJd1JZUTloVitsVW05dCthYWpGN2orZ3FoRWpabjNSWjEv?=
 =?utf-8?B?aTBVNE56VGFsK3l4RTFyblZCRDAvMVY4UWcwS2dBZFJHenBSZE04eEFHQWNX?=
 =?utf-8?B?bWtQV2g4OFhLQnFUalA1YmhTRFJXSEhRQWdnR2wwcWgvclBZVlpROVZ2S3Jp?=
 =?utf-8?B?K1d2R3I4TkppazExTE9OeWFhNDFKbmVvZUNYMnZlMUlCa09jbHFTSTMzSmMr?=
 =?utf-8?B?aUxyWXJqSWxvZGVMdCtDVmRkVUdoT2pjRkRhK3Z4REN4bGpPcFFhczJxSE5N?=
 =?utf-8?B?dTRaYkwzNTE4bnRVdmprUmFZK2I1VENHRDlSRE94aWxzYjBycWRYUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PfdcHqfU6HRE2+zL2730SvzxbG7aiyjpijz3Dh5RmXqbaIzCtfo4VOvI0+lB3TqR70nsYk4ExRPGb3nfGs44+ltdScQYImdoyo5INO/gHqSIMV3zQzKL2JQmDJakbDHg2RGCTmR4ir8H1iBrSp5qYcfmODIUFsTLpF3oQILabr7hUJoBtPZudlyDQfWeNBDTiq2VmGqK4e60j5Iu2aDIBuwQ6fk0OU5Df/So3nC5sYXu9emtb8EgLiCg5F+1JKkz8QvOSo17i8Q3y9N+fWFIXS3UAq/VWlGINBN+JXtAOn0nID1NxhsrePYqr18EyOg1CdMSnyS2Xf7kDixESqSfxOYoiOz6ektd+yR/cbv2XF6U8nl6qYxeM+uw+PeC5HUUvYyyEQOQsDoE87AObC0/YrvQ0N+hrpyPoS7jEQEsTiTCnWMBd0ZsykDlgpZKmHev14TMgy3ajlxPhZdww0RTCIR/8kZs1PqQ5FAsm8qfiisTXAbG1zV9hli511KabtiGVGB3BAKK3y45u8QvnHIGW+f1ZkvcWxfu1LyXUzCNpyPAuf6Yf/jq/TsIoBDosEdKfQgbWJyiDFiF73veJAPXstOdKuoP33BvN+f61T+DTjA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc0f62f-c415-4c7c-2e03-08de79debea8
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 11:11:12.3277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNWFctlneJA6ZuD0qNn6n9ai5hAbYSGP9wwqeYr6TUcsatVQRFWxDnMoEnBr6Iov5hfbwOJMBqwM9oGJjibBOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040087
X-Proofpoint-ORIG-GUID: XG2_6jeyteR0NTXBQr2GL6myTMA58bvB
X-Authority-Analysis: v=2.4 cv=Pp2ergM3 c=1 sm=1 tr=0 ts=69a81355 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=3pE51SaXZxqvooJhPy4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: XG2_6jeyteR0NTXBQr2GL6myTMA58bvB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA4NyBTYWx0ZWRfX8o6dJn9XUhOc
 Ttn/Xj90IqfPRnnxSmChygk0w9IKtOQkDAYWMXNPz2uvZX3wrr4oJnx3/9AVuAAg3p0rEru2Wgi
 NLaarQ1MvaLhOqFrCmjqT7v6pmoazmpl14aww4WVFsgFj4WOPWAatwcCxnlmGdURoaD03XN6mRD
 u9FNq/h6Eh5csNxgmIHZgwvkiYEYyC/68cnlKyOAz65SHmFeSGQLffG5k8RIttDl7W+GqqmJRGM
 rSkRiE30+fYzGJ93Rw1y/WkhVVR4Bt6v9E0OSLtQedl0cbNI9INRxBmnLFdF2vQXLD+5ChL4kNN
 VskcWee3Cv+ibOgHcsFDcEWHGziY0by15RL+E1ZCoPGkF0nqsHNAAfPegxwIsQOv/7nmAc7QhcY
 q6QYZWZD/DPsOOVeeeDoZNpdXmGK5osaEmKRQImSAqVPysSOZMbm2Hp9rmMtJeVSQ8u5vflVzjE
 Sps8POQftmZMCPUOkdQ==

On 04/03/2026 06:13, Benjamin Marzinski wrote:
>>   
>> +	scsi_mpath_end_request(req);
>> +
>>   	/*
>>   	 * In the MQ case the command gets freed by __blk_mq_end_request,
>>   	 * so we have to do all cleanup that depends on it earlier.
> This looks wrong. We start accounting in scsi_queue_rq(), and we need to
> end it whenever we complete or requeue the request, otherwise the
> accounting will get off. But not all requests go through
> scsi_end_request(). scsi_mpath_failover_req(), for instance, calls
> blk_mq_end_request() directly, and other functions, like
> scsi_queue_insert() call blk_mq_requeue_request(). I'm pretty sure that
> this should go in scsi_complete(), as well in the error path of
> scsi_queue_rq().

ok, let me check that further.

Thanks for the notice.
