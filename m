Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6A226D4CE;
	Mon, 23 Jun 2025 17:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750699086; cv=fail; b=nGFVt2NHH5wd4yGFwNPgIIgNpDIQSzeU9Wp1vY5Pm3ExhIIV2cvwfg8oZNv4O9byxJ10LeMy6zxRLDH4ryCc+zLgJZTcdc9qprv0aVTFUSEFcOMteP68AUOJ4opVtFU9NgSEqKWMmiKqqkswc/cg+9usmeqBPdKCLaLVsNNDPso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750699086; c=relaxed/simple;
	bh=aRS8F5kHNHx31xi006SUUUBSMqYvoMDmAOR1hHbvQFE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hSIaJyUVoqBc2GV/qxR+1S6OqPEc+aqLSEG/oLaZWcsIIJ7KVk0ro6NMO+7hAUeSVXNM84SaSD65JNfJ7OeL7/+h4GCi2h30Gu+3ZME+PW2Q/4ZLfdRcjrKdIuKdclqWM1QpdQLr4l9IQe61E6IiGKjU/aWH4fFReab4gWQI1v0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QVxlWtdM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wxJF889I; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QVxlWtdM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wxJF889I"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NGXqv0017280;
	Mon, 23 Jun 2025 17:18:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SoarsLlBHtOc7vfxMd
	Ix3miqNrHtg+B4D7NpbTDn+Yo=; b=QVxlWtdMZj/YXUO3tI5UDy9RiZgHsNyhBo
	BMUoDqrNAynXOhzwGVAuvgyTeRKpRIOmaGMZN2mNlQF/FhZrHMnBCob3bj04aFrT
	5ExWarj0Izkf11cXkWNLDgWM2Dt9r1aQdeZyKIwzkEJPXdc8GL3pkdgAddtpFtCe
	1RHkod7I1SfX5CZXlzkzSRItWK331c48Pbve5InO2qwOIIY+ucXtIIu4uQi/IYnp
	j1W/9fG2D4sOYu6OxfZVv3NyJhFwMPnEmfQtjgIok3JmvtIS5amcx4IAayjyAjPj
	gOpzFSqXTYXk8O9ncq/eyb6bpDQfDFEJ6p937PR9wwQAJxZ9iPUQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8y37s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 17:18:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55NGeneI038948;
	Mon, 23 Jun 2025 17:17:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehr3m3ae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 17:17:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2zWtQttG3kY6RPXUmHy2Ufis7GhzP4SV6rxnavdFFmGXvpexDncQuEZRXE3QRAsggiw8CA9nzl5SkqOWfJ23Qo39RBuzNM8fP96PsUtITsXCmemqCxD/QJ2m5D3VX/DOSZzh10pc5Jc/4dYJaaYM9Sw8IYM1Q3zIhaqk6Xv5xKSbYgW4uaDtfzNgsYBWo0ZAzcs+2vR1kUKWkO0D7WJtqiquImq33NO/S4j61gc65Xw69mQPBbKrkFCRLErSbaFKrb6WGOIzeIJq8ROFt9NipvJa3p6lnxRhLZh081yjz4+W40/UOxAhjHrlCCbhj45M5PTLXE+lhGpVfLUTjrHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SoarsLlBHtOc7vfxMdIx3miqNrHtg+B4D7NpbTDn+Yo=;
 b=O7GejZgdVptUVXO+cw5rT/rxWJO4ZHA6ep6wuowYWAwYHVcmIr6qLwG96MCAuQgMxYmpxav1ip7uOZdiUJDc5bamnf0cmdeHH77bOjTbYQumcHY+7NVwjPg22tflZo/FKBiqQeEGOSsU7uVZEPb1WCCEX4UlnNd1wH23OGfQm2pianIylPrPFbGYuFmbcXmu4uV+sHMN2vV1EsojTQXTNbLEqu0ooHnndNFlprxKxSuJVkOEfB2JcMIIwaGPYRwvsaeXMUb+pjrh0VqQ3R8l6clr2bi91tEesBF3QNIHf6vxMhOBKaVIT4ditf9FZlQuBkX9DeE2bYttV+TXMu7Qvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SoarsLlBHtOc7vfxMdIx3miqNrHtg+B4D7NpbTDn+Yo=;
 b=wxJF889INfGPeppfeq8vU8w2pgDua1SDE40rfoCwqoSchgrHBD5VNFw2TudIY8bjO4opyYszyNXi+CTGnIWDZgk28YpBQhOv6KKOBXj34MYFTXTc6hR28T/6v9FqIeXLZ17F3JDf7gJTBF1h/8OFJwaxixh2isjcZC/Q6s0o4ps=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB5986.namprd10.prod.outlook.com (2603:10b6:930:2a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Mon, 23 Jun
 2025 17:17:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 17:17:56 +0000
To: Salomon Dushimirimana <salomondush@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: pm80xx: add controller scsi host fatal error
 uevents
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250616190018.2136260-1-salomondush@google.com> (Salomon
	Dushimirimana's message of "Mon, 16 Jun 2025 19:00:18 +0000")
Organization: Oracle Corporation
Message-ID: <yq1pleupebs.fsf@ca-mkp.ca.oracle.com>
References: <20250612212504.512786-1-salomondush@google.com>
	<20250616190018.2136260-1-salomondush@google.com>
Date: Mon, 23 Jun 2025 13:17:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:a03:331::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc5d9f1-2fe1-49d6-c7ea-08ddb279e53c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DRlcd2UpdTew1u2VP6kNpr5Zkp7zaiTE33oj/AfCuDlOn31HUb/9H+X6u+fc?=
 =?us-ascii?Q?A8zNr9k+yDxituU2Bl3q6k2Uk2cTGt73FV9XUX7c2V4LkXnYLdxruAwXozrM?=
 =?us-ascii?Q?r3Vq5R3SL22AEy4JZBEcIkRxhyyyU5ifXpnVJDnLB5Ba7Aqg2LnwEPV8AHGJ?=
 =?us-ascii?Q?io2vogwT282g2MBmNjoFClitzMrjhVBSLODj1233xkEEu4ZE4hLLaOGsst2y?=
 =?us-ascii?Q?+JleICZjR9edIwJEXohqPDWkd1aY/SHwr4kb1Vk8+uDPcPilPxzVf8zBcCDF?=
 =?us-ascii?Q?cBgYACKpxvkHdlfj0Dj5qJmejDpQupwYKM28ZdlMjiTkj16h9idi9wJDNw4U?=
 =?us-ascii?Q?hVI0DF2PjgrSicAj/wpL2t5qCCvJPrsAqmg8xer7yX9FL/O82KPm9Rvuiniq?=
 =?us-ascii?Q?tTWjuhJxvvcD1/QwT9Cwox1pg9nl8gsjcarjX/4ZS9cVS1E3h8Rl3Vxrc6by?=
 =?us-ascii?Q?3hXj7J3SzwtTSnP/iul0W94kMGg87GZqsx6hl21rg9Uc501xckglQ2/A1IKF?=
 =?us-ascii?Q?HLuQ+0GZMeRjt+6J/CCH9Dd46uf+AHwiDPu/3mFHJN2flGpjqIkBvhJSj5mC?=
 =?us-ascii?Q?OKYztq/8XmAp+r/B3OPOSM0MLTfaIy2GRen9F2KkRtCYQEzeWFCYHwe1MdM4?=
 =?us-ascii?Q?gcfBCaB2hO42FsfayUa6AsvBN36Ag/Kb7gZbtrN35y3BKf6M+G3FdTrTvN7V?=
 =?us-ascii?Q?IpG2NMnlTzumCScMutPiUngaFnCv8hulh7T+WIp9Mh6YOu6Bf2SosURZ5GPi?=
 =?us-ascii?Q?ozS/Z/74vDTFUL4lbgCFw65QiSNQwHNxscIAHOrGQtk1Nz3YE6Ba4236AO2+?=
 =?us-ascii?Q?DwRsmRpUPF014UHtfaAC7Rr6zz7W7KpCG4xQMTersQnztN1euU9MS1duoKlZ?=
 =?us-ascii?Q?U5WBKaIWISd9YK/I15w085n51B6TkL20FHJ+ssGo5OFvEXU1br0UN72DRige?=
 =?us-ascii?Q?wKOzVW+Y6BCHhgeD+rSDChsGRIEGJQNhlGYCUpsZWUw2GfBYig1TkDR/F2XS?=
 =?us-ascii?Q?IUETPpcKpSG9P8wOA0qgQxW2VvLLBWNYnNKqKpBp6IVkiJAt5+0vG9uc5z+l?=
 =?us-ascii?Q?dcVJrq5MkYF6klj36eLhlaYsjMcXoICD6SpGsdBqf1M5UNjgpflzUofwEAHT?=
 =?us-ascii?Q?qhz2Uc+cZ2LJb3PTS0tiunCg1arJkvSULn8bF4tNby6ar7TL+mTk6MObx/d9?=
 =?us-ascii?Q?jGuMqe/m3dZxp+4We5WT2gq6TdX1kpX28+XvVDhCNHuPZMigQoi+g+EXv5Ft?=
 =?us-ascii?Q?+R8t+S6frv6N9Tn6m/RO4W2zWwBClgRSlZQONPz+GOiKWH32w64yqa9pII/l?=
 =?us-ascii?Q?A/UEx/SrACb5PoVj+fByM+Lm6R7xtVxBh6Oo0Xgmd+lpazxZWM7JczH3Hl7f?=
 =?us-ascii?Q?rI0pW72LFsxz3iBpA+mLgG2E9F3oFZXLHy6uWOGwuR7a2xUbxqZaQkq0Dqng?=
 =?us-ascii?Q?5BYW6ep6wO8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KKTpT15qXAwSBMPMM9/jm5Hx16mzqtMDaIrFqaPPC3TPh2YNB2nvHTlfKC+B?=
 =?us-ascii?Q?2IgXnrxIIsYsJWRzr2rxwdUq5xZ6UZMapmCAb/iagDhXlQRbQVNifJX0anUH?=
 =?us-ascii?Q?rnKLWNlpIWReBlu3UDmkP1tOIXfSS9yHKyEcgRc/l6/CBpbJadZ9hhuhQouW?=
 =?us-ascii?Q?1l1BIk/ibbsTIGIClrhSxFctyXJJaJNDyvZ7klPJ0OyC3xnO/LfeQ97SFqNN?=
 =?us-ascii?Q?x/eLVVlagXK6hYBfXwycrFMFRx6MpPtJyhEl2HWOOfjcFbVJpnGZ5aBXTdxE?=
 =?us-ascii?Q?ftf3TZak1NBnikn4D1lE8TKLV9xnwetKb50/lydW8XE2Bbq/AwvmdW6wMc4p?=
 =?us-ascii?Q?AZznmNRhEphhWDHFM3C3sCQHSiTCWIfjM9AiLdt8XSKieLaNEaIkQTvn75/M?=
 =?us-ascii?Q?0ymTXq+PrPPP57pw192m3qtqFqShuagD4Psm7/sJ0zJ/FO/EuOTiGrGhQONG?=
 =?us-ascii?Q?fFxAsGw8dPv3LHQ4/QJ6fA6XM1s5H+dANMpyy9PFt994rqAo2OZeDCTXo5a6?=
 =?us-ascii?Q?MToH//khAJqo0CHTE6veunuvmgu7INz1uawdSZ0oiB6tsFBaqBExxWcFgSRZ?=
 =?us-ascii?Q?XAPgNHgZf3yMNB9xiBUxHg7u/s07Vnut6070gfMQRFunUzMiUy05U9AJjVcw?=
 =?us-ascii?Q?qh4eUIb3T29JhU8l362UCnKswqfWsrE76s72FDdHr9twoZ2uSsNZGQL0nFaT?=
 =?us-ascii?Q?BcqlMTLX2nkSYABimcMYOnCfKqU98sq8TfPjiSY9jy5ng+NDdlOVCLJovttD?=
 =?us-ascii?Q?6C919igXzkxj2DQU2cjlYJxES46BHQjpnZINwHTy6NU/5ERmXZTBdxE/Dln0?=
 =?us-ascii?Q?3pbE6LuN6CDaeeYl5yiuFiSS/Y/X5KdvvYbg0XsOQP4lt7f3pKvp3tWthqLJ?=
 =?us-ascii?Q?pg35o4vHYRUopk7+8i4rUXae3rGWKwkFVw/BQqDQ9MNk8A2GzL6DndeMqvMw?=
 =?us-ascii?Q?3PSNa9zff4/RcWe5It/WHZChqYcJxjlOQXKBsV9zmMQPSJnJQ6H416Pgx1rC?=
 =?us-ascii?Q?ItunEO5DYZCLAxTrBWffzoTiJQTDBkLrpY2/4y0xVHM89N7BOefhbWOjaGUt?=
 =?us-ascii?Q?JGyMcfe46fN9pHXrrYq27T8cXyiNWm1DmpDEzaeRpFcsWLW7SaQQJzUb3Cp4?=
 =?us-ascii?Q?r/5ifzdz7n6Msb2Oyp3lW9SwRBJXxQdT7JynNnp7ZO+302yRb1pQVfjSOzTl?=
 =?us-ascii?Q?Vqgtc8b4rFCub98mjTwmuIo3YKAHpj+Qroh2yzh8JjVtoiyhvw/xB71gLsur?=
 =?us-ascii?Q?ChX3Pv9B6N2vJcMstBfRNgyWhAUxYToAudGRQPnC2abV0N7fp0aWaLzBIi4o?=
 =?us-ascii?Q?IfAbQnX1Qg833pOpvBssNmeblcsHcqXCli51Phq9rVegHzaF1OZVngnkiVbZ?=
 =?us-ascii?Q?nZQcT4PhTVK7fE83a2t/NBTQ+Mc2JjxwC/BGjCxrBpm0lCRVHOE+EcbzSzvz?=
 =?us-ascii?Q?ZUoeqLn1frNVZ+JPGkP//Lj4C63FZHCtYn9ekSIg3Lt6vKOVzRH21ZZB3xXC?=
 =?us-ascii?Q?qB/YbT6XjjvlEdLZJwDn4yXQ7jD4plrr2fZz218vPQ4PY7buvHaPep+hsokt?=
 =?us-ascii?Q?dgU1XRaR9eUm0fFcLfcqY8q+AZZSeoqxylHhteY2QRjd4UfzJuI0wJ+kuKAz?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4cEx8qo0saDBxXrQYCtLirsqH6xQ3iFCgLBoJTXvXwt0Oqio+ivsAdpA64B85ZbVc59peBukaL5agl1lB98IFxGhMgAi1ZUcncLYXESoUs7nvjQrR4wPfQR/L6O9CqYai0ovfxO7aXj0ECpssmr7DjftnpfnujIwnivSYLyuYHyOXOQQv77rfPB+dbJ1mz0GBuAM85Atqvi7exUSRU/C6uAb6eQloEDyxL28nqQ+OrPacQksvGFFNntsoEEPXHz5jwBwEZ4vS/edFSePvqs6ZmgajMgvKEyv07iPVfxHfQbRLYKJxUqNvUSgVZaBiToapLLjJlsl8xPFLQw71tKTKYijU6gRez8/DoEM1Nj7RPRRkQ2qv5h3dFG81i1FoTAFUpPrhpxUhvgYFyXfw2rtYv12XZvYsTQm5rAnaokNSH4zUQHD3ljdRYiSfj6hrcgCsX14e6HeAO0KWw4v7Glix2ykl/Acf1m33EkIJ6HDZSVOfKTBPwAK5eyQYZbPg8vpEJiZ7nNeGqjKfRzbM4wHDIEglYw1erhxKw5gTmyDZVoLXIn9wBryAGqFUHu/GiopS90vMMAfFXgUiAXlfdhIawXV+RmdCvA2rYbA33P1Y+4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc5d9f1-2fe1-49d6-c7ea-08ddb279e53c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 17:17:56.6948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrNM3SKjIr+5YsY4MPW4IOr1//7up7d+5YcJ9paNaLYOLO+vMhWl0a/73gbzYvz7y0PxXCEUJ/liFn3Ed9mDfECLC/SZHryqBrcqG6cwh4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5986
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-23_04,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=961 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506230106
X-Proofpoint-ORIG-GUID: p5i15czXroEpz1FuQ8ncj6kmdNrFRf-S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDEwNiBTYWx0ZWRfX91dVK7CyrYa8 78gPacYc5MLvLCt4Y7BG98d4vLviYvZJ01wSfg3KmQMPePVZmALFe8s/5F43M1OxjsXxsJG1He3 KdWCtaFiFDPrd9sa6KINABJ6VUkwKJsTbahw51cd8QWvXhNa4HGA4z86mQz9bor7Dxbk/6CBdS3
 9+SUzLkHCYX4jkojfpMmPadk+RiM7pXvTdei4RmpxJOfKrTbQ19lm3l3GrIPmC3nlOS+Z21xXEj OdqAlgLPFh4P0JUWLBJ374lykqwbF4uu880cYXTTW0qf7L4Ybc+D7RYt65ttjCXZD5PdrISOiik +eIdnrE6fVHIGzApdMsEozV3Z32PWnayJ6pu5YYQrhTAhA0CTHdOh4fPJnrGND3TZZpAvkB2ioa
 PAmlGmV81XyiqDAS1E2/tKWQ9j4aSpAPGr/wnytUKEyiURDjNEOM9RW6avIx9Qsy9gpu2JN6
X-Proofpoint-GUID: p5i15czXroEpz1FuQ8ncj6kmdNrFRf-S
X-Authority-Analysis: v=2.4 cv=PqSTbxM3 c=1 sm=1 tr=0 ts=68598c48 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=YSDClnwbtD96O98uur8A:9 cc=ntf awl=host:13206


Salomon,

> Adds pm80xx_fatal_error_uevent_emit(), called when the pm80xx driver
> encouters a fatal error. The uevent has the following additional
> custom key/value pair sets:

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
