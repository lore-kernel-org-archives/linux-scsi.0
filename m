Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE8D3BBFCF;
	Tue,  1 Sep 2026 10:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259602; cv=fail; b=RL8RK5A4mXz2WZo/o8Y4Hv8PvZ1eLqFePraI0YIECFFpRGNIm56P/aOL8mY4r6hqniFkAK0bSPdbpA9umxSII3ysRT73wH1QOpGldG/PNoLtodR4VP7Zcq3rhfWc/aTYk0J5hVIVONtNo6ysalnKJgVttgm/uZ2Wl+ba0btghno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259602; c=relaxed/simple;
	bh=2Ik7erG8b3f+M+YthkR8zBsM239sa/PicPIbV344Ub4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eScMXI3qPLaF5e2yFysoQaqK/qWBk7fGM+NRJkvN7n5smRYtCGRqEt4qDL5S19/72xpTeTydxrlTz5MOl68l/S1ovy0leYLkldpQ6uV+5Dy6LQGcuLt92ilcG0BTlul1wPlhe2PbTCuyn36ktMxUtFK8mQCz48oFBD9uWC4/aAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZPzkKWup; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d0BUxWS/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZPzkKWup";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d0BUxWS/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBlVQ2311045;
	Tue, 1 Sep 2026 10:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1Ms7IxDUQPuTDo5BfD17e5isRG4nX5vUE6xvTEA0Noc=; b=
	ZPzkKWupsEOW0RydhgmZ6JI6Dlj+kDx2e6P/NXSDBlzbuHN/YQEVcg+kLo9QzG1V
	cHe3TkSWQfPGgW7BQZobrLbjD2+j48cq5vboUtLLcCyYbLZRBEMoZS3cAttSULX5
	b2ZavGWllBInDy0BHK0Ja1CnuaXhdFFO3Ub2ai+WGbC9ENRQtyS9CrRl++M8ObgO
	KGdGWzmbTUSaCpaTaYW8hXE+Uq6V6fNWWRhGAuq3OM7oYKO935tKo1F+O+CGS25e
	GYp9pTnsu6998SrebwkKPJIjATXamVzu/vuvCY3iNg+85fwNdD0SnukWcxX5nIjC
	/ptXqV8r4cmsrZRNJLeuJA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbq1smbv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjMtW037319;
	Tue, 1 Sep 2026 10:46:09 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve34mp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8QO0sv7Ot4ALUNoTX0cE5jOdxCWaKwZ66TF++hnPx5itgzZebsIrTZw1kvMlWX4hsfkWoPM+eDIwAjOm/zRLmjPnvy6y3vcpdV6MHtHBnbe1Zh1LF2L6hitcZWJWg2Ikia2wa2Ks7SIkbf5VkI9nqEwH7wgPz+/ds08ey5wGVNsGcHFxREbBSZgPu492cKZHW0E+ALRaIW+3syrPSeGE5nblH0TER7Bu25mLVCHcrhOShLu1GMxz2IoxE3dsgilFCdsSfxdg5koJGjJ6lVHaz8jT4CTG5tO+XMfDZmcjv8K/H7MNa9pnDHE6VPkO90/8sV2ZBX9JwDHOxmenSEFGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ms7IxDUQPuTDo5BfD17e5isRG4nX5vUE6xvTEA0Noc=;
 b=aXsomSQT5NcufU90vcY4wU+RKAMYZ5k6C40aZEwiS/0rJ6bcIu6ivSNbSR98Hl6+fIuJ/6+HJU5rqaGYAoIWjqy89CfxX6BJMV77Q23eoKwqiNx/af5df9By+qy47wn91Gl4SxgyIr0/oMUwwFDknuaEnXRvaMtNblRqHhbHXKLUzKv66urOkL1jtynkgTmZoryDZfGDzZC+rFumSPbc8wkj2d2bsQRDX05d0kdXYKstlLzRJdys+zsToOOOKsFwf1li1WcIs3smLAbBnUmewOCPPPxAXwNhglEAcH6Zber8bFAj0HtZKclzarCS0R9/em2A2vmx6psG423WWCMPiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ms7IxDUQPuTDo5BfD17e5isRG4nX5vUE6xvTEA0Noc=;
 b=d0BUxWS/TcU2kyOAopUEqKTbejCEkDYNFfNXNQ4PMjCjYiZH6C3vnQI0GDSZGBjRFtOpEDyyF7f6PFBDOWY2MPY30UPt4cWl2kPcz4dfr1oFKXtYIVBq0OCKGTmjCO7ygM/xbf9NKTtoZ3rpvrsQ9HcNmF5RzRkYisYCJYHva6E=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:06 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 14/27] scsi-multipath: support iopolicy
