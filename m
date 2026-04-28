Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393D13FE37E;
	Tue, 28 Apr 2026 11:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374845; cv=fail; b=D9i0lTnBq4aN2kUAcj5YAIGxSBqsDAeY8qLbYT4rGg8dmVUxbzLzyiSA47N/SisAxOa18gCL8bc+UL0AMAnOXuTTkBreFqkUeu7Zn/P6Hax45BhgzHGev5UutlItac7GBW9FcF1WK1J/2OUKaeqrh788oQYbylfDAXA4d9T8tWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374845; c=relaxed/simple;
	bh=0EGo69nmzQyr5Bgs2Nhnd7cuEVwK5Bd67wDiVLNeEls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HamRA/KSk8tbo7Q8SNS3HZqJMSD8VgBwbAa6fpseGo413xhkQn1p+ziBCAilvSfQyXMvzuOwVrsI9Xso18muXx3SXKD16W00BAIgETJFGcBr7mN3f279jr5fqICE/+09KKvNHbf6fP7wXecwkx6bizOZZVKlri4ZMPhEkmgY1VY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=olpQTv5M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bAoeLFfo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="olpQTv5M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bAoeLFfo"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAIeI21905229;
	Tue, 28 Apr 2026 11:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=c0ErrnOmpYY6VXFswoaSWbYMpIaWVrz27AbwLV7Am9c=; b=
	olpQTv5M1IiZ3q/y74UPfEnxcHrygDvuGfKvFVlm+sERuE82bzx2ScK7kN8Zp6Zr
	4jqQNFDpVNAdlnGZpNfajMqAlA+ONj4gaWoLI//yC/oWEO0KMw5rNKs7pxtYCsli
	9W6KPQkQpZoEtvU4d4u2Mk07L0iyJ4z56PQvPf56ayRCqVL2Yh45ttoAyoN7zygX
	xUmrQBgFkeWsR/TyRh9uxKHkOOl5CZTTSlazs3M70ZfrZVX25N1YIOUkrIY/3LLK
	35E/NN7ocokzc27OFoMwESDj+Pze02AVlM7+c1aVI/MBzKv1hj72/V2pShxV7+is
	KpFMSr8awdToWE2odeiiGg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drng8fcr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCJKV033104;
	Tue, 28 Apr 2026 11:13:24 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010027.outbound.protection.outlook.com [52.101.46.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cufg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/H4DHzzhoGAYFYZ+bw9Uip7w08fXOb0AHxC/iBlxEJSB7nxOP+mCKr1o4+EuV3otlBX0C6zxXf4bl8jPmBrlXYjvNSRNbn2NobmZWbtSkx72mbmmwK/hIb/Q0R+BCM/6KxiGG4kPcb5IdAWGIaq9ukcdMlmbrm0lT2kikXTQXerw2RniVloaxWFRLiWB83mkNAjQIo16D9pxvAKo3/6o+TBzF1/dTKdGbFITvW2cfa+R5eVdHXhj6U9f62xjYPBj6bWh4JN+oULYidld2fe5m+czvanrJ3jNJOrthHBwiTlVloO/6lALRdWd//OJOqBB/El68Z2GuZStUIiev0C/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0ErrnOmpYY6VXFswoaSWbYMpIaWVrz27AbwLV7Am9c=;
 b=amujeAhj6FqI/6jt9xEcYcQhE3WKJmeH0ce2wRxgKg4JYUUCQ7V6fk1wAnVI7GTq+8r0bzGqRtaCqf9dr4XaRW1VTUr4a5wcG0zbpo/PWnXUZIM67PzzE/1ZE98cwTBhYfhj6ba0yX4EO/hi8rlrhUh24FIo11seee0o9HGtek/0AZcVX47T70bUC7nY87bH9FFxNfJWH0XoSn59IG/psz/4OdSShNrZFc+WfDdFXOHVEKkK1rkYkMOQE9T6eHwECQHIuRpA3cOVFBkT7V/IlQzih4fQ2K6VPlEm52nUpVDNUjvNVoPoywyH0ldnnoHgMHYhd9qQiDIiEJM3KOFRNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0ErrnOmpYY6VXFswoaSWbYMpIaWVrz27AbwLV7Am9c=;
 b=bAoeLFfoUY/6Zx8C/K0TFom85hdGmdfC4XmYK5s5Al2xrTNVC0EbFoNaAlWsykseDMVEulalnmJSn9UuwZv8bnEi3JXIvAtCxG2B4xwk0RglHQAlGcEQG9HyXLLwNFVYLjd+cGIAVxrNoz9ovgOpKG02PiIJbnpeqGtt9Cs9DhU=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:19 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 09/13] nvme-multipath: add nvme_mpath_synchronize()
