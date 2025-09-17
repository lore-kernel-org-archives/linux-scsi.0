Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A942DCBF7;
	Wed, 17 Sep 2025 22:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758147239; cv=fail; b=NR4z1v1Dta4vIGAIjbqOVhP0W+tXLKpDLxGY28wbLi8UKE6rzCWFQz6WlXPgI79ieeRe664kT71WqjBlFI8y0uuE9q3stagOsrR5dO0+mD6M/RRJ5xxGQ1k+H6++Mxc9sryVJBXKy4d3vqwgUoUdUxTcP4Gw//3pxtcS2mZTLWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758147239; c=relaxed/simple;
	bh=G1I/JZGeWUNZnjXDxAc63uFJbORvT1YR8zhIgM6cWok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t7XXp9FSnRVggePa9XWZiA6O+l41+fTpDFt8/uHctpd+a1KOa11zjJhaVnNYCFMkoHIJzgmLk/zXYt5mKGY5Dckih9zlZXCpVRt1hxq/WfJ0S3x1xFbc+Q+KNUEt28pw7t6ysGsLZnpO6OrNFhLCiTEWU00QNw/WLS9WiC+JKeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d+9ScluA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vn6VUkpf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d+9ScluA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vn6VUkpf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIStJ001843;
	Wed, 17 Sep 2025 22:13:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rjtcbutGpAsYa79xH8ZPoLmgvZjcMkn4PkeQg8iRmi0=; b=
	d+9ScluA1hYnpTJVi5efV5rbwn8rYrb48ivC5Qo8SGg036T2jj480P7bQFNpxA/M
	0560jLTeUkk9U14rk+u1FQLotFH8UbE0qwuDmzB7GmmatHPdWx3Ah4+YxtxH8bwC
	/QG/DQVxqc5qzDXM0WyVanXvnNF5eEc7c8dTpDXjcQ6BvIU3vP6iEIh+VkJXuY8P
	AeypPhvvoQNezHkaEW1quZ9+wtT4c0B+AJynj22oI2oB0TSEwD2Q4JPZoDymTNjo
	5iZhha2RQRelQrDNOInQbf9YW1YVucK6jehCsMtpgG/wU4En4c9VeRjJoMl6WnK5
	UpSXDkkiy8F14mKPkqmE7A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxd29fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 22:13:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HL6hEe028808;
	Wed, 17 Sep 2025 22:13:48 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013051.outbound.protection.outlook.com [40.107.201.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2eaq3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 22:13:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSVxSzHvAcB8/7tdfDg+W9rPZn3ZtcYmGInuTqhGso2yueFYfK/rBnc+ZAFpRinuJohwVLvyAeb3NM4Rjt0dW/XQZa1jrN1tOLyAIsrLLDOY2dC8lU0HQqNWNHHGelxSXyIOlRl3kbxKfypAwhYBc1f2jb8G6KhKyjNfEalS7qFSbK3wemokpeOW6qy14RXE48eSmYgcaU+m66n30gknCq7DlyCtDXzKW6VmcFQM9n8P3e3iThDPeb1GJSkBbCJpCtUYnOti3vTKZxzMlTzFd3ZSRu6SnVVPCe1PrFkdcLtrkiknSgEbLhKXmWASswJsPt7Z7Rl7FxFk5YoirRwhxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjtcbutGpAsYa79xH8ZPoLmgvZjcMkn4PkeQg8iRmi0=;
 b=h1lOFA6oEOZXRyL04os+o5R/uZbWl9riAyV5AVVRcFUj9sxtJvRIsDYqCqrVoxr/lexpHLRAJqhpqDN6l+jCdX38p4bb75ysRvxwlL4FzUMrGF5iaIv+URwJO2IAF9K92NHTrKw16QFa3sDCq+kGsKYh4q2j4KKXaV54x6a4GsT5KlZy6xjSfeX/ZImj+XuyGXchrVW0YrpcMgIPr6MDw6ZVMuZIU53QKZcsZ/H0s6wvDf1tLJq8t8kQ3Xd9R8NChoI6k6qbaVURxr7oV/vH0Qf9uwCmSeCO6f3OgbK2ULnoJG6kXCKPzcaRUeJoa5MGYW7xJJOgnfLYer1AEJbfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjtcbutGpAsYa79xH8ZPoLmgvZjcMkn4PkeQg8iRmi0=;
 b=Vn6VUkpfisYp1M/eomZEVs/SQaqFsZ6JeSLYQjmO2i3pFgR1CqZZoaR5iIZi9CcAgz8dQyId3S49bV3P2nSersvpPlGj86E3xsc7OgbR9+ohICrjJRrPK8CmX2ctruLDkZFOXvR/Bjppzs+gvQDZ+aVbYKJXADpN/AK3t3dJNO0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7564.namprd10.prod.outlook.com (2603:10b6:610:17d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Wed, 17 Sep
 2025 22:13:45 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 22:13:45 +0000
From: Mike Christie <michael.christie@oracle.com>
To: mlombard@redhat.com, martin.petersen@oracle.com, d.bogdanov@yadro.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 3/3] scsi: target: Move LUN stats to per CPU
Date: Wed, 17 Sep 2025 17:12:55 -0500
Message-ID: <20250917221338.14813-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250917221338.14813-1-michael.christie@oracle.com>
References: <20250917221338.14813-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:5:74::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7564:EE_
X-MS-Office365-Filtering-Correlation-Id: f7e07bc4-9417-49c8-3128-08ddf6377819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b8f2mcKWjF8CNbL5S5uZ4+32BfGQYo1WpPP85cBfztZbMCtlNstA22+SbX5S?=
 =?us-ascii?Q?4Yg9MhShTlZvBLqbzQP5RPEWyvdtFsFU6IVrrH2nGQTcDAXezXRFP+0BrwL1?=
 =?us-ascii?Q?K6mSh1gav6lG85nr0KoGOroubJi3ffj4GuN9+aGkI98pBVoeNx8/7EiyHkVv?=
 =?us-ascii?Q?+96pHJ02RcyaSmJMbHhWjWYaxOkeGXN5rgzD35ZWTVEa0htcivT0nZSg39nW?=
 =?us-ascii?Q?QwOelR4cQccMbxJpn1JUL7wUbAVls8QRPgMM9ceJPy+PPqUykXEMSge2Ly0f?=
 =?us-ascii?Q?e6cHSkHhJ1MD28bj+94EKmo/lWYAv0muuMs6K+adc8RCuKIs+/p8eMNMCEjI?=
 =?us-ascii?Q?FSMFXDJEn2O1yUfU1x4YBvOA7G5y61oeZIubJ6dV3wbd6T9Dp3JGUVKCpzW0?=
 =?us-ascii?Q?tKh9HTapa5eZ27XlL2TmokYi3nr69E7RWdiFk8NJn2mgivpBNeDXIr0H3T+w?=
 =?us-ascii?Q?Z2uL4yAV1j4jhMR2XAibAoFl44vTAqSFM5o3OhFMRtmfRgLXW/cQuJnXfK/H?=
 =?us-ascii?Q?/NMpU9OgeVOqF7HZckxvxkSD/Xr0mi8T4ePrWznXYcETgUprzgMKRC570gO/?=
 =?us-ascii?Q?xwqn17ayziuO2yPdS0ZV6q+XCKuVEMCxOzINkMnqMuaTtcbKvETW4jtk0zpY?=
 =?us-ascii?Q?dFg1uiG3LH1h54HRMKimCooULStxKI1fezlvZy02SWXFbFZKuGdkXQZJL2Uf?=
 =?us-ascii?Q?iL973+s2FkbiIDNxu38J+v/SczdBehvFd8Axi6uHjAUUNWRg3XGct/yN1M4B?=
 =?us-ascii?Q?RCZawRQ9fiaTrxEYL71IMFVfMH+7qXPs1P9eAGsyHwBT9WHNOOdupeDf/vwm?=
 =?us-ascii?Q?ngTUS+Ha5zNLRkVHVrSCQX5jYYaHSs6zDaybgrqTPejjHhvbeAHfddRtSuBc?=
 =?us-ascii?Q?ApQ3Hy2oJQlAxvq/YF2epZHs9Wt8tyOgzWTLHoUQUzqTjDx4wvPH5rSQnaeB?=
 =?us-ascii?Q?4BkUmqt/Dizlq5m0sEm7TvibrOqD6jRYTCQEtlba1DJvVKJccupnzMhH7RzT?=
 =?us-ascii?Q?9TRmym2Nig0Ec7x2XJrqAcP0F5r3jutXgJAdkjwGf7a1iD6vsAkE4GH0RLfC?=
 =?us-ascii?Q?hmBXYQnatX5PhTiHreZxDE4iILmKSTrqA3cacPwWkHciY1S4wo+O4lteGgfs?=
 =?us-ascii?Q?5qhMz548S855+BeA8RU2uUTX/Wll024rlUioI2+zhrR8oQXAhA6azX89oZYh?=
 =?us-ascii?Q?BkK84CkCX78p5eBPIBpj8f2nUvWcl2vX2Ez+pnpCV9WsHM7U+iTLqn5gBQba?=
 =?us-ascii?Q?3fw9YKyYJvNX7VXS92a2xxIT8A70Vma9hTvQ5ACaO3TyFDiXCX2EwBIQxUeD?=
 =?us-ascii?Q?rbyvMPOmKlE+ztUA9DBzfk1sOAFL8fxUP5JUZbql9tNi/gSkkMc96DuKv2y+?=
 =?us-ascii?Q?pV4BNgq6k3HEjcOpXMU/WkwOoCK2IVIqflulJY2/oKRabjphsfVzMC3w4XX5?=
 =?us-ascii?Q?9KzjsRZ6Ksc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BBaRCuRBrImPf+sK3eiBVJg/8Pth31+YwoDVoYL0DcMnaUZsOg1Ac78uRun3?=
 =?us-ascii?Q?U18lUW96H6LtFNZGia57fxw1mLtDo1Tmsx+CbrHw5A5uv8Nofh/ebP07NzYH?=
 =?us-ascii?Q?vhS8mvMtrkWOmahwp7bdZBHMYeaYGq7tAvlNJsoXTpz4aERU7+Na2nNcNuO7?=
 =?us-ascii?Q?OSg394EFR7p3ieokSZi5AyIxPVSYQgu+ih8U2gnnic0MnqmHLGufZp3eWOcs?=
 =?us-ascii?Q?0Z4wvzUxL7KQLgax/ObPyFE8O0+SkVYrb33FkRHViFNoVhJVogv+3HvrTn9E?=
 =?us-ascii?Q?UbiXhTId7UDtr3/YuSsk0/QBSNQtXxVBpUBu9fnLGb06RPZ7G15AlSPZ7pU1?=
 =?us-ascii?Q?7eKbQZb+NlDcD8RlwQJPlkPP4SlWAbPlcpi0csh7bKCD0mVL0WrJEU2xUaAn?=
 =?us-ascii?Q?2bSN5E45YjU86ASxu77/L7jMxCrBzSXM5+BOv0CIL/Y9wfVi2BoTiOyA5oLj?=
 =?us-ascii?Q?mwD3eG6e9TRsJAEHglJtzzCLU5DqeNuxnQApf159fF2D8TLDUvT+fReKnvIQ?=
 =?us-ascii?Q?wHqthcO1zhW2UzU4mpJCqfUPGBBg7lpEgQajZEGpBfs3ZVp29/Nyjp3RRFui?=
 =?us-ascii?Q?XKkaLqhb7c/dG8qWiRNTPohMB/2sMEH+CiinuH+5LOiEQcia/N8z+YDkf530?=
 =?us-ascii?Q?vPjPbvVjWoaEzVUltAB7jmz/t1X8mdLMm8HOi14fi5ImfPRvhd5GaRKQQ5gi?=
 =?us-ascii?Q?Uh8zWDhbmxWTNTRhus/8xEkwGSJTuvlcklDUWHdMxnmtjdRONkwp5xGb8eoA?=
 =?us-ascii?Q?A//baM2D8KaIqrdZOSa69PzzSVfO1AzbuCzBBekHhgY7LtPCxwajdGBUOww+?=
 =?us-ascii?Q?HkeVaV5rklnSTn8LhYbhZxY9OaDxSjNshkWgpt66lQoC9yfLmLWfFadXYFEe?=
 =?us-ascii?Q?grha+jD8qT97+0zmhAAwYe0m/tz32q5Z97l6Hm6BhhgdJlWMjk6L1Y1OHOwQ?=
 =?us-ascii?Q?F4lzR2aFIzCEhjuLjqconzRa7OUX6at/qYDi/T68EiOsAD2sreHFWnlu0hnI?=
 =?us-ascii?Q?aByqGcrUH1Lzbbkpb6255Qlf5fsqq80fu4fbiwodsmQBKQ44a0FzPPGzJbB8?=
 =?us-ascii?Q?EC/XzhILH1FnynqHgBdu3569Z9e+QgIwxDgP3C3tCBMQ/f7aQEHrzUiV+pY3?=
 =?us-ascii?Q?Zg1LDEPevALU3BZCmTTFcM8r3SOi3ch90qNMsNzs/IH98tYBla2TvCIGbpCn?=
 =?us-ascii?Q?mw5P8gHY/01qw+cFZdXA8oH1oTaeKiE7UxnNI2JXS99iB9rlYCE3HOJ7QGCQ?=
 =?us-ascii?Q?znFII3AmQ3iAilCDQQSOLARLwhfcHteE2MpAqttrgH0WrjJ19/uQPEBmdPsZ?=
 =?us-ascii?Q?0rc4PopriBobbVWrS5zL4jcGY0Hn/7rJ07r6oTIucHT/u3ojuoKHoZx50wML?=
 =?us-ascii?Q?756uV9PosT59k7VWpKkLG9fa8HZe29gV8gvqHCJPO+w+X/BaBS/1DeiIy7yA?=
 =?us-ascii?Q?2JsEyXTRPue29mp/lyVZ45NHuaPNBj5AZ0Ub5CPWVGRIFmLAkh6FWGOsGH6E?=
 =?us-ascii?Q?etumrtX5hLItK7DsbqHXvuM8/MeI7mmuxyiBV0tTu4X5Dt4yzyaUxANYW7mT?=
 =?us-ascii?Q?l35iJUYGkrRRBSaW97ZiiGl3El2J/lSK7cd5x98xnE4z7M4HvLcsImlq/FOd?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OudAhNQbdF8yjF+UtECc/lEoB6D6TrJTShJ7hUFUnMjeFRav2ytxyFVeE91FCnDvYbz8wOqbvI+L/lDpA92Dwmi3ORoGwZ+3FECtw1LxnXI8F2FGHoDsz68t3c5I/kq5SQr/yOalAqH8TrUezR4OtkZ7DmgcSeaDrjNlYnB7LfwVgUfYxIZSoKlaaNpv4ilfjDYBnNaAC/0O/z6D+WXi1BJpIl3ejozITY7+mawlUT68JJV050yqkqhQwYa+GgfnFxiZ4iiFbnEUzA3U+xYhgnRpEt8nbybt5gbiWfRknq5+rOTWitbFd57lwsetNTY9FmOdIAGsfLaQcOAfLnbn2YjLc8oDDoxiz3amJtGjZmlfW/CQolL4ENaRgYl7s0dMOqbYW1qge0qfCxNu7S8Ypg2cGyXnJUkpUsOMGpS0rCZqzTKGFEJ8Pngy0LJXZBcdAn1SCfReewpwfJQT7bybClRWqVWqJjWfnTwhkMFq0Iz/ZpBx7tXcWL08/w7ExU256fcxbPZhRY3YWg9+DVVhovZjb/N40/2RVwMT3W4irkPMz3uW+YGEq22bc0HJiOmWSZQZgAcLbONUlF1XDcL7IhwO7gVTaJIBryHP3kFPuRI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e07bc4-9417-49c8-3128-08ddf6377819
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 22:13:45.6724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBKdHWKvNLjEgogkRVSZgphI4e8vjNugrWG6NTM06HqT+pE2x0hU7U1uhaVoDXrLbJISlPN3ULTeFYEYmGv3Br+YDj4y5kvqt0QORD4P2qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170215
X-Proofpoint-GUID: y05jFxxAWTih73A0DkJx1QH0u-dhe4-I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX6F5ydYdITkn0
 Y3yYbh9Iy400UcWni/oOzXhCRxU+mUMq3Yr2KPzRaPxjDobVjZRCtfBAXm00VqA7JtzTgI8q4Wi
 E04PYkXNwAsmPzhZCpj3VYYjihSU0TkN+Dw+rXwCQzeY1m5dPdvG2qPTZtq/lopvxfGYWWoKxKa
 O0erh8hl8z0bQSgSl+1FZmJV0xyvTxCXe93ptrCsDwTRxMj+DybS/bJ6Y3Hz9OOAwOnTYpnQAAU
 PGRIOl6bhleRFsi9Ndv8CR1raoPLDr5y9wVKHhD6IIXEXOypbvdlCcEdgJRoJByXShNUVjA937o
 v2/7oKmfB+RbjGQwdagTf1icMngIfbn9EQu9v7g1I+UHwdri90wSBhWmCNui2tpuTWhWuO37LyT
 APa3w42C
X-Authority-Analysis: v=2.4 cv=cerSrmDM c=1 sm=1 tr=0 ts=68cb329e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=-c9VzbpeAAAA:8 a=OOAKvqf1tipb_53jp7oA:9
 a=WAq88MDkwfy8HpmZFCM0:22
X-Proofpoint-ORIG-GUID: y05jFxxAWTih73A0DkJx1QH0u-dhe4-I

The atomic use in the main I/O path is causing perf issues when using
higher performance backend devices and multiple queues (more than
10 when using vhost-scsi) like with this fio workload:

[global]
bs=4K
iodepth=128
direct=1
ioengine=libaio
group_reporting
time_based
runtime=120
name=standard-iops
rw=randread
numjobs=16
cpus_allowed=0-15

To fix this issue, this moves the LUN stats to per CPU.

Note: I forgot to include this patch with the delayed/ordered per CPU
tracking and per device/device entry per CPU stats. With this patch you
get the full 33% improvements when using fast backends, multiple queues
and multiple IO submiters.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_device.c          |  1 +
 drivers/target/target_core_fabric_configfs.c |  2 +-
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_stat.c            | 67 +++++++-------------
 drivers/target/target_core_tpg.c             | 23 ++++++-
 drivers/target/target_core_transport.c       | 22 +++++--
 include/target/target_core_base.h            |  8 +--
 7 files changed, 65 insertions(+), 59 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7bb711b24c0d..2d4a7c0c69ce 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -814,6 +814,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_SUBMIT;
 
+	/* Skip allocating lun_stats since we can't export them. */
 	xcopy_lun = &dev->xcopy_lun;
 	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
 	init_completion(&xcopy_lun->lun_shutdown_comp);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7156a4dc1ca7..13159928e365 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -697,7 +697,7 @@ static void target_fabric_port_release(struct config_item *item)
 	struct se_lun *lun = container_of(to_config_group(item),
 					  struct se_lun, lun_group);
 
-	kfree_rcu(lun, rcu_head);
+	call_rcu(&lun->rcu_head, target_tpg_free_lun);
 }
 
 static struct configfs_item_operations target_fabric_port_item_ops = {
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 20aab1f50565..763e6d26e187 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -125,6 +125,7 @@ void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *,
 				  struct se_lun *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u64);
