Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35D31CBA02;
	Thu, 16 Jan 2025 08:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737016744; cv=fail; b=u4u4WEyTISmjazvHMwAuSVCsITnTDO1/uCBSS6HyoRltqHRWYK6brbplbaQHoIKRpLsvqeMlT+fwsSKSTAPyiMPzvuqQBS2mYL9D9H95uxHstDsjAIuEyIFm8baMKjUZrqpoashvv58AeO8UqAlsv82VcIC6JjoiFf/E55xEXlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737016744; c=relaxed/simple;
	bh=57IzwQC+K0fWb8aoSYwnK6eJa1FYF94uz5SVEQPzgEM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dRte9N5bzVTAWwArJ9cqQtao7bfMb2d1Qhg288ZXt5irInCANQ9aQymzekCG1RsQknTXi2fCYX4I1Pf/gtEMl81lrqJRt/Ea72qN8FojprylS20rrekOj3fzPS6x9MyIa3agJOD5O2f9dLLCus7l1iH+usOFle3xYXIGACUy8fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hHub79b7; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=QAVuXKCh; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hHub79b7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QAVuXKCh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737016742; x=1768552742;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=57IzwQC+K0fWb8aoSYwnK6eJa1FYF94uz5SVEQPzgEM=;
  b=hHub79b7OmulGW6N+kObW6t1srhxfN/oZp7oUOA+S8I27NQNJt/Wq8N3
   X9GzPhXkGSlp7tlQ5E1Rc2F7uuBqjmgX6HMu2kwdthwJZCygxEoTmp1i3
   X670K9wxwHa7BFJpo6v2X6cKYbf71YVgpgRrogROewnYSAxyrHVha4nTD
   IZFVLo//xbkD9GfVWn/73HD91oFtz/Pszw3TkgqfGPfTXLPUSqxcwlz9g
   MiiXsP7hmHCDKQuO1chK0NkZTlCk5MFq95oUziyE4PzulYtEz82m49jXc
   Kt04W1J6bizkOo/dmTpJoAF46LjEvZZqvHffR9jhPIcPnnVX2nZkyRiPe
   Q==;
