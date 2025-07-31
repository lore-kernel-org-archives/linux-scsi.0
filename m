Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE594376;
	Thu, 31 Jul 2025 03:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753932163; cv=fail; b=JySEpTOTI4jiQcoO02HcYfdqs2D8P7IuP5v/V5TPC2gTIRQwlUWyKUFynXw0aSHjiMbXIs6jRpoQ90piubSP5KVD7N1bXgbXGbTuc3F37FhrR/RRds1vvL3EEElomaNF588mHpBaAM6eYAe38qAtEFeBob1FjcuAYOt8UVunPLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753932163; c=relaxed/simple;
	bh=gybcQYK4qBYBS3evA0VX/ivld8g13wHNE22hZSWvkD4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WcVErmON4aDQJOMZ5AKJVMqnCAP/HxfMPXP1h1EcCgUwnJpKUZ062HZGPQWQR5ZhlPVY3Et4PW+zqCHi6WE2FGiKPYg1AG1phXdZu8bvqNVRg7hTXmVltgSsalq1eXC2RTEs1fmsA6StOnlHLyPv/+nXUQmHmmrcQl3omy4ll0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IRAyziv/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RSo9ssLe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IRAyziv/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RSo9ssLe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2gLvN022397;
	Thu, 31 Jul 2025 03:22:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YI3mB7GHqJuKso4imt
	QvmjtJtcVIu+U+4v0hqBeOpHI=; b=IRAyziv/Iufd+H2O5DmogX7EeWvM/Z03iH
	cX7jqciXkSxcDZx2602Eu+U7MegnqBfHtSowOImp0PtsdKNuxUjJbInjg1wKHMci
	HAhrIXoF/BFswrdRtNgX8VXev6NhwcOg0vIm+LXPK9QXcA6M7z28CSk/ScvX71B2
	5VQXPJRHN63N483hJq/BfiBmixMAqLjYI5SmwVebBnjqfIEB9u15lROyYh0y1J36
	GZev0w/vUJi09k3jX/U3n+zz21q+7120hRJvuExqa3Q2KgYc0KmR/cprjP8xzylx
	LF4n/f2ZQeya67hVNqqUPLPm4DYZZMTvy/F47qArHijicSMgn3nA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q733864-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 03:22:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V1491J016739;
	Thu, 31 Jul 2025 03:22:23 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013003.outbound.protection.outlook.com [40.93.196.3])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfj9cpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 03:22:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hdV9Lmwj7cYbTcl4cYpwYLO08lALQn92o+e/YTlBfZY4/5+jqtFMON3fXVVvdEFwual2hU9MlrQqxCD6haIDz49Xi1PIJ0byx9r04TpnNn365C2eJ+X3Wtz6Zjz97slIsPFs0vKmKkmeqs1dbeO11D0W0PqGE1gv6Nb9OItpQvd5xZSvolFDw0qvrCmIwZLlaLXUzfDz4GD+vbjO7CbzGH2KBwRlC2/ibbHfZYqXcUuefIBdQMbwa11ohfcNzirLXRcUozeDihmh0p9T9F/zUt5oQz54xOdzWZp0dUpl8GpKVXRsrs2/AyL35qcqv9oP3VTSjEFEowjeIMvN1V1gWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YI3mB7GHqJuKso4imtQvmjtJtcVIu+U+4v0hqBeOpHI=;
 b=fK1SJ+HqlgOJ+EUMaIawR4WJ+Pnb71aPG2ecOhVq1S/ctiIrOEHcl0LwFArZvKioaR12UM1DNy+laCmoeQxIof0xeV+GlVYoM3cCnBUx49gy2zpElodtRtdwkfAyMLqTJn7H6XmkBs2TSFayuO85LAt1Z0ZuCE66sX9BZTHiCLx9sVyVbCfyqPd2vqJTedAw2N7OCAMYFHpaZjYonUIZmhJuF1TGLEDq/frZvIyM878GPaeeM+qm2xUeIqpU8G1fX+VXLFntd+OpgH0SvTTtny0KVS4Di5BvY3bEdSljofzfYXgDsqCib2DM3AY0NxTFXBVEVEDOcRTqMi00iZytPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI3mB7GHqJuKso4imtQvmjtJtcVIu+U+4v0hqBeOpHI=;
 b=RSo9ssLeYgCirQPXmvRKBAVeOnW9ouJF7tS019XdEPO8JTePUIPhczrdjsJRmFLQJ64zfZ6LL6/OyirEmiq/GeZtf/AUHBxbLeGBcdpP/yAGK4atMnXqVn7LpSd6VlZj2lUBlJgiCy6wDXd5tqAEupJhjpO/CjZdqUpgpub9CVA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8662.namprd10.prod.outlook.com (2603:10b6:208:570::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Thu, 31 Jul
 2025 03:22:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 03:22:19 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexey Gladkov <legion@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Geoff Levand <geoff@infradead.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: buslogic: mark blogic_pci_tbl as __maybe_unused
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250730214451.441025-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Wed, 30 Jul 2025 23:44:47 +0200")
Organization: Oracle Corporation
Message-ID: <yq1seidgi96.fsf@ca-mkp.ca.oracle.com>
References: <20250730214451.441025-1-arnd@kernel.org>
Date: Wed, 30 Jul 2025 23:22:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0048.namprd17.prod.outlook.com
 (2603:10b6:510:323::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8662:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ea074cc-b1c0-431d-4564-08ddcfe1750c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JBOu90upxjQklbCXP8ppGGx2/F76sf3lMDahAdHG5oBqilPy+ZGp5leUc/2I?=
 =?us-ascii?Q?dV912LX/AYH4nG7k4saQTqhL9XvPUP5813xxoRxrH/xbrMza7aEmInQbbj3V?=
 =?us-ascii?Q?WcZubATid55Gz+2mJifp4Mu7tX4qDvhp+Xczm7WSlCrLPtZKfXAQcHgIvrtq?=
 =?us-ascii?Q?uJ6X3lCLdPImQYwoobdQKB6ckZEVX8l2mYlClusnW/pu8qL7gMTZ3vRUW9yk?=
 =?us-ascii?Q?Er4EWNqw5m/gIFlTbjNyoK0yVXDlXzaeBF6msZv4UcRWHg0Mg8xk0TcL/L+E?=
 =?us-ascii?Q?8jij3M7GP9yo/X01jr0/lfXjCQ8q+hF0LU/WCOxvEb5ajyBusIs2PzYeY3eX?=
 =?us-ascii?Q?3wCZ/vvNaeZwQYm+ycuouSgSh648yzzRgc/48OJU4SxLm8JzKLS+n4fNnuGV?=
 =?us-ascii?Q?j77HjOVPI7yvWbnzJzyZUtOKLBPFARsjMttkLlFJuPxEoNE/1dcKI7qak5Uk?=
 =?us-ascii?Q?I3GGyneY4/dYcM1Z4t8Xxs+VkJxtfaAPeoxA9va8gpQ50G1zxlOKqVO5aogi?=
 =?us-ascii?Q?QiCEFJzXI1PVPNS5JyXfhVXxvBsqgzFXp99QljIH6N1boUHNVh89KRmLDguL?=
 =?us-ascii?Q?QS+hvlYCqTlfG1q5GFpmjJzClv8oXwEb6PTs8ga2ThFmcLMdmj6/2hod2xiI?=
 =?us-ascii?Q?yLp/JooNnJ5V4sDtbDFBUoovRNsfZA4fxmv/IQvdw0Tka6+JzMatoKUMkO/M?=
 =?us-ascii?Q?jxDIz1j9nEnhj2IRHtNNEcV+f5GLF4B+tnYVFETXDrkSCUcj2mcU5CWWVKgx?=
 =?us-ascii?Q?L3Xbqpj5W5/xYanCaum5DhkJzmb/fx/9tlhvKW+rsbFW/0tYcl9G+hyU1jzy?=
 =?us-ascii?Q?TfV4BeUuTIZVi1IowTELTRbP1Eyn10BI1MkyjGkbbK7afvxOR2I1E7mxLnAF?=
 =?us-ascii?Q?/8FWkVOE7h4bLN3K22V4Il4Lwb3JO+3My6tmA7glxueNMDj9fnCp+yi7LBcj?=
 =?us-ascii?Q?xn14LLb/WOri/BWTOo07Vbw6xkJXyZCwiCo9KmKrgHHfdgA8ef/3jfISti9z?=
 =?us-ascii?Q?au/KXdiiQUfTQHeMOC7NIlmQ4UFTQnGjrZjIekHksGXbbZ1xSlMqNW7ZdpHa?=
 =?us-ascii?Q?NyOu/OtQud8IJK/n/e3YrY36HzDYX4AVpQmp7oMGhcZeXmx3XuTbM2s26JBH?=
 =?us-ascii?Q?pAqhqLJYJpndKaAuBRXiaMV0Up0Zk0OkhG4tPY4r+93sc74G4DyRi2jzgvBd?=
 =?us-ascii?Q?Uj4827jt0Zh/iLNpvdENVNuRltuydrCPOIPadJQAV+I/+ZvFCIy9l7lV/RW9?=
 =?us-ascii?Q?mZ6D+h5k5wrpS4npvKAwJU9L2izo5kUucLrMpOhSFXLbdFqGJ63Q6WIvo0sU?=
 =?us-ascii?Q?N5aF5j7toDX7ZBSG7qIFi8hgwdDoc/94smCIrrvrRnBXoTlNw1sHqHyPRZA0?=
 =?us-ascii?Q?BJsAds4cci5VSxNj5Eu/Mxd/tU072u7F7Q+OB43y6JNf9S84Xhpsu1cr4EwT?=
 =?us-ascii?Q?0Raz9e+aVG4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V37K0eF1ZTfzkVcyVNKVGZ+7UnzmN3PZBJa691MFEPPFny1TOdQAaCrF4ENE?=
 =?us-ascii?Q?d1GkdLxhEqa6s7DVnECJOBuaIC0AZ1R6JuvPhIeoOMRMo6pPZKXPwkhLIVhF?=
 =?us-ascii?Q?UZfL43PlgkzeyyKrEiCBVnvJsEHp/ZPO3ZfrMyxrzYzuT9Jix7ep2rn86JrE?=
 =?us-ascii?Q?1A/ZwRePH325y4YtL58ACTuuzlrkH7hx2rCap7t2udjeucXITnaIG0TDwGK5?=
 =?us-ascii?Q?L58ruFXIlVAHehoPF/Qn7YpJ4f725dKVysa5WvCuL1TUhLoWMg2o8lpa4Rd7?=
 =?us-ascii?Q?jNuk/BaMDisRHv98FVX5WAys8XXrGLQVx4iJ7NStROG65ezVqYVlvKCoG6eY?=
 =?us-ascii?Q?O44q7ioO9z2AINcN5/HFyjAn43btF2P9Zb6XDKkMnU7Wt3jU6mQtrfi8s4py?=
 =?us-ascii?Q?qpXGy/wa/f/BwtECAo0Ivdv/uyikaCxT6bSPWF/i5kIqxKDOwo5GE9ivCBPs?=
 =?us-ascii?Q?TnEll95DargplGKZkwPhrbjUbg5WuA6HUFqY+sD3WXuU22Ys8cvqkIYZJtJm?=
 =?us-ascii?Q?PecAHUTk1GgUqUFBNDb46q9j7PdGFtfImGNYT+m93/Rx9WKC2YN0e2+gADg2?=
 =?us-ascii?Q?HZzHSRqN1EjW7nkGoTL75q9/is9AtzEjX4viKCrvH4yf/gOQzo7XX60p2jBx?=
 =?us-ascii?Q?poH6gfvYoccqbmTZJ8b6PBMlpNL7NNp682KPZLALWIPDrDMa/B572fklTNxw?=
 =?us-ascii?Q?BSDMvnojlQctx4samfi0W6V3db8Sf1MEpInziXCjIELO0a/PIx45sPRa0QNJ?=
 =?us-ascii?Q?AEgyPw+V352jc3UwsD42FtcN/Ye8W0UysnVU6HqqyyoQJuScUF2otPjHANRH?=
 =?us-ascii?Q?dTauqIW4lgmKMhU5+9VrcT8hdbzQtbU2qFwEL3W/oxXTCb+Fg3IJ2rdTTJua?=
 =?us-ascii?Q?uRfaCLektXvBdv6TXSGcdJtQutyaiPG3FkbLRHagSjiMwAzcLTltySBG2WjU?=
 =?us-ascii?Q?F9hPiO6JJSzqbniU+yf/Lc/QFUo/NpxuSmfirjacsrjce8WN9IjU07s1sRk5?=
 =?us-ascii?Q?ZkRwvsMtmNoIl8VjUsv9sIyEBySwMYS2F/0eo4uhiVSqjKMh64ex4RS/Yq8I?=
 =?us-ascii?Q?4Gv5TapL2DTjE8kwQSm5dZ94BWKe9TfIFGklQ9NYF7nsU5sL74Ni49M1E8dJ?=
 =?us-ascii?Q?GgQkt8HBhNozF7iWma+olcplwk2DTN1Kbch4RGMSCNViTPhwO6+QBlFQ65Xb?=
 =?us-ascii?Q?s0d2ENGxrZsicm7637eP1kZXQ5Rt1LUrQRZHbPGsaXcSA5BCeKghgAkVIg5U?=
 =?us-ascii?Q?NSn/LLocI2KP6dXOJJt425cr+3Ichsb8RDuGYgZmWNeG1Mo60g381cfOsGn4?=
 =?us-ascii?Q?o+wwy5jZdUWoAY8rN56w53MBpC0TrRxO0SYDomQFZdLpShoUQjMSEYAgwo5v?=
 =?us-ascii?Q?N5NEFrrmOnC7cLFrNd3eT3DmQwmr7IAHHl098Cp/1oT7ZAGY5/3Dz7NTsAij?=
 =?us-ascii?Q?Ssee0hkui98eGPFxj4OODXpxZ3eKHKGW6RVNCx29r346kx9gIW50Tn8Z2CrJ?=
 =?us-ascii?Q?qCVGJ1VBfvN0sqAwkLEyM4BzfBScDt28aLFjxlForF1CTmg9NcjHVHp18EwG?=
 =?us-ascii?Q?fiWLe5tLChnExLuQueM02GwWFvfMxnsOoCU+nqdhvDzDowbBVZCedjTfrsS1?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rxJ+5EUDW7fC8XiL2fq9EceqYqNZVn3LQh5F3Rf7n8wQfL/rrVvCYPVHowBKzGxMf0z46eLzqjukDNaR2VlHSSVuCqe5ipvHHUZFUAWaICqS4C+2Om/1HrZg2wMLMN2sytyfDxIz2iyzc4NhwgGZEhKXqACjUMzRK3IsiMwbZYTcUibSMfQiH/r1bXgz75qMCkmoq5opLLU9ZEystkVpGKEj1HiV1CaDb8QVmKxJaPxCHt9eSudFuBLwFatLPas5o7lfxMVqwurFAv5Xs3yhUujwOiz0RA+CO+MnGQ9H4Gxk5jpzYluRGnG28OjeJCA7XLmWWIoBFKyUHvyHN4fFsQoTgvCOsmB51oZVuPmHNT4BIiVMKbSGz6OkKa+PDtcmbFj3BOn1/aKz6tK+LBSmM9tLMZ7lbbWt1aoyt7CffvzbUIDwbnNwBsFIBUyqdrB80PKMKFpuCJ/TclGpEiZM3yatYpP4sNQ0tBUNBwj4qPHPLzbqNBtGoyGwwn7m4wVMFV7opwfCygfnlTqEsTZJRbvaPNAmvVwLSXm62pxuzeHngWikD7y7jWdI6cNUc2KGgDIDAPUWcAHakNA19tGXzx9NAATNu0PUFyeVVKjL7h8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea074cc-b1c0-431d-4564-08ddcfe1750c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 03:22:19.6163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgzfVvj+M8E+yaoL9lv2zjCD2bBNrb+c5RRvZXV/aA30GP9Xi9ZOYhzjiHYgh8cna8teK6vShTpBNuoJhaJeBrmi/ZfpWkHBMuh5BBgcIMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=765 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAyMSBTYWx0ZWRfX0YW+ZJb3Mkod
 u8HqFXUGtx89laH7Yu1XgZyJWEbC35rtVYUMpbH+bajEmc82o1sRRVufnezbb3e+E6945ezQh82
 pTt6HL30sD5hXQmkY/PwPwzMQX3Q3r0TZi6YFaGtPbblCV5dfB3SsZ7MsE1H8jcUlhQeRgIsNRP
 dgeZQo9m6BwU/O8wEycMek2fO6B1lAz2kI1rNIDw5v/YuW0iTMPm2pI3PaRLe8vYcM5kUK0XcER
 lXVgOzPVb6Pn2uw8pt5FeBiDviUfwCnnjnCQSiRAffMOkz8zrYuu+f/W5A1vKMP2JacgvM6ElRy
 wpV8Exe4gHUvhKZl9uVRdrN/mJRTc6kwGE0f9Gng9d9ao6TP29l2dcclxZ3cHFq+l+LI56wRMnW
 GGHqXDQSXmYYM5c7ZR8ulexSTSIzR7Zy4lVMHKVaPkP0CR46XV/u+QUDWt+HhYLkwufzq/kq
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688ae16f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=SNaSFmXN9eQs6mAho-sA:9 cc=ntf awl=host:12070
X-Proofpoint-GUID: aTc6DbH9hzb6CHgf4tQ3ZmdooZ3fzRt1
X-Proofpoint-ORIG-GUID: aTc6DbH9hzb6CHgf4tQ3ZmdooZ3fzRt1


Hi Arnd!

> Fixes: 204689f0ea20 ("scsi: Always define blogic_pci_tbl structure")

This commit did not go through SCSI so Alexey will have to handle your
patch. But yes, I would like the scanning to be updated.

-- 
Martin K. Petersen
