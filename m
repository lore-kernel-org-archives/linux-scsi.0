Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021098.outbound.protection.outlook.com [52.101.100.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC001DB54C;
	Tue,  8 Jul 2025 01:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751938023; cv=fail; b=MPv8hu5t0/xQrJhTOo93DqG+jiVcA6YbLdWOBmixTyEAZwo1bmy1iWoK+AcZL2ZFtY65PgunA7gcabsk6H9GUW//9NRYFk3Dsmug9cPL+qGTTLvHdSr26lGZ3Q4hryCVtqLsy5OiABEnomE+hkVR0nVQj86/Hc5Z7gkDwlzi3Ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751938023; c=relaxed/simple;
	bh=qtFxUf9NcSs0LStHHFUYogatvz1j/DcWk2NuUaacwSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ek35BK79QBP283nuxZ58ErjJLO24IeKR/X8yv0qehKNDWwtXUZZQtW/O1bwaLcHZuM6nKobX+7b/zdbz7UhLaR0ih8cY1eVxT9Meq4G4MAR2RMDlfEbvX4fu2Qa+UwvYW4s1l9BgcFtF1tPkSz4VEKrz3y4DscilkDIMpy3Qbvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qEcVZ2tZrVT7l2yrPJlWfC5VWiOjhKjxm8aR7dQNXJID5VtibFUcsVY2+qAaNN7P7JRBvKS/ITWMqinb9bAj7qklGz8F20fXjsQv46l3Ds4bcPIQTTEkWUhh2RQapABn17t2zK50bhSXhG0PEi/DxHmSBP1NDdLd/OozWPD88OH4xBDPtQwdWw2Q1jlOFZZhAzUxSPzRGJkWzpgaABiyb3e2WimhNx9ao88yXRnDU7O61zxyrFJjYQlLNQj6n26RwEnUrlEScw4NGrVEUp3qyaM31ZhYe7TjBEw4CkS8KE1xDiOtEl56+AoMCVQIlcLdl23Vw8/4DXw7pmpyJh8qaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sO6KvCPELhCUTYs+JnW7/GVVMBNPwXGOn/7t1XanuVw=;
 b=TG8uL/T8a5KW010nUs9LwV2Pc6UpSF+pXEnRu4dlcXqt9hnk/S6jza8T6fEDsvLa8pOfXN/P61+jV/HHTI8fOdiZO3mYRCyifF+Q+ok+rA/wxEGRWxgutCW6klj1DNAbcXLGeMT8j9SZrvijgIjVpHAkXUNHJTf4CmnQ1eliHQNxo2wONodN7DtR3E3CDtF8aGow3QYnZOK38l+UVZzuZ4bYqzIgyudxBQEPpttAKZPU5/lm6jA92MFaIZuAGrM5YE5xbp15M2veh+xCgHSi96vgK6akPhpyUWShwzTl03mRwV8p1FL9gu2tsp209qSsAEMR72CH/Phyz7JouV1nUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB7362.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:220::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 8 Jul
 2025 01:26:59 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%4]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 01:26:59 +0000
Date: Mon, 7 Jul 2025 21:26:55 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin <costa.shul@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, 
	Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v7 10/10] docs: add io_queue flag to isolcpus
Message-ID: <em3ikin6peciadj2kup6btc5mshq5upo3lzggdumzdy5f3bvky@rbr3mtd2a7gc>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-10-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250702-isolcpus-io-queues-v7-10-557aa7eacce4@kernel.org>
X-ClientProxiedBy: BN9PR03CA0702.namprd03.prod.outlook.com
 (2603:10b6:408:ef::17) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB7362:EE_
