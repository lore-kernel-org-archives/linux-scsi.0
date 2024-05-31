Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4771139E;
	Fri, 31 May 2024 00:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717116391; cv=fail; b=CncqhvhLqaiYf2z3iQEyvnzdrsWk7+onaKCd+iJphDL2SWpbZbY1xEmRRbJs9KNdPZPzL/nLJCT+COdUDx+BYxWTL8JjHYNVHuv8YKc45WWjS6Hi0wdn4aVM2ZfNwn2N30VdToGFif5aDSPlLYtWphrCXTBEFiMKr++/DLXV0vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717116391; c=relaxed/simple;
	bh=X8oOsxW0ZmEBKTnilqN8FBmGs/DWb6QW6BUKdtbdwts=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RAbzucs45IEQUxyRQH/xBDQweVWu92suhcNw2ZkEU+OehNIX0R++UKtdfVfNRNbE3AEESOE8lQQi9plpGc8R3sUP2ndCtrLmOQ0MSE4y+GAbcxolAEySOPkE4AWML4CsomNAfjuXvvFCCYcAQgJRATk633L2c35NugPsK2qpER8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44UF0OWg019718;
	Fri, 31 May 2024 00:46:20 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-type:date:from:in-reply-to:message-id:mime-versio?=
 =?UTF-8?Q?n:references:subject:to;_s=3Dcorp-2023-11-20;_bh=3DxB1rl8XgQJI+?=
 =?UTF-8?Q?rfRW+JCmBoJyE4fD/cRvobN2XEsWvzA=3D;_b=3DQnd+gYfNwE8+b236CVreXgj?=
 =?UTF-8?Q?P/EgDFS4jrMWheYqqTD+hGzNx8gTO4PignPREGpwReT8D_tk7FJHTCGHTvxVPCc?=
 =?UTF-8?Q?/busfGsFtR0kDlx12SRTfokMwnHPkZD7J2loYKGh4YfaCxq5DeF_bFwQF3r/X3S?=
 =?UTF-8?Q?r49ss93fZH+O75lZ0pP5uueTEyIjCqCsA9xHearysqakU1BYtQR+Mmt3O_JliF9?=
 =?UTF-8?Q?/UIBj7o23I/wHNpQE7eVa9yPBQ2DtrTcn+Yce50ZynRKEEUUQC0461xWIMThuOy?=
 =?UTF-8?Q?_kVeI0Ot0Lk8mEaRNzJG4B0rfXYm5FBdQIYyKFaEzg+NbtioRNy3INfdvr6hL+2?=
 =?UTF-8?Q?k+FR/S_Rw=3D=3D_?=
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8g9tb2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 00:46:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44UNYG3Y015137;
	Fri, 31 May 2024 00:46:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc538u93h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 00:46:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3+kiT4qOPIvq/Mj3oQ/JjucGfM1mm5dYhMOiBOvpot+VtTa+SJ2asohQ1h93RCptt/NklHIoAIreREbDsjZ90oqe9MXfVzdrSF1XdGLwMBe6EeqtoIzxHrxU0+HjmwAKNkosRFQyb4uvLtjH1grgUMkjyLCtd/hGUSmmimrQ6bpjZUneawmRWnXdaBxrPwHFD6xQUzhaKsI43m7uYPLFU5ZqON2N489ZnUR3IMa0c9ZtIOUYBYlOJgQp05yeGeJ4jYQvj/8bKWTxWFetwqGf4yJ9f5G5T8F5rAJnk3XPky9v6jDWmqRLvQUDdx4Lto5N2Sygz8bZHkL5A6l/GHRsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xB1rl8XgQJI+rfRW+JCmBoJyE4fD/cRvobN2XEsWvzA=;
 b=S0ITaRmonU4X9Vy7+pa5EwcOZgDDJ0jkTT/wxo2h6orc9R5KIn4F/Tr3JZjDBYGmlQJBg5UAt5gktW2eZ4dtAxUuT4EM04cikqQPimbM0WW6W4W4rxKR+6GlRUm5Brr6D+8lNxm+2SWoe5/R8RVCCTobennClMtt4VNsaSRZC9iMZXoTlVg5j0NQ6owi29iLE7tiFTkKNatsz63TC5TDBTmKXBhK7TI2UPIUhDACC0ThA6a/vXEy7Q+FZMeh7u2JB26g29GAgZ+MuWZ0OGahtimHSlQUMszeMYnOy3Zua7K20XrLnAa9GKIqZpiZXAy7Kbm1V0dGiBuisO3kGlOudw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xB1rl8XgQJI+rfRW+JCmBoJyE4fD/cRvobN2XEsWvzA=;
 b=ApLL7m1uaob9GbeDC23mrWsuPn2BOPnUMqgoxNSh09SPW8yleNhNGcarQ3Jo6riyL8YPRQ5HCC1bfVgDFP7o6UBeloddYPmLBL6/HS6FEg1EUaIXU7tpNxdWvzKPEUKZNlEYL0EMVqBdT7Jq5eBDfavMNcqiaY6KUPmg4xejbo4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.28; Fri, 31 May
 2024 00:46:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 00:46:17 +0000
