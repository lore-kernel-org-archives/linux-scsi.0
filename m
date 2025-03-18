Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86408462;
	Tue, 18 Mar 2025 01:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742262819; cv=fail; b=WYYJ1wuCoZn0XfDLXtj3/lpIpnwQn91zFVAAHhk+CGA9rUbLkD1fb8QidD6QFkKiNlLS4IXL7PHuD9y7LMDurxFkVxQJrHfAqqDhIBLskAIEPeNn0H+SMoggnig6yPXJs/RK+QawK0C+IKCD5lHYfvimcQNa+N6WEEm3FuJM4R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742262819; c=relaxed/simple;
	bh=gkVWXlKGXJJgjcKVoXKZSMV1oC3sRNiRfOMgvO2L6XI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ezJ9VdfD+B6Vchkq+NsZfpxkQsdhQZF9havhMl2k23HG1mh81iHgPFRqhUyB5IwIbsZMvcbBUv7Xs6Io2x87VCZf3NfxhncLiv0Ufum6gaSO2+Fx5MLOY6PEepJhry2ie4brQdpQBbFlpb0vyW/vYQPafHaazF5RGAHCSZtNYeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z5AupMW2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XhGxYOrk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z5AupMW2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XhGxYOrk"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLuwc4010239;
	Tue, 18 Mar 2025 01:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=gggiqSPMwVy1M352Me
	I7xQHVPsrDG1xLqSrRCf8R00A=; b=Z5AupMW2/DztepxnU80BR+y81QHXv1VWPi
	R9fiNyHc0HUpHQEk3Rn72jbaIc4tJaK9DJ5nDJ5d3fe2r5Lk9aFP3wlRRgW/7vfD
	p5qBt7BIZR0R6RTdcI15QHfcZn3vP4gbtuMz9JeCUno119BmOA5Ch6Vlo0ZimJmx
	JlaWV10eJHMgaAMZ/lkSet8uq4Z5cclJMixGowybuTrYFTljUZEPmIjpYfHedS4o
	LISBvk90i4vFb3PXcUgDPZwvxZrsIrxoeW+yDfCqQPV4xsOYJN2mQ0AhduqxFFSP
	n2YMfj1+VUx7ArvNZQZFZFDJGThE3TeDt5FcSpX6jXQmWh5ghimw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1s8m80u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:53:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HNFif4024505;
	Tue, 18 Mar 2025 01:53:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxbgpue5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:53:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BQi55JDoBsbo33Z8x0ygcjg0xdIfY8tvZ96jVB1RBMaIdVOb9J3AZl7paIbR1C2j5+CmqH/HDrHAjB8Z8m1uZgjlmBC/zenQGclgD2buVbofD7ucz4tsKIXlx53SvwjKACZeTwVi/KFbKD/tg83ptAHnQp4kr08CLNqZw1HYXXErb+LrIGzTOBunOEtyZqYM5/ULg04HzH+iO/Jyq2IbSDAdzsI6nqd2BFw+7sPT9f7a/4WmyM+SmdI1EehRUQC01ONZqPy7KLO+taquXowJEFi6Rs07yUzbIpl/dm5R+2QWIHQjFvhawLsu5n2z6jCYXU38fzN/oP8yxLazKUFoug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gggiqSPMwVy1M352MeI7xQHVPsrDG1xLqSrRCf8R00A=;
 b=O0POpoBErw/Don9yUaNgO8cgtt7r3LO/B0FJ5jGet7KF2OfQWVTj8vTEUOCvW/tzjv9sPL+e6BZKmmnYIaQFr2pEYkPZJJEfwBM/6G1sEt5xi5rdnpD6oGk63ue/J9ixY/uaNgKrGIatlyORQqKPcD/22N4rw2JP2eCS7oOeYc4cHVSTP0Q7XQuIltlyzzd74B6JXCszmiZuXg7qGPmnRj5sU6B7z/vEYeqLuezP1MltOJEnZ0wh4OdnV5L1dti4z7EaTJLQAhcFf/tbaB7ulL5BiL5UGcGjn3G5Uu1qABPFLl/fDBFHNoaegJFkQ7H20OUVdp2jMQgSvnKYapTnJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gggiqSPMwVy1M352MeI7xQHVPsrDG1xLqSrRCf8R00A=;
 b=XhGxYOrkgqAvClxP9XUbLgIytYKgeTr4R4p3c+FupEEcczIvbVHB3pL0RwORDzTMild3rDiyGghs+RZ/ewYWnQRjqTIEmGj8hLPgomGJ4HRJVm4rl9ddzaACBdR198tKwgzg/UZ/w/Fyui6700gnEYs8mx3o+tWupKhKhSCAvRA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5197.namprd10.prod.outlook.com (2603:10b6:5:3ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 01:53:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 01:53:27 +0000
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcm_loop: fix wrong abort tag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250313014728.105849-1-kanie@linux.alibaba.com> (Guixin Liu's
	message of "Thu, 13 Mar 2025 09:47:27 +0800")
Organization: Oracle Corporation
Message-ID: <yq1o6xzcdg8.fsf@ca-mkp.ca.oracle.com>
References: <20250313014728.105849-1-kanie@linux.alibaba.com>
Date: Mon, 17 Mar 2025 21:53:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00016415.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:d) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: cf04f3d8-5f21-4613-d277-08dd65bfacff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eEeGWEdPVyiDsNY6u1XwC3glKya2ZRpw50RMu5iN09uGTTNy4tw9k8zzQwew?=
 =?us-ascii?Q?E/6zpa8cWqezbSh8zPF9KmZp3pv7EBCtc3dOw4JkGH0BPqqgFxopeOghSIOy?=
 =?us-ascii?Q?0iVJOrB749TfecxgyL8FSJx0okvy7IQx2lbRM4SmY2YlNK2vK+9XmPFh4Hkm?=
 =?us-ascii?Q?uVGXfzmbsFmjKhBrd455OJ89I7jg6wGaKjpzinaHLqcHiwBiln66DoNxyfr0?=
 =?us-ascii?Q?8/w2fY9E1CogUJnnWmndlWxgQRJiwSM9LslOcDljGK9rioNU8QWFiNsl140S?=
 =?us-ascii?Q?+1o85l1nqLf2Mept/pIjs4ZjebZxxXQuuN8lTuwHxNsdZNhZSM/1V2lObVtw?=
 =?us-ascii?Q?fz0J1klPzMKbU2lnHtyAJKoCKipZv019Hp6/TpMwoOyw9O/UlfQ4n1BbG2Ra?=
 =?us-ascii?Q?YrRWSBk1/69gJ5etpm+7JCNFh2+lj5eLg0Ii/RTnGOTxfJFQalkDB/2OFR2x?=
 =?us-ascii?Q?8adrWYfQ7r4RFpT81QTePyK+wB7M7A8P1z6BCL5D9FBzNB5qGtTKS1pPsFfj?=
 =?us-ascii?Q?yb5odzEUE2rd3mYf9gipyt8SHi4btCzHaBCs8WHF7wfebMC6t8nZQeI5+zU9?=
 =?us-ascii?Q?NVIhZKERUGF3l/cv/XqvHA70HgZEhYA78dwW/A7OGK9GPy4YWo+axDDfh6yo?=
 =?us-ascii?Q?TFEkKa1RImZ4HwN+ITVMf0n5bQH0Uylh8ID3elsc+jehVAQwVv2BgVFRgl+K?=
 =?us-ascii?Q?1qJi5bJoBkJVz3+Ef8uLF6KyxMTDM9e4mrNaCrJt7uGFJeXOyZKIZ2VI/Mui?=
 =?us-ascii?Q?zGqd6M6RP+SXvyxResADUELwhZ/rL+WJ54wD1oO/eXf96hjfh+GpG5HqK+kF?=
 =?us-ascii?Q?92no8WAv671v6pbncAEI5XAc5Q5s3ielZSCRoj+5eHeq0w5a4w1QbVWC72Ex?=
 =?us-ascii?Q?UJEmjKcYYrfdpLQS0J5SiklxfVWfH4pFvs15kOuiNFr1TFLw/wf7vZJk27OS?=
 =?us-ascii?Q?xvIUPYF80+mvRIoG/zwb9Lr7Hq5b9k9ETx7RG9K5qt0a7p8XJjtHtW7rg/OP?=
 =?us-ascii?Q?W5yl56QIDYAt7bYh5T2UBIcH9B1xzK+V2AZsbngO3PAXR3sswQH3FrpqEovG?=
 =?us-ascii?Q?LZgsz9uKUn+Abcs7z0IeATXRy+j4CIoXsMkko9ImsMbXWsQh7xf9sIHFFpuz?=
 =?us-ascii?Q?efIknhHDCa1oeqamPfWVJ0yf48kLc7Kvyf9aNespYeTP1e75nHkhg0u5QZi5?=
 =?us-ascii?Q?pssOQdJbsWyTkoGK0MABeIJVv+BAmF+hcJjT0I32gor5yfY8aLhwm3SngvkF?=
 =?us-ascii?Q?xlnrVxSoyVY1wGt/Z93ZsTfirsCS6rNZIy1j4nSZIcTE44GG6biiMomxQLpl?=
 =?us-ascii?Q?hNOH9ehvk9f3SeiO/1LxSvjt5GKmh/94f2VUdNkE/v09OpCdDU4xQDOn0nK/?=
 =?us-ascii?Q?uHGhsiokbDfw6Us0Q2l6Hd/keF3c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dAlCP9U/MB/+eweBSiropbbK4Au65Ndd9TpBi0WOqZQxK7w/aoq2kx3gtlOy?=
 =?us-ascii?Q?bhHfusNT23+UafowVxJZPl14TWxYNUb8vcSnexOgMwXmTjEGn8uoE9F2Q90f?=
 =?us-ascii?Q?MMGwW/xqGKnzGRD9pepKcWCbhR14TF00XwX/x3lNMqeOOjmJ84dq2Yc4cxqH?=
 =?us-ascii?Q?O5jeuO9KJQxDcaMixvCjzDfiRDtGJHW5L8zo7CLwhlJgAZ38aI8aSzntO63U?=
 =?us-ascii?Q?a/dMyh8aaZaltZHgGSkNGeAViR5/IRjJtcbH66G7CmHeTL8wKLWeK1J/QXF2?=
 =?us-ascii?Q?iScdMjjNqkbaJhhOc44MwYcGHpbOScYinmr2fnaH8m9jYK7yvROPNgU+DKyJ?=
 =?us-ascii?Q?rbzDsiQtvjSaRFWJKUfcHaxpsCfIoRFY135mWvHqyzb0PLsLO/4NoqfFS6If?=
 =?us-ascii?Q?LZMSdbYaJfeHI19fRNQOJcTgI4dsH4fpBymZEMSoo7k6DvqKJq/GvDTmcnCW?=
 =?us-ascii?Q?2pUqmtd1PZcskh88DpdVfVE/aHc7UIfChLyl0jTPg7KntP8wFw+SSpzMugk9?=
 =?us-ascii?Q?gY8AxON4TthvXi8xaFPs5GZdNF2qwrU6C1tErteOw1F8mI2dvyUhr3DdCxLl?=
 =?us-ascii?Q?VWk/2VOzW8sLb+lSusPaegOECJxuuqTTkau0wM9j+Oln/BCVe2qstHz1Mh2p?=
 =?us-ascii?Q?/J3I+M7+T32gsDFwKXkBKYqeW+8rkpqwuG2h5uW2p71n9vbB1Yq+JH692Awy?=
 =?us-ascii?Q?wwj2neJ81IsHC0FHHCXAfaNOzqiPW99czwjnAzJF3m58rPf9nd8MPDz5mRJY?=
 =?us-ascii?Q?tU1ePoShyz7QIpLmEXNwU0ApmDRui3Sp2JIF4I6BtlGhhblIUBbhZgzPDqDO?=
 =?us-ascii?Q?p6S4W0xVnVEANRK8dynGyYdssTDOH8gl44qQii9r6UU1PzRXzyg7fVKRDtU7?=
 =?us-ascii?Q?CbKgAlQRWIGvQUeRe5kBJkE1XCPt5OAMQWmGIYOkZPGoZ244a9W12bkQW/+H?=
 =?us-ascii?Q?ZrxLuWqExvt/TA1UHYeRxc1+K9rh1rNf20oLO1x6W6JEWmog8dJxFuC4qoNE?=
 =?us-ascii?Q?jkrio1JVl8iN0+ZSUrfCV4Ydih029MAYj0lHeD0F/GyvUw85rMcRsHvkhxaG?=
 =?us-ascii?Q?mYHjHThGDyutz6S4hCGnp1oOCjGe67LOmsf1DKsNPH2czPjGuGtnwcvtF/lD?=
 =?us-ascii?Q?x19KMicJmkiC1BuOyP3GJjnjo79LsdKM1LBS3fr8Uabn3lIz8y18j2N/ooDt?=
 =?us-ascii?Q?XyKxEbZo5ZG9X4AIN7YaThqnVYoz+zwRgCzYlZXgUJ3YG4qQmf+MbJDSP3ry?=
 =?us-ascii?Q?fRr7t+eFA1qvU2ZajQMdZHWD5ZW8af2PXE4atVpVXtnOBdaJqEIPOezUWdAu?=
 =?us-ascii?Q?t7gGNSYCZuFppyvKPbCkmqsaikcVOwM44tuMPwBFLk/5+1K8fG5mbTDfo6m4?=
 =?us-ascii?Q?GOPG2tNTp2CcSBnMgKXRk9HVlWY/9pNwMizodRvlkCRbmH6Xt0lbyDwrqIRg?=
 =?us-ascii?Q?t9FRFjP8AON1EQI9bHHba7bd81ejtuUt2R0IStHhi/CnwOwNCCEi8wVHHz9B?=
 =?us-ascii?Q?ccfSx9QtKU31Dyh4/QzHElNABstVyv7Oy9oWW0jFVbZ1eAd1pMmtO0I+5o7l?=
 =?us-ascii?Q?wvdPrlWPxrzB/EWHj4Lrg01ldTySTFVFyt8XxyjqPD4OSzg2thM/Ju8p+fG7?=
 =?us-ascii?Q?5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nNI7/9kbp0Z888FIObP4xvSZOJ5Ez4lh5B1F0Am+uXQraMo10nvi0RuUijpHFmGLoxHBmgUMVC+O5SPXhwAojR2tOr0RcuOrBp04Dx9s91kwU1gfikUT68JFHdPMtUZ3U6M0PEkzjLPEwHjVxvCanKshjiH8WPri4UvuA0Idrt0Xr4y3qcLIiusf1E49e5UX8GV5PA9/vosb35j6EB/13/u9wBn03+mrcbsX6PrEhC406yEUkvc3CRiuhpw0Kv1aYlI4qYRkLO7lRmMihU2LHj4O3csJDjCbbUJOOE9AS3sHFR98etkvZyPBa4kmmlziGHBBuk5QBV82z8vDP7rchQN+oU2HGLAgF9QBp6rYFw7vI9rvZW75YEXtAie0EA3brSF+xoDFrrlLF5jNZJ5gmHPtC4H2RMWYgfZWukOgdEtxQUG2F0WeN07rtEcLMNrL5FrJPjx0nVzn2WIis1P5qmCcr9yRVveNj9p6+oG5CZII1epy9by1dTVe7+Favqbg+k3Y7XI5TNfECh/oWvxDhaK+zedjomcphiU85B+T4Ts9srYhXz20jXqcohCaFnkrx2GT7XIV+7zqrRNHUwXSMk3J3Wn2moEbKIQ9yqa1FeE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf04f3d8-5f21-4613-d277-08dd65bfacff
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 01:53:27.3148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBthHcYkdVfR1jEhUGyO9tT4bx+klGmgSnogyQ9doncauGu4n5E1kMZ42y0t+97Ay2Rpk4d1jkxjyMHvWlPFah8XsNBatR0x91xicQlhgqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_01,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=948 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503180012
X-Proofpoint-ORIG-GUID: Dw-ZIrR0y9QO3Qb0lYRmt-3IqeAqFzpc
X-Proofpoint-GUID: Dw-ZIrR0y9QO3Qb0lYRmt-3IqeAqFzpc


Guixin,

> When the tcm_loop_nr_hw_queues is set to a value greater than 1, the
> tags of requests in the block layer are no longer unique. This may
> lead to erroneous aborting of commands with the same tag. The issue
> can be resolved by using blk_mq_unique_tag to generate globally unique
> identifiers by combining the hardware queue index and per-queue tags.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
