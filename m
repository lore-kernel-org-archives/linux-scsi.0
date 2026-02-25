Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6E73D902A;
	Wed, 25 Feb 2026 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033851; cv=fail; b=F5ORxBMX8F7EEgm2X3Pwxt9Ay73ODavtwK6RXqvrgUe9fCvy51h+nkYotElmaBpPoC4yXhj5okHuBqm5zmip4NeXrVUlJ3oAxAfY3SpfCJGY4uPl5+fgLYPOT/mrVuT0jHy3hQRiDrTbV5qn9+7cWMuqlfhQRjHgGDRBLK1H8cM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033851; c=relaxed/simple;
	bh=OBMY/Wq5Rf1DirPjBrovE9lBOaMqT7VmjqZFczj9FaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=StrhIHHAxJqS8+8oXx3UMjcLX7ydttUNRNwA1+HEirzmPvzcva3kqbzGmx9vkjeXFqpytD7jUeAk3fPMzuXnDUHbOi/T5o7uKMm98dzF7/3uDjZ47GsTI2fa0x3v67ozQ4sT6917MBh56D3XOCMhf3nYejSf++55VG4vS++CTbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zj14wT4b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kdU4d5VK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zj14wT4b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kdU4d5VK"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PETBIl2703463;
	Wed, 25 Feb 2026 15:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aiylXdHjrFaGUZVxjdNg2KKPHqOVthZ9NuYmfHbPhro=; b=
	Zj14wT4bMBJP2dh049SqPhfAmS8DvuQPSZ60zBGqbmzoWTFNOaJVf97j/In7y0da
	MnKw+RDC0jL4TFaTGPZ++VTj9Lf2+qxzeR2+Vz8CVO8YyqHvBavu6bjdD0fY4Ui7
	fiVnf4kz04skinMw7t+swl0t7yMeYzMHGeREbqUi+aiY4mfC2EVUBxouZaQ9S1cq
	nvkaIlntypegydzkKja8x3qFSa3uP+sPgqLpKyDxo3K2yd5VqaKTTsMvFeRH6Vdn
	Br1vJdx8DrH/sjnhsg/teYNuJv1Iv3lbs8rJgfTVc+K4sRnAVAI6QrBFYxIWRgDF
	eVD3xiJ57A+vG8JPPAgfVQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbegh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE7QHR006382;
	Wed, 25 Feb 2026 15:37:07 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9h7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTrXJSDDM51GxQpgyOIbCs6kSCGluUBYzxwyEZ8MYm9Tqb2OMVUmx3XocfaT1GaYfwQ45PR6WJmLyNeBIaDgC7IrSvek8fFsEn92+sGuvNc86WoznOR36e1J5OfLZRGKJe5bNHwnlB0UmQLVvNHIxlM+YbCuOsgS/g7KOJjIrI+1xor4Vj13HKwLeKy3rDVo6kPkrQKLmR9bgPCuV52J5lBZeDJG4B/BwohV/kvG83WEBYyi5RSpL59uDp0FT4v/fRSweIYhgaTOahy/OLx7O5IJq697OV8YJds1oQv7SbhZetvxORXpe+nl6FJryvGl1yhnms3vO+zyjutNB1qDvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiylXdHjrFaGUZVxjdNg2KKPHqOVthZ9NuYmfHbPhro=;
 b=DJ86T0amgRA7VbGAuICBEZUD/+VnFV+Eg2s8LhqvQ9kuZlcWhP6Y1KbwT8ssDPW089k27HKzasLBfMCk4uk+1U6lyHO8i79VPxYkZDSc2fgIeffcLY9VXwHK+BOIQ6ER76DM0KHGn/wps1jhiQ6WCSlH/JodJTSLTVIEuuFnOVPo+ScEISFjQGBq8iQUJIreKSnglY0071bL+A4tKqb3d53M3zJ4/RuoPuIApz9Myl8BIdxs+6xSGUKQDzrDxIuz7SB1Zs+44T6k8CUG7oorfidYjzzq3EUGfS/rEe0RLAMS9Lai/zzmDYLG3khuaICCiMIAu35L6nvTCKhJ0rGJpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aiylXdHjrFaGUZVxjdNg2KKPHqOVthZ9NuYmfHbPhro=;
 b=kdU4d5VKSHKqKLxqRAYmOa3mRXGoz7vIqLTwvNRajE1QoAcLYqNFkfauC0wRQuWw5eHvH0hx2xW+F/mCpOnlvGYUa/Kp4Zcx9BPEzRU/GWY0W1mrei1lQ/0nK4Xku8Iqf44iuWGN0L4y4/DfNr6eAS0ym9qWMKTxiOIWgJX5P20=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4626.namprd10.prod.outlook.com
 (2603:10b6:303:9f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:53 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 05/24] scsi-multipath: provide sysfs link from to scsi_device