To: Minwoo Im <minwoo.im@samsung.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van
 Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joel Granados <j.granados@samsung.com>,
        gost.dev@samsung.com, Asutosh Das <quic_asutoshd@quicinc.com>
Subject: Re: [PATCH v2 0/2] ufs: mcq: Fix and cleanup unsafe macros
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240519221457.772346-1-minwoo.im@samsung.com> (Minwoo Im's
	message of "Mon, 20 May 2024 07:14:55 +0900")
Organization: Oracle Corporation
Message-ID: <yq1ttieerlv.fsf@ca-mkp.ca.oracle.com>
References: <CGME20240519222604epcas2p3d427f2f5b3b0156881f6840443210931@epcas2p3.samsung.com>
	<20240519221457.772346-1-minwoo.im@samsung.com>
Date: Thu, 30 May 2024 20:46:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:208:329::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 83d6f485-05d3-4eeb-932b-08dc810b14a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?gzosVJzdqJJ2NhR0whnsSuHg3P3HRV2DOTulZGSjNEArIFMt0d8JVeToMFnT?=
 =?us-ascii?Q?TLn8rcIyQ7Pu8udKmj4JIABJpnGqUrzHitK7l9DgAb6jTMsA28XHfJRpAP7C?=
 =?us-ascii?Q?oBiC9m56h1RxeCvW9W7lv5TiMFPqqT25Z/wn8O+bYx/M3449m4WvvUf3QLiK?=
 =?us-ascii?Q?RHO/+aKEUcMSebBEfJNHWcJtzfZprXXCvgo5IPm/2uwUTnMGgQu5T2x/TDAA?=
 =?us-ascii?Q?+bLzMdANXoTBTVCPeQCi+/T1zaPixVfPb1od8Z0oHstNfLylP4UXKTfaPZ5g?=
 =?us-ascii?Q?6c1JtZ3Byg56efiP21kezQCCnvpX0qbC1owdGUpu1bdMaVmzhvdkVIbTgCyX?=
 =?us-ascii?Q?SpLYYAri9tmVV4J50Y7jSWFGNUz6fZiXej8PW6IWYgYdPmw3woj+gBhfIyYC?=
 =?us-ascii?Q?QhBIRvYQteBrbOuKs25xi/EV7UrStc66J3OvlkIjfZbZaBgk6ocsDunP2tyk?=
 =?us-ascii?Q?FRt71OvC5xfss+4bbmj2jf+zWUn5CthF3BTOKwobCuUfHikP1XAjrEfxRyhM?=
 =?us-ascii?Q?pa9VHEAw9JS8b4VDU9IR9k00pyH/WkYJb0Vwg6EYe8+3Oqv0JHPxmTSBq7Eh?=
 =?us-ascii?Q?vBnEBNzrbNEkiuQ2cF4viDqlZ+jkXk/g6VS/N/hfeBxUjmzAfWnaFBcfJh1i?=
 =?us-ascii?Q?Y4C3QrXQpci1fiANvI1fcFBbnRtnqTMo+/NNyfuES3xI68n9Z11/1EAEjq4v?=
 =?us-ascii?Q?4itOOU7tcL0eEeQFvNvyMxFB8tWKf3ckJS3iIJ15m/Q3kSCFwMhRoZjD/MAh?=
 =?us-ascii?Q?gr13NQziTxINvGMNVfJct8MyTPwZpau2XgfvOTLuuz5L/3BTobtdbwGKSFLU?=
 =?us-ascii?Q?5+cju4Op7IMGj+0KwL+TD2K4wX2hfVs8WWwfFAQ2P80mr5R+Zv3Xuc2VQJTi?=
 =?us-ascii?Q?mrrC4PSxdmrl3NF5/D5XurN4SFGJMYSqrjvNjE6kQEw2Wc+VAObPmIx5LyoA?=
 =?us-ascii?Q?lUGx9g4mFxCosjhIouqxJfKNmWGYm5VRHeUmN/4Z0kpH/wsCmIGvJgWTokDA?=
 =?us-ascii?Q?MFynici32cjvde04UpLltYl2ckzypaZ+B5eagJDZq6G881hGEssdxtoWRoqK?=
 =?us-ascii?Q?MyKgTXdPDk4bbGl2o1MYtj6bYfpxKFzMx2gH4vdA8oK8ItYPVw6vViTKMipd?=
 =?us-ascii?Q?h1+wh4jxeTNQNBEZo/HafRA6sM9FME/KupRgw0SjEVqihoRvAn6ziut+zDtz?=
 =?us-ascii?Q?Z6SlwcWJGVmzWNtoovdf5R9NQ/dfrO/w8LTHaY5KtbvggEgqPUw6/JAxAo0Q?=
 =?us-ascii?Q?3TsmdMpkmM2pR67jiKFqmkfQEqs77x/DowN5TTHrvQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?grQVejPyuWj3KOibaHeYTxuYN03hdlFVjkbkZlqJbs06u9gVum4LbHazp+zv?=
 =?us-ascii?Q?743Jd9aqlnAq1XMSC8Fn9AH++oo45NBay6rbOgXN6RFcd+PbWu0Jr81KsC9B?=
 =?us-ascii?Q?TQZeLW25OsizOkhEgyx5ckH+BFKk741RNAlGtyYx2PhfLQ+Ogu28TZhvmCLA?=
 =?us-ascii?Q?QE0bUlVuH0v4TfwfRla1e7tXsBjwTknzOLYaVFC0KnNf3yg7Q5jwsFY7U9lY?=
 =?us-ascii?Q?OD2Y6mFXH7jg5Fz5o1ZvrBO1UfJVbl2lVn/XE0/FtP3jQMdFuMG+kU+ol/Iy?=
 =?us-ascii?Q?WQVUykZxhKV8mtzwLyrv8doObOOIu/EgIdon1yjVavV4nz8K7bHNSYn4lGgX?=
 =?us-ascii?Q?vqWj8VBEhX/ex2eFOErlp7Cf3cdy4X5o+bUQNRuTgAudLWQ+YW2xKjQwWgUe?=
 =?us-ascii?Q?RPJIl/nb2P5aXqabikSVFmf1WfkQyPJQTQgInL3PdtgagYbLBzWgrUFmabk9?=
 =?us-ascii?Q?gBTdI/zPjGB+6cKPDZXaxMlmdT5ogPw8tTRi5wxtaBSnDMr+efGhWF2uAkrK?=
 =?us-ascii?Q?fYe8HS5TFrsL/Rck8HPMkLSA8fBDTtnYnN8GPJmOPBDOUWytadcErwWO0Xzi?=
 =?us-ascii?Q?HkewEDYC62mWlHR4TfcYEzUMQazP76s3QCfJcj+SccR5Ym7BeAjW1zsYPYN7?=
 =?us-ascii?Q?V17zgA8RcCZR+7P6MoVOG1JzT0Z3RC/hLbWle0PpdCLOHRKspgjVThhGAMcl?=
 =?us-ascii?Q?BzyXQ0HTuqYWwEfMGpvhmrWD5MpHuDiOvLGSH8ook82UiPcUzmsg8kmdfNRH?=
 =?us-ascii?Q?b6TEhx5479Q+MKWB0jPumZxCliMpHJQ/rkalryedd/nHY4LrJ18RLf/AgIfk?=
 =?us-ascii?Q?vg8Z9b8keCvodApB3OrfwwxVnlhjMlkoak7dPWvVcOKRaNGnCvnAIDvRoPJ1?=
 =?us-ascii?Q?G7/iLlBvcFbzefxUOqZ7/dOasUb46ABaQ6Ht6/rP8YkefytfwXuRs+u93k1l?=
 =?us-ascii?Q?NGks0KRsx3xh3db0WQW+uBTHqS/Z9/xVjPFAlramwQBIcGUqy8aGOU2VkELF?=
 =?us-ascii?Q?/H1Xg4wD/GxQBYKv2bQTYNFlpqnvFc7K+8bVJWSDD90KjxA7wZ7pgEBk0MAv?=
 =?us-ascii?Q?3hVff67uXeZBuxRvUFDPzpbdm47DiZi6hYvRQ1CE9O0RaHHyWSqRtrpLi3vI?=
 =?us-ascii?Q?I2TYd2reSWr5+/7OnQlpdePF6/xPV8Dr7A4pl/QeGtRTKlvIvuuEVwkuzo2U?=
 =?us-ascii?Q?RBJj+qy04A6lYDrbfXeT0yXF1ynabdt0ISs6NYWS21/lsrfdvvVPL36k7xjX?=
 =?us-ascii?Q?hiV9ZFQh9mm/R7mnzLmDAm+ubr9Cu6I5Lh33VN6+C7y/7dZDnSqdWbwhbiHl?=
 =?us-ascii?Q?2cKcDa3grnODifIbR/M3X1a5OIUFdLOlQlMop0gfL3hx4QQLi1lIT6YKFr+4?=
 =?us-ascii?Q?7pCGbn1ux0CpmgVVfXQM8xVv5LdSKeYX2b5jIV8hmIUTbE2XnREnfTX3JcnS?=
 =?us-ascii?Q?54eNKTR6No4eJDBKbu1OO8WxA9zKUitxQmZTZrxHIuG2r3HhFzTP5wM2zCfu?=
 =?us-ascii?Q?pBGA6Hdpm2rQhpDz45hqnhvarh3G2mlM9LTjI6gqjnfDX+oMRorFaRza7UQ9?=
 =?us-ascii?Q?ZN8Rd8qkHTAet44ZNuoUgV4fOLQDTYDouNV4zLJCDSkEkezqWS/rBVvAQhnE?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	32v5Q2zwogp9FWa7xNT1ifsmeOaYyhKgg3nVQvk/5J4mq4UV2+EzmmFyuDnkIfp7OINtuV08F1LXSGPk05j4vYt9a8CgTGJGvP/MHTEhApPVWjk7vuVnzyIu0oV26ZIHF9+ZfyvRVO/yV1Qx6GpsTjJuwJADn6xP26ijJOTkp72Wk1bhouwcv6XX32ZYqTySHpgw79pTUvk5fhWhVgbbDdlACW7VegHZIgllLaxU2wMGncLXkiFEy8Qcq6bnsIjA8awXOsWNytfvRkX0P9O8bUbHaQkMyywbfkPoaLv3lj4V1arFU+kIMpFRMNO2D+eiZ0LQ8lU66jIjZM0ao4jb2fO5MTIohvVIsuTCjZzWEff9w3ujKp/mmjL/k+Peb7OcwyXBWsIifEZyR/ziR6VeFnqF3W864PCdtfcYajAuP6Mc34lE6lngDTJYJtuFZwsp1/SgOpPhGQNTPbg2qVLgOefSCnu0GMVN6Ye7SO/rwsBiLpZKzmSdeuKyzzTx8vXTyGxtBaxVmn3GZ9Y4P9vercgFBfm5cQ0Cc8sHlzeACtuoF+5AEgwQ0g18HuKO+2Ec98HfCdYItz8ldcPpiJ8nAQZ2oumUiW5fFlFjF6ba+4c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83d6f485-05d3-4eeb-932b-08dc810b14a2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 00:46:17.1464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSOgSdLUC+nBgn2SZy1y/NMjidqDwBgHoEBeUAd0zP62ca/zdd4weS3FPpN4a7k5dtms1EZEAuvsuHYlRinwCFiqQ2E5N3+RkoNN06y6Kvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_21,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=580 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405310004
X-Proofpoint-GUID: 1ErXzDJLCAKeXdSDplev00_B14NI0bvM
X-Proofpoint-ORIG-GUID: 1ErXzDJLCAKeXdSDplev00_B14NI0bvM


Minwoo,

> This patch set fixes an potential bug for further usages in ufs-mcq.c
> and contains a simple clean-up converting macro to an inline function.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
