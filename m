Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F02F83CB;
	Mon, 20 Oct 2025 10:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956718; cv=fail; b=r38rOV032oaSYV3xKRGyC/ChWf+wwtyE4WZW261jIerRI3uS+KfMMQhL3nsKKTncTcEB16SPEUeDag0gsvlSZbrrw8LUA6azuGYVf/MpUomwsRN5DGNWygcOc0KAkMqZOcNdEslfVBalyKnTWwZcBPZ7KWpoRn6S/ZxrRsqMArM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956718; c=relaxed/simple;
	bh=eAAbsKdHvJWyL9UWqYnoFCxp5kck6wTMVlVpVg3Z+8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=isAfApw+fZ+TanJHq5WLudhwJgTbhpaWkJZ+V1gWPdC40ZRrbFYhEbaCH0D/I7X4bCeBbh9VJ6flV3LiYKfASlteLcFQgy0600UctfxYvV1BmvZr183wh2jBFjldThV2jT0f7+fUbZ55YYJLZ6FdmwYJ10FslvQ8rSLXVQKtk1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EnfII5Tj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0CskHn0X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EnfII5Tj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0CskHn0X"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SIVW014383;
	Mon, 20 Oct 2025 10:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=W9yocODtiQPUh1b+nQadGIczPJgeL+57tnNNQcZ42c0=; b=
	EnfII5TjGEpqHN/vmqmAkjlqScdMgyvtZ9xe3aK+MOT1NpK7+ToCrN3vukzkFKwt
	+OSXFLH7vBq4LFMgTNNYxnxWea2EggxRdxHaZTHSuMVEZtAE7dEZR2DWrfFhU2cT
	8eWnqVBazZE+VMqewyxSLogxzuoGxKGClXnH6Sqwzp+0K9TmkQJB3JGRGrBsx/QZ
	qo2d8BG80FBufz6MCX0wA6UmNL6lJJ/XQfNDRcknlJ5SqTYWAZT/pw3K3e2w1XNQ
	gZ5Jb5GMEmSRUHCygCCgUDaxB2fEnds/3c2Z1xRvuhPmRzoECSdAgR3CP5F2Y3l5
	YevLEPeKiqQP5m91m115Mw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49w1vdgx0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59K7EejU025387;
	Mon, 20 Oct 2025 10:38:29 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011066.outbound.protection.outlook.com [40.93.194.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1baj6bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tcxmPIoJAZ+Zlbc5JhJToMd9ggFjY8EzfOWeLbIHuKiZv5wkUTUnMDDtcu5KJsoKswwoyHdYfCJyM1uVf86Q+M7CL+7MwLTshSFHaq8AQ5Q/n2LvZYjwdTKhGr8IIhwzQl5dEcuOkOYsv1UlgVJQ+V7VK/bnxjZ+uMGLRv7hkwopogvyC4KAjbyxErgJbpKjNpAo0HYpAB9UZcaX+0csqnA/TPFaGavIG5kpx3CaLyTeTXYxKnVpBZIdwmI0m7D/gLFzrOncb94BkB2TuVEy26eYP+rlaboAJI6SAehSCVmz/vnR50epHn93mOeg+i2Jd/OdOdpmIkwvgIbReHvTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9yocODtiQPUh1b+nQadGIczPJgeL+57tnNNQcZ42c0=;
 b=D/UhUG5bb4T5xO0r0DDHWt9x5j2HNLPEPWFisaEBZAFvawX2ghsczEIq3kInQ+oe+Qs8Pc5iLOMW+uRCHCX8bA3+7YQ2fCKTc5QwHrilVfTQWQ41tLdLdHJK8aQM1I/8MMT+E1rpX7VsldS/azJnOUPmWAugKc7UZGx4uSji7cRdyr7vNIMVJAHpnqaOOCv83oTCGqJvpgPZhwP2bRt5qCYZeaT2S2uojMedWLJuzu/LUuAM8ixn0Ccoco9Qk3XM5+KrS/q8YNZ0cLr53xMDawih7z1LyCm10JUNRd5C3xetB3Zxxe6W0/mgid1C5vui2ERcH2DL8yU9giREvqW5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9yocODtiQPUh1b+nQadGIczPJgeL+57tnNNQcZ42c0=;
 b=0CskHn0XROEsUBRIUNz0BwnFEVI3wIvDCdk12jHRLiSEeR0gtd5CE/mF5OczDDx7p8DeT8F8Ysez8Bk+YLX38bVDlNpMTrteyBPqvj27P+mNCHowHM3ql1cmyZglqvU2bABWXFcxtvvh1+bUBay+lb2H+NOLLlaEFHh1HSfwKHc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 10:38:26 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 10:38:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 1/7] scsi: target: Rename target_configure_unmap_from_queue
