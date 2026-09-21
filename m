Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CF049B5C2;
	Mon, 21 Sep 2026 13:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998950; cv=fail; b=Wnvk+G28IU1bmepYACjmcssWdB3jVTlZCbVPXJ/efwdtBcoHTnsJ0F53X55R3BozaZMbcRjCVt5MNuk+xVWjcBbYUKYxdpepu5uprdOXyj9L1LJpop9KCavAg5etK3ohN/cpxAemczdQtatUnr3Y9FMhwUFOXcjtHrP702kmvzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998950; c=relaxed/simple;
	bh=UsOrYKG6qMHda5RA5N4e5d79IG/DRWXMXm8AHe31cZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I67YIhE07r1lY+4r+afKJI2easpzmH9wNDeXg1oaum9t8yvlUAh8DCYoLiGsyU5GATMS0eYulVC5024iv1WWkIC1bRN5xyseSCzFwl+zO/L5QX+MxrxTmqJ1DdAg/am5gd9z1xg7ePccmdmrNy9wZO82/VHeXgS8V30uAE2l4BI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=GIqjfue8; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="GIqjfue8"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LDnhZ91075912;
	Mon, 21 Sep 2026 13:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=/+TARu7PaZDTl1a3tD+LGws/yM2Ff+Jr7sz8g92YFIk=; b=
	GIqjfue8oRLJGpE+1qTZO7Vmh/ZqAoCNRnhZQwJ6n85wfux2tedZP0lQmqhU20nz
	Iw8LTKZyWDEJNiZ70yiGNYB0CwAYdg5BRl99WzlWhzhf48pGq5b0XekHIik3tQ/b
	l/nz1PkVmIJVnXhomod1qawnKTANgZHJ0OwDA0QTqzevjfIvmCsVqfnMWk/dMOR4
	13zPRcIP7er771O6fGI9kTxuiWPkXTLoyq/DmryCnkfOya11pwJVvkUT1HBMNjts
	NOahF7GTRW525WGfDY7U20c8MdVrL1wr3kprMvbNAGoY/2BSZ1PFkomoniI9l4bD
	AxO1VzHDBfcf9uFPH+57Tg==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023092.outbound.protection.outlook.com [40.93.201.92])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4gshc7jn5h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 13:54:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ty9hsKOWsNFDDYlVtuPVWdRbm5+ganbuAZsRiQJprGm1X4wJEh2XiVZMa/MUN5lWFvpGMb59HO2ACOt2LNgnT3JGzCWD3uEk18YpaBzmrWlZp3mMfQ6+dDJWyxVP1YshX8ydMvr1YDlQkM6kOIcFKo9KYcWXqHs/JiEZXSDmjxace5oSPRPCrSh1B1AysLXRmf4/YbAPMrOqtiRJZnQ+PxYN0QBTfox7z0HbTY5f7yDj/WdVFKZRDqBfz4lLo1Okp2JfMEqH4VAJ/7zS93lv2idTjpF+cWyxnEPtAtP9ysiE1QONcm9wN+BO3kAyADhydl29W2bzXkCsMh/7ZVlC7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+TARu7PaZDTl1a3tD+LGws/yM2Ff+Jr7sz8g92YFIk=;
 b=vlsLDMJ9lDSALfrcAJJhfPOxbhTGsWzjhfbBrG2v2EFzK/CZZO3Yv2cglYt+BzbYM0M6xchh+QyCRBYwge/aStwHqXtcNf3UWs8zL9Yq9uelPh0ihI0qsf+tcxhH9U5oSrXNLgz7EWqNlLn6FyjXdoCYltlimqoL8z8FhQ9AfLo98uPn5YW4h2JAfhBuKyH+a0tvpPNCq7GgGTn6gDnArWwFU0TIhkuRQPE+CXqRfx8hZ5NXvXxzIT2sy9Eia6x0icBgGXVP7JtGBqZXupK5wonw3RtbPtyvBY0cKMzL/rJdYSsPqo+KO+gG5Hc+wjKTVgkAXyLuBnTgATgKtE+I9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by IA1PR11MB6220.namprd11.prod.outlook.com (2603:10b6:208:3e8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 13:54:12 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%3]) with mapi id 15.21.0428.011; Mon, 21 Sep 2026
 13:54:12 +0000
