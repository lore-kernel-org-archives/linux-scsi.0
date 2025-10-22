Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18A51CBEAA;
	Wed, 22 Oct 2025 02:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761098844; cv=fail; b=kEfzUlpZ/i3uKDTIlBmVIqtDo7boAwVM12/tppnYzMOITzPf1aI0tSHa9jOtlhanW4Hd18SSOreilzOsC6kthxxJuDBqC3zZaXxlKOpQa2o4qCh98k+KBgAXoz7d2LtbxKQRwPIOjHlWGlujTKdMircrE9lrbYpeYlADNFvNPHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761098844; c=relaxed/simple;
	bh=DoKdNExAZ0/S6+tgpVizTxRdh32LOBfgCvKvJc2AKyc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=O0O4Qz8eOyzv1tqul+NQE1RMpIgaDuvdA+ok7xaKsh3nJbSWViSRMIyim1ZrQp2i3klfVbTGTLySJN3g+4hj0oFIscOJOfUTdYAu9g2C4W7c01iaCquGX6wW+2sJEpdnM61WQPMT78l/t5fh7SF6PIScUN9gR6nKYY6mwzqfkvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ghDEC3qU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cm+tY+IO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ghDEC3qU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cm+tY+IO"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMuCL0018278;
	Wed, 22 Oct 2025 02:07:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EB2xxGOUIGUNsKyE0b
	/+41tdim1U0z8JT48143PDmaI=; b=ghDEC3qUGEVGLiOnMJjSjMeBamIBdjbQmH
	duoq6OOIq0tOkySXgshnENlBlqNcnAKTnbFDSmBGKuUEy6DyqGROSVfnDNS7wjjK
	Wv9aqYCORTbEUi4ZwXLaeAcaazojPuZp30gMSvpqzDg0aoIHsNFcYjIZpg+P716Z
	lVWK+opKxSM3mwKZ83bAOpejy2SJJmdiAcvbUaRgrMebwxQKne7rKZJAQlgG5nsG
	xXHAdRSpnHSv3soU/BRV7yVZWOKTaoDdihQTaXBFjSuZ3QuGLVqQf5xyggFLNqHr
	d72ONr/HryBXij/7iJlsO+ZtQdkrhWbwnm5v4Eu2Y4ZCLvJflDVg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49w1vdntb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:07:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M0Vnko009374;
	Wed, 22 Oct 2025 02:07:18 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdtp9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:07:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4WyRoG0jB0RR2T5HdWCJ4QzmMK7LEy1Ne9bJNtcn5OfxDWY/gnYg1PA89Ti8H6keziiR0oFq6QCIKrqLZHzt0zU8Bp0X5mKq3+xw3DymrGrtiij/O6mAs9ruD+vBkc6LBDxsg9q+B7/PbRJdg+NafTxSnGPt01RQwJdNlj+ZRbtrLPy6hhca5dvuS+GDiaPysp2F7X3TgiW5RXiRlFRuJF5LDqCDpUgnUw9VVDaZ8VkMG5jkt7j7Ukg+HlOXe68k+6MMmUJQrS/7TdQnDx8Zd1VZZLAPTDi/HIqWIh6JBcOJMki4/BFY49AL5YffHjfITOdx/j40/GEXCmNR2yugw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EB2xxGOUIGUNsKyE0b/+41tdim1U0z8JT48143PDmaI=;
 b=MXbWuoDDzwMj4ov+plGdLwfZfkfaSTT8bcLLqLKIqUGQC6Lykt8vFtym/03SZ+Ln4DjI9rB9Mvsi1pCSnTLUFh/9w9ZvAyf+eJw2kZWIZIlN8D6HV43FhV4kFJbXWL9N/r38p/SPK4PHgzHEYsuN1RE3mQUvkcm9wADTJgSfaUW/0Yk3Ao2FXZCjj2W9yIZSLMS1IgUPZIAQFophTJjT9E6OZECnWyZc+ljLkC/Z/+gsOyoGwpeyKAymLPxJs/hKfcOSCKbryxhwM7DD5NsI7xrfnmfz6vxRjHgmONNc/i4LjfQ12lqx4s3quRbIJ2nZic+6eK3gDUlqKPYs8QxsZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EB2xxGOUIGUNsKyE0b/+41tdim1U0z8JT48143PDmaI=;
 b=cm+tY+IOg+ECX+S+jkrEFnbqW0YSyms7H+8omNPXqBY4EgRJP7ETFqLCegFBpL9Do0LQI0zJDaHEC0RXgQNyfv9F+KX5FKfpuEHdGWXagzNo/0I69RmNZVr9g3wFoXet2abvN9G5/kOsl0HJGh6kRuOvnYVnnnooX1S2FiqBQDA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB7485.namprd10.prod.outlook.com (2603:10b6:208:451::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 02:07:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 02:07:16 +0000
To: Magnus Lindholm <linmag7@gmail.com>
Cc: james.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla1280.c: fix compiler warnings (DEBUG mode)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251002052604.24590-1-linmag7@gmail.com> (Magnus Lindholm's
	message of "Thu, 2 Oct 2025 07:25:24 +0200")
Organization: Oracle Corporation
Message-ID: <yq1sefb4rlj.fsf@ca-mkp.ca.oracle.com>
References: <20251002052604.24590-1-linmag7@gmail.com>
Date: Tue, 21 Oct 2025 22:07:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0109.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB7485:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c99555f-dd1e-424c-2404-08de110fb944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SfzmFP+im8iL5mh9zjv5f7IK3d+h9IG6Bjb93yDwUaG6zJUuvmXUarFs6eC9?=
 =?us-ascii?Q?ovG1rwiXvnT+3SL8/3RUg4zT2o00a1yGw7OXpZbkFeSu7HTeY+5oJpqpE3Cb?=
 =?us-ascii?Q?L7c7a3Hc6hHY1obLd75ZELjXwZJjqPQi54c5cHMG5yfG8qlVkhi+MYpZ9Dx4?=
 =?us-ascii?Q?SivyR7QHlYUtltanpJajOIAO4udXwhne1YfQlg1sWppDwgBPAjCxYw2hn/qX?=
 =?us-ascii?Q?cHhya7/rkS1nVe1/nx3cOvgEh7teZKghotslbCAdacBq6RgA3YRAcoy/+YEF?=
 =?us-ascii?Q?XS+7lLH42XIuzAq4XwRKDxmJytOYT7HOTrb5OBKApNyZg2Le1LAn0SrIgQUV?=
 =?us-ascii?Q?5iOzzHLKeZe6NC8RIL+tK6KYVpAzr6okBko8GTtrpiX2CqLZxg3oV72OK/yE?=
 =?us-ascii?Q?/LILWDS/MWvkUCEFSujMxH5fzXDWjXVOUlGXx4jJX6HtYcEzgUN6e1B3HMSF?=
 =?us-ascii?Q?mVR71WMjHZKYhi+sIk3fRs3de4nKfEtCz/FgEKCE2pvnHweVJ357eivgKrqa?=
 =?us-ascii?Q?5Hs29W8H34NxuiU2J2/DQe2EJUPgZ1eIyZRMmFdnmWod3iArH3HtmfM+fJcb?=
 =?us-ascii?Q?Fe/EjPC0ySPsOz+sBPAfVrU/Z3fDFLPu1PeZKU07Ov+2SBYoHKFMTXU3Ti46?=
 =?us-ascii?Q?Db2gDX1+3c2HyL/qRocAHKFxU/bhJvmE/qPqG1zOwboyo79m4aMvblY3Vc9q?=
 =?us-ascii?Q?SPoL3tFfXFMaa8DlfNw7AiQ0bk6Y9wWwJDXQRhFHJoMzABwKH0hCpKhIfjdA?=
 =?us-ascii?Q?v6dzwmwk7KfmG5TekNZnF2UDazZU1iKGyNHE/4viE+/hUQFiZzOjMOoioNYT?=
 =?us-ascii?Q?RkOJnDb7+dolcZIP5bR0Wa3ohvuqxjKlA/qPt31EwJMylZWZiIaxZB06Fbuk?=
 =?us-ascii?Q?dvoRfsWsIGZeuvhP3uYcCcwN5ycRwG25mDz5cpKnkMdn5CTjqiVBzo0jqSBj?=
 =?us-ascii?Q?v8mnP9pWihSOH2iF0OEouOCJKEntLkeBtc4SGElzA7CasSL5KrjGvAoxR34j?=
 =?us-ascii?Q?s6DxaZjmnmjU7jL7RLkVTzDgh90qR/pb9WnIYWD18pCpqDPu78gg1UXAisIc?=
 =?us-ascii?Q?2WFuMx4275GZnsVJ6NdUB3bmgoKMiLZCkoeTId0emi1PxM5UCl4cHgWH+3MR?=
 =?us-ascii?Q?2s6zpDxcq64phO+X3SDxYlTFIaF+1eN5Gisy0Pow1GPlt/ybBs5vOsqPY/lX?=
 =?us-ascii?Q?YHqpzqT+qghdmYmfLWx46miSZs2N+O4WdNDtIvE3LdKtQW+nNKIk6xYQn3mp?=
 =?us-ascii?Q?8JS6KXvGzkXjI2AxbhcsurEgB6uO0BV+0fX3f3rHnnRcaGgAknZpOycgYG8E?=
 =?us-ascii?Q?FGE5EW/ezWm7a5QIAiadEZ1Ve+WVcrzet54mBekLrfjKx6Bv8PkXF4VB5tfV?=
 =?us-ascii?Q?XzkLpt3vlIhHAtkHFz7Ibua1N/7SeJ1Sej9654HYUiq0YYbKHCvQ7N8glQbN?=
 =?us-ascii?Q?vID6L8CYMbKe3GzvLdaGoLMGiS0aFqd0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qLHMAW5Z/6OJlLYxlvYW2kVL2GrK7KZKJs0sOJ+dLHiRjDyfe0xT4rfIUvGc?=
 =?us-ascii?Q?FYHR6MyxzkIbPI34RbAmkkMm16BBjl2ho4zWL1YevVeDUHOEVwtOPIue9Feh?=
 =?us-ascii?Q?2dFm7Igt1Xnxmdp/BKAvd8JXd3xsA7bxdB/k3bDE3Pt3OfxPj71b7Yk3D+oK?=
 =?us-ascii?Q?ANBc1d0Yv1ka9C3zO9oMYBTSYTinmuS5mkXw72Vl8DmfMSm4OXEEDaILWBXo?=
 =?us-ascii?Q?G7Oyf3D9VUqgtiH6nGvPMuOeJH6A94DozlmRyo4QFR5lS1uDNHOr5POUwgoT?=
 =?us-ascii?Q?av2zoeI6bQCqsmXXTi2CxGF5Qg5sqgoisjqAONEc+YFKp9q2ORpXdKgGeFIY?=
 =?us-ascii?Q?hv2djz3fx2bE7FbF2U7n4qmzqF+0AwJlylRjqkWMFnBXFEfi16bnmeUsgOzm?=
 =?us-ascii?Q?B0qoz+YdshpI+Xf+hifM9kldzwntqDo8n9AstnVVlBTVJtSapYCp7ck1OYeb?=
 =?us-ascii?Q?k2k3iDfB0p87P+LEqE+wvmaNaenB1xuMUdE1N0LqPvyKSJJbB4xxp1WM7h3w?=
 =?us-ascii?Q?L4ql2UewDWMqKv2VwqHYY1KY0luVbxoGeBSk77BoP/CjMyuQ+2S5y3JonrdY?=
 =?us-ascii?Q?w+AiTw53LHf7umnrHKoSG7iIOcZwO2JFkZbLQAr4w/urHX+qi/TwOOgBio4Q?=
 =?us-ascii?Q?JO4JwfCnKdNjMJXbNBaIERFNgVOaYVXrfjG9W56fk9H6PHy6PEK5midK8mz/?=
 =?us-ascii?Q?B637bue8S4gJAKoFK4XZn1eXE/SKZkMMIh35rjrucybKtI0WG3fllEu95HUI?=
 =?us-ascii?Q?I4TSpvd54vHfzJdZLvWP0AHWV9DLJLUggaT6DzSNrtKG8dpbQCqx4fu88NxC?=
 =?us-ascii?Q?aHSBeToXbCdHPPFs8NjJxy3w93ucbg1V1Kr6U1mK9HpgjQeN6zsBpLCKZGEw?=
 =?us-ascii?Q?KknvppB9y2M9k1NMwwt4nDVIV83H830rDzZ+s9BN3l2TTlZdb2SOFHmAXoJN?=
 =?us-ascii?Q?DgYezOuvhXWzhAyIRkN1jKe1lmZrQcFSyukVHhIZPk9p0NwmRV4IAw0TF4zf?=
 =?us-ascii?Q?zGZyfc+wh3svvvsenrau/sgMbRNteE5H2kc7JfZffkp/JK6ERyqcRJelx4F0?=
 =?us-ascii?Q?J/t8r4p+kIrDAOuG/6Dkyesm3gxxDSdOjHx7/Not0KK4mXh+L6vYPKOIdYse?=
 =?us-ascii?Q?WgRugaFO0hyPLym5mO2ZAv3mUBfEy6wsbLyuOaX6gpOxAMKouNkwA7axI9lm?=
 =?us-ascii?Q?AkCkQHjt4YEzx7grh3Ce4YdpHRWNOZdHJTdyGFGPMgTB0wCF+u5JbswPlf2D?=
 =?us-ascii?Q?seGX0W6oqURl239JVWChmMRrid9DCaw1gJ1S7f3TaVPf8GAfMfiY/RKdEZXW?=
 =?us-ascii?Q?D2oxA88/mOmPukk5SWaIL3jSp/jIytbqAnjii22nINF282m0D7KxLrAaM2PJ?=
 =?us-ascii?Q?QRX01hgPaJsdZgCN6oI59W68wI7ayqGh0OT2A+j3kSuUSixJZY1tJpTTZJRu?=
 =?us-ascii?Q?gU4I71EKJVm8YAO0JoVVkQhy7VR7y3hjLzlU908DEUlDOfWoZB+7vsqVNW2U?=
 =?us-ascii?Q?BNBF+utk6Z0zkEEc5TzdGh7q5VGu1B3Ipgfuutz2fmbd4M4hS6gda/xzamBg?=
 =?us-ascii?Q?ucCkO4UqF8jQZg9C8YsaGSBjHr6/9/KP4Zt94/FMkJtiaK2ZlQ5cqixh8gWI?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QAwMFJfyraTCC4kqVcoTGCEt9JlxglDBhqSotm3CyffIs/O3LI8I6k9PmEp3uIQlA4lU1B1PAjS8XwHh7bFBpsufvq5mbySGpPC9UcmIctH6nywdmxWnhU3XZnPkv84S/Zrl8G+I6i2lsSgLh12QOHimD08RB9E3F2G1szH25Fi0PJCJx8d35sIglxje0o/fZRaDIVxn3wqFkooZvNBojyNwgzjYbi98jWxCSwcP16K7J3+QA+cLRD2jq5anMXzGch7HrhlOE7fL8GRrrcOtQBYEGviyNZaXGP/a6b+RkQIQ7VXN+87HtKYWXum+jtI0XOBYNxa+TZoBPqZ0YL1lFGK6jZcJGunxB4Nbns5GMMMImFJlt4rYwVwDJv4abA9W4Ml59bHn87WoxXPanOaiYi9X1N2M90BCmqEE6uIPpx1eTDa97GkC+MA3MF4lMkZKFSKkh9yULcVVj9hDvWLnrbI52QOCutnvrrjcxuYruT9FWrxlXxr2l46LMMdgiIm6gvB939afOCQqtR7WVWMFe7rPg4roNRiPXEfUMhIyn4AHpmpHwLrOXTHWvtgSsPakqMRrYoqQlrzIwlmNsaaIyMzssI+8fsA5Q6Edbm92Bp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c99555f-dd1e-424c-2404-08de110fb944
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 02:07:16.5204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +nzRVOJ4khfwGPSM63s/Vmgf+RcE70Xd9771XpmcJJLj+70zEHXuykeXFNnoZdzyp2PKtKtLB4JEH+LPZiJbBv7X+bK8GXhrl7pPKnJU1R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7485
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220016
X-Proofpoint-GUID: IoDcDP4-BNgGalQ2KF26KmNWtB0PCNST
X-Proofpoint-ORIG-GUID: IoDcDP4-BNgGalQ2KF26KmNWtB0PCNST
X-Authority-Analysis: v=2.4 cv=WaEBqkhX c=1 sm=1 tr=0 ts=68f83c57 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jfJTal_e7__Oh-KtVsMA:9
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDEwNSBTYWx0ZWRfX1Pylw6PW4Mxt
 GyZrYlDRe4G2lTp4TZNuEnE6OACRTNmjhCNJp3Gw72ZVWoK37sv+4THbwf4GnmWjJMNoOXkhB7b
 /fUYrtQF5D+NVSYe1qNY/Me0TAkqj1oBLK9h/0Gj5o/YVHbb2fTUsDsOWgk4jtiYP98uhhrdJRJ
 YRwyjCQ9HlkrMcSaqCglHd4RV2Att8piWhdGNilGntOZE44gMhEzbM6W4R/+jNASpXqmc8MYP6e
 DbUFk+n80zTuERvsiI5vnpX8MpUwIlhBWS4x87RLU2+7GnJbf7xPd769FPysQiIcLphyRKe+2O3
 U9df5D1oc0WrGy5azP5DqWjLKMTED2yCpVbwiouem5AsbK1KHsqC6Wmtoa0ZP2nU2I6jFwdhkcv
 8Rz1ZPPS3UpYiRra9oU0MjDcyDqEUnlrsuc9Y471PuktfwtLzdY=


Magnus,

> Building the qla1280 driver with DEBUG_QLA1280 set will emit compiler
> warnings. Fix some print formatting strings to reflect the correct
> type of printed variables as well as remove unused code. (static
> function ql1280_dump_device) in order to avoid compiler warnings.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
