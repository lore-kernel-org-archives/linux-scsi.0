Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C156B3C465;
	Wed,  7 Oct 2026 00:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791331743; cv=fail; b=qpTIhi494ejLA4jrbhLJkhJvf7vY79iED6GJm8zwP2sEXHzxoseumPFbLSY7L4sEq68AAmErUIT3jTYqfi+RAeoNhAt7tHtbjhEvAqJifQSrIrbadoY+TA/AVeQwRKlBDCxeHTykJMBSYoDCi8tLqcIsG2DPTCn8jg8+q/Jx/LM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791331743; c=relaxed/simple;
	bh=IH8VkcgCBPZYALdlRW2hFavrhoU1pf42n/um5V9MZSs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WQ2l4z0NdxhUNuRvOhxu0sqowmL+Hn/b259CGhYqQmx/A7b4sblnz2PhNrIU3W9X01hf4lyBHwPtbJSgQKbc5yuCWkbxFkTYaEQtEqqMhfy+ugR7NBT4sLYENjzjnUurBFxdkbcSNrOmlab8zQKYos06mgIsLj3hgVxb6k6lncI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BddFbLst; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ai2+cbmb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BddFbLst";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ai2+cbmb"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696LbG1b901426;
	Wed, 7 Oct 2026 00:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=04MujhRyaatbf2BJ1kNb0aoNFgmb52LH5/G3SO9xkag=; b=
	BddFbLst+MbxJUkq513owspRErKwVkdzOMZ+Pijb6YYCv9j9diTHExY/TUhJ1Bi4
	Az7Xz+Wug7lUy/esTt/cYUe0XYw7ctOqPjdvPfiVoLH0ZfiGhVh7DEfLH0TnGYuG
	h2l8rq694UQ96FiwhTFDEzccSFoIZwa3bZywLf4DtXoKOXaENsBtE2VXp50UIJ6J
	imhQ1h8YD10ub07ur0HF7qC2qShFqeYd5/x3SVGJhkUVVw4RVpPeBp3mFw+bQvlY
	vbscBK3xT1vwIcNAE0L/AZ2NJPys7uTcoVQczYPD/50OSKa5EhNepgyzlOmfdHss
	eSaIH0Jwk9EeRW6KjUU0dg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2rg1vvpt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Oct 2026 00:08:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69706b6p034717;
	Wed, 7 Oct 2026 00:08:55 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011020.outbound.protection.outlook.com [40.107.208.20])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d1r7gx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 07 Oct 2026 00:08:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mRJtCzUKQAbvmpArnjL6Jkbx0Menz6oTkCRvWTB5MNupE+yssv/y5ooJg+xMadfrR1WiWVv56Vd1cguWWI29OpuZy+kr2B686QZ91iDuamogWYBDj19GuLnWzxiuKQvh0+IRu2S1Ge96ajz05yB5SlkNsN8RG5moYdOVfKVGbCKQzQdDcTsKn7y1ykIlhPdSbEQlA2F8A9Z6dXVri6Sk8VFOH5Ci0E3EbzvpB9VTj1vVcFoHNlFhZoY2ETCZCHSW1teXorIh/AwdF42O0/NkM16iAKAy0F9H7A9foxud6fQnhoaVL3/GlsYAMwt593/ttURFHqF7RKGDsuz2NqOueg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04MujhRyaatbf2BJ1kNb0aoNFgmb52LH5/G3SO9xkag=;
 b=YiS1UMCPkFMXT3s/6QsgCFe0s1C8LHUnxETgxzQc2vjgEOuKut+y25334pRVaO5cFAOJdTYKrvnecCoHXHQktnkDeA4DbmY49A+Ga07WeYNF4yunpXqreuuvYs0DfhsStnw/sElWBskK95m0eIQkQEKRP8xr6WL+V2tXg1VWwN9y2JD7oUO7yDPm7F8rJhRDYSmtdVWWBaA8A1otJtbS6Pj2RFArpa3he6g/O4+b/Cfx9G4Rmi21zxCm4R+9n9oJrMOjZBEHj1ytxf0R5UX4c48LV4H++w6FLkpFjP0MtXONkmrElKyx/JPp3CkdjOU7ohRCtDLM8ePM8UOrIPpwSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04MujhRyaatbf2BJ1kNb0aoNFgmb52LH5/G3SO9xkag=;
 b=Ai2+cbmbtHBiwRjuJ/yKP0B8a95XU1+qnFDeEF/yZZBUR27iHPQ2NUVgmssl2rwgT/a8QKA8QRljTkB3Z/Go5wt6Vd/tpjPA5T0BRsmWlYfnGM2TCIGQY2ViGE0xChB7lWb1yFNmMMGLDO8OLaVZ2QNO0pNmZS1fuRDJhIPmccs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by DM3PPFBD8703CAB.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 00:08:52 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120%8]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 00:08:52 +0000