From: Ionut Nechita <ionut.nechita@windriver.com>
To: ionut.nechita@windriver.com
Cc: atomlin@atomlin.com, axboe@kernel.dk, bigeasy@linutronix.de,
        corbet@lwn.net, frederic@kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, marco.crivellari@suse.com,
        mingo@redhat.com, mkp@kernel.org, neelx@suse.com, peterz@infradead.org,
        tglx@kernel.org, vincent.guittot@linaro.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Date: Mon, 21 Sep 2026 16:53:38 +0300
Message-ID: <20260921135353.317688-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917154455.386769-1-ionut.nechita@windriver.com>
References: <20260917154455.386769-1-ionut.nechita@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::9) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|IA1PR11MB6220:EE_
X-MS-Office365-Filtering-Correlation-Id: d61ed4df-1c7b-4fa5-c218-08df17e7d123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|52116014|7416014|1800799024|10067099003|5023799004|6133799003|22082099003|18002099003|56012099006|11063799006|38350700014;
X-Microsoft-Antispam-Message-Info:
	D7NtkvIj1cizwGC95GVlP50BuOSmnWVs8ytCV98jY/wQqO61uKoRNfrPBg7koafAQcuBegYAKCyDBE3tO4JGZSptkJUBsh9+sd6ewrsBk2yVUX4L6Ay1mfXf2QB8F5+WxthIQNgEEIbZTKA2ImVA86MHi0EDudYXNPeMxKTrPwZu/HJ4NohJ8ivvfOTOCTk7KTQQtd+6DxhHxtyQKwcebegq667V7oD0X8sHJeWztDSv9mRMkYz/ZxLahFzyzbCNKb1Wj8ack8cF3WWEbYqmuJBGeUQS17f584iCFb3htT/J0zhzWBgMLd5YXfJ02Uuxh4lDLdOPU9Jnqt1uY6nG4SZXEqNTpAtNm6INrHLaEQpl5R/nybNZBjsrmND4zDq7DTiNPYBL5rLc24XrfkJdow3gCJfd96oWsl52/vBKNjkWCIbgn2R/TZvKraeSpGR3QyQah6qWbjA+qHU0vkEHwf+E7/e450VvuSPvhjX8xL/deF+6J/bKTd3nl11JLBFx9deAi5LC4joVy6h/8IjYxpnVTbK5yUCmeS7OBslSbBh8Y3Xf0obF9WVWyoiWXK3FaRbgIiBo3NyCxRABkVcf2N92NXlG9JIX999ZjUij/Ul2J0hgqR6h7wF3yzJ/qax/+h4DI0CnztkOtdEAZDSDzb9upC/bmsJtZPofRiiTEuXE0kbhGKuRrxHIa5oiJOA497Y+5VlPEQPLsOfB9O33brAvT5OJ/+Zs/9p1bMSUQlY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(52116014)(7416014)(1800799024)(10067099003)(5023799004)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zZ5BqZVwe3O0eYv4DtkedL+UftAs5M1KhBR+scNx3UEmOasKAEdG901vq6Y6?=
 =?us-ascii?Q?o7aGrH48OnvkFP7kY+nyguRUR37NnBqsKIz2uStglmDRhoMx8bkV6QaWbXzz?=
 =?us-ascii?Q?g3YZ9OoQ5mhLoaLd57FdQkUv09bJbV3GbESoEmanNOQKbubDLuKMKm3sivPT?=
 =?us-ascii?Q?W8xvZ29vQYpDZrd1bPElPmx+C/WtB6ou2Oz7q82B2AljTOq8+f4GtGGz+0jI?=
 =?us-ascii?Q?bnCpdHOWvq493/gGz7Yd0Rp6qIiWUtiZOdc/Wz6K+wrkhFUqe3aEBMh0QoGF?=
 =?us-ascii?Q?tvRT9yIm/kCptZyGt3FuKgTv6eyc8+g0e/2uGD1LMsgf+AebIyKCABDANCwi?=
 =?us-ascii?Q?6Qd7l4yjJVBKg/CJJlT3TA8q4TqZCY+QMrFeGVK4u6F5eSCF23TRx4xkhenC?=
 =?us-ascii?Q?b1KBWmUKoxVyftWtY/cRIb+jc+5EyQG3CndVCPWMcASp5F/UZ51xvFP0TQt1?=
 =?us-ascii?Q?ysepm3J0wZOEKrOmzPRbZHsRVRh0I7Ky15yM3cursQYY/m+otpdP7+UAtKaX?=
 =?us-ascii?Q?JcxS0ZoP+/uXiMJrPxZtfwJUezkLaskYWPrUA+SwfEVfmctGAjL69ZHlSJcR?=
 =?us-ascii?Q?nAzroBbs7g8A1LDCscxYf/CoKyeTKMvmJ7zx0LStjVUtJj2VKwQD5D+oSsp7?=
 =?us-ascii?Q?LBQGePuNebFeXnXYVjPNKh0aiwBRItDEGySMQx77hZ4JBFCvbvkb719h7c8J?=
 =?us-ascii?Q?gVRIB3Y7D0pHa3ZPtDrMW739IBc98gUqucVFbqfBFyvektD9CDdDpTQPLesz?=
 =?us-ascii?Q?T9c4yKjjhAcXblqtxVyhbpQ1w1QSMh8zZomC/8X7gmn9vJvTxjt1Asuw+1UL?=
 =?us-ascii?Q?a+977j3o9FuRMNVIDo4LHZlefghSbulMUsduRFo7HeVrWBF8pHGKQBdc25Oq?=
 =?us-ascii?Q?AaaMz7FrudkW/48EPAhMU3NrS+dfr+8gTKIrbkGpd/aciJKWGd7+vUB3NrFJ?=
 =?us-ascii?Q?Vb4uNRXwZxO7Y2jGEWcOCNF225slHzuyRx39UgIG6p0T3+Ctu1DClBHvHbi+?=
 =?us-ascii?Q?4SsJHQEJ0WrDJ8oE8yOEFgL8FtV517IeRa3jYRIe7FW99dHz3VoP51tAoID+?=
 =?us-ascii?Q?4R7YeTzIKl1JhjnR3H2tDoHZnWvuwiqsNnA8Mg6sFjoGIRyp2T2FORDvM/u9?=
 =?us-ascii?Q?Ht/1F+5LF1E0ajeSY2hyHxGLcNwt1nxXkC+sJ7VNbLzqPWsM6B8O2vTo78OD?=
 =?us-ascii?Q?u9NDkAfgl125xS2eHm2GhWPo9CvI+7d+BMiFIdlj+CT1xBsHncnahmIjo/Vj?=
 =?us-ascii?Q?pcEjgPRKpA6OBZ7WplsYRGrW3uq3poLXIsoKrE0OymxbzpWuOv5og9YvPRiJ?=
 =?us-ascii?Q?945w3qYU+1XxxI1KiIM35pH6qMbFjMd1q1bBvomjOU+q1Pqrv4A2ljO7fxpu?=
 =?us-ascii?Q?P4qtjUFiexsksmQSR5ri+h3bEPtZHGHfyjCkTYj0axk7eg3urWeXBfQIfirL?=
 =?us-ascii?Q?O4VKOOJ/LxX3UIES01IqQa4eIU5toASb4/msak6suLEUPSrm0v6nkS9gdpk2?=
 =?us-ascii?Q?v0ZxIFj6J8scG5Uv8dXyqtW++FeG+srdX2VEOb0z/VTffBdsEYESPET1zjrp?=
 =?us-ascii?Q?FdBmfwQqgplqILow0s98YsmRmMyaP27+ZOtZ87JdKzCohRU7Ru8eM/93+CkU?=
 =?us-ascii?Q?GXK8ZDN5Hgt7avU5EjmWNvcqUBb8EGHpjH5CBe30aNa4MO3X+WuiDuWLy1+h?=
 =?us-ascii?Q?/lcgIiBUkPVanQfBhZGVGL2E/Y2tADJdbm8v949nFcMt3N8efVd+ja2sjAeS?=
 =?us-ascii?Q?V4+0s6XDkZVzv62s6ZPXfaoJTpbSniM=3D?=
