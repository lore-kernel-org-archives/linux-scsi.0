Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B433D7D9C;
	Wed, 25 Feb 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033610; cv=fail; b=b7rPjKA9tAxpP+Ugnz1Ev4Smbteryxu2p9qJuhH9qwsvopLQPM4rmmWucCY4+rp+Dk+B4TUB+heAArjBNNO1KS/vCn+t9BKq9Guv5kRT4pOGLC6YuRCNThnfAnTT2Mr0jDAKfTQe3Ovd08u8D3IM+AhmqrwPZK6ZNswxlHQNApQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033610; c=relaxed/simple;
	bh=ogtp/WUxO7rFfC7hRGYuCKHf1gf+dj2nRFaksFJHF04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h/XFcgsG2rfbxl3C3Ug/02OptVp5GbF0yhdHvbwaDQ7lquLs1EHXZQW1qgSXsL6VcwJdJlSXnapZ80N6Hwk3a5nzk5m/BfZvZnuZWe9HZqOVf4tNR119pwD0bf0sIhEHAAFLhBI57MvF7iBIvjmXCSVnPlzj33tqkwCWXkCFTbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hoiBqEpo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UkrZKiwP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hoiBqEpo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UkrZKiwP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P4BV5W1461731;
	Wed, 25 Feb 2026 15:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nFJoHQdPCAG1Hc8ekTRp3tZSlnd/8ZtVD4icbc4N8Ro=; b=
	hoiBqEpowi/z47mZvZvfAI/zJdLPrZblQJC0T0wNBLozyuDY2f+YMllS6UoPzCZ9
	kYuve2eQZyP/WkML4fN5HFqwFk1CLqvsAyxv7GFXKHljMvxVpdEtHGqAMrv0jhB4
	8UdHiSR9KbnLFXS2QsPmCyPhiPy3L056wSt/Ghce7sLSc19DUyipO/ubdOhdHp6S
	25PY2zL3UAKZZbmlV2GKca1xULsFwP/tP9kRKISF8VvaQ0VA3ZKEtGP3chVftjMa
	OrurC81gP33KJkoZgKa+1A+o5WBbYq6BmmuKR3iAY0USSQt2apKLh/4RfFmC8vVj
	5mDBFNkzu6FjZeiwXy4kYQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3pg2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEXUdk013310;
	Wed, 25 Feb 2026 15:33:00 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ffugs-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFY/PAvBOtpiXky5z6fq7owqDeGqi3OAubXXECSpB0hQIBgptmUfwyyrmyqvNJznMCVXXU+8FNaJk2gU5uN0i9YQ+UIUPRDsSulV+aiE6w2RFoDw+0R1GyoU0DMz4W+viqCTPahgAvXxIAaaCd9X6wH7MLZ0lakM5as2mqNxEy3DMCpbloJ/vECTkWPNDtwApUlxmDb+wimCPEmn1ORMx1O6TiR6F8XIMA5729HDB80pWYHnHAi9IFAahWFvPPhKt6I+cY9UUBF6eOnUH/O1KuPWygZ1oOgIvfSZBhL/+W2xWbB94opp/zvYE9BXsyXdjYInbRW6TF0Kh7bTN3wz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFJoHQdPCAG1Hc8ekTRp3tZSlnd/8ZtVD4icbc4N8Ro=;
 b=VT8AnAjuUMRBL+3OweTLDuDLZEDgEt24+EbRPAamAy9WmHYbux1P9Rj5eHj+NWw4AlS7JFm8Li7ppsMiIq4KIyC1JmgPesbHCWy62rNEY0kDQ+s5zYuwdzMknKFyVGZs6PF38ctOK90t11hX04HuQgOIX8ZeU1NLGDeqS+Y1TsoowD1zncqwzog7VLJiZ9Fo5nXAMYIhPv9524qJDCmj2S2m0TjbFyeFsZPPD4+pY0E/1shvLpepUdzxhaRnm0G5ezhlxEGSrfyl8t7LJ8wJArKjoClV1llegBkKJz3JAouMErejbYIw7bU4KDKs7G5uurTjoyGmKCViTnlvhDmBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFJoHQdPCAG1Hc8ekTRp3tZSlnd/8ZtVD4icbc4N8Ro=;
 b=UkrZKiwPYNFCV6aU0dXUFMV/f3hkX/qfs0CFns/07BVX+TswedH9EMtbpZnDuIX3s0e+BaTXYgIinfUoEvWxaAFcMSsTvf15q5piqeR4Se6LhZorZU2bFjaE5745viwZ1ZmGjmx7OCeIpiP/uXWsb6oA1L5n3I2Wmt14tugweLQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:32:56 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:32:56 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 01/13] libmultipath: Add initial framework
