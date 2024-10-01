Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03B91BD009;
	Tue,  1 Oct 2024 07:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727767244; cv=fail; b=k0yA4kZ0VnYl/vbQrO9es5SvbdCXNZ6SfMUkRi2/R573f0L1QBp4HltCmqpSksQuaub6WyE8wJtF7aENaGS08xEeB1xfPMxvnXm/uyOcVNVZyVcdxy7zF8NBp0YV+e79KmWrn4pg/cw8SHVGUQP7ynUrUShewGhyMh//Vz1iG3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727767244; c=relaxed/simple;
	bh=A7L5oypaVqXAllXMAsNu1QdrEyOXbYYMTz0zMFHQnK8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jqlqsns4y4dgE0NPwJ/kXfQ748DLi7JmMHPomsDAbHblHojmELyjfO8d+3pvIuVpmYgQgg4zwSpBTXDu1rp6nUkiEnMqMowjYL2M1fkvD+Vif9r0YXQAS6MkxSC/f9rhu5IenN/gTvtjnrgl0EiRn9S3JUPpRDjv0eanp2Vyz7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=n4CJpUOR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pRU5tDqN; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="n4CJpUOR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pRU5tDqN"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1727767242; x=1759303242;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A7L5oypaVqXAllXMAsNu1QdrEyOXbYYMTz0zMFHQnK8=;
  b=n4CJpUOROsFk5wN2+mAsJhfeL1xKg3JCCbcwyaoNce3w/++fCFAqMnVl
   Gz1kPOnOs3SMlqIavnFhYnEtLJos9M4Tf33cKJ1zvByHV0Q9xbFKJ9bga
   +EUrso+nWhfzV9LTeCOUsTT4gs8c5kifEdDrDzAOINKHXVBnFrzfqBdyJ
   +Div9auBJvZjq6X30d+aMF9cxssE6TDqXsTATWvwml+8SlJRFf8uqN64d
   443dBf5POT97F+fyVnX21tUxoYCBHZV0UaN2RJqYHseslTjSynwhS9TdQ
   v+RBRgsQqBbZpgS/ivmgWMLF9umE4sELndX7CEcxiPQuBl0DC31E5ENEX
   A==;
X-CSE-ConnectionGUID: u0oa1yhAT86fIoDTAxpk0Q==
X-CSE-MsgGUID: MldArh8PQgy36dvjzBSkUA==
X-IronPort-AV: E=Sophos;i="6.11,167,1725292800"; 
   d="scan'208";a="28041159"
