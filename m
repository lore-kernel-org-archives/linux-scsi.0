Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7435273809;
	Wed,  4 Feb 2026 03:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770176064; cv=fail; b=K7STcmYVGMOJwEHqxTMKgDw3+f7UaNMUXj53UvzgxU47fBLBM6IJX0CXVKDeYWg48KVhPOIWVjJ1RE/JvSOFW2VZs9Xx0tb3zbUQg09MYuMHLBBPcK8KGdmKf3i1QfIfDuXkP2+NMkxxWhP/5pbZAqRrhvtDtoEgbMuEOrgny9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770176064; c=relaxed/simple;
	bh=lK0oqgHYDgQOtaWmvdBrPj0udBJZ+IUZKmZGMm7EWpM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sBGxMYdRtfuqdTbI1Zd2aRqz6fBfp8Rm1Up0tACperi8sq5sI2a0OGYMlWQIFsEaeetDHVflvhSJIO8dqzemy5t2Gvtx3+R6NwgiI6uuyBJDqdN4ZHGhbyPcDWmUR/ePBSwAZz4EC/sgZGijxf5Isjj+fhHIKiNa5UHgy+a1hBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iRUZ3FjT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aj/kEA5t; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iRUZ3FjT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aj/kEA5t"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuK5X4088011;
	Wed, 4 Feb 2026 03:34:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4JMf3lJfljUupO/NXL
	B0PLDWSl+gr6kZUiFU0qUi/X8=; b=iRUZ3FjT7ROcu7EpUigCqAvEN0BnRffHXA
	F29c2tyTi/qq8rtHwLkVNttvQK1RNvj7ZUYUw9Vtm/XlNcoDs181c07oCj483A5f
	PX0W74ipokA1ZmoYn0CC8oUFxsfH95+/QqslLrVY2zfqjWrAbp8JiKPXCL8jNePQ
	dzJngBYiwvumoyN5uEGfXIYgpQrA78aaQjFTJNDpoMPh98zgiYXwAiiHsWR72cS4
	alOBDuLECaiZyQbsyZbuJn1UZDtaGbkJXSxvvcTkxwGNZIROsLWRLi1cv24qbbDR
	dX0fTJcyQpFUmEuO5M5mlv6yoyktygqRDBU1+PH6Fs4QkVnYFLZA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb14sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:34:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6141K3BU034726;
	Wed, 4 Feb 2026 03:34:16 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011012.outbound.protection.outlook.com [40.93.194.12])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186au6r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:34:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+J2gkAs8y6cvEnly80vLIzkV07KdeY/edWemzHZl8UVqek3FYi4YX60vFp7ZwFWfRe5JXKQd1nrS4cM8S2wOrgoRUYAwOoWwWAJZbr0tsJ0CnMCkWnlwkPxyrR4O7RiwQQ4CcyJux7w554V4NEt79qFIyN9nV9denbEikYCMRT1Pf0pwarMfvTgWlrLn/17NBHulArntyhcc/MMe7QSZzQTUIGwz10QYdN/7/iniNGgbqF5rkwkkOFAzGCoeU+1Q2zcO6rMd92rzPzYfnjPdBhMszRdTa6RwzN3Dujnv0LRGaXugpOeFAnKFy8C66nfsi0611kxbf5Wn5aRz4NQWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JMf3lJfljUupO/NXLB0PLDWSl+gr6kZUiFU0qUi/X8=;
 b=PavuMXDpLkbqQ2gcjS+m3dynmHCKX8tsO514lXvwzW0zCMQt2p31frWRYP5IMIrjGFBrdEhfPX62tRwdeuO5Tj1BxdNchldxkP2IDzPP8Earixh/WAHFvhEC+GKtLS4cxd/FQzfTYtSS4D7WP8qTkmxC1Vtsr7+hn3qPbWHiI9p0xCCAzx4oyTnALjc5iLpWlBOe5ivnG/FeOUhe+4pXpQmcJ8suG25BEcrCulUNxPkgM3QtoLpNT1Y2xyd1qLxAwPURKw3+BS1TO4O3RU+YMuJcEZSfriqlN5NxRRhmdtIp/SHn35yXwIfThnjFYLxg8eJ8DK94Zrpw/18fweicLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JMf3lJfljUupO/NXLB0PLDWSl+gr6kZUiFU0qUi/X8=;
 b=aj/kEA5tjPbJ1ytDoRCXNqoJvW7Ay0EPU/AweraHjPqs12EHaLBdVkY9fr9FHz5nXpBMw/cWdi1klgpeaZaIwcnaTzhVjW4QwKvmONb+rzCMtvKztbvSOHqAU7iCeWbM2Uzyg6AI5fEwIP2mVUJ4Yf4bfs/4OifP+tCqEcHG6j4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Wed, 4 Feb 2026 03:34:13 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:34:13 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Naresh Kumar Inna <naresh@chelsio.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: csiostor: Fix dereference of null pointer rn
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260129155332.196338-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Thu, 29 Jan 2026 15:53:32 +0000")
Organization: Oracle Corporation
Message-ID: <yq1343hnpws.fsf@ca-mkp.ca.oracle.com>
References: <20260129155332.196338-1-colin.i.king@gmail.com>
Date: Tue, 03 Feb 2026 22:34:12 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:610:60::39) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a619c2e-f25b-4dc0-9e80-08de639e4426
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GJGuPie25PamjyHJR1R6podq35m4KOqw8AZ54sNSalNnr439fPYRBc1n6zM4?=
 =?us-ascii?Q?oVfsTfC7JRiREcVHjAdlf1A0aENVu1BAI1KBG/nlzZjiuc/yKGel0H5/Ovih?=
 =?us-ascii?Q?weLFPYiWQSXvLKWSfw8RLScvZ/LLcxvGLoYNlbVe2aE1fROvfYoT+wBBmNrI?=
 =?us-ascii?Q?FzN6kujamD5DthjjVv/PQ65iWtP8eImVj8IbgYhZZ9s8uASm3u13aE+zrulC?=
 =?us-ascii?Q?CpP0+rWxNARJTAANpw+mjSw9fC8c48Fed4SLi+k5PI0a6vm0QIodqdH/mys4?=
 =?us-ascii?Q?C3qdzGl+3JxLjineH89n4yD7MGy/gq9Czsk1T3abdD/dTIfDSqsDwKtm0k6J?=
 =?us-ascii?Q?vYEEEzUrBraoAVu6lMilrz0mV5ncsgX2KphSSlRSBG1MKxXJLQA26uw5iiCN?=
 =?us-ascii?Q?KnF/v0XfauHK37XgCltsWlq9kOqP8J7QuaSBTolm7SGKdHGmHETLnH6o1Zcc?=
 =?us-ascii?Q?qkQ/m3D8m6A+Rr+74AbZSBzNrnnjTn3JLBOj25kdxQdF3yRHaMbWN1OL4zG1?=
 =?us-ascii?Q?rYG8t6nc3MaYj5MTN0I4SSBmeq0Lm56BmoR3/4g3uKRWCXDcg7oJAJPzX7QA?=
 =?us-ascii?Q?SChxwQWCGPpBYDGAlMIFDcUB2YJuWwSvwhGM6DMnO1ZyQAbgaStBKeYD0jy6?=
 =?us-ascii?Q?39VcnCGTffpO+yrzEFG8EEn+yQGPw/Cz8eI2h2WKM7olwoq1Q5fJV4nwkwxu?=
 =?us-ascii?Q?bdMZ0BdvlAj2B6YtOm7oS9DUdkq14N4i083D/l1Mtnbq2cxOyke5CsJmj4J0?=
 =?us-ascii?Q?FoQMxXFjptTEFW/A1YrF8ki4OeZsr2kpAiObRmFuQ6CCbZ6w1tUUApSdNpqQ?=
 =?us-ascii?Q?Cop+YiS4hlNgBne6wLQ6zUQRJqqV3u7QkW+wdHyqcQSQRg+wVZDgZN5wVY0t?=
 =?us-ascii?Q?E3Q2OgTKekwNfv506zfSDseIHWqC+5kPBjaDCH/OZxVQ5H9SuIk5BjQ9y5X/?=
 =?us-ascii?Q?bCecwN7SfzFzcxkZTF48h6sVRxLqvRpkQ3J2SrFeqXfbh6bdZGN/pLurLSgG?=
 =?us-ascii?Q?3MsCNy0rm24kP+yNuw5Lp1W/Fa0D6WLkuN70jwKAByZ69KtBGgMVO80TjEkh?=
 =?us-ascii?Q?29g5vdVNYg6nM4j4Vm63y0VGerYvVqcwQOam/4wcfaLHHy2MZapoO+9Dpyql?=
 =?us-ascii?Q?rwFZ2WxDQPb8ALns41oPeEmg0w2BoJHLyENbtriIXNDQODhlx3hIbOeYX5+7?=
 =?us-ascii?Q?H5KCVD+vEMgwMFBO/99dxpEN8z15lNbGgA5Rg1aAA+5gIknFvllMLPhi6BsE?=
 =?us-ascii?Q?m0AIHQhdSGOok7Ducc8y6qlrm/YlAfRqFkzbsm7nLeOrtI9w6+idCYdRxy/P?=
 =?us-ascii?Q?nhoStqsGh82lTDuUszYieVdS8qjviaSFWyrHwzN87stjRzWJUVadlSc0Sse0?=
 =?us-ascii?Q?G8UpG16vUMoCADYaFsKMGqjkCLrrOekGp+qGLiSOS+1sERPC3nnl5J/82lsA?=
 =?us-ascii?Q?cBNQjOjXqG5eupVqtpLnuqbxHxwoKuqnLsDjIUX8MCTxFnPAwuhOhxYEm4f1?=
 =?us-ascii?Q?uX++11RoTWp/gjKL9H1pNyjQ9j5E1aFt6spKliEK/RAd+uH/yY0cVx1TP9xz?=
 =?us-ascii?Q?yZAlCxgpxYILveYe0n4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EGPi55z64Dm10J6UvIPeZ/atyPAY8M7bLB1FaCsRPrRpNYooBfx4cCtJ85k1?=
 =?us-ascii?Q?y5C9vRmsT0s33ILyPDa2DQ6Iw27qU9X1gVYFJlhvhIDdk9X7uNlBWF1qmNw1?=
 =?us-ascii?Q?fCGhQUBUlNezvs4E8h7dlCgQ4fpe4OU0vsY/P3BLTpHLQIcprRpFCoJFKLXz?=
 =?us-ascii?Q?J2bqZ5nN1jTQXHq7kjpB2Qfy8wIkxzTfsBjLWlWmcmM8fTKyZHV0VrQG2g7j?=
 =?us-ascii?Q?TKPsT4EBIvhfeGkn0Thlp8GnXlolkpRvubuMSp1r3IY6PINVpsxdeeXg/a5K?=
 =?us-ascii?Q?flZfWrkZj+8RAMLX6QFNS4O3O62pW/C/ySNu6UsQpRiGcv/oLtATNneUB5Bt?=
 =?us-ascii?Q?ZgtYSF1VWFd0VCY6sLsuhFUEl35bjlK9RZsQldkuwFqbDPNM3YaHbBL7ps9A?=
 =?us-ascii?Q?2O8ooFzBG6hDMVEE5RFSu16s/Qk1SfuxSVHX+zgrFjnh42UQQPSqLRt4y06v?=
 =?us-ascii?Q?6H3b5zgvlF4nxDgucZD1KsZwwzcRDHKZLJ6vRwtjLG4DIvveigEY1uYTC2fu?=
 =?us-ascii?Q?3bRwXR8nxGBSVD9MjTG93+yr7nIxe7Vjpk2cLwTaLP5d0agBEA3dcfy0gtaj?=
 =?us-ascii?Q?qZ+8vxkuSFizOrCV4+FJ/JPTFx5SOWTCK2n0zqtRdFQKg5/A+hmpAO8U3jtB?=
 =?us-ascii?Q?dts55JRdcnBYL8sp2SU8I1EXToANVpqyARndgA94FVzIFeBjd9rnzCm5vKUL?=
 =?us-ascii?Q?LNEb+cjmFZBDIzYWrB/dqpU+CUqbbT2+DFfMh+r71TD06mHzTWI1VlW1Rneo?=
 =?us-ascii?Q?YFoy8UQTDFpWE595VFxi59uIlaOBbxBo99fYPfvN9qi8Pvxf/IoxxGPqAfhQ?=
 =?us-ascii?Q?3EuCgbkC54Gv7Xf7WqQ1GHk4782cPUb8hzgWaKWa/LfUjlIsetJoo4HMQh0E?=
 =?us-ascii?Q?cK8wxsUesLt2fE7oSYwzJB/DJZ3oqTyDzwvFQbFPKviBMOs/yo+NlTF67ETj?=
 =?us-ascii?Q?3nmJp4wEKaKXtLUHXC9OEZE9r+iz3GZT+AoLhDGWyKyOuC8T+2jDHDi7iRfI?=
 =?us-ascii?Q?4UySFyxo8U0iWwOHSXdQamZNqUhTb+w/hAONLvFNBDrpBEIG82mQ0s7JTw0f?=
 =?us-ascii?Q?LoBQaWelZ4p/2h76DZpB9287sWBTjX/hGJG65UqFg0c1gPLQwfbZ57cJFVks?=
 =?us-ascii?Q?XXelgFagPddfmmEZOoIW6LPMILLV4/M8GDkOnU/e9sAbZAZCvG08LnyR2afs?=
 =?us-ascii?Q?aOtR8MGaHxebymqGWDnI5BAqwWyQd5pA0NmApT4lkXWqcpo+T/j7E16Yad9X?=
 =?us-ascii?Q?iJNp8zhdl94+JiOwlXSkWWB8wR703A4bt0/YPeazoQkGPo4jCc85u11grUB2?=
 =?us-ascii?Q?nYSoKLjnp4xBA4mRqp1JJ5ptnxyyv52VGhocmJKXwaEHBQ8llM/onBnbe9cn?=
 =?us-ascii?Q?QbbwZDQ9kHHTn2cMNgv/d2kh6XY9uizHJU1KBcHjJPWbaB+QB/f4f4/x3tMq?=
 =?us-ascii?Q?kivJk1q3dZ5CgrXxcv6j7dsEzN48Ll6fpZoAV5aL2Pk1zR9f/KLjqADKk3J8?=
 =?us-ascii?Q?wpjbmatwW1pXdzl6w+qwY6ZSzpK8Jz1u33Zi+t8jhp7MdF5awZfwK6LjdR+S?=
 =?us-ascii?Q?xcqmvq1LWIZ/nKZ8HqCSnnA+xeUiNFoLYOwMfy7NID56mQ6H/07RbNwjELF0?=
 =?us-ascii?Q?Jh5xP5DdTVDj97taUOEyHNDDfsw9As6xLMcyPwQB168WxAQza3SYezUjXiRO?=
 =?us-ascii?Q?FCoS4aiq+MEzaBiBOIRMbC/vbAnq2qd0pKVBMLW5c0cub/0PsRyy4RJkk+wF?=
 =?us-ascii?Q?BLrFt0px8kstBDMZlJrirykad9f2mGY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aGNdTCG8aOv+RW2Pp1CoGB+BEqRKc0Pk6h0FZaID5TfTm3BLJv1DbBkbxya5xKRA03KV40UeGvEASOBmaApyrDgxL4J0S6IBgAquoYlmiqLyPe3b4goZ10HrMRxT7TAodcwaRMEi6SKf46sxsVyTqVTyfJ+frUobxBEvMG0wCFHnkyLQEDu6FJ60aT6IVd6AuRZyxLL9oXga3Vbmkna2oWaEN8xZ6dKGVNm1nftUxTEGZNI2VP2zsLT7Ml0DRT8HZiMw6pPE7Dhza1f707jUG0WEGM2xxlDN/aoNBO7HnW4eC/Ijrqf1dzPhhBDrerU+uHgN/rFLP3MdVT2/gZuGtSCRavXsKXOmDAEUugyo0uqEGxkl+07+nZHZzf74Z92oj1HKCQyJrRYMjvFL8BHRTKowIElH+iiP4yipWUTyer7e2ILID0qnc88awTaQ3tPe5nDx+HXDyMaEwBLB5a1ygVFU0MsaGDFJ93HpzFzQnheyU/xHQsPd9YCZVLbP2K6jle+bAD8PCL0U5Jr6D6aHKyScNj/fMFma0/68psWP7xaNf2woZeWTEW0tVDMFeKwvw/LBjDHaPUVxFOrzrZsoyIBTXBIyYXltwRr1TzjbGUE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a619c2e-f25b-4dc0-9e80-08de639e4426
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:34:13.3489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmP2Qyklx9soduwBcvYsunIgbpNqXEvKeuGWATG0IUf86X7ih+XMMTz+KrhwhVeLBmE4y3EmTy1nb7HGOmIfrbD4Rqay6bomtkaW5tUnMNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=788
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602040023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyMyBTYWx0ZWRfXz3uN44jy4QGq
 5Dwjf9fInQEnBPiwoTFXs2TLaIvhDgQsPhlE+xF5WddKkbXKg9cfxJAavy1PTM1w00Nl1Mf5AUm
 DOq5Ws8C5Yt2Yq6u5jW23Y6E7BDg5W2qFtzpZszi6Jsxz2lfWPUu2ZGdjYA6hEW2+HXRy7Zx+cF
 XQoXnMNEUoM0P362hNWyn4RkvMB/bnNEYddCXToG9tx2Ibm1U+sApYN1gjiKzzVYWphnbNb3pXD
 dDiqBE10z86aFCWfOrx3FNv98STE7DO4W+vsrk6eBwtP1nYDs4AFITsmas1upXm6OfKI2d6EU95
 3Mf3A3zHkIwT8N5yi8cm9XcNRHtCEFnGQovSMsHY6DmrJqmsXYIkyz/zejpua2wNAQ2089/btDT
 7DRD7JBNI/X3tsYBMjKb49wkwFS0FlNxYJG+4pom0cgooZPxjcipj7Euu7sSUHpPNBei7uPDxni
 4ZBu4R26O2zkydqXWwQ==
X-Proofpoint-ORIG-GUID: WHswGUwiHFO2nqD31fuW0QcOeBFul3X-
X-Proofpoint-GUID: WHswGUwiHFO2nqD31fuW0QcOeBFul3X-
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=6982be38 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9
 a=zZCYzV9kfG8A:10


Colin,

> The error exit path when rn is NULL ends up deferencing the null
> pointer rn via the use of the macro CSIO_INC_STATS. Fix this by
> adding a new error return path label after the use of the macro
> to avoid the deference.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
