Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417F523F405;
	Fri, 25 Jul 2025 13:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753448806; cv=fail; b=TC9wZZ1tJIwKFVD4w709X9XzJMshaf3ZySWARwrBGMxIJWJbCCxqQYIsKyIbyBGLVKWB/FjxhHXvNDWaGRGxjNoIY2EPyqUql8oyzchaUxZSKyUHPh6+051EFnNHfUbfdCCiCIjgr/9wH1V/jmI1QurvR3vfIWm5BP6dxtB9Doc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753448806; c=relaxed/simple;
	bh=eUgBUiCpq1IfhWSMZ2zmHJkU8ixIQAZIezOfbvWH2Nw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GjbCNRdjeIcOTce8IrBa68DmVabOR+9/ZYQZrqvAJNfRyhhco5XcYISrLltpjMUnro2kyxevvk6Q3JjcH+Souaz4YtqUj7u7/Gl+DbnF6U5HhAtIbwWW6/lSqm3+O+Kd9OGm4x1o8DjTx7rhOBgAa+RDIiPz9DZc0nydT5AbyYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NBnUCucF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kcloKfBc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NBnUCucF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kcloKfBc"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PCk8Vq029311;
	Fri, 25 Jul 2025 13:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HEsCg2paV2y0eCFNPk
	vAHK+uZp2KizA7W2beoxfYrkw=; b=NBnUCucFwWhZIs1Mq/zAwdDveGH15wvPBG
	ZxeAmnGbwKKpwR1YW0PNQwq1BD/DsHHUsSyUf0yVZ+Vefgxn7oo4AqffDinsH0dK
	z3NaIs4d7BnGX79kEo5c12Ao5Gt1TmR2DjX+Cw9W/Rov/T+iNg0I4r1Wn0ajQ4pb
	c1lyAF+vtFnllsOHAcj6my/2T+wufjs4zgJ+p2l/PKl3ra7Sp9E/xFznkmC0QVJw
	g7FXc37vW/c05S/baJ6T/zgMH9L6HpvQ05QqG4O9JdCXliWdmzzmW0KAOKe5nbnl
	wsa/xbFgtVrLp8hYZGDxFanW0kFot04r2Q9FgjLHnnTIy0Ido3ug==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1jh0jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 13:06:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PB0WMO038322;
	Fri, 25 Jul 2025 13:06:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801td3s7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 13:06:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pAXT7bNuYu180MaEblbvtAZD2fPG7FQKfUTS8utnJ1jdN/LxP5iELwsFCtl9cOS4COrwJaiAcUnI+3SQay9tHyRtoW8Xp8+8MFwo4+CIpwysJm2h2uIVw6OjPInPzOfqp3xBJccdH2F36gml0XEdqRl7LTCjC4MR8bQGoGmsn2Aa+Lyy3rKqC2UaazEycgrrumzs6C2y83Y7tnlJl08pu7t2d79Ua8TEpw4TnqrUciG5+1bM1FUPYx5m65j9Iy0P5KF3EIOrlDHM0O2m2suXpauFk21DMiiSALzMlkKJnA2vFIcY4jhay1BRzdI0NKL16P8dSumbKfMy70G8IiPDuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEsCg2paV2y0eCFNPkvAHK+uZp2KizA7W2beoxfYrkw=;
 b=kSpWhB0pYinE7LwcvBmclY/QijQTe5fHRlzovaDuZlaFoW6tyNEPjQUUoh7fTUvOtaKHjrpXu6LvDn/bmalLfx3AonIdJgn45rK48z03b0IJG0oEBDLf+Q9Ts7IrO+LcFujh+KMzuJ64MC54n3DuxfVI50xkKCk4Bn7r/9CoCrhI4gxtcivO9OqdTxezUbxhvthz2JruP8enkX5piw80Y6fQFJJJms2Ttay6LCjhztnkwDhOFnhPHomPmcOnECTuJkeuBMoRvRZ4oU2FRzHs0oWQIbCx3BL/jZSKVLcSL5pSRFnen8LFphdA9OYTQXRqC1UzPo9wLMcwvGbOrWO18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEsCg2paV2y0eCFNPkvAHK+uZp2KizA7W2beoxfYrkw=;
 b=kcloKfBc4vz3EcTMFWdoJEah0manr0dtYhjaCraWYiybfOBeIBLYqkGR3p3i96MK/h8EGYtT4pSJlJSfSU5HYL7KlckYrRBn2Il2vxn3eAoKOVFkC45zVHzuAPzEw0Yo2mWYljRH2cxHSsrw/r7nnBsoynFNKluEaHsNw6C6LAc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 13:06:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 13:06:31 +0000
