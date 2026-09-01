Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB80C47CA9F;
	Tue,  1 Sep 2026 10:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259574; cv=fail; b=bq3gELXmNawxtAREFAMCgvH+wv60n4nbKB6q012mH42ici76OlNaZcbYxDEWJVoDJNyCQECb0eDvIpj0lq3cY5hcUgLCYU8mhSSDFhr9nRT5XDMFCkV/EUtxGnVT8yN9t9/aR4NeZEGdnWh0s++dvQmXkJiJrCh+q4IFaklv3Qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259574; c=relaxed/simple;
	bh=RN+L5KOpEmzubulIU/SUlvSE7bdW9m7T9JWYTiRI2Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O/Vn1mWOBRf6myzK3mRdwjA+wGbK6pCz5s22Ff9AQjGXmBJbNtWgayB2GCrKL21EBbqKYuuQtQUc5P7pbDdCVlHjAi/x+6jOeDdXzju0yREWEMVXtxuZJPv/8MMq+zwv3Sw6wcdpZRiwD/vCxo4nvS5nNXMmH5qqZljwPOgKBuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tk6BvUzx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hFSS9MhZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tk6BvUzx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hFSS9MhZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBwvX2296648;
	Tue, 1 Sep 2026 10:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GDs+L64Jr6fQBFhxqdr16TWtPoUfR3BFdJpYgHWHLSo=; b=
	Tk6BvUzxu7SkdYWQC7RHeAPzlVrLKitYWxtTcGChkD2SSDNo2rH4YYAiVv7glRtR
	z6GkQS3dAw/6OYUrD1fqbIN3QjcpcjBBCa7Zo+eM5IVz3veGnPa7H7NriXHnDy1z
	jkL3POit6Gg0/N9yCYTfOqDLPpqUmQyBpUAw2a8Nj9Bhr/9Sa9EH/BRpf76/X+Op
	hmgwbsj5lcsfhQWvy6wSUS9y0k5qJ4gnF+WBpISmXFd/9gHHgmel7EBicxhPwFa0
	C4k6KrIDvZDebWkXRWoRF0YZ04dvy2eEefSxW4XvQQwisU1zp4sBAbJaMd8aIv/U
	Pa9lb9SJbcLf1Wnw0XGFEw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xvd9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681Aj6KG023288;
	Tue, 1 Sep 2026 10:45:43 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve0hqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRUE/6CBq+6DUB43ywQeIJGM7LqWFNsnmY3Or8B7c0WFFPzgPRQIFCbfm6AtI8HFWcpTDvjcRUl8ODSyZKskWweQi84Io1//X/7s+QgqM3QGLS1QdmsJlvMKpqOHBPd8ME7tHOXLLcHpLVW5NnywDy/+IBknkrCAgDmY2n5L22l6f7PzviHUu8T+J7WPF2lhYUgAtp0kn00/AZ0h9hMkfT967HPm7CuhQkp++Sbt3a9pVN9XtWorepJJ/V2Jy8RPFyxn1so3DW+kySu4t6NYdvnB8lMDk8NOHyOP10tihC+J18eZMbHMACWLTX6V1b7aSj7DafBdooTka2awyqlPZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDs+L64Jr6fQBFhxqdr16TWtPoUfR3BFdJpYgHWHLSo=;
 b=GtB500K8qgFCCR1sk/GXhSGqjiB5dFDf6R8p4GMpWI8/hsM+wZvO2f1fSsIpUPdLRe29ichnsdww/NUp3+hETGi0TxpGN2HqnbNwy4ITgL/LX2fJv/bBwJKn0IXc7YV/KbZs00f0w9NlA+LgR+jpvLSmCBizPkBfAYYEuiQEhwfEZd9YFXYWacS+xK3QJzxx9SGma5aXmB9nviF8HnWCzrGdaXX8NIi8qaEOiXBwwqF5QQ12UFhkKNGg2LrHlqGw2bWygO6aah6l3TmwoxKeQBCmUYMIhcS7mIhQO8XgKhTQM/gaajoSrcxZlzysg4MKIhGqqZK/OJkSTM78uV7lcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDs+L64Jr6fQBFhxqdr16TWtPoUfR3BFdJpYgHWHLSo=;
 b=hFSS9MhZFzbirIvKUG+bmLdQhqp4GNIg/sGDZycwhfDMVtK0qsDb6oGoViDeLpR5hzIBqtewVA821yDCGQYcK+8vN9dFf+0S9iias9SZB2nNzZCPa67Ft9Aowmv9MROdSEJtDWT29/j8lVd576SGaLhiRG46bz57nT8MlLgfqck=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:41 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 02/27] libmultipath: Add basic gendisk support
