Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1531D4334CC;
	Thu, 23 Jul 2026 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799463; cv=fail; b=QjreT2kQYua/OqAAvqX0Fx/g8tw0WBoeMDwbUts8AS/WwtkLEVWRGaHsF9vKYPlrgyJK3EG5tmDzqrK1av9cruOkd/g2MrXlXeHvLijiGI9ynApVfDAwm8m/1rZLe4QPmLmSJrCxqXPbU1ZMMCvp3na6KvtjX28a1Q5rGmT8nOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799463; c=relaxed/simple;
	bh=w0BLhbk9mRIx1gQjf0SlS6tyIl041Gpu+sle4qebvvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HF0qcN46ASZ6t8zoAQ4dsI79nKhVUeBbH8BFJESzr8YKq9/D/yNtZruFy75W2poa24AUn9wxXwfY/V6JiGnPbxvB2OLV5/c12ACuwHf7Xc7l3NWZuB2zrJHaNIMUCGVnMmNwq25d1MrriNNicrv0IxbvRQ1pPOJyMUw0vS2aX68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GJfN5yXv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XkVqKNbU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GJfN5yXv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XkVqKNbU"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtfKe3360384;
	Thu, 23 Jul 2026 09:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vHgOPiWqppdif2y0QFBAPDqvrX3HhcXZc0qi0dTxj1s=; b=
	GJfN5yXvwbF1SOlCxMt5Qjj0DrFrTTU7x7FQBNf3+6CESivjC069xjqOuhlSj16l
	RJ+bxjGh9Jq3cnTJ1t0yKXpuXzsOeR2ZSQaRw9bO8ArE0exNNxYx9r1PSAFSTmeT
	K+D7/9ocERvhmZQz1cv8/0SWV1TJFF75+8y+jWwDqMZc+7yVi9BExF4uTKmoYMc2
	STsPn1aSpmPygy4ZkLqoWRsBIiVZ5bEfgNL9oRbVbafx/zQF17vZffXBg8tak7HN
	24Ks53NCNBvgheMvOiAnr25tuazQ+c1ERpb2XuxM/LxkL4aVb/2l0LNhdc3KYLS2
	HVMKd4PlGHuiJmjLV511ww==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q6mvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XYW6029990;
	Thu, 23 Jul 2026 09:37:14 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010013.outbound.protection.outlook.com [52.101.193.13])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs5xjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ftYQkdNhgIFZmFxMSn4XE2hLxfByzkir2fSZ5IZSs4ocn+OI0zujcdToc67pDLQqtTRKI+w1E4Vluvh1eYMOhQp0F0HYjyqljbpJyuMSkysCT19rCVk+VO3TcGyml/QRQEMeI2aKL+3TQdpMI0MAsE8JGLgJvBZu5zOgJ3b0A1MxrVTbO5ifhFLsoIYu4nDzcTjKwJpmKz6vYnDNSGMraPI0DrpBhm0ZTJd1ePEX4qklV9l1gHNhw++TeWjyJl11aA0w5mFZOrvfyPGj/kPTzR0DDnEJkLHXk1jeCY0Ekh24ApK4OEO9EQn6skCNJsppEdDkZcY6o7EUQznHLb24ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHgOPiWqppdif2y0QFBAPDqvrX3HhcXZc0qi0dTxj1s=;
 b=XEi4ZmPxUYWFfKFC8NLbOIiD97qMGNTKpDJcO8RPmxLNjoSUa2FLZVDaGqLona8lH14ErXov4ENZxIJ3a9vlvt59kndmnpQ/TXLJqOJHj6u7nUvuWq2vle7E6FUuqsMQNLcQqCgTcg6pkefiPXIDRZ3rn5aXCuVvqQqDDgdtRV0Vjn29KD6RW8D9nbKNJ8KNvBw+bQD88PXq0/NJTVCx058X3sWzDoZICFA8AH2TxvkpYj6YH7rkpUikHta6J8qMhquZUTDMsnz2VvHL7FPHi5KimtwJUGcfPGgHy/+pAmUkS/q8xY0nrvERELnZbge6Pake4e2XiC5MzwW4M5FEXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHgOPiWqppdif2y0QFBAPDqvrX3HhcXZc0qi0dTxj1s=;
 b=XkVqKNbUZA4VBSv71EPHLyB0K8aDZ4UbJDTpCB7GlyLgRsi01w7pkhpHK9RU0/i1IyHMFjMCsSuU+OuXMCKTeFRj/BaZMZz4/BoyIaIY4vvwAVvJhZSfXdwHhLN62to25BDzLJHB9G8NC52lmWfOLhSb31pKc6V+uf4kkhgKXWw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:10 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 14/28] scsi-multipath: provide sysfs link from to scsi_device
