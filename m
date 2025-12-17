Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4277221F0C;
	Wed, 17 Dec 2025 02:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765937652; cv=fail; b=JlZSQ7F1o+zZ/MUISCk1GVXAcL6o3SLY+4YxA5ldnjqI/sCoUivjAY3FeIsuF4gHvQQk+QjyhBV6vA0raWZdF5o3gs1GXfoQyc+4eD1XvpjmSBcVlCVDVFRS49y9yG5965o3NyBE2TiTiFSPoNF5CNu2UWjsmdsHiFK2/xru5Ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765937652; c=relaxed/simple;
	bh=IbwY+0dWU+UwJVt3Tmer+UULuWfnYxX8QkL0RyMe1zc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Xb4kw55kDHHiEMZlf//XSPwCmi8Fm7ey64C58uxaODUXsgq82bS29WAqkz74c6cgh0Na46kuR7R7GF/esGE35zE+lu6v6o0nOSiEzWXqmfDIB4YoNdZ3srwED9nxyC/arn3oIE4r+QdfG+8RWcXTEye/01LMJ/tbh6UjT/PKy8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jfdcnrP+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zopd/2yU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jfdcnrP+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zopd/2yU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uLck1588775;
	Wed, 17 Dec 2025 02:13:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VNw2BFz6i8M51B3Qag
	sntOOl/lwR+N08Bo2Uph0LU14=; b=jfdcnrP+dJw6BVDpN/wrd/lmMsLFH+mmRP
	n6ozdOb6Fm6GW5smI6KD85ZVEGpY3T3ShwqA39ctuJpYZ8+iL/SmTvVJgwvGDuww
	efTZwaisW/EBUsdKza4RN+uA6uVssXj9l6tydxSg2J3q0pTSeVqqCKrkiZ57ZzqE
	PVGvT/aSlcxD041gK2y5JHz0HY9SGcsMW7g8Eqre+ca7KWKjyfDLLQNMVzT7UObA
	ZAZCjvQDWRBj3NCVHR0W18KHPen4OE//+Msf0WAY+SrflV2mxxnDI4ftyLkRVUSM
	0XNdX2+skaAB+rsyOeFpPAWUWmQ5Wn2LYcAi13k1zkpZsFh5k7Mg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2d288-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:13:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH07cfo005877;
	Wed, 17 Dec 2025 02:13:59 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xke066s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:13:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q/cEt9LqNv2GCVId+yjtOKGqaW44/rN1UtSRLXhYMWOtXCrBeQejEGbCWiRvqOjjfaF0NDunCVWbqttTKlEl9H60QI4EswdUyC0wrd6G9fXKvUmAkzzmSrvhPRmmvnH8LyIjLHmh1GuQq/0Gw+l7qluL2ITXPRIsXvw+IApxvaOQVVlaJQ20CpiFhuzMsv6vcJOux1Zhsi2OTfF35mqyKI6BjGq/VINbvxQNRg75So47ibuTPJJChxqm2bNAVrcNadCEP5wPr5hMaJa5wI/fdXxl9BugYyEp8LUMA0lwjeZoPwztRC4LoGSFWnwqlH7VQ+9lsxXV27jIzkACS1F3iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNw2BFz6i8M51B3QagsntOOl/lwR+N08Bo2Uph0LU14=;
 b=LOBkdnLqn/tiswtNYpVsKgkMXwXTExBeQcECOJ/sFAf+/1WGxgEdpNK9NUrDIqR8IDBsEG0bBMokXmzUn+YakobjrnEyGed2CPY6AoGfp92RcCZYXwD6MNinQQvefYnRr3htlgnz+VRJDOAm8vt4pcO5aWXzqWg1H/seOdoGZU8sxZaOz/R3TT1TYNOZA1x+SX0bemkGXDHjJv5VkwVmbkwSLdGO7xiaaW8lAa1yBUkPX+WfnZGZ1OqWxDXPyqf5bnu8qB3+11GVPrAUF1alobqjNK4WTjp33ItUG2WTGtfVUuPrvLgIElJu640tFwNGysfSCgMZVsl3ZFTJ7hhsBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNw2BFz6i8M51B3QagsntOOl/lwR+N08Bo2Uph0LU14=;
 b=Zopd/2yU5tLoDRcbS0eTMfWCdolMoaqJrJAQhbplssOx1PoTa+BJEKlP2aD5k5KkW3jDCwNdQjTfQM9T228bL31Om4z4+FXjwDBOC5T0xho6qLvOZw2tW0LsaOauukykW25CXxUQHobQbdkKGDlwwSsTO/hCCR5w5yJVPq+UQaw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 02:13:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 02:13:55 +0000