+void	target_tpg_free_lun(struct rcu_head *head);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		bool, struct se_device *);
 void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index e29d43dacaf7..083205052be2 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -606,53 +606,30 @@ static ssize_t target_stat_tgt_port_port_index_show(struct config_item *item,
 	return ret;
 }
 
-static ssize_t target_stat_tgt_port_in_cmds_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun *lun = to_stat_tgt_port(item);
-	struct se_device *dev;
-	ssize_t ret = -ENODEV;
-
-	rcu_read_lock();
-	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%lu\n",
-			       atomic_long_read(&lun->lun_stats.cmd_pdus));
-	rcu_read_unlock();
-	return ret;
-}
-
-static ssize_t target_stat_tgt_port_write_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun *lun = to_stat_tgt_port(item);
-	struct se_device *dev;
-	ssize_t ret = -ENODEV;
-
-	rcu_read_lock();
-	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(atomic_long_read(&lun->lun_stats.rx_data_octets) >> 20));
-	rcu_read_unlock();
-	return ret;
+#define tgt_port_show_per_cpu_stat(prefix, field, shift)		\
+per_cpu_stat_snprintf(scsi_port_stats, prefix, field, shift);		\
+static ssize_t								\
+target_stat_##prefix##_show(struct config_item *item, char *page)	\
+{									\
+	struct se_lun *lun = to_stat_tgt_port(item);			\
+	struct se_device *dev;						\
+	int ret;							\
+									\
+	rcu_read_lock();						\
+	dev = rcu_dereference(lun->lun_se_dev);				\
+	if (!dev) {							\
+		rcu_read_unlock();					\
+		return -ENODEV;						\
+	}								\
+									\
+	ret = per_cpu_stat_##prefix##_snprintf(lun->lun_stats, page);	\
+	rcu_read_unlock();						\
+	return ret;							\
 }
 
