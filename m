Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E56E2FB08F;
	Mon, 20 Oct 2025 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956720; cv=fail; b=QRhP3qIRXZpujVuipAl6VMvZ3szbrGJqT19ufgOrlBJxOOU5R+xOU8tgNUVfNsT8VxVUzQuN1SN6pbf+B9mCzYPIvtPrfdqXlea0SzmHAuVchf+D1RZLOYnrhE85UCbu2ki5brjMdO8oGUtMD9IYYRct2hrKCkISf/hkVcGlb0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956720; c=relaxed/simple;
	bh=kqKW5nVt5DHFw4uZABwFRX59dFoZO2lgu73UyE90ImM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fNrPoXDjv2kw9IewWGNiZGU0ZT8rBsk367T6yIEyh9PtUy5ZpN9WsRCUSTY90avW2lCAkACwpzX5TAiwYIQnYvmlraqqsC50LvjzYjhE7yaYNrkpK7jmE+msen3bmViBJ2na0LsD5WC9wb9aLxPeS2gevHI5gXWoFL42SiR3NVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sIDk6Y36; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nbCq3XS4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sIDk6Y36";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nbCq3XS4"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SI71001384;
	Mon, 20 Oct 2025 10:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wsa2VwTp/iHEtZBMgYCE4CXlKuVinDOP8L6qj+VH1Fw=; b=
	sIDk6Y36S5eEUVML83hr+Rd708IWCxoQDOtP+hhh1QpSkIDeUIp7dZePhc62VH5f
	dAJiMam+fW5XFLjTJ9jyZBxdkMxLgT5I3TJgtlzZ7XXm9vBisgxY4dSUpDYaTL7R
	54lc0P2Ml/f3okHlvWJEozD0fdEZTrwyMueFvk0T80c2KaMLgPlX/udIPmM/BODi
	xcOCiRf24x2/TEZw1A+IGCs7ZZje7F2RSH+knIscskOK7o97N8UlIk68/GG0kn02
	OxqlL29LMMY16/D9Q/4V1+dvi0s1kYSJi53fbNiCi5k8q+N47+mbTOLrxVxeLlv4
	e88fQ+ar6K5mzSl2PorWdQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3071yvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59K7P2bn007498;
	Mon, 20 Oct 2025 10:38:31 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1basx2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GYcNSqN15bGDfZfB6G9u5zTGu2Gmdg7GKKKngtjwLNdz93N/QTIsuyyRT04WiAEhFGZLqAq820sPcRG5BEfO5oDMSI/mS8CxctPQ8rg/+whcmESnegsTdcQ+yN6UcujhTNFycfhtAtysVbL/F1PGP/qWmbbcGieQ0rHqtslYBNkFMHH9tudpDmjobvuJQSFEtH1OiBI25o+UE5rSGH7VufOgwE7oS7nZk/4lXzeZcoBNbAB8QhOYDT6owXdxWqdCSxB3YTLsBMph2f3QpkUWyR3aF/FFWrWhw/puScEODqdpG7KDjdHwwV97VHMQze8P3JojUIm3LhCijhdpk3j+9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsa2VwTp/iHEtZBMgYCE4CXlKuVinDOP8L6qj+VH1Fw=;
 b=PRmMLIpbxb9UthL/AmLSxce2qO0mkUcSzXjSoPkKVnJ88vQZ9A56kncC5GPITUbfMeMfM/xL+eB3O5SoUKtUbpHMXkxDWuFOkP9TgG7rVu5N9HWsDtnnDLx4semvtmdKD6GWZE9lLDFyjsHeAFrx8pkss4X/XOWozv1tvZfYjTK5TnNZz4cYlU+1CtxlMGXruBie3QNljY6DndCDiK5Ze/A3GZmenaASXKkAsXXcfb1OBDGru18zgsgUueX8YKRZKy7AoH9wxJqsjvHUlEfcAil+NghugtuquGNp/wGL61vvfW5qby5YkD7bVeVKsX0HfN1ZH6Eqk2cgt4j0uehWew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsa2VwTp/iHEtZBMgYCE4CXlKuVinDOP8L6qj+VH1Fw=;
 b=nbCq3XS4yM9BLHQ54McNK4kcv6k2mBQk0hfUV+j37cTyet88kCfNbhKbjZqUGlnmQ5zMuqHfRKzJHIZFdEwG9T+rWWCMALNt02RniAtQYKzep8NNm7enLjKk5dFECyqO64FQXv5x5VTIYIfaAcmdSCVVl4rcgwtbVWRqYDsj2is=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 10:38:28 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 10:38:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 2/7] scsi: target: Add atomic se_device fields
