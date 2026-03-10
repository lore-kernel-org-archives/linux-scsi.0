Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0336736EA8D;
	Tue, 10 Mar 2026 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138338; cv=fail; b=ABEgHIqDmSUG4H5NU0hsqONuSAmpiRu4zWFD23LkjlJrj3XYAXwxODhMrg5qzjull3klpnhoXJRUiqejMeaD17XAfPFCzpl2bRtcSgIm9hsFIOY7/9Gv4oyb+39Nur8pXnKdeEXSLVlzBN3cAObhHQ5AG2/5l01/28iZuSSpucU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138338; c=relaxed/simple;
	bh=Oklq9UNcubMgFaPiDsh2ivUALLoejyNuwv+ZoAz0LO0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QH24lcGyUqS2vjilbRoCTyylpBCrpxqfFMrQeBSUTyJO+nWRSIDoGeQf+r8x6U722gWROntNtfyUugLZJXM024cecl0k3SRNio1+hfOU8x7Dw42Eym3B3jxpQpq0FbKVO4jkHj6o5X9/Wv7zHlKLihqLcRix1yUdkwlsCWPvDG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=beQr1+jZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VQp84n0H; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="beQr1+jZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VQp84n0H"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9x63K2773031;
	Tue, 10 Mar 2026 10:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=06yP1WaNKGA+gb6kLB1c1Bo+b9r3UB9ZqAB7UiR/R6U=; b=
	beQr1+jZwhgvpz4f1ZeRORLuvWKH0F9u42+VZkT5l5qBv8yAo1gm0euxtRdPOeY9
	gSyTOhiOAAFllDVw2a4BH3lW3W48BqWXUUf2EgdDgg15QBfk2HCVcE2eEfs4XM0h
	eypkkNsOMO/gpLkGj+dBq2UIOvmCcrGgV12dd1dKb7/ScuBwln8HbH0yp0mlVj3b
	tmllU+sQKZB8VnClZ+dDSa9nYrThdMba4Yg3JXPcx1sncE+syOehxvhTHFw2N5yQ
	fsE8mzuoQTwIVuEOTIEoR+vd4Tnx51hzAvs84teDppG496HMrl7JyUhY7Fd1XtJT
	ojFBnVE1r3t3yzC6gZof4g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csjnujkbu-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 10:25:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62A7vkPn014822;
	Tue, 10 Mar 2026 10:12:17 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012051.outbound.protection.outlook.com [40.107.209.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafe535b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 10:12:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WjMYm7fXxnls6uZuyIK93NWtQl1ohJh+Wtd7/r8gUSqS1aIQ5iNa5gEgzFRHeg+ZJ052UgD8Ck0rmnV87qDrCQarBvhILvFdR4VU1sr6fpEI8FGYtCbn/oUtmFyY2DXAv1bSWLGczYlMD4wdn4vZTUVFWpcs7d4Aoz/8g8Ccp8D3+g1yXAvamYuydNNlTTVt+fLT8aJtPjJWZ1M2eQu3C4RCz9M5vJCfWb34zvv94fN/Ye7wF9fUUNimRzcVYZH6j6qN+Uexw59ArVrxBigjILPzNAdFc4vX05BuOSefedtJ2BsIrO7sSCOVnTNGMz5qa1PNLnTI28nMLFsyHIfCRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06yP1WaNKGA+gb6kLB1c1Bo+b9r3UB9ZqAB7UiR/R6U=;
 b=VeQ2b4sqlf205ttFWZKB+deoWTPzEvJ8SK0vk6DSF4HWkjC9b4yXS6ads9UsFSes8zsDFFDUKRjlOsNPHWdtfsl+tSNSKWwUeWqsWTjyEokkeykIUwYR1yE38w0SvuCtxXThRUPMSNDFuqi00o+cHbKfgB/uu22TbdAh4REC7vpYOj59ntcn1sz3HyAAoJ6E1uGVTKfiqpCeCzFYDyVUwMQQK3UaSJOa3bKalpJDaVgB7LtfDQtOLZ/++ZdlUhIdr9Zy5wGDHG6Ad0ST/ZZhb8/MM0E1ZEXWD0ff8qcUCk7nGF4Ec2aQ8nz6309WnlYgJjneVrDWZkBKkVSK3bcTaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06yP1WaNKGA+gb6kLB1c1Bo+b9r3UB9ZqAB7UiR/R6U=;
 b=VQp84n0H9+W5t72gqsQuXqJ4JsyPgeo6hjzsh2AyaC/IhytMWv64DbG/bnMU2Bb50vPZxTxoqKVJAUteNcqAMf9lLpt+W75jvgGP591DEWXGLI5fmxWmIBQFn+yNPTCNbB0kYZfIFsjcPkKY5v4ENKoqBtnBWZbY5fS9I/7229E=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA0PR10MB7641.namprd10.prod.outlook.com
 (2603:10b6:208:484::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.24; Tue, 10 Mar
 2026 10:12:13 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 10:12:12 +0000
Message-ID: <c204b634-8df8-4495-916b-1209cbd869d6@oracle.com>
Date: Tue, 10 Mar 2026 10:12:07 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/24] scsi: sd: support multipath disk
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-22-john.g.garry@oracle.com>
 <aa-EtdqIOX603PVu@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aa-EtdqIOX603PVu@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::6) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA0PR10MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: 20502a42-1d6f-489b-bdd9-08de7e8d7f0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	bEqQnKzF42Ia5krDZpsuhXhmrI2pbqL5Es2WLLeQKNcZzjH4kA6KVpjOYF57hcsQ/K+KApBMnH3bQXDQNPISvCziaZCNF3ybayvIaIh1+phe7e3ZYqUMhrsqZEs7GyEG8irJGn0byM+FMLcVLtRSaKyg57DyAZ8a/KN+W6zNhWoK5h6pkhiz00AqCBGTeWX6fcvlXNwKObj5CAqdG+NBEx/CSRJF3RSREfRDA2P+QPBrn5Pd6X9ezRL4sq/cLUVOAT1WpQwURlXZ8xJNg5QYKyLBmz/Z1SPvTgNQGYPNYmkyCIr+lJ2vB8AIc+87fewDJ0XGg+t/ZAKJw7O/h9qfEQnvztvzqC/SVgVGDOHOqU4JsVPyexA1c/wXr11yAZ7nvMbuAkDPY0S5jaKuB01Upm7df4uavwp4xOZEdQ9NE9gJUlkgCBnA9Gp7o4vSRKRpldocqs64fikA7ZIUA3ZfNO9s2AWcq7x/vUYdCJNi4ULLBpBWL3ezkp5LrAF/pvQjUmMLToruhrz1hYW2/VNVgZZhyRdu0auA5Ka6CFdJzsm3MW2V8LfbewZ6e6c+rh08pYVHNfpTGOB6EZZPU6muzYpr6N8ChxV8O92zWmsluL+0cA4NY50o2cocorDmewty755qWVwidIdjd8dtpMA0rYou3KAw82+OmzKx8Gt1ZHlwALalol2pBRYlNg0YfADQ7lk8Uh6yRU/YzsnGODDPAiXr8vOltvkbXsnq32ihN1o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHU4NkRCZUREUExyU1U4VDNwSndWNS8zczNqNEdTUnpodnVKK1QzS0hYTEdk?=
 =?utf-8?B?UFZuYWxqMDhNWGJKRU5JM1ZzelF1K2VkSEY5Mm9USDdTNlRZWXgxSzlabXAw?=
 =?utf-8?B?SFJ3UzdKNmFpNUZxVUlrNGxVQ205d3ZyMG8rbzlDcW9hWlltcmhlS2Y0eUVV?=
 =?utf-8?B?K2x6aVNkSkFvbU1zMllkSE5DdW1peW9VWVBvS3JCTnNLTEplSm1XRlFPTW1G?=
 =?utf-8?B?S0RTaTA3ZERFM0xGYjRVaE5HN2lObitDdmZTMkk4NWUvVnc1OHE1YmZYNnhC?=
 =?utf-8?B?UHZiS3ZEMllTaTJwQzJxZ3VqMVJpOWVzakRQQ1VYWUMyd0xnbWt3SmszWHQ5?=
 =?utf-8?B?NjlKU1c0cXk5eTVvNVZJQ1FYTWJCQWxXUkNEU21uMkZTT3JvSWZGbkJsZnVr?=
 =?utf-8?B?bkgrcUJEOENWUk1CUlcwU0lmNFZvQ3lQTTlFTXhUekNSMVlLb1VhMzZXTWp3?=
 =?utf-8?B?N0swNE9TS1lNTndyU3ZCZXZ5K1M2aUhtMUk5eXdhOFBZemZuSVJ2djdaMmVV?=
 =?utf-8?B?MS9iYzR3SkEwczg0YWx6eVB0RVVIMWhXcXBCeDZuaGpoWmZPMTNmck5OS1hJ?=
 =?utf-8?B?TWt5VFNiVjJ1RGxNd3NLVzRwNE16TmMxZUtSU0dvbmFFYW90NWtrcVZDS0Fq?=
 =?utf-8?B?M2lTQWhzeXp2RnhTbXFTTFBVSVQxVTFJaldhWWpZS1NQSWt2ZVE3WkM2b0hq?=
 =?utf-8?B?SHJ6d3pRN1FQZnJtNzAwaFlFWlJtWUVZb2JwNElHNmxTUXU4d2ZnMVBsN2ZD?=
 =?utf-8?B?SktEM3JQSEVqZUNTb0NWNC9IejRHa0ZERnJsVnRYNDVJWE5CMHhhU1ZVcDFS?=
 =?utf-8?B?T3VKeXhNMU5iSDBueXFyc2pSUzhUZS8ra1U0RGszSThTekYzRkQ4MG9SdVMy?=
 =?utf-8?B?ekJxU1UrRUh5V25NUHNkc013Y2crU0xtRVFNczFLQ0ZDVkZ1WXlEM0hIVlN5?=
 =?utf-8?B?VWhzQTRlTzlFc3lKY3c1dFREVVBmb29ObWJQMDQ5cFo2OW1TOHUzamEyb2dZ?=
 =?utf-8?B?ZGJiUWFQdklQdTgvWHhPZWtLdDVZbXErKzloZi9PNUJlTDN1Q1FWUTZyTmJu?=
 =?utf-8?B?eDFabVgycTFFTFgzVDRWSXBYT05oeWcxSEJjTU1wRzJQM0J1UllEL2N5cXNU?=
 =?utf-8?B?UStYTzIxQ1NlU3BZblJWd2UxYUZhTzFXTWFycjJWZUx4NDZ6eXpWTVkzdUow?=
 =?utf-8?B?MXp0cmVXejVJUi9lTVlyV2NjT3RYclRqQUkvTG42MlVTeVR6bzNJZmE1VTE0?=
 =?utf-8?B?Q3RkeHhiVjlrODd0NndzU3ZpeXd1YmFxeStSMXlMWE5LRkJIcWx6MHpYeVFQ?=
 =?utf-8?B?UnVvVTQwa3ZNcFRPZ3hkbmZJT3NoUjlJYlBUNlQxbW5Jam01U3ozMkx1b1dX?=
 =?utf-8?B?TWo3R0NFcmxqbnN0Z0hNZjNHTUlCMEo2R1lIbXMwMXVwR05NdVFsNHNrdEJm?=
 =?utf-8?B?K29YQU1vYzZ5VlVCbVM1WU10QmNhSmcwNjZ6dUkwejkyNFVkVmY0STJ4MS9U?=
 =?utf-8?B?Vyt4aUlDRW1FeldraEJabnhCUEVXVHBEUnEyOHlFaG9aTTl0bnZ2dDMwcU5l?=
 =?utf-8?B?clJlL2NKcmN4N0VwMTVzcUJoZGRKUzc1cVUvVEx3MUV5c3hhTmVidnRQMVJu?=
 =?utf-8?B?dG0rU0trQ1RUS0x1YS80V2hHbi9iZWRPUXdxdzlsSDRuVkhrTk5hZFJJcWF2?=
 =?utf-8?B?enlpbFFEbG15NzFheENpeU1sazkydmdjYW42cmtkWVhDendsZFJhZ2Y0MDBN?=
 =?utf-8?B?Vll0dGZydVIwV0creWliL0ZDNmhCQXI0bC9lZmdES2hidDU2TTczZFpyZmZv?=
 =?utf-8?B?TnFkSEZ1RXZsRzhKRmkxejNaY01qUXM3R2E1dEhTS0pYQXBDRTF5aHZZN0Rp?=
 =?utf-8?B?dWlQZGJmZXdaTjdFUGFsOEViRXlaOWx5Tkk3cFlnTEVrMCs2RmVrMWFSTjdK?=
 =?utf-8?B?TDFMUzRvRjlIMjBNWmRLSkllUUZxbGNvOSs5WHNZTG5ob0ZOdCt2L2FQVytz?=
 =?utf-8?B?Rml5cSt4clVaaVJwenQ2ZlJnNHNUUG5RaXUyeXU5TjBNenJ6amVYYVFWUUlj?=
 =?utf-8?B?TnVFQSthK21leTE5dm9nQTlBV2k1ZGpPMm1oVjFJb3FENStBRUZKK3NvdFVJ?=
 =?utf-8?B?bXhmelVqaGxsaTFXekl3eVNwVEVyczFvVjNZc3k3RmpSWHNOVGNGVkh0dVBZ?=
 =?utf-8?B?dUtzRmlEY0x3YUNrR0J3MUpMK1Y1TjFISHFhdW52ckNqYzJQdmdxdVphYUYx?=
 =?utf-8?B?ZFdQVWZzZzZOV2Zrc2hHUXBHWW1UVTdyeHNnc1JFcFp3STZlayt1dUZzYitZ?=
 =?utf-8?B?czI3bzdoVzNtL3ZSc2p0djNWaHkvZXB4ZXduc1hnUGxIa0ZwZyt4UT09?=
