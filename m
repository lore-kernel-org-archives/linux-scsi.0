Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1962542A96;
	Tue, 21 Apr 2026 02:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776738201; cv=fail; b=Ju14IUUVAl41ZRNAA8hWDmscHQjqVcDfdjuROXsr8yO7sXMKpSdJEmCkS9hG2nWqbqQA+SWgyyIb4kCqji/7esai0d2fmCXmcZdqYccHoT7EJH3NSdgHSh2JqCTtEqBrTXiby0dPp7Wh9HhbqtHBJYm7ZmfWRZpdp3w9ywvBqMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776738201; c=relaxed/simple;
	bh=hHuQXFxA/Qn+vjOI7Ohz1eBMqnIRTyRpO3pohr5i/7I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=nVCIK6VCyJP/Cd5kMrf0xKHoQMeWCfMo1r+WPZbBYCDYS8wfB9/iW3C1l03df2VZ1mnNIoN3nOd43yshl9eMArKckqnbm0Usv/sjKznS3XDFuEyTGt82Y/JfetmIBCgDxmMkAERjuqpPgIdbMdh44RpxxZsGpvRtNtA9pY54a64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ihaRhIQK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ofbagnR/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ihaRhIQK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ofbagnR/"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLtmde089785;
	Tue, 21 Apr 2026 02:23:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=q3lWbF6TDFbFzQZcdV
	x5adDoe2BDnAnIP9250tkDwpk=; b=ihaRhIQKoS9E89AY46reuFKGKnnU81K+/D
	oVeO6YNRbjbjjXR78+SpOvKBSjuSz/Rx0pzsxXUJoYwvt8xGAb8/DW8L/xmtQdlt
	vNxvGCgBp7WO2GyOm3RhlE2WmhToPBJrqRGaCw0X9bEhMAzXGEhGRVbnqdlcm8J3
	/D+t1w5U/JKCK++am+SIjyMCyPipSAnyIsRl+/l9snKvmHRiV6AM/QNG+sDmtN6g
	CP2E5/j0Qmw/JpUIqrWGc0GXYf5uC1UyEz/bTYa4XsvkKTNaGloFoeCmTKkUrElb
	HUrSfEBA11HDoiehe2Rh7VdtsMxzxm54z/8/SPWq0R2ZrqvQSlMw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2cevnd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:23:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L2LD6k010162;
	Tue, 21 Apr 2026 02:23:02 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn187y1qj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:23:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IrLomEt5Yh+A2IjHh3uGdFl8WvXw/H2dKHrBzCRTxYLsj1oQP6823Km2M0RzTjCd/IVfhLAximow1/eBOnIzCto6NIp2oTarfWdt3hUWGH12xD4eAXLjbpmvnVpfSDmRYLE/pjXH2TvWkThvmB90N8HxH9ve5xuM/Fmh964BniyERaIqDiNy5hyRszYZa7OgsrWVP6mFTmg8xDHAqUsHHWXo43HYu4B4I5x1XnqlXf8uncfmx/PzaBSky+8i/kVqESq/nkGez3Pkdcz8TqKfcqvdraXi1yRFDS1WdD6FrOiRlDWzXc+NVoCXfcsdjri8IWy88jOAaEGwuwdSqyMl0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3lWbF6TDFbFzQZcdVx5adDoe2BDnAnIP9250tkDwpk=;
 b=e781/34DwDnWYM2pguYFKlDeHx00u7kK0GEC8ZRoTqD5DKwB7L1jK+znC4lo71wtHSGt6XDLGG43CZxXSZGWhjd7XYCQgW6g1JRJqp2h2ISAxV0ZLcFW4VofDlNGQE3RTCAD86qTLGBHftkh9WYo6dIXI6Ob4z4rsX3bSdqJaOig7nkXyy/ncT2ZxqQQlxvhYTiS3I4ye+nw8xtKJWLJHGvbkLbhyEBepdrHLyMAqowmQz/3vgSxs3PyhK15/wIFaRt3GFp2yaXrGEg85p8bUdl/bwM3bJ9xZu35r9dedJB1rhC+svvDwmOhokN1gshgXHnTAzekA/e+Gcr0smClGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3lWbF6TDFbFzQZcdVx5adDoe2BDnAnIP9250tkDwpk=;
 b=ofbagnR/qQKg4uVJvcAZdswTMOc/zrQgXasSVBLaEn6+9GZ/HK8Te543TnPHMxMBNwDFjc3tgV7aGONOgXT2z6Xdy7o8JbWd5BuHiPN9+qDr+vXdnBqlWWMZFXUtCDfssqUalesGUvvjDhhOtIHlQoS+ykXZp00tf/gLKsWTjgM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB997624.namprd10.prod.outlook.com (2603:10b6:8:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.30; Tue, 21 Apr
 2026 02:22:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 02:22:58 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
        dlemoal@kernel.org, david.laight.linux@gmail.com,
        stable@vger.kernel.org, Mira Limbeck <m.limbeck@proxmox.com>,
        Keith
 Busch <kbusch@kernel.org>
Subject: Re: [PATCH v4] mpt3sas: Limit NVMe request size to 2 MiB
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260414110811.85156-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Tue, 14 Apr 2026 16:38:11 +0530")
Organization: Oracle Corporation
Message-ID: <yq1se8poxvz.fsf@ca-mkp.ca.oracle.com>
References: <20260414110811.85156-1-ranjan.kumar@broadcom.com>
Date: Mon, 20 Apr 2026 22:22:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0176.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB997624:EE_
X-MS-Office365-Filtering-Correlation-Id: d5e31977-b10f-4aac-a8c6-08de9f4ce779
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
 K8trwGrgl260u+zLYbPPvhOqwF+rCGzaUw1PkOjaPAc3ag1MRh1XlfirhOfHQYaxTmLFnhDZ/Kzto6EgvhG5FP7YRYPmHcx+YQaoDTVZuvkNmq0Ck06P5HBq1PR3znhGrpvjkFOnvZ/9rdU3Od6Pa0jxN2+0PWyPpW1rKpA3eW+sLhLATTZJn7qtjLZqmuQ0DWSQaZiUdV4q87Dd4t3MdVDf2FXHMpZN49LvAt7DVxW4ac/nYddlso0R7JqsRs0+PCYZWSuH98URtJ2+6pzYkWuI2p3oE5ewpRA/TI7G/dLBEbAxsjDKZfamDt+e4BWbuG4PZeacoxMJC7bZnyJvGICqG/MA2C1+8jnv0Id4WzPL/eFR0SQRhCzD23MShlXt/UkNhJjylUNOcZsnehE9eJEhZ1L7fq3NVsdi92UqwewNsIQVzbilOhT1/b0xW49PHZ69IM++Ixjupq2rH3LNAYOM1xmd0eoc1+U3dWS0tq4nKURGhqMUVrzRCV5TXjoAYPcQvrV+aa3zvT9pct9D5BGVVtRH6G/PZet+IE/BiZz8+5LJnI45YQO1YYKK3+CffKoREY7Nc67+r7lIwHY2sW4kdtWgF/GAArmrTzb0A00ypxvw2L8qA89vWMuG/h9oZtW9YjmQ270vfIwJkF+F87Xxs67/5yJuyap4owI0nOW0f7b8yTIRj0KWh3zG5wyno5fGNdI0Sa9Md8p63wfILi6ntonJMGSpNeABN3V2NqE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?VNwLs+ni2TWAbWsCxzly3rLVen1BmR1ndAwNH40upKJHvfYb31fqlE8izn6w?=
 =?us-ascii?Q?Jn5shdAsM+qjy/9sMcHYzLauuQuO9+sKH1yfJ7GBWmcXEKdCiKV0PVQkE7PD?=
 =?us-ascii?Q?AU4aYBQoJdo7rA0nB0fpHPZ2InfrWOYiy8ff85c/ZfB1zVEad+n2B9/gEoLd?=
 =?us-ascii?Q?WKBcVIOloOBUpRxLoEV6AVUQ8SaJ8AYx3KflvDoHfYhs3yNuZ16WEnmUt4Y4?=
 =?us-ascii?Q?0fljO67tw4CSgeSGguZoc16He08fZusCkgvcWmApAVR1oNWA+vAZI92L9bfl?=
 =?us-ascii?Q?klul4OQ9ynyKefSwcQiuzivwd9s4xv021ap7leTZ/7gvfOkWNVKWgjU5xtRp?=
 =?us-ascii?Q?iIAkxqZiqpxzN22atb7IX/SZfj7jEHGZ06M049grhR8oy75L4lOZaufjvEAd?=
 =?us-ascii?Q?oBM/5k7oIF8ELo1RNhfa0Itsdw+7LBJnyqa2Eyy9kgRIyFibcvv4NguOk1mm?=
 =?us-ascii?Q?3D1Qn3kjIsa2FdkKXlO47g0I/aGTEFOuXu3+4F6kOPB9LJldX71QVaIAmC0H?=
 =?us-ascii?Q?rnQrw3osEiam1LsvC/5WmwTQ5HyC6KdSLQ7PktDt373x2UVzn6u4TP0JuCZr?=
 =?us-ascii?Q?gpkawMYYKdj+YC/NoKdJfQC/5fDhBMvbiiwDCF9tK4db/6W3GBBK0BLqg9+U?=
 =?us-ascii?Q?jV2DSfmoOe75hfiSr1gvqWtfXB+SOaGzrHRtGa+W0hcRZBjo+k9z6DprynCt?=
 =?us-ascii?Q?o/V5pWJA+aFzFoPAEFZrRUSLY9mSL/6Xj1W+IfIEST3ZBwmoh5OtWYvBawf3?=
 =?us-ascii?Q?XpeTy2A6RjVXcOhUOiMnPsuEsezRYD5UvqDs1kU3o05B7vbMjXozLnwg0e2X?=
 =?us-ascii?Q?xXM8BEO/WLPXLHhhT3buTF3NYHIRQaWVoYE9AJVtN6/EQphc8mtMAKizNN5H?=
 =?us-ascii?Q?tqgCIXjGg40/hf4OuNcGy+mABIaX3UaBlw8UNqIMeQVF6zStZuKgfvNQ9EL5?=
 =?us-ascii?Q?h5koktNnBc70keGlxLeMYOkzHvXItvRB5M4DWxBIIv0KBz6sYc93eQSFLX9b?=
 =?us-ascii?Q?i+9mf8ke3wUmHEnu8dwCTRFJ+TJgLMI5PJZC6Xzdn+gnQLTC5jVGZk3G0HR2?=
 =?us-ascii?Q?B5yCNIT5vnnvysd9co3bsXvD95nFKzuJ4NTFU55E1a7aMwZlz5uRdnn1DKYn?=
 =?us-ascii?Q?gnnKo/rJbnQS0omybcRyEpyOUx2gZUbdEZvitcfTR2C77s8+eTn9fiPag2s9?=
 =?us-ascii?Q?2rNsEvV7cOTimo2Kf2WoazF1UY8J2rI38yJGKPOu8FxJHpRvQI0s504UWlt0?=
 =?us-ascii?Q?bifDtNiMEc+Y6nQ5muRmqrL12t9kpmdpoMamKLdLgSqrpDcy0H3G3vVJOSqP?=
 =?us-ascii?Q?dLQCdT+5UlT3NbNsdgLRgUEtANyZaG4U0Y9Hd4GvHG+286o0IE2x7C8h0GPF?=
 =?us-ascii?Q?p0xcgHZ423juQf96UnymbzNxtOkq7hyzr6xS45RAl11HkTyz9+esFu2NgsPt?=
 =?us-ascii?Q?Ov3vlhCvLOlmtJHzt9y/NALeCIyrcrZJctY3+rF/1m+lVy3SuWLXJCc49jQt?=
 =?us-ascii?Q?nISIvjRZwCIsFwkr4y6c0rhilLJEvxutc+1DMrr0CLWIqVBhLeT4Ak/kLRbT?=
 =?us-ascii?Q?IXfOb73nzTd5MY0aghSN7jyQs07QQY7p/Y6T9RYU9ggUAo835eM5VIputAjM?=
 =?us-ascii?Q?z5YX+nfWQV3U7L/peT3619t6j4z+gfs1RDHs+Y0DnnnAPcW/Z0sJDPGkQzb9?=
 =?us-ascii?Q?DGk/zLcAJ1ufO1X54zj3ezadtrNOWMtqW5JstBRRk6Z/pONtDaRMEJBHffYL?=
 =?us-ascii?Q?Ymoikq5XkdCnPh/VlXU0hwMBniLALLs=3D?=
X-Exchange-RoutingPolicyChecked:
	NRmvVsUNy4g6dnJYFa3MRiRfPu5x27dkOmt5+B6tmQHHrNqgCld3NTV1MVU9TwOOPtYA7ADmMzpLJOQk2z2RPJ1bNlW7tcaU7PmrcwpzGUEITQ/TcYtgGQSCSrSVIDCMLY+HmSoI+Mgn17SQT15B+LStsiNLr4oJMltATIsmTNnbsSgIGa8KNHyf55iCIlSzGhfut+aPHiLfLUNEVQbVIzsvhfLuRnxojDSown3NWg4lotLs0rLalEayyO0aXzFosR2/SpvoCIrT6hB8FU5JkT4hPyPKCY7RqhSkdmI42XITmq1Kr4Unj8aLAZNu/q3sUoH7EmUVRUhEsOLRrdlMrQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nKEGLOX/O/jz/H9NuQ43SXHm5mIWdoP0mShfepxkl7JTmUF3WatWDL+xKjCf/tlDyt5SZa7D50o1NP0GXnjI9+v6qTQ+Y3ukgNfcZguR91po+5QDrbxfT4DcpaH+1avJHNOVyCgIYWci7p9pm6ErlAlkUrPiTMyDEoZdgu2SO5aQuIiJjY1h6KJIKXGr9CVr/d0KpqND3T6jAXaxugBp3wvIhNhkSuPHkpt8w0cS35PSi1+xIhnS3k83FNGDMj8n2DBB4jpzX6hDjOL91lZ+KmqNz5Nvt9Szq2VpU3xZOu+XlqfI4zfVAS3usVWq74spI8lMpVlOUGfH9jauVPwQXkKedpP+Sg3NwMR0x1DeuEZ6e0fwwV2ScRxbNXbjlmQfcLPbKrh0bqcP5SjbI13fT/PnmJFwkGNOw+EVU7Z4N/iukj6oHoAW2MJ5fe5rqvB8Be90RKiLtl1936Ezg0h6sbfYIbuCkW6oe5tV4MPSq0T/saMUkBxGHBCm7z7UooCzCwYblBYc53xvQUcXNjHVjnjmk8u5tWSlYyXy7ZALXeNWPTd8JttuIa0xEljvgh9kNaxhsRrc8kcSKRiCOvcY4Ea4VGwnTnAXBJpWXuy6ZEo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e31977-b10f-4aac-a8c6-08de9f4ce779
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 02:22:58.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OoATSLpVSH/m1PHogzaU7Q+eG/ebVm9khHImvTSN/P0UkmKzp/W639lOOTyZVl9UmiRG0J3zMLOO/vlb5eOdyRAv45t8wbFXbedVxiDE3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_05,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=860 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604210021
X-Authority-Analysis: v=2.4 cv=BaPoFLt2 c=1 sm=1 tr=0 ts=69e6df86 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=anrGc2dYs3bqXeueZeAA:9 a=ZXulRonScM0A:10
X-Proofpoint-ORIG-GUID: IKkZIWD_gep4SytscuX9GT0Rxwe-Tnid
X-Proofpoint-GUID: IKkZIWD_gep4SytscuX9GT0Rxwe-Tnid
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDAyMSBTYWx0ZWRfXxuHxauPa1rvN
 +ghrhgJ6xrHEgV4rxEuHkkBxp0W542XrfnNe+eky1EuBCVyc29JQ5hvBDtb+ElhdWsQrMXT0B+F
 zBWrGDHWeQTBBM/NFE6IYJzB827ahUpZO8Tzt9jMNiXmeTJlGo9lb60d461zXyVhgw3X34x7N9O
 tLsr1SLZXPZvOcNT2P6xPU4MFvqTSdRfNuwF3JzD9DcmLmebmFzIg3/cos7t3fVzjNkweWB0x+3
 yriGETVY7jmxzJiHKttENCHTemAGdNaUBsbiDR3jc0ICyvhO86Gek+OEhdJE8J+x2LXttPTZuIK
 2iTl/aveYtAvMV62T6aC0ELXofvu4Dd6i3caxboRvhB8MRjtfR+c/f0OxKZ3INLq5qXyQ5xJ+AK
 WnFciR29S1jUhPviPDUVa0Vip2kdYH2uos/XbFVfhmhaM+zCmfC1IPKgGgmHqV93PAYPajLcnf9
 s8s7qn0CCxjId//YvlQ==


Ranjan,

> The HBA firmware reports NVMe MDTS values based on the underlying
> drive capability. However, because the driver allocates a fixed 4K
> buffer for the PRP list, accommodating at most 512 entries, the driver
> supports a maximum I/O transfer size of 2 MiB.
>
> Limit max_hw_sectors to the smaller of the reported MDTS and the 2 MiB
> driver limit to prevent issuing oversized I/O that may lead to a
> kernel oops.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
