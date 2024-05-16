Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E6C14D440;
	Thu, 16 May 2024 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715872884; cv=fail; b=SpyHlL8sBWFKi83aTxgj4a6+KAP2jjMpOSo9ZzF/YBn4fNJgCDCpYXu8BtkKEMNo4aNxDwAlq0SQq3dcBbfpjcBuMX4J7U8RnbaFUvPHnFJPlvnkU5G0vciH7u18ED7Ri2Her1LmSv2uSnwGjNFzYU4D0vr9b/JlTAXu7H3hdAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715872884; c=relaxed/simple;
	bh=oXvxgw2oLZxmQtDyOc1flNc5TfTioyqgkSn/M5wDSRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CouK13CJtEFo4ZnqX1/zYE22Jq7RSlJFAo7AoElnPpjuYf9grzpYfgrFjOsP4UbtS3Zls+0xUvRKfiE7jtqm+TPdsUG3wQGXtjBqe3CcvyV+KqKaPKanG9X2wbaHpCjJqmSLB/v/3CMDd7IvtwqG4B0j0JLHMhoED9Y1BrMnw5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DagqSPWe; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jUKuYC2G; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DagqSPWe";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jUKuYC2G"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715872883; x=1747408883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oXvxgw2oLZxmQtDyOc1flNc5TfTioyqgkSn/M5wDSRg=;
  b=DagqSPWezB9kIDZFfS6rPhu4BMDAiXKxu29PVsJ3ssKusXHP4loa7282
   sgB3T0LoJZOdH3hSHI103Oq/CUeaOdTgbDagt2/4q7u7+LlSddf+26owN
   HiyjzxXwEoGH/cwY43dkFXzcxfS4ftFTJ+v7TKutj67tZXKAJLr9uVgiV
   XAygqeIt9O7qfuBREh+Z69eh4h+IQoT0UnUpH/GUhGQUeRtx1Bj4Py630
   +8l0mqzf/vNvmnXLPLL2hyXgLRApJqsfQ3R0ntBagccOHxwJ4ffSEfCE7
   Izn3/WjscSwi1rf8UmWRUaNOyP94WCRAmKpyeMHcijG73lTWIxF43gGYg
   A==;
X-CSE-ConnectionGUID: V1bnljMFRTGXlsWRFdf8FQ==
X-CSE-MsgGUID: FlerG2k9QxKlrx6uwQ9uPQ==
X-IronPort-AV: E=Sophos;i="6.08,164,1712592000"; 
   d="scan'208";a="16236254"
Received: from mail-dm6nam04lp2040.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.40])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2024 23:21:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGT10RQmfGh1Q0rOFE3XAhKxw9r7+ifLr7NucjwZxTu/0V+7FQddTcFBVpNMRNZL03qF/nlS4JhW3dofF3PApk39/syvJ986+/kh56kYWO0v47HlIothg7WE5YyETydDApLS6Zg3NSHx0a9I/6hTD8U2ZnvH+Ro8s8RDt+Tm/bvlL3PoVGTTtykNMeFl7Zp06slirKuLhZgwVZsJizODc1JvPBqMXNsmOdRVSdPbYsf4Zobrhb/k4QIS/2FK0s9u0N3RqU5PqWU+Fg88u0R7t/pmrUpC1BkjtshzU3XNCIaIHjm1jPWF7UrIaTc8OJ5cr4vwvPrkGaYNe5iyaigUZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXvxgw2oLZxmQtDyOc1flNc5TfTioyqgkSn/M5wDSRg=;
 b=KSXHzee/OZ+KcShZe1/vBo9VccQxGMzbV95eW3Y5F0iupK3AbDW4eFGLvQ0RYujHMf3uMnB0uHYaIkiivQH6KRMMPTAQ+7ATxfAxh8TmLrSPl8m+eyT5Rb6ISsK2VV+gRF+RekiDL5OASQqybhPT+6FbtKqZytjJ5L6shbATAPvaL6ftLXM3gioZ/2UekMT1wLzbWFbG1qUeTq5x71bYKsotUhA9/cx81d7tpbm0UQ3dVuX5oCRLtQel5fe+CgMe6R0BrWm4VlPmHqrUb8cBR5FgKqglXvtR8nup4AtQBtyvUTVpyOFYhdCd26qXg1getmUm58rXALwsTLLbnCpREQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXvxgw2oLZxmQtDyOc1flNc5TfTioyqgkSn/M5wDSRg=;
 b=jUKuYC2Gy/lfqbJ+PQWhyh8m1sLX7ph3xaKg21wppibaq3WC4RtLOkEXJrW3DWDE5pq1jyrfRmeKbwAGUxDoS3/FMhoUZoOk9Y3uBkUEIRNQn2MhFABJ0utenvCCcqLTn9AhyTz02QnWAnR5m6dBec2aIndHP9XVXgbRWeDmB50=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ2PR04MB8485.namprd04.prod.outlook.com (2603:10b6:a03:4fb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.27; Thu, 16 May 2024 15:21:09 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 15:21:09 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/3] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v4 1/3] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHap1UgAx6b0JByVEK7/ocLFKStXbGZ6+wAgAANl+A=