X-Exchange-RoutingPolicyChecked:
	TqvY37jL5J2jqLO5ijqQLo6h6zBj9A4OAL1jEWQ5oohvu7enB3OImVqlE1OlPZJ6blQ6EK3UWPGmKY+t4ghLTgLPSg1X26lCQQGkXzuycixe2W6yH9Re5iG4Hg895ckUha8GQR92DopfB+hWDk84Cgq7Bl7GWVdtVuTnN+RvT+YqJOK6fuJorxZ5y2whZ4yvZWy33IdmOVcUy4ImOrJ5wXxlPBkR0geqhLzZ+X0++WkeJBgjFHH9SkK6ncHzQwFv2MY44MBQO+d71C3XQLzyK1nFUA2sDPwi39Rm55UgkWjwp8BoMbXs8kv3b2OD2DpXy5jp7lbg85xq7hX+lhjuVg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61ed4df-1c7b-4fa5-c218-08df17e7d123
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 13:54:12.7119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ylKD5zeAnf4XV264jkcL0uhbvRmQxnF+ZrnvypI7DwGTP9J/xAGaMXtKIdb3713NrP30+RR9LN8kQnXN5wvyNd20nnsjvBsYs7YDVQ798mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6220
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDIwMiBTYWx0ZWRfX7J6OP3Dw3Rl+
 H2rjnG59+oOplQv9a1fGktFZw4xjtAtHylPWDFkw9hXDQbhQohfBu/4nLdYi/gqrW9fe4oboDrV
 sbB8dK+CCHEdPbwzQp0Sx9ci56v1kBOLG+AJcAuc8jNJqzFoCztdBK8oLU42Rr+nqEjXu+ggZ9k
 ICBXf1h93pK86A1NbrnzK8UWulHj8fyBOWt497ngJZzO+O7xBvKXywU69shEG47tzY+IoUtfvOe
 63UnXUTRZ9EjpCISIAEMCP/qyV/2YcX0cbp5TJ1bGK3ou1keNmTgXQyI0r/7n1/busNAvkuoZTZ
 ps2QVyhElNw7Nemd6DqioOSIpGwvZJdXGEaHVBtJ/hVAPkI/FvICJxt3F4o428L8TqFzXlvZQiP
 PcanBiccK03zH4faRhPAvSr+VlpBvHHwd1xfw0I/QWalBtchM4q8IIR1p+eoDhJujH0HfYdbp7i
 2bo1FnORMdAdhh0LKmQ==