To: vamshi gajjela <vamshigajjela@google.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        bvanassche@acm.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mcq: Refactor ufshcd_mcq_enable_esi()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251211133227.4159394-1-vamshigajjela@google.com> (vamshi
	gajjela's message of "Thu, 11 Dec 2025 19:02:27 +0530")
Organization: Oracle Corporation
Message-ID: <yq1tsxp6ejp.fsf@ca-mkp.ca.oracle.com>
References: <20251211133227.4159394-1-vamshigajjela@google.com>
Date: Tue, 16 Dec 2025 21:13:53 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0157.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::30) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: 5769a683-ee76-4e23-fce6-08de3d11ee26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VeEPQRJy17lhhmhNFaWIZ9cIq44g8xw7S8l6Jk4osPf+gU6HDLVBNd/IHPm8?=
 =?us-ascii?Q?Y17XQbZ3pql1B6Tgtzx60NCFBYu/PBK71xQDgosTrFxFm528SXXHeeKiBigL?=
 =?us-ascii?Q?m9xzU8D5uD0t8pC2CJg3BuEhKooca1Z6FUjV1sOQ7qLVl2cIDOttSFs9Db1p?=
 =?us-ascii?Q?6e7y9UGLHYQ65TGGODqRR6+nuAXmp9+RQh6fLykR71v6R8WdfSSbYBg06nsL?=
 =?us-ascii?Q?VpyYNxldKzu541ZIK9tomEniWqvRcrHyVMYJ8g5YzgWtPbpHem5yWesPeDlK?=
 =?us-ascii?Q?8iPSyT/C2FVoOu62avUcF3tpQIdZf5ed39B8NeRQwozkSnjj+8ESsajLg2TF?=
 =?us-ascii?Q?/03Tq4CMAtaMPLwQUGeZ58YAshruWTNCLiEj9BagHw7XtD5uUjSRaUyAHRFn?=
 =?us-ascii?Q?eA9yOuXYlcdQ754mzMk8IVyPQnx/xMJdn03+20920shCCmgqiK9YOpNuIeNg?=
 =?us-ascii?Q?zognkKGYvy+qKc9QXnDkjnKHKaGAvu1aICwhHBi+lKVpq4OkWdoucDqeRqmK?=
 =?us-ascii?Q?YkyOWw2hN1nkk3z7bHr0W8aC6te+mFgkNQ0mQEb8xOqJUpUU+xCFICNbmAiK?=
 =?us-ascii?Q?1wGYfD5Faspvp9MyZrwaCAUEyuxnzaW7rGPD898h5ORj9ANt5LtnBCoygcz5?=
 =?us-ascii?Q?bB5Fjl0+gdmYHptXLS+W9h3cCngAQwaMv5vMnQqsSdK4wVQoIEEGO/LLJlIS?=
 =?us-ascii?Q?R8Km50XKVrKR8xfNlTGQ+xe/yYKy7AZ9dNeipzwp+3jc6IgItYA5xPvYyzn1?=
 =?us-ascii?Q?57BmLDSRNemlW9B3S+eIWssVWgmwk6jWuIz5n3waQaRe3ZOKHliYSu/lm0xW?=
 =?us-ascii?Q?ZNMo+v7zulrRXa2UgjbILsx2xsy/6NDFox9vaUBGYVdrqNi9oGZ1ByCTt438?=
 =?us-ascii?Q?g69qV9yFi7Z/w9lQl4peibLJARYebCASdfemr9fKt/Mp0QUBJR9auJgxQNlx?=
 =?us-ascii?Q?VXMxLKzbpQksbH3nPO24q82SazXz3Gzx72+OwDpecgbWIWbmaL/O+/VkStu2?=
 =?us-ascii?Q?ZIml3isuH2IkY46gLgokl1XQCvm7Q8Wp2ZyMhP8wKQfcpzbjuE/AR4NX/7mk?=
 =?us-ascii?Q?VAksru4FppAFxiz6H8/W3ldFqHD7FXliZHivve+xyLkvL4w/O3JUtbj+IaRk?=
 =?us-ascii?Q?9DcptNOu3yU0r9DLrMepLkvMa8GjJUbCsG38GlB7tfndz4sOYfPvL273NyQD?=
 =?us-ascii?Q?Hum4vw/uee2ubcPpXMTuO4/TTqTvDxDzUdVTRbDbD8/H2VTlbW5ZUgL2ceoD?=
 =?us-ascii?Q?9w7GuK6H7+nygtsLzWHzXgHgEQIx5vFuxMZbYuWWpLjZFE7VWCpjaa0AIpc9?=
 =?us-ascii?Q?YCiPnF0pwvVtcvPnK8gvYslTP4b3l5eRmmW3WLQQO6w0fIORVHthiPgvm7hk?=
 =?us-ascii?Q?IOjRqY2C2zVeKuBdguXSvxAo9/Y042bHWeDJCTpTA+dUoZBWUWzWF4fpmfEG?=
 =?us-ascii?Q?SggpWbzjJkvdTaaeYyyJxn55Q92AJhLD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fYvz4Dba6XSlp7csx1wO7U92clo6j2o0zAA/z2ge7QI8IKrCovOk3XHsfmBx?=
 =?us-ascii?Q?ACLzvGrQdIq624uCIX9kmyy3uoOP4tcHOUIz626g/CMXA0VPZiVYX9PNEpuX?=
 =?us-ascii?Q?Kg+PJbUKJMA6/qusN06fZSSxd7yCElyW8L65Xg71oqyjDKMmu3CxqRC4idkl?=
 =?us-ascii?Q?7M0fqxMMH6/aGABf7MUEYSskOxd7VIpafRoSyetTedKnnqvHF/K7w2JasiUh?=
 =?us-ascii?Q?jDp8QQ8en6JllRllJeelnycuL/2GSXkYRWfUChB7RmLsHGWuUeVMEt1E9Xa0?=
 =?us-ascii?Q?6O9P6Rp5/w8nK/TfLV+kg/lazv7+0/y6p4lKGrUCf88ouyWk/5sTNtIqkDI6?=
 =?us-ascii?Q?kFJ/9MJDlqql0HqP2P6P1UM9jIXp1XZaU9YoNNKJvZedsR5/AjPl4ORgPEAr?=
 =?us-ascii?Q?XDkXFDju33Pa9HPkCVxmZq52b5XEmHjKTeZjAPhZNplp/Yxe2eCriq5kmu+I?=
 =?us-ascii?Q?DFPx1hDUnNTv/3WCdZ7YD2ik4Ont4QLOpsv0DWyV1JhgazFYOrap0ntQpyCo?=
 =?us-ascii?Q?f7SGUkNjvwhD9dYUKCibJw8XsBMnLBYS4mjcgYlfj90CyQOFMgW+SeLnSeL0?=
 =?us-ascii?Q?HiaJVh+egdqfgzHyOhjPaRrT7l84gJSJ2dYFpj39V8WgEBBCPERjnu3V6Wfl?=
 =?us-ascii?Q?KTI0H/aLoUgBXZkdo+NrD8uqY7Es45OuoRxdHTKb3dbpgcHDQowALxcA2i1/?=
 =?us-ascii?Q?+N5n/a6mEhHv8NcLjEtQY8i4evaTWdNS37Ggztr78raOIRTgKp/hwlFH6/ln?=
 =?us-ascii?Q?aYaCUFhOgmH+xizwzQZCpbIfgvuWkbzM3foB2I93Xao67fj9kAMFxt6Wey1w?=
 =?us-ascii?Q?VfZvCOAbdFIwiMNccyvWUX8pK/38m+47Tcwvrfki3qTexsIaFf6MDYt0TSdr?=
 =?us-ascii?Q?b70llY4zhRBKN6lKAmmU2SqtAfD244p34xuz5Ck9t1M2uukLNu8wudYHm9u/?=
 =?us-ascii?Q?sr0jQ/4GeZeYjVka9Mf8ycKypCmunF0gUsIi37GPNTmZ33PKZeAjKEChI7F7?=
 =?us-ascii?Q?33LmzkTrd1+Cfq1JPhq0q6Rr7xx/4Y0oLQaefYZSR5aZXhaq4oSGv9EU1lXw?=
 =?us-ascii?Q?DBNI9Q9xAJHqpRLzNn95+EFicWmQqbI7vu8Q/Yt6TiGLPye1uBuPyajWMLNY?=
 =?us-ascii?Q?htkCSQ1MqrxK6c4sNhiNkHYG76x5p8HePp1p0r6W9GoiMN5WcjC4drzm/5ur?=
 =?us-ascii?Q?KA2HWD+6Cbkw7buafSQnYZZuu+tBh70LmQeRZSAHtxBXqFaUwWllR+TlML7h?=
 =?us-ascii?Q?a0mgdKvmlhb1eR68dQ+SzJnF7ntGYVdFWiOEae/8wEN43sLXo1II1zAkvNpM?=
 =?us-ascii?Q?P/uRQxs7oSTWtDVe89jLL/oBlvCq/KO9lR+C9AprfdMSkSjtZZPhrLUJvgaD?=
 =?us-ascii?Q?WdqQ5xA7X8rN1hACFIsxRFCEHiriFLtk8bMTjZfjgbC65YZdDwc4UR8yML5T?=
 =?us-ascii?Q?urSTI2Zn4SWC6JDVqMCClKNdW32epDTkkb4mfMiAde1JPMw1tmxx7AShwxpK?=
 =?us-ascii?Q?YgghkH3quq8pzfFIpfgURUS0vZPIioQ4RYxl7/Vt0BMXa7S89zafSERG3Z9a?=
 =?us-ascii?Q?fYjewzZCKFu22ONcF7uB819EqPo0i2fXwhCA7NfE/oXZ0GSm5TcR9EIgwBsl?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BZJFLVFfAyuHR4n1zsi1lExMLoEJ7HKvWSwERKs5HJUKHghFlN2Ms3tbObz1gt/YPHkKpfVEPaj0UVlGyfv+ThgTEaBMQlMNH3uqAvtWwjF/POGO4coUvJddX/YIfjYc+18QaSMZHXO40Pg5thP5So+2WM7+7DtPbvMZMzWGzHKRJWkuWsLC7pGvmi7qtHX126z/21ZzoOIVg2qAMVooGegW4tEQbLA0eVcSgPHgvtCpnfMGJfXA5kTBV2rXsYQWXkFlB/EOuCzEM0SrWXQzyWkK562xVA6ipmUE09UibfdaWoiYe9dwoVKgzs4+Wje1pA9UxSrmAPuTCvvAtZu+KA+d1t2eNcJOx10ZMCauzhVvpJo4aoAsaoXfGmzOLxIaLUb5g5x+lpMJ6S4uGZTNEbkz2suKzEIAbpclUoWqq4ozqe8LjJt3wZr3ee8/JO/lQ6xLk9Pj/Nh7wjjVMRgoudGqbeKo6NLPuBywoa7938cJ4RulLR1ntoxWuAj+9rheR+xXEA7kx0VgV4QhoGvAtVpISok5BO0kLsTiOg+xRVzXfI59IEjWEzJxJajttqinkTw0ShURXwmIoXFnu8USWJbZlRGg1WmvoP9EkesA4Dc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5769a683-ee76-4e23-fce6-08de3d11ee26
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 02:13:55.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGEtANhIdMg2zxLsePyJIpRWJaT+rNcrebs5pB7mczPYbOvByyAt52SMVglndXgbAu8rQFVbWT0TQYvYsGILUxfEeygc14W6dcONQ+SMdk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=666 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170016
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=694211e7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7fiO1iYlDq1NB566vDMA:9 cc=ntf
 awl=host:12109
