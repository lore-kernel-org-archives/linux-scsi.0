Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070F44399CE;
	Thu, 23 Jul 2026 09:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799510; cv=fail; b=az9bbiMahfAvS9+Qo6tGSc1tQV/YPMEgFiSzBL83HQEP+8rLQ09KkaA/atAkoljSCxQvYsXLGZ4ZaDXEp78RaHQLGQlRXX6hbsb1wOpNdC6N930+77yacFF40UlNTpipH3LodwzxCthb4GSaCZPvnfZic0aqLlkV/9ftW56LUgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799510; c=relaxed/simple;
	bh=FD33QGS6X/eXoFEsr97Dqo03fjeQIoNrhRRDGrLr6wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bSnCNxRIqYGrPJYNesXNwn3S9Vme0teuZovL7Jg/3xZebEQJp3iG3VWbJZcXFlfLMgBzrcJtauRCD66Wlw+mGaTTAnrqH/tMsr78HJv0C4sOAexjUlgUBTMhLlhpJ0p4OC3whkZgBTRoU1yRR+nckm7tdusaWslI+VIRPj9Zupc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T8WDqav3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AV0g3heO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T8WDqav3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AV0g3heO"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtfvc3573953;
	Thu, 23 Jul 2026 09:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uxY6nTKHu2WgsD/fbJ6SymsyPhk5WbDEGESc6o56UDs=; b=
	T8WDqav3yC0IJR+memirOynliz3iECIG77n+5fSJMIHcRzvphai8AUrL+gO7uF2g
	HVNoNAZoygBInYhd815rvfM5Mwdja5Uu7v85ozZWfQalfx2DsNP76ZI/1E5Wpzc6
	AionbvS2W0JNNciQtqiS8eN/WYvUx/lFNUHLeGcB7So4z4rEItyML/9uptnmTDVS
	ZU3z1fadvqnD6wuzOl8MjIZ8vQmRxTCWP4ijiRNFO97G/frsIGYZc0rZd/yec5A6
	0/FUPrFVDv23HdVR37SmguvhDFa2eIkqVRjDuuwdKkNcGyKJHUAP747PjiwB+PIn
	Nc+wJKhqma1rthkqR7yHOw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqpqc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X8Po003486;
	Thu, 23 Jul 2026 09:37:21 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxen58q-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ExBAlU7WFh430wFJ8kgHo4sh/bO9xp2HTDbTk9Orfi9WwkrXOX3jQRSx+dhIo3Y8tZ8tPfKkgv/+gGjDpP0p6RUqSw4KCnEGAm+y1Rr/sBYFRam0Jv1N8cJhp2uaHDRxxAY22uuvEc9faJ9avU52oFlYEt16hDRYw+aqjeG7LDYQUBYmM7Db7VN02ftTtJrNlDpHZ//khpmk+Wr8O6UbzLD2lNMn21iy4MxsNtF+rxJ4P7JnB3CP0k15QAkXHIEky2axH75rKXx2X3rbhIzyJ6HuMQQMejx9Os/qVvK3IYNJ4iIhVIkDMr/wTxhAv0aPoptWBNSSX4v35rhnG/hPww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxY6nTKHu2WgsD/fbJ6SymsyPhk5WbDEGESc6o56UDs=;
 b=idG7E5qOyUAU/J2aGH+yh+6SrCKtZ7+kglrUHVg+BOBScVx+szgkbrsQq8JVo/skdo1g32SFKeZdSOrHodYUHscfNvd3b6lsEcVC6ZQdlVfIH42/kOlvlrneF3Ts6SKcCFWtoYVV35QWvgz0DGE8oS6RpmyrRo5WvlPp0b/maTU+AhL4zufM536QUwfGsP0Uw59w03SEDe4h+clwE9JjTqZShlMVzjhIu4c1YejT+7M+ePos16BkUZUAbk6sN78JMJfbVmk1223teDzzR+n4bY4wxFa8DxbLCLFQNbAfGLKkwSC/2BXvwQNmlC+kRzYgDboTHumHcOyHvTcZ72oyMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxY6nTKHu2WgsD/fbJ6SymsyPhk5WbDEGESc6o56UDs=;
 b=AV0g3heOV9krSk3/xc06P0k0s3sDpL3AQk1s927RGW4MW4NPXrdyQuubcRrQrVrGmUaRon7WOGXtkM6J6yPJEPl/aDTPqy8XHeAfr6Dw3Ir5gWZ9SzQPhinF8xODNnRrOTb2rp74h4HoUELgZPEzUUGKqbipVzapXg6FhRTjkF4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:18 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:17 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 19/28] scsi-multipath: failover handling
