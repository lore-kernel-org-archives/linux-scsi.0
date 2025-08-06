Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269CD19F420;
	Wed,  6 Aug 2025 02:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754447675; cv=fail; b=lLKeNyyv/w/BDAE4FmE4i+OzjvkLgE2tUy7Na3PXmOd7fUf0oid3pbueOiKipMaYUkl2V3ExhUAze6jq9HIr400vKk4bFAefuh+IOHvID+cq9PQ7OP7vrqf9nDnjCFq4wC3T7Cc1jYjtYBWeCj1Hxu/vW1PktGgGQNdtMSAK4qI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754447675; c=relaxed/simple;
	bh=6I8Mg760fjOc5CJ6hT+IDA4BGmkgjO6h16vlQ1NOc2M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=p+bRdyBCT+X7lcF+RGiHpPWiZI3Fn2LKiQ2N9R2dy4jfladqYSsXfvq87yGT1uluOTwefKa29ShQtC8nFvhO55iSmbpJuX7aCUU6QqwLeO2koEzo/dKyMy3nqLXkp7/5OCDTTKFCKiC3P8KF1pynlFL4ZdTJ4GBzG9n5biCrZME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qVSuEmat; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CNdBHXJ/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qVSuEmat";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CNdBHXJ/"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761u4v9021165;
	Wed, 6 Aug 2025 02:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=h2xRmZDff3mxpC46TF
	K4Q+fRcgAWmqxkA6YyJ5Ry9jo=; b=qVSuEmat73RJqj98uoZ4nFjtD2Kf6DZ98a
	qwCfkAqSYwfHrUxF9a+n/j1Le7oUviKvCSnruFzwJAxC52ZVa415xPIj+H8QaZ40
	SOLz9xdgWsLTY9CDz6pBV7RpUPEKs3atKanRx3lZ6lZQreY4Q9Z6vMYs5df/69jB
	HNVpM1ZS3fyEHD95wKVlq1nKL25oEcO9X6AHNClqcU3KNm6OLwre3W205bKgmkwt
	G9nKCXFnP0S9xyBM1eml0jo4q9RJYJPuRLl09KhRXfdN6CTiDAfSRTaR8DTs7ciA
	i0xap0ppWs39mWR5fXNrsywH/XtkOsjNVKD/WTErt1DcQ++rK6Hw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvjrm6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:34:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57624GLM027087;
	Wed, 6 Aug 2025 02:34:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwmdmsg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:34:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3L4TbIY+A4b7rtgdow6Cxpz3xkTRn/JNdzkTFlXoyE5hxBnADqMcGyf+C5r3RZROhsj1USPRtKdeJfTO3/CZKr+fLfnlerjKwUFxUquR9dU9LwN03e3iD+KQE9erRWx9Dm1jdx1dbX/AoePAmDeASeFT9RsB07L9+DbZyT9/RwKI8UkU9vn1CgRgCwz+eWMxqu9ftz12JJiBAk9DX2/wA7Iz7/SS1bNEz513i8Z29BJOX0Z71lc5p0c3qWfIChRqOmKTsLoMULigPiiIQK9YGX9HAu6385CPzRied6xUkPtfxSirFN0RFE8BBGckqLmnZSBD0+xOvtxzIKNzEDuEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2xRmZDff3mxpC46TFK4Q+fRcgAWmqxkA6YyJ5Ry9jo=;
 b=zR0eTGoQ2MAEkwgg77BjopZoqgNy6/4tcGrEQuBrteyRF8wh0JNbSg01eHe1VMstNNazY0kXdZPuzq0KqOEE4ZSusMdoAN6aQ+G3eMRSsAZ7iLmZuHIy9LWbjCP3wPQO0clINp0v4hRjASVE/MVq1BTC7WP4CwQ9FF9OVz94BauMlq7cjH2dNSvuKr1QmdjQjGc1mGLIzBpO4HxMCVLyXhfyEdC1W8wVWk6BKjv3MkLymDXpYRtzQw4qRXojKI1JJJUR6mO26movNjziWlHl5PtYKc0uh/b8amiRWREd7YpBGZWpeBDTrWEH5e9LtmYjBHWd9NeuEvqac3L5yFtNYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2xRmZDff3mxpC46TFK4Q+fRcgAWmqxkA6YyJ5Ry9jo=;
 b=CNdBHXJ/5UuA69BzXIOyy84OXZuDxnN11SzLNOKMduhdS9/ljNPKfE59BjZtuHNswTPpwf0NAfTrdMnUYGJNN6Rh6zMlUvtOqX4Yy8+IHBA3xxDcARN2WJ191p+w4p3BPWZCzSCRK5TudRdW0R4L7jm/fmHLM2W0igeg67yG4p8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5605.namprd10.prod.outlook.com (2603:10b6:806:208::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 02:34:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 02:34:20 +0000
To: Waqar Hameed <waqar.hameed@axis.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>, <kernel@axis.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: core: Remove error print for
 devm_add_action_or_reset()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <pndtt2mkt8v.a.out@axis.com> (Waqar Hameed's message of "Tue, 5
	Aug 2025 11:33:36 +0200")
Organization: Oracle Corporation
Message-ID: <yq1sei59o0y.fsf@ca-mkp.ca.oracle.com>
References: <pndtt2mkt8v.a.out@axis.com>
Date: Tue, 05 Aug 2025 22:34:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:510:e::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dae8b9a-dc1b-4ca0-4a51-08ddd491bf4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fytu+B0qCPOfBYCSIy2fYhO9tLEnUK3FVSSKxxqM9TFDJ6CYarZbBvnk6lKd?=
 =?us-ascii?Q?6FkIk2WzSMIneDiZKsjqaqefGT/1lz2QBV7iM4b/2Xvy3y7tCWrkONatX17D?=
 =?us-ascii?Q?QNXHX9PbIezy0/9Sx2Cw7s+Iw0AEdjlZ+ETPyVqsuKkebhtB0BZBC2+LWESf?=
 =?us-ascii?Q?dmRYjpiP2UCXKXeTOSSpYIYIKwsfUcabGc2Ocx87aNhIQQMEzbSSSpdq6Gjy?=
 =?us-ascii?Q?2Aa3JkNKUQ3PTj1VkirkuknPPSATzwEmKwEmIuZeGDNtjeTnXHYeViwzUB8H?=
 =?us-ascii?Q?ARKl0S77gEYYNw9qiCIZ2L2hZx5N4ENlSAGjdEON1bhADVWoSs74/CWmXuYe?=
 =?us-ascii?Q?zcwfGBe+Ak17sc7lV9Z8h6dAJQUMpzJw9H206pEfcrXLyyEAz2cYsU5NqDfD?=
 =?us-ascii?Q?gwAUXE3ISGjy7RLXMyx00NtUxc6aicK1ZhpetIDGC3PS8frSYJhjz0hmv5dd?=
 =?us-ascii?Q?IijWR7axKV7BgFtwRETlDcrTbcXb04YVjkIyPbyJqUwIVCionLsUONgvohoi?=
 =?us-ascii?Q?qYAw3HvFZJhtZmEITm/4SwxJoHi/XiNa0f7/p1DeGxd/viNXcIS5egOVWOeN?=
 =?us-ascii?Q?m/T2eXcVTj5YkT8TfNSdo3l7v2qC7QsHHpZVr68f7tQkyG14BS1Wrtul6HRz?=
 =?us-ascii?Q?+eohoXpOLhKvFreqvQgGBNydVAkuTv3QBPInYW7kly2BGkjL34ZoIaxLbSsS?=
 =?us-ascii?Q?+svc50BCUf5aOYjNRDljRzXZVFs+d3bYrAfJOohH2d3E3y7aMqkWY/8s0zEY?=
 =?us-ascii?Q?5eAL5VEUxiIclidNzh5vRAf7eDOwG25UQ/1LzCVg+5uf4GDariELiZfm0hQl?=
 =?us-ascii?Q?VhbpFEjT5KN/qMRCcRen0HbnxBK4AjMTCSidCKAvIFZoGMahAmsM8rNOiSc+?=
 =?us-ascii?Q?U9qYY3drGb2Q4wC1naQCoD2AupWw2UoqCEmdDl3/BErCV0PJDvvuatXetbzn?=
 =?us-ascii?Q?6jGaUT7bd30ZlCLP/g1+jxfqM/1ZiTNMz9xzK0EIuflMixXcuYQny9R91yGd?=
 =?us-ascii?Q?zSwHlLkUzDaFVN6M+pS3FnCcMOZFAa7+W0nQRZivXq1WxRw/2v+LY7eXyXtQ?=
 =?us-ascii?Q?mSk5LIC6tqUD9PfUtsano2V+jGl51G/yckOhj9oeddDZVTBB+OEySBxF0Zey?=
 =?us-ascii?Q?8QRvxSGA19cCEC2F0HAgJtYknzeO4DVcP6LqcA/uOXfmfkpvNBiQp5yBkABx?=
 =?us-ascii?Q?7le1nNVGZ/HzzrwV0uAbl7oRYWjzUTz3MihJFPQgPuXnmdUFoHIA6xl3fVwx?=
 =?us-ascii?Q?pOR/jiD58pDhhBv91TWF3Q70dTPOvikwVE7erZqngVhoLd/Tvyy54o0Z/Vmr?=
 =?us-ascii?Q?NJ6ejBLBNWM/Ht05aq8gB6umc+AYJLIvs8TVY7em8DUt3EU3yPr6JbG2UA9U?=
 =?us-ascii?Q?tiCEW/S4Ty1QyfgXpx+g3Ocp3/80VHu+CiUfFllODXYreBC9aeTvhjzogIWn?=
 =?us-ascii?Q?gUMSYP+PDZA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cd+tbFGKpj/bL2NVnsJtZQCmoZO6bvOwJR3/l+1+PTK+r0U31DeBxwoth3n9?=
 =?us-ascii?Q?di2lhVWyG55ukNwd3PSpFCofYUtruN0J1YSy0c68K7fJGooKjbcIjJ+KE3i5?=
 =?us-ascii?Q?RCAQg3tMJR1eQ9kWUFA5b4LJfOufcC3Z0uqGqtCWBy9bktjhcW9cHKCZUaME?=
 =?us-ascii?Q?7DBZzlm5TLZ+rLxtXBPKOcmNJzr8CnHol8BPpbjrU1FUFgDNOrY2MZsuQGJU?=
 =?us-ascii?Q?pyVAGaofMONPYSL8zSG5U0eGK81rcbvx0KTOyM4js9EOvPqfyl7bpawWInQ2?=
 =?us-ascii?Q?Mn+duT9a0y3hs0+7AeTa1zgBtW7wh7oFBPMyuj7ognFQQE/7qLy4saB3sY0d?=
 =?us-ascii?Q?kxGsUG6eS7agwRCjzZTC2H37Y0JavgKhIOXNo4EEXUQ6GK1SMuLGc/csSF+u?=
 =?us-ascii?Q?ju1pZsceJk2EIkTbEBV6JCBGvhr8YYZN6HjwEvIVk2MVmpLrCkF4Zs78Q8WC?=
 =?us-ascii?Q?0d1jOcZZ/6QFXgka5Rrjir7WdH16NqQa2x8dAnlTkJHwXpJhPtUUwFPZngES?=
 =?us-ascii?Q?Yuo8yUKX9+t+ro0IQpxWcftZ7Iq8PChMKP6zX3PjHNIRJsGYtOET8r0ItiLO?=
 =?us-ascii?Q?eJBg+3ChgEBNGqDDMCLUNFiq804GEAiM9AD5W5nSarhHa9cjuJM5js2DLbE2?=
 =?us-ascii?Q?UeK+ajwjh94VOp2J+MDTcfNbos+oWgKIM6IiI42oOEUUz+FGaERkpRXYtxap?=
 =?us-ascii?Q?04Ntm0WkEey/JvS8e8Jn0APmlRsSwAAJOzEskNylzFrXvS1dlWQflub8Uezg?=
 =?us-ascii?Q?uA3KSJ6sbgs/vWT+3djcPi/7bKyoLY17u2XrVaNuUFOIKNtAFKPqHvJCP2O4?=
 =?us-ascii?Q?AEE++SPfVMXn9nBmBEVANCuCCB/BVNdEImfKx6Cya6M5qU8xDoF8i921cM4/?=
 =?us-ascii?Q?Oqw/Smj/hF9JRdxaEQd69QlaFsR6X5MFcU5ks35i8P4f2pDZvjC8nGhoX5+a?=
 =?us-ascii?Q?mR88jRzr92Rph8yUrZpIjEpwnp3Rbj0FO2+4xPvnf14JMgxL2QIMaRPR2WAW?=
 =?us-ascii?Q?9k9jXHaJ2zsWzFp5aXllP06go/4raD15yqm6/ZKZFxkKHMPTpqmvCqQjsN8s?=
 =?us-ascii?Q?ZpxPGwy2GiPRvKZYEeLmeRPS6yO6y8maaPcZ3LaWeTWVhpEW0khP9u30FCwT?=
 =?us-ascii?Q?k1aqq5v2dizPEq7Bw/65exR0+kfR1NMq/vVxZtD6NtgwlkHBIoj7xygTvA91?=
 =?us-ascii?Q?r/bX68UQc9MZ9JVIJ8cxTfP16ZWOFGklh0iBFcIn/vlAVktCWegeiosT1sUx?=
 =?us-ascii?Q?+kKPeF2KBmxLMLAbBmJ+NkLvzzLVIVowGnk7fFqVVjvCAYG1TCCvZw0FWtkj?=
 =?us-ascii?Q?fG8eWmzP+EgeIu7fB9grP3c+R7FJ2QR/xWxwE6ySG8LasNRDw5emXNXOAuSP?=
 =?us-ascii?Q?fzZxqGptXesLGNxyZiEMSwEO59iq3u95X3VZVKAH+KD0Rdoa+WLt5TXvB1sC?=
 =?us-ascii?Q?21PaP8VxxqnI3WjwjwLyOlACfqfpRiSed8EfEcRsEu75Al0YyksZDJ/sfJu2?=
 =?us-ascii?Q?pvY8r+a3SY/BbNoJjkhzIO0H9TyhJtZHWkgQVAYgRuW1YSrsLJ4cVxz0Q3FJ?=
 =?us-ascii?Q?jxpyvQ1sDdMOUwwzSOArt2pvGbF0Dz1oDpLsV3k3IXtIkB7bb9wigZllUF4g?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NWGGMOcbEpqnawAARjzast1MUuvZWyMUkqgIjs7smKLK9v8wDvyXpKzvbLZGo/Zb7LY18HkO8HZui3JndROYEqG2bHP7D5dMn0vsDF2wRNRrXqmx/QBX8WsP2WP2J7j0N07hAtMtUOVoK8n5bcbPfSmXxwYMcxyFWLrXwawPgWOI9nvIwiGaoo6d2p2zFzbcBSGhyuUVJNPa67bx87YId5pSymXDubC9wgq25E+g1FXDS868QPTlPD5mtcMBHRwz9wnQ0v6MsANT1Dqb2p/skTvo3uUb8jjodi6BIqyNTh0NrOrzBCDaaLZUzikNqHxT6rn8zj3NJQxnsOMrMXQeAvgxd1aSdxVTaeBrZ1T7fHX7sPQ23xyGW2IzfHJhBbjH3EMVQGKRhdnGnXDTMj9T35YVCze77M1KoVTK4+XQhYrO0jxzBiywIEwDOyymc5Bk5rm1ME5Rcnr0+IwZlLDt5gaATPDC7wQVKPE/5YBtOX4/LYWhnOmq0/4cuF+nH1PruDFYRNNOmskX7Lbs4158prd7b20KvjKk9rY371GLD6G4I/SDf6TCWkBe/P4J1HRgo9x3H3ASNTAXEvceBOf4Ej4Vozy5k9UtqRJxXkamvnw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dae8b9a-dc1b-4ca0-4a51-08ddd491bf4a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 02:34:20.2307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rl6GeEvfrlO5T2VTZfhMm8i64ErL1pcdwanFTgUUA/tQ6h9zQXATZjEVcWcNwQi+X/dGu1OVIDbuObOIRuu9HCR5215zROXCrOaOGkCjfcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=937 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060016
X-Proofpoint-ORIG-GUID: -gNUM6_AzOwWOwWSHEB8cryEIYYTE4xT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxNSBTYWx0ZWRfX6eoI+c/HtdtE
 JYECrCY+FVZ86l0HeTCRmkWW48OczVzsMgGJYu7qem3Zk4xOxRGFuxENEP/NUNKY88595qPZBYI
 ASKABTdwljiGABrrrxSo69IxEYqkuJ0rjfzqOFec9chOjV05hHsPgr3e1SLs3UG0TCfWREMuL9N
 BEWcFxzIOMAQV4DUW7R6F50os8f1cMLtQ/I9lMEWddjskVCGPutTF3x6N9dM/O9NZWFQQX2nIEL
 02fyN+RLo5KH3lIzt9otf9sZGM9Wm3Gmqn90RVJ0NTrZlCNUAKgxk9exouSQki4K0Akda1wj96h
 YdRsjX6nthvaM+FB8+8tqezDLN15rQNk0FQbVodVdBw7XxuZSecFSvT15323BlbjeRh5q8vhvoc
 e+q7OyqD3eaItryabsuc6UpURVp7fwfZybWCNIST9P6NYlxhJ5e8eQwSH6cIeUIzRef/EqdS
X-Authority-Analysis: v=2.4 cv=dobbC0g4 c=1 sm=1 tr=0 ts=6892bf30 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9
X-Proofpoint-GUID: -gNUM6_AzOwWOwWSHEB8cryEIYYTE4xT


Waqar,

> When `devm_add_action_or_reset()` fails, it is due to a failed memory
> allocation and will thus return `-ENOMEM`. `dev_err_probe()` doesn't
> do anything when error is `-ENOMEM`. Therefore, remove the useless
> call to `dev_err_probe()` when `devm_add_action_or_reset()` fails, and
> just return the value instead.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
