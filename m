Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A05C24113D;
	Sun, 12 Jul 2026 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783880043; cv=fail; b=VkGKUIngP7vSSnDzRvxEaYT5oI2C1VPOkO3/Clzp4rJmWTgGCKgUWRAiE1LMci1b0HYChTc2N8Z1KrbYFckRd+o334xqthgf9Z3OZfSHzXcz30jHAwr+Ss+hFzDqMELbzkKQ6Mxc/BySCcPsKkAW8KNaEO+QNkh6wSRSXMGb83w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783880043; c=relaxed/simple;
	bh=Hl+mb2HHldaJhR4f3YYPQr359kE0iFNzAeUfWArvXBM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=btlzIQapQvt9kHIjAl+ytYoAuFhjqSb8AtfFRbRYHFu3uwM7Vn0y+VB2ShGwm5g8DkxIsO1LndpoOmYO9eCA7aa2ZObTn03Kd4+/i/NkiJQdlRVRbcR225p+A3y9yK2HhzeqDVOAJPDa0tfaMsaEw2O05DgGeSuBIWjXjWmbcvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ehI4HWqA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GbyGX8oH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ehI4HWqA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GbyGX8oH"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CHxBWx3716559;
	Sun, 12 Jul 2026 18:13:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hU4ilLh6F75WzZPHT8
	nIytyGZH3G+VnJ3aKMN+Imk9A=; b=ehI4HWqAKuTEYIKEGF9COHJfmboINoAHth
	BHlRgk98+OmTlue92oJZHIBpUukqh1MCCZXBNMfV+8kKvLvbNfkinrMeLZRpXG3k
	n9A0uFc16fhA8J+avkjN0otkwcQOOXU02bJjX4sWXtMC2g1fDbG582JqbEwr3Xq9
	IKDFCI4ZOVLFag6a2UY86/W97nIRHkmZYLLuEj6MH5rdH780qHW+2iUTtXrEHHeY
	vvmczsVOmCox1Zv+JHNaxSAEltR9WN4tVC3XlV1AjEf9XFomcjxdtH/MXj7RUokC
	QWGy4Cn+IFnKFOREyL1C4wMytwguSykOPF9l44itlJxGY0tFo+Fw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fben1h4bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:13:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CI9KQf024298;
	Sun, 12 Jul 2026 18:13:51 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012069.outbound.protection.outlook.com [40.107.209.69])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9pkuer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:13:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a9uSCIjHocha3sYsfcTrsXt/YC6Xs9yirrjguPpJQNvHZe27q3GeIrd4rfipHPuM5le8JVafE5LQFLk35JeRIHFDJmzUD8oq/1EBHq+f6mlqAGSwxpOeFmOkKsfElmDjAHTpGXZ7jVe9PigCR8ls+W2QDieRkNtQMz1XIvZbthgfAUSwffJ7rEY2uuSLaEZhv3fGnBgL7wY40OFRUcluu0i+80i/a+uw4IVcsXh3HlzikvmkR/U6dcmMoJiUozwKwcyGIiU6nh6evNhOSqE6ZhHKV3gfDmKDwmztgerLdmVW5RNoxlIfunxQnW/MzUFTTGVXE5krSoI9gO2bS556cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hU4ilLh6F75WzZPHT8nIytyGZH3G+VnJ3aKMN+Imk9A=;
 b=tk9MAYz79oEHXamaxuRfHhaS+hPOt82xDW9fJxIaLlzdUPGKxRai0DfAcF0gZXLIuFv9jBL1Ijo6lm2XsCJl78cn/w7ORP0zyj3TbvcamynmlWvoNymPPcvQytV/wvpL2I4zOEDsL184uJthUl3QA79dCGo43INUkGw77AKJ+/PTcqTlNSKT7gwdBNgImU5rabLft68VROCxpuEBL3YkhUGWHCzGtgF98DV4yryu8mqvdMqOusec0RZhBcnw5PXifnSC1ShBHRTtUYEaGx4yaf12XfQiktScu3OpExNIZOpcsG7yqMQMAhaRr/zhXuAmAIqmKOyVqrm95uHLi12+2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hU4ilLh6F75WzZPHT8nIytyGZH3G+VnJ3aKMN+Imk9A=;
 b=GbyGX8oHw4pUJ4ckPtp2fx1pGXXJ77jCzOvWd6wnUqAwWQ6lSoiXDwqUR+X68XJCASd2kzlMZsMzYZrRpoAqWkQXGE73QhexZTNt+1tcKPSQ8mfI01yYyPwHqcUOdhcUFGxoQ31LbGnHNUox2BsbRzF/aRrJAUvt/RAjgMwOXgo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPF1D755039F.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::790) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 18:13:46 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 18:13:45 +0000