Date: Tue,  1 Sep 2026 10:45:13 +0000
Message-ID: <20260901104526.3850621-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0021.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 051b9637-81ce-4b81-9427-08df081639df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	uoLRyjGlLyp3QM7fjwOp5SBn2ZxLnW3HO4oqxFzatUkgIbUHWiVv7v2Fqcq8iZ91cSBl/pHH3hRMqzsH5GzhZYHxpJFCdcElwrZ+LP2i+jcNcoBu1J0VuXjKGjDqcyV+QzkTIluFgnhgwTnU16A7TXk1NTGYAKGDpLgKMHOyo/WMDs4FjCQiIGFuGBLAaU/47ugTu5To2m1Z0q5UvBxU9W2itU+zKwbwcy0Y9jpNKX6zhgES5rDW6wsA3+XyLiho1AZPzj9dAXu1/lEEApEyngPzwuRzKvSdEkaKdd7YIq+UMjrprKW44OgepEWcmznywCGtTfG0vY1KMOUG5bZNHBsyIAyT09oT8FIgOaq0ar/6yjBwSxVGLbj4AueCEaHYbZF2tgyb8eNsAnOS3vXiL4wdsvDvVMBkv+lYGcjI3rLbODEutj7yHoyeUt9FzqcA5+4M940Jmj3K5ykVqeCc5lBWxtKlPdF23QD1Job7K8P5VM37TI+WJnEusBJ1nIxvGE+J1OL3e+2AtKX1iEgUEWS7qVgW7OxmN2+6WvOGkRUaR8zRjOvtBUuBc0FnzdR8paCTmKDZkaQgXa+njZvNxeWv1Zriap12cHfiIQYyWx5HulCpH5HyPvwKdH2Ef4GCtZYDd5EkhjnbVcqFgp6P/Wqg9BjBXms8k78X7YYGwKc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aSCR5uXSoZrcYk+UWQBbZKL5VyIAPto2VEoXTFQYySRlbFPhcnxctzExRw36?=
 =?us-ascii?Q?vnTfYMXjAK+v7+sRFbowynuJeRnkmsSLDCitfgSLYzdPMNLUhjIslPjuOtlo?=
 =?us-ascii?Q?BaWcIUUXlVZyPTe9zt785oxUJ9aJSCj07WB4exnpAFTx+6Z3aLsAe27pL/Rv?=
 =?us-ascii?Q?ydApZnrPLr64rLvcFsHSjcwteaTwwbJKBL1UMi2JV8CsUqsRH5uDo5KOc2/p?=
 =?us-ascii?Q?fv9krt2PIrr/3zQByNnMDg9N+Tv69SE/Vp6E6aidt6W/GDeHZtKzRHpEaTWV?=
 =?us-ascii?Q?3IWQ0PskbP8OWg8Dj1kCZMeopSSDpBpMQZPEXaifVb7nl6Gk6dh2sSZjW2bo?=
 =?us-ascii?Q?MKXDZN19E8+Z/wNm2ul/3qu6lu/1VmJUsayeYROAATk0dDjJSTZcRH//TlV9?=
 =?us-ascii?Q?39IRXteaJwLqcgMPco3PLYsPeNiY5GsPxayT0vjrtxmdvsIaqIJi2WgzVZQl?=
 =?us-ascii?Q?qNbnT2L4s7dsog2FgGlgElev//8qO+f7G7neWhcsIVAWGe0Q02LUOvAuYMcM?=
 =?us-ascii?Q?60xN1PWOEkhePq9ONpvvmNsrfMpo8zzvYzSV2s2J+N2j7xYw8TWxAkrs5HmU?=
 =?us-ascii?Q?ms/ATmegIK86k9j+8I8TM5fWX3SRLedX63VmrVCV0Vn/S29a85oIT8rlHCh2?=
 =?us-ascii?Q?wb6i2mmYofI8by6y14GYpC1Gf+X/BdC8EsoV/wZD/3lXFVskQOWqhBim1hzI?=
 =?us-ascii?Q?G77UwhtYKKvdEVHuEQyuShu+UR61MabwPbFe8LOh3OIzyY8FY21vVFkqcLXs?=
 =?us-ascii?Q?+uSK/qS0XqPnBX9K4ecdGVcRRntg/Xb9tayeeAPUHtIaKNFransCjY/hm9dO?=
 =?us-ascii?Q?VVk0yaX/oEgf8qWDLDjKErG4+0ErJeUAJ8vLt4qSMiPIsmcVtxuuioHeI3FZ?=
 =?us-ascii?Q?MG6mZ6A2/CrUXkLRl4wu53zGCancfXB+2H91tHEgBnWbYmW2Jk1u7NP5Uf9c?=
 =?us-ascii?Q?FP56ytFc9vTAt04OyB3i8rKLfh/qjMzBidtz5/Okm/zkQwDXzJIx1z2fnDgM?=
 =?us-ascii?Q?+FYIGOt739VkOTT6wFg5maBtezwAveRZfWrsRlJvQ7xvxJLDq1Vfu6pvO8xO?=
 =?us-ascii?Q?dIRJ0/k4EvxvYNt9LlwJ1mSXmnUc+5SiC4E+WC/jflpZ4cew4ptwAJz7lcdO?=
 =?us-ascii?Q?hYwZ/m80ORNkIKtIPyWFOKOyKc7TgW9LB9XeDKKEGEw6Rz/pUOUH5PUKqyJe?=
 =?us-ascii?Q?AWLSJxmOXN+rkDMFL0sx4/SpSLR81EuetbDCs3mxGMoQ4OfO2aGWe23yP+tT?=
 =?us-ascii?Q?6DwYdSxBYBTKIucZfLzCvhp7sRuFzB9i7DVOcK09TJvnwjAmWzeHTlfnkk+B?=
 =?us-ascii?Q?8/dbSju38ofANjxsCD27ESl5pWdsaOQ+8qwvdbmeVFeA0NyAxf9e+PRhW2N6?=
 =?us-ascii?Q?HE421BV4gsb1wglwQpckrkvCDGFtGRJ4if0vqCF5LFRNJ1DZgi5YnY4iFZ3C?=
 =?us-ascii?Q?CzXl1afWL1lR1dICMq7n3joAczkQzqc1QxsUDkmoE34uWstccah3Ckgtg78J?=
 =?us-ascii?Q?klS+sVF863PljadHaYhKtNLiW8wxIR9fPJ4qBEkK+eyf4WWtZa/WWIev5w6h?=
 =?us-ascii?Q?IiywTyfTqrvttHjBDhDhfnFxeHGFfhMvOeRHIamJwaZwxACRvIqIjuGb7iQp?=
 =?us-ascii?Q?hqhte9vzPOPjGB33uozGrJbCSg6s1r6XoMl2o/mpyv9K5ukQUmQIHPfkOQtW?=
 =?us-ascii?Q?pmEOqUTVw1kZPUk7xB73ruYk/mgVcV1NW6eUJ6XDH16PZiQZVezMzr50o0il?=
 =?us-ascii?Q?WWxLQ9a4KV13JVXGtyAB+azf1DKonTA=3D?=