Date: Thu, 23 Jul 2026 09:36:12 +0000
Message-ID: <20260723093627.2327456-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:610:74::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eb70311-6deb-45f4-a05b-08dee89df7c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CaOoL1O2/uNE45cCHKIIUGtCkjmZd6wPhfOHFiNFMfCOOeGpk4SH/F5ZuJe54j5sbHC2FIFsNRx0swUoBOUWsiuubFELrlrqK6qNEgBKdd4ClP05cU3cpsDtMVgl7FKk2dmLogsmQiheS41YD4JZE9kYjtby9kUF1eb9qmKqeG7EpTZA62kgphaRwkmPwkO2qFHvRQhRYenl3MYlQozoSMKM+c6uH6apuDn0+5gR1f1kl1zCkalprfB3QMtGbhD0KO7BODz2/rtjxd3I25Bizd21OojJM0a8Akwz+DBJqkYJOhtMQJ45JE9LnBhwvUEU1sHGJmzlMDSqEftLWfh2rq5PbqyhjhPW+YOUhDcYrvVCLxFyRXrbW2WYuIVWIjQTRnqc76QAow1ySloLVeaBXA2Pz9U7OEpM1xle2C+VKi4xGCaj+AghbFLEfvte+zlBlcdFtA+q8C5TXDStbhYFN3NA102FVp0dPynAY1qs9WyuO5Or4V/LXilreVHDyCV1XZfa8EQH8GySJ4U8+xIZ3IV4lDpplMJ5EI7V9v3Qz0pYSasRJimFoAuIoBpp1wmWAkF0mC3oOz76UDGr6uhn40btyhRnULY7OQfXjD0yD+v6dJJNiJvHL6EHHiYilwaN6MvkSCQ7AlleWpY1pYxw9ymMrs1X1NNN1WdYKeebzgo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IgZZR6VXw6mwotLSY9bu3y16I+OI9/SD78zBF/uOsVpFcu6W1p6D/1c7c1E7?=
 =?us-ascii?Q?3TYYhFd7/pQcK5YX4loMTmcpUSgJVTC88DnvYow14oVssMZG+CyKh9mX/5im?=
 =?us-ascii?Q?fAe6Jd4dHpcS0WqL9SP0neAUpRgNcPpb3PLmWuwS+Hw8Fonb9g9epGZPPRWh?=
 =?us-ascii?Q?Mk0PdCObb8CLs/5/akc/ESSJ6ugee2A9wNStT5U2bLpPORohA+jv05z7l8fx?=
 =?us-ascii?Q?3ksDlrchIPuCmJTZbjy5cLUyjnH59HvZcgr2x1Yt3BMjT7Zx0hTDLXOMJmpj?=
 =?us-ascii?Q?6e82D3fRsc0tvZtIz8LcooIPZ9YZilI1w2HBa2j7JmBalCCQotzpM/G/xqRD?=
 =?us-ascii?Q?99Bpx9QVZKrLM6SKWFTV9wlLRsYB6NT8NB46DtIflq24CZkIIGMVwdmygM1y?=
 =?us-ascii?Q?VTxuuciyNAuFgrN9dChNxXPO/xp29E7iTsm9n8OXHlciOmpCVqYF0eao7Lpp?=
 =?us-ascii?Q?bPjMOGHVZmbfB/89D1VfcjCxwUrw4STvkWp8jpgj9aOFdjgFkH4LAm2blx7i?=
 =?us-ascii?Q?Q8r8jtmMyH9DaHBaZ4OnUUr5pGtnLzWLES/7yWFLsjNzCG9afQAkBMc+EjlW?=
 =?us-ascii?Q?MWJCzSg+Hc17M2ENhqbnjEoHRzZS4DwWOcyf+D6VzQgFg1qz5CopKofxZlzD?=
 =?us-ascii?Q?fEcO8hNaqFB6ZEtTwQuVqfLI0IYlZliZtellvWVlWSmkLHlLA+SnKDmlSRk4?=
 =?us-ascii?Q?jEAfK2p3OenKUKI3PaWzpO7VgxWbCtoJuIBgRPl4HJHVhF5VyTdcPdXFxfVv?=
 =?us-ascii?Q?HtRqB24axTTekmMtnX3GUm27NU+uVwrI3rIRtqLUr54Q0MKPMIjctuYfV68V?=
 =?us-ascii?Q?JUPngVGxESGxcDH6bJ0e1aMDjr4UT8LgLODsAN/mD0ddGDlv2Be4Emah7nCg?=
 =?us-ascii?Q?Xnda2FkafdAkBIDj9s2UpuFvQXXu/c/Oi7rxiCvJk4qAlIKUbp/SjQDq7we3?=
 =?us-ascii?Q?7iHp/09COE3Q+sZdb5xZo1AhaE2hJTlGc4O7nb0Nhua+/IPnEZnUWXnf1SIC?=
 =?us-ascii?Q?roZZHPNXGp7nTkFY0e7m43Z+Zkze9kjexJb68qrcsrL4CPMsmK5r/tfGm30b?=
 =?us-ascii?Q?igPQXfwueCKEtBwcT1avVIoekrLwyT/K/tdT+ZGhCBVxXqvHdGzGQG6lWwws?=
 =?us-ascii?Q?H9O/S8w2E/gQ+Cvok+lQV4qVEJXb6Lk4TMm8MU3whc30ds77R99odTGKSTq2?=
 =?us-ascii?Q?x/0XVGW+t5GINiY6X41A0W++17SScMoBN4NzdQe7YnA+k/I4jnHeb+d/4BUV?=
 =?us-ascii?Q?EhD6MJtyBVvwrKl8+WbcOg9uD3cuaOuNUx7WUcAa/4Wl54mMz2xFpdzCE3Ig?=
 =?us-ascii?Q?+MTn45mdHFYM4fAK4Zcz4H4oaHWcT5jUBVM262lgQJcBg+wrUgK7dBkzMzcI?=
 =?us-ascii?Q?d1mxjXGYkQVCM6SfNivXZoObY46SavT5WXsCyddfojHc3PCPhtQpIQZXoFUy?=
 =?us-ascii?Q?BJMMPf1DRdQ/eIrwzWQhCdJ2dfqhZK5WpVcozk1yaKWuUAwcH83VkFz5zYI7?=
 =?us-ascii?Q?nPnQ27O5BRa/XnWt4NN6mNOFNZdwMtgbz+oO4sdOzd+mmGqIKOxQbeYSjHk6?=
 =?us-ascii?Q?USLh0PJHrhKhZ+KNQUsU95dAlF2ovQKzIXjCOElHtr5nbA535zY1Uaecbpgj?=
 =?us-ascii?Q?9aeruRKzRT1yLRZuozYFtepkuBfC66J+xQ9smNFRXWkMpRBKC77IZO88qi5i?=
 =?us-ascii?Q?y/kc4US8IkR0Bue5NVLgdrocAH6f76W9P9kZQlF8MFFc3P8P7IxcsZR3QIQ8?=
 =?us-ascii?Q?bdSsigLUfnHnRMzaEP9COwFSPzobgiA=3D?=
