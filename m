Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F47E47277C;
	Mon,  7 Sep 2026 10:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778416; cv=fail; b=NBbzv5uw4pUOosbQ1D12uDF2zprViv7ic1bznh2eEMMwW/N2Rh7igrD63zzRT+tWEtok//LmSyIghubLNleYi2yiruE+1ZcpNB6Vo+JH6F2NtmKF+WcRDuXpREigesVKxICLa/FVWVMeNfV+gqf8YtrbbhGzEI4od7p9NxqV7Xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778416; c=relaxed/simple;
	bh=9p3/knx9KduMdJ1DsS5W4EPtsZA8FmJ5liztQaYpdQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I3kxI2HKm3UP8Gs52nO4Jas7EfAepkghLCVICK2uQ1NQepBClBBKvEoMjjpBCApLLHLLogp0WVZmS3mhpGVupxrvR9H8AVZBRaqZKImxm17A/2grZIvegj+l0VVZUPh6etwPK/KZw+zOXJXkXB9l7HEidASh8u0+c3kYKuAzN5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jL9W2uug; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fIQAp70h; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jL9W2uug";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fIQAp70h"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68701eoZ219204;
	Mon, 7 Sep 2026 10:52:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3QZbNYPCqDrY4OLQJMMeFe6hTcT3gnho49/4570fD/M=; b=
	jL9W2uug+SeWQc7GLN1Pcza/Z7ly2ezip23kZrTgu9S78zPwpY6d8RsgnK+chZKy
	N34FuLS1E7RBsCj2ime4TvMk4OX0tK8zv/cWawNgFA2yAl9VWNLJCVkLVp4UT588
	cR9qgOODxhU8TaqeSWKX6jc/6/P6WektDxipTWElD+KcYgZylRgj/tFiz2aURSr2
	kNHAW9MZartD8/VAZ+TZbPgurE+v07kab2pSecJPyleQkdBdehd5nuW3dGKtnSpf
	rWHgFPeWsVEOSCAAtz3wpVVNEBDzRWNjvesyRIH7qxefwgsgEAtO2WOXMfdS4Ar6
	SFbdz65a5px2CfUhykz0zQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbgvssgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:52:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687ApfQj029304;
	Mon, 7 Sep 2026 10:52:04 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh7aw8bdt-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:52:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGa8MClV+twpPAPkv3LOZfElnK2vjABvkIpsqZ08lXyv7ktU2fT5XJ7czvR/cdjQpwoPWBDyQxKy7fkgHvZRKrHCXj8lDxTkxlfUaBPSejLqNvBglMjoPZEEHqXcA8SxSr+ChibtKT4lX7SCrqqbfOa4kgW1vMTomIapycwfqrNCEu3201Wk4kEi+M9uAFOjOhNlif3YBiRXJ1HCfLUmVdJR42C7hOui6nP0IByHzMz+mL0/azJKZnJQddqzo4POHRRTgGu1+01gGWKoTxc91ey8C3zPOb+OTjN70kwTSzD4TjnaKpojJiEJKaiKA1Otu1djuXg7BFtEKXLUGFGFdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QZbNYPCqDrY4OLQJMMeFe6hTcT3gnho49/4570fD/M=;
 b=mBELHM0gBXjOE0Hdc0DI6rkIK56Wc9tGDuHcjdXxs2qaR3h7igskZ8qwcJ3g4AsRkS81QVHQW/n4tiMjb0m3QarZJrhxHh63rmsaWLI7AguHuIv86NUY+qbL9pPgfebyXs8mqqv+2DOiO/HF/H+gG/sbsw4n699fjOf5DZhwojXtqildp8tSRqfXqAnA76gnT7Wsi6/xQdpxC7ws8EEFHf1qnDZpLY17X+zpvLikxpgkXZ5OzuvBym6WR1IKMZW8p7q4vyTrI8VzKUXFaPPfv87fi45NHMm7Va7H8ONskmZXpTggKev4zF8d01GIqzW3jH6Yf2mP6SQYMWOswCp6fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QZbNYPCqDrY4OLQJMMeFe6hTcT3gnho49/4570fD/M=;
 b=fIQAp70h68Cftw2Ku3WMT+N4opHgSaUZt8R6CJSeP9YHAU+WNj6dSIfJDHOECmKXSZjb7IxpUPXLiI+DGM0ccmXq8ZSG07BfCT4ErHyg5EVR3ptu0C7ZF+eubuUAwMKc1CTt68RfRGGiRl6Sb6wzpV6REpyzJInjvie50WZ5Ops=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6276.namprd10.prod.outlook.com (2603:10b6:510:210::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:28 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 27/27] scsi: sd: add mpath_queue_depth dev attribute
