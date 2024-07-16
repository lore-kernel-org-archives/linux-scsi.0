Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B656AD7;
	Tue, 16 Jul 2024 02:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721098670; cv=fail; b=Kr+i7XWwyFIqIXC/H7ivFjyLAjangmgaGCFqfoENQTXhW3FTlrJ55r1N4HrYP2liFjfjsDSc3Fo3mKCzjA3hVedSxAbtoN1jIb7DexLfHlVz50pHDW7kD49pU+Ts+7cXhDc+WEPWEg8UC/iUyju05JgwGOSzDTHXSvVlfAoVHGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721098670; c=relaxed/simple;
	bh=8+m9DzDJ7RB8YSMIJEdWp5GdWl27rphSa2NDbs9qx0Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GVql0Bsey8LtOT03L1p9M7nEAFfxK1iAH+9B4tFl7kSXAJiAkCPKKD9Y5oPHWPBh1NSS1RDZg20RMN3eNe+UpMlibJnr1B/R9D9G7Pf7RQq4yNMSWVpzyQ/ftQXHxxAVAycP4/s/AmZAJ4T3I8Yy2+E/JYKfYxIfsEdp9ZjUlzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jlxDY2fD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wstUZqRD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jlxDY2fD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wstUZqRD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46G2uVN7027049;
	Tue, 16 Jul 2024 02:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=TesKjoXpa+fb4q
	Cc9qvobfeEatugGfqiejxvppkAeoA=; b=jlxDY2fDF+mheTdLaMIy7fGEkl5Trc
	SYroLbAzAQMk1gBQtOt+pPTJ5FO4TG/XwvQMwptCUZ36aNJi9mrGs1hIoM4l0dnU
	n7anuz3JnfoeWtkyWlzEbpqu6GhspmgTE6qcm00SCkPy9gEyoFfVSPlPz30Zb/dx
	XK5/6OZ3SEO/m0yNNImwncAx7Xa4n7mFoQdJN2XTOIkCXKOqfKNL3TyuPYJq/jnN
	P4nsrSru5iUV4oA/3ShJFclHjLS6KrhKXQIPYpqiw+dsL9I1B0j2g78nnb6oo6SA
	m+KY3v0b0QOUkcv5++jPWKN9ujXDDAV3NLFOJfStrPJs5ba5QRQCmaqQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bhf9cbvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:57:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G0UMIw038980;
	Tue, 16 Jul 2024 02:57:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40bg18u782-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:57:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZeNmGwlzbpaQmQysSy2Lr74CQWT2+dZwUBMe2dD8zOpnkU543t1cFzY8sHntTl/IIgaAsBwrhNSizG8shyIEBzmSEaNl8Gr8RVkO43C68byGt9AQsJo5CvhRO8S0MyYgG7yiQzOkW4RmNHzDttpNE5rTF8IMfVlzFTNadqDzjE/uaUFweolbv25PQWrpEw7Cl07hp6wqm0BKISZu64o2ZO7jcp0ak4LZgWuxvxpXXvrmHdnN0c3zt2H6mn5INkOYoRrIOeOEEon3F1UzxIW/Nk0ZFjZ3qR54OYgHVYRuJdwoJkHzPHCRVDmONLz26otvFwqvT0uOCrFxpySV3B0D3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TesKjoXpa+fb4qCc9qvobfeEatugGfqiejxvppkAeoA=;
 b=GDQNfQl674CokPbcPozv+y4l0teVcxSxrN7gToj4IQxhUoKdsPapee0Eey4MHKoSS6UIYP8vKC/VpWUvI1Zfb0IANrKwPwjYoxYkmP3z8R15qdlVMi0Df60XKd+SNmfr4pBafT6LnOU0UdpsPrkmapcoVGPm6maB0wZh+/CX9LSny95wNb8lpBlp5ttOEoa9wYLCZPt80hqYJ3AJxh1WyItCK2WlAbX/w1iHlUyZ0f3P6H62+OuXzxEoAi38C6TOt6VfQj3XzIzMoLMKa9qq7NRyUG/G8Tk33nfaYYQAD9RXaP0Do2dWgc9JkM7tYDo1GvcNe7+VLCf4IOGNr8L+mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TesKjoXpa+fb4qCc9qvobfeEatugGfqiejxvppkAeoA=;
 b=wstUZqRDREiA5ZNJkOIMb/91xZbkKcEEYiZwGQHfWUH1OdjVZP9A+PTcp/fJgSk1Ni4QUlBXI1pix0WghBnXnFm149kagG4hcXhNu0NQ16YVlI0sTDxuPh9cqWPqPeQlLLCYm9ldp8zASxarn9ltk/dG07LPm1n65oJXFcjAzdI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6307.namprd10.prod.outlook.com (2603:10b6:806:271::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 02:57:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 02:57:37 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <chu.stanley@gmail.com>, <huobean@gmail.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ufs: core: fix deadlock when rtc update
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240715063831.29792-1-peter.wang@mediatek.com> (peter wang's
	message of "Mon, 15 Jul 2024 14:38:31 +0800")
Organization: Oracle Corporation
Message-ID: <yq1plrejb71.fsf@ca-mkp.ca.oracle.com>
References: <20240715063831.29792-1-peter.wang@mediatek.com>
Date: Mon, 15 Jul 2024 22:57:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0626.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6307:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a82b85c-5745-4618-c31f-08dca5430c62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?qyvVSc1j6ZfJB/P7beLa/F54HBd1Tsn9lT1cJoOo0KCLNsfcej4BW3G1YvFu?=
 =?us-ascii?Q?ioaqrglhOaGmqAz4M4uaeCdTWKRlrhc2SpTpNUZ4muNrM2LgJbTJNaCmY8Ti?=
 =?us-ascii?Q?IT0N4rvsnukDDieuJW/wA9jUsV2j/04HovpS4HKVUPVlkmAxY93yQ/+glPdi?=
 =?us-ascii?Q?iJP4zYvQLXAiZgnMo5aazXgyP6+SzVaFPUYZyI1fj3VwVRazl1hwNIisToi2?=
 =?us-ascii?Q?KVzwZAFZP2XWClOjlPXSMQX8jxv6UYr84ocxi7GuIdhMS/Ze0pn2T5CW3/Eo?=
 =?us-ascii?Q?DVoQsX//aoRuChijQMd2QaQ5i9GcuCkjqx3sS+22m4z9Biig++DS1YNzWgF/?=
 =?us-ascii?Q?zz6x2XzSK6AKQL0k5CW3aLusr8cwBLJ+Z7AdvIHz+rPIRm70lLU6K5dv6eYQ?=
 =?us-ascii?Q?ygs57nReY85NkAC13blOB/8hrzo+R1II6A6EqfxzhOe35t/WuA4X69YnWv2T?=
 =?us-ascii?Q?aeGvROZtH+mZ84LcEwNROICzSRvU+BC7ukrK+cdV3bFd8eLTpwq6dCPymLeQ?=
 =?us-ascii?Q?hSiehS0yOmWpGeyK4tP8XJ5DXFvruwZ6tO/H5jk4G0lIlNIFyl1VIKsZj2wo?=
 =?us-ascii?Q?dK+Y7qEVmsw2llrnzyx5SBvA16dWsNpJ+DnBlp5wpi0qbAoe/CmXFh5WcmJO?=
 =?us-ascii?Q?3L4+RIXM88/8FwlzVqtMWfBylBKTkpxKOrkZ7OVHFJ9ZYJVjcMytvEUaoIok?=
 =?us-ascii?Q?EmclofCi3ghmkNZeGZjjYHREmkM+wSR363ITulF6SaL3a+gj02nwpXKNbGj3?=
 =?us-ascii?Q?+il2w+AERUe1oHYpMCBVbD2zw/8j3hN+FR9ZlsK3bN7qW13tHw/z22ND+osq?=
 =?us-ascii?Q?KV9pb36J2rqzWWNgQXth8fwN+NDCx8M9kJPnVeSOF99tu82ZQ2ep8qOEICEU?=
 =?us-ascii?Q?IBN3Ne4geYVAvYWTp4FiVfzfUqsrR3Wz85FVbPG9Kx2CK4FxbZTTr17FCNVn?=
 =?us-ascii?Q?zTh6SEmmJ5b6OCFnFBm6JGhnwKrUKZuIkmO4p5di/9um+1wcY4OrjxFtXe4F?=
 =?us-ascii?Q?Ftwe3rV8k39u4omorggjdpOrE2T0E35ihZEQUobBm7DVRznPQ91z7OJo5ffD?=
 =?us-ascii?Q?U98gFuLSCxJdZFdEU3uiMovzWNXatROlv4oF7JVWiwZXUtErq9ywSTwPbFRt?=
 =?us-ascii?Q?SC0N6oRA0WFbhWoQBUi+WEC9J2pjmQJZVbzTqOTJDAsvGqU5OtNKUlhIoNfh?=
 =?us-ascii?Q?7E48/Y+91pihGuwEIZ+f5U4/w4zWedhaTQX4i0CdVebpMEytwLS/1TzKST6y?=
 =?us-ascii?Q?JPSHqc/RorUR4nWEpdjkaPToncsruqj94szhi206qk6utz9zhYryp6empdR+?=
 =?us-ascii?Q?FF3RdW8u9k+AmdYtAmjvv9y+fIR281Vu+Holw7ew7EA4Pw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?9C6L+KRcl5bCMxP5p9jjzos7ZMbOSt2Lqs4haFLeRppDEhmrXkSPgEetBjFw?=
 =?us-ascii?Q?m4/WgbM92sKbIVREP4YYNIYsiybnPoFgbk/dVIXTYnBfXXFBb0zbD/n0at5y?=
 =?us-ascii?Q?yAGNOxCZ+blRZzwT0rpl9vprOu+btDrU0WDHdBqQfCpQ5EV4/CCeqy45eRm+?=
 =?us-ascii?Q?EOsvS6I1jCsB3OguVMIOOAlorqCb43zdGGXfEU4rRA3vnvFodC55nHXMUClP?=
 =?us-ascii?Q?2jViwFMyILlVxLnEGpujXxupQmy/hwjzt6FgWFGRos6rfG/EnTKI8JyyO0yF?=
 =?us-ascii?Q?asHaeEelVxSrgAyaQO81D6JciOMQ0B5FTmGu3NjwyrGByPc4zLkVSsaZL+0l?=
 =?us-ascii?Q?CFVVembWu2avahlkDHzybgeeuBH5q1uTU/+zXg4JaGMFc75VpP5splY9QbZi?=
 =?us-ascii?Q?Bp1266yfO8Jdfa/uhOk7/VdFlNiyok0wDcxIsvC1e14ggQ+dw5QzjxJx1wBw?=
 =?us-ascii?Q?CoQGxkP4kxeCOtQF9k3w+oN/ClrdF9PAuND/fqCN4oTZdjusdI2RSQOutFL4?=
 =?us-ascii?Q?//HtASALO4NJIk0uzKjyroaxTg39vSyr04udL7ZK7V+/CvmX4zXikOTVcnP1?=
 =?us-ascii?Q?DpcEwDhMW3/SzUVD4tT6IGwAF67BaGffuDH0uzDxthrhZOpb71U+Zdjliuuc?=
 =?us-ascii?Q?8a42ujxUDsjzeEV++NN4Lw4mFbPO3Grx3zyUxZkp3ULhLhulVjwtOGRwrUfi?=
 =?us-ascii?Q?IfoNpHBMRIfdU0uY2qmuGYA6DiEC/HYoT9iX4sAXNuoV0jRLnawhVqct9KXl?=
 =?us-ascii?Q?EsekIRazXQZk18x38jeoFL8mwKHg/4PPgIITBZW8ZAGw7xY3d2RMFKqEmVW5?=
 =?us-ascii?Q?S1Kz/NHOkGR+5Znorjl5xVAdzSdbHLWGCQAXhReMPCSrBo1z2DnPBmbJlJ1V?=
 =?us-ascii?Q?igAQzPnhWkTe7YAk3hP6+D2G7fiTOyRnC2L64lZW1ceLJzOVhWKBI5htCFEm?=
 =?us-ascii?Q?eSjS/U153U7Rs6R2IJkB+83CXMlfJz4TZe2625Mo9/rveYmY7X++eo7y7Fp+?=
 =?us-ascii?Q?08lG4DR/JQxtAQMF9gjTr22+13okVCrjLuLAG+YRn1Oaqjvpu1BttSlWwRcC?=
 =?us-ascii?Q?lC5U5MlctqYOjBXhipsXV3xNyZVKTowzfqPGRB8lADyQMYjSCg+S7SmlBzr3?=
 =?us-ascii?Q?LsvvsobZwy15xE6ruJU7vIks7Tcb6R+UVJbLwa6khaVBrXlIFb6HZVrUGhmX?=
 =?us-ascii?Q?cD68RwTycsIbwc2vdUyVRCwt6RhHZKMGbkiQDyHsqMVoXhB1HQgU9F4MVbCN?=
 =?us-ascii?Q?+Zt32TJlnq/Tdn/qU60duMCFPHEfhYKcrRt2BIaaqkeCNnOmeu87tkv8VN0j?=
 =?us-ascii?Q?jx0JlSQ42zC2Sjou992o7S5jzVbg78bAFq/g4VVB45OW4zLk1Er+lr3xvfyt?=
 =?us-ascii?Q?/9bWY6yDIEk+7BLnVbcFBuyb6M7UhCiEbLa2KmFcQ9/wV8DLoIyaYthzbErm?=
 =?us-ascii?Q?1Z5STr0fQoejKuBAqhGArmhk3uC3umEB5GULhVlE0mvqv4aKqIheuT8BgF17?=
 =?us-ascii?Q?49cay2UBPqjMvr8LwdskQihMEISmsmVKFqGBHhVP6WZtDzxXS6QMRA9+2yWp?=
 =?us-ascii?Q?Lycd7yEQIPHwAzqdYTNpZwv+w+9OjylbL7rd3I6obtYeQxjVjr+3SybsjHCi?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	TauAwTsh1vxcJdlnM58S3iexXdf6qmKUzsVxm1gCUN4jmjcbWI8KKbH3FL/RmQv2EFMATC8HHyqxzRsof0ETKdvX2VbidzK/RtgqvMFVpZxpoB/dF5FkHkizX15DcU8MAK1fQsRo6GT6srM0IB3Yq43cpIEIt8VnKW3jaC6ULX+c5W8kURqumt/RRnxFwYFJ6+MRqO15kyzIIM9qy2iHklYyLEz/AyjJC7XiNQYQqHNa+5/KESfZo5dc7DLSO8LSZ2k9OXX6RBxizdp2qv7Y2kQ/WEC8mZnnrCX7Ps4BT+nKWl5PBQl8AMXdcKXA54+A+hOnUJgQ1bCDw5wo0WL9kf1O+oCAwoxZs4FNkH0ysuvqYpNNll/i6R535JjLrV+yuLg7Z3KTUIXAe+c5p0whwWd9vqmJO74WCoGt3S5ZJJZlk2rsjjHaqLk0BAxP6gw/os6YTwotG5uM4PVwpJlysgl0CNB6SZA7iNpLHgpyu2tOpIhWHDJr0KeymhGIFumkXcfY0Xo7jpVVpAjYp8AxeyaVs3WzvkCJ1Do4ode8V8/Rvsqal02SUUY3bbnUr7L4gcx0zd6VGiJT+fa9W8fot/DmCkyLQqbFlZ+NNDd43f0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a82b85c-5745-4618-c31f-08dca5430c62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 02:57:36.9872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vl7e5E2pp7QonKTaxK3KlEqzWeaiqJbUF6qqLApuDgKxRKW0cRuplZ2iThGPetbhy6ZlkKCu3sMO3kBWk3Mywl5Z0zkQibljP45jon/HpfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6307
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=929 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407160022
X-Proofpoint-ORIG-GUID: M99oaRuJ1-LNigPfhHeyuPLwHgxtOoXp
X-Proofpoint-GUID: M99oaRuJ1-LNigPfhHeyuPLwHgxtOoXp


> There is a deadlock when runtime suspend waits for the flush of RTC
> work, and the RTC work calls ufshcd_rpm_get_sync to wait for runtime
> resume.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
