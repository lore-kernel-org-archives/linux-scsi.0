Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A792B4334AA;
	Thu, 23 Jul 2026 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799568; cv=fail; b=BlZXYsvfGQs34L5RtExRPFDewGC5xzmSn+ADffno8HO8SAY1uZDGZPop2Mazez4/SH8oNCLUOPmK6BuaAmPzTbllt+K+i/MG4yLw7SsBEkxYU4ucfcEqVzE6cSA7mp+HLMJr7oTf4siEzWXVEBT9ihbKWFWzgcsce5mtkN8dqbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799568; c=relaxed/simple;
	bh=3Yt7z7OVmZAl4vY3JxeH9qMcSiad6RIlXvD8ZcrXl0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q8t9AMDXx4jD3WfLFq1t14NGL5sAm95kTREXwT8jZtPzLiZ5KGUZNQGtzbS45uBJp9fEj0q5eAX/Rf3T8QxjKvuXtKztK6wfHIi7JUSX0Hffdtmun0jmuo/ZoMaxnXM388JRJkx3+NfYm+/Wc5zJmfRYCD8ErJSAn/P//3j6ZGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VNUySdsc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QRA0UCnr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VNUySdsc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QRA0UCnr"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtXA33495187;
	Thu, 23 Jul 2026 09:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=45rimpSBZVmZPGqS0vQ8dFmoB+VFoT4kTeF8ikXsH+c=; b=
	VNUySdscu+X3tQ1irAXvl8FFPPXhMseiv8nP+7eMktY43qWeb6wZRZluWAjH2gpt
	kGb+VgwR2exhzkS0jMlk1i8KVt6zBr0NsO0UPw1MbIi0EPFCnbkKJJEJnaGG85t4
	JlXoXgyQAeJk/F07NUJ5sZjN9XqAP8WPKa2pAWaCBHB54FQ2J7ZKN8NsUYSFTL7G
	GliBrvo9o2yLfCU6XZ4fwmhXpijonHNq/ahgStr2+jXZmTvw+36rLp94wDbhk70z
	C80RXrNAlqbcRESjMpmiSsZAGun6SmEmsxpnCplDHAdSVhfc+f1IQ5gsD27Jzt7X
	fGzQvWjfawPhYsgKjdxXSA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kpxn1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X9Jh021132;
	Thu, 23 Jul 2026 09:37:18 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y4af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JmNDd0z4Lwx3bdJuTywBxsJNOvvjP9mQDBmJUCN9S3GdyW7VbJwQVFkmFV1CRnCTG+lA4p3XmC5JiEquNTelea3TxGr3YvMhuOlD24wQrxShAhIk4o08p1MrELvcu8teLzSPeGfFBDbwm1AS4Mqjh+sfBdrUNdI0L54D2B6FDRyvakWF9rYQYqLmyOWj+sl9owlxmfkbmxJktJzAO/jjZe2hYi8/gCY3Myb3pRfeGZ9eaSr/HDD1MBHD1CjQPbYaOD+Qm8/pe4wM7+EJqF51rj87TCCPuxHvIiH8l7hEnG6eti58WDAgQJElmb+5d0rLV4VtD/tBIH9QcEq0GX1jPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45rimpSBZVmZPGqS0vQ8dFmoB+VFoT4kTeF8ikXsH+c=;
 b=lRFGlVswnwUZCfMR1guOAYwTcMBBu31rkrnXhjv6O6ise9ZWGpjULeyIqs5QInT/yAhhDofsMcUTw9UZCvZ1XZGtO8wIJq18M6H6odZBVGbJDCJmvVii/5ELypr7NKM5CtY006qBee48xn+6u3kW2vBsaDL6Ctcp4iaZsPkbJHfsXk+fxP0A1MtYrS1awCH0oOA5ebOqXMAnvpA0rn7+KjcLuLIl83mTveXpm+sx804ly/AM2tX0dkH5Z/mwBhln2O/4YxOhi7KjeBf2L+SoZ6JHl0N+UH/zsBpLzbDnTXUmK8PCZDFC4kWHBBRpgb7qWcaUzNkr74wXgFJ4aSiAaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45rimpSBZVmZPGqS0vQ8dFmoB+VFoT4kTeF8ikXsH+c=;
 b=QRA0UCnrMiOimDUULdXpBiOvcVSeUI33C69sWIWshpOa93FVBP14aoceoHC4jTnVR/fln9i4JsQTESMxcNQtOiG6pHfLQv+M7QjHEe+SMFwFdMshWsJjisbBaY2FUX5lRJDNfw9ItOzFOQQX80h35Dx+LQuhAzn1I/n0/j3vntI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:14 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 17/28] scsi-multipath: clear path when device is blocked
