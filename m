Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D0D3DA7D9;
	Mon, 27 Jul 2026 14:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163450; cv=fail; b=HMEfT4MZafyy+3AX53ygMEnXdwFfphnHx9UUeNb7Fh3lkg8+2Sk0wgIIsNL6jUIUPM6ImpNOWiW5a9Oekz7KwQlV9DHexZfz1OErRyx2nAw8D02WyM0HLprUNvuerTHJSw8Saj+mVSbUtToL3IchJQCNgdjqYqOtiESqLNNNY8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163450; c=relaxed/simple;
	bh=CjwUzWXoUqtOdNn8DwcA2rV0O2KEtYQ8Kbmc6zuWPWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xr+e52ijG1UHcTLl9wgeffgT9x5jM/mg8cy5BCkV+U5ldK24KLDT+GuObPGRBzWmgs8NSG91P3ezjwmnWRmjLhgqGFgtt4D5IXHh2i3YBQO9kBhTqQ/UPZ++EPoe3KRsr4VcAMZKtcfSSJ05bb9f/n2kLX9x1Ymh4AqA3yxd+TM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KM0nFwLn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JyppOIQ/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KM0nFwLn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JyppOIQ/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTGoj2082260;
	Mon, 27 Jul 2026 14:43:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5EPHHuwY5E2QCPr/1Vp8As5DgbWDwNaiOqojDIUe/xY=; b=
	KM0nFwLnfUCXojoZkHtqgE8N/d8iC/d/grEUV86vkvRiHpgB42pEBEXPzmJm3mEW
	Y2UVRcngD5Gja8ElwGmby51otb/jbLmlEODTrOe5FN1oQKliH9xvnueZ8GrWxa80
	NvVmq1xW2QH+77KfvWXfMMdE1g1tplmrVysLkKxZ1kIEj4c6ueddqbksIYQb9twN
	XCTA+h/8XU45Kq55hGdhIooDiBcOhxLwoFtdr20i+dv1cFwZ4TD7KBiCLsS7gRIt
	aTlgk+/KYfJNJJK6MiQ4kFa4BwIHnUYmCUrfnzoRl2Mdej2m0zoKv+lIumrkLi4g
	Ba8TbHI0C9CQDkk9FlQAxQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym1xku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeCJG006892;
	Mon, 27 Jul 2026 14:43:18 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehawnu-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tEOIf7zRIHuWtZ/cfkKitgXeJc8VbX2fmtb3FTd0k2h7ElaSPQ84uHW6g91XkRHUSkK9NlQ1p5vT4u70+i6rTPSHiEogHkPMEgsqYAH574+wC7HLdCb+uhLwq4wkasKZLNRFIsIjfsanJHXPBrYhqbVhJfjTETgEff8y8UMFXP2wqq2ZmxwzFivALkVAeLXbZy+4LBVtjLZw5PUUCDOKByvSUiEgdo68wtC9ouYdHO3eLFAWtuYO78mZY/FaT403klkZxw13e80vvqwL/jOWHjanB7kY2Sf48qkKlT9xn/xPeZ/gdQ0V14YVKpsKxM7kC3ZJWP0mxD/W1O0XZ3bzrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EPHHuwY5E2QCPr/1Vp8As5DgbWDwNaiOqojDIUe/xY=;
 b=hSWjSqMPOFna7IQnpEIHuQVgsscQkRiQE+LJjKZxSo+xJbUvm2aaLLB1C9nZbUDtKQw/faXQ2bsQ8bkYjUUk9SEc6WEC/3WN/U4HVZFiiLIflyM5AbiYyfthbZG5CTa41u/OWjzfnONLX0L8ArugSJwKfXwLgPKV3PBfrb518DMGCe/cQHTU1FqUuuDMtJMFenAFKNJofyDIiLkzu00LzGmKdi9DvUrFA1o1CG/v/hY+r4BnZifmrBk3Q79mC1y+nMdX1RQmz9ftHWSIYuOAhCKBFFxHX4gnlQhKE4Q1HskjQNbDkhveDvoJxoQTJ3c64KXAcL+siXF2mN4ky/c5Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EPHHuwY5E2QCPr/1Vp8As5DgbWDwNaiOqojDIUe/xY=;
 b=JyppOIQ/dEycJP3FR5geGjCKoFSshiqMFMDJk3TBIjmwA78sGOdQnELd48zjkhS3pihuiW72LIubHsE6JfwibB1Z/Y2LlBZB9pq/HbO0MHFLmJfRGos/4t1nosW0FW5MNmjdTZ6OJJhTJhVtfuhNk8oHUwn5LnY8uKrP/q++JmM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:15 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 13/27] scsi-multipath: provide sysfs link from to scsi_device
