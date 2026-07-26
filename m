Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0412B1DED63;
	Sun, 26 Jul 2026 18:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785090886; cv=fail; b=bOeH2sX0yaUzR1oTnuYi+gP2AL8nG6yOYEa8x9RKR1Y5wv0Dzng5ERWxjY8Q4mIHM23DDB8qnCOUl669FO3PjChmWEBs+gDwYwfPfqOI0yMyYwCwUOo7S+aGWjiAow6Jk20IQUfpqpsD+9GmnkrngemYQixDFGTJBiK4gPVh9zU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785090886; c=relaxed/simple;
	bh=mM59HsPDozwpkzBDB5gp8treW8feq8pRu1YcIhjxPk4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=iL3WCJYv00TlpK1V8SQtZjot/VLmSWQMYBUviVViXtU38loJEp9cFVfKAF0/wWpgOEzAkol588BZaeck2yJJ8T8gZZ09I/UqFssWj6paUTFODixslWSVcVJ795eI47DzKD2NdjTQoW88e1qh+cEV6tmoHJWYYqkpEfl1o+8aqdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OKDgbQPK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MIC5gFhx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OKDgbQPK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MIC5gFhx"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QGuEpF277344;
	Sun, 26 Jul 2026 18:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PK+ewEHhD9OrN8DLNx
	SUQ0YRwwZQ7fq1PjNc5wlxpk8=; b=OKDgbQPKtd9o5jQKetQWUGJsLEse0D7Ee1
	wkpgKb3NLr11TGcUdb51u80biUc1Za5ujpvRIvzoSWA3hOPDGRbfI5UJR0B/nSG4
	JB+k4NATZ+JTrju+aaXz9pRW9W/6mLCg8FAcHIZ/wLwzhhqHRA0Fsxevg1agXJfv
	+0warqQ4+jhc8qLGCca1cINF/T0gMXrhddFBUcTNoGzVlkGjuxSQPUlih+7QYpQk
	ITRLNRcWdt7ZwFcXlvXqXRFDhc17xtTXF+3ec/0nvgRoGwGPyJl3ckR54ofb63vl
	zKK1oQ1qh6czOjP8SGHStCob9GGj84b0DyA4tYUM3FbBbkWeDrXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pgx1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 18:34:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QIUSr5000425;
	Sun, 26 Jul 2026 18:34:32 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6mnjvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 18:34:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODXVd8O4ru/HSZFjHnZcHGnqlR/QYWRNg9W78Xds/Er0hLE9RHORXtLOVf1qJI2j2NWW3T0zE15dgXhRqHf4alP/SkNQUkd3ThZB9u4/obIpk/+NKJbswqliBno50jZWJ2hpQB+sHXV5f9bPzls9jQTa/b4TfeTPuYwJeMvRxFVkRFk3aX/NwYM87eQzuaJLdZ4NEObkagkydEPt7cAWWqSQq8xBBu7Nb8jduk4sIydjVaP57foMCGQZIJGTNjL0bCeSJjvW17p8F4r9TippJGnxOFNvQCXk86JvwV1Vuc4AkgRNm9ZOnO77x9sKY+dKD6v5XCEUlIa/lQqxyx891w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PK+ewEHhD9OrN8DLNxSUQ0YRwwZQ7fq1PjNc5wlxpk8=;
 b=mU2gmL+AXjn0ACyqp1swXTyt3I7l5+yvd7Ht0l6h4d+zmILMRpZt0yTU0o23DN1BJ1yAQJpPdePNsa+7O+zrI7waT3B2KmUaQSTRBj7XtUzjuRGTpyl5WExOl89Sn0SsK+euxrvmv29FDURGz6+gKjDELr0OWz5wi0X/MEiH2PVhJCLd2YBAh2uBRBdT8hbUgPOnWN/wkBO3mAtBb8BY/lYexLLOsc/CPXeBjWalelKpTFxaQqfY413v/U5Qnj6iUq+vNgmXpyyMNti0qFZ2joNS1jl7VrFhiX1Te0uDzdYyqUJf99TolDULeePQ/1IuwGHFLUN8kQ0cfvM6n17eeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PK+ewEHhD9OrN8DLNxSUQ0YRwwZQ7fq1PjNc5wlxpk8=;
 b=MIC5gFhxSxGyu/NyOrZOyIO+C2fZ+oJz0+y7M1rwg5D5p2/eBehpMJ8O5G+yOwJWiZx1Tw/QiyUwnKunTANZ2FFbxmkZzwHEhfjNGoIRvqzAfjlWXGdesbP9OWANhOpkLE3UZN71oohaOmpIjem0OmW7g4NA99g7qnex8gdFBas=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS5PR10MB997755.namprd10.prod.outlook.com (2603:10b6:8:342::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Sun, 26 Jul
 2026 18:34:29 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 18:34:29 +0000
To: Nimal Prabudoss I <nprabudo@redhat.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jmeneghi@redhat.com, mschmidt@redhat.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Update QED and Broadcom maintainer entries
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260713090100.126362-1-nprabudo@redhat.com> (Nimal Prabudoss,
	I's message of "Mon, 13 Jul 2026 05:01:00 -0400")
Message-ID: <yq1zezd1uew.fsf@ca-mkp.ca.oracle.com>
References: <20260713090100.126362-1-nprabudo@redhat.com>
Date: Sun, 26 Jul 2026 14:34:27 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0229.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS5PR10MB997755:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c23d113-bbea-43d2-2c9f-08deeb4486fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	3JjGjbd9NQS6c18tPMUN1337JRp4FfANqBk1lBF1hiwJHK078TTIqDNPmJ/v2lb7MfAYrRIkqWoZuU2H7eegrfBAhQ17idRMIbs2l6gOVUqs/GMYoRP4em5q4dqvo3JJrIzhiz0jScF9PYcq0IobD3Xm4AOwTFUc5tgUIXSjDzwYXDvlK8pm4BYRnibo3yw0sbC5v+37V+yPKo/YIhMNtdwDM/YF4C6vNWET6E5w3vkJUfbpbtjZCYMSWY521zbfBuIipLSa0oRYvssZwK4GOzKn9+JW7oKH271Wiy2+NQgMvdjW8N8IE1c+qsfrylRo0hxfj+9T0w/5XcsBfeK/t5bDnoGNSvDr4uZXALkXiWaUzzdezEYLXNNa1hEAbIBnhNXdhl1Xh57yHP3Yp+4qgyrBQDOYCteLYLSlHYzwRwiezNY0Tyz20OcnEa3oqXxWAMt3uTVBIZx1/9FfRqhWQphN7r6HKWYapSjbKweeMTldOgIfA650MaX5VZxi5dO3pwhFefVU26fgVQoyERTE6GQ0klWfxnJ3/AHgJ8/22wmnD/MpDGJN26PBMkObGs225SoHqYZqmJHSq5r8xiDRl/i90P2q55ZJPXipgxfiAdVkJSUH0fkcKrLg6wa9mTqnN/tz7DYq0oO7ehN5R7HAxOQMW/+TQ3ziNAoTguIp5WY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mcFPRA7YWQdFAujk+Kxn5qiGmImPp/k7TJd+pp89GcN1XrnkgvsreKEO4HY7?=
 =?us-ascii?Q?8OHGsIIxmXsVLjcx16eUSgQfgXhU4CpAFs4NuaGrvSAXSXCrh2JpasLFN68z?=
 =?us-ascii?Q?GBTta3l7uSzpb0F4G4mVkOJJ7C4kdI50NoESOk2F+0Mc7pj8xjkBeR/AJfS6?=
 =?us-ascii?Q?L6A5f+xRiXf3dbGlGwCx09fpApgMadLpFGWt5MuJ+34vdi63N/sTv2WVOsFF?=
 =?us-ascii?Q?4Dloo8TkZz4Gkjy9VDPq1K6ozy5KSqLRPrnK+bnTMrJDoqJgJOvfT+hvOTIv?=
 =?us-ascii?Q?uuMtz2Zg0Ap7IJzBiMmOgbycLgoKj/iAhH2ePnBhCs+Vf1Y+JQ35AM/fTEOR?=
 =?us-ascii?Q?IwWUbb7+Ox4PzEgdJXBbPmqtSbJH1/tLXG7LcIejnQRsByD9WjrChUdtAZzD?=
 =?us-ascii?Q?X0ldTqN5RnZEqkS6/8eUtJi5AXpArkYTp4Y/Y8FxgpMrq5b6Ec5YPLcmzeiC?=
 =?us-ascii?Q?gnZ1YxGCz9BbEpwWyBJcvFou1Q0BYac0yiOuMObe8aPrmtyciAmpZFTXo4Xk?=
 =?us-ascii?Q?8A6YZ9z2kM62zgh7CpdC0eZ311iKBeCXouWjuY2SRC6swwneqyJroHCaPZAI?=
 =?us-ascii?Q?6KwownIGl7QcpJveedpIDZYZxuyXkaQI0JqrrozHQ8kREX893u/Dcw+sBdjI?=
 =?us-ascii?Q?E67vvDnyYgXPKdTKEw3Fe2w1VVG/u9/IFxO0RlTER2vH4owS4sxfFrC11XZy?=
 =?us-ascii?Q?mHbdSMLZvVqQ6cZkm3HOtAyesQS1yHaZjSwpGGdb1KMZCd4jA+m6Nu88MhhE?=
 =?us-ascii?Q?vfQqdGvDKIWKElL3xewdmWiWxq8rX15JKrDIzFNR3aq5vuTOMdaAk8RBvgiP?=
 =?us-ascii?Q?bCCtSQX+mElSLJNTtG54dgykdpoQPu26J9LUDPVOoMY1KMYCwFqEyvKt+v5G?=
 =?us-ascii?Q?C92qI8bOr3X85Mi+CnQfW+7Yo+CNl/Vra3lUdbeHlenRFz1IITGqrsAH6WsQ?=
 =?us-ascii?Q?KGnEayySPqLGW4NwvZQ79VD1Rlgii4LG3BB9Cb3STpNwrEgWi7uTH45ibmgI?=
 =?us-ascii?Q?aj254PJHE1UQISuptD01Nlbah/IdYMTP2WQNfjepaS3FAEQzMzXx39cGBc7Q?=
 =?us-ascii?Q?fti2wIIuR7sh0JwtqKkiPWfk7vSP14eY11iSUqLydO/Q7e1hFdaqWFFGCMKT?=
 =?us-ascii?Q?MKaNrrGL51VpiXf8fdLAeCmwM8ZPG6nlkMqoMn4EygaxOCFjfZ2GcsiaRF9J?=
 =?us-ascii?Q?EnGWIngZuRkKXUfOOZIFS2mkchumSZKxQpOrtqJAD6nZVzJtqRqUHfpewjyp?=
 =?us-ascii?Q?tFnmYVLREwB+an7832lrtlheQsow/8XHN56tBzcR+izo+C8BXGTto8TXLexN?=
 =?us-ascii?Q?4c3l8v5nlAvGd01xAL1Fqs7qtxvRkftCjDeYx/UzKTByFaBBh+uhsk/ruIDk?=
 =?us-ascii?Q?DRNoQrCJwkpJIa/5Ap2SitbgPsP+06WHGKBgQrNfhO+WjT9liiXhXct9R+Xs?=
 =?us-ascii?Q?qRFzC/aPtvj/0i7PtGWsZ7NusVu9Du/p6jCr1V0NJoYTvkTy0Wl/wk2rXJKj?=
 =?us-ascii?Q?eOjnw5JBsujtKbPztRMQxn4DOHIBEajp98vM4F/z0fKQs66PVhbZdMl9XjCZ?=
 =?us-ascii?Q?i+yTVmx44y7yS1o2Tl+DffcpgKL4IZ0y21jJt3qY0y3s46g6RSx+J7YOUnVY?=
 =?us-ascii?Q?YbA4/pZ7zKhuySA52yED/NAsAhotd3gc2c86twbygvaG3Dm9gSghb7uUtc3G?=
 =?us-ascii?Q?E6wCqIAG2e4Py8lD4hR/Gp3ua0KPG9irGaqApvsxvdsXzKEPL3zaBLCZmLAY?=
 =?us-ascii?Q?tR4NuK9FJZA8kVbpIuFwXVzye1cMPmE=3D?=
X-Exchange-RoutingPolicyChecked:
	n551z25es/6dfa3VghzqUZTcAJTGE2f4ojbcMCjAiPhYFtwyGKgQybmR0onOBMjsL8TmKlHz9nhxO22Tug3u23UDQWMuc97vlrCcVBDUeUu7DoBwZZ0AlwkpFtNNq0+wq68j5ITaZRlZ0FDm+krYAjtqK9U7g2ZXJ6P7Vb9fi1Uvj/xTbLDVDPuS6K4P8iqdC+0wI7wbxoUOog1dAgh0knwoISW4augfcrmF73RpX3lWrLXPZ0Vr1aEK3zWmZ2oyrk7Dhoe6rv9ZgAUBibHE/wNOKSS56ZMoF0k/g06NAJEIxPpyjLpOwNpiWlbiaAib0+DqTzRGpbU1F1ZmvQ/wpg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SthtXHL2P+XCybuNqUGldfgNFpWX/GSsH2IdjkHD8+5SFcI9fZGGNCD281PfsxMzOv7jdzllPVxI2PMLxXeRBznX6UMKLpp41QhLGvtxD1imtKLhF0eWQqs9jiB2yAufNleQmvKzzSQxcTag+I445D/gsXloqBnhVtO/WRLYdLdoVQ6PxnI5U0JwlVHvrpEc4EenXgLT0Zvnf6o8kyKRqHBXG2mBve+6YNjj6K8+eXj4/x6zJ3dNJqqaeriiuEgq0NoGNxTYtSune9FVrq8GLm9yh7gR53fA0OrLgBkBqtm058OZmNq4QVHownIIIMjFF/t/+E28A7iAX15360M4dZXWv4dbLrDTDGxHykF5I5BlNQV0MLbouUg4mo19WINkloZEFMK1UsbJIk1DWJY/UYn5HStBVTJZJgT/iWCrjen6hnLYMVEXcJ3/PwDfGpis0UFI5Fs0x1NVgFRtye5XTBHIfbrHsqOSiL5KyM95PYbV9F/ItYik3pBqKY7OHTIOr1Z1LxiXP6tuNoez5MNakNqZOLNtu3wNVrrdQr63dSbecsU5GsUMvw5+fDEOuizcJHckdzksjfw9RGO66qyseiS1XphevoFexNc5KJ2U5h4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c23d113-bbea-43d2-2c9f-08deeb4486fc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 18:34:29.0089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuUetilUD1vb/o3CWftYpDnQFe9TDS0k8EH3FbiXVW5Z7HRVrP+rp2tZtlMlBdiXPIDjnkpXslCBgy5WEfjjPGhas6EgXloUliEyQRhYvy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PR10MB997755
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=768 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260188
X-Proofpoint-GUID: t21F5qWBAzNS3lqglyCgd5V9iyO-7baY
X-Proofpoint-ORIG-GUID: t21F5qWBAzNS3lqglyCgd5V9iyO-7baY
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a665339 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=M5GUcnROAAAA:8
 a=g8o5ca1U6tqKYOo5mg4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE4NyBTYWx0ZWRfX6nDwj9jsbHJU
 yPBCIPWXCPUJey5QWftFxLwi5r6IDSNOqXldqeY7XdOrpw3jijJOvdLUBNLfUnvIKeAsFRNXe1d
 E3Oa8F9AIPP1MDJ5Bs+Xkufn+ALJeh1j5iqibqg3qiqO1+qgRz7lQCe6I29vu3eTk2YEWUPY+SA
 z6nGGZisGzhCNQ30GYmgqcOrzadbLv3X9VA2yHqW8kbxgD719CNL4NdpR+0l8lnvuKefrWnwMa5
 bFTd5Zhr+C6V5Hgyr+DwuCpz11FI+i6yPHmRUNkocXcgKRNfF3pu1vEwGwxPdLu4lWqkl2kjC+F
 BQ7e4jW3oKXyJemfWiOy51IJoxsegQj3UZE7Cl+RtTNNbh/w1u/Oqv086veZivgEb1L3PFrQ4Qp
 Mk8APglBh5+fUE/BqkBn9IbTAZ3bj3T8g1pYxtMK4D5ZZDSkDVerhD2vcM0btbq/uBfBzbERk73
 N33n6Ngx0KW7X2Evnwcqe9O6xaZlwu4CJjnecJNA=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE4NyBTYWx0ZWRfXxc2nFmDRGfRO
 TS5WdUw4aNQTh2cbp5VFkG6y5FOrblEx1autevZ7b0a487KzCGMhQi0+clzeppGQlJlMjbcuIU7
 br6ftquC9jHz8yhB8+SCTh4YR3ZhZ+/E2K6SYnmk83ggOY3TE7uk


Hi Nimal!

Your patch is missing a Signed-off-by: tag.

Also, you are posting using a redhat.com address but specifying a
marvell.com address. Please fix your attribution.

> +M:	Nimal Prabudoss <nprabudoss@marvell.com>
> +M:	Sharad Padol <spadol@marvell.com>

As is customary, I would like somebody else from Marvell to ack the
maintainership change.

Thanks!

-- 
Martin K. Petersen