Date: Tue,  1 Sep 2026 10:45:01 +0000
Message-ID: <20260901104526.3850621-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH3P221CA0010.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1e7::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7b0247-dd21-4d94-5914-08df08162acc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	zFjtlCEtmIAfMQ5rfLUNU+GwOn6Em3GN72x0cBLBDXqD2nQgx0XIlyihjTiqg2hPEx92QYxkx6W0UzPvjbbZLuJDS/yY77exNdnsc2CzkxN1XDzBazd2MqHbCWkKhGO7EzvrcARCwvs1lOa4XoR7Y7ysyOYraklHh/+I4nrZhftzLclWf1jKy8h2IboRI7mHXu28uQ75nMiT7hnmuqipNAmdYNKndyRp6ysg0M4NFxSt7eFgS24lVeizAZvUTHH9bszYLRi1+pfhPL3DI0PjGFt+WjRO2j//YvcaZmph19MD9xVCb6aTHkKwtpvgsTYzfvjMJMYUBFxC496jHtxUuGVfi5Is8JsybdX3ZM4nn0JXjUOIrt/cihOyrNX/UdKYWTHmg2zTlP+myQVJtB/Usbv06BdFi067Lkq3e2iLUViFcng4SM3RBjGUzMG7jsv1GPC5uez+xmC1LtHf51/8whD1WU44GT2k8BBkM98HAUoR35P3CNc/gkMdLzgFEyMQxmTSWUNfXCLWUBtLAjb7CI9de9wKeOVU0MySAWv4rHHITR9jbQt1WLo2BBcnLRtEjOkEJGx9E87GBp9Uj4cIAcUi3+1OP3DWlsdxl67L53B8kjdHGL5TZL+wed9uNhwI798hjk0eangqZIzUXChfJh3mZp8z2TyRzCYLa4jDeqw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dxkMAjbOn0m/cXY5MI/VbAsKKCJiojGyJmzlh1iA382IB/FwEEzhw5oL/87B?=
 =?us-ascii?Q?PrFgW3MyBGkGH4vVFp/JpOOQxDkgdVLxr/Szehn+JMvGvtrD1aNQXca0+HNP?=
 =?us-ascii?Q?KM04qh7tAJQ/F0vCHrnl1iULIO/DFbi+gaXfbddz2liqpWXa5hWgjSiKp2/E?=
 =?us-ascii?Q?rigvHyLCoz4TxM/gllTsv6DoFRiqgiCDFEOJsOLSOnvrOgU5rzN2JgzYWj/k?=
 =?us-ascii?Q?TXflkhIDlEBG+wHWVWdhvwEyE57RyzA/GoFzmZgp3hjHns1j4yokVXk7ZnNt?=
 =?us-ascii?Q?7pv/t7JhWXS4YZsRhZYvS7Rc3b7g0sbYtQTPanrtgszp0O1favo6WOVOsPe6?=
 =?us-ascii?Q?VZjB4tbbGIBGVP51upZEn9Izx0T3oxUXfVStDptyHCIi07gQxwt0Fxhcjw6o?=
 =?us-ascii?Q?SVkLmArPYD8VUnGfw34IoDpO9fMOYMPugHdppwnGdNnTumL/xsSd65/nKoRO?=
 =?us-ascii?Q?TaesgUvEvJoh5xCKpjyGKEMzr83V3DNux3ChZQtJ0EJGNWlh9rJBQYq8wX1z?=
 =?us-ascii?Q?U8cKMNl4rHVG3TQdqJPXjQ0VYIyhm/22aDtlaSfwMoMW4mpyQO9p597e0kG2?=
 =?us-ascii?Q?CZ0BkSj4A/clW+NFnwm2q0PPcbQRzlrq2dwVgBJQgbt8QW1IcvZEPrYOruhz?=
 =?us-ascii?Q?o59w8U6pddeX2aFvVdIg72k1yEHAzHLPrb2fDT4crN4UCDwSWE0M7M0JMhc4?=
 =?us-ascii?Q?IWQVzjiJnopLWhXhB2AaNe8DFmvUwbJx1oj+s/g60Rj8g3Zq3B9qsKX5WYoq?=
 =?us-ascii?Q?S1Co55MsWwzo1rxhWln94a4FX6KYLAl91ShQG8DwT/yW15exFWef0Ih+t2dk?=
 =?us-ascii?Q?KFs36MDH41CDRjjIS7S6CxBfcaXE/ANBIq/QsZPXEwhzdpXrDNl8TZPY5nds?=
 =?us-ascii?Q?4WmWkVYrC4AeSHqCBTIAk85KzR49y4sJ1mQ+yWTw3sKFEYVliM92Cz869RDr?=
 =?us-ascii?Q?bhTdbdlyr3EusPkA7ruYY/HojzPg9Ej6yxe7PTr5IW6Qxl2dAWKDGTZwbeKN?=
 =?us-ascii?Q?ZxWTLQ2t1RTIZ4WmUAWaujISzIeC+cCdmlVYsVnjxfDWhW1b86vh6ZsaANfV?=
 =?us-ascii?Q?hPwsyG0DqT9SAYEgT5lbcXHsD4MQp6UV6EynnoeeyBhrgiKYNpt0xxH0pLoF?=
 =?us-ascii?Q?vR8ZHLbTQtjNzOueuInySLomJbAYyWzWJV5Q+cgvhUqlMAbMAkWYMB68Z3oZ?=
 =?us-ascii?Q?MVfeVb+r3jcIHZZ7Uhi4PYkAR4UFZ2e0fQ/hE2pLUgsvIIZt7p0E00gdndHv?=
 =?us-ascii?Q?Ziv3dkwmooswLRB48vMChQm9ud+5KswKEg8tWMalUn2/IeqNzuXr+L06Uxw2?=
 =?us-ascii?Q?zeDabSzvE4haaozqEMAvnFY8Z9kDWmPL0CHhWrmxEajL6sCf7zmKgdMKZ26C?=
 =?us-ascii?Q?/uK0xjiatwf5rIxJibN6RArABhIrnyO73PLXVzOVCqQqdi7AdIonJsxNFM9w?=
 =?us-ascii?Q?c1VBjb7JIvcbPlslsoupk8+rvICSRf5YHhLM1ndSWbhDvUitGw0am5lCa3qi?=
 =?us-ascii?Q?hsyxi+hxtd7HNeLlmlPDL8KGqd6H1V9Jxwlq416cOo/5UsCXYbplTjCaX9wc?=
 =?us-ascii?Q?gEDUIDqI64VGAeVgJANfzcs7eWX2X4JeTRxdMPNzNrFKWHVrYohc8N8q8OC/?=
 =?us-ascii?Q?EZNpePGo0DUJ00QwsuMEGSBzsOnzD6zFT29B2rtKIISp4zmlMRGmOoNH53LB?=
 =?us-ascii?Q?Fr7FInykxuqTpEqB9RtjWPjKjXXBrVnGi2lqCjIA2POJpaP7SSvga09ofaso?=
 =?us-ascii?Q?+e3PXkFYvA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Wlw61fwJaw3NMHpQU8ihZTm2/k6V3gYseBoQfhHK43A26pQxytPe/5m4z7NFYI51zcfcX6VnxMvDZ18LVlnUdeNfFQIJOpot4W7VRAIGXymZdGq9gewJ6JGgx5tcCse4Bcq/YBPg7TK0lMxU0/QbF+LeQ2wQ+h9qHsd/vLZMJ2sRasIyLoqMEnNyTzLQv9ffTXyibCjLv+VeN1o7Cd+P6hTPf9iNCvAxWblWIixmMaR0vBurBG71gaZ/yhe6NrfkbP2csfW5BMN9eWWTU7RNsXce+8CsIq/nNxl1KOX2SzeokcLI6LOlQmHpS4jkfHhttIqM6jbAaquml6/fSSzw0A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H/n/aX14zmrRratIDzUDxG+W2m6Aadkju+4qhZwl7yp4oqbjD+keXs9kYY/nd+QesF8/ouMxV+HSl1sJGzq4zk2nfbIsKlnVexzi81/kV653k8z4j8LnZayWDL8hY02vPyZuni6GAZEvEX0hAIiBfBNp3TD2C4bne43FFv5q3s+cPKVGF+RXIiFbuXCYp9+5/Y2JDYL614UC9rwDU2qb49uoXGzbqK6Xdi2rs6yPGyg53VdVQoCXdwNefodLOGPGSt1iHX98tyRq4m/fouOScvFn7Rmizy3v8OjJgCvk981lxWbMuiVKwDCwlLctcMYTcFUZTt3hYELiPjWJDMo8XQjEg+XlA/7bvhxVy7oUUSZ3MNS7pwsIImVr/OniIOTjYwy4QF0Z3Sfkp0eit1SC1gPXkEopy7zj9rY1TdOy52q1uV4X7pgGrhdRYyONn+7lM3sUKnJ/BJLfEdFtLob4pQeQPfcO9loz4LUdUZ+xGeW4FjkSrKPfas+PWkPtuuL8ci8OSfWdmr9Q5JGtpieJeAqax2iLrvh9NgDoEzjT908+S1aS/k0VfZFyB8/H+A1lOLyTo3fGvp9rPzMyGDugHPlPkDGuo3N1cNaBErXNKVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7b0247-dd21-4d94-5914-08df08162acc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:41.1306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +5MAST6+Q0dFewXmZLytrSVjKWbK4eU0AMC4F8wOrgdkQCenDqCw2YjpN0kBYg4a06yXP6U3F7sAlAFtLYhCtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-ORIG-GUID: lUjMWFHA3rNqnwZSYEgWdFyDOVLStdfA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXxa6b1g0aNgHt
 Y6gZdsHvHsnS6mWsLH04cE6ylqBMM4goLKVH810cUdTSuakWblQ2DWPiaejo7ph4KaLLuSezC8T
 Lve4qVEtxKbIetm780TYeK5hEdb9wPJqPW3ArXZLwJutZh5JlcyCjy+YAN50yhYpEfiMsz6C4uk
 cZ8c+UW5zUFiUFjGd+Ol+IngmfNR6a0hh9AwAKFW21S7AJKiMk2w5oUc8P0fmyZjarxk047tb2v
 XgB3MeZcZW6kC9VDGg6i11DH7+9mJfKkmzYrEyFrwFruQ8G3XfXyfwo40Im1rE/xHzY0WL26U2v
 Vjq1FGtlY03rTmtgc9ZeYDunLplbCwDx1ptYvFgaK+FEncaYbfywPXVtnfocuZ1EPuFWOrG30Ud
 CLOnDWPjan4b9YnmGagLwEnclCCKjSz1AzRY+eocwZqSnpBrA3bVFFulWetlDDrAcEPo96AVNbs
 bP74xIpTvI1i59+aC7w==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a96acd8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=B52eoxIPv8yZRAGToxQA:9