X-Exchange-RoutingPolicyChecked:
	JHUhQiAKB4DGUoG8r07gZ6wGzeP3ZpEL1lR+ig1092t1l/jeIBMD6PvjZgDrajGgxo+NrXTmqACC3pxRbWb9JyhhGlhP4SiaDh/EnI3Bn3VnSBWTiNJR6ep6kQb8gxHyTn/IU77bQreSZobIepVIJfYix2VxKZwooqR6I1E7yvMc6GXu49h5bGk4X7xmCOGhNXvwfyKMZB2NAroMzWToma7m+ZxZRZcfVXW5eq6b4Ns1EwXYDeZBoxWrlERFcHfoIsaosnY/O7JTPtriDS3U1hU+CPca4eVX1NXdjJkKS4WIimbgbIRGlAVxFs6jGZyo+Niezxd0fdPHZaziBsc9rw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zpaEywa5uO8byPCsg0QQZX5ScjNbbTVOtNrBcX9Yh6IUZFdEdgjRYjs095Cz4MfZ86ysrKGWmiumruasjuURWCYZpbUeoahbq1v0BfMThxUwpqPpUwCZ5uB3rDLivSSsF7lRQ1yg/BmTycAyBBXFAxgDB8w5e1ww7rjIRSuTZc5DCzLQoDSdEkKjAYOx0B3qQCH4tHOCsBcJ94C0hMSPx26u4MVTr4VCrtYLkWdurgObVGPe4wuR6dcmaqdVtcSDshp6TTBPbT63KwD9E+7nNCYREE1Pr6FNZSpQyRBunqmfHlKBYUoyk/WHjCyiODEaO7b6VMFL2KpYThHREqhCJDYqjpTMwkuYeFghLAZs/JQxicDd5vyoB92BcELg0Ka/nZ2nMc0ccET8X3g9R8tVI3CzNb7qzo4I2tK8kdXwkHK17r9EEdVGHRACbA7OL3xUGYYXdBlPieOmDZeVlr0aZAagrcAxVPFFsmgDiDF+VW8je0cXytNaa8xMIthUrRzrcorWIdunkdnaIPw3ZNG9IbzsJzj9nKAr29LPH40JnVtgo23WYBq1IazRtY5OQ1RFXFchgKLULqa7c6UZjjijafCc6i5TKSRj9ZGIwyvbUu0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb70311-6deb-45f4-a05b-08dee89df7c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:10.1397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+RmSvp67Oajl+kaN0T67TpRn5IqFl18Sfbhi5X6wrwiZKD1thCusAaG/rhEB/S4eARhriwde2KEMnWIp/HSFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXztrmpPbL1sMT
 9G9Ac7NvlBPffH5tsAUcAHIJI6GAcULibdsvNB9PpBol26ChzaPGgJLvsAAhUG04VdRlSh3I9dp
 17+zpSpgqw2f/kTspgzCMyJEdVWyCc6I6+YvMi8uE3Cz9lCZQIR/s3AkrvGO88m3xgYAOu5kAa+
 dhOY9mn2Nzunqj5eJ3Ff8zlL1y2beNdpu2rMqiXypYsKUZlu+j/rwGZszGO5eo6C3W9lnys23Re
 QI8CvsEVE2iLp8FKkc6kNNOEu/WiqedblK6tx6dDeH1Uc/nqg0VSgWKJVXNa+IJNJ/kD6LrFew6
 GLF3RF7v7CxgIl71CbyKdurOMis/crUdgxNNPpy42MYMsnY+8ITHv/jT7u6CSx0D69HtaAalEwC
 RnTxmYqcz6RrDBGE3jT7whLWRu1e5sAuYEvQQ/VpQetR7HtVc+9CsD+t+LiHeoalvI5Dd44pbcm
 p5U+q6Ie7SxffbsZU+6B1/z4aQsJz82vWrUoVups=
