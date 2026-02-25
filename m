Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C84E3ED117;
	Wed, 25 Feb 2026 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034050; cv=fail; b=GrLcQrn8ZSapvtFqzQpcd7dCaQd6vwxaHuK7scRv3b5KuUX3TbJF7xyvoZM5vB2r55lEkeTtiMsRhn99Sq0qVecpyPZ90sZTdBUZ/i9y/gFprUo+t7KAYTCkBCXBOkCXoP/Giq1L5dV1ZRdAVAfEtIEB/dWhT3MwQdRp4sk2EOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034050; c=relaxed/simple;
	bh=IhdZhA/HEfiDtSSWOsFQyw8WiujuCLdUOU/OIIJYr7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Suno+3xQcQsGWJBF6LgitVMomS5R3g4yt/GQX5wJ38fGmJUxuWxUDWvWjafcD8pcQ/j+m/ES0lVvk2rbdMArqAJ41LF5PO0YS8k5xLVpYkr/6E8AID0SOOuNkAyJEuZu10vUvn13UMacH7kPyaTzPhdgT+zvsLGAo+MiXrsZQss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sPxXb0Q+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oqFT4H0e; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sPxXb0Q+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oqFT4H0e"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAjt7a817332;
	Wed, 25 Feb 2026 15:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aordF72PD6FGSCIkzddrvVR40KyApVMqwTvKBk9yX/4=; b=
	sPxXb0Q+cRbUmVlwul9uvU1GHoPzC8uKV4KgGhdNXXk1yYVxp7S2xVvzgImuovm2
	jtg8+tkn1M+ObiUNR5tZCHuH+E4f9Yma74itN6w/a6HvqwIup4fYK/y9ZSMAV2XF
	Qk3Gh5/CzO2/5pxrRYT9uev6BetUFytDM/2XWbUJ3TTk4+FyosZOi9/sgwov2tmf
	VBKYM8WZ59T7rAkjwI3ootUm5LuvzPWlhmAvS7OsXn+/37QH37TZNXdcVH5ZuZ59
	LJtWz5SgtN0MyqccK3z/okWAso0j0Qe8bCjhZQLlyH5TfUNZGT1+/n+TWigNGho0
	Snk/q5OdfkRFhrHaKiVFUA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areetd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEtRbs012506;
	Wed, 25 Feb 2026 15:40:35 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg4s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6WIcy8drsEJ8EwMEhby1zI4wIhzYf7xoL/cFgFvp/BOBM0q1u0CsXKPq470MPadc/J8xSzi9XSIa4SJsEBqja4FXvq4v+LGk20VHNdQvbTGfcXefcLA+aFSIprra9xSQZBCKo9LFKXe34q2bkzP/WGfTzZ1NXu991cWkgL22DcwiAria0Rs9JfhZCWsSFrgZlT4c5yJIcO12jONxRWhRNOMwYQHkfuMpdtXnzkR3dPQqQliiE/2ZLhmjpH3MzaQIYU752gaTN1yii+jly2OlWJjmJszD93fa6fIIF3/D/sJZkTKnfNRG4X2EosYJdoxLg9X7rKgMJfKm9M636Gs7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aordF72PD6FGSCIkzddrvVR40KyApVMqwTvKBk9yX/4=;
 b=zOIB/MdZcG9xtpvn6nGX9zUyYtL8axo4+4paS68YDy2GLG1HTTfJB0nrL4mDWRK0ULy0/H818Vpld9PQURrfxVJtKsqn94Pt7XSdQEk8AIbxq9UK5pGUbVL3VnXwodmHOiQqV57Bo5q8h8J1pYluJoIgnTvPa9zuT9CmFh+asFRukJO2EjT77dDik9iL9rKsx88eziHRwzAtfiaR26QZfGJThWz1AUZ9V50fCO50RTEnJcUM9XC+CvZ2Z+1qxrXS5wK3uaa6dO6ujlLLoUJ7aU+3a3GBG18XZAIWIrXxnnZOWZwGXcE+L3LRBVqyzCPPjmyAmUhe/iVyTwYa3r41Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aordF72PD6FGSCIkzddrvVR40KyApVMqwTvKBk9yX/4=;
 b=oqFT4H0e+AScqd8AcTbX5/9mtEQVEL/mHXvLWJ1osO86SlI2JrdqR1ctpUftv5GAXOT0DLVHt7fu4x+419fvdjxBM+h0v6PY9MKnqBy2SW3pITNdKOoZ/P0SXDZRq1/LHGJKGT9yqUbTGnGKTgn39EgLBDKYZ38dtYS5FdCtYAQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB6319.namprd10.prod.outlook.com
 (2603:10b6:806:252::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:40:31 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 05/19] nvme-multipath: add nvme_mpath_available_path()
