Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF412242D89;
	Wed, 10 Sep 2025 02:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757472072; cv=fail; b=iTehoo2ZanteJ9Ei653/xUFL6rDYENLESgHSD9M5jl/AseCyw3uunlL58wp2HgslxWPzIe+luMEeMnWh/oomPKU2NiPg7M3scY24V7vIQn4zdl23dyhQeaEVb4bW66kAJE1ObRhvtk+3mLP0Yq/cP8dCNvodoE7ZdGo/AyGsqFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757472072; c=relaxed/simple;
	bh=F63duNFjl+ylHLunRX4iz5txix10Xn4StiIyddeM8nE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OrQTdSb7JTGKqD4LlWKjLb3OVw3O1cnVtpuu+4DBYGMJYhZC4pFlKmuu/NJIE6EJJqnykzwrkdM6VCVOdcnqHLhVhH8k3P/oUEuXxH5QgcDwTDqVw+9hmm0QlppZQdmDb2xh65gxwbHUyeKdbTZ43yndxubZBCpeto01axqJM5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WH1JH2Bu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uDRq8kH7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WH1JH2Bu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uDRq8kH7"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0fDo016847;
	Wed, 10 Sep 2025 02:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=x9HChAV2ly9GdNylOv
	rV9TLTMLlXKuMr8wYjilC7YcU=; b=WH1JH2Bu+4eCK0QNvwXqONz0qg2luEoGIZ
	p/T92QvU+aURzFLsjRkdVH1fMuat7glAo+GaafiDdo9umRhkhO+oO6MZfIkKAkNM
	mZXGC9L3smFsz2PLK5OvTYeDR19aU+YAiN+AsdNuy8qgP9dgMPE1OYBAXBcMUKPX
	s0x1pwrXtcWFDq3ymusy145zxpS2vLGrWeltdu84JxBgLaYJJ1fJOmW0eZ1BBhlf
	+srKOgMqQkZWnCf+PH80bY3iY2sja1qvL5H5haAHFjPm/ueNo2oTHuMjErl8CfxV
	v/ZfU4nXa2FKNjxf7i6shs/CCrsfklOzlwZ8ls/D91uZjne0vpOg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922x934na-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:41:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A1a8Zp003088;
	Wed, 10 Sep 2025 02:41:00 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdgxags-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:41:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zMhyYAOfD4yPP7qMztQjD/Doc+ik9JPpyCtcD4D818hEOvQvQ3MjrqVd9smlm7/kA5lKATXnc72Oe0Y3os9TJsMxoBL9PTmfMnRysrPU3Sg5FT4RCI2m3CDRchRnrHWSHK7BLjN+gRkTe+4QQdc7XpJhtcbD5mJDzLMUTVXY9fLHn2kq9KIUtJFwzdkAdnm22Anm8nmpIyiMhLRYO+mVbnFjTI2BrQPHOnhd0bqVgMmeJseOSSgHswiYQzywKC98XGSkah/LzbdtJv3ZOUf0KN3bYB3d+qab1Vbq/cTySamRjm0ni53d7VVM2tgN3bFrd2JRUjpqoJBNtNTAVsuR2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9HChAV2ly9GdNylOvrV9TLTMLlXKuMr8wYjilC7YcU=;
 b=v9erwasEShsBwBZbSeJhIZqy58klNzYmvr5/6UzF47uym3bIZdHMHaOzbT1nT+JNDi9qy0H3MJAVuZszNAAVu7qTPW15Nd7CA5kfE77xP6TVSpRHn04y6FEoNPmkukMaHfyu6TRvrImea6n7wRQ0S6ponZSGt2XkETrKchlsiTpEGA9I0MqHBjJox8KQjvr3o3TmPizR6eWZ7gNDvXFl9gd1EFCrKuswUVPglla1AftivBczaa7Hh5M8JGf41H9G5O+SZQCVDfTo1e/cgt/Y85Han0pipKLZJlEw8NMeLMwLb26KHL6yrCYWqDkxVAgql60MOFiIUCSDICu9Hdyuuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9HChAV2ly9GdNylOvrV9TLTMLlXKuMr8wYjilC7YcU=;
 b=uDRq8kH7u4RVcRGN9V+wo8ExOnejQSm9x27VuMe6TXHgBrckupcU+8MFXD3uxCrMTWoo7EGuG4gKbOStEH04ku873nkznwlunQSnpnhEWTd4NJV/7R0kXtFuzQ4g0GLNIA6U1S3phpKmVRXw5/c8p3b3eFcVx8Jb1SAN4z2jaPM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6864.namprd10.prod.outlook.com (2603:10b6:8:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 02:40:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 02:40:58 +0000
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry
 <john.g.garry@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3][next] scsi: pm80xx: Avoid
 -Wflex-array-member-not-at-end warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aL8jeSJ8uKih9DNJ@kspp> (Gustavo A. R. Silva's message of "Mon, 8
	Sep 2025 20:42:01 +0200")
Organization: Oracle Corporation
Message-ID: <yq1bjnj58t7.fsf@ca-mkp.ca.oracle.com>
References: <aL8jeSJ8uKih9DNJ@kspp>
Date: Tue, 09 Sep 2025 22:40:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0154.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: b847edfd-bb58-4d54-8f85-08ddf0137925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vj+SEWQKFbpfYZjmp3275B7EyBIeMWzm16mnQSaFDwYZLidI9Jv1er9jPE8Q?=
 =?us-ascii?Q?KpNdVvjoS2tS8WsjGVTdBlLXWd6HCK8ezoIYfmQGcfhuO/zX6EKgxTUUR999?=
 =?us-ascii?Q?RHK3x4qQjfl6xKnkDapBzPKOl5dmkA2oHPnU7XxhJ4aBW2p1eWF23amvRcQI?=
 =?us-ascii?Q?GZnbTJG0559aFRq5CikLNBwpf38+gcjs2rJw7bs0AqHqhj3m0Y/bw1+MUAow?=
 =?us-ascii?Q?H0lua6DHUBltFZQg5XzTko5gh3SwbftlMXtoYZwy3FzQap+FJ5UfYPubeIiB?=
 =?us-ascii?Q?4UuAx2RHtX1XreWu+n+za1ToQ0cIFex03Q6bjhqRvq2fPgtr3KHFVWzqceXQ?=
 =?us-ascii?Q?z5PQ5JdXvt+B2ZeEzH60i9lQd6qad6HOUASAbmwbwKYA/H3vYHz0VyAxn/lP?=
 =?us-ascii?Q?mPh5npz4Xu/zl8ypwEAQSpjqK/ISMzGVI8GDXcLUW4AQmz5Qy5JUc4Uh3EF7?=
 =?us-ascii?Q?ro6vD3yz03eThSU/xyYFn58NDwMaL67T34djzARrmGgSJRQtF49QPfAskYHg?=
 =?us-ascii?Q?hWPP0s9kpbQGQG05HOwLkwk8AgWhKVCUiamL8YBWbuzrEdHONehEops6XlzF?=
 =?us-ascii?Q?H+JfofdzObDoS9ytyaLnRp6zdsoC8jSuIC3uHMTE2+oSsyQRj0K2k+6rYiUy?=
 =?us-ascii?Q?7XQW5qsHdMNfe+M7zx3C1147yktj0T9FJT4YjLBRN7rPKmkBWE/xdJQcAF6l?=
 =?us-ascii?Q?NrY431zmWvxNA4pAdatxnqz6tq1mFiky8scWIlfktL9Z47ajaU8olCpAL4aY?=
 =?us-ascii?Q?MBVvbPppDjE4oBnfN2WDrhxvz45+a0t0/ksrASNXSrzfA9wbznK2hl/sc07/?=
 =?us-ascii?Q?6YfIl6jR7gR3F2bfAPHMVcwJH1PVPytgr2eEZY+nLSEy8X/XQaUKIlieihVN?=
 =?us-ascii?Q?GYNH2Del8u/3pyVCv7Ieog2sEy285kTWPFGyY3B85e6nzS1vLEf6zovMt7JH?=
 =?us-ascii?Q?NUVvLb1sEq6HHibDjmt8ZjNaryXa6MiX/aiVMtw6PMaLkRyaW+vgbBst2UFt?=
 =?us-ascii?Q?YK+4JwsgLWAGaFQKss6wWPJ4l3Tw7zrQfoca5NM3mvpxyxzgzmbUHP1DSK8c?=
 =?us-ascii?Q?pKC1q++lum08XpU8CgU0qFyxGgPyaCGSD19L9FgsoYO7iya6ZmD5MxZI1gZK?=
 =?us-ascii?Q?SeJREXDf7EcqTqky8YFJSfAz6VWsIAcuqNVGSjItuQ1RjH5UHX9wPpwLn9cN?=
 =?us-ascii?Q?fNdzAFmrZa29qmrmD3fncrwAaR1nQegSFllIQ02Xnr5sdUZ73dUN114m99xQ?=
 =?us-ascii?Q?zzqRnoBjJBIqTIEkk3EK0NvFwV/jBSpwSXUJVCLDW+TxN74ngtJil0YuHops?=
 =?us-ascii?Q?gKI/HoVvVTYzFEU8HmH/xh5cvwi5Hzef3MiDV1DIhY18nh+lFJ+W3UkwyUf7?=
 =?us-ascii?Q?/V166VQOakYNk3BA9/UZ1QxInObpvgiRTaZxb30nR9b+5PG0B/u4ODSSibt3?=
 =?us-ascii?Q?eTtV0Y+xtkE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oB3cwXOwPZ5pQ1LKAr7PucPGK1LuKXnyrkL9QFp0Sq4eDsoLjRDBrznOrU1v?=
 =?us-ascii?Q?vBw8AleHiEzIM4C2Yk1NoGTeE1GKCVMbKgKz2e2IvTxPrDa4byRUDy2C0+m1?=
 =?us-ascii?Q?JBhM/vNeCCyLp2WYPgpSEmAnWKyriTzaFbFgFHYgziBuUz+KCTysJPBQaTxt?=
 =?us-ascii?Q?mPeUitaBXsrRo3HXkSs/9HqWR/2v4J0dOJ0vC9qxvWeUd68Sbo4tCuaP20rT?=
 =?us-ascii?Q?YwS2PfFtUaXyebvbG7kOhXYzU53ZASic3NMQX/FhxSh1h+QGPUQhn9fzA66+?=
 =?us-ascii?Q?MKn9e5Z6BrxfXeS2vcm+6swKwskyzupxuGOFIoIFKI1AmLtiRjnx8xgLnVjZ?=
 =?us-ascii?Q?gTZDiQdLosj4q01xdgdC0F+gKBA19VMAfA+DNIlTaIeklp3V9UTtAovCX+Yd?=
 =?us-ascii?Q?wTIEvuCH69gHQ09IbHcod0JUdivv74hp6SFUdKQ0YJJmk6B56vgmY+YwVGPx?=
 =?us-ascii?Q?nrE6DxNzhMmDtqiiGm2MWNkbL9oh0az1Z1QqH6rvmgIEqtrq1JmrfBMQADZm?=
 =?us-ascii?Q?sB4zz5QvGn+UDAGg6iJQopZoT2KGUiASN0MFiqRUxLx+wJnzfCf0kOfdNrnG?=
 =?us-ascii?Q?4rutpvhJlT+Avt83qsYJqT8+ymjyLL3xPNjodmCmqB14aFvjS0mDxzJFSNPU?=
 =?us-ascii?Q?xa0VR70+SonEaGM5DhqerGbIo/9AWpT166Be97Ps/rXGdcdJg/CuV+3+7pSW?=
 =?us-ascii?Q?xsWnJn3ugLTpft1A1K49L2cY5ZzRu8m8/OHf4kVR5J7XOYPyQNTuLusgtAP4?=
 =?us-ascii?Q?Dw9ctgRs7jtMe6Dd5dQfNtHyvNSJwvhLuFPLsVns/MXAzmY18nfiMC73mcal?=
 =?us-ascii?Q?RFy/6NsT7CyhfAlLYrMvatlB/XbpwiL7cpuh4myiPyUiULaFmcIW+XSRwPi7?=
 =?us-ascii?Q?drlDyI/CI+GdZfZhuyqqGZgOy6hbbLzwAtjDW5zNDYZy0v6xO7L/JodZVqb3?=
 =?us-ascii?Q?wMPVTCSDts18T+sO0671m1AxOBRl6/o6QRRdzm+4suz4QWz76NJWXsoMsxX1?=
 =?us-ascii?Q?Xryvu6q7XT83dHYfkdmgdbKDvUpvc6VnfddLT9FgQNWzNxgJc1+6vhjfKAby?=
 =?us-ascii?Q?zeZytDLbOk0oBoEudBKFeDp4jRcKCTfj+Xh9+dSSf4JAVADkDzpjelK8g/6d?=
 =?us-ascii?Q?ZBw/yvEA312Wb0bvDGbUL5svylqEKcjY2WjLDtUL29uML6XFK2iNcrIu8ApI?=
 =?us-ascii?Q?W/jyR0pQtHF4ehajFI0jT4895VONnEVGscz3QHqnp1fREYFAt+1joUuHRcTy?=
 =?us-ascii?Q?1hr5BOwnV0RAgdBkYgIqdogOgyWoZlBI0idkQY1rJQJOS/LiSK7Vn3VCS33b?=
 =?us-ascii?Q?A2O5dag5IKoCgIfY5jnEOFMRuAlTJC8UYxvDtQCg8hAtJ02+mw9lYgs94j5d?=
 =?us-ascii?Q?31BxiQb0uvQ+6/Ce/9Z/UY+EmMyqFYk1gW+de3N3BnJA9ZDTWjeh8y6M2YAM?=
 =?us-ascii?Q?d7kwn7pVkXmnglFw3sahAax4F+FfDtlMsXFFPg8X17e4bdNy6DzCqD8Z8G2k?=
 =?us-ascii?Q?9vLEAguIRu5NkP3/uwbxUXppZKknBTDErusU1gpgokgailcG63H9cj7uTdXy?=
 =?us-ascii?Q?Bq6EzQcScqUqOCAHC40vWWwX2cSx6m/oawjdieu1RQohcUFC8DeCRmsKEPib?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vo71Ma6G5KIubLnMzNR18u/8wIGqt2CZ9WL3OU3+zY3sYVblGBt1AjtvX9xw8BSHhsEmgQvVI7P8IZKTaD9cewOvcBaW3WaO7neZMGrc1osCMXjR8kyWHE5wRZWfaTrR+8pO2kvIAkE6itNlJp+MrKTLr/RtGz8nQ0QAkZnHSzzJ7l+2XgM02ijqRzlUtBgOxBkLsws35hBETfEf5Rh659FVx+oI0Ng7GacJ+WwNyXIH2iUqiKG9h/ZHYt7yFVnqJkHpAQdkhsTxmq/d8cv4X4vA9AlHhrLJROe419pDdfWW8do5w2+oWQ4U1qelp9JS+zzUQFGQL5lXz211FVTInOiP/h10BrZKQWfB2N/GgMutqSyth+sCWrqp3gV2MAKgfWuGwBWrNCLo9SxOzkO6GRrG02A6uQ29iBpxCs+EAvcGG4z847/8qy77dnpeVdkEBOVNbtTthdkbm+11EpZYviHFm/WTxHuxaZI1YMmO7OxkVfkqyu7esXXxXQvYfJ9yqcQtjhMceorNqnn2SGXqyL7+YholdVxQOU+uSHIfUnMBnKYjFcNHPaQx7URf4hh2OCRlKF9iV3CYL656aQF372yxbumGrMCFgeq9YP1GnV8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b847edfd-bb58-4d54-8f85-08ddf0137925
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:40:58.5249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aINXumb55QjnHeL++j0UGDlkVdDG5u5EDCqeNQHLxS2YbJWHbH/TK2U1aMFmazeYAeEU+ker0Y6D6FKi6pPP89Sfi+snqPNtf1U05ZUS0qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=490 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NiBTYWx0ZWRfX8IK/9vrJghRl
 Jxi7/j5kNcAhBp0MztxosvBNEiMYzGUJuLqq03v/jg3FYZ4Uve/sN/U8T2eINVwhVTZ0czf/Y6P
 k4is7z7Cp0rCYG51ixgj04xgDbVR6lyrFVWTZcN9yOK3b3UQp7xjIfnZ08LnqOakUR0a0fPwmUq
 aC9k0f9J8/8bczT2u4KMi4rqLCCAUKCZjgxxM3LqnpbgyVk9HKcD2ffJsALlorqEkQSC6zwHrHV
 wymvu3lUfCxdVMHRj/v0ZPCNgztoHaW4canWA6l7Qn3ooDCF1Rbtsb4CsajDyuHWUoCjaAOZHwb
 fhrjQ1i/cqD1HV0qYgKCm9o6ejLfh7myfM95HxJqs856cvaZTv32yf0nXLEON8YsVgZytbDFhSQ
 pgAHMhM8tPT2p0odwmLY98vrw7xbRg==
X-Proofpoint-GUID: I-qaWThlx-TgNmGgf7MQh9C1XoRit97p
X-Proofpoint-ORIG-GUID: I-qaWThlx-TgNmGgf7MQh9C1XoRit97p
X-Authority-Analysis: v=2.4 cv=LYY86ifi c=1 sm=1 tr=0 ts=68c0e53e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=iBSi31ee6mCwtw8ZJvUA:9 cc=ntf awl=host:12084


Gustavo,

> Comment out unused field `residual_count` in a couple of structures,
> and with this, fix the following -Wflex-array-member-not-at-end
> warnings:
>
> drivers/scsi/pm8001/pm8001_hwi.h:342:33: warning: structure containing
> a flexible array member is not at the end of another structure
> [-Wflex-array-member-not-at-end]
> drivers/scsi/pm8001/pm80xx_hwi.h:561:32: warning: structure containing
> a flexible array member is not at the end of another structure
> [-Wflex-array-member-not-at-end]

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
