Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2F1190685;
	Wed, 25 Jun 2025 04:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750826139; cv=fail; b=OyH9lY6H4XJQ7ENI8UyYj3qcP1l7ME8Mex/WOBrkuHszthcDqcBTbblRvwA/g7ab6qZn028e2jUt98VmvMcS/x1IAGxfqB6Nqo49BHe37ntvxdsN9irlNsvlA4XVcfiokb0hQbMXeFNBmIm5tfOOQOsCNx4epjii/rrdAo0IN4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750826139; c=relaxed/simple;
	bh=+Fz+RkKr7m72AsBfNOFZfkl/y8Rmyymx2TRDkFvgp90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QQ0W3o89vINI3OWQzdqi1248YN0lxTztOm+WKTgiHcSv+cFEZgKtPLmUBVMsoi4zQdOQzr6W18grSh7gtV8H7VjBNFnQaWjA1M1wSIVAHuo0sodhrn3rB76415oaJjYUcWh03vMry3JjMAKWTLIirlxfQ/w1vRUwvCe/88PNmrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tcmx6SFP; arc=fail smtp.client-ip=40.107.92.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tcmx6SFP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gFQcJ9TaSF2s2hvu8XLI4S8dsF79us56ufKXUllf1rUCXBwAtLc7gfUel94yHKNMdW5i3jRzyy3UCNJ+JN2KK7rV6JIH9iNc93hl8gM77QZE4PAw8xIcxhRITjDV1/bb/tWQD4u+Hw66kS6V+kOiQuzD8lDwbsUI9lRiRFlX1V8lODkOkt48SINeJWz2fZd3gc3Eknj17vKe2ySsb0YnScaou/7ijMpi+L7WDZgvkmRQCyxMyWjmntiZ41MfEceSSmCH4R1HD0BkW5/0DZ/rc5Jmv1zpyItMjClb/vAlSj97CHzkIPTu9trjks/p1aD03UWr7Ikd4n7M+QBGxfChiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Fz+RkKr7m72AsBfNOFZfkl/y8Rmyymx2TRDkFvgp90=;
 b=R0GXp4pv5HDkPvqW6l7syOZc4s+fcNOq2o4NFLwo0NBg4ye3CB2A1hDvstnwMhPtWvA5CbKb5eXlwkB4FVVa8vDjJY44Mtpn2jngy65nxYgScwArAOF8aTpbPYXEQ+l9ne4/N8CVcKKCKjvNJSpfV/QEV5rYmVLCgo4MeeCTB+/tg1n9YgkrGFCPPpG/mj+E5u0obxDjiXK8YnPTLcKJf7AnYQmMqsi/Ab4UM/klbTVQ1wPH0SXrvu+4/W1vSYdzCFOgVXVcWuRwFCXhqQ5Qi1OxXbaBHcLKI3ILbqtY1GDT8NsFt5KVfzFoVIxctXoWzbaZffk6e1OVJLLMMAz8Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Fz+RkKr7m72AsBfNOFZfkl/y8Rmyymx2TRDkFvgp90=;
 b=Tcmx6SFP0nFtvzBP3bVrA417HiF8wC8MwvA2HKy82JMXAs0M16RLxfMoTo2ya7BplAVSDVzDeJQHmCEDtQ80s/IoJTaLkU2aPRoBdifcEmneL6glT1WKKlu4Wg1lMEvaoy62553qN+a1E0AGMB9wyUc2VH8AAPpt0xsNpwq0cHy4uIzfVry6fdLU5Z1aB4NVpLFOoS701intg4esKg3C7FBQ9ADxk7IYBmrWkya59g8B+PTbU3XS3vpPFCqU2XoFECeizZ6+RshM5EIqEtPAAxDR+3P6I3TkwcBsKbChF5BiDGRMnGJKbJnYQysFkHKO4KEu28cfw9xGn/Goer43DA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB7743.namprd12.prod.outlook.com (2603:10b6:8:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 04:35:32 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%3]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 04:35:32 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph
 Hellwig <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	"Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, Costa
 Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
	Hannes Reinecke <hare@suse.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "megaraidlinux.pdl@broadcom.com"
	<megaraidlinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "storagedev@microchip.com"
	<storagedev@microchip.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 2/5] blk-mq: add number of queue calc helper
Thread-Topic: [PATCH 2/5] blk-mq: add number of queue calc helper
Thread-Index: AQHb3434ZhTTZMD5j0Gc98fgnxTq5rQTVg6A
Date: Wed, 25 Jun 2025 04:35:32 +0000
Message-ID: <70f8d51e-5900-4b15-ab1b-b69aa0438d25@nvidia.com>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
 <20250617-isolcpus-queue-counters-v1-2-13923686b54b@kernel.org>
