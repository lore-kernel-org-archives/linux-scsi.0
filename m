Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E455173186;
	Tue, 21 May 2024 11:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716292099; cv=fail; b=lgDhnM8GNwHLa2o+cUbQaYwIahtIziKmQahWaVwh7dYYwvS492x2k7Uiw+VYsS74ebSsQbmHlCD/emiverRaXlJLw6XK1Impr6lh/wADM/RKNE8FrwSV9T7UVykV+eV41LjVChkECzsujFF1PuhjlZ9wq/FS1ZR3d2SIQ05UUE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716292099; c=relaxed/simple;
	bh=bEa1TkrtqOd43/iCvhbZyGqI+hJefpGMh5Pkjkv126s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gjoEOuSTOj3nZt+v4HIV38nBypprDQPmdqwR3i6oeWpZlxGz/T0WL67jLoD4KVedHwBiNhW/IrByfiruzRCLDxDSEYK+hliiRneDPU1d1lQF0OnLZsg81ynt9fJVcxYWjLQEVUWnG0dzjmUStfvt54XDybFJToa5criEPFl/5EI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WDd2C73T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NHtRRvwD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WDd2C73T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NHtRRvwD"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44L7x5TH025839;
	Tue, 21 May 2024 11:47:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=EwfG6j3NFcThLcs5eNak9NREaIA9nzSbSntPGd/uvi0=;
 b=WDd2C73TrWc4AJP3/k3q41s8Xm4nd3uV5xkWplKocB0T3fcojga4S4dLReX60jAtakOr
 ptKe/nP1y/MpWC5Hqv2DieMjeG9M0102rsDQdsb6OCgBybA0B99OOLNqxcSn7klvejz/
 IcvAytz6C+MR+fsauL/i3AdFlw4fuZBi3GZIq7tkMIxGyM6jccGgQMVPHWwayW0quORx
 bRoQFIyB7OxBsJ+Noo+oRroC+tXkr10De6qfeoetYjKheuowZoroKkoi3CaeoTRgyGRY
 gXriXYQDwUrYoNDULVFQUCRC2R9R10Sw4xhd9rgrOXzAlnHtsauRgaAJJMa2M+mOCXmV Qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k4653tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 11:47:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44L9wgA4002693;
	Tue, 21 May 2024 11:47:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js7k4xh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 11:47:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXlLf39asHZga3pc/df91DYF/GH4TTmHr+oCb8yox3d0WW9zO90h1QM/UTQRqygjGvF0vwP0awILVQ+bspsiN/FRzZWa6MNJPK6yIg3rrNxw4bQNavAW63ubtiDnpePz6GIqMShb6i2PuhjqZyRqbl6lT0FnwhEgI8x0sK9t5F6xV3eAVDuTr9QYLuzdhr8e7wQ5Z99F66CsMlZivChLDXtVictRxreDMWo3jeRZn+S5dNya0dMOuqpwh5/EP+aYSsDSF42SZeqlEmjnPmOC2h8qDOWB8fu8RQ+FCEUgBonWU47uwCxcZAkDplefJznedYOF6UJqaZLqLD1wFR/hVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwfG6j3NFcThLcs5eNak9NREaIA9nzSbSntPGd/uvi0=;
 b=G6NvHS0E1ZTbWi+uaU2wfkBoCIK/+0WHPwjgjSOrmXIiyMLQOzpj+ARTcj1DtCkHSt+kNe/REK1uDcQc+Uwbr68k3aiuAPrWVQei/lnADW6xImlLrQ9SNeEh+ktqT7Antm4F8SaKz5EdGOdXvWmNosehTrE4lAakyrO5KrhkAJSBSQBtBZuGyhOoJ4KOI0K7RcdSzSMeI5NaDpreCSbUK8SKj/un0VqZuU2fdjcutp03Htz+t9nwOWRT7QwLACdLtAm5ws5QJT7VOS/H8yV7mgK99IUr2Vq00ap7wfXxTJFZDtv4/KM62i29roUWx3eh0fw1nVkUBzeunGewu/wgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwfG6j3NFcThLcs5eNak9NREaIA9nzSbSntPGd/uvi0=;
 b=NHtRRvwDb/jBf7Xrq/WK7+01H2AzAvHhXIMK2iaY0oDcBES4mpq2DCtLhiIl1g4EBzWggBE573/NjzMoTOJXRW5bE6tV7lqAq4f4lFHbIE3Cjt+COCTGnZ9/xFWJgq5UYC3VLhBF+JJY0O4si8zFXqd6f8/BwdJ3Eg2q5euaWKA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYXPR10MB7899.namprd10.prod.outlook.com (2603:10b6:930:df::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Tue, 21 May
 2024 11:47:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 11:47:52 +0000
Message-ID: <afa06fba-43b4-4068-9639-ef4a6dfd3cef@oracle.com>
Date: Tue, 21 May 2024 07:47:49 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        damien.lemoal@opensource.wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
References: <20240424080807.8469-1-yangxingui@huawei.com>
 <c1835d80-ca48-766e-c174-d94a2d357925@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c1835d80-ca48-766e-c174-d94a2d357925@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0006.namprd16.prod.outlook.com
 (2603:10b6:208:134::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYXPR10MB7899:EE_
X-MS-Office365-Filtering-Correlation-Id: cab91329-8fb0-4d0f-1d33-08dc798bd8ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?a2p2amtEeitSNEJuVFExREl0RVhTQXU0UU5GdmdaWkE2a0ZTNGh4QytHa25X?=
 =?utf-8?B?dlVuQVdGb1BZd1E3OVd3eGFLU2FubVhkVEE4VlpnbFJYTlpZNC9Wc2Y4T2Mr?=
 =?utf-8?B?eHdsM3UyZS8rUFFwSWQ3b2ZoMmtKSlJnYklzU2NMcUJUY3ZKeGZubTNXR0Np?=
 =?utf-8?B?NlZWNSt0OGpTblZVK3ptVXNoVS9YeUZOY01zNzlWUGVkdjlRV1A4N0xNTmdt?=
 =?utf-8?B?UmlMcGgwUUk2ZGl6RWZabHRPLzFaa3dCYkV1UDZoaStVZDVvL3ZzSGZic1Vh?=
 =?utf-8?B?T1UxMzg3L3lwTUloN1V0dXgyZDZrVXN3cVN1QUZsNCt1YlVORFdScDN2bDZG?=
 =?utf-8?B?NjQ4MFlpRkVWc3Z6bURYcml6ckhXMnNWdDJaWFlBK25wN09saGtlV2JDUmpN?=
 =?utf-8?B?ak5PVVY3SEgyQnAyYXVOSUVQczFnVDc4alpOZWRXci9wYXVlSUdzanNSNUlC?=
 =?utf-8?B?OTlRbGg5bGozUTBIa0xOTktnZGxUMUd4Rnd3R0kzR0NYNEw2b2RWUk1RR1Ez?=
 =?utf-8?B?bk1JU1N2WXM5Q2tJQzh3THBpRWlGU2s0YkQvUnJQcHAvM0hFOXErTEQxeHhP?=
 =?utf-8?B?NmFTU25oNUVtMHg4cG91OFhjMGx2N3VqRDFhd0ZSc2lhUGpMN1lFcCtheUVt?=
 =?utf-8?B?U1F3dXJUcDF2NGxBb0NZMDJmL1E0TGJBK1VsUVAzenZjYU1EMXRCeHhydnNj?=
 =?utf-8?B?aEtRYk9XSGhBVTFrVHkwSmlWd1RDdllHa0c0ampZSGtDMnhsY0xZMURFclBH?=
 =?utf-8?B?bjdyUFVpZDFsZGxPcXlqNkJwdnJGbXgrZUtTVnhFbWFEUXJ1VGYzT0NYQVdI?=
 =?utf-8?B?L0Z0V1pUMXVMSk4rU3pzSGlocFYzaW9uRWZTU3JVaFptNkMrYzhSeWQ5RUpn?=
 =?utf-8?B?cmpJTmFkZnlCVnRDNFV1THA2L1dvRzVvVDJ0V1N0aThTTlhNc29aUUVPb0hn?=
 =?utf-8?B?R1N2aTE0RExSY2J3eUJUYWVwRlRNaitERFhKYUFnbFBKMm55c0FudUZZWldj?=
 =?utf-8?B?VGpka2JVSml3emdZRytLeUliSm5TTGVyamwxS245SjRQbDNxMTJxL0tiZGlE?=
 =?utf-8?B?ajFLZExzb202VC91dmplNkVnT095NGh1UG5UREpDU0o4R2JOajlJTmhMRVM5?=
 =?utf-8?B?djJuTnJ0Zm51QlVPOUsrVSsycFhMRzVhalFuRHN1QzJYZUJMOCtrMGxGVUJQ?=
 =?utf-8?B?T3RLallka1pMZ2puK0syVFcremJsT1RPWHFxNkxKZkRFajljb1Z6MFVvRDlP?=
 =?utf-8?B?OXovdGRRT0xyQ0QyQlNjTUxvVzhqYVpNVXdSQ0xLTkVBZEZiQ0VmNXJkWkVI?=
 =?utf-8?B?bUs3ZEk3amxjT0Nwbk01Z3ZZZDZrYzMrWG9Ed2hvZWd1bkdLRFJKN2V1RU9W?=
 =?utf-8?B?VXRRYmhuSFk4L1YwNVNBaW93TUFQRTVmNU84dFpxY1R3cFdaRzZOaittOWQ0?=
 =?utf-8?B?K01USUUyMjNJcCsrVVNUVU1idjg3b0VYUXZ1MzdsTlRhQlVOUFRrUXJUWnlU?=
 =?utf-8?B?dS9EeXNCaDRwYjJvdHdCVkpodXhFTWNtU3Z6QklrdFFibC9HR2xPOTRFK0Rz?=
 =?utf-8?B?cktNM2NLYk4yUXU1ZmhNSkhZL1J2alZYeVpqc1NyNUk3aVNuMGZqKzFWUUtR?=
 =?utf-8?B?T0pCdjV3ZUtNQnNzZXk5UUUxQjhKblRoWkRUb3d6eFhybjFEMDNpS09QWEVD?=
 =?utf-8?B?b29PTXN6TllCSk4zRi9Hc1FoVktWRVdNdHA5SEJaSzN5NDY3bnlOL0V3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SWFkUFo4WW1ncUMybEExZHdlU0l6N2tNR0prckJnS3lEb3gwYk10U3FlL0pM?=
 =?utf-8?B?bnU1enFaRCtZYjZ5Nm5mSHdTYzJMekUxNmxmQnV0R3hiVjlHbHdxVDlJUHdY?=
 =?utf-8?B?M1MrTWRvQTVOUW5TZGRaRFhQempLUVhGVHdBb0ZEZVU4Tml1TFBSSmx4dzQ3?=
 =?utf-8?B?RktWYWEyVmdJNGs1MWZiVy9COVlQSkkzcDBrSUdsOTJ2dW0remlYeU8veERs?=
 =?utf-8?B?cmNYSTMyQzdMTjNqUE9QMHlQdTdVdGtFbURjUS8xTWlJRFQvZTZpaVZEQ2R1?=
 =?utf-8?B?M0tPSFZ3djBGM2syb3VUdTBaSE1tZkxrbHBqeVV0Ty9JYmovUjdJMjRhMjI3?=
 =?utf-8?B?Z1pYc0dQS01Dc1c0Wm5wNU4yU2dzRU9WcjU2QjNPM0l3b21hUWszS1dPNHFw?=
 =?utf-8?B?eGhiZndzeGFHditheERUY0dYeUdrSU1RQlRma1pPQ29lN1JjNGQrVXRkMDdp?=
 =?utf-8?B?akFpUXNEaUN3aFNZV2M3RkVndXV6Y3FWc0Z2MHNiL0NGeTBGaUZHQWpocG40?=
 =?utf-8?B?UUdEa1pzRzFTZmVNdi9VdzUwZCtnYWNyWHExNVI2VVNyRFpiSWthMXNzMmUr?=
 =?utf-8?B?YTRNYWJPNG1IY0NnVUFIaDNZWjFsS2Jxc2xacUJtK1JhVExnaFpKQWduY2kx?=
 =?utf-8?B?ZEErSHk3NDZSVWtYdkVEL25YMStBbU00KzFRckduTlpXS1lEY3VFMjBiQ0hw?=
 =?utf-8?B?ZjB3aWRIOGcxR0J6cmRDdGh2ME8xRTB2UkRCU1Z6RTlDaXNSb0dWczU2K2RO?=
 =?utf-8?B?ZTNlUnE4OElnMDMxN3FQa0doTzEwdUVZVVFFcWZxSTBHeDhYbHMrSEZUMlM3?=
 =?utf-8?B?QndDbU9lYkJmYlhKS2VTMDNCUyt1Vk54Zm1VRDl5NFBEaVg1NlIrQzk0RWZP?=
 =?utf-8?B?WUFLMExEREVuQndpM2djWldKOGNPZkNvNUlBZEs1UGl1elR6bGxYY3Zaa3Jk?=
 =?utf-8?B?MTdLZ2xjSDNkUkdUUnczNGhUeEt3eEh0MUp0MXN3RVRZRXVkR3JqLzhGb0JS?=
 =?utf-8?B?VlFSMGdhU3ZnTGRJd3dQbG9jRmNIb1BtbXlQVElnNDRnR3NUaXRKTmZ0STdS?=
 =?utf-8?B?cU0rcGJNZGIwL3JiQ0drRUkyUEFpc083bTJUNEd5c1BIRVBMT0hZZ0FjeTVj?=
 =?utf-8?B?WW5BeTBJTEVuZkxjNC9KMndDb2xlVHk3b1llR0lYMlRJZlVTcDRhdjVITmp6?=
 =?utf-8?B?NytyOHlUbEVxZUVxazQzTlFpOHM1TnI1UnEzc01oL0xnQlNVQmlNNGNyVkFn?=
 =?utf-8?B?ejNVZFE3Qnkra3FrUFkyN0RHY2tCSmd5eFhYQjhDRE5wRW5KV0p4c2ZuVjg5?=
 =?utf-8?B?Wis4R2NBaW1RZjVZNi8rSWF2RWtKNEcxN3NMa2Mrd2x3Zngwamd0NDBzRGJE?=
 =?utf-8?B?eklHUGZuZDJIemU1Y3BkLzIwaEVsc1dUVHVhS0RBRllDRnBkMDdSNUZTNktO?=
 =?utf-8?B?LzdUakl6K2RPZWNtVXlrYytKWEw1eXMwR3EwYVFZQWJ6cjZDUk0zUlI4WGRL?=
 =?utf-8?B?end5UElRbGx5SkJ2bUlINndaRWRUbGI0UlNlVXJhT3lzWmUzN0ROSmVnUHcx?=
 =?utf-8?B?T1FlU0x2SlhDNm93REpBMk1DOCtNeFlQOUlsdCtEanNoeWY2bUtIRWtVd2dx?=
 =?utf-8?B?eXZZTDROMUFsdXRUTVcwcWs2eG1TM0hpbzVwRXhCWXZkaFRuZXBpQW1JNTls?=
 =?utf-8?B?R2YyUGFZclFJSm44MENOTXBxSm04M3pIbDI4RWVURElZa2tJUWdnS1pVblRT?=
 =?utf-8?B?SmQ1c09iUWlDSXRDMjJ2RTB1cUJFclcxVVRQOFJiM2YzQ29uYWhxeEJKRk5E?=
 =?utf-8?B?eWx4S3Q3QXdVUXpOWjdlZlI0WncvWWFZZ0VnZVZBU0ZOK2xVQUpOUUtVeXE5?=
 =?utf-8?B?a0dabWtac080N2wwSHZGOExHeGZUVkNVOUF3d2pVZUgweVJ0NEw4ano2Qy9G?=
 =?utf-8?B?RGVlcFpJYWs5VDhIMURJUWRtRjJmejJ1eHkzcEJKQy8vVnR1YnFBYnNHOHU3?=
 =?utf-8?B?Nms1c05aRDdSKy80U1Q5bGJEOFdWWTNoUkdZeEJhVUQ5ejRxMWMxK0FNd3c3?=
 =?utf-8?B?UHlIdS8rRjN5dWYwU0dsL3ZVTDNTL3lhYXRpWGVsWTNHOFJkcVRrVUJhamV0?=
 =?utf-8?B?cWNDZ3BNcU93b0dmWDZKL3J4NnRqbm1qYjZzZ1RCMm0wakJLemxLMk9kdlBJ?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	m5qNL/glN4BXW8vmzzqvjllBY3CqYkq58dbPrkz4Zerolj3NwR7xKJTgn5VzViz9ngWx1r9KbvObMWAZICRT5OFzZkUeFU4mxFgkMTcFtjgidoFOiPr017MJfSti9cCRyYHVXYmHNLLWza+sn6+H+D80i3p+ehZKE2EuOcTYCIYBOa8Kusbheq6FaM2pmdpSEj9t2MtI+ISVwGH8YN+Imfra8uiTn7CAQ7ISXYN/FtfMX6PjyrMk2V9NvkpywRpI7UCyMB6Hg0jRwXRG9tYxPkd45VXd+KzCVpgfOsepQnBXH7XIYroLHsl/i7x8ihK4sfd67Mj4XCSmR3iOH5vDHfj+5avPpSjQJvSLWNx3rd9zqPwd5O+cCVhLqwOQVRcqDi46vawy6NPsbg+1TKV1g5B5mV9nLxWXEw/Tav/XuTo1UQYUhKE6mI6QrMYVVfeca29gsJBblFL1ic24nDMTYMF25x4JUrsZjye4q6Xdhaexx0hmnGivZQQEJ25pvP7ZttYvS/LiL6IWIjo01A82grkGnbtRT/AbjvAvlwfZhxpIx25VRZM4FxRb53Io32JQnSM63UhGob1LXJbGA0/+qmNS+PqUyDl/6gSstGQbXQk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab91329-8fb0-4d0f-1d33-08dc798bd8ab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 11:47:52.3418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HiINGvyEso3uq6IJQKsfBaXXmE0gnSNl7kOL2J3ZK35FY22QU9pRlRoNpr4HZXr/nTcCi99B/nyDBtE1z+o+HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7899
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_07,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210088
X-Proofpoint-ORIG-GUID: S1flwL1-z1w2J7rQNp9wQU3COzZT8yhq
X-Proofpoint-GUID: S1flwL1-z1w2J7rQNp9wQU3COzZT8yhq

On 20/05/2024 09:29, yangxingui wrote:
> Friendly ping ...

I'll check when I return from vacation in a couple of days

> 
> On 2024/4/24 16:08, Xingui Yang wrote:
>> We found that it is judged as broadcast flutter when the exp-attached end
>> device reconnects after probe failed, as follows:
>>
>> [78779.654026] sas: broadcast received: 0
>> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
>> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated 
>> BROADCAST(CHANGE)
>> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
>> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 
>> 500e004aaaaaaa05 (stp)
>> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
>> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>> ...
>> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
>> tries: 1
>> [78835.171344] sas: sas_probe_sata: for exp-attached device 
>> 500e004aaaaaaa05 returned -19
>> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
>> [78835.187487] sas: broadcast received: 0
>> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
>> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated 
>> BROADCAST(CHANGE)
>> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
>> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 
>> 500e004aaaaaaa05 (stp)
>> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
>> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>>
>> The cause of the problem is that the related ex_phy's 
>> attached_sas_addr was
>> not cleared after the end device probe failed. In order to solve the 
>> above
>> problem, a function sas_ex_unregister_end_dev() is defined to clear the
>> ex_phy information and unregister the end device after the 
>> exp-attached end
>> device probe failed.
>>
>> As the sata device is an asynchronous probe, the sata device may probe

SATA, almost always capitalize acronyms

>> failed after done REVALIDATING DOMAIN. Then after its port is added to 
>> the
>> sas_port_del_list, the port will not be deleted until the end of the next
>> REVALIDATING DOMAIN and sas_destruct_ports() is called. A warning about
>> creating a duplicate port will occur in the new REVALIDATING DOMAIN when
>> the end device reconnects. Therefore, the previous destroy_list and
>> sas_port_del_list should be handled before REVALIDATING DOMAIN.
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>> Changes since v1:
>> - Simplify the process of getting ex_phy id based on Jason's suggestion.
>> - Update commit information.
>> ---
>>   drivers/scsi/libsas/sas_discover.c | 2 ++
>>   drivers/scsi/libsas/sas_expander.c | 8 ++++++++
>>   drivers/scsi/libsas/sas_internal.h | 6 +++++-
>>   3 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c 
>> b/drivers/scsi/libsas/sas_discover.c
>> index 8fb7c41c0962..aae90153f4c6 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -517,6 +517,8 @@ static void sas_revalidate_domain(struct 
>> work_struct *work)
>>       struct sas_ha_struct *ha = port->ha;
>>       struct domain_device *ddev = port->port_dev;
>> +    sas_destruct_devices(port);
>> +    sas_destruct_ports(port);
>>       /* prevent revalidation from finding sata links in recovery */
>>       mutex_lock(&ha->disco_mutex);
>>       if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)) {
>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>> b/drivers/scsi/libsas/sas_expander.c
>> index f6e6db8b8aba..45793c10009b 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1856,6 +1856,14 @@ static void sas_unregister_devs_sas_addr(struct 
>> domain_device *parent,
>>       }
>>   }
>> +void sas_ex_unregister_end_dev(struct domain_device *dev)
>> +{
>> +    struct domain_device *parent = dev->parent;
>> +    struct sas_phy *phy = dev->phy;
>> +
>> +    sas_unregister_devs_sas_addr(parent, phy->number, true);
>> +}
>> +
>>   static int sas_discover_bfs_by_root_level(struct domain_device *root,
>>                         const int level)
>>   {
>> diff --git a/drivers/scsi/libsas/sas_internal.h 
>> b/drivers/scsi/libsas/sas_internal.h
>> index 3804aef165ad..434f928c2ed8 100644
>> --- a/drivers/scsi/libsas/sas_internal.h
>> +++ b/drivers/scsi/libsas/sas_internal.h
>> @@ -50,6 +50,7 @@ void sas_discover_event(struct asd_sas_port *port, 
>> enum discover_event ev);
>>   void sas_init_dev(struct domain_device *dev);
>>   void sas_unregister_dev(struct asd_sas_port *port, struct 
>> domain_device *dev);
>> +void sas_ex_unregister_end_dev(struct domain_device *dev);
>>   void sas_scsi_recover_host(struct Scsi_Host *shost);
>> @@ -145,7 +146,10 @@ static inline void sas_fail_probe(struct 
>> domain_device *dev, const char *func, i
>>           func, dev->parent ? "exp-attached" :
>>           "direct-attached",
>>           SAS_ADDR(dev->sas_addr), err);
>> -    sas_unregister_dev(dev->port, dev);
>> +    if (dev->parent && !dev_is_expander(dev->dev_type))
>> +        sas_ex_unregister_end_dev(dev);
>> +    else
>> +        sas_unregister_dev(dev->port, dev);
>>   }
>>   static inline void sas_fill_in_rphy(struct domain_device *dev,
>>