Received: from mail-northcentralusazlp17010002.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.2])
  by ob1.hgst.iphmx.com with ESMTP; 01 Oct 2024 15:19:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K4mzCcCZtWjOSe3whtDtp87tnQ+tyvkmcJp+wHRkDcf+cj8hMsd95jKwRtaR+3lQ4xryBdFhTdVluRLC3MqxSMpzzXfFvVIjL+fyaVAhdxumZhOXXkM8Xz1B+W2RKnGF9Ia4C1Suz+DlzSXA4f6M7DK0vlFL0+7q6uhXGJSZ1l6N3uWWdYqtizKz6fu03aJZbJWv26/BxbFlfGADcgmvz1MJPUVjz3fnhvmL0YB5bX7RUFRqXJpUigpx00W8OLkbK9BE+nkjTbweJyq0aHQRAlLZqcP3PKXZxftQ3DYypx5NSLe4eamSgTDVWwDMb9EPFZlkUtp89dBJ7MSCoXX2Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7L5oypaVqXAllXMAsNu1QdrEyOXbYYMTz0zMFHQnK8=;
 b=yoFEDuX6euQdZSlvUzulaChdqxptel7iGSkhQqJu1O14TYayOp2cgCCt5sE6FufZFrCLZdy6QfDwwkuV2YKBnQw+HV0B79Qx9H22oPN1yjGLQCdx4JVYIOCRiKOWH3Sq4erLMKykEHuo0jaeavQ3ezX8QCVqOMhCtlnAo6otFBVdKU7LvxGS5ZA1woSFvX3ozx4iaqbLH09Gq+RC8HV+K42PWxhMRyLkFOiCbb0LE1n03IuqayiVGvNM1L1mB8OiXlTmfztnwfNAMODZdpmq9Vdfi24+H3d3NQnBidSlIi9HP7goaodRT4CS0fDQ4CM92TI6mQRM9aQ+JQ4wsQHnvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7L5oypaVqXAllXMAsNu1QdrEyOXbYYMTz0zMFHQnK8=;
 b=pRU5tDqNG73Wj6Ms4tR2JGnxPfM4qKN52kNkXt71TIMvu9HJTxGitU1PtPRP2q4Xo/6v/NtlHZNvg+mVImGGU7NL4QtzjaaPYWYdZtyjsYGPAaeKru3579YFqqhEDvFA37sms50+Pk2YUvyp3JYM/tfreoUrGcC3+PW4CgumcNQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH3PR04MB8816.namprd04.prod.outlook.com (2603:10b6:610:17a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 07:19:29 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 07:19:29 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Avri Altman <Avri.Altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, Daejun Park <daejun7.park@samsung.com>
Subject: RE: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
Thread-Topic: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
Thread-Index: AQHbAzySHjbFr5s36kG7QyddcK5yL7JcVmaAgAWCLjCAD8U0MA==
Date: Tue, 1 Oct 2024 07:19:29 +0000
Message-ID:
 <DM6PR04MB6575B4ADD2F9E4A9DC80C81EFC772@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240910044543.3812642-1-avri.altman@wdc.com>
 <5c15b6c8-b47b-40fc-ba05-e71ef6681ad2@acm.org>
 <DM6PR04MB657594C85E06F458EEEDB7C0FC6D2@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To:
 <DM6PR04MB657594C85E06F458EEEDB7C0FC6D2@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH3PR04MB8816:EE_
x-ms-office365-filtering-correlation-id: 5f9be5de-518c-4ffa-8cae-08dce1e96366
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?V2tIYmFyQjNXT3dtK2lPVnpCaks3cUVBQTF4aWQ4UUFQQkdUUnREWjNiUTBj?=
 =?utf-8?B?SGNoZldNUEMvVFhOUG5XbDd0VlFkd0hSVlZnRWRYS3FoZ2JqR0NKNEVVbzhY?=
 =?utf-8?B?TDlLWFVPOUt1dHNBQ2xla3pFV1E2QklNL2lRZFVaR2xSdUFIZ2x4Wk5QNXhJ?=
 =?utf-8?B?RysxTHg1ZjFlaDJEOGs0YjFJcy9WdzVRWDBOSXUzM1UrOXVLcTZQUWNIdEZV?=
 =?utf-8?B?ZGhIN0xEZ0tTdGd5L1lFWGJNNmV1WFRheHJudEhMazIza3c3b3RWU25qZHZv?=
 =?utf-8?B?Z3lUc2M5Y3hyUTJGa0Y5NG5GSVI0d0tiL2Y3ckg1eHRzazhqc0RqOE4xd0hH?=
 =?utf-8?B?OGU5dStsRXREWCtITkUvZEpDdURYd0JhRll4OHQ4WHJGTnBaWjZvbWV4MWdQ?=
 =?utf-8?B?UGJlSWhoVzNaUFNZNE1MMzhYckhmV2dTcEQxMW56Vkp0RVBXNmxUQW10U2Fz?=
 =?utf-8?B?VlphTWt3WHZuRVlEMW1aVVNZUmZVMzdnbHZId21pZWladDEwTFYvTjVmR3RI?=
 =?utf-8?B?SERRRm1iclZJRUpRdllGaWZJV3hvV1ZKRkppOHcycGhXWXVvWTJZSC83b2Fl?=
 =?utf-8?B?aG5IUG5jYkNIK0hyTTVldTBnOWZnYjJKbWhScDl5ZTVkZWRNSzJmRVh2SXhF?=
 =?utf-8?B?VzFtS3p5TFB6empsdHk4YkU3eCtYN3BGY2doQ2tSRDRLbzVYaS9wUTRlTllw?=
 =?utf-8?B?VzM2TmlyTkpESjFTT1NDc296bFBEM0RPYUowQWc2MVdNbDV2bUFMWTlKRGg4?=
 =?utf-8?B?YnIzSkhXM3AzUHltRGk0MVZqZWo5WjZOd2VpQjFWVkpyQzhnMTZSL1JuemFT?=
 =?utf-8?B?bjVnMzNCaVBGclRUajdHcjZzYVZYaDlWY1VyQ0V3eUhxekhJRy9YUjk0K1U3?=
 =?utf-8?B?bC9UVkV4RHd4bEozMWM2MW9XTWpIcUs0b2taTXN6NHRiUGtla1htRW1PeHlu?=
 =?utf-8?B?WUI4U0NqSTlodUdUcXVsV0xWK3B6OENNaG9pZ3d5WldHS1VHN1ZYWkNCdjhX?=
 =?utf-8?B?NGR0TDF0aHdQV2h1ekFjNndNWE5Pa09HTFBkeGR2dDVJcitFRUxZUCtJa0FT?=
 =?utf-8?B?UmtqRUZXOWZHWjhNWGpVdGNvV05TeEVUM0hpSzJ6Z2xjUGVPdTI5a01BREVL?=
 =?utf-8?B?bXJ3ZlE4cElaMUMvSWgxVGRXdGU3RXE1NVphQ1Zubld0SCtmRnUvK1gwbDQ5?=
 =?utf-8?B?UlpXRGlXYUJMais2WjhablhRUUpUZGI5RkdIVkE2MVhZbEltTmNpV1F5cnBL?=
 =?utf-8?B?eDExZlZ1L09YL21vcmpvTmM0ZjFaUGtJcXNKdUdHc3pEcDQvOUZPQ0NjUVZi?=
 =?utf-8?B?blAvUmp3UVZwVkVsYUdWL1JMbzdnQm9rU0Y3eFBvWjVFREZXKy9nV2dmSlly?=
 =?utf-8?B?NS94bnN3V2NMSFhVdlE5WmFOaHZyQ0dMZk5ZT01YcytRWThGMHM1VDQzczZE?=
 =?utf-8?B?MnQwUGRKVEYraThJZEhGam9GQmlYb2Z3ZUYzeDIyMnljTVlqUm9SZDl6MXZW?=
 =?utf-8?B?Y1pxN00wNzlqRm1nbjExN0k0eGNXS1NRLzM2dG4zc0VZenhXbTFsMUtyK2tC?=
 =?utf-8?B?WTY5M2JGSGNXR0ZROGVVR2NWSlNxclFjV2pRbnlVaU5BTlB5MnByZ1lhcFpT?=
 =?utf-8?B?VnRXWEJEWHI4YUhhcjI2b2xHdkl4SnZmQW96dFBGU25jbWlNTzhKWVdJMFJM?=
 =?utf-8?B?SitsUWkvUXZacE1Gekk4TmFLSDRFdy9lUjQ1bHJQVnRnbHV0aE5ZV3MzOEZT?=
 =?utf-8?B?bmxYY01yQ0VtWFcvK3lPODlZZHIwOG83akdEcFhiWURlWVAzbmZpa1JVeUdy?=
 =?utf-8?B?L0lrWlhzczl4ZCtIRUxaSUJ2MnF3WHoyaUNSVGplMGM1MS9YUzJhelVrVVV1?=
 =?utf-8?B?dzJVRWtYL2d6VTY5TWt5ZEJVVExEOEJlb01UYXVmOGpRL3c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eSs1bnIrTGxiYjJhekZxY0N4M3hqVlg0VnA3eW5FUWJqK1NkcGhJTmNjbjdY?=
 =?utf-8?B?V2VMTW92VStYNzU0aG1aMmV5ckRyWTZFZkF2ZDNkRVczNUJSNGFaZS9kYnZR?=
 =?utf-8?B?TGJDZmVReTViWEtMWi9RYUc2cFB4WWxBdE9mQ1RQakk4a2hWUjRWeHZ3dEF6?=
 =?utf-8?B?Q3lqVzVXa3RYSVJsOVZUVGdyVnM0SjdpcDNwbFd3b3NKUEJaNGluVHNCd1pw?=
 =?utf-8?B?TlYySnpPK2w1SHloSVdFWE4zbEwyWHA4ZmxDU1RDTjhuWlZ5YmJPcDlnK3c3?=
 =?utf-8?B?ZDh4dkR1MXhSK3BxdEpCZWFiMVV3ZXRwZkZ2dUJsbC9wejRHb29XR2ZJRjFP?=
 =?utf-8?B?bUxNY2JVVG1pT0h0NzFHZmtaVnhuRDlaTTM4WEVsaVliS1JPNmdETnA3KzJ4?=
 =?utf-8?B?UVJ0clBVQ1k4b1pxeXEwdUxVMDBmYXRSVjFJWkJTWEJQYXlZMVFnTjZrVEs3?=
 =?utf-8?B?Z3lZNU1sQ2ZJcVlGRGxBWGRVZUovcmduajVHSGh1SXc1VDlUVHEwclA1QXln?=
 =?utf-8?B?amxaRXV5WjN1cDRCRHZta3o5K0FocWY5SzNIMFBwYlBwRmtkeXR2RUd1T3BK?=
 =?utf-8?B?czRjWGxGSGk2ZWhPMFBHSVhFbHl5WFhYZ3NXTjFBRDBBN0FLU1Y4RmczZisx?=
 =?utf-8?B?VCtoREJJMGNOQTZCejBpRnhlRGp5VFBLWEdaQ24xcTV1SjlNM093aVZ4SFE5?=
 =?utf-8?B?RVhRTC9vemd5WW1OVis0SkQxajlnVFlDcHg2RmNMekk2dEVJZnJkODU5cU1T?=
 =?utf-8?B?M1BMZ21OWWZDYllNVndYRlROc0ZSWnNISCtReVVVbGYyem0vK05rVStxYzkx?=
 =?utf-8?B?bW1kTnRkUzEwZ1BQTS9kK0Z4c0FVanpBNit6L3JjZ0pOR083M2NnMjJpOEFP?=
 =?utf-8?B?VFVPa0xsdkh1aC9hNCtSb0I5S0hNNm9OMDQ1NElwUW55aXdKMGpyRlZOT3lU?=
 =?utf-8?B?aTlLdm1WMFJROGVFdytUcmxpV1RXbTlWU1A4WVVTSFVVd3Zsc056Z0l0UVhR?=
 =?utf-8?B?SUFQaTY2Mm1lRW5iMjRWckZBQWdQdGhISVBtWml3Rmo2YXo4ZGdNc2t5MnBu?=
 =?utf-8?B?QWNkT3lDdzZDQ0lQbVB6WWl4L2lCb3liNnh3eXN4SjIxZWQ0U0VvSndpQnA2?=
 =?utf-8?B?a1ZBRFU4SDlPdlNUQTBFelAra0FqeFJPL0VZcDhqNjdEeUUzZVZwd1JKYTRq?=
 =?utf-8?B?cnNVbG8wNUFlRWZ6bVpqYlNXTUV2RTJpbFMxQ2krUTFJanNzREhRS05idW9v?=
 =?utf-8?B?REQySWVuMTBtWjdtZGJ6Mk9GREhwNHcvRWtRb2w5MERrWWJjNXZabktFa2k3?=
 =?utf-8?B?UU1DMzhNeFZ5Q0pPckZ2ZEgyTVUvK2w2MTgzTzhMSU1aNkdPUkRlME5JSVNG?=
 =?utf-8?B?VG42WnpWcDFaYmVkNDR0aUZ1MGcwTlNFN253TkVQWWxjbFFBc1Y4TVNyRVBt?=
 =?utf-8?B?ekhCSFQwUEQwQThlaVdSUnJVbE9iSlZEQWtraCtnVVdvTlJDVk9HZVU5TDdp?=
 =?utf-8?B?YXFkeXV2TlB5REVCdUlSbXpZZ1NBcXlEL3BpcWxHTGd1TnNJMHA1ek1ZazI1?=
 =?utf-8?B?aGdKMnlVZWF4dThRekdyVFMyTnhwUFNGYnNnUHRpamZtcnloRSt2WXA5L3VC?=
 =?utf-8?B?ZVN4Z21KRkNTc2IrcFk0TFVQT3FPZTVEN3VtbnpESGNtSnozYkQyVlJ3RkM1?=
 =?utf-8?B?YXJ3Q1RaRUlGMys1MU5Ba0VlcGVrOUU4OEgvTGQrWHhvd3UzQU1OemtjQzJa?=
 =?utf-8?B?K1o5Q0Fxd0tESzE0SEQ4UjltcDA1TnVsRjM2M01UTXI5MWFSWUVtZE9aZnBN?=
 =?utf-8?B?U3AwMEVxZGxjTGZTUVhvUEdjbldqZzVuc1hGdml4djFZS2hpbWYzNjdVUE92?=
 =?utf-8?B?Lzl4QUlXdTBhZXlwbkRsZFlGUXJ1ajdBdy9uSzhRZVZOc2Rmd0NCR1A2RUpo?=
 =?utf-8?B?WVZ5bG5ady9WcTQyYVhlVGVMaVNHSVRUUGJiWXRLYWtSVm5OcEl2VlNUaXNi?=
 =?utf-8?B?Q3AvUFIxV3FWcUxJTXRZaGwreHFkbFFRM2crMHFVUmNFNWR1YTh6SEVZWk9v?=
 =?utf-8?B?ckRSWnNwWFVrQzJpWGRuQUFEaWpMUWgxYXlIQWRRb1doWWRUZlhjeDMxeTRH?=
 =?utf-8?Q?2jCdxd2q+1KCAS4RN71q5ilsT?=
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
	Y0TTJoYqcl7/pcNN8asNbXT7knZmRvZBa2rcNo6x0pSWgAZS6b91yWoYu1jeM0pyM3k4m8x8RJhFfQRzmO3ZPnHuOZ94hKnXexYrBCQz3yR69BIzVHMjWP66V6wYdrxdcaeTpnTY8/+Pe4+Nwd7KFTxaVzHykAT2OPiKjOK0FHMPJstHYDe7b3iCV7fhYVgg1jgoA0H1ZO/Dc3yiRXpt4jBm3CCz+uddgUbBnc/bAmzjTF6WVYTuA8iCBASOQ7yEifd0iTtxE6jthCU9ThCw9zBfPPMuxGwUwYgJJs3v2kypFvWd2oWXJ9g0YuSgp3tfmuIznmX3iFwDV/xl3goI0vzbwe3M2Q8ny8U8hsecuK2u4SBzF+xqTnAnuOi1RWsr7N7PKIKZybasxuoiMi35hOrfOrLlC/h5aDS3fEAPMXf7+EwJQE7sHV2TXdEFLPlWammAdFMbwM9xboiIx2qxszllGaHTtRUP9bSvJ0WdiFbZhs+exoge50x+Bllt1djqDRmHqeb1lfmJo6IIh7A2XrDQAvc5yp1xDyAyQNBWK1zTw1zkteqMhps5NAEQvxsQRMx45lCzgK60chmz570eNzUZUQdRju1/woPMD0s9obRphhCmHWg4jpVp+E7HXycJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f9be5de-518c-4ffa-8cae-08dce1e96366
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2024 07:19:29.0706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iI5FEPWUDnArgC17HFwpfiAcbJ6A5FnWhUVI4uq84xXS3pvD+DhyPCmWlgu8kbEuXGHJtjV7xERMwzx211CJuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8816

PiArRGFlanVuDQo+IA0KPiBUaGFua3MsDQo+IEF2cmkNCkJhcnQgLSBIb3cgZG8geW91IHdhbnQg
dG8gcHJvY2VlZCB3aXRoIHRoaXMgZml4Pw0KDQpUaGFua3MsDQpBdnJpDQoNCj4gPiBPbiA5Lzkv
MjQgOTo0NSBQTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gPiBSZXBsYWNlIG1hbnVhbCBvZmZz
ZXQgY2FsY3VsYXRpb25zIGZvciByZXNwb25zZV91cGl1IGFuZCBwcmRfdGFibGUNCj4gPiA+IGlu
DQo+ID4gPiB1ZnNoY2RfaW5pdF9scmIoKSB3aXRoIHByZS1jYWxjdWxhdGVkIG9mZnNldHMgYWxy
ZWFkeSBzdG9yZWQgaW4gdGhlDQo+ID4gPiB1dHBfdHJhbnNmZXJfcmVxX2Rlc2Mgc3RydWN0dXJl
LiBUaGUgcHJlLWNhbGN1bGF0ZWQgb2Zmc2V0cyBhcmUgc2V0DQo+ID4gPiBkaWZmZXJlbnRseSBp
biB1ZnNoY2RfaG9zdF9tZW1vcnlfY29uZmlndXJlKCkgYmFzZWQgb24gdGhlDQo+ID4gPiBVRlNI
Q0RfUVVJUktfUFJEVF9CWVRFX0dSQU4gcXVpcmssIGVuc3VyaW5nIGNvcnJlY3QgYWxpZ25tZW50
IGFuZA0KPiA+ID4gYWNjZXNzLg0KPiA+ID4NCj4gPiA+IEZpeGVzOiAyNmY5NjhkN2RlODIgKCJz
Y3NpOiB1ZnM6IEludHJvZHVjZQ0KPiA+IFVGU0hDRF9RVUlSS19QUkRUX0JZVEVfR1JBTg0KPiA+
ID4gcXVpcmsiKQ0KPiA+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiA+ID4NCj4gPiA+
IC0tLQ0KPiA+ID4gQ2hhbmdlcyBpbiB2MjoNCj4gPiA+ICAgLSBhZGQgRml4ZXM6IGFuZCBDYzog
c3RhYmxlIHRhZ3MNCj4gPiA+ICAgLSBmaXgga2VybmVsIHRlc3Qgcm9ib3Qgd2FybmluZyBhYm91
dCB0eXBlIG1pc21hdGNoIGJ5IHVzaW5nDQo+ID4gPiBsZTE2X3RvX2NwdQ0KPiA+ID4gLS0tDQo+
ID4gPiAgIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCA1ICsrLS0tDQo+ID4gPiAgIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3Jl
L3Vmc2hjZC5jDQo+ID4gPiBpbmRleCA4ZWE1YTgyNTAzYTkuLjg1MjUxYzE3NmVmNyAxMDA2NDQN
Cj4gPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiA+ICsrKyBiL2RyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiA+IEBAIC0yOTE5LDkgKzI5MTksOCBAQCBzdGF0aWMg
dm9pZCB1ZnNoY2RfaW5pdF9scmIoc3RydWN0IHVmc19oYmENCj4gPiA+ICpoYmEsDQo+ID4gc3Ry
dWN0IHVmc2hjZF9scmIgKmxyYiwgaW50IGkpDQo+ID4gPiAgICAgICBzdHJ1Y3QgdXRwX3RyYW5z
ZmVyX3JlcV9kZXNjICp1dHJkbHAgPSBoYmEtPnV0cmRsX2Jhc2VfYWRkcjsNCj4gPiA+ICAgICAg
IGRtYV9hZGRyX3QgY21kX2Rlc2NfZWxlbWVudF9hZGRyID0gaGJhLT51Y2RsX2RtYV9hZGRyICsN
Cj4gPiA+ICAgICAgICAgICAgICAgaSAqIHVmc2hjZF9nZXRfdWNkX3NpemUoaGJhKTsNCj4gPiA+
IC0gICAgIHUxNiByZXNwb25zZV9vZmZzZXQgPSBvZmZzZXRvZihzdHJ1Y3QgdXRwX3RyYW5zZmVy
X2NtZF9kZXNjLA0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJl
c3BvbnNlX3VwaXUpOw0KPiA+ID4gLSAgICAgdTE2IHByZHRfb2Zmc2V0ID0gb2Zmc2V0b2Yoc3Ry
dWN0IHV0cF90cmFuc2Zlcl9jbWRfZGVzYywgcHJkX3RhYmxlKTsNCj4gPiA+ICsgICAgIHUxNiBy
ZXNwb25zZV9vZmZzZXQgPSBsZTE2X3RvX2NwdSh1dHJkbHBbaV0ucmVzcG9uc2VfdXBpdV9vZmZz
ZXQpOw0KPiA+ID4gKyAgICAgdTE2IHByZHRfb2Zmc2V0ID0gbGUxNl90b19jcHUodXRyZGxwW2ld
LnByZF90YWJsZV9vZmZzZXQpOw0KPiA+ID4NCj4gPiA+ICAgICAgIGxyYi0+dXRyX2Rlc2NyaXB0
b3JfcHRyID0gdXRyZGxwICsgaTsNCj4gPiA+ICAgICAgIGxyYi0+dXRyZF9kbWFfYWRkciA9IGhi
YS0+dXRyZGxfZG1hX2FkZHIgKw0KPiA+DQo+ID4gUGxlYXNlIGFsd2F5cyBDYyB0aGUgYXV0aG9y
IG9mIHRoZSBvcmlnaW5hbCBwYXRjaCB3aGVuIHBvc3RpbmcgYSBjYW5kaWRhdGUNCj4gZml4Lg0K
PiA+DQo+ID4gQWxpbSwgc2luY2UgdGhlIHVwc3RyZWFtIGtlcm5lbCBjb2RlIHNlZW1zIHRvIHdv
cmsgZmluZSB3aXRoIEV4eW5vcw0KPiA+IFVGUyBob3N0IGNvbnRyb2xsZXJzLCBpcyB0aGUgZGVz
Y3JpcHRpb24gb2YNCj4gPiBVRlNIQ0RfUVVJUktfUFJEVF9CWVRFX0dSQU4gcGVyaGFwcyB3cm9u
Zz8gSSdtIHJlZmVycmluZyB0byB0aGUNCj4gZm9sbG93aW5nIGRlc2NyaXB0aW9uOg0KPiA+DQo+
ID4gICAgICAgICAvKg0KPiA+ICAgICAgICAgICogVGhpcyBxdWlyayBuZWVkcyB0byBiZSBlbmFi
bGVkIGlmIHRoZSBob3N0IGNvbnRyb2xsZXIgcmVnYXJkcw0KPiA+ICAgICAgICAgICogcmVzb2x1
dGlvbiBvZiB0aGUgdmFsdWVzIG9mIFBSRFRPIGFuZCBQUkRUTCBpbiBVVFJEIGFzIGJ5dGUuDQo+
ID4gICAgICAgICAgKi8NCj4gPiAgICAgICAgIFVGU0hDRF9RVUlSS19QUkRUX0JZVEVfR1JBTiAg
ICAgICAgICAgICAgICAgICAgID0gMSA8PCA5LA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+DQo+ID4g
QmFydC4NCg==