X-Exchange-RoutingPolicyChecked:
	O24ULMbiEtNUmhGvvO8SumPyUlyv2C25s8mMkSVSKcWozi3W7rL/zG5bn3KoymW+iPp1JWFIvKx3l1vaC2XalmT2pBnMqD3Ebp0zl30tRaFjzFNQmzARoosb0t4q0cFjLWm50EKPEVLVkQwhfdTjUOOidIorbY/DRaXmluZ0vjTJT8YtCXKLWfElfCpmf9f4xElGKvneyOSIyfsBr1PXm4M6rNZSzIO8vZS3iWcTSfFB8tGdeGLmfCkmJhrHSEOfGMr3sIqGVnbCkO8NBtgl/SV6aZdYpV2ZuDejQHIlRjW+CYtSkskI16fiAoUlcWoLTcc79sqe9ZphaxduUlj/aQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yGKdrOlj13lC4+BHlsxHBg/PxcXq0TY6+3VnSN97cayHbL5d6rC+xMgBYYNw5TWbNO7jMkDY/xq0uFIbVgrpGE6La6K87Q8sYohOfNSQbixn8aLfzo67h37k5MoLYPuzI9X41I2nTYeTEqvGquMTnGGMI+lDjazKuHI+NH6WE6+7/1Ha06hF+VmWlyT2HZtZAGAvdw6DNL4CW+IAw1Bf2glr9rbedADHbWMLrrJm8SLg9bV0kiAKLVMs3iqroTlWPSGaPCf7gzMKKL41IZsMZ8a6wkBWZzVyp64AkrRpFODRQjY0IzVZ6uRup/ErsrOux5FDDxK1bfkPMfa8b6mluoKEu7YS/ls8+6/aGdhVWEFOt4laVu5tvUfHN8RAl235uIEgGojslmlzGSE8rSu4AVCW3Cb5DNNu65wbje3Wl70E2jfHtFbH6+4ZWbcglEeMBwG+3jb+ZgiDEmcfTrKRPtreNnE6NuEbDNpYuupUx/tKrhV4Dg5zC5/RAV6eXsYZafNDu8dvIF933JpkPZNsuwkL06x8lwuFP5XqBrJ2QERHZa5S1MPcwR9NBy9n5NY7AoWQU5KMyQHn+xk8AhqPncErvN/CUt+EWGN2XCsIArM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20502a42-1d6f-489b-bdd9-08de7e8d7f0c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 10:12:12.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJxoD/C3UWMRvKQriAjx/TTq6RArOmcncFROc2I88ZT0zUbT6XdmeWKleacM4QIPw6FUxeiwILYYNMygw4tHoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7641
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100087
X-Proofpoint-GUID: 90Rxs6ASFLi_SBJxBSsH3redXwqDPioU
X-Authority-Analysis: v=2.4 cv=c7WmgB9l c=1 sm=1 tr=0 ts=69aff188 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=tZnqBoDlrN85SeKDJyQA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4OSBTYWx0ZWRfX79kSmRIEZddD
 5po7iwlpLCsDFHyJdYBIw9YacKYXEv0gyfMYthKlMAvqD7jvCZ6Qnh4bDkKxlLZkuB+pAQPBoRb
 NtDIsUfx3SENm7ccGTpy2S8ThkMdRXA+gTprkwyI2dJ/QFNB53T/g2u8KuVCMgDhnRZ3xf3VDIY
 B+ovoGn4FGqPx1GeMxekdvLT2EHbp2Wuu45IP3er74Cd4rY/bTYUInkpsHoDYB1A7M3hxfslabp
 NwzgeZTfUHyvS4ez634OnhWnBW+PNBoqiri5NAy5cx6BheXVp9cKiW0HFT1/nlSxDc1sNRqchCG
 ciZ/NrgFll3BgVmpj+tYbRShsLNP5AgH+rD+l/DXL/6rhSUPbwsN1sDVEFMmvowRFLysO8U03u7
 hLjgJmGNceD4n1tFJNje5XqCyMOq0woa9id6s86ta7ztH6J1rpFSJfX118gbn97Jm6FhJyMp/6N
 3crhkqobeWNXIyaY41RHovAXnbASkDa7JprjgR+k=