Date: Mon, 20 Oct 2025 10:38:14 +0000
Message-ID: <20251020103820.2917593-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0033.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:348::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: d2e7f445-4b63-4a0c-3bd4-08de0fc4ccfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gLq5E7gHDcQSPKAHH3cqC8uZ7dJvxtCmITw8eezuafZ949WFP5z+pUzQjYLU?=
 =?us-ascii?Q?rt3l0u9JjdO9R3vp1txb+0co00cgqKk/SvcPPZF60as3S9cx/OSK1kyZQaPY?=
 =?us-ascii?Q?A6AIlUdG05wbSrVO0w5PVJ4pnSgmd1RU7d2wRS9eejfx64UmF4cqhTFKYQbQ?=
 =?us-ascii?Q?QCOboR10ulphKuT9zSG5DvILZrdaZQ3X0YWYHAQAqwHRzqwT+92+klvKGPw2?=
 =?us-ascii?Q?i93z64J2Ht5KpSpDf5mittrJdLiuGgErUksmJhb92tpILvtDKSgqa+p0q258?=
 =?us-ascii?Q?9ER52rUv0DmnkDD13olb5QinYdJwb1aZMqG9zEio/W//P42sYY0s6JCPAdiS?=
 =?us-ascii?Q?1UgPFDsEC4K7Kq5hKkxb04b8EqFGHohROb/kBP4xDLclptPIwx8nqJp3iUDr?=
 =?us-ascii?Q?jyJntR87AjkuNFgWaYdeTpKibeuCF41PcvE+xP/G9/t2L/aK+hnWZIIjTinS?=
 =?us-ascii?Q?+hvy8CG+eiXKuv6W9wwbdxe+WozJDfmbi26YWM5loQn7F+fVApD5XLn3lIK0?=
 =?us-ascii?Q?nhEOoCgi14gRjNrYuKfPQWh3aZnN0y9RurQ0Zzg3ywIYAj7XBnwTBQcBDcXf?=
 =?us-ascii?Q?PmGYF8TY33Aw1cZY+2sSZ+hLpgdx4msWmFUvTvtG+P5M8FtJUceVCLaKM7jE?=
 =?us-ascii?Q?6bJ2m9+BdC6kWrKvPP7K+G+Xm632tJBWhpVQr+OZg2J5I/1XVgtBFbwAsS50?=
 =?us-ascii?Q?ZtCV+PMhmGgVAnGIioZyCmSB0O8piSQRqz2PkdcWMLz3UC46DZq5IPCcezNA?=
 =?us-ascii?Q?LxU/C9uK1tE74SLt0wc37CvJ+doBhzRvD8ikWiTKoYx4URwVCjmZ480kXn7l?=
 =?us-ascii?Q?TIBkCsHsvutneeo3dVCp8dlGqfPoM0Q94B3PQhsZJo5wmFRSdmc4/uJvC4KN?=
 =?us-ascii?Q?NN9IkduQYAu9h+QZFePyfdWmpeSC6QjNYKuaVdayRviN8ARH1NRKdQU04pOp?=
 =?us-ascii?Q?SAnM4LD6fWfj4Ifd+RurSCxo2lFISQBHx8QdPNpfwwU6MaP+f9iQDXqzeKG7?=
 =?us-ascii?Q?O27vJTlZ1HVz2yTt40VlvOLuuqOZnUvnw+XY5wqQDb8TIDTZQowUcjp6fEf1?=
 =?us-ascii?Q?jlzDqjm8MsY8NMbtDzBbAXV8UBBf+UMisZWA0t5DtDxYLlZ2qCIiAtoQKuPA?=
 =?us-ascii?Q?gaDc94ADrsScVyThXfo0DXAkPxCG19Ec3e9xS1iH+AxM0zKEV25wBA4ijzky?=
 =?us-ascii?Q?ojmypueUx5ZoMScTnR4cypmgU8ulFfcIqhdTNUI4fdgfNjlZk1U/8MfdXqxr?=
 =?us-ascii?Q?j/4DXF3dOQF4Av4KBuOeiwlp3hyfn+c77Y+ap7u8qV0SFXIWQhso4qM1ULLE?=
 =?us-ascii?Q?3bq1MLckJ8yXiShzfRD4laww9Wt6zEQ9aFhb3RuNFvysAJQ2JKG6qKGnyu8y?=
 =?us-ascii?Q?dqoDRQJDkUwggLD27njSUubFV/VGs6FCtUcZffMqxrd+zPcmTl9swIZw1vk3?=
 =?us-ascii?Q?AB5wQiqkNF1pB5ewKGIpUwKVuM71L/GW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vHDgUjY10nXZ9cbzo3UmPDfYYm+A/LpVQuYPtYRw4J/QFQKjwboat3Eo3Nqa?=
 =?us-ascii?Q?epj2tbkNp8qfITiwvrrt+9r0+ajtvIeB6zvUF8tpSkS9Kjgc0sb0b4AEKdOp?=
 =?us-ascii?Q?z8cO6QVuWBt6iZ/Vnsp0z2q9W2RSMwJQT2OXmrHEgEExOZBMdIiep59c68ES?=
 =?us-ascii?Q?JYuNtl86mnpjKjWo6UmgMim5iYXbayR2/VDIv87FeddhvVXqSuFTbgsv6wPI?=
 =?us-ascii?Q?xi0QHf+vBh+z3itrc6NDfTcS3plJqa1n/k1zLovGn225ya/cd3gXtab4KU8O?=
 =?us-ascii?Q?rH7OWQVQfWyLD0If1u4lpFvdsXmwnEtKcE8gpByUFEkeyaNFRRL1CzxQhOkr?=
 =?us-ascii?Q?MoH5Jl8Bo7nxP80huotHSLJV4pAqM81KO0FtSPv5orYs4NeXpag+ydzGONV8?=
 =?us-ascii?Q?UJ5oFixdscOEJhnypL93dSW/FAAECs37rjH15LmQukpdgAVRx2G4/hEX540M?=
 =?us-ascii?Q?2HCKcFE4EweuGrD9xd5THu1TbKmyqvo+DKZ1xdvrz6Kw8bkD6fCiMV+zTUIk?=
 =?us-ascii?Q?Nxns0NRhpLb6QzYn2ifRbkwvqum0xcyuzSurf0pj2HG9fp1QwYU+pCmYR1BR?=
 =?us-ascii?Q?T549EDVwjHlcGB+5NTW2RnazJ+47CjdQq8z1t8HfGbjaNsgJjTVIfph/pGFH?=
 =?us-ascii?Q?v3XtgwKpG7qBOQES0IbKK4mTmBgoULWGS1IFsIvm5utjIFv9ewj4EL9Zkbpd?=
 =?us-ascii?Q?562LU/iQmF/RipvecYAa7+S8ohdIKoVdlplXuCiaJrDhMs2A+qdCmYtXqT5m?=
 =?us-ascii?Q?i1w4uu8L4Erk+D0wjpDojBoP6DmjJaiI+i9ORhuh5tkMic8RH5sl3QVwjUpM?=
 =?us-ascii?Q?0xdBp2/jATepP0FJfMATo+4s2cxjLIz4RM1R0Qb7vgxDrLcoYFlgZhLUjIcy?=
 =?us-ascii?Q?H8E58oS34omYKblkHf6JKXKBNNxbLC9W1XwAIN65GUCKTeCRaXCOxZztzYP8?=
 =?us-ascii?Q?1Mh53G5DkvvyGH2x/pFkkZwwMBaDvR8BuliFRh7IwyZOX+hv2LpMYHUPwj/+?=
 =?us-ascii?Q?zOh24BVWOAcqmWtTX1wA4Q338QC/L2xqn1V8VcukQeiK1lfWnnYWjWbWn852?=
 =?us-ascii?Q?YgMhvW/oRoEJNSQyXkTy4Dvm/o2ADlqJIsfNzU/lsvliS/45DqpgevDaRVVl?=
 =?us-ascii?Q?SSLmZXmsPbPcUYRxlxBN1tPKzshsZZhG7y+CMG0Dn3y6AYrXdzPYT0/0GQQY?=
 =?us-ascii?Q?ECMsPuyZdMDEGN6oYiYXxoRYnlHH0D+gc1MM8OuiTWd/hq/J6UD7YTXg0PgC?=
 =?us-ascii?Q?g97h2TpRqslT6TA0N9JsXEYrznPGipH5dDGj7LJ9dGoemyIzi5ixhdr0Q+nM?=
 =?us-ascii?Q?58WD9q7J63KM+6wFffgQCsDBZ/xHzktkXO35yNFDszte5C0hvSLlpREG7TGA?=
 =?us-ascii?Q?ljjG89NGYLsEYTpjTvsDC7Lad4NM8uHbU6p3qLR7jK+Z1oyAJz5/cUn+wexe?=
 =?us-ascii?Q?FVw/e4jvYouLdOQ57vhYZ8cowSZcE+rU1YDADU9JNij3mmZSKyF+0nQ6KhS/?=
 =?us-ascii?Q?J0sP+s4U7Yfo/o/+R/SVgvq8b44foIqLHeH+TVN8M+yQcTkYbxekN1EKlXaR?=
 =?us-ascii?Q?JFtrQ4Nv/WkxcMIGqdY5D6HZWAPwBomaPAn/UUKRbKJGmTzNDdeLJKiJNBWq?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+c8XGwNhfqtZYorkd59vny6MAJm6eQ3nn72Yb8qQ8ezy/qXF1TH5a6MxvO8KLEqqOcpK6QkuS7h1N/aZXev/9j0VWcdMimRJ7LJBhPFI3lwWlWorfZJxHimDJIbX3gor1MOlXMnS/Xzbt9rzS5fjnHgSS7bpNGPimNvZqEFvFVOyfYAXXLF9Z9Lri0zz3Q5xEl1i1y7T7xc9OlbSsD6B6i1By1soPHV8hysNioD8nIOfBkZfpZ2Y4Sxb78VbNw/ewAlyY2Y0hImNlO6VzeaefLB5S8+93dCM62jl2DgvGXVmGXwXLwgYehmjPd5qbSr425Srbjp6nhC8LztT8oQYK9M0YvJSEImSqxwTIIfAJSshuVYaHn7VL6c21r5GntlNXi+dtnPLCgbb3pnZaAzq+MtYLjt16/+hXWEK4tXbX9Pxmmr70lcgaQ/7gQmcFoIFlPOC3D7FbKaDYSOZkUu3y3pKb5nqvRFEN0kzo0/93R5b4Dl3/JvXJHEvhntJK7m/yODYqqK1nkwnwS8cN4ea+lDmae7/WZYAoxsAWmtwDmg9y32Ejur4f7XVSebStRC/hxYQVXQQeb0n9JRFcfsJMNZsi8FFkXGQ6avsa9FP920=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e7f445-4b63-4a0c-3bd4-08de0fc4ccfd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 10:38:26.3639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0zQvNz0b0Fi8hVp/A6KTqoHtHqmR9NB0RL+AOd7OR70io+5EZnOaQrlQZOPRBkIkqRjuNyjsCKp/3352Y8XCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200087
