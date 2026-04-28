Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019DA423165;
	Tue, 28 Apr 2026 11:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374970; cv=fail; b=fzqRu/58o89P+dgbxWN0QLVXFPV1ZSrU7NYmGrBwVAwxCEh7M/LD8jRgBJD1OeJ0A6SrfDfLCyo+zjDE2z2TosvjdOgDi/DSvYy4+CMmnrwbMIfjZL8ycZVJYi80m4TXgmhY+CyOefgG/WfCdFct4CYPklaWbf+s4q6fc3SyNAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374970; c=relaxed/simple;
	bh=wDo+odMeOrmtg5PijdZkKT4n73ft8SxQ2rByxzxqJJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GrnuJwtJ/TCUir9ZpwWbHQtGpvTqbVUvD2qi55TYQXfptDXhN/6LFqKtIQdxIcOmSQp9NXunA6BxB62Cy1IRglRqWDrTYfkhY0KFTVdjjoKoNeh9+r3NmTVE59Xlr+VgMRdfAD/q6Iw3qenlfTAh3/QL67jcdHt5twqkEVdT68g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cLH5LGcd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dL2PhSRK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cLH5LGcd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dL2PhSRK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAYxUo1015449;
	Tue, 28 Apr 2026 11:15:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PRaonAqOSk2AI2qRAZFAXBctVKv95nr7rlRQ4wTIoj4=; b=
	cLH5LGcdM8j5Oxo+hjy4IZspxd1DS/146rpd50kZ/KGXwPXKxbIZirNjJnjXC5BL
	Zf70GQvTfgsCy+ADFClXQGCvhCTwL2QcRiL7+82rPL6+AwxUrp6foapahcVvzkly
	HIqOOR5Vyh7XkGeO/0PjH1hZvZsMDhxp5hnFT/lQUuefY7wSelXfRacuYgU0Efq4
	KvfBMUQcNUG8QaesI8+g9Tm9Q2HHXBE1iB9te7unVdkpe7IERq4W+yQP9hvXGi2b
	Pl4tn+gsIzVHEuXCqZpdiN/sNzKc7GgQC0M/ZvdRcsTOhdWmZhgbGr4cgoZR5R8Q
	6GL718JEsYR+UERsuAtlLA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yykc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCmVe038802;
	Tue, 28 Apr 2026 11:15:42 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccner-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPHfewxekUKxy3ojGAdA4h3q+u9PIoL5snPApx7CvMzHKjMgiZ8hUSy9BM16MkFs6M9fZ7YLcKt+FbL+J5DGxlJZhhCNdo0pjNXQy7XqE9X5S2YJziUqh9N/SCUdLn8vvs+CsJmnEFaGP56lPFv4gnBxgsruvbPidopiOa2GxbMJxw2i79Jt6BqHIW76237tKjpir7YmGQ/BkLigfJlmIUqZRGNMukytqCtow0qTxwL2jxrzc1meV3kjAcUS0u84xlMXuGmCpYiF2oBBo/03De+ur9fTcsImpOMXmO+/PVAp3L1b9oucxyGgx6zD0Wr3PuPpJc5xD0PxraTzIZLD4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRaonAqOSk2AI2qRAZFAXBctVKv95nr7rlRQ4wTIoj4=;
 b=JNhcYKJ2IeSODBz8XhBFGlsDNDRigJfYfnEDn4alamzTKv0wNMsvYa1++kwgTGSOX85rLNWUJYG48Ws50EodFeKSTcSh0PBkO0yhoVajLW51V0wZlxDW1gPNXGXdZZcTBtef/eTBG/T1NcTjZ1C8EIlNjiS2pxsllsPumiUaNrWssdOdl2kcLzZpdIDLsE5vjIF39+6wcH1a27kqE+eA7msgQjXNFXCHO4ZRqXZPZnJYtGq5eQcZgiKcBe1ocBLHgrWMGTGF/7aIcb9MOS5qIEsF/f/AdUIlGdX+6cmJ5xhqpXCBLA+E5u1kPthr+i4Wg7xUn//v/8QH08ZmihwdLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRaonAqOSk2AI2qRAZFAXBctVKv95nr7rlRQ4wTIoj4=;
 b=dL2PhSRKzTC4wKR+IqaMdy1d/rdEp4vLMhHzOJz8g++ML/grhA4pWfoq4ZGucO7wOv8x4/8viHLyef9lXlEceJ2SGthrYO8/K8WcoCo9Sz2KsCWayKXEzLPETwx7ugYejdK/kBM3lecapn/qJ4GGTGhcC4hgd/8W/wcWPgqhXjg=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:32 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 15/18] scsi: sd: add multipath disk attr groups
