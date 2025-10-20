Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6CB2FB097;
	Mon, 20 Oct 2025 10:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956729; cv=fail; b=TplQ1zFVejOf2u1MtU9Hfd9TISrHowJCHt2tZIhbZhSn6KZAGtiUwA2acMOq5k7w4lmcHETquCkLNUIGJKgl93LdGffkklDXeDgOa1/KjkxykxrQRWbiIea71kYcA/yghqWAvuxkfxyR6qe4cKy49oSNv8YURQtRTFSWEKL3pXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956729; c=relaxed/simple;
	bh=O0umhKrH86sZpLuIjLhjHtxr2ZaMuL5FOgq9frGoicI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o4NtLMsExFWBE1JPx4OncFlLSSDrcCPVCpauWvNvE3pKdC0pbro9fg60ib7tCLJPStjx7RUjUIv7n0jj+2bp81fvmAZlgLu1TcjZSyjJlLkMvJ8PCzzOV+8IXekdyGvs+5e5Od49/DgcNDMlbVQhr9kz3ms8ZbV8VfXjSI4+vX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k3A7mL32; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fA34/L6L; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k3A7mL32";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fA34/L6L"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SJTK008948;
	Mon, 20 Oct 2025 10:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dIa3ePwvAWaY3kw92znXX5CRVzoShcUAAqWtvkIt9Xk=; b=
	k3A7mL32TVoqDlVn50kUNNPXofaWCOPBUbmmt+T8domsy4UlANAhsKnMcuVg9uHP
	D3lEU4yPZ/EvhPu6BOLkBkI0zDXEcrVOGmc4r2vx3zyi6O5KaSR84zp7z2eqykg6
	GAUDWT3PvXbAi/b7aOjmgdtAnKtrs0GbJZ6ly923pw+iMqwaSKVVXfQ6IHdGDztR
	tgCXe9WfkIS0GsJhzvWVJyLrupBrA4kej+Ce/LJTy3jvxoGrfHJOMWu/3OCf8R8h
	VuTQVPLMcCPYXB0SW+CitXS78NX3fnCCnoYd6cL97MVQ36qWa0vd26WhEfiD+J3J
	xYhMLDieLMgTf5xvotK/3g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d20px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KAaK4i013669;
	Mon, 20 Oct 2025 10:38:46 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bahuvj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W2KXXO+JDfmk/8a/HiumrJH5V0HEQdCFKwGPCeuYlWMnsV92NlELhTpYf4l2kfgx648xtxbfidVaH7rb0nTBnvit62cdlpXQGriwPkbT8XfwPN85fnkHdXrYdZdQUvTemrClC5pDvDuQAGiLiiOio51CGhCj4KWWG9+b6F8KQcekMa3UH/Fs+iR/hip6kZIkO9qOl8Bjkd06ah98/Q1WKTSV0scP5d+ESFviGZfCUNSHK/GyIZqGk8jMpggBmr3/63r4jlpqEgWdBpljLQv3/NZXvMzwWXouxrbdHCWHTb0omjePmasgdvLWnUp2WgE7f/WkBGXnEINIiO1/QFk6hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIa3ePwvAWaY3kw92znXX5CRVzoShcUAAqWtvkIt9Xk=;
 b=eMQFpMp83t8Lv8kS79lMhjaNzhobzKrXw+TE8J1c4liWKGvDIRGGcgm6BEvXjs9LLikpGgkhIaQmxzrz7uJFgEUTlqXl80dEQAJgTeXn8ayuh92J1hUJETMQ3imMufuQKvEiwx545YmcYlUBm9MBQnjLBUeoQLE37ogYBSLBRFzEqwFj8aPUu/OT8v467d9xpixTS/FyiOTUXobcm+MM0J62fd+aoQ3A6oJDhVFEs6PdBMyh4caukOZ/F6tauA/LF/ZstRvVtEd14u6cgdoTu4MrbRCm0D2EYyY5CllWDttzYJfPBAyGAy9yay5U/uTdE7W7F+wsE4y508xUtKnnow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIa3ePwvAWaY3kw92znXX5CRVzoShcUAAqWtvkIt9Xk=;
 b=fA34/L6LfSTURSqXx00gkTtqidRj7dUeUn/Q0RUuT+XqStJGUDxcd08IJs6tilxjetWGfbIw/Pii38wUg6Bzmu80BwFmARfzlW7eTdpWRs13KjsBCV/5PIPDGVpro5wD0TV9QaE7uLDMC5LWV05j1UMNNszhAvaECcQzARw5LTo=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 10:38:40 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 10:38:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 7/7] scsi: target: Add atomic support to target_core_iblock