Date: Wed, 25 Feb 2026 15:32:13 +0000
Message-ID: <20260225153225.1031169-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:610:11a::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: c0350773-d93e-4ca6-95bc-08de748324cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	rFKPGP4eUTKrZNTu9Hw172cyINXnP3EpVPFWy+EiUZEPXU5CUTI75NNQS5hnoJGSoKTsKGzBVuxUgUti/SpxVf1S8CxCMhyXhdHhOXMUCEQEnrbannrwjXtARprLW/KMKBk+zd0s67EJBZzllPEefGvawGr61HP8xTdULZd4VrMDJYf7TviXkFu2zLH38CT2/ftwZpAaHP1bGokt18qc8GRiyjuINGDBvuZgTsakh6jlo4wunWF6qXxMbNupzWh7PvZ8bYr9Ht6Qxr/n0SQbf1pWaHK02jdCygGftQvSiHrBKi48KFcClJzIbnJfoxMicze4sJPhWgOTyNto6ceRKzXT5Z6anF2Fb+0G+2j9IszD7AQCnfflaMGfsSUSmo7Zo8PIshKmnLiITnm/wRxYNG3sSoQifeyXunfqvgO4m8157ybUlHzY2nz6TgkCYLoOQYtMcI8mVbnxayO87Ki254dr6+CK9jBtgLu9YvivqTr3YNXFHB72jAgur5mEY6ZCY7sSwX81sO7VbbxT+LbuCWkXuTBFb8C2Kmy0tvXbQyeLCd4oZyKPd92fu+fltYyYjegPAG9O/MIxifoMRsHGYcWRo0zAP1pLaa4AEqJI7qO97HBeJjgbukPur9fBZ2FJXjwE5Tdwn7zIwLGwpscEOl09+yoEpKzuuza0vQZDSCAeS4mZTt6syu1SqyexLJL745B4QHkXFUL+Lp1K8zkaJL/w1ueEs62QjN4rEYRnOX8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3YVCQg/Wp5Dd/wY1if4Cgi0c7DW+y9BY5hLoyVd1aRXgJ8leEi524nFiZBlI?=
 =?us-ascii?Q?W+yuFHFlJpq/fovluC3ahQBaGou7b0LAz0fSAOQm2nX2/uqyKq79ew/sc6oF?=
 =?us-ascii?Q?LyonmIFvJvW8H1WMf5FAn6Gc+k8dynt7BvVVdG/N37NwyV3dgovLnxYgmzsI?=
 =?us-ascii?Q?Ep0bhqVpHoc02CvFnyxzvpnt6UYNfz+4UvkY90HmtUD28i29t1Er2GlShDQR?=
 =?us-ascii?Q?sGqC/u1VaAbYA/1lG3xGr/vGjt2eJhx5Ltf+ljjpWVf8EwpUaGym4oXZQFfh?=
 =?us-ascii?Q?8Q4aODL4c/mzvLMD/tLEoeEJNs3XVxA9HFjp+eS2CDs9dehnT+S1ladr4B+p?=
 =?us-ascii?Q?kGjla6Ih7HIfR/RZkPVAqV/ZkjgEtvdZw8d6R3Ubk70Y+ANmwnz56L5oQWsm?=
 =?us-ascii?Q?UWdN4bT5L06rlYJIgIAh2QG7xjCQiDDqYP4UGVlVlY9vamwBbhRy/drCje9V?=
 =?us-ascii?Q?d7qdd3db1fNC7NXoORsHMt4UERYYMQSQWg5S4+0RbXeco8D8ck00YlLgkBw0?=
 =?us-ascii?Q?9aO/IN/a+memA+buPCzuAeXFaZjjWySDTzduyTDHMbSGggXalPn43Ohf8PKI?=
 =?us-ascii?Q?yBuLMiY5D+pySh/bK9BUikB/384P8ocWT2/mjN2v/6sSgbrsxzUVIqPhxQe+?=
 =?us-ascii?Q?tV/BqwO3yxq9yMsZDQJQf+SkSI/2NhAA0odp5shWpNL413jHkjA4Usqc2ipl?=
 =?us-ascii?Q?qHgcs0va67QyaOHkgVe0yvmvXp4wkU7mGjGh/0GDyKIlgT69MpFgnjbx6UfF?=
 =?us-ascii?Q?LtPXIoID3IRLqyKZOxupSE3j2Qi3jifjvf6cQXRt7GpiDLQnpvbEJjtoIhtr?=
 =?us-ascii?Q?+oSDS2pQcez997nFgtBzXXesdXEoJSzE8lovhfAzkTdUwm7pdIdMapqdphHK?=
 =?us-ascii?Q?nAqAPICa171TD9CnzB+SRCaCPx7zf8GuEixML99iy5o+qhKVawGCPhABDriW?=
 =?us-ascii?Q?nWDKNnAPDy/QEwCzBwLJp+vlhXgEvDtctJP97r+4Ask8k7RINpIPcfTqDrCq?=
 =?us-ascii?Q?fqaWqG/VnIxS/lB3QGtJHqfW7Bef9rG3AbiRBGccdSF8GVN+lY3ymWvXAP1I?=
 =?us-ascii?Q?6BXIrZl74JtkMNO+QrV6Q5RKS4HySQIqz5AFbsahmT60F4iRljTTyLlsez8F?=
 =?us-ascii?Q?fQOMfcRzct5/4DFm0NJfksQdRsaFbyD5F8fAq2szERHRD5s1MWLgW8gogEv1?=
 =?us-ascii?Q?3VFEiNepDgs06QdRwec+mSwAfOgNl+NeXddf7NaPKxG2UYQ51/hGisdEg/Tb?=
 =?us-ascii?Q?FoZMJDCfcCnK1pedaiHbbUpCVMbKnILg0yHE8i4cKeBVd62J6ER296xFJUTn?=
 =?us-ascii?Q?66pObN8GiAjDz8ixwKurcmxaah1a9r5MN7HxiYmbN8jDj6cqJ2SWu1A9edh3?=
 =?us-ascii?Q?lkYzzwROnXnW0f5UY3g7PmeOB+FwOid1v+9DOhpFxXqHDsCAhlMc1BxlMx7d?=
 =?us-ascii?Q?+ZHa8QlNLFXlVqccViUic1NWVAi98os6Wr5ptCSnLljitryZ/GUurAfGYr45?=
 =?us-ascii?Q?xzU57QHY/09o3RH9D11VebumcW7OuuocK7PcQ624n3etRycxdhocMkNRa5a7?=
 =?us-ascii?Q?myB8Mx07cbMYj+VUj7Zq1MX1qU6FfM9lXuloFRKH9ASWb/9ystmC09sQeEQD?=
 =?us-ascii?Q?43XlVVvGOFjqyrND6+Msg/a1oqi6pWETmk2pGmJr7EPhKazEOUDHcjsMh/zb?=
 =?us-ascii?Q?yHi8h+Z41urZDYSND91oRcwvTWLeg7fIEghEK2G25CmiuvpnVOI+gnfKvC1K?=
 =?us-ascii?Q?9RauvZlSBpJyNE62u/izvOBbEDzIges=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3uxVgHsTPshgBkYtfGkcwz3wsP6JEXCttAOEISFNXnFGoykpjgoyV/i/ugXAlPR3f+ChAZi7P0zj38sJhg2AmzlZdfSCVkYhMNYDk6BDXuf04p1JOzZeajqWmjZuG1lcz4Xo6ZrvBVCMLUuQbuwzz82VDk+XVVnIwU99bqyaq9DFD1Zo57G/orLgApZl2cTQr1l9vMyHgExKTAoks4Wi2ExxQHaQvV2Gs23Xk/D2srPNatNXEPp/Tsoi5c4vh1fYMpM4XO/BKHw9SiwEcnY4P7i9kCEcgw2BaN649hjsOd8ZZIuotnW+aankxibc3nueNKEbPneyQ7aVV1kNJ+SRIoXzS9Vm4i+WkL1sqRon0rS2ke5BJYVailpQ41JGsJatYT0d6ikWkjNjI8p4CbuQOPamNgetxExl6/1g/4BMOik1CP6n0NMAmdSoWep7/hkZC4mtyQuODniwh9biJYDvrcADXDRTEvMsI7OZiAOnYAwG7HhJVG7461qcV8kP7Si2spzcWastqBCN3LAqtZl81S6uNMVcZOsu6OGhuUh+HsEmyCw/q9EvIgY9cETJvfAqsgvya/RFTXHY0VwsO9aBlHo6hbVcOAESrFDs+07nfqs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0350773-d93e-4ca6-95bc-08de748324cb
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:32:54.1751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iTbYEilQ7eE85wrVr/uNoXSw1IxMyPAbIgEqcDOAJe3yjSeWUlOMNGJoRjb4LmstTj7617cmilIuC/0peOnRDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250148
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699f162c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=XP0GnSSCGFUgwQirCqwA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: 94XrwQ_uYmB1XXr7IMvzfCZM0Peqw6XU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX9ITm6zknlKGH
 h1CR34HmH2sVri2rw90XF6ZNuH35xaaogCvfXFqsB44BvDwpXikuMl1NSO8YtjE36KmRvGCL8rG
 OCfrz5pceH8/3Zie7yU7KKZ1IjCjAuQMUz8CBR2BGxzKZcUZzSsIki/zDn7/vQ/EnYjjike3902
 qw08zUYjrTfQ7SkDHjeAxMr7myncc6rAuqPzM54kaziVecaj0z5k4x9fk+FXCEgY9HoU7ysGOOp
 M4DR1BzTBXdgE0xEdkkqAZvVp8Xl7Q3zGcsp8eFv5LoW2sUF4NXSZkfyyy8nG+pVvqQxXCpBVjb
 p1eY5JRM6+Zi87Fi0ev/rUZ8J/O7cJdaYQj2momE9RblO5Qd5CGxshqOzsETLLjhoxWn+FQEilR
 QxJ1qnPoJJOkMZJNmgaYAp10yKF39hAfgpLJ8WPrhHFC9YBUfiFzDKb1Vpqte+uhVPTnb6TJXhp
 mFB+gKpKTXCe5Yj20ZKwtjlXytGvrHq9PoTQT49c=