In-Reply-To: <20250617-isolcpus-queue-counters-v1-2-13923686b54b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB7743:EE_
x-ms-office365-filtering-correlation-id: 1d70b35a-0d13-4fac-4fa3-08ddb3a1b87c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SGl4a3UvbEhGVlVSamlPTDRLemVETDk2Q2JsTERtWkNhdkluRlUzWk5YbXFD?=
 =?utf-8?B?UEQ3bW5aT1RmMTlCYWROMWZsbHdqeEFUWkhDUGYwV2NKeDVZZCtpWC8yY1dQ?=
 =?utf-8?B?MHhveE82MUFOR3diRzNQR2o1SVlrcTM5aGtGNEtCV3Nyd1cxdzFualEvZkZz?=
 =?utf-8?B?SDMrZGgzQzNPajYzRzZXcHc1dlRSOXFCZFI1b2oyMHBhcW53VWg3QlZLb0pw?=
 =?utf-8?B?TG5BeFFpUUZBdk1tSURVcWNXVEtNdlEwOWR2S1k3ZUVORlNmeFZpWVpvNEdN?=
 =?utf-8?B?YlhOV3JrczNNTDQwejBFRGhCZXdtdEJDa1JyUWMzYW9uMTMwUzljQ29PNG84?=
 =?utf-8?B?TklmNkYySFgvaFhZZCtwWlhlclVIS01PK1FDT2RvakZMdENaNGQzVU02UzBn?=
 =?utf-8?B?T0RqQkwyWCs4NnNUQ1h2QTIwSGhnSjBnSVh2NnZFZ2hhUktTUlRsMVo0RTJh?=
 =?utf-8?B?S0FtZHoxa1RPU2ZOd2wraXdJRWVwQS9XTWs0RTNUQ2NVVlZCSy9hbVlkajlL?=
 =?utf-8?B?aEZMY3F3SnRmdnZ0enhoVExMUVpHY3N0M21oYWZQTDBFZFplOFBHeFFueXph?=
 =?utf-8?B?anZMQjJIT1Q5UEk4alVjQ3ZWUUNuUVB1OHpEeUtlbW9ESzYxOUdQUzQ0YzBQ?=
 =?utf-8?B?dGFCVmNOcld6QkxvVG9YSXZVU2pmQXUxcjRtSUljeHpXd2RoODNrWFZUeXhI?=
 =?utf-8?B?NEc1cDFtNnV4ekQzVEROUzZoTFFEQUE1cVcxZC9yR0lKYXlzU2lzZVBSems4?=
 =?utf-8?B?UFp1SVhNK2JRM0NpYTVMOWpTb1ZvUFo2cjVqN2d1VkZSaHlKVlF3MlZ5T0Y4?=
 =?utf-8?B?SGFiV2pKSGxzOG5IT0NGVm1iZ1hsYkd0QzdadHIwclpYRmdNR3hpNTdFd3p4?=
 =?utf-8?B?c0s3eTB2QlFTUXVBbTRDbHFkM1phcWpaU2dEUWhNNWRaZW5kY1NpaXZiQ2NE?=
 =?utf-8?B?T0N4UjIvVUh1ZjJUYktSdW1HbDgvcEM1VHNWL2d3QVJnM3NyeFRBR1lpM1Fk?=
 =?utf-8?B?Tm56YVhsbXJYUEh2VzlJc2hTWWh3c1Q4bCtzNnJ0MVV6UlJRNG55ZGo1eHBQ?=
 =?utf-8?B?YmhmL0VIclVLeDFSMTVlSWQxc0pnZVRhcWhCaE00NmUweFpwRmVHY1M3a0Zi?=
 =?utf-8?B?M21LK1BsKzZtR0UwbUlhT3VWMGlLd2dwUnlDckM4R3d4ZGF6NWhiaE1MbGZL?=
 =?utf-8?B?cHEwZ2ZSeENDVHBodi94RmE2RE96c3E4bSswYW94ZU9kUDMrWEhMSWxyMFZJ?=
 =?utf-8?B?Rnk4WlN1MVdDSkl6UTliODh6Qk5HSEMyS29lYUd4em1MU3V1aStXUHVLNE5C?=
 =?utf-8?B?TG5zcEpWN1JhQ1hrbDBvRVhqRFFKb21ha3FQSTl6RTZkVjN3TUltdjNBRU1V?=
 =?utf-8?B?VHJGekZnYWlhSEE4ckE4VnZoOXcwWlExUHc1TUMxcEdtdnZyT0lzdXdoaytL?=
 =?utf-8?B?ZGl3Um9pUE83MEdoK0V0RkRxSkNRNWU0NVBEM2ZIYVRIYTR5T1ladkQ1M3Zt?=
 =?utf-8?B?QlB3OXF6Z1pkckh5L1ovNTMzRTZCTW1xVVE0L3ZGSXBxMlpNQXVRaDQrY3Rm?=
 =?utf-8?B?S1hCV0YyN3VxNjJOTURScFNuS0FacWFlOExEU09oZkdTbUZHVWVGcGNiOGls?=
 =?utf-8?B?NVN2dEtyeUNGQlc1UWpxSm9aSmxrYy9iVnk1MUZBUnlUNFVYQ0oyb0VEdG1r?=
 =?utf-8?B?S1huUEtZTXFZQ1dxQks3bGpDUkZjRFZNSHd3NHJwNnR1UDB4STJlU0hQMWpp?=
 =?utf-8?B?SE0yZUMrRXg5SGlyRHdEeUVsQU9wVDZCbGpYOVdDZWcwNTlnN2VyMHprRmdj?=
 =?utf-8?B?OUt6NkNpSzNVK2dWQmZKWGg3dnV1dU9PRm5TQkd0U1BjZDYrbm9qMmZiMnZk?=
 =?utf-8?B?UmUxNHI1bWRRVUNkb0tGTjVRY2VIRkxpNVRVOGZEOGFWUmlXK3d1OFNJYkZL?=
 =?utf-8?B?Um0vdHhpaENQVHNldUp0STJvSjBXaW5mQWVSSWxPemwxTmxTVGowdEVlUCtJ?=
 =?utf-8?B?dnhSRmFRQUFnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dmx5L0YxaE1aSXNCaUZqVGFpTHRGVjRwR3V5c1BSem9rTnprMWZUbnFrcGlQ?=
 =?utf-8?B?ZmFDR3p2UEcxWUdaaTNQcmpFUGg2MjY5UEU2QTdYZWp6VzR4ZTR2YVN1ZVIv?=
 =?utf-8?B?S3crT09zdEFBenlmRVZ2VlVTeEcwK2NsMkhqd0grR3ZZYWVhZ0ZFaVNDb3h0?=
 =?utf-8?B?YUlRd21BQ05lY05BalhVQXE4U1ZGb0w5ZVpMMkdvOExCY1JqdjNad1UwQVhu?=
 =?utf-8?B?OE1uZVRNTzZ6V1F3YzYyM1V4c0FpZGgzZlFpMXZxbWhySmFqYUxEMkVLTk04?=
 =?utf-8?B?Mlhxc3VoeXR3aGhTTG9HRlhHTytyYVZOMVo2NmpGNW1GMUEzNVc0ZGhZcDZ4?=
 =?utf-8?B?aEFSU1AzTUZnWU9DeXFrdjZDSXZDY3RQeDR6akN0dlRScFluZWJabVFjQUhk?=
 =?utf-8?B?SWJickgzZ29zUy9mVXJ3TEdrYUh4M2JSNEh3MHB3QVlDRlRrdnM2c3F4OWtM?=
 =?utf-8?B?dmU0TEsvejlWcDh5TmZMUUZIenNrandad3ltbWl4U2lNZ3JyNTJxRmVIbnFZ?=
 =?utf-8?B?VWwxL3pKbng4ckQ4NkF1ZU5yWHZ1dVRSU1p1UFprcG9ZR2wxMURvQnhLOVM4?=
 =?utf-8?B?aUIxWEluMGt5a1ZvWW5YMVdqOXNEVU9Ya3dLM1FmU1RPQjBWdG5oaVdvZUk2?=
 =?utf-8?B?RTJoRmlORm5jMVozbWxKRVBUaWhTd0pPc3R2a2dCLzVuUjdLeUpJNWtaRE5P?=
 =?utf-8?B?N3BPRVFFWFZPMWIvRU5GbEhudXVpb3hFZVYwc0JIZ0dKbGQvUDVDVEJPRmZO?=
 =?utf-8?B?a00wTFdSQmtOa2dYbUJJWXJmenNKbnp0K1BLVWo5OXFNWkI5bUxLcEk2WTNK?=
 =?utf-8?B?eW9YZU5GRWFZakxOVElGZWZtWTM2VUsvL3hobG81TS9TaWd5czBGWXFia1h1?=
 =?utf-8?B?WjkwT1ROakE1NjkzL09mQVU2S0tNWmNtMzc4ODFBaEFtUldYNHBEMDVlTmNE?=
 =?utf-8?B?TUhhN20zdXFsZEZIbFpKRFVtT1FOMnozcjJEaElGRjkwREVUZnc2KzdFbEVH?=
 =?utf-8?B?MnNtemRycjlyYk1VdkRCNGd6alZpSUFveXhnc0tFYk9xVkg1MGVNZlNxQmxw?=
 =?utf-8?B?N0VpNkVGT3pKU3dBZk1LSGJpZTZOWFZnOGc1NW5wZDdVS1Q5UjROZEYyRnZ4?=
 =?utf-8?B?bnZ1WGNSakVBdnVudFBEcG03b3ZXMTUwc3NNVzRGdW4zd0dGMVRzWjl2L0R5?=
 =?utf-8?B?em8wblhPa0xjZE01Uk9NZGZNRWVyQ3hERzNuTXpSOGpPMlVCM05LU3NsUUZR?=
 =?utf-8?B?akduemEvcDYybTFXZmRMc0RGWUU0TlZ0U0Zha3BjV2V4ZVR5Wmp0NkNUOHZx?=
 =?utf-8?B?dU0rcTl2eEdXSDgzUURHNEptN2x5aXpjSnRTdEduelc5VTZXdm80WW9ZWUVq?=
 =?utf-8?B?bGZwSDNoZDN4T08yZXRna2VJKzhNa055WEdYZThhZ0tiNEdqNmY3NXljY255?=
 =?utf-8?B?ZXVCRVpvSnoxU0NZRGREeVk4TFU3cnBRTThQVHpnMWlLSmVKbzhpK1pCd2RM?=
 =?utf-8?B?T2p0QWtsN1duNTJSdnM2M05OL294Z3NCTSttR1hucGJXMzBQanh1RVhoRWJZ?=
 =?utf-8?B?Ylg2Y1Nia1F2QU1RTHBjMUovSnQ5VTEwdGJIb0tVRm81UGJLM1JmVHdtTEw3?=
 =?utf-8?B?WWFzNi9tMXF3QnJzcVNtTkExL1BMa3pUNEZISmFtQitNbDlVOGM3SXV3SHQ0?=
 =?utf-8?B?azc4K0hvWnBTYlVQOUF4WHJOdGNkVVBRRzFrbmJ4OS9OaEN3YVdYaCtWZUJX?=
 =?utf-8?B?b2tLaU9xRVNjRmFRREQrU2JmK3JQbkFqbmV6cU4yczNXdHJiOVJ3S0tqN3o0?=
 =?utf-8?B?clY2MjQ1V1hyMUFDL1RxdkxheCtzYjNMRkJZNFl2d1NqWUJlK29oRVZLci9J?=
 =?utf-8?B?cDlNL3BIWFJKd0FwUE1PajRIQ2lyY0JRQ1dBeldDOVNwUmZZZzdFeUZCcEh2?=
 =?utf-8?B?SWcwU3gzWElQcUlFeWViWHJLUjhRVjVpMUxRSlhWd0l4TTZtNnhUNWlrdE5t?=
 =?utf-8?B?dEtlTmNjcDZlS2E4d2FFZ2JEV0tvai83VHcwZ0pMUzJacTRxZFl3NjBvTEMy?=
 =?utf-8?B?QWVtZEE5Z0pqa3U2TEFtRC81bDFrMnIxNS8vT09Wcko1YUtkK3NiL1VUM3BW?=
 =?utf-8?B?cDlHOTVHdy9SbVFtWUo5UTNETkFCd1JlcERXWW9aOVY1clJrM1gzZXJYTnhr?=
 =?utf-8?Q?bJBl/5LAxpKXym0NuMd5J5jhkaFaB8eS/RgVF5Yx94IF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FDA34434FE8E349B25A3A6126AA87B4@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d70b35a-0d13-4fac-4fa3-08ddb3a1b87c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 04:35:32.2389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oUcGklEXcd8pzcysTWB02VEJW/D+B49OZcgiaQzJ3ybp3Sl25xlSMigdwaVrfU3hU2bHtn8MOrPBqltA8qR/bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