Date: Tue, 28 Apr 2026 11:14:44 +0000
Message-ID: <20260428111447.1779062-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0068.namprd05.prod.outlook.com
 (2603:10b6:610:38::45) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 2869a189-d117-4d0b-2a6b-08dea5177606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18096099003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xyoNN9SwngIXmpKL3SDMSFo8LGg6U2aCCAmNmMERQ5hFmUPP4XmSdh4jvOykutntOqyQlPlvIZLkY2imnmzj+uJm1e2JqzDW2QL2nblB3DxBD88XO3GNIb7mUMhI9NVtXl6cg0sUk2lqgzUTBPY+1AJAfNZPgOoINTJ6m2vQjIaM7faYRQKybMkQMlB9XfsWqzLW9Njwk1SyJhOtMBgObZ/A/ZYEMkMbm3ii5ecFMXw7uHVHAzrRAZuWA2PeVRh24BCOoxs7XDUaJuJuH7gxRByYqsrl7Z74V4zBhSsT2vypfYeWMiKk9Pmom7mOMi9klWx53PlYoigaPiwc4mc5bRf9sAfLPDdqLQnT3rj6ofTDZPC9/49jnIgo7DDzcI4jq6/8ZtwqTgJE5Wo7C9H6wioDny25lKJ7gtA3DaDytDDjTc3AKZYIA4jvGSrdC++MtzZtr7ncBbHmeVvljSb4lMvhQrHOUkPNo4sqw/Bqp4SJ71ZO1uTTG2gHX3rElQozC8bFNmeAbDcKjJbRy0jZANKWeHSuNj/4oiqlQ2/VGolOK5mnD5Ab8HOiXgvtNSnJdvDGXO1aMUqEWyq0GBWcdP8qUp71L9yhD8DOt4IrIBD0m3mXKxfDpMocwcKzeOfbm2wflIuM3X0p+7UxpDe8RIGwGobG7eTtdlTCAY6di8xuYPaLACOq4FUCyhitmtvG5hGfnS0LHscR2F0FdHXBitB4gQwdRX8ru3u0fkQPrIU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18096099003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HmyNpRLg+sp/yBS15qcbU3SJvAmHlW7lbJtRjabXy7OAl1EjbvbnaA2dzgUX?=
 =?us-ascii?Q?g8hij6z1CLBanjaJ2RhLeuj8NwKCYWifGwu1GYPAF4qHp6Mhar/RuMAvQrvo?=
 =?us-ascii?Q?J+sqwQoxB45H7cMfHvkpJVWamrPCmZBR9TsSAymLVLUY+D1XdlSauRhVdvmF?=
 =?us-ascii?Q?DpkwMkPsVKuUOTZ4IHhIXVTI7sTFV8oz1FB31GkSU0zm8c51VHggy35mzuJ6?=
 =?us-ascii?Q?vPKyNxQGMsDCYpkkEvakYpl4hzNifkRtBB0EqqG9lm4Eo3h6lEa5EHtVgRnK?=
 =?us-ascii?Q?CvJAOrBKXn1cOEitPngWHqo3WGd4x8lZFhvL9qB5Gjip6+GME8kGxGXXX/Bm?=
 =?us-ascii?Q?3t4+dlP43+vvLIqRIbjJahHItRQABuyTjD2bW3qpIYQ1yjZLZO6V0tCh29mp?=
 =?us-ascii?Q?IFSFrQqva5o79/GeD31/5IxqQ0AE6woT8v9LAaGioygIR+VnJx67q6BZy2vo?=
 =?us-ascii?Q?qywXuliIU14VIYwXAasCeobm5zWDJ+kQPCqoi9G3pVSXWUPZdpG22qsm2quK?=
 =?us-ascii?Q?bHfXc8dZ6zvpfypl4OI8eFxefkeXsp7FSJx+bx1l3RmfpLcXHBkq6du59bT6?=
 =?us-ascii?Q?k7zO313CgojC9dTQyiM3gCHPmVFZraEzuM1sEvw33RSRV8OZKfeUHrMsFQpy?=
 =?us-ascii?Q?BOWWIh27xxXRAcS2uPiBV39BhdZXAdNQNYQS9jeKYOWNJyQ6X5fEkA7Bb8gH?=
 =?us-ascii?Q?JYq8wJjwsCbqq2J+CzJkYZ94/IMQ7DjHZIyuEYaFIrIeyO0UvmssAeH4HfEd?=
 =?us-ascii?Q?MYVq+ul1EyK0GK3Iaw7jVjGFaDQQZgkZwD7EyrogYLYJrbrj83D52Dr1pWrE?=
 =?us-ascii?Q?3Ib5Nsm99WzPOk+2vtKgoYMUFnbZTEklqCC9b86e8j+EEpveLBG0C4mubnXq?=
 =?us-ascii?Q?9THVdQYjfL9/sxs6owIhdm0POyurNxci38ysiwwt6qmKeCvzlFoWeo6DZiRk?=
 =?us-ascii?Q?z/5+gVmZ0NWggNfSbkDWW0JZCNYd+nJT6BT6JwtrSbky+mRm4E60lyaQnUZ6?=
 =?us-ascii?Q?tP142NQEo7FF+e2VBX5BHQSZ57o3RMg3Iy5FgYGm6kkmvGRD6JFtoiDctTMA?=
 =?us-ascii?Q?Gg+J2Yy5wlqWqHEhWo4DZh1Nz+3KnujOcFhVRGxWvqi5s5Ll2br1WaqgQL/r?=
 =?us-ascii?Q?hULFD8pkfnbQwhRUzvmcLHOEWhdtgIMh11VgWPVoSuS3AWkjRxyqyWjeXZqk?=
 =?us-ascii?Q?0ZI0EIrhGX1fRG21Phi1+EKrkSbn5hPl8W+2lmjZt1YK6c2f4XVMe0M/ABAX?=
 =?us-ascii?Q?hd7WBwGIprWSLQsPx2uAyEcIOhx0FknkNERyfL44RFOedf0ho+e2KKd3t6ro?=
 =?us-ascii?Q?bjM9h+OoRvZ/ks9AsvJPdLHw/2vZi70kCueS6kVY56ZKZ3GrSFznprMISPKn?=
 =?us-ascii?Q?7oUEmIh9Kx4JT4NXfgDc/c5W6bpp6S5H0ylCT9peeB05wasqh+snovWdrTTu?=
 =?us-ascii?Q?9ek+CpZ2tiw5Ffkx/ud9IBrCPo25WjOdHXdwzFLLSIwIDSPTi1EQS6ryw/lu?=
 =?us-ascii?Q?vP3iapzcl88MujmNYixY3ULPmvxx7CF/SY3EaUluQLQlIkvmir+338bpNnpy?=
 =?us-ascii?Q?NF9YuvBBDdGfNYhQo6Bl3Ky71uCNT/7v+ix6uGTQTH9Wl/Y+jwSJwQ61H9CW?=
 =?us-ascii?Q?xgsZsBHVwgOx/iyaBg08N6MDYI9TocmFFSDoyXiX4iMcm35AZOBp+zvWwSBr?=
 =?us-ascii?Q?21nQ/8O2lNBsiY5afpEixLha7BOUjYi9dgv4mDB3e4bOwu0ZEYcc7qAws+j4?=
 =?us-ascii?Q?a0LY56rgvdiFX5kfOnFT8tZPNOx1JDM=3D?=
