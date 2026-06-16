Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E6438C437;
	Tue, 16 Jun 2026 02:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781575357; cv=fail; b=QnnZQ67CmsEaYsEzfNY/3+jZmy+XioNfSClzNEDX20Ul4VmzGK6rx15bugDWCnMqfXHmp3us6JsoQ/y2sV5W8wZhLJz2T4hhhoOt6MI6OFt9EpDNgbFw87tZLu2tm0Jy9qssrCNztcjSJd13Bk/z8KSJOwNwstSI4ZdqXMGr8M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781575357; c=relaxed/simple;
	bh=plzV6wLeBvJX/56KKnczHTg6h+qBM1Zw21PNTrGDAMY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HfPuYmM93AO8oIviPHZ65SHgEy5ft9lWdpJ1VkaEtaoU5tVmjBPQsyp6qk22IHpBa6IJg/cNS6SNYQGQxTTj0qPEBvgh1r9A+VFfQcVn3CplsSRm6uF0ZdB2o7itBmq8t3McNhGCWi8gptsr430F/VkeU5JAH7SKj2YRStL5i7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SUqq+Keo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c7zSDS5s; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SUqq+Keo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c7zSDS5s"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FKs7dK1308722;
	Tue, 16 Jun 2026 02:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xZXELQ7yATZWLoaXRB
	Ih2Uiw89FHGMbJEj/v+saVU1c=; b=SUqq+Keo2RxqSdby9nyliGgbjsRs1X4S9g
	7e5HBNXEBjTg+s7L8ZcjSiHtIS9LPI3rjGHUfboOgdNJAxg7Fgbd+sBmH45J1VPT
	6xqGuJsTDJz5KEfAU3l3HdswU9NEJYTiFYQzzfkEc5kEJVut2ciYf7/Rr3v1hlwz
	A4B+2z9NkwIGx4MAyoVX3DUtsVgm3rAO34Xc8+odlQvNSxn4Lj2iz/XsyAWvOXIo
	M999L34iGq+b/vBkx5MZOgN3TKEHIdFD0qO3Fu4+uFLiiK7Gn3WqcNen1PXi5dL5
	UZsD6d67AeIolkqWsc7567WwFm6yYjmtzXKi/bmUArh9U1J6AeAA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es1h6kjp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:02:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G1r5bj007099;
	Tue, 16 Jun 2026 02:02:29 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013018.outbound.protection.outlook.com [40.107.201.18])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4etq66v4bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:02:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=neZgMHw+4e/L0YCegyOxYwE9QbRcDtzSnhABwG6x+40V1NtdQzcnEAthRoHgCIKgx9jiR+xNvaF9SE/3ycGP3x7PMEvkC/pzem0jfqdvUWPENEEuT4Vwn+oxuNxcPr53Dz1FQJbH+/ooIgMkSou8i5Il/E4xbQa2xKK4PKdJD4a5G0CqX69qb3xqPA4YWQOXx87M3bpdl7C2Rn/6tTE5ZC/ffJqTa5FxfC81x+Qb3ODpvba61HJkGiFY8zg2JW98hYCXWS8pG/wWQdhIFIXnINg99YAJVwPQJRlvanC0DCkwyFntHE41tNNaEtDT38gGVIK1uUdL+Pd+IZmgSe+qog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZXELQ7yATZWLoaXRBIh2Uiw89FHGMbJEj/v+saVU1c=;
 b=BYXpSonoiGvg5wRlyTQ9F+9y3doOUJRu5Hf2BB9shKt3y4Bx+dB/1/b7nrQEvm5JcMWm+OyqDyxxCOJR2+dM42u2PuSDaVRpOzx7FfgM53uct8nsbZYQ9ju+g8XsigqNyQWOBC72JH9jCLtS0ZQL1w3cpKH/85efrg0DbbW3mQnZciKbYZTLlXqga+k0/+c5FfV9C9tvjSrWurf3ecnQRdQX7ty+d3Xv6O5/nncT5ODm7KC7c5CEN5cMB0M9aWlBxOO8Njr3CCG4mfZuNY0uBPTGfHmWS8D3wfIJsTpRptpahtuawm8plkIZT4pXWZhPeFtw7k3ES9DJ13PWgDJenA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZXELQ7yATZWLoaXRBIh2Uiw89FHGMbJEj/v+saVU1c=;
 b=c7zSDS5s9jahC5E8f25fs6pNiOO64hK+yFxaeQ4BDjNydUNmFYlf5VUBgse8xwsJJwXRzQIY5eCmGridPRMxVsh513rBfuRjzboCQWczwIYTPXC6wfrgTmBIYW+Qq8Wx6nFrB6P+81yKFZ4pOuG2UTugfo9PnvjkZzagxffkZJo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4873.namprd10.prod.outlook.com (2603:10b6:610:c7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 02:02:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 02:02:25 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru
 <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Kees Cook
 <kees@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: reduce kernel stack usage in
 bfa_fcs_lport_fdmi_build_portattr_block
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260611125601.3385418-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Thu, 11 Jun 2026 14:55:56 +0200")
Organization: Oracle
Message-ID: <yq15x3jutsl.fsf@ca-mkp.ca.oracle.com>
References: <20260611125601.3385418-1-arnd@kernel.org>
Date: Mon, 15 Jun 2026 22:02:23 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0005.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::13)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4873:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c48cc75-5f01-48e3-2d76-08decb4b4fc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	quIwgl0FZG+3FxPlJISSLRSfk/CnbYHJJjO7XkaFCBHWSS4v9vlf/XcIX1pEZAUa9b7tq9CIgCY/86U4rsk1UZQfPQX6yEpuPu8JL+CFcqwJ9jcGu6PD8l992ZpNYi7elvFJpYwoiLo9pypsYx8zlASJO2o44VzvmX7Ch7QjPmyjwlxq3qBwquh5loPIhayIXWqiEeXpsRYxdzvYucFyrck5WKr6C4H44uFqX84+Qxd17vkB29rBPzD579wHSmW38xzTvJ9dUMvk6twXzrQV+G1Hprd3Mba9kzF0hiAeZjKRk1S18c91OdPn8Pla3GUm+Sxvh6SqEH02TDYip5FtkptZIeJIPxszV7cc/Ho0LwgoLN9eCkPHccOyWofC7HzvsrFHwPxarS7z7NmEx+3WpNgeP0hTFXxg7oH03nHtLYtLD+U7MYbcqaveh3ZfSo+Vaud76bhIaXfPNcg46tQmNDCqcO2Ij5s20WyPoWKhFWiXM+VeOvyWUiUBJ3dIKtirOkiOcNZjyc5p64WEHOnQ1i0Bnr7NvC6rQgApj7/VEBtPcsPz3aRUKeeAVVZ2K/mPCrzl+BPx0j6QHojLU/Q4T5KsIIazYD04xudwFjMiigudnQkZRbxlaxoWgctV2R1hGuLZNR3w5cD3I/RjUR8vuvwL7n+3utPj5Efl+qKQ/nXttnCcIX8fcq0dNSKURqBE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LfMDZttOFaA2gxHgPUT012dAQb8drtT335TT2ToVYcxiVAlIHZMKvmG5zGqn?=
 =?us-ascii?Q?ElixcLNoCF1sy83l29cttZ0q00INcG38NZuQ28zrV3uhkhqkLVdUsIkQDaJi?=
 =?us-ascii?Q?3BGCULWBPpMQ0ldNUKmZXmK7PUkHGgSiXpGz21Aa1c/f5HnXdUbz9y7p3rsv?=
 =?us-ascii?Q?R6RWlgwABlRt7nuISPfeSQEEDhgfw1h5OKCflTqbQy7/dvK5NkpLklexMN9D?=
 =?us-ascii?Q?hj7ZVIemQhU9PTlR/mcrz9Q2DUDDQtwHqocyWpI2/rUb4uL6AJSl7zKPeG9O?=
 =?us-ascii?Q?mzo/FsQ8gdEXEW7cc+U+3ZgZtg26vw+Hvh/rZ9kZytXh8Cti93gNZql70ILc?=
 =?us-ascii?Q?sYgrit8lK03bed3TfIbWQQGxqg54GVika1EPutRofCI+HHUOUPbQXV2U3r4q?=
 =?us-ascii?Q?MrddFWZtZ2XOq8ZXlt9EE2CvSdQnB1HEUXhkGo0LwyXFCeMlFwB9+7dDVhNs?=
 =?us-ascii?Q?3ZcPLOtoJskfVmZOH88XMeKyFzpDrwytw8heisOu/MXvoO7sOPJnJZ8MR5SY?=
 =?us-ascii?Q?ptylzGojDvSgdg4RLNIBSWdIK7baKwDQhqAn+9TyqB4eBdh2X82oRirLU/LV?=
 =?us-ascii?Q?KFzEuAQSHsssLeIZb5d4kcxiIdkhNCHOQ8QyOgJd8RTUXQ1hMGBaXjsZz5lR?=
 =?us-ascii?Q?cYq6UCT27sy7imnDeYPjkBmHCinXv2XE9uEzrgvWiIeUKDRFC0HPFTG5wmI4?=
 =?us-ascii?Q?XrqiMpu5TCLtLyTJIto1E1cGZ/SpcdBNngXZZur8mgQ0ILYytnKP1exHprPM?=
 =?us-ascii?Q?GlWjPba3PpOGHFqqj6pikev3baAz6P2TQkZCk40phFMuUcIVUpjU6cqNZPG4?=
 =?us-ascii?Q?2+Xmkof1Jf15rqJL0sYX+jM2l2E2Q+dK/Bi6G1G6yz+esdDjWRtycxVheXUJ?=
 =?us-ascii?Q?5xH2kGD0pu1r/GU1I3+k5fhA33rpbGnQOAxYX452NC75uPjRdu8V9dr2KQGM?=
 =?us-ascii?Q?+0C6papsPGe7VXjr3VMsNyAmc56P7ZzpXFGgqGEG+XwcSOVTN/qz0L73XZXr?=
 =?us-ascii?Q?pWRDf5UvLVuAoGNVmwAWMOvN5nUmdD99AuYUYxbTgDSugBTXvI/P4Nd7nRAJ?=
 =?us-ascii?Q?YhFKdzgBcOaefaxamK9H/9rhaBDiLVHbcOJw32Ge8D9XPeBd/YkVkAFGLDTM?=
 =?us-ascii?Q?e5/rQ6GNrNfAGMqpfcU703T1ov4I394QMCn1n4Gqlshumq5FILNlM1goch7F?=
 =?us-ascii?Q?aUe3pLuF+8O8DvC1+k+eHtPhv4L7n/wwj6Wve/bFDsnJj3+a6vkjizp/V+a4?=
 =?us-ascii?Q?hta9rVlFCbwBaCtjDdc38jrhB2iDNzHtufdWxGzTqil5ZHpAfKzIzekdJ3aR?=
 =?us-ascii?Q?4uwjPIFY9mbXqe4W/GiHOn2hkaVDa/tizHZbpVgaedHo+XV+nh4Wpa2iAMZc?=
 =?us-ascii?Q?OyhNTGTy7+4dca9eu6sxFTM9KHv69oIRcwNsOalT9687uKHUnC0D4JTT3ptx?=
 =?us-ascii?Q?WTaxi4b5qD3Bz/dMWs8Q+Wzd+/sXxZGKjwqwZsjHfTA7jFzO/vwTl7eiL90v?=
 =?us-ascii?Q?YYI9Q2r0s2ZUX5FKmk0KWpuYJ3Zqlj/rL/apQPGi4xF/IMxyGPAMPXq0I0ye?=
 =?us-ascii?Q?uhq4mdOLxvkW9hpCj68EXKnxa3dc+DaKn+27XfXfC24mMMTU3TWXexxPIJVD?=
 =?us-ascii?Q?5NfZh8Sy7zYG+IC215TGH4Mcmql2MPhXbsBBMRLiev6rETAHxRuYtt85HR2R?=
 =?us-ascii?Q?MVsoJliDJSoFPYrXe7OCpFQigNzKzylBVz2mRuyicMs8DDyFvaCEnL9qF/+7?=
 =?us-ascii?Q?oSJkuCotsnBZiQKnI1Lj1kSOQG9fT+A=3D?=
