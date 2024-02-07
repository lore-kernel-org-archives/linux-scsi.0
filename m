Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5678FBE9;
	Wed,  7 Feb 2024 02:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272369; cv=fail; b=VgP3xiyca5qbPxBcTZx9rZl/aHMyXWw+ya9ShqRbMdRFVocHfgYCO15Q/T2JaBET6cM+SEGC8JhpsUZCYfXVwwH3ZVwhKnbqllW0uszvuHWQmxs6q4npvCezN1jDiz9CKWqb4EuSuBxxYbWsY2nsQglnSV06TuVLO0sAPkGM00E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272369; c=relaxed/simple;
	bh=25QYqq3aLMmDo3oNyJmiju3KWGBXA81A/BTo5I5jCJE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=XrJzyZpowKM82t74PiOUdoWYSpfoKpUlraR0hSjVAidg80qmjhikiQ8PHNjbj2VFvWbVDMdqZBTUhzntk375gaJ823TFw5igrkIEayP2hbcUgp1cTNVSwFKw518W+M6M+gkjEKn52O+Q1LI+ArmQ9Gu2FhK5meB8Z1lmNJDfUV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TiAI0SU/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NBILQ7/M; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TiAI0SU/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NBILQ7/M"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 416N49V2019971;
	Wed, 7 Feb 2024 02:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=rGwBdLrV6gJ7OuANOWYpuRZoLYkvRDSyQ6CttWBSfkI=;
 b=TiAI0SU/3ompU7m1kZzUQGqsOThCJHZVuzSxjejcm4JmFw73r7X6WZ6FMlJDbgKI710B
 CLXdQtvNSi6tlltTEvYyUe08z3WqrZcbYlp1qvrAi3xv2KEYUEfnQgEJQMflQ5vnyxP6
 qMWEHNnVH7OhKFGMoOy+QheqSNN44iJEnM/Bx1VrpdApRlbAeAJo11lndsykd6qZUFBd
 tcx9csCimO+B5C0IPn8/nkRFyrBWlZVN4cE6IGm1++Q/Oh0E0pDyqcXdaSilfhXCaakA
 EaYUOAXEjF6WHADygb1fQ/DUFPs+oGXBAw58LCyZ7M4JLaRQ/HiMegYhKsayDlKVzSBv hA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32rjc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Feb 2024 02:19:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41717a2V007078;
	Wed, 7 Feb 2024 02:19:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx8jap8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Feb 2024 02:19:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gu7B2t5e+0v7hykl4DNCaahf2hpf1Zk1rZOcqKHEw5M8rh2D5Vhg/0tPycaFxq1B0TSGxX7rBfx/nH4JqIM2gaRGKDFgDW9xkPBC8dJPArvM8CjhTbFcDu2+BoMEw9Fl2xeSJRfHbNrHTLEZxeTEyFN8vBC79bP072G7eyj3ADp2+cK8JAUPmUZB/fQKfwEyAvxpvW8b3MeJzzUOjvKusLUImBx4KYKrq3rTO3Qb+7eyrUC8PVkrXdbAvaxKxc16Zjz/0czAd59s+liG1za3zvEkiWeAbCnbiMRGK0Fg67j//FyJiIsexFSh5aeP7WWYIUOleiM6W7mtQBdrk4UvTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGwBdLrV6gJ7OuANOWYpuRZoLYkvRDSyQ6CttWBSfkI=;
 b=DL0LilnBDlVDK0TP5bcnADSeheO0sxzLmK7IZCilVzo/0gSkLx/XB/ohGW5kGQg89j0Mibr45HA8yPMENBe3WL715aV1hBXxJiRJ+P1XvXVlY220724PEfYwNXocNOTYVh2ovBRLx5iHRMJbcnPSCB2+fkcZqtgcFvarTlFOjxlor3l4YtQkf24QmiCGb7Qdib1AhAhIt/BNrR67EgPq/HXzLlpsJB+cKZOiDo6ilvEeJv2UnbxUJ9FDHgF9HaSag5mkE4LXd9znWqXrFJ7I3SED5YXCIKi6KjjcJAgz9wR/27DUlxwahJh0y7G6mpN1sDV8VDyd+/+5I7lbiUoT0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGwBdLrV6gJ7OuANOWYpuRZoLYkvRDSyQ6CttWBSfkI=;
 b=NBILQ7/MuEgCILwxmKNAOYVpfq/2Kmqz2jSZAnT4ZlRUO10RPOItl3/xJSL4eo/7o2JmojV+/nF29MmWuYvYNNymBYNzzRQAQCYg/InNs+f0aQ+Wzlr/3PUrdh7OspD9j9S4DWwIe/eSSBY1xyeNTiiXrtuYIJ70hIQAC+ONJAA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA2PR10MB4635.namprd10.prod.outlook.com (2603:10b6:806:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Wed, 7 Feb
 2024 02:19:21 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7249.035; Wed, 7 Feb 2024
 02:19:21 +0000
From: Mike Christie <michael.christie@oracle.com>
To: me@xecycle.info, target-devel@vger.kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: target: Fix unmap setup during configuration
Date: Tue,  6 Feb 2024 20:19:19 -0600
Message-Id: <20240207021919.7989-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:5:335::9) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA2PR10MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bed4c94-65c2-4b76-7cd6-08dc2783321a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	MjAZY4/v0QaZ8sTbASvAiKual8B6hah3E6Kj/DwMAZLMQkmyrglM0zmC3fQfbqXyWCk4rby+Y47OoAVFUsImrVTK0RjT5EeKvsh/FJ2xEwLYuW+Q5RJckIDu8JRqaYR4d0nxz3ugm+7Z0cZtZUKO61dXjGS1ZkhOPwSAHZhbpm57p/JG0AKxftSrni2N4hCMNkKxXlFPbrVDNqxOm8chz2AAlW3/X5yJtbFzgmulOUVHwyu0hKT+IIGP4NDcP46z+EJF4EK1MFUeh+kqJ+7D7M3hhvGfCRBg3DdNG95ElGyTXHOc86V8gHjYp5QAimxVF3JuZIl9stOj95vpRtJ7JQ3IXAmRydqNuL5KEI16wEs6Cb8Q5A8jF1xAgzPiTq284PIr4lHhMyC4olC1b30TTbUkORD4u7f9dH6F3f4ATngRMHSH0vlVYwzqHFiMGmLfQTIafTjw/hiafYHGBsrf7DFvshXf2z3khv/sMvPhzF9iFQCf3LxiPL12Tdi14Pj0E9Uv4bdpta9jN0SibfZ85V5wmFxZ+Pbjl56g7Y4VOm+HtgRe6zzCTkhWb/Rkes6W
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(376002)(346002)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(86362001)(41300700001)(8936002)(6486002)(36756003)(66946007)(6506007)(6512007)(66476007)(478600001)(8676002)(4326008)(316002)(38100700002)(1076003)(2616005)(26005)(107886003)(83380400001)(66556008)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?leBwDXJGOAeKboHz+L3YnFDtvkWSGVPdMdM2NHkemqTdM/7bVK/jFo3zZixv?=
 =?us-ascii?Q?rSdSK5arvtfx4GDlPG/7gLYfyB5IIcXYnvjzQ+AfvY/u11m9nXyWUDz1EHye?=
 =?us-ascii?Q?wsxMue7zUHVWg4bBXG47Qt6SxxYCkjADV7Sl+xOGSTd5tnRmoau5N5U7A4A3?=
 =?us-ascii?Q?oCHHmmWvEBEemgL3nmR+4Q7Wonamjm98PpZha2V7GjrgXaZAxFzAYg3EfczA?=
 =?us-ascii?Q?0iZUIEYvHs+wRuXHgQPY5HhozBbZTgZdLHflrZnLtIAmifoJQanf5E1d685p?=
 =?us-ascii?Q?w2zJkyPtyEc+7I4eBsr/fADOXEhnmCm3Onme7BOYNpaN79ls9KWHSerD/rlY?=
 =?us-ascii?Q?8K6mg9O1nsOR8vEGtUFxYbzYP+hVyHw/jOKkjJx6HKv8IuosorNeyzQ4Was8?=
 =?us-ascii?Q?nvQbkkBH7Epb2CMBSfPRPgd3k1bEauXIjomZuGLNi7Oz8L0p+nzKkshQvV1N?=
 =?us-ascii?Q?VGxNDcfc1ppJCBfv65YZy+KU94m4cQoj7bxdbUgrEBaBCZ4XceidU2J68Hpt?=
 =?us-ascii?Q?QonxV2lktlEVmq3d6JGNpuro81vEz/I6U3Zqge34v+73TU0Oun4GiwQCeBlq?=
 =?us-ascii?Q?AtrHJADfliVXCxSADESMLOYx787DgGUiGA8iQP9kVXCNI2R6QbTx37dixCd/?=
 =?us-ascii?Q?5lAr0H4dFd0Sn1sJAIRNT7qQPcDIwaynDxwoDGp4tTX64HC1WhYd4WBPGrN5?=
 =?us-ascii?Q?fLRrvYi8Wi8F6pkN3DpQLT82FtnQPvJBse08t8b7IE+G246y7BbcgMokzOmG?=
 =?us-ascii?Q?3UWeyBrNdHaMBW8CEzxUSGPpjk8OyS2UKBWoXyWqwFBnUAreQrf5WNEktkey?=
 =?us-ascii?Q?dctxsA/hjUizN4F3N3WZW8QrgtkAv9jdfQFIsy6vMcfOPOSEWWIlKO/OeqRI?=
 =?us-ascii?Q?JIiJt1kSAH45tjCCYdi6TWco3WGcYFe37/3hXL78CFlKAYvgOMMHvGqx8RMJ?=
 =?us-ascii?Q?qUdsYocFzv2I6h5yaQSNJNWfaVmtPOIdBdJGwAH1V+r4lTXKJE0h2l+nAD0Z?=
 =?us-ascii?Q?lBVeCBcJq2ES0XwaD7T4ogrjBD49v1wtE7V4+XkC1bOhQbUEqzvndU42ts46?=
 =?us-ascii?Q?HbLB4KP6FTxU+x3gyE0KtApdwkk8055DTXRXlZYhf9Rx1G2/Jm1PSFg64Kkx?=
 =?us-ascii?Q?30fzK5Vq+Ho22DzrxTRrDdmyg5OlpOqFFjKC2AMiVTtVAvVw6MjwCTHN+hLS?=
 =?us-ascii?Q?/7ibPYHIOD+bKGFpxsT1ugF2bJVU31DEwpJbbQPmEHgtP/JacDKdjsnYtdRf?=
 =?us-ascii?Q?pnhLxzA0pCipf/Xh/d4EADSeB12dcGgHWZk6ZgWHwxjjajBWydyG5/muCfp6?=
 =?us-ascii?Q?4ahpSuSlC3G/0k7hABm0dkLCmQHpCFm3zyUr1Md4FSWPN4eqWsVQTvP+NTJC?=
 =?us-ascii?Q?CBnuMZM4N6TEZC8Li+24SXcLe1jYXNq6IEOi8b4OM4ut3YqJpq7X0urqOXIj?=
 =?us-ascii?Q?0cX6MX5VXQBp3e0zEZ6mVmXwuWAdNS6Ng304ySA6WtLI33pEJjKEsvINfsdO?=
 =?us-ascii?Q?mNPMFnlXK9ql1gJgUjk5/cA8ytVUlBmtHbEz7LO9ZrfSMTRmPsFyZ/DcxrXU?=
 =?us-ascii?Q?X9BGywfRXW9dqzir8zidSeboEKguww8lXL4hlPrJVvUgzpeLoJjEPkjcMEd7?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7uYv0t4wyQGjhiV1k7cPcEst6O38rTv0cMIKG2X6DttXB4+eS9Mzd0HPB+cTglTOLkWC1MSRr/yARb0qIiQREZG8xXSC3d21IVKKjDbthlmDSe/9mg41LYwkAp7hwY3SERLT41GTggV5gusTXbHlIEg4U/1hUcUYAF/BRZw8KARnuBvS0favFw1vla+nmEwdJkMVWr676XnC9QJuqAx18bxrVotD5zGB24gpcGZwU2eoFh2onoShN2HcS1lfGVm7H3rMnOJblVn4FTfo/lCcahaTiFyoE8OZbD3hhT4oh2xh9dXUcfgzOe0doNtzH/6aJx7DhYg+xVSShre25nau3Rzl6PEUIgJtf8sWxrdcktfiaDBGqyjsAlelsvLhidhemJ8t94eyUStYl3b7NeHJ8bBvqJ7M/Bz2VPRF2qnA2xsoA6FH65+sknpz1IA3vcQ0u14FYjFHYi6Zxwh0WCveF70GPJbuvm7NtWa986btUNmFljkw6qya0r8EzOX4VEAsp22v7MaEf7Xa0bTtGDbxwo5qx2abGJBAgReVLBT+D4Hb8JLophKkcXBHOU0u7v5ewf/lS+cCHRphwKIzBM+lWJqUjmNjcXFQR6iEPHsiXOs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bed4c94-65c2-4b76-7cd6-08dc2783321a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 02:19:21.5527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Er8w3mVTU79+ILh0mcJscOVjwdywDPKkdsaCEoRTjCJoUGo+g75QJrRmbP4vlpXBnmZdaxlA55HMdWo8K5XksJe5pTsO7mIbDp2MnPmKaVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4635
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-06_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402070017
X-Proofpoint-GUID: _M21H28RTOM7VD-mw8jP2yY6FB0uhn2A
X-Proofpoint-ORIG-GUID: _M21H28RTOM7VD-mw8jP2yY6FB0uhn2A

