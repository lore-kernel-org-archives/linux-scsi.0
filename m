Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855DD19D884;
	Thu, 24 Apr 2025 03:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745465274; cv=fail; b=nJvQi5pWrSZmY8vvDklHR9WIxZ39Y1UmqNThVAJsH56081kJkqP8AGO2cDrSSdko8lSRhLUsvcEV7Qjx13yFTp6ENPV7BUpBNjpA8phgUiVppwnw0Djk4bT30sCEe21HrzBNdrYGFDGbXxHsKWwJdV8Txz8MMLPO4ofre8eThGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745465274; c=relaxed/simple;
	bh=cEM9THy/dBPpdAoieruMKECja4Dcn5Ai4D2kTrH64r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R1kxbyVZt+5WxMGvdpCn6KLhlNUsgorypJVu6yFLw0jiAkAzuNko2Qo9zKHt0BT3hYIVDSR5QLgpNwmwHo2KuSHQOKeypKCCfAyuWyofB+MXqIPFaIZg1OnQIgHBQATe9XwOTAeUezDlYU94zf9f0rDQD4z8FxISvQy1Q1siY6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nw1AmlSf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U8Y/4nJb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nw1AmlSf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U8Y/4nJb"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NLNpbu010581;
	Thu, 24 Apr 2025 03:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=E9jyaLDe0ooLKdpsFHWbN5qGuKBgu5qmLS2I0Z4GmOk=; b=
	Nw1AmlSf1ksBvNhGX7mGx2EKF9TIEG6ppAngoxBCFeiQTjHToJg+pJT5391viI9F
	JdPn2fgoyVq8Zagrj7OYQig9BGSZkrbQZbJ7x9SPLtooOeCCd2Fu7pbShAoEPlf8
	1sV3i1RFEuUhK5GJ/K6BFSrSYDhUGYtTwyqts7wwlqjATPIEgfMQC77zVZ36NriA
	5aQd4eiEjTi9LaxFMPYsTl/tehmeDB80s908V6mXl1sVcgACM6TeT13tRhuQP52G
	yC+8xCUZ6niIkN9ezpTtH8QcffC6wwyGKyNx6uMq2xQhjVOLUsl3Jf6mBcn6NECG
	x/pS3M2gEaHmDClMo+DAsg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 466jhe2x6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Apr 2025 03:27:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53O0YnTI013805;
	Thu, 24 Apr 2025 03:27:49 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012015.outbound.protection.outlook.com [40.93.14.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 466jxpqee6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Apr 2025 03:27:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/bUr3zpHaCH4O8RnluAO1b7a9vagOAi0opxbzEUX/tfDhF8g/+ITjIpBCyKZVJ4gwSMWUqlKvEKqjYbD62rTDP5FEYZC2iRbV4MSXI4kgTGbPxkNbsk69+4xtOYBNg8LTRTjZfC70F3iE6eq4pN7Q/c/JmUb+u1PmqPMfgAo7A6arA1X516QF9wj1g/lsjkucOjxjZmG3irTY+d6ybdpHBChyr6v7cnfnK5Z/wDKe2OR/ls+wICZlek4yIGHt0MZlsaqolh3wdSIx+q7s3/xVgF4OgHxgvsd0GgKXhLyVdIrp9C1lnaWg/D0WkIi8mTft8ljPr/18ro5OPom/X1IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E9jyaLDe0ooLKdpsFHWbN5qGuKBgu5qmLS2I0Z4GmOk=;
 b=KmIPWbSj4yRHbndBMmzbr9LSgeBhB4xm4wDC8x/vlS4geVm3AB4OO9gH0TjfOMmyaI7wK0r3F761bstIrys6aXcGSvbZcjsyHMrqSRulFUbIBKbVKmOKU/t3gF2Hqee70p3StmCr5gWK3HzBWi73sGaaSFlt/keR8ACaTi6El6KgMar0DUcAWChu/p1gRe4/AKjlZ57ihtL2HduwBknpTRvSZxGil7nl/FbmZuRzZRa74zRrBQJOF2/3wKyPJL91HBfHdK36Z09jsQrRaixZCAG7EQcKobpmkslwVhVsPkFvA/DEXAxY/9MY/re3U0HeSS7NJGaH2PfChJ5ncEmIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9jyaLDe0ooLKdpsFHWbN5qGuKBgu5qmLS2I0Z4GmOk=;
 b=U8Y/4nJb5dBUTgODVNj6o/LiBbmle0OAFQzlbHOCJ9lsIqoe3SZUe7TXj6JY5m65wGMM7TIBizekBrQvgSxJnRsIZkE6fm7DVPW89EWp871wl+7x1K/NQHoLqooddaVRVx9CzkzOLkLjhKixzskOO1i9cTGZcWhf4suCR+EOoYw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH4PR10MB8172.namprd10.prod.outlook.com (2603:10b6:610:239::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Thu, 24 Apr
 2025 03:27:47 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%5]) with mapi id 15.20.8655.033; Thu, 24 Apr 2025
 03:27:47 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 2/2] target: Move delayed/ordered tracking to per cpu
