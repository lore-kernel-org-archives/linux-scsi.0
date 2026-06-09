Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BE737F730;
	Tue,  9 Jun 2026 08:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780995065; cv=fail; b=V/J7m43ljHHQ3SwljR94hZkVm51VYf9YXoLlCGidh5eAfvF+AnCesP0mArdapxfEtdkWnLd3FCs8sYacGnOXOrtTfln+FaiU484vjFUWqoQO4ICarQwecioc8fYnUw/AX5y1gKQPAbMrnMCR/t0egsCH7NYKEH3pdMRkB9d14kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780995065; c=relaxed/simple;
	bh=O/Apq20/IIozTshUutQbSx6dJQe+vvcnl3elVmmkjQM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aq6FxfYxkpP/4qe2+1TP5wICDdDoXG5N0XKRr83XbysJ++2QiB3uH47bdtPMS5I1b1xmX8wjNLYemHfmbSxH+mX/RbMoZe7IpOMhkjxhvUJ1yjIJ4kBN8p4xI4GJaBavSoU7XdTib62m6Lnr8CevbSEK94XmoDePeZpq9DCxH88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C5ZYMj0p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ppE2SNSl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C5ZYMj0p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ppE2SNSl"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6597wk1C1535172;
	Tue, 9 Jun 2026 08:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=G0uWxWFpLsOJDcnAm2/XBEODAEZyoOUdlwHk2etvmBw=; b=
	C5ZYMj0przvPLOm10k9e9qZ0j895WItjSmGavJVMZaqNdzru37aMCFmQOI5xfHcZ
	/PnHpYtTdUXn8070Gd+LgxxGh3xjz77FzcikoMyP4lsnolRnhTWGTnOY9JTXYJQb
	39fOUaCxxKrXDBanm1x8QH+8XFwplYtOziDaYZj9oUwoFZhiWMmVx4W9L49MhCzR
	Gf1/DsbFV2fGEOlsggP2ZFnZ/Mq/cumCektdPgu1faIBD4ujBvft2pyzJRxV4VWu
	9p62yM0U3+qTVfS2OUSeYOtt4L+VURVKm2pgvzIDkif0koddyC+7jIQZc8GOQojf
	e2hvDxXuuhelfQbXFBn7xQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emb5suy8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 08:50:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6598lv7m003401;
	Tue, 9 Jun 2026 08:50:47 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010046.outbound.protection.outlook.com [52.101.56.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0ee146-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 08:50:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m8MTN93T6Yuka0O8u/ge8kyGy5hsPpnM6pCa6c0t716Sggs2oxKp63su6HOPhOfBYEfHVvpDGcFRvVfGjY98AUTz2okUu5oKCDjVwjGI6NhrHYTSaSE2lzmaTbRq+LxijLVt0mP7TwzrgPkJBgGxYbMf8CP7HQENSN4d0WfYUO6PrEukN/iqjkDAd+HcWyjRgCQgKF1CWD6hbYbNVKX2zzaUw7w8+aqlFyPeUpiFgRG0eeWdU+fj1lp1LaujEnze07cmaVgw+r1IfSoHCQsx9Ku99msNKbM910QB34VG/ZtFgpb2+rKIstZDMHuy72EF9303/lLl2fv45r18iRyZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0uWxWFpLsOJDcnAm2/XBEODAEZyoOUdlwHk2etvmBw=;
 b=QcRcHDDkxcq+xAJ+rmRB1urrTUnnOr5I7g2bUTQxfsU789rbshsXaQdzyHGUjhtKZXXVDTBmpUjveD88olZyNcMQkaIgd8wzyuOafouHgld61RlUxSoRPM/10HC5oe4SXbxuTgeCFKOrK27wB7so8v8f2DJmY9a7Uw78mhCWltWkGOIsFiQEXuin1857QMjVYyUINC+nXDQqcB4WHa2VtCf18l4Rg1qrAk/B5i1VjojM/LTctSHG59QJsghFM3b4zQIDSBi3P9Rhhh5lxTMK8H8E/O2NEmFNfWsuCa4oGPyCuxTtHziAWQWce1jcZxfz4O3nl9XBpO3FG6H1/grmQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0uWxWFpLsOJDcnAm2/XBEODAEZyoOUdlwHk2etvmBw=;
 b=ppE2SNSlOD4dJrU68oHR+nV34EmAJmvNPA2ju7SWtjKzBXXKDQn4knzUAGN3014yoOdsOkJhj6e0zVUBbtRWuDSCvxmzwQaLWY8kidB5+AkCY8212RDjoDifNExirmyE/F8PK8cfRvSE8PTmYw/PIwi3/q1mwFc4xnlRVZtu2WM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA1PR10MB6124.namprd10.prod.outlook.com
 (2603:10b6:208:3a8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.15; Tue, 9 Jun 2026
 08:50:44 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 08:50:44 +0000
Message-ID: <fdb07a39-cf7d-48aa-9e75-1a79dc7ad620@oracle.com>
Date: Tue, 9 Jun 2026 09:50:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: copy iSCSI ISID before unmapping the PR
 OUT buffer
To: Bryam Vargas <hexlabsecurity@proton.me>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260609005858.17504-1-hexlabsecurity@proton.me>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260609005858.17504-1-hexlabsecurity@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA1PR10MB6124:EE_
X-MS-Office365-Filtering-Correlation-Id: 769ba3c2-bf40-46a5-3867-08dec6043120
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|3023799007|18002099003|22082099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	uGd8WsOv3JzDlr3QVZct6sgRN4eWtcznutc68SdSo000rcRKZih+6tBQhdyjwQ2CsHZZQVFb2wXKXa7nekmw0afCmxzuWZ9/cAgcj2j1P8qqW0s93l3l+I3QUaOeVnPunG0sFo0RR8iqAsO9SzZ3QB+grTGNHNSSAm2zXnqp8zhJ3UaljzR08AhMB2PLV1Dda2Ll89E3FlgH2KTK/4GvfSLUbK5eJTcPW3/lwHDZBZ3WZ/drilS9ZYA5YacCV+R/R4+hgqNjY78cx3eUipQLy0DJI5Cw6lneFlrCYAw0Qoz4OSOVOZy4xg0DuFui0Hgnu4wQaSx7238vmJ285m/8IsdGKCW/3fMrA+of0yJfurGGtn7hb1iOKnbACaMgHcEpTDqA18IEvNkTrSQvbPhvoa+HIn8N88C/tglKETjrK7oPdISUOp5tppCeUCwqvXwdl5TORVkRlTTvo6ejz1bml1QETotB6l2R6cK2ClMfRJ4n2NS7hQTo9SszMldi24shixKbvxU9Rq6JZNS0ycVCX1I2TKGNk3ImDt4jAvitWqTu+TlcwbzdwmHTKZD39Uyjv+D+wu6mAFkJ54aut2loJszHz4GNStxFDTxcSQ8aAcC4W9yZFRYgsskA2Skm/sdDo1GvI6MYdu/l16vmja4cqmre5qSjv0EUlVSJwhGpvitmMhEv1sX9Lq2huEtZN/vR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(3023799007)(18002099003)(22082099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDR6WS9IM1NyMmljWlNNOUFZdDErYzhxREkwOUh6bFJySG5MdXJFRGlQbDlM?=
 =?utf-8?B?Y0ZiOEJnSXZSaGZRTzJFaHFFdGNyWndqTGw2OEJybHpYc1BvdU9JL2FVdVd3?=
 =?utf-8?B?ZmtxWVZwSUs2NGthM0t5b1hHOG04V0ZXWmlHZTgwZFM5NUFIMTBucUd4K1oy?=
 =?utf-8?B?emNSNm5id0FSZndsZUZ2d0o5SFdWMjhmUUowSnVWM2VLRFgycVVSYk9KTVNH?=
 =?utf-8?B?MFp5THVib1hvOUlUU2RtbW5pV1lWMjRENFRlRTloRmhjeSsxL2xPZHkrZ2Jx?=
 =?utf-8?B?RnVmL092Y2o3c2lSenNnRUlIMWJUNjQ5dnl1TC9oODlpT1hQVGlrZ1ZKOUsx?=
 =?utf-8?B?L3ZFUlo1NmJ5emlXUnZ0T1hpNEZ5dlhHTUFiN0REbC80MmkxWXJqOEozeHF0?=
 =?utf-8?B?aWJ1V2VxZVc1T3VlV01mQlB5TTNtd0F3Q2hwWnh1SHdHcGRUbUZ3QVNZT2dw?=
 =?utf-8?B?VVZ2UnpqTkNUZVc5dnJWVUdjS3oyRVJCSzZQekVEeWtZR2VYZitzU0ZTdGRP?=
 =?utf-8?B?RkVLenU3NndJZXh4c1hOcm02MXpBaEVYUm04YzFJR0hWYXFrNFZMVEFnRHBr?=
 =?utf-8?B?OGNwVEQ5a3J4Z2R3MitvOHlBY0h3ZEVab1V3RFArN1ZDNGZnUWs0VTdLSUNp?=
 =?utf-8?B?bWY5YWxjQ1YrNDFXRmREK1lhTjBuUCttY1FnVmhGb0Zxc3RudjFPNnJyanA0?=
 =?utf-8?B?VXE5WXphbVEvZlhJNUNNdGk4WWFRSHFVWG9JdldRTzh6aldpRExWdnJoalFm?=
 =?utf-8?B?WHlheWZGYVowTVYwNGZlMFYrR3BodVJ0cWJBcmpMK3l1T2l6eE5nZGpTQXNW?=
 =?utf-8?B?djNDV3M2SkxCU3BoZTBXbWVFV0NMY0FGd3VyTnNRbHlaUzhxSGN2cnY1Mk5y?=
 =?utf-8?B?VE9MU0dEZ3RMTGxHaW5rQzJNRnZvRmNEeFl2STBTK0Z6dm13eWZZSGFLQW1m?=
 =?utf-8?B?eE5pOE9ZWktTbXEyc2pxZDFCWUNOdlJpN0FCUzl1TUl3Q2ZMVkNWS1JndzBt?=
 =?utf-8?B?ZGkxYW03Y0VGa1dRS2QxQW8xTTVKcjFRbGxhMkMvSm9YeGxoeFROWVViMk1Z?=
 =?utf-8?B?QW1DRFRUbGdpVEgyQm4wWExtQ3pjWU5qVWhXQTZaZDd2Y3BaNnF0eUtPK2VD?=
 =?utf-8?B?K3p3bnJXN3lxYjhPd2w2UDFWdFNIWGxjd2U5TXVpWHg0Tlh5NXdkUWJpRjVD?=
 =?utf-8?B?NG1OckJQRzV4ZnZDZ0ZSZldseHJheFZOOVJaT3Z0cVo2cWZYeEUxY3ZSUFZ6?=
 =?utf-8?B?Y1h2MEJHc1NmL0VyT3Q5REl6TENTc2dDbStGOFJURFZZU0diSVZVTno5YTM2?=
 =?utf-8?B?b3RmWkY0VlZJa3c0UE5IWUc5dTFQc21rUnNERFpISEdxdE9KK1BjUUhPS3l2?=
 =?utf-8?B?SDlQcTBLU05FN3hvajF4Skw4N1RrWUZKQVNmK002S1JlT2Z0d3NxNUVWY2FY?=
 =?utf-8?B?TC82R21PR1o3SjZ4cjJaMzZYcXQwVXhsNm5CdElva0RvN0JrUFJDazdsZEcv?=
 =?utf-8?B?YTc0YnluS3cyd1JnUVR1cHR2T2VYYmxzMVJxT0Z5VVNzaFlCeklHTitRaXdS?=
 =?utf-8?B?dzRQMlBPb3VWQUY1OUQ4aW5XeHMyUXlBS2RsZlpVbWN4Yk1mTlVXK2N3WDQ2?=
 =?utf-8?B?Z2FVV0VoY2xYSWlxUUZJUE9hVGFpZ3kvMkZFZTdlQ1NleU1nQTRERDI3Sm51?=
 =?utf-8?B?QWFMZ2gwaE9GcDI2czJBQ3lsL3RQZkpoNVJKTjNqVERpczB4RDdNREJhb1lC?=
 =?utf-8?B?ck03SFJrQlV5SjlkcmJENEdrUVpsS21LWWdhc2UyeHdKMHk5bkM5TkJ5ek0v?=
 =?utf-8?B?YVd3YTVWQkt6MzNpSWtXMC95Sm8zdFd4R0IyR1YwYjFaa1FRL01qR3gvbEdS?=
 =?utf-8?B?S1RyUE5TU3R5RVREd2FJQlN3bCtHbWQzbVhtaUxMR2pQTnRvUGZBY1hkNmF4?=
 =?utf-8?B?eUVIMlJmeW1lMDF1QjNTZEY3SkVQTVdQVXNWbXNpUVBmOG9JVERONUhXRVd5?=
 =?utf-8?B?R2NTYUgxSHh4Z29Yc3R3d3RIWjR2UW04UURiUlVSZlRsR0EweUY2MEx0K2JB?=
 =?utf-8?B?M2NMdkJYWk5JeGVwWU1uUCs2VUNieG9iL0FLT0Jyc2wxdmd0aXdwYTFva2hK?=
 =?utf-8?B?VVRsRkJOZ0NnbjVNeGpBTHNnQnFxei9mQ1VOUnQrcXZ5dHJLL0FudHFaQTJT?=
 =?utf-8?B?YWsvNUVHbFBrZDF1eDRLeHU1Q1pubTlmSjN0OWpEcVRsdnFSYmt0WFd3ellx?=
 =?utf-8?B?VDFyMGdnTzF3N2x1a2plckZJZERDRkUxK2lVMWdFOENvSzVuWVFodncwQS94?=
 =?utf-8?B?OXpkOGtXdk9mSkE1aFhUSHlvbXhrZTd4djhnbHRkREhLbFJtRURRUT09?=
X-Exchange-RoutingPolicyChecked:
	izYa3vc5rOAaE42pKEJR5EllIN3F+wSIxOhsJ34x98DRIx3/yg8vC6FzJE8DHtuSIJ3cUmf1bzPZkSsN5WCnMwC9qOTGaw9TGnFrJXBvJmPAWrtm9EuHJp9GQFYHBthHYOVGf7r6bJDLqVwoB+X8vIoKPSckEWo+EjcpiWF++bzUu76E7tiEks66hzO9+To28Ep1ySfSLsxxT2r/ajBItANbs77kKIG1LtI2S2BY40pRoNR/FvstOUvU6OpP60vMLiwniH1k97xWkMbupfujoT01yq1qK6KaTYcSXdIGNnNPYZ3t9jDkOPUHkXviE8xvCTQkjYTLMvahFC/24Bi8yQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0YIfEU1pBTUFf3FA+jR6zVBg1c6ZcTky6xaDlFY3N7rx9fLNaU1rM+YE/yFx2bzuEWo9rJN/1PN0FYPSj/kNzpjhp/FtKxEcPJ0cjmrxZwHA1r0DEWVGrxg8k8Zw7MrVfuGbgFHHK4oDyXab91ScKNwZBha45fYzC315iQLVkObDx944ZfCtOmh8g8ZPFvtsu9N4Koftuh0R/PUD6w2ifPKyPpKKtODqEhi3hn0AlSKmVqLrHu8I0deHI2sUwXORr4mVGRW0q4AawlDJ3Ss/lZ3TFZC6iuf6+JneBbwN+yryyPS2WTLd4iOpmVDyUggT4qgVgi4x3uDmBJmFcVHkdU1xKX3u3ON2VIFkMLAf1FlQY2Qrcf4tKLHoKE8UqxWFntHm9vFSX7xP6TsVgdhNHQEq4JzVnq2pdpqqlO1NIrBuUSuWc9svZauzrGjQ8ADIRHz2+A7ckSYg0VKP7d1j12lQZDPjalzMfMSPCFZzTcW/UNAL7CSsBMPCzSa9RGP1pbZTiDGfk+rpN4P0r8L+uFXBPdi7Xtp5h48dR7E2Pw6p1eyiqA5ioWusho72x7G0VZgSXAkzLFdwuTdPdfisCbmIj2TkZduexX9cm/Qcr1M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769ba3c2-bf40-46a5-3867-08dec6043120
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 08:50:44.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4OJgoptQq/eNoBOT4YbbnB73SH/f38zS1coSTliaTbz9KgzREvkNSr4PsQdY3GJUQj9PyEDlW+3KessHaGD+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=991 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606090081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4MSBTYWx0ZWRfX5O4bQjKnyPeM
 aecWynav5rRROsEYmdrR0veEDAhHHmHv2b+UefbI5aL4XZtGPsCKglrcF4cskQIYgfuhJBenBxJ
 oi9wSnSH4wkJF+TOJ3JmBInfVEyM0x4kz49CcqglrbE88lHXsnDT0/m9/Gx/bWAKV4on4v+xLYh
 IWlklFgXERqXgWhiDZyIQTDPN0f2bgxv6A14KwxyaK4eM6y5aTLCnVzn9cYIjeDT6PQMS77OTvg
 jDcqiWWGbBwgAvR1j0d5fIkczBjjHfqL0sjfozy7WnXiuUvG4DgC6CdGeTBS1QLj6z4urjAS7sE
 plthCA4Z1Nym8hmSOj7kmwu2eXtBsTuey+JP6v4maKjkRhfPuKkkg8kZBMkDP9GPbD5BBwtO3Qi
 m9S65ZKD/yGd2RKndNO2o93OLDbtpGvk9ra6LzMulDFTAucIACZ9twChqJWj9kokdwL7abnukPZ
 XEG60UeVZHTZ8YEwN7w==
X-Authority-Analysis: v=2.4 cv=XeC5Co55 c=1 sm=1 tr=0 ts=6a27d3e8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=KkopUOm53BCFGkXmBOkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 15lgIFiXnrmxvjPgDFhkZFY5ofHGgyCL
X-Proofpoint-GUID: 15lgIFiXnrmxvjPgDFhkZFY5ofHGgyCL

On 09/06/2026 01:59, Bryam Vargas wrote:
> core_scsi3_emulate_pro_register_and_move() maps the PERSISTENT RESERVE OUT
> parameter list with transport_kmap_data_sg() and parses the destination
> TransportID with target_parse_pr_out_transport_id(). For an iSCSI
> TransportID (FORMAT CODE 01b) iscsi_parse_pr_out_transport_id() returns
> the ISID as a raw pointer into that mapped buffer (the bytes following the
> ",i,0x" separator).
> 
> The function then unmaps the buffer with transport_kunmap_data_sg() before
> dereferencing iport_ptr in strcmp(), __core_scsi3_locate_pr_reg() and
> core_scsi3_alloc_registration() (the last reads 8 bytes via
> get_unaligned_be64() and copies the string with snprintf()). When the
> parameter list spans more than one page (PARAMETER LIST LENGTH > 4096),
> transport_kmap_data_sg() uses vmap() and transport_kunmap_data_sg() does
> vunmap(), so the kernel virtual address backing iport_ptr is torn down on
> all architectures and every subsequent dereference is a use-after-free of
> the unmapped region.
> 
> initiator_str does not have this problem because the parser strscpy()s it
> into a caller-owned buffer; iport_ptr is the only output left as a borrowed
> alias. core_scsi3_decode_spec_i_port() consumes the same alias safely
> because it unmaps only after all uses.
> 
> Move ownership of the ISID string into the parser: after lowercasing the
> ISID in-place, allocate a private copy with kzalloc(PR_REG_ISID_LEN) and
> return that instead of the raw buffer pointer. kzalloc() zero-fills the
> allocation to PR_REG_ISID_LEN bytes so the fixed 8-byte
> get_unaligned_be64() read in __core_scsi3_do_alloc_registration() stays
> in-bounds and returns deterministic results even for an ISID shorter than
> 8 characters (plain kstrdup() would give an allocation shorter than 8 bytes
> for a malformed short ISID, turning the be64 read into a heap out-of-bounds).
> 
> Both callers now own the returned pointer and must kfree() it when done.
> core_scsi3_decode_spec_i_port() frees before each inner-loop parse
> iteration (so that a failed ACL match that continues the search does not
> leak the previous parse's allocation) and at the error and success exit
> paths. core_scsi3_emulate_pro_register_and_move() frees at both the
> success return and the error label.
> 
> Fixes: 4949314c7283 ("target: Allow control CDBs with data > 1 page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
> v2 (review of v1 by John Garry):
>   - Move the ISID copy into iscsi_parse_pr_out_transport_id() so the parser
>     returns an owned allocation via *port_nexus_ptr; callers kfree() it.
>     v1's stack-buffer approach (isid_buf[] + iport_ptr = isid_buf) is gone.
>   - Use kzalloc(PR_REG_ISID_LEN) + strscpy_pad() rather than plain kstrdup():
>     __core_scsi3_do_alloc_registration() reads the ISID with a fixed 8-byte
>     get_unaligned_be64(isid); a malformed ISID shorter than 8 chars would
>     give a kstrdup allocation smaller than 8 bytes, causing a heap OOB on
>     that read.  kzalloc zero-fills to PR_REG_ISID_LEN (16) bytes.
>   - core_scsi3_decode_spec_i_port(): add kfree(iport_ptr) before each
>     inner-loop reset (line ~1574), at out_unmap:, and before return 0.
> 
> Class / impact: CWE-416 use-after-free (use-after-vunmap) in the LIO SCSI
> target. Triggerable by an authenticated iSCSI initiator that is a current
> Persistent Reservation registrant on the LUN: it sends PERSISTENT RESERVE
> OUT / REGISTER AND MOVE with an iSCSI (FORMAT CODE 01b) TransportID and a
> PARAMETER LIST LENGTH > 4096 so the parameter list spans >1 page and is
> mapped with vmap(). After transport_kunmap_data_sg() vunmap()s that region,
> the retained iport_ptr is dereferenced -> kernel read of an unmapped
> vmalloc address (oops / DoS; memory-safety corruption confirmed by KASAN).
> Primarily a remotely-reachable authenticated denial of service.
> 
> Affected: all maintained trees -- it became a destructive dangling
> dereference with 4949314c7283 (v3.3, 2012), which introduced the
> multi-page vmap() path. Verified present at mainline v7.1-rc6 and
> stable v6.12.92.
> 
> Reproducer (authenticated iSCSI initiator, current PR reservation holder):
>    1. PERSISTENT RESERVE OUT / REGISTER a key from the iSCSI nexus.
>    2. PERSISTENT RESERVE OUT / REGISTER AND MOVE, FORMAT CODE 01b TransportID
>       (IQN + ",i,0x" + 12-char ISID), RELATIVE TARGET PORT IDENTIFIER of an
>       existing target port, with PARAMETER LIST LENGTH = 8192 (two pages ->
>       vmap()/vunmap()), the inner ADDITIONAL LENGTH set so tid_len + 24 ==
>       data_length, the remainder zero padding.
> 
> A/B verification (CONFIG_KASAN_VMALLOC=y, kasan.fault=report, x86-64,
> 6.12.90; reproduced with both a 64-bit and a 32-bit initiator):
>    - Without this patch (8192-byte, two-page request):
>        BUG: KASAN: vmalloc-out-of-bounds in strcmp+0xa7/0xb0
>          strcmp
>          core_scsi3_emulate_pro_register_and_move [target_core]
>          ? remove_vm_area
>          target_scsi3_emulate_pr_out [target_core]
>          __target_execute_cmd / iscsit_execute_cmd / iscsi_target_rx_thread
>        The buggy address belongs to a vmalloc virtual mapping
>        BUG: unable to handle page fault for address ... (PTE 0)
>    - Control (56/128-byte, single-page request): no report (kunmap is a
>      no-op on 64-bit !HIGHMEM).
>    - With this patch (same 8192-byte request): no report, command completes.
> 
> drivers/target/target_core_fabric_lib.c | 16 ++++++++++++++++
>   drivers/target/target_core_pr.c         |  5 +++++
>   2 files changed, 21 insertions(+)
> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
> index 87c5d26a5089..b5ad45f072bd 100644
> --- a/drivers/target/target_core_fabric_lib.c
> +++ b/drivers/target/target_core_fabric_lib.c
> @@ -19,6 +19,7 @@
>   #include <linux/hex.h>
>   #include <linux/kernel.h>
>   #include <linux/string.h>
> +#include <linux/slab.h>
>   #include <linux/ctype.h>
>   #include <linux/spinlock.h>
>   #include <linux/export.h>
> @@ -367,6 +368,21 @@ static bool iscsi_parse_pr_out_transport_id(
>   			*p = tolower(*p);
>   			p++;
>   		}
> +		/*
> +		 * The loop above advanced p past the ISID; *port_nexus_ptr still
> +		 * holds the ISID start.  Replace the borrowed buffer alias with an
> +		 * owned heap copy so callers can safely use the ISID past the
> +		 * buffer lifetime (e.g. after transport_kunmap_data_sg() in
> +		 * register_and_move).  kzalloc() zero-fills to PR_REG_ISID_LEN
> +		 * bytes so the 8-byte get_unaligned_be64() read in
> +		 * __core_scsi3_do_alloc_registration() stays in-bounds even for
> +		 * an ISID shorter than 8 characters.
> +		 */
> +		p = *port_nexus_ptr;
> +		*port_nexus_ptr = kzalloc(PR_REG_ISID_LEN, GFP_KERNEL);
> +		if (!*port_nexus_ptr)
> +			return false;
> +		strscpy_pad(*port_nexus_ptr, p, PR_REG_ISID_LEN);
 >   	} else>   		*port_nexus_ptr = NULL;
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 11790f2c5d80..d7340c4fbd07 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -1571,6 +1571,7 @@ core_scsi3_decode_spec_i_port(
>   				continue;
>   			dest_rtpi = tmp_lun->lun_tpg->tpg_rtpi;
> 
> +			kfree(iport_ptr);
>   			iport_ptr = NULL;
>   			tid_found = target_parse_pr_out_transport_id(tmp_tpg,
>   					ptr, &tid_len, &iport_ptr, i_str);
> @@ -1808,9 +1809,11 @@ core_scsi3_decode_spec_i_port(
>   		core_scsi3_tpg_undepend_item(dest_tpg);
>   	}
> 
> +	kfree(iport_ptr);
>   	return 0;
>   out_unmap:
>   	transport_kunmap_data_sg(cmd);
> +	kfree(iport_ptr);

sorry for suggesting this change, but this is worse than what you had 
originally, as we have so many paths to call kfree() [which means more 
bugs possible]

it's hard to make good suggestions for this target code as the functions 
are so large and complex.

Is there any reason why we can't just keep the transport_kmap_data_sg() 
in place for (much) longer, i.e. until at the out: label? We already 
handle the the unmap properly there. I do notice that there would be 
regions which we keep spinlocks held when this mapping is in place, but 
I am not sure if that makes an difference

>   out:
>   	/*
>   	 * For the failure case, release everything from tid_dest_list
> @@ -3532,10 +3535,12 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
>   	core_scsi3_update_and_write_aptpl(cmd->se_dev, aptpl);
> 
>   	core_scsi3_put_pr_reg(dest_pr_reg);
> +	kfree(iport_ptr);
>   	return 0;
>   out:
>   	if (buf)
>   		transport_kunmap_data_sg(cmd);
> +	kfree(iport_ptr);
>   	if (dest_se_deve)
>   		core_scsi3_lunacl_undepend_item(dest_se_deve);
>   	if (dest_node_acl)
> 
> base-commit: 8e65320d91cdc3b241d4b94855c88459b91abf66

