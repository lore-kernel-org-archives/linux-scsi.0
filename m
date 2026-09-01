Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A3547D446;
	Tue,  1 Sep 2026 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259628; cv=fail; b=Ufp9l85p21Qk5BLCf97o9KiWWhzWhPC+JjUYBOwyja4l0rIsc6//wslYJIDl8Q4Pb0H2yEsFsnSWCGodWpACm6pfTkouohcYGHlFDWvBYE1DInbJ166lJnrYIbfwMBAJYsFkPUR6/w5zHpw189xMQTgoBxbJjXtU0fCP8lmsYQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259628; c=relaxed/simple;
	bh=0tHfHRxVgUg0g/f/dBdQLGON/+3npr1P/655VNCOZG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JTqQmIXW+qh2vMbYNTUKZekJy+IZOIhUNVhoFGoj9L46epbqLHaSDcptuIvD71t24Zqe7XPAWOdCqXADLZcpTl9+wn0zF+NwhcvpqmHPFbgL/EI1cNp0VHjxCM+chFB6+xE2mm6FP88E/CblIfmAPChn9NlgUCHuTB5slixf3tk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Om7lkbBn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yk87TI6D; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Om7lkbBn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yk87TI6D"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLCkAL2297378;
	Tue, 1 Sep 2026 10:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JGlwJRpmTmzi3d0wpKC+/WgXEINhpER7dUJPEEUIXeU=; b=
	Om7lkbBnOQMTaoLrpY2A7QHRIbNr4NMvFyMcPVeI30cpV9/sNUW0/6mOD9sVlei0
	E1t67A2dobZGLcGK0Pzi+84XVMpZFzJES+nJw7Uu+xjBfoyqmmMrApanFoRkkd+Z
	+0Hk8EvdUka5r/2vkw2zCfTVLiFKZTxTyWi5HFLbaFNHrzdH9hiCFkzdlIgvPUyK
	r9qz9m4J/qfpMRg5+Yo8iE60q/xQh9G40pKhcHL75stPuZMzZ0bDjpkEoBcLxKDW
	eUDNlH0CQyQbXuXthtC1q7vvd8h3cxAVXwtBEkiTKBluFvwv6J4WzLSeh4altEtd
	jTsxUqSBEhLzpkBv851oQg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xvdbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AYuBN040245;
	Tue, 1 Sep 2026 10:46:28 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve8n9d-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EMBYZ8hlvYTPv7kmO/Am312+ILOFzOCaAWAAcu77b+yJeIlW/ctTAgrYlBeLlmmdeIArCtOMbdfm/KyeRx3MRpOqf9L8QyhmI8iVSV1GmzvqX/1x+ER0wz8SFydgsnoWP3oYa8W5d9GlwTzVO9c++BdmRF6hKtDJsAVNgBO2NMDC+FiRYowse4WTyn2S8bXLWaqGvZFXYnjXqdstIJyT+dH76vfXl/BWuzRLvJCaxC3+CZ6GoHakvTF0yZNBIJ0ZH0ah427rjvZ/vzvTeGh8G75Agn1liswmV9nIPE79qRl5fsvKb7cJsmuYuqhBGeuXnxqkazyMKKL5OhAst3amuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGlwJRpmTmzi3d0wpKC+/WgXEINhpER7dUJPEEUIXeU=;
 b=Vb2DQkonHTRaYHOjxHYOKoUImRx62f2deH9oRpJGClIw2oK8WtWCgtwgHWBi2k22Cv6sq+cBfOF7674bQn7smZPafBN0h6wQUsCYfp6wzWXYrjsYItpfNGTfjIXP0uMwx8ZRxMzCTWKurOHHbcYT/7OQPk6K+yT2RlADwFNa7cjK3xuh9nNrngxfoMNhEl6BfRo2Q3rHC6LfY94ZYo2fbnzqkKW5RubBplh2MGa+Uh178iKWqooYAfGVfS98nFzW1zplq9kgZwejco6Np5f/MuucBoDyuaN6Tr/Z8CgpKSb/kFRVl5wZySLUU2kYzKyUAKgbd6kba54r5aY06NS8qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGlwJRpmTmzi3d0wpKC+/WgXEINhpER7dUJPEEUIXeU=;
 b=yk87TI6DW8OVmQMq9EQPTpVvl86MvZedLaqOroNSveBQEewztpSCz8O5tmMvlJ77tTHEPTtty3lJ0Or0PdSDtGEtixKkAQYib14mDbIBY6wtm0fChE3BX88pPL+DXIJqPA0zNICHLz5V1aAVOcbkOZontHWGsJsMahf2ZdpAAqE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:24 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 23/27] scsi: sd: add multipath disk attr groups