Date: Mon, 27 Jul 2026 14:42:20 +0000
Message-ID: <20260727144234.3802948-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DSZP220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:5:280::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: d64e155c-8ebe-41f3-0991-08deebed63fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	92VhGGyl0qdKzI3cr6x4Mw//805raLYb+CsF0AHva0vqVW12w1qA9ZoZfxgAZ+CVvPRPdu36kvdy5bZ4Ba1d3QqVZkZm9MOIMhTFenVprLgTI12BgxZOzU6CztabUn8iK37AHHtRkLWmRT0wmKVWf0NBjVud3Lj40jxX+XDjj2fPq+pDQoHNyvTSBvnLO4dL5w38HQp9PydnF3l7UY7vXgsLRWChS/GFSRQNaLfLdPWWML+Iko0u+/WTBw70+QHSnQjnm09Wjurjh6nUFTwUJytBcNgc6lx3qsBF4n9yooIiHmo+ouDlBwf5jZ0gK4EWgnxqxx+UUmVw0SxfYdPbvhkdT/unPNBHaIaKpw3ZCuTSpElTaUWmXN2PuZnTI+IgF6HVXHTTRbvzUsHpwsDOqOwdn/yFie14yGXoBD0dP8KOIz7XRNzWlzNPRw4sUw7n+vUMEs1bq+JVXCrahHg1ghrKA6S2jkkCpyTP1kii5+jm4iykejLtBU0PlTGCco5+14SK/cs7RYNxBu3PqIW3hAB/kOK5t7JbzfeqpEboij5Qo9RUkZ1AWm2QDXuXNlfxoW6s4Ty9JG/WE+g9cQqw/eKYx4GgODMAYNNzfUv+udUN6/PJxDUNCv8+wuGkj8sTVvj3dJCUOooZBD5Qo4LzUPC9Y8yyVVRykpLA9N/nodk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YrOGZ+DhPuBIArTA0IoRsBzhWryxzOH0HA8L0FsTAx+o5lEExJJM6uFsAaLU?=
 =?us-ascii?Q?GhrcSAoVQp10utCJMgoWSDirqIZIq3N3c4CuHpoIJCo0ur2jold7j+WQMt08?=
 =?us-ascii?Q?wTc0mThjnQGbBVLy3Kw/GP9MKXoVIBTIw8F1dQFKob49as8kAEBNNRBrfjfZ?=
 =?us-ascii?Q?+ExaclFtRT8/VJkdPSa+OkprfzCe0LM+TV+k44AfXKh4sHeoHpEu961Qjp94?=
 =?us-ascii?Q?5z0lbD270zqyGKAcspRWIlMbW6m0sKfWp+16cR90wM48+G3kprs76Hqs20M9?=
 =?us-ascii?Q?TsavWrBzDSi0TNO0kc8H4Kk0Klj0M8+Oc7/x2kcGzuE0oyRqL1Q4hckxSjiZ?=
 =?us-ascii?Q?wGPZQ9Uj7Jzr58pDQAoGrIXzJgjL5g/pWA0bFdr0DHmwcvp9M9GdVE475oIC?=
 =?us-ascii?Q?RVwdO5gs0lb/Ve1V67GzTk8kly+tPUvqrYYOjB3HaqyRiV/OgUma98irDrtR?=
 =?us-ascii?Q?7pTY5IpraWmUlGMWeB7qHOUJ2Zwj6WZ7qAAlnwf1bmyOfNWp7p1I+4PTRgsO?=
 =?us-ascii?Q?/JP8OnS7Foo+a8365Ocqh7LK9NdlzN7cYrwgXYwCfJjmOT2cu+Zy7KryWzt5?=
 =?us-ascii?Q?kBTCJA9BEdH8AXfzW+EK9ivhsWjGEjimmEGXW6e+t1YXi3q6NCNJwglqGN1K?=
 =?us-ascii?Q?NO4ocR9aqHNzS/MGX6jTw3KQAc4F30wEnMUNLF2dV9YOjBAHq7fKtqvXVX4N?=
 =?us-ascii?Q?cPOlu8SFW0DlRTbEsSwyIBjss7/YMAC2gMB8AV8CZOYuz7Rym8zw3iW8WmR4?=
 =?us-ascii?Q?YQsPCMiwUM8Lqg6FIGJuCDh6iwEXVt5KbaBf/Xz8YX3JoGofqzIneA2rWXgu?=
 =?us-ascii?Q?ZkHcDTSV/1y3QAcmA/FRZhjdmb2iQj+fwry5RmMnPS59BfRSA8ShZVkwUdVP?=
 =?us-ascii?Q?EvfxZgwhk5JtHTaJoiFt9vK/XM17yGyh9TyD8+88iYLEqHWHw3MuyRa78wUx?=
 =?us-ascii?Q?Jon7+YoxDrzGBNj5HBtfaCFMsalULllfMAmFI2fOzRnmuXnGFTHlEmUvUiSo?=
 =?us-ascii?Q?/gEywqOzUpVxqlHTAEJqON/NfCA5Efuc/Ftxja+xOlkfOOT5uH5O2XK43VLz?=
 =?us-ascii?Q?dXzI2gSS0QquuLhiG66i64hT2kiwZ99EHT2LgLVsJU5+6Or8hFt4sr9KMMkd?=
 =?us-ascii?Q?9GJOVYNLIbWv1Mysycme1nBu8w2FoSiNOt0MIko6NsUIp8hGSNoLTXas8T08?=
 =?us-ascii?Q?crby+8gi83lCPPVsLxQsEcPFooToHj0sitcX6gpKDGKjVwD4fwxscqM7JPik?=
 =?us-ascii?Q?t761WZo6c372kAythrm94y4eBnegADdGmqJOqoWqA7AwxbhHBCh3hMMEA1EF?=
 =?us-ascii?Q?nMI1QPsHqifODyy42CzQm5Is696Dg/fg+j23z+hHp50i3PvfAv8Iy5/3MBnA?=
 =?us-ascii?Q?Cf6XGvBIAIjtE57GbutDnOWbCFFC8e+GR4u5DURh5D8GODMruHsXC3ew0Tx1?=
 =?us-ascii?Q?KSnub+wbt+7yWDTAsdXHaCvUZdSemLnDWMezYqCAhFkXKgFB98TeUbYZdpdf?=
 =?us-ascii?Q?U+NAQfqPu8enwVen6wzut3jhHFaQ+MDSoPiryWe73y6zycg8T5V/6M2VJziK?=
 =?us-ascii?Q?JsIgwIY4dH5t8QICSeNnoGtwPK3lzcpiekh38mBd7vkX9yMroa+LMrnsarqO?=
 =?us-ascii?Q?nx02TuZz7yCU9jkckJvauaMSzePTpndZgmoMS5iB0fNXp992gswlnAA8DGrt?=
 =?us-ascii?Q?imisTlaqp9Mnf64wRwiZT9EyImPurEaSRfssfpZzO/AxKcjxIp25F1ScTtXn?=
 =?us-ascii?Q?wBgUVWeZzxdJ9ii6eiHc6y2TUZP3Xak=3D?=