X-CSE-ConnectionGUID: 4Rqt8CrJRUydaxQWbcTdEg==
X-CSE-MsgGUID: uU9aIw2yTAmN5hOL4Y+DtQ==
X-IronPort-AV: E=Sophos;i="6.13,208,1732550400"; 
   d="scan'208";a="35844286"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.8])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jan 2025 16:38:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=acLLnCkX8RNTkeDjc76NR+SKgJMMExC4ZeYawSZAYhhqdjoztshYxnKuBAOU4eKfx3s47FLiQZlB1RhsHO6IOwmhOxS+inbt/opYOopbPFB9qWfWMztYysYRoD5GewlsTwd3h0B6nntKmwW1vTPGWPqFx/QMNwxaVf3cY9kB+nyG/R55ohlnBfe3DMYWE9JHeo3ZtBCiC1HmX7ZnzEBTPYrKWLpHWWid1IjQO+2qY0/ZP44W8t6Rfm/jLJGzPIXbguRagVtdyrwkJCIJgxFTEetaWsyH63MoUf//bai8Iw3LtIIfihFC977M8QztwMFcz13VZu//o2XwQTNuW7c5Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57IzwQC+K0fWb8aoSYwnK6eJa1FYF94uz5SVEQPzgEM=;
 b=ZVPvcdf/OB2U8qICNCEeGlGcOpLnBx97UThwhA2q3DYhYI2lSl85KTPANttH6wAQbkeTccAiLoXB7XR3e6xcNIt3lXSN+x2Pg4KAPFEZmfT+oom+vHhe8+rGfPXwzMV8R6iKtwj2q2KNXOMFne5VobWtkT5DsH5WTsfErvNjaH8oIOb7P4Ajj7UbdKILP0DqhhP5bCXKIO4cswHetgsJ136oy+DO4GMvsagBuqbp0oyjjfVlrROk/ximeQqhhD8crV7MAcII/6jkg1e9MsMhJWANiFIR7oIEKRT2f+ICM5BuHAkYNJMSkKbqT++HJ3BrHIpYZ6oJaW4JcXX+7ngpcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57IzwQC+K0fWb8aoSYwnK6eJa1FYF94uz5SVEQPzgEM=;
 b=QAVuXKChEKcjosooz5lLEqIm4CwtUvGtX22qKHco9LOuhJyaeTG1N7keEUveS+AdAu6TX9oOhtFVdjN6hfX2lE4WsMUzHiY7WHPK0Z0nQ7F6kpEfQVktInT7xIz+vSlC/yc1qXmfnOCLcRSgRcVXWjbLWUuTt/HwK7w9LRZeOt4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH0PR04MB7189.namprd04.prod.outlook.com (2603:10b6:510:1e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.13; Thu, 16 Jan 2025 08:38:50 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 08:38:48 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: DooHyun Hwang <dh0421.hwang@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>
CC: "grant.jung@samsung.com" <grant.jung@samsung.com>, "jt77.jang@samsung.com"
	<jt77.jang@samsung.com>, "junwoo80.lee@samsung.com"
	<junwoo80.lee@samsung.com>, "jangsub.yi@samsung.com"
	<jangsub.yi@samsung.com>, "sh043.lee@samsung.com" <sh043.lee@samsung.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>, "sh8267.baek@samsung.com"
	<sh8267.baek@samsung.com>, "wkon.kim@samsung.com" <wkon.kim@samsung.com>
Subject: RE: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
Thread-Topic: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
Thread-Index: AQHbZvSIWloEi9C5LkuQH5xvf+gp7LMZFBFg
Date: Thu, 16 Jan 2025 08:38:48 +0000
Message-ID:
 <DM6PR04MB6575C2833DD66B847572F53CFC1A2@DM6PR04MB6575.namprd04.prod.outlook.com>
References:
 <CGME20250115022348epcas1p29705c109f51c01e1e91ef227233c7119@epcas1p2.samsung.com>
 <20250115022344.3967-1-dh0421.hwang@samsung.com>
In-Reply-To: <20250115022344.3967-1-dh0421.hwang@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|PH0PR04MB7189:EE_
x-ms-office365-filtering-correlation-id: a0e1b64f-a72b-4441-5ff9-08dd360932a2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dWRWcXdLMzY3VmJaczJVSURtTDBWckVabzlnNU5DWWxYWjZ1Mlk1Zkk4ZFdW?=
 =?utf-8?B?ZHdkM0svbDY3dHJZZXdyd2w1MUxOM01tZXl3VFJZb2hTa013SkVkK3RuUGRB?=
 =?utf-8?B?bHc5UEQyczJQUGpma1l5NnBuNzBpTUd6aGNac014dml1enFoY3FyTWMvRmxE?=
 =?utf-8?B?clgxR2txQUFUVklNc1pSMncwT3p2azY5MGUrbGtwNE1iNzlSRS9GQVFwVDhB?=
 =?utf-8?B?UXNGR2plSi9iMWEzem41UVhjVVh2eGQzLzBvczZJbzBQL0VEbCtZZ2FSdXRD?=
 =?utf-8?B?STV2SWtKekNFSnlwbnVEaUp0eTZYaERCK05CdEl5RHcrOFduWGk4TzRaUzlV?=
 =?utf-8?B?aW1QUHllMFptZnVESGlJM1V0MlErODIrVjltMnAxTjg2QkEyQXZkekZQWXFs?=
 =?utf-8?B?SysrUkREVmxhRUZpR3kxaW4vZkJDeHBuMDZMQTBicnkzQUxXUmFnM2hMVkZs?=
 =?utf-8?B?MTRXbStuL2VWVG9qYk1GNHBpRGZVVlF2V1dzRERRWTBZeFNaT0JQUUNMVW41?=
 =?utf-8?B?YkRiYjVEaDQwMzlvZmNCUzQrWEhOVG1GTDFSMTJFRVV1WUdEd0pENWRpdlZq?=
 =?utf-8?B?RFFVVDFVUHhqb3dIVytWd1NCM0w0azV6S3RnbENWZWV4YnZJZ3NadDVyMUdY?=
 =?utf-8?B?bWs4clF2dXJ6aVZiSERYb0xIWWtvMjZEZHpBckN3bzQzaUp0NmtSV3lRd3RV?=
 =?utf-8?B?WTJoSnJDOW5EVnNMc3pjNGtENEZSWWdGUytMVzdLV2N5UWtnV2ExT0YzU1BD?=
 =?utf-8?B?dnBDT2w0aDhtakZVaTJCVFlSb0libDBUbFNyZHpJbzNvVHRpNG1QQnU5VFd1?=
 =?utf-8?B?UWIva1V6Z0pUZnRTZDlZeis5ZHh6SmVTTVAybUJjVzgxYW0wNGJjV0M1K3Jp?=
 =?utf-8?B?NzJJb2h5eGRXRVhBeVVrUUNOL2JlcTBSeitTcEMybEVjeGkzaEYxY1NxL1Uy?=
 =?utf-8?B?b01lWEZZQjZURmhRczlOU3VNaVhkTXN2WVNGQ1J6eE9NNWJuMG9KNkFHWm1y?=
 =?utf-8?B?QTVJWWVtdnN0MlhUQUtGa2xEajJuT04yWk5yRWlxNDhFMkptOWNmeDd6NkRj?=
 =?utf-8?B?Um81ZVRRb0EyZ09FUDhjdmxBd29BYkVXd2k0Z3lVZnF1SDFYaEk0M0Q4bGYv?=
 =?utf-8?B?b1BsTFhLNVFIWFNzbGNWdEx2VmV4K2dFMWp0VmYvQ1l1OU9sOSsxNnN4QVVx?=
 =?utf-8?B?ZDU3TXV5alJCbHNxOXhWNmlCVkxzNVkyTGpwMFZRcmhaUEZsckdhYW5WZ1Zl?=
 =?utf-8?B?VWs5MkxrdnR1SlIySWgrVE1aNjd0TzJicEZPYWEzU3hHUysrS2MzNXU1SlZn?=
 =?utf-8?B?dFVqMUtBV3ZTeXVpL2t3SHE0UytZTVlLYVpOL1FRaCtwa2tpd0RxSDcraWRq?=
 =?utf-8?B?NTJsQ2VFUnljTTJrdUZhY0lmb3Y3cEpDTlpXT3ZGS1ZKQ0NHcWVvV1RheE9N?=
 =?utf-8?B?ZWlYME5EZHNmczFHaGJ5U2tJa0QraFdhOTJRM3M5NUNLMFlpNGNBbURKZjBD?=
 =?utf-8?B?dnNFQ0M4Z05nSGhFNGtxNGtab2hzMG5EaDYxSnNTb05xcm0vMXJFdVpCU2Nq?=
 =?utf-8?B?bnRqNVhvNGg5WXFINW4rdS9zWTg1cWgwelJzWXdIbTRhSWU4ZUU0Q2dPTVBn?=
 =?utf-8?B?ZWhIUmZ3OTFaRm1YV3A0VlhsVlFlMHkwazVZTkdwWnkwVnVjdWZrWGFXT0hI?=
 =?utf-8?B?YUVRdFpHc2x2NHM0RXBSV0dQbVJ3YklCZXUxN1R4Mmc5U3hnUEhKRlM2a1gv?=
 =?utf-8?B?U3hITHVBMjdPanVQbk4xKytUek9YR01kR3NFNkhIK0dHWjdwb2k3RGE0UGEy?=
 =?utf-8?B?S0h6Z0Rpa1k0dCtnTDJXUkdjT1RaR0JFUmR4MWVyZzZMOE0rcjBKa24yQlZp?=
 =?utf-8?B?Tjh0bU9iZjE0cVlSdC95WFhOcERiTnJNbk1LL0JEZzZ0NWhyRjRoRTZ3Rllh?=
 =?utf-8?B?NTF2bnlLWXBTYzEvR2lmVTFlbUVMTmxZWDNITEZkaWFhVEExaVZNeitpRFdl?=
 =?utf-8?B?My9lV2dpRXRBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZWxwM0E4Vm9aYjhUcEYxOXRiVmV4NFJLMUtjS1lDNGsyQnBxRHRyRG5ac2hB?=
 =?utf-8?B?dzVUL3l6UjRwRGN1dTFFRTRCWFVIWnZ6OWkwbjYwaStYNEZ5Z2JtMktBRlVs?=
 =?utf-8?B?M25YbEo4ZWJnNGVJWThhVUR0TnlJNGQ5cnlzTm1KUTZOZHVyMkFKUCtjY1V4?=
 =?utf-8?B?eVIxaCtXeFdBaTNPcmZML3B4eDRIZWtlb0E0UTdZdE5MWldJQmJLb252Y2hC?=
 =?utf-8?B?c284VzYvOFNsdXAxa1p2cEVqUENFcC80aTRCTTlBUlJKTHVyV2pIMm9VUUxp?=
 =?utf-8?B?V2FPemM1SEUzSGgwVzUxY04xQ01rdE5jcEdxN0xvaVgyVi9lVGhSc1BDZjhp?=
 =?utf-8?B?WE1PREU1R3FreWhITzVYM3JzajdjTWdaK0drMUNOeHRUdzNCMW9wZ054S2g5?=
 =?utf-8?B?WlhOTkRmSE85UXh2VENYemYvNHJidU1zZTBFRWxZOUlWakl6SFB4WFJCdjh4?=
 =?utf-8?B?UHV2MVhOTkJqTVhGU1BsZVlzbWUycXEyY2RmR2F2K0VoeUhXVkx3QURaT1Mw?=
 =?utf-8?B?WGFrQWRlRml5S2NTUCtGWFJEbU5VUnNrMUNZK2ZKVHVVTGZSQnBFb3g1OHhR?=
 =?utf-8?B?NUFBWGNCVkc5Y0k1WUR5b0dUS2pUQU8wMXpiUnk2RmFnQTBVNVphc21KNm5O?=
 =?utf-8?B?cFh5S2ZaT3dHNWo1a1pTTkQxZ05ySzhxRDJIaVc3ZXMvL0lyanVzMmordVV3?=
 =?utf-8?B?eWgyOFVSaWJ1MndoNTVZSDFtdDNxZ2lseFloU25nR2pObEE5aWM2NUl3Z1N4?=
 =?utf-8?B?MEdQa1FjeVVXOHpabjlkZGZlU0ZPTzdOUFNTV2ZNcGIwb0RxYVJ6Q2R2ZnFn?=
 =?utf-8?B?ZmlEcHBNV3I4M2JLR2ZTbkVmMHhGWCtvOEFBd0N1eEdEY042TTJPU1o0b29Z?=
 =?utf-8?B?Ky9jWkFPMFRDeE9MUG9KeVN2M3dEVkd1bDdnVnhoRzBZbWdERmtuQ2hXZTcx?=
 =?utf-8?B?NW92NHM4NFVtUDhWVkQzMkJGcFZ2MlZmNitCcXU3Qkgxd0l2VkJPczlmdzUx?=
 =?utf-8?B?QisyR25MUHd5L2p3ZlNPdURhOThxNHIwbE5WVUUxcHdhVmtRMHNCczRDUkIr?=
 =?utf-8?B?SE8xc3Arc3NIbWg3V3FoYzJZVjdhN1R1dVBMNTJOcWVsZjNIeU9UV2xYMUdH?=
 =?utf-8?B?TUxmVW5oZjN5bGVhNEFQTmNoMEdUK3dvalg0WjlucmJxVG1wNHhLTXhPWDZ0?=
 =?utf-8?B?RG5GWElVK0NuODRLdzAyYkhYZnNEa2Npb0NMQldhMEthR096ZDYxSkRoSG5I?=
 =?utf-8?B?QTNVV2pRRWlwNkt5Ukh0dEYwZEtmaHFBeVljOEI3a3dxcm51VkRMa0lkOTJB?=
 =?utf-8?B?OHRZd2hQSGR5OWpnc3F0Rkx6dzRaTGhqOFdIUG9PSFlYVmZJVDgvbWFPRW0y?=
 =?utf-8?B?S3BSRXJnd0pXaFB1Q0t2T2UrUUtsMTVRS3hLNG5OaHV6VzdvSDNzWU1JaHBK?=
 =?utf-8?B?dld4Tzd4Ry9uMlZTaVNwS0N6dENGVTJXcUw0TnlUbkFLWkw0Ymt3VXRsOXBH?=
 =?utf-8?B?Tms4OGVxYlNtdzNOSHZkaEZqZGYrRzBrK2Rsc0p4NGpzRlNnbjQ5Mi9vdmlX?=
 =?utf-8?B?cnFYcHRocHhrM0J0QmMvMUZnYllVdFVQNFV2aWF5Zzh4RFNNbHZkYjYxTlhw?=
 =?utf-8?B?NVdBclRsNDZZZ3hnSVVVK2cvWmJsbXQ2aUxWNkk1RE1ndVR5dG1NMFV3R3B0?=
 =?utf-8?B?WFE1dUlyNXJhS3JiQkZrd3Y2TGRKeEtVNGtkdkZOdHovYXNGNTB3SGVQeVFu?=
 =?utf-8?B?alF2T1F0U3NWYlhBVFdOSEl4YkxlVUxjbnFKOHZ2MWJqM1pmR3VUTUliWmgy?=
 =?utf-8?B?Q0p4Y0E0cjIxMUNLZ3BxbFNMYVN1UHZ1Q1hHcTM0MkNSUTdRdDgwWlk3UEpQ?=
 =?utf-8?B?ZGtsc3VDQ0pMRXlwOWQrWkE4RjhFd0FRdWJad2thdnROanNxbmo4R2VxUjhn?=
 =?utf-8?B?cUhvT3RGU3NRalZEYjAwRG1US1dSdHMxeVh2RzZGeSttcFI3WStJVkZGQ2pD?=
 =?utf-8?B?dFBJdFdlNnYwc3lhNDBXTnI4YVFPUy9OeWpiOWgwcHNvbnJGY3hkZ3h3a0cy?=
 =?utf-8?B?SmNuOC92NGZad1U0SldnVFAvTDYzWkZoaU9hTkE3THpreVV2QnczU3pNUFNu?=
 =?utf-8?Q?pH6yoT/Q9fivEu+6p25AHs0uK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w1GTS+CUbXhmlPM9AoSLW0KSNBos65XKnNmEQ3mfAv6UAmJSFiqTAQBmsYvYJaHypsbOA4OlEAzVOg3tg45aJFwAGxfs9xeEJQnD9Nk4JKUIVEfrltXpYPCZVC0Yj4BSN83G45EU0L2XrpW5zgF7LQkcGo0N99msh/d4E/LGqYYIfOKejMTzoGhr+PLv4/I90uDBKA/QiryCn9JusAgMdXv8pdWtHZkgBNYeQDEdb2lbgK0mPJG/+V4phh3neMF/a/6/I750cfURJQhD6N8ngso+zmHgZgQe2swBqqYbuJz0z0m0A+8Vd6/4JnPXrRu2hTxnyU//5s992iwrh1w1SlmbrrBPSxFyVsHj+OFa9CH8+DNZSRXHpMIoI7BKJtpjJLG1jqbA2wgE/T3cjSEcdl5pp4EYV2LOm8+ylahSTy/p2zn+jI9AizTHYs8nXfpzHObJAG5Ecc4ekEMJc6KQLV+AztiElQqtBf/9fGR3wbKQBfufTyiLtvJBTfijs/3Ij0h3hdxHYFs1XAUOyDWgbJ2r4bYpSt0k80aiKpSXwW2SOsoO/GxQRe8YChAr6Hedj5Tj4HGR5QqWZy0L6cN5NrZZgBBlVgApu6qQSgdijfYpUyaqVm/j+HYrwEmU2IO/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e1b64f-a72b-4441-5ff9-08dd360932a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 08:38:48.8185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+w+fymqjdouxRA+M62BcM7pNxWrH+qiV+mBVTdnQi4OjBpZq1KisYbBHmtT7pmc6zdITYBGsE3qaEYvuRkiDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7189

PiBJdCBpcyBmb3VuZCB0aGF0IGlzIFVGUyBkZXZpY2UgbWF5IHRha2UgbG9uZ2VyIHRoYW4gNTAw
bXMoNTBtcyAqIDEwdGltZXMpIHRvDQo+IHJlc3BvbmQgdG8gTk9QX09VVCBjb21tYW5kLg0KPiAN
Cj4gVGhlIE5PUF9PVVQgY29tbWFuZCB0aW1lb3V0IHdhcyB0b3RhbCA1MDBtcyB0aGF0IGlzIGZy
b20gYSB0aW1lb3V0DQo+IHZhbHVlIG9mIDUwbXMoZGVmaW5lZCBieSBOT1BfT1VUX1RJTUVPVVQp
IHdpdGggMTAgcmV0cmllcyhkZWZpbmVkIGJ5DQo+IE5PUF9PVVRfUkVUUklFUykNCj4gDQo+IFRo
aXMgY2hhbmdlIGluY3JlYXNlIHRoZSBOT1BfT1VUIGNvbW1hbmQgdGltZW91dCB0byB0b3RhbCAx
MDAwbXMgYnkNCj4gY2hhbmdpbmcgdGltZW91dCB2YWx1ZSB0byAxMDBtcyhOT1BfT1VUX1RJTUVP
VVQpDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEb29IeXVuIEh3YW5nIDxkaDA0MjEuaHdhbmdAc2Ft
c3VuZy5jb20+DQpXaHkgbm90IGVkaXQgaGJhLT5ub3Bfb3V0X3RpbWVvdXQgaW4gdGhlIC5pbml0
IHZvcD8NCkxpa2Ugc29tZSB2ZW5kb3JzIGFscmVhZHkgZG8uDQoNClRoYW5rcywNCkF2cmkNCg0K
PiAtLS0NCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMg
aW5kZXgNCj4gY2Q0MDRhZGU0OGRjLi5iZjVjNDYyMGVmNmIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0K
PiBAQCAtNTcsOCArNTcsOCBAQCBlbnVtIHsNCj4gIH07DQo+ICAvKiBOT1AgT1VUIHJldHJpZXMg
d2FpdGluZyBmb3IgTk9QIElOIHJlc3BvbnNlICovDQo+ICAjZGVmaW5lIE5PUF9PVVRfUkVUUklF
UyAgICAxMA0KPiAtLyogVGltZW91dCBhZnRlciA1MCBtc2VjcyBpZiBOT1AgT1VUIGhhbmdzIHdp
dGhvdXQgcmVzcG9uc2UgKi8NCj4gLSNkZWZpbmUgTk9QX09VVF9USU1FT1VUICAgIDUwIC8qIG1z
ZWNzICovDQo+ICsvKiBUaW1lb3V0IGFmdGVyIDEwMCBtc2VjcyBpZiBOT1AgT1VUIGhhbmdzIHdp
dGhvdXQgcmVzcG9uc2UgKi8NCj4gKyNkZWZpbmUgTk9QX09VVF9USU1FT1VUICAgIDEwMCAvKiBt
c2VjcyAqLw0KPiANCj4gIC8qIFF1ZXJ5IHJlcXVlc3QgcmV0cmllcyAqLw0KPiAgI2RlZmluZSBR
VUVSWV9SRVFfUkVUUklFUyAzDQo+IC0tDQo+IDIuNDguMA0KPiANCg0K
