Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040272BB13;
	Thu, 25 Sep 2025 02:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758765623; cv=fail; b=GM5UnN8VCX2z8XQlOa8dUCeYBKkfLWYDvZcLxL9ycD0PHJLie0LeF6gefpY1d7higmuG0it0QlGzmidrj8fjubm2DxRU/Uv6DPQ4paAPudxm232Dw28SYH/DuFwEOjX2wKIDl6jhm6rXXaJRo4BJTFWHsVj1amVQHK/DpJnKwZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758765623; c=relaxed/simple;
	bh=/tm//p2agaIFtr1qMBXbBvQ489Dw0iaJlt2KV8GpozE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WJaV3c6L1zBodDsGfkyAbPftzBf+oUn5rq6bGFizxS8CfA3vIcwEAE5fuLY67BR/Hl2Jw0+ImnaFUrLmBDPBwAJTH4Nv3EXTysmR4TdG5l7YNBnbiCYGWxREQHudRp5f/j3xYfAnmONta6MYL8Dkt72ou4YZVml9U2VRettAEOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mAyZgJ02; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pSgztOHp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mAyZgJ02";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pSgztOHp"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OItuNb001548;
	Thu, 25 Sep 2025 01:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cMtjvaqwk/Khb+fhtz
	KtQ2Vua/pKsSOsE2RcbA9/E9Y=; b=mAyZgJ021QQWllKu4SE5itojjOj7BrXKs8
	AOnFq2+ExVF1e5hfF0HU0PRJ/oCxfq9FTCtxzGcRorqWiG1ISYwlcG7h1u09qblW
	Gz11hFtt3NYO7GThAyOEUFt5UPzbdAi7n+u3lbz9OcmiMIzNMgx5jd9pMTRJza6v
	N459xKZMeu466dMXW7dOUXMJqvgv5q+IWyBtO84CwhRhVK7Vt7qnxA1JmCGNt9lz
	BRSne5NsmH638g8VAmd4YdEmVeDVB4UOuqG9fG/PZ3nvhZlKeKO1wR5XuuCm2Ps6
	hmBa2t08OkV7dUIWjwBhOsbdfeS/+B5ZrlTu1BrHWBo/6I/Ek+2A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k23h1ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:59:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58ONtljE021697;
	Thu, 25 Sep 2025 01:59:55 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011019.outbound.protection.outlook.com [40.93.194.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jqadkgq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:59:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HD0jTBLRfs2LMCPPems/SwWTOQpeF8lcMEn/Z7D2hx07QA1fTf96DpbJ2Z1nhtOGVdCRYDuRcZrmqmR5uCsRmB2DZ0iJ4IHrTrJnS+WaeY7mTNameWE1txrbQah9LrngXM1Yoi8I4CsBB5KbFh+uy3gHHeLAxtuKZMVoX1w/cxg7E+EWt/5UGWGiu1Yx+3yW8Pej1jxWVJDlmTM1rp+UXFd6wHpod94BYXk1atEMi8+eX4OBkBdpg9/fQyoCW9+3A7wAlax5wOh0bvb+wDmz0frSgTGgtsVcurL7dGvWKk5DO6AwV68Kj0qcdb8I+F1LjpIjcf4Kb0+aMp3z+Dz5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMtjvaqwk/Khb+fhtzKtQ2Vua/pKsSOsE2RcbA9/E9Y=;
 b=aBci29QAZ1jXmoPY6Rk4pAC8OmtpoLieClwTXKq8X+ej9K5W0xkKbDfalUdpx2Y+yFzYbkiYXHnAM6KThx1mhMZGEE01GjSqs3isDpShGy3hK7AQhrSPXtLddKZGh8YBY2qZoJuwP2zZRiea9rlZmkm/tCqAu7D9U8Ws2PGa4YfflNztWCiRG9BCeEP6Xxxgv+dXGKD72vjLDCwzqdl3i3Cj/UGxrtA5knyZBYQBAj/WWyjVGeSqRY2urveaLEClpdpbPwDtBVBz5HzplIKlzxoc6eQyQRC9Eix0Q4dmiN3LkAiSyEBrWye3U6XyY2hqK/QJmYmDiJB36SFwxHk3NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMtjvaqwk/Khb+fhtzKtQ2Vua/pKsSOsE2RcbA9/E9Y=;
 b=pSgztOHpNDnFMyykZUAGdmFiI7UV4UIPZCzDUCsF518gZfAb8B1S3SfziVvuGMlJ7R8PY+UhjaLHhqC5vbjpEtFZFD/kV3Zuz+qcJe59WkMsYb7u4Mqj4MRs9v9au/i/EYBypZQrAwVe5vkDym2TE0h9Z+9StBQ22LkWXySmDEo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB7142.namprd10.prod.outlook.com (2603:10b6:208:3f4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 01:59:52 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 01:59:52 +0000
To: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
        quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
        adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
        quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, ziqi.chen@oss.qualcomm.com
Subject: Re: [PATCH v3] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com> (Zhongqiu
	Han's message of "Wed, 17 Sep 2025 17:41:43 +0800")
Organization: Oracle Corporation
Message-ID: <yq1o6qzqol6.fsf@ca-mkp.ca.oracle.com>
References: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
Date: Wed, 24 Sep 2025 21:59:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::40) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a2112dc-a37c-4768-182f-08ddfbd73720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tqcUa6amT/xbGXtwEoy4o8ryY+hwd+iw8xwAcGqluFHAojoXsuxU2q7+vbLK?=
 =?us-ascii?Q?n1G+2nxccO7yCXUiKvEWRKkFmugcPp8quiDvWU7/eSM7uy+wHqefbUcsNvoR?=
 =?us-ascii?Q?AIzB6o9JTm1Eo3HSvKc9G7uoCLhBcWqx9AyG7tAKAeGHEmX6ZyGWSSylcgIW?=
 =?us-ascii?Q?P+R4oBN4moenlg03Mhsc0dNThv+eVmL0NuZWyPyPkjcpF9tkZ3ZgdDhtz337?=
 =?us-ascii?Q?JrJzIB52DIHsp50BO/v4rUqChQKw9pa1wDNpInk27p5EcV6ISwftuoUVSQeb?=
 =?us-ascii?Q?+YlmNd7R0KGNtOglR8RweY0Q+PyNN9qTaSFFtpidJqtXiAewOVr3k4ZlZ5gn?=
 =?us-ascii?Q?ME9ug0Xg+3Ev6Tem0hRUyIJPrdzWQu1hLA2yxnAjexBmTPzvU0vTZJQjzjcD?=
 =?us-ascii?Q?raGLwa3wIw2sNgrE5gK3B+vvWHgt2TUTEn1BOaGqniKUj2lXKeiWCPNMRER8?=
 =?us-ascii?Q?4Xe8quba1h/+Piba+tW+f0fkyGX+gsEwqmiYoIf8O7v2Dc9aj7EiDDdbr2ir?=
 =?us-ascii?Q?qXniiQNq/ih2ucPwXuTW9ekrcokq1+a8mYSZWwnR52nnJ9JdKsrIN9c5lrOM?=
 =?us-ascii?Q?wh7XCNJZ63Lq6AKrJWYt0c6s38GpdqzuRFvoHbnclud9o3AtrK94ncYztGSP?=
 =?us-ascii?Q?T8qP7n7qtpEer9E7KEv/ftimTREMwehzrWAY14YLbumc4Y4xj6v+O0R74DlS?=
 =?us-ascii?Q?ZiRFLrC6oU6vzDibKRT/pA048WbPitW3ZDTYTJrrNAVhUHPC/wzYOJ8/8n45?=
 =?us-ascii?Q?q8Vt4F9MLwQdCgKjASwHtZcmtFp9rSOJ3D+CPIpUbZWCBnoVby2mkekvclxB?=
 =?us-ascii?Q?FYw2GzLIKh7MxWDqhLCBWETf0Mt3vWuQJMIcC33AB6zdcqiD00KUghVelWhn?=
 =?us-ascii?Q?s7XUkX8h1dCYp204Sx/lQTDvDm4gbCn3YJVzjEphX6HWkhYMU6YigfqBRydP?=
 =?us-ascii?Q?9Wo7pcJJis9cCC9U3ljvh60QDWO2Pyv0SpDNd4NzNKsZOXuhkL7PTfDzEJDB?=
 =?us-ascii?Q?dMhZW8svGBHvn+JOywmw4l3r2Gyw6t2BddKnrWC8ba283eShgsg875HbDOKp?=
 =?us-ascii?Q?PDa+luNkvU0KeevrdY43opZPd93E3mSv0kV1bneJeb2H42/1mkrKkJJq5NhF?=
 =?us-ascii?Q?Sag6Kv5svTSFELwx+aIN7QFIqMkCA4LGETPAaEvWEe6oNbRKKuka1+KvYFd5?=
 =?us-ascii?Q?DXXdxowPx27TisiyFPt+IRNG2/veWm1IMf1qAJSnukIRATw/uzzRPp3lsFVP?=
 =?us-ascii?Q?mPPNKa6gHyZwXEXQtuicGFzdHQ/gzL7/REz1aOnUyhKVXzrQqJ1g1IWyy9y0?=
 =?us-ascii?Q?1iQaE9vKgsyJxhbrt4reiu/BUoCABhT+UhKPbtrrM2j1bqWvl0iKSEiMoHhs?=
 =?us-ascii?Q?tqAR7kLnXXYzpgG4ifl3Z5NiCavasZ5KshgD+TGzY6tpbweWM5FNsQZNY1tA?=
 =?us-ascii?Q?/OKYxPDRQ8w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qJk5m51Z65BkdYPD8fIMOgYlsveZUpVdkG9szmrCM8kcRM9E2IkhdIv7X6vd?=
 =?us-ascii?Q?Cy5l4J5LXmcKH4Io+OCB/uVA7NpPHjNqUBPKl4soE6bMTFesvsqcXY9L2edb?=
 =?us-ascii?Q?/oHJQJPxFz+gxttYadlVs7M8ltKQySTZbyO4Iaqw2p8gkAmx9en36/UBgN5u?=
 =?us-ascii?Q?w8R3bo+RgLx4pQBdiUb33fdxuzKSuq2+8f1lJpYxDPDhTPvRuNXzgCFLAyK+?=
 =?us-ascii?Q?/wbTNKZSOPJvU5uEep6MXL51xyUbX7VBgUPwHEXnxwv0/KuC0qHwcOl1fiEv?=
 =?us-ascii?Q?AcetZ/dQHPrK7gmT+Hi7KYknYrqH1TVLVUdNfSW44IW4/UoEEZTjlaTbqlVv?=
 =?us-ascii?Q?vKpFniq0skaObwzG3nSQjFkWdikxAT2x93pTm0L2QFriUTChMFRYj768wyNK?=
 =?us-ascii?Q?NFyvmA8O0/Zaug2Y3ObmhfLRVTnCg1BZMSxXu+LlZ/ZZtMRHql22UwejXyGp?=
 =?us-ascii?Q?eJcEpUffNg/fTaYq3q9L1MTVb9p/0N3ePCx8pJMXWGgprBP0VzxbDLf4Rkk7?=
 =?us-ascii?Q?vk8XWtjJ03PBpzwsKvsz1vxMmlrm73JPuGp2+dAi0XW/Z+oFuVLu1jXarrEZ?=
 =?us-ascii?Q?KVaRxcuQKJMeGVl03qA7MvCPnbasYeVog6ct1552OzO3mAW+/xmj2QsuEbv8?=
 =?us-ascii?Q?f6u8SYl0gTsuM9HKodzVr5qfNVB85USQAyxseCD/FE7qGk4f265gIaarTonW?=
 =?us-ascii?Q?9le+4tgXcbbnM61/PiwlsRHlZTRV7HSr6CS6d3WjjzLMTeMT3tM8PMNAwYDn?=
 =?us-ascii?Q?c3L+uk3SR36vjFaDmh/UsvisQ7dp4FABNcQi/n5jJ60gQ8T/eMwrWlEgt4iB?=
 =?us-ascii?Q?VSm+1g5GAWwzP62bL/W91Y0pME6LeH7tETMbv2PGjE/yYhlx1okC45QrvKTq?=
 =?us-ascii?Q?n7xot/COh3c/KHRMd5f0qaoBpCON0rW5yeOavcT+FhsdvP2fgVK2Jhg6b9h4?=
 =?us-ascii?Q?bROj2LZ67v30blB1CF3MHJ4YKEMYY6tP6r2VczQuw5k7DIMj6PAT4ODBAGmk?=
 =?us-ascii?Q?5jhq1/DWiSzNt2v6Kp9IgsLZu3jKtLl4fC6UfWjXR0Lh4KNJFGt0OJ80vOoM?=
 =?us-ascii?Q?VfxSbsfUiQfBD3ljmIk6RO/moIKXGOm2frzv9jkmi65mYK0Lahscj8DvHrLv?=
 =?us-ascii?Q?4mv24zPo68X3GWbVBbOXPeSc94WV1WjPAaTJT589xUqlg39tRmEPRn275qZt?=
 =?us-ascii?Q?vQoMLcF9VRsm72yd1TY8kSyW09EDjLdfirrigcdqDrxq4uQIckcM0/b48JJd?=
 =?us-ascii?Q?ytxq6kCzR1GsOHzAfum4hhfxwsoy2JWJpvdPyWZyGbVuhm9c/jIToA+cPVVw?=
 =?us-ascii?Q?/ShlxK8XX5CZcVH4SKvh5m6QyevFXe4NnkjJMfdsH8hccpWnDem/nVRw+P3k?=
 =?us-ascii?Q?LpiyFFC5BFZ/7CMQT0AX27PMhYYkyzFnfvfx+HtJ+IhKObzaTvNp5UNgqsRd?=
 =?us-ascii?Q?TKaUg97aGRPFJfDDTP4PoDwx1h/GSCEUWgZrFVvro/PprMPQShSx5J8oX3Zb?=
 =?us-ascii?Q?p3OM7DoDHlZVEO/Ybsd5o7O2CAxJrBGIG8pYrByKMncAey8f2Wvu9JrlaO2C?=
 =?us-ascii?Q?6XVsOt7Y8HVZcznI6TOeS0ngnNJ/53kjfjSbGFeX7xNb6zVhbB3D3uGNjPHG?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mNcTawKfjXqXtbTUho9WR+WQbgpQeJMs13dC0c/WyoVhF2rltbGuS91J/d6J2FocB99BOdS/C7WysJDk3zvz535VZSv3xNGQFwYiegcgeETk6mZqFv0OKZpByyyHKkT0MoCTHcXAp3d78/LUG9DXerTjudWjag31oO1apEYf2IO41NzkVzVVMRIvojKmovbeFOKJz2Q8Yu+NNpoZSloSCXIK0x62yALDJmKzaE2QOx/7uJvVaaAhcnGB91l2V2QsVY+r88ptM9XQb7LNfO13fjTEOqpEY6y+kgm9P+5KVRu9CYA9Lsqx37p5vplmp68mmhZ8kOznWQ3xeMD7Vv7UD1SkUF8wDhLnbl/x9BG9PuNCTasvjHE05GFoTNxCHHpfIxVi/cpi60gwfWD84MTKQfgO74SI4rVD+uPLHy8HG8SsApYFG4+GxTLFOUfehgWj0GIyvDIJYSnYYzAfCQTWIBVbuP+aPk7pNDpSlhfaAujsTOmPExl5xaSXwoPoZEnZqLwLSA/q1zzbAgf0oPxNdoe6I4Qmn9UcjoxmOrnrAtv9N7wVEv9T3yOReZ0oMq24IvbpufZ3l2cNqqWw/BnSebnYGE3jmnOSShdlw5QSn2k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a2112dc-a37c-4768-182f-08ddfbd73720
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 01:59:51.9167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H//DQuMAdSXqkqdvyyfHZIbYEgrYxuCIzuIQjOQZp44roBacD1+LnhMAaqmFMhIzBQ9yeF7pP6LYa+35Q1rovdAH7wJBHaQ6/xqjnCovzf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7142
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250017
X-Authority-Analysis: v=2.4 cv=C5XpyRP+ c=1 sm=1 tr=0 ts=68d4a21b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=R6l6UpzWAYBwzXPi-lwA:9 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:12089
X-Proofpoint-GUID: eG9AhSaj1WnvwfIMyu24Fu3heoI3VVoh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNiBTYWx0ZWRfX5Nf5D+6kujg7
 0UNsgyeziTivKaS0OwICF1NSojCwTS1LkxKucfTdNeJeJzQDK/p1IphPRSMvg5yJIC+vMeAXE2H
 zxbgHbLd0JZleDIyxsuphPOqor/u0bea8+hJ1HBaADEr2+XYqDgWfbuTnI11VmFy14CYjOvCuKT
 X8JHqD6RiI9TP6lWkIEasTnmY7+Rf/+zZwqnAmc5KY+TBtvdAVDLm4C6RcXswuxrhhw6ksKeuXo
 3P+s8RadMGjytf1u64jnpkDYy00Hmfx0ohXlNMbiQUc/9/oeUPbg2QnZChIW7YHaDU2aN5mdNwx
 +dTootb/IkKfxNqszD+ypyBoqoa8kAEJ/GEosOQDfgQFgxtc0ziJh+Orvql3JblHQcNiG0YSnm7
 672fleov731vlMMMkk2LKUnNXMNZTQ==
X-Proofpoint-ORIG-GUID: eG9AhSaj1WnvwfIMyu24Fu3heoI3VVoh


Zhongqiu,

> The cpu_latency_qos_add/remove/update_request interfaces lack internal
> synchronization by design, requiring the caller to ensure thread
> safety. The current implementation relies on the `pm_qos_enabled`
> flag, which is insufficient to prevent concurrent access and cannot
> serve as a proper synchronization mechanism. This has led to data
> races and list corruption issues.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
