Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03olkn2024.outbound.protection.outlook.com [40.92.59.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D863C2D;
	Sat, 11 May 2024 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.59.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715440268; cv=fail; b=SITZlD2xztVP1G7s0yrl+TWq14tMSr1222cRwaYR35u6UgiO6nJpNyh/3Ng98VDycR9cUjtsoFvPZLPAeITrfJkbPZIzHua2RUXhZQdiJHrvHqW9cgtJWOfoXadOtwwGS3c1J6xoWdl5u5Drogrci80kJX0lbYyoaDtAeXxUByE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715440268; c=relaxed/simple;
	bh=+MvwVtJogvphdZM/xV8NazZhy84qK4LTApyiw+CWQ7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KqSJEAEZCOfjw8wFh5eyz3AXMzoTJno7z10l5RKeS4lDVUIpKsuBJA9WiS8Nbl8pYrOPVKJfByKFe1q7h8q5VEFG9ZalhKD3pMSDldqul4Nx4FEPfITY/gk1DMiTzfQWudWGedC+sUJ7wt7euNS6pkF8MYxhIO3WkQOWWa+qvFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=MrpeF7jY; arc=fail smtp.client-ip=40.92.59.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="MrpeF7jY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJp1ccQxmdCQtSKMmRzd6nhykOh6vxpxklUAlIqOMd+HGOVJammd8tsEyLEnEG71Bw0AzNOvRKTOfNRHXmRJH5lrigUZHe+yzcXwNnSUheWaN9rjx8xMryG6BvB/YZg4k2krFQHJpyDoe5G9hRJKEcKJs8w/6KnH3iLc1MeRgJz/clP6Nk/Q6yB7EvVt2gXIPNBzFEUjPDpIjoWud7Rc6+yy8v3+f2bJAlloSnFaxlW1872OP+CrzNXla+uVRGKFQ9fdzIgyuTmk0svt/sKtgYKObz/pjA+dA4Ws0BWxK81GUAVz7R1+UnfzxrDuEprho/XWiLqsuLzcamxCCejLdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APNsbipS3MR/xQiB/dZvak+95EDhqhKua9o1KaL1010=;
 b=bqk3EALKJO5ZItvs19La2P1rajARD2mBuJHr3VNu7coJp7h3feKZ2LTP2h4JnY6+KcgB7xmWc06A4ii2Sv9wvSCXJ+QXMHwKDRZdUC9Ak81BOr9m+0vX/kmDCo+BHwokS29anFbtSJ2szMsjRZFNuYNlpv7hHcb2qgpYtSCgborfKtfSqnR9nP/o0l4B+lXY0yxFVmhitXYPiF+bD8m/tbPfxo7PxgvgWGtkAkpzoGGy1DunrxgAWYmKtZncNds9hufTfN3Q4fWA1KQhptllWrTPO3QVGe7Np4urcGq7KqrhISfjxvuy1dLF5ifyrqkc4wD3a0KOQlOSwrojZYD+qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APNsbipS3MR/xQiB/dZvak+95EDhqhKua9o1KaL1010=;
 b=MrpeF7jYlwEXkLgzyS26z3J3lSLmlhKs4vR8Imuot3mCKrMrfu5hf9ErCS4WjwUk5NYi/qmEaIVmR8t8PwOgmqx0ipY030F/53yu1dSyj/OO63SZjBwxY8GPhYQJJAFb8XshZ5MMj6g7R4MXZUVPd6WXFptrhBHL/R1bwIJpma3SfvgDUh+kkAY8OBWtVaHjNCgPfNS54LnhytR4j4lrRkgrxJipd3MxZQ0nGEC1XqfKoJvRydwlZYzZm5JXjqnPVp1S4+x5zGciimO6hkgqfOs2T1dRVPgGRma+jKDrvbiBDZTmgBiI8IDLtvkpVE5E8kLeuuUFfJpvqCl2t1EjsA==
Received: from AS8PR02MB7237.eurprd02.prod.outlook.com (2603:10a6:20b:3f1::10)
 by PR3PR02MB6108.eurprd02.prod.outlook.com (2603:10a6:102:62::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sat, 11 May
 2024 15:11:04 +0000
Received: from AS8PR02MB7237.eurprd02.prod.outlook.com
 ([fe80::409b:1407:979b:f658]) by AS8PR02MB7237.eurprd02.prod.outlook.com
 ([fe80::409b:1407:979b:f658%5]) with mapi id 15.20.7544.052; Sat, 11 May 2024
 15:11:04 +0000
Date: Sat, 11 May 2024 17:10:59 +0200
From: Erick Archer <erick.archer@outlook.com>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <keescook@chromium.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Erick Archer <erick.archer@outlook.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Justin Stitt <justinstitt@google.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3] scsi: csiostor: Use kcalloc() instead of kzalloc()
Message-ID:
 <AS8PR02MB72370F5A84D00516875AA7308BE02@AS8PR02MB7237.eurprd02.prod.outlook.com>
References: <AS8PR02MB7237BA2BBAA646DFDB21C63B8B392@AS8PR02MB7237.eurprd02.prod.outlook.com>
 <AS8PR02MB72370EC6DA36600475300FC28BE02@AS8PR02MB7237.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8PR02MB72370EC6DA36600475300FC28BE02@AS8PR02MB7237.eurprd02.prod.outlook.com>
X-TMN: [PGgX9B1HpfuQg3ManIMjR6L7kUc1xxJ2]
X-ClientProxiedBy: MA2P292CA0028.ESPP292.PROD.OUTLOOK.COM (2603:10a6:250::15)
 To AS8PR02MB7237.eurprd02.prod.outlook.com (2603:10a6:20b:3f1::10)
X-Microsoft-Original-Message-ID: <20240511151059.GB2460@titan>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR02MB7237:EE_|PR3PR02MB6108:EE_
X-MS-Office365-Filtering-Correlation-Id: b76e181e-6357-4172-b468-08dc71cc924f
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199019|3412199016|440099019|1602099003|1710799017;
X-Microsoft-Antispam-Message-Info:
	jkvvt/DjX7vBN2Ujf9sy/bhgfaR47go2FKoC6+rQtvuXkM4cotGwwPntMQJ0spD7APns1nKuaLOVG7rH37I9efxoTJILxNeO3RCUbAV2nBQ5QgrutQuqMAtYZLae+YS5RV+vNvDgoEMZdZ4d6qaLCE7IjjU+7yZBjtzuIPssV2AsPWfM5QmlPGlZ/TeMfGtXmLg9OJ5pBgTNGWn4h/gnmy3kUQeVSGJoUiZArjFs5ud3gMDPPkx5v34FvAwnE9l0LElA4TKPL+YuNJ0Q4eA66XoHK/sdyArLvJMlfeQkxIyjAfabBENkQwKUEzIX26mMrQMxz6LDBGQ9e0PQiabHBEdGwJRkFI3y0h5JxeI/xV3hIuf4+ZNaaGjhFc4QpbgGvXG4au0tIGSeZYht71zKDqvjPhPuZ14f15/bY1kLptaMIvxuPsXNZ6BJFJM6XOKWgDTEUl8gXNyHcf90+a65PYHkK4DJ+cl3WdLs28G24csptzYonru9EWdVD3fldM8/PHO0Fk0rskfw4VDbcvjBNLon8h7d58r19tqi74MdlrptGBcnyeKcsJCjtGiqeh6kfQPKuujL2P7bbPKeFvOxzh2bsaAzqMWYBMfrhlWClO7CqlyS/0NWOTSt4kmxjjW+4UVqlGwBDZhd8IIFqFB4bx7StDuv3xovccwROj7/tlO0u9vKvtbx5wFsA1TD0G/d
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?579/V7pClEHaz/gSydEhbQKXQsIX+hBisQyd+RBz4zzKL93Rr+uyZRAOErgO?=
 =?us-ascii?Q?4pUlO/JUt37MC9kPYM+nzTBQ3pbTFmh9bP2BOgnR5yRe92uToUO/aJ8KL4lC?=
 =?us-ascii?Q?2TitEKg8OreuAK+QzJxMsrRLZ9lXybG7C+TAUOq4xSrF41Hr/B+b4pEPeKd0?=
 =?us-ascii?Q?/nsBNg3whOAi5YsvHKTrjc+vzy8AVX1LFO3OhC1PXfPOBgpghPqVaoD66csq?=
 =?us-ascii?Q?hgjbY2fv9znBuUt9XRsqcNPfLsfld8Q55zdvR6X3fXKkDchu2FsDNaqLzQJr?=
 =?us-ascii?Q?yiQkHIzKzpfB4olPZ7Pt5vVgp5BNp3d/fPSuUAJxZK8u/A1TW0cLGHd3gfcJ?=
 =?us-ascii?Q?jQi0TdWT/zRLU7OeQdSM8qKfVLs/rMMWGc0gRY/gD/xpMSWu92ASvCBz5og5?=
 =?us-ascii?Q?jPdGuAAf3+qVmf4cCEka2BYCWZ2H3amBezeysX6a+Ju7F3ITUC9yKnLmHryR?=
 =?us-ascii?Q?gTCUEE9HCHwu790G/aBjq0ikwhHdlBAV1bOWDPFEB/oduc8mUhEZ1BKZe+Ml?=
 =?us-ascii?Q?MQ6+8fSAQpCAVFjAvyu1kxU9MqDx4qrdTR+4hKxFaGz2jusBSq61DTd+QuBJ?=
 =?us-ascii?Q?5+GoeyUd6lNyMfoKxsrAiVJSU46JfemSIx/wVp7gFqhjTqH/FtYwinlmU2Za?=
 =?us-ascii?Q?dCT+DqkzrHhN2yoXviAYFIOT1gG+M7V3ffiYEgBwOyJSy+FsQVxWueDyL3lf?=
 =?us-ascii?Q?WaqLNRkhS5iI/I57P9//LKVH6P+DGxxmRFBwSNtOyVxWbA/Ol0ZJpVLQu3n7?=
 =?us-ascii?Q?S7+HouVDMqmfhbX1bdfey31grZlQXU1X9ayNnC4lAVP4dEMBIyjY7jAAZ4BK?=
 =?us-ascii?Q?4DiWPzhja5djUOkcj7QBw2TCRXxhBBDJSRQoxfYlPJOV1O4OmDzHThioG0TQ?=
 =?us-ascii?Q?Fi1gqLXLdE5xATIMDsqJjwKlzzf8LsPSGTFrYrxCk2zivpRuPbVwbfo1eznv?=
 =?us-ascii?Q?qDMIksMJIV5iBeMkwYNi/258oJL90UJu+DGR8XOZbAddk4w9kW/q0JIVf5/4?=
 =?us-ascii?Q?nng0riC524dxPD/lHQnWg8J19zDe8TPrYu604rKxjbYYMS+lFRY5PowW3NLZ?=
 =?us-ascii?Q?gPHMJIAzPAeVd4LAqwDM3swqizjbvx7wcHGnwxSGH8FLjWXvhUpKY2LbW0Mw?=
 =?us-ascii?Q?PFp2kclq/VSrg64rB4LiyI7Teiom/HaglXAInANoNmj90tiZfQT+Otme+BYs?=
 =?us-ascii?Q?fvIhMsBuyzuKmkDCbdoX+6mkSGBSNhiZnj1YGCwHnA/cVndJs4Z8+tWktyju?=
 =?us-ascii?Q?blX4HVciNAdTrB4wHOkY?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b76e181e-6357-4172-b468-08dc71cc924f
X-MS-Exchange-CrossTenant-AuthSource: AS8PR02MB7237.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2024 15:11:02.3444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR02MB6108

Hi James,

On Sat, May 11, 2024 at 01:18:46PM +0200, Erick Archer wrote:
> Hi Martin, Kees and Finn,
> 
> On Sat, Mar 30, 2024 at 05:17:53PM +0100, Erick Archer wrote:
> > Use 2-factor multiplication argument form kcalloc() instead
> > of kzalloc().
> > 
> > Also, it is preferred to use sizeof(*pointer) instead of
> > sizeof(type) due to the type of the variable can change and
> > one needs not change the former (unlike the latter).
> > 
> > Link: https://github.com/KSPP/linux/issues/162
> > Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > Signed-off-by: Erick Archer <erick.archer@outlook.com>
> > ---
> > 
> Thank you very much for the reviews and comments.

Also, thanks for the comments and clarifications.

Regards,
Erick
