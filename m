Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD61DA21;
	Wed, 25 Jun 2025 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750814047; cv=fail; b=qDVeijGtQoSUQAVayVxuJGuXWxXTTwhKBZH78oR353B6pMZ/MPLt6QGj8m4wRt97c/JBOsZilONxqeUtvOBJh0sjt9NHXVz7Q3hj4PrsEmlslT07tLbdmNH64AgkrKgtMukLqBstSC8krw0eK5OwI0RIB9Rs2mK4h0J/sxRhmpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750814047; c=relaxed/simple;
	bh=CpocqAbSjHNoc+fy0eOk9CM/Af/Ld2G/d7415Nkn5j0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JDaU8eld2bncBBK7/lCnLgiZKGCcL+db/NLESptZplHIwGrqjSehpL33h1DHGWGqCm1kN4e7CVWTT7DOi0/kLK60+0XwD7QdJ8XIKJx1MmSc4Xf40clIzvBwA2stmGtJf+MBF5A4jzhhIt/sc2zhKxkp3pLNZV5u1fKh1w9X2ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j3LCyB/q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B5Rm5hkx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j3LCyB/q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B5Rm5hkx"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OMih2V019325;
	Wed, 25 Jun 2025 01:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=whZIT3hOhcgFLHtZVp
	0SOg0+G6k+6ivMuinOOQ/wdTE=; b=j3LCyB/qL2QoxP8F6f/1uOBCrBlXUNC18c
	dIlr39eHUxTDkMfEzt57aPuglGz4BbX3VyiYxFxA0nF6XdTce1+qF/t0S4jL0o0i
	mRR9E1zOJsiFQhfGVye7uDLrENj5Tzq835i+ZFmtxljl1SvYmtSWhRzeEMRZBLSF
	haBA/FQwbe5izxuFSdJ3bPhJJUOLi434bjPDk8WNzCMDAfCUt792FSBliQRkSUIS
	1Qyyh+of4y+jvXAay6N7KPFRwA6uRrr7xyxFDRXtxQ5yxQgM4eLVO00VpM4n4y6W
	OWhM80DNJtfdBVc0mflE++QA5YI+dgpsUzy6VY1mzJ7nFGPbV4DQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds7uxdqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:13:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55ON94FK025069;
	Wed, 25 Jun 2025 01:13:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehvww140-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:13:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zK0WYnxyzdEegjV6JFwwmaCmY4fqiUkVlbbXNh8O/JOVG+MDAnkc/kGZAu5tpSerucdOVeucMhHrQOSlk7+s3vJI73CLOxToqqniFgUp8n/CDHfbnCyd/d7Q70HdngGWk/PGQLa4kkkhR2qEBwIUeborbqixTkNsQlvjdqmnqUIs/Qhe8QDsGZjNF4EDZr71te0aayt/M3Dp5whW6KG9gLLfBkIv7PC49Sf9jsd4bQ2gzDEdtQtobv6JBcncK90+ycZiBJSwghm9yXS0sipc9XjV1aCH1vgXuo6X4mo1hl+fqQsmfj7NnweUthTTseqF82WDkQbTXBd8Y5/vMHSkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whZIT3hOhcgFLHtZVp0SOg0+G6k+6ivMuinOOQ/wdTE=;
 b=ZSQqK0xRBhmD90s1zq8twgeMmZ9PP3fs7LRr0+BFhAPl7iwbirzVHdUL/t3nSHML1nUNDp38OnVFT4wTKFo4l7OhqC80ngQyr7gkvJmxP3M2HRmnMp4QhzpoBXKEgLatLcbf2zswu4kth1lgyb3h4SN3zx0531Mt/Y7107j24rt62PUJX8zL6t4CF8JpuQuDH6PbUCfdsjiGcJOBhZa7olOtqW+6fHSzFuOliLa3J0HuaWXYdaUXq1dtFV7jQnKqI5FEglGCZ2Yt6I/E6s1KCR58VPC6Don1r50Doyku2jdIdIXMuVIJIuD5W9zh0g5bxtiyeCYsrxmnSj86CrnVLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whZIT3hOhcgFLHtZVp0SOg0+G6k+6ivMuinOOQ/wdTE=;
 b=B5Rm5hkxOLr5KIT6WvGj7ODOxbLHpOc0n2Gs2EFm/BqNhIcKZn5jim4XfS5vrKfxJJpYKpSeQB7CVfGyzENwbhRmUCt6sXslNObvTUZ0Jot6aJzy0IJoCEoS1X0dmb/U0tQIihIbAedwWl2+keAWI2WICFNpZAitfoAqwGYac0c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4746.namprd10.prod.outlook.com (2603:10b6:806:11c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 25 Jun
 2025 01:13:50 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 01:13:50 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Quinn Tran
 <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] scsi: qla2xxx: avoid stack frame size warning in
 qla_dfs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250620173232.864179-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Fri, 20 Jun 2025 19:32:22 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ms9woc87.fsf@ca-mkp.ca.oracle.com>