X-Exchange-RoutingPolicyChecked:
	fqw3SB2MbMOIpGfdnSt+4UpWHhrMErkqURnsm0GzH278uCORRljuBonsYwFQMqcXyvI7RNERye8HhVx8EVuNM+CtYlW25svVJsQibgN27xG22FRyst7F/9WAGiDX482nVAHBcZVhYVf0QvBXOIpV3NLJM7/oNwSyazN7cPrBDljuiXNAbWlddTDn0kEO4wQ9MSY2AWhcp4A/Ll2U4dtv7jgHEY1By5iRtU4cZXEByblHCBSd6OzP12EOp1mF7Sdyry5vSsB/6F3yQ0ITfr5qThiEWzARi2MOUpbjb0N001t2gjwDKi6ixWLl/1cb4yr6k45K20P6qJ7WSrL3viMXwA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UzPpQ8pFbnaq8BBCyYa3OQ2u71kg9hgs4p+KnlJE8Z2ClTEo64SyrlNpZ/1ILQwBxIMF28xC7SlAwKDDeQTHtvSXiWia5JUUoAgwYUEZVTYEjykWm3IekV0rm8wjTRI5TPCh33OYaYkhl/Zt2UlvSSr9ethzy5fSwNbDZC83/4/3G6NI6aR5wQLbGyFFBOxssNMGsICdOPrAb6Js8xWpo3JIHTineU+AwhXiLfxnh3Sgl8MnJ7YDrKkwIRxG+7iv72U47xRLIgp5FmsilYIWSLjDmA8dsty9lfsC/RYW0HSU9xpKzyCPAJNbKfMA6KZyRxhFkoPtKnQQC19bCSycTqjHl2UmqmH14ZSFp2RDSb7ZqFHxDIL9CsmJw2/yZTwiOktjBn4kUCT8l93ZLg/U1VxSxVyKchioWVJ/BhOATtsRjIYMR/3C+0SWatCG1KaaUW6EEkRmfjaq+NwkUdlr+9uS55D5KNpXMtTbTw52nvgTDfsiqixCHmmY/wvRL3ReniycOMnPWIrKdO8zqrTVcdbcqWW0JaTUroyUc7zw7msra9O35Gr/rzM5bzUIQmBzS6L6YxyZGuBxpFiD6fai+U9k1YTW4aNqdkLwOK6ad6s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64e155c-8ebe-41f3-0991-08deebed63fb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:15.1799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jYaJQ6hEW/pifa/j1nS3ztAeevggpaJtfF4EIsrd8I7QzJOwVMpVgB3ghg0OfM2kgzK9jn2nA+tbYJMe9L8LTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX1lEDvrVg7Fcp
 Z+axs+ZkguyLs5ElYH6+JiSBDKy6xbtdRDhFZRm72yXNaYvVgbkKI6sSxXf0XVp1460TIgooktX
 vtc4MEokNACatArRuaaKovF0yay1+IuG3pAOAIy1pDy0XPHZp+rp
