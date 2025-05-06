Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E27308A57;
	Tue,  6 May 2025 02:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746498813; cv=fail; b=T663pNzhZAjM13ZPKojpdYA8PXXAA83qIa3EN3/BTH3JgEA6seZbz8DUdlNK7s+fYNcATvT8jjL8mWNt80YPGbvndYu8RtX6s3xqw501qx5qysbB9pkj4IiEJU/TQQMVDKNxS/EfanVwxx98tIqjrIP7N6jtAfMspZpgO1WQ/Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746498813; c=relaxed/simple;
	bh=Df7YAhlZG9d4n3jl+aEY+x9RvoCiIOuQcyIQa9490i0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fPwM8jzDQbBGsC1TOJkfLvvIiQp4XaZTV4DcvOudbjbhNFwyNt0/iYgzK6V9nEuzo45ra9X8gMiv9a4PTchxaaLuALBFATkwuxO0Wl5sNW0SW43zGm+G5hgZ/rF5pyQKtrwkLJN1mwkQRUywU0web+BiCDXWlqnpkH4v0aBK3OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YjzjcrNx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FleB5+p3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YjzjcrNx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FleB5+p3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5462H8Tq023783;
	Tue, 6 May 2025 02:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=v3RwEdnFFiYmzWngl1
	1BVqxZx7enlf/LoepfZrN1S0g=; b=YjzjcrNxmfMC0A0gu7bf3G2uP2hR5FG2rq
	ZxM7pxBDkYMeEi5Pw7bk2fb4A+T5esS9yagOHqJkv4tLeua49vxdSLf5l5rJ20Ts
	vi/vkltN2XnM/B4hupUn7Z9tSHTzt8fhHFh3Se755zEhacms1VjcJd81USsWwmlG
	l9qPNRF/f35/cTivGKpbBJz7ea10U+E9a9aCc/PeuOL1mMmXOWk0XP9n/Q/sqbfE
	WwWhNG813shQi9n20NmiRPBbunW5mqNqKtZgrgwSwUBMhc0OYHaAdiM7U32uXXfD
	vj028aWzudHPGiuK2w07xK/IOY2uOFi0JK2ML4qTDoY1qmT6pMiw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f9gjr0c8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:33:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5461T107025122;
	Tue, 6 May 2025 02:33:25 GMT
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazlp17013078.outbound.protection.outlook.com [40.93.1.78])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kenx9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I1dxGGKG9lceYxR5vplVr0/Ns9DmJIO/MGoRLhYitXO9DfCoB7S2uyYLW/4WKzeomGwg1mZn1e/2eB02+BV8OxoHnBKovN56AuOwRaPSek67BfXbcY6KA94hN8f2yuCtFk622Xv2q0rvF+h8AFXD7y0kt1RZ/SsGMx+6qfTmAqR2o0MKPETk7da/C0ZiT1Snm7XUHubJ5gDEF8u5xTihexkBR285KHSBxfEb3C/bl9x7x2cv6OqNmzjBzBqnT/T1MHI6m0MO6QzoywxFHqSrAwH2jEpAvouDeziyd6KIFVGTz9Y3MRSk1ZFn+Ua9Wj1AM30BpAs4Mj72149DGummyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3RwEdnFFiYmzWngl11BVqxZx7enlf/LoepfZrN1S0g=;
 b=OtMpVX3ywoMxvJgyLtc8bEsBfLnm9X//Q8pjr1s0XmvMSeRiBEM89zB8fWOF6lN06j/MENzAcIwCsCRVhupVc3dOKCAn9twc/qORxy21QmE055+my2AhZSJ9bEpHOdiyoZNJqeKPc3IkSQZLa8MLdt55nwUN0pBn/fVODz28EUc57A4pZj3ahFsKyvGH2vWXEOpWeFv1IeKVplck3VDOUccJI8b+WKF6iXRbQNXYuRCCIf8Mu+vXFzvwW+P6tZZkv9fupUSuHFmjioNYM9plYEp6gjLtChfsvmct8TKwCvWRfUj3tgLGsi0uhePQMb+Sw19UOuPK8rdKnUNVrvbaPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3RwEdnFFiYmzWngl11BVqxZx7enlf/LoepfZrN1S0g=;
 b=FleB5+p3C1d2NdFSqsi4xo7On67wnfVaDR5LgH359vGumrVhq8WvNQM3+wwcj+6pwvu1XGz3Wqj5aXwT5CBdpufysu0x9YkQvG8KejIKl5XjvTm0TQ1B64kSaSJUhpiNRMOu8/PrH3MXGPqEhjf54cUcNB0DeLkG3tebXE2KaKg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6104.namprd10.prod.outlook.com (2603:10b6:8:c7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Tue, 6 May 2025 02:32:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8699.012; Tue, 6 May 2025
 02:32:55 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan
 Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: docs: clean up some style in scsi_mid_low_api
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250502015136.683691-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Thu, 1 May 2025 18:51:36 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ecx2v581.fsf@ca-mkp.ca.oracle.com>
References: <20250502015136.683691-1-rdunlap@infradead.org>
Date: Mon, 05 May 2025 22:32:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9P221CA0015.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6104:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d5532c-ecc2-48ee-c708-08dd8c464e8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eOqE65TE1AOCyOCKUsz4mi/q095VUSfNtE9nqvekqsqVtx0Gtf6+m3KQiZuz?=
 =?us-ascii?Q?3n6hAgyloISWXvKtt05ED/HKA3MEzGCJ7EK1TXQhWtYeHmnqqObyYIGES3Jn?=
 =?us-ascii?Q?wYRgYWByIot3LPy+0Fspz/rtU3jF7dpKC7BspZCjUB3CBOE6FBQemzCxVEj4?=
 =?us-ascii?Q?nO/4XvY2/1sKkRNP3xed27g1dB5p7W+mAhd8J3ETZMkP53Vw9uHiPa9xb4t7?=
 =?us-ascii?Q?F/aX/T/GoICppVqiQFzVwi++uiIV4gFAsi4TWrMzfSciLsqkoaxrwsum0k1s?=
 =?us-ascii?Q?32R+3JA1H80SN74ksADUb8Ar9p/etEVNWuijEEz7m972rTejyT3JYy6PmXWk?=
 =?us-ascii?Q?lb9j312HMridiKOVmQm3OIEC/g1jD5tDJ6weF0MIHO6RJ6JdLRq6boOOoj7P?=
 =?us-ascii?Q?JHrfj1mDsDGBybmyVSWocYmWQpqOA5QbkylT7mBxDdF8huZ6EffrdwaGh1pI?=
 =?us-ascii?Q?/6/CoLPEXS1HtfWBeunEXIa0Q7rD+b0GxYlhutfCiGpgInvGNlOdASeq2Yhh?=
 =?us-ascii?Q?o18yrOm44fxh1RF2QsqL0wqIjOni+9u6DKL4eiqOgUMRNPfEUm+7ySvqfr4X?=
 =?us-ascii?Q?BOEbuzzPUxjg65NVqGyjTuJ/EeicVHclC/QTLcKLkPM+BLAAy6kJOhPLzTSK?=
 =?us-ascii?Q?6DgTqlBscc8Pf6jwZxXKj32j/jDbwAqdGwexmX2Yf2bCbKgwK2r1zVRZ7VaL?=
 =?us-ascii?Q?2EHDx1GA8/BovXOAbOL0zZRh4DzgaOiJb64nIOQURq9vGad4voONwQyWwjg2?=
 =?us-ascii?Q?l4rUxEcsDAB8s4N9pFqMlEXXfWPqFYDNmKqeV8cUjhltmNa0ywggjUPoR4X6?=
 =?us-ascii?Q?tD9lEB8cNVHQ/Rv2eFZk7lLZw39tC3OTfJ6yLRXvhIbXAD/15ga3J/w/zeaU?=
 =?us-ascii?Q?Ko8XQgBfLTgfSaZ7y2NU26koja509qlllHBeQXW61lIu8LSnbeJXZRIJsGNT?=
 =?us-ascii?Q?wHDsfF7rsPykwVpJCtKgNjMrX6OvbGtB/skle1GNymFpQZkeVNVdN7+WY07k?=
 =?us-ascii?Q?5vYKJXWXR4KbSEekEnStC3xbGvsqDtseBFpjIpFWhcmQ+OqRP8eZwFfR+sOH?=
 =?us-ascii?Q?7IZoz5sk5qCV8xlSphHAptBc90+vn0guId5bWj/VjCPQA3elXaLD/akBvQC1?=
 =?us-ascii?Q?MZKKTz9N84ux+fBKsOPN83cEN4wDr38wcv47u7uSSHHqelPA7ZUq2oJOtoMf?=
 =?us-ascii?Q?LYokASbk8YzDC/A73a6qP7LPG5sa8FOrKJGNST2Ogag8tEcyM07HOcFyB1ax?=
 =?us-ascii?Q?cZP5zOt/LEPCrd2hIqZ95+qaKVy8EtovRre53il80a9TW+qHp3lkQ/WsIVhE?=
 =?us-ascii?Q?sZ1Txr7KY551udxkroaCTDIHJmUSOsI/DO58Of+9kszEJFwccVsNtfEHm9j2?=
 =?us-ascii?Q?EYXy00j04Iv1rZjlnUwgqLfm6BeFRk9lUG9kPfEvZJojGU8rTg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gPLYjUAzHe7kxJ5EZbaqH02UDLXZCD2CBrctUpRhTwZWrElKtRQqVZSCKIxj?=
 =?us-ascii?Q?D/21V6bBSHGIeFqHwXd6fnc/70kvItm/554JP4Le9wwKpfbYTcCgED9dZTzw?=
 =?us-ascii?Q?M1Aj3PXDa3t2B/HbD0lgwo1RlVQM4y1D3Qv1iYy72sUF19YqBTXBo5sbyUMf?=
 =?us-ascii?Q?adxbk5bo2FoK3ZfysacSgYRtk/opCmvSJkp01yXtMSpW/d8f9p0bTSArdVUk?=
 =?us-ascii?Q?BMFu1B/LYZAoNjIDa2cHQLdyFF7aKzhHHC/jqqbuPEb6i7p8uJZhaMGTlSHa?=
 =?us-ascii?Q?8b7Khv4VM0aO72+0j11HSCd90P9M1YA/bRUJNPeST1cYmjm1PIA1xh5ZSOlS?=
 =?us-ascii?Q?p07/wqdKSh/WhpFav7Eg96SUSmcXL6zZuCuYEVi4WnpfFFsWxcKXUX44oVgg?=
 =?us-ascii?Q?jW8QB8Mwxm2qOtefxBq0guTD/566nl77ncOaxKdIqwj3RBNVDsN327d+Ivq6?=
 =?us-ascii?Q?aRFvxIhMoy2anR7RwS0jj8u311HRYj4PBVKcx7SFqT0/M38h8RZHul5+T8+h?=
 =?us-ascii?Q?ZbrxqtJbQ0aRTNmbIQsC6SkF8Yt7P/EuuCPhc6ynVTMkOetjHyTODfRSaLq9?=
 =?us-ascii?Q?8KXnSvDfPZRwPzsni2MrkrxKbcUE1st0Zkd3oVeDkuxnfkLJGlW3irVfr992?=
 =?us-ascii?Q?wxDAJXhNcHkPMP06BQb/C7aO2rrSfwhJPLt7ebMzEnvKC2/jyUQc1N1GOsGq?=
 =?us-ascii?Q?DYjneJtYNXBYFMEq1e+H182kU0ptAgIPsKCnH5KYKZPS/9Ya2ZPXW/WzW5p1?=
 =?us-ascii?Q?s42iO7fsKAn2G8h9f8GE7x5Y/eDujak34gmmzuqhxYpJ/WSSBp3pbRSEfzXD?=
 =?us-ascii?Q?zKo2Pt1GWJNB6K9Vueqs6o0HFfKFrPiQVK+MGxS+d3aCrTUvJxgklVv+70eo?=
 =?us-ascii?Q?DZC/xaZ+e6+iLmVDYQpVldoRRkl2oS/s5aiQWBE4CCLANBEu7aro8Z6G/tL3?=
 =?us-ascii?Q?RFpXhmzOGD3WeNyl2dKbRujKkgRcwholl4jVaerMgReQASqr9/p4UGr/eUI8?=
 =?us-ascii?Q?1IRRt4zwL3AsKZC4OO/FxxGMQMnlhFbMTZQMsYfTdHOLkdUpzeJgQqidepbH?=
 =?us-ascii?Q?u0YDpOkjFyiXxHKyLMLUTSgdKMuT4mP5r8Ds1HpHML9LMgPG0LI2dud5xVZJ?=
 =?us-ascii?Q?5bmvjGHvAafffQjigmxDHZ+UdBEv4UkAvmcK6/lSXs/+8eR/vtFRP9VZoMj0?=
 =?us-ascii?Q?Fm0OrRWS01LGMUYx91mWVCyklaaeN6AYQefY3jZJaJ+Mu6ZOKZY6t1SLeOvH?=
 =?us-ascii?Q?s/rdEzs2qajLIGk1DKXEwJ2Px9EMJ0pnP8/yt0tkcPQjm2LgCAD7NarqqaxP?=
 =?us-ascii?Q?SwizSIx6NBSEu7Fj+dh/80DYq0wlPaza8Q/c+wKw/ZfK+YjuKHNRVc6sLfeU?=
 =?us-ascii?Q?8dVKCJRIgNaq24mBhaMZRmZAv4Bup/ba8Y42OWcd1cyMds59tE4R5fv5R+2b?=
 =?us-ascii?Q?dCa2NnWs3Oc2WpEeumziRQzJ/e/w7teVcNibjjV9k+R01+npPSNPQa6xutUS?=
 =?us-ascii?Q?vplQHQ6MLf4/XPe9T/n9OhnywZteo7/hewk+dpYO0IL9YaZy8vQZeofzzSJq?=
 =?us-ascii?Q?NUf6RYf9Wlwh9tpsFe+D6l2yc+DtChkdOd1mhVlMXvZEmQq+ylQtdvPhqHpi?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AqmAZPJpiwVSgkM4EypW866cKSh+giUEETP6yivk9Kb/ouH4bFrDSk3393rWnQNPG3TMAHRn7o+Ze/tNs0Ci7tAMH+0CV512noaJ8OqgbRYkfkV98U3gA5MkqAyQ4yD7lCclI1KjO+e+PN3dP/SsaSCsyoJCFB3Z/Lbc50/r+iR2rB69nisObWZD+AfNHqZ6OV3ihxOxkRMVuF7KyKFBZEarrfAgjyQd6u4dJQwitilRvRSyR3YC2yH1Ajoq8vnh2vP07FTatbYGiehBcoXqh/7gLTE+CI+YGZDpqV0QSdBjAl31U36ig64oDObnHISODo2j0KtKF5AxMoKEHcayQ6eem4+5d7VYxD3cM9rSoetMrSSrSo4nS/Eo0pWKiDwx0tYpnsjmGnjETcA1mDJpfZnuDE5U7Ut4Ha5WX63xMFsycGj7/VNfAz2AyZtUioeGkTDnZuwU8iG1132Ef2Whs2WZz6WGfjct2QVXARxok1CXntE7oqCu7mpwGsQTzrVWPBt36b8wRkpoaTy5GtJYjvHvqyAm9DiYYAsnlqIQdN9H8qEaAHwcQVpBPrE9URihseadB0JkpdQCSfokkekPFPfla7tdHY6hDy+ZZCzra2k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d5532c-ecc2-48ee-c708-08dd8c464e8a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 02:32:55.0842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MET8J4aN96/wFzXJ+jLfjcK0HSbZOnqXBfziXkniBcsgc2EnZ+dCgtRBJq31b8XKkeUJ/YxWwPCp6l2NiCkyjvvFr9wM5UiNvDNNjqq3MJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_01,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=717 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505060022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAyMiBTYWx0ZWRfXzh4KHwSPoVnd m3ny1UFSUqirOK6sBg4HaXlBeitbL3NH8fL5xPIuL4mP8E16txp0co3G+6tz090AqzlYcbWVVyH fjz0UsHPvIK5BYlIf0MTNVpTzw6JVDzjynskIAzNxF0+ZNoJ6poQAHPhwaBDLdBRJLr9YjXTYlj
 7FjMn44two81fq9RROUR9DpsFF7As21RU5Biw989hcR9QBEHFpbCl+Y5Mxkyy2ZxTKfgS+zG3TP BSoHJFEad3yNuV58B3jXJkbXkg5yZjZuH0ExoZ6NlNEeFQgFt5vJ8H6TfdBFNWfRWkwLtA37T2j 4Zd1NFdB85fps3aFQNTLnJyFpIo1xczW/BDkL/TGegJPyHn9EgucCFkF4kvQWAOf5me3uZpnvPg
 cEyzRNDfx0R4CKC6kq4E6tZaE+E9aovCJzXoWewqU72C4TfGIJc/9Ith+9ZAb8wcWmkGzybH
X-Proofpoint-GUID: Tbf8mJTgoCFaFxJ8yUiN8xDDjPQ87NGB
X-Proofpoint-ORIG-GUID: Tbf8mJTgoCFaFxJ8yUiN8xDDjPQ87NGB
X-Authority-Analysis: v=2.4 cv=AtTu3P9P c=1 sm=1 tr=0 ts=681974f6 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9 cc=ntf awl=host:13129


Randy,

> Capitalize Linux but not "kernel."
> Spell out Linux instead of using "lk".
> Hyphenate "system-wide."
> Hyphenate "32-bit".
> End a sentence with a period (full stop).
> Change "double linked" to "doubly linked" list.
> Use SCSI or scsi but not Scsi.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