X-MS-Office365-Filtering-Correlation-Id: 11096b8d-1603-4274-83bd-08ddbdbe8883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVlTSkgvK0dMZkRzS0lIcW1mOVFFeE5nZWsrcE44cGFDc24yWFNMUVhHc21x?=
 =?utf-8?B?NWtKVGU1RGpycktFS0VhTDRjeFpoUFBpL1d6anBFRU9BeVlLWHBLRGVzRzdz?=
 =?utf-8?B?dzJvcnFmOFFUZWd5MUxOWUdiZ3U5Zyt1T3pNTmNhRy9IQTV5SVU0d1F6MDVs?=
 =?utf-8?B?SHduNGgrRVYvTm1OVEszKzVnZFBIME9TN1FGa2lqNk9uSjRsYnJtLyt4TUhM?=
 =?utf-8?B?V2JXR01ZeG1sYWhsaSt2cU50ZVdqUC9JSXJub1E0WVNGN3RtR0xMQnIxa1JT?=
 =?utf-8?B?Q0ZtWmduRHp6YmlyUFdpUnVpb3pDYjEyTXJDcHFXRCtQZFNDdzFGL0t3amsx?=
 =?utf-8?B?MVlrb25Vc05WaW5QVXV6VllWS3pTRHlvWWxFbVl2QW5POGZyZlJQODhzYkxs?=
 =?utf-8?B?Z2hYWUxUVU0vaWc5SFBKWmE2aVpwZVJoWjFHdlVpZVptcnNwRWVOdTZxR0Nu?=
 =?utf-8?B?ZHpRQ3ZPWGlacTFMaVVWaHA5M0s0ekhWS2drdFpadU5ZejBGQ0swOVkya3di?=
 =?utf-8?B?dDRMRThoRGR6VzVzRmc1Wlh5dmo4VjViUzY3OVFnZjVFb1FhOXdKd2dBaEt0?=
 =?utf-8?B?NkZKMzVub2t6Q2VDbHoxd1U2NDNFMjdyVjJqWXdoZG5IMmxlWUt2R2RLcVRl?=
 =?utf-8?B?ZWhDTTU1OU1LT3BBbys5aWhSQmJ4YjhHOUljT2w0eE5iaUY3dnJTZ2MrK21X?=
 =?utf-8?B?WW5WSGdaK3M3V1BEcjl4bktPWUhIRS9sSi82S3Rha28wVG1xcGp1TFFkaEZC?=
 =?utf-8?B?RUk4UEpxRmJTNGdrbkQwUlNiRis2aS9DRFdPUCtYbnV3VjlxeEhNdFlONi9l?=
 =?utf-8?B?MXRsSmlHbWpDMHpjQjJiLzN2QXBwMDZhWVhHTU9kYThNRDYyZjNnWnJVSm9m?=
 =?utf-8?B?TzcrUllMbjZmdFZEYWJuMjhqSzNkblN0WUF6djBYc0pKRVd6eE00bEh5RlJw?=
 =?utf-8?B?ZHRzbmcrdTN1dzUzMEdRUXJvY0cxZG1CRSs5eXpSVU9FYzVqWTZIM0dsR2hi?=
 =?utf-8?B?VkFjY0pTWFczc1VFS0tHY0UvNlVqTFVuWFZ6OW1SdUFaaGdXdkhnanNxNFZl?=
 =?utf-8?B?MzU2MHkrSGtqL1kzRXJJUG1uQUM1RXF5R2J4SFhIeUh4QjNya0JUajQzTXRl?=
 =?utf-8?B?NE8xcVUyM1hHS2JXcWJZRm00Q2VrMDJpS0hTY0RLWFZCUTZaRWJBMUE1Lzli?=
 =?utf-8?B?cU9tblRIenkvcy9GdlZoYklTTFFMVzVSMWszbHlJNmtyNERtRi9pckNPTEkw?=
 =?utf-8?B?RE5tcHpDWW1zczkwamYvOE1VSlJsZVlTUEhaL1dLREg4K1dKQ2NDNUZNdmZx?=
 =?utf-8?B?dTJYS0NRcUh0Tm1PajdVNlRIVUhOT2dyN0dhZHJIU0E4RklMbTJkQlFOekc2?=
 =?utf-8?B?a3hyRFFLMGdJeUViYStmZFNlb04rdTZCSWdYaEtTUDkwbkhGK0tUanY0TkhW?=
 =?utf-8?B?QmhvZ283TmtuNGliMHFiWlVZeGJxUmloQVBkVFFBb0VOMXNkR0JPSjJGWEdv?=
 =?utf-8?B?bVI3bVRVTUxCNFg3VTFhbDdrVEx3SStuZURPMEFJcEdOOXBuYkFrTVRxRjgy?=
 =?utf-8?B?aEd0NzhmYjRQQmt3NHFSbHU2YktyYTdSNkJOZU1zTktaV0N5UnRPWlk3U2xL?=
 =?utf-8?B?ZWIxVkJFcEN2ZkoyZ3c1bHhLNWozUzlLR0ZKKytFb1JveEp0eFVSNTUyeUtv?=
 =?utf-8?B?ZEF4aVVzR25JOGlUUTIvcDVGT1BlRG5ueXJGR3hkTHdNUk9JN2pJNVRCTnh2?=
 =?utf-8?B?RnJUcHp1blFrQmJ5VUhKY3dZaTNoenRlUjl4WWhGTmd3NFpwemZLcTdJMWky?=
 =?utf-8?B?Um1nblhNN2hiN3o2dXo3SDhvWEZwZFhUV2RJNjFDVXlsVDBPcmptVjhzV2xz?=
 =?utf-8?B?SVN3UXdlVnlFc2wwNDhXdVQ3REJkN25nODZ0TkJvODd5KzdJRFVJNWVCY214?=
 =?utf-8?Q?AeNgHvMkXYU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NCtuLzJQQmw5Vlc4ZXBxeWd0NjRnekR1Nm1ON1F4TmNkdEZ3ZWFRby9PZmIw?=
 =?utf-8?B?WFFRZHlzSFlIVFJwTnVFK0VNVHhQU2tWZjdJN2RoOGJCK2NhUkl6elk0Tm83?=
 =?utf-8?B?dDVKSWkza2FEZlZldUZYOW5MYTVZSHEyNFNjRFk3SGpTYk5rSGYrRk9GbDZM?=
 =?utf-8?B?UjB3MWhHeUpGVXBnMTg4clpYR2hYeTlrUE12b3RXeDd3MVVvcEV6UENSR1Zs?=
 =?utf-8?B?TEdKUEpYYkhsVlhQUmFtYWxtS0JXN1doSXFKQld3QU9HRHNLUXNmU1NhT3Mr?=
 =?utf-8?B?dTlZTzB6eFFtZEZzaU9uajN3NkNqWnhmWjcwZTVMYWo2cHlkT2oxb09KVkEz?=
 =?utf-8?B?Mi96aE5HemJ4Nk5BSjdGNjJBejRSNnZ6Z3dnSmlqZ3pQR2QvVU56TTZ6RUNT?=
 =?utf-8?B?YUZ5ZTQ0elpIaVlVSkVXTnFUTUVmRk9TVTB1aVVhc29YalhtZHJyMStjUXBN?=
 =?utf-8?B?M2ZNM1VxUWU2NnlCaEF2V3ZhZnd6ZS9MWmN6QWdqazhKZEJXcWh2VnpSSDRr?=
 =?utf-8?B?TE1GdTI3M0g1bnVqcmxuMmRoTERURU11d2ZPQStFbkJ6K2dGdDBPN3I1UUhX?=
 =?utf-8?B?cWJtZnpVRDN1M0VzUFpvR2MwNXduaU1ZL3o2clNBcGxBYmN2Tkx1VEw5MExD?=
 =?utf-8?B?Qk9SY0R3TitpSEFOdFFuMlU2akNqdlNmcEQwaWF3bHo5S0JXdUU0NDN3dnBl?=
 =?utf-8?B?akR5OU9QUHpJVlR5TGFlUGlTL2tXc21XanVaS2czY0t3L3VCdkhvQlR6WVBu?=
 =?utf-8?B?M0dBU3I0Znp2NVllMUhhSkNlcitrc2ljbWFuU1hobWl2VVVFb3kycEJGaUR4?=
 =?utf-8?B?U3FzeGU2YTA1UVV1M0g2blZZek9Bd0toS3pZVVllS0VQMDkvdEt4VVNtL0VW?=
 =?utf-8?B?Qkd5SWZzNkk5L1hRMU1XTU1mMEhGUjlWTGZnL29QRlN2QU5ZakdKRENQWjVZ?=
 =?utf-8?B?eFVnNUZRQjJmWk1SZVlTN0NSRVptTldNUDgyUXFyUEtUb04yOVFXUnlzcHNm?=
 =?utf-8?B?blBvbXlqd3hNR3BpSGJWQ1ZlYm12d1RIbEVrOWxuVCs4SjdRRGcyWTFnaVFv?=
 =?utf-8?B?WTJuVDlVcG5TbDl2Y2VNa3FyWXpiZk9ZUW9TVDFJN2JEYjFpYWhlbXpubUtM?=
 =?utf-8?B?eG8wVU8rZFcxbUFPTlNObmdFT29LSVF5aGZhWHpTSTRlS3JEN2lqN3liOGgr?=
 =?utf-8?B?WitXNGhIMW8raW53MmpGTjlqYWFkejAzb3htbUZGa0MwVHFIOUtEeTBUNWtQ?=
 =?utf-8?B?SHJBTkdvbVY5cXJNZDNwS0ZMRkxVV3lLVUR6dGIvUUFwWGRmMnhnNDJKNWRZ?=
 =?utf-8?B?SUpWd3g0VTNCbEUxaURMZ1JMc2hYbmR2dUNJSkJIczdpTHFrNFhWMjVKZTVL?=
 =?utf-8?B?OXcxd1ZPekJ5RytNOEQxTm5xV0MvTGpyRHVKeXBGUUF4aW9oWXZtU0t1ZTRu?=
 =?utf-8?B?STJxL2lsMWJwQTlEcmZhTWJCYUNyejQ5UUx4aUtiRUxTRndpc3Q1Z1AyR3Ra?=
 =?utf-8?B?VlRob0dBRklYMlJZaERSdndzQkVaM2NTQXhWQk5KUHhBRUN3N1psQ2VaeXNT?=
 =?utf-8?B?Z05ZQW8rNWo4MGpkSXlCSHJoOHRRRTh0S1cwdTIybm5OTE83M0xERUFLZDRY?=
 =?utf-8?B?M1RRODRDSkdkZENHMEE4VXNhZmRCbVp5MnJoQXcxMVFxZFNMQ3BsK1hKdi9U?=
 =?utf-8?B?QUpWZXFRQS9vQUVtbjRMbGlTZXRyaHdiYjRGd1czVTBMdEdMS1hwWmlhMmpV?=
 =?utf-8?B?UzhpWkxIc1VvNytHcndacUxPWUFPbVFuWk56cVNDbXhkZ0hBakdIVmVGbUda?=
 =?utf-8?B?SWJYb0pEb3YvVThZeUZPRDNXMDdZbmxPbUp6TkFhb0s2eS9FbVdKVkZ1cFJO?=
 =?utf-8?B?S3JFTXgxN1ZnRmhBMCsvalVkYjUyckZBYTlFT29xRWdYTEJmdS9yQmlTYmxa?=
 =?utf-8?B?SHpsUitwY3ArQWM5ZENoSmZMb2ZOOHlCanFqbDdiMVl3MGVrbm5XeWZreFZi?=
 =?utf-8?B?RHVPejlrOC9seGZwSU0yaDNxTTdDdXYvUG92VnlqUWNmWHBLL3dMQUVBOUtp?=
 =?utf-8?B?ZmtESTc0eXhnd2t0OGZuRkMrdlZlY2d5Z205SjlrSUtKZ1N2cnNmMkw0Z0tI?=
 =?utf-8?Q?lOklqaz7Vvg7KdmAUVBt/UOWF?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11096b8d-1603-4274-83bd-08ddbdbe8883
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 01:26:59.0153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJJ5+whT23+we9e4/XSx15mkkMHNf2+cpqa6IdCRNhaLesPwcdGHQ3l/TVBsHcmgBqqhbMf0RGUaoogl+NdXKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB7362