Date: Tue, 28 Apr 2026 11:12:52 +0000
Message-ID: <20260428111256.1778475-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:510:324::19) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 140e7a00-7b4e-430b-115f-08dea51726dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	HE85oNHns/s+vWoRQpUm7XQnoiOfRnm00OkSz3w8QoZr1cKM19U3zgdPEeqU/avfnHW26A3c1ib5ADI2+jWmhS+dAq/eYLXclR9PdyvLkcIb0dkcR1KbhAT9rlZqAcVOx/KtWjAJpmSeL/vwBHB38+vsDZZjgSA6Tc63gXhwNF04D+P/naJM7jaijEnxXHtSyzvLPXZGooZ8HVTeEZo8USlZkQR7x//dxafa55CNdzUPx4nqEmrycwf0jdWDbI/VKHe+U6IO7qN7/J/ocGTCFS8/vFGjHYA7Q1vyZX4IyWO+7ePjqI38rh38MBJFp2Yi/7+0tEN0edv+LJbdVafvk9Yh+dXEPTBoYSlo3kgGQqAHn1PXk2k3COVEwWS6RF+7aBIOWXcorr/rWyekpXwtDap3z8UwVyao34xZGHi6ygx5zh7dss8Kf6lC5mX1YsLmPr/zu5kdGquUSfFTNV3jS7ntv4EGXSt0RmGB9DSjd165uvMNgZu6vgCsy7kAbVQTn63fEZsdUA411mM5iwVkvfc4te1LsryInM7i91jGBOwqs5z7oMLiKDU7wKbz+YEH1p2vmBCi3XZ+l9uITDswniOgCyf0ujHW0QpulxokixiLzdoP9T0lnR89Xkj/coO8IvoSEqfvT/BPQPhh14CTHwZBCHrewczr0hUt1jRZLXk2f76PzlqbwlnMo3dbWa5nrcuMw4b0AVccEZmg0A+MlyJ8dMQ2U6ZJGZZWBgxgAKE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z9n4PymzpsNmrRPDUMqBwemVaF3RKVGyCrC3qlcqkPJLF9uLsr9g+1svVrG/?=
 =?us-ascii?Q?sXCp+ofsdW9BXmiUM27K472bcCb3cBbxuUX0Av7E3By8MZsqyharl4jq62qh?=
 =?us-ascii?Q?D7UnsrfivEYaVEPxkdYsksWS69AHQW5RpSd3B1ftd2IY7ieI+Sk2bGIWUkqq?=
 =?us-ascii?Q?wp8UE+R6eseRzZHZ60TddvqQsYY6QlzoD3oP9KmXOfkLqmbcFQyBVGblgHPj?=
 =?us-ascii?Q?WND1ayiHJg6hl/MRh4gobPqxHxGWhZ+6PAJjWL7DwaAkyGEWUeQLW3AZCs1P?=
 =?us-ascii?Q?1VwGdIamy4hLkU5BcinbzdHM0nyz4G3jgr/X8mPfvRn2+gksk0E1YEqo9YYo?=
 =?us-ascii?Q?k9AKlGi074iv4uHM9YV0dqp0e/wZw+i2RGt5mMIyPjzmMWAvQk4YU5JO9nZI?=
 =?us-ascii?Q?3vKRy5YqDdgaj28EXpRCkaBlaAVsaT7CArVsh8LvsOng3SqV31BeNb6jwJg5?=
 =?us-ascii?Q?o7p9vovCaWbplkWDrTP6gSPy96kvCDtd1itpGRE6rLu7x0z0ii8bUwj2rxW5?=
 =?us-ascii?Q?nhbI84+IFnhf2dLKnSksdua5N8xOkPZMy3MVOVis7J8oisfCuV+BIMIjFcck?=
 =?us-ascii?Q?CtTS0swNKxTPvXu/c5SEsmjCE1o5TRhS8Zm+C99RuEOKSoTUwr8mxi8AyVx1?=
 =?us-ascii?Q?jxjJMhUtCEpWGadw1xTKhldyxUYd3V++oX0TZV7+LMxcrgOthoZMc+T9CSYY?=
 =?us-ascii?Q?VFp4uDLnaKdamfbVjW7mapSKAfUh/KgCF1pUeyP3UsigZKBwwjCJiju7LT/h?=
 =?us-ascii?Q?q8SoRU36TNXblFSwrjvWK2CYqAc9bLk+wAUDOiRaERQBKGqOMc174qZppfIV?=
 =?us-ascii?Q?8qZH5XMbTF72sjHych6BEosYtGQlHA+vXBMQ0BAq1UvcNKDir0RlziPgnpCW?=
 =?us-ascii?Q?J5yiNUyad5q4w82hoNzJJ0bl7qCIyxMgaI0hMTXw063FlsQL06yNHx9uzMCk?=
 =?us-ascii?Q?Kq/G12pDm7YRBNjT9siv+nADRWnI8C/9AGaimJWKz5TICRBz8mx5I6xEXtAA?=
 =?us-ascii?Q?n4TLrff+vTmkF+nSpWlj2+6Eipq0ezDxldjAvcrJ067sMSTHP0U6wiE6Zedr?=
 =?us-ascii?Q?244Gx+EypxB27SEz7zaU16bwoM3CzdyvVNd97IOitTL+7dJONqm5CnUR2ZQE?=
 =?us-ascii?Q?p5BS5Tm03hmyYYLKROc0qfZyTMPMCGpTpE5nKIuGN6YxyTHepf+MzebnjLMQ?=
 =?us-ascii?Q?wMW/igjvbZ28mzz0EgiDgOR6zlUxjWA0mcGvagb7eQ8KM3eMBKLKchHdcWwZ?=
 =?us-ascii?Q?w/izlCOLhihDKb6r/W+wbiEcGDAqlesfkJL0QTbegLACt5ktJvoW7TzE7dO9?=
 =?us-ascii?Q?1+6KxU+0AiD5aAo91hZAaTDmDiO+cwIboDigXgl2hbO9GCx8VYxrlesPEELz?=
 =?us-ascii?Q?L1GABJmMrO8amlBVGOOM902r8ewIbiOIUL+yuke6Vu41wlRugrwaFJODIKsR?=
 =?us-ascii?Q?rXhwpoGI/qTNq+JmfpTdLE8+Qyd6q+bz8jUiBWAx4rpiz7OwjLt5+K/nwTj0?=
 =?us-ascii?Q?fddf+7swOftGV/G5CvZhFZXB/i7fHD1O/fFaqyAUS7Kmns+hIcMiuwCKcL+t?=
 =?us-ascii?Q?dEmY2Hgh+gesI1eVdln/EokbvMKVDeYv41mshiC/G6Gt5N2i+Lc+1seiMyeK?=
 =?us-ascii?Q?G0OBGActcHu+UH3fXdNhkd8F/5CnLNUlCQd0ElaeaCg26phtZzd+1XAG/GG1?=
 =?us-ascii?Q?lwC4Px/SmQoT7oTpVIHW7vzpIL/XL/g2TvCwIbmzF5Cr6mFfaKjoEkzl0Yf3?=
 =?us-ascii?Q?nLllI/h+mF7/AURXGxj4k1w7y5X7hlA=3D?=
