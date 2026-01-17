Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80C752F88;
	Sat, 17 Jan 2026 04:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768622689; cv=fail; b=aEWaL51c48uf9tCsl0VxWZSB2iDq/o+2Sa+/cY4UANK4tuwffknF0OpckbiQbCDwA46GjIa0DBin+veVh+du+gO0s/B4A/XcECRFJj1YJnWPvqwiHMhRCuPorichNNC9hTXNBG/yn1pt61UMC3xBRGKqOlDuyTGpoSS3Y0iLdDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768622689; c=relaxed/simple;
	bh=enUix5LF9ykOuzvrR30/W0sGdDYCb3Hnu0uAaBSC22c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WlydsiotJYTu5QT45BSX116W6wjRaOoFAiohsWu6pcgyB2KC+EeDIKVKM5E9zTV3Lktbh8yRaFnMcnf/2c0WJ9Y3slJgTMni5UPewE9e/+8AGs4PxPwMedhQ/e6Bcz/w3/9Kc52mdefy+uFtNNDf3iOpakz0qG2SLxYatL5FKdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GTlXBrtH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=agqg38pH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GTlXBrtH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="agqg38pH"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H1Xb4S208667;
	Sat, 17 Jan 2026 04:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0IFgEPE+p+QfKSchor
	AzCzLqft6iCUA23TIOyo2J4Oc=; b=GTlXBrtH2I4zfi6y/HUN+91rP5pE5ykWtP
	xcfNd9yEWEPekCTANfVt/8HE3sHABS1kQhJsYxYCnL1IQ+ZSf18FAA+1hwPVKjCO
	YUtwe4wjwo381hNK8clCsB/P9mMKL/JmzcOXYZhYxx5LgWzk+JkvpB5z/2uAanow
	B5o+OGn9lTOxJe+tm7QkVI8b5XU6pcUgLqwoT/AOiN5G3q7OtqYgkUKTT3AggZen
	DvoNk48Lxt0HxuNwtSVUSUp6OFYALqR1IWVHvdNxJhB4TNSA6uw7AUzyYaW6sEVy
	TB0Kcpd0p+Pbn/qlY69Q3RRr7cIu+3NobERK7HS9DPX0ZUwqU82Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9g399-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:04:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1XsfN018020;
	Sat, 17 Jan 2026 04:04:28 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v6b02n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:04:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfvYFdk8WRR9FF1aWulqLsJOskEiyKbE5z9uoThzoUzzev6+Cjiv/MxsfYUJC/yAcW4hvczzNBM3RfV7Rjbk0WCkJhMTkJHhJPfFdfxWzAWtAjwrigyWWy3z4fxG9/ZqqaPhCWK3M0q0SohHtlBcWO3x+7kJZIDwa53yMMpRpmgenTQU4n4qKpWV/7ADCngghpeeF8Nh7oqeVPyayDsxqgjfxa2nN3Clqkam0MECrrVttJImXb/d18EvSpJAt0eUxJUyCs2xc7pqLie/Qen2SnOlP11YBYON1Ne+n89GaYb+p/EhTUgm7s9aH0T4NSDMpq5NznGPDdMWKxF67UNbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IFgEPE+p+QfKSchorAzCzLqft6iCUA23TIOyo2J4Oc=;
 b=uD9EUFSu8l0S80Fyw+8hWL3wHost/GuTEzIH+MvPDI7s85Een0MNFeB/v++rtzJSLAZuckkf9cdYrMd0KMjz0fcnKyqM5+6OJdVQXJEmocOJD1zezgxkMYoXWISlG/WRnIphxDwAd5UZ05NVxPIGBhaersUFiouivkWjUhF3CRdGpQ4f4/GvGfNLXg6shIel2bYlgxrT+x/CoKWRnDhL7i57jD2C6YgciMEyI24tloR6/M43aMvSqLvBjEc+8LqqnMsrS00Yoxyh3ByIRfryo0ppSXjUZ0jnjOivh5FYitjszrsHdOCISSFGBJK05svjgiDWAyzeFRBMC7IcxEg51w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IFgEPE+p+QfKSchorAzCzLqft6iCUA23TIOyo2J4Oc=;
 b=agqg38pHp8vHEqaw0OE5qY498YzojEW21bLm8xv2h5aEA7kldVf7I0oPD5Mla4Yx+T3vt4mG1rvfzH1Kyn4AX25bwRecIPwiNnTjq/DZwuJvuNDNkbM4hb789JlTEI24+UcQVHjla65anrQN7cr2hGRSoAXXnCE7hYCG3EfMeCI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7718.namprd10.prod.outlook.com (2603:10b6:510:30d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Sat, 17 Jan
 2026 04:04:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9520.006; Sat, 17 Jan 2026
 04:04:24 +0000
To: Peter Griffin <peter.griffin@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzk@kernel.org>, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, andre.draszik@linaro.org,
        willmcvicker@google.com, tudor.ambarus@linaro.org, jyescas@google.com,
        bvanassche@acm.org
Subject: Re: [PATCH v3] scsi: ufs: exynos: call phy_notify_state() from
 hibern8 callbacks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260109-ufs-exynos-phy_notify_pmstate-v3-1-7eb692e271af@linaro.org>
	(Peter Griffin's message of "Fri, 09 Jan 2026 11:40:14 +0000")
Organization: Oracle Corporation
Message-ID: <yq1v7h0j35s.fsf@ca-mkp.ca.oracle.com>
References: <20260109-ufs-exynos-phy_notify_pmstate-v3-1-7eb692e271af@linaro.org>
Date: Fri, 16 Jan 2026 23:04:22 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0109.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: a09d2268-db44-4edd-f221-08de557d7fef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L+cHtpf0YQh61ya0hN6j3lBziKSwUeG0MvqZjzTuxFna58JlBJUK5qMThTdZ?=
 =?us-ascii?Q?viHB8OisE5fwZFisT5MxzEpNSHd0bkTWwKqEGAmyhfbf+DfgnNy2pBSB/lmd?=
 =?us-ascii?Q?IBvnZFQrEREGR0kA2i8gO5s1Wm3ZRPj8HLuIyVGIYApnIaTO9THbGE3nMrVl?=
 =?us-ascii?Q?PdVD8XJ54pWRaadZkbtDFp9IdRWGmNzDhRJAdhxnzKPJhIdtRAVMBveQZp5U?=
 =?us-ascii?Q?pO3gASOcewMWZTZ4isH+66S/CBvgFKFcYv0KL/A2CiX0Vo/HaceZoyk4aa6z?=
 =?us-ascii?Q?SqwudjBhy67dLGtyjAo7OLuvh1YZCftAeIEmT+if+Z0ibHh0RYuwrfthb06I?=
 =?us-ascii?Q?7Z1auDvD/x68CeZqHL0M4SU2AGsD4WE8t+yZch3xWysKdFEBj5ug5ZThLA0k?=
 =?us-ascii?Q?UoJIr9BjczHhgJ1nnZ7UrSi9G9g0hBhkO85M7sX6h6bykAn+576ihLZk+z7s?=
 =?us-ascii?Q?spU1RnsImdvb/6oTUsBLydhE6i2Co8OCc+gA+K85XXvGj4wZIifIeUWbiS4x?=
 =?us-ascii?Q?n3uzYAwwVfFrknTvNVNujnrKmvuKVNbXU9mvHh0UbCSKicyK0ufim8d36msE?=
 =?us-ascii?Q?Od/tTmIWw1Z1tuYxf+Cl4DbQKE+iKkREhsJ4PtMmhevmkvs+omBAazkItRfD?=
 =?us-ascii?Q?W2WlCV4KVOLfBblxkLA4h+iJdyxdwJZnV+Au8Y5IOus2KjYHfi67obg7zze3?=
 =?us-ascii?Q?04PU+vBfoQHODecVtS176shYIGud6ADCUU53hhnf4bKBedpzuUqe+HQ+PJbK?=
 =?us-ascii?Q?DkWmkVptLz+HZxXo6gcSlvB8UcjVSn08mKuVnVLJVgObs0ycO/eaeU38amdr?=
 =?us-ascii?Q?lTvko4Cv0wNqnsoNY9Xx7xlmWXiU1iCmbChDqxKPIMBTqykt6Aa82W+XO3/N?=
 =?us-ascii?Q?ErmZvY//7ha8WTK2JgKERYW277A2bxow4PbvXd7Vo2C8jBxDIpGtNrZZhY1M?=
 =?us-ascii?Q?FKnY8yizVzGnE3JSO2C3ms+pwCAOVzykFCCApP/SJLTPCHZo5UeVnwV9OsoZ?=
 =?us-ascii?Q?BmQFrBJLUAhAHx/feoMvS/uuFEfVi0oOe5oGITuSGFMMKWRIC36QgD2pgQsH?=
 =?us-ascii?Q?aLLgKUbJheUFpmKshtmkgGI5aXobUWR6cAcojLfTer9BWpxdJPZ+/gAPVYSb?=
 =?us-ascii?Q?P6WSVp61OGB6hwH+tFFKZ7BawZ+0MyyeoiqqnKzM28H7Q0bKQWqFGR+Ua9pP?=
 =?us-ascii?Q?wW8Yi78TDTZGK69Zm5FWqU8j7Kx8tBrKmXFYujs9k9dGnd5hmm5JCb20QXB9?=
 =?us-ascii?Q?G82I6NyAjP2VqUcG4C4FDEeSSmXI+fY34Fz4ats/58Te3Mo2NXBRgDeyuglq?=
 =?us-ascii?Q?Kkg+Gn1wt7a8CuCXBKHux+hqdimPLYG/ZhaBgWDy/TsnuDbz1yqAJwCGtXnQ?=
 =?us-ascii?Q?j3tAMMWc+siBROEMNrGUzdwjbwpzSWgFyfUpCAU8QntsspuF9wq7dQHbIqDI?=
 =?us-ascii?Q?9wosi7LhJCpfkOA7JuBUuq4lhlZDWpChGFqFeaKCR71exUXAp56SKrvzD28/?=
 =?us-ascii?Q?PeYxjEPD3fFLf0TwHgMW4SHTAgbqjxYxjaLCPKs4mAEQ9+TVkuBa/z5y8YGO?=
 =?us-ascii?Q?6qg1cUku25WJb2T09EI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Uq86yqQH9/ogxqsqPCBzJPtV96pLZ9XUR2bDaxcHtGM/GbEW8UcZ+7qrJ+TC?=
 =?us-ascii?Q?KHJwpeC6SFQXXizhXYf922XC88x3/mRUfyyLKXdGtoLAT+FNIAKbegDrkFQi?=
 =?us-ascii?Q?W1FkUOABS1T3vPgmdK2wTk9aN/uQAPSA/pZpX4GGOuXvWnsuB4HZtG3HqvQ2?=
 =?us-ascii?Q?+t+uRHcNlAbiHS6w9peYPQnnrClNSgTytJExicAtGHMUou4xhGRIbWQ+/lor?=
 =?us-ascii?Q?6Uq1t1sEdMFNvj1HnYbowGe2S1dnzU2QLe2fC20oJMRg1SxH0/KE4feTI41l?=
 =?us-ascii?Q?HXAx/YoOrqZR1kwYXEdn/vUIRJUSN0MOIh9AyTySFLZZTBx7jSrudI23agBT?=
 =?us-ascii?Q?sDzCobH0UuK4D62n+/zjrkdzjEjtAbJiJQ+WSjk+wrnwdroqEae9KVEuvlAY?=
 =?us-ascii?Q?HdBq8pzp0nj7+wRfB00WWCYpSf986xvq+j4pk4XJL4C3rT61p1J4CKPJAXbj?=
 =?us-ascii?Q?T2z5+/bkw0rcCwzXAzqvwSWmz6Vz1ro6ivn9ubc9gRG7VuPH0vbDUP7Z23Tv?=
 =?us-ascii?Q?dp/ezz1Jy5yhNuUJA3VqcERBkWOAdhhVK/jXGuE+wdQc/bSE70MwhcTNIGFM?=
 =?us-ascii?Q?tyifA++1aeS1mZLs0VY3BjXz01c2WnsJqsIHvJCeu6mm17Uncg5NSeUV1YxF?=
 =?us-ascii?Q?p4MXpU7URWpIQZEtPFE5YgFUFbAfZQjgIyIkocOGUyFHvf+JMyoq5rRRo5yV?=
 =?us-ascii?Q?ftyahaZOFh3qC7z84OBkRfFBA/6DRcoiVn7yUTJu+JcCzq46i7OgE399KCPd?=
 =?us-ascii?Q?FfLoTtFPkcw67oxGgBHxYiipUVgcRc9r3E46ijxQY80SF3NLjuo3mLlPOEmc?=
 =?us-ascii?Q?njHJCdqjCrRv0PW/GG1su4r7V4IkupZEJXKSk4xNJCkYfNW/kSvCrKqEOwVT?=
 =?us-ascii?Q?EOPntHRLh2KCaZiP9m51tCOZJ72Rp5/IUoq2FBmtZ+xX9z65yaz7ZymWjPpW?=
 =?us-ascii?Q?XTgulHb46OonDD3LdYvb9AEXGYmqh440cQLbqrF5CsClZkYkUzyQkIvR0mF9?=
 =?us-ascii?Q?ZvWELpcTqRNYQGkbdns9MEGMI44RIcuBYjEtCpl/JPdasNozLp2VlfucEGh/?=
 =?us-ascii?Q?PUJe0IUmlf592S7/eGqCaB4/jhB/L6J6FsJ/9f/dcoKOpc/m3xUYe++A7QOi?=
 =?us-ascii?Q?ag94Py/6rfPE1ozQfghc19h4ho8mtjDPti+ijv72SnEPm4yKCA6klAubAMDQ?=
 =?us-ascii?Q?p2LwbeK6vVQRI3aptIoVnqE5/30B3BkpkV3GcSoGXTG52xW6iCqAjMIb1CC9?=
 =?us-ascii?Q?Y3VO82jXg2ecmcFHyBmxjL4qrfjeaMI5/408ZtATxx8db0HIHuDF/tKhe34M?=
 =?us-ascii?Q?sb+Yedcm4VeGPnnvI8ajQh2unTYdBVRgN2Voi2RvJ3ENXBEMCawO8LgYYp7L?=
 =?us-ascii?Q?qaN2ohcJlxPrQtwGHOjDTrHUl6J0eYH+f7Lx3yItKcoYJj73uDnh/+/P1mJu?=
 =?us-ascii?Q?9RH8hZFyFjacAGuWL3Dp6eR6bL0z80Uu0G1JDh3d70MouzM4V9HZUcd0qK4U?=
 =?us-ascii?Q?D2nlnF1xvVrXspvCUqPfVkfdXbUG+mMoFkbJtFBC65ZVm4AzVOM/Is2zS6Ll?=
 =?us-ascii?Q?kyHgaGzk7OiPM8McDJVDiaPaymic5ACHUNeVkUXFSQINXdT9Okra4m3ZIUi/?=
 =?us-ascii?Q?nqgeCJ+Mh3bAiJqGt2gyBErWBOOWHQvON7V7T7//4rtEfjotFTsFdFrddwL8?=
 =?us-ascii?Q?/HnuRUenlWZA2fijX6jyKQJeAyr0GT7mn92E6lNXj7ZMVCaVx/6vrrC6aTWL?=
 =?us-ascii?Q?dJ/R5YZQDUXgmzSIz91Vw/WCykwPj5Q=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1K5tN7E28QR93bBV3u6sQAPNpXjnnbHqymvMQaNYE/Tsv4kJoqgcJwcrtF5RB95LmGhfDeN1WeuQ+Qc/kck1m6mB/1VOuBMZJzIkcbc9pyOmaZNkwvFZPnGWwmkRaPKzmlGhqJ+oFXyabPhHTRWimFdAlsD/2f3IpkV3RHkD4qT+wf0zO3eYPgs3V237wDm0zOe71wneFUMBLuMP34WQ2DQlpBPrE1LiEqCq10MvlPiFgHNc5BgDMCan0wzM/3dAHvOf1/Yt6imVRQVEn5ao/mgBSN/NHIWSKyyhjFNAFfmujI2sNmusJzmW7qeCJpk6vNY6iuSdePIlnXxk5sT/eMGFBPiJiORgtu62tdvia7kxckJSlkThftx+P98HwLdiLcZUeBdRzAn3Ull7BpNmW7QiOSgBGgwVnPk1X7Mi2PQhfOp707t8UgPpSlY8FPRrCRXmimn5iWDHq/grv0jzm8SCrX/XKSl/QOs5xZSVdbPjR6UoqDCmAf6zbs9kFHdRIFqponM5UuvdvxNM9UcZyXk0XAiQC+pAB0HlBOMslxjqeO/xOVzTgahD1ECnuOHkFi2gMSEaXDfkw31ZuJVxD9b2dSdqKMwwyGfGTKzDSdY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a09d2268-db44-4edd-f221-08de557d7fef
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2026 04:04:24.0256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v77i9XAtLgdxv/CyJjFeDjIDBRhRkXWGyWAlaY+GK3wbYml37EJY0dCE6Tx1DLFNqLFOQAT2qDq/+RXDZzZufAe6rTyZI9wdJvE7x8mVQjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_09,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170030
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=696b0a4d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9
X-Proofpoint-GUID: WdMeLkDrECubmco2fPPdXUZQG0SBiRxz
X-Proofpoint-ORIG-GUID: WdMeLkDrECubmco2fPPdXUZQG0SBiRxz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzMCBTYWx0ZWRfX+ggyYCy4ubBP
 7rdQszcMomPVOcITyIy0y0WMYhaEOa9AiazWsJ4YsXKKdW0hBd9udPAdZ5gBsFPY0IpmThCxckM
 d+w/sjlvB7lPRW6SJlpgfrmgbhQRl2biOpiFRFGop7ddFYtU4ds/gx8zNc1AXvT8ls8+pJ3NuKX
 4elUl80EiJtZ1fLsa5t9Lxs+eB4uaZcrohQ6nJ0oGaHtxQ6iSMRw/p0lTL8ibXikfaO7ZbZikIv
 45CwgilfmXvx66EnWu/mY4fupOCdml8JjvpCU42I6GqBWFqndvfSVrM5Fpe/qJi5Oz37IJ3LxZW
 kj5qahg/0I+2tTtnPr4e6o1oI6jzBJBckWH0kUvGaFXXSJOcxPl9jgBNYZOPMxoNT8HD+k+olvS
 0Oxuf6QMjvVmfPSEdEjPtR4A1UkcjWrZrTq3ROnlFh5hM72rtpEKw9MHAfnIZ4R3bCmnhdSPedm
 wsbNqNsajCKbSiHFMDg==


Peter,

> Notify the ufs phy of the hibern8 link state so that it can program the
> appropriate values.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