-static ssize_t target_stat_tgt_port_read_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun *lun = to_stat_tgt_port(item);
-	struct se_device *dev;
-	ssize_t ret = -ENODEV;
-
-	rcu_read_lock();
-	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n",
-				(u32)(atomic_long_read(&lun->lun_stats.tx_data_octets) >> 20));
-	rcu_read_unlock();
-	return ret;
-}
+tgt_port_show_per_cpu_stat(tgt_port_in_cmds, cmd_pdus, 0);
+tgt_port_show_per_cpu_stat(tgt_port_write_mbytes, rx_data_octets, 20);
+tgt_port_show_per_cpu_stat(tgt_port_read_mbytes, tx_data_octets, 20);
 
 static ssize_t target_stat_tgt_port_hs_in_cmds_show(struct config_item *item,
 		char *page)
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c0e429e5ef31..8b5ad50baa43 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -548,7 +548,7 @@ int core_tpg_register(
 		ret = core_tpg_add_lun(se_tpg, se_tpg->tpg_virt_lun0,
 				true, g_lun0_dev);
 		if (ret < 0) {
-			kfree(se_tpg->tpg_virt_lun0);
+			target_tpg_free_lun(&se_tpg->tpg_virt_lun0->rcu_head);
 			return ret;
 		}
 	}
