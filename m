Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3EF2882C5;
	Wed,  4 Feb 2026 03:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770174369; cv=fail; b=DXwYMsrl/YMGaB3Ar+CoB0/XA9jEsU4lFdLn3e5tLu7leppDCldSM0kZ4aAG16RAi1hDE/oGirPPE5GXzSiYU5CMVa2XCzkL0t0INMJ0mrrfqgGEjAQxTfAr5+l9lrBCZsbdm+xC5gJ4VSj8mRBMQ7J3dbOSthsXQ+rTAE+dr7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770174369; c=relaxed/simple;
	bh=ppqHZzNdEScM/9zDv0vueMR4ZEc0HbFfZgNUDoSv0lY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UTjh2047Dj3Smt0OpzTwmJa0muOjqlAljRDgaHPY/7YEFZFSNJFaa1A6VohmNx2TYBrwHajseQKQxqCHNv+66mBwNqGmzDmeOUv3H/vHAEf8P+JnPKIhlj1NbxxMSHxj8pZ3nSaj7CR8EX21nGJoU4kr+7ICN4btjT++Rm9ClM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PjvI1GrI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oP9hu+RT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PjvI1GrI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oP9hu+RT"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuOsV4088127;
	Wed, 4 Feb 2026 03:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=x9b9dYZjIYhUO3mGgJ
	dZD81d3NLNK5gs0T7fRWlif2E=; b=PjvI1GrIQjUiKxIOFtjMcwR0ZYPbjomkwu
	sL79sBtHF/8Lj10ebcTYcv67g1Frf1ut3nPmImY4a1jSC1HWNMoACkh1hJYdEAZY
	CbfkkI+q6ImTRS62Ti+7H5o5pFUcPzzC0yqFKFbGbnhRvq7okLwyQEIGs/au+eSq
	YM/yC1Ho0gfVxvYvoJYywQy1b0PE5dIzOarFLNsFuo78rw7HNU/PJTJV4SDdbscw
	E9DmCxQmQDiHbYvtd4NBvPMJqq9TGKvWRI5YlG47vJC7MDaD74U8mflL/3OyJrOR
	rrb3I/8NwlLXM+EO5ALDVF6KffcmPxzqpZqGxOLLeZd7w4fvQ9Yg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb144d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:05:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6141L0JZ034779;
	Wed, 4 Feb 2026 03:05:54 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186atevh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:05:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pOhB5wMj2KtctjKuwqsm2e11Dx2xGoWOMcZraZvrAKnaqfimBEHCwRGMRSXe/++r9OO0m3Ml84JKXBFS38ihxCfc64/OeRI0BobY9qMOuxrLnR+KnoXZBaPz72xBVwlxCTYXT21vmXdyrpAdRjGpmXVBj8u8dRkq5WwB7ERQb0tELmjXc0JSLgt89+q9zE0Xi3A3q4WVPeAKIUQadjQk860+uqoRXEVpd1HaNcxj6UHdwM2+N9GsT+k7CsAE22zfiFdUZfc1sK01vb+Nb51zKM0E5h1X/Xi5QwymrrjaU8yRnfMBkCp5iydNvK5Q1IdTJnHKLxbpWNaOhVbph6wLvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9b9dYZjIYhUO3mGgJdZD81d3NLNK5gs0T7fRWlif2E=;
 b=qNoY4taxXYWwJ5Xz1ivj7R6mK8hxjQ4CXWW6jDuUS+vZmuiTrvO1WqZ37awR/yCB7c0LO5cd8/cY8rJq7PYS2ie3PhcjFJohwsvgmmPz0AHUSftsV+HTseNsviWntUHO05cjjnXHUZl8T4r6J/u66yUKPgN7gYKYhelkgeu6kQeUiRKot1HXSAXLo+tBRdXMtgNxLF1t4cwV1msfknN+dtyUxIuGij7h68OEJrNP+JZQpOJSsVLDkEmpBKRk2JuLBvhsqGwUdoxLTJmFyYNd8FhWJnGhCMV/ij0UJC25T7lQze4pOtITkiAlCm1opGNErKK9cWjFUcg0mg6LhiLA+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9b9dYZjIYhUO3mGgJdZD81d3NLNK5gs0T7fRWlif2E=;
 b=oP9hu+RTWbbZiUrDEWFF/LWoL/yZYT22wYLjdcwIOKy9O5knQfFbmiblcvGVNjet5n+/nG1PATqFpMz2vjmp4XBz+KQfUyyUXaZzIYzpCy2Jd06I+sd4hWyMU+XpKcyc8ANOe7NrZt26OSaynBm2tNP9WgVAw17nRmRx/gotb3M=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7139.namprd10.prod.outlook.com (2603:10b6:610:127::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 03:05:50 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:05:50 +0000
To: Thomas Yen <thomasyen@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean
 Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao
 D. Nguyen" <quic_nguyenb@quicinc.com>,
        "open list:UNIVERSAL FLASH STORAGE
 HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>,
        open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Flush exception handling work when
 RPM level is zero
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260126031921.2511736-1-thomasyen@google.com> (Thomas Yen's
	message of "Mon, 26 Jan 2026 11:19:15 +0800")
Organization: Oracle Corporation
Message-ID: <yq17bstp5s7.fsf@ca-mkp.ca.oracle.com>
References: <20260126031921.2511736-1-thomasyen@google.com>
Date: Tue, 03 Feb 2026 22:05:49 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:610:cd::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7139:EE_
X-MS-Office365-Filtering-Correlation-Id: 077ae810-984d-451c-18b9-08de639a4d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rYnBOOL5gECR/rngS1Ul11x/3HI5zMKstIRGr3Islww6BWiH5F+TCElgzoUr?=
 =?us-ascii?Q?lDiSPEsekbws8UAh9cJcUn1yOD203ZW5SF8zVbtzi5i5MdrmZ5O7OIo3sNfw?=
 =?us-ascii?Q?I3PxQZJe0dvmFaSuWvLBAVIaawKTKTC66IJQr635vE6S88B3evGgUY1phPXe?=
 =?us-ascii?Q?Uetwi7lbXplwJTuKrFoif8wjNqUBg99przPgHmboDi+OB1qoZ2hOxpLhA8vc?=
 =?us-ascii?Q?PUknV3p2qhlSS4uKo80Tmuk1J3W6ED/MZ2+GuQStkbVXG61MtYZYhAt5hGv8?=
 =?us-ascii?Q?Tj77rQHnd9jk5cmKbhBCm2hAs2SluBPFk2vpJvEXZ/+II/E4g8i5Ls765jRT?=
 =?us-ascii?Q?Vtx5CY3HnfQE1kNjHolT6wUP9uSgBlQef/lQwyT8zhVwJCZgHTrAadJM9Xl6?=
 =?us-ascii?Q?iQlNOFE+Ccg42sqYED9T4JiiwulS3L3+O4YqXpU12EdR+XfzZ2fpcKv5yNRR?=
 =?us-ascii?Q?41cZZ0AMvWvANCNLe2yjK2HdtLBo4sFLIajlhn5Gj2AqbIVa2g/lkc2MVsdD?=
 =?us-ascii?Q?g2HeIyvzqs/W5Q79pcXSPsllsL8SUI52Ka6VWv7dPwiT0SThuIU6ndxjI2LH?=
 =?us-ascii?Q?HNyJ7yDy696zs/HPykWD63WA9aMkuSaUO/mYyjIddG+uFttJCoC0Zt5F9zvt?=
 =?us-ascii?Q?JhpiUxJ4+Jy8N981LwtEf2fRFTZ8ejL2LnxEWcbGCyl+biFIGK139rLiywMn?=
 =?us-ascii?Q?RTmIy40WEPHiCKPGnk+t2hveLMW/9ngS8gZvPjJueBt7SwRrsP4ELd9I2QNV?=
 =?us-ascii?Q?TfsZwc1QrhCum/iAdcCd8oum5M1gWCgcEQksgyO5z36QY8Gbh/ECmo/HGLLE?=
 =?us-ascii?Q?Mm4QUHL9ZKXbqYo2RzXz8NWig9nhnV7oFHvvGxzOBZbcJzzm9Vioum6DntGM?=
 =?us-ascii?Q?kfTDcl2ki0Cb3iBn+kWtk/0ndWvqosbg9SyZc5mnGrlo8/sSobvRb0m/Kqd3?=
 =?us-ascii?Q?GshqiUGM5WmClUFkI+29DhNB3LiIkiJV+RLRqzWyVa3Y4EPq8aYTypG0pX/c?=
 =?us-ascii?Q?oJMwomT3pRi8ix7u3yxOFLck9Fb7RbVPuElzLjCcTuD4N85qcyigdQTmC/q0?=
 =?us-ascii?Q?2/Kol1xi40kb5YINd/3LueXgW4tckV1T99xNe0M6eL/vi3vJdgQipsJlxg41?=
 =?us-ascii?Q?oIzFEFVPzAUNvJOFI6cmkcKLP7JwH78z324rf8q80mThRNedPrmZtegA3HfP?=
 =?us-ascii?Q?9f8xw3LbQLBT4Q5V7/kGz8VuSFZDLclq47aMhQeIQxaRlYxF3YG4VyyemJ21?=
 =?us-ascii?Q?iZHjMbbF3HGQlltKrIi8GTHHdSTmEAiAgeaxgwZ5iDad8CRl1a00dyVmZzgr?=
 =?us-ascii?Q?OGcBrNMIGDs3avGrLQBlHzfESB2jMyhCJNkL3w6eNwcNJppYTNrUXu8qcsjI?=
 =?us-ascii?Q?88LA00M4EGY8x7TKn5FvIysQXq+fQdOyzOxhRQXgH7itfIIHPGTAn3BzanAm?=
 =?us-ascii?Q?cWpbHPR+eEU6dTuL8HsWqAmj1rqYdRo3XyIXmpMnYvqjn7a4ePCG7dmzWIIA?=
 =?us-ascii?Q?Fa2jdQCWbds+uOCPLTTWmP111L/gq8qw7ixfbM+XrWc+BcBpfbIIeK/+urLN?=
 =?us-ascii?Q?6okeFKNiZJOBd9TRW2Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4yHyG7xBrTFGSkleBUjPcvrmkUSWxta8xRpWKlxt1xAn+kovpgLmf0NMF/Vf?=
 =?us-ascii?Q?MstQbUICTCVPYxyH/WEeVbkMBcS6JFgiCSdRTwD+zSDxtUu//+Y5tQuRbD4F?=
 =?us-ascii?Q?FCcTO15ES5JGQsTJyRbiw9CXIBlY1po9etXswKBT746f2O5eGx/KvUNHk/0I?=
 =?us-ascii?Q?vObgQllbhNvJLiDs+fJJkusKLXJ+52ly2aeODXostoxrLrIz4S/tvBK/NJhB?=
 =?us-ascii?Q?5d3ObRVQ2acamPsJ0P30EazkP4FWFNwISyVgoQ/OWxPlRs6w9ADT7ahwMrUn?=
 =?us-ascii?Q?PBGp6nt6Hq/6ZK2jLEfGWeyR8BqQs6ltUoUBbGSHaoJv800nBLhxnkwc9o/F?=
 =?us-ascii?Q?h0baXKF+gd+Fljbj8M7zK+2hQlTLcxVQA6gPXOtN8++nPzhLntnZb9u9tolZ?=
 =?us-ascii?Q?2Hx+X4jw381RDljtYFUAFChDJAmuBgbJiSSajIOd7FTesw0tY3SiSp9RJh4I?=
 =?us-ascii?Q?s3qUnfTwqEVla1KUgxmNwmUTnTaZpNhYGJGnsjijLJxWWQCWAvpimGUvTnB8?=
 =?us-ascii?Q?sc+Af6zMSchtA1X/tnFrwLBEjkouWvN/kLMDmGiGnOr2WLMBH2euici4qISf?=
 =?us-ascii?Q?kBHix1nv5uiNodHCn6kGIqTXgZXrBpxSyLGQliP41WA0lo2vG+oZBHOtBTHn?=
 =?us-ascii?Q?guMI4izsCrd45ORGURw00VLqtQXCoNIeo+OcgQQPpI5FFKCiqysLbep7TQfD?=
 =?us-ascii?Q?xgr/DM048WAxIKSsJCgT7KvetQG7zyxY28ijtSJ/DjZp/67Ua0JDMqN0zKKs?=
 =?us-ascii?Q?t9WBaovCszx1cDl/anrh5gIJn3OXT2su3OYQErtDtzgpAKmStgNUTNRnqZdw?=
 =?us-ascii?Q?lSWoPh5UQKIX4k7HwDaLCr6FVTIK4/VzxrvYBkgcikMp7xiKvrZGku7KBK4w?=
 =?us-ascii?Q?d2NK+R6upFw6Izlo9uiMsm7DUrjTbog7cOG+kFQy/GJJh/W/C0P+1/sQ47N3?=
 =?us-ascii?Q?bWeP6zY7ScBb0uNIBsfr4EcvBcKdpkfK4JWda/PInElfbTfoL/6HqJrw92Wg?=
 =?us-ascii?Q?UuJpGB4duTl3qU+ymT8nEna1VucMs2GWWZZoz6XqyWvHIX8uZXEJudWNbzT0?=
 =?us-ascii?Q?ahlM/VI/6CB1q10YwmaaKNjS2b/ugw+j3LL3xX0QstaYnzZ4ygUZottE/EkD?=
 =?us-ascii?Q?GnRr68j1Jh3FSAL1vCvgibuDd3bIZfKult8nofv1Obq3pKmKRqinWrb4VYYv?=
 =?us-ascii?Q?63SO8wqneY8HwmaeQHdnywLuL/mJ1JQPnK4qUDYCdCMW5mRqRkRuTvRTOVtS?=
 =?us-ascii?Q?4rv7jLbXVPlgeILXitoscqN0EzQXYrVIfhpbEDTpIqDeopqiAg6en33Jhika?=
 =?us-ascii?Q?v4Ih/0mtq+A1BGKLyysPLElI6URCPM+mrfNr+Q8GA4OWXOTvYgKPIMmLhslt?=
 =?us-ascii?Q?p6/HCLtLrh7RBJq7+oQElioRuM7GEy/qK4zrqxfFZZ24blukmANrj2BpduWy?=
 =?us-ascii?Q?Rt4P6BveQUfIKapuuMhb7yDEYUlO7sINOEyuiVc09FkvtTQmu3CQkAMUuXl+?=
 =?us-ascii?Q?URhci+u70aeZlNzgckb82oe4QJYomOp3b/iDEaznRS9ybMJTC+OBC0uWuSIU?=
 =?us-ascii?Q?3E1fBpGg9aiJKJKmAoz4yQm7bMgmjoXuF0V7964RkiyfaPn9UkvND9/CuR08?=
 =?us-ascii?Q?MUs69OFrOxDOpR9O1AtEI2JFg2vyDYoRnv6QVWwbVn00+OBK26qvfpd3CxCR?=
 =?us-ascii?Q?qrsEf7BMsCGWzBiwl0EZ1eT6wv+6ZYCnjmbEF7iUS7+BPWaWdbwvIQ5ETeQF?=
 =?us-ascii?Q?6Dq//1q3GBGyeORzuzhKmUu6S1+RXmM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ggnrS1er+ZbbtproDrh3oock4xWVQ7IuFXKCTHcG0v1T+qV/UKxJ36B4wVGRW48A7CdhvSKOwCDV0q3/T2F2mv47H6wfq+k582f0bYyC4wJxjYno814cY1qrLW767jq9wNxywfxQOnwjcOAL6AGR8BbQEb134QO0UaFr85ylx/uXlfVQF3rJEeHeaklBEms4fAd3FuVv5OykOWMQ9Lnc4Zm4lE4NOEoJ2qmEBAVOmJWRcWZ7WnIS42ovf64b6L6mdOF5CskCEiZkfGEzU/tXrxrHFslu1RUyXPzdDV0Nla3YXdLKtGMbhDhz9r2Ej/iViaPBncZVi3DX2gAmiMHtSgGC3nylKsEJgfqtHGxd47veYvohBryrHMgmD/RdJPzwMeNRmurWLUtd3hfduiKC6fT6ac7iMkNhBpVMICzo0lIEUhsXQGPmbtmIsRqoMK202SYhAAPJiSD1Sx12KU6IGckZnj/zePH1oO7lUkW5JsjrfBFxhGyq7q6D+FieeGBQFTvFa2VU/1DQZmBcG6J5ZX2rV862lSH4QSUJfMpj3kVQJsBwt3PD3Tmr3RgwZSn8q9V3NfF4Ss3qkceb+R2MIIqX20WwNGz3OLanCgruopM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077ae810-984d-451c-18b9-08de639a4d4e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:05:50.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qIm4wZJB8KKrbgBcTmOC753f9XCzP1JK/l6hi12AzWLGXo1bP+QbWeyT/Zc3M7RwrChTqlZkOSeW1Ov3whVS6V0bL1Uq6THAPS1dL8iDc1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602040019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAxOCBTYWx0ZWRfXymd8RZ3zVGdY
 l7G0fgwmf7JQVwkHAjsA8OOL4OLG8KdQjnDWaVrpYK9RtHM5cLjkSs+GF2UVy1dmO2xUFtJ2ec7
 GjgLaNar0HiPE9N9N1hqSOwkMcpfObW/1eTJmYLuurcus/4vV4iTCServzTyhvMB4gt+XHfb+ui
 cXUzRSS6pwRxIXoS1F6mNX07aNTSnli39r8WXhaYPqlBgCCu/MbNSxChLyVrcGJa551vzEJj1xB
 Z5NMWWk5I7om22e+4llLxfRhOwPd1+3E8PBMjosrTbXb7EaQjHLQ1nXCNCNV4bq6kl/Q+kdN70I
 vYCDbsJkzs29bS+3GuqMWFhuxmReYUeGWHih8zpsxim/BDMGu/O4HI45FqNTYsoyMtj6QYlMAAA
 bRo6mj84BKVEcYB+uZaH1Lfqvajw2aY8/lRZ+n9y2aCgBm9DNsR/dGXJnx5jN3m+c/sRVhK02/6
 0p21Hqc2jG0e27JHXpw==
X-Proofpoint-ORIG-GUID: fpS2AXrK8Pt8dHzjjMX_RgLfcDQ81nlW
X-Proofpoint-GUID: fpS2AXrK8Pt8dHzjjMX_RgLfcDQ81nlW
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=6982b792 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=XfzhTUFffSti-g_A9qMA:9


Thomas,

> Ensure that the exception event handling work (&hba->eeh_work) is
> explicitly flushed during suspend when the runtime power management
> level (rpm_lvl) is set to UFS_PM_LVL_0.

Applied to 6.20/scsi-staging (with stable tag), thanks!

-- 
Martin K. Petersen