Date: Thu, 16 May 2024 15:21:09 +0000
Message-ID:
 <DM6PR04MB6575208AAB1E40C6EE91A815FCED2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240516055124.24490-1-avri.altman@wdc.com>
 <20240516055124.24490-2-avri.altman@wdc.com>
 <91e9322b-9304-4cb7-a1be-1f43208800e8@acm.org>
In-Reply-To: <91e9322b-9304-4cb7-a1be-1f43208800e8@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ2PR04MB8485:EE_
x-ms-office365-filtering-correlation-id: 7ade7d6f-21f6-4c70-190b-08dc75bbd08e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?a3RsMHh3QmpZcU1MTlBiQ1F3ODN2U3A3OWJhb3NVRU5KdTdmK3NFUWhUbEZs?=
 =?utf-8?B?UGMvLzl0T0RpeWhzMlpQOWgvVUlnRHNqS2t4SUN0M0RaZGpFUktaa0NmRHdG?=
 =?utf-8?B?SmpBUFR3WSs2dlp5NGVnOXQvZVdPNllOSFRHVTN3TFJrVEtqdmQycGd0aERs?=
 =?utf-8?B?S3NNekJ3QUdZU3VTc1VJWmxLQXRDdWxxOHNtck00QzM3K3Y2OFRnL2Jkc2Fz?=
 =?utf-8?B?S0U2Y3FJcGRZSyt2aC9NSUhHT3hiZ3V4cnhscFZDWm43ZjBMZldld2Q2ZnI2?=
 =?utf-8?B?MXVEWW4xTDdrS0VxRm8wMzdPYnZuZENFWlRmQUtJQTJNRDZDVW1mU241VlB1?=
 =?utf-8?B?aWIrcHhlMjBMMDBMSklucEs2aENUU21sRFN1TmhsZ2E4S2ZXQjdtTTRMS0Fu?=
 =?utf-8?B?U1NvTUZ5MWxnaUl5NHlFZXM5MWxzRHVTaHlRM1YwOEZmUkx2eURKMDFEdzR2?=
 =?utf-8?B?aFdaZjBad2Y0Q0hvdG1rSGU5clREMHUvR00wTDVLWEhidWNmMmROSVlKMXh3?=
 =?utf-8?B?M1h5K09pRGFwZU9IZWdTODI2aEVBL1NpT0xRVGdobTFXNDlNNFBzbDd1TU1Z?=
 =?utf-8?B?bSsxRTNwQVFNVCsvN0p6RmJhSklZN3NYWCs3Zk5BczZoYkQ3R2k1QXpkZVBP?=
 =?utf-8?B?MlVuNStWaWZ0aXlqa2NWT0Fyem1wMTNoanUrTG9kT1hNdlJ1NHFCWjlJOXdL?=
 =?utf-8?B?eUlvOFAxN0I0MStSTGxCc29MTDBjSDJ0NGd3N0lpUG80YkF5V2tQSXZXbERT?=
 =?utf-8?B?UEh2QzA2TkNKNXF5dFVGRHFOVFNTWUdJQmd6REY3cEFPaVpESDVMWENneEZv?=
 =?utf-8?B?dmd2Mmw3N1NIS25uVW5TaGZhNW96WnpDcUpjUE00b3NaaGFjWW9UbzAzeFM0?=
 =?utf-8?B?L01VN2I2K0syNTlwOE5uR0RoVzQ2dHFMMXBySUpBT2xYM2JlaTlhVGYxK0ln?=
 =?utf-8?B?K0lBcHlqZUxrL25uWUFOODNJODlWancySWJNMjRCWHNhanZKSUVJenY4Y1pH?=
 =?utf-8?B?L1N1dGFSd1VaSFYvL0xVWCtVU1UvSDZ4ZlFiR3hBclBjdVF5WXlLb25xV3pU?=
 =?utf-8?B?NTdPaTJPKzhKMFlPS0VLRGhwT0hqb0FlTlJVWkdDQUE3d1ZuYms3TVExUlpH?=
 =?utf-8?B?clR4ZDFnc1MxWUNMZ0tZbzgvQ0lPTmJEVjlETmRWTWo1QXpqdkFmOHFlMGlQ?=
 =?utf-8?B?d0s5MHRQTmxxc21RVHBmdlBIRUhEQ2Ntd2pPbFlkTkd3ZUlLdkxYRjZnd3Na?=
 =?utf-8?B?Qnd6aFh1YjB2ZXh1RDVoZTNVYkhZZ1RmeFJuTURaSWdFTVhzT3pSYUIxbTlt?=
 =?utf-8?B?OVd3KzNpVmNUdjBaSWhId1MzS0d4TnRiT2V5U0VNZC9mbGgwczA1SjNib3pI?=
 =?utf-8?B?MFZwVXlkLzNod2I0RlJtVGoyU2xrNWozMWV3U25XM0xtVU4wWnVSbUZqbFJ6?=
 =?utf-8?B?MWR6MnlBb1RlQ2ZseEtqZjY3YXAxZy9VZThOLzh6WlBFejZ5YkQ0V3I2WGJx?=
 =?utf-8?B?bThkaXg0cTVKMWV2eUJZWnRNczR3aWpoS0hDRjNTUW9veWVodFJMcmpteTJ5?=
 =?utf-8?B?ODFQaWNKNDVIbThPaUJ0QmJEVEV1bDl4VWJ0VlU4UXpOVDZjcFpnSk8rRVVh?=
 =?utf-8?B?ZEsxWUVhLzgxeUs0UjVKUG1wWWxFZUZzQTMrdzNuNURQaXV0YS9FbE54bzBm?=
 =?utf-8?B?cytybzdaeCtTZURVOS9FUHR2ZklHK1pxckpXTHdWSjcwa1pvUm9SZ0ZFS0xm?=
 =?utf-8?B?SHBhYkF0NXlIT2hPcTZJalFvQ0pnTlhlRDZOdFRubG80dEV3QytyZTk3NVVB?=
 =?utf-8?B?cFV0OWIzVXQzdjVueVFmUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K21iVnRFSEg0NFUyZTIyRUFLODFETEp6NTRWaUcvWVo4TEVQNEx0TUN4dEMr?=
 =?utf-8?B?S3d0YkxqcTNnRWlPZmIyMkVQQVk3am9OcG5oM0haL0dYVUVaTVdESlBjT0tj?=
 =?utf-8?B?TjNlN2V3YUtiV0R4dXJWb3VjSUhvb1VrRG9JVGtVQ1hsbDlVRjBod2lkZXEy?=
 =?utf-8?B?ZmdCN1VrVDNHTG5HWTFLSitad2hMaWdzc3p5Z3Qwa004b1BlSnM4TnI2ZTNC?=
 =?utf-8?B?am4yak9mcFRZZFh4U3ZZM1cvN20wMUVrUjZ3bEtoOXNjMUY2WWh5Z3E4M3hN?=
 =?utf-8?B?dGRGYi8yZzJzSWJkbXR0Nis3cExtNU5ybUxIa2RlWnVwdksvNzF4b2V0ZFM5?=
 =?utf-8?B?clRXc2kzQWJRam9nMFo2UmVobWJmZ0VBSUxWQnhFSHJsRXNyMWo0bjlGcEJU?=
 =?utf-8?B?QnZzNjBDc2RxZThLNlB5SmpBd2tJQUR3YUs3SlhmV0ZzbVFUMDVGbEN4NzFt?=
 =?utf-8?B?NXhMN0ZQeHNndDYzYkxFRDZkRnIxUk1HdVliK2FINlI4L3IvWmZ3YW15VE14?=
 =?utf-8?B?akc4MkwvMmFpcHpseWJwbzU5eWdmZW5TZnJZM2RVZUZVSzFIdWVFVS85NExp?=
 =?utf-8?B?MWdkZWMybWUwYjVsd1pwWGgrRVBuTHNHZk9JME1GcFU4SWs2ejkvM1U2YUtt?=
 =?utf-8?B?YmJhcnNOb1pDZXc4ZFR0emM2UVNhZUpxS3ZiVUJjaDl5OU1INzZzaXJvSWp0?=
 =?utf-8?B?NlNQb1VqY1IwVFNYQlJLOGxOclkwejhTV2pVbEYxdXgyZmtKZzNkbndhUGdE?=
 =?utf-8?B?d3lubkFNZXlWZDhrNi9NVEJzU1RJV3BrZnJyOHVOQVRsU3B6ek0wZG1Bbndr?=
 =?utf-8?B?N0pyazRiemtOZm5QYUoxMTQxbVByQThGN2VOOHR2MzZ1SytoK21yVUZ5Wk9S?=
 =?utf-8?B?dy9GbUdKVHJpSlRyL0EvTzlna3pIdzFoUHJhelFpVlZxOUllNis1RVdLZDlw?=
 =?utf-8?B?a2YvU3duN1JMWitlMHRva2YxUWl1cW1NZHkxcEt2dnhndkFQc1ZWZC9PelBs?=
 =?utf-8?B?RjZzUGVxUFRQS2YrUDVyMU9ZTnN5NHFwNzNPYU5KMHJLUmhaTzlGZkh1Y21O?=
 =?utf-8?B?SUsyWmFtWlVCcWR5YzFiM3l5NXJZQndzdnN5MDJjcEtvQjE5a3Q0NExoQUoy?=
 =?utf-8?B?T2xkZk5kc201UzRmaHlFaCtTWVdWeiswVGxwL0lPNUtYSG9UWDVlNDZ4L0xz?=
 =?utf-8?B?TlpudnZ0OU0rUFhSWmIrcmVNWVlwc2NRTWVva1kwSEVNUDNmbjlkQnVxbUgx?=
 =?utf-8?B?Tjd3L1lSS3F6dmYvU0NYTFp3Q0lOTnd0RFZJclZSTm9oM0xyVnJTT3M3Zkl4?=
 =?utf-8?B?M1NPU2VIWTV0eHZRSXluSWxpUmZNRW9XMXhjK1hDWWE0Nzc2cEt0MnBNK3Ro?=
 =?utf-8?B?UkQ4K2JuRmFyVE1iUVVWVE1pMndqdm1hSmpsaVJwcXBsNmdXMG1hNEJQcnRG?=
 =?utf-8?B?MVVDc3ZWNVNGbnlHNWNIaDdtemtnWTV3UEE0elM0NGVzVzlRWXBCb3dOazJR?=
 =?utf-8?B?UFlkNGQyRlhlK2FJcmQxWlUwM0NmdTcwejVPc0s0SGxSQXdMbDRHS2RDUWw2?=
 =?utf-8?B?ZkhsRWRmTERUZnVNejBhT1owdy8yU1dRRmFrTnhyNFJlRmgydkNFU1hJSlZw?=
 =?utf-8?B?ajh4N3RFamJjV0U2cGpaUmdaZGFLMTFCdDJYQUpSR0xyM0xlMlBSeWNEQklI?=
 =?utf-8?B?SCtldGJMUkV4ZEJYSTlTbWFsYUtPZThwLzNUZFpTeGJKNVJlT0ZCZW9zWXFa?=
 =?utf-8?B?cE5LN2V1SjZEK2p1N0tMb0JPc2tlbDJ3bzJ4eTMxSWVKMVFrS0xqU3RxWlRM?=
 =?utf-8?B?K3lKemJGdmhBcFdsaFNreFRPNnZydlpPWStCZEU3ZjdaS0s4T1FNUnlpYkRY?=
 =?utf-8?B?WWc3RnVveXl1ZlErWlpxYysvL2tiUVJQKzhseko2THhKV1BaRUZBVlVXdnBu?=
 =?utf-8?B?VnpOb3VRYjJObytIaXdxVEREWTh2MHhtVUxwRGdpYnJ6Ni9uS0Z0cFd0L1Z5?=
 =?utf-8?B?OE8waXhDb2JxU2hQZWpwUGs2NEx3YXUyejRIZk5od1l0elE3MklobTNwV1Nu?=
 =?utf-8?B?WmtpRkd4WFRKN3NDa2dwUnYrOHBhOXJCK29uekk2anliWmFBaTZKUThpS0dT?=
 =?utf-8?Q?drIo=3D?=
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
	Y0bPxvcw1EJMztxbv2rZKQvv1n8p/yVaZjPpKwOB+0mgQ9jckbIMnLTOyk/zFFrYGZBgr5wftsArCIqft7eADO8FnhgJtvppvBHq/M33sSHjFeUlzi4lqYY/rKqKqgnR4cBX1rogKDBz1Vsyv/Nhx1MwmXdNWBViAB3CFKqAlLTOL8sc6f6F4T1Q4RHCUxtV+aWk8P3fdvXHH/RICopqQK9LHiIS0MYhJ5xGWEhi1xHyTvT4RDYOTDRLj4BJPqQnGnxUOYW3a4BabXEtmfukdMTOMENrdy/alMwFwY/oTO3crMXyFm7+wluzYFzn7PV85ttqvVs+QKmgIv+pjZ3sz8R53y234U1cmKnpAGM/TkKVmD2K3zeJ99H+UirRO103KypbSfuveEHnsImA/HxfX+Td0IyM48y22RYh5guDbanWRhwnjnSWMkKfNU/zGXDzEhLj6DADMg635fDn59Ohafdm84uNVUQnc8KtlC3ahhGL4KLaioKJst/JexN5EF2l+1DbyIPU/Rtm8pIQgENSfCh9qKpG+GXveZb2LinBpwLzK7Zq+fS4mipoDm/v9wjGuZBJ2ohmP7aUkiTS1UGtIpG6PH87r/IE6Hi5PhsP5zRkfKJGSo1amOxHQRyecirs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ade7d6f-21f6-4c70-190b-08dc75bbd08e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 15:21:09.7976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1LXMUKzsiU/ulIPeCkn5oz9CeqM4QXMvfRMgfVGAKIu2QuQsK/rZqzbZlkvbfiq2eUoZHPy3vvTTQJVT3U7lAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8485