X-Exchange-RoutingPolicyChecked:
	T9NTUvtOUbQzZ6LDaau7lPxBJgdE8awM1Pz0KfkjPrElwfW/tab5oimIQeRRqTvUM9TiXyl9yN4qYjycFg4+ZkFThMoz5LDApI3lDuK+HuJ9QoVMrklKCwuGYMsGbuYNcWM0sDEDeBXVdZF0CEU2241JI72SJjqbpnXihMkeX2hUJ0+c78ky007mnYKt8ixKk+99kFqoztJ0QMj2QOBWXw9JzKchTROc/IXc2rIOAgtfTegURquKZIYKkh3sAx32n5f8eanErkBJdqP8FThgIPwkJ76bJjVr1jNi9+WIJqhO/sgqbltOTbld5SnRYmJA9Nj9BDtQLZ6cm1p4moIw/A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YFT/kB1bo78EpBHuC3Y+f3VvUp9FaGzai8rAse/HNZoQTLhYNcc/dT96+5scJ6Wri7diQqVXc5CbkAkX8tax23+sNiclNBCtI1bWsH0F4upQ79izrM0TbKU0LKh3f92upO22Q0h7lcknrUyyswnXAptLszAeaGgOrq/+VNa+Skib0VAiLBHxJ2YYu3/tVHEGKVq0Gy9m9NZ94BUmWxvSajCHQAe1mh8Jt0Lu4U/XwmfWdg8+9JD3OZ7vvrvHrpZZuwDXy4rljuxX7dbfxBB+EHFrkZPSMcTE3Hf6mdRYDs30e4RaWSp0PSoKYImkZWZc+Mx930yczldQleGLgGrsHcnSOGkfruHahi8Wmp/XoYFsFRuxivxdrKjcl0+YBQJzVqWae2K3H0+INrBjOncuNMvmxCvexSkVKCxE8IMB3IyUrcBoOclHX7sByyCWfxrcffX5ZVQfMjp8UHZD7u211qC/MK/VnJz4GcOxpnZXlWKItLJWkS8j0Ib+XaDOQqKSr57BMPvh+0WLmi1gGsddImmuvl15uWJthAkpHeWTYQ607ZLlsQpfyqvXXp7dKi3M2zIw7g+LT5tecgz8srcjn0j6wNZM1zYJUIAFw5nEKBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 051b9637-81ce-4b81-9427-08df081639df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:06.4864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DivqwEgPZeVQAUdt0JBJCVjKN8M+KEW8usnxDMGNcumzQnXL42mhn8CJDvoK6Hq+2R89eIgyPtJbWSvsSHUbJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Authority-Analysis: v=2.4 cv=Vp0Txe2n c=1 sm=1 tr=0 ts=6a96acf2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=YKYambv--S9dnOAEj4gA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX/4WFvLs8bRgr
 U6YF4Ed44ZwUSHusKziLgYRszPlZLTTjisiR9Ph6gSewm/Jw8p8IQk3jzbiaaPNzITiqEwZEKhB
 mZmCTmuy0+WkK8vRtFAfamvxFgLBaDDmiqOtRmarvW+yTEmjq+fx9V9HORDtGW1DFOAYQcCdDgY
 H/mE4Mjed6F63YiSOfCDinrRVHqFT/PRXiC6dEYBxanoKMoGPBzLziZ4M707iHjzOe7uNCgHWro
 ig3r/rtHfUuH6XVGbvo/w+LaZZ0thwKeMGnMBjoGf7g8kMaFKLidb9qbJ3U3chfq0/Uo5SI3Wr2
 UkklfQpADOhU8fW2m1Auzpcdk1R+DjVUbXTASh1Qf2suDyHfooK3ed98/YUGIkUKy882Th4tBUO
 T/Fj4QjUCbX8e9qvHrOrFovRAwjklgWRp57IwWFXDzNQxSXEjc4a5ddXJgH86InM83SHbaMtYuK
 zFxNCrNWsu733WcyabA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXyXCM+3NoqLTO
 rIA8dpg0on3WUnT0cMQbDyzuZrvAhZDwN8/gOXgJjkKj84Q3HLPcAvo5SBK2NpCQyUIHb/hpLfN
 bcUihau6FHi1WWDc+BHoqwK4T4aRKv5FonHJ9PxqPGTuiAqS0Tz6