T24gNi8xNy8yNSAwNjo0MywgRGFuaWVsIFdhZ25lciB3cm90ZToNCj4gQWRkIHR3byB2YXJpYW50
cyBvZiBoZWxwZXIgZnVuY3Rpb25zIHRoYXQgY2FsY3VsYXRlIHRoZSBjb3JyZWN0IG51bWJlcg0K
PiBvZiBxdWV1ZXMgdG8gdXNlLiBUd28gdmFyaWFudHMgYXJlIG5lZWRlZCBiZWNhdXNlIHNvbWUg
ZHJpdmVycyBiYXNlDQo+IHRoZWlyIG1heGltdW0gbnVtYmVyIG9mIHF1ZXVlcyBvbiB0aGUgcG9z
c2libGUgQ1BVIG1hc2ssIHdoaWxlIG90aGVycw0KPiB1c2UgdGhlIG9ubGluZSBDUFUgbWFzay4N
Cj4NCj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnPGhjaEBsc3QuZGU+DQo+IFJldmll
d2VkLWJ5OiBIYW5uZXMgUmVpbmVja2U8aGFyZUBzdXNlLmRlPg0KPiBSZXZpZXdlZC1ieTogTWlu
ZyBMZWk8bWluZy5sZWlAcmVkaGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFuaWVsIFdhZ25l
cjx3YWdpQGtlcm5lbC5vcmc+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFu
eWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg==
