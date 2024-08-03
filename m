Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4F04C7C;
	Sat,  3 Aug 2024 01:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722648400; cv=fail; b=mv1TjmREW5FEtrCO8KgpPoHn41f/dNsNiS/UyonOqaxFmTK03UtIi5aOoejjXOltFtBqVFSI0SWoNZj6yNxsJ0rLaE8t1hiowcnSI1w0e1u3v5UvtPmkphA8TIxRvNopICkSDYfHPD9x+ul18Y66c9CxddtRfCBx07xP5iz27Zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722648400; c=relaxed/simple;
	bh=ZF5harZ7NDylkzM3MXasnXwcEja8vUSLiKPZ00iDUDM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Gbrj9x/qdYW3y7dX+gGF8gtRhsqBY/xNOKxtIG3TZW5wksSBvxDpC98b+T7SA8hkGaqxLiu/zaKeRFwEbbQUokftHsOczWIUwkZ56Rl392gL93Co8G9M6EltJD2njyT25Qlm/OGWjAofpOqqP+yLKn/Vx5L2+NrEKmSBH8LNwa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JXdCcXXl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v9YYi3jB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JXdCcXXl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v9YYi3jB"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472GtV6W010173;
	Sat, 3 Aug 2024 01:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=KKhtQFCWoOIz1l
	MdtCmxjhw2c04nOzwj+qDwiVzVweA=; b=JXdCcXXl38i2lqfncDsBn0AZHFcbMp
	5HNUDq04n3PGFWU81QJz6Ic2SLO/B5xUvQA+SXHy7E7sFAtLW+29uvIFT1Kdx18S
	tYj2tI413lF5lwb/lCxXXH/jAxoYRtGopQaSpN+SQ+/Ff8SkAzHywAsnxUnO3cGr
	awTqdWa2KPs54LLM0iPNvc1LDPFJIbMvVjLPoY6/8SH5KIpPuQQPk+HXV6EBb6Ha
	b16Q2PisparAmSxVTMEn3pKwluhNn5i53BkoX+vuFEA7TZ5H5z6WaiZSSdWb+dcd
	Cz2GpUKJHv87DPXHlcto4eHSvqW1BgjWsA8jfZjcQRkdSV+k4wS3DzGA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rjdsafb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:26:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4730Gi73035519;
	Sat, 3 Aug 2024 01:26:26 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40pm880837-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:26:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C6p2dHr00NwvA3B9+YTNasafeJ2B6OEJQQ8d1bjpHBLYGkrAXpkhRj3iUf4cyRm23zWhIzphSbFzW1Bp26s9xfny25jne3GJRLCuFqxd1WAI/BxyWrjMSc1oWsHgpkMjcDLMO0Q7NC6+WfINQhVHSxIOtdna7rLK9nJ2iVS8DZJf1EfFf7i8c+84Vi68pNnuseWwlTtdbsCZBIJ7Bf2TPHhQ7/Rrpdc2jFtdL6kKwE5O+HbbuRyQln1zYXce/lm0Q4RQpCL+Kh4hzZkOq2DYYwmeXT5bLjAMfsp5lY56CgHZrTrvCDy0sE5gOQtG6klk75UTiBGNi7TJ8HSsJAMxPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKhtQFCWoOIz1lMdtCmxjhw2c04nOzwj+qDwiVzVweA=;
 b=LC1x+ik9U4IFygLukT/JWE1QBhnCghdAwek/A4yGfI0IYEchb1qsibUy8wmK7Bd1bc35+h2bMJ2KZFeJ1wE/qyOa1Ht2b41uAz7zbad2xp6zZ8A0XMEMab3PAHIzSdOt8pnLsnU1DrAXmGGCgPgojxxHzGX2j/qXXDXVN0iOfbTTeSX+9oCaTw6XI7vHTODxsJwlIF2YlHEuwih09IU8nsXZhfzV/L3uPbjO0JbGZmBTOGJ3cJ9oD7Ei44AqDfHwgsdCDx3T/AXujpllOK80Lgse86veJTWzg466J8beKcjqXlFmSPVN035QU1OHlGIJm7hXRR4o6uQE5nMc14R0FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKhtQFCWoOIz1lMdtCmxjhw2c04nOzwj+qDwiVzVweA=;
 b=v9YYi3jBkhvQbF/2NxNtYE5BcNjyOsBHD211fKNZ2TXG9J4W4zB99p4xE2XcJQ3qoo+0yMhTUHh4FF9Yv5+950BKaO+6a96YM7OfkRi3bh6LNsAFyv5LcNI2036DVWXOVmtJxhxM+gOS7mjUrpbsM1YcK4hiGNx5iFZ3bVOc0mQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:26:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:26:24 +0000
