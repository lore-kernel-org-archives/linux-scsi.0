Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399AD4C84;
	Fri, 31 May 2024 00:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717115823; cv=fail; b=feJ1fyk/vBS205isIHkFEMuG8rWB2zhXQIC2K35ngjCEnVz7HZ+Ds2ZFCEbgrpcRqqqPXENoRnDg2LPoizWh5MkBdTWWH6mpes4f6ujQyv167E1AePNQNamSmb8HO77ecneLAuIUtoRUZaIjk7TlLiQqXTD8b1NoH6BKErCSKgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717115823; c=relaxed/simple;
	bh=iSF1LU/zCQFY6TG4/nLW6Dy8b/j9TBL8D08QpH7NoTI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ps0oo16hJ1BmGQGXIpjoG/lWRaZK3Pa5nIBqCvbEXmtoFRP92bAHIKn3pwECkw5G5uVQbeTA3uiB7459dwGaHTO/9dSlCoW//hD9Uu+oNh4pYnykDfff/qhfr8uXlibIOfKibmz+cHqA4V7Bw5rYDPcnChvWeWZ8E/7XgNKs8TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44UFUkai019783;
	Fri, 31 May 2024 00:36:53 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-type:date:from:in-reply-to:message-id:mime-versio?=
 =?UTF-8?Q?n:references:subject:to;_s=3Dcorp-2023-11-20;_bh=3D/YUgjiU1wUgo?=
 =?UTF-8?Q?9dz5C1fJlVXVYYw4ag8wq4Ha72btmi0=3D;_b=3DQuUH7vg8aPjutyxbiBPxmaA?=
 =?UTF-8?Q?LG2TeKW0iYOBjsDOVZdFm8wmjhiZFh2L7frMMikLgqWGG_XMf+R9+TSFtQzaXuj?=
 =?UTF-8?Q?woWfEVHGGJFjGwnT5AAp9+AnsDsYpY+Sq1wpaiTcMaS5TFdkuRs_4VhWINp1HCb?=
 =?UTF-8?Q?TQ9F/1LyayouYmxGLUo2/LIk+RTFtO0WHw4fSsWXMWFPtV9w57nyzvcg2_xg5pu?=
 =?UTF-8?Q?vNBb9vkZxenYGz5syi0W18T/hAHqq3zqzn11agquGFMo+JJmj52tPgUh2V1BqqI?=
 =?UTF-8?Q?_ZK58tHKCW8oSEGlvd/mFPUL28vDdt5WxzD5O4jhXPA7SrHq0Kk3/4VwNX3nm8V?=
 =?UTF-8?Q?a7Nqcp_qQ=3D=3D_?=
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8g9taqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 00:36:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44V0ChWV024127;
	Fri, 31 May 2024 00:36:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc52ejtb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 00:36:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBGeKIm0hzCxDUxxIIwtAJvlZgdFQVxi++6WKSzcrsmeSFNFW/42bLx/M+On0QBenpSBdPiMNi0bEpd45NBiEA+m3EKdliCwkv1EXotxaUHCoRwVcmMihTDHP8xWlPH3RLkdp5GDCuaIhFWe982Ew2IYXhoNdCQZlQgtfM+T+o5XS61dn+mlXeCVwyt8+hb63ItxbOKK2yEA4VlCJdHMOlM/mVqJLBqrZXHG7IccwSQuKqtJjPnLoQaKbCRpybkm6ZQvu2z1QRkOi/eChtULTRH3hHKTVzXWQtvQtuqK0Tn4afHkuYstxeFrdio4RgQTYixXCKSbZvgTNUAP5RR77w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YUgjiU1wUgo9dz5C1fJlVXVYYw4ag8wq4Ha72btmi0=;
 b=m5UOd8NvSjXeQyUcQn2Pvx10L3eHaQPKBc75PsMXnSiJwGef8ohb44t+8dcOOPsWW2eTG+I4A5eqTUf52XW7/KcjGr2xQ1yYLGTkNACmt3ZWDjLGEAu/hb4tUksAoZAMGtIjcBc8Hfm1z3qDnnrmsa0DtrAev5k1tK2Ua7q1mECIsJcA/zZZyEO3pPzB6iyCG1sbym7QnvyGKOFgQ40A8cpw2SI9QiWv4zGwV9t0OHNJa5ox/xBWourgVBIfg1NLkfOsFtb+mLWhaQVtJGE88XFeWXfR2nsaN/gewTlDcGjI/+7XqM3EWzk9p/+xkiiuKgozyaGT99FgV2ih63Qt9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YUgjiU1wUgo9dz5C1fJlVXVYYw4ag8wq4Ha72btmi0=;
 b=EM9rdmoJwQNP0XBvXSU6BdsB5L4ybMYPCiVzR5xEw4hUgUe4e5ZMDkIWmkbLzgnnbQvUKO/sDsPTRjU1Vc8+OZXJHoyplh4Ma0yHRQwquKi/tUU27NPxHLvHCBUhrzWpFmZ1CE/+0A2dr8Dm7DbN0+oc32T7uiwPKQDWaJ1eXkA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4870.namprd10.prod.outlook.com (2603:10b6:408:12a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Fri, 31 May
 2024 00:36:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 00:36:50 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche
 <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Peter Wang
 <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] scsi: ufs: Allow RTT negotiation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240530142510.734-1-avri.altman@wdc.com> (Avri Altman's message
	of "Thu, 30 May 2024 17:25:06 +0300")