PiBPbiA1LzE1LzI0IDIzOjUxLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiAgIHZvaWQgdWZzaGNk
X2ZpeHVwX2Rldl9xdWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgdWZzX2Rldl9xdWlyayAqZml4dXBzKQ0KPiA+ICAg
ew0KPiA+IEBAIC04Mjc4LDYgKzgzMTIsOCBAQCBzdGF0aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rl
c2Moc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiAgICAgICBpZiAoaGJhLT5leHRfaWlkX3N1cCkN
Cj4gPiAgICAgICAgICAgICAgIHVmc2hjZF9leHRfaWlkX3Byb2JlKGhiYSwgZGVzY19idWYpOw0K
PiA+DQo+ID4gKyAgICAgdWZzaGNkX3J0dF9zZXQoaGJhLCBkZXNjX2J1Zik7DQo+ID4gKw0KPiAN
Cj4gV2h5IGRvZXMgdGhpcyBjYWxsIG9jY3VyIGluIHVmc19nZXRfZGV2aWNlX2Rlc2MoKT8gdWZz
aGNkX3J0dF9zZXQoKSBzZXRzDQo+IGEgZGV2aWNlIHBhcmFtZXRlci4gU2hvdWxkbid0IHRoaXMg
Y2FsbCBiZSBtb3ZlZCBvbmUgbGV2ZWwgdXAgaW50bw0KPiB1ZnNoY2RfZGV2aWNlX3BhcmFtc19p
bml0KCk/DQpCZWNhdXNlIG90aGVyd2lzZSBiRGV2aWNlUlRUQ2FwIGlzIG5vdCBhdmFpbGFibGUu
DQpQbGVhc2Ugbm90ZSBzZXZlcmFsIGRldmljZSBjb25maWd1cmF0aW9uIGNhbGxzIGluICB1ZnNf
Z2V0X2RldmljZV9kZXNjIC0gYWxsIHJlcXVpcmVzIHNvbWUgZGV2aWNlIGRlc2NyaXB0b3IgZmll
bGRzLg0KDQpUaGFua3MsDQpBdnJpDQo+IA0KPiBPdGhlcndpc2UgdGhpcyBwYXRjaCBsb29rcyBn
b29kIHRvIG1lLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
