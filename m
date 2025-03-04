Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11CF33D8;
	Tue,  4 Mar 2025 03:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057757; cv=fail; b=MwMFdHsYtMKqoKqcvJ/SA2KZcio4ic7vNb/BqmoD572muRCBYC3ywTQA8kHHOrA0iE53ZzgEU9gkHklzg0GjhqyFtpC7s4CW4Nxt0EsGc/muOFlsGj436qwzJk7P40yPo4bo/HaWKzglrvGY5OOmEKs/meqxfV4ml58ph6DZ7js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057757; c=relaxed/simple;
	bh=2qIouzzB5VdSc15fzdPtIdheMXw0dPznZe08fnLNd2E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lsSgFWqTVoGRsVv2rsD8a4qpoI1goYpFvv99nFDvaMb8tAQoaJcJPkV0yRMRcXYh8taGKY05QPF4UqaZ0e6H9dIuxUrJuFj/f+rAQiuzC9Ss4DOfDU+lH0AiodgP/SLs9N8gGtKX8Q1CLiAGR25euS3LFEmbsRcr65W0MMeUXWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jzOad6uy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u754Eza7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jzOad6uy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u754Eza7"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241NI08016988;
	Tue, 4 Mar 2025 03:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Srs12eXsOIa7r/8i+R
	zNTQfV22pxgjnb19LV4ygEviA=; b=jzOad6uyb7BezLz6DWBTsUIDqS7Q997POn
	ewQowL7MMKmTHDQcKwALUioVDah9RXxowr6EHTkwretYDItn8ksAqYR00tHWg0G3
	1gejhf3CziSXUadfGI6NnoIUtTO4Wwv3/7Au7b/c8+qeBHpuWGJnToKFVggwcdg2
	mWrLudDFU5pjY9wtrtZlrbyHvKBITmT3KOQGMi2y0qHB2fJOxDDPK0otwiyCeWCG
	Lj9RbHT/UY8nOBhMmKD9WqKwk0dSwIS7aEA+Jfit9plwhz+sgWDVnVv8wpPsDJfB
	IcpiRshd6+zXwNsyMts5JP8qH424Eih6iM4pHJmgvsRMVuKRkKuw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u9qc4pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:09:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5242PVZs039084;
	Tue, 4 Mar 2025 03:09:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp92jmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:09:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+gY8cD4IiN3ISS0zFccSeUQuFHYTXjrN9Q7cbrGro+Dk90X0KxOO9/WJkIHRvcKkvhXd9gZI0xJowIXPnX2XBvceF+fHDHzF+NQti57vhP5bhQVPkZr0CVNwpkIAcacw3d7nq11oMOYJGHmq+HGjqJ4qIvspJ9NpNHejp5mVJ274HPJYcYHD0ArYwy9CN8PBaZFTrc0ZMIXdfbJIWvrSDb49cerWSHW+UqClaBfq/ba/RJPHXTN6MsU8HabOui/ytLKA1ilVkplkxNU7s050fYEBls1OUMP+UgSrgNlQ6jUBAHF5h0pIQkwYg2nmUpWUbswoDu8EPjvLRrkB3blsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Srs12eXsOIa7r/8i+RzNTQfV22pxgjnb19LV4ygEviA=;
 b=hPBvNYi3wVQjrdkSSbokScPzCI16pZXQ9TlkNeU4fwQiSDR4q9oAO4Be3jEYiQ84BFzVSfiqPpDywMUDKO5oKI1W2jGNu/Qns7AzjxUSivON4C/7ZT/+wuZQohNcJ5nzR/3T52KSyTZkSfRWYx+XJX9SzeTtHT62Te9bEZuqG3aAwilf9BsIOCZqnoANdrchCHexM82lzJRJmR1eEqTllWBJo4p12sRZT31AwNceMgbVc1nwz/34NzOMCw+v2UOyCxOEJ3ffSostOuMX16nVVyQZMw7pZcChsgWkUsUOEIz+kpWOkuU0P2r1NRXbQJ5mAMRfbYiFR8S5VQzQ0+ae0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Srs12eXsOIa7r/8i+RzNTQfV22pxgjnb19LV4ygEviA=;
 b=u754Eza7GMvHN9njg0RacJFrvI29MhaaTdU5imOaObH6zM7cDP56kaDcfd1wXn62LCB4n/dK/I1lD22xTM6VM8Ks8a1s7sWE58k8lsF8+wA893gvOSlvNQWrpp97Qy9GX03M5jcVkC4wj8F2WdeBVqgjbVhJwnu4t807pfeDaKw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5634.namprd10.prod.outlook.com (2603:10b6:303:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 4 Mar
 2025 03:09:08 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 03:09:08 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
        gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
        aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter
 <dan.carpenter@linaro.org>
Subject: Re: [PATCH v2 2/2] scsi: fnic: Remove unnecessary spinlock locking
 and unlocking
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250301013712.3115-2-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Fri, 28 Feb 2025 17:37:12 -0800")
Organization: Oracle Corporation
Message-ID: <yq1mse1sd9w.fsf@ca-mkp.ca.oracle.com>
References: <20250301013712.3115-1-kartilak@cisco.com>
	<20250301013712.3115-2-kartilak@cisco.com>
Date: Mon, 03 Mar 2025 22:09:07 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:408:f6::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: a2cf52a0-f11d-4e98-447e-08dd5ac9ee06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M8arDf0peisartMnClJtwKr7EJY72vHzK1+Uv/SkmCE32HfjbqzyuYZJKLRI?=
 =?us-ascii?Q?S/olYRTQNAWjBgSY/R1cyqWTlPmvcJsLdNBx21z5O1hAHyr34fr3ep1i5i1m?=
 =?us-ascii?Q?uCmtOD87v7Sr8bSUjHd0Dj82VYe8axWUDqL0vuIJ/bSbyAAnN+cXwukYd86r?=
 =?us-ascii?Q?H4Aj8qhXUeKMQc6cehgZAts0v6rrhsgLup++zwtcana2D9UVQiIDTSnzNO2W?=
 =?us-ascii?Q?E0/XsREK2vDuyWj+W09Wx3Pa66TPdw1/DgErcPvg35R7SVxDTvMWFF3GRmuO?=
 =?us-ascii?Q?n6PDRoLKM87KkfWkXD3L4HJctH7Yw+pawVO5XnJMTn8meOM7JUWq2au1kVt3?=
 =?us-ascii?Q?WHUEOf5sy4QBgmH+S1Fu3xsEOWRTLU0TdOvF6SxPsqrUFkyYhColU3Jgg/aU?=
 =?us-ascii?Q?fKRy9Xjh+GHFqC+/0o2xFLbSlkqF3qXoGsybTM5JZc01tZq4rEqlCK56IZ//?=
 =?us-ascii?Q?GeXfPMp615eoQBnBZs2ypMiSEypjD+FXDc+LfhSajd5Q62gjxBj4WmJfBwjd?=
 =?us-ascii?Q?wrRVgKNpeziTbRhdEAdBlWJQaesXDYCKc0RsBMNE3FFZyMHeG2ELVrmpvh5s?=
 =?us-ascii?Q?D6ugKl6ZxswoKudUGrCaQcf+Xnsjf9u1Mo8bURi2U4Btg7fka9FommALOGuh?=
 =?us-ascii?Q?4Jg6lBx+REKqYbMSFH9T0pVztUVSmClD4DdQg+gdzLH9IWW1sFFMN++0QrZM?=
 =?us-ascii?Q?dDGqI2rfj/2vnq5uNctTQTXAxv8dQDk6bqQw3dcr1vEn2jfpSJYXnW8pecIw?=
 =?us-ascii?Q?QQ8Ix5SVFKKkBoBk8bsxJHbtZIeITVRHpGDm7XwH/4Z99IIKka4GL7Rh6xOK?=
 =?us-ascii?Q?jDKzJlk+l1yqcziBa6hr8CQH9Ix44GgyX1PKe0U22bt6oaPYUilDZlXYlS2G?=
 =?us-ascii?Q?WYiL8sq1VdZiOt5E9qs2EfkyQLIp+D8anf2/6Ls1m5+PWCSvay9lvv8/uczU?=
 =?us-ascii?Q?ncV8I3yI+0I4YEmQv1phHUalrK26IpIYV4147t7QhfDsgkukr9M3w6826x78?=
 =?us-ascii?Q?68U2YDfAX84iixJB6egvlkldovzy9vs1/svYkJbB3cWE6BP26ZuIvhVad66E?=
 =?us-ascii?Q?gBNE5ahWO81t3o0hCTawRKc26BcifOp30HoRKCayBvPXDA3A3bI9evga//na?=
 =?us-ascii?Q?wQwnQjtBUg7i+y0ztz+WuV/DDiwnAOkVSdLHj88RT3HYZ1TDmFjdzds+CeBb?=
 =?us-ascii?Q?ZqZlJVCf9L8n8PEmHDygAv6nEHg9wtU2B+w/v5D5qN04XPTpQAye7Yt3/phC?=
 =?us-ascii?Q?d9FDfvPzTFVVbsYMAWv3PJNJ34CX5su42Nt6YMB/8arfrUhqrWWf0yNYm0TQ?=
 =?us-ascii?Q?w1spN+MAOWOo0iImr2AjJeaJpTCUtAI3Lp0lxICdbyvNjj8sRSOU25oJZP48?=
 =?us-ascii?Q?RL4Ms3LL1WGxDw5KIBSiLmCoZ02u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c5shs9bnQae8TKXcuzWEtMwHwWC0cYU64fMlajcpOGJZ4MIDSjVl3T/7E0Oc?=
 =?us-ascii?Q?ucfhVLviEcqiSPfDpZOkE65hmtj+O3/I7KsxR29UjDp7JH9ZJs5ZTxLZis3e?=
 =?us-ascii?Q?xHoX4rEK2s+RAZhMVcOOHnaG2HMkb7erGaZCAV8xNhmlGvYxY/IQxkJeGzJh?=
 =?us-ascii?Q?aV4R+vI7Fk0HpBGna3RLi86pThw+USIphvtqdZN/dxnoCvzpfbQsyPdt9OQP?=
 =?us-ascii?Q?w9pjDDy0QXghik+A03q8ki1w9nARAxHBgnCupos1e8IIyDvpcXNKstWkJA/D?=
 =?us-ascii?Q?hxUskv6zQSainq12ALKwqppbhy8i88Np4LuwrysbBmR82KMS//JzAVIJ1qVK?=
 =?us-ascii?Q?bAh16OhCXpXpmY4k8T4ILSuEykavjdQw0dgbDjvMH2ADs3fDU6zJA4FFRLHP?=
 =?us-ascii?Q?ftXlur8z4PMkdoQghF6utAitlYLc+Q/u8qdU+OwV3z09F0BTbpaEJbw8xLEH?=
 =?us-ascii?Q?J0aGj63NSeh9U6MBzdvkYBe9IgacH4gU5gPu/d4QcOzGo2orju+QrzX2NKDJ?=
 =?us-ascii?Q?H+bKUn6XvxSuZo2E/cv1ETbH32iWbFEOpbHcgOLC3ep5A/1BTlHTj3frtmbx?=
 =?us-ascii?Q?rbGM6jRS3m6p1XkdpuBjrHxipBCU1C0lT7nmGUIobDALevIu34KqWg4eylwN?=
 =?us-ascii?Q?CPQmnjSGoN0rTe83WaGb61se0HuI7Xllx/mNI218arvit+odlvEeLZbGcQv+?=
 =?us-ascii?Q?kw5k4WWCPXrKFxuwgPAQsXBh+5YKiKZqWsQIzZq6+8CG5c8aa7GaBPgxD/V0?=
 =?us-ascii?Q?2Hy20OW9rOc+K7IiH+bYvhinGcpBi7DwoH78+XElptWa/QtcUQ1nIBsVCROM?=
 =?us-ascii?Q?Ei+3DnjVhpcT501Ue+mGacVqAea3TSasNm6F5jIQSOAoWaix8X/I4ypMAMAM?=
 =?us-ascii?Q?hrShisiYHaQ7LJXZnwI4KBtpUlAjweCNqNu+WWsyjnjhYfd+zu1kDVE235zX?=
 =?us-ascii?Q?Bx3M6oYjKlWLxXN6vfSGwSr26sfq0zrtDWsZaj/buBt4rjdGzMdCP157tp6w?=
 =?us-ascii?Q?bMYJmFmWEV6R3f6W3b+fw9l5ytO+DXALCJ2BGuaTpFckym+hJX2zhapaypPK?=
 =?us-ascii?Q?2X8vclZdd8fIPB6Zy4PVlqPOY3+wrpeNgZu7/bvV9eJ7E60S5pRsfHrn+/6Z?=
 =?us-ascii?Q?qiDYBWuGIcgXjEzYSIohf5mqwCnh3qQZyRzQEmStSyzva4KMqvmvJhXuFxNm?=
 =?us-ascii?Q?yuS6TMzWxb/vmQnAtqdK7Up5YIgI4DcXh443AQxz4E1Llh2lcbz+072p/FZf?=
 =?us-ascii?Q?ai/FvMXo9WSWA/qOe3+sh8pDDeoSP+InYB1z4hIKtaAa0ZLfvCB2eWoZkm4O?=
 =?us-ascii?Q?VpARV3T0iba1CoDgl/7cQod7/Svgo58DvQ6B84797OICP35FChFJYkk0By64?=
 =?us-ascii?Q?M6xyNVfcRB6XsfS8xp6xf36wht6RgWsi5NBrSjFCorWBoXgS0c7VfXFjz59L?=
 =?us-ascii?Q?B5fLGNOUqAi/W2jOCpLFkvM9FIeW/DaFSeunL2Q/oiIVRZGMfWazXuma6LuM?=
 =?us-ascii?Q?Xk87JqpuPgwSaTthzF6sxQt7MrcdSyErSKxj2vkvSchd/PIn70LI5kvK/Nxt?=
 =?us-ascii?Q?yJ4ZX223SDSwu+pGGKKciLtbZzymutu5bFHzwdkWuQp+R9j5Hb/PpKKjl6Bf?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BJZTdxHttO5rusB46SrWPISSHqQE5t+74AjKSk2i5HQlqi9sPI5W7U5Sb3M5dTsbWZDhTKGpWLydw3bXC4ELOOghmSSB91m/1H/ytn87jG+MbnrLHKUf1PwgmBluA/ugHXl0AHxHv3ZJOMQg7MxM1iZN3o5RZUIu/buRBD9jl3GtV8rn9u4DT+NxPcE6LT8tYAKqJhjOaZkqLNLsu26Vu25z1D1KBIjy6NF7DArd7DiZSgf7SDBunHNM4daohWj6pULi8u3sKgBbm2hmhQ8KIsPFlgRVbnnKPIH/7DcHrLI5EHJKvohnyQIN+W74H8urnv+g+Ssjb1Ty3M8UOdcperu0j2rITUObHw1WtUrN1BAEzHAPb8R1d5wS4heMgFCSY6Tj12ElM9p+kzRpfpE4oNybAOWqT8tfteO1XR3cVnOP9+TTsoqZ43B2rVkfnLlVd/FlaQLtkNOJunivGYCq1EUJKwBNH3D24LgEo5Li2EF1Lv4r/13rb+p/i9k16rsHJ4uWrXYNDalRD8VBzy44NpDAvcy+PdepXRkWbESkjgqH3GXAzYg694GVrEP0GfcmKSj7UiIELaiszlTzxSgwg0Fd8sZPDEburzIdH+5OVec=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2cf52a0-f11d-4e98-447e-08dd5ac9ee06
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 03:09:08.6216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnR8EGBQmOgvrxTU8Wu4cS8plGJphDwzQf0necg4BSwblTtst3t24LDXFOlSYlFXmvlfjcvJ1IBFOEgi2xQFwWixuOE3++eqcNxG/6PWuNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_02,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=770 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040024
X-Proofpoint-ORIG-GUID: 68ehBmsHaxKWgRZLM0onrfFc7hJKNBiy
X-Proofpoint-GUID: 68ehBmsHaxKWgRZLM0onrfFc7hJKNBiy


Karan,

> Remove unnecessary locking and unlocking of spinlock in
> fdls_schedule_oxid_free_retry_work. This will shorten the time in the
> critical section.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