This issue was found and also debugged by Carl Lei <me@xecycle.info>.

If the device is not enabled, iblock/file will have not setup their
se_device to bdev/file mappings. If a user tries to config the unmap
settings at this time, we will then crash trying to access a NULL
pointer where the bdev/file should be.

This patch adds a check to make sure the device is configured before
we try to call the configure_unmap callout.

Fixes: 34bd1dcacf0d ("scsi: target: Detect UNMAP support post configuration")
Reported-by: Carl Lei <me@xecycle.info>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_configfs.c | 46 +++++++++++++++++----------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a5f58988130a..d87f6eba4eda 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -759,6 +759,27 @@ static ssize_t emulate_tas_store(struct config_item *item,
 	return count;
 }
 
+static int target_try_configure_unmap(struct se_device *dev,
+				      const char *config_opt)
+{
+	if (!dev->transport->configure_unmap)
+		return 0;
+
+	if (!target_dev_configured(dev)) {
+		pr_err("Generic Block Discard setup for %s requires device to be configured\n",
+		       config_opt);
+		return -ENODEV;
+	}
+
+	if (!dev->transport->configure_unmap(dev)) {
+		pr_err("Generic Block Discard setup for %s failed\n",
+		       config_opt);
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 static ssize_t emulate_tpu_store(struct config_item *item,
 		const char *page, size_t count)
 {
@@ -776,11 +797,9 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		if (!dev->transport->configure_unmap ||
-		    !dev->transport->configure_unmap(dev)) {
-			pr_err("Generic Block Discard not supported\n");
-			return -ENOSYS;
-		}
+		ret = target_try_configure_unmap(dev, "emulate_tpu");
+		if (ret)
+			return ret;
 	}
 
 	da->emulate_tpu = flag;
@@ -806,11 +825,9 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		if (!dev->transport->configure_unmap ||
-		    !dev->transport->configure_unmap(dev)) {
-			pr_err("Generic Block Discard not supported\n");
-			return -ENOSYS;
-		}
+		ret = target_try_configure_unmap(dev, "emulate_tpws");
+		if (ret)
+			return ret;
 	}
 
 	da->emulate_tpws = flag;
@@ -1022,12 +1039,9 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 	 * Discard supported is detected iblock_configure_device().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		if (!dev->transport->configure_unmap ||
-		    !dev->transport->configure_unmap(dev)) {
-			pr_err("dev[%p]: Thin Provisioning LBPRZ will not be set because max_unmap_block_desc_count is zero\n",
-			       da->da_dev);
-			return -ENOSYS;
-		}
+		ret = target_try_configure_unmap(dev, "unmap_zeroes_data");
+		if (ret)
+			return ret;
 	}
 	da->unmap_zeroes_data = flag;
 	pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
-- 
2.34.1