Date: Thu, 23 Jul 2026 09:36:17 +0000
Message-ID: <20260723093627.2327456-20-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0016.namprd12.prod.outlook.com
 (2603:10b6:610:57::26) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: d01b19b7-da5c-4ad5-6242-08dee89dfc61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FiKz1N2FBCkQVBU4fniAT2GyyUwpwikhy681rnBLCZfgpxkf62q8pRGFcHpkmDuD9Bnwv1BoILpz7uzT0S/xpWNsrweSdpXfJ2m9GXtVrfABGhLhC3dPSOVSsF/tLp3FLHlRy7TntCERnvp3ypTWNRGwCjBj4+2rlYikODaggHFNNej0mKObkEYIG2IxaUuMZ8Oq+TzOGy6vTvi26+optLgzX02yiJlh8RNrOlK4MX3529SeCee7iznQcbu2QVSmaLpQtb/c6JZPzeaoUKijPvZiWisAKdnAwlGzjBFYdt/ZeD6BncDodguXk+MDQTBvo+B0PNmhDJvAZJIElIEmdqmYrXWxlcS9J4Uox2HQaWutlmZJ/OQn6CsLrSNo3h8ascdQ3DIUpK3DqS5gFTSmoy4/XTcb9XoW9ABBCi/u4zCPb56kNCgnKLbm5hxGJG5vvkMzRN0T4VODafH7jLnAyoZylnaYdBwX6t/GN75b+grdSnI8x+StAKeZulovUfZQtVhfjE3YTKWnAf0ZOTk0J7XPp8l7J4Xndl3+aPPjQZdtAlhGRpyIDjyYaZgh8+zVDzrNJ81XdYF6kWUkHGLn3BtCokk0r+HqvsCENQgdVNyn670LdMWlvUuj6HUnx1TIy1/rKnUrqVcRoASWTP/TaA5m+UMOjh5uZz+60owghoI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kS0I9vOy7Iz8VmmKFw3vN5deImnH833Uzt7AjMTsZQKeATD/5h7+XjwMg0+N?=
 =?us-ascii?Q?SLNTfJ50mSBW8AsxFpgBampNfov6sJu6IArF0Ye0FxF7RaV6QMlIb4r1uoRr?=
 =?us-ascii?Q?I8POHDQ8LuOwABJPHgVG+7h8lgX2zwV1PgqKJEGgfnP2k6uEsmSlqONrqebc?=
 =?us-ascii?Q?TpjHWxOqxJZjMbPhROAcyzY9yiC10adHpojH3XKD7Bdtb+gFRMeH1jjw6Z3Q?=
 =?us-ascii?Q?/XdV5IS7+GQK9nTLesobr2NbggqzeotElx0yKVsgI/KcCqhaC+qm5GVYIn+y?=
 =?us-ascii?Q?cUolzNSsa84y4rQCnPI/B/RAUALo+4/IVbpx95zJ8+7RFxO6gQ6ckL8WrgBk?=
 =?us-ascii?Q?52+rB8bvrtKIPJWUrIKtW10S1HzX6U52dTUahzpM+g4itGs0to4kPc/6tgRJ?=
 =?us-ascii?Q?vrAvV8bRVrxyzGy3YGqzIXGRgtPFw00fQS5INaHByCX502l+AhLAbF3yhrMs?=
 =?us-ascii?Q?CvAUEt7a3tL0dKijp7IgBh/hhqHhR2/XMs0oJU4q6P6ONTUo+Xruxj9IIXkp?=
 =?us-ascii?Q?ZtdvXBgTv5gQtBZBd10rDbFmJK7l4kB/vufVUC4XbcmqoBxuQQnot3ZiGzsw?=
 =?us-ascii?Q?qb7n1oo0z2q8BW7VDS+o0h2ssZ17jsDUcJkw9/+gJyc6ZnxlVAjIL3yOaz/8?=
 =?us-ascii?Q?TmZabjfsZ262j7j3upwkQPBhESZuh+4h6C/pRUREtjlI8OtUGqd7e+yHzznW?=
 =?us-ascii?Q?t/tZximkOOUw/lPpUcC1nDkmFVLBOjpO21R0tgcBcTT3nFS4aPuvUNydVzzp?=
 =?us-ascii?Q?oOX9DZGGq16jF7N8blh7sO282nZfzyeRiF14W3qJFS/41R9/1moR8M8Pfl+v?=
 =?us-ascii?Q?T6tcOJTXpD/m03CGhx4oafk4jMDY+ckjbsCwsAYwvsoqGpa+6ypYqrv4UcGI?=
 =?us-ascii?Q?JS4mTYt7jCnUvqiVbqBM3tBIYJKtCYDnXAwiXv3T79NOMrDNGXV1IUGY80gQ?=
 =?us-ascii?Q?v1754bExsfoWkoZ0XjTPSH27UY2RFtMk4jFTM7zM3y7jiNG1IMpQdgIWdH0L?=
 =?us-ascii?Q?YXNLOWwrLXyYJo/9ozSNMKoXEggieiMY/btjAMRUHRKr6YvgZfGBbvo2JayO?=
 =?us-ascii?Q?H8Lza37Rs8webteFccxWBsGcA9KffB+XSsvSbUEDSMasYlG2vBKbCvDzSnVl?=
 =?us-ascii?Q?HQCm/TVYxzm/sJLSyeJafxmHq9sLBn5UN1feQnNlTS71dyIT1HIqiL8ZvZLL?=
 =?us-ascii?Q?H4mYffbXN6EXtjVUFyfYx3CFZvORsDLzivMAugETav6kOnJMkjVV3jZj66T8?=
 =?us-ascii?Q?WLllXKlcumQW9uJn2g6vz86ooe3p6VJxBjIuF+hhST4xqzUWeQeaNY3tTzxf?=
 =?us-ascii?Q?j6XEAOTwsAEsDoeNlojaTjBkWWGMe+xTJ5t1Vl7O5obcVaz0yWQT+b/mMQD4?=
 =?us-ascii?Q?43rHiRnah2zurA/Dxa1s6UajEAaQqjSrFegR0v4zTPt82GhuZUtHsput9eQ1?=
 =?us-ascii?Q?5fCvmO7YEFFjzC0l6U1vAQO9bjUXr+74pxo8O8yjKT+OKlxFIixhxp+p9NNX?=
 =?us-ascii?Q?L14h3g02uVb75rZUGRe+0QuBgIpdDXrChrU+0eSwa8x/EkGGTWIVlWnjGKbd?=
 =?us-ascii?Q?E9YnI9KFIyz1sz03SmCer+9NxqKeaz53+RxeSCmLxzHXqIOGF2k2tICPQwMU?=
 =?us-ascii?Q?OHXq0zZrygHnW4I0q+fNpL/XN+m2UWVpc/S/5CJpeLVu+5+jo9YOA1nxBaiU?=
 =?us-ascii?Q?ybSUTv8vgiuyCgdCrAanK9z2QDc1GwnkDepj+6g0Ystuy7nC0ZdvaPkhDYjE?=
 =?us-ascii?Q?3kwyk2Iv/2iZk2B2ca2Scwb1nX6HCHk=3D?=