X-Proofpoint-GUID: lUjMWFHA3rNqnwZSYEgWdFyDOVLStdfA
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX1FM065qQVZtI
 Q5Z6HXoWEQ6bFkylDbro6OR0wyWv9FbXfuDfYEkCXO+DESioS3Y+JOXyVCXdRlbJHFLtluR4OBp
 M7RCB3uKhCb7TYwJWRdzwAb1JNCnqFRynoEF0l3m4zHSdjA8ut9L

From: John Garry <john.garry@linux.dev>

Add support to allocate and free a multipath gendisk.

NVMe has almost like-for-like equivalents here:
- mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
- multipath_partition_scan_work() -> nvme_partition_scan_work()
- mpath_remove_disk() -> nvme_remove_head()
- mpath_device_set_live() -> nvme_mpath_set_live()

struct mpath_head_template is introduced as a method for drivers to
provide custom multipath functionality.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  38 ++++++++++++++
 lib/multipath.c           | 104 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 407d985cd31f5..ca6e02505be43 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,11 +5,19 @@
 #include <linux/blkdev.h>
 #include <linux/srcu.h>
 
+extern const struct block_device_operations mpath_ops;
+
 struct mpath_device {
+	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
 };
 
+struct mpath_head_template {
+};
+
+#define MPATH_HEAD_DISK_LIVE 			0
+
 struct mpath_head {
 	struct srcu_struct	srcu;
 	struct list_head	dev_list;	/* list of all mpath_devs */
@@ -17,12 +25,42 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	unsigned long		flags;
+	struct gendisk		*disk;
+	struct work_struct	partition_scan_work;
+	struct device		*parent;
+	const struct attribute_group 		**disk_groups;
+	const struct mpath_head_template	*mpdt;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
+{
+	return mpath_bd_device_to_head(disk_to_dev(disk));
+}
+
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
 void mpath_head_uninit(struct mpath_head *mpath_head);
 
+void mpath_put_disk(struct mpath_head *mpath_head);
+void mpath_remove_disk(struct mpath_head *mpath_head);
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node);
+void mpath_device_set_live(struct mpath_device *mpath_device);
+
+static inline bool is_mpath_disk(struct gendisk *disk)
+{
+	#if IS_ENABLED(CONFIG_LIBMULTIPATH)
+	return disk->fops == &mpath_ops;
+	#else
+	return false;
+	#endif
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index f7b26c66eac7c..1cf20b0f62d07 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -36,6 +36,107 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_head_uninit);
 