On Wed, Jul 02, 2025 at 06:34:00PM +0200, Daniel Wagner wrote:
> The io_queue flag informs multiqueue device drivers where to place
> hardware queues. Document this new flag in the isolcpus
> command-line argument description.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index f1f2c0874da9ddfc95058c464fdf5dabaf0de713..7594ac5448575cc895ebf7af0fe051d42dc5e0e9 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2590,7 +2590,6 @@
>  			  "number of CPUs in system - 1".
>  
>  			managed_irq
> -
>  			  Isolate from being targeted by managed interrupts
>  			  which have an interrupt mask containing isolated
>  			  CPUs. The affinity of managed interrupts is
> @@ -2613,6 +2612,24 @@
>  			  housekeeping CPUs has no influence on those
>  			  queues.
>  
> +			io_queue
> +			  Isolate from I/O queue work caused by multiqueue
> +			  device drivers. Restrict the placement of
> +			  queues to housekeeping CPUs only, ensuring that
> +			  all I/O work is processed by a housekeeping CPU.
> +
> +			  Housekeeping CPUs that serve isolated CPUs
> +			  cannot be offlined.
> +
> +			  The io_queue configuration takes precedence over
> +			  managed_irq; thus, when io_queue is used,
> +			  managed_irq has no effect.
> +
> +			  Note: When an isolated CPU issues an I/O request,
> +			  it is forwarded to a housekeeping CPU. This will
> +			  trigger a software interrupt on the completion
> +			  path.
> +
>  			The format of <cpu-list> is described above.
>  
>  	iucv=		[HW,NET]
> 
> -- 
> 2.50.0
> 

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>

-- 
Aaron Tomlin
