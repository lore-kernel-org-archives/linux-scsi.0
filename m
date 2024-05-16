Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152BC14D430;
	Thu, 16 May 2024 15:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715873016; cv=fail; b=OGROQ4rF8UXTPAbI11cstjxyJARVZvJAa0nP6OT+Z89+aBzeXttc8wlEI3Dq9s3zfkOhwZ22TYaS6nNjgAYYyorVaTXUDGOEX6WIPJ8tSneUy+kTbunp3CkDK1boghtHRNGnpdSfsqByYWxfCiHzNrO9kCfTNrRfMuBYwR+jGkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715873016; c=relaxed/simple;
	bh=Wg9OpR54K3t6hLweZtcvGoQcTnoQ+kX7QYZS8GtX43E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EY1B+1W0SG3WpkzSX6d9jGjlAsGDdthC+tbu9YnDfsKNSwf/fnArkJSnwyZNYBhqEbxfSMDgrwy+TIIV08Ayr9yPhXR7vdSRQ0f3NyNhChg9FgRuR4RXCEFTqXR+se17hqd4yThDFfxp4kQickYgYhlx3ZZEM+rjO28l7U5MsaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UHP292z1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=he6EMlw0; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UHP292z1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="he6EMlw0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715873013; x=1747409013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wg9OpR54K3t6hLweZtcvGoQcTnoQ+kX7QYZS8GtX43E=;
  b=UHP292z1RnrFxdt/CjhizCPyTIJQZUwVM/x88vRUlkipxi0Dk1idNZgx
   MXHHN72z5TlKiYv/68do6f+SjpVJqITFUpX2ujsXCZNwW4q7b7mBbxdvL
   rmytvXuRuwJ7xQtzHlYWnJzJLzXXL9kSsWAMNGBsW1hnT9t/6uQ+qivMB
   I7TuEC+HjV/kKzh4iv0C4lD2AeLiC22t4195GFn5bChR/iO8E0mWQ4eob
   Rv3z22rl8F8TKx0rQJrsF9uIgtdDe9tHIA6EKPsaDAj6CfM8w15hhEaMc
   sgmLU4TdCV8V0iePAryT/D+AU+rfi3UFBOkLJtYfC7TjMI1Kumgwp7kh+
   w==;
X-CSE-ConnectionGUID: 0yeng4SQS4OGTuIA0xnKDg==
X-CSE-MsgGUID: ZiCjMCkRReePcje32vPglw==
X-IronPort-AV: E=Sophos;i="6.08,164,1712592000"; 
   d="scan'208";a="16552948"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2024 23:23:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQxZiL1zNJVNbGaHJBc3bk2baAw6tvqk8Ls8dy6lq+0yxSQyFcNu4uGB5bx1xPthvGRRFRKvDjeUMCfOklE5+LSqo9RZ2GGwwbtEgSFePi2m197Jp0DEex3zhQKRXVt+BNeb9FE92zYo6fwFmJ4Dmv+0c1fmDrkMFrHVIALXCUBdlwoxPRWW5nvevthKiXM3n1wUAq9A9oNu1iSPL/F02fX6TV3JsOHSKK5SeBxSf5/+mLcAThLL4PmJTOO+AiwDKzzYyNdjQoracXWBIGwBOEzqTX0CElOS4tTbymXxEh7XyZcUVZIw/TJPHF+uGhobtXVbbPnFLN6HXrGHuPmHYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wg9OpR54K3t6hLweZtcvGoQcTnoQ+kX7QYZS8GtX43E=;
 b=g9y62hjiIkF1YmsZrHAJcpUbMcnuXbY4vrGkLZ1UdXzClo7ttwYrXpDLpUgcNKjlSYvupUzulS4k7LlMYZr3YGaeAOkWGw/eJXK/VUQkYwF5f0L5nF7T+3x47BY+UuNgR0rD2UhUtHQVm2Qf3qd40HuwOQ4afYy4VqVyUFd4yTLxZI28m9BfBOM/LPyw090DvkWG8rf0yifZl3JoqH5VGBgDvfpbWOCg7TczzjfEvdfJSghdwPnlU+ymIVpnYL2RgQA9OPQFZIXB0ctsUTpZM8+DNAboKjNJSoXHebHihkuFqEZFP98Jme/yh8HdKSfLxS8F0GZWCTcluaL/TwYOQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wg9OpR54K3t6hLweZtcvGoQcTnoQ+kX7QYZS8GtX43E=;
 b=he6EMlw0iDb7DC8AoyAZcw2YNpf1f0inYXP4wjpyzMUCZMiFrg9Z9nW+gYexdttW9LLCMCyr+IOw7g8gYqphVLMNn3s9MkpDoNYsl7haW0D4BD5d+2t42tLgmpft97YnTuX0esP1/+9USmUNR/JMpqjJVirP9I+vRuu2W+9JVZc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB7024.namprd04.prod.outlook.com (2603:10b6:208:19e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 15:23:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 15:23:19 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 2/3] scsi: ufs: Allow platform vendors to set rtt