+static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	return mpath_get_head(mpath_head);
+}
+
+static void mpath_bdev_release(struct gendisk *disk)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	mpath_put_head(mpath_head);
+}
+
+const struct block_device_operations mpath_ops = {
+	.owner          = THIS_MODULE,
+	.open		= mpath_bdev_open,
+	.release	= mpath_bdev_release,
+};
+EXPORT_SYMBOL_GPL(mpath_ops);
+
+static void multipath_partition_scan_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+		container_of(work, struct mpath_head, partition_scan_work);
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &mpath_head->disk->state)))
+		return;
+
+	mutex_lock(&mpath_head->disk->open_mutex);
+	bdev_disk_changed(mpath_head->disk, false);
+	mutex_unlock(&mpath_head->disk->open_mutex);
+}
+
+void mpath_remove_disk(struct mpath_head *mpath_head)
+{
+	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		struct gendisk *disk = mpath_head->disk;
+
+		del_gendisk(disk);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_remove_disk);
+
+void mpath_put_disk(struct mpath_head *mpath_head)
+{
+	if (!mpath_head->disk)
+		return;
+
+	/* make sure all pending bios are cleaned up */
+	flush_work(&mpath_head->partition_scan_work);
+	put_disk(mpath_head->disk);
+	mpath_head->disk = NULL;
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node)
+{
+	struct gendisk *disk;
+
+	if (!mpath_head->disk_groups || !mpath_head->parent ||
+	    mpath_head->disk)
+		return -EINVAL;
+
+	disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
+
+	mpath_head->disk = disk;
+	mpath_head->disk->private_data = mpath_head;
+	mpath_head->disk->fops = &mpath_ops;
+
+	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head_disk);
+
+void mpath_device_set_live(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int ret;
+
+	if (!mpath_head->disk)
+		return;
+
+	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		dev_set_drvdata(disk_to_dev(mpath_head->disk), mpath_head);
+		ret = device_add_disk(mpath_head->parent, mpath_head->disk,
+				mpath_head->disk_groups);
+		if (ret) {
+			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
+			return;
+		}
+		queue_work(mpath_wq, &mpath_head->partition_scan_work);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_device_set_live);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
@@ -43,6 +144,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 	mutex_init(&mpath_head->lock);
 	refcount_set(&mpath_head->refcount, 1);
 
+	INIT_WORK(&mpath_head->partition_scan_work,
+		multipath_partition_scan_work);
+
 	return init_srcu_struct(&mpath_head->srcu);
 }
 EXPORT_SYMBOL_GPL(mpath_head_init);
-- 
2.43.7

