Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A127EFF7;
	Thu,  2 Apr 2026 08:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775118626; cv=fail; b=TyhdJrQzB2OYtXRq1tKDgMe759iqDfKhxWFfJo6Jy02LUSk5rU7VIffhbdrdolm/SqzZlGyodmV7cuFZ2qp+WqKa9NXdJH1c2+kOa0lGb2rmHFzNHZsRyAzLVLxaTy6ADlGFuMX00jFa0IXTGPW6beEprmz5cztKC6N+6RLIGdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775118626; c=relaxed/simple;
	bh=oxRb5bi0YEhKtn/mHbn4WBUOsrqRfubUpqxkPhIw+vU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=rVOimD6QZ75Ly0ugpSwbRg2QcikAM78IOdcTrRVlhMZBVeg9z6O0XIs+trMrrcNadsVChWe9n4PlP8ZgSAHoRKFUTbPTkpId0TYmc1JHZ3h7dQXIuLAoKYI5S1Vj84Wyj0mgxrJkMr2Muv7tm11XyzkmaFnSlyonRMgQp6CPsQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=R/rdv4ci; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="R/rdv4ci"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6323wWqf903401;
	Thu, 2 Apr 2026 08:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=P9kAHxQr/
	Kn6v/Mm5H/t0XHpHBxtR8TWIJq+JQNJKDE=; b=R/rdv4civBZ8C7hBYyYIxhvEz
	RgPGdntXoH7eEnBUfECwBn0jt6C07+YAkn7fRf3kUTs2fyg75OREIycB4bWlRLqN
	XqzTtmysnS988GlquEn4pLhuIhFQqyRmchR5wTbVfqZ48wYFs4SFiXHwAhdcpOi/
	0v45HCjckaCbqKk7shoTJfgAm2Nw7b1PjYPJquSwnN+Yja32QRyXhvRAo+0lN3nf
	DTbWk7twUFvYQ/B9pz8OtSr/xNup3c7SrappviuGhkijE733rQ4SVL5Q9KjQ/1zC
	MOAkaFCjWapa8I9O4B83U6BWLgFpTGoYRTQeySs75yZbMBf7GBSny3TJXD/wA==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4d65y4fgdy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 08:29:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C6e/uETWk3qE2fZTg1yvwhhbi6Mjaj9gze4CzBfdo7pR+/O66t5WP/YSe4Cccyc1bIgoiVZOkw7VR6nvDa+92KiC49h3xEMhjcCEBb5xVdPdi/V998Bu+KhAen0jnDEoLww7OLZlAhLksxwu/KkretVfxjw+Q0P50HnGn/7vTl3V8dxF1d2mHMxvj1RkVbWU5LC4kaMzeOLudl8GTRx1IUKRaCc9Q0KIVU4PYnrMTa5v80kWn/kfSC00ahR45e+aN1w/w/bd/UDBOAZ4ppYpNqbkBxwBN+FvandeqN6oOdV5okycmA8CnCVFc1d+fU/OrcVrmgyBzJHY33Up614ruQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9kAHxQr/Kn6v/Mm5H/t0XHpHBxtR8TWIJq+JQNJKDE=;
 b=GXWlNOdlEvoDuya2COIIbVstcdy1teb4oiaWWemYPZSUSx4vQub1o2kltCQLiuGA8shilK4To2tv7dft1cMSMNHKb5yL/wCBsuOJtJiXJvqOPrffI/QNYIKSGww+Q8IuaVaVamuCsuf9QwllYPWonREf1UBESEzG/P0llcxkHE7gcPr6C9+oLSflofBT9Rphj7q0tUAYkvqsIQGJu9yQ6p4JToZvrKmah5u8x+rfhnkGglGmNxw5ET/F7WSJvFPi+kSbPMY75Kzj4u4TnmiWzCo+cOG/Szhh5DNTN1ZJ0we0QgGl5MJUOwuLgIGneiyg4RIOu9N/2RzpPQPo+sIOKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CYYPR11MB8430.namprd11.prod.outlook.com (2603:10b6:930:c6::19)
 by PH7PR11MB7479.namprd11.prod.outlook.com (2603:10b6:510:27f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 2 Apr
 2026 08:29:46 +0000
Received: from CYYPR11MB8430.namprd11.prod.outlook.com
 ([fe80::1d86:a34:519a:3b0d]) by CYYPR11MB8430.namprd11.prod.outlook.com
 ([fe80::1d86:a34:519a:3b0d%5]) with mapi id 15.20.9769.014; Thu, 2 Apr 2026
 08:29:46 +0000
From: liyin.zhang.cn@windriver.com
To: stable@vger.kernel.org
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        David Jeffery <djeffery@redhat.com>, Sasha Levin <sashal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: core: Move declaration before statements in scsi_dec_host_busy()
Date: Thu,  2 Apr 2026 16:29:28 +0800
Message-Id: <20260402082928.749751-1-liyin.zhang.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0009.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::19) To CYYPR11MB8430.namprd11.prod.outlook.com
 (2603:10b6:930:c6::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYYPR11MB8430:EE_|PH7PR11MB7479:EE_
X-MS-Office365-Filtering-Correlation-Id: 9271c37b-66b8-4a0c-0ef4-08de9091ff60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|18002099003|56012099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	/Qdq96UzHkXpwAB6baWmcv1ZQHz9dtBJO8nvB0vKjAmWYJom5IoxNcMba9ZGeO+Yapr5IIlrk+MpHBqk3GxEe+fpqTyNi6sQ3+66/WkZVRQKw08q45JbjLp6vbUeCyrP9b4dIRzXCWcWYEdY+6PWM6b+vR9LUBPL4NaPUBL89cIGOoKr7apXD1aDP5MMtXHbMDxnMhTiuI7XQIwLlAgWle9zAbHilp7xyGqhFYDjCezYXHKazXBgsn737tNtNC9F+cGpwQmJpMX94IMZSgZ9GYsQzVrjqlU0COkLFMCrj+oLi1Y+betu7TPBU5Ff7XuLAHDazEoxIjto37FpHTm1yXNosOM58/efGzlFEuDE2dCcEHR4Yin4FR33/wFHhhVebXtlOSGCnkp2lSJw8oRcU/WkHrH5taiOK/YUFS28fxF+bkU3KcxNrcVtWXjVuA4UmsiSDJsZ4MGC105EapVk90xviVjgOa7jfQUIlRqXc4jg91Mq6i0uyb4L/z1doI9tNeELnKIZmQLRQ5jJeWOPJ+SVnRtedRgFHxHxMEFMUjIGNhY7c5pRI289ugDyH8l2FQ0zbuUPvuZNeRN20PbCh4/qfltl7SkfuW1HRY2YdyfdNhJpgt6+gBI/FU1ml743cLkDNmZarG9KAzPaQYrPxKRTUojaMUT1Md4D4r7S/TjxjFTJnv5kNXRb1mke0uhwA9t1cVs+pb7zuSysNXvxvUEqTwEl+nOp3Z13ck/icho2h3volaZNpKnUJBRITw9UimAG4vcnkTZIMe9aJtmY1mmWWa2/j8XywIcxjUpngwk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYYPR11MB8430.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(18002099003)(56012099003)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XXKlMipY2N1XJrxgVJaPlJ3AiburGuMJLGCW7+zM0cHbLtgbIvBtJ+Os4S9O?=
 =?us-ascii?Q?wZEhjg13Q4gBNDG5xAoSyac1vBikucy1N7XYeqjU7LwbnGosEl7S/Uql37/g?=
 =?us-ascii?Q?1+ZL2xWynB6+w+lOgzy6mZcifA0CqywugVsUgucGU1FnzHYQG4HHZZTJ+5vy?=
 =?us-ascii?Q?7ONWPGOQ20HosFs48bBFI2/OyW/H2iohTT35XqYwR4gC7lv8i32xMGZivY9j?=
 =?us-ascii?Q?Aebn9rSBD81hdLtyhNAz0ik8twC1m4jOC5iM+F6B68tdBmJ2cFeW3NcVing2?=
 =?us-ascii?Q?+2v7mP2buelVXFZ85IZEascy5enNT+H4i/w9ZrLWUeGc3lZQ6swNtUcFCD9h?=
 =?us-ascii?Q?otsMmxSvg9glO8z1CxP+NpJaVmvfbDnejSeKB7sYlXiK3mDGV2OlCZM8GwcZ?=
 =?us-ascii?Q?2Zym+FvlvilyLDfjoGowuobh3ZYg2K0E1VmX526Y+jAoMifw2J/n8PI2Mie6?=
 =?us-ascii?Q?j6MmaAM1vS98IWoNYVxTucFB5F6OiucyRLR2zMD0hZ88CWsBPb/BziP3Mm+N?=
 =?us-ascii?Q?j+6pXBavlZfv1F4fahT4i5LLIRB8KVLITXbaZ21scEyAvIGKu8UKv73iT0AP?=
 =?us-ascii?Q?ns9fabeduwzrun0Wl/QzUTyjPyOVMW4CyQFLJ0SVeS7GrLRUQV+MljuTDrts?=
 =?us-ascii?Q?nPLfUtsN2+/ULyACb9UQyXVZgAu0W6ytFTWc2Wtrpn1a/U2DQ1329kP1YMQ+?=
 =?us-ascii?Q?snaoFsDN7MjHowya8tU0+0WJsFil9/qPe0I1rntDVcmxIKb6GWpXnjuqQZof?=
 =?us-ascii?Q?RIGR5NhS0fyCAYVAAI4AkAWdop4SJkrAoMfDWOjoqLBtmc6Y4jhjswQtBam2?=
 =?us-ascii?Q?xUrTvQGO3bSReBVlvabt05sFFPMSPvBWPPDi6OYMXBiplZnLMLt9MlKm2YIo?=
 =?us-ascii?Q?JckOGOS3liiHiM98LI+yS6sKl4Ru1FX0piDMIUYeWOzur4Nf96Jk1M5uvcnT?=
 =?us-ascii?Q?pAaikUQHr35jvT3EojFR7R7LNDIfaYH3M16d0F7ZaMpVOYMSAIKeGKBfDPI4?=
 =?us-ascii?Q?QIw0Km9f50rdQlLDNlWBd+iylkjae2/9Lln8gRDckl22MYxBoxJabVc93n6B?=
 =?us-ascii?Q?I2UP+1EYrUL4/qmPGmuyxX+uCJBf31ScTv9dtYKvI46pYdJSYWk/lCXmvKFf?=
 =?us-ascii?Q?umSvNLj0gGLAMxrWwM2jmoTsYmYdmR8vM6Ydhrf84+MrbGa4P994Eq0KeKfa?=
 =?us-ascii?Q?rNSS6gntLCEJ4QuLiXdKDYhU8KiPiZ6LT8Dt7O2zg/MikblvjjVy4wtSx66X?=
 =?us-ascii?Q?BX1NrSykea4qRpqxQVdIAcUhD1WiMWnM5/M3n+rLMjDPlsPaMOQtORe1/pUd?=
 =?us-ascii?Q?MSIE08/hz2yxd7xPQqbAr6r/YW3MnO2vODZRZKyIX72AmoeUM+4FtUo44y+3?=
 =?us-ascii?Q?Ol29dn+L2c5bh1/WBW9yyqm8V/FefPSh1CZIx2x/ZB0CISEfJKtGdgviZcaO?=
 =?us-ascii?Q?hgzdSPAGHxt2YsZmzzv4JH9Z49YF56+bO4D13w+t+IohPZD1T7kLadUyTGG1?=
 =?us-ascii?Q?IttpaMVYt+6ewg0MP4qxrSl9dsn3Zvzq/CbrLiWniowi6oncOeIU8XZWv1Hb?=
 =?us-ascii?Q?8MghZUWgQAfcgcd8ei7Yn2WpUGd+yhgnadt/JQNGkFyXlms2RGbzN3oMdOek?=
 =?us-ascii?Q?56YUa90J30TjpRb4YtxZiXALrjbIGdvwvHN8NbGj6Kuw3xS3GmiyROYDxmDj?=
 =?us-ascii?Q?6FcumoigdXwsRngwofeHRJVeKKrKL0lm3kk3fycmGxxpoqZzFY9nVRekLB4D?=
 =?us-ascii?Q?53k4ciML0y5NXK3zvWHiLKccLXNhtfo=3D?=
X-Exchange-RoutingPolicyChecked:
	hTg/hkesryAaOvdl3xbvoIOLB5E+BnzKGUaAMIXKAjGAipQk2Jgr21wbIU8aZrmVPMpZSar6N9zTVcW2uYvHKRlZdXb5aDQ0PLta1XNGry5sGdFZRcgYdxKMODBCxvyDd+a1zXEg7uLOQeM6+NLImu8XVrTsRQ6P787scRhx9ByWr6XZVgPboRW952UABOsVeLiQUqt21eo9VFuPYBTPfpAXqZv1LaCE19Fa/StBoF/tRBQ8EN6lv2AJUdglq29l3AfWNmWdOKoK6wjHrsz6TFxUJsAH0hhp1O4D8Rd2T38UgcDk9PmWVEkdFIfoo58HIPY1pZVxaZMMouH5CrYnog==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9271c37b-66b8-4a0c-0ef4-08de9091ff60
X-MS-Exchange-CrossTenant-AuthSource: CYYPR11MB8430.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 08:29:46.4450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0sMBTsq6AtVaSuknw/UpSxkc0E9OQzCh9b8e9z8Jh6Wb+MGy7Hl+p4gqgpQBADvwKV1NBSA6PvdSmfG/zxsCApWmbL+fHG8r3PES7K2qy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7479
X-Authority-Analysis: v=2.4 cv=QaZrf8bv c=1 sm=1 tr=0 ts=69ce28fd cx=c_pps
 a=IMbvhL78Fdh+aiPumIwVPQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22 a=t7CeM3EgAAAA:8
 a=iIPdoBXN6uFRupVwb04A:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDA3NCBTYWx0ZWRfXyd83NQ7vDk4a
 0d53K4zqcUqWk1MMp2+9BsDfgCcoc9G9om6MHSIHH0JMdTN8wFYI0wYi1LJyPVC+wzDSHhTygRs
 66Qkdl5w7RlzJi2tHB4MxaGQwvmujvt9OEoD+m0zWSvHE/bmbTVkmVJmBM7fnRWTvGHLwhkivwm
 ID//fhb+9QPNc4wyvIwqP7CaJ9qOBSflBUV4V7XXnP3x3fpalTPv+CehjdmWPv4ezt+h1f9Vvkd
 1arO34WcnFRZm23RwlD2807nC+3AieMAiJXCHlnOjLUqzhfRuFJh0cbPmy+Ne50Of3+0yh0A9Ev
 6EbAlhktDuX77+e1jG1pLiqzgbFB6w6scyqPRNlrdY6OeFqFHA+aJeI0jQYHLEZ7FxjLnWTJ0Cb
 0Qvki6/03PG6FR85r5ZrdTks5+LV1nhSkKt9BNB0oU0IoznWVm52i5fG5tKhEKSg+lLRikoI0jW
 V+Tw4r9GGW7ydg3dz0g==
X-Proofpoint-GUID: ZqvCMwv7nOVAC3mbIRuWSlQHmF939q2v
X-Proofpoint-ORIG-GUID: ZqvCMwv7nOVAC3mbIRuWSlQHmF939q2v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_01,2026-04-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 adultscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020074

From: Liyin Zhang <liyin.zhang.cn@windriver.com>

Commit 4e6c90119907 ("scsi: core: Move scsi_host_busy() out of host lock
if it is for per-command") introduced a variable declaration of 'busy' in
scsi_dec_host_busy().

Commit cc872e35c0df ("scsi: core: Wake up the error handler when final
completions race against each other") then added a 'smp_mb()' statement
before that declaration, resulting in mixed declarations and code which is
forbidden in ISO C90. The kernel 5.10 builds with '-std=gnu89' by default,
which makes this a compile warning.

Move the declaration before the statement to fix the warning.

Among the current longterm stable branches, only 5.15 and 5.10 build with
'-std=gnu89' by default. Since commit cc872e35c0df was not backported to
5.15, no compile warning is triggered there. Therefore this fix is only
needed for 5.10.

Fixes: cc872e35c0df ("scsi: core: Wake up the error handler when final completions race against each other")
Signed-off-by: Liyin Zhang <liyin.zhang.cn@windriver.com>
---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8d570632982f..14b37fb76400 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -306,6 +306,7 @@ EXPORT_SYMBOL(__scsi_execute);
 static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	unsigned long flags;
+	unsigned int busy;
 
 	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
@@ -318,7 +319,7 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 		 */
 		smp_mb();
 
-		unsigned int busy = scsi_host_busy(shost);
+		busy = scsi_host_busy(shost);
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		if (shost->host_failed || shost->host_eh_scheduled)
-- 
2.34.1