X-Proofpoint-ORIG-GUID: 3oA1iInQrpjPUJoR9qI43IgzJ6Fl8-We
X-Proofpoint-GUID: 3oA1iInQrpjPUJoR9qI43IgzJ6Fl8-We
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAxNiBTYWx0ZWRfX6V6/L4jHbjwV
 HdKuwcpnaaXdrU56ryPHMUEGFgDNFJdvP/auMitm60dFonEPNkOZRnUZWMlG7OlEEt9hi7DSaW8
 jsdsysCs13Ipr8TelT65ld4vcKywyPeLtmsKdc+/hMKOBGRqrNFf00lXnr7WcewrTjF4q/Vfd4i
 LuVgYezygexIX5iABKUhf9jFs3mRradZMD8WER4wNk2te35hFxZxXTXEz76x80bV/telC8P7MVy
 zGVSBUe44yowLNp9AYjhn2DDk/kPBuQNWbwIc6n5EiiO087O1BRPN6rZBuJl3Y+HjZenUYsDAqj
 fkby0x2wQbUZdXh/ckeMO19M5OYWOSPIDfPGiwYM4GNgEUY1kwElOSLHboyM4Y8/Bb6i0XqL2De
 M3c45zcbPspLTxoz5CmdUiRQzxN7rZ+iBlehXlFsIbObKoC95ag=


vamshi,

> Currently, ufshcd_mcq_enable_esi() manually implements a
> read-modify-write sequence using ufshcd_readl() and ufshcd_writel().
> It also utilizes a hardcoded magic number (0x2) for the enable bit.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