@@ -595,7 +595,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 
 	if (se_tpg->proto_id >= 0) {
 		core_tpg_remove_lun(se_tpg, se_tpg->tpg_virt_lun0);
-		kfree_rcu(se_tpg->tpg_virt_lun0, rcu_head);
+		call_rcu(&se_tpg->tpg_virt_lun0->rcu_head, target_tpg_free_lun);
 	}
 
 	target_tpg_deregister_rtpi(se_tpg);
@@ -615,6 +615,13 @@ struct se_lun *core_tpg_alloc_lun(
 		pr_err("Unable to allocate se_lun memory\n");
 		return ERR_PTR(-ENOMEM);
 	}
+
+	lun->lun_stats = alloc_percpu(struct scsi_port_stats);
+	if (!lun->lun_stats) {
+		pr_err("Unable to allocate se_lun stats memory\n");
+		goto free_lun;
+	}
+
 	lun->unpacked_lun = unpacked_lun;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
@@ -628,6 +635,18 @@ struct se_lun *core_tpg_alloc_lun(
 	lun->lun_tpg = tpg;
 
 	return lun;
+
+free_lun:
+	kfree(lun);
+	return ERR_PTR(-ENOMEM);
+}
+
+void target_tpg_free_lun(struct rcu_head *head)
+{
+	struct se_lun *lun = container_of(head, struct se_lun, rcu_head);
+
+	free_percpu(lun->lun_stats);
+	kfree(lun);
 }
 
 int core_tpg_add_lun(
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0a76bdfe5528..fca9b44288bc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1571,7 +1571,12 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
 		return ret;
 
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
+	/*
+	 * If this is the xcopy_lun then we won't have lun_stats since we
+	 * can't export them.
+	 */
+	if (cmd->se_lun->lun_stats)
+		this_cpu_inc(cmd->se_lun->lun_stats->cmd_pdus);
 	return 0;
 }
 EXPORT_SYMBOL(target_cmd_parse_cdb);
