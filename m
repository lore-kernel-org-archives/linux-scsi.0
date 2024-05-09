Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A62C184;
	Thu,  9 May 2024 01:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218936; cv=fail; b=Nq/9b4Soay8D1vmYPm2QL0rf0AHYdBrCiKKYg6EZIUMLg4Rov2y8jqpUqNbtesmrgNMLaeNipxeBKVFt9CAbYFUvnIzo0WrWz5EWi+zcjl7oVv7x1qlOOvB0R8D3q3hBsvV5kQDR5M2OQCiO4XTVSpqdPFmAXBcYBP6GYy+IOos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218936; c=relaxed/simple;
	bh=q3kR4uL6zL50SdSmCPmB7wC3y6crMpRjjY+CFzHU73k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=p107tzYrIZwd2VZ2LEJTTBfxNWCGWCVbXL3yh3yARL0zXHEViB157n7jpJTuN0CLQLRTbdUrtJwtXG/60Wpt0b4kOfUpNdUDigvF1SObj1O5yG4B8UPU2T/0VT8RoJCGYwuJoeoOBRRfYox+sLOS1xnlmsLhuYA13imxhLepWsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Eke43LxP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rWrgDayO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Eke43LxP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rWrgDayO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44916htc003182;
	Thu, 9 May 2024 01:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=JWzklMINp+heb/V/zdy2gkLchdYaSyrehrIRWju51Fc=;
 b=Eke43LxP/5Fekpz80CaGwZjT2+1VcIbOwnxzt1+08gOPfKpywTECyAchYeUgRwfS5u5O
 OMke3L4nbCzPVl9eviWJSE7XtVIMkScxGmarANa+SsfLbTa9iGvEeH3z1+5DxTihZG7D
 MCS0LZ8mdOVJC5PuZgfptkyyhM1W//ZL71Kb47a7LEDVzal3H0mAsjYNXCWZGKQ8ysJd
 CxZ3C2xDyaXq3KZLVs56ckpCj905kVytWNIyE4uze5buX5MoCMduX/RxvGozYF+iDZRA
 oh4pWQ5pGii4PgOZtpEoeaZnSjM3l4NFRqxYaAJRCsNs7KUTYju8niYKH12lQhNXXEJb lg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y0mhg00y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 01:42:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44902mFX020216;
	Thu, 9 May 2024 01:38:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfmupwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 01:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/hloBkXH8uO5WwyYSeJAMfvI3jor1LCTKeBraMW87rKNZQdrt7qi9wfaiBidi0+kNcFr3I5GMPEZ+aIZK9QOfORMu54eH4YxXsMEggyKR8wwIphUXnXwi6wQb40fYbyZ26npx+8gDS0lqrUoBESBsfoazT7xIk/5H0n/QrjFTBc0XTLYByhUz0p6bJEZhbHPnyJBOhV7a/+kGDQ5ewzT5wHiklIbaddvTI+wY4BtB4hp6VgPl7iqPQU8GUt6JDGo9lR+jeLBCEAvz71T68+T8qaT0ZR7NkDDsFh5t8dPMFbOrQ7MoPczhFIGbhnsMrwiUr4DxUX6Dko+oAXnTMLmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWzklMINp+heb/V/zdy2gkLchdYaSyrehrIRWju51Fc=;
 b=bWMf5xa4HoYhqZgK5fk0QJvjC5NJxXELMigcrDqIRsxh2Tj429Em/ezorszJUgnbOjfb+coAnnx2eqDksVAED1yIl+bDpY285Z2YmuOKq3HfMJEzqNTUEjcW1RMErg7XBDwZRJVZ1YMjuQ1r2WqwXKiv6r6V0PykYkHJcMpWWaDKdjuISNjgzRKVpwbCzAZUXEoD9zbEm3SZGEQtwur8JN/FNvT0lxx4uUgM/uz2RjV/HInNW49Xl7KmXHQtMDG8vhKtx7JJZTnqWguNv8Zn7zUdkbrDwkiw9IdVf0jDEBMMSADFYpb4A9iCTdlOvtaMdTBsNbem++MRBhlQHouLIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWzklMINp+heb/V/zdy2gkLchdYaSyrehrIRWju51Fc=;
 b=rWrgDayOYXRgXd13DsiwVMQPDej0Y0pBw68xZWzhHx0iUl3bg0KfT3lXdQkuFE3pR9G7uQ6ufU/G/LuV65LbHoI77gN8GAsGHd7q2OKxFsGQCYeNF1bCwfIiMDTg/wI4MZd3Znk0aYBjEBfg3AMtIxn6XFzfJUEvLDI17GmdIXY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA3PR10MB7042.namprd10.prod.outlook.com (2603:10b6:806:317::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Thu, 9 May
 2024 01:38:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 01:38:40 +0000
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: Kernel 6.8.4 regression: aacraid controller not initialized any
 more, system boot hangs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com> (Peter
	Schneider's message of "Mon, 6 May 2024 07:19:59 +0200")
Organization: Oracle Corporation
Message-ID: <yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
Date: Wed, 08 May 2024 21:38:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00016417.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:5) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA3PR10MB7042:EE_
X-MS-Office365-Filtering-Correlation-Id: 9530e936-3273-4cf3-8f39-08dc6fc8c0d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?BDxW2+5cq9kUaa1TMNm+GLNa/M5tkEyed2ViCE4VcLwgTVQVVQVTy/RZx3Bi?=
 =?us-ascii?Q?sF6I9BkxOWSmCAn077+vflu1mAtQpOZfBp39YhXnY8Hao6yoi4U2JFQYq7Ar?=
 =?us-ascii?Q?/+a0ay06WwzGB3rVchmU1c8F28ZIjVKR/mXeYZAfKmO9IPdzA5ZNFCASRpZd?=
 =?us-ascii?Q?rbSv1KzOKI/b0TIuXGrMQ5Ueq8ggQ27ggfkO6XmGPE+s4RrBpSLZE6Uzfq2f?=
 =?us-ascii?Q?sdOCuh6kQOiFljybnTpp96o95YaJOTYqiIV3/StK0MFcW3bfe8/4HK290VtL?=
 =?us-ascii?Q?Ic6WjaCXrj+rzxyPYb5HWzbFvWcLF/Yc01KfXl/l9EJFasz4RGwTBYpJy6It?=
 =?us-ascii?Q?vHNLxk1t35dLoRJYKiG32v1udIFET7nUcuspyB+MSB1n8V8fJdb7hhi9RM3a?=
 =?us-ascii?Q?ZKXj/oyCqoQGeqCZmNDQaBtvJxoCyjs4hW7LpeOmRf/FLmKNJ+IUeksX+rn8?=
 =?us-ascii?Q?0nO6PyGdUfFlYYaQi3etA3o9PFNfAoVDeeXHVm1G6KOyd8DS1QBIwCNRZCk6?=
 =?us-ascii?Q?AiA02p0RGkm4p82A5oJwA2zL21foZOWv/lQQs4bHAumW/deJwkIdzXREhH2h?=
 =?us-ascii?Q?/2+bg+f0tDgff5GLJ7ykzahWNqKezpvAgUL/3TNgTdkQDGTPIwMVs0tC4aUV?=
 =?us-ascii?Q?l/o/xx5l+UZWp2wS08XxqsW8xx1uqXoiGc3dCmoo8c2U1fVYk0E65j0i/i37?=
 =?us-ascii?Q?xEOWR4cwyWz3zSkc9jx4hVN9/DhQYEADsUQcOka0sAVrunyu0gYUYGDEn0qu?=
 =?us-ascii?Q?uy9Utw9ZLnjRKWM+JG7tiFRQsG/5N7UtQEYoa+CJ5wHBBlMSjxwuHc4V8LQB?=
 =?us-ascii?Q?i2eqCrAcwbCfWhsyCTSj+HJqj1b0NWEAAYqrXwBKLhBGFZ/2dqPyZtBpWfAC?=
 =?us-ascii?Q?xd5AKpuQM8ZnrGH9gFX1zjMKnD0BiANNxpWONTYW43VAtNfhKQ07RKd9vu2b?=
 =?us-ascii?Q?fQf2eho9H3t7g6047raQcUV4WwYW84dLboBvZKwk4H98pHVCIEY0I3RS+0m0?=
 =?us-ascii?Q?K+qJXrIA+FY0RmWcb6UxcZ5RLj9S/qFBD6T4vQ/mgNenbvBzwtJz0C/+RsNr?=
 =?us-ascii?Q?OFbiIM/E1QIJnAssAp4Q3W4x5LKiHdGSL8ZRs/PJ2GXsLH+a2ZKqQETTkTws?=
 =?us-ascii?Q?JqiqV3AazbaXSLDcQvxTjkJ683g1Pz5PzBZ7YfAIf8P7V/6SDza0YKs0cj0E?=
 =?us-ascii?Q?3dqZb3VnNPYBNtXzzDQDgAb1yszj9QfpGF+3GhEnqVigN2LkrLZBwAkngHc9?=
 =?us-ascii?Q?/8hrnjgXbSVsLIgHhOYHQKbNnlOVL6A0kQFLIkTmZQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?9p21H0HRha0y+eCwQTrLw5WOjMvW5CIQ2FHzrAAcd3nkXUBp0dSjqCTezlSu?=
 =?us-ascii?Q?f2ah/C9npkiXtj1eakS/EhtO6luQhyQMcxCS+H6d2moWKgqOiAAKQ4c4Jap9?=
 =?us-ascii?Q?50gRz6KeMEiy1RiHw1KHVVk9Sx14dk97/IwfgnNLV8807bApjDs81ozTj9Nk?=
 =?us-ascii?Q?H1R65fNj468NzXFz9kkq7rhMxVn/sjBEB8CEC+89a3u2QYiUpdFoGr/ozi9N?=
 =?us-ascii?Q?7RG1AcoSB+w2oBYlkc6lSztG6yAIBce7K0ap/F5GkPq+OS1mp8e09rV88J77?=
 =?us-ascii?Q?3NzWXCGRzzIEH/hJoY4FgXjS+9cEUPzM2mmTpheYtC4ewYjekRv/R8YVt2Wh?=
 =?us-ascii?Q?XVuN4vjHlWjBXxySeo+M98tGKUd7q/TTAX3ODLtc78ri1MrQrWUzTMbodakF?=
 =?us-ascii?Q?yfd15xAyvlgTP4rTAkk+pk7zX4oDhRd3Hz9kiAwDQFUGcaqyA/leCE6gFcbP?=
 =?us-ascii?Q?xbe0Y2HE+CS9QWari31vquZlnRiqACJ2wRoauCFzjDX/eaRXDmVhY2ymsFcj?=
 =?us-ascii?Q?dMM/8D/B4YDhKWfHcMpI43o1ArFw89J2sNpTlWC8RhJhw4rXupWBUlRZvMIE?=
 =?us-ascii?Q?hZJRBpLH4T3yR/NM7PZ9j0erNgilJFNtsT1RIBJXJdWEugH5UrAbfvYth1pU?=
 =?us-ascii?Q?8C42Jv5+NwtubNeNPriPxY+OkVDSNj0hdludQ9x1OJL0oGr8sxqagTFp+ix6?=
 =?us-ascii?Q?LHvCe5NG8Y9sfarzg5oDVlqlLdaSfn32ofh3JLkxKffH/7X2f922FOipYFrw?=
 =?us-ascii?Q?1hGzs6j2zwCg4X5si1OWivVmmUWhBQZLL8H16SUDR5INWrPjjaFMVq61AWhn?=
 =?us-ascii?Q?MZd0lWMAgyrd9GSnqc4rkLO/AaYN/ytCNo/g9xRgQe9CguRYVp91ve9QPkaE?=
 =?us-ascii?Q?EvbMQ+SWpn+i6QK61oh14S4iNAx75Xsxpv7JGZ0Je7cTBBTRE6CQEtvY8AeE?=
 =?us-ascii?Q?I8zNmH9McIUO5dWRWVdV18FGMTLi4HwkHuaNWEPVuGNnzrIzJh9mEZSdVSoO?=
 =?us-ascii?Q?W+jOWOhotPMLZiz6xBYBYyqmxhW1pr3DorOJeGgZPh76LquZ26VuJzIdhwrF?=
 =?us-ascii?Q?t0AO75kPp3OU+/V+n3EZ/JL0wxiK4V/QgA8ijpHRHqgYYCP0USjQBR+s2dIM?=
 =?us-ascii?Q?5dPMdirJNDDMIadze/L3BQHGQh7bf1HH86NC2zrp4SwA8o/+zbfAmGW2+rqd?=
 =?us-ascii?Q?W2AXZpS2eBZQZ8NbKSWDYiLwtPYoJxD0dYVDaLo+B0H1af62ju/ge0CI+t+Y?=
 =?us-ascii?Q?z+Of2fq6F+cw2rdPla9bL9N2wAFaQxcNyVViq+V6Jwj12I9JaAS1ZlBad39Z?=
 =?us-ascii?Q?Ot4BC8elnrzGptZptbpdlyaBYU7d/g4kULK/YILIrcqOtybLB5zbTkXPwXb4?=
 =?us-ascii?Q?JhOtH0woBjYrrnzBUFWzYc8gemWP4TM91Mc/gVkqldS7qgYSDjvswri7Z/kD?=
 =?us-ascii?Q?lErWuuNQ+7Rombb/wFCevMdcu0/2kygxaFgJewS4dUfto3t9M+wUHZT5XSBo?=
 =?us-ascii?Q?CYboWAWOo+OF8Nr55fuBWucnLB/hfxv0Tt8EESVTr+S2eYOM0B/VXNiNF1lu?=
 =?us-ascii?Q?7WeZ2gPuEQ0MQ6jIyR0De1OhOO0TSoi1rt7JOQHMsvC9MkUUPht/HBmK0Cao?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rApmkzTatK6xEumhWQjIwIUhpYow6dNYPQ5EHVO9mi6Njj/ZeYEv2uMUUCqS3T5kvaPSImhGibi+KU+gg4cto3wOy0uA3Es+oadC/KkWf3RZirjbFCcZC9H/ry32DW+KAPyeAmtQy1Bp2RkS41mB+zOYPSEXGdaiaAGhB7NlGPWOn6DJQOPoTNCAQrzlMkrbWS2dOZkb/ojnKhe4VbmoZHg5LgZVKVrx8cjR47L+Edzv1cLjWNHjSi7P2EqkVGo3vLno15fYhJSC2R2ZwA6DLycIWuFfZwBrXa6KPNdox2E5jGvcvUkkoIibwka/e+Y59bV+b/7qlrw0OeGez3a+I2/5DU0ntHXW3N3pweu9nHpa2ruuxS/T/x9eyckOh8Dydo3CxtP9wkFftlywjJJcfrkO4opnTGSwtrSuyFcCWT7TtXQ0tMFn+7TTq9Lw3E1H65Rcer8ja7XFIjtv+mGqLAcadzrFtaa4cJ7U9IiLWQIO6QtMc2QSWE3kF8/ijHF0dbPdF9w/DL6RiZLVRBdboRrurFo0jf7DvLDSp6FN8BHPAPZ7ku5n1EYMb3bf0v7IwEUal9ClQ3+7P2TA9rZ6jGxfruAvzAec6i0h5vCvBsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9530e936-3273-4cf3-8f39-08dc6fc8c0d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 01:38:39.9747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZnPSctludc5OGMSTtHPToij7iCBIJVTUMX212HFpmrFyXmMxqhqwrIp+ATy3T/XkjdLDsAg6dn6Jlsx/LLdR91N9uzygOO9igzsvH9a224=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_10,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxlogscore=782 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405090010
X-Proofpoint-GUID: ycLsiy3Bl7mboUxyBvhX2UqJshj_-sEn
X-Proofpoint-ORIG-GUID: ycLsiy3Bl7mboUxyBvhX2UqJshj_-sEn


Hi Peter!

Thanks for the detailed bug report.

> 6.8.8+          WORKS   Revert "scsi: core: Consult supported VPD page
> list prior to fetching page" - This reverts commit
> b5fc07a5fb56216a49e6c1d0b172d5464d99a89b (this is the first bad commit
> of my bisect session, see below, and a single patch as part of the
> above merged tag 'scsi-fixes')

The puzzling thing is that the patch in question restores the original
behavior in which we do not attempt to query any pages not explicitly
reported by the device.

Can you please send me the output of:

# sg_vpd -a /dev/sda
# sg_readcap -l /dev/sda

where sda is one of the aacraid volumes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
