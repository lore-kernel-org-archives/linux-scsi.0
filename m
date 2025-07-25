Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DE410FD;
	Fri, 25 Jul 2025 01:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753407166; cv=fail; b=G+hbNmPY8PhXxqRJUR9Qk7EBlMOoVyOeOGRs6gVEEsGR1wZYS4SEq/EhazXS2+HGD55bSfRvCngWhDMBT1IA1+8Tf/mHh1Vh1pakUVLFr+wW9cqAKDNgryfsSC7EC9GsGGxRsipilSHXjtkktcdO6iStZh79YM8oIGgavIiDl6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753407166; c=relaxed/simple;
	bh=fM+7IE0z6TJaDlMEFhfPRQLU0THhDzUn3kFc7zk80XQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TfDv8QZsRXDv8qudZrRRZaN3BQuHCko9yeJiby2TWjHfXdl/LTZszTN6ohnzP4F/aFL3TLDYnf6b2/B3eNm34FETHHiP4eHFsH9zZgs2fiY/gzDsdIb58sUmwbPcsDGQL6qwCyV3BeCsoxvzTgK7aI0RCtHDeM32Iu4GTYINJ60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DpguAKaL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ArF9JTW8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DpguAKaL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ArF9JTW8"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLkASx004750;
	Fri, 25 Jul 2025 01:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KLCLwrJzesiZZdTM4K
	gXN52WavA89p2S6iL/HQ0S2WM=; b=DpguAKaL3sly6Zff0RKOoDF6uZbVlBDPqN
	i1GzJbzOX4EcnlPQgNJlcK+tKzBmjfMi1yMc9T2IZFow56n9AVoLmzk/1VYZHHnl
	8tzLLdqqYqWlAsfR79xRP4rWYRXiHjER3Befsubm7M8p2JmRQk7tBiIdeWgK0pZ2
	EhzTG+gj9lv6NNKEJQHeDbulonWvtRreOAEtbcMe7RIrWukyAR2EFYhIMkDxHnUb
	bpSnj7NwLnLZ+Cu2pRAJXc6uJr1SSakLUrL4RVdI5F9l7qX2Bd9vMDmtrxY4qlAN
	Kots3QKjGlggOjzcc3XJum6RbSvc2jzJi8plYr9Z9wX0nJQfcW6w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1h05yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:32:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P1Pu6P005769;
	Fri, 25 Jul 2025 01:32:42 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcgwr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:32:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLDgsXahTiBZG3V98PVBWojG5800ljN0bIA2/9U6sqLFIeykdh5EcNwxILcDgAtW3LcOZ+DzqL5jrSEZkEoquI0aW64znHLh7K7gGikOh5YL14fgTe5tbzCRXQPZQb9oZpRE9tDBitAyS2ZKAu/W7KA07dofvqhrbUHnhntXYBUD6WVAfnY9dI+09p+uATW0ii6zij3KYIt5iunhkzHTlISijYsV1ErO7xe+bbyW3LwIbXOR9PjJY1g3TocY+EsSs2ep4a0CADN2I+MtAR7DdpckwW4T2Gs29wmQQ/1qPQlP531FK/LYfK7WrIr5bIlgNwY11V8+kaHzPnGh3RoCJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLCLwrJzesiZZdTM4KgXN52WavA89p2S6iL/HQ0S2WM=;
 b=QCF7huSdccvjfRsocE4jZqTsQxegVt5CB/HDemukrTNA8PpTglYeYZwxU/NTRd+ZmUtZlXsnlqThYzrHo481BitJ64dyHLkkEKygY2x13RAJLm4NxrrXvfsRd6OsQcVBmFOvKvNB1m24AKalUOUCi0vH8gaFeoL2p0OWatxkxLYgo1neZtFP3Xd6w/ywaq/tGDYYuobwTPXcJQUraJwLRg2lrxpLtALdCOmHXZuasN11EZ6tzQCrCcmy9uKvhYiHgDTUjF/5OUeeLwaqpo/o8TU9Av6rkiTqE6fgI75qYRNHCgL+53k6kGi0FcGCYfUajG1LQRCq3g39+r3mMl2AGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLCLwrJzesiZZdTM4KgXN52WavA89p2S6iL/HQ0S2WM=;
 b=ArF9JTW8tWd1FPlVxA4XTwegvIiWneG1Zb14GujDEPcn7DyquebFhKZc2fDo8d/K79u6Ql2Ay8qdVEVRikthWmBDJhIofFomMul0UIORtYk+LCNIcfPxBX8b+DDZS3U7nRAatqXHWK9DEfd+elG02HQIM6t0X0y0jXZeg179PzQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 01:32:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 01:32:39 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] target_core_iblock: Allow iblock devices to be shared
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250721185145.20913-1-michael.christie@oracle.com> (Mike
	Christie's message of "Mon, 21 Jul 2025 13:51:45 -0500")
Organization: Oracle Corporation
Message-ID: <yq1h5z1rr6e.fsf@ca-mkp.ca.oracle.com>
References: <20250721185145.20913-1-michael.christie@oracle.com>
Date: Thu, 24 Jul 2025 21:32:37 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0187.namprd05.prod.outlook.com
 (2603:10b6:a03:330::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4391:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d8bfde9-e3e9-4eb4-8786-08ddcb1b24a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lODv00kaJQEyMsg5M28K3tCVVPdKbjocf3QY/aHdeXepiyI7XpCHpS9EVnW+?=
 =?us-ascii?Q?J6pTsFo3BcEsdixCgZDLvc7QV9Jjripiv5w6BWRouyci6ShMWJXJCGch3AA7?=
 =?us-ascii?Q?//l+B5jxk6wT/TrzpFjEyqI2fannKRIKeLc/b7Ee4/jlHGZzD4zw6mR42VUJ?=
 =?us-ascii?Q?dnk6LDPF5ZojDnQXpzNhpIsBCuYVVM9q9xw5htATz8ih/JDaZCp4KN6RtMWc?=
 =?us-ascii?Q?p6fHIJMRgFgagkC6Prm4D5/60gXmLBXBPaB5ALIcYX4nlsAIDwi3OWeS/il6?=
 =?us-ascii?Q?HB2JUieBmrtbMb5LLvMSOOhRTx6H6CtNTdQlRBfz56qRvCkH41nx4R2t2jTF?=
 =?us-ascii?Q?MCOj/GzakjuSXxJwNQu6ALPQg+x3WpfykZawk1X4dn2SytYIScpIbUBK+51F?=
 =?us-ascii?Q?wak4x4abXM/eLvXtQO3d1T848wIbieaqIL+6aiYyCM7qD2SuW80Jlya5Xa6H?=
 =?us-ascii?Q?QggxngJs2YRRZo+auxBrt/Z5tU9osKTurFzk8WJ8cuj59o/oTXrxClssKp9A?=
 =?us-ascii?Q?m0HtAwk2vsaVfGR+PviLfEdUqImLdnS9EclKtohxlnEvqZLmTFFEgt8pAQyB?=
 =?us-ascii?Q?qt1cWn8MVbRVlw+X+PQLpZaYsv4MJczJCB1oMLDhl8EgzoVEqwp6zOiKux92?=
 =?us-ascii?Q?dHFYA/iJTkkEp3IMPcZgYIw6rmmAByh63fx9734ZxpfZLvZgZJeVoiTD7su/?=
 =?us-ascii?Q?CTgR4ppgACGk3gptpLjteA3Y0fKd9xoUxN/+3I+ZheA+DzSQp8hO7Hf+NH9q?=
 =?us-ascii?Q?Jaz0U2fQIY2A9gCAEbMe0C2xywYySQLpa33/wdC1rRWoKdTSgUPud/EyQZsc?=
 =?us-ascii?Q?cjg8hlc/763ZpkOMXXDp2D7jzS5fiSLoCAxJ7RPfKtxvuE4OXpmXrP8+peoS?=
 =?us-ascii?Q?elCpnhiV6T1h45hwkIoOC3hewtM3TRK7Vbjm0mTW8t3sRiYlNWIw/tjFUYjn?=
 =?us-ascii?Q?lTCJsEPMquXD2n4cBtaqKSVG2D4H2n7bTAnYHtnNFpSszs/G4yXyASNdbH1c?=
 =?us-ascii?Q?i8dEeu/H6gpGDdUfCIrDjn6uDe7JskdgqJQTKiys6uKT2I63jUsH2/RMTn+j?=
 =?us-ascii?Q?8VGcY74ODgiKwjqpBPI3yqV+0W9PARz8hwq2KHZlcQURDTSgaHFa9q1ZePaj?=
 =?us-ascii?Q?tx2/gbYlVMRh8bIilzS0PbtP/qZV4XeUlsNZ5lm4ZYG6Hj0ID7ibzLInBFG5?=
 =?us-ascii?Q?OwrCDGOcQ72LE40RqgQxs9Cu2fSTwKeW6kJ7+MfKtmbTCdinH9KZb11iY+3p?=
 =?us-ascii?Q?GSEXbGgVkiwMXjXOEkBCNZEcrKHse8Gf/xQGoGwC+w2PqGhkrptekKpLWTvs?=
 =?us-ascii?Q?pcQyfvdyl6Y+3T4/wTJq0bgEFTJTi5nSfidk/nTUA01sK+BdsulWlAEy/5Jf?=
 =?us-ascii?Q?7vtkFZGzECL1iNm88o7nQ38dOKM2RIS/glDTP2/rRLqe/Oa/AhSyDlpYixcD?=
 =?us-ascii?Q?l2XFXte3sjA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lvLBaaV7+TTeEEWD6bFTax2tnNv6/Od+XQTBg5G/N2xmHLd7n7w46+/iuZL8?=
 =?us-ascii?Q?3vUATlr72e3xsvg7eJATUTsa9RHh3a1gO5NF577D55lj6y01e+UjqkutZKl6?=
 =?us-ascii?Q?J5532KvCeXqi+xiBGKrbUdIGblUKycXYfMom1zy1xmTobgt3SdR54kQhy82U?=
 =?us-ascii?Q?2t16CFTZ+lkZA0Sd7sE/ADBI+E98BnIQAmompq+CUiDwj4w4zmfed5zfnPLR?=
 =?us-ascii?Q?3AJOlL0bVQyKjaNfo3nitQZzQwutsiS37Ikfw2htMJr5VRDPQO6oTcuizOiY?=
 =?us-ascii?Q?uoOMBkOxkYc+KdFmeKMzSPZD7cNqcM5jYt4/V6To/sVY4N+aKNL7qonj06Tu?=
 =?us-ascii?Q?oxV7QZxxzqfZ5bSXPL6/wYCz2rXnGOVZtSrhEhw6PlSPs6apOLnZm7BZGHbk?=
 =?us-ascii?Q?sLL+67ft+byB0nsDZUxDggg0cIfEIPXACNC4AKlAd907UgZvs4D7R74/aYZ3?=
 =?us-ascii?Q?84kKSmnddUT9jHx7DnbotHK7/Jk/XD8wC6CZX/Y+fq1hnyyBiJYBFVcRNALY?=
 =?us-ascii?Q?LPDYkWmCiIv16icMh/5m7dGozV+Vo5njkFuEysFRiBl7cSV6GobuP0F7pS8u?=
 =?us-ascii?Q?nARvEjIY4wj2Z7ZK9bvMH7HGVB6szhamo2Of13AD+DxKHohZheT7P+tRIwhG?=
 =?us-ascii?Q?Nn4BMv5Tnhh3sVm+orcvfZ4q7O8R5Of6lyH3wTpW+1EcJQ70R8VNyCLwwkdu?=
 =?us-ascii?Q?qlal5iIXm7NZAvGB1FMRH1ZeQ5RtiUKk2XQpK75DOaB5QfbZckm/f52XSDqe?=
 =?us-ascii?Q?qnLZ6E1QVDJEmy0/vurn+7Awe9LlH7ZF7AZwmPclyCLtGdojZQyhXGEgu55J?=
 =?us-ascii?Q?69zae3OmGkFMV0aNIfy3MmnVzEI/Srad0OP2+u4MukEHcP0vopqRTQkI6yet?=
 =?us-ascii?Q?J0sbbbxQMOpQe5WMEh001kcyXYllsUnAkU7M5yiKen1aF/tu8AJUDBlV5sXx?=
 =?us-ascii?Q?VEvRa1Tdfokt+/o8rDkK0s/JPbg8k05y8iM9xysPQ69NImzIk0Vn6c5QqNcD?=
 =?us-ascii?Q?Y/Nc96deE+y6kevc9X+7Ebs/vFzHoG7bhoBZ8kox+ARVZQYaStedEDffWlKg?=
 =?us-ascii?Q?xiLLqUWnoTKZGudU/WwM/K0AAFN6vDouGfLL4YZxirvWevXLCuw7mPVzDQn0?=
 =?us-ascii?Q?c3KXdPSHmO0HxaJhocCBqWQ5oJaZSsMCo/69PPT7X2vNvKYtIfaKAk39aZo9?=
 =?us-ascii?Q?vFlbpwGfba5fRM8AatxG8iDXKO80NRwZrogS6OG4JjNeQGdFghZeXwdg/2/w?=
 =?us-ascii?Q?3Ypz6v2xh28wc2CaJJ810ANS5Uutk3ydzIgT9N3Ye1axLPcy0JTtZQtRG1op?=
 =?us-ascii?Q?JPlsTcga9dObuDrUSLPohYBmVYMZ+kPuycscDrSBnc2uxsIqA1b8fe1+Rb3E?=
 =?us-ascii?Q?d5MbjDlhIOOyxxaKJmCmqgc0LlsXUZ6D9RluG/V/knyhsYmn5mZnFxOXEu8u?=
 =?us-ascii?Q?iFCviKx9Lyg3TahCkD/ZI9D8jpGayNrJjhAeqeti1OywxiC+sRowNUvmPTId?=
 =?us-ascii?Q?ZtKwm8+ZJgNQEGyMZzsRQmpxRIiYerHO6dPbjnDTpAsJOrz9ROT1lroabTLy?=
 =?us-ascii?Q?qz+5+8pDHFVVLcoHnzmE+GhOurwxuubTSKZfcVUwqHj4slXkRjYgFF9H6sCE?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZfkQgqjG4cst2RMOAwGfcJYpa/8SaR+8mtCrwVzrwJ8N1C3JsrJkAjJ48ovdhpu3lvk6Br7B3jvWt5hLeNwDl8cslvYaoGsA0TlY9fGyPaVPF51iF53+fSZVWHhuHPZmOE9rXBN4zvgvnX6D5/RgbSL716ShVK5s5Q7ItXdQpw/j3FqYhVVC8sqjKe4TuOccxtNf5pr0HN1BOeypmVrTmz+hsOVGYFwKt5DUdAb2X4zCiSMIf8U2hie8bosiLGY13vy83uHoH6qPGkHMb9Cb/BrFSsrCcfXGnE/7RyzsJEUuXhNgjyZw7ZIl4BVwNo2/5gw1ekvdBufxFIQIQ//w6RlhNB0Yy6cyQwnWz3ut7q1zuzgevTKUbP8TmoZb1Lx2HaGItv37lpSwt5N6fkCjIFAZt4E+dqS/VoSuLGNBuddNBryqQoYsegWYsZdYh/66fmwwj/XR2e4X8K6HL9Sbyt9LEzMA+gMCXZbkFrAFAif4ZcNsrw42XSlxSvZivPnkfgOC32+kmZye+cbvXxpZpSnEhY/VK2gkEMHbllg6HD+ynqOEqvu9ojntEM9I2j+8AHUjtd56jD7YpijF+LZGEzPp1XjxVgvjGkb327w8FAs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8bfde9-e3e9-4eb4-8786-08ddcb1b24a2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:32:39.7692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubdI8E2SkTGdo40CB14Z0iQm4vcUFvVGLbOcti2yTQ+me/DqlfZbpnXichz5yfg6zekznk9vtNs3elwoQE0PJH/lr+xEPWrjUbF6HO9hFMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=734
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250010
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAxMSBTYWx0ZWRfX8+rQUQQK+lre
 Scxm354ZAHYa5uV8fnlZLSmW66pogi3X5b5d9wt7FL7dkKDiNFu9AIagZHGUa/5HjXfcBzWAh7A
 ennxfiZIjvcxNf/Vs0j/y0yam6CLDgv1l8ITSR/k0uYLL0S63VZvy3FgE4vQOvt4WRqk6V5RJmW
 TLVEZH4d29XFALHPk8o3qYBHl2+TeDlsZ0wgauzZT6IKcrpqDCvnHGNazE+4hr+Wh6My8Oj6EzA
 Deuj9kmIaU7uwizGs1pw0UszDrNZVfcJlWzDeTnMdoashbFcmbYQ9QBhJQ6XkSDE+ZrjbiQSZrl
 qsN7FOe0y5lFEMA+fQ1hdHlXpTOYI8PpvIS0me/b/Xcv9wjYCtj/Eyum9BtPHaRjlynuvW56Ib5
 UvG9cqx7+QX3Ib+Z1H6Y+EI60SFAV1jXi9ul00zA6CP26P7GuUUiz8XfjllLezmIBKEbk8w1
X-Proofpoint-GUID: prlTrpS4B6_xWGblrnmIGqWceznU2ha4
X-Authority-Analysis: v=2.4 cv=RIGzH5i+ c=1 sm=1 tr=0 ts=6882deba cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: prlTrpS4B6_xWGblrnmIGqWceznU2ha4


Mike,

> We might be running a local application that also interacts with the
> backing device. In this setup we have some clustering type of software
> that manages the ownwer of it, so we don't want the kernel to restrict
> us. This patch allows the user to control if the driver gets exclusive
> access.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