Date: Wed, 25 Feb 2026 15:36:08 +0000
Message-ID: <20260225153627.1032500-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0004.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: d58c3d51-c609-449b-b617-08de7483b309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	AUpWEc2JnGXkyQ1TilCFvcnxEqLb9ONOn0/4mSVqQbzY8JKjrNaNbrtkCUZyPw8HB9/eFN8/mTIzfTZPa7vO8qL7yaIQZWvc0AxGCFIM+6YD0NTJmfH+3JTvBXLvdBW77voWMITC/26uyI7susmdIphXVRcI/lfl22ZbiVD7biam1dNUT9eXiZH4a4+cNz5K6zygFDcFGhJod+HMosSaKzaJPMXx6Ad+PmnKoRzwqfJZZWgYwwQ7sMsJvAYZFQR+JSGmj+ibb4EFlIvsK46psPQKpdBOydknsgZZpEfCBI8dMhJGbshEfkKXsd/RNn/d3LlEMMJdmCRwX0qY230A5zUoiVmhCcuZwmb1aRUwtgze3HMk7hO+W/j1Ayiv8kZEgMrEmemZgudcZeAWG4SfZrrVlVTJiFO5wnh1PukVtwtTvYQlixLZRPhyhoyOaVeztk16bkQCuWaXx6NY2akpBS1Kw6qXnQjKOD93/8Pu88InCQxOojIQxjpXV5VovOoKoDOhclwiKyhK+tKGbZwb2j37lbvwtdQqC3587bh+c8GehhDKbOaHp1Q28OYY13nUk0i/POoxBju/U6VpwUnc0k2ls3sAHPbJUqqoDepVjPtIIQYc/TfnTEHy+5CDj0AXsi53+0JibZc8OIagpqRTTVxnJYaFut5fe19SURdWIcHaH1UxjLSQp3MVNQR7ZgPYE2KkSIaSrSTkWCBGor1lFlZfVqNnVvM4uiF2S6BkqT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h4NdVqaXzFKPMKShmKgdxCl5dP8krzNXcIJehBXzTP5uP7LtgViYaw4crPo8?=
 =?us-ascii?Q?VCpzIkOMGSV4n0EYzmJXI9f3uqg5Mh+v5vO1AE01qC7RowgUG6Lz3chEzgIE?=
 =?us-ascii?Q?OoqBTO1egVrzGgUbrilmwTYKMBV0yAnE1j7Ym/ro5t9Pn4APSlb5yTcnfjx+?=
 =?us-ascii?Q?Hw8ugnc6NqMJ46s2BvLiIxnnAEO0goVSlEnaY6q+TZzn2e6gzO0WTuwgoKz/?=
 =?us-ascii?Q?psAp01XmCjgyCd1YIW0l/HrUWutQGNUKigYpqzE2ENvLxJo9wKR5iQoFsvKO?=
 =?us-ascii?Q?Vl4XrWN47tLO4Q459dNniqgemwDY/WYUXxtnzxdEM94i1bLQtRkrr90j46Ou?=
 =?us-ascii?Q?eMTwRfLeUsfEKcLaxjFqLEJpV4qSXE1ecq5tPUdo5n40vyoWDMYgRDPVWAa/?=
 =?us-ascii?Q?H+MBjf7jpO1Gvhr4RNRmZv/XqOy8X3iFKHhLkdJARzdVkEs0FhlXV150Iltv?=
 =?us-ascii?Q?bEatht8Q1dvbiodGhn9mxQHh7XynyaD2ktAom4bXHhEqMfgMZNm6Jrz2+NeF?=
 =?us-ascii?Q?ZFuLPqRgcsCuZz2R8etiohJWt3PA5YQZOzTCJqeXa7WJu6hFawZwCv/KkRpm?=
 =?us-ascii?Q?1U8LABnrwEYDm/oENWmJ+V+yGXF/5kRIDbH6GFVmxusAvuS2DfT1lyoHNUrX?=
 =?us-ascii?Q?yxI+DQ4H9NdMudzQ7XPsCQbqKXjmC0lfSL6IKyhTcDUnFCyTwnBpL6wlQtxh?=
 =?us-ascii?Q?6ctUte3of3bqWuNQilK7FGLGSiJXycK/diCoQr+tJ4V9QL+G8KGcRb1ZXFnr?=
 =?us-ascii?Q?Mh8UdESGdUwsDog1s8HtpvxsBaKrAiIpq+l0pHEzBLcNtrmdpXbokAtzhpFT?=
 =?us-ascii?Q?p8d2C/YIPLmXq2WI1xajRcmKGI/Z5E0WsIQfOhLWjFFdrY6Ut+gLo8V9TjQc?=
 =?us-ascii?Q?NEbjUitakv1Twr4aSbTLuM3AAjd90zje1c7Hq+hu83mcaeH+HvMK63byVqfi?=
 =?us-ascii?Q?xrsb1VJDnQHf/qYXUet1RWcjtrjyV3fWw//SCfm5hFY9jbeWhgl0isA2oFFQ?=
 =?us-ascii?Q?OxQ28IvbPz/kxP/ZrEsOJ+8gncMgDg6aDssiTjc24Lq0DstmGR9EmmX6QxBv?=
 =?us-ascii?Q?7hrPFlzD8Lm7pXRiklD0cq+TFTCpdDipIaoOmCx8BudddsnHEqUjZc5eGxE6?=
 =?us-ascii?Q?Myiac2qscMXc93BtXZxrL2ln5xW9rjqE3PP7dTwR7mCHnu8JdBfY3gQH+xaV?=
 =?us-ascii?Q?xzJH7B572Gu0IU0D6Ik+XuXaGYBx9GDhZOjLbU10ng9gvL1z3eJR2M9DtLdX?=
 =?us-ascii?Q?UU5fN9nVgqJmWAUVVeIxKzpFBSlSXmr5jqjb2hk8B9agDSPhdFCtf+MzAPv+?=
 =?us-ascii?Q?GUVbi6vau/LIDPpd+GvQIyUkQlAjyPKCL/U+dmhupTnfjE0jqgAf8/lWknwM?=
 =?us-ascii?Q?Dh2Bge7nRokeyrLeeU9FbQ2e1Syxz5O1ZZz9/pmBvuHWYp91gr9wc98zz9nY?=
 =?us-ascii?Q?JPg746ye2rdIBigVdqkSUsKrcfjBxNHapM3LFjy9vWgyX5jIQ3sXqOrRKAX2?=
 =?us-ascii?Q?XVtLuFF+T3UsjSISgRBdTzG2rY8vKIsz8BXf3/wtlhOr3GmK7EPpw35LHGfc?=
 =?us-ascii?Q?Jcd6+zSNGzIba0onp79OrPWkV+XW9XZeodQ8oz2VToD5oKjizzCWClwhyTvA?=
 =?us-ascii?Q?+qRbQYvSszJKWBFiTWAwgc7F66SeNz6WR/ixBQZ7WwdKgE5TwNJhjIUx1wR/?=
 =?us-ascii?Q?1HOUAwobIsUlYb7AHB87P0BOrqq96pWUXk8Hh4rZ3tqdbLAdylWUJB7Q4l0m?=
 =?us-ascii?Q?/dnXXi4wktfFfEMiWFfmTZmd9cKgTo0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RtD3z30Ykh9fqfOVqGRY5QCWYELjc1wuS4lWByeqKAWaORIkOvaWUG9yUyho9HxN+Cv+tIG4uFVTZd9DSvKrZC2QMB1hMeyza6XapF2JmnMTJ2AG2ObNf7rdbrWqqRhmgHhnPRGRQleLDtvzyHuBlw61nOFb+3GTm+vycE02Gq1UIe5DFMz17vgCUtSUq9upg9IrgSr3yru4OdgqZoJ6JCiev8Lfs9n+n1z5jXhFUcRHBmZtlSRliAMgr+zU78sOYOvFF1yVQN8M6Acalt+PTikFcbd8my9whhgP6KnNEBQ8CtXhx1lrxM3NrBTy+/KXj4+jI9E/6dOksX9gVB7fv2bIgG5LrxUDJriPgxk9YgI7KxJRqiyQT3jB+1wZj/fzp0SltViVWrXrIaUugmYKKY08BFaL5YFDG19T+oKqBtIbbStifm11qowpLu5ek+2sadr47mIWrXx0eghbbGdQhLud0azjKW2kK7mLh8xeqepGmrWKaZccfxShLl63T8UQIlpTzJShkP8/vIS2vqHJu+003F6zqMyuVtUpPwokkN2xy51NV723UWdFvJ+fGhCZGHZ7ejJNW0pqARhkC2o1f9/tUFOLItVt423dzE+rCwo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d58c3d51-c609-449b-b617-08de7483b309
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:52.8430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Une1MNco3EvCCmz/6YIkcUIbokvyvddD9iiE36g5qhLZxExGLHpsFuR8EE3MM8y8dqfTwoQkvbxTNCTQC8Fkrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4626
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXyyn+3KVos1RP
 Ur2VbmWGqB3fh4jxbvbv8nAJ4xuEjSErmsl5rMswO+glNo5sv4WJbCimLOw1BRwz7w2qjcem1sw
 4rOsf8Xp4kEsaYyiDiTBr2Lv4mrl6zunTimmjZOfjCFL+TJVfJJddmcu2ySbLJGctmK7tMh6DGH
 o16zUKUKqSUBSXFO8zgdsQhEOco9eMMprn5cjFfUFsT/83Qr/MbrNfGkk+8E7J4B6fSEOPylro+
 yw+pEo/2fUb2wyBQNHoZqKv+ACk4SEn+92LOZeFtl08WvsMlteibmsV7LPPvj2Tqw+S0UBpVhmj
 h/Dg8UaelNgNsCpHRARfj+VkPm/4Cn9uezIWyX97PImAW9dkvadS+IInp0dGxf1bj0/WYInkF6i
 D+J6Nr6tNYH6TX9wf/QgYqOn068FLcxabLIyYOOjWigAp1S9SsKA+VHEJRLphr50fmDlhBVn6S7
 HK5PuwKHU4zl3FoO8Rw==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f1724 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=ZbQ-JUxe3OK3M8wTWUQA:9
