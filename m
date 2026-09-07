Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A5149B20C;
	Mon,  7 Sep 2026 10:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778357; cv=fail; b=drbZ6rduInfGUB/MjBxPKVPCgR9K4sN8YZ12P0fyQqKvqMImUFI3KIcLn5xmXiZi5nC3ATbmcKOfgawxgm8NyVFmraD8SmZNCZuapr8EQMckwusDB+Ln94EXi0MpeUrO0V41MXzl56+AHW0bunDLY4RxPkhOw0F2IDIJneJ/mkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778357; c=relaxed/simple;
	bh=fL7DspdRoZPWPj2nIIShgAJn12pxnjKALmynQ1jCFpY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rb/HVvJ+dRJPwufhsaG0Deq+KNRYC6BioDJHLcE94LWLBYN4pK7wEXmOETi2UM/vMbd5u8MgAfX6oIP0SW13PbHRGzEA5MYzbe+6wqGth8GxOqjtGgZ8+qwjZlOg70A1YIitJJcXL21JT6x3q63PPtcr4XOwiG0Ap7p9TCBNQqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nh8crmGX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cd3UModl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nh8crmGX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cd3UModl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870V5eJ695243;
	Mon, 7 Sep 2026 10:51:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=MWVeJZXNNoV6bAtj
	o+MFK1Fk5voz+QFA1oGI2UOdlOw=; b=Nh8crmGXpn0OmJoVRCxRFoY6xnO7QR5S
	R+WdL7T06mV/LHI5neU/c4+x2B/ERXQKUcIfc9XpPINy1wLyti3pFnGUXv7lEBd6
	tKrM5glc81ON6Rd4S5u61ta2bdjgFfa84BtxAzhjWug1ZXkq4drKm3mQeBhODq2q
	nX8iBYxvVoI+4dFFX3fJvWYNpACtO4OfF7XPCTKH6q+n7TpycyukVNrDFp0q1A59
	lHsQfiVh0uUT4vOxbkq2LWn9FWSRjLSWJnnJZsXHskegImZPnA6KxcOXLqQWbkp1
	b0+EGAtCqlrMekN5mvEgG2kJwo31sIoIN74bm3Rab/5xXsoWAPqoQA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbd3ssye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687Aopsw019105;
	Mon, 7 Sep 2026 10:51:38 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8sd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h7n1HN7rVBvNpmL+asZtOoyQNPaTKxGlUYvN/oP9k0Xg/eDiyJbR2isCidaIZpFv26vxSw9gn5Tf2FDt5KpGtbg5CzgukM58W8UWzPX4ThIzqCMGcm0rqGHfnJf9fC1ERIb8KsDSueKhJ0YfnT9o0q5Nf2cISIiGsZF0RBx3JT+6sIx7MskXoKSARnBH3szC79prFTD2t9CXobZfuaB7L30XCaQtmnpmVUwkWxUbBqT8gjp7f25zjRNsvJlqRA9Kxy6bPlrL1OEmuZSqYHIPJbZnxebMMFO8zwbcudEUdn3jsZSA5k+eIfJliNCTIgyYxTDooddpOfkiKguWnjVemw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWVeJZXNNoV6bAtjo+MFK1Fk5voz+QFA1oGI2UOdlOw=;
 b=PSNj1EF+CKKc9P9+ZsYMnlALBfwZZjvB82RmYSNL6aZdLo5AMPSFTgv2zUqdJkGac3618pVufd1AR/X/vO+cdL8Bbh40bHVxJybNIUQiM6KcWNCe22ZahTCFhhLOizwkWOsUM07bGq38VywalU5YpPSQFP3Jx1W3oI8/voMRgh/yQYRfyoqAtSgpcw9YkNhYqHb4WmQnp6sT9xbuSJBQ23r1d03ml3kZJMHm+YbmfG4TSmVBLhOlq1geb3x3VfPkidGayG6vjBzWUjMsx6v9AVKtzRaT2NVO2+u7GypOer3EN3G5K42bmTsX80kB9/5rAj3wK/V1xfo+y5Hs0dNI8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWVeJZXNNoV6bAtjo+MFK1Fk5voz+QFA1oGI2UOdlOw=;
 b=cd3UModlUx5ZTP1s6pgcl32vWgkWOL72/wbMRKcY/XxFepu9abOKa0sg3OElMmH2kp4XFBE5mgjZZ08NKiOb/uQPjgU8K6V2QZu7cg1dCIDt8xLusecamxREkhCIFrTLDrYMAboXnYy8Ps7/Hq+OkHSUEKULJFNuxgRjumwqRkg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 LV3PR10MB8012.namprd10.prod.outlook.com (2603:10b6:408:28a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.4; Mon, 7 Sep 2026 10:50:34 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v8 00/27] Native SCSI Multipath support
