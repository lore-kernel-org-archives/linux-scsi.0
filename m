Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815C79CD;
	Sat,  3 Aug 2024 01:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722649404; cv=fail; b=d9ePWkoILsepPxyIn4Q349l16yq3+UlAwv536c8AG5d2gC3LMDVkkR0wlrQek4eQ6tRu6btpmf1HyDRXqjQjxM8sO142+y+QgOmMb/xfwteXIlu3e/YaFOlgWKHrBXGav21IcMD/0Han2hqqNv6UKanfz07flfFEy4/B/iC0SJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722649404; c=relaxed/simple;
	bh=Fta8bcvf7yetHWLOTiCg2YjZfWSBi8UzOst32XzTp50=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qiBp+NcK8mtGY1K0bDIREMcy0e4Pr3zorb1guhh/Ajm+LrVAO1CeU1Fs2BuSJGExT8FhYEdNMkrxjnS8xm4VIidiXs2YDysg7Y39j9bsmJ+zsiPcZGIDN9fkqV0cC+4ACUbpfzc0SR2PWvVZndQS7Z53RqoT2vvNo5lhbFIJ4s0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JzU6pdVy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G+WAzPwH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JzU6pdVy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G+WAzPwH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4730LB3H008756;
	Sat, 3 Aug 2024 01:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=X/TnXM3TR63z76
	/MYkqblj/l+oj/uKapet2VdPoCAGw=; b=JzU6pdVyxjBaGQOa4M1tUHBtP9PMS9
	GA4VybroK1nhhd3Nmli8muhPCQA67CYLzk9xelCwMUTEp55rPWtUqM1SMHDOHn37
	E0j6syrfoFobwlKZ6+zXXH3+vBxG3uNS3+1KWJEsCcRWT2xxeWuprv559kIJ8g0/
	HH1qgJMMf0CYXB17AlQU7eIYE+0JRnrRdMnXpzhEU+nRqOSbcsVhqifyb/lW//kB
	e7Uy92f5KyhH6vRx2TrqZjwslpAA+trpfo3nGlsX7DA4xsf9FvfzAs++4IAIR1l0
	8gYg/bVrayc7shRhIeR/zD0qOQlyU1L0sdVv0L820U4qYkzwkjU9KM8A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rje8jeam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:42:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4731Xdd7016986;
	Sat, 3 Aug 2024 01:42:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb06r4s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:42:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rwlsM0MsVslPqoDW5poIARY1K+H9Avop2YNl7fJ/Uifzz7YQFgm+YaqfaUCMN/agKCdppPio5eyjr6Xd6xkF2Pjb7WITTj3vEzHPMaWhz272qx1zMMSJ0Fc3A5BAQihsthAVsK1ObC1lvxq8cHj9KMJvHgcJ7aqNt6Dq7oNSnHXFpgu+bA4hLxTXHgj3L3s86HkXzKkuEe3KRsWElXcFuhs0Qv5kZUy+gBzAIIiP1fL4LCSdZll9dYq1q2x+6gfjfhEItwF3e46tWjGyYqkovMTJMT16KMuW17VnjoJ/qyjFIHe7Cn8GJ0W5mTQFQ8qw2MzsjWbb8CKAJRSJDKdVBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/TnXM3TR63z76/MYkqblj/l+oj/uKapet2VdPoCAGw=;
 b=uR8ieJLNJXIETCgMiGeBKAAQ9xUKt0TrwpmFTo0Au90AGqsP42DYIVGiVLJQE5czmUi9OecmQ7KmHRpSegyijUSy/t4i6XZON+huHUGnhCPc/+jPjjvf/AzLh2hVhCo9kaVE8sSdXxwNAZPWxlXZ7feezLNvsokWgjgLgggmfhA3pYywljaqJ/uJKyqK9PI8O1AC6Mn+q19l1R7fhVKlpsAj5z/4Hy5qJlx5+qyJUkWY/HtEG9MzExq+BrIzEDqGU/flANm6HgBQcQHhSRG938E/opiY+R4B6sqjneSizxkKrBfsQFWgi7xBfLR3ZU9rdq1iA2GvTbra+Ejtb7Dlkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/TnXM3TR63z76/MYkqblj/l+oj/uKapet2VdPoCAGw=;
 b=G+WAzPwHanPB5AVpSy8x5Mx426Er6o6K6bKXjDH5mh04YjNHm6zIdn0MoszP1EL8dG8GTKZnj/CxysguKmmwVnuUsS5FCzaHOWsNa6SVvpK5abkyfnraWUuZ9qXiMFwv+HYXMO3MtemUkggsGiC8Ngv3UcuPIRVMQTnuB7kICT0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB6747.namprd10.prod.outlook.com (2603:10b6:208:43d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:42:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:42:43 +0000
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <minwoo.im@samsung.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo
 <beanhuo@micron.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        open
 list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <e4e1c87f3f867f270a3d4b5d57a00139ff0e9741.1721792309.git.quic_nguyenb@quicinc.com>
	(Bao D. Nguyen's message of "Tue, 23 Jul 2024 20:49:32 -0700")
Organization: Oracle Corporation
Message-ID: <yq1wmky5qm1.fsf@ca-mkp.ca.oracle.com>
References: <cover.1721792309.git.quic_nguyenb@quicinc.com>
	<e4e1c87f3f867f270a3d4b5d57a00139ff0e9741.1721792309.git.quic_nguyenb@quicinc.com>
Date: Fri, 02 Aug 2024 21:42:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0029.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: e0949cb6-912b-4887-6ee4-08dcb35d915d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VWRZVWROkNYIiEm5APVVj4dXY/SdffidOwggFc5HMTqp+J8mVBjZgf2K2JUA?=
 =?us-ascii?Q?5Y122qHcJ1cJz8MsLONJpmTqV7PFfhnYwu+rnH5jBuOC0mGC+wfp/ifqOeIx?=
 =?us-ascii?Q?CT1PbKvxPOWzg3rQg9gPygCJx/e6o/NguO5JDYUPw51NrB+QrPKP4Qvs0NUT?=
 =?us-ascii?Q?z2yGOqMrlRDgVFnZyV55So3bDcPCgIZ44JyXBCexvS4T53RL+Y63H4UlKZgU?=
 =?us-ascii?Q?0eiPppTgoaTgVjgRygt/hbKwkHPDFe96T3JkOEnE1z5xqKHisRf0Pr2mDhsi?=
 =?us-ascii?Q?Zxj96WD93aLSNunPELZ8BqEPp9bBKi349U3D3qFOactwF5sECkYSV6WF9DyS?=
 =?us-ascii?Q?rWduArmSQ3576T8xutZWxjjHjqKVFWFpiiFqWRVUeQIe8JqotVKocBkazBlp?=
 =?us-ascii?Q?vaF2gt0GPZTza3vwepmzJERbIcaNgWl6i+U4OS7V5jrLTyijS1T5AqiRBnor?=
 =?us-ascii?Q?kHpwmpfPi8G2+me6fR+NkCLj6G1kJjjzRyHxGsb15i6tANpZHAtaMIiTeI1m?=
 =?us-ascii?Q?mveqGQ0qtaBzlBW/ZuI3Sc5507UVQpQzLrEryJ+R7jeSFHy4eUKAs1YI9XJL?=
 =?us-ascii?Q?1nTJ2OwSZpTYnbkACJEsoLk3Nh+FDLhbYwdkfOkfYzJJcw7UHVlaHO0EHfOq?=
 =?us-ascii?Q?vcgLLm1nrqODflylpj85P3pySBJHu3L35kjAphUgvmohs+7b9Gg+aojQMz8F?=
 =?us-ascii?Q?AW2Zbnw2J/1eAVLvHhp3hqMcOFLnVbhzFhw4FHJ7BZgrMKEWvah4X0shCLmx?=
 =?us-ascii?Q?weCajBfng5BMQ4+X+AcK8h2PBrAQg7m9gNmpCJsy3tu54aS1C2u0eOU8y7ih?=
 =?us-ascii?Q?KvctcVV7hMvhaYnsY9fFPUKFu7p+MbexiS+6bj01qYMceNntc1w/H6+6lYuh?=
 =?us-ascii?Q?UTLL/aFYV+KcCV77XtH2jlNPS0vhrdrS/ZnucBZ2WzisA6/ECikuOgvDgTRS?=
 =?us-ascii?Q?Ag2WVPVsyzc1IcdJyJSZZtsvv4u1IlkwKkxjt9WcUyoEaF745GaFlNoL3FY2?=
 =?us-ascii?Q?Mu7GQVS8yedXLUuhANuh6JhYEDZAY31g7XZ1vLHgLLI9P04cnWFVDK8r3cLM?=
 =?us-ascii?Q?Hd5kPrcSLAx0Xitwk3CeKh/pBO/iR56592PiL8dhYMed197mEhPERqE2lDXf?=
 =?us-ascii?Q?T5A0Wqkzjex+EpRmv6yHtmN7xkpbQt0oKAamqcgo01etFRm1t6/3BGL0Anta?=
 =?us-ascii?Q?hV9OelsoQODixRYTx+MJQHWUeS4nNof6SzAG9SmXnA9ytZac9YWmnK6/Txlq?=
 =?us-ascii?Q?MRc7YVf3uRS2PiN2L60P980b+pHiMWNmGMP9MPXEq7QzBBkwBnffekWPqiQj?=
 =?us-ascii?Q?arzVYZGc07Pi20FACl8/GInBjyAgVrWxf4uuaDcWEhjGIA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E9SDkFeBaWLOr6LZEm9L2X22k9RgJhmMVixmvA3X+uhp7qJp/dAdGlJT2H7h?=
 =?us-ascii?Q?+xb49vnC8lxAdknki9WcQkmqHSs4xC71K3DPFNGHNEePslppLLUPiAJ6RbYp?=
 =?us-ascii?Q?UuHzM0K40BXfor36FZiAOBAW+f6HfdRZM0IH/xgPr5bmd8U/Y7oUv4vnHCjx?=
 =?us-ascii?Q?BWnfd797uvR+l5XZj0DY3JGzZCcuS9Fo+1MCrgs8LFRwQJT4D2FVkFGydcUH?=
 =?us-ascii?Q?mmhCKQKkqFFqFIvmVn5Y4kZLhlmJgmaouku84ZJ+K25cAzRS/FuNC5DN+BBP?=
 =?us-ascii?Q?JNYgNR9Y8/59uXC/DqT4XZO1BWRW9zpup5wCKx3EuHoKWlhGdpRtjic3q1wE?=
 =?us-ascii?Q?FK7Cmgg0Fvyl7yoiDqnsd0V+MEP/gFuTCICFDp4OrZUT/WmU8Q7ArZKkHOxi?=
 =?us-ascii?Q?Z3KgpsAjk39vQ/AjT+J0URW+u+nBVbRIDFNswTBuwbHzdGyFcxftCF+BWrJD?=
 =?us-ascii?Q?Qvyqn4cZz06qDvQmIL9ldDYm/e6yTp4YOAAuYtRis6irogaxXv6wtHRX+GoL?=
 =?us-ascii?Q?IFdsFARtm+8qjnKLNBopyVDZa+apxgWmVaVBABfFNeeCMd4MRoQxAFcHjpTE?=
 =?us-ascii?Q?d4v4K2CLcjLC2+fK3YFbiiswHHWsllsFvWV6FlWyIQjYgMWAm6L2qv/ASxHf?=
 =?us-ascii?Q?vNm0v7uFxekEJMMJITxkSB8lS+0I0Ii1Ck9LBeaLzjmmDkXmXNpJrESBSCCY?=
 =?us-ascii?Q?ZfYbPGFUlXiESgzbgAb1c6mkBvsAIIItgzUsjf1xqMrZ/0I07frFvAZtubwM?=
 =?us-ascii?Q?NzN2ZCLB9+jBU2QAXAC+Mlnj6UPqCn8FPZuLs4IsHk/RLZmgXis6tdX86Udn?=
 =?us-ascii?Q?wB1Ew/NGwgSgmwp+Ljaojd/+r1QlUchCkBUHkcMWnr12Wg/WFCYtizd/xTLq?=
 =?us-ascii?Q?KucyEXV5ciUSK7M6Jqi5DZQa770qf+zto0FfGg/tBjB2RlyFx0mxXnDii4XE?=
 =?us-ascii?Q?dGbWPe3JY0kEWqpRJnhK4KJdV7Vt29AxQFnNHccW7lB9uREQe8+MYhstX9M3?=
 =?us-ascii?Q?xE3foudOv9WHDGOJJLYZc3Bj66gASXU/m017iDuORTefaBCEd/Mgf4XDEL9W?=
 =?us-ascii?Q?EN6lgaop8JAo2SfmzukwZMTmRe71j42nN7dR86j1kQ8FXNSDtg8j+e8O7kd/?=
 =?us-ascii?Q?sQinslPilL5V1a8zvhxr2jYDK8L12GUzpBYyfnUYbvwPrGE2mioypZGBe9WH?=
 =?us-ascii?Q?gWRsmjp0iodEJ/R03PG1bW5Opv1cs6/QQBYSq/pb1l/7em81oauPp9gOMden?=
 =?us-ascii?Q?ywYEnYom2HBS0SU3w/p/P4nE9uswCgTCBOylatMaU4WwPTgbNaWTXaKG2WS9?=
 =?us-ascii?Q?hw37PGd4TsKDpBYY3tNpepKBj4Rr/PdHy8mBpOo7Sf/KWqipEC2G87fRObkb?=
 =?us-ascii?Q?FSZGq9Mb8xsZIQDepk93fkByxdnD65K/zxrRHkXWxotYCVPkl6LebHxKq+ik?=
 =?us-ascii?Q?SD6E4ES+hUNv7OmGSKykKclpTdbeid16MYNav7vIDnmn4ZbvXH8xqGtos6cf?=
 =?us-ascii?Q?GQ9HQJxKxVIR1BuPoz0wkcZYZnNVsntL4EgrDdNkaKOfkk/YyuvambuvYqQ3?=
 =?us-ascii?Q?Ki5W0YWUU5iISsLZxIDuEqUfIkglrOrKN0qFN6hRDvdi/B/fI1XsGDGdzZR4?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mKSOCKtDRj8MxydCHnRexRmnYmswjFkhuSKafVTKt7SD+OGHi+urf2yGTemkfsDl7WYdLSzhcZ81h36gDglTfD5/Av2ZPLC6xXrgwnOD1W4ZTDzoCAdZ/q02QcetngIa4LKPIzZBTUH9ayXg8cY6dyXDdGX7kUnpBi5+smiRLoyJxNO6iym9b7h5ssGgKGcqx9FF1mx/6oGrqhMQ+jpjke4oI6csKaKGuio4s8ug+5GxWgih5VjEbCEKZcA/SGAU/3KfDbAVCsB3/ossiclk3cB/7e0aLrbUq/mp3OcDbFHwZZKlwVTG0uT7SlTLlOy9gBoo2Bon7R1/Sl9tVnHjjp39tLIWw2Q8+y+aECwyn4HUAlaEacih2T0b/etIWiwk4pMjK4WbNX0VK8azz9azNATgzyJg5D6iWQ/c6q2Gd1YXFGKeTL2NnvNgNPsaSq/luPHEZTYqQGsYee7lOeTqrlvIPbMotbC0lK9zG24Jix4PVFu+rvRKMIic0rkhY9PgPEt/U/OWIGXpkcRYkm2B+U9EEp0KV7tdx/JB0y/w4uAFratHH4ShYBHtX0q9g7aNR9FnXO1I+Ww4dQmGOaij8IPQBV/lDH9hJWAyyfrW6z4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0949cb6-912b-4887-6ee4-08dcb35d915d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:42:43.3292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Glhn9WQVKznVwvKg2aRujmwCj9FZhadwU0eCyFxJtaMV0k/7dy7StvIuQ/Phdo/mdvbJ2uyacIjzUSg7WPcdS249bqqvh7ES+AipLX/W6Ek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408030008
X-Proofpoint-ORIG-GUID: 0BUyUT7oMZjvXk-mTxI7pvXBDLeTYKba
X-Proofpoint-GUID: 0BUyUT7oMZjvXk-mTxI7pvXBDLeTYKba


Bao,

> The default UIC command timeout still remains 500ms. Allow platform
> drivers to override the UIC command timeout if desired.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
