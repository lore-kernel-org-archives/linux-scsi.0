Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94C03FA5ED;
	Tue, 28 Apr 2026 11:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374725; cv=fail; b=dE5dpv2Z8OXRRo35aMbgXfsb61XVx8EDJ4B25s9JyZHQEaA9AZd7Owx98gqZbjid+ZWR8scdfPvClzwqiuGAeensDtNGzPb41IIgMGAAfl0cJo9NAHlPziskiXcQguXzWzGRVGMpRTI0tRdnTQ8Wy9X/txbWF3znk4UjrOUYc/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374725; c=relaxed/simple;
	bh=9qV9osS6jHuk+JzdpzNB6KvWJ9cum6vYNnGSaV5tU6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j3AfuA6436snfpRgW5ljsUJqYOVUDY0+O78OegmYA+qDDgvStMmACW3APCYlBGwAiXrQWf2Madgn4TGvQottKqI0aLtTNZx2ABqJg4jvQ0K49pgingSLD4gVnmSIJvD314h0McJpJ5x1n5RR3JzaPshws+CUX04UI/HXuPpVEqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QQQRy/CJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ghpPDMcS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QQQRy/CJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ghpPDMcS"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9luBb2721997;
	Tue, 28 Apr 2026 11:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uXFj4gmCvsSHWzsGEb/WEbCEbwURGCJu+WkMecZHPd8=; b=
	QQQRy/CJXDPZIZl9R2wFg3Vp1WL7DHHJltQHsPZZXBuxqSdrGtVoK9LzmAITIbTK
	HykRF80WFK/ZNNncp3wzRxLUdREgc9MuQvRoaBDeZTCQnkUQacpzUmSK01MFmYpc
	iTAbck6V0WR9XCwoHwSfFS21+C7+vkBmMP9igpkq6p9dSAQ7IkE++dilYdQnK2kl
	mZmHW1y0KoEDVdPKuZ4U5F4H52WRTsRp0osEMn/284F8OszUQIXiY1BjauH64ev6
	z2XJA1+FwBg0FV7DZX5BYFNtmvkEaHbJ7UJh2Hl0N6CWP09j3insesmXbcqIZF9V
	16SHDTaEej2qMpAlZgIFYQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drn7t78e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2te6033460;
	Tue, 28 Apr 2026 11:11:44 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cu2fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofiEhxk1kP8Op+ev6F1vV1gPgSlSmGuhl6Vxy0etXDSUF/L9VEYaWCk37T89CypyfQC5a2jRUd7/tvnlMK38E7jZZWhqyxqDuRlbDZj/66gRR8lqYc9rpJ7NxwmPtsBM3KbDi6SjxTLDRXVBgBuDdv1+qNcQ7MgULV0bt1FMhJNqA1Xw0rHptUrfJsgPuTtCbhsrNzh/bodDmusBMzsHhdKbo28V3k3gQWCwXG8+4c5CvCGjaMS7LfAggfn7REO1lfn8D6gHG0pT/aU4HOQYz2tkSp0CtvzfW+PvvxwhrCkSCRXfKscCA6iyZhD3kKPV+LUFPSLJ4tHSkOEy2T/vTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXFj4gmCvsSHWzsGEb/WEbCEbwURGCJu+WkMecZHPd8=;
 b=dJGQglA/4rgEeY7RbBQ61ViiT2JO0K0E2bLPRzZvnyic7FloECX4dSAChgbn62ywQFtInO/ANyNQHAcZROJKNR+wlFoRgLslVT2hClcoKR2a8iSOoS2Ir2hdGaIeF4R4/tJxvB7wiDz9a2BET4lm+MBt4EP0wO5k4sx+CV2UabTXsLCLk8ZWozdjKeqa++t2ZnqgPmrIcqNrI3iWbl03qCg+qq9PKqs+oUtyu3Kfxy919LlZrWcD4sO3ONo5uPp+Ij/F/wFddsfR6KApMfotnzyARCmEZi8bGpPt260zJLUazh+ZYsXitKHaAc/sMc3vE5R8QNINhFqoGz+xqlx04A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXFj4gmCvsSHWzsGEb/WEbCEbwURGCJu+WkMecZHPd8=;
 b=ghpPDMcSj8b39iLMN0QqJcVTXg1HEfbWfqSHuwlfZnWkSgvOOYfinttB3kU598B18sYFNUluR1P8F2cSXHIucEdzdeh93VgJ3vEGvoJ06EARYh19vIMaFsHiL6qsAVS/Gkf4+YzJ9Vld82wXon6wmpeyFt0q3vHf6xy/UXgntl0=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:39 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 13/13] libmultipath: Add mpath_bdev_get_unique_id()