Organization: Oracle Corporation
Message-ID: <yq1zfs6es12.fsf@ca-mkp.ca.oracle.com>
References: <20240530142510.734-1-avri.altman@wdc.com>
Date: Thu, 30 May 2024 20:36:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0188.namprd05.prod.outlook.com
 (2603:10b6:a03:330::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4870:EE_
X-MS-Office365-Filtering-Correlation-Id: adffea79-2ab6-4262-18c0-08dc8109c313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?h88cEPwbc+nzc5nSaEfoAxmkW3QCirEbfIotJmuRR+8DnOAkn7hCXBZH1VmM?=
 =?us-ascii?Q?sFhUCPJdMnRu0awIoupoy3yRy/6kudtzpF+GfqOWWV3Lw51dfsyWRjHBijU4?=
 =?us-ascii?Q?xb91AiNjju7nqaxmGSZRFFyqBtaeCWSydTN1s9uEgOBrKs8AorrnTw15Ijb9?=
 =?us-ascii?Q?oLtFzRCtKcaZtk//nKPGGu8YHfv7ypeOu4j4VyXR1eCy36Cn6zJ/F65WsEUI?=
 =?us-ascii?Q?jAgko6TXXWCzZRJO5MQPtLZdqVbBYCzGFUQI9VGEtrIwiped+mr0vMnK9HTV?=
 =?us-ascii?Q?5ds1lLlM37LocgQVYqc3SoZV34Qqhrx3RGena9t8soStwadGzkXU8YhgJzIH?=
 =?us-ascii?Q?qUqlsk9yZ42sZXKaN8ewrFERH1SBezauqbXhKEerH1+BGDuUV/qNOS0t5GWV?=
 =?us-ascii?Q?ITRXWv7HlMoEhrJncNPRIsRIp2wZu3DKmjOOuMdZAcOQuIdu/7VLFwxeySgP?=
 =?us-ascii?Q?/ducn0e8/VdCZv3n7snNuB8EBKBC+DqCwuLFu+b7vGzcR7sm4MUww9hSPQ3s?=
 =?us-ascii?Q?4/Od/W20rlVv5BTvoDJ7fBDE+1Yo5cyljS6MQH0cIbMW/B0MAVHVSxRHgrHu?=
 =?us-ascii?Q?jwJabmY25gTBJxmAA5phUhTIOl/vXwUS5PiuEMETLGMhCYK7E1V2QVHQgBEB?=
 =?us-ascii?Q?57+9hVKBcshr4ejyhphx8ZXujSe9pdDlAzvWUo5jDi4eBpjtn7hx4bcEpzj7?=
 =?us-ascii?Q?XLLA1Ze/TNBbWDHFnp5pGktowOK0uNKA74OhxDiU8dr9xtZ6qv7b3q7kk9sQ?=
 =?us-ascii?Q?fMpE/WTqNScvlCEH4socNeg4vX6hySDybeENBVfJow5BZE3gQ4pxDXVZAJb8?=
 =?us-ascii?Q?RqjuqF+GsG0lzJfKtCj6ucA/D+ynNOWEl4xvFK3aZQNZ3AW+JUALBOzq9gnM?=
 =?us-ascii?Q?87h96ORcEo4f5B46iym9EYRYuAwD/ZUAbkrCkCeVL956XSwIpjmzswl27ngZ?=
 =?us-ascii?Q?ziGiqMbvLs4HJkCb8KcA9CPCP/zESoMysPUCyN6NRDmz3+0RadUuL/DfU1zG?=
 =?us-ascii?Q?bPLaFalS/sOpUb0wuCD4cqRlyx/VaOrfGkKcaz4FEQ3adHi+dXNXW4BCyu/F?=
 =?us-ascii?Q?eVI3RJTf7xDMZM08a4gnQmekeEYFENWrImYgU5JY5DzmwPlxD6LXjbBy+F3R?=
 =?us-ascii?Q?eoOODXwM0EKr8qP3W7ra8zIAeRHnTiAFO/822w7ysoku8YHBbYWKBfoqgvjN?=
 =?us-ascii?Q?w/fAlLpKK9LFsABa5ieIa0ohw2MVCR4gt3MkCaNCK2dPU6mFkQql3Re6NEC4?=
 =?us-ascii?Q?vcYdwgUH+sjFkCBPvCHKhP8nBN1ZcJByaMZNazWd2Q=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?l3RNdPhT458qWgyBkj59lI2B59qZuXIRTkI6nLLa+k7y4cs5OwqQ8CVX7EMI?=
 =?us-ascii?Q?jssDzBvb1BY9dNmYCsXf1LIeQxfXtRDw5uOiHL1XqHB33LM2iRJDvfI4m5mf?=
 =?us-ascii?Q?jqNqYcKcRXMiiwWWe77Us1uYImjb9F6qq3eQRmB2g99a4xEacaNYGKvplR0m?=
 =?us-ascii?Q?w33y4Hbpb0C0km6dKD9ZvrSdJn566Pe3RAOPJEZr0qcG/iSq7MzUTtQZybor?=
 =?us-ascii?Q?KRUKrJceChU/YhkKweKbqZhVEdDZFHXuIDYI3AEcRzqFVIUPqW9FrX42f5ap?=
 =?us-ascii?Q?HJ35is1u/MwqCtX2k7UR72HAR3v0FVi8xCXOcPwtgCTM/e4cxIltUJzMpb6w?=
 =?us-ascii?Q?Ksp/Q/8XN4htoGizc6x75Rlt4BdX0mxfBP+nuyfW0b3kyfU6YbzANwI5k4EO?=
 =?us-ascii?Q?P5z4RwpE+9j7q67+UMT+ridaNw6fq7EIdBppUfEcJIdwCxQOCqgY5q+9geKb?=
 =?us-ascii?Q?Ni/+MKnRliPrNyr61eJo/4oUZv0MIO7mxmPSCQMSc6MhGnM4cFakdFplpn8l?=
 =?us-ascii?Q?xQlGmLWAQsadCtjU3rzTAhtkFD/LRoWwYROWj51LBqfHdlPhCJOo1/oIS50K?=
 =?us-ascii?Q?ODlq61btjxjFfC8F+An0CCviLaHZk20Y1tT17a1nyQPTzfLBaBjcCEBB5iM+?=
 =?us-ascii?Q?bp4XUNi0jPD9Dj6Nv1WG5sjqBL47XSKei1X/0VTNmb0TYQ6GVc4pnKhBBbXL?=
 =?us-ascii?Q?E/lwK33JyyuTbpoImPaRpcLxrFEkugbvqYBxwyLTU9PgpEn71M2AgD5LTVFg?=
 =?us-ascii?Q?wrZ6pszUbisgB8G79BC3gAAEI6eEpwrv8OMuWHsxx48zKqKTtdtxixh8yYDK?=
 =?us-ascii?Q?4U1Phip47SXFNDG+N6LNLCVeRiuwunfPykenID0sdyDnr29hPrRMDMG3O+fd?=
 =?us-ascii?Q?0S6UmuxQl6vAvmgqMq7otKo7gDMHc7s6Tp88durmzW6QbC/bDxXl72HhPw+P?=
 =?us-ascii?Q?aH/A0avSa4gIP3ay8Aimvbly/oyA7UhH/+Ru2cP4V1UOxS/b3ZQVenweDGup?=
 =?us-ascii?Q?Xsj8KjtZ36CS+Ee9ag8OTNSvImsg6IgJzdzWX6ubBl1LXOEfg4dMdsVqwkVb?=
 =?us-ascii?Q?YMiZxzfbV389Lx4Fhzfq5R0n7mL4e8PSW1/jMvPoCPmyf4KGyJWyXjlqkLNS?=
 =?us-ascii?Q?KRfng3LKP+3thuRWW0Xl/+E/AuoO1ki1fpHa305Z/XkVk0Dl0Da5y2V3Wcf8?=
 =?us-ascii?Q?lnGc5y4BbUXB23hzUyLtyr6QpOyMolwOWU/hM0ZO1WbdilicFpHljqgaDUYz?=
 =?us-ascii?Q?lxlT6NtOURpUQPO0/8DILIo7Ris4KuOm07f4pR1Qfl3X5+Qbgf+3wS7ZiIWu?=
 =?us-ascii?Q?m2MzuVtzWEVhqkWU0pZaSxQ02lMTHRtaN3SO8YuxEPqFmlpyPrxxwkUbPmvW?=
 =?us-ascii?Q?UBJDQAucHRzauF0gen6L2510lCWiug3QcfucDBhsbxzwa8XpSWn7JADyH6OJ?=
 =?us-ascii?Q?i77HxM28EFQ3MIqvUQKNFLtDLjWbFfZneVgzdupMQc7h4HgmyNOAAuAVdBOF?=
 =?us-ascii?Q?GeThGgcxn/8zUM4cP/ExsiJihfniwzIh6sRV5leOVbpCt4QXVEUDD6AhsCnN?=
 =?us-ascii?Q?rksiV6t0kpPqdRAVnWziAyo0SrcMeOFZ3kazz2oQFyulqA8VU8WP9KiAuc6v?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Kejxv7VhLMpf673r8ci9/a5RFgxOQ8Gp8w7k+0m0isxAJIs+DkzSE94tDLrDCrE4YLvuhmOoL/7Q+zaRS610+1By8+0QwSeoHv0T19GHUSLdnRozu5uuNbvsYuDJZA95WwKyTPVUq04FAQvQ1SGrlATYlrd8owUlEzYyXab55k3P3HCvOlmmxZMPo0XwL3xwgp66FMXnFTdrrGaLpTULo4m7kJhLRrBQNGLVdvWGmzfyt2/AnuWwDkql9fqRCpwC0400xEgYKjpVGT1OeayQHrv7eU5ZC6bXaYDT1ZmZKsnEl/FfZjVGRGfFUiQ3hovsOgu6xpyU4ItGtIMzUeNa99ybGzOWXx/bn9+L2SvAEzsaa/wMiFmsmIXes9jHfV6DjExlgHmOIVb+VgrZ4+Q/eQB3U30fqAXdHzdt/l0Xint1Z8hbP70SrbYQqLdu6uvCGNU+f5lmPc9J6yXuDERQlCteVqR/TsGpgAjlzPmDLvVtN/Y0Mzc9Nh+o/CnnpLBbbSmgvM/4RFIfdylQIMQO/i71b7zDhofXTIodholxB/xDOQTq/6z7YeZYKqpvGd4DcePo9Dl2AUGLbPE6ms7UIu+x75KpoOmuaC0bfIg0H0o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adffea79-2ab6-4262-18c0-08dc8109c313
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 00:36:50.8720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AeGFcv54lCxUmMLcDQQmUgZb4QBTDFc4P8oMSu/DMLZ2JDD0ECrkpIwtcrygSaOisP13GiOVDgR6BzlEPdEg4+vj61PcClsXr3IuLVheEqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4870
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_21,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=614 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310002
X-Proofpoint-GUID: Ft0ApAVea3hqTtYCmX5DRB17QrmgkZ7k
X-Proofpoint-ORIG-GUID: Ft0ApAVea3hqTtYCmX5DRB17QrmgkZ7k


Avri,

> The rtt-upiu packets precede any data-out upiu packets, thus
> synchronizing the data input to the device: this mostly applies to write
> operations, but there are other operations that requires rtt as well.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