Date: Mon, 20 Oct 2025 10:38:20 +0000
Message-ID: <20251020103820.2917593-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::31) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: b336e1de-ff1d-483a-2b90-08de0fc4d576
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9EcDaRERo1/r70KqfuU8Bg5O3P9y7CvQPb5gl+ulg//lQGd0eM81NfldUlVs?=
 =?us-ascii?Q?1z1wnbDdbEDH+IcUpOWKbi1Zhq3GV6C4g2pJg3j83k8dWv7sR3ObNNc/yxEw?=
 =?us-ascii?Q?8SDN+cWtmz4Y/fiikdyYjQbeaT8pE/1XGm5utH39vWZ/aOgaz9QNjElWr1L+?=
 =?us-ascii?Q?4MSB2HswU5lXvWCnh8ReM2Go948QhM4q3v8Q7pxuk136mqhTgWxPPStAvynp?=
 =?us-ascii?Q?QsZhGTcaf0izeE3yE8AIhCcEX8O5D3mWRIjV54TDRpk7ODbSuAikoMjIzb8i?=
 =?us-ascii?Q?45b56aUaDjopqNTnaFSJGscw0P+ZldCtFaP1hgHz5KPOSLjq0+587cVE6fF5?=
 =?us-ascii?Q?kjBIpl6aixPAm1lP1REYwmqAvtB/llw+V77QsuNoVOHx+Wx12rsxZB2owrjY?=
 =?us-ascii?Q?MTXhh2Tu9F0HRocyq0qRxObPpFJ01nA5Xtb2hquMhTXekVyV76fuq5IjUJ31?=
 =?us-ascii?Q?YEdAwIR1MEAumzwFBvpVitwD7cntiT0tsDdNrjmSbKFsN3E9CkSgq8B1J7+l?=
 =?us-ascii?Q?UQOM2IeoFxLpS626YUdBlYll+PKmnoE5JhW8sQ8/JR4WljKdQynLDQsBhOT+?=
 =?us-ascii?Q?JkEPMDiuZIDJGXc1MUdEZurmYCBSz0frTV4eubMIqVa/EhR6ocHaEY25gTTz?=
 =?us-ascii?Q?682a/hVHeJLZ4CsmcWWTuubtwqYNHONN86s1pao466c1duXngG/BMNEGzYWN?=
 =?us-ascii?Q?fKgq/UH52tAYQ6FOR8quvUnmLw1qGgaExsnmXEbESZYZ1heKeD2xl8Ovv5GJ?=
 =?us-ascii?Q?veI5ITHojHWop/lfDjd+oxeBEAxYXMoIpZI7t50yjgpne66+fFxmuIoOhuWy?=
 =?us-ascii?Q?aUlkYZDCILuRPrxZrgpqewJXI8cLJpA6wAlijQQlgQp3hDEbzeognPaCR1tJ?=
 =?us-ascii?Q?6NteF4A/pkk6UHQgzRHwNKsWYurUJwU3ovyR/rtrwRkyOLa1bv74nCKx7bcj?=
 =?us-ascii?Q?ceeS01lcYBhI0c5XlSeJdxefldMP+C1FI2kst8dWCkdtaEWvmcxPxyThVIFS?=
 =?us-ascii?Q?RQK/susG9estv4x5jOI1pmYPPR7dHlgxii4t4JnB110vWUqvQ395lGh50r/W?=
 =?us-ascii?Q?JIZPFk2ldjx3zXBSKn3AcMb9Hk8zfq1nug+nz1L5/hOQBtXNHhE14mucytJ1?=
 =?us-ascii?Q?2brN4b9lqkQA+lXtCiVPGLdSl2sNRd2fuD1mQewh3SqZmWCO8cQSCSMax3Bl?=
 =?us-ascii?Q?LytAYdOCV+U1U76CyI5ergByhnjm+meglNVXyBl0dnQCEPUN26f4xfvYMg6S?=
 =?us-ascii?Q?OAQsdLHLMtJonPv9GfdSsFAT1Lj7yH+WWEIh1yPBwEjJn1aNL4QWmyQ827oL?=
 =?us-ascii?Q?4rX0m43DUbh2IC75BXJHpqWtAmGdF4YEz2scSYL3/ioiIiXI3dU0fyx5v+3f?=
 =?us-ascii?Q?zqo3F7oaL11vLDfss+gOlMmhk84AYtcIr64B8t1jo8LPcjBGWUJEWvcx1zLU?=
 =?us-ascii?Q?lDieM2j91O/P8zc3yZMcC2MpteS5oBjU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?asai6yC5o1FBN4zRSuWdk+5VgykW6Kk6ujgO0SyYsBhuzBYjBIIAR6Dqkfz3?=
 =?us-ascii?Q?teNNOlDFnNJFE648Jm9V/pFy3Cqt9ZtBA2JQXYkeP6jGloiJTnZof7gloB9y?=
 =?us-ascii?Q?4ZWmH8U2q76Mm4/TtTe149yQ3IKUj2JF1O5xizQtoIXRrhXFCnJyBeQJAnVJ?=
 =?us-ascii?Q?URvNadqo/BHtwgTf6IVEeoMEr4VLtgWLbmOAOIeg0ErDNSthhDANMmRwTHFn?=
 =?us-ascii?Q?ljtTWTQEdLvYWi3yim8uSypA0hms/hIwebSRClZws8rJIic++td8KfFXQaJj?=
 =?us-ascii?Q?WIlgeGfS/c5XxXs2wlo6W7/kbetWlNK8ur5fCbjUY8e4fdwtJzFSaI3Foz6A?=
 =?us-ascii?Q?PagSJLz5fuIMiCzGtPDpDgJD8nesx2rkGiBVvfc48ig8YGVhOAqeZLJJSxr2?=
 =?us-ascii?Q?r8frl1aI2aTxt2bbVXziQbxGfG+F4KSxAzsfG1C3hsv4C/48zWqxMxVk71ja?=
 =?us-ascii?Q?C8P4mnT2VCNc/PirwyOatOdU7Dg8poszT+Cli5FM5N/zacEAM64eUmBJ6UNf?=
 =?us-ascii?Q?+hmTxkqmegdiJH5jB+QmAYTj07BU+wpVdwSIKbLf/6KNrux2RkpXFWj2c3Bg?=
 =?us-ascii?Q?T001MfWULJ8JvvtrHo7+IBHR7ogdb3nMS3giKmCGOztcTUdrGc8TbakEfeFO?=
 =?us-ascii?Q?egrwwTqiOYJpGtKSY7bzUB+PDEFEzgPzg2vgTGZc3YuDC5w9Rzdlv10uPmVQ?=
 =?us-ascii?Q?bX4HLezz51w84Spc+ugoBlMO7yTDiqLqdweR3pB0x9epKuYUwpltgmzQQPhk?=
 =?us-ascii?Q?yc+7UWYlZPksgM8fWVpx/ixWy6yMrkgCxy6fqJP8KEB4JRL5jX1h3qS0yPPP?=
 =?us-ascii?Q?U+SfOtt2ilggJOn/K1TD2OcUXxdDhp/kFPiwYdUeRAO/KJbrtORnwAHiZIM7?=
 =?us-ascii?Q?aINrmHZATEEEmY/pEzebGetOt+XfwejEgRfGuU9dV9rWS0YyF7Tn5YlbAJPs?=
 =?us-ascii?Q?eR7tfmEyg8eA+PVIZLffTaz7XzOuZ18gqqr2h3kmpFI9V7cR+ThsvBcnQtiH?=
 =?us-ascii?Q?KWMFdvw87xHAFpbe4U8OZKem5eRl/K3f6ok0uPCh1fHGu2F0vb5LeoT8CZ8W?=
 =?us-ascii?Q?sEOVz+N44gcmryGH+q7qf+D9ZN0sskjuOtER7QHIz5leDd0tl+C01zq/FnkJ?=
 =?us-ascii?Q?/Guf09qCEmzkomJjtJFEuhlQCk1/nZENyR5NPbaV49xlWxmGei54NN5I8hF3?=
 =?us-ascii?Q?Opjuu08lSd1mFUj7zYSu1UH5oNMrMfjocD3mxVoM3d57e7f3p79vAz+BB2hV?=
 =?us-ascii?Q?vG+LZbTbto+tGmNOHKGXuHm/M3DIkIoS9N8huDlGGy+qB4V6XAJ7il5BVafI?=
 =?us-ascii?Q?YUK+pMdvMxxgDKWtg2Xs/7agvgBm2lw2bHPCGSFMjuKoFU2TBOxEAQaiKIoZ?=
 =?us-ascii?Q?zJ7vtfeApPyeigHhPPouW/abTjkkHEQmsqOSTesR7W4pJ7r8TFKhno3SR/jK?=
 =?us-ascii?Q?BxvyBRWTUnPgyWuHFLPw1/+4Tnn/VADYFIAoN/FSV/Rwro7ew42WDsxT6drS?=
 =?us-ascii?Q?AZoZ5vX8SL1gvM+Os68d10EEZbK3fnsTsCpDeksLhvSRhtiwCp6j4QTfK5G8?=
 =?us-ascii?Q?3brePAvUuYScs8EB6ffmp9f/8f3CBeuWn9S3XzQo6xYuqjUaiEMV5rjkm+8n?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XgC7CdBMPn/3VtvgRQkKq4OZdCEKf2KoU3o9s6F79IENvHUizY/+p+bIROpSUkfv7JBjPvbDlnNHW+r3iT9z5f8bmCx1hCclzFBnn3QRspYS4ilgBzV0pyBswg0yrHsIcQk4uehhkzYzjz2DQy7osV5Zo7zp7IXvWI47RUcvhMUVoAouAoy2Sp/G7c2zcG5jojOgE+q6WOdjBvq5Tq8RcwNYzCr25MFRZbCCX07zhbb7ZIwG6mvNFTPUI45ozWH6hm7thpJNkJoC77Fj0USxXAQb7bM2pXGWVpBKUpDFzIVHj9pkDal2f8OGTdw8dZmxDQWnwAE6OKinVi3cmP/1b/siZ+UdHfjwHR3BeMcx/0Z1wbgKCzQGu1FLoHS4wTZ8aeaZmc3LSecDAep6kyH6LFksGovYyOnsgpqKcOR1ZP1uXrQYvp66mq02HhYmNsWVKiMD07/aTexsPksNq8eoRF979+ofm+T5XD8MRiapbf9yKAevn2+Utg5IOQ/SrkM3sVyNf0sW5REWbdpZSSIOJ3RNBp+YGo2wh5uRiJYsMWdxHA9IuUQl9tC/8c4VUT+qx4zwDeBF5dofJBj8lVLonz1YLmr7140Rk+g9sochatg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b336e1de-ff1d-483a-2b90-08de0fc4d576
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 10:38:40.7102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfTcsz7XaFAMhkNsLsi3YNY1eaNLuiQnm366N6fmK0MGPaSKe8ceXUqPveUxNKkNdQkrRP8xwotFWnLaLpblpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX9PYK0x7V54p/
 0MXaq8TdjCaWG/SuDsjpn6pRA+wCnepMQ4o8t70JZ9CQ6/Rp/9NeEoPTqOiVRjDcpOHeB9pvEfR
 658Qca4OG7UnnLxgBQW6I0iRi8/eGiHQc9DHpZSe0s6qOFsBCwkEtmimruAKvvZRiOMrMfZHSLe
 tU5irDB8DVuRKNGZIOHu5pEur8MzVuUHs2O3w74U0AxGanGAvwYH+qbRz4shbySdXKlUGolcIpp
 ma5/F27wzf+9ftSkrLaJScBdL4hGCCsUVbeSfV0VWTHam9NrM6AfcxWMp14vDcSNXN9atCDE+Ao
 4A4fvDQBu2O1hRNr9uqwD+76r+GSrZ5yzDTrvjCprnAUyw4oeiKD/7AENy9p6MfpLtYh6Ge+/f9
 TLzCcTfeCDejPNAcQRdYX92JQNXv0Q==
