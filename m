Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020081.outbound.protection.outlook.com [52.101.195.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B512BAF9;
	Tue,  8 Jul 2025 01:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751938310; cv=fail; b=dfrt43730AnD0tseaWQV+jzk1h9DFevUWszpKeoF2AEl+WYhwawa89kmP3ob+oyYxSfNpjpeKmgqCBIHWi/80EwRO2uMZLrSwp1lkdWy5inQKWc3YwWtMwBxNhGznqEzT91fQeVkTTXPPNrmpglOFrBslJa4FjWK/ZOACiv9cT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751938310; c=relaxed/simple;
	bh=v4/hmSlXkMOoNLwcz66bbiXrP6m+WQU+j1jqhdQivmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M+3tpKF+afJ/PixeMr7velQBu3BeA1cpY7eqhZy4j7LH+pKH51JAfYJxI4Xes6zY88P18U1fOINJuNAYOfvcksHSaOuorBwtwgz+5XssbjHBGhmTQhhwdEry6ul5DLTl9IgdVz1GhcYuT5DWl7f5yB2s/OJvicm/nb7/5m2MG6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xV+id6fWEuAAbvUUPkAIxHiVEMk41DyWrAucg5XAO9Ab73lqKVJS1Nesb3gdaM4y2las9AZe1qA7wAM9ZCf9wSx8hf7BPm/gYaK208/yARRBy7+wAjRKKZ2WejfVXmzt+jQyaTfgRcuP+yJotCbmkAXon5QpFzb2mju+supEYIo6KM6tURxRoXUqmYFrLN0mL636XhcmKH0b72hvBtVWaQ+MK9MQ5LBxapvcLiyc9XEwb2AJx4LWZ2qQYUqMyqam+InXZcXusdcZjLJSgyZS4TX8bKimT82tB2LVch4gPzkMjdckWs8sByGva0hZ1hvzsuDE7z6pkiZhCjcXnyPkog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYNZj6oXkBZDOQW+PabzG6DIhltUZWupu7joh/ZMpnc=;
 b=cceuQF/76fmDHDFKRLN0iJYE6/U/IjcvJi8jE/7nrsK1KnnDyDwglgJX3gwfGKHZNOldGATUbRJFLLcObLKm3t75ohSa6sadZ34WWwDe00fo5rvKrfy04QVq3TYglO6zl5mGlg0ey1AIQ7iC7JIbzvlwXgunfcxVLdI5v4uksj0EvepGpIrOGOHP9kvr9FiWArHcQBc1P7COtlsuOsL/1a0OP+3u1ZxyCRiPJlcbDz330nCfPZwG4HuXscdRiYL8WMsusRSHtMxLgbaq5THqtcXVOtx/WiqTSNr/Ohwko2vDhERXM6GWNBX/tNPpgXDbRkWfXBVdUEdZVQSmjpFZcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB5770.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1b5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 8 Jul
 2025 01:31:44 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%4]) with mapi id 15.20.8901.024; Tue, 8 Jul 2025
 01:31:44 +0000
Date: Mon, 7 Jul 2025 21:31:40 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Daniel Wagner <wagi@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin <costa.shul@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, 
	Waiman Long <llong@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v7 09/10] blk-mq: prevent offlining hk CPUs with
 associated online isolated CPUs
Message-ID: <w5rxrdtvk7n473stsjqhq4dvtdqearnsuu7yw63e6lhc5tzszg@dnrl22hyr7br>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-9-557aa7eacce4@kernel.org>
 <aGt63lJr2JY8VAqc@fedora>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGt63lJr2JY8VAqc@fedora>
X-ClientProxiedBy: BN9PR03CA0410.namprd03.prod.outlook.com
 (2603:10b6:408:111::25) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB5770:EE_