X-Proofpoint-ORIG-GUID: PGIivQJw1NP4lzoizJWPZRq5EMF0WNdu
X-Proofpoint-GUID: PGIivQJw1NP4lzoizJWPZRq5EMF0WNdu

Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.

An example is as follows:
# ls -l /sys/class/scsi_mpath_device/0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 45 +++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c     |  5 ++++
 include/scsi/scsi_multipath.h |  9 +++++++
 3 files changed, 59 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 05af178921cb4..ac55f9f39a5b2 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -125,6 +125,15 @@ static const struct attribute_group scsi_mpath_device_attrs_group = {
 	.attrs = scsi_mpath_device_attrs,
 };
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *scsi_mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
 static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
 {
 	return true;
@@ -137,11 +146,47 @@ static bool scsi_multipath_sysfs_attr_visible(struct kobject *kobj,
 }
 DEFINE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
 
+static const struct attribute_group scsi_mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= scsi_mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs),
+};
+
 const struct attribute_group *scsi_mpath_device_groups[] = {
 	&scsi_mpath_device_attrs_group,
+	&scsi_mpath_attr_group,
 	NULL
 };
 
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+	int error;
+
+	error = sysfs_add_link_to_group(&source->kobj, "multipath",
+			&target->kobj, dev_name(target));
+	if (error) {
+		sdev_printk(KERN_INFO, sdev, "Failed to create mpath sysfs link, errno=%d\n",
+				    error);
+	}
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_add_sysfs_link);
+
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+
+	sysfs_remove_link_from_group(&source->kobj, "multipath",
+		dev_name(target));
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_remove_sysfs_link);
+
 static const struct class scsi_mpath_device_class = {
 	.name = "scsi_mpath_device",
 	.dev_groups = scsi_mpath_device_groups,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 287a683e89ae5..3b03ee00c8df3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1389,6 +1389,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_add_sysfs_link(sdev);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
@@ -1441,6 +1444,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_remove_sysfs_link(sdev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 38953b05a44dc..d8102df329d6b 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -46,6 +46,8 @@ void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *);
 void scsi_mpath_put_head(struct scsi_mpath_head *);
 #else /* CONFIG_SCSI_MULTIPATH */
@@ -80,5 +82,12 @@ static inline int scsi_mpath_get_head(struct scsi_mpath_head *)
 static inline void scsi_mpath_put_head(struct scsi_mpath_head *)
 {
 }
+
+static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+}
+static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.5

