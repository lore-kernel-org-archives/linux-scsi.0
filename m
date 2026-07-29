Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAFC4F5E0;
	Wed, 29 Jul 2026 01:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785289213; cv=fail; b=pGvjNLPJ0udpmR1W0VZVgXtkLBCIOCRO2gD823YAueJJZ/qjj8oGTEeOIvyJi7BGhb7IxgXWIHY6lw4ESPq1fPUrGMiVQEwuIhGrsCM0CJb6ZuyK1D4M/Au9B8mTCXYZoIMbgOgW050PeDzGQ9fYnXfAAS6DVQ4YmF/hWQgnKfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785289213; c=relaxed/simple;
	bh=ArJzwdDKsEk3OBF9FJAtfWdDiPvLemjYSD05fcifx9s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JmHGCwUP9vJ6NG/8EfMd9QXPAOkW4ar/kT+nes7Kwr+2DP5BGASoSk+9qu1d1KAKxIlObwJnggborPEFu9bAqgkhqi9ZBhiZblVb+90ISBsHI5mYF9ouPI2fOJYwsJZJO1Kk3uhPRFIRaLBQW65LqKRY3N6XGQ0Xj+Ie+OGk/vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fvUZ7Bru; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MEnVU0Ir; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fvUZ7Bru";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MEnVU0Ir"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItXs01122251;
	Wed, 29 Jul 2026 01:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qbfcC6aaBWt2CDSkTM
	fcvWiTdnm5/q/yzMF4uM9wUW8=; b=fvUZ7Bru0eC3AR4kcYWcnM3PPHCHJxeO9r
	FJqDj+1/2S+O2gyxuHfsK+PMzi7KvDYQOE4nUattrCSc9ebbm7OOoYWTm4Ge46EA
	+pXkr42qmx9upVo8ZzgiAFi+8QlELyKHggnhbmRqW+2shK5rs5KINZ5tlIo2/iNe
	bjWh412OPDJ5C4H/kgtdwOLz4rNuhu0O88qI3XfK4hdUIAECGU7X4mYMFx8EnVNT
	ctvszqjdVkUlmvY9JayiC96/j6kzuLN4/O8/bO9YqUzi5T4l6XcBwKb5LvzjzGm2
	cbjSHQjFv8gI4netLqpP7OVw/zpJoMMh2Gy7dhuF2Y1PHSsEehXw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xw60a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 01:40:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T1dvjk010086;
	Wed, 29 Jul 2026 01:40:00 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013027.outbound.protection.outlook.com [40.93.196.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhek9r9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 01:40:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tThTQH8zIB2KX8fiARLlPAadFFVbIH0vjFyZqTBC8Yait6mrHodtCmil/qhigvfz3f4SBJR49nOQdfyrxQJsCFuNfvpNKl104Xu5yTLV85dikutKFRB3XAjALXtVzo2ffdptkIxkhOqpk/z5KvZ0gwhAEPPWsVBJmng2Cmh20BGtMrrPNalTMliU5AcP154FtmySREcK6asR+QJQsPBsySKowK8+Rjpy1loOIrnfnQzmthHJI25MzahvBtkguLi3OfRt9FNJUCmRn+Hcg7FWJYwOK3TG1UADftF4PQlAx+BozOdI7ZxWP5jExq8251O4fhyxAyFYE9Rt74o9tHPPMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbfcC6aaBWt2CDSkTMfcvWiTdnm5/q/yzMF4uM9wUW8=;
 b=rTFGAH1/8x/e9KCtwEzLYhjOgByA+gN4sAcq5ALw4A+nHoSy+Va1ui2zdODf+0tynbXOUN/Jrpv200Qvi3tl22JUa7GD3OQPOdKjcPUCIcNdk6maZlkscSVwSSz/y7aqW2QSYP1JJ0g2b5/7SrIWTO0LcBh0T6OrjkV2uWJi5SqPre4MKThKl2zN2MPayDkmubboLQ9dXoD0Yk5E5FgkfiU3+55/w48cHaXvHvcjdIPEIASMItKJylw54R0Snf2eDcTWWuvcA6hczo7mzAqJ7W2OqOep0Mgn14jnVzCuKaOZ79EF8+mLvkGXwaTMOZbsd5UZirlb2MQ2yYG6a1HaHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbfcC6aaBWt2CDSkTMfcvWiTdnm5/q/yzMF4uM9wUW8=;
 b=MEnVU0IrdqPsNVc0J4v8VAYHosqix5fMRBArQVS7cyRNZLQXWPvj9AhNAQDtOUFOZ0idAf0xcadLuASHv9JCl7GPYbrbW8+ETI02+CLu1JX48qf9NorRTZDpnlPmAnemIefl1UOAt/Ii0O4ZH1qhIFt7P2ogJJMjNrZxCDEJfHM=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 LV8PR10MB7798.namprd10.prod.outlook.com (2603:10b6:408:1f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 01:39:28 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%4]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 01:39:28 +0000
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manivannan
 Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche
 <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
 <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Kumar Dwivedi
 <ram.dwivedi@oss.qualcomm.com>,
        Anjana Hari
 <anjana.hari@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: dt-bindings: Add missing mcq reg for
 qcom,sa8255p-ufshc
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <amhxT25_uwzYGr95@QCOM-aGQu4IUr3Y> (Shawn Guo's message of "Tue,
	28 Jul 2026 17:07:27 +0800")
Message-ID: <yq18q6uy3vg.fsf@ca-mkp.ca.oracle.com>
References: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>
	<amhxT25_uwzYGr95@QCOM-aGQu4IUr3Y>
Date: Tue, 28 Jul 2026 21:39:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0208.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::31) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|LV8PR10MB7798:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a817f95-b19e-4c1e-f20e-08deed123aa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LHG7shzKdMyIfElAEe6RgJMRBsPKXr+wfHXUChHePkg5tjs4yB6Lc9wMoynmvnEDVRaVL1+0fkOsEwDDNwxFm+MXgqjenG3DB/TqMt1NECVHy6/yDz4rh4Hm9tDTcSe93lk+Z8cmTp9LUYdpQ9PfoSKOLiNuyZJOKYMlPWrY6UYTcdZnpk4wfbbWFxmC71yNk5mcZOs1hZpwnV3fUFHlKxO8yQPHnvk/qrCSJSdjQMOm0og/yvVWM9O+RPAuk7Dsy5aBlr03O8A3gr2yT9wxC6sDUbTKMXe1JPfRqpJduo1G9EvcoEfP8rb8AOTwJbVQJObBXOeYMFMULiFbhU0HU4Pa7w8bCCjx7HBrlut49rzNCHkGEdiVboOToKcmkbAiVp4Ab0LxFiV8aYbYrGheyW4erQHXkfaaeHabGAAXdTMik5VgjjaUCYbK7hSfKp7jHtMg4I9q/NB023RlnCyBmG02El3LD/bIoD0Ax2vzZEo4bJpL1LxT7CGyBOzTRQb1odP1/cP0xUMqQ6pInQfcLYVovZYXZh+eKUkGm0iW84OT0XU+BBNSkjvZCTWaIWgDvM6fg8jZM119apDZ4IXoq9LywTo6NaxtE33sHSnnk/0id7Wl8SZV7RwWnu13Q7OEMRTVM7189OzZ8pkdpkSqa3JXlhTayg09zmjBDi1B6yg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5UgOhPvtbzAp76DCVl8ceE32PfUFOjXE5mgjcR+5akDu66M2YUROJl6ycqIP?=
 =?us-ascii?Q?jmuvx3thybqzR3Ygw9eUy87r1bdQtiHedeEho+mgejOTJ2VfYpTRzXiA446r?=
 =?us-ascii?Q?R3mg11XsF65bjhvLAXQNj3wMnQnMhzY5/0MDtdi9xRoaDY+dLL+Vy0U0YRlD?=
 =?us-ascii?Q?015eAijfcVsmba1tH/U7QO2lVI+AA+MZYOL7OJkeivTnwjnT4MR8gTgKP6/A?=
 =?us-ascii?Q?8qfskTq0Zw63EuxBMZQmbVdc+ly+jgVzwa0KiWE9Q6LEQTlpUw9b4wIgPl+2?=
 =?us-ascii?Q?RLvcNMAR+sE0ceW3HpjMi4X0tOKSWiAeV6b/lzNNNObUrZqlqYfAdRlt8A2S?=
 =?us-ascii?Q?YYdSjvVrmrb1rr1/5j40ICjB9qNhSfY4RzJEA0rLCI6ITEn9i3GjFlNzH2Nj?=
 =?us-ascii?Q?ej5ljyscwkQJqJwDjjQ0aGSkPzzo9LBD8IWPBOIRM3WG5ZhzK9PRT7APHL1T?=
 =?us-ascii?Q?Z+Iefh7OamMqLdabgH0NWYfZEW88tLa4DE0FxSuCABTj8BvGBZez8hEvHTUI?=
 =?us-ascii?Q?zzrhvlxa+ggot0Iq/7te6rZ/wxsJYyAguVIAjEEZ0XNuC9KonpUQHIANBwIr?=
 =?us-ascii?Q?0hrS+vw64qKPZBEEgIHtBzLSRC57HiMzcWayfyFjtO29Zo3n6Xa5VKRpB3+w?=
 =?us-ascii?Q?CWIy47649XVJ/jlQw50CHfjfVOXFrYKjPf4iv3Q9hh9wvCAuAX1EN3gXbjmV?=
 =?us-ascii?Q?AVs8KkOhS1cQENNke1WlAt/B156jjOcagtyO8cdXnKnwUkYxNvN2Yqf+k8zg?=
 =?us-ascii?Q?VXDC4laLVrut0toD18IxsKdl+guijOygb45JYMF00wgGMmIqK9mUquQw3cTM?=
 =?us-ascii?Q?sWX7kwWM4b46xj7/VorFr6NDIyWEc/MXgKu6GLh2G6wWq2/h6Eq32Aru7PpY?=
 =?us-ascii?Q?I05xtVG4D44WPcARRnoF8N72L7ZW5wQfq3JiS36U1vJJX4agtn6hwuoyf/c+?=
 =?us-ascii?Q?Z9mS0LaMldAfMzh6synqckdgpLiWijxwTN1K77U12LWHnE+Wl71nvvxIoqhi?=
 =?us-ascii?Q?D6gRxY17XPjXhey52Qsr5l7UL3XijuMCr4mWe0rCnHH9a0bvvGfUocSpBrN9?=
 =?us-ascii?Q?9HKSqt6M+GGe9h5zL2FN6Bpkp8hki6+ULHB8iVkBiHOXKUwud9K/U+Tspxz9?=
 =?us-ascii?Q?KS7L5vI6y6MVvN+ZqLZ9w/YPyZgfe25+DkNyfuQrk80GjweVP4rMwYVt++1B?=
 =?us-ascii?Q?zckmItx5/tE8XCDy3mj2CWnXtBHz8sNjuyu1+xkBwv4Z8UsK09TLkUdakz8m?=
 =?us-ascii?Q?w6+ZN8dD0h6SFPuA2AqT5Kn7FXHdc6lC9HPiwMMIr4LgImUb3G7ETxNQ35rN?=
 =?us-ascii?Q?6JpYm3calh7DvktfrwhTADhQnCamcDSkLm/PWyf9ZdOrvKyUg6hZxdrqrT18?=
 =?us-ascii?Q?CkjF73wt4JrfnlrWMg/gXA/q1O5CegQbxIekY01DyfABybBsQ6vGk790N7jH?=
 =?us-ascii?Q?dn8tV8E6WT1XcdPtguba2826KyXheV6/SMq/AvM4FnjnoiSLruUi8l21W97g?=
 =?us-ascii?Q?7IKEI3CpyA99PHrkOBYWHVjUU1COegDz6HaQeduPWXjunZkJ3RoPh4Ts2+17?=
 =?us-ascii?Q?Bxlaj+OOxNCl6UPvJVhnP+vVV6v9CfDefN415d6168Cqo+amu7VjAY+zh9ln?=
 =?us-ascii?Q?j+zyehSf1V0093R9LHxRik6kBlM2o9YnRgmmCDepIt1aRNLhXPJFl1EuP7AG?=
 =?us-ascii?Q?VTLGsPbTgwe7JjZcvolYO8+p2Woa+KjX/nIF3QVe82TPzl+ygTKOq7Sujyhj?=
 =?us-ascii?Q?4ulBrqOw0vdQGnvvVpmbDbw7SMrk31g=3D?=
X-Exchange-RoutingPolicyChecked:
	hT1VBsuavNVI5sgZ0KwIkF7eTi1dFo62L+1xD+7Scdrm+XGyCjtW5YnfDT+P0ZVCwopJG61n7OtsaKYr/NeBDDRueFtnrVR6sLKjsbmovugnggu3vlWM4dpj/10ZthBkZ3G4XqgpAoZ3S5np4ycVZj1oZ0fr37p35NjKcCilM5/sp6oM0blzREIh8iQDyN2D5tw10giihjhIg/USKsY1jbQ82PXOPCQBA+k4bFzbieNkjHHTGBxGSCyLlzJkUU7ZE3LhSDpeCv2fvA3+h/NPHzl52SH4BfP2uTBmxL22AzOFjiLGQiDmtEe2y5ArGWJ3zOINubLAC3QkGMBe4a3WNQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/zqIdmDsZpjv0RAL9csHnDPNkp2vXpflOeglit09MrKXZAHBdvhEqt9qrhpQIV8grg8uFMKARENHm50RvW29xWspop3p/8qxdvmdwLEv6uFXDEoaMLjeoaB8YiDXb5PR0k/CrA44vL/vRD0I0Tb4mmkKaAJ+hYLq+G2naddxF1NHhXZXC/ZG94vAQhijh1XJXkjoRWyOgKxJQeQ8+ZMrMtritAEjlacsxOzlXrYevRDEvn4lx6v2BXgwNJpD4Ud2W4x3JIUrDExoadF1+5bg77oBg6SeURWBD2oBeAqCzoxROojuTf20NJrsBHendadT+xr0USGsJb6X9SzgKmRfoQCRAh0RNmrMK2mHQyJhzYFzbZZ2YJ+HKNK760pRGJdtyCTPY8RwWtx5Y8Ztp4JwEE2htzldmgkec1d6jFDE5uYWvxCfTVAtXfEDGYCOptESzsPu4f5uP/riL9fYhVZxFg/SRquncAy724rtcIMlZfgzfN5bcIbTgygSkSg+FImEFOaSxKEqLQIzKi+nYIu89lJENY2j0+GCmIpgatFhMWA73Et2uGVIhIEf3M0AgLVmF3cMvdItkrSoUtsCSPe4BXhtNeXns8U+ULSMPGzSMro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a817f95-b19e-4c1e-f20e-08deed123aa7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 01:39:28.3754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: clei0mVDUcTWCP+CKGWW2gYh1fUtCkppb3GhIMUEet5WnWhqUdYRZU+QlOoy+MKW9o7lIBzPHYyZW+aCN8p73JVuI2F5w/GYzQcPsZNPsnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=760
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290011
X-Proofpoint-ORIG-GUID: x-PeHncB8jVLP8pm3vYmKPeJt4nEnnL7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxMCBTYWx0ZWRfX/1wq7ptgdMEZ
 QM3DghR140eDcwBRN3Zhai5s/HSFzoRdjByT1jF7idMCZNzliQm3WUQOxq0kRgbi0p74XfWcVpQ
 tkW6PqRQ/3zDURfpi7eK9hOh+Kc/pS8D4TzGLzI4DkDf94ecYKYElT8wQ8euX8qP+jk5k//RK6o
 wUXVtTur9shpH2HX8it+VkTlH1cCuC2xvRkflTE2DLaOzsxc5Vb/SVKxPvaP21M+2daTZSiRGMf
 zL73hBCdu25TYVSUUTSDX/H2IqziSIeJ0JiJfons0XZowMz+OQVJPH0XbikGUTBnPYeTcW7JCZF
 7fsy9XGZ/WfJgzN+ID1aj2PnX95SXovnJ+hyM0cicMxQE0m0HufHUZqQ/f+WVOKzZ85jEfcfo8f
 unFdf4WAVcORW0TsBgF/AYCu8dhPOXNDkIZi6E9qnQYf3Z2jHSilJDohCux9ORydzTcdojHmgpI
 XD+sAaqrOWHF36YCXRw==
X-Proofpoint-GUID: x-PeHncB8jVLP8pm3vYmKPeJt4nEnnL7
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a6959f1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=2Pg8bzTh1uANNiGIuD4A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxMCBTYWx0ZWRfX6W4iGiF4NQ3w
 faAg6puFQRpCniE9xAGAw/sZaYAsw/ik+z4qUqIBuLiLOTQshHrJW/qNP7m7cDDy8lPLkS6rgWJ
 hAj+GaOaV3bhrotzuyoBUrj29Q1VhDpwVbepEEdToyX7a0l5Te0p


Shawn,

> I don't mean to rush you. But I do wonder whether you are fine to
> accept it as a fix for 7.2 release. Thank you!

It's been in my fixes branch for a few days, I've just been unable to
push my tree while away. It'll go out shortly.

-- 
Martin K. Petersen