To: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: switch WriteBooster missing free space message as
 warn_once
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260618-topic-ufs-wb-empty-warn-v1-1-ec744a153e0e@linaro.org>
	(Neil Armstrong's message of "Thu, 18 Jun 2026 09:52:09 +0200")
Message-ID: <yq1ik6kdqjz.fsf@ca-mkp.ca.oracle.com>
References: <20260618-topic-ufs-wb-empty-warn-v1-1-ec744a153e0e@linaro.org>
Date: Sun, 12 Jul 2026 14:13:44 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0118.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPF1D755039F:EE_
X-MS-Office365-Filtering-Correlation-Id: 6369273b-dc2d-44d0-a833-08dee041504b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	m6BWNJpwd6IYLVSQ5NteerP+2/OCLCzhjZzLnsAXtZxdk+CmdFL5vd5RrN4zltegXwtN2fpnrGo6H5GrIgwKZtIERRT6oLebMAgE5zizTn+etRHk4nsk8pXAJK9czyWewO8gMSo1W3/QmELYbZIt/EfwAFxoeAKYUZpdgDgcbQE2mOU8zO/L3x/p4CCCMFAyW1b8Ip2/gjQytE3n6utkNk3+i48sHEdY+lr2WgZFXS7FgWX2VA7dCli89Dr5OkesHMKFSW8WhNCf7usEyHMfAaoBRT1wha6fxyGwL7YI90LwMTivno6/ra0pXNFyYEB8qNb7BZb4ScBlX56zFqHqD7Bhf9pqyhjQDL9HaR00NQoTnPgAIdTLNnBJ6Pu5jzjdAPvDFpfVwD2LLkMYys7r/U/p7TZN50xm68N+yEWwP7nr4a/WON8GiNDlnRZd+dmz9KhalBVRgpQYAc9bEZpWYN79MfVghxiL3Ll4upWznzjPeR5E0xZC2JtLMyxJGjgYEelBxDPaelj2pLtqyuLt8DBOe4KVpQvKTuASJzlM63gsBfKWK7FaK9bw2Jli0ydMaR6xdDMaw24KKyfvc3h8CYBGo1+S8RK/IqZF4IOqEpVmWf63kxVUbKhZarwMRhblRkkYiDn6mY1XrhgfL4aizy4z8M7gHmocHcTU5cEGnL8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W6UYh024MlLaByqSPDkH/8vSnDJ2Zrbmy3gzCvsuaXIDjh3+Nx/TEW5s/ALh?=
 =?us-ascii?Q?Z99qAePbQkBZENazWz9iBcYPe1mXImwIwQtA4EE+D2Ov+uBpdGSBHqAOxO5Z?=
 =?us-ascii?Q?aceUAZYtroOgf1gqVbwTJISVKqRmVV0k+dTgjiLQSNk0Db+40SBaxtS846bc?=
 =?us-ascii?Q?FIwMSVR5Ov5DwZSa8I9/aiu+zmsY70R3KoXlXBz/HIo55UaEfmeT2OKumZR4?=
 =?us-ascii?Q?OiUOBL8TSnSI8gskCuCuGrwS0cQx2P2Jv8Iy5JOdyM1TGsEo0sJxnPRDhdx4?=
 =?us-ascii?Q?bajA0xv3nly0q6ifWzT4sPOb26q0gNfc9CQp7y6g6pAz5h0lQqtgfVa3zQRf?=
 =?us-ascii?Q?dTzc2NpAQO2DmD0MIN3O6KR4vXRApb0SxEzgM9dBZbSgCfJFgICof/dm7zpO?=
 =?us-ascii?Q?IOawO8n59GT358lx26ZIcwv5iMRRIGVB0p+SJ20E7soo9mWByiegtmXZeFaN?=
 =?us-ascii?Q?YT2ZNI7qVlLNGo9bPy4Bufzv9AS2QdAAyXyTgnehlyA0VSA7437+M9FTBT6l?=
 =?us-ascii?Q?uosl2L6xSqriMgf1ENyiyM8ViLkLa9OYq/gIWX3UpxLFMU0MUcawQ3nYWY3L?=
 =?us-ascii?Q?h4navsX4eipubCFgpZ+vCuFd+V4xSeWbolsMwppp6Y4DxyiZLSbCEgAPQfos?=
 =?us-ascii?Q?GM5fx7h/0P4uyl5cJ4arBOEDDFSfJPv7S3sRis7RIrsIx4o0a7wtLQTTgzEf?=
 =?us-ascii?Q?Hp+rD0c8SH5h3tKVQoOCAwCSqHRhldsWPFqltqReFWcWXccBkbkCtzUBYkLD?=
 =?us-ascii?Q?0j/Iy4kZActQ7IXsTqVPoBE8g/rGYYJRBz1CQJ/cQLFa+ADvER+U9KE/LQ8/?=
 =?us-ascii?Q?NnZkloxNHpGIKuudyM1ifYrhtsPmEdPDBvplFop5BroHYGyBJqLANn6YJsI5?=
 =?us-ascii?Q?zXEC7a+kr0KTiH7M6O+DpRtC7PfCvL5N/r17yfZR+nuOb4ciUJfQ69jZMXTM?=
 =?us-ascii?Q?QKbA6wQiSQUMwPCJtQ2UOWFAw7W8fW/2rQWZRLIESIJ3KbePgDxKxYOxXlaf?=
 =?us-ascii?Q?zJT98cKYk+t10pDpGUoHG1ukCBuTeXFw6ROlFaa+PdU+7yVcx8+mvalgW5cz?=
 =?us-ascii?Q?8Gh8hcoNLZqXpkLBOqvF/W5rRoV/Raxx3pkviHf9SmbMmlmeZPFsXpGtCfO2?=
 =?us-ascii?Q?8jUMTOh/4dYOXLwCtTYUA4UsLDLo3QR7p4trwes45hwgUAUyg/Ny9ajsYj/b?=
 =?us-ascii?Q?vkXo7zJ4J5Us7QawnhKW2P6qSfBSrf/Mo4w5v6Y+zyj92Lzvr/i4L0G4o6Pz?=
 =?us-ascii?Q?IBMedwbJEJDxLRMGz8WRw2cEVKDDVTRvkfIGyxF7FV9Mr4HuM+VdegshZLLO?=
 =?us-ascii?Q?zd8qAtciNi931OvHiQhfVZQfR1Byz5xSNBiCaaktfbcBB0MLzlTKeOLnBQou?=
 =?us-ascii?Q?fizt4AhaL7G3IbUpwFaEXM3s1n4VMoKcDOFF5Gtludt5qONXxDcwR72j4Ycv?=
 =?us-ascii?Q?Be84rlPDT4J5v+/MdXU7wSbFJtDNWNS/pkE1tPfe9rvzLiXJHjqgY65zUcbX?=
 =?us-ascii?Q?qFKMWH6XsngEjLEwq6xR84q+Ob/dbNLyr2rBB3QGDGGH6QlXRv9Zk84Dv3KX?=
 =?us-ascii?Q?RXCggdIv2xLnVN7sXSQ4TEioJS2wDC4/XPNtbD+ZqsQfq4t60q/rvEfIh+HI?=
 =?us-ascii?Q?Qw3a8j+270L/ga6PJFB3NAU6Xix+Fkcs7buR2XGOStsH5rcJAB8fWUNkvDAY?=
 =?us-ascii?Q?TfLwx2mkWtfck2FuyzyNZZ97cc3lR57yDn9adks5/1mKp7j0fLqSq9BdOSSX?=
 =?us-ascii?Q?KSnnvod4L/KBhpW3Szs0qgutl60RdbE=3D?=
X-Exchange-RoutingPolicyChecked:
	ky3093ZbhqFzNaR6Wc5cLh0DD2mtXdjQOx67unvjV9Uk4Ivln1n2yggvCr5BkOOQh4TTsRkiMbfa6PjwOcmgfx9biZUpyFDVNkcDM8rVOWLqY93AWlI/sZbwGWdmik/20bsmDAnyjLYZ9NAumyHdU0NNzwzDx4Ilw9KZ0Y4QEwjZlwbttn7vW96x6JlJvsoayekADuauDLs2FRtd05NQcN681AOXK5vEJBx5rNozzrvTDVhnkBXJiz49JOGzPC5tX1RsVIXWhM0UUZEEAdnz8g/ZCLl3ZkB62ExZVySzBW4ygRhM7zNPeE7KpHPAOco2pSasg6meyuAW1D3AgUPqmA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LIToY1lHwodigMh4WDu+UFE7zWim0yPz7liBdGqFgihsKlhFk05inHKiC+oGPzZPBTgKYHIRuGu8jT1xmmHJDnbeLTUIG2cb5iUXwIXyPa1ryD8iERx/zpv7EAFifQzAw3jnfGVPC+FHHTS+NgN9wsJYjdvWivbYScYFgxyxeIaB5/ARASOdqj3dKz0+PQPPeDpVaYz0REaQ/MRLdcKAKCFGJa7MIkvz2X9WM6jwBb0UkhZqhjLyUtk1RRHV6BtR87lu/2SGx0NFtZQNM8Tl5MoB5S6lVuQts6qM/fE5zjap3NiDC3Cx7AxB96OK+Aqd80LX7/iXoDSxf6K3xTVmx1LimR/31zSQ6TYbxtx5iW/Dgmd7mRmcqWThPVvINOm2j70tHwhFJ+fiQXBjn6pB4eWY9HhLmeamdU6LgKUncG29B4tGxURx1yQtwdsR4dVXMC1JXLF2n3WDtEEOviFKEbcWMHxyxLnDRjA3RJJjmX4ArRazCFOHFUA5K8nhfywybx2/y7ChlrIBoxwqy+AsTizh1WsdaazAVUaDtZ2+O71k8tNLldGhNwxUPrVmo72vjsIKLbotYzpkFoFExwoqD0+ialn62os9yKjnHS085MM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6369273b-dc2d-44d0-a833-08dee041504b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 18:13:45.8770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFhzzGYCr5bAOy7rvOzkQWylrojRBQLV83ovWq7dAVBxuqDEmRhuaGLaOezaUysXQU61VwqJ1SjZoBq2PTfFShvuidZCv2qaM3Ed3j9CHtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1D755039F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=841
 suspectscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607120195
X-Authority-Analysis: v=2.4 cv=d5nFDxjE c=1 sm=1 tr=0 ts=6a53d960 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=Sjn10twvmnxZ97yqDDgA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12222
X-Proofpoint-GUID: fj_14jxUSPKSwblJGbqQTLXgSZH7Ehph
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE5NSBTYWx0ZWRfX+mDCqezPGprC
 TbC42b0I2u+HhPBz6zbmsiR3aHxY8JC+adGAqZG4fOPYJr87QUe1QAl747n9LtaTcHfVEfHnpDv
 MX0WHcej+LRgVCjrX87waH85gANiKauu+L+yfT7ZpruHmXnNT+7kdNcK8JOsOBReBIlRIfHoc43
 1N1Cqg+GlwUWOXUdRcWNaj6lhjD2o5Mbt+mQl6+0769jNlcrA/ew4tCa9yn4WFDKQXHzWfQx9EY
 1hfA2flftPbRgnYn9ekd3EK/9571q6Wqm5idWT/gJdHSqIq0o+Q5LdnexAAcxXeHrClaSTbQOjs
 j5p9rbUX1gzcRaC62y+3O97J/VZYF9buNcNp21O3UE5P/8p074doJPEcNCDrT0yamTP5NW+1TkM
 E8VRRdimAeQaIU/gczGMHFKFsIy1Y7UwjubsjRqMUczcSVq46jEqPQfMm6exwG2xP0RDlgShl+v
 0bPZVV5IS/ZWPOR99VN5bLJDrxMqA1NJ7UB/PXQE=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE5NSBTYWx0ZWRfX2uol9B8X2+IN
 mfuB2ym+XtBBzAjTth+6VtoFb46YpQh23kCThgqFTG+xSzMWp4Y9st9fhurd0QY/E5ycNZ8X8ua
 Q1JXUSMmpc+ePVLXU/lPGLg/SCct4COO1zl95vb477lHl1gNEOJA
X-Proofpoint-ORIG-GUID: fj_14jxUSPKSwblJGbqQTLXgSZH7Ehph


Neil,

> Once the UFS WriteBooster fails to allocate memory, the situation will
> stay until fstrim or equivalent is ran.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
