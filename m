Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9F246C854;
	Mon,  7 Sep 2026 10:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778341; cv=fail; b=WAqMOqYwhL+kYDEIbE8wPLw/EQ/YKO4c8+FVGSmo9QgZ1xnKp5YZY3WE7wkdktszfC3KqnU84qGkU8W7hUsznptEP9k6uZ6QNPRtnplo4TkSofyw0O+/UMRIFbMqQo2Rv07V3Uqds27ShfUlxHg+FxL6JseX/XUJTZ0+5nuXod8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778341; c=relaxed/simple;
	bh=xnJzHKGg1a3/UPptc7giCrc3td51YdUZ/awXPrfcyxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gdskyh6/ZZ70JRyWuWUFm1mSQa2OLEAgexc1S4qo0wNAkI8xhMWJqr/tQOAChK90gwvYZ+NjxN4+4xmmg/3stKuOuy1Vm5Sl6adqOG78N5zlFvtiYa7Z4Zu3PFNE/vZC5qVvtp00by0wTuE9VEhl5tg8zz9G6wwySH0+quWOd8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HsRmPaDP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qNcN3bC9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HsRmPaDP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qNcN3bC9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686N2xZr058527;
	Mon, 7 Sep 2026 10:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hrLhLip921MlwAwYuG8xs1XDMN6IDNDhXfmFkF9+3FI=; b=
	HsRmPaDPcz2gtEYmwTO6jYbCZuyE/xtNAeKwJoxXiArKcTyLmvihvXvlj015ANam
	IfECUcgyWpsUa69K9olZjvir60e4p54eoArmoskDAT5W11tJazZa/RZZf7yv9eV4
	Odfn4GFE72hA9w+b0SkqBAumztDdjwxUBwxQdjbwchE6sxZcAiCaphrqXohICwGq
	Hj0G+3lx4RmmhQcs7acIXCGBWY2Q8D7iPKF+K/wScvrMA5JnPCI59ArFAmBklCZ8
	Py3CB1S/ZvPeFHxpfjIiJHnLL75c/OWM1fCv7gbw3+Io+Yl8Gjcgpwfy14AAwUbl
	uivoYaV+HeoI1yERwIdbuQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbdessgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfN019106;
	Mon, 7 Sep 2026 10:51:22 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-16
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/lM7QgcSE07cnURJZXWiK/yJkV04cM5oCWJthyrrLDwvZ+NJKC6MsLPJBG3RO1ibglFtIf4uzxlvKDl7oFTLN7AJEru7OiJw3LHYZ0OYhQEJVUZqObuhWAZXsCJuM6xk9zsz4LyDV6OFiKIud2KTgwr8KDssEwnK2b9kLCWcJJX/wY4OXQ5iTQmBlXIe2T7KBBTykJY/JJpn9k1AogvrRKznkTO7S4ulNjTT7tNTEOF6UQCy0ahU00LDMmPYlImvQvRkRIBqw3S+xjlo/c/c/WGgqOL/xHw25vAeGqKanq5Cnq0O/73PiSGpBbgzlCwKLotr/lj9GqNEzpaZH8/rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrLhLip921MlwAwYuG8xs1XDMN6IDNDhXfmFkF9+3FI=;
 b=QjmeiaQ1dFQwQZTSR4xYDjZcOmQXMoDJjeEvLjalBMMxgnw1wejDEBmpglkXqsSO/a8g18oGeDJ9QwH+AdiMxmlppGFoKqYkYheuiSbP3iP7M9XpcCdz6vBUM8sLx/Xud0wEC7OkgwlPEja/B1Hr8Pwt6ILfwzNTF1tgy4bhnrE6Urpfy7z4fDalBwRZX8wc0jaFuvlCoVaS6ctButUDYwDQ+LZxRpe2d3wcKHYJUo+D0IOqp5lDFt4tuCMyCowDw9PZtvVCVmItycKo+Y9qidvLaZ/5aq3D9CzsHcKXwJ8aTuCkCdJjrdcqtVuPdzvQR4H9NSnUM6U851l55QvTug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrLhLip921MlwAwYuG8xs1XDMN6IDNDhXfmFkF9+3FI=;
 b=qNcN3bC9Hx6l0MFBSDlEQBMEUZCO3dqINHsZjX3RZQLJYeuNfByBvXisdi2wmu5W66mbVOOreaWj1f7W0rm0V5ysldw3Wj9/teJwfYGgVfZKPHCHTBPwYclwCoY39IPk1g5LFK1mlmH7/2NlV7EB19LwZDkx2sImb3xO3bPM3SQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:15 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 20/27] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Mon,  7 Sep 2026 10:50:14 +0000