Date: Thu, 23 Jul 2026 09:36:15 +0000
Message-ID: <20260723093627.2327456-18-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0043.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b16792b-784f-4482-5d6b-08dee89dfa8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8fHk4EL7IBEW2OVxWh5W/BWUpoDDFUiNMsJkifJ/rO9LJKWZqoPPZrTvXwQV7RQDJhTMsLBwCL8lv+ZIQ9+GeE0HWtNl/44/h4owBqbAcOmVUtXrP9f7288uKsNif5YiSBf8c65haR5QTmTNHoGhx/6iZcA8PfSTYEhOaYYFkPEgj3+uRzdJPfiW7dn0dBJ/dZp5B0K2Of9C/k2sjrYZACiksh5z1Fsd1Hd7Fk2kYLaXPS+e5GgSZGbp5VaTLPN2TpDO/x06AojgjLE3wW4cwyA2bvjO4pGAIwhGQ/a9wsiKtTKViQIw8ZL7fHLj9UkM0r16uwiIOyWgLBZ6gQOuSfUWQVl4Yl6ZlTCPyOXJlCWECvyXD95HtGVm6eQjSGTe6H9X5zlFolQs+Vy+hjZ6kYkzJXOFXg3KT2G9NxqxxlGog6SslxAmKTwIS7YavOipWQVZW8oL0A+MrwBzxeX4mMj238ZgADph4058+OM59tO4CPC3pcPmyhtGqtaChM9+pppFDejFE/NFnHOmnijnKfMcI+WJg6+a93V1GfBbT/WYMRPhP1EZUEZz8y0V6/Wo98ztr+9QJv7YM/e5327JQ/EjA7ma0Iq3AnICUIcFXip8dpiNNUGd3feQJpIaYuZ+3bA1tE2h7LvheIKkJsdB/d/DhTaYy5E06K/riBtlhjA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TOp+d/DP16fFwNz2mEaEcCDxaNULKpdkAIggix2W0lLfXNYu5mfgRelFY6TS?=
 =?us-ascii?Q?aRhaNa9kTxdrE+Xn4NjVjU21QPW7R6ST8Grwrrs3m130fF+AZ8bcmmHHBcea?=
 =?us-ascii?Q?tQRmmSo94m83DWkdm5e/Lmknv25RfLfiWtmnabgR4PKPYdoQ6ZhBT2wP8S46?=
 =?us-ascii?Q?nhuaAMEBEFYII2kR++A1xhdc5Yhii7HmJm52Hcm8sq2E6YqTehfUUfk2+jwJ?=
 =?us-ascii?Q?mkPR7OcEMMmEMcyxq5VZHgA7YzK8MSl7HVTg88X5MHN01TZAs/SF2cdESBrq?=
 =?us-ascii?Q?D/RpAWecXEGx3n68ARgajE5WsnRlhff4PMsTA2QpMn1KNkiLfry8FqwHCwAt?=
 =?us-ascii?Q?F17s2GfeMoVZ2jxsr+J0QflcfS3MpeBPbqrDlbi7krp7gPzK1Qm4u2T2beww?=
 =?us-ascii?Q?gReDcjGDLbt94yvpDGutmmOtSFZ70pYN3n03jVFZRtUEeuwiO0PA09P3ybeK?=
 =?us-ascii?Q?T0Pp6iKPfRIZYpmMxteBoeHvrfmW5sqZw8343AzR2s82+PPsssGs85TNpdgW?=
 =?us-ascii?Q?MJS1lWLwHRM2UItUVP0eaIZKGGsbnASQpsUNLrhcC+SXPpBavIlLnLU3krZ/?=
 =?us-ascii?Q?lTL4lL7P3a00NyqKWpuxDFspEGlrEf3Tzeplbvie4tx4W/BU6Bw7p89maQcD?=
 =?us-ascii?Q?ZhN6zfkJ4wV8JIhpJoMfbndrUzNpBQ1fm55ugWDgJv0AolRccA8M60aWF9vs?=
 =?us-ascii?Q?FaBgGDlbKQEHsKOvdgDTxCSCxyn9ld8IyzxicTL5v99IX9V2bWVE32K0MaK0?=
 =?us-ascii?Q?+8SC+Wn4UnMQepGAKS099JddMNSfNO25N9LyiFmVqa4BiBJEyfeCfH9SXGlq?=
 =?us-ascii?Q?dlpdmvHvZ92cIIsYBct8Vq1ZQiuvb4RBrQ2yBgOsES9Krs0RWIXzSFlLa5GE?=
 =?us-ascii?Q?LoUofEtrUNjpdUulOUieWOAPSdX9QvuNIdmGPjaoGbtUJ+d0wY/DSI2dFjCD?=
 =?us-ascii?Q?bz/xXdhCFIWm/06bQdpCxt5VvVHzS94nRPYmcsgjFrBJR1BFhr5B2rE1oEs0?=
 =?us-ascii?Q?pDXeKF3tKJHsdj+6C3/wHMdgoWQSdVBCX+50l8GWyQ3jsSMhM6KEPwT8bmtb?=
 =?us-ascii?Q?5Z2VQHforg5mBpEe1LH1NvT2KbZ3/245B13patz5/NXJHyzJ5ej6uMOxoPqn?=
 =?us-ascii?Q?vcBswLqrUfOYs5kh7j2qg20Mr/D4B6jkFOsqBHwYCRsNjNy1KLYg3WBpmZV+?=
 =?us-ascii?Q?AdKUp+YxETiK2qNt4zowc1MxNWnrhjSukUFEXycyZ5X4vqK0SbItQJLyu84V?=
 =?us-ascii?Q?L1wQ6jGMuuYzCltO+eU+vaqTCNnkU+tJ2BW/ui84K4itK+r51NF23aHQvyjf?=
 =?us-ascii?Q?6SDEvkU/Ibe5W8f1Y9kM4CXX3symMzWGF6FRqLqlD/mrRKr+G47ge6K/LSlR?=
 =?us-ascii?Q?EeOBwxx3EF1Z52f5+hd617fquWV0/ui8HiESNE7tCny5dCOcAHz+VFFxV35R?=
 =?us-ascii?Q?vwaA5TdJfVzGyz3BYTkt9WRiZrml71s3dFuHbxobKmqBIs0j6AMiRLk8iLkJ?=
 =?us-ascii?Q?48aQUkwzj7CP7V/hXKY/tcnWifHMDKrtDxjNpyyBfxxnvTTNPvniwNQ7fKml?=
 =?us-ascii?Q?KiDwePlVB70m5xmQ6r3ydcvasVctXHM/JOTnT+UDv09MmqMCAx1P0fX4qLHl?=
 =?us-ascii?Q?KP3ZQpHVhG0qtJ9tbpYyFZXuggEx57zucTxtVwf5QSABdYau0vWksU8VVRZ0?=
 =?us-ascii?Q?Tk5tAW85Eor0LWcx+epRmJaFmGaSJVa6V3hmOz1P16ebO11SnsKuipwlmTjt?=
 =?us-ascii?Q?B+kNZDFKM3QpTrngu5Eh/qNNw0l7AiQ=3D?=