X-Exchange-RoutingPolicyChecked:
	RwvQuOpaeAMyH96MylVnouSig/fWagsDEZUZE/NGAHhP+WUWCdza5Sh1GTPP4CgYXOGKryQ9FqyAg8Qjw+AqF8B+RJ0C0SbNPyUc+mtceXuGwyMHYujjQEWNa15U3N7YXV1nZarMv7RINomPWulJGWxsSkXhXInAtnr+/yb/1dACWLhDqx/RlzNZwgrXQysNDYShOKtnA0LlUs1PHxo+zE1KnAzLXC4Tgv3wK8PGUrP07mdJFkTX8VaVFWUi47Tzntr+DGTeRrLoootJSE6akzzrkMsyhwWNQM8+TY2d0TN6TY9dYA4FyeEPK2BYPuzYPaE4J6YS+Ry1a2Kvv0YZMA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0pTEqDu1rlhIXARwW3jTiFWpfFWbgcaxQSr4WnzW52ERwvmCskAqa8b5ZDbVfVbJNEq4553GSyhjcpJy5+g5BfALPbGq5eJrg5ubW1Px5BqHoM4pqA7wotnDwUYJDpX0fz1mXDRyXaYzBRS3rTfArgNB5eOlt9nu/gu4kqPMVLNN36XfgXxGTgJgejb+VZROxqjAww44qASeIo4PMXbN67gH5EyJMBIHo+Dy0TgYcvMxQRtglnhgr/nH52bSc23MHLlx+f5YvrmSTsZ/3+mvjtmVXxPbofNSnUhKsbzkgQmm16rHMRtAbtL7t4iyxDZLFN7IE+dhHOVBJ7xLWjAQGX+SKTvy6bLp2GIUOAxA05iXQEl06jcZYE6N244qgjNYsbPJtYsaJMwecj1kptoB4iw8RxbxQixoBOwb7B1KpDrOfY0dseX5GYhkyh0PrxWXRsxteeeh1ybBhzJQs9DWxa4ylRn2z5nVAZ4nTalH+GQDQx5gv+suRrbWYRDK1FFbr2u73FGT32TjQqlWHx0haaAOBqvERr5OFhInd5ZSCg3oWvcTk+eTyqJqFcXJNwtCAuQ0gjtk9fJMNz0Izp6BN/A7ule7e6CQgwzikng/z4s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d01b19b7-da5c-4ad5-6242-08dee89dfc61
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:17.7768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdqJrKMct9M1wkPO9JjyDkAaSPc/Tps0EKcR/eoMeOaoxGy9JU6oTT18b1eGf6NUYMHXhw8kQtmDSbZ2EWpIXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-ORIG-GUID: 1D8Kmmg4FiVj7qukiptvL-3tlbewHGWq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX9PQT15ry54Ha
 hhgjS7ejNvZ9j3icRGJUzzSZ3W9EmdXB973VRT3Z4UxzwlT39mcx3PutFuwjPAyg0uDW793m2kk
 KPUZoMbXHqpC3+ForeMeBd8DpPKgPdJhR69oB3re4kiQbFqt1SqFAqDr/EaK3g3TWnu6DHZfirH
 avZSFcuw5nSD/U+zSlcZAmKIu6wha6y6kQwTXVmSWUXklH8QK6NBhKubqpAEXtCgtSq4Xl7RWgr
 L2IJeaq9kkbiWYQCR0oof22r0McJlTo/5ysV0S+io8NCAan/ypGksOeaNwYU2JFEA1T1VWkLIJ/
 R4efmPiv4CX9RFWay8UXRcS1L3/4hNfVkQ8j/4Y2WrqRXwKs+vkJyQ8fSMDHLzjSnyRUq2nlfoQ
 60PHoiQgoNNueS+vYd5mN7Pv62x/gP1bSbMBpzPfVTkTTn3uY+AClogvmrVW7m3wtBp0M5VD3GI
 VS90XFsl0tnpfm+pqBw==
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61e0d1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=KFrTxiSEMK9J-XJLMaMA:9
X-Proofpoint-GUID: 1D8Kmmg4FiVj7qukiptvL-3tlbewHGWq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXxqQJW9QM8w7W
 w05tViB4xBEJ9G03IHshsnhcLV+MNa1nsLjEznhoyjmM/B6ZylIDycLVIof6QlYuLa89WgindCe
 0L8hyctbftSAcysIKTie/zILgbmqZZpSKJIWst2OoU2+QTQs/4IN