X-Proofpoint-ORIG-GUID: fgCNptWjFtgaJ-eREmPuwU4odQgdNn9q
X-Proofpoint-GUID: fgCNptWjFtgaJ-eREmPuwU4odQgdNn9q
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a676e87 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=ZbQ-JUxe3OK3M8wTWUQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfXw/u6eYNA4FUG
 pSXu9Tf+Sla7YDvkb7niKPGJalEQddWFZJCT9I074g+vGPA9pQe5Rb3Na5i7GNl5TKjsM9glYyx
 3judeMqPJN1v/MQZKGzUcxRr9WzDsTop8mx8eY3kUJLq8fw79OZjGmRzRCAuC3GGbqR/B0Dg7Iu
 AP9sZwnOzCeJ/c8UtoJju+ZeXyqxXwMkvmnNPWnWVNftehG4QztfmOivtccvZ9sbHfY5Z5oQfJI
 GnETYkvA9aBYiZuM9xvvD70ERRNLc25cUWy943pd9dkyU9Lwa18/xzICo7tnhHo0rhAHMqj73WR
 PZ9nK6dG3pZo+OtU4MpZzHM9r0qbG/I1ZQPhcjimQWvEc5vJydiFepKIzUkz1nvQM16iGL7lgHJ
 YM3FDxPy5bToeHB4/bAecePJf1/PNE0bLVgNXYhfgfmDJUfGkrYdqd2XFt/UriGrCVTYQJibRyE
 QvbGGuyhnM7Ffytm7iA==

From: John Garry <john.garry@linux.dev>

Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.

An example is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 43 +++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c     |  5 ++++
 include/scsi/scsi_multipath.h |  8 +++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 5d19ab6a89eb5..1866f282c15cc 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -112,11 +112,54 @@ static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
 }
 DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *scsi_mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= scsi_mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs),
+};
+
 static const struct attribute_group *scsi_mpath_device_groups[] = {
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
+		sdev_printk(KERN_INFO, sdev, "Failed to create mpath sysfs link, error=%d\n",
+				    error);
+	}
+}
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
+
 static const struct class scsi_mpath_device_class = {
 	.name = "scsi_mpath_device",
 	.dev_groups = scsi_mpath_device_groups,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 799569b74b535..ce51fcc002bbf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1443,6 +1443,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_add_sysfs_link(sdev);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
@@ -1495,6 +1498,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_remove_sysfs_link(sdev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 50298056181f9..a9fd02bc42371 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -46,6 +46,8 @@ void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
@@ -82,5 +84,11 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+}
+static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