Date: Wed, 25 Feb 2026 15:39:53 +0000
Message-ID: <20260225154007.1033735-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 1311b1ec-5e17-42eb-40c7-08de74843500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	zpeWdbxEhR8cGjFnEe7FX3jav0OulvzurJ7Isx5JzBDBb+uGh1o5d8tC1fdzHjpyOfgYwntoxX2Q+gqHvgQD0W9I+h19ZGOmJ+zPyJZJOcs2JqXR6iJT63DeNCyjXmYZr8VqYdvsEYMejSt4ilu3JRcqr5PiqKzpqUlAziYY8Lufev6UHZTWbKmH6EXPA17IqO9z0MmQmJBhLAVMEB7xNIagHOApOyhdF6YOk2rJbW75bh7YBLkShZ2LNLKDmtCDVYeO8SCCcQjDGC4kllVtMmq3GiP4QnGnOFioXMMGpNT15bgVmgKLJ4BK1ws6yuboWr3IC8lNoEjmQFIHK+0AqXGyp4mAcnoG1W1aOGmZwe85xwdvBYsnTnd0D+nJNzFQI2lkhcGjBSZnPE5aNHH5Y9c1MhxwyL3ATiUNzLWVwMgl9R2iafX/VW+9q3hIf96lhnhnP9DRCi3otU5CHJIBRpHoxu4r4Thy8S7+wKtEG1yasHxHGqjHJqBUiGN08bzdGwEoanWh7WHCKJnYgmnsFblVSvVkNQ78BlhOvgurWlPyB2Lf3rTNCC5JEW+W2Qx6fl0R9HR+wX9/nDxiPRs9DZj0Vu8kdP2DRpM1ELLMIw9yZA/VHZBkcFhxWx8VV9VbG3L93rBzRaj0tEJZex0oWEP+R3vhRhTxxhITDB3ceNrGHmE2umHranrF7KqIS10VLO+VVLd96gUjAd91LpmCpATUD95IWE9BFp65Kd+4Qjk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ylzWowfPzc32NpxQDTe7aVRFdF0w90v60sYHZKUOZhj/Lm+vxTNA3a7Hac3S?=
 =?us-ascii?Q?ESLucjotreCPN10Do337NVq2du+Kx1YNBrC2eLQAMYx+HZyRAJ4Lsww9mS9E?=
 =?us-ascii?Q?x/U1BTCv7kPSgoXj70DRKTuft7YcazdVZj6znhCpXlvlztTce0YNF0emmx1B?=
 =?us-ascii?Q?4nOaXtvseh8XErEBg4m6P4i9r93Urgg5vN5gVwTAaEF2FJeot1KbFqTqwyD7?=
 =?us-ascii?Q?dxjQHZ4T5H/Rl/NEe+1fmfPxlrbGsDyzsZQhznNJvWMfBm46jwPgU1qmqfiz?=
 =?us-ascii?Q?jWyOvgniM6Xy69VcwyYdWG3+Rh5bUfYY6m8amcWAj3hIHLAUeCMlqL30oGNQ?=
 =?us-ascii?Q?mnhiIDYNp8qoM/6yZqXpv6tgPUIXU45xQtic2DVT268eORrzuFL1UklT3xHw?=
 =?us-ascii?Q?7I9zB+ix7TYpO5YIIeP/DvuEynFKejBQ2i/nefqDWFKLEyhj38fh8jayR7zT?=
 =?us-ascii?Q?XFZ4W3ya6OnPC6VrMTb50iHL37lNtTbspMPRv0fdZca49AB0J78fevaU68MW?=
 =?us-ascii?Q?gjRMNFEqwdsaldoRxg0VOveVG5lUUU73TZ2ArCiHZOZ9E/E+w/wEI4E906+a?=
 =?us-ascii?Q?81adsO4wZxyfet1PRTtYz8jiZ1lS6tIws5WGLLCC4psni0m8SUC3s4ZJAjWF?=
 =?us-ascii?Q?JMLO0i3jC10p+oyannN+XWyN5wweq2Q9ZsddEbnNsufjRS6WZHCHo7M7mjTW?=
 =?us-ascii?Q?a112VowQXnpRDKUEoGz2IL/iTbgwU4PINHSgyxA2D06hmuKfEnLQuC12MyyS?=
 =?us-ascii?Q?0UlbrUIFxE3XmDzm0qWfZPJENcqm9gc4Q8tJ6C/j64qEhQoTx7hZuhz4e8wR?=
 =?us-ascii?Q?qc1eN/HP/nVyD05GBkL+c3dWOLDVFcdat991EhemCx9+AuTsJeFkRsuvD1q/?=
 =?us-ascii?Q?q0VsfP6LVBBz9U83DYy+W4U15GghwSLUvdEBjIkP1Iu5cncRREGQKyubwoj6?=
 =?us-ascii?Q?pFjvHS4jcJmBbUplLrspinpbDhVYEOXF/J4789+IXarForw7mNZHy8Odqod7?=
 =?us-ascii?Q?1UzqgRxOIT9HuxNA4qxm9eHjE4lndXkeuJIGlqwirMd8TwRa5CjqijqkT6yO?=
 =?us-ascii?Q?/tTcLJqCOw1OrD9WQnRfSBiey+/ky/NIX0P7qh4+g7iN3yqiZQhU01FQ+rmE?=
 =?us-ascii?Q?FSaRBa+42Vz0Clg6Z8D3K98uO15sppIGLB+eRYcPVISnfe+A+hz1atd2jYKa?=
 =?us-ascii?Q?SLq4uOmaVsxoU+7acnWdLTLwjPE+sJq1Ik92TO1n1h4NKjzuRCsQGON8Bfr5?=
 =?us-ascii?Q?FIq7c5BglUycXNtUVqK/d0Xa+uvtiC/Mp7aVvpiY/ACxPa0anKkd3o1QIHyn?=
 =?us-ascii?Q?xslhyhAwHD0W95LR+EMx7XDNM5jOkfYZrFGr2OovxTC8te1hRqdQfCSMUe32?=
 =?us-ascii?Q?DpELZ7eVMfcMQzD6KnQRLmhComSBNzIFjaR/2ARVZtcose9VSJctEJ4kI9Un?=
 =?us-ascii?Q?XhY5rHwJdVLyQW1wqIRooIlhjxGKlDMqXUVYbUg4xZilEfYLTFRumJ+PsYM5?=
 =?us-ascii?Q?yKHPcaWyt7hf3ykaYLrXDnKkoi8IWYbMg6W4ZBadnTKHDUXSuFhjhtG/IkYJ?=
 =?us-ascii?Q?lEHIQf7NCmO69pIUvIkAUy/2C00sgv/HV8MiWIJy+f9RCE4UEvncpeQcOTju?=
 =?us-ascii?Q?1GWGZ0lntvBx2sKNgHE91PSLVfi02lNPYw9vabayawaPyfFEUVSZhpB0K7ih?=
 =?us-ascii?Q?RjuHGB9F5ewzyJfFCV7P/XK2spdc2++/YqY/AwCERWfvtAiv+KAJ0yWJ05e7?=
 =?us-ascii?Q?0j4QjRnHt6pWhcyC7IytrTiGF1IVk1U=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GsBCJ57uv42XgcHrJv9dTJPLFX4rkxBItk68+skdkvxcgRZRigSClibf4zCheYUBp8qrCO/++mmLtQTisxgwaY8vwt8DkbjGvE9n/oItqNX/vB92y1fCWA+3fAsCBV+TChbKGEFP3+Z5RsNXxRZT5HK9mfo451vlpgms1uqEFdsRnRbztAcSrt7ziSfJeVA/JfhPRh+m1YTyTVGILidIaDVg5+vGPrNsI0JJN8kowjHTALn+OBjFQtKf+zwiTkfOH2Q68Jmm2iJ5fgYvR3NWanAGDc9tZnndBiehV6UivsEz7GFj9lpabPZ17wTr3pBJ7CTkLl7/+CEyeuAyCIjgOGZ1dCtIjXzMXtlw7ew0SW+6k1GFud+69JOKYTpyajKhs5pTUvR1q3lm+Hln9HW6jfPxuMA47sMUwswR+AxDYphB8tiVM5Kb9LWXIjLnA/zTer3dOJu3vhEKWZhKfSvGjKtG6hidmvep/wsQA+oy7FX0+C4Noujzh1x2UH73Z3NwsWxgsq5l2Yoejk4PWXuIak8w1asTGkdd/EZrRrg6PVE5B+xBFLQZRSkCAnFwrW+jtp/zL59l/4ZhwFxVIm8s5PZmzyWuUMCrifJtx5CCwUc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1311b1ec-5e17-42eb-40c7-08de74843500
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:30.8464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oC/I1lhPAT+7IzkrCurOe9wimZuP9/KWBPGZdZee3yXn6nfcnTSpQRB3f0d42BqtI8QPlHbhQ3726VweHG3VGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f17f3 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=WJg9rLiHYWik38eusUgA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: yjRj6ZthHyvAsivUWeTj-94pNoXKgD7s
X-Proofpoint-GUID: yjRj6ZthHyvAsivUWeTj-94pNoXKgD7s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXzkw7UMU1hh7u
 8gd03YXsGSEzjGTEFjfWWa24uYvfeNEqNSOfrAo48O4zhnd5vqtScqRwFLpqxLvg+OWwhCS5MM2
 8wNWHRY8ie6OV+FtgzddEhaTWj3t50NFe2ZFOqRYm8PmiK80sAKrV0ow8MJlPM8+Ov91XcYFA06
 hYyIvwoWF/GHT1k33Ec1DUC2ueAyC0fA68tixlPUGFjx3lWznVkiv2w2w0i7yuE4dz2PUEG2+aP
 yasQmSS07nr2E6erVWklrJZgo7QkTFnPtDs8BvFE1LL1sVZWcej03qgW5CWt49FkvSQkLzIhVwF
 yTUDbr3Nv3VtCj1zjcS/+sUz0BgHAanhwJd+aihaWamChvuK2kOPcUsW7Iui4JR9raFThEo3QWN
 y0WM14kcd+ItK3TpgRLF0OSRoN6S/EzwYO/c25Jyn2fz345knziDOZdaqfwB5Lr9m0Tlr1s61QL
 r8/L0Fti5YBSFsh5Pj2snQquov67c6Ke0Q/CgeDk=

This is for mpath_head_template.available_path callback.

Currently the same functionality is in nvme_available_path().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 390a1d1133921..e888791b8947a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -510,6 +510,26 @@ static bool nvme_available_path(struct nvme_ns_head *head)
 	return nvme_mpath_queue_if_no_path(head);
 }
 
+static bool nvme_mpath_available_path(struct mpath_device *mpath_device,
+					bool *available)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	if (test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ns->ctrl->flags))
+		return false;
+
+	switch (nvme_ctrl_state(ns->ctrl)) {
+	case NVME_CTRL_LIVE:
+	case NVME_CTRL_RESETTING:
+	case NVME_CTRL_CONNECTING:
+		*available = true;
+	default:
+		break;
+	}
+
+	return true;
+}
+
 static void nvme_ns_head_submit_bio(struct bio *bio)
 {
 	struct nvme_ns_head *head = bio->bi_bdev->bd_disk->private_data;
@@ -1412,4 +1432,5 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 
 __maybe_unused
 static const struct mpath_head_template mpdt = {
+	.available_path = nvme_mpath_available_path,
 };
-- 
2.43.5