Date: Wed, 23 Apr 2025 22:26:33 -0500
Message-ID: <20250424032741.16216-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424032741.16216-1-michael.christie@oracle.com>
References: <20250424032741.16216-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:5:3af::20) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH4PR10MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 59d7f13c-39a3-4fc7-7d06-08dd82dffbc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?72s9r+tha2Lx+iYxG2Dgar+J0skCsTMW7qJJZWiVOlDL58isCbjVGEu9PxZ0?=
 =?us-ascii?Q?pJi89/KaAG0t7URMJJt4vTwoNmNPKSOgApaRpxjFw4iX2sgMqsm6DHVI2ZlN?=
 =?us-ascii?Q?zhwLrZjB05GnSx8GpQlTE1ld8DJqYqrCPZ1F44n+LbHa8kRWN8e6GXUFb+wf?=
 =?us-ascii?Q?0xi7FZz7V9xBXWZdqNGNe/kK2SBwJQYPDMSI9YOfmdF8Jlh0z9RnGS1z/CL3?=
 =?us-ascii?Q?qwHhjN1+rJX1+yymZap0ULfa4Bfxxd2m2ushqyVaO7A0j1qUQy/J5e4wqBA6?=
 =?us-ascii?Q?kxhwRF7aGuOwT3+cnr2op3tW5Yq2856kGMCn1tzAbqlwXNy1d4Irx3VBVew3?=
 =?us-ascii?Q?5RPK9DWs7+VSu0SZXzipJFY6ymhM6ZTSx27HbFaauJ58KgxOKc68OxfOFkp/?=
 =?us-ascii?Q?VR9ZQSGNOvSZXGhKnlnQ2FinWO6LezJs43923MiFNSmKFgbGc6bodEonwnr9?=
 =?us-ascii?Q?852NZclGK9zrh1IwNwrImmlpNxI4czX0YlvSRw/EqMzyZ36G1ZW5ZuZ7h9Wf?=
 =?us-ascii?Q?Ix2qYhDbR+6MR0lImULApWB1yqw/3+32YZFvQE0Hxxy5Z7HY/9Sqxe/SwzF+?=
 =?us-ascii?Q?RTbdbiF8j/ZmiKfdlq+Tj6566zj/argCM08SNFljyZsONp73vUTG3kxW426r?=
 =?us-ascii?Q?1b7TuEghwVZZbuYauD51VbXnSIaXAZoPp43O82Y5A1Aa4DNU8xHa/AOWxMtV?=
 =?us-ascii?Q?f66+0XupHp9BL536zs9mk2MJAYs9WDCVJCNnBPumsgwcgWz2Vhms+4kQSAGb?=
 =?us-ascii?Q?VJ0stj49BL0KvwCUNbWTs4eXvR+PYtzNgrfT8BT3PzXXkyV0/pEk1QOh2XUW?=
 =?us-ascii?Q?+O02FS+1pwu8WATBoF7ngFsoqKlI7iMq14FAtQl2xo74LbAVKEiRSzKF6kAo?=
 =?us-ascii?Q?QiEcwlnqiaLJzO3wI3bO8AIS7VD8aitK6ma1meTgWYF8y8Vd2sZjF15Cl4lp?=
 =?us-ascii?Q?Ef9MffBqujLfuZ6ClP9XkP9DswV+dyJcrzQywujTUN/Qk8EH7FafoGl/lwF2?=
 =?us-ascii?Q?I90s7ztfjb9NQueRFO+5G8ktxyamsZrpee2BZMtDXZPHwK1BXLyevwkK5Yj6?=
 =?us-ascii?Q?bxjWHgnELj4YBeEiA2Szc+us5+V8+Joumn6Omn1DwrKdpEBt09m9uzXRC5/F?=
 =?us-ascii?Q?Zvf8fe5HYwZSuF23hH97PLCHu6NmeT59cstfZ2wwepN7yrjtx9U1WGwtk3Y0?=
 =?us-ascii?Q?tgGFoyryenPPRyUCm4HQU7vLdrWgFDXNhXZazCLQAi5T2guwEYWnDJDeRbah?=
 =?us-ascii?Q?+6nK44hrLInKznxo30+iqdZgkYbjdsTwS+rbNBuxIuyLy8zg4V2TWeBJ9FvJ?=
 =?us-ascii?Q?+KGs7Nw8+0hlrtM6kXB3NXk9fUhSPh+w3+eddw/QyoIws0l3enke9ePkSXAu?=
 =?us-ascii?Q?w2nk/9L8ge9ErTvlXx2ne4PPJdn0Uh6X3xBYF1kwWdQCRWVx/hm+dzG88s7O?=
 =?us-ascii?Q?Xs/b92TB/ZU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bNkJmvwTsChNS47pskOBGsYUlcGjfNckLor+mONIkowlz3onk6KBeoRxhfqi?=
 =?us-ascii?Q?TQAhACqtC0iITzaeMIELrVid3+JrTT/ncQKccLZW60U284EB5Ka9gLUSA+Fs?=
 =?us-ascii?Q?MGRkpmkAxZmF6EDRcmIN6X8267aIppRRkzpQ0idzoeN60HUzYXXf/BwhXwAI?=
 =?us-ascii?Q?uuvCOCMfMF4RTLWmwunkvG60Ytkg0Er77UpqJbsxens3bkvggS45e+CcZzXp?=
 =?us-ascii?Q?FJ686t3jx3yPpqK69hUdftlcpPmzRXUzsYWGucJWVAddqsQ0lL8LVKuOwT+I?=
 =?us-ascii?Q?2aq2DV5SZMCN3CXwyRuSQ2E0jbYYVZFEGDgijuUWWxFOU5ewSSppwbVj8moV?=
 =?us-ascii?Q?uvbWh3/gTUuw94UJ1pQw5vmuyreK4VfDz+WPC2TWh74qql0cmh8MGZ3lU96Z?=
 =?us-ascii?Q?dw7qsOfRpfoH71zPURDq13F5NVPF+lJs/w5XuFV9O6K/QpL0iyKCYPacbr3h?=
 =?us-ascii?Q?lOz/hlV7JY6m7gBlb9GRz8ErsSIFNhcN3eto4714KP1LfmEXvJJg3cbnEvtq?=
 =?us-ascii?Q?koEfrQBF91NKLOZRFKpjarpVPygEsuJV7GivFYRAYVyUd5FeU8ZlGn5QR9mR?=
 =?us-ascii?Q?0tkPxLBvMdvsJfzCmVZX1F1Jyh9HnXl8s6d43n7MsVc4vrbmTd+PP4oA8eH7?=
 =?us-ascii?Q?RHtPLrPru29Ve0ucpm71u0kKnsUpZ5VjtNmUH0cTyMSaWdfMW6OUpa9mWkhM?=
 =?us-ascii?Q?wgdbwYzxB1RpDHR0t9y0HIWXzQdGHctB8Q7ZXXIj1PKHxaLBl5G1tzDLrGXi?=
 =?us-ascii?Q?dQNyNEDSEALXBGq9LkFWLKN5B1V5noPqhThdqNYqtlIWIG/Iqjsp3nI8UwEo?=
 =?us-ascii?Q?1RAQ5IOEaVwCvITxDczmcoilN50SiA1goSYDcrgnp3qGfS6ytjz9Ox3WWN+U?=
 =?us-ascii?Q?xPA8n79QAYb89eRew3Ce3TFjiWYHm+M8GyLsinNGipWDUXaRwow7ZS7P0wz1?=
 =?us-ascii?Q?2wC0L3H05ypc9kEVSdRGxPFE+JuaQUzHgXkRCvin+PpW8lHuNcKKIf3Ful0u?=
 =?us-ascii?Q?B0E+QjIi62SeBw+bRRUk9F1H4ecL0NUSIMrCshEwFsvjkR+su0Lb7WlTFZhR?=
 =?us-ascii?Q?CntL/rLBBSP2m4qsp+M/cUc8TpwtEaMnoZl8ZJBqR6utzbJR+jMnzM6UQ+ae?=
 =?us-ascii?Q?/grfuWEja20jD/DlSvqq5SP+wncORkRz8/Hx7VlMwZLTJ7bywGLDNOqTdmjj?=
 =?us-ascii?Q?d7VEe7isQLk5glysWvsPiHBTC2oDm2lmQuUfqa/L1nX0JjDk8eiYZcG73HYY?=
 =?us-ascii?Q?A5tQE/xCi49zZGiomNQAWifPLKKAnDq9kFBjTBGF3nE2F9wgACru9GsJIr+1?=
 =?us-ascii?Q?R0Pojy6H+kBNYutg0R+JkLQzIJgM8NNlnc/R41qNmtl7WXKNoYoOfYoWxM8C?=
 =?us-ascii?Q?k10qgky7OV4SQ1EZcxYJKDXmcrBxFLUpO5Nwxx3+jM+HMhQihWZMUGZzjqUI?=
 =?us-ascii?Q?n3OdwwRbdX9FW+E20gUrkCWDfpWls7rC+qDl5jB/9MJ3Y1zMddlz3+McRIxX?=
 =?us-ascii?Q?J5rBJnauZ9ohY2kvNqJ7bGaeBbK1asY7x3/pr0wpJ/V+80ABDUOXnAwFfYER?=
 =?us-ascii?Q?Ele5tICDy8krWs4+v2hchw26pMv+F87kzyZTzSWw1cZj1VsFLiZnW2BP78Ep?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VOarf0/84NcVFe4U6HIPERMK/lhVMy6OA6rQMiRqyTtTG0+lqNhoJVaYXAP8+QvVO0qj9LF+FnSMi1y/osxpiRCIinYjpuKADhVu6EN6AFl8VqyPgziWLPfQHKdNaqbqwkhp9ON5rL+ZW/PgWsra/4Xpxj7G3GWGGJtE3JExTXPPC7+v1a157rJs2nKfSNCC3mexI+FbOqu9K3j2uxRz5+zpLYGhSWbe4RIuX+RgW22qWmun/t7nvN1/Ub0YsDSlWnF0Kz7G+gClm8RHJKEvniV0TzeZEw4EH9B5nBp8TXNlh4bxb73TpubmHiZ5nLNt7OsFsVwpglf4KKUGpKUpy+fneUWCAQmSEp384XujQUjXestF2DpIvtl6QnAeucObT96NEBptSccX9AZkbAuf+MrlZhJgfFtjp4hS9T2H4jR+qlChiSnZwSgOdIap3zY/pr8I7FnPYEIp9kz+EbcsGqwatMPCHRoCcKF41aJ2I1vjjty6dElhfm8q6jvJNzhdzY3zL/yOxoUnOKyGNhhXJNq2VCvwGfPxh9Axjaj6Zs/3z5LCHNWY9mbyo3chd/5czGDDgg4LaH4ixNVFK2y1MARetf6aIussZdP74AVCBzU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d7f13c-39a3-4fc7-7d06-08dd82dffbc9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 03:27:47.1563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /VUQedUQum7aUcyrwLdKdGlaYDneMaBZWtLmlXG5wJRNJLW8UXjvrB72I80ddioYkBdx95JCW960UrLOd0R7RJstkYrYN2jX7ub7p67Q5/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-24_01,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504240019