From: John Garry <john.garry@linux.dev>

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down.

For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

A bio which for which failover occurs is handled in
scsi_mpath_clone_end_io(). Failover is detected for blk_path_error()
occuring, same as how dm-mpath detects this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 42 +++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index b896d28a7dd9a..a482b6ede21aa 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -248,11 +248,53 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
                mpath_synchronize(mpath_head);
 }
 
+static inline void bio_list_add_clone(struct bio_list *bl,
+				struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	if (bl->tail)
+		bl->tail->bi_next = master_bio;
+	else
+		bl->head = master_bio;
+	bl->tail = master_bio;
+	bio_put(clone);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
 
 	master_bio->bi_status = clone->bi_status;
+
+	if (clone->bi_status && blk_path_error(clone->bi_status)) {
+		struct block_device *bi_bdev = clone->bi_bdev;
+		struct request_queue *q = bi_bdev->bd_queue;
+		struct scsi_device *sdev = scsi_device_from_queue(q);
+		struct scsi_mpath_device *scsi_mpath_dev;
+		struct mpath_device *mpath_device;
+		struct mpath_head *mpath_head;
+		unsigned long flags;
+
+		if (!sdev) {
+			master_bio->bi_status = clone->bi_status;
+			goto end_bio;
+		}
+
+		scsi_mpath_dev = sdev->scsi_mpath_dev;
+		mpath_device = &scsi_mpath_dev->mpath_device;
+		mpath_head = mpath_device->mpath_head;
+
+		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+		bio_list_add_clone(&mpath_head->requeue_list, clone);
+		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+
+		mpath_schedule_requeue_work(mpath_head);
+		scsi_device_put(sdev);
+		return;
+	}
+
+end_bio:
 	bio_put(clone);
 	bio_endio(master_bio);
 }
-- 
2.43.7

