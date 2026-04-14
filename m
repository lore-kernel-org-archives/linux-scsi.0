Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE83B469D;
	Tue, 14 Apr 2026 02:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776134197; cv=fail; b=XGQp4gkJd+n9yCuM6Bmxg37sCDlbRKXhjzkgR6/rG3B6ldzdig8Xe9N2aXBADkjtDEEfq9zE7LrRRBMCqIsZcqEVihXMHIvLJkEZAtN3sijVxuPVgBvEKR9Auv+Mn1m8I4jaUqi1rIE9q26++avy/DDC+2ZX+xTCOFyyg18S2xQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776134197; c=relaxed/simple;
	bh=cmqN3B0oNi2noUBIUUuiuUXuBu6N6FCziKFQagA6PWA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ERBJlG+Xi+2GYB5mJgR0q4ZK8sOxRu9UCwqmQp+cpfo8aePm6vtNE+J3tgeEMC7z4+TahwaAXEtM0EG97x+7stZFVId79m/XziLzVw53A3AF2TffpoRosWXL/wu/qOCm7zWJxTff3oqUiOyzUQLH0kLYBTefwdvS0HNY5HYeDv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NJZtdQKV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tvyIDy/r; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NJZtdQKV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tvyIDy/r"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63E1SaVd1674022;
	Tue, 14 Apr 2026 02:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=o1cTwhL7mI8Nu3QiHe
	jMbxixsuRwGKqo6Zog2vpusgo=; b=NJZtdQKVL27QcswbDo8EdWSpJc9HLcFzzl
	QSZhn3qI5inCN3UI18lLSjk8Fpv32A0bj/TlJRETse5jPLqbiisK81DuHvqXevGB
	IFPS+cxiOanzhJQemfrz/RCETiABnD4vtmSTEf6pc8MXxa73UEsEM73fIG/JYKJ8
	RpMWA1nWVODEOwohzHc5OrabQ4dn18t8/smfGOvJIy4ryL9wTmsX4TKriFbv2a/T
	AP6dqoSKmLaETYgD8nh6y7Lo6GncjtlrjENz4C+pb6Q2gTUKCWfa0cx3k9DcMK1y
	uzHjDJiNekOIQG1Mq+sskl7DaUBIUoEs1EgWJb5OjfwfwLqlwd6g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85jgbqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:36:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E2YPro036822;
	Tue, 14 Apr 2026 02:36:30 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nksbhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:36:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ohj50KopNf+AT8STjLevlSDS2i/B03/5wln1aIGg5lbTlkVLiRMkoLkiwi3h61aI8paoI55Z19dffNCpX0tPgTam0oSaRBpLaqjmpApzUmx+yaDeI88P4ImGf/sqS5ZYvey8o/vPs2T3rIfygX/NeJ8OBNu7G1UfkQTtaeIDcwr5/AUxalhbiApHlNjUCHnqd3CTi4MG3QB9IWEYWhUPhZMMVSCqtUbDgPgoWo5HA8aub2Vifn/Bqo4FqQCGIJdCGRSpce2Ho4iQYdGG8MlPNxmiSt7glKn2SJhlFHY53NTK6ScnGtyP6jEeJODTuqD6K49amQAFp5Znx/J9fYSSmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1cTwhL7mI8Nu3QiHejMbxixsuRwGKqo6Zog2vpusgo=;
 b=sjVi/5I/BdNhjoITGiUltKSBo7OusnJ64qcm1Tzadpwxe2hOiJmFytyf1gVjdxS3LuTsXrhN1t7vWOiPOQ1hVh32jV5gsAhZNb+GwdJtRah7iLKEk7IOzi421SrM1FruA8/i5rDOxNtlUGfQKEq/8JUe/0uB3ZJPu9xtkw0IO5bA2WRppC9T8ojbYbuSOTb0Ah4fkcQkL6BG0+FS7BBWMBaFr8nRe0fjxCtpLZPTkeTXOLZ2IKRMa+XIY1DIKkfhJk5QD5bdABRvKednHcj2vABRTIAsxZqeqY/tDTvanwz1OU7/cTIo134Tw5WGjyBf7SBq+tZwCmEijHAEu6Wz8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1cTwhL7mI8Nu3QiHejMbxixsuRwGKqo6Zog2vpusgo=;
 b=tvyIDy/r9Vgjx57elgtiYfoIb+DuM6TjT4W81AXmKpodEg6BpvrMZTr8LZTCYcVv+T4y+FAW0dc4IdRkw25peZ7vn0+bx5fkzQ5ztVKCf8TYdksk4HH3ijvOO81I20EkbLMD1ClHdrpsWBg1xpW2jF7oMf6sNYOe8b3vrAqw30A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 02:36:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 02:36:27 +0000