X-Proofpoint-GUID: aAI5yssnBmYA1YK7PrF0VRR5VNfO9rYv
X-Proofpoint-ORIG-GUID: aAI5yssnBmYA1YK7PrF0VRR5VNfO9rYv
X-Authority-Analysis: v=2.4 cv=WaEBqkhX c=1 sm=1 tr=0 ts=68f61126 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=gXlpGWOUVd-z5TKqso8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDEwNSBTYWx0ZWRfX7BkOmqwpuK16
 1OVyrmBhV44aYWZXwgPgOoVffHkqTqJG/iO2K4e2hJgvJ8uLCNiam+PXJH9hSSt7Y/gr/7FiC3i
 mBhLA9URZ+YC2Mv1L9nxwCDrboZ/91K91fNrlWkfIU6lLBOo/k/QKWF4HJiQZZA5IAPG+kLOq+Q
 QA1HfknzdaZygS6l99ogkSAqaHbvjy6GFpXMuVpQOXTnVk8eSmjrqiFb07mhIDGElUEFShLvpCE
 VSASEfDPwbNf8l8yrV8yqPJ0j6U8tKj65msTyRJ3eKTmyszhWY+GLm6MTHbiUOVxxKy0+O2NZXH
 RDGShrz7k2qEG7GbnTKnPWGSrbuQAAufFYn/e8pY77TXzjCSPRWmvvLh6MhC9H/rTDHwjXtxM2S
 9McPvKPMU25sEDL/SoL79r+DzaL0QQ==

From: Mike Christie <michael.christie@oracle.com>

Rename target_configure_unmap_from_queue to
target_configure_unmap_from_bdev since it now takes a bdev.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_device.c  | 6 +++---
 drivers/target/target_core_file.c    | 4 ++--
 drivers/target/target_core_iblock.c  | 4 ++--
 include/target/target_core_backend.h | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7bb711b24c0d7..83fe3d9a9681c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -844,8 +844,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
  * Check if the underlying struct block_device supports discard and if yes
  * configure the UNMAP parameters.
  */
-bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct block_device *bdev)
+bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
+				      struct block_device *bdev)
 {
 	int block_size = bdev_logical_block_size(bdev);
 
@@ -863,7 +863,7 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 		bdev_discard_alignment(bdev) / block_size;
 	return true;
 }
-EXPORT_SYMBOL(target_configure_unmap_from_queue);
+EXPORT_SYMBOL(target_configure_unmap_from_bdev);
 
 /*
  * Convert from blocksize advertised to the initiator to the 512 byte
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2d78ef74633c8..b2610073e8cca 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -92,8 +92,8 @@ static bool fd_configure_unmap(struct se_device *dev)
 	struct inode *inode = file->f_mapping->host;
 
 	if (S_ISBLK(inode->i_mode))
-		return target_configure_unmap_from_queue(&dev->dev_attrib,
-							 I_BDEV(inode));
+		return target_configure_unmap_from_bdev(&dev->dev_attrib,
+							I_BDEV(inode));
 
 	/* Limit UNMAP emulation to 8k Number of LBAs (NoLB) */
 	dev->dev_attrib.max_unmap_lba_count = 0x2000;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 66c292b7d74bc..281612b9830f8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -84,8 +84,8 @@ static bool iblock_configure_unmap(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 
-	return target_configure_unmap_from_queue(&dev->dev_attrib,
-						 ib_dev->ibd_bd);
+	return target_configure_unmap_from_bdev(&dev->dev_attrib,
+						ib_dev->ibd_bd);
 }
 
 static int iblock_configure_device(struct se_device *dev)
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 4063a701081b4..d394306f8f490 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -121,8 +121,8 @@ sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
-bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct block_device *bdev);
+bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
+				      struct block_device *bdev);
 
 static inline bool target_dev_configured(struct se_device *se_dev)
 {
-- 
2.43.5