X-Exchange-RoutingPolicyChecked:
	rSUcaalvRojNUPGZfe95efUoBKqs8+V26AiMdl0O+uB4jgoSm70F41oBDPjiop09DEOhKT6n46lNgTJNATXccY5gjjZyS2ZJX+7i1YXHbY/cULm6KOhGnN0UrN+Qt0w4BPbLv1kZHW6JhGrBW+hRrHHsNlVZZYbU+AB0Z09YaBVnKsHHVPgl1PCRNUCoQ/r/xdhP6mAz4XBxN8v5LSol3Yg/43DHSNEYPZOwwEXfUosCtnaDGxJx2CxKvJH5h/6C6jjI3MjJw4k50rMUqIHYQ9rueoBts07oWqNwkx6oGxW5b+D8Jh1UqRa5ur+nr+nHV4nc09CDzO14H/qu/r4nyQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IGkePqzHIRdIuipwGci7WdXrmrJjQ7vMtFe1a+5AoEcmy2xXPTvo8tyJwo17Aw3tlRCklJDcQpwwcxQuAh36PmCNtle+lZe/trgzSnOT+5BwEwt46rqJYEVReQgqbTiJEn/tytXLqhy42qw95ChuyNhD2UKKvwCCEzfN5bvaMRfQITMP6fSZz5KYaSBm4jdna6R2XkwtI4QnIEmAVk+QUD6txb0TpbIOLEp07hyx3CVZ9HOnyiVbKFDTf4tmpwn42AhcMeM17CwT/IR2QzG8Njg2xyj/ZMIhCeNVf0MWMRaTanB3rhG/+kE42x9eREX0k9rnb4BoNRzQl/i0VdiaCGHnjbZBwOJ+2ClA8w3zNL+xapTeugGDR33UoSBKF1SR2SpaPBU8RHpDPBlzw0PXiM2LiCen0FvmevsyQg1tcSkPzg9ZCWyIFQ5lO556qLH2J3XqBGbapgRm2y8bU9EKpt/iEVsTFEWhik8g45Zdt5+kMxkMhYF/6aBLVI2Rdtjc42ZSVREqkd51rYT2DUBF88YOW3mblVR/ZOnecNimsh5Sa6NS/ne48qnyb8BZZGlY2KpXQF3zFyLEue4EmRImXEKJPnS2hJftIhzq4tJqkHw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c48cc75-5f01-48e3-2d76-08decb4b4fc0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 02:02:25.5180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i44R7MWOxm2v+s/4hLb0v9kgY6+Ar+aaH8MQnwMDOJgtmc8Hm5/k1ccYJwlBFUobhCME49cLUN9xSMU9wmn8yJYLcgf91o4vrIe/XDPOHxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4873
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=952
 mlxscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606040000 definitions=main-2606160016