X-Proofpoint-ORIG-GUID: Cw5XbjbbN96D685kKOxpj1nJllGg87CP
X-Proofpoint-GUID: Cw5XbjbbN96D685kKOxpj1nJllGg87CP

From: John Garry <john.garry@linux.dev>

Add support to set the multipath iopolicy.

The iopolicy member is per scsi_mpath_head structure.

A module param is added so that the default iopolicy may be set.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 52 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  3 ++
 2 files changed, 55 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 1c04947d906ea..7164bc61e65e1 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -61,6 +61,23 @@ static const struct kernel_param_ops multipath_param_ops = {
 module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
 MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
 
+static enum mpath_iopolicy_e iopolicy = MPATH_IOPOLICY_NUMA;
+
+static int scsi_mpath_set_iopolicy_param(const char *val, const struct kernel_param *kp)
+{
+	return mpath_set_iopolicy(val, &iopolicy);
+}
+
+static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_param *kp)
+{
+	return mpath_get_iopolicy(buf, iopolicy);
+}
+
+module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
+		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
+MODULE_PARM_DESC(multipath_iopolicy,
+	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
+
 static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -99,8 +116,41 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
+		return -EINVAL;
+
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+	/*
+	 * Ensure requeue work completes, as this work could run later when
+	 * the mpath_head is gone.
+	 */
+	flush_work(&mpath_head->requeue_work);
+	return count;
+}
+
+static ssize_t scsi_mpath_device_iopolicy_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return mpath_iopolicy_show(&scsi_mpath_head->iopolicy, buf);
+}
+
+static DEVICE_ATTR(iopolicy, S_IRUGO | S_IWUSR,
+		scsi_mpath_device_iopolicy_show, scsi_mpath_device_iopolicy_store);
+
 static struct attribute *scsi_mpath_device_attrs[] = {
 	&dev_attr_vpd_id.attr,
+	&dev_attr_iopolicy.attr,
 	NULL
 };
 
@@ -204,6 +254,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	if (mpath_head_init(&scsi_mpath_head->mpath_head))
 		goto out_free;
 	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+	scsi_mpath_head->iopolicy = iopolicy;
+	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
 
 	strscpy(scsi_mpath_head->vpd_id, vpd_id,
 		SCSI_MPATH_DEVICE_ID_LEN);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d224a15ce9c2a..d6f290b84f7f5 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -25,6 +25,7 @@ struct scsi_mpath_head {
 	struct list_head	entry;
 	struct ida		ida;
 	struct kref		ref;
+	enum mpath_iopolicy_e	iopolicy;
 	struct device		dev;
 	int			index;
 };
@@ -40,6 +41,8 @@ struct scsi_mpath_device {
 
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
+#define to_scsi_mpath_head(d) \
+	container_of(d, struct scsi_mpath_head, mpath_head)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
-- 
2.43.7

