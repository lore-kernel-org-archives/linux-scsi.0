Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21049476;
	Thu, 13 Feb 2025 03:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739417487; cv=fail; b=XLBeUHfSItlxlAV+FPiTBacyrwH7ZVyGQfaU83Z2rknyzHbMnynyxmGpQbQxpZQlzrTo/cjhJggSVRfnKbGd2NStVOHjmKhvl80sLfzIdqeSDcIDlabZAcjKmeQ3gQPD8sgad80JsNA8bWyRDClBnDmMIuDF2Q2nXhdvJVuvZOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739417487; c=relaxed/simple;
	bh=qKhB5IfoBlx5UkUVPhzLcd2NsFJM83I3bNhohQ+YIsE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rHZwlne2h0l/3twqYo9T8JYmJN0Z0GARXtbeN5oXgyfjH6nh/YHkSS3reNHQ5+c2gJPAAKaniF22hgW/8m+DzQAYJB/a+AJP/cbq1RKxKVuzVYwBogl/w9xJvh5a3ZBOEpHqWrwDT/Xcn2skASPbqSO1td9eDaxEZiQ7DsSqKic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gjyQ+iep; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ez3y8Uqc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gjyQ+iep";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ez3y8Uqc"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1qGvZ018533;
	Thu, 13 Feb 2025 03:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=RLOb0sHR4AsGEEcJaB
	hUESvuM0WwtabSAXblDMmC2Gs=; b=gjyQ+iep67Bm84evTT/cYzbbfzRI5R3ukv
	5xn9+mdMmINZz72tF/HZscNO8XNEf7QCZMwn4x/8WE22prGidcxO5kwjBfl2/QGM
	m6Tw2ObLcZksSU09ZiYgjG0GA0o1n2W5+cqQKdGUNDjaxcrwhwZ88Wt/LV+UJHEi
	p9OECpJcV8YxynTtaVEVN0xS1Mx3PEw261XG8cnvUkEcWRkMz5g7ih9EuWgOb1+z
	EDALoZtU93+Rmd6PQixrXmtvNFYd+Vyga6tpM8OaTIIxYGnX257P9TZKXkiOF0u5
	PMUSVfHuE7W6sa0p3UgGtzWnzWTbPHEi/hgc3Bq/piMkX1qGSuCQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0q2gtg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:31:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D329Od027016;
	Thu, 13 Feb 2025 03:31:14 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqb4kpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:31:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJp92Vy37XbO6vJkRS9H8uqd53RNQ6/Hm5wQZQjYgbAs9KpPhcAD94evYibsdVq7ugQcFq0Unl5iJMPYW4dGUS/zrRX/VxBmb7ry/07Q2H9hjf72g7m7axZdIf9pUbZRqRWKL7jLhZiaHiRJyZzqMbrLFWf7HLJX9ozntsoXxqUDbht1munY68KLktKc6dcPBjq4eKWn3iQmXC3vKti+mvhBFyOimCeTDgz+hc7BJwb3Pv2VdAtiJwBoTIU1bZccmsakWejxwvNEPok5tVGAarDxhHo0lNR977EIBaUb1VpZ9Ku/HR2HZE5HQfWMfQ+twxJtEVMK2iVJfgL31Ir/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLOb0sHR4AsGEEcJaBhUESvuM0WwtabSAXblDMmC2Gs=;
 b=DwUXOSAEIi6En8W3vkdbN/q/mCDcN6EMtauqv5QIQ/UR5hDLofRE7zcChW2Z2CwSfmiF8EePoceGlkiDlzemBTzMcvbosKIWgh2eohiAOpiUMxMRZe3Lt+IchrkQOgr19Q8w7ezUEgEZEmW2BQ4nW+lXLDwhVp26zjbCRmbdJywNEa6kcILvH+zy/IfetWHrGqIL7z4DFu2rRptSdUWbUKxGHi2JoDD+Fney0qXYeHtO8F5Dr7FKxLwQh9VadfAIXyvbDV5ijfBp4owTgXeW4kPT6hVJVthAc649xIxHEh3hncTCyVbiP6/2Fon8RKCqfRtw3qI6/iw4Sbovcuu/NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLOb0sHR4AsGEEcJaBhUESvuM0WwtabSAXblDMmC2Gs=;
 b=ez3y8Uqcr4JuPK6TXhFaFYSNvoMo3VGwxO/y19SsD0OLq2Lew8xo5UYZ+jBj4gJpjkH6ABAyQT6F1qIfNs2XbA4brpjtb27Z/pDAViuWguMDpolkeVYK0jExrABRNkkXWxzMXs1JTQ9OIhfJnTJFWgDQ6XORW6cu1sUfbZeIei8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6366.namprd10.prod.outlook.com (2603:10b6:806:256::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Thu, 13 Feb
 2025 03:31:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:31:12 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] scsi: aha1740: Use str_enabled_disabled() helper
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250209081928.3096-2-thorsten.blum@linux.dev> (Thorsten Blum's
	message of "Sun, 9 Feb 2025 09:19:28 +0100")
