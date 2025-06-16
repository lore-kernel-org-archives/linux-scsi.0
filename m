Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A4F288CAA;
	Mon, 16 Jun 2025 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750098914; cv=fail; b=SAbcy/uGP9HDyyif6Ve05MYQNlyXc2EQKYkTh2FIwKB6//pEMeKf1I+yJtyz7whVAA0xKFs90FHOEJQY3NvcrcQWh8nDfqP4mTRg+MmHrY/UAAmcIwashcrxC7poXncSsO9qjhilSnWXdqjeNegk3730355EcIqZg2vcqyNXX2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750098914; c=relaxed/simple;
	bh=RV0T9CYSmMG49LU0UpGkQoyucnddQHeUIrGd4kvmwJg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Jh/KGbsEs7u54Pa0/8+Wk4T8NvwNvSaIuig1Ji8OIrB8Bfaov9ILiNnY5/oH9FZXqLWqZ28ZfRXwWY4sMlE29GTNQhO1nK3Pvn7hK78mnUZldX7GeZXgkJSymxMw9VYnsLGj6JXOSif/cis8Ls2rzqOSHo6W2OFQZqECMzUnFOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iaRcbWT9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gSkjv06V; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iaRcbWT9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gSkjv06V"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuUKk027735;
	Mon, 16 Jun 2025 18:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TjY2GouZs2BbpPcAzP
	JB13r4wZTA4LVW3R/Vowxiv3c=; b=iaRcbWT9kiHxWGkIlnA1kSkLEZXH3St4zT
	i6GG4/rJCtdvnixPABQo57QeNKC5/bVusJnl84AqrMQ1TWlJC+zoqq72pK8ZgBe6
	nZD93rBjwi3HaB3dLscfafcx+7Op8HZmv3Q6S7WG3QeflYrgp+LBGQeUOVerXrZq
	8llbKDfiD0ix5KjmmquJIl1UPAWEeLQNMqfGL16HJUv9x1RKyIqtNmy8go1y1QhP
	G+dlpmMXo3rNTDfF2zRx2sI1nA+EJI/OR4SEoW5dIo3yXdwYmAaENlZ67IwAA18z
	+zd3t9BwoLF8tHAeuzd9eRziBbFnuOQF4914+zMW5k0x4cb8blVQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4791mxkgg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 18:35:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHQZme025950;
	Mon, 16 Jun 2025 18:35:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yheht5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 18:35:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fy4kGAGDVep/rcGFlyqy2yklRF0gBGhEGifIaJWUPIczUcS+zQzrP6FOdpPMq4kOYUUIvKjwd7Gr1ff8zCT47qYxoJDFZdFr92zK3mMrcwUgXhBzKkbW/IAL2kfzccWwm2SVeTBiQLrGqj/Ysdkq9u0ewVdDYlcsu0UVP+aA2YPmF75LA769qUyiVtBOSZ0Ua4IFVKRQezWBkA3YbJPp+R3F8nQlXychvZF+t+zaYv5Uhcay6kH4+MzbQ5Llwqz1ErWCcFUmn2SoGX7VCQssLZhujrKtlzwybAL1EhAEWfA2hFspgbbKP3GI7Q3DSZEf7Ze3QE83XbVCX+yVLXjkrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjY2GouZs2BbpPcAzPJB13r4wZTA4LVW3R/Vowxiv3c=;
 b=nifa8L1VIcjY5O8yu+LM49QZCPrHwIcExSijQBXHiMElnXjx3mR62emluL74SIN7nRJl9+RW+gLJQIZZObgIKeHfUlrbfz0drBw+hiL7YhXACRpBxEa0v8e/Ko2y3/iXFriC4buNL/iOZ9RezPtIefV4q+Q2//hy/V6QUQ8i50We9xUWYP9ttzXwo929duGlYws/VvHexI/YEg+Ysoqe/amBpT+vBomM/If1ooniYhSk5EAtfzWSscpH4iJGZwtMN6AjsY+z5HoAA4T2UHJQ4CGjM+fvWitJbadr/OwaJw1APT+rQ1mJ5VR9t/+/ljsYn3o587/iJ1hHxWuc8htgDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjY2GouZs2BbpPcAzPJB13r4wZTA4LVW3R/Vowxiv3c=;
 b=gSkjv06VLlDkkU4FfgpudhnHWVy6O29UTc8Zo1gOV2WxENrU5qM0tlTuHviqdDedKzLS/VQv2jHwtlUREzbwhDFIGiw1TI2UvloVzG1aDHS21d6zxYiI53oWSt8/Ke23mynU1HyhtRXF93brDK9qF1OpAdUjKF2HAs7TExGhUEc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA3PR10MB6969.namprd10.prod.outlook.com (2603:10b6:806:316::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Mon, 16 Jun
 2025 18:35:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 18:35:00 +0000
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Yihang Li <liyihang9@huawei.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Don't use %pK through printk
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250611-restricted-pointers-scsi-v1-1-fe31bfbc4910@linutronix.de>
	("Thomas =?utf-8?Q?Wei=C3=9Fschuh=22's?= message of "Wed, 11 Jun 2025
 11:58:06 +0200")
Organization: Oracle Corporation
Message-ID: <yq1wm9bzgah.fsf@ca-mkp.ca.oracle.com>
References: <20250611-restricted-pointers-scsi-v1-1-fe31bfbc4910@linutronix.de>
Date: Mon, 16 Jun 2025 14:34:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::39) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA3PR10MB6969:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a6ea79-a421-4bf3-5d7b-08ddad04801f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7JKIhb+NONsz5AC4ifKcp6fIvO5MXkSwn2AfvTmmqfOcFT9X74QEqhbo/jXA?=
 =?us-ascii?Q?1/tP0X+3x5/R3NqRWHnJLLnibIfK5DYf4Ebr4VdgD7aV5omBoNCiSSFEoe1e?=
 =?us-ascii?Q?qsLYixhcSnyXUxPKK/CiNmmdVo+8UISdBzPrVnLSCmUrWwhIcWuewTeb1Q98?=
 =?us-ascii?Q?WosH1c0RxicZjjoP9q/SoxNEV01IxDj/xwW2I8uThj8FaeNnF7vBp1BEggQJ?=
 =?us-ascii?Q?228IfPf5CxBeO6m3KM5eBuOC0GV0EtPi6UFXNn2t0WVOE6PjXzLcssQmw7rE?=
 =?us-ascii?Q?CzWF/dwlE9NW3K/G5ul5977zy4QXTGaSgepXVCi7AKIR8RHuGgPcE6LRkIRq?=
 =?us-ascii?Q?o1Qfro7M5e+Vg+KGgF1hfusYPkMOVpWTmS42fhwdjaqMp2hz29NKsudYScug?=
 =?us-ascii?Q?LxhfPsSQWk+aAPfwG4AXQWXzMcwrCYaZDxRPyfQaxZKXfitnlWegpFyfqVmZ?=
 =?us-ascii?Q?0TVQsmiQcE0KMmfC93I7AKWWa3BPiGF5GVYdVLSV7IhrAz1cJ8yyPzSpCo7r?=
 =?us-ascii?Q?rad52qmjxMg9zbskPjUVYTiyMb2KNTAbxeFQO2oaEeIvfamn59Lq2cB3ppy9?=
 =?us-ascii?Q?qCPhtySYLvGI5Ok/5q9TKywKeRzkYVkJP2s707wSSp/g0vwhVbYFVcPA6+eE?=
 =?us-ascii?Q?7ewaklJHp6WS/Es+Cp3UbBjjvggG0ypOZ2LQmy2i31YDmYCrLp2M2Cj/omzY?=
 =?us-ascii?Q?eC9pjcg89dOwSdIXJNJKSWuj/7+sw9MOfUKoThRyXWwCVpc7EzHvD2AnZ6sW?=
 =?us-ascii?Q?X9vVNUTiXUwKXp2EIDRfLEoNRB8FzO96Dpsm+KX3SdN46QP17oxBhww2IdnX?=
 =?us-ascii?Q?2BmYpSETJfncG0RUjJmO+lEpN8BN8Bij5J4Xlepy47OgGspbh2ZtxwZK8tz0?=
 =?us-ascii?Q?gtRus9668+8afbzMWo2Z5R3kJkMDqxRM0W724BvxQNPb2xswn17GHg9Ai12Z?=
 =?us-ascii?Q?qbO0cgM8B23N3KjqU7dwTwfnpSQgwOdXIRMEBYFmPIeVruDRsL7eD0ZJYx0m?=
 =?us-ascii?Q?y8xbCJMnPOpLjNdatTzZSP8J4aHzIyxECSPSy5DWj/fadDiQfXiX7i5sW2os?=
 =?us-ascii?Q?Rh2hf5fb+sDzTUM4hOvo6XS2pdamOPIgLvOkJAcwP1kAIT86QCQtjBhWYG1k?=
 =?us-ascii?Q?ITDsHjBnD7PgksW32AwPhN7i3AENQLvztqDJ39KZs8dZI1wScAr1EZWgos5C?=
 =?us-ascii?Q?YZveqzc2VAwFKaX3mplxTBUz/oySr76EHIXem939l25TKf+UQu1xXeV4wpyc?=
 =?us-ascii?Q?AAf4Acu3T7yvMmitaMr/MYbh2/gnfmsjj+A3pCGul5zTWUlfktb4euCRxNbZ?=
 =?us-ascii?Q?pGX1BjFW8qVD14QO4/fbu0n3GGU/muVdPLBLQgg/a9T7E6Ys4Ji/XZpCMiEN?=
 =?us-ascii?Q?gKCGBw62qRWa6bPgibqt7dz/Dp2DmIL+KvqVOrZoYJpXSP4z/R5QU/bNaIxK?=
 =?us-ascii?Q?1CczZMylZE4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qpVJXmwfHzP2jn7biGV8X0n68dPoT563GU7uy1LJPBsaVQUxuHN8HZzJcPLI?=
 =?us-ascii?Q?6ytRhuh1MsRBXYu+z4SzerBBq+aWpKJ1seBIZH66vhje57uDg9W2+DtglElx?=
 =?us-ascii?Q?l9Eq41G2ou/CYYFaqT3SlDYCLfLZFz0Ye/bS+hLEuDAQ5Zpfwjj+1PkSxrnd?=
 =?us-ascii?Q?KznvcFNKz6T9un9jer1mTiFA+NWnks+MMK7C+dxkOLNTqkp5rtTQ518Ps/+C?=
 =?us-ascii?Q?X5yDSWY1hDvZbyIucDnnpSddlR03PWEqZ6P+SptACDie84hcqdxjq+ge0/IK?=
 =?us-ascii?Q?n7Y/pMU3I2/Wjrg0U/wkyrTVPsj8NOP5fuaXt13C97lLN5Rt5EtMedXy8ze3?=
 =?us-ascii?Q?i2LBO6T3fDtP57ct2IjKLB3HycZ6kRN9HBD+FVJ+FzOaB4nI39uoKC5iOHVr?=
 =?us-ascii?Q?3UB46+a0anfSLIVheorx5rIDq0CEO9+p8f7zw7NAklJpuSBKel/Y7Z/c3jxq?=
 =?us-ascii?Q?ikxymgmIa5RDLGvtHt2gkZlbKL3LdbGheAEARKztHbtLZS4PUoZnGYEcsdbT?=
 =?us-ascii?Q?aC6RVcDKC8vaHt7MwgNgHu+/N5elsr65VsEG5o11J/QWgRnyB4sQxot93gW2?=
 =?us-ascii?Q?jTdEqpPowe6hEC0PM19CmT3T3yAMWC2Hq+i/rOvsIhV2RkUZ2IbNcoRKAP9+?=
 =?us-ascii?Q?Ik6fOKGvNezv88k36qvSiw12K7B5RD24d0kirF0siwxxJdFBhjWz68zt5kcA?=
 =?us-ascii?Q?Xs3xSX3GCuYl7jaShuyEUqUIu7GG+xl69vj0FGsRONZx8gG/yEym/jp9LXLP?=
 =?us-ascii?Q?PpP3/g4pjAgAjrFOgoazybXK/GRhjaD3rW4zH6TDoB4SW7FEOt0x18AhxdP0?=
 =?us-ascii?Q?4MU6Jku9TxSLdmYJe+JuDZJFjRvt/1Z+alPEVPfZLvudcg6urOgRDv1Kpyv8?=
 =?us-ascii?Q?zAnP7jNcfgq9ePDb/k+yKryiepzBapmOxCzxtCy6nib+IzyQ7652JtEvunIn?=
 =?us-ascii?Q?1rjVC5OywtdPeBlw8rpfD9Q7GYoBU1McjQS2z+229+EX4/tClMrJk7Xea4E4?=
 =?us-ascii?Q?RquRf/Tn745ZUuIexEl01M5STuhN/b8MkYx2/ePDLUNXWFkJD15dq9zC/91K?=
 =?us-ascii?Q?8eMEKOOUijIhQhU960I/tYqaCm8kxswVqb7ycDPQ42Vu0yIVcU4GHImJqtkD?=
 =?us-ascii?Q?MOwSJF1Osy9lrf04VQayo1q4duaYgmNVKDylgDYowzgkFkM5L5cBXfr6U9B9?=
 =?us-ascii?Q?ap4ocL4cL4sdfy1OXIomODJol2LvTB54pmtLGivvKfZ8Pn1WjcX3BVQtstnm?=
 =?us-ascii?Q?iBOCnTCuiu3bhbV2nG9HaWS+oNY18hbqGT3n9RIZrT9+KDJESiaUHEPiY9VD?=
 =?us-ascii?Q?JqAhpTdack/ja8rxbWn8hkBijK6m/EIddCw2xffNer0IfeyKh/ox/nzocltl?=
 =?us-ascii?Q?Doqj8cZWOpNBJ1aQ70JMvsoLdoj5r0LyOuhfS6CEBP4+W7X1/tWvxJLMxe7a?=
 =?us-ascii?Q?CHi0TQPFab2QgO4VFa2vwRzTdBE7xJStTaYXh38kVpGVQEvNNOEJ1OEzGA37?=
 =?us-ascii?Q?6DdG8woeiZnh4BfXbUL3NoCYq/X856jtF6ZepIjn0nQRDnk300JoT8wSds6x?=
 =?us-ascii?Q?uhjqt/71j5wiU7wyeDTPlwvcDPWitwrYb3dTPxEo4x98dTDsagxWGx7Sy+DI?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l04yNujB+NLftYW1d+grezAw91VMwkPSd2NAsFUTjeoibjwgPoL8JYB9Ud/UZ64qKUuulRuQ8wY15FAh0xDIqesPzbt4BDu7CLFd78ziPXhoXKnC0kW+Q7wujYg//DFpkc+tLLYrX50899UiuaF544Fv6vtZvz7JYmdGjkwkcTHCEOwwFtiUy8HFrnqCM+l3oBWS8xOaI+iFOf+pKQgx6ds8DdKpB3GKe/oxix6rVWcOdXl3IiLyeqalbBjleDDObxyHcWCSk+huisEv3OMNFfIeqriQsAPUUF1JF6lLTZxYFDDv6c/SOdI0FocVXdo2+LG0no3ZrVkWF/gi6mzCb4KjKJ9SV2tYEeTWGL0N0kgW+O6RPPi7CZS8v4Bf24WTe8L2FDQSFLcOrnXi3NMZ60XIhVgHkzFQ880Zv5yRUrAKGgW490w0B6kYdDL2AtBzh9oJoRGnVIrGhkW1JmRUiRiHgOGF7HttcmlEvDF7lGsOirlWR+i27z17DxpKWOnkZzQ82JSVJ1US/krHaUywn8FosPSW8bIcEXVI6rU2/HTmopaJ3eW5x0n/fUtLXTeBZPv3SnQK/TJe8j0xMLxIUid+s3fuuI5XDMdX4jreua8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a6ea79-a421-4bf3-5d7b-08ddad04801f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 18:35:00.1141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PLAPrq+wMDHq0WkJZbE8PSAc47TaSD75NCNXbK/jIqvsGyeRZp14BAD1VpXIuL2jA68lo59tcoLFLeurjlYTX4zH7f+dPGU2GgJh4r1dO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_09,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=810 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506160125
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDEyNSBTYWx0ZWRfX7aW/wU/34bzO SBjdE26IarSP+SOUivAcHeOBbuvpIWeiKw9Z0nZ8wWsSEo1OsoEpPOiOcOAKGImxmA2qNdjveKS 8xYndQnKobBIeg2rVT5dAG5F06kCjd12jd/BEiDflKOMr4hLFC/r9pqb0ktvN3+r0B28vsR1Dpa
 ktf7EihJ3dqV01yM/Q1fngm3faSMbvsNS8tg7OmP+UmftcbTsi34TA9TureEI/m1p8FaebmPmvq GhYXNE6CKZOIg6PPLi8pTSKoDs1bUuL381nWV7Pzc2sEFdDiV7dIMiN3piBUQ3JKdbnuIvGlyZz aoDFE8vK1LK3utrIQAWOHZDqmMYekpXpMu5rEWC9A5z7UkGtX2Nautsh65fdXb0k41QHNrsQLOs
 Xjxpf6mL8eGkHdDoQ0Xz7QuNvT2YdVj8j1EQOMtNT06ZyScSa2EotZEP6UOV+7/6Cgysvgvj
X-Authority-Analysis: v=2.4 cv=HvR2G1TS c=1 sm=1 tr=0 ts=685063d8 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10 cc=ntf awl=host:13207
X-Proofpoint-GUID: k6pjLqrXPjD6sBuTLm9Ro7KLBKO_0G3q
X-Proofpoint-ORIG-GUID: k6pjLqrXPjD6sBuTLm9Ro7KLBKO_0G3q


Thomas,

> In the past %pK was preferable to %p as it would not leak raw pointer
> values into the kernel log. Since commit ad67b74d2469 ("printk: hash
> addresses printed with %p") the regular %p has been improved to avoid
> this issue. Furthermore, restricted pointers ("%pK") were never meant
> to be used through printk(). They can still unintentionally leak raw
> pointers or acquire sleeping locks in atomic contexts.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
