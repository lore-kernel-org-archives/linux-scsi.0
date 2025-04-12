Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D822E4C7F;
	Sat, 12 Apr 2025 00:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418757; cv=fail; b=IPvoFYq8wCp2+4zaVzNC83YIZzABesB52xifdJVaj+yHnvAvi8kNgI2njfNg4AXVUlaCeqkeJ/2bUMk9LnGvs3eygNRmdObHU+EZolp/W3FQaC2cGBBGchrQ5yNeUQ4iue7tyaIzO2AkyiKlWCGYibkYWV25t+7zO7qQ3J486xI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418757; c=relaxed/simple;
	bh=9aFVLO+ftNmbgv6UcsP7252CtdpBcwKkvbi9ydZC5iQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fM8fST9GaM8vNrzrvi0UwiZsABMwGIZoVXmnOnDANZQI4HfESkc7bXf2e+N7YlZdmFzDpCc03/ct/3aPfL70d2YgBZSmGExqQGyWdKNL55v8x35VXvzGhF5cXB8bWm4q9ip5HVhXV5xSk3dI5e5Qii2vivQr88iqF2FRJNnqcC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iq85Rra+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w2MV2/Y4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iq85Rra+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w2MV2/Y4"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BLHh2u030631;
	Sat, 12 Apr 2025 00:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8te943+3hk/fZCyk190htnjhOQmiLL40karEs3BoB4U=; b=
	iq85Rra+VgBb0fy5nUwYZjAwcjymK4Nd0x1ttPzYq1OVRaDyDtURIE2en95ROEmG
	e/6Qlmo8lrX9YxFKDD6vgb/Gg9YnCahXbNhV6CGf6KTsvEYWGm4Pectch9OH6HY7
	8LNctO+Gt5SoBDqiAGbjsTAOS1SPrvqy3PR1YU9ZCQP6qO4HUTGreRKVI4OoS4aO
	rwjz7rruMAd7BqNlGPlAXpMZYCOsyPhbwQrJHPROBq0WWX8wyHAREpLTzWAV5ZQx
	uPzpzuo5xy4VoUDLqHYp470Rs49aEqrEcp3EPrcWLQEYtCy7Y3J/33RfiWLmh66M
	Fvu5iZ3HOYrJuPmvJnPSLw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45y9fe0jh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 00:45:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53BLlbJP013695;
	Sat, 12 Apr 2025 00:45:38 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012015.outbound.protection.outlook.com [40.93.14.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttymqt2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 00:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ithILPFS3hxLZ0hkjirTJT0oFaR1i8v3assiC/f6yKMf7QhtrDEmqmAqr4xrWY8oK3mbZ1qyg5nt98L1QOL2XqjAcPZJ7yLarbIiu+Rh6FCJnwC3BI8gmjMjfoLnS1mFMtyYw2cSgn6rf6pyJ/ciYx15YhoIiXIcMVRIwpW0sq1J8BNVfUgpUwfub/4t6xre4J2lp1txvPgOSskxfuoeQ8IPyRuMLEmaKnPT9xVXBHhE3OEo3jUK75W79QmISn3REgiJ+2zz30gk1l4qTjS73rLyF0SwO5FAnl22Bf+yLUPPLOf4j7vUxIfw/0RsnIKXOOP9KJcbwELFNGAPJJpyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8te943+3hk/fZCyk190htnjhOQmiLL40karEs3BoB4U=;
 b=Ap68pCyLZXIOG+M2Mqki+GU8a749OdfQYDas6sv/EinbWwbLcY+BKJhUpIDfbmeLt7K9UYW8D3Wj678bB9tZFgMryVj1M+a6B4MzH1+eEmSahOeum9w016t4FJMDGUGyhB5qPX+0vZJvxslPaZXAqbckLS79CTjKX7K594YWmHRFWSIhtAopdoWdHPK0eAvWPjgaH/t5V1pEJfDoMmMMle1Do32Jkibdkg+o8+kQUmGhrXtYchMPNjITvm6S8BHCrdOEo2RVjc52RU+Rq7TKQHAGLQXVH7ckvGga7slIbhxTrUEGk1YnLjioq5CWwTS9aqCQ9bfi2Szv2WyM/gGNgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8te943+3hk/fZCyk190htnjhOQmiLL40karEs3BoB4U=;
 b=w2MV2/Y48PueKCsOWCVXiV+V88yLG12CJuASag31BbY38ntr0BGJU5vjB+7zXllTjU3I6+6+aXpYOUm4AaDYOyQGAoNiOURI8OZBaaAqlmOctzEEWe9+jSDpdXwuOcdOHi7e7piSXsbeonAB0Ab9Yo+Vjiqhtw+heQ8fTTXfheA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH3PPF0A29BA37B.namprd10.prod.outlook.com (2603:10b6:518:1::787) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Sat, 12 Apr
 2025 00:45:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8632.025; Sat, 12 Apr 2025
 00:45:35 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <liuyonglong@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: Re: [PATCH v2 0/4] hisi_sas: Misc patches and cleanups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250331123349.99591-1-liyihang9@huawei.com> (Yihang Li's
	message of "Mon, 31 Mar 2025 20:33:45 +0800")
Organization: Oracle Corporation
Message-ID: <yq1jz7qjjtw.fsf@ca-mkp.ca.oracle.com>
References: <20250331123349.99591-1-liyihang9@huawei.com>
Date: Fri, 11 Apr 2025 20:45:34 -0400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0059.prod.exchangelabs.com (2603:10b6:208:23f::28)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH3PPF0A29BA37B:EE_
X-MS-Office365-Filtering-Correlation-Id: 69e94022-a632-4168-567e-08dd795b5674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHNDeHcxNWovRU1qdTVvMzZkbE1qd01Od1Rqd2d2UnFrcHE4OXU1TzdOSHhi?=
 =?utf-8?B?MGFvd2VIcVVXdk8yRXpvOEc4M2FTRkw3bm9hMzlpd056ZVJqWmR5MkRUQmNN?=
 =?utf-8?B?eUdEYjlOTFk0ZmdORUpMcEVXWHk4Z05aMWRHVkRuYjJvL25rNEx4QXEzaGlQ?=
 =?utf-8?B?Q2thcTNaeWlvYUw2Zit2UU1XVEMvKzRsR1U4U2pIVTk1ek12OHMzZ1REeGp0?=
 =?utf-8?B?VzY4SGI2SHBqQzlEVWE5TVh6Y1Uwb0pLL3BjbkFKRnllZXZhT01vb0pUN1Q4?=
 =?utf-8?B?UmRUV243Y0lTY0NNTGhYWEhYbmJhWC9GaHU2MUtHK0FXVXRxQ0crRUV3ZU4v?=
 =?utf-8?B?L1ppQjhQbERERWtoY25zcWVmeDZINzhvUlJ1NlR6alRXYUUvcGNYQkJxSW4r?=
 =?utf-8?B?aTBGOUtsbFc4Wi9jWlYycE4xb2NicFRoQmZ2UkdkNzd4ck9Ea0FFdDRuaTFT?=
 =?utf-8?B?VzVEaSsxMS93ZVMvNnRJVG8wblhKaU4vN0JuOVJOV0F1ZGtUbXFkaUZnTTBB?=
 =?utf-8?B?bmxRVWY4MDR6Q3lLZXUvRG1vZWdicE0wMm1QMWtSbithNXRqeUtYa25VbHFv?=
 =?utf-8?B?ejlLS2txQW5SMlVnNmhsQjV3VFVQTTJiQm9CbjhDWXFFR1N5Y1Z1ZVZLTUow?=
 =?utf-8?B?a2NzL0o4YkpWWjhhVXJKcE5BOUdzMk1iUzRvQkxEeWRIbFFMYzNGWnZrdElF?=
 =?utf-8?B?RG03S2RzR3BtanloZm5LQ2dBdlBEWmNhWTQrMm9STFoxbGdQbUhPOFBQVDQr?=
 =?utf-8?B?YXFJTDJVL050dWJRV2FFWTNSNmZTbkFneTFncldtMUltb0YrK2tMOTVsNG1k?=
 =?utf-8?B?STNyRXVZTjZQNzhPMGpQUTNTUFUrV3NMcnBGYThMMnF4Zm1pRUROOElZeXN3?=
 =?utf-8?B?VGRNZEQrUUhqNGZUN2lNbFV3SVFLb0s1OCt3am5xaXJFMTVCdUxWRmMzdS81?=
 =?utf-8?B?cytZajNVSkQ3eENkL0NWUG03R1lnK0dtY1ozbldvb3YvenBEcTFvNmVicDZh?=
 =?utf-8?B?ejZzYXNuWndHeWxLbmUwQ0pZRUxic0tHNUhkY1lncmgxZGhxOEtuOU9CU0k5?=
 =?utf-8?B?UXFaRGllKzJPMlpXNHZxa0ZJbmJ0SWsxdmZ1bE16ZklvWmNOOUtnSHQrRW9p?=
 =?utf-8?B?RlRrSzVOd1ZGZ0JUejRlOWEzc0hsNGxsQis5aVRjSGRENUZRRS84MS9IMllV?=
 =?utf-8?B?a0s0akUwZ3FwYndkeWNBTmJqWkhzVlZHUGV0bWZJOTVndHdsUW1zV3QyaHJy?=
 =?utf-8?B?NHJ3dlgxTkpqWmEzNURmTjBCOXNzR0dLdUp1SjhMQ1FERTNmdmFjWi93Wm5Z?=
 =?utf-8?B?enVsVkUvWEM2dkRjZnBNQ1JRWFJRczB1UDZPK2pXZlNrL2ZxTTdyVDZ1cTBo?=
 =?utf-8?B?ZmZlSnl5enRJd2xYR2ljaU9IY1hJdENXZ002SEJualNBd0VqR0Nqbjk2aDdv?=
 =?utf-8?B?Y0lvSGtNa045ZU5rZmJ3eW5CUFR3dlFkQzY2cSt0M0tnc1crZ2dMVXJaNis3?=
 =?utf-8?B?N2o4S1BkcnZrMWJVOGtaVGhMOWhra3RPVVV4ZnJKcERGQTZDWmNCd21XUUZh?=
 =?utf-8?B?QkFvMjlSMWlQbi9qTkFpdHFuSk5zWlB1NlZRMitON2Eyb2hPdDBoRWc0bkN2?=
 =?utf-8?B?SWN4RndaWHQxeEl1THpuYUM5aVUvdUdxVVBBZC80elpXa2trT1lBNGluUFY0?=
 =?utf-8?B?a1hoNzI2aVIwQWlsQVZ4dmEwR0xIZXd6RDEvWEEvendBUTFqenpCaGhDVWNE?=
 =?utf-8?B?UzV2cy93VmhsaWNVKys2QnNGdmFubHhQR29VWWNsMmVWSGgveWVDbTYyNmQv?=
 =?utf-8?B?R3kyT3ZiUFRqV0xodnpsbG5Kd3VXQno0UTdkOXp2OUxUWFNoWnZ6cUl1U1c1?=
 =?utf-8?B?U0ovenNlQVVueHhGbVV4SkVmSStWR0wxUmJFU1lvN3RnRy8xK0hBY3J4Qlk3?=
 =?utf-8?Q?9wPPeVTse/s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tm0zYm9mZUxkSHZONGpvMHRqRkZXRlRrR2FEMElEekFZKzhGeisxWElzSWRW?=
 =?utf-8?B?SC9MdW9ka0E3MnhsaWdXMzBMWDhtcUdjY1dZNjVyTUlxalJzTzFjbldtWDhU?=
 =?utf-8?B?MVY0VmZXd3luZ043Z0h0UTgrNS9JcFQyWmhEdXlpc21GRlRkWFM0ejRaNGN5?=
 =?utf-8?B?T0pHWGRtKzJaR0lzb2VKSVNNd1docFVuT0lqVCtxcVJ6ditlMEMzNDFFVHFO?=
 =?utf-8?B?Qi9vZVRWTnUrNmY1MlJ1cVg2QVlIYmhkS0MrZ1dYWDBFdDl1dFVuMERwYU1C?=
 =?utf-8?B?Q1R2czJzZVBJTUF4UTRLeUd5dlk5MjYvSjlBMk10M3IvMEd5ckdWQUZsVzhN?=
 =?utf-8?B?a0F4UWhEMjdCVWRiT3pyOTBETW5EOWI1SGlLWldNYk9RYXRwNFZCY0VIT3dF?=
 =?utf-8?B?Q2xUOHR5UjZkVGlEaE53Y21VVERiRTVoWlRNOVJDU3dvWWxtT09adVdlT25n?=
 =?utf-8?B?Z1VLQURReFcxRy96dWg5Wjl6VUxrdUgrVWU0S2tSS3N1akhMZmF3MURBZkpY?=
 =?utf-8?B?YmlPNGp5N3R2OVNiY3NWRWJVT1g1VGltY3owS0h3OVJJaUYvdTRkc3lJU1Bz?=
 =?utf-8?B?K1N2ellLS0RtQjVqejRBQy9aYkc1Q0tWc2RtbkVQSUhIaGx6cTdRMExqZVdu?=
 =?utf-8?B?QjUyWWpLNEYrdmtIYWVXaUM5TzZkSXc1NWcwRVdQSmpITHFsdklGY0hoWmVY?=
 =?utf-8?B?WGNZRFpRMTNkbmRxbkZVN1QyQTJmZE5KRXNwWmh2aEkvc2NBazR3MkltRHN2?=
 =?utf-8?B?VFRRU3V5NlpORjQ2S1hwQzZmSmtTbDJOaHRCNWFIZUtPYnlqNGFwakp2Rkg0?=
 =?utf-8?B?VHZjeXF3TmY2c1hqZVRwV25VWWxiNk1ST2g4WEREaHZiNklvMjF6ZFNDV3or?=
 =?utf-8?B?cUJrTm1KVWtOM1U2T01OczMrSUNhenJIUUZiekY3U25iSEEzUmZpMDNteDlp?=
 =?utf-8?B?dHFQNHpKTmQ0NkxUV0lWV25JSkZ0Y3pDN2t1MUtURjhEMWNLbGVUUHZtMmlk?=
 =?utf-8?B?YzNrMlJEVHIvd3VqU1Mva0Y3eG82OUkyZFhRS0t4TzFsRWNVcHkwdlBFK1JS?=
 =?utf-8?B?ODZ5VFdkNWRnVVJNb1YwMkE5c2lxZTh4OGtMZ2xReGtKS2d1VEdpek1ld0hy?=
 =?utf-8?B?M29uRGhvSjhLT24vQ1lMUjZHWEdSZ245SFJZczRGNHp5ZTNBc3BCTGxGZXU1?=
 =?utf-8?B?TnNLM0tPV2NTMDNkRWhMUXhrOG1nQzg4UFE0S1FKeUJmNkNCcE11Y2xGUDFz?=
 =?utf-8?B?eTlZUFhyUjhGWW1XYkxHbmU1NkZmUTNkOEFmbk8vMEpOZVJGTVFreURZclk0?=
 =?utf-8?B?UUhmdHUrTExtaDBoWHRFNzkrcXkyZEFmNDdHZUpQYk5CL0VORTFaSHVXNkd5?=
 =?utf-8?B?ZWxpUUsvNUYvSXZUTjV0aFFlTUJHSFlLamtXN0xhTm85ZmQ0dTZhVFhhNEp6?=
 =?utf-8?B?QS9wd1JveUk5RDJGaXN3MlF4UWRCeVJjNTBjWGJuajErTk9OZzlaQnJ1ZW5h?=
 =?utf-8?B?Nk5NR1IyU3ByTy8wM1dPUlJ6OUl2K3RMS0JsblJSTytwaVN1TUptTHUyRG83?=
 =?utf-8?B?QTFySFlQQUwrblZiNm9keFcyRjByQlI5cXRkN1JhU1c0SFRVaVpqT0RRRmZQ?=
 =?utf-8?B?L1NBamFmajhlUUtXV0p3WDhzSUxKSjYwcHRaOStGTEV1NzNKYzB0clhYR1B4?=
 =?utf-8?B?WE9GaFpzNld0WHpaQzMrOTY4MXhwR1ExOUhJa2c0b1hOU1EvOXhKcE5EVnFG?=
 =?utf-8?B?bXZRN3pMem1QZENsQVVCL3dDVjM4ZHk0bzFqb0JnYnZVV2tER1AzYWxGRzln?=
 =?utf-8?B?L2w4MXpuMUl4dlBvdi83UDVsN2JORjdzVVNodHpsdFZmTlJoMWhrOFUrRTFJ?=
 =?utf-8?B?bjVIamNRVXI4Q1ZST28yYjF0c1pxRjZsZjYrWm5PcUY2M3BjZTFTTGZSd2U0?=
 =?utf-8?B?S3BQbmVlSlhnbWh5TktnTERhSHArSnJKZUxCUEJVdzZNNGFpNHpvck05RFhi?=
 =?utf-8?B?QlJ0WXJWU0QzbS9sQk93TW0yMHRGc1VNUzRtQUU4ZWFhTEVPZ1NFNVdvT3Bn?=
 =?utf-8?B?dGFpaXdvUFpHZ01DNTdtYUR0cUVoUDdibTBweW9ER3NsaTJSSWtlY1VvNEJL?=
 =?utf-8?B?aUEvcm5lNlhISTlGOG1RTkZqZlNEaVE2aG9BNGJYRzJuV1BvWTYwLzRaNllE?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+1Toy9c6VIrd/+7n/VUw+MIjGDlZkuOUQIKWma45Jaq/0dUeW3vnQqEyOdTHwSHwqcYMAVbs8MuFoq449+501IgpwCDo6smtELxGsVtCqPLDESrLMmESJHuPVwv/hdWklvltV/h9zZypus/n2Y19dFuWLouldhzKuaJFvZlBS5LvpENDhcIfSPy7JyQQKDeeJ8ltXnd27GOq4QEH8doBfN+EhLVP5aQyyzoMxuNK9EeJ99eIVXKVmlhP0pq+uhT8nwPjbkHifxfBKl+5m2/g3+TPu4ljz0vXv/FyarbBqw/Unw5ZXEzLKJlNMXqgBWkjDXzbhVlV1cu2gSWF+cAVOiJeb3DB4CVjdD3lSGReoHitzlNmz083UMsNXhLKjk7Gci4Xe/MgWpNBSPfbUpniGtjnIc85qwYTCc1UDqH/vrHZpFh3IGmGZEK/WuMfVdr854evCqgRINw/VIG2Q9sLpgelakmZIHcl545bEe+YKQBoCMp3F3AGafXkTSFleP/4DCT7dLKwbgKiSaJ+j0jG0k9C5bjyFC6qw9bUHQQBDG8TFVfDUoNG0/fS8dMGdGoKpXVbcDsIqrS1+XDUqrCngKT8DvIP3Y/TmZPWG8zESaw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e94022-a632-4168-567e-08dd795b5674
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2025 00:45:35.7097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UvKqi2/6zSjYt7CGW8z+7ICwBTsQtQWoPVlgLyjZ+kxMstfvlmGYo9EySz2qH9s/QTUMBKCUns/VZ3mKt7w2TNnRBMrnZfEcpc2aDNfJYO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF0A29BA37B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_09,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=950 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504120003
X-Proofpoint-GUID: xFTC51FxH88zet_1R2SSxt4LJG5GExiO
X-Proofpoint-ORIG-GUID: xFTC51FxH88zet_1R2SSxt4LJG5GExiO


Hi Yihang!

> This series contains some minor bugfix and general tidying:
> - Ignore the soft reset result by calling I_T_nexus after the SATA disk
>   is soft reset
> - General minor tidying

v3_hw won't compile after applying this series:

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function =E2=80=98debugfs_show_r=
ow_64_v3_hw=E2=80=99:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3718:27: error: =E2=80=98TWO_PARA_PE=
R_LINE=E2=80=99 undeclared (first use in this function)
 3718 |                 if (!(i % TWO_PARA_PER_LINE))
      |                           ^~~~~~~~~~~~~~~~~
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3718:27: note: each undeclared ident=
ifier is reported only once for each function it appears in
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function =E2=80=98debugfs_show_r=
ow_32_v3_hw=E2=80=99:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3734:27: error: =E2=80=98FOUR_PARA_P=
ER_LINE=E2=80=99 undeclared (first use in this function)
 3734 |                 if (!(i % FOUR_PARA_PER_LINE))
      |                           ^~~~~~~~~~~~~~~~~~
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function =E2=80=98debugfs_create=
_files_v3_hw=E2=80=99:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3896:19: error: =E2=80=98NAME_BUF_SI=
ZE=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98=
PROT_BUF_SIZE=E2=80=99?
 3896 |         char name[NAME_BUF_SIZE];
      |                   ^~~~~~~~~~~~~
      |                   PROT_BUF_SIZE
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3896:14: error: unused variable =E2=
=80=98name=E2=80=99 [-Werror=3Dunused-variable]
 3896 |         char name[NAME_BUF_SIZE];
      |              ^~~~
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function =E2=80=98debugfs_trigge=
r_dump_v3_hw_write=E2=80=99:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3974:18: error: =E2=80=98DUMP_BUF_SI=
ZE=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98=
DUMMY_BUF_SIZE=E2=80=99?
 3974 |         char buf[DUMP_BUF_SIZE];
      |                  ^~~~~~~~~~~~~
      |                  DUMMY_BUF_SIZE
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3974:14: error: unused variable =E2=
=80=98buf=E2=80=99 [-Werror=3Dunused-variable]
 3974 |         char buf[DUMP_BUF_SIZE];
      |              ^~~
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function =E2=80=98debugfs_bist_l=
inkrate_v3_hw_write=E2=80=99:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4040:19: error: =E2=80=98BIST_BUF_SI=
ZE=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98=
PROT_BUF_SIZE=E2=80=99?
 4040 |         char kbuf[BIST_BUF_SIZE] =3D {}, *pkbuf;
      |                   ^~~~~~~~~~~~~
      |                   PROT_BUF_SIZE
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4040:14: error: unused variable =E2=
=80=98kbuf=E2=80=99 [-Werror=3Dunused-variable]
 4040 |         char kbuf[BIST_BUF_SIZE] =3D {}, *pkbuf;
      |              ^~~~
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function =E2=80=98debugfs_bist_c=
ode_mode_v3_hw_write=E2=80=99:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4115:19: error: =E2=80=98BIST_BUF_SI=
ZE=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98=
PROT_BUF_SIZE=E2=80=99?
 4115 |         char kbuf[BIST_BUF_SIZE] =3D {}, *pkbuf;
      |                   ^~~~~~~~~~~~~
      |                   PROT_BUF_SIZE
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4115:14: error: unused variable =E2=
=80=98kbuf=E2=80=99 [-Werror=3Dunused-variable]
 4115 |         char kbuf[BIST_BUF_SIZE] =3D {}, *pkbuf;
      |              ^~~~
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function =E2=80=98debugfs_bist_m=
ode_v3_hw_write=E2=80=99:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4247:19: error: =E2=80=98BIST_BUF_SI=
ZE=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98=
PROT_BUF_SIZE=E2=80=99?
 4247 |         char kbuf[BIST_BUF_SIZE] =3D {}, *pkbuf;
      |                   ^~~~~~~~~~~~~
      |                   PROT_BUF_SIZE
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4247:14: error: unused variable =E2=
=80=98kbuf=E2=80=99 [-Werror=3Dunused-variable]
 4247 |         char kbuf[BIST_BUF_SIZE] =3D {}, *pkbuf;
      |              ^~~~
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function =E2=80=98debugfs_phy_do=
wn_cnt_init_v3_hw=E2=80=99:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4794:19: error: =E2=80=98NAME_BUF_SI=
ZE=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98=
PROT_BUF_SIZE=E2=80=99?
 4794 |         char name[NAME_BUF_SIZE];
      |                   ^~~~~~~~~~~~~
      |                   PROT_BUF_SIZE
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4794:14: error: unused variable =E2=
=80=98name=E2=80=99 [-Werror=3Dunused-variable]
 4794 |         char name[NAME_BUF_SIZE];
      |              ^~~~
cc1: all warnings being treated as errors

Please fix, thanks!

--=20
Martin K. Petersen
