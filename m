Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6716A1519B4;
	Sat, 23 May 2026 01:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779500354; cv=fail; b=FMHsPjYRlh5uYu9Rgue9ziZDxP9FzS44tXnUH7btmb230js+H8y1iReuPENGr5RSlz7LnhZfgccOFOJELLFyLbOXEz3nsfE1ieOgsbcr56l/0gHFQRUP1czokJWZOfvQlaJUYG8mA5mH+EnVcT4TW+ISRui7PWSFawhBgvvBh0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779500354; c=relaxed/simple;
	bh=vdwtcenhOx1qDgiGamhnE1Ufm2CBqqUwZvaUUVovb4w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=h7fF3PQS/yUEol4Lnneg8F86zRT8ZJieosL1BZs/JHc8DebSfykmsaetCPiu/0gfAQoqClndCr9wZQCFEk8xXs3b7Ry3CDVzTe13kq1eo6EIzbwJTNm7mxiEdLo+udr/h64h4ikJ1qkkpIOGC4PwSFA/E3AYmYfI7vczbwZe/uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pLnkeakq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yuOgxIFo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pLnkeakq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yuOgxIFo"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MNGPKN1531598;
	Sat, 23 May 2026 01:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ruOomYKa9HTOpv+mBV
	eb7R6dO0Enec0jH6FmjwwTwF4=; b=pLnkeakqfXx7dYhukU6sBkyRJEuLaTS4QR
	FsTOPp9pF/h4qXTeprS8F2sc4Ww68FbYP0rDh1b5i/Krqm1ueKG6GPUNTXsK5um0
	rZ0FHv4kqau2FysmTV4VHPbKjCNmGQq2kmh13KRDsDU/FM+s2edg8sKazM0HufQq
	JJ8McvGwRh8kH4e77qZwpNwyqn2jIbdwbqT1U6jdOsXLBj5Ca53CrcymdU4kIx/L
	jPZb9cRHPw2lr3xmqnOjLsHpt4hMByFKYQtz67SntfiR6vQyD4fK67E4gsf50TBk
	pKgjdcn/SgpIaQqiTi3La3CedUw8G7qOPhLB6xcF7rb73hSQi3ew==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h2cuy6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:39:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N1Yd04036996;
	Sat, 23 May 2026 01:39:02 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012011.outbound.protection.outlook.com [52.101.48.11])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6r2s6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:39:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WN7Rw9nYlof+xab8HQcuwYPcV70ts0kFMfaqljybEIRegHElJq2q2OK44DGOSWaAiEUbqwMNhx/Z2bHzeUDcPxfMPIQUw+vqeuJHtr2KoyCm8H1mbeHzDpE7PEcH19TQETGJcCaHTsgsXrCxu9Me9wTg/dJVOAb6WxRtAhkrJecRjJIIXX5k/9rLruNzKwGl9MVMcPrOKVSSsSUd5B/VSbxdGm6x8tpD2aSlmrzsFMNLC8FbDjZSrH4sbBPifjB83KzxQaveAgzVSl9Uj1FuWZLbn/bOaVY2DKymNnIisPV1ajXstAHGDkBjNaqZQvbs5bW8XQsDf4/q0h424RdfUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruOomYKa9HTOpv+mBVeb7R6dO0Enec0jH6FmjwwTwF4=;
 b=CiKoQjQLv6VTYNFTe6aH+tIgM0zlRbPRjeDNf0q0IQEpoSIKuSNsdnR0aMjf24FcAu8uiJtXcsIuyqL0mqsE8LmGDlwhGTJIoIU9UNxXcODd9wA+psNnykNCFkWp5SQZI0gNl0u1Maf7TOpPFnfOfF1/2DyLY+iTkYy0+Xamo4So4det4fQ0Sw7Sut5U2gOf6DT4d/Nq3GiSN4vsmmtDW9TC3ATZJvWuJiov9oIN+mW53v9mf3U7BW75F9WKMovd4jruVo4rr2AjRI6h7MTcySCBEuRHAjlLlvPwFF/RmSS2PcGoml/Abdx+zNdl4OY1uHdm1RRdb7kZR++9X0SoMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruOomYKa9HTOpv+mBVeb7R6dO0Enec0jH6FmjwwTwF4=;
 b=yuOgxIFo98nJjTuSDUqrjUFBXIPetg0m1L0ryfhrs0A8F6crRjFPEG/M+IKpYfLGCI3M3/LBApIy0e1zw8zVpx2O2pZSFSUKWBjqPQn1Jpm807VOXFLKI3uwnHk3oLwYbCBNGJpRQj/DObWlI/IMUVUFH8qm+4BnXS+HWKA0Dw8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5560.namprd10.prod.outlook.com (2603:10b6:806:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Sat, 23 May
 2026 01:38:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 01:38:55 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Bart Van
 Assche <bvanassche@acm.org>,
        Kees Cook <kees@kernel.org>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid: reduce stack usage in
 megaraid_cmm_register()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260519202143.1305850-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Tue, 19 May 2026 22:21:24 +0200")
Organization: Oracle Corporation
Message-ID: <yq14ijyhplq.fsf@ca-mkp.ca.oracle.com>
References: <20260519202143.1305850-1-arnd@kernel.org>
Date: Fri, 22 May 2026 21:38:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0305.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5560:EE_
X-MS-Office365-Filtering-Correlation-Id: f0a80a1d-4c4a-437b-4059-08deb86c0d76
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
 1yCqz5dUOzCABk7vIBkrcKHeTGl+Y9wSD4gcz7/yPkhRUEwIuAN2+BGMBnsnS10OYeptel5DmlK9jXOhJiC/quJOIrz9OYZ8x08Wi0Nn1AtiNkLCcqXthIdodKuaRdvrt2p//Z9e9s9aTIUKpF9wM+6JCSN4sII8GcpSvJpYexw/zonyEHfdI32c0ce/xq/FCGe9IYviY/oMddi4azb3nHlVRzfEOaffkdAflzQx2l0ui+ROGYdWc5c7Vxm3/LBG5BeRDlXEnqsAF8DB7mNoVtpb88SEJvNnEP4jFuVrl/UuIjI913ThHfVPGC8A2Vb2MBKyU4u7Tcbfefs+rQ2W8ZWm1uVzS+ppeuFNPRSGDf4QBfDcX7J2ejRWLo0dw8CyKI6HxZfRapsZjj8lO6dD/3Wsvx8SVCR0yhxuzBGd1jxpuUjnvi4ax/zcYPZwAj9MLHwG/jbEbPLPrrM9+IqFM2fUxsCOdmabTZlfomgaaVKRLNzyf8RdxJ6fx6oPSaa3HaNKA0c+H38bnx6cOV8TVmb2llS5Em5rdkE+Tmih2lc/7M2yvEVQc+/8R/t/6MYUNwgCV+XVGKBTYbwxDEswNHkP3XoS0wk0gYRaSJiy5aOzGMVQTXoGpd55qW2eAZdKWsD1Sydad7IM4KQ9L3OfiWHTwMCARvQfN+P8+yJpRs5zEXpFZqHY7cKzPD0farjx
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?4dj5vzQXR232scDCu8a8LYI/8EJVznOomZRDxwpAo+rTNqFoOFynWI6Oojoi?=
 =?us-ascii?Q?1cPXbL7UOoXtSyyuYAEZsqVpTd+ku+OZV4Y6nlHveVJtlhm3m/pcy8/Eoxx+?=
 =?us-ascii?Q?dtCLVLQ0zq/q+cG/354FxqwN/QFs4sLuFf2JIn0fSIe3V/4PHcdD9cGN9jmt?=
 =?us-ascii?Q?bJrLZDf8NOv7xL8FkLyk15UpKhsb/nbHG9eGnsbM60X+qFih4BS1auexDhUy?=
 =?us-ascii?Q?kdJ8qA3M0mK6X4Iaubt5w+SO3/1iuuV7YcFNnSFi2O29UVVlu1LHUIM2ygDn?=
 =?us-ascii?Q?4nrQTxCfHaP3XASn2Ly0NxA0qiyRRe/ysAQmeLJz8hDPnCldOnIrCUw+r482?=
 =?us-ascii?Q?3ZzNHPbXml9nAQbq3zo7NcLIO+k2daxGoE/Yfy51d0AwXXPHpIMNqYO8IYYM?=
 =?us-ascii?Q?y3wOwkoBr92DTujhmgmDkfsAPLraleltJtfYCId833AvmuEPdIt2OaWWxog3?=
 =?us-ascii?Q?h6QR0th8lak7cmdYsSrlEnuOqRnqLVLycDJhNLj+HYb5uHZqC+8i7mSk5VwG?=
 =?us-ascii?Q?Oc6bS8NpXD70g1Jg3O+0RHEgVLJMMLALmhe5nGfOSkwGtRnpInA0jVviyGP/?=
 =?us-ascii?Q?XMwuRDTm6TuNRBzXl2gx2I4GCnSkx7J9ePsPxX+7lsIAaR0D+MWaXYppLFop?=
 =?us-ascii?Q?6kPRtqr8TIf1XWxrMA5RrZZ7oks85cTGcf2kM2fQN12QEwCgQVnuuKwmT5sS?=
 =?us-ascii?Q?M0/XDDuS7zlnDTXs0/3uRNBRca+MhzVozx8xWWDA3wFacF7Ys+KK+AdN2dKg?=
 =?us-ascii?Q?uEbb9xng1mUfCGo/X/6gzauNR9o9tsLlReRHuI6MpugbaReoNZxs7QfjamFR?=
 =?us-ascii?Q?Qm0L+fzRy73f9xpml2ArE/aLVS/vbtRGTMiyUX4NUxgCUCnEH8IVUXonGXiU?=
 =?us-ascii?Q?sDjuWVPbWZY50EsjFXrazh3YG+j3sUCIZ2HU1q6PxxfMcVftenP5zineF6MP?=
 =?us-ascii?Q?q8uy/Jg6lXZEkr9jRxHYnna3tcaQAKjgND1jyTxaO0XgBbQrhVSiHW7qDQZ4?=
 =?us-ascii?Q?50dNCcoPqVJOd9NSJ4+3mlgXPgMMCxwsvUHHPKqJz4xB+w2Hho01w/du8TXZ?=
 =?us-ascii?Q?Z0ajQjMfC8B1iIc5+WFi7xV2+eYIiVrCQGiYPYbgigFLj4ndu4WAvm64ZBus?=
 =?us-ascii?Q?tQwP7BZw/AdRLlVrsY13gODAj2kCtOrdfAfhXO+ougQpMmcuiGEraCk3VDWf?=
 =?us-ascii?Q?IFLqdiBReC9FMvtwo3Mj40PC26KRHLxMSx0fRzu7TKGQsLbephkno73cvOUz?=
 =?us-ascii?Q?fUvT03ydkTFEJJlGdQckuwKQyEax/CTjCFy6YInw+zu1YVlDh6aHejz5TBYX?=
 =?us-ascii?Q?DfuT/NR8qO0rcqa9CDdN/4+60F/48tGT8bi5d9z/iJ9CKFZKrX8DxGPtMKYd?=
 =?us-ascii?Q?Dp7WXOA8ITPmFP51tFDCkU1sPajkeKTMYYrNosnYq7yIyH6LJjFCGGm4DKeu?=
 =?us-ascii?Q?Nw4rgdrjKYrN9uqU3qOVJKwzrXWlckcjGITfDgBYgX8IMOR7+Hcw+HUfGYit?=
 =?us-ascii?Q?B8prJnWYAfw5zyDEVrLNJtbweHrXL2R8juxzOil4jX1INWrmVHIzgda4Oz0y?=
 =?us-ascii?Q?78vluAigGNc1V6z5gFX+W2p2vfKOHts/R9HwlINwC59VMm9S8TTl/qIYwRuM?=
 =?us-ascii?Q?jg+6GTSx6tKlKTlVRcTZSPuh+IwqSiLI3pDUd1/cwTmBo4l4XI2QJpNiKob/?=
 =?us-ascii?Q?D79mueoq5cbqY0i/IZgdyZzmfNm/ZTquUgwtlc0XM/icsQi8CjlY1K0caqed?=
 =?us-ascii?Q?Ojh9QGFZ+UsIM2Y0DSIGS6vVBHVv5RU=3D?=
X-Exchange-RoutingPolicyChecked:
	OR6Hfa0rCp2pedzqETtJvD+8GLxXCVVFAst74PMv8H/S2NQpyIISPyHsobEkWZP2i8nFgNUFQj6KEsj/zhKDBwf8oNuGzTD9sWrik/sYq5U12kDyqIcUTJiC/Kp+VurecSTPBSP3Z57itSMD0x9BsLd9+0eIR/cJgA+rPu3ZZziyyVfuQOC/lmqvJBbHPemy8w5mpYGYTjS1yBHIDhnkQ9JMjx7MPwMD7adiXVNAOJg4Io/ARI6phtGAi1xGs0yaZRjkaTHNw/mm4UhXNF+ILplhCpn9ggarI8X5snM3NCpT0YYrbcpO6dkslvzz7X2I2/Ymg3bCLv/2m5j5x0Dxzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dXmfn0Z+xJIMMg7gHgWPOe2H0aJfgU9B+1J4JRwY8QaXg41Bf+mYFj5gHD3FtbW6IEWU/uthNnfxqMyd8D7jwtmJsy/zJbB/ML2NPxZOqbGbNnbxC3zF1gtmGqG8ltZQ7/s2i8IPC1frvCRI+GSfQEg39rWSWkhiMINi3Nbhqa1cBwpGqrA6OAij0BirdAzzgiUXaoG9AI/Y9JAk91Yu+NGydQO7uzcm0izaW16vDgoo2I7x/SikM3ut2LK3gQkifpbZWbcISu/naMeXR/TNfN4QXuGNBNkbo8tC+qAIsLSwnz3rMchghrJNWvv5xqiJhZoXH2oE9z1NfdIWdlDeK2xyONQJb2OYRniH8HJhaZZJP0Pdf+16oFQfZYZbUQcdFeB14nuIaR7tiaqOLd31hJt0O7H0UWApqZMEFCl8Jjf2uEtOxm/Ok5kVpfepFv4XI+IvFEYHdE5gkJsNqMocIZHCwKXQ7H5aFhUjUl5Ki23VQfzEf0uIU8by9ZJ6K+CrJSBimHpuIF+UDvI4XrBZIIGce1bFVcSZw4lRt003s1F4+wzHpv4mzUx0i1axm7oqu0sG96ZJ3Xl18qHh+42omjnkT/7W6Rt9n1zAwriweLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a80a1d-4c4a-437b-4059-08deb86c0d76
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 01:38:55.6445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1R6r4See+o+mx0v7ajOI+vNiNi5oOPcPj1hphhsIJdhe0CftVdvvPKeXXQyIHWQCAd4z5PSOrRHIHhvWaEU8ZtULHRMhIzdRSlqbJBSHU/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5560
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230013
X-Proofpoint-ORIG-GUID: G6cYtQi-SRsTHROU9079RoVLjCHzG-hc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAxNCBTYWx0ZWRfX08kvs2h0jMks
 Ftte1Zf8zTMZtABx9vY0cuYk93VQROADSuh+TNFYj/a21ZJAwhW0dlOFN7td+y/AhBI6gbm2Suv
 ir5DJrL69gch4oXIyUnrbqLgkBAy0siEYVKMvYnoMwbszbW/4duUNG2uyF5tH4hzztTl+mfRvqZ
 p6eXQuJHcmL4WcdQbQFyfikXwRVn3ct1kSUZxmzXsrx5Gt2T7vLvX3rHozmGhG1kuF34qyLKBWb
 lePYPSJIgOgFjxEG8djTMhA8RSucDVlyrqlClsLaok44UscQoQd7SlqSyBl3bGM668RJQgCUg93
 IYgpZ4BdTHqQzBSgJXOD82zdNUv+8NBeT/tB4ZkLv7T6VEnmiXhs1qKONpTg5vWjqi4hXG+OHUs
 aUxbFuDxKYbMa5mWoOJOuICyamRWlkinGK+zMADdcv1NVbrwURFoDEUgAuiv3tirop7rWmQ6F2l
 fpBadOcO84VY3OInAwg==
X-Authority-Analysis: v=2.4 cv=Ws4b99fv c=1 sm=1 tr=0 ts=6a110537 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=hOTvdENJHGiLUBbRPrEA:9
X-Proofpoint-GUID: G6cYtQi-SRsTHROU9079RoVLjCHzG-hc


Arnd,

> The megaraid_cmm_register() function has a local copy of mraid_mmadp_t
> on the stack that gets copied into the actual structure used at
> runtime. When -fsanitize=thread is enabled, this causes the
> per-function stack frame to grow beyond the warning limit:

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
