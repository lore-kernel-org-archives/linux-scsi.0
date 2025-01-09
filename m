Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418361474A9;
	Thu,  9 Jan 2025 07:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736406607; cv=fail; b=ILwY74u6V7sU5c7SN/4IkoF4kv+fFlHmoW6Lp8A0plxmAIilZvN4Fx1K2Chc5fA7B6cgTZkFUgQPeA3LWO2N2/L3mpNLRqvzqCbQriT99EHKDQ6qQkMV+ehZHX099BQ8xHTM/jqjytQ9XwObUI402jVKfrm1imHJvwB9/s+UkCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736406607; c=relaxed/simple;
	bh=YWEyXo3TbBFoIRMHbeKuZRwn/lGYyRDjv1biiCrYfAs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n/q5SJ1F754Nm+wm6vVh+q7MJNcbp24pokhDR4VzjdFxyiJ0v+cOIj05ENnCox0ccoeHQ7qvmkj+FC/Kj4pd9EM+3SNaU1tp4R/9BYPma8HoBBNTv0ehGvT4womPvVhIEkMbQIh26Zr1p6Yy1qA97+z7FOKplmaVJ2Z8nvy/2fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ByGWtNqi; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=KI+g4MZ3; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ByGWtNqi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KI+g4MZ3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1736406605; x=1767942605;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YWEyXo3TbBFoIRMHbeKuZRwn/lGYyRDjv1biiCrYfAs=;
  b=ByGWtNqiRc59D6XBQabAJ7TkWev/D5Ljrp19ARnAOTC9TCT38Apa9dsj
   UoLNI78ujhEObYOBrfU4lucl+IMufSatVsuu8WrQO+uYHO5ZXRbpPLZhW
   smXIvXRJq3+zILntK+334cyycf3o5kYyXCtEenfbKu5DWdLgjdQtbtzYS
   6ePihTtlOyTnyyttAt9AuzzU+i06hbuW4EGWsaQqGL3LPhXiTXuHY3pVz
   wMDVjG4Vb03dOYGYeHXmEzUoFLAL+vV3JiG+NunuWfeDRgASycmuHH6AX
   MtfDyOMUPNSO1KmXnCCbA+g2v2aOOuFZJ1gKNZwrtWy4HjQV9+G5xXu4m
   w==;
X-CSE-ConnectionGUID: pf3I3lfzQgyrJSQFX5qGhA==
X-CSE-MsgGUID: AnAhEYWiRZa1/nuFhlc4AQ==
X-IronPort-AV: E=Sophos;i="6.12,300,1728921600"; 
   d="scan'208";a="36731160"