X-Proofpoint-GUID: T7ykGg2DnDjRkNKPqeOs-C1SWPYVZwTn
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXzzQST7uJy69B
 neGtseJ9FJbcWES2dFgaCZHa/zr0K7YJx4i0zbC5cdXHm5zuAbHQ4+Q4dZYKTiPfIH7Z2kcD718
 ZJHYWlxEGrRbdZ3n25WvFx6U1bD0ez6511CS4YNvchhj07mVMR02
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a61e0cb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=ZbQ-JUxe3OK3M8wTWUQA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: T7ykGg2DnDjRkNKPqeOs-C1SWPYVZwTn

From: John Garry <john.garry@linux.dev>

Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.

An example is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 43 +++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c     |  5 ++++
 include/scsi/scsi_multipath.h |  8 +++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 609f8009e4ac3..59d1c0b2d3441 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -111,11 +111,54 @@ static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
 }
 DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *scsi_mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= scsi_mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs),
+};
+
 static const struct attribute_group *scsi_mpath_device_groups[] = {
 	&scsi_mpath_device_attrs_group,
+	&scsi_mpath_attr_group,
 	NULL
 };
 
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+	int error;
+
+	error = sysfs_add_link_to_group(&source->kobj, "multipath",
+			&target->kobj, dev_name(target));
+	if (error) {
+		sdev_printk(KERN_INFO, sdev, "Failed to create mpath sysfs link, error=%d\n",
+				    error);
+	}
+}
+
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+
+	sysfs_remove_link_from_group(&source->kobj, "multipath",
+		dev_name(target));
+}
+
 static const struct class scsi_mpath_device_class = {
 	.name = "scsi_mpath_device",
 	.dev_groups = scsi_mpath_device_groups,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6bbaf424bd4a..9c4f8d4a6f42c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1443,6 +1443,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_add_sysfs_link(sdev);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
@@ -1495,6 +1498,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_remove_sysfs_link(sdev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 50298056181f9..a9fd02bc42371 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -46,6 +46,8 @@ void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
@@ -82,5 +84,11 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+}
+static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