X-Proofpoint-GUID: E45KXa46W4HrRdkNASPv5egZA2oMKvOt
X-Proofpoint-ORIG-GUID: E45KXa46W4HrRdkNASPv5egZA2oMKvOt
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDIwMiBTYWx0ZWRfX5Fvf7QXqNRHI
 LxpDVbvSBWYAqaOYQRyRvuH99H3g0Pre6tkvsABiV7o9yVe9pSdOuWfvppmeW2p5jF036hPdQ4H
 qMH5AtRCOj3kbSCgKvx6A/3c64qDzpl/hykdrEYmgPrnFm/ptEEP
X-Authority-Analysis: v=2.4 cv=feM4WEQF c=1 sm=1 tr=0 ts=6ab13709 cx=c_pps
 a=Ta0D7379KrHwLEZKU6rhjg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22 a=t7CeM3EgAAAA:8
 a=PbNhXFLJTpAsvfpV07EA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210202


Hi Aaron, Daniel,

As promised, here are the end-to-end results from exercising v16 on our
6.18 LTS PREEMPT_RT tree. Short version: managed_irq_strict behaves
exactly as documented on multiqueue NVMe with a deliberately narrow
housekeeping pool, including the nr_vectors >= nr_cpus case.

Series under test (as backported to 6.18 LTS)
---------------------------------------------
  0001 scsi-aacraid: use block-layer helpers for queue count
  0002 lib/group_cpus: remove dead SMP code
  0003 lib/group_cpus: add group_mask_cpus_evenly()
  0004 sched/isolation: prevent out-of-bounds read in isolcpus parsing
  0005 isolation: introduce the managed_irq_strict isolcpus type
  0006 blk-mq: use housekeeping CPUs only with isolcpus=managed_irq_strict
  0007 blk-mq: prevent offlining housekeeping CPUs with online-associated
       queues
  0008 genirq/affinity: restrict managed IRQ affinity to housekeeping CPUs
  0009 docs: document the managed_irq_strict isolcpus flag
  0010 genirq/affinity: confine reserved pre/post vectors to housekeeping
       CPUs