Date: Tue, 28 Apr 2026 11:11:05 +0000
Message-ID: <20260428111105.1778008-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:34b::15) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 09d38051-68d4-4137-7551-08dea516eb8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	c0u/yRgg4ZjR0w3VZrLtSNDjLdERFBhwMsFRvl0H5eFm2DhrS+rGQg66TpCI/sDnUOnGdOePdDUxFxJOIGW9edouw037Z0sGcoziY9hx000gOEpudpgsLPmaTKjsmU7x+Ledg/xjs1LsA2YGZG1G/q9+NUDiSZ20tIMmR7JCF8HJ8Hj936RvhRo16bf6PVqGHsPTrESJaRtFUA1yhfTrFWMBAF1U1+lsImLaOFiuequIzRSC/QmRtYo+esYjXQOl11IUpepzVFhbnNH+NeZwRM5ZdGEDH+/iQIU5F9ln5uzVH+LkI1Y5LeUGYx72sDea2DqFSu180PAdEHK48XRdY4z8yb1BSg0NiVPPWWWI/IdARZc2uKD/sTcp1AALCRFxFprvsMWko7x50ZCWZk5I1j8D/RoJ0nVphIbk10YrFJ+Jt7lDMiQmClYUZ9nTnAZMl8XCw3YBQs0nhqafGZC4oDUXk3uBJqzITS6ohpzGUcucbEw6/zhQUYAmgQ9oVvQfIQ1pBHl0ti7YAcNj5qtyCHfm6VVbnKqLhDrnT0BY9IfZSx1bq0NJM6197eEn8Icklo7J+GaKzUWIh6+NqVMYXan0ZZL0mMIlHDnjCH3Yn5QWRcCfqG8juzkIaFlZQ3nnPvs7mGao1VP3b1pTXxIxNnhoOFTBPuA+J6hSLjNKN1cOd4Do3uEVVFF0qb4aRLo1PX9QEa+zuuPlvTR4G5GwkJCmAOPitKRGRmadRuPVhvE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lA2BP+sK2O4IdBmdJFt+6CKh+hUJqMvzRb9kLSD6Tq7K43LHwtEInuYfEERs?=
 =?us-ascii?Q?gbArgJNj8VEwr2rKA0gkSUseQgpovTbxfbodW1qUEwXRm/nlLySVjvk5Ycio?=
 =?us-ascii?Q?uOx1ZYvWjI2+6+lH3U1YSbzxUu1SW+gKjdsDZa6eZOutr5uoT9uy5wLOSBxz?=
 =?us-ascii?Q?N/fDd9tbzoVFbFum8ox5nbTgiAQHBcgsnfAQlJJ8iXCKFYWPXnfFzd5Lp5J/?=
 =?us-ascii?Q?8HWYdhGXa8uJgrJ4l8S4+oqM+MrYEja79gO26BZ5+OvjEa3b2LPNu/d69pkC?=
 =?us-ascii?Q?GJjZPzu9+zFKOwHthjprLOudgx0+hiW0P0118xgZD1T/wkNcwMQodBRwn0UU?=
 =?us-ascii?Q?XbSEKQL2RgMhO/FWQqipVvkp84wjP6Z5mPwKo3ogRTrATyXDk2dhaJlNS3hp?=
 =?us-ascii?Q?zH1V1aCuZOwHY1MtPHVFsOoTLwdgKWAYRgrVrdOlJE/CEsVhQNvDgdxa150P?=
 =?us-ascii?Q?pX0NYkpiNfiB9IYYK9mQyhFerQDKWaj2ingHbr6USxMx03JjhsvgRSYaDRPz?=
 =?us-ascii?Q?gj/Kwanv8JXAenP8AjjKbD+nM1mmZ2j1YyrBTFsqCRoU1y3x/vShm4svNI/w?=
 =?us-ascii?Q?6EjUTsJ7NDQXX4XIzKBOIUQivmLWTaONHdsUD2LPp9Bx3KQdgCznYipe/s8M?=
 =?us-ascii?Q?xrBoTFWznTQtZbvWziOdJObhrZBrU6UFL4NnvqldfVuzcbCBe5fFTlkklqmu?=
 =?us-ascii?Q?vCAVfAVpAI+/q4ZF03tvh3JMxIjzpE2RD9ofCNttFLmGKTDCK0yJnkA7XUW4?=
 =?us-ascii?Q?DR/rMRgWwOxLop3STVDn7EdtH6XYqJIw8PSaXhdlPobhZ4rbd6q/mdSONC9k?=
 =?us-ascii?Q?9IhFcLTOpiJfYzKrLvDS19KGKAz4td2JZtSaoi6ugbFh+aubzyWdFIbxqWnn?=
 =?us-ascii?Q?2yXhsJcMkuHc1P7nI9XS3/u4z9GL73CyLQgsdKChvzBq8jsi5/2A2c0g747+?=
 =?us-ascii?Q?dbGJ47Q+eAISyrVkQEAzcfHLwwecwLWS7wo1RadVx32ti9Y8ZkKzoAoqiGr6?=
 =?us-ascii?Q?FfMde0tATJ/IAkjczml2LoDPoaW80tj9Zm7vTb/M7aeLWZhB793xBMTUo3Uj?=
 =?us-ascii?Q?tyN+jx+UQj5ADY4ma8HZh4SmxMlTbkgdW6o9JycgkEIge47EIjKht7Kk7RpY?=
 =?us-ascii?Q?lGfJ40RJagLW/O3bxDlxCwl9xjLUiwKD2OUBWWwPcJPvYPTU+GxaACOY2yWt?=
 =?us-ascii?Q?pV03LLSr8iRV6+vjKtKPQdIayfQpxvVwRDeoP9Ksd0jA8x5rXMQYC6T3/39a?=
 =?us-ascii?Q?cfCMByOHXCu5tONfxrIlfa+H8kL63eC91e1gQNhMXbJ8L6LrPsFbzyqii3fD?=
 =?us-ascii?Q?q2R/rnPduf8EHLGqn3v9IU05Ps3p9xVnJCg/EVOAEigbQth6ub21zmiW9TJF?=
 =?us-ascii?Q?0XYGVjQhsOfRyUh1CwUaXGYjoJT8/91Nfg3DIIdm+XGLibPmUp15px8pkda1?=
 =?us-ascii?Q?cbd4wyHDouZyyTR/xwR2g/hwacPYezA+YWh4+muYdWP25pHtKuZsx447MIjh?=
 =?us-ascii?Q?0ANb2dj01md2iwRtnyddBaAinAooVg4DxBFOE2OOYjAALXUfVR86Qn+PvIfI?=
 =?us-ascii?Q?gm3DL7173MNnE+GhIbvlRqMRvxGaXVFnB8d0UZ1CfgXIZ0nAdv/PN2K5hhNi?=
 =?us-ascii?Q?2LjYH6QZiSCHjvxUdusLNOj/reVexWvQ3T8+umya/h6eCfIBZypdki8+US0E?=
 =?us-ascii?Q?IHkU9Vi8POetMF85Vzh3CoM/Vh4iBpK0LDiPGYQMBDI+KZFOgl+jYK0KUzYM?=
 =?us-ascii?Q?lK0AULfytauplEiRSFfsHOkUrqgvicE=3D?=
