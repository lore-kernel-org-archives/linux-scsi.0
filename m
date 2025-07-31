Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD56238C3C;
	Thu, 31 Jul 2025 03:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753932451; cv=fail; b=EK90Y9Iksd+OzZpQrnfAkUAhnTycaeDlrUohPL13CO+jXyZe3N7+nMxwyBak+Z5hdkYi3EJTt2Z7NZrDBT4vcUypIa/8Tp37+enW9NIo19ksEhPxFdOxPjipZ6YswsDosu82FDmkbRd+iD9GoSN0W2K+uQCXBF8c2qPO5P7As/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753932451; c=relaxed/simple;
	bh=y9XqrMaXlM1XGuttNvG4VWw6zIp59EySfxiIYiQBP4Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UAEuE51oX4iyYqgofoVTbTT61VgBWj51w6JF77H5Kf7WaTLZrKBcHFPwr2LxNv0PGLq5x73bearjQe5pAcz0YQ5B6Or+UgtOIEc//b9YDx6fsa6vhphc9PE/tiWewLYTT0OBkLlUr1+PjRr7UAuYHr7e+z4K07kPxJrfMhVRBdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gPDucD3k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AUDuhxv4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gPDucD3k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AUDuhxv4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2gLvm022397;
	Thu, 31 Jul 2025 03:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dYMdo7fsjBrZZS2LzH
	pfo5KqUgJ0eJPOKMKodg8fXpQ=; b=gPDucD3kTAIAGA5DIRsYJUBUrEeGxt8VHt
	DtuFLXzh7jcmcj7wfyqfRfpGZJdTfTk8hLiBgAIvDJnUHf81LZYxhlD6HK8lgEvG
	Bg3U49Oiaf1JA6cz8EkPBYpmZkzzL5lc4AHv2K8mu1g9AYIKfn9Dyz3YMQ8lwaRb
	T5fdDiALEvjXE17b+oLYWSSFQ+Z1WBFpmRDm4eeAH/1EKH5usM5QCM9X1VDeIUhJ
	JJLyc4NBL1VXl9WfSpCg1JxGSqZTlbyhIVXL8dh+S0QW1IkyAGveGH6SDHUeTlz0
	KcNgRRedczC7JvZmQamL26i3HhQkUdo8eiRiqzq4jVrNw2wHIduw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q7338by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 03:27:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56UNltHH020481;
	Thu, 31 Jul 2025 03:27:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2042.outbound.protection.outlook.com [40.107.101.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfj97qj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 03:27:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WXbE7CySxt8G05iuhIDnL5FrIfxXb1pIOTXGxrhnPZ7gN2WacVyns2/WapXa/GorvWihil7gU+u03Ja44sQqcZ1jdj2/AeV5UKYi6GhuakvmqPYlBw2Qy+mmCbHDxBGX5Yj5qDOC9lcjOg2m4eXuGc3wynQdqdc7BpjzcGNBGXGivpwYVifLF07Urid+idmfw15E/vAS876USQaDi323laghIfy+6mCFLORLOEUc+7K9R7LfwDUaOr8Ulx5DLZjwtV1iHF/q+yUK94gLxwdFx5wFUMwA4YM8vPOGU7f0/Mt8QC9EyBvVOkOva1Bz56jXWuXfKyH2L/kpueJ9vQWhiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYMdo7fsjBrZZS2LzHpfo5KqUgJ0eJPOKMKodg8fXpQ=;
 b=tGrre1Z6SUJERxQTOy93o4bCFcg12mXajRUz+bu1j5h/PrjpDZ5AM6cUfGVQ8zBjw+hNLbD8kbootxLyH7Qi3a/kOPQ0ydDfJyq8V+W1xObqrL1Xe/B3Swi+dgfZVnfjXRGj/dzfYGdqqF/EIvuZDV7JFm/yH34IC/x325QroChpDOV0oWBRtA8SLWP/Rid1d8j1+0hdMf9te3g36AoJyu0FwNmvw0VSeNmUmgnN4SE7j83RE0K8oJD2cMjpMpMtV7krmcj+oUhxCqngmRmCOj9UKpWyPKwnSN1NJuKfgFiiv3ilElYWbPMLQj6ZdlShkUiedx0PVf6GeJGS+pmXiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYMdo7fsjBrZZS2LzHpfo5KqUgJ0eJPOKMKodg8fXpQ=;
 b=AUDuhxv4XH1NzSE6000ryWo8OfgYVkiW+2QTh0ArGD9z9ZdMadPFX/e3tPqJ4zvFBNC3l6hN2/t3b/5jRpcmRi9kmgnacU6X9ivDNEocYa3UckkHL0jz2UtaWFfArgdGQexd/13FweLQlaDZMyxigYCtsO6VUXQ61MHD2zZogI8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7902.namprd10.prod.outlook.com (2603:10b6:8:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Thu, 31 Jul
 2025 03:27:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 03:27:18 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: scsi_debug: make read-only arrays static const
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250729064930.1659007-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Tue, 29 Jul 2025 07:49:30 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ms8lghvh.fsf@ca-mkp.ca.oracle.com>
References: <20250729064930.1659007-1-colin.i.king@gmail.com>
Date: Wed, 30 Jul 2025 23:27:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132E5.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: af625dea-3698-4b1d-c1b3-08ddcfe226f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?duDzH3OTTs/pzlMIukhkMqEg8ORU+LVC/nW1WLJoLwwUQVAYxtA54CYt1IQs?=
 =?us-ascii?Q?Af3z+twlr86/CylJp+ZReEU7HnP8LJVfDILjzBeH8PzbV8KZUd5/ljk3N2M8?=
 =?us-ascii?Q?ARfvpS0I9F5EMbskEoZvHsBc+hx0NxKh/FSOSRjdBqpYV7oUBbRgYfmWp6Yx?=
 =?us-ascii?Q?6x+5EHKJJDka6DflJ/lFeh0Tb4nH/fdRholPsFWcoIHsWPL2th8GnzfIQwn1?=
 =?us-ascii?Q?kJg/vS1sfxKTaWRFsWFxxOniaWU4igOEyighX/cNUnUovVixZFZKE+zMRMuo?=
 =?us-ascii?Q?1Yo773TBThaV32JLlfdL0YKsc4L/+PUfBoX0j4yWtslcG+BrFHZIdv1CNbVw?=
 =?us-ascii?Q?/ptkyd55ssUkWjIF4fK4KqIjpLZrSbJ/DZP4Lb5Ly0ZqOuQCeYWWioouAWf6?=
 =?us-ascii?Q?mI6CBCf9oE6RrkNBWpfdqvfEyEYBcJwS+Wa9uZXy9ZtYfBw7PROPA15eqwpk?=
 =?us-ascii?Q?QHpEGaHFea73B2yaa5D2/7dQo8U8+5SsAUf+dDtV11DIfCj3oJLIZcZT6f9m?=
 =?us-ascii?Q?ZB1H8DJId8tw40misB5I8tcmXkxSXQWeoZ4Dmp2Cbu+VDXQ+AjOlOpG36ixe?=
 =?us-ascii?Q?Wd6w9/T6SchAhTdnq1dFPdqjh/Az7Yx61M3hY307B7qdt/8kHKNBcmspQH7p?=
 =?us-ascii?Q?YHn9FlbXI/ElT+uXcvAYhEJIDiOchX6baklHyccy3qaEXo6F9DCiANq13zyu?=
 =?us-ascii?Q?on0YPDamIpnzT3FCbgv4XzyH8MVGcfPBnEKGDFTx+wKQKOdUZjo4bvFIZqSr?=
 =?us-ascii?Q?FB40PAKbogzDePgPytpYcPtxQLMExvkvwI//G9dM7X1+ss8AcfFrr4phAeoW?=
 =?us-ascii?Q?K8npRxsEt78fyJnRl5Lu/OY2QlWPBYXaSSlRA9FzwbyT9GGlgk4U3F/+CYCp?=
 =?us-ascii?Q?tgq9PMOOBmIkFNIzMynOkEbswv2OEzGl0rNU+FKdcvpw8iXjg0F0J5xODvon?=
 =?us-ascii?Q?y3SFX5LZtVtIixwsLYbg/6z0RhgczSS+h0H1f++UZw7a+M3oKcGdsQRtGncy?=
 =?us-ascii?Q?d1lQo3oVTLW1N6ZXDu9pKHYQYWrIc5dHV2oeSzzKsPTB+li51lOoQAGUcQvh?=
 =?us-ascii?Q?9SbuWCo2tPZB8zQ3nsCs6kwcxZw87vhGw4A+zY5WoXZ0GvGb/Pgujv48daYd?=
 =?us-ascii?Q?GL0RYkgfJaiJ0nqzMYGgEAd43ryhTHxddqDpYvsm5j3aN39pvXpSfg8MEZ2Y?=
 =?us-ascii?Q?thmjDzdjZCs23r+TyhetUcDa3RyBYPG/AYYd87F2dbMXJRd6ebNlmkROMTD0?=
 =?us-ascii?Q?+IVprybsnMINt1nRqq4RAAadEqtiHMVkXIlm3ZIrf76+uejJufjQEKNLzYxm?=
 =?us-ascii?Q?ooDuzAqIHkTWhWSbL10kMy/A3AXDLn05xoHEQFbzHNojo26u8L2RY45g4kQs?=
 =?us-ascii?Q?wJgJTUiSBx+fFMced5HczCsWcbTAHgDFlcIeYMxBhzqcISuo1UYXNC/MjsV1?=
 =?us-ascii?Q?TDXm/FaZNR0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ksQwlodYKKBdd1rrfGt5umnuWFGeBdHnHjCmpjArpAeP7zj0OOerI96BULcX?=
 =?us-ascii?Q?KIrZSX0zrcJdXYBOW6zcRhsRfXfSkmhnL0nI8rujbO12oD56FmO5wOnu4A4K?=
 =?us-ascii?Q?Z0o6GIEfVZv58IJFW9a4suwpLnZwUdwPr5jVtUzJX3bKE/gDLU29KsGKNSIe?=
 =?us-ascii?Q?PI6MEsyGwOVgxHo7kvDcQif/DRlSjHwRAQYUOOKQBUxOcypoxa5U+LRPetiW?=
 =?us-ascii?Q?lB3YbkW/AHDbDVFc2fVdxD5MT40d8TZ/gVvy4K7RaUy798Ga4lNEzA7inq81?=
 =?us-ascii?Q?lgw7e8qpmjwFBSfdVw6tKkHcrC8/pSZxM1rab/WVbnnnX5T3DWmjxL4+OI3n?=
 =?us-ascii?Q?vhJByt2OM8QkmavcUuYfjUFSa4l5Hr5Nptbpl4qn8XXZyUy8Rc2E7P6JekHS?=
 =?us-ascii?Q?ToGiHBWvnMKtxXsg/U7nTE8zDZLvS8snlDxR3PYWHg/1iuKh0kbyHDMAlUfu?=
 =?us-ascii?Q?9n47+CS0lWPmRAOQ7hEzEQfYeXlUDkXJjU0JMRsp6SDfCMS/Nn2mKlOJpCfP?=
 =?us-ascii?Q?w/T7ub0geG9VoPPaqzPp5a8eeOG8QcSmuy2SO7Is5BhDM0pbkBeQ/gWF1fQS?=
 =?us-ascii?Q?yXgRCI/+7Y5Bp64BC/RUESWavT0//aMqIeYACkBAS1XPdQGVHCvJ9PgM+yle?=
 =?us-ascii?Q?TZO8F96pokChERQDi69iaP/YcIcCJsaY+XNK5FoV9pkUzlFQ3JvOTXLwHt5O?=
 =?us-ascii?Q?w2V/7rzIt65vGR/JpzIiufGROhmS7nmlQSQPrncs8IIMCdc+aJVfELZymO8h?=
 =?us-ascii?Q?RpdfmAY7ALYlZIs8OOGdqalqwVC15vqS9+dtISd4KgN6ETxU0wCynCghm0uF?=
 =?us-ascii?Q?rYpNfdz4N00b/jq2tAlZS66kCJrIOKiTWvuoMcBzSXLI+VPkv1BP6b+GXvZb?=
 =?us-ascii?Q?GhGuyrvmquYt40fDIUYBQV2NR94CxvcwtwT+RM4Hty9yYkK4wybAiP5kT4EK?=
 =?us-ascii?Q?UBTJbMJS6ClyJnueJuL1M4jg7g6MHtYzkopcChXVMrSIcQxudQP9BehJ9Ckc?=
 =?us-ascii?Q?W08Po3ukz4x2Hm+I6JI0btKVQx/lHyDIO9hv2ZNKPYoUvSMv24ONsNfAYNcS?=
 =?us-ascii?Q?rALk08WikjSMkAO0iFheTbWX0FbmiqYKBJXlLwOjt+vZxIJF0UvoF4/nk1DC?=
 =?us-ascii?Q?Lm4gp1O4fmcZzWn5aC55QiKWPNieQ3CNpBawMnnbTRXqV1/YY1gnspGjVsU+?=
 =?us-ascii?Q?oLclacpKFC4+NxSy6n6uienyVk5iHtG4LbLsSKtHlCHGdotQfrCLvGVaUvaW?=
 =?us-ascii?Q?B2Z2VGHEh3PjcjCu/fyGCbHC/w85SYLoRxU76x8ANgjHz5lL3YBeBQ4YYNg6?=
 =?us-ascii?Q?rXsrlws0HXDYbnG1Bd1CbAIRC48V0ucSVqZ/zCWCNy3ret/mMGAVMYQLThpi?=
 =?us-ascii?Q?XEX+PaRCmYMiDMHYK4oWsINu3jDYboGPpeVsCQB/WSxbGYRNR9dWO5QBrdS4?=
 =?us-ascii?Q?jjIGDuXudqx5Dw1oaz9NJiQExJamMvcsBSB8CTXu2Zxm5Tn/IgTbnlirRwx9?=
 =?us-ascii?Q?vU8F4d9SIlgy0AARV2fpuohhROdl3QInjccVBScn8AioSztst4s12oOKvFbL?=
 =?us-ascii?Q?tYMMaGZ2pX3vW50gLX49pAArTd1lPN2Pwtsx/4ZbO1gLbtuy0d1mLEiv/gUX?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U7pMcZ/TTADeu5o7HhX5ms7reGee8NRQFtUGCsscc0U/qpOopj774t1EiGuCdBcCD8RbwrKNxcFC6W+tHQ9cgyisPd26j8oYiC9E0rZ0tOqmfu7++Tg3CwI6WuEvCef0JKxnGDzULBFxN1W4mDQQIRngiFVe1hE27YWyefGqdgqpHXrgs5j0N4OovhxgCRUHAKbxPgefBrTYv5XqEnOAMAQE1BPsF53nVNV5i3fu2sRHFqWhFTsPaNbkI3YisPRgZmt738FjJhGW7Bk9dmVs3jlhIhJL3BeACleNeejiYLv1nipCO0ynph07UdaRw1btksd7uOrUa9kVnu27+t/c4ZASyiOqa18sIGLMmgoPnJ6j5bdr2VMA4LDRH1TBD2mQ1tHmiRVM5Ob9UcMTSzAhUdDeCyNY7NiqEvdSRId3xtXF5jweN9AOGmxz0CNIuMFQvuhRrtwQ55doayfXtZqAEAnct5IY64tZiEDs/zT/EbwIU01sadLi60tvlnBlxRqZQ611T+Ep2NocnRYGG/cGV8KEfnSFpyCBvGgyImI22x4FYUoD6B6GWSxgmmWjdWkYszg8sFssGjbVSdl62q4AyY4dS76DijuesJYQ/QQWsXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af625dea-3698-4b1d-c1b3-08ddcfe226f8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 03:27:18.1079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ax5jICgZneuKfXuZGSkW1UXgckN3Bxt88w0qMbgMWv2vgxWExy1LxNVtW9VVvkDnTqaXfrqAnRKJcM8+1EPml3b1qtbyCGFjkgtey5jHoqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7902
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAyMiBTYWx0ZWRfXz9rHuIvtBNXl
 ikSRkeZMtrIe/sKI8q5EJSYvOefIAI93ZxMIyOTFsGhotAb97jcTjpPpGYXWb72sZyQiCPwBT2i
 ytj5ljpA9ps/YTQMpIfiZTE2tVl/QsoXRrdvpzn/Ixvze4+66DczwyMNKP7ydIHELuQ1Ye5hR04
 oJorawdEF0dXMAjIY9Zd/pnECqIIanNIlGJ+5r1pFmTbl/C4QTkuAoDmHp4ymXJeP2FpL7BY8MG
 locyuv/u7bPfgVO4guwgepW2UAWDHwL0ITQQMiXQtHNZJthBVScCfAwEMMTjHnzA4eDbBpeMWTr
 vwOnbI8ycfXTHwzWf/+8r9uSMyVq44qJ7ae05E4+GBJi8BLfed+msiGw5r1frQ23BUamSdOKEAy
 ChbcwSIZMqKyRfpQf1bgFHoFqqD5hATvhMXpVjW8oJTVc78iutcewntst5KcD/a6V8ziR1Df
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688ae29f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:12071
X-Proofpoint-GUID: YNCXD10K0UigE5h9__R6fnYKqRGwXi4T
X-Proofpoint-ORIG-GUID: YNCXD10K0UigE5h9__R6fnYKqRGwXi4T


Colin,

> Don't populate the read-only arrays on the stack at run time, instead
> make them static const. Also reduces overall size.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