X-Proofpoint-GUID: mWWO_c7mKOTZWdsSIG0bzNy28P9wK910
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f61137 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=zDhUAMABgqaCYlsd0_oA:9
X-Proofpoint-ORIG-GUID: mWWO_c7mKOTZWdsSIG0bzNy28P9wK910

From: Mike Christie <michael.christie@oracle.com>

This has target_core_iblock use the LIO helper function to translate its
block_device atomic settings to LIO settings. If we then get a write
that LIO has indicated is atomic via the SCF_ATOMIC flag, we use the
REQ_ATOMIC flag to tell the block layer to perform an atomic write.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_iblock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 281612b9830f8..8ec7b534ad760 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -152,6 +152,8 @@ static int iblock_configure_device(struct se_device *dev)
 	if (bdev_nonrot(bd))
 		dev->dev_attrib.is_nonrot = 1;
 
+	target_configure_write_atomic_from_bdev(&dev->dev_attrib, bd);
+
 	bi = bdev_get_integrity(bd);
 	if (!bi)
 		return 0;
@@ -773,6 +775,9 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			else if (!bdev_write_cache(ib_dev->ibd_bd))
 				opf |= REQ_FUA;
 		}
+
+		if (cmd->se_cmd_flags & SCF_ATOMIC)
+			opf |= REQ_ATOMIC;
 	} else {
 		opf = REQ_OP_READ;
 		miter_dir = SG_MITER_FROM_SG;
-- 
2.43.5

