Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9681322D4D7;
	Thu, 16 Jan 2025 17:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047052; cv=fail; b=Z7DEY4IdbbhhFlBr9q7TgsXaR7fhRh6SgJpAP0/7uvei4FBbf5i0eFuren4mnEN0mQbIrF/VdVrwf4gWlRprFJv1ICehyCQLkIH3tNYmAbAp64EdbIqLltv33WeyvmwLSjRITQDAU9TfgSYgpo2RmQSIjjeg56BUy9XBiw755QY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047052; c=relaxed/simple;
	bh=mDn4pqVEikh4rL1ZnxkGh5Qc/oUSaNO0YZ+Wt+UdW6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZZIcWsut1V26jruMLqw3LZyzNaw7JyBZfbeD5ngP0Uff4LSuMbhV250V6gLs/SLWy9afN4K315qkLC65Vj7qDUTGJWepssl1ZdP0yq9EoeHE9oqV6SKZeQ2MKQm5s/BjXAT7B1MnhsNx6AYqvFN0R+GVAXoON2C6tK5abzq0cbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LPDnABcN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RwEuww/N; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LPDnABcN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RwEuww/N"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0fZ8024138;
	Thu, 16 Jan 2025 17:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=FoSeH0frUcXmcx9Xw0pGpi5yyKqvyumzt4V1k9tpX3U=; b=
	LPDnABcN6Hc1j+5ilJ2+gWqUovpgAAg5UnFt1I9oa4Hj4WUJozeZBlaAMa+0CaCQ
	eMuE7GLFZtvF0iPdazs5CCqDkCUlk6i1rnXuIBCeARov0dbafLH/2Lij0pfNjKcN
	9we1dyuwg6ljZXAv+DJ6neKtzbitBv+9rMUwfn/u7InoqLIPtTBH8DULsdQMLdaE
	BKyoDl+zDYc2u4ksm41Ei/FNqrNlK+8Un1b4g4jhfW6mEQ3tc/2mnRfkcz+X75B8
	9r2f8Uzrqndqo4wEvkVE4njh7u9C3e4hRr8c/oVarOCIgAvPgjwxDj8nKpTssELJ
	+NK/Pqj2wqxNRF8Ej8/SHg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4475mfg2vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GGKEfM034967;
	Thu, 16 Jan 2025 17:03:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f3b24qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMTcSkMleX56m2ueKMQ/Q/VGYYIB5GO9CAoZ0rJWBydzD6aJ/lseMBjGsXg2L6UpdMMsaMRB9cgmtteYaK8287+gB484wUDt3DcRkPRehFQHzLNpx1MhdMkvN0PVXOhIFFaIEYOBCP6j+WINXifc7kwfwEkn0gPP99DQqF/KImvhHQ/km+/NFMzvbwgwH0IuKBMtLu10bCusZk6yPgY8XCW9iSrjZWmo6LYCaN7NwU8+8qzg+b2V9nsuCTxUWKXdQklilse3in0YYi3U98GE/Mz0KzqftlmWmlXfGzc7AGr3uoV2YI5xABZ+faPn3WK0t5I1juOazEf6v2qMLUsDzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FoSeH0frUcXmcx9Xw0pGpi5yyKqvyumzt4V1k9tpX3U=;
 b=pWev+OdQOPgul6ongfIiQmceeYl+50AphO+CVD85rVYgG+KczSym5xo7askjD27gOQHPv+vbfKmulCB+EePpH21PKbjWywt4VSiGhwTWljfuMPfEi2J1tHWia8F4XsWFOB0cHMrqaUGjdRnKGVdatK6Xu5iTSyNbfFJW5Fuy8Hz8io36fsJ8tJEcvQh+HYE6i+GM8E5swiwI8SIliCLbVA8vBiGkH5dck0KHur6RZxoyHGN40wwTURRV/BrpRl3GLjjriUdMM9ECTYRGTp7YWBAzzI+gXpXixhftYj6AeIV0iIWQDvsjLObgVgcpHwGKqfLp6Qpr+y0EJ8T8R/GKVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FoSeH0frUcXmcx9Xw0pGpi5yyKqvyumzt4V1k9tpX3U=;
 b=RwEuww/NbKGkfEvtq4ZO8eyc3529dMkKff7CgOuXU+ecX6AYakOStftMkb/rzx0Tx9uoIw3G4fumY2bmdok2w5mQ9+ea6HFzYYR/o1hITElAP/YuEu6eH2j8kuxLcpAiF/6SKxMO/jGLEC0Af+BVbsalnkbzUDBlEOaNL6KZr3M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5829.namprd10.prod.outlook.com (2603:10b6:510:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 6/8] dm-stripe: Enable atomic writes