To: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>, carlos.bilbao@kernel.org,
        bilbao@vt.edu, martin.petersen@oracle.com, kees@kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: iscsi: reject invalid size Extended
 CDB AHS
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <0657bd66-43df-43b0-97d0-16288595e229@gmail.com> (Carlos Bilbao's
	message of "Thu, 9 Apr 2026 19:49:01 -0700")
Organization: Oracle Corporation
Message-ID: <yq1cy02tgum.fsf@ca-mkp.ca.oracle.com>
References: <20260404014429.115807-1-carlos.bilbao@kernel.org>
	<20260409024253.34926-1-carlos.bilbao@kernel.org>
	<20260409093159.GA902@yadro.com>
	<0657bd66-43df-43b0-97d0-16288595e229@gmail.com>
Date: Mon, 13 Apr 2026 22:36:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0010.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB4821:EE_
X-MS-Office365-Filtering-Correlation-Id: f37eb638-951c-4dcb-e8f0-08de99cea107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LPK/cVqWMMLOdX6zPrDAzsjb6w52UdhoT17y3ec+S+dW9C76hdAiYk3SJc/gbe5sdUZP4lhd2ziVn8PPbTTIN5R63DhxScialBVw/SoU67xQyjjhwk3fQbOqxnvtbnlECm5u6dnn+BwvepU6c8e0aDojIb5SxoYJHrTGZ68OK1Oc1VbXr7OoXd9lTrc0PRdTH9wPIiEzI7sHxAJMoqsuPuSZ2oj4O38dK4cy6Wx2L6t68XOTAvp71++fx/OHCfORpQDyoCaJYou7x/5u1gf02nHnn1n3v1eIRYBO5AflFGQJcq2uHff0hrS8z7uwjmhGcs5GFnPB6UoWaLdF2rHBiEXhjxEbZYqvD0N9KB7z2GHo7uIVkT3zVmNCEHohj3CE/18i6b80TP6XgU4/X+ky/rVVPKrIYG0koY3RY9y1m320moshx3tOBjWEjP9J3y5MH4T/UfhDUKsjpLiEGQso8wXZcroVIdt5QNXbcp8IFU0z/rdvqfRRvKijkstD40J0xj/fWQ55xn6jQsISS3EGmfktcS3sJbPFfpB6JKhlr3B4Hl+FfI2Y0IoqN6NRKP1+I1gShNt+UJc+t5sRLYpdZdNgTX9mqoRcPjRjvQMcuUZLbyObvKIwvTrFubDfKfzI3NcP2d5tbzkwx2iWSu4cFaO6LUu7yzCsroJDP9Qb5JSnRVFBtME1jkPi+vn6vT/sRIBIQKKcf9qM3e57pFyXPDs9pVLjsFiKAiAUL9URwp8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7k7XVtJMBu9IYaKWzaLS723buWE9z3iQfQ9rsec0leuicqnYac0MPYNVMILB?=
 =?us-ascii?Q?TCAhzWKYM3Vc+p3Mit8olpBzfr7v8/ir7kC+xVzTZn6FCUb6u95tZRBUWvhy?=
 =?us-ascii?Q?bpbvUTmpPJcpcep5zazjMq1t3wLdzDdswvDp9Z9bjAzKvnt+OCdoF5lNQfbn?=
 =?us-ascii?Q?/nWSx6QKjqI5VkWuHnUiyc0I/z+8xBXBl9BznPmUkPcHfxrNwWvWGSQ8qvbu?=
 =?us-ascii?Q?fR2yNaPnzgLi5dOm+H2OYGi8tR+jFI5ddTVkcSXS800/aRJaqyrcCOXHU46H?=
 =?us-ascii?Q?wkDnVo2vcefw3xlO2nuEn3YHy4vuNCH1f82v7Ga0iC7Xf/nye4JunEHmK/HP?=
 =?us-ascii?Q?F+DcAPZct/LFE6sZgWlj+qSf8hyK/yfMVhIqLvOtWfcXXVA1OrQH14EReBdT?=
 =?us-ascii?Q?6QBnyvhgjUUtGh0qgYRv1Mrz0ECpkCNs90uzvxez6nxid/rgtM/bojnGmJCe?=
 =?us-ascii?Q?MgYkvkUUlICBq2F6R5TnkrnHgvDI635R/IktrubX7WKPRuSaag1atrDHH81z?=
 =?us-ascii?Q?Utp4j4JxDrMhQvWEGg7S6et9aVrz3zyeHxf25mQoi7dlfnw3nWIKR43JaHwF?=
 =?us-ascii?Q?alOWjroLWJwWO1QTEp99ONw2RsDVEBun9Qyz2SE66irMD30CRGrzRZWkGtst?=
 =?us-ascii?Q?XNeQTjKz/VpzhX0hEnzfmpAPa4xZ034Z++GayezoYu80ba/rM5pBYq68AQ9h?=
 =?us-ascii?Q?zASkjV7y5ogLRJFUOKUogAuy/iWUKluZKxOMp5yDKP7HJsQkHfG/ngFjDlaQ?=
 =?us-ascii?Q?inrJb1hnAlVD6UYUuJuaHjneBnGhgeF8NKz39BrpCYHarkTdR5TNFMnad3lb?=
 =?us-ascii?Q?vJ4m7M9bVN/a8gGM/zm00tfUgBTHkA/eg1S/ERXiGbtEB9/+FI057PKQaEkx?=
 =?us-ascii?Q?MwrKgmvhn3GdEJsrdf+xH/J6SjhwQdyytbMmmqKb66vOIgdI6Tn6IZcNqBTZ?=
 =?us-ascii?Q?MxubO0OgmYdzYB6uGZWNHV0VrDC1xCjVHTITM+AFVS0OquBo4Zp7E4pYY2hS?=
 =?us-ascii?Q?T4qG1YTiCElBOpN5mrXdByzziGRhQ/XvcQfAmQJpxb218p7nasYQI9kR1HGy?=
 =?us-ascii?Q?y/yvodSCQ7XqqohSyDyDOQlsbU6Y9r0ex04zu4o79DNHnoN7qE71JyDU0HJP?=
 =?us-ascii?Q?cov7vGI33zYtndBF7n1Uok3yESfber5Uwxte2Zr6cH/Hh2xvsLkpaUXLg2Fg?=
 =?us-ascii?Q?46E6fv+AyS04u8XQz+8+5W5zonei98ocbAcXxtnQs8X7Qp1E5D9UwdKAqP0x?=
 =?us-ascii?Q?O7QIriYgagF8MBdIupyohM7tnU9LluI6lAko9lxxkewa/0Y1uzDWq1Pyxguc?=
 =?us-ascii?Q?9i4gLvWpV7qQxDZnCZmm/Vuybbv49SHORJb/0eTAtRSaa2r2/fMCoBYaWKYi?=
 =?us-ascii?Q?sFAIWyx4rW0IOyj3j3Vth4x6FFM0ikl0Treu1bcENAKG5tvCd/gpXbPifr1/?=
 =?us-ascii?Q?JYIkMrR10ZPl3ojZelBRV8nUneQUcP7jAxef+Izn/W9NoD9jNjuTG50T01V1?=
 =?us-ascii?Q?9PiJqVyqCmimOXl0X2+lKvmo+bK4Gxk3iyTqwXZg86Hv3SWj0nmIC3Pu/fhg?=
 =?us-ascii?Q?TGCRuq03+g4KNY7i0TdeurHktGUhfCJtsLAFQA1p9ng4hkrE3QRpqH9h5qgv?=
 =?us-ascii?Q?KnYaAI1IdAPMWvwH1blu2n6QS0IAzHw5EPWROWfedd3WEkhJnDWVve5sEG55?=
 =?us-ascii?Q?bg3Ujjs/SkWywhSIv/ftA/ArtmEQqbxXsNA3QFyzsk/12/bOZYkXLuek6rrr?=
 =?us-ascii?Q?wgrXuxDmoYHkNPHKRrhvxyYMXBaIUpc=3D?=
