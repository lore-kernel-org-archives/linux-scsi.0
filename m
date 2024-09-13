Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4FE1FC8;
	Fri, 13 Sep 2024 00:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187201; cv=fail; b=hThNG6X2wZuR7k8G6Q28YuYn78xcXt9gtc544GeU9nyEuE3iDVYlamvAYgULfhHLE+pTYSlRlAA8uVpjtU0+c066q7KHipXe0E57yDOFTf8XBEqjGbYp0VKOMBIERMShZpRI3ay45sTKbUV7XGSOe3/wiU9g1qIJWEX1Fmq7+38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187201; c=relaxed/simple;
	bh=kbNVkApEWSTPUSBvz/V06+AuccFTQuEO6N7C1VdeeaQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=YDR8dulrMeZnfUafY1K9lmh+Yxz80/i7wiUfs3Qgv0EcZqoqqGBWTWoCz/KOfiQ8h1uiqbm41ftR8DBvEgCoJ+mwnQ6Ndwz0G1qQ2e7UMdRrwIFs0aHJbpNEq3n4D0DmY6k+IL+29OhxhaxtSCwpxXdgr5f9tNqDfPPsBu6wDwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zv2yi1/o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jbSHW/pz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zv2yi1/o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jbSHW/pz"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYgW023293;
	Fri, 13 Sep 2024 00:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=2SnUGXbf1ei8OJ
	FrEH0A0iqCDQaPvt+KO4W+qXFG7iE=; b=Zv2yi1/oCFqujtwmepAvbOUzSi8hAI
	L10z59iDczGNARi4Sof47+0xrQECtLX/5iun2Es3PlY0qBQTXHTAebg7Qq57tPs/
	48mKYoRQlPXqPuA6tSQoG2b10wUVNCOLH9D0dYUQnVXtlMm3SqZBQuE5ai3+ZOm7
	dL8WLPyV2S640vTkPevwj1O7DA2FGXr4PYOkin/vTFaxByixBBKWZXCVS6m+dk/9
	gI29UwCeF2ZQVst7NlWJ8pREHEKhqE6AYsGM8gV1zjoDeYG5REg7x+3QA6iwqWCf
	kFGT46fn5XcpDZ4uM1QUchAJTfKwCjspncp85gVHLmSJeKm5cLxZT09A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d41xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:26:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CN0eqJ040912;
	Fri, 13 Sep 2024 00:26:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9dmsuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:26:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mHqv+EXAhPmf8oRrGwg5Pnz0l3eql5zM7XomPRihsCvKN5D8IIafL/XCYq1jDXqrkkp4rHuK/nhaaVNvWLKuh3O6ESoDBlDeOMDJZUdnA9Cdl8hXpMDsbApS8nKg4zkBDacT27uX93k2oEeJhu3ycdKnfnX6W9IIy7uUAERIcr7lwt6HrrvyvHS0XlwTp4wlGxuEwDnFlB1x0mXkFlG0wrmwZkLwHSgd9fHZfUn2/e069/fvIWRM2xlm1ks2aZpnaLuQCZeIywm07OlVTw93IS1tka4qbs8A/d6xtY6wKBXycI5WzJLC7ihGIKEtTud6Pnk7p5Z1jNB/YQP1VtSP6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SnUGXbf1ei8OJFrEH0A0iqCDQaPvt+KO4W+qXFG7iE=;
 b=DCLLzKmIsm0r2cxoo/MgQH//xQVy1XmOw2nJwZxs111cMyxfNeie+jmvO1tdCc9vhfePGgYP+1BAGIxtAZYUhikZWLqs6M6rq6JKX8P5L8omdy+Pvgl3cl/FBb7tLVQdWALU252l6ws2Yv62kHT++1Ksc+hHdy/5uOnGbUcOcZBdY9kCECdRRxRtAgQU3pntHGzjbUTsZQ02gX3fJZt6bMm7qG7YH3CDE3GpjZG5Mo3BBEecrPweUfHz/T+X4sTSovmUf8VhjRx682biakWwI+7ygdUs0QoC4CoSSJyszndVwGY3RXBOB+zh0Nfic4Gqv5VnfL5hOyzpP7z0FRLtAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SnUGXbf1ei8OJFrEH0A0iqCDQaPvt+KO4W+qXFG7iE=;
 b=jbSHW/pzovteJfRGueMf7OQ5ipUb/mg4LEphv4gHd85BCiZ8+QaBltOSFJUIMEJi4SoLI2qZxyUef5HQmDF98T4TBetD6x20/cjoRx034c1y3qB1Ns5L81Uhu/jTz6SaiGcfyEDqg2gjfeSgUJ7+0AAiVWwAJa3EIL2Uvd+L4nA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:26:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:26:33 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm8001: Remove trailing space after \n newline
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240902141537.308914-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Mon, 2 Sep 2024 15:15:37 +0100")
Organization: Oracle Corporation
Message-ID: <yq18qvwz9e6.fsf@ca-mkp.ca.oracle.com>
References: <20240902141537.308914-1-colin.i.king@gmail.com>
Date: Thu, 12 Sep 2024 20:26:31 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0906.namprd03.prod.outlook.com
 (2603:10b6:408:107::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: d1da17d4-bb71-4573-825b-08dcd38ab879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Bl8mzVsIoiddtcG4rUXq3njypLgQbEuDGUmahsg5X0Kf2dojAAHR3ocNXdF?=
 =?us-ascii?Q?AMzjNYin6kJvfAtoSfLw1mGXgVDg2aChe6uXwLc4Eoo0kIMng8ByxjaY4Txl?=
 =?us-ascii?Q?cGMVmrhWJv1RU/RYCP0CYwa6iOw9mlWtUM8Zd1YkAvAzppQdYzQQiZmomvU6?=
 =?us-ascii?Q?XkKcSVgB/jGgWa6TptZbC7PSKMSwFqLRNPNtaw7qm08qwooieqf4gVi0cGg2?=
 =?us-ascii?Q?jMeUWgl5Cz+9j+I11rys8VnaWOfFIlXAS+1AFwBhup9A6kDgFCesT01H6H0Y?=
 =?us-ascii?Q?Ely1aL+jcIpgOBrtOnFWsbR/EUJEIPTC9+KS/h13CefDGX5e3qbm6gwoflSi?=
 =?us-ascii?Q?pMrBSkDX+zY1g83XawQZlc8OaAdtXHM8YHNlVjF3z3rrpRA6KYTAwGiYrlFs?=
 =?us-ascii?Q?MzikzN2G8W6S/328k/YniZHELnsm/vXhrI/HLNVLAdxsx6rQn3VTIRTxEaxg?=
 =?us-ascii?Q?FBDyCRUb9JI9vnn3/XURrf3ghiJpHRJfQzWw3LgD611vZSVia034WGXGM3Vy?=
 =?us-ascii?Q?075/7TKEzvZR8cR6FTk4kjSl4gJyT4XmxMv+zOqi+wDhvtpw9QdgBJ8RvPw/?=
 =?us-ascii?Q?UUUDfW8uuePc3EGpCD44IprrPgo18lIq46ChGdV0ZUTj3s6Fpw47G+UbLjNV?=
 =?us-ascii?Q?lW9noZZHo/Kswrp298NlZfggwVKzsvKebjXqSUXtQaHkZlLLKWAiLN3iPZUE?=
 =?us-ascii?Q?zL985VE2gBAZMUviYYVAd+/Bkx5846utyVqBaJyLShNmtBRCLPOiMXP2cU/I?=
 =?us-ascii?Q?PaxhPZVT/3eBj0VwCdiaQIk+mNdQDuswbEX/KS0FBWqBLEK/hYsTZ/DVDHi0?=
 =?us-ascii?Q?pjupsH5caE2O/lVX/oCVYSR+4bhjSiB6EUJRamslYPQXK69DSu6ySEkvFYrS?=
 =?us-ascii?Q?F5A/TYUpJc8kQQYD9c9aH6SogOP9ybN9q1fwR8CeALEuJ6rpbc81AyAclRFC?=
 =?us-ascii?Q?Vz9afJo0mQU9+B9uFLpk3bWE2xua0KJ/tN+svyPQ44cXzIjcRgeprMJFYLw2?=
 =?us-ascii?Q?HkFa4zI0kFC41ijORfQHaYDYqwxSmPs8/1dG5XhgJc7/WiQdkAi4gDxsc54c?=
 =?us-ascii?Q?8Sw8TKoymctfgsPq239f69U8Nds1FG+j7RcNNtSkW0Fi05W7VEXSX6t2g6P2?=
 =?us-ascii?Q?8OF5JnjG6uawr6Q9l+m1h9cbOmPFn8Dmpy8OoaKom6j0p0V7bEBY6gohD5P3?=
 =?us-ascii?Q?uSjEGV999lu57ttK1rTEEm6oINX3acWI590V+xSH1G5VDRUx9bocDOw5NW+R?=
 =?us-ascii?Q?MuDsfUGk44oP6OdMiyajF/RWa0XLAkd4HrqJqoaFFeR2SG79/yOK7nqoC2RX?=
 =?us-ascii?Q?EV9+01X/5wvrn8Ta71WSMMNm3O2mh8nWjl9sCbnRspKSvA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4sH+WE9ceUcbHjUCv72gpQ4EMsryzxGwaMt58AmnuZ7S2QnAaCCWs9B+4umJ?=
 =?us-ascii?Q?5zM7aq3TyWg7poM6e29kA+2uVi+0fpUjcTRlXAgkQSoIvN2OtmOfv7SznhtA?=
 =?us-ascii?Q?iVEwl8Kkfh+kn9It0w0ZI2MAIbRlMygmot3k0mPez3rX8MexQxAh7uGU0uq1?=
 =?us-ascii?Q?N2CipBlVNMRd0+ieeCa/Jg8o5+A9YNrE65YFi2T29rvtMkgeaeoRY/sOoBkw?=
 =?us-ascii?Q?LxB8KB41uME8jGAkXW4wAvzBlR4wwvC7pJz+EBX6HtJ4utJKQwzQOePAG8eQ?=
 =?us-ascii?Q?5aRmnqvXt/Dl4c84imE3lQ5ebLEjHEVd3reHfA/R7YTDk0P2LmaWB6acQmVy?=
 =?us-ascii?Q?nyyisv/JLlUEIthgGEX237AP1ABVkR3jg46HNZUJxlHHxKbtt1V9oSijHnoL?=
 =?us-ascii?Q?5erkDoJRwUb1YckwUL1coTQP8BdaUKzOf1RbomLlOEqhT7A7X48CwLFyQuZo?=
 =?us-ascii?Q?bHge8BCwG8PV3yJlEBq/9KJRWA8oZRStquJ0VN0fJXHQFFuqcQth7iOKe6z1?=
 =?us-ascii?Q?9vHwu48iBDcRT6iKKp7dTD62ouztGpwI5r5JynkXdNsVZGhtY/2D9rSjg2wS?=
 =?us-ascii?Q?rAL8SZV9lPDhjg265MvYkV8PM2ccd7TTo3SjdrPLSxWaYlv3MBkWYCz9P9p+?=
 =?us-ascii?Q?GEuOlhQg3C6acycB87EBgdy8yAviS6rHr/HhIuQEyOheYhZnLAIbcsNwxvzD?=
 =?us-ascii?Q?BHA3qnJmlnYUSflYKlOicAjX9mtEAZTRN0+Pc0jY8RhYanPr64i5v6WVDD1c?=
 =?us-ascii?Q?uyJuwTXA2OfuDw+f+JVSUxr1NiYCWjIYLxbBBU+c/k72c44G5FDdl63I35LS?=
 =?us-ascii?Q?8PZNSfSJ3p9Igpf9jsopug3AnOqHp2S3bIg1ei3kSFIavCRKlMMmumWTOQ0j?=
 =?us-ascii?Q?x3QGxh71sd2lqZSP0BqSHcvy1yvwcgLaxBrs9shtpyEdQYmw70K1RZm4Swtr?=
 =?us-ascii?Q?yilJtiWS8bCbv2vtuKwWoDeRkOKt3meuCEwmYKkfHukFOLjq9/O/BDAvizrF?=
 =?us-ascii?Q?uNr4F83D0cHn/oVE1jyNhV99DdmEa7yU4daAyD5tIxQ8zrVP/oTwm0MzE1ao?=
 =?us-ascii?Q?cyQgJH9cTx2BHXeqSP+q+YiMEzvmo7zY1ukjIUFsvGXLZH6VEv4JCep+JeCx?=
 =?us-ascii?Q?yJEm5Ww7bl234wANzFKfEfNckYfJsTIZIX6qh8kA9fLtS5z8JNftDiJhhnnp?=
 =?us-ascii?Q?cT/blt6DTjZJU3HtirDdjspfRO0G4Bmb9u6jwJh9SL2QNYXvuaCbwBlhE8DU?=
 =?us-ascii?Q?yqPMJ/w3HO/ArsszsolbwfXDYGKPU8ufqwx9Bv9KkPKELy0qs61+Inw+fgY4?=
 =?us-ascii?Q?hLZT51IcVT5QRTRiJnfEQS/XrUIGtKCOxZYFLjVBgoAnGk5yk4IwXhc8lJVx?=
 =?us-ascii?Q?P4XMHxo4Fkwy6L00CtlZaGebdWhDnxT5TnXC6tT/NhFqEM9WdLJnBhM/LjDj?=
 =?us-ascii?Q?2utEsi0vTwCHDuTzOSp+bmrzzgKd2Goq8yKAANExWmrZk9L0b76H44Cetwmq?=
 =?us-ascii?Q?Z5dOs0G60zRs9TEk1Zpqa/bkzDdvtQMan98Sm1Rh6misiE8xtUzcQLkrcEej?=
 =?us-ascii?Q?IyjW31AtGWfUYAOTk+xRSEuCNT2W4GIhpfEkC5Z5M5EgDJc9n7hTe0KRXBOI?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9RMtOYGcbCq6J42gnia02j2qUpY3zQmcdVpyr/718m1AGvLBxCroSyWQeLurSulG3IXC5dOAdRVi7lYxw4uUOEhFqs28DsEv/qYCkE6SkOyRjIwYFKY8N3yttg9lrgMlCi53HNmxzlfWLFx7eVSASmWpiEfzrCz1vRAXhjpMK0VqOmshzWUg/OWxJxi1IOmMSeDoXfo/k1gohse5KK3EOy3LgfW6hL3TBdzs/8B5cpIFxj3wHeWYMNxjVcH50EqT/AYhygZkkdxJT96E0TYXwuayrMiE97X4G85HMcAB/fnvlmV+3DwzAKhgPUWF6g+Mn/gF07gHowPCrGGXOZBqcUhj+qBNQPPKVWYSi5JMUaTnMUYCncNAkCv2wEuZQAnsTXvOexRtjjH1nkloMxPnVjyf2IZAGHqtvEJXfLnV0aTzqGpKv38uKh/ngUt3yE2HJOKL3JLpm0/thb6UQ1+Gk01VJS6O/OawwcHd/9Ht2Yl+95vJdU1AEccxP1prmTPmlZ1h1kC5xw8PF/kWQugpO2ZmJl6cNcSjg/iMu0Mf+E/jsWBjZx7nYyuQFNIggPoe671VQFDHJq0imUdOmzspgH/TCL3iLzKSav6m+ktRlhQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1da17d4-bb71-4573-825b-08dcd38ab879
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:26:33.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKj0+so6Wt2Aiy/S0c3BYtQeZf8liDSyg12cYmSiU7icrDVUdqKPk/zDmyr4JwxSDW5AQQTZKyOoUGys9lI0Avp046brC/5tIQBefAauuGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=848 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130001
X-Proofpoint-ORIG-GUID: OVTZIDdauwmJcJHC9SiVF-ETovcGeCVh
X-Proofpoint-GUID: OVTZIDdauwmJcJHC9SiVF-ETovcGeCVh


Colin,

> There is a extraneous space after a newline in a pm8001_dbg message.
> Remove it.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
