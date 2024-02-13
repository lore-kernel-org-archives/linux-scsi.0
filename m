Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49250225A4;
	Tue, 13 Feb 2024 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707834527; cv=fail; b=TU2zIRxuFjeOjRSelDbdDCnYeSFTXuQCsAzUNHsFsdG1QsCDggokVS0pbU048yBSNJ8s3RkvHMUEKaxxIFHVuNcogK1DTAQK2fZwYOqotUjwHXcc6AO5OpJScYWRWhWuzjV0tcRL4nEvAZSHXBM48bHpFak1D7mTM2Mte+XTzrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707834527; c=relaxed/simple;
	bh=JksV2ATiA+JI8c/uivXCrEFHDs85RoI3hOiJjR/9Jo4=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=ifV10luyseMwZlArXemjIkiA+hbHNlrkX4aDkyt04bDDJIWfX+4+20wb87rmliz6yqMIQvxdoiRFP0cQIAC5DldmhRHNkDKy9Xhs4cu7nYtMPt8Zl5D4SdJLKFvvBAnRBx21lHAio7HisGnNx7PvHRzgm6n5YVQSKYrbFzG8ytA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UKBBv605; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p1b9fJGj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UKBBv605";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p1b9fJGj"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41DDmvuB013855;
	Tue, 13 Feb 2024 14:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=Vnr3qGiBSfICf5aKi70TBZm9IJIzcLni88Hzq+DOOsI=;
 b=UKBBv605D8kMPyzOI8ojf1cIUVYPfwIuLrM6MW68C7lt0+doU3qE1QT1wntSApZGQI9s
 GR1m1vGaOVUOzuXf6x5wzoacWwlgJYgWQL94aTFuwPi3f63JTh79ehaiHdEwGJ0j1qwJ
 dsYr/QEExNSII3PmttFKzQUCrzvWHgBxTeG9ZCAhmNGBYaBbS0HvgLv9f4HQiEYq5Gxx
 +ln+adqCaNiTDxeQcrVcmHS+JvAUAU0/yDp8IzKBdQ0375nNkKW3ADfBp5GBDDzjINLJ
 iNdC3BFHg+5NUk+HfX78/K5YC9oOq651E2ZjjCbl6LjKnq/Cw2yRDBKqHZLys0Avz2W6 6w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w894kr5sh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 14:28:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41DDqunc014927;
	Tue, 13 Feb 2024 14:28:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yk7553k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 14:28:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6aZr2kc0g1QwxRE42/9Xkd4dNjYmGK/r8j/ebYYuCsGZ2KZKjDf5h6+Yo8Xekfe4xqlcaiAtqGJPhsZNuhs0LebtP0/fRRH/Yp8lbgSBfzN307nNenpinmjts1Eahqih8FwJ+i4SSTsz6Eg41Shswlon6DwA6R8EeAxYuLoJ/Hd1pJ9Lzw0eOrEz0CSmNIxgSmnKgdWQPMXXpVlbdKDAa4jxF8R4PTT2aBIL1NtJZRn37fpJWiT1OUPOF+sK3XV7ry6UsvWJpc8IZS8JJdAwQGRh6p9ru8QbFni4ZeecBl0d9gh3pdc3L1QeT/Ozg4xtDdNnmgU/JoK+UAmaOIURg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vnr3qGiBSfICf5aKi70TBZm9IJIzcLni88Hzq+DOOsI=;
 b=UIn71oz5hmFcZE4z23rjKAk/KwfEDszBmgtLk9PTi+pNR1cThSbb++b5H/cG5/XznCqARYlyZ9tafC0A68QcUyPDAzasyyqdnOQVo0T27e57waLvbBTSDwV1S0e0qA0cVkdlWdmpiAo7S7DkVQPX1M/VBMNCXRj3h8Fy3d3xhGsp7/iyG70T+XPOKB+z6/NgmfIZc91CQvaMk98fyOAZfvG56+xVCqHU9cdvwm5sjJOahKikRaLkodOkUQ1qp3m6lmzJIXb8kDgmJr5XihDDaYiFkiqeSVM7T76Gjenx/3BQzJcoHUEnglZ7NRFKesKm6AdbRszaRPLDMwCMunp1Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vnr3qGiBSfICf5aKi70TBZm9IJIzcLni88Hzq+DOOsI=;
 b=p1b9fJGjWGyekUmk6CQSCT4UeFvYfPcGWD0XjAWKtkv/bxnmaRwedX+RwqYDSBxkkgAnTO5DAr1Hrjf0/nnoaYlpd4biE0vBrqRO1w9fp46GZ74XfU+J5ArZ2uOfpUgWDWa+tZFmrPDnO7JqgTmlAZkG0BPqjLion7FyyFfe3RE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4332.namprd10.prod.outlook.com (2603:10b6:5:220::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39; Tue, 13 Feb
 2024 14:28:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79%4]) with mapi id 15.20.7270.036; Tue, 13 Feb 2024
 14:28:37 +0000