Date: Mon, 20 Oct 2025 10:38:15 +0000
Message-ID: <20251020103820.2917593-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013306.namprd07.prod.outlook.com
 (2603:10b6:518:1::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0382e7-36b7-40e3-4c3d-08de0fc4ce70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7jbSjhcKLrT+963Cj1LRokK2l41dOsjQ6+zK8D4ajxYPTMVXmliQlUn1qagD?=
 =?us-ascii?Q?r1OaJm6xfiXfuQYVXblz0Z9DPC61f+dTcAQaL/K3hsnp7VVamL6QImC3c/F5?=
 =?us-ascii?Q?T77jcwinOJSBWD8nH6t+ypRhm9xZgLNwLXGkaWcotkd18hIOBgHLLP8n61UY?=
 =?us-ascii?Q?oqnrZnJBieLsSIKVqu/W1SuByxNIactbjXrfIB0Es9DR3OxRBc8rmDLxoGs1?=
 =?us-ascii?Q?Rt5p9Q/Ub9E1er/2kc2deVANqT2BKqcs5JEnSNZo544Nyur5shIHHPySV0jM?=
 =?us-ascii?Q?dsky69sOcfT2sNlXSyRsUo4Gutn3Ml0fmAfSKMBlDJq3R89AgRKVOyKH5a60?=
 =?us-ascii?Q?BRSz6ZtvNnfUMRjX7F0hrkKNZ6bhNlkbSmQ0iQr9gMqmW7Vydo0BCPPYIuAe?=
 =?us-ascii?Q?212r88k93Lvpzz2HYhOaOMy70QilX1GzQfBZAV4wVRa/cHYjCaNQZIOTp6Dy?=
 =?us-ascii?Q?WyN2Jpdm9d2ChsXLXzsyVQk8j+oS8nvckBkruHuS7aAtyzuvjuJ02261oCCH?=
 =?us-ascii?Q?gO4Drd8WV5E3kuO27GjZe9EHpszgIoXASvT5XcTrtNyIp9n9sjmh/OmO4yQE?=
 =?us-ascii?Q?y0zHJ2hXyNq8Po/lnJTR03x65ZLQNopRRh7sARknGkIXPc6XgcxZcPaYA/o7?=
 =?us-ascii?Q?OxTBzn9MDKFSBcxDoN3KVBlSgq9igVwk/LSJfISZyhuz5H4HBl4GKpE2IMo7?=
 =?us-ascii?Q?gP30AaammA8iXX+cKXsUBWH5jLAzeos502wa8wBVM1NiZgGsFVCqEfYMEhWe?=
 =?us-ascii?Q?MMJQ+eR8ke0JdfHox83nM+JcYpdqIMAPm+tBOa2ZNl0G7zGXRFXO/Qq8aElo?=
 =?us-ascii?Q?igTAsdibWJKPAz/YLKJ9sO+YLP5I5No3jrevO9KviERWxBs3uWghp5IbZ2gf?=
 =?us-ascii?Q?irNnMjO/altQS2SfHkaFaeSPIpPj2pu6bojTd0UE0hWePjQxBJuB612D8Rji?=
 =?us-ascii?Q?NB4zF0DHqZGft2/q184lU/WQQS767RpJCn0hIItQtiOVo1yI/Iqz6BGUQHn9?=
 =?us-ascii?Q?MkQ6YdLx7PpSbncLadlQ/t7IfkOFRBpFu7yWU641zN96o8m2pGYsU5n2GYBd?=
 =?us-ascii?Q?Amu5buIpk0tW13ar3nHN7GmCommT/awBa3LLUkSattQbqsPfKr3iOy2WcvXJ?=
 =?us-ascii?Q?ILRfDEjQSkxX/X8VtIu5w+5I9S+XOoDEy4yAZcqbQvdHKLGSz+kJbVavtNZZ?=
 =?us-ascii?Q?E6mm9oh/BOVVnuebR6w+PBIyifMC8GjoverGLmVsDQ4EaK+efMzBozh3Qocg?=
 =?us-ascii?Q?GkTmeNUiecYqThUfJefZdIJdLpF9PHLVYYWkz6MOcLOuPKRfR2V+IZ4cqprp?=
 =?us-ascii?Q?RCWwWI2PFD7oRWsT0shT7wglDBzrRGI7AWswQxO1zpp+3EMYpWfi01ke30Ra?=
 =?us-ascii?Q?ns+mHzkmlcpky1A2iUl2yvSm7gBVzxpe2r4c7Fb9QBzuIYTiCu21t6Bxyk12?=
 =?us-ascii?Q?x2ob3cD5CRJpLoQPOvrugrazBcEm3FwB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k9cL/F2u7phcQsEz6nq13R456TVtHBEaGLoreqXUJhQk6cCf7Lb+8fbTJtEm?=
 =?us-ascii?Q?c10YXYJTJRGsKNg9jgv3tpNllqhO4MWyT6ZVNOY2AYNhNBRzF5Ez/NXOsfZ9?=
 =?us-ascii?Q?HigR+jcf0I2DAUQDkDQf9uR5yWJLt4Y6jx7omEnl+JW4+gf3HGBNSAlRuGCu?=
 =?us-ascii?Q?1m52ejANxTx+FjAQ6xlbOELTm8+WAFIDWZgRKxEedqxYBX+SowXqr43FUVdw?=
 =?us-ascii?Q?vdjiqUHAFPyF9rhz3Kz88DjA9V9p+JM4oshbPktg4QhtC6n0qCl9j1W2mKGf?=
 =?us-ascii?Q?xp7+eERVt4KwR2bh9BB5UYR6zM4uHgLqu5nbCaKubhKZb2SupIc3Vlwd/oSA?=
 =?us-ascii?Q?qmhAwKYNKEajUUjhMr1/zP/1ugVbLExFclYaDD42EfxbdWZur2NQV5f7T0Sk?=
 =?us-ascii?Q?LkdjXHC32mC9SeSh6Tz0/v6C+6GQclqAIxRac3Ap8mAPwjrL1VzjjZZGcFEL?=
 =?us-ascii?Q?CzZz4wGNkBGuIx26A7cBQcQtJ/gg8X4mz7/L6qBA7fsA5zbf2g4Q6VX0PoCG?=
 =?us-ascii?Q?kfGp9FhZe96/GL+mBB11jKQ9Ez97xrYzaN5r9Rw4ajl89mHNq+b34l+vT/fI?=
 =?us-ascii?Q?coxzKRRLxsz4MEA5sjtEPV0ZgOrMn6yVjD/dxK7/5mDHgwds96tUhyIZbJ8W?=
 =?us-ascii?Q?R5s4dfVa5ZtDH3tYaveH5a6yRIfvcWrRMJgJmHpRjEigwgu4AUdF1dkBug4e?=
 =?us-ascii?Q?rb7o3dhm2bFxX/X4fWbmUXcQ+RQw0KUcwUdj8JptPvO4dBFsNtIu764t0JSz?=
 =?us-ascii?Q?FNLTPgf96I52j2WPh4LP197kpRrHESJIwSSxnU3o2g9N0etbk2k5W4xhLVVP?=
 =?us-ascii?Q?sJAHa0y8iNqKYLglWZlrYLWNWo6xqLYBt/FJfFRW7oQzzYtpODqPgXX9PnaI?=
 =?us-ascii?Q?9t4VJXC+pulMIWotn75Vl7kow/SRQ3LRAHnhnhSHyv7Ma3SvmYYxZ6vIuI1v?=
 =?us-ascii?Q?ri5dtaUapydmvjeql+CDIs1CRhf5s96nxPF0Szy8OaVw5NEQvkKkUDozhrZN?=
 =?us-ascii?Q?vCCRcA1kTq/jKQ4pwqjk2oLZzhRR5fNUGlrDWouBlsMiH0lOhQr5uxiF56hE?=
 =?us-ascii?Q?KwglvhJnLeF0XoXo8heNmWu0oqLqZ71Yc8XU8qOuB1h7EMlbcyKyZE5Z9haA?=
 =?us-ascii?Q?SezSprYdCqO0Y78QlUkAq6OxGEn3qdZcPOIXW0VivPa787CcLjLOFZ6skYgO?=
 =?us-ascii?Q?OSV1DnfyKTDNFFo05wpj1hUaDU2AXEyw6c+s1JLtqXVFIn1NcfD2qmwToBf2?=
 =?us-ascii?Q?jyM9rVagZ4X4cWla1n+tKjS0n9SI2h2L31hPTAvFbmQquyDoRBZAa58wKCSE?=
 =?us-ascii?Q?/iT7LM9AplfhyZ8BaTgXSsAPk8vRWOc+oqc082OcH9RO68EtAecHrt/fV/Ia?=
 =?us-ascii?Q?/Hi9Mgd12OVw5OnothDEMDQ/emmZCKaeZ5Ut/Mca2ox76G2tqV33lEHk1Qsf?=
 =?us-ascii?Q?JZ871nHuSdDIlm0qqMQOUsL1BdukmHN1122kg1ful5MgqVuSw3NvyJOlSnq2?=
 =?us-ascii?Q?FH0Er8oMaZWo2CCdp89KqwwOImB+0Rc9gBG0xDc0SJwe/+mMEbTWVdQWLa16?=
 =?us-ascii?Q?DiUl38JfOfVXXNT6tiXz6uxLkzUftZJefSAC7w/plnsucA+b4pXO0NjFxGHv?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dwta6Txncn2f/ZN4uGdUuIvTRF5qpnAtB00OY7sCgh8/7VxMZ99rwSAg8Zw8j2Hmg8BG4yzlDNIyGy7tlSxMM+xu6K7XQCwmDMgJcIMy4c9liX99zIyB4zd0H9yTsbiMSqqsbJzRKpMatzRsv+2ys/QMUuY70eczr1PoeyaxGCK6XtoPMp4RCe2hTSqRV4gLjUHipeA0lWFoVt6/UDO0eLk4GSDnfaWbzfSTcLt+ic93k1qKo5PZvhAOj/ukb3+pj4d46OeByU/FnKjgRXr9a28bqi80phM2MjsszXFqnpGl+RJfS0n4bhG9AldF6LnSp7JMAOklrW1nv/iuvp4DQ8YClU1/wdLhCw7W62MhUihNAy3ZxIeVlLSAm0YpoH1VaOAwMRzZs3fM+yPam09OapdbFYVUZYI/JPxOjKkEOXKzh3NLnl3X4SPmNgf/pkoIjYpYrJHCJjA0+EWQzhZOBIU8zX6d0NdN6l0clOavDqwJJpo0MUozBk62ensrJstKpf5ItqlLn3IsXO29IuR7vrb9RjO2v+QNTjPPi0G8vJptn1vD5mOwHPfVKR45uyF3eDsrebmknMV3k6N0mhtvDu8LTcqfRK27jVIY7gL7JR0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0382e7-36b7-40e3-4c3d-08de0fc4ce70
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 10:38:28.6730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oA5UE9tEG+oEftvmnkwONgAoYZY0LIHHggz9k+ipFJ2cwwD0MYEAW+8H7PXj7G5ZTNTCvuWNyCQw3GPu5XqP9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200087
X-Proofpoint-ORIG-GUID: 5k1SK4_J4L0aypQTLV8pT0s3DLsnNRUL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX0YwMtO68LR/R
 brLs63NtUOSdFGw+QcI1P94VsBH/cG3d5FWjoSL2/1Ss1QbBH4FfVGNXIBBPvRLHiNlP6E6K53n
 A9D5jECm75SdggxEOHUFsNPzrA1FyPxniIsylWYTNKarsYdNNV928vRbfSDqkN331nZEaEluka0
 LZZolTR7hf4pY+xqTjfg4tcriLVuLjr0b5W4rcHxMvBy5/9pnL9CYy6MmTVOGSxSyImSMR71+cM
 7+D5YrWwKxCGA2Yb/k36kFTqimjPk2gwg13JUw/Q32y0xGxy8wVfiGmwM5WLFbQvwbvKKQy89ti
 YOSsvymC8uab/C0gCeVkDecF78JIkMLSa+ynzbQjRTt2HXYSOqmFT99FDvvz2JcMfPb//qVJ1Te
 2esTq5IITe1TdJXcnVQWSvooyxWlLw==
X-Proofpoint-GUID: 5k1SK4_J4L0aypQTLV8pT0s3DLsnNRUL
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f61128 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=ybRmI6yWmN6hDEXPEKUA:9

From: Mike Christie <michael.christie@oracle.com>

This adds atomic fields to the se_device and exports them in configfs.

Initially only target_core_iblock will be supported and we will inherit
all the settings from the block layer.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
jpg: Stop being allowed to configure atomic write alignment,
     remove atomic_supported member
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_configfs.c | 15 +++++++++++++++
 include/target/target_core_base.h     |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index b19acd662726d..5470c1258445a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -578,6 +578,11 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
 DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_with_boundary);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_boundary);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -1300,6 +1305,11 @@ CONFIGFS_ATTR(, max_write_same_len);
 CONFIGFS_ATTR(, alua_support);
 CONFIGFS_ATTR(, pgr_support);
 CONFIGFS_ATTR(, submit_type);
+CONFIGFS_ATTR_RO(, atomic_max_len);
+CONFIGFS_ATTR_RO(, atomic_alignment);
+CONFIGFS_ATTR_RO(, atomic_granularity);
+CONFIGFS_ATTR_RO(, atomic_max_with_boundary);
+CONFIGFS_ATTR_RO(, atomic_max_boundary);
 
 /*
  * dev_attrib attributes for devices using the target core SBC/SPC
@@ -1343,6 +1353,11 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_pgr_support,
 	&attr_emulate_rsoc,
 	&attr_submit_type,
+	&attr_atomic_alignment,
+	&attr_atomic_max_len,
+	&attr_atomic_granularity,
+	&attr_atomic_max_with_boundary,
+	&attr_atomic_max_boundary,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c4d9116904aa0..70ece58d30780 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -731,6 +731,11 @@ struct se_dev_attrib {
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
 	u32		max_write_same_len;
+	u32		atomic_max_len;
+	u32		atomic_alignment;
+	u32		atomic_granularity;
+	u32		atomic_max_with_boundary;
+	u32		atomic_max_boundary;
 	u8		submit_type;
 	struct se_device *da_dev;
 	struct config_group da_group;
-- 
2.43.5

