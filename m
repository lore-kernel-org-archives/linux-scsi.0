Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D694275B15;
	Sat,  8 Nov 2025 18:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762626535; cv=fail; b=cUP1RzOBal2YaVDr4PLNdybC9TbD8TO71TaZZpGH1qVqySV/s1nSoYguOEj8qTACMG96iSl03yUFSKQxPIvD/CPIMRgb92TihGi/vygg+lxhwbchpb7oDQB0wTH9SkalvJDUlNLue4bNg++hn1kh9kVZufdsJSc1cAaUCC9tgyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762626535; c=relaxed/simple;
	bh=4sjxUZV2OP18YJtNlWlA1Yr9KQ+kmqgY1rHXLIJKwJA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tCicx3rHiKy5lM1PeBhMESG09z0ipIwyi3nrfs0eWxyRgiR4cP1gra6lTmIzwTlPnLYnbHiczNkObHTS/uVe6gGwmQ16ipFCi6RzFI2GtwYX8rkd8eDG1n9PO4Krt7fgED7U15+QuzDbr10K2RwMF61mx0qWu+jyZNtMI+2whUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D760Jbf6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AFvVjEPQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D760Jbf6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AFvVjEPQ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8I4OBr000536;
	Sat, 8 Nov 2025 18:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BI8YkKj3ze0TDj5p+Y
	koT3nqbuw9sSu8w9H6ba13Nd4=; b=D760Jbf6kc759sJYZsZ2OHbWcy9Yo3O35R
	4jOqsvBn0TlFQz5WZbjXZCdkmbGylT/hqQOL79nlk7svReFeVjX/9gXHEo9IbR9o
	levsUGhTpv8CtqUOqfHlGbJeIH1BHkymz82fqH2TR6U/v0pAZcW8UHnD2d2cSf+6
	ZUJaKNop5KIPpU246YeM6fw1oeUY3stOy9Z72Kub8cJ98uy68uhy+ecMN7FKcozY
	kuieL9SzAxj2bB3zoK/r6eUBlJZd32ZN1VyCAp/vFKh3YPAS7yBLh3y7tUUMlvCF
	ffI1+aby59XiXhVvS27SWxhQdL+IS1M4g/0uHwuY5imnZTbht7MQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa8se03s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:28:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HEIta039940;
	Sat, 8 Nov 2025 18:28:41 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010041.outbound.protection.outlook.com [52.101.61.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va6qs0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:28:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0dR8J1zYDu8YLdjzzIp2jkF+O3VjiB2EBceyyT8sqzewYGKz5V5aEm+tR8kIDjUFwA6GIOMvE9Ca1sD4N1yEJx1P4W1gXrH+kP/pdM1BfPHs63u5L/TiLCvagCtaxapaWOotguf2wvI0Wf5r778NpBTyNNdzuUd+H9Qz2nIa980dYEhTh/JiuFf27+Zy5nKx4H3WgbK5/ZZG4oVUEM5qx3BNwdA434dDGVKI20eZyErLH2pisi10RcV8WSbAsf4MPY7FgT55d06ctii6BSAdXRsn558wu8txQZFZ+25Ti4M3zhMZeOaRkeCG4ayEOCjIOMVq0ekv67CrJzJoZv4lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BI8YkKj3ze0TDj5p+YkoT3nqbuw9sSu8w9H6ba13Nd4=;
 b=zGtSSuX5yQDODJda4C6TsNE2zJjyJMRsfdRAL8yCpXU+qKQZDLF8ZyH+rCxutM2pVvNKL8pxDfHaUplX0Z9e/1rl4SDa6gU+XhFifwhpr5/SkFpWsVCcII/qyuntxk8MtTv9XKJj4ZAdU3Vnc4P68p4ExLkCojYWfWHTPR4aLE1eI2K9NG8HCUKaOObpH7S7H5bTfumLz9SfwrDaPPZO9de4/RtGlv0umBn0c8nnu7kTew7/LL8cygyIEXTmiMMPnUh+SFHZGiO11mpF7VQHMBC3ep3X9ZtWK2G5bFCkn7DGVgArUSln/uceKejjegtZJtVAzEawptwcJAJ+0+fV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BI8YkKj3ze0TDj5p+YkoT3nqbuw9sSu8w9H6ba13Nd4=;
 b=AFvVjEPQ/PCKIjdd1alsEMJz5zqtOqZnQO/WL7i83fkOKRP2f6fUv3K1VyRuHDYzDOpg1X4ZFoYqYUch2lSucByjm85+t6jKtaW2mG3FVkPZ/dPdZKlk73hybmpelJFzUxK59iR7ziO4QWOdcgIweswBXqXsF+kai3I+OphGBTE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7016.namprd10.prod.outlook.com (2603:10b6:a03:4cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.15; Sat, 8 Nov
 2025 18:28:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 18:28:38 +0000
To: Markus Probst <markus.probst@posteo.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] Support power resources defined in acpi on ata
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251104142413.322347-1-markus.probst@posteo.de> (Markus
	Probst's message of "Tue, 04 Nov 2025 14:24:31 +0000")
Organization: Oracle Corporation
Message-ID: <yq1fraogz03.fsf@ca-mkp.ca.oracle.com>
References: <20251104142413.322347-1-markus.probst@posteo.de>
Date: Sat, 08 Nov 2025 13:28:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0033.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::41)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: 922b2676-f3e2-4c43-f2da-08de1ef4a2bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1FxrbH2kqzueaEppSD/QCboiv8R+PM2RrhsmChRD2WTgRlsEH6ctaIBJn5LV?=
 =?us-ascii?Q?BOMfJGzeLuGUWvPaH7AGVPPk/r6Sp4pnPYe5TtBe/an3+fQ2EnrK/35xwO9W?=
 =?us-ascii?Q?CYQsyMXe6YG6f0Of0N/qoSUrAXmUi+iqQ7LAFpE0wttpzZhuvPshhVSPhFZR?=
 =?us-ascii?Q?idLSt2dxI66b8f/vrS2v5uDZDSqQf5OnEee6E7YtpqcVcwrBd7X/C9lJFNzW?=
 =?us-ascii?Q?V/enCjIdCOT0CZ24QezKsks8KneF1ywzxEzcu9+s+G5/oOIDLJjFO1P3F+xZ?=
 =?us-ascii?Q?k3Ouwg7f4jocfhT4Hy/Kihp6PiOSuw60rqFRBLnY1ewS0VRnCVUXjkJRI5zI?=
 =?us-ascii?Q?VpoLddCSbHEiQ+r4CgdYVcDIihBan9tgIdTrnZLxI/HodrAVNpi4HmHeCO3B?=
 =?us-ascii?Q?RBE9p9fEkkO3qSxdQPcU1A7xLtoMKBzaHpvepygGIrDaomCtnqbXeRWpm5be?=
 =?us-ascii?Q?x4bP0SfJjcekuLS20JJvHX1PHfkjPA8Lw7ekXAHzu3E7vUZfDwY5UVFbzavR?=
 =?us-ascii?Q?IUm458sTPhZK/B79FAF6csdQLiA9VoQuK+ZNttPEV+HUzEUS0q2QjTDxBqg+?=
 =?us-ascii?Q?MSfghYi5oGdDJjzeMbbUzNhjB7tAEoHiRk+5F7QKdJGe3/HwO7onEfIqPP0G?=
 =?us-ascii?Q?vfGFxYrAqvwjknZUWRFNyKN0EljCN0pE1CpODvQzlZpChjIFQ3wgEV1iAYn2?=
 =?us-ascii?Q?Xj/AZ+scbRIYimEXFrGohM5DiVQc4GTzTX3jfpoHmx5NYG4IlShdL0AL7l/G?=
 =?us-ascii?Q?3BCXjM7BHssBJYIg82oUT2J1c3fK6PPpakhwSvwkMiOD9k3Z9d4Ok+5V8igc?=
 =?us-ascii?Q?u2xkGpbw/uJiJbydzVN+sgZI1SXABEOFTdw1KLo7sTdQGa+rX28kFMTbzvvY?=
 =?us-ascii?Q?8Ii7dQ4v/mO4BV8YPlfpwkwfKNTVCld7WBF9m6Gc8LuEIDqRRbTRqXsa9ABQ?=
 =?us-ascii?Q?DHhiGvUgYg/ZpSgXyFe8N/5U/TxskYJ6o2bJyFP9Z/s+D84L1X5u8SWbMOPc?=
 =?us-ascii?Q?ONxCdLPjRag6xcRlRVadlLOBlk3f4kNyuUsz18ndp5ZH/XeEmfqtjgaMezDo?=
 =?us-ascii?Q?lGjnk6RTB1wK76vrne0EobRgE1cclIGka3QvwpKPV+fXNxhtJvZJm8JFoUoa?=
 =?us-ascii?Q?yi2tDN6EUqjmeZFBQE1Qn8KCzKrMD3fNkOZczDmY5Xk6JcAUfKUXp8wBWVp8?=
 =?us-ascii?Q?XDcUuB8VWKQrylXpd3rMoEWw/bL+aMhL4o5BoNtClIPcozZUH8DSvsQeKJe4?=
 =?us-ascii?Q?CeJ+VBOIBuy0e1fVnjHly9uqKzNKOyJT08Xe989v8nRCdNPqX0EOH/4X5JTY?=
 =?us-ascii?Q?RS5fNZPEM489UjQG3N6DRbdk1wjTiJ5gkzDTNvPgYl6td7YU8ArmDKJApaJd?=
 =?us-ascii?Q?HLujK7s1zoW663JxlS2hnd7BSLqcQkpxRTMka9psF3osyMxb+GSSUeu8D4pV?=
 =?us-ascii?Q?XXfVc4arONKODD3EKnLE6uBLFn61VCsr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3KJKkOPEEavc/5GApnhNbETWc62hWF29qlxn3Pp1fjSW5HsLUbeo8yKqYZoa?=
 =?us-ascii?Q?ieJFhwsQwpGABMQh9XPPA1xEBAIeonybzx4X3OE0JwsXyqmJJzZF/R97JKDd?=
 =?us-ascii?Q?FT55jAwa3SjwuLxCNLqrdghsT8zliFnMH4GCMgsuRkcMoUjC78p2MmNaTqkj?=
 =?us-ascii?Q?v9DAa6gSh1HIu8Q29fT8rJkP5Z5u8SHL/1MTTzh+6t+L0uYEati4yf6sIi9Q?=
 =?us-ascii?Q?pxL0sJ1ZqAawSmPH+ySk3NRBP3z2R9Aal2Q47I1kLeHuFFxMbLIhN+K0aQQw?=
 =?us-ascii?Q?SDw+0aMD/REe348LmQpHsju+zurswHJA4X9o9UoQGMyx7M/C1arenreOArkQ?=
 =?us-ascii?Q?lJ3QvVqVDBKQuFhxrTvnqzkC1gLLmcZV6OHsv5CCC0rbOQB9HRQorjpCNuO/?=
 =?us-ascii?Q?jLaN8Zojq3o8I4PzR4ZNcWHzb6apNFVmN3msiHOSzFLDnBqCjrvZ3BcnnDF+?=
 =?us-ascii?Q?lnsFody3aYX6sVPXWbcEKbv5t/lT2GotxLXQw7Z4JTwWWiLpmk5TxlZcisu7?=
 =?us-ascii?Q?uGEwYlduflWBX+E1QmS6k7P/rt9nYB7nxnhFJ3KvBfeFCpt6AKDPgOHteQkz?=
 =?us-ascii?Q?FuXlsj/9fEtusckcIK+e2ziTRqO7suBC/iooYAzSQhLSs3lmoU0xerw1xPQx?=
 =?us-ascii?Q?TNXrU/0cTSIXXfDusslCKxc/jgSAT2GHHbE1oPM0q+ZaiNccM2hoGCtRAZVe?=
 =?us-ascii?Q?pHag+F9TWqXB6FgvTa//Q8/jSOpFODAemVd0T+nVhIhi4zwe7/GjoId1QFf9?=
 =?us-ascii?Q?1T2clpeGYn3QwgDLgp9KEqg3P6dFlFlRiawDELbpvPwrqiozbp4wbvHfvLm9?=
 =?us-ascii?Q?tJKJlZiwwr3xQlTO8G3H0+BeKt27CXSSvxqBxeeUFImLxhTztKmo0QbO0XuP?=
 =?us-ascii?Q?SC1w6NOiPyhTivnGAKzXP048Bz75aF6/KHVqyWqd+a92zdaxDFG3nTrt92b7?=
 =?us-ascii?Q?afNbMbXahkXhbKS0skRJMPvsNAwEiFyPbVg3vDdP3tp6KDCvQaRI26mNVJOc?=
 =?us-ascii?Q?gHG30pLo4onp2ky7m75MomI531J99Urv19rBW7FNJ588egXdxiZh8cUz6ios?=
 =?us-ascii?Q?CrA75tFtwmYnvzK4h7kB+QCWTf+hxqYBA+JA/S+FaPByM/i4eNpSd5SFh7rv?=
 =?us-ascii?Q?ilAMjJUYOSAu4T3ggHyitTw8AGhQ9OdYmLG+tmWthqj+arNW9Ka/8UCYN9Dr?=
 =?us-ascii?Q?7ngcqI3hfzU81d26pVigdHDbIuR0nQd9oOe+L197jussAqAbRvUqJCEjcV02?=
 =?us-ascii?Q?PbgMlO/oFpjWLN77kxN4TbkEC3ODZ/YrPUlwFHlld7ee5APu+iUROk2psv2j?=
 =?us-ascii?Q?6FfCW9F3XB/JK6vzFCXX/pCju99Uxi15FvJ73QjDD32mjC808A+QcZZjMQYC?=
 =?us-ascii?Q?hCkXXLB7gYWRQGCht6HF0svq1oj1Rs85IsNIhc1vn7fVy+bcN6bfsRfABXub?=
 =?us-ascii?Q?EC2F7oPqCIYTCkwXXkQdIIPSgPkijHbO38HG+kd3WqtmtJc8jji4qY29z/Qc?=
 =?us-ascii?Q?VCM16N8otxj7kqLJVoVftq/mktnGqn0EDTVJ4pPCp4jS3e97ngHe+XRb98qG?=
 =?us-ascii?Q?ru8THdTuZ9DMOa6k/SKFtWOxuDRGnVAo685CNiKmzgeLrTIAJOBBjg0VYord?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uJb9rGSvy6aL/V9uKoVzMdZHAPBbNEUd3Admr0/wEhDDxxrgUkiQBweIJiBzsQmqyFEBgx3x0O6lPdarjgnredEgSHZeG6OhtW4KdfAAqqRS4m7vTdu6waBq2Qy48OT1ps6XWoXTTp/ks2Vln0H9om1Vqaji/WpS2j/iVvp1zHRW4xz4qgGEADnlk+Ca2wRHL2t3mbw5BqLvgNvwTqUU0pYjgYrpY0P6Hh9Oqs9Q+zywCLLVCZ0Hu0qVsCpssm+lmqYHAkFNhCALT/RmxSYRXiuyZfEprKk2CRT7UDzrxydfeOOgY+vxlAH9A90sbnI5wID4IuxkqTngy1UUUwHa0mR/RZ0jc/ufY2KQl6XVTrsDBWgLy+RKgMjDlsseTkcBdDiUdzoAThV0kYXpYVEpzO/wN7VLCtWh4qrqLcTgLvg2a+lx/7cyz7jHu6CXjlfUJvIPEG2h1eeUlw4NZswNi05SEFjumkfpVxy1QPEeMySnLhJ/ikhyfU/OyHsMXl30S88A+7kaixrvxzWoGZM8l0j29sGRiD8QuDYtjeesyfJ3Bb66NMnGhwWqDlBE8RSxSS9Iz2V1Z5c/PaRFKBn5ssviLUwU8KDDFVhMPaXDud8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 922b2676-f3e2-4c43-f2da-08de1ef4a2bb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 18:28:38.5750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kHXcoM1+iR4IcQOWC0xzEQ+KsEeD5/L+58wJRi6X3gIN8gRaSNL8j5chqxaAA64tXP+KCVEdnea0I/4/5TZC0QjDo13QOsR0HVWcRzml+kY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7016
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=782 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080150
X-Proofpoint-GUID: 4hHuFKPnkgxmy6yyLd3YBjKnElv-DU4-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEyNiBTYWx0ZWRfXy7hqqRkExoO4
 MpBdwWYp1f54e6VM8dRFYVXGZFDjqZ6BJ2JY4KxrkJ/iRPi45PrQ+E2letx/ol1CHJ163i7AQOL
 +lazXqvzAOv31UjPOjdLFlxixTfWUHvq1mwEyhFxBs1rg+E6rr7WhA2GFhVhRH5Xt3zRO0Vwk6X
 Uv2XPo1vtgwD39W0pQsJrcFcr8HyHWfvTyHPyqoJkYXz9rl9bundsLVHhKFarX6319I+cVpXQMP
 J8hpadggzBKu5xyhXzgsuM2d1jTu5U/00KNH1+PILdc7GkatP0O/m89pV7KFbasHvgJV51rsdLh
 Lbjrh8eDnoZbnn0vdlppL5BRgTwewzGRyoTmGlIPlwcQ3hw5O/rVl6ihfZJPp9JxqrFOhh38I/o
 6xs8dAfazP7sQT9B0mQgsbnYHeLWlA==
X-Authority-Analysis: v=2.4 cv=XuL3+FF9 c=1 sm=1 tr=0 ts=690f8bda b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=KwMgZv5xIcckdayViMQA:9
X-Proofpoint-ORIG-GUID: 4hHuFKPnkgxmy6yyLd3YBjKnElv-DU4-


Markus,

> This series adds support for power resources defined in acpi on ata
> ports/devices. A device can define a power resource in an ata port/device,
> which then gets powered on right before the port is probed. This can be
> useful for devices, which have sata power connectors that are:
>   a: powered down by default
>   b: can be individually powered on
> like in some synology nas devices. If thats the case it will be assumed,
> that the power resource won't survive reboots and therefore the disk will
> be stopped.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