X-Proofpoint-ORIG-GUID: 90Rxs6ASFLi_SBJxBSsH3redXwqDPioU

On 10/03/2026 02:40, Benjamin Marzinski wrote:
>> +static int sd_mpath_probe(struct scsi_disk *sdkp)
>> +{
>> +	struct scsi_device *sdp = sdkp->device;
>> +	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
>> +	struct device *dma_dev = sdp->host->dma_dev;
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +				scsi_mpath_dev->scsi_mpath_head;
>> +	struct sd_mpath_disk *sd_mpath_disk;
>> +	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
>> +	struct queue_limits lim;
>> +	struct gendisk *disk;
>> +	int error;
>> +
>> +	/*
>> +	 * sd_mpath_disks_list is kept locked if no disk found.
>> +	 * Otherwise an extra reference is taken.
>> +	 */
> Again, I personally think the logic is easier to follow when all the
> locking isn't split over multiple functions.

Sure, but I am considering removing the mpath_disk structure, so things 
may change here anyway. Removing mpath_disk should simplify things for 
the nvme driver transition.

> 
>> +	sd_mpath_disk = sd_mpath_find_disk(sdp);
>> +	if (sd_mpath_disk) {
>> +		mutex_lock(&sd_mpath_disk->lock);
>> +		sd_mpath_disk->disk_count++;
>> +		mutex_unlock(&sd_mpath_disk->lock);
>> +		goto found;
>> +	}
>> +
>> +	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
>> +	if (!sd_mpath_disk) {
>> +		error = -ENOMEM;
>> +		goto out_unlock;
>> +	}
>> +
>> +	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
>> +	device_initialize(&sd_mpath_disk->dev);
>> +	mutex_init(&sd_mpath_disk->lock);
>> +	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
>> +
>> +	blk_set_stacking_limits(&lim);
>> +	lim.dma_alignment = 3;
>> +	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
>> +		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
>> +
>> +	sd_mpath_disk->mpath_disk = mpath_alloc_head_disk(&lim,
>> +						dev_to_node(dma_dev));
>> +	if (!sd_mpath_disk->mpath_disk) {
>> +		error = -ENOMEM;
>> +		goto out_free_disk;
>> +	}
>> +	disk = sd_mpath_disk->mpath_disk->disk;
>> +	mpath_get_head(mpath_head); /* undone in mpath_free_disk() */
>> +
>> +	sd_mpath_disk->mpath_disk->mpath_head = mpath_head;
>> +	sd_mpath_disk->mpath_disk->parent = &sd_mpath_disk->dev;
>> +
>> +	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
>> +	if (error < 0) {
>> +		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
>> +		goto out_put_disk;
>> +	}
>> +	sd_mpath_disk->disk_index = error;
>> +	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
>> +				disk->disk_name, DISK_NAME_LEN);
>> +	if (error)
>> +		goto out_free_index;
>> +
>> +	error = dev_set_name(&sd_mpath_disk->dev, "%s",
>> +				dev_name(&scsi_mpath_head->dev));
>> +	if (error)
>> +		goto out_free_index;
>> +
>> +	/* undone in sd_mpath_disk_release() */
>> +	scsi_mpath_get_head(scsi_mpath_head);
>> +
>> +	error = device_add(&sd_mpath_disk->dev);
>> +	if (error) {
>> +		put_device(&sd_mpath_disk->dev);
>> +		goto out_unlock;
> We should clean up when we fail here, instead of just unlocking without
> fully setting things up.

I think that the release function is called from put_device(), which 
should do the class tidy up. Something similar is done in sd_probe() for 
the disk_dev.

Thanks,
John