Note: 0010 is a local follow-up (see section 3), not part of the
upstream v16 series.

Test environment
----------------
  Kernel:   6.18.15-rt and 6.18.52-rt (PREEMPT_RT), v16 backported
            (6.18.52 is the current 6.18 LTS; behaviour is identical on
            both, the data below is from 6.18.15)
  CPU:      single-socket Intel Xeon (Granite Rapids), 40C/80T,
            1 NUMA node (all 80 CPUs on node0)
  Storage:  2x NVMe (SK hynix PE9010), b6:00.0 and b7:00.0
  NICs:     8-port E830-CC + 4-port E825-C (managed IRQs)
  MSI-X:    2235 vectors allocated system-wide

  cmdline (relevant bits):
    nohz_full=2-38,42-78
    isolcpus=nohz,domain,managed_irq_strict,2-38,42-78
    rcu_nocbs=2-39,42-79 kthread_cpus=0-1,40-41 irqaffinity=39,79

  => isolated (isolcpus) = 2-38,42-78   (74 CPUs)
     housekeeping (HK)   = 0,1,39,40,41,79   (6 CPUs)

Because HK is only 6 CPUs while the box carries 2235 vectors, this is
squarely the "narrow housekeeping pool, nr_vectors >= nr_cpus" scenario.

1) blk-mq queue allocation and mapping (patches 6, 7)
-----------------------------------------------------
Both NVMe devices allocate exactly 6 hardware queues, matching the HK
weight. Each hctx is owned by exactly one HK CPU:

    nvme0n1 / nvme1n1:
      hctx0: 0   hctx1: 1   hctx2: 39
      hctx3: 40  hctx4: 41  hctx5: 79

No isolated CPU owns a queue. The sysfs cpu_list only shows the HK CPUs
because blk_mq_map_swqueue() strips the isolated CPUs from hctx->cpumask
(as intended). The full software-context routing from debugfs confirms
the 74 isolated CPUs are still mapped onto these 6 HK queues rather than
left unserved, evenly (~12-13 isolated CPUs per queue), so I/O submitted
from an isolated core completes on a housekeeping CPU:

    hctx0 (owner 0):  0,2,8,14,20,26,32,38,47,53,59,65,71,77
    hctx1 (owner 1):  1,3,9,15,21,27,33,42,48,54,60,66,72,78
    hctx2 (owner 39): 4,10,16,22,28,34,39,43,49,55,61,67,73
    hctx3 (owner 40): 5,11,17,23,29,35,40,44,50,56,62,68,74
    hctx4 (owner 41): 6,12,18,24,30,36,41,45,51,57,63,69,75
    hctx5 (owner 79): 7,13,19,25,31,37,46,52,58,64,70,76,79

All 80 CPUs are covered exactly once. This also lines up with the
hotplug guard below: isolated CPU 3 is routed to hctx1 (owned by HK CPU
1), which is precisely why offlining CPU 1 is refused.

2) Managed IRQ affinity (patch 8)
---------------------------------
Every NVMe completion-queue vector has its effective_affinity confined
to the HK set:

    nvme0q1..q6 eff = 0, 1, 39, 40, 41, 79
    nvme1q1..q6 eff = 0, 1, 39, 40, 41, 79

No managed interrupt targets an isolated CPU.

3) Reserved pre/post vectors
----------------------------
The NVMe admin (pre_vector) queues also stay off the isolated set:

    nvme0q0 eff = 79
    nvme1q0 eff = 39

Note: in the stock series the reserved pre/post vectors still default to
irq_default_affinity, which on this config spans the isolated CPUs, so a
freshly probed admin queue can briefly land on an isolated core before
any userspace re-steer. On PREEMPT_RT that stray wakeup is precisely
what we are trying to avoid, so we carry a small follow-up that confines
the affd->pre_vectors / post_vectors to the housekeeping mask when
HK_TYPE_MANAGED_IRQ_STRICT is set. The affinities above are with that
follow-up applied. Happy to post it separately if there is interest in
closing that gap upstream.