@@ -2597,8 +2602,9 @@ static void target_complete_ok_work(struct work_struct *work)
 		    !(cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL))
 			goto queue_status;
 
-		atomic_long_add(cmd->data_length,
-				&cmd->se_lun->lun_stats.tx_data_octets);
+		if (cmd->se_lun->lun_stats)
+			this_cpu_add(cmd->se_lun->lun_stats->tx_data_octets,
+				     cmd->data_length);
 		/*
 		 * Perform READ_STRIP of PI using software emulation when
 		 * backend had PI enabled, if the transport will not be
@@ -2621,14 +2627,16 @@ static void target_complete_ok_work(struct work_struct *work)
 			goto queue_full;
 		break;
 	case DMA_TO_DEVICE:
-		atomic_long_add(cmd->data_length,
-				&cmd->se_lun->lun_stats.rx_data_octets);
+		if (cmd->se_lun->lun_stats)
+			this_cpu_add(cmd->se_lun->lun_stats->rx_data_octets,
+				     cmd->data_length);
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
 		if (cmd->se_cmd_flags & SCF_BIDI) {
-			atomic_long_add(cmd->data_length,
-					&cmd->se_lun->lun_stats.tx_data_octets);
+			if (cmd->se_lun->lun_stats)
+				this_cpu_add(cmd->se_lun->lun_stats->tx_data_octets,
+					     cmd->data_length);
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret)
 				goto queue_full;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 27e1f9d5f0c6..372da2eadf54 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -744,9 +744,9 @@ struct se_port_stat_grps {
 };
 
 struct scsi_port_stats {
-	atomic_long_t	cmd_pdus;
-	atomic_long_t	tx_data_octets;
-	atomic_long_t	rx_data_octets;
+	u64			cmd_pdus;
+	u64			tx_data_octets;
+	u64			rx_data_octets;
 };
 
 struct se_lun {
@@ -773,7 +773,7 @@ struct se_lun {
 	spinlock_t		lun_tg_pt_gp_lock;
 
 	struct se_portal_group	*lun_tpg;
-	struct scsi_port_stats	lun_stats;
+	struct scsi_port_stats	__percpu *lun_stats;
 	struct config_group	lun_group;
 	struct se_port_stat_grps port_stat_grps;
 	struct completion	lun_shutdown_comp;
-- 
2.47.1

