Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA728CF4A;
	Wed, 12 Aug 2026 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786541653; cv=fail; b=KNL32ri5pa3hEv7/xTYroeeaB+itO+bruXxHxRNT6XeBElfzG15P3anetzF/gAkWVB5NJxD3V228jWF+c3CFzH5zHHiFCuuAlnele+Rq1adaik8sJnYw7O26hBjxtchJ4/NmvJWHrB/N16I2PDYRL+Du/Fb5nwP/sTsYRvJU/YI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786541653; c=relaxed/simple;
	bh=zFguT7frY+RhSCPAtwaGoBrifQvnMrVTUPpczcO9FSY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d8DU0WoYERjZvyxYmnFp8IzR49kMnYRH7+ZY+KHTGX2MDwBrHxCJlyQoU+Jeg8kJXBM9/CH+elSS/06UF3XqvNvpgFkB755yGXJ2CEO3gv455BOYzLQsi8fJ9gC/pHmilRniqKri5JFtb7RRyZcru9x7xTx4ASSuDMMEkj8bO6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IowivZLt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m5E9i86W; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IowivZLt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m5E9i86W"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67C0j2KD3641291;
	Wed, 12 Aug 2026 13:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dz31NEy2K0Hmo9nRz3UtO1EbtqfemxHnNx2DixZR6Ns=; b=
	IowivZLt1w8aEdx0ePmAqDUkMI2te68v6gnYnkJQe6OSypyTIKTbKE6GAQnjJ/zm
	8JNubAFthpd4boWuMQ7TDG83Nkshavbt01bW+zBr1C7sChW0jNQ37EvMBdsUxKPr
	7vifqd0Dp5P1jCg8+4CIkmuqDJ/sJlaan9sCu87MIGN8zwyuB5LnKMqQ7RtGicEb
	EHY3b655Qnf7zPf6oaGFGiGL/JL3PNh5ACF+fjTNxwcBeUnOJ9y37h40NxUnweja
	CKEN6ZZoqv+aggV4p61LDFzQi7KyaG9V/7J9vqGQ0qR4N8lfYhzL0tTd8uh3sG0i
	K9At0pLi4PFWGUVLAN1mmw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvfxxqr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Aug 2026 13:33:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67CDU8CR000886;
	Wed, 12 Aug 2026 13:33:49 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010064.outbound.protection.outlook.com [52.101.193.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwekm2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 12 Aug 2026 13:33:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f6FuCLbniV/hXhbi98DqgLZQpg8S5Y4H4i4EDAUOlFENs6W6Fxww8x/TT+q+BGVfyy/ljTEeP9ExYlY18InjwBopMjNdR6gWRhdVNPgJRGDK0Sgl16viZOQYJU480Fz3258va9VuL51PhgfB8aITRTBDook7DBZArJTApSURq2XW/wsIpGVOBKA56d6SKaesjBJ2K+6rfHnLc9I5XmMfXbm1SJKTt+BcSaVGSfg/kDz8DVX1mxra0mebu2QvjjJ4/cBH18v57s3H/hX3OHrohzDFFNnEqr0QFY2v0ZajLdQyxJsVb2g6I0zfhDwq+bHsdVVrMvbyrf58cnqfa2CjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dz31NEy2K0Hmo9nRz3UtO1EbtqfemxHnNx2DixZR6Ns=;
 b=dGYCb/0Jn0svRv2Ah+KUlic4P5Co5gBmiPHE5q9xYl0jZH+LpimgzTO4uyjv6xL1AwWkzvZ3SgtCe5vg2RoC4ZXVnws9f3L+blSVHg9mv32dU3RUu6HDPNlBa+9E43nlUhVCPGKHoyETPJkvZzTE5knfeIEmKEJ/PsfYtuuMSB/38CAA+i7zkICogVZnpv8W7O/V2VI73R2ifML2O/BZ9VRrfKJRH3XL+aZ85PmcdmeWWfXD3jVpgSWPloXREFeL7+iRSRafFUYiQDkB1uX/oaYkyzLHwfwC1Xm4JL2z5z98zoaIWA+K6Glb4QpgbLdHAmEGE+MnwnUHpZid1Y9fWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dz31NEy2K0Hmo9nRz3UtO1EbtqfemxHnNx2DixZR6Ns=;
 b=m5E9i86WbLX3FJp9K+tOO5g/psgKsLr8Jd5SKGGIZpzl8RJUun/jYNkTy4pAonAVFNa4LMMElxLXaX2f2S/Q2XUIBRiGgFOcrHa5RPAqvPKzxM51j0zoJDtnVELdEkMaXFkxEPTvgnU33TQkVTiGz7zHQavTMMVJ/fzfECJd+D8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BLAPR10MB5156.namprd10.prod.outlook.com (2603:10b6:208:321::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 13:33:46 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0315.012; Wed, 12 Aug 2026
 13:33:46 +0000
Message-ID: <bbc02974-b661-423c-ae5b-9743791d1769@oracle.com>
Date: Wed, 12 Aug 2026 14:33:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: libsas: Handle errors in
 sas_ex_discover_expander()
To: Eshaan Deshmukh <eshaan2031@icloud.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260811162223.411052-1-eshaan2031@icloud.com>
 <20260811162223.411052-4-eshaan2031@icloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260811162223.411052-4-eshaan2031@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0297.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BLAPR10MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cc152f0-3939-4ccc-8dc0-08def8765586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|4143699003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Xc9fB5Bbv0ZKJTtSSCxB8O/H+ATJ+aZXkkEGhQ98xP8ApFHTyDZr30TOgkTkTgP1vzffwjpvJnlQhV/aSPsA6uaTRatbYRKxjaKoVeXMPjKCcG0HRuCNlwLS+7fQ6vw+6ILKFxkPk3dgcgtvv2plZPXuqYRbt/J+8ebH1kOb0Xrf5c497Y5gU4zMsHKnhecBTxZTUZm6fMU7gB8bjYcPEDpgqMl8G+BF1L1d9pkFbNGFacHFMtIz1I8L3EyL/6XFoLTkzLp+g07ZBPkRCJCV2CYb9yKFp0wpyXlqptCbbDlTDSdFM9H6EtB6Fm3EclpPwLRDuhf+zYfE1uG0Krv4oT0BP18kFmxrsDdN0WscEDLV1VzPo7/C9iQDY0LCPn3ASbfY0CIQCSVU7nhopFhONgQM/ngsmG/H/eSMzNcyNKR8TZ5hdBpb6HU9F/kjK1SMft68cBxAG6sIpe/8+lOiCjDfdfAl6yir+jjbOgX9NB7rGvn4VbGUqT9da2IQeflvk59itApsigDgfGWltANVr2Nplc7nlS9CdXyx+CIrQ1OqP/nl929tBj9YaGz9w/NxEkMM3w7WTc8Aoibgo4qGkBHITyDebmzulcDQ5RhTx21HiCQ+OIy9WnsxEg92Xs7SoVjkX5OindaTbxSKOxP+1KFuExnhVQqBT+BGc6wyr7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TS92T1Q5dk81ZlRoZ0FzZE8xUW1oeXNJbHh4Q055N1JHcklxSWVMK2VRYkdt?=
 =?utf-8?B?YTFTS2N6YWhzR1JmNGh4K2N0ZE90R1NxOTVjaUlmeWdPeDFJMWh0OHVwaXZw?=
 =?utf-8?B?cjROeUpyWUdIZzJCQ2J1YVlDOVFUSW4rUkk0NEc5TGtaOWxMUTBZeUJqWkxa?=
 =?utf-8?B?WEpuMEs0UnFnbDd6eFlEOVlGRHF0WnJNcmVISC9taG9NMmdrZThQU2tEQSt5?=
 =?utf-8?B?RVRjOEExZkEwMnArdXVzZHlCenJ5L2hyS1JySkx6bW5ZU1lRTlZnVlZTUE5q?=
 =?utf-8?B?ZnpYdklYVktENEVkVVl2SHNHazUwSVZ3WmFpNDBvbFVMUkVqdk9qUlFiaS9Z?=
 =?utf-8?B?YzFWVktPQ3Y1UFN1RFdOT29PRW5jL3JwQytPVG9RdUp0WjJNdDVLSXNQMlRi?=
 =?utf-8?B?M0pVMzhEU0pEcUdWd0JvK09uNDliSXBkeDhGZytKenloS1RPUkpUSVBQNUVh?=
 =?utf-8?B?REZKN0hnL0RtUFY0UW43Vy9iZmdiUFV1S21hVzdEWDNwRWZ6SW1MS3VxdHdu?=
 =?utf-8?B?TTc4WWVwUUJObkNPZ0h5anVEbUtzT1RDRWI2VEt5ZHhrMkZCQXFTS2dkUDE2?=
 =?utf-8?B?WXozNkQ4VXV6SHVWV2YyL0tqME9YcVBlNUk4bk9LTXZDZE0vY1ZIYWpFWlQw?=
 =?utf-8?B?RG5tRUpUVnNGM1dKQ3BZazIyanhTMXhGNms2Y2Npb1NLSlA1V29lYVJ5a2I0?=
 =?utf-8?B?SC9uaS9KWVVrUFErQjNsc3lxY2ZnRzVMSmJVYXd1RWV3ZXpRY09wdS9LLzFS?=
 =?utf-8?B?anppdFBiOTZZNFdxVXh4Z0tzMW43Z0pURXgyRlY3bmFiWFlrZzR2SUxDUXdi?=
 =?utf-8?B?M0Ruenp2MHA4aG1RYzJoeFNGS25LTCtTYTJGZlpabnhDQ0NFbUUzaDAwZURG?=
 =?utf-8?B?M1FMRnVqQ05nM1FPNlRBdUxaZ2V3UFBnOFFYb2MvWkQ4aWlSOGUyTmhUREtl?=
 =?utf-8?B?TlVJQ3RQWHRUR3NEZGlhaG5BQmlEck53STgwOGJZTyt4Z2MrK2xOeGlYMHNy?=
 =?utf-8?B?eWdWUThIemszc0x5OEJqTVB5RFRLMHhnVkdBTjZ4MmxBZVZSQStOY0U4dUtr?=
 =?utf-8?B?ZDdyRjNZQXVLd0dCcDk1ZGlDYmw2Wks4d3N5U2VJSkdEbWs4K2hYbXNROWdZ?=
 =?utf-8?B?OU5DWUM2Vy9oeTVCZ1FjaTNrVmptMXMyZUo0WmFtd3VPbzFQakFYajNVMWtu?=
 =?utf-8?B?SnFmNFd5L3pUZVk5Q250TzRVbHA5aGx3NHRiazQ0Ykd3WGdveVR2S1BIUklu?=
 =?utf-8?B?NDIyckdXUFJ3UURBd3Z3Z1pRdE91SmFmaEo1cTZQeXovVHhBaVJ5ajJpMDhW?=
 =?utf-8?B?b1FvYTY2dmtYVklNYWduYjZtcmRFbTFsSERiMy9MRnNSeFd1K2x3MXVXdVM0?=
 =?utf-8?B?c3dYWHIvVmk1Ymlia2hyTkRzOTdiMjdNTk4vbmR2aStYTzBBQVhTb3hreXdJ?=
 =?utf-8?B?bGNyeGltU0gwN1Y2bnJWYUxsVm9vUFhDclZqNE5Kc2M5aVk5TTdDTFBtZ2x1?=
 =?utf-8?B?dTN3QVF6aHBMSGxVZ0ZWU3d4eCt4bXE0UG5BZEVpL3QyQTRWNUhZSWpLQzBR?=
 =?utf-8?B?N0puSzJGQ0htdVh1NmtqdjBzV3BxNmt4MCsvQU9nUXM2blIzamJWbEN1TzQ5?=
 =?utf-8?B?UUdMaUFsQkFwVTFhUXlpVXFsKy96ZHZ6QXYxdjRjY0RqbkxBWmFwVU93K0J4?=
 =?utf-8?B?SC9tSVJWeEM1SFBqR2J2bEdyeWV5OXBjNXYxdTBCamJJMWpLY3d4UGs5bkJm?=
 =?utf-8?B?UnVGRFg5MGF4YUdMUjRwcTRBWHJRQTdsdkp3SEh5UkE2TmRRdzhrTHhJZG1O?=
 =?utf-8?B?ZG9wdTFCNGJqQy9ndVZ6Tm9aNzN0NTBYd2NEbHJ3cGsrd1JGU1lObGlkdHV0?=
 =?utf-8?B?Y2M1TzBUTUEvT1JEMFQxd3RabnR1eEFBUk4xZlZ2MGhlWHlYczZyUGd1YlNa?=
 =?utf-8?B?dlNwOW16ZDNkd1FKbzRRMTdCUFFzNlRTeGRudDVST1VBbkdOMXVTeXA1SFJF?=
 =?utf-8?B?ZWI2RnU1NExTMVRRN0ozQmNFbm5ielVac2k0bThNdXM5Ui9LRldIMlNYbG1Q?=
 =?utf-8?B?OVpNRkRVaFJJUjFFL3cxY0kzUU9Kek80YzZaeFI1SXV4cTYyMnRTOHM3bGNt?=
 =?utf-8?B?UGNyOG0zd2g5Y2xkLytlZTIrcEZxZUNLWFJDcTg2dzZDZ3RxeTFMUzhLdEZq?=
 =?utf-8?B?UFZ1QjFsaDAzZTJYM2V2TGlYZS9aSDhRSUVSR29BV3luMEo4cmZGZzhpbEtN?=
 =?utf-8?B?M3lEdDhNa2VaQXFyK0NKQnV2cXcveTgxRGFCeVNoQjVuVG9SdzZFYTE1Tndk?=
 =?utf-8?B?VjhZZWZvV2x4NEZVZXh0QVAzeW83ZGhCQ2phZkE5MDFMc0ptZ1VaWElRVW1m?=
 =?utf-8?Q?xIu3vLLgQYn0bkvM=3D?=
X-Exchange-RoutingPolicyChecked:
	D6E8iGBtMqIoQxO9kmfNhPMyFqvh9VZnejayv+KemoCMH25sw3UTEaLh5gbwR0qKx9GrRqQ1fWLzuu4z5pcHLgzl/UU39YzEgJgy4B/fE9UIG7Hf2YP2BgVWbdOpXoqrrtD7hNSw9HGxUH5NhQEISiGz2TRKSzRNX/sdwuJklbe443Tku6PX6Fw9s97Qp0yNKo6QFxNW8x46xdzp9dD+UQzd9HmzCQ6o/OgUNzVkw/Bgw+/vLQ0bGobDPAEagOz5vslSSY4FnbZ+07QCkbeadQ+xHU/588ubZSHG0SwtTNuar5zaStfgXuSiJsf6bd2ogwcqBlyexk4PheT0wpAaXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZWn1SkTqXq7BVieVk5ICl+PylFkJxNG7Odj54VxEREJ0Kq578ufWLMzw/uNZDG3EA2RqgcprC3p2QHfjHZcjC0OlShyX5FotbPaLSjHPuvvU5NbNYN06IXAjPqJssjWbs47ThJnIxbdSaly7uNM5+8AKY/HYGW3YFXRH0aAOHQwHtDcEdc2eUEDqcGB23iXMEDnGwMxGoU8g+HYWVH6R0UbVwCQVev6Y1Q7IYGeJ6kBemC+216YBx1fzJoPy46qRXKhmxVwS8UnJzrO8iScuF8LX12fIzxqEg4hsXrawjgYCecJJtrkwt0FPnaoVHj4t9O+pTLGH9j2WFfdRHAsIoGL+x1MmwRiElSa8xDxClNv+FXuTK5TVqt6jaVYM7w2tiZmYcqGcUdtQAuIf4D6ODG/Apv+u3V3QtUapj9pPU60rB20VCd8hxhtvfEy6MpTkzHyCfeF3cSHK32H++GmZ5w/smviZQi3yGIDEesZbGy4ekQUn4ZDONHwsSKKH7UbPV90gugDcm7xZolngB4m1oGgYuKTmIljNwAvco/0rtnpv/hgYa5NU6yhZ4Qq1wuW/uvHJBosRWfNUfOSqxy94VfHUVZhbv0Ndr5tDKI1YTcg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc152f0-3939-4ccc-8dc0-08def8765586
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 13:33:45.9674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRlXoFlvQCHoIyoIAQvV7gEdjoFp5mfogQ1GTEnTyAP81SSZRntajy/7gbPN4XOdFk1iPEQfRk+DZm8WLSHGXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=901
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608120110
X-Proofpoint-GUID: NAAIiKnVTpup-eUZ7Rn2sL8U_U2LVBka
X-Authority-Analysis: v=2.4 cv=K/sS2SWI c=1 sm=1 tr=0 ts=6a7c763e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=YHDuqKY6-hR_7rxc9h4A:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: NAAIiKnVTpup-eUZ7Rn2sL8U_U2LVBka
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDExMCBTYWx0ZWRfX9TV53iEehua3
 76BWJC8OMPhrROdtsIE9BXvku03vwxA8IXH/665OVVnQ29Kz/e+yEzpgTVQI722u/rsDXcJQs4u
 mzWyaUctTI95JQL5enH1YdowzaGo0zpQ7EXdkFhiCsKpZfz7HlRDInMABs2ErRFA8e7cY6Dh9gP
 Txpfb5hV7VP9r/qB7Kh1LerLfaSQ76j8UncTCqntmhINRtVMskGw/zufUGQetts+szQK1K3nxWj
 LSxRVXXUDIVZe9UMJ7tlBSJ7LbNqeJgtgNvtKwaTBjfdZIoNbVXTjB/ce52J3lijUk/w5kHu7Fi
 +6xPKmnVr2PRbzeSq/XyWDi1pL5GQBjtmHahfC/8uyc8GhpDl15oyqlbEx4MxQFB/gN59elWUrh
 aBq9W7T2TsZ42zUA19oreWsfbETk8nLO4Tx1e3q9J9SYOY7wmWWQYRkfTDXS+24XdQGQ3vHRjiS
 kcbC4gMIl1/GXJ2DX7w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDExMCBTYWx0ZWRfXyyRc37ZSX6a2
 WWKZRSRxPt9sHmbhzDlXh9yLpRYLJjEpud914nIqKmPYCG83DOxagEO5maJ/Fb69hmjZnI6d8Fi
 QOQ4i5DmTLvxYVtJJkfuG1vrrizabLYcuR2b6kzy5oc098qM5HeG

On 11/08/2026 17:22, Eshaan Deshmukh wrote:
>    	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
> -	/* FIXME: better error handling */
> -	BUG_ON(sas_port_add(phy->port) != 0);
> +	if (!phy->port) {
> +		sas_put_device(child);
> +		return NULL;
> +	}
>    
> +	res = sas_port_add(phy->port);
> +	if (res) {

We never pay attention to the specific value of res, so it's not 
required, i.e. we can have:
	
	if (sas_port_add(phy->port)) {

You can also change the sas_discover_expander() call (not shown) for this.

> +		sas_port_free(phy->port);
> +		phy->port = NULL;
> +		sas_put_device(child);
> +		return NULL;
> +	}

There is code later after the sas_discover_expander() call which does 
the same tidy-up and more, so maybe it's better to have tidy-up labels, 
like:

if (!phy->port)
	goto out_put_device;

...

res = sas_port_add(phy->port);
if (res)
	goto out_free_port;


You get the idea...

>    
>    	switch (phy->attached_dev_type) {
>    	case SAS_EDGE_EXPANDER_DEVICE:

