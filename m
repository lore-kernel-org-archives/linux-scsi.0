Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6B63207;
	Wed,  3 Dec 2025 06:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764744145; cv=fail; b=HvGahMTnWksn+EKjNhzLB6FE0e8WIGIZgFOQWNqzucXVoiFBdgdiXLAQchxQ9P13K7UHJDyFPN4BtULXI/dusynlqo9wV7AcLWd2qoLYHceqqkixaIDw0/AUrxM7e9IW+P685sW9Pko07lfjVwE0VwvmUIQHtA17UbxAMz2RkGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764744145; c=relaxed/simple;
	bh=Az08OcHO3RUg4E87rXIVw+j8vAu/S3Qhijo8z5HAwHk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=CY+30BVAJVFDBb8moez8gBeiweaEEg0FU05eQHTRG0oyAqurHEnVMmUVK9zb/T3PazTxZFCnRRKH898ASA2NjrT9sVph3ahEtgPgStG1+Pcs6Ycn9Zzw1l1KgsGt5G8UKcfu1jUk0WL51zi5SXeQ/sEtiqdbZNF/fzxu3cp+oqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V6g8KF2G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Sbvk1Ik5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V6g8KF2G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Sbvk1Ik5"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B32v5Tb1666662;
	Wed, 3 Dec 2025 06:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vlRDaGlTQ19fE6C3E4
	AOYGlQ3W1XZMO5RS5nOu43Hzw=; b=V6g8KF2G6W8TEiRD6cBm52wWRaW10ycY1K
	fg0F++4ILLrjbxgtHNmUAmPh7XMZ1cIwqb7fGXR2Cq175b2VQQekNqRqkAZZ5d/1
	gd4xaAUUstxlF55sQ+UKFMvsqMaNiGroOLMAFWj2AySSs9E+tPuFNrcwHVNhuTQc
	/4myip91IpuVY931mKjQzQfHfTO7B9/OLXOMOxl4T1pzCO2mxODBXiXETKEXpmmO
	yRg0FE+R8oLwS2H3URLqcJT8E598ih/hH9JA33krq0Dg9SzLc2KNsJq79s+fXTxT
	17eV/6DcBeTdFmf7xIrEcAQxZm2vyC/fbvzYRUDZ6xK2Dzu1guzA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7wncmxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 06:37:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B369hu5035406;
	Wed, 3 Dec 2025 06:37:01 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9maykq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 06:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TP+d+0nZCFBlwGIZ5R23dmWh3lvMY93zpSYquSSDnDzG34Lfz4Uee7IMLLmiraNVTToZiwiJsYdcuV14AABXf5jr3HEXwJSiJpqElntA36VtxYlod3Sry8FDK0binLaIBuAJaMwt4OFGN5WjVlKozH4FZSZf7TkdlSOin8ioMTgKhrkTLATf2Y5cXE2/pszqC+ZTI0x9S/JJEScrXJGqZOvdFNXRXepRQf9v/BFb5mM9btfI+xRzonE6+pREjOT7voGWARY0YWdwiZNiLYHetbvDvwz68BdzaZrQ/xFjm0MM7zwDyFstlGGUsuMeUFVAcwFQ4zLKeqQgDTDk3CoYEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlRDaGlTQ19fE6C3E4AOYGlQ3W1XZMO5RS5nOu43Hzw=;
 b=Nx1+3o748okHAwgDXggYG6wU6szwibqfNiaHy8+R7eZRSI5aU2FBbA1gO4thuXOwt+Q41Yfp7JN6t7tXbZPdSZwdH5SyEZHfBxwBuswCWTZlv+JWoF6dBf/5sE6V/pttz72lfmhs2s7ZisywOdvfW2vNyh8rpzPasdxB1wS/Uu5msq03FqoFHbOTpxe9qaotdtEJAe9ysZZ3vRM5nxt34AxkPTXanoopDqYH4i4QzYXghcdowMAmnR7x2c8hDI433lIoKfY8rYANJ+OibF/+inPkBNUe5HfR9dX54JBtgRm3U3niG9VaG6PhTSwMvMNIFWxbauymY+8tHvS2nYsRqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlRDaGlTQ19fE6C3E4AOYGlQ3W1XZMO5RS5nOu43Hzw=;
 b=Sbvk1Ik5qwkL+tM8pwZ+rfVFxFLTqhVHlkPy244lPMZLB86pR/UR7X15S9vtK6SjDvP6tiQrRcQ2XnZJuIkvYjBS2tFD+32sRxO3d7zGWYk8zBNWz/Ker9SCFVV+JfAKysIq7YNNWKE+2YE9akF6kJPbqejA6WsRJmUbqTG7BiA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB5736.namprd10.prod.outlook.com (2603:10b6:806:232::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 06:36:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 06:36:58 +0000
To: Xingui Yang <yangxingui@huawei.com>
Cc: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
        <kangfenglong@huawei.com>
Subject: Re: [PATCH v2] Revert "scsi: libsas: Fix exp-attached device scan
 after probe failure scanned in again after probe failed"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251202065627.140361-1-yangxingui@huawei.com> (Xingui Yang's
	message of "Tue, 2 Dec 2025 14:56:27 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ikeot6kf.fsf@ca-mkp.ca.oracle.com>
References: <20251202065627.140361-1-yangxingui@huawei.com>
Date: Wed, 03 Dec 2025 01:36:56 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0197.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d596ffc-47f2-4d64-9118-08de32365bac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V52WEXFL8bVhUqdBh942n+rqBSK2ci+kfuOguNy1IQuKXSEaEvyActohraUt?=
 =?us-ascii?Q?OkfgoiIY/eeRlZHVEQojqYq9JRLL8q3wfzN2FMYHrrZ1sZQ3Y3AzvngXvnEC?=
 =?us-ascii?Q?t7JF5dIePruAv8GWpx68jd7KjoFKtXdKzQLtinIlViF91blIaJ5033xZRPRT?=
 =?us-ascii?Q?vzJL0fuq/b0as+mtrlxZexUCcSlFVyPcftV/JytjU43qULACiAo/hLvpTzmQ?=
 =?us-ascii?Q?vuAG6Rdai/rZ3wPfBEPv+FX/jOTudO3wGkmun2Vj+P9zZDNmeFVt0FIK+bTU?=
 =?us-ascii?Q?eJgVYBER4YqivFP2vCeW4jRD29UpVjkpQ6XJ0svhEvJ1QGU+m0Zlo1Fq4iZh?=
 =?us-ascii?Q?qqieBu5ImtgtcIZ1rhmpaaPxO9pa6n3ye3OPDlkCycAIXFc6mrp+GwTN99pC?=
 =?us-ascii?Q?vm3SiSV3aXDvu1zWSGCtTu8StA5uj79YvJBHab/UEstxxPSnF896oNiQhLb2?=
 =?us-ascii?Q?bfhg5jPbxmL8YUM7WeSVJr5mPNsrCVJIvvzBBPpeKDabRrU5K4z/EYvS6rEs?=
 =?us-ascii?Q?M+MX/POFF6jjj4DCr8m+CWPxNMOPAL7ykEG73Hn3/euEUJ5rw8fPQqkvmgsD?=
 =?us-ascii?Q?QNvIzeoSqqhmJ7d+m3EE/CLad3cMakplx76cQ+oTPDgPARNdMsi8mDLXS1Tz?=
 =?us-ascii?Q?UnFm1zrTblRgINFKlX00rQSpFN99EK0xwdvhbr+dJ5JGIK/cYJdaWPB9e0Fy?=
 =?us-ascii?Q?yjQPDl/L0huU3MeOAaRul9guPHAwQZNJzLm8WvEbOul7WkKNp1XY5JwJjtMg?=
 =?us-ascii?Q?I0KbFgM23tkr7CtccnW9dGOJNcfsFZRK6qSk5m30DFXAEC2nZiN4OJiZ59i7?=
 =?us-ascii?Q?UMGEiQjFuhMwPNgoFu3tafLSiAj933U7am/gG2aEsewLaC1tTSeqdZl1gSSe?=
 =?us-ascii?Q?j8Rvuo9MFH5SA9Vs7KcK4w9gquUaiAk1a9YNvU0g97MNo+HJcjAwW8TicqF2?=
 =?us-ascii?Q?VTtFxyX9usmNgS2/blmEjPhb6pkuzhaquWlSu3BtWu/F/FeIws/dlVSnshhn?=
 =?us-ascii?Q?oUmsdnpfXeHmahU/JFBXx0+Y3FuSG7aRApLdkS6Py4ZEvWzLtar/Koxhd06p?=
 =?us-ascii?Q?3xirQD51H+9iq4g4aLCN3vBBFRxF3CMaTbTCTbv+5d9syERFbSQJBIOqcB3/?=
 =?us-ascii?Q?uEcTX4HhOG5bPq98HIPzAKDgtL2LvvbZfs4xote+eshqy7tdqOoKJBUg0Q7K?=
 =?us-ascii?Q?4XMYbyy16vsD65p166iarKij0EyWcmJaiNwrkdw8pYkPiYfNxR1Z6zMDjSwF?=
 =?us-ascii?Q?h9mUb9yhEQW3ypv1iZvKousldH8gVK4m1eE+uxz5uvhyHM1yvnCQSU9gczE7?=
 =?us-ascii?Q?7O/KdNLLZopTiSef06OKFp3dLqwvMz3hnuvg2l/tiWnY8ijs+hpOwpsBFo8/?=
 =?us-ascii?Q?r1dYxFrpbmC2UPgDVG3s3hn75V3euoofVag33lpGffXUYj3X5vEIjMVAGlCS?=
 =?us-ascii?Q?ydv2y1rgj55y2alIsJFnYW5WkN6ANfmZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HHoRmgiIwPQT0GHMu0Xv1u+yiigA8Bs4bmX61c6IzLkWzkikAmSfrSSlqfI5?=
 =?us-ascii?Q?6HhG5teuNfMZfZTGRlIU4FFFGak0aZzMzCMVCbUwf4Nfm5wrvCc3YNXlpik1?=
 =?us-ascii?Q?W6oD5BVE14W5LeJbyuLDpQ00Hjuw6Lw/EyRrogJO1Uqw61jXX4Bhbv1A99FK?=
 =?us-ascii?Q?C0mHNo1rnGMVrB+EaF+95WNsocCro5RsYZJmJWS0GTvIAQam3y39gbBDGM62?=
 =?us-ascii?Q?bw9dgh0xOnGIzEuf+G78DN3XVSIVFaNcv/cr157OXjy+6eLsRDG5oGQdZ0YL?=
 =?us-ascii?Q?7wNOYgmmQ+t+ias9RcvwOkv7hlBlhk6J9FSfsR0vrjmU7MICREiXA1g2EjtH?=
 =?us-ascii?Q?fSJVwMo3Fk8yOKhx1X/EYKbQDEuGuBddjIwLHFZwDSM8fLCFYycBfGsTpE9T?=
 =?us-ascii?Q?yQWt4X12teLAoG1l67cois0gN/F0EIsPux7ZFRxtPiLxZpBPHLfQF2ByzmeJ?=
 =?us-ascii?Q?UJ4sYvr6qbE1gKz6XdfpQtkPrD5s5740EuYYqfM/0UNMVID9XKwzEjbX94h8?=
 =?us-ascii?Q?VfQExTIzC4E+v3ZU392Y9fdaJE6cvSv0CgPUYj1VmLTGo1OrEIlghY105FH3?=
 =?us-ascii?Q?1RnjjVNJSTqcVv97lSspeI+p5pXGH1TMk6Qlxsri6nhgYd9ZnrKV1RGncLfJ?=
 =?us-ascii?Q?s4K4/UVcfAs52HxU9ncY3+YpEsa+3rjpBRuMYCyT64ED2hrbiUcaWZeJOE6l?=
 =?us-ascii?Q?/Ec5PpJrAiDYXUnUcOBWP5Dy0O90WwlyIOTwDDInzgS7NTN7xSLPRRpYbxzK?=
 =?us-ascii?Q?nv3Sk7UlWz5sRtX8PMZT62wr2KdPfJFTXLeQfDFtp95r0MSwlye/FIHzvMkP?=
 =?us-ascii?Q?uLomCx7YxWDqhpg3Lx3pXfGEFXi1Ipq5Cg5u9kOvay/cIU9WmWJ7ga4p+qsM?=
 =?us-ascii?Q?vGCT+mEjJwMVTbqD9nx+6vzZZkE3/BG9rVTFWbBC94Wt7mZEHLh6dwPk6fCA?=
 =?us-ascii?Q?uILqOdPLoLjEbvikz0ZXjRJq79N5PWHB0Ynn+1E8V08l7eUMKRSMyjIJqOGj?=
 =?us-ascii?Q?jyPt9DJ11x6+q6VZPRmXLgFp2+MrIwL7hkQjRZy00ptUsymAtVzKcIrcfh8e?=
 =?us-ascii?Q?nFFe7kTY1hywk/Nx3T5kd1l/ZBXz8m4gQEswOiVAVOP9AZ5M98Efy7MNbo25?=
 =?us-ascii?Q?BsKjkwfrhp2X/BXpU7LktDXePDQu1/+p1AAIKk6t5P/D24/7SM401b2xVklk?=
 =?us-ascii?Q?qirqTzI0JPVSNcfnXiUiyFcX7903NPnhnfMJfkP7kwzaa7Wz/zUqESzTfiLU?=
 =?us-ascii?Q?8bSmHSHuPun60ygFhhoXnBZk2cU2ySY3VNQY1YYl8fiq4/zhruz1ubFjqeJS?=
 =?us-ascii?Q?0dix6FkJSE3+9mTbIbIce7SqCv1xFhnVc5lL+VGM5oTy2t4JQQAN0WglTfLW?=
 =?us-ascii?Q?wKbl7YA6eYgWM7wcDFtOkOHuANVR8ipI34+1/CpnEHAxkIrIEkCLs0c2v/iQ?=
 =?us-ascii?Q?x2FYcscv3YakMPq2b9nyzpk3PRUjQh4t/Fo2sxbrSQmyxWVwN/LeT3e2Smxm?=
 =?us-ascii?Q?DJNhfXA6V/PlWDBLZsK1Ji8EnQksrqTPp2lujXGVJgOJAJt+sWppEZHH+Sx3?=
 =?us-ascii?Q?R9LlztBVg/tfN9G0Eb6CmfMBlpzQCHcSuHHnpiKRH7xT8DbWcGuUz1fAUUC0?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wJckIM1cE7zIdxTasgrDoJt57c6ZXQXmHoeVoi0pVG8uFL+uYylXiIakAWj6xPW8Psu9mi90wsiq0rnUthAljuLCExnQBiH3VhBynVgTHVRUdyhrvJvUOBZSXekeqOzSm42lyAJzBpKj3BGUFagSPy2wgSDM3QKj3TaeC2DJPKjQYPnpvLggu+DkZ4x4w0in9TbMlbMxTiJ22wDquI7w+sP/qu6uwsQ/r+aQwYkXkgx1znV4PlwhHthPMxUdtdVDo0zGfhKfedrELH4sDkYMouCBLyfddMRoejTfNKgskNMgEuiRfI1tRF7meYCkruD0tWlx/TK2FimMBdgaSBE9BFJHrbsIuilMFVxia0UwA9Rf2VXgNyp+lGmpW2F+MkwdKEOUDFWjNDxaza9RNfdo2HFnmf+s4IwcP5QVU92ItL8rsjEQ9nn8KblD9+Xak4mGD2Wg5ZKKpo9p8F2rMQX/aMYBB+0tmHA5LCgQNLeFhAKsmIgJcNbtmiIXvvocqOy6IxGMBoXBXsJ1Dp7MURxJUEsjr70rrCxsxHOu9YALnJbG+ikBpAocb9dV/5t3dQM4Ey2xX25Zx0uLDV8BMs7KHwS2zeYLa8xm3PZQAsHY+/Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d596ffc-47f2-4d64-9118-08de32365bac
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 06:36:58.1904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AbIvPjOk31U+RI6cunrgp4mQ+IFbduassWY+4NS0sHSxpoVSns2Wf5NWySikfBWJ2aNzfscl7MK22PuhWshOStbmMXWE1ORIRuQ7AzNNm9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=839 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512030050
X-Proofpoint-GUID: 9miDo4H4Xx05H9kd4GJAcuj4BWb6i7rc
X-Proofpoint-ORIG-GUID: 9miDo4H4Xx05H9kd4GJAcuj4BWb6i7rc
X-Authority-Analysis: v=2.4 cv=SbX6t/Ru c=1 sm=1 tr=0 ts=692fda8e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDA1MCBTYWx0ZWRfX06fdzrnWCVMt
 yStHh3dQDh8JAR9fAfh2egp/Upu9+9afANt9eqikgttajE/HulfMIvN55n++aHirfl+sp5OkzcD
 XBUdq0wog460h3ujCg9jv3PFnrMA0z1B05LO0LEYK64z6Vhkx+V3+XUcxTN4RUxscXlu4mcN5jZ
 vEsLnhdWGJJt20+3JDK6JdvRUcpFpCe3wa4ie2azrxV6SSg6aeH3A9QOoS86VIrXJBoyhJB8Zoq
 /Z16RxJ0SSV3+7ckHbZzoJDGnDwJgyy2SV66AvwbPEQrDS6AGYudUydkwJxZW5+nGxnDwyLGGKU
 OEQqMSwouBYM4QVlCXadWTkHD3b2X+IWyY8SXdQ8mZMCtHCmkfRd/NNiULreXCF0c6Xxo+5CtAh
 90gOTXwSWiazu8biIpluhmbBcVMaEmd5XnsItRI/+l69A2BnwVo=


Xingui,

> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