To: Salomon Dushimirimana <salomondush@google.com>
Cc: James.Bottomley@hansenpartnership.com, bvanassche@acm.org,
        dlemoal@kernel.org, ipylypiv@google.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        vishakhavc@google.com
Subject: Re: [PATCH v3] scsi: sd: fix sd shutdown to issue START STOP UNIT
 command appropriately
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250724214520.112927-1-salomondush@google.com> (Salomon
	Dushimirimana's message of "Thu, 24 Jul 2025 21:45:20 +0000")
Organization: Oracle Corporation
Message-ID: <yq1a54spghg.fsf@ca-mkp.ca.oracle.com>
References: <20250724212137.105270-1-salomondush@google.com>
	<20250724214520.112927-1-salomondush@google.com>
Date: Fri, 25 Jul 2025 09:06:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0003.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB4552:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c6e3253-d323-4a1c-3c7e-08ddcb7c134e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tsT8TB1LYkF6RIGyfCB4/p8CyJqeq7xICyazR8Wlk3Ojp6Ki3Y9GPv+RXnso?=
 =?us-ascii?Q?JfuKqZgAXa22HmvKyWTJvkKn0GXssy8j1F2mDbq6ZFfYb8tqXBxtHc8vKxZe?=
 =?us-ascii?Q?XrbAgdNeuPRLRqVAaZtkTtzmQgRnJCyOkZiWcSn0maDP3spgZYUJevk8EI15?=
 =?us-ascii?Q?5TKxZ49XJlT+IgcaP9RtA0aZt5/94WyU9YYiYRPnBecCZrBH5+NTSxsFaMj1?=
 =?us-ascii?Q?H8ZaLcM4pxnZfhggFo+IG8gGhuxcip1t15Z+kRrfNpIKGMKPfj8NIn/BXjTI?=
 =?us-ascii?Q?tULxE0ARTuRjtfDSQvtD8V/Wp6QAgnFl+rLizNRFME56dFYTZWMrgmznOgcw?=
 =?us-ascii?Q?CY3JI1pu6BlL5mhCeUKQ28pEE07JB0qqAdLxy/olKSbN7ymYAzqLn0UQaTgo?=
 =?us-ascii?Q?6AFa7XM9lvh4EBG0DdmNsmtlD5ZUN71NDPrf4iWxBS9Ss0F/1aNamGHgrFP4?=
 =?us-ascii?Q?I87//aa8ogks+wj0vKKFYxGAqpW955A9U5c0iBzE/9nQcPndK66tfh+zyh19?=
 =?us-ascii?Q?3qF6tWIHFOKRT1BQ4GMNnEkIamhWqr3I7IVkxAAP1TmAnp1pfTd0xPUfnhNM?=
 =?us-ascii?Q?zrxWKwNhECTSQ696qXhQg6BFaa/xyzqwntLlzubbL/fEOsODFWTRAN5Gs447?=
 =?us-ascii?Q?oWnxL1nCv4oRvkOiuIWelOI4ldra2VtJpt87LmzdeV3TPU52yThtiSTYWtKN?=
 =?us-ascii?Q?muhzE3+SVDJbTAIcB+0XdOvfnvgqn/fj4MoUNK1ZGuzLelhQz+uszonzOwan?=
 =?us-ascii?Q?l2TnWscwCDbye7c2fRvlmj17P3q9+1rFjAf1dhgUXWgMV13hR6nfmHru84wu?=
 =?us-ascii?Q?qGZ7tuOq9os3LxMYGHP0rnIz9+P4utALNpLPnMQi+OTmlfdccdYtzYRCQS3p?=
 =?us-ascii?Q?Yp30wNQWXtzfrKaxiiQNjMDiYwpt9+g2IC1oFvCPDZefi3vuzh6Ujn9wuXtO?=
 =?us-ascii?Q?rxpyW29I1SCdE6M1neMwlh8l3eZ6gsIYpEEwCnlTCvNQtHVT80Xczt1gLHGi?=
 =?us-ascii?Q?quTkuMGDm6Iyvq9a60rT+St56D0tm5UWVKNx5SDqX+oMPIIgebSlVQXjJTCN?=
 =?us-ascii?Q?8z99YqYWUY3WlwRYjZVmqL1k+RJIbjwEXCHwY7+cI54hzDKRDhXT5Okpt/Nu?=
 =?us-ascii?Q?kuvh/LVNE+igYWn0o9+E2L9PfxFGKhiN1s8v2DhSIHozVr8QQjGk/FG+Iltl?=
 =?us-ascii?Q?qwKZ1h2FQbTKtwdGGfhwLyQrI/1oVVbuPASgkfxueFswusHBW34zkoX0Fk2z?=
 =?us-ascii?Q?fQmy2IJeNVumg+9i6vbcI+8Pjgx/FgTaHvixrUokFtr6s6GKeizk3dQrrrWf?=
 =?us-ascii?Q?O8gV7vCO7QdIlrMJV/W1Hibv3XhC4XL03SGb9gs7/6GgWAQ1oi04on2w8ylL?=
 =?us-ascii?Q?tINfSvROzJtxOlxH/jwAJAkW2YokUINZOZLMjSi5ZRpTrZ+BrAlZ2R3U/eU/?=
 =?us-ascii?Q?FFuVH7OowZw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YQ1ZW2Lw6xg+0hwCBOix0Plg3m79E0JsyIhRilWRdQEliOM8O998vuTSyRXZ?=
 =?us-ascii?Q?7In3wdzGCkPxYWPTmMcjT52XvEjo1rYWcWot3mJ6+vDOZDVO2lfi6ekTj3SS?=
 =?us-ascii?Q?i3h4ZBX36oyA47mHhOfsP87Hh0iPi2gRg90dJX5Gh7CjXTSZ/NOAYpgrkDUO?=
 =?us-ascii?Q?Nm6rhXmIJGHPVqme6pn1gyk0ihx89I3GnUlsTsAx5Blse3Ksclrm9lnUQPo/?=
 =?us-ascii?Q?kixXylI0dafUKttxZHwdwbCZc71vyTjL8nYKf5PjcRY60vI7j19jfQvHgMNK?=
 =?us-ascii?Q?gXeHNnhpz6hqTbNwC7erWO/ff7WQUC1Z9oswsX3KFJnnoeiXWdyL8xefFGPS?=
 =?us-ascii?Q?YdWfp1PDJGvFwsHljCytXA7aaR2aObpTIDEw33BuASj+o+7KV+CjF2px/25m?=
 =?us-ascii?Q?aXw5HAWK0rAoaTUsRQn4pc83AxGTo0IxM1Rkz/va6Uw+Q9wUIIAtbUSi1S0V?=
 =?us-ascii?Q?n5y2SL8ibpLEJNzV4nzG2wLfs53TiX1neJoL6+y9oa3CKlJRNkCaqXu8+Bmv?=
 =?us-ascii?Q?4/fkIIzX+PfP85D/2YUh1GM+/UneRYSGdIVzT7eq2zF/jhOKUakLYJC35gva?=
 =?us-ascii?Q?H2/02cWHxOSy2XEe7KvjWZEyGTsqYpWoKBF5xuLnSES4x09m5rEpt28xmTK9?=
 =?us-ascii?Q?ycf6+wo2Mh4rdzAC8s8bTrwrAtCpfFA5A4RigfXA9Fxvj2OSMtAJhCas7a78?=
 =?us-ascii?Q?Hws/fWrnpGgJ50xA1gsQUXa4ecwtA6RClqKPNHLR+wIdzoKd159GhgnUnfCG?=
 =?us-ascii?Q?amYLwwOh+co7TiVk8rtZHAK23v1HCbI2jatF6FTKPA/mPwnE/olG6FF8yPyX?=
 =?us-ascii?Q?1okheDhkLh4d7VUznBUzM7NLhNvgeHp0xrIh+VuvfXl9Wsc5m84n4WFauuMK?=
 =?us-ascii?Q?NnsJ5OPFHUW2F7/z0F5DIQpW/kSzhbjzSh+Il9Qheej57IWKeRP2OHQ4KR6W?=
 =?us-ascii?Q?ei9vQYVHZJuDYZ+ILOA92WrUjjqlC1yBfRx4NZsLtux9GJISvEAYwqJ/sYdA?=
 =?us-ascii?Q?Jcmf3QIZoguOWa11zXMNpT5h8or5fli5xJPa4FVnXzcQvD5R1Rc+l39PSGQw?=
 =?us-ascii?Q?6NOcXd9vK6QRvo/txEgFfU92pHBBML7974Rj0i4rDuTd36C07Ue+s63ZrO/v?=
 =?us-ascii?Q?LdflXv0h3WSfPl4e7qkgNlnjNxnUItns7fKIXCBjL+2vrP6ltm8jXHTOGbpU?=
 =?us-ascii?Q?7PnC2iFatqd53g+ci5IdNu0xnSjsL3lqCP9DSHjjaia/XCrb5NgcBmlrMxD2?=
 =?us-ascii?Q?BjTRSytoXO4PbSJ+GA3wj82lJFCM3b62+11n4IPqyl8dmU4zbRHZRhlssf0H?=
 =?us-ascii?Q?F867RJ4kC7FBL2p2En4qdqDwIeZMVCEYDFsiujnpVQuIoe07CRcalIR4Ycmc?=
 =?us-ascii?Q?XUhI7zDbzvzKUcmHCrwwYpD8y8z4eBnw9oHSHRHXV4qQEc14R8uzrx7N9gGo?=
 =?us-ascii?Q?OrTC/HYMyqh70Rqa43naiQzhf+p172o+utsdAFPfTQcjFoGxRfu1FwPYhLOm?=
 =?us-ascii?Q?QUjWLJx8xsQNzkx63FM+qcOO0JcOWwB9Wpxr5bEUmGFhVzTr/oHPs6mSNRhe?=
 =?us-ascii?Q?vz8Vs6FuyNspu+8pUGrtjmN0Dojz29+N7CJgzvjzEqQVUlSL9k9qR8y/12Uc?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J9JSXzZsZfYoVl8YnsoHDfFjw77Oz+z1nttiHEfO+1V7kiuSe+HrGWq+ZqIcKoSAFu/TVQFjwMF7jqXZ9zFSm85636YN4KXFF1wuI+FPIYRcc8KqPm3wNkQcBKh3fmoqDM+0vBIwXtPg0S/aP1xeKNAVdM94LJrRHNDKKs0W2F+0fsDFEDdf/PBPa+C2b1njbcN5E65Dl75lUzIAfxFOYoJajqQgxuFQhLv/KxrmRKwGFjA73lnlH3WHw6D1QHyrgpOKvjtmo8ge6Isrued04VFypX2tvug/FyWMlWARZtZhP/0tWOUBGH9gtsPQiwL+ulAbNCg6HOOW8pEdWYNAX7w23EGhCEdpADf55jD7vbpKPCaV4d5BYXiSXM3bpuZ5KD2iAsymDShFSPCJ1HZhszH+O11IWydsD5siGVP/a4uQmswLjfjoXmZJwDfOjFz9t00D+8BJdYN8VTCTiTUiBsmR4oADs4iZb+8JhZNkmRVQlAn2sWgofI8Ix7vW1J0hLEq2XPvVmqh2LYzUe0/xZp5k/mpltRie8Ww+cqp0hsseVratgsit8dp/6A1BOREGxDCRj6/m7A2FVpqT9VXcRk8M14G7LDfJ1ZcfSbYpkxY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6e3253-d323-4a1c-3c7e-08ddcb7c134e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 13:06:31.8983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8V7Ei0ronRcytEeY1baPxaKjj1bgC31iQVg0HP9tIFqfGK9G8mTYQpguVlW+D/eYI1oUaNliV9+pLijrNZpQCZuooZyfNGQZ3I2t2dtGJV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_03,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDExMSBTYWx0ZWRfX1aysNdXOeLz3
 DEtoQ/St2CbRd7PJXaHpLP/3v/Yvy9fa5T3tU7cSgUEXJbWAjRLFlbw5d9ZDfFW5uoYDsq+QL37
 OdU21dbarSAkJDwHk32hkfsZ+fExcBZIBfP4TwmpiED3AFysomws3UY0Dk7TPbD0q2eyuVo4Qyw
 HHSMsHDXP5YUsQaq4OgDldThRb02hJ7FN2F4i20DcdCGvI1qAHSfXf331nhedIgMarKdNBnEDyu
 B0SJpMB3qDcZkZumpStQqh2Yum4im51IT96JPu4+lbypmSblbT50n4+Zg5/wt95f4i9+tSGt9El
 +j/ocvcoQRpvY1GehqWw2XF9nX2WKwErM7BF2D06+8FDbG/1wLDrD9840JJYv8dUPN0bA1JgYY3
 C6iXMYODn1CAeRN6OQqOV//ZQM/PxERd9qL0Ff9f/NFEski9OprOv1nDKd7lPSj+oV78Y0LW
X-Authority-Analysis: v=2.4 cv=W+s4VQWk c=1 sm=1 tr=0 ts=6883815b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=Pvi4vb-GGbkbf7goAgIA:9 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: lfMdpCAHdoa5FnOZysfYOvQ3sk862SH8
X-Proofpoint-GUID: lfMdpCAHdoa5FnOZysfYOvQ3sk862SH8


Salomon,

> Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
> manage_system_start_stop") enabled libata EH to manage device power
> mode trasitions for system suspend/resume and removed the flag from
> ata_scsi_dev_config. However, since the sd_shutdown() function still
> relies on the manage_system_start_stop flag, a spin-down command is
> not issued to the disk with command "echo 1 >
> /sys/block/sdb/device/delete"

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
