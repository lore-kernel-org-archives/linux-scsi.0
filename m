Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDB93BB69D;
	Thu, 23 Jul 2026 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799600; cv=fail; b=j9yWBARHXZpjRnds4ipscuJzgNWzppawOrM6ANwaooiIeW4A9DAthfJRsnvsReEs5IFIm5BwqLuwH1ROvkhAWjvfx7/xwZoFx5Hf9LXqiiMfT5dhd0bDtQJcbcOjS9lQU0kYDhMc53KmNA9VbDSr7rLpQwd3sDMkflNT3KLJxlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799600; c=relaxed/simple;
	bh=4XMYoenVRcfywgZiUXxmJDFt29QOdkYWaCo7hrGcoOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nXTNNmChf4f8tdlGsgNteJhhofBpJPriNIH+q7AQwgqd6fEMeTXyPOdQYhkFSiUiDNPno8QzMVBuKHaet+GZAU4suLSh9IgDj6s6XiR6oZ7fj5Bleu/BVb8kYj7OSq1sDMio77u/fKDbR/XvNWzPmybbcVdUCQ8mp0YIQ+LOxi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h5tcqrng; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cv6YZ85v; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h5tcqrng";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cv6YZ85v"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtWp83391720;
	Thu, 23 Jul 2026 09:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=; b=
	h5tcqrngcQRTmJ1xwP1AYwCWOeYJW1jO7h1DCuHe1nbF4IccvYlYvjuFBSPPamph
	MoDa+lB2Hz0oPhA6bSSNkiGz+M/qawygxbe+MBYgMUMkIMYVmfL86bnQRSAkX9KZ
	0kuQIgP5feGgWoDpzEWmk7rBKhGdGEGDkmaeLEjpCMlIp4RTNz1KPhM4Y1x2PDYd
	hdIM9oInan7AaVfbTjh1iJ+hS+4lfYC/KSV9FLu6p7RX8CbUO6kjiLq82ZkGWFmN
	aIOgmrmDGEmyc9TckzI0ziEXlH4ehKW2lH+DpNudSVH7hVMMqyCmfNNZ6iKzWqOC
	PS5uK3skBS22yTCrHIgWPg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1tjxn6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X9QK021137;
	Thu, 23 Jul 2026 09:37:28 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010049.outbound.protection.outlook.com [52.101.193.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y4cn-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhALQPeqW1MX+jZaeIcVGD6fOrMR25rUAfgt6leDbamNq8BIi78BosOTZIeIWkrgFJ7GIER7ZzUe8ZSSkF+M+HCOdwzgUWdzV1VWJ52rwLctxRNWJ/T2ohFABVr2y9BEQ2lVDHiqU+RfSdPHPncOC9GioBOlZi3fmgK0+SlmvpDYuIMwoNlw3ivA+z/HvW+ZihLgZ0db4pMgfOPGCIox+J9XiCrvWnCWIc+aM5nqOMZG3HM6FKOEHSqnSvUau5vVgCNnAMgG3yYmgbS8vnC41BLblq6vTTQI5AF7HsQI7OHGiG4EFRSj50WCO693Ebai/y8V73hLRwf8ZKE2oGKaZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=;
 b=Fw/p2YrRTFWchDsVAdehxTp1egaozsz1HS10pEzG1vhW3gGg+Ba4YmThna6nJhuJwRk1uGC7XT2PabyLkq2fnWUfgoCay0zkFkzr4ThKgB/vEaJEHL9Fma+TUoGB1AxR1ygewR1YQGCha0PaHtizHWkQ/iNnpvh9q/esyWhDr9soplm/f5lU95rG3+oQT886M7FX3Io8wQ3AbOCKCqzjibkQmfT8lPd2JZWA/7f8j7sosFokMQXUx7SRjI4PPfTCMZadMwCCKVx+TDmG2PKA4VCxhhjJxefjQDU4zTq+WCwN+913ywEM0KQ+QtarqVQPzaXdAmXUsj7UtIa8pXp8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=;
 b=cv6YZ85vulyAQ4KKVzV8Nc2jVSvi/iC8V1+pjF4i6HDVxQzbohZYRXQj+k3FKD6Y87D32InFCquEzNybGPc9QgiyP6XKtrD4Za2kNvT5iX1JZx4iOtrTXlVHnYaF9/P4XUmskU7ehhUbmdCNZWsZh0w63LNHbpqVafxNhCpLW9Q=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:25 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 24/28] scsi: sd: add multipath disk attr groups
