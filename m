Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123111A2554;
	Tue, 10 Dec 2024 02:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733799219; cv=fail; b=uneoNuAR9b+4lFexdNYjaBkbVh7ch1TXTGC6dr9hEyLvwjZDQ/6MJUxGgCpjKlg0qe2uvNI3pEuInE8xlJL6KRtJyVx1XXv/p2vjmncp3iUPEp3Uc2bAG9yfU4fo/B/kklMnfau+8utRtN0I6J2Am0p/nvudI9OXxfdYji3fPdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733799219; c=relaxed/simple;
	bh=3u1c/TL21NjjElHPsPUsZ12XQxt9KFY8u2Jy/U8xq9Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kTDk36A9X/V5N7DT0c6wbIRvfBI+hnZ+imOitJc7C4ZNBop0Q3Ezuj33WYlRjp1DluO4Cutb6wgHbZNlG+T22BRBtLM1Yc8O6By/IszC37ZO/ptkzKAX5uR9KBpfCoIw7fpR1VSppHBCVdE6csj4xcS85N4AZDjXldvm8IMKuAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RjFmFylA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KS8etSIk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RjFmFylA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KS8etSIk"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1BuWX005416;
	Tue, 10 Dec 2024 02:53:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=JMZXxsXTGFXSeN+Azt
	A7YWu10Ae5ZfWVRMr2bJ26EIk=; b=RjFmFylAriZ/v1r6m3XOO1veanc5Q8sqGv
	4MBKTUxB3zZ8m/1AqWce6YuAn+RuzCmnOSK84+25ofUneqDLXmBDHPL6U74FFnga
	7mJamAVXizwiSXqGJG+CGAobT4t6vkkNvQ+A0VN9HOfnUZrDiu7BPIPCvrmG4+xt
	hGNbA7WiYQe1FF7x2uTdhSUA64GioGSa3aJibqROWtsyxc4AvPlYRrWVw22QofxV
	OB0salOIEWVMAOD0ifiz3GYCGf9Z3TmFGsP1KOF5Mu+M8B93GUhUNogE83kCdv4R
	0MB4Lux6B0rXgDkD+qaIcPWDf57VIhyVDSQ/v8BcWWhsmPE6p4GQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cd9amshb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:53:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA0x3Sw036590;
	Tue, 10 Dec 2024 02:53:19 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cct83m87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:53:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RG6ujeleCJGc21TZxVe/JMOSJulIMAsl0JIQ4fi+vKbxQ8d9uw5Q5eF7qmAx1MmLU3t4pGoj6Gn02rScyKOe7ojC/5bGjn94zRB1BNfgLyNzJmfnW/wLdGbNJe+3+XKaM+WCKsr/9ITAZsIFd6qQQiysuUTpaGeMlxbkk0uYT/iM5uhEqHVnpd+hZWiLMF2qmZCP8S215iiyimgWbd0xhOnAiRNr8ho/lGW9lO0ITqMqJmxcJHEPcZyNl3l8zYjWooSynAqrdPVJ5iQqmbupNVLR8nCCm0+zshzQ5JyP+fGKn6NFAWKG/0VZl1DYQ7BjG1Sm0kCcUK1peaona359Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMZXxsXTGFXSeN+AztA7YWu10Ae5ZfWVRMr2bJ26EIk=;
 b=AariigGBONzzri0a0aOoT3GhMQYybkAbsJCISDpJhk9G18q4RAqvd/OqSEN6gaG9hvSD7AaGevg1G5zReFTyaBpt99LI3UZ2VLBMn67mXpsGvnBPeay7/XGMOInN9rvGWMoLB9I0x7LKnLZyhrRPnd84qxU1krSRaBUlQAWtkt5R1NRUu24iqFoRgATWSFMml3uGtkJUOpJDfF9IsKdgAXVVxltxCZmjlw/9As1xFXCGCYuzZvIEqiNpfX9KEPOKI+vWvN2JheNghIM311GbZgrdgs0I+9zEk2PfZ5KnhhccfH6MnjMCCcFFmSnT0NFw7dVIHSxhC8NKUnR26Jrv4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMZXxsXTGFXSeN+AztA7YWu10Ae5ZfWVRMr2bJ26EIk=;
 b=KS8etSIkYtR9gwy+vQl/KX+P+gANe8dF82c2WTz/lVNufZTVDRJTcQ6ZHskxSNaU6Xm6xc+i6ODpw1OQZBFFo9UPObaMuiT2ehtwXO5KNIFpjety3kpPfU5PjQCjxM86KG8rlxxqUo8op5QJid6pZbKdOqP0mKqldqvGsn463KY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4683.namprd10.prod.outlook.com (2603:10b6:806:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 02:53:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 02:53:15 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, Kashyap
 Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: eliminate scsi_register() and scsi_unregister()
 usage & docs.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241205041839.164404-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Wed, 4 Dec 2024 20:18:39 -0800")
Organization: Oracle Corporation
Message-ID: <yq1h67cjlkf.fsf@ca-mkp.ca.oracle.com>
References: <20241205041839.164404-1-rdunlap@infradead.org>
Date: Mon, 09 Dec 2024 21:53:13 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0637.namprd03.prod.outlook.com
 (2603:10b6:408:13b::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4683:EE_
X-MS-Office365-Filtering-Correlation-Id: 9449e5ee-ac95-4d54-14a7-08dd18c5cb1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p8TTVGb+I8h9eAOiT7wQN4RK9NtpjnT38dqKRpTXS8xXEyz1PKCiR0AGKc0t?=
 =?us-ascii?Q?KG0Lt8fmUvIze5pJqmSEhRgwtEhYW3yRjrqlHz9FQ/d/xO9L8pTItiPRM3y+?=
 =?us-ascii?Q?W4AlfoHQiCslml0FkSNQRPdzehTHxS2HnUKiZ6ZqPKdTTZVYvaPkCtZX0fGN?=
 =?us-ascii?Q?15q6S41ukJ4UG7OkDw4NVKagLVAW9izS/NkBov2eFgNnjIW1/o1VGtV/uoId?=
 =?us-ascii?Q?AX1KMzSC02hCrd1FOPW5o3NGWxuCihp0N4yx3VKbS899ffaCBlSXHnBXTaW4?=
 =?us-ascii?Q?rh7I2aRjQ6+TFKv6nYpBoGP4YlRFyV0ByHVWrPyRhG+yQkQ7PzTLNgKGL3LB?=
 =?us-ascii?Q?A8R57SsRiRAPxDWaktiVDFBc1gMvroZzw4GyIWeylnHHPPy/QeaEs7kvzzYh?=
 =?us-ascii?Q?jxfn27p5SOz1Dj/9UG6hd6tuPEFZ/tw9hQG6ABW4jdczGYmrf3Ls2fczzivw?=
 =?us-ascii?Q?/5IH+zm3EydUjhj/HQ+9VBN7uoh9n0kf2tvwLwwHw2OMvy+Sn9zvAQ2zQU3S?=
 =?us-ascii?Q?gYxCTZucUogdjOvg3qJVPFHQLZ32o2ip8ZT/PNdkT5pdfkhRIIzanCQc0LP4?=
 =?us-ascii?Q?injAsXYyVU74MUtO6Se7rsLx7NINqewPpEmRFHbsAiIsxMjorrrNAGxMPRns?=
 =?us-ascii?Q?UOt22aPc4qzSbepLlT0ZTbeGeNc551upGZJ0V/7Ia1PUK7H2P7ncwsHWx652?=
 =?us-ascii?Q?3Ye4AY5NbebX4LXR9Wu256iw6cnMRHtlpgxpP8u7oirztRIkGGzOYqucw671?=
 =?us-ascii?Q?Mr894AKz79dZmLr2jJ3sFceho/PxdpJ52pRAz3VBd/+UJXk2uwOLCAr3swjq?=
 =?us-ascii?Q?n0eeSm0Wi6MwHjvhcVvQKjRLHgteMmEMMjhTm1KKH941/Fhn9R7NknRItIv0?=
 =?us-ascii?Q?awyXSp/ufQGRNMk8LuHs5N8AXfUdFBqNkzMXpJKeQYB9vBbjADxrozcPEP86?=
 =?us-ascii?Q?g1n/bJopn4J9suZPY61PQZO3c6lin2BZ6cvNB7pojM+OOl28xJnhuzbhcJ+h?=
 =?us-ascii?Q?hmy6yY3tzaYKPtmScd+CSNYV6Ua7HfpItSNzEGT9NRfb4rnEw3+PjHTvvHjL?=
 =?us-ascii?Q?iNP2gWn1iGZw8RoVeVISoLQjReJz/C+CP7nVwrJ/0BCw91Hs5J7b/m98USIK?=
 =?us-ascii?Q?FAiMXtcb3O6ZJULGy/ZBUYE82CcxlaHsPvjGuBenJ2DOETP4mXIuckpD/HwS?=
 =?us-ascii?Q?Lc4AhzD9aq5vfcusOzaH6FWrqZ/ixMjC8V7SMQxUJj779aqka0FmqPg1FuK8?=
 =?us-ascii?Q?HeyviJZuRWm+TmsOcdlU76QVCSp4eImbNBWkCvjJ7Z3W6wZD9gzmaLi6DAct?=
 =?us-ascii?Q?ygEHe0jtcFkeqhf2/6uSPwUSiDoh6sGv8JWwpO6byQzdYA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yT4K8Ybnf6YtlzqwQRlMs52au8Bi01VD5fK1PQ1u1Cs9JC392mOM+yicK6bG?=
 =?us-ascii?Q?MkVfZV6I9bHwSKj/3bTT6UzP6wPbcdw6u6H49tTCU2dSa5K7mAj+Wlo0u8rc?=
 =?us-ascii?Q?VXf//yxfNVracsH+VJzKK4/3LamK0qRB6MfrK7Jjd4UimuPYbYjx4ycx7cE0?=
 =?us-ascii?Q?BDYFIt2+XWNUvPYpgA5pMnn2H+sQ3YQQl7ssObKPXIc6qpRol+Kc+GLhmShj?=
 =?us-ascii?Q?/owg2JSlef4G9y5/lYqHVJ6ufjEaFD/nvoONWSkxdRBynPGIHh6MOR6AMe7f?=
 =?us-ascii?Q?rhBaZXSypwo9S7rGxEzAMnUhXcbNS8mllULwMTVoxFcrbwx90Fxt6EUdq6yk?=
 =?us-ascii?Q?1VlsaL8U6rnFWMtrRMjAoi/kK274XTbUhvPio/ZKkradv6L5p3TT9uZQa8pS?=
 =?us-ascii?Q?lypgkAnFolvcSnm8zM879qlIRONnjYlColKyVP54sRljJeWLmwnWxDRV7XXi?=
 =?us-ascii?Q?Sb3CZSUJvJH2fAeCl1sCjITfodDQ3sQVHYCIkYyINtP8Q8Ej500XSxcIhRxh?=
 =?us-ascii?Q?s1aZwYOzfvrxIt749knWSv8DFU/3gLSSwrTapZ09CHenm0VmL2PC8gb+7EwZ?=
 =?us-ascii?Q?/YMGVBlFCo2SzkNBSFzS1nBXO+H3VSnADxqteGqi185+cc7o3WtIbvD9K0Fl?=
 =?us-ascii?Q?R/ge2cA01oK8ABYBcd9Ixf0gRsWlXRguLURH2TDxZQ0B1FEtQMeBsV4mItiR?=
 =?us-ascii?Q?VWZND76FyXzCV4pR3/s7TULcyuTkiZG8lfCwRsrcR0LcJQ0tbMOSWNZRnc7y?=
 =?us-ascii?Q?IjWsbh/DleCXMmY/AUNQmBViP8Z5FaUb8IF2fB0KUYGqyvtJLJk6SpGpeiIn?=
 =?us-ascii?Q?X3i+UC/8RP5hDMl/Q7+GXS9z+nbT7oqXncervSuTW9XXWew0nYr6BTtiKln7?=
 =?us-ascii?Q?4mn0oPeCbfQQhU09SF6L/QGJxD7WxSw1W6xwwXILHhcTDDBTgYk7iz8Xl/0t?=
 =?us-ascii?Q?numdLOleldZaPqYzTtimXidYZnVmavCfKFc9j415Fg4ZII5YVZp9ETBq2Mmx?=
 =?us-ascii?Q?C7gjDXfrnKRt02Hvu54Ibjd6UlHLHJoFj6fdajuw4Zm1hmiz9JnUQMi16a+F?=
 =?us-ascii?Q?Fmo2xGNoOSXpnIa1UQqWXf/i+XnyEvWkxaWI9o6Q/OMVCmfinlwJR6RQsSEz?=
 =?us-ascii?Q?8MBxinHxuTjjHjrlveiugDyndkmZGNkjtqIdFSnUmMbalMYd9y4VXQ1ShbeC?=
 =?us-ascii?Q?4TzVxie3eOkSQLniZiAAe8y20ERUfCBU2Je/3Pq+7aX2jwtqNeGIzDaFEx+w?=
 =?us-ascii?Q?Xzc0N1P4wlcr+V8V0O9lUzRw7yKiENbwJkEQsnkHePnuHdkibH/bcmTomQ+v?=
 =?us-ascii?Q?wVOQUsKpX8bD8B2LXpo0lo8sZUQUvacGeaArzMStWNBCLT41UZxT/1of3c3o?=
 =?us-ascii?Q?V7a3ccDsmhMABHk4QQcz/NS3QLkzM1MRrffuie/Bh5FVUeJuq+T9VQXTD5eK?=
 =?us-ascii?Q?CMEhiykMAQxwzuEJHMQvqmMe9cKd0Ms0TyCqzMQeNEY0Mfhl7o54DB2m9hzK?=
 =?us-ascii?Q?5050WgAmeREg1Tf0Lwe0jTBjhu+hARApq3kmrPcRxHFCQO74ElZtieJRN3j9?=
 =?us-ascii?Q?0WuHNoRBlQxPF4bOOj+akXSzkYayPl9JnNpbBuriAg49mTp2gd8dQn4En05y?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F5axeHnkyQfUI0HeTGh4JxvCDRdAcGBtfCEF0PlP1jp5c8Q9Td9DWW5eI9cTQ+z7JGzP6YjVaOqvQ47zZTxcQYruB6za/yfF+WB7xgiUj+gkhulLftsefBJ8uKNo8kaOE6RkhzQOfNAZnl218asyew9P1grxUGwIB55cKq5RLm1qAyD0MZNT8GQoZZ9dbmsLmI9xuikv2L7qA7dckRIHPHitW20yp7J1/b2l/v7fkvwVOCxNgDbedKEK/Nai/tle8rG+Qbd2nlZEebXuB8xydZ/JQfbhamoqXkru7wqjKrizdop8RwKwQ4vkyMeeo1kZFy2PIJDpmtaGFj7ehz7ThA+s+vsQozFXdOr8DwgtyOTh/eXkT6wAUdnjxaB6JRQrDBV8uDslUMd+o/eHKylyjW8nIdDYcq06HH1EhBnBHlByxtX/LHKARlM9Q8iFnaBJb11jWju73Vny+RB71ZNk5WmX9B1u+Z39sQerYUrXGBUd3gYhcKuhMNir+DvAf1J0maoMZhK9KNzfa1+BSo4UQLvW1DAD5wb2kmkhU23DehQWT5sd5mjhHG7/YH6PC5jzzFvd0OxIVVfEE6juOLpdUvCasMUOOU4uKgrmotskg7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9449e5ee-ac95-4d54-14a7-08dd18c5cb1c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 02:53:15.3721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3WdYpPT/zzxo3IUihXevAMnDCfVfyxo2zTtmHC6Oj5YwFU2j7JKzGrmaFNMyFvOy4qb3Nyx+dGuOWLbbGpEfXj+fGx77+O5KXkQ/j1FcMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4683
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=686 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412100020
X-Proofpoint-GUID: Mx7cepvNtMJRfDAEZ-C9tNG2ywVL0X1q
X-Proofpoint-ORIG-GUID: Mx7cepvNtMJRfDAEZ-C9tNG2ywVL0X1q


Randy,

> scsi_mid_low_api.rst refers to scsi_register() and scsi_unregister()
> but these functions (or macros) don't exist. They have been replaced
> by more meaningful names.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