Date: Tue,  1 Sep 2026 10:45:22 +0000
Message-ID: <20260901104526.3850621-24-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d57d05b-a87d-4b2c-e924-08df081644b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|6133799003|20046099003|18002099003|22082099003|56012099006|18096099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	DVsaHtslsya2pVdnIMX0R2yc/RZK/+UmnrjuvrbK5P45r9aC+MQ0/GCnT6RAg4BqcDkQQ0cNh7iktq1msVK+2jDitfC/VCClebN7HL+laUyW0p8meU5lABaEBj2psi2W+L0ZbfaQ0K+Ky/N8Ieaafa6cjSZd463WKIqdFVjEQgS4p5NcnRl1QfG75UqftCGneHhZi/Sbs5oJiWuH3XPqp/MNn5yVotfK/WgolOPHE51ODDEabyhEpbcplqOpYUWXIbyJ7Oy+S/DBPevNxQuMEL+XIE10RGliNopLmUKes/r9LgmkWjK6Rkac/3TPLv2iDDoh05cmODpztjSHa1BWXB0zc3F/qtOqzZdyRhbpUILQXx0KB0V0jnfyfVev4akMmruq6ucl4xVJlbgPKW4sCVMpSQbXIQcqs6FlZA8fuIDIkCZbWylBLi+NoBEmCz/hAz9yvnRuZ1pDcUCSLXJZkDzafeM1kG1/NMjBOIpfv8slHRmn7n70EtTh3t1Zsp/ifRkMaWRpf3a6JoIPKa+rYtXDKgwEYXLk8B5OQqAtsEvRe7jrBGBd2MhhkyKRPMlvdVXPaPTLZyK0WFv3gfFCRp1BNRn0JBDOMbiib+umJtWDwarrrgsAdR0N+kDRtm0uURqoDWoGI6oG7rWqP6QM/BeJxJn7p4F1zaLPrUnLOZg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(6133799003)(20046099003)(18002099003)(22082099003)(56012099006)(18096099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5nSPSQn1Ug7+BiKXbsoHpEfbtM5pIAGnP/HVG3sMYGPystKK9c6j/SJ9gjA6?=
 =?us-ascii?Q?kmoyntWjR4jMReiFtzmwyMil6lDEpXaZvSBJT/eFo7H5VAZm7trGapE05zqs?=
 =?us-ascii?Q?UN8Da/t5LYvCBVOQyRAGZDijc+RozceYB2cGwf+GepUDgaKC5xvWzMVFfc9l?=
 =?us-ascii?Q?IQx87JkycVBT6BOf7+khDgEGd6RXykojTPrVZxBn6rO5LpueGQYdGZ9UrGIZ?=
 =?us-ascii?Q?gHCoIN6HIwE33mbe2791l4XqNsc/4n85GZX2ebtdLI3AEScV3Cy7sGLGG0Co?=
 =?us-ascii?Q?a6Ugop2fF9ryjbVMrwyuXrdWBE5ZcSENhhvImNlBwpBIqHcmCodfjpnJhY5Y?=
 =?us-ascii?Q?wa22RZoBUv1ajqJFHdkHsTPpHKNqcgreXTv2RwYysnjVlmVT/5ITmwbBSBZc?=
 =?us-ascii?Q?S+r2otRDjIVQpC8ajWKnhCjeqXhQ3M1ybauUMgFzG9YWE6s4q4A8/H68D5f5?=
 =?us-ascii?Q?V8q5zdGsItGX71e1ozpK/Puz58FZbla0mQTNjC+jj+jx4JNX82YRLOwyYUQu?=
 =?us-ascii?Q?LupmC11TBjN8kVnb1riODeDF8Kq6lRPgSM7Sqm8q1irzHBclrsizhhQQurEj?=
 =?us-ascii?Q?0xy2aHij2RqG1G2kbtzOGmsqYMQEpnuEMQinoIALiUNzb+30vvEyGiR0gRT5?=
 =?us-ascii?Q?HSyuuHHhBIhdjAX8lCdSMBtiRYpXW4JzbzDZZp3076wE5DCqj28eHgM0Fn8w?=
 =?us-ascii?Q?FkCnGUeiGIyJpePzsih5y2k8FZKQHxZTEHj6h+S1sT4I1tv/6AekodfgayGN?=
 =?us-ascii?Q?D9m2Krroza9F3Errp1q6DC8yulm5q57uflOgj+wt1FglDHrlxI/rI2XSf4mI?=
 =?us-ascii?Q?a7NBv4xBQWmMIq6Guwf7N4aCR7EGi3FqbnaoH7lDlLuz9JhSjmJP3KsmCPqL?=
 =?us-ascii?Q?Cj4KbYXF+s5/Sw/Sk55K1mB6AHvOEN+2V5FhVNgSeHtvLj/xH9+gidYUJDoA?=
 =?us-ascii?Q?a1F4ebyw1reJmA61KQNmvsrcKOEjoo9TLIMb7AX5iPljZ1QFmEaXAdJXw19s?=
 =?us-ascii?Q?szNBIiCCMMrazH2q0/Iqgs8WVLfG0b2xBRUrSeLhF8DjxAI1/YN72Kqzl+ZR?=
 =?us-ascii?Q?xUvnqC5m+gYWHlMLnCXLNXwsktrv0PCzSkvPi5sAy31fdAjT2BXXWskXRiN4?=
 =?us-ascii?Q?O+5G0MBArtsm3taW088T//elFMB77HycPyrELE6NeF9EqQC6CxwlekenJsrc?=
 =?us-ascii?Q?ubkWg+CpuLo7lZrs+JD4UlIW3jfP2MxfH/TTNSqdy6XY8aqarkonRZFPA0A/?=
 =?us-ascii?Q?LFiCouqma2Wj4pnNCMjMaZlRAOFkvj66j2vXkBDqKPqjdXpHe3Ivfgf+88mD?=
 =?us-ascii?Q?3NTEy5VuegcQa5xH8c2Y1cDB5+9n7N7mj3UU2BZwf0lyhXLRNH5VJxjlYr9m?=
 =?us-ascii?Q?pa13uVanxVmNcYhYP/0NZtn8lTWBXQVD6/6KSqhVZtb+UV1Mx0QYSYaAkztg?=
 =?us-ascii?Q?aJAoBSZr3T7CWzwL53QQWrSqKmbr6vu0PbYwJuKRKktp5pUEgspifhuez3Oj?=
 =?us-ascii?Q?hb385F4yazFH/dZECCqtN0nLtnyjo54BIpY+IBrdxgr0kNzUTWZ6DCNiByZo?=
 =?us-ascii?Q?222vseVXjQsUJyhkJbVMzR4oHzgwXFk9oipiFRo+PxJPcRULrmbcIv8fvZfO?=
 =?us-ascii?Q?VbfZQr7vpJl6WLMPLGvt/euzqgglNaJf8WZKU1vv/0rX+1ZJE+b6mm9ZzrJj?=
 =?us-ascii?Q?WRhASN6NW7CzLX21cnRcF1gq9iNcfV/YRXwNvMcYLiQCHX+b9oD8RHGkRlPl?=
 =?us-ascii?Q?ig/Xi5sgu1zRCFdhuZ+i2Og+D+acTII=3D?=
X-Exchange-RoutingPolicyChecked:
	251d7oRqxZFP/Rwh2T2qUtb6xfGMBpTiDXyRpx6eRLInDMy4VMzJLgwCN3UaNzfysRqJRjPdaQkIr7o7ArLX86g4bm56EF/H0zwisUxZugZ2Kk8mm8mWeP1sB9LMUGatiTWLZs95vKXHzvl0+I3Yr+7KoZCh6qBLWlYkkWPKHA6LbEB9MWGTuR9SN+x3JXQUu/vQODpdA/JbrUaIiOZGdUToouu9Cw570Dj7ofEOBV4vntfT6Hxn2r7DS/hEmUo9sZWqih4jYHOqlwy9/v+1HroT/SQnP5UDkNH5e3Te9yxLrRLl0/gJTiDr4lsghZ3nG+OKdBzXPz3M86pex9a9yg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/oy4htZUCY4zPeWORkwJ1uEJcmNAZm8tfw20lzTYs/ks8RG+Ywo4sjKXU3/Txeov5LWkMtwwDcC0+9wLlnV2UEGe4oSyE303N3eoVvVVS8c6QcykO6hzDacIS0Q2iGzbs5yND1gGVKaKgVeAywReurSo7t8p6WIgxo+dCFPpXxREiTm0Bewc025VVWvO89slqQm45XUnEpjJIyJnUn8DVmfX7g7xB286IEGQcTSNzFiYfcbgN6Xtoo1GFnHSMybAOknr6Ysukv3Xik70jJN/ndVua3e4KonLOmVDxAZCKHhTms6PQO07x5M54TgQSIdWGo+EGH9FMPufX/WJaSukyAn7/Rt0eixA+jHkgzQ7EhBC3e6IWV073PBI8EOgByWh8WQeDs1gRAd9D9aix4kBWaVWmqTMbMiXaNMSShNomDRBL3xFlb8bFv7mV3iDaK3nMmBeecZRuVvnU5P5ejrGaJvJLKWDzJfJLJqy0cNNhEdDzlSw1HveuJ4Wi95mCI6MwxfET5qJtrz1BXA1vO9NhfY88E1T0wtQhhoD2Bv+CbBtNa1ZIi6qAo+H0WaYMsyJBpUKSVoaAc263cZukNWOB1yhPlfZuw2WsIrOLMCLzAw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d57d05b-a87d-4b2c-e924-08df081644b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:24.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IuWWAYXBywpojtVFcrUlGLXuUlgeToFEqfFsimgzJf2DTJy+S5Po/WZ4+2oIeFHDY0M5h+PVFiC2fPIke9pr5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010094
X-Proofpoint-ORIG-GUID: UBgLmuPOQtNzs8qFEc2nQ-U7bSmNqpDN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX5L3FdxJz5IP6
 reGPTZ06RaJgT3r7CNRUkO77U5XJEIkoQiNmBI5yCUbatZXBjlzyVomoHuh6+ftXsX/I/+/eVuh
 IMVBlZCFVKjm1FlaKHsRxk7TeXXWq2E+TygfpFJ2zhr4jLCyAHBpJya6sg1ERNluIY7R6JeI354
 giTHs7KgZ8JOPGTu1XLZCfYzt5Ak0S//MM2Q+zufOAcyO67UdJ8MVsLYxNaXYXlZ7Kg33qMPSDd
 ghmj+Mr9pCUwVvhUJIIO2DffdVsGFdufRzdpFaDxxEYafuWRG7fnxExe1GT7XoF/kWEQwkh0aDS
 e97fyoTgJrBTwOP9QmR5wBeiOSci6dBvrvcnYVCM0SKXApU7ZYEu6qH/CLhRdbqnVrwdnpO1z6/
 lMYF5Cwp5uWDZqk3B0Oj7TgJKGnC5pGhMRhsqJLbSEDMDQLED6IyDPvYIUSzjtogJhmF7GP3WzB
 02gK0rVdSavQTwe9+Ag==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a96ad05 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=4WwWyauO2_0H2zdGQVkA:9
X-Proofpoint-GUID: UBgLmuPOQtNzs8qFEc2nQ-U7bSmNqpDN
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX+KQ0AukSE/w5
 +hBjrP3hy2TdHFNhantzw4wQbuq0x0bXPhrbjCuuJzhrFz8IyOrNLrfeY9NgZmIJ3OSCXTOoZTm
 iJogqPudnRF32QhM79Sc4Yg7paM1NaG8qlUMtnlbWr9Ij8Shq3+J

From: John Garry <john.garry@linux.dev>

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6847805215bd7..60e071d23ddd0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4019,6 +4019,42 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
+}
+
+static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_show(mpath_head, buf);
+}
+
+static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
+		sd_mpath_device_delayed_removal_show,
+		sd_mpath_device_delayed_removal_store);
+
+static struct attribute *sd_mpath_disk_attrs[] = {
+	&dev_attr_delayed_removal_secs.attr,
+	NULL
+};
+
+static const struct attribute_group sd_mpath_disk_attr_group = {
+	.attrs		= sd_mpath_disk_attrs,
+};
+
+__maybe_unused
+static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
+	&sd_mpath_disk_attr_group,
+	&mpath_attr_group,
+	NULL
+};
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
-- 
2.43.7

