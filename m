Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE422989B0;
	Fri, 27 Mar 2026 20:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774643475; cv=fail; b=pVTKe9qf2+BD/uJAXMP7eCenNYDRctm4LtZGepsNioEiKXWLvqd40hdCuN1UH7seGEv1syVigDAp5SKQwNFYoFIxJjzcSOQWcifMJ3ui10OPdky21f8vRybNw6YXQkhzauCdL2Drvw4jOs+HKPS8jrNKjgprO5JXufJLPLQw7vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774643475; c=relaxed/simple;
	bh=mng7BoB0ns41qPOniM9208VtPnBul6DSLPppYeXTuOQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JtY5JMk2qnBxYm7zc26t8PFg7IYGGbFSD/R0A8J1sMY+tgUkhSro4BuKi2Wsz96BiU9y0/WLgl4YT5Oy6y8sklJjjfKJ839CbOKSnZWtZvyEv43rYNvIn/Omp85+TIunRGvLdq0q9JH6mmoqMzSMg2uQpwIO+uCOc1ddyCYgRfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RzVxwWiU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pb7uzm0r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RzVxwWiU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pb7uzm0r"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RGuJPd239329;
	Fri, 27 Mar 2026 20:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n0VI8lO0kEbiI7cp8B
	ouk8TTpfg+1OLOvEsPD4eToD4=; b=RzVxwWiUuoPfMXRjdj7MXg5sSybkcS3rLG
	659+avzLqVGwDQbz/uPoHg/usU1ZQBSmew8KC5CD/Iku+Jf2Xq2fe4eMfsKnzEHu
	DQXHxw1EeMwsMupmkX5mya51qrqDHozZKMOntPOIOAVtl1ngPcNPWXJD32+D/TYa
	CZxcZFzhyyoZKUumzOMgTYsnNbL/9bI84Q1YY7O0RVuHiDogAe/4w8MpGOgAX5UI
	nF6B0SfSw/eNxnWBoLKjnMF/vy8xDG88So0mVU+7l4UpKw6qt4tBCZOIRSSO8y/D
	l86sOeJEWqnW2z/iEaKxtpTR3mq2DEeUwzDqeXIA32KrhOp6B3gQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kejtrdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:30:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62RJfjmV038380;
	Fri, 27 Mar 2026 20:30:56 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d26xujek3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:30:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JZMEjw1xWW9lad4+JPiV8PV4STYq058HZTHVt4MWykX/gVPQi5AzPwPEBWJMC977bZMb/i/ox2QizgOiBwE6hVnxjILieWPoWK7I058NlS4rRQSyZUmEueeNSk/rhha+5gqbH6G+c+Bx59/KJAXB9XNmzK+q9k6O6fsN491bgG2Ljd91+CUMDLBOvJGMrUqmUmiNCH6vTLSLr5Lo1NyXUMqYavxza02PWFSdp8oS2y5nJyxGgTzYaO1uBUTlpkZte+dnQEH/ckAPBsTiHeetFrv1l7ceeFXUZvom/TYg1Z9VxGEegENJQmmi5xCWEzfY3E9wbmOC8q5qYFQEPxMsPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0VI8lO0kEbiI7cp8Bouk8TTpfg+1OLOvEsPD4eToD4=;
 b=CyWMMkhscSzxALElDOW4fQPg79OyX4zU2KSkVOBIiijqASvGfB9fWOJxjA3yuCUsmFXwvk7GckidttlGZpmRFwt7Lf+8v0pq/ICQ0/oURbT75twL83qBLZXp970WTG2HDx1FYroXP3oWiwf/VsfAnP3pv3LG8uIjYJTLCnH9nAdiDvBj0aJ6nugXZzTyzFCxFfR5jcc98XDE0stj6rnYZqijnKBuRmLBf+xOp3gPLr3w6r05QGhbf8jUWd4gpq8JDjJnCgByFG1vv9UVKVNDK0d0WSMM6s0I0Jybg3GMuWxy1iMgFqq8q+bzSpNnajXcwUyXiLoSREDg18nIgFd5DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0VI8lO0kEbiI7cp8Bouk8TTpfg+1OLOvEsPD4eToD4=;
 b=pb7uzm0rvcgIlEeotggNPo9d4fPBVhT5CmhtjwcVMZkKJ+JgtEQB0des2yoJ5gSe2JCrCaRJZsObv2YwfLzoUlWMHIh8kv/iUSKxTCpU9YiePmN3Dm0X/kt4rMdN+BvofdAQjQ3C92ZF5+R/+RoJirT01lRGKEAqYg3t1ghArjI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7414.namprd10.prod.outlook.com (2603:10b6:610:155::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Fri, 27 Mar
 2026 20:30:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9745.023; Fri, 27 Mar 2026
 20:30:49 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] scsi: esas2r: fix __printf annotation on
 esas2r_log_master()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260323100027.1975646-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Mon, 23 Mar 2026 10:57:39 +0100")
