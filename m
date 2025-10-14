Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7378324A046;
	Tue, 14 Oct 2025 21:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478943; cv=fail; b=nTzSx9HNm32/+gqNfpJG+uOUEfE2vnFF4rJ8LNMG3NpbZOGZ8bFMiAnJuvPnBxKXssJAzTWLVuLyxgynlSYYxVHGqErTgV4e069dgBGdEEssJlfgs6Sa98sHvdDXKrck9eAk9hzHoapVo+qcC/JIYepNqdbUl1upYkJX8nD03Sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478943; c=relaxed/simple;
	bh=7Fa2MJRRjuZzklAnBSRrjIoN6NanI9Zvxrr/d7UwtmA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GTEVl/bmSjzQ+IlL37Bb7rQhJmLJ4OBJQEtu4AUiY8njiWSymmcVQKiFhgAkt3NBJU1B+aHQEI1FH5GcKtaIkcedo4vYnBM8GAh870vfoh9XDOFG15i8yrnRKBNi3PEo0O8WFwVakDLm9T/FlCiFKGQPimEXV36spbRpHY36V40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gp16bEOJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DN5LvDM5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gp16bEOJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DN5LvDM5"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEf71l026219;
	Tue, 14 Oct 2025 21:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6tEJ9YFf79uQtrsyrb
	V+A5xsUIgdDg58h6V0BN0OMBo=; b=gp16bEOJbLTPLnS8dTBP/uhYtaOSAOPn1u
	zQHCp8F1wBTZ9Mb8eERutSy+brg8+WLe9w1e+ngcZKcByDgmAnRTfRh1/Wa5HmO+
	rgbRcu1Jx29FuNnE1OnFur87LI2aKcuMpjI7tZH12AzhfQPjoplFLtaVJLauEdxz
	McmTTkarzV/csqVdDEbT+AzLOGK3Juhthr1iefDV/1ExDUZR6uaFO48YT6epC2qk
	qne7HX7hJrFyznk1wh8e1/n0mRsJT/lcdxp9hUT4wQGoZaB4AV+J0W6NxKvz+7UG
	R5rvfE/xIEcuzYLBu0btTO07qe8VQH1N3g/bgGBoebj6jTNDOs8g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdnc5cub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 21:55:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EJvdtk017446;
	Tue, 14 Oct 2025 21:55:24 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp99u28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 21:55:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jeb6bErK5bRzXdhVPuZHdUpiLQT/VypGL0+pyMVSuxGnSrtPaGkXlsgrE2+REw9k0ysJbUqs8hS6GH0PK0VJW2r/IIsrHxzqwG+EEp9wQIM9g/8apARA0NamGqlYpJYcdHF2EdOu6tYy4vMvpItDfGtOzl+jTenE20x5p2ZJX9G0c+Vk7KqcG40v1uP00UsnU1IruuZqEvsCZmJGK/daYU9+zmYY1BTY9NUqQLcRy+KuDBL7jEl+W53kb0dqQhW9TlG1Egm1z6tRMReEADvtFwCCzs9zgPI34OXwIXArjv6xHCGmoyso3TstU8hDYu5lx1fhmjQiPVJLYsZMHfU+Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tEJ9YFf79uQtrsyrbV+A5xsUIgdDg58h6V0BN0OMBo=;
 b=K3vk/Qck9SrQGBa1Ez0bgKXFSisvJutJpmg/JLj6SUtXTgPLU4L6KJ7IVDbX0DkmgAhlTN3ATaGwZgevyO4ysSc2ABts+jkY0y2bM7sB7ht7a7pUTvbpah20MVFvZzidxn/o5nHUsYGvc6MYfhDYuUp9kkbwcY6Cvhfuj2E3iDMKrECJl7/aKkZC3OhZsS2V8VbSt+SSed7Xzp/5AH1ZTBuCBeejCFOdChJ863wGUU90CIyFTThb4iDTmPB5+VHq/oPoMCAbUmBNEN451xAfvqb+CFfVATSwv8CM6BxJvq0AE6ILXIVP0sZLfdJk4eb/S3cVPSAr0zkfEnZg7+/Kwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tEJ9YFf79uQtrsyrbV+A5xsUIgdDg58h6V0BN0OMBo=;
 b=DN5LvDM51TqXO0fhFb/UDXDhcghvHTrUx+qfyByyLj8ADLJ1SiHQ0Nsqy3S4Ae8oQmcCV4Fwod+OJINyt7x/FwajINJDv2Q98XlLxTqzzqmsCqIOoY2wyIdlyplsvu4JFvrd+Cyxy9OzR6yxfl71aCNIEi0UKVXMWZB4fOmciXo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB4630.namprd10.prod.outlook.com (2603:10b6:510:33::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 21:55:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 21:55:20 +0000
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Gustavo A. R.
 Silva" <gustavoars@kernel.org>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth
 patil <chandrakanth.patil@broadcom.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2][next] scsi: megaraid_sas: Avoid a couple
 -Wflex-array-member-not-at-end warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <a157b190-74f4-443b-b52f-1fe0280f9bb3@embeddedor.com> (Gustavo A.
	R. Silva's message of "Wed, 8 Oct 2025 10:28:38 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldldb1f7.fsf@ca-mkp.ca.oracle.com>
References: <aM1E7Xa8qYdZ598N@kspp>
	<3a80fd1d-5a05-4db3-9dda-3ad38bedfb38@embeddedor.com>
	<4cf727c56c4fda8d28df920214b3824c9739bc8f.camel@HansenPartnership.com>
	<5b23ae5a-bd47-49c7-bca7-7019abc631f7@embeddedor.com>
	<ca77643eab8e10319db31690baaf031b8bfd32ae.camel@HansenPartnership.com>
	<a157b190-74f4-443b-b52f-1fe0280f9bb3@embeddedor.com>
Date: Tue, 14 Oct 2025 17:55:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB4630:EE_
X-MS-Office365-Filtering-Correlation-Id: 6557090d-d860-4729-1595-08de0b6c5e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ll/ut4i3E5afC4k+HCA0Q+ddC6tr4nBqnNI5xQTskD/hUIkF/1U+pxP/Zy/f?=
 =?us-ascii?Q?wYJaArCoheH6WdI8GyU5wMkIS2uiP+InOe0rveatLNebxtu3e43KSEVPN0bN?=
 =?us-ascii?Q?5foAt9S7g9djv6eU3UAgYrfinBt7WdFDpm70UNll+FmxtM9QFSTLTVjuSKmv?=
 =?us-ascii?Q?UT8nlxB9D7zYkQTO5O+U+yXVk/Uofk3U/xgqHGzHQEVBB9aSs3C8RTkEVpam?=
 =?us-ascii?Q?xaSj+5YoOK1i7RqZeUZs3Ca8uJswzJeIHW7r/WDwi5SelqvbPyOfumHCkuxx?=
 =?us-ascii?Q?u23I2FKhwQ0bIp4AA/pUDuJ0jf6tE3iq8lkjNjiJQGHIowGnQ8iv1hKMNqSA?=
 =?us-ascii?Q?E3YMtaumi3i6u8qf8/2Jvhij7DDdSeClZpr/zzR4k0NO6ucn6fhXIoVnqvD6?=
 =?us-ascii?Q?jIAiOdSxET076LqqruZuC92Ebrhmr0lD/n5NGuLTtbU8FnggD7Vxka26Q2L6?=
 =?us-ascii?Q?4XNm/rlkodPHbY0cw9z4uEfUMRKMjv8B8xgOd56grB/PJTwK4XxKGqUg/JXE?=
 =?us-ascii?Q?b1qkk3wtmCw5+K98w2LQIikg7n7pEyuXa4DT9nnWC5MU3EEVSVWuncxSgCen?=
 =?us-ascii?Q?XF8b9trqove48b4tchzXfbGQUeAZguWPoit5A6Djn85cXs9tmIAxv8JWaweP?=
 =?us-ascii?Q?LxZ/Q07l9qvADAS0LPxW+A8l4NaWjQsCrmgexfqW/hvbNq9hKntzB3pqq8qx?=
 =?us-ascii?Q?XLlOi9tHAbRxJQ5iIeGVV0durptTQrcI3d/h7fyFFQXf/yqFAC+8j4UKJ84n?=
 =?us-ascii?Q?2EuCf/zvt0nA5n/w5XTGoTQfedd/3GtVmW2XwG2U3nQyXQAptBePLjs86TVi?=
 =?us-ascii?Q?gEBd16WXsTXYEcXG+acBGCE/9YYdxOoVFTzZKVWdViIQPCYI49+5e/KQg0H7?=
 =?us-ascii?Q?Y5aCJNABjS4W+tMVsRA/pyS+/L3z53VtT6qCDbclo/JccTwh9NqfHTbEstLB?=
 =?us-ascii?Q?Cj6sOqMkqRUNi1mn8LattjqCLs3MZ3WSVJlNPlqJNnzJiBWdTNww3TAPCPB7?=
 =?us-ascii?Q?9HxAcfwPNdu6MBGnvs6nKczb3Tn3ApXYz5uSqExb0uzFu2MT2gHbnuLlnoBV?=
 =?us-ascii?Q?bXF4HQKNpj7/73qrWUmvJnC4Gs9bPt2bFQv6CpKpKOYkaMkUFGJLHjX8a8zQ?=
 =?us-ascii?Q?hdZAOprczgzy8AvxkdvyxJCu/k0HXkPdnw/+SG+qbvUCWVKtTSLxfvgiUZns?=
 =?us-ascii?Q?KUsCNfqpxQQqSZkDpJQMyn54QK53d37IfVMMN/0wu2/eBE2O1kfq92mhjeQ0?=
 =?us-ascii?Q?AMq7YPI0cvXv7YhIyNCAmNIYF68l4CEHZ9KeDExtWjrjRBShs40arBd4aMHd?=
 =?us-ascii?Q?4YqX/EhobjTuzTnF7euxBGdIw0QYzI5UNlpdOo7ehRDauuDsO5oXZgqQhBgv?=
 =?us-ascii?Q?XPsmESAJTRy7axssqzeF/dCMXS2z/1QtG9P0W7FQ3W78Q3s/dqEVNrJv/eru?=
 =?us-ascii?Q?ijfPk74WR5woHaZ4xrKcUHp4fiiMz0eE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mvbbYTELT/B1yPuL6YSD8+36bJdqabQwwdPBmBz9vgxnsrqVttNFmHSMR7u4?=
 =?us-ascii?Q?Mrg9OYotjdyk0QRmEXpvzSamYm8YvcqDPd2vrH6PaUUlUma/MpsZ4T28L2KB?=
 =?us-ascii?Q?alofQCviMayUAVPbEpKRfEd8KBnVJE/68kgeeTjlG2b86652HLOHpoOszB5+?=
 =?us-ascii?Q?7iRQfYRHUN0X42JOeteswfPrdX+0W8oaT4Ki4KAKfD4aWkKQnWbyugFpfdJo?=
 =?us-ascii?Q?HztV1ngsEnzv11S9YC23CJLrkJGzd4VNgMB1iaumjd0xks0frgIWJl/Iw2or?=
 =?us-ascii?Q?O2+4Dav1qcXTgMhgV3Dhra9xwjNhrNvS5K9S6lFvejTNb3weDPH7tMh8Ilvg?=
 =?us-ascii?Q?ZVN6Fc9HYyTAMFYVbZ14BB/RE3pGJSqhwiYOY5NrU83fxWBq2kk+kEtsu7Wi?=
 =?us-ascii?Q?+2P1jq3JV72Buy5C1xCZ+DvJ35hDmxgXrNp3Wwzk0QhMJS0Y9ktkda92Tfmw?=
 =?us-ascii?Q?ehtPGyYBcIloE0aa9w6MEreR+FmhGebW4tvxk2u3dsG53JNfaRmIzP2AgN3P?=
 =?us-ascii?Q?bEypsrS1lORnGgyzFDEEmqxGKDTuJeSRSZ1H8B12Y67zunEO5s9w+OEpJ6BU?=
 =?us-ascii?Q?undv70cVhb4hLBxdNHmJ0zAvg1N6SyUeQppX0pewvq/C6q/GuxueaVl8omnT?=
 =?us-ascii?Q?2O9cuJGYroaPIO+yif/1YXgubwgQHY/M3nBTBZKAijwqKRWOEhj2a2pc9lqT?=
 =?us-ascii?Q?hifyTG/Hm2d7aibfURaaS9E76AORoDL2++5VBWne0hoKXMGb3t3MjY6WvFB8?=
 =?us-ascii?Q?Bkt+wi30iAMtryfQhRKwHLaZje4IztL5fHGjqdWcKPNEAW0JQSRJeVup/0FG?=
 =?us-ascii?Q?rVWm+leXgsVyE7yj/Xcsbryh/GQ83sSBgoglxsxkdMRpWygf7HcR6BEi6Pe7?=
 =?us-ascii?Q?Q8Aur1xKg9borfg5m/yvu1DJZ8woiw9qIsQ7/X6S9YzZxgy3GV5y5a38DjbM?=
 =?us-ascii?Q?s/XB/oGc5XKInd2wgmnhkGVWMahi0jGoj2PJpwcOYskXSeOogyb5mCS5R2xc?=
 =?us-ascii?Q?bmnyij/2sDTaTt1eNemv2FoFSaw49R3JmsA2QqPsEeLxG5BmQv+jdaD8+h8N?=
 =?us-ascii?Q?qFfoqoK/pJ4sewXvIlocxWEvPTtgUgk2dDY/bdeDkpTtgprLmzcIzOuIoObb?=
 =?us-ascii?Q?R0VnEry1vmKd0w4V/Vb8cp477iI/iaCfPA5Eu4+BF+CoGqFjfhfM9AhiZrvx?=
 =?us-ascii?Q?lolTU32W3IFAbmvtjRFJTbAwFEC31ITYrOeqzZZBYB0UoZg1aC6xL281P8PC?=
 =?us-ascii?Q?O9wowSVtx95ZwG7i3tqhk10DRqt7BBdAGdp931Plr83cT470jQnN1kGQ5T9Z?=
 =?us-ascii?Q?12qj6rJUbRbJQs3BeJJQ3uEia3p4eLQTqY9MxHDpLqcNNgH0aMxtRO7I9xDY?=
 =?us-ascii?Q?c0HllQa7Fv49Ip/+vio6tvJrsjyHksQyEy5JbUbZnaXWD6lNJd1K24e4uXV9?=
 =?us-ascii?Q?H7SX3g77W71MzqJ0R79unv6U/cD1/jtnDrod7PsRrv/db9jdsHWddak+FWsP?=
 =?us-ascii?Q?15cyBzNhZ5AprGR4ugfE46ouDoVRe7T1nRJMWh2+av/kTojpWQaUOFA5yEXf?=
 =?us-ascii?Q?R6cvlVsv3m/eE/yi57O3DDIKdx8mX748U55NNkl0xdgQHqvkFjgrO6Bl4pqB?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	61FZzHIbmVnt3VKWLV+NlbPDbNGt7UzvUuKrk+ckKn4XHx5RgJ4BiJzM6GLfAka/2je3z7cIebsHT4pkOcHDCPjoWg9NuiESfl5lxqtTN7az4OFcaZ/k+gszwr+XGbG7Ddi2ggEQ48U+tr+ZMjyzX/fmir34iotoJ+Paz88uBtVkpCSlIbEs5ZeecsBkx3Rb5aPAQ1BLt34EFR95IZkGewqCZKdH+PeUXuEckkuYkzpVmWwxHkVlNQPX9ExfyeOwF+OwCR12jcX5xG5o343UsXU53Je6MOnK6nC9zuwisJ+oDL8ngG3hz4UXzVx1bn8TQtmX+L/q9wpw6aqTfstlurXs6xl4vCyoQJpBs1YCOjbtaELGsjsxeqV3TPYQYXURFLoxOOfpaEdpxegY5PCXg1biziRc32MrfYcH1Q75tzxgkWe9OZw/+NIRHsULNFVcV2sjVS3eo9zuFNjRn4dlnC/wmvSgx2zSbhU15CC7zknOKsg9q+cU7LpDSJwV1A/e3KW8DqCVygl0lIBnnhaF5nk60HEK7TnSpk6gvIO4pnAKoqAWcfh5RyEiIaR6Lko7f/Fuc7e4g8y0KEPZrfhnwnUGEMPB97H0uFRTAJwrf8Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6557090d-d860-4729-1595-08de0b6c5e66
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 21:55:20.3036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +THscvjkBLUk/XD/LwQg3Wup9IBftvNBYLK3DVG7W//Lu/STmoz9cfCKUbbzbiHTaCl+UZLuYEjiSrRr70IjIrvMx2co6cr45JeSJw65cPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4630
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=531 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfX8z5ts2CJM4PT
 A42tCLcPkohwOt8fXD2pG2zG0oPKMEbUdOIzjiXvzHxG2TgrO7N7UZLjYfAR1LjbT9o3g3FSnNA
 T46q5hBChKNMigPlIHikMptrfY6oblFPV5OHu2Wru/YKzGJJRKqzIfxMS+zuyhqgQSe59K8EXQa
 d1ioUYM6/2t7IMec7mlPI3COH/oJ4Zv6mS4dB0rFhEBqfQz6Q69SbT9v+/FzKyARDdfp1UBZu8Y
 W16ZGqKRsl0fBkBPl2lHl+pIvkdS7M+kvPLF5zLgiJ+t4Xue6LzQGKQ9V+VphL+w/5FfAZvIYXf
 kFiUhqVp2XKFUhBPtIOLaQpNCvxp6uY90xjkHoj8C49sIogHnVItNc727rnZvAgveC9723myUTA
 ezqDYgzsCypJsj7+KQ8Q7Z36mMbyvg==
X-Proofpoint-GUID: 08Vaa0pCJSgeTkYWrVV7X8oMqsgvH2xV
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68eec6ce cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=SK_bpUBa7HXoe9ATCCcA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 08Vaa0pCJSgeTkYWrVV7X8oMqsgvH2xV


Gustavo,

>> I'll leave it up to Martin, but I think going forwards it would be
>> helpful if you could indicate that you've checked that the binary
>> layout before and after is unchanged and thus the risk of merging the
>> patch is low.
>
> Absolutely. I'll do that.

For patches like these it really helps. I only have the ability to
validate changes against a very small subset of the SCSI drivers we
support in the kernel.

-- 
Martin K. Petersen
