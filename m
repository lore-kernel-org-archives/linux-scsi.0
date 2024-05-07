Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2965F1862;
	Tue,  7 May 2024 01:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715045935; cv=fail; b=MO4/Vj2pM9mdDlCQ2bauRZv7YL1i/5OEjs7TbpCh4apuwO1YFaXujR+c/59XshWKzBnrAnEvCoKzoRLxscgOO2aFFqHkygWIpeNBghxrRNyBVQyJbWpynGmKQTwHRzyXOHTmHkGeNXaNwqolJ80iTxBU524raEq/lCHoVxi9BfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715045935; c=relaxed/simple;
	bh=FT9PYkP+OIEGvgieOnfAztbcw3uk1MmB58o/FJR/HRw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=aar9H9w97VvNhSAT1fGCejCbuhnCli4LKTmTUK3lXph+bRpExBlgStL5JW1kvPGljfti7GEC7EGqTuQE2eTUoqsHPyVHy5d+8W5Aggmku7nqXdWaP7ArgUzLCsaZ1T0ZABOGvm7d7uskOYNAh3VTB2gJAIuNfnucZXaUkBmf8C4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WUgFXnJ5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FuFvVG06; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WUgFXnJ5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FuFvVG06"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446Mn0eW031655;
	Tue, 7 May 2024 01:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=m9g1VZVHPd50KLAaDmTb8QbNapaOlmRO68Knq4jVfBE=;
 b=WUgFXnJ5hHPtYH8ViBpzZtw9slEAarEmcCAChJA/VG8G14pygOO38/6EB1lRHu9o7zxJ
 IzQpKvVhfK4RwcEwz7qx1TusyjmM04QIhxAFiH4taJzPPeIQyeFuL1r8xoVtNUCt/6EK
 GHxSgip6FsLEORjnZYKcVQJ+WUQhpYOE21/dkf9uslOOS95LL6sU0UlBkJyOZ7fWypa/
 JlCiioPvj964kAbo5GcI/m4BTVK4fDfyrYbEOMwsA0qLxjVdmAVw8czTcB1Qb1QkSGCB
 Ng+2heluYWnHziP0CfNkIogPRjlcXvm4Hs1Uv5QEko67PhFIks1Q0W06xqd8/seA/Co9 YQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbeeuun6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:38:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4470gicV029257;
	Tue, 7 May 2024 01:38:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfckte0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkfKV35asn2nKTkMAAbx/MdX9Fv+ygogajoNnfpZXQE6p+USShFV9H9j19bGpoU01UZ2zesEzJQg6tqUo6Sh4nk29OrrgtcqDFRpOBK8JlUjKJhG83joUT77ZVxcdkxe+N8qZhRtZ7xYYiajRN7hL2kR7VgmuOW4sY8G7jJd8eSxc26SZNvECLq/QawPHzN9VsY7zjuerhLqNH8pFhY+x3RkmRI4qzYIxG59LQvZWkLjL2MIW3BkzuI42fEy8QuTRCEBY+GbEqLWzZrWyhFw8dywSbWY8f7lqcP4BzeIzoGtVINbKHe1vroC+QGmLmYLzUjYOB23eJCsCtIb+NB3cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9g1VZVHPd50KLAaDmTb8QbNapaOlmRO68Knq4jVfBE=;
 b=NIU4XuEu4NbWIcNFev5rxEDoJznnIul0SKlN/sQ5Iy7sVV8eLPXtlYEY9zlxD2FG9VrSSb3VM5l38p/i5KFZ5/nSNUWQtAqlGzvaVYm+qFbs5anNwTQ9UBid4PYM/42wo0tWE8wNuy3qbxBe64v6K1bI4LMTTdcZzpJDWuYor1cdwZCuquSm4W3nqywjS5MAgdqBlI7/TtHzvpcr6tNPGDg5egelk+xmDod60fx0zXDEs119TN0U07fomlp923dcEOyJG9suCxu4qyrwNm+drnng+VyexniA8sOyIqdUb3E/tbEvm0VMpaoiQpBaym4rJnqhJcIMkwvgU4+ilORFGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9g1VZVHPd50KLAaDmTb8QbNapaOlmRO68Knq4jVfBE=;
 b=FuFvVG06FgHk+Bzg6fKRwsSrCQw3JaOZCgUZbmk9sggXK4yM8afBc8J+D5tqNwA/YyiAZBY3Za0t5OlIKTEKiC7erMRG7Vc8KS2Y5pNO0V0TybGZFVP8EL9/hBfN8Cu8WSbV/hPbTlf5qjG4VJYwRq5M7FOx7DX4rEZ6MKWA+GU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 01:38:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 01:38:31 +0000