X-Proofpoint-GUID: AnKTqim5-po0drVqOLHtAJRYVNPdi5-3
X-Proofpoint-ORIG-GUID: AnKTqim5-po0drVqOLHtAJRYVNPdi5-3
X-Authority-Analysis: v=2.4 cv=CM0amxrD c=1 sm=1 tr=0 ts=6a30aeb6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=xB4PgKRHdaRRgBI2U4IA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAxNyBTYWx0ZWRfX33hfoBDjAjOP
 0owoVzHhxyPonjXwLH505tQPWAJaPqioBTvIqK6PXOxywt3dOT6zbuxMB5Qx7aUWvS8ev9bhWeE
 irZ1QdtJ+l0rDqwAwDQX+DsvJ7fs+/UBEWD2mYflNeFSO4q0D+ak
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAxNyBTYWx0ZWRfX7HkbZvIjM3Tw
 4xDbCEdf9WHrnWHVPaY+ASOW1CC6saweYM2Iz2JgdHW9TZHhftZpKBlNAEK8JTRm4YIB6Lmin/w
 Wpmxanyik/lglRF0a5eA+eIbNXqSCWB3GG4XkjXH8syaPP/507ciN8DeWv64w5Los1goWg6h3AO
 EyfqThbOGjwck7QSNCXN1+CD7HpuET8a580guPRHu6WMvqWi/3c+JoXsu816oJIVFn79rAdRHNM
 jjr74Y2qvjfAHomtBbG6rZIcbDnbYxTIZzxxRoLNT2DVur/jDhruo7WUQpbZqP8PhwUQt31QzBa
 UIYo1/u2TkWMqxJLgkq/K1/+bHtuaaYZUVJHhrBZmxCJpfozsWIQyu251TFJZj8wMzvSqGK5QnP
 UGvR3LKZV5GhE1TJzPVLVptmWI2EANktFRHim0vdeYtLpoKMsA0GUO0HJ+CXTG0jtaolaS30bvP
 wOwhcnmQw7MZdpjXAjw==


Arnd,

> bfa_fcs_fdmi_get_portattr() gets inlined into multiple places and has
> two fairly large variables on the stack, to the point of causing a
> warning in some randconfig builds:

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