Thread-Topic: [PATCH v4 2/3] scsi: ufs: Allow platform vendors to set rtt
Thread-Index: AQHap1UkH6QgHrMQzEy6mLv1EN9b5LGZ542AgAATnrA=
Date: Thu, 16 May 2024 15:23:19 +0000
Message-ID:
 <DM6PR04MB6575D86BBC8329CEE5113C71FCED2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240516055124.24490-1-avri.altman@wdc.com>
 <20240516055124.24490-3-avri.altman@wdc.com>
 <e6a5c633-7de5-44bf-af1a-ead577d079e6@acm.org>
In-Reply-To: <e6a5c633-7de5-44bf-af1a-ead577d079e6@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB7024:EE_
x-ms-office365-filtering-correlation-id: a3051c1a-d955-4890-cb78-08dc75bc1de4
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?VXlHSkg0MVBlT2szTHdwbDJkS2hZWFlmaGlKQkN4eHlrZDgzdS9RK0FjRVNq?=
 =?utf-8?B?TFdHZ3ZqQUwrNGd1NnA1MGc0UXBDVGdjV2dwRnBkdkVzb1dtaEhzSkV5TlJt?=
 =?utf-8?B?akFLY25RbVB6OXVXNFU5WkkvdUpzRXBlOTlvT3NuT1hOaERMUC9veHQrU3hO?=
 =?utf-8?B?QVYyeXZucE1YWXhIYmJ6L25PUGxjTTg3dlBCWUZCemhNeHlxZXI5WDF0L3NQ?=
 =?utf-8?B?ekNyZTh2MCtGeFUwaDFXT3c0RGRNYWdLQkVsVXR4ME5zQlMxUERhY2kyZUIr?=
 =?utf-8?B?VWp3YmhxVU43K0pDU2x0RFhUYzFoemdmSy9BSGZJbVdYUG1Ca25sUWtaTWdv?=
 =?utf-8?B?MW14ZndKNUMveDhXcUZLb2dWcWdrNEhJKy9tY1BVdVAzcDNkZlVTTytLR2pM?=
 =?utf-8?B?dTM4aS80djRIMHdMWGZ0R1VNWWtoKzlTRVNhWDRuNzBidG9Ra1J5S25IRm51?=
 =?utf-8?B?azkxMVJvUW1JczVBM0ZQb2hhTWpsZ2VxbkF4Q2swTERYUXhrRC9NWFZqU1Fw?=
 =?utf-8?B?VlEwbEEwYjBQRDlLRDBPd0VIQ0tkMHV6WUxzSjhwcUp2b1ZNbFhsR3o3aWdD?=
 =?utf-8?B?bk1ZbXgzWEFCeU5yVlBRUjBjMU9TbHhwWU5QMGV2LzBzaW9SSlBpSmtlTVlp?=
 =?utf-8?B?QTNHQWNCb0JwYUtva2R0MDJZeFJNRmxEWWVrZFJwc2ZhM0E0MU5sd256WHpz?=
 =?utf-8?B?QUxCNTRwYWQ0c3BqNjRpdWlEOTk4YktZcW4wcjhING93d3ZLSnZkZmlvTWF5?=
 =?utf-8?B?YjhlNWRtOEVjZW1iYkc4NVRoanVVM2xlWHBvV2thOXpvUUZOU0dSSTBBZ1hQ?=
 =?utf-8?B?SEtjeUVSTmZTZ1FYbkdlWXVUUkczM2l0VURNYzV1aTBaWDc1dVRWM2RoUUMv?=
 =?utf-8?B?M3JFdWFJeTdBcXd3RUxZempLbTJBT0xsWFlvc3JBVkFmRk11VjR3WEUwS2o2?=
 =?utf-8?B?TE9OTmRLUW1GenBIVEwwcjFsbkgrTUZucmJweWdxMVg3VmwrN1Q3TFlmb0hx?=
 =?utf-8?B?QVVOTFpKelBmTWdtWUc0S00rMFZJdlJ5b2lTdGNlbytXc1JBQXo0NWxnZE01?=
 =?utf-8?B?Zm1hTDdDSGhFbU1SNnFvRFZoZFB6RTEzb1hxL05iT0RKdlJScHhGMzZyenNz?=
 =?utf-8?B?dXFMaGtINjR5WHk1VVFzWjdwMXpLanBWOFJHS01UVlF4U1lMM1pVWmVCeHdW?=
 =?utf-8?B?S01sOVJoYXIzcG55Zk1tekpsbDUwN3JQRFdqQnQzQ1E5M3dUUUs0YW1ES1Ni?=
 =?utf-8?B?bmM3WVJWRzVsdE1pb3pLMkkxekJhRVVSekZRZURGQjRFYUdlQzNSbFluTktW?=
 =?utf-8?B?K080WXlGWHZuWkJVTVRnbEFPYlRlYmRtKytvcTVHTjhpblZnNVNETnh3WWhS?=
 =?utf-8?B?dVZYZTR4UU44aGI0M3l5MitRY01rdDdpbGEwSXVvVlcvYXYyNWZMZWx2eGlq?=
 =?utf-8?B?QkRUWE9QVFJUNVhCaDFXVXRCMFo1Y2ZYQi9mSUZXcjcwTHJRbVJzNmxXSnhV?=
 =?utf-8?B?VUxBQUVFZG1oZVFWVnlnWlVyaDhlRnBsaHFJUGlmS3NEQ3lzMDMxSjJGNkpr?=
 =?utf-8?B?Nkc0OTRkZmgxSE1mUjRjN3IzVWZiTDZTNFNIVEJadTM0cFc5eVA5dFZmdjVL?=
 =?utf-8?B?VHllUzVvNWp1RS9jOUNWUnFHSkZqc2RVRWUzT3Y5U1U1d2ZMVE5FaFBiUGp3?=
 =?utf-8?B?MHNGeTNjM0wwUUxxMjlBblVDYTV0Z2J1MUJKM1F6K0dZOFVnbTM2RlRhaVRB?=
 =?utf-8?B?TTF4UVN3RS91elp5enhlYmgvQW9qNm9kWjUwODZ4QUlWbngvc1JkVW8rSmlu?=
 =?utf-8?B?RVgwZ0Jhd0VSWENNTkdZZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MDVJSW1oU2hEREdtRHhZcncycTVheStVTkwwY2g4NVdYc2RCWXBrMk1ES0RW?=
 =?utf-8?B?L3lxUytqNG10K3RqUnJZNmlGeHRkZlhoOUFqM1dEdXpIQ254aTk3WXhsZ0Uv?=
 =?utf-8?B?OWFSN2xZVWRUQkczVHk4TlUwcXV5bDBLRTgyVElLckZjY0VnUDdnQjUxa3pv?=
 =?utf-8?B?eURjRUw5VDd2WlZRSFNBa2hPbERrT3NIR243VnVsY2dBK3U1dldxZkppQzUz?=
 =?utf-8?B?VlBVTlJXQlNTRXVFWGN2OUdTcmJXc2RnNDFTUE13bGEwYjU0MW0rZ3l2SXZ5?=
 =?utf-8?B?WUI1WlRiMTdpKzlXaWRqaGErc1dzeWJneHpySHVWOUdZNjIyTHpySTJmZ3VV?=
 =?utf-8?B?NG5nV1VOZzRoUDQvcVFrcWNHZS9LRllBWkVxRlk1TmlVTDVmL0g3L1RxTnFj?=
 =?utf-8?B?Ui9LU084RnVWV3Vna001Qmxjc05FWEpWNmdveGxMNE42QTViZGxiN1g2dE5P?=
 =?utf-8?B?SjZqME5xNTRxQXJORUdpbXMvdTRHMG1HM1V1cnYzdk9ZVTRVM1d4bWRzd2ti?=
 =?utf-8?B?NVRlU2VYMEdLYUZCZWNFUUltZ3FUOFRKeU5FWDEwRUIvQ2dQVGdRdWFwTWNs?=
 =?utf-8?B?ejZnUmp6NXNOWS8zbHlzV0ovdjF2K2QzUno4bUkrTzl1T1A4UnJ1aGxaa2gr?=
 =?utf-8?B?M2dsVUxXUytRZ2dwVlZ2ZXltZEhZVDJ2eGpIR3RJdERDS29vZlAyYVFVNUZD?=
 =?utf-8?B?QkY5RGUrNzhwODJKbmpjTGpaSEE1L1E3TVdPbmFtdEpBUnVLRlhGVXhTdnVs?=
 =?utf-8?B?dDhmUVh2Y1VkdCt2L2pOeC8yRjM1MVJjUGNvQkVvUmpnM0M3MkdYUTE2SVVk?=
 =?utf-8?B?RWxTOUhHeW40Q3pMQUdhYVg3S0R6VUZUNndoc2dBSU9zdjN2VG5DWnI0L2ZC?=
 =?utf-8?B?T1h0NWZDTlljVEJ6VjhFRkV2UjF3dzhKdzFHV2hDRHFXZHBNLzBmWFJyZC9q?=
 =?utf-8?B?czgxWkRNNTk1akNTZWtPTUl3SnBkajkxanZiUUg3VEtnNmFoOUt4cnloZ0NT?=
 =?utf-8?B?Ti84ajVXN3A4UGx2L2NncUQvQkU1eHVualZWZWtSTFFkM0dRa2RDNjBXaXh1?=
 =?utf-8?B?VnVXNWxsU2V6YS9qNDN6YWV6MGhJS0hUR3FqN1FUUE9ia2RCdEI0VkZGNmYz?=
 =?utf-8?B?ZE82NjdjY2E0L05IK3hDSERuWWZic210SWphdUwzWFZ1TWZTenh3d2gzcDZq?=
 =?utf-8?B?Y0NRdHJONWJVTnd0ZkZIbmJuclJGZ2Z6WWhYM1ZXcm9saUF0N2RiVVVNWjY2?=
 =?utf-8?B?WTU2NENOSVJ5REpWUGZSb2JHWnBZMHoxUWNhVlVOdjVPSUo3L0tDUHBFdW9v?=
 =?utf-8?B?UU1FdFlZN200ZUx1T2trc2tJQmxLSndVZGhXdFUveUpvdlY5WjZSS3FpZVpa?=
 =?utf-8?B?YXhiMXo5eis5TFZLMERQT0k0Qml4bmZQS1lzYkVzUlVrd3RzY1MvRmUvMzBh?=
 =?utf-8?B?UzJOeFlwU25xeFR4V0lUWEQxMFBNTzhhanRQU3hSMWhRaTgrSWlRa2RvdTZa?=
 =?utf-8?B?ODZiY0FEK3g1NHRCTVpCejY5alBjaHNPRkJMUm0xUVZva1hzWHNvZkR3K2ZU?=
 =?utf-8?B?TmhrYmVtQWo5aUtlMGdGc0d1L1pFWkhrNlpQcUE4eUMyUk9sWlJoWlRTa3Bh?=
 =?utf-8?B?RW4va2Iya0szeXJpSk90K0VIVlpuOVhmSytmTnJCUHZuZ1dPWUVGcUZ4akFG?=
 =?utf-8?B?aEVHakJSbXVINldNb2doc2RCeG0yYjBqYW1sQUhUVG5rUGhSYlpvN3pxYVdo?=
 =?utf-8?B?aTZJMUdCcmNQM1BLd2RBUVQ3dUhaUkgzUVZtMkltKys0WmJIWjIzYjRhUDZa?=
 =?utf-8?B?TG4raExWMkdEYXNocm8zcUlhZ1pMaXkrQnptS0o2TjQzNWdacTcxNEpISDhY?=
 =?utf-8?B?UnNXOElnaWQzT2JhNmErOFFPV29NNmhsVk1aVWx0YXR1dnQ1MTVkZm9YaW1x?=
 =?utf-8?B?Q2pBRjRsUS91OGdaOHY3YlJUS0ZWWDQwSWhxWEdpTUNjK211a3FqUCtqV2xk?=
 =?utf-8?B?SjFTOUpoZDBvVzVjQXljZUZVV3cvQU9LWkRtcWZoYkhhYnI0M1ZrT214d0ZW?=
 =?utf-8?B?c1MyVnQ3YlFLVEUyY20xaTREZ2JuU3NLckVqVWlRWHBjVmpFQytvT0l3eTBZ?=
 =?utf-8?Q?XGFk=3D?=
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
	DXISXcASZD+oJliXhoG/2o4gwocvORHfeT5iYbY36Bjq4txVul2mcCcHVtnI6h5d58iT7plX1VpEi8q3S1p7/T5wKG4CrqsJRDJOc0lPVPzqfcZXwlA7pDOr5hfpT+9YMR8bOYX2qavf4hhfitfj1A/e7bGTANA/2TRMczPJ8qlwFseC5CZfKkttaEDQfaflvtUuMFi10IT+JVUibKLB2n7Pqh3gL23TMpEG/VH/9xWK5aryDvRRyM61KR5Hx+++5yedgFq4Lk/SBUMF/Tp/1SgQ00FFB7Gi9DeGVzj8lytCbgVayj9I2y9sSBNMUp2eGHPeW12UKwCzO+qdF2eBfoZN6WQqDDkPQiqfRs0wSjoBoj4q/jOUWhROeo40njPvcEFs7S/URzPdR4nsDLtDK+f8TrpqBZ15flCeRClahqL7T13NvSQ9lT7r2SSjC3JdnEn1ErcbWtnc/GYthlE/cEtXfhfL6s963KS7kaSmpO2c2sBQ2AseeviQOhBiBOBLueNvFTns7jNQJ8OUfL9MLUxD2hq5D3PUkpEdjuOvFjzJfQlTI3Dqw6ExKkPV29AH4ouLaLkJ1xyotTYAJaTAzJ9+OV65q04bFN3GKBbaru3jPVYLyYIRZ9HBGB2Vga+X
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3051c1a-d955-4890-cb78-08dc75bc1de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 15:23:19.5164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YuJHeNOJ9igHfyCGCDO9BAgV51O54mZ/fyQQmkgme53v/yXF4afoyjYDCorrRPxmAGOE13vY6N/+Laxf9Ba9CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7024