X-Exchange-RoutingPolicyChecked:
	iyzN4zIM2ASgEr9NRScJIdZGAOKwEcYKfkzzoI0ETgNksvxW3OeTOxtNLhnSxxzRvdUJ80EfgXcbhRXyg8a3oMVda0jAnlZM81La/zcul5BiKLeF+HV+2vBMqGFnCUlW6wD6b5WirMd2UCHFKvypbSH8Q9UVqM6M1Le0hHPRTnoQ9V7ePUdeGybnDkRV4KOhsJXsXItEH/3rQCmWQZdKVeFfpSK4075SVGQ1akJzZK5iSU/mYJIaY+nShkMostdTuXWp0Rx6lH13wgOvliE3kJJ+TNtCSj8WxfZO8PaDVGCGiwwUlYB2DHSjZLjNYI5VFaetiB/mu9n5Rdzn7TLbBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZDZkyiHJiVrqlRgewGNRy4OyCb0JjzL4iulrDhNW1WFeeXz1djn3lSua7RkaZQiM8fdnBEHWtBxR17uIJ3qBWMtK356Agf3blmo4XlNpaEe9NQi8akogmmJxpbwBB080g/QL75ObOJyAc8689mfC9V4WoGhv8yXG/5pq0PmI6yoSIivR4voJMSc1MwtE1F63457+SGDQ46i3kVba6ajEiBLY9WJ/w/fyg19OnPdy1DcFnXTJF2VS9FyeOljoBT4Gch+TJA4wcbRZ2HafkpVHUeVYFyBezk3zRB9F/Q+5tt+OxoXAsz3nLvig5XZMc3xyin5g8aUgN/bsh4XiWsk/Mc6VWbkZ819vJRG30Hp/K2iv9yqKgh7Lb44/DPgN3xToeSAZr5X3Zx1jYMqc0XpmO8b0WP1uwYUWBb59Zyd3k3XIXjerVQ6TSHIkxttHTYqU0ifNKpig6IjJmRPSrw7ymalXze00e+vzz1Iqt8vFknwBoBIOnGuf9aE9smuv97FgOplcRGQnkt9Idc+65N08FzknTpewrzFNOclab0G4Vz3PiTZ+UQ2+Vpxw6zpkOcQ+Kf8v1/NJzWulef0/CjReN+TbDp6rwDaYiUoUGYG0REA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37eb638-951c-4dcb-e8f0-08de99cea107
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 02:36:27.8384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLFwuCxku182BRuheJX7LX7uLXi6QipUKjQkGNUvpVJE7m8RqV7IQTVsuDkH5a5wziL37Jb+xGE3YugJxZfKkB63lv5KNHUMg8yEBCtAiKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=558 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604140022
X-Proofpoint-ORIG-GUID: TDM3BiI6VPI6pfEEEcn_wtekX_Jh1-X9
X-Proofpoint-GUID: TDM3BiI6VPI6pfEEEcn_wtekX_Jh1-X9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAyMiBTYWx0ZWRfX+rNH+9snCV56
 z+9pLXbnIu4pjJBlt62fKfN1ftcddmXROdNiAyqNafXYGsipr4RoPtTrDPCu/ZxwKZHtSd6KrHU
 UixzsMWIqciqq5T+HrGN5XXgGqGlLxrXgpW92wgRP6v3odiJErDbMUDiDcknIQL3XRMhSS6O8o1
 ts3lIOqNTmK0R20yVV0/hPkhnKBHsPmtF2egLidO4QYZA7Vd0A2iI1n9Ipyx+k1Q82PEJgI6H5X
 paHMGib+v9a0HcvNuDBHjR1jtKY/399+THWtqPZESOlbyNhRuDOaz+EfCj78W1qiEcvvK1wU11b
 rqYspOFmNzYKFeRa6sAXFnZh15/ck/6MNNLmSKCMzVbm+BAMsdps3TfOl4igEni/PmklAULyjBI
 keKczlJIqZeZ1RGMfyfzpfq5S4SxCiloK0OEAs5rcSZm8WBsWYAVTbviL0I9eUpIIID7OSsGQVp
 z7BA6RAMF+rWqx6RgU4RCYbBMv+9iS2D1HUCRU2Y=
X-Authority-Analysis: v=2.4 cv=Co+PtH4D c=1 sm=1 tr=0 ts=69dda82f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=Nh5GQaGglCHso3iG0c8A:9 cc=ntf awl=host:12291


Carlos,

>>> +               u16 cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
>> AFAIK, a variable declarationis allowed to be in the beginning of code block only.
>
> You're absolutely right, happy to send v3 if the maintainer prefers.

Yes, please. Best to stay consistent with the existing coding style in a
given file.

-- 
Martin K. Petersen
