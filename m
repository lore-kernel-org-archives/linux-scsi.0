Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343C817FD;
	Fri, 13 Sep 2024 00:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187409; cv=fail; b=KJexuQU++R/Doi/HKS6c+dsX0Wz0yCrT211y/z6ankE3A+mq7tluIjcaTcL57/fxCuIsbko0kEXNs70RfY+tpq6XkAIFkcM2r4Rsjph4RyTnXc2aAFRllCPM0Ne4GL7QFGrMCSR8EwpMRCxDptQUDB09tpo+LiO7LlvD/GpVUcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187409; c=relaxed/simple;
	bh=v4DxMdaDVnwI6dr8bfAWq8HdGxBkdmgfH9iXpdeaXvc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UAXrkjLrHsR6bUK9z6HhibZQhb3nQAkmryZX9ElGNytJoMZg86/nvWzqAY7efG5e6WCvVBtZ/BTArgZCvIlTDgPE9fFeG238+gMm3kz1BCZGoLyb9PJ8A/O1WB61OYd7y8pnhftMjeArENdlBJBMzmGAB27dcS/E1jYRdkUyUag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oRtHEbKc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aRvsdOsg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oRtHEbKc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aRvsdOsg"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYXo023301;
	Fri, 13 Sep 2024 00:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=8KuKqtjOK3lpQM
	MkD4sOlJQuqpB0cTL3V64MtsO+szw=; b=oRtHEbKc+QWl73RUwz8g1wQfkQx6ri
	ueqxS4P8MUZalj1kOiMV8ZagKk+tQjmJjKb2LABlVAyOiw/c9Jf+BFjiRC9uS0/4
	7zApmvmNNziDPIA/mI4s+GYBpHRklxW9vrGVnq52vxst13hi7KRZGLgTM5TVRFc3
	HRIhQNcStfxSwqa19vw+APXr1cbqDhr5Uziy/92TQklPxsrham+OlW6WYhLUs3aU
	nSxfdZdXDc3J2yUYLwz+qOU1qoHjapOwboUwRXDhGTAvGIHcxtjOMihgKxa0RpEH
	9dDI5Kf6mEzC3SogqnRJGGzwoG/Xr19ZoWzUd107sCrlXPD4zf+HB+5A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d426m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:30:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CNrwDV031678;
	Fri, 13 Sep 2024 00:30:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9cfhp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:30:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wGWy1ATVyYQLpgXzF7gCzUKtdq9ZW8p7rktWznV4os4tTNXE3PsJ5p0l3N77HP/cwYyZSsBjz5ZDbjZaacWUVcvGLr86n87eJXm6dz9RXW80dnaiAaJ9AbZJtA2xTpsQdIzYabWINioyhzjZchnxgsCYGa1U7cnKq1kjU3ArP/CmHtXfUxI5T7c4oYLUF3rSonrnCL2YZTuSy/2GAj7N/ZdWGBsKWQSf1GJ1o8/KNs51Id9CeberKZ7ral2z4BS/7cF3JW2okWhBYg95nQKCXC1VbtUIOia6OH6Wsaxly+VP9J5TwWqtUiVGS7pHLCUKheJPu6aAV0rR07XZksi1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KuKqtjOK3lpQMMkD4sOlJQuqpB0cTL3V64MtsO+szw=;
 b=xuF3CoHc+o43iPUeTY+6XS2F3fGlZf/DeCfwTRV+7VV0GQBeDl20fLJ2aE1Sotl5/MUzS+2zE4necS+YrFs9wFiWNqruv9WNQVJZdLK5uM5h7PIP9wwOIuMuW4/W+/mrx9/j4DBuJAJ0fvEulwTLbKRo2gT5kriLHiXklUq23/EU8qxsbsbhXh510yff4CkYs4B5kPSnQd+UM4y3uIGOsfAVZtxnrrbUrEcdR9mHbxzNExEb1kev6xuM8cLnLb9aP7UXaUj9A2GGM0fx7c2Yjnc5o4P/fOvWaRWCKvIB60NFUKg0NKPG57jouuPX7jx/DSh6VLdM0Hu+zd+ovd9K2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KuKqtjOK3lpQMMkD4sOlJQuqpB0cTL3V64MtsO+szw=;
 b=aRvsdOsghuMA5HH7TNsTDtTwuPCBs+N4gVUyj1C+dMi2Cy4TSjJqu1cVsmGaDnC0SzNjfxqi3rhw02XkHG/c4KGmYPw1B2D9u9d16rKhTsJ7q11gMkzM+lJOOQ8MGoQxuY+knTFo2GJ2cZWA5V9Nhsw8PyspQ9WGXj+5Mz9xIYE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:30:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:30:00 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: James Smart <james.smart@broadcom.com>,
        Dick Kennedy
 <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: Remove trailing space after \n newline
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240902150042.311157-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Mon, 2 Sep 2024 16:00:42 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldzwxuny.fsf@ca-mkp.ca.oracle.com>
References: <20240902150042.311157-1-colin.i.king@gmail.com>
Date: Thu, 12 Sep 2024 20:29:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: b671148e-bd3c-46b4-ad00-08dcd38b33db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bfaY2KkWVZQ1x83BtVtpexCYcLXBlyPRSJwuSiZcTCkQfe+/oZacdjSJ5sAE?=
 =?us-ascii?Q?GNgT9mHetOhbMQKl06s0askjKL8Z6egFV9E3dex8pavOef+j2RkK0tDK6hUP?=
 =?us-ascii?Q?jlCyS4xtnLy1iiiF8K8GVE4M+nDaY+rnrDbjJn5LYg8BAzzuFT+HON5t5ORJ?=
 =?us-ascii?Q?K8fMbQ7eOYmJUdFfKO9FfLkcHc9lMX0fDgRTTP3KA8a25h1alz3AHQxZ9ftt?=
 =?us-ascii?Q?Ky1oQ8gT084wY39NMtUCR90Q+0gtJKlMxJYtS/VAFoGVyupOgE7N2T8+IjBY?=
 =?us-ascii?Q?85EIovA3miJxub8ZB5D58LDOQe6EyUTDpExtPd26x4KWzjpmWECi7gbPwez5?=
 =?us-ascii?Q?k+rFWGzBHFXP2f54dT63FcQA4KG5ZAG8WVCznbuKaVMDakBpydVJvWYhlO14?=
 =?us-ascii?Q?u5K7dUJmhhUlRd7T14AZEriBf4fgORiV1koeRBULZVE2BFJAP6m4WWDdYGg3?=
 =?us-ascii?Q?lgG5DDIiwP6zm9U5bGL8/2rb2YxUAo4tCbXV8qM6B5FlFxM3/Y6mwGU9TYaP?=
 =?us-ascii?Q?t4NTzPyIffYveBo0+9zjRDQEDeVOmIF+gs9VjlwVw6Y62SCD66Q66Ct6rL9a?=
 =?us-ascii?Q?N3VH1cPXgooXjeu+Q4j2L2he5xCn5Qm22Efr86MHvkh/xJ3xVWk9dxxf8bU/?=
 =?us-ascii?Q?iiGrft163l6UVksIHcurnZM7biK/dfT77AlzS7A2ltBxKtr1V5gIarZtN3k7?=
 =?us-ascii?Q?fUK3D2I9YSVIW12qMwS1TpL7HWPHaC3ek5tFsWscBrvygJp8/jBNlCrJZIoW?=
 =?us-ascii?Q?xjcV/EpRThzZaYloT5cFpASZUo51Ym8ZuJyWgwSgVTdKrCNmhCqTLyknrWlm?=
 =?us-ascii?Q?xta0bWWSa9q6fCjLR1O8AG9Oze8uzEmA0EDS7E2aq8ae75pWkHwAqOg9cvve?=
 =?us-ascii?Q?gEA6FwiV7p0j8MdtEka+tZ3T02yscpl4nKSTATNXefLSJhvrPD186sW9EHh3?=
 =?us-ascii?Q?C2kWjZ55l3ogflF+49668yDUU2AiQS+jnr3TErbViqyDiVitNOfZogRtB7Zc?=
 =?us-ascii?Q?GksiU3Dwk+iWof8kmZBSiedJ7hCHeV3pufNjpN2RypP2G74pP0a92Km96R1F?=
 =?us-ascii?Q?RvTutEK0QGjtn8ItpDwn5KtIic0SMHHeSo9/tAFeTydUK5Q5pZnUIrLYhTeY?=
 =?us-ascii?Q?mpO9vcVDTANUxiN0mm2TJ/1+ldXT3pNkIWI5ueVMtPrhUD/CfzfAbvUiY7Oh?=
 =?us-ascii?Q?El6yZzIlN7FxohjQHVGNDKdkXosahqFlpYN2c8dNvRfu4SD0YvwaxAV6bR+h?=
 =?us-ascii?Q?xIntjxlIDK+X54M1UTM+Ehu0bCW1ro234yZLjB5xIkZr17VNojeIndpR4+aI?=
 =?us-ascii?Q?qclkthqe//UgBFA0/dJLdVVDwVkR9xxSbN8gXNmy8Kpbew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dUbG+jdo2C/zz5CfcJF1kRvw4TAG+pLww9VORHfHrnJso6buJMSwfZkm9Kbz?=
 =?us-ascii?Q?H6NnYCOnErBCiDr1TVixPjJqPQNpBTG9Q04lEUgraMUdAE8iXJur5E19jSd3?=
 =?us-ascii?Q?3R3VaQK5pgRKT19fKvmhYuwPJjuznKcj1WWllwY6F/4ek4HWiHymlhEi6D+6?=
 =?us-ascii?Q?41NWXma5UCoBIlNrRj/dYP1hcwi438mP+uT8ggIIqNY40o6EKLQLsxKbhU10?=
 =?us-ascii?Q?6hnxJV84EfHh/v6Cbn3P6S/xGjaqxLt2zEyUFGrIWykje0LbmMuuzyV72y8C?=
 =?us-ascii?Q?L58WQgTCdK7EtO586KQLnnUk4NxMMVuty7eljZJWxZeDLoMRn6LdAz/+arYq?=
 =?us-ascii?Q?A2oCF4rEmNga8AQVI+HWvZWmEcbd/pvmyMCaAODyJn8g8d+U5qlpqxbmV+b/?=
 =?us-ascii?Q?qxg6rLfA2bFtq9PIZumrH6I2zvI4jXGzrAa8GuBHOLKfINcbANfLy/Q1S1jS?=
 =?us-ascii?Q?L8kk2Lshkhvmz2rY26XQifX+Mue7bve4oYYM/wZjFMv1kw3e4OYhWvAa3aE+?=
 =?us-ascii?Q?k9IHSTWuIzwH4qJiPFssMwTtdk3xURLvkpYyXnCYp2PcmHr6o3QU8va9zTmJ?=
 =?us-ascii?Q?YfqtrrqMfWzvcuOby8+aTqVWRQO6gTnb3Mn6OYY7cGvICAp9Q1tBNh5AgFJf?=
 =?us-ascii?Q?nGj4NI/OE8erkdRKVVfxkkjHRnEmpkBLy0aG4yG7R3/9UXgij5kIuxZwMdOt?=
 =?us-ascii?Q?zoI+GBe/amU2Pva3Jyz7CtZ2Q1P3NnoqmhIE0GJbgc8y8pVhYkykzRIa7Je9?=
 =?us-ascii?Q?SxPGcQXxpnwHXrwctpfaIDY95HPMa+3BUgourO6sxPcH5ma7tOlGvFvraZDR?=
 =?us-ascii?Q?O6Z4xX823vgTnF1OzS60lSzGR3RcfU94t6VRmDRb3siz+kZHgm87OnyXsrQV?=
 =?us-ascii?Q?lYOWGC29NQc6mzsqugHDfyD6Db5rE6Y9ieXMvjAwXWMsmhZ6oP4CMklvtIQT?=
 =?us-ascii?Q?UaZqL/4awQ5kXxA2J5H/8YWhHU+vViwLSIolT60Vra3jwU0HN9Hck96Plhb4?=
 =?us-ascii?Q?ySBQyDF8Rx7T9g4TTyB6CE8oqj6DIvenDaGfsngENPipKQIgLslat4WvAAV2?=
 =?us-ascii?Q?TMc049S6EZxOOgU1f8VaykekJ1XbgGx+ZwJ2nKKIuwsqBmxBG4dWJlg7drE7?=
 =?us-ascii?Q?jWNXqCUocFjvsjDcQDWJZorbsrJP1g9t0jUMGAbS8lW/LvAAqawkczpHJMEf?=
 =?us-ascii?Q?0aW+BSN+BbLChZV62s7Xj9b1G88MNKy5hG7t+v+TQ3vRN8tR6hSYJydDMtDx?=
 =?us-ascii?Q?SvnMDMEhLFY9MLMrGStIb5skhBuA1Z6jhFYPLe8q+D6/ysUopGYYcguebHoL?=
 =?us-ascii?Q?6TiO/jdi2uz7hM8XtT04f1Q6iXT9utwgLu+cDYhOsP9MmsdQQ7ajNZFcPsPt?=
 =?us-ascii?Q?8fgNCpdHuHbywzlT1JDQn89OZTlD2d0SHyu00LsmrquyP/5EtRa6ceVuo7jN?=
 =?us-ascii?Q?uCjnpZ4sWYzGb/63zXQ8mIXnSgP8TUmoavumzcIW9IXkD5yKNQrmfrue1nXf?=
 =?us-ascii?Q?m/a1iRZCmeOcv0cuOmeYslgE/EZSUuPEqia36uWvB7PUvXNR3ErPpqGnCbyx?=
 =?us-ascii?Q?43LQMqOjpXoy2llcvCBcz2zIeJjzltkKTbr8zh5w7LxLbpdXpqagMTGTLS41?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1ptalgllPbi7deJIKAgtGLYijxOUqshvQ/f+k+9Nk+aRNJc5NASrAhvDYUc3U9ufm0cm6+tdomTyTcxSQ7dbkE8cDKMbN+dFUxlp/kkrX9SCl1ArxiuZCtkrxPXhPcXAcDA0nzsA7S240C12qLu81p1b/loCbSZpzgpVZzb73fwAlycdx4K5PJgzpTyVjQJLcK1Lf7wTw8XdSNG88wlUJI2IZSUO3Wt61SL2T2ra9Hgte6keN1WZXuaiBcWs7tzKMuYSeN8iEM3yYZglhqTdt4UpUpYeRDTIrMfKwIhJ45TAtWwE5Pf1ZxNNyMFHMQhHBVrJxNEA7oRe5OYpNeEiyLbvw5zyXVOj8eMsU1OGmVXGFpxYSO6ZtJC29vrARCkaMjyG4vlU7SIW2UU7v/bY9an9utiPkOAW7O7Nc0rK11VbRrPI8kcrtBfEPDaBB1w6knzCSenyE/0JrYrlxi6Sq88HwM7lg/uvrv05DNqm3nWLVJt+xGJVXTabgBJ5BsNERCF3fE+Db6qElZKAB2vrrf5R49qc+v9atolSZpYi0LW+tiQR5x1u1+8kQoRDut7uKk3wBQFx56DTfds19uOR5LYkYPNpWSAC5UoMrBI7o/s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b671148e-bd3c-46b4-ad00-08dcd38b33db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:30:00.5203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k/fwKcHapi10ySkUmfGJ9rGL6MR0CANVhSIClLjBZuXNxpBNkcHDQr/qjBh59G2V4V+A3KkoBAv4tpb8Rc/qrwCSbLzzCg3Hr52THJ64C4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=935 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130002
X-Proofpoint-ORIG-GUID: pjX3x6BG3WJCiXnO8BhZKFlDrLW09m7j
X-Proofpoint-GUID: pjX3x6BG3WJCiXnO8BhZKFlDrLW09m7j


Colin,

> There is a extraneous space after a newline in two lpfc_printf_log
> messages. Remove the space.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