To: Julian Sikorski <belegdol@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-storage: Ignore UAS for LaCie Rugged FW USB3
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bk8kl9th.fsf@ca-mkp.ca.oracle.com>
References: <20240209151121.1004985-1-tasos@tasossah.com>
	<b16e72ad-3f2d-46a8-8361-2641088694df@rowland.harvard.edu>
	<2978efa3-e83f-4ef5-907d-8232e4b692a5@tasossah.com>
	<6d4b1f55-09df-47e9-945d-fa38cd36588c@gmail.com>
	<b6dcf71b-f094-4664-8d43-7d8c0173f51f@gmail.com>
	<c21f9649-30be-462a-b9ec-f7c96ead30cf@gmail.com>
	<0cf5ea13-6472-47e1-a32f-b9f332656c6a@gmail.com>
Date: Tue, 13 Feb 2024 09:28:34 -0500
In-Reply-To: <0cf5ea13-6472-47e1-a32f-b9f332656c6a@gmail.com> (Julian
	Sikorski's message of "Tue, 13 Feb 2024 14:06:30 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4332:EE_
X-MS-Office365-Filtering-Correlation-Id: fca6cdf3-3af8-4fd4-649b-08dc2ca0111e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	RU4oI53W3hZdDoXBX7cLjU8U6EwDnq3hfjWYOQM8+dh/Ft5TeE4ANstZN+a0Z0S977sQ/3ZVdnlaJVZW4Vb1gsn8MK+YeLyiEOuSZuSQ2MJrj+AxEKcJSjzXyr4Ts2L//ncTX1ETYbpXgm7Mo0owl8M4eo0jr5HkpZRpcTk5JyXx4Itoccis1pxeEL+kbtQoqLts8krg+f2h3i1E+rI6sIpup29yeuCGprrctnD/ME+XyBB496QRDHT6e+WaTJVQvrJTlYBlclI9AbRFQXrHiIMrqCiSUbP01C9m+SbxaOT0OXRwBgywglRaqzoGH70RRpU7bYEnUj7m8+IaMqdkW2Mv+A4Q0m7QUs8Iup9b2+ilA9Ftakni7p6LOrc7ONXIKCR968cY/N5LMR15oDbMEG/D7CM+wtd7emzkK1u1n8PsqxCzS8M2ZvcFOYz7eIb455GFbB98E0RennjHMD4ctVX+rluRsQSxg4yuf/dz+3P1L76jKACAWwqcgJ0yazxDnrMzZH9mQBfq7D2ee1+XuUc6zf5e1Vr5scQdFKNSxFMXUs+vIuAHhErlwNrWJytk
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(6029001)(346002)(396003)(136003)(39860400002)(366004)(376002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(6512007)(8936002)(41300700001)(478600001)(36916002)(66946007)(66556008)(6506007)(6486002)(5660300002)(66476007)(4326008)(6916009)(8676002)(26005)(6666004)(316002)(558084003)(86362001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?N/SPdzF+M2KAcTzF7EWu4xvlojA1cwuWJbc4NYLgxoYz6MPCmFd3tr7N1VoB?=
 =?us-ascii?Q?N3OL7qj2sl7uhxM1iA34HAIXsf3AMYWZ1I5fzdQfpPSGaruPPZF/tuPuWlmZ?=
 =?us-ascii?Q?MfiXlFXlJ85Z+e5IGSSmnZjnR+6iC1AqVEoGYyy5grmZYTL9AlorWS+gtQSd?=
 =?us-ascii?Q?Hz/x6yvpPglQqMl7bDGmsemnY4SicQDwFHCnG/KPgvBN3OU/UhxkCFqOQnDc?=
 =?us-ascii?Q?tj21cWH9NSzSdeXcMkPrI7PxfXYcrxCOG8MXZDa/QI99lSikYmWkRO50Ed1u?=
 =?us-ascii?Q?TdGWNbfDp4+cHRQTfml5f/q/ulN8cFH/Z+850hph4KDGmcHOaRSrHsgngEEC?=
 =?us-ascii?Q?kK7XBdbkQPolVEletUpO/wury9VDuy5Ey09tlpxhgbbqHenSjuGDTJOErt9g?=
 =?us-ascii?Q?ByXwpgCgBHN+GUVeqKEqlWd+2UAEHpu7E+nHw2TqdFJUmTfk+vbq1o6V1jvL?=
 =?us-ascii?Q?QzOBMwiUm3UqF/H7uBVaF5ilU0YYlXcQsZy+HF00p5twuvNTCp+uw9PsCVIC?=
 =?us-ascii?Q?xrTlsLn4IiMNUcqQ5qYp+XG+ThtXODLoffENvuR+w2dkoW+LS4OqUCu2yuxF?=
 =?us-ascii?Q?/NS2Be8pltrA2vrr+Lco8Kr1nDt+yJSPo1bsn6YOCAByJloW9JuIStmLRQLI?=
 =?us-ascii?Q?Chhr2EVrCsP76AtRpJKPlAH1VwMS6ius+rwqi7t4hVoen15f0eMvzIWISMUI?=
 =?us-ascii?Q?rHqKvXzNsdz+2F3Cxrq5+EP4xYxs4QLh//voBgg4EXr4nSEVsde4RAodS3KQ?=
 =?us-ascii?Q?JU9d9tJhNMndBzM05U7rpvLIVUsPFkMoemhcYcIgHzcDeBoL9Mtzye6GrXX1?=
 =?us-ascii?Q?FJ5EdOPNSdvDOot4/OPrVXaFfyzn0BdsAiTV2V9LA6tQsYam1fRXNFoarxzX?=
 =?us-ascii?Q?fxC/4hMabZ58kQgkxUn4H6jaij1kQYflnimps6MwMZJecdNRG6PJMJ4gSI+c?=
 =?us-ascii?Q?NqZxJxjCcgdPIttP9X0cDPThnWbwSU3OVtBnXM7RBPAEoB3c2JffOs74nO5S?=
 =?us-ascii?Q?i9j2MdPehc6yB2Z1rRZ9f5Pk4AFkT2MGvhHVcbOpldq3mE7/1wPPshWwrMh9?=
 =?us-ascii?Q?B8MTQg/WfMm+j+Y9QzxkV6SE+ooT+eHpNs1LfvNYX0Oz5BAy6fzp0oe2NBe7?=
 =?us-ascii?Q?0fEYpxIoeE19RnIfwLjsnv/0Oct1jbOAQDfcgRWGXmOYVlmOwsFp9M5+OKCa?=
 =?us-ascii?Q?uS83E8Q1/T7W4DsX3NkX2PJ+PcKgj7TeXZdbH5FYsMKEVFXFFg/yabxf5MTh?=
 =?us-ascii?Q?UtpyUUw1cqNPodLvtKfH/J6qNlUetCEUfoFnoCxvgS3E9INiH3UTM7GTdbJ5?=
 =?us-ascii?Q?u2uXF69QEjclvbUep0/74LdwG3ciVafDX68cNUV9bqFkg4AsfMkC0nynWX0N?=
 =?us-ascii?Q?IK3d0MOB+XwmPz8vFOZDdU8Kc7e+Cq+jgL9iINMY7bMVZbvmDi+5fcEWKjfl?=
 =?us-ascii?Q?5DTlTHNqxE5nm4W2+oWZ2YlRcNMpws84tl1ziBsaxqBn0/fQSFFiXes+80uu?=
 =?us-ascii?Q?UHV19T53atOGQL+rpV4FuDGs7RXFZ9RGiRU3lI4amQCLZ9qhrl21sgQa3Xlx?=
 =?us-ascii?Q?x+nxO8IsbZmGf+eCes8cboVbneO+qo7CcfHeF7xfsphcKQhmTqVubOr68Loh?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	AxsHQxBg7M+yd0axWiL8+CLhe5Dqp56mRcBzMEbDk4IVmmrAwW+wJ9NCte80O3PIqsb4AHnbFyJpFMUN6sgNTjD0wkMliclF33z79cG/NKY4OSiAKvK6TesppBIPGauFvlhB6wmicPW8J+6w5Vv7f1OQMQ+qrmla2fSxuWjhGNjmvDBrbafTGTGG3jAm9IsRUnjigetVk+CBH+wCFARqrVyJjKT6P9CJPH+qCIzAx0dz+/dCSCJvBcOXDK8mZEICUvvaAdyldPz6JOunwu44lFCHmvL6z5eiWqk0mrXLxmw6ccEE4EON/NzZmcbI7wLmg9VHKIxTunRukbPol4JvMpLKpLzl9dEfVbuqgrd7fKkjTYRX0mIeuBa4eDb9n0r973Qv0sNB8eoGJUYLMWUIBXbwgKXIrlaFApAL5QTKccwQRayf+LiG6WgvKmLCmzRMFsTTKe5LjiqFbeE+OjVYAIIjtcBfc5YGogxHw6dCQwNFX9joZNfOtXMmS+xWVH9wg36SSUYQvmX0d1SKasHjrUN7f1s5r6rXvXF2dkCxU59gaLO2u1nDSAWZPZA9quhWJHZQ8Jo3HHfPQnx76duiMXKHvdKWcQTRdra6ofkDXfo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca6cdf3-3af8-4fd4-649b-08dc2ca0111e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 14:28:37.4864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztQvH9e2NBK1ukogvaXhisbahsPGKm54RaaFSTpc6YpV66CO5P8Tpuc1UViFS1cUQFnkU2kakpsXPvqdRWtvuJPmU/g0Gr5chi/zJ7Md4x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4332
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-13_08,2024-02-12_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=511 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402130115
X-Proofpoint-GUID: ZBVSh7rs2k2I7mJdQYBFBDCjWG3WhHCg
X-Proofpoint-ORIG-GUID: ZBVSh7rs2k2I7mJdQYBFBDCjWG3WhHCg


Julian,

> I am cross-posting this to scsi list, maybe someone there would be
> able to understand what is going on.

I'm going to copy you on a patch I have in my development tree. I would
appreciate if you could try that out.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