Message-ID: <60f874ba-ab80-48c7-9c00-4ce8bf19e20f@oracle.com>
Date: Tue, 6 Oct 2026 19:08:51 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: libiscsi: reject a negative task index from
 parse_pdu_itt
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, lduncan@suse.com,
        cleech@redhat.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
 <20260804040546.2264137-2-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260804040546.2264137-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0092.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:25a::16) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|DM3PPFBD8703CAB:EE_
X-MS-Office365-Filtering-Correlation-Id: acbb27ab-fb28-468a-e0c2-08df24072b35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|10067099003|22082099003|4143699003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	Nz4HXBn+maxTVkitb8XiTrD3CVjJ+E0tIh3AbU5hqRo+EbQWatE2nZHHsb7CBXXCaE2p5DYy9wdnM3opRUbnwrnVLQDk3R1ghw1ZpcFdgVE194kVF/DPDFod9kQGupj1X18CaiJf1BqYmbTLkegqyIdyTQMGbLAPvNEaEsBOD/w5mZFlrcLCMH8mRBRrdjH16NIJHCt0ETi5eFIVMO/f8HnV4n9aMbd93iNsgUKElEf/M1jnxeABE/jEWfWwkm49m3z8d5ay/0JwnFdpsnaetEU5dBBhj1cOpzxinDjTgPIT9UnsEZKZcYi97ti8g2K7Kigt9h2TfJnAKT2zv/m4UuQEvN5n5Z5fSjdD1OKheSvFIm4HnaQtArgF4h1bPqRgPaYnT3LfYLU/O2LUF1Mrbm3aMNTcWw0UbbvLYGGLg0YJuVED49nOSNKGun2DadIbrWEanRHgvQUyCy1VyJAnkJUXWkseuZ0lnqV+xC/HenXHLXM8Fp2vyQmAocF/QYlt07BtD8p3AHqj4j5hUJE8swtPb1BHrwZ85BKX7Yk8MO9gTpZNguIKvdnk2wWL27cvxpq08VNqVYEmeGoRB+3GM+HhQj9F/+vZA6UzuXMLOmMbVZj8kAd5K541DDAELFL52Z6N9BnEYJWJajHCUbpu5s31MGNxIwyO114QL2DslO0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(10067099003)(22082099003)(4143699003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFlETks5emlBMklkN1RabWNidGJhMFdqSHltWU56KzRoUHAwZEdLb2FFNlhF?=
 =?utf-8?B?T2xOa3lscGgvTk9yMTJXeDFHT3JVOFFmRFFtVjd3ZGNtSE1weUZYQXNZckZp?=
 =?utf-8?B?SXdJNHVMOWwwWEtvMVlGN2Q1QTN1alhRdFVkTlh5NHZNMHRFUGZkenRQZ09h?=
 =?utf-8?B?ZHZ6dVhPWlloN1lKVFRzeEdHZ3dIaVQ5Mm1YdFpONlY0MmtuVDBkSCtSdXdT?=
 =?utf-8?B?Yll6RVBWbWt2S2NrMDJ3NHNHRkdoYnRFTnkwUjRob05tNW5wZVd4T09uWDRx?=
 =?utf-8?B?QzNsZGI3U1AvcFVNVE51S01QS1FBeW9pekYxMlUvRDFLb0FUZXdnYjZlNjhj?=
 =?utf-8?B?aUJDa1JwZkVrbENQN212RitOMnpDSzc0dkU5bFRPZlZ2QjBvYjUvZ2s1NmpJ?=
 =?utf-8?B?Vm1tL0hCR0lTcG0yN0lnNXdBOE9RYW9ySTdQR0hpQXk2a2hYUndWdysvYTNO?=
 =?utf-8?B?ZzRJTUhGY3dzdVNQQm1XRDFYY0k3N2xZS1NlcDJsRTVNYnphQ1lvd1h0bWcz?=
 =?utf-8?B?ZkhhMXVuVDdTdDA2SmltSVp4ZmZUVEpmQXF4WXVmU1ZBNzNYOGNzR09vQnVz?=
 =?utf-8?B?SmZTWGhJTHg4NW92RGo5YVAzRk5UQUt5UHkxcG1wTTErTWJtQTk2bFgvVHZi?=
 =?utf-8?B?bXZLM1QyZ25TU2hSamdITTBSMlpaTEVqTEg3UGxmQjNiS2NQM0NIV2xad2Nr?=
 =?utf-8?B?SStOWE5NMmtac2JBT0ppTUQ5ZDNtYU1jMU1YeFZoRWtpMmFObjRHd3Y2dmp4?=
 =?utf-8?B?S0ZMTENqUHhNWDE5aTFNZnlEdjZaTzRZWE1LcmN3SGg0UVRxSXFtTWlNYkhM?=
 =?utf-8?B?bFlUZ2d3aDlCSjhFZi9QbnhTZnZjMUx5K2VTS2JaeXRhS0dxSkcyN3kyQ21q?=
 =?utf-8?B?N2hmd0h0ZEdhMVU0MTlKNjBYOFRPRHgvMWNZb3lKUzE5L0ZIK3EraS9ydUZF?=
 =?utf-8?B?SmdDVnNnaG5WemFCLzdDV0xYSGdaN1RhVDVFbFJldktIU0FYSVZqU2FLNUtF?=
 =?utf-8?B?VjgvKzJqTUxHRzBhazV5ZnNyRnZkYjhsS2hhcGNzOFNvN2U0eDBIUnlUTVhv?=
 =?utf-8?B?MUVqMmxjT1kzYitpeXhPUGk0RkNodENyaFljSW81S1ZEUU5aVWNOYUswdnJ5?=
 =?utf-8?B?TjZjc25GR3B2dmJZQ0FJWGcyQStqanRSazJ0UjcvcmxFMlpOYTdBamtXbE5n?=
 =?utf-8?B?UW51ZWZ6emZJQXJqUEYwaUJyZWJUdHJ4YW5ZRzFwNVJGTklJRzQraG1JYkg2?=
 =?utf-8?B?WUN2dnFNUGs3bnFWaXp5VXBqYWRGNGpadFBjSytLQkh6YnJSczNNRmNOQ25x?=
 =?utf-8?B?cldNaGtrVllhbUZZQTc3RnFiYmw0dWFiWlMwTE5kcHRicld2aVFMUW55N0ZD?=
 =?utf-8?B?SG42Z2hPWmtrUVU0eU9TNkFWYXFwMFNFenFIa2tvNkZlTTZJejlNM3NnaHpH?=
 =?utf-8?B?UjlGK2VMWmZMOUZqbjZ0ZnJPVCtOTHZ5MS9Tblp3cElzTStULzE0ZnFEM01y?=
 =?utf-8?B?Y09KMmxmckVHc1dSc0pFRXBwOGp5dVVWMVAvakZlTkIxYndQMEdSdmQ1Y3dY?=
 =?utf-8?B?dFdHMElUcjZIVDJHU0tVSEZLRXRhOUJ1cU9rQmwrRzMyU3dtblpvSEJmTWlk?=
 =?utf-8?B?MWhkVENjc3NWV1hOUGEzUFEvL3Z5NmJlK0RJOXBuOUpvSnNkem1HZ1BOSjVv?=
 =?utf-8?B?NUFJZjVDUnZ5dVh4dW9rNjB5aGM5OEp6Z0JITTIwSFFGaWkxRm1LTHpxS3FS?=
 =?utf-8?B?eVN6QXJsMnRBNlJHN05NSFI4NGRmRU9iRnZHNmFZa3VIbTVEekEvaFNFejBj?=
 =?utf-8?B?UWRKRlg4UXVTdGtFMnBZYitoOFFienh0cVdpVWNlUFdtcGdJRm1VZ0FHMW5t?=
 =?utf-8?B?S1dQZ2VCMzVMRGdUNS9CQkQ0T2Y5ZXU2THFsSVRESDVXWjE1NDFhTHBxa0h0?=
 =?utf-8?B?WG93TTg5TnptUDJlWEQ1WjVVaGp2S1RMb1pKRy9WSjZ5cTRsaVF1L0dyNGRN?=
 =?utf-8?B?Ry9lK2x1d0lNR2hRNkdvY05FeTF3OHB3UTBiUEpGOEU4WlJwUnVrKzMxQWUz?=
 =?utf-8?B?N0s5R3NVbHlhU08zRTNxWkhESEYxd1E5QVUvRlJUT2JsdnNmMnAwbVB3eS9s?=
 =?utf-8?B?ZHBqTS9SdnZXV0pFZDQ3ZzRGZGFvRDA0THBVaXlWcXpEMkxlNmFpb296SzN6?=
 =?utf-8?B?NmFlSGJDU29JSGdldFVNS0Z5ZDhnRG9ZTFRId0hmL1AxVm9CSHNzM1hTbnBy?=
 =?utf-8?B?SHp2b1NaRzFuUnNtYU9TVEdPRzM5ekIyWThvNytqcnFVNlpmejBBSjFIcmd5?=
 =?utf-8?B?OW5vUFdWdjdtWHVpODJoY1pFM1VJaFN5QUdoK3VaOFBINjAvaVhRM09iYnQ2?=
 =?utf-8?Q?AMT3jO6e2idtBrSE=3D?=
X-Exchange-RoutingPolicyChecked:
	w9ZNLe7lvvdLsRnfC9u460AWqTyqlcNq9ph5ESrld9jhG10YhkXfc+gYUPvY8UcYSuRFwl/sDe4sSJzsWIVqQ10jQxOwYEJM7C2zC3whuNBsyygOHwDkiDpGJywFaET97tzxWgZSYdXUO5KHjZnNFahPfAgHQ1IuspRWN28LL6sJxl+44g3u3onEUc5iFYC2tCRmdxRqr/7Ev26zENQhCXzi4IKCRwP4SYk1xiwcQBURW17e1wMfn1xQCMHTGYhutzoemJnQGKi8cP/N+OKQnUDpK9pUWuc005n2sty8wvZl+N/Vs2PQLL3O/2knPgkq8zDIDY2Y03l8xmsJfxJ2vQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uJDgFQfMGFZyc4DjNN2MekyOy2HrA+w3nIJZTtjkLiH94WANNKtJPnHmGq0gI4yUXj4ktIJuEz59kubN7YuGuW46/ZhjwTWYo7mmhMscKfkisD75gtPMdE096TfEnmfeK9+AsE01Wp4yvomxgDmBohVX/VqWnKZmPj3cagdTAG7vwc6id90G544lud5HzChXtd7eigMgp4wQ20eYqxtl+kKuQudg0jQ6NUGIlN7UUpwJhkRqEsAlYzPfO6IaXxD+rLxSmyYI0KBgOS4WkcigYqtK2Fl0zim4ioHVGOPZ3ZsJY/5p4iXNDP2VpSwcJxdL5twWjOuTbplJkrJMKIjjwRIhc1+moRMuc/pO2YiuXEQOkHL9fCFjnAQpLB9+1uc4QOwRyTCFZahR5VLG6P5UytS8W78zqZ1tw8rjomD9hSpQ4XAa704cLTH0Pfl8F9mIj5t9dVPWjHn2xq7hxUuJ8uEWLsXkzKO6EhJdDEMycpEKHiEypv8Wd5q1YvjH+A/TyuSl96M6GctU3e5VHaeD/CWSRpn1kXEpfIoWIRZpNk+1thvIwV6uEaiPoDuBficcBmtfylSlfxuDgO8BzAPqpgDWSJvJ6x0JHJ4dcGCRpfE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbb27ab-fb28-468a-e0c2-08df24072b35
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 00:08:52.0086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iTm4vuHnQRVx3qA6zMYhZOLgKtbgISNio/uHe4YuZKx54kzcjjpm+wsTZ8iaCr7A/esGg2orqa6P/lOLBD1ohctpnsf9FhPzwLGfRNtLUYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFBD8703CAB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610070000
X-Authority-Analysis: v=2.4 cv=afj0Dhot c=1 sm=1 tr=0 ts=6ac58d98 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=s3p_mlSWoKBcCmHIFeEA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX38Edybt5NxZY
 Bue/i0n9Xd+4u/AVzHWXAOysNyfUdFV0m8VZIW9SV5E5JDTcm+4jB+45RKmhE4yxwzXrmBOdxDX
 bKd1iPZn9O7zWZEKzih74ueWrxCIOTMwDluTgiixV7RMmwugCubxtxchmSREX6e9FMPPeYcFfD+
 ZvYsGm0fwj5VOXViioFU77dfmwg/9gRSV7OriTBv2X6LdfDR3Q3GCgB/45p2FaHLtlG00nVT5mx
 X/AKX7EcOpwEUEiV/5n1XoiGXhFsAYYKUfETVIFyJehlmV+OoJ/5sVAl0tCwZir+Pddxz98PAkq
 R+4BmF69H9NS+1Wc6aZ3A5wQgBTyo26eATm3n1m+ksppnBDM65ncS0KvXXz6IIJY9pw8n2z2dZx
 dmg+5X6++VOR20Kd79tXww9I6U5y9b7QTBgn8Fr0mw8w7N6bxAQXK5/z3jc63YhZcKdgfYNcB4e
 /dxEVIQ+2egNJSgdoXg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfXz4xQomLnOqr/
 QCYaknd3sd83WJ9KK2H39SE+5xSDvsATD3p8zOs7GylKStxEXbGCm5jXXx4wj4upPxP45CqqDF7
 GSFSqPeL+y82ISWM/xfYptfugp+jomOCu277Dby3Z41TkojPppFQ
X-Proofpoint-GUID: fDXgWSJGtDvdoVAN9ajLRp0JqlgdRPhH
X-Proofpoint-ORIG-GUID: fDXgWSJGtDvdoVAN9ajLRp0JqlgdRPhH

On 8/3/26 11:05 PM, Yehyeong Lee wrote:
> A transport that implements parse_pdu_itt hands libiscsi an index taken
> from the PDU, and both lookups bound it from above only:
> 
>       if (i >= session->cmds_max)
> 
> i and cmds_max are both int, so a negative index passes and
> session->cmds[i] is read from before the array.
> 
> be2iscsi produces one. beiscsi_parse_pdu() assigns the raw tag,
> 
>       *index = (int)itt;
> 
> and beiscsi_complete_pdu() forwards an unsolicited NOP-In from the
> hardware async ring without replacing its ITT, so the value is the
> target's. It also reports the session's own age rather than the one in
> the tag, which leaves the age comparison in iscsi_verify_itt() with
> nothing to reject.
> 
> Bound the index from below in both lookups.
> 
> Fixes: bfead3b2cb46 ("[SCSI] be2iscsi: Adding msix and mcc_rings V3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
