Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4A741C0D6;
	Tue, 10 Mar 2026 11:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143410; cv=fail; b=VmpKG0lfSIMEzcMMSMn9WWKsC62KzTre8IN8h6pkggfy32/PADDg68EBcP6RPW7RPQ9xtCTTl/K39cuDKNbKue7XTZEzVapqxMfkQKBiNb1Gcsm3eZ5J2xC6OQR31lyJ5JfgQq5h5wiHKv4Phg67Fs9Le2YDUAMn/BSjk6hnoFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143410; c=relaxed/simple;
	bh=sxrkg68uyZuyFkrlyZrkvqbfuc/NKv/tpQKFbvPYCZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OWbhDUy8qZPJ92WOxqxZgAKHCvk8B79CPDSvWSKQ/meQZDcT4qOTV/FPN/zMnibwoquzp6yVRi/HRZg/pYuSoOqU9V7YkEfgcdatKq8AaeFfh681Ls0O1JafPHtR6P2AsAEUWMbu8kP3AWZSptaplb7ePPHKRBlPwqXtuGe3Mso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p7hSHRmL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b8yITzpg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p7hSHRmL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b8yITzpg"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9eCLa1628413;
	Tue, 10 Mar 2026 11:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LBW/fXKYlZYe+UNtZ/28LjXAZIB1syxEV+MY9wK9Y1Q=; b=
	p7hSHRmL1xxjy+jF/CEIsr5FzqDvPY/E+cA1aeDX8yloGc/UVOOBqSanHEdTnF48
	2zfFvODhG6aYwa1d0x5naNwKd+uLZ3E5BP4esZT2a+A/l0fK2T8bmbzzH8/fw5mI
	/r6h2UTOtEP/saqoWj9PEUQ/BuOMHnvAgF5xm5lPDzgof3xDAv8oSHm57CSdibls
	Lt0gSNoLD3BMKzHCo8H+Wfr61fFQE8fKx2kxiGfJ+/TDc5WQZn8VlyNxlY/txkki
	vB8ZKxG+pbcDzJZsRRR6StdU6/oTJJv8Vtcpzp3F2bSIMyXDE/6ohwwAozV9BeUT
	/ooPdxfaqb0GPfa1K7xoRg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmps2nt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62A9o4vM007796;
	Tue, 10 Mar 2026 11:49:50 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012067.outbound.protection.outlook.com [40.93.195.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf9yfuw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rROLEOifuFUz3yYY9pBv2Cige2Ll0DXPRGT0SEr9oLYYwtLlZsm4VMkxQMoIJUXhpAPXKsPvgKr+zZfEypQFrpazyqlmdhl49gCBGlUc0epyw7+Tll97iLrG400pC9g1sTcEfSjG0EPMBngSYXIA6yoI0e/Yg4XDNrP4/d8ztoxtcCijAFB3KmtZDznFzmm/0BG04/s40cePqlaf6nW+JjVmaP+Hk4MmmB0YSIaQt+KKLIaa6RjF35ntumSiGJOjMBlPA0092RiZGZmLrPBxO241ZcnbnV78ZBeKOZoFMUhnjTXZTLxsh5zuwEcR8OuwIoLSTUD5u7MMb+wBFKHrsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBW/fXKYlZYe+UNtZ/28LjXAZIB1syxEV+MY9wK9Y1Q=;
 b=VLi5bHElyQGsIqKCnI3PRvaGFC/chdl+0bw+gZHtxm2eWG5qH47IDvVqaBjz5uHStEclbTSKms7OJzUtS0/vEhzbx1b/V6G2dtAvm/HqAQOgvwbMbt/hz6VMLe7UXXbsXxh1kxlGIHWfPiG+Lg53vrNFk1GL9+iPGq5ed5IDWyTfWEURBWNAeO72Eoyz0MEHs2w73toSpHIZTS8Hw2Gh4E0ZjKyFLOebl5myXrV07WIkkaPsTYsXoIhP4jTXYdke0XegZk7o1Av7JZJc5/b4O/3N5zQxEw9F+XM1za8TRsj5L4Yu6qiA4B+6k8FTfU6MLH+jYh3v2Q6xm3yHvKw2wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBW/fXKYlZYe+UNtZ/28LjXAZIB1syxEV+MY9wK9Y1Q=;
 b=b8yITzpgN95f6Rm3yi9KGB6oz3YIM1ry36+QM9eldma2Twarg+Ya09TwOFcQn+gFCPRqUb7w5mRh4Gv96iYV7EahiSL1UbeGiPkhgDiDZxP9Oy+21H0GGaU26jEboyi+avWXxjdFHDgi1KOLNNX2nlBbcGID15yenyMKZz/33uU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4519.namprd10.prod.outlook.com
 (2603:10b6:510:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 11:49:48 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 6/8] scsi: scsi-multipath: Maintain sdev->access_state
Date: Tue, 10 Mar 2026 11:49:23 +0000
Message-ID: <20260310114925.1222263-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260310114925.1222263-1-john.g.garry@oracle.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: fda0c891-7844-4848-3cd1-08de7e9b2179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	bfAjEYGTX4/CLgmocXUXg26vyn53ZrsuM2CdZOhVgxW0+LpsCNqCPSlIIlhrOC2kO9ThmebmZya8i28QR03K9eZRyiFrHCtJTWgaMnVPaYb4YO0fATqYLWSv4TlEfoJt5Gof/UabC6YL19wUdvhNDxEs+PbcjPIQpWD2M02xYxmoJ9E0ZUXcb1RznUQvAPm2KUVvhk4mmJcbEyuXKZ7JzNZMIfMJRcrp7+yUvZTeUCsz2B/ehWX+Zk8zX02vIAURr8K5imCYYrGC8L8ZVHNHy1rrrH4FWjMun6/u9Ecbag6Lk5GGzfqHsur+vjE7mXza/yU/qVs5o6VMLqA1MGiWdlq9FV902jGxxRH86IHUf7KVDJ4ElOh06N3MSSsdoEyFZSB+qmDHQ7XQBSw6r6Wji86usLScxQBEm7HMLS31xQgd8TBfvXQ3wriuwwYaMkoa02IxaMRc5gPvfttq4U4W2Obj5XyWBzxdA3xjeMgp19iJ9Y59FOU1xi1Ub0bUfvg7/o23ZFcc+s9ULaJ6j2BrGha/QoZ3R+FMQQgORlwZVB8M+69LxnPyOdcanzPsXe4wdn+zhw9HSajZkvqFjyA2HTKu/uPWikFUK3fjG1dXpmiouHXzIKmuBif+kl3R8Jieg+diCaEtIZOPlLouBFc6I3o7vDJE02EcdU0mLrzdJGiCNVU0iKOOEev9GVCUp9p+/GyjGh0wZ4owS7EsihGDMsrdNqvqymu0zaXInazKoBc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2A+1zZLZipd4xoGf+XKW7NOUmaJL9gdALF4j8BBJEBHHs0ijpnKTn2eejPiv?=
 =?us-ascii?Q?POz3D7PqFCoNwxln2Ke+1rFgR/JVNulZNhe8gOOHx4YRMHibKc2RAZlN13TP?=
 =?us-ascii?Q?I4JTECfgPZtpDzigY8hSv4OIb9obn3rducl5R2Z/PbVkTTU8qZBoLPRrIyZy?=
 =?us-ascii?Q?epGszN+iZv7pqezdEOtLaGKtaIkRV37IR95LM7VnWr6PP/zQf5dWOrj2KYjF?=
 =?us-ascii?Q?4wkkFa7JO+rWGFKbNurquW7iuyl5usb9Q195yOWn1oPqblbHDcokhCdEF+ip?=
 =?us-ascii?Q?84imcxg02cjFB/rj1SAC2pUL1VCt520C9hMSobr7pJkHTatyIsy71epx255p?=
 =?us-ascii?Q?62o/zuK8rOTF4S4Vd135pT50jUBWMHxh4KIcRaFcpMAscQJnUCHA2vgFw5Pa?=
 =?us-ascii?Q?UO7DLhJ9V5uiOO39Gou2QETAbJYsbhvx32uvAvP9b7NLUh25bSwPKPLX0ULS?=
 =?us-ascii?Q?3Zm4OkEyRWS2faENelrNYN370izRE7Fuy7Tn8Ba+P9v/02NzLDtVhzai+pmY?=
 =?us-ascii?Q?d68AqKPo38gcsspzFwVLivm5By87u6hVUlseAqFQWi2oKjA9V4E9jM2D+WRH?=
 =?us-ascii?Q?51JoA7GMKM3oJyeARrV3iKLUOWwFWgH39bNxxID1mqaQNx1kirAr20aVE5hG?=
 =?us-ascii?Q?WojyjfLab3a1AxMqzFLLM8EQXvWhaPGROxcSxUiTXBI4fLanzNZ+hNc7IQcD?=
 =?us-ascii?Q?FZfLBDhL/Vyv4EaS9OSss+CfmltzfQwLqgrU0GIbAq8RzQvrYW3tS+ylV+AF?=
 =?us-ascii?Q?fEORQKALjsNeol6M47VIim+4vy8Am3rT7fikKg1a4l0j+AlD0Wv/UiIcbTTB?=
 =?us-ascii?Q?GZNSLKQsTUAumwWs/zjSzAQMauleJXW6EV1GEqll12zI8Fgc/YHiBCwZ3XGW?=
 =?us-ascii?Q?4Ub1q9gS5X5rs9OwOsPmLnDilSK77fGp3M8/J19TG5Qn+jhHp2cl6/+T4r43?=
 =?us-ascii?Q?qm8Os4sAdjXop1wSljE38VuntXeJUju1jqyVQLNMGIHACkLxTYpw9WLHMGtu?=
 =?us-ascii?Q?ItyYHl95mAFU6VXm6aJDdAbpbsB8L51utSPQecMSJzNdNn/g5lpvZFryLOck?=
 =?us-ascii?Q?OemN9AAnnuZrjM3KzYmboXCFSJw47smdT28kYhnV4WOcfeLgBsvqx3dxDWZ8?=
 =?us-ascii?Q?x43mz6MgS9Gp/uhvqoAFx4y+dFVh9D1bQqXfNiUln9/cUQ5hw0FAeMd5K6S7?=
 =?us-ascii?Q?uLI5rr5C972iTyFaU99DBpKau4nh0IA7DuUMsdfxVEHaOhZg0N1jkdIJxCUi?=
 =?us-ascii?Q?++xXwx3H0v4Vr0TIu5+e8FHT/7WBUGTqnGSKoWoMqpA6lF6/O0POUytBCpRA?=
 =?us-ascii?Q?jrBwPYfdCPO7V3DksqW8TmabK10De7g37L7WmfByZW7kEddtpXvrzO+aee6U?=
 =?us-ascii?Q?uKtYTN8BfKK74vhl41Pw1hbmbPCmL6u7xltJ0dVSo4U8IDWNcHTtSNl4MOI8?=
 =?us-ascii?Q?Z8Dczn/zm6U3OOmfGI/MPG9fYTbCtVCOlLXirjUWiZEj77x9plTOIKWSECMW?=
 =?us-ascii?Q?mBkB+A4HFM010Kuxb27cR/B1DQx2Ubx9yFoxADC/m0BwOrTIVQgQ8mQN5Jml?=
 =?us-ascii?Q?eC3PmGuKSWg5fUOoMWpfKXeDZovIJ+qN15gC7A/jxdSggKPZCA47gxdUDtko?=
 =?us-ascii?Q?slYzS9umrXESmFtWI2wQ47sIR6wv+CwBQtB1+Yh09tqvBvI8wnRfiRHcKgVX?=
 =?us-ascii?Q?hMZd8YDMggadzxJx1ikHidlbriDRvukogwPVkoKnLpgkN2hwuZK/5JuYY2oo?=
 =?us-ascii?Q?kzJ1H9Krfw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	kxGwrpb+Dv3kFt0gqPgAHGdL5kFSMB8FfN5wwcH36fePTMyz5ejlE3EdVH6T3jUEEdgloNhEEhCFAjRrouJ+Vt/PgCYNWSQJjQyvB0yjxwB/IJJ/s/OxKdJWolIsZJ/IHgQ5syN49fk6XQ7ooxfjPFSmYIv3LGhyGaImvnHdrp2TtbvQkpFUdjatxOwkvDDoeB4ENP0w7pcx94LeCOq3n2e6p+BKk2L2bKHGTEDsX854BlPZ0yIekCzas9saIEtASZW/+MmpNdL+Mq9AJt/adTrGhMqNKY65j2NPM2bPHXmlM3WEZGv3ZmTzgn4Hxvkn+UmdYZgZ5RAedXOXUU5qZg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QqO+7qFbNzUcUSvnNe3plwB3jLDwWPxEZsAVx43XCNiwdflKIZ+0dULJMpwkpmx8RrPxx+1oEb3MN2pEntkIG6t4UVlJAZ+M6xiWKRET1TagRESAjJHd8i6jjR0YkvyhbqoXJjHjpJb6sMR1NBSAgtYIrrsd6IOyDaw/ln6lTChZbsLpvyC3WgvS3w9zHpDeWRJUGtWKfqXFSuSfTJgUTSjyfmuYWwpolrfwzLyZtuHU05ao1ceya7MG3rl/KOZzzCeMrlkE6dtJXdF0RfRBv1fIJwjX9AyU+3c+d42yJnlOwGLgKWnuVe7kXjBJB9ljZc0xPBxT9zR+g5XmHm554Y18cL8ffdhhdnTyGo4VtG/olm6mgExqwQToS1LD9sp2q6CcKaEPZDVTmSerBTJWzchKSv+uFDayp1EdKZIdwew7JUPIgRbT/pTXbMcUvEt8b8rFxgEOi8yyKc1/h7t7mt8KVbwjX3yb9jr4wFus76H4zQ9J1R8PApbY6V2DI0D8oyVA9ZYY1b1jyVhpAwpU4l28ru7JYf7eADrCp4+0fZ+vc65Laz/JG6zUY+P0m1TyNA16F6nRkb7twiEFCuh3ZgxDoMLW0zVlH/zSy4zr9mw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda0c891-7844-4848-3cd1-08de7e9b2179
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:48.1428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHCFfjJMs4hvZZqtJD+mJr4pzOi2ft/TsjVtmcHIEaeh8YIaAj7MAmq0Z0L/z67k9VSJCH0lZAAEI2kGk+J40g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Authority-Analysis: v=2.4 cv=IJQPywvG c=1 sm=1 tr=0 ts=69b0055f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=Z-QkV3UySbKu4i3C0aMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfXz9NXT1uxe1OX
 fhP4rUF0ODSGYzcgD0GKqeulS1Ss2HtbyfkzeVdmZ64I4DNn6GpTfuwEyuGOSMIVHj/TvjYOXmp
 q4bG4lzv1J0NOZ4uNV2ydNyDWpRPvsRemhe6pixJhpve95XdX+IFAjdLeH6swGqOm2T5jJG6inF
 EbzlX/jTQDyZoWVcbQbK9EJIrBSj4c7bsBDIA5BhqxCmCRnsf3b0kF6aAicNFzbZSxnK5x6uE7m
 3v3C1XcEs8conBnqOYI91lMzQshd5J27/Vrogjng5iWMF+WMl6p9nN/Xb5GBY9UxvZuYrJ9zn+f
 sGbFqUChJeMeYb17qL+eSTCHP0cvnxT5Ca+cdQJCXu6EYJ6fKUNwdhMs6NGf7oJD5FVoWzICwq/
 9FS/jRZF39Z4pLhaMv68Oq21jqjeMVR8mY7+OK7dBmwT2UoqXVgPB+N7/1aRHcsVzF6KiO3mlXR
 3UQWMdylnqDGNkfvAIg==
X-Proofpoint-GUID: ARNglL8J09SBm3iyilPp47IyU547NqZl
X-Proofpoint-ORIG-GUID: ARNglL8J09SBm3iyilPp47IyU547NqZl

Now that ALUA is supported, we can maintain sdev->access_state.

However, preferred_path is still not maintained as that that is related
to transitioning  state and we do not yet support that (for SCSI
multipath).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 1 +
 drivers/scsi/scsi_sysfs.c     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 0a314080bf0a5..0c34b1151f5bf 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -772,6 +772,7 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 	} else {
 		sdev->scsi_mpath_dev->alua_state = SCSI_ACCESS_STATE_OPTIMAL;
 	}
+	sdev->access_state = sdev->scsi_mpath_dev->alua_state;
 
 	sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
 	if (sdev->scsi_mpath_dev->index < 0) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 3b03ee00c8df3..e4fbf08e05f4f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1113,7 +1113,7 @@ sdev_show_access_state(struct device *dev,
 	unsigned char access_state;
 	const char *access_state_name;
 
-	if (!sdev->handler)
+	if (!sdev->handler && !sdev->scsi_mpath_dev)
 		return -EINVAL;
 
 	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
-- 
2.43.5