X-Exchange-RoutingPolicyChecked:
	VMogZj/36sWAXqqDYC/jYi+wG86e7nxwxLzfMMSiN8URadkXKroAjFudr2EWjOD9PvJMkirvMQqeK7IuGdbpuLpnKaBFS8WQhN2Pv67WlCJSg8RwJLV5xVeL2o0f4dAXQZ6mq7wdQtZbEQ5NBCi+F9Qbya3hIZmeqv6K3SGVLZuo4jjda8v0htISV4ykzHHmo41H2i/s8WajQwl8lRu/BmHWf/JFm6CBXeGey8EpuA8FFKP57LbbcJrsLqDcx5mhW6UIOz5jNJ/ub+G5aeSXkCf+WxLlfgF2yf8Vcpp6SiRpgkWovHPV123NYPMnd+rDa9/me9WWZKfNwOWyb/uXrA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FYzdSDXTW/RGACBSdeuQtPID7pN1upLwZ3pQGkqi5eWJkX5oZOtw0CILCYvTzG0V+rjANMo6N+9HiD+KYYg3KLrt4OfWHgBLW6c7PqruV3+Z16VBMcAUsjPZmhaErPROhhY1MNIwyAwsMO20VHUB1yl1C4KGi+vlka7oKU/wBs5iAV29k5Hs7JeBUg66fdpH8Be4DOT7SeX9+MBw/Wz2X/MS20fKBkqqToJTKbYKTLMkYZfEe1CAQyIawGu3b7yu/r3ZXvs8cTblDyrC94Cbmh5d+91xiUKDno+p5T2UoT0lnL87LZZ6vWSfef/n6CSn+r3DMaCA/ykx/mjEoaZDkFNYcl1QcNEjuoGLzDOIGAQHRmG/pXuU0NhVoiJbURwh3WxovfIosEEkqY+Irskaw1TtVeQIqT3dFHdYcmFCz7f2cWXVsefukHhy2Jwu5fGrhIzD3MI0khXuJD8EOhajQESbaiSVXwHIbeFLbsqNx+WAXtYwd07wYAwNN5ttl9kPAlleAAWiM4eDXl9HT8Y09VzlGoVtzamcWF0+MTLXatL4t2BbCJSP2RoP7XCkP0me28JySbIS9gvxLyoqU/h/zSjghHexiOVmsoZh6bwi5tI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d38051-68d4-4137-7551-08dea516eb8c
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:39.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xf3fWED0dZMdK1onYU9uF4M3+/fGw4FE4TdM+UvZMzKvAfi1weHiUdTMSwGpc73xFhcWkLANCjWQLge2uGAkrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX7xGhVQqSX7w5
 wDq9zS/6Iu5J/ujyrxgxRJFeHkSwaD+RhJqjf5+ExJ8/QRonQ3luEWzzHGjB+/EiIKyaOhwCefw
 L9Zo16i3zs92RTszAn/DPwcbfxlBmbi4kXqQbhflXbzFp/YoyqQH69Scm+hAsblTBuGr/v6Ods3
 uUimA2eBPQ105wCvewaBIDqSkj5T52F/2bilcbr6qI/na999YJPaBFu6borzP6qjq1CYdoCA5Pp
 mgFefPpYng3BssAohagt49Z31W0h2sl73Np0Am+cB39Dirgu9PBrx2iQkY7fvZYPoKsYjUO5PwM
 x1L6Tg5ahpISHmg/0uZ2AAoZS6MZoTumU0Ss4Ab2QOLBYDrQt1iNf3SW+QSF+TSA2KIhFpbh/7w
 E7961Ozi9xaz3d3b2sbtX0nxKirWi0ngHt77SGMaG5UgZFVqMAo5k4ei296AMC08+JZt99WpAS0
 KS0nsSb9A3USiKoleOQ==
X-Authority-Analysis: v=2.4 cv=QO5YgALL c=1 sm=1 tr=0 ts=69f095f1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=iZHHUXBEY3CVZWiF-fYA:9
X-Proofpoint-GUID: c6sP0qBRo_4llWqydpy5ISn7rKzvj7D-
X-Proofpoint-ORIG-GUID: c6sP0qBRo_4llWqydpy5ISn7rKzvj7D-

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 1228837e5eeac..001a02e6df274 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -490,6 +490,26 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->get_unique_id)
+			ret = mpath_device->disk->fops->get_unique_id(
+					mpath_device->disk, id, type);
+		else
+			ret = 0; /* referencing __dm_get_unique_id() */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -730,6 +750,7 @@ const struct block_device_operations mpath_ops = {
 	.submit_bio	= mpath_bdev_submit_bio,
 	.ioctl		= mpath_bdev_ioctl,
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.report_zones	= mpath_bdev_report_zones,
 	.getgeo		= mpath_bdev_getgeo,
 	.pr_ops		= &mpath_pr_ops,
-- 
2.43.5