Date: Thu, 23 Jul 2026 09:36:22 +0000
Message-ID: <20260723093627.2327456-25-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0029.namprd20.prod.outlook.com
 (2603:10b6:610:58::39) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: 1de55e18-ae54-4776-eaec-08dee89e00cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|20046099003|18096099006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8qAzErHai3zEnNQjC6je+u28IDapXQTYPnvHyrfRG9VBA1FGA491fXNw2NGGTYAWvjIO3dF9361WsJbTXLvAYRSEfDs8DffLdMFxTleLnQqeypOskJoqLFGf66sTjNYOvbPmXmeBYf7qL2j+JwRs+nqXbLvMvrB176zukpKuTQy4CX4RUO6eJlF44tUNPX8utotgfqFLvRUTSrQUBEoJKdRJEAokf6MfaW8LCrvtqQI3isWiwASQAn7YStD9lk1DbnShZ4qEUqzMU7fqgjN08OOj2bbVNezbhJpfqYka5drW7Bh2wMQ3IYf/CpPGQNTp56hPWuXH1Zsr0QknMzp5W2SFJjCfftiXBtDc2FZ9s21LhJGvxMhv4iCQg+1FCSEWeAaX/E3VpLb5LD9j3TRjurUUQJB8uMc9xtXHI+EbeYMD9VQ/PX17InCJM7xUh9x0gjJTjO97YiTflSnc1ZrWNRDnVzwtpFQbx/MpX/rbsD6Jbg7SxkCOFWT1h9YE1Czyp0ljJNY1uIWCXbEpnu45Of+q3o8bH7bMLPCjxaf+dTG6Dr2kIzPNHrQgOaEEx/UXTG8spkgWrDWgOYhTMYEHF5eFKat8Jrj+79vh4qTbVDGa4O66uSixCDIhxLo9/RJqyTEHYIVNZP/wnZKdhFx1H5ZwAJjBeF35ZknF+Br0yf0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(20046099003)(18096099006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8UuNMTgGj3gPKt1v6Tia0/sAoq6Z6TheURJ22cqAoy1vbotr7S3nHHy2ZL1e?=
 =?us-ascii?Q?RSetevXhZnupDIu3OjnGZ+S9OEVcx2+Vqc1OHC9Y2vHjhHBfP4rbVt3uknSz?=
 =?us-ascii?Q?VHCqY4vnTQcPxeC9ST21Nj35QLCrNvgPj+NYHHeFjD1p49BHVe7kJMmZ7+6y?=
 =?us-ascii?Q?623L0w5JWmVg2amoLbQ7CNQtVslJi7wXi1wJms+4NQhxcKvjpj8K6w2KzxJJ?=
 =?us-ascii?Q?AjEyGGQNEswfI6HVi9lh4qQYOdnAX5frh2zh/oomLHcDjxsE5U6c7Zb3kWoS?=
 =?us-ascii?Q?zuLboflDgsgsKRzLDsXcJ6GXv26DskGTIx3vDceNN8OWszwxUs4Z4TNLpNSl?=
 =?us-ascii?Q?xoZk1wK0Ajc4Obdf+tPPSLPRPvO0C9cj7d7ApzoBRlmzn+2F8rKWvQyWykWb?=
 =?us-ascii?Q?T4MNWsLavcsO82j+XlBkmdb7DWTCvuS++BAoDXsZRsOUlWMeUas2SFh+mRFL?=
 =?us-ascii?Q?QN0JWQPbt8E2f/VWCKN8k5Hwu0kEoxeg3/BftCRh1DaNPN/rABNAkvYsqr6m?=
 =?us-ascii?Q?2DtOq/mW/SrOaFIPG2QyJrmYdTgBL0+gu+3Z2rwXyXHyTZsHEqCazOVgZpxE?=
 =?us-ascii?Q?f5OqY4A8QMLiJdpK3LI/h9o3nlp9vrL2W8cve6rahIftQh2whJypgDMNPrQg?=
 =?us-ascii?Q?gegulUwZ5s0kmS//daVU1KGhXiA9VnEixRee6QlqQQcbfpRQXv9BI+3jpo/4?=
 =?us-ascii?Q?DMc39tJxVZjujqES7K5Shq0cXfQ9Gyr/Pa6G1i0xIW1D305NJuZSKVrrIn02?=
 =?us-ascii?Q?KAHl79IV9XATpriBuymMUXdjBqWaDNYoKzS0ZZBBCn0r2vo7Hp/5JLpvXKJG?=
 =?us-ascii?Q?Qg4oblYUQLyr4G2uWA9YQowUddIfjVbM2BTjQ/DvpisODL0vlSZsvOOJA55M?=
 =?us-ascii?Q?H/18tCn3tdS61GalSYbqnE/IjgpyRurPIp0i2AzHaXvOMkUU4qqIlHunzI6J?=
 =?us-ascii?Q?luwNETg+uDxkdvI7BW7fM1m0DdD5KdwuwMZIdxLOOnCyk6JK+XYkO7ZhAk9c?=
 =?us-ascii?Q?6GWWu1/7Vz2xXWTv7/foQZDuKXkdh1qpF7lXxwd9O27M2ypis3v6KNpUvqst?=
 =?us-ascii?Q?h2dAcWL1rs3Nlec+rSaIi15ZeouIKvdaMlwlY0rqQd8nMB6T1ZVN5gEOuOBi?=
 =?us-ascii?Q?/rZwdoKjkjwMs4hA8T5+fQK4oJKLnuymSO+wReFSzc5yZjvduDE200yTPAUT?=
 =?us-ascii?Q?J3EYWeAiiNGJ6EryU4sAhZ2V+pu7bCbcUyBwKi67syWYVQMVf0uhdp6D212k?=
 =?us-ascii?Q?usIqUBnPOvhNoV2QQFnSLC/RT4Ioa/KBoWqq6w/BQv5OtPVGAfOMplObbStI?=
 =?us-ascii?Q?I37/SYtr0DNkZglxbi/CODeJCgFi1R1CiCYOga8Q8bK6rj2YI76YF2VZJoeA?=
 =?us-ascii?Q?CDViQcuLpkFLjCvhW6++Dg46Hxm1GIz72G7Kb0kczqAHgtoJmkR/WWiHIC4p?=
 =?us-ascii?Q?NLBg+91LxC8OVNbPPEVQM6M4Nn6gCklLwZTKq3jtlMLAq+x5JOwTmSMEicDe?=
 =?us-ascii?Q?Q9dye6QXBzbjFU10BSxau8fgAI5joqpK9MQ3UALx/a1eaxNTa4ko8r/ajnvi?=
 =?us-ascii?Q?PqyX1Z6+Q5lKK202vPCBg7g4KmLYlxdm6GBF0Tlgl9ikOcr5YxB7dHuouCvr?=
 =?us-ascii?Q?/wcnGAwnr4bmZ8k62kMIEIh46TdK/xlskz15DcFO6DkMNrvUsItRwp5XXq96?=
 =?us-ascii?Q?SvHiYwYMYqRKUNX9JfqoQw7x7Ou3YDwS16Sgf0c9C6X0bOc7PVO4T5ksdlt1?=
 =?us-ascii?Q?pmg0ggJvEh5EHFUjDeqKQBUhsSQICjU=3D?=
X-Exchange-RoutingPolicyChecked:
	LQC8252mmQea1KbijEVibJOHiGx6Njfs8B5gv6udeFI5Kryj0/VC4Er5xFX2sqtGbMZCqZBgPMk74MX4C24TUDVYF71ReOOm+ecdYtYqSZTlvuc9qwZd2MKJ50DpxpwU46VtdD4aIEcBZfJNOmK3PHOKatabA74TlzkubVhhvzu22gNByZ9bdbts1e9aqdriWpGOydEeoXhy8TqCNUxzbGQH+8MQlWCOxVrSob0zlnKh/ZCOIEmeL8RzScAQI2baiLp/DL9M2dCGTiHfAPmiHWyjdNF1CWKsaAPXRd0L5QaNf4/8vysQd/lAWOUT7p9cnfKQ45OmQUvppLZ6/l6oyg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3QST1sA9P22LXD7yViWz8gqTb96aX3h/8GRTuWkqb5IK4FRTyYUxkOpXi7u9Z4/v1mRmvunDoz15p+7XfrBgnHxaz7rbeAONTmIAjZRYr3hZ24nRnR8v/nAJF+uz+QctIYeTzv3ar9xARs5oLxVbRhcxNG3tbUERspYIdPhgYBEnN9SvB+iqC+nZsIq4L0XqS3rXsP+EvmUhyTZXDHjCkwZSd4aCBw9keudsGManpEFsWtEghXQCw9MXaEQS4OVz4LiTiuDwJZfB/KX6fqvKIcbVGWTTZ3gKuo2UZkZ1HXdfbdThhvVZ9MrALoUG/r47B+ktjQ+cT/G2caiULr5Fx2DZConfXOpWskdkkLuqmJ1NiD7w5E+CVM5wLUSoSvNt2LHkkXFYRRbYD6vN6+LVNoeHfC8tIN0F/yF+qyWUieHBof7TgcCLUMfGjBlkKgXnCLOC/R87lkKxZFjR3gDTPkSrvOO7GI3/mbkNECGPs73ih2R024NpTsn++iQHvrDtSei6cI5YOlhn0ajk03lIDQWnKJyz9U79NUZEIg5E1GKgD+rlrEbbMmYlsewimTLWwp0H03z6gKgGwyBohyR3Qsbis0BZBqBXHkJW6y0tMdQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de55e18-ae54-4776-eaec-08dee89e00cf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:25.0571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQUCVMzPNz50wJOnrahm9QPSRR8czimqwBdjqXUTKkQ599ZRWY0YMCMEn5hRRsCRSW/kx/BAoNK+YKW4tA198Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Authority-Analysis: v=2.4 cv=TN51jVla c=1 sm=1 tr=0 ts=6a61e0d9 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=4WwWyauO2_0H2zdGQVkA:9
X-Proofpoint-GUID: ZAP3vzPiyrKAO2uTLoQI8KZMWN7FHOOY
X-Proofpoint-ORIG-GUID: ZAP3vzPiyrKAO2uTLoQI8KZMWN7FHOOY
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX7GmF4Gv28ThY
 jvSt0yQh/FyzAe4uRttdYa4cf2nbZROsDRh0TKlvmuXVQl06yfiaKRb2QGmZuXazXIttG2FMf2p
 WXsyTc3vqlouicpL/RTwohQflLUKYcHKWazn9CO2UXE3T7bkekK5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX5vTFqpV4XQUl
 uc5DMx4s2RyDpvpzFP97B8/NL9c1i5slyXiDjdGQa3diFnH2AH7sJznm2evtL2AGOSH2NEqjjoz
 eUVNszTgLrbgXJfmF/EVYD4F+EtmL43TBcDoBlv6KVz3+bdKFoEyVrdqZs6fd/h+M+r/Ob9PA0P
 FatrJr8mdNSmjs+onDockL/a453/RIwp62mJBDqrBncBFr4HIcdtJuqhX1CRb0XcENbCFsUw1q/
 /nJmP8HEb/48O6JgqVPSeUMpkSgMhJMx+i5cDjBShvWeUr4DDv1o6WXSfVgmTVtvJuqp186M7va
 b35p7DwLUFMCij/tcXTP5Qp9bmv2WXsmR90u3c4qxEzrc+27feoXkhL9YVxJUOXpnUi7kmRaR6y
 wKZNudVJj0liOGpuXrvfp2wFEpFoCliFJz6lYerbfvJnqRHXM3V6exvW5aHiGtVX3TAE7R/gtKU
 BXK2iT8I0aLRRdH79BQ==

From: John Garry <john.garry@linux.dev>

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 242a15bc2c5bb..36c745cbb2619 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4006,6 +4006,42 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
+}
+
+static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_show(mpath_head, buf);
+}
+
+static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
+		sd_mpath_device_delayed_removal_show,
+		sd_mpath_device_delayed_removal_store);
+
+static struct attribute *sd_mpath_disk_attrs[] = {
+	&dev_attr_delayed_removal_secs.attr,
+	NULL
+};
+
+static const struct attribute_group sd_mpath_disk_attr_group = {
+	.attrs		= sd_mpath_disk_attrs,
+};
+
+__maybe_unused
+static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
+	&sd_mpath_disk_attr_group,
+	&mpath_attr_group,
+	NULL
+};
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
-- 
2.43.7