X-Proofpoint-GUID: j253v0IRVkUxyhMl_saWmsDGs2g9vQg7
X-Proofpoint-ORIG-GUID: j253v0IRVkUxyhMl_saWmsDGs2g9vQg7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI0MDAxOSBTYWx0ZWRfX7JTUABz82Cgw SHLxUxnAUkk4tiXnbCg4S/EtFcpsHqb8+Gtc5dYjLFqdK2hAXQwZNmfiUZVtLXxF2BPoDnrhDrt Ks1k/Dp56KKxI3Y1N6J1HzAvXkxqAeb31Q3mMriONFnvplDLGyo6artNFnBEq6eZrk4WIn8kUb0
 ObQC47F8HGBmBg5oRC3oLnf5cE841B5xMmr+POgWlnYAXB2NzU6DYGyc9j8diBuxIhHlgaUVXdQ oFENq0uA5aANF72A6WiBkYU1Hy6T5KP7aCRsGvVzS+MR8sxtdOU531LFDI27SLRUEhenB+L/nDj N+NKvwwX1njvic544YWzNZe0kX/8jW99TidhpFmpE122GpM2dVm/W5PvWuIE2gZZ39Y1Qkmfwvi JOvX0Eet

The atomic use from the delayed/ordered tracking is causing perf
issues when using higher perf backend devices and multiple queues.
This moves the values to a per cpu counter. Combined with the per cpu
stats patch, this improves IOPS by up to 33% for 8K IOS when using 4
or more queues from the initiator.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    |  20 +++++
 drivers/target/target_core_transport.c | 119 +++++++++++++------------
 include/target/target_core_base.h      |   4 +-
 3 files changed, 83 insertions(+), 60 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 39aad464c0bf..7bb711b24c0d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -700,6 +700,18 @@ static void scsi_dump_inquiry(struct se_device *dev)
 	pr_debug("  Type:   %s ", scsi_device_type(device_type));
 }
 