To: Kees Cook <kees@kernel.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: struct MR_LD_VF_MAP: Replace
 1-element arrays with flexible arrays
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711155823.work.778-kees@kernel.org> (Kees Cook's message of
	"Thu, 11 Jul 2024 08:58:23 -0700")
Organization: Oracle Corporation
Message-ID: <yq11q368ki4.fsf@ca-mkp.ca.oracle.com>
References: <20240711155823.work.778-kees@kernel.org>
Date: Fri, 02 Aug 2024 21:26:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0284.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 578bb296-27f0-4218-c179-08dcb35b49b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W8V6xDu231yT9h0Rm3LcELBpSE01U21qLn2ay51y5tCfmKH9Yb0GIo6SQT+i?=
 =?us-ascii?Q?25lsnpZev5EF7uNHQZDkfbRPSzhMAvI6H+zt/1CrY6GuSlmfVF9L55cgtwTd?=
 =?us-ascii?Q?BJ9IaFQSzHhhaOELDK1bzOY9oJ0xC3Wl0juX3JLmLGf3hwfNiJxsSmaSoPhh?=
 =?us-ascii?Q?hbEFULUb9cAiGGnLhqyPgjh/4uWXeYC3wObLKVQnOtopLVbo75wmMUInSNJq?=
 =?us-ascii?Q?KdHV7ba34LDB9K636PklwUVUBDN1UOi29rYPAiB10bYws/BErbkh6+OwVsUf?=
 =?us-ascii?Q?G7WfWyWi8lcwApsVeICbgBbzQ08ligA8vTciolsgEMamMVsh8zxCtTIkrOA8?=
 =?us-ascii?Q?03FKm059G2Xdgg78mIT1posmWG57dNfVNVi+mNgHakWi54xlEFf1epSRXXVH?=
 =?us-ascii?Q?rQiTsM2e4OjI5Wg5pRZZji4vbf8+OjoEb5cJhoDc6w6PHNru7CpZen8BvYe4?=
 =?us-ascii?Q?iQBHLWmpgZdllJHZudde7meXrKPLos30QYjeqCinlEMQbjrMhRg/RcLEc6Rt?=
 =?us-ascii?Q?jqNLV31Ci9dViy8hthxyPQJuu6qWUjMa/JZHwsgbSjjvdMtYGDHJqbhfNwV9?=
 =?us-ascii?Q?1vACAP9pFqPyDxhMUkuhmbLL/utOoQqTeuTAmIJwjPfODOQtycBIvu+UYDOK?=
 =?us-ascii?Q?9vRMYzbyTh0zLhHmmH+bzUHIaE+z7rlHn4XI0HOqAjbo4Sq4Wn6H8IXOlBFG?=
 =?us-ascii?Q?riESA3JPR6BKFvwERQwWVT3eCvoNsJdrYOqGeKMsI2gW7o0Hha9m5McJMjYL?=
 =?us-ascii?Q?pV8jPxFqVjdPhOrySaKQn522FpiwNZGCguseMGyVzh7OgnJbubx3FsQYGzG4?=
 =?us-ascii?Q?Ze5rxdsEJ0YMabbp4HE1i1Wm+I2DhQnNiW2t78tOxlEH9/6l60iTKcRykiGI?=
 =?us-ascii?Q?TGVGz7mIi3l/qw9Wk76FwblhGO1UNHicSc226aRYpcBU+mRUNS8o8CoSwj2L?=
 =?us-ascii?Q?/BV6QOm/aQ2AgkMXMLmguvFK2EO3VsacdeA0mFGTX2j6BHV9d0q3c9t1n9q2?=
 =?us-ascii?Q?+Lwz+TjVzgZRNxNrTF7cnzO+rGGQKuYcJPQYF24CTvfPzCwav/BOcimTCNLr?=
 =?us-ascii?Q?gJYiu+YFoxeuDP1SdL5G/CxNIhmRGzUNoHkh5iymni7CA/ooGx/I5aAGFwRc?=
 =?us-ascii?Q?WZzVIpXm8S+6vCLARoxlNl17Rv+FNIqZqdh12eOtFqe/13OeFDYjbxuK3NQR?=
 =?us-ascii?Q?zDjjX2kxFO+eX9B7l+0Thf3Ic7aqIBb9ZhkBbYD4QQDlMNZ1icyxHVuPlwzI?=
 =?us-ascii?Q?Ay0rD+RmI1gJbXgJ5e/EXVZonY0M+9nHInqLZGba2IE6j8ZiDkxAbJqxUFgO?=
 =?us-ascii?Q?11E3m/1Z/EdwWUFyXT5tUFu3todYRZYLNa33/z49VVxjxg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nVdnt+Dr2TTeQcg9PaVfHFWkne3DhHIwk1oP1KoKgV4CC8M64+nvTRY+ZRdU?=
 =?us-ascii?Q?Gh8/4FYflaTBeTCBwdMGU7BmvL1xkgm2/iXvlfzHJpwu3309bOhoxVfArG9t?=
 =?us-ascii?Q?ZpVMVT36LfvM5PA4V44ZCR3XYX2D/sGBhTYevKpN6NxIDq4/SB4jLhTu88Uh?=
 =?us-ascii?Q?ahawOLEIqOWbk9XSnu/TyFooKeRj8fbK9GYOfxT8cfQW48hw2VpIYNa2JUoz?=
 =?us-ascii?Q?K61b3ptyRDBvN7rfhikMDTLbdL3925+RHrptUKFnpdPtURe7pIGPytW8Rubi?=
 =?us-ascii?Q?WB4rETeRTyDPctfC17RYFM/MhkJ9mC+QY2HawujSEdY6ggcWk2vKRIbk5905?=
 =?us-ascii?Q?+cfA4RgmkQLQwhFcdqadawLoI3cbFEiMEimJltz5J9E5i67j5pN89CtcYpcx?=
 =?us-ascii?Q?0yCGV0NIxiyTs6Xgi2Vc7zQYPa403zWWCDPVSUClEaiqUJq0VEN9EojUkqcG?=
 =?us-ascii?Q?TKmXaGnpp71Yl1QhZ8JRn9WzHZbLm3E/JTKGK6FW+jsNJBlyzFHBN2KE6G+z?=
 =?us-ascii?Q?PV+q82tgpg5KkwCCQKILJKAL4TFUMOb1Jfcd5w9Vc56r7FDbT1Ec3zCmfzIp?=
 =?us-ascii?Q?S0N06Y+RaZg+uwJj3Q8rjMc6q0EiJgQ2WAf7tIr1Uoz587TjrO6+o5nUSkzu?=
 =?us-ascii?Q?6tQPdgguNlMI+l3yUZxUdr6h349GA5z5QwWtWeZ/X1AwPsD0MeBNEU9iYnVc?=
 =?us-ascii?Q?Ke8qZ4qm0izbU+IkSgLVxxIOFqGq+zvSg1qXSUVaB2WB3116WU8XbbJhM53q?=
 =?us-ascii?Q?pAqXa5oJDEIhzSWIPhVXRiVS/y3U5h0Z4wj6AJj7J+GOJo6SaYox4H5zcaJt?=
 =?us-ascii?Q?pvyNYlnfHt9BAVfA9atfv+hcCuO04kYk4rYSzWntJkI+kUGdyCVFVEczmX7k?=
 =?us-ascii?Q?gO9X+LVySMMqx6A+I/+I3g2K8E7X0sH8EFrh0cYFxzRj9bTk8A9+pcpX0B5Q?=
 =?us-ascii?Q?QzWk04jzCXHAzJAo+QGKSQp741QiR5IM9PUXJdE13+xdDtwbTYQiVSqox1aw?=
 =?us-ascii?Q?2rjF4i1jk/GzINdyqLBEoY+AcsWvTmk6ZxqAVMQzQGcLSVJCgJDDFZIQG4bU?=
 =?us-ascii?Q?qJLTNfXojLVqDmb4OZC51ti7UA0VPzT7kRW3lZLcduZUoBbEBZRcnjCjjRcL?=
 =?us-ascii?Q?Ad2YWO+PS8mZPB+y5a5SnusutxtP0oxOf/sgvhM4HF/OL4pkow12kh0FBNnU?=
 =?us-ascii?Q?rx6qRfKlRaTovuBbf4EAXw38S5oZeDnxF67X7Axo4CqKPYZxhyFSsatrhonm?=
 =?us-ascii?Q?A2CQofVYJ8og5/LabGjN0ao8lHLRltBOTkc8CLbjvNJAC/zkcCTtIM8HkSGi?=
 =?us-ascii?Q?lB6wxJ6cdJUAGwB6EwLXfwpUoV4Rv/fZRCzwHCNeeuTGJ36BQ0vWrTHSz6dU?=
 =?us-ascii?Q?zIIrLeIA5VyVid+jlrZ+13ia5qSNSbu6YLSO1viDAZ7nHPdvd62M9Sx0c1DP?=
 =?us-ascii?Q?wxiHJC5Inf6J0XEy/znnNj0FsBKRGxIcnMGP9ZESQLzRHEuMS7GAnvEbwIcQ?=
 =?us-ascii?Q?aLd0jhmkfz+Hx7FCnEajaXujRTAjICofCJAuHNd2NtVAQSS+Ac2Rm0tI9xqf?=
 =?us-ascii?Q?XjxanbphD26l8cegwyAtPO3Azte6eJbSgfjzaCyiiofw72bDeqJBsowBx4G0?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6If9VPlF/l0wIus4dDJ9Ag/86kzOcxW3mG1ZRPq3QLxGBT5FPjVLTYjuq5j6GFt2xpYbi0Rr95Yvn5RCGivtWGId/i0IeDxjXLtO33MgN0uyM7UUkwTz/kakJXm1TeVA0YfE/5Ou8CTCUMepR0lt0NFetzN8FeGpD2St8ZIFJ4uIRUcA+AFz9w5nw732A72TH/8CRm/p9GNg5GRqOmiubesdYubhCAKpP0MTev3bz37h6e05lb4AXD1Clbrd5q3BnHX/OrzNR5fhQTZ32mohCFAwJbhEk421LFmzMZqyN/tp4DYJam8lg4uqg6lC6rJpKZUFCyyA5z6ZcVO4e+XXVkch9hak/VfWQxJL05OpqxXtObbejrfjDxjqHEptn7du80AtZ2mcDqGYZ1FpZnyAa9aRk+ZtI7JpAueOkqrmpod83NbXVDLw/I8GqDF0D6p0I2Mmd154F/d5oOgZ0Tl9teVx4FuQrsDFBhvmW0UuifO1Bgd8G5ZNVdKrc8CX6gtpDZ1S1j+YNv0S4a8DdKm30aNhcSRia0Op75kvZ+bRCu3yIUfmyeFE38V6oqcFnqKCsRFOczMpasiX83xRePHvejd+WKG57UtfulZkGmB06fQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 578bb296-27f0-4218-c179-08dcb35b49b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:26:24.0826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vSD04ZpKv1InKAS8JH9QH63UZ9oK9a9E2o1uB8AA4U72oR9iOq+OFQ5Cu8ecEA/85IHpBjDHPtB9+1LN3MGnovaTWa3lH6of9u8qVCpgKG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=576
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408030007
X-Proofpoint-ORIG-GUID: EQA4Ld7yL40jFqMU8w5AAwVEBJ_879KD
X-Proofpoint-GUID: EQA4Ld7yL40jFqMU8w5AAwVEBJ_879KD


Kees,

> Replace the deprecated[1] use of a 1-element array in struct
> MR_LD_VF_MAP with a modern flexible array.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