To: Peter Griffin <peter.griffin@linaro.org>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        tudor.ambarus@linaro.org, andre.draszik@linaro.org,
        saravanak@google.com, willmcvicker@google.com, kernel-team@android.com
Subject: Re: [PATCH v3 0/6] ufs-exynos support for Tensor GS101
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240426122004.2249178-1-peter.griffin@linaro.org> (Peter
	Griffin's message of "Fri, 26 Apr 2024 13:19:58 +0100")
Organization: Oracle Corporation
Message-ID: <yq1o79ixuya.fsf@ca-mkp.ca.oracle.com>
References: <20240426122004.2249178-1-peter.griffin@linaro.org>
Date: Mon, 06 May 2024 21:38:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BY5PR10MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: 7263b778-c098-4eff-02b4-08dc6e366708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Z/IIJFvqxZl6YC5IPInQao46zz+BD5nbnR/49ruHglr36eESfTBGUv94BbNn?=
 =?us-ascii?Q?WbCK6952cSz2oxhjwz2xMkZDOpZMgZcuM2eLH4/NpmVY/WcivRU1iJeuvX5o?=
 =?us-ascii?Q?SRkMvEkpD/gAKU+6JOTCioN11P+rdRJjf9vwhl8iHQHsR2NnYjzG2lrsA43o?=
 =?us-ascii?Q?6JQtaMKoY6mxxVgBiRqUa8KfyNCmHlj+aLzD81MD0QLFXh/u3zKBoqkbhamf?=
 =?us-ascii?Q?WIXIOEx+8u/e4TXzPscScMkjxtkioKhIXxvAMgWZa8g1dOZPubhsB+4u5OOK?=
 =?us-ascii?Q?sLjlrk89ELVZEpy5t2lwgHo4r9C+YDhblXVYQU0Q0nga7dED0OhSDOh2s5PV?=
 =?us-ascii?Q?QoDAh3/xOGO1h3ys0ts24aWPNNj4OksJUtZnkePw3ll3IEWKiUwdUC+q6pEK?=
 =?us-ascii?Q?F7cUIvbjwA9aT74syZHbc7UOzg8WijU/VvemT41aMIAWGtwhOVZEH8gQLFYm?=
 =?us-ascii?Q?S8pf3bAT6EGbw+CkXsnvbTvY08h2R3nsG7nsO3Q+WA7F4vFthgciYr8G/YV/?=
 =?us-ascii?Q?JrrGCnpWaaD/gT2DVu47cVzExsbfNJuyDuGzRyjna3jiNSTthjqcuxB3uW6R?=
 =?us-ascii?Q?NMc4EjaHEOmtfBGa9bWb5SCovLeyr3NXv/Ikywu1qEKfB2ZWkGzGQKYZlBce?=
 =?us-ascii?Q?zS2CoAoS5IkjKCPG+c7AJe59TFyoY1C2caNm5VadUlGmGeVvt8HQiZEFlIrw?=
 =?us-ascii?Q?CooWLDyibB9Sw0wvDAnoA8R2TSmLCETOWXtjBR+LEWVnjQXU3XSNhqvUifEi?=
 =?us-ascii?Q?vauHfZfyNsIk0PCMjSP9jIbqc+Ua3adoIRHkHs+CSOp9PYSYivLyOAnCSyBg?=
 =?us-ascii?Q?YdkFSrDHt6ihRicPf9gYPJPqrQNSu00raTLHzhtPPStSVG31KwWSaGjQQd8n?=
 =?us-ascii?Q?ufGGa19YOjeBREdyxWKOMGbyVx30RK+NPMty7LQpQCOHQdI420/Qu/14noEC?=
 =?us-ascii?Q?dTvcukhf8Ps9a6KgicXPDX+4zcjg2LnBTVjNXxEOEOTqfJUegeBpt3DnPWaX?=
 =?us-ascii?Q?NKU/X7yQRj0bJveMd+5fe7jexMX2CRO3XHIeiLnpMSQKjGiCptAeRAKpMcho?=
 =?us-ascii?Q?pTpsYwamoVjn4WGM+L3H3msW5e/XF7FjDhCRLwZRa3lVRNX7YjSq90n+bJcj?=
 =?us-ascii?Q?yvgRznxAG9HqFHLUWqDpbfM8SjzVpMzxhInueXRIW6GxFEtJCBdwSuBWIecl?=
 =?us-ascii?Q?rKf+gwsC3vbwbK4YX9TLDpOLPo1RFH8rybCEe/tOX/y42ziaTOKQNhtkKNIc?=
 =?us-ascii?Q?OW0YhYveOrIASqvhZGLPyvBGwxlpxEjyJxLLGHYEiA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zXpZzDJWnEZDhIxErHsAlVeFabcAHpUEnoU5hXEYJHfHOz5UkGVv3H15SZ63?=
 =?us-ascii?Q?Zy3gt66PUOhwL5Za4imHB9f6pbB/8BPKXcd+kUe+sdsVOvCi0GyLLonM5GJj?=
 =?us-ascii?Q?itcnxvqaGBfFVq4fejrUMBy2uMVJrOIPQ6uiPwq2XBea/qf4JGC8VO75yXAe?=
 =?us-ascii?Q?F8S4DUaVConqGorg0oyPs1YJxjrB1o1LkT9xx/LS1eYJWvi59+3NOyCTX5s7?=
 =?us-ascii?Q?4e7PKugYaIINROziBNZJ4xXI2HeoUkGdksqo3n6aloOIfs5fIb1jteWBDuVa?=
 =?us-ascii?Q?Z5T6S6YhTev1KujVHZJ8j27qVntJsiE81Dw4ukE5v67en48IQCTR3PF70YPk?=
 =?us-ascii?Q?pGqY+mwM/GyjYGwTG8RmDUHHpM3IIBPo4yujIRfPNnvcK4J4tg0sWyHwiZrv?=
 =?us-ascii?Q?erU/CrA3J60aEy8eprcIdoc6UGV7VWFRLj1LrZyQfr+rGAybHLhsjav+SvAQ?=
 =?us-ascii?Q?/JbuP8ZVgoFmuzNosCbcty1m/fVQPSwCFg+BpnvefXqQCk6Gt3JRAgEh5dEv?=
 =?us-ascii?Q?vU2PCLHeMYDxAcfiy18nRgXdpX2NJu9eOlcZigNDUq2YbbpUK7pBqcXM8zn0?=
 =?us-ascii?Q?u/txHR7i9MDKbiaBcjo9zcMcSDmPsrvpUnsL0poHkqqCB+Uz5YE5jFmTi+ZN?=
 =?us-ascii?Q?3/fCsBNL7dShD2WLIOKEA9na2lzckGfeUkIqm6etRnfKuyO8C9K+Bh7khwDb?=
 =?us-ascii?Q?dKShwXPB4TM2Y2RUPHAOT/WVKs69DIRCtsR1V1vCIjCmJy31mG3LyT01bGk4?=
 =?us-ascii?Q?JqLFUDInw9F08z+2mcLwBTYNCS9MpJMvO4URFMYfmY0KOFymTfAEpLLBd72x?=
 =?us-ascii?Q?HRIkttXNKK0kTkVuXWl0cjh7n6X1dHnrxKZQvHH2cG7p+rM5O4Yt0Kpasia2?=
 =?us-ascii?Q?30CP/5VxT1xsWVgRErR/IiTiCLWAFWnHP7AQn38CpwrLQS8vBTzrE7MojjAH?=
 =?us-ascii?Q?EyCHrwsUa6ByA4gs9Zxnw+/jQqQz05Rf1dmfuIUhKIhNsaHxndYe+jaYV5yl?=
 =?us-ascii?Q?L4+qiqKIkqoraNwcFXgLr11/DBhrlQUgOF7hGKlYfayCZxYcGKV/w1hs/8uY?=
 =?us-ascii?Q?rm2EZ2wnW/IauAg0W/ogDOgFEHTsm1B7DMXzEzQM7OLbC7u6BQwGHeFBppLb?=
 =?us-ascii?Q?j4hHNmx3xBgv0q9aa64up5BTi5hhktD9vB2IlO0jPj+vlOoA8yfbLHyHqTrW?=
 =?us-ascii?Q?wK2d5EFugABkHPWfMIohNFl2p48IGgjxWzj7d09bDioravsPVADakTnCPHPn?=
 =?us-ascii?Q?LB5Sf1FSPxiA6hkbfaFqRTFddLvh8EfCcj2h8y97XNjzKUX2QmgO+IlxK9tl?=
 =?us-ascii?Q?AiA11eM7dnU5kFhWQW2IqcUsBMlL6IAoOyy3rS/VsWnML1ohKLHcbCLEPhOR?=
 =?us-ascii?Q?SVufKVIPrb4GgrD9C3Fb6CQzmUuM9nmptp5KxPkp37X0K7u3PbhRMXcWMFTM?=
 =?us-ascii?Q?KcHxBljW6zIh/C5o6NNlISoTqb0z3JMui6XecSmSphA8CTdhmaR5L/2kZBFE?=
 =?us-ascii?Q?w1pg0MLphw7PXqMdkVkfjX/KpnX7vmncOoV1HHoppdwHd15LP/nfBdHgyQxU?=
 =?us-ascii?Q?vHWoT8lNwpFt2DMDaDDOQipTC9SSMxDbe3f3ZtFWBupqS9x8KoBKa1E5yXOb?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cpEE0ZxTmg39w4B59UCKpqp2RGrRrZOfGVolZm92Gd4paw2udoiM5ilZ9KcmvTdmU8I9ROC08tJUfYLFlPyFOKnNDVI/E1q5zdaQ6D4FGjju8Um0t5N7+gW3y818HAvY8vHmV5BGtFENQ55I3d4jnkEsvM02xB7Y4X5rlq9DOJ0wWxCqMXgphn8aFIH/8+0kaOoCcIAYWb0ibEZY0ZfoEa8QD8kTi3oShuMogXpf/9gdWRi/mMOVx7V37kaJfsVUGgPphgfIsk0o74ZzmUkQ2kxgK7AE9N9zhLKzsNhrNdF9rUKTgLZgbBHNWhppTOsPRK3B03ZaFymhqsMR0YolhKhaHIiQB4u/BUDfkw4HUWrEnk71gsAw18m6NPJ399yf6f4lVmacHbSt6xTiCWLQRiCB8A1gpQi2X7bBZdULGtY7S53bIUWYPc5e5r1R53LhmSBdLp68Y8NoZNtsedGqjYizWFzMr5HZ9rBdwzBSixEX/9uQDxdIZxNUJ8iE6Iq9ixtCvIS9RNVLY9Jdsr3XB0QHys+SrTTP4TOhG8lZjpXJ7wK92Bgewc9WJhud1oGSMXRFaS0NBNnRetu8iQg6U2owB6nKc45Zrvbhc8G1Aoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7263b778-c098-4eff-02b4-08dc6e366708
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 01:38:31.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZagO3H4PLhPY1ftL14EkZ4Er3+5KBnQyXufdpqhb7hjIgN6HHhOUJ4dbYT9oR5dgcT85hW0+J68lvEXCo0ghAhUWtbHDLKkQ8/xNUqb8u8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=930 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070011
X-Proofpoint-GUID: PQQPa2nZJDKgVdcynKQXE350YVCUuaMj
X-Proofpoint-ORIG-GUID: PQQPa2nZJDKgVdcynKQXE350YVCUuaMj


Peter,

> This series adds support to the ufs-exynos driver for Tensor gs101
> found in Pixel 6. It was send previously in [1] and [2] but included
> the other clock, phy and DTS parts. This series has been split into
> just the ufs-exynos part to hopefully make things easier.
>
> With this series, plus the phy, clock and dts changes UFS is functional
> upstream for Pixel 6. The SKhynix HN8T05BZGKX015 can be enumerated,
> partitions mounted etc.
>
> The series is split into some prepatory patches for ufs-exynos and a final
> patch that adds the gs101 support.
>
> Note the sysreg clock has been moved to ufs node as fine grained clock
> control around the syscon sysreg register accesses doesn't result in
> functional UFS.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
