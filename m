Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC75E42E013;
	Thu, 23 Jul 2026 09:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799565; cv=fail; b=Nr9kSK61OZsCRIUiUMviDh9OUfoZAnyi9INwEW8U+ntURZpjW1/wQxmq8vBvSrXJtoc+4Xn4hCLtXJyeIx2nMvM6VcRptlDKe7aCVkp1uGCUtVW1TjEmwj/e6549DhCTy035HVSdP0GbOuedqzA9WW38Bq67q3SiHJYxqtpEMrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799565; c=relaxed/simple;
	bh=Cf7UdpcpqIYtbWgfwDdAS31e8unZV2kUU9JMkx+eNks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DbJJba7WE8KR5sFRuDGHpB6kJuNLotB6dyGGGTx9QVCw74FJobEA4vc2+3LDjpYrjM9WWTMi8XaRso31QpdQ0ud/uEJRK8cYqR1nx8WQM5m+zOvMbTflAFnRad/OuqT9yECFinklmL6bZuJncYtjLFsHfCLuEEbqIqWNE+DldeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZzozwYka; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yoSuzxC2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZzozwYka";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yoSuzxC2"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtcT63353523;
	Thu, 23 Jul 2026 09:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GMFJ9nUKtlf7PxsquqkRrAjf8uZlrSvOEsQXbqspjHw=; b=
	ZzozwYkateouDMQlGfm4nmG/i3ft2smRhJfzsSaqVWmaOLtvU9T7FtuYXcH6I1AP
	TT4ZMtMLQHCnwcbJfbKOxrM1urOr3ocJHAZ9XyHbUbbzJLp2UEX+IVSHzn8Y73MQ
	lln2PqBu9OKTRGh+8sJVu0aN43d8c9jV+HK6LMH+7UVwEuhjjwe2vascEzSikdP6
	BHNfaCO/ftO7KKHRbvOG5t8XTtJBAGitaUCyNjdW02/HKkT76VwdvGdsLZzOPE9L
	QJLGTZLz+2tWxUTq/lvGIuoKLaIRX9QyuGREVgOYgcoFtajUddICX8fTtB7a94gy
	m3W2fpISLusIxGJy5IpMcg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6kpa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9NXha008288;
	Thu, 23 Jul 2026 09:37:32 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010059.outbound.protection.outlook.com [52.101.56.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxrwn35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NBcawuISP89xFbPTKPIJghMB4jqYcIr9Y0vFRBZdXYfCjF/BgCWlD/eJvnTM/3at0I8w+B88+71QpQFsHoY39J7AexLLWJ1P4+zTvNJfUVyH72V9KLexyWtVQYp4yAhJzAXU60qhUQv7H+uljELlyiq0tUwcaIoJQnHqVb5JSTw1FHzLc/pnXaLQQTKtM5bGbmeYPs9x8NwLQWK6CxgDPiJb6uNZiql5myo9uqxUYLbzV0v6PjRnjJ5SbYEHZIYU25Cxhsan+0wR8xBfQ402yfumEGa/+W86O4TFvhSRcLrZKGaI59+z0i+r+WLtaVh64uUcgNRMrKrPbQpLsr0O0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GMFJ9nUKtlf7PxsquqkRrAjf8uZlrSvOEsQXbqspjHw=;
 b=XDndhlx7iv2DemqDRB2svqJjIJ9bsQpoLn5GCP8bpN4N0xfhKrrgliknB5PAOLC7Od9cTDfczbYUx+yZbePWgCqz2HIcYBcXD5WUrVo2r5nLrsjujL1Aw6fFlkuDTv7kkPSkTlZEhmo2VpPsJG+8G27Ak3SRrMp2vF3z4qONhlYJKIgq3rDWdUUSBfPpRyV88gxlXWuZ8rjlx0MHO7aK82gj4BbfAlueuPBV4oSPMOI6tfHvy8aJ2TCJ/+ewcJnPlEvG2V/F25fE7yZTY9wYh/MongsAd7d8RgUSzU4Qfr4XaPYfVN3l2NHxtexxV8mTVJXn94Pfwto0JzpyOf9Tjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMFJ9nUKtlf7PxsquqkRrAjf8uZlrSvOEsQXbqspjHw=;
 b=yoSuzxC2riMm7y9cKSIlDm3mjvTUbsvcq0NdszA8f25JWmpLc3TUYYVSp0l4D7jAskVz8jBPhPiusvEgfnXVHqD2aqTEZno6m9SEBFcG7JO/9xP3qJ0ad7BHQA2qm5OIls0yTCbu8UyS/dJmOS+Wo11m5nbqqjwPT2WVbXhsB3Y=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5672.namprd10.prod.outlook.com (2603:10b6:a03:3ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:37:29 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 27/28] scsi: sd: add mpath_numa_nodes dev attribute
Date: Thu, 23 Jul 2026 09:36:25 +0000
Message-ID: <20260723093627.2327456-28-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:610:b1::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: af1b59d9-7383-46d2-f9bc-08dee89e0331
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	X7ydbsovrEGQSfXo7jdjFGrGgwVkmSHSztJv8DJgJxpoeq9KDjgxp1AkFsMOn5d3SFACTfzUycKF7eWNtvUMEBGimIyTM906VBscN+KdMZmyLWnmQBJ8rJST4jZ9HV5QTfokvLRXLe5ILCeH/+dfNV1FMd536TjW4+UxiojcD03dcidgA18DiYy0U8/rgp1NhjsLgBL/vdxT26Q3fmHJNDe79Oj8KUk+kEJ/Zl7n2W86aLQbmg4gbtQBq5DLbrQ7STsOHAPLOmQ/SCm5UGFLGN0wS2we5AgtJXRNiMe4kNlC+GAh8dFt+t1eSPyemkacFujsQ/4vJ+PrDJPAjrVKkRr+rVhDQoL/f1ockn1a6Y1gWZxFjcXwOx5KhgAD+qdowguSTDadV6qvkQNXjsZPPy3u23NJu5GFG5JMdc0Mkz6auojJNdwhiAec3uJMdJ5PoFs+LEyCyT5O5Sucu//oVfj16ThjzhnrqCDkyHoOlF8h8HZLn4XncJNGGmXTFeMkqJrwJvHgCHhC566K1Yp+lv0ZiCxbi5Tbv3Z4RMbQrkrqCkPENlscXfUTREHBQZeUqKWPJHKnJKlYGlVG+Qt12Jtdn5HULBKF9a4i1mbFTqu4xUF45rh04cn5JaHQMaigOxXg76golqFdSyUF7psb9u7HZTrAJpEb+HnlSVZ3dTs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0BYtNXmWBDRx9DgYp8EBvIqF3ZMJZlBQDstB6qR8s8IiC2dfwPDWVNMYfJ/6?=
 =?us-ascii?Q?7QUjMPIqfq3Z1O9YTkUrdwYHO00eghVKBJCOYp+1ymQ9KxHalmo5K0vCwSCN?=
 =?us-ascii?Q?s7u8DmXq08gs52QeR+Sfc/DAXUPTuQSOc/4j93wgLXKVPZKJ0IS5lppjI29x?=
 =?us-ascii?Q?mIMjc2nBBW0A0dmmU1e/3N13Qo0D3IVmhlER2GGpkrklXmasWZ0/x/X99cH4?=
 =?us-ascii?Q?FQUS/gPpWWxqU2oba35IlIf+LT5do8lh4WmhaHYO80f8SJrw2fBkT4Jav3UK?=
 =?us-ascii?Q?CsQcRD439ox+5mG7bEEjJG/nFQjWgzu7KhFdpu/cNi9YNYEh1p7Rsd42k0FI?=
 =?us-ascii?Q?c843Ib/7AWBgVZTdMZNOaP+8gnwvtPeSMSvciPzbnF7TNMaprR97Qi55cCFO?=
 =?us-ascii?Q?5aAiB0kTmPZ2JtEWg3CDJIk87WgLtavDleOrql12x1nqDWwCWJ8VyundN843?=
 =?us-ascii?Q?Dwlnf5XKyXI7Y2jEIuSUL24/0Y3l3XoOmZCSWyezN09RXKJ0oe2LHQYYLc17?=
 =?us-ascii?Q?WK4QLjimHmXPWuvkVSEeUzL2HHTj/4uHFCjjLLE+l02J/1rkd81e5Ai+LYph?=
 =?us-ascii?Q?EGhsZ5RTJz0LqthosKvITI+NZlkrBh+pu2LeE0vAaQ+Oc1Pu2rK0YltIOJMp?=
 =?us-ascii?Q?/q5l4sZqp83kqsGweJPSxYaNq/CX9Sj2NyzNFOuppy87y8TLinVDoIyqxTEd?=
 =?us-ascii?Q?hgYZj59bJqIp7ogi6O1EXUxAOghF4/x9rKqrujIz/teEzUVi8NAlSUOOQ22t?=
 =?us-ascii?Q?qkfTaU8PN51sPQIEYsls1UNKcyexhv0pxG92jqK2CQOh8FA04epQ9E/uVdeA?=
 =?us-ascii?Q?v1eArfzrRTFY0a+yWJP51rZTvqw5xlbD9pIyddz+N3SfsUBjO7H8O093nRlo?=
 =?us-ascii?Q?zTKKEM3Sd1e0AJK0xb8wyMLZE3inXW9QXldwzv+ZyiE8UUiTMyzi1vHM2Eyo?=
 =?us-ascii?Q?2N101K+eJ5qF+lsHaNJlQiWxZj/Xq6m9qWF3i4bGvRteCxSuPjTzKqGv5lv/?=
 =?us-ascii?Q?+6xSqbahSZSIUETZXpUJV+pw0d/kbVy3Nz0kQU/fj6zbA75yTDbYj6ZyqZtX?=
 =?us-ascii?Q?/GKLawtmPC5bEvfuMWPq3/aaeJSk1jR8M/yjEPS8Wl4CmzVMuTVxJ2JUxlTe?=
 =?us-ascii?Q?dzFyZRRmtbepPqJj8zaiRkRIGp66YyFmYnjoL9lkli1LRV/hfRnZyE7rPNiB?=
 =?us-ascii?Q?kYh2ohDZPzS5J0WOOdGfPdWYIcqet6BhBgNQHaACnV1+NTf/OY/WdmeMjVls?=
 =?us-ascii?Q?XfJsMArkDewhBlhqKDKJtuUrMDsd3w89YECmG2gs40m59CVjSVC3YRrYWRHD?=
 =?us-ascii?Q?+HAOrI/rtxjT/o8IB1GBxH9bw9MHT9tzoQU3SAT8jQ9Tr/8GhnqKFrGEsL7Z?=
 =?us-ascii?Q?mQ5x0Mo//ljy/GcWzYqa3uOesy2PunelGBNg3ZlA7FMZToKVPxD1e0DRzVos?=
 =?us-ascii?Q?eFBwV/78YZ8sLoCv1hmhGNeK9esQIfnBK9ePErG8IL/n7gM1B4ZDT3WU9hqu?=
 =?us-ascii?Q?oEJLThF6JRbO8Yp9rDNlvzUTX5ZlHyEgPU3YtoVcY4zmyY9QndmMAiq8ZYsz?=
 =?us-ascii?Q?UOJfj/sHmmVtqa73j6hyIakSaBr0B+9LSu4AsVSMRMb5S12zGEl6r0EBhMKx?=
 =?us-ascii?Q?Hw+s0oAPVLwW/97XapBuZ2JHjLF5ZENIprdwJGDFCR+KvkZjXeyj5+iMrZRm?=
 =?us-ascii?Q?A5V7jabL9Hi22B1WMHWTAJx+eWc9aDIis3z0mrKUxBVVT7OT3o0iy/iNwutL?=
 =?us-ascii?Q?V04L11cUY1kBj7kvfKv4UvvuA6iTtIU=3D?=
X-Exchange-RoutingPolicyChecked:
	fhO/LftrOOL9ZQy3zYYleBPnpCGcxuxvwTAKgbxIdgLY1UCDE2EsXLOGfgkkwBPd1OQQrAupbW+wazBNbwYRiBRjWOX7Nd63LgQFVOzvw5t/fiF1RCQK5gUfH+TYDLFGduVxL+8ZM9yPpffHMuZ0Lat5t3gqOC19K70UUCre5jL/toFLuvbbZSL590B5QpCesR3vzkd6I14RFxZMSfl4+Dz3xlYHMmCaTtudnRAnLQvgEYrA/v2l+oLTc+OTfGovyTSs8yJgxW5GkPt7e7z1+emd19QBTr3Vzb+G/2TmeCP4EfkdzEnmppn0bfdKHdtXccR/Gxs9jfnT8kMHCkjDYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RP+87Hhm4RfONbM75Z5feYJQNE32jdGLJH/oZ8OScB+7AjJXk3EyQrZUZhTFQchVyr/kM4u+L9+pLR1XwUSSojOGil1jocdIxqIcd+ahb12puKbSoYfRCqnAhAxxfSJfG7CRiXUUNYWbQWdWIjNw3bLWHNC7jcE77riBUDxsxW6CxaPvT2qVEqIEjQUZ4VCPmSq5HcxyUJY/i8qpwuUT1Kp0DrmTmaTO76SvYqHtRlOExOzvxnBn21xgCuF30UZHcPnUk7GtvvjkbKYH71fdF+yGcI7+7OW+kq48DsBZncqyHB8CqXJRSh6luI7qmSwTGtLklwNOayVBQS/Mu8zsh2fCjH+GVQDnv1cIAYze8CnF7xaUx/6Kz+5BlAJqmwZufuQfW+W92szXUZKYzXaY1rkSXf82UVc3zx5xGYTcZahBkNDwdei+uwqaCZcO7qa8Sy51MbsLhKvpfQlqRrfuqcJbXPt9saHZeiZYM9YZSDA4GRpVbDHkV7xuMYfKd1p9BQYS+kq55oUOymTMc9qZMdHTOP0dtLFroIMowTZxwyauECcdAOe+QP9Uy4zJcIojJ8OfBR2I9DnVPN/H5+Gp6IRlzjZAG+ZO6q1jnNgG+v8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af1b59d9-7383-46d2-f9bc-08dee89e0331
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:29.0385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxUpQvR/At7Rm+PZ6/gZI8rlyV8bU0YUypG8d6QvODDjL6lG1f89N5ZAgPN9N+y0qEr2UjzXUPWQmrq6aX8nvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230093
X-Proofpoint-GUID: sLs59brjWIme5oWtqSS5yZMzlx1uK6ys
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXzoTrnMNbaA10
 6fh48OyRSjjZsudzJStKpzH+RMjZyA/if8xWvbRL1ZwrNkzkFvm00Jum5n6lZhtgMov+AnAp2id
 hTVyY1+qDmnHOliLm2uLDt1eiiMkzaz/3hGslxOZLE688/cjCUcF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX5HBu0i0ovEQ4
 Ve3ABwipOgFDjAUKhAZt6sfTvD0ZxwigkejurPb40IbyoGbHQDpZdPk5qSVB3mQedzcGPv5eGz8
 6PTyoxNvHSCc+TIeFA57DDhUKaEXkZLZ0Bl+P1xv+u16AvtCRwowipwYgoohHEGIWtN9R/R2vcA
 v+74QKh2PXSXfSF4vfdFmvGxp/GFQEek0sw+/RjE7rSno8p/d4cOCpfnT3XB//GZePvTWMHgGJm
 NAQxAVHxQ4Boi/o8wmHYpQ2pSD3PY2VNwJH3jAN2wqta0Ei+nlT793SlaRnqlfbcvR2H0M2twsf
 TuFs8ylmFT9MEI0qdJqAKYPXLsGoD1y9Qt+JiN3YVkHOLFDTBgvket8ufBpJXlSIaw1BeOaAcpa
 bCcuS68OmbmJPHlgteK7ygcB9/YeuUzjGnTPQnF4tMARdEhM0j51vpl8Ow+ryqvCgkX/dBjPu7n
 tlgUiBzKQ89mmEi7iZFHVCUXirdH8uQ76teJVhqc=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a61e0dd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=P2_R26dytZ8aPJic-48A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: sLs59brjWIme5oWtqSS5yZMzlx1uK6ys

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f8c9096e6c43c..7255df6e3e971 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4076,8 +4076,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
 
+static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+
+	return mpath_numa_nodes_show(mpath_device, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.7