X-Exchange-RoutingPolicyChecked:
	r5z3xuM8+VEItOf8yhMdbrinvWglDh3vp+DgiNfpQDz9kqablsJgM3+jr7ZStlnc6ffx2ut4cvz7K3UQw5virJRcsFjFCVvT0cMp5sNGuZI7MuzQ9tEU2C84LoIBUN6KZtlyPwKpzU9iBFaQNhy4iy3PGvcXHS0yuPhlTa+W8hlnIP0a5MozpI0IGpg0IvrllyTaroMm9i1noaeym3uP8/rE4Y/DulWxPaMNXgbC5tsdadqhFHkwneZqyacHnkXz/SV0LU0/0+rTN0t7L1CCordNevHX44Z52iFUvE381k+MXA+yyL5MeQkPNUMDjgIBNFl6+4FyEhcxXpCyTC9wCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j/uTNqQr67TlEJTCNxf9fHavSLi6ru1sjzuQ6fpGHx1Sxbmp5Q+PpTNTwqPPooIZt21gDuJd9m+TqibKIjNV9vjZtcNKs+5A5HYkvomjA+kC2SJSHfog+M2BuenF8/qT9eEL0SubVoNmoDmqv0vkdE+cYSWWnqF08wumx0it38Nzn1fvTrlFMILOnjXn6JAggx97XIqLOXUZimB87VnbTeeBjFqeb2f0DHonAUEJ8Ac8KhH0QWxf7Z1MmUMZ+5fCe/DtBFnIWrrsbqiY13znJMy9uUCmBoABQ989Jeyj7AShXtEHVi168+dsT/UYLnPtofcAwf6IWqWuQ34FKr2CUBclg7VdDlCVFA5Wfmz+GosM7cRvRKRZfGtvCzT9Q9X9PL9HwTYaXJl4x01kOWwETCdK5ZNEVjfJiM2CMOHcdCQj8TiPc8FI7yTgBkmf2erNYwJr4Qx6X/S9u828x8vyouY8z4UKT8jLRiZ3WC/1G7oWdNqiryNHoYJAmsMqTq21fqD6yajCHLpXFUuc2fkiJ2ETYP7EDNLQ2I4fFiXajX8lPaDbRYLgPMfpyd7zbFL6GpHRH8Nqdtp5IJjIwql2eCkyAMRzmQ/HY8IYPDshZDs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2869a189-d117-4d0b-2a6b-08dea5177606
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:31.8609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTJiMOdc9dYRJPFCMPAY0BbMnIs/QR40Or06t/GZKzDbmD0CwEW2zS0yCHkr83p85qjUpwcdE/i0ybOUapqiqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: 1sX7mVIFNesvP1xJn-p11DJWLttQrj_H
X-Proofpoint-ORIG-GUID: 1sX7mVIFNesvP1xJn-p11DJWLttQrj_H
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f096df b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=4WwWyauO2_0H2zdGQVkA:9 cc=ntf
 awl=host:13844
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMyBTYWx0ZWRfX/xkIT+6MAJfs
 DTANS8zSSmve1RRsKZ5lbNndSLd/r4DRrukPlpLg7WwZT/271lzCObh9oxg0YfVFVYropJu/GfD
 d4y1qUsRj6ByccyLGyJ6QQ0lEqAPd03NLjwpT1DvfDvkvZr0LA8+yXS+rImvYVfNQMmuxKQa1on
 l+ByDXfLRyV/FrDbk/3RopmaVGKq5ev4usuWjn4kdsOeapWzYfiuHAGWdiJMRD4mxGMDmjEQXTP
 hhFMIuFqR78FYqYdqi5uIHEqdGOPkD77c+7H4HTfoKF8cONv+WyZmtu8UFwxYCcZjpccseF9nc0
 GcDHe66s9kuzfKRndd/r0wJe9SeiS92gGiA7OhwK6xRDXAmntBw7gXQeWctzju2YXM2MrEdHHo7
 9GUyLY4pUf3RR78OY449vvO/kAnUFcHqMJLzsQdhyO5HhOnJN/QkcSMOe8LK2D3h+If9H/oXVom
 2zHoZaiwgFXODgjNSAbdC/5nnVLHPBqROBhYERIU=

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ca20f9430b4ac..b1cf35194895e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4064,6 +4064,41 @@ static void sd_mpath_add_disk(struct scsi_disk *sdkp)
 	mpath_device_set_live(mpath_device);
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
+const struct attribute_group *sd_mpath_disk_attr_groups[] = {
+	&sd_mpath_disk_attr_group,
+	&mpath_attr_group,
+	NULL
+};
+
 static int sd_mpath_probe(struct scsi_disk *sdkp)
 {
 	struct scsi_device *sdp = sdkp->device;
@@ -4149,6 +4184,7 @@ static int sd_mpath_probe(struct scsi_disk *sdkp)
 	/* undone in sd_mpath_disk_release() */
 	scsi_mpath_get_head(scsi_mpath_head);
 	scsi_mpath_head->mpath_head->drv_module = THIS_MODULE;
+	scsi_mpath_head->mpath_head->disk_groups = sd_mpath_disk_attr_groups;
 
 	error = device_add(&sd_mpath_disk->dev);
 	if (error) {
-- 
2.43.5

