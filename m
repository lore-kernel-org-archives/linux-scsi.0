Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8C61A83ED;
	Tue, 30 Sep 2025 20:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759263236; cv=fail; b=HTMRO5kUeWJAYeo2mrjA9Jw5y++G1au9+QORC7BnjzvINcbV+DuWQGSFIuQDB6lHP5RclJts9NabNoVYqUrL0CrfFBJ/Lt2miDZ491ytc5bsvzxUiXyMe9BmpbMjlOuZGzARnliJBdQHVJ4chlfU/uJJTi0KLASY4v0hh6NThkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759263236; c=relaxed/simple;
	bh=JWPbsIwkOZ1NcC1LSIqSzwGekcbLIuso4HnDl/xw2c0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=D3c2TLBQzCSiATjX7Bb3Dy+dhLkTtTNwxZkhhMD6aSJP/LV9TSO4allbEuE0e/2zMImmQHD0UOpRlrBG4QnT9yXOeneI16g+ZTeCqY+AlZeoUG1+fOMmiPjcRSPBO+ld7HnaJquwgvwe1dMst4RFhkK74meUlSRLVbcieb20bTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GhNC5/Ok; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F+GINUL0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GhNC5/Ok";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F+GINUL0"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UKCu4J022147;
	Tue, 30 Sep 2025 20:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=E71DcmDVhCToHtC0aB
	6YNnXP+HGvsr0gusdDsUOUliY=; b=GhNC5/Oku5AnQJjqw9SV20RqL7FPEKvUoE
	EoO5uJJORNofP3Is2fZWOaOkmFWpEMlWVWwWi1izQZA+M/wietXEKNxKPvV9+KG/
	+52Vi0dROrcqP9VfFd/POWSPJB/NfzYU4e7lBWGQ7+btBll40VIZBw7Ll8NebIL8
	36lEJbYjwKoTd4s4LnO5VNOuXFccoNPrJVGNLfxKCh8o6UrdtY+qakyCBV5T4ess
	Az6DbgSqcEaZZPTM0tvGTyFy15Cm1wylHrlQwVdTfMx3SnzAUs2dabDYK2tymJCj
	pNqowGwFgYAaMPig3BIYpGg1kPU7lca+hTjPVE/zFvLMdrQfJQng==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gm3bg8kr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 20:13:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58UJe3FS036448;
	Tue, 30 Sep 2025 20:13:35 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010008.outbound.protection.outlook.com [52.101.193.8])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c8kfk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 20:13:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OaTtIQ06BIYiaEDZvOIVEMsxPTy8u6caBxMuNckJu64cgx4oXMbQGH0yOVleRc0wIVNlvXjKNDw1dVYgPH2kD/6QeWTmA+G1TxoKfG+nL7OSbk/7ZcEOBsrvu2z+QWWR98atNlowzDxU4fNLQS04L7JNq18G+QBgUNsR33nzQDdoqApO3/FZOqMhCUXPuHKWEKYdzSnOfJHhiDWEUZF7W2gFWn7D4HiiDBSTo6aJSUcOYACWF6Ii9ZOqISa7GSFDx7MF1P2DxqpBuGPcx2sclcX0vYAZUZBH5EWUy8OGbzWng5o5eYPckduELjaya+AklYQZZVunHMn038ybZAFg6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E71DcmDVhCToHtC0aB6YNnXP+HGvsr0gusdDsUOUliY=;
 b=i3QQB37MkqaGWEhkcspCnBIVEvjelPaAYoOgbp+vNbD9We6HKSfFOhhJtCSXrbYI72g1KJ1opD/VizYw5jcZBo9xml/2wn97qj8ZcHZpyD7hpfajPfbOETFatDSRfVKFGC8bb/YlhKeqbI0gKJCGhAPPgC+17kONtgp7EDhtq7InrJHpH0CRIayvw9mr47FAG2AUZiNQ2eQBSrhu/OdAf25BaDhLae2dOUChDmVUgh9kejtwWdVZZqJhNMFrXTH0W8sc2fdHs8SlafKfy4zu9m008ElSWAjqWjqzeibvrOxh44o3PslXbXR9qFcsh5B8e+bD/qPCDAhwdT/eq7rLlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E71DcmDVhCToHtC0aB6YNnXP+HGvsr0gusdDsUOUliY=;
 b=F+GINUL0LUJcOU+BtcdaGbub+KN8NRpwLKNd6ZeM3+qhaL+VnQZqTuyq5QIQGdynHsEDZD4FllnVZXoL5krLfD+cRTa7VIkvHjT+akSEjHk4UtyymPg7hDWQM8yar5lDak+prVNMXGxkpkaO7mRH4qH7BoNh24W9voMrjEgXaLU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5650.namprd10.prod.outlook.com (2603:10b6:303:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 20:13:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.017; Tue, 30 Sep 2025
 20:13:05 +0000
To: John Meneghini <jmeneghi@redhat.com>
Cc: martin.petersen@oracle.com, axboe@kernel.dk, emilne@redhat.com,
        gustavoars@kernel.org, hare@suse.de, hch@lst.de,
        james.smart@broadcom.com, kbusch@kernel.org, kees@kernel.org,
        linux-hardening@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, njavali@marvell.com, sagi@grimberg.me
Subject: Re: [PATCH] Revert "scsi: qla2xxx: Fix memcpy() field-spanning
 write issue"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <70657b10-32a3-4c4f-bb53-e95d88435d58@redhat.com> (John
	Meneghini's message of "Tue, 30 Sep 2025 05:35:22 -0400")
Organization: Oracle Corporation
Message-ID: <yq13483n1kh.fsf@ca-mkp.ca.oracle.com>
References: <yq1zfajqpec.fsf@ca-mkp.ca.oracle.com>
	<20250925130729.776904-1-jmeneghi@redhat.com>
	<7b1342ce-0f30-4481-bf3b-ef3c92b9bcf8@embeddedor.com>
	<70657b10-32a3-4c4f-bb53-e95d88435d58@redhat.com>
Date: Tue, 30 Sep 2025 16:13:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0192.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: 214de8e1-b7c8-4c5f-73ef-08de005dc3b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R7BnVcc+ZxrtSIQ7syrlDQj3yn9PROctAooEhJ8VDZVrtlvqB4wbJygpAmQ5?=
 =?us-ascii?Q?4wp/qyUtAEi2s4nmc6XpQHwzPojM61rQu2609Hsob54SV1a16aLnUaQACLp1?=
 =?us-ascii?Q?ZK1CQ7Y0bywC5ObByH7C8V5QOE6liljkkqz9QrLKZxorinvtsLnTOnnOAxBH?=
 =?us-ascii?Q?krHpX7bl5atfmzHJJA2rVWLth4+zYQSKyUejFGZpqybaLlrNu7lZRMQPqhFC?=
 =?us-ascii?Q?N0pEWnpv/PkEA0UZuBapW4/jqBuFHwYTRNsdn1/Oaq0XaptjwfSRJ0p2JyG6?=
 =?us-ascii?Q?S+J2iVPTJ4iN/MHv2QKb3Cz80FY4qSnRLs/kxtUZMO5iMb17rDp+TK4JTnB1?=
 =?us-ascii?Q?vMfPiyUn3wYrSlOH86y/7XncrCrm56ZMm7xQoOSOWGRZMpKxkqYCoiCNQPJ+?=
 =?us-ascii?Q?TWvGeJ6tVb9ZdlmYuLoDZCXydHEAm3DfaUkx8pIk917f1NR9PBoRFmhCC9Ze?=
 =?us-ascii?Q?wJ/MCvhCk6zX8wPuESyJCf3aPB2MStV9Nj48t+8MLF3vgHlVOEeVOO129mVR?=
 =?us-ascii?Q?i+9ahxIHrUS7MqcPa1W51vBB8dMW8xERvTzoNB9Tyd+DbN3e4bL/r/lD+njd?=
 =?us-ascii?Q?c4rUR2otlpvmozPQdscqTc8g3QLlpYQMB0YpPREqHT8CFKt+5BlYSjL6EPlC?=
 =?us-ascii?Q?wm0oG1+PAmdUUZG0eKw9ejIkaIWSYcPguQ/bbfr17Oy0qITt/WWMXwalXFld?=
 =?us-ascii?Q?YblNQKNthv9gCGWUuU8ZlfKd8MKPCtDIGYSuy5U0oLEKwkDcQAKzZ20eMa0T?=
 =?us-ascii?Q?AvlhAuXv6JZZTz/eKHAywC00fsIZGOg4BYKCDC6jvBFrnP9KFoGJYgg095EL?=
 =?us-ascii?Q?c/bCGSQvEG1gRIFQr7gySL/uTbMrFBTHiDX7Ee5VnoacWYEL4RMdh+ALr+8e?=
 =?us-ascii?Q?TkGWV2cDD2+bN1wX3KCdTWTObzwJO4XMfhhMl72svdbjX/jypIjjgy6UZVkp?=
 =?us-ascii?Q?r8fLc1Mrc7JAzuXjcLT/jsK8SHCbVpE/KDRe+QhZ/FZil3VeSLDZvuplZFW0?=
 =?us-ascii?Q?sPLw7tGu+Fyk+UCjPXzPj2eo8KkfAuAjQ443/P09Q+FSeYeiYp448+vbLBld?=
 =?us-ascii?Q?MKT11JXNK1uKNedaajaaATbTXyzRg9FYKq6CendfwXuHDFe9GHOErXxThMEF?=
 =?us-ascii?Q?Lgn5PfKUR2Quw21HOd6YraBCYuqAjgjeP2r/ewXsZS0dkuh5D31Wu02+kcee?=
 =?us-ascii?Q?FPdA8yPoSzRtK5Fvga5N6vXRPSoXM1eASLAEHfXLS+kMBLUNVT6i5Mt04ChT?=
 =?us-ascii?Q?7pIahStF/TelHg6ITuB/uxdFJ855ZHrYY5X+5KpapeBSCpmMA4tpYzjY1xZv?=
 =?us-ascii?Q?glL2Zs9kWs4tt8MCjP3GQypCifCNPKOy10DLoYrAhMB2EOi/m269KCY7AGED?=
 =?us-ascii?Q?XeIegQCXAfLjcoPlvMw9ZCsehjCRPRARRlUk5KuNXuRoT+E9RW/mb0oHSTMl?=
 =?us-ascii?Q?fO/grMOoZt/NKvYFgzE5EL57/Kg4cZr5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6f8BdVqoaLUkjcRJrlhXRV+ppvLzgBTwD1XglRpiFamBGWEtSYUvndpYljtj?=
 =?us-ascii?Q?4re2WJOTkEOYLZOcKyppPuCRPCiKZh5hoOzhsQJszL3GZu910UeZ/m/8DxOY?=
 =?us-ascii?Q?7ME+h4rIJJjIEvdiO3h5SExmpC35Rs0mcFLuMQr2w7RduxnLNZtclSOTLEii?=
 =?us-ascii?Q?DK++mjF1ZFSnicGm6r+M6ltegE8wzcWxmQwQ7R/d1mmhy9KUUYau13duLcJR?=
 =?us-ascii?Q?LSmD86T+KQK88QU2IbnurfUBJ1Xb74jmoEybi4oxpkeB7KaMlT8zYMMf9MbI?=
 =?us-ascii?Q?VxCbBq0X709CMbHv8s9Jpw2vS9AaWsQRPaO9mW7BfDAzUGXiyy7IQgWPuZUV?=
 =?us-ascii?Q?hHcVYoLsTZAHb0hUWCsXTlmrxbyC81lSRGWqaRM3MMNEf9Y84vKgMR8JbRdf?=
 =?us-ascii?Q?KvUAgI+uTo6K8KqBxqeHprTowh1/yDojilr6zmpF4ZB0Y/5Gj/eLRRCB/Rjc?=
 =?us-ascii?Q?WJp1Pu9HP/0YX32Kik9iAbQw//f4YnCqYY5e/d/Mqa+qj1R9DWn8cuqVPQ+S?=
 =?us-ascii?Q?djwSaOsSD9n+HMYwqVnWAg8p5sJy60KYwujCo9MQYlUzhlM54xUAd4r9t4ha?=
 =?us-ascii?Q?NAnqUW/PTgO6NddbNA8OuVHY+GGr0nhjzxdUSIzIVjcAiUhU2OiY5+O8BP7t?=
 =?us-ascii?Q?pilhqvwp7OKKyneRLrXfVuX/ndLmxfbirixix+rpQIhZO5ElfxqebNTyxEfN?=
 =?us-ascii?Q?7EjzOtlp+yWBDlx3ko+4uakxXAvhNAzyuM3fd5nCNwDp9f9FnhMlAEb6jbVO?=
 =?us-ascii?Q?Msj/XakEj3RUG8Za/XDjFOcBqByDHpaFx/5kvM39HVH5lSBOlVd198AMCN6a?=
 =?us-ascii?Q?HeylGLEXMeOyIGuHNkEHZFj1nYj7eu88TqO9NEHPzW0kGfwsQxzbB4Bfibps?=
 =?us-ascii?Q?zzWQnp2QKWvudzANBTYkfe5DO8IrLCiCDH2CC0qn2xAbYLd8Jo3LGAGq5wLI?=
 =?us-ascii?Q?rGPYPpJkb46C60gBUgbszyro3cbvwlX2Ww6rZAUMEAHdsAZWtbvXakaktTBf?=
 =?us-ascii?Q?h0nwZ2+D1eK4md7X/QhZb6EEHQa/in6mfxGhx6KiZqyrynjlhBaqy67+NnOW?=
 =?us-ascii?Q?lyLUeLBveajd7wdNNCM1GAyUJ2p6qnjJY04c0cvNGvLlvBmRRvRrlFp35otU?=
 =?us-ascii?Q?G4Mcv+AjN6ZIX35uGEtc1Qy/hcrKa6ZtChyjcYCR3/wN/8ITYd6Mh/xqmJc1?=
 =?us-ascii?Q?+wtnOBNRPwcr2HdZAIr3FlQc8KF1m3zORqoQw935ZpWJCpLzofbo9QFyflqD?=
 =?us-ascii?Q?8ZoJrzSUjfVZpSSbVICIWtI+R9x2g3YrXhGchuRXis3nHiIgKmN02UokxiSo?=
 =?us-ascii?Q?yld8W654OPWyjxl/lgN+TW7arhQnDJ/A7jldlgHN4ycKUI7id294jYjecPIn?=
 =?us-ascii?Q?gtwcHscxzw7EBhDfydPnoyeqol0rTaBOm0hy1FgwfP4PMxk6HuvNMFLzQYCn?=
 =?us-ascii?Q?OzhiZATKE0cyLq0y9kS3wGmqkRc0nVVyBxLSAEkTmgU1cgbbEHcjMCHPinK2?=
 =?us-ascii?Q?Qfilf+7+naQIzPpuMBDiztTtkby63v8SXLyxdblyiQAIWgI9+4Nk4G1GuGtE?=
 =?us-ascii?Q?o1IGPr2pj7+/Z7KWVDCnk2UzZjgUCS3RMsX1HLygrnK0UtRBPKo1zKVSMRrF?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ETyqqIiv9NZe2JcSyQrsd4f/y5Coh72lduLzRbAoUSfSS39gi0eVHuyVSXBEYpn12vck/G6R7iUxGc6cvODUvCGpZ/NnjN8IrBysapK3mYFNW1tZdxcyGq6w+bgGBMsHWxSl/QGlSMoxmCO09JQRKEhvZp4dqsb2ha0ORzc0Qu8kIW2gKuWQ7Kk7u0DQfcMYeOaQ3vXIzOrWyIDLxEJ6xYGB/SehJzpRgGxEHCKnzk+qglwafJEbANlCRHwmxUqnER4sowSmRlpu83AuFtpxBP6xfmfsR1Ac04ql5cOiRNQiONVvCByxTCI1ppM6CdLF750ySg7kIoCXzRFDnIUpCjKRv6AG1DhEPLBRn6YR1aGb8RpcdDFKKR6kgoaIysET+0AZQg/X3oLT3tqJBDHIctDgJfL+Ehwm2lKgSherbpsKJyz9zojJIfJnNPk+A74wL44MbZWnQYgERROnFi+2FT/eeBJ84wlWf7RAXWMt8mvJ4v+YZgqNXpuvlm99bOuR1neClnu4TTJef+mj8lj3mf0hF2PfPXj1nq6uE53ra0z56Kmpf1qkdunIjdkhfftwf7QVWWbp7od/VtTtjPKdhAwM7Sc1yXCQoBmElh+Q5LE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214de8e1-b7c8-4c5f-73ef-08de005dc3b1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 20:13:04.9468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 97l1EaL+qOse/53eO/PUpAgRMp6NR6OZjZbLMfm3jLrF6ZClVyquTpLKO9Ab5VCitWfjAxZKj8PcY7OfQXdxcNxQaev1XNTEfW/GgInGYWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5650
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=734 suspectscore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300184
X-Proofpoint-GUID: phvvIMSWivVkIL666WzhZdIkKhmsLfel
X-Authority-Analysis: v=2.4 cv=GsJPO01C c=1 sm=1 tr=0 ts=68dc39f0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=iOiOaIpq1Z_ZzEPSluUA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MiBTYWx0ZWRfX7gAqlb6CT0Vs
 a3F2xK6hSJLRBENeEc7cDFhZWGWH+X+m/EZifL1qoHFRbhg0UhFfZL6EzA5rHcN57ITVybwpa3M
 p5Gwt87U68ZoVDByqcbvPZWh3U7ZeujVzAbC5yR2wjHq39LHvTP3RTS6BBYItRV2gfhSUiWNRcv
 mR39qqfHy3hLjCYnuGViQeWlpdKmHXHZnjGdbbP3hLq1chACOqUOzrxPrJ4zSNrFs/54Xn37Of7
 M4I2PUA4cqO8QXJENkzQiBq8tqIOpiGFNuUMyqmxYrtXajHH+rD0DwHYTNLDP6zJSAq40yLLTdJ
 z65Wd6tRDSj8m6+oFJ3lPLvYEB78UE6A/m0nAoA7P5hcYlwFpwwXQ3MU/2BbbbUnucF5ZH2DBlt
 fflEzYB6E102RSDrPSSr50lyqpk9YA==
X-Proofpoint-ORIG-GUID: phvvIMSWivVkIL666WzhZdIkKhmsLfel


John,

> I don't see this patch in scsi/6.18/scsi-queue yet.
>
> Are we going to revert this ?

It's in 6.18/scsi-staging. Stuff usually sits in staging for a week or
so before getting shuffled over to queue. This lets the static checkers
do their thing...

-- 
Martin K. Petersen