PiANCj4gT24gNS8xNS8yNCAyMzo1MSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gQWxsb3cgcGxh
dGZvcm0gdmVuZG9ycyB0byB0YWtlIHByZWNlZGVuY2UgaGF2aW5nIHRoZWlyIG93biBydHQNCj4g
PiBuZWdvdGlhdGlvbiBtZWNoYW5pc20uICBUaGlzIG1ha2VzIHNlbnNlIGJlY2F1c2UgdGhlIGhv
c3QgY29udHJvbGxlcidzDQo+ID4gbm9ydHQgY2hhcmFjdGVyaXN0aWMgbWF5IGRlZmVyIGFtb25n
IHZlbmRvcnMuDQo+IA0KPiBkZWZlciAtPiB2YXJ5Pw0KPiANCj4gPiArICAgICB2b2lkICAgICgq
cnR0X3NldCkoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggKmRlc2NfYnVmKTsNCj4gDQo+IFBsZWFz
ZSBjaGFuZ2UgInJ0dF9zZXQiIGludG8gInNldF9ydHQiIHN1Y2ggdGhhdCB0aGUgd29yZCBvcmRl
ciBtYXRjaGVzDQo+IHRoZSByZWd1bGFyIHdvcmQgb3JkZXIgaW4gdGhlIEVuZ2xpc2ggbGFuZ3Vh
Z2UuDQpEb25lLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQu
DQoNCg==