4) blk-mq hotplug guard (patch 7)
---------------------------------
Offlining a housekeeping CPU that still serves an online isolated CPU is
refused:

    # echo 0 > /sys/devices/system/cpu/cpu1/online
    -> fails (-EINVAL)
    blk-mq: cannot offline CPU 1: online isolated CPU 3 is still
            mapped to hctx1

After offlining the dependent isolated CPUs first, offlining the HK CPU
succeeds. suspend/hibernate (cpuhp_tasks_frozen) is correctly exempted.

5) Vector count / probe robustness (patch 8)
--------------------------------------------
With 2235 vectors against 6 HK CPUs, no device aborted probe: no -ENOSPC
and no nr_io_queues=0. The minimum-vector safety net in
irq_calc_affinity_vectors() holds on this narrow-HK box.

Backport notes (6.18.15 / 6.18.52)
----------------------------------
Nothing behavioural, just tree deltas: the default isolcpus flag stays
HK_FLAG_DOMAIN (no HK_FLAG_DOMAIN_BOOT in this tree); the cpus_read_lock
around the cpu_possible_mask weight in irq_calc_affinity_vectors() is
retained; and the housekeeping.rst hunk from the docs patch is dropped
(that guide does not exist here).

6) Runtime completion locality (PREEMPT_RT threaded IRQs)
---------------------------------------------------------
fio randread 64k, 4 jobs, iodepth=64, 120s, pinned to a single isolated
CPU via a device-plugin extended resource on Kubernetes.

  Results:
    IOPS       : 56.9k
    Bandwidth  : 3559 MiB/s (3732 MB/s), 417 GiB in 120s
    clat       : avg 4489us, stdev 30.99us, p99 4555us
    total IOs  : 6,833,178

While fio was submitting from that isolated CPU, every threaded NVMe
IRQ handler on the host was scheduled on a housekeeping CPU
(SCHED_FIFO, as expected on PREEMPT_RT). `ps -eLo psr,cls,comm |
grep irq.*nvme` during the run:

   0 FF irq/195-nvme0q3   0 FF irq/196-nvme0q4   0 FF irq/198-nvme0q6
   1 FF irq/187-nvme1q2   1 FF irq/188-nvme1q3   1 FF irq/194-nvme0q2
  39 FF irq/185-nvme1q0
  40 FF irq/186-nvme1q1  40 FF irq/189-nvme1q4  40 FF irq/193-nvme1q6
  41 FF irq/191-nvme1q5  41 FF irq/192-nvme0q1  41 FF irq/197-nvme0q5
  79 FF irq/190-nvme0q0

All 14 threaded handlers land on {0,1,39,40,41,79} = HK. Zero
irq/*-nvme* threads scheduled on any of the 74 isolated CPUs.

The /proc/interrupts delta over the 120s run confirms it at the counter
level. Every nvme* IRQ that fired incremented only on an HK CPU:

  irq 192 nvme0q1 CPU0 : +6,809,271   (fio's IOs, one HK owner)
  irq 187 nvme1q2 CPU1 : +684
  irq 186 nvme1q1 CPU0 : +598
  irq 189 nvme1q4 CPU40: +568
  irq 191 nvme1q5 CPU41: +512
  irq 188 nvme1q3 CPU39: +304
  irq 193 nvme1q6 CPU79: +271
  irq 196 nvme0q4 CPU40: +4
  irq 194 nvme0q2 CPU1 : +3

Every single delta is on {0,1,39,40,41,79}. Zero completions on any of
the 74 isolated CPUs. I/O submitted by a task pinned to an isolated
core completes entirely on housekeeping cores.

Still on my list: a negative-control boot with plain managed_irq to
show the confinement disappears. I will follow up with that.

On option 1 vs option 2, my earlier preference stands: keep
managed_irq_strict as an explicit opt-in and leave managed_irq
semantics unchanged, to avoid a silent behavioural change for existing
deployments.

Tested-by: Ionut Nechita <ionut.nechita@windriver.com>

Thanks,
Ionut