X-Proofpoint-GUID: 94XrwQ_uYmB1XXr7IMvzfCZM0Peqw6XU

Add initial framework for libmultipath. libmultipath is a library for
multipath-capable block drivers, such as NVMe. The main function is to
support path management, path selection, and failover handling.

Basic support to add and remove the head structure - mpath_head - is
included.

This main purpose of this structure is to manage available paths and path
selection. It is quite similar to the multipath functionality in
nvme_ns_head. However a separate structure will introduced after to manage
the multipath gendisk.

Each path is represented by the mpath_device structure. It should hold a
pointer to the per-path gendisk and also a list element for all siblings
of paths. For NVMe, there would be a mpath_device per nvme_ns.

All the libmultipath code is more or less taken from
drivers/nvme/host/multipath.c, which was originally authored by Christoph
Hellwig <hch@lst.de>.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 28 +++++++++++++++
 lib/Kconfig               |  6 ++++
 lib/Makefile              |  2 ++
 lib/multipath.c           | 74 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
new file mode 100644
index 0000000000000..18cd133b7ca21
--- /dev/null
+++ b/include/linux/multipath.h
@@ -0,0 +1,28 @@
+
+#ifndef _LIBMULTIPATH_H
+#define _LIBMULTIPATH_H
+
+#include <linux/blkdev.h>
+#include <linux/srcu.h>
+
+struct mpath_device {
+	struct list_head	siblings;
+	struct gendisk		*disk;
+};
+
+struct mpath_head {
+	struct srcu_struct	srcu;
+	struct list_head	dev_list;	/* list of all mpath_devs */
+	struct mutex		lock;
+
+	struct kref		ref;
+
+	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
+	void			*drvdata;
+};
+
+int mpath_get_head(struct mpath_head *mpath_head);
+void mpath_put_head(struct mpath_head *mpath_head);
+struct mpath_head *mpath_alloc_head(void);
+
+#endif // _LIBMULTIPATH_H
diff --git a/lib/Kconfig b/lib/Kconfig
index 2923924bea78c..465aed2477d90 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -649,3 +649,9 @@ config UNION_FIND
 
 config MIN_HEAP
 	bool