Date: Thu, 16 Jan 2025 17:02:59 +0000
Message-Id: <20250116170301.474130-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0132.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: f15d31b9-440c-4fc6-317f-08dd364fb9b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XKFKcqObJPfKSORuXs2l5/tMkrxYTXz/+yhKu0Q61/KMaZr3/OKG3M3XjkBo?=
 =?us-ascii?Q?1bohfz3naHxWqCbZOG5JOekDusnukVZKgDUWmmTdVbVq/yec2Vxe6eoF9LVk?=
 =?us-ascii?Q?8+hzMjOud5BELrlyLMX+EOxsvCbx++Iietx4ygz8LoL4lJvPBqukWvTEaMdv?=
 =?us-ascii?Q?CfXm34jbCIRtl1yDzARMv+2Nt5O3ODmxjHFjSfrShRPZ+dL8+QBekjQ65X/e?=
 =?us-ascii?Q?fOs+j/3AUxeq/f9/LciIhIpqV25BekS2a41xgAnzEZdZ3iy9cd2fdypcGjg0?=
 =?us-ascii?Q?Ese4z66fgOqv+Onw/M+rfmXF4ZpjVD4gE/sGwpd4H52cyFtXvSJ5kCDmzCE5?=
 =?us-ascii?Q?H0fwhbH41r4wNuSJYd8tVwt2txR2Px642o4zKd5ol/NB0sDVl7hJJlBaVo/i?=
 =?us-ascii?Q?KuoeN8E1Xk4X+KKiuu0OkbYBLgwZiQaCBdyWbvBlPVpNWn+aetyS8WOumL95?=
 =?us-ascii?Q?2e3ASQ9X4bZrUA9HX6ZOSj8fq9wuBz5L+1ar5Ih+fPmZutbFY2qffg2f0Gnp?=
 =?us-ascii?Q?yUe9epZFaYdTqQHiBmTpuxElWbep1LFuwtQ4r1uyiEKzkEQvWTr7LPrnJUey?=
 =?us-ascii?Q?2QbdUajwCt0K4X4btTmhmv2MbdKxXaqS70pc55tm0P2Eh3Gk3N0Ccuor2GgI?=
 =?us-ascii?Q?R62dwoCQbO09RZmLRFqcnUYiVa5nNFOnquUaZxBehEyzPtLV2b7VIAvHfAlb?=
 =?us-ascii?Q?OBleXM5PWCcTH+QfoXmL0rfqyzsTnC1YpnE3OpKXlAHcWNzMd/kxLhG0PdLv?=
 =?us-ascii?Q?9BMeWnq4TJjJwcPsQTwwH4elL9XF2DEaqLmrNWZifFJWNrQsItYFDGTzJpTe?=
 =?us-ascii?Q?I/FCesmhEARQyRC7Wzei6sZeGt8Y+kNW9cEIb59rrlmN+n7Iy2EpcVwrORLz?=
 =?us-ascii?Q?cPAekWOhXH1RCH7F7sDkTvi8+cGm+GCUYV5qF+ExjpM4ui6/lWvIjNulb7br?=
 =?us-ascii?Q?YU4ipSRKi6XRm/oeykMFNA+7RyEhjPtPj40a/iGD8y4k5kg9HuhU2GUnUnQe?=
 =?us-ascii?Q?vs75sxz7Rc3yx8zo2fogKIcHG/KkhWyQtqU85hseHNqDmhCTbaHQ9pZDbrB0?=
 =?us-ascii?Q?2YcDuncmRrstZZ22Q9BLt1qs0jup1JXCgPLeHohWnVJeakpRZ/wwluiRNV6H?=
 =?us-ascii?Q?5tQVAmp+QFFX2YO7cO9aKa3G2nbsMVs/CkFXHuhqGqckfH+S8aIJPHMiqBCl?=
 =?us-ascii?Q?nNP7hY2tu8Ish9voR8thOosPACPPaZfcWWZrDnpcoFCLBPGp8inQ+sSantie?=
 =?us-ascii?Q?99ud72727SwOA5Ty2gw84gycqZtSb6Fi4q6FeQ7JdQe/AZ6HXVShLwM9rUkX?=
 =?us-ascii?Q?W1nOuzlo7kQR2a+3/ZJBUqJ2ZnZkIN2YIhd1uOeb0s/oo6b+9FhVmL85fJzu?=
 =?us-ascii?Q?orIVUb8sBy7KKudAytsLQnHjdavh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UOoDDLydfuhoE5n867hJj4FPspvV/M/wDhc4dV0IQ7NH+CIAX7U79bcAl5OF?=
 =?us-ascii?Q?nl9/fpNM3q7JsWi5ZZvBPpWPSisJKpCi+cjwi6O8pKaDnlJ7U5Ref2TVb6r3?=
 =?us-ascii?Q?u3addWX/5wg3ecFkoOp1/CAIAZpJA6CLFm1HVXLXLRzWTwQRmr5VxptSwYLs?=
 =?us-ascii?Q?qIb18R9lgH7Z8FVTWsyqz34g8lqalaTBWs19uT2NTZ4mYOyLxLwfSub1ca8W?=
 =?us-ascii?Q?Ixi8i1OjF2f5D/Y5LhY26Wft6qJd2jQok6yW9q9+34o5AdMQpUaLXXUI0wvQ?=
 =?us-ascii?Q?gq7tmeEheU40xU9CxvPW127deO5CJmUsekLdTRNBaRKM2QEKiEIoA4PVLVxl?=
 =?us-ascii?Q?A+Uh+p/r3RbVFLl0tIUm6db4/7K6+Iuw2EydVB92pwE2pSHVXGGv1XvSWRcl?=
 =?us-ascii?Q?WnSo9GawcK9ZAhKwQJUiz9lb+OzFLPJByYwZSNgaii0ymsIGxmdCgCURClNf?=
 =?us-ascii?Q?dDaCb9jvhoEwSU3PjlhLBpqbWGMdwY+QZt2dVW0WXefQK8TLB9z5mDB1BZqr?=
 =?us-ascii?Q?zuwTzfCIq1Pi/xGFuL/A8FEHkIM6HZ3JXj2nfhdxUQCScC9K/mt720Kso7TV?=
 =?us-ascii?Q?1Pj5e3EjEHwlrlQxQ8rKrcJxHRIiP+y3Umza0RRXLxOavd6VXy1+HI3FpTeh?=
 =?us-ascii?Q?yrRq0UroGFUUND4Hx3brzUKNf7I1+uarRmFjjzkkwCgJ//AA2GwukJFnOnNa?=
 =?us-ascii?Q?4OGxcIuabezJsUOPygvzZVpQeT+trkiBmqUIfS0czMzXMZ4kwqOI53MKLbLC?=
 =?us-ascii?Q?J6G3zHG5+x1g7DEK8L1Xb4tlEietP94wcow9AdGwD4uXpGfEoozSfrb5+7Aw?=
 =?us-ascii?Q?umh4xLv/+WlqSuRwtWPCackrrtVFU5J4eYmeUN8TuMweD1plXrauw3DL26Rn?=
 =?us-ascii?Q?IQLBOhbd+GwWqTmqMarwBIWmw87mFTGg1JIas1vySfmWX4Pq/G6V9XrcU19W?=
 =?us-ascii?Q?JnxeKo2r6PDUqp0JmfaKTknDAyTebxEgUDwBEjX3ew9ospdkwCxCaDe9yXIo?=
 =?us-ascii?Q?eTK5sN6S0e3akMpL5NNn9dGGgrmuKCLZSf4ZZTIR7vxnFr4zU32J0BeLLwAW?=
 =?us-ascii?Q?xHMP8UIzDT6OOvQC8OKs4BUiUFqTUycVElqgswCiSGnNulAWdsEPhKj7hmAz?=
 =?us-ascii?Q?K47EfzxzssoFCb3xJphWto0W7bbv5VPERRbiV/RT241l/S7TMZVNE57TqfYb?=
 =?us-ascii?Q?9+30JdxR9yjtxxhdj37Uvt8MDYc405bvMmqf6W2XJzra5/sq50Xw098SHTQY?=
 =?us-ascii?Q?Nd+nyxeHgerensGtYlIgQlRNy9PMaJDLSuuaV4Pvo654WvmslXPHJlQFxrpB?=
 =?us-ascii?Q?0mUY74loLbjFL81plyLDK/Aj7vRLo8Nii4/FwK3ykpxDMznKWXfnkdJyoaCP?=
 =?us-ascii?Q?1E9+h/+oxnb4OF0BpdOKpNsBg7dSdS2DtIcWd2N2y66Yp+sT3Arl2WdB2Wf1?=
 =?us-ascii?Q?M3IkMIuOa7sDnfOaony3yl5mV5Yeb696aOttVuhc78UI9yeS+/9DW2+YXYG9?=
 =?us-ascii?Q?56m8ZMJYidbPol7n0QQErFWU4j/ZouADsjx4uMGMR136V3oaoexl3NRKZeHw?=
 =?us-ascii?Q?DMBpDa7bnLJhY5MOrvPKFHymWaWV++TSUidmPFW+Vd7jdX+0fW/IHPMdjsL/?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3CdGVTmwdwOKWjCU4U2MD04hRP2d2An1YiRBrJ5fYwLQb/fGNGrmLI8JTP/5CXZSBh2x90Q7TSQAFYtarZRivFINZHKe4D5gzHzmYYHND2SJtwTNU1InOwvhFpHjotbO/fSYWRlWcXweXLqxFSOpWaTQYnQY4pF36rhm1NXfkMs2Mxj/uhAVDTWQysLUd5IDZRBc9DxFIF1HT35f0+MxllPIgVFFO+zXUT/vYq43Ax7Ok8rZ13AU3MrkHzpNPIWvGlJu7FFvaloaqSe7kLck+SCUHM0anfJuyjG41gsywkpHeuCoWZ3hE2UbN9qGdY6UWoAVgGzQrsxEJJg/vkvvoqoUXg0ZsEsfojwSS+/C4humHZVLU+vuilg4Vvz2lqA9O5sG+BskPUEa76qpkU3Y/neUfNEK+HgJQRZvss7AIiYUMLiLMx91/gaTJtNkKnvbPoYGEBkzpvLKkXn9aVrWUWqvkz3cKkbPWA21uBMJrZpJ9X+q9bEnMrlkWE40JJELj6376VZnSusW+OP269bMJLWUWSIwP++Ts12j3e9p1zHlVam24gcxksF7xOC7em/N1UdBZuR36aL6hJSVp81D3c2eSZzUryavr7Dyax6CzKQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f15d31b9-440c-4fc6-317f-08dd364fb9b8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:40.3882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +so+Oyxad7rnGEsNjYJyU1Sw9KVe2srdOvJjMHMLbb3ZojpqCi9Ke5/QXyA6uSpT9pjQIZ4C/CWMwCBfG1xwtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-GUID: wswMmsCugZ8C07Ka-WQNjUyd8qP6Kdhy
X-Proofpoint-ORIG-GUID: wswMmsCugZ8C07Ka-WQNjUyd8qP6Kdhy

Set feature flag DM_TARGET_ATOMIC_WRITES.

Similar to md raid0, the chunk size set in stripe_io_hints() limits the
atomic write unit max.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-stripe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 4112071de0be..9add79c234ae 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -466,7 +466,8 @@ static void stripe_io_hints(struct dm_target *ti,
 static struct target_type stripe_target = {
 	.name   = "striped",
 	.version = {1, 6, 0},
-	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT,
+	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
+		    DM_TARGET_ATOMIC_WRITES,
 	.module = THIS_MODULE,
 	.ctr    = stripe_ctr,
 	.dtr    = stripe_dtr,
-- 
2.31.1