Date: Mon,  7 Sep 2026 10:50:21 +0000
Message-ID: <20260907105021.1763236-28-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0033.namprd14.prod.outlook.com
 (2603:10b6:610:56::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: 593c1f2d-298f-4e4b-cb1b-08df0ccdf848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	/UCvutaUQFUYIu58ZfGyO3gMqNj0Bec7G/jzS+Yqfm0txpS56OJednqUFsowR7XxfQMOCAyOySm28I2L8UTv93Zk95896d5PUZkkFwVZBZGjcYlQ2KRHj69ta9K+5vxInIPRrhUYlgaHGaoJ35zNQGGziTB5AVt62wHOSckkJiVJTzR3Xj2Wt3DwPYlhm5Y28NUfCn8ORO2PvmWs+TERopRT46jhvnE6cdcq6ky7DgX9f5eKyDocdzzi53t6dJBrYHmoiZkkANpyfygPbrGzYhp8pFkzEkIq0FcZrQrIA2sQCjhpGuw3sJ9faP1ItIF4S+1AT1arPW8ex5oIFiw9FeRnn2win6OPXY4Z/7uCpTvEy5X1R1d+O0aSOLM/LHc6Vyo52Awxxdh3VOdBmL/wG6Bk1r66Flgs9g26sctP602KQb6/jcI7ToohofL5O5z4SpdyvUVjzB6ibnHWKYy54f3+hlRG2jc08DqVWgsAAWZo1lWGsXsAEfxKlCfegVmaxCYWQ1+KvRUDqgWQ6gebyJ7UlcLAJbBmOwIZoWGhHDsnpk4o+NqK3/UqXbRhlKVe1/7HAL3W4Hjal6NAj+5B7td23P0ZjUFSfLX6K8FMHfnZpK0P9lU9/xeIqdHN7eI1fdEptBAf4f2OkiTiQOWiytvxVlQnzkJsNu1eONgPItg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iK74lEJGzurhV2R8imA+mS0Adh4qqw+/tuiGfXRvTx0aaqWHzyqYQDAQRUw/?=
 =?us-ascii?Q?0Fku+p4L1I+IIQLD79vM917LlrBakBF+YgdYzIHai/+XgZwlU30OqG2EMPbP?=
 =?us-ascii?Q?0MrODh0V3XWNvdf3raUW+W8qy8dQcd3E8DAvjlwQfM+e4o25rgzkbc7OCKNR?=
 =?us-ascii?Q?Anbx++HZ9ukUc5oAIazYKCmyhAqO6FMKDMtIgWL9K0QNlnuJfuIPEws6qcC/?=
 =?us-ascii?Q?BLxH3cMJmw5tmGPU/MM6Zn1vKBwrGtmvJfJcsJ/GWl5eetf1krrxaIFZ3vCW?=
 =?us-ascii?Q?N3jWzDj/vpwXCVwGOA3UnYUE0TbPB302coUWpFFBS14JhIlHKiuOdw4FK9j+?=
 =?us-ascii?Q?I0Lbl3y0nLEUtRWMphweRD/MABLlrgs/GxleY5IXg/9k5Hrk4U4L4Bje3q9W?=
 =?us-ascii?Q?uqku106b5NmNgRXTpHhfrz79AjcW6oSVONJYAmCV+XEInZa8g04DzVdST+Ri?=
 =?us-ascii?Q?gO4cTBcgJJA09Hzz7X1viNvSdNqEw1FgTLNHu17HEpqifXAUz/rqYEL2O0ZA?=
 =?us-ascii?Q?5hGs8auegUt2eXDQ1kQgReKjv13kxeyGpfE/B69MIhlIgTzXQECwMfnzVdyi?=
 =?us-ascii?Q?0niTQtrQuOsZM11lrc93Yp9IC/W88uLo2Bj8ws6GcAFUDLZtJUZvVLARfcNn?=
 =?us-ascii?Q?k4w/lZXduCnq74/L3hNqbNJ/OYNYX3AE5gbvqhZtL4wuCO/7Lc42qVmgS8w4?=
 =?us-ascii?Q?j0ZBsRuC5GeuPYm4DSTYyn5xtI1ANF343zBHXLeBEqssD/Y2NAabhc2uvizt?=
 =?us-ascii?Q?VMjtuJmKGA825YQF1mWDN2HIi8PjI9iIvrKNJT+2RVYqqQl5NSjrDJcgjyJv?=
 =?us-ascii?Q?HV0JeRze6VzlATdqssU15by7XQcb28lsl/+c5/rwqBCqP49xY6zfaoXRcGjf?=
 =?us-ascii?Q?vLqbdvkAJ7AFpsDjV+OUioh0clGtA3dSgd8MTXnuVuH/imFvoZrXK2LtrxeU?=
 =?us-ascii?Q?Je6++juDwBSx0+0qz8ClEqZfQhkT45/7zmdBam0seCmuuZmfXm7JCN5pw2Ij?=
 =?us-ascii?Q?Va3RXWesR0UDfR3gPw+fLvMP2ZbvtQRI8jyaSZb4pc1uEeZE+UQQY+efwR36?=
 =?us-ascii?Q?kifZ0xaCu+aVsHTslVXU4IuUDKV/1K1KvSTxPzsYeW+kuYg5F8nuoGTM2jim?=
 =?us-ascii?Q?opPVG3dUqdx1jBee0LaZH2JMKHACWWBfFrKKohS50J4hP48NztIWz61QXWEi?=
 =?us-ascii?Q?OdMwt3clBDPRbMrWpPHXOtXAOHfvjkEBem0jb4u4+FkPdbzm2jPh/XuEXcTz?=
 =?us-ascii?Q?Qe/C43Xgj7NnVDnWSBzvpnfk4iTFahMTonRc8CzD2uXW4J29zTdMgkuvmJlg?=
 =?us-ascii?Q?nadIsZWw709p0iMp36wVLr+UONcP3kBvts5hvXiF9GtKlkM8j2w4zJt45wUq?=
 =?us-ascii?Q?fUzehyJdtNYxetZzxHdXshMqTvo/h6siARwkZm+VGD/4U1tdooFKOXZZJDzo?=
 =?us-ascii?Q?ptlt9g4gRnYo8jJKV73xx+sQAxcQ5wuR3U8/jqOt8+ybqKU8T3Ng7iTUZmA5?=
 =?us-ascii?Q?nH7AYALB59kBFMix3edpY95CzxAPFy+SsaeIQK62NlNZbk11T+GTWzR+JVYc?=
 =?us-ascii?Q?GmJqVugbArIcIVy/gGpNIWCzJf/FSL+O2QnxmMAZhDbpAhq0HF+QwFmc4Z4M?=
 =?us-ascii?Q?cfVbquf/JB5iGNOHKHpqWpJ9azO1EayY6sdt4y5nb6GgrdAygE8eHh1wyb6+?=
 =?us-ascii?Q?1aGGM1fpWgzgj46JWf2ZTxv93W5vYK9tq6OeQEU8KqZsXseUMyNBpBt60WgN?=
 =?us-ascii?Q?3owZ+fakCw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	GT7iaEacojFzkAcSq2hlzBxbqOMUMHki4V4Rk4kfXDGeCWq7fBSFzkFZ09wwPO9iQaU3QRyn5i0QQaUoiZixFOf35R1gKONWIKIbH9ka7u+cggXlSUzxnBS/i90+Md+rAFufmTRWs2nRSwlg4aHaaF+EMqHGpuY3/S9etyQcI36X8oifhoCymgcp/EyojUSi8ZsqRR/m05GP85M020mbRvkvTQunquhQ9VWK9pAnLSMxC0Eh1GVvNZRgBuXxXRSN8QW6eDmj2EvEz/Zqkx3gDa9ZXULIY9VkuCcY2E2z6fcZcE0mSYNtWkaV3ARlQbxbjmNxSDeEpGKsb6sIPQ8hfA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GeYD4AlPocojXJEBWt8XdNnBp8ApP3qg/Nr05RX0PlrOdiPMw3O/MW24n5XxhauKRET7hvhpr1FOOjb/b3HqSlk/IWGWJEt5k3QUEXZmBrDaR+O5EQOmfwa3gpsOJAsUAiuCLlmybVAGwlMs56vXSbtUErsZHjTvI2wab9NNciDWxht0WPEVjDuTZZzKsZyuibloseHh9jKpMEtoiYpRJBQxhOc7u39u8wO/WIJj95C8LDi3fk8Y6PUPdtIBt8M0zQaKH2hL/VXW3onz/DHu8Hi/YMpyM++HZLJl8BP1dAliNvz2MOWe4FP0ot1eTHLJ+/Uqz1DTJUavdaQhK2t32u3yJ5fHxvy873mVZlIbNdN33YS9oA83XPcbalKDfz4JZAIfw/Si5RD/I65Be4swyX1j6RdUuCRmEccFl+Z7umkTCFaOBE/rUBlkeyTYPlfIIw9evUeTKeUTc/uZVUKhpxvBUteML5g952YVybhUBs9rAjnH31gUeLTtqzlc9lyU1h+020bWcb5VSb2SLQRaZojJu8hgVNTkMaG2h2u6/9Da7PuX6/bg7d5Ve3h8+c5C6P6CTeTNwyOdQyuR4AtmrGCXKbqF/SUuNhAtMEcSPSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 593c1f2d-298f-4e4b-cb1b-08df0ccdf848
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:28.5019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +REfSlB1MAXwfziahbEfJi1c7/2os8vwHrpXXr2h++c73NWD6kV/cwhs9fqVEzjr+kNzajIBmxtOs/3mZD+6fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6276
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-ORIG-GUID: j9RR2U7YNlKS67L9NEhfhZHuTbxP8NXL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOSBTYWx0ZWRfXxiEjsmvRuZit
 5y/yEotVT6Es8sOwaGHjzp4XXaoZw6X5Oln7kF80q2l0JpI2PNTgV4szrFbSKGV8ssgk8fLKiIA
 Gxqm8p/1Y+LEt6k7joczLVhNAAQmsXPzg2i2AnOwirHBOY07SyWd
X-Proofpoint-GUID: j9RR2U7YNlKS67L9NEhfhZHuTbxP8NXL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOSBTYWx0ZWRfX6NSz0ofFNx/P
 RpZemZPzhrJy3hzbiUkEcqlwQNvh8BzycJ2DEFiQKAaDgKpnZic5KRuwhYSne2Us/I3TcV6SvZk
 WYg6eNRXq+lVfvi1EEtHLnDbu6NaIP7EeameTd0c9+09MmTR1Dw+45y2w/A+53N0apdGIEUPAHj
 KJji/Raphg6HziH0VFVX/3518Qh2YEpSol3GJbCiRakSKOD2C4bOijSVN/KZNhPzAPfzvCNtVA6
 jDmn/M6g4KbKx8vWnPVdlk5SyIfPhbPgBfHQrBdVDPEbcBq1lQnBvj3rwBEyqla6qIA/pQ+VSqt
 92hPJZ7wUwNJ5DcB9Nzozg/AEPvs8pHf8SDD06sclOpLbIiYRFtvJuGCmEjh7JWhTngO51oHp7z
 5ivHxR2vn7VhTe1MX4LtoDVt71Ti+mTHwWrvd18fTYqHvPS8Rff3+pj64Ge2bKyzqKdJYFsYs6O
 ZLXn2HFNnbEvq4yXuKvrjh9FSlrSreaUeGHukO9I=
X-Authority-Analysis: v=2.4 cv=Td6mcxQh c=1 sm=1 tr=0 ts=6a9e9755 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=bA5FzAUjrTEoIiOIIUIA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521

From: John Garry <john.garry@linux.dev>

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bf02f14705518..84f17285bfa56 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4176,9 +4176,28 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.7