+
+config LIBMULTIPATH
+	bool "MULTIPATH BLOCK DRIVER LIBRARY"
+	depends on BLOCK
+	help
+	  If you say yes here then you get a multipath lib for block drivers
diff --git a/lib/Makefile b/lib/Makefile
index aaf677cf4527e..b81002bc64d2e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -332,3 +332,5 @@ obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 obj-$(CONFIG_FIRMWARE_TABLE) += fw_table.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+
+obj-$(CONFIG_LIBMULTIPATH)	+= multipath.o
diff --git a/lib/multipath.c b/lib/multipath.c
new file mode 100644
index 0000000000000..15c495675d729
--- /dev/null
+++ b/lib/multipath.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2017-2018 Christoph Hellwig.
+ * Copyright (c) 2026 Oracle and/or its affiliates.
+ */
+#include <linux/module.h>
+#include <linux/multipath.h>
+
+static struct workqueue_struct *mpath_wq;
+
+static void mpath_free_head(struct kref *ref)
+{
+	struct mpath_head *mpath_head =
+		container_of(ref, struct mpath_head, ref);
+
+	cleanup_srcu_struct(&mpath_head->srcu);
+	kfree(mpath_head);
+}
+
+int mpath_get_head(struct mpath_head *mpath_head)
+{
+	if (!kref_get_unless_zero(&mpath_head->ref)) {
+		return -ENXIO;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_get_head);
+
+void mpath_put_head(struct mpath_head *mpath_head)
+{
+	kref_put(&mpath_head->ref, mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(mpath_put_head);
+
+struct mpath_head *mpath_alloc_head(void)
+{
+	struct mpath_head *mpath_head;
+	int ret;
+
+	mpath_head = kzalloc(sizeof(*mpath_head), GFP_KERNEL);
+	if (!mpath_head)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&mpath_head->dev_list);
+	mutex_init(&mpath_head->lock);
+	kref_init(&mpath_head->ref);
+
+	ret = init_srcu_struct(&mpath_head->srcu);
+	if (ret) {
+		kfree(mpath_head);
+		return ERR_PTR(ret);
+	}
+
+	return mpath_head;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head);
+
+static int __init mpath_init(void)
+{
+	mpath_wq = alloc_workqueue("mpath-wq",
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
+	if (!mpath_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+static void __exit mpath_exit(void)
+{
+	destroy_workqueue(mpath_wq);
+}
+
+module_init(mpath_init);
+module_exit(mpath_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("libmultipath");
-- 
2.43.5

