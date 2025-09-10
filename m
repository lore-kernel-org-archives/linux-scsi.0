Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E003524728E;
	Wed, 10 Sep 2025 02:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473110; cv=fail; b=nUpun1iJx/lFuQhGn0sgZcJhUyYsnPKnWpLG44zsst6tq8aTk/vcLqSnRhL+bq4ef0TOHHyjnDSl3UDCql26ayWHL4FTSHHEI7b1smCaghpcEOTZombGGFuy2WwiEgt+PTXjiQXSBpszqPlgkOLA09kaQvmoJsfH1AHpEGxoz2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473110; c=relaxed/simple;
	bh=UGUt7JXnOfJqpoLq9KGPYS2PYEsE0ug77WC5rNuts0I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DxCaaQtqUT0F0x8u+17EAFE70t++Mca30+eZr1CXomUyxKYXHyeWZau7Z+3db8Zx4j/5gtOrb3HnOvc7JTBNAaWn2q7xbtrixuBluBRP4d6DpspJCv8UUnhjTE9w4Z2e82jSDqcpZnXDso/3w1ClbDCZPrZ1D+evitclQu04M0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U91MUXrh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xUy+Wz3J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U91MUXrh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xUy+Wz3J"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0kX8032544;
	Wed, 10 Sep 2025 02:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/KfvQWCU6moECS43j4
	VxN7/xxhPIUqBg9sxR5ql5MBY=; b=U91MUXrhp49S814Er+VZ5HeCzsrW99+sl1
	d/yqSRpxzu2zJlcm7ufvtHmE53ILwrR1BS2rOPNFu7xYIoOxBeTWAKqxuhIdlcI2
	hEECgzC5ETIcVMWvSClqNhcEg2KlMdygV2dSoIcBRAgbTIlQjZfSWSMvVgc/Xlcb
	dEfJnqIWZHvO9tEItxelIrZLVowrbqwpCaBE3tEMwjtjdcyjPjYKKXKGGv0fRcHe
	RV9pt/FbOUVtp2UTtEGoQPbvkwj3qnjIvT9yml4bPnQmqA6GoaLWAKi1JXI3nmSY
	pGuF+uhHv7Qxbl/ZFlPT3SFgpnUV4J7J0dzSg2iF7ZLWCuDjNtcA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2u7xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:58:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A0UQOS026140;
	Wed, 10 Sep 2025 02:58:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdaeq7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dGaCmttGzO5A65FiGMIOqWs00x75ME6oPtyrJm+IQYZABjD4IqzzQn3We88J96HZ/lajnYCUavhP7fMoLmP8HRJ2sHz2qGPBu0XBN38mKoHZUlrJ5Ha+NtQJbX+LP31aIL2IKvlaiDq9xIVxkErjn3NshAzKMOc8HZZ6vOIf7lMYOBIpV/qkOD7Vl3vSGKZGFozF8LIhhRz9vlFywpz/fEO+mbPwDlxR1knrpe2RGQOVirMUH7a9YF4qKcprZyPwJWvx166WP5ST84+gTmUzHLB9ZqWFqqcztC5v5iwth6o7G8KSOjZIPx+urisrOUQJE84pIeVjUoaaYoE10VJkUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KfvQWCU6moECS43j4VxN7/xxhPIUqBg9sxR5ql5MBY=;
 b=XivueV1ODcFzJnFiUdFf9dym7+LY1cFmOwuJCwx642362H+oSx6IyRLEC/o0m71TU9JSk5DbDesXaxIpifplPZg1VXe/iE7Xyizqsq5I6lXWO3Tm4EyX5kz/yhtKq83FSgrM86EiiBl0y1ruVfTf62J4NsKGhkCb6ExDwmZR6qqAVpryEA7Y50nDCjuAJ9A3Jy2fCfDtKbP53f/MNd4TsVSBYQtQ2Vq22o8+fK7Hgp0EqXyPfTzw+8g4NmGnEaRjA5VtE1bO79NJqq+HyF8spusuhsJNq/CxjUtjLAVsns2t3EmWBXe4OyekLYI4vpsuwnSNETIg/6tCr1sKXSmNEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KfvQWCU6moECS43j4VxN7/xxhPIUqBg9sxR5ql5MBY=;
 b=xUy+Wz3JqOMI/VUGNxmucDyyk7m66ju6xGiIwqn44c44TvHRjPwN0cVa9bzoKHUkZrNMo8O4PRxXYOdOhm2GlOSqLemUa/s6FesRsBRrFoDW1UitFksoz7icXWu25HSib9l2mBNNL63xFKeFAYI2NuL/hufGWmGwwe3S+YUDazo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8275.namprd10.prod.outlook.com (2603:10b6:208:577::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 10 Sep
 2025 02:58:13 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 02:58:13 +0000
To: liuqiangneo@163.com
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Liu
 <liuqiang@kylinos.cn>
Subject: Re: [PATCH] [SCSI] bfa: Remove self-assignment code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250904093600.175762-1-liuqiangneo@163.com>
	(liuqiangneo@163.com's message of "Thu, 4 Sep 2025 17:35:58 +0800")
Organization: Oracle Corporation
Message-ID: <yq1tt1b3tga.fsf@ca-mkp.ca.oracle.com>
References: <20250904093600.175762-1-liuqiangneo@163.com>
Date: Tue, 09 Sep 2025 22:58:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0034.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8275:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b739570-af92-4900-c1c2-08ddf015e1fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z5A1kalx4H2XdK8NSWZcldn9U/48JIkdGAyCy4Tr34svKs1BMng1r81HmqVD?=
 =?us-ascii?Q?KEjN3OO/KpC4sFGOOp4+pbv9wjmCw3ZyHVzlHXRF5z27he0mNMr4zuBEFJWC?=
 =?us-ascii?Q?8UT4BisQb6/a+glk94Sz1Q/srWlL1T7eJwp+LkpRzHkWQwuZs77WBlgeSVY5?=
 =?us-ascii?Q?Yo6smotgi9ckziK7oWVMXzY/ODlV9Pz4m6ovgC2fgOKZLTS2ubMAxEV/0YCK?=
 =?us-ascii?Q?0pHLkudFRm5jk8J8IeBrkaGiWMcpM3h5Hzr8t2NDOtclCb2JWdGPIAUUUxMK?=
 =?us-ascii?Q?6LG1i/NmSWuiXuL/8crGk8LOOd9HMF1ZH72eRKz1L6fRGk6Sv9SxJGEInezp?=
 =?us-ascii?Q?kj3EH1X23n4IV+K7wlrOEQYfzjwRTXEXItfCkaI/KmMYs2CFeEP/OH0nlxsc?=
 =?us-ascii?Q?gOL/XGwC4xOyMJJcxg2MBb5aPLTAxizB6p9RuLAP5qqgmTroR1ILCuEJXT/S?=
 =?us-ascii?Q?WT9vA6+16rTARBzYXpiNl6vnaryaKZGi2gW0OQwkNVakxX4d3L8flfhpu6Et?=
 =?us-ascii?Q?t+ychy8DTOoSLleeARv+6AfyeqURZ0xzDBcYlyyuqRxmuxpu35aBEprF5MUi?=
 =?us-ascii?Q?OatAgXCA1r/SPCDhHk4DZlQ3+NrV3YigyQxpyW9SX/Y7LHtJrFwgG52KOIbp?=
 =?us-ascii?Q?wqwo5r70LNsUG6G3ftVfd/g3k3Zqnvaw+jfxqj/Z/ucX8aEppdqofV92QKSJ?=
 =?us-ascii?Q?5RM1YUI7b685DVCP4s/nec6iBzws0KACBfBoNm7qc/QBOnHf5YEfTHkgcZFx?=
 =?us-ascii?Q?XwLeeQI5bGkKDDz2ERf/t2Hip20Zyd39bxg33BQmqqxnCrul6GX/xJpMKQb2?=
 =?us-ascii?Q?wYb+qpUAqTyBlums0YW67R9eDqQQqfQFmRzfFn5P7X0lGi/0GesUDH+2rZea?=
 =?us-ascii?Q?J+2ULG7BpCEu/wQkrN2QIBNz8YjBq8I19TWZ71YAPorLDazQGSdTr8lZ6H/6?=
 =?us-ascii?Q?bd7S3jYUu71FNeiHgkN4NCDm4vZ83f98qIzKknGHAdSF+haqadLNP2JpA1qj?=
 =?us-ascii?Q?9zqdXYrJjmXfHhN/wDEFsC0zt3Ft6u6fDLZQvLt0e8MAOv4styM3s5sp0Gge?=
 =?us-ascii?Q?3qwYiJDY064STrWq1rTJTrMTnxuYNZA1dHz7NwstKXXMGjI0oaNkr/TfXmfr?=
 =?us-ascii?Q?2LF+gNMUrz8qzDC3WMtSSI68FqtVeir+yZaDZFdM38fsMekfe1MunwFyfvj2?=
 =?us-ascii?Q?ODjc73CFX+XTPgLaoyfLtf7ISwIQQO6cZkm+fjuLxj4GbL+DOp3lcOtHp1Rc?=
 =?us-ascii?Q?UfMB25/0CI5XhWpbbZw2sLjLIZ3EGpxsn23wiJwiCQVmrsrbDyWO5oF2vqQs?=
 =?us-ascii?Q?WL8tuQErKIoHvGBKDU8um+l8vg4ZDNy/hu56grR+j1ZCMHKqgKTFvh9GJpyV?=
 =?us-ascii?Q?GhkcSd6aaP5ksYSxF+e0jm4obIAZLOZitaBiT5CTYvrq/sHLwXfA5tVBUSxB?=
 =?us-ascii?Q?e+hzy17He08=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TRQYX95FNBk60fvmEQ7cGN/vPhmUo1uY7Z5m2j1RTVpLMrZi+2IZFyR3eiTk?=
 =?us-ascii?Q?uTW0h7qMv3ubCOGww17NdgpcUHRhij6aKNULj5+mcmIH7qHYirG1W9wF+1dh?=
 =?us-ascii?Q?YOGH3+0vvBvJszDwZ01joTICjj5LC+99yDgA6P1c7/iTuzB1sXf7UMNtvlUQ?=
 =?us-ascii?Q?dobR1lpLONzyFGAXR0YISzh9PXA12+8lTUnp0c7zqUvnmycvJ35LbpVyXu+4?=
 =?us-ascii?Q?ESLT1ua14L+XHkTaWiWs+Pzbhsse6GmbviLfGCMOaDdTqmT8mQVQOYksy3cU?=
 =?us-ascii?Q?KudjWnUUjzHI7T1OwQlMXcTt5/Rb6/Fl+ae+qW8XbZI5/OSg9/LPZxB5Jbki?=
 =?us-ascii?Q?mWAtqswvmCMXZq5CD/XTxywEkb1pfsGo+k2696ui3glSJ1F+FcqJHlg4p9oT?=
 =?us-ascii?Q?O6nviqzI87okftcm2pEEhMe9XIPw/QEFrCd/FqmLwRwT9IJyMxV11h4b4GS+?=
 =?us-ascii?Q?mpxeSDdqlTNX1MeyQz56WSC2Sfx6oJqN/3KILC9RbkPD01r+RucVWGjFN0oO?=
 =?us-ascii?Q?99iR3bFt15utj0ogTS41t9Vyj8WM7NsmWoVbTUJ5njd0SLEdmz+wI6WRzx00?=
 =?us-ascii?Q?gEGxb4G4VJEw8wJZi+QXNVncxQv8urUIQURzUKGAQ+cxu572EgsXh2JY/d0h?=
 =?us-ascii?Q?9qGajhZLfhFaiGfEYIvschEELkJ8H87aGs2maH3hG5SUHx9g9g7+gVdbLAyE?=
 =?us-ascii?Q?ZavSVOsZvdO2m/w7zAZRWqAdB1DMDLnHL5HkXJqcitUVKppvMtuF8CYK1S12?=
 =?us-ascii?Q?HR9PGQapcaCa4WhXCmU0t+aa8Jnm4tJIcycEGAL0+KId0nKdpYbMu2r4aCvz?=
 =?us-ascii?Q?LWj+x5jtKYLij3FrQYF2JwMyxeULX12EI/4+3WjZYIY5wCYYLOy8g5nIDYi5?=
 =?us-ascii?Q?qhz7fBXyEvMboH+5GKjYJSpv1d/ONBkSmMd9roYYnRS/Yb1qTkdU/1ZZV+Gw?=
 =?us-ascii?Q?hKhiFf3gUfrlDwSFKcecB/vnyyd34JS/kKUOQXS8s2A51mI3M3SFsW2Iy2jg?=
 =?us-ascii?Q?RiQDrQcMQV656E2aMrUEKjliII9R7MZ4dumCvqTXRpHFioKoCY6XrIgVXbSs?=
 =?us-ascii?Q?DA5DMaB56lV4HHTJfRGWm+YMshNezezMqZWYhNn/OnaqM/XBQPa8nHiCeFC4?=
 =?us-ascii?Q?lUdc3j+BokJgsoOf9DszFW6/VbL54mijHpn7xlaZYbeOPR0j7Eb+123lpgB4?=
 =?us-ascii?Q?gFnyFU4InRedUgZ3z8oIRPzrW0TPxTVCWAi4SjDhBESBjSUAYLB58bfuUWvd?=
 =?us-ascii?Q?GNDr1psJgDdne7O28kcp+YCHx/+0+QPPfeyC0+JkspGwUwpaVRqT1Cv+2Bef?=
 =?us-ascii?Q?If6vyBD5RojR0pthosuCDZi2oIUZPgHUbYhtP8ykHZ5RtEihCZm8ArJPggDH?=
 =?us-ascii?Q?h2+rP+6dreBl/da2kHDsDdWybgE6mLfUzNtvg+e6oAuQq9W+ammhwH6MK0Ln?=
 =?us-ascii?Q?rePOtfd8TNc/z0XWaUDSs4mXBH1gF1M8u9ZLHtF5LQ1lGB21TBjBqmTSHUgv?=
 =?us-ascii?Q?eMqI+AiIDtaIb+bFTGHb9UkWG/kz2hYgsyM95URaWD8OmiVX1kBgNXdlyf1h?=
 =?us-ascii?Q?IfRw9l42hCfRtYPNVwYmHjB6AwEBG2v45fJOTmwyKvEShWmeAZi53xaKhjWj?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rlvIqtNxsEZ9DmgTOZPAyIqyoOIjG0hc9oe1l/uCzB+JexZpYu4NbkLF0mEKp4/CeY0RQzYVKMvMJFCGYQLKimPnhDZTGw19AZPEYyxqMhcYaZyylabtgWdfBAzHr45W2iH7KpfdJsFT62BJNUWjcUms8kIENoJnH05bo+RTyyJKABoDfgSDP0ugGhtWfludj91hxelXwuGKY6L8eo8yBjj+OSs2EiiT3eqR09SoPjV8Ybje+Jdg5pdHEEpCcVm5UJ+TyEdM0eqKU51kg2fWXPAjX/SmdY7ILragyUiesSZQOp73iX/COisgdUA033r6LY7eDVgvx7jtvD01CJHOZBH+hlkC1YPo6tc9cCUJPVJ2klO0RjHVABLqhWayZjmFZzGjzBMKS5nc6NTEGsVcLyPYNcCh1mq5gKI46UbyA+JJlGsKTsU7QfdrrM9+uhHPnKgRJisZqVWHEvZln4gc43I+3JOH49MSNzg9YlPIkdpteqn73QFtuGhq/qdB4K+cJ9kLFxJcOKWMczfwxJGlX8DibFAaBvrva/xmukO2zUNfibmxIz5ctDwu4dn+ABdJgoBUDr6y2C4YCAIfJvh2bIGgZdLzQUMslPsjIIGFWyk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b739570-af92-4900-c1c2-08ddf015e1fa
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:58:13.3922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYbkAPfBJvktF48HZJ4kmGCckXKAyOMhlMBVTQkNAx2M4lhgugFTM6hBBCpiwuasPdqeYaCRrf2bK0eJoe3ywy4pG7N4E/b3TyfezaOWXvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=966
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100024
X-Proofpoint-GUID: HPC-8OGSYUOMLCvKLDsmx18ixGiRP8S3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfX9DCXmWbnZR6i
 MPFLXB2eIwS7PzqbX797b1dnAClWw/z7H6pLVSTrDh+IOQXYxwzvRxs7sEmnSbnhrEU/3Zdhm94
 MPt9ONYAJlHqu4ZjNXtQ/AlcCFQ31NLLPlB3TMVI2J/0ujGhaJm7DmNWCPjFWTkU6Wr2uB80/7I
 cJKZQLn57lcHF6iM17ieaR39AzbzGYhkN93tlUeNtaHhuli5ExoAoVHj1ncvy5dLr+Jsg6QeOKF
 c+CSHZm1ozfBqvUysyRBF/0GtWlO2QDA60/MlRn/5jGtOiLsJ2RmQVSsFzdMBhuoL4aJ/Gxa0d6
 ZB89+DnICtw+KWLKUChTOeFnN1lQjAnkXX76S2S3o5HAgGhTghyPJItoytHJZ+N7FMRN4BSBjck
 ANl3CWrZL7mdPftrbCDhduEY0ZXqbA==
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c0e949 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=7-8EVNUgK-EBv_froikA:9 cc=ntf awl=host:13614
X-Proofpoint-ORIG-GUID: HPC-8OGSYUOMLCvKLDsmx18ixGiRP8S3


> The variable num_cqs is of type u8 and does not require be16_to_cpu
> conversion, so the redundant  code is removed.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