X-Exchange-RoutingPolicyChecked:
	jTcXG59svKgRyvrXeGRyJOiypYGG7TPezQiTUfgBl7dtefMzezIRAkPR9ITwO1bfkIAUpPMo0H00qpjayn5tXxfG7M7d2V+I4D6/YqTfb/al2xH85CqgBKGEjy2+G0YrvUCu7ugcwipC++feLfBshnuya0N+RnXhCESq9iPz2bITVgVNdyfs8QvQtrT/7H5yYeE27FauDaKSaoutDpfMVFwa5Nu109JTwqBP7grBzDYOsltB4f9y3PiVBz76HdP46UTzG1ZA7QJ1jdf8fy2bSed7qF+27ckhSvpscdfj9PwlllsC70Tt0JoQHi2g7BQJk9WWiF51bZ9TWAdirzTNQw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GfHB5uYkb6VOBDgrTuD/gRFPiWQ4WdVIgNIVpxaF6QjStqWzTDOu/NjNPrVbrZ0sHZ6NnRcsClK+3xhweLEW1zSffBOwtnd6YxzJxGZUKq9elDmrO2HnAVpdHF0PVuI3UZZ7bgoHMkq1eufJ6gMwIVMYvldxZNJkp5mt5jvOVKjod5Aj7nqa9Gm81o4djmla2vUlnsAITUFfGf88yDUUqR2VeMMaT39lJ1GAfkKRQBIxF14tww41RcZROtInYtHtbyJuQTYMohovLmFd3XG0dVbFau3MbDY/JYjA0CQuNqqLhEwZF1mSjm2C1u6odOKVxTQMWFbbwRsoIwpyeNnA1RiW696t9VgQpPI72rDPvJ09XbdPQSyhiXdvZBj4hcGm6Ighy5XJ6ye6ndEKHMQuEOLcrhUmT7A+XbOxs+p06cEiKDEh/9/i2VNAg8iwn5gVtHN5kTl7DIHZZJDw5lHmWl12n65lrPa/9v03z+Fob2ytJQDbjhVsOYdr1UgYejuHKoQpCRNK+FvEBsGFftLUS3qSnT5p6XuEoDZD4F7QdnZDWrd4MFosk9oDGlsqinxM9ufmJ6floyYxn8ot8nkCcGRgzrDOCPA/7DYl9XVpm5U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 140e7a00-7b4e-430b-115f-08dea51726dd
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:18.9314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06gvbNjOxjV3yWyziID4J5gDBxQ7u0IxO2WtI5vV6HckkO0CBgDKdV6SJKEH6mR9/Ir0HD3dmyLyMN03EDJeTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Authority-Analysis: v=2.4 cv=U7uiy+ru c=1 sm=1 tr=0 ts=69f09654 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=Aed8ZSgTGLsvUS2N6I8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX6u3VyFtqZhTX
 A8l4IQ9b+wt4UikNFbysncVfex/8zS8obRJkj06+tyHg9SCQBFmZYEC2lpU8+jw/6iwDmQzKLkB
 HwpQ/Rh6/EEQY9BD76eaguvB5dpBTcvXnJ5lSO1A9o8OTqebWkxBb0xZN/0y+57IHE/0hpYsaEW
 knL5anmKdgadgoFY9HZSdpAuYxQOTFP2dUmNxRdPZQIKAWd7bQG20qGhrmD32KCfJNvKMTeV6zE
 rmt/AUGNRbjYi+KA6aWqYv+jl3O37ychgvZuQRMQ9sL4pCgwhi/KBshilsIkdRkO341gaAOniqm
 0sEhGw4aBoNMjUTGiVjeEqNzm2fyVkncRnmjsmWoNn6mewL7xXFE77DQVBHkkYR56OQQ4r243uw
 ffWfxq1NME8CWiFFpHrUDkGGNzTFAYKGwgqtY+COdPu8Q+xIGB7hwhd5UPZEXxj55mHSUlXznMi
 DgvxAhHn17o0YSi1sdg==
X-Proofpoint-GUID: sxo5bUO65MuG0-dOuWZ8iTqDRvh6teyU
X-Proofpoint-ORIG-GUID: sxo5bUO65MuG0-dOuWZ8iTqDRvh6teyU

Add a wrapper which calls into mpath_synchronize.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/nvme.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 01a7a25bcd254..cc63ed8131c36 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1062,6 +1062,11 @@ void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
 			unsigned int cmd, void **opaque);
 void nvme_mpath_ioctl_finish(void *opaque);
 
+static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
+{
+	mpath_synchronize(head->mpath_head);
+}
+
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
@@ -1094,6 +1099,9 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 {
 	return false;
 }
+static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
+{
+}
 static inline void nvme_failover_req(struct request *req)
 {
 }
-- 
2.43.5