Organization: Oracle Corporation
Message-ID: <yq1wmduttgw.fsf@ca-mkp.ca.oracle.com>
References: <20250209081928.3096-2-thorsten.blum@linux.dev>
Date: Wed, 12 Feb 2025 22:31:10 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0019.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 024b10ee-f629-45c8-c294-08dd4bdedcfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6th1Rev4MMT5SGpvhgT/lgu7j9t+bTkR5cIMrXMQY4WRh+0JH7PfhKtqvZEB?=
 =?us-ascii?Q?KeF70KrYv6wMWAGkXxUlVk+ai7rlllrKI7o3Jfq70inb0/Q07pWqrDn8gZwf?=
 =?us-ascii?Q?FCpLf9G3NYs6kUy40KvUrIuLgIOQ7d7+BJFt553uSobFMyz4nzw6d63P07Pj?=
 =?us-ascii?Q?GS2OYhjhr7MBm249NY4NRAEmnLjvyo1v+LykAa95ea384UpslHi/D/nNEAbP?=
 =?us-ascii?Q?ZD8eljeoNqK/aSkrM86cj4SQSYOqji60QkkFGgnCZGKAdjmzoPufFgIg/k4e?=
 =?us-ascii?Q?XrJoCuYP2J/L86w1AvAl2ma2J+5YN7trBkuRUpJ2n0QyoHzZn4a/xCPkSGkk?=
 =?us-ascii?Q?tVK3NYYPA6goJYP2g8EVuebYjivr2Obbni3FoHEWu8545wjvuy0DgtJlgIFe?=
 =?us-ascii?Q?sqwbizKtIJrtDIY+trmFumF0/OmduB6hVx0oLznFaNUOEUQp6uvwCS9oBVzs?=
 =?us-ascii?Q?uPVEOGN5iu6RoeUwd2PdnkzEl6IkkZR/Xdp3V7d5O3vxjPiIE5JhDaAhll6Y?=
 =?us-ascii?Q?4L+nlk/9kXO2mliIrffnWH1S/c6JOp0ZyJthyCJcCQdHkOLKd2lg7HPKYdHT?=
 =?us-ascii?Q?PuZeFCLkZc1we/b6A7wt7zACRvl8rQqJWvjMmt1RvoC0j5n8gFlbkhh6JeYc?=
 =?us-ascii?Q?2yYIYfcwDzi4+2k4YhPr44zGFEd5YEJX61bURdzR2O8K5/lsdWxNlmef6tTv?=
 =?us-ascii?Q?lZJLWYWFOaVTHsnwGb20LOrtgO/TSXkKFjikJ0kdsmno77+46w4TjYKoLIdr?=
 =?us-ascii?Q?XTmCmu0NNLoc+2kMtibuAfKAUQQeEgJrM7aiAFigaCReC5xTnHpHKI6vTl86?=
 =?us-ascii?Q?sAR0S1rwHRtdx182hkGCUX+h4+MGpBszEwjT03qMxXAYuHI8EJMUp/1B6I3o?=
 =?us-ascii?Q?spQxOminU8fg06oVZjinJOwF95WmmLN/5TCJp5VwniI83yEXp98FXtgKMvP3?=
 =?us-ascii?Q?LT6e2CFA0EmFpJEHy8kekeAz33osDWgQZ1EpNLffCZfcDSvTkBeGp+YvKFaU?=
 =?us-ascii?Q?n3mxuaVq4T90z6PXK8RvFxC6aIyOBdJxucUk/OCXDx7VxRlSUx1nbJs3jJLM?=
 =?us-ascii?Q?YM3QxWPUHWH/Rq6fHdayeHVQU2TM74EqyPf6QT61KKxWagkoPi5Gf2KSsGsR?=
 =?us-ascii?Q?I2vSw8agRgBbcwWRzwdrmXLa90w9R24OOyX2DPzOK5a8QoXS9DlVOZkxbN05?=
 =?us-ascii?Q?f1iyQuxhtgRx69u0xMdv/vKMTwVho8UwOofTq+6X83m/PZwSKHc9zqEpyL3N?=
 =?us-ascii?Q?c0rZrT4zlRbUgl+2H0hhEmFrAUKXANENLExesHyEvusWHXUhHbYok07nej3Z?=
 =?us-ascii?Q?m89YdNepPvSQ6Srb0pk0efzwSwPUZXfjm+uH49bIMrTY0a7UgaeS4fUX5MU7?=
 =?us-ascii?Q?MrZPOZwYgdVjXq25A0iM/0GDwL/w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BGPykmjqMxMw/FIaoS7q+IZA+QrQLq+MBnTNzim98d4SJxctbaXdJ4SNYe7Z?=
 =?us-ascii?Q?uECpkbPt+QwVvwo1Ikj/iswn1jX3b4h7hLLkUaKANZccTHmb8xvKBVLcJWDJ?=
 =?us-ascii?Q?F0YaQTZpCSGZKRMLb2bhV7VTufogKiYLINZFsd6l0yhxnERIJqnfth/RP0vo?=
 =?us-ascii?Q?s0pGINJXyt1BS0KRaYAt2oSqddoMmxph98Gp8JMot/x1PyIbYodIneCOj19l?=
 =?us-ascii?Q?+LxNgZRYujSvQ/fjXiByrVbNi+OkZgG7wdj+rp5SqADpLIBKq5PJW1CmKEY9?=
 =?us-ascii?Q?3fMQQFo+I8n3O5MJEr4qMoJUc+Nn5hdyY3Qw95kViAjFyMQtddKutBAr+t5e?=
 =?us-ascii?Q?ybHrGFpVaXhLEVc9LM0/Q3tBfZRJmyVTKp7aViXpv+q74gRubJZJyc1jXJUd?=
 =?us-ascii?Q?C31a1t07eEbr7Fhy9FuhY4WBJsU5jspHvuRTY9OtoFK8Qh7l7ClQpYyVoNpB?=
 =?us-ascii?Q?WC9eaHGhgE/W1Kh45JvwnOYLGHh1bpHI1KheDQv98ooRYVqtymipELXMaacM?=
 =?us-ascii?Q?Hoq5h1I3Ir/mVhbixgIeoC92KCR7YXU0/QHJPZvhDWi1e6fHt3QBoR+sh5jf?=
 =?us-ascii?Q?QNo/h3wjUDVqTOecM0aza8bItu9PQ2cLqj7uuln0bzcJJ8UkmBti2PIQVbUx?=
 =?us-ascii?Q?HwkxPaqeG4mHvmvaVtA+PIgWjO4v4kJFoe3Vr4mShhyjqpCr9Cwjw+hUYLmA?=
 =?us-ascii?Q?Cz/x66pSA/K+DuoZ/BRSRTApBf916GoIm1kslIcEVOkWgXRhfByC0QgDZ1rz?=
 =?us-ascii?Q?/F0lHKmaHLjpS5yIumH19anZXSHo7dSxFT1zqq3CoVeBiQc2lqlbD8TjPqkl?=
 =?us-ascii?Q?TfWvjYonMsAzk66akjlhGnGWyyo5U8ilvrTRweskqjQAG2UWp+uK9FfjO3wH?=
 =?us-ascii?Q?4vrSOeJsywAwyI4SeAbuf/xzbg4nqCeJvxlEaeno31GxkbdxSMcOP6cCkqlA?=
 =?us-ascii?Q?lNeyjjVnsAp4kw9YZhRZ6AL4EJAsGKutgh8AakjMNUfZeZzkroSf5xOqCnr1?=
 =?us-ascii?Q?pC1wT0nElUWR/+uesncWRd2FrsY5Tt3oU0tk2WBfo4h/Ns0g2r1A3ZLQWAda?=
 =?us-ascii?Q?g/gbNBJTCIqDEB1UWerYinrtWDp8L23IXImEo97D8dCmoxXtRkftpdtPzFOy?=
 =?us-ascii?Q?+D71FvRSBTR6r4ELRGw+WRImxig4RVMIpI3LLwWGk/N5Uj7K26yuD/+d1W8N?=
 =?us-ascii?Q?W44woooP7IkvPLfU7kqu2RlNQmdfvArKGsgESeqElPbOb7W+S2QWqr3YSJ8M?=
 =?us-ascii?Q?Tn/9CEFKQAu1wQXPOMrJPTk8qKv8aSko01dzwbnXiSf41v0SV1q799iEjRKX?=
 =?us-ascii?Q?YYTMLciU+gfQMcBg11MuBcObuvkkkUKUcvUbR1Ec9jOMiFFPANuuGtpAMDaV?=
 =?us-ascii?Q?CALgU+aoJKKj854565cHcw3ISZh69W+OOfgnGisg+o7BvMQyctmAiibVaplu?=
 =?us-ascii?Q?buw4FDGyeLYOyHugauk2jKJwp50pDtbutshU6trYWuZSuHd7lD8GFU1tcBhY?=
 =?us-ascii?Q?M9OXuVfzVl+1+0NXIzZDyX5rkJJt0J9e1SnnOnaQd6oaVdAg/xr+qpyPOYA7?=
 =?us-ascii?Q?yrWHYVXRBtUgRMB45vH9c9SAmE2UHJ2ZQSlkcaabBPEakHn7oSEYDPZzesPq?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VampmojrrzgGxVBF3pSu65Q8SCrqo7JJ5Q+lK8XFIieTxYYs51gnuaiV7Eun3bSG7IiBHIEI4SskzA8UGCYaMiDrJ7QyYSLKXcq9IAk4FNIHqln+MP38r0i1nj8ZJUoC7Lh6qw7md3uvorIJkQERyLRrRGDi0YoC4ucLnJJinO1dtOFqE8sGixq2BhAnbTQafPydfc8hWCydJStoZEY3III163no4CwXIdL+5bsJjsRe51NsXcaBYlytTui5CN7dAHqittG+m0SnlPC+8BqBlyfXvT2ezcFCpTdOLnj2OnwgJhfYMbYk14zeZbsZpNXz8jHteFgoCxCgSKr/E6DsZ3IlaREu0UvfuOpyBi9CU4iMSURxA6QaiUPAV1rG2oTFgF84p/dwXusWB+EVHyDAGBfiNu7Ri8ylQ6JVhiCA5mBEpwrvhIfWjzJGAi1BfCGvNIueUqg662tfVTirjfKMyoNania1Slw3YUf3fEJfF10TB3v3UZRXcUdBxnEy5aVzuMtZSp8QrF9RwpBITD4phB1LIsya8hUnLVnOIZ8diZpfp7gfSTBqoy+mUDjmeaXcBW1075g1JomDvdnJcX8cOUgKZIgZRFk1TVpr1rbNCO4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024b10ee-f629-45c8-c294-08dd4bdedcfd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:31:12.0550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J42JdbNYJok7KcAsaQVdTEyTg8mvTdZrwazdLiyXL6whmUG8wKP63xIvtoEptqDlIRz2pdEaFKf9hJU0V5ilSL2Uwh7DH60eE16WSnoeZ8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_01,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130026
X-Proofpoint-GUID: u8smYQD1gn6LO-fZ4rBX3TLVhhoHRPth
X-Proofpoint-ORIG-GUID: u8smYQD1gn6LO-fZ4rBX3TLVhhoHRPth


Hi Thorsten!

> Remove hard-coded strings by using the str_enabled_disabled() helper
> function.

This is a very old driver and I'm not too inclined to make cosmetic
changes to it. I'm also not entirely sold on the idea that the helper
makes things more readable. I know what a ternary does, the helper I
have to go look up.

-- 
Martin K. Petersen	Oracle Linux Engineering