Organization: Oracle Corporation
Message-ID: <yq1cy0p9frn.fsf@ca-mkp.ca.oracle.com>
References: <20260323100027.1975646-1-arnd@kernel.org>
Date: Fri, 27 Mar 2026 16:30:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0426.namprd03.prod.outlook.com
 (2603:10b6:610:10e::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7414:EE_
X-MS-Office365-Filtering-Correlation-Id: 1db278d6-d0c7-4e5b-32e5-08de8c3fbb9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gOwSMCzOM1P/pxnM9+OpD1w2rW30oSJ6JHjQVXMhL2aNXdmrca48/HQy5EA34SVJb0rXDZX7UNWJI7l3LhSsRWnRrpbOZ9+iQm2WT26HGWefsVBpkv+whXMSFyCz/3qXDGCd3plUZpv/7lhvdjgCTPmK4UWB5JGHDcebvtYfz2zBLkddu7eWN/Y3tH7ayeoq6zYFeTkzWvC5DdMEoF9Qbro3Ab4pQynpowCkRQ9baGNih/jvnWqWJZz9UpRY7iu+WQ1hsLK0FGZWXfg9trPzv/f1WM+65l/opQboVA17ZE1szVNDCbOAnW+UJYCxKFdUXFR+EqkVMk3UOK6s5Z68JLtO7OF/ieogiTindRTLGNkqGTlAxbXvSCBU03g+kRvlzY3AQXjxnBuK6DGJG4L8UmU6+UzV1yQVK+fIh8zjgi/8YOkdd170mMhXmJslfdHvJfNWHagpb93DCTwKTmoalnb+fBefmZT7aYg1k7vUkpAEb6xiAzbGnYq/tyr2LBN4mKObnpl1dyAMrFvy54LDYqz/sVYZPi7bAuLwV/FkKYEcTq56n6qm66J5zgPFE1TfkOk6+LErQyE0JVhqjDfLC1wWc5o1RwsrduCiCoz71Lc9/khky+3kZMlOYsITsY9Tg/tWa9Z1BPq+DH805CbSBXP6Re6dVzz2knAbpTfALgreHrvMCJJQevy7/M8tSscdUZX6XgScC8V+7By11oj7sMmmuTZ/rpwPHx8KSGKbync=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EGW3hHGonhXiwOgyslUNy/+kDW0NtOH4H4mY6jTwxkSujPHEArWF5OWNm0HQ?=
 =?us-ascii?Q?vwA0MqG6+EqDy4EzEwH+wCtiJvNPUa8oarELAvV2x/4adlYrnpo+VmyPenHF?=
 =?us-ascii?Q?8IZ6rzom273GVpeZAF8Es7FN4pROlBZaQSkT9lDbo67y9haF1EmrjB+DLurg?=
 =?us-ascii?Q?Tt8qgU35rJHjtox4YfsPUpnm83xZFnX9MGDnvhtZFgp5ZYFNbW2KGPko2Pk4?=
 =?us-ascii?Q?PNdKNfXoBvwHWv59yzU4cYBVP+YOjPbI+hBgjDc8AF4YIcxVYlfH5eUkoUiV?=
 =?us-ascii?Q?FxbWBFH8sSZAHMgvCs+jV77TuGAmCGt2cQ+cOd/DKDqPApVm5D+UowlHi8eT?=
 =?us-ascii?Q?X5aTjuUmt7egDtSprTHl7L3g+x2M5OrrXvm0Z7gf1U0tDaYPmtrUerWSUa2I?=
 =?us-ascii?Q?PMrbZC7JzPxnSr5KHxPFnr4KPDdi/t8XZX39ruj9V65okHfwvNYdvIn0YU4r?=
 =?us-ascii?Q?zCBhGmdeqbeiM7YyRYCv1utYaWmsWf8fR7X1g8N9sKCqUeY2Pm+js2s/oB75?=
 =?us-ascii?Q?d3za/anhs0hjavL39NervRCMjIIIQFIM3dj20eSi10ertCRqc2BM44S+//k5?=
 =?us-ascii?Q?fE32D/5qNQVsvaG9+DCqVpo/m054ElqAlik9B/KWcRyMubsqrYkDmBciNfiT?=
 =?us-ascii?Q?0l+5RFWlovY7l562uZ33X746MxTEUT40EDNK+/DVAhbfECROtD2DMa8bEH4G?=
 =?us-ascii?Q?SKHYIObjpyApzfDZeHNk/SuVM4DnNuOZdiBWVDA+8MRdZzVZM34z9qzeLPT6?=
 =?us-ascii?Q?dpIUKlIyNaVc7+6JW4vrtXWl5pUx6DY0RFCejQ8yYaNFzHYPZ86cL86QormK?=
 =?us-ascii?Q?vpcbD+7xfiYPeqGC+ACPyLXkxiR7jVEeGmnB7jjG2RXZNn7nxm0xqacWz1Sq?=
 =?us-ascii?Q?PRtNu5PgGRnaVZGoAg3Ohxr1iuZqsr5VpABdPc/GHIv7z/QjCySrSc/zP6e0?=
 =?us-ascii?Q?ANLNP1hIqY149ZjdYK7R4jcU/8woclCCnib/c4sqRCu4BkA9oMOqy/xoAgrt?=
 =?us-ascii?Q?CJYPP3iPDF4sK7WQwj+YENzf6Qv38FmBSkKxDqHGvCatpTF/zSiBDrOuLS5p?=
 =?us-ascii?Q?j1rPI4TNNLHfiQLEakdIyZSDv4WjuKbk0S9a2iwuc9BBqRvZNICz5giyMuKv?=
 =?us-ascii?Q?2NIU8spzC/Qxs3Uz0fU7OICrMJUcjr0MepbnsoPBuZHnPdOsxxTjXILqCMI7?=
 =?us-ascii?Q?F9jKDD7lXIHu9Zed98EeJliGqyuqmJY6HjQ1C3qEEkUuM5rou15EOq5voCIR?=
 =?us-ascii?Q?VRcSrVahgEukMXLb9akImBcAPda8y8B59kXb0Bk+X3BvXGg/BwyP/hfuEty9?=
 =?us-ascii?Q?K2R54gAl29jKabknuGuS8XWIs3ID0K2McPOk1NcpuU/rzgaEEtUu2MwbAQUY?=
 =?us-ascii?Q?Pqpl/iCi+/0AU6Jcz/x2pukRPxLjd4tEkzCYkFdiFFQmZtfxbaJzbKSjwuUh?=
 =?us-ascii?Q?WYUqOXnG+/UzmWr5cAipG6FaCjTrNSKliRu08dMAsfOO9BVmjutE87hdQuaw?=
 =?us-ascii?Q?gRzcCr/7glVFjXLVTN6m/rr3FVH87ukKf/NwNTjTklmLXkuP3FEIUDgtIb6T?=
 =?us-ascii?Q?RHSHdkLDLdbG2rBDRaRcXoNuPU4W/FB7F5pHg1O7ysPEJlnUXxv16JgqJlyD?=
 =?us-ascii?Q?bymCKTAM4J3mTPQ95OOlpMbfrm1l9lHZrK4yhZ2Tt60J2uQMXv2Tz3Fwu8SX?=
 =?us-ascii?Q?OtL/1njRFajEwYmG0LYXb4rIqPfQGdj+83xzACZEkg6UJqvDTrjbDJmzf7Kh?=
 =?us-ascii?Q?DSobMgPacf+UpRA1cqZwLjOwjDcjS4o=3D?=
X-Exchange-RoutingPolicyChecked:
	UODbJJ8GSZ+Hw4+v/B3bZHh6Cwb89i+3OMF1Nbbev7CsaWbcHz+oYOIkUzmtyOCC4byS6W44wI9IcReKNqMRpJkXb2hDVASdseDfEd6D11nhTbRFjg8LxQ25lnDsQcz8w9JmIL4w4kaHwc/J3Yxf0V0wh4TbWkjHiw9emzxTwPm2yiMMhUpHHF4kdYp0McUbLHTfYA70FvICzG1X0Z+c4ScKHkGnlzhtKvr75ApH1PjmQ7Z/Y6p/P4YovR7KKF/nJFhVqaFyKohcy1UyZldBqUn3zVo0LzkuyZy1aCWYsrQaJg+mopbYfJsKSEWE0wFCKuGFcYXvj1Un9F03r+RQEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WpHEqXZ21/5s77u1BBaa/TSD4bs6LnGS+gfoD+o4+i6X2JKRs3EaTY7aKa2FnbRXRskfH5QujXw44otxslPvaEyYB/Mc35SoNLPCZSUSN8KnxZG0XNSeywaQ4+WGaK0GZlSy0A+JELsz8zyc+y8dpbuCdltvgowgRQ9EHB+bR8i+zS+ytxmyJub/aSNGtdlGmF8Pe8poTdso+BFe3/nJhOZ33BZ6wYmLsYUTvTqhaCKouzM6ODAZrZtGRzQoUwliwbP+AKF3+W8OylbXCwbUnYB8hrlGjMs+NXK2ZxTz2u3oIciaDFl7qEjf91hvlRygn4UwKyH4yaJGh2lx+vfrps4BE5aq7HX46rFpK8pPtoIMQ9ujjN8wO+PQX8DyXb7JZHcqkpBHVaQ8kqUD5jDUAnof1U/CXPW+YvSB0WLrjmLs/Z/pMZcFTy1TYbbQk2lti48ONcBjMU9NURunZZPgdvgCArrSWh8ZEyprlz+iG36bSFnhx28Ceqyb2ozPs1tQCqoMKXilOUSX/mDe9vJMedhbUHnvrEDrsoUZqvcxaivb6X2+Ii8hUlHpYPzYaOt4cuHyzV6ZCrEjd5pyHmYZctrECqlWVGJbwIX8891XfJ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db278d6-d0c7-4e5b-32e5-08de8c3fbb9f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 20:30:49.2936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLTx9oUqOURncI1GL2TFZglHwYZNDT5hr5TQjEtdG4lo3UllCFHvV4chTf95axYq2BwQmHNZxqUXODpltF0uHxIEHHVoYP7TSeZ0LqYlx0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7414
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=805 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603270143
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDE0MyBTYWx0ZWRfX/kPAe1ftFWid
 at062V22nEYr4D4iPDBY1McNXD7z7hSVlevXRKDWpr4xzZNGcmVrxjtDr//UnKE0APDdwb0xgD+
 kiZU+xWNuU3Mi+7YHrSxBNxAzeF7sK4v7GIQoiSdIlBdzTw0OH+8A1JVVxWSd+wtxqn+I3jmw53
 Oy6VWPxfnytMjj1+c4H05MXZ12jeqhDDHwJjwkJTlhXgP4FG3DfotrZaYTdTyZRQva3sdZPiH9n
 LI65oOTVjkdbmHF0u26LeoMpc91P8v3Ez8GbM5AyZjaEsqsqyOcxGc9Q9LAT8mef5xfc0S/9O1S
 MAnbLfVJjyDKWYzVfvpyBNOjdqDmUf/TlZ0sefaRhHmVkCGielIg3Pc2eLG6yZ8B57KkV5LFGSB
 8Err2fvI8Yj5K4Lt+UL85ZZvSj0JGB1QRYeXd/u2K0RmEBt15luxKblObB0+B+uB1Y0zhPjBRxY
 Kd1gPDaJ9HhL3jcAwLD4roGNRvl1I37Xh7mzeBCE=
X-Authority-Analysis: v=2.4 cv=GZAaXAXL c=1 sm=1 tr=0 ts=69c6e901 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=6gItoEMkhOOZMK_oc2wA:9 cc=ntf awl=host:12276
X-Proofpoint-ORIG-GUID: 6-Nc18a8seM-CmvjmTpDuTMHNzFSJTu3
X-Proofpoint-GUID: 6-Nc18a8seM-CmvjmTpDuTMHNzFSJTu3


Arnd,

> clang-22 started warning about functions that take printf format
> strings:

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