Received: from mail-westusazlp17010005.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([40.93.1.5])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2025 15:10:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gHVh2Wq9t9DE1WVZKSptMzOIhgxZj5F4Xq825cVAes991jiwBLN4JM40WpsHzggvS1lcwBWzfI6bZQt8b69yvzd0NXiwGgkaWo2O8qv0axArMuIYduN97qeEnp3Bo4CbQ9e87f2v0j8bC6ufCswkV2tklZucNUJ0Jo2TEmgdlP0R3Yrd8trYl1dd/PWo/I1CnJY3ATzrjBebeZkWJnWfsu4+f36RMXaq8zNHFEKsWMUOFfTpS40jzWXv4zzM2Jz3BNG/CW7zfGwQMhJK+pcmgI3XXfzTBPpARBmHnLv0+d+0mlPEZHNsCP69GhWJ4vGXGeL9iAU3qPLzjlSjpG8cfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWEyXo3TbBFoIRMHbeKuZRwn/lGYyRDjv1biiCrYfAs=;
 b=cyHxoghMhd8b2tGTgMJsJscBG+4JO+TUyzBfaKStU1o4QQhNl0IRHwoSuNNsTUdcN/EBiaZDU4Cv35hvesDIEFdXrtarPo4RAD8g1okx59lPztPSQmWpiRcm4YmSQbGHPGHXsyGjUF5QH1aYPFxBOmCmxBNHyXFFJgBNVRH5zNcN4lHPN0+qliAVVRxlYOLixdH0nHn0oUfP9USgcRa9r3JWgzpQBd33ismJRJW8NJ6Xe0cA6VqeevS2PnX6E7KFUqAGwlSyexdjBUD96xyhQk02UZiA42/paS8J4jonnLhU8IguTp3oLCWR0QspPIWoK1ix+7RcdsuF4Lnr/V58wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWEyXo3TbBFoIRMHbeKuZRwn/lGYyRDjv1biiCrYfAs=;
 b=KI+g4MZ3t8DkJDFiaq1UMV6drCjYhMMNPQbCXraH7XDRbmOakhgQUt/FzCpszMgP1F/2s5CK9Bz8lmZ0yaOzPImrJi8o0pjYqCS/+M4Zmi96vAaOREBq3ju3i9ILe+2wlsJ9Z2ElL3VHgHUslHY59VMphc9ziOfP6WGSeA95yGI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH3PR04MB8901.namprd04.prod.outlook.com (2603:10b6:610:17a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Thu, 9 Jan
 2025 07:10:01 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8335.010; Thu, 9 Jan 2025
 07:10:01 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Bean Huo
	<beanhuo@micron.com>, Daejun Park <daejun7.park@samsung.com>, Guenter Roeck
	<linux@roeck-us.net>, open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit
 Definitions
Thread-Topic: [PATCH v1 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit
 Definitions
Thread-Index: AQHbYijizBA9pgaWNUywhEUKAqK4R7MNkh4AgAB0XnA=
Date: Thu, 9 Jan 2025 07:10:01 +0000
Message-ID:
 <DM6PR04MB6575BEA85BDCDDE769B8721EFC132@DM6PR04MB6575.namprd04.prod.outlook.com>
References:
 <5df3cb168d367719ae5c378029a90f6337d00e79.1736380252.git.quic_nguyenb@quicinc.com>
 <ac0e465c-3595-96df-9be8-c067b823a13c@quicinc.com>
In-Reply-To: <ac0e465c-3595-96df-9be8-c067b823a13c@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH3PR04MB8901:EE_
x-ms-office365-filtering-correlation-id: ac5e3281-5639-4795-a4fd-08dd307ca23b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cHZXWXhyKzd6K0FzNk10SE5BV3dBUDJrVi94c0VLeFZocS9TYy9ZUEd1cjl2?=
 =?utf-8?B?UXVDVEgwOFRMYk5sci8xb0lsYTZjZUt5QytIUFIvc3NvbmR0S202Z09yM21a?=
 =?utf-8?B?bXllS2dVaWt4eWlhaGZ2bWozRzUzTnJjRlNYUmhRa2p4Zmpta2IwZUx2L2wx?=
 =?utf-8?B?QmxGV2ZjbXBZYzJ1MUhQcUVkcVNVTWVXSFVaWFV3R0FOMjJFK1Z6c1UxN2g3?=
 =?utf-8?B?NG91cCtNSXRtMk5mVk95bkx2VCtHTDhvbFcxZXI2a21UVDRoVWdmZmptZytP?=
 =?utf-8?B?NWY4WWh5TGlVQ3dKQWlGaXdZOE9VZE1wVFRaZVdGNEhJNVgrK0FkQjdOYnRz?=
 =?utf-8?B?bHdnN1VkcUQrekg1ektjTW1TM0VqMHJSQ09IZ0I4cnFza2M0eG1GVnVNUlB4?=
 =?utf-8?B?MWxkWmgzdUR0V0N5eDlxRWVZelNMakVLcFBtalVyZnFQc3NpRVFmdHF3cXpY?=
 =?utf-8?B?dFhrQ0VFMG5lOWNsZG9ENmtnMy9PT05EeEpSZTNxY0ZqaXBoa2pJc2l1QnNW?=
 =?utf-8?B?OWw3WENsM2JmcWgzbDN5WERsZ2t3dC9wSTlIY2FJSnhnaGFUTDlvdzd0bFlj?=
 =?utf-8?B?TzhKUGNSTW5nY2lyK1BKaG03Tk13bHRaMzFRTGR3cEJ1KzMrUVhoM0FlRXhz?=
 =?utf-8?B?RDh2TUVVMWJ2aGkzRFdKaWxabnV6bHYweDMxTzg4RVpOZllvdDRGZHBqVUcz?=
 =?utf-8?B?dFJTaFNWR2FjVm9ST0M0dzBMNjZRS3o3TVhGSjJlT2YzWkNpTzJRUkpsTGxJ?=
 =?utf-8?B?UWtZem5jNm8rV1RNVTV4NmlYOFN4aUFKQ0VtTk1TMFIyRVkwNkIrWjUzZnBL?=
 =?utf-8?B?V1VML3hEL256QmdrbE5tVFFsVTk0YlZCNTBvaDNLY3JlRzhOSEt5M3VVWUNU?=
 =?utf-8?B?L2ZwMnJ6S29BVlErN3lESEkyWXV4c3krUHVySkJzZk51R1p1SzM3Y00xcmRw?=
 =?utf-8?B?aGVuNm54K1h4T3ZtSGZrNjgvdlZScTlwZTVUMkpHUVJCUkYzU0pCNGp3ZWlB?=
 =?utf-8?B?WFJJUmRnNmFkdFg0RklVZXVRcFFyMFJGOXhNaGFQckRiN1VXYnd4a3ZIUXlC?=
 =?utf-8?B?Nlg1ZEFzV2t1SzlKMEdtaVVpSjB2Vk5oazc1cnBrWmZJRHZjYTh0S25sYlgv?=
 =?utf-8?B?SVZhcFluTGNvSzFyTjZJY283SVBPWUp0N3lXRFNsQXlSRithenZZU1FjUXZh?=
 =?utf-8?B?Z2o0TFByOUlhWjV6SXVhWW1FU0N0YllvWFFxeXZqNHk3MmpOazNiMzMxdnNB?=
 =?utf-8?B?ZGhxY0RZUHZwWXJUNHhESUlmMkFKdFN1aEt4SllTeEh3UEVCRkpDc0hVREdj?=
 =?utf-8?B?d1hsSGNtMkRVOXFFUkhXTjRwS1RBMmNyb3VWNlpPbGxxQzVpK0pENFhuVDdh?=
 =?utf-8?B?MWU2ZEFzV2dhdDNNUythWE01U3lLbVRTVUJGYWVuTVJ0elRLK2I5RDhFN09C?=
 =?utf-8?B?dWoydnI4VEF3dDM2R0oySzVhZGE2cFc2TGVlamZCVFB4OWUzeXdLdjZSSjdp?=
 =?utf-8?B?YkNuemR6UmJLZlBCRDl0Zys3dHZwdU9BS0J4R3hFclQzd2ZkdGdsQkZMSSt5?=
 =?utf-8?B?U0V1MzdrK21hUDV6VC9rZExDNFhmdGMrTHJjc0djR2dUNG9PeVdzMTB5ajJY?=
 =?utf-8?B?YzVqSE9VeGxxWGF5YVlxYmcxK2dXc09JQ0ZRdVllK0h4YlpmY0xxMHVLNG1G?=
 =?utf-8?B?bDVmOEhSRjh4dlpqbHVrVVZ5RENVMU96QUo4dThjVkVYQ0lLYkoxSHlhZkpj?=
 =?utf-8?B?NFBtRmJ4UnZPaUpyUE15RnpBTElqYUlLYkRBREJ5aFcvU0F1T3ZRUUltdUJ2?=
 =?utf-8?B?WDBSWFBqY3BzdUlidE1MOFpJT3Q1eDhVZVBqZHhUcDBXMm5jVjJ5Y2UwTys1?=
 =?utf-8?B?TExWeTd4Rzg1dkpqL0ZNYkFiQVd3Ui85UGpTZ2J4NHVyODdNWGpJb0JqeWpu?=
 =?utf-8?Q?+OocmVm00z/7cy0MdgdXjCJbfGR2LxOs?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dHRJVlp4VEVaUUpCVGFDWEFDcTFpVTh5UjFvWkJVNUVFY0JuVkVwM2t0ZExT?=
 =?utf-8?B?cGc2SUF2MjQrR0V4Q1JCQlFHTGFrY0VxMUkwdEdxRE1oY3p3TkpYcDlQWFVJ?=
 =?utf-8?B?UjRpRWxLZmx1Y3VvekorVXFXNlhBZURVUnVuMXNxNkRMTm5LK1dabm5nZ1R3?=
 =?utf-8?B?c3dNY2dXRU9JSUptc2VQdDN5Wko2S2pTYjZ0dmhMM3RFL3dqdEo5SEhWUmRx?=
 =?utf-8?B?dEt3SjBJaXRCalJFOTd5WVFMb3hrUndHTjZUSW1CcEJhNEQ5RHpMZU1UbGtj?=
 =?utf-8?B?N3V6cHpEMFpZT2VRTWNBS1o4Mnd1bnl3NXZhSVB4SDZVV28yRkdZUUxET0o2?=
 =?utf-8?B?OU5FNHE5WnlWcFdZdUZHaU83RFpvaHU3VWRvbGJQVmVINHEvcmc0elhYRmVB?=
 =?utf-8?B?L1VmaVo4Qmd0MkpIR2Nic0VTMno4UDQwSm54T2FaTUJpRTMzbklwdUFrdVBL?=
 =?utf-8?B?UTN2QVlZVmxwMkZxOVhwZkNxWm8vME55MWpUMGRzSzJxVjJRcUQ4amlQeEdW?=
 =?utf-8?B?K2lNcXRjbkxUTFhGWjlBOVhYZnZYR0czZUVDVlB2STJmWWNteXhOMXVURXlR?=
 =?utf-8?B?RGROQzBzVUpNVEhyZWRvSFRaRkQxa2RjSDhjL3M1U2JYTzZiRVB0MzlpdU9H?=
 =?utf-8?B?bTJncFNwT0dWTjUrdE5yWCt2NXRMYlBGbWpsWi9aWjNuaVloaytENlRkcGY1?=
 =?utf-8?B?YTFuK2l6VW1SbWFlZytuaDVOc040dUR3UHFpd3ZKa2x1MnhRcFBUM1JLakJU?=
 =?utf-8?B?ODZpVG9wRUthL3Uzbm1KOXp4ZHpzUWZYSnZDRkZ4cWdheUVZejdDYU8zdmpL?=
 =?utf-8?B?L2JmOXdYYzIwY0prNEpOSE1WNlZSK293UlYwWEo0ZFFpc3dQT0dtL1I5USsv?=
 =?utf-8?B?blhlR2Mrd2x0d2FTbUl6RjIwbzFMUmhWdVovZ0RUTzlOTFpGZWNrdGd3NWFP?=
 =?utf-8?B?L2N6MGZTcE5mQmM3T1IzWFd3VHl3MzNOVkMvam5MeGZHeTIrMjNBMWozd1Ax?=
 =?utf-8?B?VHZmS3dUOUlJcDRjTlcvZ291VEd2VHBacnVjbHdWZDV3Y0UvQld4UGVPUDg0?=
 =?utf-8?B?Ky9EZUpKK1BTcEpxWFJTY0FXa1I1Q2FJbUhNcGFFNEJyWHZQS0JWeVFDZ0l0?=
 =?utf-8?B?OFNpOGI0VVh5RGNhZ0VCY054VzVYMDZZMTdmQlNNWVBSVzZSM2tlMUpLN0pk?=
 =?utf-8?B?RFJnMXZHOGN6MFBwRHdMNEdUSzEwWG9icU9mekk4bHJFNGg1a3RqTFF1dmZ2?=
 =?utf-8?B?QnV2RTJpdGR0QmRhVlZVZDl3Z3FYYmhzNWZYS1NsQTNYNXQ3MEgyZ2Vsa0d6?=
 =?utf-8?B?RlY1N0lEZnV5ODlvQW15Yk5vcjRmOEdIWlgvbkVrUk8wWkxYT2VMajI1MVBY?=
 =?utf-8?B?VXNkdGN3aG1SN2VMYnUwaUxieUdvTnBKUllJTUcwNkVyUENxNGg4YldBdkNN?=
 =?utf-8?B?SGRla2Y5LzFNNmVIRmpuSFVEK2pXeXlPOTEremtNSnNMWlVZT1ROVVQzeDdB?=
 =?utf-8?B?NXhWNEQvZmgvZ2FYNUE3bXdaRzBPdStNd08wRlU0VzFaT0ZjQy9nbmNTTEVr?=
 =?utf-8?B?T2k4UThTU2VZVFl2RzFXbFdDV0x3Y08zek1rN3RJYk8xZWNLQ0o2SXE3TzVn?=
 =?utf-8?B?VVpQUzlOKzJFSjFXU3Y5RWlvTGVqT0F1UE15R3dqb2VJRm03M1RON2MzZGlG?=
 =?utf-8?B?a0ZXT1FnSk8rTmlpWXRHVmlrOW0ycldyM09NcGdLWUVZWVB4RU5RMEV2VmNa?=
 =?utf-8?B?NDVzMlIyVjluWTNSVjBST1FkckI3TENsRVlzZ0RaaFhsWWtUSXlsbXVjbDBD?=
 =?utf-8?B?N3M1YWc5cU00Q3ZlbTd0TTJyVldKYmpzeUwxV2FaVFVxbXlTVzBUblROeHYw?=
 =?utf-8?B?WkIyOEpwczZtQmpML2NuM05FU2xVRTF3V0I1SmVkSEI0N3lHbkZjMjNwaUVU?=
 =?utf-8?B?a3l2anlJWFFLbG1EdzNxV3AzY09ZdE1rbWlEN2kwUmJiZzJYMTdOV21UQ0NC?=
 =?utf-8?B?WWlKM2ltWkRRTjJFR2NHMlNkSUN1eXQyTEh6SlkxaXlOT0NTK2ozakJEYTdP?=
 =?utf-8?B?MzFzbzFlNm1SbGE5Mko4andIbzVRN1NvQURLUjc1Ymd0MElGRUYyZVBlWDJY?=
 =?utf-8?Q?5R9nZnfuj+f36j1P/OHB1gAKg?=
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
	8cHTlby/mL9HE/JW3MvX0R6nKgk1Rp75bdfNJqqxYvAf17DrV6PsO/5bxnjO39OE7NzYPVaKsMAIN8aCXQJ+1Dx8AJiiaSAdGCfSBlTenqF7Zz8D1Dt5d5gbI6VxBMZ0GRYZaj5b54Ens7LCdX13htCYxV6d6ihM7reOXKQuBbig+22mVfLjoSk9FVZsgR6herAtJL2D17OF+MeiL6agcMoBfKtSKaOLb8XldkrwyrMeVHYbYkc0z8mnfenIB37ha++8RsOX6B9q3VwojZKN/zkDkrMUlhhcOVslnM/Jz4/g9+leYAQWJPhCk/keLG6QxNDaS0BhJRDPe4z5eYlTCCEIGbtTLoOb/zWtdnWhVcvYIZ91jzVaukF97LkCfqplspm1POVXkQ2CGffd4PFOJIj7OUXYKxLDag8W9lAw2Qzo14LSS3G7pxsVkO2Ad2psmp1K3dX+RnaA6Tod7YRFX8xrTiMSkTbjtJej6ksXR9JtZBFfb3awdg8UHTs0cnwLfWPby42E2GcABZWmhZS0EWEfNogQ6s1ewzSUS+1Ph3N+KrchejGxCplkm8Up7SRs3kq0dqG43MHSPC3HreCAKAzkYvr6QdD7K9WNagEmSc2hjOT1CzoFzyttIBuYv3uD
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5e3281-5639-4795-a4fd-08dd307ca23b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2025 07:10:01.1783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyiCtzdj9ECR0GPEW/sQ8Ut5ldQyv+mXudPpk6baq4pBkqfRAJ6tMq1XfRIsue057y82njdCzectE0aMHwxYJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8901

PiBPbiAxLzgvMjAyNSAzOjU1IFBNLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0KPiA+IEFjY29yZGlu
ZyB0byB0aGUgVUZTIERldmljZSBTcGVjaWZpY2F0aW9uLCB0aGUgYlVGU0ZlYXR1cmVzU3VwcG9y
dA0KPiBJIHdpbGwgY29ycmVjdCB0aGUgYlVGU0ZlYXR1cmVzU3VwcG9ydCB0byBkRXh0ZW5kZWRV
RlNGZWF0dXJlc1N1cHBvcnQgaW4NCj4gdGhlIG5leHQgcmV2aXNpb24uDQpQbGVhc2UgYWRkIG15
IFJldmlld2VkLWJ5IHRhZyB0byB5b3VyIG5leHQgc3Bpbi4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+
IA0KPiBUaGFua3MsIEJhbw0K