X-Exchange-RoutingPolicyChecked:
	G+JHAc3jABlS+z8dB/bLy0C0SAKcI3CeWhaE1gVhq77xkFvmFaIog6pQQyr0syBtHHmCiL8zBVXk2US8RbwHajJbfxo1MFl1mw6cPb6XWDfFbUXrrxsqbok3tuD3dWk7dBIDzw5P53iIfaa8rvQgjKkV4HQsREuMQpRYc9yUQ44wNjSVqlGHqJZlXvilL+GxjwVvRL3yZuj+/qpjawgmjzHhWdOTiLLkI0x13V0FjhJbMYKjLPsKvdFo8do7UPHQHRe5/5aFrIuc9JVw1VnGmXSkhW/ougA0E0Tq86cOGGo3MlSd8DiEJiOm1eubNFHPXH7hgh+DBDqhxum+5h2vXw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LE21CU/djGt4P26qqw2wzDfErFTV0F/XJrAofdIYx0G6th7TCgOQNK5iSkyn/kxgshxwdKSH6BGEjx9PCGylQqhvnzRnMFJvAEBJgexyTAoXEeheAv/MI2QFJTb5/ia1kxA4YUy1CBUxCDci3nQsfTA0eF+RRovb6cE1Q5Ab+phLTH5/4Gc7pjnjLWEmLxSC8+Owsz7Ctpn+EUmzzOlrMyrDyzkUuR8j/GThp6PC/XT446eS5blq1G4hqAsGvm4iWiMdtzMvQdBctQSJd/avse9o/CjQsizUFrpP9Yptme2G65tSBYYOcNlCV4QyacxJn7T+OQKpwOnqEFPt/XtZQpIy6KK+1hXw3ElMyg8ow2sLiSVKiRxRMjyqRMalvcbQSInKNWPZ+j7re/PLEEcTcrpIOUS7yMtvdd5/vhWbLsTYZ0WBN+qKOPumEqiTkDKcyAz6A83aR3BFsiPxixlpbLOyQBqvFtivatz6Pt0/A7K7jHd5Wn8y+pf+goN56rEFBkTJRDCP65wIITi5WbKwOjpKhAtr4HigapEjb7uscLq02N3iYMPSy6KQUXMaEbUYOi8e+mMZ+8nehOcKkxNmV6HlurVB/aPfwT0ndCfkYE4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b16792b-784f-4482-5d6b-08dee89dfa8f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:14.7342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kn1pnmq2/le+S3dGqhYexreQ/Ojm4Y3Abd86cPk+uyFWDiLAUtYE0xv17QObMnmrYL6dgW83EXn+KHe4QS+0gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX/t9NFDec/PVv
 hThkJzN8kKRMOOKDvv4fWxVPjx3g+r6AuxTteg3tQKVNB5BSF6HMchjF0zsZ5bBDVBo/mmf/uIe
 qyIRP63NA9Kb36JE5ykNVItk1i07A3TR9H6WoKx5kh0XNeQE5mRp
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a61e0cf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=9iB6f5t5XeFLL-rLAp4A:9
X-Proofpoint-ORIG-GUID: Lx5n9SD0tIKfDsAytLdBdFaOlqsCRUJG
X-Proofpoint-GUID: Lx5n9SD0tIKfDsAytLdBdFaOlqsCRUJG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXw+K5CPhz/+ea
 hAjjWmmtjkRDDTwzVX/y3aOWYQecOB8faOC+f205a+pZjgQSCP0H1kZH8/qcnxH9nXr3a1UrkVS
 rgRE0dXAVguHknwHCxY47SmnmXZTgx5PJVJ6memqZVIMjG6tSJdSuLNscP1sEM04cSEGSZ0cQTX
 jyLLhf6hl5lyDDUFSJTGXGcbMpqojUltndRh9NwpXBBYPKdM77HiIB4Of9vz0Mjtz+du7QLhkbY
 oXjay3RjGxertLI0QsOumNS6kXmfopiDc7ZvplM7UNxMySikXB7Hy6uzO3SUB/HI4XYeUNRESvH
 Xs4Yx4s1VPpJi9R+6n1AfFIsotwwmSIC58mbu8qw+SP3nH03sphc9FwvKND1vXs0qRwVV7+r8l1
 E3+bLE0la/AafFoMDu2vCRU0VDTRAqQU3ZgX/yqv4uDDtYKBo7wJki4QbrZ35VsyRujsmNcCGdT
 aZOYw8SCKVFI2T9lcZQ==

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  6 +++++-
 drivers/scsi/scsi_multipath.c | 10 ++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223440d..dafa781288046 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_multipath.h>
 
 #include <trace/events/scsi.h>
 
@@ -3007,13 +3008,16 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
 	state = sdev->sdev_state;
-	if (err == 0)
+	if (err == 0) {
 		/*
 		 * scsi_stop_queue() must be called with the state_mutex
 		 * held. Otherwise a simultaneous scsi_start_queue() call
 		 * might unquiesce the queue before we quiesce it.
 		 */
 		scsi_stop_queue(sdev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
+	}
 
 	mutex_unlock(&sdev->state_mutex);
 
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 9a4b35c597778..6a2b06c148c1a 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -230,6 +230,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       if (mpath_clear_current_path(mpath_device))
+               mpath_synchronize(mpath_head);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 5cc37acaa664f..8f58c44d96a77 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -54,6 +54,7 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -88,6 +89,10 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