References: <20250620173232.864179-1-arnd@kernel.org>
Date: Tue, 24 Jun 2025 21:13:47 -0400
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0038.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4746:EE_
X-MS-Office365-Filtering-Correlation-Id: da86741a-8a8a-4d7a-a5e7-08ddb3858b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PUw5OZ509XMBGBbffeFvHuzlkxCa355aW2LnMv3O+NFJQ6ow2bxVdaxYaOCk?=
 =?us-ascii?Q?GkXCRUfZKbNl1MDK3QJh3a3/vIS0gvUrTdKjxAaiLQcbguT/fzkGNuN9aa2x?=
 =?us-ascii?Q?kABxbNtF20gi5xXcC+9Ul77NwwbgsERjXuUu9ZW0pEGZ2kSSWnGDl3L04Hvg?=
 =?us-ascii?Q?hOQfr6n7bgDImSIeFwFGKOGhRfXLZk4ADyRlc/LBy7Bc8YOB9Ht68Qtgofi2?=
 =?us-ascii?Q?epPv6DzDvvsmW0xWvThDVJCQD+iKxjzYx7auaSUWpvxD2Ta/HdX8MaNHH9Pm?=
 =?us-ascii?Q?Ns31CyqMRrbleTHUhd5eMDdO9wtPgoXg7xbYZk6cozR1ZbcYW98wJVC86vr+?=
 =?us-ascii?Q?LYHD1kDXkgy1TK7ymvN+ERyJQwd2gYZ/WE9r1KXCAdntNkgG7Jpvr5HxxBpS?=
 =?us-ascii?Q?Bapflx0c4xg+YRBtExGtpetv8kZmdh28GNzB5moJ8SJJU/JXLqkRpzt9oeWf?=
 =?us-ascii?Q?kVQ5by3/0vOf24H89pXHewFl2K0ha0QAwZq55DH1kswts6eA5acgA180ktQp?=
 =?us-ascii?Q?HmSVhQqi/2OjWobLMNDiBD+6FMeaa5XKsb7amqvFTfJ95/gWPy3JbIMIzdyL?=
 =?us-ascii?Q?at4axotIRNYdg+nQv6TA/xeIR5An39FiTwfM21H1ecHI9se2JbDvZbe9Dkj+?=
 =?us-ascii?Q?ctg66OK/0vNl/8q8C+Bxu8/24JdnC5kt7tYVPnisbs+o7FBeo6weOlouaOWP?=
 =?us-ascii?Q?AuGjD47ZZcE/vv/KlCEkXSgTCxLjQ2+DTmi2m2BKG5JOScAahfkur6B5qCIc?=
 =?us-ascii?Q?SAiEjE5CeXsOlJpXmGBbZvH/ZbC0FmClXE7lt90/WfMj29zaIsH1X8h/lA/E?=
 =?us-ascii?Q?WY3bvhAbD8GBtBMYEtia5pOVfxgHQVdDUfgDz354ofL8cFYukIWJKKEFCXDK?=
 =?us-ascii?Q?D7VWGEAEZJW9Au6M0uUmtw/EYrxbIjsmZijQtmK+WLfVQ6DSGQHVjJ2RR+Xf?=
 =?us-ascii?Q?8Vi4M5xl204wPNSXNvymhPFcbrlJ6/pK8nBHSQt3c08CnvSug3fzNwrSqbHL?=
 =?us-ascii?Q?ONqB2zSe4sp+niIirkkH4l+p/05JpVx+3LLaLYML0k4pmNX1UXTcQ8iFG5hC?=
 =?us-ascii?Q?dFu6N5P1OzFBkgHcn5sW1NaPL9v5wcG+2wnSpbRp3tCREQGykAs1UNJui/hY?=
 =?us-ascii?Q?fWoiyt5MBIHXp5npaphZ4q7pKrJM0r+GmMXG0LOo6d4Uu24z63He8EVvmLPA?=
 =?us-ascii?Q?q40aw4Y5xj1bSm3nixaM6nohZ3p0PLsThZHOH8HFE8vJaSBXJrQOyzxhKnQ0?=
 =?us-ascii?Q?2fk0Tzhi1JJBmW5SXhLCagQQfJwSrqDOrLexXvqQ2uwR5+geVXULBOvzZsfE?=
 =?us-ascii?Q?vCFHXH5CADYv/7Oain2G7rTKzgzy33ywNDoC1R4HBzt/oUBuduGJQ+KmjHLC?=
 =?us-ascii?Q?IjEOVAWJ1kv6WJy0+gSkC2/rnsevTBncyFkHHZbFDjuskwvS8KSKO/8kGp0O?=
 =?us-ascii?Q?9xwh70XdZeI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5/dxhz9O98RHY9pF9dp+UXfVeJsyufCpYDcQvFCYBm7tEC+sBZXjMd/wGgP8?=
 =?us-ascii?Q?OmtnpdSGbRrxivFA23hnnoMHwl66DKDj7YBYMDLOU9ajVU1KVdGWKQhanVxO?=
 =?us-ascii?Q?/z3S5QSsSvm3iae9lKOrcqczA77hIVWRPJ0IOsOnaZr6TnJXj+m0PGU+D6zP?=
 =?us-ascii?Q?ltkQYn1ILXSG2/nl1gpWKH/vo9NIeEaUHN9KJdRgcR97Z65/jarUjC6Uitw1?=
 =?us-ascii?Q?hbV4dmzLv5Lu0rDkJOKKAouT++wVNoL7ixbAwDke5eIxG7WdGQKqeNq03CXx?=
 =?us-ascii?Q?TzyjPD8anhomIH9GF9d3QFt/KMLHpnbaU0TlualOXOvMxykqn8bM0Ce2L4wN?=
 =?us-ascii?Q?lt8yhAHkOt8MTMoiM0SdSpp8IRDsVDZKKujGrGyIi6vvKhTQgEX6xIAb2xW7?=
 =?us-ascii?Q?3MJpzR1+afTZnrAHr8v7T5UJVjOnT2Anfvh3X6TWBQr3wAyk6CsRzJfdQjUP?=
 =?us-ascii?Q?2JDKONttGiBv9/mKSBcvEV0MT/Vx/Et91KO0BVj2pT7Td/tjs9pWQRL+xCf0?=
 =?us-ascii?Q?b8oWQp34wixl3mPEEf3XD0dwzgE1gaEmCbWMCAIqMMamsRnB6evIW41MgpC1?=
 =?us-ascii?Q?LUbqU3JvgWKJBHIC5FvvJ7rz59gzd1ZCLUoW7Nqiv0ntNKKGXqKGgW7e9NME?=
 =?us-ascii?Q?cFQWPq3sH1bVFKIz7kJ1CflP4UFFT/zXUHSvgk4kxduCLBGwyIPCsYvhI4E8?=
 =?us-ascii?Q?hHxJstojiTGckVxERaT42tkJRHNzwj8Dr/uSB0z7lkxLrCnq9MYE/GSrm4fM?=
 =?us-ascii?Q?A2ZQ4UKVsxqQzvMRDsLA04VvrYq57eSP4bZ/B98T9HsbYkzqlzMjiPkOi24r?=
 =?us-ascii?Q?whQmed0hHpnMxV88VcTugaCF/uQow8d7LE9P+/4/LZWWAP2hhDswD9rmV/tS?=
 =?us-ascii?Q?936/47fWF8bYdnmzJ4SIOQvIHKcmIZB49sU1/zgIGx6wfTUUtpzICigTV/Lz?=
 =?us-ascii?Q?G5Y873DS4MJV3fvCDJYve8BPZkGrydTboIe7wGXo0zN7bIme3AoLZs4ySD6N?=
 =?us-ascii?Q?fFPRNhfIv+c2ACbK3pZlUf2O/6d2KG/cPar1U9j3sof1QbFW477+Izr0wTfi?=
 =?us-ascii?Q?es/p3jH/Ll/KOjs1JD+10ygVkmCJ6vUjN+VJSLVZZ6YB63SwPq0R0uHagFqJ?=
 =?us-ascii?Q?Os8n8GGrpY2jjFDlKDGf2tfCFwfB624f4/j0IDbT+NgfpPTxUjykKad4ykKC?=
 =?us-ascii?Q?XxvUGXsauNc0k1XNpHE2Ro4E5z5OUv8T8dWeDN59TSzhiDFAJjWvG1doRKQV?=
 =?us-ascii?Q?qx10G8uiGyLp+UpvoJcSL34intYmA/k0TKFL7x4NR1WtaIss9JfN9tODAYpA?=
 =?us-ascii?Q?Zkoa1fQi1wqKD+wBpGOIuIjj+KKG+SZ9gk/70QI9Sm7fTrvFCtvqNlGk4ZYc?=
 =?us-ascii?Q?fgWqTu1AFiEQmMfPPZKgB0dqg5KOcNn1rIuosuAV9DMSpZ+ZSwsypRC+3kTf?=
 =?us-ascii?Q?s3mUm9GRCHA+MSUdoi7SQWVypIDJcw/Ou03k+GBWr5mmuBxMp29UKFHDjVth?=
 =?us-ascii?Q?doTFjL4psDjGJW5szjWBbynTIKQ8Qy6gVsNERCcjtMFSruw7G4NUH4aw2MsD?=
 =?us-ascii?Q?ZCIDT+VKmgwyKUSSB+ZZk0FMuoQRHzwswC8UlpVDQwqBJFO5Bjqcca/ECfac?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a0MMkYxbYy482wHcRUidpqAo4+S/CPzv7i31C2DFSr/NMZ1FuSoMnfSzF7atSDwFp2etGyWU3pLJXOz4dalh6HD0Af8BLoRb4Rgqp1khdQqp4j3tbWh0hIZOK665Lz6AQLM8fJ1vRuPj5VlT3N23SCzeskrSroASumxive6FDywXJhV2FERb118PKGdkp61ZGbqc/Q5UIDw27L677F9VCpVvicGMSSNa0EHl749fGD3qvtmnvTTfLaXBU33QGWI5O4PwdgmiGz4IMftwK/G1FnT4NiaFFsicwC5umdZEk1o/Ddt92KzivfTYLm22VLe9/N024SJw7ZCw+p/hAYTuXkuC5Q8F2tDSBgZANlFPCumI58Fcr54/+XT9KClsGU+GwhsBdxtN1zlD0HJmbULuRu0K9bEG/fI9z4CeLhfzG9vuB4XolVMeQJIt1vuJci/yPDhxQ5veFSADVXbQaZ5u+9RUaKPewWYH951/Wjdfs2jgSr+EtqK+ktu1r1SJ+v7pOk3Lhdr5thCv/dNaa9kZs7suN5tz0NOiNy6DcP+FYIVPBi65cu5zFDppo9wHyySvskmgaXIllGCqFPgeDWW7nia642Cmy9c8w4DQD7uM6Ms=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da86741a-8a8a-4d7a-a5e7-08ddb3858b21
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 01:13:50.6041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q3jZr/d9Dyzpj7wMEom1LAg49SqLGvVDxfeqiddKRsCLEiodFx/n3SY8crcTAr/wL+R4cY6ekHKmzKcgJpi9VAlZKRcVSreEdQJuXwtf8vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506250008
X-Proofpoint-GUID: WAyWOHdZ4-vHESeK37FAiRbZkCUN5HPB
X-Authority-Analysis: v=2.4 cv=CeII5Krl c=1 sm=1 tr=0 ts=685b4d54 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=YSDClnwbtD96O98uur8A:9 cc=ntf awl=host:14714
X-Proofpoint-ORIG-GUID: WAyWOHdZ4-vHESeK37FAiRbZkCUN5HPB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDAwOCBTYWx0ZWRfX5srlBsZoyDFd vOahNuqoFXx0j7u/yZ4zKasks7LcC6tFuZ6YrMeUqQlXRsYe1FFE+tK6jCUIdVPv+KjUy80eyn/ EQcpzWKC5uw6LV4nM/xLgYPc9v+ylyOrQonFXveL0yk5OlkRHvBOiXrPaVqGObLowrYWZ5PC/se
 2VbT5ZYJON4KpSPZk9044+GZiXRDbfXAihbfuTxaNs38lvkniMj/CRtCVwkHnxujVcOgpdOkwBR plkk/7wErB2DfttZaH+UeBAevPwh90v3rrXEM0KllXW0dlJpp/lyam9JpEf8d/9m6RppPtrQ1e9 lIpqrjrkqZEkgb06UJn/HDU6k+Dt+6c78hAcWSHEwR1jjcN09+FaF3GcBD19xv9uZ9V/VtX1QbN
 DB1IHgvQ+0iflnp4kjjiPkr9wTqK9Y5hkKvBhaspOxFnT2cCBoSPLYz7W4asTS261SMCEZZL


Arnd,

> The qla2x00_dfs_tgt_port_database_show() function constructs a fake
> fc_port_t object on the stack, which depending on the configuration is
> large enough to exceed the stack size warning limit:

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