Message-ID: <20260907105021.1763236-21-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0015.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 436410d1-2998-4b2c-058e-08df0ccdf078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003|10063799003;
X-Microsoft-Antispam-Message-Info:
	ZuYuHuW3tG6lNPVGPO45dz5ZDH5kenPTGCmqXgCskbuLOUC/VFN8ePBfHg/1mt6k4OnyGkMczGWvrpA0ZQsT1BDP8PcfiXlwcL6pfseKhIlIjGLKpsB5o/C2sn6qTa3btkHvE+VSRu5Updc9olz+drX4QumvTxmONHoKQd5VDnThIy5is4x+CqlcM+kP2c5lEmFbKRhxBz0MLnHmytHBpcKulp/2aTPJswNQq+a/eEqC4s74tv9V+3qE8wPczPlMKMdlwKqfz/oj/5piZZKCTCE4Aeu4A6mul63yWP3D7yLt0+67gs/QyQBCBlf79VdIYIVtLmhU6qQKZQtXUSkTx+rNXaRf/DsUrkQAYXS26WHWeyp3kwoFvewk3tGUxUkKIzWUPy8ZiYNAEIm4P/rLbuN5J+Gums+KMG1IcDK637bgIxUk07kyTIaeG2D1xYGzS7Ruv/8mnvfNJA9GPgbseD0zR9jXqALgJApL65jEMg4NsrRpu4zvUFe9mRQmxTKcxT1pI/V45aGr0HKidYF4Pt1MrD5/c6xKptVIleM35+WVvNnLblRlZOieMJ8dspjk5QT47pbTUuYLfzQFBrXhd4o5MF/dOvqqaYNOA+2ZZCMMoVgNEEROsH+Ipo+aEygxDbgD5sEBx4l5Vaz7TWrCbpUv1Vn+YsKbm5JjteqDpVc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003)(10063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aib9DDRU46ioKuxL01y7fNVVFmd2WyrRBnn5StlPYmstDFPyibqilcve8GR/?=
 =?us-ascii?Q?fjYBNhaCnu1zIFhpsjZ/eS5Hf8nLUBNDLvpVv4BMPzVUvVFM0pcBfOXTAZ+Y?=
 =?us-ascii?Q?sbMVyb9ID5N9iY3E7k6ydQbcj7jWdXv1vRBNFSI+1jYhWnQTit16pnwhr2a/?=
 =?us-ascii?Q?ouiXJ9rEJ1veh1SutRIePfskabeNduomGAx3nrXQNxUcgo/P14A+ZT/EVJff?=
 =?us-ascii?Q?M7Z6ciUieXMl/r9bgtak47wtfhqPitKXSjXM5EIX37LUHkWCEJ7IYTzXmh2n?=
 =?us-ascii?Q?be0NfFWpsH6V/gMH0ZMD7vOOu/j09bgsgxZDFZ+NtrrcLwnwIZCFBajrZ/5S?=
 =?us-ascii?Q?WIhAaRjjoo9zMn7qwjL4RpWl4SF/T2OLlaaRXQwulu0FsdHrpOj5iv0cqbzS?=
 =?us-ascii?Q?Ed70w5qwJPt4L0mGHRxh6fC+kMsENalq7srw4Gx49+sgXT2c70I4OKbzjvsI?=
 =?us-ascii?Q?ez8HiYpWhSpFsvHbRFpXFpbTr0zSIT0xsXuiZKaCb6a+5EWkQZpbRixMnJ6V?=
 =?us-ascii?Q?nJgEBmjiaO0w/YZ1z+JzW+GGaeVF099JPgETi0p/CRyE1PjR2CvDOThs44bj?=
 =?us-ascii?Q?x4PPTWCQesvJgvaIHJgtmtjbVEG+rVOALV3bF2plAezkvvrbrTGNIWjcUGnk?=
 =?us-ascii?Q?YSaGzKoFMoNBUkvPi2d4S6H1iZhNPchLaEpVpQuq/o5WGlzp4htQyTCgRsMI?=
 =?us-ascii?Q?CCaapwf4F0Jdb4TfJ80Hgf9Eqnc6ZDjV5PHav2efIkor/Qr6r4Wf4a5cBQKT?=
 =?us-ascii?Q?T6VaKxx76TBr0zUC262Ny0tzFGJh07Wq9x+cj/gk8kpA/4CgzvXo+SMMlFNh?=
 =?us-ascii?Q?BvqDhOse24e4FpzLj2lcYSke53y9/16ckzDbj1HOrLqormlUwGt56jUMf2V7?=
 =?us-ascii?Q?2dN4ewTsn5qxJNyvFVw5iCJjoBMMIMEwfyTkuGnsiTQuLhq8veBIilI5ZI1y?=
 =?us-ascii?Q?wGxASx94KplQWsijPMtMT1kuuoLyo+Zm5LmPqm0DoY2xP/ZbGTHh923Z8MmV?=
 =?us-ascii?Q?T60yR9LKO7Q+IKdlDVv23jEvyyut4aQA2AFMN0SrA7/DdlzmSjutpHfbkBu6?=
 =?us-ascii?Q?ZjyTDVjH0YXH3yJd4I00XbV5PPSoQX4fn8FoM0vu5vzrKGAHka1MjY2AsoK9?=
 =?us-ascii?Q?uOXIvNHbPe/fULAFEZgJWw/J4pC/nM8Mj87rou8+1vOcPm0Vzz8vnewvXUtm?=
 =?us-ascii?Q?VwvE4a+AZfYl3gnLVeZFcNFpjbWx8CLDM+KEgRFFd4p+CBhHE1hGW6Vwcdw7?=
 =?us-ascii?Q?2SN1Al17NfUKcLTICDZdOpYgLPfYAfabVc8xkHbjP93PUQUXOkFRJ7/3XC5A?=
 =?us-ascii?Q?CNQGCtzVCJixMdgGT+NzQVG1bfQBTDRSre5I1u6pvbDmA2+Ycs5Y8bxoMGrD?=
 =?us-ascii?Q?wP0R4rDi5A/od0cUZBywtaQgTdssBbI+pOhIVI2tCccEQxG6hzhQq7tQJJ2K?=
 =?us-ascii?Q?CaO+dEaifBMgW36vF9LH16to9BHkoJ7L5cYQk1g0F/fNofAD8E/FlKtFmuWx?=
 =?us-ascii?Q?euoLTKCugbC4F8RwCFj/clatZbiQmydpiqliawO+KT8hnnJl5oOYG9arLqGC?=
 =?us-ascii?Q?wPZkR9wZPE9+TWOi8kuDrQN8GeFtZRAQ838nYRMPIkVwXmUijflHwAhD19Gd?=
 =?us-ascii?Q?scQBfeLL3lF9t0wX5bScfXrtRgrkR8+v2LBMD0C9tB1Uusw04ztR2TL8yCk4?=
 =?us-ascii?Q?Gu7dJQvYOqugedTFCWmJLkEsAUwuGgHQt4NUVF35Qk37GP4gpZM97fgaZbAR?=
 =?us-ascii?Q?zimvVAexNA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	pSgagBQjupUgZ61ED3CfcsDebbI4/CUByeRkZ7nFTWSNO0ASIzBQDpsuAijTxLBVpC2WcR6UhQXVNEm8NjQFiYGRpcMLMWjCCKM7iFxlrRKmgdpZa1TAOEKABnnL2ZgveuLlJRbLg4Ws9cH+Cjf94mHuvImeJLeGIOPM2uBQA6Nbp7nckOXZJ/NVo2eBiwRMa5ThpGr4O4x4VasQVe1OFlIvkkNuFEd1fdVvVq1qIIEwXEDVKkRydbfRiu2cm7uxR+gccZS80oXPvEa9gmwXp1MmCSvdqc48mkksJjuy+W3p/dbd15xNZYfg0jhlZNNyza/id4PKzrqz/dIR1gAj3g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bnv28VloBNbDfi99gsny2W9zrQbWJbccZr0Ang3Jrat1Ur3hjLchoR6G2k+k6mQoXWk4vi3IDo8LXlpQGxIHA1wp97lhwYtD93cjQK0MSMBW5PO2C5MUgIAENDZMKknVmTjXQvjqzc15SpYNi9qYW20IB13WgI6oxDvJp5qKqWd/a92FCYQuqgtcrf1N20S+C9PIp3THGfWRuyiTIGfUFzbUPFzPVpkCps4xCFEJrLwq9ckyf3sbSxrsyW7prPkrn0E+oruwyB7QGQQZu8se913Vk0ou56/w6A9KMzBdk74MhbQnR1ZwCaRU7jc+yl+Iit0MZmrW8Ppdot5inPom9Z+anFj1IW3UN8gElSQakpABngP9l3bKYOH+SpfPdtQGTOtN7o0bYa9d9Px8NqsGY6qcixp0fOn772k0oOu73BHCYzTtC4Iild3N32+y7bqPf5XhLtU6HwYRySpJvPy21HOqtFuWofmh3tv13OyE3UdEy2k+kxJLux2hjrN+GMUUhkljT73ywcbZnLjgt7+fdaXGM1wSjZLpwZ8uN8EzkQXHTiJr/VxEyyChj1qRNX7rlQ7MX0nxg5v0NCqjkNdAOYWupW7W/qdAzqwhxN0YVc4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436410d1-2998-4b2c-058e-08df0ccdf078
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:15.4318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CeG78rdJOge5SHBUDnUKkHswdCRz79+/Nfh2z9x+2aPY0GeeuGGsAGpMQVi/RwfXKS9JFgCSrjERX6BiT5GXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: xwloqidu9DsEI1qgAvP9aO-daqSCUTLO
X-Proofpoint-ORIG-GUID: xwloqidu9DsEI1qgAvP9aO-daqSCUTLO
X-Authority-Analysis: v=2.4 cv=R94z39RX c=1 sm=1 tr=0 ts=6a9e972b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=e6BYPIScm8OiYhIHgSgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX37DhvojA+ERv
 zynoa154SVF1Av6dpBL8OvFcbXJwGorlh99lrVbdgGWF1ALVIcCMGuRHB4plc98+VUrIeMfqxyc
 k+AT+5K0232MzeODpCy64PEPOrXV7bdmEiFWRJ2yIhzDnFEuzg5aD/H6rglXeSmdFiX7vDbb9NF
 6tkbjq1aUFaxssyKp1gaDMGG5RID6HQcTilwX0XP1OHb1dQ8597i4SqOA4uZI9tUs5tjPueiFvU
 e4e9K5coieK46vmuZcu9TvkioB+6TjfrorJywwqKIchoeKqlzfZVWptz0OwG7la7I8FTzGofYws
 oOW/WcK9VhxYBXipqXaqy4Ph4Fb9d07tQ3JXkTxznuyM4i2WgEUVN8eLYj7Aqg9LRVyAdFo8636
 rklkFX+oq4WUW4DDcdFNulSvNptviHB6qOUVSP8QF7XBXoSbI0ipzm2K07XEr9buU7ls+UicrBu
 RoX/PFhEoXdmwTfT3/A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX4LbQwmt4YdJe
 wZlD0vuSdGoJI/mGmzEt1SrkmWMNn7SjRFS+FUtUiue9ije+VPrtiyC+k2qceN2DPbQTYotw+Oc
 HQdXkN0/TB5xrZrnGHAZwd5VmagJsD543HE7bkXtZfEtgvYymCvg

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

New member Scsi_Host.mpath_nr_active is added. This is required for queue
depth multipath iopolicy.

For NVMe, this count is per controller. The reason is that many NSes may
be connected to a controller, so congestion should be judged at
controller level.

SCSI has no definition of a controller, but SCSI host is a comparable
concept.

Indeed, many SCSI disks may be connected to the same SCSI host, so it
makes sense to count number of active requests at this point. However,
for a transport like iSCSI Initiator over TCP/IP, we have a separate SCSI
host per SCSI device (so there the count would be same at SCSI device
level).

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       |  8 +++-
 drivers/scsi/scsi_multipath.c | 69 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  9 ++++-
 include/scsi/scsi_host.h      |  4 ++
 include/scsi/scsi_multipath.h | 11 ++++++
 5 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1a6f5e1fd80cb..193e7e9a2d30b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -669,7 +669,10 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	if (blk_update_request(req, error, bytes))
+	if (sdev->scsi_mpath_dev && is_mpath_request(req)) {
+		if (scsi_mpath_end_request(req, error, bytes))
+			return true;
+	} else if (blk_update_request(req, error, bytes))
 		return true;
 
 	if (q->limits.features & BLK_FEAT_ADD_RANDOM)
@@ -1918,6 +1921,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (sdev->scsi_mpath_dev && is_mpath_request(req))
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 4055b86c83a03..5faa06b5e8770 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -553,6 +553,75 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct bio *clone = req->bio, *master;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_inc(&shost->mpath_nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (blk_rq_is_passthrough(req) || !blk_queue_io_stat(disk->queue))
+		return;
+
+	if (!clone) {
+		scmd->flags &= ~SCMD_MPATH_IO_STATS;
+		return;
+	}
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS)
+		return;
+
+	master = clone->bi_private;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(master->bi_bdev, req_op(req),
+				jiffies);
+	scmd->start_bytes = blk_rq_bytes(req);
+}
+
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+				unsigned int nr_bytes)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct block_device *bi_bdev = NULL;
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS) {
+		struct bio *clone = req->bio, *master = clone->bi_private;
+
+		bi_bdev = master->bi_bdev;
+	}
+
+	if (blk_update_request(req, error, nr_bytes))
+		return true;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return false;
+	bdev_end_io_acct(bi_bdev, req_op(req),
+			 scmd->start_bytes >> SECTOR_SHIFT,
+			 scmd->start_time);
+
+	return false;
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..52227e2cd9749 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -58,8 +58,11 @@ struct scsi_pointer {
  */
 #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | \
+				SCMD_MPATH_IO_STATS | SCMD_MPATH_CNT_ACTIVE)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -139,6 +142,10 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	unsigned int		start_bytes;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index daaf1247673ff..8cbca6b75732f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -756,6 +756,10 @@ struct Scsi_Host {
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
+	#ifdef CONFIG_SCSI_MULTIPATH
+	atomic_t mpath_nr_active;
+	#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 6e50da94fc5dd..dca1307c9fa46 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -57,6 +57,9 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_start_request(struct request *req);
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -109,5 +112,13 @@ static inline
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline void scsi_mpath_start_request(struct request *req)
+{
+}
+static inline bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes)
+{
+	return false;
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