+static void target_non_ordered_release(struct percpu_ref *ref)
+{
+	struct se_device *dev = container_of(ref, struct se_device,
+					     non_ordered);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->delayed_cmd_lock, flags);
+	if (!list_empty(&dev->delayed_cmd_list))
+		schedule_work(&dev->delayed_cmd_work);
+	spin_unlock_irqrestore(&dev->delayed_cmd_lock, flags);
+}
+
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 {
 	struct se_device *dev;
@@ -730,6 +742,9 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 		INIT_WORK(&q->sq.work, target_queued_submit_work);
 	}
 
+	if (percpu_ref_init(&dev->non_ordered, target_non_ordered_release,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+		goto free_queues;
 
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
@@ -816,6 +831,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	return dev;
 
+free_queues:
+	kfree(dev->queues);
 free_stats:
 	free_percpu(dev->stats);
 free_device:
@@ -1010,6 +1027,9 @@ void target_free_device(struct se_device *dev)
 
 	WARN_ON(!list_empty(&dev->dev_sep_list));
 
+	percpu_ref_exit(&dev->non_ordered);
+	cancel_work_sync(&dev->delayed_cmd_work);
+
 	if (target_dev_configured(dev)) {
 		dev->transport->destroy_device(dev);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 05d29201b730..0a76bdfe5528 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2213,6 +2213,7 @@ static int target_write_prot_action(struct se_cmd *cmd)
 static bool target_handle_task_attr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
+	unsigned long flags;
 
 	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return false;
@@ -2225,13 +2226,10 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	 */
 	switch (cmd->sam_task_attr) {
 	case TCM_HEAD_TAG:
-		atomic_inc_mb(&dev->non_ordered);
 		pr_debug("Added HEAD_OF_QUEUE for CDB: 0x%02x\n",
 			 cmd->t_task_cdb[0]);
 		return false;
 	case TCM_ORDERED_TAG:
-		atomic_inc_mb(&dev->delayed_cmd_count);
-
 		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list\n",
 			 cmd->t_task_cdb[0]);
 		break;
@@ -2239,29 +2237,29 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 		/*
 		 * For SIMPLE and UNTAGGED Task Attribute commands
 		 */
-		atomic_inc_mb(&dev->non_ordered);
-
-		if (atomic_read(&dev->delayed_cmd_count) == 0)
+retry:
+		if (percpu_ref_tryget_live(&dev->non_ordered))
 			return false;
+
 		break;
 	}
 
-	if (cmd->sam_task_attr != TCM_ORDERED_TAG) {
-		atomic_inc_mb(&dev->delayed_cmd_count);
-		/*
-		 * We will account for this when we dequeue from the delayed
-		 * list.
-		 */
-		atomic_dec_mb(&dev->non_ordered);
+	spin_lock_irqsave(&dev->delayed_cmd_lock, flags);
+	if (cmd->sam_task_attr == TCM_SIMPLE_TAG &&
+	    !percpu_ref_is_dying(&dev->non_ordered)) {
+		spin_unlock_irqrestore(&dev->delayed_cmd_lock, flags);
+		/* We raced with the last ordered completion so retry. */
+		goto retry;
+	} else if (!percpu_ref_is_dying(&dev->non_ordered)) {
+		percpu_ref_kill(&dev->non_ordered);
 	}
 
-	spin_lock_irq(&cmd->t_state_lock);
+	spin_lock(&cmd->t_state_lock);
 	cmd->transport_state &= ~CMD_T_SENT;
-	spin_unlock_irq(&cmd->t_state_lock);
+	spin_unlock(&cmd->t_state_lock);
 
-	spin_lock(&dev->delayed_cmd_lock);
 	list_add_tail(&cmd->se_delayed_node, &dev->delayed_cmd_list);
-	spin_unlock(&dev->delayed_cmd_lock);
+	spin_unlock_irqrestore(&dev->delayed_cmd_lock, flags);
 
 	pr_debug("Added CDB: 0x%02x Task Attr: 0x%02x to delayed CMD listn",
 		cmd->t_task_cdb[0], cmd->sam_task_attr);
@@ -2313,41 +2311,52 @@ void target_do_delayed_work(struct work_struct *work)
 	while (!dev->ordered_sync_in_progress) {
 		struct se_cmd *cmd;
 
-		if (list_empty(&dev->delayed_cmd_list))
+		/*
+		 * We can be woken up early/late due to races or the
+		 * extra wake up we do when adding commands to the list.
+		 * We check for both cases here.
+		 */
+		if (list_empty(&dev->delayed_cmd_list) ||
+		    !percpu_ref_is_zero(&dev->non_ordered))
 			break;
 
 		cmd = list_entry(dev->delayed_cmd_list.next,
 				 struct se_cmd, se_delayed_node);
+		cmd->se_cmd_flags |= SCF_TASK_ORDERED_SYNC;
+		cmd->transport_state |= CMD_T_SENT;
 
-		if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
-			/*
-			 * Check if we started with:
-			 * [ordered] [simple] [ordered]
-			 * and we are now at the last ordered so we have to wait
-			 * for the simple cmd.
-			 */
-			if (atomic_read(&dev->non_ordered) > 0)
-				break;
-
-			dev->ordered_sync_in_progress = true;
-		}
+		dev->ordered_sync_in_progress = true;
 
 		list_del(&cmd->se_delayed_node);
-		atomic_dec_mb(&dev->delayed_cmd_count);
 		spin_unlock(&dev->delayed_cmd_lock);
 
-		if (cmd->sam_task_attr != TCM_ORDERED_TAG)
-			atomic_inc_mb(&dev->non_ordered);
-
-		cmd->transport_state |= CMD_T_SENT;
-
 		__target_execute_cmd(cmd, true);
-
 		spin_lock(&dev->delayed_cmd_lock);
 	}
 	spin_unlock(&dev->delayed_cmd_lock);
 }
 
+static void transport_complete_ordered_sync(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->delayed_cmd_lock, flags);
+	dev->dev_cur_ordered_id++;
+
+	pr_debug("Incremented dev_cur_ordered_id: %u for type %d\n",
+		 dev->dev_cur_ordered_id, cmd->sam_task_attr);
+
+	dev->ordered_sync_in_progress = false;
+
+	if (list_empty(&dev->delayed_cmd_list))
+		percpu_ref_resurrect(&dev->non_ordered);
+	else
+		schedule_work(&dev->delayed_cmd_work);
+
+	spin_unlock_irqrestore(&dev->delayed_cmd_lock, flags);
+}
+
 /*
  * Called from I/O completion to determine which dormant/delayed
  * and ordered cmds need to have their tasks added to the execution queue.
@@ -2360,30 +2369,24 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		return;
 
 	if (!(cmd->se_cmd_flags & SCF_TASK_ATTR_SET))
-		goto restart;
-
-	if (cmd->sam_task_attr == TCM_SIMPLE_TAG) {
-		atomic_dec_mb(&dev->non_ordered);
-		dev->dev_cur_ordered_id++;
-	} else if (cmd->sam_task_attr == TCM_HEAD_TAG) {
-		atomic_dec_mb(&dev->non_ordered);
-		dev->dev_cur_ordered_id++;
-		pr_debug("Incremented dev_cur_ordered_id: %u for HEAD_OF_QUEUE\n",
-			 dev->dev_cur_ordered_id);
-	} else if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
-		spin_lock(&dev->delayed_cmd_lock);
-		dev->ordered_sync_in_progress = false;
-		spin_unlock(&dev->delayed_cmd_lock);
+		return;
 
-		dev->dev_cur_ordered_id++;
-		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED\n",
-			 dev->dev_cur_ordered_id);
-	}
 	cmd->se_cmd_flags &= ~SCF_TASK_ATTR_SET;
 
-restart:
-	if (atomic_read(&dev->delayed_cmd_count) > 0)
-		schedule_work(&dev->delayed_cmd_work);
+	if (cmd->se_cmd_flags & SCF_TASK_ORDERED_SYNC) {
+		transport_complete_ordered_sync(cmd);
+		return;
+	}
+
+	switch (cmd->sam_task_attr) {
+	case TCM_SIMPLE_TAG:
+		percpu_ref_put(&dev->non_ordered);
+		break;
+	case TCM_ORDERED_TAG:
+		/* All ordered should have been executed as sync */
+		WARN_ON(1);
+		break;
+	}
 }
 
 static void transport_complete_qf(struct se_cmd *cmd)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 05e3673607b8..a52d4967c0d3 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -157,6 +157,7 @@ enum se_cmd_flags_table {
 	SCF_USE_CPUID				= (1 << 16),
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
+	SCF_TASK_ORDERED_SYNC			= (1 << 19),
 };
 
 /*
@@ -833,9 +834,8 @@ struct se_device {
 	atomic_long_t		aborts_no_task;
 	struct se_dev_io_stats __percpu	*stats;
 	/* Active commands on this virtual SE device */
-	atomic_t		non_ordered;
+	struct percpu_ref	non_ordered;
 	bool			ordered_sync_in_progress;
-	atomic_t		delayed_cmd_count;
 	atomic_t		dev_qf_count;
 	u32			export_count;
 	spinlock_t		delayed_cmd_lock;
-- 
2.43.5