X-MS-Office365-Filtering-Correlation-Id: 3624b45d-a3c2-410b-66e0-08ddbdbf32a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3RSR0RpSUhoTXBQUC9kK2krYkJDVHA3UENPT1piZkxNN2FFNmtVbm5ZSHg5?=
 =?utf-8?B?ZlBmR2dveDF0VWtXV0llRERySU1VaW9NaDEvQ21QV2cySjFUeWRzNGNJTGtt?=
 =?utf-8?B?cUx1cTgzNDZTWXdzMVNrak8xQ3Q5b0RNa09IRDFlczBVc2dxK2Z4bGpnQmZh?=
 =?utf-8?B?V2JRaFFzdEpHQmt5Tklqc05oV0piMVoyNG5hMjgrQUdBaVdEZDdLRGgzT1c4?=
 =?utf-8?B?b0tXc0xmZDRLdkVBYURTQkVML25UUUlUWHk2L0lQbG9lbWFnQ0wzaE9PZXE3?=
 =?utf-8?B?UmdFNFZEcURHK2ZIUzJtOWpENDVQVWVESGE2VE83dWZ3YlVxSnJlM0pTQVVL?=
 =?utf-8?B?M2F0TnpMVnNwYXUvenZ3eG9NU05FdmFSYjdRZHhVdkFERlpsanZ5Z3dLTEFV?=
 =?utf-8?B?WjVKWHZjNXNrS3htUDZKSXBKWTR6TDdDQ0JLNVVTWXpxdGY3YjQ4MWlkSXZ2?=
 =?utf-8?B?MVVFQlBBYUFNNk1lZU9zRGNNQ0VEVHQ3Sk1JZkdiOVVtS0paQUQ3cklJdmNt?=
 =?utf-8?B?REpOREhmTXdEKzYwUzVqYmRmSTFReUFFUnVhcjVNUHZKMktiTXlWQW8yQjhq?=
 =?utf-8?B?SEpCVSswR1AxVlJSclpYc0R6ckdVcXJqQTRFK1hpdVRkNHl4cVVvYW1mdUxx?=
 =?utf-8?B?aFRPajh4VTcrYXJJNnl5N3FKT0ViZ1ZRajk0aXNHNTQ5K3FvWVhhWFRubStL?=
 =?utf-8?B?Unl0Mk9WckFqVEJnam9TWVVPZmowV2NqNlplTjJ1a09QTUg0eE5wS3FoUG13?=
 =?utf-8?B?clVHc1hIcThIOEFyV0pQRm1lZ0tsK21YZjRPQ2RybHFSakNoUU5oRGt4NVhi?=
 =?utf-8?B?ZXJLNzBvK0J5UE4xNS9JcjdiOXpFRkZYVzhMeEd0dHBwZVZUc1N3bEFUWGFH?=
 =?utf-8?B?bVgwZyt4ckplUUdVTVJUV2VnUmc3aHczU09EUk92Y042V3VTUmhuZzIyR1Z3?=
 =?utf-8?B?VmR1OGVQRkN0NytVOU9Gc0RzNDdpMWFJc0U1aTQ1TXNzZHhFYmx3TGRGQlRr?=
 =?utf-8?B?SktDT2FQZHJGUkgxZUtBeEJKYU1jdnViVkNiVnZWS2FvZDJpUGdwd1hDNzFQ?=
 =?utf-8?B?NjZjR2Y3d0E2OFp4UHBLKzIveHVRbm5qUVNsdGJUMDBmdkNqcFVlTjVzQmdU?=
 =?utf-8?B?cnVhaWtkVUV4V0Z1R28vemprcS9PWTI5cGtFS2p5RWNyNzh2S0JWeFVSMW5o?=
 =?utf-8?B?aXcwbWJRdk5JZ1RpMGZnZkdnbjM5WGpqOG1oU0ZTcG9DRnNWbXM1UDcvYkor?=
 =?utf-8?B?YTNTUDJNY1hSR0FvZ29xQSsyc21ZVGc4YXBQMlI4QXpZOXcvVkJPK2hxWHR1?=
 =?utf-8?B?VXZibzIwNkhWbkFLemxiMGNRR3FEME1NL1d2eFREVENKWXJhQUJSMVA4SmNC?=
 =?utf-8?B?bm94bXlzSkFzT1hQWVNDR1dDTUJWQ05BRnNBdDBEUk1TQzVoQmhuV0FWWlRT?=
 =?utf-8?B?Smw2Mmt2d1NrNE5PVFYxbnk4ZVFEd1dORGVDcGtnRUQ0U1BTaDM1Q2FQYmFl?=
 =?utf-8?B?bVBtc1E2d1l3U1h3ZVVPYkl2YlpyWmVxUDU3NjM0VDlQbkVYVDFQa2piVnI0?=
 =?utf-8?B?RXoyRlFlelBBMUROdFMzdXpXRFhiTUFUK3B5cnZrTkN0SzJPSHBPejMzZEQx?=
 =?utf-8?B?MUN4VG1sczhEc2NXSW1Uc1NHajd0d0hBWFlNQzVKUUFmcWFGSU1aV0lyYVJs?=
 =?utf-8?B?NTFtbjVtdHJMWW9ZQTc1WkNoa3pSRE0rNjQ4QUpvT0Z1V3NmZnpJVVJUSDZS?=
 =?utf-8?B?WFFQMkpodkYyai9wNlJRL1RXRjRLQUZlSEx0VmQwTjl6SkQ0UWhrazNFMW80?=
 =?utf-8?B?NThwaHpGOGFRRjB4REtsaFFIQlYwYlc2RDZmc1A0c1hUdDRlNHQ3eE16Q1kr?=
 =?utf-8?B?aUoybTBpY2VLMTV5ckd4WlpCc0J2eVhWcDBWYWFremtFZkF0VHRCcWdoVmNO?=
 =?utf-8?Q?LfiGgkdk57k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aW1ybkk3eW9BN0svNTcyeXVSbnVNUW1BNmJyUExXMkFGL0g4MHJoZTlNcmI1?=
 =?utf-8?B?cXhLSW5zMEpwK3BBcWtCVzZ2UjBvSkg3d3lOYkREYjRJbkttQ0VJdWhVV0Uz?=
 =?utf-8?B?MDBleUJLT0FFOEI2cW1NVTY2RitlVEpZYUYrbHpMNHE3TENnMkpNN1E5VjZr?=
 =?utf-8?B?b1BGNDdXV05ncmJ2N2NJMFcrQ0VPV2EvRXk4U3ZEUGRyVDZoRzlQODduNjdm?=
 =?utf-8?B?VDl4dXlRZ0oycEI1eGgxODdlQTJFaXRuR09sajVhSmVsaHBMdjQrdUsvUEVa?=
 =?utf-8?B?TjBUVTE2cjFhbGxSMkcvczRwMmdOejdZb1RlbXYzaXd4bFEzRGhJano5djBP?=
 =?utf-8?B?alFobjc3bTNFZ1FpcndXZ2pEc0tueGtXVFZvU0lKQWE2ZVdGU2ZMc0JVbXo4?=
 =?utf-8?B?cmJHM0hDNzgvemZUMkNpVVdKVU1DUVFNQWV6ZEZYNllIckFVLzBRRDljaS9j?=
 =?utf-8?B?Smo2VnVIZ3ZsU3czUWpkTnA2dEpReU5qREtmcUp3KzcrSmo1Zmtzelp6SkVp?=
 =?utf-8?B?UHZHOTNLbS9ZUGluSzNTN0dIS0xnOVdWeE9ra3Y4OFNacFFLRkdhbXdsN3I4?=
 =?utf-8?B?Slk3a3BqYnN0NXJFQ1FESlViK29OUE52Uk15aS96VHlDeGgvNEYwSzdQYmQw?=
 =?utf-8?B?SXZ5VFJOU29wQ2U1WTRrdXNjVWdDRE8zMm5wWCt0b1k4Mk1zRDUxMlVDSFB1?=
 =?utf-8?B?M1hGWm1LejJydTBGeTAxOVpTT2VPT1hENmJ4YXEvenJiZGdkZDIyWWVKSDdC?=
 =?utf-8?B?NXJHSm5pTjl3R0RaTlhIWlEvenJybXU0QkQ4dkZ0Uld1V1lxVGs2UWFQbkN3?=
 =?utf-8?B?RThmVnM1bHo3dWwzUGFYR0lqY3habHFLNDU2aDUrb0hwdXlsS0FwK2pNa0sx?=
 =?utf-8?B?Tk55YTBnT1c2ZUpZVUU1UzNhWDhxNDF2UWxrV2pIWURBSythTG1oOE9wS1JI?=
 =?utf-8?B?RXh3YmtDaHhlbDJMSllLRnFOSllEaTJxSzlFNTRvcEhYRUJqd1JnZURwSFNx?=
 =?utf-8?B?NnlIWWozV0s0TXlkTXNxY1FMdTVkTUpOUHFWdk85bnV4dzhGSXpTOVRENmwr?=
 =?utf-8?B?WjJOVnZqV1dJWHMxa1ExSGxoZHVrZ0VtYVlyRFdLU1NPamY4NjVtaDU2SmxY?=
 =?utf-8?B?cEpMcTBObXE0bGg2alovOFRvVDNORnpuR25yaFdSS21iVW1VVDRCaHAvMm1M?=
 =?utf-8?B?NTl3azVHUFYxbHlhMVA1REFCVFRlakZ3akYzWk81RWFXd2I0eWxja0VEV2g0?=
 =?utf-8?B?Z3krYytobklZUUlRN0hUbUM0Y2NLTVBRL3pxYzhRazNXNTVRNC9zdFNRclA4?=
 =?utf-8?B?b3EvbTM0L3NvVU5tT2VjYiswdXRHV0hOLzcwOC9YTC84L21BRlBWRUhQNjR2?=
 =?utf-8?B?djUyUERrT1YvcGRhLzA0Z3lkTlFpYytDR2prLzRFelNjQzZUSmRNUXFSVWFk?=
 =?utf-8?B?VGF4aHJLWkw3c2hNa0tWODhiT0FBZ3YyeWlPSzR0ZkNtNXBBOElLb1NFc2lN?=
 =?utf-8?B?Vml2Wlh6RFdmeDhENzRQWFhVZkxZdmhZdENvNFJENDVXRFRMVHNRb3YwR2dY?=
 =?utf-8?B?bTFNTUN0TDJUamZ6Q29lQk5HWlNXQVNJTjZReU1oTGFIc0hFNGNoaDdpaGJq?=
 =?utf-8?B?dnVyZXlTdmhhajFmWVVCWS9JUDVGSFdoVkhaU1J3emV4Mk0zcmFPZXhFZG01?=
 =?utf-8?B?WlYzVWRqb2VvUzQ2UHdKcmdUNUVwVlJiL05JcUZESUh3bWlteDhSeTE4SUpJ?=
 =?utf-8?B?N013M2tmVEJYRHFjdU9zR3djS1lEb3R3Q2QyTXBZdk1zTDZNUzl5cHlISkxO?=
 =?utf-8?B?dk43VkVOdlZsZnIrNE9jVko1MnR0a1M1QXBacWVGM2IrYkdzR091ZlVGNFY1?=
 =?utf-8?B?b2NFeHZVYnM4ZTdDREZ1ZWhBVVlQdFkyQkZRcCtBbTVYbVFoLzU0VXlkWEU5?=
 =?utf-8?B?TWhrQmQvVld2S0pka3Z2YlBrcm5hQU5BNkNNVnE4RWRlRDk1WnBXeVNhNklC?=
 =?utf-8?B?NFZnSnczRTBqSW1sVUl6cFhyZnhuQlBSWTkrN29DK1o1VVFhV2lHbkVQMWNr?=
 =?utf-8?B?UXVZMGxoYXNvZllLVGNkdlN2cTh2VUtWNFlyUk5PRUsyeDJZRXFvR3VlenlS?=
 =?utf-8?Q?6ixbd8RMauoU/F6rkqsJU85+g?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3624b45d-a3c2-410b-66e0-08ddbdbf32a3
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 01:31:44.4458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zBH+nTIXPSbaa3l7/Sc7KxRoG+flJC6z26mRNf5PkecmA+8HNqPDzMJoxeIbJU7WGx51H8PhcQBlokJSU+R26g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB5770

On Mon, Jul 07, 2025 at 03:44:30PM +0800, Ming Lei wrote:
> On Wed, Jul 02, 2025 at 06:33:59PM +0200, Daniel Wagner wrote:
> > When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
> > given hctx goes offline, there would be no CPU left to handle I/O. To
> > prevent I/O stalls, prevent offlining housekeeping CPUs that are still
> > serving isolated CPUs.
> > 
> > When isolcpus=io_queue is enabled and the last housekeeping CPU
> > for a given hctx goes offline, no CPU would be left to handle I/O.
> > To prevent I/O stalls, disallow offlining housekeeping CPUs that are
> > still serving isolated CPUs.
> 
> If you do so, cpu offline is failed, and this change is user visible, please
> document the cpu offline failure limit on Documentation/admin-guide/kernel-parameters.txt.
> in the next patch.
> 
> Thanks,
> Ming

+1

-- 
Aaron Tomlin