Date: Mon,  7 Sep 2026 10:49:54 +0000
Message-ID: <20260907105021.1763236-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::33) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|LV3PR10MB8012:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dca60ce-859d-49ec-1382-08df0ccdd7cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|10067099003|18002099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	9ic+VUYgZqaiVd2Yz9jwQ7Djh+1nw3IGxdsMiVGyExjDJZbHbxvV7qw0azYIq0Nl8rdjaTDpA8/hrgmtCkqfcqxRw/9VcLhOgF63dcan9afb6CJuWR1gU4EucUB6XM0y4h/hg4Fkf/fz+3wgRGYhIwvEDFHv4RL8yf+ekeD/IgZOT6ou7PWrpIVTZ77weoUhl9dQSfl1F9Ua/oTn5jPtFFWt5EC02UHmjhkBqeD9xH6Iw0O1G/NrbpUQdsKTZQVVVmzDJYdVHENwvpghj7zbaIKgceFF4Rx24em7futSLCPaToe2UyB06H2+V2LGGzX+/MIZzXEp5bEyyQYA2GGNnBBC6iY2Iag3P8SSOB6z4KV4xU1wAm6u8aTXx9yH3rY2t7vtwHETyVkdkY1SRCBH59ajiy3SMZyJNk0WCvAdPc465NbFcodk8Nlp9mMbmw31iRczRLMGo1mSrsWtVXBP7bThhTfAPVVIFKLhh0eCOs5n/psSpqXTjgaa8F6+Y2rtKjQeh4CzCJ+6f/qzDQmQwtjFb9BVQBviGwqVOXjn174sSyS77Hm1blG7GDP+Z2YYNivibiN3Kg91Jdr7PIGBAososq+olnbcS04U0mKqeQYevlOWR3EajhtoPPBmsVF8oHeG0Du6h5K9uIi7wgW1YWVV3RWKDKWRfZyCtG7ui50=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(10067099003)(18002099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E1RQiudeS0oeLinRou9T6MNz7bStvJLoi8Tri/t2r5SbenjS5JTbBQ+DpoWW?=
 =?us-ascii?Q?OWpX4BhXA/3E8loHJinR/KhXwQIpu9tfDFIw/mtzvikVWhVFxTv7neIi7uEK?=
 =?us-ascii?Q?M3kQyTiQ7iBmeDP+uTkwQWehPNaGTAxb002AmOqFshmu7BozFGijYvvfefwM?=
 =?us-ascii?Q?xvt2cZkRX1o83JnpHVFeAI8N/sFeXcCafuLJDZd8n7xvosp++g028JF30D/f?=
 =?us-ascii?Q?BRnGZ562aJKcWaQoDKyZ6xg6jC4DMqpckgIfSTDkO1B1x/oDgsYJxge2KkCt?=
 =?us-ascii?Q?gZYahDD5AjaUi2nYl76OMJR+JKbKrFx8X5DI44NiHyY1PnYfN8XV06VtVlwe?=
 =?us-ascii?Q?xbRZhGVit831OXf4h8beHqrpWplbnEYvje3YU7px0VK9B/0Aau5BltWuuPwI?=
 =?us-ascii?Q?EZDX2z+ApbZTuFri0jAGtGnwFQe7ezgJUwqwG+iOFVdLsCS9+uczwFTS7NrL?=
 =?us-ascii?Q?AHh4tWL9VdK5c9Iv89pZiSp+E9Rp7OwgGbF0gA7Y6ebGdlE7kkVqn6BILD8N?=
 =?us-ascii?Q?u2kKKKLzTQPN2Ri7qoM1EJ8yXbQwKq/xmqkS6EzfImfn6D0pmCgogKpmUgGe?=
 =?us-ascii?Q?Knu7S0e1kVOfkvJKMURXgXnFevaD5WrqS+Ofqfr8eHUYNBRAwjWMQIznl4iA?=
 =?us-ascii?Q?rFH4LGsBx4cLtcI3+t/uGKRzAqIjG093byiNxuObd54J2OOwo3Rw+z9uioTd?=
 =?us-ascii?Q?S5+qLH0IZ7k9r6Q36JpoRS33mlgT4z7/uCcEC7DupC18Te52AvAowrfEElXV?=
 =?us-ascii?Q?nuvvAqoDdiFO1b1coLa7ZkC34C1tmXaGsNgSvIoC27OH//Z3Kztz1kkC8vjR?=
 =?us-ascii?Q?Sd7qrmCe5cBhjfXocDr88Iyay39zWQSZAaiyykI/yXvSUm3zuoDRoQpTBDFo?=
 =?us-ascii?Q?WZ77YiDf92cw9o+3j1VFFmibuYDAeEXX9ck7VPgkjy6EqL4uIrIXwNN00ail?=
 =?us-ascii?Q?nYnf0w/0tskFO981QCcQBvWRDk6JbQIQNsH8U/NkXSv+czwdRJ1XmsFc4nIC?=
 =?us-ascii?Q?fJ64YBrsmAVvBGiqOfyOme13Y7pokmqst4Q9/3GZrw2D90er/Qa0gWx/6gvy?=
 =?us-ascii?Q?C1at64NeJc7MCE0zDKOqgWkYPXsn57bU4tzBtmDUUuMYC+iE8bHqryIL5nha?=
 =?us-ascii?Q?m6CSZxKqnEmlZj0LhRtNpUfgHISRkeyRXc5lLDtmxsimxgxW0K73gBEVXkxf?=
 =?us-ascii?Q?G0/4EMtHIpkTo5DoIK2bYM5eSSGF4dellaJ/EMsezik8pMuCQkfqSIDgiOO+?=
 =?us-ascii?Q?UnCLCp9ky5EJjlKldfQKBtOz+ksmGn/8a7JQgTSqwdBFJe0EeCnb/ENMCRlH?=
 =?us-ascii?Q?vzDHsk+v27oCaAirKumarwH6DMQgWUihsPRSHKngRZ2qjNkqj2wMFXVmZ7/b?=
 =?us-ascii?Q?wtyLTbQbOOdS9F8ceEuhsF3QQnm6nndpOsWdvSRJJeHDVyoiqOEKtVHgIns0?=
 =?us-ascii?Q?n2d1MOcBmYUAgdzLKpR/3G26Tv7l+PBDihT7I26qrmrByrVBQ6nFRjdv7kNq?=
 =?us-ascii?Q?gDzWsjdo1eipRUzxTpX4kF8HY3I/P0NEgBDQWc3r/Z93Wlfwn6icI3xY2STd?=
 =?us-ascii?Q?JyVHF2uXU+weO4ITC9tMGYQbjqDXYqS8BAydwKz9N0Sk3qgX1hgQsw/9cyf8?=
 =?us-ascii?Q?fg3TkABvyQC8k33Jf/zLoJv0aM4UXPXSeqWVJ0TpD2yxZCFFkqy+PhqgI/be?=
 =?us-ascii?Q?w4W1FDEa9ru9nCHtvZi0Aq5l50zK4nDjPb5dmYH+bEXYhOwV0k1aObsXsLIm?=
 =?us-ascii?Q?/bm1qDOYxAJ2k5BRWoyo/yHqj0OsY58=3D?=
X-Exchange-RoutingPolicyChecked:
	Olk1MwbNALJWsp4AlcBBaR5y8MKofYWn7gM0tQSzH9/4oG9/v0v02MvqSbQYsnbd87LrXs/IiutPiK6kQK4heMWEthVaGwi2SHLvwu6Wx74bpn4DPBeDzKIEi5GXr0mnx8VaD6ei1BOaRuK3ry1Hsp5kUSCyPYxh+O5QQZ0sE2YLB1gvVmb1/uAR9MWjR7XjdPxFakmUArZVGw9/8a9ztd+IuiLlqYg/TDAff+/2jGTGIGc2+2LOpRzoTO9mvWYqsK1h6cvYWEKWcrzu5X9VYwYsVS0ZglKVQdPsAi63mItiBeLJ7wk1cTx6ASNWV0OnQwjVW/5NggF38iXof3mfsw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qw3DHqseX+UGZBrBR2jUdjxVO6R6+Q8kafwlTbUq49890ruZJtd5hY8i9qJr2u4UUeaukBeKKLFjQnofgIyspOxySSE5uWz1hGL/OmC4okPGnJxfUfkBjhDtYQLyGGUdZcbMR3caW7c3RXNwJv4f8l27CYBsb1agb2qJ5CnoM2OD9E+VuDttjEHyp+2ClJT5QY84wnerYDg/umGf5eH/QmfTlmaayXQbYOJb0XM7zMLvvwWvQqN0B04hy6mTqd7sq/w0EDqkklA/3sTxTyiVhMX7tW57p9Zol8iNTOv5sthgQvPEMMRxJnm3+pxTiIxGrL02Kt1x12ZKJwPXTNwl86TXY9YswLf+Xo7sZljbNFUCpWJF3cmUQWGwUZc8HkKP4DYKWgt8OS9ADTnbahx2MbfMm1oO181i1bJu+YzAOH/+WFupIn01MOlURWvX526kQq1m+uxcDhTvI0zACvEXqVQJwqPlY2GzHOYZUbCTvB3SxQJrkbhRxUExvFBg69oo0Nyx9uOuY9k1TKPax1mxoXAi3XfnaHPHMAr9ukuLo2Xrp3cKR3+bLt2Y3ah3cSCYKmRrsdHUYVwqpGfh0nrOT0lVkz9jUZ9cm+/k79W05KY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dca60ce-859d-49ec-1382-08df0ccdd7cf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:34.0247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YclW33AczLymC4UtPB8LPbm0x0pTa09xTP1vXaLQ97J6VrThPWt9uio9YmHb9YpVZFV1G4btX9Df4MEKmTL5Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=EuDiaycA c=1 sm=1 tr=0 ts=6a9e973b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8
 a=tPCbtmrUit6F0t18becA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX8qppof4wse/O
 AmbF3kwfxhFq9ZVWdlPi3NASBCd+7mhKIW4poiE5WwQ+8PCRqS9ouVN+RF8fHCqHWklx588i8Mz
 udm7Xq4mUNmEMIpkZxBtpuHTOitU45NGE0nj40fG6ncqVVvoqv/i
X-Proofpoint-GUID: Y9yLhAo0EIFEBLHwt5pt0GT0KD3lpaDc
X-Proofpoint-ORIG-GUID: Y9yLhAo0EIFEBLHwt5pt0GT0KD3lpaDc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX+gZkLt18zD8u
 HdrEMsRQCYd5CFeRuTlU/EGpd/Np4vn/j77l8AQIuNRkCEGGHOVmudI1yLvxJXK2by80f9fTL+S
 WwmPkdoAH+4j2iolCHslYeRo7FSc2OcUDRwXLUeP4E+NEE8rwXlCAoBRs9WL+I4RMm4C8H6qxqg
 7c9VGQKaH+e7L64smnbTlCuwQE3Qm5fuGXtMs5jX51lG8IjZlwsjplntjhJN0yt4380I/P75ddb
 faOV94mLF5POTfc+fmwEJROe0ARK+NqWpGIh5A7BcotiC84lERaHqIB7Gu86Z4x7rdlamffIvJ5
 qKAsGIXpZpz3/TSmlcEqJfphM8L0h0NdRMYaFL+XcVW5iMw9PQKS/MHUWPpGSAlOFOOfmUoLyrb
 hv3a0J9MnNOU4MdDYNLTSUF8/Ge0L7b7Y7/NAl+0TO4MZsCNoFz2QEzTJwhir47jhoqMF9+2Rl4
 hNrMLsIMF4eHdk3qnOA==

NATIVE SCSI MULTIPATH:

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series relies on reading sdev->access_state to get path information.
This path information would be provided by ALUA. ALUA support which does
not rely on device handlers has already been discussed at
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
and support will be added in the next phase.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full (for failover errors).

LIBMULTIPATH:

This series introduces also libmultipath. It is essentially a refactoring
of NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
-may provide callbacks for driver specifics, like ANA support for NVMe.

Important new structures introduced include:

- mpath_head
These contain much of the multipath-specific functionality from
nvme_ns_head, including a pointer to the gendisk structure and
a path SRCU-based array.

- mpath_device
This is the per-path structure, and contains much the same
multipath-specific functionality in nvme_ns

libmultipath provides functionality for path management, path selection,
data path, and failover handling.

Full series also available at
https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.3-v8/

Differences to v7:
- rebase
- simplify scsi_mpath_clone_end_io() (sashiko)
- rename bio_list_add_clone() -> bio_list_add_master()
- rework checks in mpath_alloc_disk_head() (sashiko)

Differences to v6:
- rebase
- add scsi_mpath_get_head()

Differences to v5:
- deal with issues sashiko found in libmultipath:
 - include wait_bit.h
 - don't store error in mpath_head->disk
 - use check_mul_overflow() in mpath_can_remove_head()
 - use -ENOTTY in mpath_bdev_ioctl()
- deal with issues sashiko found in scsi mpath support:
 - check 0 returned from scsi_vpd_lun_id()
 - call flush_work() in scsi_mpath_device_iopolicy_store()
 - clear SCMD_MPATH_IO_STATS for !bio in scsi_mpath_start_request()
 - add checks for calling scsi_mpath_{start,end}_request()
 - tweak sd_mpath_dev_show()

John Garry (27):
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add delayed removal support
  libmultipath: Add sysfs helpers
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when device is blocked
  scsi-multipath: revalidate paths upon device unblock
  scsi-multipath: failover handling
  scsi-multipath: provide callbacks for path state
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: add delayed disk removal support
  scsi: sd: add multipath disk class
  scsi: sd: add multipath disk attr groups
  scsi: sd: support multipath disk
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_lib.c       |  13 +-
 drivers/scsi/scsi_multipath.c | 664 ++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 611 +++++++++++++++++++++-
 drivers/scsi/sd.h             |   3 +
 include/linux/multipath.h     | 156 ++++++
 include/scsi/scsi_cmnd.h      |   9 +-
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   4 +
 include/scsi/scsi_host.h      |   4 +
 include/scsi/scsi_multipath.h | 124 +++++
 lib/Kconfig                   |   6 +
 lib/Makefile                  |   2 +
 lib/multipath.c               | 947 ++++++++++++++++++++++++++++++++++
 18 files changed, 2554 insertions(+), 24 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/linux/multipath.h
 create mode 100644 include/scsi/scsi_multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.7

